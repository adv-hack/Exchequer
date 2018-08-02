unit ValCfg;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

  procedure ValidatePrinting(var sMessage : string);
  procedure ValidateGLCodes(var sMessage : string);
  procedure ValidateDefaults(var sMessage : string);
  procedure ValidateCCDept(var sMessage : string);
  function CheckGLCurrency(var sMessage : string) : boolean;

implementation
uses
  TKUtil, EPOSCnst, SysUtils, EntLkup, StrUtil, EPOSProc, UseDLLU, BtrvU2, DLLInc;

procedure ValidatePrinting(var sMessage : string);
begin
  {Printing Tab}
  with SetupRecord do begin
    {Check Receipt Form Name}
{$IFDEF EX600}
    if (not FileExists(sCurrCompPath + 'FORMS\' + ReceiptFormName + '.EFX'))
{$ELSE}
    if (not FileExists(sCurrCompPath + 'FORMS\' + ReceiptFormName + '.EFD'))
{$ENDIF}
    and ((not FileExists(sCurrCompPath + 'FORMS\' + ReceiptFormName + '.DEF'))
    or (not FileExists(sCurrCompPath + 'FORMS\' + ReceiptFormName + '.LST'))) then
      begin
        sMessage := 'Receipt Form Name';
      end
    else begin
      {Check Invoice Form Name}
{$IFDEF EX600}
      if (not FileExists(sCurrCompPath + 'FORMS\' + InvoiceFormName + '.EFX')) {.308}
{$ELSE}
      if (not FileExists(sCurrCompPath + 'FORMS\' + InvoiceFormName + '.EFD'))
{$ENDIF}
      and ((not FileExists(sCurrCompPath + 'FORMS\' + InvoiceFormName + '.DEF'))
      or (not FileExists(sCurrCompPath + 'FORMS\' + InvoiceFormName + '.LST'))) then
        begin
          sMessage := 'Invoice Form Name';
        end
      else begin
        {Check Order Form Name}
        if SetupRecord.TransactionType in [1,2] then begin // only validate if creating SORs
{$IFDEF EX600}
          if (not FileExists(sCurrCompPath + 'FORMS\' + OrderFormName + '.EFX')) {.308}
{$ELSE}
          if (not FileExists(sCurrCompPath + 'FORMS\' + OrderFormName + '.EFD'))
{$ENDIF}
          and ((not FileExists(sCurrCompPath + 'FORMS\' + OrderFormName + '.DEF'))
          or (not FileExists(sCurrCompPath + 'FORMS\' + OrderFormName + '.LST'))) then begin
              sMessage := 'Order Form Name';
          end;{if}
        end;{if}
      end;{if}
    end;{if}
  end;{with}
end;{ValidatePrinting}

procedure ValidateGLCodes(var sMessage : string);
var
  iNom : integer;
  sNom : string;
  sStockCode : string20;
begin
  {G/L Codes Tab}
  with SetupRecord do begin
    {Check Cash Payment G/L Code}
    iNom := MOPNomCodes[pbCash];
    sNom := IntToStr(iNom);
    if (not DoGetNom(nil{Self}, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet]
    , vmCheckValue, TRUE)) then
      begin
        sMessage := 'Cash Payment G/L Code';
      end
    else begin
      {Check Cheque Payment G/L Code}
      iNom := MOPNomCodes[pbCheque];
      sNom := IntToStr(iNom);
      if (not DoGetNom(nil{Self}, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet]
      , vmCheckValue, TRUE)) then
        begin
          sMessage := 'Cheque Payment G/L Code';
        end
      else begin
        {Check Write-Off G/L Code}
        iNom := WriteOffNomCode;
        sNom := IntToStr(iNom);
        if (not DoGetNom(nil{Self}, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet]
        , vmCheckValue, TRUE)) then
          begin
            sMessage := 'Write-Off G/L Code';
          end
        else begin
          if TakeNonStockDefaultFrom = 0 then
            begin
              {Check Non-Stock Default G/L Code}
              iNom := DefNonStockNomCode;
              sNom := IntToStr(iNom);
              if (not DoGetNom(nil{Self}, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet]
              , vmCheckValue, TRUE)) then sMessage := 'Non-Stock Default G/L Code';
            end
          else begin
            sStockCode := NonStockItemCode;
            if (not DoGetStock(nil, sCurrCompPath, sStockCode, sStockCode, [stkProduct, stkBOM]
            , vmCheckValue, TRUE)) then sMessage := 'Non-Stock Stock Code';
          end;
        end;{if}
      end;{if}
    end;{if}
  end;{with}
end;{ValidateGLCodes}

procedure ValidateDefaults(var sMessage : string);
var
  sLocation : string10;
begin
  {Defaults Tab}
  with SetupRecord do begin
    {Check Stock Location}
    sLocation := DefStockLocation;
    if (TKSysRec.MultiLocn > 0) and (not DoGetMLoc(nil{Self}, sCurrCompPath, sLocation, sLocation
    , vmCheckValue, TRUE)) then sMessage := 'Stock Location';
  end;{with}
end;{ValidateDefaults}

procedure ValidateCCDept(var sMessage : string);
var
  sCCDept : string20;
begin
  {Validate CC / Dept Tab}

  with SetupRecord do begin
    if (TKSysRec.CCDepts) then begin
      {Check Cost Centre}
      sCCDept := DefCostCentre;
      if not DoGetCCDep(nil, sCurrCompPath, sCCDept, sCCDept, TRUE, vmCheckValue, TRUE)
      then sMessage := 'Default Cost Centre'
      else begin
        {Check Department}
        sCCDept := DefDepartment;
        if not DoGetCCDep(nil, sCurrCompPath, sCCDept, sCCDept, FALSE, vmCheckValue, TRUE)
        then sMessage := 'Default Department';
      end;{if}
    end;{if}
  end;{with}
end;{ValidateDefaults}

function CheckGLCurrency(var sMessage : string) : boolean;

  function CorrectCurrency(iNom : integer) : boolean;
  var
    GLCodeRec : TBatchNomRec;
    pKey : PChar;
    iStatus : SmallInt;
  begin
    Result := FALSE;
    pKey := StrAlloc(255);
    StrPCopy(pKey, IntToStr(iNom));
    iStatus := EX_GETGLACCOUNT(@GLCodeRec, SizeOf(GLCodeRec),pKey,0,B_GetEq,FALSE);
    ShowTKError('EX_GETGLACCOUNT', 44, iStatus);
    if iStatus = 0 then begin
      if (GLCodeRec.DefCurr = 0) or (GLCodeRec.DefCurr = SetupRecord.TillCurrency) then Result := TRUE;
    end;{if}
    StrDispose(pKey);
  end;{CorrectCurrency}

var
  iPos : integer;

begin
  Result := TRUE;
  with SetupRecord do begin
    {G/L Codes Tab}
    if not CorrectCurrency(MOPNomCodes[pbCash]) then begin
      sMessage := 'Cash Payment G/L Code';
      Result := FALSE;
    end;{if}

    if Result and (not CorrectCurrency(MOPNomCodes[pbCheque])) then begin
      sMessage := 'Cheque Payment G/L Code';
      Result := FALSE;
    end;{if}

    if Result and (not CorrectCurrency(WriteOffNomCode)) then begin
      sMessage := 'Write-Off G/L Code';
      Result := FALSE;
    end;{if}

    if Result and (TakeNonStockDefaultFrom = 0)
    and (not CorrectCurrency(DefNonStockNomCode)) then begin
      sMessage := 'Non-Stock Default G/L Code';
      Result := FALSE;
    end;{if}

    {Check Credit Card's Currency's}
    if Result then begin
      iPos := 0;
      while (iPos < 20) and Result do begin
        if CreditCards[iPos].Desc <> '' then begin
          if (not CorrectCurrency(CreditCards[iPos].GLCode)) then begin
            sMessage := 'Credit Card "' + CreditCards[iPos].Desc + '" GL Code';
            Result := FALSE;
          end;{if}
        end;{if}
        Inc(iPos);
      end;{while}
    end;{if}
  end;{with}
end;{CheckGLCurrency}


end.
