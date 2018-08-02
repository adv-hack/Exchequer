unit SecureU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, Mask,
  GlobVar;


type
  TSecureFrm= class(TForm)
    Memo1: TMemo;
    VerF: Label8;
    OkI1Btn: TButton;
    DLLVer: Label8;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    Memo2: TMemo;
    SecF: Text8Pt;
    RelF: Text8Pt;
    CanCP1Btn: TButton;
    ISNF: Text8Pt;
    procedure FormCreate(Sender: TObject);
    procedure RelFExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkI1BtnClick(Sender: TObject);
  private
    { Private declarations }
    JustCreated  :   Boolean;
  public
    { Public declarations }

    GotSecOk  :  Boolean;

    LFullExSec,

    LYrNextDSec,

    LNextDSec  :  LongInt;


  end;

Var
  SecureMode  :  Boolean;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU1,
  BTSupU2,
  {$IFDEF LTE}
    Brand,
    EntLicence,
  {$ENDIF}
  SecSup2U;

{$R *.DFM}




procedure TSecureFrm.FormCreate(Sender: TObject);


begin
  JustCreated:=BOn;
  GotSecOk:=BOff;

{$IFDEF LTE}
  // MH 11/04/06: Rebranding for IAO/Exchequer support
  Caption := Branding.pbProductName;

  // Check for the existance of the branding file for the about dialog
  If Branding.BrandingFileExists (ebfAbout) Then
  Begin
    Branding.BrandingFile(ebfAbout).ExtractImage (Image1, 'Logo');
  End; // If Branding.BrandingFileExists (ebfAbout)

  DLLVer.Caption:=EnterpriseLicence.elLongVersionDesc + ' ' + CurrVersion;

  If (Not SecureMode) Then
  Begin
    Memo1.Clear;
    Memo1.Lines.Add('');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Licence Check');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Too many users are logged into');
    Memo1.Lines.Add(Branding.pbProductName);
    Memo1.Lines.Add('');
    Memo1.Lines.Add('-+-');
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Please wait for other users to');
    Memo1.Lines.Add('finish before retrying.');
  End; // If (Not SecureMode)
{$ELSE}
  {$IFNDEF WCA}
    DLLVer.Caption:='Version: '+Ver;
  {$ENDIF}
{$ENDIF}

  If (SecureMode) then
  Begin
    Memo1.Visible:=BOff;
    Caption:=Caption+' Security Check';
    ActiveControl:=RelF;
  end
  else
  Begin
    Memo2.Visible:=BOff;
    RelF.Visible:=BOff;
    SecF.Visible:=BOff;
    ISNF.Visible:=BOff;
    Caption:=Caption+' Licence Check';
    ActiveControl:=OKI1Btn;
  end;
end;

procedure TSecureFrm.RelFExit(Sender: TObject);

Var
  RelNo  :  LongInt;

begin
  With RelF do
  Begin
    RelNo:=Calc_Security(Text,BOn);

    GotSecOk:=((RelNo=LFullExSec) or (RelNo=LNextDSec) or (RelNo=LYrNextDSec) );

    If (ActiveControl<>CanCP1Btn) and (Not GotSecOk) then
      SetFocus;
  end;
end;

procedure TSecureFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TSecureFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TSecureFrm.OkI1BtnClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

Initialization

end.
