{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPRPTF;

interface

uses
  {$IFDEF Linux}
  QGraphics, Qt, Types,
  {$ELSE}
  WinTypes, WinProcs, Graphics,
  {$ENDIF}
  Classes, SysUtils, RPDefine, RPBase;

  procedure RTFToRPTF(var RTFBuffer;
                          RTFLength: longint;
                          RPTFStream: TStream);
  procedure RTFStreamToRPTF(RTFStream: TStream;
                            RPTFStream: TStream);
  procedure ParseRPTF(    InStr: string;
                      var Pos: longint;
                      var TextStr: string;
                      var RPTFStr: string);
  procedure ProcessRPTF(BaseReport: TBaseReport;
                        RPTFStr: string);
  function NextPiece(    BaseReport: TBaseReport;
                         InStr: string;
                     var Pos: longint): string;
  function UnformatStr(RPTFStr: string): string;
  function UnformatLen(RPTFStr: string): longint;
  function UnformatLenC(RPTFStr: PChar;
                        Length: longint): longint;

  function GetBaseRPTFState: TFormatState;
  procedure ApplyRPTFToState(var State: TFormatState;
                                 RPTFStr: string);
  function StateToRPTF(State: TFormatState): string;
  function SimpleTextWidth(BaseReport: TBaseReport;
                           Value: string;
                           InitPos: longint): longint;
  function RPTFTextWidth(BaseReport: TBaseReport;
                         Text: string): longint;
  function RPTFTextHeight(BaseReport: TBaseReport;
                          Text: string): double;
  function GetJustify(RPTFStr: string;
                      Justify: TPrintJustify): TPrintJustify;

implementation

{$IFDEF Linux}
uses
  MiscKylix;
{$ENDIF}

  procedure GetNextRPTFCommand(    RPTFStr: string;
                               var Pos: longint;
                               var Command: char;
                               var Param: string);

  begin { GetNextRPTFCommand }
    if Pos = 0 then
    begin
      Pos := 1;
    end; { if }
    repeat
    { Find beginning of next RPTF command }
      while (Pos <= Length(RPTFStr)) and
            not (RPTFStr[Pos] in [RPTFPrefix,RPTFInfix]) do
      begin
        Inc(Pos);
      end; { while }

      //PR 21/07/03 Changed from <= to < to avoid rangecheck error
      if Pos < Length(RPTFStr) then
      begin
      { Skip over framing character }
        Inc(Pos);

      { Read command }
        Command := RPTFStr[Pos];
        Inc(Pos);

      { Read parameter(s) }
        Param := '';
       {TG 19/07/2017 ABSEXCH-14461-"Is not a Valid Integer Value" error
        message when running Job Costing Actual Analysis Report
       {Changed from <= to < to avoid rangecheck error occuring due to the
        incorrect calculation of Param creating conflicts in ProcessRPTF method}

        //PR: 15/08/2017 Removed ABSEXCH-14461 change and made change in TJCActualReport.PrintReportLine
        //(RepJCA1U.pas) to pass in Pay-In Ref text only and not #1 prefix
        while Pos <= Length(RPTFStr) do
        begin
          case RPTFStr[Pos] of
            RPTFInfix: Break;
            RPTFSeparator: begin end; {!!! Start next parameter }
            RPTFSuffix: Break;
          else Param := Param + RPTFStr[Pos];
          end; { case }
          Inc(Pos);
        end; { while }
      end
      else
      begin
        Command := RPTFIgnore;
        //PR 21/07/03 Added to avoid infinite loop with above change
        Inc(Pos);
      end; { if }
    until (Pos > Length(RPTFStr)) or (RPTFStr[Pos] in [RPTFInfix,RPTFSuffix]);
  end;  { GetNextRPTFCommand }

{ Parse the formatted string InStr and return the next piece of unformatted text
  in TextStr and the RPTF formatting string in RPTFStr }

  procedure ParseRPTF(    InStr: string;
                      var Pos: longint;
                      var TextStr: string;
                      var RPTFStr: string);

  var
    Ch: char;

  begin { ParseRPTF }
    TextStr := '';
    RPTFStr := '';
    While Pos <= Length(InStr) do begin
      If InStr[Pos] = RPTFPrefix then begin
        If TextStr <> '' then begin { Return with current string pieces }
          Exit;
        end else begin { Build RPTFStr }
          Repeat
            Ch := InStr[Pos];
            RPTFStr := RPTFStr + Ch;
            Inc(Pos);
          until (Pos > Length(InStr)) or (Ch = RPTFSuffix);
        end; { else }
      end else begin
        TextStr := TextStr + InStr[Pos];
        Inc(Pos);
      end; { else }
    end; { while }
  end;  { ParseRPTF }

  procedure ProcessRPTF(BaseReport: TBaseReport;
                        RPTFStr: string);

  var
    Command: char;
    Param: string;
    Pos: longint;
    Font: TSaveFont;

  begin { ProcessRPTF }
  { Process through commands }
    Pos := 0;
    Font := BaseReport.GetBaseFont;
    Repeat
      GetNextRPTFCommand(RPTFStr,Pos,Command,Param);

    { Process Command/Param combination }
      Case Command of
        RPTFIgnore: begin end;
        RPTFBold: Font.Bold := (Param = RPTFOn);
        RPTFItalic: Font.Italic := (Param = RPTFOn);
        RPTFUnderline: Font.Underline := (Param = RPTFOn);
        RPTFStrikeout: Font.Strikeout := (Param = RPTFOn);

        RPTFSuperscript: Font.Superscript := (Param = RPTFOn);
        RPTFSubscript: Font.Subscript := (Param = RPTFOn);

        RPTFName: Font.Name := Param;
        RPTFSize: begin
          Font.Size := StrToFloat(Param);
          Font.Height := Font.Size / 72.0;
        end;
        RPTFColor: Font.Color := StrToInt(Param);
        RPTFPitch: begin
          Case Param[1] of
            'D': Font.Pitch := fpDefault;
            'F': Font.Pitch := fpFixed;
            'V': Font.Pitch := fpVariable;
          end; { case }
        end;
        RPTFResetParagraph: begin
          Font.Name := 'Arial';
          Font.Size := 12;
          Font.Height := 12.0 / 72.0;
          Font.Bold := false;
          Font.Underline := false;
          Font.Italic := false;
          Font.Strikeout := false;
          Font.Color := clBlack;
          Font.Pitch := fpDefault;
          {$IFDEF Linux}
          Font.CharSet := Ord(fcsAnyCharSet);
          {$ELSE}
          Font.Charset := DEFAULT_CHARSET;
          {$ENDIF}
          Font.Superscript := false;
          Font.Subscript := false;
          Font.Rotation := 0;
          Font.Width := 0.0;
          Font.Align := faBaseline;
        end;
        RPTFResetStyle: begin
          Font.Bold := false;
          Font.Underline := false;
          Font.Italic := false;
          Font.Strikeout := false;
          Font.Color := clBlack;
          Font.Pitch := fpDefault;
          {$IFDEF Linux}
          Font.CharSet := Ord(fcsAnyCharSet);
          {$ELSE}
          Font.Charset := DEFAULT_CHARSET;
          {$ENDIF}
          Font.Superscript := false;
          Font.Subscript := false;
          Font.Rotation := 0;
          Font.Width := 0.0;
          Font.Align := faBaseline;
        end;
        RPTFJustify: begin
          Case Param[1] of
            RPTFLeft: begin end;
            RPTFCenter: begin end;
            RPTFRight: begin end;
            RPTFBlock: begin end;
          end; { case }
        end;
      end; { case }
    until Pos > Length(RPTFStr);
    BaseReport.SetBaseFont(Font);
  end;  { ProcessRPTF }

  function NextPiece(    BaseReport: TBaseReport;
                         InStr: string;
                     var Pos: longint): string;

  var
    RPTFStr: string;

  begin { NextPiece }
    ParseRPTF(InStr,Pos,Result,RPTFStr);
    If RPTFStr <> '' then begin
      ProcessRPTF(BaseReport,RPTFStr);
    end; { if }
  end;  { NextPiece }

{ Return the RPTF formatted string without any format characters }

  function UnformatStr(RPTFStr: string): string;

  var
    I1: longint;
    Include: boolean;

  begin { UnformatStr }
    Include := true;
    Result := '';
    For I1 := 1 to Length(RPTFStr) do begin
      If Include then begin
        If RPTFStr[I1] = RPTFPrefix then begin
          Include := false;
        end else begin
          Result := Result + RPTFStr[I1];
        end; { else }
      end else begin
        Include := RPTFStr[I1] = RPTFSuffix;
      end; { else }
    end; { for }
  end;  { UnformatStr }

{ Return the length of the RPTF formatted string without any format characters }

  function UnformatLen(RPTFStr: string): longint;

  var
    I1: longint;
    Include: boolean;

  begin { UnformatLen }
    Include := true;
    Result := 0;
    For I1 := 1 to Length(RPTFStr) do begin
      If Include then begin
        If RPTFStr[I1] = RPTFPrefix then begin
          Include := false;
        end else begin
          Inc(Result);
        end; { else }
      end else begin
        Include := RPTFStr[I1] = RPTFSuffix;
      end; { else }
    end; { for }
  end;  { UnformatLen }

  function UnformatLenC(RPTFStr: PChar;
                        Length: longint): longint;

  var
    Include: boolean;
    RPTFCh: PChar;

  begin { UnformatLenC }
    Include := true;
    Result := 0;
    RPTFCh := RPTFStr;
    While Length > 0 do begin
      If Include then begin
        If RPTFCh^ = RPTFPrefix then begin
          Include := false;
        end else begin
          Inc(Result);
        end; { else }
      end else begin
        Include := RPTFCh^ = RPTFSuffix;
      end; { else }
      Inc(RPTFCh);
      Dec(Length);
    end; { while }
  end;  { UnformatLenC }

  function GetBaseRPTFState: TFormatState;

  begin { GetBaseRPTFState }
    With Result do begin
      Prev := nil;
      Name := 'Arial';
      Size := 12.0;
      Style.Bold := false;
      Style.Italic := false;
      Style.Underline := false;
      Style.Strikeout := false;
      Style.Subscript := false;
      Style.Superscript := false;
      Style.Color := clBlack;
      Style.Pitch := fpDefault;
      Para.Justify := pjLeft;
      Para.FirstIndent := 0.0;
      Para.LeftIndent := 0.0;
      Para.RightIndent := 0.0;
    end; { with }
  end;  { GetBaseRPTFState }

  procedure ApplyRPTFToState(var State: TFormatState;
                                 RPTFStr: string);

  var
    Command: char;
    Param: string;
    Pos: longint;

  begin { ApplyRPTFToState }
  { Process through commands }
    Pos := 0;
    Repeat
      GetNextRPTFCommand(RPTFStr,Pos,Command,Param);

    { Process Command/Param combination }
      Case Command of
        RPTFIgnore: begin end;
        RPTFBold: State.Style.Bold := (Param = RPTFOn);
        RPTFItalic: State.Style.Italic := (Param = RPTFOn);
        RPTFUnderline: State.Style.Underline := (Param = RPTFOn);
        RPTFStrikeout: State.Style.Strikeout := (Param = RPTFOn);
        RPTFSuperscript: State.Style.Superscript := (Param = RPTFOn);
        RPTFSubscript: State.Style.Subscript := (Param = RPTFOn);
        RPTFName: State.Name := Param;
        RPTFSize: State.Size := StrToFloat(Param);
        RPTFColor: State.Style.Color := StrToInt(Param);
        RPTFPitch: begin
          Case Param[1] of
            'D': State.Style.Pitch := fpDefault;
            'F': State.Style.Pitch := fpFixed;
            'V': State.Style.Pitch := fpVariable;
          end; { case }
        end;
        RPTFResetParagraph: State := GetBaseRPTFState;
        RPTFResetStyle: State.Style := GetBaseRPTFState.Style;
        RPTFJustify: begin
          Case Param[1] of
            RPTFLeft: begin
              State.Para.Justify := pjLeft;
            end;
            RPTFCenter: begin
              State.Para.Justify := pjCenter;
            end;
            RPTFRight: begin
              State.Para.Justify := pjRight;
            end;
            RPTFBlock: begin
              State.Para.Justify := pjBlock;
            end;
          end; { case }
        end;
        RPTFFirstIndent: begin
          State.Para.FirstIndent := StrToFloat(Param);
        end;
        RPTFLeftIndent: begin
          State.Para.LeftIndent := StrToFloat(Param);
        end;
        RPTFRightIndent: begin
          State.Para.RightIndent := StrToFloat(Param);
        end;
      end; { case }
    until Pos > Length(RPTFStr);
  end;  { ApplyRPTFToState }

  procedure AddFormat(var FormatStr: string;
                          Format: string);

  begin { AddFormat }
    If FormatStr = '' then begin
      FormatStr := RPTFPrefix;
    end else begin
      FormatStr := FormatStr + RPTFInfix;
    end; { else }
    FormatStr := FormatStr + Format;
  end;  { AddFormat }

  function CompareStates(var FormatStr: string;
                             Old: TFormatState;
                             New: TFormatState): string;

  begin { CompareStates }
    With New do begin
      If Old.Para.FirstIndent <> New.Para.FirstIndent then begin
        AddFormat(FormatStr,RPTFFirstIndent + FloatToStr(New.Para.FirstIndent));
      end; { if }
      If Old.Para.LeftIndent <> New.Para.LeftIndent then begin
        AddFormat(FormatStr,RPTFLeftIndent + FloatToStr(New.Para.LeftIndent));
      end; { if }
      If Old.Para.RightIndent <> New.Para.RightIndent then begin
        AddFormat(FormatStr,RPTFRightIndent + FloatToStr(New.Para.RightIndent));
      end; { if }
      If Old.Name <> Name then begin
        AddFormat(FormatStr,RPTFName + Name);
      end; { if }
      If Old.Size <> Size then begin
        AddFormat(FormatStr,RPTFSize + FloatToStr(Size));
      end; { if }
      If Old.Style.Bold <> Style.Bold then begin
        If Style.Bold then begin
          AddFormat(FormatStr,RPTFBold + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFBold + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Italic <> Style.Italic then begin
        If Style.Italic then begin
          AddFormat(FormatStr,RPTFItalic + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFItalic + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Underline <> Style.Underline then begin
        If Style.Underline then begin
          AddFormat(FormatStr,RPTFUnderline + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFUnderline + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Strikeout <> Style.Strikeout then begin
        If Style.Strikeout then begin
          AddFormat(FormatStr,RPTFStrikeout + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFStrikeout + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Subscript <> Style.Subscript then begin
        If Style.Subscript then begin
          AddFormat(FormatStr,RPTFSubscript + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFSubscript + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Superscript <> Style.Superscript then begin
        If Style.Superscript then begin
          AddFormat(FormatStr,RPTFSuperscript + RPTFOn);
        end else begin
          AddFormat(FormatStr,RPTFSuperscript + RPTFOff);
        end; { else }
      end; { if }
      If Old.Style.Color <> Style.Color then begin
        AddFormat(FormatStr,RPTFColor + IntToStr(Style.Color));
      end; { if }
      If Old.Para.Justify <> Para.Justify then begin
        Case Para.Justify of
          pjLeft: AddFormat(FormatStr,RPTFJustify + RPTFLeft);
          pjCenter: AddFormat(FormatStr,RPTFJustify + RPTFCenter);
          pjRight: AddFormat(FormatStr,RPTFJustify + RPTFRight);
          pjBlock: AddFormat(FormatStr,RPTFJustify + RPTFBlock);
        end; { case }
      end; { if }
    end; { with }
    Result := FormatStr;
  end;  { CompareStates }

  function StateToRPTF(State: TFormatState): string;

  begin { StateToRPTF }
    Result := '';
    AddFormat(Result,RPTFResetParagraph);
    CompareStates(Result,GetBaseRPTFState,State);
    Result := Result + RPTFSuffix;
  end;  { StateToRPTF }

  procedure RTFToRPTF(var RTFBuffer;
                          RTFLength: longint;
                          RPTFStream: TStream);

  var
    RTFPos: longint;
    TokenType: TRTFTokenType;
    TokenStr: string;
    TokenParam: string[60];
    TokenNum: longint;
    ErrCode: integer;
    IgnoreAll: boolean;
    IgnoreToGroupLevel: integer;
    GroupLevel: integer;
    Fonts: TStringList;
    Colors: TList;
    DefaultFont: integer;
    KeepCurrentToken: boolean;
    FormatStr: string;
    FormatState: PFormatState;
    BaseState: TFormatState;
    LastState: TFormatState;
    FirstOutput: boolean;

    procedure IncRTFCh;

    begin { IncRTFCh }
      Inc(RTFPos);
    end;  { IncRTFCh }

    procedure DecRTFCh;

    begin { DecRTFCh }
      Dec(RTFPos);
    end;  { DecRTFCh }

    function RTFCh: char;

    begin { RTFCh }
      If RTFPos >= RTFLength then begin
        Result := #0;
      end else begin
        Result := TCharArray(RTFBuffer)[RTFPos];
      end; { else }
    end;  { RTFCh }

    procedure PushState;

    var
      TempState: PFormatState;

    begin { PushState }
      New(TempState);
      Move(FormatState^,TempState^,SizeOf(TFormatState));
      TempState^.Prev := FormatState;
      FormatState := TempState;
    end;  { PushState }

    procedure PopState;

    var
      TempState: PFormatState;

    begin { PopState }
      If Assigned(FormatState) then begin
        TempState := FormatState;
        FormatState := FormatState^.Prev;
        Dispose(TempState);
      end; { if }
    end;  { PopState }

    procedure FreeFormatStates;

    var
      TempState: PFormatState;

    begin { FreeFormatStates }
      While Assigned(FormatState) do begin
        TempState := FormatState;
        FormatState := FormatState^.Prev;
        Dispose(TempState);
      end; { while }
    end;  { FreeFormatStates }

    function GetHexByte: byte;

    const
      HexStr = '0123456789ABCDEF';

    begin { GetHexByte }
      Result := (Pos(UpCase(RTFCh),HexStr) - 1) * 16;
      IncRTFCh;
      Result := Result + (Pos(UpCase(RTFCh),HexStr) - 1);
      IncRTFCh;
    end;  { GetHexByte }

    procedure GetNextToken;

    begin { GetNextToken }
      If KeepCurrentToken then begin
        KeepCurrentToken := false;
        Exit;
      end; { if }

      TokenStr := '';
      TokenParam := '';
      TokenNum := 0;
      Case RTFCh of
        #0: begin
          TokenType := ttText;
          IgnoreAll := false;
        end;
        '{': begin
          IncRTFCh;
          TokenType := ttGroupBegin;
        end;
        '}': begin
          IncRTFCh;
          TokenType := ttGroupEnd;
        end;
        '\': begin
        { Skip over extra spaces }
          Repeat
            IncRTFCh;
          until RTFCh <> ' ';
          If RTFCh in ['a'..'z'] then begin { Read Control Word }
            TokenType := ttControlWord;
          { Read letter sequence }
            Repeat
              TokenStr := TokenStr + RTFCh;
              IncRTFCh;
            until not (RTFCh in ['a'..'z']);
            If RTFCh in ['-','0'..'9'] then begin { Read numeric parameter }
              Repeat
                TokenParam := TokenParam + RTFCh;
                IncRTFCh;
              until not (RTFCh in ['0'..'9']);
              Val(TokenParam,TokenNum,ErrCode);
            end; { if }
            If RTFCh = ' ' then begin { Absorb space }
              IncRTFCh;
            end; { else }
          end else if RTFCh = '''' then begin { Read Hex char }
            TokenType := ttText;
            IncRTFCh;
            TokenStr := Char(GetHexByte);
          end else begin { Read Control Symbol }
            TokenType := ttControlSymbol;
            TokenStr := RTFCh;
            IncRTFCh;
          end; { else }
        end;
        else begin { Read in text }
          TokenType := ttText;
          Repeat
            If not (RTFCh in [#0..#31]) then begin
              TokenStr := TokenStr + RTFCh;
            end; { if }
            IncRTFCh;
            If RTFCh = '\' then begin { Check next character for formatting char }
              IncRTFCh;
              If RTFCh = '''' then begin { Hex character }
                IncRTFCh;
                TokenStr := TokenStr + Char(GetHexByte);
              end else if RTFCh in ['\','{','}'] then begin { Add this character on as text }
                TokenStr := TokenStr + RTFCh;
                IncRTFCh;
              end else begin
                DecRTFCh;
              end; { else }
            end; { if }
          until (RTFCh in [#0,'{','}','\']);
          If (TokenStr = '') and (RTFCh <> #0) then begin
            GetNextToken;
          end; { if }
        end;
      end; { case }
    end;  { GetNextToken }

    procedure GetNextCommand(NewGroup: boolean;
                             ExitSet: TRTFTokenTypeSet);

    var
      I1: integer;

    begin { GetNextCommand }
      Repeat
        GetNextToken;

        If NewGroup then begin
          If TokenType in [ttControlWord,ttControlSymbol] then begin
          { Check for ignored group }
            For I1 := Low(RTFIgnoreDest) to High(RTFIgnoreDest) do begin
              If RTFIgnoreDest[I1] = TokenStr then begin
                IgnoreToGroupLevel := GroupLevel - 1;
                IgnoreAll := true;
                Exit;
              end; { if }
            end; { for }
          end; { if }
          If not IgnoreAll then begin
            PushState;
          end; { if }
          NewGroup := false;
        end; { if }

        Case TokenType of
          ttGroupBegin: begin
            Inc(GroupLevel);
            If not IgnoreAll then begin { Check for ignored destination }
              GetNextCommand(true,ExitSet);
            end; { if }
          end;
          ttGroupEnd: begin
            Dec(GroupLevel);
            If not IgnoreAll then begin
              PopState;
            end; { if }
            If GroupLevel <= IgnoreToGroupLevel then begin
              IgnoreToGroupLevel := 0;
              IgnoreAll := false;
            end; { if }
          end;
          ttText: begin
            If RTFCh = #0 then begin
              IgnoreAll := false;
            end; { if }
          end;
        end; { case }
      until not IgnoreAll and (TokenType in ExitSet);
    end;  { GetNextCommand }

    procedure OutputText(TextStr: string);

    var
      FStr1: string;

    begin { OutputText }
      If TextStr = '' then Exit;

    { Write out any formatting differences }
      With FormatState^ do begin
        FormatStr := '';
        AddFormat(FormatStr,RPTFResetParagraph);
        FStr1 := CompareStates(FormatStr,BaseState,FormatState^);
        If FirstOutput then begin
          AddFormat(FormatStr,RPTFResetParagraph);
          FirstOutput := false;
        end else begin
          FormatStr := '';
        end; { else }
        CompareStates(FormatStr,LastState,FormatState^);
        If Length(FStr1) < Length(FormatStr) then begin
          FormatStr := FStr1;
        end; { if }
      end; { with }

      If FormatStr <> '' then begin
        FormatStr := FormatStr + RPTFSuffix;
        RPTFStream.WriteBuffer(FormatStr[1],Length(FormatStr));
        FormatStr := '';
      end; { if }

      If TextStr <> '' then begin
        RPTFStream.WriteBuffer(TextStr[1],Length(TextStr));
      end; { if }

    { Save off current state }
      LastState := FormatState^;
    end;  { OutputText }

//!!! Don't set default font until RTF string is found

    procedure ProcessControlWord;

    begin { ProcessControlWord }
      If TokenStr = 'b' then begin { Bold }
        FormatState^.Style.Bold := (TokenParam <> '0');
      end else if TokenStr = 'f' then begin { Select font }
        FormatState^.Name := Fonts[TokenNum];
      end else if TokenStr = 'fs' then begin { Font size }
        FormatState^.Size := TokenNum / 2.0;
      end else if TokenStr = 'i' then begin { Italic }
        FormatState^.Style.Italic := (TokenParam <> '0');
      end else if TokenStr = 'nosupersub' then begin { No super/subscript }
        FormatState^.Style.Subscript := false;
        FormatState^.Style.Superscript := false;
      end else if TokenStr = 'sub' then begin { Subscript }
        FormatState^.Style.Subscript := true;
      end else if TokenStr = 'super' then begin { Superscript }
        FormatState^.Style.Superscript := true;
      end else if TokenStr = 'strike' then begin { Strikeout }
        FormatState^.Style.Strikeout := (TokenParam <> '0');
      end else if TokenStr = 'ul' then begin { Underline }
        FormatState^.Style.Underline := (TokenParam <> '0');
      end else if TokenStr = 'ulnone' then begin { No underline }
        FormatState^.Style.Underline := false;
      end else if TokenStr = 'plain' then begin { Plain settings }
        FormatState^.Style := BaseState.Style;
        FormatState^.Size := BaseState.Size;
        FormatState^.Name := Fonts[0];
      end else if TokenStr = 'pntext' then begin { Bullets }
        FormatState^.Style := BaseState.Style;
        FormatState^.Name := Fonts[0];
      end else if TokenStr = 'deff' then begin { Default font number }
        DefaultFont := TokenNum;
      end else if TokenStr = 'par' then begin { New paragraph }
        OutputText(#13#10);
      end else if TokenStr = 'ql' then begin { Left Justified }
        FormatState^.Para.Justify := pjLeft;
      end else if TokenStr = 'qc' then begin { Center Justified }
        FormatState^.Para.Justify := pjCenter;
      end else if TokenStr = 'qr' then begin { Right Justified }
        FormatState^.Para.Justify := pjRight;
      end else if TokenStr = 'qj' then begin { Block Justified }
        FormatState^.Para.Justify := pjBlock;
      end else if TokenStr = 'pard' then begin { Reset Paragraph }
        FormatState^.Para := BaseState.Para;
      end else if TokenStr = 'fi' then begin { First Indent }
        FormatState^.Para.FirstIndent := TokenNum / 1440;
      end else if TokenStr = 'li' then begin { Left Indent }
        FormatState^.Para.LeftIndent := TokenNum / 1440;
      end else if TokenStr = 'ri' then begin { Right Indent }
        FormatState^.Para.RightIndent := TokenNum / 1440;
      end else if TokenStr = 'bullet' then begin { Bullet }
        OutputText(#149);
      end else if TokenStr = 'endash' then begin  { En-dash (-) }
        OutputText(#150);
      end else if TokenStr = 'emdash' then begin  { Em-dash (--) }
        OutputText(#151);
      end else if TokenStr = 'lquote' then begin { Left Quote }
        OutputText(#145);
      end else if TokenStr = 'rquote' then begin { Right Quote }
        OutputText(#146);
      end else if TokenStr = 'ldblquote' then begin { Left Double Quote }
        OutputText(#147);
      end else if TokenStr = 'rdblquote' then begin { Right Double Quote }
        OutputText(#148);
      end else if TokenStr = 'tab' then begin
        OutputText(#9);
      { OutputText('        '); }
      end else if TokenStr = 'cf' then begin
        If TokenNum < Colors.Count then begin
          FormatState^.Style.Color := longint(Colors[TokenNum]);
        end else begin
          FormatState^.Style.Color := clBlack;
        end; { else }
      end else if TokenStr = 'nevrona' then begin
        FormatStr := '';
      end else begin
      { Ignore control word }
      end; { else }
    end;  { ProcessControlWord }

    procedure ReadFontTable;

    var
      FinishLevel: integer;
      FontNumber: integer;

    begin { ReadFontTable }
      FontNumber := 0;
      FinishLevel := GroupLevel - 1;
      Repeat
        GetNextCommand(false,[ttControlWord,ttControlSymbol,ttText,ttGroupBegin,
         ttGroupEnd]);
        Case TokenType of
          ttControlWord: begin
            If TokenStr = 'f' then begin
              FontNumber := TokenNum;
            end; { if }
          end;
          ttText: begin
          { Add a font for the current FontNumber }
            If TokenStr[Length(TokenStr)] = ';' then begin
              Delete(TokenStr,Length(TokenStr),1);
            end; { if }
            If TokenStr <> '' then begin
              If FontNumber = Fonts.Count then begin
                Fonts.Add(TokenStr);
              end else begin
                While Fonts.Count <= FontNumber do begin
                  Fonts.Add('');
                end; { while }
                Fonts[FontNumber] := TokenStr;
              end; { else }
            end; { if }
          end;
        end; { case }
      until GroupLevel = FinishLevel;
      If Fonts.Count = 0 then begin
        Fonts.Add('Arial');
      end; { if }
      FormatState^.Name := Fonts[DefaultFont];
    end;  { ReadFontTable }

    procedure ReadColorTable;

    var
      FinishLevel: integer;
      RedNum: longint;
      GreenNum: longint;
      BlueNum: longint;
      ThisColor: longint;

    begin { ReadColorTable }
      RedNum := 0;
      GreenNum := 0;
      BlueNum := 0;
      FinishLevel := GroupLevel - 1;
      Repeat
        GetNextCommand(false,[ttControlWord,ttControlSymbol,ttText,ttGroupBegin,
         ttGroupEnd]);
        Case TokenType of
          ttControlWord: begin
            If TokenStr = 'red' then begin
              RedNum := TokenNum;
            end else if TokenStr = 'green' then begin
              GreenNum := TokenNum;
            end else if TokenStr = 'blue' then begin
              BlueNum := TokenNum;
            end; { else }
          end;
          ttText: begin
          { Add a color for the current ColorNumber }
            If Pos(';',TokenStr) > 0 then begin
              ThisColor := RGB(RedNum,GreenNum,BlueNum);
              RedNum := 0;
              GreenNum := 0;
              BlueNum := 0;
              Colors.Add(pointer(ThisColor));
            end; { if }
          end;
        end; { case }
      until GroupLevel = FinishLevel;
    end;  { ReadColorTable }

  begin { RTFToRPTF }
    BaseState := GetBaseRPTFState;
    LastState := BaseState;
    New(FormatState);
    FormatState^ := BaseState;
    FirstOutput := true;

    Fonts := TStringList.Create;
    Colors := TList.Create;
    GroupLevel := 0;
    IgnoreToGroupLevel := 0;
    IgnoreAll := false;
    FormatStr := '';
    DefaultFont := 0;

    RTFPos := 0;
    try
    { Process through each token in RTF stream }
      Repeat
        GetNextCommand(false,[ttControlWord,ttControlSymbol,ttText]);
        Case TokenType of
          ttControlWord, ttControlSymbol: begin
            If TokenStr = 'fonttbl' then begin { Process font table }
              ReadFontTable;
            end else if TokenStr = 'colortbl' then begin { Process color table }
              ReadColorTable;
            end else begin { Process control word }
              ProcessControlWord;
            end; { else }
          end;
          ttText: begin
            OutputText(TokenStr);
          end;
        end; { case }
      until RTFCh = #0;
    finally
      FreeFormatStates;
      Fonts.Free;
      Colors.Free;
    end; { tryf }
  end;  { RTFToRPTF }

  procedure RTFStreamToRPTF(RTFStream: TStream;
                            RPTFStream: TStream);

  var
    BufLen: longint;
    TempBuf: pointer;

  begin { RTFStreamToRPTF }
    BufLen := RTFStream.Size - RTFStream.Position;
    If RTFStream is TMemoryStream then begin
      RTFToRPTF((RTFStream as TMemoryStream).Memory^,BufLen,RPTFStream);
    end else begin
      GetMem(TempBuf,BufLen);
      try
        RTFStream.ReadBuffer(TempBuf^,BufLen);
        RTFToRPTF(TempBuf^,BufLen,RPTFStream);
      finally
        FreeMem(TempBuf,BufLen);
      end; { tryf }
    end; { else }
  end;  { RTFStreamToRPTF }

  function SimpleTextWidth(BaseReport: TBaseReport;
                           Value: string;
                           InitPos: longint): longint;

  var
    FoundPos: integer;
    Piece: string;
    IncAmt: longint;

  begin { SimpleTextWidth }
    Result := InitPos;
    With BaseReport do begin
      IncAmt := Round(XU2I(FixedTabWidth) * XDPI);
    end; { with }
    Piece := Value;
    FoundPos := System.Pos(#9,Piece); { Look for a tab }
    While FoundPos > 0 do begin { Process substrings }
      If FoundPos > 1 then begin { There is something to print }
        Result := Result + BaseReport.GetTextExtent(
         Copy(Piece,1,FoundPos - 1)).cX;
      end; { if }
      System.Delete(Piece,1,FoundPos);

    { Round Result up to next largest tab width }
      Result := (((Result - 1) div IncAmt) + 1) * IncAmt;

      FoundPos := System.Pos(#9,Piece); { Look for another tab }
    end; { while }
    Result := Result + BaseReport.GetTextExtent(Piece).cX;
  end;  { SimpleTextWidth }

  function RPTFTextWidth(BaseReport: TBaseReport;
                         Text: string): longint;

  var
  { TextExtent: TSize; }
    I1: longint;
    S1: string;

  begin { RPTFTextWidth }
    BaseReport.PushFont;
    Result := 0;
    I1 := 1;
    S1 := NextPiece(BaseReport,Text,I1);
    Repeat
      If S1 <> '' then begin
        BaseReport.SelectRPFont;
        Result := SimpleTextWidth(BaseReport,S1,Result);
        BaseReport.SelectCanvasFont;
      { Result := Result + TextExtent.cX; }
      end; { if }
      If I1 > Length(Text) then Break;
      S1 := NextPiece(BaseReport,Text,I1);
    until false;
    If Result = 0 then begin
      Result := 1;
    end; { if }
    BaseReport.PopFont;
  end;  { RPTFTextWidth }

  function RPTFTextHeight(BaseReport: TBaseReport;
                          Text: string): double;

  var
    I1: longint;
    S1: string;

  begin { RPTFTextHeight }
    BaseReport.PushFont;
    Result := 0.0;
    I1 := 1;
    S1 := NextPiece(BaseReport,Text,I1);
    Repeat
      If Result < BaseReport.FontHeight then begin
        Result := BaseReport.FontHeight;
      end; { if }
      If I1 > Length(Text) then Break;
      S1 := NextPiece(BaseReport,Text,I1);
    until false;
    BaseReport.PopFont;
  end;  { RPTFTextHeight }

  function GetJustify(RPTFStr: string;
                      Justify: TPrintJustify): TPrintJustify;

  var
    Command: char;
    Param: string;
    Pos: longint;

  begin { GetJustify }
  { Process through commands }
    Pos := 0;
    Result := Justify;
    Repeat
      GetNextRPTFCommand(RPTFStr,Pos,Command,Param);

    { Process Command/Param combination }
      If Command = RPTFResetParagraph then begin
        Result := pjLeft;
      end else if Command = RPTFJustify then begin
        Case Param[1] of
          RPTFLeft: Result := pjLeft;
          RPTFCenter: Result := pjCenter;
          RPTFRight: Result := pjRight;
          RPTFBlock: Result := pjBlock;
        end; { case }
        Exit;
      end; { else }
    until Pos > Length(RPTFStr);
  end;  { GetJustify }

end.