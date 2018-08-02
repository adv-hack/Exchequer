unit oAcDisc;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, oQtyBrk, GlobList;

type
  TAccountDiscount = class(TBtrieveFunctions, IAccountDiscount, IAccountDiscount2, IBrowseInfo)
  private
    // Note: All properties protected to allow descendants access
    FDiscSubType : Char;      // SubType used to access records
    FAccCode     : String[6]; // Account Code of current account

    FDiscRec     : CustDiscType;

    // Quantity Breaks sub-object
    FQtyBrkO     : TQuantityBreak;
    FQtyBrkI     : IQuantityBreak;

    FIntfType    : TInterfaceMode;
    FToolkit     : TObject;

  protected
    // IAccountDiscount
    function  Get_adStockCode: WideString; safecall;
    procedure Set_adStockCode(const Value: WideString); safecall;
    function  Get_adType: TDiscountType; safecall;
    procedure Set_adType(Value: TDiscountType); safecall;
    function  Get_adCurrency: Smallint; safecall;
    procedure Set_adCurrency(Value: Smallint); safecall;
    function  Get_adPrice: Double; safecall;
    procedure Set_adPrice(Value: Double); safecall;
    function  Get_adDiscPercent: Double; safecall;
    procedure Set_adDiscPercent(Value: Double); safecall;
    function  Get_adDiscValue: Double; safecall;
    procedure Set_adDiscValue(Value: Double); safecall;
    function  Get_adMarkupMarginPercent: Double; safecall;
    procedure Set_adMarkupMarginPercent(Value: Double); safecall;
    function  Get_adStockCodeI: IStock; safecall;
    function  Get_adPriceBand: WideString; safecall;
    procedure Set_adPriceBand(const Value: WideString); safecall;
    function  Get_adQtyBreaks: IQuantityBreak; safecall;

    function Get_adDateEffectiveFrom: WideString; safecall;
    procedure Set_adDateEffectiveFrom(const Value: WideString); safecall;
    function Get_adDateEffectiveTo: WideString; safecall;
    procedure Set_adDateEffectiveTo(const Value: WideString); safecall;
    function Get_adUseEffectiveDates: WordBool; safecall;
    procedure Set_adUseEffectiveDates(Value: WordBool); safecall;


    function  Add: IAccountDiscount; safecall;
    function  Update: IAccountDiscount; safecall;
    function  Clone: IAccountDiscount; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    function  BuildIndex(const StockCode: WideString; Currency: Smallint): WideString; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;


    //PR: 23/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;
    //procedure Debug; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local Methods
    Procedure CloneDetails (Const DiscDets : CustDiscType; Const AccCode  : ShortString);
    procedure InitNew (Const AccCode  : ShortString);
    Procedure InitObjects;
    Procedure LoadDetails (Const DiscDets : CustDiscType;
                           Const AccCode  : ShortString;
                           Const LockPos  : LongInt);
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr;
                        Const DiscSub  : Char);

    Destructor Destroy; override;

    Procedure SetStartKey (Const AccCode  : ShortString);
  End; { TAccountDiscount }

implementation

uses ComServ, oToolkit, DLL01U, DllErrU, BtsupU1, BtKeys1U, EtStrU, ComnU2, SQLStructuresU, TKSQL,
  //PR: 14/02/2012 ABSEXCH-9795
  QtyBreakVar;

{-------------------------------------------------------------------------------------------------}

Constructor TAccountDiscount.Create (Const IType    : TInterfaceMode;
                                     Const Toolkit  : TObject;
                                     Const BtrIntf  : TCtkTdPostExLocalPtr;
                                     Const DiscSub  : Char);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IAccountDiscount2, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392

  // Initialise Btrieve Ancestor
  FFileNo := MiscF;

  // Setup note indexing fields
  FDiscSubType := DiscSub;
  FAccCode := '';

  // Initialise variables
  FillChar (FDiscRec, SizeOf(FDiscRec), #0);
  InitObjects;

  // Setup Links
  FIntfType := IType;
  FToolkit := Toolkit;

  // Default to index 0
  FIndex := 0;

  FObjectID := tkoCustDisc;
  FRecordSubType := DiscSub;
End; { Create }

{-----------------------------------------}

Destructor TAccountDiscount.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TAccountDiscount.InitObjects;
Begin { InitObjects }
  // Quantity Breaks sub-object
  FQtyBrkO := NIL;
  FQtyBrkI := NIL;

  FToolkit := NIL;
End; { InitObjects }

{-----------------------------------------}

(*
procedure TAccountDiscount.Debug;
Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;

  SecName : Array [1..5] Of String = ('Customer Discounts',
                                      'Supplier Discounts',
                                      'Customer Quantity Breaks',
                                      'Stock  Quantity Breaks',
                                      'Supplier Quantity Breaks');
  RecPrefix  : Array [1..5] Of Char = ('C', 'C', 'D', 'D', 'D');
  RecSubType : Array [1..5] Of Char = ('C', 'S', 'C', 'Q', 'S');
Var
  OutF      : TextFile;
  KeyS      : Str255;
  I, J, Res : SmallInt;
begin
  AssignFile (OutF, 'c:\Disc.txt');
  Rewrite (OutF);

  For I := 1 To 5 Do Begin
    Writeln (OutF, SecName[I]);
    Writeln (OutF, StringOfChar('=', Length(SecName[I])));

    KeyS:=RecPrefix[I]+RecSubType[I];
    Res := Find_Rec(B_GetGEQ, F[MiscF], MiscF, RecPtr[MiscF]^, 0, KeyS);
    While (Res = 0) And (MiscRecs.RecMFix = RecPrefix[I]) And (MiscRecs.SubType = RecSubType[I]) Do Begin
      Case I Of
        // Account Discounts
        1,
        2 : With MiscRecs.CustDiscRec Do
              Writeln(OutF, KeyS,  ' \', DCCode + ':' + QStkCode + ':' + QBType);

        // Account Quantity Breaks
        3,
        5 : With MiscRecs.QtyDiscRec Do
              Writeln(OutF, KeyS,  ' \', QCCode + ':' + IntToStr(QStkFolio) + ':' + Format('%5f:%5f:%s', [FQB, TQB, QBType]));

        // Stock Quantity Breaks
        4 : With MiscRecs.QtyDiscRec Do
              Writeln(OutF, KeyS,  ' \', IntToStr(QStkFolio) + ':' + Format('%5f:%5f:%S', [FQB, TQB, QBType]));
      End; { Else }

      Res := Find_Rec(B_GetNext, F[MiscF], MiscF, RecPtr[MiscF]^, 0, KeyS);
    End; { While }

    Writeln (OutF);
  End; { For I }

  CloseFile (OutF);
End;
*)

{-----------------------------------------}

Procedure TAccountDiscount.SetStartKey (Const AccCode  : ShortString);
begin
  If (FAccCode <> AccCode) Then Begin
    // Take copy of active account code
    FAccCode := FullCustCode(AccCode);
    FSQLParentKey := FAccCode;
    // Reset current discount record
    FillChar (FDiscRec, SizeOf(FDiscRec), #0);
  End; { If (FAccCode <> AccCode) }
end;

{-----------------------------------------}

Procedure TAccountDiscount.CopyDataRecord;
Begin { CopyDataRecord }
  FDiscRec := FBtrIntf^.LMiscRecs^.CustDiscRec;
End; { CopyDataRecord }

{-----------------------------------------}

Function TAccountDiscount.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  With FBtrIntf^ Do Begin
    // General shared index including Discounts, FIFO, Serial No's, Window Positions, etc... records

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, CDDiscCode + FDiscSubType + FAccCode + SearchKey);

    if BtrOp = B_GetEq then
      KeyChk := KeyS
    else
      KeyChk := Copy(KeyS, 1,  Length(CDDiscCode + FDiscSubType + FAccCode));

    Loop := True;
    Case BtrOp of
      // Moving forward through file
      B_GetFirst   : Begin
                       BtrOpCode  := B_GetGEq;
                       BtrOpCode2 := B_GetNext;
                     End;

      B_GetGEq,
      B_GetGretr,
      B_GetNext    : BtrOpCode2 := B_GetNext;

      // Moving backward through file
      B_GetLess,
      B_GetLessEq,
      B_GetPrev    : BtrOpCode2 := B_GetPrev;

      B_GetLast    : Begin
                       BtrOpCode  := B_GetLessEq;
                       BtrOpCode2 := B_GetPrev;
                     End;

      // Looking for exact match - do it and finish
      B_GetEq      : Loop := False;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    Repeat
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      BtrOpCode := BtrOpCode2;

      //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
      If Not CheckKey(KeyS, KeyChk, Length(KeyChk), True) and (BtrOp <> B_GetEq) Then
        // Not a Matching record - abandon operation
        Result := 9; 
    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LMiscRecs^.RecMFix = CDDiscCode) And (LMiscRecs^.SubType = FDiscSubType) Then
        // Take local Copy
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (8, Result);
End; { GetDataRecord }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TAccountDiscount.AuthoriseFunction (Const FuncNo     : Byte;
                                             Const MethodName : String;
                                             Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);

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
End; { AuthoriseFunction }

{-----------------------------------------}

function TAccountDiscount.Get_adCurrency: SmallInt;
begin
  Result := FDiscRec.QBCurr;
end;

procedure TAccountDiscount.Set_adCurrency(Value: SmallInt);
begin
  FDiscRec.QBCurr := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TAccountDiscount.Get_adPrice: Double;
begin
  Result := FDiscRec.QSPrice;
end;

procedure TAccountDiscount.Set_adPrice(Value: Double);
begin
  FDiscRec.QSPrice := Value;
end;

{-----------------------------------------}

function TAccountDiscount.Get_adStockCode: WideString;
begin
  Result := FDiscRec.QStkCode;
end;

procedure TAccountDiscount.Set_adStockCode(const Value: WideString);
begin
  FDiscRec.QStkCode := FullStockCode(Value);
end;

{-----------------------------------------}

function TAccountDiscount.Get_adType: TDiscountType;
begin
  Case FDiscRec.QBType Of
    QBPriceCode    : Result := DiscSpecialPrice;
    QBBandCode     : Result := DiscBandPrice;
    QBMarginCode   : Result := DiscMargin;
    QBMarkupCode   : Result := DiscMarkup;
    QBQtyBCode     : Result := DiscQtyBreak;
    QBValueCode    : Result := DiscValueBased;
  Else
    Raise EValidation.Create ('Invalid Discount Type (' + FDiscRec.QBType + ')');
  End; { Case }
end;

procedure TAccountDiscount.Set_adType(Value: TDiscountType);
begin
  Case Value Of
    DiscSpecialPrice : FDiscRec.QBType := QBPriceCode;
    DiscBandPrice    : FDiscRec.QBType := QBBandCode;
    DiscMargin       : FDiscRec.QBType := QBMarginCode;
    DiscMarkup       : FDiscRec.QBType := QBMarkupCode;
    DiscQtyBreak     : FDiscRec.QBType := QBQtyBCode;
    DiscValueBased   : FDiscRec.QBType := QBValueCode;
  Else
    Raise EValidation.Create ('Invalid Discount Type (' + IntToStr(Value) + ')');
  End; { Case }
end;

{-----------------------------------------}

function TAccountDiscount.Get_adDiscPercent: Double;
begin
  Result := FDiscRec.QDiscP;
end;

procedure TAccountDiscount.Set_adDiscPercent(Value: Double);
begin
  FDiscRec.QDiscP := Value;
end;

{-----------------------------------------}

function TAccountDiscount.Get_adDiscValue: Double;
begin
  Result := FDiscRec.QDiscA;
end;

procedure TAccountDiscount.Set_adDiscValue(Value: Double);
begin
  FDiscRec.QDiscA := Value;
end;

{-----------------------------------------}

function TAccountDiscount.Get_adMarkupMarginPercent: Double;
begin
  Result := FDiscRec.QMUMG;
end;

procedure TAccountDiscount.Set_adMarkupMarginPercent(Value: Double);
begin
  FDiscRec.QMUMG := Value;
end;

{-----------------------------------------}

function TAccountDiscount.Get_adPriceBand: WideString;
begin
  Result := FDiscRec.QBand;
end;

procedure TAccountDiscount.Set_adPriceBand(const Value: WideString);
begin
  FDiscRec.QBand := ExtractChar(Value, #0);
end;

{-----------------------------------------}

function TAccountDiscount.Get_adStockCodeI: IStock;
begin
  With FToolkit As TToolkit Do
    Result := StockO.GetCloneInterface(FDiscRec.QStkCode);
end;

{-----------------------------------------}

function TAccountDiscount.BuildIndex(const StockCode: WideString; Currency: Smallint): WideString;
begin
  Result := FullStockCode(StockCode) + Chr(Currency) + HelpKStop;
end;

{-----------------------------------------}

procedure TAccountDiscount.InitNew (Const AccCode  : ShortString);
begin { InitNew }
  FAccCode := AccCode;

  FillChar (FDiscRec, SizeOf (FDiscRec), #0);
  With FDiscRec Do Begin
    DCCode := AccCode;
    QBType := QBBandCode;
  End; { With FDiscRec }
end; { InitNew }

{-----------------------------------------}

function TAccountDiscount.Add: IAccountDiscount;
Var
  AddO : TAccountDiscount;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TAccountDiscount.Create(imAdd, FToolkit, FBtrIntf, FDiscSubType);
  AddO.InitNew(FAccCode);

  Result := AddO;
end;

{-----------------------------------------}

procedure TAccountDiscount.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

Procedure TAccountDiscount.CloneDetails (Const DiscDets : CustDiscType; Const AccCode  : ShortString);
begin
  FDiscRec := DiscDets;
  FAccCode := AccCode;
end;

{-----------------------------------------}

function TAccountDiscount.Clone: IAccountDiscount;
Var
  CloneO : TAccountDiscount;
Begin { Clone }
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Customer Account object and initialise
  CloneO := TAccountDiscount.Create(imClone, FToolkit, FBtrIntf, FDiscSubType);
  CloneO.CloneDetails(FDiscRec, FAccCode);

  Result := CloneO;
end;

{-----------------------------------------}

function TAccountDiscount.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
  TkCustDisc  : TBatchDiscRec;
  BtrOp, Res  : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save Current Position in global file
  SaveMainPos(SaveInfo);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Res := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Res := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Res = 0) Then Begin
    // Copy into Toolkit structure
    ExCustDiscToTKCustDisc (FDiscRec, TkCustDisc);
    tkCustDisc.QtyBreak := False;
    tkCustDisc.RecordPos := FLockPosition;

    // Add/Update Discount
    SaveExLocalPos(SaveInfo2);
    Res := Ex_StoreDiscMatrix(@TkCustDisc,           // P
                              SizeOf (TkCustDisc),   // PSIZE
                              BtrOp);                // SEARCHMODE
    RestoreExLocalPos(SaveInfo2);

    //PR: 16/02/2016 v2016 R1 ABSEXCH-14208 Copy back Qty Break folio number to local record
    if Res = 0 then
      FDiscRec.QtyBreakFolio := TKCustDisc.QBFolio;

  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

{-----------------------------------------}

Procedure TAccountDiscount.LoadDetails (Const DiscDets : CustDiscType;
                                        Const AccCode  : ShortString;
                                        Const LockPos  : LongInt);
begin
  CloneDetails (DiscDets, AccCode);

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TAccountDiscount.Update: IAccountDiscount;
Var
  UpdateO : TAccountDiscount;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TAccountDiscount.Create(imUpdate, FToolkit, FBtrIntf, FDiscSubType);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FDiscRec, FAccCode, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

function TAccountDiscount.Get_adQtyBreaks: IQuantityBreak;
Var
  SaveInfo : TBtrieveFileSavePos;
  KeyS     : Str255;
  lStatus  : SmallInt;
begin
  // Check it is a Quantity Break entry
  If (FDiscRec.QBType = QBQtyBCode) Then Begin
    // Check Qty Break sub-object has been initialised
    If (Not Assigned(FQtyBrkO)) Then Begin
      // Create and initialise Quantity Break details
      If (FDiscSubType = 'C') Then
        // Customer
        FQtyBrkO := CreateTQtyBreak (13, FToolkit, FDiscSubType)
      Else
        // Supplier
        FQtyBrkO := CreateTQtyBreak (14, FToolkit, FDiscSubType);

      FQtyBrkI := FQtyBrkO;
    End; { If (Not Assigned(FQtyBrkO)) }

    //PR: 14/02/2012 Change to use new Qty Break record ABSEXCH-9795
    FQtyBrkO.SetStartKey (FDiscRec, FullNomKey(FDiscRec.QtyBreakFolio), qbFolioIdx);

    Result := FQtyBrkI;
  End { If (FDiscRec.QBType = QBQtyBCode) }
  Else
    // Not a Quantity Break
    Raise EInvalidMethod.Create ('The adQtyBreaks property is only available for Quantity Break Discounts');
end;

{-----------------------------------------}

//IBrowseInfo
function TAccountDiscount.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TAccountDiscount.Get_adDateEffectiveFrom: WideString;
begin
  Result := FDiscRec.CStartD;
end;

function TAccountDiscount.Get_adDateEffectiveTo: WideString;
begin
  Result := FDiscRec.CEndD;
end;

function TAccountDiscount.Get_adUseEffectiveDates: WordBool;
begin
  Result := FDiscRec.CUseDates;
end;

procedure TAccountDiscount.Set_adDateEffectiveFrom(
  const Value: WideString);
begin
  FDiscRec.CStartD := Value;
end;

procedure TAccountDiscount.Set_adDateEffectiveTo(const Value: WideString);
begin
  FDiscRec.CEndD := Value;
end;

procedure TAccountDiscount.Set_adUseEffectiveDates(Value: WordBool);
begin
  FDiscRec.CUseDates := Value;
end;

function TAccountDiscount.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TCustomerDiscountRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, FAccCode + SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LMiscRecs^.CustDiscRec.DiscCode  := MakeCDKey(DataRec.CustCode, DataRec.StockCode, DataRec.Currency) + '!';
    FBtrIntf^.LMiscRecs^.CustDiscRec.QStkCode  := FullStockCode(DataRec.StockCode);
    FBtrIntf^.LMiscRecs^.CustDiscRec.DCCode    := FullCustCode(DataRec.CustCode);
    FBtrIntf^.LMiscRecs^.CustDiscRec.QBType    := DataRec.DiscountType;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QBCurr    := DataRec.Currency;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QSPrice   := DataRec.Price;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QBand     := DataRec.Band;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QDiscP    := DataRec.DiscountP;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QDiscA    := DataRec.DiscountA;
    FBtrIntf^.LMiscRecs^.CustDiscRec.QMUMG     := DataRec.MarkUp;
    FBtrIntf^.LMiscRecs^.CustDiscRec.CUseDates := DataRec.UseDates;
    FBtrIntf^.LMiscRecs^.CustDiscRec.CStartD   := DataRec.StartDate;
    FBtrIntf^.LMiscRecs^.CustDiscRec.CEndD     := DataRec.EndDate;

    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TAccountDiscount.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if not UsingRedirectCache then
  begin
    FSQLRedirect := TSQLRedirect.Create;
    FSQLRedirect.FileNo := F_ACCOUNT_DISCOUNT;
    FSQLRedirect.WhereClause := FullQuery;
    FSQLRedirect.FieldList := FColumns;
    FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
    Result := FSQLRedirect.Open;
  end
end;

end.
