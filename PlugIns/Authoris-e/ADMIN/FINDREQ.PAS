unit FindReq;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmFindReq = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    edtReq2Find: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFindReq: TfrmFindReq;

implementation

{$R *.dfm}

end.
