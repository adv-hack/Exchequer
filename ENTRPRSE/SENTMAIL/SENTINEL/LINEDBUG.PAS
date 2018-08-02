unit linedbug;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmLineDebug = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLineDebug: TfrmLineDebug;

implementation

{$R *.DFM}

procedure TfrmLineDebug.Button2Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    Memo1.Lines.SaveToFile(SaveDialog1.Filename);
end;

end.
