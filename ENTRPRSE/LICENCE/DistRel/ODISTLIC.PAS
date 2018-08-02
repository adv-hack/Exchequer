unit oDistLic;

interface

Const
  // Default number of days granted on a new licence
  DefaultLicenceDays = 90;

  // Licence File Name
  DistLicenceFName = 'ENDISTRC.DRL';

Type
  DistributorLicenceRecType = Record
    dlrLicencee      : ShortString;
    dlrPassword      : ShortString;
    dlrLicenceExpiry : TDateTime;

    dlrSpare         : Array [1..400] Of Byte;
  End; { DistributorLicenceRecType }

  TDistributorLicence = Class(TObject)
  Private
    FFileStamp      : TDateTime;
    FLicence        : DistributorLicenceRecType;
    FMajorVersion   : Byte;
    FMinorVersion   : Byte;
    FCheckSum       : Byte;
    FTimeStamp      : TDateTime;

    function GetLicencee: ShortString;
    function GetLicenceExpiry: TDateTime;
    function GetPassword: ShortString;
    procedure SetLicencee(const Value: ShortString);
    procedure SetLicenceExpiry(const Value: TDateTime);
    procedure SetPassword(const Value: ShortString);
  Protected
    Function CalcBufferCheckSum (Const MemBuffer : Pointer; Const MemBufferLen : LongInt) : Byte;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Function  Expired : Boolean;
    Procedure InitLicencing;
    Function  Open (Const LicencePath : ShortString) : LongInt;
    Function  Save (Const LicencePath : ShortString) : LongInt;

    Property dlLicencee : ShortString Read GetLicencee Write SetLicencee;
    Property dlPassword : ShortString Read GetPassword Write SetPassword;
    Property dlLicenceExpiry : TDateTime Read GetLicenceExpiry Write SetLicenceExpiry;

    Property dlLicenceMajorVer : Byte Read FMajorVersion;
    Property dlLicenceMinorVer : Byte Read FMinorVersion;
  End; { TDistributorLicence }

implementation

Uses Classes, DateUtils, Dialogs, Forms, SysUtils, Types, Windows, Crypto, ZLib;

Const
  // HM Changed signature to invalidate previous licences
  //StartSigByte : ShortString = #217#124#96#197#255#197#96#124#217;
  StartSigByte : ShortString = #216#124#96#197#255#197#96#124#216;

//----------------------------------------------------------------------------

constructor TDistributorLicence.Create;
begin
  Inherited Create;

  // Initialise the licencing variables
  InitLicencing;
end;

//-----------------------------------

destructor TDistributorLicence.Destroy;
begin
  // ?

  inherited;
end;

//----------------------------------------------------------------------------

procedure TDistributorLicence.InitLicencing;
begin
  // Initialise the Internal Licence variables
  FillChar (FLicence, SizeOf(FLicence), #0);

  // Set default values
  With FLicence Do Begin
    // file structure version
    FMajorVersion := 2;
    FMinorVersion := 0;

    // Licence Timestamp
    FTimeStamp := -1.0;

    // Data checksum (after encryption)
    FCheckSum  := 0;

    // File Date/Time
    FFileStamp := -1.0;

    // Leave Licencee blank
    //dlrLicencee      : ShortString;

    // Leave Password blank
    //dlrPassword      : ShortString;

    // Default Licence Expiry Date - Expire on Thursday to ensure plenty of time to contact us
    dlrLicenceExpiry := Now + DefaultLicenceDays;
    Repeat
      dlrLicenceExpiry := dlrLicenceExpiry + 1;
    Until (DayOfTheWeek(dlrLicenceExpiry) = DayWednesday);
  End; { With FLicence }
end;

//----------------------------------------------------------------------------

function TDistributorLicence.GetLicencee: ShortString;
begin
  Result := FLicence.dlrLicencee;
end;

procedure TDistributorLicence.SetLicencee(const Value: ShortString);
begin
  FLicence.dlrLicencee := Value;
end;

//-----------------------------------

function TDistributorLicence.GetLicenceExpiry: TDateTime;
begin
  Result := FLicence.dlrLicenceExpiry;
end;

procedure TDistributorLicence.SetLicenceExpiry(const Value: TDateTime);
begin
  FLicence.dlrLicenceExpiry := Value;
end;

//-----------------------------------

function TDistributorLicence.GetPassword: ShortString;
begin
  Result := FLicence.dlrPassword;
end;

procedure TDistributorLicence.SetPassword(const Value: ShortString);
begin
  FLicence.dlrPassword := UpperCase(Trim(Value));
end;

//---------------------------------------------------------------------------

Function TDistributorLicence.CalcBufferCheckSum (Const MemBuffer : Pointer; Const MemBufferLen : LongInt) : Byte;
Type
  BufferArrayType = Array[1..100000] Of Byte;
Var
  MemArray    : ^BufferArrayType;
  CheckSum, I : LongInt;
Begin { CalcBufferCheckSum }
  Result := 0;

  // Always return zero checksum for zero length buffers
  If (MemBufferLen > 0) Then
    // Check buffer fits within pre-defined length
    If (MemBufferLen <= SizeOf(BufferArrayType)) Then Begin
      // ReMap Memory Buffer pointer over the Array of Byte
      MemArray := MemBuffer;

      // Sum the values of the buffer for the CheckSum calculation
      CheckSum := 0;
      For I := 1 To MemBufferLen Do
        CheckSum := CheckSum + MemArray^[I];

      // Return CheckSum
      Result := CheckSum Mod 255;
    End { If (MemBufferLen <= SizeOf(BufferArrayType)) }
    Else
      Raise Exception.Create ('TDistributorLicence.CalcBufferCheckSum - Buffer too large');
End; { CalcBufferCheckSum }

//----------------------------------------------------------------------------

// Return Values:-
//
//  0      AOK
//  1000   Unknown Error
//  1001   Unknown Exception
//  2001   File Signature Invalid
//  2002   Checksum mismatch
//  2003   Licence File Locked
function TDistributorLicence.Open(const LicencePath: ShortString): LongInt;
Var
  MemBuffer      : Pointer;
  Licence        : ^DistributorLicenceRecType;
  LicenceLen     : LongInt;
  sBuffer        : ShortString;
  iBuffer        : SmallInt;
  CheckByte      : Byte;
  FileStream     : TFileStream;
  StartTime      : DWord;
begin
  Result := 0;

  // Clear out any pre-existing licencing information
  InitLicencing;

  Try
    // Allocate memory for compression buffering
    LicenceLen := SizeOf (Licence^);
    New (Licence);
    Try
      // Read Date/Time stamp of file
      FFileStamp := FileDateToDateTime(FileAge(LicencePath + DistLicenceFName));

      // Create the input stream for reading the licence file - may get error if locked for writing
      FileStream := NIL;
      StartTime := GetTickCount;
      Repeat
        Try
          FileStream := TFileStream.Create (LicencePath + DistLicenceFName, fmOpenRead or fmShareDenyNone);
        Except
          On Exception Do Begin
            // Remove reference to the dud FileStream
            FileStream := NIL;

            // File Open Error - probably locked by another app writing to it
            If ((GetTickCount - StartTime) > 10000) Then
              // 10 seconds elapsed-  time out and return an error
              Result := 2003;

            // Wait a while to see if the problem will go away
            Application.ProcessMessages;
            Sleep(50);
          End; { On Exception  }
        End; { Except }
      Until (Result <> 0) Or Assigned(FileStream);

      If (Result = 0) Then Begin
        // Read the licencing details
        With FileStream Do
          Try
            // Licence Header --------------------------------------------------------

            // File Signature (Uncompressed)
            SetLength(sBuffer,9);
            Read (sBuffer[1], Length(sBuffer));
            If (sBuffer <> StartSigByte) Then
              Result := 2001;

            // File Version
            If (Result = 0) Then Begin
              Read(FMajorVersion, 1);
              Read(FMinorVersion, 1);
            End; { If (Result = 0) }

            // Licence Creation Date/Time stamp
            If (Result = 0) Then
              Read(FTimeStamp, SizeOf(FTimeStamp));

            // File Checksum
            If (Result = 0) Then
              Read(FCheckSum, SizeOf(FCheckSum));

            // Licencee Details  -----------------------------------------------------
            If (Result = 0) Then Begin
              // Extract Length of compressed Licencing Details buffer
              Read (iBuffer, SizeOf (iBuffer));

              GetMem (MemBuffer, iBuffer);
              Try
                // Copy the compressed section into the Memory buffer for decompression
                Read (MemBuffer^, iBuffer);

                // Check the Checksum byte
                CheckByte := CalcBufferCheckSum(MemBuffer, iBuffer);
                If (CheckByte <> FCheckSum) Then
                  Result := 2002;

                // Decompress the Memory Buffer into the original structure
                If (Result = 0) Then
                  DecompressToUserBuf(MemBuffer,        // InBuffer containing compressed data
                                      iBuffer,          // Size of In Buffer
                                      Licence,          // OutputBuffer receiving uncompressed data
                                      LicenceLen);      // Bytes placed into OutputBuffer

                // Decrypt the licence Details
                DecodeDataKey (17382, Licence, LicenceLen);

                // Copy the details out of the uncompressed Licencing structure
                FLicence := Licence^;
              Finally
                FreeMem (MemBuffer, iBuffer);
              End;
            End; { If (Result = 0) }
          Finally
            Free;
          End;

        // Check for licence expiry
        If (Result = 0) Then
          If (FLicence.dlrLicenceExpiry <> -1) And ((FLicence.dlrLicenceExpiry + 1) < Now) Then Begin
            FLicence.dlrLicenceExpiry := -1;
            Save (LicencePath);
          End; { If (FExpiry + 1 < Now)  }
      End; { If (Result = 0) }
    Finally
      Dispose (Licence);
    End;
  Except
    On E:Exception Do Begin
      Result := 1001;
    End; { On }
  End;
end;

//----------------------------------------------------------------------------

function TDistributorLicence.Save(const LicencePath: ShortString): LongInt;
Var
  MemBuffer              : Pointer;
  MemBufferLen           : LongInt;
  Licence                : ^DistributorLicenceRecType;
  LicenceRecLen          : LongInt;
  FileStream             : TFileStream;
  StartTime              : DWord;
  sBuffer                : ShortString;
  iBuffer                : SmallInt;
begin
  Result := 0;

  Try
    // Calculate required size of storage space aand allocate the required memory
    LicenceRecLen := SizeOf(Licence^);
    GetMem (Licence, LicenceRecLen);
    Try
      // Setup the data structrue
      Licence^ := FLicence;

      // Encrypt the licence Details
      EncodeDataKey (17382, Licence, LicenceRecLen);

      // Create the file stream for writing the licence file - may get error if locked for writing
      FileStream := NIL;
      StartTime := GetTickCount;
      Repeat
        Try
          FileStream := TFileStream.Create (LicencePath + DistLicenceFName, fmCreate Or fmShareExclusive);
        Except
          On Exception Do Begin
            // Remove reference to the dud FileStream
            FileStream := NIL;

            // File Open Error - probably locked by another app writing to it
            If ((GetTickCount - StartTime) > 10000) Then
              // 10 seconds elapsed-  time out and return an error
              Result := 2003;

            // Wait a while to see if the problem will go away
            Application.ProcessMessages;
            Sleep(50);
          End; { On Exception  }
        End; { Except }
      Until (Result <> 0) Or Assigned(FileStream);

      If (Result = 0) Then
        // Write the licence file
        With FileStream Do
          Try
            // Licence Header --------------------------------------------------------

            // File Signature (Uncompressed)
            SBuffer := StartSigByte;
            Write(sBuffer[1], Length(sBuffer));

            // File Version 2.0 (Uncompressed)
            Write(FMajorVersion, 1);
            Write(FMinorVersion, 1);

            // Licence Creation Date/Time stamp
            FTimeStamp := Now;
            Write(FTimeStamp, SizeOf(FTimeStamp));

            // Licencee Details  -----------------------------------------------------

            CompressBuf(Licence,          // InBuffer for compression
                        LicenceRecLen,    // Size of InBuffer
                        MemBuffer,        // Memory Buffer to receive compressed data
                        MemBufferLen);    // Size of Compress Data returned in Memory Buffer

            // File Checksum
            FCheckSum := CalcBufferCheckSum(MemBuffer, MemBufferLen);
            Write(FCheckSum, SizeOf(FCheckSum));

            // Write Licencee Details  -----------------------------------------------

            // Write out the size of the compressed licencing details
            iBuffer := MemBufferLen;
            Write (iBuffer, SizeOf (iBuffer));

            // Write out the compressed licencing details
            Write(MemBuffer^, MemBufferLen);

            Result := 0;
          Finally
            FileStream.Free;
          End;

      If (FFileStamp > -1) Then
        // Restore the original File Date/Time stamp from when the file was read
        FileSetDate(LicencePath + DistLicenceFName, DateTimeToFileDate(FFileStamp));
    Finally
      FreeMem (Licence, LicenceRecLen);
    End;
  Except
    On E:Exception Do Begin
      Result := 1001;
    End; { On }
  End;
end;

//----------------------------------------------------------------------------

Function TDistributorLicence.Expired : Boolean;
Begin { Expired }
  Result := (dlLicenceExpiry = -1);
End; { Expired }

//---------------------------------------------------------------------------

end.
