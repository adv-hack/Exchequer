unit ObjUnallocateF;

interface

{$I DEFOVR.INC}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls, SBSPanel, VirtualTrees, StrUtils, Printers,
  GlobVar, VarConst, VarRec2U, BTSupU1, ExWrap1U, ImgList, Menus, Tranl1U;

Type
  TObjUnallocateFormType = (oufMatching, oufUnallocate);

  TNodeDataType = (ndtTransaction, ndtMatching);

  pNodeDataRecType = Record
    ndType : TNodeDataType;

    ndOurRef      : String[10];
    ndCurrency    : Byte;
    ndSettled     : Double;
    ndCurrSettled : Double;
    ndRevalued    : Boolean;

    // MH 16/11/2011 v6.9 ABSEXCH-11947: Added Date and YourRef columns
    ndTransDate   : LongDate;
    ndYourRef     : String[20];

    ndKeyPath     : SmallInt;

    // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
    ndOrderPaymentElement : enumOrderPaymentElement;  // The type of transaction in Order Payments subsystem, e.g. Order Payment
  End; // pNodeDataRecType

  pNodeDataRec = ^pNodeDataRecType;

  //------------------------------

  TFrmObjectUnallocate = class(TForm)
    vstMatching: TVirtualStringTree;
    btnClose: TButton;
    btnUnallocate: TButton;
    panTotals: TSBSPanel;
    Label83: Label8;
    Label81: Label8;
    UnalTotF: TCurrencyEdit;
    DocTotF: TCurrencyEdit;
    btnPrint: TButton;
    panBuildProgress: TPanel;
    Images: TImageList;
    popTree: TPopupMenu;
    mnuExpand: TMenuItem;
    mnuExpandThisLevel: TMenuItem;
    mnuExpandAllLevels: TMenuItem;
    mnuCollapse: TMenuItem;
    mnuCollapseThisLevel: TMenuItem;
    mnuCollapseEntireTree: TMenuItem;
    N2: TMenuItem;
    mnuViewTrans: TMenuItem;
    N1: TMenuItem;
    mnuRestoreDefaults: TMenuItem;
    mnuSaveCoords: TMenuItem;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure vstMatchingGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: WideString);
    procedure btnUnallocateClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure vstMatchingDblClick(Sender: TObject);
    procedure vstMatchingGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: Integer);
    procedure vstMatchingCollapsed(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure mnuExpandThisLevelClick(Sender: TObject);
    procedure mnuExpandAllLevelsClick(Sender: TObject);
    procedure mnuCollapseThisLevelClick(Sender: TObject);
    procedure mnuCollapseEntireTreeClick(Sender: TObject);
    procedure mnuRestoreDefaultsClick(Sender: TObject);
    procedure mnuViewTransClick(Sender: TObject);
    procedure mnuSaveCoordsClick(Sender: TObject);
  private
    { Private declarations }
    FFormType : TObjUnallocateFormType;

    // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
    MinSizeX : LongInt;
    MinSizeY : LongInt;

    // String list contains the OurRef's of transactions already in the list
    IncludedTransactions : TStringList;

    DoneRestore: Boolean;

    // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
    bOrdPayPaymentFound : Boolean;
    bOrdPayPaymentTransaction : InvRec;

    RootNode : PVirtualNode;

    // Transaction drill-down form
    DispTrans : TFInvDisplay;

    // Debt/Credit total of matching build when the tree is loaded
    UTotals : DrCrType;

    // Indicates that the process to build the tree is still running
    BuildingTree : Boolean;

    ExLocal : TdExLocal;

    // Original transaction
    MatchDoc : InvRec;

    // Returns true if the specified transaction has already been loaded, if it hasn't
    // the transaction is added into the internal string list so future checks pick it up
    function AlreadyLoaded (TransRef : ShortString) : Boolean;
    procedure LoadMatching (ParentNode : PVirtualNode; Const Level : SmallInt; Const OurRefHistory : ANSIString);
    procedure OutTotals;
    procedure SetColoursAndPositions(const Mode: Byte);
    procedure SetTransNodeData (NodeData : pNodeDataRec; Const Transaction : InvRec);
    procedure SetMatchingNodeData (      NodeData : pNodeDataRec;
                                   Const TransRef : ShortString;
                                   Const KeyPath  : SmallInt;
                                   Const TransactionExists : Boolean;
                                   Const Transaction : InvRec;
                                   Const Matching : MatchPayType);
    Procedure UnallocateAll;
    procedure UpdateTotals (NodeData : pNodeDataRec);
    procedure ViewTransaction (Const ViewGroupTrans : Boolean);
    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;
    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;
  public
    { Public declarations }
    // MH 08/03/2012 v6.10 ABSEXCH-12219: Added FormType param so we can distinguish between usages
    constructor Create(AOwner: TComponent; Const FormType : TObjUnallocateFormType); ReIntroduce;

    // CJS 18/03/2011 - ABSEXCH-9646
    procedure LoadTree(ForceReset: Boolean);
  end;

implementation

{$R *.dfm}

Uses BtrvU2, BTKeys1U, CurrncyU, SalTxl1U, SavePos, LedgSupU, ETMiscU, Comnu2, PWarnU,
     uSettings, ComnUnit, GenWarnU, ETStrU, ETDateU, JChkUseU, ObjUnallocateReport
     //PR: 13/02/2013 ABSEXCH-13752  v7.0.2
    {$IFDEF CU}
    ,Event1U
    {$ENDIF}

    // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
    {$IFDEF SOP}
    ,PasswordAuthorisationF
    {$ENDIF}
    ;

//=========================================================================

procedure TFrmObjectUnallocate.FormCreate(Sender: TObject);
begin
  // Do not use - use overridden constructor below instead
end;

//------------------------------

// MH 08/03/2012 v6.10 ABSEXCH-12219: Added FormType param so we can distinguish between usages
constructor TFrmObjectUnallocate.Create(AOwner: TComponent; Const FormType : TObjUnallocateFormType);
begin
  inherited Create(AOwner);

  ClientHeight:=322;
  ClientWidth:=525;

  // Minimum form sizes to be set in the WM_GetMinMaxInfo message handler
  MinSizeX := Width;
  MinSizeY := Height;

  RootNode := NIL;
  vstMatching.NodeDataSize := SizeOf(pNodeDataRecType);

  // Init Debit/Credit totals
  FillChar(UTotals,SizeOf(UTotals),0);

  // Create local DB interface and copy in transaction details
  ExLocal.Create;
  ExLocal.AssignFromGlobal(InvF);
  MatchDoc := ExLocal.LInv;

  // Setup cache for ourrefs already processed
  IncludedTransactions := TStringList.Create;
  IncludedTransactions.Sorted := True;

  // MH 08/03/2012 v6.10 ABSEXCH-12219: Customise layout for different usages
  FFormType := FormType;
  Case FFormType Of
    oufMatching   : Begin
                      btnUnallocate.Visible := False;
                      Caption := 'Financial Matching - ' + ExLocal.LInv.OurRef;
                      panTotals.Visible := False;
                    End; // oufMatching
    oufUnallocate : Begin
                      Caption := 'Block Unallocate - ' + ExLocal.LInv.OurRef;
                    End; // oufUnallocate
  Else
    Raise Exception.Create ('TFrmObjectUnallocate.Create: Unsupported FormType (' + IntToStr(Ord(FFormType)) + ')');
  End; // Case FormType

  BuildingTree := False;
  DispTrans := NIL;

  // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
  bOrdPayPaymentFound := False;
  FillChar(bOrdPayPaymentTransaction, SizeOf(bOrdPayPaymentTransaction), #0);

  // Load colours/positions/sizes/etc...
  DoneRestore := False;
  SetColoursAndPositions (0);

  FormReSize(Self);
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.FormActivate(Sender: TObject);
begin
  LoadTree(False);
end;

//-------------------------------------------------------------------------

Procedure TFrmObjectUnallocate.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);
Begin // WMGetMinMaxInfo
  With Message.MinMaxInfo^ Do
  Begin
    ptMinTrackSize.X:=MinSizeX;
    ptMinTrackSize.Y:=MinSizeY;
  End; // With Message.MinMaxInfo^

  Message.Result:=0;

  Inherited;
End; // WMGetMinMaxInfo

//------------------------------

procedure TFrmObjectUnallocate.FormResize(Sender: TObject);
Const
  MagicNumber = 5;
begin
  panBuildProgress.Top := Trunc(ClientHeight * 0.33);
  panBuildProgress.Left := 30;
  panBuildProgress.Width := ClientWidth - (2 * panBuildProgress.Left);

  // Buttons
  btnClose.Top := ClientHeight - MagicNumber - btnClose.Height;
  btnClose.Left := ClientWidth - MagicNumber - btnClose.Width;

  btnPrint.Top := btnClose.Top;
  btnPrint.Left := btnClose.Left - MagicNumber - btnPrint.Width;

  btnUnallocate.Top := btnClose.Top;
  btnUnallocate.Left := btnPrint.Left - MagicNumber - btnUnallocate.Width;

  // Totals
  panTotals.Left := MagicNumber;
  If (btnUnallocate.Left > (panTotals.Left + panTotals.Width + MagicNumber)) Then
    panTotals.Top := ClientHeight - MagicNumber - panTotals.Height
  Else
    panTotals.Top := btnClose.Top - MagicNumber - panTotals.Height;

  // Tree
  vstMatching.Top := MagicNumber;
  vstMatching.Left := MagicNumber;
  vstMatching.Width := ClientWidth - (2 * vstMatching.Left);

  // MH 08/03/2012 v6.10 ABSEXCH-12219: Customise layout for different usages
  If (FFormType = oufMatching) Then
    // Matching - Totals panel is hidden so shuffle the tree down to cover the extra gap to the buttons
    vstMatching.Height := btnClose.Top - MagicNumber - vstMatching.Top
  Else
    vstMatching.Height := panTotals.Top - MagicNumber - vstMatching.Top;
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=Not BuildingTree;

  //GenCanClose(Self,Sender,CanClose,BOn);

  If (CanClose) then
  Begin
    // Save colours/positions/sizes/etc...
    SetColoursAndPositions (1);

    //Send_UpdateList(179);
    // CJS 18/03/2011 - ABSEXCH-9646
    if (FFormType = oufMatching) then
      SendMessage((Owner as TForm).Handle, WM_CustGetRec, 180, 0)
    else
      SendMessage((Owner as TForm).Handle, WM_CustGetRec, 179, 0);
  end;
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNIL(IncludedTransactions);

  ExLocal.Destroy;

  Action:=caFree;
end;

//-------------------------------------------------------------------------

Procedure TFrmObjectUnallocate.WMCustGetRec(Var Message  :  TMessage);
Begin // WMCustGetRec
  Case Message.WParam Of
    200 : DispTrans := NIL;
  End; // Case WParam

  Inherited;
End; // WMCustGetRec

//-------------------------------------------------------------------------

// Returns true if the specified transaction has already been loaded, if it hasn't
// the transaction is added into the internal string list so future checks pick it up
function TFrmObjectUnallocate.AlreadyLoaded (TransRef : ShortString) : Boolean;
Begin // AlreadyLoaded
  TransRef := FullOurRefKey(TransRef);
  Result := (IncludedTransactions.IndexOf(TransRef) <> -1);
  If (Not Result) Then
  Begin
    IncludedTransactions.Add(TransRef);

    // MH 08/03/2012 v6.10 ABSEXCH-12219: Modified progress panel to display at the start - previously only displayed on the 10th record (bug?)
    If ((IncludedTransactions.Count Mod 10) = 1) Then
    Begin
      If (Not panBuildProgress.Visible) Then
        panBuildProgress.Visible := True;
      panBuildProgress.Caption := 'Scanning ' + TransRef;
      panBuildProgress.Refresh;
    End; // If ((IncludedTransactions.Strings.Count Mod 10) = 1)
  End; // If (Not Result)
End; // AlreadyLoaded

//------------------------------

// CJS 18/03/2011 - ABSEXCH-9646
procedure TFrmObjectUnallocate.LoadTree(ForceReset: Boolean);
Var
  pNodeData : pNodeDataRec;
begin
  if ForceReset then
  begin
    RootNode := nil;
    vstMatching.Clear;
    IncludedTransactions.Clear;
    ExLocal.AssignFromGlobal(InvF);
    MatchDoc := ExLocal.LInv;
    FillChar(UTotals,SizeOf(UTotals),0);
    Caption := 'Financial Matching - ' + ExLocal.LInv.OurRef;
  end;
  // Check to see if tree needs to be loaded
  If (Not Assigned(RootNode)) Then
  Begin
    Try
      Refresh;

      BuildingTree := True;
      btnUnallocate.Enabled := False;
      btnPrint.Enabled := False;
      btnClose.Enabled := False;

      If (ExLocal.LInv.InvDocHed In SalesSplit+PurchSplit-QuotesSet-OrderSet-BatchSet) Then
      Begin
        // Create root item for selected transaction
        RootNode := vstMatching.AddChild(nil);
        pNodeData := vstMatching.GetNodeData(RootNode);
        SetTransNodeData(pNodeData, ExLocal.LInv);

        // Log transaction as being loaded
        AlreadyLoaded(ExLocal.LInv.OurRef);

        // Load matching and related transactions
        LoadMatching (RootNode, 0, ExLocal.LInv.OurRef);

        // MH 07/03/2012 v6.10 ABSEXCH-12219: Hide detail of matching beyond first level by only opening the node for the initial transaction
        If (FFormType = oufMatching) Then
        Begin
          vstMatching.Expanded[vstMatching.RootNode.FirstChild] := True;
        End // If (FFormType = oufMatching)
        Else
        Begin
          // Display totals and all matching information
          vstMatching.FullExpand(RootNode);
          OutTotals;
        End; // Else
      End; // If (ExLocal.LInv.InvDocHed In SalesSplit+PurchSplit-QuotesSet-OrderSet-BatchSet)
    Finally
      // Unallocate button only available if the matching balances or the user is logged in with the Daily password
      panBuildProgress.Visible := False;
      btnUnallocate.Enabled := (Round_Up (UTotals[BOff] - UTotals[BOn],2) = 0.0) Or SBSIn;
      btnPrint.Enabled := True;
      btnClose.Enabled := True;
      BuildingTree := False;
    End; // Try..Finally
  End; // If (Not Assigned(RootNode))
end;

//------------------------------

// Loads in the matching details for the transaction currently in ExLocal.LInv
// MH 08/03/2012 v6.10 ABSEXCH-12219: Added the OurRefHistory so that the Matching Tree version can identify whether
// the transaction is loaded within the current branch of the tree
procedure TFrmObjectUnallocate.LoadMatching (ParentNode : PVirtualNode; Const Level : SmallInt; Const OurRefHistory : ANSIString);
Var
  MatchingNode : PVirtualNode;
  pNodeData : pNodeDataRec;
  TmpInv : ^InvRec;
  AddCredit, TransExists : Boolean;
  iStatus, KeyPath : SmallInt;
  KeyS, KeyChk : Str255;
  sOurRef : String[10];
Begin // LoadMatching
//If (Level < 190) Then
  With TBtrieveSavePosition.Create Do
  Begin
    Try
      // Save the current position in the file for the current key
      SaveFilePosition (PwrdF, GetPosKey);
      SaveDataBlock (@Password, SizeOf(Password));

      //------------------------------

      GetMem(TmpInv, SizeOf(TmpInv^));
      TmpInv^ := ExLocal.LInv;

      AddCredit := BOff;
      Repeat
        If ((ExLocal.LInv.RemitNo<>'') or (ExLocal.LInv.OrdMatch) or (ExLocal.LInv.InvDocHed=ADJ)) and (Not AddCredit) then
          Keypath := PWK
        else
          Keypath := HelpNDXK;

        KeyChk:=FullMatchKey(MatchTCode,MatchSCode,ExLocal.LInv.OurRef);
        KeyS:=KeyChk;

        iStatus := Find_Rec(B_GetGEq,F[PwrdF],PwrdF,RecPtr[PwrdF]^,KeyPath,KeyS);
        While (iStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff)) Do
        Begin
          sOurRef := IfThen(KeyPath = HelpNdxK, Password.MatchPayRec.DocCode, Password.MatchPayRec.PayRef);

          // Check we haven't already loaded the details for this transaction - due to the joys of
          // partial matching it may have been loaded already for a different transaction and loading
          // it again is liable to cause infinite loops
          If (GetDocType(Copy(sOurRef,1,3)) In SalesSplit+PurchSplit-OrderSet-QuotesSet-BatchSet) And
             (
               // MH 08/03/2012 v6.10 ABSEXCH-12219: For Matching Tree we filter later when deciding whether to load
               // the subitems
               // MH 18/01/2013 v7.1 ABSEXCH-13238: Reinstated check on whether items are already shown to avoid
               //                                   duplicate transactions showing against SCR's
               ((FFormType = oufMatching) And (Not AlreadyLoaded(sOurRef)))
               Or
               // For Block Unallocate we can only load the transaction is is isn't already present in the tree,
               // otherwise it may try to unallocate it multiple times
               ((FFormType = oufUnallocate) And (Not AlreadyLoaded(sOurRef)))
             ) Then
          Begin
            // Check the Transaction exists
            TransExists := CheckRecExsists(sOurRef, InvF, InvOurRefK);

            // Create root item for selected transaction
            MatchingNode := vstMatching.AddChild(ParentNode);
            pNodeData := vstMatching.GetNodeData(MatchingNode);
            SetMatchingNodeData(pNodeData, sOurRef, KeyPath, TransExists, Inv, Password.MatchPayRec);

            // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
            If (Not bOrdPayPaymentFound) And (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
            Begin
              bOrdPayPaymentFound := True;
              bOrdPayPaymentTransaction := Inv;
            End; // If (Not bOrdPayPaymentFound) And (Inv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet)

            If TransExists Then
            Begin
              // Load matching for the matched transaction
              ExLocal.AssignFromGlobal(InvF);

              // MH 08/03/2012 v6.10 ABSEXCH-12219: For Matching Tree only load the matching against the transaction if it isn't already present in the current branch
              // MH 18/01/2013 v7.1 ABSEXCH-13354: Suppress Matching beyond the first level due to
              //                                   crashes and apparent hangs due to the complexity
              //                                   of the matching being loaded causing it to run out
              //                                   of resources or the user decides its hung
              If {((FFormType = oufMatching) And (Pos(sOurRef, OurRefHistory) = 0)) Or} (FFormType = oufUnallocate) Then
                LoadMatching (MatchingNode, Level + 1, OurRefHistory + '/' + sOurRef);
            End; // If TransExists
          End; // If (GetDocType(Copy(sOurRef,1,3)) ...

          iStatus := Find_Rec(B_GetNext,F[PwrdF],PwrdF,RecPtr[PwrdF]^,KeyPath,KeyS);
        End; // While (iStatus = 0) And (CheckKey(KeyChk, KeyS, Length(KeyChk), BOff))

        // Restore original transaction for 2nd pass
        ExLocal.LInv := TmpInv^;

        AddCredit := Not AddCredit; {Have a look at the other index in case it is a negative credit allocation}
      Until (Not AddCredit) or ((Not (ExLocal.LInv.InvDocHed In CreditSet)) and (RightSignDoc(ExLocal.LInv)));

      //------------------------------

      FreeMem(TmpInv);

      // Restore position in file
      RestoreSavedPosition;
      RestoreDataBlock (@Password);
    Finally
      Free;
    End; // Try..Finally
  End; // With TBtrieveSavePosition.Create
End; // LoadMatching

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.UpdateTotals (NodeData : pNodeDataRec);
Var
  CrDr : DrCrType;
Begin // UpdateTotals
  If (Not NodeData^.ndRevalued) Then
  Begin
    ShowDrCr(NodeData^.ndSettled, CrDr);
    UTotals[BOff] := UTotals[BOff] + CrDr[BOff];
    UTotals[BOn] := UTotals[BOn] + CrDr[BOn];
  End; // If (Not NodeData^.ndRevalued)
End; // UpdateTotals

//------------------------------

procedure TFrmObjectUnallocate.SetTransNodeData (NodeData : pNodeDataRec; Const Transaction : InvRec);
Begin // SetTransNodeData
  FillChar(NodeData^, SizeOf(NodeData^), #0);
  With NodeData^ Do
  Begin
    ndType := ndtTransaction;

    ndOurRef := Trim(Transaction.OurRef);
    ndCurrency := Transaction.Currency;
    ndSettled := Transaction.Settled;
    ndCurrSettled := Transaction.CurrSettled;
    ndRevalued := ReValued(Transaction);

    // MH 16/11/2011 v6.9 ABSEXCH-11947: Added Date and YourRef columns
    ndTransDate := Transaction.TransDate;
    ndYourRef := Trim(Transaction.YourRef);

    // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
    ndOrderPaymentElement := Transaction.thOrderPaymentElement;
  End; // With NodeData^

  UpdateTotals (NodeData);
End; // SetTransNodeData

//------------------------------

// MH 08/03/2012 v6.10 ABSEXCH-12219: Added Matching details parameter so the matched value can be shown for the Matching variant
procedure TFrmObjectUnallocate.SetMatchingNodeData (      NodeData : pNodeDataRec;
                                                    Const TransRef : ShortString;
                                                    Const KeyPath  : SmallInt;
                                                    Const TransactionExists : Boolean;
                                                    Const Transaction : InvRec;
                                                    Const Matching : MatchPayType);
Begin // SetMatchingNodeData
  FillChar(NodeData^, SizeOf(NodeData^), #0);
  With NodeData^ Do
  Begin
    ndType := ndtMatching;

    ndKeyPath := KeyPath;
    ndOurRef := Trim(TransRef);

    // MH 08/03/2012 v6.10 ABSEXCH-12219: Show the matched value for the Matching variant instead of the total settled
    // which will include any other invoices/receipts the current transaction is matched against
    If (FFormType = oufMatching) Then
    Begin
      // Matching Information
      ndSettled := Matching.SettledVal;
      ndCurrSettled := Matching.OwnCVal;
    End // If (FFormType = oufMatching)
    Else
    Begin
      // Block Unnallocate
      // MH 25/06/2015 v7.0.14 ABSEXCH-12679: Show blank for Purged Transactions
      If TransactionExists Then
      Begin
        ndSettled := Transaction.Settled;
        ndCurrSettled := Transaction.CurrSettled;
      End // If TransactionExists
      Else
      Begin
        ndSettled := 0.0;
        ndCurrSettled := 0.0;
      End; // Else

      UpdateTotals (NodeData);
    End; // If (FFormType = oufMatching)

    // MH 18/01/2013 v7.1 ABSEXCH-12679: Modified handling for Purged Transactions
    If TransactionExists Then
    Begin
      ndCurrency := Transaction.Currency;

      ndRevalued := ReValued(Transaction);

      // MH 16/11/2011 v6.9 ABSEXCH-11947: Added Date and YourRef columns
      ndTransDate := Transaction.TransDate;
      ndYourRef := Trim(Transaction.YourRef);

      // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
      ndOrderPaymentElement := Transaction.thOrderPaymentElement;
    End // If TransactionExists
    Else
    Begin
      // Transaction Doesn't exist - derive currency from Matching
      If (Trim(TransRef) = Trim(Matching.DocCode)) Then
        ndCurrency := Matching.MCurrency
      Else
        ndCurrency := Matching.RCurrency;

      ndYourRef := '[PURGED] ' + Trim(Transaction.YourRef);
    End; // Else
  End; // With NodeData^
End; // SetMatchingNodeData

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.OutTotals;
Begin // OutTotals
  {$IFDEF MC_On}
    DocTotF.CurrencySymb  := SSymb(0);
    UnAlTotF.CurrencySymb := DocTotF.CurrencySymb;
  {$ENDIF}

  DocTotF.Value := UTotals[BOff];
  UnAlTotF.Value := UTotals[BOn];
End; // OutTotals

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.vstMatchingGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: WideString);
var
  pNodeData : pNodeDataRec;
begin
  pNodeData := vstMatching.GetNodeData(Node);
  If Assigned(pNodeData) Then
  Begin
    Case pNodeData^.ndType Of
      ndtTransaction : Begin
                         // MH 16/11/2011 v6.9 ABSEXCH-11947: Added Date and YourRef columns
                         Case Column Of
                           0 : CellText := pNodeData^.ndOurRef;
                           1 : Begin
                                 CellText := FormatCurFloat(GenRealMask, pNodeData^.ndSettled, BOff, 0);
                                 {$IFDEF MC_On}
                                   If (pNodeData^.ndCurrency > 1) then
                                     CellText := CellText + ' / ' + FormatCurFloat(GenRealMask, pNodeData^.ndCurrSettled, BOff, pNodeData^.ndCurrency);

                                   If pNodeData^.ndRevalued then
                                     CellText := CellText + '. Revalued!';
                                 {$ENDIF}
                               End;
                           2 : CellText := pNodeData^.ndYourRef;
                           3 : CellText := POutDateB(pNodeData^.ndTransDate);
                         End; // Case Column

                         (*
                         CellText := pNodeData^.ndOurRef + '. ' + FormatCurFloat(GenRealMask, pNodeData^.ndSettled, BOff, 0);

                         {$IFDEF MC_On}
                           If (pNodeData^.ndCurrency > 1) then
                             CellText := CellText + ' / ' + FormatCurFloat(GenRealMask, pNodeData^.ndCurrSettled, BOff, pNodeData^.ndCurrency);

                           If pNodeData^.ndRevalued then
                             CellText := CellText + '. Revalued!';
                         {$ENDIF}
                         *)
                       End; // ndtTransaction

      ndtMatching    : Begin
                         // MH 16/11/2011 v6.9 ABSEXCH-11947: Added Date and YourRef columns
                         Case Column Of
                           0 : CellText := pNodeData^.ndOurRef;
                           1 : Begin
                                 // MH 25/06/2015 v7.0.14 ABSEXCH-12679: Show blank for Purged Transactions
                                 If (pNodeData^.ndSettled <> 0.0) Or (pNodeData^.ndCurrSettled <> 0.0) Then
                                 Begin
                                   CellText := FormatCurFloat(GenRealMask, pNodeData^.ndSettled, BOff, 0);
                                   {$IFDEF MC_On}
                                     If (pNodeData^.ndCurrency > 1) then
                                       CellText := CellText + ' / ' + FormatCurFloat(GenRealMask, pNodeData^.ndCurrSettled, BOff, pNodeData^.ndCurrency);

                                     If pNodeData^.ndRevalued then
                                       CellText := CellText + '. Revalued!';
                                   {$ENDIF}
                                 End // If (pNodeData^.ndSettled <> 0.0) Or (pNodeData^.ndCurrSettled <> 0.0) 
                                 Else
                                   CellText := '';
                               End;
                           2 : CellText := pNodeData^.ndYourRef;
                           3 : CellText := POutDateB(pNodeData^.ndTransDate);
                         End; // Case Column

                         (*
                         CellText := pNodeData^.ndOurRef + '. ' + FormatCurFloat(GenRealMask, pNodeData^.ndSettled, BOff, 0);

                         {$IFDEF MC_On}
                           If (pNodeData^.ndCurrency > 1) then
                             CellText := CellText + ' / ' + FormatCurFloat(GenRealMask, pNodeData^.ndCurrSettled, BOff, pNodeData^.ndCurrency);

                           If pNodeData^.ndRevalued then
                             CellText := CellText + '. Revalued!';
                         {$ENDIF}
                         *)
                       End; // ndtMatching
    Else
      CellText := 'Unhandled Type';
    End; // Case pNodeData^.ndType
  End // If Assigned(pNodeData)
  Else
    CellText := 'Missing Data';
end;

//------------------------------

procedure TFrmObjectUnallocate.vstMatchingCollapsed(
  Sender: TBaseVirtualTree; Node: PVirtualNode);
{ If the user collapses a node, make sure that the node becomes selected
  (otherwise it is possible to leave the selection on a hidden node) }
begin
  vstMatching.FocusedNode := Node;
  vstMatching.Selected[Node] := True;
end;

//------------------------------

procedure TFrmObjectUnallocate.ViewTransaction (Const ViewGroupTrans : Boolean);
var
  Node   : PVirtualNode;
  pNodeData : pNodeDataRec;
  iStatus : SmallInt;
  KeyS : Str255;
Begin // ViewTransaction
  Node := vstMatching.FocusedNode;
  If (Node <> nil) Then
  begin
    If (Node.ChildCount = 0) Or ViewGroupTrans Then
    Begin
      pNodeData := vstMatching.GetNodeData(Node);

      KeyS := FullOurRefKey (pNodeData.ndOurRef);
      iStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyS);
      If (iStatus = 0) Then
      Begin
        If (Allowed_In(Inv.InvDocHed In (SalesSplit-OrderSet),03)) or
           (Allowed_In(Inv.InvDocHed In (PurchSplit-OrderSet),12)) then
        Begin
          ExLocal.LastInv:=ExLocal.LInv;
          ExLocal.AssignFromGlobal(InvF);
          Try
            If (DispTrans=nil) then
              DispTrans:=TFInvDisplay.Create(Self);

            try
              With ExLocal,DispTrans do
              Begin
                LastDocHed:=LInv.InvDocHed;

                Display_Trans(99,0,BOff,BOn);
              end; {with..}
            except
              DispTrans.Free;
            end;
          Finally
            ExLocal.LInv:=ExLocal.LastInv;
          End; // Try..Finally
        End; // If (Allowed_In(...
      End; // If (iStatus = 0)
    End; // If (Node.ChildCount = 0)
  End; // If (Node <> nil)
End; // ViewTransaction

procedure TFrmObjectUnallocate.mnuViewTransClick(Sender: TObject);
begin
  ViewTransaction(True);
end;

procedure TFrmObjectUnallocate.vstMatchingDblClick(Sender: TObject);
begin
  ViewTransaction(False);
end;

//------------------------------

procedure TFrmObjectUnallocate.vstMatchingGetImageIndex(
  Sender: TBaseVirtualTree; Node: PVirtualNode; Kind: TVTImageKind;
  Column: TColumnIndex; var Ghosted: Boolean; var ImageIndex: Integer);
var
  pNodeData : pNodeDataRec;
begin
  If (Column = 0) Then
  Begin
    If (Node.ChildCount > 0) Then
      ImageIndex := 0   // Folder
    Else
    Begin
      pNodeData := vstMatching.GetNodeData(Node);
      If Assigned(pNodeData) Then
      Begin
        // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
        If (pNodeData^.ndOrderPaymentElement In OrderPayment_PaymentAndRefundSet) Then
          ImageIndex := 2   // Padlocked Document
        Else
          ImageIndex := 1;   // Document
      End // If Assigned(pNodeData); // If Assigned(pNodeData)
      Else
        ImageIndex := 1;   // Document
    End; // Else
  End; // If (Column = 0)
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.mnuExpandThisLevelClick(Sender: TObject);
begin
  If vstMatching.FocusedNode.ChildCount = 0 Then
    vstMatching.FullExpand(vstMatching.FocusedNode.Parent)
  Else
    vstMatching.FullExpand(vstMatching.FocusedNode);
end;

//------------------------------

procedure TFrmObjectUnallocate.mnuExpandAllLevelsClick(Sender: TObject);
begin
  vstMatching.FullExpand(RootNode);
end;

//------------------------------

procedure TFrmObjectUnallocate.mnuCollapseThisLevelClick(Sender: TObject);
begin
  If vstMatching.FocusedNode.ChildCount = 0 Then
    vstMatching.FullCollapse(vstMatching.FocusedNode.Parent)
  Else
    vstMatching.FullCollapse(vstMatching.FocusedNode);
end;

//------------------------------

procedure TFrmObjectUnallocate.mnuCollapseEntireTreeClick(Sender: TObject);
begin
  vstMatching.FullCollapse(RootNode);
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.SetColoursAndPositions(const Mode: Byte);
// Controls the loading/saving of the colours and positions
//
// Mode   0=Load Details, 1=Save Details, 2=Delete Details
var
  WantAutoSave: Boolean;
begin
  case Mode of
    0 : begin  // Create
          oSettings.LoadForm(self, WantAutoSave);
           {HV 11/03/2016 2016-R2 ABSEXCH-13588: Provided support
            to VirtualStringTree for saving co-ordinates. }
          oSettings.LoadList(vstMatching, Self.Name);
//          mnuSaveCoords.Checked := WantAutoSave;
        end;
    1 : if (not DoneRestore) Then
        begin  // Destroy
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm(self, mnuSaveCoords.Checked);
          {HV 11/03/2016 2016-R2 ABSEXCH-13588: Provided support
           to VirtualStringTree for saving co-ordinates. }
          if mnuSaveCoords.Checked then
            oSettings.SaveList(vstMatching, Self.Name);
        end;
    2 : begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults(self.Name);
           {HV 11/03/2016 2016-R2 ABSEXCH-13588: Provided support
            to VirtualStringTree for saving co-ordinates.}
          oSettings.RestoreListDefaults(vstMatching, Self.Name);
          mnuSaveCoords.Checked := False;
          PostMessage (Self.Handle, WM_CLOSE, 0, 0);
        end;
  else
    raise Exception.Create ('TFrmObjectUnallocate.SetColoursAndPositions - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  end;
end;

//------------------------------

procedure TFrmObjectUnallocate.mnuRestoreDefaultsClick(Sender: TObject);
begin
  SetColoursAndPositions (2);
end;

//------------------------------

procedure TFrmObjectUnallocate.mnuSaveCoordsClick(Sender: TObject);
begin
  // Have to do manually - using auto-check caused the menu item to disappear
  mnuSaveCoords.Checked := Not mnuSaveCoords.Checked;
end;

//-------------------------------------------------------------------------

Procedure TFrmObjectUnallocate.UnallocateAll;
Var
  RefreshList : Boolean;
  LastCursor  : TCursor;

  //------------------------------

  Procedure ProcessItem (TheNode : PVirtualNode);
  Var
    pNodeData : pNodeDataRec;
    KeyS : Str255;
    LStatus : SmallInt;
    LOk, Locked : Boolean;
  Begin // ProcessItem
    pNodeData := vstMatching.GetNodeData(TheNode);

    With ExLocal Do
    Begin
      // Get and lock the transaction
      KeyS := pNodeData.ndOurRef;
      LStatus := Find_Rec(B_GetEq, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, KeyS);
      If (LStatus=0) Then
      Begin
        LGetRecAddr(InvF);
        LOk := LGetMultiRec(B_GetDirect, B_MultLock, KeyS, InvOurRefK, InvF, BOn, Locked);
        If LOk And Locked Then
        Begin
          LInv.Settled:=0.0;
          LInv.CurrSettled:=0.0;

          Set_DocAlcStat(LInv);  {* Set Allocation Status *}

          If VAT_CashAcc(SyssVAT.VATRates.VATScheme) Then  {* Cash Accounting set Blank VATdate & Until Date *}
          Begin
            If (LInv.SettledVAT = 0) Then
            Begin
              Blank(LInv.VATPostDate,Sizeof(LInv.VATPostDate));
              LInv.UntilDate := NdxWeight;
              {Blank(UntilDate,Sizeof(UntilDate));}
            End // If (LInv.SettledVAT = 0)
            Else
            Begin
              LInv.VATPostDate := SyssVAT.VATRates.CurrPeriod;
              LInv.UntilDate := Today;
            End; // Else
          End // If VAT_CashAcc(SyssVAT.VATRates.VATScheme)
          Else
            {Blank(UntilDate,Sizeof(UntilDate));}
            LInv.UntilDate := NdxWeight;

          {$IFDEF JC}
            Set_DocCISDate(LInv,BOn);
          {$ENDIF}

          If (Not ReValued(LInv)) and (Not UseCoDayRate) then
            LInv.CXRate[BOff]:=0.0;

          LStatus := Put_Rec(F[InvF],InvF,LRecptr[InvF]^,InvOurRefK);
          Report_BError(InvF,LStatus);
          UnLockMLock(InvF,LastRecAddr[InvF]);

          if Remove_MatchPay(LInv.OurRef,DocMatchTyp[BOff],MatchSCode,BOff) then
          begin
            //PR: 13/02/2013 ABSEXCH-13752 v7.0.2
            {$IFDEF CU}
            // Load account record into ExLocal
            ExLocal.AssignFromGlobal(CustF);

            // Trigger hook point - 163 for customer unallocate, 164 for supplier unallocate
            //PR: 27/02/2013 Amended to 173 & 174 as 163 & 164 are already in use. D'Oh!
            if LInv.CustSupp = TradeCode[True] then
              GenHooks(2000, 173, ExLocal)
            else
              GenHooks(2000, 174, ExLocal);
            {$ENDIF}
          end;

          {* Remove stray lines created by batch payments *}
          Remove_MatchPay(LInv.OurRef,DocMatchTyp[BOn],MatchSCode,BOn);

          // Set flag to update the customer ledger
          RefreshList := BOn;
        End; // If LOk And Locked
      End; // If (LStatus=0)
    End; // With ExLocal
  End; // ProcessItem

  //------------------------------

  // Routine processes the passed node and then runs through its children recursively
  // calling itself - important to minimise local stack variables in this routine
  Procedure ProcessNode (TheNode : PVirtualNode);
  Var
    ChildNode : PVirtualNode;
  Begin // ProcessNode
    // Process this node and then run through any children of the node
    ProcessItem (TheNode);
    If (TheNode.ChildCount > 0) Then
    Begin
      ChildNode := TheNode.FirstChild;
      Repeat
        ProcessNode (ChildNode);
        ChildNode := ChildNode.NextSibling;
      Until ChildNode = NIL;
    End; // If (TheNode.ChildCount > 0)
  End; // ProcessNode

  //------------------------------

Begin
  LastCursor:=Cursor;
  Cursor:=crHourGlass;
  Try
    RefreshList:=BOff;

    ProcessNode (RootNode);

    If (RefreshList) then
      PostMessage(TForm(Self.Owner).Handle,WM_CustGetRec,121,0);
  Finally
    Cursor:=LastCursor;
  End; // Try..Finally
end;

//------------------------------

procedure TFrmObjectUnallocate.btnUnallocateClick(Sender: TObject);
Var
  mbRet  :  Word;
begin
  If (Round_Up(UTotals[BOff] - UTotals[BOn],2) = 0.0) Or (SBSIn) Then
  Begin
    mbRet:=CustomDlg(Self,'ObjectUnallocate','Unallocate all transactions.',
                     'Please confirm you wish to unallocate all the transactions as shown.',
                     mtConfirmation,
                     [mbOK,mbCancel]);

    // MH 12/11/2014 ABSEXCH-15799: Added authorisation requirement for Order Payments' Payments and Refunds
    {$IFDEF SOP}
    If (mbRet = mrOk) And bOrdPayPaymentFound Then
    Begin
      // Need to get Daily Password to authorise the unallocation of the Order Payments Payment/Refunds
      If OrdPay_OKToAllocate(Self, bOrdPayPaymentTransaction, False) Then
        mbRet := mrOK
      Else
        mbRet := mrCancel;
    End; // If (mbRet = mrOk)
    {$ENDIF}

    If (mbRet = mrOk) Then
    Begin
      btnUnallocate.Enabled := False;
      btnPrint.Enabled := False;
      btnClose.Enabled := False;

      UnallocateAll;

      PostMessage(Self.Handle,WM_Close,0,0);
    End; // If (mbRet = mrOk)
  End // If (Round_Up(UTotals[BOff] - UTotals[BOn],2) = 0.0) Or (SBSIn)
  Else
    CustomDlg(Self,'ObjectUnallocate','Transactions do not balance.',
                   'The transactions contained within this matching series do not balance, indicating that the matching information '+
                   'is either missing or incorrect.  Block unallocation is not possible as it would result in an imbalance.'+#13+#13+
                   'Unallocate each transaction manually.',
                   mtWarning, [mbOK]);
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.btnPrintClick(Sender: TObject);
Var
  RepCtrl  :  MLocRec;
begin
  FillChar(RepCtrl,Sizeof(RepCtrl),#0);

  With RepCtrl.AllocCrec do
  Begin
    arcOurRef := MatchDoc.OurRef;
    arcOwnTransValue := UTotals[BOff];
    arcOwnSettleD := UTotals[BOn];

    {$IFDEF RP}
      AddObjectUnallocateRep2Thread(RepCtrl, vstMatching, Self, (FFormType = oufMatching));
    {$ENDIF}
  end;
end;

//-------------------------------------------------------------------------

procedure TFrmObjectUnallocate.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

end.
