unit LocListF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComObj, ComCtrls, Enterprise01_TLB;

type
  TDialogMode = (mdAdd, mdEdit, mdView);

  TfrmLocList = class(TForm)
    lvLocations: TListView;
    Panel1: TPanel;
    btnAdd: TButton;
    btnEdit: TButton;
    btnView: TButton;
    btnClose: TButton;
    btnStkLoc: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnViewClick(Sender: TObject);
    procedure btnStkLocClick(Sender: TObject);
  private
    { Private declarations }
    procedure DisplayLocation (DlgMode : TDialogMode);
    procedure LoadList;
  public
    { Public declarations }
  end;

var
  frmLocList: TfrmLocList;
  oToolkit    : IToolkit;

implementation

{$R *.DFM}

Uses LocDetlF, StkLocLF;

{----------------------------------------}

procedure TfrmLocList.FormCreate(Sender: TObject);
Var
  FuncRes : LongInt;
begin
  // Create as OLE Object
  oToolkit := CreateOleObject ('Enterprise01.Toolkit') As IToolkit;

  // Check it created OK
  If Assigned(oToolkit) Then Begin
    // Open Toolkit
    FuncRes := oToolkit.OpenToolkit;

    If (FuncRes = 0) Then
      // Load Location List
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

// Load List view with location details
procedure TfrmLocList.LoadList;
Var
  FuncRes : LongInt;
begin { LoadList }
  If Assigned(oToolkit) Then
    With lvLocations Do Begin
      // Clear out any previous data
      Items.Clear;

      // Traverse Customer Database addint items into list
      With oToolkit.Location Do Begin
        // Get First Location
        Index := loIdxCode;
        FuncRes := GetFirst;

        While (FuncRes = 0) Do Begin
          // Add into ListView
          With Items.Add Do Begin
            Caption := loCode;
            SubItems.Add (loName);
          End; { With Items.Add }

          // Get next customer
          FuncRes := GetNext;
        End; { While (FuncRes = 0) }
      End; { With oToolkit.Location }
    End; { With lvLocations }
end; { LoadList }

{----------------------------------------}

procedure TfrmLocList.DisplayLocation (DlgMode : TDialogMode);
var
  FuncRes     : LongInt;
begin
  With lvLocations, oToolkit, Location Do
    // Check 1 item is selected for editing
    If (DlgMode = mdAdd) Or (SelCount = 1) Then Begin
      If (DlgMode <> mdAdd) Then Begin
        // Retrieve selected Account Details for View/Edit
        Index := loIdxCode;
        FuncRes := GetEqual(BuildCodeIndex(Selected.Caption));
        If (FuncRes <> 0) Then
          MessageDlg ('The following error occured getting the Location Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                      mtError, [mbOk], 0);
      End { If (DlgMode <> mdAdd) }
      Else
        // Adding - no need to do anything
        FuncRes := 0;

      If (FuncRes = 0) Then Begin
        // AOK - create Location Detail window
        With TfrmLocationDetail.Create(Self) Do
          Try
            // Position form nicely
            Left := Self.Left + 35;
            Top := Self.Top + 35;

            // Set window mode
            Mode := DlgMode;

            // Set Transaction Interface on detail window
            Case DlgMode Of
              mdAdd  : LocDetail := Location.Add;
              mdEdit : LocDetail := Location.Update;
              mdView : LocDetail := Location.Clone;
            End; { Case }

            // Check we got a valid interface
            If Assigned (LocDetail) Then Begin
              // Display dialog
              ShowModal;

              // Reload list if changes were made
              If NeedRefresh Then LoadList;
            End { If Assigned (AccDetail) }
            Else
              ShowMessage ('The Location Detail is not available - someone else may be editing it');
          Finally
            Free;
          End;
      End; { If (FuncRes = 0) }
    End; { If (DlgMode = mdAdd) Or (SelCount = 1) }
end;

{----------------------------------------}

procedure TfrmLocList.btnCloseClick(Sender: TObject);
begin
  Close;
end;

{----------------------------------------}

procedure TfrmLocList.btnAddClick(Sender: TObject);
begin
  DisplayLocation(mdAdd);
end;

{----------------------------------------}

procedure TfrmLocList.btnEditClick(Sender: TObject);
begin
  DisplayLocation(mdEdit);
end;

{----------------------------------------}

procedure TfrmLocList.btnViewClick(Sender: TObject);
begin
  DisplayLocation(mdView);
end;

{----------------------------------------}

procedure TfrmLocList.btnStkLocClick(Sender: TObject);
var
  FuncRes     : LongInt;
begin
  With oToolkit, Location Do Begin
    // Check 1 item is selected for editing
    If (lvLocations.SelCount = 1) Then Begin
      // Retrieve selected Account Details for View/Edit
      Index := loIdxCode;
      FuncRes := GetEqual(BuildCodeIndex(lvLocations.Selected.Caption));
      If (FuncRes <> 0) Then
        MessageDlg ('The following error occured getting the Location Details:-'#13#13 + QuotedStr(oToolkit.LastErrorString),
                    mtError, [mbOk], 0);
    End { If (lvLocations.SelCount = 1)  }
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

          Caption := 'Stock in Location ' + loCode;

          // Setup list and load window
          LoadList (loStockList);

          // Display dialog
          ShowModal;
        Finally
          Free;
        End;
  End; { With oToolkit, Location }
end;

{----------------------------------------}

end.
