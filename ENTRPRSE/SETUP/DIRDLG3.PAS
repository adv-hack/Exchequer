unit DirDlg3;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, FileCtrl, Buttons, SetupU, LicRec, IniFiles,
  FilCtl95;

type
  TfrmSCDDirDlg = class(TSetupTemplate)
    Path: TComboBox;
    btnFindEnt: TButton;
    DriveComboBox1: TDrive95ComboBox;
    DirectoryListBox1: TDirectory95ListBox;
    imgBackdoor: TImage;
    procedure DirectoryListBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindEntClick(Sender: TObject);
    procedure PathClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PathChange(Sender: TObject);
    procedure imgBackdoorDblClick(Sender: TObject);
  private
    { Private declarations }
    OldCrntDir : String;
    FFindEnt : Byte;
    LocPosData  : Array [1..2] Of LongInt;
    InChange : Boolean;

    Function  CheckSpace (ReqLong : LongInt) : Boolean;
    Function  GetPath : String;
    Procedure SetPath(Value : String);
    Procedure SetFindEnt(Value : Byte);

    Function  ValidOk(VCode : Char) : Boolean; OverRide;
  public
    { Public declarations }
    ValidMode : Char;
    LicR      : CDLicenceRecType;
    LocLicR   : CDLicenceRecType;
    W_LicF    : String;
    Property InstallPath : String read GetPath write SetPath;

    { 0=Off, 1=Enterprise, 2=Exchequer , 3-Either }
    Property WantFindEnt : Byte Read FFindEnt Write SetFindEnt;
  end;

{var
  DirectoryDialog: TDirectoryDialog;   }


function SCD_GetEnterDir(var DLLParams: ParamRec): LongBool; {$IFDEF WIN32} StdCall; {$ENDIF} export;


implementation

{$R *.DFM}

Uses DiskU, FindDlg2, EntLic, WLicFile, SerialU, LicFuncU, LicFuncs;

Const
  // MH 07/09/06: Increased req'd disk space to 500Mb from 70Mb as an IAO install is 329Mb with demo data!
  //DS_FullSystem : LongInt =  70000000;
  DS_FullSystem : LongInt = 500000000;
  DS_NewCompany : LongInt =  17000000;
  DS_ConnectKit : LongInt =   9000000;
  DS_PSQLCD     : LongInt = 145000000;

  posEditHOfs   = 1;
  posDirHOfs    = 2;

{$I FilePath.Inc}


{ Get }
function SCD_GetEnterDir(var DLLParams: ParamRec): LongBool;
var
  frmSCDDirDlg                   : TfrmSCDDirDlg;
  DlgPN, HlpPath, DefDrv, CcyVer : String;
  Res                            : LongInt;


  Function Switch (Bool : Boolean; Val1, Val2 : LongInt) : LongInt;
  Begin
    If Bool Then Result := Val1 Else Result := Val2;
  End;

Begin { SCD_GetEnterDir }
  { Get path of help file }
  GetVariable(DLLParams, 'INST', DlgPN);

  If Not (Copy (DlgPN, Length(DlgPN), 1)[1] In [':', '\']) Then
    HlpPath := DlgPN + '\'
  Else
    HlpPath := DlgPN;
  { Set On-Line Help File }
  Application.HelpFile := HlpPath + 'SETUP.HLP';

  frmSCDDirDlg := TfrmSCDDirDlg.Create(Application);
  Try
    With frmSCDDirDlg Do Begin
      { Get Licence File Name }
      GetVariable (DLLParams, 'I_LICFILE', W_LicF);
      If ReadLicFile (W_LicF, frmSCDDirDlg.LicR) Then Begin
        { Got licence OK - Resize for the resolution }
        AutoResize (2, 0);

        { Get default installation directory from WISE }
        GetVariable(DLLParams, 'DLGDIR', DefDrv);

        { Get mode - passed as parameter }
        ValidMode := DllParams.szParam[0];

        { Check we have a valid dialog type character }
        // MH 07/09/06: Added 'i' mode for IAO Installer to allow Btrieve v6.15 mode to be catered for
        If (ValidMode In ['1', 'C', 'c', 'L', 'I', 'i', 'U']) Then Begin
          Case ValidMode Of
            { ----- Pervasive.SQL ----- }

            '1' : Begin { CD Image }
                    HelpContextID := 10005;
                    InstallPath := DefDrv;
                    Instructions := 'Please specify the directory where you want your Pervasive.SQL CD Image to be installed:';
                    Title := 'Pervasive.SQL CD';
                  End;

            { ----- Single-CD ----- }

            'i',
            'I' : Begin { Install }
                    HelpContextID := 29;

                    //InstallPath := DefDrv;
                    Path.Text := DefDrv;
                    PathChange(frmSCDDirDlg);

// MH 11/10/05: Rebranded for Exchequer/LITE compatibility
//                    Instructions := 'Please specify the directory where you want to install Exchequer:';
//                    Title := 'Install Exchequer';
                    Instructions := 'Please specify the directory where you want to install the application:';
                    Title := 'Installation Directory';

                    If (ValidMode = 'i') Then
                    Begin
                      Instructions := 'Btrieve v6.15 is installed in the directory below, please click the &Next button to continue:';
                      DriveComboBox1.Enabled := False;
                      DirectoryListBox1.Enabled := False;
                      Path.Enabled := False;
                      imgBackdoor.Enabled := True;
                    End; // If (ValidMode = 'i')
                  End; { I }

            'U' : Begin { Upgrade }
                    HelpContextID := 41;
                    InstallPath := DefDrv;

// MH 11/10/05: Rebranded for Exchequer/LITE compatibility
//                    Instructions := 'Please specify the directory containing your Exchequer system files:';
                    Instructions := 'Please specify the directory containing the application''s program files:';
                    Title := 'Upgrade Directory';

                    WantFindEnt := 3;
                  End;

            'C' : Begin { New Company - Exchequer Directory }
                    HelpContextID := 26;
                    InstallPath := DefDrv;
                    Instructions := 'Please specify the directory containing the program files for your ' +
                                    'Accounts system or click the &Find button to search for the directory:';
                    Title := 'Main Company';

                    WantFindEnt := 1;
                  End; { C }

            'c' : Begin { New Company - New Company Data Directory }
                    HelpContextID := 27;
                    InstallPath := DefDrv;
                    Instructions := 'Please specify the directory you want to install the new company data files into:';
                    Title := 'New Company';
                  End; { c }

            { ----- Single-CD Workstation Setup ----- }

            'L' : Begin { Local Program Files directory }
                    HelpContextID := 14;
                    InstallPath := DefDrv;
                    Instructions := 'Please specify the Local directory where you want the Exchequer ' +
                                    'Program Files to be installed:';
                    Title := 'Local Exchequer';
                  End; { n }
          End; { Case }

          ShowModal;

          Case ExitCode Of
            'B' : Begin { Back }
                    { Get Prev/Next dialog string }
                    GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
                    SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
                  End;
            'N' : Begin { Next }
                    { Get Prev/Next dialog string }
                    GetVariable(DLLParams,'DLGPREVNEXT',DlgPN);
                    SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));

                    SetVariable(DLLParams,'DLGDIR',InstallPath);

                    If (licR.licType = 2) And (ValidMode <> 'c') Then Begin
                      { Auto-Upgrade - Update temporary licence file }
                      Res := UpdateLicFile (W_LicF, LocLicR);
                      If (Res <> 0) Then Begin
                        { Error updating licence file }
                        MessageDlg ('An error occured updating the Auto-Upgrade Licence:' + #13#13 +
                                    '  Error: ' + IntToStr(Res) + #13#13 +
                                    'Please contact your Technical support.', mtError, [mbOK], 0);
                      End { If (Res <> 0) }
                      Else
                        { Update Wise Variables }
                        WriteLicToWise (DLLParams, W_LicF, LocLicR, 1);
                    End; { If }

                    { Write Warning flags to Wise Script }
                    If (GlobFlags[1] = 0) Then Begin
                      SetVariable(DLLParams, 'W_OVERWRITE', 'N');
                      SetVariable(DLLParams, 'W_OWDIR', '');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_OVERWRITE', 'Y');
                      SetVariable(DLLParams, 'W_OWDIR', InstallPath);
                    End; { Else }

                    { Write Warning flags to Wise Script }
                    If (GlobFlags[2] = 0) Then Begin
                      SetVariable(DLLParams, 'W_LOCPROGDIR', 'N');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_LOCPROGDIR', 'Y');
                    End; { Else }

                    { 3=Upgrading and module ver is worsening e.g. SPOP->STK }
                    If (GlobFlags[3] = 0) Then Begin
                      SetVariable(DLLParams, 'W_MODVER', 'N');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_MODVER', 'Y');
                    End; { Else }

                    { 4=Upgrading C/S to Non-C/S }
                    If (GlobFlags[4] = 0) Then Begin
                      SetVariable(DLLParams, 'W_NONCS', 'N');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_NONCS', 'Y');
                    End; { Else }

                    { 5=Upgrading Global To Euro }
                    If (GlobFlags[5] = 0) Then Begin
                      SetVariable(DLLParams, 'W_CCYVER', 'N');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_CCYVER', 'Y');
                    End; { Else }

                    { 6=Upgrading and User Count reducing }
                    If (GlobFlags[6] = 0) Then Begin
                      SetVariable(DLLParams, 'W_UCOUNT', 'N');
                    End { If }
                    Else Begin
                      SetVariable(DLLParams, 'W_UCOUNT', 'Y');
                    End; { Else }
                  End;

            'X' : Begin { Exit Installation }
                    SetVariable (DLLParams, 'DIALOG', '999');
                  End;
          End; { Case }
        End { If ValidMode In ... }
        Else Begin
          { Invalid Directory Dialog type }
          MessageDlg ('An Invalid Directory Dialog Type was detected', mtError, [mbOk], 0);
          SetVariable (DLLParams, 'DIALOG', '999');
        End; { Else }
      End { If }
      Else Begin
        { Cannot read licence }
        MessageDlg ('An error occurred trying to read the Licence file', mtError, [mbOk], 0);
        SetVariable (DLLParams, 'DIALOG', '999');
      End; { Else }
    End; { With }
  Finally
    frmSCDDirDlg.Free;
  End;

  Result := False;
End; { SCD_GetEnterDir }


{---------------------------------------------------------------------------}

procedure TfrmSCDDirDlg.FormCreate(Sender: TObject);
begin
  inherited;

  { Save Current Directory }
  OldCrntDir := GetCurrentDir;
  ValidMode := #0;

  WantFindEnt := 0;

  { Generate postion data for dynamic resizing }
  LocPosData[posEditHOfs] := Self.Height - Path.Top;
  LocPosData[posDirHOfs]  := Self.Height - DirectoryListBox1.Height;
end;

procedure TfrmSCDDirDlg.FormDestroy(Sender: TObject);
begin
  inherited;

  { Restore Current Directory }
  SetCurrentDir(OldCrntDir);
end;

procedure TfrmSCDDirDlg.FormResize(Sender: TObject);
begin
  inherited;

  Path.Top := Self.Height - LocPosData[posEditHOfs];
  DirectoryListBox1.Height := Self.Height - LocPosData[posDirHOfs];
  btnFindEnt.Top := BackBtn.Top;
end;

Function TfrmSCDDirDlg.GetPath : String;
Begin
  Result := Path.Text;
End;

Procedure TfrmSCDDirDlg.SetPath(Value : String);
Var
//  Pos  : SmallInt;
//  OK   : Boolean;
  sPath : ShortString;

  Function ValidPath (Path : ShortString) : Boolean;
  Begin // ValidPath
    Path := UpperCase(Trim(Path));
    Result := (Length(Path) >= 2);
    If Result Then
      Result := (Path[1] In ['A'..'Z']) And (Path[2] = ':');
  End; // ValidPath

Begin
  // Find the last valid directory in the path and set the directory list box to show it
  sPath := IncludeTrailingPathDelimiter(Value);

  While ValidPath(sPath) And (Not DirectoryExists(sPath)) And (Length(sPath) > 3) Do
  Begin
    Delete(sPath, Length(sPath), 1);
    sPath := ExtractFilePath(sPath);
  End; // While (Not DirectoryExists(sPath))

  If ValidPath(sPath) And DirectoryExists(sPath) Then
  Begin
    DriveComboBox1.Drive := sPath[1];
    DirectoryListBox1.Directory := sPath;
  End; // If ValidPath(sPath) And DirectoryExists(sPath)

(*
  Pos := Length(Value);
  OK := True;

  Repeat
    If (Not OK) Then Begin
      Repeat
        Dec (Pos);
      Until (Pos = 0) Or (Value[Pos] In ['\', ':']);
    End; { If }

    OK := True;

    If (Pos > 0) Then Begin
      Try
        DirectoryListBox1.Directory := Copy(Value, 1, Pos);

      Except
        On Exception Do OK := False;
      End;
    End; { If }
  Until OK;

  If (Pos > 0) And (Pos < Length(Value)) Then Begin
    DirectoryListBox1Change(Self);

    If (Copy(Path.Text, Length(Path.Text), 1) = '\') And (Value[Pos] = '\') Then
      Inc (Pos);

    Path.Text := Path.Text + Copy(Value, Pos, Length(Value));
  End; { If }
*)
End;

procedure TfrmSCDDirDlg.DirectoryListBox1Change(Sender: TObject);
begin
  inherited;

//  Path.Text := DirectoryListBox1.Directory;

  If (Not InChange) Then
    Path.Text := IncludeTrailingPathDelimiter(DirectoryListBox1.Directory);
end;

Function TfrmSCDDirDlg.ValidOk(VCode : Char) : Boolean;
Var
  IniF                  : TIniFile;
  TmpPath, TmpPath2     : String;
  SNoArray              : SerialNoType;
  EntLicR               : EntLicenceRecType;

  Function GotData (Const DataPath : ShortString) : Boolean;
  Begin { GotData }
    Result := FileExists (DataPath + PathSys) And             { EXCHQSS.DAT }
              FileExists (DataPath + Path1 + CustName) And    { CUST\CUSTSUPP.DAT }
              FileExists (DataPath + Path2 + DocName) And     { TRANS\DOCUMENT.DAT }
              FileExists (DataPath + Path2 + DetailName) And  { TRANS\DETAILS.DAT }
              FileExists (DataPath + Path3 + MiscNam) And     { MISC\EXSTKCHK.DAT }
              FileExists (DataPath + Path4 + MLocName) And    { STOCK\MLOCSTK.DAT }
              FileExists (DataPath + Path4 + StockNam);       { STOCK\STOCK.DAT }
  End; { GotData }

  Function CheckCompCount (Const CompPath : ShortString) : WordBool;
  Var
    _CheckCompCount : Function (Const CompPath : ShortString) : WordBool; StdCall;
    _DLLHandle      : THandle;
    LibPath         : ANSIString;
  Begin { CheckCompCount }
    Result := False;

    { Load ENTCOMP.DLL dynamically }
    LibPath := CompPath + 'EntComp2.Dll';
    _DLLHandle := LoadLibrary(PCHAR(LibPath));

    Try
      If (_DLLHandle > HInstance_Error) Then Begin
        _CheckCompCount := GetProcAddress(_DLLHandle, 'Setup_CheckCompCount');

        If Assigned(_CheckCompCount) Then
          Result := _CheckCompCount(CompPath);

        { Unload library }
        FreeLibrary(_DLLHandle);
        _DLLHandle:=0;
      End; { If }
    Except
      FreeLibrary(_DLLHandle);
      _DLLHandle:=0;
      _CheckCompCount := Nil;
    End;
  End; { CheckCompCount }

Begin
  Result := True;

  If (VCode = 'N') Then Begin
    { Check its a valid drive letter path }
    TmpPath := UpperCase(Trim(Path.Text));
    Result := (TmpPath[1] In ['C'..'Z']) And (TmpPath[2] = ':');
    If (Not Result) Then
      MessageDlg ('The path must be a valid drive and path combination', mtWarning, [mbOk], 0)
    Else Begin
      { Check not installing it in the root of the drive }
      Result := (ValidMode = 'X'); { Cripple Reports directory can be anywhere }

      If (Not Result) Then
        { All non-CR paths cannot be the root of a drive - causes major errors }
        Result := (Length(TmpPath) > 3) Or ((Length(TmpPath) = 3) And (TmpPath[3] <> '\'));

      If (Not Result) Then
        MessageDlg ('The path cannot be the root directory of a drive', mtWarning, [mbOk], 0)
      Else
        { Check install specific details }
        Case ValidMode Of
          { ----- Pervasive.SQL ----- }

          '1' : Begin { CD Image }
                  { Validation ??? }

                End;

          { ----- Single-CD ----- }

          'i',
          'I' : Begin { Install }
                  { Check for existing system }
                  If DirectoryExists(Path.Text) Then Begin
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    (* HM 20/03/03: Modified to prevent installations over the top of an existing system- changed
                                    because Dealers were getting errors installing the Channel Forum CD over the
                                    top of the Developer Showcase CD.
                    { Check directory doesnt already contain data }
                    If FileExists (TmpPath + 'EXCHQSS.DAT') Then Begin
                      Result := (MessageDlg ('Exchequer Data already exists in this directory. Do you want to overwrite it?',
                                             mtConfirmation,
                                             [mbYes, mbNo],
                                             0) = mrYes);
                      GlobFlags[1] := Ord(Result);
                    *)
                    If FileExists (TmpPath + 'Enter1.Exe') Or FileExists (TmpPath + 'Excheqr.Exe') Or
                       FileExists (TmpPath + 'COMPANY.DAT') Or FileExists (TmpPath + 'EXCHQSS.DAT') Or
                       FileExists (TmpPath + 'CUST\CUSTSUPP.DAT') Or FileExists (TmpPath + 'TRANS\DOCUMENT.DAT') Then Begin
                      MessageDlg ('A system already exists in this directory and cannot be overwritten',
                                  mtWarning, [mbOK], 0);

                      Result := False;
                    End { If }
                    Else
                      { AOK - No Data }
                      Result := True;
                  End { If }
                  Else Begin
                    { AOK - If Path is set }
                    Result := (Trim(Path.Text) <> '');

                    If (Not Result) Then
                      MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                  End; { Else }
                End;

          'U' : Begin { Upgrade }
                  { Next }
                  Result := DirectoryExists(Path.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check for Exchequer/Enterprise Program files }
                    Result := (FileExists (TmpPath + 'ENTER1.EXE') Or FileExists (TmpPath + 'REX.BAT'));

                    If Result And (licR.licType = 2) Then Begin
                      { Auto-Upgrade - directory must contain an Enterprise System }
                      Result := FileExists (TmpPath + 'ENTER1.EXE');
                    End; { If }

                    If Result Then Begin
                      { Check for data files }
                      Result := GotData(TmpPath);

                      If (Not Result) Then Begin
                        { No data but got programs - check to see if its a Local Program Files dir }
                        If FileExists (TmpPath + 'ENTWREPL.INI') Then Begin
                          IniF := TIniFile.Create (TmpPath + 'ENTWREPL.INI');
                          Try
                            TmpPath2 := IniF.ReadString('UpdateEngine', 'NetworkDir', '');
                            If (Trim(TmpPath2) <> '') Then Begin
                              { Got path }
                              If Not (TmpPath2 [Length(TmpPath2)] In [':', '\']) Then
                                TmpPath2 := TmpPath2 + '\';

                              { Check for Company.Dat }
                              Result := FileExists(TmpPath2 + 'COMPANY.DAT') And
                                        FileExists(TmpPath2 + 'ENTRPRSE.DAT') And
                                        GotData(TmpPath2);

                              If Result Then Begin
                                Result := (MessageDlg ('This is a local Program Files directory, Do you want to upgrade it?',
                                           mtConfirmation, [mbYes, mbNo], 0) = mrYes);
                                GlobFlags[2] := Ord(Result);
                              End; { If Result }
                            End; { If (Trim... }
                          Finally
                            IniF.Free;
                          End;
                        End; { If FileExists ... }
                      End; { If (Not Result) }
                    End; { If Result }

                    If Result Then Begin
                      { Enterprise System - Check for licencing files }
                      Result := FileExists (TmpPath + 'ENTRPRSE.DAT');
                      If Result Then Begin
                        { Don't check ccy version for Auto-Upgrades as not currency dependant }
                        If (licR.licType <> 2) Then Begin
                          { Not Auto-Upgrade - Check Currency Version is correct }
                          If (LicR.licEntCVer = 0) Then Begin
                            { Single Currency - check for DEFPF044.SYS or DEF044.SYS and not DEFMC044.SYS }
                            Result := (FileExists (TmpPath + 'DEFPF044.SYS') Or FileExists (TmpPath + 'DEF044.SYS')) And
                                      (Not FileExists (TmpPath + 'DEFMC044.SYS'));

                            If (Not Result) Then
                              MessageDlg ('This directory contains a Multi Currency system ' +
                                          'and this setup program can only upgrade ' +
                                          'Single Currency systems', mtWarning, [mbOk], 0);
                          End { If (LicR.licEntCVer = 0) }
                          Else Begin
                            { Euro/Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                            Result := FileExists (TmpPath + 'DEFMC044.SYS') And
                                      (Not (FileExists (TmpPath + 'DEFPF044.SYS') Or FileExists (TmpPath + 'DEF044.SYS')));

                            If (Not Result) Then
                              MessageDlg ('This directory contains a Single Currency system ' +
                                          'and this setup program can only upgrade ' +
                                          'Multi Currency systems', mtWarning, [mbOk], 0);
                          End; { Else }
                        End; { If (licR.licType <> 2) }
                      End { If Result }
                      Else Begin
                        { No Single-CD licences found }
                        MessageDlg ('This directory does not contain a valid Licence. ' +
                                    'Check you have run the correct conversion programs.', mtWarning, [mbOk], 0);
                      End; { Else }
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid system', mtWarning, [mbOk], 0);

                    If Result Then Begin
                      // HM 22/01/02: Added to prevent intermittant errors reading licence
                      ExMainCoPath^ := '';

                      { Read Enterprise licence from selected directory }
                      If ReadEntLic (TmpPath + EntLicFName, EntLicR) Then Begin
                        { Copy details into local CD licence record }
                        LocLicR := licCopyEntLicToCDLic(EntLicR);
(*
ShowMessage ('Ent Licence ESN: ' + ESN2ByteToStr(EntLicR.licISN) + #13 +
             'Loc Lic ESN: ' + ESN2ByteToStr(LocLicR.licESN) + #13 +
             'CD Licence ESN: ' + ESN2ByteToStr(LicR.licESN) + #13 +
             'Ent Licence ESN2: ' + ESN2ByteToStr(EntLicR.licESN2) + #13 +
             'Loc Lic ESN2: ' + ESN2ByteToStr(LocLicR.licESN2) + #13 +
             'CD Licence ESN2: ' + ESN2ByteToStr(LicR.licESN2));
*)

{ShowMessage ('CD.LicType: ' + IntToStr(LicR.licType) + #13 +
             'CD.SerialNo: ' + LicR.licSerialNo + #13 +
             'CD.ESN: ' + ISNByteToStr (LicR) + #13 +
             'Local.SerialNo: ' + LocLicR.licSerialNo + #13 +
             'Local.ESN: ' + ISNByteToStr (LocLicR));}

                        If (LicR.licType = 0) Then Begin
                          { Install CD - Check Upgrade directory originated from this CD }
                          Result := (LicR.licSerialNo = LocLicR.licSerialNo);
{ShowMessage ('LicR.licSerialNo: ' + LicR.licSerialNo + #13 +
             'LocLicR.licSerialNo: ' + LocLicR.licSerialNo);}

                          If (Not Result) Then
                            MessageDlg ('This directory cannot be upgraded as it was installed from a different CD, ' +
                                        'use that CD to upgrade this directory.', mtWarning, [mbOk], 0);
                        End { If }
                        Else Begin
                          If (LicR.licType = 1) Then Begin
                            { Upgrade CD - Check CD ESN matches local ESN}
                            Result := (LicR.licEsn[1] = LocLicR.licEsn[1]) And (LicR.licEsn[2] = LocLicR.licEsn[2]) And
                                      (LicR.licEsn[3] = LocLicR.licEsn[3]) And (LicR.licEsn[4] = LocLicR.licEsn[4]) And
                                      (LicR.licEsn[5] = LocLicR.licEsn[5]) And (LicR.licEsn[6] = LocLicR.licEsn[6]);

                            If (Not Result) Then Begin
                              { If ESN2 in licence is non-zero then check against that as well }
                              If (LicR.licESN2[1] <> 0) Or (LicR.licESN2[2] <> 0) Or (LicR.licESN2[3] <> 0) Or
                                 (LicR.licESN2[4] <> 0) Or (LicR.licESN2[5] <> 0) Or (LicR.licESN2[6] <> 0) Then Begin
                                { ESN2 is set - check against local ESN }
                                Result := (LicR.licESN2[1] = LocLicR.licEsn[1]) And (LicR.licESN2[2] = LocLicR.licEsn[2]) And
                                          (LicR.licESN2[3] = LocLicR.licEsn[3]) And (LicR.licESN2[4] = LocLicR.licEsn[4]) And
                                          (LicR.licESN2[5] = LocLicR.licEsn[5]) And (LicR.licESN2[6] = LocLicR.licEsn[6]);
                              End; { If }
                            End; { If }

                            If (Not Result) Then Begin
                              { May have just upgraded from pre-SCuD and ESN in licence not set, check }
                              { if a) ESN not set and b) the system ESN is compatible with CD Sno }
                              If (LicR.licEsn[1] = 0) And (LicR.licEsn[2] = 0) And (LicR.licEsn[3] = 0) And
                                 (LicR.licEsn[4] = 0) And (LicR.licEsn[5] = 0) And (LicR.licEsn[6] = 0) Then Begin
                                { ESN in licence not set - compare system ESN with CD Sno }
                                SNoArray := SNoStrToSNoByte (LicR.licSerialNo);

                                Result := (LocLicR.licEsn[1] = SnoArray[1]) And (LocLicR.licEsn[4] = SnoArray[2]);
                              End; { If }
                            End; { If }

                            If (Not Result) Then
                              MessageDlg ('This directory cannot be upgraded as it has the wrong Serial Number, only ' +
                                          'systems with the correct Serial Number can be upgraded.', mtWarning, [mbOk], 0)
                            Else Begin
                              { Check modules, etc.. for potential accidental downgrades }

                              { Check Enterprise Core Modules }
                              If (LicR.licEntModVer < LocLicR.licEntModVer) Then Begin
                                Result := (MessageDlg ('The version you are upgrading is a higher spec version ' +
                                                       'than this upgrade program will install. If you continue you may lose ' +
                                                       'some functionality. Do you want to continue?',
                                                       mtConfirmation, [mbYes, mbNo], 0) = mrYes);
                                GlobFlags[3] := Ord(Result);
                              End; { If }

                              { Check Client-Server }
                              // HM 02/10/03: Added mode 2 for workgroup engine
                              If (LocLicR.licEntClSvr = 1) And (LicR.licEntClSvr = 0) Then Begin
                                { Downgrading Client-Server to Non Client-Server }
                                Result := (MessageDlg ('The system you are upgrading is the Client-Server version, this upgrade ' +
                                                       'program will install the NON-Client-Server version. Do you want to continue?',
                                                       mtConfirmation, [mbYes, mbNo], 0) = mrYes);
                                GlobFlags[4] := Ord(Result);
                              End; { If }

                              { Check Currency Version }
                              If (LocLicR.licEntCVer = 2) And (LicR.licEntCVer = 1) Then Begin
                                { Downgrading Global to Euro }
                                Result := (MessageDlg ('The system you are upgrading is Multi-Currency and this upgrade is a Euro version. ' +
                                                       'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
                                GlobFlags[5] := Ord(Result);
                              End; { If }

                              { Check User Count }
                              If (LocLicR.licUserCnt > LicR.licUserCnt) Then Begin
                                { Reducing User Count }
                                Result := (MessageDlg ('This upgrade will reduce the User Count from ' + IntToStr(LocLicR.licUserCnt) + ' to ' +
                                                       IntToStr(LicR.licUserCnt) + '. Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
                                GlobFlags[6] := Ord(Result);
                              End; { If }
                            End; { Else }
                          End { If }
                          Else
                            If (LicR.licType = 2) Then Begin
                              { Auto-Upgrade CD - Check ESN is set }
                              Result := licESNSet(LocLicR.licESN);

                              If (Not Result) Then
                                MessageDlg ('This is not a valid system and cannot be upgraded with an Auto-Upgrade ' +
                                            'licence. Please use a standard upgrade licence to upgrade this system.',
                                            mtWarning, [mbOk], 0)
                              Else Begin
                                { ESN in data is set - check to see if licence has any ESN's set }
                                If licESNSet(LicR.licESN) Or licESNSet(LicR.licESN2) Then Begin
                                  { Licence ESN's are set - check them against the local data ESN }
                                  If licESNSet(LicR.licESN) Then Begin
                                    { Check ESN1 against local data }
                                    Result := licMatchingESN(LicR.licESN, LocLicR.licESN);

                                    { If no match then try checking ESN2 }
                                    If (Not Result) And licESNSet(LicR.licESN2) Then
                                      { Check ESN2 against local data }
                                      Result := licMatchingESN(LicR.licESN2, LocLicR.licESN);
                                  End { If licESNSet(LicR.licESN) }
                                  Else
                                    { ESN1 not set - check ESN2 agaist local licence ESN }
                                    Result := licMatchingESN(LicR.licESN2, LocLicR.licESN);

                                  If (Not Result) Then
                                    { Invalid ESN }
                                    MessageDlg ('This directory cannot be upgraded as it has the wrong ' +
                                                'Serial Number, only systems with the correct ' +
                                                'Serial Number can be upgraded.', mtWarning, [mbOk], 0)
                                End; { If licESNSet ... }
                              End; { Else }
                            End; { If (LicR.licType = 2) }
                        End; { Else }
                      End { If }
                      Else Begin
                        Result := False;
                        MessageDlg ('Failed to read the Serial Number in the specified directory.', mtWarning, [mbOk], 0);
                      End; { Else }
                    End; { If Result }
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End; { u }

          'C' : Begin { New Company - Enterprise Directory }
                  { Next }
                  Result := DirectoryExists(Path.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check for data file }
                    Result := FileExists (TmpPath + 'ENTER1.EXE') And
                              FileExists (TmpPath + 'EXCHQSS.DAT') And
                              DirectoryExists (TmpPath + '\FORMS');
                    If Result Then Begin
                      If (licR.licType <> 2) Then Begin
                        { NOT Auto-Upgrade Licence - Check Currency Version against directory }

                        { Enterprise System - Check Currency Version is correct }
                        If (LicR.licEntCVer = 0) Then Begin
                          { Single Currency - check for DEFPF044.SYS and not DEFMC044.SYS }
                          Result := FileExists (TmpPath + 'DEFPF044.SYS') And Not FileExists (TmpPath + 'DEFMC044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Multi Currency system ' +
                                        'and this setup program can only upgrade ' +
                                        'Single Currency systems', mtWarning, [mbOk], 0);
                        End { If }
                        Else Begin
                          { Euro/Multi Currency - check for DEFMC044.SYS and not DEFPF044.SYS }
                          Result := FileExists (TmpPath + 'DEFMC044.SYS') And Not FileExists (TmpPath + 'DEFPF044.SYS');

                          If (Not Result) Then
                            MessageDlg ('This directory contains a Single Currency system ' +
                                        'and this setup program can only upgrade ' +
                                        'Multi Currency systems', mtWarning, [mbOk], 0);
                        End; { Else }
                      End { If (licR.licType <> 2) }
                      Else Begin
                        { Auto-Upgrade - Read Licence to update setup script }
                        ReadEntLic (TmpPath + EntLicFName, EntLicR);

                        { Copy details into local CD licence record }
                        LocLicR := licCopyEntLicToCDLic(EntLicR);
                      End; { Else }
                    End { If }
                    Else
                      MessageDlg ('This directory does not contain a valid system', mtWarning, [mbOk], 0);

                    (* HM 14/08/98: Removed chack as install will now install it if required
                    If Result And (ValidMode = 'C') Then Begin
                      { Check for multi-company manager }
                      Result := FileExists (TmpPath + 'MCompMan.Sys');

                      If (Not Result) Then
                        MessageDlg ('This System is not using the Multi-Company Manager', mtWarning, [mbOk], 0);
                    End; { If }
                    *)

                    If Result And (ValidMode = 'N') Then Begin
                      { Check for Replication List, ENTWREPL.LST, in network dir }
                      { this indicates if it is a Local Programs directory       }
                      Result := FileExists (TmpPath + 'EntWRepl.Lst');

                      If (Not Result) Then
                        MessageDlg ('This System does not have the replication files installed', mtWarning, [mbOk], 0);
                    End; { If }

                    If Result Then Begin
                      { Read Enterprise licence from Main Company directory }
                      ReadEntLic (TmpPath + EntLicFName, EntLicR);

                      { Copy details into local CD licence record }
                      LocLicR := licCopyEntLicToCDLic(EntLicR);
                    End; { If Result }

                    If Result Then Begin
                      { HM 16/07/01 v4.40: Check the Company Count to ensure free slots in the licence }
                      Result := CheckCompCount (TmpPath);
                      If (Not Result) Then
                        MessageDlg ('This System has already reached the licenced number of companies, ' +
                                    'please contact your Dealer or Distributor to get details on increasing ' +
                                    'your Company Licence Count.', mtWarning, [mbOk], 0);
                    End; { If Result }
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End; { u }

          'c' : Begin { New Company - New Company Data Directory }
                  Result := (Trim(Path.Text) <> '');

                  If Result Then Begin
                    If DirectoryExists (Trim(Path.Text)) Then Begin
                      TmpPath := Path.Text;
                      If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                        TmpPath := TmpPath + '\';

                      { Check directory doesnt already contain data }
                      Result := Not FileExists (TmpPath + 'EXCHQSS.DAT');

                      If (Not Result) Then
                        MessageDlg ('Data files already exist in this directory', mtWarning, [mbOk], 0);
                    End; { If }
                  End { If }
                  Else
                    MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                End;

          { ----- Single-CD Workstation Setup ----- }

          'L' : Begin { Local Program Files directory }
                  { Check for existing system }
                  If DirectoryExists(Path.Text) Then Begin
                    TmpPath := Path.Text;
                    If Not (Copy(TmpPath, Length(TmpPath), 1)[1] In [':', '\']) Then
                      TmpPath := TmpPath + '\';

                    { Check directory doesnt already contain data }
                    Result := Not FileExists (TmpPath + 'EXCHQSS.DAT');
                    If (Not Result) Then Begin
                      MessageDlg ('This directory contains an Exchequer System and cannot be overwritten', mtWarning, [mbOk], 0);
                    End { If }
                    Else Begin
                      { No data - check for Enterprise .EXE's }
                      Result := Not FileExists (TmpPath + 'ENTER1.EXE');
                      If (Not Result) Then Begin
                        Result := (MessageDlg ('Exchequer Program Files already exists in this directory. Do you want to overwrite them?',
                                               mtConfirmation,
                                               [mbYes, mbNo],
                                               0) = mrYes);
                        GlobFlags[1] := Ord(Result);
                      End; { If (Not Result) }
                    End; { Else }
                  End { If }
                  Else Begin
                    { AOK - If Path is set }
                    Result := (Trim(Path.Text) <> '');

                    If (Not Result) Then
                      MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                  End; { Else }
                End;
        End; { Case }
    End; { Else }

    If Result Then Begin
      { Check disk space }
      Case ValidMode Of
        '1' : Begin { CD Image }
                Result := CheckSpace (DS_PSQLCD);
              End;

        'i',        // IAO Install
        'I',        { Install }
        'U',        { Upgrade }
        'L' : Begin { Local Program Files directory }
                Result := CheckSpace (DS_FullSystem);
              End;

        'c' : Begin { New Company - New Company Data Directory }
                Result := CheckSpace (DS_NewCompany);
              End;
      End; { Case ValidMode }
    End; { If }
  End; { If }
End;

Function TfrmSCDDirDlg.CheckSpace (ReqLong : LongInt) : Boolean;
Var
  fDriveNo          : Smallint;
  FreeSpace, ReqDbl : Double;
Begin
  Result := False;
  ReqDbl := ReqLong;

  { Calculate drive number }
  fDriveNo:=Ord(UPCase(Path.Text[1]))-64;

  { get free space on drive }
  FreeSpace := sbsDiskFree(fDriveNo);

  { Check it }
  Result := (FreeSpace > ReqDbl) Or (FreeSpace <= 0);

  If (Not Result) Then Begin
    { Not enough disk space }
    ReqLong := Trunc(ReqDbl-FreeSpace) Div 1024;
    Result := (MessageDlg ('There is not enough disk space free to install the ' +
                           'files in the drive you specified. Another ' + IntToStr(ReqLong) + 'k is required.' +
                           #10#13#10#13 +
                           'Do you want to continue anyway?', mtWarning, [mbYes, mbNo], 0) = mrYes);
  End; { If }
End;

Procedure TfrmSCDDirDlg.SetFindEnt(Value : Byte);
Begin { SetFindEnt }
  FFindEnt := Value;
  btnFindEnt.Visible := (Value > 0);

  If (btnFindEnt.Visible) Then Begin
    { Convert combo to drop-down type }
    Path.Style := csDropDown;
  End; { If }
End;  { SetFindEnt }

procedure TfrmSCDDirDlg.btnFindEntClick(Sender: TObject);
var
  frmFindDlg : TfrmFindDlg;
  I          : SmallInt;
  TmpStr     : ShortString;
begin
  inherited;

  If (FFindEnt > 0) And btnFindEnt.Visible Then Begin
    { Setup dialog }
    frmFindDlg := TfrmFindDlg.Create(Self);
    Try
      frmFindDlg.DriveComboBox1.Drive := DriveComboBox1.Drive;
      frmFindDlg.FindMode := FFindEnt;
      If (LicR.licEntCVer = 0) Then
        frmFindDlg.CurrMode := 'S'
      Else
        frmFindDlg.CurrMode := 'M';
      frmFindDlg.PathList := Path;

      frmFindDlg.Title := 'Find Accounts Directory';

      frmFindDlg.ShowModal;

      { run through list deleting any duplicate paths }
      If (Path.Items.Count > 1) Then Begin
        TmpStr := Path.Text;

        I := 1;
        While I <= Pred(Path.Items.Count) Do Begin
          If (Path.Items[I] = Path.Items[Pred(I)]) Then Begin
            { Delete duplicate item }
            Path.Items.Delete(I);
          End { If }
          Else Begin
            { AOK - move to next }
            Inc (I);
          End; { Else }
        End; { While }

        Path.Text := TmpStr;
      End; { If }

      If (frmFindDlg.ExitCode = 'N') Then Begin
        { A path was selected - setup drive/dir to look at it }
        Path.Text := frmFindDlg.lstDirs.Items[frmFindDlg.lstDirs.ItemIndex];
        PathClick(Sender);
      End; { If }
    Finally
      frmFindDlg.Free;
    End;
  End; { If }
end;

procedure TfrmSCDDirDlg.PathClick(Sender: TObject);
begin
  inherited;

  //InstallPath := Path.Text;
end;

procedure TfrmSCDDirDlg.PathChange(Sender: TObject);
begin
  inherited;
  InChange := True;
  Try
    InstallPath := Path.Text;
  Finally
    InChange := False;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.imgBackdoorDblClick(Sender: TObject);
begin
  DriveComboBox1.Enabled := True;
  DirectoryListBox1.Enabled := True;
  Path.Enabled := True;
  imgBackdoor.Enabled := False;
end;

//-------------------------------------------------------------------------

end.
