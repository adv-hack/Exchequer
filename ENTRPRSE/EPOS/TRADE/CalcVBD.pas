unit CalcVBD;

interface

uses
  EposCnst, SysUtils, Classes, MiscUtil, DLLInc, UseDLLU, StrUtil, MathUtil
  , ETMiscU, EPOSProc;

{$I EXDLLBT.INC}

type
  T2VBDs = Record
    rCurrentVBD : double;
    rCurrentVBDAmount : double;
    sCurrentVBD : string;
    cCurrentVBD : Char;
    rCurrentVBDThreshold : double;
    sNextVBD : string;
    rNextVBDThreshold : double;
    bNextVBDSet : boolean;
  end;

  TDiscountInfo = class
    TKDiscountRec : TBatchDiscRec;
  end;

 function GetVBDs(sCustCode : string6; rValue : double) : T2VBDs;
 function ImplementVBDs(rNetTotal, rTTDValue : double) : boolean;

implementation

function GetVBDs(sCustCode : string6; rValue : double) : T2VBDs;

  function GetVBDFromDiscRec(TKDiscountRec : TBatchDiscRec) : double;
  begin{GetVBDAmountFromDiscRec}
    if not ZeroFloat(TKDiscountRec.DiscAmt) then
    begin
      Result := TKDiscountRec.DiscAmt
    end else
    begin
      Result := TKDiscountRec.DiscPer;
    end;{if}
  end;{GetVBDAmountFromDiscRec}

  function GetVBDAmountFromDiscRec(TKDiscountRec : TBatchDiscRec) : double;
  begin{GetVBDAmountFromDiscRec}
    if not ZeroFloat(TKDiscountRec.DiscAmt) then
    begin
      Result := TKDiscountRec.DiscAmt
    end else
    begin
//      Result := (rValue * (TKDiscountRec.DiscPer / 100));
      Result := Round_Up((rValue * (TKDiscountRec.DiscPer / 100)), 2);
    end;{if}
  end;{GetVBDAmountFromDiscRec}

  function GetVBDStringFromDiscRec(TKDiscountRec : TBatchDiscRec) : string;
  begin{GetVBDStringFromDiscRec}
    if not ZeroFloat(TKDiscountRec.DiscAmt) then
    begin
      Result := sCurrencySym + MoneyToStr(TKDiscountRec.DiscAmt);
    end else
    begin
      Result := MoneyToStr(TKDiscountRec.DiscPer) + '%'
    end;{if}
  end;{GetVBDStringFromDiscRec}

  function GetVBDTypeFromDiscRec(TKDiscountRec : TBatchDiscRec) : Char;
  begin{GetVBDStringFromDiscRec}
    if not ZeroFloat(TKDiscountRec.DiscAmt) then
    begin
      Result := #0
    end else
    begin
      Result := '%'
    end;{if}
  end;{GetVBDStringFromDiscRec}

var
  TKDiscountRec : TBatchDiscRec;
  iCCY, iPos, iStatus : integer;
  slDiscounts : TStringList;
  DiscountInfo : TDiscountInfo;
  sKey : string;
  bFoundDatedDiscount : boolean;

const
  CCY_TILL = 1;
  CCY_CONSOLID = 0;

begin
//  Result.CurrentVBD := 1;
//  Result.NextVBD := 2;
//  Result.NextVBDThreshold := 20;

  if Trim(sCustCode) = '' then exit;

  // initialise
  FillChar(Result, SizeOf(Result), #0);
  slDiscounts := TStringList.Create;
  bFoundDatedDiscount := FALSE;

  // Look for Till CCY, then Consolidated CCY Discouhts
  For iPos := CCY_TILL downto CCY_CONSOLID do
  begin
    if iPos = CCY_TILL then iCCY := SetupRecord.TillCurrency;
    if iPos = CCY_CONSOLID then iCCY := CCY_CONSOLID;

    // Read all VBDs for this customer from the toolkit
    FillChar(TKDiscountRec, SizeOf(TKDiscountRec), #0);
    TKDiscountRec.CustCode := sCustCode;
    TKDiscountRec.DiscType := 'V';
    iStatus := Ex_GetDiscMatrix(@TKDiscountRec, SizeOf(TKDiscountRec), 0, B_GetGEq, FALSE);
    while (iStatus = 0) and (TKDiscountRec.CustCode = sCustCode) and (TKDiscountRec.DiscType = 'V') do
    begin
      // Check Currency of Discount
      if (TKDiscountRec.VBCurrency = iCCY) then
      begin
        // Check Date Range of Discount
        if (not TKDiscountRec.UseDates)
        or ((Trunc(Date) >= Str8ToDate(TKDiscountRec.StartDate))
        and (Trunc(Date) <= Str8ToDate(TKDiscountRec.EndDate))) then
        begin
          if TKDiscountRec.UseDates then bFoundDatedDiscount := TRUE;
          DiscountInfo := TDiscountInfo.Create;
          DiscountInfo.TKDiscountRec := TKDiscountRec;
          sKey := PadString(psLeft, MoneyToStr(TKDiscountRec.VBThreshold), '0', 20);
          slDiscounts.AddObject(sKey, DiscountInfo);

          if iPos = CCY_CONSOLID then
          begin
            // Convert Consolidated Values to till currency
            Ex_ConvertAmount(CCY_CONSOLID, SetupRecord.TillCurrency, DiscountInfo.TKDiscountRec.DiscAmt, 0);
            Ex_ConvertAmount(CCY_CONSOLID, SetupRecord.TillCurrency, DiscountInfo.TKDiscountRec.VBThreshold, 0);
          end;
        end;{if}
      end;{if}

      // Get Next
      iStatus := Ex_GetDiscMatrix(@TKDiscountRec, SizeOf(TKDiscountRec), 0, B_GetNext, FALSE);
    end;{while}

    // If we have found some discounts for the till xurrency, we don't look at the consolidated ones
    if (iPos = CCY_TILL) and (slDiscounts.Count > 0) then break;
  end;{for}

  // If we find ANY dated discounts, no matter whether they match our TX Date or not
  // , ignore all the non-dated discounts that we have found
  if bFoundDatedDiscount then
  begin
    iPos := 0;
    while iPos < slDiscounts.Count do
    begin
      if not TDiscountInfo(slDiscounts.Objects[iPos]).TKDiscountRec.UseDates then
      begin
        // Delete Discount
        TDiscountInfo(slDiscounts.Objects[iPos]).Free;
        slDiscounts.delete(iPos);
      end else
      begin
        // Next
        Inc(iPos);
      end;
    end;{while}
  end;{if}

  // Sort VBDs, and set result
  if slDiscounts.Count > 0 then
  begin
    slDiscounts.Sort;
    For iPos := 0 to slDiscounts.Count-1 do
    begin
      TKDiscountRec := TDiscountInfo(slDiscounts.Objects[iPos]).TKDiscountRec;

      // Is this the discount to apply to this transaction ?
      if (rValue >= TKDiscountRec.VBThreshold) or (ZeroFloat(rValue - TKDiscountRec.VBThreshold))
      then begin
        Result.rCurrentVBD := GetVBDFromDiscRec(TKDiscountRec);
        Result.cCurrentVBD := GetVBDTypeFromDiscRec(TKDiscountRec);
        Result.sCurrentVBD := GetVBDStringFromDiscRec(TKDiscountRec);
        Result.rCurrentVBDThreshold := TKDiscountRec.VBThreshold;
        Result.rCurrentVBDAmount := GetVBDAmountFromDiscRec(TKDiscountRec);
      end;

      // Is this the Next VBD which could apply to this transaction ?
      if (not Result.bNextVBDSet) and (rValue < TKDiscountRec.VBThreshold) and (not ZeroFloat(rValue - TKDiscountRec.VBThreshold))then
      begin
        Result.sNextVBD := GetVBDStringFromDiscRec(TKDiscountRec);
//        if ZeroFloat(TKDiscountRec.DiscAmt) then Result.NextVBD := MoneyToStr(TKDiscountRec.DiscPer) + '%'
//        else Result.NextVBD := sCurrencySym + MoneyToStr(TKDiscountRec.DiscAmt);
        Result.rNextVBDThreshold := TKDiscountRec.VBThreshold;
        Result.bNextVBDSet := TRUE;
      end;{if}
    end;{for}

    ClearList(slDiscounts);
  end;{if}

  // Clear Up
  slDiscounts.Free;
end;

function ImplementVBDs(rNetTotal, rTTDValue : double) : boolean;
begin
  Result := TRUE;

  // Check if we are about to create an SRF/SCR, which VBDs do not get implemented on.
  if (SetupRecord.NegativeTXType = 1) {Create SRFs and SCRs}
  and (rNetTotal < 0) and (not zerofloat(rNetTotal)) then
  begin
    Result := FALSE;
    exit;
  end;{if}

  // Check if VBD Has been disabled in Exchequer
  if (not TKSysRec.VBDEnabled) {VBD Disabled} then
  begin
    Result := FALSE;
    exit;
  end;{if}

  // Check if we are in the correct discount mode
{  if (SetupRecord.DiscountType <> 1) then {not "Use and modify Exchequer Discounts"}
{  begin
    Result := FALSE;
    exit;
  end;{if}

  // Check to see if TTD Has been implemented (this overrides VBD)
  if not ZeroFloat(rTTDValue) then
  begin
    Result := FALSE;
    exit;
  end;{if}
end;

end.
