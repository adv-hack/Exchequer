unit GIRateU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar,VarConst;

type
  TGetInCrate = class(TForm)
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    ClsCP1Btn: TButton;
    OkCP1Btn: TButton;
    DefVATF: TSBSComboBox;
    Label84: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    PrevHState  :  Boolean;

    Procedure OutIS;

    Procedure SetISStore(EnabFlg  :  Boolean);

    Procedure Form2IS;

  public
    { Public declarations }
    IRate   :  Char;


    Function InitIRate(VO    :  Boolean;
                       Col1  :  TColor;
                       Fon1  :  TFont):  Word;
  end;

  Function ClientPos(X,Y  :  LongInt)  :  TPoint;

  Procedure GetIRate(SP          :  TPoint;
                     Col1        :  TColor;
                     Fon1        :  TFont;
                     AOwner      :  TControl;
                     VO          :  Boolean;
                Var  VATIncFlg   :  Char);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  BTSupU1,
  BTSupU2;

{$R *.DFM}


procedure TGetInCrate.FormCreate(Sender: TObject);
begin
  Build_DefaultCVAT(DefVATF.Items,BOff,BOff,BOff,BOff);
  Build_DefaultCVAT(DefVATF.ItemsL,BOff,BOff,BOff,BOn);

  Caption:=Caption+CCVATName^+' Rate.';

  IRate:=VATStdCode;
end;


{ ==== Procedure to Display Address ==== }

Procedure TGetInCrate.OutIS;

Begin
  IF (IRate In VATSet) then
    DefVATF.ItemIndex:=GetVATCIndex(IRate,BOn)
  else
    DefVATF.ItemIndex:=0;
end;


Procedure TGetInCrate.SetISStore(EnabFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TSBSComboBox) then
    With (Components[Loop] as TSBSComboBox) do
    Begin
      Font.Assign(DefVATF.Font);
      Color:=DefVATF.Color;


      If (Tag=1) then
        ReadOnly:= EnabFlg;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Font.Assign(DefVATF.Font);
        Color:=DefVATF.Color;

        If (Tag=1) then
          ReadOnly:= EnabFlg;
      end;
  end;

end;

Procedure TGetInCrate.Form2IS;

Begin
  With DefVATF do
    If (ItemIndex>=0) then
      IRate:=Items[ItemIndex][1];

end;


Function TGetInCrate.InitIRate(VO    :  Boolean;
                               Col1  :  TColor;
                               Fon1  :  TFont):  Word;


Begin
  With DefVATF do
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




procedure TGetInCrate.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TGetInCrate.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Function ClientPos(X,Y  :  LongInt)  :  TPoint;

Begin
  Result.X:=X;
  Result.Y:=Y;
end;

procedure GetIRate(SP          :  TPoint;
                   Col1        :  TColor;
                   Fon1        :  TFont;
                   AOwner      :  TControl;
                   VO          :  Boolean;
              Var  VATIncFlg   :  Char);

Var
  mrResult  :  Word;
  ISCtrl    :  TGetIncRate;

begin

  Begin
    ISCtrl:=TGetIncRate.Create(AOwner);

    try

      With ISCtrl do
      Begin
        Top:=SP.Y; Left:=SP.X;

        IRate:=VatIncFlg;

        mrResult:=InitIRate(VO,Col1,Fon1);

        If (mrResult=mrOk) then
        Begin
          VATIncFlg:=IRate;
        end;
      end;

    finally

      ISCtrl.Free;

    end; {Try..}

  end; {with..}

end;



end.
