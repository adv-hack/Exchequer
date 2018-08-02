unit ModemSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom;

type
  TfrmModemSelect = class(TForm)
    cbPorts: TComboBox;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmModemSelect: TfrmModemSelect;

implementation

{$R *.dfm}

end.
