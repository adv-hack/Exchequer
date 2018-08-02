unit elvar;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN SYMBOL_PLATFORM OFF}
{Have one file for Elert recs, one for EmailAddresses, SMSNumbers, and
output lines, linked on UserIDcode & unique (within co) ElertName}
interface

uses
  GlobVar, BtrvU2, {$IFDEF ELMAN}Enterprise01_TLB,{$ELSE}Enterprise04_TLB,{$ENDIF} Classes, SyncObjs, Windows;

const
  MaxEngines = 8;
  MaxEngineMisses = 3;

  PollInterval = 500;

  hcSMSSenderDlg = 0;

  ElPath = 'SMAIL\';
  S_COMMON_LOG = '.___';

  MaxLineRecSize = 984;
  TotElertFiles = 20;

  MaxSMSLength = 160;

  MaxRetries = 5;

  //PR: 08/07/2013 ABSEXCH-14438 Rebranding

  ElSMSTrailer = ' Sent by Sentimail (c) Advanced Enterprise Software.';
  ElSMSTrailer2 = ' Sentimail (c) Advanced Enterprise Software.';
  ElSMSTrailer3 = ' (c) Advanced Enterprise Software';
  ElSMSTrailer4 = ' (c) AES';

  ElEmailTrailer = #13 + #13 + ElSMSTrailer;

  //line record prefixes
  pxElOutput   = 'O';
  pxElEmail    = 'E';
  pxElSMS      = 'S';
  pxElRecsSent = 'R';
  pxElEvent    = 'V';
  pxElRespawn  = 'W';
  pxSysRec     = 'Z';
  pxRemoteEmail= 'A';
  pxTriggered  = 'T';

  //output types
  otLogic         = 'L';
  otParams        = 'P';
  otSMS           = 'S';
  otEmailSubject  = 'B';
  otEmailHeader   = 'E';
  otEmailLine     = 'N';
  otEmailTrailer  = 'T';
  otReport        = 'R';
  otCSV           = 'C';

  otSMS2Go        = 'M';
  otEmailSub2Go   = 'J';
  otEmail2Go      = 'I';
  otEmailAdd2Go   = 'D';
  otReport2Go     = 'O';
  otCSV2Go        = 'V';
  otSMSNumber2Go  = 'U';
  otSMSMarker     = 'K';

  otFaxNo           = 'X';
  otFaxFrom         = 'F';
  otRepEmailAdd     = 'A';
  otRepEmailSubject = 'Y'; //ran out of meaningful letters
  otRepEmailLine    = 'Z';
  otRepPrinter      = 'H';
  otFaxNoteLine     = 'G';  //for 'gnotes'?

  otEDF2Go          = 'Q';

  otSysRec          = 'Z';


  Outputs2Go = [otSMS2Go, otEmailSub2Go, otEmail2Go, otEmailAdd2Go, otReport2Go,
                otCSV2Go, otSMSNumber2Go, otSMSMarker, otEDF2Go];
                
  ElertFileName   = ELPath + 'Sent.dat';
  LineFileName    = ELPath + 'SentLine.Dat';
  SysFileName     = 'SentSys.dat';


  ElertBase = 19;

  ElertF   = ElertBase + 1;
  LineF    = ElertBase + 2;

  ElertNumofKeys   = 4;
  ElertNumSegments = 11;

  elIdxElertName = 0;
  elIdxParent  = 1;
  elIdxType  = 2;
  elIdxEvent = 3;

  LineNumofKeys   = 4;
  LineNumSegments = 19;

  ellIdxOutputType = 0;
  ellIdxLineType = 1;
  ellIdxElert = 2;
  ellIdxExclude = 3;

  EmailTypes : Array[0..2] of String[3] = ('To', 'CC', 'BCC');

  MinutesToHangUp = 15;

  //Purge options
  poHistory       = 1;
  poEvents        = 2;
  poCurrentOutput = 4;

  elServiceDesc = 'Runs sentinels to send alerts and reports from the Exchequer system.';

  ServiceTimeOut = 60;

  elEngineTimeStampMinutes = 5; //Minutes after which an engine will be assumed to be no longer running.

  S_FINISHED = '<Finish>';

type

   TElOpenThread = Class(TThread)
   public
     property Terminated;
   end;

//PR: 15/08/2012 moved structures into an include file to allow use by SQL Conversion.
{$I w:\entrprse\sentmail\sentinel\sentstructures.inc}

  //File defs

  ElertFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..ElertNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  LineFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..LineNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

const
  Report2GoSet = [esReportEmailReadyToGo..esReportBothReadyToGo];
  csvCopyReadyToGoSet  = [esCopyReadyToGo, esFTPAndCopyReadyToGo, esCopyAndEmailReadyToGo,
                          esAllCSVReadyToGo];
  csvFTPReadyToGoSet   = [esFTPReadyToGo, esFTPAndCopyReadyToGo, esFTPandEmailReadyToGo,
                          esAllCSVReadyToGo];
  csvEmailReadyToGoSet = [esCSVEmailReadyToGo, esCopyAndEmailReadyToGo, esFTPandEmailReadyToGo,
                          esAllCSVReadyToGo];
  CSV2GoSet = [esCopyReadyToGo..esAllCSVReadyToGo];
  Ready2GoSet = [esSMSReadyToGo, esEmailReadyToGo, esBothReadyToGo] + Report2GoSet + CSV2GoSet;
  RunningSet = [esInProcess, esInSendProcess];

  ConveyorSet = [spConveyor, spReportConveyor, spCSVConveyor, spVisualReportConveyor];
  QuerySet    = [spQuery, spReport, spReportQuery];


  function LJVar(const Value : ShortString; len : integer) : ShortString;
  procedure DefineFiles(const WhichDir : String);
  function MakeElertNameKey(const UID : String;
                            const ELName : String;
                            const ELParent : String = '') : Str255;

  function IntKey(i : longInt) : ShortString;

  procedure ShowNoSentinelsLeftMessage;

  function CheckLicenceOK : Boolean;

  function IsToday(const s : string; AType : Byte) : Boolean;

  function SentinelsLicenced : longint;
  function CheckSentinelsOK : Boolean;
  function NoOfUnusedSentinels : SmallInt;
  function SentinelsUsed : longint;  

  function SysUser : string;
  function SysElertName : string;

  function BlankWorkStation : string;

  procedure ResetCloseFlags;
  procedure SetWantToClose;
  function WantToClose : Boolean;
  function OKToClose : Boolean;
  function Query_WantToClose : Boolean;

  procedure UpdateQueryTick(var ARec : TElertRec);
  procedure ResetQueryTick(var ARec : TElertRec);

  procedure SetQuery_OKToClose(SetOn : Boolean);
  function GetQuery_OKToClose : Boolean;

//  function GetCompanyCode(const AToolkit : IToolkit; const Path : string) : string;
  function Localise(const APath: string): string;

  Function IsWindows7 : Boolean;

  Function ElVersion : string;

  {$IFDEF SCHEDULER}
   procedure LogIt(Where : TSentinelPurpose; s : ShortString; StandardDebug : Boolean = False);
  {$ENDIF}
  {$IFDEF PALL}
     procedure WriteToPalladiumLog(s : string);
  {$ENDIF}
var

  ElertRec    : TElertRec;
  ElertFile   : ElertFileDef;

  LineRec     : TElertLineRec;
  LineFile    : LineFileDef;

{  AddressRec  : TElertEmailAddressRec;
  AddressFile : AddressFileDef;

  SMSRec      : TElertSMSRec;
  SMSFile     : SMSFileDef;

  RecsSentRec : TElertRecSentRec;
  RecsSentFile: RecsSentFileDef; }

  EntDir      : AnsiString;

  QueryAborted,
  ConveyorAborted,
  ReportAborted : Boolean;

  oToolkit : IToolkit;

  LastFTPError, LastEmailError, LastSMSError : string;

  SentinelsSoFar : SmallInt;
  SentinelsAllowed : SmallInt;

//  MainToolkit : IToolkit;

  GlobalEntPath: string;

  WorkStationName : string;

  LastConveyorTick : TDateTime;
  LastQueryTick : TDateTime;

  Conveyor_OKToClose,
  Poller_OKToClose : Boolean;

  Conveyor_WantToClose,
  FQuery_WantToClose,
  Poller_WantToClose : Boolean;

  DebugModeOn : Boolean;

  RepPasswordList : TStringList;

  AllowDebugInfo : Boolean; //Show records by double clicking on admin form

  ReportsAvailable : Boolean = False;
  VisualReportsAvailable : Boolean = False;

  ConveyorInUse, QueryInUse : Boolean;

  {$IFDEF PALL}
  LogFName : string;
  {$ENDIF}
  ServiceMappedDrive, ServiceLocalDir : string;
  QueryLock, ConveyorLock : TCriticalSection;

implementation

uses
  SysUtils, Forms,
  {$IFNDEF SENTHOOK}
  {$IFNDEF ADMINONLY}
  {$IFNDEF SCHEDULER}
  {$IFNDEF V6CONV}
  DebugLog,
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  IniFiles,
  {$IFNDEF ADMINONLY}
  {$IFNDEF V6CONV}
  SentLic,
  {$ENDIF}
  {$ENDIF}
  dialogs,
  StrUtils,
  ExchequerRelease;

var
   eBSetDrive  :  AnsiString = '';
   Query_OKToClose : Boolean;

const
  BuildNo = '174';

function IntKey(i : longInt) : ShortString;
var
  s : ShortString;
begin
  s := StringOfChar(' ', SizeOf(i));
  Move(i, s[1], sizeOf(i));
  Result := s;
end;

Function ElVersion : string;
begin
  Result := ExchequerModuleVersion(emSentimail, BuildNo);
end;



procedure DefineElert;
const
  Idx = ElertF;
begin
  FileSpecLen[Idx] := SizeOf(ElertFile);
  FillChar(ElertFile, FileSpecLen[Idx],0);

  with ElertFile do
  begin
    RecLen := Sizeof(ElertRec);
{$IFDEF EX600}
    PageSize := 2048; //DefPageSize * 2;
{$ELSE}
    PageSize := 1024; //DefPageSize;
{$ENDIF}
    NumIndex := ElertNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - UserID code + ElertName
    // UserIDCode = string[6]
    KeyBuff[1].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[1].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[1].KeyFlags := DupModSeg;
    //ElertName = String[12]
    KeyBuff[2].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);;
    KeyBuff[2].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[2].KeyFlags := DupMod;

    //Key 1 - UserID Code + Parent + Name
    // UserIDCode = string[6]
    KeyBuff[3].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[3].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[3].KeyFlags := DupModSeg;
    //Parent = String[30]
    KeyBuff[4].KeyPos := BtKeyPos(@ElertRec.elParent[1], @ElertRec);;
    KeyBuff[4].KeyLen := SizeOf(ElertRec.elParent) - 1;
    KeyBuff[4].KeyFlags := DupModSeg;

    KeyBuff[5].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);
    KeyBuff[5].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[5].KeyFlags := DupMod;

    //Key 2 - UserID Code + Name + Type
    // UserIDCode = string[6]
    KeyBuff[6].KeyPos := BtKeyPos(@ElertRec.elUserID[1], @ElertRec);
    KeyBuff[6].KeyLen := SizeOf(ElertRec.elUserID) - 1;
    KeyBuff[6].KeyFlags := DupModSeg;
    //Name = String[12]
    KeyBuff[7].KeyPos := BtKeyPos(@ElertRec.elElertName[1], @ElertRec);;
    KeyBuff[7].KeyLen := SizeOf(ElertRec.elElertName) - 1;
    KeyBuff[7].KeyFlags := DupModSeg;

    KeyBuff[8].KeyPos := BtKeyPos(@ElertRec.elType, @ElertRec);
    KeyBuff[8].KeyLen := SizeOf(ElertRec.elType);
    KeyBuff[8].KeyFlags := DupMod;


    //Key 3 - WindowID + HandlerID + TermChar
    KeyBuff[9].KeyPos := BtKeyPos(@ElertRec.elWindowID, @ElertRec);;
    KeyBuff[9].KeyLen := SizeOf(ElertRec.elWindowID);
    KeyBuff[9].KeyFlags := DupModSeg + ExtType;
    KeyBuff[9].ExtTypeVal:=BInteger;

    KeyBuff[10].KeyPos := BtKeyPos(@ElertRec.elHandlerID, @ElertRec);;
    KeyBuff[10].KeyLen := SizeOf(@ElertRec.elHandlerID);
    KeyBuff[10].KeyFlags := DupModSeg + ExtType;
    KeyBuff[10].ExtTypeVal:=BInteger;

    //Terminating char = '!'
    KeyBuff[11].KeyPos := BtKeyPos(@ElertRec.elTermChar, @ElertRec);;
    KeyBuff[11].KeyLen := SizeOf(ElertRec.elTermChar);
    KeyBuff[11].KeyFlags := DupMod;



    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(ElertRec);
  FillChar(ElertRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @ElertRec;
  FileSpecOfS[Idx] := @ElertFile;
  FileNames[Idx] := EntDir + ElertFilename;
end;

procedure DefineLine;
const
  Idx = LineF;
begin
  FileSpecLen[Idx] := SizeOf(LineFile);
  FillChar(LineFile, FileSpecLen[Idx],0);

  with LineFile do
  begin
    RecLen := Sizeof(LineRec);
{$IFDEF EX600}
    PageSize := 2048; //DefPageSize * 2;
{$ELSE}
    PageSize := 1024; //DefPageSize;
{$ENDIF}
    NumIndex := LineNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    //Key 0 Pfix + UserID + ElertName + Instance + Outputtype + MsgInstance + LineNo
    KeyBuff[1].KeyPos := BtKeyPos(@LineRec.Prefix, @LineRec);
    KeyBuff[1].KeyLen := SizeOf(LineRec.Prefix);
    KeyBuff[1].KeyFlags := DupModSeg;
    // UserIDCode = string[6]
    KeyBuff[2].KeyPos := BtKeyPos(@LineRec.Output.eoUserID[1], @LineRec);
    KeyBuff[2].KeyLen := SizeOf(LineRec.Output.eoUserID) - 1;
    KeyBuff[2].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[3].KeyPos := BtKeyPos(@LineRec.Output.eoElertName[1], @LineRec);;
    KeyBuff[3].KeyLen := SizeOf(LineRec.Output.eoElertName) - 1;
    KeyBuff[3].KeyFlags := DupModSeg;

    //Instance = SmallInt
    KeyBuff[4].KeyPos := BtKeyPos(@LineRec.Output.eoInstance, @LineRec);;
    KeyBuff[4].KeyLen := SizeOf(LineRec.Output.eoInstance);
    KeyBuff[4].KeyFlags := DupModSeg + ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    //OutputType = Char
    KeyBuff[5].KeyPos := BtKeyPos(@LineRec.Output.eoOutputType, @LineRec);;
    KeyBuff[5].KeyLen := SizeOf(LineRec.Output.eoOutputType);
    KeyBuff[5].KeyFlags := DupModSeg;

    //MsgInstance = SmallInt
    KeyBuff[6].KeyPos := BtKeyPos(@LineRec.Output.eoMsgInstance, @LineRec);;
    KeyBuff[6].KeyLen := SizeOf(LineRec.Output.eoMsgInstance);
    KeyBuff[6].KeyFlags := DupModSeg + ExtType;
    KeyBuff[6].ExtTypeVal:=BInteger;

    //LineNo = SmallInt
    KeyBuff[7].KeyPos := BtKeyPos(@LineRec.Output.eoLineNo, @LineRec);;
    KeyBuff[7].KeyLen := SizeOf(LineRec.Output.eoLineNo);
    KeyBuff[7].KeyFlags := DupModSeg + ExtType;
    KeyBuff[7].ExtTypeVal:=BInteger;

    //Terminating char = '!'
    KeyBuff[8].KeyPos := BtKeyPos(@LineRec.Output.eoTermChar, @LineRec);;
    KeyBuff[8].KeyLen := SizeOf(LineRec.Output.eoTermChar);
    KeyBuff[8].KeyFlags := DupMod;

    //Key 1 - Prefix + UserID + ElertName
    KeyBuff[9].KeyPos := BtKeyPos(@LineRec.Prefix, @LineRec);
    KeyBuff[9].KeyLen := SizeOf(LineRec.Prefix);
    KeyBuff[9].KeyFlags := DupModSeg;

    KeyBuff[10].KeyPos := BtKeyPos(@LineRec.Output.eoUserID[1], @LineRec);
    KeyBuff[10].KeyLen := SizeOf(LineRec.Output.eoUserID) - 1;
    KeyBuff[10].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[11].KeyPos := BtKeyPos(@LineRec.Output.eoElertName[1], @LineRec);;
    KeyBuff[11].KeyLen := SizeOf(LineRec.Output.eoElertName) - 1;
    KeyBuff[11].KeyFlags := DupMod;

    //Key 2 - UserID + ElertName
    KeyBuff[12].KeyPos := BtKeyPos(@LineRec.Output.eoUserID[1], @LineRec);
    KeyBuff[12].KeyLen := SizeOf(LineRec.Output.eoUserID) - 1;
    KeyBuff[12].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[13].KeyPos := BtKeyPos(@LineRec.Output.eoElertName[1], @LineRec);;
    KeyBuff[13].KeyLen := SizeOf(LineRec.Output.eoElertName) - 1;
    KeyBuff[13].KeyFlags := DupMod;

    //Key 3 - Pfix + User + ElertName + RecsSentID + RecsSentLIneNo + TermChar
    KeyBuff[14].KeyPos := BtKeyPos(@LineRec.Prefix, @LineRec);
    KeyBuff[14].KeyLen := SizeOf(LineRec.Prefix);
    KeyBuff[14].KeyFlags := DupModSeg;
    // UserIDCode = string[6]
    KeyBuff[15].KeyPos := BtKeyPos(@LineRec.RecsSent.ersUserID[1], @LineRec);
    KeyBuff[15].KeyLen := SizeOf(LineRec.RecsSent.ersUserID) - 1;
    KeyBuff[15].KeyFlags := DupModSeg;
    //ElertName = String[30]
    KeyBuff[16].KeyPos := BtKeyPos(@LineRec.RecsSent.ersElertName[1], @LineRec);;
    KeyBuff[16].KeyLen := SizeOf(LineRec.RecsSent.ersElertName) - 1;
    KeyBuff[16].KeyFlags := DupModSeg;

    //Recs ID - String[60]
    KeyBuff[17].KeyPos := BtKeyPos(@LineRec.RecsSent.ersID[1], @LineRec);;
    KeyBuff[17].KeyLen := SizeOf(LineRec.RecsSent.ersID) - 1;
    KeyBuff[17].KeyFlags := DupModSeg;
    //Lineno - LongInt
    KeyBuff[18].KeyPos := BtKeyPos(@LineRec.RecsSent.ersLineNo, @LineRec);;
    KeyBuff[18].KeyLen := SizeOf(LineRec.RecsSent.ersLineNo);
    KeyBuff[18].KeyFlags := DupModSeg + ExtType;
    KeyBuff[18].ExtTypeVal:=BInteger;

    //TermChar = Char
    KeyBuff[19].KeyPos := BtKeyPos(@LineRec.RecsSent.ersTermChar, @LineRec);;
    KeyBuff[19].KeyLen := SizeOf(LineRec.RecsSent.ersTermChar);
    KeyBuff[19].KeyFlags := DupMod;


    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(LineRec);
  FillChar(LineRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @LineRec;
  FileSpecOfS[Idx] := @LineFile;
  FileNames[Idx] := EntDir + LineFilename;
end;


procedure DefineFiles(const WhichDir : String);
begin
  EntDir := '';
  //SetDrive := WhichDir;

  DefineElert;
  DefineLine;

end;

function MakeElertNameKey(const UID : String;
                          const ELName : String;
                          const ELParent : String = '') : Str255;
begin
  Result := LJVar(UID, UIDSize) +
{            LJVar(ElParent, 30) +} //uncomment when ready
            LJVar(ElName, 30);
end;

function LJVar(const Value : ShortString; len : integer) : ShortString;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;

function SentinelCount(const DataPath : string) : integer;
var
  Status : integer;
  keys : str255;
begin
  Result := 0;
  Status := Open_File(F[ElertF], IncludeTrailingBackSlash(DataPath) + Filenames[ElertF], -2);
  if Status = 0 then
  begin
    Status := Find_Rec(B_GetFirst, F[ElertF], ElertF, ElertRec, 0, KeyS);
    while Status = 0 do
    begin
      if (Copy(ElertRec.elUserID, 1, 5) <> '_SYS_') and (Trim(ElertRec.elUserID) <> '') then
        inc(Result);

      Status := Find_Rec(B_GetNext, F[ElertF], ElertF, ElertRec, 0, KeyS);
    end;
//    Result := Used_Recs(F[ElertF], ElertF);
    Close_File(F[ElertF]);
  end
  else
    Result := 0;
end;


function SentinelsLicenced : longint;
begin
  Result := SentinelsAllowed;
end;

function SentinelsUsed : longint;
var
  i : integer;
begin
    {$IFDEF PALL}
    WriteToPalladiumLog('Start SentinelsUsed');
    {$ENDIF}
  Result := 0;
  if Assigned(oToolkit) then
    with oToolkit.Company do
      for i := 1 to cmCount do
        Result := Result + SentinelCount(Trim(cmCompany[i].coPath));
    {$IFDEF PALL}
    WriteToPalladiumLog('End SentinelsUsed');
    {$ENDIF}
end;

function NoOfUnusedSentinels : SmallInt;
begin
  Result := SentinelsLicenced - SentinelsUsed;
end;

function CheckSentinelsOK : Boolean;
begin
  Result := SentinelsSoFar < SentinelsLicenced;
end;


procedure ShowNoSentinelsLeftMessage;
begin
  ShowMessage('This installation is licenced for ' + IntToStr(SentinelsLicenced) +
               ' sentinels. This number has been reached.'#10 +
               'Please contact your Exchequer dealer to licence further sentinels');
end;

function IsToday(const s : string; AType : Byte) : Boolean;
begin
  Result := (AType in [1, 2]) and
            ((UpperCase(s) = 'TODAY') or
             (UpperCase(s) = 'CURRENT PERIOD'));
end;


function CheckLicenceOK : Boolean;
var
  sLic : SmallInt;
begin
{$IFNDEF V6CONV}
{$IFNDEF ADMINONLY}
  sLic := GetSentLicence(SentinelsAllowed);
  if  sLic = slLicenced then
  begin
    Result := True;
  end
  else
  begin
  {$IFNDEF SERVICE}
    if sLic = slNotLicenced then
      ShowSentNotLicencedMessage
    else
      ShowSentLicenceErrorMessage;
  {$ENDIF}
    Result := False;
  end;
{$ENDIF}
{$ENDIF}
end;

function SysUser : string;
begin
  Result := LJVar(' _Sys', 10);
end;

function SysElertName : string;
begin
  Result := LJVar(' _Sys', 30);
end;

function BlankWorkStation : string;
begin
  StringOfChar(' ', 30);
end;

procedure ResetCloseFlags;
begin
  Conveyor_OKToClose := True;
  Query_OKToClose := True;
  Poller_OKToClose := True;

  Conveyor_WantToClose := False;
  FQuery_WantToClose := False;
  Poller_WantToClose := False;
end;

procedure SetWantToClose;
begin
  Conveyor_OKToClose := True;
  Query_OKToClose := True;
  Poller_OKToClose := True;
end;

function OKToClose : Boolean;
begin
  Result := Conveyor_OKToClose and
            Query_OKToClose and
            Poller_OKToClose;
end;

function WantToClose : Boolean;
begin
  if Conveyor_WantToClose and
    Query_WantToClose and
    Poller_WantToClose
  then
    Result := True
  else
    Result := False;

end;

function Query_WantToClose : Boolean;
begin
  Result := FQuery_WantToClose;
end;

{$IFDEF PALL}
procedure WriteToPalladiumLog(s : string);
var
  F : File;
  crlf : string;
begin
  crlf := #13#10;
  AssignFile(F, LogFName);
  if not FileExists(LogFName) then
    Rewrite(F, 1)
  else
  begin
    Reset(F, 1);
    Seek(F, FileSize(F));
  end;
  s := FormatDateTime('hh:nn:ss> ', Now) + s;
  BlockWrite(F, s[1], Length(s));
  BlockWrite(F, crlf[1], 2);
  CloseFile(F);
end;
{$ENDIF}

procedure UpdateQueryTick(var ARec : TElertRec);
begin
  Arec.elQueryStart := Now;
end;

procedure ResetQueryTick(var ARec : TElertRec);
begin
  Arec.elQueryStart := 0;
end;

procedure SetQuery_OKToClose(SetOn : Boolean);
var
  s : string;
begin
  Query_OKToClose := SetOn;
  if SetOn then
    s := 'On'
  else
    s := 'Off';
  {$IFNDEF SENTHOOK}
  {$IFNDEF ADMINONLY}
  {$IFNDEF SCHEDULER}
  {$IFNDEF V6CONV}
  LogIt(spQuery, 'Query_OkToClose set ' + s);
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
  {$ENDIF}
end;

function GetQuery_OKToClose : Boolean;
begin
  Result := Query_OKToClose;
end;
(*
function GetCompanyCode(const AToolkit : IToolkit; const Path : string) : string;
var
  i : integer;
begin
  Result := '';
  if Assigned(AToolkit) then
  with AToolkit.Company do
  for i := 1 to cmCount do
  begin
  {$IFNDEF SERVICE}
    if Trim(UpperCase(Path)) = Trim(UpperCase(cmCompany[i].coPath)) then
  {$ELSE}
    if Trim(UpperCase(Path)) = Localise(Trim(UpperCase(cmCompany[i].coPath))) then
  {$ENDIF}
    begin
      Result := Trim(cmCompany[i].coCode);
      Break;
    end;
  end;
end;
*)
  function Localise(const APath: string): string;
  begin
    Result := AnsiReplaceStr(APath, ServiceMappedDrive, ServiceLocalDir);
  end;

Function IsWindows7 : Boolean;
Var
  OSVerIRec  :  TOSVersionInfo;
Begin // IsWindows7
  Result := False;

  FillChar(OSVerIRec,Sizeof(OSVerIRec),0);
  OSVerIRec.dwOSVersionInfoSize:=Sizeof(OSVerIRec);
  If GetVersionEx(OSVerIRec) Then
    Result := (OSVerIRec.dwMajorVersion = 6) And (OSVerIRec.dwMinorVersion = 1);
End; // IsWindows7


{$IFDEF SCHEDULER}
procedure LogIt(Where : TSentinelPurpose; s : ShortString; StandardDebug : Boolean = False);
begin

end;
{$ENDIF}


Initialization
  ConveyorInUse := False;
  QueryInUse := False;

  Query_OKToClose := True;
  Conveyor_OKToClose := True;
  Poller_OKToClose := True;

  QueryLock := TCriticalSection.Create;
  ConveyorLock := TCriticalSection.Create;

Finalization

  QueryLock.Free;
  ConveyorLock.Free;


end.
