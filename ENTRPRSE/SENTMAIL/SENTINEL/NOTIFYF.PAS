unit notifyf;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmNotify = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNotify: TfrmNotify;

implementation

{$R *.DFM}

procedure TfrmNotify.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
