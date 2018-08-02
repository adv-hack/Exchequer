unit ReportCriteria;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, StdCtrls, CheckLst, ExtCtrls, uExDatasets, uComTKDataset
  , uMultiList, uDBMultiList, ComCtrls, BTConst, BTUtil, BTFiles, Enterprise01_TLB
  , MiscUtil, EnterToTab, Mask, TEditVal;

type
  TfrmReportCriteria = class(TForm)
    btnCancel: TButton;
    btnRunReport: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    cbFilterByAccType: TCheckBox;
    lAccountType: TLabel;
    edAccountType: TEdit;
    EnterToTab1: TEnterToTab;
    edStartPY: TMaskEdit;
    edEndPY: TMaskEdit;
    procedure btnCancelClick(Sender: TObject);
    procedure btnRunReportClick(Sender: TObject);
    procedure cbFilterByAccTypeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PYEdit(Sender: TObject);
  private
    sProduct, sContract : string;
    bIgnore, bSelectAll : boolean;
    procedure EnableDisable;
    function ValidatePeriodYear(edPY : TMaskEdit) : boolean;
    function ValidatePeriodYearRange : boolean;
  public
    { Public declarations }
  end;

var
  frmReportCriteria: TfrmReportCriteria;

implementation

uses
  StrUtil, APIUtil, WEEEProc, Reports;

{$R *.dfm}

procedure TfrmReportCriteria.EnableDisable;
begin
  edAccountType.Enabled := cbFilterByAccType.Checked;
  lAccountType.Enabled := edAccountType.Enabled;
end;

procedure TfrmReportCriteria.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmReportCriteria.btnRunReportClick(Sender: TObject);
begin
  if not ValidatePeriodYear(edStartPY) then exit;
  if not ValidatePeriodYear(edEndPY) then exit;
  if not ValidatePeriodYearRange then exit;

  with ModReports do
  begin
    iStartPeriod := StrToIntDef(Copy(edStartPY.Text,1,2), 0);
    iStartYear := StrToIntDef(Copy(edStartPY.Text,3,4), 0);
    iEndPeriod := StrToIntDef(Copy(edEndPY.Text,1,2), 0);
    iEndYear := StrToIntDef(Copy(edEndPY.Text,3,4), 0);

    if cbFilterByAccType.Checked
    then sAccountTypeFilter := edAccountType.text
    else sAccountTypeFilter := '';
    btnRunReport.Enabled := FALSE;
    btnCancel.Enabled := FALSE;
    PrintWEEEReport;
  end;{with}
  Close;
end;

procedure TfrmReportCriteria.cbFilterByAccTypeClick(Sender: TObject);
begin
  EnableDisable;
end;

procedure TfrmReportCriteria.FormShow(Sender: TObject);
begin
  edStartPY.Text := '01' + IntToStr(CurrentYear);
  edEndPY.Text := PadString(psLeft, IntToStr(oToolkit.SystemSetup.ssPeriodsInYear), '0', 2)
  + IntToStr(CurrentYear);
  EnableDisable;
end;

procedure TfrmReportCriteria.PYEdit(Sender: TObject);
begin
  if ActiveControl <> btnCancel
  then begin
    ValidatePeriodYear(TMaskEdit(Sender));
  end;{if}
end;

function TfrmReportCriteria.ValidatePeriodYear(edPY : TMaskEdit) : boolean;
var
  iPeriod, iYear : integer;
begin
  Result := TRUE;
  with edPY do
  begin
    iPeriod := StrToIntDef(Copy(Text,1,2), 0);
    iYear := StrToIntDef(Copy(Text,3,4), 0);

    if (iPeriod < 1) or (iPeriod > 99) or (iPeriod > oToolkit.SystemSetup.ssPeriodsInYear) then
    begin
      Result := FALSE;
      MsgBox('You have entered an invalid period', mtError, [mbOK], mbOK, 'Period Error');
      ActiveControl := edPY;
    end;{if}

    if (iYear < 1900) or (iYear > 2200) then
    begin
      Result := FALSE;
      MsgBox('You have entered an invalid year', mtError, [mbOK], mbOK, 'Year Error');
      ActiveControl := edPY;
    end;{if}
  end;{with}
end;

function TfrmReportCriteria.ValidatePeriodYearRange : boolean;
var
  iStart, iEnd : integer;
begin
  Result := TRUE;
  iStart := StrToIntDef(Copy(edStartPY.Text,3,4) + Copy(edStartPY.Text,1,2), 0);
  iEnd := StrToIntDef(Copy(edEndPY.Text,3,4) + Copy(edEndPY.Text,1,2), 0);

  if (iStart > iEnd) then
  begin
    Result := FALSE;
    MsgBox('You have entered an invalid period/year range', mtError, [mbOK], mbOK, 'Period/Year Error');
    ActiveControl := edStartPY;
  end;{if}
end;

end.
