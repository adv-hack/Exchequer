unit WOBOMIsU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst;


type
  TWOBOMIssue = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    PAMntF: TCurrencyEdit;
    SBSBackGroup1: TSBSBackGroup;
    PALab: Label8;
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
      BCurSymb   : String[5];

      Function InitIS(SuggQty  :  Double;
                      BOMId    :  IDetail)  :  Word;

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

Procedure TWOBOMIssue.OutIS;


Begin
  PAmntF.Value:=PAValue;
end;



Procedure TWOBOMIssue.Form2IS;

Begin
  PAValue:=PAmntF.Value;

end;


Function TWOBOMIssue.InitIS(SuggQty  :  Double;
                            BOMId    :  IDetail)  :  Word;


Begin
  PAValue:=SuggQty;
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



procedure TWOBOMIssue.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TWOBOMIssue.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TWOBOMIssue.FormCreate(Sender: TObject);
begin
  ClientHeight:=98;
  ClientWidth:=180;
  
  PAmntF.DecPlaces:=Syss.NoQtyDec;
end;

end.
