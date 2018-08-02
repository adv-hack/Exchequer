unit OLineSNo;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U, {$IFNDEF WANTEXE04}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     VarCnst3, oBtrieve, MiscFunc, BtrvU2, ExBTTH1U, oSerial, GlobList;

type
  TTransLineSerialBatch = class(TBtrieveFunctions, ITransactionLineSerialBatch, ITransactionLineSerialBatch2,
                                 ITransactionLineSerialBatch3, ITransactionLineSerialBatch4)
  private
    // List of 'Used' Serial Numbers for active transaction line
    FSerialNos   : TList;

    // Stock code of 'parent' transaction line
    FStkCode     : ShortString;
    FStkFolio    : LongInt;

    // Cached infor to determine of transaction has changed
    FTHOurRef    : ShortString;
    FTLAbsNo     : LongInt;
    FTHType      : DocTypes;
    FQty         : Double;

    // Flag to indicate whether the 'parent' transaction line uses Serial numbers
    FUsesSerial  : Boolean;

    // Mode of 'parent' transaction object
    FIntfType    : TInterfaceMode;

    // Serial/Batch sub-object
    FSerialO     : TSerialBatch;
    FSerialI     : ISerialBatchDetails;

    // Parent Transaction Line stored as TObject to avoid circular references
    FParentTrans : TObject;
    FParentLine  : TObject;

    // Main Toolkit object
    FToolkit     : TObject;
    function DoUseSerialBatch(const SerialBatch: ISerialBatchDetails; Qty: Double): Integer;
  protected
    // ITransactionLineSerialBatch
    function  Get_tlCount: Integer; safecall;
    function  Get_tlUsedSerialBatch(Index: Integer): ISerialBatchDetails; safecall;
    function  Get_tlUsesSerialBatchNo: WordBool; safecall;
    function  Add: ISerialBatch; safecall;
    procedure Refresh; safecall;
    function  UseSerialBatch(const SerialBatch: ISerialBatchDetails): Integer; safecall;

    // ITransactionLineSerialBatch2
    function Print(PrintAs: TTransLineSerialPrintMode): IPrintJob; safecall;

    // ITransactionLineSerialBatch3
    function UseBatch(const Batch: ISerialBatchDetails; Qty: Double): Integer; safecall;

    //PR: 10/04/2014 ABSEXCH-14755 ITransactionLineSerialBatch4
    function AddToBatch(const Batch: ISerialBatchDetails; Qty: Double): Integer; safecall;

    Procedure CopyDataRecord; override;
    Function  GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer; override;

    // Local Methods
    Procedure InitObjects;
    Procedure KillSerial(Const Index : Integer);
    Procedure KillSerialNos;
  public
    Constructor Create (Const IType       : TInterfaceMode;
                        Const Toolkit     : TObject;
                        Const ParentTrans : TObject;
                        Const ParentLine  : TObject;
                        Const BtrIntf     : TCtkTdPostExLocalPtr);

    Destructor Destroy; override;

    Procedure BuildSerialList (Const IntfType  : TInterfaceMode;
                                     StkCode   : ShortString;
                               Const THOurRef  : ShortString;
                               Const TLAbsNo   : LongInt;
                               Const THType    : DocTypes;
                               const ForceLoad : Boolean;
                               const Qty       : Double);
  End; { TTransLineSerialBatch }

Function CreateTTransLineSno (Const Toolkit     : TObject;
                              Const ParentTrans : TObject;
                              Const ParentLine  : TObject) : TTransLineSerialBatch;

implementation

uses ComServ, oToolkit, DllErrU, BtsupU1, BtKeys1U, EtStrU, ETMiscU, BTS1,
     CurrncyU, DllSrBOM,
{$If Defined(COMPRNT)}
     EnterpriseForms_TLB,    // Type Library for Form Printing Toolkit
     oPrntJob,               // COM Toolkit Print Job Object
{$IfEnd}
     oTrans,                 // Transaction Object
     oLine;                  // Transaction Line Object

Type
  TLineSerialType = Record
    SerialRec : SerialType;
  End;
  pLineSerialType = ^TLineSerialType;


{-------------------------------------------------------------------------------------------------}

Function CreateTTransLineSno (Const Toolkit     : TObject;
                              Const ParentTrans : TObject;
                              Const ParentLine  : TObject) : TTransLineSerialBatch;
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
  BtrIntf := (Toolkit as TToolkit).SerialNoBtrIntf;
  Result := TTransLineSerialBatch.Create(imGeneral, Toolkit, ParentTrans, ParentLine, BtrIntf);
End; { CreateTTransLineSno }

{-------------------------------------------------------------------------------------------------}

Constructor TTransLineSerialBatch.Create (Const IType       : TInterfaceMode;
                                          Const Toolkit     : TObject;
                                          Const ParentTrans : TObject;
                                          Const ParentLine  : TObject;
                                          Const BtrIntf     : TCtkTdPostExLocalPtr);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITransactionLineSerialBatch4, BtrIntf);

  // Initialise Btrieve Ancestor
  FFileNo := MiscF;

  // Initialise object references
  InitObjects;

  // Create list to hold Serial Number objects
  FSerialNos := TList.Create;

  // Initialise variables
  FUsesSerial := False;
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

destructor TTransLineSerialBatch.Destroy;
begin
  { Remove any loaded lines }
  KillSerialNos;

  { Destroy sub-ojects }
  FreeAndNIL(FSerialNos);
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

procedure TTransLineSerialBatch.InitObjects;
begin
  // Serial/Batch sub-object
  FSerialO := NIL;
  FSerialI := NIL;

  FParentTrans := NIL;
  FParentLine := NIL;
  FToolkit := NIL;
end;

{------------------------------}

// Removes a specific component from the component list
Procedure TTransLineSerialBatch.KillSerial(Const Index : Integer);
Var
  TmpSer : pLineSerialType;
Begin { KillSerial }
  // remove object references
  TmpSer := FSerialNos.Items[Index];
  Dispose(TmpSer);

  // Destroy List Entry
  FSerialNos.Delete(Index);
End; { KillSerial }

{-----------------------------------------}

// Empties the sub-components List
Procedure TTransLineSerialBatch.KillSerialNos;
Begin { KillSerialNos }
  While (FSerialNos.Count > 0) Do
    KillSerial(0);
End; { KillSerialNos }

{------------------------------}

// Loads the FSerialNos list with the Serial/Batch Numbers allocated to the transaction line
Procedure TTransLineSerialBatch.BuildSerialList (Const IntfType  : TInterfaceMode;
                                                       StkCode   : ShortString;
                                                 Const THOurRef  : ShortString;
                                                 Const TLAbsNo   : LongInt;
                                                 Const THType    : DocTypes;
                                                 const ForceLoad : Boolean;
                                                 const Qty       : Double);
Var
  siPos   : TBtrieveFileSavePos;
  oSerial : pLineSerialType;
  KeyS    : Str255;
  iStatus : SmallInt;

  function CheckInOrder : Boolean;
  begin
    with FBtrIntf^.LMiscRecs.SerialRec do
      Result := ((THType = POR) And (InOrdDoc = FTHOurRef) And
                 (InOrdLine = TLAbsNo) And (Not BatchChild));

  end;

  function CheckInDoc : Boolean;
  begin
    with FBtrIntf^.LMiscRecs.SerialRec do
      Result := ((THType In [ADJ, POR, PDN, PIN, PJI, PPI, SCR, SJC, SRF]) And
                 (InDoc = FTHOurRef) And (BuyLine = TLAbsNo) And (Not BatchChild) {and (Qty > 0.00)});
  end;

  function CheckOutOrder : Boolean;
  begin
    with FBtrIntf^.LMiscRecs.SerialRec do
      Result := ((THType = SOR) And (OutOrdDoc = FTHOurRef) And (OutOrdLine = TLAbsNo));
  end;

  function CheckOutDoc : Boolean;
  begin
    with FBtrIntf^.LMiscRecs.SerialRec do
      Result := ((THType In [ADJ, SOR, SDN, SIN, SJI, SRI, PCR, PJC, PRF, WOR, PRN]) And
                 (OutDoc = FTHOurRef) And (SoldLine = TLAbsNo) {and (Qty < 0.00)});
  end;

  function CheckReturnDoc : Boolean;
  begin
    with FBtrIntf^.LMiscRecs.SerialRec do
      Result := ((THType in [SRN, PRN]) and {ReturnSNo and}
                 (RetDoc = FTHOurRef) and (RetDocLine = TLAbsNo));
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
    FQty := Qty;
    // Need to re-load - remove any existing Serial/Batch details
    KillSerialNos;

    // Check for Stock Code - No Stock Code = No Serial Numbers
    If (Trim(FStkCode) <> '') Then
      With FBtrIntf^ Do Begin
        // Get Stock Record
        SaveExLocalPosFile (StockF, siPos);
        If LGetMainRec(StockF, FStkCode) Then Begin
          // Got Stock - Check Valuation Method for Serial/Batch Type
          FUsesSerial := (LStock.StkValType = 'R') Or ((LStock.StkValType = 'A') And (LStock.SerNoWAvg = 1));
          FStkFolio := LStock.StockFolio;
        End { If LGetMainRec(StockF, FStkCode) }
        Else
          // Cannot load Stock Code
          FUsesSerial := False;
        RestoreExLocalPos (siPos);

        //-----------------

        If FUsesSerial Then Begin
          // Load Serial/Batch Numbers for Transaction line
          KeyS := MFIFOCode + MSernSub + FullNomKey (FStkFolio) + Chr(1) + StringOfChar (#255, 20);
          iStatus := LFind_Rec (B_GetLessEq, MiscF, MIK, KeyS);
          //PR 14/07/03 Added missing Doc types to check - PJI, PPI, SCR, SJC, SRF, SJI, SRI, PCR, PJC, PRF.
          While (iStatus = 0) And (LMiscRecs.SerialRec.StkFolio = FStkFolio) Do Begin
            With LMiscRecs.SerialRec Do Begin
              If CheckInOrder Or
                 CheckInDoc Or
                 CheckOutOrder Or
                 CheckOutDoc  or
                 CheckReturnDoc Then Begin
                // Document uses this Serial number - Add into list
                New (oSerial);
                With oSerial^ Do Begin
                  SerialRec := LMiscRecs.SerialRec;
                End; { With oSerial^ }

                // Add into Serial/Batch Numbers List
                FSerialNos.Add(oSerial);
              End; { If }
            End; { With LMiscRecs.SerialRec }

            iStatus := LFind_Rec (B_GetPrev, MiscF, MIK, KeyS);
          End; { While ... }
        End { If FUsesSerial }
      End { With FBtrIntf^ }
    Else
      // No Stock Code - Therefore No Serial Numbers
      FUsesSerial := False;
  End; { If (FStkCode <> StkCode) }
End; { BuildSerialList }

{------------------------------}

function TTransLineSerialBatch.Get_tlCount: Integer;
begin
  Result := FSerialNos.Count;
end;

{------------------------------}

function TTransLineSerialBatch.Get_tlUsedSerialBatch(Index: Integer): ISerialBatchDetails;
Var
  oSerial : pLineSerialType;
begin
  If (Index >= 1) And (Index <= FSerialNos.Count) Then Begin
    // Check Serial/Batch detail sub-object has been initialised
    If (Not Assigned(FSerialO)) Then Begin
      FSerialO := TSerialBatch.Create(imClone, FToolkit, FBtrIntf, False, False);

      FSerialI := FSerialO;
    End; { If (Not Assigned(FSerialO)) }

    // Extract object from TList
    oSerial := FSerialNos.Items[Index - 1];

    // Update object with Serial/Batch detail
    FSerialO.CloneDetails (oSerial.SerialRec);

    Result := FSerialI;
  End { If (Index >= 1) And (Index <= FSerialNos.Count) }
  Else
    Raise EInvalidMethod.Create('Invalid Transaction Line Serial/Batch Number index (' + IntToStr(Index) + ')');
end;

{------------------------------}

function TTransLineSerialBatch.Get_tlUsesSerialBatchNo: WordBool;
begin
  Result := FUsesSerial;
end;

{------------------------------}

function TTransLineSerialBatch.Add: ISerialBatch;
Var
  FSerialO : TSerialBatch;
begin { Add }
  If FUsesSerial Then Begin
    FSerialO := TSerialBatch.Create(imAdd, FToolkit, FBtrIntf, False, True);
    FSerialO.InitFromTrans ((FParentTrans As TTransaction).TH, (FParentLine As TTransactionLine).TL, FStkFolio);

    Result := FSerialO;
  End { If FUsesSerial }
  Else
    Raise EInvalidMethod.Create ('This Transaction Line does not use Serial Numbers');
end;

{------------------------------}

// Used by programmers to refresh the Sno list after adding a Serial
// Number, not technically feasible to do it automatically
procedure TTransLineSerialBatch.Refresh;
begin
  BuildSerialList (FIntfType, FStkCode, FTHOurRef, FTLAbsNo, FTHType, True, FQty);
end;

{------------------------------}

function TTransLineSerialBatch.UseSerialBatch(const SerialBatch: ISerialBatchDetails): Integer;
begin
  Result := DoUseSerialBatch(SerialBatch, 1);
end;

function TTransLineSerialBatch.UseBatch(const Batch: ISerialBatchDetails; Qty: Double): Integer;
begin
  if Batch.snType <> snTypeBatch then
    Result := 30021
  else
    Result := DoUseSerialBatch(Batch, Qty);
end;

function TTransLineSerialBatch.DoUseSerialBatch(const SerialBatch: ISerialBatchDetails; Qty : Double): Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  TkSerial : TBatchSerialRec;
begin
  If (Not (FIntfType In [imAdd, imUpdate])) Then Begin
    // Check we are using Serial Numbers
    If FUsesSerial Then Begin
      // Check Transaction Type - probably filtered out already by FUsesSerial, but just in case

      //PR: 31/10/2011 v6.9 Added PCR, PRF & PJC. ABSEXCH-11953
      If (FTHType In ([ADJ, SRN, PRN, WOR, PCR, PRF, PJC] + SalesSplit - RecieptSet - BatchSet)) Then Begin
        // Do some basic checks before continuing
        With SerialBatch Do Begin
          // Can be either a Serial or a Batch record, but not a Batch Child
          // Must not be already sold
          If (snType In [snTypeSerial, snTypeBatch]) And ((Not snSold) or (FTHType = SRN)) Then Begin
            // Save current file positions in main files
            SaveInfo := SaveSystemFilePos ([]);

            FillChar (TKSerial, SizeOf(TkSerial), #0);
            With TKSerial Do Begin
              // Copy details in from Transaction and Serial/Batch object
              SerialNo := snSerialNo;
              BatchNo := snBatchNo;

              BuyQty := snBatchQuantity;
              InDoc := snInDocRef;
              BuyAbsLine := snInDocLine;
              DateIn := snInDate;
              Sold := snSold;
              //PR 19/04/06 - use by date was missing
              DateUseX := snUseByDate;

              //PR: 09/02/2011 Store record position to ensure correct record identification. (ABSEXCH-2689)
              (SerialBatch as IBtrieveFunctions).SavePosition;
              RecPos := (SerialBatch as IBtrieveFunctions).Position;

              StockCode := FStkCode;

              if FTHType in [SRN, PRN] then
                Returned := True;

              if ((FTHType = PRN) and (Trim(OutDoc) <> '')) or
                 (FTHType = SRN) then
              begin
                ReturnDoc := FTHOurRef;
                ReturnDocLine := FTLAbsNo;
                OutDoc := snOutDocRef;
                SoldAbsLine := snOutDocLine;
              end
              else
              begin
                OutDoc := FTHOurRef;
                SoldABSLine := FTLAbsNo;
              end;

              If (FTHType = SOR) Then Begin
                // Set Out Order details as well
                OutOrdDoc := FTHOurRef;
                OutOrdLine := FTLAbsNo;
              End; { If (FTHType = SOR) }

              // Copy details in from Transaction Header
              With (FParentTrans As TTransaction) Do Begin
                DateOut := TH.TransDate;
                CurSell := TH.Currency;
              End; { With (FParentTrans As TTransaction) }

              // Copy details in from Transaction Line
              With (FParentLine As TTransactionLine) Do Begin
                SerSell := TL.NetValue;
                OutMLoc := TL.MLocStk;
              End; { With (FParentLine As TTransactionLine) }

              CoRate := SyssCurr^.Currencies[CurSell].CRates[BOn];
              DailyRate := SyssCurr^.Currencies[CurSell].CRates[BOff];

//              QtyUsed := 1;
              QtyUsed := Qty;

              // HM 07/09/01: Added additional fields for improved support of Duplicate Batches
              InMLoc := snInLocation;
            End; { With TKSerial }

            Result := Ex_UseSerialBatch (@TkSerial, SizeOf(TkSerial), B_Update);

            // Restore original file positions
            RestoreSystemFilePos (SaveInfo);
          End { If (snType In [snTypeSerial, snTypeBatch]) And (Not snSold) }
          Else
            Raise EValidation.Create ('This Serial/Batch object cannot be ' + QuotedStr('used') + '.');
        End; { With SerialBatch }
      End { If (FTHType In ([ADJ] + SalesSplit)) }
      Else
        Raise EInvalidMethod.Create ('This Transaction Type does not use Serial Numbers');
    End { If FUsesSerial }
    Else
      Raise EInvalidMethod.Create ('This Transaction Line does not use Serial Numbers');
  End { If (Not (FIntfType In [imAdd, imUpdate])) }
  Else
    Raise EInvalidMethod.Create ('The UseSerialBatch method cannot be used whilst a Transacton is being Added or Edited');
end;

{------------------------------}

function TTransLineSerialBatch.Print(PrintAs: TTransLineSerialPrintMode): IPrintJob;
Var
  oPrintJob  : TPrintJob;
begin { Print }
  // Only allow printing for general object and clone objects
  If (FIntfType In [imGeneral, imClone]) Then Begin
    // Create and initialise the PrintJob object
    oPrintJob := TPrintJob.Create(FToolkit, fmSerialLabel, defTypeTransLineSerialLabels, jtLabelRun);
    With oPrintJob Do Begin
      // Configure to print the transaction
      With (FParentTrans As TTransaction).TH Do Begin
        MainFileNum  := InvF;
        MainKeyPath  := InvOurRefK;
        MainKeyRef   := FullOurRefKey(OurRef);

        DefaultAcc   := CustCode;
      End; { With (FParentTrans As TTransaction).TH }

      With (FParentLine As TTransactionLine).TL Do Begin
        TableFileNum := IDetailF;
        TableKeyPath := IDLinkK;
        TableKeyRef  := FullNomKey(FolioNum) + FullNomKey(ABSLineNo);
      End; { With (FParentLine As TTransactionLine).TL }

      // Serial Labels - need to import all Serial No's for line as separate items
      With FormsToolkitI.PrintJob.ImportDefaults Do Begin
        idType   := defTypeTransLineSerialLabels;
        idAcCode := DefaultAcc;

        // Main File = Invoice
        idMainFileNo    := MainFileNum;
        idMainIndexNo   := MainKeyPath;
        idMainKeyString := MainKeyRef;

        // Tabl = Line
        idTableFileNo    := TableFileNum;
        idTableIndexNo   := TableKeyPath;
        idTableKeyString := TableKeyRef;

        // Add Labels in FormsTK will load the Trans and Line and run through the Serial
        // Number items adding them into the PrintJob
        AddLabels;
      End; { With FPrintToolkitI.PrintJob.ImportDefaults }
    End; { With oPrintJob }

    // Return reference to interface - object will be automatically destroyed when
    // user reference to it is lost
    Result := oPrintJob;
  End { If (FIntfType In [imGeneral, imClone]) }
  Else
    Raise EInvalidMethod.Create ('The Print method is not available in this object')
end; { Print }

function TTransLineSerialBatch.AddToBatch(const Batch: ISerialBatchDetails;
  Qty: Double): Integer;
Var
  SaveInfo : TBtrieveSavePosType;
  oBatch : ISerialBatch;
  TKSerial : TBatchSerialRec;
  BatchString : WideString;
begin
  If (Not (FIntfType In [imAdd, imUpdate])) Then Begin
    // Check we are using Serial Numbers
    If FUsesSerial Then Begin
      // Check Transaction Type
      If (FTHType In ([ADJ, SCR, SRF, SJC] + PurchSplit - RecieptSet - BatchSet)) Then Begin
        // Do some basic checks before continuing
        With Batch Do Begin
          // Must be a Batch record, but not a Batch Child
          If (snType = snTypeBatch) Then Begin

             // Save current file positions in main files
             SaveInfo := SaveSystemFilePos ([]);

             with Batch as IToolkitRecord do
               BatchString := GetData;

             Move(BatchString[1], TKSerial, SizeOf(TKSerial));

             with TKSerial do
             begin
               //Update qty
               BuyQty := BuyQty + Qty;

               //Set transaction and line to update
               LatestInDoc := (FParentTrans As TTransaction).TH.OurRef;
               LatestBuyLine := (FParentLine As TTransactionLine).TL.AbsLineNo;

               //Get position
               (Batch as IBtrieveFunctions).SavePosition;
               RecPos := (Batch as IBtrieveFunctions).Position;

               //Restore position in main file
               if RecPos <> 0 then
               begin
                 SetDataRecOfs(MiscF, RecPos);
                 Status := GetDirect(F[MiscF],MiscF,RecPtr[MiscF]^,0,0);
               end;
             end;

             Result := Ex_StoreSerialBatch (@TkSerial, SizeOf(TkSerial), B_Update);

            // Restore original file positions
            RestoreSystemFilePos (SaveInfo);
          End { If (snType In [snTypeSerial, snTypeBatch]) And (Not snSold) }
          Else
            Raise EValidation.Create ('This Batch object cannot be ' + QuotedStr('added to') + '.');
        End; { With Batch }
      End { If (FTHType In ([ADJ] + SalesSplit)) }
      Else
        Raise EInvalidMethod.Create ('This Transaction Type cannot be used to add stock to batches');
    End { If FUsesSerial }
    Else
      Raise EInvalidMethod.Create ('This Transaction Line does not use Serial Numbers');
  End { If (Not (FIntfType In [imAdd, imUpdate])) }
  Else
    Raise EInvalidMethod.Create ('The UseSerialBatch method cannot be used whilst a Transacton is being Added or Edited');
end;

procedure TTransLineSerialBatch.CopyDataRecord;
begin
  //Do nothing - avoid warnings
end;

function TTransLineSerialBatch.GetDataRecord(const BtrOp: SmallInt;
  const SearchKey: String): Integer;
begin
  //Do nothing - avoid warnings
  Result := 0;
end;

end.
