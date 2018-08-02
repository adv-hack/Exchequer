unit oStkBomL;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, GlobList;

type
  //TStockBOMMode = (bomKitList, bomWhereUsed);

  TStockBOMList = class(TBtrieveFunctions, IStockBOMList)
  private
    // Folio number of parent of currently loaded components
    FParentFolio   : LongInt;
    FParentCode    : String[16];
    FParentCostCcy : SmallInt;

    // List of Transaction Lines for current transaction
    FComponents  : TList;
    FCompsChanged: Boolean;   // Changes Made

    FIntfType    : TInterfaceMode;
    FToolkit     : TObject;
  protected
    // IStockBOMList
    function  Get_blComponentCount: Integer; safecall;
    function  Get_blComponent(Index: Integer): IStockBomComponent; safecall;
    procedure AddComponent(const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure EditComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure InsertComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double); safecall;
    procedure DeleteComponent(Index: Integer); safecall;
    procedure SwitchComponents(Index1: Integer; Index2: Integer); safecall;
    procedure CheckComponentCosts; safecall;

    // TBtrieveFunctions
    Function AuthoriseFunction (Const FuncNo     : Byte;
                                Const MethodName : String;
                                Const AccessType : Byte = 0) : Boolean; Override;

    // Local Methods
    Procedure InitObjects;
    Procedure KillComponent(Const Index : Integer);
    Procedure KillComponents;

    Procedure CopyDataRecord; override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; override;
  public
    Constructor Create (Const IType    : TInterfaceMode;
                        Const Toolkit  : TObject;
                        Const BtrIntf  : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Procedure BuildList(Const ParentCode    : ShortString;
                        Const ParentFolio   : LongInt;
                        Const ParentCostCcy : SmallInt;
                              NeedRefresh   : Boolean = False);
    procedure DeleteList(const ParentFolio : Longint);
    procedure SetParentCostCcy(Const ParentCostCcy : SmallInt);
    function  SaveChanges (Const ParentFolio : LongInt) : LongInt;

  End; { TStockBOMList }

Function CreateTStockBOMList (Const ClientId : Integer;
                              Const IType    : TInterfaceMode;
                              Const Toolkit  : TObject) : TStockBOMList;

implementation

uses ComServ, oToolkit, DllSrBOM, DllErrU, BtsupU1, BtKeys1U, EtStrU, oStkBom;

Type
  TComponentType = Record
    CompO : TStockBOM;
    CompI : IStockBOMComponent;
  End;
  pComponentType = ^TComponentType;

{-------------------------------------------------------------------------------------------------}

Function CreateTStockBOMList (Const ClientId : Integer;
                              Const IType    : TInterfaceMode;
                              Const Toolkit  : TObject) : TStockBOMList;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTStockBOM }
  // Create common btrieve interface for objects
  New (BtrIntf, Create(ClientId));

  // Open files needed by TQuantityBreak object
  BtrIntf^.Open_System(PwrdF, PwrdF);
  BtrIntf^.Open_System(StockF, StockF);

  // Create basic TQuantityBreak object
  Result := TStockBOMList.Create(IType, Toolkit, BtrIntf);
End; { CreateTStockBOM }

{-------------------------------------------------------------------------------------------------}

constructor TStockBOMList.Create(Const IType   : TInterfaceMode;
                                 Const Toolkit : TObject;
                                 Const BtrIntf : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, IStockBOMList, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := PwrdF;

  FComponents := TList.Create;
  FCompsChanged := False;

  // Initialise variables
  FParentFolio := -1919191919;
  FParentCode := '';
  InitObjects;

  // Setup Links
  FIntfType := IType;
  FToolkit := Toolkit;

  // Index 0 - Used to load sub-components of a specified stock item
  FIndex := 0
End; { Create }

{------------------------------}

destructor TStockBOMList.Destroy;
begin
  { Remove any loaded lines }
  KillComponents;

  { Destroy sub-ojects }
  FreeAndNIL(FComponents);
  InitObjects;

  If Assigned (FBtrIntf) {And (FIntfType = imGeneral)PR: fix to avoid 87 error on clones} Then
    Dispose (FBtrIntf, Destroy);

  inherited;
end;

{------------------------------}

procedure TStockBOMList.InitObjects;
begin
  FToolkit := NIL;
end;

{-----------------------------------------}

// Removes a specific component from the component list
Procedure TStockBOMList.KillComponent(Const Index : Integer);
Var
  TmpComp : pComponentType;
Begin { KillLines }
  // remove object references
  TmpComp := FComponents.Items[Index];
  TmpComp.CompO := Nil;
  TmpComp.CompI := Nil;
  Dispose(TmpComp);

  // Destroy List Entry
  FComponents.Delete(Index);
End; { KillLines }

{-----------------------------------------}

// Empties the sub-components List
Procedure TStockBOMList.KillComponents;
Begin { KillLines }
  While (FComponents.Count > 0) Do
    KillComponent(0);
End; { KillLines }

{-----------------------------------------}

// Used by TBtrieveFunctions ancestor to authorise exceution of a function
// see original definition of AuthoriseFunction in oBtrieve.Pas for a
// definition of the parameters
Function TStockBOMList.AuthoriseFunction (Const FuncNo     : Byte;
                                          Const MethodName : String;
                                          Const AccessType : Byte = 0) : Boolean;
Begin { AuthoriseFunction }
  Case FuncNo Of
    1..99     : Result := (FIntfType = imGeneral);


    100,  // .AddComponent
    101,  // .EditComponent
    102,  // .InsertComponent
    103,  // .DeleteComponent
    104,  // .SwitchComponents
    105   // .CheckComponentCosts
              : Result := (FIntfType = imUpdate);
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

{------------------------------}

procedure TStockBOMList.BuildList(Const ParentCode    : ShortString;
                                  Const ParentFolio   : LongInt;
                                  Const ParentCostCcy : SmallInt;
                                        NeedRefresh   : Boolean = False);
Var
  oComp       : pComponentType;
  KeyS        : Str255;
  LStatus     : SmallInt;
begin
  // Check to see if Stock changed
  If (FParentFolio <> ParentFolio) or NeedRefresh Then Begin
    // Cache stock details
    FParentFolio := ParentFolio;
    FParentCode := ParentCode;
    FParentCostCcy := ParentCostCcy;

    // remove any existing components
    KillComponents;

    FCompsChanged := False;

    // Load all sub-components
    With FBtrIntf^ Do Begin
      KeyS := BillMatTCode + BillMatSCode + FullNomKey (ParentFolio);
      LStatus := LFind_Rec (B_GetGEQ, FFileNo, FIndex, KeyS);

      With LPassword Do
        While (LStatus = 0) And (RecPFix = BillMatTCode) And (SubType = BillMatSCode) And (Copy (BillMatRec.StockLink, 1, 4) = FullNomKey(ParentFolio)) Do Begin
          // Create and initialise a Sub-Component object
          New (oComp);
          With oComp^ Do Begin
            // Create lines object
            CompO := TStockBOM.Create(bomComponent, imGeneral, FToolkit, FBtrIntf, False);
            CompI  := CompO;

            // Pass in Sub-Component details
            CompO.SetBillRec(BillMatRec);
          End; { With oComp }

          // Add into Sub-Components List
          FComponents.Add(oComp);

          LStatus := LFind_Rec (B_GetNext, FFileNo, FIndex, KeyS);
        End; { While ... }
    End; { With FBtrIntf^ }
  End; { If (FParentFolio <> ParentFolio) }
end;

procedure TStockBOMList.DeleteList(Const ParentFolio : LongInt);
Var
  oComp       : pComponentType;
  KeyS        : Str255;
  LStatus     : SmallInt;
begin

    With FBtrIntf^ Do Begin
      KeyS := BillMatTCode + BillMatSCode + FullNomKey (ParentFolio);
      LStatus := LFind_Rec (B_GetGEQ, FFileNo, FIndex, KeyS);

      With LPassword Do
        While (LStatus = 0) And (RecPFix = BillMatTCode) And (SubType = BillMatSCode) And
              (Copy (BillMatRec.StockLink, 1, 4) = FullNomKey(ParentFolio)) Do
        Begin

          LDelete_Rec(FFileNo, FIndex);

          KeyS := BillMatTCode + BillMatSCode + FullNomKey (ParentFolio);
          LStatus := LFind_Rec (B_GetGEq, FFileNo, FIndex, KeyS);
        End; { While ... }
    End; { With FBtrIntf^ }
end;


{------------------------------}

function TStockBOMList.SaveChanges (Const ParentFolio : LongInt) : LongInt;
Type
  SaveBOMLineType = Array [1..5000] Of TBatchBOMRec;
Var
  ParStkCode  : ANSIString;
  oComp       : pComponentType;
  BOMList     : ^SaveBOMLineType;
  BOMListSize : LongInt;
  I           : SmallInt;
begin
  If (ParentFolio = FParentFolio) And FCompsChanged Then Begin
    // Correct Stock Code and changes have been made - save all changes as a batch

    // Setup a variable size structure to pass the changes into the old Toolkit DLL function
    BOMListSize := SizeOf(TBatchBOMRec) * FComponents.Count;
    GetMem(BOMList, BOMListSize);
    FillChar (BOMList^, BOMListSize, #0);

    If (FComponents.Count > 0) Then
      For I := 0 To Pred(FComponents.Count) Do Begin
        oComp := FComponents.Items[I];

        With oComp.CompI, BOMList^[I + 1] Do Begin
          // Sub-component Stock Code
          StockCode := bmStockCode;

          // Number of sub-components used in Parent component
          QtyUsed := bmQuantityUsed;
        End; { With BOMList^[I] }
      End; { For I }

    ParStkCode := FParentCode;
    Result := Ex_StoreStockBOM(BOMList, BOMListSize, PCHAR(ParStkCode));

    FreeMem(BOMList);
  End { If (ParentFolio = StkFolio) }
  Else
    // No changes made or wrong stock code - return successful result
    Result := 0;

  //PR: 18/02/2016 v2016 R1 ABSEXCH-16860 After successful save convert to clone object
  if Result = 0 then
    FIntfType := imClone;

end;

{-----------------------------------------}

function TStockBOMList.Get_blComponentCount: Integer;
begin
  Result := FComponents.Count;
end;

{-----------------------------------------}

function TStockBOMList.Get_blComponent(Index: Integer): IStockBomComponent;
Var
  oComp : pComponentType;
begin
  // Check its a valid line number
  If (Index >= 1) And (Index <= FComponents.Count) Then Begin
    // Extract interface from list
    oComp := FComponents.Items[Index - 1];
    Result := oComp.CompI;
  End { If (Index >= 1) And (Index <= FComponents.Count) }
  Else
    Raise EInvalidMethod.Create('Invalid Sub-Component number (' + IntToStr(Index) + ')');
end;

{-----------------------------------------}

procedure TStockBOMList.AddComponent(const StockCode: WideString; QuantityUsed: Double);
Var
  oComp : pComponentType;
begin
  // Check interrnal security to ensure that method is allowed at this time
  AuthoriseFunction (100, 'AddComponent', 0);

  If (FComponents.Count < 5000) Then Begin
    // Create and initialise a Sub-Component object
    New (oComp);
    With oComp^ Do Begin
      // Create lines object
      CompO := TStockBOM.Create(bomComponent, imGeneral, FToolkit, FBtrIntf, False);
      CompI  := CompO;

      // Pass in Sub-Component details to sub-object
      CompO.UpdateBillRec(StockCode, QuantityUsed, FParentCostCcy);
    End; { With oComp }

    // Add into Sub-Components List
    FComponents.Add(oComp);

    // Mark component list as changed
    FCompsChanged := True;
  End { If (FComponents.Count < 5000) }
  Else
    Raise EMaximumSize.Create ('This Stock Item has reached the maximum of 5,000 sub-components supported by the COM Toolkit');
end;

{-----------------------------------------}

// Changes the specified component StockCode and QtyUsed
procedure TStockBOMList.EditComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double);
Var
  oComp : pComponentType;
begin
  // Check internal security to ensure that method is allowed at this time
  AuthoriseFunction (101, 'EditComponent', 0);

  If (Index > 0) And (Index <= FComponents.Count) Then Begin
    // Get component object from FComponents list
    oComp := FComponents.Items[Index - 1];

    oComp.CompO.UpdateBillRec(StockCode, QuantityUsed, FParentCostCcy);

    // Mark component list as changed
    FCompsChanged := True;
  End { If (Index > 0) And (Index <= FComponents.Count)  }
  Else
    Raise EInvalidMethod.Create('Invalid Component Index (' + IntToStr(Index) + ')');
end;

{-----------------------------------------}

// Inserts a new sub-component at the specified position
procedure TStockBOMList.InsertComponent(Index: Integer; const StockCode: WideString; QuantityUsed: Double);
Var
  oComp        : pComponentType;
begin
  // Check interrnal security to ensure that method is allowed at this time
  AuthoriseFunction (102, 'InsertComponent', 0);

  If (FComponents.Count < 5000) Then Begin
    // Create and initialise a Sub-Component object
    New (oComp);
    With oComp^ Do Begin
      // Create lines object
      CompO := TStockBOM.Create(bomComponent, imGeneral, FToolkit, FBtrIntf, False);
      CompI  := CompO;

      // Pass in Sub-Component details to sub-object
      CompO.UpdateBillRec(StockCode, QuantityUsed, FParentCostCcy);
    End; { With oComp }

    // Add into Sub-Components List
    FComponents.Insert(Index - 1, oComp);

    // Mark component list as changed
    FCompsChanged := True;
  End { If (FComponents.Count < 5000) }
  Else
    Raise EMaximumSize.Create ('This Stock Item has reached the maximum of 5,000 sub-components supported by the COM Toolkit');
end;

{-----------------------------------------}

// Deletes the specified component
procedure TStockBOMList.DeleteComponent(Index: Integer);
begin
  // Check interrnal security to ensure that method is allowed at this time
  AuthoriseFunction (103, 'DeleteComponent', 0);

  If (Index > 0) And (Index <= FComponents.Count) Then Begin
    // Delete from list
    KillComponent(Index -1);

    // Mark component list as changed
    FCompsChanged := True;
  End { If (Index > 0) And (Index <= FComponents.Count) }
  Else
    Raise EInvalidMethod.Create('Invalid Component Index (' + IntToStr(Index) + ')');
end;

{-----------------------------------------}

// Switches the components at Index1 and Index2
procedure TStockBOMList.SwitchComponents(Index1: Integer; Index2: Integer);
Var
  oComp : pComponentType;
begin
  // Check interrnal security to ensure that method is allowed at this time
  AuthoriseFunction (104, 'SwitchComponents', 0);

  If (Index1 > 0) And (Index1 <= FComponents.Count) And (Index1 <> Index2) Then
    If (Index2 > 0) And (Index2 <= FComponents.Count) Then Begin
      // Get first component object from FComponents list
      oComp := FComponents.Items[Index1 - 1];

      // replace with second component
      FComponents.Items[Index1 - 1] := FComponents.Items[Index2 - 1];

      // replace second component with copy of first
      FComponents.Items[Index2 - 1] := oComp;

      // Mark component list as changed
      FCompsChanged := True;
    End { If (Index2 > 0) And (Index2 <= FComponents.Count) }
    Else
      Raise EInvalidMethod.Create('Invalid Component Index (' + IntToStr(Index2) + ')')
  Else
    Raise EInvalidMethod.Create('Invalid Component Index (' + IntToStr(Index1) + ')');
end;

{-----------------------------------------}

// Runs through all components recalculating the cost
procedure TStockBOMList.CheckComponentCosts;
Var
  oComp : pComponentType;
  I     : SmallInt;
begin
  // Check interrnal security to ensure that method is allowed at this time
  AuthoriseFunction (105, 'CheckComponentCosts', 0);

  If (FComponents.Count > 0) Then
    For I := 0 To Pred(FComponents.Count) Do Begin
      // Extract component from list
      oComp := FComponents.Items[I];

      oComp.CompO.RecalcCost (FParentCostCcy);

      // Mark component list as changed
      FCompsChanged := True;
    End; { For I }
end;

{-----------------------------------------}

procedure TStockBOMList.SetParentCostCcy(Const ParentCostCcy : SmallInt);
begin
  FParentCostCcy := ParentCostCcy;
end;

{-----------------------------------------}
procedure TStockBOMList.CopyDataRecord;
begin
  //Do nothing - avoid warnings
end;

function TStockBOMList.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin
  Result := 0;
  //Do nothing - avoid warnings
end;

end.

