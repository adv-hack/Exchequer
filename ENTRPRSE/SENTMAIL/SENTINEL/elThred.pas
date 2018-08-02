unit elThred;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, ExBtTh1u, SentU, ElVar, RepThrd1;

type

   TElThread  =  Object(TThreadQueue)
     private
       FSentinel : TSentinel;
     public
       Purpose : TSentinelPurpose;
       EName, UserID : ShortString;
       DataPath : AnsiString;
       FSendEmailRes : integer;
       Constructor Create(AOwner  :  TObject);
       Destructor  Destroy; Virtual;
       Function Start   :  Boolean; Virtual;
       procedure Process; virtual;
       procedure Finish; virtual;
       function SyncSendEmail : SmallInt;
       procedure DoSendEmail;
     end;

     TPollThread = Class(TElOpenThread)
     protected
       function GetTerminated : Boolean;
     public
       Constructor Create;
       Destructor  Destroy; override;
       procedure Execute; override;
       procedure SyncProgress;
       procedure SyncError;
       property IsTerminated : Boolean read GetTerminated;
     end;


   procedure AddELT2Q(AOwner : TObject; Ename, UserID : ShortString;
                      DataPath : AnsiString; APurpose : TSentinelPurpose; APriority : Byte);

   Procedure AddReportToQueue (const Ename, UID : ShortString;
                               Const RepName : ShortString;
                               const APath : AnsiString);

   Procedure AddNewReportToQueue (const Ename, UID : ShortString;
                                  Const ReportName : ShortString;
                                  const APath : AnsiString);

var
  PollThread : TPollThread;
  SyncEmailProc : Procedure;

implementation

uses
  ExThrd2U, Forms, SysUtils, GlobVar, RepObjCU, RepObjNU, RwFuncs, RwOpenF, BtSupU1,
  VarConst, Windows, DebugLog, CtkUtil04;

const
  BOn  = True;
  BOff = False;

{  ThreadDesc : Array[spQuery..spConveyor] of String[8] =
                 ('Running ', 'Sending ');
}

function ThreadDesc(Purpose : TSentinelPurpose) : String;
begin
  Case Purpose of
     spQuery, spReportQuery : Result := 'Running ';
     spConveyor,
     spReportConveyor,
     spCSVConveyor,
     spVisualReportConveyor : Result := 'Sending ';
     spEmailCheck : Result := 'Checking ';
  end;
end;

function TElThread.SyncSendEmail : SmallInt;
begin
  TQThreadObj.RunSync(DoSendEmail);
end;

procedure TElThread.DoSendEmail;
begin
  Try
    FSendEmailRes := EntEmail.Send;
  Except
    FSendEmailRes := 2;
  End;
end;


constructor TElThread.Create(AOwner : TObject);
begin
  Inherited Create(AOwner);


  fTQNo:=1;
  fCanAbort:=BOn;
//  fPrintJob:=BOn;

  fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

  MTExLocal:=nil;

end;

destructor TElThread.Destroy;
begin
  if Purpose in ConveyorSet then
  begin
    ConveyorLock.Enter;
    Try
      ConveyorInUse := False;
    Finally
      ConveyorLock.Leave;
    End;
  end
  else
  if Purpose in QuerySet then
  begin
    QueryLock.Enter;
    Try
      QueryInUse := False;
    Finally
      QueryLock.Leave;
    End;
  end;
  inherited Destroy;
end;

function TElThread.Start : Boolean;
begin
  LogIt(Purpose, 'TElThread.Start');
  InitProgress(100);
  Result := True;
  LogIt(Purpose, 'TElThread.Start - 145');
end;

procedure TElThread.Process;
begin
  FLocalFilesOpen := True;
  LogIt(Purpose, 'TElThread.Process');
  inherited Process;
  LogIt(Purpose, 'TElThread.Process - after inherited');
  Case Purpose of
    spQuery,
    spReportQuery    : FSentinel := TSentinelQuery.Create;
    spConveyor : FSentinel := TSentinelConveyor.Create(ConveyorID);  //PR: 21/09/2009 Memory Leak Change
    spReportConveyor : FSentinel := TSentinelReportConveyor.Create(ReportConveyorID); //PR: 21/09/2009 Memory Leak Change
    spCSVConveyor : FSentinel := TSentinelCSVConveyor.Create;
    spEmailCheck : FSentinel := TSentinelEmailChecker.Create;
    spVisualReportConveyor : FSentinel := TSentinelVisualReportConveyor.Create;

{    spQuery,
    spReportQuery    : FSentinel := ASentinelQuery;
    spConveyor : FSentinel := ASentinelConveyor;
    spReportConveyor : FSentinel := ASentinelReportConveyor;
    spCSVConveyor : FSentinel := ASentinelCSVConveyor;}

  end; //case
  LogIt(Purpose, 'TElThread.Process - after FSentinel.Create');

  Try
    FSentinel.ElertName := EName;
    FSentinel.User := UserID;
    FSentinel.DirectMode := False;
    FSentinel.DataPath := DataPath;
    {$IFNDEF SERVICE}
    FSentinel.OnThreadProgress := UpdateProgress;
    {$ENDIF}
    FSentinel.SendEmailProc := SyncSendEmail;
    LogIt(Purpose, 'TElThread.Process - before FSentinel.Run');
    if Purpose = spReportQuery then
      FSentinel.Run(True, True)
    else
      FSentinel.Run;
    LogIt(Purpose, 'TElThread.Process - After FSentinel.Run');
  Finally
    FSentinel.Free;
    LogIt(Purpose, 'Sentinel freed');
  End;

end;

procedure TElThread.Finish;
begin
  InPrint := BOff;
  LogIt(Purpose, 'TElThread.Finish');
  inherited Finish;
  LogIt(Purpose, 'TElThread.Finish - after inherited');
end;

procedure AddELT2Q(AOwner : TObject; Ename, UserID : ShortString;
                      DataPath : AnsiString; APurpose : TSentinelPurpose;
                      APriority : Byte);
var
  ELT1 : ^TElThread;
begin
LogIt(APurpose, 'AddELT2Q');
  if APurpose in [spQuery, spConveyor, spReportConveyor, spReportQuery,
                  spCSVConveyor, spEmailCheck, spVisualReportConveyor] then
  begin
    New(ELT1, Create(AOwner));
    ELT1^.EName := Trim(EName);
    ELT1^.UserID := UserID;
    ELT1^.Purpose := APurpose;
    ELT1^.DataPath := DataPath;
    if APurpose in [spQuery, spReportQuery] then
      ELT1^.fPrintJob := True
    else
      ELT1^.fPrintJob := False;
    ELT1^.fSetPriority := True;
    //PR: 02/06/2009 Change to make sure spReportQuery is added to thread 1, otherwise can clash with standard queries/reports
    if APurpose in [spQuery, spReportQuery] then
    begin
      ELT1^.FTQNo := 1;
      Case APriority of
        0 : ELT1^.fPriority := tpLower;
        1 : ELT1^.fPriority := tpHigher;
        else
          ELT1^.fPriority := tpLower;
      end;
    end
    else
    begin
      ELT1^.FTQNo := 3;
      ELT1^.fPriority := tpNormal;
    end;

   LogIt(APurpose, 'Before Create_BackThread');
    if Create_BackThread then
    begin
      LogIt(APurpose, 'Create_BackThread = True');
       if ELT1^.Start then
         BackThread.AddTask(ELT1, ThreadDesc(APurpose) + Trim(Ename));
    end
    else
      LogIt(APurpose, 'Create_BackThread = False');
  end
  else //spReport
  begin
    //not used
  end;
end;

Procedure AddReportToQueue (const Ename, UID : ShortString;
                            Const RepName : ShortString;
                            const APath : AnsiString);
Var
  EntTest   :  RepRunCtrlPtr;
  FoundCode : String;

  xInfo : TExtraRepInfoRec;
Begin
//  SetDrive := APath;
   xInfo.xDataPath := APath;
   xInfo.xRepName := RepName;

   {===== Open system stuff moved to GetReport in rwfuncs =============}
{   SetDrive := APath;
   Open_System ( 1, 15);
   Open_System (DictF, RepGenF);}

    {If GetReport (RepName, FoundCode) Then} Begin
      {GroupRepRec^ := RepGenRecs^;   { cannot set grouprec until processing starts }

      { Update all system records }
{      Init_AllSys;}
      {ReportDataPath := APath;}

      If (Create_BackThread) then Begin
       // Sleep(2000); //Try this to cure hang-up
        New (EntTest,Create(Application.MainForm, RepGenRecs^, xInfo));

        try
          With EntTest^ do Begin
            ReportMode:=1;
            FTQNo := 1;
            ElertName := Trim(EName);
            UserID := UID;
            If (Start) and (Create_BackThread) then
            Begin
              With BackThread do
                AddTask(EntTest,{RepCtrlRec^.RepDesc} 'Running ' + Trim(Ename));
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(EntTest,Destroy);
              Raise Exception.Create('Unable to start report');
            end;
          end; {with..}

        except
          Dispose(EntTest,Destroy);

        end; {try..}
      end; {If process got ok..}
    End; { If got report }
    //Close_Files(True);
End;

Procedure AddNewReportToQueue (const Ename, UID : ShortString;
                               Const ReportName : ShortString;
                               const APath : AnsiString);
var
  RepThread : ^TGUIReportThread;
begin
  LogIt(spReport, 'AddNewReporttoQueue');
      If (Create_BackThread) then Begin
        LogIt(spReport, 'Create_BackThread OK');
       // Sleep(2000); //Try this to cure hang-up
        New (RepThread,Create(Application.MainForm));

        try
          With RepThread^ do Begin
{            ReportMode:=1; }
            FTQNo := 1;
            ElertName := Trim(EName);
            UserID := Trim(UID);           
            DataPath := APath;
            RepName := ReportName;

            If {(Start) and} (Create_BackThread) then
            Begin
              //LogIt(spReport, 'After Start');
              With BackThread do
                AddTask(RepThread,{RepCtrlRec^.RepDesc} 'Running ' + Trim(Ename));
              LogIt(spReport, 'After Add Task');
            end
            else
            Begin
              Set_BackThreadFlip(BOff);
              Dispose(RepThread,Destroy);
              Raise Exception.Create('Unable to start report');
            end;
          end; {with..}

        except
          Dispose(RepThread,Destroy);

        end; {try..}
      end; {If process got ok..}

end;


Constructor TPollThread.Create;
begin
  inherited Create(True);
  Priority := tpLower;
  FreeOnTerminate := True;
  SyncProc := SyncProgress;
  SyncErr := SyncError;
end;

Destructor TPollThread.Destroy;
begin
  inherited Destroy;
end;

procedure TPollThread.Execute;
begin
  if Assigned(PollProc) then
//    Synchronize(PollProc);
    PollProc;
end;

procedure TPollThread.SyncProgress;
begin
  if Assigned(ProgressProc) then
    Synchronize(ProgressProc);
end;

function TPollThread.GetTerminated : Boolean;
begin
  Result := Terminated;
end;

procedure TPollThread.SyncError;
begin
  if Assigned(ErrorProc) then
    Synchronize(ErrorProc);
end;





end.
