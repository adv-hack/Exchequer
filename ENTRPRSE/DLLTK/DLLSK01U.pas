UNIT DLLSK01U;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/07/93                      }
{                                                              }
{                     Internal Export Modeule                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}

Interface

Uses
  GlobVar,
  {$IFDEF WIN32}
  VarRec2U,
  {$ELSE}
    VRec2U,
  {$ENDIF}
  VarConst,
  VarCnst3;

Const
  {* Moved from GlobVar b/c of 16 bits compilation problem*}
//  StkValueSet    =  ['F','L','A','C','S','R'];  {* Permitted valuation methods *}
  CoverPrSet     =  ['D','W','M'];

  UserMatchSet   =  ['0'..'4'];

{$IFNDEF WIN32}
Type
  SmallInt = Integer;    { 2 Byte Integer: -32768..32767 }
{$ENDIF}


{* --------------- Stock Record Information ------------------------- *}

FUNCTION EX_GETSTOCK(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;
                     {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;


FUNCTION EX_STORESTOCK(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_UNLOCKSTOCK  :  SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------------- Stock Location Information ------------------------- *}

FUNCTION EX_GETSTOCKLOC(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHKEY    :  PCHAR;
                        SEARCHLOC    :  PCHAR;
                        LOCK         :  WORDBOOL )  :  SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STORESTOCKLOC(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------------- Location Master Record Information ------------------------- *}

FUNCTION EX_GETLOCATION(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHKEY    :  PCHAR;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL)  :  SMALLINT;
                        {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STORELOCATION(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                          {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

{* --------------- Matching Record Information ------------------------- *}

FUNCTION EX_GETMATCH(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;
                     {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STOREMATCH(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_STOREJAPMATCH(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;


FUNCTION EX_DELETEMATCH(P            :  POINTER;
                        PSIZE        :  LONGINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;


{* --------------- Notes Record Information ------------------------- *}

FUNCTION EX_STORENOTES(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;
                       {$IFDEF WIN32} STDCALL; {$ENDIF} EXPORT;

FUNCTION EX_GETNOTES(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;
                     {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------------- Calculate Stock Price  ------------------------- *}

FUNCTION EX_CALCSTOCKPRICE(P      :  POINTER;
                           PSIZE  :  LONGINT)   :  SMALLINT;
                           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

{* --------------- Stock Alternative Record Information ------------------------- *}

FUNCTION EX_GETSTKALT(P           :  POINTER;
                      PSIZE       :  LONGINT;
                      SEARCHKEY   :  PCHAR;
                      SEARCHPATH  :  SMALLINT;
                      SEARCHMODE  :  SMALLINT;
                      LOCK        :  WORDBOOL)  :  SMALLINT;
                      {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_STORESTKALT(P          :  POINTER;
                        PSIZE      :  LONGINT;
                        SEARCHPATH :  SMALLINT;
                        SEARCHMODE :  SMALLINT)  :  SMALLINT;
                        {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_GETSTOCKBYFOLIO(P           :  POINTER;
                            PSIZE       :  LONGINT;
                            FOLIONUM    :  LONGINT;
                            SEARCHMODE  :  SMALLINT;
                            LOCK        :  WORDBOOL)  :  SMALLINT;
                            {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_DELETESTOCK(FOLIO  :  LONGINT) : SMALLINT; {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

FUNCTION EX_UPDATEINVALIDMATCHES(CALLBACK : POINTER) : SMALLINT;
                            {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;

function EX_DELETEFIFO : SMALLINT; StdCall Export;

{$IFDEF COMTK}
  function Ex_GetStockGeneric(    P          : pointer;
                                  PSize      : longint;
                              var SearchKey  : str255;
                                  SearchPath : smallint;
                                  SearchMode : smallint;
                                  Lock       : wordbool) : smallint;

  Procedure CopyExStockToTkStock(Const StockR : StockRec; Var ExStockRec  :  TBatchSKRec);

  Procedure CopyExLocToTKLoc (Const MLocR : MLocLocType; Var ExLocRec : TBatchMLocRec);

  Procedure CopyExStockLocToTKStockLoc(Const StkLoc : MStkLocType; Var ExSLRec : TBatchSLRec);

  Procedure CopyExNotesToTKNotes(Const ExchNotes : NotesType; Var ExNotesRec  :  TBatchNotesRec);

  procedure CopyAltToExAlt(const EntAltRec : sdbStkType; VAR ExSKAltRec  : TBatchSKAltRec);

  Function Full_SupStkKey(SFol  :  LongInt;
                        SCode :  Str20 )  :  Str30;

{$ENDIF}

  procedure GetApplicableMultiBuyDiscount(Var ExStkPrRec  :  TBatchStkPriceRec);


var
  UseMultiBuys : Boolean;

  //PR: 19/11/2012 Add variable to cover whether ABSEXCH-9480 fix works or not (ABSEXCH-13753)
  Use9480ReOrder : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}
Implementation
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses

  SysUtils,

{$IFDEF WIN32}
  BtrvU2, BTSupU1, SysU1, SysU2, ComnU2, ComnUnit, CurrncyU, DiscU3U, BTKeys1U,
{$ELSE}
  BtrvU16, BTSup1, BTSup2, DiscU3,
{$ENDIF}
  BTS1, ETStrU, ETDateU, ETMiscU, DLlErrU, Dialogs, MLocFunc, Validate,  DllMiscU, DLSQLSup, MultiBuyVar,

  //PR: 02/11/2011 v6.9
  AuditNotes,
  AuditNoteIntf;


{* -------------------------------------------------------------------------- *}


{* This has been copied from BTKeys1U for not to include SOP and for Alt.StockCode  *}

Function Full_SupStkKey(SFol  :  LongInt;
                        SCode :  Str20 )  :  Str30;
Begin

  Full_SupStkKey:=FullNomKey(SFOL)+FullStockCode(SCode);

end;

Function FullRunNoKey(Rno,Fno  :  Longint)  :  Str20;


Begin
  FullRunNoKey:=FullNomKey(Rno)+FullNomKey(Fno);
end;

Function Calc_AltStkHCode(NType  :  Char)  :  Char;

Begin
  Calc_AltStkHCode:=Char(Ord(Ntype)+StkHTypWeight);
end;



{--------- Copied from WOPCT1U.Pas ----------------------}

Procedure Time2Mins(Var MTime                :  LongInt;
                    Var Days,Hrs,Mins        :  Extended;
                        SetMode              :  Byte);
Var
  TimeLeft  :  Extended;
Begin
  Case  SetMode of
    0  :  Begin
            Days:=Trunc(MTime/1440);
            TimeLeft:=Round(MTime-(Days*1440));

            Hrs:=Trunc(TimeLeft/60);

            Mins:=Round(TimeLeft-(Hrs*60));
          end;

    1  :  Begin
            MTime:=Round((Days*1440)+(Hrs*60)+Mins);

          end;
  end;{Case..}
end;

procedure GetApplicableMultiBuyDiscount(Var ExStkPrRec  :  TBatchStkPriceRec);
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  ThisQty : Double;

  PercentDiscount : Double;
  DiscountSoFar : Double;

  iCount : Integer;

  TempStkPrRec  :  TBatchStkPriceRec;

  function QtyToBuy : Double;
  begin
    with MultiBuyDiscount do
    begin
      if mbdDiscountType = mbtGetFree then
        Result := mbdBuyQty + mbdRewardValue
      else
        Result := mbdBuyQty;
    end;
  end;

  function CurrentNetValue : Double;
  begin
    with ExStkPrRec do
      Result := Price - Calc_PAmount(Price, DiscVal, DiscChar);
  end;

  function CurrentDiscountValue : Double;
  begin
    with MultiBuyDiscount do
    begin
      Case mbdDiscountType of
         mbtGetFree    : Result := (CurrentNetValue * mbdRewardValue);
         mbtForAmount  : Result :=  mbdRewardValue;
         mbtGetPercentOff
                       : Result :=  CurrentNetValue - (CurrentNetValue * mbdRewardValue);
         else
           Result := 0;
      end; //Case
    end;
  end;

  function ValidDiscount : Boolean;
  begin
    with MultiBuyDiscount do
    begin
      Result := not mbdUseDates or ((ExStkPrRec.PriceDate >= mbdStartDate) and (ExStkPrRec.PriceDate <= mbdEndDate));

      if Result then
        Result := (mbdDiscountType <> mbtForAmount) or (mbdCurrency = 0) or (mbdCurrency = ExStkPrRec.Currency);
    end;
  end;

begin
  DiscountSoFar := 0;
  PercentDiscount := 0;
  iCount := 0;
  ThisQty := ExStkPrRec.Qty;
  KeyS := mbdStockCodeKey(ExStkPrRec.CustCode, ExStkPrRec.StockCode);
  KeyChk := mbdPartStockCodeKey(ExStkPrRec.CustCode, ExStkPrRec.StockCode);
  
  Res := Find_Rec(B_GetLessEq, F[MultiBuyF], MultiBuyF, RecPtr[MultiBuyF]^, 0, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) and (ThisQty > 0) do
  begin
    if ValidDiscount then
    begin
      if ThisQty >= QtyToBuy then
      begin
        inc(iCount);
        if (iCount = 1) and (MultiBuyDiscount.mbdDiscountType = mbtGetPercentOff) then //store percentage in case we have only one
          PercentDiscount := MultiBuyDiscount.mbdRewardValue;                          //discount
      end;

      while (ThisQty >= QtyToBuy) do
      begin
        DiscountSoFar := DiscountSoFar + CurrentDiscountValue;

        ThisQty := ThisQty - QtyToBuy;
      end;
    end;

    if ThisQty > 0 then
      Res := Find_Rec(B_GetPrev, F[MultiBuyF], MultiBuyF, RecPtr[MultiBuyF]^, 0, KeyS);
  end;

  if ThisQty < ExStkPrRec.Qty then //found at least 1 valid discount
  begin
    if (MultiBuyDiscount.mbdDiscountType = mbtGetPercentOff) and (iCount = 1) then
    begin
      ExStkPrRec.MultiBuyDiscValue := PercentDiscount;
      ExStkPrRec.MultiBuyDiscChar := '%';
    end
    else
    begin
      ExStkPrRec.MultiBuyDiscValue := DiscountSoFar / ExStkPrRec.Qty;
      ExStkPrRec.MultiBuyDiscChar := #0;
    end;
  end
  else
  begin
  //If no mbds found then look for stock only record (customer only - not supplier)
    if (Cust.CustSupp = 'C') and (Trim(ExStkPrRec.CustCode) <> '') then
    begin
      TempStkPrRec := ExStkPrRec;
      TempStkPrRec.CustCode := FullCustCode('');

      GetApplicableMultiBuyDiscount(TempStkPrRec);

      ExStkPrRec.MultiBuyDiscValue := TempStkPrRec.MultiBuyDiscValue;
      ExStkPrRec.MultiBuyDiscChar := TempStkPrRec.MultiBuyDiscChar;
    end;
  end;
end;



{* -------------------------------------------------------------------------- *}

Procedure CopyExStockToTkStock(Const StockR : StockRec; Var ExStockRec  :  TBatchSKRec);
Var
  n  :  Byte;
  Days, Hours, Mins : Extended;
  TempProdTime : longint;

  d1, d2, d3, QtyPost : Double;
Begin
  With ExStockRec do
  Begin

    d1 :=Profit_to_Date(Calc_AltStkHCode(StockR.StockType),
                        CalcKeyHist(StockR.StockFolio,''),0,Syss.CYr,Syss.CPr,d2,d3,QtyPost,BOn);

    StockCode:=StockR.StockCode;

    For n:=1 to NofSDesc do
      Desc[n]:=StockR.Desc[n];

    AltCode:=StockR.AltCode;
    SuppTemp:=StockR.SuppTemp;

    For n:=1 to NofSNoms do
      NomCodeS[n]:=StockR.NomCodeS[n];

    MinFlg:=BoolToWordBool(StockR.MinFlg);
    StockFolio:=StockR.StockFolio;
    StockCat:=StockR.StockCat;
    StockType:=StockR.StockType;
    UnitK:=StockR.UnitK;
    UnitS:=StockR.UnitS;
    UnitP:=StockR.UnitP;
    PCurrency:=StockR.PCurrency;
    CostPrice:=StockR.CostPrice;

    UsesBins := BoolToWordBool(StockR.MultiBinMode);

    For n:=1 to NofSBands-2 do
    Begin
      SaleBands[n].Currency:=StockR.SaleBands[n].Currency;
      SaleBands[n].SalesPrice:=StockR.SaleBands[n].SalesPrice;
    end;

    SellUnit:=StockR.SellUnit;
    BuyUnit:=StockR.BuyUnit;
    VATCode:=StockR.VATCode;
    CC:=StockR.CCDep[BOn];
    Dep:=StockR.CCDep[BOff];
    QtyInStock:=StockR.QtyInStock;
    QtyPosted:=QtyPost;
    QtyAllocated:=StockR.QtyAllocated;
    QtyOnOrder:=StockR.QtyOnOrder;
    QtyMin:=StockR.QtyMin;
    QtyMax:=StockR.QtyMax;
    ROQty:=StockR.ROQty;
    CommodCode:=StockR.CommodCode;
    SWeight:=StockR.SWeight;
    PWeight:=StockR.PWeight;
    UnitSupp:=StockR.UnitSupp;
    SuppSUnit:=StockR.SuppSUnit;
    BinLoc:=StockR.BinLoc;
    {$IFNDEF COMTK}
    BinLoc10 := StockR.BinLoc;
    {$ENDIF}
    CovPr:=StockR.CovPr;
    CovPrUnit:=StockR.CovPrUnit;
    CovMinPr:=StockR.CovMinPr;
    CovMinUnit:=StockR.CovMinUnit;
    Supplier:=StockR.Supplier;
    CovSold:=StockR.CovSold;
    UseCover:=BoolToWordBool(StockR.UseCover);
    CovMaxPr:=StockR.CovMaxPr;
    CovMaxUnit:=StockR.CovMaxUnit;
    ROCurrency:=StockR.ROCurrency;
    ROCPrice:=StockR.ROCPrice;
    RODate:=StockR.RODate;
    StkValType:=StockR.StkValType;
    QtyPicked:=StockR.QtyPicked;
    LastUsed:=StockR.LastUsed;

    {* Added on 14.07.97 *}
    StBarCode:=StockR.BarCode;
    StROCostCentre:=StockR.ROCCDep[BOn];
    StRODepartment:=StockR.ROCCDep[BOff];
    StLocation:=StockR.DefMLoc;
    StPricePack:=BoolToWordBool(StockR.PricePack);
    StDPackQty:=BoolToWordBool(StockR.DPackQty);
    StKitPrice:=BoolToWordBool(StockR.KitPrice);
    StKitOnPurch:=BoolToWordBool(StockR.KitOnPurch);

    StStkUser1:=StockR.StkUser1;
    StStkUser2:=StockR.StkUser2;

    JAnalCode:=StockR.JAnalCode; {* *}

    {*** ver 4.31 ***}
    WebInclude:=StockR.WebInclude;
    WebLiveCat:=StockR.WebLiveCat;
    WebPrevCat:=StockR.WebPrevCat;
    StkUser3:=StockR.StkUser3;
    StkUser4:=StockR.StkUser4;
    SerNoWAvg:=StockR.SerNoWAvg;
    SSDDUplift:=StockR.SSDDUplift;
    // MH 18/01/2016 2016-R1 ABSEXCH-17099: SSD Country field no longer used for UK
    If (CurrentCountry <> UKCCode) Then
      SSDCountry := StockR.SSDCountry
    Else
      SSDCountry := '';
    TimeChange:=StockR.TimeChange;
    SVATIncFlg:=StockR.SVATIncFlg;
    LastOpo:=StockR.LastOpo;
    ImageFile:=StockR.ImageFile;
    StkLinkLT:=StockR.StkLinkLT;
    PriceByStkUnit:=BoolToWordBool(StockR.CalcPack);  { Price by Stock Unit }
    ShowAsKit := BoolToWordBool(StockR.ShowasKit);  { ShowAsKit - Explode BOM on Sales }

    QtyPickWOR := StockR.QtyPickWOR;
    {*** ----------------------- ***}

    //Extra fields added for 5.6 9/12/03
    {$IFDEF COMTK}
    SSDAUplift := StockR.SSDAUpLift;
    BOMProdTime := StockR.BOMProdTime;

    TempProdTime := StockR.ProdTime;
    Time2Mins(TempProdTime, Days, Hours, Mins, 0);
    WOPProdTimeDays := Round(Days);
    WOPProdTimeHours := Round(Hours);
    WOPProdTimeMins := Round(Mins);

    WOPLeadTime  := StockR.Leadtime;
    WOPCalcProdTime := StockR.CalcProdTime;
    WOPMinEcQty  := StockR.MinEccQty;
    WOPIssuedWIPGL  := StockR.WOPWIPGL;
    QtyAllocWOR  := StockR.QtyAllocWOR;
    QtyIssueWOR  := StockR.QtyIssueWOR;
    QtyStockTake := StockR.QtyTake;
    QtyStockTakeChanged := StockR.StkFlg;
    QtyFreeze    := StockR.QtyFreeze;

    {$IFDEF EN570}
    SalesWarranty := StockR.SWarranty;
    SalesWarrantyType := StockR.SWarrantyType;
    PurchWarranty := StockR.MWarranty;
    PurchWarrantyType := StockR.MWarrantyType;
    SalesRetGL := StockR.ReturnGL;
    PurchRetGL := StockR.PReturnGL;
    RestockCharge := StockR.ReStockPcnt;
    if StockR.ReStockPChr = '%' then
      RestockCharge := RestockCharge * 100;
    SalesRetQty := StockR.QtyReturn;
    PurchRetQty := StockR.QtyPReturn;
    RestockFlag := StockR.ReStockPChr;

    {$ENDIF 570}

    {$ENDIF COMTK}

    //PR: 21/10/2011 v6.9
    StkUser5 := StockR.StkUser5;
    StkUser6 := StockR.StkUser6;
    StkUser7 := StockR.StkUser7;
    StkUser8 := StockR.StkUser8;
    StkUser9 := StockR.StkUser9;
    StkUser10 := StockR.StkUser10;

  end;
end; {proc ..}

Procedure StockToExStock(Var ExStockRec  :  TBatchSKRec);
Begin
  CopyExStockToTkStock(Stock, ExStockRec);
End;

{* -------------------------------------------------------------------------- *}

{* ========= Get Stock ========== *}

function Ex_GetStockGeneric(P          : pointer;
                            PSize      : longint;
                            var SearchKey  : str255;
                            SearchPath : smallint;
                            SearchMode : smallint;
                            Lock       : wordbool) : smallint;
Var
  ExStockRec :  ^TBatchSKRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
begin
  If TestMode Then
  Begin
    ExStockRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetStock:' + #10#13 +
                 'P^.StockCode: ' + ExStockRec^.StockCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + SearchKey + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PSize=Sizeof(TBatchSKRec)) then
  Begin
    KeyS := SearchKey;
    {04.10.2000 - Added this line otherwise, not return the record if B_GetEq is used }
    if SearchPath = 0 then
      KeyS:=LJVar(UpperCase(KeyS),StkLen);

    ExStockRec:=P;

    Blank(ExStockRec^,Sizeof(ExStockRec^));

    KeyS:= SetKeyString(SearchMode, StockF, KeyS);

    Result:=Find_Rec(SearchMode,F[StockF],StockF,RecPtr[StockF]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,StockF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,StockF,SilentLock,Locked));
    {$ENDIF}

    SearchKey := KeyS;
    KeyStrings[StockF] := KeyS;

    If (Result=0) then
      StockToExStock(ExStockRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;
end;

FUNCTION EX_GETSTOCK(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;
var
  SearchStr : str255;
begin
  LastErDesc:='';
  SearchStr := SearchKey;
  Result := Ex_GetStockGeneric(P, PSize, SearchStr, SearchPath, SearchMode, Lock);
  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(30,Result);

  StrPCopy(SearchKey, SearchStr);
end;

FUNCTION EX_GETSTOCKBYFOLIO(P           :  POINTER;
                            PSIZE       :  LONGINT;
                            FOLIONUM    :  LONGINT;
                            SEARCHMODE  :  SMALLINT;
                            LOCK        :  WORDBOOL)  :  SMALLINT;
var
  SearchStr : str255;
begin
  LastErDesc:='';
  SearchStr := FullNomKey(FolioNum);
  Result := Ex_GetStockGeneric(P, PSize, SearchStr, 1, SearchMode, Lock);

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(146,Result);

end;


(* Original function !!!
FUNCTION EX_GETSTOCK(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;
Var
  ExStockRec :  ^TBatchSKRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
Begin
  If TestMode Then
  Begin
    ExStockRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetStock:' + #10#13 +
                 'P^.StockCode: ' + ExStockRec^.StockCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PSize=Sizeof(TBatchSKRec)) then
  Begin
    KeyS:=StrPas(SearchKey);
    {04.10.2000 - Added this line otherwise, not return the record if B_GetEq is used }
    KeyS:=LJVar(UpperCase(KeyS),StkLen);

    ExStockRec:=P;

    Blank(ExStockRec^,Sizeof(ExStockRec^));

    Result:=Find_Rec(SearchMode,F[StockF],StockF,RecPtr[StockF]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,StockF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,StockF,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
      StockToExStock(ExStockRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

end; {Func..} *)

{* -------------------------------------------------------------------------- *}

Function ExStockToStock(ExStockRec :  TBatchSKRec;
                        AddMode    :  SmallInt;
                        Keypath    :  SmallInt)  :  Integer;
Const
  CCDepMsg     : Array[BOff..BOn] of Integer = (30288,30287);
  CCDepActMsg  : Array[BOff..BOn] of Integer = (30304,30303);
  RoCCDepMsg   : Array[BOff..BOn] of Integer = (30290,30289);

  {SS 15/06/2016 2016-R3 
   ABSEXCH-13693:Importer doesn't validate Global Time Rate record import where the same Stock Code already exists and vice versa.
  - Function to check Time Rate record exists with the same as Stock record.}
  function TimeRateExists: Boolean;
  var
    Key: Str255;
    TmpStat: Integer;
    TmpKPath:  Integer;
    TmpRecAddr:  LongInt;
    Currency: Byte;
    FirstCurrency: Byte;
    LastCurrency: Byte;
  Begin
    // Store the current record position
    TmpKPath := GetPosKey;
    TmpStat  := Presrv_BTPos(JCtrlF, TmpKPath, F[JCtrlF], TmpRecAddr, False, True);

    {$IFDEF MC_On}
    FirstCurrency := 1;
    LastCurrency  := CurrencyType;
    {$ELSE}
    FirstCurrency := 0;
    LastCurrency  := 0;
    {$ENDIF}

    // Work through all the currencies
    Result := False;
    for Currency := FirstCurrency to LastCurrency do
    begin
      if IsCurrencyUsed(Currency) then
      begin
        Key    := 'J'+'E'+FullJBCode('ÿÿÿÿ', Currency, Stock.StockCode);
        Status := Find_Rec(B_GetEq, F[JCtrlF], JCtrlF, RecPtr[JCtrlF]^, JCK, Key);
        Result := (Status=0);
        if Result then
          break;
      end;
    end;

    // Restore the record position
    TmpStat := Presrv_BTPos(JCtrlF, TmpKPath, F[JCtrlF], TmpRecAddr, True, True);
  end;


Var
  n              :  Byte;
  OrgStock,
  OStock         :  StockRec;

  FindRec,
  ValidCheck,
  ValidHed       : Boolean;

  KeyS           : Str255;

  UpdateBOMCost,                { 06.11.2000 }
  RepBO,
  TBo            : Boolean;

  TmpMode        : SmallInt;
  TStr           : Str10;
  Days, Hours, Mins : Extended;

  //PR: 04/02/2016 v2016 R1 ABSEXCH-17243
  ErrSSDCode    :  LongInt;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Changed to Int64 to avoid overflows with 10 digit TARIC codes > MaxLongInt
  TmpSSD        : Int64;
Begin
  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;
  TmpMode:=AddMode;

  With Stock do
  Begin
    KeyS:=LJVar(UpperCase(ExStockRec.StockCode),StkLen);

    Status:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,KeyS);

    FindRec:=StatusOk;

    {import - assign appro. mode }
    If (AddMode=CheckMode) or (AddMode=ImportMode) then
    begin
      If (FindRec) then
        AddMode:=B_Update
      else
        AddMode:=B_Insert;
    end;

    If (AddMode=B_Insert) then
    Begin
      ResetRec(StockF);
      NLineCount:=1;
      BLineCount:=1;
      ROCurrency:=1;
      GenSetError(Not FindRec,5,Result,ValidHed);

      // HM 07/09/01 (4.40)
      MinEccQty:=1.0;
      CalcProdTime:=True;
    end
    else
    Begin
      GenSetError(FindRec,4,Result,ValidHed);

      OStock:=Stock;
      OrgStock:=Stock;

    end;

    {** Start conversion **}

    StockCode:=Ljvar(UpperCase(ExStockRec.StockCode),StkLen);

    For n:=1 to NofSDesc do
      Desc[n]:=ExStockRec.Desc[n];

    {$IFDEF IMPV6}
    //PR: 04/11/2010 Description line 1 needs to be padded - ABSEXCH-2714
    Desc[1] := LJVar(Desc[1],StkDesKLen);
    {$ENDIF}

    AltCode:=LJVar(UpperCase(ExStockRec.AltCode), StkKeyLen);
    SuppTemp:=FullCustCode(ExStockRec.SuppTemp);

    For n:=1 to NofsNoms do
      NomCodeS[n]:=ExStockRec.NomCodeS[n];

    MinFlg:=WordBoolToBool(ExStockRec.MinFlg);
    StockFolio:=ExStockRec.StockFolio;
    StockCat:=LjVar(UpperCase(ExStockRec.StockCat),StkLen);
    StockType:=ExStockRec.StockType;
    UnitK:=ExStockRec.UnitK;
    UnitS:=ExStockRec.UnitS;
    UnitP:=ExStockRec.UnitP;
    PCurrency:=ExStockRec.PCurrency;
    CostPrice:=ExStockRec.CostPrice;

    For n:=1 to NofSBands-2 do
    Begin
      SaleBands[n].Currency:=ExStockRec.SaleBands[n].Currency;
      SaleBands[n].SalesPrice:=ExStockRec.SaleBands[n].SalesPrice;
    end;

    SellUnit:=ExStockRec.SellUnit;
    BuyUnit:=ExStockRec.BuyUnit;
    VATCode:=ExStockRec.VATCode;
    CCDep[BOn]:=FullCCDepKey(UpperCase(ExStockRec.CC));
    CCDep[BOff]:=FullCCDepKey(UpperCase(ExStockRec.Dep));
    QtyMin:=ExStockRec.QtyMin;
    QtyMax:=ExStockRec.QtyMax;
    ROQty:=ExStockRec.ROQty;
    // MH 09/02/2011 v6.6 ABSEXCH-9480: Modified to set ROFlg depending on the Re-Order Qty
    //PR: 19/11/2012 ABSEXCH-13753 Allow use of pre-fix functionality
    if Use9480ReOrder then
      ROFlg := (ROQty > 0);
    CommodCode:=ExStockRec.CommodCode;
    SWeight:=ExStockRec.SWeight;
    PWeight:=ExStockRec.PWeight;
    UnitSupp:=ExStockRec.UnitSupp;
    SuppSUnit:=ExStockRec.SuppSUnit;

    //PR 23/2/05: Change to allow empty string to BinLoc
//    If (Not EmptyKey(ExStockRec.BinLoc,BinLen)) then
    //PR 02/06/05 Added BinLoc10 field to tk rec
    {$IFNDEF COMTK}
      if Length(ExStockRec.BinLoc10) > 0 then
        BinLoc:=FullBinCode(ExStockRec.BinLoc10)
      else
    {$ENDIF}
        BinLoc:=FullBinCode(ExStockRec.BinLoc);
      TempBLoc:=BinLoc;  { Added in 4.31 - 24.01.2000 }

    CovPr:=ExStockRec.CovPr;
    CovPrUnit:=ExStockRec.CovPrUnit;
    CovMinPr:=ExStockRec.CovMinPr;
    CovMinUnit:=ExStockRec.CovMinUnit;
    Supplier:=FullCustCode(ExStockRec.Supplier);
    UseCover:=WordBoolToBool(ExStockRec.UseCover);
    CovMaxPr:=ExStockRec.CovMAxPr;
    CovMaxUnit:=ExStockRec.CovMaxUnit;
    ROCurrency:=ExStockRec.ROCurrency;
    ROCPrice:=ExStockRec.ROCPrice;
    RODate:=ExStockRec.RODate;
    StkValType:=ExStockRec.StkValType;
    LastUsed:=Today; {for v4.31 - ExStockRec.LastUsed;}
    TimeChange:=TimeNowStr;  {for v4.31 }

    {* Added on 14.07.97 *}
    BarCode:=FullBarCode(ExStockRec.StBarCode);
    ROCCDep[BOn]:=FullCCDepKey(UpperCase(ExStockRec.StROCostCentre));
    ROCCDep[BOff]:=FullCCDepKey(UpperCase(ExStockRec.StRODepartment));
    DefMLoc:=Full_MlocKey(UpperCase(ExStockRec.StLocation));
    PricePack:=WordBoolToBool(ExStockRec.StPricePack);
    DPackQty:=WordBoolToBool(ExStockRec.StDPackQty);
    KitPrice:=WordBoolToBool(ExStockRec.StKitPrice);
    KitOnPurch:=WordBoolToBool(ExStockRec.StKitOnPurch);
    StkUser1:=ExStockRec.StStkUser1;
    StkUser2:=ExStockRec.StStkUser2;

    JAnalCode:=UpperCase(ExStockRec.JAnalCode);

    {*** ver 4.31 ***}
    WebInclude:=ExStockRec.WebInclude;
    {WebLiveCat:=ExStockRec.WebLiveCat;   .. ReadOnly }
    {Needs to be updatable - but only Exchequer should use !}
    WebPrevCat:=ExStockRec.WebPrevCat;
    StkUser3:=ExStockRec.StkUser3;
    StkUser4:=ExStockRec.StkUser4;
    SerNoWAvg:=ExStockRec.SerNoWAvg;
    SSDDUplift:=ExStockRec.SSDDUplift;
    // MH 18/01/2016 2016-R1 ABSEXCH-17099: SSD Country field no longer used for UK
    If (CurrentCountry <> UKCCode) Then
      SSDCountry := ExStockRec.SSDCountry
    Else
      // Use fillchar to ensure that the underlying byte values within the string are cleared
      // down - setting it to '' would just set the length byte to 0 leaving them intact
      FillChar (SSDCountry, SizeOf(SSDCountry), #0);

    SVATIncFlg:=ExStockRec.SVATIncFlg;
    LastOpo:=ExStockRec.LastOpo;
    ImageFile:=ExStockRec.ImageFile;

    //9/12/2003 - new fields added for 560
    {$IFDEF COMTK}
     SSDAUpLift := ExStockRec.SSDAUplift;
     BOMProdTime := ExStockRec.BOMProdTime;

     Days  := ExStockRec.WOPProdTimeDays;
     Hours := ExStockRec.WOPProdTimeHours;
     Mins  := ExStockRec.WOPProdTimeMins;
     Time2Mins(ProdTime, Days, Hours, Mins, 1);

     Leadtime := ExStockRec.WOPLeadTime;
     CalcProdTime := ExStockRec.WOPCalcProdTime;
     MinEccQty := ExStockRec.WOPMinEcQty;
     WOPWIPGL := ExStockRec.WOPIssuedWIPGL;
     QtyTake := ExStockRec.QtyStockTake;
     StkFlg := ExStockRec.QtyStockTakeChanged;
     QtyFreeze := ExStockRec.QtyFreeze;

     If (Not (ExStockRec.StkValType In ['E','R'])) then
       MultiBinMode := ExStockRec.UsesBins
     else
       MultiBinMode := False;

     //22/7/05 new fields for 5.70
     {$IFDEF EN570}
       SWarranty := ExStockRec.SalesWarranty;
       SWarrantyType := ExStockRec.SalesWarrantyType;
       MWarranty := ExStockRec.PurchWarranty;
       MWarrantyType := ExStockRec.PurchWarrantyType;
       ReturnGL := ExStockRec.SalesRetGL;
       PReturnGL := ExStockRec.PurchRetGL;
       ReStockPcnt := ExStockRec.RestockCharge;
       ReStockPChr := ExStockRec.RestockFlag;
       if ReStockPChr = '%' then
         ReStockPcnt := ReStockPcnt / 100;
     {$ENDIF}
    {$ENDIF}


    //PR: 21/10/2011 v6.9
    StkUser5 := ExStockRec.StkUser5;
    StkUser6 := ExStockRec.StkUser6;
    StkUser7 := ExStockRec.StkUser7;
    StkUser8 := ExStockRec.StkUser8;
    StkUser9 := ExStockRec.StkUser9;
    StkUser10 := ExStockRec.StkUser10;

    {$IFDEF COMTK}
      // MH 09/09/2014 v7.1 ABSEXCH-15052: Added EC Service Flag
      If ((CurrentCountry = UKCCode) Or (CurrentCountry = IECCode)) And SyssVAT.VATRates.EnableECServices Then
        stIsService := ExStockRec.StkIsService
      Else
        stIsService := False;
    {$ENDIF COMTK}

    if (ExStockRec.StkLinkLT in [0..4]) then
      StkLinkLT := ExStockRec.StkLinkLT;

    CalcPack:=WordBoolToBool(ExStockRec.PriceByStkUnit);  { Has validation }

    ShowAsKit := WordBoolToBool(ExStockRec.ShowAsKit);

    {*** ----------------------- ***}

    {* Start Validation *}

    ValidCheck:=((OStock.StockCat=StockCat) or (AddMode=B_Insert));

    GenSetError(ValidCheck,30270,Result,ValidHed);

    {* Stock Type Check *}

    ValidCheck:=((AddMode=B_Update) and (OStock.StockType = StockType)) or
                ((AddMode=B_Insert) and (StockType In StkProdSet+[StkDescCode,StkGrpCode]));

    GenSetError(ValidCheck,30271,Result,ValidHed);

    ValidCheck:=(Not EmptyKey(StockCode,StkLen));

    GenSetError(ValidCheck,30272,Result,ValidHed);

    {* Stock Group Check *} //At BH's request moved below to be last test
//-----------------------------------------------------------------------------
(*    OStock:=Stock; {* Temp preserve *}

    ValidCheck:=(EmptyKey(StockCat,StkLen));  {* Blank StkCat = Level 0 *}

    If (Not ValidCheck) then
    Begin

      ValidCheck:=(CheckRecExsists(OStock.StockCat,StockF,StkCodeK));

      ValidCheck:=((ValidCheck) and (StockType=StkGrpCode));
    end;

    Stock:=OStock;

    GenSetError(ValidCheck,30273,Result,ValidHed); *)
//------------------------------------------------------------------------------
    {* VAT Code Check *}

    ValidCheck:=(((VATCode<>VATMCode) and (VATCode In VATSet))
                  or (StockType=StkGrpCode));

    GenSetError(ValidCheck,30274,Result,ValidHed);

    {* Check Def Supplier *}

    ValidCheck:=(EmptyKey(Supplier,AccLen));

    If (Not ValidCheck) then
    begin
      ValidCheck:=CheckRecExsists(Supplier,CustF,CustCodeK);

      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[BOff]));
    end;

    SuppTemp:=Supplier;

    GenSetError(ValidCheck,30275,Result,ValidHed);

    {* Check Currency *}

    If (ExSyss.MCMode) then
      ValidCheck:=(((PCurrency>=1) and (PCurrency<=CurrencyType)) or (StockType=StkGrpCode))
    else
    Begin
      ValidCheck:=BOn;
      PCurrency:=0;
    end;

    GenSetError(ValidCheck,30276,Result,ValidHed);

    If (ExSyss.MCMode) then
      ValidCheck:=(((ROCurrency>=1) and (ROCurrency<=CurrencyType)) or (StockType=StkGrpCode))
    else
    Begin
      ValidCheck:=BOn;
      ROCurrency:=1;
    end;

    GenSetError(ValidCheck,30277,Result,ValidHed);

    For n:=1 to (NofSBands - 2) do
    Begin
      With SaleBands[n] do
      If (ExSyss.MCMode) then
      Begin
        If (SalesPrice<>0) then
        Begin
          ValidCheck:=((Currency>=1) and (Currency<=Pred(CurrencyType)));
          GenSetError(ValidCheck,30278,Result,ValidHed);
        end;
      end
      else
        Currency:=0;

    end; {Loop..}

    {* Stock Valuation Type - Import has Default Value to be assigned if not valid,
       but not in DLL *}
    //PR 7/04/06 - Moved ValuationMethod check to Validate.pas
//    ValidCheck:=((StkValType In StkValueSet) or (StockType=StkGrpCode));
    ValidCheck:=(ValidateStockValuationMethod(StkValType) or (StockType=StkGrpCode));

    GenSetError(ValidCheck,30279,Result,ValidHed);

    //PR 7/04/06 - Moved all GL Code checks to ValidateStockGL in Validate.pas
    For n:=1 to NofSNoms do
    Begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(NomCodeS[n])),NomF,NomCodeK));

      ValidCheck := ValidCheck or ((StockType=StkGrpCode) and (NomCodeS[n] = 0));

      if (StockType <> StkGrpCode) then
        ValidCheck := ValidCheck and ValidateStockGL(n, Nom);

{      ValidCheck:=(((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]))
                   or (StockType=StkGrpCode));}

      GenSetError(ValidCheck,30280,Result,ValidHed);
    end;

    {$IFDEF COMTK}
    if WOPOn and (StockType = StkBillCode) then
    begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(WOPWIPGL)),NomF,NomCodeK));

      ValidCheck := ValidCheck and ValidateStockGL(sglWIP, Nom);


//      ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

      GenSetError(ValidCheck,30297,Result,ValidHed);
    end
    else
      WOPWIPGL := 0;

    {$IFDEF EN570}
     if RetMOn and not (StockType in [StkGrpCode, StkDescCode]) then
     begin
      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(ReturnGL)),NomF,NomCodeK));

//      ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));
      ValidCheck := ValidCheck and ValidateStockGL(sglSalesRet, Nom);

      GenSetError(ValidCheck,30298,Result,ValidHed);

      ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(PReturnGL)),NomF,NomCodeK));

//      ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));
      ValidCheck := ValidCheck and ValidateStockGL(sglPurchRet, Nom);

      GenSetError(ValidCheck,30299,Result,ValidHed);

     end;
    {$ENDIF 570}
    {$ENDIF COMTK}

    {$IFDEF COMTK}
      // MH 09/09/2014 v7.1 ABSEXCH-15052: Added EC Service Flag
      If ValidCheck And stIsService Then
      Begin
        // EC Service can only be set for Description Only stock items
        ValidCheck := (StockType = StkDescCode);
        GenSetError(ValidCheck,30300,Result,ValidHed);
      End; // If ValidCheck And stIsService
    {$ENDIF COMTK}


    {* Check Selling Units *}
    //PR: 27/08/2010 Removed Stock Unit checks at MR's request (ABSEXCH-10170)
    (*

    ValidCheck:=((SellUnit<>0) or (StockType=StkGrpCode));

    GenSetError(ValidCheck,30281,Result,ValidHed);

    ValidCheck:=((BuyUnit<>0) or (StockType=StkGrpCode));

    GenSetError(ValidCheck,30282,Result,ValidHed);

    If (Not ValidCheck) then
      BuyUnit:=1;

    ValidCheck:=(((SuppSUnit<>0) or (Not Syss.IntraStat)) or (StockType=StkGrpCode));

    GenSetError(ValidCheck,30283,Result,ValidHed);

    If (Not ValidCheck) then
      SuppSUnit:=1;
    *)

    {* Check Cover *}

    If (UseCover) then
    Begin
      ValidCheck:=(CovPr>0);

      GenSetError(ValidCheck,30284,Result,ValidHed);

      ValidCheck:=((CovMinUnit In CoverPrSet) or ((CovMinUnit=#0) and (CovMinPr=0)));

      GenSetError(ValidCheck,30285,Result,ValidHed);

      ValidCheck:=((CovMaxUnit In CoverPrSet) or ((CovMaxUnit=#0) and (CovMaxPr=0)));

      GenSetError(ValidCheck,30286,Result,ValidHed);
    end
    else
    Begin
      CovPr:=0;
      CovPrUnit:=#0;
      CovMinPr:=0;
      CovMinUnit:=#0;
      CovMaxPr:=0;
      CovMaxUnit:=#0;
    end;

    {* Check CC/Dep *}
    For Tbo:=BOff to BOn do
    Begin
      {* if location master UseCCDep is On *}
      ValidCheck:=((Not Syss.UseCCDep) or (EmptyKey(CCDep[Tbo],CCDpLen)) );

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat
          ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+CCDep[TBo],PWrdF,PWK)));
          GenSetError(ValidCheck,CCDepMsg[Tbo],Result,ValidHed);

          If (Not ValidCheck) then
              CCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);

        {SS 22/06/2016 2016-R3 
         ABSEXCH-12948:Core Financials - Possible to import Transactions with Inactive CC/Depts using Importer Module.
        -Added validation to check Cost Centre/Department is active or not.}
        if ValidCheck then
        begin
          ValidCheck := (PassWord.CostCtrRec.HideAC = 0);
          GenSetError(ValidCheck,CCDepActMsg[Tbo],Result,ValidHed);
        end;
      end;
    end;

    {* Check ROCC/Dep *}
    For Tbo:=BOff to BOn do
    Begin
      {* if location master UseCCDep is On *}
      ValidCheck:=((Not Syss.UseCCDep) or (EmptyKey(ROCCDep[Tbo],CCDpLen)) );

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat
          ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+ROCCDep[TBo],PWrdF,PWK)));
          GenSetError(ValidCheck,ROCCDepMsg[Tbo],Result,ValidHed);

          If (Not ValidCheck) then
              ROCCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);
      end;
    end;

    {* Location Code Check *}
    { Added -1 to SizeOf seems OK, but should use length of string instead ??? }
    ValidCheck:=(EmptyKey(DefMLoc,Sizeof(DefMLoc)-1) or (Not Syss.UseMLoc) or
                (CheckRecExsists(CostCCode+CSubCode[BOn]+DefMLoc,MLocF,MLK)));

    GenSetError(ValidCheck,30291,Result,ValidHed);

    {* Ver 4.31 Validation *}
    {* Check Serial No. Average *}
    ValidCheck:=BOn;
    If (StkValType=MSERNSub) then
      ValidCheck:=(SerNoWAvg In [0..1])
    else
      SerNoWAvg:=0;

    GenSetError(ValidCheck,30292,Result,ValidHed);

    {* SSD Despatch Uplift Check *}
    ValidCheck:=(SSDDUplift>=0) and (SSDDUplift<=100);
    GenSetError(ValidCheck,30293,Result,ValidHed);

    {* CVat Inc. Flag Check *}
    If (VATCode=VATICode) then
    begin
      ValidCheck:=(SVATIncFlg In VATSet-VATEqStd);
      GenSetError(ValidCheck,30294,Result,ValidHed);
    end; {if..}

    {* Job Anal. Code *}
    If (Not EmptyKey(JAnalCode,JobcodeLen)) then
    begin
      JAnalCode:=LJVar(JAnalCode,JobcodeLen);
      ValidCheck:=(CheckRecExsists(JARCode+JAACode+JAnalCode,JMiscF,JMK));
      GenSetError(ValidCheck,30295,Result,ValidHed);
    end;

    {* They are used in Combo Box in the Ent. hence, should not set True in both fields *}
    ValidCheck:=(Not PricePack) or (Not CalcPack);
    GenSetError(ValidCheck,30296,Result,ValidHed);

    //PR: 04/02/2016 v2016 R1 ABSEXCH-17243 Commodity code must be blank or 8 digits
    if (CommodCode <> '') and IntrastatEnabled then
    begin
      // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
      Val(CommodCode, TmpSSD, ErrSSDCode);
      ValidCheck:=(ErrSSDCode=0) and ((Length(Trim(CommodCode)) = 8) Or (Length(Trim(CommodCode)) = 10));
      GenSetError(ValidCheck,30301,Result,ValidHed);
    end; {if..}

    {* Stock Group Check *} //Moved from above to be last test, at BH's request
//-----------------------------------------------------------------------------
    OStock:=Stock; {* Temp preserve *}

    ValidCheck:=(EmptyKey(StockCat,StkLen));  {* Blank StkCat = Level 0 *}

    If (Not ValidCheck) then
    Begin

      ValidCheck:=(CheckRecExsists(OStock.StockCat,StockF,StkCodeK));

      ValidCheck:=((ValidCheck) and (StockType=StkGrpCode));
    end;

    Stock:=OStock;

    GenSetError(ValidCheck,30273,Result,ValidHed);
//------------------------------------------------------------------------------

    {* --------- End of Validation -------- *}

    {* Wins Import *}
    If ((TmpMode<>CheckMode) and (Result=0)) then
    Begin
      If (AddMode=B_Insert) then
      Begin
        Result:=GetNextCount(SKF,BOn,BOff,0,StockFolio,'');
        If (Result=0) then
          Result:=Add_Rec(F[StockF],StockF,RecPtr[StockF]^,Keypath);

          //PR: 02/11/2011 v6.9
          if Result = 0 then
            AuditNote.AddNote(anStock, Stock.StockFolio, anCreate);
      end
      else {* AddMode=Edit*}
      Begin
        OStock:=Stock;
        KeyS:=Stock.StockCode;

        {$IFDEF WIN32}
        begin
          If (GetMultiRec(B_GetEq,B_SingLock,KeyS,StkCodeK,StockF,SilentLock,GlobLocked)) then
            Result:=0;
          // If not locked and user hits cancel return code 84
          if (Result = 0) and not GlobLocked then
            Result := 84;
        end;
        {$ELSE}
        Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,StkCodeK,StockF,SilentLock,GlobLocked));
        {$ENDIF}

        Stock:=OStock;

        If (Result=0) and (GlobLocked) then
        begin
          {* Preserve these Ex Set Variables *}

          StockFolio:=OrgStock.StockFolio;
          MinFlg:=OrgStock.MinFlg;

          // MH 09/02/2011 v6.6 ABSEXCH-9480: Modified to set ROFlg depending on the Re-Order Qty
          //PR: 19/11/2012 ABSEXCH-13753 Allow use of pre-fix functionality
          if not Use9480ReOrder then
            ROFlg:=OrgStock.RoFlg;

          QtyInStock:=OrgStock.QtyInStock;
          QtyPosted:=OrgStock.QtyPosted;
          QtyAllocated:=OrgStock.QtyAllocated;
          QtyOnOrder:=OrgStock.QtyOnOrder;
          NLineCount:=OrgStock.NLineCount;
          SubAssyFlg:=OrgStock.SubAssyFlg;
//          ShowAsKit:=OrgStock.ShowAsKit;
          BLineCount:=OrgStock.BLineCount;
          RODate:=OrgStock.RODate;
          CovSold:=OrgStock.CovSold;
          QtyFreeze:=OrgStock.QtyFreeze;
          //PR: 25/10/04 Allow QtyTake & StkFlg to be updated.
//          StkFlg:=OrgStock.StkFlg;
       (* JF: 09-10-2000 Apparently OK to update these according to EAL
          ROCurrency:=OrgStock.ROCurrency;
          ROCPrice:=OrgStock.ROCPrice; *)
//          QtyTake:=OrgStock.QtyTake;
          HasSerNo:=OrgStock.HasSerNo;

          { 06.11.2000 - to change the system setup switch for updating BOM Cost Price }

          UpdateBOMCost:=((OrgStock.PCurrency<>PCurrency) or (OrgStock.CostPrice<>CostPrice));

          Result:=Put_Rec(F[StockF],StockF,RecPtr[StockF]^,StkCodeK);

          //PR: 02/11/2011 v6.9
          if Result = 0 then
            AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);

          If (UpdateBOMCost) and (Result=0) then
          begin
            { in SysU2 - check Syss.AutoBillUp and change Syss.NeedBMUp }
            Update_UpChange(BOn);
          end; {if UpdateBOMCost..}


        end; {if Lock O.k ...}


      end;

    end; {if result=0 ..}

    {SS 15/06/2016 2016-R3 
    ABSEXCH-13693:Importer doesn't validate Global Time Rate record import where the same Stock Code already exists and vice versa.
    -Validation of Time Rate record.}
    if Result = 0 then
    begin
      ValidCheck := not TimeRateExists;
      GenSetError(ValidCheck,30302,Result,ValidHed);
    end;
  end; {with..}

end; {proc..}

{* -------------------------------------------------------------------------- *}

{* ========== Store Stock ========== *}

FUNCTION EX_STORESTOCK(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;
Var
  ExStockRec  :  ^TBatchSKRec;
  KeyS        :  Str255;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExStockRec:=P;
    ShowMessage ('Ex_StoreStock:' + #10#13 +
                 'P^.StockCode: ' + ExStockRec^.StockCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSKRec)) then
  Begin
    ExStockRec:=P;
    //PR: 03/05/2005 Change to check for full stock
    if StockOn and (FullStkSysOn or (ExStockRec.StockType in ['G', 'D', 'X']))  then
      Result:=ExStockToStock(ExStockRec^,SearchMode,SearchPath)
    else
    begin
      if StockOn then
        Result := NoFullStock
      else
        Result := NoStockErr;
    end;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(31,Result);

end; {Func..}

{* -------------------------------------------------------------------------- *}

{ ======== Function to Lock a customer record ============ }

FUNCTION EX_UNLOCKSTOCK  :  SMALLINT;

Var
  KeyS  :  Str255;

Begin

  Blank(KeyS,Sizeof(KeyS));

  Result:=Find_Rec(B_Unlock,F[StockF],StockF,RecPtr[StockF]^,0,KeyS);

  If (Result<>0) then
    LastErDesc:='Unabl to Unlock the Stock Record';


end; {func..}

{* -------------------------------------------------------------------------- *}

{* =========== Store into Ex.Multi Location Stock ========== *}

Procedure CopyExStockLocToTKStockLoc(Const StkLoc : MStkLocType; Var ExSLRec : TBatchSLRec);

Var
  n  :  Byte;

Begin
  With StkLoc {MLocCtrl^.MStkLoc} do
  Begin
    ExSLRec.lsStkCode:=lsStkCode;
    ExSLRec.lsLocCode:=lsLocCode;
    ExSLRec.lsQtyInStock:=lsQtyInStock;
    ExSLRec.lsQtyOnOrder:=lsQtyOnOrder;
    ExSLRec.lsQtyAlloc:=lsQtyAlloc;
    ExSLRec.lsQtyPicked:=lsQtyPicked;
    ExSLRec.lsQtyMin:=lsQtyMin;
    ExSLRec.lsQtyMax:=lsQtyMax;
    ExSLRec.lsQtyFreeze:=lsQtyFreeze;
    ExSLRec.lsRoQty:=lsRoQty;
    ExSLRec.lsRoDate:=lsRoDate;
    ExSLRec.lsRoCC:=lsRoCCDep[BOn];
    ExSLRec.lsRoDep:=lsRoCCDep[BOff];
    ExSLRec.lsCC:=lsCCDep[BOn];
    ExSLRec.lsDep:=lsCCDep[BOff];
    ExSLRec.lsBinLoc:=lsBinLoc;
    ExSLRec.lsROPrice:=lsROPrice;
    ExSLRec.lsROCurrency:=lsROCurrency;
    ExSLRec.lsCostPrice:=lsCostPrice;
    ExSLRec.lsPCurrency:=lsPCurrency;
    ExSLRec.lsMinFlg:=BoolToWordBool(lsMinFlg);
    ExSLRec.lsTempSupp:=lsTempSupp;
    ExSLRec.lsSupplier:=lsSupplier;
    ExSLRec.lsLastUsed:=lsLastUsed;
    ExSLRec.lsQtyPosted:=lsQtyPosted;
    ExSLRec.lsQtyTake:=lsQtyTake;
    ExSLRec.lsLastTime:=lsLastTime;

    For n:=1 to NofSNoms do
      ExSLRec.lsDefNom[n]:=lsDefNom[n];

    For n:=1 to NofSBands-2 do
    Begin
      ExSLRec.lsSaleBands[n].Currency:=lsSaleBands[n].Currency;
      ExSLRec.lsSaleBands[n].SalesPrice:=lsSaleBands[n].SalesPrice;
    end;

    ExSLRec.lsQtyAllocWOR := lsQtyAllocWOR;
    ExSLRec.lsQtyIssueWOR := lsQtyIssueWOR;
    ExSLRec.lsQtyPickWOR  := lsQtyPickWOR;
    ExSLRec.lsWOPWIPGL    := lsWOPWIPGL;

    {$IFDEF COMTK}
    ExSLRec.lsSalesWarranty := lsSWarranty;
    ExSLRec.lsSalesWarrantyType := lsSWarrantyType;
    ExSLRec.lsPurchWarranty := lsMWarranty;
    ExSLRec.lsPurchWarrantyType := lsMWarrantyType;
    ExSLRec.lsSalesRetGL := lsReturnGL;
    ExSLRec.lsPurchRetGL := lsPReturnGL;
    ExSLRec.lsRestockCharge := lsReStockPcnt;
    ExSLRec.lsSalesRetQty := lsQtyReturn;
    ExSLRec.lsPurchRetQty := lsQtyPReturn;


    {$ENDIF}


  end;
end; {proc..}

Procedure StockLocToExStockLoc(Var ExSLRec : TBatchSLRec);
begin
  CopyExStockLocToTKStockLoc(MLocCtrl^.MStkLoc, ExSLRec);
end;

{* -------------------------------------------------------------------------- *}

{* ========== Get Stock by Location ========== *}

FUNCTION EX_GETSTOCKLOC(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHKEY    :  PCHAR;
                        SEARCHLOC    :  PCHAR;
                        LOCK         :  WORDBOOL )  :  SMALLINT;

Const
  Fnum       = MLocF;
  SearchPath = MLK;
Var
  ExSLRec    :  ^TBatchSLRec;
  SKey,SLoc,
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
Begin
  LasterDesc:='';
  If TestMode Then Begin
    ExSLRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetStockLoc:' + #10#13 +
                 'P^.StockCode: ' + ExSLRec^.lsStkCode + #10#13 +
                 'P^.Loc.Code: ' + ExSLRec^.lsLocCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchLoc: '  + StrPas(SearchLoc) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PSize=Sizeof(TBatchSLRec)) then
  Begin
    SKey:=UpperCase(StrPas(SearchKey));
    SLoc:=UpperCase(StrPas(SearchLoc));

    KeyS:=CostCCode+CSubCode[False]+LJVar(SKey,StkLen)+LJVar(SLoc,MLocLen);
          {  C     +      D        + Stock Code       +    Location Code       }


    ExSLRec:=P;
    Blank(ExSLRec^,Sizeof(ExSLRec^));
    UseVariant(F[FNum]);
    Result:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[FNum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
    {$ENDIF}

    If (Result=0) then
      StockLocToExStockLoc(ExSLRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(70,Result);

end; {Ex_GetStockLoc..}

{* -------------------------------------------------------------------------- *}

{ ===== ExStockLocToStockLoc ===== }

Function ExStockLocToStockLoc(ExSLRec    :  TBatchSLRec;
                              AddMode    :  Integer)  :  Integer;

Const
  Fnum       = MLocF;
  SearchPath = MLK;

  CCDepMsg     : Array[BOff..BOn] of Integer = (30280,30279);
  RoCCDepMsg   : Array[BOff..BOn] of Integer = (30282,30281);
Var
  n       :  Byte;
  OStkLoc :  MStkLocType;
  OLocLoc :  MLocLocType;

  Tbo,RepBo,
  FindRec,
  ValidCheck,
  ValidHed      : Boolean;

  KeyS          : Str255;

Begin
  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;

  FillChar(OLocLoc,SizeOf(OLocLoc),#0);

  With ExSLRec do
  begin
    lsStkCode:=LJVar(UpperCase(lsStkCode),StkLen);
    lsLocCode:=LJVar(UpperCase(lsLocCode),MLocLen);
  end;

  With MLocCtrl^.MStkLoc do
  Begin

    KeyS:=CostCCode+CSubCode[False]+ExSLRec.lsStkCode+ExSLRec.lsLocCode;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,MLK,KeyS);

    FindRec:=StatusOk;

    If (AddMode=B_Insert) then
    Begin
      ResetRec(Fnum);
      lsStkCode:=ExSLRec.lsStkCode;
      lsLocCode:=ExSLRec.lsLocCode;
      GenSetError(Not FindRec,5,Result,ValidHed);
    end
    else
    Begin
      GenSetError(FindRec,4,Result,ValidHed);
      OStkLoc:=MLocCtrl^.MStkLoc;

    end;

    {** Start conversion **}
    lsQtyMin:=ExSLRec.lsQtyMin;
    lsQtyMax:=ExSLRec.lsQtyMax;
    lsRoQty:=ExSLRec.lsRoQty;
    // MH 09/02/2011 v6.6 ABSEXCH-9480: Modified to set Stk-Loc ROFlg depending on the Re-Order Qty
    //PR: 19/11/2012 ABSEXCH-13753 Allow use of pre-fix functionality
    if Use9480ReOrder then
      lsROFlg := (lsROQty > 0);
    lsRoDate:=ExSLRec.lsRoDate;
    lsRoCCDep[BOn]:=FullCCDepKey(UpperCase(ExSLRec.lsRoCC));
    lsRoCCDep[BOff]:=FullCCDepKey(UpperCase(ExSLRec.lsRoDep));
    lsCCDep[BOn]:=FullCCDepKey(UpperCase(ExSLRec.lsCC));
    lsCCDep[BOff]:=FullCCDepKey(UpperCase(ExSLRec.lsDep));
    lsBinLoc:=FullBinCode(ExSLRec.lsBinLoc);
    lsRoPrice:=ExSLRec.lsRoPrice;
    lsCostPrice:=ExSLRec.lsCostPrice;
    lsPCurrency:=ExSLRec.lsPCurrency;
    lsRoCurrency:=ExSLRec.lsRoCurrency;
    If (lsQtyInStock<lsQtyMin) then
      lsMinFlg:=BOn;
    lsTempSupp:=FullCustCode(ExSLRec.lsTempSupp);
    lsSupplier:=FullCustCode(ExSLRec.lsSupplier);
    lsLastUsed:=Today; {ExSLRec.lsLastUsed; 13.12.99 for 4.31 }
    lsLastTime:=TimeNowStr; { v4.31 }
    lsQtyFreeze := ExSLRec.lsQtyFreeze;
    //PR: 11/06/02 Set StockTake flag if stocktake quantity is different to qty in stock
    lsStkFlg := Abs(lsQtyFreeze - ExSLRec.lsQtyTake) > 0.000001;
    lsQtyTake:=ExSLRec.lsQtyTake;

    //These are read only
    {    lsQtyAllocWOR := ExSLRec.lsQtyAllocWOR;
    lsQtyIssueWOR := ExSLRec.lsQtyIssueWOR;
    lsQtyPickWOR := ExSLRec.lsQtyPickWOR;}
    lsWOPWIPGL := ExSLRec.lsWOPWIPGL;


    For n:=1 to NofsNoms do
      lsDefNom[n]:=ExSLRec.lsDefNom[n];

    For n:=1 to NofSBands-2 do
    Begin
      lsSaleBands[n].Currency:=ExSLRec.lsSaleBands[n].Currency;
      lsSaleBands[n].SalesPrice:=ExSLRec.lsSaleBands[n].SalesPrice;
    end;

     //22/7/05 new fields for 5.70
     {$IFDEF EN570}
       lsSWarranty := ExSLRec.lsSalesWarranty;
       lsSWarrantyType := ExSLRec.lsSalesWarrantyType;
       lsMWarranty := ExSLRec.lsPurchWarranty;
       lsMWarrantyType := ExSLRec.lsPurchWarrantyType;
       lsReturnGL := ExSLRec.lsSalesRetGL;
       lsPReturnGL := ExSLRec.lsPurchRetGL;
       lsReStockPcnt := ExSLRec.lsRestockCharge;
     {$ENDIF}


    {* ===== start validation ===== *}

    {* Stock Code Check *}
    ValidCheck:=(CheckRecExsists(lsStkCode,StockF,StkCodeK));

    GenSetError(ValidCheck,30270,Result,ValidHed);

    {* Stock Group Check *}
    If (ValidCheck) then
      ValidCheck:=(Stock.StockType<>StkGrpCode);

    GenSetError(ValidCheck,30271,Result,ValidHed);

    {* check override status *}
    If (ValidCheck) then
    begin
      {* CC/Dept *}

      If (OLocLoc.loUseCCDep) then
      begin
        lsRoCCDep[BOn]:=OLocLoc.loCCDep[BOn];
        lsRoCCDep[BOff]:=OLocLoc.loCCDep[BOff];
        lsCCDep[BOn]:=OLocLoc.loCCDep[BOn];
        lsCCDep[BOff]:=OLocLoc.loCCDep[BOff];
      end;
      {* Nominal Codes *}
      If (OLocLoc.loUseNom) then
      begin
        For n:=1 to NofsNoms do
          lsDefNom[n]:=OLocLoc.loNominal[n];
      end;
    end; {if validcheck..}

    {* Check Temp. Supplier *}

    ValidCheck:=(EmptyKey(lsTempSupp,AccLen));

    If (Not ValidCheck) then
    begin
      ValidCheck:=CheckRecExsists(lsTempSupp,CustF,CustCodeK);
      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[BOff]));
    end;

    GenSetError(ValidCheck,30273,Result,ValidHed);

    {* Check Main Supplier *}

    ValidCheck:=(EmptyKey(lsSupplier,AccLen));

    If (Not ValidCheck) then
    begin
      ValidCheck:=CheckRecExsists(lsSupplier,CustF,CustCodeK);
      ValidCheck:=((ValidCheck) and (Cust.CustSupp=TradeCode[BOff]));
    end;

    GenSetError(ValidCheck,30274,Result,ValidHed);

    {* Check Cost Currency *}

    If (ExSyss.MCMode) then
      ValidCheck:=((lsPCurrency>=1) and (lsPCurrency<=CurrencyType))
    else
    Begin
      ValidCheck:=BOn;
      lsPCurrency:=0;
    end;

    GenSetError(ValidCheck,30275,Result,ValidHed);

    {* Check Re-order Currency *}

    If (ExSyss.MCMode) then
      ValidCheck:=((lsROCurrency>=1) and (lsROCurrency<=CurrencyType))
    else
    Begin
      ValidCheck:=BOn;
      lsROCurrency:=0;
    end;

    GenSetError(ValidCheck,30276,Result,ValidHed);

    {* Check Sales Currency *}
    For n:=1 to (NofSBands - 2) do
    Begin
      With lsSaleBands[n] do
      If (ExSyss.MCMode) then
      Begin
        If (SalesPrice<>0) then
        Begin
          ValidCheck:=((Currency>=1) and (Currency<=CurrencyType));
          GenSetError(ValidCheck,30277,Result,ValidHed);
        end;
      end
      else
        Currency:=0;
    end; {Loop..}

    {* Nominal Code Check *}

    For n:=1 to NofSNoms do
    Begin

      ValidCheck:=(lsDefNom[n]=0);   {* can be Zero *}

      If (Not ValidCheck) then
      begin
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(lsDefNom[n])),NomF,NomCodeK));
        ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode])); {* B or A *}
      end;

      GenSetError(ValidCheck,30278,Result,ValidHed);

    end;
    {$IFDEF COMTK}
    {$IFDEF EN570}
     if RetMOn then
     begin
      ValidCheck := lsReturnGL = 0;
      if not ValidCheck then
      begin
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(lsReturnGL)),NomF,NomCodeK));

        ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

        GenSetError(ValidCheck,30283,Result,ValidHed);
      end;

      ValidCheck := lsPReturnGL = 0;
      if not ValidCheck then
      begin
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(lsPReturnGL)),NomF,NomCodeK));

        ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

        GenSetError(ValidCheck,30284,Result,ValidHed);
      end;

     end;
    {$ENDIF 570}
    {$ENDIF COMTK}


    {* Check CC/Dep *}
    For Tbo:=BOff to BOn do
    Begin

      {* if location master UseCCDep is On *}
      ValidCheck:=((Not Syss.UseCCDep) or (EmptyKey(lsCCDep[Tbo],CCDpLen)) or (OLocLoc.loUseCCDep));

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat
          ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+lsCCDep[TBo],PWrdF,PWK)));
          GenSetError(ValidCheck,CCDepMsg[Tbo],Result,ValidHed);

          If (Not ValidCheck) then
              lsCCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);
      end;
    end;

    {* Check RoCC/Dep *}
    For Tbo:=BOff to BOn do
    Begin

      {* if location master UseCCDep is On *}
      ValidCheck:=((Not Syss.UseCCDep) or (EmptyKey(lsRoCCDep[Tbo],CCDpLen)) or (OLocLoc.loUseCCDep));

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat
          ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+lsRoCCDep[TBo],PWrdF,PWK)));
          GenSetError(ValidCheck,RoCCDepMsg[Tbo],Result,ValidHed);

          If (Not ValidCheck) then
              lsRoCCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);
      end;
    end;

    If (Result=0) and (AddMode <> CheckMode) then
    Begin
      If (AddMode=B_Insert) then
      Begin
        With MLocCtrl^ do
        begin
          RecPFix:=CostCCode;
          SubType:=CSubCode[False];
          MStkLoc.lsCode1:=LJVar(lsStkCode,StkLen)+LJVar(lsLocCode,MLocLen);
          MStkLoc.lsCode2:=LJVar(lsLocCode,MLocLen)+LJVar(lsStkCode,StkLen);
          {MStkLoc.lsCode3:=; To confirm }
          MStkLoc.lsStkFolio:=Stock.StockFolio;
        end;
        If (Result=0) then
          Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

          //PR: 02/11/2011 v6.9  Adding a new stock/location can be considered as editing the stock
          if Result = 0 then
            AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
      end
      else
      Begin

        OStkLoc:=MLocCtrl^.MStkLoc;

        KeyS:=CostCCode+CSubCode[False]+LJVar(lsStkCode,StkLen)+LJVar(lsLocCode,MLocLen);

        {$IFDEF WIN32}
        begin
          If (GetMultiRec(B_GetEq,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,GlobLocked)) then
            Result:=0;
          // If not locked and user hits cancel return code 84
          if (Result = 0) and not GlobLocked then
            Result := 84;
        end;
        {$ELSE}
        Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,GlobLocked));
        {$ENDIF}

        MLocCtrl^.MStkLoc:=OStkLoc;

        If (Result=0) and (GlobLocked) then
          Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath);

          //PR: 02/11/2011 v6.9
          if Result = 0 then
            AuditNote.AddNote(anStock, Stock.StockFolio, anEdit);
      end;

    end;
   end;
end;

{* -------------------------------------------------------------------------- *}

{ ===== Store Multi Location Stock ===== }

FUNCTION EX_STORESTOCKLOC(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Var
   ExSLRec    :  ^TBatchSLRec;
   KeyS       :  Str255;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExSLRec:=P;
    ShowMessage ('Ex_StoreStockLoc:' + #10#13 +
                 'P^.lsStkCode: ' + ExSLRec^.lsStkCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSLRec)) then
  Begin
    ExSLRec:=P;
    if StockOn then
      Result:=ExStockLocToStockLoc(ExSLRec^,SearchMode)
    else
      Result := NoStockErr;
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(71,Result);

end; {Func..}

{* -------------------------------------------------------------------------- *}

{* ========== Location Master ========== *}

Procedure CopyExLocToTKLoc (Const MLocR : MLocLocType; Var ExLocRec : TBatchMLocRec);

Var
  n  :  Byte;

Begin
  With MLocR do
  Begin
    ExLocRec.loCode:=loCode;
    ExLocRec.loName:=loName;
    For n:=1 to 5 do
      ExLocRec.loAddr[n]:=loAddr[n];
    ExLocRec.loTel:=loTel;
    ExLocRec.loFax:=loFax;
    ExLocRec.loEMail:=loEmail;
    ExLocRec.loModem:=loModem;
    ExLocRec.loContact:=loContact;
    ExLocRec.loCurrency:=loCurrency;
    ExLocRec.loArea:=loArea;
    ExLocRec.loRep:=loRep;
    ExLocRec.loTag:=BoolToWordBool(loTag);
    ExLocRec.loCC:=loCCDep[BOn];
    ExLocRec.loDep:=loCCDep[BOff];
    ExLocRec.loUsePrice:=BoolToWordBool(loUsePrice);
    ExLocRec.loUseNom:=BoolToWordBool(loUseNom);
    ExLocRec.loUseCCDep:=BoolToWordBool(loUseCCDep);
    ExLocRec.loUseSupp:=BoolToWordBool(loUseSupp);
    ExLocRec.loUseBinLoc:=BoolToWordBool(loUseBinLoc);

    ExLocRec.loNLineCount := loNLineCount;
    ExLocRec.loUseCPrice := BoolToWordBool(loUseCPrice);
    ExLocRec.loUseRPrice := BoolToWordBool(loUseRPrice);
    ExLocRec.loWOPWIPGL := loWOPWIPGL;

    {$IFDEF COMTK}
    ExLocRec.loSalesRetGL := loReturnGL;
    ExLocRec.loPurchRetGL := loPReturnGL;
    ExLocRec.loUseCPrice := loUseCPrice;
    ExLocRec.loUseRPrice := loUseRPrice;
    {$ENDIF}

    For n:=1 to NofSNoms do
      ExLocRec.loNominal[n]:=loNominal[n];

  end;
end;

Procedure LocToExLoc(Var ExLocRec : TBatchMLocRec);
begin
  CopyExLocToTKLoc (MLocCtrl^.MLocLoc, ExLocRec);
end;

{* -------------------------------------------------------------------------- *}

{* ========== Get Location Master =========== *}

FUNCTION EX_GETLOCATION(P            :  POINTER;
                        PSIZE        :  LONGINT;
                        SEARCHKEY    :  PCHAR;
                        SEARCHPATH   :  SMALLINT;
                        SEARCHMODE   :  SMALLINT;
                        LOCK         :  WORDBOOL)  :  SMALLINT;

Const
  Fnum       = MLocF;

Var
  ExLocRec   :  ^TBatchMLocRec;
  SKey,SLoc,
  KeyS       :  Str255;
  loop,
  Locked     :  Boolean;
  LockStr    :  Str255;
  B_Func     :  Integer;
Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExLocRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetLocation:' + #10#13 +
                 'P^.Loc.Code: ' + ExLocRec^.loCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchPath: '  + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: '  + IntToStr(SearchMode) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;
  Loop:=BOn;
  B_Func:=0;

  If (P<>Nil) and (PSize=Sizeof(TBatchMLocRec)) then
  Begin
    SKey:=StrPas(SearchKey);
    KeyS:=CostCCode+CSubCode[BOn];
    Case SearchPath of
       0  : KeyS:=KeyS+LJVar(Uppercase(SKey),MLocLen);
       1  : KeyS:=KeyS+LJVar(SKey,MLocNamLen);
    end;

    ExLocRec:=P;
    Blank(ExLocRec^,Sizeof(ExLocRec^));

    Case SearchMode of
         B_GetGEq,
         B_GetGretr,
         B_GetNext   :  B_Func:=B_GetNext;

         B_GetLess,
         B_GetLessEq,
         B_GetPrev   :  B_Func:=B_GetPrev;

         // HM 30/11/00: Rewrote Btrieve operations as STEP functions didn't work properly and
         //              reduced performance
         B_GetFirst,
         B_StepFirst :  Begin
                          SearchMode := B_GetGEq;
                          B_Func := B_GetNext;
                          KeyS:=CostCCode+CSubCode[BOn] + #0;
                        End;
         B_StepNext  :  Begin
                          SearchMode := B_GetNext;
                          B_Func:=B_GetNext;
                        End;
         B_StepPrev  :  Begin
                          SearchMode := B_GetPrev;
                          B_Func:=B_GetPrev;
                        End;
         B_GetLast,
         B_StepLast  :  Begin
                          SearchMode := B_GetLessEq;
                          B_Func:=B_GetPrev;
                          KeyS:=CostCCode+CSubCode[BOn] + #255;
                        End;

         else           Loop:=BOff;

    end; {Case..}

    KeyS:= SetKeyString(SearchMode, FNum, KeyS);

    Repeat
      UseVariant(F[Fnum]);
      Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

      SearchMode:=B_Func;

      // HM 30/11/00: Added cop-out clause to improve performance - otherwise it
      // runs to the EOF before finishing - very time consuming.
      If (MLocCtrl^.RecPFix <> CostCCode) Or (MLocCtrl^.SubType <> CSubCode[True]) Then
        // Not a Location record - abandon operation
        Result := 9;
    Until (Result<>0) or (Not Loop) or (MLocCtrl^.SubType=CSubCode[BOn]);

    If (MLocCtrl^.SubType<>CSubCode[BOn]) then
      Result:=4;

    KeyStrings[FNum] := KeyS;

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[Fnum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,Fnum,SilentLock,Locked));
    {$ENDIF}


    { ================ }

    If (Result=0) then
      LocToExLoc(ExLocRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(72,Result);

end; {Ex_GetLocation..}

{* -------------------------------------------------------------------------- *}

{ ===== ExLocToLoc ===== }

Function ExLocToLoc(ExLocRec    :  TBatchMLocRec;
                    AddMode     :  SmallInt;
                    KeyPath     :  SmallInt)  :  Integer;
Const
  Fnum       = MLocF;
  CCDepMsg   : Array[BOff..BOn] of Integer = (30274,30273);

Var
  n       :  Byte;
  OLocLoc :  MLocLocType;

  Tbo,RepBo,
  FindRec,
  ValidCheck,
  ValidHed     : Boolean;

  KeyS         : Str255;

  TmpMode      : SmallInt;

Begin
  Result:=0;
  ValidCheck:=BOff;
  ValidHed:=BOn;
  TmpMode:=AddMode;

  FillChar(OLocLoc,SizeOf(OLocLoc),#0);

  With ExLocRec do
  begin
    loCode:=LJVar(UpperCase(LoCode),MLocLen);
    //PR: 16/11/2010 Remove padding to be consistent with Enter1
    {$IFNDEF IMPv6}
    loName:=LJVar(loName,MLocNamLen);
    {$ENDIF}
  end;

  With MLocCtrl^.MLocLoc do
  Begin

    KeyS:=CostCCode+CSubCode[BOn]+ExLocRec.loCode;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    FindRec:=StatusOk;

    If ((AddMode=CheckMode) or (AddMode=ImportMode)) then
    begin
      If (FindRec) then
        AddMode:=B_Update
      else
        AddMode:=B_Insert

    end;

    If (AddMode=B_Insert) then
    Begin
      ResetRec(Fnum);
      loCode:=Full_MLocKey(UpperCase(ExLocRec.loCode));
      GenSetError(Not FindRec,5,Result,ValidHed);
    end
    else
    Begin
      GenSetError(FindRec,4,Result,ValidHed);
      OLocLoc:=MLocCtrl^.MLocLoc;
    end;

    {** Start conversion **}
    {$IFDEF IMPV6}
    //PR: 12/11/2010 Added ExLocRec. to to loName to fix ABSEXCH-10464
    //PR: 16/11/2010 To be compatible with Enter1, remove padding from name
    loName:=ExLocRec.loName;
    {$ELSE}
    //PR: 17/01/2014 ABSEXCH-14947 Need to prefix loName with ExLocRec.
    loName:=LJVar(ExLocRec.loName,MLocNamLen);
    {$ENDIF}
    For n:=1 to 5 do
      loAddr[n]:=ExLocRec.loAddr[n];
    loTel:=ExLocRec.loTel;
    loFax:=ExLocRec.loFax;
    loEMail:=ExLocRec.loEMail;
    loModem:=ExLocRec.loModem;
    loContact:=ExLocRec.loContact;
    loCurrency:=ExLocRec.loCurrency;
    loArea:=ExLocRec.loArea;
    loRep:=ExLocRec.loRep;
    loTag:=WordBoolToBool(ExLocRec.loTag);
    For n:=1 to NofsNoms do
      loNominal[n]:=ExLocRec.loNominal[n];

    loCCDep[BOn]:=FullCCDepKey(UpperCase(ExLocRec.loCC));
    loCCDep[BOff]:=FullCCDepKey(UpperCase(ExLocRec.loDep));
    loUsePrice:=WordBoolToBool(ExLocRec.loUsePrice);
    loUseNom:=WordBoolToBool(ExLocRec.loUseNom);
    loUseCCDep:=WordBoolToBool(ExLocRec.loUseCCDep);
    loUseSupp:=WordBoolToBool(ExLocRec.loUseSupp);
    loUseBinLoc:=WordBoolToBool(ExLocRec.loUseBinLoc);

    loNLineCount := ExLocRec.loNLineCount;
    loUseCPrice := WordBoolToBool(ExLocRec.loUseCPrice);
    loUseRPrice := WordBoolToBool(ExLocRec.loUseRPrice);
    loWOPWIPGL := ExLocRec.loWOPWIPGL;

    {$IFDEF COMTK}
    loReturnGL := ExLocRec.loSalesRetGL;
    loPReturnGL := ExLocRec.loPurchRetGL;
    loUseCPrice := ExLocRec.loUseCPrice;
    loUseRPrice := ExLocRec.loUseRPrice;
    {$ENDIF}

    {* ===== start validation ===== *}

    {* Blank Location Code Check *}

    ValidCheck:=(Not EmptyKey(loCode,MLocLen));

    GenSetError(ValidCheck,30271,Result,ValidHed);

    {* Check Currency *}

    If (ExSyss.MCMode) then
    begin
      //PR 21/09/05 Enterprise has started creating locations with currency set to 0. Set to 1 to
      //avoid error message. (Requested by WJ).
      if loCurrency = 0 then
        loCurrency := 1;
      ValidCheck:=((loCurrency>=1) and (loCurrency<=CurrencyType));

    end
    else
    Begin
      ValidCheck:=BOn;
      loCurrency:=0;
    end;

    GenSetError(ValidCheck,30272,Result,ValidHed);

    {* Check CC/Dep *}
    For Tbo:=BOff to BOn do
    Begin
      {* if location master UseCCDep is On *}
      ValidCheck:=((Not Syss.UseCCDep) or (EmptyKey(loCCDep[Tbo],CCDpLen)));

      If (Not ValidCheck) then
      Begin
        RepBo:=BOff;
        Repeat
          ValidCheck:=((CheckRecExsists(CostCCode+CSubCode[TBo]+loCCDep[TBo],PWrdF,PWK)));
          GenSetError(ValidCheck,CCDepMsg[TBo],Result,ValidHed);

          If (Not ValidCheck) then
              loCCDep[Tbo]:=ExSyss.DefCCDep[Tbo];

          RepBo:=Not RepBo;

        Until (Not RepBo) or (ValidCheck);
      end;
    end;

    {* Nominal Code Check *}

    For n:=1 to NofSNoms do
    Begin

      ValidCheck:=(loNominal[n]=0) and not loUseNom;   {* can be Zero *}

      If (Not ValidCheck) then
      begin
        ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(loNominal[n])),NomF,NomCodeK));
        ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode])); {* B or A *}
      end;

      GenSetError(ValidCheck,30275,Result,ValidHed);

    end;

    {$IFDEF EN570}
     if RetMOn then
     begin
        ValidCheck := (loReturnGL = 0) and not loUseNom;
        if not ValidCheck then
        begin
          ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(loReturnGL)),NomF,NomCodeK));

          ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

          GenSetError(ValidCheck,30276,Result,ValidHed);
        end;

        ValidCheck := (loPReturnGL = 0) and not loUseNom;
        if not ValidCheck then
        begin
          ValidCheck:=(CheckRecExsists(Strip('R',[#0],FullNomKey(loPReturnGL)),NomF,NomCodeK));

          ValidCheck:=((ValidCheck) and (Nom.NomType In [BankNHCode,PLNHCode]));

          GenSetError(ValidCheck,30277,Result,ValidHed);
        end;

     end;
    {$ENDIF 570}

    If (TmpMode<>CheckMode) and (Result=0) then
    Begin
      If (AddMode=B_Insert) then
      Begin
        With MLocCtrl^ do
        begin
          RecPFix:=CostCCode;
          SubType:=CSubCode[BOn];

        end;
        If (Result=0) then
          Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      end
      else
      Begin

        OLocLoc:=MLocCtrl^.MLocLoc;

        KeyS:=CostCCode+CSubCode[BOn]+LJVar(loCode,MLocLen);

        {$IFDEF WIN32}
        begin
          If (GetMultiRec(B_GetEq,B_SingLock,KeyS,MLK,Fnum,SilentLock,GlobLocked)) then
            Result:=0;
          // If not locked and user hits cancel return code 84
          if (Result = 0) and not GlobLocked then
            Result := 84;
        end;
        {$ELSE}
        Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,MLK,Fnum,SilentLock,GlobLocked));
        {$ENDIF}

        MLocCtrl^.MLocLoc:=OLocLoc;

        If (Result=0) and (GlobLocked) then
          Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,MLK);
      end;

    end; {if result=0 ..}
  end; {with ..}
end; {func..}

{* -------------------------------------------------------------------------- *}

{ ===== Store Location Master ===== }

FUNCTION EX_STORELOCATION(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;
Var

   ExLocRec    :  ^TBatchMLocRec;
   KeyS        :  Str255;

Begin
  LasterDesc:='';

  If TestMode Then Begin
    ExLocRec:=P;
    ShowMessage ('Ex_StoreLocation:' + #10#13 +
                 'P^.loCode: ' + ExLocRec^.loCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMLocRec)) then
  Begin
    ExLocRec:=P;
    if StockOn then
      Result:=ExLocToLoc(ExLocRec^,SearchMode,SearchPath)
    else
      Result := NoStockErr;
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(73,Result);

end; {Ex_StoreLocation..}

{* -------------------------------------------------------------------------- *}

Procedure MatchToExMatch(VAR ExMatchRec  :  TBatchMatchRec);

begin
  With PassWord.MatchPayRec do
  begin
    ExMatchRec.DebitRef:=DocCode;
    ExMatchRec.CreditRef:=PayRef;
    ExMatchRec.DebitCr:=MCurrency;
    ExMatchRec.CreditCr:=RCurrency;
    ExMatchRec.DebitVal:=OwnCVal;
    ExMatchRec.CreditVal:=RecOwnCVal;
    ExMatchRec.BaseVal:=SettledVal;
    {$IFDEF EN550CIS}
    ExMatchRec.MatchType := MatchType;
    {$ENDIF}
  end;
end; {Proc..}

{* -------------------------------------------------------------------------- *}

{* Get Matching / Allocation Record *}
FUNCTION EX_GETMATCH(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;

Var
  ExMatchRec :  ^TBatchMatchRec;
  KeyS       :  Str255;
  Locked     :  Boolean;
  LockStr    :  Str255;
Begin
  LastErDesc:='';

  If TestMode Then
  Begin
    ExMatchRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetMatch:' + #10#13 +
                 'P^.Doc. Code: ' + ExMatchRec^.DebitRef + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey: '  + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;

  If (P<>Nil) and (PSize=Sizeof(TBatchMatchRec)) then
  Begin
    KeyS:=MatchTCode+MatchSCode+StrPas(SearchKey);

    ExMatchRec:=P;

    Blank(ExMatchRec^,Sizeof(ExMatchRec^));

    KeyS:= SetKeyString(SearchMode, PwrdF, KeyS);

    UseVariant(F[PwrdF]);
    Result:=Find_Rec(SearchMode,F[PwrdF],PwrdF,RecPtr[PwrdF]^,SearchPath,KeyS);

    KeyStrings[PwrdF] := KeyS;

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[PwrdF]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked));
    {$ENDIF}

    StrPCopy(SearchKey,KeyS);

    If (Result=0) then
      MatchToExMatch(ExMatchRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(75,Result);

end; {Ex_GetMatch Func..}

{* -------------------------------------------------------------------------- *}

Function  ExMatchToMatch(ExMatchRec   :  TBatchMatchRec;
                         SearchMode   :  SmallInt;
                         SearchPath   :  SmallInt)  :  Integer;

Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;
  Fnum2     =  InvF;
  Keypath2  =  InvOurRefK;

var
  OPass    :  TBatchMatchRec;
  n        :  Byte;
  LastACNo :  Str10;
  Rnum     :  Real;

  KeyS     :  Str255;

  bNegative,
  ValidHed,
  ValidCheck,
  LastDocType,
  Locked
           :  Boolean;

  TmpMode  :  SmallInt;
  InvSign, RecSign : SmallInt;

  //PR: 17/08/2012 ABSEXCH-12791
  InvHed : DocTypes;

  KeepSettledVal,
  KeepOwnCVal,
  KeepRecOwnCVal : Double;

  function Sign(const Value : Double) : SmallInt;
  begin
    if Value > 0 then
      Result := 1
    else
    if Value < 0 then
      Result := -1
    else
      Result := 0;
  end;

begin
  KeepSettledVal := 0;
  KeepOwnCVal := 0;
  KeepRecOwnCVal := 0;

  TmpMode:=SearchMode;

  FillChar(PassWord, SizeOf(PassWord),#0);
  FillChar(OPass, SizeOf(OPass),#0);

  With ExMatchRec do
  begin
    {* 23.04.99 Ljvar has been added for VB user, (Cooper)
                though DebitRef is 9, extra 3 character have been assigned in
                DocCode which is String12 *}
    PassWord.MatchPayRec.DocCode:=LJVar(DebitRef,DocLen);  {DebitRef;}
    PassWord.MatchPayRec.PayRef:=LJVar(CreditRef,DocLen);  {CreditRef;}
    PassWord.MatchPayRec.MCurrency:=DebitCr;
    PassWord.MatchPayRec.RCurrency:=CreditCr;
    PassWord.MatchPayRec.OwnCVal:=DebitVal;
    PassWord.MatchPayRec.RecOwnCVal:=CreditVal;
    PassWord.MatchPayRec.SettledVal:=BaseVal;
{$IFDEF EN550CIS}
    if MatchType in ['0'..'4', 'A', 'C'] then
      PassWord.MatchPayRec.MatchType:=MatchType
    else
      PassWord.MatchPayRec.MatchType:='A';
    if MatchType in UserMatchSet then
      PassWord.MatchPayRec.AltRef := CustomRef;
{$ELSE}
    PassWord.MatchPayRec.MatchType:='A';
{$ENDIF}
    PassWord.RecPFix:=MatchTCode;
    if MatchType in UserMatchSet then
      PassWord.SubType:=MatchType
    else
      PassWord.SubType := MatchSCode;

    //PR: 25/06/2014 ABSEXCH-14912 Need to store values from Custom Matching, as they are lost in
    //                             the validation
    if MatchType in UserMatchSet then
    begin
      KeepSettledVal := BaseVal;
      KeepOwnCVal := DebitVal;
      KeepRecOwnCVal := CreditVal;
    end;
  end;

  {* Start Validation *}

  ValidHed:=BOn;
  ValidCheck:=BOff;
  KeyS:='';
  LastAcNo:='';
  LastDocType:=BOff;
  Result:=0;

  With PassWord.MatchPayRec do
  Begin

    {* Check first document exists *}
    //VA 28/05/2018 2018-R1.1 ABSEXCH-15414: Caching in the SQL edition is causing a problem when adding two matching records for the same transaction.
    KeyS := DocCode;
    ValidCheck := (Find_Rec(B_GetEq, F[Fnum2], Fnum2, RecPtr[Fnum2]^, KeyPath2, KeyS) = 0);
    //ValidCheck:=(CheckRecExsists(Trim(DocCode),Fnum2,KeyPath2));
    GenSetError(ValidCheck,30001,Result,ValidHed); {Unable to locate this document.}

    If (ValidHed) then
    Begin

      {* Check document type valid, and being allocated the right way round *}

    {$IFDEF EN550CIS}
     if not (MatchType in UserMatchSet) then
     begin
    {$ENDIF}
      LastAcNo:=Inv.CustCode;

      LastDocType:=(Inv.InvDocHed In SalesSplit);

      ValidCheck:=(((Inv.RemitNo<>'') or (Round_Up(Inv.Settled,2)=0)) and (Inv.InvDocHed In DocAllocSet));

      GenSetError(ValidCheck,30002,Result,ValidHed); {'This document is being allocated incorrectly.'}

      {* Check matching currency is same as document *}

      ValidCheck:=(MCurrency=Inv.Currency);

      GenSetError(ValidCheck,30003,Result,ValidHed);

      //PR: 17/08/2012 ABSEXCH-12791 Added DocCnst here to ensure that settled amount is correct for SCR/PCR
      Inv.Settled:=Inv.Settled+(SettledVal*DocCnst[Inv.InvDocHed]*DocNotCnst);
      Inv.CurrSettled:=Inv.CurrSettled+(OwnCVal*DocCnst[Inv.InvDocHed]*DocNotCnst);

      //PR: 21/07/2011 Changed to validate on Base Amount rather than currency amount, as Base includes
      // PostDiscAm (Settlement discount on SRC/PPY) ABSEXCH-11641
//      Rnum:=CurrencyOS(Inv,BOn,BOff,BOff)*DocCnst[Inv.InvDocHed]*DocNotCnst;
      //PR: 17/08/2012 ABSEXCH-12791 Added missing DocCnst as it was failing on part allocations. (Worked on
      //full allocations because Rnum would be 0.
      Rnum:=Round_Up(BaseTotalOS(Inv), 2) * DocCnst[Inv.InvDocHed] * DocNotCnst;

      {* Check for over settlement *}
      //PR: 17/08/2012 ABSEXCH-12791 InvSign no longer needed
//      InvSign := Sign(ITotal(Inv)) * DocCnst[Inv.InvDocHed];
      bNegative := ITotal(Inv) < 0;
      ValidCheck := ((Rnum >= 0) and (not bNegative)) or ((Rnum <= 0) and (bNegative));
      GenSetError(ValidCheck,30004,Result,ValidHed); {}


      {$IFDEF EN550CIS}
     end;
      {$ENDIF}

      {* Check Credit document exists *}

      //VA 28/05/2018 2018-R1.1 ABSEXCH-15414: Caching in the SQL edition is causing a problem when adding two matching records for the same transaction.
      KeyS := PayRef;
      ValidCheck := (Find_Rec(B_GetEq, F[Fnum2], Fnum2, RecPtr[Fnum2]^, KeyPath2, KeyS) = 0);
     // ValidCheck:=(CheckRecExsists(PayRef,Fnum2,KeyPath2));
      GenSetError(ValidCheck,30005,Result,ValidHed); {Unable to locate this document.}


    {$IFDEF EN550CIS}
     if not (MatchType in UserMatchSet) then
     begin
    {$ENDIF}
      If (ValidHed) then
      Begin

        {* Check both docs belong to same account number *}

        ValidCheck:=(LastAcNo=Inv.CustCode);

        GenSetError(ValidCheck,30006,Result,ValidHed);

        {* Check both docs belong to same Doc Type number *}

        ValidCheck:=(LastDocType=(Inv.InvDocHed In SalesSplit));

        GenSetError(ValidCheck,30007,Result,ValidHed);

        {* Check document type valid, and being allocated the right way round *}

        ValidCheck:=((Inv.RemitNo='') and (Inv.InvDocHed In DocAllocSet));

        GenSetError(ValidCheck,30008,Result,ValidHed);

        {* Check matching currency is same as document *}

        ValidCheck:=(RCurrency=Inv.Currency);

        GenSetError(ValidCheck,30009,Result,ValidHed);

        Inv.Settled:=Inv.Settled+(SettledVal*DocCnst[Inv.InvDocHed]*DocNotCnst);

        Inv.CurrSettled:=Inv.CurrSettled+(RecOwnCVal*DocCnst[Inv.InvDocHed]*DocNotCnst);

        //PR: 21/07/2011 Changed to validate on Base Amount rather than currency amount, as Base includes
        // PostDiscAm (Settlement discount on SRC/PPY) ABSEXCH-11641
//        Rnum:=CurrencyOS(Inv,BOn,BOff,BOff)*DocCnst[Inv.InvDocHed]*DocNotCnst;
        Rnum:=Round_Up(BaseTotalOS(Inv), 2) *DocCnst[Inv.InvDocHed]*DocNotCnst;

        //PR: 17/08/2012 ABSEXCH-12791 This check was preventing credit notes being allocated against PPYs/SRCs
        //and isn't needed as document oversettled is checked above.
        {* Check for over settlement *}
{        RecSign := Sign(ITotal(Inv)) * DocCnst[Inv.InvDocHed];
        ValidCheck := (InvSign + RecSign = 0);
        GenSetError(ValidCheck, 30004, Result, ValidHed);}

        bNegative := ITotal(Inv) < 0;
        ValidCheck := ((Rnum >= 0) and (not bNegative)) or ((Rnum <= 0) and (bNegative));
//        ValidCheck := (Rnum >= 0);
        {$IFDEF COMTK}
        if not ExMatchRec.AllowOversettling then
        {$ENDIF}
        GenSetError(ValidCheck,30010,Result,ValidHed);

      end;
     {$IFDEF EN550CIS}
     end;
     {$ENDIF}
    end;


    If (ValidHed) then
    Begin

     if not (MatchType in UserMatchSet) then
     begin
      Locked:=BOff;

      KeyS:=DocCode;

      {$IFDEF WIN32}
      begin
        If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked));
      {$ENDIF}
     end
     else
       Locked := True; //Locked wasn't being initialized for custom matching

      If (SearchMode<>CheckMode) and (Result=0) and (Locked) then
      With Inv do
      Begin
        //PR: 17/08/2012 ABSEXCH-12791 Keep record of document type, so we can use it to get the
        //sign right for payment settled amount below.
       InvHed := InvDocHed;
       if not (MatchType in UserMatchSet) then
       begin
        ValidCheck:=(CurrencyOS(Inv,BOn,BOff,BOff)=0); {* Check was allocated *}

        //PR: 17/08/2012 ABSEXCH-12791 Added DocCnst here to ensure that settled amount is correct for SCR/PCR
        //PR: 17/10/2012 Store changed values so we can set them in the matching record before storing it.
        KeepSettledVal := SettledVal*DocCnst[Inv.InvDocHed]*DocNotCnst;
        KeepOwnCVal := OwnCVal*DocCnst[Inv.InvDocHed]*DocNotCnst;
        Settled:=Settled+KeepSettledVal;
        CurrSettled:=CurrSettled+KeepOwnCVal;



        RemitNo:=PayRef;

        If (CurrencyOS(Inv,BOn,BOff,BOff)=0) and (Not ValidCheck) then {* Now fully allocated *}
        Begin

          If (ExSyss.MCMode) and (CXRate[BOff]=0) then
            CXrate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];

          AllocStat:=#0;

        end
        else
          If (CurrencyOS(Inv,BOn,BOff,BOff)<>0) and (ValidCheck) then
          Begin
            If (ExSyss.MCMode) and (Not UseCoDayRate) then
              CXrate[BOff]:=0;

            AllocStat:=CustSupp;

          end;

        //PR 21/07/06 - vatpostdate wasn't being set
        If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* ENv4.22 Cash Accounting set VATdate to Current VAT Period *}
        Begin

          VATPostDate:=SyssVAT.VATRates.CurrPeriod;
        end;


        {* 01.09.99 - Added confirmed by EL *}
        Set_DocAlcStat(Inv);
        Result:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);
       end;

        If (Result=0) then
        Begin

          if not (MatchType in UserMatchSet) then
            AltRef:=YourRef;


          if not (MatchType in UserMatchSet) then
          begin
             KeyS:=PayRef;

            {$IFDEF WIN32}
            begin
              If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked)) then
                Result:=0;
              // If not locked and user hits cancel return code 84
              if (Result = 0) and not Locked then
                Result := 84;
            end;
            {$ELSE}
            Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked));
            {$ENDIF}

            If (Result=0) and (Locked) then
            With Inv do
            Begin

              ValidCheck:=(CurrencyOS(Inv,BOn,BOff,BOff)=0); {* Check was allocated *}

              //PR: 17/08/2012 ABSEXCH-12791 Changed DocNotCnst to DocCnst of document (not payment) type
              //to ensure that settled amount is correct for SCR/PCR

              //PR: 21/07/2014 ABSEXCH-15432 Above fix was incomplete - need both DocNotCnst and DocCnst[] to get correct
              //                             sign for SIN-SRC, but remove DocNotCnst for SCR/SRC
              if DocCnst[InvHed] <> DocCnst[Inv.InvDocHed] then
              begin
                Settled:=Settled+(SettledVal*DocCnst[Inv.InvDocHed]*DocNotCnst);

                CurrSettled:=CurrSettled+(RecOwnCVal*DocCnst[Inv.InvDocHed]*DocNotCnst);
              end
              else
              begin // SCR/SJC - SRC; PCR/PJC - PPY
                Settled:=Settled+(SettledVal*DocCnst[Inv.InvDocHed]);

                CurrSettled:=CurrSettled+(RecOwnCVal*DocCnst[Inv.InvDocHed]);
              end;

              RemitNo:='';

              If (CurrencyOS(Inv,BOn,BOff,BOff)=0) and (Not ValidCheck) then {* Now fully allocated *}
              Begin

                If (ExSyss.MCMode) and (CXRate[BOff]=0) then
                  CXrate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];

                AllocStat:=#0;

              end
              else
                If (CurrencyOS(Inv,BOn,BOff,BOff)<>0) and (ValidCheck) then
                Begin
                  If (ExSyss.MCMode) and (Not UseCoDayRate) then
                    CXrate[BOff]:=0;

                  AllocStat:=CustSupp;

                end;

              {* 01.09.99 - Added confirmed by EL *}
              Set_DocAlcStat(Inv);
              Result:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);

          end; {With..& Locked..}
          end;

          //Set final match values and store
          SettledVal := KeepSettledVal;
          OwnCVal    := KeepOwnCVal;

          //PR: 25/06/2014 ABSEXCH-14912 Re-instate stored Custom Matching value
          if MatchType in UserMatchSet then
            RecOwnCVal := KeepRecOwnCVal;

          Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);


        end; {If Doc stored ok..}

      end;

    end;

  end; {With..}

  ExMatchToMatch:=Result;

end; {proc..}

{* -------------------------------------------------------------------------- *}

{* Store Match Record *}
FUNCTION EX_STOREMATCH(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Var

   ExMatchRec  :  ^TBatchMatchRec;
   KeyS        :  Str255;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExMatchRec:=P;
    ShowMessage ('Ex_StoreMatch:' + #10#13 +
                 'P^.DebitRef: ' + ExMatchRec^.DebitRef + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMatchRec)) then
  Begin
    ExMatchRec:=P;
    Result:=ExMatchToMatch(ExMatchRec^,SearchMode,SearchPath);
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(76,Result);

end; {Ex_StoreMatch Func..}

{* -------------------------------------------------------------------------- *}
FUNCTION EX_DELETEMATCH(P            :  POINTER;
                        PSIZE        :  LONGINT)  :  SMALLINT;
var
  RecordCorrect : Boolean;
  ExMatchRec  :  ^TBatchMatchRec;
begin
  {$IFDEF EN550CIS}
  LastErDesc:='';

  If TestMode Then Begin
    ExMatchRec:=P;
    ShowMessage ('Ex_StoreMatch:' + #10#13 +
                 'P^.DebitRef: ' + ExMatchRec^.DebitRef + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13);
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMatchRec)) then
  Begin
    ExMatchRec:=P;

    if ExMatchRec.MatchType in UserMatchSet then
      Result := 0
    else
      Result := 30000;

    if Result = 0 then
    begin
      RecordCorrect := (PassWord.RecPFix = MatchTCode) and (PassWord.SubType = MatchSCode) and
                       (Trim(PassWord.MatchPayRec.DocCode) = Trim(ExMatchRec.DebitRef)) and
                       (Trim(PassWord.MatchPayRec.PayRef) = Trim(ExMatchRec.CreditRef)) and
                       (PassWord.MatchPayRec.MCurrency = ExMatchRec.DebitCr) and
                       (PassWord.MatchPayRec.RCurrency = ExMatchRec.CreditCr) and
                       (PassWord.MatchPayRec.OwnCVal = ExMatchRec.DebitVal) and
                       (PassWord.MatchPayRec.RecOwnCVal = ExMatchRec.CreditVal) and
                       (PassWord.MatchPayRec.SettledVal = ExMatchRec.BaseVal);

      if not RecordCorrect then Result := 30001;
    end;

    if Result = 0 then
      Result := Delete_Rec(F[PWrdF], PWrdF, PWK);
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(170,Result);
{$ELSE}
  Result := -23;
{$ENDIF}

end;
{* -------------------------------------------------------------------------- *}


{ ===== Function to return note owner based on NSubCode ==== }

Function RetNoteSort(NSub  :  Str5)  :  Char;

Var
  TmpStr  :  Char;

Begin
  TmpStr:=NdxWeight;

  If (NSub='ACC') then
    TmpStr:=NoteCCode
  else
  If (NSub='DOC') then
    TmpStr:=NoteDCode
  else
  If (NSub='STK') then
    TmpStr:=NoteSCode
  else
  if (NSub='JOB') then
    TmpStr:=NoteJCode
  else
  if NSub = 'ALT' then
    TmpStr := NotesdbCode
  else
  if NSub = 'EMP' then
    TmpStr := NoteECode
  else
  if NSub = 'SER' then
    TmpStr := NoteRCode
  else
  if NSub = 'LOC' then
    TmpStr := NoteLCode
  // MH 15/12/2008: Added CC/Dept support
  Else If (Trim(NSub) = 'CC') then
    TmpStr := NoteDP2Code
  Else If (Trim(NSub) = 'DP') then
    TmpStr := NoteDP1Code;

  RetNoteSort:=TmpStr;

end;

{* -------------------------------------------------------------------------- *}

Function FullNCode(CCode  :  Str10) : Str10;
begin
  FullNCode:=LJVar(CCode,AccLen);
end;

{* -------------------------------------------------------------------------- *}

Function FullRNoteKey(CCode  :  Str10;
                      NT     :  Char;
                      LineNo :  LongInt)  :  Str20;
Begin
  FullRNoteKey:=FullNCode(CCode)+NT+Dec2Hex(LineNo);
end;

{* -------------------------------------------------------------------------- *}

{ ============ Key Building routines =========== }

Function PartNoteKey(RC,ST  :  Char;
                     CCode  :  Str20)  :  Str30;
Begin
  PartNoteKey:=RC+ST+CCode;
end; {Func..}

{* -------------------------------------------------------------------------- *}

Function PartGNoteKey(RC,ST,NT  :  Char;
                      CCode     :  Str10)  :  Str30;
Begin
  PartGNoteKey:=PartNoteKey(RC,ST,FullNCode(CCode))+NT;
end;

{ ---------------------------------------------------------------------------- }

Function  ExtNoteToExNote(ExNoteRec    :  TBatchNotesRec;
                          SearchMode   :  SmallInt;
                          SearchPath   :  SmallInt)  :  Integer;

Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;
  CondYN    :  Array[BOff..BOn] of Char = ('N','Y');

Var
  ValidHed,
  ValidCheck,
  Locked
                :  Boolean;
  KeyS          :  Str255;
  n             :  Byte;
  Ty,Tm,Td      :  Word;
  FFnum,
  FKeypath      :  Integer;
  Rnum          :  Real;
  TmpPWrd       :  PassWordRec;
  TmpMode       :  SmallInt;
  SnoKey        :  Str255;
  cSubType      :  Char;

Begin
  FFNum := 0;
  FKeyPath := 0;

  TmpMode:=SearchMode;

  Result:=0;
  ValidHed:=BOn; ValidCheck:=BOff; KeyS:='';

  FillChar(PassWord, SizeOf(PassWord),#0);
  FillChar(TmpPWrd, SizeOf(TmpPWrd),#0);

  With ExNoteRec do
  begin
  (*
    If (ExSyss.OverWNPad) then
      PassWord.RecPFix:=NoteTmpCode    {* "~" *}
    else
      PassWord.RecPFix:=NoteTCode;     {* "N" *}
  *)

    PassWord.RecPFix:=NoteTCode;                  {* "N" *}
    PassWord.SubType:=RetNoteSort(NoteSort);      {* ACC=A  DOC=D  STK=S JOB=J*}
    cSubType := Password.SubType;
    PassWord.NotesRec.NoteDate:=NoteDate;
    PassWord.NotesRec.NoteAlarm:=AlarmDate;
    PassWord.NotesRec.ShowDate:=(AlarmSet=CondYN[BOn]);
    PassWord.NotesRec.NType:=NoteType;
    PassWord.NotesRec.TmpImpCode:=NoteCode;
    {$IFDEF COMTK}
    if Password.SubType in [NoteRCode, NotesdbCode] then
    begin
      SnoKey := KeyStr;
      Password.NotesRec.NoteFolio := FullNomKey(NFolio);
    end;
    {$ENDIF}
    PassWord.NotesRec.LineNo:=LineNo;
    PassWord.NotesRec.NoteLine:=NoteLine;
    PassWord.NotesRec.NoteUser:=User;
    { 13.10.2000 }
    PassWord.NotesRec.RepeatNo:=RepeatDays;
    PassWord.NotesRec.NoteFor:=NoteFor;

  end;


  With PassWord.NotesRec do
  Begin

    {* Check Note Sort is valid  (A,D,S, or J *}

    With PassWord do
      ValidCheck:=SubType in [NoteCCode, NoteDCode, NoteSCode,
                              NoteJCode{$IFDEF COMTK}, NoteRCode, NoteECode, NotesdbCode, NoteLCode{$ENDIF}, NoteDP1Code,NoteDP2Code];

    GenSetError(ValidCheck,30001,Result,ValidHed); {* Invalid Note Sort *}

    {* Check Note Type is valid *}

    ValidCheck:=((NType=NoteCDCode) or (NType=NoteCGCode));  {'2' / '1'}

    GenSetError(ValidCheck,30002,Result,ValidHed); {* Invalid Note Type *}

    {* Check if parent exists *}

    With PassWord do
    Begin
      Case SubType of
        NoteCCode  :  Begin
                        FFnum:=CustF;
                        FKeyPath:=CustCodeK;
                        TmpImpCode:=FullCustCode(TmpImpCode);
                      end;
        NoteDCode  :  Begin
                        FFnum:=InvF;
                        FKeyPath:=InvOurRefK;
                        TmpImpCode:=LJVar(TmpImpCode,DocLen);
                      end;
        NoteSCode  :  Begin
                        FFnum:=StockF;
                        FKeyPath:=StkCodeK;
                        TmpImpCode:=LJVar(TmpImpCode,StkLen);
                      end;
        NoteJCode  :  Begin
                        FFnum:=JobF;
                        FKeyPath:=JobCodeK;
                        TmpImpCode:=LJVar(TmpImpCode,10);
                      end;
        NoteDP2Code,         // CC
        NoteDP1Code:  Begin // Dept
                        FFnum:=PwrdF;
                        FKeyPath:=PWK;
                        TmpImpCode := CostCCode + CSubCode[SubType = NoteDP2Code] + LJVar(UpCaseStr(TmpImpCode),CCDpLen);
                      end;
        {$IFDEF COMTK}
        NoteRCode  :  Begin
                        FFnum:=MiscF;
                        if ExNoteRec.SnoType = 0 then
                        begin
                          FKeyPath:=0;
                          SnoKey:=LJVar(SnoKey,26);
                        end
                        else
                        begin //Batch
                          FKeyPath:=2;
                          SnoKey:=LJVar(SnoKey,12);
                        end;
                      end;
         NoteECode :  begin
                        FFNum := JMiscF;
                        FKeyPath := 0;
                        TmpImpCode := JARCode + JAECode + LJVar(UpperCase(TmpImpCode), 6);
                      end;
         NotesdbCode: begin
                        FFNum := MLocF;
                        FKeyPath := 1;
                      end;
         NoteLCode  : begin
                        FFNum := MLocF;
                        FKeyPath := 0;
                        TmpImpCode := CostCCode + CSubCode[True] + LJVar(TmpImpCode, MLocKeyLen);
                      end;
        {$ENDIF}
      end; {Case..}


      {08.03.01 - Added (Result=0) condition, otherwise, gets Range Check error
       if the user does not assign Note Type (Subtype), FFNum was not assigned
       in the above Case, that causing range check error while using the below
       CheckRecExists. }

      if cSubType in [NoteDP1Code,NoteDP2Code] then
        TmpPWrd:=PassWord; //PR 17/12/2008 Store and restore Password rec, as CCDept records are in same file as notes.

      ValidCheck:=(Result=0) and (CheckRecExsists(TmpImpCode,FFnum,FKeyPath));

      if cSubType in [NoteDP1Code,NoteDP2Code] then
      begin
        if ValidCheck then
          TmpPWrd.NotesRec.NoteFolio := FullNCode(Password.CostCtrRec.PCostC); //Get CCDept code here before restoring NotesRec
        PassWord:=TmpPWrd;
      end;

    {$IFDEF COMTK}
      if Password.SubType in [NoteRCode, NotesdbCode] then
        ValidCheck:=(Result=0) and (CheckRecExsists(SnoKey,FFnum,FKeyPath));
    {$ENDIF}


      GenSetError(ValidCheck,30003,Result,ValidHed); {* 'Unable to locate the parent for this note.' *}

      If (ValidCheck) then
        Case SubType of

          NoteCCode  :  NoteFolio:=Cust.CustCode;

          NoteDCode  :  NoteFolio:=FullNomKey(Inv.FolioNum);

          NoteSCode  :  NoteFolio:=FullNomKey(Stock.StockFolio);

          NoteJCode  :  NoteFolio:=FullNomKey(JobRec^.JobFolio);

          NoteECode  :  NoteFolio := FullNCode(JobMisc^.EmplRec.EmpCode);

//          NoteRCode  :  NoteFolio := FullNomKey(MiscRecs.SerialRec.NoteFolio);
          NotesdbCode : NoteFolio := FullNomKey(MLocCtrl.SdbStkRec.sdFolio);

          NoteLCode : NoteFolio := MLocCtrl.MLocLoc.loCode;

        end; {Case..}

    end; {Check note parent..}

    NoteFolio:=FullNCode(NoteFolio);

    {* Check Note LineNo is valid *}

    ValidCheck:=(LineNo>0);

    GenSetError(ValidCheck,30004,Result,ValidHed); {* Invalid Line Number. Must be > 0 *}

    {* Check Note Date *}

    If (NoteDate<>'') then
    Begin
      DateStr(NoteDate,Td,Tm,Ty);

      ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

      GenSetError(ValidCheck,30005,Result,ValidHed); {* Invalid Note Date. Will be override with Today Date *}

      If (Not ValidCheck) then
        NoteDate:=ToDay;
    end;

    {* Check Alarm Date *}

    If (NoteAlarm<>'') then
    Begin

      DateStr(NoteAlarm,Td,Tm,Ty);

      ValidCheck:=((Td In [1..31]) and (Tm In [1..12]) and (Ty<>0));

      GenSetError(ValidCheck,30006,Result,ValidHed); {* Invalid Alarm Date. Will be override with Today Date *}

      If (Not ValidCheck) then
        NoteAlarm:=Today;
    end;

    { 16.10.2000 - NoteFor validation }

    ValidCheck:=(Trim(NoteFor)='');

    If (Not ValidCheck) then
    begin

      NoteFor:=UpperCase(Ljvar(NoteFor,LoginKeyLen));

      KeyS:=FullPWordKey(PassUCode,C0,NoteFor);  {RecPFix, SubType, UserName}

      TmpPWrd:=PassWord;

      //Using find_rec was losing position in the file (and consequently overwriting the user!}
//      Status:=Find_Rec(B_GetEq,F[PWrdF],PWrdF,RecPtr[PWrdF]^,PWK,KeyS);

      if CheckRecExsists(KeyS, PWrdF, PWK) then
        Status := 0
      else
        Status := 4;


      With Password.PassEntryRec do
        ValidCheck:=(Status=0) and (CheckKey(TmpPWrd.NotesRec.NoteFor,LogIn,Length(LogIn),BOn));

      PassWord:=TmpPWrd;

      GenSetError(ValidCheck,30007,Result,ValidHed);


    end; { if..}

    If ((TmpMode<>CheckMode) and (Result=0)) then
    Begin

      NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo); {* Note Index Key *}

      {* 28.06.2000 - EL advised to add ShowDate *}
      ShowDate:=(NType=NoteCDCode) and (NoteDate<>'');

      If (ExSyss.OverWNPad) then {* Delete any existing note lines b4 storing *}
      Begin
        {ChangeNotes:=BOn;}

        TmpPWrd:=PassWord;

        With PassWord do
          KeyS:=NoteTCode+SubType+NoteFolio;

        DeleteLinks(KeyS,Fnum,Length(KeyS),Keypath,BOff);

        PassWord:=TmpPWrd;

      end;

      If (SearchMode=B_Update) then
        Result:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth)
      else
        Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

      If (Result=0) then
      Begin
        if Password.SubType = NoteRCode then
        begin
          KeyS := SnoKey;

          Result:=Find_Rec(B_GetGEq,F[FFnum],FFnum,RecPtr[FFnum]^,FKeyPath,KeyS);

          while (Result = 0) and (CheckKey(KeyS, SnoKey, Length(SnoKey), True))
                             and (FullNCode(FullNomKey(MiscRecs.SerialRec.NoteFolio)) <> Password.NotesRec.NoteFolio) do
          begin
            Result:=Find_Rec(B_GetNext,F[FFnum],FFnum,RecPtr[FFnum]^,FKeyPath,KeyS);
          end;
          if not (CheckKey(KeyS, SnoKey, Length(SnoKey), True)) then
            Result := 4;
        end
        else
        begin
          if Password.SubType = NotesdbCode then
            KeyS := SnoKey
          else
            KeyS:=TmpImpCode;

          Result:=Find_Rec(B_GetEq,F[FFnum],FFnum,RecPtr[FFnum]^,FKeyPath,KeyS);
        end;

        If Result=0 then {* Attempt to lock record after we have found it *}
        {$IFDEF WIN32}
        begin
          If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,FKeyPath,FFnum,BOn,Locked)) then
            Result:=0;
          // If not locked and user hits cancel return code 84
          if (Result = 0) and not Locked then
            Result := 84;
        end;
        {$ELSE}
        Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,FKeyPath,FFnum,BOn,Locked));
        {$ENDIF}

        {* Added on 02.05.98 to update Notes Lines Count in Master File *}
        If (Result=0) and (Locked) then
        With Password,NotesRec do
        Begin

          Case SubType of
            NoteCCode  :  With Cust do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
            NoteDCode  :  With Inv do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
							//HV 14/06/2016 2016-R3 ABSEXCH-13283: When importing transaction notes using the Importer, the status on the transaction is not updating to show a note exists 
                            If (HoldFlg = 0) then
                              HoldFlg := 32; // For Updating transaction status by "Notes""
                          end;
            NoteSCode  :  With Stock do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
            NoteJCode  :  With JobRec^ do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
            NoteRCode  :  With MiscRecs.SerialRec do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
            NoteECode  :  with JobMisc^.EmplRec do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
            NotesdbCode:  with MLocCtrl.SdbStkRec do
                          begin
                            If (LineNo>sdNLineCount) then
                              sdNLineCount:=LineNo+1;
                          end;

            NoteDP2Code,  // CC
            NoteDP1Code:  // Dept
                          with Password.CostCtrRec do
                          Begin
                            If (LineNo>NLineCount) then
                              NLineCount:=LineNo+1;
                          end;
          end; {Case..}

          Result:=Put_Rec(F[FFnum],FFnum,RecPtr[FFnum]^,FKeyPAth);

        end;
      end;
    end;

  end; {With..}

  ExtNoteToExNote:=Result;

end; {Proc..}

{* -------------------------------------------------------------------------- *}

{* Store Notes Record *}

FUNCTION EX_STORENOTES(P            :  POINTER;
                       PSIZE        :  LONGINT;
                       SEARCHPATH   :  SMALLINT;
                       SEARCHMODE   :  SMALLINT)  :  SMALLINT;
Var
   ExNoteRec   :  ^TBatchNotesRec;
   KeyS        :  Str255;

Begin
  LastErDesc:='';
  If TestMode Then Begin
    ExNoteRec:=P;
    ShowMessage ('Ex_StoreNotes:' + #10#13 +
                 'P^.NoteCode: ' + ExNoteRec^.NoteCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchNotesRec)) then
  Begin
    ExNoteRec:=P;
    Result:=ExtNoteToExNote(ExNoteRec^,SearchMode,SearchPath);
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(78,Result);

end; {Ex_StoreNotes Func..}

{* -------------------------------------------------------------------------- *}
{ ========= Get Notes ============== }

Procedure CopyExNotesToTKNotes(Const ExchNotes : NotesType; Var ExNotesRec  :  TBatchNotesRec);

Const
  CondYN : Array[BOff..BOn] of Char = ('N','Y');

begin

  With ExchNotes do
  begin
{    ExNotesRec.NoteCode:=NoteFolio;}
    ExNotesRec.NoteDate:=NoteDate;
    ExNotesRec.AlarmDate:=NoteAlarm;
    ExNotesRec.AlarmSet:=CondYN[ShowDate];
    ExNotesRec.LineNo:=LineNo;
    ExNotesRec.User:=NoteUser;
    ExNotesRec.NoteLine:=NoteLine;
    {13.10.2000 }
    ExNotesRec.RepeatDays:=RepeatNo;
    ExNotesRec.NoteFor:=NoteFor;
  end;

end; {ExNotesToExtNotes Proc..}

Procedure ExNotesToExtNotes(Var ExNotesRec : TBatchNotesRec);
begin
  CopyExNotesToTKNotes(PassWord.NotesRec, ExNotesRec);
end;

{* -------------------------------------------------------------------------- *}

FUNCTION EX_GETNOTES(P            :  POINTER;
                     PSIZE        :  LONGINT;
                     SEARCHKEY    :  PCHAR;
                     SEARCHPATH   :  SMALLINT;
                     SEARCHMODE   :  SMALLINT;
                     LOCK         :  WORDBOOL)  :  SMALLINT;

Var
  ExNotesRec :  ^TBatchNotesRec;

  TmpStr,
  KeyS       :  Str255;

  ValidHed,
  ValidCheck,
  Locked     :  Boolean;

  TmpPC,
  LockStr    :  Str20;

  TmpNoteType,
  TmpNoteSort:  Char;

  R1,
  FFnum,
  FKeyPath   :  Integer;

  RecAddr    : LongInt;

Begin
  FFNum := 0;
  FKeyPath := 0;
  
  LastErDesc:='';

  If TestMode Then
  Begin
    ExNotesRec:=P;
    If WordBoolToBool(Lock) Then LockStr := 'True' Else LockStr := 'False';
    ShowMessage ('Ex_GetNotes:' + #10#13 +
                 'P^.NoteSort: ' + ExNotesRec^.NoteSort + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchKey : ' + StrPas(SearchKey) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
                 'Lock: '       + LockStr);
  End; { If }

  Result:=32767;
  Locked:=BOff;
  SearchPath:=0;  {PMK}
  ValidCheck:=BOff;
  ValidHed:=BOn;
  R1:=0;
  ExNotesRec:=P;

  If (P<>Nil) and (PSize=Sizeof(TBatchNotesRec)) then
  Begin

    TmpNoteType:=#0;
    TmpNoteSort:=#0;

    TmpStr:=StrPas(SearchKey);             {* AccountCode/StockCode/OurRef *}

    With ExNotesRec^ do
    begin
      TmpNoteType:=NoteType;               {* 1/2 - General/DatedNotes *}
      TmpNoteSort:=RetNoteSort(NoteSort);  {* ACC/STK/DOC *}
    end;

    //PR: 07/11/2011 v6.9 Check to avoid including Audit Notes.
    ValidCheck := TmpNoteType in ['1', '2'];
    GenSetError(ValidCheck,30003,R1,ValidHed);
    Result := R1;

    if ValidCheck then
    begin

      Case TmpNoteSort of

        NoteDCode  :  Begin
                        FFnum:=InvF;
                        FKeyPath:=InvOurRefK;
                        TmpStr:=LJVar(TmpStr,DocLen);
                      end;
        NoteSCode  :  Begin
                        FFnum:=StockF;
                        FKeyPath:=StkCodeK;
                        TmpStr:=LJVar(TmpStr,StkLen);
                      end;
        NoteCCode  :  Begin
                        FFnum:=CustF;
                        FKeyPath:=CustCodeK;
                        TmpStr:=FullCustCode(TmpStr);
                      end;
        NoteJCode  : Begin
                       FFnum:=JobF;
                       FKeyPath:=JobCodeK;
                       TmpStr:=FullJobCode(TmpStr);
                     end;
      end; {case..}

      TmpPC:=TmpStr;

      ValidCheck:=(CheckRecExsists(TmpStr,FFnum,FKeyPath));

      GenSetError(ValidCheck,30001,R1,ValidHed); {* 'Unable to locate the parent for this note.' *}
      Result:=R1;

      If (ValidCheck) then
        Case TmpNoteSort of

          NoteCCode  :  TmpStr:=Cust.CustCode;

          NoteDCode  :  TmpStr:=FullNomKey(Inv.FolioNum);

          NoteSCode  :  TmpStr:=FullNomKey(Stock.StockFolio);

          NoteJCode  :  TmpStr:=FullNomKey(JobRec^.JobFolio);

        end; {Case..}

      KeyS:=PartGNoteKey(NoteTCode,TmpNoteSort,TmpNoteType,TmpStr);

      {Blank(ExNotesRec^,Sizeof(ExNotesRec^));}
      KeyS:= SetKeyString(SearchMode, PWrdF, KeyS);

      UseVariant(F[PWrdF]);
      Result:=Find_Rec(SearchMode,F[PWrdF],PWrdF,RecPtr[PWrdF]^,SearchPath,KeyS);

      If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
      {$IFDEF WIN32}
      begin
        UseVariant(F[PWrdF]);
        If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,PWrdF,SilentLock,Locked));
      {$ENDIF}

      StrPCopy(SearchKey,TmpPC);

      KeyStrings[PWrdF] := KeyS;

      If (Result=0) then
      begin
        With PassWord.NotesRec do
          ValidCheck:=((NType=TmpNoteType) and (CheckKey(TmpStr,NoteFolio,Length(TmpStr),BOff)));

        GenSetError(ValidCheck,30002,R1,ValidHed);  {* No Notes *}
        Result:=R1;

        if Result = 0 then
        begin
          If (ValidCheck) then
            ExNotesToExtNotes(ExNotesRec^);  {* Assign into Notes Lines *}
        end
        else
        begin
          Ex_GetRecordAddress(PwrdF, RecAddr);
          Ex_UnlockRecord(PwrdF, RecAddr);
        end;
      end; //result = 0
    end; //if ValidCheck (NoteType in ['1','2']
  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(77,Result);

end; {Ex_GetNotes Func..}

{* -------------------------------------------------------------------------- *}
{* ------ To get Stock Price by Customer/Supplier, Currency and Quentity ------ *}

Function GetPrice(Var ExStkPrRec  :  TBatchStkPriceRec)  :  Integer;
var
  PrVal,
  TQty,
  DiscR       :  Real;
  DiscCh      :  Char;
  LCode       :  Str10;
  FoundOk,
  ValidHed,
  ValidCheck  :  Boolean;

begin
  PrVal:=0;
  ValidHed:=BOn;
  FoundOk:=BOn;
  Result:=0;
  LCode:='';

  // HM 28/02/01: Initialised Discount as was being initialised to 1.55E+33
  // which was really screwing things up when used for a POR, but was OK for
  // an SOR!
  DiscR := 0.00;

  // HM 13/03/01: Added following initialisations as they were being created with crap values
  DiscCh := #0;
  TQty := 0.00;

  With ExStkPrRec do
  begin

    {* Check Stock Code *}
    StockCode:=LJVar(UpCaseStr(StockCode),StkLen)+#0+#0+#0+#0;

    ValidCheck:=CheckRecExsists(StockCode,StockF,StkCodeK);


    GenSetError(ValidCheck,30101,Result,ValidHed);

    {* Check Stock Type *}
    If (ValidCheck) then
    begin
      ValidCheck:=(Stock.StockType<>StkGrpCode);
      GenSetError(ValidCheck,30102,Result,ValidHed);
    end;

    {* Check Customer/Supplier *}
    CustCode:=FullCustCode(CustCode);
    if CustCode <> Cust.CustCode then
    begin
      ValidCheck:=CheckRecExsists(CustCode,CustF,CustCodeK);
      GenSetError(ValidCheck,30103,Result,ValidHed);
    end;

    {* Check Currency *}
    If (ExSyss.MCMode) then
      ValidCheck:=((Currency>=1) and (Currency<=CurrencyType))
    else
    Begin
      ValidCheck:=BOn;
      Currency:=0;
    end;
    GenSetError(ValidCheck,30104,Result,ValidHed);

    {* Check Qty *}
    If (Qty=0) then
      TQty:=1
    else
      TQty:=Qty;  {* bc of real in main proc.. *}

    // HM 16/05/01: Finished writing the support for Locations that Sandra started in Nov2000!
    If (Trim(LocCode) <> '') Then Begin
      { Location Code set - validate it }
      ValidCheck := TK_GetMLoc(LocCode);

      If ValidCheck Then LCode := LocCode;
      GenSetError(ValidCheck,30105,Result,ValidHed);
    End; { If (Trim(LocCode) <> '') }

    If (Result=0) then
    begin
      {* Main Procedure to return Price Value *}
      Calc_StockPrice(Stock,Cust,Currency,TQty,ExStkPrRec.PriceDate,PrVal,DiscR,DiscCh,LCode,FoundOk, 0);

      Price:=PrVal;

      If (DiscCh=PcntCh) then
        DiscVal:=Round_Up((DiscR*100),2)
      else
        DiscVal:=DiscR;

      DiscChar:=DiscCh;

    end;

  end; {With..}

  GetPrice:=Result;

end; {GetPrice Func ..}

{* -------------------------------------------------------------------------- *}

FUNCTION EX_CALCSTOCKPRICE(P      :  POINTER;
                           PSIZE  :  LONGINT)   :  SMALLINT;
var
  ExStkPrRec  :  ^TBatchStkPriceRec;

begin

  LastErDesc:='';

  If TestMode Then
  Begin
    ExStkPrRec:=P;
    ShowMessage ('Ex_CalcStockPrice:' + #10#13 +
                 'P^.StockCode: ' + ExStkPrRec^.StockCode + #10#13 +
                 'P^.CustCode : ' + ExStkPrRec^.CustCode + #10#13 +
                 'PSize: '      + IntToStr(PSize));
  End; { If }

  Result:=32767;
  ExStkPrRec:=P;

  If ((P<>Nil) and (PSize=SizeOf(TBatchStkPriceRec))) then
  begin
    Result:=GetPrice(ExStkPrRec^);
  end
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(80,Result);

  Ex_CalcStockPrice:=Result;

end; {Ex_CalcStockPrice Func...}

{* -------------------------------------------------------------------------- *}




procedure CopyAltToExAlt(const EntAltRec : sdbStkType; VAR ExSKAltRec  : TBatchSKAltRec);
Var
  KeyS  :  Str255;
  Stat  :  Integer;

begin
  With ExSKAltRec do
  begin
    AltCode:=EntAltRec.sdCode1;
    AltDesc:=EntAltRec.sdDesc;
    SuppCode:=EntAltRec.sdSuppCode;
    ROPrice:=EntAltRec.sdROPrice;
    ROCurr:=EntAltRec.sdROCurrency;
    UseROPrice:=BoolToWordBool(EntAltRec.sdOverRO);
    LastUsed:=EntAltRec.sdLastUsed;
    LastTime:=EntAltRec.sdLastTime;

    {$IFDEF COMTK}
    FolioNum := EntAltRec.sdFolio;

    UseROQty := EntAltRec.sdOverMinEcc;
    ROQty    := EntAltRec.sdMinEccQty;
    UseLineQty := EntAltRec.sdOverLineQty;
    LineQty := EntAltRec.sdLineQty;
    LineNo := EntAltRec.sdLineNo;
    OrigAltCode := AltCode;
    OrigLineNo := LineNo;
    {$ENDIF}

    KeyS:=FullNomKey(EntAltRec.sdStkFolio);
    Stat:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkFolioK,KeyS);

    If (Stat=0) then
      StockCode:=Stock.StockCode;

  end; {with..}
end; {proc..}

Procedure AltToExAlt(VAR ExSKAltRec  : TBatchSKAltRec);
begin
  CopyAltToExAlt(MLocCtrl^.sdbStkRec, ExSkAltRec);
end;


{* -------------------------------------------------------------------------- *}

{* Get Stock Alternative Code *}
FUNCTION EX_GETSTKALT(P           :  POINTER;
                      PSIZE       :  LONGINT;
                      SEARCHKEY   :  PCHAR;
                      SEARCHPATH  :  SMALLINT;
                      SEARCHMODE  :  SMALLINT;
                      LOCK        :  WORDBOOL)  :  SMALLINT;
Const
  Fnum       =  MLocF;

Var
  ExskAltRec   :  ^TBatchSKAltRec;
  KeyChk,
  KeyS         :  Str255;
  Locked       :  Boolean;
  B_Func       :  Integer;

Begin
  LastErDesc:='';
  Result:=32767;
  Locked:=BOff;
  B_Func:=0;

  If (P<>Nil) and (PSize=Sizeof(TBatchSKAltRec)) then
  Begin

    ExSKAltRec:=P;

    KeyS:=StrPas(SearchKey);

    Case SearchPath of

      0  : KeyS:=PartCCKey(NoteTCode,NoteCCode)+FullStockCode(KeyS);  {* By Stock Alt-Code *}
      1  : begin
             KeyS:=LJVar(UpperCase(KeyS),StkLen);

             Status:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,KeyS);

             If (Status=0) then
               KeyS:=PartCCKey(NoteTCode,NoteCCode)+Full_SupStkKey(Stock.StockFolio,ExSKAltRec^.AltCode);
           end;
      {2  : KeyS:=PartCCKey(NoteTCode,NoteCCode)+FullRunNoKey(sdFolio,sdStkFolio);}
    end; {Case..}


    KeyChk:=KeyS;
    KeyS:= SetKeyString(SearchMode, FNum, KeyS);

    If TestMode Then
            ShowMessage ('Ex_GetStkAlt : ' + #10#13 +
            'P: ' + IntToStr(SizeOf(TBatchSKAltRec)) + #10#13 +
            'PSize: ' + IntToStr(PSize) + #10#13 +
            'SearchKey: ' + StrPas(SearchKey) + #10#13 +
            'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
            'SearchMode: ' + IntToStr(SearchMode) + #10#13 +
            'Lock: ' + IntToStr(Ord(Lock)));

    Blank(ExSKAltRec^,Sizeof(ExSKAltRec^));

    UseVariant(F[Fnum]);
    Result:=Find_Rec(SearchMode,F[Fnum],Fnum,RecPtr[Fnum]^,SearchPath,KeyS);

    KeyStrings[FNum] := KeyS;

    If WordBoolToBool(Lock) and (Result=0) then {* Attempt to lock record after we have found it *}
    {$IFDEF WIN32}
    begin
      UseVariant(F[Fnum]);
      If (GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,MLocF,SilentLock,Locked)) then
        Result:=0;
      // If not locked and user hits cancel return code 84
      if (Result = 0) and not Locked then
        Result := 84;
    end;
    {$ELSE}
    Result:=(GetMultiRec(B_GetDirect,B_SingLock,KeyS,SearchPath,MLocF,SilentLock,Locked));
    {$ENDIF}

    {
    If (Result=0) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) then
    begin
      Result:=0;
      AltToExAlt(ExSKAltRec^);
    end;
    }
    StrPCopy(SearchKey,KeyS);


    If (Result=0) then
      AltToExAlt(ExSKAltRec^);

  end {If .. Not assigned}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(51,Result);

end; { Ex_GetStkAlt..}

{* -------------------------------------------------------------------------- *}

{* From External record to Exch. Record for Stock Alternative Record *}

function  ExStkAltToStkAlt(ExStkAltRec   :  TBatchSkAltRec;
                           SearchMode    :  Smallint;
                           SearchPath    :  SmallInt)  :  Integer;
Const
  Fnum     =  MLocF;
  KeyPath  =  MLK;

var
  KeyChk,
  KeyS    :  Str255;

  ValidCheck,
  ValidHed,
  FoundOK,
  NewRec  :  Boolean;

  B_Func  :  Integer;

  CheckOnly,
  Found : Boolean;
  StkDesc : String;

begin

  Result:=0;
  ValidCheck:=BOn;
  ValidHed:=BOff;
  FoundOK:=BOff;

  ResetRec(Fnum);

  CheckOnly := SearchMode = CheckMode;

{  If (Not (SearchMode In [B_Insert,B_Update])) then
    SearchMode:=B_Insert;}

  With ExStkAltRec do
  begin
    AltCode:=LJVar(UpperCase(AltCode),StkLen);

    {* Check Parent Stock Record *}
    StockCode:=LJVar(UpperCase(StockCode),StkLen);
    KeyS:=StockCode;
    Status:=Find_Rec(B_GetEq,F[StockF],StockF,RecPtr[StockF]^,StkCodeK,KeyS);
    ValidCheck:=(Status=0) and (Stock.StockType<>StkGrpCode);

    GenSetError(ValidCheck,30001,Result,ValidHed);


    //PR: 8/8/02 - Wasn't checking ValidCheck before checking SupplierCode so
    // record was saved incorrectly. Added check.
    if ValidCheck then
    begin
      {$IFDEF COMTK}
       //Set the stock folio here as we may check another stock record for extended types
       StockFolio := Stock.StockFolio;
      {$ENDIF}
       StkDesc := Stock.Desc[1];
      {* Check Supplier Code *}
      ValidCheck:=(EmptyKey(SuppCode,AccLen));
      If (Not ValidCheck) then
      begin
        SuppCode:=LJVar(UpperCase(SuppCode),AccLen);
        ValidCheck:=(CheckRecExsists(SuppCode,CustF,CustCodeK));
        //PR 25/02/03 NZ want to be able to add for customers as well as suppliers so remove this check
        //ValidCheck:=(ValidCheck) and (Cust.CustSupp=TradeCode[BOff]);
      end; {if..}

      GenSetError(ValidCheck,30002,Result,ValidHed);
    end;

    //PR: 8/8/02 - Wasn't checking ValidCheck before checking Currency so
    // record was saved incorrectly. Added check.
    if ValidCheck then
    begin
      {* Check Currency *}
      If (ExSyss.MCMode) then
        ValidCheck:=((ROCurr>=1) and (ROCurr<=CurrencyType))
      else
      Begin
        ValidCheck:=BOn;
        ROCurr:=0;
      end;
      GenSetError(ValidCheck,30003,Result,ValidHed);
    end;

    If (ValidCheck) then
    begin
      { Check StockCode + AltCode }
      KeyS:=PartCCKey(NoteTCode,NoteCCode)+Full_SupStkKey(Stock.StockFolio,AltCode);
      KeyChk:=KeyS;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,1,KeyS);

      Found := False;
      while (Status = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) and not Found do
      begin
        Found := CheckKey(MLocCtrl^.sdbStkRec.sdSuppCode, SuppCode, Length(SuppCode), True);

        if not Found then
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,1,KeyS);
      end;

      if not Found then
        Status := 4;

      if CheckOnly then
      begin
        if Found then
          SearchMode := B_Update
        else
          SearchMode := B_Insert;
      end;

      {* If update, check the record exists *}
      If (SearchMode=B_Update) then
      begin

        ValidCheck:=(Status=0);

        {$IFDEF COMTK}
        //PR 26/01/04 - Allow AltCode to be changed, so need to make sure we have
        //the correct record by checking folio number
        ValidCheck := ValidCheck and (MLocCtrl^.sdbStkRec.sdFolio = FolioNum);
        if not ValidCheck then
        begin
          if (RecType = NoteCCode) then
            KeyS := PartCCKey(NoteTCode,RecType) + FullRunNoKey(FolioNum, Stock.StockFolio)
          else
            KeyS := PartCCKey(NoteTCode,RecType) + FullRunNoKey(Stock.StockFolio,OrigLineNo) + OrigAltCode;

          KeyChk:=KeyS;

          Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,2,KeyS);
          ValidCheck:=(Status=0);
        end;

        {$ENDIF}
        GenSetError(ValidCheck,30004,Result,ValidHed);

      end {if Update..}
      else
      begin  {Insert..}

(*        While (Status=0) and (ValidCheck) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOff) do
        begin
          ValidCheck:=(Not CheckKey(MLocCtrl^.sdbStkRec.sdSuppCode,SuppCode,Length(SuppCode),BOff));
          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,1,KeyS);
        end; {while..} *)
        ValidCheck := Status <> 0;

        GenSetError(ValidCheck,30005,Result,ValidHed);

      end; {if..}

    end; {if Validcheck..}

    {$IFDEF COMTK} //If in extended types then stock code must be valid
    if ValidCheck and (RecType <> NoteCCode) then
    begin
      ValidCheck := not (EmptyKey(AltCode,StkLen)) and (Trim(AltCode) <> Trim(StockCode));
      If (ValidCheck) then
      begin
        AltCode:=LJVar(UpperCase(AltCode),StkLen);
        ValidCheck:=(CheckRecExsists(AltCode,StockF,StkCodeK));

      end; {if..}

      GenSetError(ValidCheck,30007,Result,ValidHed);

    end;
    {$ENDIF}

    {* Update Record *}
    If (ValidCheck) and not CheckOnly then
    With MLocCtrl^.sdbStkRec do
    begin
    {$IFDEF COMTK}
      sdStkFolio := StockFolio;
    {$ENDIF}
      sdSuppCode:=SuppCode;
      sdROPrice:=ROPrice;
      sdROCurrency:=ROCurr;
      sdOverRO:=WordBoolToBool(UseROPrice);
      {$IFDEF COMTK}
        if RecType <> NoteCCode then
          sdDesc := StkDesc
        else
      {$ENDIF}
          sdDesc:=AltDesc;

      sdLastUsed:=Today;      { v4.31 }
      sdLastTime:=TimeNowStr; { v4.31 }
      sdAltCode := AltCode;

      //PR 27/02/06 Moved this below, as sdStkFolio & sdFolio haven't been set at this point
{      sdCode1:=FullStockCode(AltCode);
      sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);
      if RecType = NoteCCode then
        sdCode3:=FullRunNoKey(sdFolio,sdStkFolio)
      else
        sdCode3 := FullRunNoKey(sdStkFolio,sdLineNo) + sdCode1;}

      {$IFDEF COMTK}
      sdOverMinEcc := UseROQty;
      sdMinEccQty := ROQty;
      sdOverLineQty := UseLineQty;
      sdLineQty := LineQty;
      sdLineNo := LineNo;

      {$ENDIF}

      If (SearchMode=B_Insert) then
      begin

        MLocCtrl^.RecPfix:=NoteTCode;
        {$IFNDEF COMTK}
        MLocCtrl^.Subtype:=NoteCCode;
        {$ELSE}
        MLocCtrl^.Subtype:=RecType;
        {$ENDIF}
        sdFolio :=SetNextSFolio(SKF,BOn,1);
        sdNLineCount:=1;
        {$IFDEF COMTK}
        SdStkFolio:= StockFolio;
        {$ENDIF}
//        sdFolio:=SetNextSFolio(SKF,BOn,1);
      sdCode1:=FullStockCode(AltCode);
      sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);
      {$IFDEF COMTK}
      if RecType = NoteCCode then
        sdCode3:=FullRunNoKey(sdFolio,sdStkFolio)
      else
        sdCode3 := FullRunNoKey(sdStkFolio,sdLineNo) + sdCode1;
      {$ELSE}
        sdCode3:=FullRunNoKey(sdFolio,sdStkFolio);
      {$ENDIF}

        Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
        ValidCheck:=(Status=0);

      end {if..}
      else
      begin
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
        ValidCheck:=(Status=0);

      end; {if..}

      GenSetError(ValidCheck,30006,Result,ValidHed);

    end; {if..}

  end; {with..}

end; {proc..}

{* -------------------------------------------------------------------------- *}

{* Store Stock Alternative Codes *}
FUNCTION EX_STORESTKALT(P          :  POINTER;
                        PSIZE      :  LONGINT;
                        SEARCHPATH :  SMALLINT;
                        SEARCHMODE :  SMALLINT)  :  SMALLINT;

Var
  ExStkAltRec  :  ^TBatchSKAltRec;
  KeyS         :  Str255;

Begin
  LastErDesc:='';
  If (TestMode) then
  begin
    ExStkAltRec:=P;
    ShowMessage ('Ex_StoreStkAlt:' + #10#13 +
                 'P^.AltCode: ' + ExStkAltRec^.AltCode + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  end; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchSKAltRec)) then
  Begin
    ExStkAltRec:=P;

    if StockOn then
      Result:=ExStkAltToStkAlt(ExStkAltRec^,SearchMode,SearchPath)
    else
      Result := NoStockErr;

  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(52,Result);

end; {Ex_StoreStkAlt..}


Function  ExJAPMatchToMatch(ExMatchRec   :  TBatchMatchRec;
                            SearchMode   :  SmallInt;
                            SearchPath   :  SmallInt)  :  Integer;

Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;
  Fnum2     =  InvF;
  Keypath2  =  InvOurRefK;

var
  OPass    :  TBatchMatchRec;
  n        :  Byte;
  LastACNo :  Str10;
  Rnum     :  Real;

  KeyS     :  Str255;

  bNegative,
  ValidHed,
  ValidCheck,
  LastDocType,
  Locked
           :  Boolean;

  TmpMode  :  SmallInt;
  InvSign, RecSign : SmallInt;

  function Sign(const Value : Double) : SmallInt;
  begin
    if Value > 0 then
      Result := 1
    else
    if Value < 0 then
      Result := -1
    else
      Result := 0;
  end;

begin

  TmpMode:=SearchMode;

  FillChar(PassWord, SizeOf(PassWord),#0);
  FillChar(OPass, SizeOf(OPass),#0);

  With ExMatchRec do
  begin
    {* 23.04.99 Ljvar has been added for VB user, (Cooper)
                though DebitRef is 9, extra 3 character have been assigned in
                DocCode which is String12 *}
    PassWord.MatchPayRec.DocCode:=LJVar(DebitRef,DocLen);  {DebitRef;}
    PassWord.MatchPayRec.PayRef:=LJVar(CreditRef,DocLen);  {CreditRef;}
    PassWord.MatchPayRec.MCurrency:=DebitCr;
    PassWord.MatchPayRec.RCurrency:=CreditCr;
    PassWord.MatchPayRec.OwnCVal:=DebitVal;
    PassWord.MatchPayRec.RecOwnCVal:=CreditVal;
    PassWord.MatchPayRec.SettledVal:=BaseVal;

    PassWord.MatchPayRec.MatchType:= 'O'; //SPOP

    PassWord.RecPFix:=MatchTCode;
    if MatchType in UserMatchSet then
      PassWord.SubType:=MatchType
    else
      PassWord.SubType := MatchSCode;
  end;

  {* Start Validation *}

  ValidHed:=BOn;
  ValidCheck:=BOff;
  KeyS:='';
  LastAcNo:='';
  LastDocType:=BOff;
  Result:=0;

  With PassWord.MatchPayRec do
  Begin

    {* Check first document exists *}

    ValidCheck:=(CheckRecExsists(Trim(DocCode),Fnum2,KeyPath2));
    GenSetError(ValidCheck,30001,Result,ValidHed); {Unable to locate this document.}

      {* Check document type valid, and being allocated the right way round *}

    If (ValidHed) then
    Begin

(*     if not (MatchType in UserMatchSet) then
     begin
      Locked:=BOff;

      KeyS:=DocCode;

      {$IFDEF WIN32}
      begin
        If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked)) then
          Result:=0;
        // If not locked and user hits cancel return code 84
        if (Result = 0) and not Locked then
          Result := 84;
      end;
      {$ELSE}
      Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked));
      {$ENDIF}
     end
     else
       Locked := True; //Locked wasn't being initialized for custom matching

      If (SearchMode<>CheckMode) and (Result=0) and (Locked) then
      With Inv do
      Begin

       if not (MatchType in UserMatchSet) then
       begin
        ValidCheck:=(CurrencyOS(Inv,BOn,BOff,BOff)=0); {* Check was allocated *}

        Settled:=Settled+SettledVal;
        CurrSettled:=CurrSettled+OwnCVal;

        RemitNo:=PayRef;

        If (CurrencyOS(Inv,BOn,BOff,BOff)=0) and (Not ValidCheck) then {* Now fully allocated *}
        Begin

          If (ExSyss.MCMode) and (CXRate[BOff]=0) then
            CXrate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];

          AllocStat:=#0;

        end
        else
          If (CurrencyOS(Inv,BOn,BOff,BOff)<>0) and (ValidCheck) then
          Begin
            If (ExSyss.MCMode) and (Not UseCoDayRate) then
              CXrate[BOff]:=0;

            AllocStat:=CustSupp;

          end;

        {* 01.09.99 - Added confirmed by EL *}
        Set_DocAlcStat(Inv);
        Result:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);
       end;    *)

        If (Result=0) then
        Begin

{          if not (MatchType in UserMatchSet) then
            AltRef:=YourRef;}

          Result:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

(*          if not (MatchType in UserMatchSet) then
          begin
             KeyS:=PayRef;

            {$IFDEF WIN32}
            begin
              If (GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked)) then
                Result:=0;
              // If not locked and user hits cancel return code 84
              if (Result = 0) and not Locked then
                Result := 84;
            end;
            {$ELSE}
            Result:=(GetMultiRec(B_GetEq,B_SingLock,KeyS,KeyPath2,Fnum2,SilentLock,Locked));
            {$ENDIF}

            If (Result=0) and (Locked) then
            With Inv do
            Begin

              ValidCheck:=(CurrencyOS(Inv,BOn,BOff,BOff)=0); {* Check was allocated *}

              Settled:=Settled+(SettledVal*DocNotCnst);

              CurrSettled:=CurrSettled+(RecOwnCVal*DocNotCnst);

              RemitNo:='';

              If (CurrencyOS(Inv,BOn,BOff,BOff)=0) and (Not ValidCheck) then {* Now fully allocated *}
              Begin

                If (ExSyss.MCMode) and (CXRate[BOff]=0) then
                  CXrate[BOff]:=SyssCurr^.Currencies[Currency].CRates[BOff];

                AllocStat:=#0;

              end
              else
                If (CurrencyOS(Inv,BOn,BOff,BOff)<>0) and (ValidCheck) then
                Begin
                  If (ExSyss.MCMode) and (Not UseCoDayRate) then
                    CXrate[BOff]:=0;

                  AllocStat:=CustSupp;

                end;

              {* 01.09.99 - Added confirmed by EL *}
              Set_DocAlcStat(Inv);
              Result:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPAth2);

          end; {With..& Locked..}
          end;

        end; {If Doc stored ok..} *)

      end;  

    end;    

  end; {With..} 

//  ExMatchToMatch:=Result;

end; {proc..}

FUNCTION EX_STOREJAPMATCH(P            :  POINTER;
                          PSIZE        :  LONGINT;
                          SEARCHPATH   :  SMALLINT;
                          SEARCHMODE   :  SMALLINT)  :  SMALLINT;

Var

   ExMatchRec  :  ^TBatchMatchRec;
   KeyS        :  Str255;

Begin
  LastErDesc:='';

  If TestMode Then Begin
    ExMatchRec:=P;
    ShowMessage ('Ex_StoreMatch:' + #10#13 +
                 'P^.DebitRef: ' + ExMatchRec^.DebitRef + #10#13 +
                 'PSize: '      + IntToStr(PSize) + #10#13 +
                 'SearchPath: ' + IntToStr(SearchPath) + #10#13 +
                 'SearchMode: ' + IntToStr(SearchMode));
  End; { If }

  Result:=32767;

  If (P<>Nil) and (PSize=Sizeof(TBatchMatchRec)) then
  Begin
    ExMatchRec:=P;
    Result:=ExJAPMatchToMatch(ExMatchRec^,SearchMode,SearchPath);
  end {If .. Not assigned/Wrong Size}
  else
    If (P<>Nil) then
      Result:=32766;

  If (Result<>0) then
    LastErDesc:=Ex_ErrorDescription(76,Result);

end; {Ex_StoreMatch Func..}

FUNCTION EX_DELETESTOCK(FOLIO  :  LONGINT) : SMALLINT;
var
  SearchStr : str255;
begin
  LastErDesc:='';
  SearchStr := FullNomKey(Folio);
  Result := Find_Rec(B_GetEq + B_MultLock, F[StockF], StockF, RecPtr[StockF]^, 1, SearchStr);
  if Result = 0 then
  begin
     Result := Delete_Rec(F[StockF], StockF, 1);
     if Result <> 0 then
       Result := 30000 + Result;
  end;

end;

Type
  TMatchCallbackProc = procedure(DRef : PChar; PRef : PChar); StdCall;

function UpdateRemitNo(sKey : Str255) : Integer;
const
  FNum = InvF;
  KeyPath = InvOurRefK;
var
  Res : Integer;
  KeyS : Str255;
begin
  KeyS := sKey;
  Result := Find_Rec(B_GetEq + B_SingLock, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);
  if Result = 0 then
  begin
    FillChar(Inv.RemitNo, 11, 0);
    Result := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, KeyPath);
  end;
end;

FUNCTION EX_UPDATEINVALIDMATCHES(CALLBACK : POINTER) : SMALLINT;
const
  Fnum      =  PWrdF;
  Keypath   =  PWK;
  LogFile   = 'Logs\matchlog.log';
var
  Res, Res1 : Integer;
  DRef, PRef : PChar;
  CallBackProc : TMatchCallbackProc;
  KeyS : Str255;
  DocType, PayType, TempDoc, TempPay : string;
  AnyErrors : Boolean;
  MatchLogF : TextFile;

  procedure LogIt(ErrCode : Integer; ErrCodeTrans : Integer);
  var
    ErrMessage : string;
  begin
    Case ErrCode of
      0 : ErrMessage := 'Matching record adjusted';
     84 : ErrMessage := 'Matching record was locked';
      else
        ErrMessage := 'Unable to store Matching record. Error ' + IntToStr(ErrCode);
    end; //case

    WriteLn(MatchLogF, Format('%s : %s - %s', [AnsiString(DRef), AnsiString(PRef), ErrMessage]));
    if ErrCodeTrans <> 0 then
      WriteLn(MatchLogF, Format('Unable to update transaction %s. Error %d',[PRef, ErrCodeTrans]));
    if (ErrCode <> 0) or (ErrCodeTrans <> 0) then
      Result := 30001;
  end;

begin
  if Assigned(CallBack) then
  begin
    Result := 0;
    AssignFile(MatchLogF, SetDrive + Logfile);
    Rewrite(MatchLogF);
    AnyErrors := False;
    CallBackProc := CallBack;
    DRef := StrAlloc(10);
    PRef := StrAlloc(10);
    Try
      KeyS := MatchTCode + MatchSCode;
      UseVariant(F[Fnum]);
      Res := Find_Rec(B_StepFirst + B_SingLock, F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath, KeyS);
      while (Res in [0, 84]) do
      begin
        Res1 := 0;
        FillChar(DRef^, 10, 0);
        FillChar(PRef^, 10, 0);
        if (PassWord.RecPFix = MatchTCode) and (PassWord.SubType = MatchSCode) and
           (PassWord.MatchPayRec.MatchType = 'A') then
        begin
          DocType := Copy(Password.MatchPayRec.DocCode, 1, 3);
          PayType := Copy(Password.MatchPayRec.PayRef, 1, 3);
          if ((DocType = 'PPY') and ((PayType = 'PCR') or (PayType = 'PJC')))
          or ((DocType = 'SRC') and ((PayType = 'SCR') or (PayType = 'SJC'))) then
          begin
            if Res = 0 then
            begin
              TempPay := Password.MatchPayRec.DocCode;
              TempDoc := Password.MatchPayRec.PayRef;
              FillChar(Password.MatchPayRec.DocCode, 13, 0);
              FillChar(Password.MatchPayRec.PayRef, 11, 0);
              Password.MatchPayRec.DocCode := LJVar(TempDoc, DocLen);
              Password.MatchPayRec.PayRef := LJVar(TempPay, DocLen);
              Password.MatchPayRec.SettledVal := -Password.MatchPayRec.SettledVal;
              Password.MatchPayRec.OwnCVal := - Password.MatchPayRec.OwnCVal;

              Res := Put_Rec(F[FNum], FNum, RecPtr[FNum]^, KeyPath);

              StrPCopy(DRef, Password.MatchPayRec.DocCode);
              StrPCopy(PRef, Password.MatchPayRec.PayRef);

              if Res = 0 then
                Res1 := UpdateRemitNo(Password.MatchPayRec.PayRef);
            end;
            LogIt(Res, Res1);
          end;
        end;
        CallBackProc(DRef, PRef);
        UseVariant(F[Fnum]);
        Res := Find_Rec(B_StepNext + B_SingLock, F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath, KeyS);
      end;
    Finally
      StrDispose(PRef);
      StrDispose(DRef);
      CloseFile(MatchLogF);
    End;
  end
  else //This should never happen
    Result := 30000;
end;

function EX_DELETEFIFO : SMALLINT;
const
  Fnum    = MiscF;
  Keypath = MIK;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
begin
  KeyS := MFIFOCode + MFIFOSub;
  KeyChk := KeyS;
  UseVariant(F[Fnum]);
  Result := Find_Rec(B_GetGEq, F[FNum], FNum, RecPtr[FNum]^, KeyPath, KeyS);

  if (Result = 0) and (Copy(KeyS, 1, 2) = KeyChk) then
    Result := Delete_Rec(F[FNum], FNum, KeyPath)
  else
  if Result = 0 then //no more FIFOs
    Result := 9;
end;

initialization
  UseMultiBuys := True;
  //PR: 19/11/2012 Add variable to cover whether ABSEXCH-9480 fix works or not (ABSEXCH-13753)
  Use9480ReOrder := True;

end.
