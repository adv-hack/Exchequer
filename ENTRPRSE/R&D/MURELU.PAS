unit MURelU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, TEditVal, SBSPanel, Mask,
  GlobVar;



type
  TMultiLicFrm= class(TForm)
    VerF: Label8;
    OkI1Btn: TButton;
    DLLVer: Label8;
    SBSPanel1: TSBSPanel;
    Image1: TImage;
    Memo2: TMemo;
    SecF: Text8Pt;
    RelF: Text8Pt;
    UserF: Text8Pt;
    CanCP1Btn: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure RelFExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    JustCreated  :  Boolean;
    
  public
    { Public declarations }



  end;

Function Control_USRLine : Boolean;

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
  SysU3,
  SecSup2U,
  HelpSupU;
  

{$R *.DFM}



procedure TMultiLicFrm.FormActivate(Sender: TObject);
begin
  If (JustCreated) then
  Begin
    MDI_ForceParentBKGnd(BOn);

    JustCreated:=BOff;

    If SecF.CanFocus then
      SecF.SetFocus;

    If RelF.CanFocus then
    Begin
      RelF.SetFocus;
      RelF.BringToFront;
    end;
  end;

end;

procedure TMultiLicFrm.FormCreate(Sender: TObject);
begin
  JustCreated:=BOn;
end;


procedure TMultiLicFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TMultiLicFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TMultiLicFrm.RelFExit(Sender: TObject);
begin
  UserF.Text:=Form_Int(Syss.EntULogCount,0)+'/'+Form_Int(DeCode_Usrs(SecF.Text,RelF.Text),0);
end;


Function Control_USRLine : Boolean;

Var
  PrevHState,
  Locked  :  Boolean;
  Secure  :  TMultiLicFrm;

Begin
  Result := True;

  Secure:=TMultiLicFrm.Create(Application);

  try
    With Syss, Secure do
    Begin
      SecF.Text:=ExUsrSec;
      RelF.Text:=ExUsrRel;
      UserF.Text:=Form_Int(EntULogCount,0)+'/'+Form_Int(DeCode_Usrs(ExUsrSec,ExUsrRel),0);


      SetAllowHotKey(BOff,PrevHState);

      ShowModal;

      SetAllowHotKey(BOn,PrevHState);

      If (ModalResult=mrOk) then
      Begin
        Locked:=BOn;

        If (GetMultiSys(BOff,Locked,SysR)) and (Locked) then
        Begin
          Syss.ExUsrRel:=RelF.Text;

          {* Update duplicate record *}

          TrackSecUpdates(BOff);

          PutMultiSys(SysR,BOn);

          {$IFDEF COMP}     // EntComp.Dll - Multi-Company Manager
            // Update the MCM Global Security record
            LoadnLockCompanyOpt;

            // Enterprise Global Full User Count
            SyssCompany^.CompOpt.OptEntUserSecurity := Syss.ExUsrSec;
            SyssCompany^.CompOpt.OptEntUserRelease := Syss.ExUsrRel;

            // Enterprise Global 30-Day User Count
            (*
            SyssCompany^.CompOpt.OptEntUser30Security := Syss.ExUsrSec;
            SyssCompany^.CompOpt.OptEntUser30UCount := Syss.ExUsrRel;
            SyssCompany^.CompOpt.OptEntUser30Expiry := 0;
            *) ShowMessage ('Store Exchequer 30-Day User Count');

            PutCompanyOpt (True);
          {$ELSE}
            // NOTE: Don't want to call this if MCM as its already being called by MCM
            Replicate_CoSecurity;
          {$ENDIF}
        end;
      end;

      Result := (ModalResult = mrOk);
    end;

  finally

    Secure.Free;

    MDI_ForceParentBKGnd(BOn);
  end; {try..}

end;



Initialization

end.
