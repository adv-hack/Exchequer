unit Convf;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls;

type
  TfrmWelcome = class(TSetupTemplate)
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

procedure TfrmWelcome.FormCreate(Sender: TObject);
begin
  inherited;

  ExitMsg := 3;
end;

end.
