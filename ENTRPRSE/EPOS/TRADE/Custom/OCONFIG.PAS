unit oConfig;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, Forms, EnterpriseTrade_TLB, StdVcl, oHookPnt, oEvent;

type
  TTradeConfiguration = class(TAutoIntfObject, ITradeConfiguration)
  private
  protected
    // ITradeConfiguration
    function Get_cfEnterpriseDirectory: WideString; safecall;
    function Get_cfDataDirectory: WideString; safecall;
    function Get_cfLocalTradeDirectory: WideString; safecall;

    // Local methods
  public
    Constructor Create;
    Destructor Destroy; override;
  end; { TTradeConfiguration }

implementation

uses
  ComServ, SysUtils, Windows, EPOSCnst, LicUtil;

//---------------------------------------------------------------------------

Constructor TTradeConfiguration.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeConfiguration);

End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeConfiguration.Destroy;
Begin { Destroy }

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

function TTradeConfiguration.Get_cfDataDirectory: WideString;
begin
{ TODO -cTODO : ITradeConfiguration.cfDataDirectory not coded }
  Result := sCurrCompPath;
end;

//---------------------------------------------------------------------------

function TTradeConfiguration.Get_cfEnterpriseDirectory: WideString;
begin
{ TODO -cTODO : ITradeConfiguration.cfEnterpriseDirectory not coded }
//  Result := '';
  Result := GetTCMEnterpriseDirectory;
end;

//---------------------------------------------------------------------------

function TTradeConfiguration.Get_cfLocalTradeDirectory: WideString;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

//---------------------------------------------------------------------------

end.
