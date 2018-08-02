unit EditSett;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, StrUtil, EditColours, EditFonts,
  Menus, EditFields;

type
  TFrmEditSettings = class(TForm)
    Label1: TLabel;
    mlExample: TMultiList;
    edCode: TEdit;
    lCode: TLabel;
    Label2: TLabel;
    edDate: TEdit;
    bvBevel: TBevel;
    btnCancel: TButton;
    btnOK: TButton;
    btnEditColours: TButton;
    btnEditFonts: TButton;
    memName: TMemo;
    pmEditFields: TPopupMenu;
    EditFieldProperties1: TMenuItem;
    btnEditFields: TButton;
    pmList: TPopupMenu;
    EditHeaderFont1: TMenuItem;
    N1: TMenuItem;
    EditMainFont1: TMenuItem;
    EditMainBackgroundColour1: TMenuItem;
    N2: TMenuItem;
    EditHighlightFont1: TMenuItem;
    EditHighlightColor1: TMenuItem;
    N3: TMenuItem;
    EditMultiSelectFont1: TMenuItem;
    EditMultiSelectColour1: TMenuItem;
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure mlExampleChangeSelection(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnMultiSelectColClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure btnEditColoursClick(Sender: TObject);
    procedure btnEditFontsClick(Sender: TObject);
    procedure EditFieldProperties1Click(Sender: TObject);
    procedure EditHeaderFont1Click(Sender: TObject);
    procedure EditMainFont1Click(Sender: TObject);
    procedure EditHighlightFont1Click(Sender: TObject);
    procedure EditMultiSelectFont1Click(Sender: TObject);
    procedure EditMainBackgroundColour1Click(Sender: TObject);
    procedure EditHighlightColor1Click(Sender: TObject);
    procedure EditMultiSelectColour1Click(Sender: TObject);
    procedure pmListPopup(Sender: TObject);
    procedure mlExampleRefreshList(Sender: TObject);
  private
    frmEditColours : TfrmEditColours;
    frmEditFonts : TfrmEditFonts;
    frmEditFields : TfrmEditFields;
  public
    { Public declarations }
  end;

var
  FrmEditSettings: TFrmEditSettings;

implementation

{$R *.dfm}

procedure TFrmEditSettings.FormCreate(Sender: TObject);
var
  iPos : integer;
  sNo : string;
begin
  frmEditColours := nil;
  frmEditFonts := nil;
  frmEditFields := nil;

  for iPos := 1 To 50 Do Begin
    sNo := PadString(psLeft,IntToStr(iPos),'0',2);
    mlExample.DesignColumns[0].items.Add('STK' + sNo);
    mlExample.DesignColumns[1].items.Add('Description ' + sNo);
    mlExample.DesignColumns[2].items.Add(IntToStr(Random(20)+ 1));
    mlExample.DesignColumns[3].items.Add(IntToStr(Random(30)+ 3) + '.' + IntToStr(Random(10)) + IntToStr(Random(10)));
  end;{for}
  mlExample.Selected := 0;
  mlExample.MultiSelect('4',3);
  mlExample.MultiSelect('6',5);
  mlExample.MultiSelect('7',6);
end;

procedure TFrmEditSettings.mlExampleChangeSelection(Sender: TObject);
begin
{  if mlExample.Selected >= 0 then begin
    edCode.Text := mlExample.DesignColumns[0].Items[mlExample.Selected];
    edDescription.Text := mlExample.DesignColumns[1].Items[mlExample.Selected];
    edStatus.Text := mlExample.DesignColumns[2].Items[mlExample.Selected];
  end;{if}
end;

procedure TFrmEditSettings.Button2Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.Font);
  if FontDialog.Execute then mlExample.Font.Assign(FontDialog.Font);
  mlExample.RefreshList;}
end;

procedure TFrmEditSettings.Button4Click(Sender: TObject);
{var
  iColumn : integer;}
begin
{  ColorDialog.Color := mlExample.DesignColumns[0].Color;
  if ColorDialog.Execute then begin
    For iColumn := 0 to mlExample.Columns.Count -1
    do mlExample.DesignColumns[iColumn].Color := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.btnMultiSelectColClick(Sender: TObject);
begin
{  if ColorDialog.Execute then begin
    mlExample.Colours.MultiSelection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.Button8Click(Sender: TObject);
begin
{  ColorDialog.Color := mlExample.Colours.Selection;
  if ColorDialog.Execute then begin
    mlExample.Colours.Selection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.Button3Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.HeaderFont);
  if FontDialog.Execute then mlExample.HeaderFont.Assign(FontDialog.Font);
  mlExample.RefreshList;}
end;

procedure TFrmEditSettings.Button6Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.HighLightFont);
  if FontDialog.Execute then begin
    mlExample.HighlightFont.Assign(FontDialog.Font);
    mlExample.HighlightFont.Name := mlExample.Font.Name;
    mlExample.HighlightFont.Size := mlExample.Font.Size;
  end;{if}
//  mlExample.RefreshList;
end;

procedure TFrmEditSettings.Button7Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.MultiSelectFont);
  if FontDialog.Execute then begin
    mlExample.MultiSelectFont.Assign(FontDialog.Font);
    mlExample.MultiSelectFont.Name := mlExample.Font.Name;
    mlExample.MultiSelectFont.Size := mlExample.Font.Size;
  end;{if}
//  mlExample.RefreshList;
end;

procedure TFrmEditSettings.btnEditColoursClick(Sender: TObject);
begin
  if frmEditColours = nil then begin
    frmEditColours := TfrmEditColours.Create(self);
    frmEditColours.FrmParent := Self;
  end;{if}
  frmEditColours.Top := Top - 40;
  frmEditColours.Left := Left + 300;
  frmEditColours.Show;
end;

procedure TFrmEditSettings.btnEditFontsClick(Sender: TObject);
begin
  if frmEditFonts = nil then begin
    frmEditFonts := TfrmEditFonts.Create(self);
    frmEditFonts.FrmParent := Self;
  end;{if}
  frmEditFonts.Top := Top - 150;
  frmEditFonts.Left := Left + 150;
  frmEditFonts.Show;
end;

procedure TFrmEditSettings.EditFieldProperties1Click(Sender: TObject);
begin
  if frmEditFields = nil then begin
    frmEditFields := TfrmEditFields.Create(self);
    frmEditFields.FrmParent := Self;
  end;{if}
  frmEditFields.Top := Top - 150;
  frmEditFields.Left := Left + 150;
  frmEditFields.Show;
end;

procedure TFrmEditSettings.EditHeaderFont1Click(Sender: TObject);
begin
  FontDialog.Font := mlExample.HeaderFont;
  if FontDialog.Execute then begin
    mlExample.HeaderFont.Assign(FontDialog.Font);
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditMainFont1Click(Sender: TObject);
begin
  FontDialog.Font := mlExample.Font;
  if FontDialog.Execute then begin
    mlExample.Font.Assign(FontDialog.Font);
    mlExample.HighlightFont.Name := FontDialog.Font.Name;
    mlExample.MultiSelectFont.Name := FontDialog.Font.Name;
    mlExample.HighlightFont.Size := FontDialog.Font.Size;
    mlExample.MultiSelectFont.Size := FontDialog.Font.Size;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditHighlightFont1Click(Sender: TObject);
begin
  FontDialog.Font := mlExample.HighlightFont;
  if FontDialog.Execute then begin
    mlExample.HighlightFont.Style := FontDialog.Font.Style;
    mlExample.HighlightFont.Color := FontDialog.Font.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditMultiSelectFont1Click(Sender: TObject);
begin
  FontDialog.Font := mlExample.MultiSelectFont;
  if FontDialog.Execute then begin
    mlExample.MultiSelectFont.Style := FontDialog.Font.Style;
    mlExample.MultiSelectFont.Color := FontDialog.Font.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditMainBackgroundColour1Click(Sender: TObject);
var
  iCol : integer;
begin
  ColorDialog.Color := mlExample.DesignColumns[0].Color;
  if ColorDialog.Execute then begin
    for iCol := 0 to mlExample.Columns.Count -1
    do mlExample.DesignColumns[iCol].Color := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditHighlightColor1Click(Sender: TObject);
begin
  ColorDialog.Color := mlExample.Colours.Selection;
  if ColorDialog.Execute then begin
    mlExample.Colours.Selection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.EditMultiSelectColour1Click(Sender: TObject);
begin
  ColorDialog.Color := mlExample.Colours.MultiSelection;
  if ColorDialog.Execute then begin
    mlExample.Colours.MultiSelection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettings.pmListPopup(Sender: TObject);
begin
  EditMultiSelectFont1.Enabled := mlExample.Options.MultiSelection;
  EditMultiSelectColour1.Enabled := mlExample.Options.MultiSelection;
end;

procedure TFrmEditSettings.mlExampleRefreshList(Sender: TObject);
begin
  if frmEditFonts <> nil then frmEditFonts.LoadProperties;
  if frmEditColours <> nil then frmEditColours.LoadProperties;
  if frmEditFields <> nil then frmEditFields.LoadProperties;
end;

end.
