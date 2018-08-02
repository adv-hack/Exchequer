unit DIRDLG4;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, FileCtrl, Buttons, SetupU, LicRec, IniFiles,
  FilCtl95, ComCtrls, ShellCtrls2005;

type
  TfrmSCDDirDlg = class(TSetupTemplate)
    btnFindEnt: TButton;
    imgBackdoor: TImage;
    ShellTreeView20051: TShellTreeView2005;
    edtPath: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindEntClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure imgBackdoorDblClick(Sender: TObject);
    procedure ShellTreeView20051AddFolder(Sender: TObject;
      AFolder: TShellFolder; var CanAdd: Boolean);
    procedure ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
    procedure edtPathChange(Sender: TObject);
    procedure edtPathKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    DBType: String;
    OldCrntDir : String;
    FFindEnt : Byte;
    LocPosData  : Array [1..2] Of LongInt;
    FInChange : Boolean;

    Function  CheckSpace (ReqLong : LongInt) : Boolean;
    Function  GetPath : String;
    Procedure SetPath(Value : String);
    Procedure SetFindEnt(Value : Byte);

    Function ValidPath (Path : ShortString) : Boolean;

    Function  ValidOk(VCode : Char) : Boolean; OverRide;

//    function CheckBTrieveVersion(var DLLParams: ParamRec; pPath: ShortString): Boolean;
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

Uses DiskU, FindDlg3, EntLic, WLicFile, SerialU, LicFuncU, LicFuncs, DiskUtil,
  PervInfo, ExpireAuthF;

Const
  // MH 07/09/06: Increased req'd disk space to 500Mb from 70Mb as an IAO install is 329Mb with demo data!
  //DS_FullSystem : LongInt =  70000000;
  //TODO: check files system sizes
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
      GetVariable (DLLParams, 'L_DBTYPE', DBType);

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
                    edtPath.Text := DefDrv;
                    edtPathChange(frmSCDDirDlg);

// MH 11/10/05: Rebranded for Exchequer/LITE compatibility
//                    Instructions := 'Please specify the directory where you want to install Exchequer:';
//                    Title := 'Install Exchequer';
                    Instructions := 'Please specify the directory where you want to install the application:';
                    Title := 'Installation Directory';

                    If (ValidMode = 'i') Then
                    Begin
                      Instructions := 'Btrieve v6.15 is installed in the directory below, please click the &Next button to continue:';
                      ShellTreeView20051.Enabled := False;
                      edtPath.Enabled := False;
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
//                    edtPath.Text := DefDrv;
//                    edtPathChange(frmSCDDirDlg);

                    Instructions := 'Please specify the directory containing the program files for your ' +
                                    'Accounts system or click the &Find button to search for the directory:';
                    Title := 'Main Company';

                    WantFindEnt := 1;
                  End; { C }

            'c' : Begin { New Company - New Company Data Directory }
                    HelpContextID := 27;
                    //InstallPath := DefDrv;
                    edtPath.Text := DefDrv;
                    edtPathChange(frmSCDDirDlg);
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
  LocPosData[posEditHOfs] := Self.Height - edtPath.Top;
  LocPosData[posDirHOfs]  := Self.Height - ShellTreeView20051.Height;
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

  //Path.Top := Self.Height - LocPosData[posEditHOfs];
  //DirectoryListBox1.Height := Self.Height - LocPosData[posDirHOfs];
  //btnFindEnt.Top := BackBtn.Top;
end;

//-------------------------------------------------------------------------

Function TfrmSCDDirDlg.ValidPath (Path : ShortString) : Boolean;
Begin // ValidPath
  Path := UpperCase(Trim(Path));
  Result := (Length(Path) >= 2);
  If Result Then
    Result := (Path[1] In ['A'..'Z']) And (Path[2] = ':');
End; // ValidPath

//-------------------------------------------------------------------------

Function TfrmSCDDirDlg.GetPath : String;
Begin
  Result := edtPath.Text;
End;

Procedure TfrmSCDDirDlg.SetPath(Value : String);
Var
  sPath : ShortString;
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
    // Remove any double slashes as this is easy to do and fix
    sPath := StringReplace (sPath, '\\', '\', [rfReplaceAll]);

    Try
      ShellTreeView20051.Path := sPath;
      ShellTreeView20051.Selected.MakeVisible;
      If ShellTreeView20051.SelectedFolder.SubFolders Then
        ShellTreeView20051.Selected.Expand(False);
    Except
      // Bury errors - it wouldn't give the user confidence in the install
    End;
  End; // If ValidPath(sPath) And DirectoryExists(sPath)
End;

//-------------------------------------------------------------------------

Function TfrmSCDDirDlg.ValidOk(VCode : Char) : Boolean;
Var
  IniF                  : TIniFile;
  TmpPath, TmpPath2     : String;
  SNoArray              : SerialNoType;
  EntLicR               : EntLicenceRecType;

  Function GotData (Const DataPath : ShortString) : Boolean;
  Begin { GotData }
    if Trim(DbType) = '1' then
      // SQL
      Result := FileExists (DataPath + 'Company.Sys')
    else
      Result := FileExists (DataPath + PathSys) And             { EXCHQSS.DAT }
                FileExists (DataPath + Path1 + CustName) And    { CUST\CUSTSUPP.DAT }
                FileExists (DataPath + Path2 + DocName) And     { TRANS\DOCUMENT.DAT }
                FileExists (DataPath + Path2 + DetailName) And  { TRANS\DETAILS.DAT }
                FileExists (DataPath + Path3 + MiscNam) And     { MISC\EXSTKCHK.DAT }
                FileExists (DataPath + Path4 + MLocName) And    { STOCK\MLOCSTK.DAT }
                FileExists (DataPath + Path4 + StockNam);       { STOCK\STOCK.DAT }
  End; { GotData }

  { Updates the PATH statement for the current process to include the Enterprise directory }
  function SetEnterprisePath(const Path:String) : LongBool;
  var
    CurrentPath : String;
    EntDir      : String;
    NewPath     : ANSIString;
  Begin { SetEnterprisePath }
    // Get current PATH for the process
    CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

    // Check to see if it is already present in the path
    If (Pos(UpperCase(Path), UpperCase(CurrentPath)) = 0) Then Begin
      // Build the new path with the Enterprise directory at the start
      NewPath := Path + ';' + CurrentPath;

      // Update the environment settings for the current process
      SetEnvironmentVariable('PATH', PChar(NewPath));
    End; { If (Pos(UpperCase(EntDir), CurrentPath) = 0) }
  End; { SetEnterprisePath }

  //------------------------------

(**** MH 22/04/08: Rewrote to use SQLHELPR.Exe
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

    {check the handl}
    if _DLLHandle = 0 then
    begin
      {if something goes wrong, try seting the environment path variable to the current process}
      SetEnterprisePath(ExtractFilePath(LibPath));
      _DLLHandle := LoadLibrary(PCHAR(LibPath));
    end; {if _DLLHandle = 0 then}

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
****)

  Function CheckCompCount (Const CompPath : ShortString) : WordBool;
  Var
    LibPath         : ANSIString;
    hSetupSQL      : THandle;
    _SQLHLPR_CheckCompanyCount : Function (Const CompPath : ShortString) : WordBool; StdCall;
  Begin // CheckCompCount
    Result := False;

    // Load ENTCOMP.DLL dynamically
    LibPath := CompPath + 'SetupSQL.Dll';
    hSetupSQL := LoadLibrary(PCHAR(LibPath));
    If (hSetupSQL = 0) Then
    Begin
      // Failed - try adding the directory into the PATH
      SetEnterprisePath(ExtractFilePath(LibPath));
      hSetupSQL := LoadLibrary(PCHAR(LibPath));
    End; // If (hSetupSQL = 0)

    If (hSetupSQL > HInstance_Error) Then
    Begin
      Try
        _SQLHLPR_CheckCompanyCount := GetProcAddress(hSetupSQL, 'SQLHLPR_CheckCompanyCount');

        If Assigned(_SQLHLPR_CheckCompanyCount) Then
          Result := _SQLHLPR_CheckCompanyCount(CompPath);
      Finally
        FreeLibrary(hSetupSQL);
      End; // Try..Finally
    End; // If (hSetupSQL > HInstance_Error)
  End; // CheckCompCount

  //------------------------------

  function CheckBTrievePreReqs(const pDrive: String): Boolean;
  var
    lBTR: IPervasiveInfo;
    lDriveInfo : DriveInfoType;
  begin
    If (Trim(DbType) = '0') Then
    Begin
      // Pervasive Edition
      Result := False;

//ShowMessage('BTrieve Prereqs. Drive: ' + pDrive);

      if Trim(pDrive) <> '' then
      begin
        lBTR := PervasiveInfo;
        Try
          // Checks are dependant on the type of the drive containing Exchequer
          FillChar(lDriveInfo, SizeOF(DriveInfoType), #0);
          lDriveInfo.drDrive := pDrive[1];
          GetDriveInfo (lDriveInfo);

          if lDriveInfo.drDriveType = dtNetwork then
          begin
            // if network, it needs to be workgroup or server and version 8 or later
//ShowMessage('BTrieve Prereqs. Network drive. Client installed: ' + Inttostr(ord(lBtr.ClientInstalled)));

//ShowMessage ('Client Installed: ' + IntToStr(Ord(lbtr.ClientInstalled)) + ' - ' + FloatToStr(lBtr.ClientVersion));
//ShowMessage ('Server Installed: ' + IntToStr(Ord(lbtr.ServerInstalled)) + ' - ' + FloatToStr(lBtr.ServerVersion));

            Result := (lBtr.ClientInstalled and (lBtr.ClientVersion >= 8)) Or
                      (lbtr.ServerInstalled And (lBtr.ServerVersion >= 8)) Or
                      (lBtr.WorkgroupInstalled And (lbtr.WorkgroupVersion >= wv8));
          end // if lDriveInfo.drDriveType = dtNetwork
          else if lDriveInfo.drDriveType = dtFixed then
          begin
            // if local, it needs to be work client and v8
//ShowMessage('BTrieve Prereqs. Fixed drive. Server installed: ' +
//               Inttostr(ord(lBtr.ServerInstalled)) + ' Workgroup installed: ' + Inttostr(ord(lBtr.WorkgroupInstalled)));

//ShowMessage ('Server Installed: ' + IntToStr(Ord(lbtr.ServerInstalled)) + ' - ' + FloatToStr(lBtr.ServerVersion) + #13 +
//             'WorkGroup Installed: ' + IntToStr(Ord(lbtr.WorkgroupInstalled)) + ' - ' + IntToStr(Ord(lBtr.WorkgroupVersion)));

            Result := (lbtr.ServerInstalled And (lBtr.ServerVersion >= 8)) Or
                      (lbtr.WorkgroupInstalled and (lbtr.WorkgroupVersion >= wv8));
          end; // if lDriveInfo.drDriveType = dtFixed
        Finally
          lBTR := nil;
        End; // Try..Finally
      end; {if Trim(pDrive) <> '' then}
    End // If (Trim(DbType) = '0')
    Else
      // SQL Edition
      Result := True;
  end; {function CheckBTrievePreReqs: Boolean;}

Begin
//ShowMessage ('ValidOK.Start');
  Result := True;

  If (VCode = 'N') Then
  Begin
    { Check its a valid drive letter path }
    TmpPath := UpperCase(Trim(edtPath.Text));
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

                  If DirectoryExists(edtPath.Text) Then Begin
                    TmpPath := IncludeTrailingPathDelimiter(edtPath.Text);

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

                    if TRim(DbType) = '1' then
                    begin
                      If FileExists (TmpPath + 'Enter1.Exe') Then Begin
                        MessageDlg ('A system already exists in this directory and cannot be overwritten',
                                    mtWarning, [mbOK], 0);

                        Result := False;
                      End { If }
                      Else
                        { AOK - No Data }
                        Result := True;
                    end {if TRim(DbType) = '1' then}
                    else
                    begin
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
                    end; {else..begin}
                  End { If }
                  Else Begin
                    { AOK - If Path is set }
                    Result := (Trim(edtPath.Text) <> '');

                    If (Not Result) Then
                      MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                  End; { Else }
                End;

          'U' : Begin { Upgrade }
                  { Next }
                  //Showmessage('Upgrade 2');
                  Result := DirectoryExists(edtPath.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := IncludeTrailingPathDelimiter(edtPath.Text);

                    { Check for Exchequer/Enterprise Program files }
                    // MH 13/09/07: Added check for Conv600.Dat to prevent v5.71 installations being
                    // upgraded without the conversion having been run
                    Result := FileExists (TmpPath + 'ENTER1.EXE') And FileExists(TmpPath + 'Conv600.Dat');

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
                              //Result := FileExists(TmpPath2 + 'COMPANY.DAT') And
                              Result := FileExists(TmpPath2 + 'ENTRPRSE.DAT') And
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
                        //showmessage(inttostr(LicR.licEntDB) + ' ' + inttostr(LocLicR.licEntDB));
                        
                        { Copy details into local CD licence record }
                        LocLicR := licCopyEntLicToCDLic(EntLicR);

                        {VM: 03/05/2007 check if directory contains b-trieve and it is trying to install sql...}
                        if LicR.licEntDB <> LocLicR.licEntDB then
                        begin
                          MessageDlg ('This directory cannot be upgraded as it was installed with a different database type.' + #13+#10+
                                      'Please contact your technical support.', mtWarning, [mbOk], 0);

                          Result := False;
                        end
                        else

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
                          // MH 21/07/2014 v7.0.11 ABSEXCH-15467: Removed CD Serial Number Check.
                          //Result := (LicR.licSerialNo = LocLicR.licSerialNo);
                          Result := True;

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

//                              {VM: 03/05/2007 check if directory contains b-trieve and it is trying to install sql...}
//                              if LicR.licEntDB <> LocLicR.licEntDB then
//                              begin
//                                MessageDlg ('This directory cannot be upgraded as it was installed with a different database type.' + #13+#10+
//                                            'Please contact your technical support.', mtWarning, [mbOk], 0);
//
//                                Result := False;
//                              end;


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


                    if Result then
                    begin
                      // VM: 24/05/2007 check which version of the b-trieve is installed.
                      Result := CheckBTrievePreReqs(ExtractFileDrive(Trim(edtPath.Text)));

                      If Not Result Then
                        MessageDlg ('This directory cannot be upgraded as your system has an incompatible Pervasive Version.' + #13+#10+
                                    'Please contact your technical support.', mtWarning, [mbOk], 0);
                    end; {if Result then}

                    if Result then
                    begin
                      //PR: 11/10/2016 v2017-R1 ABSEXCH-17457 Warn user about expiry of Authoris-e - the function determines if a message needs to be shown
                      Result := ContinueWithExpireAuthorise(TmpPath, IncludeTrailingBackSlash(ExtractFileDir(Application.HelpFile)));
                    end;
                  End { If }
                  Else
                    MessageDlg ('This is not a valid path', mtWarning, [mbOk], 0);
                End; { u }

          'C' : Begin { New Company - Enterprise Directory }
                  { Next }
                  Result := DirectoryExists(edtPath.Text);

                  If Result Then Begin
                    { Check directory contents }
                    TmpPath := IncludeTrailingPathDelimiter(edtPath.Text);

                    { Check for data file }
                    // MH 13/09/07: Added check on Conv600.Dat to prevent installer being used to
                    // add companies into v5.7x installations
                    // MH 22/04/08: Added check on SQLHELPR.EXE for SQL Edition
                    // MH 08/01/09: Changed check to look for ICoreBtrv.Dll as SQLHelpr.Exe is a standard file from v6.01
                    Result := FileExists (TmpPath + 'ENTER1.EXE') And
                              //((DBType = '0') Or ((DBType = '1') And FileExists(TmpPath + 'SQLHELPR.EXE'))) And
                              (
                                ((DBType = '0') And (Not FileExists(TmpPath + 'ICoreBtrv.Dll')))
                                Or
                                ((DBType = '1') And FileExists(TmpPath + 'ICoreBtrv.Dll'))
                              ) And
                              FileExists (TmpPath + 'CONV600.DAT') And
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

                    If Result Then
                    Begin
                      // HM 16/07/01 v4.40: Check the Company Count to ensure free slots in the licence
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
                  Result := (Trim(edtPath.Text) <> '');

                  If Result Then Begin
                    If DirectoryExists (Trim(edtPath.Text)) Then Begin
                      TmpPath := IncludeTrailingPathDelimiter(edtPath.Text);

                      { Check directory doesnt already contain data }
                      Result := Not FileExists (TmpPath + 'EXCHQSS.DAT') and
                        not DirectoryExists (TmpPath + '\FORMS');

                      If (Not Result) Then
                        MessageDlg ('Data files already exist in this directory', mtWarning, [mbOk], 0);
                    End; { If }

                    if Result then
                    begin
                      // VM: 24/05/2007 check which version is installed.
                      Result := CheckBTrievePreReqs(ExtractFileDrive(Trim(edtPath.Text)));

                      If Not Result Then
                        MessageDlg ('The new company cannot be installed in this directory as your system has an incompatible Pervasive Version.' + #13+#10+
                                    'Please contact your technical support.', mtWarning, [mbOk], 0);
                    end; {if Result then}
                  End { If }
                  Else
                    MessageDlg ('The Installation Path must be set', mtWarning, [mbOk], 0);
                End;

          { ----- Single-CD Workstation Setup ----- }

          'L' : Begin { Local Program Files directory }
                  { Check for existing system }
                  If DirectoryExists(edtPath.Text) Then Begin
                    TmpPath := IncludeTrailingPathDelimiter(edtPath.Text);

                    { Check directory doesnt already contain data }
                    Result := Not FileExists (TmpPath + 'EXCHQSS.DAT') and
                      not DirectoryExists (TmpPath + '\FORMS');
                      
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
                    Result := (Trim(edtPath.Text) <> '');

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
//ShowMessage ('ValidOK.Fini');
End;



Function TfrmSCDDirDlg.CheckSpace (ReqLong : LongInt) : Boolean;
Var
  fDriveNo          : Smallint;
  FreeSpace, ReqDbl : Double;
Begin
  Result := False;
  ReqDbl := ReqLong;

  { Calculate drive number }
  fDriveNo:=Ord(UPCase(edtPath.Text[1]))-64;

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
    edtPath.Style := csDropDown;
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
      frmFindDlg.ShellComboBox20051.Path := IncludeTrailingPathDelimiter(ExtractFileDrive(ShellTreeView20051.Path));
      frmFindDlg.FindMode := FFindEnt;
      If (LicR.licEntCVer = 0) Then
        frmFindDlg.CurrMode := 'S'
      Else
        frmFindDlg.CurrMode := 'M';
      frmFindDlg.PathList := edtPath;

      frmFindDlg.Title := 'Find Accounts Directory';

      frmFindDlg.ShowModal;

      { run through list deleting any duplicate paths }
      If (edtPath.Items.Count > 1) Then Begin
        TmpStr := edtPath.Text;

        I := 1;
        While I <= Pred(edtPath.Items.Count) Do Begin
          If (edtPath.Items[I] = edtPath.Items[Pred(I)]) Then Begin
            { Delete duplicate item }
            edtPath.Items.Delete(I);
          End { If }
          Else Begin
            { AOK - move to next }
            Inc (I);
          End; { Else }
        End; { While }

        edtPath.Text := TmpStr;
      End; { If }

      If (frmFindDlg.ExitCode = 'N') Then Begin
        { A path was selected - setup drive/dir to look at it }
        edtPath.Text := frmFindDlg.lstDirs.Items[frmFindDlg.lstDirs.ItemIndex];
        edtPathChange(Sender);
      End; { If }
    Finally
      frmFindDlg.Free;
    End;
  End; { If }
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.imgBackdoorDblClick(Sender: TObject);
begin
  ShellTreeView20051.Enabled := True;
  edtPath.Enabled := True;
  imgBackdoor.Enabled := False;
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.ShellTreeView20051AddFolder(Sender: TObject; AFolder: TShellFolder; var CanAdd: Boolean);
Var
  DriveInfo : DriveInfoType;
begin
  If (AFolder.Level = 1) Then
  Begin
    // Filter out Control Panel and CD/DVD Drives
    CanAdd := (UpperCase(AFolder.DisplayName) <> 'CONTROL PANEL');
//ShowMessage (AFolder.DisplayName + ': ' + IntToStr(Ord(CanAdd)));
    If CanAdd Then
    Begin
      DriveInfo.drDrive := AFolder.PathName[1];
      If GetDriveInfo (DriveInfo) Then
      Begin
        CanAdd := Not (DriveInfo.drDriveType In [dtFloppy, dtCDROM])
      End; // If GetDriveInfo (DriveInfo)
    End; // If CanAdd
  End; // If (AFolder.Level = 1)
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.ShellTreeView20051Change(Sender: TObject; Node: TTreeNode);
Var
  sPath : ShortString;
  Thing, ss, sl : Byte;
begin
  If ValidPath(ShellTreeView20051.Path) Then
  Begin
    If (Not FInChange) Then
    Begin
      edtPath.Text := ShellTreeView20051.Path;
      edtPath.SelStart := Length(edtPath.Text);
    End // If (Not FInChange)
    Else
    Begin
      // Update the path in the edit box to have the correct capitalisation for the valid part of the path
      ss := edtPath.SelStart;
      sl := edtPath.SelLength;
      Thing := Length(ShellTreeView20051.Path);
      If (Length(edtPath.Text) < Thing) Then Thing := Length(edtPath.Text);
      sPath := edtPath.Text;
      Delete(sPath, 1, Thing);
      edtPath.Text := Copy (ShellTreeView20051.Path, 1, Thing) + sPath;
      edtPath.SelStart := ss;
      edtPath.SelLength := sl;
    End; // Else
  End; // If ValidPath(ShellTreeView20051.Path)
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.edtPathChange(Sender: TObject);
begin
  FInChange := True;
  Try
    InstallPath := edtPath.Text;
  Finally
    FInChange := False;
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfrmSCDDirDlg.edtPathKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Var
  sDir    : ShortString;
  iFolders, iPos : SmallInt;
begin
  If (Key = VK_RIGHT) And (Shift = [ssCtrl]) And ShellTreeView20051.SelectedFolder.SubFolders Then
  Begin
    // Extract the incomplete directory name from the edit field and search the sub-directories
    // off the selected directory in the list for a match
    If (Length(edtPath.Text) > Length(ShellTreeView20051.Path)) Then
    Begin
      sDir := Trim(UpperCase(Copy (edtPath.Text, Length(IncludeTrailingPathDelimiter(ShellTreeView20051.Path))+1, 100)));

      For iFolders := 0 To (ShellTreeView20051.Selected.Count - 1) Do
      Begin
        iPos := Pos(sDir, Trim(UpperCase(ShellTreeView20051.Selected.Item[iFolders].Text)));
        If (iPos = 1) Then
        Begin
          edtPath.Text := IncludeTrailingPathDelimiter(ShellTreeView20051.Path) + IncludeTrailingPathDelimiter(ShellTreeView20051.Selected.Item[iFolders].Text);
          edtPath.SelLength := 0;
          edtPath.SelStart := Length(edtPath.Text);
          Break;
        End; // If (iPos = 1)
      End; // For iFolders
    End; // If (Length(edtPath.Text) > Length(ShellTreeView20051.Path))
  End; // If (Key = VK_RIGHT) And (Shift = ssCtrl)
end;

//-------------------------------------------------------------------------

//function TfrmSCDDirDlg.CheckBTrieveVersion(var DLLParams: ParamRec; pPath: ShortString): Boolean;
//var
//  BTRINST,    // btrieve is installed...
//  BTRCLTINST, // client is installed
//  BTRSRVINST, // server installed
//  BTRWKGINST, // work group installed
//  BTRWKGVER: String;  // work group version
//  lDriveInfo: DriveInfoType;
//begin
//  GetVariable(DLLParams,'BTRINST',  BTRINST);
//  GetVariable(DLLParams,'BTRCLTINST', BTRCLTINST);
//  GetVariable(DLLParams,'BTRSRVINST', BTRSRVINST);
//  GetVariable(DLLParams,'BTRWKGINST', BTRWKGINST);
//  GetVariable(DLLParams,'BTRWKGVER', BTRWKGVER);
//
//  lDriveInfo.drDrive := ExtractFileDrive(pPath)[1];
//
//  FillChar(lDriveInfo, SizeOf(DriveInfoType), 0);;
//  diskutil.GetDriveInfo(lDriveInfo);
//end;

end.
