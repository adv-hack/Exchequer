unit About;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls;

type
  TAboutBox = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    ProductName: TLabel;
    Version: TLabel;
    lCopyright: TLabel;
    Label1: TLabel;
    txtVersion: TStaticText;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation
uses
  StrUtil;

{$R *.DFM}

const
  VERSION_NO = '1.17';

procedure TAboutBox.FormCreate(Sender: TObject);
begin
  txtVersion.Caption := VERSION_NO;
  lCopyRight.Caption := GetCopyrightMessage;
end;

end.

