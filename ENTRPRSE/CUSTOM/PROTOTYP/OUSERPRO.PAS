unit oUserPro;

Interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl;

type
  TTradeUserProfile = class(TAutoIntfObject, ITradeUserProfile)
  private
  protected
    // ITradeUserProfile
  public
    Constructor Create;
  End; { TTradeUserProfile }

implementation

uses ComServ;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeUserProfile.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeUserProfile);

End; { Create }

end.
 