unit DQAboutF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

type
  TfrmAbout = class(TForm)
    NameLbl: TLabel;
    CopyrightLbl: TLabel;
    DescLbl: TLabel;
    lblCopyright: TLabel;
    OkBtn: TButton;
    Image1: TImage;
    Label2: TLabel;
    lblExcelAddInVer: TLabel;
    lblCOMServerVer: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

Uses Brand;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  NameLbl.Caption := Branding.pbProductName + ' Data Query Add-In';
  Caption := 'About ' + NameLbl.Caption;
  Image1.Picture.Icon := Branding.pbProductIcon;
  lblCopyright.Caption := Branding.pbCopyright;
end;

end.
