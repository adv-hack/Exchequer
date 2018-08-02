program MBAdmin;

uses
  Forms,
  AdmninF in 'AdmninF.pas' {frmMultiBacAdmin},
  BacConst in '..\GENERAL\BacConst.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMultiBacAdmin, frmMultiBacAdmin);
  Application.Run;
end.
