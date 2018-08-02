unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl, EnterpriseTrade_TLB;

type
  TTotalQuantity = class(TAutoObject, ITotalQuantity, ITradeClient)
  protected
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  private
    lBaseData: ITradeConnectionPoint;
    hpTXHeadCustomButton : integer;
  end;

implementation

uses
  Dialogs, APIUtil, StrUtil, Forms, PISecure, ComServ;

{ TTotalQuantity }

procedure TTotalQuantity.OnConfigure(const Config: ITradeConfiguration);
begin

end;

procedure TTotalQuantity.OnCustomEvent(const EventData: ITradeEventData);
var
  iLine : integer;
  rTotalQuantity : real;
begin
  if (EventData.edWindowId = twiTransaction) and (EventData.edHandlerId = hpTXHeadCustomButton) then
  begin
    // On TXHead custom button click
    rTotalQuantity := 0;
    For iLine := 1 to EventData.Transaction.thLines.thLineCount do begin
      with EventData.Transaction.thLines.thLine[iLine] do begin
        rTotalQuantity := rTotalQuantity + tlQty;
      end;{with}
    end;{for}

    MsgBox('The total quantity for this transaction is : '#13#13#9 + MoneyToStr(rTotalQuantity
    , lBaseData.SystemSetup.ssEnterprise.ssQtyDecimals), mtInformation, [mbOK]
    , mbOK,'Total Quantity');
  end;{if}
end;

procedure TTotalQuantity.OnCustomText(const CustomText: ITradeCustomText);
begin
  if (CustomText.ctWindowId = twiTransaction) and (CustomText.ctTextId = hpTXHeadCustomButton)
  then CustomText.ctText := '&Total Qty';
end;

procedure TTotalQuantity.OnShutdown;
begin
  lBaseData := nil;
end;

procedure TTotalQuantity.OnStartup(const BaseData: ITradeConnectionPoint);
const
  sPlugInName = 'Total Quantity Plug-In';
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = 'v7.0.05.003';
//    sVersionNo = 'v6.00.002';
  {$ELSE}
    sVersionNo = 'v5.70.002';
  {$ENDIF}
begin
  hpTXHeadCustomButton := 0;

  BaseData.piCustomisationSupport := 'v1.00';
  BaseData.piVersion := sVersionNo;
  BaseData.piName := sPlugInName;

  if PICheckSecurity('EXCHTCMTQP000037', ']ss152Qq,>/?23c?', sPlugInName
  , sVersionNo + ' (TCM)', stSystemOnly, ptTCM, Application.ExeName) then
  begin
    BaseData.piAuthor := 'Advanced Enterprise Software';
    BaseData.piCopyright := GetCopyrightMessage;
    BaseData.piSupport := 'Contact your Exchequer helpline number';
    lBaseData := BaseData;

    // Enable Hooks
    if lBaseData.piHookPoints[twiTransaction,hpTXHeadCustom1] in [thsEnabled, thsEnabledOther] then
    begin
      if lBaseData.piHookPoints[twiTransaction,hpTXHeadCustom2] = thsDisabled
      then hpTXHeadCustomButton := hpTXHeadCustom2;
    end else
    begin
      hpTXHeadCustomButton := hpTXHeadCustom1;
    end;{if}

    if hpTXHeadCustomButton <> 0 then
    begin
      lBaseData.piHookPoints[twiTransaction,hpTXHeadCustomButton] := thsEnabled;
      lBaseData.piCustomText[twiTransaction,hpTXHeadCustomButton] := thsEnabled;
    end;{if}

  end else
  begin
    BaseData.piAuthor := '  ///////////////////////////////////////////////////////';
    BaseData.piSupport := '//// THIS PLUG-IN HAS EXPIRED ////';
    BaseData.piCopyright := '               ///////////////////////////////////////////////////////';
  end;{if}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TTotalQuantity, Class_TotalQuantity,
    ciSingleInstance, tmApartment);
end.
