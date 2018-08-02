unit uWRThresholds;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompText, IWCompButton, uWRedCustomers,
  IWCompListbox, Classes, Controls, IWControl, IWCompLabel, IWGrids,
  IWCompEdit;

type
  ThreshRec = record
    CodeID: integer;
    ModuleID: integer;
    Threshold: integer;
    Period: integer;
  end;

  TfrmThresholds = class(TIWAppForm)
    lblhdrThresholds: TIWLabel;
    bnNew: TIWButton;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    bnSave: TIWButton;
    txtThreshold: TIWText;
    gdThresholds: TIWGrid;
    bnReturnCust: TIWButton;
    lblThreshold: TIWLabel;
    lblReleaseCodes: TIWLabel;
    cbRelCode: TIWComboBox;
    edThreshold: TIWEdit;
    lblPeriod: TIWLabel;
    edPeriod: TIWEdit;
    bnDelete: TIWButton;
    lblhdrCurrent: TIWLabel;
    lblCurrent: TIWLabel;
    lblNoThresholds: TIWLabel;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
    procedure bnReturnCustClick(Sender: TObject);
    procedure gdThresholdsCellClick(const ARow, AColumn: Integer);
    procedure bnDeleteClick(Sender: TObject);
    procedure bnSaveClick(Sender: TObject);
    procedure bnNewClick(Sender: TObject);
  private
    fThresholds: array of ThreshRec;
    fCurrentRec: integer;
    fCustID: integer;
    frmedCustomers: TfrmedCustomers;
    procedure AddThreshold(NewCodeID: integer; NewModuleID: integer; NewThreshold: integer; NewPeriod: integer);
    procedure LoadThresholds;
    function GetCodeID: integer;
    function GetCustName: string;
    function GetModuleID(CodeID: integer): integer;
    function isValidThreshold(CodeID: integer; ModuleID: integer): string;
  public
    procedure InitThresholds(CustomerID: integer; CustForm: TfrmedCustomers);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRAdmin, uWRSite, uWRData, Graphics, SysUtils;

//*** Startup and Shutdown *****************************************************

procedure TfrmThresholds.IWAppFormCreate(Sender: TObject);
begin
  {Populate the release codes drop-down list;}

  fCurrentRec:= -1;
  UserSession.InitRelCodes(cbRelCode);
end;

procedure TfrmThresholds.InitThresholds(CustomerID: integer; CustForm: TfrmedCustomers);
begin
  fCustID:= CustomerID;
  frmedCustomers:= CustForm;
  LoadThresholds;
end;

//*** Main *********************************************************************

procedure TfrmThresholds.LoadThresholds;
var
RowIndex: integer;
begin
  with WRData.qyPrimary, gdThresholds, TStringlist.Create do
  try

    fThresholds:= nil;
    lblCurrent.Caption:= 'None';
    cbRelCode.ItemIndex:= -1;
    edThreshold.Text:= '';
    edPeriod.Text:= '';
    gdThresholds.Clear;
    RowCount:= 1;

    Close;
    Sql.Clear;
    Sql.Add('select a.custid as custid, a.codeid as codeid, a.threshold as threshold, ');
    Sql.Add('a.period as period, b.codedesc as codedesc ');
    Sql.Add('from thresholds a inner join codetypes b on a.codeid = b.codeid ');
    Sql.Add('where a.codeid not in (8, 9, 10, 11) ');
    Sql.Add('and a.custid in (0, :pcustid) ');
    Sql.Add('order by a.custid desc, b.codedesc ');
    ParamByName('pcustid').AsInteger:= fCustID;
    Open;

    RowIndex:= 0;
    Cell[RowIndex, 0].Text:= 'Scope';
    Cell[RowIndex, 1].Text:= 'Password / Release Code';
    Cell[RowIndex, 2].Text:= 'Threshold';
    Cell[RowIndex, 0].Font.Style:= Cell[RowIndex, 0].Font.Style + [fsBold];
    Cell[RowIndex, 1].Font.Style:= Cell[RowIndex, 1].Font.Style + [fsBold];
    Cell[RowIndex, 2].Font.Style:= Cell[RowIndex, 2].Font.Style + [fsBold];
    AddThreshold(-1, -1, -1, -1);

    while not eof do
    begin
      AddThreshold(FieldByName('CodeID').AsInteger, -1, FieldByName('Threshold').AsInteger, FieldByName('Period').AsInteger);
      RowCount:= RowCount + 1;
      inc(RowIndex);

      if FieldByName('CustID').AsInteger <> 0 then
      begin
        Add(FieldByName('CodeID').AsString);
        Cell[RowIndex, 0].Text:= 'Local';
        Cell[RowIndex, 1].Text:= FieldByName('CodeDesc').AsString;
        Cell[RowIndex, 2].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Cell[RowIndex, 1].Clickable:= true;
      end
      else if IndexOf(FieldByName('CodeID').AsString) < 0 then
      begin
        Cell[RowIndex, 0].Text:= 'Global';
        Cell[RowIndex, 1].Text:= FieldByName('CodeDesc').AsString;
        Cell[RowIndex, 2].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Cell[RowIndex, 1].Clickable:= true;
      end;

      Next;
    end;

    Close;
    Sql.Clear;
    Sql.Add('select a.custid as custid, a.threshold as threshold, a.period as period, ');
    Sql.Add('a.codeid as codeid, a.moduleid as moduleid, ');
    Sql.Add('b.modulename as modulename, b.plugin as plugin, b.usercount as usercount ');
    Sql.Add('from thresholds a inner join modules b on a.moduleid = b.moduleid ');
    Sql.Add('where a.codeid in (8, 9, 10, 11) ');
    Sql.Add('and a.custid in (0, :pcustid) ');
    Sql.Add('order by a.custid desc, b.plugin, a.codeid, b.modulename ');
    ParamByName('pcustid').AsInteger:= fCustID;
    Open;

    Clear;
    inc(RowIndex);
    RowCount:= RowCount + 1;
    Cell[RowIndex, 0].Text:= ' ';
    Cell[RowIndex, 1].Text:= ' ';
    Cell[RowIndex, 2].Text:= ' ';
    AddThreshold(-1, -1, -1, -1);

    inc(RowIndex);
    RowCount:= RowCount + 1;
    Cell[RowIndex, 0].Text:= 'Scope';
    Cell[RowIndex, 1].Text:= 'Module / Plug-In Release Code';
    Cell[RowIndex, 2].Text:= 'Threshold';
    Cell[RowIndex, 0].Font.Style:= Cell[RowIndex, 0].Font.Style + [fsBold];
    Cell[RowIndex, 1].Font.Style:= Cell[RowIndex, 1].Font.Style + [fsBold];
    Cell[RowIndex, 2].Font.Style:= Cell[RowIndex, 2].Font.Style + [fsBold];
    AddThreshold(-1, -1, -1, -1);

    while not eof do
    begin
      AddThreshold(FieldByName('CodeID').AsInteger, FieldByName('ModuleID').AsInteger, FieldByName('Threshold').AsInteger, FieldByName('Period').AsInteger);
      RowCount:= RowCount + 1;
      inc(RowIndex);

      if FieldByName('CustID').AsInteger <> 0 then
      begin
        Add(FieldByName('CodeID').AsString + ',' + FieldByName('ModuleID').AsString);
        Cell[RowIndex, 0].Text:= 'Local';

        case FieldByName('CodeID').AsInteger of
          8: Cell[RowIndex, 1].Text:= 'Module - ' + FieldByName('ModuleName').AsString;
          9: Cell[RowIndex, 1].Text:= 'Module - User Count - ' + FieldByName('ModuleName').AsString;
          10: Cell[RowIndex, 1].Text:= 'Plug-In - ' + FieldByName('ModuleName').AsString;
          11: Cell[RowIndex, 1].Text:= 'Plug-In - User Count - ' + FieldByName('ModuleName').AsString;
        end;

        Cell[RowIndex, 2].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Cell[RowIndex, 1].Clickable:= true;
      end
      else if IndexOf(FieldByName('CodeID').AsString + ',' + FieldByName('ModuleID').AsString) < 0 then
      begin
        Cell[RowIndex, 0].Text:= 'Global';

        case FieldByName('CodeID').AsInteger of
          8: Cell[RowIndex, 1].Text:= 'Module - ' + FieldByName('ModuleName').AsString;
          9: Cell[RowIndex, 1].Text:= 'Module - User Count - ' + FieldByName('ModuleName').AsString;
          10: Cell[RowIndex, 1].Text:= 'Plug-In - ' + FieldByName('ModuleName').AsString;
          11: Cell[RowIndex, 1].Text:= 'Plug-In - User Count - ' + FieldByName('ModuleName').AsString;
        end;

        Cell[RowIndex, 2].Text:= FieldByName('Threshold').AsString + ' every ' + FieldByName('Period').AsString + ' days';
        Cell[RowIndex, 1].Clickable:= true;
      end;

      Next;
    end;

    Visible:= RowCount > 1;
    lblNoThresholds.Visible:= RowCount <= 1;

  finally
    Free;
  end;
end;

procedure TfrmThresholds.bnDeleteClick(Sender: TObject);
begin
  if fCurrentRec < 0 then WebApplication.ShowMessage('Please select a threshold to delete by clicking the threshold in the grid below.')
  else if (fCustID > 0) and (gdThresholds.Cell[fCurrentRec, 0].Text = 'Global') then WebApplication.ShowMessage('Global thresholds cannot be deleted when editing a customer. Please use the Thresholds utility from the main Admin area.')
  else with WRData.qyPrimary, fThresholds[fCurrentRec] do
  begin
    Close;
    Sql.Clear;
    Sql.Add('delete from thresholds ');
    Sql.Add('where codeid = :pcodeid ');

    {Drop a global will drop all locals for that code also;}

    if gdThresholds.Cell[fCurrentRec, 0].Text = 'Local' then
    begin
      Sql.Add('and custid = :pcustid ');
      ParamByName('pcustid').AsInteger:= fCustID;
    end;

    if ModuleID > 0 then
    begin
      Sql.Add('and moduleid = :pmoduleid ');
      ParamByName('pmoduleid').AsInteger:= ModuleID;
    end;

    ParamByName('pcodeid').AsInteger:= CodeID;
    ExecSql;

    if gdThresholds.Cell[fCurrentRec, 0].Text = 'Global' then
    begin
      UserSession.AdminLog(0, itThreshold, 'Global threshold deleted, Code:' + gdThresholds.Cell[fCurrentRec, 1].Text);
      WebApplication.ShowMessage('The ' + gdThresholds.Cell[fCurrentRec, 1].Text + ' threshold and the associated customer overrides have been deleted.');
    end
    else
    begin
      UserSession.AdminLog(0, itThreshold, 'Local threshold deleted, Customer:' + GetCustName + ', Code:' + gdThresholds.Cell[fCurrentRec, 1].Text);
      WebApplication.ShowMessage('The ' + gdThresholds.Cell[fCurrentRec, 1].Text + ' threshold has been deleted for ' + GetCustName + '.');
    end;
    LoadThresholds;
  end;
end;

procedure TfrmThresholds.bnSaveClick(Sender: TObject);
begin
  if fCurrentRec < 0 then WebApplication.ShowMessage('Please select a threshold to edit by clicking the threshold in the grid below.')
  else with WRData.qyPrimary, fThresholds[fCurrentRec] do
  begin
    Close;
    Sql.Clear;

    if (gdThresholds.Cell[fCurrentRec, 0].Text = 'Global') and (fCustID > 0) then
    begin
      Sql.Add('insert into thresholds (custid, codeid, threshold, period');
      if ModuleID >= 0 then Sql.Add(', moduleid');
      Sql.Add(') values (:pcustid, :pcodeid, :pthreshold, :pperiod');
      if ModuleID >= 0 then Sql.Add(', :pmoduleid');
      Sql.Add(') ');

      ParamByName('pcustid').AsInteger:= fCustID;
      ParamByName('pcodeid').AsInteger:= CodeID;
      ParamByName('pthreshold').AsInteger:= StrToIntDef(Trim(edThreshold.Text), 0);
      ParamByName('pperiod').AsInteger:= StrToIntDef(Trim(edPeriod.Text), 1);
      if ModuleID >= 0 then ParamByName('pmoduleid').AsInteger:= ModuleID;
      ExecSql;

      UserSession.AdminLog(0, itThreshold, 'Local threshold added, Customer:' + GetCustName + ', Code:' + gdThresholds.Cell[fCurrentRec, 1].Text + ', Threshold:' + Trim(edThreshold.Text) + ', Period:' + Trim(edPeriod.Text));
      WebApplication.ShowMessage('A local ' + gdThresholds.Cell[fCurrentRec, 1].Text + ' threshold has been added for ' + GetCustName + '.');
    end
    else
    begin
      Sql.Add('update thresholds ');
      Sql.Add('set threshold = :pthreshold, period = :pperiod ');
      Sql.Add('where custid = :pcustid and codeid = :pcodeid ');
      ParamByName('pthreshold').AsInteger:= StrToIntDef(Trim(edThreshold.Text), 0);
      ParamByName('pperiod').AsInteger:= StrToIntDef(Trim(edPeriod.Text), 1);

      if ModuleID > 0 then
      begin
        Sql.Add('and moduleid = :pmoduleid ');
        ParamByName('pmoduleid').AsInteger:= ModuleID;
      end;

      if gdThresholds.Cell[fCurrentRec, 0].Text = 'Global' then ParamByName('pcustid').AsInteger:= 0
      else ParamByName('pcustid').AsInteger:= fCustID;
      ParamByName('pcodeid').AsInteger:= CodeID;
      ExecSql;

      if gdThresholds.Cell[fCurrentRec, 0].Text = 'Global' then
      begin
        UserSession.AdminLog(0, itThreshold, 'Global threshold updated, Code:' + gdThresholds.Cell[fCurrentRec, 1].Text + ', Threshold:' + Trim(edThreshold.Text) + ', Period:' + Trim(edPeriod.Text));
        WebApplication.ShowMessage('The global threshold for the ' + gdThresholds.Cell[fCurrentRec, 1].Text + ' has been updated.');
      end
      else
      begin
        UserSession.AdminLog(0, itThreshold, 'Local threshold updated, Customer:' + GetCustName + ', Code:' + gdThresholds.Cell[fCurrentRec, 1].Text + ', Threshold:' + Trim(edThreshold.Text) + ', Period:' + Trim(edPeriod.Text));
        WebApplication.ShowMessage('The local ' + gdThresholds.Cell[fCurrentRec, 1].Text + ' threshold for ' + GetCustName + ' has been updated.');
      end;
    end;

    LoadThresholds;
  end;
end;

procedure TfrmThresholds.bnNewClick(Sender: TObject);
var
CodeID, ModuleID: integer;
ValidStr: string;
begin
  {}

  with WRData.qyPrimary do
  begin
    ModuleID:= -1;
    CodeID:= GetCodeID;
    if CodeID in [8, 9, 10, 11] then ModuleID:= GetModuleID(CodeID);

    ValidStr:= isValidThreshold(CodeID, ModuleID);
    if ValidStr <> '' then
    begin
      WebApplication.ShowMessage(ValidStr);
      Exit;
    end;

    Close;
    Sql.Clear;
    Sql.Add('insert into thresholds (custid, codeid, threshold, period');
    if ModuleID >= 0 then Sql.Add(', moduleid');
    Sql.Add(') values (0, :pcodeid, :pthreshold, :pperiod');
    if ModuleID >= 0 then Sql.Add(', :pmoduleid');
    Sql.Add(') ');

    ParamByName('pcodeid').AsInteger:= CodeID;
    ParamByName('pthreshold').AsInteger:= StrToIntDef(Trim(edThreshold.Text), 0);
    ParamByName('pperiod').AsInteger:= StrToIntDef(Trim(edPeriod.Text), 1);
    if ModuleID >= 0 then ParamByName('pmoduleid').AsInteger:= ModuleID;
    ExecSql;

    UserSession.AdminLog(0, itThreshold, 'Global threshold added, Code:' + cbRelCode.Text + ', Threshold:' + Trim(edThreshold.Text) + ', Period:' + Trim(edPeriod.Text));
    WebApplication.ShowMessage('A new global ' + cbRelCode.Text + ' threshold has been added.');
    LoadThresholds;
  end;
end;

//*** Helper Functions *********************************************************

procedure TfrmThresholds.AddThreshold(NewCodeID: integer; NewModuleID: integer; NewThreshold: integer; NewPeriod: integer);
begin
  SetLength(fThresholds, Length(fThresholds) + 1);
  with fThresholds[High(fThresholds)] do
  begin
    CodeID:= NewCodeID;
    ModuleID:= NewModuleID;
    Threshold:= NewThreshold;
    Period:= NewPeriod;
  end;
end;

function TfrmThresholds.GetCodeID: integer;
begin
  {Determine the release code from the release code drop-down string;}

  Result:= 0;

  if Pos('Module - User Count - ', cbRelCode.Text) <> 0 then Result:= 9
  else if Pos('Module - ', cbRelCode.Text) <> 0 then Result:= 8
  else if Pos('Plug-In - User Count - ', cbRelCode.Text) <> 0 then Result:= 11
  else if Pos('Plug-In - ', cbRelCode.Text) <> 0 then Result:= 10
  else with WRData.qySecondary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select codeid from codetypes where codedesc = :pcodedesc ');
    ParamByName('pcodedesc').AsString:= cbRelCode.Text;
    Open;

    if not eof then Result:= FieldByName('CodeID').AsInteger;
  end;
end;

function TfrmThresholds.GetModuleID(CodeID: integer): integer;
var
ModuleName: string;
begin
  {}

  Result:= 0;

  case CodeID of
    8: ModuleName:= Copy(cbRelCode.Text, 10, Length(cbRelCode.Text));
    9: ModuleName:= Copy(cbRelCode.Text, 23, Length(cbRelCode.Text));
    10: ModuleName:= Copy(cbRelCode.Text, 11, Length(cbRelCode.Text));
    11: ModuleName:= Copy(cbRelCode.Text, 24, Length(cbRelCode.Text));
  end;

  with WRData.qySecondary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select moduleid from modules where modulename = :pmodulename ');
    ParamByName('pmodulename').AsString:= ModuleName;
    Open;

    if not eof then Result:= FieldByName('ModuleID').AsInteger;
  end;
end;

function TfrmThresholds.isValidThreshold(CodeID: integer; ModuleID: integer): string;
begin
  {}

  Result:= '';

  if StrToIntDef(edThreshold.Text, -1) = -1 then Result:= 'Please enter a valid numeric threshold.'
  else if StrToIntDef(edPeriod.Text, -1) = -1 then Result:= 'Please enter a valid numeric period.'
  else if cbRelCode.ItemIndex < 0 then Result:= 'Please select a release code from the release codes drop-down list.'
  else with WRData.qySecondary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select count(custid) from thresholds ');
    Sql.Add('where codeid = :pcodeid ');

    if ModuleID > 0 then
    begin
      Sql.Add('and moduleid = :pmoduleid ');
      ParamByName('pmoduleid').AsInteger:= ModuleID;
    end;

    ParamByName('pcodeid').AsInteger:= CodeID;
    Open;

    if Fields[0].AsInteger > 0 then Result:= 'A threshold for this release code already exists. Please edit the existing threshold or select another from the drop-down list.';
  end;
end;

function TfrmThresholds.GetCustName: string;
var
PosIndex: integer;
begin
  {}

  PosIndex:= Pos('Thresholds', lblhdrThresholds.Text);
  Result:= Copy(lblhdrThresholds.Text, 1, PosIndex - 2);
end;

//*** Event Handlers ***********************************************************

procedure TfrmThresholds.gdThresholdsCellClick(const ARow, AColumn: Integer);
begin
  if fThresholds[ARow].CodeID >= 0 then with gdThresholds, fThresholds[ARow] do
  begin
    fCurrentRec:= ARow;
    edThreshold.Text:= IntToStr(Threshold);
    edPeriod.Text:= IntToStr(Period);
    lblCurrent.Caption:= Cell[ARow, 1].Text + ' - ' + Cell[ARow, 0].Text;
  end
  else fCurrentRec:= -1;
end;

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmThresholds.bnReturnAdminClick(Sender: TObject);
begin
  if Assigned(frmedCustomers) then frmedCustomers.Release;
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmThresholds.bnReturnMainClick(Sender: TObject);
begin
  if Assigned(frmedCustomers) then frmedCustomers.Release;
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmThresholds.bnReturnCustClick(Sender: TObject);
begin
  frmedCustomers.LoadThresholds(frmedCustomers.gdThresholds);
  Release;
end;

//******************************************************************************

end.
