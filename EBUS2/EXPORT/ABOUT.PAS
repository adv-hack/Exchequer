unit about;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
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
    lCopyright: TLabel;
    lblVersion: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

{var
  frmAbout: TfrmAbout;}

implementation

uses
  ExchequerRelease, EbusUtil;

{$R *.DFM}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lblVersion.Caption := 'Version: ' + ExchequerModuleVersion(emEbusinessExport, BuildNo);
  lCopyright.Caption := GetCopyrightMessage;
end;

end.
