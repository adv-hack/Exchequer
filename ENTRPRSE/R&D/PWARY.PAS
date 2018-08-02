

  With PWTreeGrpAry[1] do
  Begin
    tCaption:='Sales';

  end;


  With PWTreeGrpAry[10] do
  Begin
    tCaption:='Sales Transactions';
    PWLink:='019355 019356 019410 019357 019358 019359 019360 019361 019362 019363 010342 019256 019260 019309 019310 048107 048143';
    IsChild:=1;

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 019505';
    {$ENDIF}

  end;

  With PWTreeGrpAry[20] do
  Begin
    tCaption:='Sales Daybook';
    IsChild:=1;
    PWLink:='010001 010303 010304 012002 013003 014004 015005 016006 017007 017283 018008 019009 019094 019101 019187';

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 019505';
    {$ENDIF}

  end;

  With PWTreeGrpAry[30] do
  Begin
    tCaption:='Sales Orders';
    IsChild:=1;
    PWLink:='';

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With PWTreeGrpAry[40] do
  Begin
    tCaption:='Sales Order Transactions';
    IsChild:=2;
    PWLink:='035258 035259 035344';

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

    {$IFDEF WOP}
      If FullWOP then
        PWLink:=PWLink+' 035354';
    {$ENDIF}



  end;

  With PWTreeGrpAry[50] do
  Begin
    tCaption:='Sales Order Daybook';
    IsChild:=2;

    PWLink:='035144 035307 035145 035156 035157 035158 035159 035160 035161 035162 035425 035163 035183 035184 035185 035186 035311 ';

    {$IFNDEF LTE}
      PWLink:=PWLink+'035245 035346 035347 035348';
    {$ENDIF}  

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 035507';
    {$ENDIF}

  end;


  With PWTreeGrpAry[60] do
  Begin
    tCaption:='Sales Order Commitment';
    IsChild:=2;
    PWLink:='035268 035270 035271 048274';


    {$IF Not Defined(SOP) or Defined(LTE)}
      Exclude:=BOn;

    {$ELSE}
       If (Not CommitAct) then
         PWLink:='035271';

    {$IFEND}

  end;


  With PWTreeGrpAry[70] do
  Begin
    tCaption:='TeleSales Module';
    IsChild:=2;
    PWLink:='035245 035346 035347 035348';



    {$IFNDEF SOP}
      Exclude:=BOn;

    {$ELSE}
      Exclude:=Not TeleSModule;
    {$ENDIF}

  end;

  //PR: 29/07/2014 Order Payments T013
  With PWTreeGrpAry[72] do
  Begin
    tCaption:='Order Payments';
    IsChild:=2;
    PWLink := Format('%s %s %s %s %s %s %s %s ', [uasSORAllowOrderPaymentsPayment, uasSORDefaultOrderPaymentsPaymentOn,
                                                  uasSORAllowOrderPaymentsRefund,  uasSDNAllowOrderPaymentsPayment,
                                                  uasSINAllowOrderPaymentsPayment, uasSINAllowOrderPaymentsRefund,
                                                  uasAllowCreditCardPayment,       uasAllowCreditCardRefund]);



    {$IFNDEF SOP}
      Exclude:=True;
    {$ELSE}  //Not available for Cash Accounting system
      // MH 03/12/2014 ABSEXCH-15838: Suppress Order Payments permissions for non-UK companies
      // MH 17/06/2015 Exch-R1 ABSEXCH-16543: Hide Order Payments entries if Order Payments turned off
      Exclude := (Not Syss.ssEnableOrderPayments) Or VAT_CashAcc(SyssVAT.VATRates.VATScheme) Or (CurrentCountry <> UKCCode);
    {$ENDIF}

  end;



  With PWTreeGrpAry[80] do
  Begin
    tCaption:='Customers';
    IsChild:=1;
    PWLink:='';

  end;


  With PWTreeGrpAry[90] do
  Begin
    tCaption:='Customer Records';
    IsChild:=2;
    PWLink:='042031 042032 ' + uasCustomerViewBankDets + ' 042240 042241 042034 042035 042039 ' + uasEditCustomerRoles;

    //PR: 29/07/2014 Order Payments T013
    {$IFDEF SOP}
      // MH 03/12/2014 ABSEXCH-15838: Suppress Order Payments permissions for non-UK companies
      // MH 17/06/2015 Exch-R1 ABSEXCH-16543: Hide Order Payments entries if Order Payments turned off
      if Syss.ssEnableOrderPayments And (not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And (CurrentCountry = UKCCode) then
        PWLink := PWLink + ' ' + uasCustomerAllowOrderPaymentEdit;
    {$ENDIF}
  end;


  With PWTreeGrpAry[100] do
  Begin
    tCaption:='Customer Discounts';
    IsChild:=2;
    PWLink:='042047 042287 042288 042289 042290 042291';

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}
  end;


  With PWTreeGrpAry[110] do
  Begin
    tCaption:='Customer Miscellaneous';
    IsChild:=2;

    {$IFDEF WOP}
      If WOPOn then
        WOPStr:=' 042353';
    {$ENDIF}

    {$IFDEF JAP}
      If (JAPOn) then
        JAPStr:=' 042463';


    {$ENDIF}

    {$IFDEF RET}
      If (RetMOn) then
        RetStr:=' 042509';
    {$ENDIF}


    // CJS 08/03/2011 v6.7 ABSEXCH-10901
    PWLink:='042030 042033 042036 042595 042037'+WOPStr+JAPStr+RetStr+' 042038 042404 042047 042104 042142 042202 042254 042281 042285 042411 042412';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 042470';
    {$ENDIF}

    WOPStr:='';
    JAPStr:='';
    RETStr:='';
  end;


  With PWTreeGrpAry[120] do
  Begin
    tCaption:='Batch Payments/Receipts';
    IsChild:=1;
    PWLink:='051150 051151 051152 051153 051154 051155 051264 051265';

  end;


  With PWTreeGrpAry[150] do
  Begin
    tCaption:='Purchase';
    IsChild:=0;
  end;


  With PWTreeGrpAry[160] do
  Begin
    tCaption:='Purchase Transactions';

    PWLink:='029364 029365 029413 029366 029367 029368 029369 029370 029371 029372 020343 028257 028261 048107';

    IsChild:=1;

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 028506';
    {$ENDIF}

  end;

  With PWTreeGrpAry[170] do
  Begin
    tCaption:='Purchase Daybook';
    IsChild:=1;
    // CJS 2013-08-02 - ABSEXCH-14408 - Added entry for 'Enforce Hold Flag' (020600)
    HoldStr := '';
    if (WebExtEProcurementOn) then
      HoldStr := '020600 ';
    PWLink:='020010 020305 020306 021011 022012 023013 024014 025015 ' + HoldStr + '026016 026284 027017 028018 028095 028102 028192';

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 028506';
    {$ENDIF}

  end;



  With PWTreeGrpAry[180] do
  Begin
    tCaption:='Purchase Orders';
    IsChild:=1;
    PWLink:='';

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With PWTreeGrpAry[190] do
  Begin
    tCaption:='Purchase Order Transactions';
    IsChild:=2;
    PWLink:='036262 036263 036345';


    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With PWTreeGrpAry[200] do
  Begin
    tCaption:='Purchase Order Daybook';
    IsChild:=2;
    PWLink:='036164 036308 036165 036166 036167 036168 036169 036170 036171 036172 036426 036173 036188 036189 036190 036191';

    {$IFNDEF SOP}
      Exclude:=BOn;
    {$ENDIF}

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 036508';
    {$ENDIF}

  end;


  With PWTreeGrpAry[210] do
  Begin
    tCaption:='Purchase Order Commitment';
    IsChild:=2;
    PWLink:='036269 036272 036273 048274';

    {$IF Not Defined(SOP) or Defined(LTE)}
      Exclude:=BOn;

    {$ELSE}
      If (Not CommitAct) then
        PWLink:='036273';

    {$IFEND}

  end;


  With PWTreeGrpAry[220] do
  Begin
    tCaption:='Suppliers';
    IsChild:=1;
    PWLink:='';

  end;


  With PWTreeGrpAry[230] do
  Begin
    tCaption:='Supplier Records';
    IsChild:=2;
    PWLink:='043041 043042 ' + uasSupplierViewBankDets + ' 043242 043243 043044 043045 043049 ' + uasEditSupplierRoles;

    If (CISOn) then
      PWLink:=PWLink+' 043249';

  end;


  With PWTreeGrpAry[240] do
  Begin
    tCaption:='Supplier Discounts';
    IsChild:=2;
    PWLink:='043180 043292 043293 043294 043295 043296';

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With PWTreeGrpAry[250] do
  Begin
    tCaption:='Supplier Miscellaneous';
    IsChild:=2;

    {$IFDEF JAP}
      If (JAPOn) then
        JAPStr:=' 043464';
    {$ENDIF}

    {$IFDEF RET}
      If (RetMOn) then
        RetStr:=' 043510';
    {$ENDIF}

    // CJS 08/03/2011 v6.7 ABSEXCH-10901
    PWLink:='043040 043043 043046 043596 043048 043424'+JAPStr+RETStr+' 043105 043179 043180 043181 043204 043255 043282 043286 043414 043415 ';

    {$IFNDEF LTE}
      PWLink:=PWLink+'043471';
    {$ENDIF}  

    JAPStr:='';
    RETStr:='';
  end;


  With PWTreeGrpAry[260] do
  Begin
    tCaption:='Batch Payments';
    IsChild:=1;
    PWLink:='051150 051151 051152 051153 051154 051155 051264';

  end;


  With PWTreeGrpAry[280] do
  Begin
    tCaption:='General Ledger';
    IsChild:=0;
  end;

  With PWTreeGrpAry[290] do
  Begin
    tCaption:='Miscellaneous';
    IsChild:=1;

    PWLink:='030098 030099 030106';

    {$IFNDEF LTE}
      PWLink:='030019 '+PWLink;
    {$ENDIF}
    

  end;


  With PWTreeGrpAry[300] do
  Begin
    tCaption:='General Ledger Tree';
    IsChild:=1;
    PWLink:='031020';



  end;


  With PWTreeGrpAry[310] do
  Begin
    tCaption:='General Ledger Accounts';
    IsChild:=1;
    PWLink:='031021 031022 031023 031196 031197';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 031198';

    {$ENDIF}
    
  end;

  With PWTreeGrpAry[312] do
  Begin
    tCaption:='General Ledger Views';
    IsChild:=1;
    PWLink:='031546';

    {$IFDEF LTE}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With PWTreeGrpAry[314] do
  Begin
    tCaption:='View Control Records';
    IsChild:=2;
    PWLink:='031547 031548 031549 031550 031551';

    {$IFDEF LTE}
      Exclude:=BOn;
    {$ENDIF}

  end;

  With PWTreeGrpAry[316] do
  Begin
    tCaption:='View Line Records';
    IsChild:=2;

    PWLink:='031552 031553 031554 031555 031556 031568';

    {$IFDEF LTE}
      Exclude:=BOn;
    {$ENDIF}

  end;

    With PWTreeGrpAry[318] do
  Begin
    tCaption:='User Access';
    IsChild:=2;

    PWLink:='031557 031558 031559 031560 031561 031562 031563 031564 031565 031566';

    {$IFDEF LTE}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With PWTreeGrpAry[320] do
  Begin
    tCaption:='Nominal Transfers';
    IsChild:=1;
    PWLink:='032024 032572 032025 032026 032027 032028 032029 032096 032103 032140 032338';


  end;


  With PWTreeGrpAry[340] do
  Begin
    tCaption:='Reports';
    IsChild:=1;

  end;

  With PWTreeGrpAry[350] do
  Begin
    tCaption:='Posting';
    IsChild:=2;
    PWLink:='061080';

  end;


  With PWTreeGrpAry[360] do
  Begin
    tCaption:='G/L Based';
    IsChild:=2;
    PWLink:='052062 052063 052064 052065 052066 052067 052068';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 052100';
    {$ENDIF}
     
  end;


  With PWTreeGrpAry[380] do
  Begin
    tCaption:='Stock';
    IsChild:=0;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With PWTreeGrpAry[390] do
  Begin
    tCaption:='Miscellaneous';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='039109 041124 041125 048182';

    {$IFNDEF LTE}
      PWLink:='039108 '+PWLink;

    {$ENDIF}
  end;


  With PWTreeGrpAry[400] do
  Begin
    tCaption:='Stock Records';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='X 039110 039111 040469 040472 040473 040474 041312 041313 039570 039112 039113 039114 039200 039146 048143';

  end;

  With PWTreeGrpAry[410] do
  Begin
    tCaption:='Stock Ledger';
    IsChild:=2;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='041314';

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 041511';
    {$ENDIF}


  end;


  With PWTreeGrpAry[420] do
  Begin
    tCaption:='Serial/Batch Records';
    IsChild:=1;

    {$IF Not Defined(SOP) or Defined(LTE)}
      Exclude:=BOn;
    {$IFEND}

    PWLink:='039244 039275 039276 039277';

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 039512 039573';
    {$ENDIF}

  end;



  With PWTreeGrpAry[430] do
  Begin
    tCaption:='FIFO Records';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='039278 039279 039280';
  end;

  With PWTreeGrpAry[440] do
  Begin
    tCaption:='Stock Discounts'; //PR: 07/07/2009 Changed from 'Quantity Break Discounts' FR v6.01.124
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='039297 039298 039299 039300 039301';

  end;


  With PWTreeGrpAry[450] do
  Begin
    tCaption:='Bill of Materials';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='041315 041316 041317 041318';


  end;

  {$IFDEF SOP}

    With PWTreeGrpAry[453] do
    Begin
      tCaption:='Location Records';
      IsChild:=1;

      PWLink:='039423';

      Exclude:=Not UseEMLocStk;
    end;

  {$ENDIF}

  With PWTreeGrpAry[457] do
  Begin
    tCaption:='Bin Records';
    IsChild:=1;

    {$IF Not Defined(STK) or Defined(LTE)}
      Exclude:=BOn;
    {$IFEND}


    PWLink:='039430 039431 039432 039433';

  end;


  With PWTreeGrpAry[460] do
  Begin
    tCaption:='Stock List';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='040115 039147 039148 039149 040302';

  end;

  With PWTreeGrpAry[470] do
  Begin
    tCaption:='Stock Re-Order Screen';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ELSE}

      Exclude:=Not FullStkSysOn;
    {$ENDIF}

    PWLink:='040174 040175';


  end;

  With PWTreeGrpAry[480] do
  Begin
    tCaption:='Stock Take Screen';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ELSE}

      Exclude:=Not FullStkSysOn;

    {$ENDIF}

    PWLink:='040176 040177 040178';

  end;


  With PWTreeGrpAry[490] do
  Begin
    tCaption:='Stock Adjustments';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ELSE}

      Exclude:=Not FullStkSysOn;

    {$ENDIF}

      PWLink:='040116 040117 040118 040119 040120 040121 040122 040123 040571';

  end;

  With PWTreeGrpAry[500] do
  Begin
    tCaption:='Reports';
    IsChild:=1;

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='053131 053132 053133 053134 053135 053136 053137 053138 053139 053416 053141';


  end;

  With PWTreeGrpAry[520] do
  Begin
    tCaption:='Procedures';
    IsChild:=0;

    PWLink:='X 044050 045051 ';

    {$IFNDEF LTE} {* Global period change *}
      PWLink:=PWLink+'045352 ';
    {$ENDIF}

    PWLink:=PWLink+'046052 046349 047053 ';


    {$IFNDEF LTE}  {* Export data menu *}
      PWLink:=PWLink+'047126 ';
    {$ENDIF}

    If (CISOn) then
      PWLink:=PWLink+'047429 ';

    PWLink:=PWLink+'047199 047201 ';

    {$IFNDEF LTE}  {* Object CC *}
      PWLink:=PWLink+'047427 ';
    {$ENDIF}

    {$IFDEF SOP}
      PWLink:=PWLink+'035271 036273 ';

    {$ENDIF}

    {$IFDEF RET}
      If (RETMOn) then
        PWLink:=PWLink+'183543 182542';

    {$ENDIF}

  end;

  With PWTreeGrpAry[525] do
  Begin
    tCaption:='Global Notepad';
    IsChild:=1;

    PWLink:='048400 048401 048402 048403';

  end;


  With PWTreeGrpAry[540] do
  Begin
    tCaption:='Paperless Module';
    IsChild:=0;

    Exclude:=Not eCommsModule;

    PWLink:='048266';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 048267';
    {$ENDIF}
  end;


  With PWTreeGrpAry[560] do
  Begin
    tCaption:='Reports';
    IsChild:=0;

  end;

  With PWTreeGrpAry[570] do
  Begin
    tCaption:='Miscellaneous Settings';
    IsChild:=1;

    PWLink:='050054';

  end;


  With PWTreeGrpAry[580] do
  Begin
    tCaption:='Credit Control';
    IsChild:=1;

    PWLink:='051055 051056 051057 051058 051059 051060 051061';

    {$IFDEF SOP}
      // MH 17/06/2015 Exch-R1 ABSEXCH-16543: Added End of Day Payments Report
      // Not available for Cash Accounting system or foreigners
      If Syss.ssEnableOrderPayments And (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And (CurrentCountry = UKCCode) Then
      Begin
        PWLink := PWLink + ' ' + uasAccessEndOfDayPaymentsReport;
      End; // If Syss.ssEnableOrderPayments And (Not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And (CurrentCountry = UKCCode)
    {$ENDIF}

  end;

  With PWTreeGrpAry[590] do
  Begin
    tCaption:='General Ledger Based';
    IsChild:=1;

    PWLink:='052062 052063 052064 052065 052066 052067 052068 052100';

  end;


  With PWTreeGrpAry[600] do
  Begin
    tCaption:='Miscellaneous Reports';
    IsChild:=1;

    PWLink:='053069 053070 053071 053072 053073 053074 053075 053076';

  end;


  With PWTreeGrpAry[610] do
  Begin
    tCaption:='Stock Reports';
    IsChild:=1;

    //PR: 02/05/2017 v2017R1 ABSEXCH-18635 Add in new permissions for moved reports
    PWLink:='053131 053132 053133 053134 053135 053136' +
            Format(' %s %s %s ', [uasReconciliationValuationReport,
                                  uasFinishedGoodsReport,
                                  uasStockAgingReport]) +
            '053137 053138 053139 053416 053141';

    {$IFNDEF STK}
      Exclude:=BOn;
    {$ENDIF}

  end;


  With PWTreeGrpAry[620] do
  Begin
    tCaption:='Job Costing Reports';
    IsChild:=1;

    PWLink:='106225 108226 108227 108228 108229 108230 108231 108232 108233';

    Exclude:=Not JBCostOn;

    PWLink := PWLink + ' ' + uasSubContractorsReport;

    If (CISOn) then
      PWLink:=PWLink+' 162248';

    If (JAPOn) then
      PWLink:=PWLink+' 174468';




  end;

  With PWTreeGrpAry[622] do
  Begin
    tCaption:='Works Order Processing Reports';
    IsChild:=1;

    Exclude:=Not WOPOn;

    PWLink:='153389 154390 154392';

    If (FullWOP) then
      PWLink:=PWLink+' 154391 154393';

  end;

  With PWTreeGrpAry[625] do
  Begin
    tCaption:='Return Reports';
    IsChild:=1;

    Exclude:=Not RETMOn;

    PWLink:='177528 181541';

  end;


  With PWTreeGrpAry[636] do
  Begin
    tCaption:='Report Writer';
    IsChild:=0;

    // MH 14/08/07: Modified to use global flag
    //Exclude:=Not RepWrtOn and (Not VizRepWrt);
    Exclude:=Not RepWrtOn and (Not VRWOn);

    PWLink:='054193 054194 054520';

  end;


  With PWTreeGrpAry[640] do
  Begin
    tCaption:='Job Costing';
    IsChild:=0;

    Exclude:=Not JBCostOn;

  end;


  With PWTreeGrpAry[650] do
  Begin
    tCaption:='Miscellaneous';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='081205 081206 ' + uasAccessJobBudgetsMenu + ' 084213 087214 089215 089216';

  end;

  With PWTreeGrpAry[660] do
  Begin
    tCaption:='Job Records';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='081207 081208 081209 081210 081211 081428';

    If (JAPOn) then
      PWLink:=PWLink+' 081452 081453 081454';


  end;


  With PWTreeGrpAry[670] do
  Begin
    tCaption:='Timesheets';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='091217 091406 094218';


  end;


  With PWTreeGrpAry[680] do
  Begin
    tCaption:='Retentions';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='096219 096220';

  end;


  With PWTreeGrpAry[690] do
  Begin
    tCaption:='Employees';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
    PWLink:='100221 104222 104223 104224 ' + uasJobCostingEmployeeRecordsStatus;

    If (CISOn) then
      PWLink:=PWLink+' 104250';

    If (JAPOn) then
      PWLink:=PWLink+' 104455 104456 ';


  end;

  With PWTreeGrpAry[692] do
  Begin
    tCaption:='Applications & Valuations';
    IsChild:=1;

    Exclude:=(Not JBCostOn) or (Not JAPOn);

    
  end;

  With PWTreeGrpAry[693] do
  Begin
    tCaption:='Miscellaneous';
    IsChild:=2;

    Exclude:=(Not JBCostOn) or (Not JAPOn);

    PWLink:='042463 043464 081452 081453 081454 104455 172465 172466 172467 174468';


  end;


  With PWTreeGrpAry[694] do
  Begin
    tCaption:='Sales Applications';
    IsChild:=2;

    Exclude:=Not JAPOn;

    PWLink:='168443 168444 168445 168446 168447 168448 168449 168450 168451 170457 170458 170459';
  end;

  With PWTreeGrpAry[695] do
  Begin
    tCaption:='Purchase Applications';
    IsChild:=2;

    Exclude:=Not JAPOn;

    PWLink:='166434 166435 166436 166437 166438 166439 166440 166441 166442 171460 171461 171462';
  end;


  With PWTreeGrpAry[696] do
  Begin
    tCaption:='CIS/RCT';
    IsChild:=1;

    Exclude:=Not CISOn;

    PWLink:='X 069422 160246 160247 043249 104250 047429';


  end;

  With PWTreeGrpAry[698] do
  Begin
    tCaption:='CIS/RCT Ledger';
    IsChild:=2;

    Exclude:=Not CISOn;

    PWLink:='164251 164252 164253 164417 164418 164419 164420 164421';
  end;


  PWTreeGrpAry[700]:=PWTreeGrpAry[620];

  With PWTreeGrpAry[700] do
  Begin
    tCaption:='Reports';

  end;


  With PWTreeGrpAry[710] do
  Begin
    tCaption:='Utilities';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='110234 112235 112236 112237 112238 112239';

  end;


  With PWTreeGrpAry[730] do

  Begin
    tCaption:='Utilities';
    IsChild:=0;

    {$IFDEF RET}
      If (RetMOn) then
        RetStr:=' 175545'
      else
        RetStr:='';
    {$ENDIF}


    PWLink:='060077 061078 061079 061080 061097 062081 063082 ';

    {$IFNDEF LTE}

      PWLink:=PWLink+'068087 ';

    {$ENDIF}

    PWLink:=PWLink+'069088 069089 069090 069091'+RetStr+' 069092 069350 069351 064083 062195';

    //PR: 02/06/2010 Add eBanking access to utilities menu
    if EBankOn then
      PWLink:=PWLink + ' 069593';

    PWLink:=PWLink + ' ' + uasAccessTraderAudit + ' ' + uasAccessCustomFields;

    If (JBCostOn) then
      PWLink:='X '+PWLink;

    RetStr:='';

    //PR: 29/07/2014 Order Payments T013
    {$IFDEF SOP}
      // MH 03/12/2014 ABSEXCH-15838: Suppress Order Payments permissions for non-UK companies
      if (not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And (CurrentCountry = UKCCode) then
        PWLink := PWLink + ' ' + uasAccessToCCPaymentGateway;
    {$ENDIF}

    // PKR. 07/01/2016. ABSEXCH-17082.
    if (CurrentCountry = UKCCode) then
      PWLink := PWLink + Format(' %s %s %s', [uasIntrastatAccessIntrastatControlCentre, // '069648'
                                              uasIntrastatChangeSettings,               // '069649'
                                              uasIntrastatClosePeriod]);                // '069650'
  end;


  With PWTreeGrpAry[740] do
  Begin
    tCaption:='Job Costing Utilities';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='110234 112235 112236 112237 112238 112239';

    If (CISOn) then
      PWLink:=PWLink+' 069422';
  end;


  With PWTreeGrpAry[750] do
  Begin
    tCaption:='eBusiness Module';
    IsChild:=0;

    Exclude:=Not eBusModule;

    PWLink:='130319 131320 131321 131322 131323 131324 131325 132326 133327';

  end;


  With PWTreeGrpAry[770] do
  Begin
    tCaption:='Trade Counter Module';
    IsChild:=0;

    Exclude:=Not TradeCounter;

  end;


  With PWTreeGrpAry[780] do
  Begin
    tCaption:='Admin';
    IsChild:=1;

    Exclude:=Not TradeCounter;

    PWLink:='136328 137329 138330';
  end;


  With PWTreeGrpAry[790] do
  Begin
    tCaption:='Trade Counter';
    IsChild:=1;

    Exclude:=Not TradeCounter;

    PWLink:='139331 140332 140333 140334 140335 140336 140337 140409 140339 140340 140341 140407 140408';
  end;

  With PWTreeGrpAry[800] do
  Begin
    tCaption:='Works Order Processing Module';
    IsChild:=0;

    Exclude:=Not WOPOn;

  end;


  With PWTreeGrpAry[810] do
  Begin
    tCaption:='Works Order Daybook';
    IsChild:=1;

    Exclude:=Not WOPOn;

    PWLink:='150373 151374 152375 152376 152377 152378 152379 152380';
     
    If (FullWOP) then
      PWLink:=PWLink+' 152381 152382 152383 152387';


      PWLink:=PWLink+' 152384 152385 152386 152388';


  end;


  With PWTreeGrpAry[815] do
  Begin
    tCaption:='Works Order Transaction';
    IsChild:=1;

    Exclude:=Not WOPOn;

    PWLink:='155394 155395 155396 155397';

    If (FullWOP) then
      PWLink:=PWLink+' 155398 155399';

    {$IFDEF RET}
      If (RetMOn) then
        PWLink:=PWLink+' 152574';
    {$ENDIF}

  end;

  PWTreeGrpAry[820]:=PWTreeGrpAry[622];

  With PWTreeGrpAry[820] do
  Begin
    tCaption:='Reports';

  end;


  With PWTreeGrpAry[825] do
  Begin
    tCaption:='Sentimail';
    IsChild:=0;

    Exclude:=Not SentimailOn;

    PWLink:='158405';
  end;

  With PWTreeGrpAry[827] do
  Begin
    tCaption:='Excel OLE Link';
    IsChild:=0;

  end;


  With PWTreeGrpAry[829] do
  Begin
    tCaption:='Customers';
    IsChild:=1;

    Exclude:=BOff;

    PWLink:='145475 145476 145477';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 145494';
    {$ENDIF}

    If (CanSaveOLE) then
      PWLink:=PWLink+' 145478';

  end;

  With PWTreeGrpAry[832] do
  Begin
    tCaption:='Suppliers';
    IsChild:=1;

    Exclude:=BOff;

    PWLink:='146480 146481 146482';

    If (CanSaveOLE) then
      PWLink:=PWLink+' 146483';

  end;

  With PWTreeGrpAry[835] do
  Begin
    tCaption:='G/L';
    IsChild:=1;

    Exclude:=BOff;

    PWLink:='146485 146486 146487';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 146567';
    {$ENDIF}  

    If (CanSaveOLE) then
      PWLink:=PWLink+' 146488';

  end;


  With PWTreeGrpAry[837] do
  Begin
    tCaption:='Stock';
    IsChild:=1;

    {$IFDEF STK}
      Exclude:=Not FullStkSysOn;
    {$ELSE}
      Exclude:=BOn;
    {$ENDIF}

    PWLink:='147489 147490';

    {$IFNDEF LTE}
      PWLink:=PWLink+' 147493';
    {$ENDIF}

    If (CanSaveOLE) then
      PWLink:=PWLink+' 147491 147492';

  end;

  With PWTreeGrpAry[840] do
  Begin
    tCaption:='Job Costing';
    IsChild:=1;

    Exclude:=Not JBCostOn;

    PWLink:='149495 149496 149514 149515 149479';

    If (CanSaveOLE) then
      PWLink:=PWLink+' 149513 149516 149517 149484 149518 149519';

  end;


  With PWTreeGrpAry[900] do
  Begin
    tCaption:='Returns Module';
    IsChild:=0;

     Exclude:=Not RETMOn;

    PWLink:='175545';
  end;


  With PWTreeGrpAry[904] do
  Begin
    tCaption:='Sales Return';
    IsChild:=1;

     Exclude:=Not RETMOn;

              {* Sales accrual *}
    {PWLink:='183543 177528';}
    PWLink:='177528';
  end;

  With PWTreeGrpAry[907] do
  Begin
    tCaption:='Sales Return Daybook';
    IsChild:=2;

    Exclude:=Not RETMOn;

    PWLink:='175575 175576 176577 176578 176579 176580 176540 176521 176522 176523 176524 176525 176526 176527';

  end;


  With PWTreeGrpAry[911] do
  Begin
    tCaption:='Purchase Return';
    IsChild:=1;

    Exclude:=Not RETMOn;

    PWLink:='182542 181541';
  end;

  With PWTreeGrpAry[913] do
  Begin
    tCaption:='Purchase Return Daybook';
    IsChild:=2;

     Exclude:=Not RETMOn;


    PWLink:='179529 179530 180531 180532 180533 180534 180544 180535 180536 180537 180538 180539';

  end;

  //PR 26/01/2009 Added group for Cost Centre/Department Add, Edit & Delete (6.01)
  With PWTreeGrpAry[914] do
  Begin
    tCaption:='Cost Centres / Departments';
    IsChild:=0;

    Exclude:=Not Syss.UseCCDep;


    PWLink:=Format('%s %s %s %s %s %s', [uasAddCostCentre, uasEditCostCentre,uasDeleteCostCentre,
                                   uasAddDepartment, uasEditDepartment,uasDeleteDepartment]) ;
    // PS - 01-12-2015 - ABSEXCH-3046 - Added uasDeleteDepartment/ uasDeleteCostCentre
  end;

  //CS 05/03/2009 Added group for Sort Views (6.01)
  With PWTreeGrpAry[915] do
  Begin
    tCaption:='Sort Views';
    IsChild:=0;

    PWLink:=Format('%s %s %s %s', [uasAccessSortView, uasAddSortView, uasEditSortView, uasDeleteSortView]);

  end;


  //PR: 06/09/2013 MRD 1.1.08  Add consumer permissions (including AutoReceipt permission MRD 1.2.09)
  With PWTreeGrpAry[112] do
  Begin
    tCaption:='Consumers';
    IsChild:=1;
    PWLink:='';

  end;

  With PWTreeGrpAry[114] do
  Begin
    //PR: 29/07/2014 Order Payments T013 Added Order Payment Edit option (SOP only)
    tCaption:='Consumer Records';
    IsChild:=2;
    PWLink:=Format('%s %s %s %s %s %s %s %s ', [uasAddConsumer, uasEditConsumer, uasViewConsumerBank,
                                                  uasEditConsumerBank, uasEditConsumerCreditLimit, uasFindConsumer,
                                                  uasDeleteConsumer, uasPrintConsumer]);
    {$IFDEF SOP}
      // MH 03/12/2014 ABSEXCH-15838: Suppress Order Payments permissions for non-UK companies
      if (not VAT_CashAcc(SyssVAT.VATRates.VATScheme)) And (CurrentCountry = UKCCode) then
        PWLink := PWLink + uasConsumerAllowOrderPaymentEdit;
    {$ENDIF}

  end;

//PR: 07/05/2014 ABSEXCH-15086 Discounts only available in Stk & above
{$IFDEF STK}
  With PWTreeGrpAry[116] do
  Begin
    tCaption:='Consumer Discounts';
    IsChild:=2;
    PWLink:= Format('%s %s %s %s %s %s', [uasViewConsumerDiscounts, uasAddConsumerDiscount, uasEditConsumerDiscount,
                                          uasDeleteConsumerDiscount, uasCopyConsumerDiscount, uasCheckConsumerDiscount]);


  end;
{$ENDIF}

  {$IFDEF RET}
    If (RetMOn) then
      RetStr := uasConsumerReturns
    else
      RetStr := '';
  {$ENDIF}


  With PWTreeGrpAry[118] do
  Begin
    tCaption:='Consumer Miscellaneous';
    IsChild:=2;
    PWLink:=Format('%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ',
            [uasConsumerDetailsAccess, uasConsumerViewLedger, uasConsumerCheckAlloc, uasUnallocateAllConsumerTransactions, uasConsumerViewOrderLedger,
             RetStr, uasConsumerViewHistory, uasConsumerViewBalance, uasConsumerAccessNotes, uasConsumerStatus,
             uasConsumerUnallocTrans, uasConsumerCopyReverse, uasConsumerSettle, uasConsumerAllocate, uasConsumerAllocWizard,
             uasConsumerBlockUnalloc]);

    //Delete Stock Analysis record - check licencing before including
    if AnalCuStk then
      PWLink := PWLink + uasConsumerDeleteStockAnal + ' ';

    PWLink := PWLink + uasConsumerAccessLinks;

  end;

  //RB 06/12/2017 2018-R1 ABSEXCH-19478: 5.2.2 User Permissions - Insert into DB in GEUpgrde + Update User Profile Tree
  if GDPROn then
  begin
    with PWTreeGrpAry[742] do
    begin
      tCaption:='GDPR';
      IsChild:=1;
    end;

    with PWTreeGrpAry[744] do
    begin
      tCaption:='PII Tree';
      IsChild:=2;
      //PWLink:=Format('%s %s %s %s ', [uasAccessForCustomerConsumer, uasAccessForSupplier, uasAccessForEmployee, uasAllowEditDelete]);
      PWLink:=Format('%s %s %s ', [uasAccessForCustomerConsumer, uasAccessForSupplier, uasAccessForEmployee]);
    end;
    
    with PWTreeGrpAry[746] do
    begin
      tCaption:='Anonymisation Control Centre';
      IsChild:=2;
      PWLink:=Format('%s %s %s %s %s ', [uasAccessToAnonymisationControlCentre, uasAnonymiseCustomerConsumer, uasAnonymiseSupplier,
                                                    uasAnonymiseEmployee, uasAccessToGDPRConfiguration]);
    end;
  end;

