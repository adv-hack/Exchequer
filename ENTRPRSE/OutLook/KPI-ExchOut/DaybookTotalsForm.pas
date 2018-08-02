unit DaybookTotalsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TEditVal, ExtCtrls, TDaybookTotalsClass, ComObj, Activex, Enterprise01_TLB,
  CTKUtil, AdvGlowButton, AdvCombo, ColCombo, AdvOfficePager,
  AdvOfficePagerStylers, KPICommon;

type
  TfrmTotals = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    AdvOfficePage: TAdvOfficePage;
    btnClose: TAdvGlowButton;
    pnlInfo: TPanel;
    lblInfo: TLabel;
    pnlRounded: TPanel;
    CurrFLab: Label8;
    Tot1Lab: Label8;
    Tot2Lab: Label8;
    Tot3Lab: Label8;
    Tot4Lab: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel4: TBevel;
    Bevel5: TBevel;
    Label81: Label8;
    ceToday: TCurrencyEdit;
    ceVAT: TCurrencyEdit;
    ceNet: TCurrencyEdit;
    ceTotal: TCurrencyEdit;
    ceOutstanding: TCurrencyEdit;
    ccbCurrency: TColumnComboBox;
    OfficeStyler: TAdvOfficePagerOfficeStyler;
    Bevel3: TBevel;
    Bevel6: TBevel;
    pnlDLLDetails: TPanel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure cbCurrencyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pnlDLLDetailsClick(Sender: TObject);
    procedure pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    FTLAList:  TTLAList;
    FTLAix:    integer;
    FDataPath: ShortString;
    FCurrency: integer;
    FPrevCurr: integer;
    FOnRefreshData: TOnRefreshDataProc;
    procedure PopulateBoxes;
    procedure PopulateCurrencyList;
    procedure ChangeCaption;
    procedure MakeRounded(Control: TWinControl);
  public
    { Public declarations }
    property OnRefreshData: TOnRefreshDataProc read FOnRefreshData write FOnRefreshData;
  end;

procedure ShowTotalsForm(ATLAList: TTLAList; ATLAix: integer;
  ADataPath: ShortString; ACurrency: integer; RefreshDataProc: TOnRefreshDataProc);

implementation

{$R *.dfm}

var
  frmTotals: TfrmTotals;

procedure ShowTotalsForm(ATLAList: TTLAList; ATLAix: integer; ADataPath: ShortString;
  ACurrency: integer; RefreshDataProc: TOnRefreshDataProc);
begin
//  ShowMessage(format('Currency = %d', [ACurrency]));
  with frmTotals do begin
    FTLAList  := ATLAList;
    FTLAix    := ATLAix;
    FDataPath := ADataPath;
    FCurrency := ACurrency;
    FPrevCurr := ACurrency; // v004
    PopulateCurrencyList;
    ccbCurrency.ItemIndex := ACurrency; // v004
    PopulateBoxes;
    OnRefreshData := RefreshDataProc;
    Show;
  end;
end;

procedure TfrmTotals.ChangeCaption;
begin
  caption := format('%s %s Daybook Totals', [FTLAList[FTLAix].SalesPurchase, TLADesc[FTLAix]]);
  lblInfo.Caption := caption;
end;

procedure TfrmTotals.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action    := caHide;
end;

procedure TfrmTotals.PopulateBoxes;
begin
  ChangeCaption;
  with FTLAList[FTLAix] do begin
    ceToday.Value       := Today;
    ceOutstanding.Value := OS;
    ceNet.Value         := TotalNet;
    ceVAT.Value         := TotalVAT;
    ceTotal.Value       := Total;
  end;
end;

procedure TfrmTotals.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmTotals.PopulateCurrencyList;
var
  Toolkit: IToolkit;
  i: integer;
begin
  if ccbCurrency.Items.Count > 0 then EXIT;

  Toolkit := OpenToolkit(FDataPath, true);
  if not assigned(Toolkit) then begin
    ShowMessage('Unable to create COM toolkit');
    EXIT;
  end;

  try
    with Toolkit.SystemSetup do
      for i := 0 to 89 do
//        if trim(ssCurrency[i].scSymbol) <> '' then // the user might leave gaps in the list
        with ccbCurrency.ComboItems.Add do
          if trim(ssCurrency[i].scSymbol) = #156 then
            strings.Add ('£')
          else
            strings.Add (ssCurrency[i].scSymbol);
    ccbCurrency.ItemIndex := FCurrency;
    FPrevCurr            := FCurrency;
  finally
    Toolkit := nil;
  end;
end;

procedure TfrmTotals.cbCurrencyChange(Sender: TObject);
var
  Toolkit: IToolkit;
begin
  if FPrevCurr = ccbCurrency.ItemIndex then
    EXIT;
  OnRefreshData(ccbCurrency.ItemIndex);
  PopulateBoxes;
  FPrevCurr := ccbCurrency.ItemIndex;
end;

procedure TfrmTotals.FormCreate(Sender: TObject);
begin
  AdvOfficePage.TabVisible := false;
  MakeRounded(self);
  MakeRounded(pnlRounded);
end;

procedure TfrmTotals.MakeRounded(Control: TWinControl);
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

procedure TfrmTotals.pnlDLLDetailsClick(Sender: TObject);
begin
  ShowDLLDetails(Sender, pnlDLLDetails.Color, true);
end;

procedure TfrmTotals.pnlInfoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = SC_MOVE + HTCAPTION; // = $F012
begin
  if Button = mbLeft then begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

initialization
begin
  frmTotals := TfrmTotals.Create(nil); // this gets called when Outlook creates the KPI Host and the KPI Host creates this COM object.
                                       // Outlook destroys and re-creates the KPI Host several times
                                       // E.g. This unit gets Finalized and Re-Initialized if you are viewing Outlook Today and
                                       // open and close the Outlook options dialog.
                                       // Initialization of this unit occurs before TDayBookTotals.Initialize gets called.
end;

finalization
  if assigned(frmTotals) then
    frmTotals.free;

end.
