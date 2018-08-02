unit Notify;

interface

uses
{$IFDEF AQ}
  WorkSta2,
{$ELSE}
  WorkStat,
{$ENDIF}
  CommsInt;

  procedure NotifyHungConveyor;

implementation

uses
  SentU, ApiUtil, GlobIni, sysUtils;

var
  FWsSetup : TElertWorkstationSetup;


procedure NotifyHungConveyor;
var
  Admn : string;
  Msg : AnsiString;
begin
  with TSentIniObject.Create(GlobalIniFilename) do
  Try
    Admn := AdminEmail;
  Finally
    Free;
  End;

  if Trim(Admn) <> '' then
  begin
    FWsSetup := TElertWorkstationSetup.Create;
    Try
      with EntEmail do
      begin
        Recipients.Clear;
        CC.Clear;
        BCC.Clear;
        Attachments.Clear;
        if (FWsSetup.SMTPServer <> '') and not FWsSetup.UseMapi then
        begin
          Sender :=  FWsSetup.SMTPAddress;
          SenderName := FwsSetup.SMTPUser;
          SMTPServer := FWsSetup.SMTPServer;
          UseMAPI := FWsSetup.UseMapi;
        end
        else
        begin
          if FWsSetup.UseMapi then
            UseMapi := FWsSetup.UseMAPI
        end;
        Recipients.Add(Admn);

        Subject := 'PROBLEM: Sentimail conveyor not responding';

        Msg := 'The Sentimail conveyor on ' + WinGetComputerName +
                   ' is not responding. Time: ' + TimeToStr(Time);

        Message := PChar(Msg);

        Priority := 2;
        Send;
      end;
    Finally
      FWsSetup.Free;
    End;
  end;

end;

end.
