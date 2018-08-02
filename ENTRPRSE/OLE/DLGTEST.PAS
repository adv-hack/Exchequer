unit DlgTest;

{ markd6 12:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm_DlgTest = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_DlgTest: TForm_DlgTest;

implementation

{$R *.DFM}

procedure TForm_DlgTest.FormCreate(Sender: TObject);
begin
  { Create }
end;

procedure TForm_DlgTest.FormDestroy(Sender: TObject);
begin
  { Destroy }
end;

procedure TForm_DlgTest.FormDeactivate(Sender: TObject);
begin
  { Deactivate }
end;

procedure TForm_DlgTest.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
