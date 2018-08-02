unit EditColours;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmEditColours = class(TForm)
    Label4: TLabel;
    colListBack: TColorBox;
    Label6: TLabel;
    Label7: TLabel;
    lMultiSelect: TLabel;
    colListHighlight: TColorBox;
    colMultiSelect: TColorBox;
    btnClose: TButton;
    Shape1: TShape;
    panFields: TPanel;
    Label9: TLabel;
    colFields: TColorBox;
    procedure colListBackChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure colListHighlightChange(Sender: TObject);
    procedure colMultiSelectChange(Sender: TObject);
    procedure colFieldsChange(Sender: TObject);
    procedure btnRestoreDefaultsClick(Sender: TObject);
  private

  public
    FrmParent : TForm;
    procedure LoadProperties;
  end;

{var
  frmEditColours: TfrmEditColours;}

implementation
uses
  APIUtil, EditSett;

{$R *.dfm}


procedure TfrmEditColours.colListBackChange(Sender: TObject);
var
  iCol : integer;
begin
  with TFrmEditSettings(FrmParent) do begin
    for iCol := 0 to mlExample.Columns.Count -1
    do mlExample.DesignColumns[iCol].Color := colListBack.selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditColours.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmEditColours.LoadProperties;
begin
  with TFrmEditSettings(FrmParent) do begin

    panFields.Visible := edCode.Visible;
    if not panFields.Visible then self.Height := 243;

    colListBack.Selected := mlExample.DesignColumns[0].Color;
    colListHighlight.Selected := mlExample.colours.Selection;
    colMultiSelect.Selected := mlExample.colours.MultiSelection;
    colFields.Selected := edCode.Color;

    colMultiSelect.Enabled := mlExample.Options.MultiSelection;
    lMultiSelect.Enabled := mlExample.Options.MultiSelection;
  end;{with}
end;

procedure TfrmEditColours.FormShow(Sender: TObject);
begin
  LoadProperties;
end;

procedure TfrmEditColours.colListHighlightChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.colours.Selection := colListHighlight.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditColours.colMultiSelectChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    mlExample.colours.MultiSelection := colMultiSelect.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditColours.colFieldsChange(Sender: TObject);
begin
  with TFrmEditSettings(FrmParent) do begin
    edCode.color := colFields.Selected;
    edDate.color := colFields.Selected;
    memName.color := colFields.Selected;
    mlExample.RefreshList;
  end;{with}
end;

procedure TfrmEditColours.btnRestoreDefaultsClick(Sender: TObject);
begin
  if MsgBox('Are you sure you want to restore the default colours ?',mtConfirmation,[mbYes,mbNo],mbNo,'Restore Defaults') = mrYes then begin
    colListBack.Selected := clWhite;
    colListBackChange(colListBack);

    colListHighlight.Selected := clNavy;
    colListHighlightChange(colListHighlight);

    colMultiSelect.Selected := clSkyBlue;
    colMultiSelectChange(colMultiSelect);

    colFields.Selected := clWhite;
    colFieldsChange(colFields);
  end;{if}
end;

end.
