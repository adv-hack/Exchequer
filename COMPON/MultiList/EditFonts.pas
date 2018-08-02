unit EditFonts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, FontProc;

type
  TfrmEditFonts = class(TForm)
    Label10: TLabel;
    cmbListMainFont: TComboBox;
    cmbListMainSize: TComboBox;
    cmbListMainStyle: TComboBox;
    Label12: TLabel;
    Label13: TLabel;
    lMultiSelect: TLabel;
    colListMain: TColorBox;
    ColListHeader: TColorBox;
    ColListHighlight: TColorBox;
    Shape1: TShape;
    colMultiSelect: TColorBox;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    btnClose: TButton;
    lLHFont: TLabel;
    lLHSize: TLabel;
    lLMSFont: TLabel;
    lLMSSize: TLabel;
    cmbListHeaderStyle: TComboBox;
    cmbListHighlightStyle: TComboBox;
    cmbListMultiSelectStyle: TComboBox;
    cmbListHeaderFont: TComboBox;
    cmbListHeaderSize: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    panFields: TPanel;
    Shape5: TShape;
    Label11: TLabel;
    colFields: TColorBox;
    cmbFieldsStyle: TComboBox;
    cmbFieldsFont: TComboBox;
    cmbFieldsSize: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure colListMainChange(Sender: TObject);
    procedure ColListHeaderChange(Sender: TObject);
    procedure ColListHighlightChange(Sender: TObject);
    procedure colMultiSelectChange(Sender: TObject);
    procedure colFieldsChange(Sender: TObject);
    procedure cmbListMainFontChange(Sender: TObject);
    procedure cmbListHeaderFontChange(Sender: TObject);
    procedure cmbFieldsFontChange(Sender: TObject);
    procedure cmbListMainStyleChange(Sender: TObject);
    procedure cmbListHeaderStyleChange(Sender: TObject);
    procedure cmbListHighlightStyleChange(Sender: TObject);
    procedure cmbListMultiSelectStyleChange(Sender: TObject);
    procedure cmbFieldsStyleChange(Sender: TObject);
    procedure cmbListMainSizeChange(Sender: TObject);
    procedure cmbListHeaderSizeChange(Sender: TObject);
    procedure cmbFieldsSizeChange(Sender: TObject);
    procedure btnRestoreDefaultsClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private

  public
    FrmParent : TForm;
    procedure LoadProperties;
  end;

{var
  frmEditFonts: TfrmEditFonts;}

implementation
uses
  APIUtil, EditSett;

{$R *.dfm}

procedure TfrmEditFonts.LoadProperties;
begin
  cmbListMainFont.Items := Screen.Fonts;
  cmbListHeaderFont.Items := Screen.Fonts;
  cmbFieldsFont.Items := Screen.Fonts;

  with TFrmEditSettings(FrmParent) do begin

    panFields.Visible := edCode.Visible;

    if not panFields.Visible then self.Height := 315;

    colListMain.Selected := mlExample.Font.Color;
    colListHeader.Selected := mlExample.HeaderFont.Color;
    colListHighlight.Selected := mlExample.HighlightFont.Color;
    colMultiSelect.Selected := mlExample.MultiSelectFont.Color;
    colFields.Selected := edCode.Font.color;

    cmbListMainFont.ItemIndex := cmbListMainFont.Items.IndexOf(mlExample.Font.Name);
    cmbListHeaderFont.ItemIndex := cmbListHeaderFont.Items.IndexOf(mlExample.HeaderFont.Name);
    cmbFieldsFont.ItemIndex := cmbFieldsFont.Items.IndexOf(edCode.Font.Name);

    BuildFontSizeList(TStringList(cmbListMainSize.Items), cmbListMainFont.Text);
    BuildFontSizeList(TStringList(cmbListHeaderSize.Items), cmbListHeaderFont.Text);
    BuildFontSizeList(TStringList(cmbFieldsSize.Items), cmbFieldsFont.Text);

    cmbListMainSize.ItemIndex := cmbListMainSize.Items.IndexOf(IntToStr(mlExample.Font.Size));
    cmbListHeaderSize.ItemIndex := cmbListHeaderSize.Items.IndexOf(IntToStr(mlExample.HeaderFont.Size));
    cmbFieldsSize.ItemIndex := cmbFieldsSize.Items.IndexOf(IntToStr(edCode.Font.Size));

    cmbListMainStyle.ItemIndex := GetFontStyleIndexFrom(mlExample.Font);
    cmbListHeaderStyle.ItemIndex := GetFontStyleIndexFrom(mlExample.HeaderFont);
    cmbListHighlightStyle.ItemIndex := GetFontStyleIndexFrom(mlExample.HighlightFont);
    cmbListMultiSelectStyle.ItemIndex := GetFontStyleIndexFrom(mlExample.MultiSelectFont);
    cmbFieldsStyle.ItemIndex := GetFontStyleIndexFrom(edCode.Font);

    lMultiSelect.Enabled := mlExample.Options.MultiSelection;
    lLMSFont.Enabled := mlExample.Options.MultiSelection;
    lLMSSize.Enabled := mlExample.Options.MultiSelection;
    cmbListMultiSelectStyle.Enabled := mlExample.Options.MultiSelection;
    colMultiSelect.Enabled := mlExample.Options.MultiSelection;

  end;{with}

  cmbListMainFontChange(self);
  cmbListMainSizeChange(self);
end;

procedure TfrmEditFonts.FormShow(Sender: TObject);
begin
  LoadProperties;
end;

procedure TfrmEditFonts.colListMainChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.Font.Color := colListMain.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.ColListHeaderChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HeaderFont.Color := colListHeader.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.ColListHighlightChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HighlightFont.Color := colListHighlight.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.colMultiSelectChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.MultiSelectFont.Color := colMultiSelect.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.colFieldsChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.color := colFields.Selected;
    edDate.Font.color := colFields.Selected;
    memName.Font.color := colFields.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbListMainFontChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.Font.Name := cmbListMainFont.Items[cmbListMainFont.itemindex];
    mlExample.HighlightFont.Name := mlExample.Font.Name;
    mlExample.MultiSelectFont.Name := mlExample.Font.Name;
    if TWinControl(Sender).Name = 'cmbListMainFont' then mlExample.RefreshList;

    lLHFont.Caption := mlExample.Font.Name;
    lLMSFont.Caption := lLHFont.Caption;

    cmbListMainSize.ItemIndex := BuildFontSizeList(TStringList(cmbListMainSize.Items), lLHFont.Caption);
    cmbListMainSizeChange(sender);
  end;{with}
end;

procedure TfrmEditFonts.cmbListHeaderFontChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HeaderFont.Name := cmbListHeaderFont.Items[cmbListHeaderFont.itemindex];
    mlExample.RefreshList;

    cmbListHeaderSize.ItemIndex := BuildFontSizeList(TStringList(cmbListHeaderSize.Items), mlExample.HeaderFont.Name);
    cmbListHeaderSizeChange(cmbListHeaderSize);
  end;{with}
end;

procedure TfrmEditFonts.cmbFieldsFontChange(Sender: TObject);
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

procedure TfrmEditFonts.cmbListMainStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.Font.Style := GetFontStyleFromIndex(cmbListMainStyle.itemindex);
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbListHeaderStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HeaderFont.Style := GetFontStyleFromIndex(cmbListHeaderStyle.itemindex);
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbListHighlightStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HighlightFont.Style := GetFontStyleFromIndex(cmbListHighlightStyle.itemindex);
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbListMultiSelectStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.MultiSelectFont.Style := GetFontStyleFromIndex(cmbListMultiSelectStyle.itemindex);
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbFieldsStyleChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.Style := GetFontStyleFromIndex(cmbFieldsStyle.itemindex);
    edDate.Font.Style := edCode.Font.Style;
    memName.Font.Style := edCode.Font.Style;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbListMainSizeChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.Font.size := StrToIntDef(cmbListMainSize.Text,8);
    mlExample.HighlightFont.size := mlExample.Font.size;
    mlExample.MultiSelectFont.size := mlExample.Font.size;
    if TWinControl(Sender).Name = 'cmbListMainSize' then mlExample.RefreshList;

    lLHSize.Caption := IntToStr(StrToIntDef(cmbListMainSize.Text,8));
    lLMSSize.Caption := lLHSize.Caption;
  end;{with}
end;

procedure TfrmEditFonts.cmbListHeaderSizeChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.HeaderFont.size := StrToIntDef(cmbListHeaderSize.Text,8);
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.cmbFieldsSizeChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.Font.Size := StrToIntDef(cmbFieldsSize.Text,8);
    edDate.Font.Size := edCode.Font.Size;
    memName.Font.Size := edCode.Font.Size;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditFonts.btnRestoreDefaultsClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to restore the default fonts ?',mtConfirmation,[mbYes,mbNo],mbNo,'Restore Defaults') = mrYes then begin
    cmbListMainFont.ItemIndex := cmbListMainFont.Items.IndexOf('Arial');
    cmbListMainFontChange(cmbListMainFont);
    cmbListHeaderFont.ItemIndex := cmbListHeaderFont.Items.IndexOf('Arial');
    cmbListHeaderFontChange(cmbListHeaderFont);
    cmbFieldsFont.ItemIndex := cmbFieldsFont.Items.IndexOf('Arial');
    cmbFieldsFontChange(cmbFieldsFont);

    BuildFontSizeList(TStringList(cmbListMainSize.Items), cmbListMainFont.Text);
    BuildFontSizeList(TStringList(cmbListHeaderSize.Items), cmbListHeaderFont.Text);
    BuildFontSizeList(TStringList(cmbFieldsSize.Items), cmbFieldsFont.Text);

    cmbListMainSize.ItemIndex := cmbListMainSize.Items.IndexOf('8');
    cmbListMainSizeChange(cmbListMainSize);
    cmbListHeaderSize.ItemIndex := cmbListHeaderSize.Items.IndexOf('8');
    cmbListHeaderSizeChange(cmbListHeaderSize);
    cmbFieldsSize.ItemIndex := cmbFieldsSize.Items.IndexOf('8');
    cmbFieldsSizeChange(cmbFieldsSize);

    cmbListMainStyle.ItemIndex := 0;
    cmbListMainStyleChange(cmbListMainStyle);
    cmbListHeaderStyle.ItemIndex := 0;
    cmbListHeaderStyleChange(cmbListHeaderStyle);
    cmbListHighlightStyle.ItemIndex := 0;
    cmbListHighlightStyleChange(cmbListHighlightStyle);
    cmbListMultiSelectStyle.ItemIndex := 0;
    cmbListMultiSelectStyleChange(cmbListMultiSelectStyle);
    cmbFieldsStyle.ItemIndex := 0;
    cmbFieldsStyleChange(cmbFieldsStyle);

    with TFrmEditSettings(FrmParent) do begin
      colListMain.Selected := clBlack;
      mlExample.Font.Color := colListMain.Selected;

      colListHeader.Selected := clBlack;
      mlExample.HeaderFont.Color := colListHeader.Selected;

      colListHighlight.Selected := clWhite;
      mlExample.HighlightFont.Color := colListHighlight.Selected;

      colMultiSelect.Selected := clWhite;
      mlExample.MultiSelectFont.Color := colMultiSelect.Selected;
    end;

    colFields.Selected := clBlack;
    colFieldsChange(colFields);
  end;{if}
end;

procedure TfrmEditFonts.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
