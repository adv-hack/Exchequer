unit oLineBin;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     MiscFunc, BtrvU2, ExBTTH1U, oMultBin, GlobList;

type
  //PR: 10/04/2014 ABSEXCH-14755  added ITransactionLineMultiBin2
  TTransLineMultiBin = class(TBtrieveFunctions, ITransactionLineMultiBin, ITransactionLineMultiBin2)
  private
    // List of 'Used' Serial Numbers for active transaction line
    FBins   : TList;

    // Stock code of 'parent' transaction line
    FStkCode     : ShortString;
    FStkFolio    : LongInt;

    // Cached infor to determine of transaction has changed
    FTHOurRef    : ShortString;
    FTLAbsNo     : LongInt;
    FTHType      : DocTypes;

    // Flag to indicate whether the 'parent' transaction line uses Serial numbers
    FUsesBins  : Boolean;

    // Mode of 'parent' transaction object
    FIntfType    : TInterfaceMode;

    // Serial/Batch sub-object
    FBinO     : TMultiBin;
    FBinI     : IMultiBinDetails;

    // Parent Transaction Line stored as TObject to avoid circular references
    FParentTrans : TObject;
    FParentLine  : TObject;

    // Main Toolkit object
    FToolkit     : TObject;
  protected
    // ITransactionLineMultiBin
    function Get_tlCount: Integer; safecall;
    function Get_tlUsesMultiBins: WordBool; safecall;
    function Get_tlUsedMultiBins(Index: Integer): IMultiBinDetails; safecall;
    procedure Refresh; safecall;
    function Add: IMultiBin; safecall;
    function UseMultiBin(const MultiBin: IMultiBinDetails; Qty: Double): Integer; safecall;

    //PR: 08/04/2014 ABSEXCH-14755 ITransactionLineMultiBin2
    function AddToBin(const MultiBin: IMultiBinDetails; Qty: Double): Integer; safecall;
    // Local Methods
    Procedure InitObjects;
    Procedure KillSerial(Const Index : Integer);
    Procedure KillSerialNos;
    Procedure CopyDataRecord; override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; override;
  public
    Constructor Create (Const IType       : TInterfaceMode;
                        Const Toolkit     : TObject;
                        Const ParentTrans : TObject;
                        Const ParentLine  : TObject;
                        Const BtrIntf     : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Procedure BuildBinList (Const IntfType  : TInterfaceMode;
                                  StkCode   : ShortString;
                            Const THOurRef  : ShortString;
                            Const TLAbsNo   : LongInt;
                            Const THType    : DocTypes;
                            const ForceLoad : Boolean);
  End; { TTransLineMultiBin }

Function CreateTTransLineMultiBin (Const Toolkit     : TObject;
                                   Const ParentTrans : TObject;
                                   Const ParentLine  : TObject) : TTransLineMultiBin;

implementation

uses ComServ, oToolkit, DllErrU, BtsupU1, BtKeys1U, EtStrU, ETMiscU, BTS1,
     CurrncyU, DllBin,
{$If Defined(COMPRNT)}
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
{$IfEnd}
     oTrans,                 // Transaction Object
     oLine;                  // Transaction Line Object

Type
  TLineBinType = Record
    BinRec : brBinRecType;
  End;
  pLineBinType = ^TLineBinType;


{-------------------------------------------------------------------------------------------------}

Function CreateTTransLineMultiBin (Const Toolkit     : TObject;
                                   Const ParentTrans : TObject;
                                   Const ParentLine  : TObject) : TTransLineMultiBin;
Var
  BtrIntf : TCtkTdPostExLocalPtr;
Begin { CreateTTransLineSno }
  // Create common btrieve interface for objects
(*  New (BtrIntf, Create(22));

  // Open files needed by TStock object
  BtrIntf^.Open_System(StockF, StockF);  { Stock }
  BtrIntf^.Open_System(MiscF,  MiscF);   { Serial/Batch }
  BtrIntf^.Open_System(PwrdF,  PwrdF);   { Serial/Batch Notes }
  *)
  {PR: Change 10/07/03. Change so that all TransLineSNos use the same BtrIntf which
   is now a property of TToolkit}
  // Create bas TAccount object
  BtrIntf := (Toolkit as TToolkit).MultiBinBtrIntf;
  Result := TTransLineMultiBin.Create(imGeneral, Toolkit, ParentTrans, ParentLine, BtrIntf);
End; { CreateTTransLineSno }

{-------------------------------------------------------------------------------------------------}

Constructor TTransLineMultiBin.Create (Const IType       : TInterfaceMode;
                                          Const Toolkit     : TObject;
                                          Const ParentTrans : TObject;
                                          Const ParentLine  : TObject;
                                          Const BtrIntf     : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITransactionLineMultiBin2, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MiscF;

  // Initialise object references
  InitObjects;

  // Create list to hold Serial Number objects
  FBins := TList.Create;

  // Initialise variables
  FUsesBins := False;
  FStkCode := StringOfChar (#255, StkKeyLen);
  FTHOurRef := StringOfChar (#255, 9);
  FTLAbsNo := -19191919;
  FTHType := FOL;

  // Set reference to parent transaction and line
  FParentTrans := ParentTrans;
  FParentLine := ParentLine;

  // Setup reference to main Toolkit object
  FToolkit := Toolkit;
End; { Create }

{------------------------------}

destructor TTransLineMultiBin.Destroy;
begin
  { Remove any loaded lines }
  KillSerialNos;

  { Destroy sub-ojects }
  FreeAndNIL(FBins);
  InitObjects;

  //PR Change 10/07/03 BtrIntf is now owned by toolkit object so don't destroy it
{  If (FIntfType = imGeneral) Then Begin
    // Destroy Btrieve interface objecct
    Dispose (FBtrIntf, Destroy);
    FBtrIntf := NIL;
  End; { If (FIntfType = imGeneral) }

  inherited;
end;

{------------------------------}

procedure TTransLineMultiBin.InitObjects;
begin
  // Serial/Batch sub-object
  FBinO := NIL;
  FBinI := NIL;

  FParentTrans := NIL;
  FParentLine := NIL;
  FToolkit := NIL;
end;

{------------------------------}

// Removes a specific component from the component list
Procedure TTransLineMultiBin.KillSerial(Const Index : Integer);
Var
  TmpSer : pLineBinType;
Begin { KillSerial }
  // remove object references
  TmpSer := FBins.Items[Index];
  Dispose(TmpSer);

  // Destroy List Entry
  FBins.Delete(Index);
End; { KillSerial }

{-----------------------------------------}

// Empties the sub-components List
Procedure TTransLineMultiBin.KillSerialNos;
Begin { KillSerialNos }
  While (FBins.Count > 0) Do
    KillSerial(0);
End; { KillSerialNos }

{------------------------------}

// Loads the FBins list with the Bins allocated to the transaction line
Procedure TTransLineMultiBin.BuildBinList (Const IntfType  : TInterfaceMode;
                                                 StkCode   : ShortString;
                                           Const THOurRef  : ShortString;
                                           Const TLAbsNo   : LongInt;
                                           Const THType    : DocTypes;
                                           const ForceLoad : Boolean);
Var
  siPos   : TBtrieveFileSavePos;
  oBin : pLineBinType;
  KeyS    : Str255;
  lStatus : SmallInt;

  function CheckInOrder : Boolean;
  begin
    with FBtrIntf.LMLocCtrl^.brBinRec do
      Result := ((THType = POR) And (brInOrdDoc = FTHOurRef) And
                 (brInOrdLine = TLAbsNo) And (Not brBatchChild));
  end;

  function CheckInDoc : Boolean;
  begin
    with FBtrIntf.LMLocCtrl^.brBinRec do
      Result := ((THType In [ADJ, POR, PDN, PIN, PJI, PPI, SCR, SJC, SRF]) And
                 (brInDoc = FTHOurRef) And (brBuyLine = TLAbsNo) And (Not brBatchChild));
  end;

  function CheckOutOrder : Boolean;
  begin
    with FBtrIntf.LMLocCtrl^.brBinRec do
      Result := ((THType = SOR) And (brOutOrdDoc = FTHOurRef) And (brOutOrdLine = TLAbsNo));
  end;

  function CheckOutDoc : Boolean;
  begin
    with FBtrIntf.LMLocCtrl^.brBinRec do
      Result := ((THType In [ADJ, SOR, SDN, SIN, SJI, SRI, PCR, PJC, PRF]) And
                 (brOutDoc = FTHOurRef) And (brSoldLine = TLAbsNo));
  end;

  function CheckReturn : Boolean;
  begin  //No way to check this so don't use for now.
    with FBtrIntf.LMLocCtrl^.brBinRec do
      Result := (THType In [SRN, PRN]) and brReturnBin;
  end;

Begin { BuildSerialList }
  // Check for updates
  StkCode := FullStockCode(UpperCase(StkCode));
  If ForceLoad Or (FStkCode <> StkCode) Or (IntfType <> FIntFType) Or (FTHOurRef <> THOurRef) Or (FTLAbsNo <> TLAbsNo) Then Begin
    // Take local copy of parent info
    FStkCode := StkCode;
    FIntfType := IntFType;
    FTHOurRef := THOurRef;
    FTHType := THType;
    FTLAbsNo := TLAbsNo;

    // Need to re-load - remove any existing Serial/Batch details
    KillSerialNos;

    // Check for Stock Code - No Stock Code = No Serial Numbers
    If (Trim(FStkCode) <> '') Then
      With FBtrIntf^ Do Begin
        // Get Stock Record
        SaveExLocalPosFile (StockF, siPos);
        If LGetMainRec(StockF, FStkCode) Then Begin
          // Got Stock - Check Valuation Method for Serial/Batch Type
          FUsesBins := LStock.MultiBinMode;
          FStkFolio := LStock.StockFolio;
        End { If LGetMainRec(StockF, FStkCode) }
        Else
          // Cannot load Stock Code
          FUsesBins := False;
        RestoreExLocalPos (siPos);

        //-----------------

        If FUsesBins Then Begin
          // Load Bins for Transaction line
          KeyS := BRRecCode + MSernSub + FullNomKey (FStkFolio) + StringOfChar (#0, 21);
          lStatus := LFind_Rec (B_GetGEq, MLocF, 1, KeyS);
          //PR 14/07/03 Added missing Doc types to check - PJI, PPI, SCR, SJC, SRF, SJI, SRI, PCR, PJC, PRF.
          While (lStatus = 0) And (LMLocCtrl^.brBinRec.brStkFolio = FStkFolio) Do Begin
            With LMLocCtrl^.brBinRec Do Begin
              If CheckInOrder Or
                 CheckInDoc Or
                 CheckOutOrder Or
                 CheckOutDoc Then Begin
                // Document uses this Serial number - Add into list
                New (oBin);
                With oBin^ Do Begin
                  BinRec := LMLocCtrl^.brBinRec;
                End; { With oSerial^ }

                // Add into Serial/Batch Numbers List
                FBins.Add(oBin);
              End; { If }
            End; { With LMiscRecs.SerialRec }

            lStatus := LFind_Rec (B_GetNext, MLocF, 1, KeyS);
          End; { While ... }
        End { If FUsesBins }
      End { With FBtrIntf^ }
    Else
      // No Stock Code - Therefore No Serial Numbers
      FUsesBins := False;
  End; { If (FStkCode <> StkCode) }
End; { BuildSerialList }

{------------------------------}

function TTransLineMultiBin.Get_tlCount: Integer;
begin
  Result := FBins.Count;
end;

{------------------------------}

function TTransLineMultiBin.Get_tlUsedMultiBins(Index: Integer): IMultiBinDetails;
Var
  oBin : pLineBinType;
  BRec : TBatchBinRec;
begin
  If (Index >= 1) And (Index <= FBins.Count) Then Begin
    // Check Serial/Batch detail sub-object has been initialised
    If (Not Assigned(FBinO)) Then Begin
      FBinO := TMultiBin.Create(imClone, FToolkit, FBtrIntf, False, False);

      FBinI := FBinO;
    End; { If (Not Assigned(FSerialO)) }

    // Extract object from TList
    oBin := FBins.Items[Index - 1];

    DoCopyEntBinToTkBin(oBin.BinRec, BRec);

    // Update object with Serial/Batch detail
    FBinO.CloneDetails (BRec);

    Result := FBinI;
  End { If (Index >= 1) And (Index <= FBins.Count) }
  Else
    Raise EInvalidMethod.Create('Invalid Transaction Line MultiBin index (' + IntToStr(Index) + ')');
end;

{------------------------------}

function TTransLineMultiBin.Get_tlUsesMultiBins: WordBool;
begin
  Result := FUsesBins;
end;

{------------------------------}

function TTransLineMultiBin.Add: IMultiBin;
Var
  FBinO : TMultiBin;
begin { Add }
  If FUsesBins Then Begin
    FBinO := TMultiBin.Create(imAdd, FToolkit, FBtrIntf, False, True);
    FBinO.InitFromTrans ((FParentTrans As TTransaction).TH, (FParentLine As TTransactionLine).TL, FStkFolio);

    Result := FBinO;
  End { If FUsesBins }
  Else
    Raise EInvalidMethod.Create ('This Transaction Line does not use MultiBins');
end;

{------------------------------}

// Used by programmers to refresh the Sno list after adding a Serial
// Number, not technically feasible to do it automatically
procedure TTransLineMultiBin.Refresh;
begin
  BuildBinList (FIntfType, FStkCode, FTHOurRef, FTLAbsNo, FTHType, True);
end;

{------------------------------}

function TTransLineMultiBin.UseMultiBin(const MultiBin: IMultiBinDetails; Qty: Double): Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  TkBin : TBatchBinRec;
begin
  If (Not (FIntfType In [imAdd, imUpdate])) Then Begin
    // Check we are using MultiBins
    If FUsesBins Then Begin
      // Check Transaction Type - probably filtered out already by FUsesBins, but just in case
      //PR: 17/11/2011 Allow PCR, PJC & PRF to use bins ABSEXCH-12139/12152
      If (FTHType In ([ADJ, PCR, PJC, PRF] + SalesSplit - RecieptSet - BatchSet)) Then Begin
        // Do some basic checks before continuing
        With MultiBin Do Begin
          // Can be either a Serial or a Batch record, but not a Batch Child
          // Must not be already sold
          If not mbUsed then Begin
            // Save current file positions in main files

            SaveInfo := SaveSystemFilePos ([]);

            FillChar(TkBin, SizeOf(TkBin), 0);
            TkBin.brBinCode := MultiBin.mbCode;
            TkBin.brInDocRef := MultiBin.mbInDocRef;
            TkBin.brInDate := MultiBin.mbInDate;
            TkBin.brInLocation := MultiBin.mbInLocation;
            TkBin.brInDocLine := MultiBin.mbInDocLine;
            TkBin.brInOrderRef := MultiBin.mbInOrderRef;
            TkBin.brInOrderLine := MultiBin.mbInOrderLine;
            TkBin.brCostPrice := MultiBin.mbCostPrice;
            TkBin.brCostPriceCurrency := MultiBin.mbCostPriceCurrency;
            TkBin.brStockFolio := FStkFolio;
            TkBin.brSold := True;

            With TkBin Do Begin
              // Copy details in from Transaction and Serial/Batch object

              brOutDocRef := FTHOurRef;
              brOutDocLine := FTLAbsNo;

              If (FTHType = SOR) Then Begin
                // Set Out Order details as well
                brOutOrderRef := FTHOurRef;
                brOutOrderLine := FTLAbsNo;
              End; { If (FTHType = SOR) }

              // Copy details in from Transaction Header
              With (FParentTrans As TTransaction) Do Begin
                brOutDate := TH.TransDate;
                brSalesPriceCurrency := TH.Currency;
              End; { With (FParentTrans As TTransaction) }

              // Copy details in from Transaction Line
              With (FParentLine As TTransactionLine) Do Begin
                brSalesPrice := TL.NetValue;
                brOutLocation := TL.MLocStk;
                brQtyUsed := Qty;
              End; { With (FParentLine As TTransactionLine) }

              brCompanyRate := SyssCurr^.Currencies[brCostPriceCurrency].CRates[False];
              brDailyRate := SyssCurr^.Currencies[brCostPriceCurrency].CRates[True];

            End; { With TkBin }

            Result := Ex_UseMultiBin (@TkBin, SizeOf(TkBin));

            // Restore original file positions
            RestoreSystemFilePos (SaveInfo);
          End  // If not mbUsed
          Else
            Raise EValidation.Create ('This MultiBin object cannot be ' + QuotedStr('used') + '.');
        End; { With MultiBin }
      End { If (FTHType In ([ADJ] + SalesSplit)) }
      Else
        Raise EInvalidMethod.Create ('This Transaction Type does not use MultiBins');
    End { If FUsesBins }
    Else
      Raise EInvalidMethod.Create ('This Transaction Line does not use MultiBins');
  End { If (Not (FIntfType In [imAdd, imUpdate])) }
  Else
    Raise EInvalidMethod.Create ('The UseMultiBin method cannot be used whilst a Transacton is being Added or Edited');
end;

{------------------------------}

//PR: 10/04/2014 ABSEXCH-14755
function TTransLineMultiBin.AddToBin(const MultiBin: IMultiBinDetails;
  Qty: Double): Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  TkBin : TBatchBinRec;
  BinString : WideString;
  RecPos : longint;
begin
  If (Not (FIntfType In [imAdd, imUpdate])) Then Begin
    // Check we are using MultiBins
    If FUsesBins Then Begin
      // Check Transaction Type - probably filtered out already by FUsesBins, but just in case
      If (FTHType In ([ADJ, SCR, SJC, SRF] + PurchSplit - RecieptSet - BatchSet)) Then Begin
        // Do some basic checks before continuing
        With MultiBin Do Begin
          // Must not be a child (used) record
          If not mbUsed then Begin
            // Save current file positions in main files

            SaveInfo := SaveSystemFilePos ([]);

            FillChar(TkBin, SizeOf(TkBin), 0);

            with MultiBin as IToolkitRecord do
              BinString := GetData;

            Move(BinString[1], TkBin, SizeOf(TkBin));

            //Set qty
            TkBin.brQty := TkBin.brQty + Qty;
            //AP : 15/12/2016 : ABSEXCH-17327 When adding stock items to an existing bin (using AddToBin), the line bin quantity is not being updated
            TkBin.brAddQty := TkBin.brQty;
            //Set transaction and line to update
            TkBin.brLatestInDoc := (FParentTrans As TTransaction).TH.OurRef;
            TkBin.brLatestInLine := (FParentLine As TTransactionLine).TL.AbsLineNo;

            //Get position
            (MultiBin as IBtrieveFunctions).SavePosition;
            RecPos := (MultiBin as IBtrieveFunctions).Position;

            //Restore position in main file
            if RecPos <> 0 then
            begin
              SetDataRecOfs(MLocF, RecPos);
              Status := GetDirect(F[MLocF],MLocF,RecPtr[MLocF]^,0,0);
            end;

            Result := Ex_StoreMultiBin (@TkBin, SizeOf(TkBin), 0, B_Update);

            // Restore original file positions
            RestoreSystemFilePos (SaveInfo);
          End { If (snType In [snTypeSerial, snTypeBatch]) And (Not snSold) }
          Else
            Raise EValidation.Create ('This MultiBin object cannot be ' + QuotedStr('added to') + '.');
        End; { With MultiBin }
      End { If (FTHType In ([ADJ] + SalesSplit)) }
      Else
        Raise EInvalidMethod.Create ('This Transaction Type add stock to MultiBins');
    End { If FUsesBins }
    Else
      Raise EInvalidMethod.Create ('This Transaction Line does not use MultiBins');
  End { If (Not (FIntfType In [imAdd, imUpdate])) }
  Else
    Raise EInvalidMethod.Create ('The AddToBin method cannot be used whilst a Transacton is being Added or Edited');
end;

procedure TTransLineMultiBin.CopyDataRecord;
begin
  //Do nothing - avoid warnings
end;

function TTransLineMultiBin.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin
  //Do nothing - avoid warnings
  Result := 0;
end;

end.
