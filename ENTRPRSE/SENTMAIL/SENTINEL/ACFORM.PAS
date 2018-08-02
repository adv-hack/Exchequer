unit acform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmAccount = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    btnClose: TButton;
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    SMSSender : Variant;
  end;

var
  frmAccount: TfrmAccount;

implementation

{$R *.dfm}


procedure TfrmAccount.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;



procedure TfrmAccount.Timer1Timer(Sender: TObject);
var
  s : string;
begin
  Timer1.Enabled := False;
  Try
    s := SMSSender.GetErrorDesc(3333);
    if Copy(s, 1, 2) <> '-1' then
      Label1.Caption := 'You have ' + s + ' credits available.'
    else
      Label1.caption := 'Unable to check account at this time.  Please try again later';
  Except;
      Label1.caption := 'Unable to check account at this time.  Please try again later';
  End;
  btnClose.Enabled := True;
end;

end.
