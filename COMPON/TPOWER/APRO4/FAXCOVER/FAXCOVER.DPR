program FaxCover;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  PageForm in 'PAGEFORM.PAS' {CoverPageForm},
  Ruler in 'RULER.PAS',
  FaxField in 'FAXFIELD.PAS',
  FDRepTag in 'FDREPTAG.PAS' {ReplacementTagsForm},
  FDOption in 'FDOPTION.PAS' {PageOptionsForm},
  FDUtils in 'FDUTILS.PAS',
  ADABOUT in '..\ADABOUT.PAS' {ApdAboutForm};

{$R *.RES}

begin
  Application.Title := 'Fax Cover Page Builder';
  Application.HelpFile := 'FAXCOVER.HLP';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
