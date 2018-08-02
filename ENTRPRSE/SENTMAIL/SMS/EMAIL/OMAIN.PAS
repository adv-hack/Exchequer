unit oMain;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, SysUtils, StrUtil, Inifiles
  , RegUtil, Dialogs, Setup, Forms, Classes;

const
  ClassVersion = '1.00.003';

type
  TSMSSender = class(TAutoObject, ISMSSender)
  protected
    function Get_Message: WideString; safecall;
    function Get_Number: WideString; safecall;
    function Get_Version: WideString; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    function Send: Integer; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Setup: Integer; safecall;
    function AreYouReady: WordBool; safecall;
    procedure Reset; safecall;
  private
    sMessage, sNumber : string;
  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation
uses
  ComServ, CommsInt;

function TSMSSender.Get_Message: WideString;
begin
  Result := sMessage;
end;

function TSMSSender.Get_Number: WideString;
begin
  Result := sNumber;
end;

function TSMSSender.Get_Version: WideString;
begin
  Result := ClassVersion;
end;

procedure TSMSSender.Abort;
begin
  {can't do anything}
end;

function TSMSSender.GetErrorDesc(ErrorNo: Integer): WideString;
begin
  Case ErrorNo of
    1 : Result := 'Error Sending MAPI Email';
    2 : Result := 'No mobile number defined to send the message to.';
    3 : Result := 'ENTCOMM2.DLL Not Found.';
    4 : Result := 'No message to send';
    5 : Result := 'File not found : SMSEmail.INI';
    6 : Result := 'Invalid Type defined in SMSEmail.INI';
  end;{case}
end;

function TSMSSender.Send: Integer;
var
  sIniFullPath, sType : string;
  IniFile : TIniFile;
  bDebug : boolean;
  lstRecipient : TStringlist;
const
  sInifileName = 'SMSEmail.ini';
begin
  Result := 0;

  {make sure that there is a message to send}
  if sMessage = '' then Result := 4
  else begin

    {Make sure there is a mobile number to send the message to}
    if Trim(sNumber) = '' then Result := 2
    else begin

      {make sure SMSEmail.ini exists}
      sIniFullPath := GetCOMObjectDir('EnterpriseSMS.SMSSender') + sInifileName;
      if FileExists(sIniFullPath) then
        begin

          {read settings from ini file}
          IniFile := TIniFile.create(sIniFullPath);
          sType := IniFile.ReadString('Settings','Type','');
          bDebug := UpperCase(IniFile.ReadString('Settings','Debug','FALSE')) = 'TRUE';

          {create enterprise emailing component}
          with TEntEmail.Create do
          try
            Priority := 1;  // Send as normal priority
            lstRecipient := TStringList.Create;

            if sType = 'Kapow' then
              begin

                {set appropriate properties for Kapow Gateway}
                lstRecipient.Add(RemoveAllChars(Trim(sNumber),' ') + '@'
                + IniFile.ReadString(sType,'Company','kapow.co.uk'));
                Subject := sMessage;
                StrPCopy(Message, IniFile.ReadString(sType,'UserName','') + #13
                + IniFile.ReadString(sType,'Password',''));
              end
            else begin
              if sType = 'Text Marketer' then
                begin

                  {set appropriate properties for Text Marketer Gateway}
                  lstRecipient.Add(RemoveAllChars(Trim(sNumber),' ') + '@'
                  + IniFile.ReadString(sType,'Company','textmarketer.co.uk'));
//lstRecipient.Add('nfrewer@exchequer.com');
                  Subject := IniFile.ReadString(sType,'AccountNo','');
                  StrPCopy(Message, '%%START%%' + sMessage + '%%END%%');
                end
              else Result := 6;{Invalid Type in the ini file}
            end;{if}

            {Send Email}
            if Result = 0 then begin
              Recipients.Assign(lstRecipient);
              Sender := IniFile.ReadString('Settings','SenderEmailAddress','Exchequer Sentimail');
              SenderName := 'Exchequer Sentimail';
              SMTPServer := IniFile.ReadString('Settings','SMTPServer','');
              UseMAPI := UpperCase(IniFile.ReadString('Settings','UseMAPI','FALSE')) = 'TRUE';

              if bDebug then ShowMessage('Number : ' + sNumber + #13#13 + 'Message : ' + sMessage)
              else begin
                try
                  Result := Send;
                except // Trap any exceptions on sending E-mail
                end;{try}
              end;
            end;{if}

            IniFile.Free;

          finally
            lstRecipient.Free;
            Free;
          end;

        end
      else Result := 5 {SMSEmail.ini does not exist}
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

procedure TSMSSender.Initialize;
begin { Initialize }
  inherited Initialize;
  sMessage := '';
  sNumber := '';
end;

Destructor TSMSSender.Destroy;
Begin { Destroy }
  inherited Destroy;
End; { Destroy }

function TSMSSender.AreYouReady: WordBool;
begin
  Result := TRUE;
end;

procedure TSMSSender.Reset;
begin
  {do nothing !}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender,
    ciMultiInstance, tmApartment);
end.
