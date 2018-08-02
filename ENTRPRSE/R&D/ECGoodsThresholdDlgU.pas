unit ECGoodsThresholdDlgU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GlobVar, ReportAU, ExWrap1U, TEditVal;

type
  TTotalsEvent = procedure (StartDate, EndDate: LongDate; Totals: TECTotals;
                            QuarterPos, Quarter: Integer) of object;

  TQtrControls = record
    CaptionLbl: TLabel;
    ValueEdt: TCurrencyEdit;
    StatusLbl: TStaticText;
  end;

  TThresholdCalculator = class(TObject)
  private
    ECReport: ^TECVATReport;
    BaseKey: Str255;
    Key: Str255;
    Cancelled: Boolean;
    FOnTotals: TTotalsEvent;
    procedure FindFirstCustomer;
    function CustomerFound: Boolean;
    procedure FindNextCustomer;
    function IncludeCustomer: Boolean;
    procedure GoToPreviousQuarter;
    function Quarter: Integer;
  public
    StartDate: LongDate;
    EndDate:   LongDate;
    constructor Create;
    destructor Destroy; override;
    procedure Execute;
    procedure Cancel;
    property OnTotals: TTotalsEvent read FOnTotals write FOnTotals;
  end;

  TECGoodsThresholdDlg = class(TForm)
    CurrentThresholdLbl: TLabel;
    QtrNowLbl: TLabel;
    Qtr1Lbl: TLabel;
    Qtr2Lbl: TLabel;
    Qtr3Lbl: TLabel;
    Qtr4Lbl: TLabel;
    Label9: TLabel;
    InformationLbl: TLabel;
    OkBtn: TButton;
    Timer: TTimer;
    CurrentThresholdTxt: TCurrencyEdit;
    QtrNowEdt: TCurrencyEdit;
    Qtr1Edt: TCurrencyEdit;
    Qtr2Edt: TCurrencyEdit;
    Qtr3Edt: TCurrencyEdit;
    Qtr4Edt: TCurrencyEdit;
    QtrNowStatusLbl: TStaticText;
    Qtr1StatusLbl: TStaticText;
    Qtr2StatusLbl: TStaticText;
    Qtr3StatusLbl: TStaticText;
    Qtr4StatusLbl: TStaticText;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure ThresholdTotals(StartDate, EndDate: LongDate; Totals: TECTotals;
                              QuarterPos, Quarter: Integer);
  private
    { Private declarations }
    Calculator: TThresholdCalculator;
    Controls: array[0..4] of TQtrControls;
    Interrupted: Boolean;
    procedure CalculateThresholds;
  public
    { Public declarations }
    StartDate: LongDate;
    EndDate:   LongDate;
  end;

var
  ECGoodsThresholdDlg: TECGoodsThresholdDlg;

implementation

{$R *.dfm}

uses BtrvU2, VarConst, BtSupU1, ETDateU, ExBtTh1U, ETMiscU;

// =============================================================================
// TThresholdCalculator
// =============================================================================

procedure TThresholdCalculator.Cancel;
begin
  Cancelled := True;
end;

// -----------------------------------------------------------------------------

constructor TThresholdCalculator.Create;
begin
  inherited Create;
  New(ECReport, Create(self));
  if (not Assigned(RepExLocal)) then
    Create_ReportFiles;
  ECReport^.MTExLocal := RepExLocal;
end;

// -----------------------------------------------------------------------------

function TThresholdCalculator.CustomerFound: Boolean;
begin
  Result := (StatusOk and (Checkkey(BaseKey, Key, Length(BaseKey), BOn)));
end;

// -----------------------------------------------------------------------------

destructor TThresholdCalculator.Destroy;
begin
  if (Assigned(ECReport)) then
  begin
    Dispose(ECReport, Destroy);
    ECReport := nil;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TThresholdCalculator.Execute;
var
  i: Integer;
  CustTotals: TECTotals;
  Totals: TECTotals;
begin
  for i := 0 to 4 do
  begin
    BaseKey   := TradeCode[True];
    Key       := BaseKey;
    Cancelled := False;
    Totals.Goods := 0.0;
    Totals.TriangulatedGoods := 0.0;
    Totals.Services := 0.0;
    Totals.TriangulatedServices := 0.0;
    ECReport.IncludeGoods := True;

    FindFirstCustomer;
    while CustomerFound and not Cancelled do
    begin
      if IncludeCustomer then
      begin
        ECReport.Calc_ECSales(Cust.CustCode, StartDate, EndDate, CustTotals);
        Totals.Goods := Totals.Goods + Trunc(CustTotals.Goods);
        Totals.TriangulatedGoods := Totals.TriangulatedGoods + Trunc(CustTotals.TriangulatedGoods);
      end;
      FindNextCustomer;
    end;

    if Assigned(FOnTotals) then
      OnTotals(StartDate, EndDate, Totals, i, Quarter);

    GoToPreviousQuarter;
  end;
end;

// -----------------------------------------------------------------------------

procedure TThresholdCalculator.FindFirstCustomer;
begin
  Status := Find_Rec(B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, CustCntyK, Key);
end;

// -----------------------------------------------------------------------------

procedure TThresholdCalculator.FindNextCustomer;
begin
  Status := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, CustCntyK, Key);
end;

// -----------------------------------------------------------------------------

procedure TThresholdCalculator.GoToPreviousQuarter;
var
  d, m, y: Word;
  NewDate: TDateTime;
begin
  DateStr(StartDate, d, m, y);
  NewDate := EncodeDate(y, m, d);
  NewDate := IncMonth(NewDate, -3);
  StartDate := FormatDateTime('yyyymmdd', NewDate);
  DateStr(EndDate, d, m, y);
  NewDate := EncodeDate(y, m, d);
  NewDate := IncMonth(NewDate, -3);
  EndDate := FormatDateTime('yyyymmdd', NewDate);
end;

// -----------------------------------------------------------------------------

function TThresholdCalculator.IncludeCustomer: Boolean;
begin
  Result := ((Cust.EECMember) and (Cust.CustSupp = TradeCode[True]));
end;

// -----------------------------------------------------------------------------

function TThresholdCalculator.Quarter: Integer;
var
  d, m, y: Word;
begin
  DateStr(StartDate, d, m, y);
  Result := ((m - 1) div 3) + 1;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TECGoodsThresholdDlg
// =============================================================================

procedure TECGoodsThresholdDlg.CalculateThresholds;
begin
  Calculator.StartDate := StartDate;
  Calculator.EndDate   := EndDate;
  Calculator.OnTotals  := ThresholdTotals;
  Calculator.Execute;
end;

// -----------------------------------------------------------------------------

procedure TECGoodsThresholdDlg.FormCreate(Sender: TObject);
begin
  Controls[0].CaptionLbl := QtrNowLbl;
  Controls[0].ValueEdt   := QtrNowEdt;
  Controls[0].StatusLbl  := QtrNowStatusLbl;
  Controls[1].CaptionLbl := Qtr1Lbl;
  Controls[1].ValueEdt   := Qtr1Edt;
  Controls[1].StatusLbl  := Qtr1StatusLbl;
  Controls[2].CaptionLbl := Qtr2Lbl;
  Controls[2].ValueEdt   := Qtr2Edt;
  Controls[2].StatusLbl  := Qtr2StatusLbl;
  Controls[3].CaptionLbl := Qtr3Lbl;
  Controls[3].ValueEdt   := Qtr3Edt;
  Controls[3].StatusLbl  := Qtr3StatusLbl;
  Controls[4].CaptionLbl := Qtr4Lbl;
  Controls[4].ValueEdt   := Qtr4Edt;
  Controls[4].StatusLbl  := Qtr4StatusLbl;
  Calculator := TThresholdCalculator.Create;

  CurrentThresholdTxt.Value := Round_Up(SyssVAT.VATRAtes.ECSalesThreshold, 0);

  Timer.Enabled := True;
end;

// -----------------------------------------------------------------------------

procedure TECGoodsThresholdDlg.FormDestroy(Sender: TObject);
begin
  Calculator.Free;
end;

// -----------------------------------------------------------------------------

procedure TECGoodsThresholdDlg.ThresholdTotals(StartDate, EndDate: LongDate;
  Totals: TECTotals; QuarterPos, Quarter: Integer);
var
  Value: Double;
  QuarterStr, YearStr, ValueStr: string;
begin
{  DebugList.Items.Add(IntToStr(Quarter) + ', ' + StartDate); }

  Value := Trunc(Totals.Goods + Totals.TriangulatedGoods);
  QuarterStr := 'Q' + IntToStr(Quarter);
  YearStr    := Copy(StartDate, 1, 4);

  Controls[QuarterPos].CaptionLbl.Caption := QuarterStr + ', ' + YearStr;
  Controls[QuarterPos].ValueEdt.Value := Value;

  if (Value > Trunc(SyssVAT.VATRAtes.ECSalesThreshold)) then
  begin
    Controls[QuarterPos].StatusLbl.Visible := True;
  end
  else
  begin
    Controls[QuarterPos].StatusLbl.Visible := False;
  end;

  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TECGoodsThresholdDlg.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := False;
  CalculateThresholds;
end;

// -----------------------------------------------------------------------------

end.
