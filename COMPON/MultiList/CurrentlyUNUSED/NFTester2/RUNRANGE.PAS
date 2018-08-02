unit RunRange;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, Reports, CardProc, NeilProc, VarConst,
  ANIMATE, APIUtil;

type
  TRangeFormMode = (fmPosting, fmPostingDetail, fmGroupSales, fmEODReports
  , fmDownLoadDepts, fmDownLoadPLUs, fmPLUSales, fmTillGroupSales
  , fmNewTillGroupSales, fmHourlySales, fmClerkSales, fmTXTotalisers
  , fmAllTillReports);

  TFrmRunNoRange = class(TForm)
    lText: TLabel;
    Bevel1: TBevel;
    lStart: TLabel;
    edStart: TCurrencyEdit;
    lEnd: TLabel;
    edEnd: TCurrencyEdit;
    btnCancel: TButton;
    btnOK: TButton;
    panTillDetails: TPanel;
    Bevel2: TBevel;
    Label1: TLabel;
    rbAllTills: TRadioButton;
    Bevel3: TBevel;
    rbSelectedTill: TRadioButton;
    cmbTills: TComboBox;
    GolfBall: TAnimated;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbSelectedTillClick(Sender: TObject);
  private
    { Private declarations }
  public
    iStart, iEnd : integer;
    RangeFormMode : TRangeFormMode;
  end;

{var
  FrmRunNoRange: TFrmRunNoRange;}

implementation

{$R *.DFM}

procedure TFrmRunNoRange.btnOKClick(Sender: TObject);
var
  iTillNo : byte;
begin
  iStart := StrToInt(edStart.Text);
  iEnd := StrToInt(edEnd.Text);
  if iStart > iEnd then
    begin
      MsgBox('Please input a valid range', mtError,[mbOK],mbOK,'Invalid Range');
      ModalResult := mrNone;
    end
  else begin
    with ModReports do begin
      case RangeFormMode of
        fmPostingDetail, fmPosting, fmGroupSales, fmEODReports, fmPLUSales
        , fmTillGroupSales, fmNewTillGroupSales, fmHourlySales, fmClerkSales
        , fmTXTotalisers, fmAllTillReports : begin
          SetRunNumbers(iStart, iEnd);
          case RangeFormMode of
            fmPosting : PrintEODPosting(FALSE);
            fmPostingDetail : PrintEODPosting(TRUE);
            fmGroupSales : PrintGroupSales;

            fmEODReports : begin
              {$IFNDEF CARDTK}
                PrintEODReports(iStart, iEnd, FALSE, FALSE);
{                If (Not Syss.HideEODLog) Then PrintEODLogs;}
              {$ENDIF};
            end;

            fmTXTotalisers : PrintTXTotalisers;


            {Reports by Till No}
            fmClerkSales, fmHourlySales, fmPLUSales, fmTillGroupSales
            , fmNewTillGroupSales, fmAllTillReports : begin
              if rbAllTills.Checked then iTillNo := 0
              else iTillNo := cmbTills.ItemIndex + 1;

              case RangeFormMode of
                fmPLUSales : PrintPLUSales(iTillNo);
                fmTillGroupSales : PrintTillGroupSales(iTillNo);
                fmNewTillGroupSales : PrintNewTillGroupSales(iTillNo);
                fmHourlySales : PrintHourlySales(iTillNo);
                fmClerkSales : PrintClerkSales(iTillNo);

                fmAllTillReports : begin
                  bConsolidate := TRUE;
                  PrintPLUSales(iTillNo);
                  PrintTillGroupSales(iTillNo);
                  PrintHourlySales(iTillNo);
                  PrintClerkSales(iTillNo);
                  PrintTXTotalisers;
                  bConsolidate := FALSE;
                end;

              end;{case}
            end;
          end;{case}
        end;
      end;{case}
    end;{with}
  end;{if}
end;

procedure TFrmRunNoRange.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmRunNoRange.FormShow(Sender: TObject);
var
  iTill : byte;
begin
  edStart.displayformat := '#########0'; {cos this gets reset @ run-time - nice}
  edEnd.displayformat := '#########0'; {cos this gets reset @ run-time - nice}
  case RangeFormMode of
    {Reports}
    fmTXTotalisers, fmPostingDetail, fmPosting, fmGroupSales, fmEODReports : begin
      ClientHeight := 134;
      panTillDetails.Visible := FALSE;
      lText.Caption := ' Run Number Range ';
      case RangeFormMode of
        fmPosting : begin
          Caption := 'EOD Posting Report';
          HelpContext := 38;
        end;

        fmPostingDetail : begin
          Caption := 'EOD Detailed Posting Report';
          HelpContext := 38;
        end;

        fmGroupSales : begin
          Caption := 'Group Sales Report';
          HelpContext := 36;
        end;

        fmEODReports : begin
          Caption := 'End of Day Reports';
          HelpContext := 30;
        end;

        fmTXTotalisers : begin
          Caption := 'Transaction Totals Report';
          HelpContext := 59;
        end;
      end;{case}
      edStart.Text := IntToStr(GetLastRunNo);
      edEnd.Text := edStart.Text;
    end;

    {SAM Reports}
    fmClerkSales, fmHourlySales, fmPLUSales, fmTillGroupSales, fmNewTillGroupSales
    , fmAllTillReports  : begin
      edStart.Text := IntToStr(GetLastRunNo);
      edEnd.Text := edStart.Text;
      ClientHeight := 246;
      panTillDetails.Visible := TRUE;
      for iTill := 1 to Syss.NoTills do cmbTills.Items.Add(IntToStr(iTill) + ' : ' + Syss.Till[iTill].Name);
      cmbTills.ItemIndex := 0;

      case RangeFormMode of
        fmPLUSales : begin
          Caption := 'PLU Sales Report';
          HelpContext := 55;
        end;

        fmTillGroupSales, fmNewTillGroupSales : begin
          Caption := 'Till Group Sales Report';
          HelpContext := 56;
        end;

        fmHourlySales : begin
          Caption := 'Hourly Sales Report';
          HelpContext := 57;
        end;

        fmClerkSales : begin
          Caption := 'Clerk Sales Report';
          HelpContext := 58;
        end;

        fmAllTillReports : begin
          Caption := 'Print All Till Reports';
          HelpContext := 55;
        end;
      end;{case}
    end;

    {DownLoads}
    fmDownLoadDepts, fmDownLoadPLUs : begin
      ClientHeight := 134;
      panTillDetails.Visible := FALSE;

      edStart.Text := IntToStr(iStart);
      edEnd.Text := IntToStr(iEnd);
      case RangeFormMode of
        fmDownLoadDepts : begin
          lText.Caption := ' Department Numbers Range ';
          Caption := 'Upload Departments';
        end;

        fmDownLoadPLUs : begin
          lText.Caption := ' PLU Number Range ';
          Caption := 'Upload PLUs';
        end;
      end;{case}
      HelpContext := 18;
    end;
  end;{case}
  GolfBall.Play := TRUE;
end;

procedure TFrmRunNoRange.rbSelectedTillClick(Sender: TObject);
begin
  cmbTills.Enabled := rbSelectedTill.Checked; 
end;

end.
