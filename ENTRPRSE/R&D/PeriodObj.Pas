Unit PeriodObj;

Interface

Uses
  Classes,
  SyncObjs,
  SysUtils,
  Windows;

{$IFNDEF PERIODFIX}
  Compiler Stop Here - This unit should not be in the buld
{$ENDIF}

Type
  TUserPeriodCache = Class(TObject)
  Private
    FPeriod : Byte;
    FYear : Byte;
    FDisplayAsMonths : Boolean;
  Public
    Property Period : Byte Read FPeriod;
    Property Year : Byte Read FYear;
    Property DisplayAsMonths : Boolean Read FDisplayAsMonths;

    Constructor Create (Const Period, Year : Byte; Const DispAsMonths : Boolean);
  End; // TUserPeriodCache

  //------------------------------

  TUserPeriodInfo = Class(TObject)
  Private
    FMainThreadId : DWord;
    FLogCount : Byte;

    FPeriod : Byte;
    FYear : Byte;
    FDisplayAsMonths : Boolean;

    Procedure StartCriticalSection(Const FunctionName : ShortString);
    Procedure FinishCriticalSection;

    Function GetPeriod : Byte;
    Procedure SetPeriod (Value : Byte);

    Function GetYear : Byte;
    Procedure SetYear (Value : Byte);

    Function GetDisplayAsMonths : Boolean;
    Procedure SetDisplayAsMonths (Value : Boolean);
  Public
    Property Period : Byte Read GetPeriod Write SetPeriod;
    Property Year : Byte Read GetYear Write SetYear;
    Property DisplayAsMonths : Boolean Read GetDisplayAsMonths Write SetDisplayAsMonths;

    Constructor Create;
    Destructor Destroy; Override;

    Procedure SetPeriodYear (Const NewPeriod, NewYear : Byte);

    Function GetCache : TUserPeriodCache;
    Procedure RestoreCache (Var GetCache : TUserPeriodCache);
  End; // TUserPeriodInfo

Var
  PeriodCriticalSection : TCriticalSection;

Implementation

Uses StrUtils,
     LogUtil,
     APIUtil;



//=========================================================================

Constructor TUserPeriodCache.Create (Const Period, Year : Byte; Const DispAsMonths : Boolean);
Begin // Create
  Inherited Create;

  FPeriod := Period;;
  FYear := Year;
  FDisplayAsMonths := DispAsMonths;
End; // Create

//=========================================================================

Constructor TUserPeriodInfo.Create;
Begin // Create
  Inherited Create;

  FMainThreadId := GetCurrentThreadId;
  FLogCount := 0;

  StartCriticalSection('TUserPeriodInfo.Create');
  Try
    FPeriod := 0;
    FYear := 0;
    FDisplayAsMonths := False;
  Finally
    FinishCriticalSection;
  End;
End; // Create

//------------------------------

Destructor TUserPeriodInfo.Destroy;
Begin // Destroy
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TUserPeriodInfo.StartCriticalSection(Const FunctionName : ShortString);
Var
  oLogFile : TLogFile;
  sException : ShortString;
  DoError : Boolean;
Begin // StartCriticalSection
  DoError := False;
  sException := '';
  If Assigned(PeriodCriticalSection) Then
  Begin
    Try
      PeriodCriticalSection.Enter;
    Except
      On E:Exception Do
      Begin
        sException := E.Message;
        PeriodCriticalSection := NIL;
        DoError := True;
      End;
    End; // Try..Except
  End // If Assigned(PeriodCriticalSection)
  Else
    DoError := True;

  If DoError And (FLogCount < 10) Then
  Begin
    oLogFile := TLogFile.Create('Period Object');
    Try
      If (sException <> '') Then
        oLogFile.Add(FunctionName + ' - Exception ' + sException + ' Entering Critical Section')
      Else
        oLogFile.Add(FunctionName + ' - Critical Section Not Assigned (' + IfThen(GetCurrentThreadId = FMainThreadId, 'Main', 'Sub') + ' Thread)');
      oLogFile.Add('');
      oLogFile.Add('Running in non-thread-safe mode');
      oLogFile.SaveLog;
      RunFile(oLogFile.SavedName);

      Inc(FLogcount);
    Finally
      oLogFile.Free;
    End; // Try..Finally
  End; // If DoError And (FLogCount < 20)
End; // StartCriticalSection

//------------------------------

Procedure TUserPeriodInfo.FinishCriticalSection;
Begin // FinishCriticalSection
  If Assigned(PeriodCriticalSection) Then
    PeriodCriticalSection.Leave;
End; // FinishCriticalSection

//-------------------------------------------------------------------------

Procedure TUserPeriodInfo.SetPeriodYear (Const NewPeriod, NewYear : Byte);
Begin // SetPeriodYear
  StartCriticalSection('TUserPeriodInfo.SetPeriodYear');
  Try
    FPeriod := NewPeriod;
    FYear := NewYear;
  Finally
    FinishCriticalSection;
  End;
End; // SetPeriodYear

//-------------------------------------------------------------------------

Function TUserPeriodInfo.GetCache : TUserPeriodCache;
Begin // GetCache
  StartCriticalSection('TUserPeriodInfo.GetCache');
  Try
    Result := TUserPeriodCache.Create (FPeriod, FYear, FDisplayAsMonths);
  Finally
    FinishCriticalSection;
  End;
End; // GetCache

//------------------------------

Procedure TUserPeriodInfo.RestoreCache (Var GetCache : TUserPeriodCache);
Begin // RestoreCache
  StartCriticalSection('TUserPeriodInfo.RestoreCache');
  Try
    FPeriod := GetCache.Period;
    FYear := GetCache.Year;
    FDisplayAsMonths := GetCache.DisplayAsMonths;
  Finally
    FinishCriticalSection;
  End;

  GetCache.Free;
  GetCache := NIL;
End; // RestoreCache

//-------------------------------------------------------------------------

Function TUserPeriodInfo.GetPeriod : Byte;
Begin // GetPeriod
  StartCriticalSection('TUserPeriodInfo.GetPeriod');
  Try
    Result := FPeriod;
  Finally
    FinishCriticalSection;
  End;
End; // GetPeriod
Procedure TUserPeriodInfo.SetPeriod (Value : Byte);
Begin // SetPeriod
  StartCriticalSection('TUserPeriodInfo.SetPeriod');
  Try
    {$IFDEF PERIODDEBUG}
    If (Value = 0) Or (Value > Syss.PrinYr) Then
      If (MessageDlg ('Unexpected Period Value - ' + IntToStr(Value) + #13#13 + 'Crash?', mtConfirmation, [mbYes, mbNo], 0) = Controls.mrYes) Then
        Raise Exception.Create ('Unexpected Period Value - ' + IntToStr(Value));
    {$ENDIF}

    FPeriod := Value;
  Finally
    FinishCriticalSection;
  End;
End; // SetPeriod

//------------------------------

Function TUserPeriodInfo.GetYear : Byte;
Begin // GetYear
  StartCriticalSection('TUserPeriodInfo.GetYear');
  Try
    Result := FYear;
  Finally
    FinishCriticalSection;
  End;
End; // GetYear
Procedure TUserPeriodInfo.SetYear (Value : Byte);
Begin // SetYear
  StartCriticalSection('TUserPeriodInfo.SetYear');
  Try
    {$IFDEF PERIODDEBUG}
    If (Value <= 105) Then
      If (MessageDlg ('Unexpected Year Value - ' + IntToStr(Value) + #13#13 + 'Crash?', mtConfirmation, [mbYes, mbNo], 0) = Controls.mrYes) Then
        Raise Exception.Create ('Unexpected Year Value - ' + IntToStr(Value));
    {$ENDIF}

    FYear := Value;
  Finally
    FinishCriticalSection;
  End;
End; // SetYear

//------------------------------

Function TUserPeriodInfo.GetDisplayAsMonths : Boolean;
Begin // GetDisplayAsMonths
  StartCriticalSection('TUserPeriodInfo.GetDisplayAsMonths');
  Try
    Result := FDisplayAsMonths;
  Finally
    FinishCriticalSection;
  End;
End; // GetDisplayAsMonths
Procedure TUserPeriodInfo.SetDisplayAsMonths (Value : Boolean);
Begin // SetDisplayAsMonths
  StartCriticalSection('TUserPeriodInfo.SetDisplayAsMonths');
  Try
    {$IFDEF PERIODDEBUG}
    If (Ord(Value) <> 0) Then
      If (MessageDlg ('Unexpected Period Format Value - ' + IntToStr(Ord(Value)) + #13#13 + 'Crash?', mtConfirmation, [mbYes, mbNo], 0) = Controls.mrYes) Then
        Raise Exception.Create ('Unexpected Period Format Value - ' + IntToStr(Ord(Value)));
    {$ENDIF}

    FDisplayAsMonths := Value;
  Finally
    FinishCriticalSection;
  End;
End; // SetDisplayAsMonths

//=========================================================================


Initialization
  PeriodCriticalSection := TCriticalSection.Create;
Finalization
  FreeAndNIL(PeriodCriticalSection);
End.
