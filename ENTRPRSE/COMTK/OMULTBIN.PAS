unit oMultBin;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     VarCnst3, oBtrieve, oAddr,
     MiscFunc, BtrvU2, oStock2, oStkLoc, oNotes, ExBtTH1U, oQtyBrk,
     oStkBOM, oStkBOML, oSerial, GlobList, oLinks, oAltStk;

type
  TMultiBin = class(TBtrieveFunctions, IMultiBinDetails, IMultiBin, IMultiBinDetails2, IMultiBin2, IBrowseInfo,
                    IToolkitRecord)
  protected
    FIntfType    : TInterfaceMode;
    FBinRec      : TBatchBinRec;
    FStockCode   : String;
    FKillBtr     : Boolean;
    FToolkit     : TObject;

    function Get_mbCode: WideString; safecall;
    procedure Set_mbCode(const Value: WideString); safecall;
    function Get_mbInDocRef: WideString; safecall;
    procedure Set_mbInDocRef(const Value: WideString); safecall;
    function Get_mbOutDocRef: WideString; safecall;
    procedure Set_mbOutDocRef(const Value: WideString); safecall;
    function Get_mbSold: WordBool; safecall;
    procedure Set_mbSold(Value: WordBool); safecall;
    function Get_mbInDate: WideString; safecall;
    procedure Set_mbInDate(const Value: WideString); safecall;
    function Get_mbOutDate: WideString; safecall;
    procedure Set_mbOutDate(const Value: WideString); safecall;
    function Get_mbCostPrice: Double; safecall;
    procedure Set_mbCostPrice(Value: Double); safecall;
    function Get_mbCapacity: Double; safecall;
    procedure Set_mbCapacity(Value: Double); safecall;
    function Get_mbInDocLine: Integer; safecall;
    procedure Set_mbInDocLine(Value: Integer); safecall;
    function Get_mbOutDocLine: Integer; safecall;
    procedure Set_mbOutDocLine(Value: Integer); safecall;
    function Get_mbQty: Double; safecall;
    procedure Set_mbQty(Value: Double); safecall;
    function Get_mbQtyUsed: Double; safecall;
    procedure Set_mbQtyUsed(Value: Double); safecall;
    function Get_mbUsed: WordBool; safecall;
    procedure Set_mbUsed(Value: WordBool); safecall;
    function Get_mbInLocation: WideString; safecall;
    procedure Set_mbInLocation(const Value: WideString); safecall;
    function Get_mbOutLocation: WideString; safecall;
    procedure Set_mbOutLocation(const Value: WideString); safecall;
    function Get_mbInOrderRef: WideString; safecall;
    procedure Set_mbInOrderRef(const Value: WideString); safecall;
    function Get_mbOutOrderRef: WideString; safecall;
    procedure Set_mbOutOrderRef(const Value: WideString); safecall;
    function Get_mbInOrderLine: Integer; safecall;
    procedure Set_mbInOrderLine(Value: Integer); safecall;
    function Get_mbOutOrderLine: Integer; safecall;
    procedure Set_mbOutOrderLine(Value: Integer); safecall;
    function Get_mbCostPriceCurrency: Integer; safecall;
    procedure Set_mbCostPriceCurrency(Value: Integer); safecall;
    function Get_mbSalesPriceCurrency: Integer; safecall;
    procedure Set_mbSalesPriceCurrency(Value: Integer); safecall;
    function Get_mbSalesPrice: Double; safecall;
    procedure Set_mbSalesPrice(Value: Double); safecall;
    function Get_mbCompanyRate: Double; safecall;
    procedure Set_mbCompanyRate(Value: Double); safecall;
    function Get_mbDailyRate: Double; safecall;
    procedure Set_mbDailyRate(Value: Double); safecall;
    function Get_mbUseOwnRates: WordBool; safecall;
    procedure Set_mbUseOwnRates(Value: WordBool); safecall;
    function Get_mbUnitOfMeasurement: WideString; safecall;
    procedure Set_mbUnitOfMeasurement(const Value: WideString); safecall;
    function Get_mbTagNo: Integer; safecall;
    procedure Set_mbTagNo(Value: Integer); safecall;
    function Get_mbAutoPickMode: TAutoPickModeType; safecall;
    procedure Set_mbAutoPickMode(Value: TAutoPickModeType); safecall;
    function Get_mbPickingPriority: WideString; safecall;
    procedure Set_mbPickingPriority(const Value: WideString); safecall;
    function Get_mbUseByDate: WideString; safecall;
    procedure Set_mbUseByDate(const Value: WideString); safecall;

    //25/7/05 IMultiBin2 added for 5.70
    function Get_mbReturned: WordBool; safecall;
    procedure Set_mbReturned(Value: WordBool); safecall;


        //IBrowseInfo
    function Get_ibInterfaceMode: Integer; safecall;

    //PR: 11/04/2014 ABSEXCH-14755 Add IToolkitRecord functions to allow AddToBin to get record
    function GetData: WideString; safecall;
    function ConvertData(const DataRec: WideString): WideString; safecall;


    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;
    function BuildFullIndex(Sold: WordBool; const Location: WideString; const Priority: WideString;
                        const DateIn: WideString; const Code: WideString): WideString; safecall;
    function Add: IMultiBin; safecall;
    function Update: IMultiBin; safecall;
    function Clone: IMultiBin; safecall;
    function Save: Integer; safecall;

  public
    Constructor Create(Const IType     : TInterfaceMode;
                       Const Toolkit   : TObject;
                       Const BtrIntf   : TCtkTdPostExLocalPtr;
                       Const KillBtr   : Boolean;
                       Const IsMainObj : Boolean);
    Procedure SetStockKeys (Const StkCode : ShortString; Const StkFolio : LongInt);
    procedure LoadDetails(const BRec : TBatchBinRec; const LockPos : longint);
    procedure CloneDetails(const BRec : TBatchBinRec);
    Procedure InitFromTrans (Const TH       : TBatchTHRec;
                             Const TL       : TBatchTLRec;
                             Const StkFolio : LongInt);
    function GetBinRec : TBatchBinRec;
  end;

  Function CreateTMultiBin (Const ClientId : Integer;
                            Const Toolkit  : TObject) : TMultiBin;



implementation

uses
  DllBin, DllErrU, BtKeys1U, ComServ, VarRec2U, BtSupU1, oToolkit, CurrncyU;

Function CreateTMultiBin (Const ClientId : Integer;
                          Const Toolkit  : TObject) : TMultiBin;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStockBOM }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  BtrIntf^.Open_System(MLocF, MLocF);

  // Create basic TMultiBin object
  Result := TMultiBin.Create(imGeneral, Toolkit, BtrIntf, True, True);

  if SQLBeingUsed then
    Result.SetFileNos([MLocF]);

End; { CreateTStockBOM }



Constructor TMultiBin.Create(Const IType     : TInterfaceMode;
                             Const Toolkit   : TObject;
                             Const BtrIntf   : TCtkTdPostExLocalPtr;
                             Const KillBtr   : Boolean;
                             Const IsMainObj : Boolean);
begin
  If IsMainObj Then
    Inherited Create (ComServer.TypeLib, IMultiBin2, BtrIntf)
  Else
    Inherited Create (ComServer.TypeLib, IMultiBinDetails2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MLocF;
  FKillBtr := KillBtr;

  FillChar(FBinRec, SizeOf(FBinRec), 0);

  FIntfType := IType;
  FToolkit := Toolkit;

  if IType = imAdd then
  begin
    FBinRec.brSold := False;
    FBinRec.brUsedRec := False;
    FBinRec.brCompanyRate := 1;
    FBinRec.brDailyRate := 1;
    if (FToolkit as TToolkit).SystemSetupI.ssCurrencyVersion <> enProfessional then
    begin
      FBinRec.brSalesPriceCurrency := 1;
      FBinRec.brCostPriceCurrency := 1;
    end;
  end;

  FBinRec.brStockFolio := -19191919;


  FIndex := 1;

end;

function TMultiBin.Get_mbCode: WideString;
begin
  Result := FBinRec.brBinCode;
end;

procedure TMultiBin.Set_mbCode(const Value: WideString);
begin
  FBinRec.brBinCode := Value;
end;

function TMultiBin.Get_mbInDocRef: WideString;
begin
  Result := FBinRec.brInDocRef;
end;

procedure TMultiBin.Set_mbInDocRef(const Value: WideString);
begin
  FBinRec.brInDocRef := Value;
end;

function TMultiBin.Get_mbOutDocRef: WideString;
begin
  Result := FBinRec.brOutDocRef;
end;

procedure TMultiBin.Set_mbOutDocRef(const Value: WideString);
begin
  FBinRec.brOutDocRef := Value;
end;

function TMultiBin.Get_mbSold: WordBool;
begin
  Result := FBinRec.brSold;
end;

procedure TMultiBin.Set_mbSold(Value: WordBool);
begin
  FBinRec.brSold := Value;
end;

function TMultiBin.Get_mbInDate: WideString;
begin
  Result := FBinRec.brInDate;
end;

procedure TMultiBin.Set_mbInDate(const Value: WideString);
begin
  FBinRec.brInDate := Value;
end;

function TMultiBin.Get_mbOutDate: WideString;
begin
  Result := FBinRec.brOutDate;
end;

procedure TMultiBin.Set_mbOutDate(const Value: WideString);
begin
  FBinRec.brOutDate := Value;
end;

function TMultiBin.Get_mbCostPrice: Double;
begin
  Result := FBinRec.brCostPrice;
end;

procedure TMultiBin.Set_mbCostPrice(Value: Double);
begin
  FBinRec.brCostPrice := Value;
end;

function TMultiBin.Get_mbCapacity: Double;
begin
  Result := FBinRec.brCapacity;
end;

procedure TMultiBin.Set_mbCapacity(Value: Double);
begin
  FBinRec.brCapacity := Value;
end;

function TMultiBin.Get_mbInDocLine: Integer;
begin
  Result := FBinRec.brInDocLine;
end;

procedure TMultiBin.Set_mbInDocLine(Value: Integer);
begin
  FBinRec.brInDocLine := Value;
end;

function TMultiBin.Get_mbOutDocLine: Integer;
begin
  Result := FBinRec.brOutDocLine;
end;

procedure TMultiBin.Set_mbOutDocLine(Value: Integer);
begin
  FBinRec.brOutDocLine := Value;
end;

function TMultiBin.Get_mbQty: Double;
begin
  Result := FBinRec.brQty;
end;

procedure TMultiBin.Set_mbQty(Value: Double);
begin
  FBinRec.brQty := Value;
end;

function TMultiBin.Get_mbQtyUsed: Double;
begin
  Result := FBinRec.brQtyUsed;
end;

procedure TMultiBin.Set_mbQtyUsed(Value: Double);
begin
  FBinRec.brQtyUsed := Value;
end;

function TMultiBin.Get_mbUsed: WordBool;
begin
  Result := FBinRec.brUsedRec;
end;

procedure TMultiBin.Set_mbUsed(Value: WordBool);
begin
  FBinRec.brUsedRec := Value;
end;

function TMultiBin.Get_mbInLocation: WideString;
begin
  Result := FBinRec.brInLocation;
end;

procedure TMultiBin.Set_mbInLocation(const Value: WideString);
begin
  FBinRec.brInLocation := Value;
end;

function TMultiBin.Get_mbOutLocation: WideString;
begin
  Result := FBinRec.brOutLocation;
end;

procedure TMultiBin.Set_mbOutLocation(const Value: WideString);
begin
  FBinRec.brOutLocation := Value;
end;

function TMultiBin.Get_mbInOrderRef: WideString;
begin
  Result := FBinRec.brInOrderRef;
end;

procedure TMultiBin.Set_mbInOrderRef(const Value: WideString);
begin
  FBinRec.brInOrderRef := Value;
end;

function TMultiBin.Get_mbOutOrderRef: WideString;
begin
  Result := FBinRec.brOutOrderRef;
end;

procedure TMultiBin.Set_mbOutOrderRef(const Value: WideString);
begin
  FBinRec.brOutOrderRef := Value;
end;

function TMultiBin.Get_mbInOrderLine: Integer;
begin
  Result := FBinRec.brInOrderLine;
end;

procedure TMultiBin.Set_mbInOrderLine(Value: Integer);
begin
  FBinRec.brInOrderLine := Value;
end;

function TMultiBin.Get_mbOutOrderLine: Integer;
begin
  Result := FBinRec.brOutOrderLine;
end;

procedure TMultiBin.Set_mbOutOrderLine(Value: Integer);
begin
  FBinRec.brOutOrderLine := Value;
end;

function TMultiBin.Get_mbCostPriceCurrency: Integer;
begin
  Result := FBinRec.brCostPriceCurrency;
end;

procedure TMultiBin.Set_mbCostPriceCurrency(Value: Integer);
begin
  FBinRec.brCostPriceCurrency := Value;
end;

function TMultiBin.Get_mbSalesPriceCurrency: Integer;
begin
  Result := FBinRec.brSalesPriceCurrency;
end;

procedure TMultiBin.Set_mbSalesPriceCurrency(Value: Integer);
begin
  FBinRec.brSalesPriceCurrency := Value;
end;

function TMultiBin.Get_mbSalesPrice: Double;
begin
  Result := FBinRec.brSalesPrice;
end;

procedure TMultiBin.Set_mbSalesPrice(Value: Double);
begin
  FBinRec.brSalesPrice := Value;
end;

function TMultiBin.Get_mbCompanyRate: Double;
begin
  Result := FBinRec.brCompanyRate;
end;

procedure TMultiBin.Set_mbCompanyRate(Value: Double);
begin
  FBinRec.brCompanyRate := Value;
end;

function TMultiBin.Get_mbDailyRate: Double;
begin
  Result := FBinRec.brDailyRate;
end;

procedure TMultiBin.Set_mbDailyRate(Value: Double);
begin
  FBinRec.brDailyRate := Value;
end;

function TMultiBin.Get_mbUseOwnRates: WordBool;
begin
  Result := FBinRec.brUseORate;
end;

procedure TMultiBin.Set_mbUseOwnRates(Value: WordBool);
begin
  FBinRec.brUseORate := Value;
end;

function TMultiBin.Get_mbUnitOfMeasurement: WideString;
begin
  Result := FBinRec.brUnitOfMeasurement;
end;

procedure TMultiBin.Set_mbUnitOfMeasurement(const Value: WideString);
begin
  FBinRec.brUnitOfMeasurement := Value;
end;

function TMultiBin.Get_mbTagNo: Integer;
begin
  Result := FBinRec.brTagNo;
end;

procedure TMultiBin.Set_mbTagNo(Value: Integer);
begin
  if (Value >= 0) and (Value <= 99) then
    FBinRec.brTagNo := Value
  else
    raise EValidation.Create('Invalid TagNo. Must be between 0 and 99');
end;

function TMultiBin.Get_mbAutoPickMode: TAutoPickModeType;
begin
  Result := TAutoPickModeType(FBinRec.brAutoPickMode);
end;

procedure TMultiBin.Set_mbAutoPickMode(Value: TAutoPickModeType);
begin
  if Value in [0..3] then
    FBinRec.brAutoPickMode := Value
  else
    Raise EUnknownValue.Create ('Invalid Auto Pick Mode (' + IntToStr(Ord(Value)) + ')');
end;

function TMultiBin.Get_mbPickingPriority: WideString;
begin
  Result := FBinRec.brPickingPriority;
end;

procedure TMultiBin.Set_mbPickingPriority(const Value: WideString);
begin
  FBinRec.brPickingPriority := Value;
end;

function TMultiBin.Get_ibInterfaceMode: Integer;
begin
  Result := Ord(FIntfType);
end;

Function TMultiBin.AuthoriseFunction (Const FuncNo     : Byte;
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

Procedure TMultiBin.CopyDataRecord;
begin
  DoCopyEntBinToTkBin(FBtrIntf^.LMlocCtrl.brBinRec, FBinRec);
end;

Function TMultiBin.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;

  //----------------------------

  Function GotRecord : Boolean;
  Begin { GotRecord }
    With FBtrIntf^.LMLocCtrl^ Do Begin
      // Always check RecMFix and SubType
      Result := (RecPFix = BRRecCode) And (SubType = MSernSub);

      If Result And (FIndex = 0) Then Begin
        // Serial Number record - Always check stock folio number
        Result := (brBinRec.brStkFolio = FBinRec.brStockFolio);
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

  With FBtrIntf^ Do Begin
    // General shared index including Discounts, FIFO, Serial No's, Window Positions, etc... records

    KeyChk := BRRecCode + MSernSub;
    if SearchKey = '' then
      KeyChk := KeyChk + FullNomKey(FBinRec.brStockFolio);

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

        If (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True)) Then
          // Invalid Record - return End of File
          Result := 9;
      End; { If (Result = 0) }
    Until (Result <> 0) Or (Not Loop) Or ((Result = 0) And (LMLocCtrl^.brBinRec.brStkFolio = FBinRec.brStockFolio));

    FKeyString := KeyS;

    If (Result = 0) And ((Result = 0) And (LMLocCtrl^.brBinRec.brStkFolio = FBinRec.brStockFolio)) Then Begin
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
    LastErDesc := Ex_ErrorDescription (172, Result);
End; { GetDataRecord }

function TMultiBin.Add: IMultiBin;
var
  BinO : TMultiBin;
begin
  AuthoriseFunction(100, 'Add');

  BinO := TMultiBin.Create(imAdd, FToolkit, FBtrIntf, False, True);
  BinO.SetStockKeys(FStockCode, FBinRec.brStockFolio);

  Result := BinO;
end;

function TMultiBin.Update: IMultiBin;
Var
  FUpdateO : TMultiBin;
  FuncRes  : LongInt;
begin { Update }
  Result := Nil;
  AuthoriseFunction(101, 'Update');

//PR 1/6/05 This was checking sold - should be checking UsedRec
//  If (Not FBinRec.brSold) Then Begin
  if not FBinRec.brUsedRec then
  begin
    // Lock Current Record
    FuncRes := Lock;

    If (FuncRes = 0) Then Begin
      // Create an update object
      FUpdateO := TMultiBin.Create(imUpdate, FToolkit, FBtrIntf, False, True);

      // Pass current Serial/Batch Record and Locking Details into sub-object
      FUpdateO.LoadDetails(FBinRec, LockPosition);
      FUpdateO.SetStockKeys(FStockCode, FBinRec.brStockFolio);
      LockCount := 0;
      LockPosition := 0;

      Result := FUpdateO;
    End; { If (FuncRes = 0) }
  End { If (Not FSerialRec.brUsedRec) }
  Else
    // Cannot edit Sold items
    Raise EInvalidMethod.Create ('It is not possible to edit a bin usage line');
end;

function TMultiBin.Clone: IMultiBin;
Var
  FCloneO : TMultiBin;
begin
  // Check Clone method is available
  AuthoriseFunction(104, 'Clone');

  // Create new Stock object and initialise
  FCloneO := TMultiBin.Create(imClone, FToolkit, FBtrIntf, False, True);
  FCloneO.CloneDetails(FBinRec);
  FCloneO.SetStockKeys(FStockCode, FBinRec.brStockFolio);
  Result := FCloneO;
end;

function TMultiBin.Save: Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  BtrOp    : SmallInt;
begin
  AuthoriseFunction(102, 'Save');

  // Save current file positions in main files
  SaveInfo := SaveSystemFilePos ([]);

  If (FIntfType = imUpdate) Then Begin
    // Updating - Reposition on original Locked Stock item
    Result := PositionOnLock;
    BtrOp := B_Update;
  End { If (FIntfType = imUpdate) }
  Else Begin
    // Adding - no need to do anything
    Result := 0;
    BtrOp := B_Insert;
  End; { Else }

  If (Result = 0) Then Begin
    // Build Toolkit Serial/Batch Record
    Result := Ex_StoreMultiBin (@FBinRec, SizeOf(FBinRec), 1, BtrOp);

    //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
    if Result = 0 then
      FIntfType := imClone;
  End; { If (Res = 0) }

  // Restore original file positions
  RestoreSystemFilePos (SaveInfo);
end;

function TMultiBin.BuildFullIndex(Sold: WordBool; const Location: WideString; const Priority: WideString;
                    const DateIn: WideString; const Code: WideString): WideString;
begin
 Result := FullBinCode2(FBinRec.brStockFolio, WordBoolToBool(Sold),
                           Location, Priority,  DateIn, Code);
end;

Procedure TMultiBin.SetStockKeys (Const StkCode : ShortString; Const StkFolio : LongInt);
begin
  FStockCode := StkCode;
  FBinRec.brStockFolio := StkFolio;
end;

procedure TMultiBin.LoadDetails(const BRec : TBatchBinRec; const LockPos : longint);
begin
  FBinRec := BRec;
  LockCount := 1;
  LockPosition := LockPos;
end;

procedure TMultiBin.CloneDetails(const BRec : TBatchBinRec);
begin
  FBinRec := BRec;
end;

function TMultiBin.Get_mbUseByDate: WideString;
begin
  Result := FBinRec.brUseByDate;
end;

procedure TMultiBin.Set_mbUseByDate(const Value: WideString);
begin
  FBinRec.brUseByDate := Value;
end;

Procedure TMultiBin.InitFromTrans (Const TH       : TBatchTHRec;
                                   Const TL       : TBatchTLRec;
                                   Const StkFolio : LongInt);
var
  TriRec : TriCurType;
  TmpByte : Byte;
Begin { InitNew }
  FStockCode  := FullStockCode(TL.StockCode);
//  FStkFolio := StkFolio;

  FillChar (FBinRec, SizeOf(FBinRec), #0);
  With FBinRec Do Begin
    brStockFolio := StkFolio;

    brInDocRef := TH.OurRef;
    brInDocLine := TL.AbsLineNo;

    brInDate := TH.TransDate;

    brCostPriceCurrency := TH.Currency;
    brCostPrice := TL.NetValue;

    brQty := TL.Qty;

    brInLocation := TL.MLocStk;

    //PR: 30/11/2011 If we have a job code on the line then stock is automatically booked out,
    //so set fields accordingly.
    if (Not ExSyss.JBIgnore) and (Trim(TL.JobCode) <> '') then
    begin
      brOutDocRef := brInDocRef;
      brOutDocLine := brInDocLine;
      brOutLocation := brInLocation;

      brOutDate := brInDate;
      brSalesPriceCurrency := TH.Currency;
      brSold    := True;
      brSalesPrice := brCostPrice;

      brQtyUsed := brQty;

    end;


    // Default currency exchange rates
    brCompanyRate := SyssCurr^.Currencies[brCostPriceCurrency].CRates[False];
    brDailyRate := SyssCurr^.Currencies[brCostPriceCurrency].CRates[True];
    if brUseORate then
      TmpByte := 1
    else
      TmpByte := 0;
    SetTriRec(brCostPriceCurrency, TmpByte, TriRec);

    brTriRates := TriRec.TriRates;
    brTriEuro  := TriRec.TriEuro;
    brTriInvert := TriRec.TriInvert;
    brTriFloat  := TriRec.TriFloat;

  End; { With FSerialRec }
End; { InitNew }

function TMultiBin.GetBinRec : TBatchBinRec;
begin
  Result := FBinRec;
end;


function TMultiBin.Get_mbReturned: WordBool;
begin
  Result := FBinRec.brReturned;
end;

procedure TMultiBin.Set_mbReturned(Value : WordBool);
begin
  FBinRec.brReturned := Value;
end;

function TMultiBin.ConvertData(const DataRec: WideString): WideString;
begin
  //No implementation needed
end;

function TMultiBin.GetData: WideString;
begin
  SetLength(Result, SizeOf(FBinRec));
  Move(FBinRec, Result[1], SizeOf(FBinRec));
end;

end.
