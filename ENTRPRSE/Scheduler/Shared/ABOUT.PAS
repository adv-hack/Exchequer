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
    Bevel1: TBevel;
    lblVersion: TLabel;
    Panel2: TPanel;
    Image1: TImage;
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
  StrUtil, SchedVar;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  //PR: 08/07/2013 ABSEXCH-14438 Rebranding.
  //PR: 03/06/2015 v7.0.14 Change copyright strings
  lblTitle.Caption := 'Exchequer Scheduler';
  lblVersion.Caption := 'Version: ' + SchedulerVersion;
  Memo1.Lines.Add(GetCompanyNameString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetExchequerTrademarkString);
  Memo1.Lines.Add(' ');
  Memo1.Lines.Add(GetCopyRightMessage);
  Memo1.Lines.Add(' ');
end;

end.
