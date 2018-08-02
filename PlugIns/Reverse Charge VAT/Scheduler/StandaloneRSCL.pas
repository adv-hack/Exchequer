unit StandaloneRSCL;

interface
uses
  RSCLProc, Progress, Forms;

type
  TRunRSCLFunction = Class
    FrmProgress : TFrmProgress;
    procedure UpdateProgress(sMessage : string);
    procedure Execute(sCompanyPath : string);
  end;{class}

implementation
uses
  Controls, APIUtil, Dialogs;

{ TRunRSCLFunction }

procedure TRunRSCLFunction.Execute(sCompanyPath: string);
begin
  if MsgBox(' Are you sure that you want to run the Reverse Charge VAT RCSL Update Utility ?'
  , mtconfirmation, [mbyes, mbNo], mbNo, 'Reverse Charge VAT RCSL Update Utility') = mrYes then
  begin
    FrmProgress := TFrmProgress.Create(application);
    FrmProgress.Show;
    UpdateRSCL(sCompanyPath, UpdateProgress, TRUE);
    FrmProgress.Hide;
    FrmProgress.Release;
  end;{if}
end;

procedure TRunRSCLFunction.UpdateProgress(sMessage: string);
begin
  FrmProgress.UpdateLine2(sMessage);
end;

end.
