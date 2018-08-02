unit UtilFuncs;

interface

Function CreateMemoryMap : LongInt; StdCall; Export;
Function DestroyMemoryMap : LongInt; StdCall; Export;
Function ClearMemoryMap : LongInt; StdCall; Export;
Function AddCompanyUser (Const CompanyCode, UserId, Password : PANSIChar) : LongInt; StdCall; Export;
Function LastErrorString : PANSIChar; StdCall; Export;

implementation

Uses SysUtils, MemoryMap;

Var
  sLastError : ShortString;

//=========================================================================

// This function creates an empty memory map.
//
// The following return values are expected:-
//   0    Success.
//   1    Unknown Exception - call LastErrorString for details.
//
Function CreateMemoryMap : LongInt;
Begin // CreateMemoryMap
  Try
    // Master Application - Create and initialise the map
    GlobalOLEMemoryMap := TOLEServerMemoryMap.Create(True);

    Result := 0;
    sLastError := '';
  Except
    On E:Exception Do
    Begin
      sLastError := E.Message;
      Result := 1;
    End; // On E:Exception
  End; // Try..ExceptTry
End; // CreateMemoryMap

//-------------------------------------------------------------------------

// This function destroys the memory map.
//
// The following return values are expected:-
//
//   0   Success.
//   1   Unknown Exception - call LastErrorString for details.
//
Function DestroyMemoryMap : LongInt;
Begin // DestroyMemoryMap
  Try
    If Assigned(GlobalOLEMemoryMap) Then
      FreeAndNil(GlobalOLEMemoryMap);

    Result := 0;
    sLastError := '';
  Except
    On E:Exception Do
    Begin
      sLastError := E.Message;
      Result := 1;
    End; // On E:Exception
  End; // Try..ExceptTry
End; // DestroyMemoryMap

//-------------------------------------------------------------------------

// This function can be used with an existing memory map to clear down any details previously
// specified, this can be used when changing to a different spreadsheet requiring different
// login details.
//
// The following return values are expected:-
//
//   0   Success.
//   1   Unknown Exception - call LastErrorString for details.
//   2   Memory Map not created.
//
Function ClearMemoryMap : LongInt;
Begin // ClearMemoryMap
  Try
    If Assigned(GlobalOLEMemoryMap) Then
    Begin
      GlobalOLEMemoryMap.Clear;

      Result := 0;
      sLastError := '';
    End // If Assigned(GlobalOLEMemoryMap)
    Else
    Begin
      sLastError := 'Memory Map not created';
      Result := 2;
    End; // Else
  Except
    On E:Exception Do
    Begin
      sLastError := E.Message;
      Result := 1;
    End; // On E:Exception
  End; // Try..ExceptTry
End; // ClearMemoryMap

//-------------------------------------------------------------------------

// This function adds the specified Company Code, User Id and Password into the Memory Map for
// use by the IRIS Exchequer OLE Server.  No validation on the details will be or can be provided
// other than to check for blank or too long Company Codes or User Id's.
//
// The details will be encrypted before they are added into the memory map to prevent it being
// a security loophole.
//
// A maximum of 1,000 sets of details will be supported.
//
// The following return values are expected:-
//
//   0   Success
//   1   Unknown Exception - call LastErrorString for details
//   2   Memory Map not created
//   3   Out of space - the memory map is full
//   4   Invalid Company Code
//   5   Invalid User Id
//   6   Invalid Password
//
// Note: Calling app is responsible for allocating and de-allocating the PCHAR parameters.
//
// Note: Using PANSIChar as PCHAR changes in Delphi 2009 to point to Unicode characters.
//
Function AddCompanyUser (Const CompanyCode, UserId, Password : PANSIChar) : LongInt;
Var
  sCompanyCode, sUserId, sPassword : String;
Begin // AddCompanyUser
  Try
    If Assigned(GlobalOLEMemoryMap) Then
    Begin
      sCompanyCode := CompanyCode;
      sUserId := UserId;
      sPassword := Password;
      Result := GlobalOLEMemoryMap.AddCompany (sCompanyCode, sUserId, sPassword);
      Case Result Of
        0 : sLastError := '';
        2 : sLastError := 'Memory Map not created';
        3 : sLastError := 'Out of space - the memory map is full';
        4 : sLastError := 'Invalid Company Code';
        5 : sLastError := 'Invalid User Id';
        6 : sLastError := 'Invalid Password';
      End; // Case Result
    End // If Assigned(GlobalOLEMemoryMap)
    Else
    Begin
      sLastError := 'Memory Map not created';
      Result := 2;
    End; // Else
  Except
    On E:Exception Do
    Begin
      sLastError := E.Message;
      Result := 1;
    End; // On E:Exception
  End; // Try..ExceptTry
End; // AddCompanyUser

//-------------------------------------------------------------------------

// This function will return an error string for the last function call result, the calling
// routine is responsible for de-allocating the returned PChar.
//
// Note: Using PANSIChar as PCHAR changes in Delphi 2009 to point to Unicode characters.
//
Function LastErrorString : PANSIChar;
Begin // LastErrorString
  Result := StrAlloc(255);
  Result := StrPCopy(Result, sLastError);
End; // LastErrorString

//=========================================================================

Initialization
  sLastError := '';
end.
