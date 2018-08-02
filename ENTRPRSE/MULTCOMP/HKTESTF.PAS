unit HKTestF;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmHookSecTest = class(TForm)
    GroupBox1: TGroupBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHookSecTest: TfrmHookSecTest;

implementation

{$R *.DFM}

end.
