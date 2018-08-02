unit ElManF;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Enterprise01_TLB, ElObjs, ImgList, Menus, ExtCtrls, APIUTil,
  Buttons, EngineF, ElVar;

type

  TfrmELManager = class(TForm)
    pnlUser: TPanel;
    lbl2: TLabel;
    cbUser: TComboBox;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Active1: TMenuItem;
    N1: TMenuItem;
    Status1: TMenuItem;
    Purge1: TMenuItem;
    PurgeAll1: TMenuItem;
    Purgesystemevents1: TMenuItem;
    RetrySend1: TMenuItem;
    N2: TMenuItem;
    EnginesRunning1: TMenuItem;
    N4: TMenuItem;
    Export1: TMenuItem;
    Import1: TMenuItem;
    N3: TMenuItem;
    About1: TMenuItem;
    Timer1: TTimer;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    Panel1: TPanel;
    lvElerts: TListView;
    pnlButtonBackground: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnCopy: TButton;
    btnRunNow: TButton;
    btnTest: TButton;
    btnClose: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure lvElertsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure btnDeleteClick(Sender: TObject);
    procedure cbUserChange(Sender: TObject);
    procedure btnCopyClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure lvElertsDblClick(Sender: TObject);
    procedure btnRunNowClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure lvElertsSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Active1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Status1Click(Sender: TObject);
    procedure lvElertsColumnClick(Sender: TObject; Column: TListColumn);
    procedure lvElertsCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure Purge1Click(Sender: TObject);
    procedure PurgeAll1Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RetrySend1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure Import1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure EnginesRunning1Click(Sender: TObject);
    procedure Purgesystemevents1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
    FToolkit : IToolkit;
    ThisElert : TElertObject;
    FDataDir : AnsiString;
    CurrentCaption : AnsiString;
    ElertUnlocked : Boolean;
    SortIndex : Integer;
    SortDirections : Array[0..5] of SmallInt;
    FirstTime, Showing : Boolean;
    SysRec  : TSysRec;
    EnginesRunning : TEnginesRunningRec;
    PrevEngineCount : Array[1..MaxEngines] of longint;
    EngineMissCount : Array[1..MaxEngines] of byte;
    IsCust : Boolean;
    procedure FillList(Added : Boolean = False);
    function GetCoCode : ShortString;
    function AuthorizedUser(const ID, Pass : ShortString) : SmallInt;
    procedure StartLogIn;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    function EventKeyType(winId : longint) : String;
    function EventFileNo(WinID : longint; IsCust : Boolean) : SmallInt;
    procedure ShowStatus(Res : SmallInt);
    procedure LoadPositions;
    procedure SavePositions;
    procedure ExportSentinels;
    procedure ImportSentinels;
    function CompanyName : String;
    function CheckSysPassword(const s : string) : SmallInt;
    function CheckNoOfSentinels : Boolean;
    procedure CheckEngines;
    function ThisElertCanRun : boolean;
    function CheckSentimailSecurity(const UserName : Shortstring) : Boolean;
    procedure ApplicationActive(Sender : TObject);
    procedure EntDeActivate(Sender : TObject);
    procedure MarkExistingRecs(IsCust : Boolean);
  public
    { Public declarations }
  end;

var
  frmELManager: TfrmELManager;

implementation

{$R *.DFM}
uses
  Wizard, ComObj, SecCodes, debugLog, SentU, {$IFDEF AQ}WorkSta2,
  EntLicence{$ELSE}WorkStat{$ENDIF}, Status,
  EnterpriseSMS_TLB, GlobVar, LineDBug, ElEvDefs, KeyForm,
  Selfld2, ElExpImp, Variants, {SecureU}DailyPW, About, fileUtil, PurgeOpt, RWOpenF, DateUtils,
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  AddRec, CTKUtil, LoginF, PasswordComplexityConst, AdoConnect;

var
  FormUserID : ShortString;



procedure TfrmELManager.btnAddClick(Sender: TObject);
var
  OldCursor : TCursor;
begin
  OldCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
 {$IFDEF PALL}
  WriteToPalladiumLog('Add Button clicked');
 {$ENDIF}
  oToolkit := FToolkit;
  if CheckNoOfSentinels then
  begin
    if not Showing then
    begin
      Timer1.Enabled := False;
      Showing := True;
    {$IFDEF PALL}
    WriteToPalladiumLog('About to Create Wizard');
    {$ENDIF}
//      with TfrmElWizard.Create(nil) do
      with frmElWizard do
      Try
    {$IFDEF PALL}
    WriteToPalladiumLog('Wizard Created');
    {$ENDIF}
        Image1.Visible := not NoXLogo;

        UserID := cbUser.Text;
        Toolkit := FToolkit;
        ThisElert.Clear;
        ThisElert.DaysOfWeek := 31;
        ThisElert.SingleEmail := True;
    {$IFDEF PALL}
    WriteToPalladiumLog('After ThisElert.Clear');
    {$ENDIF}
        Elert := ThisElert;
        LoadForm;
        IsEdit := False;
        LoadFolderTree;
    {$IFDEF PALL}
    WriteToPalladiumLog('After LoadFolderTree');
    {$ENDIF}

        ShowModal;
        if ModalResult = mrOK then
        begin
          CurrentCaption := ThisElert.ElertName;
          if chkMarkExisting.Checked then
            MarkExistingRecs(rgAcType.ItemIndex = 0);
        end;
        FillList(True);
      Finally
//        Free;
      End;
      Showing := False;
      Timer1.Enabled := True;
    end;
  end;
  oToolkit := nil;
  Screen.Cursor := OldCursor;
end;

procedure TfrmELManager.FormCreate(Sender: TObject);
var
  i :integer;
  V : Variant;
  a, b, c : longint;
  s, TempS : string;
  Res : SmallInt;

  procedure ShowCloseMessage(const s : Ansistring);
  begin
    Application.MessageBox(PChar('Unable to find data file ' +
                      SetDrive + ElPath + s + #10'Please contact your Technical Support.'), 'Sentimail',
                      MB_OK or MB_ICONERROR);
    PostQuitMessage(0);
  end;

begin
  //Intialise GlobalAdoConnection as we will be using SystemSetup
  if EnterpriseLicence.IsSQL and (not Assigned(GlobalAdoConnection)) then
    InitialiseGlobalADOConnection(SetDrive);
  //PR: 16/05/2013 ABSEXCH-13897 Extend for versions later than XP
  if GetWindowsVersion in wvXPStyle then
  begin
    lvElerts.Height := Panel1.ClientHeight - 12;
  end;
  ConvertOldRegistryValues;
  {$IFDEF PALL}
  if SaveDialog2.Execute then
    LogFName := SaveDialog2.FileName;
  {$ENDIF}

{$IFNDEF CreateFiles}
  {$IFDEF EXSQL}
  if not TableExists(SetDrive + ElPath + 'SENT.DAT') then
  {$ELSE}
  if not FileExists(SetDrive + ElPath + 'SENT.DAT') then
  {$ENDIF}
  begin
    ShowCloseMessage('SENT.DAT');
    EXIT;
  end;

  {$IFDEF EXSQL}
  if not TableExists(SetDrive + ElPath + 'SENTLINE.DAT') then
  {$ELSE}
  if not FileExists(SetDrive + ElPath + 'SENTLINE.DAT') then
  {$ENDIF}
  begin
    ShowCloseMessage('SENTLINE.DAT');
    EXIT;
  end;
{$ENDIF}

  Application.OnActivate   := ApplicationActive;
  Application.OnDeactivate := EntDeActivate;
  Application.OnMinimize   := EntDeActivate;
  Application.OnRestore    := ApplicationActive;

  FirstTime := True;
  Showing := False;
  Try
    FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  Except
    ShowMessage('Unable to create COM Toolkit. Application will terminate');
    Application.Terminate;
  End;

  if Assigned(FToolkit) then
  begin
    {$IFDEF PALL}
    WriteToPalladiumLog('Toolkit created');
    {$ENDIF}

    with FToolkit do
    begin
{      if (FToolkit.Version >= 'TKCOM-v4.32.035') or
         (Copy(FToolkit.Version, 1, 9) = 'TKCOM-500') or
         ((FToolkit.Version[7] = 'b') and (FToolkit.Version >= 'TKCOM-b500.100')) then}
      begin

        EncodeOpCode(97, a, b, c);
        Configuration.SetDebugMode(a, b, c);
      end;
    end;
    if Trim(SetDrive) = '' then
      SetDrive := IncludeTrailingBackSlash(ExtractFilePath(ParamStr(0)));

    {$IFDEF PALL}
    WriteToPalladiumLog('SetDrive: ' + QuotedStr(SetDrive));
    {$ENDIF}

    StartLogin;

    {$IFDEF PALL}
    WriteToPalladiumLog('Logged in');
    {$ENDIF}

    SortIndex := 0;
    SortDirections[0] := -1;
    for i := 1 to 4 do
      SortDirections[i] := 1;
    FDataDir := SetDrive;
    DefineFiles('');
    ThisElert := TElertObject.Create;
    ThisElert.CompanyCode := CompanyCodeFromPath(FToolkit, FDataDir);


    with FToolkit do
    begin
      begin
        SysRec := TSysRec.Create(Trim(GetEnterpriseDirectory));

        Configuration.DataDirectory := FDataDir;
        {$IFDEF PALL}
        WriteToPalladiumLog('Configuration.DataDirectory: ' + QuotedStr(Configuration.DataDirectory));
        {$ENDIF}

        Res := OpenToolkit;
        if Res <> 0 then
          ShowMessage('Unable to open COM Toolkit'#10#10'(' + IntToStr(Res) + ') ' +
                        QuotedStr(LastErrorString))
        else
        Try
          with SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes2 do
            VisualReportsAvailable := rcVisualReportWriter <> rcDisabled;
          ReportsAvailable := SystemSetup.ssReleaseCodes.rcReportWriter <> rcDisabled;
          if ReportsAvailable then
          begin
            {$IFDEF EXSQL}
            if TableExists(SetDrive + 'Reports\Reports.DAT') then
            {$ELSE}
            if FileExists(SetDrive + 'Reports\Reports.DAT') then
            {$ENDIF}
              OpenRW;
          end;
          EncodeOpCode(64, a, b, c);
          V := Configuration.SetDebugMode(a, b, c);
          if VarType(V) <> varEmpty then
          begin
             cbUser.Items.CommaText := V.UserNames;
             cbUser.ItemIndex := 0;
          end;
  {        else
            raise EComTKException.Create('Can''t load user list');}
        Finally
          V := Unassigned;
          CloseToolkit;
        End;
      end;
    end;

    //DON'T FORGET TO CHANGE THIS WHEN POSSIBLE - changed
    if Trim(FormUserID) <> 'SYSTEM' then
    begin
      cbUser.ItemIndex := cbUser.Items.IndexOf(Trim(FormUserID));
      ClientHeight := Panel1.Height;
      pnlUser.Visible := False;
  {    ClientHeight := Panel1.Height + 16;}
  {    Panel1.Top := 16;}
    end;
    FillList;
    SortDirections[0] := -1;
    Caption := 'Sentimail Sentinel Manager - ' + CompanyName;
  //  LoadPositions;
    Fillchar(PrevEngineCount, SizeOf(PrevEngineCount), 0);
    FillChar(EngineMissCount, SizeOf(EngineMissCount), 0);

    RepPasswordList := TStringList.Create;

    AllowDebugInfo := False;
    for i := 1 to ParamCount do
    begin
      s := UpperCase(ParamStr(i));
      Delete(s, 1, 1);
      if s = 'AXD' then
        AllowDebugInfo := True;
    end;

    frmElWizard := TfrmElWizard.Create(Application);
    Timer1.Enabled := True;
  end //If assigned(FToolkit)
  else
   raise EComTKException.Create('COM Toolkit not available');

end;

procedure TfrmELManager.FormDestroy(Sender: TObject);
begin
  FToolkit := nil;
//  FSMSSender := nil;
  if Assigned(ThisElert) then
    ThisElert.Free;

  if Assigned(SysRec) then
    SysRec.Free;

  if Assigned(RepPasswordList) then
    RepPasswordList.free;

{  if Assigned(frmElWizard) then
    frmElWizard.Free;}

end;

procedure TfrmELManager.FillList(Added : Boolean = False);
var
  Res : SmallInt;
  TempItem : TListItem;
  WasTop : longint;
begin
  if Assigned(lvElerts.TopItem) then
    WasTop := lvElerts.TopItem.Index
  else
    WasTop := -1;
  CheckEngines;
    {$IFDEF PALL}
    WriteToPalladiumLog('Back from engine check');
    {$ENDIF}
  lvElerts.Items.BeginUpdate;
  with ThisElert do
  begin
    lvElerts.Items.Clear;
    UserID := cbUser.Text;
    Index := 0;
    Res := GetFirst;

    while Res = 0 do
    begin
      with lvElerts.Items.Add do
      begin
        //Name and icon
        Caption := ElertName;
        if ElertType = etTimer then
        begin
          if ActionReport then
            ImageIndex := 3
          else
            ImageIndex := 0;
        end
        else
        begin
          if ActionReport then
            ImageIndex := 4
          else
            ImageIndex := 1;
        end;

        //Active - Yes/no or Exp for expired
        if Expired then
          SubItems.Add('Expired')
        else
        if Active then
          SubItems.Add('Yes')
        else
          SubItems.Add('No');

        //Last date run
        if LastDateRun > 0 then
          SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn', LastDateRun))
        else
          SubItems.Add('N/A');

        //Next run due
        if Active and (ElertType = etTimer) then
          SubItems.Add(FormatDateTime('dd/mm/yyyy hh:nn', NextRunDue))
        else
          SubItems.Add('N/A');

        //Status
        SubItems.Add(StatusString);

        //Set icon if overdue
        if Active and (ElertType = etTimer) then
          if (NextRunDue < Now) and (Status = esIdle) then
            ImageIndex := 2;

        if Pos('Error', SubItems[SubItems.Count - 1]) > 0 then
          ImageIndex := 2;

        //Priority
{        if Priority = elpHigh then
          SubItems.Add('High')
        else
          SubItems.Add('Low');}
          SubItems.Add(IntToStr(CanRunPercent(EnginesRunning)) + '%');

          SubItems.Add(Workstation);
        //Description - not shown but used for hint
        SubItems.Add(Description);
      end;

      Res := GetNext;
    end;
    {$IFDEF PALL}
    WriteToPalladiumLog('End of FillList');
    {$ENDIF}
  end;//with

  SortDirections[SortIndex] := - SortDirections[SortIndex];
  lvElerts.AlphaSort;
  SortDirections[SortIndex] := - SortDirections[SortIndex];

  TempItem := lvElerts.FindCaption(0, CurrentCaption, False, True, True);

  if Assigned(TempItem) then
  begin
    lvElerts.Selected := TempItem;
    if Added then
      lvElerts.Selected.MakeVisible(False);
  end;
  if not Added and (WasTop <> -1) and (lvElerts.Items.Count > 0) then
  begin
    WasTop := WasTop + lvElerts.VisibleRowCount - 1;
    if Assigned(lvElerts.Items[WasTop]) then
      lvElerts.Items[WasTop].MakeVisible(False)
    else
      lvElerts.Items[lvElerts.Items.Count - 1].MakeVisible(False);
  end;
  ActiveControl := lvElerts;
  lvElerts.Items.EndUpdate;
end;

function TfrmELManager.GetCoCode : ShortString;
var
  i : integer;
  s : ShortString;
begin
{  s := cbCompany.Text;
  i := Length(s) - 1;
  while (i > 0) and (s[i] <> '(') do dec(i);
  Result := Copy(s, i + 1, Length(s));
  Delete(Result, Length(Result), 1);}
end;


procedure TfrmELManager.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmELManager.btnEditClick(Sender: TObject);
var
  Res : SmallInt;
  TempObject : TOutput;
  OldCursor : TCursor;
begin
  if not Showing then
  begin
    Showing := True;
    Timer1.Enabled := False;
    OldCursor := Screen.Cursor;
    Screen.Cursor := crHourGlass;
    if Assigned(lvElerts.Selected) then
    begin
      CurrentCaption := lvElerts.Selected.Caption;
      ThisElert.UserID := cbUser.Text;
      Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
      if Res = 0 then
//      with TfrmElWizard.Create(nil) do
      with frmElWizard do
      begin
        Image1.Visible := not NoXLogo;
        TempObject := TOutput.Create;
        UserID := cbUser.Text;
        Elert := ThisElert;
        Toolkit := FToolkit;
        IsEdit := True;
        LoadForm;
        ShowModal;
        if ModalResult = mrCancel then
          ThisElert.Cancel
        else
        if ModalResult = mrOK then
        begin
          CurrentCaption := ThisElert.ElertName;
          if chkMarkExisting.Checked then
            MarkExistingRecs(rgAcType.ItemIndex = 0);
        end;

        FillList;
        TempObject.Free;
      end
      else
      begin
        if Res in [84, 85] then
          ShowMessage('This record is locked by another workstation')
        else
          ShowMessage('Database error ' + IntToStr(Res));
      end;
    end;
    Showing := False;
    Screen.Cursor := OldCursor;
    Timer1.Enabled := True;
  end;
end;

procedure TfrmELManager.lvElertsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  if Assigned(Item) then
  begin
    InfoTip := Item.SubItems[Item.SubItems.Count - 1];
    if Trim(InfoTip) = '' then
      InfoTip := Item.Caption;
  end;
end;

procedure TfrmELManager.btnDeleteClick(Sender: TObject);
var
  Res : SmallInt;
  TempObject : TOutput;
  TempIndex : Integer;
begin
  if Assigned(lvElerts.Selected) then
  begin
    if MsgBox('Are you sure you want to delete this Sentinel ?'
    ,mtConfirmation,[mbYes,mbNo],mbNo,'Delete Sentinel') = mrYes then begin

      tempIndex := lvElerts.Selected.Index;
      ThisElert.UserID := cbUser.Text;
      Res := ThisElert.GetEqual(lvElerts.Selected.Caption);
      if Res = 0 then
      begin
        TempObject := TOutput.Create; //Opens line file
        ThisElert.Delete;
        TempObject.Free;
        FillList;
        if tempIndex >= lvElerts.Items.Count then
          tempIndex := lvElerts.Items.Count - 1;
        lvElerts.Selected := lvElerts.Items[TempIndex];
      end
      else
        ShowMessage('Can''t find record for ' + lvElerts.Selected.Caption);
    end;{if}
  end;{if}
end;

procedure TfrmELManager.cbUserChange(Sender: TObject);
begin
  FillList;
end;

procedure TfrmELManager.btnCopyClick(Sender: TObject);
var
  Res, i : SmallInt;
  NewName, OldName, sq : ShortString;
  NewUser : ShortString;
  TempObject : TOutput;
begin
  if CheckNoOfSentinels then
    if Assigned(lvElerts.Selected) then
    begin
      OldName := lvElerts.Selected.Caption;
      i := 1;
      ThisElert.UserID := cbUser.Text;
      Res := ThisElert.GetEqual(OldName);
      if Res = 0 then
      begin
        TempObject := TOutput.Create;
        NewUser := ThisElert.UserID; //until we decide otherwise
        while Res = 0 do
        begin
          sq := '(' + IntToStr(i) + ')';
          NewName := Copy(OldName, 1, 30 - Length(sq)) + sq;
          Res := ThisElert.GetEqual(NewName);
          inc(i);
        end;
        ThisElert.ElertName := OldName;
        ThisElert.GetEqual(OldName);
        ThisElert.Copy(NewName, NewUser);
        TempObject.Free;
        FillList;
      end;
    end;
end;

procedure TfrmELManager.FormDblClick(Sender: TObject);
var
  TempObject : TOutput;
begin
{  if ClientHeight < 400 then
  begin
    Panel1.Align := alNone;
    TempObject := TOutput.Create;
    ClientHeight := 459;

    Memo1.Lines.Clear;
    ThisElert.ShowRecs(Memo1.Lines);
    TempObject.Free;
  end
  else
  begin
    ClientHeight := 312;
    Panel1.Align := alBottom;           
  end;}
  if AllowDebugInfo then
  with TfrmLineDebug.Create(Self) do
  Try
    TempObject := TOutput.Create;
    ThisElert.ShowRecs(Memo1.Lines);
    ShowModal;
  Finally
    TempObject.Free;
    Free;
  End;
end;

procedure TfrmELManager.lvElertsDblClick(Sender: TObject);
begin
  btnEditClick(Self);
end;

procedure TfrmELManager.btnRunNowClick(Sender: TObject);
var
  Res : SmallInt;
begin
  //Change this so it doesn't run the query but gives it to the engine to run

{  if Assigned(lvElerts.Selected) then
  with TSentinelQuery.Create do
  begin
    Try
      ElertName := lvElerts.Selected.Caption;
      User := cbUser.Text;
      DirectMode := True;
      Run;
      ShowMessage(QuotedStr(ElertName) + ' completed');
    Finally
      Free;
    End;
  end;}
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      ThisElert.RunNow := True;
      ThisElert.Save;
      FillList;
      ShowMessage('Sentinel sent to query engine');
    end
    else
    begin
      ThisElert.Cancel;
      if Res in [84, 85] then
        ShowMessage('This record is locked by another workstation')
      else
        ShowMessage('Unable to run this Sentinel at the moment'#10#10 +
                    'Return code: ' + IntToStr(Res));
    end;

  end;

end;

procedure TfrmELManager.btnTestClick(Sender: TObject);
var
  s : ShortString;
  Proceed : Boolean;
  Res : SmallInt;
  IsCust : Boolean;
begin
  ResetCloseFlags;
  s := '';
  Proceed := True;
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      if ThisElert.ElertType = etEvent then
      begin
        with TfrmEventKey.Create(Self) do
        Try
          Label1.Caption := 'Please enter the ' + EventKeyType(ThisElert.WindowID) +
                             ' code for the record you want to test this Sentinel on';
          ActiveControl := edtKey;
          if ThisElert.WindowID = AccWindow then
            rgCustSupp.Enabled := True;
          ShowModal;
          if ModalResult = mrOk then
          begin
            s := Trim(edtKey.Text);
            IsCust := rgCustSupp.ItemIndex = 0;
            ThisElert.FileNumber := EventFileNo(ThisElert.WindowID, IsCust);
            ThisElert.Save;
          end
          else
          begin
            Proceed := False;
            ThisElert.Cancel;
          end;
        Finally
          Free;
        End;
      end;
{      else
        ThisElert.Cancel;}

     if Proceed then
      with TSentinelQuery.Create do
      begin
        Try
          ElertName := lvElerts.Selected.Caption;

          //PR: 21/08/2017 ABSEXCH-15487 Moved next line from below as we
          //need to set data path before setting user so can check user permissions
          DataPath := SetDrive;
          User := cbUser.Text;
          DirectMode := True;
          EventKeyString := s;
          Run(True); //test mode
        Finally
          Free;
        End;
      end;
    end;//if res = 0
  end; //if assigned

end;

procedure TfrmELManager.lvElertsSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  WorkStation : TElertWorkStationSetup;
  Res : SmallInt;
begin
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption);
    if Res = 0 then
    begin
      btnRunNow.Enabled := ThisElert.ElertType = etTimer;
      btnTest.Enabled := not ThisElert.ActionReport;
    end
    else
      btnRunNow.Enabled := False;
  end;

end;

procedure TfrmELManager.Active1Click(Sender: TObject);
var
  Res : SmallInt;
begin
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      ThisElert.Active := not ThisElert.Active;
      Active1.Checked := ThisElert.Active;
      ThisElert.Save;
      FillList;
    end
    else
      if Res in [84, 85] then
        showMessage('Record is locked by another workstation');
    
  end;
end;

procedure TfrmELManager.PopupMenu1Popup(Sender: TObject);
begin
  Active1.Checked := ThisElert.Active;
end;

procedure TfrmELManager.Status1Click(Sender: TObject);
var
  Res : SmallInt;
begin
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      with TfrmStatus.Create(nil) do
      Try
        RadioGroup1.ItemIndex := Ord(ThisElert.Status);
        ShowModal;
        if ModalResult = mrOK then
        begin
          ThisElert.Status := TElertStatus(RadioGroup1.ItemIndex);
          ThisElert.Save;
          FillList;
        end
        else
          ThisElert.Cancel;
      Finally
        Free;
      End;
    end
    else
      if Res in [84, 85] then
        showMessage('Record is locked by another workstation');
    
  end;

end;

procedure TfrmELManager.lvElertsColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  SortIndex := Column.Tag;
  lvElerts.AlphaSort;
  SortDirections[SortIndex] := - SortDirections[SortIndex];
end;

procedure TfrmELManager.lvElertsCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);

  function CompareDt(const s1, s2 : string) : integer;
  var
    T1, T2 : TDateTime;
  begin
    if s1 = 'N/A' then
      T1 := 0
    else
      T1 := StrToDateTime(s1);

    if s2 = 'N/A' then
      T2 := 0
    else
      T2 := StrToDateTime(s2);

    if T1 = T2 then
      Result := 0
    else
    if T1 < T2 then
      Result := -1
    else
      Result := 1;
  end;

begin
  Case SortIndex of
    0     : Compare := AnsiCompareText(Item1.Caption, Item2.Caption);
    1, 4, 5, 6  : Compare := AnsiCompareText(Item1.SubItems[SortIndex - 1],
                                  Item2.SubItems[SortIndex - 1]);
    2, 3  : Compare := CompareDt(Item1.SubItems[SortIndex - 1],
                                  Item2.SubItems[SortIndex - 1]);
  end; //case

  Compare := Compare * SortDirections[SortIndex];
end;

function TfrmELManager.AuthorizedUser(const ID, Pass : ShortString) : SmallInt;
var
  Res : Smallint;
begin
  Result := 0;
  with FToolkit do
  begin
    Configuration.DataDirectory := SetDrive;
    Result := OpenToolkit;
    if Result = 0 then
    begin
      Result := Functions.entCheckPassword(ID, Pass);
      CloseToolkit;
    end;
  end;
end;

procedure TfrmELManager.StartLogIn;
var
  lGotPassWord: Boolean;
  lLoginFrm: TfrmLogin;
begin
  lGotPassWord := False;
  lLoginFrm := TfrmLogin.Create(Application);
  try
    with lLoginFrm do
    begin
      LoginDialog := ldSentimail;
      InitDefaults; //Init Defaults values
      ShowModal;
      lGotPassWord := ModalResult = mrOK;
      if lGotPassWord then
        FormUserID := LoggedInUserName;

    end; {with lLoginFrm do}
  finally
    FreeAndNil(lLoginFrm);
  end;
  if not lGotPassword then  {* Force abort..}
    Halt;
end;

procedure TfrmELManager.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}

begin
  with Message.MinMaxInfo^ do begin
    ptMinTrackSize.X := 247;
    ptMinTrackSize.Y := 260 + (Ord(pnlUser.visible) * pnlUser.Height);
  end;{with}
  Message.Result := 0;
  inherited;
end;

function TfrmELManager.EventKeyType(winId : longint) : String;
begin
  Case winID of
    AccWindow     : Result := 'Account';
    TransWindow   : Result := 'Transaction';
    StockWindow   : Result := 'Stock';
    JobWindow     : Result := 'Job';
  end;
end;

function TfrmELManager.EventFileNo(WinID : longint; IsCust : Boolean) : SmallInt;
begin
  Case WinID of
    AccWindow     :  if IsCust then
                       Result := 1
                     else
                       Result := 2;
    TransWindow   :  Result := 3;
    StockWindow   :  Result := 6;
    JobWindow     :  Result := 22;
    else
      Result := 0;
  end;
end;



procedure TfrmELManager.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FillList;
  Timer1.Enabled := True;
end;

procedure TfrmELManager.Purge1Click(Sender: TObject);
var
  Res : SmallInt;
  TempOutput : TOutput;
  PurgeOpts : Byte;
  StartTime : Cardinal;
begin
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      Res := MessageBox(Self.Handle,
                   'This will delete temporary records associated with this Sentinel'#10#10 +
                                      'Do you wish to continue?',
                   'Confirm purge',
                   MB_YESNO or MB_ICONWARNING);
      if Res = ID_YES then
      begin
        PurgeOpts := GetPurgeOpts;
        if PurgeOpts <> 0 then
        begin
          TempOutput := TOutput.Create;
          Try
            StartTime := GetTickCount;
            ThisElert.Purge(PurgeOpts);
            ThisElert.ClearRetryFlags;
            ThisElert.Status := esIdle;
            ThisElert.CSVFileRenamed := False;

            ShowMessage('Temporary records deleted');
          Finally
            TempOutput.Free;
          End;
        end;
      end;
      ThisElert.Save;
      FillList;
    end
    else
      ShowStatus(Res);
  end;
end;

procedure TfrmELManager.PurgeAll1Click(Sender: TObject);
var
  Res, i : SmallInt;
  TempOutput : TOutput;
  NotAll : Boolean;
  RetryCount : Byte;
  s : AnsiString;
  PurgeOpts : Byte;
begin
  s := 'This will delete temporary records associated with all Sentinels for ' +
          cbUser.Text + #10#10 +
                        'Do you wish to continue?';

  NotAll := False;
  Res := MessageBox(Self.Handle, PChar(s), 'Confirm purge', MB_YESNO or MB_ICONWARNING);
  if Res = ID_YES then
  begin
    PurgeOpts := GetPurgeOpts;
    if PurgeOpts <> 0 then
    begin
      ShowMessage('Please ensure that no Sentimail engines are currently running before continuing');
      Screen.Cursor := crHourGlass;
      TempOutput := TOutput.Create;
      Try
        for i := 0 to lvElerts.Items.Count - 1 do
        begin
          RetryCount := 0;
          if Assigned(lvElerts.Items[i]) then
          begin
            CurrentCaption := lvElerts.Items[i].Caption;
            ThisElert.UserID := cbUser.Text;
            Res := 84;
            while (Res in [84, 85]) and (RetryCount < 11) do
            begin
              Res := ThisElert.GetEqual(CurrentCaption,True);
              inc(RetryCount);
              Wait(100);
            end;
            if Res = 0 then
            begin
              ThisElert.Purge(PurgeOpts);
              ThisElert.ClearRetryFlags;
              ThisElert.Status := esIdle;
              ThisElert.Save;
            end
            else
              NotAll := True;
          end; //
        end; //for i
      Finally
        FillList;
        TempOutput.Free;
        Screen.Cursor := crDefault;
        if notAll then
          ShowMessage('It was not possible to purge all the Sentinels as one or'#10 +
                      'more were locked by other workstations')
        else
          ShowMessage('Purge complete');
      End;
    end; //if PurgeOpts <> 0
  end;
end;

procedure TfrmELManager.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F5 then
    FillList;
end;

procedure TfrmELManager.RetrySend1Click(Sender: TObject);
var
  Res : SmallInt;
begin
  if Assigned(lvElerts.Selected) then
  begin
    CurrentCaption := lvElerts.Selected.Caption;
    ThisElert.UserID := cbUser.Text;
    Res := ThisElert.GetEqual(lvElerts.Selected.Caption,True);
    if Res = 0 then
    begin
      ThisElert.ClearRetryFlags;
      ThisElert.Save;
      FillList;
    end
    else
      ShowStatus(Res);
  end;

end;

procedure TfrmELManager.ShowStatus(Res : SmallInt);
begin
  if Res in [84, 85] then
    showMessage('Record is locked by another workstation')
  else
    ShowMessage('Database Error ' + IntToStr(Res));
end;

procedure TfrmELManager.LoadPositions;
begin
  with TElertWorkstationSetup.Create do
  begin
    if MWidth > 0 then
    begin
      Left := MLeft;
      Top := MTop;
      Width := MWidth;
      Height := MHeight;

      with lvElerts.Columns do
      begin
        if MCol0 > 0 then
          Items[0].Width := MCol0;
        if MCol1 > 0 then
          Items[1].Width := MCol1;
        if MCol2 > 0 then
          Items[2].Width := MCol2;
        if MCol3 > 0 then
          Items[3].Width := MCol3;
        if MCol4 > 0 then
          Items[4].Width := MCol4;
        if MCol5 > 0 then
          Items[5].Width := MCol5;
        if MCol6 > 0 then
          Items[6].Width := MCol6;
      end;
    end;
  end;

end;

procedure TfrmELManager.SavePositions;
begin

  with TElertWorkstationSetup.Create do
  begin
     MLeft := Left;
     MTop := Top;
     MWidth := Width;
     MHeight := Height;

    with lvElerts.Columns do
    begin
       MCol0 := Items[0].Width;
       MCol1 := Items[1].Width;
       MCol2 := Items[2].Width;
       MCol3 := Items[3].Width;
       MCol4 := Items[4].Width;
       MCol5 := Items[5].Width;
       MCol6 := Items[6].Width;
    end;

  end;

end;


procedure TfrmELManager.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SavePositions;
end;

procedure TfrmELManager.FormActivate(Sender: TObject);
begin
  if FirstTime then
  begin
    LoadPositions;
    {$IFDEF PALL}
    WriteToPalladiumLog('After LoadPositions');
    {$ENDIF}
    FirstTime := False;
  end;
end;

procedure TfrmELManager.ExportSentinels;
var
  Res : Smallint;
begin
  with TElertExporter.Create do
  Try
    SaveDlg := SaveDialog1;
    User := cbUser.Text;
    FileName := SaveDialog1.Filename;
    Res := Execute;
    if Res = 0 then
      ShowMessage('Export complete')
    else
    if Res = ieCancelled then
      ShowMessage('Export cancelled')
    else
      ShowMessage(ErrorMessage(Res));
  Finally
    Free;
  End;
end;

procedure TfrmELManager.ImportSentinels;
var
  Res : SmallInt;
begin
  if OpenDialog1.Execute then
  begin
    oToolkit := FToolkit;
    with TElertImporter.Create do
    Try
      User := cbUser.Text;
      FileName := OpenDialog1.Filename;
      Res := Execute;
      FillList;
      if Res = 0 then
        ShowMessage('Import complete')
      else
        if Res <> ieCancelled then
          ShowMessage(ErrorMessage(Res));
    Finally
      Free;
      oToolkit := nil;
    End;
  end;
end;


procedure TfrmELManager.Export1Click(Sender: TObject);
begin
  ExportSentinels;
end;

procedure TfrmELManager.Import1Click(Sender: TObject);
begin
  ImportSentinels;
end;

function TfrmELManager.CompanyName : String;
var
  i : integer;
begin
  Result := '';
  if Assigned(FToolkit) then
  begin
    with FToolkit do
    begin
      for i := 1 to Company.cmCount do
      begin
        if UpperCase(Trim(SetDrive)) = UpperCase(Trim(Company.cmCompany[i].coPath)) then
        begin
          Result := Company.cmCompany[i].coName;
          Break;
        end;
      end;
    end;
  end;
end;

function TfrmELManager.CheckSysPassword(const s : string) : SmallInt;
begin
   if Trim(s) = Trim(Get_TodaySecurity) then
     Result := 0
   else
     Result := 30002;
end;


procedure TfrmELManager.About1Click(Sender: TObject);
begin
  oToolkit := FToolkit;
  with TfrmAbout.Create(nil) do
  Try
    lblTitle.Caption := 'Sentimail';
    lblVersion.Caption := 'Version: ' + ElVersion;
    ShowModal;
  Finally
    oToolkit := nil;
    Free;
  end;

end;

(* PR 23/10/2008 Changed engine notification mechanism to avoid SQL Emulator locking problem (Pivotal 33441)

procedure TfrmELManager.CheckEngines;
var
  i : integer;
  CanRun : Boolean;
  Res : SmallInt;
begin
  FillChar(EnginesRunning, SizeOf(EnginesRunning), #0);
  with SysRec do
  begin
    UserID := 'ZZZZZZZZZZ';
    ElertName := 'System';
    for i := 1 to MaxEngines do
    begin
      OutputType := TOutputLineType(i + Ord(Pred(eolSysEmail)));
      Res := GetEqual('', True);
      CanRun := Res in [78, 84, 85];
      if CanRun then
      begin
        Res := GetEqual('');
        if Res = 0 then
        begin
          if EngineCounter <> PrevEngineCount[i] then
            PrevEngineCount[i] := EngineCounter
          else
          begin
            inc(EngineMissCount[i]);
            if EngineMissCount[i] > MaxEngineMisses then
            begin
              CanRun := False;
              EngineMissCount[i] := 0;
            end;
          end;
        end;
      end;

      Case i of
        1  :  EnginesRunning.Email := CanRun;
        2  :  EnginesRunning.SMS := CanRun;
        3  :  EnginesRunning.Fax := CanRun;
        4  :  EnginesRunning.FTP := CanRun;
        5  :  EnginesRunning.Alerts := CanRun;
        6  :  EnginesRunning.Reports := CanRun;
        7  :  EnginesRunning.HighPriority := CanRun;
        8  :  EnginesRunning.LowPriority := CanRun;
      end;
{      if Res = 0 then
        Cancel;}
    end;
  end;
end; *)

procedure TfrmELManager.CheckEngines;
//PR 23/10/2008 Change. The engine will now put a timestamp into the records in SentSys.dat. If the timestamp is within elEngineTimeStampMinutes
//of now then we treat the engine as running.
var
  i : integer;
  CanRun : Boolean;
  Res : SmallInt;
begin
  FillChar(EnginesRunning, SizeOf(EnginesRunning), #0);
  with SysRec do
  begin
    UserID := 'ZZZZZZZZZZ';
    ElertName := 'System';
    for i := 1 to MaxEngines do
    begin
      CanRun := False;
      OutputType := TOutputLineType(i + Ord(Pred(eolSysEmail)));
      begin
        Res := GetEqual('');
        if Res = 0 then
          CanRun := Abs(MinutesBetween(TimeStamp, Now)) <= elEngineTimeStampMinutes;
      end;

      Case i of
        1  :  EnginesRunning.Email := CanRun;
        2  :  EnginesRunning.SMS := CanRun;
        3  :  EnginesRunning.Fax := CanRun;
        4  :  EnginesRunning.FTP := CanRun;
        5  :  EnginesRunning.Alerts := CanRun;
        6  :  EnginesRunning.Reports := CanRun;
        7  :  EnginesRunning.HighPriority := CanRun;
        8  :  EnginesRunning.LowPriority := CanRun;
      end; //Case
    end; //for i
  end;
end;


function TfrmELManager.CheckNoOfSentinels : Boolean;
begin
  Result := True;
{
  oToolkit := FToolkit;
  Result := NoOfUnusedSentinels > 0;
  if not Result then
    ShowNoSentinelsLeftMessage;
  oToolkit := nil;}
end;

function TfrmELManager.ThisElertCanRun : boolean;
begin
end;

procedure TfrmELManager.EnginesRunning1Click(Sender: TObject);
begin
  CheckEngines;
  ShowEnginesRunning(EnginesRunning);
end;

procedure TfrmELManager.Purgesystemevents1Click(Sender: TObject);
var
  Res : SmallInt;
  ThisEvent : TEvent;
  OneFail : Boolean;
begin
  Res := MessageBox(Self.Handle,
           'This will delete all System Event records. '#10#10 +
                                      'Do you wish to continue?',
                   'Confirm purge',
                   MB_YESNO or MB_ICONWARNING);
  if Res = ID_YES then
  begin

    ThisEvent := TEvent.Create;
    Try
      ThisEvent.UserID := SysUser;
      ThisEvent.ElertName := SysElertName;

      Res := ThisEvent.GetFirst;

      while Res = 0 do
      begin
        Res := ThisEvent.Delete;

        if Res = 0 then
          Res := ThisEvent.GetFirst;
      end;

      if Res in [84, 85] then
        ShowMessage('It was not possible to delete all the Events as one or'#10 +
                    'more were locked by other workstations')
      else
        ShowMessage('All System Events deleted');
    Finally
      ThisEvent.Free;
    End;

  end;


end;

function TfrmELManager.CheckSentimailSecurity(const UserName : Shortstring) : Boolean;
var
  V : Variant;
  SecResult : Integer;
  a, b, c : longint;
begin
  Result := False;
  if Assigned(FToolkit) then
  with FToolkit do
  begin
    OpenToolkit;
    Try
      EncodeOpCode(64, a, b, c);
      V := Configuration.SetDebugMode(a, b, c);
      if VarType(V) <> varEmpty then
      begin
        if V.CheckSecurity(UserName, 405, SecResult) = 0 then
          Result := SecResult <> 0;
      end;
    Finally
      V := Unassigned;
      CloseToolkit;
    End;
  end;
end;

procedure TfrmELManager.ApplicationActive(Sender : TObject);
begin
  Application.Title := Caption;
end;

procedure TfrmELManager.EntDeActivate(Sender : TObject);
begin
  Application.Title := CompanyName + ' - Sentimail Sentinel Manager';
end;

procedure TfrmELManager.MarkExistingRecs(IsCust : Boolean);
var
  REs : SmallInt;
begin
  with TfrmAddRecs.Create(nil) do
  Try
    EName := ThisElert.ElertName;
    UID := cbUser.Text;
    DPath := SetDrive;
    ThisElert.FileNumber := EventFileNo(ThisElert.WindowID, IsCust);
    Res := ThisElert.Save;
    if Res = 0 then
      ShowModal;
  Finally
    Free;
  End;
end;

procedure TfrmELManager.FormResize(Sender: TObject);
begin
  //RB 31/05/2017 2017-R2 ABSEXCH-13457: Screen resolution on Sentimail Manager hides the buttons where screen set to medium 125% resolution
  //And for some reason close button's top margin was changing drastically hence it was not visible on screen, so now close button will stay at bottom.
  lvElerts.Width := Panel1.ClientWidth - 10;
  btnClose.Top := pnlButtonBackground.Height - btnClose.Height - 5;
  
  //PR: 16/05/2013 ABSEXCH-13897 Extend for versions later than XP
  if GetWindowsVersion in wvXPStyle then
    lvElerts.Height := Panel1.ClientHeight - 12
  else
    lvElerts.Height := Panel1.ClientHeight - 2;

end;

end.
