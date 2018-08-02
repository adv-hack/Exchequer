program EntMapi64;

uses
  Vcl.Forms,
  oMapi64 in '..\oMapi64.pas' {OwnerForm},
  MapiEx in '..\MapiEx.pas',
  Exchequer_TLB in '..\Exchequer_TLB.pas',
  oEntMapi64 in '..\oEntMapi64.pas' {Mapi64: CoClass};

{$R *.TLB}

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := False;
  Application.Title := '';
  Application.ShowMainForm := False;
  Application.CreateForm(TOwnerForm, OwnerForm);
  Application.Run;
end.
