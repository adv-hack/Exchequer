unit JPstInpU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, Animate, ExtCtrls, SBSPanel, StdCtrls, bkgroup, TEditVal,
  BorBtns,
  JobSup1U,
  JobPostU, ComCtrls, TCustom;


type
  TJPostFilt = class(TRepInpMsg)
    PCOMChk: TBorCheck;
    PJDChk: TBorCheck;
    PTSChk: TBorCheck;
    Label86: Label8;
    PCERChk: TBorCheck;
    btnSchedule: TSBSButton;
    procedure FormCreate(Sender: TObject);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure btnScheduleClick(Sender: TObject);
  private
    { Private declarations }
    JPostCtrl  :  JInvHedRec;

  public
    { Public declarations }
  end;


procedure JPrePostInput(AOwner  :  TComponent;
                        PMode   :  Byte);

Function  Got_JCTransToPost  :  Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  VarConst,
  BTKeys1U,
  BTrvU2,
  BTSupU1,
  BTSupU2,
  GenWarnU,
  ApiUtil,
  DateUtils,
  SchedulerDllInterface;


{$R *.DFM}



procedure TJPostFilt.FormCreate(Sender: TObject);
begin
  PComChk.Checked:=BOn;
  PJDChk.Checked:=BOn;
  PTSChk.Checked:=BOn;
  PCERChk.Checked:=BOn;

  inherited;
  ClientHeight:=191;
  ClientWidth:=305;

  SBSPanel1.Visible:=BOff;
//  Animated1.Play:=BOff;

  FillChar(JPostCtrl,Sizeof(JPostCtrl),0);


end;

procedure TJPostFilt.OkCP1BtnClick(Sender: TObject);

Var
  SMode  :  Byte;

begin
  If (Sender=OKCP1Btn) then
  Begin

    With JPostCtrl do
    Begin
      ChkComm:=PCOmChk.Checked;
      PostJD:=PJDChk.Checked;
      ChkExpRet:=PCERChk.Checked;

      SMode:=1+(2*Ord(PTSChk.Checked));

    end;

    AddJobPost2Thread(Self.Owner,SMode,'',@JPostCtrl,TForm(Self.Owner).Handle);

  end;

  inherited;

end;


procedure JPrePostInput(AOwner  :  TComponent;
                        PMode   :  Byte);

Var
  RepInpMsg1  :  TJPostFilt;

Begin

  RepInpMsg1:=TJPostFilt.Create(AOwner);


end;


{ == Function Got Trans to post == }

Function  Got_JCTransToPost  :  Boolean;

Const
  Fnum      =  JDetlF;
  Keypath   =  JDPostedK;

Var
  KeyChk,
  KeyS      :  Str255;

Begin
  KeyChk:=PartCCKey(JBRCode,JBECode)+FullNomKey(0);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  Result:=(StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));


end;

procedure TJPostFilt.btnScheduleClick(Sender: TObject);
var
  bContinue : Boolean;
  bSchedulerRunning : Boolean;
  Res : Integer;
  JobOpts : Byte;
  dtLastTimeStamp : TDateTime;

  function GetUserID : string;
  begin
    if UserProfile^.Loaded then
      Result := Trim(UserProfile^.Login)
    else
      Result := Trim(EntryRec^.Login);
  end;

  function GetUserEmail : string;
  begin
    if UserProfile^.Loaded then
      Result := Trim(UserProfile^.EmailAddr)
    else
      Result := '';
  end;


begin

  //Check if Scheduler engine running. If it isn't then we can still allow the user to elect to proceed - it's then their
  //responsibility to get the engine started. SchedulerInterval is declared in ScheduleDllInterface.pas
  //GetSchedulerTimeStamp will return the most recent time stamp that the Scheduler has put in the configuration file. If it was not possible
  //to load Schedule.dll then the function will return 1 and we'll LibraryNotLoaded to display an error message.

  dtLastTimeStamp := GetSchedulerTimeStamp;

  if dtLastTimeStamp = 1 then
    LibraryNotLoaded
  else
  begin
    bSchedulerRunning := Abs(SecondsBetween(GetSchedulerTimeStamp, Now)) < SchedulerInterval;

    if bSchedulerRunning then
      bContinue := True
    else
      bContinue := msgBox('The Scheduler engine is not currently running. Are you sure you wish to continue with this post?', mtConfirmation, [mbYes, mbNo], mbNo,
                          'Schedule Post') = mrYes;

    If bContinue Then
    Begin
      //Pass through selected options
     JobOpts := 0;
     if PComChk.Checked then
       JobOpts := JobOpts or 1;
     if PJdChk.Checked then
       JobOpts := JobOpts or 2;
     if PTsChk.Checked then
       JobOpts := JobOpts or 4;
     if PCerChk.Checked then
       JobOpts := JobOpts or 8;

     //PR: 18/04/2011 Added Screen parameter to avoid dialog in dll hiding when help is shown.  ABSEXCH-11266
     Res := AddScheduledPost(Application, Screen, SetDrive, GetUserID, GetUserEmail, [], Syss.ProtectPost, Syss.SepRunPost, 5, JobOpts);

      if Res = 0 then  //Close form
        PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

end.
