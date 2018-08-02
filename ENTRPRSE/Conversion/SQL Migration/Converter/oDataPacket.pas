Unit oDataPacket;

Interface

Uses oConvertOptions;

Type
  // TDataPacket is a storage object for the data queued against a SQL Write Thread
  TDataPacket = Class(TObject)
  Private
    FCompanyDetails : TConversionCompany;
    FTaskDetails : IDataConversionTask;
    FDataSize : Integer;
    FData : Pointer;

    FSourceSearchKey : ShortString;
    FSourcePosition : LongInt;
  Public
    Property CompanyDetails : TConversionCompany Read FCompanyDetails;
    Property TaskDetails : IDataConversionTask Read FTaskDetails;
    Property dpData : Pointer Read FData;
    Property dpDataSize : Integer Read FDataSize;

    Constructor Create (Const DataPacket : TDataPacket); Overload;
    Constructor Create (Const CompanyDetails : TConversionCompany;
                        Const TaskDetails : IDataConversionTask;
                        Const DataPointer : Pointer;
                        Const SourceSearchKey : ShortString;
                        Const SourcePosition : LongInt); Overload;
    Destructor Destroy; Override;

    // Dumps the DataPacket details to a file in the logs directory and returns the filename
    Function DumpToFile : ShortString;
  End; // TDataPacket

Implementation

Uses Classes, Forms, SysUtils, DateUtils, SyncObjs, APIUtil, SQLConvertUtils;

Var
  // Critical section is used bu the DumpToFile routine to avoid conflicts if
  // multiple threads need to have a dump simultaneously
  DumpCriticalSection : TCriticalSection;

//=========================================================================

Constructor TDataPacket.Create (Const DataPacket : TDataPacket);
Begin // Create
  Create (DataPacket.FCompanyDetails, DataPacket.FTaskDetails, DataPacket.FData, DataPacket.FSourceSearchKey, DataPacket.FSourcePosition);
End; // Create

//------------------------------

Constructor TDataPacket.Create (Const CompanyDetails : TConversionCompany;
                                Const TaskDetails : IDataConversionTask;
                                Const DataPointer : Pointer;
                                Const SourceSearchKey : ShortString;
                                Const SourcePosition : LongInt);
Begin // Create
  Inherited Create;

  // Store local references to the parent company and task for the data
  FCompanyDetails := CompanyDetails;
  FTaskDetails := TaskDetails;

  // Allocate memory to store the data - dctRecordLength uses a Critical Section
  // so minimise references by using a local reference
  FDataSize := TaskDetails.dctRecordLength;
  GetMem (FData, FDataSize);

  // Copy the data into local storage for later reference
  Move (DataPointer^, FData^, FDataSize);

  // Record source file position details
  FSourceSearchKey := SourceSearchKey;
  FSourcePosition := SourcePosition;
End; // Create

//------------------------------

Destructor TDataPacket.Destroy;
Begin // Destroy
  FreeMem (FData, FDataSize);
  FCompanyDetails := NIL;
  FTaskDetails := NIL;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Dumps the DataPacket details to a file in the logs directory and returns the filename
Function TDataPacket.DumpToFile : ShortString;
Var
  TimeoutTime : TDateTime;
  BoredNow : Boolean;
  sLogsDir, sFilename : ShortString;
Begin // DumpToFile
  Result := '';
  Try
    // Use a critical section to stop multiple threads creating dump files simultaneously
    DumpCriticalSection.Acquire;
    Try
      // Generate a unique filename in the Logs directory
      sLogsDir := ExtractFilePath(Application.ExeName) + 'Logs\';

      // Timeout after 10 seconds with no joy
      TimeoutTime := IncSecond(Now, 10);
      Repeat
        sFileName := 'DataPacket-' + FormatDateTime('yyyymmdd-hhnnsszzz', Now) + '.xml';
        BoredNow := (Now > TimeoutTime);
      Until Not FileExists(sFileName) Or BoredNow;

      If (Not BoredNow) Then
      Begin
        With TStringList.Create Do
        Begin
          Try
            // Write out the data packet details to an XML file in the following format:-
            //
            //   <DataPacketDump Date="19/07/2012" Time="11:02:34.625" Machine="L008743" User="MARKD6">
            //     <CompanyDetails Code="MAIN01" Path="C:\Exchequer\Exch70Conv\Companies\MAIN01\"/>
            //     <TaskDetails Description="CustSupp" Filename="Cust\CustSupp.Dat" />
            //     <DataPacket Position="123456" KeyString="0x167362537362" >
            //       <Data>0x000000000000000000000000000000000000000000000000000000000000000000000000000000</Data>
            //     </DataPacket>
            //   </DataPacketDump>
            //
            Add ('<DataPacketDump Date="' + FormatDateTime ('dd/mm/yyyy', Now) +
                               '" Time="' + FormatDateTime ('hh:nn:ss.zzz', Now) +
                               '" Machine="' + WinGetComputerName +
                               '" User="' + WinGetUserName + '">');
            With FCompanyDetails Do
              Add ('  <CompanyDetails Code="' + ccCompanyCode + '" Path="' + ccCompanyPath + '"/>');
            With FTaskDetails Do
              Add ('  <TaskDetails Description="' + dctTaskDescription + '" Filename="' + dctPervasiveFilename + '" />');
            Add ('  <DataPacket Position="' + IntToStr(FSourcePosition) + '" KeyString="' + ToHexString(@FSourceSearchKey, Length(FSourceSearchKey)) + '" >');
            Add ('    <Data>' + ToHexString(FData, FDataSize) + '</Data>');
            Add ('    <HumanReadableData>' + ToHumanReadableString (FData, FDataSize) + '</HumanReadableData>');
            Add ('  </DataPacket>');
            Add ('</DataPacketDump>');

            // Save it to the logs directory and return the filename so it can be record in the log entry
            SaveToFile (sLogsDir + sFilename);
            Result := sFilename;
          Finally
            Free;
          End; // Try..Finally
        End; // With TStringList.Create
      End // If (Not BoredNow)
      Else
        Result := 'Timeout creating Dump';
    Finally
      DumpCriticalSection.Release;
    End; // Try..Finally
  Except
    // This is typically called from within an Exception handler so handle the error
    // and return the description instead of the filename
    On E:Exception Do
      Result := E.Message;
  End; // Try..Finally
End; // DumpToFile

//=========================================================================

Initialization
  DumpCriticalSection := TCriticalSection.Create;
Finalization
  DumpCriticalSection.Free;
End.
