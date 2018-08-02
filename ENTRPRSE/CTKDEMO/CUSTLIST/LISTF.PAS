unit ListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  COMObj, Enterprise01_TLB, ComCtrls, StdCtrls, ExtCtrls;

{ DEFINE SHOWSUPP}

type
  TDialogMode = (mdAdd, mdEdit, mdView);

  TfrmCustList = class(TForm)
    lvCustomers: TListView;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnClose: TButton;
    btnViewNotes: TButton;
    btnDiscounts: TButton;
    Button1: TButton;
    btnPrint: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewNotesClick(Sender: TObject);
    procedure btnDiscountsClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayAccount (DlgMode : TDialogMode);
    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmCustList : TfrmCustList;
  oToolkit    : IToolkit;

implementation

{$R *.DFM}

Uses CustDetF, NoteLstF, AcDiscF;

{----------------------------------------}

procedure TfrmCustList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    Caption := Caption + ' (' + oToolkit.Version + ')';

    // Open Toolkit
    //oToolkit.Configuration.DataDirectory := 'f:\431dec13\';
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes = 0) Then
      // Load Customer List
      LoadList
    Else Begin
      // Error opening Toolkit - display error and shutdown app normally
      MessageDlg ('The following error occured opening the Toolkit:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                  mtError, [mbOk], 0);
      Application.Terminate;
    End; { Else }
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

// Load List view with customer details
procedure TfrmCustList.LoadList;
Var
  FuncRes : LongInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With lvCustomers Do Begin
      // Clear out any previous data
      Items.Clear;

      // Traverse Customer Database addint items into list
      {$IFDEF SHOWSUPP}
      With oToolkit.Supplier Do Begin
      {$ELSE}
      With oToolkit.Customer Do Begin
      {$ENDIF}
        // Get First customer
        Index := acIdxCode;
        FuncRes := GetFirst;

        While (FuncRes = 0) Do Begin
          // Add into ListView
          With Items.Add Do Begin
            Caption := acCode;
            SubItems.Add (Trim(acCompany));

            // Get current balance in consolidated
            achistory.acCurrency := 0;
            acHistory.acPeriod := -99;   // YTD
            acHistory.acYear := 0;
            SubItems.Add (Format ('%10.2n', [acHistory.acBalance]));
          End; { With Items.Add }

          // Get next customer
          FuncRes := GetNext;
        End; { While (FuncRes = 0) }
      End; { With oToolkit.Customer }
    End; { With lvCustomers }
end; { LoadList }

{----------------------------------------}

procedure TfrmCustList.DisplayAccount (DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  {$IFDEF SHOWSUPP}
  With lvCustomers, oToolkit, Supplier Do
  {$ELSE}
  With lvCustomers, oToolkit, Customer Do
  {$ENDIf}
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Account Details for View/Edit
        Index := acIdxCode;
        FuncRes := GetEqual(Selected.Caption);
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Account Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Account Detail window
        With TfrmCustDetail.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              {$IFDEF SHOWSUPP}
              mdAdd  : AccDetail := Supplier.Add;
              mdEdit : AccDetail := Supplier.Update;
              mdView : AccDetail := Supplier.Clone;
              {$ELSE}
              mdAdd  : AccDetail := Customer.Add;
              mdEdit : AccDetail := Customer.Update;
              mdView : AccDetail := Customer.Clone;
              {$ENDIF}
            End; { Case }

            // Check we got a valid interface
            If Assigned (AccDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then LoadList;
            End { If Assigned (AccDetail) }
            Else
              ShowMessage ('Invalid Account Interface');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmCustList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmCustList.btnAddClick(Sender: TObject);
begin
  DisplayAccount (mdAdd);
end;

{----------------------------------------}

procedure TfrmCustList.btnEditClick(Sender: TObject);
begin
  DisplayAccount (mdEdit);
end;

{----------------------------------------}

procedure TfrmCustList.btnViewClick(Sender: TObject);
begin
  DisplayAccount (mdView);
end;

{----------------------------------------}

procedure TfrmCustList.btnViewNotesClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  {$IFDEF SHOWSUPP}
  With lvCustomers, oToolkit, Supplier Do
  {$ELSE}
  With lvCustomers, oToolkit, Customer Do
  {$ENDIf}
    // Retrieve selected Account Details
    If (SelCount = 1) Then Begin
      Index := acIdxCode;
      FuncRes := GetEqual(Selected.Caption);
      If (FuncRes = 0) Then
        // Display Notes
        DisplayNotes ('Notes for ' + Trim(acCode) + ' - ' + Trim(acCompany), oToolkit, acNotes)
      Else
        MessageDlg ('The following error occured getting the Account Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmCustList.btnDiscountsClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  {$IFDEF SHOWSUPP}
  With lvCustomers, oToolkit, Supplier Do
  {$ELSE}
  With lvCustomers, oToolkit, Customer Do
  {$ENDIf}
    // Retrieve selected Account Details
    If (SelCount = 1) Then Begin
      Index := acIdxCode;
      FuncRes := GetEqual(Selected.Caption);
      If (FuncRes = 0) Then
        // Display Notes
        DisplayDiscounts ('Discounts for ' + Trim(acCode) + ' - ' + Trim(acCompany), oToolkit, acDiscounts)
      Else
        MessageDlg ('The following error occured getting the Account Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (SelCount = 1) }
end;

procedure TfrmCustList.btnPrintClick(Sender: TObject);
var
  oPrintTempFile : IPrintTempFile;
  FuncRes : LongInt;
begin
  {$IFDEF SHOWSUPP}
  With lvCustomers, oToolkit, (Supplier As IAccount2) Do
  {$ELSE}
  With lvCustomers, oToolkit, (Customer As IAccount2) Do
  {$ENDIf}
    // Retrieve selected Account Details
    If (SelCount = 1) Then
    Begin
      Index := acIdxCode;
      FuncRes := GetEqual(Selected.Caption);
      If (FuncRes = 0) Then
        With Print(acpmStatement) Do
        Begin
          // Print Statement
          ImportDefaults;

          oPrintTempFile := PrintToTempFile(pdPrinter);
          oPrintTempFile.DisplayPreviewWindow(ptEDFReader);
        End // With Print
      Else
        MessageDlg ('The following error occured getting the Account Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (SelCount = 1) }
end;

End.
