program Exmdi2;

uses
  Forms,
  AdExcept,
  Exmdi20 in 'EXMDI20.PAS' {Form1},
  Exmdi21 in 'EXMDI21.PAS' {Form2},
  Exmdi22 in 'EXMDI22.PAS' {Form3};

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
