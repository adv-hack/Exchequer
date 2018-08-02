unit MultiBuyFuncs;

interface

uses
  VarConst, MultiBuyVar, BtrvU2, SysUtils, Classes, GlobVar, BtKeys1U
  {$IFDEF COMTK}
    ,{$IFDEF IMPV6}
      GlobalTypes
     {$ELSE}
     VarCnst3
     {$ENDIF}
  {$ENDIF}
  {$If (not Defined(EXDLL)) or Defined(COMTK)}, ExWrap1U {$IfEnd};

const
  rcType = 1;
  rcQty = 2;
  rcDate = 4;
  rcCurrency = 128;

type
  TMultiBuyDiscountList = Class
  private
    FList : TList;
    FIndex : Integer; //Pointer to current record
    function GetRecord : TMultiBuyDiscount;
    function GetCount : Integer;
  public
    constructor Create;
    destructor Destroy; override;
    function GetFirst : Boolean;
    function GetNext : Boolean;
    property MBDRec : TMultiBuyDiscount read GetRecord;
    property Count : Integer read GetCount;
  end;

  TMultiBuyDiscountHolder = Class
    mbdQty : Integer;
    LineUnitPrice : Double;
    MBDRec : TMultiBuyDiscount;
    constructor Create;
  end;

  TMultiBuyFunctions = Class
  private
    FMBDRec : TMultiBuyDiscount;
    WantToAbort : Boolean;
    function GetCostPrice(const sStockCode : string) : Double;
    function UnderCostPrice(const sStockCode : string; var CostP : Double; var SellP : Double) : Boolean;
    procedure CheckStockPrices(const sStockCode : string; const CustCode : string = '');
    function GetDiscountQty: Double;
    function DiscountsClash(const NewRec, ExistingRec : TMultiBuyDiscount) : Integer;
    function ConsolidatedToCurrency(Value : Double; Currency : Byte) : Double;
   {$If (not Defined(EXDLL)) or Defined(COMTK)}
    function DoGetMultiBuyList(const sAcCode : String; const sStockCode, sTransDate : String; //Fairly self-explanatory
                               ExLocal : TdExLocalPtr;     //Must not be nil
                               Currency : Integer = 0;     //Currency of transaction - only used for mbtForAmount discounts
                               Threaded : Boolean = True;  //True indicates a multi-threaded exlocal
                               IsSales : Boolean = True;   //True indicates a sales transaction
                               WantedQty : Double = 0      //If >0 then only MBDs >= WantedQty are returned; if 0 the all are returned
                               ) : TStringList;
    {$IfEnd}
  public
    constructor CreateWith(const ARec : TMultiBuyDiscount);
    function MBDUnitPrice(PriceEach : Double; DecPlaces : Byte) : Double;
    function FindAcStockRecords(const sAcCode, sStockCode, sDate : string; Currency : Byte = 0) : TMultiBuyDiscountList;
    function FindFirstFit(const sAcCode, sStockCode, sDate : string; Currency : Byte = 0) : TMultiBuyDiscountList;
    function InDateRange(const ARec : TMultiBuyDiscount; const sDate : string) : Boolean;
    procedure CheckPricesForAccount(const sAcCode : string);
    procedure CheckPricesForStock(const sStockCode : string);
    procedure BlockDelete(IsStock : Boolean; AOwner : TComponent; MsgHandle : THandle);
   {$If (not Defined(EXDLL)) or Defined(COMTK)}
   //GetMultiBuyList returns a TStringList of applicable MBDs - the strings contain descriptions and
   //the objects contain the MBDs as TMultiBuyDiscountHolders.
    function GetMultiBuyList(const sAcCode : String; const sStockCode, sTransDate : String; //Fairly self-explanatory
                               ExLocal : TdExLocalPtr;     //Must not be nil
                               Currency : Integer = 0;     //Currency of transaction - only used for mbtForAmount discounts
                               Threaded : Boolean = True;  //True indicates a multi-threaded exlocal
                               IsSales : Boolean = True;   //True indicates a sales transaction
                               WantedQty : Double = 0      //If >0 then only MBDs >= WantedQty are returned; if 0 the all are returned
                               ) : TStringList;
    function ValueOfDiscount(LId : IDetail; Qty : Double) : Double;
    function UnitValueOfDiscount(LId : IDetail; Qty : Double) : Double;
    {$IfEnd}
    function FormatMultiBuyString(ARec : TMultiBuyDiscount) : String;
    procedure FreeMultiBuyList(var AList : TStringList);  //PR: 24/08/2009 Changed param to var
    function DiscountAvailable(BuyQty : Double) : Boolean;
    function ValidateDiscount(const NewRec : TMultiBuyDiscount; IsEdit : Boolean) : Integer;
    //Takes a list returned from GetMultiBuyList and returns a list of Description Lines
    function GetDiscountLineStrings(const sStockCode : string; const AList : TStringList) : TStringList;
   {$If (not Defined(EXDLL)) or Defined(COMTK)}
    function AddMultiBuyDescLines(var InvR: InvRec; IDR: IDetail; StockFolio : longint;
                                 const MBDList : TStringList; ExLocal : TdExLocalPtr = nil) : Integer;
    {$Else}
    function AddMultiBuyDescLines(var InvR: InvRec; IDR: IDetail; StockFolio : longint;
                                 const MBDList : TStringList) : Integer;
    {$IfEnd}
    procedure GetUnitDiscountValue(const AList: TStringList;
                                   {$IFDEF COMTK}
                                   const TLRec : TBatchTLRec;
                                   {$ELSE}
                                   const TLRec : IDetail;
                                   {$ENDIF}
                                   var DiscValue: Double;
                                   var DiscChr: Char);
    //PR: 03/08/2009
    function DeleteDescLines(LID : IDetail) : Integer;
    property DiscountQty : Double read GetDiscountQty;
    property MBDRec : TMultiBuyDiscount read FMBDRec write FMBDRec;
  end;

  function QtyString(iQty : Integer) : string;

  {$IFDEF EBAD}
  function AddMultiBuyDiscounts(var InvR: InvRec; var IDR: IDetail; StockFolio : longint; ExLocal : TdExLocalPtr; VatRate : Double) : Boolean;
  {$ENDIF}

implementation

uses
  EtMiscU, BtSupU1, SysU2,
  {$IFNDEF EXDLL}
// {$IFNDEF EBAD} FifoL2u,  Discu3U,  MultiBuyDeleteF,{$ELSE} XmlUtil,{$ENDIF}  MiscU, BtSupU2,
 {$IFNDEF EBAD} FifoL2u,  Discu3U,  MultiBuyDeleteF,{$ELSE} XmlUtil,{$ENDIF} {$IFNDEF TRADE} MiscU, {$ENDIF}  BtSupU2,

  {$ELSE}
    {$IFDEF COMTK}
     MiscU, BtSupU2,
    {$ENDIF}
  {$ENDIF}
  EtDateU, ComnU2, ApiUtil, EtStrU, Dialogs, Controls, IIFFuncs, CurrncyU

  {$IFDEF TRADE}
    , TCMEntFuncs;
  {$ELSE}
    ;
  {$ENDIF}

function LineDiscountAmount(const IDR : IDetail) : Double;
begin
  with IDR do
    Result := Calc_PAmountAD(NetValue,
                           Discount, DiscountChr,
                           Discount2, Discount2Chr,
                           Discount3, Discount3Chr);
end;

{$IFDEF EBAD}
function AddMultiBuyDiscounts(var InvR: InvRec; var IDR: IDetail; StockFolio : longint; ExLocal : TdExLocalPtr; VatRate : Double) : Boolean;
var
  AList : TStringList;
  VATIndex : VatType;
  i : integer;
  DiscValue : Double;
  DiscChar : Char;
begin
  with TMultiBuyFunctions.Create do
  Try
    Try
      AList := GetMultiBuyList(InvR.CustCode, IDR.StockCode, InvR.TransDate, ExLocal, InvR.Currency,
                               True, InvR.InvDocHed = SOR, IDR.Qty);
      if AList.Count = 0 then
      begin //Try again for consolidated
        AList.Free;
        AList := GetMultiBuyList(InvR.CustCode, IDR.StockCode, InvR.TransDate, ExLocal, 0,
                               True, InvR.InvDocHed = SOR, IDR.Qty);
      end;

      Result := AList.Count > 0;
      if Result then
      begin
        //Calculate discount on 1 unit
        GetUnitDiscountValue(AList, IDR, DiscValue, IDR.Discount2Chr);
        IDR.Discount2 := DiscValue;

//        InvR.InvNetVal := InvR.InvNetVal - (IDR.Discount2 * IDR.Qty);
        InvR.TotOrdOs := InvR.TotOrdOs - (IDR.Discount2 * IDR.Qty);
        InvR.DiscAmount := InvR.DiscAmount + (IDR.Discount2 * IDR.Qty);

        //Recalculate Header Totals & Vat
        if not InvR.ManVat then
        with IDR do
        begin
          //Remove existing VAT for this line from header
          InvR.InvVat := InvR.InvVat - VAT;
          VATIndex := GetVatNo(VATCode, #0);
          InvR.InvVATAnal[VATIndex] := InvR.InvVATAnal[VATIndex] - VAT;


          VAT := ((NetValue - LineDiscountAmount(IDR)) * Qty * (VATRate /100)) * (1 - InvR.DiscSetl);

          //Add revised VAT to header
          InvR.InvVAT := InvR.InvVAT + VAT;
          InvR.InvVATAnal[VATIndex] := InvR.InvVATAnal[VATIndex] + VAT;
        end;



        TdMTExLocalPtr(ExLocal)^.LAdd_Rec(IDetailF, -1);
        AddMultiBuyDescLines(InvR, IDR, StockFolio, AList, ExLocal);
        TdMTExLocalPtr(ExLocal)^.LPut_Rec(InvF, 0); //Update header with new line count
      end;
    Finally
      FreeMultiBuyList(AList);
    End;
  Finally
    Free;
  End;
end;
{$ENDIF}

function QtyString(iQty : Integer) : string;
begin
  Result := Format('%d x ', [iQty]);
end;

function IsInDateRange(const DateToTest, StartDate, EndDate : string) : Boolean;
begin
  Result := (DateToTest >= StartDate) and (DateToTest <= EndDate);
end;



//Price each should already have been calculated, taking into account line discount for BuyQty
function TMultiBuyFunctions.MBDUnitPrice(PriceEach : Double; DecPlaces : Byte) : Double;
begin
  Result := 0;
  with MBDRec do
  begin
    Case mbdDiscountType of
      mbtGetFree       : Result := Round_Up((PriceEach * mbdBuyQty) /(mbdBuyQty + mbdRewardValue), DecPlaces );

      mbtForAmount     : Result := Round_Up( mbdRewardValue / mbdBuyQty, DecPlaces);

      mbtGetPercentOff : Result := Round_Up(PriceEach - (PriceEach * mbdRewardValue), DecPlaces);
    end;
  end;
end;



constructor TMultiBuyFunctions.CreateWith(
  const ARec: TMultiBuyDiscount);
begin
  inherited Create;
  FMBDRec := ARec;
end;

function TMultiBuyFunctions.FindAcStockRecords(const sAcCode, sStockCode,
  sDate: string; Currency: Byte = 0): TMultiBuyDiscountList;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  MBRec : PMultiBuyDiscount;
  ThisCurrency : Byte;
begin
  Result := TMultiBuyDiscountList.Create;
  KeyS := FullCustCode(sAcCode) + FullStockCode(sStockCode);
  KeyChk := KeyS;
  ThisCurrency := 0;

  if Currency <> 0 then  //Need to see if there are any records with this currency for this AcCode/StockCode combination - if not, then use consolidated
  begin
    Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    begin
      with MultiBuyDiscount do
      if (mbdDiscountType = mbtForAmount) and InDateRange(MultiBuyDiscount, sDate) and (mbdCurrency = Currency) then
      begin
        ThisCurrency := Currency;
        Res := 9;
      end;


        Res := Find_Rec(B_GetNext, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
    end;
  end;

  Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
  while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
  begin
    with MultiBuyDiscount do
    if InDateRange(MultiBuyDiscount, sDate) and ((mbdDiscountType <> mbtForAmount) or (mbdCurrency = ThisCurrency )) then
    begin
      New(MBRec);
      MBRec^ := MultiBuyDiscount;
      Result.FList.Add(MBRec);
    end;

    Res := Find_Rec(B_GetNext, F[MultiBuyF], MultiBuyF, MultiBuyDiscount, mbdAcCodeK, KeyS);
  end;

end;

{ TMultiBuyDisountList }

constructor TMultiBuyDiscountList.Create;
begin
  inherited Create;
  FList := TList.Create;
  FIndex := 0;
end;

destructor TMultiBuyDiscountList.Destroy;
begin
  FList.Free;
  inherited;
end;

function TMultiBuyDiscountList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TMultiBuyDiscountList.GetFirst: Boolean;
begin
  FIndex := 0;
  Result := FList.Count > 0;
end;

function TMultiBuyDiscountList.GetNext: Boolean;
begin
  Inc(FIndex);
  Result := FIndex < FList.Count;
end;

function TMultiBuyDiscountList.GetRecord: TMultiBuyDiscount;
begin
  Result := PMultiBuyDiscount(FList[FIndex])^;
end;

function TMultiBuyFunctions.InDateRange(const ARec: TMultiBuyDiscount;
  const sDate: string): Boolean;
begin
  Result := not ARec.mbdUseDates or ((sDate >= ARec.mbdStartDate) and (sDate <= ARec.mbdEndDate));
end;

function TMultiBuyFunctions.FindFirstFit(const sAcCode, sStockCode,
  sDate: string; Currency: Byte): TMultiBuyDiscountList;
begin
//Function to return the first set of Discount records, searching in the following order - Account/Stock/Currency, Account/Stock/Consolidated,
//Stock/Currency, Stock/Consolidated

  Result := FindAcStockRecords(sAcCode, sStockCode, sDate, Currency);
  if Result.Count = 0 then //No discounts for this Account code - try blank account code
  begin
    Result.Free;

    Result := FindAcStockRecords('', sStockCode, sDate, Currency);
  end;
end;

function TMultiBuyFunctions.GetCostPrice(const sStockCode : string): Double;
begin
  Result := 0;
{$IFNDEF EXDLL}
  {$IFNDEF EBAD}
  if Trim(Stock.StockCode) <> Trim(sStockCode) then
     CheckRecExsists(FMBDRec.mbdStockCode, StockF, StkCodeK);

  Result := Round_Up(FIFO_GetCost(Stock,Stock.PCurrency,1,1,''),Syss.NoCosDec);
  {$ENDIF}
{$ENDIF}
end;

function TMultiBuyFunctions.UnderCostPrice(const sStockCode : string; var CostP : Double; var SellP : Double): Boolean;
var
  UPrice, Disc, Qty : Real;
  DiscCh : Char;
  FoundOK : Boolean;
begin
  Result := False;
{$IFNDEF EXDLL}
  {$IFNDEF EBAD}
  if Trim(Stock.StockCode) <> Trim(sStockCode) then
     CheckRecExsists(sStockCode, StockF, StkCodeK);

  if FMBDRec.mbdDiscountType = mbtGetFree then
    Qty := FMBDRec.mbdBuyQty + FMBDRec.mbdRewardValue
  else
    Qty := FMBDRec.mbdBuyQty;

  Calc_StockPrice(Stock, Cust, 0, Qty, Today, UPrice, Disc, DiscCh, '', FoundOK, 0);

  CostP := GetCostPrice(Stock.StockCode);
  SellP := MBDUnitPrice(UPrice - Calc_PAmount(UPrice, Disc, DiscCh), Syss.NoCosDec);

  Result := SellP < CostP;
  {$ENDIF}
{$ENDIF}
end;

procedure TMultiBuyFunctions.CheckPricesForAccount(const sAcCode: string);
var
  Res : Integer;
  KeyS, KeyChk : Str255;
begin
  WantToAbort := False;
  KeyS := FullCustCode(sAcCode);
  KeyChk := KeyS;
  Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, FMBDRec, mbdAcCodeK, KeyS);
  while not WantToAbort and (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
  begin
    CheckStockPrices(FMBDRec.mbdStockCode, sAcCode);

    Res := Find_Rec(B_GetNext, F[MultiBuyF], MultiBuyF, FMBDRec, mbdAcCodeK, KeyS);
  end;
end;

procedure TMultiBuyFunctions.CheckStockPrices(const sStockCode: string; const CustCode : string = '');
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  CostP, SellP : Double;
  RecAddr : longint;
  LocalCust : CustRec;

  procedure ShowWarning;
  begin
     WantToAbort := MessageDlg(' - WARNING! Selling Price too Low! - '+#13+#13+
                        Trim(sStockCode)+ ' Multi-Buy Discount' +#13+#13+
                        'Cost Price : '+Form_Real(CostP,0,2)+' Sell Price : '+Form_Real(SellP,0,2)
                        ,mtWarning,[mbOk,mbAbort], 0) = mrAbort;
  end;
begin
  //PR: 13/08/2009 If we're checking from stock, then Global Cust Record will have Supplier in it - so need to
  //blank it out before calculating price - otherwise we'll get the cost price as the sell price. Don't forget to
  //restore it afterwards.
  if CustCode = '' then
  begin
    LocalCust := Cust;
    FillChar(Cust, SizeOf(Cust), 0);
  end;
  Try
    KeyS := FullStockCode(sStockCode);
    if Trim(Stock.StockCode) <> Trim(sStockCode) then
       CheckRecExsists(FMBDRec.mbdStockCode, StockF, StkCodeK);

    if Stock.StockType = StkGrpCode then
    begin
      KeyChk := KeyS;
      GetPos(F[StockF],StockF,RecAddr);
      Res := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCATK,  KeyS);
      while not WantToAbort and (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
      begin
        if UnderCostPrice(Stock.StockCode, CostP, SellP) then
          ShowWarning;

        Res := Find_Rec(B_GetNext, F[StockF], StockF, RecPtr[StockF]^, StkCATK,  KeyS);
      end;
      SetDataRecOfs(StockF,RecAddr);
      Res := GetDirect(F[StockF],StockF,RecPtr[StockF]^,0,0);
    end
    else
    if UnderCostPrice(Stock.StockCode, CostP, SellP) then
      ShowWarning;
  Finally
    //Restore Global Cust Rec
    if CustCode = '' then
      Cust := LocalCust;
  End;
end;

procedure TMultiBuyFunctions.BlockDelete(IsStock : Boolean; AOwner : TComponent; MsgHandle : THandle);
var
  RepMode : Integer;
  Filter : Str255;
begin
{$IFNDEF EXDLL}
  {$IFNDEF EBAD}
  if IsStock then
  begin
    RepMode := 0;
    Filter := Stock.StockCode;
  end
  else
  begin
    if Cust.CustSupp = TradeCode[True] then
      RepMode := 1
    else
      RepMode := 2;
    Filter := Cust.CustCode;
  end;
  Del_MultiBuyDiscount(RepMode, Filter, AOwner, MsgHandle);
  {$ENDIF}
{$ENDIF}
end;

procedure TMultiBuyFunctions.CheckPricesForStock(const sStockCode: string);
var
  Res : Integer;
  KeyS, KeyChk : Str255;
begin
  WantToAbort := False;
  KeyS := mbdPartStockCodeKey('', sStockCode);   //PR: 09/07/2009 Changed to use mbdPartStockCodeKey
  KeyChk := Copy(KeyS, 1, mbdAcStockKeyLen);

  Res := Find_Rec(B_GetGEq, F[MultiBuyF], MultiBuyF, FMBDRec, mbdAcCodeK, KeyS);
  while not WantToAbort and (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
  begin
    CheckStockPrices(FMBDRec.mbdStockCode);

    Res := Find_Rec(B_GetNext, F[MultiBuyF], MultiBuyF, FMBDRec, mbdAcCodeK, KeyS);
  end;
end;

{$If (not Defined(EXDLL)) or Defined(COMTK)}
function TMultiBuyFunctions.DoGetMultiBuyList(const sAcCode,
  sStockCode, sTransDate: String; ExLocal : TdExLocalPtr; Currency : Integer = 0; Threaded : Boolean = True; IsSales : Boolean = True;
  WantedQty : Double = 0): TStringList;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  MultiBuyDiscountHolder : TMultiBuyDiscountHolder;
  DiscQty : Double;
  ThisQty : Integer;
  ThisLocal : TdExLocalPtr;
begin
  ThisLocal := nil;
  Result := TStringList.Create;
  KeyS := mbdStockCodeKey(sAcCode, sStockCode);
  KeyChk := Copy(KeyS, 1, mbdAcStockKeyLen);
  if not Assigned(ExLocal) then
  begin
    New(ThisLocal, Create);
    ExLocal := ThisLocal;
  end;
  Try
    if Threaded then
      Res := TdMTExLocalPtr(ExLocal).LFind_Rec(B_GetLessEq, MultiBuyF, mbdAcCodeK, KeyS)
    else
      Res := Find_Rec(B_GetLessEq,F[MultiBuyF],MultiBuyF,ExLocal.LRecPtr[MultiBuyF]^,mbdAcCodeK,KeyS);

    while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
    begin
      with ExLocal.LMultiBuyDiscount do    //PR: Added Currency = -1 to return any currency
        if ((Not mbdUseDates) or ((sTransDate>=mbdStartDate) and (sTransDate<=mbdEndDate))) and
           ((mbdDiscountType <> mbtForAmount) or (mbdCurrency = Currency) or (Currency = -1)) then
        begin
          //Work out how many of this discount we can have
          FMBDRec := ExLocal.LMultiBuyDiscount;
          DiscQty := GetDiscountQty;
          if (WantedQty = 0) or (DiscQty <= WantedQty) then
          begin
            ThisQty := 0;
            while DiscQty <= WantedQty do
            begin
              Inc(ThisQty);

              WantedQty := WantedQty - DiscQty;
            end;

            MultiBuyDiscountHolder := TMultiBuyDiscountHolder.Create;
            MultiBuyDiscountHolder.MBDRec := ExLocal.LMultiBuyDiscount;
            MultiBuyDiscountHolder.mbdQty := ThisQty;
            Result.AddObject( FormatMultiBuyString(ExLocal.LMultiBuyDiscount), MultiBuyDiscountHolder);
          end;

        end;

      if Threaded then
        Res := TdMTExLocalPtr(ExLocal).LFind_Rec(B_GetPrev, MultiBuyF, mbdAcCodeK, KeyS)
      else
        Res := Find_Rec(B_GetPrev,F[MultiBuyF],MultiBuyF,ExLocal.LRecPtr[MultiBuyF]^,mbdAcCodeK,KeyS);

    end;
  Finally
    if Assigned(ThisLocal) then
      Dispose(ThisLocal, Destroy);
  End;


end;

function TMultiBuyFunctions.GetMultiBuyList(const sAcCode,
  sStockCode, sTransDate: String; ExLocal : TdExLocalPtr; Currency : Integer = 0; Threaded : Boolean = True; IsSales : Boolean = True;
  WantedQty : Double = 0): TStringList;
begin
  //Account + Stock + Currency
  Result := DoGetMultiBuyList(sAcCode, sStockCode, sTransDate, ExLocal, Currency, Threaded, IsSales, WantedQty);

  //Account + Stock + Consolidated
  if Result.Count = 0 then
  begin
    Result.Free;
    Result := DoGetMultiBuyList(sAcCode, sStockCode, sTransDate, ExLocal, 0, Threaded, IsSales, WantedQty);
  end;

  //Stock + Currency
  if IsSales and (Trim(sAcCode) <> '') and (Result.Count = 0) then
  begin
    Result.Free;
    Result := DoGetMultiBuyList('', sStockCode, sTransDate, ExLocal, Currency, Threaded, IsSales, WantedQty);
  end;

  //Stock + Consolidated
  if IsSales and (Trim(sAcCode) <> '') and (Result.Count = 0) then
  begin
    Result.Free;
    Result := DoGetMultiBuyList('', sStockCode, sTransDate, ExLocal, 0, Threaded, IsSales, WantedQty);
  end;

end;

{$IfEnd}

function TMultiBuyFunctions.FormatMultiBuyString(
  ARec: TMultiBuyDiscount): String;
var
  BQDecs, RVDecs : Integer;
begin
{$If (not Defined(EXDLL)) or Defined(COMTK)}
  with ARec do
  begin
    BQDecs := Syss.NoQtyDec;
    RVDecs := IIF(mbdOwnerType = 'C', Integer(Syss.NoNetDec), Integer(Syss.NoCosDec));
    Case mbdDiscountType of
      mbtGetFree       : Result := Format('Buy %s Get %s Free', [Form_Real(mbdBuyQty,0,BQDecs), Form_Real(mbdRewardValue,0,BQDecs)]);
      mbtForAmount     : Result := Format('Buy %s For %s', [Form_Real(mbdBuyQty,0,BQDecs), TxLatePound(Trim(SyssCurr.Currencies[mbdCurrency].SSymb), True) +
                                                                                               Form_Real(mbdRewardValue,0,RVDecs)]);
      // MH 30/07/09: Modified percentage to display to 2dp instead of Qty Decs
      mbtGetPercentOff : Result := Format('Buy %s Get %s Off', [Form_Real(mbdBuyQty,0,BQDecs), Form_Real(100*mbdRewardValue,0,2) + '%' ]);
    end;
  end;
{$IfEnd}
end;

procedure TMultiBuyFunctions.FreeMultiBuyList(var AList: TStringList);
var
  i : integer;
begin
  for i := 0 to AList.Count - 1 do
    if Assigned(AList.Objects[i]) then
      AList.Objects[i].Free;
  FreeAndNil(AList);
end;

{ TMultiBuyDiscountHolder }

constructor TMultiBuyDiscountHolder.Create;
begin
  mbdQty := 0;
end;

function TMultiBuyFunctions.DiscountAvailable(BuyQty: Double): Boolean;
begin
  Result := DiscountQty <= BuyQty;
end;

function TMultiBuyFunctions.GetDiscountQty: Double;
begin
  if FMBDRec.mbdDiscountType = mbtGetFree then
    Result := FMBDRec.mbdBuyQty + FMBDRec.mbdRewardValue
  else
    Result := FMBDRec.mbdBuyQty;
end;

{$If (not Defined(EXDLL)) or Defined(COMTK)}
function TMultiBuyFunctions.ValueOfDiscount(LId : IDetail; Qty : Double): Double;
begin
  Result := UnitValueOfDiscount(LId, Qty) * Qty;
end;

function TMultiBuyFunctions.UnitValueOfDiscount(LId: IDetail;
  Qty: Double): Double;
var
  RVDecs : Integer;
  dBuyQty : Double;
  dRewardValue : Double;

  function IDNetValue : Double;
  var
    TmpQty : Double;
  begin
    LId.Discount2 := 0;
    LId.Discount2Chr := #0;
    TmpQty := {Ea2Case(LID, Stock, LId.Qty)}LID.Qty;
    if TmpQty <> 0 then
    begin
      //PR: 30/06/2009 Need special handling for Inclusive VAT
      if (LId.IncNetValue <> 0.00) and (LId.VATCode=VATMCode) then
        Result := (LID.IncNetValue - Calc_PAmount(LId.IncNetValue, Lid.Discount, Lid.DiscountChr))
      else
        Result := InvLTotalND(LId, True, 0, -1) / TmpQty;
    end
    else
      Result := 0;
  end;
begin
  Result := 0;
  dRewardValue := 0;
  with FMBDRec do
  begin
     dBuyQty := Case2Ea(LID, Stock, mbdBuyQty);
     if mbdDiscountType = mbtGetFree then
       dRewardValue := Case2Ea(LID, Stock, mbdRewardValue);
//    RVDecs := IIF(mbdOwnerType = 'C', Integer(Syss.NoNetDec), Integer(Syss.NoCosDec));
//    RVDecs := 2;

{    Case mbdDiscountType of
      mbtGetFree       : Result := Round_Up(mbdRewardValue * IDNetValue, RVDecs);
      mbtForAmount     : if Qty > 0 then
                           Result := Round_Up(((IDNetValue * mbdBuyQty) - mbdRewardValue),RVDecs)
                         else
                           Result := 0;
      mbtGetPercentOff : Result := Round_Up(IDNetValue  * mbdBuyQty * mbdRewardValue, RVDecs);
    end;}

    Case mbdDiscountType of
      mbtGetFree       : Result := dRewardValue * IDNetValue;
      mbtForAmount     : if Qty > 0 then
                           Result := ((IDNetValue * dBuyQty) - ConsolidatedToCurrency(mbdRewardValue, LId.Currency))
                         else
                           Result := 0;
      mbtGetPercentOff : Result := IDNetValue  * dBuyQty * mbdRewardValue;
    end;
  end;
end;
{$IfEnd}

function TMultiBuyFunctions.DiscountsClash(const NewRec,
  ExistingRec: TMultiBuyDiscount): Integer;
//Check new mbd record againgst existing record. If there is a clash then return enough info to allow the user to know what to change:-
//Bit-specific result using rc constants (defined at the top of this file.)
var
  ClashFound, CurrencyOk, CurrencyClash,
  TypeClash, QtyClash : Boolean;

  procedure SetResult(Condition : Boolean; Value : Integer);
  begin
    if Condition then
      Result := Result or Value;
  end;

  function BothUseDates : Boolean;
  begin
    Result := NewRec.mbdUseDates and ExistingRec.mbdUseDates;
  end;

  function DatesClash : Boolean;
  begin
    Result := BothUseDates and (IsInDateRange(NewRec.mbdStartDate, ExistingRec.mbdStartDate, ExistingRec.mbdEndDate) or
              IsInDateRange(NewRec.mbdEndDate, ExistingRec.mbdStartDate, ExistingRec.mbdEndDate));
  end;
  
begin
  Result := 0; //Ok until we know better.

  //Can we ignore problems because currencies are different?
  CurrencyOK := (NewRec.mbdDiscountType <> mbtForAmount) or
                (NewRec.mbdCurrency = ExistingRec.mbdCurrency);

  //Check for same AcCode (including blank) and same StockCode.
  ClashFound := (NewRec.mbdAcCode = ExistingRec.mbdAcCode) and
                (NewRec.mbdStockCode = ExistingRec.mbdStockCode) and
                 CurrencyOK;

  if ClashFound then
  begin
    //Do we have a currency issue?
    CurrencyClash := (NewRec.mbdDiscountType = mbtForAmount) and
                     (ExistingRec.mbdDiscountType = mbtForAmount) and
                     (NewRec.mbdCurrency <> ExistingRec.mbdCurrency);

    TypeClash := (NewRec.mbdDiscountType <> ExistingRec.mbdDiscountType);

    QtyClash := (NewRec.mbdBuyQty = ExistingRec.mbdBuyQty);

    //If we have a clash then it will always occur if either record doesn't use a date range
    SetResult(TypeClash and (not NewRec.mbdUseDates or not ExistingRec.mbdUseDates), rcType);
    SetResult(QtyClash and (not NewRec.mbdUseDates or not ExistingRec.mbdUseDates), rcQty);

    //If we have a clash and both recs use date range, then it only matters if the date ranges clash
    SetResult(TypeClash and DatesClash, rcDate or rcType);
    SetResult(QtyClash and DatesClash, rcDate or RcQty);

    //If there is a currency clash then pass back that info
    SetResult((Result > 0) and CurrencyClash, rcCurrency);
  end;

end;

function TMultiBuyFunctions.ValidateDiscount(
  const NewRec: TMultiBuyDiscount; IsEdit : Boolean): Integer;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  RecAddr, RecAddr1 : longint;
  TempMultiBuy : TMultiBuyDiscount;
begin
  Result := 0;
  if IsEdit then
    GetPos(F[MultiBuyF],MultiBuyF,RecAddr) //Store current record address;
  else
    RecAddr := 0;
  TempMultiBuy := MultiBuyDiscount;
  KeyS := mbdStockCodeKey(NewRec.mbdAcCode, NewRec.mbdStockCode);
  KeyChk := Copy(KeyS, 1, mbdAcStockKeyLen);

  Res := Find_Rec(B_GetLessEq,F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,mbdAcCodeK,KeyS);

  while (Res = 0) and (Result = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) do
  begin

    GetPos(F[MultiBuyF],MultiBuyF,RecAddr1); //Store currenc record address;

    //If we're editing and this is the same record then no need to check
    if IsEdit and (RecAddr = RecAddr1) then
      Result := 0
    else
      Result := DiscountsClash(NewRec, MultiBuyDiscount);

    if Result = 0 then
      Res := Find_Rec(B_GetPrev,F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,mbdAcCodeK,KeyS);
  end;

  if IsEdit and (RecAddr > 0) then //need to restore position in file
  begin
    Move(RecAddr, MultiBuyDiscount, SizeOf(RecAddr));
    Res := GetDirect(F[MultiBuyF],MultiBuyF,RecPtr[MultiBuyF]^,0,0);
  end;
  //Restore original record contents
  MultiBuyDiscount := TempMultiBuy;
end;

function TMultiBuyFunctions.GetDiscountLineStrings(const sStockCode : string;
  const AList: TStringList): TStringList;
var
  i : integer;

  function InsertStockCode(const s : string) : string;
  var
    j : Integer;
  begin
    Result := s;
    j := 5;
    while (Result[j] <> ' ') do inc(j);
      Insert(Trim(sStockCode) + ' ', Result, j + 1);
  end;

begin
  Result := TStringList.Create;
  if Assigned(AList) then
  begin
    for i := 0 to AList.Count - 1 do
      if (AList.Objects[i] as TMultiBuyDiscountHolder).mbdQty > 0 then
        with  (AList.Objects[i] as TMultiBuyDiscountHolder) do
          Result.Add(QtyString(mbdQty) + InsertStockCode(AList[i]));
  end;
end;


procedure TMultiBuyFunctions.GetUnitDiscountValue(const AList: TStringList;
                                                 {$IFDEF COMTK}
                                                  const TLRec : TBatchTLRec;
                                                  {$ELSE}
                                                  const TLRec : IDetail;
                                                  {$ENDIF}
                                                  var DiscValue: Double;
                                                  var DiscChr: Char);
var
  i : Integer;
  TotalDiscount : Double;
  d1, d2, d3 : Double;
  dNetValue : Double;
begin
  TotalDiscount := 0;
  if (AList.Count > 0) and (AList.Objects[0] is TMultiBuyDiscountHolder) then
  begin
    if (AList.Count = 1) and ((AList.Objects[0] as TMultiBuyDiscountHolder).MBDRec.mbdDiscountType = mbtGetPercentOff) then
    begin
      DiscValue := (AList.Objects[0] as TMultiBuyDiscountHolder).MBDRec.mbdRewardValue;
      DiscChr := '%';
    end
    else
    begin

      for i := 0 to AList.Count - 1 do
      with (AList.Objects[i] as TMultiBuyDiscountHolder) do
      begin
        FMBDRec := MBDRec;
        with TLRec do
        begin
          //PR: 16/07/2009 If using Inclusive VAT then we come in a second time with NetValue already adjusted -
          // so in that case use IncNetValue to calc Discount
          if (VATCode = 'M') and (IncNetValue <> 0) then
            dNetValue := IncNetValue
          else
            dNetValue := NetValue;
          d1 := mbdQty;
          d2 := GetDiscountQty;
          d3 := dNetValue - Calc_PAmount(dNetValue, Discount, DiscountChr);
          TotalDiscount := TotalDiscount + (d1 * d2 * (d3 - ConsolidatedToCurrency(MBDUnitPrice(d3, 12), TLRec.Currency)));
{          TotalDiscount := TotalDiscount +  (mbdQty * GetDiscountQty *
                           (NetValue - Calc_PAmount(NetValue, Discount, DiscountChr) -
                            MBDUnitPrice(NetValue - Calc_PAmount(NetValue, Discount, DiscountChr), 2)));}
        end;

      end;
//      DiscValue := Round_Up(TotalDiscount / TLRec.Qty, 2);
      DiscValue := TotalDiscount / TLRec.Qty;
      DiscChr := ' ';
    end;
  end;
end;

  Procedure Set_UpId(IdR    :  IDetail;
                 Var TmpId  :  IDetail);


  Begin

    Blank(TmpId,Sizeof(TmpId));

    With TmpId do
    Begin

      FolioRef:=IdR.FolioRef;

      DocPRef:=IdR.DocPRef;

      IDDocHed:=IdR.IDDocHed;

      LineNo:=Succ(IdR.LineNo);

      Currency:=IdR.Currency;

      CXRate:=IdR.CXRate;

      CurrTriR:=IdR.CurrTriR;

      {$IFDEF STK}
        LineType:=StkLineType[IdDocHed];
      {$ENDIF}

      ABSLineNo:=0;

      PYr:=IdR.PYr;
      PPr:=IdR.PPr;

      Payment:=IdR.Payment;

      Reconcile:=IdR.Reconcile;

      CustCode:=IdR.CustCode;

      PDate:=IdR.PDate;

      DocLTLink:=IdR.DocLTLink;

      MLocStk:=IdR.MLocStk;
    end; {With..}

  end; {Proc..}


{$If (not Defined(EXDLL)) or Defined(COMTK)}
function TMultiBuyFunctions.AddMultiBuyDescLines(var InvR: InvRec;
  IDR: IDetail; StockFolio: Integer; const MBDList : TStringList; ExLocal : TdExLocalPtr = nil) : Integer;
{$Else}
function TMultiBuyFunctions.AddMultiBuyDescLines(var InvR: InvRec;
  IDR: IDetail; StockFolio: Integer; const MBDList : TStringList) : Integer;
{$IfEnd}
var
  Res, i : Integer;
  AList : TStringList;
  TmpID, TmpID2 : IDetail;
  CurrentLineNo : longint;
  TmpKeyPath : Integer;
  TmpRecAddr : Longint;
begin
  TmpID2 := ID;
  TmpKeyPath := GetPosKey;
  Res := Presrv_BTPos(IDetailF, TmpKeyPath, F[IDetailF], TmpRecAddr, False, False);
  CurrentLineNo := IDR.LineNo;
  AList := GetDiscountLineStrings(IDR.StockCode, MBDList);
  Result := AList.Count;
  Try
    if AList.Count > 0 then
    begin
      for i := 0 to AList.Count - 1 do
      begin
        FillChar(TmpID, SizeOf(TmpID), 0);
        Set_UpId(Idr, TmpID);
        TmpId.DocltLink := 0;
{        Inc(CurrentLineNo, 2);
        TmpID.LineNo:= CurrentLineNo;
        TmpID.ABSLineNo :=CurrentLineNo;}
      TmpID.LineNo:= IDR.LineNo + 2 + (2 * i);
      TmpID.ABSLineNo:=InvR.ILineCount;
      Inc(InvR.ILineCount, 2);

      //PR: 16/06/2009 - shouldn't have vat code
//        TmpID.VatCode := Idr.VatCode;

        TmpID.Desc := AList[i];
        TmpID.Qty := IdR.Qty;
        TmpID.QtyMul := IdR.QtyMul;


        TmpID.KitLink := IDr.FolioRef;
        TmpID.Discount3Type := mbdDescLineID;
{$If (not Defined(EXDLL)) or Defined(COMTK)}
        if not Assigned(ExLocal) then
        begin
          Res := Add_Rec(F[IDetailF], IDetailF, TmpID, -1);
        end
        else
        with TdMTExLocalPtr(ExLocal)^ do
        begin
          LID := TmpID;
          Res := LAdd_Rec(IDetailF, -1);
          LID := IDR;
        end;
{$Else}
       Res := Add_Rec(F[IDetailF], IDetailF, TmpID, -1)
{$IfEnd}
      end;
      Inc(InvR.ILineCount, AList.Count * 2);
    end;
  Finally
    AList.Free;
    Res := Presrv_BTPos(IDetailF, TmpKeyPath, F[IDetailF], TmpRecAddr, True, False);
  End;
end;

function TMultiBuyFunctions.ConsolidatedToCurrency(Value : Double; Currency : Byte) : Double;
begin
  Result := Value;
  if (FMBDRec.mbdDiscountType = mbtForAmount) and (FMBDRec.mbdCurrency = 0) then
    Result := Currency_ConvFT(Value, 0, Currency, UseCoDayRate);
end;

function TMultiBuyFunctions.DeleteDescLines(LID: IDetail) : Integer;
var
  Res : Integer;
  KeyS, KeyChk : ShortString;
  sStock : string;
  TmpRecAddr : longint;
  TmpKeyPath : Integer;
  TmpId : IDetail;

  function IsCorrectDescriptionLine : Boolean;
  begin
    Result := (Trim(ID.StockCode) = '') and (Id.Discount3Type = 255) and (Id.Qty = LId.Qty) and
              (Pos(Trim(LID.StockCode), ID.Desc) > 0); //PR: 09/07/2009 Need to Trim LID.StockCode when looking for it in ID.Desc
  end;
begin
  TmpID := ID;
  TmpKeyPath := GetPosKey;
  Res := Presrv_BTPos(IDetailF, TmpKeyPath, F[IDetailF], TmpRecAddr, False, False);
  Try
    Result := 0;
    KeyS := FullNomKey(LID.FolioRef);
    KeyChk := KeyS;

    Res :=  Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);

    while (Res = 0) and CheckKey(KeyS, KeyChk, Length(KeyChk), True) do
    begin
      if IsCorrectDescriptionLine then
      begin
        Delete_Rec(F[IDetailF],IDetailF,IdFolioK);
        Inc(Result);
      end;

      Res :=  Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^,IdFolioK,KeyS);
    end;
  Finally
    Res := Presrv_BTPos(IDetailF, TmpKeyPath, F[IDetailF], TmpRecAddr, True,False);
  End;
  ID := TmpID;
end;



end.
