unit COMINTND;

interface

Uses Classes, Dialogs, SysUtils, Windows, Compress, EmailFax;

Type
{$IFNDEF ECOM}
  { Class to build PK-ZIP 2.04g Archive Files using ENTCOMMS.DLL }
  TEntZipND = Class(TObject)
  Private
    FDosPaths          : Boolean;
    FFiles             : TStringList;
    FOverwriteExisting : Boolean;
    FRecurse           : Boolean;
    FRemoveDots        : Boolean;
    FStripDrive        : Boolean;
    FStripPath         : Boolean;
    FZipName           : ShortString;
  Public
    Property DOSPaths : Boolean Read FDosPaths Write FDosPaths;
    Property Files : TStringList Read FFiles Write FFiles;
    Property OverwriteExisting : Boolean Read FOverwriteExisting Write FOverwriteExisting;
    Property Recurse : Boolean Read FRecurse Write FRecurse;
    Property RemoveDots : Boolean Read FRemoveDots Write FRemoveDots;
    Property StripDrive : Boolean Read FStripDrive Write FStripDrive;
    Property StripPath : Boolean Read FStripPath Write FStripPath;
    Property ZipName : ShortString Read FZipName Write FZipName;

    Constructor Create;
    Destructor Destroy; Override;

    { Stores .ZIP file - 0=OK, 1=no files to compress, 2=failed to delete existing .ZIP file }
    {                    3=DLL Not Found, }
    Function Save : SmallInt;
  End; { TEntZipND }

  TUnzipperND = Class(TObject)
  Private
    FZipFileName : shortString;
    FFiles : TStringList;
  Public
    Property Files : TStringList Read FFiles Write FFiles;
    Constructor Create(sZipFilename : shortstring);
    Destructor Destroy; Override;
    Function ExtractFiles(sMask, sDir : shortstring) : SmallInt;
  End; { TEntZipND }

  TEntEmailND = Class(TObject)
  Private
    FAttachments : TStringList;
    FBCC         : TStringList;
    FCC          : TStringList;
    FHeaders     : TStringList;
    FMessage     : PChar;
    FPriority    : Byte;
    FRecipients  : TStringList;
    FSender      : ShortString;
    FSenderName  : ShortString;
    FSMTPServer  : ShortString;
    FSubject     : ShortString;
    FUseMAPI     : Boolean;

    Procedure SetMessage(Value : PChar);
    Procedure SetPriority(Value : Byte);
  Public
    Property Attachments : TStringList Read FAttachments Write FAttachments;
    Property BCC : TStringList Read FBCC Write FBCC;
    Property CC : TStringList Read FCC Write FCC;
    Property Headers : TStringList Read FHeaders Write FHeaders;
    Property Message : PChar Read FMessage Write SetMessage;
    Property Priority : Byte Read FPriority Write SetPriority;
    Property Recipients : TStringList Read FRecipients Write FRecipients;
    Property Sender : ShortString Read FSender Write FSender;
    Property SenderName : ShortString Read FSenderName Write FSenderName;
    Property SMTPServer : ShortString Read FSMTPServer Write FSMTPServer;
    Property Subject : ShortString Read FSubject Write FSubject;
    Property UseMAPI : Boolean Read FUseMAPI Write FUseMAPI;

    Constructor Create;
    Destructor Destroy; Override;

    { Sends the email: 0=OK, 1=Error Sending MAPI Email, 3=DLL Not Found }
    Function Send : SmallInt;
  End; { TEntEmailND }

  Function MAPIAvailableND : Boolean;

{$ENDIF}

implementation
uses
  CommsInt;


{$IFNDEF ECOM}

  Constructor TEntZipND.Create;
  Begin { TEntZipND.Create }
    Inherited Create;

    FDosPaths          := False;
    FOverwriteExisting := False;
    FRecurse           := False;
    FRemoveDots        := True;
    FStripDrive        := True;
    FStripPath         := False;
    FZipName           := '';;

    FFiles := TStringList.Create;
  End; { TEntZipND.Create }

  Destructor TEntZipND.Destroy;
  Begin { TEntZipND.Destroy }
    FFiles.Clear;
    FFiles.Destroy;

    Inherited Destroy;
  End; { TEntZipND.Destroy }

  Function TEntZipND.Save : SmallInt;
//  Const
//    ResNames : Array[0..1] of PChar = ('ENTCOMMS', 'ECBUILDZIP');
  Var
//    _ecBuildZip  : Function (Const Info : CompressInfoType) : SmallInt; StdCall;
//    _MyGSRHandle : THandle;
//    DLLAddr      : TFarProc;
    Info         : CompressInfoType;
  Begin { TEntZipND.Save }
    Result := 3;

    { Load ENTCOMMS.DLL dynamically }
//    _MyGSRHandle := LoadLibrary(ResNames[0]);

//    Try
//      If (_MyGSRHandle > HInstance_Error) Then Begin
//        _ecBuildZip := GetProcAddress(_MyGSRHandle, ResNames[1]);

//        If Assigned(_ecBuildZip) then Begin
          FillChar(Info, SizeOf(Info), #0);
          With Info Do Begin
            coDOSPaths          := FDOSPaths;
            coFileList          := FFiles;
            coOverwriteExisting := FOverwriteExisting;
            coRecurse           := FRecurse;
            coRemoveDots        := FRemoveDots;
            coStripDrive        := FStripDrive;
            coStripPath         := FStripPath;
            coZipFile           := FZipName;
          End; { With }
          Result := ecBuildZip(Info);
//        End; { If }

        { Unload library }
//        FreeLibrary(_MyGSRHandle);
//        _MyGSRHandle:=0;
//      End; { If }
  //  Except
//      FreeLibrary(_MyGSRHandle);
//      _MyGSRHandle:=0;

//      _ecBuildZip := Nil;
//    End;
  End; { TEntZipND.Save }


  {----------------------------------------------------------------------------}


  Constructor TEntEmailND.Create;
  Begin { TEntEmailND.Create }
    Inherited Create;

    FAttachments := TStringList.Create;
    FBCC         := TStringList.Create;
    FCC          := TStringList.Create;
    FHeaders     := TStringList.Create;
    FMessage     := StrAlloc (10240);     // NOTE: Also update .SetMessage method

    StrPCopy(FMessage,'');

    FPriority    := 1;
    FRecipients  := TStringList.Create;
    FUseMAPI     := True;
  End; { TEntEmailND.Create }

  Destructor TEntEmailND.Destroy;
  Begin { TEntEmailND.Destroy }
    StrDispose(FMessage);
    FAttachments.Clear;     FAttachments.Destroy;
    FBCC.Clear;             FBCC.Destroy;
    FCC.Clear;              FCC.Destroy;
    FHeaders.Clear;         FHeaders.Destroy;
    FRecipients.Clear;      FRecipients.Destroy;

    Inherited Destroy;
  End; { TEntEmailND.Destroy }

  Procedure TEntEmailND.SetMessage (Value : PChar);
  Begin { TEntEmailND.SetMessage }
    StrLCopy (FMessage, Value, 10240);
  End; { TEntEmailND.SetMessage }

  Procedure TEntEmailND.SetPriority(Value : Byte);
  Begin { TEntEmailND.SetPriority }
    If (Value In [0..2]) Then Begin
      { Valid Priority }
      FPriority := Value;
    End { If }
    Else Begin
      FPriority := 1;
    End; { Else }
  End; { TEntEmailND.SetPriority }

  Function TEntEmailND.Send : SmallInt;
//  Const
//    ResNames : Array[0..1] of PChar = ('ENTCOMMS', 'ECSENDEMAIL');
  Var
//    _ecSendEmail  : Function (Const Info : EmailInfoType) : SmallInt; StdCall;
//    _MyGSRHandle : THandle;
//    DLLAddr      : TFarProc;
    Info         : EmailInfoType;
  Begin { TEntEmailND.Send }
    Result := 3;

    { Load ENTCOMMS.DLL dynamically }
//    _MyGSRHandle := LoadLibrary(ResNames[0]);

//    Try
//      If (_MyGSRHandle > HInstance_Error) Then Begin
//        _ecSendEmail := GetProcAddress(_MyGSRHandle, ResNames[1]);

//        If Assigned(_ecSendEmail) then Begin
          FillChar(Info, SizeOf(Info), #0);
          With Info Do Begin
            emSender       := FSender;
            emTo           := FRecipients;
            emCC           := FCC;
            emBCC          := FBCC;
            emSubject      := FSubject;
            emTextPChar    := FMessage;
            emAttachments  := FAttachments;
            emSMTPServer   := FSMTPServer;
            emSenderName   := FSenderName;
            emPriority     := FPriority;
            emHeaders      := FHeaders;

            emUseMAPI      := FUseMAPI;
          End; { With }

          Result := ecSendEmail(Info);
//        End; { If }

        { Unload library }
//        FreeLibrary(_MyGSRHandle);
//        _MyGSRHandle:=0;
//      End; { If }
//    Except
//      FreeLibrary(_MyGSRHandle);
//      _MyGSRHandle:=0;

//      _ecSendEmail := Nil;
//    End;
  End; { TEntEmailND.Send }

  { Returns True if MAP is installed and available }
  Function MAPIAvailableND : Boolean;
//  Const
//    ResNames : Array[0..1] of PChar = ('ENTCOMMS', 'ECMAPIAVAILABLE');
//  Var
//    _ecMapiAvailable : Function : WordBool; StdCall;
//    _MyGSRHandle     : THandle;
//    DLLAddr          : TFarProc;
  Begin { MAPIAvailable }
    Result := False;

    { Load ENTCOMMS.DLL dynamically }
//    _MyGSRHandle := LoadLibrary(ResNames[0]);

//    Try
//      If (_MyGSRHandle > HInstance_Error) Then Begin
//        _ecMapiAvailable := GetProcAddress(_MyGSRHandle, ResNames[1]);

//        If Assigned(_ecMapiAvailable) then Begin
          Result := ecMapiAvailable;
//        End; { If }

        { Unload library }
//        FreeLibrary(_MyGSRHandle);
//        _MyGSRHandle:=0;
//      End; { If }
//    Except
//      FreeLibrary(_MyGSRHandle);
//      _MyGSRHandle:=0;
//      _ecMapiAvailable := Nil;

//      Result := False;
//    End;
  End; { MAPIAvailable }

  Constructor TUnzipperND.Create(sZipFilename : shortstring);

    Procedure GetFileList;
//    var
//      _ecZipGetFileList  : function (sFileName : shortstring; var slFiles : TStringList) : SmallInt; StdCall;
//      _hEntCommsDLL : THandle;
    begin
      { Load ENTCOMMS.DLL dynamically }
//      _hEntCommsDLL := LoadLibrary('ENTCOMMS');
//      try
//        if (_hEntCommsDLL > HInstance_Error) then begin
//          _ecZipGetFileList := GetProcAddress(_hEntCommsDLL, 'ECZIPGETFILELIST');
//          if Assigned(_ecZipGetFileList) then
            ecZipGetFileList(FZipFileName, FFiles);

          { Unload library }
//          FreeLibrary(_hEntCommsDLL);
//          _hEntCommsDLL:=0;
//        end; { If }
//      except
//        FreeLibrary(_hEntCommsDLL);
//        _hEntCommsDLL:=0;
//        _ecZipGetFileList := nil;
//      end;
    end;{GetFileList}

  Begin {TUnzipperND.Create }
    Inherited Create;
    FZipFileName := sZipFilename;
    FFiles := TStringList.Create;
    GetFileList;
  End; {TUnzipperND.Create }

  Destructor TUnzipperND.Destroy;
  Begin {TUnzipperND.Destroy }
    FFiles.Free;
    Inherited Destroy;
  End; {TUnzipperND.Destroy }

  function TUnzipperND.ExtractFiles(sMask, sDir : shortstring) : SmallInt;
//  var
//    _ecExtractFiles  : function (sFileName, sMask, sDir : shortstring) : SmallInt; StdCall;
//    _hEntCommsDLL : THandle;
  begin
    Result := 0;
    { Load ENTCOMMS.DLL dynamically }
//    _hEntCommsDLL := LoadLibrary('ENTCOMMS');
//    try
//      if (_hEntCommsDLL > HInstance_Error) then begin
//        _ecExtractFiles := GetProcAddress(_hEntCommsDLL, 'ECEXTRACTFILES');
//        if Assigned(_ecExtractFiles) then Result :=
    ecExtractFiles(FZipFileName, sMask, sDir);

        { Unload library }
//        FreeLibrary(_hEntCommsDLL);
//        _hEntCommsDLL:=0;
//      end; { If }
//    except
//     FreeLibrary(_hEntCommsDLL);
//      _hEntCommsDLL:=0;
//      _ecExtractFiles := nil;
//    end;
  end;{TUnzipperND.UnzipFiles}

{$ENDIF}



end.

