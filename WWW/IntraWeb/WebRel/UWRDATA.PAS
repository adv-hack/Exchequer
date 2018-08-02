unit uWRData;

interface

uses
  Forms, SysUtils, Classes, DB, pvtables, sqldataset, pvsqltables,
  IdMessage, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdMessageClient, IdSMTP, Inifiles;

type
  TWRData = class(TDataModule)
    WRDB: TPvSqlDatabase;
    WRSession: TPvSqlSession;
    qyPrimary: TPvQuery;
    qyUserGroups: TPvQuery;
    qyCustomers: TPvQuery;
    qyESNs: TPvQuery;
    qyAuditLog: TPvQuery;
    qySecondary: TPvQuery;
    qyTertiary: TPvQuery;
    SMTPer: TIdSMTP;
    msgMain: TIdMessage;
    qyAudit: TPvQuery;
    qyAuditGrid: TPvQuery;
    dsAudit: TDataSource;
    qyAdminLog: TPvQuery;
    procedure DataModuleCreate(Sender: TObject);
  public
    procedure LoadRecipients;
  end;

  function WRData: TWRData;

implementation

{$R *.dfm}

uses IWInit, uCodeIDs, uWRServer;

//*** Startup and Shutdown *****************************************************

procedure TWRData.DataModuleCreate(Sender: TObject);
begin
  {Builds the send details for the internal request code email from the WebRel inifile;}

  with TInifile.Create('C:\Development\WebRel\WebRel.ini') do
  try

    SMTPer.Host:= ReadString('Mail', 'EmailIP', '127.0.0.1');

  finally
    Free;
  end;
end;

procedure TWRData.LoadRecipients;
begin
  with UserSession, qyPrimary do
  begin
    Close;
    Sql.Clear;
    Sql.Add('select description, address, recipient, active from emailrecipients ');
    Sql.Add('order by recipientid ');
    Open;

    if Locate('Description', tidEmailRequest, [loCaseInsensitive]) then
    begin
      RequestRecipient.Address:= FieldByName('Address').AsString;
      RequestRecipient.Name:= FieldByName('Recipient').AsString;
      RequestRecipient.Active:= FieldByName('Active').AsBoolean;
    end;

    if Locate('Description', tidEmailThreshApplied, [loCaseInsensitive]) then
    begin
      ThreshAppliedRecipient.Address:= FieldByName('Address').AsString;
      ThreshAppliedRecipient.Name:= FieldByName('Recipient').AsString;
      ThreshAppliedRecipient.Active:= FieldByName('Active').AsBoolean;
    end;

    if Locate('Description', tidEmailThreshOverridden, [loCaseInsensitive]) then
    begin
      ThreshOverriddenRecipient.Address:= FieldByName('Address').AsString;
      ThreshOverriddenRecipient.Name:= FieldByName('Recipient').AsString;
      ThreshOverriddenRecipient.Active:= FieldByName('Active').AsBoolean;
    end;

    if Locate('Description', tidEmailCodeUnavailable, [loCaseInsensitive]) then
    begin
      CodeUnavailableRecipient.Address:= FieldByName('Address').AsString;
      CodeUnavailableRecipient.Name:= FieldByName('Recipient').AsString;
      CodeUnavailableRecipient.Active:= FieldByName('Active').AsBoolean;
    end;

    if Locate('Description', tidEmailESNSpecified, [loCaseInsensitive]) then
    begin
      ESNSpecifiedRecipient.Address:= FieldByName('Address').AsString;
      ESNSpecifiedRecipient.Name:= FieldByName('Recipient').AsString;
      ESNSpecifiedRecipient.Active:= FieldByName('Active').AsBoolean;
    end;

  end;
end;

//*** Helper Functions *********************************************************

function WRData: TWRData;
begin
  {Accessor function for the Data Module;}

  Result:= TUserSession(RWebApplication.Data).WRData;
end;

//******************************************************************************

end.
