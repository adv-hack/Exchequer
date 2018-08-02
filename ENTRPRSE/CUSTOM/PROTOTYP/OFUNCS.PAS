unit oFuncs;

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl;

type
  TTradeFunctions = class(TAutoIntfObject, ITradeFunctions)
  private
    FTradehWnd : THandle;
  protected
    // ITradeFunctions
    function Get_fnTradehWnd: Integer; safecall;
    procedure entActivateClient(ClientHandle: Integer); safecall;
  public
    Property TradehWnd : THandle Read FTradehWnd Write FTradehWnd;

    Constructor Create;
  End; { TTradeFunctions }

implementation

uses ComServ, Windows;

{-------------------------------------------------------------------------------------------------}

Constructor TTradeFunctions.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeFunctions);

End; { Create }

{-------------------------------------------------------------------------------------------------}

procedure TTradeFunctions.entActivateClient(ClientHandle: Integer);
begin
  SetForeGroundWindow (ClientHandle);
end;

{-------------------------------------------------------------------------------------------------}

function TTradeFunctions.Get_fnTradehWnd: Integer;
begin
  Result := FTradehWnd;
end;

{-------------------------------------------------------------------------------------------------}

end.
