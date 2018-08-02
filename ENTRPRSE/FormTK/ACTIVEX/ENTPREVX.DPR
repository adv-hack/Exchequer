library entPrevX;

uses
  ComServ,
  entPrevX_TLB in 'entPrevX_TLB.pas',
  entPrevw in 'entPrevw.pas' {entPreviewX: CoClass},
  About1 in 'About1.pas' {entPreviewXAbout};

{$E ocx}

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}

{$R *.RES}

begin
end.
