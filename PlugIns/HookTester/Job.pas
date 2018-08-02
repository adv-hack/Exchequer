unit Job;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, ValEdit, CustAbsU;

type
  TfrmJob = class(TForm)
    vlProperties: TValueListEditor;
    Panel1: TPanel;
    btnSaveEdits: TButton;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveEditsClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure FillProperties;
  public
    LJob : TAbsJob3;
    LHandlerID : integer;
  end;

var
  frmJob: TfrmJob;

implementation
uses
  MathUtil;

{$R *.dfm}

{ TfrmJob }

procedure TfrmJob.FillProperties;
begin
  with LJob do begin
    vlProperties.Values['jrJobCode'] := jrJobCode;
    vlProperties.Values['jrJobDesc'] := jrJobDesc;
    vlProperties.Values['jrJobFolio'] := IntToStr(jrJobFolio);
    vlProperties.Values['jrCustCode'] := jrCustCode;
    vlProperties.Values['jrJobCat'] := jrJobCat;
    vlProperties.Values['jrJobAltCode'] := jrJobAltCode;
    vlProperties.Values['jrCompleted'] := IntToStr(jrCompleted);
    vlProperties.Values['jrContact'] := jrContact;
    vlProperties.Values['jrJobMan'] := jrJobMan;
    vlProperties.Values['jrChargeType'] := IntToStr(jrChargeType);
    vlProperties.Values['jrQuotePrice'] := FloatToStr(jrQuotePrice);
    vlProperties.Values['jrCurrPrice'] := IntToStr(jrCurrPrice);
    vlProperties.Values['jrStartDate'] := jrStartDate;
    vlProperties.Values['jrEndDate'] := jrEndDate;
    vlProperties.Values['jrRevEDate'] := jrRevEDate;
    vlProperties.Values['jrSORRef'] := jrSORRef;
    vlProperties.Values['jrVATCode'] := jrVATCode;
    vlProperties.Values['jrDept'] := jrDept;
    vlProperties.Values['jrCostCentre'] := jrCostCentre;
    vlProperties.Values['jrJobAnal'] := jrJobAnal;
    vlProperties.Values['jrJobType'] := jrJobType;
    vlProperties.Values['jrJobStat'] := IntToStr(jrJobStat);
    vlProperties.Values['jrUserDef1'] := jrUserDef1;
    vlProperties.Values['jrUserDef2'] := jrUserDef2;
    vlProperties.Values['jrUserDef3'] := jrUserDef3;
    vlProperties.Values['jrUserDef4'] := jrUserDef4;
//    vlProperties.Values['jrActual'] := jrActual;
//    vlProperties.Values['jrBudget'] := jrBudget;
//    vlProperties.Values['jrRetention'] := jrRetention;
//    vlProperties.Values['jrDefRetentionCcy'] := jrDefRetentionCcy;
    vlProperties.Values['jrJPTRef'] := jrJPTRef;
    vlProperties.Values['jrJSTRef'] := jrJSTRef;
    vlProperties.Values['jrQSCode'] := jrQSCode;
  end;{with}

  btnSaveEdits.enabled := NumberIn(LHandlerID, [105038, 105039]);
end;

procedure TfrmJob.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmJob.btnSaveEditsClick(Sender: TObject);
begin
  with LJob do begin
    case LHandlerID of
      105038, 105039 : begin
        jrQSCode := vlProperties.Values['jrQSCode'];
      end;
    end;{case}
  end;{with}
  FillProperties;
end;

procedure TfrmJob.FormShow(Sender: TObject);
begin
  FillProperties;
end;

end.
