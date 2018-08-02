unit BTSFrmU1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel,GlobVar,BtrvU2,
  ExWrap1U;


type
  TBTWaitLock = class(TForm)
    SBSPanel1: TSBSPanel;
    SBSPanel2: TSBSPanel;
    Image1: TImage;
    Label81: Label8;
    Label82: Label8;
    SBSPanel4: TSBSPanel;
    Timer1: TTimer;
    AbortBtn: TButton;
    Label83: Label8;
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

    MTExLocal     :  TdMTExLocalPtr;


    Procedure Test_Lock;


  public
    { Public declarations }

    Procedure Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                        Key2S                       :  Str255;
                        BtRec                       :  RecCPtr;
                        MTClient                    :  TdMTExLocalPtr);

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
  BTSupU1,
  BtSupu2,
  DateUtils;

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
  BMap1    :  TBitMap;
  RectD    :  TRect;
begin
  //TW: 03/08/2011 Adjusted height slightly.
  ClientHeight:=126;
  ClientWidth:=270;
  
  SetAllowHotKey(BOff,PrevHState);

  MTExLocal:=nil;

  //TW: 03/08/2011 Adjusted position slightly.
  If (Owner is TForm) then
  begin
    Top := Application.MainForm.Top + Application.MainForm.ClientHeight - Height + 25;
    Left := Application.MainForm.Left + Application.MainForm.ClientWidth - Width + 5;
  end
  else
  begin
    Top := Screen.Height-Height;
    Left := Screen.Width-Width;
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
  BCode : Integer;
  TimeStart, TimeElapsed : TDateTime;
  ShowAbort : Boolean;
Begin
  Timer1.Enabled := false;
  ShowAbort := false;
  TimeStart := Time;
 
  Repeat
    //TW: 03/08/2011 ABSEXCH-11360 Changed time elapsed to show abort button after 5 minutes.
                                   
    TimeElapsed := MinutesBetween(Time,TimeStart);

    If (not ShowAbort) and (TimeElapsed >= 5) then
    Begin
      AbortBtn.Visible := true;
      ShowAbort := true;
      //Change height so abort button is visible.
      self.Height := self.Height + 28;
      self.Top  := self.Top - 28;
    end;
    //Improved message to user.
    SBSPanel4.Caption:= Format('Time Elapsed: %s',[TimeToStr(Time - TimeStart)]);

    If (Assigned(MTExLocal)) then {* Use threads own version *}
      With MTExLocal^ do
        BCode:=LTry_Lock(TestFunc,B_SingNWLock+TestLockType,TestKey2S,TestKeypath,TestFnum,TestBtRec)
    else
      BCode:=Try_Lock(TestFunc,B_SingNWLock+TestLockType,TestKey2S,TestKeypath,TestFnum,TestBtRec);

    MDI_UpdateParentStat;

    Application.ProcessMessages;
  Until (BCode = 0) or (not (BCode in [84,85])) or (Aborted);

  If (BCode=0) then
    ModalResult:=mrOk
  else
    ModalResult:=mrCancel;
end;

Procedure TBTWaitLock.Init_Test(Func,Fnum,Keypath,LockType  :  Integer;
                                Key2S                       :  Str255;
                                BtRec                       :  RecCPtr;
                                MTClient                    :  TdMTExLocalPtr);



Begin
  TestFunc:=Func;
  TestFnum:=Fnum;
  TestKeypath:=Keypath;
  TestLockType:=LockType;
  TestKey2S:=Key2S;
  TestBtRec:=BtRec;

  MTExLocal:=MTClient;

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
