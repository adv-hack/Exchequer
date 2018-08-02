Unit DiscU3U;

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/96                      }
{                                                              }
{              Account Discount Link  Controller               }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,

     //PR: 09/02/2012 ABSEXCH-9795
     QtyBreakVar
     {$IFDEF SOP}
       ,
       EXWrap1U;

     {$ELSE}
       ;

     {$ENDIF}


{* Reproduced in Report6U *}

//PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
Procedure Calc_UPriceDisc(TStock  :  StockRec;
                          DiscRec :  MiscRec;
                          TCurr   :  Byte;
                          TQty    :  Real;
                      Var UPrice,
                          DiscR   :  Real;
                      Var DiscCh  :  Char;
                    Const LCode   :  Str10;
                          Mode    :  Byte;
                          QBRec   :  TQtyBreakRec);


Procedure Calc_StockPrice(TStock  :  StockRec;
                          TCust   :  CustRec;
                          TCurr   :  Byte;
                          TQty    :  Real;
                          TDate :  LongDate;
                      Var UPrice,
                          DiscR   :  Real;
                      Var DiscCh  :  Char;
                    Const LCode   :  Str10;
                      Var FoundOk :  Boolean;
                          DMode   :  Byte);

{$IFDEF SOP}
  procedure QBLineVAT_Update(Var ExLocal  :  TdExLocal);
{$ENDIF}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   Math,
   StrUtils,
   Forms,
   SysUtils,
   ETStrU,
   ETMiscU,
   BtrvU2,
   BTKeys1U,
   ComnUnit,
   ComnU2,
   CurrncyU,
   SysU2,
   {$IFNDEF EXDLL}
     InvListU,
   {$ENDIF}

   {$IFDEF STK}

     FIFOL2U,

     {$IFDEF SOP}
       InvLst3U,
       MiscU,
     {$ENDIF}

     {$IFDEF EXDLL}
       MLocFunc,
     {$ENDIF}

   {$ENDIF}

   {$IFDEF EXSQL}
     SQLUtils,
     SQLCallerU,
   {$ENDIF}

   BTSupU1,
   InvCT2SU,

   ADOConnect;

Var
  PromoDatesFound  :  Boolean;


{=====================================================================================}
{=== These routines replicated within Report6U so they do not effect global stock === }
{== And ObjPrceU ==}
{=====================================================================================}


  { ========= Function to find Account Discount match ========== }
  {
    This searches the file specified by Fnum (invariably EXSTKCHK?) for any
    discount records against the specified Customer, Stock Item, and Currency.
    Any record found which does not use dates will be the Default Discount
    record, and will be used if no dated discounts are found. If a dated
    discount is found whose range includes the supplied TDate, this record will
    be used instead.

    On return, MiscRecs^.CustDiscRec will hold the details of the record to be
    used (note that this might not be the currently selected record in the
    file).
  }
  Function Calc_AccDMatch(TStock  :  StockRec;
                          TCust   :  CustRec;
                          TCurr   :  Byte;
                          TDate   :  LongDate;
                          Fnum,
                          Keypath :  Integer)  :  Boolean;




  Var
    KeyS,
    KeyChk    :  Str255;

    DefFound,
    FoundOk   :  Boolean;

    TmpMisc   :  MiscRec;


  Begin
    FoundOk:=BOff; DefFound:=BOff;

    KeyChk:=FullQDKey(CDDiscCode,TCust.CustSupp,MakeCDKey(TCust.CustCode,TStock.StockCode,TCurr));

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With MiscRecs^.CustDiscRec do
    Begin
      FoundOk:=(Not CUseDates) or ((TDate>=CStartD) and (TDate<=CEndD));

      If (FoundOk) and (Not CUseDates) and (Not DefFound) then {* See if there are others *}
      Begin
        DefFound:=BOn;
        FoundOk:=BOff;
        TmpMisc:=MiscRecs^;
      end;

      PromoDatesFound:=(PromoDatesFound or CUseDates);

      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end;

    If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
    Begin
      MiscRecs^:=TmpMisc;
      FoundOk:=Bon;
    end;


    Result:=FoundOk;
  end;



  { ======= Function to Return next item up the tree ====== }


  Function Get_DiscTree(Scode  :  Str20)  :  Boolean;

  Begin

    If (Not EmptyKey(Scode,StkKeyLen)) then
      Get_DiscTree:=CheckRecExsists(Strip('R',[#0],Scode),StockF,StkCodeK)
    else
      Get_DiscTree:=BOff;

  end; {Func..}


  { ======= Function to Match Qty Break ======== }
  //PR: 09/02/2012 Amended function to use new Qty Breaks file ABSEXCH-9795
  Function Calc_QtyBreak(TStock  :  StockRec;
                         TCust   :  CustRec;
                         TCurr   :  Byte;
                         TQty    :  Real;
                         TDate   :  LongDate;
                         Fnum,
                         Keypath :  Integer;
                         Mode    :  Byte;
                         QBFolio : longint = 0)  :  Boolean;




  Var
    KeyS,
    KeyChk  :  Str255;

    DefFound,
    FoundOk :  Boolean;

    TmpQtyBreak   :  TQtyBreakRec;


  Begin

    FoundOk:=BOff; DefFound:=BOff;

    Case Mode of
      //PR: 09/02/2012 ABSEXCH-9795
      1  :  begin   //PR: 27/06/2012 Pass false parameter to fix ABSEXCH-13085
              KeyChk := QtyBreakStartKey('', TStock.StockFolio, False) + Char(TCurr);
              KeyPath := qbAcCodeIdx;
            end;
      2  :  begin
              KeyChk := FullNomKey(QBFolio);
              KeyPath := qbFolioIdx;
            end;

    end; {Case..}

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[QtyBreakF],QtyBreakF,RecPtr[QtyBreakF]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
    With QtyBreakRec do
    Begin

      FoundOk:=((TQty >= qbQtyFrom) and (TQty <= qbQtyTo)) and ((Not qbUseDates) or ((TDate >= qbStartDate) and (TDate <= qbEndDate)));

      If (FoundOk) and (not qbUseDates) and (Not DefFound) then {* See if there are others *}
      Begin
        DefFound:=BOn;
        FoundOk:=BOff;
        TmpQtyBreak := QtyBreakRec;
      end;

      PromoDatesFound:=(PromoDatesFound or qbUseDates);


      If (Not FoundOk) then
        Status:=Find_Rec(B_GetNext,F[QtyBreakF],QtyBreakF,RecPtr[QtyBreakF]^,Keypath,KeyS);

    end; {While.}

    If (Not FoundOk) and (DefFound) then {* Re-instate the default one as it was the only one *}
    Begin
      QtyBreakRec := TmpQtyBreak;
      FoundOk:=Bon;
    end;


    Calc_QtyBreak:=FoundOk;

  end; {Func..}



  { ======== Function to Convert Discount Record in to unit price and discount ======= }

  Procedure Calc_UPriceDisc(TStock  :  StockRec;
                            DiscRec :  MiscRec;
                            TCurr   :  Byte;
                            TQty    :  Real;
                        Var UPrice,
                            DiscR   :  Real;
                        Var DiscCh  :  Char;
                      Const LCode   :  Str10;
                            Mode    :  Byte;
                            QBRec   :  TQtyBreakRec);



  Var
    DiscTyp,
    DiscBand :  Char;
    DiscCurr :  Byte;

    SPrice,
    CPrice,
    DiscPC,
    DiscAM,
    DiscMU,
    Rnum    :  Real;


  Begin

    DiscR:=0;
    DiscCh:=C0;
    UPrice:=0;

    Rnum:=0;

    DiscTyp := #0;
    DiscMU := 0;
    DiscPC := 0;
    DiscBand := #0;
    DiscAM := 0;
    DiscCurr := 0;
    SPrice := 0;

    With DiscRec do
    Case Mode of

      1  :  With QBRec do
            Begin
              //PR: 09/02/2012 Use new qb record ABSEXCH-9795
              DiscTyp := DiscountCharFromBreakType(qbBreakType);
              DiscBand:= qbPriceBand;

              SPrice:= qbSpecialPrice;
              DiscPC:= qbDiscountPercent;
              DiscAM:= qbDiscountAmount;
              DiscMU:= qbMarginOrMarkup;

              DiscCurr := qbCurrency;
            end;

      2  :  With CustDiscRec do
            Begin

              DiscTyp:=QBType;
              DiscBand:=QBand;

              SPrice:=QSPrice;
              DiscPC:=QDiscP;
              DiscAM:=QDiscA;
              DiscMU:=QMUMG;
              DiscCurr:=QBCurr;

            end;

    end; {Case..}


    Case DiscTyp of

      QBPriceCode  :  Begin
                        UPrice:=Currency_ConvFT(SPrice,DiscCurr,TCurr,UseCoDayRate);
                      end;

      QBBandCode   :  Begin
                        {$IFDEF SOP}
                          Stock_LocPSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocPSubst(TStock,LCode);
                          {$ENDIF}
                        {$ENDIF}


                        UPrice:=Get_StkPrice(TStock.SaleBands,0,DiscBand,TCurr,1,1,TStock.CalcPack);

                        If (DiscPC<>0) or (DiscAm<>0) then
                        Begin
                          If (DiscPC<>0) then
                          Begin
                            DiscCh:=PcntChr;
                            DiscR:=Pcnt(DiscPC);
                          end
                          else
                            DiscR:=DiscAM;
                        end
                        else
                          DiscCh:=DiscBand;

                      end;

      QBMarkUpCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          Stock_LocCSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocCSubst(TStock,LCode);
                          {$ENDIF}
                        {$ENDIF}

                        CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1,LCode);

                        {* To be replaced by FIFO *}

                        UPrice:=Round_Up(Calc_IdQty(CPrice*(1+Pcnt(DiscMU)),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

      QBMarginCode :  With TStock do
                      Begin
                        {$IFDEF SOP}
                          Stock_LocCSubst(TStock,LCode);
                        {$ELSE}
                          // EL 21/10/02: Added Toolkit support for Locations
                          {$IFDEF EXDLL}
                            Stock_LocCSubst(TStock,LCode);
                          {$ENDIF}
                        {$ENDIF}

                        Rnum:=DiscMU;

                        If (Rnum>=100) then
                          Rnum:=99.99;

                        CPrice:=FIFO_GetCost(TStock,TCurr,TQty,1,LCode);

                        UPrice:=Round_Up(Calc_IdQty(DivWChk(CPrice,(1-Pcnt(Rnum))),SellUnit,Not CalcPack),Syss.NoNetDec);

                      end;

    end; {Case..}

  end; {Proc..}



  { ============ Function to search for a matching discount ============= }

  Procedure Calc_StockPrice(TStock  :  StockRec;
                            TCust   :  CustRec;
                            TCurr   :  Byte;
                            TQty    :  Real;
                            TDate   :  LongDate;
                        Var UPrice,
                            DiscR   :  Real;
                        Var DiscCh  :  Char;
                      Const LCode   :  Str10;
                        Var FoundOk :  Boolean;
                            DMode   :  Byte);



  Const
    Fnum     =  MiscF;
    Keypath  =  MIK;


  Var
    TmpKPath,
    TmpStat   :  Integer;

    TmpRecAddr
              :  LongInt;


    Loop,
    TreeLoop,
    RunStandard,
    SetforDatesOnly,
    SetAny    :  Boolean;

    LCurr,
    Mode      :  Byte;

    FoundCode :  Str20;
    KeyS      :  Str255;

    //------------------------------

    Function SQL_FindDiscounts : Boolean;
    Var
      SQLCaller : TSQLCaller;  // \ExchSQL\BtrvSQL\SQLCallerU.Pas
      CompanyCode, ConnectionString, sQuery, lPassword: WideString;
      bGotConsDiscs : Boolean;
      iCount, iPass : Integer;
      LStock : StockRec;
    Begin // SQL_FindDiscounts
      Result := False;

      //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
      SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
      Try
        CompanyCode := GetCompanyCode(SetDrive);

        //If (GetConnectionString(CompanyCode, True, ConnectionString) = 0) Then
        //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
        If (GetConnectionStringWOPass(CompanyCode, True, ConnectionString, lPassword) = 0) Then
        Begin

          if TCust.CustSupp = 'S' then
          begin
            sQuery := ';WITH temp_StockTree (tmpStockCode, tmpParentCode) AS ' +
                      '(' +
                         'SELECT stCode, stParentCode ' +
                         'FROM [COMPANY].Stock ' +
                         'WHERE stCode = ''%s'' ' +
                         'UNION ALL ' +
                         'SELECT stcode, b.stParentCode ' +
                         'FROM temp_StockTree AS a, [COMPANY].Stock AS b ' +
                         'WHERE cast(a.tmpParentCode as varbinary(16)) = b.stCode' +
                      ') ' +
                      'SELECT tmpStockCode, ' +
                            '(Select Count(RecMFix) ' +
                             'From [COMPANY].ExStkChk ' +
                             'Where (RecMFix = ''C'') And (SubType = ''%s'') ' +
                               'And (ExStChkVar1Computed like ''%s'' + tmpStockCode + ''%s'') ' +
                               'And ((CUseDates = 0) Or ((CUseDates = 1) And (CStartD <= ''%s'') And (CEndD >= ''%s''))) ' +
                               'And (CustQBCurr = %d) ' +
                            ') As ''NumInCcyDiscounts'', ' +
                            '(Select Count(RecMFix) ' +
                             'From [COMPANY].ExStkChk ' +
                             'Where (RecMFix = ''C'') And (SubType = ''%s'') ' +
                               'And (ExStChkVar1Computed like ''%s'' + tmpStockCode + ''%s'') ' +
                               'And ((CUseDates = 0) Or ((CUseDates = 1) And (CStartD <= ''%s'') And (CEndD >= ''%s''))) ' +
                               'And (CustQBCurr = 0) ' +
                            ') As ''NumConsolDiscounts'' ' +
                      'FROM temp_StockTree';

              //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
              //(to check for quote chars that could break SQLs interpretation)
              With SQLCaller do
                sQuery := Format(sQuery, [
                                        CompatibilityFormat(TStock.StockCode), //stockcodes can have ['] chars..
                                        TCust.CustSupp,
                                        CompatibilityFormat(TCust.CustCode),   //cust/supp code can have ['] chars..
                                        '%',
                                        TDate,
                                        TDate,
                                        TCurr,
                                        TCust.CustSupp,
                                        CompatibilityFormat(TCust.CustCode),
                                        '%',
                                        TDate,
                                        TDate]);
            end
            else
            begin
              sQuery := ';WITH temp_StockTree (tmpStockCode, tmpParentCode) AS ' +
                        '(' +
                           'SELECT stCode, stParentCode ' +
                           'FROM [COMPANY].Stock ' +
                           'WHERE stCode = ''%s'' ' +
                           'UNION ALL ' +
                           'SELECT stcode, b.stParentCode ' +
                           'FROM temp_StockTree AS a, [COMPANY].Stock AS b ' +
                           'WHERE cast(a.tmpParentCode as varbinary(16)) = b.stCode' +
                        ') ' +
                        'SELECT tmpStockCode, ' +
                              '(Select Count(CustCode) ' +
                               'From [COMPANY].CustomerDiscount ' +
                               'Where  ' +
                                 '(CustCode = ''%s'') ' +
                                 'And (StockCode LIKE tmpStockCode + ''%s'')' +
                                 'And ((UseDates = 0) Or ((UseDates = 1) And (StartDate <= ''%s'') And (EndDate >= ''%s''))) ' +
                                 'And (Currency = %d) ' +
                              ') As ''NumInCcyDiscounts'', ' +
                              '(Select Count(CustCode) ' +
                               'From [COMPANY].CustomerDiscount ' +
                               'Where ' +
                                 '(CustCode = ''%s'') ' +
                                 'And (StockCode LIKE tmpStockCode + ''%s'')' +
                                 'And ((UseDates = 0) Or ((UseDates = 1) And (StartDate <= ''%s'') And (EndDate >= ''%s''))) ' +
                                 'And (Currency = 0) ' +
                              ') As ''NumConsolDiscounts'' ' +
                        'FROM temp_StockTree';

              //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
              //(to check for quote chars that could break SQLs interpretation)
              With SQLCaller do
                sQuery := Format(sQuery,
                                        [CompatibilityFormat(TStock.StockCode), //stockcodes can have ['] chars..
                                        CompatibilityFormat(TCust.CustCode), //cust/supp code can have ['] chars..
                                        '%',
                                        TDate,
                                        TDate,
                                        TCurr,
                                        CompatibilityFormat(TCust.CustCode),
                                        '%',
                                        TDate,
                                        TDate]);
            end;

          SQLCaller.Select(sQuery, CompanyCode);

          If (SQLCaller.ErrorMsg = '') Then
          Begin
            Try
              If (SQLCaller.Records.RecordCount > 0) Then
              Begin
                // Run through results for Line Currency and then for Consolidated if nothing found
                bGotConsDiscs := False;
                For iPass := 1 To 2 Do
                Begin
                  SQLCaller.Records.First;
                  While (Not SQLCaller.Records.EOF) And (Not Result) Do
                  Begin
                    iCount := SQLCaller.Records.FieldByName(IfThen(iPass=1, 'NumInCcyDiscounts', 'NumConsolDiscounts')).AsInteger;
                    If (iCount > 0) Then
                    Begin
                      // Need to load in correct Stock record
                      If CheckRecExsists(Strip('R',[#0],SQLCaller.Records.FieldByName('tmpStockCode').AsString),StockF,StkCodeK) Then
                      Begin
                        LStock := Stock;
                        Result := Calc_AccDMatch(LStock, TCust, IfThen(iPass=1, TCurr, 0), TDate, Fnum, Keypath);
                      End // If CheckRecExsists ...
                      Else
                        // Revert to standard functionality
                        Raise Exception.Create('');
                    End // If (iCount > 0)
                    Else
                      If (iPass = 1) And (Not bGotConsDiscs) Then
                      Begin
                        // Check for Consolidate Discounts
                        iCount := SQLCaller.Records.FieldByName('NumConsolDiscounts').AsInteger;
                        bGotConsDiscs := (iCount > 0);
                      End; // If (iPass = 1)*)

                    If (Not Result) Then
                      SQLCaller.Records.Next;
                  End; // While (Not SQLCaller.Records.EOF) And (Not Result)

                  If Result Or (Not bGotConsDiscs) Then
                    // Drop out of loop if already found a discount, don't bother looping around to process consolidated discounts if none found during first pass
                    Break;
                End; // For iPass
              End; // If (SQLCaller.Records.RecordCount > 0)
            Finally
              Stock := TStock;  // Restore original stock record for price calculation
            End; // Try..Finally
          End // If (SQLCaller.ErrorMsg = '')
          Else
            // Revert to standard functionality
            Raise Exception.Create('');
        End // If (GetConnectionString(CompanyCode, True, ConnectionString) = 0)
        Else
          // Revert to standard functionality
          Raise Exception.Create('');
      Finally
        SQLCaller.Free;
      End; // Try..Finally
    End; // SQL_FindDiscounts

    //------------------------------

  Begin

    SetAny:=FoundOk;

    PromoDatesFound:=BOff;  SetforDatesOnly:=(DMode=11);

    FoundOk:=BOff;

    TreeLoop:=BOn;

    LCurr:=TCurr;

    Blank(KeyS,Sizeof(KeyS));

    Mode:=2;

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOff,BOff);


    {$IFDEF MC_On}

      Loop:=BOff;

    {$ELSE}

      Loop:=BOn;

      LCurr:=0;

    {$ENDIF}

    {$IFDEF EXSQL}
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      Try
        FoundOk := SQL_FindDiscounts;
        RunStandard := False;
      Except
        RunStandard := True;
      End; // Try..Except
    End // If SQLUtils.UsingSQLAlternateFuncs
    Else
      RunStandard := True;
    {$ENDIF}

    If RunStandard Then
    Begin
      Repeat

          {* Search for an exact match *}

        FoundOk:=Calc_AccDMatch(TStock,TCust,LCurr,TDate,Fnum,Keypath);

        Stock:=TStock;

        If (Not FoundOk) then {* Search for a match via the tree *}
        Repeat

          TreeLoop:=Get_DiscTree(Stock.StockCat);

          If (TreeLoop) then
          Begin

            FoundOk:=Calc_AccDMatch(Stock,TCust,LCurr,TDate,Fnum,Keypath);

          end;

        Until (Not TreeLoop) or (FoundOk);

        LCurr:=0;

        Loop:=Not Loop;  {* Repeat for Currecncy 0 *}


        Stock:=TStock;

      Until (FoundOk) or (Not Loop);
    End; // If RunStandard

    If (Not FoundOk) then {* Search for product QB match *}
    Begin


      If (TCust.CustSupp=TradeCode[BOn]) then
      Begin

        Mode:=1;

        LCurr:=TCurr;


        {$IFDEF MC_On}

          Loop:=BOff;

        {$ELSE}

          Loop:=BOff; {It seems quantity breaks in Ex set with Curr 0}

        {$ENDIF}


        Repeat

          FoundOk:=Calc_QtyBreak(TStock,TCust,LCurr,TQty,TDate,Fnum,Keypath,Mode);

          LCurr:=0;

          Loop:=Not Loop;

        Until (Not Loop) or (FoundOk);

      end; {If Supplier..}

    end {If not found..}
    else
    Begin


      If (MiscRecs^.CustDiscRec.QBType=QBQtyBCode) then {* Search for subsequent qty break *}
      Begin

        Mode:=1;

        LCurr:=TCurr;

        KeyS:=MiscRecs^.CustDiscRec.QStkCode;

        {$IFNDEF EXDLL}
        GetStock(Application.MainForm,KeyS,FoundCode,-1);
        {$ELSE}
        Global_GetMainRec(StockF, KeyS);
        {$ENDIF}

        {$IFDEF MC_On}

          Loop:=BOff;

        {$ELSE}

          Loop:=BOn;

        {$ENDIF}

        Repeat
          //PR: 09/02/2012 Amended to use new Qty Breaks file ABSEXCH-9795
          FoundOk:=Calc_QtyBreak(Stock,TCust,LCurr,TQty,TDate,Fnum,Keypath,2,MiscRecs^.CustDiscRec.QtyBreakFolio);

          LCurr:=0;

          Loop:=Not Loop;

        Until (Not Loop) or (FoundOk);

      end; {Acc Qty break}

    end; {FoundOk..}
                     {* v5.61.001. If triggered by a date change, only change price if promo date present *}
    If (FoundOk) and (PromoDatesFound or Not SetforDatesOnly) then
      //PR: 09/02/2012 Amended to use new Qty Breaks file ABSEXCH-9795
      Calc_UPriceDisc(TStock,MiscRecs^,TCurr,TQty,UPrice,DiscR,DiscCh,LCode,Mode, QtyBreakRec)
    else
    Begin

      If (SetAny) then  {* Only set values if allowed *}
      Begin
        If (TCust.CustSupp<>TradeCode[BOff]) then
        Begin
          {$IFDEF SOP}
            Stock_LocPSubst(TStock,LCode);
          {$ELSE}
            // HM 16/05/01: Added Toolkit support for Locations as CalcPrice was
            //              ignoring them because it doesn't use the SOP directive
            {$IFDEF EXDLL}
              Stock_LocPSubst(TStock,LCode);
            {$ENDIF}
          {$ENDIF}


          With TCust do
          Begin
            If (DiscR<>Discount) then
              DiscR:=Discount;

            If (DiscCh<>CDiscCh) then
              DiscCh:=CDiscCh;
          end;

          UPrice:=Get_StkPrice(TStock.SaleBands,DiscR,DiscCh,TCurr,1,1,TStock.CalcPack);

        end
        else
        Begin
          {$IFDEF SOP}
            Stock_LocROCPSubst(TStock,LCode);
          {$ELSE}
            // HM 16/05/01: Added Toolkit support for Locations as CalcPrice was
            //              ignoring them because it doesn't use the SOP directive
            {$IFDEF EXDLL}
              Stock_LocROCPSubst(TStock,LCode);
            {$ENDIF}
          {$ENDIF}

          DiscR:=0.0; DiscCh:=#0; {v5.52. These were being set to random figures}

          With TCust do
          Begin
            If (DiscR<>Discount) then
              DiscR:=Discount;

            If (DiscCh<>CDiscCh) then
              DiscCh:=CDiscCh;
          end;


          UPrice:=Currency_ConvFT(TStock.ROCPrice,TStock.ROCurrency,TCurr,UseCoDayRate);
        end;
      end;

    end;

    TmpStat:=Presrv_BTPos(StockF,TmpKPath,F[StockF],TmpRecAddr,BOn,BOff);


    Stock:=TStock;

  end; {Proc..}



{$IFDEF SOP}

  { == Procedure to override VAT Code & Inclusive calculation after a qty break has been applied *}
  procedure QBLineVAT_Update(Var ExLocal  :  TdExLocal);
    Var
      NewVC  :  Char;


    Begin
      With ExLocal do
        NewVC:=Correct_PVAT(LStock.VATCode,LCust.VATCode);

      If (NewVC=VATICode) and (ExLocal.LId.VATCode=VATMCode) then {*We need to re-introduce I*}
      Begin
        ExLocal.LId.VATCode:=NewVC;

        CalcVATExLocal(ExLocal,BOff,nil);

      end;

    end;

{$ENDIF}




Initialization

PromoDatesFound:=BOff;


end.