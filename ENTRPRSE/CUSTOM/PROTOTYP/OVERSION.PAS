unit oVersion;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl;

type
  TTradeVersion = class(TAutoIntfObject, ITradeVersion)
  private
  protected
    // ITradeVersion
  public
    Constructor Create;
  End; { TTradeVersion }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeVersion.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeVersion);

End; { Create }

end.
