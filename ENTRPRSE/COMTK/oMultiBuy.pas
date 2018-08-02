unit oMultiBuy;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
      MiscFunc, oBtrieve, BtrvU2, GlobList, VarConst, Varrec2u, GlobVar, VarCnst3,
      ExceptIntf;

type
  TMultiBuyDetails = class(TAutoIntfObjectEx, IMultiBuyDetails)
  private
    FMultiBuyRec : TBatchMultiBuyDiscount;
    FOwnerType : Char;
    function GetAcCode: string;
    function GetStockCode: string;
    procedure SetAcCode(const Value: string);
    procedure SetStockCode(const Value: string);
    function GetOwnerType: Char;
    procedure SetOwnerType(const Value: Char); //'C', 'S' - customer/Supplier, 'T' - stock, 'L' - transaction line.
  protected
    function Get_mbdType: TMultiBuyDiscountType; safecall;
    procedure Set_mbdType(Value: TMultiBuyDiscountType); safecall;
    function Get_mbdStockCode: WideString; safecall;
    procedure Set_mbdStockCode(const Value: WideString); safecall;
    function Get_mbdCurrency: Integer; safecall;
    procedure Set_mbdCurrency(Value: Integer); safecall;
    function Get_mbdBuyQty: Double; safecall;
    procedure Set_mbdBuyQty(Value: Double); safecall;
    function Get_mbdRewardValue: Double; safecall;
    procedure Set_mbdRewardValue(Value: Double); safecall;
    function Get_mbdUseEffectiveDates: WordBool; safecall;
    procedure Set_mbdUseEffectiveDates(Value: WordBool); safecall;
    function Get_mbdDateEffectiveFrom: WideString; safecall;
    procedure Set_mbdDateEffectiveFrom(const Value: WideString); safecall;
    function Get_mbdDateEffectiveTo: WideString; safecall;
    procedure Set_mbdDateEffectiveTo(const Value: WideString); safecall;
    function Get_mbdApplyQty: Integer; safecall;
    procedure Set_mbdApplyQty(Value: Integer); safecall;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetDetails(const Details : TBatchMultiBuyDiscount);
    property AcCode : string read GetAcCode write SetAcCode;
    property StockCode : string read GetStockCode write SetStockCode;
    property Details : TBatchMultiBuyDiscount read FMultiBuyRec;
    property OwnerType : Char read GetOwnerType write SetOwnerType;
  end;

  TMultiBuyDiscounts = Class(TAutoIntfObjectEx, IMultiBuyDiscounts)
  private
    FList : TStringList;

    FMultiBuyO : TMultiBuyDetails;
    FMultiBuyI : IMultiBuyDetails;

    FStockCode,
    FAcCode,
    FDate  : string;
    FCurrency : Integer;
    FBtrIntf : TCtkTdPostExLocalPtr;
    FLineQty : Double;
    FIsSales : Boolean;
  protected
    function Get_mbdCount: Integer; safecall;
    function Get_mbdDetails(Index: Integer): IMultiBuyDetails; safecall;
    procedure InitObjects;
  public
    constructor Create(const sStockCode, sAcCode, TransDate : string; Currency : Integer; LineQty : Double);
    destructor Destroy; override;
    procedure LoadList;
    property BtrIntf : TCtkTdPostExLocalPtr read FBtrIntf write FBtrIntf;
    property IsSales : Boolean read FIsSales write FIsSales;
    property List : TStringList read FList;
  end;

  TMultiBuy = Class(TBtrieveFunctions, IMultiBuy, IMultiBuyDetails)
  private
    FMultiBuyRec : TBatchMultiBuyDiscount;
{    FDetailsO : TMultiBuyDetails;
    FDetailsI : IMultiBuyDetails;}
    FOwnerType : Char;
    FStartKey : Str255;
    FToolkit : TObject;
    FIntfType       : TInterfaceMode;
    function GetAcCode: string;
    function GetStockCode: string;
    procedure SetAcCode(const Value: string);
    procedure SetStockCode(const Value: string);
    function GetOwnerType: Char;
    procedure SetOwnerType(const Value: Char); //'C', 'S' - customer/Supplier, 'T' - stock, 'L' - transaction line.
  protected
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    Function  AuthoriseFunction (Const FuncNo     : Byte;
                                 Const MethodName : String;
                                 Const AccessType : Byte = 0) : Boolean; override;

    function Get_mbdType: TMultiBuyDiscountType; safecall;
    procedure Set_mbdType(Value: TMultiBuyDiscountType); safecall;
    function Get_mbdStockCode: WideString; safecall;
    procedure Set_mbdStockCode(const Value: WideString); safecall;
    function Get_mbdCurrency: Integer; safecall;
    procedure Set_mbdCurrency(Value: Integer); safecall;
    function Get_mbdBuyQty: Double; safecall;
    procedure Set_mbdBuyQty(Value: Double); safecall;
    function Get_mbdRewardValue: Double; safecall;
    procedure Set_mbdRewardValue(Value: Double); safecall;
    function Get_mbdUseEffectiveDates: WordBool; safecall;
    procedure Set_mbdUseEffectiveDates(Value: WordBool); safecall;
    function Get_mbdDateEffectiveFrom: WideString; safecall;
    procedure Set_mbdDateEffectiveFrom(const Value: WideString); safecall;
    function Get_mbdDateEffectiveTo: WideString; safecall;
    procedure Set_mbdDateEffectiveTo(const Value: WideString); safecall;
    function Get_mbdApplyQty: Integer; safecall;
    procedure Set_mbdApplyQty(Value: Integer); safecall;

    Procedure LoadDetails (Const MBDetails : TBatchMultiBuyDiscount; Const LockPos : LongInt; IsClone : Boolean = False);
    function Save: Integer; safecall;
    function Add: IMultiBuy; safecall;
    function Clone: IMultiBuy; safecall;
    function Update: IMultiBuy; safecall;
    procedure Cancel; safecall;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        const OwnerType : Char;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;
    procedure SetStartKey(const KeyS : string);
  end;


implementation

uses
  ComServ, MultiBuyVar, MultiBuyFuncs, DLLMultiBuy, BtSupU1, BtKeys1U, EtStrU;

{ TMultiBuyDetails }

constructor TMultiBuyDetails.Create;
begin
  Inherited Create (ComServer.TypeLib, IMultiBuyDetails);
end;

destructor TMultiBuyDetails.Destroy;
begin

  inherited;
end;

function TMultiBuyDetails.GetAcCode: string;
begin
  Result := FMultiBuyRec.mbdAcCode;
end;

function TMultiBuyDetails.GetOwnerType: Char;
begin
  Result := FMultiBuyRec.mbdOwnerType;
end;

function TMultiBuyDetails.GetStockCode: string;
begin
  Result := FMultiBuyRec.mbdStockCode;
end;

function TMultiBuyDetails.Get_mbdApplyQty: Integer;
begin
  Result := FMultiBuyRec.mbdApplyQty;
end;

function TMultiBuyDetails.Get_mbdBuyQty: Double;
begin
  Result := FMultiBuyRec.mbdBuyQty;
end;

function TMultiBuyDetails.Get_mbdCurrency: Integer;
begin
  Result := FMultiBuyRec.mbdCurrency;
end;

function TMultiBuyDetails.Get_mbdDateEffectiveTo: WideString;
begin
  Result := FMultiBuyRec.mbdEndDate;
end;

function TMultiBuyDetails.Get_mbdRewardValue: Double;
begin
  Result := FMultiBuyRec.mbdRewardValue;
end;

function TMultiBuyDetails.Get_mbdDateEffectiveFrom: WideString;
begin
  Result := FMultiBuyRec.mbdStartDate;
end;

function TMultiBuyDetails.Get_mbdStockCode: WideString;
begin
  Result := FMultiBuyRec.mbdStockCode;
end;

function TMultiBuyDetails.Get_mbdType: TMultiBuyDiscountType;
begin
  Result := Ord(FMultiBuyRec.mbdDiscountType) - 48;
end;

function TMultiBuyDetails.Get_mbdUseEffectiveDates: WordBool;
begin
  Result := FMultiBuyRec.mbdUseDates;
end;

procedure TMultiBuyDetails.SetAcCode(const Value: string);
begin
  FMultiBuyRec.mbdAcCode := FullCustCode(Value);
end;

procedure TMultiBuyDetails.SetDetails(
  const Details: TBatchMultiBuyDiscount);
begin
  FMultiBuyRec := Details;
end;

procedure TMultiBuyDetails.SetOwnerType(const Value: Char);
begin
  if Value in ['C', 'C', 'T'] then
    FMultiBuyRec.mbdOwnerType := Value;
  FOwnerType := Value;
end;

procedure TMultiBuyDetails.SetStockCode(const Value: string);
begin
  FMultiBuyRec.mbdAcCode := FullStockCode(Value);
end;

procedure TMultiBuyDetails.Set_mbdApplyQty(Value: Integer);
begin
  FMultiBuyRec.mbdApplyQty := Value;
end;

procedure TMultiBuyDetails.Set_mbdBuyQty(Value: Double);
begin
  FMultiBuyRec.mbdBuyQty := Value;
end;

procedure TMultiBuyDetails.Set_mbdCurrency(Value: Integer);
begin
  FMultiBuyRec.mbdCurrency := Value;
end;

procedure TMultiBuyDetails.Set_mbdDateEffectiveTo(const Value: WideString);
begin
  FMultiBuyRec.mbdEndDate := Value;
end;

procedure TMultiBuyDetails.Set_mbdRewardValue(Value: Double);
begin
  FMultiBuyRec.mbdRewardValue := Value;
end;

procedure TMultiBuyDetails.Set_mbdDateEffectiveFrom(const Value: WideString);
begin
  FMultiBuyRec.mbdStartDate := Value;
end;

procedure TMultiBuyDetails.Set_mbdStockCode(const Value: WideString);
begin
  if (FOwnerType in ['C', 'S']) then
    FMultiBuyRec.mbdStockCode := Value;
end;

procedure TMultiBuyDetails.Set_mbdType(Value: TMultiBuyDiscountType);
begin
  FMultiBuyRec.mbdDiscountType := Char(Value + 48);
end;

procedure TMultiBuyDetails.Set_mbdUseEffectiveDates(Value: WordBool);
begin
  FMultiBuyRec.mbdUseDates := Value;
end;

{ TMultiBuyDiscounts }

constructor TMultiBuyDiscounts.Create(const sStockCode, sAcCode, TransDate : string; Currency : Integer; LineQty : Double);
begin
  Inherited Create (ComServer.TypeLib, IMultiBuyDiscounts);
  FList := nil;
  InitObjects;
  FStockCode := sStockCode;
  FAcCode := sAcCode;
  FLineQty := LineQty;
  //PR: 21/07/2009 Wasn't setting date - D'oh!
  FDate := TransDate;
end;

destructor TMultiBuyDiscounts.Destroy;
begin
  InitObjects;
  if Assigned(FList) then
    FList.Free;
  inherited;
end;

function TMultiBuyDiscounts.Get_mbdCount: Integer;
begin
  if Assigned(FList) then
    Result := FList.Count
  else
    Result := 0;
end;

function TMultiBuyDiscounts.Get_mbdDetails(Index: Integer): IMultiBuyDetails;
var
  TKMBD : TBatchMultiBuyDiscount;
begin
  if Assigned(FList) then
  begin
    if (Index >= 0) and (Index < FList.Count) then
    begin
      ExMultiBuyToTkMultiBuy((FList.Objects[Index] as TMultiBuyDiscountHolder).MBDRec, TKMBD);
      TKMBD.mbdApplyQty := (FList.Objects[Index] as TMultiBuyDiscountHolder).mbdQty;
    end
    else
      raise ERangeError.Create('Index out of range (' + IntToStr(Index) + ').');
  end;

  if not Assigned(FMultiBuyO) then
  begin
    FMultiBuyO := TMultiBuyDetails.Create;

    FMultiBuyI := FMultiBuyO;
  end;

  FMultiBuyO.SetDetails(TKMBD);

  Result := FMultiBuyI;

end;

procedure TMultiBuyDiscounts.InitObjects;
begin
  FMultiBuyO := nil;
  FMultiBuyI := nil;
end;

procedure TMultiBuyDiscounts.LoadList;
begin
  with TMultiBuyFunctions.Create do
  Try
    FList := GetMultiBuyList(FAcCode, FStockCode, FDate, FBtrIntf, FCurrency, True, FIsSales, FLineQty);
  Finally
    Free;
  End;
end;

{ TMultiBuy }

function TMultiBuy.Add: IMultiBuy;
var
  MultiBuyO : TMultiBuy;
begin
  AuthoriseFunction(100, 'Add');

  MultiBuyO := TMultiBuy.Create(imAdd, FToolkit, FOwnerType, FBtrIntf);
  MultiBuyO.SetStartKey(FStartKey);

  Result := MultiBuyO;
end;

procedure TMultiBuy.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

function TMultiBuy.Clone: IMultiBuy;
var
  MultiBuyO : TMultiBuy;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  MultiBuyO := TMultiBuy.Create(imClone, FToolkit, FOwnerType, FBtrIntf);

  // Pass current Record and Locking Details into sub-object
  MultiBuyO.LoadDetails(FMultiBuyRec, 0, True);

  Result := MultiBuyO;
end;

procedure TMultiBuy.CopyDataRecord;
begin
  ExMultiBuyToTkMultiBuy(FBtrIntf^.LMultiBuyDiscount, FMultiBuyRec);
end;

constructor TMultiBuy.Create(const IType: TInterfaceMode;
  const Toolkit: TObject; const OwnerType : Char; const BtrIntf: TCtkTdPostExLocalPtr);
begin
  inherited Create(ComServer.TypeLib, IMultiBuy, BtrIntf);
  FOwnerType := OwnerType;
  FToolkit := Toolkit;

  FIntfType := IType;

//  FDetailsO := TMultiBuyDetails.Create;

//  FDetailsI := FDetailsO;

  FFileNo := MultiBuyF;
  FIndex := 0;
  FillChar(FMultiBuyRec, SizeOf(FMultiBuyRec), 0);
end;

destructor TMultiBuy.Destroy;
begin
{  FDetailsO := nil;
  FDetailsI := nil;}
  inherited;
end;



function TMultiBuy.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
var
  KeyS : Str255;
  BtrOpCode : Integer;
begin
  Case BtrOp of

    B_GetEq,
    B_GetFirst,
    B_GetGEq   :    begin
                       BtrOpCode := B_GetGEq;
                       if FOwnerType in ['C','S'] then
                         KeyS := mbdPartStockCodeKey(FStartKey, SearchKey)
                       else
                         KeyS := FStartKey;{ + BuyQuantityStringStartValue;}
                     end;

    B_GetLast,
    B_GetLessEq :  begin
                       BtrOpCode := B_GetLessEq;
                       if FOwnerType in ['C','S'] then
                         KeyS := mbdStockCodeKey(FStartKey, SearchKey)
                       else
                         KeyS := FStartKey + BuyQuantityStringStartValue;
                   end;
    else
      BtrOpCode := BtrOp;
  end; {Case..}


  with FBtrIntf^ do
  begin
    KeyS := SetKeyString(BtrOpCode, KeyS);

    Result := LFind_Rec(BtrOpCode, FFileNo, FIndex, KeyS);

    if (Result = 0) and not CheckKey(FStartKey,KeyS,Length(FStartKey),BOn) then
      Result := 9;

    if Result = 0 then
    begin
      CopyDataRecord;

      FKeyString := KeyS;
    end;
  end;
end;

function TMultiBuy.Save: Integer;
Var
  SaveInfo     : TBtrieveFileSavePos;
  SaveInfo2    : TBtrieveFileSavePos;
  BtrOp, Res   : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global customer file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
    FMultiBuyRec.RecordPosition := LockPosition;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Add/Update Stock
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreMultiBuy (@FMultiBuyRec,           // P
                             SizeOf(FMultiBuyRec),    // PSize
                             FIndex,                 // SearchPath
                             BtrOp);                 // SearchMode
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

function TMultiBuy.Update: IMultiBuy;
var
  MultiBuyO : TMultiBuy;
  FuncRes : Integer;
begin
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    MultiBuyO := TMultiBuy.Create(imUpdate, FToolkit, FOwnerType, FBtrIntf);

    // Pass current Record and Locking Details into sub-object
    MultiBuyO.LoadDetails(FMultiBuyRec, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := MultiBuyO;
  End; { If (FuncRes = 0) }

end;

procedure TMultiBuy.SetStartKey(const KeyS: string);
begin

  Case FOwnerType of
    'C',
    'S' : begin
            FStartKey := FullCustCode(KeyS);
            FMultiBuyRec.mbdAcCode := KeyS;
          end;
    'T' : begin
            FMultiBuyRec.mbdAcCode := '';
            //PR: 02/06/2010 Change to set Stock Code correctly - remove empty cust code & pad to length.
            FMultiBuyRec.mbdStockCode := LJVar(Copy(KeyS, 7, Length(KeyS)), StkKeyLen);
            FStartKey := mbdPartStockCodeKey('', KeyS);
          end;
    end; //Case
  FMultiBuyRec.mbdOwnerType := FOwnerType;
end;

function TMultiBuy.AuthoriseFunction(const FuncNo: Byte;
  const MethodName: String; const AccessType: Byte): Boolean;
begin
  Case FuncNo Of
    // Step functions
    1..4      : Result := False;  { Not supported as CustF is shared file }

    5..99     : Result := (FIntfType = imGeneral);

    // .Add method
    100       : Result := (FIntfType = imGeneral);
    // .Update method
    101       : Result := (FIntfType = imGeneral);
    // .Save method
    102       : Result := (FIntfType In [imAdd, imUpdate]);
    // .Cancel method
    103       : Result := (FIntfType = imUpdate);
    // .Clone method
    104       : Result := (FIntfType = imGeneral);

    // .Delete method
    105       : Result := (FIntfType = imGeneral);

  Else
    Result := False;
  End; { Case FuncNo }

  If (Not Result) Then Begin
    If (AccessType = 0) Then
      // Method
      Raise EInvalidMethod.Create ('The method ' + QuotedStr(MethodName) + ' is not available in this object')
    Else
      // Property
      Raise EInvalidMethod.Create ('The property ' + QuotedStr(MethodName) + ' is not available in this object');
  End; { If (Not Result) }
end;

//Used for loading details for Update and Clone objects.
procedure TMultiBuy.LoadDetails(const MBDetails: TBatchMultiBuyDiscount;
  const LockPos: Integer; IsClone : Boolean = False);
begin
//  FDetailsO.SetDetails(FMultiBuyRec);
  FMultiBuyRec := MBDetails;

  if not IsClone then
  begin
    LockCount := 1;
    LockPosition := LockPos;
  end;
end;

function TMultiBuy.GetAcCode: string;
begin
  Result := FMultiBuyRec.mbdAcCode;
end;

function TMultiBuy.GetOwnerType: Char;
begin
  Result := FMultiBuyRec.mbdOwnerType;
end;

function TMultiBuy.GetStockCode: string;
begin
  Result := FMultiBuyRec.mbdStockCode;
end;

function TMultiBuy.Get_mbdApplyQty: Integer;
begin
  Result := FMultiBuyRec.mbdApplyQty;
end;

function TMultiBuy.Get_mbdBuyQty: Double;
begin
  Result := FMultiBuyRec.mbdBuyQty;
end;

function TMultiBuy.Get_mbdCurrency: Integer;
begin
  Result := FMultiBuyRec.mbdCurrency;
end;

function TMultiBuy.Get_mbdDateEffectiveTo: WideString;
begin
  Result := FMultiBuyRec.mbdEndDate;
end;

function TMultiBuy.Get_mbdRewardValue: Double;
begin
  Result := FMultiBuyRec.mbdRewardValue;
end;

function TMultiBuy.Get_mbdDateEffectiveFrom: WideString;
begin
  Result := FMultiBuyRec.mbdStartDate;
end;

function TMultiBuy.Get_mbdStockCode: WideString;
begin
  Result := FMultiBuyRec.mbdStockCode;
end;

function TMultiBuy.Get_mbdType: TMultiBuyDiscountType;
begin
  Result := Ord(FMultiBuyRec.mbdDiscountType) - 48;
end;

function TMultiBuy.Get_mbdUseEffectiveDates: WordBool;
begin
  Result := FMultiBuyRec.mbdUseDates;
end;

procedure TMultiBuy.SetAcCode(const Value: string);
begin
  FMultiBuyRec.mbdAcCode := FullCustCode(Value);
end;

procedure TMultiBuy.SetOwnerType(const Value: Char);
begin
  if Value in ['C', 'C', 'T'] then
    FMultiBuyRec.mbdOwnerType := Value;
  FOwnerType := Value;
end;

procedure TMultiBuy.SetStockCode(const Value: string);
begin
  FMultiBuyRec.mbdAcCode := FullStockCode(Value);
end;

procedure TMultiBuy.Set_mbdApplyQty(Value: Integer);
begin
  FMultiBuyRec.mbdApplyQty := Value;
end;

procedure TMultiBuy.Set_mbdBuyQty(Value: Double);
begin
  FMultiBuyRec.mbdBuyQty := Value;
end;

procedure TMultiBuy.Set_mbdCurrency(Value: Integer);
begin
  FMultiBuyRec.mbdCurrency := Value;
end;

procedure TMultiBuy.Set_mbdDateEffectiveTo(const Value: WideString);
begin
  FMultiBuyRec.mbdEndDate := Value;
end;

procedure TMultiBuy.Set_mbdRewardValue(Value: Double);
begin
  FMultiBuyRec.mbdRewardValue := Value;
end;

procedure TMultiBuy.Set_mbdDateEffectiveFrom(const Value: WideString);
begin
  FMultiBuyRec.mbdStartDate := Value;
end;

procedure TMultiBuy.Set_mbdStockCode(const Value: WideString);
begin
  if (FOwnerType in ['C', 'S']) then
    FMultiBuyRec.mbdStockCode := Value;
end;

procedure TMultiBuy.Set_mbdType(Value: TMultiBuyDiscountType);
begin
  FMultiBuyRec.mbdDiscountType := Char(Value + 48);
end;

procedure TMultiBuy.Set_mbdUseEffectiveDates(Value: WordBool);
begin
  FMultiBuyRec.mbdUseDates := Value;
end;


end.
