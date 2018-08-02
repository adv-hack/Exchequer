program madTestMailAPIs;

// dontTouchUses  <- this tells madExcept to not touch the uses clause

uses
  madExcept,
  madLinkDisAsm,
  Forms,
  mailtest in 'mailtest.pas' {FMailForm};

{$R madExcept.res}

begin
  Application.Initialize;
  Application.CreateForm(TFMailForm, FMailForm);
  Application.Run;
end.
