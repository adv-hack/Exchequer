unit FaxStat;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, APIUtil,
  ComCtrls, Buttons, SBSPanel, ExtCtrls, Grids, Outline, DirOutln, StdCtrls,
  VarConst, FaxUtils, AdFax, AdTapi, OoMisc, AdPort, {AdModem,} Menus, BTSupU1
  ,AdFStat, TEditVal, FaxClass, ImgList, About, {NeilProc,} Password, Crypto,
  CommsInt, AdStatLt, Inifiles, DailyPW, Registry, FaxmanJr_TLB, OleCtrls;

type
  TfrmFaxStatus = class(TForm)
    tmrFaxSearch: TTimer;
    tmrAdminCheck: TTimer;
    mnuMain: TMainMenu;
    mnuFile: TMenuItem;
    mnuExit: TMenuItem;
    mnuTools: TMenuItem;
    mnuSystemClearDown: TMenuItem;
    N2: TMenuItem;
    mnuPauseSender: TMenuItem;
    mnuServerParameters: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    pbrCurPageProgress: TProgressBar;
    Image1: TImage;
    lStatus: TLabel;
    lPage: TLabel;
    lFilename: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    DialNow1: TMenuItem;
    lDocument: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    lSender: TLabel;
    Label7: TLabel;
    lRecipient: TLabel;
    pbTotal: TProgressBar;
    Label6: TLabel;
    Label8: TLabel;
    AbortFax1: TMenuItem;
    N1: TMenuItem;
    Contents1: TMenuItem;
    SearchforHelpon1: TMenuItem;
    HowtouseHelp1: TMenuItem;
    HowTo1: TMenuItem;
    Troubleshooting1: TMenuItem;
    N3: TMenuItem;
    MenuImages: TImageList;
    FaxmanJr1: TFaxmanJr;
    procedure FormCreate(Sender: TObject);
    procedure ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure tmrAdminCheckTimer(Sender: TObject);
    procedure tmrFaxSearchTimer(Sender: TObject);
    procedure ApdTapiDevice1TapiPortOpen(Sender: TObject);
    procedure ApdTapiDevice1TapiPortClose(Sender: TObject);
    procedure ApdSendFax1FaxStatus(const pStatObj: IFaxStatusObj);
    procedure FormActivate(Sender: TObject);
    procedure mnuExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mnuPauseSenderClick(Sender: TObject);
    procedure mnuServerParametersClick(Sender: TObject);
    procedure mnuSystemClearDownClick(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure DialNow1Click(Sender: TObject);
    procedure AbortFax1Click(Sender: TObject);
    procedure Contents1Click(Sender: TObject);
    procedure SearchforHelpon1Click(Sender: TObject);
    procedure HowtouseHelp1Click(Sender: TObject);
    procedure HowTo1Click(Sender: TObject);
    procedure Troubleshooting1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FaxmanJr1CompletionStatus(Sender: TObject;
      const pStatObj: IFaxStatusObj);
    procedure FaxmanJr1Status(Sender: TObject;
      const pStatObj: IFaxStatusObj);
    procedure FaxmanJr1Pages(Sender: TObject;
      const pStatObj: IFaxStatusObj);
    procedure FaxmanJr1Message(Sender: TObject; const bsMsg: WideString;
      bNewLine: Smallint);
  private
    fFaxListStatus     : TFaxStatus;
    fFaxDirs           : TFaxDirs;
    fCurFaxParams      : PFaxParams;  // Set-up parameters
    fFaxInProgress     : boolean;
    fCheckInProgress   : boolean;
    FrmAbout : TFrmAbout;
    bDebug, bDown, bAskClose : boolean;
    sFaxServerRoot : string;
    iComNo : integer;
    CurrentPage, TotalPages : Integer;
    FDebugLog : TextFile;
    FLogFileName : string;
    iStartTime, iEndTime : Cardinal;
    procedure AfterServerParamsRead;
    procedure SetupParameters;
    procedure ShowDebug(const s : string; NewLine : Boolean = True);
    function ConvertBanner(const sBanner: string) : string;
    function TimeOutExpired : Boolean;
end;

const
  sAppName = 'Fax Sender';
  I_TIMEOUT = 300000; //Timeout = 5 mins in millisecs

var
  frmFaxStatus: TfrmFaxStatus;
  EntEmail : TEntEmail;

implementation

uses
  UFaxBtrv, FaxParam, {ComIntND,}AdExcept, BtrvU2, {RPDevice,} PortReg, StrUtils, FileUtil;

{$R *.DFM}
{$R FOLDER.RES}  // Folder images for the TreeView

type
  TMasterSource = (msrBtrieve, msrFaxFiles);

const
  prgSendingPage = [FAXST_SEND_10..FAXST_SEND_100];
//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ShowDebug(const s : string; NewLine : Boolean = True);
begin
  if bDebug then
  begin
    if not FileExists(FLogFilename) then
      Rewrite(FDebugLog)
    else
      Append(FDebugLog);
    if NewLine then
      WriteLn(FDebugLog, FormatDateTime('HH:NN:SS', Now)+ '> ' + s)
    else
      Write(FDebugLog, FormatDateTime('HH:NN:SS', Now)+ '> ' + s);
    CloseFile(FDebugLog);
  end;
end;

procedure TfrmFaxStatus.SetUpParameters;
var
  Params : PFaxParams;
  Status : integer;
  SetupIni : TIniFile;
begin
//  with TfrmServerParams.Create(nil) do //This is auto-created so no need to create again
  with frmServerParams do
  try
    new(Params);
    Status := ReadFaxParams(Params);
    if Status in [0,4] then
    begin
      if Status = 4 then // Fax params record not found
      begin // Initialise params structure

        screen.Cursor := crHourglass;

        FillChar(Params^,SizeOf(Params^),#0);
        SetupIni := TInifile.create('..\WSTATION\SETUP.USR');

        with Params^ do begin // Provide reasonable defaults
          FaxVersion := 1;
          FaxCheckFreq := 1; // Every minute;
          FaxOffPeakStart := EncodeTime(18,0,0,0); // Default to 6:00 PM
          FaxOffPeakEnd := EncodeTime(8,0,0,0); // Default to 8:00 AM

          FaxDownTimeStart := EncodeTime(0,0,0,0); // Default to 0:00 AM
          FaxDownTimeEnd := EncodeTime(6,0,0,0); // Default to 6:00 AM

          FaxSendAction := 'D'; // Delete
          FaxDialAttempts := 3;
          FaxDialRetryWait := 60; // seconds
          FaxConnectWait := 30; // seconds

          {get defaults from the inifile created by the setup program}
          if SetupIni.ReadString('Entrprse', 'PEmail', 'B') = 'A' then FaxEmailType := 'S'; // SMTP
          if SetupIni.ReadString('Entrprse', 'PEmail', 'B') = 'B' then FaxEmailType := 'M'; // MAPI
          FaxSMTPServerName := SetupIni.ReadString('Entrprse', 'PEmailSMTP', '');
          FaxAdminEmail := SetupIni.ReadString('Entrprse', 'PEmailAddr', '');
          FaxStationID := SetupIni.ReadString('Entrprse', 'PFaxNo', 'Enterprise Faxing');

//          FaxEmailAvail := ((FaxEmailType = 'M') and MAPIAvailableND) or (FaxSMTPServerName <> '');
          FaxEmailAvail := ((FaxEmailType = 'M') and MAPIAvailable) or (FaxSMTPServerName <> '');

          FaxSenderNotify := 'F'; // Only On Failed Faxes
          FaxAdminNotify := 'N'; // Never
          FaxArchiveSize := 10;
          FaxArchiveNum := 100;
          FaxAdminAvailFrom := EncodeTime(9,0,0,0); // Default to 9:00 AM
          FaxAdminAvailTo := EncodeTime(18,0,0,0); // Default to 6:00 PM
          FaxAdminCheckFreq := 7200000; // Every 2 hours
          FaxAdminEmailDefault := FaxAdminEmail <> '';

          // $D = Today's date (MM/DD/YY)
          // $T = Current time (HH:MMpm)
          // $R = Recipient's name (HeaderRecipient property = FaxRecipientName)
          // $F = Sender's name (HeaderSender property = FaxSenderName)
          // $P = Current page number
          // $N = Total number of pages
          // $S = Title of fax (HeaderTitle property = FaxUserDesc)
          // $S = Station ID e.g. sender's fax no.
//          FaxHeaderLine := '$D $T  To: $R  From: $F  on $I  Re: $S  Page $P of $N';
          FaxHeaderLine := '%d %t|To: %r From: %s Re: %u|Page %c of %p';

          FaxSenderEmailAddress := 'FaxSender';

          FaxSubDirs[fxsNormal] := '';
          FaxSubDirs[fxsUrgent] := '';
          FaxSubDirs[fxsOffPeak] := '';
          FaxSubDirs[fxsArchive] := '';
          FaxSubDirs[fxsFail] := '';

          FaxRetryMins := 10;
          FaxNoOfRetries := 3;
        end;{with}
        screen.Cursor := crDefault;
      end;

      if ShowModal(Params) = mrOK then
        if WriteFaxParams(Params) then
        begin // Update currently active settings
          fCurFaxParams^ := Params^;
          ShowDebug('Port = ' + IntToStr(Params^.FaxPort));
        end;
    end
    else
      ShowBtrieveError('Cannot read parameters',Status);

  finally
    dispose(Params);
//    Release;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.FormCreate(Sender: TObject);

  function CheckParams : boolean;
  var
    i : integer;
  begin
    Result := false;
    for i := 1 to ParamCount do begin
      if UpperCase(ParamStr(i)) = '/CREATE' then begin
        Result := true;
        MakeFaxFile;
        Application.Terminate;
      end;{if}

      if UpperCase(ParamStr(i)) = '/LOG' then begin
{        ApdComPort1.Logging := tlOn;
        ApdTapiDevice1.TapiLog := ApdTapiLog1;
        ApdSendFax1.FaxLog := ApdFaxLog1;}
      end;{if}

      if UpperCase(ParamStr(i)) = '/DEBUG' then begin
        bDebug := TRUE;
      end;{if}
    end;{for}
  end;{CheckParams}

begin
  bDown := FALSE;
  {Resets registry entries for all com ports for this application}
  ResetComPortReg(sAppName);

  sFaxServerRoot := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));

  pbTotal.Position := 0;
  pbrCurPageProgress.Position := 0;
  lStatus.Caption := 'Idle';
  lPage.Caption := '';
  lFilename.Caption := '';
  lDocument.Caption := '';
  lDocument.Hint := '';
  lRecipient.Caption := '';
  lSender.Caption := '';

  SetBtrieveLocation;
  if CheckParams then exit;
  if bDebug then
  begin
    FLogFilename := GetEnterpriseDirectory + 'Logs\Fax.log';
    AssignFile(FDebugLog,  FLogFilename);

  end;
  if OpenFaxFile(true) then begin
    if CheckFaxServerRunning then
      begin
        MsgBox('An instance of the Fax Sender is already running.',mtInformation,[mbOk],mbOK,'Fax Sender');
        bAskClose := FALSE;
      end
    else bAskClose := TRUE;
    new(fCurFaxParams);
  end;{if}
end; // TfrmFaxStatus.FormCreate

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.AfterServerParamsRead;
// Action : Set properties of components on the form that are dependent on
//          fax set-up parameters
(*  procedure SetFaxDirectories;
  // Post : fFaxDirs is populated with the fully qualified paths of all the
  //        sub-directories that physically exist below the fax root directory
  var
    FaxSubDir : string;
    SearchRec : TSearchRec;
    i : TKnownFaxStatus;
  begin
    FillChar(fFaxDirs,SizeOf(fFaxDirs),#0);

    for i := Low(TKnownFaxStatus) to High(TKnownFaxStatus) do
    begin
      FaxSubDir := AddBackSlash(fCurFaxParams^.FaxServerRoot)+fCurFaxParams^.FaxSubDirs[i];
      if FindFirst(FaxSubDir, faDirectory, SearchRec) = 0 then
        fFaxDirs[i] := FaxSubDir;
      FindClose(SearchRec);
    end;
  end; // TfrmFaxStatus.SetFaxDirectories*)

var
  slModems : TStringList;
  iModem : integer;

begin
  LogFaxServerAsRunning(true);

  if fCurFaxParams^.FaxVersion < 1 then
  begin
    //PR: 15/07/2013 ABSEXCH-14438 Rebranding
    msgBox('Because of an internal change it will be necessary to reselect your fax modem',
            mtInformation, [mbOK], mbOK, 'Advanced Enterprise FaxSender');
    fCurFaxParams.FaxVersion := 1;
    fCurFaxParams.FaxHeaderLine := ConvertBanner(fCurFaxParams.FaxHeaderLine);
    frmServerParams.SelectModem(fCurFaxParams);
    WriteFaxParams(fCurFaxParams);
  end;

  with fCurFaxParams^ do begin
    tmrFaxSearch.Interval := FaxCheckFreq * 60000;
    tmrAdminCheck.Interval := FaxAdminCheckFreq;
//    ApdTapiDevice1.SelectedDevice := FaxDeviceName;
    SetFaxDirectories(fFaxDirs, sFaxServerRoot);
    fFaxListStatus := fxsUnknown;
    mnuTools.Enabled := TRUE;
{    Lights.Monitoring := FALSE;}
    AbortFax1.Enabled := FALSE;
    Self.Refresh;
    tmrFaxSearchTimer(Self);
    tmrAdminCheck.Enabled := true;
    mnuPauseSender.Checked := FALSE;
  end; // with

//  If (ApdTapiDevice1.ComNumber = 0) and (GetWindowsVersion in [wv95, wvNT3]) then
    if False then
    begin
      {Async Component has failed to get the comport number for the modem}

      with TRegistry.create do begin
        try
          slModems := TStringList.Create;
          Access := KEY_READ;
          RootKey := HKEY_LOCAL_MACHINE;
          if OpenKey('System\CurrentControlSet\Services\Class\Modem\', FALSE) then
            begin
              GetKeyNames(slModems);
              For iModem := 0 to slModems.Count -1 do begin
                with TRegistry.create do begin
                  try
                    Access := KEY_READ;
                    RootKey := HKEY_LOCAL_MACHINE;
                    if OpenKey('System\CurrentControlSet\Services\Class\Modem\' + slModems[iModem], FALSE) then
                      begin
                       (* if UpperCase(ReadString('DriverDesc')) = UpperCase(ApdTapiDevice1.SelectedDevice) then begin
                          iComNo := StrToInt(ReadString('AttachedTo')[4]);
                          Break;
                        end;{if} *)
                      end
                    else RegAccessError('HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Class\Modem\' + slModems[iModem], 'read',10);
                  finally
                    CloseKey;
                    Free;
                  end;{try}
                end;{with}
              end;{for}
            end
          else RegAccessError('HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\Class\Modem\', 'read',11);


        finally
          slModems.Free;
          CloseKey;
          Free;
        end;{try}
      end;{with}
    end;
//  else iComNo := ApdTapiDevice1.ComNumber;

//  if bDebug then ShowMessage('iComNo = ' + IntToStr(iComNo));

end; // TfrmFaxStatus.ServerParamsOK

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.FormDestroy(Sender: TObject);
begin
  LogFaxServerAsRunning(false);
  CloseFaxFile;
  if Assigned(fCurFaxParams) then dispose(fCurFaxParams);
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.tmrAdminCheckTimer(Sender: TObject);
  procedure CheckArchiveDirectory;
    procedure WarnAdmin(Msg : AnsiString);
    var
      lstRecipient : TStringList;
    begin
//      with fCurFaxParams^, TEntEmailND.Create do
//      with fCurFaxParams^, TEntEmail.Create do
      with fCurFaxParams^, EntEmail do
      try
        Message := PChar(Msg);
        Priority := 2;  // Send as high priority
        lstRecipient := TStringList.Create;
        lstRecipient.Add(FaxAdminEmail);
        Recipients.Assign(lstRecipient);
{       Sender := 'FaxSender';}
        Sender := FaxSenderEmailAddress;
        SenderName := 'Exchequer Fax Sender';
        SMTPServer := FaxSMTPServerName;
        UseMAPI := FaxEmailType = 'M';
        try
          Send;
        except // Trap any exceptions on sending E-mail
        end;
      finally
        lstRecipient.Free;
//        Free;
      end;
    end;{WarnAdmin}
  begin // CheckArchiveDirectory
    // If no fax server administrator set ignore routine
    if fCurFaxParams^.FaxAdminEmail = '' then exit;
    fCheckInProgress := true;
    with fCurFaxParams^ do begin
      if FaxEmailAvail and (fFaxDirs[fxsArchive] <> '') then begin
        case FaxAdminNotify of
          'S' : begin // Directory size
            if GetDirSize(fFaxDirs[fxsArchive]) / MEGA > FaxArchiveSize then
              WarnAdmin('Size of the directory ' + fFaxDirs[fxsArchive] + ' has exceeded ' +
                   IntToStr(FaxArchiveSize) + 'MB');
          end;

          'F' : begin // Number of files in directory
            if GetDirFileCount(fFaxDirs[fxsArchive]) > FaxArchiveNum then
              WarnAdmin('Number of files in directory ' + fFaxDirs[fxsArchive] + ' has exceeded ' +
                 IntToStr(FaxArchiveNum));
          end;

          'B' : begin // Both
            if GetDirSize(fFaxDirs[fxsArchive]) / MEGA > FaxArchiveSize then
              WarnAdmin('Size of the directory ' + fFaxDirs[fxsArchive] + ' has exceeded ' +
                   IntToStr(FaxArchiveSize) + 'MB');

            if GetDirFileCount(fFaxDirs[fxsArchive]) > FaxArchiveNum then
              WarnAdmin('Number of files in directory ' + fFaxDirs[fxsArchive] + ' has exceeded ' +
                 IntToStr(FaxArchiveNum));
          end;
        end;{case}
      end;{if}
    end;{with}
    fCheckInProgress := false;
  end;{CheckArchiveDirectory}
begin
  if not (fCheckInProgress or fFaxInProgress) then
    with fCurFaxParams^ do
      if InTimePeriod(FaxAdminAvailFrom, FaxAdminAvailTo) then
        CheckArchiveDirectory;
end;{tmrAdminCheckTimer}

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.tmrFaxSearchTimer(Sender: TObject);


  function ParseFaxDirectories : boolean;
  var
    CurFaxStatus : TFaxPriority;
    CurFaxDetails : PFaxDetails;
    SearchRec : TSearchRec;
    APFName : string;
    bDetails, bRetry, bFound : boolean;
    iTotalMins, iLastFind : integer;
    wHours,wMins,wSecs,wMSecs : Word;

    function FaxCancelled(APFName : string) : boolean;
    // Pre    : APFNAme = name of APF file to check for
    // Action : If the cancel flag is set the record is deleted
    // Post   : Returns true if cancel flag was set
    var
      Details : PFaxDetails;
      LockPos : longint;
    begin
      new(Details);
      if FindAndLockFaxDetails(APFName,'A', Details, LockPos) then
        begin
          Result := Details^.FaxCancel;
          if Result then
            begin
              DeleteFaxDetails('A');
              DeleteFile(APFName);
            end
          else UnlockFaxDetails(LockPos);
        end
      else begin
        Result := DeleteFile(APFName);
      end;{if}
      dispose(Details);
    end;{FaxCancelled}
  begin{ParseFaxDirectories}
    Result := FALSE;
    lStatus.Caption := 'Checking...';
    APFName := '';

    for CurFaxStatus := System.Low(TFaxPriority) to System.High(TFaxPriority) do begin
      if (fFaxDirs[CurFaxStatus] <> '') and (APFName = '')
      and ((CurFaxStatus in [fxsUrgent,fxsNormal])
      or ((CurFaxStatus = fxsOffPeak)
      and InTimePeriod(fCurFaxParams^.FaxOffPeakStart, fCurFaxParams^.FaxOffPeakEnd)))
      then begin
        ShowDebug('Checking folder ' + fFaxDirs[CurFaxStatus]);
        if FindFirst(AddBackSlash(fFaxDirs[CurFaxStatus]) + '*' + APF_EXT
        , faAnyFile, SearchRec) = 0 then begin
          iLastFind := 0;
          ShowDebug('Found ' + SearchRec.Name);
          bFound := FALSE;
          While (not bFound) do begin
            bFound := TRUE;
            new(CurFaxDetails);
            bRetry := FALSE;
            bDetails := FindFaxDetails(SearchRec.Name, 'A', CurFaxDetails);
            if bDetails then begin
              ShowDebug('Found fax details');
              // Figures out what the retry time of a fax will be
              DecodeTime(CurFaxDetails^.FaxFinishTime,wHours,wMins,wSecs,wMSecs);
              iTotalMins := wMins + fCurFaxParams.FaxRetryMins;
              if iTotalMins > 59 then
                begin
                  wHours := wHours + iTotalMins DIV 60;
                  if wHours > 23 then wHours := wHours - 24;
                  wMins := iTotalMins MOD 60;
                end
              else wMins := iTotalMins;

              if Now > (Trunc(CurFaxDetails^.FaxFinishTime) + EncodeTime(wHours,wMins,wSecs,wMSecs)) then bRetry := TRUE;
              ShowDebug(Format('Retry time = %d:%d:%d', [wHours, wMins, wSecs]));
            end;{if}

            if FaxCancelled(AddBackSlash(fFaxDirs[CurFaxStatus]) + SearchRec.Name) or (not bDetails)
            or CurFaxDetails^.FaxHold or ((CurFaxDetails^.FaxBusyRetries > 0) and (not bRetry))
            then begin
              iLastFind := FindNext(SearchRec);
              bFound := iLastFind <> 0;
            end;{if}
            dispose(CurFaxDetails);
          end;{while}

          if iLastFind = 0 then APFName := AddBackSlash(fFaxDirs[CurFaxStatus]) + SearchRec.Name
          else APFName := '';
        end;{if}
        FindClose(SearchRec);
      end;{if}
    end;{for}

    {Send Fax}
    new(CurFaxDetails);
    ShowDebug('APFName = ' + APFName);
//    if bDebug then ShowMessage('ApdTapiDevice1.comnumber = ' + IntToStr(ApdTapiDevice1.comnumber));

    if (APFName <> '') and FindFaxDetails(SearchRec.Name, 'A', CurFaxDetails)
    and (not ComPortInUseReg(iComNo)) then begin

      {sets the registry entry, flagging that the com port is in use}
      SetComPortReg(sAppName, iComNo, TRUE);

      try
        lDocument.Caption := CurFaxDetails^.FaxUserDesc;
        lDocument.Hint := CurFaxDetails^.FaxUserDesc;
        lRecipient.Caption := CurFaxDetails^.FaxRecipientName;
        lSender.Caption := CurFaxDetails^.FaxSenderName;
        lStatus.Caption := 'Preparing Fax';
        mnuTools.Enabled := FALSE;
        AbortFax1.Enabled := TRUE;
  {      Lights.Monitoring := TRUE;}
        Refresh;

        Result := TRUE;
       with CurFaxDetails^, fCurFaxParams^ do begin
          // Hide the selected APF file
          FileSetAttr(APFName,FileGetAttr(APFNAme) or faHidden);

          FaxManJr1.DeviceInit := FaxModemInit;
          FaxManJr1.FaxBanner := FaxHeaderLine;
          FaxManJr1.FaxName := FaxRecipientName;
          FaxManJr1.FaxNumber := FaxNumber;
          FaxManJr1.LocalID := FaxStationID;
          if iFaxClass > 0 then
            FaxManJr1.Class_ := iFaxClass;
          FaxManJr1.FaxNumber := FaxExtLine + FaxNumber;
          ShowDebug('Fax file name: ' + APFname);
          FaxManJr1.FaxFiles := APFName;
          FaxManJr1.Port := FaxPort;
          FaxManJr1.UserName := FaxSenderName;
          FaxManJr1.FaxSubject := FaxUserDesc;

          TotalPages := 1; //This will be set to the correct value in the FaxManJr Pages Event
          CurrentPage := 1;
          fFaxInProgress := true;
          ShowDebug('About to send fax to ' + FaxManJr1.FaxNumber);
          iStartTime := GetTickCount;
          FaxManJr1.SendFax;
{           HeaderLine := FaxHeaderLine;
          HeaderRecipient := FaxRecipientName;
          HeaderSender := FaxSenderName;
          HeaderTitle := FaxUserDesc;
          StationID := FaxStationID;

          DialPrefix := FaxExtLine;
  {        DialPrefix := '';}

 (*         DialAttempts := FaxDialAttempts;
          DialRetryWait := FaxDialRetryWait;
          DialWait := FaxConnectWait;
          FaxFile := APFName;

          PhoneNumber := FaxNumber;
  {        PhoneNumber := FaxExtLine + FaxNumber;}

          fFaxInProgress := true;
          //ApdTapiDevice1.ConfigAndOpen; *)
        end;{with}
      finally
      end;{try}
    end;{if}
    dispose(CurFaxDetails);
    lStatus.Caption := 'Idle';
  end;{ParseFaxDirectories}
begin{tmrFaxSearchTimer}
  tmrFaxSearch.Enabled := FALSE;
  ShowDebug('Timer disabled');
  LogFaxServerAsRunning(true);
  if not (fFaxInProgress or fCheckInProgress) then begin
    if InTimePeriod(fCurFaxParams^.FaxDownTimeStart, fCurFaxParams^.FaxDownTimeEnd) then
      begin
        if not bDown then begin
          CloseFaxFile;
          bDown := TRUE;
          lStatus.Caption := 'Down';
{          mnuTools.Enabled := FALSE;}
          mnuPauseSender.Enabled := FALSE;
          DialNow1.Enabled := FALSE;
        end;{if}
      end
    else begin
      if bDown then begin
        OpenFaxFile(true);
        bDown := FALSE;
        lStatus.Caption := 'Idle';
{        mnuTools.Enabled := TRUE;}
        mnuPauseSender.Enabled := TRUE;
        DialNow1.Enabled := TRUE;
      end;{if}
    end;

    if bDown then
    begin
      tmrFaxSearch.Interval := fCurFaxParams^.FaxCheckFreq * 60000;
      tmrFaxSearch.Enabled := TRUE;
      ShowDebug('Timer enabled');
    end
    else begin
      if not ParseFaxDirectories then
      begin
        tmrFaxSearch.Interval := fCurFaxParams^.FaxCheckFreq * 60000;
        tmrFaxSearch.Enabled := TRUE; {Reset Timer}
        ShowDebug('Timer enabled');
      end;

    end;{if}
  end;{if}
end;{tmrFaxSearchTimer}

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ApdTapiDevice1TapiPortOpen(Sender: TObject);
begin
//  ApdSendFax1.StartTransmit;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ApdSendFax1FaxFinish(CP: TObject; ErrorCode: Integer);
const
  LINE_BUSY = -8064;
var
  LockPos : longint;
  APFName : string;
  CurFaxDetails : PFaxDetails;


  procedure NotifySender(CurFaxDetails : PFaxDetails);
  var
    SendTo : string;
    lstRecipient : TStringList;
    sMessage, LocalMessage : AnsiString; // Must be a long string
    iPos : integer;
  begin
    lStatus.Caption := 'Sending E-mail';
    with fCurFaxParams^ do
      if FaxEmailAvail then
//        with TEntEmailND.Create, CurFaxDetails^ do
//        with TEntEmail.Create, CurFaxDetails^ do
        with EntEmail, CurFaxDetails^ do
        try
          LocalMessage := 'Fax Information :' + CRLF + CRLF
          + TAB + 'Title:' + TAB + FaxUserDesc + CRLF
          + TAB + 'Fax No:' + TAB + FaxNumber + CRLF
          + TAB + 'From:' + TAB + FaxSenderName + CRLF
          + TAB + 'Login:' + TAB + FaxUserName + CRLF
          + TAB + 'To:' + TAB + FaxRecipientName + CRLF
          + TAB + 'Time:' + TAB + TimeToStr(FaxFinishTime) + CRLF;

          if FaxErrorCode = 0 then
            begin
              // Fax Sent OK
              Subject := 'Fax : ' + FaxUserDesc + ' - was sent OK';
              LocalMessage := LocalMessage + TAB + 'Status:' + TAB + 'OK';
              SendTo := FaxSenderEmail;
            end
          else begin
            // Error occurred
            Subject := 'Fax : ' + FaxUserDesc + ' - failed to send';
            LocalMessage := LocalMessage + TAB + 'Status:' +  TAB + ErrorMsg(FaxErrorCode) + ' (' + IntToStr(FaxErrorCode) + ')';
            if (FaxSenderEmail = '') and FaxAdminEmailDefault
            then SendTo := FaxAdminEmail
            else SendTo := FaxSenderEmail;
          end;{if}

          Message := PChar(LocalMessage);
          Priority := 1;  // Send as normal priority
          lstRecipient := TStringList.Create;
          lstRecipient.Add(SendTo);
          Recipients.Assign(lstRecipient);
          SenderName := 'Exchequer Fax Sender';
{          Sender := 'FaxServer';}
          Sender := FaxSenderEmailAddress;
          SMTPServer := FaxSMTPServerName;
          UseMAPI := FaxEmailType = 'M';
          try
            // A blank Email recipient (fax sender / admin) results in an
            // exception - need to avoid.
            if Trim(SendTo) <> '' then

              {create debug message for email}
              sMessage := 'Attachments : ';
              For iPos := 0 to Attachments.Count - 1 do sMessage := sMessage + Attachments[iPos] + ', ';
              sMessage := sMessage + #13;
              sMessage := sMessage + 'BCC : ';
              For iPos := 0 to BCC.Count - 1 do sMessage := sMessage + BCC[iPos] + ', ';
              sMessage := sMessage + #13;
              sMessage := sMessage + 'CC : ';
              For iPos := 0 to CC.Count - 1 do sMessage := sMessage + CC[iPos] + ', ';
              sMessage := sMessage + #13;;
              sMessage := sMessage + 'Headers : ';
              For iPos := 0 to Headers.Count - 1 do sMessage := sMessage + Headers[iPos] + ', ';
              sMessage := sMessage + #13;
              sMessage := sMessage + 'Message : ' + Message + #13;
              sMessage := sMessage + 'Priority : ' + IntToStr(Priority) + #13;
              sMessage := sMessage + 'Recipients : ';
              For iPos := 0 to Recipients.Count - 1 do sMessage := sMessage + Recipients[iPos] + ', ';
              sMessage := sMessage + #13;
              sMessage := sMessage + 'Sender : ' + Sender + #13;
              sMessage := sMessage + 'SenderName : ' + SenderName + #13;
              sMessage := sMessage + 'SMTPServer : ' + SMTPServer + #13;
              sMessage := sMessage + 'Subject : ' + Subject + #13;
              if UseMAPI then sMessage := sMessage + 'UseMAPI = TRUE'
              else sMessage := sMessage + 'UseMAPI = FALSE';

{              showmessage(sMessage);
              showmessage('Send Result = ' + IntToStr(Send));}

              Send;
          except // Trap any propagated exceptions on sending E-mail
          end;
        finally
          lstRecipient.Free;
//          Free;
        end;
    pbTotal.Position := 0;
    pbrCurPageProgress.Position := 0;
    lStatus.Caption := 'Idle';
    lDocument.Caption := '';
    lDocument.Hint := '';
    lRecipient.Caption := '';
    lSender.Caption := '';
    lFilename.Caption := '';
  end;{NotifySender}

begin
  {sets the registry entry, flagging that the com port is no longer in use}
  SetComPortReg(sAppName, iComNo, FALSE);

//  APFName := ApdSendFax1.FaxFile;
  APFName :=  FaxManJr1.FaxFiles;
  new(CurFaxDetails);

  if FindAndLockFaxDetails(APFName, 'A', CurFaxDetails, LockPos) then begin
    with CurFaxDetails^ do begin
      FaxErrorCode := ErrorCode;
      FaxFinishTime := Now;
      if ErrorCode = FAXERR_OK then
        begin
          ShowDebug('Fax OK');
          if fCurFaxParams^.FaxSendAction = 'D' then
            begin // On successful send ... Delete
               DeleteFile(APFName);
               DeleteFaxDetails('A');
            end
          else begin // On successful send ... Archive
            FaxBusyRetries := 0;
            UpdateFaxDetails('A', CurFaxDetails, LockPos);
            FileSetAttr(APFName,FileGetAttr(APFNAme) and not faHidden);
            if (fFaxDirs[fxsArchive] <> '') then RenameFile(APFName
            , AddBackSlash(fFaxDirs[fxsArchive])+ExtractFileName(APFName));
          end;{if}
          if fCurFaxParams^.FaxSenderNotify = 'A' then NotifySender(CurFaxDetails);
        end // Sent OK
      else begin // Failed
        if ErrorCode = FAXERR_BUSY then
          begin
            ShowDebug('Line Busy');
            {Line Busy : Re-queue for later}
            if FaxBusyRetries = 0 then FaxBusyRetries  :=  fCurFaxParams^.FaxNoOfRetries
            else FaxBusyRetries := FaxBusyRetries - 1;
            UpdateFaxDetails('A', CurFaxDetails, LockPos);
            FileSetAttr(APFName,FileGetAttr(APFNAme) and not faHidden);

            {Failed}
            if FaxBusyRetries = 0 then begin
              if (fFaxDirs[fxsFail] <> '') then RenameFile(APFName
              , AddBackSlash(fFaxDirs[fxsFail])+ExtractFileName(APFName));
            end;{if}
          end
        else begin
          {Failed}
          ShowDebug('Failed');
          UpdateFaxDetails('A', CurFaxDetails, LockPos);
          FileSetAttr(APFName,FileGetAttr(APFNAme) and not faHidden);
          if (fFaxDirs[fxsFail] <> '') then RenameFile(APFName
          , AddBackSlash(fFaxDirs[fxsFail])+ExtractFileName(APFName));
        end;{if}
        if fCurFaxParams^.FaxSenderNotify <> 'N' then NotifySender(CurFaxDetails);
      end;{if}
    end;{with}
  end;{if}



  fFaxInProgress := false;
  mnuTools.Enabled := TRUE;
{  Lights.Monitoring := FALSE;}
  AbortFax1.Enabled := FALSE;
  if bAskClose then
  begin
    tmrFaxSearch.Interval := 1000;
    tmrFaxSearch.Enabled := TRUE;
    ShowDebug('Timer enabled');
//     tmrFaxSearchTimer(Self)
  end
  else
    Close;
end; // TfrmFaxStatus.ApdSendFax1FaxLog

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ApdTapiDevice1TapiPortClose(Sender: TObject);
begin
//  fFaxInProgress := false;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.ApdSendFax1FaxStatus(const pStatObj: IFaxStatusObj);
var
  Msg : string;
  PageProgressPercent : single;
  iProgress : integer;
  ShowPageProgress : boolean;
begin
(*  with ApdSendFax1 do *)
  begin
    Msg := IntToStr(pStatObj.CurrentStatus);
    ShowPageProgress := true;
    if not (pStatObj.CurrentStatus in prgSendingPage) then
      PageProgressPercent := 0;
    case pStatObj.CurrentStatus of
      FAXST_INIT :
        Msg := 'Initialising modem';
      FAXST_SEND_INIT :
        Msg := 'Initialising modem for Sending';
      FAXST_SEND_DIALING :
        Msg := 'Dialing ' + FaxManJr1.FaxNumber;
      FAXST_SEND_WAIT_CONNECT :
        Msg := 'Waiting for connection';
      FAXST_SEND_WAIT_FCON :
        Msg := 'Connection established';
      FAXST_SEND_FCON :
        Msg := 'Connected to remote machine';
      FAXST_SEND_FCSI,
      FAXST_SEND_FDCS :
        Msg := 'Negotiating';
      FAXST_SENDING :
        Msg := 'Preparing to send page';
{      fpBusyWait :
        Msg := PhoneNumber + ' is busy';}
      FAXST_PAGE_END :
        begin
          Msg := 'Current page transmitted';
          Inc(CurrentPage);
        end;
{      fpPageError :
        Msg := 'Page data not received OK';
      fpPageOK :
        Msg := 'Page sent OK';}
      FAXST_ABORT :
        begin
          ShowPageProgress := false;
          Msg := 'Cancelled';
        end;
      FAXST_COMPLETE :
        begin
          Msg := 'Process completed';
          pbTotal.Position := 0;
          pbrCurPageProgress.Position := 0;
          PageProgressPercent := 0;
        end;
      FAXST_SEND_10..FAXST_SEND_100 :
      begin
        try
          PageProgressPercent := (pStatObj.CurrentStatus - Pred(FAXST_SEND_10)) * 10;
        except
          PageProgressPercent := 0.0;
        end;
        lPage.Caption := IntToStr(CurrentPage) + ' of ' + IntToStr(TotalPages);
        Msg := 'Sending page';
      end;
      FAXST_PORTSHUT :
        begin
          Msg := 'Idle';
          ShowPageProgress := False;
        end;
    end; // case

    if PageProgressPercent > 0 then
      iProgress := Trunc(PageProgressPercent)
    else
      iProgress := 0;
    if iProgress > 0 then begin
      pbTotal.Max := TotalPages * 100;
      pbTotal.Position := ((CurrentPage - 1) * 100) + iProgress;
      pbrCurPageProgress.Position := iProgress;
    end;{if}

    lStatus.Caption := Msg;
    ShowDebug(Msg);
    if not ShowPageProgress then
      begin
        lFilename.Caption := '';
        lDocument.Caption := '';
        lDocument.Hint := '';
        lRecipient.Caption := '';
        lSender.Caption := '';
        lPage.Caption := '';
      end
    else begin
      lFilename.Caption := ExtractFileName(FaxManJr1.FaxFiles);
    end;{if}
  end; // with
end; // TfrmFaxStatus.ApdSendFax1FaxStatus

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.FormActivate(Sender: TObject);
var
  Status : integer;
begin
  if not bAskClose then Close
  else begin
    Status := ReadFaxParams(fCurFaxParams);
    case Status of
      0 : AfterServerParamsRead; // Parameters read OK
      4 : begin // Parameters record missing
        MessageDlg('The fax sender parameters are missing and need to be initialised.'
        , mtInformation, [mbOK], 0);
        SetupParameters;
        AfterServerParamsRead; //PR 19/08/2008 - this was missing, so the first time the sender was run it didn't register itself
                               //                as running.
      end;
    else
      ShowBtrieveError('An error occurred in reading the fax sender parameters',Status);
    end;
  end;{if}
{  CloseFaxFile;
  OpenFaxFile(true);}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuExitClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if bAskClose then begin
    if fFaxInProgress then
      begin
        if MsgBox('A fax is currently being sent.' + CHR(13) + 'Closing the Fax Sender will cancel the sending of the current fax.'
        + CHR(13) + CHR(13) + 'Are you sure you want to do this ?',mtConfirmation,[mbYes, mbNo],mbNo
        ,'Fax Sender') = mrYes then
          begin
            screen.cursor := crHourglass;
//            ApdSendFax1.CancelFax;
            CanClose := TRUE;
            bAskClose := FALSE;
          end
        else CanClose := FALSE;
      end
    else begin
      // Should only be enabled if parameters read in OK
      if mnuTools.Enabled and (not bDown) then begin
        CanClose := MsgBox('Shutting down the sender will stop faxes being sent.' + CRLF + CRLF +
       'Are you sure you want to do this ?', mtWarning,[mbYes, mbNo], mbNo,'Close Fax Sender') = mrYes;
      end;{if}
    end;{if}
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuPauseSenderClick(Sender: TObject);
begin
  mnuPauseSender.Checked := not mnuPauseSender.Checked;
  tmrFaxSearch.Enabled := not mnuPauseSender.Checked;

  if mnuPauseSender.Checked then
    begin
      lStatus.Caption := 'Paused.';
      mnuPauseSender.Caption := 'Unpause Fax Sending';
    end
  else begin
    tmrFaxSearchTimer(Self);
    mnuPauseSender.Caption := 'Pause Fax Sending';
  end;{if}
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuServerParametersClick(Sender: TObject);
var
  Params : PFaxParams;
  iStatus : integer;
begin
  tmrFaxSearch.Enabled := FALSE;
  frmPassword := TfrmPassword.Create(Application);
  try
    with frmPassword do begin
      lPlease.Caption := 'Please enter the system password to gain access to the Sender Options';
      lPlease.Height := 49;
      lPlease.Width := 177;
      if ShowModal = mrOK then begin
        try
          new(Params);
          iStatus := ReadFaxParams(Params);
          with Params^ do begin
            if ((iStatus = 0) and (UpperCase(edPassword.Text) = Decode(FaxSystemPass)))
            or (iStatus = 4) or (Get_TodaySecurity = UpperCase(edPassword.Text))
            then SetUpParameters
            else MsgBox('The password you have supplied is incorrect.'
            ,mtInformation,[mbOK],mbOK,'Incorrect Password');
          end;{with}
        finally
          dispose(Params);
        end;{try}
      end;{if}
    end;{with}
  finally
    frmPassword.Release;
  end;{try}

  if not mnuPauseSender.Checked then tmrFaxSearchTimer(Self);
end;

//-----------------------------------------------------------------------

procedure TfrmFaxStatus.mnuSystemClearDownClick(Sender: TObject);
var
  Master : TMasterSource;

  procedure Process;
  var
    ProcessDetails : boolean;
    Details        : PFaxDetails;
    BtrieveRecList : TStringListPartialMatch;
    APFFileList    : TStringList;
    CurFaxStatus   : TKnownFaxStatus;
    SearchRec      : TSearchRec;
    AFileFound     : boolean;
    PosInList,
    Index          : integer;
    LockPos        : longint;
    APFName        : string;
  begin
    fCheckInProgress := true;
    // Create string list containing all APF file names from the Btrieve file
    new(Details);
    BtrieveRecList := TStringListPartialMatch.Create;
    with BtrieveRecList do
    begin
      ProcessDetails := FindFirstFaxDetails(Details);
      while ProcessDetails do
      begin
        Add(UpperCase(Details^.FaxAPFName));
        ProcessDetails := FindNextFaxDetails(Details);
     end;
     if Master = msrBtrieve then
       Sort;
    end;

    // Create string list containing all the actual physical APF files
    APFFileList := TStringList.Create;
    with APFFileList do
    begin
      for CurFaxStatus := System.Low(TKnownFaxStatus) to System.High(TKnownFaxStatus) do
        if fFaxDirs[CurFaxStatus] <> '' then
        begin
          AFileFound := FindFirst(AddBackSlash(fFaxDirs[CurFaxStatus])+ '*' + APF_EXT,
            faAnyFile, SearchRec) = 0;
          while AFileFound do
          begin
            if Master = msrBtrieve then
              Add(UpperCase(SearchRec.Name+(AddBackSlash(fFaxDirs[CurFaxStatus]))))
            else
              Add(UpperCase(SearchRec.Name));
            AFileFound := FindNext(SearchRec) = 0;
          end;
          FindClose(SearchRec);
        end;
      if Master = msrFaxFiles then
        Sort;
    end;

    if Master = msrFaxFiles then
    begin
      for PosInList := 0 to BtrieveRecList.Count -1 do
        if not APFFileList.Find(BtrieveRecList.Strings[PosInList],Index) then
          if FindAndLockFaxDetails(BtrieveRecList.Strings[PosInList], 'A', Details, LockPos) then
            DeleteFaxDetails('A');
    end
    else
      for PosInList := 0 to APFFileList.Count -1 do
        if not BtrieveRecList.FindPartial(APFFileList.Strings[PosInList],12,Index) then
        begin
          APFName := APFFileList.Strings[PosInList];
          DeleteFile(copy(APFName,13,length(APFName)-12)+copy(APFName,1,12));
        end;

    dispose(Details);
    BtrieveRecList.Free;
    APFFileList.Free;
    fCheckInProgress := false;
  end;{Process}
begin
  tmrFaxSearch.Enabled := FALSE;
  if MessageDlg('This process consolidates the Btrieve data file and their associated fax files.'
  + #13#13 + 'Do you wish to continue ?', mtInformation, [mbYes, mbNo] , 0) = mrYes
  then begin
    Screen.Cursor := crHourglass;
    for Master := System.Low(TMasterSource) to System.High(TMasterSource) do Process;
    Screen.Cursor := crDefault;
    MsgBox('System Tidy-Up Finished.',mtInformation,[mbOK],mbOK,'Tidy-Up');
  end;{if}
  if not mnuPauseSender.Checked then tmrFaxSearchTimer(Self);
end;{mnuSystemClearDownClick}

procedure TfrmFaxStatus.About1Click(Sender: TObject);
begin
  FrmAbout := TFrmAbout.Create(Self);
  FrmAbout.ShowModal;
  frmAbout.Free;
end;

procedure TfrmFaxStatus.DialNow1Click(Sender: TObject);
begin
  tmrFaxSearchTimer(Self);
end;

procedure TfrmFaxStatus.AbortFax1Click(Sender: TObject);
begin
  if MsgBox('Are you sure you want to abort the sending of the current fax ?',mtconfirmation
  ,[mbYes, mbNo],mbNo,'Abort Fax') = mrYes then  {ApdSendFax1.CancelFax};
    FaxManJr1.CancelFax;
end;

procedure TfrmFaxStatus.Contents1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_Finder,0);
end;

procedure TfrmFaxStatus.SearchforHelpon1Click(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TfrmFaxStatus.HowtouseHelp1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TfrmFaxStatus.HowTo1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1000);
end;

procedure TfrmFaxStatus.Troubleshooting1Click(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT,1001);
end;

procedure TfrmFaxStatus.Button1Click(Sender: TObject);
begin
(*  with TEntEmailND.Create do begin
    Message := 'Message';
    Priority := 2;  // Send as high priority
    Recipients.Add('nfrewer@exchequer.com');
    Sender := 'FaxSender';
    SenderName := 'Exchequer Fax Sender';
    SMTPServer := 'ntbox';
    UseMAPI := TRUE;
    Send;
    Free;
  end;*)
end;

procedure TfrmFaxStatus.FaxmanJr1CompletionStatus(Sender: TObject;
  const pStatObj: IFaxStatusObj);
begin
//Sending completed - check status
  ShowDebug('Completed. Error Status: ' + IntToStr(pStatObj.ErrorCode));
  ApdSendFax1FaxFinish(Self, pStatObj.ErrorCode);
end;

procedure TfrmFaxStatus.FaxmanJr1Status(Sender: TObject;
  const pStatObj: IFaxStatusObj);
begin
//Status of faxing
  ApdSendFax1FaxStatus(pStatObj);
end;

procedure TfrmFaxStatus.FaxmanJr1Pages(Sender: TObject;
  const pStatObj: IFaxStatusObj);
begin
  TotalPages := pStatObj.Pages;
end;

function TfrmFaxStatus.ConvertBanner(const sBanner: string) : string;
const
   AsyncCodes : Array[1..8] of String[2] = ('$D', '$T', '$I', '$N', '$P','$R','$F','$S');
  FaxManCodes : Array[1..8] of String[2] = ('%d', '%t', '%i', '%p', '%c','%r','%s','%u');
var
  i : Integer;
begin
  Result := sBanner;
  for i := 1 to 8 do
    Result := AnsiReplaceStr(Result, ASyncCodes[i], FaxManCodes[i]);
end;


procedure TfrmFaxStatus.FaxmanJr1Message(Sender: TObject;
  const bsMsg: WideString; bNewLine: Smallint);
begin
  if bDebug then
    ShowDebug(bsMsg, bNewLine <> 0);
end;

function TfrmFaxStatus.TimeOutExpired: Boolean;
begin
  SleepEx(1000, True);
  iEndTime := GetTickCount;
  if iEndTime < iStartTime then //clock rolled over back to zero
    iEndTime := iStartTime;
  Result := (iEndTime > iStartTime + I_TIMEOUT);
end;

initialization

{$IFNDEF VER130}
{  ShowMessage('Error : This must be compiled under Delphi 5, and needs to use Async v3.05');
  Halt;}
{$ENDIF}

  ChangeCryptoKey(19672);
  EntEmail := TEntEmail.Create;
finalization
  EntEmail.Free;

end.
