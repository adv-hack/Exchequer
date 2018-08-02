unit ReportCU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,StrUtils,
  GlobVar,VARRec2U,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type



  TPBrkReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private

                       FGScrt,
                       ThisScrt   :  Scratch2Ptr;


                       Procedure Build_ProdBreak(Mode     :  Byte;
                                                 DocFilt  :  Str20;
                                                 CustFilt,
                                                 LocFilt  :  Str10;
                                                 RCr      :  Byte;
                                                 SDate,
                                                 EDate    :  LongDate;
                                                 StkToo   :  Str20;
                                                 SingProd :  Boolean;
                                                 RCCDep   :  CCDepType;
                                             Var AbortPrint
                                                          :  Boolean);

                       Function Make_NomIdKey(NmCode  :  LongInt;
                                              RCr,
                                              RYr,
                                              RPr     :  Byte)  :  Str20;


                       Procedure Build_StkReconSales(Fnum,
                                                     KeyPath   :  Integer;
                                                     RCr,
                                                     YrS,PrS,
                                                     YrE,PrE   :  Byte;
                                                     CustFilt  :  Str10;
                                                     LocFilt   :  Str10;
                                                 Var AbortPrint,
                                                     Ok2Cont
                                                               :  Boolean);

                       Procedure Build_StkReconQtyOnly(Fnum,
                                                       KeyPath   :  Integer;
                                                       RCr,
                                                       YrS,PrS,
                                                       YrE,PrE   :  Byte;
                                                       CustFilt,
                                                       LocFilt   :  Str10;
                                                       StkToo    :  Str20;
                                                       GLCode    :  LongInt;
                                                   Var AbortPrint,
                                                       Ok2Cont
                                                                 :  Boolean);

                       Procedure Build_StkRecon(Fnum,
                                                KeyPath   :  Integer;
                                                RCr,
                                                YrS,PrS,
                                                YrE,PrE   :  Byte;
                                                CustFilt,
                                                LocFilt   :  Str10;
                                                StkToo    :  Str20;
                                            Var AbortPrint
                                                          :  Boolean);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintOCBal2(Rcr,RTxCr:  Byte;
                                             OBal,
                                             CBal     :  Real;
                                             Mode     :  Byte;
                                             CloseBal :  Boolean);

                       Procedure PrintStockTot(GMode     :  Byte);

                       Procedure CalcDueTotals(STot      :  Totals);

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParamP  :  PBrkRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


  Procedure AddProdRep2Thread(LMode      :  Byte;
                              IRepParam  :  PBrkRepPtr;
                              AOwner     :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  MiscU,
  BTSupU1,
  InvListU,
  RevalU2U,
  SalTxl1U,
  RpDefine,
  {$IFDEF REPPFC}
    SQLUtils,
    SQLFuncs,
    SavePos,
  {$ENDIF}
  ExThrd2U,
  // MH 04/10/2013 MRD1.1.27: Added report filter on account types
  ConsumerUtils,
  BtSupu2;


{ ========== TPBrkReport methods =========== }

Constructor TPBrkReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParamP);

  FillChar(CRepParamP^,Sizeof(CRepParamP^),0);

  FGScrt:=Nil;

end;


Destructor TPBrkReport.Destroy;

Begin
  Dispose(CRepParamP);

  Inherited Destroy;
end;







Procedure TPBrkReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        10:  Begin
              SetTab (MarginLeft, pjLeft, 13, 4, 0, 0);
              SetTab (NA, pjLeft, 45, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,19, 4, 0, 0);
            end;

        11:  Begin
              // MH 13/03/2012 v6.10 ABSEXCH-11902: Changed to Landscape and increased Code/Desc column widths
              SetTab (MarginLeft, pjLeft, 50 {23}, 4, 0, 0);
              SetTab (NA, pjLeft, 60 {40}, 4, 0, 0);
              SetTab (NA, pjRight, 18, 4, 0, 0);
              SetTab (NA, pjLeft, 10, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight,29, 4, 0, 0);
              SetTab (NA, pjRight,19, 4, 0, 0);
            end;

        15
          :  Begin
               SetTab (MarginLeft, pjLeft, 43, 4, 0, 0);
               SetTab (NA, pjLeft, 53, 4, 0, 0);
               SetTab (NA, pjLeft, 18, 4, 0, 0);
               SetTab (NA, pjLeft, 35{22}, 4, 0, 0);  // MHYR
               SetTab (NA, pjRight, 15, 4, 0, 0);
               SetTab (NA, pjLeft, 17, 4, 0, 0);
               SetTab (NA, pjLeft, 13, 4, 0, 0);
               SetTab (NA, pjRight, 28{29}, 4, 0, 0);  // MHYR
               SetTab (NA, pjRight, 28{29}, 4, 0, 0);  // MHYR
               SetTab (NA, pjRight, 28{29}, 4, 0, 0);  // MHYR

             end;
        16
          :  Begin
               SetTab (MarginLeft, pjLeft, 43, 4, 0, 0);
               SetTab (NA, pjLeft, 130, 4, 0, 0);
               SetTab (NA, pjRight, 29, 4, 0, 0);
               SetTab (NA, pjRight, 29, 4, 0, 0);
               SetTab (NA, pjRight, 29, 4, 0, 0);
             end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;





{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TPBrkReport.Build_ProdBreak(Mode     :  Byte;
                                      DocFilt  :  Str20;
                                      CustFilt :  Str10;
                                      LocFilt  :  Str10;
                                      RCr      :  Byte;
                                      SDate,
                                      EDate    :  LongDate;
                                      StkToo   :  Str20;
                                      SingProd :  Boolean;
                                      RCCDep   :  CCDepType;
                                  Var AbortPrint
                                               :  Boolean);


Const
  Fnum      =  IDetailF;
  Keypath   =  IdAnalK;



Var
  KeyS2,
  KeyChk,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  B_Func   :  Integer;

  TmpInclude,
  TmpBo
           :  Boolean;

  CStatus : SmallInt;
  StockKey : Str255;

  LastStockCode : String[20];
  LastResult : Boolean;

  // MH 04/10/2013 MRD1.1.27: Added report filter on account types
  oTraderCache : TTraderCache;

  {$IFDEF REPPFC}
    SQLPFCRes : LongInt;
    sColName : ShortString;

    Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
    Begin // ColName
      Result := GetDBColumnName(FileName, ColumnName, '')
    End; // ColName

    Function StockGroupFilter(ParentGroup, ColumnName : ShortString; Const Init : Boolean = True) : ANSIString;
    Var
      iStatus  : SmallInt;
      KeyS : Str255;
      sTemp : ANSIString;
    Begin // StockGroupFilter
      Result := '';

      With TBtrieveSavePosition.Create Do
      Begin
        Try
          // Save the current position in the file for the current key
          SaveFilePosition (StockF, GetPosKey);
          SaveDataBlock (@Stock, SizeOf(Stock));

          // Check Parent exists
          KeyS := FullStockCode(ParentGroup);
          iStatus := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCATK, KeyS);
          While (iStatus = 0) And (Stock.StockCat = ParentGroup) Do
          Begin
            If (Stock.StockType = StkGrpCode) Then
              // For Stock Groups run through their children
              sTemp := StockGroupFilter(Stock.StockCode, ColumnName, False)
            Else
              // Otherwise add stock item into Query
              sTemp := '(' + ColumnName + ' = ' + StringToHex(#16 + Trim(Stock.StockCode), 17) + '00000000)';

            If (Trim(sTemp) <> '') Then
            Begin
              If (Trim(Result) <> '') Then
                Result := Result + ' Or ';
              Result := Result + sTemp;
            End; // If (Trim(sTemp) <> '')

            iStatus := Find_Rec(B_GetNext, F[StockF], StockF, RecPtr[StockF]^, StkCATK, KeyS);
          End; // While (iStatus = 0) And (Stock.StockCat = ParentGroup)

          // Restore position in file
          RestoreDataBlock (@Stock);
          RestoreSavedPosition;
        Finally
          Free;
        End; // Try..Finally
      End; // With TBtrieveSavePosition.Create

      If Init And (Result <> '') Then
        Result := '(' + Result + ')';
    End; // StockGroupFilter
  {$ENDIF}

Begin
  {$IFDEF REPPFC}
   SQLPFCRes := -1;
  {$ENDIF}
  AbortPrint:=BOn;

  KeyChk:=DocFilt;
  KeyS2:=KeyChk;

  If (Length(KeyS2)=1) then {* Jump past blank lines *}
    KeyS2:=KeyS2+'!';

  MatchStr:='';

  RecAddr:=0;

  TmpInclude:=BOff;
  TmpBo:=BOff;

  LastStockCode := #255;
  LastResult := False;

  // MH 04/10/2013 MRD1.1.27: Added report filter on account types
  oTraderCache := NIL;

  B_Func:=B_GetNext;

  ShowStatus(2,'Calculating Totals.');

  With MTExLocal^ do
  Begin
    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      SQLWhereClause :=                    '(' + ColName ('f_line_type') + ' = ' + QuotedStr(DocFilt[1]) + ') ' +
                                           'And ';

      sColName := ColName('f_stock_code');
      If (Trim(StkToo) <> '') Then
      Begin
        If SingProd Then
          // Filter on Stock Code
          SQLWhereClause := SQLWhereClause + '(' + sColName + ' = ' + StringToHex(#16 + StkToo, 17) + '00000000) '
        Else
          // Filter on Stock Group
          SQLWhereClause := SQLWhereClause + StockGroupFilter(StkToo, sColName) + ' ';
      End // If (Trim(StkToo) <> '')
      Else
        SQLWhereClause := SQLWhereClause + '(' + sColName + ' <> 0x102020202020202020202020202020202000000000) ' +
                                           'And ' +
                                           '(' + sColName + ' <> 0x000000000000000000000000000000000000000000) ';

      SQLWhereClause := SQLWhereClause +   'And ' +
                                           '(' + ColName ('f_line_no') + ' > 0) ' +
                                           'And ' +
                                           '(' + ColName ('f_qty') + ' <> 0) ' +
                                           'And ' +
                                           '((' + ColName ('f_p_date') + ' <= ' + QuotedStr(EDate) + ') And (' + ColName ('f_p_date') + ' >= ' + QuotedStr(SDate) + ')) ' +
                                           'And ' +
                                           '(Not (' + ColName ('f_id_doc_hed') + ' In (' + IntToStr(Ord(PDN)) + ', ' + IntToStr(Ord(SDN)) + ')))';

      // Check Currency
      If (RCr <> 0) Then
      Begin
        SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' = ' + IntToStr(Rcr) + ')';
      End; // If (RCr <> 0)

      // Check Account Filter
      If (Trim(CustFilt) <> '') Then
      Begin
        SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_cust_code') + ' = ' + QuotedStr(CustFilt) + ')';
      End; // If (Trim(CustFilt) <> '')

      // Check Location Filter
      If (Trim(LocFilt) <> '') Then
      Begin
        SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_m_loc_stk') + ' = ' + QuotedStr(LocFilt) + ')';
      End; // If (Trim(LocFilt) <> '')

      // MH 04/10/2013 MRD1.1.27: Added report filter on account types
      If (CRepParamP.IncludeAccountTypes <> atCustomersAndConsumers) Then
      Begin
        // Apply additional filtering on Customer/Consumer sub type
        SQLWhereClause := SQLWhereClause + ' And (tlAcCode In (Select acCode Collate SQL_Latin1_General_CP437_BIN ' +
                                                              'From [' + GetCompanyCode(SetDrive) + '].CUSTSUPP ' +
                                                              'Where acSubType = ''' + IfThen(CRepParamP.IncludeAccountTypes = atCustomersOnly,
                                                                                              ConsumerUtils.CUSTOMER_CHAR,
                                                                                              ConsumerUtils.CONSUMER_CHAR) + '''))';
      End; // If TmpInclude And (CRepParam.IncludeAccountTypes <> atCustomersAndConsumers)

      SQLColumns := '';
      SQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[IDetailF], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);
    End; // If SQLUtils.UsingSQLAlternateFuncs
    {$ENDIF}

    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
      UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LId do
    Begin

      TmpInclude:=((LineNo>0) and (Qty<>0)
                     and (Not EmptyKey(StockCode,StkKeyLen))
                     and ((Currency=RCr) or (RCr=0))
                     and ((PDate<=EDate) and (PDate>=SDate))
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                     and (Not (IdDocHed In DeliverSet))
                     and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff)));

      // MH 04/10/2013 MRD1.1.27: Added report filter on account types
      If TmpInclude And (Not SQLUtils.UsingSQLAlternateFuncs) And (CRepParamP.IncludeAccountTypes <> atCustomersAndConsumers) Then
      Begin
        // Apply additional filtering on Customer/Consumer sub type - for SQL this is done by the prefill cache
        If (Not Assigned(oTraderCache)) Then
          oTraderCache := TTraderCache.Create;

        // Check the caching object to avoid multiple reads of the same record
        TmpInclude := (oTraderCache.GetSubType(LId.CustCode) = IfThen(CRepParamP.IncludeAccountTypes = atCustomersOnly, ConsumerUtils.CUSTOMER_CHAR, ConsumerUtils.CONSUMER_CHAR));
      End; // If TmpInclude And (CRepParam.IncludeAccountTypes <> atCustomersAndConsumers)

      If (TmpInclude) then
      Begin

        If (StockCode<>LStock.StockCode) then
        Begin
          {$IFNDEF EXSQL}
            LGetMainRec(StockF,StockCode);
          {$ELSE}
            // MH 30/06/08: Use GetGEq to try and leverage SQL Caching
            StockKey := FullStockCode(StockCode);
            CStatus := LFind_Rec(B_GetGEq,StockF,StkCodeK,StockKey);
            If (CStatus <> 0) Or (LStock.StockCode <> StockCode) Then
              LResetRec(StockF);
          {$ENDIF}
        End; // If (StockCode<>LStock.StockCode)

        // MH 27/06/08: Added check on whether the Stock Code/Group filter is set prior to going off to check it
        If (Not SingProd) And (Trim(StkToo) <> '') then
        begin
          If (LStock.StockCode <> LastStockCode) Then
          Begin
            TmpInclude:=Stk_InGroup(StkToo,LStock);
            LastStockCode := LStock.StockCode;
            LastResult := TmpInclude;
          End // If (LStock.StockCode <> LastStockCode)
          Else
            TmpInclude := LastResult;
        End; // If (Not SingProd) And (Trim(StkToo) <> '')

        {$IFDEF PF_On}

          If (TmpInclude) then
            For TmpBo:=BOff to BOn do
              TmpInclude:=(TmpInclude and (CheckKey(RCCDep[TmpBo],CCDep[TmpBo],Length(RCCDep[TmpBo]),BOff)));

        {$ENDIF}
      end;

      If (TmpInclude) then
      Begin
        {$IFDEF REPPFC}
        If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
          UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
        {$ENDIF}
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        Case ReportMode of

          10  :  MatchStr:=StockCode+CustCode;
          11  :  MatchStr:=CustCode+StockCode;

        end; {Case..}

        ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,MatchStr,'');

        If (AbortPrint) then
          AbortPrint:=BOff;

        B_Func:=B_GetNext;

      end
      else
      Begin

        B_Func:=B_GetGEq;

        If (PDate<SDate) and (PDate<>'') then
          KeyS2:=FullStkAnal(LineType,SDate,StockCode)
        else
          If (PDate>EDate) and (PDate<>'') then
            KeyS2:=FullStkAnal(LineType,ConstStr(NdxWeight,10),StockCode)
          else
            B_Func:=B_GetNext;
      end;


      {$IFDEF REPPFC}
      If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
      {$ENDIF}
      LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS2);

    end; {While..}

    {$IFDEF REPPFC}
      If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
        DropCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end;

  // MH 04/10/2013 MRD1.1.27: Added report filter on account types
  If Assigned(oTraderCache) Then
    oTraderCache.Free;
end; {Proc..}

{ ==== Make Nominal Id Key ==== }

Function TPBrkReport.Make_NomIdKey(NmCode  :  LongInt;
                                   RCr,
                                   RYr,
                                   RPr     :  Byte)  :  Str20;


Begin

  Make_NomIdKey:=FullNomKey(NmCode)+Chr(0)+Chr(RCr)+Chr(RYr)+Chr(RPr);

end;

  { =========== Proc to Scan and Build Stock Recon Report ========= }

Procedure TPBrkReport.Build_StkReconSales(Fnum,
                                          KeyPath   :  Integer;
                                          RCr,
                                          YrS,PrS,
                                          YrE,PrE   :  Byte;
                                          CustFilt,
                                          LocFilt   :  Str10;
                                      Var AbortPrint,
                                          Ok2Cont
                                                    :  Boolean);



Var

  KeyS2,
  KeyChk,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  TmpInclude,
  FoundOk,
  LoopCtrl
           :  Boolean;

  LoopChk  :  Array[BOff..BOn] of Char;

  {$IFDEF REPPFC}
    SQLPFCRes : LongInt;
    sColName : ShortString;
  {$ENDIF}

  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // ColName
  {$ENDIF}

Begin
  {$IFDEF REPPFC}
   SQLPFCRes := -1;
  {$ENDIF}

  LoopCtrl:=BOff; FoundOk:=BOff;

  LoopChk[BOff]:=StkLineType[SIN];
  LoopChk[BOn]:=StkLineType[ADJ];

  With MTExLocal^ do
  Begin
    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs And Ok2Cont Then
    Begin
      sColName := ColName('f_id_doc_hed');
      SQLWhereClause := '(' +
                          '(' + ColName('f_line_type') + ' = ' + QuotedStr(LoopChk[BOff]) + ') ' +
                          'Or ' +
                          '(' + ColName('f_line_type') + ' = ' + QuotedStr(LoopChk[BOn]) + ')' +
                        ') ' +
                        'And ' +
                        //SubString(' + ColName('f_stock_code') + ',2,16) = ' + StringToHex(LStock.StockCode) + ') ' +
                        //'(tlStockCodeTrans1 = ' + QuotedStr(LStock.StockCode) + ') ' +
                        // MH 31/07/08: Modified to use the indexed Stock Code field to improve performance by ~25%
                        '(tlStockCodeComputed = ' + StringToHex(LStock.StockCode) + StringOfchar('0', 8) + ') ' +
                        'And ' +
                        '(' +
                          '(' + ColName('f_line_no') + ' > 0) ' +
                          'Or ' +
                          '(' +
                            '(' + sColName + ' = ' + IntToStr(Ord(ADJ)) + ') ' +
                            'And ' +
                            '(' + ColName('f_sop_line_no') + ' <> 0) ' +
                            'And ' +
                            '(' + ColName('f_line_no') + ' = ' + IntToStr(Ord(StkLineNo)) + ')' +
                          ') ' +
                          'Or ' +
                          '(' +
                            '(' + sColName + ' In (' + IntToStr(Ord(SIN)) + ', ' +
                                                       IntToStr(Ord(SRC)) + ', '+
                                                       IntToStr(Ord(SCR)) + ', '+
                                                       IntToStr(Ord(SJI)) + ', '+
                                                       IntToStr(Ord(SJC)) + ', '+
                                                       IntToStr(Ord(SRF)) + ', '+
                                                       IntToStr(Ord(SRI)) + ', '+
                                                       IntToStr(Ord(SQU)) + ', '+
                                                       IntToStr(Ord(SOR)) + ', '+
                                                       IntToStr(Ord(SDN)) + ', '+
                                                       IntToStr(Ord(SBT)) + ')) ' +
                            'And ' +
                            '(' + ColName('f_b2b_line_no') + ' <> 1) ' +
                            'And ' +
                            '(' + ColName('f_cost_price') + ' <> 0.0)' +
                          ')' +
                        ') ' +
                        'And ' +
                        '(' + ColName('f_qty') + ' <> 0.0) ' +
                        'And ' +
                        '(' + ColName('f_deduct_qty') + ' <> 0.0)';

      If (RCr <> 0) Then
      Begin
        // Filter on Currency
        SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' = ' + IntToStr(Rcr) + ')';
      End; // If (RCr <> 0)

      // Filter on period range
      SQLWhereClause := SQLWhereClause + ' And (' +
                                                '(((' + ColName('f_p_yr') + ' = ' + IntToStr(YrS) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(PrS) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(YrS) + ')) ' +
                                                'And ' +
                                                '(((' + ColName('f_p_yr') + ' = ' + IntToStr(YrE) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(PrE) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(YrE) + '))' +
                                              ')';

      // and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))

      // and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff))

      SQLWhereClause := SQLWhereClause + ' And ('  + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) +')';

      If (LStock.StockType=StkBillCode) Then
      Begin
//        If (KitLink=1) and (LStock.StockType=StkBillCode) and (LStock.NomCodes[4]<>LStock.NomCodes[5]) and (B2BLineNo<>1) and (IdDocHed=ADJ) then
//          TmpInclude:=BOff;
        If (LStock.NomCodes[4] <> LStock.NomCodes[5]) Then
        Begin
          SQLWhereClause := SQLWhereClause + ' And (' +
                                                    '(' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(ADJ)) + ') ' +
                                                    'Or ' +
                                                    '(' + ColName('f_b2b_line_no') + ' = 1) ' +
                                                    'Or ' +
                                                    '(' + ColName('f_kit_link') + ' <> 1)' +
                                                  ')';
        End; // If (LStock.NomCodes[4] <> LStock.NomCodes[5])

//          If (IdDocHed In SalesSplit) and (LStock.StockType=StkBillCode) and (LStock.NomCodes[4]<>LStock.NomCodes[5])
//          and (TmpInclude) and (Not CRepParamP^.FGMode) then
//            TmpInclude:=BOff;
        If (LStock.NomCodes[4] <> LStock.NomCodes[5]) and (Not CRepParamP^.FGMode) Then
        Begin
          SQLWhereClause := SQLWhereClause + ' And (Not (' + ColName('f_id_doc_hed') + ' In (' + IntToStr(Ord(SIN)) + ', ' +
                                                                                                 IntToStr(Ord(SRC)) + ', '+
                                                                                                 IntToStr(Ord(SCR)) + ', '+
                                                                                                 IntToStr(Ord(SJI)) + ', '+
                                                                                                 IntToStr(Ord(SJC)) + ', '+
                                                                                                 IntToStr(Ord(SRF)) + ', '+
                                                                                                 IntToStr(Ord(SRI)) + ', '+
                                                                                                 IntToStr(Ord(SQU)) + ', '+
                                                                                                 IntToStr(Ord(SOR)) + ', '+
                                                                                                 IntToStr(Ord(SDN)) + ', '+
                                                                                                 IntToStr(Ord(SBT)) +
                                                                                           ')' +
                                                       '))';
        End; // If (LStock.NomCodes[4]<>LStock.NomCodes[5]) and (Not CRepParamP^.FGMode)
      End; // If (LStock.StockType=StkBillCode)

      SQLColumns := '';
      SQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[Fnum], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);
    End // If SQLUtils.UsingSQLAlternateFuncs And Ok2Cont
    Else
      SQLPFCRes := -1;
    {$ENDIF}

    Repeat
      KeyChk:=LoopChk[LoopCtrl]+LStock.StockCode;
      KeyS2:=KeyChk;

      {$IFDEF REPPFC}
        If (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
      {$ENDIF}
      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (Ok2Cont) and (ChkRepAbort) do
      With LId do
      Begin

        TmpInclude:=(((LineNo>0) or ((IdDocHed=ADJ) and (SOPLineNo<>0) and (LineNo=StkLineNo))
                                 or ((IdDocHed In SalesSplit) and (B2BLineNo<>1) and (CostPrice<>0.0)))
                     and (Qty<>0) and (DeductQty<>0)
                     and ((Currency=RCr) or (RCr=0))
                     and ((Pr2Fig(PYr,PPr)>=Pr2Fig(YrS,PrS)) and (Pr2Fig(PYr,PPr)<=Pr2Fig(YrE,PrE)))
                     and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                     and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff))
                     and (IdDocHed<>RUN));


        If (TmpInclude) then
        With LInv do
        Begin
          MatchStr:=FullNomKey(FolioRef);

          If (FolioNum<>FolioRef) then
            LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,MatchStr)
          else
            LStatus:=0;

          TmpInclude:=((RunNo>0) or (RunNo=StkAdjRunNo)) and (LStatusOk);


        end;

        If (TmpInclude) then
        Begin
        {* Non building BOMS do not affect stock value at all, so exclude them.
           There may be problems if stock value has been used for WIP, or Write off
           code as well... *}

            If (KitLink<>1) and (LStock.StockType=StkBillCode)
              and (NomCode<>LStock.NomCodes[4+Ord(CRepParamP^.FGMode)]) and (IdDocHed=ADJ) then
            TmpInclude:=BOff;

            If (Not TmpInclude) and (CRepParamP^.FGMode) then {* v5.61 It may be a WOR build so we want to include in FG report *}
            Begin
              TmpInclude:=(Match_Glob(Sizeof(LInv.TransDesc),'Bld',LInv.TransDesc,FoundOk) and (NomCode=LStock.WOPWIPGL)) ;

            end;

          {* v4.31 When building new BOMS, exclude BOM lines, as deduction came via hidden lines,
          {* v5.61 unless G/L codes are the same, in which case do not supress as we want to report *}

          If (KitLink=1) and (LStock.StockType=StkBillCode) and (LStock.NomCodes[4]<>LStock.NomCodes[5])
              and (B2BLineNo<>1) and (IdDocHed=ADJ) then
            TmpInclude:=BOff;


          {* If we are selling a BOM, it should not appear either, as we will be selling from WIP *}

          If (IdDocHed In SalesSplit) and (LStock.StockType=StkBillCode) and (LStock.NomCodes[4]<>LStock.NomCodes[5])
          and (TmpInclude) and (Not CRepParamP^.FGMode) then
            TmpInclude:=BOff;

        end;




        If (TmpInclude) then
        Begin
          {$IFDEF REPPFC}
            If (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
          {$ENDIF}
          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          MatchStr:=Form_Int(LStock.NomCodes[4+Ord(CRepParamP^.FGMode)],6)+FullStockCode(StockCode)+Form_Int(Pr2Fig(PYr,PPr),0);

          ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,MatchStr,'');

          If (AbortPrint) then
            AbortPrint:=BOff;

        End; // If (TmpInclude)


        {$IFDEF REPPFC}
          If (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
        {$ENDIF}
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

      end; {While..}

      LoopCtrl:=Not LoopCtrl;
    Until (Not Ok2Cont) or (Not LoopCtrl);

    {$IFDEF REPPFC}
      If (SQLPFCRes = 0) Then
        DropCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end;

end; {Proc..}



Procedure TPBrkReport.Build_StkReconQtyOnly(Fnum,
                                            KeyPath   :  Integer;
                                            RCr,
                                            YrS,PrS,
                                            YrE,PrE   :  Byte;
                                            CustFilt,
                                            LocFilt   :  Str10;
                                            StkToo    :  Str20;
                                            GLCode    :  LongInt;
                                        Var AbortPrint,
                                            Ok2Cont
                                                      :  Boolean);



Var

  KeyS2,
  KeyChk,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  TmpInclude
           :  Boolean;



Begin

  With MTExLocal^ do
  Begin

    KeyChk:=Strip('R',[#0],FullRunNoKey(0,GLCode));

    KeyS2:=KeyChk;


    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (Ok2Cont) and (ChkRepAbort) do
    With LId do
    Begin

      TmpInclude:=((LineNo>0) and (Qty<>0)
                   and ((Currency=RCr) or (RCr=0))
                   and ((Pr2Fig(PYr,PPr)>=Pr2Fig(YrS,PrS)) and (Pr2Fig(PYr,PPr)<=Pr2Fig(YrE,PrE)))
                   and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                   and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff))
                   and (Not (IdDocHed In [RUN,TSH,NMT])));


      If (TmpInclude) then
      With LInv do
      Begin
        MatchStr:=FullNomKey(FolioRef);

        If (FolioNum<>FolioRef) then
          LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,MatchStr);

        TmpInclude:=(RunNo>0);


      end;


      If (Not EmptyKey(StkToo,StkKeyLen)) and (TmpInclude) then
      Begin
        If (StockCode<>LStock.StockCode) then
          LGetMainRec(StockF,StockCode);

        TmpInclude:=Stk_InGroup(StkToo,LStock);
      end;


      If (TmpInclude) then
      Begin

        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

        MatchStr:=Form_Int(GLCode,6)+FullStockCode(StockCode)+Form_Int(Pr2Fig(PYr,PPr),0);

        ThisScrt^.Add_Scratch(Fnum,IdFolioK,RecAddr,MatchStr,'');

        If (AbortPrint) then
          AbortPrint:=BOff;

      end;


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

    end; {While..}

  end;

end; {Proc..}


{ =========== Proc to Scan and Build Stock Recon Report ========= }

Procedure TPBrkReport.Build_StkRecon(Fnum,
                                     KeyPath   :  Integer;
                                     RCr,
                                     YrS,PrS,
                                     YrE,PrE   :  Byte;
                                     CustFilt,
                                     LocFilt   :  Str10;
                                     StkToo    :  Str20;
                                 Var AbortPrint
                                               :  Boolean);


Const
  Fnum2      =  IDetailF;
  Keypath2   =  IdNomK;



Var

  UseCr    :  Byte;

  TmpStat,
  TmpKPath :  Integer;

  KeyS2,
  KeyChk,
  KeyStk,
  KeyFG,
  HedStr,
  MatchStr :  Str255;

  TmpRecAddr,
  RecAddr,
  SLastBsNom,
  PurgeCount,
  PurgeTotal
           :  LongInt;

  B_Func   :  Integer;

  TmpStock,
  TmpStock2
           :  StockRec;

  TmpInclude,
  TmpBo,
  Ok2Cont
           :  Boolean;
  {$IFDEF REPPFC}
    SQLPFCRes : LongInt;
    sColName : ShortString;
  {$ENDIF}

Procedure Create_FGStockSeq;

Const
  SFnum    =  StockF;
  SKeypath =  StkCodeK;

Var
  KeyFGStk  :  Str255;
  BtrOpFirst, BtrOpNext : Byte;
  {$IFDEF REPPFC}
    SQLPrefillCacheID : LongInt;
    SQLWhereClause : ANSIString;
    SQLColumns : ANSIString;
    SQLPFCRes : LongInt;
    sColName : ShortString;
  {$ENDIF}
Begin
  If (Not Assigned(FGScrt)) then
    New(FGScrt,Init(26,MTExLocal,BOff));

  {$IFDEF REPPFC}
   SQLPFCRes := -1;
  {$ENDIF}

  With MTExLocal^ do
  Begin
    BtrOpFirst := B_StepFirst;
    BtrOpNext := B_StepNext;

    {$IFDEF REPPFC}
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      SQLWhereClause := '(' + GetDBColumnName('Stock.Dat', 'f_stock_type', '') + '=' + QuotedStr(StkBillCode) + ')';
      SQLColumns := '';
      SQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[SFnum], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);

      If (SQLPFCRes = 0) Then
      Begin
        // Switch to Get operations as PFC doesn't support Step operations
        BtrOpFirst := B_GetFirst;
        BtrOpNext := B_GetNext;
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
      End; // If (SQLPFCRes = 0)
    End; // If SQLUtils.UsingSQLAlternateFuncs
    {$ENDIF}
    LStatus:=LFind_Rec(BtrOpFirst,SFnum,SKeyPath,KeyFGStk);

    While (LStatusOk) and (ChkRepAbort) do
    Begin
      With LStock do
      Begin
        If (StockType=StkBillCode) then
        Begin
          {$IFDEF REPPFC}
          If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
          {$ENDIF}
          LStatus:=LGetPos(SFnum,RecAddr);  {* Get Preserve IdPosn *}

          MatchStr:=Form_Int(NomCodes[5],6)+StockCode;

          FGScrt^.Add_Scratch(SFnum,StkCodeK,RecAddr,MatchStr,'');
        End; // If (StockType=StkBillCode)

        {$IFDEF REPPFC}
        If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
        {$ENDIF}
        LStatus:=LFind_Rec(BtrOpNext,SFnum,SKeyPath,KeyFGStk);
      End; // With LStock
    End; // While (LStatusOk) and (ChkRepAbort)

    {$IFDEF REPPFC}
      If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
        DropCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end; {With..}
end; {Proc..}


  {$IFDEF REPPFC}
  Function ColName(Const ColumnName : ShortString; Const FileName : ShortString = 'Details.Dat') : ShortString;
  Begin // ColName
    Result := GetDBColumnName(FileName, ColumnName, '')
  End; // ColName
  {$ENDIF}

Begin

  AbortPrint:=BOn;

  SQLPFCRes := -1;

  Ok2Cont:=BOn;

  SLastBSNom:=1;

  HedStr:='';

  If (CRepParamP^.FGMode) then
  Begin
    // Go create file in fg code order

    try
      Create_FGStockSeq;

      If (Assigned(FGScrt)) then
        KeyFG:=FullNomKey(FGScrt^.Process)
      else
        Ok2Cont:=BOff;

      KeyStk:=KeyFG;
    except
      FGScrt:=nil;
      Ok2Cont:=BOff;
    end; {try..}
  end
  else
    KeyStk:=FullNomKey(SLastBSNom);

  ShowStatus(2,'Calculating Totals.');

  With MTExLocal^,CRepParamP^ do
  Begin

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyStk);

    While (LStatusOk) and ((Not FGMode) or (CheckKey(KeyFG,KeyStk,Length(KeyFG),BOn))) and (Ok2Cont) and (ChkRepAbort) do
    With LStock do
    Begin
      TmpInclude:=BOn;

      {$IFDEF PF_On}
        If (FGMode) then
        Begin
          If (Assigned(FGScrt)) then {* Get Id Link *}
            FGScrt^.Get_Scratch(LRepScr^)
          else
            TmpInclude:=BOff;

        end;

        For TmpBo:=BOff to BOn do
        With CRepparamP^ do
          TmpInclude:=(TmpInclude and (CheckKey(RCCDep[TmpBo],CCDep[TmpBo],Length(RCCDep[TmpBo]),BOff)));

      {$ENDIF}

      If (TmpInclude) then {* Don't pick up desc only items stock records as a trigger, although they will get picked
                              up if they have a genuine stock value code in them and used on a purchase *}
        TmpInclude := (StockType <> StkDescCode)
                      And
                      (
                        (LastStockType <> StkDescCode)
                        Or
                        (StockType <> StkDListCode)
                      )
                      And
                      (
                        (Not FGMode)
                        Or
                        (StockType = StkBillCode)
                      )
                      And
                      (StockType<>StkGrpCode);

      If (TmpInclude) then
      Begin
        If (NomCodes[4+Ord(FGMode)]<>SLastBSNom) then
        Begin
          SLastBSNom:=NomCodes[4+Ord(FGMode)];

          TmpKPath:=Keypath;

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          TmpStock2:=LStock;


          {$IFDEF MC_On}

            If (RCr=0) then
              UseCr:=1
            else
          {$ENDIF}

            UseCr:=RCr;

          KeyChk:=FullNomKey(SLastBSNom)+Chr(0);

          KeyS2:=Make_NomIdKey(SLastBSNom,UseCr,YrS,PrS);

          MatchStr:='';

          RecAddr:=0;

          TmpInclude:=BOff;

          B_Func:=B_GetNext;

          {$IFDEF REPPFC}
          If SQLUtils.UsingSQLAlternateFuncs Then
          Begin
            // Duplicate the effect of the Manual Key Index
            SQLWhereClause := '((' + ColName('f_nom_code') + ' > 0) And ((' + ColName('f_nom_mode') + ' <> 0) Or (' + ColName('f_p_yr') + ' <> 0) or (' + ColName('f_p_pr') + ' <> 0) or (' + ColName('f_currency') + ' <> 0)) And (' + ColName('f_posted_run') + ' <> 0)) ' +
                              'And (' + ColName('f_line_no') + ' > 0) And (' + ColName('f_qty') + ' <> 0) ' +
                              'And (' + ColName('f_posted_run') + ' > 0) ' +
                              'And (' + ColName('f_id_doc_hed') + ' <> ' + IntToStr(Ord(RUN)) + ')';

            If (RCr <> 0) Then
            Begin
              // Filter on Currency
              SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' = ' + IntToStr(Rcr) + ')';
            End; // If (RCr <> 0)

            // Filter on period range
            SQLWhereClause := SQLWhereClause + ' And (' +
                                                      '(((' + ColName('f_p_yr') + ' = ' + IntToStr(YrS) + ') And (' + ColName('f_p_pr') + ' >= ' + IntToStr(PrS) + ')) Or (' + ColName('f_p_yr') + ' > ' + IntToStr(YrS) + ')) ' +
                                                      'And ' +
                                                      '(((' + ColName('f_p_yr') + ' = ' + IntToStr(YrE) + ') And (' + ColName('f_p_pr') + ' <= ' + IntToStr(PrE) + ')) Or (' + ColName('f_p_yr') + ' < ' + IntToStr(YrE) + '))' +
                                                    ')';

            {$IFDEF MC_On}
              SQLWhereClause := SQLWhereClause + ' And (' + ColName('f_currency') + ' <> 0)';
            {$ENDIF}

            sColName := ColName ('f_id_doc_hed');
            SQLWhereClause := SQLWhereClause + ' And (' +
                                                      '(' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SIN)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SRC)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SCR)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SJI)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SJC)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SRF)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SRI)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SQU)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SOR)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SDN)) + ') And ' +
                                                        '(' + sColName + ' <> ' + IntToStr(Ord(SBT)) + ')' +
                                                      ')' +
                                                      ' Or ' +
                                                      '(' + ColName ('f_stock_code') + ' = '''')' +
                                                   ')';

            SQLColumns := ''; // All columns
            SQLPFCRes := CreateCustomPrefillCache(SetDrive+FileNames[Fnum2], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);

            If (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
          End; // If SQLUtils.UsingSQLAlternateFuncs
          {$ENDIF}
          LStatus:=LFind_Rec(B_GetGEq,Fnum2,KeyPath2,KeyS2);

          While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (Ok2Cont) and (ChkRepAbort) do
          With LId do
          Begin
            TmpInclude:=((LineNo>0) and (Qty<>0)
                         and ((Currency=RCr) or (RCr=0))
                         and ((Pr2Fig(PYr,PPr)>=Pr2Fig(YrS,PrS)) and (Pr2Fig(PYr,PPr)<=Pr2Fig(YrE,PrE)))
                         and (CheckKey(CustFilt,CustCode,Length(CustFilt),BOff))
                         and (CheckKey(LocFilt,MLocStk,Length(LocFilt),BOff))
                         and (PostedRun>0)
                         and (IdDocHed<>RUN));

            {$IFDEF MC_On}

              TmpInclude:=(TmpInclude and (Currency<>0));

            {$ENDIF}



            If (TmpInclude) then
            Begin



              TmpInclude:=((Not (IdDocHed In SalesSplit)) or (EmptyKey(StockCode,StkKeyLen)));

              If (Not EmptyKey(StkToo,StkKeyLen)) and (TmpInclude) then
              Begin
                If (StockCode<>LStock.StockCode) then
                  LGetMainRec(StockF,StockCode);

                TmpInclude:=Stk_InGroup(StkToo,LStock);
              end;


              If (TmpInclude) then
              With LInv do
              Begin
                MatchStr:=FullNomKey(FolioRef);

                If (FolioNum<>FolioRef) then
                  LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,MatchStr);



                HedStr:=AutoNomHedTit[6]+'. ADJ';

                TmpInclude:=((Not AutoPost) and (Not CheckKey(AutoNomHedTit[1],TransDesc,Length(AutoNomHedTit[1]),BOff))
                             and (Not CheckKey(HedStr,TransDesc,Length(HedStr),BOff)));

              end;

            end;

            If (TmpInclude) then
            Begin
              {$IFDEF REPPFC}
              If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
              {$ENDIF}
              LStatus:=LGetPos(Fnum2,RecAddr);  {* Get Preserve IdPosn *}

              {$IFDEF DBD}
                If (Debug) then
                Begin
                  If (SLastBSNom=77020) then
                    MEssageBeep(0);
                end;
              {$ENDIF}

              MatchStr:=Form_Int(SLastBSNom,6)+FullStockCode(StockCode)+Form_Int(Pr2Fig(PYr,PPr),0);

              ThisScrt^.Add_Scratch(Fnum2,IdFolioK,RecAddr,MatchStr,'');

              If (AbortPrint) then
                AbortPrint:=BOff;

              B_Func:=B_GetNext;

            end
            else
            Begin

              B_Func:=B_GetGEq;

              If (Pr2Fig(PYr,PPr)<Pr2Fig(YrS,PrS)) then
                KeyS2:=Make_NomIdKey(NomCode,Currency,YrS,PrS)
              else
                If (Pr2Fig(PYr,PPr)>Pr2Fig(YrE,PrE)) then
                Begin
                  {$IFDEF MC_On}
                    If (UseCr<CurrencyType) then
                    Begin
                      If (UseCr<Currency) then
                        UseCr:=Currency;

                      Inc(UseCr);

                      KeyS2:=Make_NomIdKey(NomCode,UseCr,YrS,PrS);
                    end
                    else
                  {$ENDIF}

                  KeyS2:=Make_NomIdKey(FirstAddrD,UseCr,YrS,PrS);

                end
                else
                  B_Func:=B_GetNext;
            end;

            {$IFDEF REPPFC}
            If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
            {$ENDIF}
            LStatus:=LFind_Rec(B_Func,Fnum2,KeyPath2,KeyS2);
          end; {While..}

          {$IFDEF REPPFC}
            If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0) Then
            Begin
              DropCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
              SQLPrefillCacheID := 0;
            End; // If SQLUtils.UsingSQLAlternateFuncs And (SQLPFCRes = 0)
          {$ENDIF}

          {$IFNDEF STKRECVALTEST}
          // MH 28/07/2010 v6.4: Added compiler def to allow test versions to be compiled without this call - analysis
          //                     has suggested that this routine does nothing but read data (approx 19% of Find_Rec calls
          //                     on Demo Data) and can never add anything into the temporary file as it requires TH.RunNo
          //                     to be > 0 and TL.RunNo to be = 0 - which should never happen
          Build_StkReconQtyOnly(Fnum2,IdRunK,RCr,YrS,PrS,YrE,PrE,CustFilt,LocFilt,StkToo,SLastBSNom,AbortPrint,Ok2Cont);
          {$ENDIF}

          TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

          LStock:=TmpStock2;

        end;

        TmpStock:=LStock;

        If (Stk_InGroup(StkToo,TmpStock)) and (StockType In StkProdSet) and (Ok2Cont) then
          Build_StkReconSales(Fnum2,IdAnalK,RCr,YrS,PrS,YrE,PrE,CustFilt,LocFilt,AbortPrint,Ok2Cont);
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyStk);

    end; {While..}
  end;

  If (Not Ok2Cont) then
    AbortPrint:=BOn;

end; {Proc..}



Procedure TPBrkReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^, CRepParamP^ do
  Begin
    Case ReportMode of
      10,11,15,16  :  Case DDMode of
                        0  :  Begin

                                Case ReportMode of
                                  10  :  Begin
                                           SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);
                                         end;

                                  11
                                      :  Begin
                                           SendRepDrillDown(1,TotTabs,1,FullStockCode(LStock.StockCode),StockF,StkCodeK,1);
                                         end;
                                  15
                                      :  Begin
                                           SendRepDrillDown(1,TotTabs,1,LId.DocPRef,InvF,InvOurRefK,0);

                                           SendRepDrillDown(1,2,2,FullStockCode(LId.StockCode),StockF,StkCodeK,1);

                                           If (ReportMode=15) then
                                             SendRepDrillDown(7,7,2,FullCustCode(LId.CustCode),CustF,CustCodeK,0);
                                         end;
                                  16
                                      :  Begin
                                           SendRepDrillDown(1,TotTabs,1,FullStockCode(LastProd),StockF,StkCodeK,1);
                                         end;
                                end; {Case..}
                              end;

                        1  :  SendRepDrillDown(1,TotTabs,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);

                        2  :  Begin

                                Case ReportMode of
                                  10,15
                                      :  Begin
                                           SendRepDrillDown(1,TotTabs,1,FullStockCode(LastProd),StockF,StkCodeK,1);

                                         end;

                                  11  :  Begin
                                           SendRepDrillDown(1,TotTabs,1,FullCustCode(LastCust),CustF,CustCodeK,0);
                                         end;

                                end; {Case..}
                              end;

                      end; {Case..}

    end; {Case..}
  end; {With..}
end;


{ ======================= Get Opening & Closing Balances & Print them =================== }

Procedure TPBrkReport.PrintOCBal2(Rcr,RTxCr:  Byte;
                                  OBal,
                                  CBal     :  Real;
                                  Mode     :  Byte;
                                  CloseBal :  Boolean);


Const
  OBalStr  :  Array[BOff..BOn] of Str50 = ('Opening','Closing');


Var
  Rnum                 :  Real;
  NCrDr                :  DrCrType;
  GenStr               :  Str255;


Begin
  With RepFiler1,MTExLocal^ do
  Begin

    Rnum:=Currency_Txlate(OBal,RCr,RTxCr);

    ShowDrCr(Rnum,NCrDr);

    GenStr:=Form_Int(LNom.NomCode,0)+','+LNom.Desc+'.';

    Case Mode of
      1
         :  Begin
              ClearTabs;

              SetTab (MarginLeft, pjLeft, 78, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);

              SetTabCount;
              SetReportDrillDown(1);

              SendText(ConCat(#9,GenStr,OBalStr[CloseBal]+' Balance',
                           #9,FormatFloat(GenRealMask,Rnum)));

              If (CloseBal) and (OBal<>CBal) then
                SendLine(ConCat(ConstStr(#9,3),'Difference : '#9,FormatFloat(GenRealMask,OBal-CBal)))
              else
                // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                Self.CRLF;

              DefLine(-1,TabStart(1),TabEnd(4),0);

              RepSetTabs;

            end;
    end;


    If (CloseBal) then
    Begin
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
    end;

  end; {With..}
end;



{ ======================= Due Sub / Grand Total ================ }

Procedure TPBrkReport.PrintStockTot(GMode     :  Byte);

Var
  n          :  Byte;

  CompCBal,
  Dnum       :  Double;

  T1,T2      :  Integer;

  GenStr     :  Str255;


Begin
  Dnum:=0;

  GenStr:='';
  T1 := 0;
  T2 := 0;

  With RepFiler1,MTExLocal^,  CRepParamP^ do
  Begin
    If (ReportMode In [10,11]) and (GMode=1) then
      SetReportDrillDown(2);


    Case ReportMode of
       10
          :  Begin
               Case GMode of
                 1  :  DefLine(-1,TabStart(2),TabEnd(8),0);



                 2  :  Begin


                         ProdTot:=RepTot;

                         DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

                       end;

               end; {Case..}


               ProdTot[4]:=(ProdTot[3]-ProdTot[2]);

               ProdTot[5]:=Calc_Pcnt(ProdTot[3],ProdTot[4]);



               SendLine(ConCat(#9,#9,'Total:',
                               #9,FormatFloat(GenQtyMask,ProdTot[1]),#9,
                               #9,FormatFloat(GenRealMask,ProdTot[2]),
                               #9,FormatFloat(GenRealMask,ProdTot[3]),
                               #9,FormatFloat(GenRealMask,ProdTot[4]),
                               #9,FormatFloat(GenPcntMask,ProdTot[5])));

               {Case GMode of

                 1  :  DefLine(-2,TabStart(2),TabEnd(8),0);


               end; {Case..}

               Blank(ProdTot,Sizeof(ProdTot));

             end; {Case..}

       11
          :  Begin
               Case GMode of
                 1  :  DefLine(-1,TabStart(2),TabEnd(8),0);



                 2  :  Begin


                         ProdTot:=RepTot;

                         DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);


                       end;

               end; {Case..}


               ProdTot[4]:=(ProdTot[3]-ProdTot[2]);

               ProdTot[5]:=Calc_Pcnt(ProdTot[3],ProdTot[4]);


               SendLine(ConCat(#9,#9,'Total:',
                               #9,FormatFloat(GenQtyMask,ProdTot[1]),#9,
                               #9,FormatFloat(GenRealMask,ProdTot[2]),
                               #9,FormatFloat(GenRealMask,ProdTot[3]),
                               #9,FormatFloat(GenRealMask,ProdTot[4]),
                               #9,FormatFloat(GenPcntMask,ProdTot[5])));

               {Case GMode of

                 1  :  DefLine(-2,TabStart(2),TabEnd(8),0);


               end; {Case..}

               Blank(ProdTot,Sizeof(ProdTot));

             end; {Case..}


       15,16
          :  Begin
               DefFont(0,[fsBold]);


               Case ReportMode of
                 15  :  Begin
                          T1:=10;
                        end;

                 16  :  Begin
                          T1:=5;
                        end;
               end; {Case..}

               Case GMode of

                 1,2
                    :  Begin

                         If (GMode=2) then
                         Begin
                           ProdTot:=CustTot;

                           GenStr:='Total value for : '+Form_Int(LNom.NomCode,0);
                         end
                         else
                           GenStr:='Total : '+Strip('B',[#32],LastProd);



                         DefLine(-1,TabStart(2),TabEnd(T1),-0.6);


                       end;

                 3,4
                    :  Begin

                         If (GMode=3) then
                           ProdTot:=RepTot
                         else
                         Begin
                           Blank(ProdTot,Sizeof(ProdTot));

                           ProdTot[1]:=OBalTot+(RepTot[2]-RepTot[3]);
                           ProdTot[2]:=CBalTot;

                           ProdTot[3]:=ProdTot[1]-ProdTot[2];
                         end;

                         DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);


                       end;

               end; {Case..}

               ClearTabs;


               If (GMode<>4) then
               Begin
                 ProdTot[4]:=(ProdTot[2]-ProdTot[3]);

                 If (GMode=2) then
                   ProdTot[4]:=ProdTot[4]+BSOBal;

                 Dnum:=ProdTot[1];

                 SetTab (MarginLeft+43, pjLeft, 78+(8*Ord(ReportMode=15)), 4, 0, 0);
                 SetTab (NA, pjLeft, 13, 4, 0, 0);
                 SetTab (NA, pjRight, 29, 4, 0, 0);
                 SetTab (NA, pjLeft, 10, 4, 0, 0);
                 SetTab (NA, pjRight, 29, 4, 0, 0);
                 SetTab (NA, pjRight, 29, 4, 0, 0);
                 SetTab (NA, pjRight, 29, 4, 0, 0);

                 SetTabCount;

                 If (GMode In [1,2]) then
                   SetReportDrillDown(3-GMode);


                 SendLine(ConCat(#9,GenStr,#9,'Balance:',
                                 #9,FormatFloat(GenRealMask,ProdTot[4]),
                                 #9,'Total:',
                                 #9,FormatFloat(GenQtyMask,Dnum),
                                 #9,FormatFloat(GenRealMask,ProdTot[2]),
                                 #9,FormatFloat(GenRealMask,ProdTot[3])));


               end
               else
                 If (Not SingProd) then
                 Begin

                   SetTab (MarginLeft, pjLeft, 55+(8*Ord(ReportMode=15)), 4, 0, 0);
                   SetTab (NA, pjRight, 29, 4, 0, 0);
                   SetTab (NA, pjLeft, 50, 4, 0, 0);
                   SetTab (NA, pjRight, 29, 4, 0, 0);
                   SetTab (NA, pjLeft, 29, 4, 0, 0);
                   SetTab (NA, pjRight, 39, 4, 0, 0);

                   SendLine(ConCat(#9,'Opening',' ','Balances',' ','+',' ','Movement:',
                                   #9,FormatFloat(GenRealMask,ProdTot[1]),
                                   #9,'Total',' ','Closing',' ','Balances:',
                                   #9,FormatFloat(GenRealMask,ProdTot[2]),
                                   #9,'Difference......:',
                                   #9,FormatFloat(GenRealMask,ProdTot[3])));
                 end;

               RepSetTabs;


               Case GMode of

                 1,2  :  Begin

                           SendLine('');

                           If (GMode=2) then
                           With LNom do
                           Begin

                             CompCBal:=Get_OCBal(NomType,FullNomKey(NomCode),RCr,YrT,PrT,1,BOn);

                             PrintOCBal2(RCr,RTxCr,CompCBal,ProdTot[4],1,BOn);

                             OBalTot:=OBalTot+BSOBal;

                             CBalTot:=CBalTot+CompCBal;
                           end;
                         end;

               end; {Case..}

               If (Gmode=2) then
                 Blank(CustTot,Sizeof(CustTot));

               Blank(ProdTot,Sizeof(ProdTot));

               DefFont(0,[]);

             end; {Case..}


     end; {Case..}
  end; {With..}

end;



{ ======================= Due Include ======================= }


Function TPBrkReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;
  DayRepInc  :  Boolean;


  ChkRecon   :  Byte;

  KeyS2       :  Str255;


Begin

  {$B-}

  With MTExLocal^, CRepParamP^ do
  Begin



    Case ReportMode of

      10,11,15,16
           :  With LId  do
              Begin



                If (ThisScrt<>NIL) then {* Get Id Link *}
                  ThisScrt^.Get_Scratch(LRepScr^);


                TmpInclude:=BOn;

                Case ReportMode of

                  10  :  Begin
                           If (LastCust='') then
                           Begin

                             LastCust:=CustCode;

                             LGetMainRec(CustF,LastCust);

                           end;
                         end;
                  11  :  Begin
                           If (LastProd='') then
                           Begin

                             LastProd:=StockCode;

                             LGetMainRec(StockF,LastProd);

                           end;
                         end;

                  15,16
                      :  Begin

                           If (CustCode<>LCust.CustCode) and (ReportMode<>16) then
                             LGetMainRec(CustF,CustCode);


                           If (LStock.StockCode<>StockCode) then
                             LGetMainRec(StockF,StockCode);


                           If (IdDocHed=NMT) or (EmptyKey(StockCode,StkKeyLen)) then {* Allow for NMT *}
                           Begin
                             LStock.NomCodes[4+Ord(FGMode)]:=NomCode;
                             LStock.Desc[1]:='Nominal Journals';
                             LStock.StockCode:=NdxWeight;
                           end
                           else
                             If (LStock.NomCodes[4+Ord(FGMode)]<>NomCode) and (IdDocHed In PurchSplit) then
                               LStock.NomCodes[4+Ord(FGMode)]:=NomCode;

                           RepNomCode:=LStock.NomCodes[4+Ord(FGMode)];

                           If (FolioRef<>LInv.FolioNum) then
                           Begin

                             KeyS2:=FullNomKey(FolioRef);

                             LStatus:=LFind_Rec(B_GetEq,InvF,InvFolioK,KeyS2);

                           end;


                         end;

                end; {Case..}
              end;
           else  //PR: 23/03/2016 v2016 R2 ABSEXCH-17390
             raise Exception.Create('Invalid ReportMode in TPBrkReport.IncludeRecord: ' + IntToStr(ReportMode));

    end; {Case..}

  end; {With..}

    {$B+}

    Result:=TmpInclude;
end; {Func..}




Procedure TPBrkReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParamP^ do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of

      10
          :  SendLine(ConCat(#9,'Acc',' ','No',#9,'Company',#9,'Qty',' ','Sold',#9,#9,
                     'Cost',#9,'Sales',#9,'Margin',#9,'GP%'));


      11
          :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'Qty',' ','Sold',#9,
                     #9,'Cost',#9,'Sales',#9,'Margin',#9,'GP%'));

      15  :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'Our',' ','Ref',
                     #9,'Your',' ','Ref',#9,'Per/Yr',#9,'Date',#9,'A/C',#9,'Qty',
                     #9,'Dr',#9,'Cr'));

      16  :  SendLine(ConCat(#9,'Stock',' ','Code',#9,'Description',#9,'Qty',
                     #9,'Dr',#9,'Cr'));


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TPBrkReport.RepPrintHeader(Sender  :  TObject);

Var
  TStockRec  :  StockRec;

Begin

  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1 do
  Begin
    TStockRec:=LStock;
    
    Case ReportMode of
       10,15
            :  If (CurrentPage>1) then
                 PrintStkLine(LStock.StockCode,BOn);
        11  :  If (CurrentPage>1) then
                 PrintCustLine(LCust.CustCode,BOn);

    end; {Case..}

    LStock:=TStockRec;
  end;
end;




  { ======================= Calculate Due Totals ==================== }

  Procedure TPBrkReport.CalcDueTotals(STot      :  Totals);

  Var
    nBo        :  Boolean;
    Rnum       :  Real;
    n          :  SmallInt;

  Begin

    Rnum:=0;

    With MTExLocal^,CRepParamP^ do
      Case ReportMode of

        10,11,15,16
           :  Begin

                For n:=1 to NoTotals do
                Begin
                  CustTot[n]:=CustTot[n]+Stot[n];
                  RepTot[n]:=RepTot[n]+Stot[n];
                  ProdTot[n]:=ProdTot[n]+Stot[n];
                end;

              end;


      end; {Case..With..}
  end;




Procedure TPBrkReport.PrintReportLine;



Var
  QPNum,
  Rnum,
  Rnum2,
  RnumC      :  Real;

  ReconQty,
  Dnum       :  Double;

  n,UOR      :  Byte;

  LineTot    :  Totals;

  TBo,
  Ok2Print   :  Boolean;

  CrDr       :  DrCrType;

  GenStr,
  GenStr2    :  Str255;

  CostRates  :  CurrTypes;


Begin
  Rnum:=0;

  Rnum2:=0;

  RnumC:=0;

  Dnum:=0;

  QPNum:=0; UOR:=0;

  GenStr:='';

  GenStr2:='';  ReconQty:=0.0;

  Blank(LineTot,Sizeof(LineTot));

  Blank(CostRates,Sizeof(CostRates));

  Ok2Print:=BOff;


  With MTExLocal^,RepFiler1 do
    With CRepParamP^ do
    Begin
      DefFont (0,[]);


      Case ReportMode of

          10
               :  With LId do
                  Begin

                    Ok2Print:=((LastCust<>CustCode) or (LastProd<>StockCode) and (LastPRod<>''));

                  end;
          11
               :  With LId do
                  Begin

                    Ok2Print:=((LastProd<>StockCode) or (LastCust<>CustCode) and (LastCust<>''));

                  end;

          15
               :  With LId do
                  Begin


                    {If (LastBSNom<>LStock.NomCodes[4]) then}
                    If (LastBSNom<>RepNomCode) then

                    Begin
                      If (LastBSNom<>FirstAddrD) then {* Print a sub total *}
                      Begin

                        If (ReportMode<>16) then
                          PrintStockTot(1); {* Stock Total *}

                        If (Not SingProd) then
                          PrintStockTot(2); {* B/S *}

                      end;

                      {LastBSNom:=LStock.NomCodes[4];}
                      LastBSNom:=RepNomCode;


                      LGetMainRec(NomF,FullNomKey(LastBSNom));

                      With LNom do
                        BSOBal:=Get_OCBal(NomType,FullNomKey(LastBSNom),RCr,YrF,PrF,1,BOff);

                      PrintOCBal2(RCr,RTxCr,BSOBal,0,1,BOff);

                      LastProd:=NdxWeight


                    end;

                    If (Trim(LastProd)<>Trim(StockCode)) then
                    Begin
                      Ok2Print:=BOn;

                      If (LastProd<>NdxWeight) then
                        PrintStockTot(1); {* Stock Total *}

                      // MH 16/05/2016 2016-R2 ABSEXCH-17459: Strip the crap off the Pay-In Ref so that it
                      // only contains printable characters which don't crash the .xlsx link to Excel
                      If (LId.IdDocHed <> NMT) Then
                        LastProd:=StockCode
                      Else
                      Begin
                        If (LId.PostedRun > 0) then
                          LastProd:=Extract_PayRef2(LId.StockCode)
                        Else
                          LastProd:=Extract_PayRef1(LId.StockCode);
                      End; // Else
                    end;

                  end;

          16   :  With LId do
                  Begin

                    Ok2Print:=((Trim(LastProd)<>Trim(StockCode)) and (LastProd<>NdxWeight));

                    If (Not Ok2Print) and (LastProd=NdxWeight) then
                      LastProd:=StockCode;

                  end;

        end; {Case..}

        With LId do
        Begin

          If (ReportMode In [15,16]) then
          Begin

            {* v5.61. Use deduct qty so bom build lines with SV & FG g/ls set to tbe the same only account for
                                     Actual costs deducted *}
            If (IdDocHed In StkInSet+StkOutSet) then
            Begin
              LineTot[1]:=(DeductQty)*StkAdjCnst[IdDocHed];
              ReconQty:=DeductQty;
            end
            else
            Begin
              LineTot[1]:=(Qty)*StkAdjCnst[IdDocHed]*QtyMul;
              ReconQty:=Calc_IdQty(Qty,QtyMul,UsePack);
            end;

            If (IdDocHed In [ADJ]) then
              Linetot[3]:=LineTot[1]*CostPrice
            else
            If (IdDocHed In SalesSplit) then
            begin
              {SSK 14/02/2017 2017-R1 ABSEXCH-15291: this change has been done to consider split pack qty for individual product as well as BOM Stock
              while calculating (Debit/Credit) value of the transaction}
              Linetot[3] := Round_Up(Calc_IdQty(Qty,QtyMul,UsePack)*StkAdjCnst[IdDocHed]*CostPrice,Syss.NoCosDec);
            end;

            If (IdDocHed In [ADJ]) and (KitLink=1) and (LStock.StockType=StkBIllCode) and (NomCode<>LStock.NomCodes[4]) then
              LineTot[3]:=LineTot[3]*DocNotCnst;

            If (NomCode=LStock.NomCodes[4]) and (IdDocHed In PurchSplit) then    //SSK 07/02/2017 2017-R1 ABSEXCH-15291: (IdDocHed In PurchSplit) condition added to show correct figure when pack quantities are used
                Linetot[3]:=LineTot[3]+DetLTotal(LId,Not Syss.SepDiscounts,BOff,0.0);

            If (IdDocHed In PurchSplit) and (LiveUpLift) and (CostPrice<>0.0) then
              Linetot[3]:=LineTot[3]+(InvLCost(LId)*DocCnst[IdDocHed]);

            If (RCr=0) then
            Begin
              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              {LineTot[2]:=Round_Up(Conv_TCurr(LineTot[2],XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);}

              If (IdDocHed In SalesSplit) then {* We need to convert using the original rate *}
              Begin
                CostRates:=LInv.OrigRates;

                If (COSConvRate<>0.0) then
                  CostRates[UseCoDayRate]:=COSConvRate;
              end
              else
                CostRates:=CXRate;

              Linetot[3]:=Round_Up(Conv_TCurr(LineTot[3],XRate(CostRates,BOff,Currency),Currency,UOR,BOff),2);
            end;


            ShowDrCr(LineTot[3],CrDr);

            LineTot[2]:=CrDr[BOff];
            LineTot[3]:=CrDr[BOn];

          end
          else
          Begin
            LineTot[1]:=Calc_IdQty(Qty,QtyMul,UsePack)*StkAdjCnst[IdDocHed]*DocNotCnst;

            If (IdDocHed In OrderSet) then
              LineTot[1]:=LineTot[1]*DocNotCnst;

            {LineTot[1]:=(Qty)*StkAdjCnst[IdDocHed]*DocNotCnst;}

            LineTot[2]:=Round_Up(LineTot[1]*CostPrice,Syss.NoCosDec);

            Linetot[3]:=DetLTotal(LId,BOn,BOff,0.0)*DocNotCnst;

            If (RCr=0) then
            Begin
              UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

              LineTot[3]:=Round_Up(Conv_TCurr(LineTot[3],XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

              If (IdDocHed In SalesSplit) then {* We need to convert using the original rate *}
              Begin
                CostRates:=LInv.OrigRates;

                If (COSConvRate<>0.0) then
                  CostRates[UseCoDayRate]:=COSConvRate;
              end
              else
                CostRates:=CXRate;

              Linetot[2]:=Round_Up(Conv_TCurr(LineTot[2],XRate(CostRates,BOff,Currency),Currency,UOR,BOff),2);
            end;

          end;



          LineTot[2]:=Currency_Txlate(LineTot[2],RCr,RTxCr);

          LineTot[3]:=Currency_Txlate(LineTot[3],RCr,RTxCr);


        end; {With..}


        If (Ok2Print) or (ReportMode=15) then
          SetReportDrillDown(0);

        Case ReportMode of


          10
              : Begin


                  If (Ok2Print) then
                  With LCust do
                  Begin


                    CustTot[4]:=CustTot[3]-CustTot[2];  {* Profit *}

                    Rnum:=Calc_Pcnt(CustTot[3],CustTot[4]);

                    QPNum:=CaseQty(LStock,CustTot[1]);

                    //TW 11/08/2011: Stock sales reports now differentiate between
                    //               group and single searches.
                    if CRepParamP.SingProd = true then
                    begin
                    SendLine(ConCat(#9,CustCode,
                                    #9,Company,
                                    #9,FormatFloat(GenQtyMask,QPNum),
                                    #9,Stock.UnitS,
                                    #9,FormatFloat(GenRealMask,CustTot[2]),
                                    #9,FormatFloat(GenRealMask,CustTot[3]),
                                    #9,FormatFloat(GenRealMask,CustTot[4]),
                                    #9,FormatFloat(GenPCntMask,RNum)));
                    end
                    else
                    begin
                    SendLine(ConCat(#9,CustCode,
                                    #9,Company,
                                    #9,FormatFloat(GenQtyMask,QPNum),
                                    #9,MTExLocal.LStock.UnitS,
                                    #9,FormatFloat(GenRealMask,CustTot[2]),
                                    #9,FormatFloat(GenRealMask,CustTot[3]),
                                    #9,FormatFloat(GenRealMask,CustTot[4]),
                                    #9,FormatFloat(GenPCntMask,RNum)));
                    end;

                    LastCust:=LId.CustCode;

                    LGetMainRec(CustF,LastCust);

                    Blank(CustTot,Sizeof(CustTot));
                  end;

                end;
          11
              : Begin


                  If (Ok2Print) then
                  With LStock do
                  Begin


                    CustTot[4]:=CustTot[3]-CustTot[2];  {* Profit *}

                    Rnum:=Calc_Pcnt(CustTot[3],CustTot[4]);

                    QPNum:=CaseQty(LStock,CustTot[1]);

                    SendLine(ConCat(#9,StockCode,
                                    #9,Desc[1],
                                    #9,FormatFloat(GenQtyMask,QPNum),
                                    #9,UnitS,
                                    #9,FormatFloat(GenRealMask,CustTot[2]),
                                    #9,FormatFloat(GenRealMask,CustTot[3]),
                                    #9,FormatFloat(GenRealMask,CustTot[4]),
                                    #9,FormatFloat(GenRealMask,RNum)));


                    LastProd:=LId.StockCode;

                    LGetMainRec(StockF,LastProd);

                    Blank(CustTot,Sizeof(CustTot));
                  end;

                end;

          15  : Begin

                  If (OK2Print) then
                  Begin
                    // MH 20/06/08: Filter out ÿ (#255) characters printed for NOM section
                    If (LStock.StockCode <> #255) Then
                      GenStr:=LStock.StockCode
                    Else
                      GenStr:='';
                    GenStr2:=LStock.Desc[1];
                  end;

                  Dnum:=LineTot[1];


                  {* vv note use of PPr_PR/Yr vv *}

                  SendLine(ConCat(#9,GenStr,
                                  #9,GenStr2,
                                  #9,LInv.OurRef,
                                  #9,LInv.YourRef,
                                  #9,PPR_OutPr(LId.PPr,LId.PYr),
                                  #9,POutDateB(LInv.TransDate),
                                  #9,LInv.CustCode,
                                  #9,FormatFloat(GenQtyMask,Dnum),
                                  #9,FormatFloat(GenRealMask,LineTot[2]),
                                  #9,FormatFloat(GenRealMask,LineTot[3])));


                end;

          16  : If (Ok2Print) then
                Begin
                  If (Not EmptyKey(LastProd,StkKeyLen)) then
                    LGetMainRec(StockF,LastProd)
                  else
                  Begin
                    LResetRec(StockF);
                    LStock.Desc[1]:='Nominal Journals';
                  end;

                  Dnum:=ProdTot[1];

                  SendLine(ConCat(#9,LStock.StockCode,
                                  #9,LStock.Desc[1],
                                  #9,FormatFloat(GenQtyMask,Dnum),
                                  #9,FormatFloat(GenRealMask,ProdTot[2]),
                                  #9,FormatFloat(GenRealMask,ProdTot[3])));

                  LastProd:=LId.StockCode;

                  If (LId.FolioRef<>0) and (Not EmptyKey(LastProd,StkKeyLen)) then
                    LGetMainRec(StockF,LastProd);

                  Blank(ProdTot,Sizeof(ProdTot));
                end;

       end; {Case..}


        Case ReportMode of

          10
               :  With LId do
                  Begin

                    If (StockCode<>LastProd) then
                    Begin
                      If (LastProd<>'') then
                        PrintStockTot(1);

                      LastProd:=StockCode;


                      PrintStkLine(LastProd,BOff);

                      //TW 11/08/2011: Used to populate LStock for group searches.
                      LGetMainRec(StockF,LastProd);
                    end;


                  end;
          11
               :  With LId do
                  Begin
                    If (CustCode<>LastCust) then
                    Begin
                      If (LastCust<>'') then
                        PrintStockTot(1);

                      LastCust:=CustCode;


                      PrintCustLine(LastCust,BOff);

                    end;


                  end;

          16   :  {If (LastBSNom<>LStock.NomCodes[4]) then}
                  If (LastBSNom<>RepNomCode) then
                  Begin

                    If (LastBSNom<>FirstAddrD) and (Not SingProd) then {* Print a sub total *}
                    Begin

                      PrintStockTot(2); {* B/S *}

                     end;

                    {LastBSNom:=LStock.NomCodes[4];}

                    LastBSNom:=RepNomCode;

                    LGetMainRec(NomF,FullNomKey(LastBSNom));

                    With LNom do
                      BSOBal:=Get_OCBal(NomType,FullNomKey(LastBSNom),RCr,YrF,PrF,1,BOff);

                    PrintOCBal2(RCr,RTxCr,BSOBal,0,1,BOff);

                  end;

        end; {Case..}

        CalcDueTotals(LineTot);


    end; {With(s)..}
end;





Procedure TPBrkReport.PrintEndPage;

Var
  n    :  SmallInt;

Begin
  With MTExLocal^,RepFiler1,CRepParamP^ do
  Begin
    Case ReportMode of
        10,11
            :  Begin

                 LResetRec(IdetailF);

                 Case ReportMode of
                   10  :  Begin
                            LastCust:=NdxWeight;

                            LId.StockCode:=LastProd;
                          end;

                   11  :  Begin
                            LastProd:=NdxWeight;

                            LId.CustCode:=LastCust;
                          end;
                 end; {Case..}

                 PrintReportLine;

                 PrintStockTot(1);

                 If RepPrintExcelTotals then
                   PrintStockTot(2);

               end;

        15,16
            :  Begin

                 If (ReportMode=16) then
                 Begin
                   LResetRec(IDetailF);

                   PrintReportLine;

                 end;

                 For n:=1 to 4 do
                   If ((n<>1) or (ReportMode<>16)) and (RepPrintExcelTotals) then
                     PrintStockTot(n);

               end;

      end; {Case..}


    Inherited PrintEndPage;
  end; {With..}
end;



Function TPBrkReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParamP^ do
  Begin
    Case ReportMode of

      10,11  :  Begin
                  If (Debug) then
                  Begin
                    {SDate:='19950802'; EDate:='19961212';}

                  end;

                  Case ReportMode of

                    10  :  Begin
                             ThTitle:='Stk Prod Report';
                             RepTitle:='Stock Sales by Product Report';
                           end;

                    11  :  Begin
                             RepTitle:='Stock Sales by Customer Report';
                             ThTitle:='Stk Cust Report';

                             // MH 13/03/2012 v6.10 ABSEXCH-11902: Changed to Landscape and increased Code/Desc column widths
                             ROrient:=RPDefine.PoLandscape;
                           end;

                  end; {Case..}


                  If (OrderMode) then
                    RepTitle:=RepTitle+'. (Orders)';

                  PageTitle:=RepTitle+'. '+POutDate(SDate)+' - '+POutDate(EDate);


                  {$IFDEF MC_On}

                    If (RTxCr<>0) and (RTxCr<>RCr) then
                      PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
                    else
                      PageTitle:=CurrDesc(RCr)+PageTitle;

                  {$ENDIF}


                  If (CustFilt<>'') then
                  Begin
                    GetCust(Application.MainForm,CustFilt,FoundCode,BOn,-1);

                    RepTitle2:='For '+Strip('B',[#32],Cust.Company);
                  end;

                  If (StkToo<>'') then
                  Begin
                    GetStock(Application.MainForm,FullStockCode(StkToo),FoundCode,-1);

                    SingProd:=(Stock.StockType<>StkGrpCode);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    If (SingProd) then
                      RepTitle2:=RepTitle2+'Stock item : '+Strip('B',[#32],Stock.Desc[1])
                    else
                      RepTitle2:=RepTitle2+'Stock filter : '+Strip('B',[#32],Stock.Desc[1]);

                  end;

                  {$IFDEF PF_On}

                    For BoLoop:=BOff to BOn do

                      If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
                      Begin
                        FoundCode:=RCCDep[BoLoop];

                        GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                        If (RepTitle2<>'') then
                          RepTitle2:=RepTitle2+', ';

                        RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

                      end; {Loop..}

                  {$ENDIF}


                  {$IFDEF SOP}
                    If (Not EmptyKey(LocFilt,LocKeyLen)) then
                    Begin
                      If (RepTitle2<>'') then
                        RepTitle2:=RepTitle2+', ';

                      RepTitle2:=RepTitle2+MLocRepTitle(LocFilt)+'. ';
                    end;
                  {$ENDIF}

                  RFont.Size:=7;
                end;


      15,16
         :  Begin

              If (Debug) then
              Begin
                {YrF:=Syss.CYr; PrF:=1;

                YrT:=Syss.CYr; PrT:=Syss.PrInYr;}
              end;

              LastBSNom:=FirstAddrD;

              LastProd:=NdxWeight;

              ThTitle:='Stk Recon Report';

              If (Not FGMode) then
                RepTitle:='Stock Reconciliation Report'
              else
                RepTitle:='Finished Goods Reconciliation Report';


              PageTitle:=RepTitle+' ('+PPR_OutPr(PrF,YrF)+' - '+PPR_OutPr(PrT,YrT)+')';

              {$IFDEF MC_On}

                If (RTxCr<>0) and (RTxCr<>RCr) then
                  PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
                else
                  PageTitle:=CurrDesc(RCr)+PageTitle;

              {$ENDIF}


              SingProd:=((CustFilt<>'') or (StkToo<>''));

              If (CustFilt<>'') then
              Begin
                GetCust(Application.MainForm,FullCustCode(CustFilt),FoundCode,BOn,-1);

                RepTitle2:='For '+Strip('B',[#32],Cust.Company);
              end;

              If (StkToo<>'') then
              Begin
                GetStock(Application.MainForm,FullStockCode(StkToo),FoundCode,-1);

                If (RepTitle2<>'') then
                  RepTitle2:=RepTitle2+', ';

                RepTitle2:=RepTitle2+'Stock Item/Group '+Strip('B',[#32],Stock.Desc[1]);

              end;

              {$IFDEF PF_On}
                For BoLoop:=BOff to BOn do
                  If (Not EmptyKeyS(RCCDep[BoLoop],CCKeyLen,BOff)) then
                  Begin
                    FoundCode:=RCCDep[BoLoop];

                    GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                    If (RepTitle2<>'') then
                      RepTitle2:=RepTitle2+', ';

                    RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

                  end; {Loop..}


              {$ENDIF}

              {$IFDEF SOP}
                If (Not EmptyKey(LocFilt,LocKeyLen)) then
                Begin
                  If (RepTitle2<>'') then
                    RepTitle2:=RepTitle2+', ';

                  RepTitle2:=RepTitle2+MLocRepTitle(LocFilt)+'. ';
                end;
              {$ENDIF}


              RFont.Size:=7;
              ROrient:=RPDefine.PoLandscape;
            end;

    end; {Case..}


    RFnum:=ReportF;

    RKeyPath:=RpK;

  end; {With..}

  Result:=BOn;
end;




Procedure TPBrkReport.Process;

Var
  SRFnum,
  SRKeypath    :  Integer;

  ScanStr      :  Str255;

  AbortPrint   :  Boolean;


Begin
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}
  With MTExLocal^,CRepParamP^ do
  Begin
    AbortPrint:=BOff;

    New(ThisScrt,Init(6,MTExLocal,BOff));

    RepKey:=FullNomKey(ThisScrt^.Process);

    If (OrderMode) then
      ScanStr:=StkLineType[DocTypes(Ord(SOR)+3)]
    else
      ScanStr:=StkLineType[SIN];

    If (SingProd) then
      ScanStr:=ScanStr+StkToo;

    InitStatusMemo(4);

    ShowStatus(0,RepTitle);

    If (FGMode) then
    Begin
      SRFnum:=RFnum; SRKeypath:=RKeypath;
    end
    else
    Begin
      SRFnum:=StockF; SRKeypath:=StkValK;
    end;


    Case ReportMode of

        10,11  :  Build_ProdBreak(ReportMode,
                                  ScanStr,
                                  CustFilt,
                                  LocFilt,
                                  RCr,
                                  SDate,
                                  EDate,
                                  StkToo,
                                  SingProd,
                                  RCCDep,
                                  AbortPrint);

        15,16  :  Build_StkRecon(SRFnum,SRKeypath,
                                 RCr,
                                 YrF,PrF,YrT,PrT,
                                 CustFilt,
                                 LocFilt,
                                 StkToo,
                                 AbortPrint);

      end; {Case..}

    LResetRec(CustF);
    LResetRec(StockF);

  end;


  Inherited Process;

end;


Procedure TPBrkReport.Finish;


Begin
  If (Assigned(ThisScrt)) then
    Dispose(ThisScrt,Done);

  If (Assigned(FGScrt)) then
    Dispose(FGScrt,Done);


  Inherited Finish;
end;


{ ======== }



Procedure AddProdRep2Thread(LMode    :  Byte;
                            IRepParam:  PBrkRepPtr;
                            AOwner   :  TObject);


Var
  EntTest  :  ^TPBrkReport;

  //PR: 21/10/2009 Function to add this report's parameters to the report's PrintParameters object.
  procedure AddParameters;
  begin
    if Assigned(EntTest.oPrintParams) then
    begin
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Period/Year Range';
//        Value := Format('%.2d/%d to %.2d/%d', [IRepParam.PrF, IRepParam.YrF + 1900, IRepParam.PrT, IRepParam.YrT + 1900]);
          Value := Format('%s to %s', [PPR_OutPr(IRepParam.PrF, IRepParam.YrF), PPR_OutPr(IRepParam.PrT, IRepParam.YrT)]);
      end;

      {$IFDEF MC_ON}
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RCr), True);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RTxCr), True);
      end;
      {$ENDIF}

      if Syss.UseCCDep and (LMode <> 1) then
      begin
        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Cost Centre';
          Value := IRepParam.RCCDep[True];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Department';
          Value := IRepParam.RCCDep[False];
        end;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Account No';
        Value := IRepParam.CustFilt;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Product Code/Group';
        Value := IRepParam.StkToo;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Summary Report';
        Value := LMode = 16; //EL adds Ord(Sum1.Checked) to report mode of 15 to indicate summary report - aaargggh!
      end;

      EntTest.bPrintParams := True;
    end;
  end;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
          CRepParamP^:=IRepParam^;


        If (Create_BackThread) and (Start) then
        Begin
          if IRepParam.PrintParameters then
            AddParameters;

          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





Initialization



Finalization

end.
