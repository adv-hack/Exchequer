unit about;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TfrmAbout = class(TForm)
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    lCopyright: TLabel;
    lVersion: TLabel;
    Bevel2: TBevel;
    Label4: TLabel;
    lTKVersion: TLabel;
    btnOK: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation
uses
  EPOSCnst, UseDllU, StrUtil, ExchequerRelease;

{$R *.DFM}

procedure TfrmAbout.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  //lVersion.Caption := 'Administrator version : ' + sTCMAdminVersionNumber;
  lVersion.Caption := 'Administrator version : ' + ExchequerModuleVersion (emTradeCounterAdmin, sTCMAdminVersionNumber);
  lTKVersion.Caption := 'Toolkit version : ' + EX_VERSION;
  lCopyright.Caption := GetCopyrightMessage;
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

end.
