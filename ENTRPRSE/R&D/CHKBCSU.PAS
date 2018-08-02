unit ChkBCSU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, Mask,
  GlobVar;



type
  TChkBCSFrm= class(TForm)
    OkI1Btn: TButton;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    Memo1: TMemo;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    JustCreated  :  Boolean;

  public
    { Public declarations }



  end;

Procedure CheckClientServer;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  BtrvU2,
  ETStrU,
  ETMiscU,
  ETDateU,
  BTSupU1,
  Brand,
  {$IFDEF LTE}
    EntLicence,
  {$ENDIF}
  BTSupU2;

{$R *.DFM}



procedure TChkBCSFrm.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    MDI_ForceParentBKGnd(BOn);

    JustCreated:=BOff;
  end;

end;

procedure TChkBCSFrm.FormCreate(Sender: TObject);
begin
  JustCreated:=BOn;

{$IFDEF LTE}
  // MH 11/04/06: Rebranding for IAO/Exchequer support
  Caption := Branding.pbProductName + ' Client Server Check';
{$ENDIF}

  // Check for the existance of the branding file for the about dialog
  If Branding.BrandingFileExists (ebfAbout) Then
  Begin
    Branding.BrandingFile(ebfAbout).ExtractImage (Image1, 'Logo');
  End; // If Branding.BrandingFileExists (ebfAbout)
end;


Procedure CheckClientServer;

Var
  PrevHState,
  Locked  :  Boolean;
  Secure  :  TChkBCSFrm;

Begin
  If (Not Check4SABtrv(F[SysF])) and (Chk4BCS) then
  Begin

    Secure:=TChkBCSFrm.Create(Application);

    try
      Secure.ShowModal;

    finally

      Secure.Free;

      MDI_ForceParentBKGnd(BOn);

      Halt;
    end; {try..}
  end;

end;



Initialization

end.
