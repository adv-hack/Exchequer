unit AddRec;

interface

uses
  Enterprise01_TLB, Classes;

const
  NoOfGLs = 8;

  MaxLines = 30;   //No of lines on a transaction will be random between 1 & MaxLines
  MaxCost  = 1500; //Cost price of stock will be random between 10 & MaxCost
  MaxQty   = 30;   //Qty on a transaction line will be random between 1 and MaxQty

  AdjDivider = 10; //10% of total transactions
  InvDivider = 4;  //25%      "       "
  PayDivider = 5;  //20%      "       "


type
  //Class to handle GL Defaults
  TGLObject = Class
  private
    FGLCodes : Array[1..NoOfGLs] of longint;
    function GetGL(const Index: Integer): longint;
    procedure SetGL(const Index: Integer; const Value: longint);
  public
    procedure Load;
    procedure Save;
    property SalesGL : longint Index 1 read GetGL write SetGL;
    property COSGL   : longint Index 2 read GetGL write SetGL;
    property ClosingGL : longint Index 3 read GetGL write SetGL;
    property StockValueGL : longint Index 4 read GetGL write SetGL;
    property BOMGL : longint Index 5 read GetGL write SetGL;
    property SalesReturnGL : longint Index 6 read GetGL write SetGL;
    property PurchReturnGL : longint Index 7 read GetGL write SetGL;
    property BankGL : longint Index 8 read GetGL write SetGL;
  end;


  TProgressProc = procedure (Sender : TObject; CurrentRecord, TotalRecords : Integer) of Object;

  //Base class for objects which add records - procedure AddRecords must be overridden by
  //each descendant class
  TBaseAdder = Class
  protected
    FToolkit : IToolkit;
    FRecordsToAdd : Integer;
    FOnProgress : TProgressProc;
    procedure AddRecords; virtual; abstract;
    function ZerosAtFront(Value, Len : Integer) : string;
    procedure DoProgress(RecordsSoFar : Integer); virtual;
    procedure HandleToolkitError(sTransType : string);
  public
    procedure Execute;
    property Toolkit : IToolkit read FToolkit write FToolkit;
    property RecordsToAdd : Integer read FRecordsToAdd write FRecordsToAdd;
    property OnProgress : TProgressProc read FOnProgress write FOnProgress;
  end;


  TAccountAdder = Class(TBaseAdder)
  protected
    FAccountType : TAccountType; //Customer or Supplier
  public
    procedure AddRecords; override;
    property AccountType : TAccountType read FAccountType write FAccountType;
  end;

  TStockAdder = Class(TBaseAdder)
  public
    procedure AddRecords; override;
  end;

  TTransAdder = Class(TBaseAdder)
  protected
    FNumberOfAccounts,
    FNumberOfStockItems : Integer;
    FDate : TDateTime;
    FTotalRecsAdded : Integer;
    //Returns a random existing account code - Customer or Supplier depending on TransType
    function RandomAccount(TransType : TDocTypes) : string;

    //Returns a random existing stock code
    function RandomStock : string;

    //Returns a random date within 28 days from FDate (which is always the 1st of the month)
    function RandomDate : string;

    //Add one month's transactions
    procedure DoOneMonth;

    //Initialise FDate to 5 years before the first day of the current month
    procedure SetInitialDate;

    //Find how many transactions of TransType we want to create
    function NoOfTransactions(TransType : TDocTypes) : Integer;

    //Add transactions
    procedure AddAdjustments;
    procedure AddSalesOrPurchaseTransactions(WantSales : Boolean);

    procedure DoProgress(RecordsSoFar : Integer); override;
  public
    procedure AddRecords; override;
    property NumberOfAccounts : Integer read FNumberOfAccounts write FNumberOfAccounts;
    property NumberOfStockItems : Integer read FNumberOfStockItems write FNumberOfStockItems;
  end;

  function GLObject : TGLObject;

implementation

{ TBaseAdder }
uses
  SysUtils, IniFiles, Forms, DateUtils;

var
  oGLObject : TGLObject;

function GLObject : TGLObject;
begin
  if not Assigned(oGLObject) then
  begin
    oGLObject := TGLObject.Create;
    oGLObject.Load;
  end;

  Result := oGLObject;
end;

procedure TBaseAdder.DoProgress(RecordsSoFar: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, RecordsSoFar, FRecordsToAdd);

end;

procedure TBaseAdder.Execute;
var
  Res : Integer;
begin
  if Assigned(FToolkit) then
  begin
    Res := FToolkit.OpenToolkit;
    AddRecords;
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
end;

procedure TBaseAdder.HandleToolkitError(sTransType: string);
begin
  raise Exception.Create('Unable to save ' + sTransType + ' record.'#10#10'Error ' +
                            QuotedStr(FToolkit.LastErrorString));
end;

function TBaseAdder.ZerosAtFront(Value, Len : Integer): string;
//Len is the total number of characters required in the return string
begin
  Result := IntToStr(Value);
  if Length(Result) < Len then
    Result := StringOfChar('0', Len - Length(Result)) + Result;
end;

{ TAccountAdder }

procedure TAccountAdder.AddRecords;
const
  Codes : Array[atCustomer..atSupplier] of String[2] = ('CU', 'SU');
  Names : Array[atCustomer..atSupplier] of String[8] = ('Customer', 'Supplier');
var
  Res, i : Integer;
  Target : IAccount;
begin
  if FAccountType = atCustomer then
    Target := FToolkit.Customer
  else
    Target := FToolkit.Supplier;

  for i := 1 to FRecordsToAdd do
  begin
    with Target.Add do
    begin
      acCode := Codes[FAccountType] + ZerosAtFront(i, 4);
      acCompany := Names[FAccountType] + ' ' + IntToStr(i);

      Res := Save;

      if Res <> 0 then
        HandleToolkitError('Account');

      DoProgress(i);
    end;
  end;
end;

{ TGLObject }

function TGLObject.GetGL(const Index: Integer): longint;
begin
  Result := FGLCodes[Index];
end;

procedure TGLObject.Load;
var
  i : Integer;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
  Try
    for i := 1 to NoOfGLs do
      FGLCodes[i] := ReadInteger('GLCodes', 'GL_' + IntToStr(i), 0);
  Finally
    Free;
  End;
end;

procedure TGLObject.Save;
var
  i : Integer;
begin
  with TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini')) do
  Try
    for i := 1 to NoOfGLs do
      WriteInteger('GLCodes', 'GL_' + IntToStr(i), FGLCodes[i]);
  Finally
    Free;
  End;
end;

procedure TGLObject.SetGL(const Index: Integer; const Value: longint);
begin
  FGLCodes[Index] := Value;
end;

{ TStockAdder }

procedure TStockAdder.AddRecords;
var
  Res, i : Integer;
begin
  for i := 1 to FRecordsToAdd do
    with FToolkit.Stock.Add as IStock4 do
    begin
      stCode := 'ST' + ZerosAtFront(i, 6);
      stDesc[1] := 'Stock Item ' + IntToStr(i);

      stSalesGL := GLObject.SalesGL;
      stCOSGL := GLObject.COSGL;
      stWIPGL := GLObject.BOMGL;
      stBalSheetGL := GLObject.StockValueGL;
      stPandLGL := GLObject.ClosingGL;
      stSalesReturnGL := GLObject.SalesReturnGL;
      stPurchaseReturnGL := GLObject.PurchReturnGL;

      stCostPrice := Random(MaxCost) + 10;
      stSalesBands['A'].stCurrency := 1;
      stSalesBands['A'].stPrice := stCostPrice * (1.5 + Random(3));


      Res := Save;

      if Res <> 0 then
        HandleToolkitError('Stock');

      DoProgress(i);

    end;
end;

{ TTransAdder }

procedure TTransAdder.AddAdjustments;
var
  i, j, TransCount, LineCount, Res : integer;
begin
  TransCount := NoOfTransactions(dtADJ);
  for i := 1 to TransCount do
  begin
    with FToolkit.Transaction.Add(dtADJ) do
    begin
      thTransDate := RandomDate;
      LineCount := 1 + Random(MaxLines);
      for j := 1 to LineCount do
      with thLines.Add do
      begin
        tlStockCode := RandomStock;
        tlQty := 1 + Random(MaxQty);
        ImportDefaults;
        Save;
      end;

      Res := Save(True);

      if Res <> 0 then
        HandleToolkitError('Stock Adjustment');

      DoProgress(i);
    end;
  end;
  Inc(FTotalRecsAdded, TransCount);
end;

procedure TTransAdder.AddRecords;
var
  i : Integer;
begin
  FTotalRecsAdded := 0;
  SetInitialDate;
  for i := 1 to 60 do
  begin
    DoOneMonth;
    FDate := IncMonth(FDate, 1);
  end;
end;

procedure TTransAdder.AddSalesOrPurchaseTransactions(WantSales: Boolean);
const
  Desc : Array[False..True] of String[7] = ('Purchase', 'Sales');
var
  i, j, Res, InvCount, PayCount, LineCount, AddedCount, Sign : Integer;
  InvDocType, PayDocType : TDocTypes;
  OurRef, NetVal : String;
  oInv, oPay : ITransaction;
begin
  if WantSales then
  begin
    InvDocType := dtSIN;
    PayDocType := dtSRC;
  end
  else
  begin
    InvDocType := dtPIN;
    PayDocType := dtPPY;
  end;

  InvCount := NoOfTransactions(InvDocType);
  PayCount := NoOfTransactions(PayDocType);
  AddedCount := 0;

  for i := 1 to InvCount do
  begin
    LineCount := 1 + Random(MaxLines);
    //Add Invoice
    oInv := FToolkit.Transaction.Add(InvDocType);
    with oInv do
    begin
      thTransDate := RandomDate;
      thAcCode := RandomAccount(InvDocType);
      thCurrency := 1;
      for j := 1 to LineCount do
      with thLines.Add do
      begin
        tlStockCode := RandomStock;
        tlQty := 1 + Random(MaxQty);
        ImportDefaults;
        if not WantSales then
        begin
          FToolkit.Stock.GetEqual(FToolkit.Stock.BuildCodeIndex(tlStockCode));
          tlNetValue := FToolkit.Stock.stCostPrice;
        end;
        Save;
      end;
      Res := Save(True);
      if Res <> 0 then
        HandleToolkitError(Desc[WantSales] + ' Invoice');

      inc(AddedCount);
      DoProgress(AddedCount);
    end;

    if i <= PayCount then //Add a matching receipt and allocate it
    begin
      oPay := FToolkit.Transaction.Add(PayDocType);
      with oPay do
      begin
        thAcCode := oInv.thAcCode;
        thTransDate := oInv.thTransDate;
        thCurrency := 1;
        with thLines.Add do
        begin
          tlQty := 1;
          tlNetValue := oInv.thTotals[TransTotInBase];
          tlGlCode := GLObject.BankGL;
          Save;
        end;
        Res := Save(True);
        if Res <> 0 then
          HandleToolkitError(Desc[WantSales] + ' Receipt');

        inc(AddedCount);
        DoProgress(AddedCount);
      end;

      Res := FToolkit.Transaction.GetEqual(FToolkit.Transaction.BuildOurRefIndex(oInv.thOurRef));
      if Res = 0 then
      with FToolkit.Transaction.thMatching.Add do
      begin
        if WantSales then
          Sign := 1
        else
          Sign := -1;
        maDocCurrency := 1;
        maPayCurrency := 1;
        maDocRef := oInv.thOurRef;
        maPayRef := oPay.thOurRef;
        maDocValue := oPay.thNetValue * Sign;
        maPayValue := oPay.thNetValue * Sign;
        maBaseValue := oPay.thNetValue * Sign;

        Res := Save;
        if Res <> 0 then
          HandleToolkitError('Matching');
      end;

    end;
  end;
  Inc(FTotalRecsAdded, InvCount);
  oInv := nil;
  oPay := nil;
end;

procedure TTransAdder.DoOneMonth;
begin
  AddAdjustments;
  AddSalesOrPurchaseTransactions(False);
  AddSalesOrPurchaseTransactions(True);
end;

procedure TTransAdder.DoProgress(RecordsSoFar: Integer);
begin
  if Assigned(FOnProgress) then
    FOnProgress(Self, FTotalRecsAdded + RecordsSoFar, FRecordsToAdd * 60);
end;

function TTransAdder.NoOfTransactions(TransType: TDocTypes): Integer;
begin
  Case TransType of
    dtADJ : Result := FRecordsToAdd div AdjDivider;
    dtSIN,
    dtPIN : Result := FRecordsToAdd div InvDivider;
    dtSRC,
    dtPPY : Result := FRecordsToAdd div PayDivider;
  end;
end;

function TTransAdder.RandomAccount(TransType : TDocTypes) : string;
var
  sPrefix : string;
begin
  if TransType = dtSIN then
    sPrefix := 'CU'
  else
    sPrefix := 'SU';

  Result := sPrefix + ZerosAtFront(1 + Random(FNumberOfAccounts), 4);
end;

function TTransAdder.RandomDate: string;
begin
  Result := FormatDateTime('yyyymmdd', FDate + Random(28));
end;

function TTransAdder.RandomStock: string;
begin
  Result := 'ST' + ZerosAtFront(1 + Random(FNumberOfAccounts), 6);
end;

procedure TTransAdder.SetInitialDate;
var
  yy, mm, dd : Word;
begin
  DecodeDate(Date, yy, mm, dd);

  FDate := StrToDate('1/' + IntToStr(mm));
  FDate := IncYear(FDate, -5);
end;

Initialization
  oGLObject := nil;

end.
