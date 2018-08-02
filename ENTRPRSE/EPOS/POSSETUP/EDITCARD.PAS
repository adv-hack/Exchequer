unit EditCard;

{ nfrewer440 16:26 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TFrmCardDetails = class(TForm)
    Label1: TLabel;
    edDescription: TEdit;
    Label2: TLabel;
    edGLCode: TEdit;
    btnCancel: TButton;
    btnOK: TButton;
    procedure edGLCodeExit(Sender: TObject);
    procedure edDescriptionChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmCardDetails: TFrmCardDetails;

implementation
uses
  EntLkUp, EPOSCnst, EPOSKey;

{$R *.DFM}

procedure TFrmCardDetails.edGLCodeExit(Sender: TObject);
var
  sNom : string;
  iCode, iNom : integer;
begin
  sNom := TEdit(Sender).Text;
  Val(TEdit(Sender).Text, iNom, iCode);
  if DoGetNom(Self, sCurrCompPath, sNom, iNom, [nomProfitAndLoss, nomBalanceSheet], vmShowList, TRUE) then
    begin
      TEdit(Sender).Text := IntToStr(iNom);
      ActiveControl := btnOK;
    end
  else ActiveControl := TWinControl(Sender);
end;

procedure TFrmCardDetails.edDescriptionChange(Sender: TObject);
begin
  btnOK.Enabled := (edDescription.Text <> '') and (StrToIntDef(edGLCode.Text,0) > 0);
end;

procedure TFrmCardDetails.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
//  If (Key = VK_F1) and (Not (ssAlt In Shift)) then Application.HelpCommand(HELP_Finder,0);
end;

procedure TFrmCardDetails.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

end.
