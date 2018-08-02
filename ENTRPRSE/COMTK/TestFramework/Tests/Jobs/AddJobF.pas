unit AddJobF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TESTFORMTEMPLATE, StdCtrls, Enterprise04_TLB;

type
  TfrmTestTemplate1 = class(TfrmTestTemplate)
  private
    { Private declarations }
  public
    { Public declarations }
    procedure AddJob;
    procedure RunTest; override;
  end;

var
  frmTestTemplate1: TfrmTestTemplate1;

implementation

{$R *.dfm}

{ TfrmTestTemplate1 }

procedure TfrmTestTemplate1.AddJob;
begin
  with oToolkit.JobCosting.Job.Add do
  begin
    jrParent := 'MAIN01';
    jrCode := 'ZZZZ01';
    jrDesc := 'The ZZZ Project';
    jrAcCode := 'ABAP01';
    jrContact := 'Mr A N Other';
    jrType := JTypeJob;
    jrJobType := 'SE2';
    jrStartDate := '20110901';
    jrEndDate := '20120331';

    FResult := Save;
  end;
end;

procedure TfrmTestTemplate1.RunTest;
begin
  AddJob;
end;

end.
