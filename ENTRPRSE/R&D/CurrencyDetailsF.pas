unit CurrencyDetailsF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, Mask, SBSPanel, ExtCtrls, uExDatasets,
  uBtrieveDataset, TCustom, uMultiList, uDBMultiList, EnterToTab;

type
  TDetailsMode = (dmAdd, dmEdit, dmView);

  TfrmCurrencyDetails = class(TForm)
    Panel2: TPanel;
    mlHistory: TDBMultiList;
    Label89: Label8;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    dsHistory: TBtrieveDataset;
    EnterToTab1: TEnterToTab;
    gbGeneral: TSBSGroup;
    Label81: Label8;
    Label82: Label8;
    edtDesc: Text8Pt;
    ceCurrNo: TCurrencyEdit;
    gbRates: TSBSGroup;
    Label85: Label8;
    Label86: Label8;
    ceDailyRate: TCurrencyEdit;
    ceCoRate: TCurrencyEdit;
    gbGhost: TSBSGroup;
    Label87: Label8;
    Label88: Label8;
    chkInvert: TCheckBox;
    chkFloat: TCheckBox;
    ceGhostRate: TCurrencyEdit;
    ceTriang: TCurrencyEdit;
    gbSymbol: TSBSGroup;
    Label83: Label8;
    Label84: Label8;
    edtScreen: Text8Pt;
    edtPrinter: Text8Pt;
    btnExport: TSBSButton;
    SaveDialog1: TSaveDialog;
    procedure dsHistoryGetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure ceDailyRateExit(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    FDetailsMode: TDetailsMode;
    FIsRevalue : Boolean;
    procedure SetDetailsMode(const Value: TDetailsMode);
  public
    { Public declarations }
    property DetailsMode : TDetailsMode read FDetailsMode write SetDetailsMode;
    property IsRevalue : Boolean read FIsRevalue write FIsRevalue;
  end;

var
  frmCurrencyDetails: TfrmCurrencyDetails;

implementation

uses
  CurrencyHistoryVar, EtDateU, MathUtil, GenWarnU, CurrncyU, CurrencyHistoryClass;

{$R *.dfm}


procedure TfrmCurrencyDetails.dsHistoryGetFieldValue(Sender: TObject;
  PData: Pointer; FieldName: String; var FieldValue: String);
var
  pDataRec : ^TCurrencyHistoryRec;
begin
  pDataRec := PData;

  Case FieldName[1] of
    'D'  : FieldValue := POutDate(pDataRec.chDateChanged);
    'V'  : FieldValue := Format('%8.6f', [pDataRec.chDailyRate]);
    'C'  : FieldValue := Format('%8.6f', [pDataRec.chCompanyRate]);
    'U'  : FieldValue := Trim(pDataRec.chUser);
  end;
end;

procedure TfrmCurrencyDetails.SetDetailsMode(const Value: TDetailsMode);
begin
  //Set status of controls according to whether we're Adding, Editing or Viewing and whether we're revaluing
  //As there is no documentation, the rules below are taken from how the existing currency dialog behaves.
  FDetailsMode := Value;

  //View mode - set buttons
  if (FDetailsMode = dmView) then
  begin
    btnOK.Caption := '&Close';
    btnOK.ModalResult := mrCancel;
    btnOK.Cancel := True;

    btnCancel.Visible := False;
  end;

  //Standard details - allow change unless view or revalue
  edtDesc.ReadOnly    := (FDetailsMode = dmView) or IsRevalue;
  edtScreen.ReadOnly  := (FDetailsMode = dmView) or IsRevalue;
  edtPrinter.ReadOnly := (FDetailsMode = dmView) or IsRevalue;

  //DailyRate - allow change unless view  (or currency is 1)
  ceDailyRate.ReadOnly := (FDetailsMode = dmView) or (ceCurrNo.Value = 1);

  //Company Rate - allow change only if Adding or revaluing (and not if currency = 1)
  //PR: 25/09/2012 ABSEXCH-13443 Add check for view mode (when revaluing)
  ceCoRate.ReadOnly := ((FDetailsMode <> dmAdd) and not IsRevalue) or (ceCurrNo.Value = 1) or (FDetailsMode = dmView);

  //Triangulation - allow change only if Adding or revaluing
  //PR: 25/09/2012 ABSEXCH-13443 Add check for view mode (when revaluing)
  chkInvert.Enabled := (FDetailsMode = dmAdd) or (IsRevalue and (FDetailsMode <> dmView));
  chkFloat.Enabled := chkInvert.Enabled;
  ceTriang.ReadOnly := not chkInvert.Enabled;
  ceGhostRate.ReadOnly := not chkInvert.Enabled;

end;

procedure TfrmCurrencyDetails.FormCreate(Sender: TObject);
begin
  FDetailsMode := dmView;
  FIsRevalue := False;
end;

procedure TfrmCurrencyDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  IsAProblem : Boolean;
begin
  //Logic copied from CheckCompleted function in SetCurrU.pas
  if (ModalResult = mrOK) and (Trim(edtDesc.Text) <> '') and (Trim(edtScreen.Text) <> '') then
  begin

    //Check that Daily Rate isn't zero. If we using a CompanyRate system, check that Company Rate isn't zero.
    IsAProblem := (ZeroFloat(ceCoRate.Value) and Not UseCoDayRate) or ZeroFloat(ceDailyRate.Value);

    //Check that we're not using triangulation or that the triangulation rate is not zero.
    if not IsAProblem and (not ZeroFloat(ceTriang.Value) or chkFloat.Checked) then
      IsAProblem := ZeroFloat(ceGhostRate.Value);

    CanClose := not IsAProblem;

    //Show error message copied from existing currencies dialog
    if not CanClose then
       CustomDlg(Application.MainForm,'WARNING!','Incorrect Currency Rate',
                             'At least one of the exchange rates for currency '+ edtDesc.Text + ' ('+ edtScreen.Text +') is zero.'+#13+#13+
                             'A zero exchange rate is not valid for a genuine currency.'+#13+
                             'Please correct before attempting to update the currency table.',
                             mtInformation,
                             [mbOk]);
  end;
end;

procedure TfrmCurrencyDetails.ceDailyRateExit(Sender: TObject);
begin
  //don't allow negative rates
  if Sender is TCurrencyEdit then
    with Sender as TCurrencyEdit do
      if Value < 0 then
        Value := Abs(Value);
end;

procedure TfrmCurrencyDetails.btnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    with TCurrencyHistory.Create do
    Try
      Index := chNumberK;
      ExportCurrencyHistory(SaveDialog1.Filename, Char(Trunc(ceCurrNo.Value)) + #0);
    Finally
      Free;
    End;
  end;
end;

end.
