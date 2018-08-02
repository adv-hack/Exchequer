unit RepInpSU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, Mask, TEditVal,
  BorBtns;

type
  TRepInpMsgS = class(TRepInpMsg)
    Label81: Label8;
    ACFF: Text8Pt;
    RePInv: TBorCheck;
    procedure ACFFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure RePrint_Backing(AOwner  :  TComponent);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTKeys1U,
  InvListU,
  FrmThrdU,
  SysU1,
  SysU2,
  BTSupU2;


{$R *.DFM}


procedure TRepInpMsgS.ACFFExit(Sender: TObject);
Var
  AltMod     :  Boolean;
  FoundCode  :  Str20;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>ClsCP1Btn) and (Length(FoundCode)>3) then
    Begin
      Text:=AutoSetInvKey(FoundCode,DocKeyLen);
    end;

  end; {With..}

end;

procedure TRepInpMsgS.OkCP1BtnClick(Sender: TObject);
begin
  If (Sender=OkCP1Btn) then
  Begin
    If AutoExitValidation Then
    Begin
      OKCP1Btn.Enabled:=BOff;

      {$IFDEF JC}
        PrintJCDoc(RePInv.Checked,BOn,ACFF.Text);
      {$ENDIF}

      inherited;
    End // If AutoExitValidation
    Else
      ModalResult := mrNone;
  End // If (Sender=OkCP1Btn)
  Else
    inherited;
end;

procedure TRepInpMsgS.FormCreate(Sender: TObject);
begin
  inherited;

  ClientHeight:=144;
  ClientWidth:=299;

  SetLastValues;

end;



procedure RePrint_Backing(AOwner  :  TComponent);



Var
  RepInpMsg1  :  TRepInpMsgS;

Begin
  RepInpMsg1:=TRepInpMsgS.Create(AOwner);


end;




end.
