unit oCustTxt;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oHookPnt, oEvent;

type
  TTradeCustomText = class(TAutoIntfObject, ITradeCustomText)
  private
    // Custom Text WindowId/TextId
    FWindowId  : TTradeWindowIds;
    FTextId    : Integer;
    FText      : ShortString;
  protected
    // ITradeCustomText
    function Get_ctWindowId: TTradeWindowIds; safecall;
    function Get_ctTextId: Integer; safecall;
    function Get_ctText: WideString; safecall;
    procedure Set_ctText(const Value: WideString); safecall;

    // Local methods
  public
    Property WindowId : TTradeWindowIds Read FWindowId Write FWindowId;
    Property TextId : Integer Read FTextId Write FTextId;
    Property Text : ShortString Read FText Write FText;

    Constructor Create;
  end;

implementation

uses ComServ, SysUtils;

//---------------------------------------------------------------------------

Constructor TTradeCustomText.Create;
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeCustomText);
End; { Create }

//---------------------------------------------------------------------------

function TTradeCustomText.Get_ctWindowId: TTradeWindowIds;
begin
  Result := FWindowId;
end;

//----------------------------------------

function TTradeCustomText.Get_ctTextId: Integer;
begin
  Result := FTextId;
end;

//----------------------------------------

function TTradeCustomText.Get_ctText: WideString;
begin
  Result := FText;
end;

procedure TTradeCustomText.Set_ctText(const Value: WideString);
begin
  FText := Value;
end;

//---------------------------------------------------------------------------

end.
