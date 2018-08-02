unit DispDocF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  ExWrap1U,      // Btrieve File Wrapper Object
  BTRVU2,
  TranSOPF,      // Standard SOP Transaction Form (SOR/SDN/SIN/SRI/...)
  NomTfrU,       // Copy of entrprse\r&d Nominal Transfer form
  SRCPPYF,       // Copy of entrprse\r&d Recep1U for displaying SRC/PPY receipts
  frmStkAdjU,    // Stock Adjustments Form
  frmTimeSheetU, // Time Sheet Form
  frmWorksOrderU,// Works Order Form
  BTSupU1;       // Custom Messages and Misc Btrieve Routines

type
  TfrmDisplayTransManager = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    // Standard SOR/SDN/SIN/POR/PDN/PIN window
    FInvoice : TfrmSOPTrans;
    // Receipt
    FReceipt : TRecepForm;
    // Nominal Transfer
    FNominal : TNTxfrForm;
    // Stock Adjustment
    FStockAdj : TfrmStkAdj;
    // Batch
    FBatch : TForm;
    // Timesheet
    FTimesheet : TfrmTimeSheet;
    // Works Order
    FWorksOrder : TfrmWorksOrder;

    procedure DisplayNOMTrans(Const TheTrans : InvRec; Const DataChanged : Boolean);
    procedure DisplayPayTrans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
    procedure DisplaySOPTrans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
    procedure DisplaySAdjTrans(const TheTrans: InvRec; const TheCust: CustRec; const DataChanged: Boolean);
    procedure DisplayTimeSheetTrans(const TheTrans: InvRec; const TheCust: CustRec; const DataChanged: Boolean);
    procedure DisplayWorksOrderTrans(const TheTrans: InvRec; const TheCust: CustRec; const DataChanged: Boolean);
    Procedure WMCustGetRec (Var Message : TMessage); Message WM_CustGetRec;
  public
    { Public declarations }
    procedure Display_Trans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
  end;


procedure CustToMemo(CRec    :  CustRec;
                 Var Memo1   :  TMemo;
                     Mode    :  Byte);

implementation

{$R *.dfm}

//=========================================================================

procedure CustToMemo(CRec    :  CustRec;
                 Var Memo1   :  TMemo;
                     Mode    :  Byte);
Var
  n         :  Byte;
  ThisAddr  :  AddrTyp;
Begin
  With CRec,Memo1,Lines do
  Begin
    Text:=Trim(Company);

    Case Mode of
      0  :  ThisAddr:=CRec.Addr;
      1  :  ThisAddr:=CRec.DAddr;
    end; {Case..}

    For n:=1 to High(AddrTyp) do
      If (Trim(ThisAddr[n])<>'') then
        Text:=Text+#13+Trim(ThisAddr[n]);

    If (Contact<>'') then
      Text:=Text+#13+'Contact : '+Trim(Contact);

    If (Phone<>'') then
      Text:=Text+#13+'Tel: '+Trim(Phone);

    If (Phone2<>'') then
      Text:=Text+#13+'Tel: '+Trim(Phone2);

    If (Fax<>'') then
      Text:=Text+#13+'Fax: '+Trim(Fax);
  end; {With..}
end;

//=========================================================================

procedure TfrmDisplayTransManager.FormCreate(Sender: TObject);
begin
  // Initialise all form references
  FInvoice := NIL;
  FReceipt := NIL;
  FNominal := NIL;
  FStockAdj := NIL;
  FBatch := NIL;
  FTimesheet := NIL;
  FWorksOrder := NIL;
end;

//-------------------------

procedure TfrmDisplayTransManager.FormDestroy(Sender: TObject);
begin
  // Destroy any open forms
  If Assigned(FInvoice) Then
    FreeAndNIL(FInvoice);

  If Assigned(FReceipt) Then
    FreeAndNIL(FReceipt);

  If Assigned(FNominal) Then
    FreeAndNIL(FNominal);

  If Assigned(FStockAdj) Then
    FreeAndNIL(FStockAdj);

  If Assigned(FBatch) Then
    FreeAndNIL(FBatch);

  If Assigned(FTimesheet) Then
    FreeAndNIL(FTimesheet);

  If Assigned(FWorksOrder) Then
    FreeAndNIL(FWorksOrder);
end;

//-------------------------------------------------------------------------

Procedure TfrmDisplayTransManager.WMCustGetRec (Var Message : TMessage);
Begin { WMCustGetRec }
  With Message Do
    Case WParam Of
      // Sub-form closed
      100    : Case lParam Of
                 1  : FInvoice   := nil;
                 2  : FNominal   := nil;
                 3  : FReceipt   := nil;
                 4  : FStockAdj  := nil;
                 5  : FTimeSheet := nil;
                 6  : FWorksOrder:= nil;
               End; { Case lParam }
    End; { Case }
End; { WMCustGetRec }

//-------------------------------------------------------------------------

procedure TfrmDisplayTransManager.Display_Trans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
begin { Display_Trans }
  if (TheTrans.InvDocHed In RecieptSet) then
    DisplayPayTrans(TheTrans, TheCust, DataChanged)
  else if (TheTrans.InvDocHed In NomSplit) then
    DisplayNOMTrans(TheTrans, DataChanged)
  else if (TheTrans.InvDocHed In StkAdjSplit) then
    DisplaySAdjTrans(TheTrans, TheCust, DataChanged)
  else if (TheTrans.InvDocHed In BatchSet) then
    //Display_Batch(Mode,CPage,SFocus)
    MessageDlg ('TfrmDisplayTransManager.Display_Trans - Batches (SBT/PBT) are not supported at this time', mtInformation, [mbOk], 0)
  else if (TheTrans.InvDocHed In TSTSplit) then
    DisplayTimeSheetTrans(TheTrans, TheCust, DataChanged)
  else if (TheTrans.InvDocHed In WOPSplit ) then
    DisplayWorksOrderTrans(TheTrans, TheCust, DataChanged)
  else
    DisplaySOPTrans(TheTrans, TheCust, DataChanged);
End; { Display_Trans }

//-------------------------------------------------------------------------

// Handle display of standard transactions - SOR/SDN/SIN/POR/PDN/PIN,etc..
procedure TfrmDisplayTransManager.DisplaySOPTrans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
begin { DisplaySOPTrans }
  // If called because of the selected data being changed then only display
  // if the window is already on display
  If (Not DataChanged) Or Assigned(FInvoice) Then Begin
    // Create SOP Transaction form if necessary
    If Not Assigned(FInvoice) Then
      FInvoice := TfrmSOPTrans.Create (Self);

    With FInvoice Do Begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans, TheCust);

      // Display the form
      Show;
    End; { With FInvoice }
  End; { If DataChanged Or Assigned(FInvoice) }
End; { DisplaySOPTrans }

//-------------------------------------------------------------------------

procedure TfrmDisplayTransManager.DisplayNOMTrans(Const TheTrans : InvRec; Const DataChanged : Boolean);
Begin { DisplayNOMTrans }
  // If called because of the selected data being changed then only display
  // if the window is already on display
  If (Not DataChanged) Or Assigned(FNominal) Then Begin
    // Create SOP Transaction form if necessary
    If Not Assigned(FNominal) Then
      FNominal := TNTxfrForm.Create (Self);

    With FNominal Do Begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans);

      // Display the form
      Show;
    End; { With FNominal }
  End; { If DataChanged Or Assigned(FNominal) }
End; { DisplayNOMTrans }

//-------------------------------------------------------------------------

procedure TfrmDisplayTransManager.DisplayPayTrans(Const TheTrans : InvRec; Const TheCust : CustRec; Const DataChanged : Boolean);
Begin { DisplayPayTrans }
  // If called because of the selected data being changed then only display
  // if the window is already on display
  If (Not DataChanged) Or Assigned(FReceipt) Then Begin
    // Create SRC/PPY Transaction form if necessary
    If Not Assigned(FReceipt) Then
      FReceipt := TRecepForm.Create (Self);

    With FReceipt Do Begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans, TheCust);

      // Display the form
      Show;
    End; { With FReceipt }
  End; { If DataChanged Or Assigned(FReceipt) }
End; { DisplayPayTrans }

//-------------------------------------------------------------------------

procedure TfrmDisplayTransManager.DisplaySAdjTrans(const TheTrans: InvRec;
  const TheCust: CustRec; const DataChanged: Boolean);
begin
  // If called because of the selected data being changed then only display
  // if the window is already on display
  if (not DataChanged) or Assigned(FStockAdj) then
  begin
    // Create Stock Adjustments form if necessary
    if not Assigned(FStockAdj) then
      FStockAdj := TfrmStkAdj.Create (Self);

    with FStockAdj do
    begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans, TheCust);
      // Display the form
      Show;
    end; { With FStockAdj }
  end; { If DataChanged Or Assigned(FNominal) }
end;

//-------------------------------------------------------------------------

procedure TfrmDisplayTransManager.DisplayTimeSheetTrans(const TheTrans: InvRec;
  const TheCust: CustRec; const DataChanged: Boolean);
begin
  // If called because of the selected data being changed then only display
  // if the window is already on display
  if (not DataChanged) or Assigned(FTimeSheet) then
  begin
    // Create Time Sheets form if necessary
    if not Assigned(FTimeSheet) then
      FTimeSheet := TfrmTimeSheet.Create (Self);

    with FTimeSheet do
    begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans, TheCust);
      // Display the form
      Show;
    end; { With FTimeSheet }
  end; { If DataChanged Or Assigned(FNominal) }
end;

procedure TfrmDisplayTransManager.DisplayWorksOrderTrans(
  const TheTrans: InvRec; const TheCust: CustRec;
  const DataChanged: Boolean);
begin
  // If called because of the selected data being changed then only display
  // if the window is already on display
  if (not DataChanged) or Assigned(FWorksOrder) then
  begin
    // Create Works Order form if necessary
    if not Assigned(FWorksOrder) then
      FWorksOrder := TfrmWorksOrder.Create (Self);

    with FWorksOrder do
    begin
      // Setup the form to display the Transaction
      DisplayTrans(TheTrans, TheCust);
      // Display the form
      Show;
    end; { With FWorksOrder }
  end; { If DataChanged Or Assigned(FNominal) }
end;

end.


