unit ConvUtil;

interface

Type
  TBtrieveFileUtilities = Class(TObject)
  Private
  Public
    // Deletes the specified btrieve file and any extension files, returns true if all existing files
    // were deleted successfully
    Function Delete (Const FilePath : ShortString; Const StopOnError : Boolean = False) : Boolean;

    // Returns the extension of the last extension files
    Class Function LastExtensionFile (Const FilePath : ShortString) : ShortString;

    // Returns the size of the specified btrieve file and any extension files in bytes
    Class Function Size (Const FilePath : ShortString) : Int64;

    // Renames the specified btrieve file and any extension files from CurrentName to NewName,
    // returns True if successful
    Function RenameFile (Const CurrentName, NewName : ShortString) : Boolean;

  End; // TBtrieveFileUtilities

// Returns the size of an individual file
Function FileSize (Const Filepath : ShortString) : Int64;

// Modifies the string for XML safety
Function FixDodgyChars (Const DodgyString : ShortString) : ShortString;

// Converts a size in bytes to megabytes - assuming 1Mb = 1000Kb
Function ToMb (Const SizeInBytes : Int64) : Int64;

// Translates the character used to store the Default Stock Valuation Method in System Setup - Stock
// to a description
function TranslateStockValuationMethod (Const StkValMethod : WideChar) : ShortString; Overload;
function TranslateStockValuationMethod (Const StkValMethod : Char) : ShortString; Overload;

implementation

Uses SysUtils, Windows;

Const
  MKDEExtensionFileExtensions : Array[1..31] Of String[4] =
      ('.^01', '.^02', '.^03', '.^04', '.^05', '.^06', '.^07', '.^08', '.^09', '.^0A',
       '.^0B', '.^0C', '.^0D', '.^0E', '.^0F', '.^10', '.^11', '.^12', '.^13', '.^14',
       '.^15', '.^16', '.^17', '.^18', '.^19', '.^1A', '.^1B', '.^1C', '.^1D', '.^1E', '.^1F');

//=========================================================================

// Returns the size of an individual file
Function FileSize (Const Filepath : ShortString) : Int64;
Var
  DatFileInfo : TSearchRec;
  DatSrchRes  : Integer;
  MaxD, ThisDirSpace, Tmp : Double;
Begin // FileSize
  Result := 0;

  // Get file size of file and multiply by some magic number
  If FileExists(FilePath) Then
  Begin
    { check 1+ files exist on network with matching name (including wildcards) }
    DatSrchRes := FindFirst(FilePath, faAnyFile, DatFileInfo);
    Try
      If (DatSrchRes = 0) Then
      Begin
        // Very complex calculation to handle very large files (>4Gb) - the calculation is very
        // weird and I didn't fancy messing around with it just in case it needed to be like this!
        MaxD := MaxDWord;
        MaxD := MaxD + 1;
        Tmp := (DatFileInfo.FindData.nFileSizeHigh * MaxD);
        ThisDirSpace := DatFileInfo.FindData.nFileSizeLow + Tmp;
        Result := Round(ThisDirSpace);
      End; // If (DatSrchRes = 0)
    Finally
      SysUtils.FindClose (DatFileInfo);
    End; // Try..Finally
  End; // If FileExists(FilePath)
End; // FileSize

//-------------------------------------------------------------------------

// Modifies the string for XML safety
Function FixDodgyChars (Const DodgyString : ShortString) : ShortString;
Var
  I : SmallInt;
Begin // FixDodgyChars
  Result := '';
  For I := 1 To Length(DodgyString) Do
  Begin
    Case DodgyString[I] Of
      '<' : Result := Result + '&lt;';
      '>' : Result := Result + '&gt;';
      '"' : Result := Result + '&quot;';
      '&' : Result := Result + '&amp;';
    Else
      Result := Result + DodgyString[I];
    End; // Case DodgyString[I]
  End; // For I
End; // FixDodgyChars

//-------------------------------------------------------------------------

// Converts a size in bytes to megabytes - assuming 1Mb = 1000Kb
Function ToMb (Const SizeInBytes : Int64) : Int64;
Begin // ToMb
  If (SizeInBytes > 0) Then
    Result := Round(SizeInBytes / 1024000)
  Else
    Result := 0;
End; // ToMb

//-------------------------------------------------------------------------

// Translates the character used to store the Default Stock Valuation Method in System Setup - Stock
// to a description
function TranslateStockValuationMethod (Const StkValMethod : WideChar) : ShortString;
begin
  Case StkValMethod Of
    'C' : Result := 'Last Cost';
    'S' : Result := 'Standard';
    'F' : Result := 'FIFO';
    'L' : Result := 'LIFO';
    'A' : Result := 'Average';
    'R' : Result := 'Serial/Batch';
    'E' : Result := 'Serial/Batch Average Cost';
  Else
    Result := 'Unknown';
  End; { Case }
end;

//------------------------------

// Translates the character used to store the Default Stock Valuation Method in System Setup - Stock
// to a description
function TranslateStockValuationMethod (Const StkValMethod : Char) : ShortString;
Var
  X : WideChar;
  Size : Integer;
Begin // TranslateStockValuationMethod
  StringToWideChar(StkValMethod, @X, Size);
  Result := TranslateStockValuationMethod (X);
End; // TranslateStockValuationMethod

//=========================================================================

// Deletes the specified btrieve file and any extension files, returns true if all existing files
// were deleted successfully
Function TBtrieveFileUtilities.Delete (Const FilePath : ShortString; Const StopOnError : Boolean = False) : Boolean;
Var
  ExtFile : ShortString;
  I       : Byte;
Begin // Delete
  If FileExists (FilePath) Then
    Result := SysUtils.DeleteFile(FilePath)
  Else
    Result := True;

  If Result Or (Not StopOnError) Then
  Begin
    For I := Low(MKDEExtensionFileExtensions) To High(MKDEExtensionFileExtensions) Do
    Begin
      ExtFile := ChangeFileExt(FilePath, MKDEExtensionFileExtensions[I]);
      If FileExists (ExtFile) Then
      Begin
        {$BOOLEVAL ON}
        Result := Result And SysUtils.DeleteFile(ExtFile);
        {$BOOLEVAL OFF}
        If (Not Result) And StopOnError Then
          Break;
      End; // If FileExists (ExtFile)
    End; // For I
  End; // If Result Or (Not StopOnError)
End; // Delete

//-------------------------------------------------------------------------

// Returns the size of the specified btrieve file and any extension files in bytes
Class Function TBtrieveFileUtilities.Size (Const FilePath : ShortString) : Int64;
Var
  ExtFile : ShortString;
  I       : Byte;
Begin // Size
  If FileExists (FilePath) Then
    Result := FileSize (FilePath)
  Else
    Result := 0;

  For I := Low(MKDEExtensionFileExtensions) To High(MKDEExtensionFileExtensions) Do
  Begin
    ExtFile := ChangeFileExt(FilePath, MKDEExtensionFileExtensions[I]);
    If FileExists (ExtFile) Then
    Begin
      Result := Result + FileSize (ExtFile);
    End; // If FileExists (ExtFile)
  End; // For I
End; // Size

//-------------------------------------------------------------------------

// Returns the extension of the last extension files
Class Function TBtrieveFileUtilities.LastExtensionFile (Const FilePath : ShortString) : ShortString;
Var
  ExtFile : ShortString;
  I       : Byte;
Begin // LastExtensionFile
  If FileExists (FilePath) Then
  Begin
    Result := Copy(ExtractFileExt(FilePath), 2, 255);

    For I := Low(MKDEExtensionFileExtensions) To High(MKDEExtensionFileExtensions) Do
    Begin
      ExtFile := ChangeFileExt(FilePath, MKDEExtensionFileExtensions[I]);
      If FileExists (ExtFile) Then
      Begin
        Result := Copy(ExtractFileExt(ExtFile), 2, 255);
      End // If FileExists (ExtFile)
      Else
        Break;
    End; // For I
  End // If FileExists (FilePath)
  Else
    Result := '';
End; // LastExtensionFile

//-------------------------------------------------------------------------

// Renames the specified btrieve file and any extension files from CurrentName to NewName,
// returns True if successful
Function TBtrieveFileUtilities.RenameFile (Const CurrentName, NewName : ShortString) : Boolean;
Var
  ExtFile : ShortString;
  I       : Byte;
Begin // RenameFile
  If FileExists (CurrentName) Then
    Result := SysUtils.RenameFile(CurrentName, NewName)
  Else
    Result := True;

  If Result Then
  Begin
    For I := Low(MKDEExtensionFileExtensions) To High(MKDEExtensionFileExtensions) Do
    Begin
      ExtFile := ChangeFileExt(CurrentName, MKDEExtensionFileExtensions[I]);
      If FileExists (ExtFile) Then
      Begin
        Result := SysUtils.RenameFile(ExtFile, ChangeFileExt(NewName, MKDEExtensionFileExtensions[I]));
        If (Not Result) Then
          Break;
      End; // If FileExists (ExtFile)
    End; // For I
  End; // If Result Or (Not StopOnError)
End; // RenameFile

//=========================================================================
end.
