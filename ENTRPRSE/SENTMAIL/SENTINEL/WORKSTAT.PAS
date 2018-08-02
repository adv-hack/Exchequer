unit WORKSTAT;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{For sms senders - we check when Sentinel.exe first runs if we've got an
EnterpriseSMS.SMSSender registered. If not then we give the user a chance to
register one.  If they say no then we set IgnoreSMS flag to true and we don't
bother asking again. User can always register SMS Sender from workstation setup}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, GlobIni, Spin;

const
  ElertRootKey = HKEY_LOCAL_MACHINE;
  SMSRootKey = HKEY_CLASSES_ROOT;

  ElertKey = 'Software\Exchequer\Sentimail';
  ElertSMS = 'SMS';
  ElertEmail = 'Email';
  ElertHighPriority = 'High Priority';
  ElertLowPriority = 'Low Priority';

  ElertServer = 'SMPT Server';
  ElertUser = 'User Name';
  ElertAddress = 'User Address';

  ElertUseMapi = 'Use Mapi';

  EMLeft = 'Manager Left';
  EMTop = 'Manager Top';
  EMWidth = 'Manager Width';
  EMHeight = 'Manager Height';

  EMCol0 = 'Column 0';
  EMCol1 = 'Column 1';
  EMCol2 = 'Column 2';
  EMCol3 = 'Column 3';
  EMCol4 = 'Column 4';
  EMCol5 = 'Column 5';
  EMCol6 = 'Column 6';

  ElertFax = 'Fax';
  ElertPrint = 'Printer';
  ElertFTP = 'FTP';

  ELOff1Start = 'Offline 1 Start';
  ElOff1End = 'Offline 1 End';

  ELOff2Start = 'Offline 2 Start';
  ElOff2End = 'Offline 2 End';

  ElRunAlert = 'Alert';
  ElRunReport = 'Report';

  ElIgnoreSMS = 'Ignore SMS';
  ELCurrentSMS = 'Current SMS';

  SMSNameKey = 'EnterpriseSMS.SMSSender';

  ExchIniFile = 'SentSMS.ini';
  ThirdPartyIniFile = 'CustmSMS.ini';

  ElPollSpeed = 'PollSpeed'; //0-9

  SetupUSR = 'wstation\setup.usr';



type

  TElertWorkstationSetup = Class
  protected
    function GetBool(Index : Integer) : Boolean;
    procedure SetBool(Index : Integer; Value : Boolean);
    function GetString(Index : Integer) : AnsiString;
    procedure SetString(Index : Integer; const Value : AnsiString);
    function GetInt(Index : Integer) : SmallInt;
    procedure SetInt(Index : Integer; Value : SmallInt);
    function GetSMSSender : Boolean;

  public

    procedure ReadSetupUsr;
    property CanSendSMS : Boolean Index 1 read GetBool write SetBool;
    property CanSendEmail : Boolean Index 2 read GetBool write SetBool;
    property CanRunHighPriority : Boolean Index 3 read GetBool write SetBool;
    property CanRunLowPriority : Boolean Index 4 read GetBool write SetBool;
    property UseMapi : Boolean Index 5 read GetBool write SetBool;
    property SMTPServer  : AnsiString Index 1 read GetString write SetString;
    property SMTPUser    : AnsiString Index 2 read GetString write SetString;
    property SMTPAddress : AnsiString Index 3 read GetString write SetString;

    property MLeft   : SmallInt index 0 read GetInt write SetInt;
    property MTop    : SmallInt index 1 read GetInt write SetInt;
    property MWidth  : SmallInt index 2 read GetInt write SetInt;
    property MHeight : SmallInt index 3 read GetInt write SetInt;
    property MCol0   : SmallInt index 4 read GetInt write SetInt;
    property MCol1   : SmallInt index 5 read GetInt write SetInt;
    property MCol2   : SmallInt index 6 read GetInt write SetInt;
    property MCol3   : SmallInt index 7 read GetInt write SetInt;
    property MCol4   : SmallInt index 8 read GetInt write SetInt;
    property MCol5   : SmallInt index 9 read GetInt write SetInt;
    property MCol6   : SmallInt index 11 read GetInt write SetInt;

    property CanSendFax : Boolean Index 6 read GetBool write SetBool;
    property CanPrint   : Boolean Index 7 read GetBool write SetBool;


    property CanRunAlerts : Boolean Index 8 read GetBool write SetBool;
    property CanRunReports : Boolean Index 9 read GetBool write SetBool;

    property Offline1Start : AnsiString Index 4 read GetString write SetString;
    property Offline1End : AnsiString Index 5 read GetString write SetString;
    property Offline2Start : AnsiString Index 6 read GetString write SetString;
    property Offline2End : AnsiString Index 7 read GetString write SetString;

    property CurrentSMS : AnsiString Index  8 read GetString write SetString;
    property IgnoreSMS : Boolean Index 10 read GetBool write SetBool;

    property CanSendFTP : Boolean Index 11 read GetBool write SetBool;

    property SMSAvailable : Boolean read GetSMSSender;

    property PollSpeed : SmallInt index 10 read GetInt write SetInt;

  end;

  TfrmWorkstationSetup = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Panel1: TPanel;
    Button1: TButton;
    btnCancel: TButton;
    chkSMS: TCheckBox;
    chkEmail: TCheckBox;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    chkHigh: TCheckBox;
    chkLow: TCheckBox;
    TabSheet3: TTabSheet;
    Panel3: TPanel;
    edtServer: TEdit;
    edtUser: TEdit;
    edtAddress: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    chkUseMapi: TCheckBox;
    chkFax: TCheckBox;
    chkPrint: TCheckBox;
    tabAlerts: TTabSheet;
    Panel4: TPanel;
    chkRunAlerts: TCheckBox;
    chkRunReports: TCheckBox;
    TabSheet5: TTabSheet;
    Panel5: TPanel;
    edtOff1Start: TEdit;
    edtOff2Start: TEdit;
    edtOff2End: TEdit;
    edtOff1End: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    tabSMS: TTabSheet;
    GroupBox1: TGroupBox;
    lbSenders: TListBox;
    btnRegister: TButton;
    btnSetupSMS: TButton;
    chkFTP: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox2: TGroupBox;
    tbPollSpeed: TTrackBar;
    Label8: TLabel;
    Label9: TLabel;
    lblInterval: TLabel;
    TabSheet6: TTabSheet;
    GroupBox3: TGroupBox;
    edtAdminEmail: TEdit;
    edtAdminSMS: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel6: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    spnSmsWarn: TSpinEdit;
    Label16: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtOff1StartExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure chkSMSClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure btnRegisterClick(Sender: TObject);
    procedure btnSetupSMSClick(Sender: TObject);
    procedure lbSendersClick(Sender: TObject);
    procedure tbPollSpeedChange(Sender: TObject);
  private
    { Private declarations }
    FSetup : TElertWorkstationSetup;
    FGlobalIni : TSentIniObject;
    AList : TStringList;
    procedure ReadSections(const IniFileName : string);
    procedure RegisterSender(const WhichSender : string);
    function IntervalInSecs(I : integer) : string;
  public
    { Public declarations }
    IniDir : AnsiString;
    SMSSender : Variant;
    procedure ReadIniFile;
  end;

  function SMSQuery : Word;

//var
//  frmWorkstationSetup: TfrmWorkstationSetup;


implementation

{$R *.DFM}
uses
  Registry, BtSupU2, ComObj, ElVar, IniFiles, ApiUtil, AcForm;


function SMSQuery : Word;
begin
  Result := MessageDlg('You do not have an SMS sender registered on this workstation'#10
                             + 'Do you wish to register one now?', mtInformation, [mbYes, mbNo], hcSMSSenderDlg);
end;

function TElertWorkstationSetup.GetBool(Index : Integer) : Boolean;
begin
  Result := False;
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, False) then
    begin
     Try
      Case Index of
        1 : Result := ReadBool(ElertSMS);
        2 : Result := ReadBool(ElertEmail);
        3 : Result := ReadBool(ElertHighPriority);
        4 : Result := ReadBool(ElertLowPriority);
        5 : Result := ReadBool(ElertUseMapi);
        6 : Result := ReadBool(ElertFax);
        7 : Result := ReadBool(ElertPrint);
        8 : Result := ReadBool(ElRunAlert);
        9 : Result := ReadBool(ElRunReport) and (ReportsAvailable or VisualReportsAvailable);
       10 : Result := ReadBool(ElIgnoreSMS);
       11 : Result := ReadBool(ElertFTP);
      end;
     Except
       Case Index of
         2, 3, 4, 8, 9 : Result := True;
         else
           Result := False;
       end;
     End;
    end;
  Finally
    Free;
  End;
end;

procedure TElertWorkstationSetup.SetBool(Index : Integer; Value : Boolean);
begin
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, True) then
    begin
      Case Index of
        1 : WriteBool(ElertSMS, Value);
        2 : WriteBool(ElertEmail, Value);
        3 : WriteBool(ElertHighPriority, Value);
        4 : WriteBool(ElertLowPriority, Value);
        5 : WriteBool(ElertUseMapi, Value);
        6 : WriteBool(ElertFax, Value);
        7 : WriteBool(ElertPrint, Value);
        8 : WriteBool(ElRunAlert, Value);
        9 : WriteBool(ElRunReport, Value and (ReportsAvailable or VisualReportsAvailable));
       10 : WriteBool(ElIgnoreSMS, Value);
       11 : WriteBool(ElertFTP, Value);
      end;
    end;
  Finally
    Free;
  End;
end;

function TElertWorkstationSetup.GetString(Index : Integer) : AnsiString;
begin
  Result := '';
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, False) then
    begin
     Try
      Case Index of
        1 : Result := ReadString(ElertServer);
        2 : Result := ReadString(ElertUser);
        3 : Result := ReadString(ElertAddress);
        4 : Result := ReadString(ElOff1Start);
        5 : Result := ReadString(ElOff1End);
        6 : Result := ReadString(ElOff2Start);
        7 : Result := ReadString(ElOff2End);
        8 : Result := ReadString(ElCurrentSMS);
      end;
     Except
      Result := '';
     End;
    end;
    if (Result = '') and (Index in [4..7]) then
      Result := '00:00';
  Finally
    Free;
  End;
end;

procedure TElertWorkstationSetup.SetString(Index : Integer; const Value : AnsiString);
begin
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, True) then
    begin
      Case Index of
        1 : WriteString(ElertServer, Value);
        2 : WriteString(ElertUser, Value);
        3 : WriteString(ElertAddress, Value);
        4 : WriteString(ElOff1Start, Value);
        5 : WriteString(ElOff1End, Value);
        6 : WriteString(ElOff2Start, Value);
        7 : WriteString(ElOff2End, Value);
        8 : WriteString(ElCurrentSMS, Value);
      end;
    end;
  Finally
    Free;
  End;
end;

function TElertWorkstationSetup.GetSMSSender : Boolean;
begin
  with TRegistry.Create do
  Try
    RootKey := SMSRootKey;
    if OpenKey(SMSNameKey, False) then
      Result := True
    else
      Result := False;
  Finally
    Free;
  End;
end;

function TElertWorkstationSetup.GetInt(Index : Integer) : SmallInt;
begin
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, True) then
    begin
      Try
        Case Index of
          0 : Result := ReadInteger(EMLeft);
          1 : Result := ReadInteger(EMTop);
          2 : Result := ReadInteger(EMWidth);
          3 : Result := ReadInteger(EMHeight);

          4 : Result := ReadInteger(EMCol0);
          5 : Result := ReadInteger(EMCol1);
          6 : Result := ReadInteger(EMCol2);
          7 : Result := ReadInteger(EMCol3);
          8 : Result := ReadInteger(EMCol4);
          9 : Result := ReadInteger(EMCol5);

         10 : Result := ReadInteger(ElPollSpeed);
         11 : Result := ReadInteger(EMCol6);

        end;
      Except
        Case Index of
          0  : Result := (Screen.Width div 2) -
                         (Application.MainForm.Width div 2);
          1  : Result := (Screen.Height div 2) -
                         (Application.MainForm.Height div 2);
          2  : Result := Application.MainForm.Width;
          3  : Result := Application.MainForm.Height;
          else
            Result := 0;
        end;
      End;
    end
    else
    begin
      Result := 0;
      raise Exception.Create('Unable to open registry key');
    end;
  Finally
    Free;
  End;
end;

procedure TElertWorkstationSetup.SetInt(Index : Integer; Value : SmallInt);
begin
  with TRegistry.Create do
  Try
    RootKey := ElertRootKey;
    if OpenKey(ElertKey, True) then
    begin
      Case Index of
        0 : WriteInteger(EMLeft, Value);
        1 : WriteInteger(EMTop, Value);
        2 : WriteInteger(EMWidth, Value);
        3 : WriteInteger(EMHeight, Value);

        4 : WriteInteger(EMCol0, Value);
        5 : WriteInteger(EMCol1, Value);
        6 : WriteInteger(EMCol2, Value);
        7 : WriteInteger(EMCol3, Value);
        8 : WriteInteger(EMCol4, Value);
        9 : WriteInteger(EMCol5, Value);

       10 : WriteInteger(ElPollSpeed, Value);
       11 : WriteInteger(EMCol6, Value);
      end;
    end;
  Finally
    Free;
  End;
end;

procedure TElertWorkstationSetup.ReadSetupUsr;
const
  EntSection = 'Entrprse';
var
  TheIni : TIniFile;
begin
  TheIni := TIniFile.Create(GlobalEntPath + SetupUSR);
  Try
    //read
    CanSendEmail := True;
    UseMapi := TheIni.ReadString(EntSection, 'PEmail', 'A') = 'A';
    SMTPServer := TheIni.ReadString(EntSection, 'PEmailSMTP', '');
    SMTPUser :=  TheIni.ReadString(EntSection, 'PEmailName', '');
    SMTPAddress := TheIni.ReadString(EntSection, 'PEmailAddr', '');
  Finally
    TheIni.Free;
  End;
end;

procedure TfrmWorkstationSetup.FormCreate(Sender: TObject);
begin
  FSetup := TElertWorkstationSetup.Create;
  FGlobalIni := TSentIniObject.Create(GlobalIniFileName);
  AList := TStringList.Create;

 { chkSMS.Enabled := FSetup.SMSAvailable;}
  chkSMS.Checked := FSetup.CanSendSMS {and chkSMS.Enabled};

  chkEmail.Checked := FSetup.CanSendEmail;
  chkFax.Checked := FSetup.CanSendFax;
  chkPrint.Checked := FSetup.CanPrint;
  chkFTP.Checked := FSetup.CanSendFTP;

  chkHigh.Checked := FSetup.CanRunHighPriority;
  chkLow.Checked := FSetup.CanRunLowPriority;

  chkUseMapi.Checked := FSetup.UseMapi;

  edtServer.Text := FSetup.SMTPServer;
  edtUser.Text := FSetup.SMTPUser;
  edtAddress.Text := FSetup.SMTPAddress;

  chkRunAlerts.Checked := FSetup.CanRunAlerts;
  chkRunReports.Enabled := ReportsAvailable or VisualReportsAvailable;
  chkRunReports.Checked := FSetup.CanRunReports;

  edtOff1Start.Text := FSetup.Offline1Start;
  edtOff1End.Text := FSetup.Offline1End;
  edtOff2Start.Text := FSetup.Offline2Start;
  edtOff2End.Text := FSetup.Offline2End;

  tbPollSpeed.Position := FSetup.PollSpeed;
  lblInterval.Caption := IntervalInSecs(tbPollSpeed.Position);

  edtAdminEmail.Text := FGlobalIni.AdminEmail;
  edtAdminSMS.Text := FGlobalIni.AdminSMS;


  if not FSetup.IgnoreSMS then
    PageControl1.ActivePage := tabSMS
  else
    PageControl1.ActivePage := tabAlerts;

  spnSmsWarn.Value := FGlobalIni.smsWarnLevel;    


end;

procedure TfrmWorkstationSetup.Button1Click(Sender: TObject);
begin
  if not FSetup.SMSAvailable then
    chkSMS.Checked := False;
  FSetup.CanSendSMS := chkSMS.Checked and FSetup.SMSAvailable;
  FSetup.CanSendEmail := chkEmail.Checked;
  FSetup.CanSendFax := chkFax.Checked;
  FSetup.CanPrint := chkPrint.Checked;
  FSetup.CanSendFTP := chkFTP.Checked;

  FSetup.CanRunHighPriority := chkHigh.Checked;
  FSetup.CanRunLowPriority := chkLow.Checked;

  FSetup.UseMapi := chkUseMapi.Checked;

  FSetup.SMTPServer := edtServer.Text;
  FSetup.SMTPUser := edtUser.Text;
  FSetup.SMTPAddress := edtAddress.Text;

  FSetup.CanRunAlerts := chkRunAlerts.Checked;
  FSetup.CanRunReports := chkRunReports.Checked;

  FSetup.Offline1Start := edtOff1Start.Text;
  FSetup.Offline1End := edtOff1End.Text;
  FSetup.Offline2Start := edtOff2Start.Text;
  FSetup.Offline2End := edtOff2End.Text;

  FSetup.PollSpeed := tbPollSpeed.Position;

  FGlobalIni.AdminEmail := edtAdminEmail.Text;
  FGlobalIni.AdminSMS := edtAdminSMS.Text;

  FGlobalIni.smsWarnLevel := spnSmsWarn.Value;


{$IFDEF OldSMS}
  btnRegisterClick(Self);
{$ENDIF}  
end;

procedure TfrmWorkstationSetup.FormDestroy(Sender: TObject);
begin
  if Assigned(FSetup) then
    FSetup.Free;

  if Assigned(FGlobalIni) then
    FGlobalIni.Free;

  if Assigned(AList) then
    AList.Free;
end;

procedure TfrmWorkstationSetup.edtOff1StartExit(Sender: TObject);
var
  d : TDateTime;
  s : AnsiString;
begin
  if (ActiveControl <> btnCancel) and (Sender is TEdit) then
    with Sender as TEdit do
    begin
      Try
        if Text = '' then Text := '00:00';
        d := StrToTime(Text);
      Except
        s := QuotedStr(Text) + ' is not a valid Time'#10 +
                                      'Please use format ' + ShortTimeFormat;
        Application.MessageBox(PChar(s), 'Sentimail', MB_OK or MB_ICONEXCLAMATION);
        ActiveControl := TWinControl(Sender);
      End;
    end;
end;

procedure TfrmWorkstationSetup.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);

end;

procedure TfrmWorkstationSetup.FormKeyPress(Sender: TObject;
  var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);

end;

procedure TfrmWorkstationSetup.ReadIniFile;
var
  s : string;
  i, j  : integer;
begin
{  Try
    AList.LoadFromFile(IniDir + IniFileName);
    i := 0;
    while i < Alist.Count do
    begin
      s := AList[i];
      j := Pos('|', s);
      if j > 0 then
      begin
        if FileExists(Copy(s, j + 1, Length(s))) then
        begin
          lbSenders.Items.Add(Copy(s, 1, j - 1));
          Delete(s, 1, j);
          AList[i] := s;
          inc(i);
        end
        else
          AList.Delete(i);
      end
      else
        AList.Delete(i);
    end; //while
  Except
  End;}
  lbSenders.Clear;
  ReadSections(ExchIniFile);
  Try
    ReadSections(ThirdPartyIniFile);
  Except
  End;
end;



procedure TfrmWorkstationSetup.chkSMSClick(Sender: TObject);
var
  Res : Word;
begin
  if not FSetup.SMSAvailable and chkSMS.Checked then
  begin
    Res := SMSQuery;
    if Res = mrYes then
    {$IFDEF OldSMS}
      PageControl1.ActivePage := tabSMS
    {$ELSE}
    begin
      RegisterComServer(IniDir + 'entsms.dll');
      ShowMessage('SMS Sender registered');
    end
    {$ENDIF}
    else
      chkSMS.Checked := False;
  end;

end;

procedure TfrmWorkstationSetup.ReadSections(const IniFileName : string);
var
  s : string;
  i, j  : integer;
begin
{$IFDEF OldSMS}
  AList.Clear;
  AList.LoadFromFile(IniDir + IniFileName);
  i := 0;
  while i < Alist.Count do
  begin
    s := AList[i];
    if Length(s) > 0 then
    begin
      if s[1] = '[' then
      begin
        Delete(s, 1, 1);
        j := Length(s);
        while (j > 0) and (s[j] <> ']') do dec(j);
        if j > 0 then
          Delete(s, j, Length(s));
        lbSenders.Items.Add(s);
      end;
    end;
    inc(i);
  end;
  if FSetup.SMSAvailable then
    lbSenders.ItemIndex := lbSenders.Items.IndexOf(FSetup.CurrentSMS);
{$ENDIF}

end;

procedure TfrmWorkstationSetup.RegisterSender(const WhichSender : string);
var
  i : integer;
  s : string;
  IniFileName : string;
begin
{$IFDEF OldSMS}
  IniFileName := '';
  with TIniFile.Create(IniDir + ExchIniFile) do
  Try
    if SectionExists(WhichSender) then
      IniFilename := ExchIniFile;
  Finally
    Free;
  End;

  if IniFileName = '' then
  with TIniFile.Create(IniDir + ThirdPartyIniFile) do
  Try
    if SectionExists(WhichSender) then
      IniFilename := ThirdPartyIniFile;
  Finally
    Free;
  End;

  AList.Clear;
  with TIniFile.Create(IniDir + IniFileName) do
  Try
    ReadSection(WhichSender, AList);
    if AList.Count > 0 then
    begin
      Try
        for i := 0 to AList.Count - 1 do
        begin
          s := ReadString(WhichSender, AList[i], '');
          RegisterComServer(IniDir + s);
        end;
        ShowMessage(WhichSender + ' registered successfully');
      Except
        ShowMessage('Error: Unable to register ' + WhichSender + ' (' +
                        AList[i] + ')');
      End;
    end
    else
      MessageDlg('No COM objects listed in ' + IniDir + IniFileName + ' for ' + WhichSender,
                    mtError, [mbOK], 0);
  Finally
    Free;
  End;
{$ELSE}
  RegisterComServer(IniDir + 'sms_wap.dll');
{$ENDIF}
end;

procedure TfrmWorkstationSetup.PageControl1Change(Sender: TObject);
begin
   btnRegister.Visible := PageControl1.ActivePage = tabSMS;
   btnSetupSMS.Visible := btnRegister.Visible;
{$IFDEF OldSMS}
   btnRegister.Enabled := lbSenders.ItemIndex > -1;
   btnSetupSMS.Enabled := btnRegister.Enabled;
{$ENDIF}
   HelpContext := PageControl1.ActivePage.Tag;

end;

procedure TfrmWorkstationSetup.btnRegisterClick(Sender: TObject);
var
  OldCursor : TCursor;
  s : string;
begin
{$IFDEF OldSMS}
  if lbSenders.ItemIndex > -1 then
  begin
    if Trim(FSetup.CurrentSMS) <> Trim(lbSenders.Items[lbSenders.itemIndex]) then
    begin
      RegisterSender(lbSenders.Items[lbSenders.itemIndex]);
      FSetup.CurrentSMS := lbSenders.Items[lbSenders.itemIndex];
      ShowMessage('You must restart the Sentimail engine before this change will take effect');
      if FSetup.CurrentSMS  = 'Mobile Message Centre (Internet)' then
        MsgBox('This Message Centre requires that numbers are specified in their international format'#10#10
                  + 'e.g. The UK number 07768123456 becomes 447768123456', mtInformation, [mbOK], mbOK,
                  'Mobile Message Centre (Internet)');
    end;
  end;
{$ELSE}
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
//  lblConnect.Visible := True;
  Try
{    s := SMSSender.GetErrorDesc(3333);
    if s <> '-1' then
      ShowMessage('You have ' + s + ' SMS credits available.')
    else
      ShowMessage('Unable to check account at this time.  Please try again later');}
    frmAccount := TfrmAccount.Create(nil);
    frmAccount.SMSSender := SMSSender;
    frmAccount.ShowModal;
{  Except;
      ShowMessage('Unable to check account at this time.  Please try again later');}
  Finally
    frmAccount.Free;
  End;
//  lblConnect.Visible := False;
  Screen.Cursor := OldCursor;
{$ENDIF}
end;

procedure TfrmWorkstationSetup.btnSetupSMSClick(Sender: TObject);
var
  Res : Word;
begin
{$IFDEF OldSMS}
  if lbSenders.ItemIndex > -1 then
{$ENDIF}
  Try
    Res := mrYes;
{$IFDEF OldSMS}
    if lbSenders.Items[lbSenders.ItemIndex] <> FSetup.CurrentSMS then
    begin
      Res := MessageDlg(QuotedStr(lbSenders.Items[lbSenders.ItemIndex]) + ' is not the ' +
                       'currently registered SMS Sender.  Do you wish to register it?'#10 +
                       '(Please note: This will unregister the currently registered sender.)',
                       mtConfirmation, mbYesNoCancel, 0);
      if Res = mrYes then
        btnRegisterClick(Self);
    end;
{$ENDIF}
    if Res = mrYes then
      SMSSender.Setup;
  Except
  End;
end;

procedure TfrmWorkstationSetup.lbSendersClick(Sender: TObject);
begin
   btnRegister.Enabled := lbSenders.ItemIndex > -1;
   btnSetupSMS.Enabled := btnRegister.Enabled;
end;

function TfrmWorkstationSetup.IntervalInSecs(I : integer) : string;
var
  D : Double;
begin
  d := I;
  d := d /2;

  if d = (i div 2) then
    Result := Format('%2.0f secs', [d])
  else
    Result := Format('%2.1f secs', [d]);
end;

procedure TfrmWorkstationSetup.tbPollSpeedChange(Sender: TObject);
begin
  lblInterval.Caption := IntervalInSecs(tbPollSpeed.Position);
  lblInterval.Repaint;
end;


end.

