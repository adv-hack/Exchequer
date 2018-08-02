unit MsgTest;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons;

type
  TfrmMsg = class(TForm)
    memMsg: TMemo;
    Label1: TLabel;
    Label2: TLabel;
    lblSender: TLabel;
    lblSubject: TLabel;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMsg: TfrmMsg;

implementation

{$R *.DFM}

end.
