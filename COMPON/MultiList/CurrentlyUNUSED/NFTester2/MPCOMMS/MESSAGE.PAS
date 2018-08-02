unit message;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TFrmMessage = class(TForm)
    Panel1: TPanel;
    lMessage: TLabel;
    Image1: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmMessage: TFrmMessage;

implementation

{$R *.DFM}

end.
