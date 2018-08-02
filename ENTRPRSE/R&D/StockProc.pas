unit StockProc;

interface
  function FilterSerialBinByLocation(bSysSetupFlag, bSales, bSalesOnlyHook : boolean) : boolean;
  function ChemilinesStockLocHookEnabled : boolean;

implementation
{$IFDEF CU}
uses
  Event1U;
{$ENDIF}

function FilterSerialBinByLocation(bSysSetupFlag, bSales, bSalesOnlyHook : boolean) : boolean;
begin
  if bSysSetupFlag then
  begin
    // The flag is on in system setup
    if bSalesOnlyHook then
    begin
      // Since the hook is enabled, the Filter is only on, if it is a sales transaction
      Result := bSales;
    end else
    begin
      // The Filter is on, as the hook is not enabled
      Result := TRUE;
    end;
  end else
  begin
    // The flag is off in system setup, so it doesn't matter what else. the filter is off
    Result := FALSE;
  end;{if}
end;

function ChemilinesStockLocHookEnabled : boolean;
begin
  {$IFDEF CU}
    Result := EnableCustBtns(3100, 5);
  {$ELSE}
    Result := FALSE;
  {$ENDIF}
end;


end.
 