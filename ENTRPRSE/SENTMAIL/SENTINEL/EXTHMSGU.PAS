unit ExThMsgU;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, Gauges,  BTSupU1,
  BTSupU3,SBSComp2;

type

  TThreadMsg = class(TForm)
    CanCP1Btn: TButton;
    SBSPanel3: TSBSPanel;
    Label1: Label8;
    Label2: Label8;
    Label3: Label8;
    Label4: Label8;
    NoCP1Btn: TButton;
    procedure CanCP1BtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDeactivate(Sender: TObject);

    private
      ThisMode   :  Byte;
      LabelList  :  Array[0..3] of TObject;

      Procedure Send_UpdateList(Mode   :  Integer);

      Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

      procedure ShutDown;


    public
      { Public declarations }
      KeyR        :  TModalResult;

      OTForm      :  THandle;

      ThreadRec   :  ^TMonRec;

      procedure AdjustWidth(LabNo       :  Integer;
                            AbortMode   :  Byte);


  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,
  VarConst,

  BTSupU2;

{$R *.DFM}



procedure TThreadMsg.CanCP1BtnClick(Sender: TObject);

Var
  mbRet  :  Word;

begin
  If (ModalResult=mrOk) and (Assigned(ThreadRec)) then
  With ThreadRec^ do
  Begin

    If (THPrintJob) then
    Begin
      mbRet:=MessageDlg('Do you wish to print the information processed so far?',
                         mtConfirmation,[mbYes,mbNo],0);

      THAbortPrint:=(mbRet=mrNo);
    end;

    If (ThisMode<>3) then
    Begin
      THAbort:=BOn;
      THShowAbort:=BOn;
    end
    else
      If (OTForm<>0) then {* Force a termination *}
        Send_UpdateList(20);

  end
  else
    If (OTForm<>0) and (ThisMode=3) then {* Reset termination status *}
      Send_UpdateList(21);


  
  ShutDown;
end;


Procedure TThreadMsg.WMCustGetRec(Var Message  :  TMessage);

Begin
  With Message do
  Begin


    Case WParam of

      0
         :  Begin
              Label4.Caption:='';
            end;


    end; {Case..}

  end; {With..}

  Inherited;

end;



Procedure TThreadMsg.Send_UpdateList(Mode   :  Integer);


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
    MessResult:=SendMEssage(OTForm,Msg,WParam,LParam);

end; {Proc..}

procedure TThreadMsg.ShutDown;

Begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;


procedure TThreadMsg.AdjustWidth(LabNo       :  Integer;
                                 AbortMode   :  Byte);

Var
  n,
  Offset1,
  OffSet2  :  Integer;

Begin
  OffSet1:=Width-(SBSPanel3.Width);
  OffSet2:=SBSPanel3.Width-Label1.Width;

  ThisMode:=AbortMode;

  If (Not (AborTMode In [2,3])) then
    Width:=Canvas.TextWidth(Label8(LabelList[LabNo]).Caption)+90;

  If (AbortMode=3) then
  Begin
    Label1.Caption:='Warning! Terminating a thread is a last resort option.';
    Label2.Caption:='Only terminate this thread if you are sure it has crashed.';
    Label3.Caption:='If you terminate this thread, close down Sentimail immediately.';
  end;

  SBSPanel3.Width:=Width-OffSet1;

  For n:=0 to 3 do
  Begin
    Label8(LabelList[n]).Width:=SBSPanel3.Width-OffSet2;

    If (n>0) and (AbortMode=2) then
      Label8(LabelList[n]).Visible:=BOff;
  end;

  Case AbortMode of
    1,3
       :  Begin
            With CanCp1Btn do
            Begin
              Cancel:=BOff;
              Caption:='&Yes';
              Left:=(Self.Width div 2) - ((Width+NOCp1Btn.Width+5) div 2);
            end;
            With NoCp1Btn do
            Begin
              Cancel:=BOn;
              Enabled:=BOn;
              Visible:=BOn;
              Left:=CanCp1Btn.Left+CanCp1Btn.Width+5;
            end;
          end;
    else  Begin
            CanCP1Btn.Left:=((Width div 2) - (CanCP1Btn.Width div 2));

            Case AbortMode of
              2  :  Label1.Height:=SBSPanel3.Height-9;
              4  :  Begin
                      NoCP1Btn.Visible:=BOff;
                      CanCP1Btn.Visible:=BOff;
                      BorderIcons:=[];
                    end;

            end; {Case..}

          end;
  end;


  Left := (Screen.Width div 2) - (Width div 2);
  Top := (Screen.Height div 2) - (Height div 2);

end;

procedure TThreadMsg.FormCreate(Sender: TObject);
begin
  ClientHeight:=131;
  ClientWidth:=299;

  LabelList[0]:=Label1;
  LabelList[1]:=Label2;
  LabelList[2]:=Label3;
  LabelList[3]:=Label4;

  ThreadRec:=nil;

  OTForm:=0;

end;

procedure TThreadMsg.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=BOn;

  If (OTForm<>0) and (ThisMode=1) then {* Resume all threads *}
    Send_UpdateList(22);

end;

procedure TThreadMsg.FormDeactivate(Sender: TObject);
begin
  PostMessage(Self.Handle,WM_Close,0,0);
end;

end.
