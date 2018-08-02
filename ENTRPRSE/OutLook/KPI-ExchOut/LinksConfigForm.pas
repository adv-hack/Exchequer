unit LinksConfigForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Grids, ValEdit, AdvOfficePager,
  AdvOfficePagerStylers, AdvEdit, AdvCombo, ColCombo, Mask, AdvSpin,
  AdvGlowButton, AdvPanel, KPICommon;

type
  TfrmConfigureLinks = class(TForm)
    OpenDialog: TOpenDialog;
    advPanel: TAdvPanel;
    btnSave: TAdvGlowButton;
    AdvGlowButton1: TAdvGlowButton;
    ofConfig: TAdvOfficePager;
    ofpLinks: TAdvOfficePage;
    gbFilters: TGroupBox;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    veLinks: TValueListEditor;
    btnAdd: TAdvGlowButton;
    btnEdit: TAdvGlowButton;
    btnDelete: TAdvGlowButton;
    btnMoveUp: TAdvGlowButton;
    btnMoveDown: TAdvGlowButton;
    pgStyler: TAdvOfficePagerOfficeStyler;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure veLinksEditButtonClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnMoveUpClick(Sender: TObject);
    procedure btnMoveDownClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure veLinksKeyPress(Sender: TObject; var Key: Char);
    procedure AdvGlowButton1Click(Sender: TObject);
    procedure advPanelDblClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FCanClose: boolean;
    FLinkCount: integer;
    Procedure SetHost (Value : HWND);
    procedure MakeRounded(Control: TWinControl);
    procedure SetLinkCount(const Value: integer);
  public
    procedure Startup;
    Property Host : HWND Write SetHost;
    property LinkCount: integer read FLinkCount write SetLinkCount;
    property Links: TValueListEditor read veLinks;
  end;

implementation

{$R *.dfm}

//=========================================================================

procedure TfrmConfigureLinks.FormCreate(Sender: TObject);
var
  ix: integer;
begin
  // Centre - can't use poScreenCentre because of Host property not working
//  Self.Top := (Screen.Height - - Self.Height) Div 2;
//  Self.Left := (Screen.Width - Self.Width) Div 2;
  MakeRounded(self);
  MakeRounded(pnlRounded);
  MakeRounded(advPanel);
//  ix := veLinks.InsertRow('', '', true); // make sure we have at least one true row in addition to the column titles
//  veLinks.ItemProps[ix - 1].EditStyle := esEllipsis; // otherwise first data row doesn't get esEllipsis when grid is blank
//  if veLinks.Strings.Count = 0 then
//    veLinks.enabled := false;
end;

//-------------------------------------------------------------------------

Procedure TfrmConfigureLinks.SetHost (Value : HWND);
Var
  lpRect: TRect;
Begin // SetHost
  If (Value <> 0) Then
  Begin
    // Get the host window position and centre the login dialog over it
    If GetWindowRect(Value, lpRect) Then
    Begin
      // Top = Top of Host + (0.5 * Host Height) - (0.5 * Self Height)
      Self.Top := lpRect.Top + ((lpRect.Bottom - lpRect.Top - Self.Height) Div 2);

      // Left = Left of Host + (0.5 * Host Width) - (0.5 * Self Width)
      Self.Left := lpRect.Left + ((lpRect.Right - lpRect.Left - Self.Width) Div 2);

      // Make sure it is still fully on the screen
      If (Self.Top < 0) Then Self.Top := 0;
      If ((Self.Top + Self.Height) > Screen.Height) Then Self.Top := Screen.Height - Self.Height;
      If (Self.Left < 0) Then Self.Left := 0;
      If ((Self.Left + Self.Width) > Screen.Width) Then Self.Left := Screen.Width - Self.Width;
    End; // If GetWindowRect(Value, lpRect)
  End; // If (Value <> 0)
End; // SetHost

//------------------------------

procedure TfrmConfigureLinks.btnAddClick(Sender: TObject);
var
  ix: integer;
  SelGrid: TGridRect;
begin
  veLinks.Enabled := true;
  ix := veLinks.InsertRow('', '', true);
  if ix > 0 then begin
    veLinks.ItemProps[ix - 1].EditStyle := esEllipsis;
    with SelGrid do begin
      Left   := 0;
      Top    := ix;
      Right  := 0;
      Bottom := ix;
      veLinks.Selection  := SelGrid;
      veLinks.SetFocus;
      veLinks.EditorMode := true;
    end;
  end;
end;

procedure TfrmConfigureLinks.btnDeleteClick(Sender: TObject);
var
  Sel: TGridRect;
  key: string;
begin
  Sel := veLinks.Selection; // top and bottom indicate the first and last rows that were selected (left and right indicate the columns);
  if sel.Top < 1 then EXIT;
  key := veLinks.Keys[sel.top];
  if MessageDlg(format('Are you sure you want to delete %s ?', [key]), mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    veLinks.DeleteRow(sel.top);
  if veLinks.Strings.Count = 0 then
    veLinks.enabled := false
  else
    veLinks.SetFocus;
end;

procedure TfrmConfigureLinks.veLinksEditButtonClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    veLinks.Cells[veLinks.Selection.Left, veLinks.Selection.Top] := OpenDialog.FileName;
end;

procedure TfrmConfigureLinks.btnEditClick(Sender: TObject);
begin
  if veLinks.Selection.Top > 0 then
    veLinksEditButtonClick(sender);
end;

procedure TfrmConfigureLinks.btnMoveUpClick(Sender: TObject);
var
  tmpKey:   string;
  tmpValue: string;
  SelRect:  TGridRect;
begin
  if veLinks.Selection.Top = 1 then EXIT;

  with veLinks do begin
    tmpKey   := Cells[0, Selection.Top];
    tmpValue := Cells[1, Selection.Top];

    Cells[0, Selection.Top] := Cells[0, Selection.Top - 1];
    Cells[1, Selection.Top] := Cells[1, Selection.Top - 1];

    Cells[0, Selection.Top - 1] := tmpKey;
    Cells[1, Selection.Top - 1] := tmpValue;
  end;
  SelRect        := veLinks.Selection;
  SelRect.Top    := SelRect.Top - 1;
  SelRect.Bottom := SelRect.Bottom - 1;
  veLinks.Selection := SelRect;
  veLinks.SetFocus;
end;

procedure TfrmConfigureLinks.btnMoveDownClick(Sender: TObject);
var
  tmpKey:   string;
  tmpValue: string;
  SelRect:  TGridRect;
begin
  if veLinks.Selection.Bottom = veLinks.RowCount - 1 then EXIT;

  with veLinks do begin
    tmpKey   := Cells[0, Selection.Top];
    tmpValue := Cells[1, Selection.Top];

    Cells[0, Selection.Top] := Cells[0, Selection.Top + 1];
    Cells[1, Selection.Top] := Cells[1, Selection.Top + 1];

    Cells[0, Selection.Top + 1] := tmpKey;
    Cells[1, Selection.Top + 1] := tmpValue;
  end;
  SelRect        := veLinks.Selection;
  SelRect.Top    := SelRect.Top + 1;
  SelRect.Bottom := SelRect.Bottom + 1;
  veLinks.Selection := SelRect;
  veLinks.SetFocus;
end;

procedure TfrmConfigureLinks.FormKeyPress(Sender: TObject; var Key: Char);
begin
//  if key = #13 then begin
//    SendMessage(Handle, WM_NEXTDLGCTL, 0, 0);
//    key := #0;
//  end;
end;

procedure TfrmConfigureLinks.MakeRounded(Control: TWinControl);
var
  R: TRect;
  Rgn: HRGN;
begin
  with Control do
  begin
    R := ClientRect;
    rgn := CreateRoundRectRgn(R.Left, R.Top, R.Right, R.Bottom, 20, 20);
    Perform(EM_GETRECT, 0, lParam(@r));
    InflateRect(r, -5, -5);
    Perform(EM_SETRECTNP, 0, lParam(@r));
    SetWindowRgn(Handle, rgn, True);
    Invalidate;
  end;
end;

procedure TfrmConfigureLinks.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

procedure TfrmConfigureLinks.FormActivate(Sender: TObject);
begin
  if veLinks.Enabled then
    veLinks.SetFocus
  else
    btnAdd.SetFocus;
end;

procedure TfrmConfigureLinks.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then
    ModalResult := mrCancel;
end;

procedure TfrmConfigureLinks.veLinksKeyPress(Sender: TObject; var Key: Char);
var
  SelRect: TGridRect;
begin
  if (key = #13) then
    if (veLinks.Selection.Left = 0) then begin // pressed enter when in the left-hand column
      SelRect := veLinks.Selection;
      SelRect.Right := 1; // move the selection to the right-hand column (path/url)
      SelRect.Left  := 1; // move the selection to the right-hand column (path/url)
      veLinks.Selection := SelRect;
      veLinks.SetFocus;
      veLinks.EditorMode := true;
    end
    else if (veLinks.Selection.Left = 1) then begin  // pressed enter when in the right-hand column
      btnAdd.SetFocus;
    end;
end;

procedure TfrmConfigureLinks.AdvGlowButton1Click(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to cancel your changes ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    FCanClose := true;
end;

procedure TfrmConfigureLinks.advPanelDblClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, 0, false);
end;

procedure TfrmConfigureLinks.btnSaveClick(Sender: TObject);
begin
  FCanClose := true;
end;

procedure TfrmConfigureLinks.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FCanClose then
    action := caFree
  else
    action := caNone;
end;

procedure TfrmConfigureLinks.SetLinkCount(const Value: integer);
begin
  FLinkCount := Value;
end;

procedure TfrmConfigureLinks.Startup;
begin
  veLinks.Enabled := FLinkCount <> 0;
end;

end.
