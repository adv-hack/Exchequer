unit messscrn;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFrmMessageScreen = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    lMessage: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  FrmMessage: TFrmMessage;}

implementation

{$R *.DFM}

end.
