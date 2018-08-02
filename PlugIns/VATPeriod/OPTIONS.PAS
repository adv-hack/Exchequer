unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls;

type
  TfrmOptions = class(TForm)
    Panel1: TPanel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    CheckBox1: TCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

{$R *.dfm}

end.
