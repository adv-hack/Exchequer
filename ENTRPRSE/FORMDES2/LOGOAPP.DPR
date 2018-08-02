program LogoApp;

uses
  Forms,
  LogoMain in 'LogoMain.pas' {LogoAppForm},
  About in 'ABOUT.PAS' {AboutBox};

{$R *.RES}
{$R LOGOSTRS.RES}

begin
  Application.CreateForm(TLogoAppForm, LogoAppForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
 