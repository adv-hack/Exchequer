unit AuthVar;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  GlobVar, BtrvU2;

const

  earError = -1;
  earAuthorized = 0;
  earSentForAuthorization = 1;
  earNotInAuthTypes = 2;
  earNotRequired = 3;

  MaxPaRecSize = 650;

  AuthF      = 1;
  UserF      = 2;
  RequestF   = 3;
  GlobalParamsF = 4;
  CompanyParamsF = 5;

  AuthNameIdx = 0;
  AuthValIdx = 1;
  AuthEmailIdx = 2;

  ReqEARIdx = 0;
  ReqDateIdx = 1;

  PaPath = 'PurAuth\';

  PaTypeGlob = 0;
  PaTypeComp = 1;
  PaTypeAuth = 2;
  PaTypeUser = 3;
  PaTypeRequest = 4;

  AuthFilename = PaPath + 'PaAuth.dat';
  UserFileName = PaPath + 'PaUser.dat';
  RequestFileName = PaPath + 'PaEar.dat';
  GlobalParamsFilename = PaPath + 'PaGlobal.Dat';
  CompanyParamsFilename = PaPath + 'PaComp.Dat';

  PaMessageFile = PaPath + 'PaMsg.txt';

  AuNumOfKeys = 3;
  AuNumSegments =5;

  UsNumOfKeys = 1;
  UsNumSegments = 2;

  ReNumOfKeys = 2;
  ReNumSegments = 3;

  GpNumOfKeys = 1;
  GpNumSegments = 1;

  CpNumOfKeys = 1;
  CpNumSegments = 1;


type

  TpaAuthorizerRec = Record
   Company                : String[6];
   auName                 : String[60];
   auMaxAuthAmount        : Int64;
   auEMail                : String[100];
   auAuthCode             : String[10];
   auAuthSQU              : Boolean;
   auAuthPQU              : Boolean;
   auAuthPOR              : Boolean;
   auAuthPIN              : Boolean;
   Active                 : Boolean;
   Spare                  : Array[1..200] of char;
  end;

  TpaUserRec       = Record
    usCompany             : String[6];
    usUserID              : String[10];
    usUserName            : String[30];
    usEMail               : string[100];
    usFloorLimit          : Double;
    usAuthAmount          : Double;
    usSendOptions         : Char;
    Spare                 : Array[1..300] of char;
  end;

  TpaRequestRec = Record
    Company               : String[6];
    reEAR                 : String[50];
    reOurRef              : String[10];
    reUserID              : String[10];
    reTimeStamp           : String[8];
    reTotalValue          : Double;
    Spare                 : Array[1..300] of char;
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
    Spare                 : Array[1..190] of char;
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
    Spare                  : Array[1..300] of char;
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

var

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


implementation

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
    KeyBuff[2].KeyPos := 9;
    KeyBuff[2].KeyLen := 60;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 1 - Authorization amount
    //Authoriz limit = Double (8 bytes)
    KeyBuff[3].KeyPos := 69;
    KeyBuff[3].KeyLen := 8;
    KeyBuff[3].KeyFlags := DupMod + ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    //Key 2 - CompanyCode + Email address

    // CompanyCode = string[6]
    KeyBuff[4].KeyPos := 2;
    KeyBuff[4].KeyLen := 6;
    KeyBuff[4].KeyFlags := DupModSeg;

    //Authorizer email = String[100]
    KeyBuff[5].KeyPos := BtKeyPos(@AuthRec.auEmail[1], @AuthRec);;
    KeyBuff[5].KeyLen := 100;
    KeyBuff[5].KeyFlags := DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(AuthRec);
  FillChar(AuthRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @AuthRec;
  FileSpecOfS[Idx] := @AuthFile;
  FileNames[Idx] := AuthFilename;
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
  FileNames[Idx] := UserFilename;
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

    //Key 1 - Date
    KeyBuff[3].KeyPos := BtKeyPos(@RequestRec.reTimestamp[1], @RequestRec);
    KeyBuff[3].KeyLen := 8;
    KeyBuff[3].KeyFlags := DupMod;


    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(RequestRec);
  FillChar(RequestRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @RequestRec;
  FileSpecOfS[Idx] := @RequestFile;
  FileNames[Idx] := RequestFilename;
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
  FileNames[Idx] := GlobalParamsFilename;
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
  FileNames[Idx] := CompanyParamsFilename;
end;



Initialization
  DefineAuthorizer;
  DefineUser;
  DefineRequest;
  DefineGlobalParams;
  DefineCompanyParams;

end.
