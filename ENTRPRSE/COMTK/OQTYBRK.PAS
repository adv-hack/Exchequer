unit oQtyBrk;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, GlobList,

     //PR: 14/02/2012 ABSEXCH-9795
     StrUtil,
     QtyBreakVar;

type
  TQuantityBreak = class(TBtrieveFunctions, IQuantityBreak, IQuantityBreak2, IBrowseInfo, IQuantityBreak3)
  private
    // Note: All properties protected to allow descendants access
    FDiscSubType : Char;         // SubType used to access records
    FIdxStr      : ShortString;  // Index String to find correct QtyBrk records


    //PR: 14/02/2012 Change to use new record. ABSEXCH-9795
    FQtyBreakRec : TQtyBreakRec;
    FDiscRec     : CustDiscType;


    FKillBtr     : Boolean;

    FIntfType    : TInterfaceMode;
    FToolkit     : TObject;
  protected
    // IQuantityBreak
    function  Get_qbQuantityFrom: Double; safecall;
    procedure Set_qbQuantityFrom(Value: Double); safecall;
    function  Get_qbQuantityTo: Double; safecall;
    procedure Set_qbQuantityTo(Value: Double); safecall;
    function  Get_qbType: TDiscountType; safecall;
    procedure Set_qbType(Value: TDiscountType); safecall;
    function  Get_qbPrice: Double; safecall;
    procedure Set_qbPrice(Value: Double); safecall;
    function  Get_qbDiscPercent: Double; safecall;
    procedure Set_qbDiscPercent(Value: Double); safecall;
    function  Get_qbDiscValue: Double; safecall;
    procedure Set_qbDiscValue(Value: Double); safecall;
    function  Get_qbMarkupMarginPercent: Double; safecall;
    procedure Set_qbMarkupMarginPercent(Value: Double); safecall;
    function  Get_qbCurrency: Smallint; safecall;
    procedure Set_qbCurrency(Value: Smallint); safecall;
    function  Get_qbPriceBand: WideString; safecall;
    procedure Set_qbPriceBand(const Value: WideString); safecall;

    //IQuantityBreak2
    function Get_qbDateEffectiveFrom: WideString; safecall;
    procedure Set_qbDateEffectiveFrom(const Value: WideString); safecall;
    function Get_qbDateEffectiveTo: WideString; safecall;
    procedure Set_qbDateEffectiveTo(const Value: WideString); safecall;
    function Get_qbUseEffectiveDates: WordBool; safecall;
    procedure Set_qbUseEffectiveDates(Value: WordBool); safecall;

    //IQuantityBreak3
    //PL: 18/10/2016 ABSEXCH-13768 Qty Brk Folio has not been added to
    //the COM Toolkit on the IQuantityBreak or IAccountDiscount tables
    function Get_qbFolio: Integer; safecall;

    function  Add: IQuantityBreak; safecall;
    function  Update: IQuantityBreak; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local Methods
    procedure InitNew (Const DiscDets : CustDiscType);
    Procedure InitObjects;
    Procedure LoadDetails (Const DiscDets : CustDiscType;
                           Const QBrkDets : TQtyBreakRec;
                           Const IdxStr   : ShortString;
                           Const LockPos  : LongInt);

    procedure SetSQLCaching(SubType : Char = ' '); override;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr;
                        Const DiscSub  : Char;
                        Const KillBtr  : Boolean);

    Destructor Destroy; override;
    //PR: 14/02/2012 Changed to include index in parameters. 0 is for Stock so we search on StockCode,
    // 1 is for Customer or Supplier and we search on the qty break folio.ABSEXCH-9795
    Procedure SetStartKey (Const DiscDets : CustDiscType;
                           Const IndexStr : ShortString;
                           Const AnIndex : Integer);
  End; { TQuantityBreak }


Function CreateTQtyBreak (Const ClientId : Integer;
                          Const Toolkit  : TObject;
                          Const SubType  : Char) : TQuantityBreak;

implementation

uses ComServ, oToolkit, DLL01U, DllErrU, BtsupU1, BtKeys1U, EtStrU;

{-------------------------------------------------------------------------------------------------}

Function CreateTQtyBreak (Const ClientId : Integer;
                          Const Toolkit  : TObject;
                          Const SubType  : Char) : TQuantityBreak;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTQtyBreak }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TQuantityBreak object
  //PR: 14/02/2012 Change to use new file ABSEXCH-9795
  BtrIntf^.Open_System(QtyBreakF, QtyBreakF);

  // Create basic TQuantityBreak object
  Result := TQuantityBreak.Create(imGeneral, Toolkit, BtrIntf, SubType, True);

  //PR: 14/02/2012 Change to use new file ABSEXCH-9795
  if SQLBeingUsed then
    Result.SetFileNos([QtyBreakF]);

End; { CreateTQtyBreak }

{-------------------------------------------------------------------------------------------------}

Constructor TQuantityBreak.Create (Const IType    : TInterfaceMode;
                                   Const Toolkit  : TObject;
                                   Const BtrIntf  : TCtkTdPostExLocalPtr;
                                   Const DiscSub  : Char;
                                   Const KillBtr  : Boolean);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IQuantityBreak3, BtrIntf); //PR: 21/01/2011 ABSEXCH-10392
  //PL: 18/10/2016 ABSEXCH-13768 IQuantityBreak3
  // Initialise Btrieve Ancestor
  FFileNo := QtyBreakF;
  FKillBtr := KillBtr;

  // Setup note indexing fields
  FDiscSubType := DiscSub;
  FIdxStr := '';

  // Initialise variables
  FillChar (FQtyBreakRec, SizeOf(FQtyBreakRec), #0);
  FillChar (FDiscRec, SizeOf(FDiscRec), #0);
  InitObjects;

  // Setup Links
  FIntfType := IType;
  FToolkit := Toolkit;

  // Default to index 0
  FIndex := 0;
  FObjectID := tkoQtyBreak;
End; { Create }

{-----------------------------------------}

Destructor TQuantityBreak.Destroy;
Begin { Destroy }
  { Destroy sub-ojects }
  InitObjects;

  If Assigned (FBtrIntf) And (FIntfType = imGeneral) And FKillBtr Then
    Dispose (FBtrIntf, Destroy);

  inherited Destroy;
End; { Destroy }

{-----------------------------------------}

Procedure TQuantityBreak.InitObjects;
Begin { InitObjects }
  FToolkit := NIL;
End; { InitObjects }

{-----------------------------------------}

//PR: 14/02/2012 Changed to include index in parameters. 0 is for Stock so we search on StockCode,
// 1 is for Customer or Supplier and we search on the qty break folio.ABSEXCH-9795
Procedure TQuantityBreak.SetStartKey (Const DiscDets : CustDiscType;
                                      Const IndexStr : ShortString;
                                      Const AnIndex : Integer);
Begin { SetStartKey }
  If (IndexStr <> FIdxStr) Then Begin
    // Take copy of new Index String
    FIdxStr := IndexStr;


    FDiscRec := DiscDets;

    // Reset current discount record
    FillChar (FQtyBreakRec, SizeOf(FQtyBreakRec), #0);

    FIndex := AnIndex;
  End; { If (IndexStr <> FIdxStr) }
End; { SetStartKey }

{-----------------------------------------}

Procedure TQuantityBreak.CopyDataRecord;
Begin { CopyDataRecord }
  FQtyBreakRec := FBtrIntf^.LQtyBreakRec;
End; { CopyDataRecord }

{-----------------------------------------}

Function TQuantityBreak.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;

Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  //PR: 14/02/2012 Changed to use new Qty Break file. ABSEXCH-9795
  With FBtrIntf^ Do Begin

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, FIdxStr + SearchKey);

    if FIndex = qbAcCodeIdx then
      KeyChk := TrimString(psRight, Copy(KeyS, 1, 10), #0)
    else
      //PR: 28/01/2013 ABSEXCH-13878 Need to limit check to QtyBreakFolio
      KeyChk := TrimString(psRight, Copy(KeyS, 1, SizeOf(FDiscRec.QtyBreakFolio)), #0);

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
      If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) and (BtrOp <> B_GetEq) Then
        // Not a valid Qty Break record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;

    If (Result = 0) Then
        CopyDataRecord
      Else
        Result := 4;

  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (8, Result);
End; { GetDataRecord }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TQuantityBreak.AuthoriseFunction (Const FuncNo     : Byte;
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

    // .qbDateEffectiveFrom, To & UseEffectiveDates properties
    200..202   //PR: 15/02/2012 Only allow write if Stock QtyBreak ABSEXH-9795
             : Result := FDiscRec.QtyBreakFolio = 0;
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

function TQuantityBreak.Get_qbCurrency: Smallint;
begin
  Result := FQtyBreakRec.qbCurrency;
end;

{-----------------------------------------}

procedure TQuantityBreak.Set_qbCurrency(Value: Smallint);
begin
  FQtyBreakRec.qbCurrency := ValidateCurrencyNo (Value);
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbDiscPercent: Double;
begin
  Result := FQtyBreakRec.qbDiscountPercent;
end;

procedure TQuantityBreak.Set_qbDiscPercent(Value: Double);
begin
  FQtyBreakRec.qbDiscountPercent := Value;
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbDiscValue: Double;
begin
  Result := FQtyBreakRec.qbDiscountAmount;
end;

procedure TQuantityBreak.Set_qbDiscValue(Value: Double);
begin
  FQtyBreakRec.qbDiscountAmount := Value;
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbMarkupMarginPercent: Double;
begin
  Result := FQtyBreakRec.qbMarginOrMarkup;
end;

procedure TQuantityBreak.Set_qbMarkupMarginPercent(Value: Double);
begin
  FQtyBreakRec.qbMarginOrMarkup := Value;
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbPrice: Double;
begin
  Result := FQtyBreakRec.qbSpecialPrice;
end;

procedure TQuantityBreak.Set_qbPrice(Value: Double);
begin
  FQtyBreakRec.qbSpecialPrice := Value;
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbQuantityFrom: Double;
begin
  Result := FQtyBreakRec.qbQtyFrom;
end;

procedure TQuantityBreak.Set_qbQuantityFrom(Value: Double);
begin
  FQtyBreakRec.qbQtyFrom := Value;
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbQuantityTo: Double;
begin
  Result := FQtyBreakRec.qbQtyTo;
end;

procedure TQuantityBreak.Set_qbQuantityTo(Value: Double);
begin
//PR 23/02/05 change so that value can be updated when in update mode
//  If (FIntfType <> imUpdate) Then
    FQtyBreakRec.qbQtyTo := Value
{  Else
    Raise Exception.Create ('The Quantity Break To cannot be Edited');}
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbType: TDiscountType;
begin
  Case FQtyBreakRec.qbBreakType Of
    dtPriceBand    : Result := DiscBandPrice;
    dtSpecialPrice : Result := DiscSpecialPrice;
    dtMargin       : Result := DiscMargin;
    dtMarkup       : Result := DiscMarkup;
  Else
    Raise EValidation.Create ('Invalid Discount Type (' + IntToStr(Ord(FQtyBreakRec.qbBreakType)) + ')');
  End; { Case }
end;

procedure TQuantityBreak.Set_qbType(Value: TDiscountType);
begin
  Case Value Of
    DiscSpecialPrice : FQtyBreakRec.qbBreakType := dtSpecialPrice;
    DiscBandPrice    : FQtyBreakRec.qbBreakType := dtPriceBand;
    DiscMargin       : FQtyBreakRec.qbBreakType := dtMargin;
    DiscMarkup       : FQtyBreakRec.qbBreakType := dtMarkup;
    //DiscQtyBreak   : NOTE: Can't have a QtyBrk in a QtyBrk!
  Else
    Raise EValidation.Create ('Invalid Discount Type (' + IntToStr(Value) + ')');
  End; { Case }
end;

{-----------------------------------------}

function TQuantityBreak.Get_qbPriceBand: WideString;
begin
  Result := FQtyBreakRec.qbPriceBand;
end;

procedure TQuantityBreak.Set_qbPriceBand(const Value: WideString);
begin
  FQtyBreakRec.qbPriceBand := ExtractChar(Value, #0);
end;

{-----------------------------------------}

procedure TQuantityBreak.InitNew (Const DiscDets : CustDiscType);
begin { InitNew }
  FDiscRec := DiscDets;

  FillChar (FQtyBreakRec, SizeOf (FQtyBreakRec), #0);
  With FQtyBreakRec Do Begin
    qbAcCode     := FDiscRec.DCCode;
    qbCurrency   := FDiscRec.QBCurr;
    qbBreakType  := dtPriceBand;
    qbPriceBand  := 'A';
    qbQtyFrom    := 1;
    qbQtyTo      := 1;
    qbFolio := FDiscRec.QtyBreakFolio;
  End; { With FQtyBreakRec }
end; { InitNew }

{-----------------------------------------}

function TQuantityBreak.Add: IQuantityBreak;
Var
  AddO : TQuantityBreak;
begin { Add }
  AuthoriseFunction(100, 'Add');

  AddO := TQuantityBreak.Create(imAdd, FToolkit, FBtrIntf, FDiscSubType, False);
  AddO.InitNew(FDiscRec);

  Result := AddO;
end;

{-----------------------------------------}

procedure TQuantityBreak.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{-----------------------------------------}

function TQuantityBreak.Save: Integer;
Var
  SaveInfo    : TBtrieveFileSavePos;
  SaveInfo2   : TBtrieveFileSavePos;
  TkQtyBrk    : TBatchDiscRec;
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
    // Copy Qty Brk into Toolkit structure
    //PR: 14/02/2012 Change to use new Qty Break record ABSEXCH-9795
    ExQtyBrkToTKQtyBrk (FQtyBreakRec, TkQtyBrk);
    TkQtyBrk.StockCode := FDiscRec.QStkCode;
    if FIntfType = imUpdate then
      TkQtyBrk.RecordPos := FLockPosition
    else
    begin
      if Trim(TkQtyBrk.CustCode) <> '' then //From a cust/supp discount so set date/currency fields the same as the header.
      begin
        TkQtyBrk.UseDates := FDiscRec.CUseDates;
        TkQtyBrk.StartDate := FDiscRec.CStartD;
        TkQtyBrk.EndDate := FDiscRec.CEndD;
        TkQtyBrk.SPCurrency := FDiscRec.QBCurr;
      end;
    end;

    // Add/Update Discount
    SaveExLocalPos(SaveInfo2);
    //PR: 14/02/2012 Changed to use new Qty Break dlltk function ABSEXCH-9795
    Res := Ex_StoreDiscMatrix(@TkQtyBrk,           // P
                              SizeOf (TkQtyBrk),   // PSIZE
                              BtrOp);              // SEARCHMODE
    RestoreExLocalPos(SaveInfo2);
  End; { If (Res = 0) }

  // Restore original position in global customer file
  RestoreMainPos(SaveInfo);

  Result := Res;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;
end;

{-----------------------------------------}

Procedure TQuantityBreak.LoadDetails (Const DiscDets : CustDiscType;
                                      Const QBrkDets : TQtyBreakRec;
                                      Const IdxStr   : ShortString;
                                      Const LockPos  : LongInt);
begin
  FDiscRec := DiscDets;
  FQtyBreakRec := QBrkDets;

  FIdxStr := IdxStr;

  LockCount := 1;
  LockPosition := LockPos;
end;

{-----------------------------------------}

function TQuantityBreak.Update: IQuantityBreak;
Var
  UpdateO : TQuantityBreak;
  FuncRes : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Lock Current Record
  FuncRes := Lock;

  If (FuncRes = 0) Then Begin
    // Create an update object
    UpdateO := TQuantityBreak.Create(imUpdate, FToolkit, FBtrIntf, FDiscSubType, False);

    // Pass current Location Record and Locking Details into sub-object
    UpdateO.LoadDetails(FDiscRec, FQtyBreakRec, FIdxStr, LockPosition);
    LockCount := 0;
    LockPosition := 0;

    Result := UpdateO;
  End; { If (FuncRes = 0) }
end;

{-----------------------------------------}

//IBrowseInfo
function TQuantityBreak.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;


function TQuantityBreak.Get_qbDateEffectiveFrom: WideString;
begin
//PR: 15/02/2012 Allow read of dates for all qty breaks (previously just stock qty breaks.) ABSEXCH-9795
//  AuthoriseFunction(200, 'qbDateEffectiveFrom', 1);

  Result := FQtyBreakRec.qbStartDate;
end;

function TQuantityBreak.Get_qbDateEffectiveTo: WideString;
begin
//PR: 15/02/2012 Allow read of dates for all qty breaks (previously just stock qty breaks.) ABSEXCH-9795
//  AuthoriseFunction(201, 'qbDateEffectiveTo', 1);
  Result := FQtyBreakRec.qbEndDate;
end;

function TQuantityBreak.Get_qbUseEffectiveDates: WordBool;
begin
//PR: 15/02/2012 Allow read of dates for all qty breaks (previously just stock qty breaks.) ABSEXCH-9795
//  AuthoriseFunction(202, 'qbUseEffectiveDates', 1);
  Result := FQtyBreakRec.qbUseDates;
end;

procedure TQuantityBreak.Set_qbDateEffectiveFrom(const Value: WideString);
begin
  AuthoriseFunction(200, 'qbDateEffectiveFrom', 1);
  FQtyBreakRec.qbStartDate := Value;
end;

procedure TQuantityBreak.Set_qbDateEffectiveTo(const Value: WideString);
begin
  AuthoriseFunction(201, 'qbDateEffectiveTo', 1);
  FQtyBreakRec.qbEndDate := Value;
end;

procedure TQuantityBreak.Set_qbUseEffectiveDates(Value: WordBool);
begin
  AuthoriseFunction(202, 'qbUseEffectiveDates', 1);
  FQtyBreakRec.qbUseDates := Value;
end;

procedure TQuantityBreak.SetSQLCaching(SubType: Char);
begin
  inherited SetSQLCaching(FDiscSubType);
end;

//PL: 18/10/2016 ABSEXCH-13768 Qty Brk Folio has not been added to
//the COM Toolkit on the IQuantityBreak or IAccountDiscount tables
function TQuantityBreak.Get_qbFolio: Integer;
begin
  Result := FQtyBreakRec.qbFolio;
end;

end.
