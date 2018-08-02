unit Form;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmStock = class(TForm)
    lStockCode: TLabel;
    lbCodes: TListBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  FrmStock: TFrmStock;

implementation

{$R *.dfm}

end.
