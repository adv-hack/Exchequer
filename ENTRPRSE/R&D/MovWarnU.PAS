unit MovWarnU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Buttons, BorBtns;


type
  TMovWarnFrm = class(TForm)
    SBSPanel1: TSBSPanel;
    OkCP1Btn: TButton;
    Label81: Label8;
    Label82: Label8;
    SBSPanel2: TSBSPanel;
    CLMsgL: Label8;
    Label86: Label8;
    Image1: TImage;
    Label83: Label8;
    CanCP1Btn: TButton;
    SBSPanel3: TSBSPanel;
    Label84: Label8;
    cb1: TBorCheckEx;
    cb2: TBorCheckEx;
    Label85: Label8;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure cb1Click(Sender: TObject);
  private
    { Private declarations }
    Focus2    :  Boolean;
  public
    { Public declarations }

    procedure DisplayWarning(const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                                     Buttons: TMsgDlgButtons);

  end;


Function MovCustomDlg(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                   Buttons: TMsgDlgButtons;
                   SetBtn2Focus  :  Boolean = False)  :  TModalResult;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  GlobVar,
  VarConst,
  BTSupU1,
  BTSupU2,
  ExThrd2U;

{$R *.DFM}

procedure TMovWarnFrm.FormCreate(Sender: TObject);

begin
  ClientHeight:=471;
  ClientWidth:=275;

end;

procedure TMovWarnFrm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TMovWarnFrm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TMovWarnFrm.DisplayWarning(const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                                     Buttons: TMsgDlgButtons);


Const
  ExClamName  :  Array[TMsgDlgType] of PChar = ('EXCLAM_2','EXCLAM_3','INFO_1','EXQMARK_1','EXQMARK_2');

Var
  BMap1       :  TBitMap;

  RectD       :  TRect;

  WhichBtn    :  TButton;

  NoBtns      :  Byte;

Begin
  If Not NoXLogo then
  Begin
    BMap1:=TBitMap.Create;

    BMap1.Handle:=LoadBitMap(HInstance,ExClamName[AType]);

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
  end;{If..}

  Caption:=Cap;
  Label86.Caption:=Cap;
  CLMsgL.Caption:=Sub;

  Label83.Caption:=Msg;

  NoBtns:=0;

  If (mbOk In Buttons) or (mbYes In Buttons) then
  Begin
    Inc(NoBtns);

    WhichBtn:=OkCp1Btn;

    If (mbYes In Buttons) then
      WhichBtn.Caption:='&Yes';

    WhichBtn.Visible:=BOn;
  end;

  If (mbCancel In Buttons) or (mbNo In Buttons) then
  Begin
    Inc(NoBtns);

    WhichBtn:=CanCp1Btn;

    If (mbNo In Buttons) then
      WhichBtn.Caption:='&No';

    WhichBtn.Visible:=BOn;
  end;

  If (NoBtns=1) then
  With WhichBtn do
  Begin
    Left:=(Self.Width Div 2)-(Width Div 2);

    Cancel:=True;

  end;

end;

procedure TMovWarnFrm.cb1Click(Sender: TObject);
begin
  OkCP1Btn.Enabled:=cb1.Checked and cb2.Checked;
end;


{ ========== Return Modal Result =========== }

Function MovCustomDlg(Sender  :  TWinControl; const Cap,Sub,Msg: AnsiString; AType: TMsgDlgType;
                   Buttons: TMsgDlgButtons;
                   SetBtn2Focus  :  Boolean = False)  :  TModalResult;

Var
  GenFrm  :  TMovWarnFrm;
  PrevHState
          :  Boolean;


Begin
  GenFrm:=TMovWarnFrm.Create(Sender);

  try

   With GenFrm do
   Begin
     DisplayWarning(Cap,Sub,Msg,AType,Buttons);

     SetAllowHotKey(BOff,PrevHState);
     Set_BackThreadMVisible(BOn);

     If (SetBtn2Focus) and (CanCP1Btn.CanFocus) then
       ActiveControl:=CanCP1Btn;

     Result:=ShowModal;


   end;

  finally

   GenFrm.Free;

   Set_BackThreadMVisible(BOff);

   SetAllowHotKey(BOn,PrevHState);
  end;
end;



end.
