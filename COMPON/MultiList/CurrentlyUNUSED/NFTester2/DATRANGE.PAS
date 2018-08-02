unit DatRange;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, BorBtns, Mask, TEditVal, NeilProc, VarConst,
  ANIMATE, StrUtil;

type
  TDateFormMode = (fmStatementDetail, fmStatementLedger, fmCardTurnover, fmLedgerHistory);

  TFrmDateRange = class(TForm)
    edFromDate: TEditDate;
    Label1: TLabel;
    edToDate: TEditDate;
    Label2: TLabel;
    Label3: TLabel;
    btnCancel: TBitBtn;
    btnRunReport: TBitBtn;
    bevel1: TBevel;
    panCheck: TPanel;
    Bevel2: TBevel;
    panNumbers: TPanel;
    Bevel3: TBevel;
    lStart: TLabel;
    edStart: TCurrencyEdit;
    lEnd: TLabel;
    edEnd: TCurrencyEdit;
    Bevel4: TBevel;
    rbAllCards: TRadioButton;
    rbCardRange: TRadioButton;
    GolfBall: TAnimated;
    chkDetailed: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure btnRunReportClick(Sender: TObject);
    constructor Create(NewFormMode : TDateFormMode);
    procedure rbCardRangeClick(Sender: TObject);
  private
    { Private declarations }
  public
    DateFormMode : TDateFormMode;
    sStartDate, sEndDate : string8;
    { Public declarations }
  end;

implementation

uses Reports;

{$R *.DFM}

procedure TFrmDateRange.FormShow(Sender: TObject);
begin
  edFromDate.DateValue := sStartDate;
  edToDate.DateValue := sEndDate;

  panCheck.Visible := DateFormMode in [fmStatementDetail, fmStatementLedger, fmCardTurnover];
  panNumbers.Visible := DateFormMode in [fmLedgerHistory];
  case DateFormMode of
    fmStatementDetail : begin
      Caption := 'Customer Statement';
      chkDetailed.Caption := 'Detailed Report ?';
      chkDetailed.Checked := FALSE;
      HelpContext := 10;
    end;

    fmStatementLedger : begin
      Caption := 'Customer Statement';
      chkDetailed.Caption := 'Detailed Report ?';
      chkDetailed.Checked := TRUE;
      HelpContext := 10;
    end;

    fmCardTurnover : begin
      Caption := 'Card Turnover';
      chkDetailed.Caption := 'Hide Zero Cards ?';
      chkDetailed.Checked := TRUE;
      HelpContext := 33;
    end;

    fmLedgerHistory : begin
      Caption := 'Ledger History';
      chkDetailed.Checked := TRUE;
      HelpContext := 37;
    end;
  end;{case}
  GolfBall.Play := TRUE;
end;

procedure TFrmDateRange.btnRunReportClick(Sender: TObject);
var
  iStart, iEnd : integer;
begin
  with ModReports do begin
    case DateFormMode of
      fmStatementDetail, fmStatementLedger : CardStatement(Cust, edFromDate.DateValue, edToDate.DateValue
      , chkDetailed.Checked);

      fmCardTurnover : CardTurnover(edFromDate.DateValue, edToDate.DateValue, chkDetailed.Checked);

      fmLedgerHistory : begin
        if rbAllCards.Checked then
          begin
            iStart := -1;
            iEnd := -1;
          end
        else begin
          iStart := StrToInt(edStart.Text);
          iEnd := StrToInt(edEnd.Text);
        end;{if}
        LedgerHistory(edFromDate.DateValue, edToDate.DateValue, iStart, iEnd);
      end;
    end;{case}
  end;{with}
end;

constructor TFrmDateRange.Create(NewFormMode : TDateFormMode);
begin
  inherited Create(Application);

  edStart.displayformat := '#########0'; {cos this gets reset @ run-time - nice}
  edEnd.displayformat := '#########0'; {cos this gets reset @ run-time - nice}

  DateFormMode := NewFormMode;
  case DateFormMode of
    fmStatementDetail, fmStatementLedger, fmCardTurnover : begin
      panCheck.Top := 120;
      panCheck.Left := 8;
      ClientHeight := 200;
    end;

    fmLedgerHistory : begin
      panNumbers.Top := 120;
      panNumbers.Left := 8;
      ClientHeight := 280;
    end;
  end;{case}
end;

procedure TFrmDateRange.rbCardRangeClick(Sender: TObject);
begin
  edStart.Enabled := rbCardRange.Checked;
  lStart.Enabled := rbCardRange.Checked;
  edEnd.Enabled := rbCardRange.Checked;
  lEnd.Enabled := rbCardRange.Checked;
end;

end.
