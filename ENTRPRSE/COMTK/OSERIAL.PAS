unit oSerial;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, oNotes, GlobList;

type
  TSerialBatch = class(TBtrieveFunctions, ISerialBatch, ISerialBatchDetails, IBrowseInfo,
                        ISerialBatch2, ISerialBatchDetails2, ISerialBatch3, ISerialBatchDetails3, ISerialBatch4,
                        IToolkitRecord)
  private
    FSerialRec   : SerialType;

    FStkCode     : ShortString;
    FStkFolio    : LongInt;

    FKillBtr     : Boolean;

    FNotesO      : TNotes;
    FNotesI      : INotes;

    FIntfType    : TInterfaceMode;
    FToolkit     : TObject;
  protected
    // ISerialBatch
    function  Get_snSerialNo: WideString; safecall;
    procedure Set_snSerialNo(const Value: WideString); safecall;
    function  Get_snBatchNo: WideString; safecall;
    procedure Set_snBatchNo(const Value: WideString); safecall;
    function  Get_snType: TSerialBatchType; safecall;
    procedure Set_snSold(Value: WordBool); safecall;
    function  Get_snSold: WordBool; safecall;
    function  Get_snUseByDate: WideString; safecall;
    procedure Set_snUseByDate(const Value: WideString); safecall;
    procedure Set_snInDate(const Value: WideString); safecall;
    function  Get_snInDate: WideString; safecall;
    function  Get_snInOrderRef: WideString; safecall;
    procedure Set_snInOrderRef(const Value: WideString); safecall;
    function  Get_snInOrderLine: Integer; safecall;
    procedure Set_snInOrderLine(Value: Integer); safecall;
    function  Get_snInDocRef: WideString; safecall;
    procedure Set_snInDocRef(const Value: WideString); safecall;
    function  Get_snInDocLine: Integer; safecall;
    procedure Set_snInDocLine(Value: Integer); safecall;
    function  Get_snInLocation: WideString; safecall;
    procedure Set_snInLocation(const Value: WideString); safecall;
    procedure Set_snOutDate(const Value: WideString); safecall;
    function  Get_snOutDate: WideString; safecall;
    function  Get_snOutOrderRef: WideString; safecall;
    procedure Set_snOutOrderRef(const Value: WideString); safecall;
    function  Get_snOutOrderLine: Integer; safecall;
    procedure Set_snOutOrderLine(Value: Integer); safecall;
    function  Get_snOutDocRef: WideString; safecall;
    procedure Set_snOutDocRef(const Value: WideString); safecall;
    function  Get_snOutDocLine: Integer; safecall;
    procedure Set_snOutDocLine(Value: Integer); safecall;
    function  Get_snOutLocation: WideString; safecall;
    procedure Set_snOutLocation(const Value: WideString); safecall;
    function  Get_snCostPrice: Double; safecall;
    procedure Set_snCostPrice(Value: Double); safecall;
    function  Get_snCostPriceCurrency: Smallint; safecall;
    procedure Set_snCostPriceCurrency(Value: Smallint); safecall;
    function  Get_snSalesPrice: Double; safecall;
    procedure Set_snSalesPrice(Value: Double); safecall;
    function  Get_snSalesPriceCurrency: Smallint; safecall;
    procedure Set_snSalesPriceCurrency(Value: Smallint); safecall;
    function  Get_snBatchQuantity: Double; safecall;
    procedure Set_snBatchQuantity(Value: Double); safecall;
    function  Get_snBatchQuantitySold: Double; safecall;
    procedure Set_snBatchQuantitySold(Value: Double); safecall;
    function  Get_snDailyRate: Double; safecall;
    procedure Set_snDailyRate(Value: Double); safecall;
    function  Get_snCompanyRate: Double; safecall;
    procedure Set_snCompanyRate(Value: Double); safecall;
    function  Get_snNotes: INotes; safecall;
    function  Add: ISerialBatch; safecall;
    function  Update: ISerialBatch; safecall;
    function  Clone: ISerialBatch; safecall;
    function  Save: Integer; safecall;
    procedure Cancel; safecall;
    function  BuildUsedSerialIndex(Sold: WordBool; const SerialNo: WideString): WideString; safecall;
    function  BuildSerialIndex(const SerialNo: WideString): WideString; safecall;
    function  BuildBatchIndex(const BatchNo: WideString): WideString; safecall;

    function  Get_Index: TSerialBatchIndex; safecall;
    procedure Set_Index(Value: TSerialBatchIndex); safecall;

    //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    function Get_snBinCode: WideString; safecall;
    procedure Set_snBinCode(const Value: WideString); safecall;

    //25/7/05 ISerialBatch3 methods - 5.70 for goods returned
    function Get_snReturned: WordBool; safecall;
    procedure Set_snReturned(Value: WordBool); safecall;
    function Get_snReturnOurRef: WideString; safecall;
    procedure Set_snReturnOurRef(const Value: WideString); safecall;
    function Get_snBatchReturnedQty: Double; safecall;
    procedure Set_snBatchReturnedQty(Value: Double); safecall;
    function Get_snReturnLineNo: Integer; safecall;
    procedure Set_snReturnLineNo(Value: Integer); safecall;


    //PR: 11/04/2014 ABSEXCH-14755 Add IToolkitRecord functions to allow AddToBatch to get record
    function GetData: WideString; safecall;
    function ConvertData(const DataRec: WideString): WideString; safecall;


    //PR: 22/02/2010 Added new functions to deal with SQL Caching in redirect tables
    function LoadTheCache : Integer; override;
    function GetRedirectedDataRec(const BtrOp : SmallInt; const SearchKey : string) : Integer;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local Methods
    Procedure InitNew (Const StkCode : ShortString; Const StkFolio : LongInt);
    Procedure InitObjects;
    Procedure LoadDetails (Const SerDets : SerialType; Const LockPos : LongInt);
  public
    Constructor Create (Const IType     : TInterfaceMode;
                        Const Toolkit   : TObject;
                        Const BtrIntf   : TCtkTdPostExLocalPtr;
                        Const KillBtr   : Boolean;
                        Const IsMainObj : Boolean);

    Destructor Destroy; override;

    Procedure CloneDetails (Const SerDets : SerialType);
    Procedure InitFromTrans (Const TH       : TBatchTHRec;
                             Const TL       : TBatchTLRec;
                             Const StkFolio : LongInt);
    Procedure SetStockKeys (Const StkCode : ShortString; Const StkFolio : LongInt);
  End; { TSerialBatch }


Function CreateTSerialBatch (Const ClientId : Integer;
                             Const Toolkit  : TObject) : TSerialBatch;


implementation

uses ComServ, oToolkit, DllErrU, BtsupU1, BtKeys1U, EtStrU, ETMiscU, BTS1,
     CurrncyU, DllSrBOM, SysU1, SQLStructuresU, TKSQL, ComnU2, ComnUnit;

{-------------------------------------------------------------------------------------------------}

Function CreateTSerialBatch (Const ClientId : Integer;
                             Const Toolkit  : TObject) : TSerialBatch;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStockBOM }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TQuantityBreak object
  BtrIntf^.Open_System(MiscF, MiscF);
  BtrIntf^.Open_System(PwrdF, PwrdF);   { Serial/Batch Notes }

  // Create basic TSerialBatch object
  Result := TSerialBatch.Create(imGeneral, Toolkit, BtrIntf, True, True);

  if SQLBeingUsed then
    Result.SetFileNos([PwrdF, MiscF]);

End; { CreateTStockBOM }

{-------------------------------------------------------------------------------------------------}

constructor TSerialBatch.Create(Const IType     : TInterfaceMode;
                                Const Toolkit   : TObject;
                                Const BtrIntf   : TCtkTdPostExLocalPtr;
                                Const KillBtr   : Boolean;
                                Const IsMainObj : Boolean);
Begin { Create }
  If IsMainObj Then
    Inherited Create (ComServer.TypeLib, ISerialBatch3, BtrIntf)
  Else
    Inherited Create (ComServer.TypeLib, ISerialBatchDetails3, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MiscF;
  FKillBtr := KillBtr;

  // Initialise variables
  FStkFolio := -191919191;
  InitObjects;

  // Setup Links
  FIntfType := IType;
  FToolkit := Toolkit;

  // Index 0 - Used to find serial numbers for a particulr stock folio number
  FIndex := snIdxUsedSerialNo;

  FObjectID := tkoSerialBatch;
End; { Create }

{------------------------------}

destructor TSerialBatch.Destroy;
begin
  { Destroy sub-ojects }
  InitObjects;
  If Assigned (FBtrIntf) And (FIntfType = imGeneral) And FKillBtr Then
    Dispose (FBtrIntf, Destroy);

  inherited;
end;

{------------------------------}

procedure TSerialBatch.InitObjects;
begin
  FNotesO := NIL;
  FNotesI := NIL;

  FToolkit := NIL;
end;

{-----------------------------------------}

procedure TSerialBatch.SetStockKeys (Const StkCode : ShortString; Const StkFolio : LongInt);
begin
  If (FStkFolio <> StkFolio) Then Begin
    // Take copy of new Stock folio Number
    FStkCode := StkCode;
    FStkFolio := StkFolio;
    FSQLParentKey := FullNomKey(StkFolio);
    // Reset current Serial/Batch Number record
    FillChar (FSerialRec, SizeOf(FSerialRec), #0);
  End; { If (IndexStr <> FIdxStr) }
end;

{------------------------------}

function TSerialBatch.Get_Index: TSerialBatchIndex;
begin
  Result := Inherited Get_Index;
end;

procedure TSerialBatch.Set_Index(Value: TSerialBatchIndex);
begin
  Inherited Set_Index (Value);
end;

{------------------------------}

Procedure TSerialBatch.CopyDataRecord;
Begin { CopyDataRecord }
  FSerialRec := FBtrIntf^.LMiscRecs.SerialRec;
  FSerialRec.DateIn := GetSerialInDate(FSerialRec);
End; { CopyDataRecord }

{-----------------------------------------}

Function TSerialBatch.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;

  //----------------------------

  Function GotRecord : Boolean;
  Begin { GotRecord }
    With FBtrIntf^.LMiscRecs^, SerialRec Do Begin
      // Always check RecMFix and SubType
      Result := (RecMFix = MFIFOCode) And (SubType = MSernSub);

      If Result And (FIndex = 0) Then Begin
        // Serial Number record - Always check stock folio number
        Result := (StkFolio = FStkFolio);
      End; { If Result }

      If Result And (BtrOp In [B_GetLess, B_GetLess, B_GetEq, B_GetGretr, B_GetGEq]) Then Begin
        // Btrieve Search Function - have to start checking other things


      End; { If Result And (BtrOp In []) }
    End; { With FBtrIntf^.LMiscRecs, SerialRec }
  End; { GotRecord }

  //----------------------------

Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';

  if UsingRedirectCache then
    Result := GetRedirectedDataRec(BtrOp, SearchKey)
  else
  With FBtrIntf^ Do Begin
    // General shared index including Discounts, FIFO, Serial No's, Window Positions, etc... records

    If (FIndex = 0) Then
      // Idx 0 - StkFolio + Sold + Serial No
      KeyChk := MFIFOCode + MSernSub + FullNomKey(FStkFolio)
    Else
      // Idx 1 - Serial No or Idx 2 - Batch No
      KeyChk := MFIFOCode + MSernSub;
    KeyS := SetKeyString(BtrOp, KeyChk + SearchKey);

    BtrOpCode := BtrOp;
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

      // HM 11/12/01: Modified as GetEqual would find matching codes for other stock items
      //              and return with a 0
      // Looking for exact match - do it and finish
      {B_GetEq      : Loop := False;}
      B_GetEq      : Begin
                       KeyChk := KeyS;
                       BtrOpCode2 := B_GetNext;
                     End;
    Else
      Raise Exception.Create ('Invalid Btrieve Operation');
    End; { Case BtrOp}

    // Loop through file until we wither get a btrieve error or we find a desired
    // record.  Except for GetEqual which just looks for an exact match
    Repeat
      // Look for record
      Result := LFind_Rec (BtrOpCode, FFileNo, FIndex, KeyS);

      If (Result = 0) Then Begin
        // Change Btrieve Operation to look for next record
        BtrOpCode := BtrOpCode2;

        //AP : 3/11/2016 : ABSEXCH-16305 GetNext returning Error 4 on Customer Object
        If ((Not CheckKey(KeyS, KeyChk, Length(KeyChk), True))) and (BtrOp <> B_GetEq) Then
          // Invalid Record - return End of File
          Result := 9;
      End; { If (Result = 0) }
    Until (Result <> 0) Or (Not Loop) Or ((Result = 0) And (LMiscRecs^.SerialRec.StkFolio = FStkFolio));

    FKeyString := KeyS;

    If (Result = 0) And ((Result = 0) And (LMiscRecs^.SerialRec.StkFolio = FStkFolio)) Then Begin
      // check correct record type was returned
      If GotRecord Then
        // Take local Copy
        CopyDataRecord
      Else
        // Wrong Record - report Key Not Found
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (95, Result);
End; { GetDataRecord }

{------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TSerialBatch.AuthoriseFunction (Const FuncNo     : Byte;
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

    // .snNotes property
    201       : Result := (FIntfType In [imGeneral, imClone]);
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

{----------------------------------------------------------------------------}

function TSerialBatch.Get_snBatchNo: WideString;
begin
  Result := FSerialRec.BatchNo;
end;

procedure TSerialBatch.Set_snBatchNo(const Value: WideString);
begin
  FSerialRec.BatchNo := Value;
end;

{------------------------------}

function TSerialBatch.Get_snSerialNo: WideString;
begin
  Result := FSerialRec.SerialNo;
end;

procedure TSerialBatch.Set_snSerialNo(const Value: WideString);
begin
  FSerialRec.SerialNo := Value;
end;

{------------------------------}

function TSerialBatch.Get_snType: TSerialBatchType;
begin
  If FSerialRec.BatchRec Then Begin
    // Batch or Batch Child
    If FSerialRec.BatchChild Then
      Result := snTypeBatchSale
    Else
      Result := snTypeBatch;
  End { If FSerialRec.BatchRec }
  Else
    Result := snTypeSerial;
end;

{------------------------------}

function TSerialBatch.Get_snSold: WordBool;
begin
  Result := FSerialRec.Sold;
end;

procedure TSerialBatch.Set_snSold(Value: WordBool);
begin
  FSerialRec.Sold := Value;
end;

{------------------------------}

function TSerialBatch.Get_snUseByDate: WideString;
begin
  Result := FSerialRec.DateUseX;
end;

procedure TSerialBatch.Set_snUseByDate(const Value: WideString);
begin
  FSerialRec.DateUseX := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInDate: WideString;
begin
  Result := FSerialRec.DateIn;
end;

procedure TSerialBatch.Set_snInDate(const Value: WideString);
begin
  FSerialRec.DateIn := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInOrderRef: WideString;
begin
  Result := FSerialRec.InOrdDoc;
end;

procedure TSerialBatch.Set_snInOrderRef(const Value: WideString);
begin
  FSerialRec.InOrdDoc := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInOrderLine: Integer;
begin
  Result := FSerialRec.InOrdLine;
end;

procedure TSerialBatch.Set_snInOrderLine(Value: Integer);
begin
  FSerialRec.InOrdLine := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInDocRef: WideString;
begin
  Result := FSerialRec.Indoc;
end;

procedure TSerialBatch.Set_snInDocRef(const Value: WideString);
begin
  FSerialRec.Indoc := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInDocLine: Integer;
begin
  Result := FSerialRec.BuyLine;
end;

procedure TSerialBatch.Set_snInDocLine(Value: Integer);
begin
  FSerialRec.BuyLine := Value;
end;

{------------------------------}

function TSerialBatch.Get_snInLocation: WideString;
begin
  Result := FSerialRec.InMLoc;
end;

procedure TSerialBatch.Set_snInLocation(const Value: WideString);
begin
  FSerialRec.InMLoc := LJVar(Value,MLocKeyLen);
end;

{------------------------------}

function TSerialBatch.Get_snOutDate: WideString;
begin
  Result := FSerialRec.DateOut;
end;

procedure TSerialBatch.Set_snOutDate(const Value: WideString);
begin
  FSerialRec.DateOut := Value;
end;

{------------------------------}

function TSerialBatch.Get_snOutOrderRef: WideString;
begin
  Result := FSerialRec.OutOrdDoc;
end;

procedure TSerialBatch.Set_snOutOrderRef(const Value: WideString);
begin
  FSerialRec.OutOrdDoc := Value;
end;

{------------------------------}

function TSerialBatch.Get_snOutOrderLine: Integer;
begin
  Result := FSerialRec.OutOrdLine;
end;

procedure TSerialBatch.Set_snOutOrderLine(Value: Integer);
begin
  FSerialRec.OutOrdLine := Value;
end;

{------------------------------}

function TSerialBatch.Get_snOutDocRef: WideString;
begin
  Result := FSerialRec.OutDoc;
end;

procedure TSerialBatch.Set_snOutDocRef(const Value: WideString);
begin
  FSerialRec.OutDoc := Value;
end;

{------------------------------}

function TSerialBatch.Get_snOutDocLine: Integer;
begin
  Result := FSerialRec.SoldLine;
end;

procedure TSerialBatch.Set_snOutDocLine(Value: Integer);
begin
  FSerialRec.SoldLine := Value;
end;

{------------------------------}

function TSerialBatch.Get_snOutLocation: WideString;
begin
  Result := FSerialRec.OutMLoc;
end;

procedure TSerialBatch.Set_snOutLocation(const Value: WideString);
begin
  FSerialRec.OutMLoc := LJVar(Value,MLocKeyLen);
end;

{------------------------------}

function TSerialBatch.Get_snCostPrice: Double;
begin
  Result := FSerialRec.SerCost;
end;

procedure TSerialBatch.Set_snCostPrice(Value: Double);
begin
  FSerialRec.SerCost := Value;
end;

{------------------------------}

function TSerialBatch.Get_snCostPriceCurrency: Smallint;
begin
  Result := FSerialRec.CurCost;
end;

procedure TSerialBatch.Set_snCostPriceCurrency(Value: Smallint);
begin
  FSerialRec.CurCost := ValidateCurrencyNo (Value);
end;

{------------------------------}

function TSerialBatch.Get_snSalesPrice: Double;
begin
  Result := FSerialRec.SerSell;
end;

procedure TSerialBatch.Set_snSalesPrice(Value: Double);
begin
  FSerialRec.SerSell := Value;
end;

{------------------------------}

function TSerialBatch.Get_snSalesPriceCurrency: Smallint;
begin
  Result := FSerialRec.CurSell;
end;

procedure TSerialBatch.Set_snSalesPriceCurrency(Value: Smallint);
begin
  FSerialRec.CurSell := ValidateCurrencyNo (Value);
end;

{------------------------------}

function TSerialBatch.Get_snBatchQuantity: Double;
begin
  Result := FSerialRec.BuyQty;
end;

procedure TSerialBatch.Set_snBatchQuantity(Value: Double);
begin
  FSerialRec.BuyQty := Value;
end;

{------------------------------}

function TSerialBatch.Get_snBatchQuantitySold: Double;
begin
  Result := FSerialRec.QtyUsed;
end;

procedure TSerialBatch.Set_snBatchQuantitySold(Value: Double);
begin
  FSerialRec.QtyUsed := Value;
end;

{------------------------------}

function TSerialBatch.Get_snDailyRate: Double;
begin
  Result := FSerialRec.SerCRates [True];
end;

procedure TSerialBatch.Set_snDailyRate(Value: Double);
begin
  FSerialRec.SerCRates [True] := Value;
end;

{------------------------------}

function TSerialBatch.Get_snCompanyRate: Double;
begin
  Result := FSerialRec.SerCRates [False];
end;

procedure TSerialBatch.Set_snCompanyRate(Value: Double);
begin
  FSerialRec.SerCRates [False] := Value;
end;

{------------------------------}

function TSerialBatch.Get_snNotes: INotes;
var
  Res : longint;
begin
  AuthoriseFunction(201, 'snNotes', 1);

  { Check Notes sub-object has been initialised }
  If (Not Assigned(FNotesO)) Then Begin
    { Create and initialise Customer Details }
    FNotesO := TNotes.Create(imGeneral,
                             FToolkit,
                             FBtrIntF,
                             'SER',
                             '2',
                             False);

    FNotesI := FNotesO;
  End; { If (Not Assigned(FNotesO)) }

  if FSerialRec.NoteFolio = 0 then
  begin
    if Lock = 0 then
    begin
      PositionOnLock;

      MiscRecs.SerialRec.NoteFolio := GetNextCount(SKF, True, False, 0);

      Res := Put_Rec(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex);

      if Res = 0 then
        FSerialRec.NoteFolio := MiscRecs.SerialRec.NoteFolio
      else
        raise Exception.Create('Unable to update Serial Number Note folio');
    end
    else
      raise Exception.Create('Unable to update Serial Number Note folio - Serial Record Locked');


  end;

  FNotesO.SetStartKey (FSerialRec.SerialNo,
                       NoteTCode + NoteRCode + FullNCode(FullNomKey(FSerialRec.NoteFolio)));
  if Trim(FSerialRec.SerialNo) <> '' then
    FNotesO.SetSerialNoKey(MFIFOCode + MSernSub + MakeSNKey(FSerialRec.StkFolio, FSerialRec.Sold, FSerialRec.SerialNo), 0,
                           FSerialRec.NoteFolio)
  else
    FNotesO.SetSerialNoKey(MFIFOCode + MSernSub + FSerialRec.BatchNo, 1, FSerialRec.NoteFolio);

  Result := FNotesI;
end;

{------------------------------}

Procedure TSerialBatch.InitNew (Const StkCode : ShortString; Const StkFolio : LongInt);
Begin { InitNew }
  FStkCode  := StkCode;
  FStkFolio := StkFolio;

  FillChar (FSerialRec, SizeOf(FSerialRec), #0);
  With FSerialRec Do Begin
    StkFolio := FStkFolio;

    // Default to base for multi-currency systems
    If ExSyss.MCMode Then
      CurCost := 1;

    // Default to Date In to today
    DateIn := FormatDateTime ('YYYYMMDD', Now);
  End; { With FSerialRec }
End; { InitNew }

Procedure TSerialBatch.InitFromTrans (Const TH       : TBatchTHRec;
                                      Const TL       : TBatchTLRec;
                                      Const StkFolio : LongInt);
var
  DiscP : Double;
Begin { InitNew }
  FStkCode  := FullStockCode(TL.StockCode);
  FStkFolio := StkFolio;

  FillChar (FSerialRec, SizeOf(FSerialRec), #0);
  With FSerialRec Do Begin
    StkFolio := FStkFolio;

    InDoc := TH.OurRef;
    BuyLine := TL.AbsLineNo;

    DateIn := TH.TransDate;


    CurCost := TH.Currency;

    //PR: 24/05/2012 ABSEXCH-12919 Serial Cost price should take account of Discounts & Uplift
    with TL do
    begin
      DiscP := Calc_PAmountAD (Round_Up(NetValue,Syss.NoCosDec),
                             Discount, DiscountChr,
                             tlMultiBuyDiscount, tlMultiBuyDiscountChr,
                             tlTransValueDiscount, tlTransValueDiscountChr);

      If (tlUseCase) then
        SerCost :=Round_Up(Calc_StkCP((NetValue-DiscP),tlQtyPack,tlUseQtyMul)+CostPrice,Syss.NoCosDec)
      else
        SerCost :=Round_Up(Calc_StkCP((NetValue-DiscP+CostPrice),QtyMul,tlUseQtyMul),Syss.NoCosDec);
    end;

    BuyQty := 1.0;

    InMLoc := TL.MLocStk;

    //PR: 24/11/2011 If we have a job code on the line then stock is automatically booked out,
    //so set fields accordingly.
    if (Not ExSyss.JBIgnore) and (Trim(TL.JobCode) <> '') then
    begin
      OutDoc := InDoc;
      SoldLine := BuyLine;
      OutMLoc := InMLoc;

      //PR: 25/11/2011 Date out needs to be line date rather than header date.
      DateOut := TL.LineDate;
      CurSell := CurCost;
      Sold    := True;
      SerSell := SerCost;

      QtyUsed := BuyQty;

    end;

    // Default currency exchange rates
    SerCRates := SyssCurr^.Currencies[CurCost].CRates;
    SetTriRec(CurCost, SUseORate, SerTriR);
  End; { With FSerialRec }
End; { InitNew }

function TSerialBatch.Add: ISerialBatch;
Var
  FSerialO : TSerialBatch;
begin { Add }
  AuthoriseFunction(100, 'Add');

  FSerialO := TSerialBatch.Create(imAdd, FToolkit, FBtrIntf, False, True);
  FSerialO.InitNew (FStkCode, FStkFolio);

  Result := FSerialO;
end;

{------------------------------}

// HM 12/03/01: Removed from interface as Editing not supported by Ex_StoreSerialBatch
procedure TSerialBatch.Cancel;
begin
  AuthoriseFunction(103, 'Cancel');

  Unlock;
end;

{------------------------------}

Procedure TSerialBatch.CloneDetails (Const SerDets : SerialType);
begin
  FSerialRec := SerDets;
end;

function TSerialBatch.Clone: ISerialBatch;
Var
  FCloneO : TSerialBatch;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FCloneO := TSerialBatch.Create(imClone, FToolkit, FBtrIntf, False, True);
  FCloneO.CloneDetails(FSerialRec);

  Result := FCloneO;
end;

{------------------------------}

function TSerialBatch.Save: Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  TkSerial : TBatchSerialRec;
  BtrOp    : SmallInt;
  NewQty  : Double;
  NewOurRef : string;
  NewLineNo : longint;
begin
  AuthoriseFunction(102, 'Save');
  NewLineNo := 0;
  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
    if Result = 0 then
    begin
      MiscRecs.SerialRec.DateUseX := FSerialRec.DateUseX;
      MiscRecs.SerialRec.SerCost := FSerialRec.SerCost;
      MiscRecs.SerialRec.CurCost := FSerialRec.CurCost;
//      MiscRecs.SerialRec.BuyQty := FSerialRec.BuyQty;
      MiscRecs.SerialRec.InBinCode := FSerialRec.InBinCode;
//      MiscRecs.SerialRec.SerCRates := FSerialRec.SerCRates;
      NewQty := FSerialRec.BuyQty;
      NewOurRef := FSerialRec.InDoc;
      NewLineNo := FSerialRec.BuyLine;

	  // PL 29/11/2016 : 2017 R1 : ABSEXCH-17797 edit batch no
      FBtrIntf^.LMiscRecs.SerialRec.BatchNo := FSerialRec.BatchNo;
      FSerialRec := MiscRecs.SerialRec;
      FSerialRec.BuyQty := NewQty;

      //PL 16/11/2016 : 2017 R1 :	ABSEXCH-17797 edit batch no
       if  (FSerialRec.QtyUsed > 0) and
           (FSerialRec.BatchRec) and
           (not (FBtrIntf^.LMiscRecs.SerialRec.BatchNo = FSerialRec.BatchNo)) then
          Result := 30022
       else
          FSerialRec.BatchNo := FBtrIntf^.LMiscRecs.SerialRec.BatchNo;
    end;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Build Toolkit Serial/Batch Record
    CopyExSerialToTkSerial (FSerialRec, TkSerial);

   //PR: 25/11/2011 Are we updating a batch with a new transaction or line?
   if (Trim(FSerialRec.BatchNo) <> '') and (FIntfType = imUpdate) and
      (
       (Trim(NewOurRef) <> Trim(FSerialRec.InDoc)) or (NewLineNo <> FSerialRec.BuyLine)
      ) then
   begin
     TKSerial.LatestInDoc := NewOurRef;
     TKSerial.LatestBuyLine := NewLineNo;
   end;

    // Add/Update Serial/Batch Record
    Result := Ex_StoreSerialBatch (@TkSerial, SizeOf(TkSerial), BtrOp);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

{------------------------------}

Procedure TSerialBatch.LoadDetails (Const SerDets : SerialType; Const LockPos : LongInt);
begin
  FSerialRec := SerDets;

  LockCount := 1;
  LockPosition := LockPos;
end;

// HM 12/03/01: Removed from interface as Editing not supported by Ex_StoreSerialBatch
function TSerialBatch.Update: ISerialBatch;
Var
  FUpdateO : TSerialBatch;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

  // Can't edit Sold Serial/Batch Numbers
//  If (Not FSerialRec.Sold) Then Begin
  If (Not FSerialRec.BatchChild) Then Begin
    // Lock Current Record
    FuncRes := Lock;

    If (FuncRes = 0) Then Begin
      // Create an update object
      FUpdateO := TSerialBatch.Create(imUpdate, FToolkit, FBtrIntf, False, True);

      // Pass current Serial/Batch Record and Locking Details into sub-object
      FUpdateO.LoadDetails(FSerialRec, LockPosition);
      LockCount := 0;
      LockPosition := 0;

      Result := FUpdateO;
    End; { If (FuncRes = 0) }
  End { If (Not FSerialRec.Sold) }
  Else
    // Cannot edit Sold items
//    Raise EInvalidMethod.Create ('Serial/Batch Numbers that have already been sold cannot be edited');
    Raise EInvalidMethod.Create ('It is not possible to edit batch usage lines.');
end;

{------------------------------}

function TSerialBatch.BuildUsedSerialIndex(Sold: WordBool; const SerialNo: WideString): WideString;
begin
  If Sold Then
    Result := #1 + LJVar(UpperCase(SerialNo), SNoKeyLen)
  Else
    Result := #0 + LJVar(UpperCase(SerialNo), SNoKeyLen);
end;

{------------------------------}

function TSerialBatch.BuildSerialIndex(const SerialNo: WideString): WideString;
begin
  Result := LJVar(UpperCase(SerialNo), SNoKeyLen);
end;

{------------------------------}

function TSerialBatch.BuildBatchIndex(const BatchNo: WideString): WideString;
begin
  Result := LJVar(UpperCase(BatchNo), BNoKeyLen);
end;

function TSerialBatch.Get_snBinCode: WideString;
begin
  Result := FSerialRec.InBinCode;
end;

procedure TSerialBatch.Set_snBinCode(const Value: WideString);
begin
  FSerialRec.InBinCode := Value;
end;


{------------------------------}

//IBrowseInfo
function TSerialBatch.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

function TSerialBatch.Get_snBatchReturnedQty: Double;
begin
  Result := FSerialRec.BatchRetQty;
end;

function TSerialBatch.Get_snReturned: WordBool;
begin
  Result := FSerialRec.ReturnSNo;
end;

function TSerialBatch.Get_snReturnLineNo: Integer;
begin
  Result := FSerialRec.RetDocLine;
end;

function TSerialBatch.Get_snReturnOurRef: WideString;
begin
  Result := FSerialRec.RetDoc;
end;

procedure TSerialBatch.Set_snBatchReturnedQty(Value: Double);
begin
  FSerialRec.BatchRetQty := Value;
end;

procedure TSerialBatch.Set_snReturned(Value: WordBool);
begin
  FSerialRec.ReturnSNo := Value;
end;

procedure TSerialBatch.Set_snReturnLineNo(Value: Integer);
begin
  FSerialRec.RetDocLine := Value;
end;

procedure TSerialBatch.Set_snReturnOurRef(const Value: WideString);
begin
  FSerialRec.RetDoc := Value;
end;

function TSerialBatch.GetRedirectedDataRec(const BtrOp: SmallInt;
  const SearchKey: string): Integer;
var
  DataRec : TSerialBatchRec;
  sKey : Str255;
begin
  sKey := SetKeyString(BtrOp, FullNomKey(FStkFolio) + SearchKey);
  Result := FSQLRedirect.GetData(BtrOp, FIndex, sKey, @DataRec, SizeOf(DataRec));

  if Result = 0 then
  begin
    FBtrIntf^.LMiscRecs^.RecMfix := MFIFOCode;
    FBtrIntf^.LMiscRecs^.SubType := MSernSub;
    FBtrIntf^.LMiscRecs^.SerialRec.SerialCode := MakeSNKey(DataRec.StockFolio,
                                                DataRec.Sold, DataRec.SerialNo);
    Move(DataRec.SerialNo, FBtrIntf^.LMiscRecs^.SerialRec.SerialNo, SizeOf(DataRec) - (BtKeyPos(@DataRec.SerialNo, @DataRec) - 1));

    CopyDataRecord;

    FKeyString := sKey;
  end;
end;

function TSerialBatch.LoadTheCache: Integer;
var
  DefaultWhere : string;
begin
  Result := 0;
  if not UsingRedirectCache then
  begin
    FSQLRedirect := TSQLRedirect.Create;
    FSQLRedirect.FileNo := F_SERIALBATCH;
    FSQLRedirect.WhereClause := FullQuery;;
    FSQLRedirect.FieldList := FColumns;
    FSQLRedirect.ClientID := FBtrIntf^.ExClientID;
    Result := FSQLRedirect.Open;
  end;
end;

function TSerialBatch.ConvertData(const DataRec: WideString): WideString;
begin
  //Implementation not required
end;

function TSerialBatch.GetData: WideString;
var
  TKSerialRec : TBatchSerialRec;
begin
  CopyExSerialToTkSerial(FSerialRec, TKSerialRec);
  SetLength(Result, SizeOf(TKSerialRec));
  Move(TKSerialRec, Result[1], SizeOf(TKSerialRec));
end;

end.
