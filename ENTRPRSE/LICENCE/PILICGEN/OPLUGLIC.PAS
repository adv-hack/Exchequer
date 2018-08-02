unit oPlugLic;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  TPlugInDetailLicenceType = Class(TObject)
  Private
    FpiCode    : ShortString;   // Plug-In ID Code
    FpiName    : ShortString;   // Plug-in Description
    FpiExpiry  : TDateTime;

    Fpi30Day   : LongInt;       // Number of 30-Day System Relcodes given
    FpiFull    : LongInt;       // Number of Full System Relcodes given
    FpiUCount  : LongInt;       // Number of User Count Relcodes given
    FpiUCTotal : LongInt;       // Total Number of User released

    function GetpiNumber: LongInt;     // Licence Expiry Date
  Protected
  Public
    Property piCode : ShortString Read FpiCode Write FpiCode;
    Property piName : ShortString Read FpiName Write FpiName;
    Property piExpiry : TDateTime Read FpiExpiry Write FpiExpiry;
    Property piNumber : LongInt read GetpiNumber;

    Property pi30Day : LongInt Read Fpi30Day Write Fpi30Day;
    Property piFull : LongInt Read FpiFull Write FpiFull;
    Property piUCount : LongInt Read FpiUCount Write FpiUCount;
    Property piUCTotal : LongInt Read FpiUCTotal Write FpiUCTotal;

    Constructor Create (Const PlugInCode, PlugInName : ShortString; Const PlugInExpiry : TDateTime);
    Destructor Destroy; Override;
    Function Expired : Boolean;
  End; { TPlugInDetailLicenceType }

  TPlugInUtilityLicenceType = Class(TObject)
  Private
    FExceptMsg : ShortString;
    FExpiry    : TDateTime;
    FLicencee  : ShortString;
    FPlugIns   : TList;
    FTimeStamp : TDateTime;
    FFileStamp : TDateTime;

    FMajorVersion  : Byte;
    FMinorVersion  : Byte;

    FCheckSum  : Byte;
    FSuppressExpiryWarnings : Boolean;

    function GetPlugInCount: SmallInt;
    function GetPlugIn(Index: Integer): TPlugInDetailLicenceType;
  Protected
    Function CalcBufferCheckSum (Const MemBuffer : Pointer; Const MemBufferLen : LongInt) : Byte;
    Procedure InitLicencing;
    Procedure SetDefaultVersion;
  Public
    Property CheckSum : Byte Read FChecksum Write FCheckSum;
    Property ExceptMsg : ShortString Read FExceptMsg;
    Property Expiry : TDateTime Read FExpiry Write FExpiry;
    Property FileStamp : TDateTime Read FFileStamp Write FFileStamp;
    Property Licencee : ShortString Read fLicencee Write FLicencee;
    Property MajorVersion : Byte Read FMajorVersion Write FMajorVersion;
    Property MinorVersion : Byte Read FMinorVersion Write FMinorVersion;
    Property PlugIn [Index : LongInt] : TPlugInDetailLicenceType Read GetPlugIn;
    Property PlugInCount : SmallInt Read GetPlugInCount;
    Property SuppressExpiryWarnings : Boolean Read FSuppressExpiryWarnings Write FSuppressExpiryWarnings;
    Property TimeStamp : TDateTime Read FTimeStamp Write FTimeStamp;

    Constructor Create (Const SuppressExpiryWarnings : Boolean = False);
    Destructor Destroy; Override;

    Procedure AddPlugIn (Const PlugInCode    : ShortString;
                         Const PlugInName    : ShortString;
                         Const PlugInExpiry  : TDateTime;
                         Const PlugIn30Day   : LongInt = 0;
                         Const PlugInFull    : LongInt = 0;
                         Const PlugInUCount  : LongInt = 0;
                         Const PlugInUCTotal : LongInt = 0);

    Function Expired : Boolean;
    Function Open (Const LicenceName : ShortString; Const CheckExpiry : Boolean) : LongInt;
    Function Save (Const LicenceName : ShortString) : LongInt;
  End; { TPlugInUtilityLicenceType }

implementation

Uses ZLib;

Const
  StartSigByte : ShortString = #255#254#253#254#255#254#253#254#255;

Type
  LicenceDetsType = Record
    LicenceeName    : String[45];
    LicenceExpiry   : TDateTime;
    LicencedPlugIns : LongInt;
  End; { LicenceDetsType }

  // structure to store an individual Plug-In
  PlugInRecType = Record
    PlugInCode      : String[16];
    PlugInName      : String[100];
    PlugInExpiry    : TDateTime;

    // Release Code stats
    PlugIn30Day     : LongInt;        // Number of 30-Day System Relcodes given
    PlugInFull      : LongInt;        // Number of Full System Relcodes given
    PlugInUCount    : LongInt;        // Number of User Count Relcodes given
    PlugInUCTotal   : LongInt;        // Total Number of User released
  End; { PlugInRecType }

  CompressType = Record
    LicenceeDets  : LicenceDetsType;
    PlugInList    : Array [0..299] Of PlugInRecType;
  End; { CompressType }

//---------------------------------------------------------------------------

Constructor TPlugInDetailLicenceType.Create (Const PlugInCode, PlugInName : ShortString;
                                             Const PlugInExpiry           : TDateTime);
Begin { Create }
  Inherited Create;

  FpiCode   := PlugInCode;
  FpiName   := PlugInName;
  FpiExpiry := PlugInExpiry;

  Fpi30Day   := 0;       // Number of 30-Day System Relcodes given
  FpiFull    := 0;       // Number of Full System Relcodes given
  FpiUCount  := 0;       // Number of User Count Relcodes given
  FpiUCTotal := 0;       // Total Number of User released
End; { Create }

//---------------------------------------

Destructor TPlugInDetailLicenceType.Destroy;
Begin { Destroy }

  inherited;
End; { Destroy }

//---------------------------------------

Function TPlugInDetailLicenceType.GetpiNumber: LongInt;
Begin { GetpiNumber }
  Result := StrToInt (Copy (FpiCode, 11, 6));
End; { GetpiNumber }

//---------------------------------------

Function TPlugInDetailLicenceType.Expired : Boolean;
Begin { Expired }
  Result := (piExpiry = -1);
End; { Expired }

//---------------------------------------------------------------------------

Constructor TPlugInUtilityLicenceType.Create (Const SuppressExpiryWarnings : Boolean = False);
Begin { Create }
  Inherited Create;

  FSuppressExpiryWarnings := SuppressExpiryWarnings;

  FPlugIns := TList.Create;

  // Initialise the internal variables
  InitLicencing;
End; { Create }

//---------------------------------------

Destructor TPlugInUtilityLicenceType.Destroy;
Begin { Destroy }
  // Remove any Plug-Ins loaded
  InitLicencing;

  // destroy the Plug-Ins list
  FreeAndNIL (FPlugIns);

  inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TPlugInUtilityLicenceType.InitLicencing;
Begin { InitLicencing }
  FExceptMsg := '';

  FLicencee  := '';
  FExpiry    := -1.0;
  FTimeStamp := -1.0;
  FCheckSum  := 0;
  FFileStamp := -1.0;

  SetDefaultVersion;

  // Remove any Plug-Ins loaded within the list
  If Assigned(FPlugIns) Then
    While (FPlugIns.Count > 0) Do Begin
      TPlugInDetailLicenceType(FPlugIns.Items[0]).Free;
      FPlugIns.Delete(0);
    End; { While (FPlugIns.Count > 0) }
End; { InitLicencing }

//---------------------------------------------------------------------------

// Default Licence File Version
Procedure TPlugInUtilityLicenceType.SetDefaultVersion;
Begin { SetDefaultVersion }
  FMajorVersion := 1;
  FMinorVersion := 0;
End; { SetDefaultVersion }

//---------------------------------------------------------------------------

function TPlugInUtilityLicenceType.GetPlugInCount: SmallInt;
begin
  Result := FPlugIns.Count;
end;

//---------------------------------------

function TPlugInUtilityLicenceType.GetPlugIn(Index: Integer): TPlugInDetailLicenceType;
begin
  Result := TPlugInDetailLicenceType(FPlugIns.Items[Index]);
end;

//---------------------------------------

Procedure TPlugInUtilityLicenceType.AddPlugIn (Const PlugInCode    : ShortString;
                                               Const PlugInName    : ShortString;
                                               Const PlugInExpiry  : TDateTime;
                                               Const PlugIn30Day   : LongInt = 0;
                                               Const PlugInFull    : LongInt = 0;
                                               Const PlugInUCount  : LongInt = 0;
                                               Const PlugInUCTotal : LongInt = 0);
Var
  oPlugIn    : TPlugInDetailLicenceType;
Begin { AddPlugIn }
  // Create an Plug-In sub-object
  oPlugIn := TPlugInDetailLicenceType.Create(PlugInCode, PlugInName, PlugInExpiry);
  With oPlugIn Do Begin
    pi30Day   := PlugIn30Day;
    piFull    := PlugInFull;
    piUCount  := PlugInUCount;
    piUCTotal := PlugInUCTotal;
  End; { With oPlugIn }

  // Add it into the Plug-Ins List
  FPlugIns.Add(oPlugIn);
End; { AddPlugIn }

//---------------------------------------------------------------------------

Function TPlugInUtilityLicenceType.CalcBufferCheckSum (Const MemBuffer : Pointer; Const MemBufferLen : LongInt) : Byte;
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
      Raise Exception.Create ('TPlugInUtilityLicenceType.CalcBufferCheckSum - Buffer too large');
End; { CalcBufferCheckSum }

//---------------------------------------------------------------------------

// Return Values:-
//
//  0      AOK
//  1000   Unknown Error
//  1001   Unknown Exception
//  2001   File Signature Invalid
//  2002   Checksum mismatch
//  2003   Licence File Locked
Function TPlugInUtilityLicenceType.Open (Const LicenceName : ShortString; Const CheckExpiry : Boolean) : LongInt;
Var
  MemBuffer      : Pointer;
  Licence        : ^CompressType;
  LicenceLen     : LongInt;
  sBuffer        : ShortString;
  iBuffer, I     : SmallInt;
  CheckByte      : Byte;
  NeedUpdate     : Boolean;
  FileStream     : TFileStream;
  StartTime      : DWord;
Begin { Open }
  Result := 0;

  // Clear out any pre-existing licencing information
  InitLicencing;

  Try
    // Allocate memory for compression buffering
    LicenceLen := SizeOf (CompressType);
    New (Licence);
    Try
      // Read Date/Time stamp of file
      FFileStamp := FileDateToDateTime(FileAge(LicenceName));

      // Create the input stream for reading the licence file - may get error if locked for writing
      FileStream := NIL;
      StartTime := GetTickCount;
      Repeat
        Try
          FileStream := TFileStream.Create (LicenceName, fmOpenRead or fmShareDenyNone);
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
                                      Licence,         // OutputBuffer receiving uncompressed data
                                      LicenceLen);      // Bytes placed into OutputBuffer
              Finally
                FreeMem (MemBuffer, iBuffer);
              End;

              // Copy the details out of the uncompressed Licencing structure
              If (Result = 0) Then
                With Licence^ Do Begin
                  FLicencee := LicenceeDets.LicenceeName;
                  FExpiry := LicenceeDets.LicenceExpiry;

                  If (LicenceeDets.LicencedPlugIns > 0) Then
                    For I := 0 To Pred(LicenceeDets.LicencedPlugIns) Do
                      With PlugInList[I] Do
                        AddPlugIn (PlugInCode, PlugInName, PlugInExpiry, PlugIn30Day, PlugInFull, PlugInUCount, PlugInUCTotal);
                End; { With Licence }
            End; { If (Result = 0) }
          Finally
            Free;
          End;

          If (Result = 0) And CheckExpiry Then Begin
            NeedUpdate := False;

            // Check main Licence Expiry
            If (FExpiry <> -1) And ((FExpiry + 1) < Now) Then Begin
              FExpiry := -1;
              NeedUpdate := True;
            End; { If (FExpiry + 1 < Now)  }

            // Check Individual Plug-In Expiry Dates
            If (FPlugIns.Count > 0) Then
              For I := 0 To Pred(FPlugIns.Count) Do
                With PlugIn[I] Do Begin
                  // Check the Plug-In hasn't already expired
                  If (piExpiry <> -1) Then Begin
                    If ((piExpiry + 1) < Now) Then Begin
                      // Expired
                      NeedUpdate := True;
                      piExpiry := -1;

                      If (Not FSuppressExpiryWarnings) Then
                        MessageDlg ('The Licence for the ' + piCode + ' Plug-In has expired.'#13#13'Please contact your Technical Support Helpline', mtInformation, [mbOk], 0);
                    End { If ((piExpiry + 1) < Now) }
                    Else
                      // check to see if it is going to expire shortly
                      If (Not FSuppressExpiryWarnings) And (piExpiry < (Now + 6)) Then
                        MessageDlg ('Your Licence for the ' + piCode + ' Plug-In expires on the ' + FormatDateTime('DD/MM/YYYY', piExpiry) +
                              ', please contact your Technical Support Helpline for a new licence as soon as possible.', mtWarning, [mbOk], 0);
                  End; { If (piExpiry <> -1)  }
              End; { With PlugIn[I], PlugInList[I] }

            If NeedUpdate Then
              Save (LicenceName);
          End; { If Result And CheckExpiry }
      End; { If (Result = 0) }
    Finally
      Dispose (Licence);
    End;
  Except
    On E:Exception Do Begin
      Result := 1001;
      FExceptMsg := E.Message;
    End; { On }
  End;
End; { Open }

//---------------------------------------------------------------------------

// Return Values:-
//
//  0      AOK
//  1000   Unknown Error
//  1001   Unknown Exception
//  2003   Licence File Locked
Function TPlugInUtilityLicenceType.Save (Const LicenceName : ShortString) : LongInt;
Var
  MemBuffer              : Pointer;
  MemBufferLen           : LongInt;
  Licence                : ^CompressType;
  LicenceRecLen          : LongInt;
  sBuffer                : ShortString;
  iBuffer, I             : SmallInt;
  FileStream             : TFileStream;
  StartTime              : DWord;
Begin { Save }
  Result := 0;

  Try
    // Calculate required size of storage space aand allocate the required memory
    LicenceRecLen := SizeOf(LicenceDetsType) + (FPlugIns.Count * SizeOf(PlugInRecType));
    GetMem (Licence, LicenceRecLen);
    Try
      // Setup the data structrue
      FillChar (Licence^, LicenceRecLen, #0);
      With Licence^ Do Begin
        // Licencee Details
        With LicenceeDets Do Begin
          LicenceeName    := FLicencee;
          LicenceExpiry   := FExpiry;
          LicencedPlugIns := FPlugIns.Count;
        End; { With LicenceeDets }

        // Plug-In Details
        If (FPlugIns.Count > 0) Then
          For I := 0 To Pred(FPlugIns.Count) Do
            With PlugIn[I], PlugInList[I] Do Begin
              PlugInCode   := piCode;
              PlugInName   := piName;
              PlugInExpiry := piExpiry;

              PlugIn30Day   := pi30Day;
              PlugInFull    := piFull;
              PlugInUCount  := piUCount;
              PlugInUCTotal := piUCTotal;
            End; { With PlugIn[I], PlugInList[I] }
      End; { With Licence^ }

      // Create the input stream for reading the licence file - may get error if locked for writing
      FileStream := NIL;
      StartTime := GetTickCount;
      Repeat
        Try
          FileStream := TFileStream.Create (LicenceName, fmCreate Or fmShareExclusive);
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
        // Read the licencing details
        With FileStream Do
          Try
            // Licence Header --------------------------------------------------------

            // File Signature (Uncompressed)
            SBuffer := StartSigByte;
            Write(sBuffer[1], Length(sBuffer));

            // File Version 1.0 (Uncompressed)
            SetDefaultVersion;
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
        FileSetDate(LicenceName, DateTimeToFileDate(FFileStamp));
    Finally
      FreeMem (Licence, LicenceRecLen);
    End;
  Except
    On E:Exception Do Begin
      Result := 1001;
      FExceptMsg := E.Message;
    End; { On }
  End;
End; { Save }

//---------------------------------------------------------------------------

Function TPlugInUtilityLicenceType.Expired : Boolean;
Begin { Expired }
  Result := (Expiry = -1);
End; { Expired }

//---------------------------------------------------------------------------

//Initialization
  //ShowMessage('CompressType: ' + IntToStr(SizeOf(CompressType)));
  //ShowMessage (FloatToStr(Now));
end.
