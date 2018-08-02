unit CLPAlU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup;

type
  TCLPAl = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    PAMntF: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    PALab: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      PAValue    : Double;
      BSDiscMode,
      BudgetMode,
      JCChargeMode
                 : Boolean;
      BCurSymb   : String[5];

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
  SBSComp2,
  CurrncyU,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TCLPAL.OutIS;


Begin
  PAmntF.Value:=PAValue;
end;



Procedure TCLPAL.Form2IS;

Begin
  PAValue:=PAmntF.Value;

end;


Function TCLPAL.InitIS(VO    :  Boolean;
                       Col1  :  TColor;
                       Fon1  :  TFont):  Word;


Begin
  With PAmntF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  If (BSDiscMode) then
  Begin
    Caption:='Settlement Write-off';
    PALab.Caption:='Write-off/Discount in '+BCurSymb;
    Self.HelpContext:=1167;
  end
  else
  If (Not BudgetMode) then
  Begin
    {$IFDEF MC_On}
      PALab.Caption:='How Much?';

      If (Not JCChargeMode) then
        PALab.Caption:=PALab.Caption+' (in '+Ssymb(0)+')';

    {$ENDIF}
  end;

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin
    LastValueObj.UpdateAllLastValues(Self);

    Form2IS;
  end;
end;



procedure TCLPAL.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TCLPAL.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TCLPAl.FormCreate(Sender: TObject);
begin
  ClientHeight:=98;
  ClientWidth:=180;
  BSDiscMode:=BOff;
  BudgetMode:=BOff;
end;

procedure TCLPAl.OkCP1BtnClick(Sender: TObject);
begin
  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on TCurrencyEdit which
  //                                   processes the text and updates the value
  OkCP1Btn.SetFocus;
end;

end.
