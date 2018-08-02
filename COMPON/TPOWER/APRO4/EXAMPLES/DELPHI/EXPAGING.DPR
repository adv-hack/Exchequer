program ExPaging;

uses
  Forms,
  ExPagin0 in 'ExPagin0.pas' {Form1},
  ExPagin1 in 'ExPagin1.pas' {Form2},
  ExPagin2 in 'ExPagin2.pas' {Form3};

{$IFDEF WhenPigsFly -- this prevents the IDE's scanner from adding a *.RES}
{.{$R *.RES}
{$ENDIF}

{$R EXICON.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.

