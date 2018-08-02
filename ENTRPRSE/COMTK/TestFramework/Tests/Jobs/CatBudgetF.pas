unit CatBudgetF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
    procedure UpdateBudget;
  public
    { Public declarations }
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.RunTest;
begin
  UpdateBudget;
end;

procedure TfrmTestTemplate1.UpdateBudget;
var
  KeyS : String;
  oBud : ISummaryJobBudget;
begin
  with oToolkit.JobCosting do
  begin
    FResult := Job.GetEqual(Job.BuildCodeIndex(FExtraParam));
    if FResult = 0 then
    with Job as IJob2 do
    begin
      jrSummaryBudget.Index := 0;
      jrSummaryBudget.jbYear := 107;
      jrSummaryBudget.jbPeriod := 5;
      KeyS := jrSummaryBudget.BuildCategoryIndex(jbcLabour);
      FResult := jrSummaryBudget.GetEqual(KeyS);
      if FResult = 0 Then
      begin
        oBud := jrSummaryBudget.Update;

        if Assigned(oBud) then
        begin
          oBud.jbOriginalValue := 1100;
          oBud.jbRevisedValue := 1300;
          FResult := oBud.Save;
        end;
      end
      else
        FResult := 100 + FResult;
    end;
  end;
end;

end.
 