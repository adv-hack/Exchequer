unit MemMap;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows{, VarConst};

Type
  pGlobalOLEServerData = ^TGlobalOLEServerData;

  //------------------------------

  TGlobalOLEServerCompanyData = Record
    gcdCompCode : string[6]; // String[CompCodeLen];
    gcdUserId   : String[12];
  End; { TGlobalOLEServerCompanyData }

  //------------------------------

  TGlobalOLEServerData = Record
    godDefined    : Boolean;
    godVersion    : Byte;

    // Number of elements in the godLogins array
    godLoginCount : SmallInt;

    // Array of successfull Company Login Data
    godLogins     : Array [1..50] Of TGlobalOLEServerCompanyData;

    // For future expandibility
    godSpare      : Array [1..45076] Of Byte;
  End; { TGlobalOLEServerData }

  //------------------------------

  TOLEMemoryMap = Class(TObject)
  Private
    FGlobalData : pGlobalOLEServerData;
    FMapHandle  : THandle;
  Protected
    Function ConvertCompCode (Const CompCode : ShortString) : ShortString;
    Function GetDefined : Boolean;
    Function GetLoginCount : SmallInt;
    function GetLogins(Index: SmallInt): TGlobalOLEServerCompanyData;
    Procedure InitMemMap(Const InitSettings : Boolean);
  Public
    Constructor Create (Const InitGlobalData : Boolean);
    Destructor Destroy; OverRide;
    Procedure AddLogin (CompCode, UserId : ShortString);

    Property Defined : Boolean Read GetDefined;
    Property LoginCount : SmallInt Read GetLoginCount;
    Property Logins [Index: SmallInt] : TGlobalOLEServerCompanyData Read GetLogins;

    Function IndexOf (CompCode : ShortString) : SmallInt;
  End; { TOLEMemoryMap }

  //------------------------------

Var
  GlobalOLEMap : TOLEMemoryMap;

Implementation

//Uses GlobVar, VarConst;

function WinGetUserName : Ansistring;
// Wraps the Windows API call : GetUserName
// Gets the name of the currently logged in user
var
  lpBuffer : Array [0..255] of Char;
  nSize : DWORD;
begin
  nSize := SizeOf(lpBuffer) - 1;
  if GetUserName(lpBuffer, nSize) then Result := lpBuffer
  else Result := 'User';
end;

function cMMFileName: pchar;
begin
  cMMFileName := PChar('KILO636'); // + WinGetUserName);
end;
{------------------------------------------------------------------------}

Constructor TOLEMemoryMap.Create (Const InitGlobalData : Boolean);
//const
//  cMMFileName : PChar = 'KILO636';
Var
  Size: Integer;
Begin { Create }
  Inherited Create;

  { Get the size of the data to be mapped. }
  Size := SizeOf(TGlobalOLEServerData);

  { Now get a memory-mapped file object. Note the first parameter passes
    the value $FFFFFFFF or DWord(-1) so that space is allocated from the system's
    paging file. This requires that a name for the memory-mapped
    object get passed as the last parameter. }

  FMapHandle := CreateFileMapping(DWord(-1), nil, PAGE_READWRITE, 0, Size, cMMFileName);

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

Destructor TOLEMemoryMap.Destroy;
Begin { Destroy }
  // Remove settings
  InitMemMap(False);

  UnmapViewOfFile(FGlobalData);
  CloseHandle(FMapHandle);

  Inherited Destroy;
End; { Destroy }

{---------------------------------}

Procedure TOLEMemoryMap.InitMemMap(Const InitSettings : Boolean);
Begin { InitMemMap }
  FillChar (FGlobalData^, SizeOf(FGlobalData^), #0);
  If InitSettings Then
    With FGlobalData^ Do Begin
      godDefined := True;
      godVersion := 1;
    End; { With FGlobalData^ }
End; { InitMemMap }

//-------------------------------------------------------------------------

Function TOLEMemoryMap.GetDefined : Boolean;
begin
  Result := FGlobalData^.godDefined;
end;

//------------------------------

Function TOLEMemoryMap.GetLoginCount : SmallInt;
Begin
  Result := FGlobalData^.godLoginCount;
End;

//------------------------------

function TOLEMemoryMap.GetLogins(Index: SmallInt): TGlobalOLEServerCompanyData;
begin
  With FGlobalData^ Do 
    If (Index >= Low(godLogins)) And (Index <= High(godLogins)) Then
      Result := godLogins[Index];
end;

//-------------------------------------------------------------------------

Function TOLEMemoryMap.ConvertCompCode (Const CompCode : ShortString) : ShortString;
Begin { ConvertCompCode }
  Result := UpperCase(Trim(CompCode));
End; { ConvertCompCode }

//-------------------------------------------------------------------------

Function TOLEMemoryMap.IndexOf (CompCode : ShortString) : SmallInt;
Var
  I       : SmallInt;
Begin { IndexOf }
  Result := 0;

  With FGlobalData^ Do
    // Check there are some entries to test
    If godDefined And (godLoginCount > 0) Then Begin
      // Convert the Company Code parameter to the common stored format
      CompCode := ConvertCompCode (CompCode);

      // Run through the array checking for it
      For I := Low(godLogins) To godLoginCount Do
        If (godLogins[I].gcdCompCode = CompCode) Then Begin
          // Match - Return Index and finish loop now
          Result := I;
          Break;
        End; { If (gcdCompCode = CompCode) }
    End; { If godDefined And (godLoginCount > 0) }
End; { IndexOf }

//-------------------------------------------------------------------------

Procedure TOLEMemoryMap.AddLogin (CompCode, UserId : ShortString);
Var
  WantAdd : Boolean;
  I       : SmallInt;
Begin { AddLogin }
  With FGlobalData^ Do
    // Check for space to add another login
    If godDefined And (godLoginCount < High(godLogins)) Then Begin
      CompCode := ConvertCompCode (CompCode);
      UserId := UpperCase(Trim(UserId));

      // first check to see if it already exists - highly unlikely but just in case
      If (IndexOf (CompCode) = 0) Then Begin
        // Setup the next free element in the array
        Inc (godLoginCount);
        With godLogins[godLoginCount] Do Begin
          gcdCompCode := CompCode;
          gcdUserId   := UserId;
        End; { With godLogins[godLoginCount] }
      End; { If WantAdd }
    End; { If godDefined And (godLoginCount < High(godLogins)) }
End; { AddLogin }

//-------------------------------------------------------------------------

Initialization
  GlobalOLEMap := NIL;

  // Ensure the size never changes - 45k
  If (SizeOf(TGlobalOLEServerData) <> 46080) Then
    ShowMessage ('MemMap.Pas - Incorrect TGlobalOLEServerData Size (' + IntToStr(SizeOf(TGlobalOLEServerData)) + ')');

  {$IF Defined(DRILL)}
    // Clients - Drill-Down Server
    GlobalOLEMap := TOLEMemoryMap.Create(False);
  {$ELSE}
    // OLE Server
    GlobalOLEMap := TOLEMemoryMap.Create(True);
  {$IFEND}
Finalization
  FreeAndNil(GlobalOLEMap);
end.
