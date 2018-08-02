unit Blank;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmBlank = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmBlank: TfrmBlank;

implementation

{$R *.dfm}

procedure TfrmBlank.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmBlank.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
