unit secwarn;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls;

type
  TSecurityWarning = class(TSetupTemplate)
    Timer1: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SecurityWarning: TSecurityWarning;

implementation

{$R *.DFM}

procedure TSecurityWarning.Timer1Timer(Sender: TObject);
begin
  inherited;

  NextBtn.Enabled := True;
end;

procedure TSecurityWarning.Image1DblClick(Sender: TObject);
begin
  inherited;

  Timer1.Enabled := False;
  Timer1Timer(Sender);
end;

end.
