unit BtrTestF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

Uses SetupReg;

procedure TForm1.Button2Click(Sender: TObject);
Var
  BtrReg : TSetupEntRegistry;
begin
  BtrReg := TSetupEntRegistry.Create;
  Try
    With BtrReg Do Begin
      ClientServer := False;
      EntDir := 'c:\excheqr\entrprse\';
      UserCount := 5;

      RegSettings.WriteToIni('c:\entbtrv.dat');
    End; { With }
  Finally
    BtrReg.Free;
  End;
end;

procedure TForm1.Button1Click(Sender: TObject);
Var
  BtrReg : TSetupEntRegistry;
begin
  BtrReg := TSetupEntRegistry.Create;
  Try
    With BtrReg Do Begin
      ClientServer := False;
      EntDir := 'c:\excheqr\entrprse\';
      UserCount := 5;

      SetupBtrieve615;
    End; { With }
  Finally
    BtrReg.Free;
  End;
end;

end.
