unit vatReturnSummary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  vatReturnDBManager;

type
  TvatSummaryForm = class(TForm)
    Label21: TLabel;
    lblSubmissionStatus: TLabel;
    Label23: TLabel;
    lblCorrelationID: TLabel;
    btnClose: TButton;
    memoNarrative: TMemo;
    btnViewReturn: TButton;
    Label1: TLabel;
    lblSubmittedDate: TLabel;
    Label3: TLabel;
    lblVatPeriod: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnViewReturnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    fReturnRecord : TVATSubmissionRecord;
  public
    { Public declarations }
    procedure SetVATReturn(VATRecord : TVATSubmissionRecord);
  end;

var
  vatSummaryForm: TvatSummaryForm;

implementation

uses
  vatReturnDetail, vatUtils;

{$R *.dfm}

procedure TvatSummaryForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TvatSummaryForm.SetVATReturn(VATRecord : TVATSubmissionRecord);
begin
  fReturnRecord := VATRecord;

  // Set the field values
  self.lblVatPeriod.Caption        := FormatVatPeriod(fReturnRecord.vatPeriod);
  self.Caption := 'VAT 100 Submission Status - VAT Period ' + FormatVATPeriod(fReturnRecord.vatPeriod);
  self.lblSubmissionStatus.Caption := FormatSubmissionStatus(fReturnRecord.status);
  case fReturnRecord.status of
    StatusSubmitted:
      self.lblSubmissionStatus.Font.Color := clWindowText;
    StatusPending:
      self.lblSubmissionStatus.Font.Color := clBlue;
    StatusError:
      self.lblSubmissionStatus.Font.Color := clRed;
    StatusAccepted:
      self.lblSubmissionStatus.Font.Color := clGreen;
  end;
  self.lblSubmittedDate.Caption    := FormatSubmittedDate(fReturnRecord.dateSubmitted);
  self.lblCorrelationID.Caption    := fReturnRecord.correlationID;

  self.memoNarrative.Text := fReturnRecord.HMRCNarrative;
end;

procedure TvatSummaryForm.btnViewReturnClick(Sender: TObject);
begin
  // PKR. 09/09/2015. ABSEXCH-16834 Multiple copies of the Submissions window may be opened.
  // The same applies for the Detail form
  if not Assigned(frmVAT100ReturnDetail) then
  begin
    frmVAT100ReturnDetail := TfrmVAT100ReturnDetail.Create(self);
  end;
  frmVAT100ReturnDetail.SetVATReturn(fReturnRecord);
  frmVAT100ReturnDetail.Show;
end;

procedure TvatSummaryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  vatSummaryForm := nil;
end;

end.
