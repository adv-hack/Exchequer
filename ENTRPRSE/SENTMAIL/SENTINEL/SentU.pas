unit Sentu;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExBtTh1U, ElVar, BtrvU2, VarConst, Parser, ThingU, RepFNO1U, Dialogs, SyncObjs,
  {EnterpriseSMS_TLB,} Classes, Enterprise04_TLB, CommsInt, BtSupU3, ExThrd2U, {$IFNDEF VAO}MailPoll,{$ENDIF}
{$IFDEF AQ}
  WorkSta2;
{$ELSE}
  WorkStat;
{$ENDIF}

const
  QueryID = 1;
  ConveyorID = 2;
  PollerID = 3;
  ReportConveyorID = 4;
  CSVConveyorID = 5;
  VisualReportConveyorID = 6;

  REMOTE_LIST = 'Remote.lst';

type

  TPollProgressRec = Record
    DataPath, EName : AnsiString;
    Status : TSentinelPurpose;
    Offline : Boolean;
  end;


  TElertFileSavePos = Record
    fsFileNo   : SmallInt;
    fsKeyPath  : Integer;
    fsStatus   : SmallInt;
    fsRecAddr  : LongInt;
  End; { Adapted from TBtrieveFileSavePos in comtk\obtrieve}


  Str255 = String[255];


  TSentinelFoundProc = function(Ename, UserID : ShortString;
                                 DataPath : AnsiString; APurpose : TSentinelPurpose;
                                 APriority : Byte; ARep : ShortString = ''; NewRep : Boolean = False) : Boolean of Object;

  TSentinelProgressProc = Procedure(PollProgress : TPollProgressRec) of Object;

  TThreadProgressProc = Procedure(Max  :  Integer;
                                    s1 : ShortString = '';
                                    s2 : ShortString = '';
                                    s3 : ShortString = '';
                                    s4 : ShortString = '') of Object;

  TNotifyRetriesProc = procedure(Sender : TObject;
                                 WhichType : TElertTransmissionType) of Object;

  TEmailProc = function : Smallint of Object;

  TMarkRecsProc = procedure (const s : string; ACount : longint; var Cancel : Boolean) of object;


  TSentinel = Class
  protected
    FToolkit : IToolkit;
    FClientID   : SmallInt;
    FElertName  : ShortString;
    FUser       : ShortString;
    FExLocal    : TdSentExLocalPtr;
    FTestMode   : Boolean;
    FOutputList : TStringList;
    FDataPath   : AnsiString;
    FLockPosition, FSavePos : LongInt;
    FLockCount : Integer;
    FSysLockPosition, FSysSavePos : LongInt;
    FSysLockCount : Integer;
    FOnThreadProgress : TThreadProgressProc;
    FPurpose : TSentinelPurpose;
    FPaperless : String;
    FSendEmailProc : TEmailProc;
    FOwningThread : TElOpenThread;
    TriggerInstance : SmallInt;
    FCompanyCode : string;
    FLogFileName : string;
    FRanOK : Boolean;
    FExtraLog : TStringList;
    procedure SetElert(const ElertName : ShortString);
    function GetOutputText(WhichType : Char; WhichInstance : SmallInt = 0;
                                 WhichMsgInstance : SmallInt = 0) : AnsiString;
    function BelowReminderLevel(const s : string; Level : integer) : Boolean;
    procedure ShowTestOutput;
    function Lock(Retry : Boolean = True) : SmallInt;
    function UnLock : SmallInt;
    function SysLock : SmallInt;
    function SysUnLock : SmallInt;
    Procedure SaveMainPos(Var SaveInfo : TElertFileSavePos);
    Procedure RestoreMainPos(SaveInfo : TElertFileSavePos);
    Function PositionOnLock : SmallInt;
    function Save : SmallInt;
    procedure WriteReSpawn(Purpose : TSentinelPurpose);
    function WantRespawn(Purpose : TSentinelPurpose; DeleteRec : Boolean = False) : Boolean;
    function CheckLineTypeKey(LType : Char) : Boolean;
    function CheckFullOutputLineKey(OType : Char; Instance : SmallInt) : Boolean;
    function OutputKey(OType : Char; Instance : SmallInt) : Str255;
    procedure LogEmails(T, CC, BCC : TStrings);
    procedure UpdateTick;
    procedure ResetTick;
    procedure AddRecipients(AList : TStringList; Recips : String);
    function GetRemoteRecipient(RecipientNo : SmallInt) : string;
    function GetNextTriggeredInstance : SmallInt;
    procedure TurnOffSMS;
    procedure UseVariant;
    function ThisElertWhereClause : string;
    function PrefixWhereClause(Pfix : Char) : string;
    procedure SetDataPath(const APath : AnsiString);
    Procedure SendProgress(Max  :  Integer;
                                    s1 : ShortString = '';
                                    s2 : ShortString = '';
                                    s3 : ShortString = '';
                                    s4 : ShortString = '');
    function RemoteFileName : string;
    procedure SetUser(const Value: ShortString);
  public
    DirectMode : Boolean;
    Abort : Boolean;
    Constructor Create;
    destructor Destroy; override;
    function Due : Boolean;
    procedure DebugMessage(const s : ShortString; Error : SmallInt = 0;
                                   IsSystem : Boolean = False); virtual;
    function SendSMS(AList : TStringList; var Prog : Integer) : SmallInt;
    function SendEMail(const eSub, eMsg : AnsiString; IsCSV : Boolean = False) : SmallInt; virtual;
    function SendSystemEMail(MsgType : Byte) : SmallInt;
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False);  virtual; abstract;
    function ElertDescription : ShortString; //for testing - remove at some point
    procedure DeleteOutputLines(WhichType : Char);
    procedure DeleteOutputNumber(WhichType : Char; Inst : SmallInt;
                                          const L : ShortString);
    procedure WriteEventHappenedRec;
//    function WantRunNow : Boolean; //PR: 17/07/2009 Moved to Poller only
    function EventKey(const WinID, HandID : longint) : Str255;
    function SMSErrorDesc : ShortString;
    procedure AddSystemSentinel;
    procedure LogIt(Where : TSentinelPurpose; const s : string; MainLogOnly : Boolean = False); virtual;


    property ElertName : ShortString read FElertName write SetElert;
    property User : ShortString read FUser write SetUser;
    property DataPath : AnsiString read FDataPath write SetDatapath;
    property CompanyCode : String read FCompanyCode;
    property OnThreadProgress : TThreadProgressProc read FOnThreadProgress
                                                    write FOnThreadProgress;
    property SendEmailProc : TEMailProc read FSendEmailProc
                                        write FSendEmailProc;

    property OwningThread : TElOpenThread read FOwningThread write FOwningThread;
    property LogFileName : string read FLogFileName write FLogFileName;
    property RanOK : Boolean read FRanOK write FRanOK;
  end;

  TSQLTest = Class(TSentinel)
  private
    AList : TStringList;
  public
    constructor Create(CID : Integer);
    destructor Destroy; override;
    procedure Close;
    procedure Run;
  end;

  TSentinelQuery = Class(TSentinel)
  private
    FParser : TParserObj;
    FastObj  : FastNDXOPtr;
    FSubject : AnsiString;
    FMarkRecs : TMarkRecsProc;
    FMarkCount : longint;
    FAttPrinter : string;  //PR: 16/02/2011 ABSEXCH-10913
    procedure WriteOutput(P : TParserObj);
    procedure WriteOutputLines(const Msg : AnsiString; WhichType : Char);
    procedure WriteEmailHeader(P : TParserObj);
    procedure WriteEmailTrailer(P : TParserObj);
    procedure SetEmailSubject(P : TParserObj);
    procedure WriteDestination(P : TParserObj; WhichType : Char);
    procedure StartFastNDX;
    function RecsKey(FileNumber : Byte; LineNumber : longint = 0) : ShortString;
    function MakeRecsKey(const AKey : ShortString; LineNumber : longint) : ShortString;
    function IncludeThisRec(AFileNo : Byte; AKey : ShortString; LineNumber : longint = 0) : Boolean;
    function AddMonths(ADate : ShortString; M : SmallInt) : ShortString;
    procedure DoProgress(FNum : Byte; RecsDone : longint);
    function GetNextMsgInstance : SmallInt;
    function PrintForm : ShortString;
    function CheckAbort : Boolean;
    function DoPrint(const ARef, AForm : AnsiString;
                                          AKey : longint;
                                          AttMethod : Byte;
                                          AttPrinter : string = '') : ShortString;
  public
    PCondition : AnsiString;
    EventKeyString : ShortString;
    AddExistingRecs : Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
    property MarkRecs : TMarkRecsProc read FMarkRecs write FMarkRecs;
  end;

  TSentinelConveyor = Class(TSentinel)
  public
    constructor Create(ClientID : SmallInt); //PR: 21/09/2009 Memory Leak Change
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
  end;

  TSentinelEmailChecker = Class(TSentinel)
  private
    //AP: 22/01/2018 ABSEXCH-19659 When access sentinel gives CoInitialize error
    {$IFNDEF VAO}
    MailPoller : TEMailPoller;
    {$ENDIF VAO}
  public
    constructor Create;
    destructor Destroy; override;
    procedure ShowMailProgress(const Msg : ShortString);
    procedure ProcessRemoteEmail(const Sender, Subject : ShortString;
                                     Text : PChar);
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
  end;

  TCompanyCodeObj = Class
    coCode : String;
  end;

  TSentinelPoller = Class(TSentinel)
  private
    FOnSentinelFound : TSentinelFoundProc;
    FOnProgress : TSentinelProgressProc;
    FOnTooManyRetries : TPollProc;
    FirstRun : Boolean;
    LastTick : TDateTime;
    ConveyorAvailable, AbortSMSTried : Boolean;
    FLastRemoteCheck : TDateTime;
    FPathList : TStringList;
    FWantToDeleteEventData : Boolean;
    function WantRunNow : Boolean; //PR: 17/07/2009 Moved from TSentinel
    function GetCompanyCode(const Path : string) : string;
    procedure SpawnNewSentinel(APurpose : TSentinelPurpose);
    procedure Expire;
    function IsExpired : Boolean;
    function CheckRetries(WhichType : TElertTransmissionType) : Boolean;
    procedure WriteEvents;
    function ConveyorHungup : Boolean;
    function CanAddQuery : Boolean;
    function CanAddConveyor : Boolean;
    function AllowQueuing : Boolean;
    function CheckRemoteList(const DataPath : string; var Rec : TElertRec) : Boolean;
    function CheckAuthorisedAddress(const Addr : string; var AddNo : SmallInt) : Boolean;
    procedure LoadCompanies;
    procedure DeleteEventData;
    procedure LoadRemoteList;
    procedure DebugMessage(const s : ShortString; Error : SmallInt = 0;
                                   IsSystem : Boolean = False); override;

  public
    Abort : Boolean;
    constructor Create;
    destructor Destroy; override; //PR: 21/09/2009 Memory Leak Change
    procedure Poll(DataPath : AnsiString);
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
    procedure LogIt(Where : TSentinelPurpose; const s : string; MainLogOnly : Boolean = False); override;

    procedure ShowProgress(const DataPath, EName : AnsiString;
                            Status : TSentinelPurpose; Offline : Boolean = False);
    property OnSentinelFound : TSentinelFoundProc read FOnSentinelFound
                                                  write FOnSentinelFound;
    property OnProgress : TSentinelProgressProc read FOnProgress
                                                write FOnProgress;
    property OnTooManyRetries : TPollProc read FOnTooManyRetries
                                           write FOnTooManyRetries;
  end;

  TSentinelReportConveyor = Class(TSentinel)
  protected
    function SendFax(AList : TStringList; var Prog : Integer) : SmallInt;
    function SendReportEmail(const eSub, eMsg : AnsiString) : SmallInt;
    function SetReportPrinter : SmallInt;
    function SetFaxPrinter : SmallInt;
    function SetFaxMethod : Byte;
    function Print : SmallInt;
    Procedure PrimeFax(Var PParam  :  TPrintParam);
  public
    constructor Create(ClientID : SmallInt); //PR: 21/09/2009 Memory Leak Change
    destructor Destroy; override;
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
  end;

  TSentinelCSVConveyor = Class(TSentinelConveyor)
  protected
    function CopyFile : SmallInt;
    function SendFileByFTP : SmallInt;
    function SendFileByEmail(const eSub, eMsg : AnsiString) : SmallInt;
    procedure WriteAddresses;
    function RenameCSVFile(const s1, s2 : AnsiString) : SmallInt;
  public
    constructor Create;
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
  end;

  TSentinelVisualReportConveyor = Class(TSentinelReportConveyor)
  protected
    function SendEMail(const eSub, eMsg : AnsiString; IsCSV : Boolean = False) : SmallInt; override;
  public
    constructor Create;
    procedure Run(TestMode : Boolean = False; RepQuery : Boolean = False); override;
  end;


  procedure TestCreate;

var
  FSMSSender : {ISMSSender} Variant;
  EntEmail : TEntEmail;
  SBSOpened : Boolean;
  LogFile : TextFile;


  Function ECMAPIAVAILABLE : WordBool; StdCall; external 'ENTCOMM2.DLL' Index 3;


implementation

uses
  SysUtils, rpCommon, GlobVar, VarFPosU, BTSupU1, DicLinkU,
   ComObj, testU, Forms, ActiveX, SecCodes, ElObjs, Windows, RwOpenF,
  BtSupU2, DebugLog, EtDateU, GlobIni,
  RWPrintR, RPDevice, RPFPrint, FaxIntO, RPdefine, PrintFrm, SBS_Int, Pform,
  SentFTP, DateUtils, Notify, CtkUtil04, FileUtil, SQLUtils, LocalU,
  ApiUtil,
  //PR: 21/03/2012 ABSEXCH-12689
  CustomFieldsIntf,

  //PR: 12/03/2012
  Variants,

  //PR: 18/09/2013 ABSEXCH-14630
  SysU2;

var
  PollProgress : TPollProgressRec;
  pollcount : longint;
  RemoteList : TStringList;

  Procedure SentClose_Files(ByFile  :  Boolean);


  Var
    Choice  :  Byte;

    FSpec   : FileSpec;

    Stat    : SmallInt;


  Begin

  {$I-}
      For Choice:=1 to TotFiles do
      Begin
        {* Check file is open b4 closing it *}

        Stat:=GetFileSpec(F[Choice],Choice,FSpec);

        If (Stat = 0) then
          Stat:=Close_File(F[Choice])
        else
          Stat:=0;
      end;
    {$I+}
  end;



function LJVar(const Value : ShortString; len : integer) : ShortString;
begin
  Result := Value + StringOfChar(' ', len);
  Result := Copy(Result, 1, len);
end;


 Function File_CheckKey(Fnum  :  Integer)  :  Str255;

 Var
   KeyS   :  Str255;

 Begin

   FillChar(KeyS,Sizeof(KeyS), #0);

   Case Fnum of

     7,8  :  KeyS:=PartCCKey(CostCCode,CSubCode[(Fnum=7)]);

     {*431RW  HM 29/03/00: Added Bill Of Materials }
     10   :  KeyS:=PartCCKey(BillMatTCode, BillMatSCode);

     13   :  KeyS:=PartCCKey(PassUCode,C0);

     {*431RW  HM 29/03/00: Added Job Notes }
     15   :  KeyS:=PartCCKey(NoteTCode, NoteJCode);

     16   :  KeyS:=PartCCKey(MFIFOCode,MSernSub);

     { Job Costing - Analysis Codes }
     17   :  KeyS:=PartCCKey(JARCode, JAACode);

     { Job Costing - Job Types }
     18   :  KeyS:=PartCCKey(JARCode, JATCode);

     {*431RW HM 29/03/00: Added FIFO }
     20   :  KeyS:=PartCCKey(MFIFOCode, MFIFOSub);

     { Job Costing - Employees }
     21   :  KeyS:=PartCCKey(JARCode, JAECode);

     { Job Costing - Actuals }
     23   :  KeyS:=PartCCKey(JBRCode, JBECode);

     { Job Costing - Retentions }
     24   :  KeyS:=PartCCKey(JBRCode, JBPCode);

     { Locations }
     26   :  KeyS:=PartCCKey(CostCCode, CSubCode[True]);

     { Stock Locations }
     27   :  KeyS:=PartCCKey(CostCCode, CSubCode[False]);

     { HM 25/01/99: Matched Payments added }
     28   :  KeyS:=PartCCKey('T', 'P');

     {*431RW HM 03/04/00: Customer and Supplier Notes }
     29,
     30   :  KeyS:=PartCCKey(NoteTCode, NoteCCode);

     {*431RW HM 03/04/00: Stock Notes }
     31   :  KeyS:=PartCCKey(NoteTCode, NoteSCode);

     {*431RW HM 12/04/00: Transaction Notes }
     32   :  KeyS:=PartCCKey(NoteTCode, NoteDCode);

     //PR 21/01/03
     33   :  KeyS := PartCCKey(JATCode, JBSCode);
   end; {Case..}

   File_CheckKey:=KeyS;

 end; {Func..}

 Function File_Include(Fnum  :  Integer)  :  Boolean;

 Var
   TmpBo   : Boolean;
   KeyS    : Str255;
   LStatus : Integer;
 Begin

   TmpBo:=BOff;

   Case Fnum of

     1,2  :  TmpBo:=(Cust.CustSupp=TradeCode[(Fnum=1)]);

     {*431RW  HM 03/04/00: Added Discount Matrix }
     14   :  With MiscRecs^ Do Begin
                        { Customer/Supplier Discounts }
               TmpBo := ((RecMFix = CDDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn]])) Or
                        { Customer/Supplier/Stock Quantity Breaks }
                        ((RecMFix = QBDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn], QBDiscSub]));
             End; { If }

     { Job Costing - Rates Of Pay (Employee & Global) }
     19   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBECode, JBPCode]);

     { Job Costing - Budgets }
     25   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBBCode, JBMCode, JBSCode]);

     {*431RW HM 03/04/00: Customer and Supplier Notes }
     29,
     30   :  With Password, NotesRec Do Begin
               TmpBo := (RecPfix = NoteTCode) And (SubType = NoteCCode);

               If TmpBo Then Begin
                 { Get Account Record and check type }
                 KeyS := NoteFolio;
                 LStatus:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
                 If (LStatus = 0) And CheckKey(NoteFolio, KeyS, Length(NoteFolio), BOn) Then
                   TmpBo := (Cust.CustSupp = TradeCode[FNum = 29])
                 Else
                   TmpBo := False;
               End; { If }
             End; { With }

     else    TmpBo:=BOn;

   end; {Case..}


   File_Include:=TmpBo;

 end; {Func..}


Constructor TSentinel.Create;
begin
  inherited Create;
  CoInitialize(nil);
  FToolkit := CreateToolkitWithBackdoor;
  FSendEmailProc := nil;
  FOnThreadProgress := nil;
  TotFiles := TotElertFiles;
  Abort := False;
  FOwningThread := nil;
  FOnThreadProgress := SendProgress;
  FRanOK := False;
  FExtraLog := TStringList.Create;
  FExtraLog.Add(' ');
end;

destructor TSentinel.Destroy;
begin
  if Assigned(FExtraLog) then
    FExtraLog.Free;
{  if DebugModeOn then}
{$IFDEF Debug}
    DebugMessage('Destroying Sentinel');
{$ENDIF}
  FToolkit := nil;
  CoUninitialize;
  if Assigned(FExLocal) then
  begin
    if UsingSQL then
      CloseClientIDSession(FExLocal.ExClientId);
    Dispose(FExLocal, Destroy);
  end;
{$IFDEF Debug}
    DebugMessage('Destroying Sentinel - After Dispose ExLocal');
{$ENDIF}
  inherited Destroy;
{$IFDEF Debug}
    DebugMessage('Destroying Sentinel - After inherited');
{$ENDIF}

end;

Function TSentinel.PositionOnLock : SmallInt;
Var
  KeyS : Str255;
Begin { PositionOnLock }
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr (ElertF, FLockPosition, RecPtr[ElertF]^);

    // Get Record
    Result := GetDirect(F[ElertF], ELertF, RecPtr[ElertF]^, 0, 0);
  End; { If (FLockCount > 0) }
End; { PositionOnLock }

function TSentinel.Save : SmallInt;
const
  TotalSaveTries = 4;
var
  res : SmallInt;
  KeyS : Str255;
  SaveInfo : TElertFileSavePos;
  tmpRec : TElertRec;
  iLockPosition : longint;

  iSaveTries : Integer;
begin
  iSaveTries := 0;

  //PR: Allow for occasional clashes by retrying save
  while iSaveTries < TotalSaveTries do
  begin
    if DebugModeOn then
      DebugMessage('Sentinel saved. Name = ' + FExLocal.LElertRec.elElertName + '. UserID = ' +
                     FExLocal.LElertRec.elUserID);
    Res := FExLocal^.LPut_Rec(ElertF, 0);

    //PR: 01/04/2011 Added handling for occasional error 80 - conflict
    //If this error occurs then we need to re-read the record before saving it
    if Res = 80 then
    with FExLocal^ do
    begin
      //Keep our record safe
      tmpRec := LElertRec;

      //Re-read record from database
      Res := LGetPos (ElertF, iLockPosition);
      if (Res = 0) then
      begin
        SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
        Res := LGetDirect(ElertF, 0, 0);

        if Res = 0 then
        begin
          //Restore our record and save.
          LElertRec := tmpRec;
          Res := LPut_Rec(ElertF, 0);
        end;
      end;
    end;  //If Res = 80

    inc(iSaveTries);
    if Res = 0 then
      iSaveTries := TotalSaveTries
    else
      Wait(1000 + Random(2000));

  end; //while

  Result := Res;

  Unlock;
end;

function TSentinel.BelowReminderLevel(const s : string; Level : integer) : Boolean;
var
  Tmp : Double;
  TmpInt : integer;
begin
  if Trim(s) <> '' then
  begin
    if Pos('.', s) > 0 then
    begin
      Try
        Tmp := StrToFloat(s);
      Except
        Tmp := Level + 1;
      End;
      Result := Tmp < Level + 1;
    end
    else
    begin
      Try
        TmpInt := StrToInt(s);
      Except
        TmpInt := Level + 1;
      End;
      Result := TmpInt <= Level;
    end;
  end;
end;


function TSentinel.GetOutputText(WhichType : Char; WhichInstance : SmallInt = 0;
                                 WhichMsgInstance : SmallInt = 0) : AnsiString;
var
  KeyS : Str255;
  Res : SmallInt;
  TmpRecAddr : longint;
  SepChars : String;
begin
  with FExLocal^ do
  begin
    if WhichType = otSMS then
      SepChars := ' '
    else
      SepChars := #13 + #10;

    Result := '';






    KeyS := OutputKey(WhichType, LElertRec.elInstance);
    UseVariant;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

    While (Res = 0) and CheckFullOutputLineKey(WhichType, LElertRec.elInstance{WhichInstance}) do
    begin

      if (LElertLineRec.Output.eoInstance = WhichInstance) and
         (LElertLineRec.Output.eoMsgInstance = WhichMsgInstance) then
      begin
        Result := Result + LElertLineRec.Output.eoLine1  + SepChars;
        if (WhichType = otEmail2Go) and LElertRec.elSendDoc and (LElertLineRec.Output.eoLineNo = 1) then
          FPaperless := Trim(LElertLineRec.Output.eoLine2);

      end;

      UseVariant;
      Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
    end;

    if Length(Result) > 0 then
    begin
      if Result[Length(Result)] = #10 then
        Delete(Result, Length(Result) - 1, 2)
      else
      if Result[Length(Result)] = ' ' then
        Delete(Result, Length(Result), 1);
    end;


  end;
end;

procedure TSentinel.LogEmails(T, CC, BCC : TStrings);
var
  i : integer;
begin
  for i := 0 to T.Count - 1 do
    DebugMessage('Email sent to ' + T[i]);

  for i := 0 to CC.Count - 1 do
    DebugMessage('Email cc''d to ' + CC[i]);

  for i := 0 to BCC.Count - 1 do
    DebugMessage('Email bcc''d to ' + BCC[i]);

end;


procedure TSentinel.SetElert(const ElertName : ShortString);
begin
  FElertName := ElertName;
end;

function TSentinel.Due : Boolean;
begin
  Result := False;
end;


procedure TSentinel.DeleteOutputLines(WhichType : Char);
var
  KeyS : String[255];
  Res : SmallInt;
  WhereClause : string;
begin
  if SQLUtils.UsingSQL then
  begin
    WhereClause := ThisElertWhereClause + ' AND ' + PrefixWhereClause(pxElOutput) + ' AND ' +
                   GetDBColumnName('Sentline.dat', 'Instance', '') + ' = ' + IntToStr(FExLocal^.LElertRec.elInstance) + ' AND ' +
                   GetDBColumnName('Sentline.dat', 'OutputType', '') + ' = ' + QuotedStr(WhichType);
    if Assigned(FExLocal) then
      DeleteRows(FCompanyCode, 'Sentline.dat', WhereClause, FExLocal.ExClientID)
    else
      DeleteRows(FCompanyCode, 'Sentline.dat', WhereClause);
  end
  else
  if Assigned(FExLocal) then
  with FExLocal^ do
  begin
    KeyS := OutputKey(WhichType, LElertRec.elInstance);

    Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

    While (Res = 0) and (LElertLineRec.Prefix = pxElOutput) and
          CheckFullOutputLineKey(WhichType, LElertRec.elInstance) do
    begin
      if (LElertRec.elInstance = LElertLineRec.Output.eoInstance) then
        LDelete_Rec(LineF, ellIdxOutputType);

      Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);
    end;
  end;
end;

procedure TSentinel.DeleteOutputNumber(WhichType : Char; Inst : SmallInt;
                                          const L : ShortString);
var
  KeyS : String[255];
  Res : SmallInt;
begin
  if Assigned(FExLocal) then
  with FExLocal^ do
  begin
    KeyS := OutputKey(WhichType, LElertRec.elInstance);

    UseVariant;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

    While (Res = 0) and (LElertLineRec.Prefix = pxElOutput) and
          CheckFullOutputLineKey(WhichType, LElertRec.elInstance) do
    begin
      if (Inst = LElertLineRec.Output.eoMsgInstance) and
         (Trim(L) = Trim(LElertLineRec.Output.eoLine1)) then
         begin
            LDelete_Rec(LineF, ellIdxOutputType);
            Res := 9;
         end
         else
            Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
    end;
  end;
end;



function TSentinel.ElertDescription : ShortString;
var
  Res : SmallInt;
  KeyS : String[255];
begin
  if Assigned(FExLocal) then
  with FExLocal^ do
  begin
    Open_System(ElertF, ElertF);
    KeyS := {LJVar(FUser, UIDSize) + LJVar(FElertName, 30)}MakeElertNameKey(FUser, FElertName);

    Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS);

    if Res = 0 then
      Result := LElertRec.elDescription
    else
      Result := 'Error: ' + IntToStr(Res);
    Close_Files;
  end;
end;

function TSentinel.SendSMS(AList : TStringList; var Prog : Integer) : SmallInt;
var
  Res, TempRes, TempRes2 : SmallInt;
  KeyS, KeyS2 : Str255;
  ThisInst, i : SmallInt;
  s : AnsiString;
  L : SmallInt;
  FloatStep, FloatPos : Double;
  IntPos : Integer;
  ProgStep : Integer;
  SMSError, TheseSMSTries : SmallInt;
  SMSReady : Boolean;
  FAbort : Boolean;
  SMSInvalidNoCount : Integer;

  WCount, WLevel : SmallInt;

  function RemoveSpaces(const s1 : String) : String;
  var
    j : integer;
  begin
    j := 1;
    Result := s1;
    while (j < Length(Result)) do
      if Result[j] = ' ' then
        Delete(Result, j, 1)
      else
        inc(j);
  end;

begin
  //PR: 12/04/2012 Need to create SMS Sender before we use it. D'Oh! (ABSEXCH-12578 T3)
  FSMSSender := CreateOLEObject('EnterpriseSMS.SMSSender');
  if VarIsEmpty(FSMSSender) then
  begin
    LogIt(spConveyor, 'Unable to create SMS Sender');
    raise Exception.Create('Unable to create SMS Sender');
  end;
  UpdateTick;
  Result := 0;
  SMSError := 0;
  FAbort := False;
  SMSInvalidNoCount := 0;
  with FExLocal^.LElertRec do
  begin
    if (elEmailRetriesNotified) and (elSysMessage = 0) then
    begin
      //Try to send error notification
      with TSentIniObject.Create(GlobalIniFileName) do
      begin
       Try
        if AdminSMS <> '' then
        begin
          FSMSSender.Number := RemoveSpaces(AdminSMS);
          FSMSSender.Message := 'Error sending Email for ' + Trim(FUser) + ': ' + FElertName;
          Try
            if Assigned(FOnThreadProgress) then
                FOnThreadProgress(IntPos, 'Sending SMS Message',
                                    'Sending error notification');
            Result := FSMSSender.Send;
            if Result <> 0 then
            begin
{              if elSMSRetriesNotified then
                elSysMessage := 2
              else}
                elSysMessage := 3;
            end;
          Except
          End;
        end;
       Finally
        Result := 999;
        Free;
       End;
      end;
      EXIT;
    end;
  end;

  if (AList.Count > 0)  then
  with FExLocal^ do
  begin

    with LElertRec do
    begin
    //Setup progress step
      if elActions.eaEmail then
         FloatStep := 100 / (AList.Count + 1)
      else
         FloatStep := 100 / AList.Count;

    end;

    FloatPos := Prog;
    KeyS := OutputKey(otSMS2Go, LElertRec.elInstance);
    UseVariant;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

    i := 0;
    FAbort := Conveyor_WantToClose;
    while not FAbort and (i < AList.Count) do
    begin
      if (i = 0) or (Integer(AList.Objects[i]) <> Integer(AList.Objects[i-1])) then
      begin
        s := '';
        While (Res = 0) and CheckFullOutputLineKey(otSMS2Go, LElertRec.elInstance) and
           (LElertLineRec.Output.eoMsgInstance = Integer(AList.Objects[i])) do
        begin
          s := s + LElertLineRec.Output.eoLine1;

          UseVariant;
          Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
        end;

        L := MaxSMSLength - Length(s);
        if L >= Length(ElSMSTrailer) then
          s := s + ElSMSTrailer
        else
        if L >= Length(ElSMSTrailer2) then
          s := s + ElSMSTrailer2
        else
        if L >= Length(ElSMSTrailer3) then
          s := s + ElSMSTrailer3
        else
        if L >= Length(ElSMSTrailer4) then
          s := s + ElSMSTrailer4;
      end;

      {$IFDEF NewSMS}
        TheseSMSTries := 0;
        Repeat
          Try
            inc(TheseSMSTries);
            SMSReady := FSMSSender.AreYouReady;
            if not SMSReady then
              SleepEx(100, True);
          Except
            SMSReady := False;
          End;
        Until SMSReady or (TheseSMSTries > 25);
      {$ENDIF}


      FSMSSender.Number := RemoveSpaces(AList[i]);

      FSMSSender.Message := s;

      IntPos := Trunc(FloatPos);
      if Assigned(FOnThreadProgress) then
        FOnThreadProgress(IntPos, 'Sending SMS Messages',
                                  'Sending message ' + IntToStr(i + 1),
                                  AList[i]);
      UpdateTick;


      Try
       if SMSReady then
         TempRes := FSMSSender.Send
       else
         TempRes := 100;
      Except
       on E: Exception do
       begin
         TempRes := 999;
         DebugMessage('Exception in SendSMS for number ' + AList[i] + ': ' + E.Message);
         {$IFDEF NewSMS}
         FSMSSender.Reset;
         {$ENDIF}
       end;
      End;

      LelertRec.elSMSErrorNo := TempRes;
      if TempRes <> 0 then
      begin
        SMSError := TempRes;
        if TempRes <> 999 then
        begin
          LastSMSError := QuotedStr(FSMSSender.GetErrorDesc(TempRes));
          DebugMessage(LastSMSError + ' for number ' + AList[i], TempRes);
          if FSMSSender.Version >= 'v2.00' then
          begin
            if (TempRes = 1) then
              inc(SMSInvalidNoCount)
            else
            if TempRes = 2 then
            begin //Fatal error - don't try to send any more messages
              i := AList.Count;
              //Turn off SMS functionality
              TurnOffSMS;
              LElertRec.elSysMessage := 5;
              LElertRec.elSMSTries := MaxRetries;
            end;


          end;
        end;
        Sleep(1010);
      end
      else
        DebugMessage('SMS message sent to ' + AList[i]);



      inc(i);

      FloatPos := FloatPos + FloatStep;

      FAbort := Conveyor_WantToClose;

    end; //while i < AList.Count
    Prog := Trunc(FloatPos);
  end;

    if SMSError = 1 then
    begin
      if SMSInvalidNoCount = AList.Count then
                FExLocal.LElertRec.elSMSTries := MaxRetries
      else
      begin
        SMSError := 0;
        FExLocal.LElertRec.elSysMessage := 2;
      end;
    end;

    if SMSError = 0 then
    with TSentIniObject.Create(GlobalIniFileName) do
    Try
     if SMSWarnLevel > 0 then
     begin
       s := FSMSSender.GetErrorDesc(3333);
       if (s <> '-1') then
       if BelowReminderLevel(s, SMSWarnLevel) then
       begin
         FExLocal.LElertRec.elSysMessage := 1;
         SMSCredit := s;
         AddSystemSentinel;
       end;
     end;
    Finally
      Free;
    End;



  Result := SMSError;
  ResetTick;
end;

function TSentinel.SMSErrorDesc : ShortString;
begin
  with FExLocal^.LElertRec do
  begin
    if elSMSErrorNo = 999 then
      Result := 'Exception sending SMS.  Check log for details'
    else
    Try
      Result := QuotedStr(FSMSSender.GetErrorDesc(elSMSErrorNo));
    Except
      Result := 'Exception sending SMS.  Check log for details';
    End;
  end;
end;

procedure TSentinel.ShowTestOutput;
begin
  with TfrmTestOutput.Create(nil) do
  Try
    Memo1.Lines.AddStrings(FOutputList);
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TSentinel.AddRecipients(AList : TStringList; Recips : String);
var
  i, j : integer;
begin
  while (Length(Recips) > 0) do
  begin
    i := Pos(';', Recips);
    if i = 0 then
      i := Length(Recips) + 1;

    if i > 0 then
    begin
      AList.Add(Copy(Recips, 1, i-1));
      Delete(Recips, 1, i);
    end;
  end;
end;

function TSentinel.GetRemoteRecipient(RecipientNo : SmallInt) : string;
var
  Res : SmallInt;
  KeyS : String[255];
  Found : Boolean;
begin
  Found := False;
  with FExLocal^ do
  begin
    KeyS := pxRemoteEmail + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);

    UseVariant;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

    While (Res = 0) and not Found and
          (LElertLineRec.Prefix = pxRemoteEmail) and
          (LElertLineRec.Output.eoUserID  = LElertRec.elUserID) and
          (LElertLineRec.Output.eoElertName = LElertRec.elElertName) do
    begin
      if LElertLineRec.EMail.emaRecipNo = RecipientNo then
      begin
        Result := LElertLineRec.EMail.emaAddress;
        Found := True;
      end
      else
      begin
        UseVariant;
        Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
      end;
    end;
  end;
end;

function TSentinel.SendSystemEMail(MsgType : Byte) : SmallInt;
var
  KeyS : Str255;
  Res, TempRes : SmallInt;
//  EntEmail : TEntEmail;
  s : AnsiString;
//  a, b, c, d : longint;
  M : PChar;
  TempLockPos : longint;
  ThisInst : SmallInt;
  ExceptStr : String;
  FWsSetup : TElertWorkstationSetup;

  AddressType : Char;
  j : integer;

  CurrentInst : SmallInt;
  FirstTime : Boolean;

  TmpStat, TmpKPath : Integer;
  TmpRecAddr : longint;
  FAbort : Boolean;

  function CheckAddressKey : Boolean;
  begin
    with FExLocal^ do
      Result :=  (Res = 0) and CheckFullOutputLineKey(otEmailAdd2Go, LElertRec.elInstance);
  end;

begin
  Result := 0;
  UpdateTick;
  FAbort := False;
  Try



    with FExLocal^ do
    begin
      FWsSetup := TElertWorkstationSetup.Create;
      Try
        with EntEmail do
        begin
           Recipients.Clear;
           CC.Clear;
           BCC.Clear;
           Attachments.Clear;
           if (FWsSetup.SMTPServer <> '') and not FWsSetup.UseMapi then
           begin
             Sender :=  FWsSetup.SMTPAddress;
             SenderName := FwsSetup.SMTPUser;
             SMTPServer := FWsSetup.SMTPServer;
             UseMAPI := FWsSetup.UseMapi;
           end
           else
           begin
             if FWsSetup.UseMapi then
               UseMapi := FWsSetup.UseMAPI
             else
             begin
               Result := -5;
               ExceptStr := 'SMTP Server blank';
             end;
           end;
{$IFDEF Debug}
           DebugMessage(#13#10'   Sender: ' + Sender + #13#10'   SenderName: ' +
                        SenderName + #13#10'   Server: ' + SMTPServer);
{$ENDIF}
(*           if Result = 0 then
           with FExLocal^.LElertRec do
            begin
              if elSMSRetriesNotified or elEmailRetriesNotified then
              begin
                //Try to send error notification
                with TSentIniObject.Create(GlobalIniFileName) do
                begin
                 Try
                  if AdminEmail <> '' then
                  begin
//                    Recipients.Add(AdminEmail);
                    //08/05/2002 - change so we can have admin emails separated by semi-colons
                    AddRecipients(Recipients, AdminEmail);
                    Subject := 'Sentimail error notification';
                    if elSMSRetriesNotified then
                      s := 'Error sending SMS for ' + Trim(FUser) + ': ' + FElertName
                    else
                      s := 'Error sending Email for ' + Trim(FUser) + ': ' + FElertName;

                    s := s + #10#10 + 'Please see log for details';
                    Message := PChar(s);

                    Try
{                      if Assigned(FSendEmailProc) then
                        FSendEmailProc;}
                      Send;
                    Except
                    End;
                  end;
                 Finally
                  Result := 999;
                  Free;
                 End;
                end;
                EXIT;
              end;
            end;//not csv
*)
            {$IFDEF VAO}
            with TElertWorkstationSetup.Create do
            {$ELSE}
            with TSentIniObject.Create(GlobalIniFileName) do
            {$ENDIF}
            Try
              if MsgType = 1 {SMS Credit notification} then
              begin
              {$IFNDEF VAO}
                if AdminEmail <> '' then
                begin
                  AddRecipients(Recipients, AdminEmail);
                  //PR: 08/07/2013 ABSEXCH-14438 Rebranding
                  Subject := 'Sentimail: available SMS credit';
                  s := 'Your available SMS credit has fallen below the warning limit you set.'#13#10 +
                       'Limit:     ' + IntToStr(SMSWarnLevel) + #13#10 +
                       'Available: ' + SMSCredit + #13#10#13#10 +
                       'To purchase more credits, please contact your Advanced Enterprise Reseller.';
                  Message := PChar(s);
                  Try
                    Result := Send(False);
                  Except
                  End;
                end;
               {$ENDIF not VAO}
              end
              else
              if MsgType = 2 {SMS Failure notification} then
              begin
                if AdminEmail <> '' then
                begin
                  AddRecipients(Recipients, AdminEmail);
                  Subject := 'Sentimail error notification';
                  s := 'Error sending SMS for ' + Trim(LElertRec.elReportName) +
                                        ': ' + Trim(LElertRec.elDescription);

                  s := s + #10#10 + 'Please see log for details';
                  Message := PChar(s);
                  Try
                    Result := Send(False);
                  Except
                  End;
                end;
              end
              else
              if MsgType = 3 then
              begin  //Email error
                if AdminSMS <> '' then
                begin
                  FSMSSender.Number := AdminSMS;
                  FSMSSender.Message := 'Error sending Email for ' + Trim(FUser) + ': ' + FElertName;
                  Result := FSMSSender.Send;
                end;
              end
              else
              if MsgType = 4 then
              begin //Query in queue for too long
                if AdminEmail <> '' then
                begin
                  AddRecipients(Recipients, AdminEmail);
                  Subject := 'Sentimail error notification';
                  s := 'User ' + QuotedStr(Trim(LElertRec.elReportName)) + ': Query or report ' +
                       QuotedStr(Trim(LElertRec.elDescription)) +
                     ' running on workstation ' + QuotedStr(Trim(LElertRec.elParent)) +
                     ' has not finished within the required period. This may indicate a ' +
                     'problem with the Sentimail engine';

                  Message := PChar(s);
                  Try
                    Result := Send(False);
                  Except
                  End;
                end;
              end
              else
              if MsgType = 5 then
              begin //Fatal error in sending sms
                if AdminEmail <> '' then
                begin
                  AddRecipients(Recipients, AdminEmail);
                  Subject := 'Sentimail error notification';
                  s := 'There has been a fatal error sending an SMS message for Sentinel '+
                       QuotedStr(Trim(LElertRec.elDescription))+', User ' +
                       QuotedStr(Trim(LElertRec.elReportName)) +'. Please check the log for details.'#10 +
                       'Sending SMS messages has been temporarily disabled in the Sentimail engine workstation setup.' +
                       ' You can re-enable it manually once the problem has been rectified.' ;
                  Message := PChar(s);
                  Try
                    Result := Send(False);
                  Except
                  End;
                end;
              end;

            Finally
              Free;
            End;



        end;
       Finally
         if Result = 0 then
         begin
           DebugMessage('Email messages sent');
           LastEmailError := '';
           LElertRec.elTriggered := 1;
           LElertRec.elSysMessage := 0;
         end
         else
           if Result <> 999 then
           begin
             DebugMessage('Email error: ' + ExceptStr, Result);
             LastEmailError := ExceptStr;
           end;
       End;
    end;
  Finally
    ResetTick;
  End;

end;



function TSentinel.SendEMail(const eSub, eMsg : AnsiString; IsCSV : Boolean = False) : SmallInt;
var
  KeyS : Str255;
  Res, TempRes : SmallInt;
  s : AnsiString;
  M : PChar;
  TempLockPos : longint;
  ThisInst : SmallInt;
  ExceptStr : String;
  FWsSetup : TElertWorkstationSetup;

  AddressType : Char;
  j : integer;

  CurrentInst : SmallInt;
  FirstTime : Boolean;

  TmpStat, TmpKPath : Integer;
  TmpRecAddr : longint;
  FAbort : Boolean;
  IdxStr : string;

  function CheckAddressKey : Boolean;
  begin
    with FExLocal^ do
      Result :=  (Res = 0) and CheckFullOutputLineKey(otEmailAdd2Go, LElertRec.elInstance);
  end;

begin
  Result := 0;
  UpdateTick;
  FAbort := False;
  Try



    with FExLocal^ do
    begin
      FWsSetup := TElertWorkstationSetup.Create;
      Try
        with EntEmail do
        begin
           Recipients.Clear;
           CC.Clear;
           BCC.Clear;
           Attachments.Clear;
           if (FWsSetup.SMTPServer <> '') and not FWsSetup.UseMapi then
           begin
             Sender :=  FWsSetup.SMTPAddress;
             SenderName := FwsSetup.SMTPUser;
             SMTPServer := FWsSetup.SMTPServer;
             UseMAPI := FWsSetup.UseMapi;
           end
           else
           begin
             if FWsSetup.UseMapi then
               UseMapi := FWsSetup.UseMAPI
             else
             begin
               Result := -5;
               ExceptStr := 'SMTP Server blank';
             end;
           end;
{$IFDEF Debug}
           DebugMessage(#13#10'   Sender: ' + Sender + #13#10'   SenderName: ' +
                        SenderName + #13#10'   Server: ' + SMTPServer);
{$ENDIF}
           if Result = 0 then
           with FExLocal^.LElertRec do
            if not IsCSV then
            begin
              if (elSMSRetriesNotified or elEmailRetriesNotified) and (elSysMessage = 0) then
              begin
                //Try to send error notification
                {$IFDEF VAO}
                with TElertWorkstationSetup.Create do
                {$ELSE}
                with TSentIniObject.Create(GlobalIniFileName) do
                {$ENDIF}
                begin
                 Try
                  if AdminEmail <> '' then
                  begin
                    //08/05/2002 - change so we can have admin emails separated by semi-colons
                    AddRecipients(Recipients, AdminEmail);
                    Subject := 'Sentimail error notification';
                    if elSMSRetriesNotified then
                      s := 'Error sending SMS for ' + Trim(FUser) + ': ' + FElertName
                    else
                    begin
                      s := 'Error sending Email for ' + Trim(FUser) + ': ' + FElertName;
                      //Add addresses to s before sending
                    end;

                    s := s + #10#10 + 'Please see log for details';
                    Message := PChar(s);

                    Try
                      Result := Send(False);
                      if Result <> 0 then
                      begin
                        if elSMSRetriesNotified then
                          elSysMessage := 2
                        else
                          elSysMessage := 3;
                      end;
                    Except
                    End;
                  end;
                 Finally
                  Result := 999;
                  Free;
                 End;
                end;
                EXIT;
              end;
            end;//not csv


           Subject := eSub;
           //PR: 02/03/2011 Bodge to avoid crash when freeing EntEmail if msg >= 10240 bytes
           if Length(eMsg + ElEmailTrailer) < 10240 then
             Message := PChar(eMsg {+ #13 + #10 + #13 + #10} + ElEmailTrailer)
           else
             Message := PChar(Copy(eMsg + ElEmailTrailer, 1, 10239));


           KeyS := OutputKey(otEmailAdd2Go, LElertRec.elInstance);
           Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);
           ThisInst := 0;
           CurrentInst := 0;
           FAbort := Conveyor_WantToClose;
           While not Abort and (Res = 0) and CheckFullOutputLineKey(otEmailAdd2Go, LElertRec.elInstance) do
           begin
             UpdateTick;
             if not LElertRec.elSingleEmail then
             begin
               ThisInst := LElertLineRec.Output.eoMsgInstance;
               CurrentInst := ThisInst;
             end
             else
               ThisInst := 0;


             Case TEmailRecipType(LElertLineRec.Output.eoEmType) of
               ertTo  :  EntEmail.Recipients.Add(LElertLineRec.Output.eoLine1);
               ertCC  :  EntEmail.CC.Add(LElertLineRec.Output.eoLine1);
               ertBCC :  EntEmail.BCC.Add(LElertLineRec.Output.eoLine1);
             end;



             if not LElertRec.elSingleEmail then
             begin
               TmpKPath:=GetPosKey;
               TmpStat:=LPresrv_BTPos(LineF,TmpKPath,LocalF^[LineF],TmpRecAddr,BOff,BOff);

               //PR: ABSEXCH-14098 Reset subject for each message
               Subject := GetOutputText(otEmailSub2Go, LElertLineRec.Output.eoInstance,
                                      ThisInst);

               s := GetOutputText(otEmail2Go, LElertLineRec.Output.eoInstance,
                                      ThisInst);
               TmpStat:=LPresrv_BTPos(LineF,TmpKPath,LocalF^[LineF],TmpRecAddr,BOn,BOff);

                Message := PChar(s + ElEmailTrailer);

             end
             else
               Result := 0;

             if (Result = 0) then
             begin
               Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);

               if not LElertRec.elSingleEmail and
                      ((LElertLineRec.Output.eoMsgInstance <> CurrentInst) or
                        (LElertLineRec.Output.eoOutputType <> otEmailAdd2Go)) then
               begin
                Try
                 if (LElertRec.elSendDoc) and (FPaperless <> '') then
                 begin
                 {$IFDEF Debug}
                   DebugMessage('Adding attachment: ' + QuotedStr(FPaperless));
                 {$ENDIF}
                   Attachments.Clear;
                   Attachments.Add(FPaperless);
                   if LElertRec.elDBF then
                   begin
                     IdxStr := ChangeFileExt(FPaperless, '.mdx');
                     Attachments.Add(IdxStr);
                   end;
                 end;
                 if EntEmail.Recipients.Count > 0 then
                 begin
{$IFDEF Debug}
  DebugMessage('Before Send Email');
{$ENDIF}
                     Result := Send(False); //PR: 21/09/2009 Memory Leak Change
{$IFDEF Debug}
  DebugMessage('After Send Email');
{$ENDIF}

                   if Result = 0 then
                   begin
                     with EntEmail do
                       LogEmails(Recipients, CC, BCC);
                     if not LElertRec.elSingleEmail and
                     (LElertRec.elSendDoc) and (FPaperless <> '') then
                     begin
                       SysUtils.DeleteFile(FPaperless);
                       if LElertRec.elDBF then
                         SysUtils.DeleteFile(IdxStr);
                     end;
                   end;
                 end
                 else
                   Result := 1;
                Except
                 on E: Exception do
                 begin
                   Result := 2;
                   ExceptStr := E.Message;
                   DebugMessage('Email error ' + ExceptStr, Result);
                 end;

                End;
                 EntEmail.Recipients.Clear;
                 CC.Clear;
                 BCC.Clear;
                 ThisInst := LElertLineRec.Output.eoMsgInstance;
                 CurrentInst := ThisInst;


               end;

             end;
             FAbort := Conveyor_WantToClose;
           end; //while

           if LElertRec.elSingleEmail then
           begin
             try
               if IsCSV and (FPaperless <> '') then
               begin
                 Attachments.Add(FPaperless);
                 if LElertRec.elDBF then
                   Attachments.Add(ChangeFileExt(FPaperless, '.mdx'));
               end;
               if EntEmail.Recipients.Count > 0 then
               begin
{$IFDEF Debug}
  DebugMessage('Before Send Email');
{$ENDIF}
                 if not FAbort then
                   Result := Send
                 else
                   Result := 1;
{$IFDEF Debug}
  DebugMessage('After Send Email');
{$ENDIF}
                 if Result = 0 then
                   with EntEmail do
                     LogEmails(Recipients, CC, BCC);
               end
               else
               begin
                 Result := 1;
                 DebugMessage('Email message has no addresses');
               end;
             except // Trap any exceptions on sending E-mail
               on E: Exception do
               begin
                 Result := 2;
                 ExceptStr := E.Message;
               end;
             end;
           end;
        end;
       Finally
         if Result = 0 then
         begin
           DebugMessage('Email messages sent');
           LastEmailError := '';
         end
         else
           if Result <> 999 then
           begin
             DebugMessage('Email error: ' + ExceptStr, Result);
             LastEmailError := ExceptStr;
             if LElertRec.elEmailTries >= MaxRetries then
               raise Exception.Create('Error sending email. ' + ExceptStr);

           end;
         FWsSetup.Free; //PR: 21/09/2009 Memory Leak Change
       End;
    end;
  Finally
    ResetTick;
  End;

end;
//Locking/Unlocking stolen from comtk\obtrieve
function TSentinel.Lock(Retry : Boolean = True) : SmallInt;
const
  TotalLockTries = 5;
Var
  SaveInfo : TElertFileSavePos;
  lRes     : LongInt;

  iLockTries : Integer;
begin
  With FExLocal^ Do
  Begin
    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (ElertF, FLockPosition);
    If (Result = 0) Then
    begin
      iLockTries := 0;
      repeat
        inc(iLockTries);
        // Copy locked record position into data record
        SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
        // Reread and lock record
        Result := LGetDirect(ElertF, 0, B_SingLock + B_SingNWLock);
        If (Result = 0) Then
        begin
          // Record Locked
          Inc (FLockCount);
          iLockTries := TotalLockTries;
        end
        else
          Wait(1000 + Random(2000));
      until not Retry or (iLockTries >= TotalLockTries);
    end;{ If (Result = 0) }

  End; { With FBtrIntf^ }
end;

function TSentinel.UnLock : SmallInt;
Var
  KeyS : Str255;
begin
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(ElertF, FLockPosition, FExLocal^.LRecPtr[ElertF]^);


    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := FExLocal^.LFind_Rec(B_Unlock, ElertF, 0, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
    Result := FExLocal^.LFind_Rec(B_GetDirect, ElertF, 0, KeyS);
  End; { If (FLockCount > 0) }
end;

function TSentinel.SysLock : SmallInt;
Var
  SaveInfo : TElertFileSavePos;
  lRes     : LongInt;
begin
  With FExLocal^ Do
  Begin

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (LineF, FSysLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
     SetDataRecOfsPtr (LineF, FSysLockPosition, LRecPtr[LineF]^);
      // Reread and lock record
      Result := LGetDirect(LineF, 0, B_MultNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FSysLockCount);
    End { If (Result = 0) };

  End; { With FBtrIntf^ }
end;

function TSentinel.SysUnLock : SmallInt;
Var
  KeyS : Str255;
begin
    with FExLocal^ do
      Result := UnLockMLock(LineF, 0);
end;


Procedure TSentinel.SaveMainPos(Var SaveInfo : TElertFileSavePos);
Begin { SaveMainPos }
  FillChar(SaveInfo, SizeOf(SaveInfo), #0);
  With SaveInfo Do Begin
    fsFileNo  := ElertF;
    fsKeyPath := GetPosKey;

    fsStatus := Presrv_BTPos(ElertF, fsKeyPath, F[ElertF], fsRecAddr, BOff, BOff);
  End; { With SaveInfo }
End; { SaveMainPos }

// Saves the position in the global file
Procedure TSentinel.RestoreMainPos(SaveInfo : TElertFileSavePos);
Begin { RestoreMainPos }
  With SaveInfo Do
    If (FsStatus = 0) Then
      fsStatus := Presrv_BTPos(ElertF, fsKeyPath, F[ElertF], fsRecAddr, BOn, BOff);
End; { RestoreMainPos }

procedure TSentinel.WriteEventHappenedRec;
var
  KeyS : Str255;
  Res, i : SmallInt;
begin
  i := 1;
  if Assigned(FExLocal) then
  with FExLocal^ do
  begin
    KeyS := pxElEvent + FUser + FElertName;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

    while (Res = 0) and (LElertLineRec.Prefix = pxElEvent) do
    begin
      inc(i);

      Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
    end;

    with LElertLineRec, Event do
    begin
      Prefix := pxElEvent;
      evUserID := FUser;
      evElertName := FElertName;
      evInstance := i;
    end;

    Res := LPut_Rec(LineF, ellIdxLineType);

  end;
end;

procedure TSentinelPoller.WriteEvents;
var
  Res, Res1 : SmallInt;
  KeyS, Keys1, KeyChk : Str255;
  LocalLineRec : TElertLineRec;

  //PR 15/08/2008 Added to work around SQL Emulator locking fault
  function SafeRecordLock : Integer;
  begin
    with FExLocal^ do
    begin
      Result := LFind_Rec(22, LineF, ellIdxLineType, KeyS);

      if Result = 0 then
        Result := LFind_Rec(B_GetDirect + B_SingNWLock, LineF, ellIdxLineType, KeyS);
    end;
  end;

begin
  with FExLocal^ do
  begin
    KeyS := pxElEvent + SysUser + SysElertName;
    KeyChk := KeyS;
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);
    if Res = 0 then
      Res := SafeRecordLock;
    ShowProgress(FDataPath, 'Checking system events', spPoller);
    SleepEx(100, True);
    while (Res in [0, 84, 85]) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
     begin
       if Res = 0 then //if locked then another engine is dealing with this event
       begin
//         DebugMessage('WriteEvents 1777');
         Move(LElertLineRec, LocalLineRec, SizeOf(LocalLineRec));
         Res1 := LDelete_Rec(LineF, ellIdxLineType);
         {$IFDEF Debug}
         DebugMessage('Delete system event rec. Result: ' + IntToStr(Res1));
         {$ENDIF}
         KeyS1 := IntKey(LocalLineRec.Event.evWinID) + IntKey(LocalLineRec.Event.evHandID) + '!';

         Res1 :=  LFind_Rec(B_GetGEq, ElertF, elIdxEvent, KeyS1); //don't try to lock

         while (Res1 = 0) and (LElertRec.elWindowID = LocalLineRec.Event.evWinID) and
                              (LElertRec.elHandlerID = LocalLineRec.Event.evHandID) do
         begin
           {$IFDEF Debug}
           DebugMessage('Write System Event ' + LocalLineRec.Event.evKey);
           {$ENDIF}
           if LElertrec.elActive then
           begin
             LElertLineRec.Event.evUserID := LElertRec.elUserID;
             LElertLineRec.Event.evElertName := LElertRec.elElertName;
             LAdd_Rec(LineF, ellIdxLineType);
           end;

           Res1 := LFind_Rec(B_GetNext, ElertF, elIdxEvent, KeyS1);
         end;
       end;

       //if another engine has the rec locked then we want to skip it
       if Res = 0 then
       begin
         Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);
         if Res = 0 then
           Res := SafeRecordLock;
       end
       else
       begin
         Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);
         if Res = 0 then
         begin
           Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
           if Res = 0 then
              Res := SafeRecordLock;
         end;
       end;

     end;
    //If we've gone past the event records then unlock
    if (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) <> KeyChk) then
      LFind_Rec(B_Unlock, LineF, ellIdxLineType, KeyS);
  end;
end;

function TSentinelPoller.WantRunNow : Boolean;
var
  Res : SmallInt;
  KeyS : Str255;
begin
  if Assigned(FExLocal) then
  with FExLocal^ do
  begin
    if TElertStatus(LElertRec.elStatus) = esReportToRun then
      Result := True
    else
    if LElertRec.elType = 'T' then
      Result := (LElertRec.elNextRunDue < Now) or LElertRec.elRunNow
    else
    begin

      KeyS := pxElEvent + FUser + FElertName;
      Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

      if (Res = 0) and (LElertLineRec.Prefix = pxElEvent) and
         (Trim(LElertLineRec.Event.evUserID) = Trim(FUser)) and
         (Trim(LElertLineRec.Event.evElertName) = Trim(FElertName)) then
      begin
        LElertRec.elInstance := LElertLineRec.Event.evInstance;
        LElertRec.elRangeStart.egType := evString;
        LElertRec.elRangeStart.egString := LElertLineRec.Event.evKey;
        LElertRec.elRangeEnd.egType := evString;
        LElertRec.elRangeEnd.egString := LElertLineRec.Event.evKey;
        LElertRec.elFileNo := LElertLineRec.Event.evFileNo;
        Result := True;
        FWantToDeleteEventData := True;
      end;

    end;//else

  end;
end;

function TSentinel.EventKey(const WinID, HandID : longint) : Str255;
begin
  FillChar(Result, SizeOf(Result), #0);
  Move(WinID, Result[1], SizeOf(WinID));
  Move(HandID, Result[5], SizeOf(HandID));
  Result[9] := '!';
  Result[0] := #9;
end;

procedure TSentinel.WriteReSpawn(Purpose : TSentinelPurpose);
var
  Res : SmallInt;
  KeyS : Str255;
  Found : Boolean;
begin
  if not WantRespawn(Purpose) then
  with FExLocal^, LElertLineRec, Respawn  do
  begin
    Prefix := pxElRespawn;
    ewUserID := LJVar(FUser, UIDSize);
    ewElertName := LJVar(FElertName, 30);
    ewInstance := LElertRec.elInstance;
    ewPurpose := Ord(Purpose);
    ewTimeStamp := Now;

    Res := LAdd_Rec(LineF, ellIdxLineType);
  end;
end;

function TSentinel.WantRespawn(Purpose : TSentinelPurpose; DeleteRec : Boolean = False) : Boolean;
var
  Res : SmallInt;
  KeyS : Str255;
  Found : Boolean;
begin
  Found := False;
  KeyS := pxElRespawn + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);

  Res := FExLocal^.LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

  while (Res = 0) and
        not Found and
        CheckLineTypeKey(pxElRespawn) do
  begin
    if (TSentinelPurpose(FExLocal^.LElertLineRec.Respawn.ewPurpose) = Purpose) then
      Found := True
    else
      Res := FExLocal^.LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
  end;

  Result := Found;

  if Result and DeleteRec then
    FExLocal^.LDelete_Rec(LineF, ellIdxLineType);
end;

function TSentinel.CheckLineTypeKey(LType : Char) : Boolean;
begin
  with FExLocal^.LElertLineRec, Output do
    Result := (Prefix = LType) and
              (Trim(eoUserID) = Trim(FUser)) and
              (Trim(eoElertName) = Trim(FElertName));
end;

function TSentinel.CheckFullOutputLineKey(OType : Char; Instance : SmallInt) : Boolean;
begin
  with FExLocal^.LElertLineRec, Output do
    Result := (Prefix = pxElOutput) and
              (Trim(eoUserID) = Trim(FUser)) and
              (Trim(eoElertName) = Trim(FElertName)) and
              (eoInstance = Instance) and
              (eoOutputType = OType);
end;

function TSentinel.OutputKey(OType : Char; Instance : SmallInt) : Str255;
  function InstKey(i : SmallInt) : ShortString;
  var
    s : ShortString;
  begin
    s := StringOfChar(' ', SizeOf(i));
    Move(i, s[1], sizeOf(i));
    Result := s;
  end;
begin
  FillChar(Result, SizeOf(Result), #0);
  Result := pxElOutput + LJVar(FUser, UIDSize) +
            LJVar(FElertName, 30) + InstKey(Instance) + OType;
end;

procedure TSentinel.DebugMessage(const s : ShortString; Error : SmallInt = 0;
                                   IsSystem : Boolean = False);
var
  st : string;
  n : string;
begin
  SendProgress(Error, s);
end;

procedure TSentinel.UpdateTick;
begin
  LastConveyorTick := Now;
end;

procedure TSentinel.ResetTick;
begin
  LastConveyorTick := 0;
end;

procedure TSentinel.AddSystemSentinel;
var
  SysMsg : Byte;
  RunNo : SmallInt;
  TmpID, TmpName : string;
  WStat : string;
begin
  if Copy(FExLocal^.LElertRec.elUserID, 1, 5)  <> '_SYS_' then
  begin

    with TSentIniObject.Create(GlobalIniFileName) do
    Try
      RunNo := SMSSendWarning;
      SMSSendWarning := SMSSendWarning + 1;
    Finally
      Free;
    End;

    with FExLocal^ do
    begin
      TmpID := Trim(LElertRec.elUserID);
      TmpName := LElertRec.elElertName;
      SysMsg := LElertRec.elSysMessage;
      WStat := LElertRec.elWorkStation;
      LElertRec.elSysMessage := 0;
      LPut_Rec(ElertF, 0);
      FillChar(LElertRec, SizeOf(LElertRec), #0);

      LElertRec.elDescription := TmpName;
      LElertRec.elReportName := TmpID;
      LElertRec.elSysMessage := SysMsg;
      LElertRec.elUserID := LJVar('_SYS_', 10);
      LElertRec.elElertName := LJVar('System Notification ' + IntToStr(RunNo), 30);
      LElertRec.elType := 'Y';
      LElertRec.elActive := True;
      if SysMsg in [1, 2, 4, 5] then
      begin
        LElertRec.elActions.eaEmail := True;
        LElertRec.elStatus := Ord(esEmailReadyToGo);
      end
      else
      if SysMsg = 3 then
      begin
        LElertRec.elActions.eaSMS := True;
        LElertRec.elStatus := Ord(esSMSReadyToGo);
      end;
      LElertRec.elExpiration := Ord(eetAfterTriggers);
      LElertRec.elLastDateRun := Now;
      LElertRec.elDeleteOnExpiry := True;
      LElertRec.elTriggerCount := 1;
      LElertRec.elParent := WStat;

      LAdd_Rec(ElertF, 0);
    end;
  end;
end;


{=============================== TSentinelQuery methods ========================}
constructor TSentinelQuery.Create;
var
  ID : AnsiString;
begin
  inherited Create;
  FClientID := QueryID;
  New(FExLocal, Create(FClientID));
  DirectMode := False;
  FOutputList := TStringList.Create;
  EventKeyString := '';
  FPurpose := spQuery;
  AddExistingRecs := False;
  FMarkRecs := nil;
  FMarkCount := 0;
  if DebugModeOn then
  begin
    DebugMessage('Creating sentinel');
    ID := 'Sentinel Query Create. ThreadID: ' + IntToStr(GetCurrentThreadID) + '. ClientID: ' + IntToStr(Integer(@FExLocal.ExClientId));
    OutputDebugString(PChar(ID));
  end;
end;

destructor TSentinelQuery.Destroy;
begin
  if Assigned(FastObj) then
    Dispose(FastObj, Done);

//  Dispose(FExLocal, Destroy);

  if Assigned(FOutputList) then
    FOutputList.Free;
  inherited Destroy;
end;

procedure TSentinelQuery.Run(TestMode : Boolean = False; RepQuery : Boolean = False);
const
  LTries = 100; //Lock tries
var
  Condition : AnsiString;
  KeyS : String[255];
  Res, TmpStat : SmallInt;
  TempBool : Boolean;
  ParserObj : TParserObj;
  TheThing : TThing;
    WantSavePos,
    Selected,
    PassFileFilt,
    Abort,
    ForceEnd,
    FoundFirst,
    FastNDX,
    AtLeastOneRec
              :  Boolean;
  KeyChk,
  POnStr,
  POffStr    :  String[255];

    B_FuncGet,
    B_FuncNext
              :  Integer;

  FNum : Integer;
  KeyPath : Integer;

    MainRecPos,
    RecAddr,
    TotalCount,
    Count,
    NoChecked,
    RecsDone,
    RecsIncluded
              :  LongInt;

  IV : Byte;
  ValueStr : Str200;

  SaveInst : SmallInt;
  TryCount : Byte;
  TempS : ShortString;
  TempL : longint;
  AtLeastOneEmail,
  AtLeastOneSMS : Boolean;
  i : integer;
  FloatPos, FloatStep : Double;
  TotRecs : longint;
  ElObj : TElertObject;
  AttMethod : Byte;
  OutFormat : SmallInt;
  SaveDataPath : String;
  dbString : AnsiString;
begin
  SetQuery_OkToClose(False);
  Abort := False;
  SBSOpened := False;
  OutFormat := 0;
  with TElertWorkstationSetup.Create do
  Try
    OutFormat := OutputFormat;
  Finally
    Free;
  End;
  AtLeastOneEmail := False;
  AtLeastOneSMS := False;
  TryCount := 0;
  RecsDone := 0;
  Count := 0;
  RecsIncluded := 0;
  FTestMode := TestMode;
  SetDrive := FDataPath;
  ElObj := TElertObject.CreateNoFile;
  if not TestMode or RepQuery then
  begin
    Open_System(CustF, 15);
    SaveDataPath := SetDrive;
    SetDrive := GetEnterpriseDirectory;
    Open_System (DictF, DictF);
    SetDrive := SaveDataPath;
    {$IFDEF EXSQL}
    if TableExists(SetDrive + 'Reports\Reports.DAT') then
    {$ELSE}
    if FileExists(SetDrive + 'Reports\Reports.DAT') then
    {$ENDIF}
      Open_System (RepGenF, RepGenF);
//    if DebugModeOn then
      DebugMessage('System opened');
  end;
//  FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
  Try
    VarConst_Init;
    //PR: 21/03/2012 ABSEXCH-12689 Need to set custom fields path here, otherwise
    // STDNOMList doesn't get initialised and there's an AV further down the road.
    SetCustomFieldsPath(SetDrive);
    BtSupU2_Init;
    FloatPos := 0;
    FloatStep := 0;
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      if not TestMode or RepQuery then
      if Assigned(FToolkit) then
      begin
        if FToolkit.Status = tkOpen then
          FToolkit.CloseToolkit;

//        FToolkit.Configuration.DataDirectory := GetToolkitPath(FDataPath);
        FToolkit.Configuration.DataDirectory := FDataPath;
        Res := FToolkit.OpenToolkit;

        if Res = 0 then
        begin
{$IFDEF Debug}
          DebugMessage('Toolkit opened');
{$ENDIF}
          if OutFormat = 0 then
            AttMethod := Byte(FToolkit.SystemSetup.ssPaperless.ssAttachMethod)
          else
          begin
            Case OutFormat of
              1  :  AttMethod := 0;
              2  :  AttMethod := 2;
            end;
          end;

          //PR: 16/02/2011 ABSEXCH-10913
          if AttMethod = 1 then
            FAttPrinter := (FToolkit.SystemSetup.ssPaperless as ISystemSetupPaperless3).ssEmailAttachmentPrinter
          else
            FAttPrinter := '';
          (************** Temporary change - only allow edf *******)
{          if AttMethod in [1, 2] then
            AttMethod := 0;}
          FToolkit.CloseToolkit;
{$IFDEF Debug}
          DebugMessage('Toolkit Closed');
{$ENDIF}
        end
        else
          AttMethod := 0;
      end
      else
        AttMethod := 0;

      FastNDX := False;
      AtLeastOneRec := False;
      Abort := False;
      B_FuncNext := B_GetNext;
      begin
        LSetDrive := FDataPath;
        dbString := 'Sentimail query - open system ' + FDataPath;
        OutputDebugString(PChar(dbString));
        Open_System(CustF, 15);
      //16 doesn't seem to be used
        LSetDrive := FDataPath;
        Open_System(ElertF, LineF);
        TriggerInstance := GetNextTriggeredInstance;

        KeyS := MakeElertNameKey(FUser, FElertName);

        Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS); //don't forget to lock
      end;
      Try
        if Res = 0 then
          if not FTestMode or RepQuery then
            Res := Lock;

         while (Res in [84, 85]) and (TryCount < LTries) do
         begin
           Res := Lock;
           if Res <> 0 then
           begin
             Sleep(100);
             inc(TryCount);
           end;
         end;

        if (Res = 0) and (not FTestMode or RepQuery) then
        begin
          LElertRec.elWorkStation := WorkStationName;
          Res := Save;
          if Res = 0 then
            Res := Lock;
        end;


        if Res = 0 then
        begin
          if DebugModeOn then
            DebugMessage('Sentinel found');
    {      LElertRec.elStatus := Ord(esIdle);
          LPut_Rec(ElertF, 0); //don't unlock}
          if LElertRec.elSendDoc and not FTestMode then
          begin
            if Assigned(BackThread) then
              BackThread.InitSync(LSetDrive);
            SBSOpened := True;
            LelertRec.elRpAttachMethod := AttMethod;
          end;
          LElertRec.elSMSTries := 0;
          LElertRec.elEmailTries := 0;
          LelertRec.elSMSRetriesNotified := False;
          LelertRec.elEmailRetriesNotified := False;

          if LElertRec.elType = 'T' then
          {$IFDEF EN550CIS}
            B_FuncGet := B_GetGEq
          {$ELSE}
            B_FuncGet := B_GetFirst
          {$ENDIF}
          else {event}
          begin
            B_FuncGet := B_GetGEq;
            if FTestMode and not RepQuery then
            begin
             with LelertRec do
             begin
              elRangeStart.egString := EventKeyString;
              elRangeStart.egType := evString;
              elRangeEnd.egString := EventKeyString;
              elRangeEnd.egType := evString;
             end;
            end;
          end;
         {$IFDEF Debug}
          DebugMessage('Elert type read');
         {$ENDIF}
          SaveInst := LElertRec.elMsgInstance;
          LElertRec.elMsgInstance := GetNextMsgInstance;
          FastNDX := LElertRec.elIndexNo > 0;
          KeyPath := LElertRec.elIndexNo;
          FNum := FileTxLate(LElertRec.elFileno, KeyPath);
          KeyChk:=File_CheckKey(LElertRec.elFileno);
          //Get conditions
          Condition := '';
          KeyS := OutputKey('L', LElertRec.elInstance);
          Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);


          Abort := Query_WantToClose;
          While (Res = 0) and CheckFullOutputLineKey('L', LElertRec.elInstance) and not Abort do
          begin
            Condition := Condition + LElertLineRec.Output.eoLine1;

            Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
          end;
         {$IFDEF Debug}
          DebugMessage('Conditions loaded');
         {$ENDIF}

          ParserObj := TParserObj.Create;
          Try
            TheThing := TThing.Create;
            Try
          { Set event links }
              TheThing.DrivingFile := FNum;
              ParserObj.GetDBFEvent := TheThing.GetDBFEvent;
              ParserObj.GetFMLEvent := TheThing.GetFMLEvent;
              ParserObj.GetTBCEvent := TheThing.GetTBCEvent;
              ParserObj.GetTBPEvent := TheThing.GetTBPEvent;
              ParserObj.GetTBTEvent := TheThing.GetTBTEvent;
              ParserObj.GetTRWEvent := TheThing.GetTRWEvent;
              ParserObj.GetFmtDateEvent := TheThing.FormatDate;

         {$IFDEF Debug}
          DebugMessage('Parser created and initialised');
         {$ENDIF}
            if FastNDX then
              StartFastNDX;

            If (FastNDX) then
            Begin

              KeyChk:=FastObj^.KeyChk;
              KeyS:=KeyChk;

              Status:=FastObj^.Find_FastNDX(B_GetGEq,KeyS);

            end
               else
            Begin
              if LElertRec.elType = 'E' then
              begin
                KeyS := Trim(LElertRec.elRangeStart.egString);
                KeyChk := KeyS;
              end
              else
              begin
              {$IFNDEF EN550CIS}
                FillChar(KeyS, SizeOf(KeyS), #0);
              {$ELSE}
                KeyS := KeyChk;
              {$ENDIF}
                TotRecs := Used_Recs(F[Fnum],FNum);

                if TotRecs > 0 then
                  FloatStep := 100 / TotRecs;
              end;
              Status:=Find_Rec(B_FuncGet,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

            end;
         {$IFDEF Debug}
          DebugMessage('First Find_Rec - Result: ' + IntToStr(Status));
         {$ENDIF}

            Abort := Query_WantToClose;
            if not Abort and LElertRec.elActions.eaEmail then
            begin
              if (StatusOk) and ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX)) then
              begin
                if LElertRec.elSingleEmail then
                begin
                  WriteEmailHeader(ParserObj);
    //              WriteDestination(ParserObj, pxElEmail);  move to after query loop
                end
                else
                begin
                  if not FTestMode then
                  begin
                     //PR 14/05/2013 ABSEXCH-14098 Move setting subject to below so it picks up correct data fields
{                    SetEmailSubject(ParserObj);
                    WriteOutputLines(FSubject, otEmailSub2Go);}
                  end;
                end;
              end;
         {$IFDEF Debug}
          DebugMessage('Email header written set');
         {$ENDIF}

            end;

              Abort := Query_WantToClose;
              While (StatusOk) and ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX))
                and CheckAbort and not Abort do
              Begin
                If WantSavePos Then Begin
                  { Save main record position here if not STEPing }
                  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOff,BOff);
                End; { If }

                Selected:=BOn;

                RecAddr:=0;



                PassFileFilt:=File_Include(LElertRec.elFileno);


                Abort := Query_WantToClose;
                If (Selected) and (PassFileFilt) and (Not Abort) then
                Begin

                  Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Get Preserve File Posn *}

                      Abort := Query_WantToClose;
                      ValueStr := Condition;
                      if not Abort then
                        ParserObj.ReplaceExpressions(ValueStr, False);
                      TempBool := not Abort and ParserObj.Evaluate_Expression(ValueStr, False);
         {$IFDEF Debug}
          DebugMessage('Back from parser.evaluate');
         {$ENDIF}

                      inc(RecsDone);
                      DoProgress(FNum, RecsDone);
                      if not Abort and TempBool then
                      begin

                        if FTestMode and RepQuery then
                        begin
                          AtLeastOneRec := True;
                          Break;
                        end;

                        if not FTestMode or AddExistingRecs then
                        begin
                          if FNum = IDetailF then
                            TempL := ID.LineNo
                          else
                            TempL := 0;

                          TempS := RecsKey(FNum, TempL);
                          TempBool := IncludeThisRec(FNum, TempS, TempL);
         {$IFDEF Debug}
          DebugMessage('Back from IncludeThisRec');
         {$ENDIF}

                        end;

                        if TempBool then
                        begin
         {$IFDEF Debug}
           DebugMessage('TempBool = True');
         {$ENDIF}

                          inc(RecsIncluded);
                          TempS := RecsKey(FNum, TempL);
                          if LElertRec.elActions.eaEmail then
                          begin
                            if not LElertRec.elSingleEmail and not FTestMode then
                            begin
                              inc(LElertRec.elMsgInstance);
                              WriteDestination(ParserObj, pxElEmail);

                              //PR 14/05/2013 ABSEXCH-14098 Moved from above so subject can pick up
                              //correct data fields for multiple messages.
                              SetEmailSubject(ParserObj);
                              WriteOutputLines(FSubject, otEmailSub2Go);
                            end;
                            AtLeastOneEmail := True;
         {$IFDEF Debug}
           DebugMessage('AtLeastOneEmail Set');
         {$ENDIF}
                          end;

                          if LElertRec.elActions.eaSMS then
                          begin
                            if not  FTestMode then
                            begin
                              if not LElertRec.elActions.eaEmail or
                                     LElertRec.elSingleEmail then
                                inc(LElertRec.elMsgInstance);
                              WriteDestination(ParserObj, pxElSMS);
                              AtLeastOneSMS := True;
                            end;
                          end;
         {$IFDEF Debug}
           DebugMessage('About to write output');
         {$ENDIF}

                          WriteOutput(ParserObj);
                          AtLeastOneRec := True;
         {$IFDEF Debug}
           DebugMessage('Back from write output');
         {$ENDIF}

                        end;//if TempBool
                      end;//if TempBool
                end;

                If WantSavePos Then Begin
                  { Restore main record pos here if not STEPing }
                  TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOn,BOff);
                End; { If }

                if (LElertRec.elType = 'T') or AddExistingRecs then
                begin
                  If (FastNDX) then
                  begin
                    Status:=FastObj^.Find_FastNDX(B_GetNext,KeyS);
                    if Status = 1 then Status := 9;
                  end
                  else
                  Try
                   {$IFDEF Debug}
                      DebugMessage('Calling Next find_rec');
                   {$ENDIF}

                    Status:=Find_Rec(B_FuncNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);
                  Except
                    on E:Exception do
                    DebugMessage('Exception in Find_Rec: ' + E.Message);
                  End;
         {$IFDEF Debug}
           DebugMessage('Next find_rec - Result: ' + IntToStr(Status) + '. Record: ' +
                            Cust.CustCode);
         {$ENDIF}

                end
                else
                  Status := 9;

                Inc(Count);

                if not FastNDX and (LElertRec.elType = 'T') then
                begin
                  if TotRecs > 0 then
                  begin
                    FloatPos := Count / TotRecs;

                    FloatPos := FloatPos * 100;
                  end
                  else
                    FloatPos := 0;
                end;
                Abort := Query_WantToClose;
                if Assigned(FOnThreadProgress) and not FTestMode then
                  FOnThreadProgress(Trunc(FloatPos), 'Processing query', 'Records read:      ' + IntToStr(Count),
                                     'Records included: ' + IntToStr(RecsIncluded));
              end; {While..}
         {$IFDEF Debug}
          DebugMessage('Out of While loop');
         {$ENDIF}

          if Abort then
          begin
            AtLeastOneRec := False;
            AtLeastOneEmail := False;
            AtLeastOneSMS := False;
            LElertRec.elStatus := Ord(esIdle);
          end;

            if LElertRec.elActions.eaEmail and LElertRec.elSingleEmail then
            begin

              if (Status = 9) and ((CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) or (FastNDX)) then
                WriteEmailTrailer(ParserObj);

              if AtLeastOneRec and not FTestMode then
              begin

                SetEmailSubject(ParserObj);
                if DirectMode then
                  SendEmail(FSubject, FOutputList.Text)
                else
                begin
                  WriteOutputLines(FOutputList.Text, otEmail2Go);
                  WriteOutputLines(FSubject, otEmailSub2Go);
                end;
              end;
            end;

            Finally
              TheThing.Free;
            End;
          Finally
            ParserObj.Free;
          End;

          if (not FTestMode or RepQuery) and not DirectMode and AtLeastOneRec then
          begin
            if not RepQuery then
            begin
              if LElertRec.elActions.eaEmail and LElertRec.elActions.eaSMS then
                LElertRec.elStatus := Ord(esBothReadyToGo)
              else
              if LElertRec.elActions.eaEmail then
                LElertRec.elStatus := Ord(esEmailReadyToGo)
              else
              if LElertRec.elActions.eaSMS then
                LElertRec.elStatus := Ord(esSMSReadyToGo)
              else
                LElertRec.elStatus := Ord(esIdle);//shouldn't happen
{$IFDEF Debug}
DebugMessage('Status in Query.run: ' + IntToStr(LElertRec.elStatus));
{$ENDIF}
            end
            else
            begin
              if LElertRec.elActions.eaReport then
                LElertRec.elStatus := Ord(esReportToRun)
              else
                LElertRec.elStatus := Ord(esIdle);//shouldn't happen

            end;
          end
          else
          begin
            LElertRec.elStatus := Ord(esIdle);

          end;
          LElertRec.elLastDateRun := Now;
          LElertRec.elMsgInstance := SaveInst;
          ElObj.SetDataPointer(@LElertRec);
          LElertRec.elNextRunDue := ElObj.GetNextRunDue(True);

          if not AtLeastOneRec or not CheckAbort then
          begin

            if not AtLeastOneEmail or not CheckAbort then
            begin
              DeleteOutputLines(otEmailAdd2Go);
              DeleteOutputLines(otEmailSub2Go);
              DeleteOutputLines(otEmail2Go);
            end;

            if not AtLeastOneSMS or not CheckAbort then
              DeleteOutputLines(otSMSNumber2Go);
            LElertRec.elInstance := 0;
          end
          else
          begin
            if LElertRec.elSingleEmail and not FTestMode then
              WriteDestination(ParserObj, pxElEmail);

            if not FTestMode then
               inc(LElertRec.elTriggered);
          end;

         if not CheckAbort then
            LElertRec.elStatus := Ord(esIdle);

          if not FTestMode or RepQuery then
          begin
            LElertRec.elWorkStation := BlankWorkStation;
            Res := Save;
            if (Res <> 0) then
              DebugMessage('Error on save in Query.run', Res);
{$IFDEF Debug}
DebugMessage('Save in Query.run: ' + IntToStr(Res));
{$ENDIF}
          end;


          if Assigned(FOnThreadProgress) and not FTestMode then
          begin
             FOnThreadProgress(100, 'Query complete');
          end;

        end
        else
          if not FTestMode or RepQuery then
          begin
            WriteRespawn(spQuery);
            DebugMessage('Sentinel error: ' + IntToStr(Res));
          end;
        if FTestMode and not (RepQuery or AddExistingRecs) then
          ShowTestOutput;

      Finally
        Close_Files;
      End;
      if Res = 0 then
      begin
        LogIt(spQuery, S_FINISHED);
        FRanOK := True;
      end
      else
        LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
    end; //with FExLocal
  Finally
    if SBSOpened then
      if Assigned(BackThread) then
         BackThread.DeInitSync;

    if not TestMode or RepQuery then
      SentClose_Files(True);
    if Assigned(ElObj) then
       ElObj.Free;
    BtSupU2_Destroy; //PR: 21/09/2009 Memory Leak Change
    {$IFDEF EN551p}
    ResetQueryTick(FExLocal^.LElertRec);
    {$ENDIF}
    SetQuery_OkToClose(True);
  End;

end;

function TSentinelQuery.CheckAbort : Boolean;
begin
  Result := True;
//  Result := FTestMode;{ or not BackThread.MTMonRecs[1].THAbort;}
end;

procedure TSentinelQuery.WriteOutput(P : TParserObj);
var
  Res : SmallInt;
  s : AnsiString;
  KeyS : String[255];
  OType : Char;
  SaveInst : SmallInt;
begin
         {$IFDEF Debug}
           DebugMessage('In write output');
         {$ENDIF}

  with FExLocal^.LElertRec do
  begin
    if elActions.eaSMS then
    begin
      SaveInst := elInstance;
      elInstance := 0;
      s := GetOutputText('S');
      elInstance := SaveInst;

      s := P.FormatSMSOutput(s);

     if FTestMode then
       FOutputList.Add(s)
     else
       WriteOutputLines(s, 'M');
    end;

    if elActions.eaEmail then
    begin
      SaveInst := elInstance;
      elInstance := 0;
         {$IFDEF Debug}
           DebugMessage('WriteOutput - About to Getoutputtext');
         {$ENDIF}

      s := GetOutputText('N');
         {$IFDEF Debug}
           DebugMessage('WriteOutput - Back from Getoutputtext');
         {$ENDIF}
      elInstance := SaveInst;

         {$IFDEF Debug}
           DebugMessage('WriteOutput - About to format output');
           DebugMessage('Output text: ' + s);
         {$ENDIF}
      s := P.FormatSMSOutput(s, True);

         {$IFDEF Debug}
           DebugMessage('WriteOutput - Back from format output');
         {$ENDIF}
      if elSingleEmail or FTestMode then
        FOutputList.Add(s)
      else
        WriteOutputLines(s, otEmail2Go);
    end;
  end; //with
end;

procedure TSentinelQuery.StartFastNDX;
begin
  with FExLocal^.LElertRec do
    New(FastObj,Init(FastNDXOrdL^[elFileNo,elIndexNo],1,'',FExLocal));
end;

procedure TSentinelQuery.WriteOutputLines(const Msg : AnsiString; WhichType : Char);
var
  MsgList : TStringList;
  i,
  Res : SmallInt;
begin
  MsgList := TStringList.Create;
  Try
    if WhichType = 'M' then
      MsgList.Add(Msg)
    else
      MsgList.Text := Msg;
    FillChar(FExLocal^.LElertLineRec, SizeOf(FExLocal^.LElertLineRec), #0);
    if MsgList.Count = 0 then
      MsgList.Add(' ');
    for i := 0 to MsgList.Count - 1 do
    with FExLocal^ do
    begin
      LElertLineRec.Prefix := pxElOutput;
      with LElertLineRec.Output do
      begin
        eoUserID := LJVar(FUser, UIDSize);
        eoElertName := LJVar(FElertName, 30);
        eoOutputType := WhichType;
        eoLineNo := i + 1;
        eoLine1 := MsgList[i];
        eoTermChar := '!';
        eoInstance := LElertRec.elInstance;
        if (WhichType = otSMS2Go) or not LElertRec.elSingleEmail then
          eoMsgInstance := LElertRec.elMsgInstance
        else
          eoMsgInstance := 0;
      end;

      if i = 0 then
        if LElertRec.elSendDoc and (WhichType = otEmail2Go) then
          LElertLineRec.Output.eoLine2 := PrintForm;

      Res := LAdd_Rec(LineF, ellIdxOutputType);

      LElertLineRec.Prefix := pxTriggered;
      LElertLineRec.Output.eoInstance := TriggerInstance;
      Res := LAdd_Rec(LineF, ellIdxOutputType);
    end;
  Finally
    MsgList.Free;
  End;
end;

function TSentinelQuery.PrintForm : ShortString;
var
  FName, SwapPath  : ShortString;
  FromName : string;
  Err : Boolean;
  FromFile, ToFile : TFileStream;
  i, j : integer;
  frmPrint : TfrmPrint;
begin
  frmPrint := TfrmPrint.Create(Application);
  Try
    InitSBS(frmPrint, FDataPath);
    Try
      with FExLocal^ do
        Result := DoPrint(Inv.OurRef, LElertRec.elDocName, Inv.FolioNum,
                                       {$IFNDEF Internal}
                                       LElertRec.elRpAttachMethod
                                       {$ELSE}
                                       0
                                       {$ENDIF}
                                       FAttPrinter);
    Finally
      DeInitSBS;
    End;
  Finally
//    frmPrint.Free; //Application will destroy it at shutdown
  End;

  Result := Trim(Result);
  FromName := Result;
  if Result <> '' then
  begin
    SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\';
    FName := ExtractFileName(Result);
    if Length(FName) > 13 then
    begin
      i := Pos('(', FName);
      j := i;
      while ((i) < Length(FName)) and (FName[i] <> ')') do inc(i);
      if i < Length(FName) then
        Delete(FName, j, (i - j) + 1);
    end;
    if Length(FName) > 12 then
      Delete(FName, 4, 1);

    i := Ord('A');
    j := Succ(Ord('Z'));
    while FileExists(SwapPath + FName) and (i < j) do
    begin
      FName[4] := Char(i);
      inc(i);
    end;



    {$IFDEF Debug}
    DebugMessage('Attachment written to ' + Result);
    {$ENDIF}

    Try
      FromFile := TFileStream.Create(Result, fmOpenRead or fmShareDenyWrite);
    Except
      Result := '';
    End;

    if Result <> '' then
    Try
      Try
        FName := SwapPath + FName;
        {$IFDEF Debug}
         DebugMessage('About to create file stream ' + FName);
         {$ENDIF}
        ToFile := TFileStream.Create(FName, fmCreate or fmShareExclusive);
      Except
        Result := '';
        DebugMessage('Exception creating file stream' + FName);
      End;

      if Result <> '' then
      Try
        Try
          ToFile.CopyFrom(FromFile, FromFile.Size);
          Result := FName;
        {$IFDEF Debug}
          DebugMessage('Attachment copied to ' + Result);
        {$ENDIF }
        Except
          DebugMessage('Exception copying attachment');
          Result := '';
        End;
      Finally
        ToFile.Free;
      End;
    Finally
      FromFile.Free;
      SysUtils.DeleteFile(FromName);
    End;
  end;
end;


procedure TSentinelQuery.WriteEmailTrailer(P : TParserObj);
var
  s : AnsiString;
begin
  s := GetOutputText('T');

  s := P.FormatSMSOutput(s, True);

  FOutputList.Add(s);
end;

procedure TSentinelQuery.SetEmailSubject(P : TParserObj);
var
  s : AnsiString;
begin
  s := GetOutputText(otEmailSubject);

  s := P.FormatSMSOutput(s);

  FSubject := s;
end;


procedure TSentinelQuery.WriteEmailHeader(P : TParserObj);
var
  s : AnsiString;
begin
  s := GetOutputText('E');

  s := P.FormatSMSOutput(s, True{Keep crs});

  FOutputList.Add(s);
end;

procedure TSentinelQuery.WriteDestination(P : TParserObj; WhichType : Char);
var
  Res, i : SmallInt;
  s : AnsiString;
  KeyS : Str255;
  AList : TStringList;
  Acount : SmallInt;
  EType : Integer;
begin
  AList := TStringList.Create;
  EType := 0;
  Try
    with FExLocal^ do
    begin
      i := 0;
      if (WhichType = pxElEmail) and (LElertRec.elRecipNo > 0) then
      begin
        s := GetRemoteRecipient(LElertRec.elRecipNo);
        LElertRec.elRecipNo := 0;
        if s <> '' then
        begin
          EType := 0; //To
          s := P.FormatSMSOutput(s);

          AList.AddObject(s, TObject(EType));

        end;
      end;

      if AList.Count = 0 then
      begin
        KeyS := WhichType + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);

        Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

        While (Res = 0) and (LElertLineRec.Prefix = WhichType) and
                (LElertLineRec.Output.eoUserID  = LElertRec.elUserID) and
                (LElertLineRec.Output.eoElertName = LElertRec.elElertName) do
        begin
          if WhichType = pxElEmail then
          begin
            s := LElertLineRec.EMail.emaAddress;
            EType := LElertLineRec.EMail.emaRecipType;
          end
          else
            with LElertLineRec.SMS do
              s := esCountry + esCode + esNumber;

          s := P.FormatSMSOutput(s);

          AList.AddObject(s, TObject(EType));

          Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
        end;
      end;

      FillChar(LElertLineRec, SizeOf(LElertLineRec), #0);

      for i := 0 to AList.count - 1 do
      with LElertLineRec do
      begin
        Prefix := pxElOutput;
        Output.eoUserID  := LElertRec.elUserID;
        Output.eoElertName := LElertRec.elElertName;
        Output.eoInstance := LElertRec.elInstance;
        if (WhichType = pxElSMS) or not LElertRec.elSingleEMail then
          Output.eoMsgInstance := LElertRec.elMsgInstance
        else
          Output.eoMsgInstance := 0;

        if WhichType = pxElEmail then
        begin
          Output.eoOutputType := otEmailAdd2Go;
          Output.eoEmType := Byte(AList.Objects[i]);
        end
        else
          Output.eoOutputType := otSMSNumber2Go;

        Output.eoLineNo := i + 1;
        Output.eoLine1 := AList[i];

        Res := LAdd_Rec(LineF, ellIdxOutputType);

        Prefix := pxTriggered;
        Output.eoInstance := TriggerInstance;
        Res := LAdd_Rec(LineF, ellIdxOutputType);
      end;
    end;
  Finally
   AList.Free;
  End;
end;

function TSentinelQuery.RecsKey(FileNumber : Byte; LineNumber : longint = 0) : ShortString;
begin
  Case FileNumber of
    CustF     :  Result := Trim(Cust.CustCode);
    InvF,
    IDetailF  :  Result := Trim(Inv.OurRef);
    NomF      :  Result := Trim(Nom.Desc);
    StockF    :  Result := Trim(Stock.StockCode);
    JobF      :  Result := Trim(JobRec.JobCode);
  end;
end;

function TSentinelQuery.MakeRecsKey(const AKey : ShortString;
                                    LineNumber : longint) : ShortString;
begin
  Result := pxElRecsSent +
            LJVar(FUser, UIDSize) +
            LJVar(FElertName, 30) +
            LJVar(AKey, 60) +
            IntKey(LineNumber) + '!';
end;


function TSentinelQuery.IncludeThisRec(AFileNo : Byte; AKey : ShortString;
                                       LineNumber : longint = 0) : Boolean;
var
  Res : SmallInt;
  KeyS : Str255;
  RepeatType : TElertRepeatPeriod;
  d : SmallInt;
  TempDate : String[10];
  NowString : String[10];
  WantCancel : Boolean;
begin
  with FExLocal^ do
  begin

    FillChar(KeyS, SizeOf(KeyS), #0);
    KeyS := MakeRecsKey(AKey, LineNumber);

    Res := LFind_Rec(B_GetEq, LineF, ellIdxExclude, KeyS);

    RepeatType := TElertRepeatPeriod(LElertRec.elRepeatPeriod);
    if Res = 0 then
    begin
      //Check date
      if RepeatType = epNever then //epNever is never repeat
        Result := False
      else
      if RepeatType = epAlways then //epAlways is never exclude
        Result := True
      else
      begin
        d := LElertRec.elRepeatData;
        TempDate := FormatDateTime('yyyymmdd', LElertLineRec.RecsSent.ersDateLastSent);
        NowString := FormatDateTime('yyyymmdd', SysUtils.Date);
        if RepeatType <> epMonth then
        begin
          if RepeatType = epWeek then
            d := d * 7;
          TempDate := CalcDueDate(TempDate, d);
        end
        else
          TempDate := AddMonths(TempDate, d);

        if TempDate <= NowString then
        begin
          Result := True;
          LElertLineRec.RecsSent.ersDateLastSent := SysUtils.Date;
          LPut_Rec(LineF, ellIdxExclude);
        end
        else
          Result := False;

      end;
    end
    else
    begin
      Result := True;

      if Result and (RepeatType <> epAlways) then
      begin
        FillChar(LElertLineRec, SizeOf(LElertLineRec), #0);
        with LElertLineRec, RecsSent do
        begin
          Prefix := pxElRecsSent;
          ersUserID := LJVar(FUser, UIDSize);
          ersElertName := LJVar(FElertName, 30);
          ersID := LJVar(Trim(AKey), 60);
          ersLineNo := LineNumber;
          ersDateLastSent := SysUtils.Date;
          ersTermChar := '!';

        end;

        LAdd_Rec(LineF, ellIdxExclude);

        if Assigned(FMarkRecs) then
        begin
          WantCancel := False;
          FMarkRecs(Trim(AKey), FMarkCount, WantCancel);
          Abort := WantCancel;
        end;
      end;
    end;
  end;//with
end;

function TSentinelQuery.AddMonths(ADate : ShortString; M : SmallInt) : ShortString;
var
  dd, mm, yy, i : Word;
  j : SmallInt;
begin
  DateStr(Adate, dd, mm, yy);

  while M > 0 do
  begin
    if M <= 5 then
    begin
      i := 5 - m;
      m := 0;
    end
    else
    begin
      i := 0;
      m := m - 5;
    end;

    j :=500 + (i * 100) + dd;

    ADate := CalcDueDate(ADate, j);
  end;
  Result := ADate;
end;

procedure TSentinelQuery.DoProgress(FNum : Byte; RecsDone : longint);
var
  s : ShortString;
begin
end;

function TSentinelQuery.GetNextMsgInstance : SmallInt;
var
  Res : SmallInt;
  KeyS : Str255;
begin
  Result := 0;
  with FExLocal^ do
  begin
    KeyS := pxElOutput + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);

    Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

    while (Res = 0) and CheckLineTypeKey(pxElOutput) do
    begin
      if LElertLineRec.Output.eoMsgInstance > Result then
        Result := LElertLineRec.Output.eoMsgInstance;

      Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
    end;
  end;
//  inc(Result);
end;



{============================== Poller methods ==============================}


constructor TSentinelPoller.Create;
var
  ID : AnsiString;
begin
  inherited Create;
  FClientID := PollerID;
  New(FExLocal, Create(FClientID));
  FOnSentinelFound := nil;
  FPurpose := spPoller;
  DebugMessage('Creating sentinel');
  FirstRun := True;
  ConveyorAvailable := True;
  AbortSMSTried := False;
  FLastRemoteCheck := 0;
  FPathList := TStringList.Create;
  if DebugModeOn then
  begin
    ID := 'Sentinel Poller Create. ThreadID: ' + IntToStr(GetCurrentThreadID) + '. ClientID: ' + IntToStr(Integer(@FExLocal.ExClientId));;
    OutputDebugString(PChar(ID));
  end;
  LoadCompanies;
  FWantToDeleteEventData := False;
end;

destructor TSentinelPoller.Destroy;
var
  i : integer;
begin
  if Assigned(FPathList) then
  begin
    for i := 0 to FPathList.Count - 1 do
      if Assigned(FPathList.Objects[i]) then
        FPathList.Objects[i].Free;
    FPathList.Free;
  end;
  inherited;
end;


function TSentinelPoller.CheckRemoteList(const DataPath : string; var Rec : TElertRec) : Boolean;
var
  i  : integer;
  CoCode : string;
  s, s1 : string;
  AddressNo : SmallInt;
begin
  CoCode := GetCompanyCode(DataPath);
  Result := False;
  i := 0;
  while not Result and (i < RemoteList.Count) do
  begin
    s := RemoteList[i];
    s1 := Copy(s, 1, 40);
    if s1 = UpperCase(LJVar(Rec.elUserID, 10) + LJVar(Rec.elElertName, 30)) then
    begin
      s1 := Copy(s, 41, 6);
      if s1 = CoCode then
      begin
        s1 := Copy(s, 50, Length(s));
        Result := CheckAuthorisedAddress(s1, AddressNo); //Recipno of address is returned in AddressNo
        if Result then
        begin
          if Copy(s, 47, 2) = 'ME' then
            Rec.elRecipNo := AddressNo;
          Rec.elRunNow := True;
        end;
        RemoteList.Delete(i);

      end;
    end;
    inc(i);
  end;
end;

function TSentinelPoller.CheckAuthorisedAddress(const Addr : string; var AddNo : SmallInt) : Boolean;
var
  Res : SmallInt;
  KeyS : String[255];
begin
  Result := False;
  with FExLocal^ do
  begin
    KeyS := pxRemoteEmail + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);

    Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

    While (Res = 0) and not Result and
          (LElertLineRec.Prefix = pxRemoteEmail) and
          (LElertLineRec.Output.eoUserID  = LElertRec.elUserID) and
          (LElertLineRec.Output.eoElertName = LElertRec.elElertName) do
    begin
      Result := UpperCase(Trim(Addr)) = UpperCase(Trim(LElertLineRec.EMail.emaAddress));

      if Result then
        AddNo := LElertLineRec.EMail.emaRecipNo
      else
        Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
    end;
  end;

end;


procedure TSentinelPoller.Poll(DataPath : AnsiString);
//run through all elerts available and check which need to run or be sent
var
  KeyS : String[255];
  Res, TempRes : SmallInt;
  BFunc : SmallInt;
  ThisStatus : TElertStatus;
  WorkStation : TElertWorkStationSetup;
  ElObj : TElertObject;
  WhichFlag : Char;
  i : integer;
  EndTime : TDateTime;
  CoCode : string;
  dbString : AnsiString;

  function TimeToCheckEmails : Boolean;
  begin
    Result := ((WorkStation.RemoteFreq > 0) and (MinutesBetween(Now, FLastRemoteCheck) >= WorkStation.RemoteFreq)) or
              ((WorkStation.RemoteFreq < 0) and (SecondsBetween(Now, FLastRemoteCheck) >= Abs(WorkStation.RemoteFreq)));
  end;
begin
  Abort := False;
  Poller_OKToClose := False;
  if DebugModeOn then
    DebugMessage('Polling ' + Datapath);
  WorkStation := TElertWorkStationSetup.Create;
  Res := 0;
  Try
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      begin
        Inc(PollCount);
        ConveyorAvailable := not ConveyorHungUp;
        FDataPath := DataPath;
        LSetDrive := FDataPath;
        dbString := 'Sentimail poller - open system ' + FDataPath;
        OutputDebugString(PChar(dbString));

        Open_System(ElertF, LineF);
        if DebugModeOn then
          DebugMessage('After OpenSystem');
        WriteEvents;
        BFunc := B_GetFirst;
        ShowProgress(FDataPath, '', spPoller);
        Try
          if WorkStation.AllowRemote and ConveyorAvailable then
          begin
            LoadRemoteList;
            if TimeToCheckEmails then
            begin
              SpawnNewSentinel(spEmailCheck);
              FLastRemoteCheck := Now;
            end;
          end;
          while not Abort and (Res <> 9) do
          begin
    {$IFNDEF SERVICE}
      Application.ProcessMessages;
    {$ENDIF}
            Res := LFind_Rec(BFunc, ElertF, 0, KeyS); //lock at this point
            BFunc := B_GetNext;
            if DebugModeOn then
              DebugMessage('Find_Rec returned ' + IntToStr(Res));

            if (Res = 0) and not (TElertStatus(LElertRec.elStatus) in [esInProcess, esInSendProcess]) then
            begin
            {$IFNDEF VAO}
              if CheckSentinelsOK  then //we haven't exceeded licenced sentinels
              begin
                if DebugModeOn then
                  DebugMessage('After CheckSentinelsOK');
                if Trim(LElertRec.elUserID) <> '_SYS_' then
                  inc(SentinelsSoFar);
                Res := Lock(False);
              end
              else
              begin
                if Trim(LElertRec.elUserID) <> '_SYS_' then
                  Res := 9;

                if DebugModeOn then
                  DebugMessage('CheckSentinelsOK failed. Sentinels so far: ' + IntToStr(SentinelsSoFar) + ', Sentinels licenced: '
                                    + IntToStr(SentinelsAllowed));
              end;
            {$ELSE}
              Res := Lock(False);
            {$ENDIF}
            end;

            begin
              if Res = 0 then
              begin
              //do we want it
                if IsExpired then
                begin
                  if LElertRec.elDeleteOnExpiry then
                  begin
                    DebugMessage('Expired sentinel deleted');
                    LDelete_Rec(ElertF, 0);
                  end;
                end
                else
                begin
                  Abort := Poller_WantToClose;
                  ShowProgress(FDataPath, LElertRec.elElertName, spPoller);
                  with LElertRec do
                  begin
                    FElertName := elElertName;
                    FUser := elUserID;
                    ThisStatus := TElertStatus(elStatus);
                    if (ThisStatus = esIdle) and WorkStation.AllowRemote then
                      CheckRemoteList(DataPath, LElertRec);
                    if (ThisStatus = esInProcess) and (elHoursBeforeNotify > 0) and
                       (elQueryStart > 0) then
                    begin
                      //Check if query has been running for longer than required period
                      EndTime := IncHour(elQueryStart, elHoursBeforeNotify);
                      if Now > EndTime then
                      begin
                        elSysMessage := 4;
                        ResetQueryTick(LElertRec);
                        //Save;
                        AddSystemSentinel;
                      end;
                    end
                    else
                    if (ThisStatus in Ready2GoSet) or
                        WantRespawn(spConveyor, True) and
                        ConveyorAvailable then //data is ready to be transmitted
                    begin
                      if (((ThisStatus in [esSMSReadyToGo, esBothReadyToGo]) and
                           CheckRetries(etrSMS) and (WorkStation.CanSendSMS)) or
                         ((ThisStatus in [esEmailReadyToGo, esBothReadyToGo]) and
                          (WorkStation.CanSendEmail) and CheckRetries(etrEmail))) and
                          not Abort then
                      begin
                        if CanAddConveyor then
                        begin
                          ConveyorLock.Enter;
                          Try
                            ConveyorInUse := True;
                          Finally
                            ConveyorLock.Leave;
                          End;
                          ShowProgress(FDataPath, LElertRec.elElertName, spConveyor);
                          elPrevStatus := elStatus;
                          elStatus := Ord(esInSendProcess);
        //                  TempRes := LPut_Rec(ElertF, 0);
                          elWorkStation := WorkStationName;
                          TempRes := Save;
                          DebugMessage('Sent to conveyor (' + DataPath + ')');
                          SpawnNewSentinel(spConveyor);
                        end;
    {$IFNDEF SERVICE}
      Application.ProcessMessages;
    {$ENDIF}
                      end
                      else
                      if ThisStatus in Report2GoSet then
                      begin
                        if ((LElertRec.elActions.eaRepEmail and WorkStation.CanSendEmail and
                            CheckRetries(etrEmail)) or
                           (LElertRec.elActions.eaRepFax and WorkStation.CanSendFax and
                             CheckRetries(etrFax))) and not Abort then
                        begin
                         if CanAddConveyor then
                         begin
                          if Trim(LElertRec.elRepFile) <> '' then
                          begin
                            ConveyorLock.Enter;
                            Try
                              ConveyorInUse := True;
                            Finally
                              ConveyorLock.Leave;
                            End;
                            ShowProgress(FDataPath, LElertRec.elElertName, spConveyor);
                            elPrevStatus := elStatus;
                            elStatus := Ord(esInSendProcess);
                            elWorkStation := WorkStationName;
                            TempRes := Save;
                            DebugMessage('Sent to report conveyor (' + DataPath + ')');
                            if elNewReport then
                            begin
                              SpawnNewSentinel(spVisualReportConveyor);
                            end
                            else
                              SpawnNewSentinel(spReportConveyor);
                          end
                          else
                          begin
                            elStatus := Ord(esIdle);
                            TempRes := Save;
                            DebugMessage('Report file name is blank. Sentinel purged');
                          end;
                         end;
                        end;
                      end
                      else
                      if ThisStatus in CSV2GoSet then
                      begin
                        if ((LElertRec.elCSVToFolder and (ThisStatus in csvCopyReadyToGoSet)) or
                          (LElertRec.elCSVByEmail and WorkStation.CanSendEmail and
                          (ThisStatus in csvEmailReadyToGoSet) and
                            CheckRetries(etrEmail)) or
                          (LElertRec.elCSVByFTP and WorkStation.CanSendFTP and
                          (ThisStatus in csvFTPReadyToGoSet) and
                            CheckRetries(etrFTP))) and not Abort then
                        begin
                         if CanAddConveyor then
                         begin
                          ConveyorLock.Enter;
                          Try
                            ConveyorInUse := True;
                          Finally
                            ConveyorLock.Leave;
                          End;
                          ShowProgress(FDataPath, LElertRec.elElertName, spConveyor);
                          elPrevStatus := elStatus;
                          elStatus := Ord(esInSendProcess);
                          elWorkStation := WorkStationName;
                          TempRes := Save;
                          DebugMessage('Sent to CSV conveyor (' + DataPath + ')');
                          SpawnNewSentinel(spCSVConveyor);
                         end;
                        end;

                      end;//otherwise leave for workstation that can deal with it
                    end
                    else
                    if ((ThisStatus in [esIdle, esReportToRun])
                       or WantRespawn(spQuery, True)) {and not IsExpired} and
                       (elActive or (elRunNow or (ThisStatus = esReportToRun)))
                       then
                    begin
                      if ((elPriority = 'H') and Workstation.CanRunHighPriority) or
                          ((elPriority = 'L') and WorkStation.CanRunLowPriority)
                          then
                      begin
                        if (elActions.eaReport and WorkStation.CanRunReports) or
                           (not elActions.eaReport and WorkStation.CanRunAlerts)  then
                        begin
                          if not Abort and  WantRunNow then
                          begin
                           if CanAddQuery then
                           begin
                            {//PR: 17/07/2009 For event-based elerts, the event instance data was being deleted in
                            WantRunNow. Unfotunately, if we had more than one try before adding to the ObjectThread queue than
                            that instance data would be needed again for the next try - D'oh!! Change to only delete the
                            event instance data once we're ok to add the elert to the OT queue. This should fix Enduara's problem.
                            The DeleteEventData procedure checks that we want to delete the data before doing so.}
                            DeleteEventData;
                            QueryLock.Enter;
                            Try
                              QueryInUse := True;
                            Finally
                              QueryLock.Leave;
                            End;
                            ShowProgress(FDataPath, LElertRec.elElertName, spQuery);
                            elPrevStatus := elStatus;
                            elStatus := Ord(esInProcess);
                            elWorkStation := WorkStationName;
                            {$IFDEF EN551p}
                            UpdateQueryTick(LElertRec);
                            {$ENDIF}
                            Tempres := Save;
                            DebugMessage('Sent to query engine (' + DataPath + ')');
                            if elActions.eaReport then
                            begin
                             Try
                              if (ThisStatus = esReportToRun) or not elHasConditions then
                              begin
                                SpawnNewSentinel(spReport);
                              end
                              else
                                SpawnNewSentinel(spReportQuery);
                             Except
                               QueryLock.Enter;
                               Try
                                 QueryInUse := False;
                               Finally
                                 QueryLock.Leave;
                               End;

                               DebugMessage('Exception in SpawnNewSentinel');
                               KeyS := LJVar(elUserID, 10) + LJVar(elElertName, 30);
                               TempRes := LFind_Rec(B_GetEq, ElertF, 0, KeyS);

                               if TempRes = 0 then
                                   TempRes := Lock(False);

                               if TempRes = 0 then
                               begin
                                 elStatus := Ord(esIdle);
                                 elRunNow := True;
                                 TempRes := Save;
                               end;
                             End;
                            end
                            else
                              SpawnNewSentinel(spQuery);
                            //Application.ProcessMessages;
                           end;
                          end;
                        end;
                      end
                      else
                      begin
                        //unlock record
                        UnLock;
                      end;
                    end
                    else
                      Unlock;
                  end; //with
                  Unlock; //just in case
                end;
              end;//if not expired
            end; //if res = 0
    {$IFNDEF SERVICE}
      Application.ProcessMessages;
    {$ENDIF}
            Wait(500 + (PollInterval * WorkStation.PollSpeed));
            {$IFDEF SERVICE}
            if Assigned(FOwningThread) then
              Abort := FOwningThread.Terminated or Poller_WantToClose;
            {$ELSE}
            Abort := Poller_WantToClose;
            {$ENDIF}
          end; //while
        Finally
          Close_Files;
        End;
      end;
    end;
  Finally
    if Assigned(WorkStation) then
      WorkStation.Free;
    Poller_OKToClose := True;
  End;
end;

procedure TSentinelPoller.SpawnNewSentinel(APurpose : TSentinelPurpose);
var
  APriority : Byte;
  RepName : ShortString;
  WasRunNow : Boolean;
begin
  with FExLocal^.LElertRec do
  if Assigned(FOnSentinelFound) then
  begin
    if APurpose = spEmailCheck then
      FOnSentinelFound('Checking Emails', FUser, FDataPath, APurpose, 1, '')
    else
    begin
      WasRunNow := elRunNow;
      elRunNow := False;
      FExLocal.LPut_Rec(ElertF, 0);
      if elPriority = 'H' then
        APriority := 1
      else
        APriority := 0;
      if elNewReport and (APurpose = spReport) then
      begin
        RepName := elNewReportName;
        APurpose := spVisualReport;
      end
      else
        RepName := elReportName;
      if not FOnSentinelFound(FElertName, FUser, FDataPath, APurpose, APriority, RepName, elNewReport) then
      begin
        elStatus := elPrevStatus;
        elRunNow := WasRunNow;
        FExLocal.LPut_Rec(ElertF, 0);
      end;

    end;
  end;
end;

procedure TSentinelPoller.ShowProgress(const DataPath, EName : AnsiString;
                                             Status : TSentinelPurpose; Offline : Boolean = False);
begin
  {$IFNDEF SERVICE}
  if Assigned(OnProgress) then
  begin
    PollProgress.DataPath := DataPath;
    PollProgress.EName := EName;
    PollProgress.Status := Status;
    PollProgress.Offline := Offline;
    OnProgress(PollProgress);
  end;
  {$ENDIF}
end;

procedure TSentinelPoller.Expire;
var
  Exp : TElertExpirationType;
begin
  with FExLocal^.LElertRec do
  begin
    if not elExpired then
    begin
      Exp := TElertExpirationType(elExpiration);
      if ((Exp = eetDate) and (elExpirationDate < SysUtils.Date)) or
         ((Exp = eetAfterTriggers) and (elTriggered >= elTriggerCount)) or
         ((elType = 'Y') and (IncDay(elLastDateRun, 1) < SysUtils.Date)) then
      begin
        DebugMessage('Sentinel expired');
        elExpired := True;
        Save;
      end;
    end;
  end;
end;

function TSentinelPoller.IsExpired : Boolean;
begin
  Expire; //checks whether it should be expired & sets elExpired
  Result := FExLocal^.LElertRec.elExpired;
end;

function TSentinelPoller.CheckRetries(WhichType : TElertTransmissionType) : Boolean;

  function NeedToRetry(iTries : Integer) : Boolean;
  begin
    Result := (iTries >= 0) and (iTries < MaxRetries);
  end;
begin

  if WhichType = etrSMS then
    Result := NeedToRetry(FExLocal^.LElertRec.elSMSTries)
  else
  if WhichType = etrFTP then
    Result := NeedToRetry(FExLocal^.LElertRec.elFTPTries)
  else
  if WhichType = etrFax then
    Result := NeedToRetry(FExLocal^.LElertRec.elFaxTries)
  else
    Result := NeedToRetry(FExLocal^.LElertRec.elEmailTries);

  if FExLocal^.LElertRec.elSMSTries = MaxRetries then
  begin
    if (WhichType = etrSMS) and not FExLocal^.LElertRec.elSMSRetriesNotified then
    begin
      FExLocal^.LElertRec.elSMSRetriesNotified := True;
      if Assigned(FOnTooManyRetries) then
      begin
        ErrorSender := Self;
        ErrorTransType := WhichType;
        FOnTooManyRetries;
      end;
      Save;
      FExLocal.LElertRec.elSysMessage := 2;
      AddSystemSentinel;
    end
  end;

  if {not Result}FExLocal^.LElertRec.elEmailTries = MaxRetries then
  begin
    if (WhichType = etrEmail) and not FExLocal^.LElertRec.elEMailRetriesNotified then
    begin
      if Assigned(FOnTooManyRetries) then
      begin
        ErrorSender := Self;
        ErrorTransType := WhichType;
        FOnTooManyRetries;
      end;
      FExLocal^.LElertRec.elEmailRetriesNotified := True;
      Save;
    end;
  end;

  if {not Result}FExLocal^.LElertRec.elFTPTries = MaxRetries then
  begin
    if (WhichType = etrFTP) and not FExLocal^.LElertRec.elFTPRetriesNotified then
    begin
      if Assigned(FOnTooManyRetries) then
      begin
        ErrorSender := Self;
        ErrorTransType := WhichType;
        FOnTooManyRetries;
      end;
      FExLocal^.LElertRec.elFTPRetriesNotified := True;
      Save;
    end;
  end;

  if {not Result}FExLocal^.LElertRec.elFaxTries = MaxRetries then
  begin
    if (WhichType = etrFax) and not FExLocal^.LElertRec.elFaxRetriesNotified then
    begin
      if Assigned(FOnTooManyRetries) then
      begin
        ErrorSender := Self;
        ErrorTransType := WhichType;
        FOnTooManyRetries;
      end;
      FExLocal^.LElertRec.elFaxRetriesNotified := True;
      Save;
    end;
  end;

end;

function TSentinelPoller.ConveyorHungUp : Boolean;
var
  TempTick : TDateTime;
begin
  TempTick := LastConveyorTick;
  Result := (TempTick <> 0) and (IncMinute(TempTick, MinutesToHangUp) < Now);
  if Result and ConveyorAvailable then
    NotifyHungConveyor
end;

function TSentinelPoller.CanAddQuery : Boolean;
begin
  Result := True;
end;

function TSentinelPoller.CanAddConveyor : Boolean;
begin
  Result := True;
end;

function TSentinelPoller.AllowQueuing : Boolean;
begin
  Result := True;
end;
{============================== Email Checker methods ==============================}
constructor TSentinelEmailChecker.Create;
begin
  inherited Create;
  //AP: 22/01/2018 ABSEXCH-19659 When access sentinel gives CoInitialize error
  {$IFNDEF VAO}
    MailPoller := TEmailPoller.Create;
  {$ENDIF VAO}
  FClientID := ConveyorID;
  FPurpose := spEmailCheck;
  if DebugModeOn then
    DebugMessage('Creating sentinel');
end;

destructor TSentinelEmailChecker.Destroy;
begin
  //AP: 22/01/2018 ABSEXCH-19659 When access sentinel gives CoInitialize error
  {$IFNDEF VAO}
    FreeAndNil(MailPoller);
  {$ENDIF VAO}
  inherited Destroy;
end;

procedure TSentinelEmailChecker.Run(TestMode : Boolean = False; RepQuery : Boolean = False);
var
  WorkStation : TElertWorkStationSetup;
begin
  {$IFNDEF VAO}
  MailPoller.OnGetMessage := ProcessRemoteEmail;
  WorkStation := TElertWorkStationSetup.Create;
  Try
    if WorkStation.AllowRemote then
    begin
      if WorkStation.UseMapi then
        MailPoller.EmailType := emlMAPI
      else
        MailPoller.EmailType := emlSMTP;
      MailPoller.Pop3Server := WorkStation.SMTPServer;
      MailPoller.Pop3UserName := WorkStation.RemoteAc;
      MailPoller.Pop3Password := WorkStation.RemotePass;
      MailPoller.CheckNow;
    end;
  Finally
    FRanOK := True;
    WorkStation.Free;
    if RemoteList.Count > 0 then
    Try
      RemoteList.SaveToFile(RemoteFilename);
    Except
      on E:Exception do
        LogIt(spEmailCheck, 'Exception saving remote list: ' + QuotedStr(E.Message));
    End;
    LogIt(spEmailCheck, S_FINISHED);
  End;
  {$ENDIF}
end;

procedure TSentinelEmailChecker.ProcessRemoteEmail(const Sender, Subject : ShortString;
                                     Text : PChar);
var
  CoCode,
  UserName,
  SentName,
  SendAll : string;
  s : AnsiString;
  ks : string;

    function FindNextWord(const Param : string) : string;
    var
      i, i1, j : integer;
    begin
      Result := '';
      i := Pos(Param, UpperCase(s));
      i1 := i;
      j := i + Length(Param);
      if (i > 0) then
      begin
        //inc(j);
        i := j;
        while (j < Length(s)) and not(s[j] in [#10,#13]) do inc(j);
        if (j < Length(s)) then
        begin
          Result := Trim(Copy(s, i, j - i));
          Delete(s, i1, j - i1);
        end;
      end;
    end;

begin
  LogIt(spEmailCheck, 'Processing email from ' + Sender);
  s := AnsiString(Text);
  CoCode := FindNextWord('COMPANY=');
  UserName := FindNextWord('USER=');
  SendAll := FindNextWord('SEND=');
  SentName := FindNextWord('RUN=');

  while SentName <> '' do
  begin
    ks := LJVar(UserName, 10) + LJVar(SentName, 30) + LJVar(CoCode, 6)
             + LJVar(SendAll, 3) + Sender;
    RemoteList.Add(UpperCase(ks));

    SentName := FindNextWord('RUN=');
  end;

end;


{============================== Conveyor methods ==============================}

constructor TSentinelConveyor.Create(ClientID : SmallInt); //PR: 21/09/2009 Memory Leak Change
var
  ID : AnsiString;
begin
  inherited Create;
  FClientID := ClientID;  //PR: 21/09/2009 Memory Leak Change
  New(FExLocal, Create(FClientID));
  FPurpose := spConveyor;
  if DebugModeOn then
  begin
    DebugMessage('Creating sentinel');
    ID := 'Sentinel Conveyor Create. ThreadID: ' + IntToStr(GetCurrentThreadID) + '. ClientID: ' + IntToStr(Integer(@FExLocal.ExClientId));
    OutputDebugString(PChar(ID));
  end;

end;


procedure TSentinelConveyor.Run(TestMode : Boolean = False; RepQuery : Boolean = False);
var
  KeyS : Str255;
  Res : SmallInt;
  s : AnsiString;
  eSub, eMsg : AnsiString;
  WorkStation : TElertWorkstationSetup;
  SMSSent, EmailSent : Boolean;
  AList : TStringList;
  Prog, ProgStep : Integer;
  SMSRes : SmallInt;
  Abort : Boolean;
  TempSysMsg : Byte;

begin
  Abort := False;
  Conveyor_OKToClose := False;
  FTestMode := TestMode;
  AList := TStringList.Create;
  WorkStation := TElertWorkstationSetup.Create;
  Prog := 0;
  Try
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      LSetDrive := FDataPath;
      Open_System(CustF, 15);
      //16 doesn't seem to be used
      Open_System(ElertF, LineF);

      KeyS := MakeElertNameKey(FUser, FElertName);

      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS); //don't forget to lock

      if Res = 0 then
        Res := Lock;

        if (Res = 0) and not FTestMode then
        begin
          LElertRec.elWorkStation := WorkStationName;
          Save;
          Res := Lock;
        end;


      if Res = 0 then
      begin
{        LElertRec.elStatus := LElertRec.elPrevStatus;
        LPut_Rec(ElertF, 0); //don't unlock}

        with LElertRec do
        begin
          ProgStep := 50;

          Abort := Conveyor_WantToClose;
          SMSSent := not elActions.eaSMS or (elPrevStatus = Ord(esEMailReadyToGo));
          EmailSent := not elActions.eaEmail or (elPrevStatus = Ord(esSMSReadyToGo));

          if WorkStation.CanSendSMS and
            ((elActions.eaSMS and not SMSSent) or elSMSRetriesNotified or elEMailRetriesNotified) and
            not Abort then
          begin
            s := '';
            KeyS := OutputKey(otSMSNumber2Go, LElertRec.elInstance);
            Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

            While (Res = 0) and CheckFullOutputLineKey(otSMSNumber2Go, LElertRec.elInstance) do
            begin
              AList.AddObject(LElertLineRec.Output.eoLine1,
                              TObject(LElertLineRec.Output.eoMsgInstance));

              Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
            end;
           // List will now be in order of MsgInstance
           if AList.Count > 0 then
           begin
            if elActions.eaEmail then
              ProgStep := 100 div (AList.Count + 1)
            else
              ProgStep := 100 div AList.Count;


            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending SMS Messages');
            Try
             SMSRes := SendSMS(AList, Prog);
             if SMSRes = 0 then
               SMSSent := True
             else
               SMSSent := False;
            Except
              SMSSent := False;
            End;
           end
           else
             SMSSent := True;

           if SMSSent then
           begin
//             Prog := Prog + ProgStep;
             if Assigned(FOnThreadProgress) then
               FOnThreadProgress(Prog, 'SMS Messages sent');

             DeleteOutputLines(otSMS2Go);
             DeleteOutputLines(otSMSNumber2Go);
             LElertRec.elSMSTries := 0;
             Sleep(300);
           end
           else
            if (SMSRes <> 2) {and (SMSRes <> 4)} then
             Inc(LElertRec.elSMSTries);

          end;
          Abort := Conveyor_WantToClose;
          if WorkStation.CanSendEmail and
          ((elActions.eaEmail and not EmailSent) or elSMSRetriesNotified or elEMailRetriesNotified) and
            not Abort then
          begin
            //SendEmail
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Email Messages');
            if elType = 'Y' then
            begin
              if SendSystemEmail(elSysMessage) <= 1 then
                EmailSent := True
              else
                EmailSent := False;
            end
            else
            begin
              eSub := GetOutputText(otEmailSub2Go);
              eMsg := GetOutputText(otEmail2Go);
              if (eSub <> '') or not elSingleEmail or (eMsg <> '') then
              begin
                if SendEmail(eSub, eMsg, elNewReport) <= 1 then
                  EmailSent := True
                else
                  EmailSent := False;
              end
              else
                EmailSent := True;
            end;
            if EmailSent then
            begin
              Sleep(300);
              Prog := Prog + ProgStep;
              if Assigned(FOnThreadProgress) then
                 FOnThreadProgress(100, 'Email Messages sent');
              DeleteOutputLines(otEmailSub2Go);
              DeleteOutputLines(otEmail2Go);
              DeleteOutputLines(otEmailAdd2Go);
              if not elSingleEmail then
                SysUtils.DeleteFile(FPaperless);
              Sleep(300);
              LElertRec.elEmailTries := 0;
            end
            else
              Inc(LElertRec.elEmailTries);

          end;

          if (SMSSent and EmailSent) then
            elStatus := Ord(esIdle)
          else
          if (SMSSent and elActions.eaEmail) then
            elStatus := Ord(esEmailReadyToGo)
          else
          if (EmailSent and elActions.eaSMS) then
            elStatus := Ord(esSMSReadyToGo)
          else
            elStatus := elPrevStatus;

          if elStatus = Ord(esIdle) then
            elInstance := 0; //reset
          {Res := LPut_Rec(ElertF, 0);}
          elWorkStation := BlankWorkStation;
          TempSysMsg := elSysMessage;
          elSysMessage := 0;
          Res := Save;
          if (Res <> 0) then
            DebugMessage('Error on save in Conveyor.run', Res);
          if TempSysMsg > 0 then
          begin
            elSysMessage := TempSysMsg;
            AddSystemSentinel;
          end;
        end; //with LElertRec
        UnLock;
      end //if res = 0
      else
        WriteRespawn(spConveyor);
      Close_files;
      if Res = 0 then
      begin
        LogIt(spQuery, S_FINISHED);
        FRanOK := True;
      end
      else
        LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
    end; //with FExLocal^
  Finally
    WorkStation.Free;
    AList.Free;  //PR: 21/09/2009 Memory Leak Change
    Conveyor_OKToClose := True;
  End;
end;

{============================ Report conveyor =================================}

constructor TSentinelReportConveyor.Create;
begin
  inherited Create;
  FClientID := ReportConveyorID;
  New(FExLocal, Create(FClientID));
  FPurpose := spReportConveyor;
  if DebugModeOn then
    DebugMessage('Creating sentinel');

end;


procedure TSentinelReportConveyor.Run(TestMode : Boolean = False; RepQuery : Boolean = False);
var
  KeyS : Str255;
  Res : SmallInt;
  s : AnsiString;
  eSub, eMsg : AnsiString;
  WorkStation : TElertWorkstationSetup;
  FaxSent, EmailSent, PrintSent : Boolean;
  AList : TStringList;
  Prog, ProgStep : Integer;
  SwapPath : String;

begin
  Conveyor_OKToClose := False;
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - Start');
  {$ENDIF}
  FTestMode := TestMode;
  AList := TStringList.Create;
  WorkStation := TElertWorkstationSetup.Create;
  Prog := 0;
  Try
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      LSetDrive := FDataPath;
      Open_System(CustF, 15);
      //16 doesn't seem to be used
      Open_System(ElertF, LineF);

  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After OpenSystem');
  {$ENDIF}
      KeyS := MakeElertNameKey(FUser, FElertName);

      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS); //don't forget to lock

      if Res = 0 then
        Res := Lock;

        if (Res = 0) and not FTestMode then
        begin
          LElertRec.elWorkStation := WorkStationName;
          Save;
          Res := Lock;
        end;

  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After Record Lock: Res = ' + IntToStr(Res));
  {$ENDIF}

      if Res = 0 then
      begin

        with LElertRec do
        begin
          ProgStep := 50;


          FaxSent := not elActions.eaRepFax;
          EmailSent := not elActions.eaRepEmail;
          PrintSent := not elActions.eaRepPrinter;

          if WorkStation.CanSendFax and
            ((elActions.eaRepFax and not FaxSent))
            then
          begin
            s := '';
            KeyS := OutputKey(otFaxNo, LElertRec.elInstance);
            Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

            While (Res = 0) and CheckFullOutputLineKey(otFaxNo, LElertRec.elInstance) do
            begin
              AList.Add(LElertLineRec.Output.eoLine1 + '|' +
                              LElertLineRec.Output.eoLine2);

              Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
            end;

           if AList.Count > 0 then
           begin
            if elActions.eaRepEmail then
              ProgStep := 100 div (AList.Count + 1)
            else
              ProgStep := 100 div AList.Count;


            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Fax Messages');
            Try
             if SendFax(AList, Prog) = 0 then
               FaxSent := True
             else
               FAxSent := False;
            Except
              FaxSent := False;
            End;
           end
           else
             FaxSent := True;

           if FaxSent then
           begin
             if Assigned(FOnThreadProgress) then
               FOnThreadProgress(Prog, 'Fax Messages sent');

             LElertRec.elFaxTries := 0;
             Sleep(300);
           end
           else
             Inc(LElertRec.elFaxTries);

          end; //can send fax;

          if WorkStation.CanSendEmail and
          ((elActions.eaRepEmail and not EmailSent))
            then
          begin
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - SendRepEmail');
  {$ENDIF}
            //SendRepEmail
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Email Messages');
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After ThreadProgress');
  {$ENDIF}

            eSub := GetOutputText(otRepEmailSubject);
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After GetOutputText 2');
  {$ENDIF}
            eMsg := GetOutputText(otRepEmailLine);
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After GetOutputText 2');
  {$ENDIF}
            if SendReportEmail(eSub, eMsg) = 0 then
              EmailSent := True
            else
              EmailSent := False;
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - After SendReportEmail: EmailSent = ' + IntToStr(Ord(EmailSent)));
  {$ENDIF}
            if EmailSent then
            begin
              Sleep(300);
              Prog := Prog + ProgStep;
              if Assigned(FOnThreadProgress) then
                 FOnThreadProgress(100, 'Email Messages sent');
              Sleep(300);
              LElertRec.elEmailTries := 0;
            end
            else
              Inc(LElertRec.elEmailTries);

          end;

          if WorkStation.CanPrint and
            ((elActions.eaRepPrinter and not PrintSent))
            then
          begin
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Printing Report');

            PrintSent := Print = 0;
          end;

          if (FaxSent and EmailSent) and (PrintSent) then
            elStatus := Ord(esIdle)
          else
          if (FaxSent and elActions.eaRepEmail) then
            elStatus := Ord(esReportEmailReadyToGo)
          else
          if (EmailSent and elActions.eaRepFax) then
            elStatus := Ord(esFaxReadyToGo)
          else
            elStatus := elPrevStatus;

          if elStatus = Ord(esIdle) then
          begin
            Try
              //Delete temp file
              SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\'
                +  FExLocal^.LElertRec.elRepFile;
            Except
            End;
            elInstance := 0; //reset
          end;
          {Res := LPut_Rec(ElertF, 0);}
          elWorkStation := BlankWorkStation;
          Res := Save;
          if (Res <> 0) then
            DebugMessage('Error on save in ReportConveyor.run', Res);
        end; //with LElertRec
        UnLock;
      end //if res = 0
      else
        WriteRespawn(spReportConveyor);
      Close_files;
      if Res = 0 then
      begin
        LogIt(spQuery, S_FINISHED);
        FRanOK := True;
      end
      else
        LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
    end; //with FExLocal^
  Finally
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.Run - End');
  {$ENDIF}

    WorkStation.Free;
    Conveyor_OKToClose := True;
  End;
end;

function TSentinelReportConveyor.SendFax(AList : TStringList; var Prog : Integer) : SmallInt;
var
  PrnInfo : TSBSPrintSetupInfo;
  WorkStation : TElertWorkstationSetup;
  KeyS : Str255;
  Res : SmallInt;
  RepFiler : TFilePrinter;
  SwapPath : AnsiString;
  c : integer;
  FToName, FToNo : ShortString;
  FloatStep, FloatPos : Double;
  IntPos : Integer;

  TParam : TPrintParam;

  procedure SplitFaxString(const s : ShortString; var s1, s2 : ShortString);
  var
    i : integer;
  begin
    i := Pos('|', s);
    s1 := Copy(s, 1, i - 1);
    s2 := Copy(s, i + 1, Length(s));
  end;

begin
  UpdateTick;
  Result := 0;
  SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\';
  FillChar(PrnInfo, SizeOf(PrnInfo), #0);
  FillChar(TParam, SizeOf(TParam), #0);


  PrnInfo.Preview := False;
  PrnInfo.DevIdx := SetFaxPrinter;
  PrnInfo.feFaxPrinter := SetFaxPrinter;
  PrnInfo.NoCopies := 1;
  PrnInfo.TestMode := False;
  PrnInfo.LabelMode := False;
  PrnInfo.ChequeMode := False;
  PrnInfo.fePrintMethod := 1;
  PrnInfo.feFaxMethod := SetFaxMethod;
  PrnInfo.feFaxMsg := GetOutputText(otFaxNoteLine);

  PrnInfo.feFaxPrinter := SetFaxPrinter;
  with FExLocal^, LelertRec do
  begin

    if elActions.eaRepEmail then
       FloatStep := 100 / (AList.Count + 1)
    else
       FloatStep := 100 / AList.Count;


    FloatPos := Prog;

    PrnInfo.feCoverSheet := elFaxCover;
    PrnInfo.feJobtitle := Trim(elElertName);
    PrnInfo.feFaxPriority := elFaxPriority;
    KeyS := OutputKey(otFaxFrom, elInstance);
    Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

    if Res = 0 then
    begin

      PrnInfo.feFaxFrom := LElertLineRec.Output.eoLine1;
      PrnInfo.feFaxFromNo := LElertLineRec.Output.eoLine2;
    end;

    for c := 0 to AList.Count - 1 do
    begin
      UpdateTick;
      SplitFaxString(AList[c], FToName, FToNo);
      PrnInfo.feFaxTo := FToName;
      PrnInfo.feFaxToNo := FToNo;

      with TParam do
      begin
        DelSwapFile := False;
        PBatch := False;
        PDevRec := PrnInfo;
        RepCaption := '(Sentimail) ' + FElertName;
        SwapFileName := '';
        FileName := SwapPath + elRepFile;
        UFont := nil;
        Orient := poPortrait;
        eCommLink := nil;
      end;


      Try
        IntPos := Trunc(FloatPos);
        if Assigned(FOnThreadProgress) then
          FOnThreadProgress(IntPos, 'Sending Fax Messages',
                                    'Sending message ' + IntToStr(c + 1),
                                    FToName + ' ' + FToNo);

          PrimeFax(TParam);
          PrnInfo.feJobTitle := TParam.PDevRec.feJobtitle;
          PrintFileTo(PrnInfo, SwapPath + elRepFile, TParam.PDevRec.feJobtitle);
      Except
        Result := Result + 1;
      End;
      FloatPos := FloatPos + FloatStep;
    end; //for c
  end; //with
  ResetTick;
end;

function TSentinelReportConveyor.SendReportEmail(const eSub, eMsg : AnsiString) : SmallInt;
var
  PrnInfo : TSBSPrintSetupInfo;
  WorkStation : TElertWorkstationSetup;
  KeyS, OldServer : Str255;
  Res : SmallInt;
  RepFiler : TFilePrinter;
  SwapPath, TempPath : AnsiString;
  TempP : PChar;
  TempOK : DWord;
begin
  {$IFDEF Debug}
  DebugMessage('ReportConveyor.SendReportEmail - Start');
  {$ENDIF}
  UpdateTick;
  FExLocal^.LGet_Sys;
  SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\';
  TempPath := IncludeTrailingBackSlash(SwapPath) + FExLocal^.LElertRec.elRepFile;
  OldServer := {FExLocal^.L}SyssEDI2^.EDI2Value.EmSMTP;

  WorkStation := TElertWorkstationSetup.Create;
  SyssEDI2^.EDI2Value.EmSMTP := WorkStation.SMTPServer;
  RepFiler := TFilePrinter.Create(nil);

  Try
    FillChar(PrnInfo, SizeOf(PrnInfo), #0);
    PrnInfo.feEmailMAPI := WorkStation.UseMapi;
    PrnInfo.feEmailFrom := WorkStation.SMTPUser;
    PrnInfo.feEmailFromAd := WorkStation.SMTPAddress;
    PrnInfo.DevIdx := pfFind_DefaultPrinter(FExLocal^.LSyssEDI2^.EDI2Value.EmailPrnN);
    PrnInfo.feEmailPriority := 1;


    PrnInfo.feEmailSubj := eSub;
    PrnInfo.feEmailMsg := eMsg + ElEmailTrailer;


   (************** Temporary change **************)
   {$IFDEF Internal} //Fax server used on the internal accounts has trouble with adobe
   PrnInfo.feEmailAtType := 0;
   {$ELSE}
    if WorkStation.OutputFormat = 0 then
      PrnInfo.feEmailAtType := FExLocal^.LelertRec.elRpAttachMethod
    else
    begin
      Case WorkStation.OutputFormat of
        1 : PrnInfo.feEmailAtType := 0;
        2 : PrnInfo.feEmailAtType := 2;
      end;
    end;
    {$ENDIF}
    if PrnInfo.feEmailAtType = 0 then
      PrnInfo.feEmailZip := 2
    else
      PrnInfo.feEmailZIP := 0;

    PrnInfo.fePrintMethod := 2; //Email

    with FExLocal^ do
    begin
      if (LElertRec.elRecipNo > 0) then
      begin
        PrnInfo.feEmailTo := ';' + GetRemoteRecipient(LElertRec.elRecipNo) + ';';
        LElertRec.elRecipNo := 0;
      end
      else
      begin
        KeyS := OutputKey(otRepEmailAdd, LElertRec.elInstance);
        Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

        While (Res = 0) and CheckFullOutputLineKey(otRepEmailAdd, LElertRec.elInstance) do
        with LElertLineRec.Output do
        begin
          UpdateTick;
          Case TEmailRecipType(eoEmType) of
            ertTo  :  PrnInfo.feEmailTo := PrnInfo.feEmailTo + eoLine1 + ';' + eoLine2 + ';';
            ertCC  :  PrnInfo.feEmailCC := PrnInfo.feEmailCC + eoLine1 + ';'+ eoLine2 + ';';
            ertBCC :  PrnInfo.feEmailBCC := PrnInfo.feEmailBCC + eoLine1 + ';'+ eoLine2 + ';';
          end;

          Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);

        end;
      end;

      Try
{$IFDEF Debug}
        DebugMessage('TempPath: ' + TempPath);
{$ENDIF}
        DebugMessage(PrnInfo.feEmailFrom + ', ' + PrnInfo.feEmailTo + ', ' +
                     PrnInfo.feEmailToAddr + ', ' + PrnInfo.feEmailToAddr);
        SendEmailFile2(PrnInfo, RepFiler, TempPath, True);

        Result := 0;
        DebugMessage('Report emails sent');
      Except
        on E: Exception do
        begin
          Result := 1;
          DebugMessage('Error sending email: ' + E.Message, 1);
        end;
      End;
    end; //with
  Finally
    {FExLocal^.L}SyssEDI2^.EDI2Value.EmSMTP := OldServer;
    WorkStation.Free;
    RepFiler.Free;
    StrDispose(TempP);
    ResetTick;
  End;
end;


function TSentinelReportConveyor.SetReportPrinter : SmallInt;
begin
  Result := RpDev.DeviceIndex;
end;

function TSentinelReportConveyor.SetFaxPrinter : SmallInt;
begin
  Result := pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN);
end;

function TSentinelReportConveyor.SetFaxMethod : Byte;
begin
  Result := SyssEDI2^.EDI2Value.FxUseMAPI;
end;

function TSentinelReportConveyor.Print : SmallInt;
var
  PrnInfo : TSBSPrintSetupInfo;
  SwapPath : AnsiString;
begin
  SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\';
  FillChar(PrnInfo, SizeOf(PrnInfo), #0);
  PrnInfo.Preview := False;
  PrnInfo.DevIdx := SetReportPrinter;
  PrnInfo.NoCopies := 1;
  PrnInfo.TestMode := False;
  PrnInfo.LabelMode := False;
  PrnInfo.ChequeMode := False;

  with FExLocal^.LElertRec do
  Try
    if Assigned(FOnThreadProgress) then
      FOnThreadProgress(50, 'Printing Report',
                               'Printing ' + Trim(elElertName));

    PrintFileTo(PrnInfo, SwapPath + elRepFile, elElertName);
    Result := 0;
  Except
    Result := 1;
  End;
end;

  Procedure TSentinelReportConveyor.PrimeFax(Var PParam  :  TPrintParam);
  Var

    EntFaxO : TEntFaxInt;
    Res     : SmallInt;
  Begin


        With PParam do
        Begin

          With PDevRec do
          If (fePrintMethod = 1) And (feFaxMethod In [0,2]) Then
          Begin
            { Faxing via Enterprise }
            EntFaxO := TEntFaxInt.Create;

            Try
              With EntFaxO Do
              Begin
                //PR: 08/07/2013 ABSEXCH-14438 Rebranding
                fxDocName := 'Exchequer Sentimail Fax';

                fxRecipName := PDevRec.feFaxTo;
                fxRecipNumber := PDevRec.feFaxToNo;

                fxSenderName := PDevRec.feFaxFrom;
                fxSenderEmail := PDevRec.feEmailFromAd;


                fxUserDesc := {PDevRec.feFaxMsg;}  RepCaption;

                InitFromPrnInfo (PDevRec);

                fxFaxDir:=SyssEDI2^.EDI2Value.FaxDLLPath;

                If (SyssEDI2^.EDI2Value.FxUseMAPI<>2) then
                  Res := StoreDetails  {Sent via main program}
                else
                  Begin {This is all experimental to see if we could solve Neils OLE GPF problem}
                    PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,99,LongInt(EntFaxO));
                    Res:=0;
                  end;

                If (Res = 0) Then
                Begin
                  { AOK - pull back print job title }
                  feJobtitle := fxDocName;

                End; { If }

                If (SyssEDI2^.EDI2Value.FxUseMAPI<>2) then
                  EntFaxO.Destroy;
              End; { With }
            Except
              EntFaxO.Destroy;
            End;

          end;

        end; {With..}
  end;

{============================== CSV Conveyor ==================================}

constructor TSentinelCSVConveyor.Create;
begin
  inherited Create(CSVConveyorID); //PR: 21/09/2009 Memory Leak Change
  FClientID := CSVConveyorID;
  FPurpose := spCSVConveyor;
  if DebugModeOn then
    DebugMessage('Creating sentinel');
end;


procedure TSentinelCSVConveyor.Run(TestMode : Boolean = False; RepQuery : Boolean = False);
var
  KeyS : Str255;
  Res : SmallInt;
  s : AnsiString;
  eSub, eMsg : AnsiString;
  WorkStation : TElertWorkstationSetup;
  CopySent, EmailSent, FTPSent : Boolean;
  AList : TStringList;
  Prog, ProgStep : Integer;
  SwapPath : String;
  ActionsWanted, ActionsDone : Byte;
  ThisStat : TElertStatus;
begin
  Conveyor_OKToClose := False;
  FTestMode := TestMode;
  AList := TStringList.Create;
  WorkStation := TElertWorkstationSetup.Create;
  Prog := 0;
  Try
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      LSetDrive := FDataPath;
      Open_System(ElertF, LineF);

      KeyS := MakeElertNameKey(FUser, FElertName);

      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS); //don't forget to lock

      if Res = 0 then
        Res := Lock;

        if (Res = 0) and not FTestMode then
        begin
          LElertRec.elWorkStation := WorkStationName;
          Save;
          Res := Lock;
        end;


      if Res = 0 then
      begin
        with LElertRec do
        begin
          ProgStep := 50;

          ThisStat := TElertStatus(elPrevStatus);
          CopySent  := not (ThisStat in csvCopyReadyToGoSet);
          EmailSent := not (ThisStat in csvEmailReadyToGoSet);
          FTPSent   := not (ThisStat in csvFTPReadyToGoSet);

          if WorkStation.CanSendFTP and
            ((elCSVByFTP and not FTPSent))
            then
          begin
            s := '';
            if elCSVByEmail then
              ProgStep := 100 div (AList.Count + 1)
            else
              if AList.Count > 0 then
                ProgStep := 100 div AList.Count
              else
                ProgStep := 100;


            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending File by FTP');
            Try
             if SendFileByFTP = 0 then
               FTPSent := True
             else
               FTPSent := False;
            Except
              FTPSent := False;
            End;

           if FTPSent then
           begin
             if Assigned(FOnThreadProgress) then
               FOnThreadProgress(Prog, 'Files sent by FTP');

             LElertRec.elFTPTries := 0;
             Sleep(300);
           end
           else
             Inc(LElertRec.elFTPTries);

          end; //can send fax;

          if WorkStation.CanSendEmail and
          ((elCSVByEmail and not EmailSent))
            then
          begin
            //SendRepEmail
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Email Messages');

            eSub := GetOutputText(otRepEmailSubject);
            eMsg := GetOutputText(otRepEmailLine);
            if SendFileByEmail(eSub, eMsg) <= 1 then
              EmailSent := True
            else
              EmailSent := False;
            if EmailSent then
            begin
              Sleep(300);
              Prog := Prog + ProgStep;
              if Assigned(FOnThreadProgress) then
                 FOnThreadProgress(100, 'Email Messages sent');
              Sleep(300);
              LElertRec.elEmailTries := 0;
            end
            else
              Inc(LElertRec.elEmailTries);

          end;

          if elCSVToFolder and not CopySent then
          begin
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Copying file');

            CopySent := CopyFile = 0;
          end;

          ActionsWanted := 0;
          if elCSVToFolder then ActionsWanted := ActionsWanted or 1;
          if elCSVByFTP then ActionsWanted := ActionsWanted or 2;
          if elCSVByEmail then ActionsWanted := ActionsWanted or 4;

          ActionsDone := 0;
          if elCSVToFolder and CopySent then ActionsDone := ActionsDone or 1;
          if elCSVByFTP and FTPSent then ActionsDone := ActionsDone or 2;
          if elCSVByEmail and EMailSent then ActionsDone := ActionsDone or 4;

          ActionsWanted := ActionsWanted xor ActionsDone;

          if ActionsWanted = 0 then
            elStatus := Ord(esIdle)
          else
            elStatus := Ord(Pred(esCopyReadyToGo)) + ActionsWanted;

          if elStatus = Ord(esIdle) then
          begin
            Try
              //Delete temp file
              SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\'
                +  FExLocal^.LElertRec.elRepFile;
              if FileExists(SwapPath) then
              begin
                SysUtils.DeleteFile(SwapPath);
                if FExLocal^.LElertRec.elDBF then
                begin
                  SwapPath := ChangeFileExt(SwapPath, '.mdx');
                  if FileExists(SwapPath) then
                    SysUtils.DeleteFile(SwapPath);
                end;
              end;

              //Delete temp file if renamed
              SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\'
                + FExLocal^.LElertRec.elCSVFileName;
              if FileExists(SwapPath) then
              begin
                SysUtils.DeleteFile(SwapPath);
                if FExLocal^.LElertRec.elDBF then
                begin
                  SwapPath := ChangeFileExt(SwapPath, '.mdx');
                  if FileExists(SwapPath) then
                    SysUtils.DeleteFile(SwapPath);
                end;
              end;
              FExLocal^.LElertRec.elCSVFileRenamed := False;
            Except
            End;
            elInstance := 0; //reset
          end;
          elWorkStation := BlankWorkStation;
          Res := Save;
          if (Res <> 0) then
            DebugMessage('Error on save in CSVConveyor.run', Res);
        end; //with LElertRec
        UnLock;
      end //if res = 0
      else
        WriteRespawn(spCSVConveyor);
      Close_files;
      if Res = 0 then
      begin
        LogIt(spQuery, S_FINISHED);
        FRanOK := True;
      end
      else
        LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
    end; //with FExLocal^
  Finally
    WorkStation.Free;
    Conveyor_OKToClose := True;
  End;
end;

function TSentinelCSVConveyor.CopyFile : SmallInt;
var
  FromFile, ToFile : TFileStream;
  FromPath, ToPath : AnsiString;
  FName : String;

  function DoCopy(const FromF, ToF : string) : SmallInt;
  begin
    Result := 0;
    Try
      FromFile := TFileStream.Create(FromF, fmOpenRead or fmShareDenyWrite);
    Except
      Result := 1;
    End;

    if Result = 0 then
    Try
      Try
        ToFile := TFileStream.Create(ToF, fmCreate or fmShareExclusive);
      Except
        Result := 2;
      End;

      if Result = 0 then
      Try
        Try
          ToFile.CopyFrom(FromFile, FromFile.Size);
        Except
          Result := 3;
        End;
      Finally
        ToFile.Free;
      End;
    Finally
      FromFile.Free;
    End;

  end;
begin
  Result := 0;
  UpdateTick;
  if FExLocal^.LElertRec.elCSVFileRenamed then
    FName := FExLocal^.LElertRec.elCSVFileName
  else
    FName := FExLocal^.LElertRec.elRepFile;

  FromPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' + FName;
  DebugLog.LogIt(spReportConveyor, 'CSV Copy: FromFile = ' + QuotedStr(FromPath), True);

  ToPath   := GlobalEntPath +
                     IncludeTrailingBackSlash(FExLocal^.LElertRec.elRepFolder)
                        + FExLocal^.LElertRec.elCSVFileName;
  DebugLog.LogIt(spReportConveyor, 'CSV Copy: ToFile = ' + QuotedStr(ToPath), True);

  Result := DoCopy(FromPath, ToPath);
  DebugLog.LogIt(spReportConveyor, 'CSV Copy: Result = ' + IntToStr(Result), True);

  if (Result = 0) and FExLocal^.LElertRec.elDBF and FileExists(ChangeFileExt(FromPath, '.mdx')) then
  begin
    Result := DoCopy(ChangeFileExt(FromPath, '.mdx'), ChangeFileExt(ToPath, '.mdx'));
    DebugLog.LogIt(spReportConveyor, 'CSV Copy idx file: Result = ' + IntToStr(Result), True);
  end;

  ResetTick;
end;

function TSentinelCSVConveyor.SendFileByFTP : SmallInt;
var
  SwapF1, SwapF2 : String;
begin
  UpdateTick;
  SwapF1 := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' + FExLocal^.LElertRec.elCSVFileName;
  SwapF2 := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' +
                FExLocal^.LElertRec.elRepFile;
//  LogMessage(FPurpose, FUser, FElertName, 'OldName=' + SwapF2 + ',NewName='+SwapF1);

  if UpperCase(Trim(SwapF1)) = UpperCase(Trim(SwapF2)) then
    FExLocal^.LElertRec.elCSVFileRenamed := True;

  if not FExLocal^.LElertRec.elCSVFileRenamed and FileExists(SwapF1) then
    DeleteFile(PChar(SwapF1));
  Result := RenameCSVFile(SwapF1, SwapF2);
//  LogMessage(FPurpose, FUser, FElertName, 'RenameCSVFile - Result = ' + IntToStr(Result));

  if Result = 0 then
  begin
    with TfrmFTP.Create(nil) do
    Try
      UserName := FExLocal.LElertRec.elFTPUserName;
      Password := FExLocal.LElertRec.elFTPPassword;
      Server   := FExLocal.LElertRec.elFTPSite;
      RemoteDir := FExLocal.LElertRec.elUploadDir;
      Port := FExLocal.LElertRec.elFtpPort;
      UpdateTickProc := UpdateTick;
      Try
        Timeout := FExLocal.LElertRec.elFTPTimeout * 60000;
      Except
        Timeout := High(integer);
      End;
      Try
        if SendFile(SwapF1) then
          Result := 0
        else
          Result := 7;
      Except
        Result := 7;
      End;

{      if Result = 0 then
        if FileExists(SwapF1) then
          SysUtils.DeleteFile(SwapF1);}

    Finally
      Free;
    End;
  end;
  ResetTick;
end;

function TSentinelCSVConveyor.SendFileByEmail(const eSub, eMsg : AnsiString) : SmallInt;
var
  SwapF1, SwapF2 : String;
begin
  UpdateTick;
  //If file to send exists then delete it
  Result := 0;
  SwapF1 := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' + FExLocal^.LElertRec.elCSVFileName;
  SwapF2 := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' +
                FExLocal^.LElertRec.elRepFile;

  Result := RenameCSVFile(SwapF1, SwapF2);
  if Result = 0 then
  begin
     FPaperless := SwapF1;
     WriteAddresses;
     //PR: 23/11/2009 SendEmail wasn't attaching the csv file because elSendDoc not set
     FExLocal^.LElertRec.elSendDoc := True;
     Result := SendEmail(eSub, eMsg, True);
     DeleteOutputLines(otEmailAdd2Go);
{     if Result = 0 then
       if FileExists(SwapF1) then
         SysUtils.DeleteFile(SwapF1);}
  end;
  ResetTick;
end;

function TSentinelCSVConveyor.RenameCSVFile(const s1, s2 : AnsiString) : SmallInt;
var
  IdxStr1, IdxStr2 : string;
begin
  //If file to send exists then delete it
  Result := 0;
  if AnsiCompareText(s1, s2) <> 0 then
  if not FExLocal^.LElertRec.elCSVFileRenamed then
  begin
    if FileExists(s1) then
      DeleteFile(PChar(s1));
    IdxStr1 := ChangeFileExt(s1, '.mdx');
    IdxStr2 := ChangeFileExt(s2, '.mdx');

    if Result = 0 then
    Try
      //Rename swap file to file to send
      if RenameFile(s2, s1) then
        FExLocal^.LElertRec.elCSVFileRenamed := True
      else
        Result := 6;
    Except
      Result := 6;
    End;

    if (Result = 0) and FExLocal^.LElertRec.elDBF then
    Try
      //Rename swap file to file to send
      if not RenameFile(IdxStr2, IdxStr1) then
      begin
        Result := 6;
        FExLocal^.LElertRec.elCSVFileRenamed := False;
      end;
    Except
      Result := 6;
      FExLocal^.LElertRec.elCSVFileRenamed := False;
    End;

  end;
end;

procedure TSentinelCSVConveyor.WriteAddresses;
var
  Res, i : SmallInt;
  s : AnsiString;
  KeyS : Str255;
  AList : TStringList;
  Acount : SmallInt;
  EType : Integer;
begin
  AList := TStringList.Create;
  EType := 0;
  Try
    with FExLocal^ do
    begin
      //PR: 04/03/2011 Wasn't using elRecipNo for Remotely Triggered with SEND=ME
      if (LElertRec.elRecipNo > 0) then
      begin
        s := GetRemoteRecipient(LElertRec.elRecipNo);
        LElertRec.elRecipNo := 0;
        if s <> '' then
        begin
          EType := 0; //To

          AList.AddObject(s, TObject(EType));

        end;
      end;

      if AList.Count = 0 then
      begin

        i := 0;
        KeyS := OutputKey(otRepEmailAdd, LElertRec.elInstance);

        Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

        While (Res = 0) and CheckFullOutputLineKey(otRepEmailAdd, LElertRec.elInstance) do
        begin
          s := LElertLineRec.Output.eoLine2;
          EType := LElertLineRec.Output.eoEmType;

          AList.AddObject(s, TObject(EType));

          Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
        end;
      end;

      FillChar(LElertLineRec, SizeOf(LElertLineRec), #0);

      for i := 0 to AList.count - 1 do
      with LElertLineRec do
      begin
        Prefix := pxElOutput;
        Output.eoUserID  := LElertRec.elUserID;
        Output.eoElertName := LElertRec.elElertName;
        Output.eoInstance := LElertRec.elInstance;
        Output.eoMsgInstance := 0;

        Output.eoOutputType := otEmailAdd2Go;
        Output.eoEmType := Byte(AList.Objects[i]);

        Output.eoLineNo := i + 1;
        Output.eoLine1 := AList[i];

        Res := LAdd_Rec(LineF, ellIdxOutputType);

      end;
    end;
  Finally
   AList.Free;
  End;
end;

procedure TestCreate;
var
  FSent : TSentinelQuery;
  i : integer;
begin

  for i := 1 to 10 do
  begin
    FSent := TSEntinelQuery.Create;
    Sleep(1000);
    FSent.Free;
    FSent := nil;
    Sleep(1000);
  end;
end;



{ TSentinelVisualReportConveyor }

constructor TSentinelVisualReportConveyor.Create;
var
  ID : AnsiString;
begin
  inherited Create(VisualReportConveyorID); //PR: 21/09/2009 Memory Leak Change
  FClientID := VisualReportConveyorID;
  FPurpose := spVisualReportConveyor;
  if DebugModeOn then
  begin
    DebugMessage('Creating sentinel');
    ID := 'Sentinel VRW Conveyor Create. ThreadID: ' + IntToStr(GetCurrentThreadID);
    OutputDebugString(PChar(ID));
  end;

end;

procedure TSentinelVisualReportConveyor.Run(TestMode, RepQuery: Boolean);
var
  KeyS : Str255;
  Res : SmallInt;
  s : AnsiString;
  eSub, eMsg : AnsiString;
  WorkStation : TElertWorkstationSetup;
  FaxSent, EmailSent, PrintSent : Boolean;
  AList : TStringList;
  Prog, ProgStep : Integer;
  SwapPath : String;

begin
  Conveyor_OKToClose := False;

  FTestMode := TestMode;
  AList := TStringList.Create;
  WorkStation := TElertWorkstationSetup.Create;
  Prog := 0;
  Try
    if Assigned(FExLocal) then
    with FExLocal^ do
    begin
      LSetDrive := FDataPath;
      Open_System(CustF, 15);
      //16 doesn't seem to be used
      Open_System(ElertF, LineF);

      KeyS := MakeElertNameKey(FUser, FElertName);

      Res := LFind_Rec(B_GetEq, ElertF, 0, KeyS); //don't forget to lock

      if Res = 0 then
        Res := Lock;

        if (Res = 0) and not FTestMode then
        begin
          LElertRec.elWorkStation := WorkStationName;
          Save;
          Res := Lock;
        end;


      if Res = 0 then
      begin
        with LElertRec do
        begin
          ProgStep := 50;


          FaxSent := not elActions.eaRepFax;
          EmailSent := not elActions.eaRepEmail;
          PrintSent := not elActions.eaRepPrinter;

          if WorkStation.CanSendFax and
            ((elActions.eaRepFax and not FaxSent))
            then
          begin
            s := '';
            KeyS := OutputKey(otFaxNo, LElertRec.elInstance);
            Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

            While (Res = 0) and CheckFullOutputLineKey(otFaxNo, LElertRec.elInstance) do
            begin
              AList.Add(LElertLineRec.Output.eoLine1 + '|' +
                              LElertLineRec.Output.eoLine2);

              Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
            end;

           if AList.Count > 0 then
           begin
            if elActions.eaRepEmail then
              ProgStep := 100 div (AList.Count + 1)
            else
              ProgStep := 100 div AList.Count;


            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Fax Messages');
            Try
             if SendFax(AList, Prog) = 0 then
               FaxSent := True
             else
               FAxSent := False;
            Except
              FaxSent := False;
            End;
           end
           else
             FaxSent := True;

           if FaxSent then
           begin
             if Assigned(FOnThreadProgress) then
               FOnThreadProgress(Prog, 'Fax Messages sent');

             LElertRec.elFaxTries := 0;
             Sleep(300);
           end
           else
             Inc(LElertRec.elFaxTries);

          end; //can send fax;

          if WorkStation.CanSendEmail and
          ((elActions.eaRepEmail and not EmailSent))
            then
          begin
            //SendRepEmail
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Sending Email Messages');

            eSub := GetOutputText(otRepEmailSubject);
            eMsg := GetOutputText(otRepEmailLine);
            if SendEmail(eSub, eMsg, True) = 0 then
              EmailSent := True
            else
              EmailSent := False;
            if EmailSent then
            begin
              Sleep(300);
              Prog := Prog + ProgStep;
              if Assigned(FOnThreadProgress) then
                 FOnThreadProgress(100, 'Email Messages sent');
              Sleep(300);
              LElertRec.elEmailTries := 0;
            end
            else
              Inc(LElertRec.elEmailTries);

          end;

          if WorkStation.CanPrint and
            ((elActions.eaRepPrinter and not PrintSent))
            then
          begin
            if Assigned(FOnThreadProgress) then
              FOnThreadProgress(Prog, 'Printing Report');

            PrintSent := Print = 0;
          end;

          if (FaxSent and EmailSent) and (PrintSent) then
            elStatus := Ord(esIdle)
          else
          if (FaxSent and elActions.eaRepEmail) then
            elStatus := Ord(esReportEmailReadyToGo)
          else
          if (EmailSent and elActions.eaRepFax) then
            elStatus := Ord(esFaxReadyToGo)
          else
            elStatus := elPrevStatus;

          if elStatus = Ord(esIdle) then
          begin
            Try
              //Delete temp file
              //PR: 15/02/2011 Change to allow Adobe files to look in the correct folder 
                
               if elExRepFormat <> 255 then
//                 SwapPath := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' +
                   //PR: 15/06/2012 VRW has started to put files in windows temp folder ABSEXCH-13050
                   SwapPath := WinGetWindowsTempDir + elRepFile
               else
               begin
                 SwapPath := IncludeTrailingBackSlash(elRepFolder) +
                   elRepFile;
                 elRepFolder := '';
                 elExRepFormat := 0;
               end;

            Except
            End;
            elInstance := 0; //reset
          end;
          elWorkStation := BlankWorkStation;

          Res := Save;
          if (Res <> 0) then
            DebugMessage('Error on save in ReportConveyor.run', Res);
        end; //with LElertRec
        UnLock;
        if LElertRec.elEmailTries >= MaxRetries then
           raise Exception.Create('Error sending email.');

      end //if res = 0
      else
        WriteRespawn(spReportConveyor);
      Close_files;
    end; //with FExLocal^
    if Res = 0 then
    begin
      LogIt(spQuery, S_FINISHED);
      FRanOK := True;
    end
    else
      LogIt(spQuery, 'Unable to save record: ' + IntToStr(Res));
  Finally
    WorkStation.Free;
    AList.Free; //PR: 21/09/2009 Memory Leak Change
    Conveyor_OKToClose := True;
  End;
end;

function TSentinelVisualReportConveyor.SendEMail(const eSub,
  eMsg: AnsiString; IsCSV: Boolean): SmallInt;
var
  KeyS : Str255;
  Res, TempRes : SmallInt;
  s : AnsiString;
  M : PChar;
  TempLockPos : longint;
  ThisInst : SmallInt;
  ExceptStr : String;
  FWsSetup : TElertWorkstationSetup;

  AddressType : Char;
  j : integer;

  CurrentInst : SmallInt;
  FirstTime : Boolean;

  TmpStat, TmpKPath : Integer;
  TmpRecAddr : longint;
  FAbort : Boolean;
  IdxStr : string;

  function CheckAddressKey : Boolean;
  begin
    with FExLocal^ do
      Result :=  (Res = 0) and CheckFullOutputLineKey(otEmailAdd2Go, LElertRec.elInstance);
  end;

begin
  Result := 0;
  UpdateTick;
  FAbort := False;
  Try



    with FExLocal^ do
    begin
      FWsSetup := TElertWorkstationSetup.Create;
      Try
        with EntEmail do
        begin
           Recipients.Clear;
           CC.Clear;
           BCC.Clear;
           Attachments.Clear;
           if (FWsSetup.SMTPServer <> '') and not FWsSetup.UseMapi then
           begin
             Sender :=  FWsSetup.SMTPAddress;
             SenderName := FwsSetup.SMTPUser;
             SMTPServer := FWsSetup.SMTPServer;
             UseMAPI := FWsSetup.UseMapi;
           end
           else
           begin
             if FWsSetup.UseMapi then
               UseMapi := FWsSetup.UseMAPI
             else
             begin
               Result := -5;
               ExceptStr := 'SMTP Server blank';
             end;
           end;

           if Result = 0 then
           begin

           Subject := eSub;
           Message := PChar(eMsg {+ #13 + #10 + #13 + #10} + ElEmailTrailer);


      //PR: 04/03/2011 Wasn't using elRecipNo for Remotely Triggered with SEND=ME
      if (LElertRec.elRecipNo > 0) then
      begin
        EntEmail.Recipients.Add(GetRemoteRecipient(LElertRec.elRecipNo));
        LElertRec.elRecipNo := 0;
      end
      else
      begin
           KeyS := OutputKey(otRepEmailAdd, LElertRec.elInstance);
           Res := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);
           ThisInst := 0;
           CurrentInst := 0;
           FAbort := Conveyor_WantToClose;
           While not Abort and (Res = 0) and CheckFullOutputLineKey(otRepEmailAdd, LElertRec.elInstance) do
           begin
             UpdateTick;
             ThisInst := 0;


             Case TEmailRecipType(LElertLineRec.Output.eoEmType) of
               ertTo  :  EntEmail.Recipients.Add(LElertLineRec.Output.eoLine2);
               ertCC  :  EntEmail.CC.Add(LElertLineRec.Output.eoLine2);
               ertBCC :  EntEmail.BCC.Add(LElertLineRec.Output.eoLine2);
             end;

             Res := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);

           end;
      end;
             try
               if LElertRec.elExRepFormat <> 255 then
//                 FPaperless := IncludeTrailingBackSlash(FDataPath) + 'SWAP\' +
                 //PR: 15/06/2012 VRW has started to put files in windows temp folder ABSEXCH-13050
                 FPaperless := WinGetWindowsTempDir + LElertRec.elRepFile
               else
                 FPaperless := IncludeTrailingBackSlash(LElertRec.elRepFolder) +
                   LElertRec.elRepFile;

               if (FPaperless <> '') then
               begin
                 Attachments.Add(FPaperless);
               end;
               if EntEmail.Recipients.Count > 0 then
               begin
                 if not FAbort then
                   Result := Send
                 else
                   Result := 1;
                 if Result = 0 then
                   with EntEmail do
                     LogEmails(Recipients, CC, BCC);
               end
               else
               begin
                 Result := 1;
                 DebugMessage('Email message has no addresses');
               end;
             except // Trap any exceptions on sending E-mail
               on E: Exception do
               begin
                 Result := 2;
                 ExceptStr := E.Message;
               end;
             end;
             end;
          end;
       Finally
         if Result = 0 then
         begin
           DebugMessage('Email messages sent');
           LastEmailError := '';
           SysUtils.DeleteFile(FPaperless);
           if LElertRec.elExRepFormat = 255 then
             SysUtils.DeleteFile(ChangeFileExt(FPaperless, '.log'));
         end
         else
           if Result <> 999 then
           begin
             DebugMessage('Email error: ' + ExceptStr, Result);
             LastEmailError := ExceptStr;
           end;

         FWsSetup.Free; //PR: 21/09/2009 Memory Leak Change
       End;
    end;
  Finally
    ResetTick;
  End;

end;

procedure TSentinelPoller.LoadCompanies;
var
  i : integer;
  CodeObj : TCompanyCodeObj;
begin
end;

function TSentinelPoller.GetCompanyCode(const Path : string) : string;
var
  i : integer;
begin
  Result := SQLUtils.GetCompanyCode(Path);
end;

function TSentinel.GetNextTriggeredInstance: SmallInt;
var
  Res : Integer;
  KeyS, KeyChk : Str255;
  WhereClause, FColumns : AnsiString;
  CacheID : longint;
begin
  Result := 0;
  if UsingSQL then
  begin
    WhereClause :=  'UserID = '+ QuotedStr(FUser) + ' AND Name = ' + QuotedStr(FElertName) +
                    ' AND Prefix = ''T''';
    Res := CreateCustomPrefillCache(FExLocal^.LSetDrive + Filenames[LineF], WhereClause, FColumns, CacheID, FExLocal^.ExClientId);
    if Res = 0 then
    begin
      UseCustomPrefillCache(CacheID, FExLocal^.ExClientId);
      Res := FExLocal^.LFind_Rec(B_GetLast, LineF, ellIdxLineType, KeyS);
      if Res = 0 then
        Result := FExLocal^.LElertLineRec.Output.eoInstance;
      DropCustomPrefillCache(CacheID, FExLocal^.ExClientId); //PR: 21/09/2009 Memory Leak Change
    end;
  end
  else
  begin
    KeyS := pxTriggered + LJVar(FUser, UIDSize) + LJVar(FElertName, 30);
    KeyChk := KeyS;

    with FExLocal^ do
    begin
      Res := LFind_Rec(B_GetGEq, LineF, ellIdxLineType, KeyS);

      while (Res = 0) and (KeyS = KeyChk) do
      begin
        Result := LElertLineRec.Output.eoInstance;

        Res := LFind_Rec(B_GetNext, LineF, ellIdxLineType, KeyS);
      end;
    end;
  end;
  Result := Result + 1;
end;

procedure TSentinel.TurnOffSMS;
//Turn off SMS facility for engine.
begin
  with TElertWorkstationSetup.Create do
  Try
    CanSendSMS := False;
  Finally
    Free;
  End;

end;

procedure TSentinel.UseVariant;
begin
  if UsingSQL then
    UseVariantForNextCall(FExLocal.LocalF^[LineF], FExLocal.ExClientId);
end;

{ TSQLTest }

procedure TSQLTest.Close;
begin
  FExLocal.Close_Files;
end;

constructor TSQLTest.Create(CID: Integer);
begin
  inherited Create;
  FClientID := CID;
  New(FExLocal, Create(FClientID));
  FExLocal.LSetDrive := ExtractFilePath(Application.ExeName);
  DirectMode := False;
  AList := TStringList.Create;
end;

destructor TSQLTest.Destroy;
begin
  AList.Free;
  inherited;
end;

procedure TSQLTest.Run;
var
  Res : Integer;
  KeyS : Str255;
  i  : Integer;
begin
  i := 0;
  FExLocal.Open_System(StockF, StockF);
  Try
  Res := FExLocal.LFind_Rec(B_GetFirst + B_SingNWLock, StockF, 0, KeyS);

  while Res in [0, 84, 85] do
  begin

    Res := FExLocal.LFind_Rec(B_GetNext, StockF, 0, KeyS);

    if Res = 0 then
    begin
      Res := FExLocal.LFind_Rec(B_GetEq + B_SingNWLock, StockF, 0, KeyS);
    end;
    inc(i);
    if i = 100 then
    begin
      i := 0;
      if Assigned(FOnThreadProgress) then
        FOnThreadProgress(i);
    end;
  end;
  Finally
    FRanOK := True;
  End;
end;

function TSentinel.ThisElertWhereClause: string;
begin
  Result := GetDBColumnName('Sentline.dat', 'UserId', '') + ' = ' + QuotedStr(FUser) + ' AND ' +
            GetDBColumnName('Sentline.dat', 'Name', '') + ' = ' + QuotedStr(FElertName);
end;

function TSentinel.PrefixWhereClause(Pfix : Char): string;
begin
  Result := GetDBColumnName('Sentline.dat', 'Prefix', '') + ' = ' + QuotedStr('' + Pfix);
end;

procedure TSentinel.SetDataPath(const APath: AnsiString);
begin
  FDataPath := APath;
  FCompanyCode := SQLUtils.GetCompanyCode(APath);
end;

procedure TSentinelPoller.DeleteEventData;
var
  Res : Integer;
begin
  if FWantToDeleteEventData and (FExLocal.LElertRec.elType = 'E') then
  begin
    Res := FExLocal.LDelete_Rec(LineF, ellIdxLineType);
    FWantToDeleteEventData := False;
    if Res <> 0 then
      LogIt(spPoller, 'Unable to delete Event Instance Data. Res = ' + IntToStr(Res));
  end;
end;


destructor TSentinelReportConveyor.Destroy;  //PR: 21/09/2009 Memory Leak Change
begin

  inherited;
end;

procedure TSentinel.LogIt(Where : TSentinelPurpose; const s: string; MainLogOnly : Boolean = False);
var
  AList : TStringList;
  iCount : Integer;
  bDone : Boolean;
  LogS : string;
begin
  iCount := 0;
  bDone := False;
  while (iCount < 10) and not bDone do
  begin
    Try
      //PR: 05/11/2012 Change to use DateTimeToStr so that local date/time format is respected.
      LogS := LJVar(DateTimeToStr(Now), 23) + '>' + s;

      //PR: 10/12/2012 To improve performance, only write full log if debugging.
      if WantDebug or MainLogOnly then
      begin
        Append(LogFile);
        WriteLn(LogFile, LogS);
        CloseFile(LogFile);
      end;
      bDone := True;
    Except
      Wait(10 + Random(100));
      inc(iCount);
    End;
  end;

  //PR: 30/11/2012 Add one line log for communication to try to resolve Newbridge problem
  //The engine will only read this log, rather than the main log.
  //MainLogOnly is set to true if this function is called by the poller.
  if not MainLogOnly then
  begin
    FExtraLog[0] := LogS;
    iCount := 0;
    bDone := False;
    while (iCount < 10) and not bDone do
    begin
      Try
        FExtraLog.SaveToFile(ChangeFileExt(LogFileName, S_COMMON_LOG));
        bDone := True;
      Except;
        Wait(10 + Random(100));
        inc(iCount);
      End;
    end;
  end;
end;

procedure TSentinel.SendProgress(Max: Integer; s1, s2, s3, s4: ShortString);
begin
  LogIt(FPurpose, s1 + '  ' + s2 + '  ' + s3 + '  ' + s4);
end;

procedure TSentinelPoller.LoadRemoteList;
var
  AList : TStringList;
begin
  if FileExists(RemoteFileName) then
  begin
    AList := TStringList.Create;
    Try
      AList.LoadFromFile(RemoteFileName);
      RemoteList.AddStrings(AList);
    Finally
      AList.Free;
      SysUtils.DeleteFile(RemoteFileName);
    End;
  end;
end;

function TSentinel.RemoteFileName: string;
begin
  Result := GetEnterpriseDirectory + 'SWAP\' + REMOTE_LIST;
end;

procedure TSentinelEmailChecker.ShowMailProgress(const Msg: ShortString);
begin
  LogIt(spEmailCheck, Msg);
end;

procedure TSentinelPoller.DebugMessage(const s: ShortString;
  Error: SmallInt; IsSystem: Boolean);
var
  st : string;
  n : string;
begin
  st := 'Poller';
{$IFDEF Debug}

  st := '$ANN: ' + st + ': ' + s;
  OutputDebugString(Pchar(st));
{$ENDIF}

  with FExLocal^.LElertRec  do
    if Error <> 0 then
      LogError(FPurpose, FUser, '', s, Error)
    else
    begin
      if IsSystem then
        LogMessage(spSystem,'','', s)
      else
        LogMessage(FPurpose, FUser, FElertName, s);
    end;
end;

function TSentinelQuery.DoPrint(const ARef, AForm : AnsiString;
                                          AKey : longint;
                                          AttMethod : Byte;
                                          AttPrinter : string = ''): ShortString;
var
  EmailInfo : TEmailPrintInfoType;
  Res : Smallint;
  NameRec : TSentimailData;

begin
  FillChar(EmailInfo, SizeOf(EmailInfo), #0);
  EmailInfo.emPreview := False;
  EMailInfo.emCoverSheet := '';
  EmailInfo.emPriority := 1;
  FillChar(NameRec, SizeOf(NameRec), #0);

  if AddJob(AKey, ARef, AForm) then
  begin                                                                       //PR: 16/02/2011 ABSEXCH-10913
    Res := PrintToFile(@EmailInfo, @NameRec, SizeOf(EmailInfo), AttMethod, AttPrinter);
    if Res = 0 then
      Result := NameRec.sdFileName
    else
      Result := '';
  end;
end;

procedure TSentinelPoller.LogIt(Where: TSentinelPurpose; const s: string;
  MainLogOnly: Boolean);
begin
  inherited LogIt(Where, s, True);
end;

procedure TSentinel.SetUser(const Value: ShortString);
begin
//PR: 18/09/2013 ABSEXCH-14630 Need to get user record to see if they are allowed to view bank details
  FUser := Value;
  SetDrive := FDataPath;
  Open_System(PWrdF, PWrdF);
  if not GetLoginRec(FUser) then
    FillChar(EntryRec^, SizeOf(EntryRec^), 0);
end;

procedure TSentinelPoller.Run(TestMode, RepQuery: Boolean);
begin
  //Do nothing - avoid warning
end;

Initialization
  PollCount := 0;
  LastSMSError := '';
  LastEmailError := '';
  LastFTPError := '';
{$IFNDEF ELMAN}
  RemoteList := TStringList.Create;
  {$IFDEF REMOTE}
    {$IFNDEF VAO}
  //AP: 22/01/2018 ABSEXCH-19659 When access sentinel gives CoInitialize error
  //MailPoller := TEmailPoller.Create;
     {$ENDIF not VAO}
  {$ENDIF}
{$ENDIF}

Finalization
{$IFNDEF ELMAN}
  if Assigned(RemoteList) then
  begin
    Try
      RemoteList.Free;
    Finally
    End;

  end;

  {$IFDEF REMOTE}
    {$IFNDEF VAO}
  //MailPoller.Free;
     {$ENDIF not VAO}
  {$ENDIF}
{$ENDIF}
end.
