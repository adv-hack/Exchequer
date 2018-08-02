unit PrntList;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TFrmPrintCardList = class(TForm)
    Bevel1: TBevel;
    rbCardNo: TRadioButton;
    rbCardName: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPrintCardList: TFrmPrintCardList;

implementation

{$R *.DFM}

end.
