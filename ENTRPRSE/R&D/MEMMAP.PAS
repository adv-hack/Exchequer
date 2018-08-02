unit MemMap;
{$WARN SYMBOL_DEPRECATED OFF}
interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  pGlobalEnterpriseData = ^TGlobalEnterpriseData;

  TMMCurrencyVerType = (ccyProf, ccyEuro, ccyGlobal);

  TGlobalEnterpriseData = Record
    gedDefined      : Boolean;

    // Enterprise Version
    gedEntVer       : String[30];

    // Memory Map Version - '4.31.xxx'
    gedMapVer       : String[30];

    // Path of parent .EXE
    gedAppPath      : ShortString;

    // Path of Company Data
    gedDataPath     : ShortString;

    // Current Logged-In User ID
    gedUserName     : String[30];

    // Currency Version
    gedCurrencyVer  : TMMCurrencyVerType;

    // For future expandibility
    gedSpare        : Array [1..45473] Of Byte;
  End; { GlobalEnterpriseData }

  TMemoryMap = Class(TObject)
  Private
    FGlobalData : pGlobalEnterpriseData;
    FMapHandle  : THandle;
  Protected
    Function GetApplicationPath : String;
    Function GetCompanyDataPath : String;
    Procedure SetCompanyDataPath (Value : String);
    Function GetCurrencyVer : TMMCurrencyVerType;
    Function GetDefined : Boolean;
    Function GetEnterpriseVersion : String;
    Function GetMapVersion : String;
    Function GetUserName : String;
    Procedure SetUserName(Value : String);

    Procedure InitMemMap(Const InitSettings : Boolean);
  Public
    Constructor Create (Const InitGlobalData : Boolean);
    Destructor Destroy; OverRide;
  Published
    Property ApplicationPath : String Read GetApplicationPath;
    Property CompanyDataPath : String Read GetCompanyDataPath Write SetCompanyDataPath;
    Property CurrencyVersion : TMMCurrencyVerType Read GetCurrencyVer;
    Property Defined : Boolean Read GetDefined;
    Property EnterpriseVersion : String Read GetEnterpriseVersion;
    Property MapVersion : String Read GetMapVersion;
    Property UserName : String Read GetUserName Write SetUserName;
  End; { TMemoryMap }


{$IFDEF EXDLL}
  // Toolkit DLL
  Function EX_GETENTDATA(P : Pointer; PSize : LongInt) : SmallInt;
           {$IFDEF WIN32} STDCALL {$ENDIF} EXPORT;
{$ENDIF}

Var
  GlobalEntMap : TMemoryMap;

Implementation

{$IFDEF MEMMAP}
Uses GlobVar, VarConst, APIUtil;
{$ELSE}
  {$IFDEF EXDLL}
    Uses GlobVar, VarCnst3, DLLErrU, APIUtil;
  {$ENDIF}
{$ENDIF}

{------------------------------------------------------------------------}

{$IFDEF EXDLL}
  // Toolkit DLL Function
  Function EX_GETENTDATA(P : Pointer; PSize : LongInt) : SmallInt;
  Var
    EntInfo : ^TEnterpriseInfoType;
  Begin { Ex_GetEntData }
    Result := 32767;  // Record not initialised correctly
    LastErDesc := '';

    If Assigned(P) And (PSize = Sizeof(TEnterpriseInfoType)) Then Begin
      If Assigned(GlobalEntMap) Then Begin
        EntInfo := P;

        FillChar (EntInfo^, SizeOf (EntInfo^), #0);
        With EntInfo^, GlobalEntMap Do Begin
          // Copy details from GlobalEntMap into record
          eiDefined        := BoolToWordBool(Defined);
          eiEntVersion     := EnterpriseVersion;
          eiEntPath        := ApplicationPath;
          eiDataPath       := CompanyDataPath;
          eiUserName       := UserName;
          Case CurrencyVersion Of
            ccyProf   : eiCurrencyVer := 'P';
            ccyEuro   : eiCurrencyVer := 'E';
            ccyGlobal : eiCurrencyVer := 'G';
          End; { Case CurrencyVersion }
        End; { With EntInfo^ }

        Result := 0;
      End { If Assigned(GlobalEntMap) }
      Else
        // Map not available
        Result := 32765;
    End { If Assigned(P) And (PSize = Sizeof(TBatchTHRec)) }
    Else
      If Assigned(P) Then
        // Incorrect record size
        Result:=32766;

    If (Result <> 0) Then
      LastErDesc:=Ex_ErrorDescription(148, Result);
  End; { Ex_GetEntData }
{$ENDIF}

{------------------------------------------------------------------------}

Constructor TMemoryMap.Create (Const InitGlobalData : Boolean);
//const
//  cMMFileName : PChar = 'KILO877';
Var
  Size        : Integer;
  cMMFileName : ANSIString;
Begin { Create }
  Inherited Create;

  cMMFileName := 'KILO877' + WinGetUserName;

  { Get the size of the data to be mapped. }
  Size := SizeOf(TGlobalEnterpriseData);

  { Now get a memory-mapped file object. Note the first parameter passes
    the value $FFFFFFFF or DWord(-1) so that space is allocated from the system's
    paging file. This requires that a name for the memory-mapped
    object get passed as the last parameter. }

  FMapHandle := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, Size, PCHAR(cMMFileName));

  If (FMapHandle <> 0) Then Begin
    { Now map the data to the calling process's address space and get a
      pointer to the beginning of this address }
    FGlobalData := MapViewOfFile(FMapHandle, FILE_MAP_ALL_ACCESS, 0, 0, Size);

    If (Not Assigned(FGlobalData)) Then Begin
      // Error
      CloseHandle(FMapHandle);
      RaiseLastWin32Error;
    End { If (Not Assigned(FGlobalData)) }
    Else
      // OK
      If InitGlobalData Then InitMemMap(True);
  End { If (FMapHandle <> 0) }
  Else
    { CreateFileMapping generated an error }
    RaiseLastWin32Error;
End; { Create }

{---------------------------------}

Destructor TMemoryMap.Destroy;
Begin { Destroy }
  // Remove settings
  InitMemMap(False);

  UnmapViewOfFile(FGlobalData);
  CloseHandle(FMapHandle);

  Inherited Destroy;
End; { Destroy }

{---------------------------------}

Procedure TMemoryMap.InitMemMap(Const InitSettings : Boolean);
Begin { InitMemMap }
{$IFDEF MEMMAP}
  FillChar (FGlobalData^, SizeOf(FGlobalData^), #0);
  If InitSettings Then
    With FGlobalData^ Do Begin
      gedDefined := True;

      // Enterprise Version
      gedEntVer := Ver;

      // Memory Map Version - '4.31.xxx'
      gedMapVer := '4.31.001';

      // Path of parent .EXE - Usually Enter1.Exe
      gedAppPath := Application.ExeName;

      // Path of Company Data
      gedDataPath := SetDrive;

      // Current Logged-In User ID
      // Set after Login in EParentU.Pas - StartLogIn

      // Currency Version - P=Single/Professional, E=Euro, G=Multi-Currency/Global
      {$IFDEF MC_ON}
        If EuroVers then
          gedCurrencyVer := ccyEuro
        Else
          gedCurrencyVer := ccyGlobal;
      {$ELSE}
        gedCurrencyVer := ccyProf;
      {$ENDIF}
    End; { With FGlobalData^ }
{$ENDIF}
End; { InitMemMap }

{---------------------------------}

Function TMemoryMap.GetApplicationPath : String;
begin
  Result := FGlobalData^.gedAppPath;
end;

{---------------------------------}

Function TMemoryMap.GetCompanyDataPath : String;
begin
  Result := FGlobalData^.gedDataPath;
end;

Procedure TMemoryMap.SetCompanyDataPath (Value : String);
begin
  FGlobalData^.gedDataPath := Value;
end;

{---------------------------------}

Function TMemoryMap.GetCurrencyVer : TMMCurrencyVerType;
begin
  Result := FGlobalData^.gedCurrencyVer;
end;

{---------------------------------}

Function TMemoryMap.GetDefined : Boolean;
begin
  Result := FGlobalData^.gedDefined;
end;

{---------------------------------}

function TMemoryMap.GetEnterpriseVersion: String;
begin
  Result := FGlobalData^.gedEntVer;
end;

{---------------------------------}

function TMemoryMap.GetUserName: String;
begin
  Result := FGlobalData^.gedUserName;
end;

procedure TMemoryMap.SetUserName(Value: String);
begin
  FGlobalData^.gedUserName := Value;
end;

{---------------------------------}

Function TMemoryMap.GetMapVersion : String;
begin
  Result := FGlobalData^.gedMapVer;
end;

{---------------------------------}





Initialization
  GlobalEntMap := NIL;

  // Ensure the size never changes - 45k
  If (SizeOf(TGlobalEnterpriseData) <> 46080) Then
    ShowMessage ('MemMap.Pas - Incorrect TGlobalEnterpriseData Size (' + IntToStr(SizeOf(TGlobalEnterpriseData)) + ')');

  {$IFDEF COMTK}
    // COM Toolkit
    GlobalEntMap := TMemoryMap.Create(False);
  {$ELSE}
    {$IFDEF EXDLL}
      // Toolkit DLL
      GlobalEntMap := TMemoryMap.Create(False);
    {$ELSE}
      {$IFDEF EARNIEEXP}
        // Earnie Timesheet Export
        GlobalEntMap := TMemoryMap.Create(False);
      {$ELSE}
        // Enterprise
        GlobalEntMap := TMemoryMap.Create(True);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

Finalization
  FreeAndNil(GlobalEntMap);
end.
