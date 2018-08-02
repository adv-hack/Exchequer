unit BTSFrmU1;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel,GlobVar,BtrvU2,
  ExWrap1U;


type
  TBTWaitLock = class(TForm)
    SBSPanel1: TSBSPanel;
    SBSPanel2: TSBSPanel;
    SBSPanel3: TSBSPanel;
    Image1: TImage;
    Label81: Label8;
    Label82: Label8;
    SBSPanel4: TSBSPanel;
    Timer1: TTimer;
    AbortBtn: TButton;
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure AbortBtnClick(Sender: TObject);
  private
    { Private declarations }

    PrevHState    :  Boolean;
    TestFunc,
    TestFnum,
    TestKeypath,
    TestLockType  :  Integer;

    TestKey2S     :  Str255;

    TestBtRec     :  RecCPtr;

    Aborted       :  Boolean;

    //MTExLocal     :  TdMTExLocalPtr;


    Procedure Test_Lock;


  public
    { Public declarations }

    Procedure Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                        Key2S                       :  Str255;
                        BtRec                       :  RecCPtr;
                        MTClient                    :  Pointer);

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
  BTSupU1{,
  BTSupU2};

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
  BMap1    :  TBitMap;

  RectD    :  TRect;

begin
  ClientHeight:=136;
  ClientWidth:=270;

  SetAllowHotKey(BOff,PrevHState);

  //MTExLocal:=nil;

  If (Owner is TForm) then
  Begin
    TmpForm:=TForm(Owner);

    Top:=TmpForm.Height-Height;
    Left:=TmpForm.Width-Width;
  end
  else
  Begin
    Top:=Screen.Height-Height;
    Left:=Screen.Width-Width;
  end;

  BMap1:=TBitMap.Create;

  Aborted:=BOff;

  BMap1.Handle:=LoadBitMap(HInstance,'INFO_1');

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


procedure TBTWaitLock.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  SetAllowHotKey(BOn,PrevHState);
end;

Procedure TBTWaitLock.Test_Lock;


Var
  BCode  :  Integer;

  TimeStart,
  TimeElapsed
         :  TDateTime;
  ShowAbort
         :  Boolean;

Begin

  Timer1.Enabled:=BOff;

  TimeStart:=Time;

  ShowAbort:=BOff;

  Repeat

    TimeElapsed:=Time-TimeStart;

    If (Not ShowAbort) and (TimeElapsed>300) then
    Begin
      AbortBtn.Visible:=BOn;
      ShowAbort:=BOn;
    end;

    SBSPanel4.Caption:=TimeToStr(TimeElapsed);

    (*
    If (Assigned(MTExLocal)) then {* Use threads own version *}
      With MTExLocal^ do
        BCode:=LTry_Lock(TestFunc,B_SingNWLock+TestLockType,TestKey2S,TestKeypath,TestFnum,TestBtRec)
    else
    *)
      BCode:=Try_Lock(TestFunc,B_SingNWLock+TestLockType,TestKey2S,TestKeypath,TestFnum,TestBtRec);

    //MDI_UpdateParentStat;

    Application.ProcessMessages;

  Until (BCode=0) or (Aborted);


  If (BCode=0) then
    ModalResult:=mrOk
  else
    ModalResult:=mrCancel;

end;

Procedure TBTWaitLock.Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                                Key2S                       :  Str255;
                                BtRec                       :  RecCPtr;
                                MTClient                    :  Pointer);



Begin
  TestFunc:=Func;
  TestFnum:=Fnum;
  TestKeypath:=Keypath;
  TestLockType:=LockType;
  TestKey2S:=Key2S;
  TestBtRec:=BtRec;

  //MTExLocal:=MTClient;

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




procedure TBTWaitLock.AbortBtnClick(Sender: TObject);

Var
  mbRet  :  Word;
begin

  mbRet:=MessageDlg('The system has detected a record lock.'+#13+
                    'You should only abort if you are sure no other user or thread are locking records.'+#13+#10+
                    'Aborting at this point when a record is genuinely locked could cause data corruption.'+#13+#10+
                    'Please confirm you wish to abort this record lock',mtConfirmation,[mbYes,mbNo],0);

  Aborted:=(mbRet=mrYes);

  AbortBtn.Enabled:=Not Aborted;
end;

end.
