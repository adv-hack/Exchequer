program CISOutgoingDemo;

uses
  Forms,
  uCISdemo in 'uCISdemo.pas' {Form1},
  CISOutgoing_TLB in '..\CISOutgoing_TLB.pas',
  uDSRFileFunc in '..\..\DSR\uDSRFileFunc.pas',
  DSROutgoing_TLB in 'X:\EXCHLITE\ICE\Source\DSR\Outgoing\DSROutgoing_TLB.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
