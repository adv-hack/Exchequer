library DummyDLL;

{$R *.RES}

//
//  Dummy DLL used by Setup for data storage, functions below
//  are dummies to make the DLL seem more real!
//

//-----------------------

Procedure CheckSys32;
Begin
End;

Function WinUserName32 : PChar;
Begin
  Result := NIL;
End;

Function WinComputerName32 : PChar;
Begin
  Result := NIL;
End;

Function ProcessorType : Pointer;
Begin
  Result := NIL;
End;

Function GetWindowsVersion : LongInt;
Begin
  Result := 0;
End;

Function GetWindowsBuildNo : LongInt;
Begin
  Result := 0;
End;

//-----------------------

Function GetTheme : Pointer;
Begin
  Result := NIL;
End;

Function GetThemeName : PChar;
Begin
  Result := NIL;
End;

Function GetThemeStat (Const StatId : LongInt) : LongInt;
Begin
  Result := 0;
End;

//-----------------------

Function AllocMem32 (Const MemSize : LongInt) : Pointer;
Begin
  Result := NIL;
End;

Procedure DeAllocMem32 (Const Mem : Pointer);
Begin
End;

Procedure ShrinkResources;
Begin
End;

//-----------------------

Exports
  CheckSys32,
  WinUserName32,
  WinComputerName32,
  ProcessorType,
  GetWindowsVersion,
  GetWindowsBuildNo,

  AllocMem32,
  DeAllocMem32,
  ShrinkResources,

  GetTheme,
  GetThemeStat,
  GetThemeName;
end.
