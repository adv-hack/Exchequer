unit oClient;

{ nfrewer440 12:21 21/01/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EnterpriseTradePlugIn_TLB, StdVcl, EnterpriseTrade_TLB, Swipe;

type
  TPDQWedge = class(TAutoObject, IPDQWedge, ITradeClient)
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
  Dialogs, StrUtil, Windows, Controls, Forms, ComServ, PISecure;

{ TPDQWedge }

procedure TPDQWedge.OnConfigure(const Config: ITradeConfiguration);
begin

end;

procedure TPDQWedge.OnCustomEvent(const EventData: ITradeEventData);
begin
  if (EventData.edWindowId = twiCreditCard) and (EventData.edHandlerId = hpCreditCardBeforeShow)
  then begin
//    ShowMessage('twiCreditCard.hpCreditCardBeforeShow');
    frmSwipe := TfrmSwipe.Create(application);
    try
      frmSwipe.lEventData := EventData;
      frmSwipe.lBaseData := lBaseData;
      lBaseData.Functions.entActivateClient(frmSwipe.Handle);
      EventData.edBoolResult[2] := FrmSwipe.ShowModal = mrCancel;
      EventData.edBoolResult[1] := TRUE;

      if not EventData.edBoolResult[2]
      then EventData.Transaction.thTender.teCardDetails.cdAuthorisationCode := frmSwipe.sAuthCode;

{      if not EventData.edBoolResult[2] then begin
        EventData.Transaction.thTender.teCardDetails.cdAuthorisationCode := '654';
        EventData.Transaction.thTender.teCardDetails.cdCardName := 'MR J BLOGGS';
        EventData.Transaction.thTender.teCardDetails.cdCardNumber := '7119 4331 2342 1299';
        EventData.Transaction.thTender.teCardDetails.cdCardType := 1;
        EventData.Transaction.thTender.teCardDetails.cdExpiryDate := '12/05';
      end;{if}
    finally
      FrmSwipe.Release;
    end;{try}

    SetForegroundWindow(lBaseData.Functions.fnTradehWnd);
  end;{if}
end;

procedure TPDQWedge.OnCustomText(const CustomText: ITradeCustomText);
begin

end;

procedure TPDQWedge.OnShutdown;
begin
  lBaseData := nil;
end;

procedure TPDQWedge.OnStartup(const BaseData: ITradeConnectionPoint);
const
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = 'v7.0.5.014';
//    sVersionNo = 'v6.00.013';
  {$ELSE}
    sVersionNo = 'v5.60.013';
  {$ENDIF}
  sPlugInName = 'Commidea RTI Plug-In';
begin
  BaseData.piCustomisationSupport := 'v1.00';
  BaseData.piVersion := sVersionNo;
  BaseData.piName := sPlugInName;

  if PICheckSecurity('EXCHTCMWTI000024', 'j23F9bb<-as@`D%Y', sPlugInName
  , sVersionNo + ' (TCM)', stSystemOnly, ptTCM, Application.ExeName) then
  begin
    BaseData.piAuthor := 'Advanced Enterprise Software';
    BaseData.piCopyright := GetCopyrightMessage;
    BaseData.piSupport := 'Contact your Exchequer helpline number';
    lBaseData := BaseData;
    with lBaseData do begin
      lBaseData.piHookPoints[twiCreditCard,hpCreditCardBeforeShow] := thsEnabled;
    end;{with}
  end else
  begin
    BaseData.piAuthor := '  ///////////////////////////////////////////////////////';
    BaseData.piSupport := '//// THIS PLUG-IN HAS EXPIRED ////';
    BaseData.piCopyright := '               ///////////////////////////////////////////////////////';
  end;{if}
end;

initialization
  TAutoObjectFactory.Create(ComServer, TPDQWedge, Class_PDQWedge,
    ciSingleInstance, tmApartment);
end.
