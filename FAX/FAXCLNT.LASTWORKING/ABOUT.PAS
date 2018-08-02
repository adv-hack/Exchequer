unit about;

{ nfrewer440 10:20 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, OOMisc, StrUtil;

type
  TfrmAbout = class(TForm)
    Bevel1: TBevel;
    btnOK: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    lblVersion: TLabel;
    Bevel2: TBevel;
    Memo1: TMemo;
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

{$R *.DFM}
uses
  FaxUtils;

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
{  lPipeName.Caption := 'Pipename : ' + ApdPipeName + sExtraPipeName;
  lPipeName.Hint := lPipeName.Caption;
  lCommsVersion.Caption := 'Comms Version : ' + ApVersionStr;}
  lblVersion.Caption := FAX_VERSION;

  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
  Memo1.Lines.Add(' ');

end;

end.
