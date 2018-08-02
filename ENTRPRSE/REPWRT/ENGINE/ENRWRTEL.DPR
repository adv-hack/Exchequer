program Enrwrtel;

uses
  Forms,
  GlobVar in '\ENTRPRSE\R&D\Globvar.pas',
  VarConst in '\ENTRPRSE\R&D\Varconst.pas',
  RwOpenF in 'RwOpenF.pas',
  RWMain in 'RWMain.pas' {Form_RWMain},
  rwfuncs in 'rwfuncs.pas',
  RepTree in 'Reptree.pas' {Form_RepTree},
  RepNot in 'RepNot.pas' {FrmNotLine},
  rpinput in 'rpinput.pas' {RepInputs},
  RwListU in 'RwListU.pas',
  RepObjCU in 'Repobjcu.pas',
  RWPrintR in 'RWPrintR.pas',
  VarFPOSU in 'Varfposu.pas',
  Repnom in 'Repnom.pas' {FrmNomLine},
  RepInp in 'Repinp.pas' {FrmInpLine},
  Repdet in 'Repdet.pas' {ReportRec},
  Repline in 'Repline.pas' {FrmRepLine},
  prntprev in 'Prntprev.pas' {Form_PrintPreview},
  ReportO in 'Reporto.pas',
  AboutU in '\ENTRPRSE\R&D\Aboutu.pas' {AboutFrm},
  overwrit in 'overwrit.pas' {Form_OverWrite},
  RepObjNU in 'Repobjnu.pas';

{$R *.RES}

{$R Arrows.RES}

begin
  Application.Initialize;
  Application.Title := 'Exchequer Enterprise Report Writer';
  Application.HelpFile := 'ENREPWRT.HLP';
  Application.CreateForm(TForm_RWMain, Form_RWMain);
  Application.Run;
end.
