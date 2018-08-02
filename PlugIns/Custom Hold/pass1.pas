unit pass1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls;

type
  TfrmPass1 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    edtPass: TEdit;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    procedure SBSButton2Click(Sender: TObject);
    procedure SBSButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPass1: TfrmPass1;

implementation

{$R *.dfm}
uses
  HoldForm;


procedure TfrmPass1.SBSButton2Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmPass1.SBSButton1Click(Sender: TObject);
begin
  ReadSettingsFile;
  if CheckPassword(Trim(edtPass.Text)) then
  begin
    Self.Hide;
    ShowSettingsForm;
    Close;
  end
  else
  begin
    ShowMessage('Invalid Password');
    ActiveControl := edtPass;
  end;
end;

end.
