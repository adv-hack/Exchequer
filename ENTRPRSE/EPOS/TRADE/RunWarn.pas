unit RunWarn;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IAeverButton, ExtCtrls, EPOSCnst, GfxUtil;

type
  TfrmRunWarning = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    lLastLabel: TLabel;
    btnClose: TIAeverButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRunWarning: TfrmRunWarning;

implementation

{$R *.DFM}

procedure TfrmRunWarning.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmRunWarning.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  lLastLabel.Caption := 'Please exit this program and run the installation program ('
  + ExtractFilePath(ParamStr(0)) + 'TCMSETUP.EXE' + ') to install and setup The Trade Counter Module.';
end;

end.
