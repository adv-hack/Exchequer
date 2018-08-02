unit StkSelct;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, ComCtrls;

type
  TfrmStkSelect = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lvStock: TListView;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Function SelectStock (oToolkit : IToolkit; Const Mode : SmallInt; Var StkKey : ShortString) : IStock;

implementation

{$R *.DFM}

{-------------------------------------------------------------------------------------------------}

// Displays a popup stock selection list
//
// Mode:    0 = anything
//          1 = Groups
//          2 = Products + Description + BOM
//
Function SelectStock (oToolkit : IToolkit; Const Mode : SmallInt; Var StkKey : ShortString) : IStock;
var
  oldPosition  : LongInt;
  oldIndex     : SmallInt;
  FuncRes      : LongInt;

  Function CheckFilter : Boolean;
  Begin { CheckFilter }
    Result := (Mode = 0);

    If (Not Result) Then
      With oToolkit, Stock do
        Case Mode Of
          // Groups
          1  : Result := (stType = stTypeGroup);

          // Products + Description + BOM
          2  : Result := (stType = stTypeProduct) or (stType = stTypeDescription) or (stType = stTypeBillOfMaterials);
        End; { Case }
  End; { CheckFilter }

  Procedure AddListItem (lvStock : TListView);
  Begin { AddListItem }
    With oToolkit.Stock, lvStock.Items.Add Do Begin
      Caption := stCode;
      SubItems.Add (stDesc[1]);
      SubItems.Add (stSupplier);
    End; { With lvStock.Items.Add }
  End; { AddListItem }

Begin { SelectStock }
  Result := NIL;

  With oToolkit, Stock Do Begin
    // Save current position in stock file
    oldPosition := Position;
    oldIndex := Index;
    SavePosition;

    // Identify index to be used, '/' = Description otherwise Code
    StkKey := Trim(StkKey);
    If (StkKey <> '') Then Begin
      If (StkKey[1] = '/') Then Begin
        // Description Index
        Index := stIdxDesc;

        // Delete index character
        Delete (StkKey, 1, 1);

        // Build as proper index search key
        StkKey := BuildDescIndex(StkKey);
      End { If }
      Else Begin
        // No specifier - use code
        Index := stIdxCode;
        StkKey := BuildCodeIndex(StkKey);
      End; { Else }

      If (Trim(StkKey) <> '') Then Begin
        // Check for exact match
        FuncRes := GetEqual(StkKey);
        If (FuncRes = 0) And CheckFilter Then Begin
          // Got match - return exact code and a clone interface
          StkKey := KeyString;
          Result := Clone;
        End; { If (FuncRes = 0) }
      End; { If (StkCode <> '') }
    End { If (StkCode <> '') }
    Else
      // no search details - use code index
      Index := stIdxCode;

    If (Not Assigned(Result)) Then Begin
      // No exact match found - Load list of any matching items
      With TfrmStkSelect.Create(Application) Do
        Try
          // Remove any pre-existing list entries
          lvStock.Items.Clear;

          If (Trim(StkKey) = '') Then Begin
            // No filter condition - load all applicable stock items
            FuncRes := GetFirst;
            While (FuncRes = 0) Do Begin
              If CheckFilter Then
                // Add into ListView
                AddListItem(lvStock);

              // Get next item
              FuncRes := GetNext;
            End; { While (FuncRes = 0) }
          End { If (StkCode = '') }
          Else Begin
            // Filter condition - load matching items
            FuncRes := GetGreaterThanOrEqual(StkKey);
            While (FuncRes = 0) And (Pos(UpperCase(Trim(StkKey)), UpperCase(KeyString)) = 1) Do Begin
              If CheckFilter Then
                // Add into ListView
                AddListItem(lvStock);

              // Get next item
              FuncRes := GetNext;
            End; { While (FuncRes = 0) And (Pos(UpperCase(StkCode), UpperCase(KeyString)) = 1) }
          End; { Else }

          If (lvStock.Items.Count = 1) Then Begin
            // Only 1 item - must be required stock item - load and return details
            Index := stIdxCode;
            FuncRes := GetEqual(BuildCodeIndex(lvStock.Items[0].Caption));
            If (FuncRes = 0) Then Begin
              StkKey := KeyString;
              Result := Clone;
            End; { If (FuncRes = 0) }
          End; { If }

          If (Not Assigned(Result)) Then
            If (ShowModal = mrOk) Then Begin
              Index := stIdxCode;
              FuncRes := GetEqual(BuildCodeIndex(lvStock.Selected.Caption));
              If (FuncRes = 0) Then Begin
                StkKey := KeyString;
                Result := Clone;
              End; { If (FuncRes = 0) }
            End; { If (ShowModal = mrOk) }
        Finally
          Free;
        End;
    End; { If (Not Assigned(Result)) }

    // Restore original position in stock file
    Index := OldIndex;
    Position := oldPosition;
    RestorePosition;
  End; { With oToolkit, Stock }
End; { SelectStock }

{-------------------------------------------------------------------------------------------------}

procedure TfrmStkSelect.btnOKClick(Sender: TObject);
begin
  If Assigned(lvStock.Selected) Then
    ModalResult := mrOk
  Else
    ShowMessage ('A Stock Record must be selected');
end;

end.
