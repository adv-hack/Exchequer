{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RPMemo;

interface

uses
  {$IFDEF Linux}
  QControls, QGraphics, QForms, QDialogs, QStdCtrls, QComCtrls, QExtCtrls,
  {$ELSE}
  Messages, Graphics, Controls, Forms, Dialogs, StdCtrls, ComCtrls, ExtCtrls,
  {$ENDIF}
  SysUtils, Classes, RPDefine, RPBase;

type
  TMemoBuf = class(TBaseMemoBuf)
  protected
    FMaxHeight: double; { Maximum print height for PrintLines }
    FBufferInc: longint; { Minimum bytes to add each time buffer needs to be increased }
    FNoNewLine: boolean; { Should PrintMemo end with a NewLine? }
    FSaveBuffer: PCharArray; { Saved FBuffer }
    FSaveSize: longint; { Saved FBuffer size }
    FSaveRPTFList: TList; { Saved RPTF list }
    FBuffer: PCharArray; { Buffer of text }
    FSize: longint; { Size of FBuffer }
    FMaxSize: longint; { Maximum Size for FBuffer }
    FPos: longint; { Current position in FBuffer }
    FNewParagraph: boolean; { Did a new paragraph just begin? }
    NewLine: boolean; { Did a new line just begin? }
    FSearchText: TFormatString; { Text to search for }
    FSearchLen: longint; { Length of search text }
    FCaseMatters: boolean; { Does case matter during search? }
    FRPTFList: TList; { List of RPTF commands }
    FProcessRPTF: boolean; { Process RPTF commands when importing? }
    LastRPTF: string[60]; { Last piece of RPTF code }
    ReadRTF: boolean; { Should SetData or SetRTF be called? }
    ReplaceRPTF: boolean;
    NonSpacePos: longint;
    LeftIndent: double;
    RightIndent: double;

    SaveFPos: longint; { Holds FPos for SaveState/RestoreState }
    SaveNewParagraph: boolean; { Holds NewParagraph for SaveState/RestoreState }
    SaveNewLine: boolean; { Holds NewLine for SaveState/RestoreState }

    function GetText: string;
    procedure SetText(Value: string);
    procedure SetRTFText(Value: string);
    procedure SetPos(Value: longint);
    procedure SetMaxSize(Value: longint);
    procedure SetMemo(Value: TMemo);
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    procedure SetRichEdit(Value: TRichEdit);
    {$ENDIF}
    procedure SetSize(Value: longint);
    procedure FreeBuffer;
    procedure ClearRPTFList(List: TList);
    procedure CopyRPTFList(FromList: TList;
                           ToList: TList);
    procedure AddRPTFString(RPTFStr: string;
                            BufPos: longint);
    function FillRPTF(TextStr: string;
                      StartPos: longint): string;
    function GetStateAtPos(Pos: longint): TFormatState;
    function GetLine(    Width: longint;
                     var EOL: boolean): string;

  public
    constructor Create;
    destructor Destroy; override;

    function HasRPTF: boolean;
    procedure Reset;
    procedure SaveState;
    procedure RestoreState;
    function GetWord: string;
    procedure SetData(var Buffer;
                          BufSize: longint);
    procedure SetRTF(var Buffer;
                         BufSize: longint);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream;
                             BufSize: longint);
    procedure LoadFromFile(FileName: string);
    procedure RTFLoadFromStream(Stream: TStream;
                                BufSize: longint);
    procedure RTFLoadFromFile(FileName: string);
    procedure InsertMemoBuf(BufPos: longint;
                            MemoBuf: TMemoBuf);
    procedure AppendMemoBuf(MemoBuf: TMemoBuf);
    function Empty: boolean;
    procedure Insert(BufPos: longint;
                     Text: string);
    procedure Append(Text: string);
    procedure Delete(BufPos: longint;
                     DelLen: longint);
    function SearchFirst(SearchText: string;
                         CaseMatters: boolean): boolean;
    function SearchNext: boolean;
    procedure ReplaceAll(SearchText: string;
                         ReplaceText: string;
                         CaseMatters: boolean);
    procedure SaveBuffer;
    procedure RestoreBuffer;
    procedure FreeSaved;
    function GetNextLine(var EOL: boolean): string; override;
    function MemoLinesLeft: longint; override;
    function PrintLines(Lines: longint;
                        PrintTabs: boolean): double; override;
    function PrintHeight(Height: double;
                         PrintTabs: boolean): double;
    function MemoHeightLeft: double;
    function ConstrainHeightLeft(Constraint: double): double;

  { Internal use properties }
    property NewParagraph: boolean read FNewParagraph;

  { Public properties }
    property Text: string read GetText write SetText;
    property RTFText: string write SetRTFText;
    property Size: longint read FSize write SetSize;
    property MaxSize: longint read FMaxSize write SetMaxSize;
    property Pos: longint read FPos write SetPos;
    property Buffer: PCharArray read FBuffer;
    property NoCRLF: boolean read FNoNewLine write FNoNewLine;
    property NoNewLine: boolean read FNoNewLine write FNoNewLine;
    property BufferInc: longint read FBufferInc write FBufferInc;
    property Memo: TMemo write SetMemo;
    {$IFDEF Linux}
    //!!PORT!!
    {$ELSE}
    property RichEdit: TRichEdit write SetRichEdit;
    {$ENDIF}
    property ProcessRPTF: boolean read FProcessRPTF write FProcessRPTF;
  end; { TMemoBuf }

implementation

uses
  RPRPTF;

{*************************************************************************}
{                            class TRPTFItem                              }
{*************************************************************************}

type
  TRPTFItem = class
    Data: string; { RPTF Formatting commands }
    Pos: longint; { Position in buffer that these commands apply to }

    procedure AddRPTF(RPTFStr: string);
    procedure SetRPTF(RPTFStr: string);
  end; { TRPTFItem }

  procedure TRPTFItem.AddRPTF(RPTFStr: string);

  begin { AddRPTF }
    Delete(Data,Length(Data),1);
    RPTFStr[1] := RPTFInFix;
    Data := Data + RPTFStr;
  end;  { AddRPTF }

  procedure TRPTFItem.SetRPTF(RPTFStr: string);

  begin { SetRPTF }
    Data := RPTFStr;
  end;  { SetRPTF }

{*************************************************************************}
{                            class TMemoBuf                               }
{*************************************************************************}

  constructor TMemoBuf.Create;

  begin { Create }
    inherited Create;

    FNewParagraph := true;
    NewLine := true;
    FBuffer := nil;
    FSize := 0;
    FMaxSize := 0;
    FPos := 0;
    FPrintStart := 0.0;
    FPrintEnd := 0.0;
    FJustify := pjLeft;
    FNoNewLine := false;
    FBufferInc := 256;
    FSaveBuffer := nil;
    FSaveSize := 0;
    FRPTFList := TList.Create;
    FSaveRPTFList := TList.Create;
    FProcessRPTF := true;
    ReadRTF := false;
  end;  { Create }

  destructor TMemoBuf.Destroy;

  begin { Destroy }
    FreeBuffer;
    FRPTFList.Free;
    FreeSaved;
    FSaveRPTFList.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TMemoBuf.ClearRPTFList(List: TList);

  var
    I1: integer;

  begin { ClearRPTFList }
    For I1 := 1 to List.Count do begin
      TRPTFItem(List[I1 - 1]).Free;
    end; { for }
    List.Clear;
  end;  { ClearRPTFList }

  procedure TMemoBuf.CopyRPTFList(FromList: TList;
                                  ToList: TList);

  var
    I1: integer;
    RPTFItem: TRPTFItem;

  begin { CopyRPTFList }
    ClearRPTFList(ToList);

    For I1 := 1 to FromList.Count do begin
      RPTFItem := TRPTFItem.Create;
      With RPTFItem do begin
        Data := TRPTFItem(FromList[I1 - 1]).Data;
        Pos := TRPTFItem(FromList[I1 - 1]).Pos;
      end; { with }
      ToList.Add(RPTFItem);
    end; { for }
  end;  { CopyRPTFList }

  procedure TMemoBuf.AddRPTFString(RPTFStr: string;
                                   BufPos: longint);

  var
    I1: integer;
    RPTFItem: TRPTFItem;
    Found: boolean;

  begin { AddRPTFString }
    If RPTFStr = '' then Exit;

  { Search through list looking for right place to insert }
    Found := false;
    For I1 := 1 to FRPTFList.Count do begin
      RPTFItem := TRPTFItem(FRPTFList[I1 - 1]);
      If RPTFItem.Pos > BufPos then begin { Insert new RPTFItem }
        RPTFItem := TRPTFItem.Create;
        With RPTFItem do begin
          Data := RPTFStr;
          Pos := BufPos;
        end; { with }
        FRPTFList.Insert(I1 - 1,RPTFItem);
        Found := true;
        Break;
      end else if RPTFItem.Pos = BufPos then begin
        If ReplaceRPTF then begin
          RPTFItem.SetRPTF(RPTFStr);
        end else begin
          RPTFItem.AddRPTF(RPTFStr);
        end; { else }
        Found := true;
        Break;
      end; { else }
    end; { for }
    ReplaceRPTF := false;

    If not Found then begin
      RPTFItem := TRPTFItem.Create;
      With RPTFItem do begin
        Data := RPTFStr;
        Pos := BufPos;
      end; { with }
      FRPTFList.Add(RPTFItem);
    end; { if }
  end;  { AddRPTFString }

  procedure TMemoBuf.Reset;

  begin { Reset }
    FPos := 0;
    FNewParagraph := true;
    NewLine := true;
  end;  { Reset }

  procedure TMemoBuf.SaveState;

  begin { SaveState }
    SaveFPos := FPos;
    SaveNewParagraph := NewParagraph;
    SaveNewLine := NewLine;
  end;  { SaveState }

  procedure TMemoBuf.RestoreState;

  begin { RestoreState }
    FPos := SaveFPos;
    FNewParagraph := SaveNewParagraph;
    NewLine := SaveNewLine;
  end;  { RestoreState }

  function TMemoBuf.FillRPTF(TextStr: string;
                             StartPos: longint): string;

  var
    I1: integer;
    EndPos: longint;
    CurrPos: longint;
    First: boolean;
    WSLen: longint;

  begin { FillRPTF }
  { Return TextStr inserted with any RPTF commands }
    Result := TextStr;
    If TextStr = '' then Exit;
    I1 := FRPTFList.Count - 1;

  { Calculate length of white space in front }
    WSLen := 0;
    Repeat
      If Result[WSLen + 1] in [#9,#10,#13,' '] then begin
        Inc(WSLen);
      end else begin
        Break;
      end; { else }
    until WSLen >= Length(Result);

    EndPos := StartPos + Length(Result) - 1 - WSLen;
    First := true;
    While I1 >= 0 do begin
      CurrPos := TRPTFItem(FRPTFList[I1]).Pos;
      If CurrPos <= EndPos then begin
        If First then begin
          First := false;
          LastRPTF := TRPTFItem(FRPTFList[I1]).Data;
        end; { if }
        System.Insert(TRPTFItem(FRPTFList[I1]).Data,Result,CurrPos - StartPos + WSLen + 1);
      end; { if }
      If CurrPos <= StartPos then Break;
      Dec(I1);
    end; { while }
  end;  { FillRPTF }

  function TMemoBuf.GetStateAtPos(Pos: longint): TFormatState;

  var
    I1: integer;
    RPTFItem: TRPTFItem;

  begin { GetStateAtPos }
  { Find TFormatState for the current position }
    I1 := 0;
    RPTFItem := TRPTFItem(FRPTFList[I1]);
    Result := GetBaseRPTFState;
    While RPTFItem.Pos <= Pos do begin
      ApplyRPTFToState(Result,RPTFItem.Data);
      Inc(I1);
      If I1 < FRPTFList.Count then begin
        RPTFItem := TRPTFItem(FRPTFList[I1]);
      end else begin
        Break;
      end; { else }
    end; { while }
  end;  { GetStateAtPos }

  function TMemoBuf.HasRPTF: boolean;

  begin { HasRPTF }
    Result := (FRPTFList.Count > 0);
  end;  { HasRPTF }

  function TMemoBuf.GetWord: string;

  var
    StartPos: longint;

  begin { GetWord }
    If not Assigned(FBuffer) or (FPos >= Size) then begin
      Result := '';
      Exit;
    end; { if }

    StartPos := FPos;

  { Search for first non-whitespace character or end of buffer }
    While (FPos < FSize) and (FBuffer^[FPos] in [#9,' ']) and
     ((FPos - StartPos) < MAXWORDLEN) do begin
      Inc(FPos);
    end; { while }
    NonSpacePos := FPos;

    If NewLine then begin
      If not NewParagraph and not KeepSpaces then begin { Get rid of beginning white space }
        StartPos := FPos;
      end; { if }
      FNewParagraph := false;
      NewLine := false;
    end; { if }

  { Check to see if we are on a carriage return }
    If (FPos < FSize) and (FBuffer^[FPos] = #13) then begin
      FNewParagraph := true;
      Inc(FPos); { Skip #13 }
      If (FPos < FSize) and (FBuffer^[FPos] = #10) then begin
        Inc(FPos); { Skip #10 }
      end; { if }
      Result := #13; { Return carriage return only }
    end else if (FPos < FSize) and (FBuffer^[FPos] = #10) then begin
      FNewParagraph := true;
      Inc(FPos); { Skip #10 }
      Result := #13; { Return carriage return only }
    end else begin
    { Search for first whitespace character or end of buffer }
      While (FPos < FSize) and not (FBuffer^[FPos] in [#9,#10,#13,' ']) and
       ((FPos - StartPos) < MAXWORDLEN) do begin
        Inc(FPos);
      end; { while }

      SetLength(Result,FPos - StartPos);
      If FPos <> StartPos then begin
        Move(FBuffer^[StartPos],Result[1],FPos - StartPos);
      end; { if }
    end; { else }
  end;  { GetWord }

  function TMemoBuf.GetLine(    Width: longint;
                            var EOL: boolean): string;

  var
    TestWidth: longint;
    SavePos: longint;
    NewWord: string;
    S1: string;
    S2: string;
    StartPos: longint;
    FormatState: TFormatState;
    StartState: string;
    AdjWidth: longint;
    FirstLine: boolean;

  begin { GetLine }
  { Get a line of text that will fit within PrintStart to PrintEnd }
    EOL := false;
    NewLine := true;
    StartPos := -1;
    S1 := '';
    S2 := '';
    StartState := '';
    Result := '';
    FirstLine := NewParagraph;
    AdjWidth := Width;

    Repeat
      SavePos := FPos; { Save off current position }
      NewWord := GetWord; { Get next word }

      If StartPos < 0 then begin { Initial run through }
        StartPos := NonSpacePos;
        If HasRPTF then begin { Get state of line start }
          FormatState := GetStateAtPos(SavePos);
          StartState := StateToRPTF(FormatState);
          If FirstLine then begin
            LeftIndent := FormatState.Para.FirstIndent + FormatState.Para.LeftIndent;
          end else begin
            LeftIndent := FormatState.Para.LeftIndent;
          end; { else }
          RightIndent := FormatState.Para.RightIndent;
          AdjWidth := Width - Round((LeftIndent + RightIndent) * BaseReport.XDPI);
          If AdjWidth < BaseReport.XDPI then begin { Don't allow width less than 1" }
            AdjWidth := BaseReport.XDPI;
          end; { if }
        end; { if }
      end; { if }

      If (NewWord = #13) or (NewWord = '') then begin { Finish off line }
        EOL := true;
        If Result = '' then begin
          Result := StartState;
        end; { if }
        Break;
      end else begin { Test width with new word }
        S2 := S2 + NewWord;
        S1 := StartState + FillRPTF(S2,StartPos);

        If System.Pos(RPTFPrefix,S1) = 0 then begin
          TestWidth := SimpleTextWidth(BaseReport,S1,0);
        end else begin
          TestWidth := RPTFTextWidth(BaseReport,S1);
        end; { else }

        If TestWidth <= AdjWidth then begin { Add new word }
          Result := S1;
        end else begin { Reset position to before this word }
          FPos := SavePos;
        end; { else }

        If TestWidth >= AdjWidth then begin
          If UnformatLen(Result) = 0 then begin { First word was too long, cut it down }
            Repeat { Add on characters until enough width }
              S1 := Result;
              While FBuffer^[FPos] = RPTFPrefix do begin { Add on RPTF stuff }
                Repeat
                  S1 := S1 + FBuffer^[FPos];
                  Inc(FPos);
                until FBuffer^[FPos] = RPTFSuffix;
                S1 := S1 + FBuffer^[FPos];
                Inc(FPos);
              end; { while }
              S1 := S1 + FBuffer^[FPos];
              If System.Pos(RPTFPrefix,S1) = 0 then begin
                TestWidth := SimpleTextWidth(BaseReport,S1,0);
              end else begin
                TestWidth := RPTFTextWidth(BaseReport,S1);
              end; { else }
              If TestWidth <= AdjWidth then begin
                If S1 = ' ' then begin
                  Result := '';
                end else begin
                  Result := S1;
                end; { else }
                Inc(FPos);
              end; { if }
            until TestWidth >= AdjWidth;
          end; { if }
          Break;
        end; { if }
      end; { else }
    until false;
  end;  { GetLine }

  function TMemoBuf.GetText: string;

  begin { GetText }
    If FSize >= MAXWORDLEN then begin { Only return the first MAXWORDLEN chars }
      SetLength(Result,MAXWORDLEN);
      Move(FBuffer^,Result[1],MAXWORDLEN);
    end else begin
      SetLength(Result,FSize);
      If FSize > 0 then begin
        Move(FBuffer^,Result[1],FSize);
      end; { if }
    end; { else }
  end;  { GetText }

  procedure TMemoBuf.SetText(Value: string);

  begin { SetText }
    If Value = '' then begin
      FreeBuffer;
    end else begin
      SetData(Value[1],Length(Value));
    end; { else }
  end;  { SetText }

  procedure TMemoBuf.SetRTFText(Value: string);

  begin { SetRTFText }
    ReadRTF := true;
    SetText(Value);
  end;  { SetRTFText }

  procedure TMemoBuf.FreeBuffer;

  begin { FreeBuffer }
    If Assigned(FBuffer) then begin
      FreeMem(FBuffer,FMaxSize);
    end; { if }
    ClearRPTFList(FRPTFList);
    FSize := 0;
    FMaxSize := 0;
    Reset;
    FBuffer := nil;
    LastRPTF := '';
  end;  { FreeBuffer }

  procedure TMemoBuf.SetPos(Value: longint);

  begin { SetPos }
    If Value >= FSize then begin
      FPos := FSize;
    end else begin
      FPos := Value;
    end; { else }
  end;  { SetPos }

  procedure TMemoBuf.SetData(var Buffer;
                                 BufSize: longint);

  var
    TextSize: longint;
    RPTFCh: PChar;
    RPTFStr: string;
    IsRPTF: boolean;
    BufPos: longint;
    TextCh: PChar;
    TextLen: longint;

  begin { SetData }
    If ReadRTF then begin
      ReadRTF := false;
      SetRTF(Buffer,BufSize);
      Exit;
    end; { if }
    FreeBuffer;
    If ProcessRPTF then begin
      TextSize := UnformatLenC(PChar(@Buffer),BufSize);
    end else begin
      TextSize := BufSize;
    end; { else }
    If BufSize = TextSize then begin { No formatting }
      FSize := BufSize;
      FMaxSize := BufSize;
      GetMem(FBuffer,FMaxSize);
      Move(Buffer,FBuffer^,FSize);
    end else begin { Process RPTF formatting }
      FSize := TextSize;
      FMaxSize := TextSize;
      GetMem(FBuffer,FMaxSize);
      RPTFCh := @Buffer;
      RPTFStr := '';
      IsRPTF := false;
      BufPos := 0;
      TextLen := 0;
      TextCh := RPTFCh;
      While BufSize > 0 do begin
        If IsRPTF then begin
          IsRPTF := RPTFCh^ <> RPTFSuffix;
          RPTFStr := RPTFStr + RPTFCh^;
        end else begin
          If RPTFCh^ = RPTFPrefix then begin
            If TextLen > 0 then begin { Write out TextStr and add RPTF item }
              AddRPTFString(RPTFStr,BufPos);
              RPTFStr := '';
              Move(TextCh^,FBuffer^[BufPos],TextLen);
              Inc(BufPos,TextLen);
              TextLen := 0;
            end; { if }
            IsRPTF := true;
            RPTFStr := RPTFStr + RPTFCh^;
          end else begin
            If TextLen = 0 then begin
              TextCh := RPTFCh;
            end; { if }
            Inc(TextLen);
          end; { else }
        end; { else }
        Inc(RPTFCh);
        Dec(BufSize);
      end; { while }

    { Copy any remaining data out }
      If (TextLen > 0) or (RPTFStr <> '') then begin
        AddRPTFString(RPTFStr,BufPos);
        Move(TextCh^,FBuffer^[BufPos],TextLen);
      end; { if }
    end; { else }
  end;  { SetData }

  procedure TMemoBuf.SetRTF(var Buffer;
                                BufSize: longint);

  var
    RPTFStream: TMemoryStream;

  begin { SetRTF }
    RPTFStream := TMemoryStream.Create;
    try
      RTFToRPTF(Buffer,BufSize,RPTFStream);
      RPTFStream.Position := 0;
      LoadFromStream(RPTFStream,RPTFStream.Size);
    finally
      RPTFStream.Free;
    end; { tryf }
  end;  { SetRTF }

  procedure TMemoBuf.SaveToStream(Stream: TStream);

  begin { SaveToStream }
    Stream.WriteBuffer(FBuffer^,FSize);
  end;  { SaveToStream }

  procedure TMemoBuf.LoadFromStream(Stream: TStream;
                                    BufSize: longint);

  var
    TempBuffer: pointer;

  begin { LoadFromStream }
    If Stream is TMemoryStream then begin
      SetData((Stream as TMemoryStream).Memory^,BufSize);
    end else begin
      If BufSize = 0 then begin
        BufSize := Stream.Size - Stream.Position;
      end; { if }
      GetMem(TempBuffer,BufSize);
      Stream.ReadBuffer(TempBuffer^,BufSize);
      SetData(TempBuffer^,BufSize);
      FreeMem(TempBuffer,BufSize);
    end; { else }
  end;  { LoadFromStream }

  procedure TMemoBuf.LoadFromFile(FileName: string);

  var
    Stream: TFileStream;

  begin { LoadFromFile }
    Stream := TFileStream.Create(FileName,fmOpenRead);
    try
      LoadFromStream(Stream,0);
    finally
      Stream.Free;
    end; { tryf }
  end;  { LoadFromFile }

  procedure TMemoBuf.RTFLoadFromStream(Stream: TStream;
                                       BufSize: longint);

  begin { RTFLoadFromStream }
    ReadRTF := true;
    LoadFromStream(Stream,BufSize);
  end;  { RTFLoadFromStream }

  procedure TMemoBuf.RTFLoadFromFile(FileName: string);

  begin { RTFLoadFromFile }
    ReadRTF := true;
    LoadFromFile(FileName);
  end;  { RTFLoadFromFile }

  procedure TMemoBuf.InsertMemoBuf(BufPos: longint;
                                   MemoBuf: TMemoBuf);

  var
    Needed: longint;
    NewBuffer: PCharArray;
    I1: integer;
    RPTFItem: TRPTFItem;

  begin { InsertMemoBuf }
  { Check for BufPos out of range }
    If BufPos < 0 then begin
      BufPos := 0; { Insert before first char }
    end else if BufPos > FSize then begin
      BufPos := FSize; { Insert after last char }
    end; { else }

  { Allocate more space in buffer if not enough already }
    Needed := FSize + MemoBuf.Size;
    If Needed > FMaxSize then begin { Allocate more space }
      Needed := ((Needed - 1) div FBufferInc + 1) * FBufferInc;
      GetMem(NewBuffer,Needed);
      Move(FBuffer^,NewBuffer^,BufPos);
    end else begin
      NewBuffer := FBuffer;
    end; { else }

  { Adjust existing RPTF commands }
    If HasRPTF then begin
      For I1 := 1 to FRPTFList.Count do begin
        RPTFItem := TRPTFItem(FRPTFList[I1 - 1]);
        If RPTFItem.Pos >= BufPos then begin { Move position }
          RPTFItem.Pos := RPTFItem.Pos + MemoBuf.Size;
        end; { if }
      end; { for }
    end; { if }

  { Copy over any RPTFItems in MemoBuf to FRPTFList }
    If MemoBuf.HasRPTF then begin
      AddRPTFString(StateToRPTF(GetStateAtPos(BufPos + MemoBuf.Size)),
       BufPos + MemoBuf.Size);
      For I1 := 1 to MemoBuf.FRPTFList.Count do begin
        RPTFItem := TRPTFItem(MemoBuf.FRPTFList[I1 - 1]);
        AddRPTFString(RPTFItem.Data,RPTFItem.Pos + BufPos);
      end; { for }
    end; { if }

  { Move any trailing data to make room for Text}
    Move(FBuffer^[BufPos],NewBuffer^[BufPos + MemoBuf.Size],FSize - BufPos);

  { Insert Text }
    Move(MemoBuf.Buffer^[0],NewBuffer^[BufPos],MemoBuf.Size);
    FSize := FSize + MemoBuf.Size;

  { Check to see if we created a new buffer or not }
    If NewBuffer <> FBuffer then begin
      FreeMem(FBuffer,FMaxSize);
      FBuffer := NewBuffer;
      FMaxSize := Needed;
    end; { if }
  end;  { InsertMemoBuf }

  procedure TMemoBuf.AppendMemoBuf(MemoBuf: TMemoBuf);

  begin { AppendMemoBuf }
    InsertMemoBuf(FSize,MemoBuf);
  end;  { AppendMemoBuf }

  function TMemoBuf.Empty: boolean;

  begin { Empty }
    Result := (FSize = 0) or (FPos >= FSize);
  end;  { Empty }

  procedure TMemoBuf.SetMaxSize(Value: longint);

  var
    Actual: longint;
    NewBuffer: PCharArray;

  begin { SetMaxSize }
    If Value <> FMaxSize then begin
    { Allocate buffer in increments of FBufferInc }
      Actual := ((Value - 1) div FBufferInc + 1) * FBufferInc;

    { Look for shrinking buffer }
      If FSize > Value then begin
        FSize := Value;
        If FPos > Value then begin
          FPos := Value;
        end; { if }
      end; { if }

    { Copy characters over }
      GetMem(NewBuffer,Actual);
      Move(FBuffer^,NewBuffer^,FSize);

    { Assign new buffer }
      FreeMem(FBuffer,FMaxSize);
      FBuffer := NewBuffer;
      FMaxSize := Actual;
    end; { if }
  end;  { SetMaxSize }

  procedure TMemoBuf.SetMemo(Value: TMemo);

  var
    PCharVar: PChar;
    Len: longint;

  begin { SetMemo }
    Len := Value.GetTextLen;
    PCharVar := StrAlloc(Len + 1);
    try
      Value.GetTextBuf(PCharVar,Len + 1);
      SetData(PCharVar^,Len);
    finally
      StrDispose(PCharVar);
    end; { tryf }
  end;  { SetMemo }

  {$IFDEF Linux}
  //!!PORT!!
  {$ELSE}
  procedure TMemoBuf.SetRichEdit(Value: TRichEdit);

  var
    Stream: TMemoryStream;

  begin { SetRichEdit }
    Stream := TMemoryStream.Create; { Create temporary stream }
    try
      Value.Lines.SaveToStream(Stream); { Save RichEdit to stream }
      SetRTF(Stream.Memory^,Stream.Size); { Set memo buffer data to stream }
    finally
      Stream.Free; { Free up temporary stream }
    end; { try }
  end;  { SetRichEdit }
  {$ENDIF}

  procedure TMemoBuf.SetSize(Value: longint);

  begin { SetSize }
    If Value > FSize then begin
      MaxSize := Value;
    end; { if }
    FSize := Value;
  end;  { SetSize }

  procedure TMemoBuf.Insert(BufPos: longint;
                            Text: string);

  var
    Needed: longint;
    NewBuffer: PCharArray;
    I1: integer;
    RPTFItem: TRPTFItem;

  begin { Insert }
  { Check for BufPos out of range }
    If BufPos < 0 then begin
      BufPos := 0; { Insert before first char }
    end else if BufPos > FSize then begin
      BufPos := FSize; { Insert after last char }
    end; { else }

  { Allocate more space in buffer if not enough already }
    Needed := FSize + Length(Text);
    If Needed > FMaxSize then begin { Allocate more space }
      Needed := ((Needed - 1) div FBufferInc + 1) * FBufferInc;
      GetMem(NewBuffer,Needed);
      Move(FBuffer^,NewBuffer^,BufPos);
    end else begin
      NewBuffer := FBuffer;
    end; { else }

  { Adjust RPTF commands }
    If HasRPTF then begin
      For I1 := 1 to FRPTFList.Count do begin
        RPTFItem := TRPTFItem(FRPTFList[I1 - 1]);
        If RPTFItem.Pos >= BufPos then begin { Move position }
          RPTFItem.Pos := RPTFItem.Pos + Length(Text);
        end; { if }
      end; { for }
    end; { if }

  { Move any trailing data to make room for Text}
    Move(FBuffer^[BufPos],NewBuffer^[BufPos + Length(Text)],FSize - BufPos);

  { Insert Text }
    If Text <> '' then begin
      Move(Text[1],NewBuffer^[BufPos],Length(Text));
    end; { if }
    FSize := FSize + Length(Text);

  { Check to see if we created a new buffer or not }
    If NewBuffer <> FBuffer then begin
      FreeMem(FBuffer,FMaxSize);
      FBuffer := NewBuffer;
      FMaxSize := Needed;
    end; { if }
  end;  { Insert }

  procedure TMemoBuf.Append(Text: string);

  begin { Append }
    Insert(FSize,Text);
  end;  { Append }

  procedure TMemoBuf.Delete(BufPos: longint;
                            DelLen: longint);

  var
    I1: integer;
    RPTFItem: TRPTFItem;

  begin { Delete }
  { Adjust RPTF commands }
    If HasRPTF then begin
      ReplaceRPTF := true;
      AddRPTFString(StateToRPTF(GetStateAtPos(BufPos + DelLen)),BufPos + DelLen);
      I1 := 0;
      While I1 < FRPTFList.Count do begin
        Inc(I1);
        RPTFItem := TRPTFItem(FRPTFList[I1 - 1]);
        If RPTFItem.Pos >= BufPos then begin { Move position }
          If RPTFItem.Pos < (BufPos + DelLen) then begin { Delete RPTFItem }
            RPTFItem.Free;
            FRPTFList.Delete(I1 - 1);
            Dec(I1);
          end else begin
            RPTFItem.Pos := RPTFItem.Pos - DelLen;
          end; { else }
        end; { if }
      end; { while }
    end; { if }

    If (BufPos < FSize) and (BufPos >= 0) then begin
      If DelLen >= (FSize - BufPos) then begin { Take off end only }
        FSize := BufPos;
      end else begin
        Move(FBuffer^[BufPos + DelLen],FBuffer^[BufPos],FSize - (BufPos + DelLen));
        FSize := FSize - DelLen;
      end; { else }
    end; { if }
  end;  { Delete }

  function TMemoBuf.SearchFirst(SearchText: string;
                                CaseMatters: boolean): boolean;

  var
    SavePos: longint;

  begin { SearchFirst }
    SavePos := Pos;
    FSearchText := SearchText;
    FCaseMatters := CaseMatters;
    If not FCaseMatters then begin
      FSearchText := AnsiUpperCase(FSearchText);
    end; { if }
    FSearchLen := Length(FSearchText);

    Pos := -1;
    Result := SearchNext;
    If not Result then begin { None found, restore position }
      Pos := SavePos;
    end; { if }
  end;  { SearchFirst }

  function TMemoBuf.SearchNext: boolean;

  var
    Start: longint;
    Finish: longint;
    I1: longint;
    I2: longint;
    MainPtr: PChar;
    BufPtr: PChar;
    Found: boolean;
    Ch: char;

  begin { SearchNext }
  { Scan through buffer looking for SearchText }
    Result := false;
    Start := Pos + 1;
    Finish := FSize - FSearchLen;
    MainPtr := @FBuffer^[Start];
    For I1 := Start to Finish do begin
      BufPtr := MainPtr;
      Found := true;
      For I2 := 1 to FSearchLen do begin
        If FCaseMatters then begin
          If BufPtr^ <> FSearchText[I2] then begin
            Found := false;
            Break;
          end; { if }
        end else begin
          Ch := BufPtr^;
          If AnsiUpperCase(Ch) <> FSearchText[I2] then begin
            Found := false;
            Break;
          end; { if }
        end; { else }
        Inc(BufPtr);
      end; { for }
      If Found then begin
        Pos := I1;
        Result := true;
        Break;
      end; { if }
      Inc(MainPtr);
    end; { for }
  end;  { SearchNext }

  procedure TMemoBuf.ReplaceAll(SearchText: string;
                                ReplaceText: string;
                                CaseMatters: boolean);

  var
    Found: boolean;
    SavePos: longint;
    SaveRPTF: string;

  begin { ReplaceAll }
    SavePos := Pos;
    Found := SearchFirst(SearchText,CaseMatters);
    If HasRPTF then begin
      While Found do begin
        SaveRPTF := StateToRPTF(GetStateAtPos(Pos));
        Delete(Pos,Length(SearchText));
        Insert(Pos,ReplaceText);
        ReplaceRPTF := true;
        AddRPTFString(SaveRPTF,Pos);
        Pos := Pos + Length(ReplaceText) - 1;
        Found := SearchNext;
      end; { while }
    end else begin
      While Found do begin
        Delete(Pos,Length(SearchText));
        Insert(Pos,ReplaceText);
        Pos := Pos + Length(ReplaceText) - 1;
        Found := SearchNext;
      end; { while }
    end; { else }
    If SavePos > Size then begin
      Pos := Size;
    end else begin
      Pos := SavePos;
    end; { if }
  end;  { ReplaceAll }

  procedure TMemoBuf.SaveBuffer;

  begin { SaveBuffer }
    FreeSaved;
    FSaveSize := FSize;
    GetMem(FSaveBuffer,FSaveSize);
    Move(FBuffer^,FSaveBuffer^,FSaveSize);
    CopyRPTFList(FRPTFList,FSaveRPTFList);
  end;  { SaveBuffer }

  procedure TMemoBuf.RestoreBuffer;

  begin { RestoreBuffer }
    If Assigned(FSaveBuffer) then begin
      MaxSize := FSaveSize;
      Move(FSaveBuffer^,FBuffer^,FSaveSize);
      FSize := FSaveSize;
      CopyRPTFList(FSaveRPTFList,FRPTFList);
      Reset;
    end; { if }
  end;  { RestoreBuffer }

  procedure TMemoBuf.FreeSaved;

  begin { FreeSaved }
    If Assigned(FSaveBuffer) then begin
      FreeMem(FSaveBuffer,FSaveSize);
      ClearRPTFList(FSaveRPTFList);
      FSaveBuffer := nil;
      FSaveSize := 0;
    end; { if }
  end;  { FreeSaved }

  function TMemoBuf.GetNextLine(var EOL: boolean): string;

  var
    MaxWidth: longint;

  begin { GetNextLine }
    If BaseReport = nil then begin
      RaiseError(Trans('TMemoBuf.BaseReport not assigned.'));
    end; { if }
    With BaseReport do begin
    { Get a single line from MemoBuf }
      MaxWidth := XU2D(PrintEnd) - XU2D(PrintStart) + 1;
      SelectRPFont;
      Result := GetLine(MaxWidth,EOL);
      SelectCanvasFont;
    end; { with }
  end;  { GetNextLine }

  function TMemoBuf.MemoLinesLeft: longint;

  var
    MaxWidth: longint;
    EOL: boolean;
    Line: string;

  begin { MemoLinesLeft }
    If BaseReport = nil then begin
      RaiseError(Trans('TMemoBuf.BaseReport not assigned.'));
    end; { if }
    With BaseReport do begin
    { Process MemoBuf to figure out how many lines are needed to print }
      Result := 0;
      MaxWidth := XU2D(PrintEnd) - XU2D(PrintStart) + 1;
      SaveState;
      SelectRPFont;
      While Pos < Size do begin
        Line := GetLine(MaxWidth,EOL);
        Inc(Result);
      end; { while }
      SelectCanvasFont;
      RestoreState;
    end; { with }
  end;  { MemoLinesLeft }

  function TMemoBuf.PrintLines(Lines: longint;
                               PrintTabs: boolean): double;

  var
    TempTab: PTab;
    TabStr: string[60];
    OnLine: integer;
    MaxWidth: longint;
    Line: string;
    EOL: boolean;
    ThisJustify: TPrintJustify;
    RPTFFontHeight: double;
    CheckHeight: boolean;

  begin { PrintLines }
    Result := 0.0;
    If Lines < 0 then Exit; { Don't print anything }
    If BaseReport = nil then begin
      RaiseError(Trans('TMemoBuf.BaseReport not assigned.'));
    end; { if }

    With BaseReport do begin
      TabStr := '';
      If PrintTabs then begin { Determine how many tab setting there are }
        TempTab := GetTab(1);
        While Assigned(TempTab) do begin
          TabStr := TabStr + #9;
          TempTab := TempTab^.Next;
        end; { while }
      end; { if }

      If PrintEnd <= PrintStart then begin
        RaiseError(Trans('TMemoBuf.PrintEnd must be greater than TMemoBuf.PrintStart'));
      end; { if }
      MaxWidth := XU2D(PrintEnd) - XU2D(PrintStart) + 1;
      CheckHeight := (FMaxHeight > 0.0);
      OnLine := 0;

    { Print the memo lines }
      While ((Lines > 0) and (OnLine < Lines)) or ((Lines = 0) and (Pos < Size)) do begin

      { Get next memo line }
        SaveState;
        SelectRPFont;
        Line := GetLine(MaxWidth,EOL);
        SelectCanvasFont;

      { Determine if there is enough height left }
        If HasRPTF and (LineHeightMethod = lhmFont) then begin
          RPTFFontHeight := RPTFTextHeight(BaseReport,Line);
          If CheckHeight then begin
            FMaxHeight := FMaxHeight - (RPTFFontHeight * 1.2);
            If (FMaxHeight + 0.001) < 0.0 then begin { Not enough height left }
              RestoreState;
              Break;
            end; { if }
          end; { if }

        { Setup line }
          If OnLine > 0 then begin
            If NewParagraph or HardLines then begin
              NewLine;
            end else begin
              SoftLine;
            end; { else }
          end; { if }

          FontHeight := RPTFFontHeight;
          Result := Result + RPTFFontHeight;
          AdjustLine;
        end else begin
        { Setup line }
          If OnLine > 0 then begin
            If NewParagraph or HardLines then begin
              NewLine;
            end else begin
              SoftLine;
            end; { else }
          end; { if }
          Result := Result + LineHeight;
        end; { else }
        Inc(OnLine);

      { Print Tab string }
        If TabStr <> '' then begin
          Print(TabStr);
        end; { if }

      { Get justification }
        If HasRPTF then begin
          Justify := GetJustify(Line,Justify);
          If Justify = pjBlock then begin
            Justify := pjLeft; {!!! Block justify doesn't work with RPTF codes }
          end; { if }
        end; { if }
        If EOL and (Justify = pjBlock) then begin
          ThisJustify := pjLeft;
        end else begin
          ThisJustify := Justify;
        end; { else }

      { Print the line }
        PrintJustify(Line,XU2I(PrintStart + LeftIndent) + LineStartPos - XU2I(SectionLeft),
         ThisJustify,0,XU2I(PrintEnd - PrintStart - (LeftIndent + RightIndent)));
      end; { while }

      If not NoNewLine then begin { Finish off with NewLine }
        If NewParagraph or HardLines or (Pos >= Size) then begin
          NewLine;
        end else begin
          SoftLine;
        end; { else }
      end; { if }
    end; { with }
  end;  { PrintLines }

  function TMemoBuf.PrintHeight(Height: double;
                                PrintTabs: boolean): double;

  begin { PrintHeight }
    If BaseReport = nil then begin
      RaiseError(Trans('TMemoBuf.BaseReport not assigned.'));
    end; { if }
    With BaseReport do begin
      AdjustLine;
      If HasRPTF then begin
      { Print lines up to Height }
        FMaxHeight := Height;
        Result := PrintLines(0,PrintTabs);
        FMaxHeight := 0.0;
      end else begin
        FMaxHeight := 0.0;
        Result := PrintLines(Trunc(0.00001 + (Height / LineHeight)),PrintTabs);
      end; { else }
    end; { with }
  end;  { PrintHeight }

  function TMemoBuf.MemoHeightLeft: double;

  begin { MemoHeightLeft }
    Result := ConstrainHeightLeft(99999999.0);
  end;  { MemoHeightLeft }

  function TMemoBuf.ConstrainHeightLeft(Constraint: double): double;

  var
    MaxWidth: longint;
    EOL: boolean;
    Line: string;
    F1: double;

  begin { ConstrainHeightLeft }
    If BaseReport = nil then begin
      RaiseError(Trans('TMemoBuf.BaseReport not assigned.'));
    end; { if }
    With BaseReport do begin
      If HasRPTF and (LineHeightMethod = lhmFont) then begin
      { Process MemoBuf to figure out how many lines are needed to print }
        Result := 0.0;
        MaxWidth := XU2D(PrintEnd) - XU2D(PrintStart) + 1;
        SaveState;
        SelectRPFont;
        While Pos < Size do begin
          Line := GetLine(MaxWidth,EOL);
          F1 := RPTFTextHeight(BaseReport,Line);
          F1 := F1 * 1.2;
          If (Result + F1) <= Constraint then begin
            Result := Result + F1;
          end else begin
            Break; { Reached constraint height }
          end; { else }
        end; { while }
        SelectCanvasFont;
        RestoreState;
      end else begin
        Result := MemoLinesLeft * LineHeight;
        If Result > Constraint then begin
          Result := Int(Constraint / LineHeight) * LineHeight;
        end; { if }
      end; { else }
    end; { with }
  end;  { ConstrainHeightLeft }

end.