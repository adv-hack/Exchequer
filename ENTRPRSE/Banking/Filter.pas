unit Filter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, Mask, TCustom, ExtCtrls, EnterToTab;

type

  TFilterBy = (fbDocType, fbAccount, fbRef, fbAmount, fbStatus, fbDate);

  TfrmFilterInput = class(TForm)
    Panel1: TPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    Label1: TLabel;
    lblFrom: TLabel;
    lblTo: TLabel;
    EnterToTab1: TEnterToTab;
    lblFormFilters: TLabel;
    pnlDocType: TPanel;
    cbTypeFrom: TComboBox;
    cbTypeTo: TComboBox;
    pnlAmount: TPanel;
    ceFrom: TCurrencyEdit;
    ceTo: TCurrencyEdit;
    pnlDate: TPanel;
    edDateFrom: TEditDate;
    edDateTo: TEditDate;
    pnlText: TPanel;
    pnlStatusCb: TPanel;
    Label4: TLabel;
    cbFrom: TComboBox;
    edtFrom: Text8Pt;
    edtTo: Text8Pt;
    cbFilterBy: TSBSComboBox;
    procedure cbFilterByChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtFromExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    FilterWanted : TFilterBy;
    procedure SetEdits;
  end;

var
  frmFilterInput: TfrmFilterInput;

implementation

{$R *.dfm}
uses
 Math, SbsComp2, ApiUtil, GlobVar, InvListU;

{ TfrmFilterInput }

procedure TfrmFilterInput.SetEdits;
begin
  FilterWanted := TFilterBy(cbFilterBy.ItemIndex);
  pnlStatusCb.Enabled := False;
  pnlDocType.Enabled := False;
  pnlText.Enabled := False;
  pnlDate.Enabled := False;
  pnlAmount.Enabled := False;
  lblFrom.Visible := True;
  lblTo.Visible := True;
  Case FilterWanted of
    fbDocType  :  begin
                     pnlDocType.Enabled := True;
                     pnlDocType.BringToFront;
                     ActiveControl := cbTypeFrom;
                  end;
    fbAccount,
    fbRef      :  begin
                     pnlText.Enabled := True;
                     pnlText.BringToFront;
                     ActiveControl := edtFrom;
                  end;
    fbAmount   :  begin
                     pnlAmount.Enabled := True;
                     pnlAmount.BringToFront;
                     ActiveControl := ceFrom;
                  end;
    fbDate     :  begin
                     pnlDate.Enabled := True;
                     pnlDate.BringToFront;
                     ActiveControl := edDateFrom;
                  end;
    fbStatus   :  begin
                    cbFrom.ItemIndex := 0;
                    pnlStatusCb.Enabled := True;
                    pnlStatusCb.BringToFront;
                    lblFrom.Visible := False;
                    lblTo.Visible := False;
                    ActiveControl := cbFrom;
                  end;
  end;
end;

procedure TfrmFilterInput.cbFilterByChange(Sender: TObject);
begin
  SetEdits;
end;

procedure TfrmFilterInput.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ModalResult = mrOK then
  begin
    if (Trim(edtTo.Text) = '') and (Trim(edtFrom.Text) <> '') then
      edtTo.Text := StringOfChar('Z', 20);
    if (ceTo.Value = 0.0) and (ceFrom.Value > 0.0) then
      ceTo.Value := MaxDouble;
  end;
  LastValueObj.UpdateAllLastValuesFull(Self);
end;

procedure TfrmFilterInput.FormCreate(Sender: TObject);
begin
  LastValueObj.GetAllLastValuesFull(Self);
end;

procedure TfrmFilterInput.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if (ActiveControl <> btnCancel) then
  begin
    Case FilterWanted of
      fbDocType..fbRef
         :   if edtFrom.Text > edtTo.Text then
             begin
               msgBox('The To value is before the From value - please correct this before continuing', mtWarning,
                      [mbOK], mbOK, 'Add Filter');
               CanClose := False;
             end;
      fbAmount
         :   if ceFrom.Value > ceTo.Value  then
             begin
               msgBox('The To value is before the From value - please correct this before continuing', mtWarning,
                      [mbOK], mbOK, 'Add Filter');
               CanClose := False;
             end;

      fbDate
         :   if (edDateFrom.DateValue > edDateTo.DateValue) then
             begin
               msgBox('The Date To is before the Date From - please correct this before continuing', mtWarning,
                         [mbOK], mbOK, 'Add Filter');
               CanClose := False;
             end;
    end; //Case
  end;
end;

procedure TfrmFilterInput.edtFromExit(Sender: TObject);
var
  AcCode : Str20;
begin
  if (FilterWanted = fbAccount) and (ActiveControl <> btnCancel) and (ActiveControl <> cbFilterBy) then
  with Sender as TExt8pt do
  begin
    AcCode := Trim(Text);
    if GetCust(Self, AcCode, AcCode, False, 99 {Cust & Supp}) then
      Text := AcCode
    else
      ActiveControl := Sender as TExt8Pt;
  end;
  if ActiveControl = btnOK then
end;

end.
