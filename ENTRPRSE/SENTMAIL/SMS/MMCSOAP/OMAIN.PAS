unit oMain;

interface

uses
  Forms,ComObj, ActiveX, EnterpriseSMS_TLB, StdVcl, Dialogs, AdPort, AdPager
  , IniFiles, Classes, SysUtils, Windows, FileUtil;

const
  ClassVersion = '1.00.003';

type
  TIniSettings = record
    sURL : string;
    sUserName : string;
    sPassword : string;
    sCompany : string;
    bDebug : boolean;
  end;

  TSMSSender = class(TAutoObject, ISMSSender)
  private
    sNumberToSendTo, sMessage, sNumber : string;
    oSMS : variant;
  protected
    function Get_Version: WideString; safecall;
    function Send: Integer; safecall;
    procedure Set_Message(const Value: WideString); safecall;
    procedure Set_Number(const Value: WideString); safecall;
    function Setup: Integer; safecall;
    procedure Abort; safecall;
    function GetErrorDesc(ErrorNo: Integer): WideString; safecall;
    function Get_Message: WideString; safecall;
    function Get_Number: WideString; safecall;
    function AreYouReady: WordBool; safecall;
    procedure Reset; safecall;
  public
    procedure Initialize; override;
    Destructor Destroy; override;
  end;

implementation

uses
  Registry, ComServ, Variants, Setup;

{-------------------------------------------------------------------------------------------------}
procedure TSMSSender.Initialize;
begin { Initialize }
  inherited Initialize;
  sNumberToSendTo := '';
  sMessage := '';
  sNumber := '';

//  CoInitialize(nil);

  try
    oSMS := CreateOleObject('Smscomponent.mmcWrapper');
  except
    On e:exception do Showmessage('SMSMMC.DLL Exception : ' + e.Message);
//    ShowMessage('SMSMMC.DLL : Could not create a Smscomponent.mmcWrapper COM object');
  end;{try}

end;

{-----------------------------------------}

Destructor TSMSSender.Destroy;
Begin { Destroy }
  oSMS := Unassigned;
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
  sLabel, sXML : string;

  function GetSettingsFromIniFile : TIniSettings;
  var
    IniFile : TIniFile;
  const
    sInifileName = 'SMSMMC.INI';

    function GetDLLDir : string;
    var
      ClsId : string;
      RegO : TRegistry;
    begin
      Result := '';

      RegO := TRegistry.Create;

      {Check for COM Object}
      RegO.RootKey := HKEY_CLASSES_ROOT;
      If RegO.KeyExists('EnterpriseSMS.SMSSender\Clsid') Then
        {get path from com object registration}
        Begin
          { Key exists - get CLSID }
          If RegO.OpenKey('EnterpriseSMS.SMSSender\Clsid', False) Then Begin
            If RegO.KeyExists('') Then Begin
              ClsId := RegO.ReadString ('');
              { Open CLSID up and get executable name }
              RegO.CloseKey;
              If RegO.OpenKey('Clsid\'+ClsId+'\InprocServer32', False) Then Begin
                ClsId := RegO.ReadString ('');
                If FileExists (ClsId) Then Begin
                  { Got File - Check its in current directory }
                  Result := IncludeTrailingBackslash(Trim(ExtractFilePath(ClsId)));
                End; { If }
              End; { If }
            End; { If }
          End; { If }
        End
      else Result := ExtractFilePath(Application.Exename);

      RegO.CloseKey;
    end;{GetDLLDir}

  begin{GetSettingsFromIniFile}

    IniFile := TIniFile.create(GetDLLDir + sInifileName);

    With Result do begin
      sURL := IniFile.ReadString('Settings','URL','http://gateway.mobilemessagecentre.com/soap/mmc.dll');
      sUserName := IniFile.ReadString('Settings','UserName','');
      sPassword := IniFile.ReadString('Settings','Password','');
      sCompany := IniFile.ReadString('Settings','Company','');
      bDebug := UpperCase(IniFile.ReadString('Settings','Debug','FALSE')) = 'TRUE';
    end;{with}
  end;{GetSettingsFromIniFile}

begin{Send}

  if Trim(sNumber) = '' then Result := 1
  else begin
    if Trim(sMessage) = '' then Result := 3
    else begin

      sNumberToSendTo := sNumber;

      sLabel := 'Exchequer SentiMail';
    //  sNumber := '447946855132';

      // Numbers must be specified in their international format:
      // eg: 07768123456 is written 447768123456
      sXml := ' <mmc version=''1.0''>';
      sXml := sXml + #13 + '         <msg>';
      sXml := sXml + #13 + '            <numbers>';
      sXml := sXml + #13 + '               <number operatorid=''0'' model=''0'' country=''0'' make=''0''>' + sNumber + '</number>';
      sXml := sXml + #13 + '            </numbers>';
      sXml := sXml + #13 + '            <contents>';
      sXml := sXml + #13 + '               <text>' + sMessage + '</text>';
      sXml := sXml + #13 + '            </contents>';
      sXml := sXml + #13 + '        </msg>';
      sXml := sXml + #13 + '      </mmc>';

      with GetSettingsFromIniFile do begin
        oSMS.Url(sURL);
        oSMS.UserDetails(sUserName, sPassword, sCompany, sLabel);

        oSMS.Xml(sXML);

        if bDebug then ShowMessage('Number : ' + sNumberToSendTo + #13#13 + 'Message : ' + sMessage)
        else oSMS.Send;
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
  { do nothing !}
end;

function TSMSSender.GetErrorDesc(ErrorNo: Integer): WideString;
begin
  Case ErrorNo of
    1 : Result := 'No mobile number defined to send the message to.';
    3 : Result := 'No message defined.';
  end;{case}
end;

function TSMSSender.Get_Message: WideString;
begin
  Result := sMessage;
end;

function TSMSSender.Get_Number: WideString;
begin
  Result := sNumber;
end;

function TSMSSender.AreYouReady: WordBool;
begin
  Result := TRUE;
end;

procedure TSMSSender.Reset;
begin
  {do nothing !}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TSMSSender, Class_SMSSender, ciSingleInstance, tmBoth);

end.

