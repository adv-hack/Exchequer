program MakeHTML;

uses
  Forms,
  Main in 'Main.pas' {Form1},
  BrwseDir in 'x:\Shared\Brwsedir.pas' {FrmDirBrowse},
  MSXML_TLB in 'x:\EBUS2\xml\msxml_tlb.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmDirBrowse, FrmDirBrowse);
  Application.Run;
end.
