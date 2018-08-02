unit BnkWarnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Buttons;

type
  TBankWarnFrm = class(TForm)
    SBSPanel1: TSBSPanel;
    OkCP1Btn: TButton;
    Image1: TImage;
    BankWMsg: TLabel;
    CanCP1Btn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    DMode    :            Byte;

    procedure FormDesign;


  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  BTSupU2;

{$R *.DFM}

procedure TBankWarnFrm.FormCreate(Sender: TObject);

Const
  ExClamName  :  Array[BOff..BOn] of PChar = ('EXCLAM_2','EXCLAM_1');

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;
begin
  ClientHeight:=194;
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
end;

procedure TBankWarnFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TBankWarnFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TBankWarnFrm.FormDesign;

Begin
  Case DMode of
    0  :  Begin
            OkCP1Btn.Visible:=BOff;
            CanCP1Btn.Left:=100;

            BankWMsg.Caption:=#13+#13+'You must enter some bank entries first'+
                              #13+'before you can attempt to match.';

          end;

    1  :  Begin
            BankWMsg.Caption:=#13+'There are unmatched entries present'+#13+
                               'which will not be processed during'+#13+
                               'this run.'+#13+
                              'Once the matched items have been'+#13+
                              'processed, either correct/amend any'+#13+
                              'unmatched entries and run the match'+#13+
                              'procedure again, or use the Bank-Rec'+#13+
                              'option to manually clear them.';


          end;


  end; {Case..}
end;

end.
