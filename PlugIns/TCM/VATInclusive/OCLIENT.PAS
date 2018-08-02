unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  EnterpriseTrade_TLB, ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl, StrUtil;

type
  TVATInclusive = class(TAutoObject, IVATInclusive, ITradeClient)
  protected
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;
  private
    lBaseData: ITradeConnectionPoint;
  end;

implementation

uses ComServ;

{ TVATInclusive }

procedure TVATInclusive.OnConfigure(const Config: ITradeConfiguration);
begin

end;

procedure TVATInclusive.OnCustomEvent(const EventData: ITradeEventData);
begin
  if (EventData.edWindowId = twiTransactionLine) and (EventData.edHandlerId = hpTXLineBeforeCalcStockPrice)
  then begin
    if not ((EventData.Transaction.thLines.thCurrentLine.tlVATCode = 'I')
    or (EventData.Transaction.thLines.thCurrentLine.tlVATCode = 'M')) then begin
      if (EventData.Transaction.thCustomer.acVATCode = 'I') then begin
{        EventData.Transaction.thLines.thCurrentLine.tlInclusiveVATCode := EventData.Transaction.thLines.thCurrentLine.tlVATCode;
        EventData.Transaction.thLines.thCurrentLine.tlVATCode := 'I';
        EventData.Transaction.thLines.thCurrentLine.tlVATCode := EventData.Transaction.thCustomer.acInclusiveVATCode;}

//        EventData.Transaction.thLines.thCurrentLine.tlInclusiveVATCode := EventData.Transaction.thLines.thCurrentLine.tlVATCode;
        EventData.Transaction.thLines.thCurrentLine.tlVATCode := 'I';
        EventData.Transaction.thLines.thCurrentLine.tlInclusiveVATCode := EventData.Transaction.thCustomer.acInclusiveVATCode;
      end;{if}
    end;
  end;{if}
end;

procedure TVATInclusive.OnCustomText(const CustomText: ITradeCustomText);
begin

end;

procedure TVATInclusive.OnShutdown;
begin

end;

procedure TVATInclusive.OnStartup(const BaseData: ITradeConnectionPoint);
begin
  lBaseData := BaseData;

  {Find DLL}
  with lBaseData do begin
    lBaseData.piCustomisationSupport := 'v1.00';
    lBaseData.piName := 'VAT Inclusive Plug-In';

    {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
      lBaseData.piVersion := 'v7.0.05.005';
//     lBaseData.piVersion := 'v6.00.004';
    {$ELSE}
      lBaseData.piVersion := 'v5.71.004';
    {$ENDIF}

    lBaseData.piAuthor := 'Advanced Enterprise Software';
    lBaseData.piCopyright := GetCopyrightMessage;
    lBaseData.piSupport := 'Contact your Exchequer helpline number';

    // Enable Hooks
    lBaseData.piHookPoints[twiTransactionLine,hpTXLineBeforeCalcStockPrice] := thsEnabled;
  end;{with}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TVATInclusive, Class_VATInclusive,
    ciSingleInstance, tmApartment);
end.
