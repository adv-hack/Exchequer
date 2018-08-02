unit uWRModules;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompCheckbox, IWCompText,
  IWCompButton, IWCompLabel, Classes, Controls, IWControl, IWCompEdit;

type
  TfrmModules = class(TIWAppForm)
    edModuleName: TIWEdit;
    lblModuleName: TIWLabel;
    bnSaveChanges: TIWButton;
    lblhdrModules: TIWLabel;
    txtModules: TIWText;
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    cbPlugIn: TIWCheckBox;
    cbUserCount: TIWCheckBox;
    edPlugCode: TIWEdit;
    txtPlugIns: TIWText;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnSaveChangesClick(Sender: TObject);
    procedure cbPlugInClick(Sender: TObject);
  private
    procedure DoAdminLog(ModuleID: integer);
    procedure InsertThresholdRecs(ModuleID: integer);
  end;

implementation

{$R *.dfm}

uses uWRServer, uWRData, uWRSite, uWRAdmin, SysUtils;

//*** Main *********************************************************************

procedure TfrmModules.bnSaveChangesClick(Sender: TObject);
var
MaxID: integer;
begin
  {Ensure a name has been provided; If the module is a plug-in, ensure a 16-
   character plug-in code has been provided;}

  if Trim(edModuleName.Text) = '' then
  begin
    if cbPlugIn.Checked then WebApplication.ShowMessage('Please specify a name for the new plug-in.')
    else WebApplication.ShowMessage('Please specify a name for the new module.');
    Exit;
  end;

  if cbPlugIn.Checked and (Length(edPlugCode.Text) <> 16) then
  begin
    WebApplication.ShowMessage('The Plug-In code must be 16 characters in length.');
    Exit;
  end;


  {Obtain the next ModuleID and insert a new module record for that ID; Log the
   changes and display a success message;}

  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select max(moduleid) from modules ');
    Open;
    MaxID:= Fields[0].AsInteger;

    Close;
    Sql.Clear;
    Sql.Add('insert into modules (moduleid, modulename, plugin, plugcode, usercount) ');
    Sql.Add('values (:pmoduleid, :pmodulename, :pplugin, :pplugcode, :pusercount) ');
    ParamByName('pmoduleid').AsInteger:= MaxID + 1;
    ParamByName('pmodulename').AsString:= Copy(Trim(edModuleName.Text), 1, 30);
    ParamByName('pplugin').AsBoolean:= cbPlugIn.Checked;
    if cbPlugIn.Checked then ParamByName('pplugcode').AsString:= UpperCase(edPlugCode.Text)
    else ParamByName('pplugcode').AsString:= '';
    ParamByName('pusercount').AsBoolean:= cbUserCount.Checked;
    ExecSql;

    InsertThresholdRecs(MaxID + 1);
    DoAdminLog(MaxID + 1);

    if cbPlugIn.Checked then WebApplication.ShowMessage('The plug-in ' + Copy(Trim(edModuleName.Text), 1, 30) + ' has been added successfully.')
    else WebApplication.ShowMessage('The module ' + Copy(Trim(edModuleName.Text), 1, 30) + ' has been added successfully.' + #13#10#13#10 + 'A global threshold has been automatically added for the new module preventing any release codes from being given out.' + #13#10#13#10 + 'Please adjust this accordingly using the Thresholds utility in the Admin area.');
  end;
end;

procedure TfrmModules.InsertThresholdRecs(ModuleID: integer);
begin
  {Inserts a threshold record for the module or plug-in and an additional record
   if user-count enabled; These records are locked down (threshold is set to 0)
   to prevent any release codes for this module from being given out until the
   threshold is updated;}

  with WRData.qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('insert into thresholds (custid, codeid, threshold, period, moduleid) ');
    Sql.Add('values (0, :pcodeid, 0, 30, :pmoduleid) ');
    ParamByName('pmoduleid').AsInteger:= ModuleID;
    if cbPlugIn.Checked then ParamByName('pcodeid').AsInteger:= 10
    else ParamByName('pcodeid').AsInteger:= 8;
    ExecSql;

    if cbUserCount.Checked then
    begin
      if cbPlugIn.Checked then ParamByName('pcodeid').AsInteger:= 11
      else ParamByName('pcodeid').AsInteger:= 9;
      ExecSql;
    end;
  end;
end;

procedure TfrmModules.DoAdminLog(ModuleID: integer);
var
UCStr, PlugStr, CodeStr: string;
begin
  {Assemble the ChangeDesc string according to whether the new registration is
   user-count enabled, and/or a plug-in; Log to the database;}

  if cbUserCount.Checked then UCStr:= 'User-Count Enabled, ' else UCStr:= '';

  if cbPlugIn.Checked then
  begin
    PlugStr:= 'Plug-In';
    CodeStr:= 'Code:' + edPlugCode.Text;
  end
  else
  begin
    PlugStr:= 'Module';
    CodeStr:= '';
  end;

  UserSession.AdminLog(ModuleID, itModule, 'New ' + PlugStr + ' registered - Name:' + Copy(Trim(edModuleName.Text), 1, 30) + ', ' + UCStr + CodeStr);
end;

//*** Event Handlers ***********************************************************

{Show the corresponding form for the button clicked and release the current form;}

procedure TfrmModules.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

procedure TfrmModules.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmModules.cbPlugInClick(Sender: TObject);
begin
  {If the module is a plug-in, enable the plug-in code edit box;}

  edPlugCode.ReadOnly:= not cbPlugIn.Checked;
end;

//******************************************************************************

end.