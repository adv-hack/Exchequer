unit dmimages;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ImgList;

type
  Tdm1 = class(TDataModule)
    ImageList1: TImageList;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dm1: Tdm1;

implementation

{$R *.DFM}

end.
