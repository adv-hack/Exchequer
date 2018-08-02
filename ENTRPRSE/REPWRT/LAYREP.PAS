unit layrep;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, Graphics, SysUtils, Windows, GlobVar, VarConst,
     RPBase, RpFiler, RpDefine, RpDevice;

Type
  TLayoutReport = Class(TObject)
  Private
    ReportFiler : TReportFiler;

    Procedure DoFont (Const FontType : Byte);
    Procedure LRNewPage(Sender: TObject);
    Procedure LROnPrint(Sender: TObject);
    Procedure LRFooter(Sender: TObject);
    procedure SetMargins;
    Procedure SetTabs(TabSet : Byte);
  Public
    LRName : ShortString;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure Execute;
  End; { TLayoutReport }

implementation

Uses BtrvU2, BtSupU1, EtStrU, RwOpenF, RWPrintR, VarFPosu, RpCommon, InvListU,
     RepLine;

Constructor TLayoutReport.Create;
Begin
  Inherited Create;

  ReportFiler := Nil;
End;

Destructor TLayoutReport.Destroy;
Begin
  If Assigned(ReportFiler) Then ReportFiler.Free;

  Inherited Destroy;
End;

Procedure TLayoutReport.Execute;
Var
  PrnInfo : TSBSPrintSetupInfo;
Begin
  Try
    If RpDev.PrinterSetupDialog Then Begin
      ReportFiler := TReportFiler.Create(Application.MainForm);
      Try
        With ReportFiler Do Begin
          FileName         := GetTempFName('!REP');
          LineHeightMethod := lhmFont;
          Orientation      := poLandscape;
          PrinterIndex     := RpDev.DeviceIndex;
          Units            := unMM;

          OnNewPage := LRNewPage;
          OnPrint   := LROnPrint;
          OnPrintFooter := LRFooter;
        End; { With }

        { print }
        ReportFiler.Execute;

        { Preview }
        PrnInfo := RpDev.SBSSetupInfo;
        With PrnInfo Do Begin
          NoCopies := 1;
          Preview := True;
        End; { With }
        PrintFileTo (PrnInfo, ReportFiler.FileName, 'Report Layout');
      Finally
        ReportFiler.Free;
        ReportFiler := Nil;
      End;
    End; { If }
  Except
    On Ex:Exception Do
      MessageDlg ('The following error occurred printing the Report Layout, ''' +
                  Ex.Message + '''. Please contact your Technical Support.', mtError,
                  [mbOk], 0);
  End;
End;

Procedure TLayoutReport.DoFont (Const FontType : Byte);
Begin
  With ReportFiler Do Begin
    FontName := 'Arial';
    FontColor := clBlack;
    Bold := False;
    UnderLine := False;

    SetPen (clBlack, psSolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    Case FontType Of
      0  : Begin
             FontSize := 12;
             Bold := True;
           End;
      1  : Begin
             FontSize := 10;
           End;
      2  : Begin
             FontSize := 10;
             Bold := True;
           End;
      3  : Begin
             FontSize := 14;
             Bold := True;
           End;
    End; { Case }
  End; { With }
End;

procedure TLayoutReport.SetMargins;
Begin
  With ReportFiler Do Begin
    { set the margins - Landscape}
    MarginLeft   := 2 * TopWaste;
    MarginRight  := 2 * BottomWaste;
    MarginTop    := 2 * RightWaste;
    MarginBottom := 2 * LeftWaste;
  End; { With }
End;

Procedure TLayoutReport.LRNewPage(Sender: TObject);
Var
  Y1 : LongInt;
begin
  With ReportFiler Do Begin
    SetMargins;
    Home;
    CRLF;

    DoFont (0);
    { Print Company & Date/Time }
    PrintLeft  (Syss.UserName, MarginLeft);
    {PrintRight (TimeToStr(Now) + ' - ' + DateToStr(Now), PageWidth - MarginRight);}
    PrintRight (Macro(midCurrentPage) + ' of ' + Macro(midTotalPages), PageWidth - MarginRight);
    DoFont (3);
    PrintCenter ('Report Layout', PageWidth / 2.0);
    DoFont (0);

    { Print Separator Line }
    Y1 := CursorYPos;
    CRLF;
    SetPen   (clBlack, psSolid, -2, pmCopy);
    MoveTo (MarginLeft, YD2U(Round((CursorYPos + Y1) / 2)));
    LineTo (PageWidth - MarginRight, YD2U(Round((CursorYPos + Y1) / 2)));
    CRLF;
  End; { With }
End;

Procedure TLayoutReport.SetTabs(TabSet : Byte);
Begin
  With ReportFiler Do Begin
    ClearTabs;

    Case TabSet Of
      1 : Begin
            SetTab (MarginLeft + 45, pjLeft, 48,  4, 0, 0);
            SetTab (NA,              pjLeft, 48,  4, 0, 0);
            SetTab (NA,              pjLeft, 48,  4, 0, 0);
            SetTab (NA,              pjLeft, 48,  4, 0, 0);
            SetTab (NA,              pjLeft, 48,  4, 0, 0);
          End;
      2 : Begin
            SetTab (MarginLeft + 15, pjLeft,   20, 4, 0, 0); { Variable }
            SetTab (NA,              pjLeft,   40, 4, 0, 0); { desc }
            SetTab (NA,              pjLeft,   30, 4, 0, 0); { title }
            SetTab (NA,              pjRight,  12, 4, 0, 0); { char width }
            SetTab (NA,              pjRight,  12, 4, 0, 0); { MM width }
            SetTab (NA,              pjRight,   8, 4, 0, 0); { decs }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Print }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Subtotal }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Sort }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Break }
            SetTab (NA,              pjCenter, 20, 4, 0, 0); { Period/Year }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Currency }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Debit/Credit }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Summary }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Select on Summary }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Recalc on Break }
            SetTab (NA,              pjCenter, 15, 4, 0, 0); { Input Link }
          End;
      3 : Begin
            SetTab (MarginLeft + 10, pjLeft,   40, 4, 0, 0);
            SetTab (NA,              pjLeft,  200, 4, 0, 0); { Formula, rec select, print select }
          End;
      4 : Begin
            SetTab (MarginLeft + 15, pjLeft,   40, 4, 0, 0); { Description }
            SetTab (NA,              pjLeft,   40, 4, 0, 0); { Type }
            SetTab (NA,              pjLeft,   50, 4, 0, 0); { Val1 }
            SetTab (NA,              pjLeft,   50, 4, 0, 0); { Val2 }
          End;
      5 : Begin
            SetTab (MarginLeft + 15, pjLeft,   20, 4, 0, 0); { Code }
            SetTab (NA,              pjLeft,   50, 4, 0, 0); { Description }
            SetTab (NA,              pjLeft,   50, 4, 0, 0); { Calculation }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Break }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Print }
            SetTab (NA,              pjCenter, 10, 4, 0, 0); { Subtotal }
          End;
    End; { Case }
  End; { With }
End;

Procedure TLayoutReport.LROnPrint(Sender: TObject);
Const
  FNum    = RepGenF;
  KeyPath : SmallInt = RGK;
Var
  KeyS,
  KeyChk :  Str255;
  Y1 : LongInt;
  FirstTime : Boolean;

  Function RepTypeToStr : ShortString;
  Begin
    Case RepGenRecs^.ReportHed.RepType Of
      'H' : Result := RepHedTypesL^[1];
      'N' : Result := RepHedTypesL^[3];
      'R' : Result := RepHedTypesL^[2];
    Else
      Result := 'Unknown';
    End; { Case }
  End;

  Function BoolToStr(BoolVal : Boolean) : ShortString;
  Begin
    If BoolVal Then Result := 'Yes' Else Result := 'No';
  End;

  Function NomDesc (Const FieldCode : ShortString) : ShortString;
  Var
    OrigNom : ^NominalRec;
    RetCode : LongInt;
  Begin
    Result := '';

    If (FieldCode <> '+') Then Begin
      New (OrigNom);
      OrigNom^ := Nom;

      If GetNom (Application.MainForm, FieldCode, RetCode, -1) Then
        Result := Trim(Nom.Desc);

      Nom := OrigNom^;
      Dispose (OrigNom);
    End; { If }
  End;

  Function DictDesc (Const FieldCode : ShortString) : ShortString;
  Var
    DataRec : DataDictRec;
  Begin
    Result := '';

    If GetDDField (FieldCode, DataRec) Then
      Result := DataRec.DataVarRec.VarDesc;
  End;

Begin
  With ReportFiler Do Begin
    { Printer Report Header info }
    With RepGenRecs^.ReportHed Do Begin
      DoFont (0);
      PrintLn (RepTypeToStr + ': ' + Trim(RepName) + ' - ' + Trim(RepDesc) + '  (Heading: ' + Trim(RepGroup) + ')');
      DoFont (1);

      SetTabs (1);
      If (DriveFile In [3, 4, 23]) Then Begin
        PrintLn ('File:' + #9 + DataFilesL^[DriveFile] + #9 +
                 'Index:' + #9 + FastNDXHedL^[DriveFile, DrivePath] + #9  +
                 'Input Link:' + #9 + IntToStr(FNDXInpNo));
      End { If }
      Else
        PrintLn ('File:' + #9 + DataFilesL^[DriveFile]);
      PrintLn ('Test Mode:' + #9 + BoolToStr(TestMode) + #9 +
               'Sample Count:' + #9 + IntToStr(SampleNo) + #9 +
               'Refresh - Start: ' + BoolToStr(RefreshPos) +
               '  End: ' + BoolToStr(RefreshEnd));
      If (RepDest = 1) Then
        PrintLn ('Output To:'#9'Printer'#9 +
                 'Paper Orientation: ' + #9 + PaprOrient + #9 +
                 'Column Spacing:' + #9 + IntToStr(ColSpace))
      Else
        PrintLn ('Output To:'#9'CSV'#9 +
                 'Paper Orientation: ' + #9 + PaprOrient + #9 +
                 'Column Spacing:' + #9 + IntToStr(ColSpace));
      PrintLn ('Global Report Selection:' + #9 + RepSelect);
    End; { With }

    { Print Header Line info }
    FirstTime := True;
    KeyChk:=FullRepKey(ReportGenCode,RepRepCode,LRName)+RepHedTyp;
    KeyS:=KeyChk;
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) Do Begin
      If (LinesLeft <= 4) Or FirstTime Then Begin
        { out of room - do page break }
        If (LinesLeft <= 4) Or (FirstTime And (LinesLeft <= 6)) Then NewPage;

        { print section header }
        CRLF;
        DoFont (0);
        PrintLn ('Header Lines');
        DoFont (2);
        SetTabs(2);
        PrintLn ('Field'#9+
                 'Variable'#9+
                 'Description'#9+
                 'Title'#9+
                 'ChW'#9+
                 'mmW'#9+
                 'Dp'#9+
                 'Prn'#9+
                 'Sub'#9+
                 'Sort'#9+
                 'Brk'#9+
                 'Per/Yr'#9+
                 'Cur'#9+
                 'D/C'#9+
                 'Sum'#9+
                 'Sel'#9+
                 'Rec'#9+
                 'ILnk');
        DoFont (1);

        FirstTime := False;
      End; { If }

      With RepGenRecs^.ReportDet Do Begin
        SetTabs(2);
        PrintLn (VarType + RepPadNo + #9 +
                 VarRef + #9 +
                 DictDesc(VarRef) + #9 +
                 RepLDesc + #9 +
                 IntToStr(VarLen) + #9 +
                 IntToStr(MMWidth) + #9 +
                 IntToStr(NoDecs) + #9 +
                 BoolToStr(PrintVar) + #9 +
                 BoolToStr(SubTot) + #9 +
                 SortOrd + #9 +
                 BreakTypL^[Break] + #9 +
                 RepLPr[BOff] + '/' + RepLPr[BOn] + #9 +
                 IntToStr(RepLCr) + #9 +
                 BoolToStr(CDrCr) + #9 +
                 BoolToStr(Summary) + #9 +
                 BoolToStr(ApplyPSumm) + #9 +
                 BoolToStr(ReCalcBTot) + #9 +
                 IntToStr(InputLink));

        SetTabs(3);
        PrintLn (#9'Calculation:'#9 + VarSubSplit);
        PrintLn (#9'Record Selection:'#9 + RecSelect);
        PrintLn (#9'Print Selection:'#9 + PrintSelect);
      End; { With }

      { Get next record }
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; { While }

    { Print Report Line info }
    FirstTime := True;
    KeyChk:=FullRepKey(ReportGenCode,RepRepCode,LRName)+RepRepCode;
    KeyS:=KeyChk;
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) Do Begin
      If (LinesLeft <= 4) Or FirstTime Then Begin
        { out of room - do page break }
        If (LinesLeft <= 4) Or (FirstTime And (LinesLeft <= 6)) Then NewPage;

        { print section header }
        CRLF;
        DoFont (0);
        PrintLn ('Report Lines');
        DoFont (2);
        SetTabs(2);
        PrintLn ('Field'#9+
                 'Variable'#9+
                 'Description'#9+
                 'Title'#9+
                 'ChW'#9+
                 'mmW'#9+
                 'Dp'#9+
                 'Prn'#9+
                 'Sub'#9+
                 'Sort'#9+
                 'Brk'#9+
                 'Per/Yr'#9+
                 'Cur'#9+
                 'D/C'#9+
                 'Sum'#9+
                 'Sel'#9+
                 'Rec'#9+
                 'ILnk');
        DoFont (1);

        FirstTime := False;
      End; { If }

      With RepGenRecs^.ReportDet Do Begin
        SetTabs(2);
        PrintLn (VarType + RepPadNo + #9 +
                 VarRef + #9 +
                 DictDesc(VarRef) + #9 +
                 RepLDesc + #9 +
                 IntToStr(VarLen) + #9 +
                 IntToStr(MMWidth) + #9 +
                 IntToStr(NoDecs) + #9 +
                 BoolToStr(PrintVar) + #9 +
                 BoolToStr(SubTot) + #9 +
                 SortOrd + #9 +
                 BreakTypL^[Break] + #9 +
                 RepLPr[BOff] + '/' + RepLPr[BOn] + #9 +
                 IntToStr(RepLCr) + #9 +
                 BoolToStr(CDrCr) + #9 +
                 BoolToStr(Summary) + #9 +
                 BoolToStr(ApplyPSumm) + #9 +
                 BoolToStr(ReCalcBTot) + #9 +
                 IntToStr(InputLink));

        SetTabs(3);
        PrintLn (#9'Calculation:'#9 + VarSubSplit);
        PrintLn (#9'Record Selection:'#9 + RecSelect);
        PrintLn (#9'Print Selection:'#9 + PrintSelect);
      End; { With }

      { Get next record }
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; { While }

    { Print Input Line info }
    FirstTime := True;
    KeyChk:=FullRepKey(ReportGenCode,RepLineTyp,LRName);
    KeyS:=KeyChk;
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) Do Begin
      If (LinesLeft <= 4) Or FirstTime Then Begin
        { out of room - do page break }
        If (LinesLeft <= 4) Or (FirstTime And (LinesLeft <= 6)) Then NewPage;

        { print section header }
        CRLF;
        DoFont (0);
        PrintLn ('Input Lines');
        DoFont (2);
        SetTabs(4);
        PrintLn ('Field'#9+
                 'Description'#9+
                 'Type'#9+
                 'Val1'#9+
                 'Val2');
        DoFont (1);

        FirstTime := False;
      End; { If }

      With RepGenRecs^.ReportDet Do Begin
        SetTabs(4);
        Print (VarType + RepPadNo + #9 +
                 RepLDesc + #9 +
                 RepInpTypesL^[RepLIType] + #9);

        Case RepLIType Of
          { Date }
          1  : PrintLn (DRange[1] + #9 + DRange[2]);
          { Period }
          2  : PrintLn (IntToStr(PrRange[1,1])+'/'+IntToStr(PrRange[1,2]) + #9 +
                        IntToStr(PrRange[2,1])+'/'+IntToStr(PrRange[2,2]));
          { Value }
          3  : PrintLn (SysUtils.Format('%0.2f', [VRange[1]]) + #9 + SysUtils.Format('%0.2f', [VRange[2]]));
          { Currency }
          5  : PrintLn (IntToStr(CrRange[1]) + #9 + IntToStr(CrRange[2]));
          4,         { ASCII }
          6,         { Document No. }
          7,         { Customer Code }
          8,         { Supplier Code }
          9,         { Nominal Code }
          10,        { Stock Code }
          11,        { Cost Centre Code }
          12,        { Department Code }
          13,        { Location Code }
          17 : Begin { Job Code }
                 PrintLn (ASCStr[1] + #9 + ASCStr[2]);
               End;
        Else
          PrintLn ('Unknown Data');
        End; { Case }
      End; { With }

      { Get next record }
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; { While }

    { Print Nominal Line info }
    FirstTime := True;
    KeyChk:=FullRepKey(ReportGenCode,RepNomCode,LRName);
    KeyS:=KeyChk;
    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) Do Begin
      If (LinesLeft <= 4) Or FirstTime Then Begin
        { out of room - do page break }
        If (LinesLeft <= 4) Or (FirstTime And (LinesLeft <= 6)) Then NewPage;

        { print section header }
        CRLF;
        DoFont (0);
        PrintLn ('Nominal Lines');
        DoFont (2);
        SetTabs(5);
        PrintLn ('Field'#9+
                 'Code'#9 +
                 'Description'#9+
                 'Calculation'#9+
                 'Brk'#9+
                 'Prn'#9 +
                 'Sub');
        DoFont (1);

        FirstTime := False;
      End; { If }

      With RepGenRecs^.ReportNom Do Begin
        SetTabs(5);
        PrintLn (VarType + RepPadNo + #9 +
                 NomRef + #9 +
                 NomDesc (NomRef) + #9 +
                 VarSubSplit + #9 +
                 BreakTypL^[Break] + #9 +
                 BoolToStr(PrintVar) + #9 +
                 BoolToStr(SubTot));
      End; { With }

      { Get next record }
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    End; { While }
  End; { With }
End;

Procedure TLayoutReport.LRFooter(Sender: TObject);
{Var
  Y1 : LongInt;}
Begin
  (*With ReportFiler Do Begin
    { Print page footer with number of pages }
    YPos := PageHeight - 2 * LineHeight;
    Y1 := CursorYPos;
    CRLF;
    SetPen   (clBlack, psSolid, -2, pmCopy);
    MoveTo (MarginLeft, YD2U(Round((CursorYPos + Y1) / 2)));
    LineTo (PageWidth - MarginRight, YD2U(Round((CursorYPos + Y1) / 2)));
  End; { With }*)
End;

end.

