unit FaxParam;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BorBtns, TEditVal, StdCtrls, Mask, ExtCtrls, SBSPanel, VarConst, ComCtrls,
  OoMisc, AdTapi, Crypto, {ComIntND,}CommsInt, AdPort, ModTest, OleCtrls,
  FaxmanJr_TLB;

type
  TModemClassInfo = Class
    iClass : Byte;
  end;

  TfrmServerParams = class(TForm)
    pnlClient: TSBSPanel;
    btnOK: TButton;
    btnCancel: TButton;
    pnlLeft: TSBSPanel;
    pgcParams: TPageControl;
    tabGeneralSettings: TTabSheet;
    tabEmailSettings: TTabSheet;
    grpOffPeak: TSBSGroup;
    Label814: Label8;
    Label815: Label8;
    edtOffPeakStart: TMaskEdit;
    edtOffPeakEnd: TMaskEdit;
    grpOnSend: TSBSGroup;
    grpDialling: TSBSGroup;
    Label816: Label8;
    Label817: Label8;
    edtDialAttempts: Text8Pt;
    edtRedialWait: Text8Pt;
    Label813: Label8;
    edtHeaderLine: Text8Pt;
    edtFaxCheckFreq: Text8Pt;
    pnlTabEmailClient: TSBSPanel;
    grpNotifyAdmin: TSBSGroup;
    Label818: Label8;
    edtAdminEmail: Text8Pt;
    grpNotifySender: TSBSGroup;
    grpEmailType: TSBSGroup;
    Label820: Label8;
    edtSMTPServer: Text8Pt;
    Label81: Label8;
    Label82: Label8;
    pnlTabEmailTop: TSBSPanel;
    chkEmailAvail: TCheckBox;
    Label85: Label8;
    edtAdminFreq: Text8Pt;
    Label86: Label8;
    chkDefaultToAdminEmail: TCheckBox;
    edtStationID: Text8Pt;
    Label87: Label8;
    Label88: Label8;
    edtConnectionWait: Text8Pt;
    Bevel1: TBevel;
    Label1: TLabel;
    Label821: Label8;
    edtAdminAvailEnd: TMaskEdit;
    Label84: Label8;
    edtAdminAvailStart: TMaskEdit;
    Label811: Label8;
    edtExtLine: Text8Pt;
    Bevel4: TBevel;
    Label3: TLabel;
    edtArchiveSize: TMaskEdit;
    Label819: Label8;
    edtArchiveNo: TMaskEdit;
    Label89: Label8;
    Bevel3: TBevel;
    TabSheet1: TTabSheet;
    Bevel8: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Bevel9: TBevel;
    btnSelectDevice: TButton;
    Label6: TLabel;
    Label7: TLabel;
    edAdminPass: Text8Pt;
    edSystemPass: Text8Pt;
    Label83: Label8;
    Label822: Label8;
    edRetryMins: TEditValue;
    lModem: TLabel;
    edNoOfRetries: TEditValue;
    Label823: Label8;
    cbSizeArchived: TCheckBox;
    cbNoOfArchived: TCheckBox;
    Label8: TLabel;
    Bevel10: TBevel;
    Label9: TLabel;
    Label824: Label8;
    edDownStart: TMaskEdit;
    Label825: Label8;
    edDownEnd: TMaskEdit;
    Label10: TLabel;
    edModemInit: TEdit;
    Bevel2: TBevel;
    radMAPI: TRadioButton;
    radSMTP: TRadioButton;
    radNotifyAll: TRadioButton;
    radNotifyFail: TRadioButton;
    radNotifyNone: TRadioButton;
    radSendArchive: TRadioButton;
    radSendDelete: TRadioButton;
    btnModemTest: TButton;
    edSenderEmail: TEdit;
    Label2: TLabel;
    FaxFinder1: TFaxFinder;
    procedure chkEmailAvailClick(Sender: TObject);
    procedure radNotifyAdminClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure CheckTimeExit(Sender: TObject);
    procedure radEmailTypeClick(Sender: TObject);
    procedure btnSubDirectoriesClick(Sender: TObject);
    procedure btnSelectDeviceClick(Sender: TObject);
    procedure NumericEditExitCheck(Sender: TObject);
    procedure chkDefaultToAdminEmailClick(Sender: TObject);
    procedure cbSizeArchivedClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnModemTestClick(Sender: TObject);
  private
    fFaxParams : PFaxParams; // pointer
    sFaxServerRoot : string;
    procedure PopulateParamsRec;
    procedure CheckForSubdirectories;
    procedure ValidateIntegers(edtInteger : Text8Pt; Msg : string; Min, Max : integer);
  public
    function ShowModal(Params : PFaxParams) : integer; reintroduce;
    procedure SelectModem(Params : PFaxParams);
  end;

var
  frmServerParams: TfrmServerParams;

implementation

uses
  FileCtrl, FaxUtils, ModemSelect, ApiUtil;

{$R *.DFM}

procedure TfrmServerParams.SelectModem(Params : PFaxParams);
var
  iPort : Byte;
  i : Integer;
  ModemClassInfo : TModemClassInfo;

  function GetPortNo(const s : string) : Byte;
  var
    j : Integer;
  begin
    j := Length(s);
    while (j > 0) and (s[j] in ['0'..'9']) do
      dec(j);
    Try
      Result := StrToInt(Copy(s, j + 1, Length(s)));
    Except
      Result := 0;
    end;
  end;
begin
  msgBox('It will take a few moments to detect the modems attached to your system', mtInformation,
          [mbOK], mbOK, 'Change Modem');
  Screen.Cursor := crHourglass;
{  with ApdTapiDevice1 do
  begin
    SelectDevice;
    fFaxParams^.FaxDeviceName := SelectedDevice;
  end;}

  with TfrmModemSelect.Create(Application) do
  Try
    FaxFinder1.AutoDetect;
    for i := 0 to FaxFinder1.DeviceCount - 1 do
    begin
      ModemClassInfo := TModemClassInfo.Create;
      //PR 4/02/2008 Change to default class to 1
      if FaxFinder1.Item[i].bClass1 <> 0 then
        ModemClassInfo.iClass := FAX_1
      else
      if FaxFinder1.Item[i].bClass2 <> 0 then
        ModemClassInfo.iClass := FAX_2
      else
      if FaxFinder1.Item[i].bClass20 <> 0 then
        ModemClassInfo.iClass := FAX_20
      else
      if FaxFinder1.Item[i].bClass21 <> 0 then
        ModemClassInfo.iClass := FAX_21
      else
        raise Exception.Create('Unable to identify Fax Class');

      cbPorts.Items.AddObject('Class ' + IntToStr( ModemClassInfo.iClass) + ' Fax/Modem on port ' + IntToStr(FaxFinder1.Item[i].Port), ModemClassInfo);
    end;
    if cbPorts.Items.Count > 0 then
    begin
      cbPorts.ItemIndex := 0;
      ShowModal;
      if ModalResult = mrOK then
      begin
        if cbPorts.ItemIndex >= 0 then
        begin
          Params^.FaxPort := GetPortNo(cbPorts.Items[cbPorts.ItemIndex]);
          Params^.iFaxClass := TModemClassInfo(cbPorts.Items.Objects[cbPorts.ItemIndex]).iClass;
          Params^.FaxDeviceName := cbPorts.Items[cbPorts.ItemIndex];
        end;
      end;
    end
    else
      msgBox('No modems found.', mtError, [mbOK], mbOK, 'Select Modem');
  Finally
    Free;
  End;

  Screen.Cursor := crDefault;
end;

function LocalEncodeTime(TimeStr : string) : TDateTime;
// Pre : Assumes TimeStr in format hhmm
begin
  Result := EncodeTime(StrToInt(copy(TimeStr,1,2)),StrToInt(copy(TimeStr,3,2)),0,0);
end;

function FaxNameString(const s : string) : string;
begin
  if Trim(s) <> '' then
    Result := 'Fax/Modem on port ' + IntToStr(Ord(s[1]))
  else
    Result := '';
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.chkEmailAvailClick(Sender: TObject);
begin
  // Equivalent SBS component TBorCheck fires OnClick event twice
  pnlTabEmailClient.Enabled := chkEmailAvail.Checked;
end;

//-----------------------------------------------------------------------

function TfrmServerParams.ShowModal(Params : PFaxParams) : integer;
// Action : Populates all controls from values in Params structure
begin
 fFaxParams := Params;
 if Assigned(fFaxParams) then begin
   with fFaxParams^ do begin
     if FaxDeviceName = '' then btnSelectDeviceClick(nil)
     else {ApdTapiDevice1.SelectedDevice := FaxDeviceName};
     edtFaxCheckFreq.Text := IntToStr(FaxCheckFreq);
     edtExtLine.Text := FaxExtLine;
     edtDialAttempts.Text := IntToStr(FaxDialAttempts);
     edtRedialWait.Text := IntToStr(FaxDialRetryWait);
     edtConnectionWait.Text := IntToStr(FaxConnectWait);
     case FaxSendAction of
       'D' : radSendDelete.Checked := true;
       'A' : radSendArchive.Checked := true;
     end;
     edtOffPeakStart.Text := FormatDateTime('hhnn',FaxOffPeakStart);
     edtOffPeakEnd.Text := FormatDateTime('hhnn',FaxOffPeakEnd);

     edModemInit.Text := FaxModemInit;

     edDownStart.Text := FormatDateTime('hhnn',FaxDownTimeStart);
     edDownEnd.Text := FormatDateTime('hhnn',FaxDownTimeEnd);

     edtHeaderLine.Text := FaxHeaderLine;
     edtStationID.Text := FaxStationID;
{     edtFaxClientDir.Text := FaxClientRoot;}

     chkEmailAvail.Checked := FaxEmailAvail;
     case FaxEmailType of
       'M' : radMAPI.Checked := true;
       'S' : radSMTP.Checked := true;
     end;
     edtSMTPServer.Text := FaxSMTPServerName;
     case FaxSenderNotify of
       'A' : radNotifyAll.Checked := true;
       'F' : radNotifyFail.Checked := true;
       'N' : radNotifyNone.Checked := true;
     end;

     edSenderEmail.Text := FaxSenderEmailAddress;

     cbNoOfArchived.Checked := (FaxAdminNotify = 'F') or (FaxAdminNotify = 'B');
     cbSizeArchived.Checked := (FaxAdminNotify = 'S') or (FaxAdminNotify = 'B');

     chkDefaultToAdminEmail.Checked := FaxAdminEmailDefault;
     edtAdminAvailStart.Text := FormatDateTime('hhnn',FaxAdminAvailFrom);
     edtAdminAvailEnd.Text := FormatDateTime('hhnn',FaxAdminAvailTo);
     edtAdminFreq.Text := IntToStr(FaxAdminCheckFreq div (MILLI_SECS * SECS_PER_MIN));
     edtArchiveSize.Text := IntToStr(FaxArchiveSize);
     edtArchiveNo.Text := IntToStr(FaxArchiveNum);
     edtAdminEmail.Text := FaxAdminEmail;

     radNotifyAdminClick(self);
     chkDefaultToAdminEmailClick(self);
     pgcParams.ActivePage := tabGeneralSettings;
     pnlTabEmailClient.Enabled := chkEmailAvail.Checked;

     edAdminPass.Text := Decode(FaxAdminPass);
     edSystemPass.Text := Decode(FaxSystemPass);
     edRetryMins.FloatValue := FaxRetryMins;
     edNoOfRetries.FloatValue := FaxNoOfRetries;

     lModem.Caption := fFaxParams^.FaxDeviceName;
   end;{with}
 end;{if}

// radMAPI.Enabled := MAPIAvailableND;
 radMAPI.Enabled := MAPIAvailable;
 if not radMAPI.Enabled then radSMTP.Checked := TRUE;

 Result := inherited ShowModal;
end; // ShowModal

//-----------------------------------------------------------------------

procedure TfrmServerParams.radNotifyAdminClick(Sender: TObject);
// Action : Enables / disables admin notify controls dependent on which options checked
begin
{ edtArchiveSize.Enabled := cbSizeArchived.Checked;
  edtArchiveNo.Enabled := cbNoOfArchived.Checked;

  if radNotifyAdminDir.Checked then
  begin
    edtArchiveSize.Enabled := true;
    edtArchiveNo.Enabled := false;
    edtAdminEmail.Enabled := true;
    edtAdminFreq.Enabled := true;
  end;

  if radNotifyAdminNo.Checked then
  begin
    edtArchiveSize.Enabled := false;
    edtArchiveNo.Enabled := true;
    edtAdminEmail.Enabled := true;
    edtAdminFreq.Enabled := true;
  end;}

{ if radNotifyAdminNever.Checked then
  begin
    edtArchiveSize.Enabled := false;
    edtArchiveNo.Enabled := false;
    edtAdminFreq.Enabled := false;
    if not chkDefaultToAdminEmail.Checked then
      edtAdminEmail.Enabled := false;
  end;}
end; // TfrmServerParams.radNotifyAdminClick

//-----------------------------------------------------------------------

procedure TfrmServerParams.PopulateParamsRec;
// Action : Converts values stored in controls into fields in fFaxParams
begin
  with fFaxParams^ do
  begin
//    FaxDeviceName := ApdTapiDevice1.SelectedDevice;
    FaxCheckFreq := StrToInt(edtFaxCheckFreq.Text);
    FaxExtLine := edtExtLine.Text;
    FaxDialAttempts := StrToInt(edtDialAttempts.Text);
    FaxDialRetryWait := StrToInt(edtRedialWait.Text);
    FaxConnectWait := StrToInt(edtConnectionWait.Text);
    if radSendDelete.Checked then
      FaxSendAction := 'D'
    else
      FaxSendAction := 'A';

    FaxOffPeakStart := LocalEncodeTime(edtOffPeakStart.Text);
    FaxOffPeakEnd := LocalEncodeTime(edtOffPeakEnd.Text);

    FaxModemInit := edModemInit.Text;

    FaxDownTimeStart := LocalEncodeTime(edDownStart.Text);
    FaxDownTimeEnd := LocalEncodeTime(edDownEnd.Text);

    FaxHeaderLine := edtHeaderLine.Text;
    FaxStationID := edtStationID.Text;

    {Set Paths to EXE Dir
    FaxServerRoot := ExtractFilePath(Application.EXEName);
    FaxClientRoot := ExtractFilePath(Application.EXEName);}

    FaxServerRoot := '';
    FaxClientRoot := '';

    FaxEmailAvail := chkEmailAvail.Checked;
    if radMAPI.Checked then
      FaxEmailType := 'M'
    else
      FaxEmailType := 'S';
    FaxSMTPServerName := edtSMTPServer.Text;
    if radNotifyAll.Checked then
      FaxSenderNotify := 'A'
    else
      if radNotifyFail.Checked then
        FaxSenderNotify := 'F'
      else
        FaxSenderNotify := 'N';

    FaxSenderEmailAddress := edSenderEmail.Text;

    if cbSizeArchived.Checked then
      begin
        if cbNoOfArchived.Checked then FaxAdminNotify := 'B'
        else FaxAdminNotify := 'S';
      end
    else begin
      if cbNoOfArchived.Checked then FaxAdminNotify := 'F'
      else FaxAdminNotify := 'N';
    end;{if}

    FaxAdminEmailDefault := chkDefaultToAdminEmail.Checked;
    FaxAdminAvailFrom := LocalEncodeTime(edtAdminAvailStart.Text);
    FaxAdminAvailTo := LocalEncodeTime(edtAdminAvailEnd.Text);
    FaxAdminCheckFreq := StrToInt(edtAdminFreq.Text) * MILLI_SECS * SECS_PER_MIN;
    FaxArchiveSize := StrToInt(Trim(edtArchiveSize.Text));
    FaxArchiveNum := StrToInt(Trim(edtArchiveNo.Text));
    FaxAdminEmail := edtAdminEmail.Text;
    FaxAdminPass := Encode(UpperCase(edAdminPass.Text));
    FaxSystemPass := Encode(UpperCase(edSystemPass.Text));
    FaxRetryMins := Round(edRetryMins.FloatValue);
    FaxNoOfRetries := Round(edNoOfRetries.FloatValue);
  end; // with
end; // TfrmServerParams.PopulateParamsRec

//-----------------------------------------------------------------------

procedure TfrmServerParams.CheckForSubdirectories;
// Action : Checks for the fax sub-directories.  If they're absent offers the user
//          the chance to create them.
var
  i : TKnownFaxStatus;
  SubDirsAbsent : array[TKnownFaxStatus] of boolean;
  SubDirNames : string;
  ASubDirAbsent : boolean;
  DirCreateError : boolean;
  FaxDirs : TFaxDirs;
begin
  SetFaxDirectories(FaxDirs, sFaxServerRoot);

  ASubDirAbsent := false;
  for i := System.Low(TKnownFaxStatus) to System.High(TKnownFaxStatus) do begin
    SubDirsAbsent[i] := not DirectoryExists(FaxDirs[i]);
    if SubDirsAbsent[i] then ASubDirAbsent := true;
  end;{for}

  SubDirNames := '';
  if ASubDirAbsent then begin
    for i := System.Low(TKnownFaxStatus) to System.High(TKnownFaxStatus) do begin
      if SubDirsAbsent[i] then begin
        if SubDirNames = '' then SubDirNames := FaxDirs[i]
        else SubDirNames := SubDirNames + CRLF + FaxDirs[i];
      end;{if}
    end;{for}
  end;{if}

  if ASubDirAbsent then begin
    DirCreateError := false;
    for i := System.Low(TKnownFaxStatus) to System.High(TKnownFaxStatus) do begin
      if SubDirsAbsent[i] then begin
        try
          MkDir(FaxDirs[i]);
        except on EInOutError do
          DirCreateError := true;
        end;{try}
      end;{if}
    end;{for}

    if DirCreateError then MessageDlg('Sorry, could not create all sub-directories',mtError,[mbOK],0);
  end;{if}
end; // TfrmServerParams.CheckForSubdirectories

//-----------------------------------------------------------------------

procedure TfrmServerParams.btnOKClick(Sender: TObject);
begin
  PopulateParamsRec;
  CheckForSubDirectories;
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.CheckTimeExit(Sender: TObject);
// Action : Validate off peak start and end times
var
  TempDateTime : TDateTime;
begin
  with Sender as TMaskEdit do
  try
    TempDateTime := LocalEncodeTime(Text);
  except
    on EConvertError do
    begin
      MessageDlg('Invalid time - use 24 hour clock notation', mtWarning, [mbOK], 0);
      SetFocus;
    end;
  end;
end; // TfrmServerParams.CheckTimeExit

//-----------------------------------------------------------------------

procedure TfrmServerParams.radEmailTypeClick(Sender: TObject);
begin
  if radMAPI.Checked then
    edtSMTPServer.Enabled := false
  else
    edtSMTPServer.Enabled := true;
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.btnSubDirectoriesClick(Sender: TObject);
begin
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.btnSelectDeviceClick(Sender: TObject);
var
  iPort : Byte;
  i : Integer;

begin
  SelectModem(fFaxParams);
  if Length(fFaxParams^.FaxDeviceName) > 0 then
  begin
    lModem.Caption := fFaxParams^.FaxDeviceName;
  end
  else
    lModem.Caption := 'No modem selected';
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.ValidateIntegers(edtInteger : Text8Pt; Msg  : string;
  Min, Max : integer);
var
  Value : integer;
  Error : boolean;
begin
  edtInteger.Text := Trim(edtInteger.Text);
  Error := false;
  try
    Value := StrToInt(edtInteger.Text);
  except
    Error := true;
  end;

  Error := Error or (Value < Min) or (Value > Max);
  if Error then
  begin
    MessageDlg(Msg, mtWarning, [mbOK], 0);
    edtInteger.SetFocus;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmServerParams.NumericEditExitCheck(Sender: TObject);
begin
  if Sender = edtFaxCheckFreq then
    ValidateIntegers(edtFaxCheckFreq, 'Range must be from 1 to 180 minutes',1,180);
  if Sender = edtDialAttempts then
    ValidateIntegers(edtDialAttempts, 'Range must be from 1 to 10 tries',1,10);
  if Sender = edtRedialWait then
    ValidateIntegers(edtRedialWait, 'Range must be from 10 to 600 seconds',10,600);
  if Sender = edtAdminFreq then
    ValidateIntegers(edtAdminFreq, 'Range must be from 10 to 480 minutes (8 hours)',10,480);
  if Sender = edtConnectionWait then
    ValidateIntegers(edtConnectionWait, 'Range must be from 2 to 120 seconds',2,120);
end;

procedure TfrmServerParams.chkDefaultToAdminEmailClick(Sender: TObject);
begin
{  if chkDefaultToAdminEmail.Checked then
    edtAdminEmail.Enabled := true
  else
    edtAdminEmail.Enabled := not radNotifyAdminNever.Checked;}
end;

procedure TfrmServerParams.cbSizeArchivedClick(Sender: TObject);
begin
  edtArchiveSize.Enabled := cbSizeArchived.Checked;
  edtArchiveNo.Enabled := cbNoOfArchived.Checked;
end;

procedure TfrmServerParams.FormCreate(Sender: TObject);
begin
  sFaxServerRoot := IncludeTrailingBackslash(ExtractFilePath(Application.ExeName));
end;

procedure TfrmServerParams.btnModemTestClick(Sender: TObject);
begin
  with TfrmModemTest.Create(application) do begin
    try
 //     ApdTapiDevice := ApdTapiDevice1;
      showmodal;
    finally
      release;
    end;{try}
  end;{with}
end;


end.
