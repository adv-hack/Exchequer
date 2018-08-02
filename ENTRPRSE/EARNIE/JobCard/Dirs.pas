unit Dirs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, TCustom, ExtCtrls;

type
  TfrmSelectDir = class(TForm)
    Panel1: TPanel;
    SBSButton1: TSBSButton;
    SBSButton2: TSBSButton;
    edtEntDir: TEdit;
    edtPayDir: TEdit;
    edtLogDir: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSelectDir: TfrmSelectDir;

implementation

{$R *.dfm}
  uses
    BrwseDir;

procedure TfrmSelectDir.SpeedButton1Click(Sender: TObject);
var
  s : string;
begin
  if Sender is TSpeedButton then
  begin
    Case TSpeedButton(Sender).Tag of
      0  :  s := edtEntDir.Text;
      1  :  s := edtPayDir.Text;
      2  :  s := edtLogDir.Text;
    end;
    with TBrowseDirDialog.Create do
    Try
      Directory := s;
      if Execute then
      begin
        s := Directory;
        Case TSpeedButton(Sender).Tag of
          0  :  edtEntDir.Text := s;
          1  :  edtPayDir.Text := s;
          2  :  edtLogDir.Text := s;
        end;
      end;
    Finally
      Free;
    End;
  end;
end;

end.
