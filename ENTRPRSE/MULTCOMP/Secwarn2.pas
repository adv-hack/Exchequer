unit SecWarn2;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

{$WARN UNIT_PLATFORM OFF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, IniFiles, LicRec, ComCtrls, TEditVal,
  FileCtrl;

type
  TfrmSecWarn = class(TSetupTemplate)
    Notebook1: TNotebook;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    ccySecDays: TCurrencyEdit;
    SBSUpDown1: TSBSUpDown;
    Label7: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    lblExpDate: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure ccySecDaysChange(Sender: TObject);
    procedure SBSUpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetSecDays;
    Procedure SetupDlg;
  end;

Var
  IAOSecOverride : Boolean = False;

{ Display the Single-CD Security Warning Wizard }
Function SCD_SecWarnWizard (Const CompDir, EntDir : ShortString;
                            Const Mode            : Byte;
                            Var   TempLicR        : EntLicenceRecType;
                            Var   SetRelCode      : Byte) : LongInt;

Function MCM_SECWIZARD (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt; StdCall; Export;

implementation

{$R *.DFM}

Uses GlobVar, VarConst, EtDateU, EtStrU, EtMiscU, SecWarn3, CommsInt, CustDets,
     GlobExcH, BtrvU2, BtSupu1, HelpSupU, entLic, SecureU, SysU3, ReplSysF,
     SecSup2U, APIUtil, EntLicence,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     ActivateF;

//-------------------------------------------------------------------------

// Wrapper functions around SCD_SecWarnWizard for running the Release Code wizard
// from outside the setup program
//
// Mode: 1=SCuD Install, 2=SCud Upgrade, 3=MCM, 4=Ent
//
// Results:-
//  0           OK
//  1           Already Fully Released
//  2           Release Code Entered
//  1000        Unknown Error
//  1001        Unknown Exception
//  1100..1199  Btrieve Error opening SysF
//  1200..1299  Btrieve Error Opening PwrdF
//  1300        Unknown Error Reading Enterprise Licence File
//  10000+      Error in SCD_SecWarnWizard
Function MCM_SECWIZARD (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt;
Var
  TempLicR           : EntLicenceRecType;
  Locked, NeedRepl   : Boolean;
  ErrDir, lCompDir   : ShortString;
  Res                : LongInt;
  DoneRelCode        : Byte;
Begin { MCM_SECWIZARD }
  Result := 1000;
  NeedRepl := False;

  Try
    { Set Help File path }
    Application.HelpFile := ExtractFilePath(Application.ExeName) + 'MCM.HLP';

    { HM 17/11/99: Added check of CompDir as Enterprise sometimes passes it in blank and everything goes tits up }
    lCompDir := Trim(CompDir);
    If (lCompDir = '') Then Begin
      { Blank - generate as .EXE dir }
      lCompDir := ExtractFilePath(Application.ExeName);
{$IFDEF EXSQL}
      if SQLUtils.TableExists(lCompDir + FileNames[SysF]) then
{$ELSE}
      If (Not FileExists(lCompDir + FileNames[SysF])) Then
{$ENDIF}
      Begin
        { No data - must be wrong directory }
        lCompDir := '';
      End; { If }
    End; { If }

    { open system file for main company }
    Status := Open_File(F[SysF], EntDir + FileNames[SysF], 0);
    If StatusOk Then Begin
      { Get ModR }
      Locked := False;
      Ok := GetMultiSys (BOff, Locked, ModRR);

      { Get SysR }
      Locked := False;
      Ok := GetMultiSys (BOff, Locked, SysR);

      { Check to see if need release code }
      If Not FullyReleased Then Begin
        { Open PwrdF }
        Status := Open_File(F[PwrdF], EntDir + FileNames[PwrdF], 0);
        If StatusOk Then Begin
          If ReadEntLic (lCompDir + EntLicFName, TempLicR) Then Begin
            // MH 10/03/06: Added check on Product Type
            If (EnterpriseLicence.elProductType In [ptLITECust, ptLITEAcct]) And (Not IAOSecOverride) Then
              // IAO Activation Wizard - ActivateF.Pas
              Res := IAO_ActivationWizard (lCompDir, EntDir, Mode, TempLicR, DoneRelCode)
            Else
              // Exchequer - Display Release Code wizard
              Res := SCD_SecWarnWizard (lCompDir, EntDir, Mode, TempLicR, DoneRelCode);

            If (Res = 0) And (DoneRelCode = 1) Then Begin
              // Remove Grace Period
              Syss.GracePeriod := 0;

              { Update SysR }
              PutMultiSys(SysR,BOn);

              { Update PwrdF shadow record }
              TrackSecUpdates(BOff);

              { Run replication if allowed }
              NeedRepl := True;

              Result := 2;
            End { If }
            Else Begin
              If (Res = 0) Then
                Result := 0
              Else
                Result := 10000 + Res;
            End; { If }
          End { If ReadEntLic }
          Else Begin
            { Error reading Enterprise Licence File }
            Result := 1300;
          End; { Else }

          { close system file for main company }
          Close_File(F[PwrdF]);
        End { If }
        Else Begin
          { Btrieve Error Opening PwrdF }
          Result := 1200 + Status;
        End; { Else }
      End { If }
      Else Begin
        { Fully released - no release code required }
        MessageDlg ('This system does not need a Security Release Code', mtInformation, [mbOk], 0);
        Result := 1;
      End; { Else }

      Close_File(F[SysF]);

      If Repl And NeedRepl Then Begin
        { Replication across all companies }
        ErrDir := EntDir;
        Res := ReplicateEntLicence (lCompDir, ErrDir);

        If (Res = 0) Then
          Result := 0
        Else Begin
          MessageDlg ('The following error occurred replicating the Release Code changes:-' + #13#13 +
                      'Error: ' + IntToStr(Res) + ' in ' + ErrDir, mtInformation, [mbOk], 0);
          Result := 20000 + Res;
        End; { Else }
      End; { If }
    End { If }
    Else Begin
      { Error opening SysF }
      Result := 1100 + Status;
    End; { Else }
  Except
    On Ex:Exception Do
      Result := 1001;
  End; { Try..Except }
End; { MCM_SECWIZARD }

//-------------------------------------------------------------------------

// Display the Single-CD Security Warning Wizard
//
// Mode: 1=SCuD Install, 2=SCud Upgrade, 3=MCM, 4=Ent
// SetRelCode: 0=Nothing, 1=Release Code Set
//
// 11000      Unknown Error
// 11001      Unknown Exceqption
Function SCD_SecWarnWizard (Const CompDir, EntDir : ShortString;
                            Const Mode            : Byte;
                            Var   TempLicR        : EntLicenceRecType;
                            Var   SetRelCode      : Byte) : LongInt;
Var
  BinIniF, UsrIniF     : TIniFile;
  frmSecWarn           : TfrmSecWarn;
  frmSecWarn2          : TfrmSecWarn2;
  CustDetsO            : TCustDetsDlg;
  Done, Cancel, First1 : Boolean;
  WizNo                : Byte;
  ExCode               : Char;
  TmpDir               : String;
  GotMAPI              : Boolean;
  CurSecy              : LongInt;
  OldAppHelp           : ShortString;
Begin { SCD_SecWarnWizard }
//ShowMessage ('SCD_SecWarnWizard.Start');
  Result := 11000;
  SetRelCode := 0;

  // HM 14/02/02: Modified to setup help file correctly
  OldAppHelp := Application.HelpFile;
  Application.HelpFile := EntDir + 'MCM.HLP';

  Try
    If Not (GetWindowsVersion In [wv2003Server, wv2003TerminalServer]) Then
    Begin
      { Check for MAPI availability }
      GotMapi := False;
      TmpDir := GetCurrentDir;
      If SetCurrentDir (CompDir) Then Begin
        { Check for MAPI emailing }
//  ShowMessage ('SCD_SecWarnWizard.1');
        GotMapi := MAPIAvailable;
      End; { If }
      SetCurrentDir (TmpDir);
    End //
    Else
    Begin
      // Windows 2003 Server - crashes setup loading EntComm2.Dll for unknown reason
//ShowMessage ('Win 2003 - Skip Check');
      GotMapi := False;
    End; // Else

//ShowMessage ('SCD_SecWarnWizard.2');
    { Create WStation directory if missing }
    If Not DirectoryExists (CompDir + 'WSTATION') Then Begin
      ForceDirectories(CompDir + 'WSTATION');
    End; { If }

//ShowMessage ('SCD_SecWarnWizard.3');
    BinIniF := TIniFile.Create(CompDir + 'WSTATION\SETUP.BIN');
    Try
      UsrIniF := TIniFile.Create(CompDir + 'WSTATION\SETUP.USR');
      Try
        CustDetsO := TCustDetsDlg.Create(TempLicR, UsrIniF);
        Try
//ShowMessage ('SCD_SecWarnWizard.4');
          frmSecWarn  := Nil;
          frmSecWarn2 := Nil;

          { Check Ent Security Code is set }
          // V5SECREL HM 09/01/02: Modified for new v5.00 Security/Release Code system
// V5SECRELQUERY - Is this check for a valid release code still correct?
          CurSecy := Calc_Security(Syss.ExSecurity,BOff);
          If (CurSecy = 0) Then Begin
            //Syss.ExSecurity := Get_ISNSecurity(Syss.EXISN);
            Syss.ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);

            // HM 27/06/00: Modified to enforce storage of new Security Code
            SetRelCode := 1;
          End; { If (CurSecy = 0) }

//ShowMessage ('SCD_SecWarnWizard.5');
          WizNo := 1;
          Done := False;
          Cancel := False;
          First1 := True;
          Repeat
            Case WizNo Of
              { Security Timeout Warning }
              1 : Begin
                    If (Not Assigned(frmSecWarn)) Then
                      frmSecWarn := TfrmSecWarn.Create(Application);

                    With frmSecWarn Do Begin
                      ExitCode := '?';

                      If (Mode = 1) Then Begin
                        NoteBook1.ActivePage := 'Install';

                        SBSUpDown1.Position := BinIniF.ReadInteger ('DemoConfig', 'Expiry', MaxDaysSecy);
                        ccySecDays.Text := IntToStr(SBSUpDown1.Position);
                        SetSecDays;
                      End { If Install }
                      Else Begin
                        NoteBook1.ActivePage := 'Upgrade';
                      End; { Else }

                      If (Mode In [3, 4]) Then Begin
                        Label2.Caption := ReplaceStrings(Label2.Caption, '%SKIP%', 'Cancel');
                        BackBtn.Caption := '&Cancel';
                      End { If (Mode In [3, 4]) }
                      Else
                        Label2.Caption := ReplaceStrings(Label2.Caption, '%SKIP%', 'Skip');

                      SetupDlg;
                      ShowModal;

                      Case ExitCode Of
                        'B' : Cancel := True;
                        'N' : WizNo := 2;

                        'X' : Cancel := True;
                        '?' : Cancel := True;
                      End; { Case }
                    End; { With }
                  End;

              { Choose method }
              2 : Begin
                    If (Not Assigned(frmSecWarn2)) Then Begin
                      frmSecWarn2 := TfrmSecWarn2.Create(Application);
                      First1 := True;
                    End; { If }

                    With frmSecWarn2 Do Begin
                      ExitCode := '?';

                      tabshPhone.TabVisible := (Mode <> 1);

                      If First1 Then Begin
                        SetupDlg(CustDetsO, CompDir, GotMAPI, TempLicR, BinIniF, UsrIniF);
                        First1 := False;
                      End; { If }

                      ShowModal;

                      Case ExitCode Of
                        'B' : WizNo := 1;
                        'N' : Begin
                                If DoneRelCode Then
                                  SetRelCode := 1;

                                Done  := True;
                                SaveDefaults(UsrIniF);
                              End;

                        'X' : Cancel := True;
                        '?' : Cancel := True;
                      End; { Case }
                    End; { With }
                  End;
            Else
              WizNo := 1;
            End; { Case }
          Until Done Or Cancel;

          Result := 0;

          If Assigned(frmSecWarn) Then frmSecWarn.Free;
          If Assigned(frmSecWarn2) Then frmSecWarn2.Free;
        Finally
          CustDetsO.Free;
        End;
      Finally
        UsrIniF.Free;
      End;
    Finally
      BinIniF.Free;
    End;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      Result := 11001;
    End;
  End;

  // HM 14/02/02: Modified to setup help file correctly
  Application.HelpFile := OldAppHelp;
//ShowMessage ('SCD_SecWarnWizard.Fini');
End; { SCD_SecWarnWizard }

{----------------------------------------------------------------------------}

Procedure TfrmSecWarn.SetupDlg;
var
  RelDateStr : LongDate;
  Rd,Rm,Ry   : Word;
  ExpDays    : LongInt;
Begin { SetupDlg }
  JulCal(Syss.RelDate,Rd,Rm,Ry);
  RelDateStr:=StrDate(Ry,Rm,Rd);

  ExpDays := NoDays(Today,RelDateStr);
  Label3.Caption := 'Your current Security Code ';
  If (ExpDays < 0) Then
    Label3.Caption := Label3.Caption + 'has expired and y'
  Else
    If (ExpDays = 0) Then
      Label3.Caption := Label3.Caption + 'expires today and y'
    Else Begin
      Label3.Caption := Label3.Caption + 'expires in ' + IntToStr(ExpDays) + ' days on ' + POutDate(RelDateStr) + '. Y';
    End; { Else }
  Label3.Caption := Label3.Caption + 'ou will have to get a new Security Code from your Local Distributor.'
End; { SetupDlg }

procedure TfrmSecWarn.FormCreate(Sender: TObject);
begin
  inherited;

  ExitMsg := 2;  { Security Code wizard }
end;

procedure TfrmSecWarn.ccySecDaysChange(Sender: TObject);
begin
  inherited;

  SetSecDays;
end;

procedure TfrmSecWarn.SetSecDays;
Var
  SecDays          : LongInt;
  Err              : Integer;
  Day, Month, Year : Word;
Begin { SetSecDays }
  If Self.Visible And (NoteBook1.ActivePage = 'Install') Then Begin
    { Calculate days }
    Val (ccySecDays.Text, SecDays, Err);
    If (Err = 0) Then Begin
      { Validate Days }
      If (SecDays > MaxDaysSecy) Or (SecDays < 1) Then Begin
        SecDays := MaxDaysSecy;
        ccySecDays.Value := SecDays;
      End; { If }

      Syss.RelDate := CalcNewRelDate(SecDays);

      JulCal (Syss.RelDate, Day, Month, Year);
      lblExpDate.Caption := POutDate (StrDate(Year, Month, Day));
    End; { If }
  End; { If }
End; { SetSecDays }

procedure TfrmSecWarn.SBSUpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
  inherited;

  ccySecDaysChange(Sender);
end;

procedure TfrmSecWarn.FormActivate(Sender: TObject);
begin
  inherited;

  ccySecDaysChange(Sender);
end;

end.
