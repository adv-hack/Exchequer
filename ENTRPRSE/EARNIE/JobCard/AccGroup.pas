unit AccGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls;

type
  TfrmAccGroup = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    edtAccGroup: TEdit;
    Label1: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAccGroup: TfrmAccGroup;

implementation

{$R *.dfm}

end.
