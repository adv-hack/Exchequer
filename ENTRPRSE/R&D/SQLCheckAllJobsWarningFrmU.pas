unit SQLCheckAllJobsWarningFrmU;
{
  Form used by TSQLCheckAllJobsFrm to display a list of data discrepancies
  found prior to running Check All Jobs.

  The Error List is populated by TSQLCheckAllJobsFrm.VerifyData, so there is
  no actual processing on this form.
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TSQLCheckAllJobsWarningFrm = class(TForm)
    MainPanel: TPanel;
    ButtonPanel: TPanel;
    lblContinue: TLabel;
    ErrorList: TListBox;
    lblDataDiscrepancies: TLabel;
    btnNext: TButton;
    btnCancel: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SQLCheckAllJobsWarningFrm: TSQLCheckAllJobsWarningFrm;

implementation

{$R *.dfm}

const
  DataDiscrepanciesMsg = 'Unable to run Check All Jobs in optimised mode. %d data warnings were identified.';

procedure TSQLCheckAllJobsWarningFrm.FormActivate(Sender: TObject);
var
  Lbl: string;
begin
  Lbl := Format(DataDiscrepanciesMsg, [ErrorList.Items.Count]);
  lblDataDiscrepancies.Caption := Lbl;
end;

end.
