unit KeyForm;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmEventKey = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Panel1: TPanel;
    edtKey: TEdit;
    Label1: TLabel;
    rgCustSupp: TRadioGroup;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEventKey: TfrmEventKey;

implementation

{$R *.DFM}

end.
