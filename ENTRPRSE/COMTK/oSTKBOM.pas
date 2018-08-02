unit oStkBom;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, GlobList;

type
  TStockBOMMode = (bomWhereUsed, bomComponent);

  TStockBOM = class(TBtrieveFunctions, IStockWhereUsed, IStockBOMComponent)
  private
    FIdxStr      : ShortString;  // Index String to find correct QtyBrk records

    FBillRec     : BillMatType;  // Local Bill of Materials record

    FKillBtr     : Boolean;

    FBOMMode     : TStockBOMMode;
    FIntfType    : TInterfaceMode;
    FToolkit     : TObject;
  protected
    // IStockBOMWhere
    function  Get_bmStockCode: WideString; safecall;
    function  Get_bmStockCodeI: IStock; safecall;
    function  Get_bmQuantityUsed: Double; safecall;
    function  Get_bmUnitCost: Double; safecall;
    function  Get_bmUnitCostCurrency: SmallInt; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;
    Procedure CopyDataRecord; Override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; Override;

    // Local Methods
    function GetStockCode: WideString;
    Procedure InitObjects;
  public
    Constructor Create (Const BOMMode  : TStockBOMMode;
                        Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr;
                        Const KillBtr  : Boolean);

    Destructor Destroy; override;

    Procedure SetStartKey (Const IndexStr : ShortString);

    Procedure RecalcCost (Const ParentCostCcy : SmallInt);
    Procedure SetBillRec (Const BillRec : BillMatType);
    Procedure UpdateBillRec(Const StockCode     : ShortString;
                            Const QuantityUsed  : Double;
                            Const ParentCostCcy : SmallInt);
  End; { TStockBOM }



Function CreateTStockBOM (Const BOMMode  : TStockBOMMode;
                          Const ClientId : Integer;
                          Const Toolkit  : TObject) : TStockBOM;

implementation

uses ComServ, oToolkit, DllErrU, BtsupU1, BtKeys1U, EtStrU, ETMiscU, BTS1,
     CurrncyU;

{-------------------------------------------------------------------------------------------------}

Function CreateTStockBOM (Const BOMMode  : TStockBOMMode;
                          Const ClientId : Integer;
                          Const Toolkit  : TObject) : TStockBOM;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStockBOM }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TQuantityBreak object
  BtrIntf^.Open_System(PwrdF, PwrdF);
  BtrIntf^.Open_System(StockF, StockF);

  // Create basic TQuantityBreak object
  Result := TStockBOM.Create(BOMMode, imGeneral, Toolkit, BtrIntf, True);
End; { CreateTStockBOM }

{-------------------------------------------------------------------------------------------------}

constructor TStockBOM.Create(Const BOMMode : TStockBOMMode;
                             Const IType   : TInterfaceMode;
                             Const Toolkit : TObject;
                             Const BtrIntf : TCtkTdPostExLocalPtr;
                             Const KillBtr : Boolean);
Begin { Create }
  Case BOMMode Of
    bomWhereUsed : Inherited Create (ComServer.TypeLib, IStockWhereUsed, BtrIntf);
    bomComponent : Inherited Create (ComServer.TypeLib, IStockBOMComponent, BtrIntf);
  Else
    Raise Exception.Create ('TStockBOM.Create: Invalid BOM Mode');
  End; { Case }

  // Initialise Btrieve Ancestor
  FFileNo := PwrdF;
  FKillBtr := KillBtr;

  // Initialise variables
  FIdxStr := '';
  InitObjects;

  // Setup Links
  FBOMMode := BOMMode;
  FIntfType := IType;
  FToolkit := Toolkit;

  // Index 1 - Used to find parent stock items for a specified components
  FIndex := 1;
End; { Create }

{------------------------------}

destructor TStockBOM.Destroy;
begin
  { Destroy sub-ojects }
  InitObjects;

  If Assigned (FBtrIntf) And (FIntfType = imGeneral) And FKillBtr Then
    Dispose (FBtrIntf, Destroy);

  inherited;
end;

{------------------------------}

procedure TStockBOM.InitObjects;
begin
  FToolkit := NIL;
end;

{------------------------------}

procedure TStockBOM.SetStartKey(const IndexStr: ShortString);
begin
  If (FIdxStr <> IndexStr) Then Begin
    // Take copy of new Index String
    FIdxStr := IndexStr;

    // Reset current BOM record
    FillChar (FBillRec, SizeOf(FBillRec), #0);

    // Automatically load first record
    GetFirst;
  End; { If (IndexStr <> FIdxStr) }
end;

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TStockBOM.AuthoriseFunction (Const FuncNo     : Byte;
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

Procedure TStockBOM.CopyDataRecord;
Begin { CopyDataRecord }
  FBillRec := FBtrIntf^.LPassword.BillMatRec;
End; { CopyDataRecord }

{-----------------------------------------}

Function TStockBOM.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode, BtrOpCode2 : SmallInt;
  KeyS, KeyChk          : Str255;
  Loop                  : Boolean;
Begin { GetDataRecord }
  Result := 0;
  LastErDesc := '';
  BtrOpCode2 := 0;
  With FBtrIntf^ Do Begin
    // General shared index including Discounts, FIFO, Serial No's, Window Positions, etc... records

    BtrOpCode := BtrOp;
    KeyS := SetKeyString(BtrOp, BillMatTCode + BillMatSCode + FIdxStr + SearchKey);

    {PR 28/04/06. The key length is 11 but the record length is 10, so we get the first byte of qty used in the
     key. However, if the stock folio ends in zeros and the qty used is 0, then KeyS loses all zeros at the end, so
     doesn't match KeyChk. To fix this we'll strip all zeros from the end of KeyChk, so it should still match.}
    KeyChk := Strip('R', [#0], KeyS);

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

      //PR 21/5/2007 - Add extra check that record is for the correct stock item
      If (Result = 0) And (Not CheckKey(KeyS, KeyChk, Length(KeyChk), True) or
                           (Copy(LPassword.BillMatRec.BillLink, 1, 4) <> FIdxStr) ) Then
        // Not a valid Qty Break record - abandon operation
        Result := 9;
    Until (Result <> 0) Or (Not Loop) Or CheckKey(KeyS, KeyChk, Length(KeyChk), True);

    FKeyString := KeyS;
    {PR Due to invalid index 1 on this file we need to ignore the last character of the keystring}
    if (FIndex = 1) then
      Delete(FKeyString, Length(FKeyString), 1);

    If (Result = 0) Then Begin
      // check correct record type was returned
      If (LPassword.RecPFix = BillMatTCode) And (LPassword.SubType = BillMatSCode) Then
        // Take local Copy
        CopyDataRecord
      Else
        Result := 4;
    End; { If (Result = 0) }
  End; { With FBtrIntf^ }

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (46, Result);
End; { GetDataRecord }

{------------------------------}

function TStockBOM.GetStockCode: WideString;
Var
  KeyS    : Str255;
  LStatus : SmallInt;
  FolNo   : LongInt;
begin
  If (FBOMMode = bomComponent) Then
    // Sub-Components actually have the sub-component stock code in the record
    Result := FBillRec.FullStkCode
  Else
    With FBtrIntf^ Do Begin
      // Check we haven't already got the correct stock record loaded
      Move (FBillRec.StockLink[1], FolNo, 4);
      If (LStock.StockFolio <> FolNo) Then Begin
        // Where Used List - need to lookup stock code from Stock Folio in StockLink
        KeyS := FullNomKey(FolNo);
        LStatus := LFind_Rec (B_GetEq, StockF, StkFolioK, KeyS);
        If (LStatus = 0) Then
       {   Result := LStock.StockCode} //Moved to outside the if statement as no result was being returned if false
        Else
          Raise EUnknownValue.Create ('Unable to determine Parent Stock Code');
      End; { If (LStock.StockFolio <> FolNo) }
      Result := LStock.StockCode;
    End; { With FBtrIntf^ }
End;

{------------------------------}

function TStockBOM.Get_bmStockCode: WideString;
begin
  Result := GetStockCode;
end;

{------------------------------}

function TStockBOM.Get_bmStockCodeI: IStock;
begin
  Result := (FToolkit as TToolkit).StockO.GetCloneInterface(GetStockCode);
end;

{------------------------------}

function TStockBOM.Get_bmQuantityUsed: Double;
begin
  Result := FBillRec.QtyUsed;
end;

{------------------------------}

function TStockBOM.Get_bmUnitCost: Double;
begin
  Result := FBillRec.QtyCost;
end;

{------------------------------}

function TStockBOM.Get_bmUnitCostCurrency: SmallInt;
begin
  Result := FBillRec.QCurrency;
end;

{------------------------------}

Procedure TStockBOM.SetBillRec (Const BillRec : BillMatType);
Begin
  FBillRec := BillRec;
End;

{------------------------------}

Procedure TStockBOM.UpdateBillRec(Const StockCode : ShortString; Const QuantityUsed : Double; Const ParentCostCcy : SmallInt);
Begin
  With FBillRec Do Begin
    FullStkCode := StockCode;
    QtyUsed     := QuantityUsed;
  End; { With FBillRec }

  RecalcCost (ParentCostCcy);
End;

{------------------------------}

// Recalculate the cost from the component stock record
Procedure TStockBOM.RecalcCost (Const ParentCostCcy : SmallInt);
Var
  KeyS     : Str255;
  SaveInfo : TBtrieveFileSavePos;
  lStatus  : SmallInt;
Begin
  With FBtrIntF^ Do Begin
    // Save Position in Stock Record
    SaveExLocalPosFile (StockF, SaveInfo);

    // Get Sub-Component Stock Record
    KeyS := FullStockCode(FBillRec.FullStkCode);
    LStatus := LFind_Rec (B_GetEq, StockF, StkCodeK, KeyS);
    If (LStatus = 0) Then
      With FBillRec Do Begin
        // Recalulate cost
        QCurrency := ParentCostCcy;

        QtyCost := Round_Up(Calc_StkCP(Currency_ConvFT(LStock.CostPrice,   // sub-component unit cost
                                                       LStock.PCurrency,   // sub-component cost currency
                                                       ParentCostCcy,      // BOM Currency
                                                       UseCoDayRate),
                                       LStock.BuyUnit, LStock.CalcPack), Syss.NoCosDec);
      End { With FBillRec }
    Else
      Raise Exception.Create ('Unable to load Stock Code ' + QuotedStr(FBillRec.FullStkCode));

    // Restore starting position
    RestoreExLocalPos (SaveInfo);
  End; { With FBtrIntF^ }
End;

{------------------------------}

end.
