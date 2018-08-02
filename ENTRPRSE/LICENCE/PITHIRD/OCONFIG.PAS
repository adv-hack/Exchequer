unit oConfig;

{$ALIGN 1}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  TPlugInConfiguration = Class(TObject)
  Private
    FpicCode            : ShortString;   // Plug-In ID Code

    FpicUsesSystem      : Boolean;        // Plug-In uses the System Release Code Security?
    FpicSystem30DayInst : LongInt;        // Number of 30-Day System Relcodes given
    FpicSystemFullInst  : LongInt;        // Number of Full System Relcodes given

    FpicUsesUserCount   : Boolean;        // Plug-In uses the User Count Release Code Security?
    FpicUserCountInst   : LongInt;        // Number of User Count Relcodes given
    FpicUserCountTotal  : LongInt;        // Total Number of User released
  Protected
  Public
    Property picCode : ShortString Read FpicCode Write FpicCode;
    Property picUsesSystem : Boolean Read FpicUsesSystem Write FpicUsesSystem;
    Property picSystem30DayInst : LongInt Read FpicSystem30DayInst Write FpicSystem30DayInst;
    Property picSystemFullInst : LongInt Read FpicSystemFullInst Write FpicSystemFullInst;
    Property picUsesUserCount : Boolean Read FpicUsesUserCount Write FpicUsesUserCount;
    Property picUserCountInst : LongInt Read FpicUserCountInst Write FpicUserCountInst;
    Property picUserCountTotal : LongInt Read FpicUserCountTotal Write FpicUserCountTotal;

    Constructor Create (Const PlugInCode : ShortString);
    Destructor Destroy; Override;
  End; { TPlugInConfiguration }

  // Plug-In Release Code Utility Configuration Object
  TPIRCUConfiguration = Class(TObject)
  Private
    FConfigName     : ShortString;
    FMasterPassword : ShortString;
    FShowCustDets   : Boolean;
    FUserPassword   : ShortString;

    FPlugIns   : TList;

    function GetPlugIn(Index: ShortString): TPlugInConfiguration;
  Protected
    Procedure InitConfiguration;
  Public
    Property cfgFileName : ShortString Read FConfigName;
    Property cfgMasterPW : ShortString Read FMasterPassword Write FMasterPassword;
    Property cfgPlugIns [Index : ShortString] : TPlugInConfiguration Read GetPlugIn;
    Property cfgShowCustDets : Boolean Read FShowCustDets Write FShowCustDets;
    Property cfgUserPW : ShortString Read FUserPassword Write FUserPassword;

    Constructor Create;
    Destructor Destroy; Override;

    Function OpenConfigFile (Const DispErrMsg : Boolean = False) : LongInt;
    Function SaveConfigFile (Const DispErrMsg : Boolean = False) : LongInt;
  End; { TPIRCUConfiguration }

Var
  oConfiguration : TPIRCUConfiguration;

implementation

Uses ZLib;

Const
  StartSigByte : ShortString = #127#126#125#126#127#126#125#126#127;

Type
  ConfigDetsType = Record
    // Passwords for access control
    UserPW        : String[8];           // Basic Password - 30-Day system codes only
    MasterPW      : String[8];           // Master Password - no limitations

    // system switches
    ShowCustDets  : Boolean;             // Show Customer Details section?

    // Number of Plug-Ins defined in configuration file
    PlugInCount   : LongInt;

    // Spare for future use
    Spare         : Array [1..200] Of Byte;
  End; { ConfigDetsType }

  // structure to store an individual Plug-Ins configuration details
  PlugInRecType = Record
    PlugInCode      : String[16];

    UsesSystem      : Boolean;        // Plug-In uses the System Release Code Security?
    System30DayInst : LongInt;        // Number of 30-Day System Relcodes given
    SystemFullInst  : LongInt;        // Number of Full System Relcodes given

    UsesUserCount   : Boolean;        // Plug-In uses the User Count Release Code Security?
    UserCountInst   : LongInt;        // Number of User Count Relcodes given
    UserCountTotal  : LongInt;        // Total Number of User released

    // Spare for future use
    Spare           : Array [1..100] Of Byte;
  End; { PlugInRecType }

  // main structure with general settings and list of Plug-In specific configuration details
  CompressType = Record
    ConfigDets    : ConfigDetsType;
    PlugInList    : Array [0..299] Of PlugInRecType;
  End; { CompressType }


//---------------------------------------------------------------------------

Constructor TPlugInConfiguration.Create(const PlugInCode: ShortString);
Begin { Create }
  Inherited Create;

  FpicCode            := UpperCase(Trim(PlugInCode));
  FpicUsesSystem      := True;
  FpicSystem30DayInst := 0;
  FpicSystemFullInst  := 0;
  FpicUsesUserCount   := True;
  FpicUserCountInst   := 0;
  FpicUserCountTotal  := 0;
End; { Create }

//---------------------------------------

Destructor TPlugInConfiguration.Destroy;
Begin { Destroy }

  inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Constructor TPIRCUConfiguration.Create;
Begin { Create }
  Inherited Create;

  // Create the internal list to store the Plug-in details
  FPlugIns := TList.Create;

  InitConfiguration;

  // generate filename of configuration file
  FConfigName := ChangeFileExt(Application.ExeName, '.OPT');

  // open the configuration file and load the current settings
  OpenConfigFile;
End; { Create }

//---------------------------------------

Destructor TPIRCUConfiguration.Destroy;
Begin { Destroy }
  // Remove any Plug-In details in the list
  InitConfiguration;

  // destroy the Plug-Ins list
  FreeAndNIL (FPlugIns);

  inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TPIRCUConfiguration.InitConfiguration;
Begin { InitLicencing }
  FShowCustDets   := True;
  FMasterPassword := '';
  FUserPassword   := '';

  // Remove any Plug-Ins loaded within the list
  If Assigned(FPlugIns) Then
    While (FPlugIns.Count > 0) Do Begin
      TPlugInConfiguration(FPlugIns.Items[0]).Free;
      FPlugIns.Delete(0);
    End; { While (FPlugIns.Count > 0) }
End; { InitLicencing }

//---------------------------------------------------------------------------

Function TPIRCUConfiguration.GetPlugIn(Index: ShortString): TPlugInConfiguration;
Var
  I : LongInt;
Begin { GetPlugIn }
  Result := NIL;

  // Find the Plug-In in the list and return the details
  If (FPlugIns.Count > 0) Then
    For I := 0 To Pred(FPlugIns.Count) Do
      With TPlugInConfiguration(FPlugIns.Items[I]) Do
        If (picCode = UpperCase(Trim(Index))) Then Begin
          Result := TPlugInConfiguration(FPlugIns.Items[I]);
          Break;
        End; { If (picCode = UpperCase(Trim(Index))) }

  If (Not Assigned(Result)) Then Begin
    // Plug-In not found - create new entry and return the details
    Result := TPlugInConfiguration.Create (Index);
    FPlugIns.Add (Result);
  End; { If (Not Assigned(Result)) }
End; { GetPlugIn }

//---------------------------------------------------------------------------

Function TPIRCUConfiguration.OpenConfigFile (Const DispErrMsg : Boolean = False) : LongInt;
Var
  MemBuffer      : Pointer;
  Config         : ^CompressType;
  ConfigLen      : LongInt;
  FileStream     : TFileStream;
  StartTime      : DWord;
  sBuffer        : ShortString;
  iBuffer, I     : SmallInt;
  oPlugIn        : TPlugInConfiguration;
  ErrMsg         : ShortString;
Begin { OpenConfigFile }
  Result := 0;

  // setup default configuration - removing any pre-existing Plug-In details
  InitConfiguration;

  // Check for existing configuration file
  If FileExists (FConfigName) Then Begin
    Try
      // Allocate memory for compression buffering
      ConfigLen := SizeOf (CompressType);
      New (Config);
      Try
        // Create the input stream for reading the licence file - may get error if locked for writing
        FileStream := NIL;
        StartTime := GetTickCount;
        Repeat
          Try
            FileStream := TFileStream.Create (FConfigName, fmOpenRead or fmShareDenyNone);
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
              // File Header --------------------------------------------------------

              // File Signature (Uncompressed)
              SetLength(sBuffer,9);
              Read (sBuffer[1], Length(sBuffer));
              If (sBuffer <> StartSigByte) Then
                Result := 2001;

              // Configuration Details  -----------------------------------------------------
              If (Result = 0) Then Begin
                // Extract Length of compressed Licencing Details buffer
                Read (iBuffer, SizeOf (iBuffer));

                GetMem (MemBuffer, iBuffer);
                Try
                  // Copy the compressed section into the Memory buffer for decompression
                  Read (MemBuffer^, iBuffer);

                  // Decompress the Memory Buffer into the original structure
                  DecompressToUserBuf(MemBuffer,        // InBuffer containing compressed data
                                      iBuffer,          // Size of In Buffer
                                      Config,           // OutputBuffer receiving uncompressed data
                                      ConfigLen);       // Bytes placed into OutputBuffer
                Finally
                  FreeMem (MemBuffer, iBuffer);
                End;

                // Copy the details out of the uncompressed Licencing structure
                FShowCustDets   := Config^.ConfigDets.ShowCustDets;
                FMasterPassword := Config^.ConfigDets.MasterPW;
                FUserPassword   := Config^.ConfigDets.UserPW;

                If (Config^.ConfigDets.PlugInCount > 0) Then
                  For I := 0 To Pred(Config^.ConfigDets.PlugInCount) Do
                    With Config^.PlugInList[I] Do Begin
                      // Create an Plug-In sub-object
                      oPlugIn := TPlugInConfiguration.Create(PlugInCode);
                      With oPlugIn Do Begin
                        picUsesSystem      := UsesSystem;
                        picSystem30DayInst := System30DayInst;
                        picSystemFullInst  := SystemFullInst;

                        picUsesUserCount   := UsesUserCount;
                        picUserCountInst   := UserCountInst;
                        picUserCountTotal  := UserCountTotal;
                      End; { With oPlugIn }

                      // Add it into the Plug-Ins List
                      FPlugIns.Add(oPlugIn);
                    End; { With PlugInList[I] }
              End; { If (Result = 0) }
            Finally
              FileStream.Destroy;
            End;
        End; { If (Result = 0) }
      Finally
        Dispose (Config);
      End;
    Except
      On E:Exception Do
        Result := 1001;
    End;

    If DispErrMsg And (Result <> 0) Then Begin
      Case Result Of
        //0      AOK
        1000 : ErrMsg := 'Unknown Error';
        1001 : ErrMsg := 'Unknown Exception';
        2001 : ErrMsg := 'File Signature Invalid';
        2003 : ErrMsg := 'Licence File Locked';
      Else
        ErrMsg := 'Unknown Error ' + IntToStr(Result);
      End; { Case Result }

      MessageDlg ('The following error occurred whilst reading the Enterprise Plug-In Release Code Utility configuration file:-' + #13#13 +
                  QuotedStr(ErrMsg) + #13#13 + 'Please contact your Technical Support',mtError, [mbOk], 0);
    End; { If DispErrMsg }
  End { If FileExists }
  Else Begin
    // No configuration file - Chcek for command line switch allowing the file to be created
    If FindCmdLineSwitch('CRCFG', ['/', '-', '\'], True) Then
      //save default configuration
      SaveConfigFile
    Else Begin
      MessageDlg ('The application configuration file is missing and the program cannot be started correctly.'#13#13'Please contact your Technical Support Helpline.', mtError, [mbOk], 0);
      Application.Terminate;
    End; { Else }
  End; { Else }
End; { OpenConfigFile }

//---------------------------------------------------------------------------

// Return Values:-
//
//  0      AOK
//  1000   Unknown Error
//  1001   Unknown Exception
//
Function TPIRCUConfiguration.SaveConfigFile (Const DispErrMsg : Boolean = False) : LongInt;
Var
  MemBuffer              : Pointer;
  MemBufferLen           : LongInt;
  Config                 : ^CompressType;
  ConfigRecLen           : LongInt;
  sBuffer                : ShortString;
  iBuffer, I             : SmallInt;
  FileStream             : TFileStream;
  StartTime              : DWord;
  ErrMsg                 : ShortString;
Begin { SaveConfigFile }
  Result := 0;

  Try
    // Calculate required size of storage space aand allocate the required memory
    ConfigRecLen := SizeOf(ConfigDetsType) + (FPlugIns.Count * SizeOf(PlugInRecType));
    GetMem (Config, ConfigRecLen);
    Try
      // Setup the data structrue
      FillChar (Config^, ConfigRecLen, #0);
      With Config^ Do Begin
        // Licencee Details
        With ConfigDets Do Begin
          ShowCustDets := FShowCustDets;
          MasterPW     := FMasterPassword;
          UserPW       := FUserPassword;
          PlugInCount  := FPlugIns.Count;
        End; { With ConfigDets }

        // Plug-In Details
        If (FPlugIns.Count > 0) Then
          For I := 0 To Pred(FPlugIns.Count) Do
            With PlugInList[I], TPlugInConfiguration(FPlugIns.Items[I]) Do Begin
              PlugInCode      := picCode;

              UsesSystem      := picUsesSystem;
              System30DayInst := picSystem30DayInst;
              SystemFullInst  := picSystemFullInst;

              UsesUserCount   := picUsesUserCount;
              UserCountInst   := picUserCountInst;
              UserCountTotal  := picUserCountTotal;
            End; { With PlugInList[I], TPlugInConfiguration(FPlugIns.Items[I])}
      End; { With Licence^ }

      // Create the input stream for reading the licence file - may get error if locked for writing
      FileStream := NIL;
      StartTime := GetTickCount;
      Repeat
        Try
          FileStream := TFileStream.Create (FConfigName, fmCreate Or fmShareExclusive);
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

            // Licencee Details  -----------------------------------------------------

            CompressBuf(Config,           // InBuffer for compression
                        ConfigRecLen,     // Size of InBuffer
                        MemBuffer,        // Memory Buffer to receive compressed data
                        MemBufferLen);    // Size of Compress Data returned in Memory Buffer

            // Write Licencee Details  -----------------------------------------------

            // Write out the size of the compressed licencing details
            iBuffer := MemBufferLen;
            Write (iBuffer, SizeOf (iBuffer));

            // Write out the compressed licencing details
            Write(MemBuffer^, MemBufferLen);

            Result := 0;
          Finally
            FileStream.Destroy;
          End;
    Finally
      FreeMem (Config, ConfigRecLen);
    End;
  Except
    On Exception Do
      Result := 1001;
  End;

  If DispErrMsg And (Result <> 0) Then Begin
    Case Result Of
      //0      AOK
      1000 : ErrMsg := 'Unknown Error';
      1001 : ErrMsg := 'Unknown Exception';
      2003 : ErrMsg := 'Licence File Locked';
    Else
      ErrMsg := 'Unknown Error ' + IntToStr(Result);
    End; { Case Result }

    MessageDlg ('The following error occurred whilst reading the Enterprise Plug-In Release Code Utility configuration file:-' + #13#13 +
                QuotedStr(ErrMsg) + #13#13 + 'Please contact your Technical Support',mtError, [mbOk], 0);
  End; { If DispErrMsg }
End; { SaveConfigFile }

//---------------------------------------------------------------------------

Initialization
  oConfiguration := TPIRCUConfiguration.Create;
Finalization
  FreeAndNIL (oConfiguration);
end.
