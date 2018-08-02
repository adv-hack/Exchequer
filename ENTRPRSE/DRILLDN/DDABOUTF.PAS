unit DDAboutF;

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
    memDrillLog: TMemo;
    Bevel1: TBevel;
    btnMoreInfo: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnMoreInfoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses StrUtil,
     Brand,
     DrillLog;      // DrillDownLog object

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  // Set copyright
//  lblCopyright.Caption := GetCopyrightMessage;

  NameLbl.Caption := Branding.pbProductName + ' Drill-Down Add-In';
  Caption := 'About ' + NameLbl.Caption;
  Image1.Picture.Icon := Branding.pbProductIcon;
  lblCopyright.Caption := Branding.pbCopyright;

  // Load Drill-Down Log messages into memo
  memDrillLog.Lines.Assign(DrillDownLog.Lines);

  // Hide Drill-Log Details as default
  ClientHeight := 108;
end;

procedure TfrmAbout.btnMoreInfoClick(Sender: TObject);
begin
  btnMoreInfo.Enabled := False;

  ClientHeight := 253;
  memDrillLog.Enabled := True;
end;

end.
