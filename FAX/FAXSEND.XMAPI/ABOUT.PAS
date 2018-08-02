unit about;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, BTSupU1, BtrvU2;

type
  TfrmAbout = class(TForm)
    Bevel1: TBevel;
    btnOK: TBitBtn;
    Label1: TLabel;
    lblVersion: TLabel;
    Bevel2: TBevel;
    Image2: TImage;
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
uses
  StrUtil, FaxUtils;

{$R *.DFM}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
//  lcommsversion.caption := 'Comms Version : ' + frmFaxStatus.ApdComPort1.Version;
  lblVersion.Caption := FAX_VERSION;
  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
  Memo1.Lines.Add(' ');
end;

end.
