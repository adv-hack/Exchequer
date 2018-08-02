unit SerialU;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$IFDEF WIN32}
  {$ALIGN 1}  { Variable Alignment Disabled }
{$ENDIF}


interface

Type
  SerialNoStrType = String[9];

  SerialNoType    = Array [1..4] Of Byte;

{$IFDEF WIN32}
{ Convert Byte to hex string equivalent }
Function ByteToHexStr (Const TheByte : Byte) : ShortString;

{ Converts 2 character hex string to Byte equivalent }
Function HexStrToByte (Const HexStr : ShortString) : Byte;

{ Converts a Serial Numbers array of byte into a display string }
Function SNoByteToStr (Const SnoByte : SerialNoType) : ShortString;

{ Converts a Serial Numbers array of byte into a ISN format display string }
Function SNoByteToISN (Const CDByte, LclByte : SerialNoType) : ShortString;

{ Converts a Serial Numbers String into an array of byte }
Function SNoStrToSNoByte (Const SNoStr : SerialNoStrType) : SerialNoType;

{ Checks the OS for specified criterion }
Function CheckOSVer (Const CheckNo : Byte) : Boolean;

{ Returns the Serial Number of the specified drive }
Function GetDriveSerial (Const TheDrive : Char) : ShortString;

{ Returns the Serial Number of the specified drive as an array of byte }
Function GetDriveSerialB (Const TheDrive : Char) : SerialNoType;

Function IntToStr3 (Const Value : Integer) : ShortString;
{$ENDIF}


implementation


{$IFDEF WIN32 }
{$Warn Unit_Platform Off}
Uses Dialogs, FileCtrl, SysUtils, Windows;

{---------------------------------------------------------------------------}

{ Convert Byte to hex string equivalent }
Function ByteToHexStr (Const TheByte : Byte) : ShortString;
Begin { ByteToHexStr }
  Result := Format ('%2x', [TheByte]);

  { Check for blank leading byte }
  If (Result[1] = ' ') Then
    Result[1] := '0';
End; { ByteToHexStr }

{---------------------------------------------------------------------------}

{ Converts 2 character hex string to Byte equivalent }
Function HexStrToByte (Const HexStr : ShortString) : Byte;
Var
  Res : SmallInt;

  Function CharVal (Const TheChar : Char) : Byte;
  Begin { CharVal }
    Case TheChar Of
      '0' : Result := 0;
      '1' : Result := 1;
      '2' : Result := 2;
      '3' : Result := 3;
      '4' : Result := 4;
      '5' : Result := 5;
      '6' : Result := 6;
      '7' : Result := 7;
      '8' : Result := 8;
      '9' : Result := 9;
      'A' : Result := 10;
      'B' : Result := 11;
      'C' : Result := 12;
      'D' : Result := 13;
      'E' : Result := 14;
      'F' : Result := 15;
    Else
      Result := 0;
    End; { Case }
  End; { CharVal }

Begin { HexStrToByte }
  Result := 0;

  If (Length(HexStr) = 2) Then Begin
    Res := (CharVal(HexStr[1]) * 16) + CharVal(HexStr[2]);

    If (Res >= 0) Then
      Result := Res
    Else
      Result := 0;
  End; { If }
End; { HexStrToByte }

{---------------------------------------------------------------------------}


{ Converts a Serial Numbers array of byte into a display string }
Function SNoByteToStr (Const SnoByte : SerialNoType) : ShortString;
Begin { SNoByteToStr }
  Result := ByteToHexStr(SnoByte[1]) + ByteToHexStr(SnoByte[2]) + '-' +
            ByteToHexStr(SnoByte[3]) + ByteToHexStr(SnoByte[4]);
End; { SNoByteToStr }

{---------------------------------------------------------------------------}

Function IntToStr3 (Const Value : Integer) : ShortString;
Begin { IntToStr3 }
  If (Value >= 0) And (Value <= 255) Then Begin
    Result := '00' + IntToStr(Value);

    While(Length(Result) > 3) Do Delete (Result, 1, 1);
  End { If }
  Else
    Result := 'xxx';
End; { IntToStr3 }

{---------------------------------------------------------------------------}

{ Converts a Serial Numbers array of byte into a, ISN format display string }
Function SNoByteToISN (Const CDByte, LclByte : SerialNoType) : ShortString;
Begin { SNoByteToISN }
  Result := IntToStr3(CDByte[1])  + '-' +
            IntToStr3(LclByte[1]) + '-' +
            IntToStr3(LclByte[2]) + '-' +
            IntToStr3(CDByte[2])  + '-' +
            IntToStr3(LclByte[3]) + '-' +
            IntToStr3(LclByte[4]);
End; { SNoByteToISN }

{---------------------------------------------------------------------------}

{ Converts a Serial Numbers String into an array of byte }
Function SNoStrToSNoByte (Const SNoStr : SerialNoStrType) : SerialNoType;
Var
  I : Byte;
Begin { SNoStrToSNoByte }
  For I := Low(Result) To High(Result) Do
    Result[I] := 0;

  Try
    If (Length(SNoStr) >= 2) Then
      Result [1] := HexStrToByte (Copy(SNoStr, 1, 2));

    If (Length(SNoStr) >= 4) Then
      Result [2] := HexStrToByte (Copy(SNoStr, 3, 2));

    If (Length(SNoStr) >= 7) Then
      Result [3] := HexStrToByte (Copy(SNoStr, 6, 2));

    If (Length(SNoStr) >= 9) Then
      Result [4] := HexStrToByte (Copy(SNoStr, 8, 2));
  Except
    On Ex:Exception Do
      ;
  End;
End; { SNoStrToSNoByte }

{---------------------------------------------------------------------------}

{ Returns true if NT is running }
Function CheckOSVer (Const CheckNo : Byte)  :  Boolean;
Var
  OSVerIRec : TOSVersionInfo;
Begin { CheckOSVer }
  Result:=False;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);

  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);

  If (GetVersionEx(OSVerIRec)) Then Begin
    Case CheckNo Of
      1 : Begin { Any version of NT }
            Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT);
          End;
      2 : Begin { NT4 or later (?) }
            Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT) And
                      (OSVerIRec.dwMajorVersion >= 4);
          End;
      3 : Begin { NT4 }
            Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT) And
                      (OSVerIRec.dwMajorVersion = 4);
          End;
      4 : Begin { NT3.51 }
            Result := (OSVerIRec.dwPlatformId = VER_PLATFORM_WIN32_NT) And
                      (OSVerIRec.dwMajorVersion = 3) And
                      (OSVerIRec.dwMinorVersion = 51);
          End;
    End; { Case }
  End; { If }
End; { CheckOSVer }

{---------------------------------------------------------------------------}

{ Returns the Serial Number of the specified drive }
Function GetDriveSerial (Const TheDrive : Char) : ShortString;
(*
Type
  CharArrType = Array[1..4] Of Byte;
Var
  OldErrorMode               : Integer;
  pDrive, pVolName, pSysName : PChar;
  pSerial, NotUsed, VolFlags : DWord;
  CharArr                    : ^CharArrType;
*)
Var
  Sno : SerialNoType;
begin
(*
  Result := '    -    ';

  pDrive := StrAlloc (100);
  StrPCopy (pDrive, TheDrive + ':\');

  { Get Volume Information:- File System + Compression }
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    pVolName := StrAlloc (200);
    pSysName := StrAlloc (200);
    pSerial  := 0;

    If GetVolumeInformation(pDrive,           { Drive }
                            pVolName,         { Volume Name }
                            200,              { Volume Name Length }
                            @pSerial,         { Volume Serial Number }
                            NotUsed,          { Max filename length }
                            VolFlags,         { Volume Flags }
                            pSysName,         { File System Name }
                            100) Then Begin   { File system Name Length }


      CharArr := @pSerial;

      If (TDriveType(GetDriveType(pDrive)) = dtCDROM) Then Begin
        { CD-ROM drive }
        If CheckOSVer (1) Then Begin
          { Windows NT }
          If CheckOSVer (4) Then Begin
            { NT 3.51 - it can't read Serial Numbers from CD's to save its life - default to fixed }
            Result := 'ABCD-1234';
          End { If }
          Else Begin
            { NT 4 or later - reverse the byte order to be compatible with Win 9x }
            Result := ByteToHexStr(CharArr[1]) +
                      ByteToHexStr(CharArr[2]) + '-' +
                      ByteToHexStr(CharArr[3]) +
                      ByteToHexStr(CharArr[4]);
          End; { Else }
        End { If }
        Else Begin
          Result := ByteToHexStr(CharArr[4]) +
                    ByteToHexStr(CharArr[3]) + '-' +
                    ByteToHexStr(CharArr[2]) +
                    ByteToHexStr(CharArr[1]);
        End; { Else }
      End { If }
      Else Begin
        { Not CD-ROM Drive}
        Result := ByteToHexStr(CharArr[4]) +
                  ByteToHexStr(CharArr[3]) + '-' +
                  ByteToHexStr(CharArr[2]) +
                  ByteToHexStr(CharArr[1]);
      End; { Else }
    End; { If }

    StrDispose(pVolName);
    StrDispose(pSysName);
  Finally
    SetErrorMode(OldErrorMode);
  End;
*)

  SNo := GetDriveSerialB (TheDrive);

  Result := SNoByteToStr (SNo);
end;

{---------------------------------------------------------------------------}

{ Returns the Serial Number of the specified drive as an array of byte }
Function GetDriveSerialB (Const TheDrive : Char) : SerialNoType;
Type
  CharArrType = Array[1..4] Of Byte;
Var
  OldErrorMode, I            : Integer;

  pDrive, pVolName, pSysName : PChar;
  pSerial, NotUsed, VolFlags : DWord;
  CharArr                    : ^SerialNoType;
Begin { GetDriveSerialB }
  { Initialise Result }
  For I := Low(Result) To High(Result) Do
    Result[I] := 0;


  pDrive := StrAlloc (100);
  StrPCopy (pDrive, TheDrive + ':\');

  { Get Volume Information:- File System + Compression }
  OldErrorMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    pVolName := StrAlloc (200);
    pSysName := StrAlloc (200);
    pSerial  := 0;

    If GetVolumeInformation(pDrive,           { Drive }
                            pVolName,         { Volume Name }
                            200,              { Volume Name Length }
                            @pSerial,         { Volume Serial Number }
                            NotUsed,          { Max filename length }
                            VolFlags,         { Volume Flags }
                            pSysName,         { File System Name }
                            100) Then Begin   { File system Name Length }


      CharArr := @pSerial;

      If (TDriveType(GetDriveType(pDrive)) = dtCDROM) Then Begin
        { CD-ROM drive }
        If CheckOSVer (1) Then Begin
          { Windows NT }
          If CheckOSVer (4) Then Begin
            { NT 3.51 - it can't read Serial Numbers from CD's to save its life - default to fixed }
            Result[1] := 171;  { AB }
            Result[2] := 205;  { CD }
            Result[3] := 18;   { 12 }
            Result[4] := 51;   { 34 }
          End { If }
          Else Begin
            { NT 4 or later - reverse the byte order to be compatible with Win 9x }
            Result[1] := CharArr[1];
            Result[2] := CharArr[2];
            Result[3] := CharArr[3];
            Result[4] := CharArr[4];
          End; { Else }
        End { If }
        Else Begin
          Result[1] := CharArr[4];
          Result[2] := CharArr[3];
          Result[3] := CharArr[2];
          Result[4] := CharArr[1];
        End; { Else }
      End { If }
      Else Begin
        { Not CD-ROM Drive}
        Result[1] := CharArr[4];
        Result[2] := CharArr[3];
        Result[3] := CharArr[2];
        Result[4] := CharArr[1];
      End; { Else }
    End; { If }

    StrDispose(pVolName);
    StrDispose(pSysName);
  Finally
    SetErrorMode(OldErrorMode);
  End;
End; { GetDriveSerialB }

{$ENDIF}

end.

