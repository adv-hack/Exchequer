unit uWREmail;

interface

uses
  IWAppForm, IWApplication, IWTypes, IWCompCheckbox, IWCompText,
  IWCompEdit, IWCompLabel, Classes, Controls, IWControl, IWCompButton;

type
  TfrmEmail = class(TIWAppForm)
    bnReturnAdmin: TIWButton;
    bnReturnMain: TIWButton;
    lblThresholdApplied: TIWLabel;
    edToApplied: TIWEdit;
    lblThresholdOverridden: TIWLabel;
    edToOverridden: TIWEdit;
    lblhdrEmail: TIWLabel;
    lblCodeRequests: TIWLabel;
    edToRequest: TIWEdit;
    lblCodeUnavailable: TIWLabel;
    edToUnavailable: TIWEdit;
    txtEmail: TIWText;
    cbCUActive: TIWCheckBox;
    cbTAActive: TIWCheckBox;
    cbTOActive: TIWCheckBox;
    bnSaveAll: TIWButton;
    edEmailApplied: TIWEdit;
    edEmailOverridden: TIWEdit;
    edEmailRequest: TIWEdit;
    edEmailUnavailable: TIWEdit;
    lblTo: TIWLabel;
    lblEmailAddress: TIWLabel;
    lblESNSpecified: TIWLabel;
    edToESNSpecified: TIWEdit;
    edEmailESNSpecified: TIWEdit;
    cbESNActive: TIWCheckBox;
    procedure bnReturnAdminClick(Sender: TObject);
    procedure bnReturnMainClick(Sender: TObject);
    procedure bnSaveAllClick(Sender: TObject);
    procedure IWAppFormCreate(Sender: TObject);
  private
    ssToRequest,
    ssEmailRequest,
    ssToUnavailable,
    ssEmailUnavailable,
    ssToApplied,
    ssEMailApplied,
    ssToOverRidden,
    ssEmailOverridden,
    ssToESNSpecified,
    ssEmailESNSpecified : ShortString;
    bCUActive,
    bTAActive,
    bTOActive,
    bESNActive : Boolean;
    procedure DoAdminLog;
  end;

implementation

{$R *.dfm}

uses SysUtils, DB, uWRData, uWRServer, uWRAdmin, uWRSite, uCodeIDs;

//*** Startup and Shutdown *****************************************************

procedure TfrmEmail.IWAppFormCreate(Sender: TObject);
begin
  with WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select * from emailrecipients ');
    Open;

    // AB - 12
    if Locate('Description', tidEmailRequest, [loCaseInsensitive]) then
    begin
      edToRequest.Text:= FieldByName('Recipient').AsString;
      ssToRequest := edToRequest.Text;

      edEmailRequest.Text:= FieldByName('Address').AsString;
      ssEmailRequest := edEmailRequest.Text;
    end;

    if Locate('Description', tidEmailCodeUnavailable, [loCaseInsensitive]) then
    begin
      edToUnavailable.Text:= FieldByName('Recipient').AsString;
      ssToUnavailable := edToUnavailable.Text;

      edEmailUnavailable.Text:= FieldByName('Address').AsString;
      ssEmailUnavailable := edEmailUnavailable.Text;

      cbCUActive.Checked:= FieldByName('Active').AsBoolean;
      bCUActive := cbCUActive.Checked;
    end;

    if Locate('Description', tidEmailThreshApplied, [loCaseInsensitive]) then
    begin
      edToApplied.Text:= FieldByName('Recipient').AsString;
      ssToApplied := edToApplied.Text;

      edEmailApplied.Text:= FieldByName('Address').AsString;
      ssEmailApplied := edEmailApplied.Text;

      cbTAActive.Checked:= FieldByName('Active').AsBoolean;
      bTAActive := cbTAActive.Checked;
    end;

    if Locate('Description', tidEmailThreshOverridden, [loCaseInsensitive]) then
    begin
      edToOverridden.Text:= FieldByName('Recipient').AsString;
      ssToOverridden := edToOverridden.Text;

      edEmailOverridden.Text:= FieldByName('Address').AsString;
      ssEmailOverridden := edEmailOverridden.Text;

      cbTOActive.Checked:= FieldByName('Active').AsBoolean;
      bTOActive := cbTOActive.Checked;
    end;

    // AB - 3
    if Locate('Description', tidEmailESNSpecified, [loCaseInsensitive]) then
    begin
      edToESNSpecified.Text := FieldByName('Recipient').AsString;
      ssToESNSpecified := edToESNSpecified.Text;

      edEmailESNSpecified.Text := FieldByName('Address').AsString;
      ssEmailESNSpecified := edEmailESNSpecified.Text;

      cbESNActive.Checked := FieldByName('Active').AsBoolean;
      bESNActive := cbESNActive.Checked;
    end;

  end;
end;

//*** Main *********************************************************************

procedure TfrmEmail.bnSaveAllClick(Sender: TObject);
begin
  with UserSession, WRData, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('update emailrecipients ');
    Sql.Add('set recipient = :precipient, address = :paddress, active = :pactive ');
    Sql.Add('where description = :pdescription ');

    ParamByName('precipient').AsString:= Trim(edToRequest.Text);
    ParamByName('paddress').AsString:= Trim(edEmailRequest.Text);
    ParamByName('pdescription').AsString:= tidEmailRequest;
    ParamByName('pactive').AsBoolean:= true;
    ExecSql;
    RequestRecipient.Address:= Trim(edEmailRequest.Text);
    RequestRecipient.Name:= Trim(edToRequest.Text);

    ParamByName('precipient').AsString:= Trim(edToUnavailable.Text);
    ParamByName('paddress').AsString:= Trim(edEmailUnavailable.Text);
    ParamByName('pdescription').AsString:= tidEmailCodeUnavailable;
    ParamByName('pactive').AsBoolean:= cbCUActive.Checked;
    ExecSql;
    CodeUnavailableRecipient.Address:= Trim(edEmailUnavailable.Text);
    CodeUnavailableRecipient.Name:= Trim(edToUnavailable.Text);
    CodeUnavailableRecipient.Active:= cbCUActive.Checked;

    ParamByName('precipient').AsString:= Trim(edToApplied.Text);
    ParamByName('paddress').AsString:= Trim(edEmailApplied.Text);
    ParamByName('pdescription').AsString:= tidEmailThreshApplied;
    ParamByName('pactive').AsBoolean:= cbTAActive.Checked;
    ExecSql;
    ThreshAppliedRecipient.Address:= Trim(edEmailApplied.Text);
    ThreshAppliedRecipient.Name:= Trim(edToApplied.Text);
    ThreshAppliedRecipient.Active:= cbTAActive.Checked;

    ParamByName('precipient').AsString:= Trim(edToOverridden.Text);
    ParamByName('paddress').AsString:= Trim(edEmailOverridden.Text);
    ParamByName('pdescription').AsString:= tidEmailThreshOverridden;
    ParamByName('pactive').AsBoolean:= cbTOActive.Checked;
    ExecSql;
    ThreshOverriddenRecipient.Address:= Trim(edEmailOverridden.Text);
    ThreshOverriddenRecipient.Name:= Trim(edToOverridden.Text);
    ThreshOverriddenRecipient.Active:= cbTOActive.Checked;

    // AB - 3
    ParamByName('precipient').AsString:= Trim(edToESNSpecified.Text);
    ParamByName('paddress').AsString:= Trim(edEmailESNSpecified.Text);
    ParamByName('pdescription').AsString:= tidEmailESNSpecified;
    ParamByName('pactive').AsBoolean := cbESNActive.Checked;
    ExecSql;
    ESNSpecifiedRecipient.Address := Trim(edToESNSpecified.Text);
    ESNSpecifiedRecipient.Name := Trim(edEmailESNSpecified.Text);
    ESNSpecifiedRecipient.Active := cbESNActive.Checked;
  end;

  // Reports and changes made to the email recipients.
  DoAdminLog;

  TfrmAdmin.Create(WebApplication).Show;
  WebApplication.ShowMessage('The Email settings were updated successfully.');
  Release;
end;

procedure TfrmEmail.DoAdminLog;
var
  BuildStr : string;
begin
  BuildStr := '';

  with UserSession do  
  begin
    // For Code Requests
    if (ssToRequest <> trim(edToRequest.Text)) then
      BuildStr := BuildStr + 'Code Requests To: ' + trim(edToRequest.Text) + ', ';
    if (ssEmailRequest <> trim(edEmailRequest.Text)) then
      BuildStr := BuildStr + 'Code Requests Email: ' + trim(edEmailRequest.Text) + ', ';
    // The call to delete() removes trailing comma and space.
    Delete(BuildStr, Length(BuildStr) - 1, 2);
    if (Length(BuildStr) <> 0) then
    begin
      UserSession.AdminLog(UserID, itUser, 'Email recipients updated (Code Requests) - ' + Copy(BuildStr, 1, 250));
      BuildStr := '';
    end;

    // For Code Unavailable
    if (ssToUnavailable <> trim(edToUnavailable.Text)) then
      BuildStr := BuildStr + 'Code Unavailable To: ' + trim(edToUnavailable.Text) + ', ';
    if (ssEmailUnavailable <> trim(edEmailUnavailable.Text)) then
      BuildStr := BuildStr + 'Code Unavailable Email: ' + trim(edEmailUnavailable.Text) + ', ';
    if (bCUActive <> cbCUActive.Checked) then
    begin
      if cbCUActive.Checked then
        BuildStr := BuildStr + 'Active, '
      else
        BuildStr := BuildStr + 'Inactive, ';
    end;
    // The call to delete() removes trailing comma and space.
    Delete(BuildStr, Length(BuildStr) - 1, 2);
    if (Length(BuildStr) <> 0) then
    begin
      UserSession.AdminLog(UserID, itUser, 'Email recipients updated (Code Unavailable) - ' + Copy(BuildStr, 1, 250));
      BuildStr := '';
    end;

    // For Threshold Applied
    if (ssToApplied <> trim(edToApplied.Text)) then
      BuildStr := BuildStr + 'Threshold Applied To: ' + trim(edToApplied.Text) + ', ';
    if (ssEmailApplied <> trim(edEmailApplied.Text)) then
      BuildStr := BuildStr + 'Threshold Applied Email: ' + trim(edEmailApplied.Text) + ', ';
    if (bTAActive <> cbTAActive.Checked) then
    begin
      if cbTAActive.Checked then
        BuildStr := BuildStr + 'Active, '
      else
        BuildStr := BuildStr + 'Inactive, ';
    end;
    // The call to delete() removes trailing comma and space.
    Delete(BuildStr, Length(BuildStr) - 1, 2);
    if (Length(BuildStr) <> 0) then
    begin
      UserSession.AdminLog(UserID, itUser, 'Email recipients updated (Threshold Applied) - ' + Copy(BuildStr, 1, 250));
      BuildStr := '';
    end;

    // For Threshold OverRidden
    if (ssToOverRidden <> trim(edToOverRidden.Text)) then
      BuildStr := BuildStr + 'Threshold Applied To: ' + trim(edToApplied.Text) + ', ';
    if (ssEmailOverridden <> trim(edEmailOverridden.Text)) then
      BuildStr := BuildStr + 'Threshold Applied Email: ' + trim(edEmailOverridden.Text) + ', ';
    if (bTOActive <> cbTOActive.Checked) then
    begin
      if cbTOActive.Checked then
        BuildStr := BuildStr + 'Active, '
      else
        BuildStr := BuildStr + 'Inactive, ';
    end;
    // The call to delete() removes trailing comma and space.
    Delete(BuildStr, Length(BuildStr) - 1, 2);
    if (Length(BuildStr) <> 0) then
    begin
      UserSession.AdminLog(UserID, itUser, 'Email recipients updated (Threshold OverRidden) - ' + Copy(BuildStr, 1, 250));
      BuildStr := '';
    end;

    // For ESN Specified
    if (ssToESNSpecified <> trim(edToESNSpecified.Text)) then
      BuildStr := BuildStr + 'ESN Specified To: ' + trim(edToESNSpecified.Text) + ', ';
    if (ssEmailESNSpecified <> trim(edEmailESNSpecified.Text)) then
      BuildStr := BuildStr + 'ESN Specified Email: ' + trim(edEmailESNSpecified.Text) + ', ';
    if (bESNActive <> cbESNActive.Checked) then
    begin
      if cbESNActive.Checked then
        BuildStr := BuildStr + 'Active, '
      else
        BuildStr := BuildStr + 'Inactive, ';
    end;
    // The call to delete() removes trailing comma and space.
    Delete(BuildStr, Length(BuildStr) - 1, 2);
    if (Length(BuildStr) <> 0) then
    begin
      UserSession.AdminLog(UserID, itUser, 'Email recipients updated (ESN Specified) - ' + Copy(BuildStr, 1, 250));
      BuildStr := '';
    end;
    
  end;
end;

//*** Event Handlers ***********************************************************

procedure TfrmEmail.bnReturnAdminClick(Sender: TObject);
begin
  TfrmAdmin.Create(WebApplication).Show;
  Release;
end;

procedure TfrmEmail.bnReturnMainClick(Sender: TObject);
begin
  TfrmSite.Create(WebApplication).Show;
  Release;
end;

//******************************************************************************

end.
