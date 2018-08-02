unit CSWarnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Buttons;

type
  TCredLimForm = class(TForm)
    SBSPanel1: TSBSPanel;
    OkCP1Btn: TButton;
    Label81: Label8;
    Label82: Label8;
    CLF: TCurrencyEdit;
    CBF: TCurrencyEdit;
    COF: TCurrencyEdit;
    CAF: TCurrencyEdit;
    CrLimit: Label8;
    ComitBal: Label8;
    Label83: Label8;
    Label84: Label8;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Image1: TImage;
    CWOF: TCurrencyEdit;
    Label85: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    procedure SetHelpContextIDs; // NF: 16/05/06
  public
    { Public declarations }
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  SysU2,
  BTSupU2;

{$R *.DFM}

procedure TCredLimForm.FormCreate(Sender: TObject);

Const
  ExClamName  :  Array[BOff..BOn] of PChar = ('EXCLAM_2','EXCLAM_3');

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;
begin
  ClientHeight:=259;
  ClientWidth:=275;


  BMap1:=TBitMap.Create;

  BMap1.Handle:=LoadBitMap(HInstance,ExClamName[Syss.StopBadDr]);

  With BMap1 do
    RectD:=Rect(0,0,Width,Height);


  With Image1.Picture.Bitmap do
  Begin
    Width:=BMap1.Width;
    Height:=BMap1.Height;

    Canvas.Brush.Color:=clBtnFace;
    Canvas.BrushCopy(RectD,BMap1,RectD,clSilver);
  end;

  BMap1.Free;

  SetHelpContextIDs; // NF: 16/05/06 Fix for incorrect Context IDs

  If (UseDebtWeeks(Syss.DebtLMode)) then
    Label85.Caption:='Weeks overdue'
  else
    Label85.Caption:='Days overdue';

end;

procedure TCredLimForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCredLimForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

// NF: 16/05/06 Fix for incorrect Context IDs
procedure TCredLimForm.SetHelpContextIDs;
begin
  HelpContext := 1813;
end;



end.
