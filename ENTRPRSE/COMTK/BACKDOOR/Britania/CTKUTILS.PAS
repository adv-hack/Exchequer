//=================================================================
//
// Exchequer Enterprise COM Toolkit Routines
// -----------------------------------------
//
// This module cannot be redistributed without written permission
// from Exchequer Software Ltd.
//
// Exchequer Software reserve the right to change the routines
// within the COM Toolkit used by this routine without notice.
//
// Copyright (c) 2002 Exchequer Software Ltd
//
//=================================================================
unit CTKUtils;

interface

// Calculate the daily backdoor passwords for the COM Toolkit
Function CalcCTKPword (Const AppPath : String; Var I1, I2, I3 : LongInt) : Boolean;

implementation

Uses SysUtils, Windows;

//----------------------------------------------------------------------------

Function CalcCTKPword (Const AppPath : String; Var I1, I2, I3 : LongInt) : Boolean;
Type
  TCalcPword = Procedure (Var I1, I2, I3 : LongInt); StdCall;
Var
  DLLPath    : PChar;
  hDLL       : THandle;
  hCalcPword : TCalcPword;
Begin { CalcCTKPword }
  Result := False;

  // Initialise parameters to default return value
  I1 := 0;
  I2 := 0;
  I3 := 0;

  DLLPath := StrAlloc (255);
  Try
    // Copy path of DLL into Pchar
    StrPCopy (DLLPath, IncludeTrailingBackslash(ExtractFilePath(AppPath)) + 'FAA32X.');

    // Check DLL exists
    If FileExists (DllPath) Then Begin
      // Load DLL dynamically
      hDLL := LoadLibrary(DLLPath);
      If (hDLL > HInstance_Error) Then Begin
        // Get Handle to procedure within DLL
        hCalcPword := GetProcAddress(hDLL, Pointer(1));

        If Assigned (hCalcPword) Then Begin
          // Initialise procedure parameters to authorisation values
          I1 := 235;
          I2 := 173842;
          I3 := -6472163;

          // Call procedure to calculate daily backdoor passwords
          hCalcPword (I1, I2, I3);

          // Return successful status to calling app
          Result := True;
        End { If Assigned (hCalcPword) }
        Else
          // Failed to get Procedure handle
          I1 := 20000 + GetLastError;

        // Unload Library from memory
        FreeLibrary (hDLL);
      End { If (hDLL > HInstance_Error) }
      Else
        // Failed to load DLL
        I1 := 100000 + GetLastError;
    End { If FileExists (DllPath) }
    Else
      // Backdoor DLL not found
      I1 := 1001;
  Finally
    StrDispose (DLLPath);
  End;
End; { CalcCTKPword }

//----------------------------------------------------------------------------

end.
