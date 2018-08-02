unit oMain;

interface

uses
  Forms,ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, Dialogs, AdPort, AdPager
  , IniFiles, Classes, SysUtils, Windows, FileUtil, Setup, ExtCtrls;

const
  ClassVersion = '1.00.003';
  sAppName = 'SMS Sender';

type
  TIniSettings = record
    iComNo : integer;
    iNoOfDataBits : integer;
    iNoOfStopBits : integer;
    iNoOfSecsPauseBetweenDials : integer;
    cParity : Char;
    sCallCentreNo : string;
    sComPortLogFile : string;
    sTapLogFile : string;
  end;

  TSMSSender = class(TAutoObject, ISMSSender)
  private
    bDebug : boolean;
    sExceptMessage, sNumberToSendTo, sMessage, sNumber : string;
    ApdComPort: TApdComPort;
    ApdTAPPager: TApdTAPPager;
    ApdPagerLog: TApdPagerLog;
    iGlobalStatus : integer;
    procedure SMSOnTAPStatus(Sender: TObject; Event: TTapStatus);
    procedure SMSOnTAPFinish(Sender: TObject);
    procedure SMSOnDialError(Sender: TObject; Error: TDialError);
    procedure SMSOnDialStatus(Sender: TObject; Event: TDialingStatus);
    procedure SMSOnGetNextMessage(Sender : TObject; var DoneMessages: Boolean);
    function GetSettingsFromIniFile : TIniSettings;
    procedure TimerTimeout(Sender: TObject);

  protected
    function Get_Version: WideString; safecall;
//    function Get_NumberSentTo: WideString; safecall;
    function Send: Integer; safecall;
{    procedure Set_AreaCode(const Value: WideString); safecall;}
    procedure Set_Message(const Value: WideString); safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Setup: Integer; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    function Get_Number: WideString; safecall;
    function Get_Message: WideString; safecall;
    procedure Reset; safecall;
    function AreYouReady: WordBool; safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation

uses
  ComServ, PortReg, RegUtil;

{-------------------------------------------------------------------------------------------------}

procedure TSMSSender.SMSOnTAPStatus(Sender: TObject; Event: TTapStatus);
begin
//DebugToFile('SMSOnTAPStatus : ' + ApdTAPPager.TAPStatusMsg(Event));
end;

procedure TSMSSender.SMSOnTAPFinish(Sender: TObject);
begin
//DebugToFile('SMSOnTAPFinish');
end;

procedure TSMSSender.SMSOnDialError(Sender: TObject; Error: TDialError);
begin

//DebugToFile('SMSOnDialError : ' + ApdTAPPager.DialStatusMsg(Error));

  iGlobalStatus := 2000 + Ord(Error);
end;

procedure TSMSSender.SMSOnDialStatus(Sender: TObject; Event: TDialingStatus);
var
  iStatusNo : integer;
begin
  iStatusNo := Ord(Event);
  if not (iStatusNo in [10,9,5,4,3,2,1]) then iGlobalStatus := 1000 + iStatusNo;

//DebugToFile('SMSOnDialStatus : ' + ApdTAPPager.DialStatusMsg(Event));

//  if Event = dsMsgNotSent
//  then ApdTAPPager.CancelCall;
end;

procedure TSMSSender.SMSOnGetNextMessage(Sender : TObject; var DoneMessages: Boolean);
begin
  DoneMessages := TRUE;

//DebugToFile('SMSOnGetNextMessage')

end;

procedure TSMSSender.Initialize;
begin { Initialize }
  inherited Initialize;
  sExceptMessage := '';
  sNumberToSendTo := '';
{  sAreaCode := '';}
  sMessage := '';
  sNumber := '';
  ApdComPort := TApdComPort.create(application);
  ApdTAPPager := TApdTAPPager.create(application);
  ApdPagerLog := TApdPagerLog.create(application);

  {link components together}
  ApdTAPPager.PagerLog := ApdPagerLog;
  ApdTAPPager.Port := ApdComPort;
  ApdPagerLog.Pager := ApdTAPPager;

  {set default values}
  ApdComPort.Baud := 9600;
  ApdComPort.Logging := tlOn;
  ApdTAPPager.MaxMessageLength := 160;
  ApdTAPPager.OnDialError := SMSOnDialError;
  ApdTAPPager.OnDialStatus := SMSOnDialStatus;
  ApdTAPPager.OnGetNextMessage := SMSOnGetNextMessage;
  ApdTAPPager.OnTAPFinish := SMSOnTAPFinish;
  ApdTAPPager.OnTAPStatus := SMSOnTAPStatus;

  ApdTAPPager.DialAttempts := 1;
//  ApdTAPPager.BlindDial := TRUE; {this messes up Mobile phone modems}
  ApdTAPPager.AbortNoConnect := TRUE;
  ApdTAPPager.DialWait := 45;

  {Resets registry entries for all com ports for this application}
  ResetComPortReg(sAppName);

end;

{-----------------------------------------}

Destructor TSMSSender.Destroy;
Begin { Destroy }
  ApdTAPPager.CancelCall;
  ApdComPort.Free;
  ApdTAPPager.Free;
  ApdPagerLog.Free;
  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

function TSMSSender.Get_Version: WideString;
// Version number - used to identify what level of functionality is available
begin
  Result := ClassVersion;
end;

function TSMSSender.Send: Integer;
var
  Timeout : TTimer;

  Procedure StringToStrings(sString : string; sStrings : TStrings);
  var
    iPos : integer;
  begin{StringToStrings}

    {truncate if > 160}

    iPos := 1;
    Repeat
      if Pos(UpperCase(sString[iPos]), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890.,;:!?''%&*+-=#()/') = 0
      then Delete(sString,iPos,1)
      else Inc(iPos);
    Until iPos > Length(sString);

    if length(sString) > 160 then sString := Copy(sString,1,160);

    sStrings.Clear;
    sStrings.Add(sString);
(*    iStartPos := 1;
    for iPos := 1 to length(sString) do begin
      if (sString[iPos] = #13) or (iPos = length(sString)) then begin
        sStrings.Add(Copy(sString,iStartPos,iPos - iStartPos));
        iStartPos := iPos + 1;
      end;{if}
    end;{for}*)
  end;{StringToStrings}

begin{Send}

//DebugToFile('');
//DebugToFile(sNumber);

  iGlobalStatus := 0;
  if sMessage = '' then Result := 3
  else begin
    sNumberToSendTo := sNumber;{ConvertPhoneNo(sCountryCode, sAreaCode, sNumber);}

    {Make sure there is a mobile number to send the message to}
    if Trim(sNumberToSendTo) = '' then Result := 1
    else begin
      with GetSettingsFromIniFile do begin

        {Make sure there's a number for the call centre}
        if Trim(sCallCentreNo) = '' then Result := 2
        else begin

          {checks the registry entry, seeing if the comport is already in use}
          if ComPortInUseReg(iComNo) then Result := 4
          else begin
            Result := 0;
            ApdPagerLog.HistoryName := sTapLogFile;
            ApdComPort.LogName := sComPortLogFile;
            ApdComPort.ComNumber := iComNo;
            ApdComPort.Databits := iNoOfDataBits;
            ApdComPort.StopBits := iNoOfStopBits;
            case cParity of
              'O' : ApdComPort.Parity := pOdd;
              'E' : ApdComPort.Parity := pEven;
              'N' : ApdComPort.Parity := pNone;
            end;{case}

            ApdTAPPager.PhoneNumber := sCallCentreNo;
            ApdTAPPager.PagerID := sNumberToSendTo;
//            ApdTAPPager.TapWait
            StringToStrings(sMessage, ApdTAPPager.Message);

            if bDebug then ShowMessage('Number : ' + sNumberToSendTo + #13#13 + 'Message : ' + ApdTAPPager.Message[0])
            else begin

              {sets the registry entry, flagging that the com port is in use}
              SetComPortReg(sAppName, ApdComPort.comnumber, TRUE);

              Timeout := TTimer.Create(nil);
              Timeout.OnTimer := TimerTimeout;
              Timeout.Interval := 180000;
              Timeout.Enabled := TRUE;

              try
                ApdTAPPager.Send;
              except
                on E:Exception do begin
                  Result := 5;
                  sExceptMessage := E.Message;
                end;
              end;{try}

              Timeout.Enabled := FALSE;
              Timeout.Free;

              {sets the registry entry, flagging that the com port is no longer in use}
              SetComPortReg(sAppName, ApdComPort.comnumber, FALSE);

              if (Result <> 5) and (iGlobalStatus <> 0) then Result := iGlobalStatus;
            end;{if}

            Sleep(iNoOfSecsPauseBetweenDials * 1000);
          end;{if}
        end;{if}
      end;{with}
    end;{if}
  end;{if}
end;

procedure TSMSSender.Set_Message(const Value: WideString);
begin
  sMessage := Value;
end;

procedure TSMSSender.Set_Number(const Value: WideString);
begin
  sNumber := Value;
end;

function TSMSSender.Setup: Integer;
var
  frmSetup : TfrmSetup;
begin
  Result := 0;

  frmSetup := TfrmSetup.Create(application);
  try
    frmSetup.ShowModal;
  finally
    frmSetup.Release;
  end;{try}
end;

procedure TSMSSender.Abort;
begin
  ApdTAPPager.CancelCall;
end;

function TSMSSender.GetErrorDesc(ErrorNo: Integer): WideString;
begin
  Case ErrorNo of
    1 : Result := 'No mobile number defined to send the message to.';
    2 : Result := 'No number defined for the SMS Call Centre.';
    3 : Result := 'No message defined.';
    4 : Result := 'Com Port in use by another Exchequer application.';
    5 : Result := 'An exception has occurred when sending the message (' + sExceptMessage +').';
    {100 - Don't use as Paul is using it}
    1000..1999 : Result := 'OnDialStatus Returned a result of : ' + ApdTAPPager.DialStatusMsg(TDialingCondition(ErrorNo - 1000));
    2000..2999 : Result := 'OnDialError Returned a result of : ' + ApdTAPPager.DialStatusMsg(TDialingCondition(ErrorNo - 2000));
  end;{case}
end;

function TSMSSender.Get_Number: WideString;
begin
  Result := sNumber;
end;

function TSMSSender.Get_Message: WideString;
begin
  Result := sMessage;
end;

procedure TSMSSender.Reset;
begin
  ResetComPortReg(sAppName);
end;

function TSMSSender.AreYouReady: WordBool;
begin
  Result := not ComPortAppInUseReg(GetSettingsFromIniFile.iComNo, sAppName);
end;

function TSMSSender.GetSettingsFromIniFile : TIniSettings;
var
  IniFile : TIniFile;
const
  sInifileName = 'SMSCntr.ini';

begin{GetSettingsFromIniFile}

  IniFile := TIniFile.create(GetCOMObjectDir('EnterpriseSMS.SMSSender') + sInifileName);

  With Result do begin
    iNoOfSecsPauseBetweenDials := IniFile.ReadInteger('Settings','NoOfSecsPauseBetweenDials',2);
    iComNo := IniFile.ReadInteger('Settings','ComNo',1);
    iNoOfDataBits := IniFile.ReadInteger('Settings','NoOfDataBits',8);
    iNoOfStopBits := IniFile.ReadInteger('Settings','NoOfStopBits',1);
    cParity := IniFile.ReadString('Settings','Parity','N')[1];
    sCallCentreNo := IniFile.ReadString('Settings','CallCentreNo','');
    sComPortLogFile := IniFile.ReadString('Settings','ComPortLogFile','SMSPORT.LOG');
    sTapLogFile := IniFile.ReadString('Settings','TapLogFile','SMSTAP.LOG');
    bDebug := UpperCase(IniFile.ReadString('Settings','Debug','FALSE')) = 'TRUE';
  end;{with}
  IniFile.Free;
end;{GetSettingsFromIniFile}

procedure TSMSSender.TimerTimeout(Sender: TObject);
begin
  ApdTAPPager.CancelCall;
end;


initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender, ciSingleInstance, tmBoth);

end.
