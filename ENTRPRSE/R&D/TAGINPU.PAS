unit TagInpU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup,
  GlobVar, VarConst;


type
  TSetTagNo = class(TForm)
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
      PAValue    : Byte;

      Function InitIS(SuggQty,Mode  :  Byte)  :  Word;


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

Procedure TSetTagNo.OutIS;


Begin
  PAmntF.Value:=PAValue;
end;



Procedure TSetTagNo.Form2IS;

Begin
  PAValue:=Round(ABS(PAmntF.Value));

end;


Function TSetTagNo.InitIS(SuggQty,Mode  :  Byte)  :  Word;


Begin
  PAValue:=SuggQty;

  Case Mode of
    1  :  PALab.Caption:='Unset all Tag Number';
  end; {Case..}

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



procedure TSetTagNo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TSetTagNo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TSetTagNo.FormCreate(Sender: TObject);
begin
  ClientHeight:=98;
  ClientWidth:=180;
  
  PAmntF.DecPlaces:=0;
end;

end.
