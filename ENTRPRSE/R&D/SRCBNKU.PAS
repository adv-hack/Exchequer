unit SrcBnkU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BorBtns, StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel, bkgroup;

type
  TBankDefault = class(TForm)
    OkR1Btn: TButton;
    CanR1Btn: TButton;
    UserDef1: TBorCheck;
    DefGLF: Text8Pt;
    GLDescF: Text8Pt;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label82: Label8;
    AutoVar: TBorCheck;
    AutoDisc: TBorCheck;
    Label83: Label8;
    Label84: Label8;
    procedure DefGLFExit(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private

    PrevHState  :  Boolean;
    
    Procedure OutIS;

    Procedure SetISStore(EnabFlg  :  Boolean);

    Procedure Form2IS;

  public
    { Public declarations }
    ISNomCode    : LongInt;
    UseNomCode,
    IsSRCBank,
    UseAutoDisc,
    UseAutoVar   : Boolean;


    Function InitIS(VO    :  Boolean;
                    Col1  :  TColor;
                    Fon1  :  TFont):  Word;

end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTSupU1,
  BTSupU2,
  PassWR2U,
  InvListU;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TBankDefault.OutIS;

Var
  FoundLong  :  LongInt;
  FoundOk    :  Boolean;

Begin
  UserDef1.Checked:=UseNomCode;
  AutoVar.Checked:=UseAutoVar;
  AutoDisc.Checked:=UseAutoDisc;

  DefGLF.Text:=Form_BInt(ISNomCode,0);

  If (Nom.NomCode<>ISNomCode) then
    FoundOk:=GetNom(Self,DefGLF.Text,FoundLong,-1);

  GLDescF.Text:=Nom.Desc;

end;


Procedure TBankDefault.SetISStore(EnabFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    If (Tag=1) then
    Begin
      ReadOnly:= EnabFlg;
    end;
  end;

end;

Procedure TBankDefault.Form2IS;

Begin
  UseNomCode:=UserDef1.Checked;
  ISNomCode:=IntStr(DefGLF.Text);
  UseAutoVar:=AutoVar.Checked;
  UseAutoDisc:=AutoDisc.Checked;
end;


Function TBankDefault.InitIS(VO    :  Boolean;
                             Col1  :  TColor;
                             Fon1  :  TFont):  Word;

Var
  Locked,
  StoreProfile
            :  Boolean;
  OrigNCode :  LongInt;

Begin
  With DefGLF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  OrigNCode:=ISNomCode;

  StoreProfile:=BOff;

  SetISStore(VO);

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin
    Form2IS;

    Locked:=BOn;

    GetMultiSys(BOn,Locked,SysR);

    If (Locked) then
    With Syss,UserProfile^ do
    Begin
      If (IsSRCBank) then
      Begin
        If (OrigNCode=DefSRCBankNom) then
          DefSRCBankNom:=ISNomcode;

        //GS 27/10/2011 ABSEXCH-11651: if the user has closed the SRC dialog with 'default' disabled, then delete
        //the existing 'default to' value
        if self.UseNomCode = False then
        begin
          DefSRCBankNom := 0;
          ISNomCode := 0;
        end;

        If (OrigNCode=SalesBank) and (SalesBank<>0) then
        Begin
          SalesBank:=IsNOmCode;
          StoreProfile:=Loaded;
        end;
      end
      else
      Begin
        If (OrigNCode=DefBankNom) then
          DefBankNom:=ISNomcode;

        //GS 27/10/2011 ABSEXCH-11651: if the user has closed the PPY dialog with 'default' disabled, then delete
        //the existing 'default to' value
        if self.UseNomCode = False then
        begin
          DefBankNom := 0;
          ISNomCode := 0;
        end;

        If (OrigNCode=PurchBank) and (PurchBank<>0) then
        Begin
          PurchBank:=IsNOmCode;
          StoreProfile:=Loaded;
        end;
      end;




      UseDefBank:=UseNomCode;
      AutoGenVar:=UseAutoVar;
      AutoGenDisc:=UseAutoDisc;

      Store_PWDefaults(Login,UserProfile^);


      PutMultiSys(SysR,BOn);
    end;

  end;
end;






procedure TBankDefault.DefGLFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;


begin

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanR1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

      If (FoundOk) and (FoundLong=Syss.NomCtrlCodes[CurrVar]) then
      Begin
        ShowMessage('The default bank account cannot be a control account.');
        FoundOk:=BOff;
      end;

      If (FoundOk) then {* Credit Check *}
      Begin
        GLDescF.Text:=Nom.Desc;
        Text:=Form_Int(FoundLong,0);
      end
      else
        SetFocus;


    end;


  end; {with..}
end;



procedure TBankDefault.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TBankDefault.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

Initialization


end.
