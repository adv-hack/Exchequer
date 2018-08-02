program DBMDemo;

{$REALCOMPATIBILITY ON}
{$ALIGN 1}

uses
  Forms,
  uDBMDemo in 'uDBMDemo.pas' {frmDBMDemo},
  uDBMDChild in 'uDBMDChild.pas' {frmDBMChild},
  uDBMDPaths in 'uDBMDPaths.pas' {frmPaths};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmDBMDemo, frmDBMDemo);
  Application.CreateForm(TfrmPaths, frmPaths);
  Application.Run;
end.
