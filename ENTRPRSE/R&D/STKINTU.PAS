unit StkIntU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar, bkgroup;

type
  TStkIntFrm = class(TForm)
    OkCP1Btn: TButton;
    ClsCP1Btn: TButton;
    CCodeF: Text8Pt;
    SSDUF: TCurrencyEdit;
    SWF: TCurrencyEdit;
    SBSPanel1: TSBSBackGroup;
    Label81: Label8;
    Label83: Label8;
    Label84: Label8;
    Label847: Label8;
    SUP: TCurrencyEdit;
    Label848: Label8;
    COF: Text8Pt;
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

    procedure SetHelpContextIDs; // NF: 21/06/06

  public
    { Public declarations }

    ISCCode  : String[8];
    COrig    : Str10;

    ISDUnit,
    ISW,ISUP : Double;



    Function InitIS(VO    :  Boolean;
                    Col1  :  TColor;
                    Fon1  :  TFont):  Word;



  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  VarConst,
  BTSupU1,
  BTSupU2;

{$R *.DFM}


{ ==== Procedure to Display Address ==== }

Procedure TStkIntFrm.OutIS;

Begin
  CCodeF.Text:=ISCCode;
  SSDUF.Value:=ISDUnit;
  SWF.Value:=ISW;
  SUP.Value:=ISUP;
  COF.Text:=CORig;
end;


Procedure TStkIntFrm.SetISStore(EnabFlg  :  Boolean);

Var
  Loop  :  Integer;

Begin

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is TMaskEdit) then
    With (Components[Loop] as TMaskEdit) do
    Begin
      Font.Assign(CCodeF.Font);
      Color:=CCodeF.Color;


      If (Tag=1) then
        ReadOnly:= EnabFlg;
    end
    else
      If (Components[Loop] is TCurrencyEdit) then
      With (Components[Loop] as TCurrencyEdit) do
      Begin
        Font.Assign(CCodeF.Font);
        Color:=CCodeF.Color;

        If (Tag=1) then
          ReadOnly:= EnabFlg;
      end;
  end;

end;

Procedure TStkIntFrm.Form2IS;

Begin
  ISCCode:=CCodeF.Text;
  ISDUnit:=SSDUF.Value;
  ISW:=SWF.Value;
  ISUP:=SUP.Value;
  CORig:=COF.Text;
end;


Function TStkIntFrm.InitIS(VO    :  Boolean;
                           Col1  :  TColor;
                           Fon1  :  TFont):  Word;


Begin
  With CCodeF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;


  SetISStore(VO);

  If (CurrentCountry<>IECCode) then
  Begin
    Label847.Visible:=BOff;
    SUP.Visible:=BOff;
  end;

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
    Form2IS;

end;

procedure TStkIntFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TStkIntFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TStkIntFrm.FormCreate(Sender: TObject);
begin
  SetHelpContextIDs; // NF: 21/06/06 Fix for incorrect Context IDs
end;

procedure TStkIntFrm.SetHelpContextIDs;
// NF: 21/06/06 Fix for incorrect Context IDs
begin
  CCodeF.HelpContext := 1855;
  SSDUF.HelpContext := 1856;
  SWF.HelpContext := 1857;
  COF.HelpContext := 1858;
  SUP.HelpContext := 1859;
end;


end.
