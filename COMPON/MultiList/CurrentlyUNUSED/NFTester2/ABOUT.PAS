unit about;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, StrUtil;

type
  TfrmAbout = class(TForm)
    Bevel1: TBevel;
    btnOK: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    lVersion: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    lTKVersion: TLabel;
    lCommsVersion: TLabel;
    lCopyright: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation
uses
  VarConst, UseDllU, Comms;

{$R *.DFM}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lVersion.Caption := 'Loyalty version : ' + WincardVersion;
  lTKVersion.Caption := 'Toolkit version : ' + EX_VERSION;
  lCommsVersion.Caption := 'Comms version : ' + frmComms.ComPort.Version;
  lCopyright.Caption := GetCopyrightMessage;
end;

end.
