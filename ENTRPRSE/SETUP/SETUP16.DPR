Library Setup16;

uses
  Forms,
  SetupU in 'SETUPU.PAS',
  Setdir16 in 'SETDIR16.PAS' {DirectoryDialog},
  Dllconfg in 'DLLCONFG.PAS',
  GlobVar in '\ENTRPRSE\EXDLLnew\GLOBVAR.PAS',
  VarCnst3 in '\ENTRPRSE\EXDLLnew\VARCNST3.PAS',
  VarConst in '\ENTRPRSE\EXDLLnew\VARCONST.PAS',
  Confdlg4 in 'CONFDLG4.PAS' {ConfigDlg4},
  Confdlg2 in 'CONFDLG2.PAS' {ConfigDlg2},
  Confdlg3 in 'CONFDLG3.PAS' {ConfigDlg3};

{$R *.RES}

Exports
  GetEnterDir,
  ToolkitConfig;
Begin
  { Always need begin section in Delphi 1.0 }
end.
