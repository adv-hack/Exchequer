unit TestF2;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm3 = class(TForm)
    GroupBox1: TGroupBox;
    ComboBox1: TComboBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

Uses DiskUtil;

procedure TForm3.FormCreate(Sender: TObject);
begin
  ClientHeight := 51;
  ClientWidth := 421;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  If CheckDirRights (ComboBox1.Text, '') Then
    ShowMessage ('OK')
  Else
    ShowMessage ('Failed');
end;

end.
