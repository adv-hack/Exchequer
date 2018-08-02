unit oTakePPD;

interface

uses
  VarConst, Dialogs, ExBtth1U;

type

  //Public interface for take ppd
  ITakePPD = Interface
  ['{250E4B91-9D3A-4BD5-89BB-45B0EC4D1331}']
    //PR: 16/06/2015 ABSEXCH-16546 Changed ExLocal to TdPostExLocal as we need to update account balance
    function GetExLocal : TdPostExLocalPtr;
    procedure SetExLocal(const Value : TdPostExLocalPtr);

    function GetAccount : CustRec;
    procedure SetAccount(Value : CustRec);

    function GetDate : string;
    procedure SetDate(const Value : string);

    function GetCreditNote : InvRec;

    function GetPayRec : InvRec;
    procedure SetPayRec(Value : InvRec);

    function GetYear : Byte;
    procedure SetYear(Value : Byte);

    function GetPeriod : Byte;
    procedure SetPeriod(Value : Byte);

    function GetErrorString : string;

    function Execute : Integer;

    procedure AddInvoice(AnInvoice : InvRec; TakePPD : Boolean = True);
    procedure RemoveInvoice(OurRef : string);
    function GetInvoiceCount : Integer;

    property tpCreditNote : InvRec read GetCreditNote;
    property tpExLocal : TdPostExLocalPtr read GetExLocal write SetExLocal;
    property tpAccount : CustRec read GetAccount write SetAccount;
    property tpDate : string read GetDate write SetDate;
    property tpErrorString : string read GetErrorString;
    property tpInvoiceCount : Integer read GetInvoiceCount;
    property tpPayRec : InvRec read GetPayRec write SetPayRec;
    property tpYear : Byte read GetYear write SetYear;
    property tpPeriod : Byte read GetPeriod write SetPeriod;


  end;

  function GetTakePPD : ITakePPD;


implementation

uses
  Classes, Contnrs, SysUtils, EtMiscU, PromptPaymentDiscountFuncs, Math, AuditNotes, SysU1, EtDateU, ComnUnit,
   TransactionOriginator, CurrncyU, GlobVar, btKeys1U, BtrvU2, BtSupU1, MiscU, BtSupu2
   {$IFNDEF COMTK}, Event1U, Saltxl1U{$ENDIF};

{$IFDEF COMTK}
const
  GenRealMask   =  '###,###,###,##0.00 ;###,###,###,##0.00-';
{$ENDIF}

type
  //Class to hold a single invoice record
  TInvoiceObject = Class
  public
    Invoice : InvRec;
    TakePPD : Boolean; //Taking PPD or not
  end;

  //List of invoice records
  TInvoiceList = Class(TObjectList)
  private
    function GetHasPPD: Boolean;
  protected
    function GetItem(Index : Integer) : TInvoiceObject;
    procedure SetItem(Index: Integer; Value: TInvoiceObject);
  public
    function Add( Value: TInvoiceObject): Integer;
    property Items[Index: Integer]: TInvoiceObject read GetItem write SetItem; default;
    property HasPPD : Boolean read GetHasPPD;
  end;

  //Class to hold line details consolidated by VAT Code/CC/Dept
  TLineDetails = Class
    VATCode  : Char;
    VatIndex : VATType;
    VATRate  : Double;
    CostCentre : String[3];
    Department : String[3];
    GoodsValue : Double;
    VATValue : Double;
  end;

  //List of line details records
  TLineDetailsList = Class(TObjectList)
  protected
    function GetItem(Index : Integer) : TLineDetails;
    procedure SetItem(Index: Integer; Value: TLineDetails);
  public
    function Add( Value: TLineDetails): Integer;
    function Find(IdR : IDetail) : Integer;
    property Items[Index: Integer]: TLineDetails read GetItem write SetItem; default;
  end;

  //Main class to implement giving/taking of PPD
  TTakePPD = Class(TInterfacedObject, ITakePPD)
  protected
    FCurrentInv : InvRec;
    FCreditNote : InvRec;
    FCreditNoteLine : IDetail;
    FExLocal : TdPostExLocalPtr;
    FCreditNoteType : DocTypes;
    FFullInvoiceList : TInvoiceList;
    FInvoiceList : TInvoiceList;
    FAccount : CustRec;
    FDate : string;
    FDetailsList : TLineDetailsList;
    FInvPPDGoods : Double;
    FInvPPDVAT : Double;
    FErrorString : string;
    FOwnExLocal : Boolean;
    // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
    {$IFDEF CU}
      FTransactionNotificationList : TInvoiceList;
    {$ENDIF CU}

    FYear, FPeriod : Byte;

    FPayRec : InvRec;
    FCurrencySettledTotal : Real48;
    FBaseSettledTotal : Real48;
    FCreditSettled : Real48; //Settled amount for all credit notes
    //Local functions
    function Allocate : Integer;
    function StartTransaction : Integer;
    function CommitTransaction : Integer;
    function AbortTransaction : Integer;
    function AddCreditNote : integer;
    function StoreCreditNote : integer;
    function AddLine(oLineDetails : TLineDetails; LastLine : Boolean) : integer;
    procedure InitialiseLine;
    function ProcessOneInvoice(InvNo : Integer) : Integer;
    function UpdateInvoice(InvNo : Integer) : Integer;
    function AddAllocationRecord(InvNo : Integer) : Integer;
    function ConvertToBase(Value : Double) : Double;
    function AddAuditNote(const CustomText : string = '') : Integer;

    procedure LoadLines(InvNo : Integer);
    procedure LoadInvoicesForNextCurrency;
    function ProcessInvoicesByCurrency : Integer;

    //PR: 08/07/2015 Add functions to calculate variance once all transactions have been settled
    function CalculateVariance : Real48;
    function AddVarianceLine(Variance : Real48) : Integer;
    function UpdatePayRec : Integer;

    procedure SetDateAndPeriod;

    procedure CreateExLocal;

    //Interface implementation
    procedure AddInvoice(AnInvoice : InvRec; TakePPD : Boolean = True);
    procedure RemoveInvoice(OurRef : string);

    function GetInvoiceCount : Integer;

    function GetExLocal : TdPostExLocalPtr;
    procedure SetExLocal(const Value : TdPostExLocalPtr);

    function GetAccount : CustRec;
    procedure SetAccount(Value : CustRec);

    function GetDate : string;
    procedure SetDate(const Value : string);

    function GetCreditNote : InvRec;
    function GetErrorString : string;

    function GetYear : Byte;
    procedure SetYear(Value : Byte);

    function GetPeriod : Byte;
    procedure SetPeriod(Value : Byte);

    function GetPayRec : InvRec;
    procedure SetPayRec(Value : InvRec);

    constructor Create;
    destructor Destroy; override;

    function Execute : Integer;
  end;

{$IFDEF COMTK}
Function FormatCurFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean;
                        Cr     :  Byte)  :  Str255;


Var
  GenStr  :  Str5;

Begin
  GenStr:='';

  GenStr:=SSymb(Cr);
  If (Value<>0.0) or (Not SBlnk) then
    Result:=GenStr+FormatFloat(Fmask,Value)
  else
    Result:='';

end;
{$ENDIF}

//Function to return an instance of a PPD interface
function GetTakePPD : ITakePPD;
begin
  Result := TTakePPD.Create;
end;

//Callback function to sort the details list by VAT Rate
function SortLineDetails(Item1, Item2: Pointer): Integer;
begin
  Result := Sign(TLineDetails(Item1).VATRate - TLineDetails(Item2).VATRate);
end;

//Callback function to sort the full invoice list by currency
//PR: 26/06/2015 ABSEXCH-16590 Amended to also sort by Daily Rate
//PR: 02/09/2015 ABSEXCH-16811 Amended to also sort by Ctrl GL. Changed to use string for sorting
function SortInvoices(Item1, Item2: Pointer): Integer;
var
  Item1CurrAndRate,
  Item2CurrAndRate : String[11];

  // Function to return a key string constructed from 3 invoice fields:
  // String[11] - Chars 1-4 = CtrlGL (longint); 5 = Currency (Byte); 6-11 = Daily Rate (Real48)
  // Order is unimportant so long as invoices with the same CtrlGL, Currency and Daily Rate are grouped together
  function FillKey(const AnInvoice : InvRec) : ShortString;
  begin
    Result := StringOfChar(' ', 11);
    with AnInvoice do
    begin
      Move(CtrlNom,  Result[1], SizeOf(CtrlNom));
      Move(Currency, Result[5], SizeOf(Currency));
      Move(CXRate[True],  Result[6], SizeOf(CXRate[True]));
    end;
  end;

begin
  Item1CurrAndRate := FillKey(TInvoiceObject(Item1).Invoice);
  Item2CurrAndRate := FillKey(TInvoiceObject(Item2).Invoice);

  if Item1CurrAndRate >  Item2CurrAndRate then
    Result := 1
  else
  if Item1CurrAndRate = Item2CurrAndRate then
    Result := 0
  else
    Result := -1;
end;


{ TTakePPD }

function TTakePPD.AbortTransaction: Integer;
begin
  Result := FExLocal.LCtrl_BTrans(2);
end;

//Adds one matching record between the credit note and the invoice indicated by InvNo
function TTakePPD.AddAllocationRecord(InvNo: Integer): Integer;
begin
  with FExLocal^ do
  begin
    LResetRec(PWrdF);

    LPassWord.RecPFix:=MatchTCode;
    LPassWord.SubType := MatchSCode;

    LPassword.MatchPayRec.MatchType := 'A';
    LPassword.MatchPayRec.DocCode := FInvoiceList[InvNo].Invoice.OurRef;
    LPassword.MatchPayRec.PayRef := FCreditNote.OurRef;

    LPassword.MatchPayRec.MCurrency := FInvoiceList[InvNo].Invoice.Currency;
    LPassword.MatchPayRec.RCurrency := 0;

    //PR: 04/06/2015 Added DocCnst... to ensure sign is correct
    LPassword.MatchPayRec.OwnCVal := Round_Up((FInvoiceList[InvNo].Invoice.thPPDGoodsValue +
                                              FInvoiceList[InvNo].Invoice.thPPDVATValue) * DocCnst[FInvoiceList[InvNo].Invoice.InvDocHed] * DocNotCnst, 2);
    LPassword.MatchPayRec.SettledVal := ConvertToBase(LPassword.MatchPayRec.OwnCVal);
//    LPassword.MatchPayRec.SettledVal := Round_Up(FCreditNote.Settled + SimpleVariance(FInvoiceList[InvNo].Invoice), 2);

    Result := LAdd_Rec(PWrdF, -1);
  end;
end;

//Add an audit note for the transaction currently in ExLocal
//PR: 15/03/2016 v2016 R1 patch ABSEXCH-17310 The standard call to audit note uses the global files, so
// won't be in the transaction. Change to do all the work here using ClientId and local files
function TTakePPD.AddAuditNote(const CustomText : string = ''): Integer;
Var
  oAuditNote : TAuditNote;
begin
  oAuditNote := TAuditNote.Create(EntryRec.Login, @FExLocal.LocalF[PwrdF], FExLocal.ExClientId);
  Try
    Result := oAuditNote.AddCustomAuditNote(AnTransaction, FExLocal.LInv.FolioNum, CustomText);
  Finally
    oAuditNote.Free;
  End;
end;

//Initialise credit note header
function TTakePPD.AddCreditNote: integer;
begin
  Result := 0;
  FillChar(FCreditNote, SizeOf(FCreditNote), 0);

  //Work out doc type
  case FAccount.acPPDMode of
    pmPPDEnabledWithAutoJournalCreditNote : if FAccount.CustSupp = 'C' then
                     FCreditNote.InvDocHed := SJC
                   else
                     FCreditNote.InvDocHed := PJC;

    pmPPDEnabledWithAutoCreditNote : FCreditNote.InvDocHed := SCR;
    pmPPDEnabledWithManualCreditNote : Exit; //Not auto-creating a credit note
    else
    begin
      FErrorString := 'This account does not have PPD enabled.';
      Result := 30001;
    end;
  end; //case

  if Result = 0 then
  begin
    //Customer fields
    FCreditNote.CustCode := FAccount.CustCode;
    FCreditNote.CustSupp := FAccount.CustSupp;

    //Date fields
    FCreditNote.TransDate := FDate;
    FCreditNote.DueDate := FDate;

    //Currency
    FCreditNote.Currency := FInvoiceList[0].Invoice.Currency;

    //PR: ABSEXCH-16590 Take xrate from the invoice
    FCreditNote.CXRate := FInvoiceList[0].Invoice.CXRate;

    //PR: 02/09/2015 2015 R1 ABSEXCH-16811 Take Vat xrate from invoice
    FCreditNote.VATCRate := FInvoiceList[0].Invoice.VATCRate;

    //PR: 02/09/2015 2015 R1 ABSEXCH-16813 Copy Control GL from first invoice
    FCreditNote.CtrlNom := FInvoiceList[0].Invoice.CtrlNom;


    //OurRef and folio
    //PR: 26/06/2015 Change to use Client ID so done in db transaction
    FExLocal.LSetNextDocNos(FCreditNote, True);

    //Set year & period from date
    FCreditNote.AcPr := FPeriod;
    FCreditNote.AcYr := FYear;

    //Other stuff
    FCreditNote.NomAuto := True;
    FCreditNote.OpName := EntryRec^.Login;
    SetOriginator(FCreditNote);

    FCreditNote.thPPDCreditNote := True;

  end;

end;

//Adds one invoice to the list
procedure TTakePPD.AddInvoice(AnInvoice : InvRec; TakePPD : Boolean = True);
var
  InvObj : TInvoiceObject;
begin
    InvObj := TInvoiceObject.Create;
    InvObj.Invoice := AnInvoice;
    InvObj.TakePPD := TakePPD;
    FFullInvoiceList.Add(InvObj);
end;

//Adds and stores a line for the credit note
function TTakePPD.AddLine(oLineDetails : TLineDetails; LastLine : Boolean): integer;
begin
  with FExLocal.LId do
  begin

    //Increment line numbers
    AbsLineNo := AbsLineNo + 2;
    LineNo := LineNo + 2;

    //Set values
    NetValue := Round_Up(oLineDetails.GoodsValue * FCurrentInv.thPPDPercentage, 2);
    VAT := Round_Up(oLineDetails.VATValue * FCurrentInv.thPPDPercentage, 2);

    //Reduce total ppd values
    FInvPPDGoods := Round_Up(FInvPPDGoods - NetValue, 2);
    FInvPPDVAT := Round_Up(FInvPPDVAT - VAT, 2);

    //If this is the last line then add anything left over
    if LastLine then
    begin
      if Round_Up(FInvPPDGoods, 2) <> 0.00 then
        NetValue := Round_Up(NetValue + FInvPPDGoods, 2);
      if Round_Up(FInvPPDVAT, 2) <> 0.00 then
        VAT := Round_Up(VAT + FInvPPDVAT, 2);
    end;

    //Vat & description
    VATCode := oLineDetails.VatCode;
    CCDep[True] := oLineDetails.CostCentre;
    CCDep[False] := oLineDetails.Department;

    //Description
    if Syss.UseCCDep then
      Desc := Format('PPD %sn against %s VAT Code:%s CC:%s Dep:%s',
                     [PPDGiveTakeWord(FCurrentInv.CustSupp, False),
                     FCurrentInv.OurRef,
                     oLineDetails.VATCode,
                     oLineDetails.CostCentre,
                     oLineDetails.Department]
                     )
    else
      Desc := Format('PPD %sn against %s VAT Code:%s',
                     [PPDGiveTakeWord(FCurrentInv.CustSupp, False),
                     FCurrentInv.OurRef,
                     oLineDetails.VATCode]
                     );

    //Add record
    Result := FExLocal.LAdd_Rec(IDetailF, 0);

    //Update header totals
    FCreditNote.InvVatAnal[oLineDetails.VatIndex] := Round_Up(FCreditNote.InvVatAnal[oLineDetails.VatIndex] + VAT, 2);
    FCreditNote.InvNetVal := Round_Up(FCreditNote.InvNetVal + NetValue, 2);
    FCreditNote.InvVAT := Round_Up(FCreditNote.InvVAT + VAT, 2);
  end; //with FExLocal.LId
end;

function TTakePPD.AddVarianceLine(Variance: Real48): Integer;
var
  lKeyS,lKeyChk : Str255;
  lCC,lDep : String;
  lRes : Integer;
begin
  //SS:20/07/2017:2017-R2:ABSEXCH-18679:Currency Variance line doesn't populate CC/Dept when PPD applied
  //Fetch CC/Dep from the assosiated payment line item. 
  if Syss.UseCCDep then
  begin      
    lKeyS := FullNomKey(FPayRec.FolioNum);
    lKeyChk := lKeyS;

    lRes := FExLocal.LFind_Rec(B_GetGEq, IDetailF, IdFolioK, lKeyS);
    with FExlocal^,Lid do
    begin
      if (lRes = 0) and (Copy(lKeyS, 1, Length(lKeyChk)) = lKeyChk) then
      begin
        lCC  :=  CCDep[True];
        lDep :=  CCDep[False];
      end;
    end;

  end;

  //Add a variance line to the SRC/PPY
  with FExlocal^.LId do
  begin
    FillChar(FExlocal^.LId, SizeOf(FExlocal^.LId), 0);

    FolioRef := FPayRec.FolioNum;
    DocPRef := FPayRec.OurRef;
    IdDocHed := FPayRec.InvDocHed;
    AbsLineNo := FPayRec.ILineCount;
    LineNo := RecieptCode;
    Qty := 1;
    QtyMul := 1;
    QtyPack := 1;


    //SS:20/07/2017:2017-R2:ABSEXCH-18679:Currency Variance line doesn't populate CC/Dept when PPD applied.
    if Syss.UseCCDep then
    begin
      CCDep[True] := lCC;
      CCDep[False] := lDep;
    end;


    CustCode := FPayRec.CustCode;
    PDate := FPayRec.TransDate;
    Currency := 1; //PR: 14/07/2015 ABSEXCH--16662 Variance currency must be 1 not 0

    CXRate[True] := 1;
    CXRate[False] := 1;
    NomCode := Syss.NomCtrlCodes[CurrVar];
    Payment:=DocPayType[IdDocHed];


    NetValue := Variance;

    Result := FExLocal.LAdd_Rec(IDetailF, -1);

    if Result <> 0 then
      FErrorString := 'Error ' + IntToStr(Result) + ' occurred when adding variance line to  ' + FPayRec.OurRef;
  end;
end;

function TTakePPD.Allocate: Integer;
var
  i : Integer;
begin
  Result := 0;
  //credit note is fully settled
  FCreditNote.CurrSettled := Round_Up(FCreditNote.InvNetVal + FCreditNote.InvVAT, 2) * DocCnst[FCreditNote.InvDocHed] * DocNotCnst;
  FCreditNote.Settled := BaseTotalOS(FCreditNote);
  FCreditSettled := FCreditSettled + FCreditNote.Settled;

  //Update invoices and add matching
  for i := 0 to FInvoiceList.Count - 1 do
  begin
    Result := UpdateInvoice(i);
    if (Result = 0) and FInvoiceList[i].TakePPD then
      Result := AddAllocationRecord(i);
    if Result <> 0 then
      Break;
  end;
end;
//Calculate variance on all settled amounts
function TTakePPD.CalculateVariance: Real48;
begin
  //Only check for variance if invoices or payments aren't in base currency

  //PR: 14/08/2015 ABSEXCH-16758 Removed DocCnst[] * DocNotCnst to ensure variance has correct sign
  if (FPayRec.Currency > 1) or (FCreditNote.Currency > 1) then
    Result := Round_Up((Abs(FBaseSettledTotal) - Abs(FPayRec.Settled + FCreditSettled)), 2)
  else
    Result := 0.0;
end;

function TTakePPD.CommitTransaction: Integer;
begin
  Result := FExLocal.LCtrl_BTrans(0);
end;

function TTakePPD.ConvertToBase(Value : Double) : Double;
begin
{$IFDEF MC_ON}
  Result := Currency_Txlate(Value, FCurrentInv.Currency, 1);
{$ELSE}
  Result := Value;
{$ENDIF}
end;

constructor TTakePPD.Create;
begin
  inherited;
  FInvoiceList := TInvoiceList.Create;

  FFullInvoiceList := TInvoiceList.Create;
  FFullInvoiceList.OwnsObjects := False;

  FDetailsList := TLineDetailsList.Create;
  FErrorString := '';

  // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
  {$IFDEF CU}
    FTransactionNotificationList := TInvoiceList.Create;
  {$ENDIF CU}

  FExLocal := nil;
  FOwnExLocal := False;

  FCurrencySettledTotal := 0;
  FBaseSettledTotal := 0;
  FCreditSettled := 0;

  FillChar(FPayRec, SizeOf(FPayRec), 0);

  FYear := 0;
  FPeriod := 0;
end;

procedure TTakePPD.CreateExLocal;
begin
  New(FExLocal, Create(92));
  FExLocal.Open_System(CustF, SysF);
  FOwnExLocal := True;
end;

destructor TTakePPD.Destroy;
begin
  // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
  {$IFDEF CU}
    FTransactionNotificationList.Free;
  {$ENDIF CU}

  FInvoiceList.Free;
  FFullInvoiceList.Free;
  FDetailsList.Free;

  inherited;
end;

function TTakePPD.Execute: Integer;
var
  i : integer;
  Res : Integer;

  TmpRecAddr : longint;
  KeyPath : Integer;

begin
  {$IFDEF COMTK}
  //Need to initialise currency list for toolkit
  Init_STDCurrList;
  {$ENDIF}

  if not Assigned(FExLocal) then
    CreateExLocal;

  Try
    SetDateAndPeriod;
    Result := StartTransaction;
    if Result = 0 then
    Try
      //Store position in trans file
      //PR: 15/07/2015 ABSEXCH-16670 Change to use new LPresrv_BTPosLocal functino to avoid overwriting global inv record
      with FExLocal^ do
        if not FOwnExLocal then
          LStatus := LPresrv_BTPosLocal(InvF, Keypath, LocalF^[InvF], TmpRecAddr, False, False);

      FFullInvoiceList.Sort(SortInvoices);
      Result := ProcessInvoicesByCurrency;
    Finally
      //PR: 08/07/2015 Call UpdatePayRec to set any variance required
      //PR: 18/09/2015 ABSEXCH-16886 if it's Manual PCR mode then we don't need to update the PPY.
      if (Result = 0) and (FAccount.acPPDMode <> pmPPDEnabledWithManualCreditNote) then
        Result := UpdatePayRec;

      if Result = 0 then
      begin
        CommitTransaction;

        // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
        {$IFDEF CU}
          If (FTransactionNotificationList.Count > 0) Then
          Begin
            For I := 0 To (FTransactionNotificationList.Count - 1) Do
            Begin
              FExLocal^.LInv := FTransactionNotificationList.Items[I].Invoice;
              GenHooks(2000, 170, FExLocal^);
            End; // For I
          End; // If (FTransactionNotificationList.Count > 0)
        {$ENDIF CU}
      end
      else
        AbortTransaction;

      //Restore position and index in transaction table
      //PR: 15/07/2015 ABSEXCH-16670 Change to use new LPresrv_BTPosLocal functino to avoid overwriting global inv record
      with FExLocal^ do
        if not FOwnExLocal then
          LStatus := LPresrv_BTPosLocal(InvF, Keypath, LocalF^[InvF], TmpRecAddr, True, True);
    End
    else
      FErrorString := 'Unable to start database transaction';
  Finally
    if FOwnExLocal then
    begin
      FExLocal.Close_Files;
      Dispose(FExLocal, Destroy);
    end;
  End;
end;

function TTakePPD.GetAccount: CustRec;
begin
  Result := FAccount;
end;

function TTakePPD.GetCreditNote: InvRec;
begin
  Result := FCreditNote;
end;

function TTakePPD.GetDate: string;
begin
  Result := FDate;
end;

function TTakePPD.GetErrorString: string;
begin
  Result := FErrorString;
end;

function TTakePPD.GetExLocal: TdPostExLocalPtr;
begin
  Result := FExLocal;
end;

function TTakePPD.GetInvoiceCount: Integer;
begin
  Result := FFullInvoiceList.Count;
end;

function TTakePPD.GetPayRec: InvRec;
begin
  Result := FPayRec;
end;

function TTakePPD.GetPeriod: Byte;
begin
  Result := FPeriod;
end;

function TTakePPD.GetYear: Byte;
begin
  Result := FYear;
end;

procedure TTakePPD.InitialiseLine;
begin
  FillChar(FExLocal.LId, SizeOf(FExLocal.LId), 0);

  with FExLocal.LId do
  begin
    FolioRef := FCreditNote.FolioNum;
    DocPRef := FCreditNote.OurRef;
    IdDocHed := FCreditNote.InvDocHed;

    //PR: 23/02/2015 ABSEXCH-16904 2015 R1 Need to set line year and period
    PPr := FCreditNote.AcPr;
    PYr := FCreditNote.AcYr;
    {$IFDEF STK}
    LineType := StkLineType[IdDocHed];
    {$ENDIF}
    Qty := 1;
    QtyMul := 1;
    QtyPack := 1;

    CustCode := FCreditNote.CustCode;
    PDate := FCreditNote.TransDate;
    if FAccount.CustSupp = 'C' then
      NomCode := Syss.NomCtrlCodes[DiscountGiven]
    else
      NomCode := Syss.NomCtrlCodes[DiscountTaken];

    //PR: 12/06/2015 ABSEXCH-16542 Wasn't setting currency on the line
    Currency := FCreditNote.Currency;
    Payment:=DocPayType[IdDocHed];

    // MH 05/02/2018 2018-R1 ABSEXCH-19718: Copy exchange rates into line from header to fix SQL Posting issue
    CxRate := FCreditNote.CxRate;
    CurrTriR := FCreditNote.CurrTriR;
  end;
end;

//Adds invoices for one currency into FInvoiceList and removes them from FFullInvoiceList
//PR: 02/09/2015 2015 R1 ABSEXCH-16811 Added Ctrl GL
procedure TTakePPD.LoadInvoicesForNextCurrency;
var
  i : integer;
  ThisCurrency : Integer;
  ThisRate :  Real48;
  ThisCtrlGL : Longint;
begin
  //Clear invoices from last currency
  FInvoiceList.Clear;
  if FFullInvoiceList.Count > 0 then
  begin
    //Set currency we're using
    ThisCurrency := FFullInvoiceList[0].Invoice.Currency;
    ThisRate := FFullInvoiceList[0].Invoice.CXRate[True];
    ThisCtrlGL := FFullInvoiceList[0].Invoice.CtrlNom;

    {$B-}
    while (FFullInvoiceList.Count > 0) and (FFullInvoiceList[0].Invoice.Currency = ThisCurrency) and
           (FFullInvoiceList[0].Invoice.CXRate[True] = ThisRate) and
           (FFullInvoiceList[0].Invoice.CtrlNom = ThisCtrlGL) do
    begin
      //Add invoice to small list
      FInvoiceList.Add(FFullInvoiceList[0]);

      //Remove from full list
      FFullInvoiceList.Delete(0);
    end;
  end;
end;

//Reads lines for current invoice and adds required details into Line list
procedure TTakePPD.LoadLines(InvNo: Integer);
var
  Res : integer;
  KeyS : Str255;
  KeyChk : Str255;
  oDetails : TLineDetails;
  Index : Integer;
  LineNet : Double;
begin
  FDetailsList.Clear;

  KeyS := FullNomKey(FInvoiceList[InvNo].Invoice.FolioNum);
  KeyChk := KeyS;

  //First line
  Res := FExLocal.LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    LineNet := InvLTotal(FExLocal.LId, True, 0);
    with FExLocal.LId do
    begin
      if (Round_Up(LineNet + VAT, 2) > 0.00) then
      begin
        Index := FDetailsList.Find(FExLocal.LId);
        if Index = -1 then
        begin
          //Doesn't already exist in the list so create it
          oDetails := TLineDetails.Create;

          oDetails.VATCode := VATCode;
          oDetails.VatIndex := GetVATNo(oDetails.VATCode, #0);
          oDetails.VATRate := Round_Up(SyssVAT^.VATRates.VAT[oDetails.VatIndex].Rate, 2);
          if Syss.UseCCDep then
          begin
            oDetails.CostCentre := CCDep[True];
            oDetails.Department := CCDep[False];
          end
          else
          begin
            oDetails.CostCentre := '';
            oDetails.Department := '';
          end;
          oDetails.GoodsValue := 0.0;
          oDetails.VATValue := 0.0;

          Index := FDetailsList.Add(oDetails);
        end;

        //Update values
        //PR: 19/06/2015 ABSEXCH-16574 Use the correct figures - D'Oh!
        FDetailsList[Index].GoodsValue := Round_Up(FDetailsList[Index].GoodsValue + LineNet, 2);
        FDetailsList[Index].VATValue := Round_Up(FDetailsList[Index].VATValue + VAT, 2);

      end;

      //Next line
      Res := FExLocal.LFind_Rec(B_GetNext, IDetailF, IdFolioK, KeyS);
    end;

  end;
end;

//Goes through all the invoices and creates one credit note for each currency
function TTakePPD.ProcessInvoicesByCurrency: Integer;
var
  i : integer;
begin
  Result := 0;

  while (Result = 0) and (FFullInvoiceList.Count > 0) do
  begin
    LoadInvoicesForNextCurrency;

    if FAccount.acPPDMode = pmPPDEnabledWithManualCreditNote then
    begin //Don't need to create a credit note so just set ppdtaken flag on invoices
      for i := 0 to FInvoiceList.Count - 1 do
        Result := UpdateInvoice(i);
    end
    else
    begin
      //Create Credit Note header and populate with defaults (only if we want a credit for this xrate)
      if FInvoiceList.HasPPD then
        Result := AddCreditNote;

      if Result = 0 then
      begin
        for i := 0 to FInvoiceList.Count - 1 do
        if FInvoiceList[i].TakePPD then
        begin
          //process invoice lines and create credit note lines
          Result := ProcessOneInvoice(i);
          if Result <> 0 then
            Break;
        end;

        if Result = 0 then
          Result := Allocate;

        if (Result = 0) and FInvoiceList.HasPPD then
          Result := StoreCreditNote;
      end; // AddCreditNote Result = 0
    end;
  end; //while FullInvoiceList.Count > 0 do
end;

function TTakePPD.ProcessOneInvoice(InvNo: Integer): Integer;
var
  Res : Integer;
  KeyS : Str255;
  VATC : Char;
  VatPercent : Double;
  i : integer;
begin
  if not (FInvoiceList.Items[InvNo].Invoice.InvDocHed in PPDTakeTransactions) then
  begin
    Result := 30003;
    FErrorString := 'PPD cannot be taken or given for this transaction type';
    Exit;
  end;

  if FInvoiceList.Items[InvNo].Invoice.thPPDTaken <> ptPPDNotTaken then
  begin
    Result := 30004;
    FErrorString := 'There is no PPD available on this transaction';
    Exit;
  end;

  KeyS := FInvoiceList.Items[InvNo].Invoice.OurRef;
  Result := FExLocal.LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

  if Result = 0 then
  begin
    FCurrentInv := FExLocal.LInv;

    //Check is any relevant changes have been made since populating the ppd ledger
    if (FCurrentInv.thPPDTaken <> ptPPDNotTaken) or
       (Round_Up(FCurrentInv.thPPDGoodsValue, 2) <> Round_Up(FInvoiceList.Items[InvNo].Invoice.thPPDGoodsValue, 2)) or
       (Round_Up(FCurrentInv.thPPDVATValue, 2) <> Round_Up(FInvoiceList.Items[InvNo].Invoice.thPPDVATValue, 2)) then
    begin
      {$IFDEF COMTK}
      FErrorString := FCurrentInv.OurRef + ' has changed since it was read.';
      {$ELSE}
      FErrorString := FCurrentInv.OurRef + ' has changed since the PPD Ledger was opened.';
      {$ENDIF}
      Result := 30002;
    end;

    if Result = 0 then
    begin
      FInvPPDGoods := FCurrentInv.thPPDGoodsValue;
      FInvPPDVAT := FCurrentInv.thPPDVATValue;

      //Load the lines for this transaction into the list and consolidate by VAT Code/CC/Dept
      LoadLines(InvNo);

      //Sort the list by VAT Rate so that zero vat rates come at the front. That way
      //if we have any rounding issues and have to add an odd penny or two to the last line in the credit note
      //we won't be adding any vat onto a zero vat rate line.
      FDetailsList.Sort(SortLineDetails);

      //Initialise the line record from the header
      InitialiseLine;

      //Add and store lines for the credit note
      for i := 0 to FDetailsList.Count - 1 do //Add a line for this VAT/CC/Dept combination.
      begin
        Result :=  AddLine(FDetailsList[i], i = FDetailsList.Count - 1);

        if Result <> 0 then
        begin
          FErrorString := 'Error ' + IntToStr(Result) + ' occurred while saving a transaction line.';
          Result := 1000 + Result;
          Break;
        end;
      end;
    end;

  end
  else
    FErrorString := 'Unable to find transaction ' + FInvoiceList[InvNo].Invoice.OurRef;
end;

procedure TTakePPD.RemoveInvoice(OurRef : string);
var
  i : integer;
begin
  for i := 0 to FFullInvoiceList.Count - 1 do
    if FFullInvoiceList[i].Invoice.OurRef = OurRef then
    begin
      FFullInvoiceList[i].Free;
      FFullInvoiceList.Delete(i);
      Break;
    end;
end;

procedure TTakePPD.SetAccount(Value: CustRec);
begin
  FAccount := Value;
end;

procedure TTakePPD.SetDate(const Value: string);
begin
  FDate := Value;
end;

procedure TTakePPD.SetDateAndPeriod;
begin
  if Trim(FDate) = '' then
    FDate := EtDateU.Today;

  // CJS 2016-06-02 - ABSEXCH-17306 - period-year on manually allocated PPD transactions
  if (FYear = 0) or (FPeriod = 0) then
  begin
    If Syss.AutoPrCalc then
      SimpleDate2Pr(FDate, FPeriod, FYear)
    else
    begin
      FPeriod := GetLocalPr(0).CPr;
      FYear := GetLocalPr(0).CYr;
    end;
  end;
end;

procedure TTakePPD.SetExLocal(const Value: TdPostExLocalPtr);
begin
  FExLocal := Value;
end;

procedure TTakePPD.SetPayRec(Value: InvRec);
begin
  FPayRec := Value;
end;

procedure TTakePPD.SetPeriod(Value: Byte);
begin
  FPeriod := Value;
end;

procedure TTakePPD.SetYear(Value: Byte);
begin
  FYear := Value;
end;

function TTakePPD.StartTransaction: Integer;
begin
  Result := FExLocal.LCtrl_BTrans(1);
end;

function TTakePPD.StoreCreditNote: integer;
var
  // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
  {$IFDEF CU}
    CreditNoteObj : TInvoiceObject;
  {$ENDIF CU}
  i : integer;
begin
  //Set line count from last line number
  FCreditNote.ILineCount := FExLocal.LId.AbsLineNo + 2;

  //Set note line count
  FExLocal.LInv := FCreditNote;

  //Add audit notes - one for each invoice
  for i := 0 to FInvoiceList.Count - 1 do
  with FExLocal^ do
  begin
    LInv.NLineCount := LInv.NLineCount + 2;
    AddAuditNote(Format('PPD %sn against %s - %s / %s Goods / %s VAT',
                        [PPDGiveTakeWord(LInv.CustSupp),
                         FInvoiceList[i].Invoice.OurRef,
                         FloatToStrF(FAccount.DefSetDisc, ffGeneral, 3, 3) + '%',
                         Trim(FormatCurFloat(GenRealMask,FInvoiceList[i].Invoice.thPPDGoodsValue,BOff,FCreditNote.Currency)),
                         Trim(FormatCurFloat(GenRealMask,FInvoiceList[i].Invoice.thPPDVATValue,BOff,FCreditNote.Currency))]
                                 ));
  end;

  Result := FExLocal.LAdd_Rec(InvF, -1);

  // MH 11/06/2015 v7.0.14 ABSEXCH-16454: Added notification Hook Point for SCR creation
  If (Result = 0) Then
  Begin
      //PR: 16/06/2015 ABSEXCH-16546 Need to update account balance
      if (Result = 0) and Not Syss.UpBalOnPost then
        with FExLocal^ do
          LUpdateBal(LInv,ConvCurrITotal(LInv,BOff,BOn,BOn)*DocCnst[LInv.InvDocHed]*DocNotCnst,0,0,BOff,2);
    {$IFDEF CU}
      // Add an object containing the Credit Note's InvRec into a list for processing after the
      // database transaction is committed, the list then owns it and destroys it
      CreditNoteObj := TInvoiceObject.Create;
      CreditNoteObj.Invoice := FExLocal^.LInv;
      FTransactionNotificationList.Add(CreditNoteObj);
    {$ENDIF CU}
  End // If (Result = 0)
  Else
     FErrorString := 'Error ' + IntToStr(Result) + ' occurred when trying to store the Credit Note header';
end;

//update invoice with settled values/ppd taken
function TTakePPD.UpdateInvoice(InvNo: Integer): Integer;
var
  KeyS : Str255;
  RecAddress : longint;
  AuditNoteText : string;
  Terms : string;
begin
  KeyS := FInvoiceList[InvNo].Invoice.OurRef;

  Result := FExLocal.LFind_Rec(B_GetEq, InvF, InvOurRefK, KeyS);

  if Result = 0 then
  with FExLocal^ do
  begin
    //Lock record using single lock
    LGetPos (InvF, RecAddress);
    SetDataRecOfsPtr (InvF, RecAddress, LRecPtr[InvF]^);
    Result := LGetDirect(InvF, InvOurRefK, B_SingLock + B_SingNWLock);

    if Result = 0 then
    begin
      //Only set PPD taken if we're doing so
      if FInvoiceList[InvNo].TakePPD then
      begin
        //Set PPD taken flag - check to see if it is inside the expiry
        if CalcDueDate(LInv.TransDate, LInv.thPPDDays) >= FDate then
        begin
          LInv.thPPDTaken := ptPPDTaken;
          Terms := '';
        end
        else
        begin
          LInv.thPPDTaken := ptPPDTakenOutsideTerms;
          Terms := ' outside of terms '
        end;
      end;

      //Only set settled values if we're creating a credit note
      if FAccount.acPPDMode <> pmPPDEnabledWithManualCreditNote then
      begin
        //Only set settled values if we're taking PPD
        if FInvoiceList[InvNo].TakePPD then
        begin
          FCurrentInv := LInv;

          //PR: 03/06/2015 ABSEXCH-16479 Added DocCnst[LInv.InvDocHed]*DocNotCnst to ensure correct sign
          LInv.CurrSettled := Round_Up(LInv.CurrSettled + Round_Up((LInv.thPPDGoodsValue + LInv.thPPDVATValue)*DocCnst[LInv.InvDocHed]*DocNotCnst, 2), 2);

          //If we don't have a pay record then just convert currency settled to base; if we have,
          //then we've just taken a full payment (less o/s) so settle in full to avoid leaving any variance o/s
          if Trim(FPayRec.OurRef) = '' then
            LInv.Settled := ConvertToBase(LInv.CurrSettled)
          else
            LInv.Settled := Round_Up(LInv.Settled + BaseTotalOS(LInv), 2);

          Set_DocAlcStat(LInv);

          LInv.RemitNo := FCreditNote.OurRef;

          AuditNoteText := (Format('PPD %sn%s by %s: %s / %s Goods / %s VAT',
                                    [PPDGiveTakeWord(LInv.CustSupp),
                                     Terms,
                                     FCreditNote.OurRef,
                                     FloatToStrF(FAccount.DefSetDisc, ffGeneral, 3, 3) + '%',
                                     Trim(FormatCurFloat(GenRealMask,LInv.thPPDGoodsValue,BOff,FCurrentInv.Currency)),
                                     Trim(FormatCurFloat(GenRealMask,LInv.thPPDVATValue,BOff,FCurrentInv.Currency))]
                                     ));
        end;

        //Update settled totals for variance calculation
        //PR: 22/09/2015 ABSEXCH-16896 In case of part payments we need to subtract starting settled amounts
        FCurrencySettledTotal := FCurrencySettledTotal + LInv.CurrSettled - FInvoiceList[InvNo].Invoice.CurrSettled;
        FBaseSettledTotal := FBaseSettledTotal + LInv.Settled - FInvoiceList[InvNo].Invoice.Settled;

      end
      else
        AuditNoteText := (Format('PPD %sn%s: %s / %s Goods / %s VAT',
                                    [PPDGiveTakeWord(LInv.CustSupp),
                                     Terms,
                                     FloatToStrF(FAccount.DefSetDisc, ffGeneral, 3, 3) + '%',
                                     Trim(FormatCurFloat(GenRealMask,LInv.thPPDGoodsValue,BOff,FCurrentInv.Currency)),
                                     Trim(FormatCurFloat(GenRealMask,LInv.thPPDVATValue,BOff,FCurrentInv.Currency))]
                                     ));

      if FInvoiceList[InvNo].TakePPD then
      begin
        //Add audit notes and update Note line count
        LInv.NLineCount := LInv.NLineCount + 2;
        AddAuditNote(AuditNoteText);

        //Store invoice header
        Result := FExLocal.LPut_Rec(InvF, InvOurRefK);
        if Result <> 0 then
          FErrorString := 'Error ' + IntToStr(Result) + ' occurred when storing ' + FInvoiceList[InvNo].Invoice.OurRef
        else
      end;
    end
    else
      FErrorString := LInv.OurRef + ' is locked by by another user.';
  end
  else
    FErrorString := 'Unable to find transaction ' + FInvoiceList[InvNo].Invoice.OurRef;
end;

//Update the SRC/PPY with any variance
function TTakePPD.UpdatePayRec: Integer;
var
  KeyS, KeyChk : Str255;
  RecAddress : longint;
  AuditNoteText : string;
  Terms : string;
  Variance : Real48;
  OldPayRec : InvRec;
  Res : Integer;
begin
  Result := 0;

  //If PayRec hasn't been set then do nothing; same if variance has already been done.
  if (Trim(FPayRec.OurRef) <> '') then
  begin
    Variance := CalculateVariance;

    if Variance <> 0.00 then
    begin
      OldPayRec := FPayRec;
      //We have variance, so add line
      Result := AddVarianceLine(Variance);

      if Result = 0 then
      begin
        //Line added ok, so update header
        KeyS := FPayRec.OurRef;

        Result := FExLocal.LFind_Rec(B_GetEq + B_SingLock + B_SingNWLock, InvF, InvOurRefK, KeyS);

        if Result = 0 then
        with FExLocal^ do
        begin
          //PR: 18/08/2015 ABSEXCH-16758 Multiply variance by DocCnst[LInv.InvDocHed] * DocNotCnst before adding to settled
          LInv.Settled := Round_Up(LInv.Settled + (Variance * DocCnst[LInv.InvDocHed] * DocNotCnst), 2);
          LInv.Variance :=  Round_Up(LInv.Variance + Variance, 2);
          LInv.TotalReserved := Round_Up(LInv.TotalReserved + LInv.Variance, 2);

          LInv.ILineCount := LInv.ILineCount + 2;

          Result := FExLocal.LPut_Rec(InvF, InvOurRefK);

          if Result <> 0 then
              FErrorString := 'Error ' + IntToStr(Result) + ' occurred when storing ' + FPayRec.OurRef
          else //PR: 15/07/2015 ABSEXCH-16667 Need to update the trader balance with the variance
          if not Syss.UpBalOnPost then
            with FExLocal^ do
              LUpdateBal(LInv,Variance*DocCnst[FPayRec.InvDocHed]*DocNotCnst,0,0,False,2);
        end
        else
        begin
          if Result in [84, 85] then
            FErrorString := FPayRec.OurRef + ' is locked by by another user.'
          else
            FErrorString := 'Unable to find transaction ' + FPayRec.OurRef;
        end;

        //Find matching record and update
        with FExLocal^ do
        begin
          KeyS := FullMatchKey(MatchTCode,MatchSCode,LInv.OurRef);
          KeyChk := KeyS;

          Res := LFind_Rec(B_GetGEq, InvF, HelpNDXK, KeyS);

          if (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) then
          begin
            LPassword.MatchPayRec.SettledVal := LInv.Settled;

            Res := LPut_Rec(PWrdF, HelpNDXK);
          end;

        end;

      end; //if Result = 0 (AddVarianceLine)
    end; //if Variance <> 0.00
  end; //if Trim(FPayRec.OurRef) <> ''
end;

{ TInvoiceList }

function TInvoiceList.Add(Value: TInvoiceObject): Integer;
begin
  Result := Inherited Add(Value);
end;

//Returns True if any item has TakePPD set to true - if none have then we don't need to create a credit note
function TInvoiceList.GetHasPPD: Boolean;
var
  i : integer;
begin
  Result := False;
  for i := 0 to Count - 1 do
    if Items[i].TakePPD then
    begin
      Result := True;
      Break;
    end;
end;

function TInvoiceList.GetItem(Index: Integer): TInvoiceObject;
begin
  Result := TInvoiceObject(inherited Items[Index]);
end;

procedure TInvoiceList.SetItem(Index: Integer; Value: TInvoiceObject);
begin
  inherited SetItem(Index, Value);
end;

{ TLineDetailsList }

function TLineDetailsList.Add(Value: TLineDetails): Integer;
begin
  Result := Inherited Add(Value);
end;

function TLineDetailsList.Find(IdR: IDetail): Integer;
var
  i : integer;
begin
  Result := -1;
  for i := 0 to Count -1 do
    with Items[i] do
      if (VATCode = IdR.VatCode) and
      (not Syss.UseCCDep or
        ((CostCentre = Idr.CCDep[True]) and (Department = Idr.CCDep[False]))
      )
      then
      begin
        Result :=i;
        Break;
      end;

end;

function TLineDetailsList.GetItem(Index: Integer): TLineDetails;
begin
  Result := TLineDetails(inherited Items[Index]);
end;

procedure TLineDetailsList.SetItem(Index: Integer; Value: TLineDetails);
begin
  inherited SetItem(Index, Value);
end;

Initialization


Finalization
{$IFDEF COMTK}
  If (Assigned(STDCurrList)) then
  Begin
    STDCurrList.Free;
    STDCurrList:=Nil;
  end;
{$ENDIF}
end.
