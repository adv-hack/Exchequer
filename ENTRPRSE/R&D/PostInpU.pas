unit PostInpU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Repinp1u, StdCtrls, Animate, ExtCtrls, SBSPanel, bkgroup, TEditVal,
  VarConst, BTSupU3, BorBtns, ComCtrls, TCustom;

type
  TPostFilt = class(TRepInpMsg)
    Inc1: TButton;
    IncList: TListBox;
    IncAll: TButton;
    Exc1: TButton;
    ExcAll: TButton;
    ExcList: TListBox;
    Label81: Label8;
    Label82: Label8;
    ProModeChk: TBorCheck;
    SepPModeChk: TBorCheck;
    panTrialBalanceWarning: TPanel;
    lblTrialBalanceWarning: TLabel;
    btnMoreInfo: TButton;
    btnSchedule: TSBSButton;
    panSQLPostingNotification: TPanel;
    shSQLPostingNotification: TShape;
    lblInfo: TLabel;
    Label1: TLabel;
    lblSQLPostingNotificationMoreInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Inc1Click(Sender: TObject);
    procedure Exc1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure ProModeChkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SepPModeChkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IncListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure IncListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure btnMoreInfoClick(Sender: TObject);
    procedure btnScheduleClick(Sender: TObject);
    procedure lblSQLPostingNotificationMoreInfoClick(Sender: TObject);
  private
    { Private declarations }
    PostMode  :  Byte;
    AutoOn    :  Boolean;
    CRepParam :  PostRepPtr;
    TrialBalanceCheck : Double;
    lblAnotherPost : TLabel;

    procedure SetIncList;

    procedure BuildIncExcSets;

    Procedure CreateEntry(DT  :  DocTypes);

    procedure CheckTrialBalance;

    // MH 05/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
    procedure CheckSQLPostingStatus;

    function AnyPostRunning : Boolean;
  public
    { Public declarations }
    Ask       :  Boolean;
    RPParam   :  TPrintParamPtr;

    IncDocSet,
    ExcDocSet   :  DocSetType;

  end;

  procedure PrePostInput(AOwner  :  TComponent;
                       PMode   :  Byte;
                       PAsk    :  Boolean;
                       PParam  :  TPrintParamPtr);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  GlobVar,
  PostingU,
  BTKeys1U,
  BTSupU1,
  BTSupU2,
  DayBk2,
  PWarnU,

  {$IFDEF JC}
    JPstInpU,
  {$ENDIF}

  SalTxl1U,
  TrialBalanceWarningF,

  GenWarnU,
  ApiUtil,
  DateUtils,
  SchedulerDllInterface,
  SQLUtils,
  SavePos,
  BtrvU2,
  ExWrap1U,

  // MH 05/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
  SQLRep_Config, SQLPostingPromptF,

  oProcessLock;

{$R *.DFM}

Var
  GPMode  :  Byte;


Type
  PostDocType  =  Class (TObject)
                    DT  :  DocTypes;
                  end;

  PostDocPtr   =  PostDocType;


Procedure TPostFilt.CreateEntry(DT  :  DocTypes);

Var
  PDR   :  PostDocPtr;

Begin
  PDR:=PostDocType.Create;

  PDR.DT:=DT;

  IncList.Items.AddObject(dbFormatName(DocCodes[DT],DocNames[DT]),PDR);
end;

procedure TPostFilt.SetIncList;

Const
 DDocPWMode     :  Array[DocTypes] of SmallInt       = ( 355,  356, 357,  359, 360, 362, 361,  358,  -255,  -255,  363,  -254,  -254,  -254,  -254,
                                                         364,  365, 366,  368, 369, 371, 370,  367,  -255,  -255,  372,  -254,  -254,  -254,  -254,
                                                        -255, -254,-254, -254,-254,-255,-254, -254 , -254,  -254, -254 , -254,  -254,  -254,  -254,-254
                                                        , -254 , -254,  -254,  -254,  -254 );



Var
  PSet  :  DocSetType;

  DT    :  DocTypes;

  PDR   :  PostDocPtr;


Begin
  GetPostMode(PostMode,PSet);

  If (CommitAct) and (Not AutoOn) then
  Begin
    PSet:=PSet-DeliverSet;

    If (Not ChkAllowed_In(272)) then
      PSet:=PSet-[POR];

    If (Not ChkAllowed_In(270))  then
      PSet:=PSet-[SOR];
  end
  else
    PSet:=PSet-PSOPSet;

  For DT:=SIN to ADJ do
  Begin
    If (DT In PSet) and (ChkAllowed_In(DDocPWMode[DT])) then
    Begin
      CreateEntry(DT);

    end;
  end;

  {$IFDEF JC}
     If (JBCostOn) and ((SIN In PSet) or (PIN In PSet) or (NMT In PSet)) and (ChkAllowed_In(216)) and (Not AutoOn) then
     Begin
       CreateEntry(JRN);

     end;

  {$ENDIF}

end;


procedure TPostFilt.FormCreate(Sender: TObject);
Var
  Locked  :  Boolean;

begin
  inherited;
  ClientHeight:=266;
  ClientWidth:=450;

  PostMode:=GPMode;

  AutoOn:=(PostMode>10);

  Caption:=Build_Title(PostMode)+' Choose Transaction Types.';

  If (Owner is TDayBk1) then
  With TDayBk1(Owner) do
  Begin
    IncList.Color:=db1ORefPanel.Color;
    IncList.Font.Color:=db1ORefPanel.Font.Color;
    ExcList.Color:=db1ORefPanel.Color;
    ExcList.Font.Color:=db1ORefPanel.Font.Color;
  end;

  If (AutoOn) then
    PostMode:=PostMode-20;

  RPParam:=nil;
  Ask:=BOn;

  IncDocSet:=[];
  ExcDocSet:=[];

  New(CRepParam);

  try
    FillChar(CRepParam^,Sizeof(CRepParam^),0);
  except
    Dispose(CRepParam);
    CRepParam:=nil;
  end;


  SetIncList;


  Locked:=BOff;


  {$IFDEF LTE}
    ProModeChk.Visible:=BOff;
    ProModeChk.Checked:=BOn;
  {$ELSE}
    If (BTFileVer>=6) then
    Begin
      GetMultiSys(BOff,Locked,SysR);

      ProModeChk.Checked:=Syss.ProtectPost;
    end
    else
      ProModeChk.Enabled:=BOff;


  {$ENDIF}

  SepPModeChk.Checked:=Syss.SepRunPost;

  SBSPanel1.Visible:=BOff;
  Animated1.Play:=BOff;

  // MH 05/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status Warning - suppress for ADJ Daybook
  If SQLUtils.UsingSQL And (PostMode <> 4) Then
    CheckSQLPostingStatus;

  // MH 05/10/2010 v6.4 ABSEXCH-9791: Added warning if Trial Balance is out
  CheckTrialBalance;
end;

//-------------------------------------------------------------------------

// MH 05/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
procedure TPostFilt.CheckSQLPostingStatus;
Begin // CheckSQLPostingStatus
  // Check to see if SQL Posting is disabled
  If (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] <> psPassed) Then
  Begin
    shSQLPostingNotification.Brush.Color := RGB(0, 159, 223);
    shSQLPostingNotification.Pen.Color := shSQLPostingNotification.Brush.Color;

    panSQLPostingNotification.Visible := True;
    Self.ClientHeight := Self.ClientHeight + panSQLPostingNotification.Height;
  End; // If (SQLReportsConfiguration.SQLPostingStatus[SQLUtils.GetCompanyCode(SetDrive)] <> psPassed)
End; // CheckSQLPostingStatus

//-------------------------------------------------------------------------

procedure TPostFilt.CheckTrialBalance;
Begin // CheckTrialBalance
  If (Not IsTrialBalanceOK (TrialBalanceCheck)) Then
  Begin
    // Display warning message
    panTrialBalanceWarning.Visible := True;
    lblTrialBalanceWarning.Caption := 'Warning: Your Trial Balance is out by ' + FormatCurFloat(GenRealMask, TrialBalanceCheck, BOff, 0);
    btnMoreInfo.Enabled := True;

    //PR: Check for a post currently running which may be causing the imbalance.
    if AnyPostRunning or SQLUtils.UsingSQL then
    begin
      lblAnotherPost := TLabel.Create(Self);
      lblAnotherPost.Parent := panTrialBalanceWarning;
      lblAnotherPost.AutoSize := False;
      lblAnotherPost.Left := lblTrialBalanceWarning.Left;
      lblAnotherPost.Width := lblTrialBalanceWarning.Width;
      lblAnotherPost.Font.Color := clRed;
      lblAnotherPost.Height := 75;
      lblAnotherPost.Top := 27;

      lblAnotherPost.WordWrap := True;
      if AnyPostRunning then
      begin
        lblAnotherPost.Caption := '(Please note: Another daybook post is currently running. This may be causing a temporary imbalance.)';
        panTrialBalanceWarning.Height := 90;
      end
      else
      begin  //Using SQL so can't tell whether there is a post running in the same instance - show permanent message
        lblAnotherPost.Caption := '(Please note: Another daybook post could currently be running, causing a temporary imbalance. ' +
                                     'Please check that there are no additional daybook posts running.)';
        panTrialBalanceWarning.Height := 98;
      end;
      lblAnotherPost.Visible := True;
    end;
    ClientHeight := ClientHeight + panTrialBalanceWarning.Height;
  End; // If (Not IsTrialBalanceOK (TrialBalanceCheck))
End; // CheckTrialBalance

//-------------------------------------------------------------------------

procedure TPostFilt.Inc1Click(Sender: TObject);

Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=IncAll);

  With IncList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        ExcList.Items.AddObject(Items[n],Items.Objects[n]);

        {Dispose(Items.Objects[n]);}

        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;
  end;

end;

procedure TPostFilt.Exc1Click(Sender: TObject);
Var
  n,m,i  :  Integer;

  SendAll
       :  Boolean;

begin
  inherited;

  SendAll:=(Sender=ExcAll);

  With ExcList do
  If (SelCount>0) or (SendAll) then
  Begin
    n:=0; m:=0;

    i:=Items.Count-1;

    While (m<=i) do
    Begin
      {$B-}

      If (SendAll) or (Selected[n]) then

      {$B+}
      Begin
        IncList.Items.AddObject(Items[n],Items.Objects[n]);

        Items.Delete(n);
      end
      else
        Inc(n);

      Inc(m);
    end;

  end;
end; {Porc..}


procedure TPostFilt.FormClose(Sender: TObject; var Action: TCloseAction);

Var
  n  :  Integer;



begin
  inherited;

  With IncList,Items do
    For n:=0 to Count-1 do
    Begin
      If (Assigned(Items.Objects[n])) then
        PostDocPtr(Items.Objects[n]).Destroy;

    end;


  With ExcList,Items do
    For n:=0 to Count-1 do
    Begin
      If (Assigned(Items.Objects[n])) then
        PostDocPtr(Items.Objects[n]).Destroy;

    end;

  If (Assigned(CRepParam)) then
    Dispose(CRepParam);


  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Release process lock if cancelled
  if ModalResult <> mrOK then
    SendMessage(Application.MainForm.Handle, WM_LOCKEDPROCESSFINISHED, Ord(plDaybookPost), 0);
end;


procedure TPostFilt.BuildIncExcSets;

Var
  n     :  Integer;
  PDR   :  PostDocPtr;

Begin
  IncDocSet:=[];
  ExcDocSet:=[];

  With IncList,Items do
    For n:=0 to Count-1 do
    Begin
      If (Assigned(Items.Objects[n])) then
      Begin
        PDR:=PostDocPtr(Items.Objects[n]);

        IncDocSet:=IncDocSet+[PDR.DT];
      end;
    end;


  With ExcList,Items do
    For n:=0 to Count-1 do
    Begin
      If (Assigned(Items.Objects[n])) then
      Begin
        PDR:=PostDocPtr(Items.Objects[n]);

        ExcDocSet:=ExcDocSet+[PDR.DT];
      end;
    end;

end;

procedure TPostFilt.OkCP1BtnClick(Sender: TObject);

Var
  StartedOk, bContinue  :  Boolean;

begin
  StartedOk:=BOff;

  If (Sender=OKCP1Btn) then
  Begin
    // MH 05/10/2010 v6.4 ABSEXCH-9791: Added warning if Trial Balance is out
    bContinue := Not IsTrialBalanceBorked(TrialBalanceCheck);
    If (Not bContinue) Then
      bContinue := DisplayTrialBalanceWarning(Self, TrialBalanceCheck);

    If bContinue Then
    Begin
      BuildIncExcSets;

      If (JRN In IncDocSet) then
      Begin
        IncDocSet:=IncDocSet-[JRN];

        CRepParam^.PostJCDBk:=BOn;
      end;

      CRepParam^.IncDocFilt:=IncDocSet;

      If (AutoOn) then
        With CRepParam^ do
        Begin
          PostMode:=PostMode+20;
        end;

      AddPost2Thread(PostMode,Application.MainForm,Owner,Ask,RPParam,CRepParam,StartedOk);

      {$IFDEF JC}
        {$B+}
          If (StartedOk) and (CRepParam^.PostJCDBk) and Got_JCTransToPost then {Kick start Job Daybook post}
        {$B-}
            JPrePostInput(Owner,0);

      {$ENDIF}

      inherited;
    End; // If bContinue
  End // If (Sender=OKCP1Btn)
  Else
  begin
    inherited;
  end;
end;



procedure PrePostInput(AOwner  :  TComponent;
                       PMode   :  Byte;
                       PAsk    :  Boolean;
                       PParam  :  TPrintParamPtr);

Var
  RepInpMsg1  :  TPostFilt;
Begin
  //PR: 15/05/2017 ABSEXCH-18683 v2017 R1 Check for running processes
  if not GetProcessLock(plDaybookPost) then
    EXIT;

  GPMode:=PMode;

  RepInpMsg1:=TPostFilt.Create(AOwner);

  Try
    If (Assigned(PParam)) then
      RepInpMsg1.RPParam^:=PParam^;

    RepInpMsg1.Ask:=PAsk;

    //PR: 17/12/2010 Don't show Schedule button for Auto Daybooks as Scheduler doesn't run an auto post.
    //PR: 21/03/2011 ABSEXCH-11087. Scheduler can't post all daybooks, so don't show button on Post All Daybooks option
    if GPMode in [0, 21, 22] then
    with RepInpMsg1 do
    begin
      btnSchedule.Visible := False;
      OKCp1Btn.Left := 142;
      ClsCp1Btn.Left := 228;
    end;

  except
    RepInpMsg1.Free;

  end;



end;



procedure TPostFilt.ProModeChkMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  Locked  :  Boolean;

begin
  inherited;

  Locked:=BOn;

  If (Sender=ProModeChk) then
  Begin
    If (GetMultiSys(BOn,Locked,SysR)) then
    Begin
      Syss.ProtectPost:=ProModeChk.Checked;

      PutMultiSys(SysR,BOn);


      If (Syss.ProtectPost) then
        CustomDlg(Application.MainForm,'Please Note!','Posting Transactions',
                             ' When Protected Mode posting is switched on, it will be possible to recover '+
                             'from a crash during posting in most cases, however Protected mode will slow other '+
                             'workstations down considerably.'+#13+
                             'The posting should be run at maximum speed to reduce this effect.'+#13+
                             'Using Protected Mode is NOT a substitute for taking regular backups. Backups are still essential.',
                             mtInformation,
                             [mbOk])
      else
        CustomDlg(Application.MainForm,'Please Note!','Posting Transactions',
                             ' When Protected Mode posting is switched off, it will not be possible to recover '+
                             'from a crash during posting without unposting, or reverting to a backup, however Protected mode will slow other '+
                             'workstations down considerably.'+#13+
                             'Do not switch Protected Mode off if the posting run has previously crashed, as this will prevent '+
                             'The system from recovering the posting data.',
                             mtInformation,
                             [mbOk])

    end;
  end;
end;



procedure TPostFilt.SepPModeChkMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
Var
  Locked  :  Boolean;

begin
  inherited;

  Locked:=BOn;

  If (Sender=SepPModeChk) then
  Begin
    If (GetMultiSys(BOn,Locked,SysR)) then
    Begin
      Syss.SepRunPost:=SepPModeChk.Checked;

      PutMultiSys(SysR,BOn);
    end;
  end;

end;

procedure TPostFilt.IncListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  inherited;

  //GS: 06/05/11 added the 'if Sender <> Source' clause before a drop operation is commenced
  //this means that if the user returns the item they are currently dragging to its source control,
  //the drop behavior will no longer execute
  if Sender <> Source then
    If (Source=ExcList) then
      Exc1Click(Nil)
    else
      If (Source =IncList) then
        Inc1Click(Nil);
end;


procedure TPostFilt.IncListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept:=(Sender = IncList) or (Sender = ExcList);
end;

procedure TPostFilt.btnMoreInfoClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, TrialBalanceWarningHelpContext);
end;

procedure TPostFilt.btnScheduleClick(Sender: TObject);
var
  bContinue : Boolean;
  bSchedulerRunning : Boolean;
  dtLastTimeStamp : TDateTime;
  Res : Integer;

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
  //Mark's trial balance stuff
  bContinue := Not IsTrialBalanceBorked(TrialBalanceCheck);
  If (Not bContinue) Then
    bContinue := DisplayTrialBalanceWarning(Self, TrialBalanceCheck);


  //Check if Scheduler engine running. If it isn't then we can still allow the user to elect to proceed - it's then their
  //responsibility to get the engine started. SchedulerInterval is declared in ScheduleDllInterface.pas
  //GetSchedulerTimeStamp will return the most recent time stamp that the Scheduler has put in the configuration file. If it was not possible
  //to load Schedule.dll then the function will return 1 and we'll call LibraryNotLoaded to display an error message.

  dtLastTimeStamp := GetSchedulerTimeStamp;

  if dtLastTimeStamp = 1 then
    LibraryNotLoaded
  else
  begin
    bSchedulerRunning := Abs(SecondsBetween(dtLastTimeStamp, Now)) < SchedulerInterval;

    if bContinue and not bSchedulerRunning then
      bContinue := msgBox('The Scheduler engine is not currently running. Do you wish to continue with this post?', mtConfirmation, [mbYes, mbNo], mbNo,
                          'Schedule Post') = mrYes;

    If bContinue Then
    Begin
      //Put doc types which have been selected into IncDocSet
      BuildIncExcSets;
      //PR: 18/04/2011 Added Screen parameter to avoid dialog in dll hiding when help is shown. ABSEXCH-11266
      //Do standard daybook - Sales, Purch, Nominal, Stock
      Res := AddScheduledPost(Application, Screen, SetDrive, GetUserID, GetUserEmail, IncDocSet - [JRN], ProModeChk.Checked, SepPModeChk.Checked, PostMode, 0);

      if (Res = 0) and (JRN in IncDocSet) then  //Do Job daybook
        Res := AddScheduledPost(Application, Screen, SetDrive, GetUserID, GetUserEmail, [], ProModeChk.Checked, SepPModeChk.Checked, 5, 15{All Job Options});

      if Res = 0 then  //Close form
        PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end;
  end;
end;

function TPostFilt.AnyPostRunning: Boolean;
Const
  Fnum     =  MiscF;
  Keypath  =  MIK;
Var
  KeyS  :  Str255;
  Res, i : Integer;
  LAddr
        :  LongInt;
  MTExLocal : TdMTExLocal;
begin
  Result := False;
  MTExLocal.Create(65);
  MTExLocal.Open_System(MiscF, MiscF);
  Try
    for i := 1 to 4 do
    begin
      KeyS:=FullPLockKey(PostUCode,PostLCode,i);

      Res := MTExLocal.LFind_Rec(B_GetEq+B_SingNWLock,Fnum,KeyPath,KeyS);

      if Res = 0 then
        MTExLocal.LFind_Rec(B_UnLock,Fnum,KeyPath,KeyS)
      else
      if Res in [84, 85] then
      begin
        Result := True;
        Break;
      end;
    end;
  Finally
    MTExLocal.Close_Files;
    MTExLocal.Destroy;
  End;
end;

//-------------------------------------------------------------------------

procedure TPostFilt.lblSQLPostingNotificationMoreInfoClick(Sender: TObject);
begin
  // MH 05/01/2018 2017-R1 ABSEXCH-19316: Added new SQL Posting Status
  // Open the help file to the More Information page
  Application.HelpCommand(HELP_CONTEXT, 2315);
end;

//-------------------------------------------------------------------------

Initialization

  GPMode:=0;

end.
