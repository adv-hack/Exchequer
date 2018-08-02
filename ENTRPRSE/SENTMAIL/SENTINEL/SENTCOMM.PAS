unit SentComm;

{ prutherford440 10:08 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, SysUtils, Windows;

Type
  { Structure passed into PK-ZIP function in ENTCOMMS.DLL}
(*  CompressInfoType = Record
    coDOSPaths          : Boolean;      { Store as DOS 8.3 format filenames }
    coFileList          : TStrings;     { Files to compress }
    coOverwriteExisting : Boolean;      { Delete any pre-existing .ZIP file }
    coRecurse           : Boolean;      { Recurse Subdirectories }
    coRemoveDots        : Boolean;      { Remove '..\' from stored filenames }
    coStripDrive        : Boolean;      { Strip Drive from stored filenames }
    coStripPath         : Boolean;      { Strip path from stored filenames }
    coZipFile           : String[255];  { Destination ZIP file }

    coSpare             : Array [1..200] Of Byte;
  End; { CompressInfoType }*)

  { Structure passed into Email function in ENTCOMMS.DLL }
(*  EmailInfoType = Record
    emSender       : String[255];             { From Email Address }
    emTo           : TStrings;                { To Address List }
    emCC           : TStrings;                { CC Address List }
    emBCC          : TStrings;                { Blank CC Address List }
    emSubject      : String[255];             { Subject }
    emTextPChar    : PChar;                   { Message Body as PChar }
    emAttachments  : TStrings;                { Attachments List - full dos 8.3 drive and path }
    emPriority     : Byte;                    { Email Priority: 0-Low, 1-Normal,2-High }
    emUseMAPI      : Boolean;                 { Use MAPI if available }

    { Used for MAPI Components }

    { Used for Bespoke Components }
    emSMTPServer   : String[255];             { SMTP Server Address }
    emSenderName   : String[255];             { From Email Address }
    emHeaders      : TStrings;                { User Definable Email Headers }

    emSpare        : Array [1..200] Of Byte;
  End; { EmailInfoType } *)

{..$IFNDEF ECOM}
  { Class to build PK-ZIP 2.04g Archive Files using ENTCOMMS.DLL }
  TEntZip = Class(TObject)
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
  End; { TEntZip }

  TUnzipper = Class(TObject)
  Private
    FZipFileName : shortString;
    FFiles : TStringList;
  Public
    Property Files : TStringList Read FFiles Write FFiles;
    Constructor Create(sZipFilename : shortstring);
    Destructor Destroy; Override;
    Function ExtractFiles(sMask, sDir : shortstring) : SmallInt;
  End; { TEntZip }

  TEntEmail = Class(TObject)
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
  End; { TEntEmail }

  Function ZipErr(Res  :  SmallInt)  :  ShortString;

  Function EmailErr(Res  :  SmallInt)  :  ShortString;

  Function MAPIAvailable : Boolean;

{..$ENDIF}

implementation
uses
  Forms, AbZipper, AbZipKit, AbArcTyp, AbUtils, EmailFax, Compress, CommsInt;


{..$IFNDEF ECOM}

  Const
    {$IFDEF NOSHMEM}
      // Sharemem disabled
      LibName = 'ENTCOMM2';
    {$Else}
      LibName = 'ENTCOMMS';
    {$ENDIF}


  Constructor TEntZip.Create;
  Begin { TEntZip.Create }
    Inherited Create;

    FDosPaths          := False;
    FOverwriteExisting := False;
    FRecurse           := False;
    FRemoveDots        := True;
    FStripDrive        := True;
    FStripPath         := False;
    FZipName           := '';;

    FFiles := TStringList.Create;
  End; { TEntZip.Create }

  Destructor TEntZip.Destroy;
  Begin { TEntZip.Destroy }
    FFiles.Clear;
    FFiles.Destroy;

    Inherited Destroy;
  End; { TEntZip.Destroy }

  Function TEntZip.Save : SmallInt;
  Var
    AbZipKit1 : TAbZipKit;
    I : Integer;
  Begin { TEntZip.Save }

    Result := 0;

    If (FFiles.Count > 0) Then
      Begin
        If FOverwriteExisting And FileExists(FZipName) Then Begin
          If Not SysUtils.DeleteFile(FZipName) Then Begin
            { Failed to delete existing .ZIP file }
            Result := 2;
            Exit;
          End; { If }
        End; { If }

        {create zipping component}
        AbZipKit1 := TAbZipKit.Create(Application);
        Try
          with AbZipKit1 Do Begin
            If (UpperCase(ExtractFileExt(FZipName)) <> '.ZIP') Then Begin
              // Form Designer/Report Writer - For zipping to EDZ - get an exception
              // without this as Abbrevia doesn't know what compression method to use
              ForceType := True;
              ArchiveType := atZip;
            End; { If (UpperCase(ExtractFileExt... }

            {set properties}
            FileName := FZipName;
            ForceType := True;
            ArchiveType := AtZip;
            DOSMode := FDOSPaths;
            StoreOptions := [];
            if FRecurse then StoreOptions := StoreOptions + [soRecurse];
            if FRemoveDots then StoreOptions := StoreOptions + [soRemoveDots];
            if FStripDrive then StoreOptions := StoreOptions + [soStripDrive];
            if FStripPath then StoreOptions := StoreOptions + [soStripPath];

            { Add files into compression list }
            For I := 0 To Pred(FFiles.Count) Do Begin
              { Check file exists }
              If FileExists (FFiles[I]) Then Begin
                AddFiles (FFiles[I], 0);
              End; { If }
            End; { For }
            Save;
          end;{with}
        finally
          AbZipKit1.Free;
        end;{try}
      end
    else begin
      Result := 1;
    end; { If }
  end; { TEntZip.Save }


  Function ZipErr(Res  :  SmallInt)  :  ShortString;

  Begin
    Case Res of
      1  :  Result:='Unable to locate file to be zipped.';
      2  :  Result:='Unable to delete the existing zip file.';
      3  :  Result:='Unable to locate ENTCOMMS.DLL';
      else  Result:='';

    end; {Case..}

  end;

  {----------------------------------------------------------------------------}


  Constructor TEntEmail.Create;
  Begin { TEntEmail.Create }
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
  End; { TEntEmail.Create }

  Destructor TEntEmail.Destroy;
  Begin { TEntEmail.Destroy }
    StrDispose(FMessage);
    FAttachments.Clear;     FAttachments.Destroy;
    FBCC.Clear;             FBCC.Destroy;
    FCC.Clear;              FCC.Destroy;
    FHeaders.Clear;         FHeaders.Destroy;
    FRecipients.Clear;      FRecipients.Destroy;

    Inherited Destroy;
  End; { TEntEmail.Destroy }

  Procedure TEntEmail.SetMessage (Value : PChar);
  Begin { TEntEmail.SetMessage }
    StrLCopy (FMessage, Value, 10240);
  End; { TEntEmail.SetMessage }

  Procedure TEntEmail.SetPriority(Value : Byte);
  Begin { TEntEmail.SetPriority }
    If (Value In [0..2]) Then Begin
      { Valid Priority }
      FPriority := Value;
    End { If }
    Else Begin
      FPriority := 1;
    End; { Else }
  End; { TEntEmail.SetPriority }

  Function TEntEmail.Send : SmallInt;
  Const
    ResNames : Array[0..1] of PChar = ('ENTCOMMS', 'ECSENDEMAIL');
  Var
    _ecSendEmail  : Function (Const Info : EmailInfoType) : SmallInt; StdCall;
    _MyGSRHandle : THandle;
    DLLAddr      : TFarProc;
    Info         : EmailInfoType;
  Begin { TEntEmail.Send }
    Result := 3;

    { Load ENTCOMMS.DLL dynamically }
{    _MyGSRHandle := LoadLibrary(LibName); //ResNames[0]);}

    Try
{      If (_MyGSRHandle > HInstance_Error) Then Begin
        _ecSendEmail := GetProcAddress(_MyGSRHandle, ResNames[1]);}

{        If Assigned(_ecSendEmail) then }Begin
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
        End; { If }

        { Unload library }
{        FreeLibrary(_MyGSRHandle);
        _MyGSRHandle:=0;
      End; { If }
    Except
{      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;

      _ecSendEmail := Nil;}
    End;
  End; { TEntEmail.Send }



  Function EmailErr(Res  :  SmallInt)  :  ShortString;

  Begin
    Case Res of
      1  :  Result := 'Unable to send via MAPI';
      2  :  Result := 'Unknown Exception';
      3  :  Result := 'Unable to locate ENTCOMMS.DLL';
      4  :  Result := 'Default email settings are incorrect.';
      else  Result := '';

    end; {Case..}

  end;


  { Returns True if MAP is installed and available }
  Function MAPIAvailable : Boolean;
  Const
    ResNames : Array[0..1] of PChar = ('ENTCOMMS', 'ECMAPIAVAILABLE');
  Var
    _ecMapiAvailable : Function : WordBool; StdCall;
    _MyGSRHandle     : THandle;
    DLLAddr          : TFarProc;
  Begin { MAPIAvailable }
    Result := False;

    { Load ENTCOMMS.DLL dynamically }
{    _MyGSRHandle := LoadLibrary(LibName); //ResNames[0]);}

    Try
{      If (_MyGSRHandle > HInstance_Error) Then Begin
        _ecMapiAvailable := GetProcAddress(_MyGSRHandle, ResNames[1]);

        If Assigned(_ecMapiAvailable) then Begin}
          Result := ecMapiAvailable;
{        End; { If }

        { Unload library }
{        FreeLibrary(_MyGSRHandle);
        _MyGSRHandle:=0;
      End; { If }
    Except
{      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;
      _ecMapiAvailable := Nil;}

      Result := False;
    End;
  End; { MAPIAvailable }

  Constructor TUnzipper.Create(sZipFilename : shortstring);

    Procedure GetFileList;
    var
      _ecZipGetFileList  : function (sFileName : shortstring; var slFiles : TStringList) : SmallInt; StdCall;
      _hEntCommsDLL : THandle;
    begin
      { Load ENTCOMMS.DLL dynamically }
{      _hEntCommsDLL := LoadLibrary(LibName); //'ENTCOMMS');}
      try
{        if (_hEntCommsDLL > HInstance_Error) then begin
          _ecZipGetFileList := GetProcAddress(_hEntCommsDLL, 'ECZIPGETFILELIST');
          if Assigned(_ecZipGetFileList)
          then _}ecZipGetFileList(FZipFileName, FFiles);

          { Unload library }
{          FreeLibrary(_hEntCommsDLL);
          _hEntCommsDLL:=0;}
      {  end; { If }
      except
{        FreeLibrary(_hEntCommsDLL);
        _hEntCommsDLL:=0;
        _ecZipGetFileList := nil;}
      end;
    end;{GetFileList}

  Begin {TUnzipper.Create }
    Inherited Create;
    FZipFileName := sZipFilename;
    FFiles := TStringList.Create;
    GetFileList;
  End; {TUnzipper.Create }

  Destructor TUnzipper.Destroy;
  Begin {TUnzipper.Destroy }
    FFiles.Free;
    Inherited Destroy;
  End; {TUnzipper.Destroy }

  function TUnzipper.ExtractFiles(sMask, sDir : shortstring) : SmallInt;
  var
    _ecExtractFiles  : function (sFileName, sMask, sDir : shortstring) : SmallInt; StdCall;
    _hEntCommsDLL : THandle;
  begin
    Result := 0;
    { Load ENTCOMMS.DLL dynamically }
{    _hEntCommsDLL := LoadLibrary(LibName); //'ENTCOMMS');}
    try
{      if (_hEntCommsDLL > HInstance_Error) then begin
        _ecExtractFiles := GetProcAddress(_hEntCommsDLL, 'ECEXTRACTFILES');
        if Assigned(_ecExtractFiles) then }Result := {_}ecExtractFiles(FZipFileName, sMask, sDir);

        { Unload library }
{        FreeLibrary(_hEntCommsDLL);
        _hEntCommsDLL:=0;
      end; { If }
    except
{      FreeLibrary(_hEntCommsDLL);
      _hEntCommsDLL:=0;
      _ecExtractFiles := nil;}
    end;
  end;{TUnzipper.UnzipFiles}

{..$ENDIF}



end.

