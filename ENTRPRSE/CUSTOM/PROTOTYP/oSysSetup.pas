unit oSysSetup;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl;

type
  TTradeSystemSetup = class(TAutoIntfObject, ITradeSystemSetup)
  private
  protected
    // ITradeSystemSetup
  public
    Constructor Create;
  End; { TTradeSystemSetup }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeSystemSetup.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeSystemSetup);

End; { Create }

end.
