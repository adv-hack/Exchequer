unit PageForm;

interface

uses
  {$IFDEF Win32} Windows, {$ELSE} WinTypes, WinProcs, {$ENDIF}
  Classes, Messages, Graphics, Forms, Controls, ExtCtrls, FaxField,
  Menus;

type
  TCoverPageForm = class(TForm)
    MainMenu1: TMainMenu;
    N11: TMenuItem;
    miAddTextField: TMenuItem;
    miAddImageField: TMenuItem;
    miDeleteField: TMenuItem;
    miCenterHorizontally: TMenuItem;
    N2: TMenuItem;
    miCenterVertically: TMenuItem;
    miFont: TMenuItem;
    miLoadImage: TMenuItem;
    N1: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure miAddTextFieldClick(Sender: TObject);
    procedure miAddImageFieldClick(Sender: TObject);
    procedure miDeleteFieldClick(Sender: TObject);
    procedure miCenterHorizontallyClick(Sender: TObject);
    procedure miCenterVerticallyClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure miFontClick(Sender: TObject);
    procedure miLoadImageClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FPathName : string;
    procedure FieldSelectionChange(IsFieldSelected : Boolean);
    procedure FieldPositionChange(ALeft, ATop, AWidth, AHeight : Integer);
    procedure SetPathName(const Name : string);
    procedure WMGetDlgCode(var Msg : TWMGetDlgCode);
      message WM_GETDLGCODE;
    function GetEditMode: Boolean;
    procedure SetEditMode(AEditMode: Boolean);
  public
    { Public declarations }
    FaxDesigner : TFaxDesigner;
    property EditMode: Boolean read GetEditMode write SetEditMode;
    property PathName : string read FPathName write SetPathName;
  end;


implementation

uses
  SysUtils, Dialogs, FDUtils, Main;

{$R *.DFM}

procedure TCoverPageForm.FormCreate(Sender: TObject);
var
  PixelsPerInch : Double;
begin
  SetBounds(10, 10, Application.MainForm.ClientWidth - 25,
            Application.MainForm.ClientHeight - 75);
  FaxDesigner := TFaxDesigner.Create(Self);
  with FaxDesigner do begin
    Parent := Self;
    {Set PageWidthPixels so that the page takes up the entire client area}
    PageWidthPixels := ClientWidth - 29; {Subtract 29 to allow for vertical scroll bar}
    {Set PageHeightPixels so that vertical PixelsPerInch is the same as horizontal}
    PixelsPerInch    := PageWidthPixels / PageWidthInches;
    PageHeightPixels := Round(PageHeightInches * PixelsPerInch);
    FaxPanel.OnFieldSelectionChange := FieldSelectionChange;
    FaxPanel.OnFieldPositionChange  := FieldPositionChange;
  end;
end;

procedure TCoverPageForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TCoverPageForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose := not FaxDesigner.FaxPanel.NeedsSaving or
    (MessageDlg('Exit and lose changes?', mtWarning, [mbNo, mbYes], 0) = mrYes);
end;

procedure TCoverPageForm.miAddTextFieldClick(Sender: TObject);
begin
  SetFocus;
  FaxDesigner.FaxPanel.AddTextField;
end;

procedure TCoverPageForm.miAddImageFieldClick(Sender: TObject);
begin
  SetFocus;
  FaxDesigner.FaxPanel.AddImageField;
end;

procedure TCoverPageForm.miDeleteFieldClick(Sender: TObject);
begin
  SetFocus;
  FaxDesigner.FaxPanel.DeleteSelectedField;

  {Disable menu items that perform actions on the selected field and make
   Position labels invisible since no fields are now selected}
  miDeleteField.Enabled         := False;
  miCenterHorizontally.Enabled := False;
  miCenterVertically.Enabled   := False;
  MainForm.PositionLbl.Visible  := False;
end;

procedure TCoverPageForm.miCenterHorizontallyClick(Sender: TObject);
begin
  FaxDesigner.FaxPanel.CenterSelectedField(True);
end;

procedure TCoverPageForm.miCenterVerticallyClick(Sender: TObject);
begin
  FaxDesigner.FaxPanel.CenterSelectedField(False);
end;

procedure TCoverPageForm.FieldSelectionChange(IsFieldSelected : Boolean);
begin
  {We need to enable the menu items that perform actions on the selected field
   if a field is selected, or disable them if no fields are selected. Ditto for
   the visibility of Position label. It should be visible if a field is selected,
   or invisible if not.}
  miDeleteField.Enabled         := IsFieldSelected;
  miCenterHorizontally.Enabled  := IsFieldSelected;
  miCenterVertically.Enabled    := IsFieldSelected;

  with FaxDesigner.FaxPanel do begin
    miFont.Enabled :=
      (SelectedField <> nil) and (SelectedField is TTextField);
    miLoadImage.Enabled :=
      (SelectedField <> nil) and (SelectedField is TImageField);
  end;

  MainForm.PositionLbl.Visible  := IsFieldSelected;
end;

procedure TCoverPageForm.FieldPositionChange(ALeft, ATop, AWidth, AHeight : Integer);
var
  LeftInches, TopInches, WidthInches, HeightInches : Double;
begin
  with FaxDesigner.FaxPanel do begin
    LeftInches   := HorzPixelsToInches(ALeft);
    TopInches    := VertPixelsToInches(ATop);
    WidthInches  := HorzPixelsToInches(AWidth);
    HeightInches := VertPixelsToInches(AHeight);
  end;
  if FaxDesigner.IsMetric then
    MainForm.PositionLbl.Caption := Format('%1.2f x %1.2f mm at (%1.2f, %1.2f)',
                                     [InchesToMillimeters(WidthInches),
                                      InchesToMillimeters(HeightInches),
                                      InchesToMillimeters(LeftInches),
                                      InchesToMillimeters(TopInches)])
  else
    MainForm.PositionLbl.Caption := Format('%1.2f" x %1.2f" at (%1.2f", %1.2f")',
                                     [WidthInches, HeightInches, LeftInches, TopInches]);
end;

procedure TCoverPageForm.SetPathName(const Name : string);

  function JustFileName(FullPathName : string) : string;
  var
    Posn : Integer;
  begin
    Posn := Pos('\', FullPathName);
    while Posn > 0 do begin
      Delete(FullPathName, 1, Posn);
      Posn := Pos('\', FullPathName);
    end;
    Posn := Pos('.', FullPathName);
    if Posn > 0 then
      Delete(FullPathName, Posn, Length(FullPathName) - Posn + 1);
    Result := FullPathName;
  end;

begin
  if FPathName <> Name then begin
    FPathName := Name;
    Caption   := JustFileName(FPathName);
  end;
end;

procedure TCoverPageForm.FormActivate(Sender: TObject);
begin
  {When this form receives focus, turn visibility of MainForm's position label
   on or off depending upon whether any selected fields exist}
  MainForm.PositionLbl.Visible := FaxDesigner.FaxPanel.SelectedFieldsExist;
  {If MainForm's position label is visible, update it to show the position of
   this form's selected field}
  if MainForm.PositionLbl.Visible then
    FaxDesigner.FaxPanel.FieldPositionChangeForSelectedField;
end;

procedure TCoverPageForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  I     : Integer;
begin
  if Key = VK_TAB then
    Exit;
  for I := 0 to FaxDesigner.FaxPanel.FieldCount - 1 do
    if FaxDesigner.FaxPanel.Field[I].Selected then
      FaxDesigner.FaxPanel.SizeMove(FaxDesigner.FaxPanel.Field[I], Key, Shift);
end;

procedure TCoverPageForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  I     : Integer;
begin
{!!! see if shift key is down}
  if Ord(Key) = VK_TAB then
    for I := 0 to FaxDesigner.FaxPanel.FieldCount - 1 do
      FaxDesigner.FaxPanel.SizeMove(FaxDesigner.FaxPanel.Field[I], VK_TAB, []);
  Key := #0;    
end;

procedure TCoverPageForm.miFontClick(Sender: TObject);
begin
  with FaxDesigner.FaxPanel do
    if (SelectedField <> nil) and (SelectedField is TTextField) then
      TTextField(SelectedField).MemoDblClick(nil);
end;

procedure TCoverPageForm.miLoadImageClick(Sender: TObject);
begin
  with FaxDesigner.FaxPanel do
    if (SelectedField <> nil) and (SelectedField is TImageField) then
      TImageField(SelectedField).ImageDblClick(nil);
end;

procedure TCoverPageForm.WMGetDlgCode(var Msg : TWMGetDlgCode);
begin
  Msg.Result := Msg.Result or DLGC_WANTTAB;
end;

function TCoverPageForm.GetEditMode: Boolean;
begin
  Result := FaxDesigner.FaxPanel.EditMode;
end;

procedure TCoverPageForm.SetEditMode(AEditMode: Boolean);
begin
  if AEditMode <> GetEditMode then begin
    FaxDesigner.Faxpanel.EditMode := AEditMode;
    if AEditMode then
      miDeleteField.ShortCut := 0
    else
      miDeleteField.ShortCut := ShortCut(VK_DELETE, []);
  end;
end;

end.
