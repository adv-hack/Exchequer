unit ExTHSu1U;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1,
  BTSupU3, ComCtrls, BorBtns, bkgroup;

type
  ThreadIdRec  =  Class(TObject)
                    IdNo  :  LongInt;
                  end;

  TThreadFormQ =  Record
                    Radio  :  TBorRadio;
                    IdNo   :  LongInt;
                  end;


  TProgTForm = class(TForm)
    SBSPanel1: TSBSPanel;
    Label81: Label8;
    SBSPanel2: TSBSPanel;
    Gauge1: TGauge;
    CanCP1Btn: TButton;
    ListBox1: TListBox;
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    Label2: Label8;
    Label3: Label8;
    Label4: Label8;
    MU1Btn: TButton;
    MD1Btn: TButton;
    DelBtn: TButton;
    Thc1: TBorRadio;
    Thc2: TBorRadio;
    Thc3: TBorRadio;
    TrackBar1: TTrackBar;
    Label82: Label8;
    Label83: Label8;
    Label85: Label8;
    SBSBackGroup1: TSBSBackGroup;
    SBSBackGroup2: TSBSBackGroup;
    TermBtn: TButton;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure MU1BtnClick(Sender: TObject);
    procedure DelBtnClick(Sender: TObject);
    procedure Thc1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure TermBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);

    private
      SysMenuH   :  HWnd;
      OldCursor  :  TCursor;


      Procedure Send_UpdateList(Mode   :  Integer);

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

      Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;

      procedure UpdateSysMenu;

      procedure SetSysMenu;
    {  procedure WMSetFocus(var Msg : TMessage); message WM_SetFocus;}
    public
      { Public declarations }
      KeyR  :  TModalResult;
      ThreadFinished
            :  Boolean;

      ThreadFormQ
            :  Array[1..3] of TThreadFormQ;

      MsgCallBack
            :  TSBSMsgEvent;

      UpdateThreadList
            :  TSBSMoveEvent;

      UnlockList
            :  TNotifyEvent;


      procedure ShutDown;

      procedure SetButtonStatus(Enab  :  Boolean);


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTSupU2,
  ExThMsgU;

{$R *.DFM}


Const
  CM_AutoMin  =  CM_Base + $F0;
  CM_AutoMax  =  CM_Base + $F1;


procedure TProgTForm.CanCP1BtnClick(Sender: TObject);
begin
  KeyR:=mrAbort;

  If (Assigned(MsgCallBack)) then
    MsgCallBack(Self,1,'Please confirm you wish to Abort the current job.');

end;



procedure TProgTForm.TermBtnClick(Sender: TObject);
begin
  TermBtn.Enabled:=BOff;

  If (Assigned(MsgCallBack)) then
    MsgCallBack(Self,3,'Please confirm you wish to terminate this thread.');

end;


Procedure TProgTForm.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      0
         :  Begin
              Label4.Caption:='';

            end;

      1  :  Begin
              Label4.Caption:='Record in use by another Station. Waiting...';

            end;


      20
         :  If (Assigned(MsgCallBack)) then
              MsgCallBack(Self,4,'');

      21 :  TermBtn.Enabled:=BOn;

      22
         :  If (Assigned(MsgCallBack)) then
              MsgCallBack(Self,5,'');

    end; {Case..}

  end; {With..}

  Inherited;

end;

Procedure TProgTForm.WMSysCommand(Var Message  :  TMessage);

Var
  Locked,
  TBo  :  Boolean;

Begin
  With Message do
    Case WParam of

      {CM_AutoMin,
      CM_AutoMax    :  Begin
                         Locked:=BOn;

                         TBo:=(WParam=CM_AutoMax);

                         GetMultiSys(BOn,Locked,SysR);

                         Syss.AMMThread[TBo]:=Not Syss.AMMThread[TBo];

                         If (Syss.AMMThread[Not TBo]) and (Syss.AMMThread[TBo]) then
                           Syss.AMMThread[Not TBo]:=BOff;

                         PutMultiSys(SysR,BOn);

                         UpdateSysMenu;

                       end;}

      CM_AutoMin    :  Begin
                         Locked:=BOn;

                         If (GetMultiSys(BOff,Locked,SysR)) then
                         Begin

                           If (Syss.AMMThread) then
                             Syss.AMMThread:=False
                           else
                             Syss.AMMThread:=True;


                           PutMultiSys(SysR,BOn);

                           UpdateSysMenu;
                         end;
                       end;
    end; {Case..}

  Inherited;
end;


Procedure TProgTForm.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}

procedure TProgTForm.ShutDown;

Begin
  //PostMessage(Self.Handle,WM_Close,0,0);
  Gauge1.Progress := 0;
  Label1.Caption := '';
  Label2.Caption := '';
  Label3.Caption := '';
  Label4.Caption := '';
  Caption := 'ObjectThread Controller - Idle';
  Thc1.Caption := 'Idle';
  Thc3.Caption := 'Idle';
end;


procedure TProgTForm.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n       :  Integer;

begin
  Action:=caFree;
  {Screen.Cursor:=OldCursor;}

  Screen.Cursor:=crDefault;


  For n:=0 to Pred(ListBox1.Items.Count) do
    Begin
      If (Assigned(ListBox1.Items.Objects[n])) then
        ListBox1.Items.Objects[n].Free;
    end;

end;

procedure TProgTForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=ThreadFinished;

{  If (Not CanClose) then
  Begin
    If (Assigned(MsgCallBack)) then
      MsgCallBack(Self,0,'A background task is still running. Please wait for this task to finish.');
  end;}

    {ShowMessage();}
end;


{procedure TProgTForm.UpdateSysMenu;

Var
  MF_Check  :  Integer;

Begin
  If (Syss.AMMThread[BOff]) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_String+MF_Check,CM_AutoMin,'&Auto Minimize');

  If (Syss.AMMThread[BOn]) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMax,MF_ByCommand+MF_String+MF_Check,CM_AutoMax,'A&uto Maximize');
end;

procedure TProgTForm.SetSysMenu;

Begin
  SysMenuH:=GetSystemMenu(Handle,BOff);

  DeleteMenu(SysMenuH,6,MF_ByPosition);
  DeleteMenu(SysMenuH,5,MF_ByPosition);

  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMin,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMax,'');

  UpdateSysMenu;
end;}



procedure TProgTForm.UpdateSysMenu;

Var
  MF_Check  :  Integer;

Begin
  If (Syss.AMMThread) then
    MF_Check:=MF_Checked
  else
    MF_Check:=0;

  ModifyMenu(SysMenuH,CM_AutoMin,MF_ByCommand+MF_String+MF_Check,CM_AutoMin,'&Auto Minimize');

end;

procedure TProgTForm.SetSysMenu;

Begin
  SysMenuH:=GetSystemMenu(Handle,BOff);

  DeleteMenu(SysMenuH,6,MF_ByPosition);
  DeleteMenu(SysMenuH,5,MF_ByPosition);

  AppendMenu(SysMenuH,MF_SEPARATOR,0,'');

  AppendMenu(SysMenuH,MF_String,CM_AutoMin,'');

  UpdateSysMenu;
end;

procedure TProgTForm.FormCreate(Sender: TObject);
begin
  ClientHeight:=220;
  ClientWidth:=513;

  OldCursor:=Screen.Cursor;
  Screen.Cursor:=CrAppStart;

  ThreadFinished:=BOff;

  SetSysMenu;

  Blank(ThreadFormQ,Sizeof(ThreadFormQ));

  ThreadFormQ[1].Radio:=Thc1;
  ThreadFormQ[2].Radio:=Thc2;
  ThreadFormQ[3].Radio:=Thc3;

  Left:=(Application.MainForm.ClientWidth-Width)-10;
  Top:=(Application.MainForm.ClientHeight-Height)-60;

  If (Syss.AMMThread) then
    WindowState:=wsMinimized;



end;

procedure TProgTForm.MU1BtnClick(Sender: TObject);

Var
  Ok2Cont  :  Boolean;
  OldItemIndex,
  NewIndex :  Integer;

  VisiRec  :  ThreadIdRec;

begin
  If (ListBox1.ItemIndex>=0) and (Assigned(UpdateThreadList)) then
  With ListBox1 do
  Begin
    SetButtonStatus(BOff);

    If (Assigned(UnLockList)) then
      UnLockList(nil);

    try
      OldItemIndex:=ItemIndex;
      Ok2Cont:=((ItemIndex>0) and (Sender=MU1Btn)) or ((ItemIndex<Pred(Items.Count)) and (Sender=MD1Btn));

      If (Ok2Cont) and (ItemIndex>0) then
      Begin
        NewIndex:=ItemIndex+(Ord((Sender=MD1Btn))+(-1*Ord(Sender=MU1Btn)));

        ListBox1.Items.Move(ItemIndex,NewIndex);
        If (CanFocus) then
        Begin
          SetFocus;
          ItemIndex:=NewIndex;
        end;

        If (Assigned(UpdateThreadList)) then
        Begin
          VisiRec:=ThreadIdRec(Items.Objects[ItemIndex]);

          UpDateThreadList(Self,0,VisiRec.IdNo,ItemIndex-OldItemIndex);
        end;

      end;
    finally
      If (Assigned(UnLockList)) then
        UnLockList(Self);

      SetButtonStatus(BOn);
    end;
  end; {With..}
end;

procedure TProgTForm.DelBtnClick(Sender: TObject);

Var
  VisiRec    :  ThreadIdRec;
  CurrIndex  :  Integer;

begin
  If (ListBox1.ItemIndex>=0) and (Assigned(UpdateThreadList)) then
  With ListBox1 do
  Begin
    

    try
      CurrIndex:=ItemIndex;

      If (CurrIndex>=0) then
      Begin
        VisiRec:=ThreadIdRec(Items.Objects[CurrIndex]);

        UpDateThreadList(Self,1,VisiRec.IdNo,0);

        VisiRec.Free;

        Items.Delete(CurrIndex);

        If (CanFocus) then
        Begin
          SetFocus;
          If (CurrIndex<=Pred(ListBox1.Items.Count)) then
            ItemIndex:=CurrIndex
          else
            If (Pred(ListBox1.Items.Count)>=0) then
              ItemIndex:=0;

        end;
      end;
    Finally
      If (Assigned(UnLockList)) then
        UnLockList(Self);

      SetButtonStatus(BOn);
    end; {try..}
  end;
end;

procedure TProgTForm.SetButtonStatus(Enab  :  Boolean);

Begin
  DelBtn.Enabled:=Enab;
  MD1Btn.Enabled:=Enab;
  MU1Btn.Enabled:=Enab;
end;

procedure TProgTForm.Thc1Click(Sender: TObject);
begin

  If (Assigned(UpdateThreadList)) then
    UpDateThreadList(Self,2,TBorRadio(Sender).Tag,0);

end;

procedure TProgTForm.TrackBar1Change(Sender: TObject);
begin
  If (Assigned(UpdateThreadList)) then
    UpDateThreadList(Self,3,TrackBar1.Position,0);

end;

procedure TProgTForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TProgTForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


procedure TProgTForm.FormShow(Sender: TObject);
begin
  if not Application.mainForm.Visible then
  begin
    ShowWindow(Application.Handle, SW_HIDE);
  end;
end;

{procedure TProgTForm.WMSetFocus(var Msg : TMessage);
var
  OtherID, MyID : Longint;
begin
  if not Visible then
  with Msg do
  begin
    OtherID := GetWindowThreadProcessId(HWnd(wParam), nil);
    MyID := GetCurrentThreadId;
    if AttachThreadInput(MyID, OtherID, True) then
    begin
      Windows.SetFocus(HWnd(wParam));
      AttachThreadInput(MyID, OtherID, False);
      Result := 0;
    end;
  end;
end;}


end.
