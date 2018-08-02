unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, AppEvnts, CustomFieldsIntF, VAOUtil;

type
  TfrmMainDebug = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
  private
    { Private declarations }
    FIndent : Integer;
  public
    { Public declarations }
    {$IFDEF DRILLDEBUG}
    Procedure DebugStr (Const DbgMsg : ANSIString; Const IndentBy : Integer = 0);
    {$ENDIF} // DRILLDEBUG
  end;

var
  frmMainDebug: TfrmMainDebug;

implementation

{$R *.dfm}
{$R WinXPMan.Res}

//=========================================================================

procedure TfrmMainDebug.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
  //GS 17/11/2011 ABSEXCH-12037: set the path for the custom fields object
  SetCustomFieldsPath(VAOInfo.vaoCompanyDir);

  FIndent := 0;
end;

//-------------------------------------------------------------------------

{$IFDEF DRILLDEBUG}
Procedure TfrmMainDebug.DebugStr (Const DbgMsg : ANSIString; Const IndentBy : Integer = 0);
Var
  IndStr : ShortString;
Begin { DebugStr }
  With ListView1 Do Begin
    // Unindent before writing the entry
    If (IndentBy < 0) Then
    Begin
      FIndent := FIndent + (2 * IndentBy);
      If (FIndent < 0) Then
        FIndent := 0
    End; // If (IndentBy < 0)
    IndStr := StringOfChar (' ', FIndent);

    With Items.Add Do Begin
      // Add new item
      Caption := FormatDateTime('HH:MM:Ss.zzz', Now);
      SubItems.Add (IndStr + DbgMsg);
    End; { With Items.Add }

    // Move to selected item
    ItemIndex := Items.Count - 1;
    Selected.MakeVisible(False);

    // Indent after writing the entry
    If (IndentBy > 0) Then
    Begin
      FIndent := FIndent + (2 * IndentBy);
      If (FIndent > 100) Then
        FIndent := 100
    End; // If (IndentBy > 0)
  End; { With ListView1.Items.Add }
End; { DebugStr }
{$ENDIF} // DRILLDEBUG

//=========================================================================

procedure TfrmMainDebug.Clear1Click(Sender: TObject);
begin
  ListView1.Items.Clear;
end;

end.
