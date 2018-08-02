unit XMLEmail;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, msmsg, Email, Mssocket, Mspop, VarConst,XMLConst, Blowfish,
  MapiEx;

type
  TXMLPostProcess = (pxmArchive, pxmDelete);
  TEmailType = (emlNone, emlMAPI, emlSMTP);

  TXMLCompanyInfo = record
    XMLCompanyCode     : string[6];
    XMLSearchDir       : string[80];
    XMLArchiveDir      : string[80];
    XMLFailDir         : string[80];
    XMLImportLogDir    : string[80];
    XMLEmailUserName   : string[40];
    XMLEmailPassword   : string[40];
    XMLAdminEmail      : string[100];
    XMLAdminNotify     : byte;
    XMLPostProcess     : TXMLPostProcess;
    XMLEmailType       : TEmailType;
    XMLPop3ServerName  : string[40];
    XMLNotifySender    : byte;
    XMLConfirmProcessing
                       : byte;
    XMLOrdOKTextFile   : string[12];
    XMLOrdFailTextFile : string[12];
    XMLInvOKTextFile   : string[12];
    XMLInvFailTextFile : string[12];


  end;
  PXMLCompanyInfo = ^TXMLCompanyInfo;

  TMultiCompanyXMLList = class(TList)
    protected
      function ReadFromDatabase  :  boolean;
      function  CheckDirectories : boolean;
    public
      function  InitialiseMultiCompanyList : boolean;
      destructor  Destroy; override;
  end;

  //-----------------------------------------------------------------------------------

  TXMLDir = (xdrSearch, xdrArchive, xdrFail, xdrImportLog);

  TPollStatus = (tmrOn, tmrOff);
  TUpdateMethod = procedure of object;
  TXMLMessageFound = procedure(const XMLFileName : string) of object;

  TdmoXMLPolling = class(TDataModule)
    tmrPoll: TTimer;
    msPOP1: TmsPOPClient;
    msMessage1: TmsMessage;
    Blowfish1: TBlowfish;
    procedure tmrPollTimer(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    EMail1 : TMapiExEmail;
    EMailS : TEmail;
    FUseExtended : Boolean;
    fSearchDir,
    fArchiveDir,
    fFailDir,
    fImportLogDir : string;
    fPollFreq : integer;   // The polling frequency in seconds e.g. every 5 secs
    fSecsElapsed : integer;
    fXMLPostProcess : TXMLPostProcess;
    fDisplayUpdate : TUpdateMethod;
    fXMLMessageFound : TXMLMessageFound;
    fStatusDisplay : string;
    fTimerDisplay : string;
    fPromptUser : boolean; // Whether the user should be asked to accept an XML doc
    fPollStatus : TPollStatus;
    fCompanyCode : string;

    {$IFDEF EXTERNALIMPORT}
      fCompanyPath : string;
    {$ENDIF}

    fMultiCompanyXMLList : TMultiCompanyXMLList;

    // E-mail properties
    fEmailType     : TEmailType;
    fPop3Server    : string;
    fPop3UserName  : string;
    fPop3PassWord  : string;
    fAdminEmail    : string;
    fAdminNotify   : byte;
    fNotifySender  : byte;
    fConfirmProcessing
                   : byte;
    fOrdOKTextFile : String;
    fOrdFailTextFile
                   : String;
    fInvOKTextFile : String;
    fInvFailTextFile
                   : String;


    procedure SetString(Index : integer; const Value : string);
    procedure SetAdminNotify(Value : byte);
    procedure SetPollFreq(Value : integer);
    procedure SetXMLPostProcess(Value : TXMLPostProcess);
    procedure SetXMLMessageFound(Value : TXMLMessageFound);
    procedure SetDisplayUpdate(Value : TUpdateMethod);
    procedure SetEmailType(Value : TEmailType);
    procedure SetPromptUser(Value : boolean);
    procedure UpdateTimerDisplay;
    procedure CallDisplayUpdate;
    procedure DownloadPOP3Emails;
    procedure DownloadMAPIEmails;
    procedure DownloadSimpleMAPIEmails;
    procedure ProcessAllCompanies;
    procedure InitialiseToolkit;
    procedure LookForXMLFiles;
    procedure CheckForEmails;
    procedure SaveOriginator(Const Originator,OrigAddr,Subject,FileName  :  String);

    function  GetAttachmentFileName(const Filename : string) : string;
    function  SaveAttachment(const SourcePath : shortstring;
                              var   ErrStr     : shortstring) : boolean;
    procedure DoTheBlowfish(const FileName : string);
  public
    property SearchDir : string index 1 read fSearchDir write SetString;
    property ArchiveDir : string index 2 read fArchiveDir write SetString;
    property FailDir : string index 3 read fFailDir write SetString;
    property ImportLogDir : string index 4 read fImportLogDir write SetString;
    property PollFreq : integer read fPollFreq write SetPollFreq;
    property PostProcessXML : TXMLPostProcess read fXMLPostProcess write SetXMLPostProcess;
    property DisplayUpdate : TUpdateMethod read fDisplayUpdate write SetDisplayUpdate;
    property EmailType : TEmailType read fEmailType write SetEmailType;
    property Pop3Server : string index 5 read fPop3Server write SetString;
    property Pop3UserName : string index 6 read fPop3UserName write SetString;
    property Pop3PassWord : string index 7 read fPop3PassWord write SetString;
    property StatusDisplay : string index 8 read fStatusDisplay write SetString;
    property TimerDisplay : string index 9 read fTimerDisplay write SetString;
    property CompanyCode : string index 10 read fCompanyCode write SetString;
    property AdminEmail : string index 11 read fAdminEmail write SetString;
    property AdminNotify : byte read fAdminNotify write SetAdminNotify;
    property NotifySender : byte read fNotifySender write fNotifySender;
    property ConfirmProcessing: byte read fConfirmProcessing write fConfirmProcessing;
    property OrdOKTextFile : string index 12 read fOrdOKTextFile write SetString;
    property OrdFailTextFile : string index 13 read fOrdFailTextFile write SetString;
    property InvOKTextFile : string index 14 read fInvOKTextFile write SetString;
    property InvFailTextFile : string index 15 read fInvFailTextFile write SetString;

    {$IFDEF EXTERNALIMPORT}
      property CompanyPath : string index 16 read fCompanyPath write SetString;
    {$ENDIF}

    property OnXMLMessageFound : TXMLMessageFound read fXMLMessageFound write SetXMLMessageFound;
    property PromptUser : boolean read fPromptUser write SetPromptUser;

    function  InitialiseXMLPolling : boolean;
    procedure ProcessXmlDoc(DocName : string);
    procedure PostParsingProcess(DocName : string; ProcessedOK : boolean);
    procedure NotifyAdmin(FileName : string; Status : TImportXML;
      TransMode : TTransferMode = tfrExchange);

    procedure SendNotifySender(SelCompPath,XMLFileName : string; ImpStatus : TImportXML;
                               ImpInv   : InvRec);

    procedure SetPolling(Status : TPollStatus);
  end;

var
  dmoXMLPolling: TdmoXMLPolling;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

uses
  XmlParse, XMLUtil, FileCtrl, EBusVar, Globvar, BtrvU2, CommsInt, EBusUtil,
  ETDateU, BTSupU1,
  EBusBtrv, UseDLLU, Debugger, TKUtil;

//-----------------------------------------------------------------------------------

const
  sBlowLoad = 'dFe7' + '2eN84' + 'mT4b';
  sBlowInit = 'Y6xEE' + '9L7v6' + 'J8rkQ';

destructor TMultiCompanyXMLList.Destroy;
var
  i : integer;
begin
  for i := 0 to Count -1 do
    if assigned(Items[i]) then
    begin
      dispose(PXMLCompanyInfo(Items[i]));
      Items[i] := nil;
    end;
  inherited Destroy;
end; // TReadXMLCompanyInfo.Destroy

//-----------------------------------------------------------------------------------

Function TMultiCompanyXMLList.ReadFromDatabase  :  Boolean;
var
  XMLCompanyInfo : PXMLCompanyInfo;
  GlobalImportSettings : TEBusImport;
  GlobalEmailSettings : TEBusEmail;

  CompanyInfo : TEBusBtrieveCompany;
  ImportInfo : TEBusBtrieveImport;
  EmailInfo : TEBusBtrieveEmail;
  CompPathDir  :  String;


  function GetXMLDir(DirType : TXMLDir; SubPath : string) : string;
  // Notes : Either use the sub path from a particular company defined in the
  //         set-up file, or if blank the standard pathing information.
  begin
    if Trim(SubPath) = '' then
      case DirType of
        xdrSearch    : SubPath := EBUS_XML_SEARCH_DIR;
        xdrArchive   : SubPath := EBUS_XML_ARCHIVED_DIR;
        xdrFail      : SubPath := EBUS_XML_FAIL_DIR;
        xdrImportLog : SubPath := EBUS_LOGS_IMPORTED_DIR;
      end;
    
    If (CompPathDir='') then // Only go and get this once for this company
      {$IFDEF EXTERNALIMPORT}
        CompPathDir:= IncludeTrailingBackSlash(GetCompanyDirFromCode(Trim(ImportInfo.CompanyCode), Trim(CompanyInfo.FileLocation)));
      {$ELSE}
        CompPathDir:= IncludeTrailingBackSlash(GetCompanyDirFromCode(Trim(ImportInfo.CompanyCode)));
      {$ENDIF}

    Result:=CompPathDir;

    Result := Result + IncludeTrailingBackSlash(EBUS_DIR);
    if DirType = xdrImportLog then
      Result := Result + IncludeTrailingBackSlash(EBUS_LOGS_DIR)
    else
      Result := Result + IncludeTrailingBackSlash(EBUS_XML_DIR);
    Result := Result + SubPath;
  end; // GetXMLDir

  procedure ProcessOneCompany;
  var
    CurrentImportSettings : TEBusImport;
    CurrentEmailSettings : TEBusEmail;
  begin
    CompPathDir:='';

    ImportInfo.CompanyCode := CompanyInfo.CompanyCode;
    if ImportInfo.FindRecord = 0 then
      CurrentImportSettings := ImportInfo.ImportSettings
    else
      CurrentImportSettings := GlobalImportSettings;

    EmailInfo.CompanyCode := CompanyInfo.CompanyCode;
    if EmailInfo.FindRecord = 0 then
      CurrentEmailSettings := EmailInfo.EmailSettings
    else
      CurrentEmailSettings := GlobalEmailSettings;

    new(XMLCompanyInfo);
    with XMLCompanyInfo^ do
    begin
      XMLCompanyCode   := CompanyInfo.CompanyCode;
      XMLSearchDir     := GetXMLDir(xdrSearch, CurrentImportSettings.ImportSearchDir);
      XMLArchiveDir    := GetXMLDir(xdrArchive, CurrentImportSettings.ImportArchiveDir);
      XMLFailDir       := GetXMLDir(xdrFail, CurrentImportSettings.ImportFailDir);
      XMLImportLogDir  := GetXMLDir(xdrImportLog, CurrentImportSettings.ImportLogDir);
      XMLEmailUserName := CurrentEmailSettings.EmailAccountName;
      XMLEmailPassword := CurrentEmailSettings.EmailAccountPassword;
      XMLAdminEmail    := CurrentEmailSettings.EmailAdminAddress;
      XMLAdminNotify   := CurrentEmailSettings.EmailNotifyAdmin;
      XMLNotifySender  :=CurrentEmailSettings.EmailNotifySender;
      XMLConfirmProcessing:=CurrentEmailSettings.EmailConfirmProcessing;
      XMLOrdOKTextFile:=CompanyInfo.CompanySettings.CompOrdOKTextFile;
      XMLOrdFailTextFile:=CompanyInfo.CompanySettings.CompOrdFailTextFile;
      XMLInvOKTextFile:=CompanyInfo.CompanySettings.CompInvOKTextFile;
      XMLInvFailTextFile:=CompanyInfo.CompanySettings.CompInvFailTextFile;

      if CompanyInfo.CompanySettings.CompXMLAfterProcess = 0 then
        XMLPostProcess := pxmArchive
      else
        XMLPostProcess := pxmDelete;
      case CurrentEmailSettings.EmailType of
        0 : XMLEmailType := emlNone;
        1 : XMLEmailType := emlMAPI;
        2 : XMLEmailType := emlSMTP;
      end;
      // Additional field now determines if E-mail available, so overwrite EmailType
      if not CurrentEmailSettings.EmailEnabled then
        XMLEmailType := emlNone;
      XMLPop3ServerName  := CurrentEmailSettings.EmailServerName;
    end;
    Add(XMLCompanyInfo);
  end;

begin // TMultiCompanyXMLList.ReadFromDatabase
  Result:=True;
  CompPathDir:='';

  ImportInfo := TEBusBtrieveImport.Create(true);
  try
    Result:=(ImportInfo.OpenFile=0);


    ImportInfo.FindRecord;
    // Assign anyway, so that variable initialised with user's values or blank
    GlobalImportSettings := ImportInfo.ImportSettings;

    If (Result) then
    Begin
      EmailInfo := TEBusBtrieveEmail.Create(true);
      try
        Result:=(EmailInfo.OpenFile=0);
        EmailInfo.FindRecord;
        // Assign anyway, so that variable initialised wirh user's values or blank
        GlobalEmailSettings := EmailInfo.EmailSettings;

        If (Result) then
        Begin
          // Loop through all the companies that have been set-up
          CompanyInfo := TEBusBtrieveCompany.Create(true);
          try
            Result:=(CompanyInfo.OpenFile=0);

            Status := CompanyInfo.FindRecord(B_GetFirst);
            while Status = 0 do
            begin
               ProcessOneCompany;
               Status := CompanyInfo.FindRecord(B_GetNext);
            end;
            CompanyInfo.CloseFile;
          finally
            CompanyInfo.Free;
          end;
        end {If file not open error, reset  GlobalEmailSettings}
        else
        Begin
          FillChar(GlobalEmailSettings,Sizeof(GlobalEmailSettings),0);

        end;

        EmailInfo.CloseFile;
      finally
        EmailInfo.Free;
      end;
    end {If File not open, }
    else
    Begin


    end;

    ImportInfo.CloseFile
  finally
    ImportInfo.Free;
  end;
end; // TMultiCompanyXMLList.ReadFromDatabase

//-----------------------------------------------------------------------------------

function TMultiCompanyXMLList.CheckDirectories : boolean;
var
  i : integer;
  CompanyInError : boolean;
  CurCompany,
  ErrMsg : string;

  procedure CheckOneDirectory(const Dir : string);
  begin
    if not DirectoryExists(Dir) then
    begin
      if not CompanyInError then
        ErrMsg := ErrMsg + CRLF + 'Company: ' + CurCompany;
      ErrMsg := ErrMsg + CRLF + Dir;
      CompanyInError := true;
      Result := false;
    end;
  end;

begin // TMultiCompanyXMLList.CheckDirectories
  Result := true;
  ErrMsg := '';
  for i := 0 to Count -1 do
    with TXMLCompanyInfo(Items[i]^) do
    begin
      CompanyInError := false;
      CurCompany := XMLCompanyCode;
      CheckOneDirectory(XMLSearchDir);
      CheckOneDirectory(XMLFailDir);
      if XMLPostProcess = pxmArchive then
        CheckOneDirectory(XMLArchiveDir);
      CheckOneDirectory(XMLImportLogDir);
    end;

  if not Result then
  begin
    ErrMsg := 'The following required eBusiness directories are missing:' +
      ErrMsg;
    MessageDlg(ErrMsg, mtError, [mbOk], 0);
  end;
end; // TMultiCompanyXMLList.CheckDirectories

//-----------------------------------------------------------------------------------

function TMultiCompanyXMLList.InitialiseMultiCompanyList : boolean;
begin
  {$B-}
    Result:=(ReadFromDatabase and CheckDirectories);

  {$B-} {Projcect is by default short circuit evaluation}
end;

//===================================================================================

procedure TdmoXMLPolling.SetString(Index : integer; const Value : string);
begin
  case Index of
    1: begin
         fSearchDir := Value;
         // Only poll for a file if the search directory is valid
         if not DirectoryExists(fSearchDir) then
           fSearchDir := '';
       end;
    2: begin
         fArchiveDir := Value;
         // Only archives if the archive directory is valid
         if not DirectoryExists(fArchiveDir) then
           fArchiveDir := '';
       end;
    3: begin
         fFailDir := Value;
         // Only archives if the fail directory is valid
         if not DirectoryExists(fFailDir) then
           fFailDir := '';
       end;
    4: begin
         fImportLogDir := Value;
         // Only archives if the import log directory is valid
         if not DirectoryExists(fImportLogDir) then
           fImportLogDir := '';
       end;
    5: fPop3Server := Value;
    6: fPop3UserName := Value;
    7: fPop3PassWord := Value;
    8: fStatusDisplay := Value;
    9: fTimerDisplay := Value;
    10: fCompanyCode := Value;
    11: fAdminEmail := Value;
    12: fOrdOKTextFile:=Value;
    13: fOrdFailTextFile:=Value;
    14: fInvOKTextFile:=Value;
    15: fInvFailTextFile:=Value;

    {$IFDEF EXTERNALIMPORT}
      16: fCompanyPath := Value;
    {$ENDIF}

  end;
end; // TdmoXMLPolling.SetString

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetEmailType(Value : TEmailType);
begin
  fEmailType := Value;
  if Value = emlMAPI then
  begin
    FUseExtended := ExtendedMAPIAvailable;
    if FUseExtended then
    begin
      if not Assigned(Email1) then
        Email1 := TMapiExEmail.Create(Self);
      Email1.DeleteAfterRead := False;
    end
    else
    begin
      if not Assigned(EmailS) then
        EmailS := TEmail.Create(Self);
    end;
  end;

end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetPromptUser(Value : boolean);
begin
  fPromptUser := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetPollFreq(Value : integer);
begin
  fPollFreq := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetAdminNotify(Value : byte);
begin
  fAdminNotify := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetXMLPostProcess(Value : TXMLPostProcess);
begin
  fXMLPostProcess := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetDisplayUpdate(Value : TUpdateMethod);
begin
  if assigned(Value) then
    fDisplayUpdate := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetXMLMessageFound(Value : TXMLMessageFound);
begin
  if assigned(Value) then
    fXMLMessageFound := Value;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.CallDisplayUpdate;
begin
  if assigned(DisplayUpdate) then
    DisplayUpdate;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.tmrPollTimer(Sender: TObject);
begin
  inc(fSecsElapsed);
  UpdateTimerDisplay;

  if fSecsElapsed >= PollFreq then
  begin
    SetPolling(tmrOff);
    ProcessAllCompanies;

    
  end;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.ProcessAllCompanies;
var
  XMLCompanyInfo : TXMLCompanyInfo;
  i : integer;
begin
  for i := 0 to fMultiCompanyXMLList.Count -1 do
  begin
    XMLCompanyInfo := TXMLCompanyInfo(fMultiCompanyXMLList.Items[i]^);
    with XMLCompanyInfo do
    begin
      Application.ProcessMessages;

      CompanyCode := XMLCompanyCode;
      SearchDir := XMLSearchDir;
      ArchiveDir := XMLArchiveDir;
      FailDir := XMLFailDir;
      EmailType := XMLEmailType;
      Pop3Server := XMLPop3ServerName;
      Pop3UserName := XMLEmailUserName;
      Pop3PassWord := XMLEmailPassword;
      AdminEmail := XMLAdminEmail;
      AdminNotify := XMLAdminNotify;
      NotifySender:=XMLNotifySender;
      ConfirmProcessing:=XMLConfirmProcessing;
      OrdOKTextFile:=XMLOrdOKTextFile;
      OrdFailTextFile:=XMLOrdFailTextFile;
      InvOKTextFile:=XMLInvOKTextFile;
      InvFailTextFile:=XMLInvFailTextFile;

      PostProcessXML := XMLPostProcess;
      ImportLogDir := XMLImportLogDir;
    end;
    // Check for XML E-mails and remove attachments
    CheckForEmails;
    // Check for XML files for this company
    LookForXMLFiles;

    If (WantToClose) then
      Break;
  end;


  If (Not WantToClose) then
    SetPolling(tmrOn)
  else
  Begin
    BusyInProcess:=False;
    PostMessage(Application.MainForm.Handle,WM_IconClose,0,0);
  end;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SetPolling(Status : TPollStatus);
begin
  if fPollStatus <> Status then
    fPollStatus := Status
  else
    exit;

  case fPollStatus of
    tmrOn :
      begin
        fSecsElapsed := 0;
        tmrPoll.Enabled := true;
        UpdateTimerDisplay;

        //Reset can't close flag
        BusyInProcess:=False;

      end;
    tmrOff :
      begin
        tmrPoll.Enabled := false;
        BusyInProcess:=True;
        //Set can't close flag

      end;
  end;
end;

//-----------------------------------------------------------------------------------

function TdmoXMLPolling.GetAttachmentFileName(const Filename : String) : string;
var
  FVar : longint;
  Ext : string;
begin
  Ext := ExtractFileExt(Filename);
  if UpperCase(Ext) <> '.XMB' then
    Ext := '.xml';
  with TEBusEmailCounter.Create do
  try
    OpenFile;
    MaxValue := 9999999;
    repeat
      FVar := GetNextValue;
      Result := IncludeTrailingBackSlash(fSearchDir) + 'E' + IntToStr(FVar) + {'.XML'}Ext;
    until not FileExists(Result);
  finally;
    CloseFile;
    Free;
  end;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.SaveOriginator(Const Originator,OrigAddr,Subject,FileName  :  String);

Var
  FileIO   :  Text;
  IOR      :  Integer;
  NewFileName
           :  String;

Begin
  {$I-}
    NewFileName:=ChangeFileExt(FileName,EBUS_EML_EXT);

    AssignFile(FileIO,NewFileName);

    Try

      IOR:=IOresult;

      Report_IOError(IOR,NewFileName);

      If (IOR=0) then
      Begin
        ReWrite(FileIO);

        IOR:=IOresult;

        Report_IOError(IOR,NewFileName);

        If (IOR=0) then
        Begin
          Writeln(FileIO,Originator);
          Writeln(FileIO,OrigAddr);
          Writeln(FileIO,Subject);

          IOR:=IOresult;

          Report_IOError(IOR,NewFileName);
        end;
      end;
    finally
      CloseFile(FileIO);

    end;
  {$I+}
end;



function TdmoXMLPolling.SaveAttachment(const SourcePath : ShortString;
                                        var   ErrStr     : ShortString) : Boolean;
var
  RepFName       : ShortString;
  pFromF, pToF   : PChar;
begin
  Result := True;
  ErrStr := '';
  try
    RepFName := GetAttachmentFileName(SourcePath);


    // Copy file
    pFromF := StrAlloc(255);
    StrPCopy (pFromF, SourcePath);

    pToF   := StrAlloc(255);
    StrPCopy (pToF, RepFName);

    if not CopyFile (pFromF, pToF, false) then
    begin
      { Error - Failed To Copy }
      ErrStr := IntToStr(GetLastError);
      Result := False;
    end
    else
    begin
      if FUseExtended then
        With Email1 do {* Save email details for auto response back *}
          SaveOriginator(Originator,OrigAddress,Subject,RepFName)
      else
        With EmailS do {* Save email details for auto response back *}
          SaveOriginator(Originator,OrigAddress,Subject,RepFName)
    end;

    StrDispose(pFromF);
    StrDispose(pToF);

    { Delete original temp file }
    DeleteFile (SourcePath);
  except
    on Ex:Exception do
    begin
      ErrStr := Ex.Message;
      Result := False;
    end;
  end;
end; // function TdmoXMLPolling.SaveAttachment

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.DownloadPOP3Emails;
Var
  I, J, FVar : LongInt;
  RepFName   : ShortString;
  EmlFileName: String;
Begin { DownloadPOP3Emails }
  EmlFileName:='';

  Try { Except }
    With msPOP1 Do
    begin
      { Download all messages }
      for I := 0 To Pred(TotalMessages) do
      begin
        Application.ProcessMessages;

        fStatusDisplay := 'Processing ' + IntToStr(I + 1) + ' of ' + IntToStr(TotalMessages);
        CallDisplayUpdate;

        { Download full message details }
        CurrentMessage := i;
        Retrieve;

        With MailMessage Do
        Begin
          If (Attachments.Count > 0) Then Begin
            For J := 0 To Pred(Attachments.Count) Do Begin
              // Check it's an .XML file }
              if (UpperCase(ExtractFileExt(Attachments[J].FileName)) = '.XML') or
                 (UpperCase(ExtractFileExt(Attachments[J].FileName)) = '.XMB') then
              begin
                // Generate unique filename in destination dir }
(*                FVar := 0;
                Repeat
                  RepFName := IncludeTrailingBackSlash(fSearchDir) + 'EML' + IntToStr(FVar) + '.XML';
                  Inc (FVar);
                Until (Not FileExists (RepFName)) Or (FVar > 99999); *)

                RepFName:=GetAttachmentFileName(Attachments[J].FileName);

                { Save to file }
                Attachments[J].Contents.SaveToFile(RepFName);

                With MailMessage.Sender do  {* Save email details for auto response back *}
                Begin
                  {EL: 04/10/2000. For some reason, name & address are the wrong way around, so pass in wrong way around}
//                  SaveOriginator(Address,Name,Subject,RepFName);
                  //PR 24/09/2004. Changed back to normal order.
                  SaveOriginator(Name,Address,Subject,RepFName);
                end;
              end;
            End; { For J }
          End; { If }
        End; { With Msg }

        { Delete message from server }
        Delete;

        If (WantToClose) then
          Break;
      End; { For }
    End; { With msPOP1 }
  Except
    On Ex:Exception Do
      MessageDlg ('The following exception occured whilst reading the messages:' + #13#13 +
                  Ex.Message, mtError, [mbOk], 0);
  End;
End; { DownloadPOP3Emails }

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.DoTheBlowfish(const FileName : string);
var
  NewFileName: string;
begin
  NewFileName:= ChangeFileExt(FileName, '.xml');

  with BlowFish1 do
  try
    LoadIVString('dFe7' + '2eN84' + 'mT4b');
    InitialiseString('Y6xEE' + '9L7v6' + 'J8rkQ');
    DecFile(FileName, NewFileName);
    if FileExists(NewFileName) then DeleteFile(FileName);
  finally
    Burn;
  end;
end;

procedure TdmoXMLPolling.CheckForEmails;
var
  NumWaiting : longint;
  OldText    : string;
  Res        : Integer;
  WasMessages : Boolean;
begin
  OldText := StatusDisplay;
  fStatusDisplay := 'Checking Emails';
  CallDisplayUpdate;

  case EmailType of
    emlMAPI:
    begin
      try
        if not FUseExtended then
        begin
        { Logon to MAPI and download all emails to inbox }
          EmailS.UseDefProfile := True;
          EmailS.Logon;
          try
            { Count unread emails }
            NumWaiting := EmailS.CountUnread;
            WasMessages := NumWaiting > 0;
            if NumWaiting > 0 then // Process e-mails
              DownloadSimpleMAPIEmails;
          finally
            { Logoff MAPI }
            EmailS.LogOff;
{            if WasMessages and Assigned(FOnLogOff) then
              FOnLogOff(Self);}
          end;
        end
        else
        begin
          Email1.UseDefProfile := True;
          Res := Email1.Logon;
          Try
            if Res = 0 then
              DownloadMAPIEmails;
          Finally
            Email1.Logoff;
          end;
        end;
      except
        On Ex:Exception Do
          MessageDlg ('The following exception occurred whilst reading the messages:' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
      end;
    end;

    emlSMTP:
    begin
      try
        with MSPop1 do
        begin
          Host     := POP3Server;
          UserName := POP3UserName;
          Password := POP3PassWord;
          { Connect to Server }
          Login;

          try
            { Check for outstanding messages }
            if TotalMessages > 0 then
              DownloadPOP3Emails;
          finally
            // Close connection
            Logout;
          end;
        end; // with
      except
      On Ex:Exception Do
        MessageDlg ('The following exception occurred whilst reading the messages:' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
      end;
    end;
  end; // case

  fStatusDisplay := OldText;
  CallDisplayUpdate;
end; { CheckforEmails }

//-----------------------------------------------------------------------------------
procedure TdmoXMLPolling.DownloadMAPIEmails;
var
  Messages       : TStringList;
  MsgCnt, MsgPos : SmallInt;
  I              : SmallInt;
  ErrStr         : ShortString;
  Res            : Integer;
Begin { DownLoadEmails }
    Try { Except }
      Res := Email1.GetFirstUnread;

      if Res = 0 then
        FStatusDisplay := 'Downloading Email headers - MAPI';

      while (Res = 0) and not WantToClose do
      with Email1 do
      begin
        Application.ProcessMessages;
        If (Attachment.Count > 0) Then
          For I := 0 To Pred(Attachment.Count) Do
            If Not SaveAttachment (Attachment[I], ErrStr) Then Begin
              { Some error saving the attachment }
              MessageDlg ('An error ''' + ErrStr + ''' occured whilst saving the attachments please ' +
                          'manually import the attachment:-' + #13#13 +
                          'Sender: ' + Originator + ' (' + OrigAddress + ')' + #13 +
                          'Subject: ' + Subject{ + #13 +
                          'Received: ' + DateRecvd}, mtError, [mbOk], 0);
            End; { If }
        Inc (MsgPos);

        Res := Email1.GetNextUnread;
      end;

    Except
      On Ex:Exception Do
        MessageDlg ('The following exception occurred whilst reading the messages:' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    End;
End; { DownLoadEmails }


procedure TdmoXMLPolling.DownloadSimpleMAPIEmails;
var
  Messages       : TStringList;
  MsgCnt, MsgPos : SmallInt;
  I              : SmallInt;
  ErrStr         : ShortString;
Begin { DownLoadEmails }
  { Create list to store Message ID's in }
  Messages := TStringList.Create;
  EMailS.UnreadOnly := True;
  Try { Finally }
    Try { Except }
      { Download all Message ID's into local list }
      fStatusDisplay := 'Downloading Email Headers';
      CallDisplayUpdate;

      EmailS.GetNextMessageId;

      While (Length(EmailS.MessageId) <> 0)  and (Not WantToClose) Do
      Begin
        Messages.Add(EmailS.MessageId);

        EmailS.GetNextMessageID;
      End; { While (Length(EmailS.MessageId) <> 0) }

      { Process downloaded messages -have to do this way otherwise positioning }
      { is lost in message queue and it starts looping, etc...                 }
      MsgPos := 1;
      MsgCnt := Messages.Count;
      While (Messages.Count > 0)  and (Not WantToClose) Do
      Begin
        Application.ProcessMessages;

        fStatusDisplay := 'Processing ' + IntToStr(MsgPos) + ' of ' + IntToStr(MsgCnt);
        CallDisplayUpdate;

        With EmailS Do Begin
          { Set Message ID from list }
          MessageId := Messages[0];

          { Mark messages as read }
          LeaveUnRead := False;

          { fetch the specified message }
          ReadMail;

          { Save attachments }
          If (Attachment.Count > 0) Then
            For I := 0 To Pred(Attachment.Count) Do
              If Not SaveAttachment (AttPathNames[I], ErrStr) Then Begin
                { Some error saving the attachment }
                MessageDlg ('An error ''' + ErrStr + ''' occured whilst saving the attachments please ' +
                            'manually import the attachment:-' + #13#13 +
                            'Sender: ' + Originator + ' (' + OrigAddress + ')' + #13 +
                            'Subject: ' + Subject + #13 +
                            'Received: ' + DateRecvd, mtError, [mbOk], 0);
              End; { If }
        End; { With EmailS }

        { Increment progress counter }
        Inc (MsgPos);

        { Remove Message ID from list }
        Messages.Delete(0);
      End; { While (Messages.Count > 0) }
    Except
      On Ex:Exception Do
        MessageDlg ('The following exception occured whilst reading the messages:' + #13#13 +
                    Ex.Message, mtError, [mbOk], 0);
    End;
  finally
    Messages.Destroy;
  end;
End; { DownLoadEmails }

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.ProcessXmlDoc(DocName : string);
var
  Status : integer;
begin
  with TxmlParse.Create do
  try
    Initialise(xmlDemo, DocName);
    Parse(Status);
    if Status = 0 then
      MessageDlg(Format('XML document %s successfully created.', [CreatedTransName]),
        mtInformation, [mbOK], 0)
    else
      MessageDlg(Format('XML document %s not imported. %s Error Code = %d',
        [DocName, #13#10, Status]), mtError, [mbOK], 0);

    PostParsingProcess(DocName, Status=0);
  finally
    Free;
  end;
end;

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.PostParsingProcess(DocName : string; ProcessedOK : boolean);
Var
  EmlFName    :  String;
  HaveEmlFile :  Boolean;

  procedure MoveTo(const OldName,Dir : string);
  var
    NewName : string;
  begin
    if Dir <> '' then
    begin
      NewName := IncludeTrailingBackSlash(Dir) + ExtractFileName(OldName);
      DeleteFile(NewName);
      RenameFile(OldName, NewName);
    end;
  end; // MoveTo

begin // TdmoXMLPolling.PostParsingProcess
  EmlFName:=ChangeFileExt(DocName,EBUS_EML_EXT);
  HaveEmlFile:=FileExists(EmlFName);

  if ProcessedOK then
  Begin
    if PostProcessXML = pxmDelete then
    Begin
      DeleteFile(DocName);

      If (HaveEmlFile) then
        DeleteFile(EmlFName);
    end
    else
    Begin
      MoveTo(DocName,ArchiveDir);

      If (HaveEmlFile) then
        MoveTo(EmlFName,ArchiveDir);
    end;
  end
  else
  Begin
    MoveTo(DocName,FailDir);

    If (HaveEmlFile) then
      MoveTo(EmlFName,FailDir);
  end;
end; // TdmoXMLPolling.PostParsingProcess

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.NotifyAdmin(FileName : string; Status : TImportXML;
  TransMode : TTransferMode = tfrExchange);
var
  Msg : ansistring;
  lstRecipient : TStringList;
begin
  // AdminNotify : 0 = never, 1 = only exchange XML transactions, 2 = all XML transactions
  if (EmailType <> emlNone) and
    (((AdminNotify = 1) and ((TransMode = tfrExchange) or (Status = impFatal))) or
    (AdminNotify = 2)) then
    with TEntEmail.Create do
    try
      Msg := Format('XML message %s ', [FileName]);
      case Status of
        impFatal: Msg := Msg + 'could not be imported';
        impOK:    Msg := Msg + 'was imported OK';
        impError: Msg := Msg + 'was imported with errors';
        impWarn : Msg := Msg + 'was imported with warnings';
      end;
      Message := PChar(Msg);
      Priority := 1; // Normal ???
      lstRecipient := TStringList.Create;
      lstRecipient.Add(AdminEmail);
      Recipients.Assign(lstRecipient);
      Sender := AdminEmail;
      SenderName := 'Exchequer eBusiness Module';
      SMTPServer := Pop3Server;
      if EmailType = emlMAPI then
        UseMAPI := true
      else
        UseMAPI := false;
      try
        Send;
      except // Trap any exceptions on sending E-mail
      end;
    finally
      lstRecipient.Free;
      Free;
    end;
end;

//-----------------------------------------------------------------------------------
// Sends contents of OK or Failed Ord/Inv standard text file to original sender of eBIS email

procedure TdmoXMLPolling.SendNotifySender(SelCompPath,XMLFileName : string; ImpStatus : TImportXML;
                                          ImpInv   : InvRec);

Const
  SimpleMessage  :  Array[BOff..BOn] of String[80] = ('failed to be imported.','was successfully received.');

Var
  ImportOK  :  Boolean;
  Msg       : ansistring;
  lstRecipient
            : TStringList;


  Function  MsgFileName  :  AnsiString;

  Begin
    Result:='';

    If (ImpInv.InvDocHed In OrderSet) then
    Begin
      If (ImportOk) then
        Result:=OrdOKTextFile
      else
        Result:=OrdFailTextFile;

    end
    else
    Begin
      If (ImportOk) then
        Result:=InvOKTextFile
      else
        Result:=InvFailTextFile;
    end;

  end;


Begin {NotifySender}
  ImportOk:=(ImpStatus In [ImpOk,ImpWarn]);

  Debug.Show('Running SendNotify Sender with : CompPAth:  '+SelCompPath+'| XMLFileName : '+XMLFileName+'| Inv '+
              ImpInv.YourRef+'/'+ImpInv.TransDesc+'/'+ImpInv.TransDate);

  if (EmailType <> emlNone) and (NotifySender=1) then
  Begin
    With TGetSenderDetails.Create  do
    try

      ReadEmailSettings(XMLFileName);

      Debug.Show('Read Email Settings got Originator :'+Originator+'| Address : '+OrigAddr+'| Subject : '+TheSubject);

      If (OrigAddr<>'') then
      Begin
        With TStringList.Create do
        try
          If (MsgFileName<>'') then
            LoadFromFile(IncludeTrailingBackSlash(SelCompPath)+IncludeTrailingBackSlash(EBUS_Dir)+IncludeTrailingBackSlash(EBUS_TXT_DIR)+MsgFileName)
          else
            Add('The message '+SimpleMessage[ImportOK]);


          with TEntEmail.Create,ImpInv  do
          try
            Msg := 'Your Ref : '+YourRef+'/'+TransDesc+'. Dated : '+PoutDate(TransDate);

            Msg:=Msg+#13+#10+#13+#10;

            Msg:=Msg+'Our Ref '+Format('XML message %s ', [XMLFileName]);

            Msg:=Msg+#13+#10+#13+#10+Text;

            Message := PChar(Msg);
            Priority := 1; // Normal ???
            lstRecipient := TStringList.Create;
            lstRecipient.Add(OrigAddr);
            Recipients.Assign(lstRecipient);
            Sender := AdminEmail;
            SenderName := 'Exchequer eBusiness Module';
            Subject:='FAO '+Originator+'. Re '+TheSubject;

            SMTPServer := Pop3Server;
            if EmailType = emlMAPI then
              UseMAPI := true
            else
              UseMAPI := false;
            try
              Send;
            except // Trap any exceptions on sending E-mail
            end;
          finally
            lstRecipient.Free;
            Free;
          end;  {Try..}



        finally
          Free;

        end; {Try..}

      end;

    finally
      Free;

    end; {Try..}



  end;
end; {Proc..}







//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.InitialiseToolkit;
var
  Status : integer;
  CompanyPath : ansistring;

  procedure ReadSysRec;
  var
    Lock : boolean;
    Stat : integer;
  begin
    Stat := Open_File(F[SysF], CompanyPath + FileNames[SysF], 0);
    if Stat = 0 then
    begin
      Lock := false;
      GetMultiSys(false, Lock, SysR);
      Close_File(F[SysF]);
    end;
  end;

begin
  Ex_CloseData;

  //NF: 05/02/2010 - Added for compatibility with Simply Conveyancing Bespoke Importer
  {$IFDEF EXTERNALIMPORT}
    CompanyPath := GetCompanyDirFromCode(Trim(CompanyCode), '');
  {$ELSE}
    CompanyPath := GetCompanyDirFromCode(Trim(CompanyCode));
  {$ENDIF}

  ReadSysRec;
  Status := SetToolkitPath(CompanyPath);
  ShowTKError('TdmoXMLPolling.InitialiseToolkit',84,Status);
  if Status = 0 then
  begin
    Status := Ex_InitDLL;

    ShowTKError('TdmoXMLPolling.InitialiseToolkit',1,Status);
  end;
end; // TXmlParse.InitialiseToolkit

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.LookForXmlFiles;
// Post : Looks for all XML files within a particular company's search directory
var
  SearchRec : TSearchRec;
  Path : string;
  Status : integer;
  ToolkitInitialised : boolean;
begin
//look for blowfish files
  Path := IncludeTrailingBackSlash(fSearchDir) + '*.xmb';
  Status := FindFirst(Path, faAnyFile, SearchRec);
  while (Status = 0) and (Not WantToClose) do
  begin
    DoTheBlowfish(IncludeTrailingBackSlash(ExtractFileDir(Path)) + SearchRec.Name);
    Status := FindNext(SearchRec);
  end;

//look for .xml files
  Path := IncludeTrailingBackSlash(fSearchDir) + '*.xml';
  Status := FindFirst(Path, faAnyFile, SearchRec);
  ToolkitInitialised := false;
  while (Status = 0) and (Not WantToClose) do
  begin
    Application.ProcessMessages;

    if not PromptUser or
      (PromptUser and (MessageDlg(Format('XML document %s found, do you wish to import?',
        [SearchRec.Name]), mtConfirmation, [mbYes,mbNo], 0) = mrYes)) then
      if assigned(OnXMLMessageFound) then
      begin
        if not ToolkitInitialised then
        begin
          InitialiseToolkit;
          ToolkitInitialised := true;
        end;
        OnXMLMessageFound(IncludeTrailingBackSlash(ExtractFileDir(Path)) + SearchRec.Name);
      end;
    Status := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
end; // TdmoXMLPolling.LookForXmlFiles

//-----------------------------------------------------------------------------------

procedure TdmoXMLPolling.UpdateTimerDisplay;
var
  Secs : integer;

  function FormatTime : string;
  const
    SECS_PER_MIN = 60;
  var
    Mins : integer;
  begin
    Mins := Secs div SECS_PER_MIN;
    Secs := Secs mod SECS_PER_MIN;
    Result := Format('%.2d:%.2d',[Mins,Secs]);
  end;

begin
  Secs := PollFreq - fSecsElapsed;
  fTimerDisplay := 'Time : ' + FormatTime;
  CallDisplayUpdate;
end;

//-----------------------------------------------------------------------------------

function TdmoXMLPolling.InitialiseXMLPolling : boolean;
begin
  fMultiCompanyXMLList := TMultiCompanyXMLList.Create;
  Result := fMultiCompanyXMLList.InitialiseMultiCompanyList;
  fPollStatus := tmrOff;
end;

procedure TdmoXMLPolling.DataModuleCreate(Sender: TObject);
begin
  Email1 := nil;
  EmailS := nil;
end;

end.
