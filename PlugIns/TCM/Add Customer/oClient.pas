unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  EnterpriseTrade_TLB, ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl
  , Forms, CustDet, Controls, StrUtil, SysUtils, APIUTil;

type
  TAddCustomer = class(TAutoObject, IAddCustomer, ITradeClient)
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

uses
  Windows, PISecure, ComServ;

{ TAddCustomer }

procedure TAddCustomer.OnConfigure(const Config: ITradeConfiguration);
begin

end;

procedure TAddCustomer.OnCustomEvent(const EventData: ITradeEventData);
begin
  if (EventData.edWindowId = twiTransaction) and (EventData.edHandlerId = hpTXHeadCustom1)
  then begin
    frmAddCust := TfrmAddCust.Create(application);
    try
      with frmAddCust, EventData.Transaction do begin
        oBaseData := lBaseData;
        oEventData := EventData;
        lBaseData.Functions.entActivateClient(frmAddCust.Handle);
        if ShowModal = mrOK then begin
          try
            EventData.Transaction.thAcCode := edAccountCode.Text;
          except
          end;
        end;{if}
        SetForegroundWindow(lBaseData.Functions.fnTradehWnd);
      end;
    finally
      frmAddCust.Release;
    end;{try}
  end;{if}
end;

procedure TAddCustomer.OnCustomText(const CustomText: ITradeCustomText);
begin
  if (CustomText.ctWindowId = twiTransaction) and (CustomText.ctTextId = hpTXHeadCustom1)
  then CustomText.ctText := '&Add Customer';
end;

procedure TAddCustomer.OnShutdown;
begin
  lBaseData := nil;
end;

procedure TAddCustomer.OnStartup(const BaseData: ITradeConnectionPoint);
var
  sPlugInName : string;
const
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = 'v7.0.05.009';
//    sVersionNo = 'v6.00.008';
  {$ELSE}
    sVersionNo = 'v5.60.008';
  {$ENDIF}
begin
  if FileExists(WinGetWindowsSystemDir + 'pcode32.dll')
  then sPlugInName := 'Add Customer Plug-In (AFD)'
  else sPlugInName := 'Add Customer Plug-In';

  BaseData.piCustomisationSupport := 'v1.00';
  BaseData.piVersion := sVersionNo;
  BaseData.piName := sPlugInName;

  if PICheckSecurity('EXCHTCMADC000023', 'asS6s!"xcdpd+¬2 ', sPlugInName
  , sVersionNo + ' (TCM)', stSystemOnly, ptTCM, Application.ExeName) then
  begin
    BaseData.piAuthor := 'Advanced Enterprise Software';
    BaseData.piCopyright := GetCopyrightMessage;
    BaseData.piSupport := 'Contact your Exchequer helpline number';
    lBaseData := BaseData;
    with lBaseData do begin
      lBaseData.piHookPoints[twiTransaction,hpTXHeadCustom1] := thsEnabled;
      lBaseData.piCustomText[twiTransaction,hpTXHeadCustom1] := thsEnabled;
    end;{with}
  end else
  begin
    BaseData.piAuthor := '  ///////////////////////////////////////////////////////';
    BaseData.piSupport := '//// THIS PLUG-IN HAS EXPIRED ////';
    BaseData.piCopyright := '               ///////////////////////////////////////////////////////';
  end;{if}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TAddCustomer, Class_AddCustomer,
    ciSingleInstance, tmApartment);
end.
