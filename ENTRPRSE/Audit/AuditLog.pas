unit AuditLog;

interface

Uses Classes, SysUtils, BlowFish;

Type
  TAuditLogReader = Class(TObject)
  Protected
    FAuditLogPath : ShortString;
    FAuditStrings : TStringList;

    Procedure ConfigureBlowfish (Var BlowFish : TBlowFish);
    Function ReadAndDecryptAuditLog (InputFileStream : TFileStream) : LongInt;
  Public
    Property AuditStrings : TStringList Read FAuditStrings Write FAuditStrings;

    Constructor Create (Const AuditLogPath : ShortString);
    Destructor Destroy; Override;

    Function ReadAuditLog : LongInt;
  End; // TAuditLogReader

  //------------------------------

  TAuditLogReaderWriter = Class(TAuditLogReader)
  Protected
    ReadWriteFileStream : TFileStream;
  Public
    //Constructor Create;
    Destructor Destroy; Override;

    Function ReadAuditLog : LongInt;
    Function WriteAuditLog : LongInt;

    Function Archive : LongInt;
  End; // TAuditLogReaderWriter

implementation

//=========================================================================

Constructor TAuditLogReader.Create (Const AuditLogPath : ShortString);
Begin // Create
  Inherited Create;

  FAuditLogPath := AuditLogPath;
  FAuditStrings := TStringList.Create;
End; // Create

//------------------------------

Destructor TAuditLogReader.Destroy;
Begin // Destroy
  FreeAndNIL(FAuditStrings);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Function TAuditLogReader.ReadAuditLog : LongInt;
Var
  InputFileStream : TFileStream;
Begin // ReadAuditLog
  FAuditStrings.Clear;

  If FileExists (FAuditLogPath) Then
  Begin
    InputFileStream := TFileStream.Create(FAuditLogPath, fmOpenRead, fmShareDenyNone);
    Try
      Result := ReadAndDecryptAuditLog(InputFileStream);
    Finally
      FreeAndNIL(InputFileStream);
    End; // Try..Finally
  End // If FileExists (AuditLogPath)
  Else
    Result := 0;
End; // ReadAuditLog

//-------------------------------------------------------------------------

Procedure TAuditLogReader.ConfigureBlowfish (Var BlowFish : TBlowFish);
Begin // ConfigureBlowfish
  BlowFish.CipherMode := ECB;
  BlowFish.InitialiseString('Darth_Horlock_Sez_Vote_Sith!'); // a seemingly random sequence of ascii Hex codes
End; // ConfigureBlowfish

//-------------------------------------------------------------------------

//   -2    Unknown Exception
//    0    AOK
Function TAuditLogReader.ReadAndDecryptAuditLog (InputFileStream : TFileStream) : LongInt;
Var
  BlowFish: TBlowFish;
  OutputMemStream : TMemoryStream;
Begin // ReadAuditLog
  Try
    BlowFish := TBlowFish.Create(NIL);
    OutputMemStream := TMemoryStream.Create;
    Try
      ConfigureBlowfish(BlowFish);

      // Read the Input stream, encrypt it and write it to the output stream
      BlowFish.DecStream(InputFileStream, OutputMemStream);

      // Save the text to a memory stream for encryption and saving
      OutputMemStream.Seek(0, soFromBeginning);
      FAuditStrings.LoadFromStream(OutputMemStream);

      Result := 0;
    Finally
      BlowFish.Burn;
      FreeAndNIL(BlowFish);
      FreeAndNIL(OutputMemStream);
    End; // Try..Finally
  Except
    On E:Exception Do
      Result := -2;
  End; // Try..Except
End; // ReadAuditLog

//=========================================================================

Destructor TAuditLogReaderWriter.Destroy;
Begin // Destroy
  If Assigned(ReadWriteFileStream) Then
    ReadWriteFileStream.Free;

  // MH 27/05/2015 v7.0.13 ABSEXCH-16325: Added missing call to ancestor
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Reads and locks the file
Function TAuditLogReaderWriter.ReadAuditLog : LongInt;
Begin // ReadAuditLog
  FAuditStrings.Clear;

  // Get rid of any pre-existing stream
  If Assigned(ReadWriteFileStream) Then
    FreeAndNIL(ReadWriteFileStream);

  Try
    // Create a new filestream to lock the file during the read and write process, if the file
    // is already locked then an exception should result
    If FileExists (FAuditLogPath) Then
      ReadWriteFileStream := TFileStream.Create(FAuditLogPath, fmOpenReadWrite Or fmShareExclusive)
    Else
      ReadWriteFileStream := TFileStream.Create(FAuditLogPath, fmCreate Or fmShareExclusive);

    Result := ReadAndDecryptAuditLog(ReadWriteFileStream);
  Except
    On E:Exception Do
      Result := -2;
  End; // Try..Excepttrye
End; // ReadAuditLog

//-------------------------------------------------------------------------

//   -2    Unknown Exception
//    0    AOK
Function TAuditLogReaderWriter.WriteAuditLog : LongInt;
Var
  BlowFish: TBlowFish;
  InputMemStream : TMemoryStream;
Begin // WriteAuditLog
  Try
    BlowFish := TBlowFish.Create(NIL);
    InputMemStream := TMemoryStream.Create;
    Try
      ConfigureBlowfish (BlowFish);

      // Save the text to a memory stream for encryption and saving
      FAuditStrings.SaveToStream(InputMemStream);

      // Move to start of stream for encryption
      InputMemStream.Seek(0, soFromBeginning);
      ReadWriteFileStream.Seek(0, soFromBeginning);

      // Read the Input stream, encrypt it and write it to the file stream for the audit file
      BlowFish.EncStream(InputMemStream, ReadWriteFileStream);

      Result := 0;
    Finally
      BlowFish.Burn;
      FreeAndNIL(BlowFish);
      FreeAndNIL(InputMemStream);
    End; // Try..Finally
  Except
    On E:Exception Do
      Result := -2;
  End; // Try..Except
End; // WriteAuditLog

//-------------------------------------------------------------------------

// -999   ReadWrite Stream doesn't exist
Function TAuditLogReaderWriter.Archive : LongInt;
Begin // Archive
  If Assigned(ReadWriteFileStream) Then
  Begin
    ReadWriteFileStream.Size := 0;
    FAuditStrings.Clear;
    Result := 0;
  End // If Assigned(ReadWriteFileStream)
  Else
    Result := -999;
End; // Archive

//-------------------------------------------------------------------------

end.
