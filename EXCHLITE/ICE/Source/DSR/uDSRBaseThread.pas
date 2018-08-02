{-----------------------------------------------------------------------------
 Unit Name: uDSRBaseThread
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
unit uDSRBaseThread;

interface

Uses Classes, Sysutils
  ;

Type
  TThreadType = (ttRead, ttWrite);

  {base thread that controls how and when the dowriting/reading is going to happen}
  TDSRThread = Class(TThread)
  Private
    fAlive: Boolean;
    Procedure SetThreadType(aType: TThreadType);
    Procedure RequestChange(aType: TTHreadType);
    Procedure ProcessRequest;
  Protected
    fMadeRequest: Boolean;
    fRequestType: TThreadType;
    fThreadType: TThreadType;
    fWorking: Boolean;
    Procedure DoReading; Virtual;
    Procedure DoWriting; Virtual;
    Procedure DoPause; Virtual;
    //Procedure OnDSRThreadTerminate(Sender: TObject);
    Procedure DoTerminate; Override;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Execute; Override;
    Property ThreadType: TThreadType Read fThreadType Write SetThreadType;
    Property Terminated;
    Property Working: Boolean Read fWorking Write fWorking;
    {this property is true when the thread is created and false when free}
    Property Alive: Boolean Read fAlive Write fAlive;
  Published
  End;


implementation

uses uCommon, uConsts;

{ TDSRThread }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRThread.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := True;
  fAlive := True;
//  OnTerminate := OnDSRThreadTerminate;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRThread.Destroy;
Begin
  fWorking := False;
  fAlive := False;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoPause
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.DoPause;
Begin
  {virtual method}
End;

{-----------------------------------------------------------------------------
  Procedure: DoReading
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.DoReading;
Begin
  {virtual method}
End;

{-----------------------------------------------------------------------------
  Procedure: DoWriting
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.DoWriting;
Begin
  {virtual method}
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura

  main execute method that controls the thread synchronization
-----------------------------------------------------------------------------}
Procedure TDSRThread.Execute;
Begin
  While Not Terminated Do
  Begin
    DoPause;

    If Terminated Then
      Break;

    fWorking := True;

    Try
      If (fThreadType = ttRead) And (Not Terminated) Then
        DoReading
      Else If (fThreadType = ttWrite) And (Not Terminated) Then
        DoWriting
      Else
        Terminate;
    Except
      On e: exception Do
      Begin
        _LogMSG('TDSRThread.Execute :- Error while executing thread. Error: ' +
          e.message);
        Terminate;
      End; {begin}
    End; {try}

    fWorking := False;

    If fMadeRequest Then
      ProcessRequest;

    If Terminated Then
      Break;

    Sleep(cDEFAULTPAUSE);
  End; {While Not Terminated Do}
End;

{-----------------------------------------------------------------------------
  Procedure: OnDSRThreadTerminate
  Author:    vmoura
-----------------------------------------------------------------------------}
//Procedure TDSRThread.OnDSRThreadTerminate(Sender: TObject);
Procedure TDSRThread.DoTerminate;
Begin
  If Assigned(FatalException) Then
  Begin
    Try
      _LogMSG('TDSRThread.OnDSRThreadTerminate :- A thread exception has occurred');
      _LogMSG('TDSRThread.OnDSRThreadTerminate :- Sender: ' + Self.ClassName);
      _LogMSG('TDSRThread.OnDSRThreadTerminate :- Class name: ' +
        FatalException.ClassName);
    Except
    End; {try}
  End; {If Assigned(FatalException) Then}

  Inherited DoTerminate;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessRequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.ProcessRequest;
Begin
  fThreadType := fRequestType;
  fMadeRequest := False;
End;

{-----------------------------------------------------------------------------
  Procedure: RequestChange
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.RequestChange(aType: TTHreadType);
Begin
  fMadeRequest := True;
  fRequestType := aType;
End;

{-----------------------------------------------------------------------------
  Procedure: SetThreadType
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRThread.SetThreadType(aType: TThreadType);
Begin
  If Not fWorking Then //verify that thread isn't working and prevent
    fThreadType := atype //a button hook on it when it isn't looking
  Else
    RequestChange(aType);
End;


end.
