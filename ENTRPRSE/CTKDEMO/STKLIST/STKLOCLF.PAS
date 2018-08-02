unit StkLocLF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, Enterprise01_TLB;

type
  TDialogMode = (mdAdd, mdEdit, mdView);

  TfrmStkLocList = class(TForm)
    lvStockLoc: TListView;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
  private
    { Private declarations }
    FStkLoc : IStockLocation;

    procedure DisplayStockLoc (DlgMode : TDialogMode);
  public
    { Public declarations }
    procedure LoadList(StkLoc : IStockLocation);
  end;

implementation

{$R *.DFM}

Uses StkListF, StkLocDF;

{----------------------------------------}

procedure TfrmStkLocList.FormCreate(Sender: TObject);
begin
  FStkLoc := NIL;
end;

{----------------------------------------}

procedure TfrmStkLocList.FormDestroy(Sender: TObject);
begin
  FStkLoc := NIL;
end;

{----------------------------------------}

procedure TfrmStkLocList.LoadList(StkLoc : IStockLocation);
Var
  LocI    : ILocation;
  FuncRes : LongInt;
begin
  FStkLoc := StkLoc;

  With StkLoc, lvStockLoc Do Begin
    // Clear any pre-existing items out of list
    Items.Clear;

    // Get First Location
    FuncRes := GetFirst;
    While (FuncRes = 0) Do Begin
      // Add into ListView
      With Items.Add Do Begin
        Caption := slLocationCode;
        LocI := slLocationCodeI;
        If Assigned(LocI) Then
          SubItems.Add (LocI.loName)
        Else
          SubItems.Add ('?');
        SubItems.Add (Format ('%0.' + IntToStr(oToolkit.SystemSetup.ssQtyDecimals) + 'f', [slQtyInStock]));
        SubItems.Add (Format ('%0.' + IntToStr(oToolkit.SystemSetup.ssQtyDecimals) + 'f', [slQtyFree]));
        SubItems.Add (Format ('%0.' + IntToStr(oToolkit.SystemSetup.ssQtyDecimals) + 'f', [slQtyOnOrder]));
      End; { With Items.Add }

      // Get next customer
      FuncRes := GetNext;
    End; { While (FuncRes = 0) }
  End; { With StkLoc, lvStockLoc }
end;

{----------------------------------------}

procedure TfrmStkLocList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmStkLocList.DisplayStockLoc (DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  With lvStockLoc, FStkLoc Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Account Details for View/Edit
        FuncRes := GetEqual(BuildCodeIndex(Selected.Caption));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Stock-Location Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Stock-Location Detail window
        With TfrmStkLocDetl.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : StkLocDetail := FStkLoc.Add;
              mdEdit : StkLocDetail := FStkLoc.Update;
              mdView : StkLocDetail := FStkLoc.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (StkLocDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then LoadList(FStkLoc);
            End { If Assigned (AccDetail) }
            Else
              ShowMessage ('The Stock-Location Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;


{----------------------------------------}

procedure TfrmStkLocList.btnAddClick(Sender: TObject);
begin
  DisplayStockLoc (mdAdd);
end;

{----------------------------------------}

procedure TfrmStkLocList.btnEditClick(Sender: TObject);
begin
  DisplayStockLoc (mdEdit);
end;

{----------------------------------------}

procedure TfrmStkLocList.btnViewClick(Sender: TObject);
begin
  DisplayStockLoc (mdView);
end;

{----------------------------------------}

end.
