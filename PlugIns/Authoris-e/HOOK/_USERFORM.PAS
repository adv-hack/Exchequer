unit UserForm;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmPaUserID = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    edtUserID: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblReason: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

end.
