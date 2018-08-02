unit WOPWizIU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst, BorBtns;


type
  TWORWizBuild = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    PAMntF: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    PALab: Label8;
    BorCheck1: TBorCheck;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    private
      PrevHState  :  Boolean;

      Procedure OutIS;

      Procedure Form2IS;

    public
      { Public declarations }
      PAValue    : Double;
      SetBuild   : Boolean;

      Function InitIS(SuggQty  :  Double;
                      SuggBuild:  Boolean)  :  Word;

  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  SBSComp2,
  CurrncyU,
  BTSupU1,
  BTSupU2;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TWORWizBuild.OutIS;


Begin
  PAmntF.Value:=PAValue;
  BorCheck1.Checked:=SetBuild;
end;



Procedure TWORWizBuild.Form2IS;

Begin
  PAValue:=PAmntF.Value;
  SetBuild:=BorCheck1.Checked;

end;


Function TWORWizBuild.InitIS(SuggQty  :  Double;
                            SuggBuild:  Boolean)  :  Word;

Begin
  PAValue:=SuggQty;
  SetBuild:=SuggBuild;

  OutIS;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin

    Form2IS;
  end;
end;



procedure TWORWizBuild.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TWORWizBuild.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TWORWizBuild.FormCreate(Sender: TObject);
begin
  ClientHeight:=139;
  ClientWidth:=180;

  PAmntF.DecPlaces:=Syss.NoQtyDec;
end;

end.
