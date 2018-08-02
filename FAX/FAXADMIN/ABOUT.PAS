unit about;

{ nfrewer440 10:19 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, OoMisc, StrUtil, BtrvU2;

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
//  lCommsVersion.Caption := 'Comms Version : ' + ApVersionStr;
//  lCopyright.Caption := GetCopyrightMessage;
//  lMode.Caption := 'Force Local Mode : ' + IntToStr(Ord(BTForceLocalEngine));
  lblVersion.Caption := FAX_VERSION;

  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
  Memo1.Lines.Add(' ');

end;

end.
