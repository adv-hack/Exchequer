unit AuthVar;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobVar, BtrvU2;

const
//  CheckPINInterval = 60;
  defNone = '[None]';
  MaxAuthAmount = 999999999999.99;
  MaxPaRecSize = 650;

  MaxLogFileSize = 1024 * 200;

  CRLF = #13#10;

  fdPIN = 22;
  fdPOR = 25;
  fdPQU = 24;
  fdSQU = 10;

  AuthF      = 1;
  UserF      = 2;
  RequestF   = 3;
  GlobalParamsF = 4;
  CompanyParamsF = 5;

  AuthNameIdx = 0;
  AuthValIdx = 1;
  AuthEmailIdx = 2;
  AuthCodeIdx = 3;

  ReqEARIdx = 0;
  ReqDateIdx = 1;
  ReqOurRefIdx = 2;

  PaPath = 'WorkFlow\';

  PaTypeGlob = 0;
  PaTypeComp = 1;
  PaTypeAuth = 2;
  PaTypeUser = 3;
  PaTypeRequest = 4;
  PaTypeAuthInactive = 5;

  hcGlobalAc = 30;
  hcGlobalDef = 31;
  hcGlobalMess = 32;
  hcGlobSec = 33;

  hcCompDef = 35;
  hcCompForms = 36;
  hcCompOther = 37;

  hcAuthDet = 38;
  hcAuthPerm = 39;

  hcUserSet = 41;

  hcReq  = 47;

  AuthFilename = PaPath + 'PaAuth.dat';
  UserFileName = PaPath + 'PaUser.dat';
  RequestFileName = PaPath + 'PaEar.dat';
  GlobalParamsFilename = PaPath + 'PaGlobal.Dat';
  CompanyParamsFilename = PaPath + 'PaComp.Dat';

  PaMessageFile = PaPath + 'PaMsg.txt';
  PaAppMsgFile = PaPath + 'PaAppMsg.txt';

  AuNumOfKeys = 4;
  AuNumSegments =9;

  UsNumOfKeys = 1;
  UsNumSegments = 2;

  ReNumOfKeys = 3;
  ReNumSegments = 6;

  GpNumOfKeys = 1;
  GpNumSegments = 1;

  CpNumOfKeys = 1;
  CpNumSegments = 1;



type

  TAuthModeType = (auAuthOnlyAuto, auAuthOnlyMan, auApproveAndAuth);

  TEARStatusType = (esSentforApproval, esApprovedAndSent, esSentForAuth, esReadyToSend,
                    esOrderWaitingForInvoice, esOKToAuthorise, esAuthorised, esRejected);

  TEARDocType = (edtPIN, edtPOR, edtPQU, edtSQU);

  TpaAuthorizerRec = Record
   Company                : String[6];
   auName                 : String[60];
   auMaxAuthAmount        : Int64;
   auEndAmountchar        : Char;
   auEMail                : String[100];
   auAuthCode             : String[10];
   auAuthSQU              : Boolean;
   auAuthPQU              : Boolean;
   auAuthPOR              : Boolean;
   auAuthPIN              : Boolean;
   Active                 : Boolean;
   auApprovalOnly         : Boolean;
   auCompressAttachments  : Boolean;
   auDefaultAuth          : string[60];
   auAlternate            : string[30];
   auAltAfter             : SmallInt; //interval after which to use alternate
   auAltHours             : Boolean;
   auDisplayEmail         : string[100];
   Spare                  : Array[1..102] of char;
   //PR 31/03/2008 IMPORTANT - This record size is 494 bytes, but the record size in PaAuth.dat is 394 bytes. We've got away
   //with it because of the spare & compression, but the next time we need to add a field we should do a data conversion.
  end;

  TpaUserRec       = Record
    usCompany             : String[6];
    usUserID              : String[10];
    usUserName            : String[30];
    usEMail               : string[100];
    usFloorLimit          : Double;
    usAuthAmount          : Double;
    usSendOptions         : Char;
    usDefaultApprover     : string[60];
    usDefaultAuthoriser   : string[60];
    Spare                 : Array[1..178] of char;
  end;

  TpaRequestRec = Record
    Company               : String[6];
    reEAR                 : String[50];
    reOurRef              : String[10];
    reUserID              : String[10];
    reTimeStamp           : String[12]; //yyyymmddhhnn
    reTotalValue          : Double;
    reStatus              : Byte; //maps to EARStatusType
    reApprovedBy          : String[60]; //authorisername of approver
    reAuthoriser          : String[60];
    reFolio               : longint;
    reDocType             : Byte;
    reSupplier            : String[6];
    reLineCount           : SmallInt;
    reCheckSum            : Int64;
    reApprovalDateTime    : TDateTime;
    reAdminNotified       : Boolean;
    reAlreadySent         : Boolean;
    rePrevDate            : string[12]; //yyyymmdd
    Spare                 : Array[1..134] of char;
  end;

  TpaGlobalSysParams = Record
    spCompany             : string[6];
    spFrequency           : SmallInt;
    spAccountName         : String[100];
    spAccountPWord        : String[100];
    spEMail               : String[100];
    spAdminEMail          : string[100];
    spOfflineStart        : TDateTime;
    spOfflineFinish       : TDateTime;
    spEARTimeOut          : SmallInt;
    spPassword            : String[8];
    spServer              : String[100];
    spUseMapi             : Boolean;
    Spare                 : Array[1..80] of char;
  end;

  TpaCompanySysParams = Record
    Company                : String[6];
    spAuthSQU              : Boolean;
    spAuthPQU              : Boolean;
    spAuthPOR              : Boolean;
    spAuthPIN              : Boolean;
    spSQUForm              : String[8];
    spPQUForm              : String[8];
    spPORForm              : String[8];
    spPINForm              : String[8];
    spAuthMode             : Byte; //maps to AuthModeType
    spAllowPrint           : Boolean;
    spFloorOnPins          : Boolean;
    spAuthOnConvert        : Boolean;
    spPINTolerance         : Double;
    spLastPINCheck         : TDateTime;
    spPINCheckInterval     : SmallInt;
    Spare                  : Array[1..278] of char;
  end;


  AuthFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..AuNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  UserFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..usNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  ReqFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..reNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  GpFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..gpNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  CpFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..cpNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

Const
  ebRemoteDirSw  =  '/DIR:';

Var
  eBSetDrive  :  AnsiString = '';


  AuthRec : TPaAuthorizerRec;
  AuthFile : AuthFileDef;

  UserRec : TPaUserRec;
  UserFile : UserFileDef;

  RequestRec : TpaRequestRec;
  RequestFile : ReqFileDef;

  GlobalParamsRec : TpaGlobalSysParams;
  GlobalParamsFile : GpFileDef;

  CompanyParamsRec : TpaCompanySysParams;
  CompanyParamsFile : CpFileDef;

  EntDir : AnsiString;

  DebugModeOn : Boolean;
  MapiOK : Boolean;

  AttachPrinter : AnsiString;

  CheckPINInterval : longint;


implementation

uses
  SysUtils, Forms, IniFiles, FileUtil;

var
  s : ShortString;

function GetMultiCompDir : ansistring;
const
  WORKSTATION_REPLICATION_INI = 'ENTWREPL.INI';
  SECTION_NAME = 'UpdateEngine';
  KEY_NAME = 'NetworkDir';
var
  Directory : ansistring;
  ShortDir  : ansistring;
begin
  Result:='';  ShortDir:='';

  If (ebSetDrive='') then
    Directory := ExtractFilePath(Application.ExeName)
  else
    Directory:=ebSetDrive;

  with TIniFile.Create(Directory+WORKSTATION_REPLICATION_INI) do
  try
    Result := ReadString(SECTION_NAME, KEY_NAME, '');
  finally
    Free;
  end;
  if Trim(Result) = '' then
    Result := Directory;

  ShortDir:=ExtractShortPathName(Result);

  If (ShortDir<>'') then
    Result:=ShortDir;
end;


procedure DefineAuthorizer;
const
  Idx = AuthF;
begin
  FileSpecLen[Idx] := SizeOf(AuthFile);
  FillChar(AuthFile, FileSpecLen[Idx],0);

  with AuthFile do
  begin
    RecLen := Sizeof(AuthRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := auNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - CompanyCode + Name
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := 2;
    KeyBuff[1].KeyLen := 6;
    KeyBuff[1].KeyFlags := DupModSeg;

    //Authorizer name = String[60]
    KeyBuff[2].KeyPos := BtKeyPos(@AuthRec.auName[1], @AuthRec);
    KeyBuff[2].KeyLen := 60;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 1 - Authorization amount
    // CompanyCode = string[6]
    KeyBuff[3].KeyPos := 2;
    KeyBuff[3].KeyLen := 6;
    KeyBuff[3].KeyFlags := DupModSeg;

    //Authoriz limit = Int64 (8 bytes)
    KeyBuff[4].KeyPos := 69;
    KeyBuff[4].KeyLen := 8;
    KeyBuff[4].KeyFlags := DupModSeg + ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    // CompanyCode = string[6]
    KeyBuff[5].KeyPos := BTKeyPos(@AuthRec.auEndAmountChar, @AuthRec);
    KeyBuff[5].KeyLen := 1;
    KeyBuff[5].KeyFlags := DupMod;



    //Key 2 - CompanyCode + Email address

    // CompanyCode = string[6]
    KeyBuff[6].KeyPos := 2;
    KeyBuff[6].KeyLen := 6;
    KeyBuff[6].KeyFlags := DupModSeg;

    //Authorizer email = String[100]
    KeyBuff[7].KeyPos := BtKeyPos(@AuthRec.auEmail[1], @AuthRec);;
    KeyBuff[7].KeyLen := 100;
    KeyBuff[7].KeyFlags := DupMod;

    //Key 3 - CompanyCode + AuthCode
    // CompanyCode = string[6]
    KeyBuff[8].KeyPos := 2;
    KeyBuff[8].KeyLen := 6;
    KeyBuff[8].KeyFlags := DupModSeg;

    //Authorizer code = String[10]
    KeyBuff[9].KeyPos := BtKeyPos(@AuthRec.auAuthCode[1], @AuthRec);;
    KeyBuff[9].KeyLen := 10;
    KeyBuff[9].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(AuthRec);
  FillChar(AuthRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @AuthRec;
  FileSpecOfS[Idx] := @AuthFile;
  FileNames[Idx] := EntDir + AuthFilename;
end;

procedure DefineUser;
const
  Idx = UserF;
begin
  FileSpecLen[Idx] := SizeOf(UserFile);
  FillChar(UserFile, FileSpecLen[Idx],0);

  with UserFile do
  begin
    RecLen := Sizeof(UserRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := usNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := BtKeyPos(@UserRec.usCompany[1], @UserRec);
    KeyBuff[1].KeyLen := SizeOf(UserRec.usCompany) - 1;
    KeyBuff[1].KeyFlags := DupModSeg;
    //UserID = String[10]
    KeyBuff[2].KeyPos := BtKeyPos(@UserRec.usUserID[1], @UserRec);;
    KeyBuff[2].KeyLen := SizeOf(UserRec.usUserID) - 1;
    KeyBuff[2].KeyFlags := DupMod;



    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(UserRec);
  FillChar(UserRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @UserRec;
  FileSpecOfS[Idx] := @UserFile;
  FileNames[Idx] := EntDir + UserFilename;
end;

procedure DefineRequest;
const
  Idx = RequestF;
begin
  FileSpecLen[Idx] := SizeOf(RequestFile);
  FillChar(RequestFile, FileSpecLen[Idx],0);

  with RequestFile do
  begin
    RecLen := Sizeof(RequestRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := reNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - CompanyCode + EAR
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := 2;
    KeyBuff[1].KeyLen := 6;
    KeyBuff[1].KeyFlags := DupModSeg;

    KeyBuff[2].KeyPos := 9;
    KeyBuff[2].KeyLen := 50;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 1 - CompanyCode + Date
    // CompanyCode = string[6]
    KeyBuff[3].KeyPos := 2;
    KeyBuff[3].KeyLen := 6;
    KeyBuff[3].KeyFlags := DupModSeg;

    KeyBuff[4].KeyPos := BtKeyPos(@RequestRec.reTimestamp[1], @RequestRec);
    KeyBuff[4].KeyLen := 12;
    KeyBuff[4].KeyFlags := DupMod;

    //Key 2 - CompanyCode + OurRef
    // CompanyCode = string[6]
    KeyBuff[5].KeyPos := 2;
    KeyBuff[5].KeyLen := 6;
    KeyBuff[5].KeyFlags := DupModSeg;

    KeyBuff[6].KeyPos := BtKeyPos(@RequestRec.reOurRef[1], @RequestRec);
    KeyBuff[6].KeyLen := SizeOf(RequestRec.reOurRef) - 1;
    KeyBuff[6].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(RequestRec);
  FillChar(RequestRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @RequestRec;
  FileSpecOfS[Idx] := @RequestFile;
  FileNames[Idx] := EntDir + RequestFilename;
end;

procedure DefineGlobalParams;
const
  Idx = GlobalParamsF;
begin
  FileSpecLen[Idx] := SizeOf(GlobalParamsFile);
  FillChar(GlobalParamsFile, FileSpecLen[Idx],0);

  with GlobalParamsFile do
  begin
    RecLen := Sizeof(GlobalParamsRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := gpNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    KeyBuff[1].KeyPos := 2;
    KeyBuff[1].KeyLen := 6;
    KeyBuff[1].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(GlobalParamsRec);
  FillChar(GlobalParamsRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @GlobalParamsRec;
  FileSpecOfS[Idx] := @GlobalParamsFile;
  FileNames[Idx] := EntDir + GlobalParamsFilename;
end;

procedure DefineCompanyParams;
const
  Idx = CompanyParamsF;
begin
  FileSpecLen[Idx] := SizeOf(CompanyParamsFile);
  FillChar(CompanyParamsFile, FileSpecLen[Idx],0);

  with CompanyParamsFile do
  begin
    RecLen := Sizeof(CompanyParamsRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := cpNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := 2;
    KeyBuff[1].KeyLen := 6;
    KeyBuff[1].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(CompanyParamsRec);
  FillChar(CompanyParamsRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @CompanyParamsRec;
  FileSpecOfS[Idx] := @CompanyParamsFile;
  FileNames[Idx] := EntDir + CompanyParamsFilename;
end;

function CheckSizes : ShortString;
begin
  Result := '';
  if SizeOf(AuthRec) > MaxPaRecSize then
    Result := Result + 'AuthRec ';
  if SizeOf(UserRec) > MaxPaRecSize then
    Result := Result + 'UserRec ';
  if SizeOf(RequestRec) > MaxPaRecSize then
    Result := Result + 'RequestRec ';
  if SizeOf(GlobalParamsRec) > MaxPaRecSize then
    Result := Result + 'GlobalParamsRec ';
  if SizeOf(CompanyParamsRec) > MaxPaRecSize then
    Result := Result + 'CompanyParamsRec ';
end;




Initialization
  EntDir := IncludeTrailingBackslash(GetEnterpriseDirectory);
  s := CheckSizes;
  if s <> '' then
    raise Exception.create('Invalid record size: ' + s);

  DefineAuthorizer;
  DefineUser;
  DefineRequest;
  DefineGlobalParams;
  DefineCompanyParams;

end.
