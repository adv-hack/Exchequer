unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  PISecure, Dialogs, SysUtils, Classes, Forms, Math, PIMisc, ChainU, ropopup, ExchequerRelease;

var
  bPlugInEnabled: boolean;

procedure AutoSetReorder(Const EventData : TAbsEnterpriseSystem); forward;
procedure PurchasePackPopup(Const EventData : TAbsEnterpriseSystem); forward;

Const
  PlugInName = 'Exchequer Re-Order Qty Round-up Plug-In';
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '107';
//    sVersionNo = 'v6.00.105';
  {$ELSE}
    sVersionNo = 'v5.71.105';
  {$ENDIF}
  EventDisabled = 0;
  EventEnabled  = 1;
  // Handler IDs
  ExitOrderQuantity = 51;
  AutoSetROQty = 52;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  slAboutText : TStringList;
  iPos : integer;
Begin
  CustomOn := FALSE;

  bPlugInEnabled:= PICheckSecurity('EXCHREORDR000019', 'f0Efgz[2 /,d3F£1'
  ,PlugInName, '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  { Enable Hooks and Set About Message here }
  if bPlugInEnabled then
  begin
    with CustomHandlers do
    begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(PlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      slAboutText.Free;

      // Set handler on Stock ReOrder - On Change Item.
      SetHandlerStatus(wiStock, ExitOrderQuantity, EventEnabled);   // Route 2

      // Set handler on Stock ReOrder - Auto Set ReOrder Qty.
      SetHandlerStatus(wiStock, AutoSetROQty, EventEnabled);
    end;
  end;{if}

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;
  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  if bPlugInEnabled then
  begin
    { Handle Hook Events here }
    with EventData do
    begin
      if (WinID = wiStock) then
      begin
        case HandlerID of
          ExitOrderQuantity : // Route 2 - popup window.
            begin
              PurchasePackPopup(EventData);
            end;
          AutoSetROQty :  // Route 1 - Auto-Set.
            begin
              AutoSetReorder(EventData);
            end;
        end; // case HandlerID of
      end; // if (WinID = wiStock) then
    end; // with EventData do
    { Pass onto other Hook DLL's }
  end;{if}

  DLLChain.ExecCustomHandler(EventData);
End;

procedure AutoSetReorder(Const EventData : TAbsEnterpriseSystem);
var
  rPackSize, rReOrderQty,
  rPackDivider, rPackFraction,
  rQtyRoundedToPack : Real48;
  iPackMultiplier : integer;
begin
  if (trim(EventData.Stock.stStkUser4) <> '') then
  begin
    rPackSize := StrToFloat(EventData.Stock.stStkUser4);
    rReOrderQty := EventData.Stock.stReOrderQty;

    rPackDivider := rReOrderQty / rPackSize;
    rPackFraction := frac(rPackDivider);

    if (rPackFraction <> 0) then
    begin
      // Makes sure that iPackMultiplier is rounded to nearest whole pack
      // NOTE: that 0.5 rounds UP.
      if (rPackFraction >= 0.5) then
        iPackMultiplier := Ceil(rPackDivider)
      else
        iPackMultiplier := Floor(rPackDivider);
      
      rQtyRoundedToPack := rPackSize * iPackMultiplier;
      EventData.Stock.stReOrderQty :=
                                  EventData.entRound(rQtyRoundedToPack,EventData.Setup.ssNoQtyDec);
    end;
  end; // if (trim(EventData.Stock.stStkUser4) <> '') then
end;

procedure PurchasePackPopup(Const EventData : TAbsEnterpriseSystem);
var
  frmQtyPopup: TfrmQtyPopup;
  rPackSize, rReOrderQty,
  rPackDivider, rPackFraction,
  rQtyRoundedToPack, rMaxStockQty : Real48;
  iPackMultiplier : integer;
begin
  if (trim(EventData.Stock.stStkUser4) <> '') then
  begin
    rPackSize := StrToFloat(EventData.Stock.stStkUser4);
    rMaxStockQty := EventData.Stock.stQtyMax;
    rReOrderQty := EventData.Stock.stReOrderQty;

    rPackDivider := rReOrderQty / rPackSize;
    rPackFraction := frac(rPackDivider);

    if (rPackFraction <> 0) then
    begin
      // Makes sure that iPackMultiplier is rounded to nearest whole pack
      // NOTE: that 0.5 rounds UP.
      if (rPackFraction >= 0.5) then
        iPackMultiplier := Ceil(rPackDivider)
      else
        iPackMultiplier := Floor(rPackDivider);

      rQtyRoundedToPack := rPackSize * iPackMultiplier;

      frmQtyPopup := TfrmQtyPopup.Create(Application);
      with frmQtyPopup do
      begin
        try
          Caption := 'Purchase pack ('+EventData.Stock.stCode+')';
          edtMaxStock.Text := FloatToStr(rMaxStockQty);
          edtPurchasePack.Text := FloatToStr(rPackSize);
          edtQtyRounded.Text :=
                      FloatToStr(EventData.entRound(rQtyRoundedToPack,EventData.Setup.ssNoQtyDec));
          ShowModal;
          EventData.Stock.stReOrderQty :=
                                  EventData.entRound(rQtyRoundedToPack,EventData.Setup.ssNoQtyDec);
        finally
          Release;
        end; // try...finally
      end; // with frmQtyPopup do

    end; // if ( frac(rPackDivider) <> 0) then
  end; // if (trim(EventData.Stock.stStkUser4) <> '') then
end;

end.
