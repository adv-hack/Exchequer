unit EditFields;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmEditFields = class(TForm)
    Shape5: TShape;
    Label11: TLabel;
    colFieldsFont: TColorBox;
    btnClose: TButton;
    cmbFieldsStyle: TComboBox;
    cmbFieldsFont: TComboBox;
    cmbFieldsSize: TComboBox;
    Label9: TLabel;
    colFieldsBack: TColorBox;
    Shape1: TShape;
    procedure FormShow(Sender: TObject);
    procedure cmbFieldsFontChange(Sender: TObject);
    procedure cmbFieldsSizeChange(Sender: TObject);
    procedure cmbFieldsStyleChange(Sender: TObject);
    procedure colFieldsFontChange(Sender: TObject);
    procedure colFieldsBackChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnRestoreDefaultsClick(Sender: TObject);
  private
    { Private declarations }
  public
    FrmParent : TForm;
    procedure LoadProperties;
  end;

var
  frmEditFields: TfrmEditFields;

implementation
uses
  APIUtil, FontProc, EditSett;

{$R *.dfm}

procedure TfrmEditFields.LoadProperties;
begin
  cmbFieldsFont.Items := Screen.Fonts;

  with TFrmEditSettings(FrmParent) do begin
    colFieldsFont.Selected := edCode.Font.color;
    cmbFieldsFont.ItemIndex := cmbFieldsFont.Items.IndexOf(edCode.Font.Name);
    BuildFontSizeList(TStringList(cmbFieldsSize.Items), cmbFieldsFont.Text);
    cmbFieldsSize.ItemIndex := cmbFieldsSize.Items.IndexOf(IntToStr(edCode.Font.Size));
    cmbFieldsStyle.ItemIndex := GetFontStyleIndexFrom(edCode.Font);
    colFieldsBack.Selected := edCode.Color;
  end;{with}
end;

procedure TfrmEditFields.FormShow(Sender: TObject);
begin
  LoadProperties;
end;

procedure TfrmEditFields.cmbFieldsFontChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.Name := cmbFieldsFont.Items[cmbFieldsFont.itemindex];
    edDate.Font.Name := cmbFieldsFont.Items[cmbFieldsFont.itemindex];
    memName.Font.Name := cmbFieldsFont.Items[cmbFieldsFont.itemindex];

    cmbFieldsSize.ItemIndex := BuildFontSizeList(TStringList(cmbFieldsSize.Items), edCode.Font.Name);
    cmbFieldsSizeChange(cmbFieldsSize);

    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFields.cmbFieldsSizeChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.Size := StrToIntDef(cmbFieldsSize.Text,8);
    edDate.Font.Size := edCode.Font.Size;
    memName.Font.Size := edCode.Font.Size;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFields.cmbFieldsStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.Style := GetFontStyleFromIndex(cmbFieldsStyle.itemindex);
    edDate.Font.Style := edCode.Font.Style;
    memName.Font.Style := edCode.Font.Style;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFields.colFieldsFontChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.color := colFieldsFont.Selected;
    edDate.Font.color := colFieldsFont.Selected;
    memName.Font.color := colFieldsFont.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFields.colFieldsBackChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.color := colFieldsBack.Selected;
    edDate.color := colFieldsBack.Selected;
    memName.color := colFieldsBack.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFields.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditFields.btnRestoreDefaultsClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to restore the default fonts ?',mtConfirmation,[mbYes,mbNo],mbNo,'Restore Defaults') = mrYes then begin
    cmbFieldsFont.ItemIndex := cmbFieldsFont.Items.IndexOf('Arial');
    cmbFieldsFontChange(cmbFieldsFont);
    BuildFontSizeList(TStringList(cmbFieldsSize.Items), cmbFieldsFont.Text);
    cmbFieldsSize.ItemIndex := cmbFieldsSize.Items.IndexOf('8');
    cmbFieldsSizeChange(cmbFieldsSize);
    cmbFieldsStyle.ItemIndex := 0;
    cmbFieldsStyleChange(cmbFieldsStyle);
    colFieldsFont.Selected := clBlack;
    colFieldsFontChange(colFieldsFont);
    colFieldsBack.Selected := clWhite;
    colFieldsBackChange(colFieldsBack);
  end;{if}
end;

end.
