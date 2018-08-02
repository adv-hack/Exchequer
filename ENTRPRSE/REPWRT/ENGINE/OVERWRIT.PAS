unit overwrit;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, BorBtns;

type
  TForm_OverWrite = class(TForm)
    OWAny: TBorRadio;
    OWThis: TBorRadio;
    NoOWThis: TBorRadio;
    NoOWAny: TBorRadio;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



implementation

{$R *.DFM}

procedure TForm_OverWrite.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
