unit CHK4USER;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_DEPRECATED OFF}

interface

Uses Classes, Dialogs, Forms, Graphics, Messages, SysUtils, Windows, RPDefine,
     RPDevice, RPBase, RPFiler, Controls, RPCanvas, RPFPrint;

type
  tsFontTypeList = (ftHdr, ftNormal, ftSmall, ftBNormal, ftBNormal12, ftWarning);

  TdmCheckForUsersRep = class(TDataModule)
    ReportFiler1: TReportFiler;
    FilePrinter1: TFilePrinter;
    procedure ReportFiler1Print(Sender: TObject);
    procedure ReportFiler1BeforePrint(Sender: TObject);
    procedure ReportFiler1NewPage(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Procedure DoFont (Const FontType : tsFontTypeList);
    Procedure ListLoginRefs (Const SysId     : Char;
                             Const CompanyId : LongInt;
                             Const SysDesc   : ShortString;
                             Var   RefCount  : LongInt);
    procedure StartPosition;
  public
    { Public declarations }
    GotData : Boolean;
    ParForm : TForm;
  end;

// Prints the Check For Users Report
Procedure CheckForUsers (Const ParentForm : TForm);

implementation

{$R *.DFM}

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, SecWarn2,
     CompUtil, SecureU, BtSupU1, LicRec, WLicFile, HelpSupU, EntLic, SerialU,
     GlobExch, sysU3, VarFPosU, UserSec, ProgF, Excep3U, PreviewF,
     PrintToF,        // Generic Select Printer dialog
     SQLUtils,
     ChkComp;

//---------------------------------------------------------------------------

(*****
Type
  TMCMListType = Class(TObject)
  Public
    mlCompDet : CompanyDetRec;
    mlStatus  : SmallInt;
  End; { MCMListType }

// Prints the Check For Users Report
Procedure CheckForUsers (Const CompList : TForm);
Var
  MCMList        : TList;
  oCompany       : TMCMListType;
  KeyS           : Str255;
  lStatus, I     : SmallInt;
WantReset, WantDelay : Boolean;
Begin { CheckForUsers }
WantReset := MessageDlg('Reset Btrieve after each check?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
WantDelay := MessageDlg('Pause between checks?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;

  MCMList := TList.Create;
  Try
    { Load list of companies into MCMList }
    KeyS := cmCompDet;
    lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (lStatus = 0) And (Company^.RecPFix = cmCompDet) Do Begin
      { Create object to hold company details }
      oCompany := TMCMListType.Create;
      With oCompany Do Begin
        mlCompDet := Company^.CompDet;
        mlCompDet.CompPath := IncludeTrailingBackslash(Trim(mlCompDet.CompPath));
        mlStatus := 0;
      End; { With }

      { Add into list }
      MCMList.Add (oCompany);

      { get next company details }
      lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While (LStatus = 0) ... }

    { Close all open Btrieve files and Reset Btrieve }
    Close_File (F[MiscF]);
    Close_File (F[CompF]);
    If WantReset Then Reset_B;

    { Run through the list doing an exclusive check on each company data set }
    If (MCMList.Count > 0) Then
      With TfrmProgress.Create (CompList) Do
        Try
          // Display Progress Window
          Show;

          For I := 0 To Pred(MCMList.Count) Do Begin
            { Extract company details from list }
            oCompany := TMCMListType(MCMList.Items[I]);
            With oCompany Do Begin
              { update progress }
              ProgressText := 'Scanning Company Data Set: ' +
                              Trim(mlCompDet.CompCode) + ' - ' +
                              Trim(mlCompDet.CompName);

If WantDelay Then
              // Delay to fix problem found in Ent with Novel 32 Client
              BTDelay(2000+(5000*Ord(MUDelay2)));

              // Try to open JMiscF exclusively - if successful reset the Logged In User
              // Count and Company / Workstation Cross-Reference records
              mlStatus := Open_File(F[JMiscF], mlCompDet.CompPath + FileNames[JMiscF], -4);
              If (mlStatus = 0) Then
                // Opened OK - Close immediately
                Close_File (F[JMiscF]);

              { Reset Btrieve to ensure no conflicts }
              If WantReset Then Reset_B;
            End; { With oCompany }
          End; { For I }
        Finally
          Free;
        End;

    { Re-open normal data files }
    Open_File(F[CompF], SetDrive + FileNames[CompF], 0);
    Open_File(F[MiscF], SetDrive + FileNames[MiscF], 0);
  Finally
    MCMList.Free;
  End;
End; { CheckForUsers }
****)

// Prints the Check For Users Report
Procedure CheckForUsers (Const ParentForm : TForm);
Var
  PrintJobInfo : TSBSPrintSetupInfo;

  Function GetUniqueName (BaseDir : ShortString)  : ShortString;
  Var
    RepFName : ShortString;
    FVar     : LongInt;
  Begin { GetUniqueName }
    Result := '';

    { Ensure path is formatted correctly }
    BaseDir := IncludeTrailingBackslash(UpperCase(Trim(BaseDir)));

    { Generate Unique Filename for report file }
    FVar := 0;
    Repeat
      RepFName := BaseDir + '!REP' + IntToStr(FVar) + '.SWP';
      Inc (FVar);
    Until (Not FileExists (RepFName)) Or (FVar > 9999);

    { Check filename was found OK }
    If (FVar > 9999) Then
      Raise Exception.Create('Unable to generate Unique Filename, please check SWAP directory')
    Else
      Result := RepFName;
  End; { GetUniqueName }

Begin { CheckForUsers }
//  // Get Printer Details for Output
//  If RPDev.PrinterSetupDialog Then

  // Show Select Printer dialog
  If ShowPrintTo (ParentForm, 'Print Logged In User Report To', PrintJobInfo) Then
  Begin
    // Create and configure report object
    With TdmCheckForUsersRep.Create (ParentForm) Do
    Begin
      Try
        ParForm := ParentForm;

        // Execute Report - Checks companies and prints report simultaneously
        RpDev.SetPrnSetup(PrintJobInfo);
        ReportFiler1.FileName := GetUniqueName(IncludeTrailingBackslash(SetDrive) + GetSwapDir);
        ReportFiler1.Execute;

        Try
          If GotData Then
          Begin
            If PrintJobInfo.Preview Then
            Begin
              // Display Preview Window
              PreviewReport (ParentForm, ReportFiler1.FileName, PrintJobInfo);
            End // If PrintJobInfo.Preview
            Else
            Begin
              // Printer
              FilePrinter1.FileName := ReportFiler1.FileName;
              FilePrinter1.Execute;
            End;
          End // If GotData
          Else
          Begin
            If FileExists (ReportFiler1.FileName) Then SysUtils.DeleteFile(ReportFiler1.FileName);
            MessageDlg ('No users were detected as being logged into any of the Companies at this time',
                        mtInformation, [mbOk], 0)
          End; // Else
        Finally
          // Remove the temporary file
          DeletePrintFile (ReportFiler1.FileName);
        End; // Try..Finally
      Finally
        Free;
      End;
    End; // With TdmCheckForUsersRep.Create (ParentForm)
  End; // If ShowPrintTo (ParentForm, ...
End; { CheckForUsers }

procedure TdmCheckForUsersRep.ReportFiler1Print(Sender: TObject);
Var
  TmpRecAddr         : LongInt;
  TmpKPath, TmpStat  : Integer;
  lCompany           : CompRec;
  KeyS               : Str255;
  lStatus            : SmallInt;
  DPath              : ShortString;
  Res, RefCount      : LongInt;


  Procedure KillSwap (Const DataPath : ShortString);
  Var
    NetFInfo : TSearchRec;
    SrchRes  : Integer;
  Begin { KillSwap }
    Try
      SrchRes := FindFirst(DPath + 'Swap\*.*', faAnyFile, NetFInfo);
      Try
        While (SrchRes = 0) Do Begin
          If ((NetFInfo.Attr And faDirectory) <> faDirectory) Then Begin
            // Not a subdirectory
            SysUtils.DeleteFile (DPath + 'Swap\' + NetFInfo.Name);
          End; { If }

          SrchRes := FindNext(NetFInfo);
        End; { While }
      Finally
        FindClose (SrchRes);
      End;
    Except
      On Exception Do
        ;
    End;
  End; { KillSwap }

begin
  // Create Progress Form
  With TfrmProgress.Create (ParForm) Do
    Try
      // Move to start position on report
      StartPosition;

      // Display Progress
      Show;

      // Run through Company Details attempting to get exlusive access,
      // if gained then reset the Logged In User Count to Zero and
      // remove any XRef records, if failed add the company into the report

      KeyS := cmCompDet;
      lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
      While (LStatus = 0) And (Company^.RecPFix = cmCompDet) Do Begin
        // Update progress window
        ProgressText := 'Scanning Company Data Set: ' +
                        Trim(Company.CompDet.CompCode) + ' - ' +
                        Trim(Company.CompDet.CompName);

        // Check out the company data set
        CheckCompanyDir (Company^.CompDet);

        // reformat path from company details as it is ' ' padded
        DPath := IncludeTrailingBackslash(Trim(Company^.CompDet.CompPath));

        // Delay to fix problem found in Ent with Novel 32 Client
        BTDelay(2000+(5000*Ord(MUDelay2)));

        // MH 16/06/08: Modified to use alternate check for SQL Edition
        If SQLUtils.UsingSQL Then
        Begin
          If SQLUtils.ExclusiveAccess(DPath) Then
            lStatus := 0
          Else
            lStatus := 3;
        End // If SQLUtils.UsingSQL
        Else
        Begin
          // Try to open JMiscF exclusively - if successful reset the Logged In User
          // Count and Company / Workstation Cross-Reference records
          lStatus := Open_File(F[JMiscF], DPath + FileNames[JMiscF], -4);
          If (lStatus = 0) Then
            // Opened OK - Close immediately
            Close_File (F[JMiscF]);
        End; // Else

        If (lStatus = 0) Then Begin
          // Reset User Count
          Res := ResetEntUserCount (DPath);
          If (Res = 0) Then
            Res := RemoveCIDLoginRef (Company^.CompDet.CompId);

          // HM 22/04/02: Remove swap files from data set SWAP directory
          KillSwap (DPath);
        End { If (lStatus = 0) }
        Else
          // Open Failed - Someone Using System - Add Into Report
          With ReportFiler1 Do Begin
            GotData := True;

            If (LinesLeft < 4) Then NewPage;

            DoFont (ftBNormal);
            Print (Trim(Company.CompDet.CompCode) + ' - ' + Trim(Company.CompDet.CompName));
            If (Company^.CompDet.CompAnal <> 1) Then
              // Error during analysis of Company Data Set
              Print ('  (' + GetCompDirError(Company^.CompDet.CompAnal) + ')');
            CRLF;
            DoFont (ftNormal);

            // List any Company / Workstation Cross-Reference records for the Company Id

            // Save existing position
            lCompany := Company^;
            TmpKPath := CompCodeK;
            TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOff,BOff);

            // Print Login Reference record details
            Refcount := 0;
            ListLoginRefs (cmUserCount, Company.CompDet.CompId, 'Accounts', RefCount);
            Company^ := lCompany;
            ListLoginRefs (cmTKUserCount, Company.CompDet.CompId, 'Toolkit', RefCount);
            Company^ := lCompany;
            ListLoginRefs (cmTradeUserCount, Company.CompDet.CompId, 'Trade Counter', RefCount);

            // Add Warning about unmonitored applications
            If (lCompany.CompDet.CompAnal <> 101) Then Begin
              DoFont (ftWarning);
              If (RefCount = 0) Then
                PrintLn (#9 + 'WARNING: The Data Set is in use by unidentified modules')
              Else
                PrintLn (#9 + 'WARNING: The Data Set may also be in use by other unidentified modules');
            End; { If }

            // restore original position
            If (TmpStat = 0) Then TmpStat := Presrv_BTPos(CompF,TmpKPath,F[CompF],TmpRecAddr,BOn,BOff);
            Company^ := lCompany;

            CRLF;
          End; { With ReportFiler1 }

        lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);

        // HM 11/12/01: Added to allow screen re-painting to work
        Application.ProcessMessages;
      End; { While (LStatus = 0) ... }
    Finally
      Free;
    End;
end;

Procedure TdmCheckForUsersRep.ListLoginRefs (Const SysId     : Char;
                                             Const CompanyId : LongInt;
                                             Const SysDesc   : ShortString;
                                             Var   RefCount  : LongInt);
Var
  KeyS     : Str255;
  lStatus  : SmallInt;
Begin { ListLoginRefs }
  KeyS := SysId + FullNomKey (CompanyId);
  lStatus := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  While (lStatus = 0) And (Company^.RecPFix = SysId) And (Company^.UserRef.ucCompanyId = CompanyId) Do Begin
    With ReportFiler1, Company^.UserRef Do Begin
      If (LinesLeft < 4) Then NewPage;
      PrintLn (#9 + SysDesc + #9 + Trim(ucUserId) + #9 + Trim(ucWStationId) + #9 + IntToStr(ucRefCount));

      Inc(RefCount);
    End; { With ReportFiler1, Company^.UserRef }

    lStatus := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  End; { While ... }
End; { ListLoginRefs }

Procedure TdmCheckForUsersRep.DoFont (Const FontType : tsFontTypeList);
Begin
  With ReportFiler1 Do Begin
    FontName := 'Arial';
    FontColor := clBlack;
    Bold := False;
    Italic := False;
    UnderLine := False;

    SetPen (clBlack, psSolid, -1, pmCopy);
    SetBrush (clWhite, bsClear, Nil);

    Case FontType Of
      ftHdr       : Begin
                      FontSize := 12;
                      Bold := True;
                    End;
      ftNormal    : Begin
                      FontSize := 10;
                    End;
      ftSmall     : Begin
                      FontSize := 8;
                    End;
      ftBNormal   : Begin
                      FontSize := 10;
                      Bold := True;
                    End;
      ftBNormal12 : Begin
                      FontSize := 12;
                      Bold := True;
                    End;
      ftWarning   : Begin
                      FontSize := 8;
                      Italic := True;
                    End;
    End; { Case }
  End; { With }
End;

procedure TdmCheckForUsersRep.ReportFiler1BeforePrint(Sender: TObject);
begin
  With ReportFiler1 Do Begin
    Orientation := poPortrait;

    MarginLeft   := 2 * LeftWaste;
    MarginRight  := 2 * RightWaste;
    MarginTop    := 2 * TopWaste;
    MarginBottom := 2 * BottomWaste;
  End; { With ReportFiler1 }
end;

procedure TdmCheckForUsersRep.ReportFiler1NewPage(Sender: TObject);
Var
  Y1 : LongInt;
begin
  With ReportFiler1 Do Begin
    Home;

    DoFont (ftNormal);
    PrintRight  (FormatDateTime ('HH:MM DD/MM/YYYY', Now), PageWidth - MarginRight);
    CRLF;
    DoFont (ftBNormal12);
    PrintLeft ('Logged In User Report', MarginLeft);
    DoFont (ftNormal);
    PrintRight (UpperCase('Page ' + IntToStr(CurrentPage)) + ' Of ' + Macro(MidTotalPages), PageWidth - MarginRight);
    CRLF;
    CRLF;

    ClearTabs;
    SetTab (MarginLeft + 5, pjLeft, 40,  4, 0, 0);
    SetTab (NA,             pjLeft, 40,  4, 0, 0);
    SetTab (NA,             pjLeft, 40,  4, 0, 0);
    SetTab (NA,             pjLeft, 40,  4, 0, 0);
    DoFont (ftBNormal);
    Print (#9'System'#9'Windows User Id'#9'Workstation Id'#9'Instances');
    Y1 := CursorYPos;
    CRLF;
    SetPen   (clBlack, psSolid, -2, pmCopy);
    MoveTo (MarginLeft, YD2U(Round((CursorYPos + Y1) / 2)));
    LineTo (PageWidth - MarginRight, YD2U(Round((CursorYPos + Y1) / 2)));
    CRLF;
    DoFont (ftNormal);

    StartPosition;
  End; { With }
end;

procedure TdmCheckForUsersRep.StartPosition;
Begin
  With ReportFiler1 Do Begin
    Home;
    CRLF;
    CRLF;
    CRLF;
    CRLF;
    CRLF;
  End; { With }
End;

procedure TdmCheckForUsersRep.DataModuleCreate(Sender: TObject);
begin
  GotData := False;
end;

end.
