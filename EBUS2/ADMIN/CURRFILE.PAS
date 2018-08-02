unit CurrFile;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    btnCreateFile: TButton;
    Button1: TButton;
    procedure btnCreateFileClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

uses
  ISOCurr;

procedure TForm1.btnCreateFileClick(Sender: TObject);
begin
  TISOCurrencyList.ProcessTextFile;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TISOCurrencyList.ProcessTextFileDesc;
end;

end.
