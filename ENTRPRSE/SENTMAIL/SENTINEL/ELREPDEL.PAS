unit elRepDel;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmRepDelivery = class(TForm)
    rgType: TRadioGroup;
    edtDelivery: TEdit;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRepDelivery: TfrmRepDelivery;

implementation

{$R *.DFM}

end.
