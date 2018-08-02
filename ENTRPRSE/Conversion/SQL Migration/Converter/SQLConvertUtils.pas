Unit SQLConvertUtils;

Interface

Uses SysUtils;

type
  // Used by Trade Counter structures
  string6   = string[6];
  string8   = string[8];
  string10  = string[10];
  string16  = string[16];
  string20  = string[20];
  string25  = string[25];
  string45  = string[45];
  string50  = string[50];
  string100 = string[100];

// Calculates the size in bytes of a binary block between the address of two fields in a record
// structure, StartAddr is the address of the first field, NextFieldAddr is the address of the
// next field AFTER the block
Function CalculateBinaryBlockSize (Const StartAddr : Pointer; Const NextFieldAddr : Pointer) : Integer;

// Returns a CHAR as an ANSIString but filters out character 0 to emulate the SQL Emulator bahaviour
Function ConvertCharToSQLEmulatorVarChar(Const TheChar : Char) : ANSIString;

// Returns a variant array of the specified length
Function CreateVariantArray (Const StartAddr : Pointer; Const ArrayLength : Integer) : Variant;

// Converts a block of memory to a hexadecimal string for safe output to XML
Function ToHexString (Const MemPtr : PByteArray; Const MemLength : Integer) : ANSIString;

// Converts a block of memory to a human readable string for safe output to XML
Function ToHumanReadableString (Const MemPtr : PByteArray; Const MemLength : Integer) : ANSIString;

// Extracts and returns a FullNomKey value from the string at an optional position
Function UnFullNomKey (Const NomKeyString : ShortString; Const StartPos : Byte = 1) : LongInt;

//If ADateTime is 0 then returns NULL otherwise returns ADateTime
function DateTimeToSQLDateTimeOrNull(const ADateTime : TDateTime) : Variant;

//If all members of array are #0 then returns an empty string, otherwise returns array as an AnsiString;
function CharArrayToVarChar(const AData : Array of Char) : AnsiString;

// Returns the number of currently available bytes of memory
Function AvailableMemoryInBytes : LongWord;


Implementation

Uses Variants, Windows;

//=========================================================================

// Returns a CHAR as an ANSIString but filters out character 0 to emulate the SQL Emulator bahaviour
Function ConvertCharToSQLEmulatorVarChar(Const TheChar : Char) : ANSIString;
Begin // ConvertCharToSQLEmulatorVarChar
  If (TheChar = #0) Then
    Result := ''
  Else
    Result := TheChar;
End; // ConvertCharToSQLEmulatorVarChar

//-------------------------------------------------------------------------

// Calculates the size in bytes of a binary block between the address of two fields in a record
// structure, StartAddr is the address of the first field, NextFieldAddr is the address of the
// next field AFTER the block
Function CalculateBinaryBlockSize (Const StartAddr : Pointer; Const NextFieldAddr : Pointer) : Integer;
Begin // CalculateBinaryBlockSize
  Result := LongInt(NextFieldAddr) - LongInt(StartAddr);
End; // CalculateBinaryBlockSize

//-------------------------------------------------------------------------

// Returns a variant array of the specified length
Function CreateVariantArray (Const StartAddr : Pointer; Const ArrayLength : Integer) : Variant;
Type
  MemoryBufferType = Array[1..40000] Of Byte;
Var
  MemAddr : ^MemoryBufferType;
  I : Integer;
Begin // CreateVariantArray
  If (ArrayLength > SizeOf(MemoryBufferType)) Then
    Raise Exception.Create ('CreateVariantArray: Maximum Size Exceeded (' + IntToStr(SizeOf(MemoryBufferType)) + '/' + IntToStr(ArrayLength) + ')');

  // Create a variant byte array of the required length
  Result := VarArrayCreate([0, (ArrayLength - 1)], VarByte);

  // Remap the local buffer array variable onto the
  MemAddr := StartAddr;

  For I := 1 to ArrayLength Do
  Begin
    Result[I-1] := MemAddr^[I];
  End; // For I
End; // CreateVariantArray

//-------------------------------------------------------------------------

// Extracts and returns a FullNomKey value from the string at an optional position
Function UnFullNomKey (Const NomKeyString : ShortString; Const StartPos : Byte = 1) : LongInt;
Begin // UnFullNomKey
  Move (NomKeyString[StartPos], Result, SizeOf(Result));
End; // UnFullNomKey

//-------------------------------------------------------------------------

// Converts a block of memory to a hexadecimal string for safe output to XML
Function ToHexString (Const MemPtr : PByteArray; Const MemLength : Integer) : ANSIString;
Var
  I : Integer;
Begin // ToHexString
  Result := '0x';

  If (MemLength > 0) Then
  Begin
    For I := 0 To (MemLength - 1) Do
    Begin
      Result := Result + IntToHex(MemPtr^[I], 2);
    End; // For I
  End; // If (MemLength > 0)
End; // ToHexString

//-------------------------------------------------------------------------

// Converts a block of memory to a human readable string for safe output to XML
Function ToHumanReadableString (Const MemPtr : PByteArray; Const MemLength : Integer) : ANSIString;
Var
  I : Integer;
Begin // ToHexString
  Result := '';

  If (MemLength > 0) Then
  Begin
    For I := 0 To (MemLength - 1) Do
    Begin
      // Filter out '<', '>'
      If (Ord(MemPtr^[I]) In [32..59, 61, 63..126]) Then
        // anything after space should work ok
        Result := Result + Chr(MemPtr^[I])
      Else
        // non printable characters
        Result := Result + '#' + IntToStr(MemPtr^[I]);
    End; // For I
  End; // If (MemLength > 0)
End; // ToHexString

//-------------------------------------------------------------------------

//If ADateTime is 0 then returns NULL otherwise returns ADateTime
function DateTimeToSQLDateTimeOrNull(const ADateTime : TDateTime) : Variant;
begin
  if ADateTime <> 0 then
    Result := ADateTime
  else
    Result := NULL;
end;

//-------------------------------------------------------------------------

//If all members of array are #0 then returns an empty string, otherwise returns array as an AnsiString;
function CharArrayToVarChar(const AData : Array of Char) : AnsiString;
var
  i : integer;
begin
  Result := '';
  for i := Low(AData) to High(AData) do
    if AData[i] <> #0 then
    begin
      Result := AnsiString(AData);
      Break;
    end;
end;

//-------------------------------------------------------------------------

// Returns the number of currently available bytes of memory
Function AvailableMemoryInBytes : LongWord;
Var
  Memory : TMemoryStatus;
Begin // AvailableMemoryInBytes
  // Set default max amount of memory to be used by the app to 50% of available memory
  Memory.dwLength := SizeOf(Memory);
  GlobalMemoryStatus (Memory);
  Result := Memory.dwAvailPhys;
End; // AvailableMemoryInBytes

//-------------------------------------------------------------------------

End.
