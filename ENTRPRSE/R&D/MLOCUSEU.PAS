unit MLocUseU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup;

type
  TMLUseI = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    PkMntF: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    PKLab: Label8;
    PAmntF: TCurrencyEdit;
    PALab: Label8;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      PKValue,
      PAValue    : Double;

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
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TMLUseI.OutIS;


Begin
  PAmntF.Value:=PAValue;
  PKmntF.Value:=PKValue;
end;



Procedure TMLUseI.Form2IS;

Begin
  PAValue:=PAmntF.Value;
  PKValue:=PKmntF.Value;
end;


Function TMLUseI.InitIS(VO    :  Boolean;
                       Col1  :  TColor;
                       Fon1  :  TFont):  Word;

Var
  Mid  :  Integer;

Begin
  With PAmntF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  If (Syss.InpPack) then
  With PKmntF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end
  else
  Begin
    PKmntF.Visible:=BOff;
    PKLab.Visible:=BOff;

    Mid:=Round((Self.Width/2)-(PAmntF.Width/2));
    PALab.Left:=Mid;
    PAMntF.Left:=Mid;
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



procedure TMLUseI.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TMLUseI.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


end.
