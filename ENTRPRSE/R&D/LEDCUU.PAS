unit LedCuU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  BorBtns, ExtCtrls, SBSPanel, TEditVal, StdCtrls, Mask,
  GlobVar,VarConst;

type
  TLCForm = class(TForm)
    SBSPanel1: TSBSPanel;
    ClsCP1Btn: TButton;
    OkCP1Btn: TButton;
    CDRCurrLab: Label8;
    CurrF: TSBSComboBox;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    procedure SetCaption(CSM  :  Byte);

  public

    Function InitAS(Var   CI    :  Byte;
                          CuStkM:  Byte;
                    Const Col1  :  TColor;
                    Const Fon1  :  TFont):  Word;


  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  tHEMEfIX, BTSupU2;

{$R *.DFM}




procedure TLCForm.SetCaption(CSM  :  Byte);


Begin
  Case CSM of
    1  :  Caption:='Set Currency';
    2  :  Caption:='Translate to';
  end;{Case..}

end;


Function TLCForm.InitAS(Var   CI    :  Byte;
                              CuStkM:  Byte;
                        Const Col1  :  TColor;
                        Const Fon1  :  TFont):  Word;


Begin
  With CurrF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
    ItemIndex:=CI;
  end;

  SetCaption(CuStkM);


  Result:=ShowModal;

  If (Result=mrOk) then
    CI:=CurrF.ItemIndex;

end;





procedure TLCForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TLCForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TLCForm.FormCreate(Sender: TObject);
begin
  // MH 10/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  Set_DefaultCurr(CurrF.Items,BOn,BOff);
  Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
end;

end.
