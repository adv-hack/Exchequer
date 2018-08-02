unit ropopup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmQtyPopup = class(TForm)
    lbMaxStock: TLabel;
    lbPurchasePack: TLabel;
    lbQtyRounded: TLabel;
    edtMaxStock: TEdit;
    edtPurchasePack: TEdit;
    edtQtyRounded: TEdit;
    btnOK: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmQtyPopup: TfrmQtyPopup;}

implementation

{$R *.dfm}

end.
