program Loc;

uses
  Forms,
  LocListF in 'LocListF.pas' {frmLocList},
  LocDetlF in 'LocDetlF.pas' {frmLocationDetail},
  Stklocdf in 'Stklocdf.pas' {frmStkLocDetl},
  StkLocLF in 'Stkloclf.pas' {frmStkLocList};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfrmLocList, frmLocList);
  Application.Run;
end.
