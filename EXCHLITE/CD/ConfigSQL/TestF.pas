unit TestF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ServiceManager, WinSvc, StdCtrls, DateUtils;

type
  TForm1 = class(TForm)
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

    procedure ConfigureSQL;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

Uses APIUtil, Registry;

//-------------------------------------------------------------------------

procedure TForm1.Button3Click(Sender: TObject);
begin
  ConfigureSQL;
  ShowMessage ('Done');
end;

//------------------------------

procedure TForm1.ConfigureSQL;
Var
  PCharStr : ANSIString;
  oServiceManager : TServiceManager;
  TimeoutTime : TDateTime;

  Procedure UpdateSQLRegistry;
  Var
    oReg : TRegistry;
    sInstanceName : ShortString;
  Begin // UpdateSQLRegistry
    // Lokup IRISSOFTWARE instance in the registry to identify where the MSSQL registry entries are
    oReg := TRegistry.Create;
    Try
      // Requires write permissions
      //oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
      oReg.RootKey := HKEY_LOCAL_MACHINE;

      // Check for the 'IRISSOFTWARE' named instance
      sInstanceName := '';
      If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False) Then
      Begin
        If oReg.ValueExists('IRISSOFTWARE') Then
        Begin
          // Extract the 'MSSQL.X' name so we can go to the actual settings for IRISSOFTWARE
          sInstanceName := oReg.ReadString('IRISSOFTWARE');
        End; // If oReg.ValueExists('IRISSOFTWARE')
        oReg.CloseKey;

        // Open the section for the IRISSOFTWARE named instance
        If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\' + sInstanceName + '\MSSQLServer\SuperSocketNetLib\Np', False) Then
        Begin
          oReg.WriteInteger('Enabled', 1);
          oReg.CloseKey;
        End; // If oReg.OpenKey('SOFTWARE\...

        // Open the section for the IRISSOFTWARE named instance
        If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\' + sInstanceName + '\MSSQLServer\SuperSocketNetLib\Tcp', False) Then
        Begin
          oReg.WriteInteger('Enabled', 1);
          oReg.CloseKey;
        End; // If oReg.OpenKey('SOFTWARE\...
      End; // If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server', False)
    Finally
      FreeAndNIL(oReg);
    End; // Try..Finally
  End; // UpdateSQLRegistry

begin
  oServiceManager := TServiceManager.Create;
  Try
    PCharStr := WinGetComputerName;
    If oServiceManager.Connect(PCHAR(PCharStr), NIL, SC_MANAGER_ALL_ACCESS) Then
    Begin
      PCharStr := 'MSSQL$IRISSOFTWARE';
      If oServiceManager.OpenServiceConnection(PCHAR(PCharStr)) Then
      Begin
        // Stop Service -----------------------------------
        If (oServiceManager.GetStatus = SERVICE_RUNNING) Then
        Begin
          If oServiceManager.StopService Then
          Begin
            // Wait until started - otherwise following pre-reqs may fail
            TimeoutTime := IncSecond(Now, 10); // 10 second timeout
            Repeat
              Sleep(250);  // pause for 1/4 second to allow it do do its thang
            Until oServiceManager.ServiceStopped Or (TimeoutTime < Now);
          End // If oServiceManager.StopService
          Else
            MessageDlg ('Unable to stop the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
                        mtError, [mbOK], 0);
        End; // If (oServiceManager.GetStatus = SERVICE_RUNNING)

        // Update Registry --------------------------------
        UpdateSQLRegistry;

        // Restart Service --------------------------------
        If oServiceManager.StartService Then
        Begin
          // Wait until started - otherwise following pre-reqs may fail
          TimeoutTime := IncSecond(Now, 10); // 10 second timeout
          Repeat
            Sleep(250);  // pause for 1/4 second to allow it do do its thang
          Until oServiceManager.ServiceRunning Or (TimeoutTime < Now);
        End // If oServiceManager.StartService
        Else
          MessageDlg ('Unable to restart the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
                      mtError, [mbOK], 0);
      End // If oServiceManager.OpenServiceConnection(PCHAR(PCharStr))
      Else
        MessageDlg ('Unable to connect to the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
                    mtError, [mbOK], 0);
    End // If oServiceManager.Connect(PCHAR(PCharStr), NIL, SC_MANAGER_ALL_ACCESS)
    Else
      MessageDlg ('Unable to connect to the Service Manager, please contact your Technical Support',
                  mtError, [mbOK], 0);
  Finally
    FreeAndNIL(oServiceManager);
  End; // Try..Finally
end;

end.
