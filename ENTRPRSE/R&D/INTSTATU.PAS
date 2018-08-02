unit IntStatu;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar,VarConst;

type
  TIntStatInv = class(TForm)
    SBSPanel1: TSBSPanel;
    ISDelF: Text8Pt;
    Label81: Label8;
    ISTTF: TCurrencyEdit;
    Label82: Label8;
    ISMTF: TCurrencyEdit;
    Label83: Label8;
    ClsCP1Btn: TButton;
    OkCP1Btn: TButton;
    Label84: Label8;
    ISPTF: TSBSComboBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure ISDelFExit(Sender: TObject);
    procedure ISTTFExit(Sender: TObject);
    procedure ISMTFExit(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    PrevHState  :  Boolean;

    Procedure OutIS;

    Procedure SetISStore(EnabFlg  :  Boolean);

    Procedure Form2IS;

  public
    { Public declarations }
    ISDelTerms   : String[3];
    ISTransNat,
    ISTransMode  : Byte;

    ISProcessFlag: Char;


    Function InitIS(VO    :  Boolean;
                    Col1  :  TColor;
                    Fon1  :  TFont):  Word;



  end;


  Function PTtoCB(PT  : Char)  :  Integer;

  Function CBtoPT(CB  :  Integer)  :  Char;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ThemeFix,
  BTSupU1,
  BTSupU2,
  SysU3;

{$R *.DFM}


{ == Functions to translate Process Flag == }

Function PTtoCB(PT  : Char)  :  Integer;

Begin
  If (PT='T') then
    Result:=1
  else
    If (PT='P') then
      Result:=2
    else
      Result:=0;
end;


Function CBtoPT(CB  :  Integer)  :  Char;

Const
  CBAry  :  Array[0..2] of Char = (#32,'T','P');

Begin
  If (CB In [0..2]) then
    Result:=CBAry[CB]
  else
    Result:=CBAry[0];

end;

{ ==== Procedure to Display Address ==== }

Procedure TIntStatInv.OutIS;

Begin
  ISDelF.Text:=ISDelTerms;
  ISTTF.Value:=ISTransNat;
  ISMTF.Value:=ISTransMode;
  ISPTF.ItemIndex:=PTtoCB(ISProcessFlag);
end;


Procedure TIntStatInv.SetISStore(EnabFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Font.Assign(ISDELF.Font);
      Color:=ISDELF.Color;


      If (Tag=1) then
        ReadOnly:= EnabFlg;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Font.Assign(ISDELF.Font);
        Color:=ISDELF.Color;

        If (Tag=1) then
          ReadOnly:= EnabFlg;
      end
      else
        If (Components[Loop] is TSBSComboBox) then
        With (Components[Loop] as TSBSComboBox) do
        Begin
          Font.Assign(ISDELF.Font);
          Color:=ISDELF.Color;

          If (Tag=1) then
            ReadOnly:= EnabFlg;
        end;
  end;

end;

Procedure TIntStatInv.Form2IS;

Begin
  ISDelTerms:=ISDelF.Text;
  ISTransNat:=Round(ISTTF.Value);
  ISTransMode:=Round(ISMTF.Value);
  ISProcessFlag:=CBtoPT(ISPTF.ItemIndex);
end;


Function TIntStatInv.InitIS(VO    :  Boolean;
                            Col1  :  TColor;
                            Fon1  :  TFont):  Word;


Begin
  With ISDelF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;


  SetISStore(VO);

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
    Form2IS;

end;




procedure TIntStatInv.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TIntStatInv.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;




procedure TIntStatInv.ISDelFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidDelTerms(Text);

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;

procedure TIntStatInv.ISTTFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidNatTran(Round(Value));

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;


procedure TIntStatInv.ISMTFExit(Sender: TObject);
Var
  FoundOk,
  AltMod     :  Boolean;

begin
  If (Sender is TCurrencyEdit) then
  With (Sender as TCurrencyEdit) do
  Begin
    AltMod:=Modified;

    If (AltMod) and (ActiveControl<>ClsCP1Btn) then
    Begin

      StillEdit:=BOn;

      FoundOk:=ValidModeTran(Round(Value));

      If (Not FoundOk) and (CanFocus) then {* Credit Check *}
      Begin
        SetFocus;
        {FieldNextFix(Self.Handle,ActiveControl,Sender);}

      end
      else
      Begin
        {StopPageChange:=BOn;}

      end; {If not found..}

    end;
  end;

end;




procedure TIntStatInv.OkCP1BtnClick(Sender: TObject);
begin
  // MH 21/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on date and Period/Year
  //                                   fields which processes the text and updates the value
  If OkCP1Btn.CanFocus Then
    OkCP1Btn.SetFocus;
end;

procedure TIntStatInv.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);
end;

end.
