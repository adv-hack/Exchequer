unit Diagf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmDiag = class(TForm)
    memDiag: TMemo;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDiag: TfrmDiag;

implementation

{$R *.DFM}

end.
