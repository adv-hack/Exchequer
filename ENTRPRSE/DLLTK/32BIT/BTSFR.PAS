unit BTSFrmU1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  WinTypes, WinProcs,
  StdCtrls, ExtCtrls, GlobVar,BtrvU2;


type
  TBTWaitLock = class(TForm)
    Timer1: TTimer;
    SBSPanel1: TPanel;
    SBSPanel3: TPanel;
    SBSPanel2: TPanel;
    SBSPanel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }

    PrevHState    :  Boolean;
    TestFunc,
    TestFnum,
    TestKeypath,
    TestLockType  :  Integer;

    TestKey2S     :  Str255;

    TestBtRec     :  RecCPtr;

    Procedure Test_Lock;


  public
    { Public declarations }

    Procedure Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                        Key2S                       :  Str255;
                        BtRec                       :  RecCPtr);

  end;


Function Try_Lock(Func      :  Integer;
                  LockType  :  Integer;
              Var Key2S     :  Str255;
                  KeyPth    :  Integer;
                  Fnum      :  Integer;
                  BtRec     :  RecCPtr)  :  Integer;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  BTSupU1;

{$R *.DFM}


{ ============ Lock via a DirectCall ============ }

Function Lock_Direct(Func  :  Integer;
                     Fnum  :  Integer;
                     KeyPth:  Integer;
                     BtRec :  RecCPtr)  :  Integer;


Var
  LockCode  :  Integer;
  RecAddr   :  LongInt;



Begin
  LockCode:=GetPos(F[Fnum],Fnum,RecAddr);

  If (LockCode=0) then
  Begin
    SetDataRecOfsPtr(Fnum,RecAddr,BtRec^);

    LockCode:=GetDirect(F[Fnum],Fnum,BtRec^,KeyPth,Func);
  end;

  Lock_Direct:=LockCode;

end;


{ ======= Lower Level Routine to Atempt a Record Lock ========= }

Function Try_Lock(Func      :  Integer;
                  LockType  :  Integer;
              Var Key2S     :  Str255;
                  KeyPth    :  Integer;
                  Fnum      :  Integer;
                  BtRec     :  RecCPtr)  :  Integer;


Begin

   If (Func<>B_GetDirect) then
    Try_Lock:=Find_Rec(Func+LockType,F[Fnum],Fnum,BtRec^,KeyPth,Key2s)
  else
    Try_Lock:=Lock_Direct(LockType,Fnum,KeyPth,BtRec);

end; {Func..}


procedure TBTWaitLock.FormCreate(Sender: TObject);

Var
  TmpForm  :  TForm;
  BMap1    :  TPicture;

  RectD    :  TRect;

begin
  {SetAllowHotKey(BOff,PrevHState);}

  If (Owner is TForm) then
  Begin
    TmpForm:=TForm(Owner);

    Top:=TmpForm.Height-Height;
    Left:=TmpForm.Width-Width;
  end;

  BMap1:=TPicture.Create;

  BMap1.Bitmap.Handle:=LoadBitMap(HInstance,'INFO_1');

  With BMap1 do
    RectD:=Rect(0,0,Width,Height);


  With Image1.Picture.Bitmap do
  Begin
    Width:=BMap1.Width;
    Height:=BMap1.Height;

    Canvas.Brush.Color:=clBtnFace;
    Canvas.BrushCopy(RectD,BMap1.Bitmap,RectD,clSilver);
  end;

  BMap1.Free;
end;


procedure TBTWaitLock.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  {SetAllowHotKey(BOn,PrevHState);}
end;

Procedure TBTWaitLock.Test_Lock;


Var
  BCode  :  Integer;

  TimeStart,
  TimeElapsed
         :  TDateTime;

Begin

  Timer1.Enabled:=BOff;

  TimeStart:=Time;


  Repeat

    TimeElapsed:=Time-TimeStart;

    SBSPanel4.Caption:=TimeToStr(TimeElapsed);

    BCode:=Try_Lock(TestFunc,B_SingNWLock+TestLockType,TestKey2S,TestKeypath,TestFnum,TestBtRec);

    Application.ProcessMessages;

  Until (BCode=0) ;


  If (BCode=0) then
    ModalResult:=mrOk
  else
    ModalResult:=mrCancel;

end;

Procedure TBTWaitLock.Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                                Key2S                       :  Str255;
                                BtRec                       :  RecCPtr);



Begin
  TestFunc:=Func;
  TestFnum:=Fnum;
  TestKeypath:=Keypath;
  TestLockType:=LockType;
  TestKey2S:=Key2S;
  TestBtRec:=BtRec;

end; {Proc..}


procedure TBTWaitLock.FormShow(Sender: TObject);

Begin

  Timer1.Enabled:=BOn;

end; {Proc..}

procedure TBTWaitLock.Timer1Timer(Sender: TObject);
begin
  Test_Lock;

  Timer1.Enabled:=BOff;

end;




end.
