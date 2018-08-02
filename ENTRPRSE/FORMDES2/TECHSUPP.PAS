unit Techsupp;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, RPCanvas, RPFPrint, RPreview, RPBase, RPFiler, RpMemo, RpDevice,
  RPDefine;

Type
  tsFontTypeList = (ftHdr, ftNormal, ftSmall, ftBNormal);

  TForm_TechSupp = class(TForm)
    ReportFiler1: TReportFiler;
    procedure ReportFiler1Print(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ReportFiler1NewPage(Sender: TObject);
    procedure ReportFiler1BeforePrint(Sender: TObject);
  private
    { Private declarations }
    TheReport : TBaseReport; { print to this as its easier to swap controls later }
    OnCtrlPg  : Boolean;
    procedure BlankLine;
    procedure CheckSpace (Const NeedLines : Byte);
    Procedure DoFont (Const FontType : tsFontTypeList);
    Function  MemoHeight (Var MemoBuf : TMemoBuf) : SmallInt;
    Procedure PrintLine (Const FontType : tsFontTypeList;Text : String);
    procedure PrintMLine (Const FontType : tsFontTypeList;Text : String);
    procedure PrintOut (Const FontType : tsFontTypeList;Text : String);
    procedure SetMargins;
    procedure StartPosition;
  public
    { Public declarations }
  end;

var
  Form_TechSupp: TForm_TechSupp;

implementation

{$R *.DFM}

Uses FormDesn, GlobType, DllInt, SBSFuncs, SBSDrag, FormUtil,
     History;   // Form Designer History & Version


procedure TForm_TechSupp.FormCreate(Sender: TObject);
begin
  TheReport := ReportFiler1;
  OnCtrlPg  := False;
end;

procedure TForm_TechSupp.BlankLine;
Begin
  With TheReport Do
    PrintLn ('');
End;

Procedure TForm_TechSupp.DoFont (Const FontType : tsFontTypeList);
Begin
  With TheReport Do Begin
    FontName := 'Arial';
    FontColor := clBlack;
    Bold := False;
    UnderLine := False;

    SetPen (clBlack, psSolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    Case FontType Of
      ftHdr     : Begin
                    FontSize := 12;
                    Bold := True;
                  End;
      ftNormal  : Begin
                    FontSize := 10;
                  End;
      ftSmall   : Begin
                    FontSize := 8;
                  End;
      ftBNormal : Begin
                    FontSize := 10;
                    Bold := True;
                  End;
    End; { Case }

    If OnCtrlPg Then Begin
      SetPen (clSilver, psSolid, -1, pmCopy);
      FontColor := clSilver;
    End; { If }
  End; { With }
End;

procedure TForm_TechSupp.SetMargins;
Begin
  With TheReport Do Begin
    { set the margins }
    If (Orientation = poPortrait) Then Begin
      MarginLeft   := 2 * LeftWaste;
      MarginRight  := 2 * RightWaste;
      MarginTop    := 2 * TopWaste;
      MarginBottom := 2 * BottomWaste;
    End { If }
    Else Begin
      MarginLeft   := 2 * TopWaste;
      MarginRight  := 2 * BottomWaste;
      MarginTop    := 2 * RightWaste;
      MarginBottom := 2 * LeftWaste;
    End; { Else }
  End; { With }
End;

procedure TForm_TechSupp.PrintLine (Const FontType : tsFontTypeList;Text : String);
Var
  Memo : TMemoBuf;
Begin
  DoFont (FontType);

  With TheReport Do
    PrintLn (UpperCase (Text));
End;

procedure TForm_TechSupp.PrintMLine (Const FontType : tsFontTypeList;Text : String);
Var
  Memo : TMemoBuf;
Begin
  DoFont (FontType);

  With TheReport Do Begin
    Memo := TMemoBuf.Create;
    Try
      Memo.Text := UpperCase (Text);
      Memo.PrintStart := MarginLeft{ + 35};
      Memo.PrintEnd   := PageWidth - MarginRight;
      PrintMemo(Memo, 0, False);
    Finally
      Memo.Free;
    End;
  End; { With }
End;

procedure TForm_TechSupp.PrintOut (Const FontType : tsFontTypeList;Text : String);
Begin
  DoFont (FontType);
  With TheReport Do
    Print (UpperCase (Text));
End;

procedure TForm_TechSupp.StartPosition;
Begin
  With TheReport Do Begin
    Home;
    CRLF;
    CRLF;
    CRLF;
  End; { With }
End;

procedure TForm_TechSupp.CheckSpace (Const NeedLines : Byte);
Begin
  With TheReport Do
    If (LinesLeft < (1 + NeedLines)) Then NewPage;
End;

{ returns the number of lines to print for a memo }
Function TForm_TechSupp.MemoHeight (Var MemoBuf : TMemoBuf) : SmallInt;
Var
  MaxWidth : LongInt;
  LineNo   : SmallInt;
  EOL      : Boolean;
Begin
  With TheReport, MemoBuf Do Begin
    MaxWidth := XU2D(PrintEnd) - XU2D(PrintStart) + 1;

    { Print the memo lines }
    (*
    LineNo := 0;
    While (Pos < Size) Do Begin
      Inc(LineNo);
      GetLine(TheReport, MaxWidth, EOL);
    End; { while }
    *) LineNo := 1;

    MemoBuf.Reset;

    If (LineNo <= 0) Then LineNo := 1;
    If (LineNo > 3) Then LineNo := 3;

    Result := LineNo;
  End; { With }
End;

procedure TForm_TechSupp.ReportFiler1NewPage(Sender: TObject);
Var
  Y1 : LongInt;
begin
  With TheReport Do Begin
    SetMargins;
    Home;

    DoFont (ftBNormal);
    PrintLeft  (UpperCase(ExtractFileName(Form_Designer.FormController.FormDetails.ftFormPath)), MarginLeft);
    PrintCenter (Trim(UpperCase(GetCompanyName)), PageWidth / 2.0);
    PrintRight (UpperCase('Page ' + IntToStr(CurrentPage)) + ' Of ' + Macro(MidTotalPages), PageWidth - MarginRight);
    Y1 := CursorYPos;
    CRLF;
    If OnCtrlPg Then
      SetPen   (clSilver, psSolid, -2, pmCopy)
    Else
      SetPen   (clBlack, psSolid, -2, pmCopy);
    MoveTo (MarginLeft, YD2U(Round((CursorYPos + Y1) / 2)));
    LineTo (PageWidth - MarginRight, YD2U(Round((CursorYPos + Y1) / 2)));
    CRLF;

    OnCtrlPg := False;
    DoFont (ftNormal);

    StartPosition;
  End; { With }
end;

procedure TForm_TechSupp.ReportFiler1Print(Sender: TObject);
Var
  ColObj       : TFormDefListObjType;
  FormDef      : FormDefRecType;
  StrRec       : ^fdFormStringsType;
  DragCtrl     : TSBSDragControl;
  LineStr, Col : ShortString;
  FileDateTime : TDateTime;
  I, J, GTop   : SmallInt;
  MemoBuf      : TMemoBuf;
  FileByteSize : LongInt;
  CtrlRect     : TRect;
  HedRec       : ^fdHeaderRecType;

  { gets the size, data, and time of the specified file }
  Procedure GetFileInfo (Const FName : ShortString);
  Var
    TmpFileMode, FileHandle, TmpDT : Integer;
    DW1, DW2                       : DWord;
  Begin
    FileByteSize := 0;
    FileDateTime := 0;

    If FileExists (FName) Then Begin
      FileHandle :=  FileOpen (FName, (fmOpenRead Or fmShareDenyNone));
      If (FileHandle <> -1) Then Begin
        { Get date and time }
        TmpDT := FileGetDate(FileHandle);
        If (TmpDT > 0) Then FileDateTime := FileDateToDateTime (TmpDT);

        { File Size }
        DW1 := GetFileSize (FileHandle, @DW2);
        If (DW1 > 0) Then FileByteSize := DW1;

        { close file }
        FileClose (FileHandle);
      End { If }
      Else
        SysUtils.Beep;
    End { If }
    Else
      SysUtils.Beep;
  End;

  Procedure PrnMemo (Typ : Byte; MemoStr : String);
  Begin
    With TheReport Do Begin
      MemoBuf.Text := MemoStr;
      MemoBuf.PrintStart := MarginLeft + (Typ * 10);
      MemoBuf.PrintEnd   := PageWidth - MarginRight;
      CheckSpace(MemoHeight(MemoBuf));
      PrintMemo(MemoBuf, MemoHeight(MemoBuf), False);
    End; { With }
  End;

  Procedure PrnFont (Typ : Byte; TheFont : fdFontDefType);
  Var
    Col, FontStr : ShortString;
  Begin
    With TheFont Do Begin
      FontStr := 'Font: ' + ffName + ', ' +
                 IntToStr(ffSize) + 'pt';

      If GetColorName (ffColor, Col) Then
        FontStr := FontStr + ', ' + Col;

      If (fsBold In ffStyle) Then FontStr := FontStr + ', Bold';
      If (fsItalic In ffStyle) Then FontStr := FontStr + ', Italic';
      If (fsUnderline In ffStyle) Then FontStr := FontStr + ', Uline';
      If (fsStrikeOut In ffStyle) Then FontStr := FontStr + ', Strike';

      PrnMemo (Typ, FontStr);
    End; { With }
  End; { With }

  Procedure PrnIf (Typ : Byte; TheIf : fdIfInfoType);
  Var
    Col, FontStr : ShortString;
  Begin
    With TheIf Do Begin
      If (Trim(fiIf) <> '') Then
        PrnMemo (Typ, 'If: ' + fiIf);
    End; { With }
  End; { With }

  Procedure RepTabs (Typ : Byte);
  Begin { RepTabs }
    With TheReport Do Begin
      ClearTabs;

      Case Typ Of
        1 : Begin
              SetTab (MarginLeft + 35, pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
            End;
        2 : Begin
              SetTab (MarginLeft + 10, pjLeft, 23,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
              SetTab (NA,              pjLeft, 40,  4, 0, 0);
            End;
      End; { Case }
    End; { With }
  End;  { RepTabs }

begin
  With TheReport, Form_Designer, FormController Do Begin
    { set the margins }
    SetMargins;

    RepTabs (1);

    StartPosition;
    PrintLine (ftHdr,    'System:');
    PrintLine (ftNormal, 'Location: ' + #9 + ExtractFilePath(Application.ExeName));
    PrintLine (ftNormal, 'DataPath: ' + #9 + SystemInfo.ExDataPath);
    BlankLine;
    PrintLine (ftNormal, #9 + 'Ver' + #9#9 + 'Date/Time' + #9 + 'Size');
    GetFileInfo (Application.ExeName);
    PrintLine (ftNormal, 'Form Designer' + #9 + FormDesVer + #9#9 + DateToStr(FileDateTime) + ' ' + TimeToStr(FileDateTime) + #9 + IntToStr(FileByteSize));
    GetFileInfo (ExtractFilePath(Application.ExeName)+'sbsform.dll');
    PrintLine (ftNormal, 'Dll' + #9 + sbsForm_GetDllVer + #9#9 + DateToStr(FileDateTime) + ' ' + TimeToStr(FileDateTime) + #9 + IntToStr(FileByteSize));

    BlankLine;
    BlankLine;
    PrintLine (ftHdr,    'Form:');
    I := 1;
    Repeat
      With FormDetails Do
        Case I Of
          1  : PrintLine (ftNormal, 'Type:' + #9 + Iif (ftFormType = ftForm, 'Form', IIF (ftFormType = ftLabel, 'Label', 'Report')));
          2  : PrintLine (ftNormal, 'Descr:' + #9 + ftFormDescr);
          3  : PrintLine (ftNormal, 'Path:' + #9 + ftFormPath);
          4  : PrintLine (ftNormal, 'Continuation:' + #9 + ftContinue);
          5  : PrintLine (ftNormal, 'Paper:' + #9 + 'Width: ' + IntToStr(ftPaperWidth) + #9 + 'Height:' + IntToStr(ftPaperHeight));
          6  : PrintLine (ftNormal, 'Margins:' + #9 + 'Top: ' + IntToStr(ftTopMargin) +
                                                 #9 + 'Bottom: ' + IntToStr(ftBottomMargin) +
                                                 #9 + 'Left: ' + IntToStr(ftLeftMargin) +
                                                 #9 + 'Right: ' + IntToStr(ftRightMargin));
          7  : Begin
                 If (LinesLeft < 7) Then NewPage;
                 PrintLine (ftNormal, 'Sections:' + #9 + 'Page Header: ' + #9 + Iif (stPageHead In ftSections, 'On', 'Off') + #9 + 'Height: ' + IntToStr(ftHeaderSep));
                 PrintLine (ftNormal,               #9 + 'Body Header: ' + #9 + Iif (stBodyHead In ftSections, 'On', 'Off') + #9 + 'Height: ' + IntToStr(ftBodyHeadSep));
                 PrintLine (ftNormal,               #9 + 'Body: '        + #9 + Iif (stBody     In ftSections, 'On', 'Off') + #9 + 'Height: ' + IntToStr(ftBodySep));
                 PrintLine (ftNormal,               #9 + 'Body Footer: ' + #9 + Iif (stBodyFoot In ftSections, 'On', 'Off') + #9 + 'Height: ' + IntToStr(ftHeaderSep));
                 PrintLine (ftNormal,               #9 + 'Page Footer: ' + #9 + Iif (stPageFoot In ftSections, 'On', 'Off') + #9 + 'Height: ' + IntToStr(ftBodyFootSep));
               End;

          8  : Begin { Strings }
                 GetMem (StrRec, SizeOf (StrRec^));

                 DetailsToStrRec (StrRec^);

                 LineStr := 'Strings:';
                 With StrRec^ Do
                   For J := Low (fsSVStrs) To High(fsSVStrs) Do
                     If (Trim(fsSVStrs[J]) <> '') Then Begin
                       LineStr := LineStr + #9 + IntToStr(J) + ': "' + fsSVStrs[J] + '"';
                       PrintLine (ftNormal, LineStr);
                       LineStr := '';
                     End; { If }

                 FreeMem (StrRec, SizeOf (StrRec^));
               End;

          9  : Begin // Options
                 GetMem (HedRec, SizeOf(HedRec^));
                 DetailsToHedRec (HedRec^);

                 With HedRec^ Do
                 Begin
                   PrintLine (ftNormal, 'Options:' + #9 + 'Serial: ' + Iif (fhSerialNo In [1,3,11,13], 'Yes', 'No') +
                                                     #9 + 'Batch: ' + Iif (fhSerialNo In [2,3,12,13], 'Yes', 'No') +
                                                     #9 + 'Bins: ' + Iif (fhShowBins, 'Yes', 'No'));

                   PrintLine (ftNormal,              #9 + 'InDocs: ' + Iif (fhInpSNo, 'Yes', 'No') +
                                                     #9 + 'UseBy: ' + Iif (fhShowUseBy, 'Yes', 'No') +
                                                     #9 + 'Order: ' + Iif (fhStockOrder, 'Stock', 'Bin'));

                   PrintLine (ftNormal,              #9 + 'Format: ' + Iif (fhSerialNo >= 10, 'Full', '1/Line') +
                                                     #9 + 'Width: ' + IntToStr(fhSNoWidth));

                   PrintLine (ftNormal,              #9 + 'ADJ Mode: ' + IntToStr(fhPrintAdjBom) +
                                                     #9 + 'Sort Mode: ' + IntToStr(fhDocSortMode));
                 End; // With HedRec^
                 
                 FreeMem (HedRec, SizeOf(HedRec^));
               End; // Options
        End; { Case }

      Inc (I);

      CheckSpace (1);
    Until (I = 20);


    MemoBuf := TMemoBuf.Create;
    Try
      CheckSpace (7);
      BlankLine;
      BlankLine;
      PrintLine (ftHdr, 'Controls: ' + IntToStr(ControlList.Count));
      For I := 0 To (ControlList.Count - 1) Do Begin
        DragCtrl := TSBSDragControl(ControlList.Items[I]);
        FormDef  := DragCtrl.GetDefRec;

        RepTabs (1);

        { Print Basic Details (ControlId in Bold) }
        DoFont (ftBNormal);
        TheReport.Print (DragCtrl.ControlId);
        PrintLine (ftNormal, #9 + DragCtrl.GetPosStr + '  (Group: ' + GetGroup (DragCtrl) + ')');

        Case FormDef.fdFieldClass Of
          fdcText    : With FormDef.Text Do Begin
                         PrnMemo (1, '"' + ftText + '"');
                         PrnFont (1, ftFont);
                         PrnIf (1, ftIf);
                       End; { fdcText }
          fdcLine    : With FormDef.Line Do Begin
                         Case flType Of
                           lnVertical   : LineStr := 'Vertical';
                           lnHorizontal : LineStr := 'Horizontal';
                           lnTLToBR     : LineStr := 'Top-Left to Bottom-Right';
                           lnBLToTR     : LineStr := 'Bottom-Left to Top-Right';
                         End; { Case }

                         If GetColorName (flColor, Col) Then
                           LineStr := LineStr + ', ' + Col;

                         PrnMemo (1, LineStr);
                         PrnIf (1, flIf);
                       End; { fdcLine }
          fdcBitmap  : With FormDef.Bitmap Do Begin
                         PrnMemo (1, fbBitmapPath);
                         PrnIf (1, fbIf);
                       End; { fdcBitmap }
          fdcTable   : With TSBSDragDbTable(DragCtrl) Do Begin
                         { Print Table Details }
                         PrnIf (1, FormDef.Table.frIf);

                         RepTabs (2);

                         { Print Column Details }
                         For J := 0 To (Columns.Count - 1) Do Begin
                           ColObj := Columns.Items[J];
                           With ColObj.FormDef Do Begin
                             DoFont (ftBNormal);
                             TheReport.Print (#9 + fdControlId);

                             Case fdFieldClass Of
                               fdcFieldCol   : With FieldCol Do Begin
                                                 DoFont (ftNormal);
                                                 TheReport.PrintLn (' - "' + fdTitle + '"');

                                                 PrnMemo (2, 'Field: ' + fdShortCode);
                                                 LineStr := 'Width: ' + IntToStr(fdWidth) +
                                                             ', Align: ';
                                                 Case fdAlign Of
                                                   taLeftJustify  : LineStr := LineStr + 'Left';
                                                   taRightJustify : LineStr := LineStr + 'Right';
                                                   taCenter       : LineStr := LineStr + 'Centre';
                                                 End; { Case }
                                                 LineStr := LineStr + ', Decs: ' + IntToStr(fdDecs) +
                                                            IIF (fdHidden, ', Hidden', '') +
                                                            IIF (fdBlankIfZero, ', Blank, ', '');

                                                 PrnMemo (2, LineStr);
                                                 PrnFont (2, fdColFont);
                                               End;

                               fdcFormulaCol : With FormulaCol Do Begin
                                                 DoFont (ftNormal);
                                                 TheReport.PrintLn (' - "' + ffTitle + '"');

                                                 PrnMemo (2, 'Formula: ' + ffFormula);
                                                 LineStr := 'Width: ' + IntToStr(ffWidth) +
                                                             ', Align: ';
                                                 Case ffAlign Of
                                                   taLeftJustify  : LineStr := LineStr + 'Left';
                                                   taRightJustify : LineStr := LineStr + 'Right';
                                                   taCenter       : LineStr := LineStr + 'Centre';
                                                 End; { Case }
                                                 LineStr := LineStr + ', Decs: ' + IntToStr(ffDecs) +
                                                            IIF (ffHidden, ', Hidden', '') +
                                                            IIF (ffBlankIfZero, ', Blank, ', '');

                                                 PrnMemo (2, LineStr);

                                                 If (ffBarCode <> bcNone) Then Begin
                                                   LineStr := 'BarCode: ';
                                                   Case ffBarCode Of
                                                     bcCode39  : LineStr := LineStr + 'Code 39';
                                                     bcCode128 : LineStr := LineStr + 'Code 128';
                                                     bcInter25 : LineStr := LineStr + 'Interleaved 2 Of 5';
                                                     bcCodabar : LineStr := LineStr + 'Codabar';
                                                     bcPostnet : LineStr := LineStr + 'PostNet';
                                                     bcUPCA    : LineStr := LineStr + 'UPC-A';
                                                     bcUPCE    : LineStr := LineStr + 'UPC-E';
                                                     bcEAN8    : LineStr := LineStr + 'EAN-8';
                                                     bcEAN13   : LineStr := LineStr + 'EAN-13';
                                                   Else
                                                     LineStr := LineStr + 'Unknown';
                                                   End; { Case }

                                                   LineStr := LineStr + ', Flags: ' +
                                                              IntToStr(ffBCFlag1) + ', ' +
                                                              IntToStr(ffBCFlag2) + ', ' +
                                                              IntToStr(ffBCFlag3);

                                                   PrnMemo (2, LineStr);
                                                 End; { If }

                                                 PrnFont (2, ffColFont);
                                               End;
                             End; { Case }

                             PrnIf (2, ColObj.GetIf);
                           End; { With }
                         End; { For }
                       End; { fdcTable }
          fdcPage    : With FormDef.PageNo Do Begin
                         PrnMemo (1, '"' + fpLeading + '%P' + fpTrailing + '"');
                         PrnFont (1, fpFont);
                         PrnIf (1, fpIf);
                       End; { fdcPage }
          fdcFormula : With FormDef.Formula Do Begin
                         PrnMemo (1, 'Formula: ' + ffFormula);
                         LineStr := 'Align: ';
                         Case ffAlign Of
                           taLeftJustify  : LineStr := LineStr + 'Left';
                           taRightJustify : LineStr := LineStr + 'Right';
                           taCenter       : LineStr := LineStr + 'Centre';
                         End; { Case }
                         LineStr := LineStr + ', Decs: ' + IntToStr(ffDecs) +
                                    IIF (ffHidden, ', Hidden', '') +
                                    IIF (ffBlankIfZero, ', Blank, ', '');

                         PrnMemo (1, LineStr);

                         If (ffBarCode <> bcNone) Then Begin
                           LineStr := 'BarCode: ';
                           Case ffBarCode Of
                             bcCode39  : LineStr := LineStr + 'Code 39';
                             bcCode128 : LineStr := LineStr + 'Code 128';
                             bcInter25 : LineStr := LineStr + 'Interleaved 2 Of 5';
                             bcCodabar : LineStr := LineStr + 'Codabar';
                             bcPostnet : LineStr := LineStr + 'PostNet';
                             bcUPCA    : LineStr := LineStr + 'UPC-A';
                             bcUPCE    : LineStr := LineStr + 'UPC-E';
                             bcEAN8    : LineStr := LineStr + 'EAN-8';
                             bcEAN13   : LineStr := LineStr + 'EAN-13';
                           Else
                             LineStr := LineStr + 'Unknown';
                           End; { Case }

                           LineStr := LineStr + ', Flags: ' +
                                      IntToStr(ffBCFlag1) + ', ' +
                                      IntToStr(ffBCFlag2) + ', ' +
                                      IntToStr(ffBCFlag3);

                           PrnMemo (1, LineStr);
                         End; { If }

                         PrnFont (1, ffFont);
                         PrnIf (1, ffIf);
                       End; { fdcFormula }
          fdcBox     : With FormDef.Box Do Begin
                         PrnMemo (1, 'Lines: ' + IIF(fxLeftBorder, 'Left ', '') +
                                                 IIF(fxTopBorder, 'Top ', '') +
                                                 IIF(fxRightBorder, 'Right ', '') +
                                                 IIF(fxBottomBorder, 'Bottom', ''));
                         PrnMemo (1, 'Width: ' + IntToStr (fxPenWidth) +
                                     IIF (GetColorName (fxPenColor, Col), ', Colour: ' + Col, '') +
                                     IIF (fxFill, ', Fill', ''));
                         PrnIf (1, fxIf);
                       End; { fdcBox }
          fdcDbfield : With FormDef.DbField Do Begin
                         PrnMemo (1, 'Field: ' + fdShortCode);
                         LineStr := 'Length: ' + IntToStr(fdFieldLen) + ', Align: ';
                         Case fdAlign Of
                           taLeftJustify  : LineStr := LineStr + 'Left';
                           taRightJustify : LineStr := LineStr + 'Right';
                           taCenter       : LineStr := LineStr + 'Centre';
                         End; { Case }
                         LineStr := LineStr + ', Decs: ' + IntToStr(fdDecs) +
                                    IIF (fdBlankIfZero, ', Blank, ', '');

                         PrnMemo (1, LineStr);
                         PrnFont (1, fdFont);
                         PrnIf (1, fdIf);
                       End; { fdcDbField }
          fdcGroup   : With FormDef.Group Do Begin
                         LineStr := 'Rows:';
                         GTop    := fgYPos;
                         For J := Low (fgRows) To High(fgRows) Do
                           If (fgRows[J] > 0) Then Begin
                             PrintLine (ftNormal, LineStr + #9 + IntToStr (GTop) + '-' + IntToStr(fgYPos + fgRows[J] - 1));
                             GTop := fgYPos + fgRows[J];
                             LineStr := '';
                           End; { If }
                         PrintLine (ftNormal, #9 + IntToStr (GTop) + '-' + IntToStr(fgYPos + fgHeight));

                         PrnIf (1, fgIf);
                       End; { fdcGroup }
        End; { Case }

        CheckSpace (1);
      End; { For }
    Finally
      MemoBuf.Free;
    End;

    { Print Control Outlines with ControlId's }
    OnCtrlPg := True;
    NewPage;
    For I := 0 To (ControlList.Count - 1) Do Begin
      DragCtrl := TSBSDragControl(ControlList.Items[I]);

      With DragCtrl Do Begin
        FormDef  := DragCtrl.GetDefRec;

        CtrlRect := CreateRect(PixelsToMMH(DragCtrl.Left),
                               PixelsToMMV(DragCtrl.Top),
                               PixelsToMMH(DragCtrl.Left) + PixelsToMM(DragCtrl.Width),
                               PixelsToMMV(DragCtrl.Top) + PixelsToMM(DragCtrl.Height));

        Case FormDef.fdFieldClass Of
          { data controls }
          fdcTable,
          fdcDbfield,
          fdcFormula    : Begin
                            SetPen   (clGray, psSolid, -1, pmCopy);
                            SetBrush (clWhite, bsClear, Nil);

                            Rectangle (PixelsToMMH(DragCtrl.Left),
                                       PixelsToMMV(DragCtrl.Top),
                                       PixelsToMMH(DragCtrl.Left) + PixelsToMM(DragCtrl.Width),
                                       PixelsToMMV(DragCtrl.Top) + PixelsToMM(DragCtrl.Height));
                            DoFont   (ftSmall);
                            TextRect  (CtrlRect, PixelsToMMH(DragCtrl.Left) + (0.1 * PixelsToMM(DragCtrl.Height)), PixelsToMMV(DragCtrl.Top) + (0.9 * PixelsToMM(DragCtrl.Height)), ControlId);
                          End;
          (* Doesn't print correctly on all printers
          fdcText,
          fdcLine,
          fdcBitmap,
          fdcBox,
          fdcPage,
          fdcGroup      : Begin
                            SetPen   (clSilver, psDot, -1, pmCopy);
                            SetBrush (clWhite, bsClear, Nil);

                            Rectangle (PixelsToMMH(DragCtrl.Left),
                                       PixelsToMMV(DragCtrl.Top),
                                       PixelsToMMH(DragCtrl.Left) + PixelsToMM(DragCtrl.Width),
                                       PixelsToMMV(DragCtrl.Top) + PixelsToMM(DragCtrl.Height));
                          End;
          *)
        End; { Case }
      End; { With }
    End; { For }
  End; { With }
end;

procedure TForm_TechSupp.ReportFiler1BeforePrint(Sender: TObject);
begin
  With TheReport Do Begin
    Orientation := RpDev.Orientation;
  End; { With }
end;

end.
