unit About;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TfrmAbout = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    lblTitle: TLabel;
    Image1: TImage;
    Bevel1: TBevel;
    lblVersion: TLabel;
    lblCopyRight: TLabel;
    Label2: TLabel;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.DFM}
uses
  StrUtil;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblCopyRight.Caption := GetCopyrightMessage;
end;

end.
