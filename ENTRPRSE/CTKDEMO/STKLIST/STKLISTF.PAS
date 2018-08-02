unit StkListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  COMObj, Enterprise01_TLB, StdCtrls, ExtCtrls, ComCtrls, Buttons;

type
  TDialogMode = (mdAdd, mdEdit, mdView);

  TfrmStockList = class(TForm)
    lvStock: TListView;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnClose: TButton;
    btnViewLoc: TButton;
    btnViewNotes: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnViewLocClick(Sender: TObject);
    procedure btnViewNotesClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayStock (DlgMode : TDialogMode);
    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmStockList: TfrmStockList;
  oToolkit    : IToolkit;

implementation

{$R *.DFM}

Uses StkDetlF, StkSelct, StkLocLF, NoteLstF;

{----------------------------------------}

procedure TfrmStockList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  Caption := Application.Title;

  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
//oToolkit.Configuration.DataDirectory := 'C:\Develop\Dev500\Companies\TRAIN';
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes = 0) Then
      // Load Stock List
      LoadList
    Else
      // Error opening Toolkit
      ShowMessage ('OpenToolkit: ' + IntToStr(FuncRes));
  End; { If Assigned(oToolkit) }
end;

{----------------------------------------}

// Load List view with Stock details
procedure TfrmStockList.LoadList;
Var
  FuncRes : LongInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With lvStock Do Begin
      // Clear out any previous data
      Items.Clear;

      // Traverse Customer Database addint items into list
      With oToolkit.Stock Do Begin
        // Get First Item
        Index := stIdxCode;
        FuncRes := GetFirst;

        While (FuncRes = 0) Do Begin
          // Add into ListView
          With Items.Add Do Begin
            Caption := stCode;
            SubItems.Add (stDesc[1]);
            SubItems.Add (stSupplier);
          End; { With Items.Add }

          // Get next item
          FuncRes := GetNext;
        End; { While (FuncRes = 0) }
      End; { With oToolkit.Stock }
    End; { With lvStock }
end; { LoadList }

{----------------------------------------}


procedure TfrmStockList.DisplayStock (DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  With lvStock, oToolkit, Stock Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Stock Details for View/Edit
        Index := stIdxCode;
        FuncRes := GetEqual(Selected.Caption);
        If (FuncRes <> 0) Then
          ShowMessage ('Unable to load Stock Details, status ' + IntToStr(FuncRes));
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Stock Detail window
        With TfrmStockDetail.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : StkDetail := Stock.Add;
              mdEdit : StkDetail := Stock.Update;
              mdView : StkDetail := Stock.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (StkDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then LoadList;
            End { If Assigned (AccDetail) }
            Else
              ShowMessage ('Invalid Stock Interface');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmStockList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmStockList.btnAddClick(Sender: TObject);
begin
  DisplayStock (mdAdd);
end;

{----------------------------------------}

procedure TfrmStockList.btnEditClick(Sender: TObject);
begin
  DisplayStock (mdEdit);
end;

{----------------------------------------}

procedure TfrmStockList.btnViewClick(Sender: TObject);
begin
  DisplayStock (mdView);
end;

{----------------------------------------}

procedure TfrmStockList.btnViewLocClick(Sender: TObject);
var
  FuncRes     : LongInt;
begin
  With oToolkit, Stock Do Begin
    // Check 1 item is selected for editing
    If (lvStock.SelCount = 1) Then Begin
      // Retrieve selected Account Details for View/Edit
      Index := stIdxCode;
      FuncRes := GetEqual(BuildCodeIndex(lvStock.Selected.Caption));
      If (FuncRes <> 0) Then
        MessageDlg ('The following error occured getting the Stock Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End { If (lvStock.SelCount = 1)  }
    Else
      // Nothing Selected
      FuncRes := -1;

    If (FuncRes = 0) Then
      // AOK - create Location Detail window
      With TfrmStkLocList.Create(Self) Do
        Try
          // Position form nicely
          Left := Self.Left + 35;
          Top := Self.Top + 35;

          Caption := 'Locations for Stock ' + stCode;

          // Setup list and load window
          LoadList (stLocationList);

          // Display dialog
          ShowModal;
        Finally
          Free;
        End;
  End; { With oToolkit, Stock }
end;

procedure TfrmStockList.btnViewNotesClick(Sender: TObject);
var
  FuncRes : LongInt;
begin
  With oToolkit, Stock Do
    // Check 1 item is selected for editing
    If (lvStock.SelCount = 1) Then Begin
      // Retrieve selected Account Details for View/Edit
      Index := stIdxCode;
      FuncRes := GetEqual(BuildCodeIndex(lvStock.Selected.Caption));
      If (FuncRes = 0) Then
        // Display Notes
        DisplayNotes ('Notes for ' + Trim(stCode) + ' - ' + Trim(stDesc[1]), oToolkit, stNotes)
      Else
        MessageDlg ('The following error occured getting the Stock Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End; { If (lvStock.SelCount = 1)  }
end;

end.
