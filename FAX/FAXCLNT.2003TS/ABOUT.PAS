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
    lCopyright: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    lPipeName: TLabel;
    lCommsVersion: TLabel;
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

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  lPipeName.Caption := 'Pipename : ' + ApdPipeName + sExtraPipeName;
  lPipeName.Hint := lPipeName.Caption;
  lCommsVersion.Caption := 'Comms Version : ' + ApVersionStr;
  lCopyright.Caption := GetCopyrightMessage;
end;

end.
