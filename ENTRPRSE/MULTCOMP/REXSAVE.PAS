unit rexsave;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Setupbas, ExtCtrls, StdCtrls;

type
  TForm_REXWarn = class(TSetupTemplate)
    RexSave: TLabel;
    procedure tn_OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_REXWarn: TForm_REXWarn;

implementation

{$R *.DFM}

procedure TForm_REXWarn.tn_OKClick(Sender: TObject);
begin
  inherited;

  Close;
end;

end.
