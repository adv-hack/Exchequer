{-----------------------------------------------------------------------------
 Unit Name: uDSRLock
 Author:    vmoura
 Purpose:
 History:

 this is a copy paste of the TMultiReadExclusiveWriteSynchronizer update patch of
 the sysutils from borland

http://codecentral.borland.com/Item.aspx?id=17761

Title:  	 TMultiReadExclusiveWriteSynchronizer deadlock fix-SysUtils.pas
Summary: 	This updated SysUtils.pas file fixes a deadlock issue that can occur in the TMultiReadExclusiveWriteSynchronizer. The problem
tends to show up when a lot of threads are using the same TMREWS object at the same time.

-----------------------------------------------------------------------------}
Unit uDSRLock;

Interface

Uses Windows, sysutils, SyncObjs;

Type
  PThreadInfo2 = ^TThreadInfo2;
  TThreadInfo2 = Record
    Next: PThreadInfo2;
    ThreadID: Cardinal;
    Active: Integer;
    RecursionCount: Cardinal;
  End;

  TThreadLocalCounter2 = Class
  Private
    FHashTable: Array[0..15] Of PThreadInfo2;
    Function HashIndex: Byte;
    Function Recycle: PThreadInfo2;
  Public
    Destructor Destroy; Override;
    Procedure Open(Var Thread: PThreadInfo2);
    Procedure Delete(Var Thread: PThreadInfo2);
    Procedure Close(Var Thread: PThreadInfo2);
  End;

Const
  Alive = High(Integer);

Const
  mrWriteRequest = $FFFF; // 65535 concurrent read requests (threads)
                          // 32768 concurrent write requests (threads)
                          // only one write lock at a time
                          // 2^32 lock recursions per thread (read and write combined)

Type
  IReadWriteSync = Interface
    Procedure BeginRead;
    Procedure EndRead;
    Function BeginWrite: Boolean;
    Procedure EndWrite;
  End;

  TDSRSynchronizer = Class(TCriticalSection)
  public
    constructor Create;
    destructor Destroy; override;
    Procedure BeginRead;
    Procedure EndRead;
    Function BeginWrite: Boolean;
    Procedure EndWrite;
  published
  
  end;

  // TDSRSynchronizer = TMultiReadExclusiveWriteSynchronizer
  TDSRSynchronizer_ = Class(TInterfacedObject, IReadWriteSync)
  Private
    FSentinel: Integer;
    FReadSignal: THandle;
    FWriteSignal: THandle;
    FWaitRecycle: Cardinal;
    FWriteRecursionCount: Cardinal;
    tls: TThreadLocalCounter; // !! ThreadLocalCounter2 patch
    FWriterID: Cardinal;
    FRevisionLevel: Cardinal;
    Procedure BlockReaders;
    Procedure UnblockReaders;
    Procedure UnblockOneWriter;
    Procedure WaitForReadSignal;
    Procedure WaitForWriteSignal;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure BeginRead;
    Procedure EndRead;
    Function BeginWrite: Boolean;
    Procedure EndWrite;
    Property RevisionLevel: Cardinal Read FRevisionLevel;
  End;

Implementation

Destructor TThreadLocalCounter2.Destroy;
Var
  P, Q: PThreadInfo2;
  I: Integer;
Begin
  //for I := 0 to High(FHashTable) do
  For I := High(FHashTable) Downto 0 Do
  Try
    P := FHashTable[I];
    FHashTable[I] := Nil;
    While P <> Nil Do
    Begin
      Q := P;
      P := P^.Next;
      FreeMem(Q);
    End;
  Except
  End;

  Inherited Destroy;
End;

Function TThreadLocalCounter2.HashIndex: Byte;
Var
  H: Word;
Begin
  H := Word(GetCurrentThreadID);
  Result := (WordRec(H).Lo Xor WordRec(H).Hi) And 15;
End;

Procedure TThreadLocalCounter2.Open(Var Thread: PThreadInfo2);
Var
  P: PThreadInfo2;
  CurThread: Cardinal;
  H: Byte;
Begin
  H := HashIndex;
  CurThread := GetCurrentThreadID;

  P := FHashTable[H];
  While (P <> Nil) And (P.ThreadID <> CurThread) Do
    P := P.Next;

  If P = Nil Then
  Begin
    P := Recycle;

    If P = Nil Then
    Begin
      P := PThreadInfo2(AllocMem(sizeof(TThreadInfo2)));
      P.ThreadID := CurThread;
      P.Active := Alive;

      // Another thread could start traversing the list between when we set the
      // head to P and when we assign to P.Next.  Initializing P.Next to point
      // to itself will make others spin until we assign the tail to P.Next.
      P.Next := P;
      P.Next := PThreadInfo2(InterlockedExchange(Integer(FHashTable[H]),
        Integer(P)));
    End;
  End;
  Thread := P;
End;

Procedure TThreadLocalCounter2.Close(Var Thread: PThreadInfo2);
Begin
  Thread := Nil;
End;

Procedure TThreadLocalCounter2.Delete(Var Thread: PThreadInfo2);
Begin
  Thread.ThreadID := 0;
  Thread.Active := 0;
End;

Function TThreadLocalCounter2.Recycle: PThreadInfo2;
Var
  Gen: Integer;
Begin
  Result := FHashTable[HashIndex];
  While (Result <> Nil) Do
  Begin
    Gen := InterlockedExchange(Result.Active, Alive);
    If Gen <> Alive Then
    Begin
      Result.ThreadID := GetCurrentThreadID;
      Exit;
    End
    Else
      Result := Result.Next;
  End;
End;

Constructor TDSRSynchronizer_.Create;
Begin
  Inherited Create;
  FSentinel := mrWriteRequest;
  FReadSignal := CreateEvent(Nil, True, True, Nil);
    // manual reset, start signaled
  FWriteSignal := CreateEvent(Nil, False, False, Nil);
    // auto reset, start blocked
  FWaitRecycle := INFINITE;
  tls := TThreadLocalCounter(Pointer(TThreadLocalCounter2.Create));

End;

Destructor TDSRSynchronizer_.Destroy;
Begin
(*
  BeginWrite;
  inherited Destroy;
  CloseHandle(FReadSignal);
  CloseHandle(FWriteSignal);
  tls.Free;
  *)

  CloseHandle(FReadSignal);
  CloseHandle(FWriteSignal);
  tls.Free;
  Inherited Destroy;
End;

Procedure TDSRSynchronizer_.BlockReaders;
Begin
  ResetEvent(FReadSignal);
End;

Procedure TDSRSynchronizer_.UnblockReaders;
Begin
  SetEvent(FReadSignal);
End;

Procedure TDSRSynchronizer_.UnblockOneWriter;
Begin
  SetEvent(FWriteSignal);
End;

Procedure TDSRSynchronizer_.WaitForReadSignal;
Begin
  WaitForSingleObject(FReadSignal, FWaitRecycle);
End;

Procedure TDSRSynchronizer_.WaitForWriteSignal;
Begin
  WaitForSingleObject(FWriteSignal, FWaitRecycle);
End;

Function TDSRSynchronizer_.BeginWrite: Boolean;
Var
  Thread: PThreadInfo2;
  HasReadLock: Boolean;
  ThreadID: Cardinal;
  Test: Integer;
  OldRevisionLevel: Cardinal;
Begin
  {
    States of FSentinel (roughly - during inc/dec's, the states may not be exactly what is said here):
    mrWriteRequest:         A reader or a writer can get the lock
    1 - (mrWriteRequest-1): A reader (possibly more than one) has the lock
    0:                      A writer (possibly) just got the lock, if returned from the main write While loop
    < 0, but not a multiple of mrWriteRequest: Writer(s) want the lock, but reader(s) have it.
          New readers should be blocked, but current readers should be able to call BeginRead
    < 0, but a multiple of mrWriteRequest: Writer(s) waiting for a writer to finish
  }

  Result := True;
  ThreadID := GetCurrentThreadID;
  If FWriterID <> ThreadID Then // somebody or nobody has a write lock
  Begin
    // Prevent new readers from entering while we wait for the existing readers
    // to exit.
    BlockReaders;

    OldRevisionLevel := FRevisionLevel;

    TThreadLocalCounter2(tls).Open(Thread);
    // We have another lock already. It must be a read lock, because if it
    // were a write lock, FWriterID would be our threadid.
    HasReadLock := Thread.RecursionCount > 0;

    If HasReadLock Then // acquiring a write lock requires releasing read locks
      InterlockedIncrement(FSentinel);

    // InterlockedExchangeAdd returns prev value
    While InterlockedExchangeAdd(FSentinel, -mrWriteRequest) <> mrWriteRequest
      Do
    Begin
      // Undo what we did, since we didn't get the lock
      Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest);
      // If the old value (in Test) was 0, then we may be able to
      // get the lock (because it will now be mrWriteRequest). So,
      // we continue the loop to find out. Otherwise, we go to sleep,
      // waiting for a reader or writer to signal us.

      If Test <> 0 Then
      Begin
        WaitForWriteSignal;
      End
    End;

    // At the EndWrite, first Writers are awoken, and then Readers are awoken.
    // If a Writer got the lock, we don't want the readers to do busy
    // waiting. This Block resets the event in case the situation happened.
    BlockReaders;

    // Put our read lock marker back before we lose track of it
    If HasReadLock Then
      InterlockedDecrement(FSentinel);

    FWriterID := ThreadID;

    Result := Integer(OldRevisionLevel) =
      (InterlockedIncrement(Integer(FRevisionLevel)) - 1);
  End;

  Inc(FWriteRecursionCount);
End;

Procedure TDSRSynchronizer_.EndWrite;
Var
  Thread: PThreadInfo2;
Begin
  assert(FWriterID = GetCurrentThreadID);

  TThreadLocalCounter2(tls).Open(Thread);
  Dec(FWriteRecursionCount);
  If FWriteRecursionCount = 0 Then
  Begin
    FWriterID := 0;
    InterlockedExchangeAdd(FSentinel, mrWriteRequest);
    UnblockOneWriter;
    UnblockReaders;
  End;
  If Thread.RecursionCount = 0 Then
    TThreadLocalCounter2(tls).Delete(Thread);
End;

Procedure TDSRSynchronizer_.BeginRead;
Var
  Thread: PThreadInfo2;
  WasRecursive: Boolean;
  SentValue: Integer;
Begin
  TThreadLocalCounter2(tls).Open(Thread);
  Inc(Thread.RecursionCount);
  WasRecursive := Thread.RecursionCount > 1;

  If FWriterID <> GetCurrentThreadID Then
  Begin
    // In order to prevent recursive Reads from causing deadlock,
    // we need to always WaitForReadSignal if not recursive.
    // This prevents unnecessarily decrementing the FSentinel, and
    // then immediately incrementing it again.
    If Not WasRecursive Then
    Begin
      // Make sure we don't starve writers. A writer will
      // always set the read signal when it is done, and it is initially on.
      WaitForReadSignal;
      While (InterlockedDecrement(FSentinel) <= 0) Do
      Begin
        // Because the InterlockedDecrement happened, it is possible that
        // other threads "think" we have the read lock,
        // even though we really don't. If we are the last reader to do this,
        // then SentValue will become mrWriteRequest
        SentValue := InterlockedIncrement(FSentinel);
        // So, if we did inc it to mrWriteRequest at this point,
        // we need to signal the writer.
        If SentValue = mrWriteRequest Then
          UnblockOneWriter;

        // This sleep below prevents starvation of writers
        Sleep(0);

        WaitForReadSignal;
      End;
    End;
  End;
(*
var
Thread: PThreadInfo2;
DidDec: Boolean;
begin
DidDec := False;
if FWriterID <> GetCurrentThreadID then
begin
while (InterlockedDecrement(FSentinel) <= 0) do
begin
InterlockedIncrement(FSentinel);
WaitForReadSignal;
end;
DidDec := True;
end;
//----added by ahmed ismail
UnblockReaders;
//----
TThreadLocalCounter2(tls).Open(Thread);
try
Inc(Thread.RecursionCount);
if (Thread.RecursionCount > 1) and DidDec then
InterlockedIncrement(FSentinel);
finally
TThreadLocalCounter2(tls).Close(Thread);
end;
end;

*)
End;

Procedure TDSRSynchronizer_.EndRead;
Var
  Thread: PThreadInfo2;
  Test: Integer;
Begin
  TThreadLocalCounter2(tls).Open(Thread);
  Dec(Thread.RecursionCount);
  If (Thread.RecursionCount = 0) Then
  Begin
    TThreadLocalCounter2(tls).Delete(Thread);

    // original code below commented out
    If (FWriterID <> GetCurrentThreadID) Then
    Begin
      Test := InterlockedIncrement(FSentinel);
      // It is possible for Test to be mrWriteRequest
      // or, it can be = 0, if the write loops:
      // Test := InterlockedExchangeAdd(FSentinel, mrWriteRequest) + mrWriteRequest;
      // Did not get executed before this has called (the sleep debug makes it happen faster)
      If Test = mrWriteRequest Then
        UnblockOneWriter
      Else If Test <= 0 Then // We may have some writers waiting
      Begin
        If (Test Mod mrWriteRequest) = 0 Then
          UnblockOneWriter; // No more readers left (only writers) so signal one of them
      End;
    End;
  End;
End;

{ TDSRSynchronizer2 }

procedure TDSRSynchronizer.BeginRead;
begin
  Self.Enter;
end;

function TDSRSynchronizer.BeginWrite: Boolean;
begin
  Self.Enter;
  Result := True;
end;

constructor TDSRSynchronizer.Create;
begin
  inherited Create;
end;

destructor TDSRSynchronizer.Destroy;
begin
  inherited Destroy;
end;

procedure TDSRSynchronizer.EndRead;
begin
  Self.Leave;
end;

procedure TDSRSynchronizer.EndWrite;
begin
  Self.Leave;
end;

End.

