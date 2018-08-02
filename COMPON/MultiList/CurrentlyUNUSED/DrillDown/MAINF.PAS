unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, AppEvnts;

type
  TfrmMainDebug = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Clear1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    {$IFDEF DRILLDEBUG}
    Procedure DebugStr (Const DbgMsg : ANSIString);
    {$ENDIF} // DRILLDEBUG
  end;

var
  frmMainDebug: TfrmMainDebug;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmMainDebug.FormCreate(Sender: TObject);
begin
  Caption := Application.Title;
end;

//-------------------------------------------------------------------------

{$IFDEF DRILLDEBUG}
Procedure TfrmMainDebug.DebugStr (Const DbgMsg : ANSIString);
Begin { DebugStr }
  With ListView1 Do Begin
    With Items.Add Do Begin
      // Add new item
      Caption := FormatDateTime('HH:MM:Ss.zzz', Now);
      SubItems.Add (DbgMsg);
    End; { With Items.Add }

    // Move to selected item
    ItemIndex := Items.Count - 1;
    Selected.MakeVisible(False);
  End; { With ListView1.Items.Add }
End; { DebugStr }
{$ENDIF} // DRILLDEBUG

//=========================================================================

procedure TfrmMainDebug.Clear1Click(Sender: TObject);
begin
  ListView1.Items.Clear;
end;

end.
