unit About;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
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
    Memo1: TMemo;
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
  StrUtil, ElVar;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add('Sentinels licenced: ' + IntToStr(SentinelsLicenced));
  Memo1.Lines.Add('Sentinels used: ' + IntToStr(SentinelsUsed));
  Memo1.Lines.Add(' ');
end;

end.
