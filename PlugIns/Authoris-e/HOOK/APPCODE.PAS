unit appcode;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmAppCode = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    edtAppCode: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAppCode: TfrmAppCode;

implementation

{$R *.dfm}

end.
