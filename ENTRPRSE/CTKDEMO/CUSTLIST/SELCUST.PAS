unit SelCust;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Enterprise01_TLB, ComCtrls;

type
  TfrmCustSelect = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lvCust: TListView;
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


Function SelectAccount (oAccount : IAccount; Var AcKey : ShortString) : IAccount;

implementation

{$R *.DFM}

{-------------------------------------------------------------------------------------------------}

// Displays a popup Account selection list
Function SelectAccount (oAccount : IAccount; Var AcKey : ShortString) : IAccount;
var
  oldPosition  : LongInt;
  oldIndex     : SmallInt;
  FuncRes      : LongInt;

  Procedure AddListItem (lvCust : TListView);
  Begin { AddListItem }
    With oAccount, lvCust.Items.Add Do Begin
      Caption := acCode;
      SubItems.Add (acCompany);
    End; { With oAccount, lvCust.Items.Add }
  End; { AddListItem }

Begin { SelectCust }
  Result := NIL;

  With oAccount Do Begin
    // Save current position in Customer file
    oldPosition := Position;
    oldIndex := Index;
    SavePosition;

    // Identify index to be used, '/' = Name otherwise Code
    AcKey := Trim(AcKey);
    If (AcKey <> '') Then Begin
      If (AcKey[1] = '/') Then Begin
        // Company Name Index
        Index := acIdxName;

        // Delete index character
        Delete (AcKey, 1, 1);

        // Build as proper index search key
        AcKey := BuildNameIndex(AcKey);
      End { If }
      Else Begin
        // No specifier - use code
        Index := acIdxCode;
        AcKey := BuildCodeIndex(AcKey);
      End; { Else }

      If (Trim(AcKey) <> '') Then Begin
        // Check for exact match
        FuncRes := GetEqual(AcKey);
        If (FuncRes = 0) Then Begin
          // Got match - return exact code and a clone interface
          AcKey := KeyString;
          Result := Clone;
        End; { If (FuncRes = 0) }
      End; { If (AcKey <> '') }
    End { If (AcKey <> '') }
    Else
      // no search details - use code index
      Index := acIdxCode;

    If (Not Assigned(Result)) Then Begin
      // No exact match found - Load list of any matching items
      With TfrmCustSelect.Create(Application) Do
        Try
          // Remove any pre-existing list entries
          lvCust.Items.Clear;

          If (Trim(AcKey) = '') Then Begin
            // No filter condition - load all applicable stock items
            FuncRes := GetFirst;
            While (FuncRes = 0) Do Begin
              // Add into ListView
              AddListItem(lvCust);

              // Get next item
              FuncRes := GetNext;
            End; { While (FuncRes = 0) }
          End { If (AcKey = '') }
          Else Begin
            // Filter condition - load matching items
            FuncRes := GetGreaterThanOrEqual(AcKey);
            While (FuncRes = 0) And (Pos(UpperCase(Trim(AcKey)), UpperCase(KeyString)) = 1) Do Begin
              // Add into ListView
              AddListItem(lvCust);

              // Get next item
              FuncRes := GetNext;
            End; { While (FuncRes = 0) And (Pos(UpperCase(AcKey), UpperCase(KeyString)) = 1) }
          End; { Else }

          If (lvCust.Items.Count = 1) Then Begin
            // Only 1 item - must be required stock item - load and return details
            Index := acIdxCode;
            FuncRes := GetEqual(BuildCodeIndex(lvCust.Items[0].Caption));
            If (FuncRes = 0) Then Begin
              AcKey := KeyString;
              Result := Clone;
            End; { If (FuncRes = 0) }
          End; { If }

          If (Not Assigned(Result)) Then
            If (ShowModal = mrOk) Then Begin
              Index := acIdxCode;
              FuncRes := GetEqual(BuildCodeIndex(lvCust.Selected.Caption));
              If (FuncRes = 0) Then Begin
                AcKey := KeyString;
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
  End; { With Customer }
End; { SelectAccount }

{-------------------------------------------------------------------------------------------------}

procedure TfrmCustSelect.btnOKClick(Sender: TObject);
begin
  If Assigned(lvCust.Selected) Then
    ModalResult := mrOk
  Else
    ShowMessage ('A Customer Record must be selected');
end;

end.
