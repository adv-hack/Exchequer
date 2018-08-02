unit FaxCForm;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


// System Tray Icon Code based on article 'Windows 95 Tray Icons' by Marco Cantu
// The Delphi Magazine Issue 12, August 1996

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , Menus, ShellAPI, OoMisc, AdFaxCtl, StdCtrls, VarConst, FaxUtils, ExtCtrls
  , GlobVar, APIUtil, BTSupU1, About, PDrvInNT, ImgList, IniFiles, CompUtil;
const
  wm_IconMessage = wm_User;

type
  TFaxRecMode = (recInsert,recUpdate);
  PHWND = ^HWND;

  TfrmFaxClient = class(TForm)
    mnuPopUp: TPopupMenu;
    Close1: TMenuItem;
    OpenDialogWin95: TOpenDialog;
    OpenDialogWinNT: TOpenDialog;
    faxicon: TImage;
    ViewMyFaxes1: TMenuItem;
    About1: TMenuItem;
    ImageList1: TImageList;
    Help1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    InstallDriver1: TMenuItem;
    ApdFaxDriver: TApdFaxDriverInterface;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApdFaxDriverDocEnd(Sender: TObject);
    procedure ApdFaxDriverDocStart(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure mnuCloseClick(Sender: TObject);
    procedure ViewMyFaxes1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Help1Click(Sender: TObject);
    procedure InstallDriver1Click(Sender: TObject);
 private
    nid : TNotifyIconData;
    bUserRemoved, bBeenAskedYet, Closing, bCancelled, bOKToShowMenu, fFaxFileOpenedOK : boolean;
    fFaxDetails : PFaxDetails;
    fLockPos : longint;
    fFaxRecMode : TFaxRecMode;
    fFaxDirs : TFaxDirs;
    fFaxClientRoot : string;
{    ApdFaxDriver : TApdFaxDriverInterface;}
    hFaxAdmin, FaxInfoDLL : THandle;
    UserListIni : TIniFile;
    FaxInfo : function (FaxNo, RecipientName, SenderName, DocDesc, SenderEmail : PChar;
                var Priority : char) : boolean; stdcall;
    procedure SetAPFFileName(Priority : char);
    function  WinNTDLLCheck(var DLLLocation : string) : boolean;
    function  APFDriverFound(bCheck : boolean) : boolean;
    procedure RemoveUser;
 public
    bDebug : boolean;
    procedure IconTray(var Msg : TMessage); message wm_IconMessage;
 end;

var
  frmFaxClient: TfrmFaxClient;
  function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;

implementation

{$R *.DFM}
{$R PHONE.RES}
uses
  RunFirst, UFaxBtrv, RPDevice, PDrvInst, WinSpool;

type
  TRPDeviceItem = class
    FDeviceName: PChar;
    FDriverName: PChar;
    FOutputName: PChar;
  end;
//-----------------------------------------------------------------------

procedure TfrmFaxClient.IconTray(var Msg : TMessage);
{This dictates what happens when a mouse event happens on the tray icon}
var
  Pt : TPoint;
begin
  if bOKToShowMenu then begin
    case Msg.lParam of
      {Right Button Click}
      WM_RBUTTONDOWN : begin
        SetForegroundWindow(Handle);
        GetCursorPos(Pt);
        mnuPopup.Popup(Pt.x, Pt.y);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;

      {Double Click Click}
      WM_LBUTTONDBLCLK : begin
        SetForegroundWindow(Handle);
        ViewMyFaxes1Click(Self);
        PostMessage(Handle, WM_NULL, 0, 0);
      end;
    end;{case}
  end;{if}
end; // TfrmFaxClient.IconTray

//-----------------------------------------------------------------------

function TfrmFaxClient.WinNTDLLCheck(var DLLLocation : string) : boolean;
// Post  : If the user had to select the DLL file then we already know its location,
//         so return it in DLLLocation.
// Notes : WinNTFaxDriverInstalledOK uses the NT driver DLL to check for the driver
//         so before that routine is called the DLL must be present.
//         Code modified from PDrvInNT routine InstalledOK
var
  zDriverFile : PChar;
  DriverDir : PChar;
  SizeNeeded : DWord;
  TempStr : ShortString;
  Instance : THandle;
{  SourceDriverDir : string;}
{  SourceDriverFile : PChar;}
begin
  DLLLocation := '';
  DriverDir := StrAlloc(255);
  GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
  TempStr := IncludeTrailingBackslash(StrPas(DriverDir));
  zDriverFile := StrAlloc(255);
  StrPCopy(zDriverFile,TempStr+StrPas(DriverFileName));
  if bDebug then ShowMessage('zDriverFile : '+ zDriverFile);
  Instance := LoadLibrary(zDriverFile);
  Result := Instance > HInstance_Error;

  if Result then FreeLibrary(Instance)
  else begin
(*    SourceDriverDir := ExtractFilePath(ParamStr(0));
    if not FileExists(SourceDriverDir + DriverFileName) then
    begin
      OpenDialogWinNT.Execute;
      SourceDriverDir := ExtractFilePath(OpenDialogWinNT.FileName);
    end;
    SourceDriverFile := StrAlloc(255);
    StrPCopy(SourceDriverFile, SourceDriverDir + StrPas(DriverFileName));
    Result := CopyFile(SourceDriverFile, zDriverFile, true);
    if Result then begin
      DLLLocation := SourceDriverDir;
      // Under NT there is a delay before the file is physically copied
      // Wait for this to happen before later code which relies on the DLL
      // being present runs.
      repeat
        Delay(200, Application);
      until FileExists(zDriverFile);
    end;{if}
    StrDispose(SourceDriverFile);*)
  end;{if}
  StrDispose(DriverDir);
  StrDispose(zDriverFile);
end; // TfrmFaxClient.WinNTDLLCheck

//-----------------------------------------------------------------------

function TfrmFaxClient.APFDriverFound(bCheck : boolean) : boolean;
const
  DRIVER_NAME = '''Print to Fax'' Driver';
  WIN_95_DRIVER_FILE = 'APFGEN.DRV';
  WIN_95_DRIVER = 'APFGEN';
var
  PrintDriverDir, PrintDriverFile, sDriverDir, sWinSysDir, PrintDriverName  : string;
  OpenDialog : TOpenDialog;
  pWinSysDir : array[0..255] of Char;
  DriverDir : pChar;
  SizeNeeded  : DWord;

{  zDriverFile : PChar;
  DriverDir : PChar;
  TempStr : ShortString;
  SizeNeeded : DWord;}
  iPos : integer;
  bContinue : boolean;
begin
  bContinue := not bCheck;

  if IsWinNT then
    begin
      PrintDriverFile := DriverFileName; // Defined in PDrvInNT
      PrintDriverName := DriverName; // Defined in PDrvInNT
      OpenDialog := OpenDialogWinNT;
      if bDebug then ShowMessage('DriverFileName : ' + DriverFileName + #13#13 +
      'DriverName : ' + DriverName);
    end
  else begin
    PrintDriverFile := WIN_95_DRIVER_FILE;
    PrintDriverName := WIN_95_DRIVER;
    OpenDialog := OpenDialogWin95;
  end;{if}

  if bCheck then begin
    if IsWinNT then
      begin
        Result := false;
        if WinNTDLLCheck(PrintDriverDir) then begin {Check for Files (I Think)}
          {Check that there is a 'Print to Fax' driver in the printers list}
          for iPos := 0 to RPDev.Printers.count - 1 do begin
            if Copy(RPDev.Printers[iPos],1,12) = 'Print to Fax' then Result := TRUE;
          end;
        end;{if}
      end
    else begin
      Result := RPDev.CheckForDriver(PrintDriverName);
    end;{if}

    PrintDriverDir := '';

    if not Result and (MessageDlg('The Exchequer Fax Client will not function without the'
    + CRLF + DRIVER_NAME + '.' + CRLF + CRLF + 'Do you wish to install this now ?' + CRLF + CRLF
    + 'N.B. You may require Windows installation disks.', mtWarning, [mbYes,mbNo]
    , 0) = mrYes) then bContinue := TRUE;
  end;{if}

  if bContinue then begin
    GetSystemDirectory(pWinSysDir, 256);
    sWinSysDir := IncludeTrailingBackslash(pWinSysDir);

    DriverDir := StrAlloc(255);
    GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
    sDriverDir := IncludeTrailingBackslash(DriverDir);
    StrDispose(DriverDir);

    if PrintDriverDir = '' then begin
      // Look for driver file in current directory
      PrintDriverDir := ExtractFilePath(ParamStr(0));
      if (not FileExists(PrintDriverDir + PrintDriverFile)) then begin
        if FileExists(sWinSysDir + PrintDriverFile) then PrintDriverDir := sWinSysDir
        else begin
          if FileExists(sDriverDir + PrintDriverFile) then PrintDriverDir := sDriverDir
          else begin
            OpenDialog.Execute;
            PrintDriverDir := ExtractFilePath(OpenDialog.FileName);
          end;{if}
        end;{if}
      end;
    end;{if}

    if IsWinNt then
      begin
        if InstallDriver32(PrintDriverDir) then begin
{          GetPrinterDriverDirectory(nil, nil, 1, DriverDir, 255, SizeNeeded);
          TempStr := IncludeTrailingBackslash(StrPas(DriverDir));
          zDriverFile := StrAlloc(255);
          StrPCopy(zDriverFile,TempStr+StrPas(DriverFileName));
          repeat
            Delay(200, Application);
          until FileExists(zDriverFile);}
        end;{if}
      end
    else InstallDriver(PrintDriverDir + PrintDriverFile);

    Result := DrvInstallError = ecOK;
    // Copied from Async Pro demo code in PINST.DPR ...
    case DrvInstallError of
      ecOK :
        MessageDlg('The Exchequer Fax Driver ''Print to Fax'' has been sucessfully installed.', mtInformation, [mbOK], 0);
      ecUniCannotGetSysDir :
        MessageDlg('Couldn''t determine Windows\System directory', mtError, [mbOK], 0);
      ecUniCannotGetPrinterDriverDir :
        MessageDlg('Couldn''t determine Windows NT printer driver directory', mtError, [mbOK], 0);
      ecUniCannotGetWinDir :
        MessageDlg('Couldn''t determine Windows directory', mtError, [mbOK], 0);
      ecUniUnknownLayout :
        MessageDlg('   -- Unknown Windows Layout --' + CRLF +
                   'Unable to locate  required  support' + CRLF + 'files', mtError, [mbOK], 0);
      ecUniCannotParseInfFile :
        MessageDlg('Cannot locate unidriver files in'+ CRLF+
                 'Windows Setup (INF) file.', mtError, [mbOK], 0);
      ecUniCannotInstallFile :
        MessageDlg('Unidriver files '+
                   'not installed.  The print driver'+#13+
                   'may not be configured properly.',
                    mtError, [mbOK], 0);
      ecNotNTDriver :
        MessageDlg('This printer driver is not compatible with Windows NT',
                   mtError, [mbOK], 0);
      ecDrvCopyError :
        MessageDlg('Unable to copy printer driver to Windows system directory',
                   mtError, [mbOK], 0);
      ecCannotAddPrinter :
        MessageDlg('Could not install ' + DRIVER_NAME + ' as a Windows printer',
                   mtError, [mbOK], 0);
      ecDrvBadResources :
        MessageDlg('Printer driver file contains bad or missing string resources',
                   mtError, [mbOK], 0);
      ecDrvDriverNotFound :
        MessageDlg(format('A required printer driver file %s was not found',[ErrorFile]),
                   mtError, [mbOK], 0);

      {NF : Added to create a different error. It seems to occur on some
      NT machines when you don't have the rights to add printers}
      -8093 :
        MessageDlg(format('The printer monitor could not be added.' + CHR(13) + CHR(13)
        + 'You may not have access rights to do this.',[ErrorFile]), mtError, [mbOK], 0);

    else
      MessageDlg('Unknown installation error : '+ IntToStr(DrvInstallError), mtError, [mbOK], 0);
    end; // case
  end; // Attempted to install driver
end; // TfrmFaxClient.APFDriverFound

//-----------------------------------------------------------------------

procedure TfrmFaxClient.FormCreate(Sender: TObject);
var
  CloseApp : boolean;
  sFileName : string;

  procedure CheckParams;
  var
    ParamNo : byte;
    BtrieveDir : string;
  begin
    // ParamStr[0] = Application name and location
    ParamNo := 1;
    bDebug := FALSE;
    while (ParamNo <= ParamCount) do begin
      if UpperCase(ParamStr(ParamNo)) = '/SHOWPIPENAME' then ShowMessage('Pipename : ' + ApdPipeName + sExtraPipeName);
      if UpperCase(ParamStr(ParamNo)) = '/DEBUG' then bDebug := TRUE;
      inc(ParamNo);
    end;{while}
  end;{CheckParams}

begin
  {NF: Added 21/03/2001}
  if GetWindowsVersion in wvTSVersions then sExtraPipeName := WinGetUserName
  else sExtraPipeName := '';

  CheckParams;


  bOKToShowMenu := FALSE;
  bBeenAskedYet := FALSE;
  fFaxClientRoot := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
  if APFDriverFound(TRUE) then
    begin
      // If the Fax driver interface component is on the form, its constructor is
      // called when the form is created.  If the driver files are not installed
      // this can lead to a 'Can't create named pipe' error under NT.  Therefore
      // programmatically create the interface after checks for the drivers being
      // installed.

      {create INI File entry for user}
      bUserRemoved := FALSE;
      sFileName := ExtractFilePath(application.ExeName) + 'CLNTUSER.INI';
      UserListIni := TIniFile.Create(sFileName);
      UserListIni.WriteString('Logged In', WinGetComputerName, WinGetUserName);
      UserListIni.UpdateFile;

{      ApdFaxDriver := TApdFaxDriverInterface.Create(self);
      ApdFaxDriver.OnDocStart := ApdFaxDriverDocStart;
      ApdFaxDriver.OnDocEnd := ApdFaxDriverDocEnd;}

      Closing := false;

      with nid do begin
        cbSize := sizeof(nid);
        wnd := Handle;
        uID := 1;
        uCallBackMessage := wm_IconMessage;
        hIcon := FaxIcon.Picture.Icon.Handle;
        szTip := 'Exchequer Fax Client';
        uFlags := nif_Message or nif_Icon or nif_Tip;
      end;{with}
      Shell_NotifyIcon(NIM_ADD, @nid);

      SetBtrieveLocation;
      if OpenFaxFile(true) then
        begin
          SetFaxDirectories(fFaxDirs, fFaxClientRoot);

{          if not CheckFaxServerRunning then
            MessageDlg('Either the Exchequer Fax Server is not running,' + CRLF
            + 'or the Btrieve settings on this machine are incorrect.' + CRLF
            + CRLF + 'Please check with your administrator.'
            , mtWarning, [mbOK], 0);}
          CloseFaxFile;

          FaxInfoDLL := LoadLibrary('FaxInfo');
          if FaxInfoDLL > HInstance_Error then
            FaxInfo := GetProcAddress(FaxInfoDLL, 'FaxInfoDialog');
          CloseApp := not Assigned(FaxInfo);
        end
      else CloseApp := true;
    end
  else CloseApp := true;

  if CloseApp then Halt {Application.Terminate}
  else begin
    { HM 23/03/99: Set Window Long so Enterprise can uniquely identify }
    {              whether the Fax Client is running or not.           }
    SetWindowLong (Handle, GWL_USERDATA, 1010);
  end;{if}
  bOKToShowMenu := TRUE;
end; // TfrmFaxClient.FormCreate

//-----------------------------------------------------------------------

procedure TfrmFaxClient.FormDestroy(Sender: TObject);
begin
  nid.uFlags := 0;
  Shell_NotifyIcon(NIM_DELETE, @nid);
  FreeLibrary(FaxInfoDLL);
  Application.ProcessMessages;
end; // TfrmFaxClient.FormDestroy

//-----------------------------------------------------------------------

procedure TfrmFaxClient.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  hFaxAdminWin : HWnd;
begin

  if not Closing then begin
    Action := caNone;
    ShowWindow(Handle, sw_Hide);
  end;{if}

  {Close Fax Administrator if it is open}
  hFaxAdminWin := 0;
  EnumWindows(@EnumWndProc, Longint(@hFaxAdminWin));
  if (hFaxAdminWin <> 0) then PostMessage(hFaxAdminWin, WM_Close, 0, 0);
end; // TfrmFaxClient.FormClose

//-----------------------------------------------------------------------

procedure TfrmFaxClient.SetAPFFileName(Priority : char);
var
  Status : TKnownFaxStatus;
  sFileName : string;
begin
  if bDebug then ShowMessage('fFaxDirs[fxsNormal] : ' + fFaxDirs[fxsNormal]);
  with fFaxDetails^ do begin
    FaxAPFName := LeftPadStr(IntToStr(SetNextFaxCounter),8,'0') + APF_EXT;
    Status := PriorityCharToEnum(Priority);
    if fFaxDirs[Status] = '' then sFileName := IncludeTrailingBackslash(fFaxDirs[fxsNormal]) + FaxAPFName
    else sFileName := IncludeTrailingBackslash(fFaxDirs[Status]) + FaxAPFName;
    if bDebug then ShowMessage('sFileName B4 UNC : ' + sFileName);
    sFileName := ExpandUNCFileName(sFileName);
    ApdFaxDriver.FileName := sFileName;
  end;{with}
  if bDebug then ShowMessage('sFileName After UNC : ' + sFileName);
end; // TfrmFaxClient.SetAPFFileName

//-----------------------------------------------------------------------


procedure TfrmFaxClient.ApdFaxDriverDocStart(Sender: TObject);
var
  Num     : array[0..20] of char;
  FaxTo   : array[0..80] of char;
  FaxFrom : array[0..80] of char;
  DocDesc : array[0..80] of char;
  SenderEmail : array[0..100] of char;
  Priority : char;
  Win2kFaxIni : TIniFile;
  sSection, sDocName : string;

  procedure InitialiseDialogVars;
  begin
    FillChar(Num, SizeOf(Num),#0);
    FillChar(FaxTo, SizeOf(FaxTo), #0);
    FillChar(FaxFrom, SizeOf(FaxFrom), #0);
    FillChar(DocDesc, SizeOf(DocDesc), #0);
    FillChar(SenderEmail, SizeOf(SenderEmail), #0);
    Priority := 'N';
  end;

begin // TfrmFaxClient.ApdFaxDriverDocStart

  if bDebug then ShowMessage('ApdFaxDriverDocStart Reached');

  {new Windows 2000 fix}
  if GetWindowsVersion in [wv2000, wv2000TerminalServer] then
    begin
      Win2kFaxIni := TInifile.create(SetDrive + 'WIN2KFAX.INI');
      sSection := Uppercase(WinGetUserName + ':' + WinGetComputerName);
      sDocName := Win2kFaxIni.ReadString(sSection,'UniqueKey',ApdFaxDriver.DocName);
      Win2kFaxIni.EraseSection(sSection);
{      Win2kFaxIni.WriteString('Debug',FormatDateTime('HHNNSSZZZ',now),'EraseSection : ' + sDocName);}
    end
  else sDocName := ApdFaxDriver.DocName;

  fFaxFileOpenedOK := FALSE;
  if sDocName = '' then MsgBox('Could not find the required fax files - This fax will not be sent.' + CHR(13) + CHR(13)
  + 'Please check the ''Fax Interface Path'' in the System Setup of Exchequer.',mtError,[mbOK],mbOK,'Faxing Error')
  else begin
    fFaxFileOpenedOK := OpenFaxFile(false);
    if fFaxFileOpenedOK then begin
      if (not CheckFaxServerRunning) and (Not bBeenAskedYet) then
        begin
          bCancelled := (Application.MessageBox('Could not communicate with the fax server.'
          + CRLF + 'Either the Exchequer Fax Server is not running,' + CRLF
          + 'or the configuration of this machine is incorrect.' + CRLF + CRLF
          + 'Do you still want to send this Fax ?', 'Fax Server',MB_YESNO + MB_SYSTEMMODAL
          + MB_ICONQUESTION) = mrNo);
          bBeenAskedYet := TRUE;
        end
      else bCancelled := FALSE;

      {send Fax}
      new(fFaxDetails);
      FillChar(fFaxDetails^,SizeOf(fFaxDetails^),#0);
      // Default to insert fax details record
      // Duplicate document names OK, as long as APF file names both not blank and unique
      fFaxRecMode := recInsert;
      // Check for record with an identical document name, if found and the APFName is blank
      // need to lock and update

      if bDebug then begin
        ShowMessage('sDocName : ' + sDocName);
        if FindFaxDetails(sDocName, 'D', fFaxDetails) then ShowMessage('FindFaxDetails = TRUE')
        else ShowMessage('FindFaxDetails = FALSE');

        ShowMessage('fFaxDetails.FaxAPFName : ' + fFaxDetails.FaxAPFName);
      end;{if}

      if (FindFaxDetails(sDocName, 'D', fFaxDetails))
      and (fFaxDetails.FaxAPFName = '') then begin
        {fax from enterprise}
        if FindAndLockFaxDetails(sDocName, 'D', fFaxDetails, fLockPos) then begin
{          fFaxDetails^.FaxUserDesc := 'Enterprise Fax';}
          fFaxDetails^.FaxUserDesc := 'Exchequer Fax - ' + fFaxDetails^.FaxUserDesc;
          SetAPFFileName(fFaxDetails^.FaxPriority);
          fFaxRecMode := recUpdate;
        end;{if}
      end;{if}

      if (fFaxRecMode = recInsert) and (not bCancelled) then
        {fax from other application}
        begin // Show fax information dialog
          InitialiseDialogVars;
          UserDefaults(FaxFrom, SenderEmail, iniRead);
          with fFaxDetails^ do begin
            StrPCopy(DocDesc, sDocName);
            Close1.Enabled := FALSE;
            if FaxInfo(Num,FaxTo,FaxFrom,DocDesc,SenderEmail,Priority) then
              begin // User accepted
                FaxNumber := Trim(Num);
                FaxRecipientName := Trim(FaxTo);
                FaxSenderName := Trim(FaxFrom);
                FaxUserDesc := Trim(DocDesc);
                FaxSenderEmail := Trim(SenderEmail);
                FaxUserName := WinGetUserName;
                FaxCancel := FALSE;
                FaxHold := FALSE;
                FaxBusyRetries := 0;
                UserDefaults(FaxFrom, SenderEmail, iniWrite);
              end
            else bCancelled := TRUE; // User cancelled
            Close1.Enabled := TRUE;
            // Populate whether user accepted or cancelled
            FaxDocName := SpacePad(sDocName,80);
            SetAPFFileName(Priority);
          end; // with
        end
      else begin
{        InitialiseDialogVars;}
        UserDefaults(FaxFrom, SenderEmail, iniRead);
        fFaxDetails^.FaxDocName := SpacePad(sDocName,80);
{        SetAPFFileName(Priority);}
      end;{if}
    end; // Fax Btrieve file opened OK
  end;{if}
end; // TfrmFaxClient.ApdFaxDriverDocStart

//-----------------------------------------------------------------------

procedure TfrmFaxClient.ApdFaxDriverDocEnd(Sender: TObject);
begin
  if fFaxFileOpenedOK then begin
    fFaxDetails.FaxCancel := bCancelled;
{    if bCancelled then SetAPFFileName('N');}
    if fFaxRecMode = recInsert then InsertFaxDetails(fFaxDetails)
    else UpdateFaxDetails('D',fFaxDetails,fLockPos);
    CloseFaxFile;
    dispose(fFaxDetails);
  end;{if}
end; // TfrmFaxClient.ApdFaxDriverDocEnd

//-----------------------------------------------------------------------

procedure TfrmFaxClient.Close1Click(Sender: TObject);
begin
  Closing := True;
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxClient.mnuCloseClick(Sender: TObject);
begin
  Closing := true;
  Close;
end;

procedure TfrmFaxClient.ViewMyFaxes1Click(Sender: TObject);
var
  hFaxAdminWin : HWnd;
begin
  {Find Fax Administrator window}
  hFaxAdminWin := 0;
  EnumWindows(@EnumWndProc, Longint(@hFaxAdminWin));

  {Open/Pop-up Fax Administrator}
  if (hFaxAdminWin = 0) then hFaxAdmin := RunApp(SetDrive + 'FAXADMIN.EXE', FALSE)
  else begin
    BringWindowToTop(hFaxAdminWin); {Bring Fax Admin Window To Front}
    PostMessage(hFaxAdminWin,WM_FormStateMsg,SC_RESTORE,0); {Restore Window if minimized (message handled in faxadmin)}
  end;{if}
end;

function EnumWndProc (Hwnd: THandle; FoundWnd: PHWND): Bool; export; stdcall;
{ Callback function to identify the Fax Admin window }
var
  ClassName : string;
  Tag       : THandle;
begin
  Result := True;
  SetLength (ClassName, 100);
  GetClassName (Hwnd, PChar (ClassName), Length (ClassName));
  ClassName := PChar (Trim(ClassName));

  if (AnsiCompareText (ClassName, 'TfrmMain') = 0) then begin
    Tag := GetWindowLong (Hwnd, GWL_USERDATA);
    if (Tag = 2323) then begin
      FoundWnd^ := Hwnd;
      Result := False;
    end;{if}
  end;{if}
end;

procedure TfrmFaxClient.About1Click(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Self);
  frmAbout.ShowModal;
  frmAbout.Release;
end;

procedure TfrmFaxClient.RemoveUser;
begin
  if not bUserRemoved then begin
    UserListIni.DeleteKey('Logged In', WinGetComputerName);
    UserListIni.UpdateFile;
    UserListIni.Free;
    bUserRemoved := TRUE;
  end;{if}
end;


procedure TfrmFaxClient.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  RemoveUser;
end;

procedure TfrmFaxClient.Help1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmFaxClient.InstallDriver1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to install the fax printer driver ?',mtConfirmation,[mbYes, mbNo]
  , mbYes,'Driver Install') = mrYes then APFDriverFound(FALSE);
end;

end.
