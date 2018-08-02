unit EditSettEnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, StrUtil, Menus, ComCtrls, FontDlg;

type
  TFrmEditSettingsEnt = class(TForm)
    FontDialog: TFontDialog;
    ColorDialog: TColorDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    btnCancel: TButton;
    btnOK: TButton;
    Bevel1: TBevel;
    lFields: TLabel;
    btnFieldColour: TButton;
    btnFieldFont: TButton;
    panFields: TPanel;
    btnHeaderFont: TButton;
    panHeader: TPanel;
    Bevel2: TBevel;
    btnHighlightColour: TButton;
    btnHighlightFont: TButton;
    panHighlight: TPanel;
    Bevel3: TBevel;
    lListHeadings: TLabel;
    lHighlightBar: TLabel;
    btnDefaults: TButton;
    panMultiSelectStuff: TPanel;
    Label4: TLabel;
    btnMultiSelectColour: TButton;
    btnMultiSelectFont: TButton;
    panMultiSelect: TPanel;
    Bevel4: TBevel;
    btnHeaderColour: TButton;
    procedure FormCreate(Sender: TObject);
    procedure mlExampleChangeSelection(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnMultiSelectColClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure btnHeaderFontClick(Sender: TObject);
    procedure btnFieldFontClick(Sender: TObject);
    procedure btnHighlightFontClick(Sender: TObject);
    procedure btnMultiSelectFontClick(Sender: TObject);
    procedure btnFieldColourClick(Sender: TObject);
    procedure btnHighlightColourClick(Sender: TObject);
    procedure btnMultiSelectColourClick(Sender: TObject);
  private
//    frmEditColours : TfrmEditColours;
//    frmEditFonts : TfrmEditFonts;
//    frmEditFields : TfrmEditFields;
  public
    { Public declarations }
  end;

var
  FrmEditSettingsEnt: TFrmEditSettingsEnt;

implementation

{$R *.dfm}

procedure TFrmEditSettingsEnt.FormCreate(Sender: TObject);
var
  iPos : integer;
  sNo : string;
begin
//  frmEditColours := nil;
//  frmEditFonts := nil;
//  frmEditFields := nil;
end;

procedure TFrmEditSettingsEnt.mlExampleChangeSelection(Sender: TObject);
begin
{  if mlExample.Selected >= 0 then begin
    edCode.Text := mlExample.DesignColumns[0].Items[mlExample.Selected];
    edDescription.Text := mlExample.DesignColumns[1].Items[mlExample.Selected];
    edStatus.Text := mlExample.DesignColumns[2].Items[mlExample.Selected];
  end;{if}
end;

procedure TFrmEditSettingsEnt.Button2Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.Font);
  if FontDialog.Execute then mlExample.Font.Assign(FontDialog.Font);
  mlExample.RefreshList;}
end;

procedure TFrmEditSettingsEnt.Button4Click(Sender: TObject);
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

procedure TFrmEditSettingsEnt.btnMultiSelectColClick(Sender: TObject);
begin
{  if ColorDialog.Execute then begin
    mlExample.Colours.MultiSelection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettingsEnt.Button8Click(Sender: TObject);
begin
{  ColorDialog.Color := mlExample.Colours.Selection;
  if ColorDialog.Execute then begin
    mlExample.Colours.Selection := ColorDialog.Color;
    mlExample.RefreshList;
  end;{if}
end;

procedure TFrmEditSettingsEnt.Button3Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.HeaderFont);
  if FontDialog.Execute then mlExample.HeaderFont.Assign(FontDialog.Font);
  mlExample.RefreshList;}
end;

procedure TFrmEditSettingsEnt.Button6Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.HighLightFont);
  if FontDialog.Execute then begin
    mlExample.HighlightFont.Assign(FontDialog.Font);
    mlExample.HighlightFont.Name := mlExample.Font.Name;
    mlExample.HighlightFont.Size := mlExample.Font.Size;
  end;{if}
//  mlExample.RefreshList;
end;

procedure TFrmEditSettingsEnt.Button7Click(Sender: TObject);
begin
{  FontDialog.Font.Assign(mlExample.MultiSelectFont);
  if FontDialog.Execute then begin
    mlExample.MultiSelectFont.Assign(FontDialog.Font);
    mlExample.MultiSelectFont.Name := mlExample.Font.Name;
    mlExample.MultiSelectFont.Size := mlExample.Font.Size;
  end;{if}
//  mlExample.RefreshList;
end;

procedure TFrmEditSettingsEnt.btnHeaderFontClick(Sender: TObject);
begin
  oFontDialog.Font := panHeader.Font;
  oFontDialog.Background := panHeader.Color;
  if oFontDialog.Execute then begin
    panHeader.Font.Assign(oFontDialog.Font);
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnFieldFontClick(Sender: TObject);
begin
  oFontDialog.Font := panFields.Font;
  oFontDialog.Background := panFields.Color;
  oFontDialog.ChangeStyle := FALSE;
  if oFontDialog.Execute then begin
    panFields.Font.Assign(oFontDialog.Font);
    panHighlight.Font.Name := oFontDialog.Font.Name;
    panMultiSelect.Font.Name := oFontDialog.Font.Name;
    panHighlight.Font.Size := oFontDialog.Font.Size;
    panMultiSelect.Font.Size := oFontDialog.Font.Size;
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnHighlightFontClick(Sender: TObject);
begin
  oFontDialog.Font := panHighlight.Font;
  oFontDialog.Background := panHighlight.Color;
  oFontDialog.ChangeName := FALSE;
  oFontDialog.ChangeSize := FALSE;
  if oFontDialog.Execute then begin
    panHighlight.Font.Style := oFontDialog.Font.Style;
    panHighlight.Font.Color := oFontDialog.Font.Color;
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnMultiSelectFontClick(Sender: TObject);
begin
  oFontDialog.Font := panMultiSelect.Font;
  oFontDialog.Background := panMultiSelect.Color;
  oFontDialog.ChangeName := FALSE;
  oFontDialog.ChangeSize := FALSE;
  if oFontDialog.Execute then begin
    panMultiSelect.Font.Style := oFontDialog.Font.Style;
    panMultiSelect.Font.Color := oFontDialog.Font.Color;
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnFieldColourClick(Sender: TObject);
begin
  ColorDialog.Color := panFields.Color;
  if ColorDialog.Execute then begin
    panFields.Color := ColorDialog.Color;
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnHighlightColourClick(Sender: TObject);
begin
  ColorDialog.Color := panHighlight.Color;
  if ColorDialog.Execute then begin
    panHighlight.Color := ColorDialog.Color;
  end;{if}
end;

procedure TFrmEditSettingsEnt.btnMultiSelectColourClick(Sender: TObject);
begin
  ColorDialog.Color := panMultiSelect.color;
  if ColorDialog.Execute then begin
    panMultiSelect.color := ColorDialog.Color;
  end;{if}
end;

end.
