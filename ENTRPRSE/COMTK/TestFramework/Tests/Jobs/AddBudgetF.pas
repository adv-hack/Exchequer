unit AddBudgetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    FList, FSplitList : TStringList;
    procedure AddAnalysisBudget;
    procedure CreateBudgets;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

//Format of paramaters = JobCode, Category, AnalysisCode, Original Qty, Unit Price
const
  I_JOBCODE = 0;
  I_CATEGORY = 1;
  I_ANAL_CODE = 2;
  I_QTY = 3;
  I_VALUE = 4;

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddAnalysisBudget;
var
  oBudget : IAnalysisJobBudget3;
  sJobCode : string;
  iCategory : Integer;
  sAnalysisCode : string;
  dQty : Double;
  dValue : Double;
  Res : integer;
begin
  sJobCode := FSplitList[I_JOBCODE];
  iCategory := StrToInt(FSplitList[I_CATEGORY]);
  sAnalysisCode := FSplitList[I_ANAL_CODE];
  dQty := StrToFloat(FSplitList[I_QTY]);
  dValue := StrToFloat(FSplitList[I_VALUE]);
  with oToolkit.JobCosting do
  begin
    Job.Index := jrIdxCode;
    FResult := Job.GetEqual(Job.BuildCodeIndex(sJobCode));
    if FResult = 0 then
    with Job as IJob3 do
    begin
      oBudget := jrAnalysisBudget.Add as IAnalysisJobBudget3;
      Try
        oBudget.jbCurrency := 1;
        oBudget.jbOriginalQty := dQty;
        oBudget.jbUnitPrice := dValue;
        oBudget.jbOriginalValue := dValue * dQty;
        oBudget.jbRecharge := True;

        Res := JobAnalysis.GetEqual(JobAnalysis.BuildCodeIndex(sAnalysisCode));

        if Res = 0 then
        begin
          oBudget.jbAnalysisType := JobAnalysis.anType;
          oBudget.jbAnalysisCode := JobAnalysis.anCode;
          oBudget.jbCategory := TJobBudgetCategoryType(iCategory);
          FResult := oBudget.Save;
        end
        else
          FResult := 100 + Res;
      Finally
        oBudget := nil;
      End;
    end;
  end;
end;



procedure TfrmTestTemplate1.CreateBudgets;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
  if Trim(FList[0]) <> '' then
  begin
    FSplitList.Clear;
    FSplitList.CommaText := FList[i];
    if FSplitList.Count <> 5 then
      FResult := -1
    else
      AddAnalysisBudget;

    if FResult <> 0 then
      Break;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  FList := TStringList.Create;
  FSplitList := TStringList.Create;
  Try
    FList.LoadFromFile(FExtraParam);
    CreateBudgets;
  Finally
    FSplitList.Free;
    FList.Free;
  End;
end;

end.
 