unit ScanEntF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TfrmScanEnterprise = class(TForm)
    ProgressBar1: TProgressBar;
    lblProgress: TLabel;
    Timer1: TTimer;
    procedure FormActivate(Sender: TObject);
    Procedure ScanEnterprise(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

Uses oEntList, oCompF, SurveyF;

//--------------------------------------------------------------------------

procedure TfrmScanEnterprise.FormCreate(Sender: TObject);
begin
  ProgressBar1.Min := 0;
  ProgressBar1.Position := 0;
end;

//---------------------------------------

procedure TfrmScanEnterprise.FormActivate(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

//---------------------------------------

procedure TfrmScanEnterprise.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

//--------------------------------------------------------------------------

// Scans the Enterprise installation and creates a text report
// of the installed companies
Procedure TfrmScanEnterprise.ScanEnterprise(Sender: TObject);
Var
  oCompanyFile : TCompanyFile;
  Res          : LongInt;
Begin { ScanEnterprise }
  // Disable timer to prevent event happening again
  Timer1.Enabled := False;

  // Update Progress Screen
  lblProgress.Caption := 'Checking Exchequer Directory...';
  lblProgress.Refresh;

  // Read Enterprise Licence if available
  oSurveyInfo.CheckEntLicence;

  // Build list of Enterprise Company Data Sets from Company.Dat
  oCompanyFile := TCompanyFile.Create;
  Try
    Res := oCompanyFile.OpenData (oSurveyInfo.EntPath);
    If (Res = 0) Then Begin
      // Setup Progress Bar
      ProgressBar1.Max := oCompanyFile.RecCount;

      // Run through Company.Dat processing Company Details records
      Res := oCompanyFile.GetFirst;
      While (Res = 0) Do Begin
        If (oCompanyFile.RecType = cmCompDet) Then Begin
          // Update Progress Screen
          lblProgress.Caption := Trim(oCompanyFile.mcmCompany);
          lblProgress.Refresh;

          // Add data set into the list of company data sets
          oSurveyInfo.AddDataSet (oCompanyFile.mcmCode, oCompanyFile.mcmCompany, oCompanyFile.mcmPath);
        End; { If (oCompanyFile.RecType = cmCompDet) }

        // Update Progress Bar
        ProgressBar1.Position := ProgressBar1.Position + 1;

        // Get Next record
        Res := oCompanyFile.GetNext;

        Application.ProcessMessages;

{ TODO : Remove delay before release version!!! }
Sleep (50);
      End; { While (Res = 0) }

      // Close the open Company.Dat
      oCompanyFile.CloseData;
    End { If (Res = 0) }
    Else
      // Error opening company.Dat
      ShowMessage ('Error ' + IntToStr(Res) + ' calling oCompanyFile.OpenData');
  Finally
    FreeAndNIL (oCompanyFile);
  End;

  // Move to Warnings dialog
  Hide;
  TfrmCustSurvey.Create(Application.MainForm).ShowFirst;
  Close;
End; { ScanEnterprise }

//--------------------------------------------------------------------------

end.
