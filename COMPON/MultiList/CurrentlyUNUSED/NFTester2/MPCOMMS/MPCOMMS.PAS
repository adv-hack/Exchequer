unit MPComms;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , ExtCtrls, AdPort, AdPacket, adExcept, Debug, StrUtil, CmdList, Message
  , SyncObjs, APIUtil, FileUtil;

const
  MAX_NO_OF_COMS_LOGFILES = 100;
{  sSign = '00';

var
  iAscSign : integer;}

type
  TCommandType = (cmdSetGroupInfo, cmdSetProductInfo, cmdSetTransInfo, cmdSetDeptInfo
  , cmdGetScreenBalance, cmdPreGetMemberInfo, cmdGetTillName, cmdBlankMemberInfo, cmdWaitForBalance
  , cmdWaitForMemberInfo, cmdWaitForTransInfo, cmdWaitForGroupInfo, cmdWaitForDeptInfo
  , cmdWaitForProductInfo, cmdTillOnLine, cmdSetMemberInfo, cmdSetCardInfo, cmdGetCardInfo
  , cmdCancelling ,cmdSetBalance, cmdGetBestBalance, cmdGetBalance, cmdGetMaximums, cmdGetAllPLUSales
  , cmdGetAllHourlySales, cmdGetAllClerkData, cmdClearSalesData, cmdGetAllClerkInfo, cmdGetAllTransInfo
  , cmdGetPLUSales, cmdGetAllCashierSales);

  TCommand = class
    CommandType : TCommandType;
    TillNo : integer;
    Number : integer;
    Tries : integer;
    TryNo : integer;
    Data : TObject;
    Success : boolean;
    Done : boolean;
    Read : boolean;
    Append : boolean;
    Executing : boolean;
    Blank : boolean;
    constructor Create(newCommandType : TCommandType; iTillNo, newNumber
    , NoTries : integer; DataToSend : TObject);
    destructor Destroy;
  end;{TCommand}

  TCommsEvent = procedure(Command: TCommand) of object;

{RECORDS}
  TProductRec = Record
    PLUNumber  : string6;
    Code       : string32;
    SearchCode : string2;
    Name       : string16;
    Dept       : string4;
    Group      : string6;
    HighAmt    : string2;
    Flag3      : string2;
    Flag2      : string2;
    Flag1      : string2;
    Price      : string8;
  end;{TProductInfo}

  TGroupRec = Record
    TitleNumber : string2;
    Name : string12;
    {InvalidData := string2;}
    GroupNo : string6;
  end;

  TDeptRec = Record
    Number : string4;
    Name : string16;
    GroupNo : string2;
    HighAmt : string2;
    Flag3 : string2;
    Flag2 : string2;
    Flag1 : string2;
    Price : string8;
  end;

  TCardRec = Record
    TrackNo :   String6;
    Name :   String12;
    CardNo :   String6;
    SearchCode :   String2;
  end;

  TTaxDataRec = Record
    Qty : string6;
    Value : string10;
    Sign : string2;
  end;{TTaxData}

  TBalanceRec = Record
    Covers : String4;
    IV : String2;
    Value : String10;
    Sign : String2;
  end;{TBalanceRec}

  TTransactionRec = Record
    {TrackNo : String6}
    PacketNumber : string2;
    Flag : String2;
    Number : String6;
    Qty : String6;
    Spare : String1;
    Value : String9;
    Sign : String2;

    itType : Char;
    itNumber : LongInt;
    itQuantity : Real;
    itAmount   : Real;

    TrackRef : string7;
  end;{TTransactionRec}

  TMemSalesRec = Record
    iCardNo : integer;
    TrackNo : string6;
    {PacketNumber : string2}
    ClerkNumber : string6;
    SlipLineCount : string2;

    {TrackNo : string6}
    {PacketNumber : string2}
    TaxData : Array[1..4] of TTaxDataRec;
    NewBalance : TBalanceRec;
    Transactions : Array of TTransactionRec;
    Links : Array of string6;
    Deposits : Real;
  end;{TMemSalesData}

  TTransRec = Record
{    TranTypeNo : String4;}
    pQty       : String6;
    pAmount    : String10;
    pSign      : String2;
  End;{TTransRec}

  TTotTransRec = Record
    Qty : Real;
    Amount : Real;
  end;{TTotTransRec}
  TaTransInfo = array of TTotTransRec;

  TMaximumsRec = Record
    ShiftLevels   : String2;
    InvalidData1  : String2;
    Departments   : String4;
    PLU           : String6;
    InvalidData2  : String4;
    Cashiers      : String2;
    InvalidData3  : String4;
    Clerks        : String2;
    Guests        : String6;
    InvalidData4  : String4;
    Cards : string2;
  end;

  TPLURec = Record
    PLU       : String6;
    Qty       : String6;
    Amount    : String10;
    Sign      : String2;
  end;{TPLURec}
  TaPLURecs = array of TPLURec;

  THourSalesRec = Record
    Hour      : String2;
    Qty       : String6;
    Amount    : String10;
    Sign      : String2;
  end;{TPLURec}
  TaHourSalesRecs = array of THourSalesRec;

  TClerkRec = Record
    ClerkNo : string2;
    SPNo8 : string8;
    SPNo7 : string8;
    SPNo6 : string8;
    SPNo5 : string8;
    SPNo4 : string8;
    SPNo3 : string8;
    SPNo2 : string8;
    SPNo1 : string8;
    SPRate : string4;
    Name : string8;
    EndNo : string6;
    StartNo : string6;
    IDNo : String6;
  end;{TClerkRec}
  TaClerkRec = array of TClerkRec;

  TClerkDataType = Record
    Clerk : string2;
    DataType : string2;
    Qty       : String6;
    Amount    : String10;
    Sign      : String2;
  end;

  TClerkData = Record
    aData : array[1..24] of TClerkDataType; {0.63}
  end;
  TaClerkData = array of TClerkData;

  TCashierSalesLine = Record
    CashierNo : string2;
    DataType : string2;
    Qty       : String6;
    Amount    : String10;
    Sign      : String2;
  end;
  TCashierSales = Record
    aSalesLines : array[1..15] of TCashierSalesLine;
  end;
  TaCashierSales = array[1..10] of TCashierSales;


{CLASSES}
  TMemSalesInfo = Class
    MemSalesRec : TMemSalesRec;
    constructor create;
    constructor CreateFrom(MemSalesInfo : TMemSalesInfo);
  end;{TMemSalesData}

  TBalanceInfo = class
    Balance : Integer;
    constructor CreateFrom(iBalance : integer);
  end;{TBalanceInfo}

  TProductInfo = Class
    ProductRec : TProductRec;
    constructor createFrom(sPLUNumber : string6; sCode : string32; sName : string16;
    sDept : string4; sGroup : string6; sHighAmt, sFlag3, sFlag2, sFlag1 : string2;
    sPrice : string8);
  end;{TProductInfo}

{  TProductsInfo = Class
    Products : TList;
    constructor Create;
    destructor Destroy; override;
  end;}

  TGroupInfo = Class
    GroupRec : TGroupRec;
    constructor CreateFrom(sTitleNumber : string2; sName : string12; sGroupNo : string6);
  end;{with}

  TDeptInfo = Class
    DeptRec : TDeptRec;
    constructor CreateFrom(sNumber : string4; sName : string16; sGroupNo, sHighAmt, sFlag3, sFlag2
    , sFlag1 : string2; sPrice : string8);
  end;{with}

  TCardInfo = Class
    CardRec : TCardRec;
    constructor CreateFrom(sTrackNo : String6; sName : String12; sCardNo : String6);
  end;{TCardInfo}

{  TCardsInfo = Class
    Cards : TList;
    constructor Create;
    destructor Destroy; override;
  end;{TCardsInfo}

  TTXWordInfo = Class
    Word : string8;
    constructor CreateFrom(sWord : string8);
  end;{TTXWordInfo}

  TTransInfo = Class
    TransRec : TTransRec;
    constructor CreateFrom({TranTypeNo : String; }pQty : String6; pAmount : String10; pSign : String2);
  end;{TTXWordInfo}

  TMaxInfo = Class
    MaxRec : TMaximumsRec;
  end;{TMaxInfo}

  TPLUSalesInfo = Class
    aPLURecs : TaPLURecs;
    constructor create;
  end;

  TPLUInfo = Class
    PLURec : TPLURec;
    constructor CreateFrom(sPLU : String6; sQty : String6; sAmount : String10; sSign : String2);
  end;

  THourSalesInfo = Class
    HourSalesRec : THourSalesRec;
    constructor CreateFrom(sHour : String2; sQty : String6; sAmount : String10; sSign : String2);
  end;

  TAllHourSalesInfo = Class
    aHourSalesRecs : TaHourSalesRecs;
    constructor create;
  end;

  TAllClerkRec = Class
    aClerkRec : TaClerkRec;
  end;

  TAllClerkData = Class
    aClerks : TaClerkData;
  end;

  TClerkInfo = Class
    ClerkData : TClerkDataType;
    constructor CreateFrom(sClerk : string2; sDataType : string2; sQty : String6; sAmount : String10; sSign : String2);
  end;

  TAllCashierSales = Class
    aCashierSales : TaCashierSales;
  end;

  TCashierSalesInfo = Class
    CashierSalesLine :  TCashierSalesLine;
    constructor CreateFrom(sCashierNo : string2; sDataType : string2; sQty : String6; sAmount : String10; sSign : String2);
  end;

  TAllTransInfo = class
    aTransRec : TaTransInfo;
  end;{TAllTransInfo}

  TPollTillThread = class(TThread)
  private
    FComPort : TApdComPort;
    FDataPacket : TApdDataPacket;
    FTimeout : TTimer;
    FlCommands : TList;
    FOnCommsFail, FOnReceiveData : TCommsEvent;
    FsPrevReceive, FsLogFile, FsCommand : string;
    FbAssumeMUXSwitchesOK, FbDetailedLogging, Fb4MBTills, FbBusy, FbNAK, FbOKToFreeMe, FbVerifySends, FbTimeOut, FbReceived : boolean;
    FslResponse : TStringList;
    FiMuxPause, FiCurrentTillNo, FiNoOfTills, FiDefaultRetries : integer;
    FcMultiID1, FcMultiID2 : char;
    procedure ExecuteCommand(var Command : TCommand);
    function SendCommand(Command: String; bSend : boolean): boolean;
    procedure DataPacketStringPacket(Sender: TObject; Data: String);
    procedure ComPortTriggerAvail(CP: TObject; Count: Word);
    procedure TimeoutTimer(Sender: TObject);
    procedure SRTXWordInfo(var Command : TCommand; bSend : boolean);
    procedure SRProductInfo(var Command : TCommand; bSend : boolean);
    procedure SRGroupInfo(var Command : TCommand; bSend : boolean);
    procedure SRCardInfo(var Command : TCommand; bSend : boolean);
{    procedure GetAllProductsInfo(var Command : TCommand);
    procedure GetAllCardsInfo(var Command : TCommand);}
    procedure SRMemberInfo(var Command : TCommand; bSend : boolean);
    procedure SRTransInfo(var Command : TCommand; bSend : boolean);
    procedure RAllTransInfo(var Command : TCommand);
    procedure SRPLUSalesInfo(var Command : TCommand; bSend : boolean);
    procedure RAllPLUSalesInfo(var Command : TCommand);
    procedure SRHourSalesInfo(var Command : TCommand; bSend : boolean);
    procedure RAllHourlySales(var Command : TCommand);
    procedure SRDeptInfo(var Command : TCommand; bSend : boolean);
    procedure SRMaxInfo(var Command : TCommand; bSend : boolean);
    procedure RAllClerkRec(var Command : TCommand);
    procedure RAllClerkData(var Command : TCommand);
    procedure RAllCashierSales(var Command : TCommand);
    procedure SRCashierSalesInfo(var Command : TCommand; bSend : boolean);
    procedure ClearSalesData(var Command : TCommand);
    function RemoveControlCodes(data : string): string;
    function SwitchMulti(iTillNo : integer; bDontCheck : boolean = FALSE) : boolean;
  protected
    procedure Execute; override;
  public
    bDoingCommand, bCancel : boolean;
    iTimeouts : integer;
    constructor Create(ComPort : TApdComPort; DataPacket : TApdDataPacket;
    Timeout : TTimer; lCommands : TList; OnReceiveData, OnCommsFail : TCommsEvent;
    iDefaultRetries : integer; bVerifySends : boolean; sLogFile : string;
    iNoOfTills : integer; cMultiID1, cMultiID2 : char; b4MBTills : boolean; CommsSignal : TEvent
    ; sWinCardVersion, sPathOfEXE : string; bDetailedLogging : boolean; iMuxPause : integer
    ; bAssumeMUXSwitchesOK : boolean);
    function GetCommandDesc(CommandType : TCommandType): string;
  end;

  TMPComms = class(TComponent)
  private
    ComPort: TApdComPort;
    DataPacket: TApdDataPacket;
    Timeout : TTimer;
    FsLogFile, FsComPort, FsDataPacket, FsTimer : string;
    FiMuxPause, FiNoOfTills, FiRetries, FiCommsTimeout, FiComPortNo, FiBaudRate : integer;
    FOnCommsFail, FOnReceiveData : TCommsEvent;
    FbAssumeMUXSwitchesOK, FbLogBigErrors, FbDetailedLogging, Fb4MBTills, FbVerifySends, FbEnabled: Boolean;
    FcMultiID1, FcMultiID2 : char;
    sWinCardVersion : string;
    sPathOfEXE : string;
    iBigBadErrors : integer;
    procedure ChangeEnabled(Value: Boolean);
  protected
    { Protected declarations }
  public
    CommsSignal : TEvent;
    PollTillThread : TPollTillThread;
    lCommands : TList;
    procedure SetThreadPriority(ThreadPriority : TThreadPriority);
    procedure CancelAllTransfers;
    procedure CancelTransfersType(RemoveCommandType : TCommandType);
    procedure SetProperties(iBaudRate, iCommsTimeout, iComPortNo, iDefaultRetries, iNoOfTills : integer;
    bVerifySends : boolean; sLogFile : string; cMultiID1, cMultiID2 : char; b4MBTills : boolean
    ; sWinCardVer, sPathEXE : string; bDetailedLogging : boolean; iMuxPause : integer; bLogBigErrors, bAssumeMUXSwitchesOK : boolean);
    procedure ShowCommsDebug;
    procedure ShowCommandList;
    procedure QCommand(ctCommandType : TCommandType; iTillNo, iNumber, iRetries : integer; DataToSend : TObject);
    function DoCommand(ctCommandType : TCommandType; iTill, iNumber, iRetries : integer; DataToSend : TObject): boolean;
    function GetCommandDesc(CommandType : TCommandType): string;
    Procedure ResetBigBadErrorCount;
  published
    Property CommsTimeout : integer read FiCommsTimeout write FiCommsTimeout;
    Property ComPortNo : integer read FiComPortNo write FiComPortNo;
    Property Timer : string read FsTimer write FsTimer;
    Property BaudRate : integer read FiBaudRate write FiBaudRate;
    Property ApdComPort : string read FsComPort write FsComPort;
    Property ApdDataPacket : string read FsDataPacket write FsDataPacket;
    property OnReceiveData: TCommsEvent read FOnReceiveData write FOnReceiveData;
    property OnCommsFail: TCommsEvent read FOnCommsFail write FOnCommsFail;
    Property DefaultRetries : integer read FiRetries write FiRetries;
    property Enabled: Boolean read FbEnabled write ChangeEnabled default False;
    Property VerifySends : boolean read FbVerifySends write FbVerifySends;
    Property LogFile : string read FsLogFile write FsLogFile;
    Property NoOfTills : integer read FiNoOfTills write FiNoOfTills;
    Property MultiID1 : char read FcMultiID1 write FcMultiID1;
    Property MultiID2 : char read FcMultiID2 write FcMultiID2;
    Property FourMBTills : boolean read Fb4MBTills write Fb4MBTills;
    Property LogBigErrors : boolean read FbLogBigErrors write FbLogBigErrors;
  end;

  procedure LogFileLine(sLogLine, FsLogFile : string);
  function DecodeCodes(sReceived : string): string;
  function CalcSign(sSign : string2): shortint;
  function CalcSignBytes(iValue : integer): string2;
  function TillStrToInt(sValue, sSign : String): integer;
  function TillStrToReal(sValue, sSign : String): real;
  function RealToTillStr(rReal : real; iLength : integer) : string;
  function IntToTillStr(iValue, iLength : integer) : string;
{  function ArchiveCommslog(sFilename : string) : boolean;}

var
  lpCriticalSection : TRTLCriticalSection;

const
  NegVal = 4;
  ALLTILLS = 0;
  NO_OF_TOTALISERS = 200;

procedure Register;

implementation
uses
  MathUtil, CommsInt, FileCtrl{, VarConst};

const
  NUL = #0;
  STX = ^B; {#2 / ASC:2}
  ETX = ^C; {#3 / ASC:3}
  ACK = ^F; {#6 / ASC:6}
  LF = ^J;  {#$A / ASC:10}
  CR = ^M;  {#$D / ASC:13}
  DC1 = ^Q; {#$11 / ASC:17}
  NAK = ^U; {#$15 / ASC :21}
  DEL = #127; {#$7F}


{TCommand}
constructor TCommand.Create(newCommandType : TCommandType; iTillNo : integer; newNumber
, NoTries : integer; DataToSend : TObject);
begin
  inherited create;
  CommandType := newCommandType;
  TillNo := iTillNo;
  Number := newNumber;
  Tries := NoTries;
  TryNo := 1;
  Success := FALSE;
  Done := FALSE;
  Read := FALSE;
  Append := FALSE;
  Executing := FALSE;
  Blank := FALSE;
  Data := DataToSend;
end;

destructor TCommand.Destroy;
begin
  if Data <> nil then Data.Free;
  inherited;
end;

{TTXWordInfo}
constructor TTXWordInfo.CreateFrom(sWord : string8);
begin
  inherited create;
  Word := sWord;
end;


{TProductInfo}
constructor TProductInfo.CreateFrom(sPLUNumber : string6; sCode : string32; sName : string16;
sDept : string4; sGroup : string6; sHighAmt, sFlag3, sFlag2, sFlag1 : string2;
sPrice : string8);
begin
  inherited create;
  with ProductRec do begin
    PLUNumber  := sPLUNumber;
    Code       := sCode;
    SearchCode := '00';
    Name       := sName;
    Dept       := sDept;
    Group      := sGroup;
    HighAmt    := sHighAmt;
    Flag3      := sFlag3;
    Flag2      := sFlag2;
    Flag1      := sFlag1;
    Price      := sPrice;
  end;{with}
end;


{TDeptInfo}
constructor TDeptInfo.CreateFrom(sNumber : string4; sName : string16; sGroupNo, sHighAmt, sFlag3, sFlag2
, sFlag1 : string2; sPrice : string8);
begin
  inherited create;
  with DeptRec do begin
    Number  := sNumber;
    Name       := sName;
    GroupNo      := sGroupNo;
    HighAmt    := sHighAmt;
    Flag3      := sFlag3;
    Flag2      := sFlag2;
    Flag1      := sFlag1;
    Price      := sPrice;
  end;{with}
end;


{TProductsInfo}

{constructor TProductsInfo.Create;
begin
  inherited create;
  Products := TList.Create;
end;

destructor TProductsInfo.Destroy;
var
  iProd : integer;
begin
  for iProd := 0 to (Products.Count - 1) do TProductInfo(Products[iProd]).Free;
  Products.Free;
  inherited destroy;
end;}


{TGroupInfo}
constructor TGroupInfo.CreateFrom(sTitleNumber : string2; sName : string12; sGroupNo : string6);
begin
  inherited Create;
  with GroupRec do begin
    TitleNumber := sTitleNumber;
    Name := sName;
    GroupNo := sGroupNo;
  end;{with}
end;{with}


{TCardInfo}
constructor TCardInfo.CreateFrom(sTrackNo : String6; sName : String12; sCardNo : String6);
begin
  inherited create;
  with CardRec do begin
    TrackNo := sTrackNo;
    Name := sName;
    CardNo := sCardNo;
    SearchCode := '00';
  end;{with}
end;


{TCardsInfo}

{constructor TCardsInfo.Create;
begin
  inherited create;
  Cards := TList.Create;
end;

destructor TCardsInfo.Destroy;
var
  iCard : integer;
begin
  for iCard := 0 to (Cards.Count - 1) do TCardInfo(Cards[iCard]).Free;
  Cards.Free;
  inherited destroy;
end;}


{TMemSalesInfo}
constructor TMemSalesInfo.create;
var
  iTax : integer;
begin
  inherited create;
  with MemSalesRec do begin
    iCardNo := 0;
    TrackNo := '000000';
    ClerkNumber := '000000';
    SlipLineCount := '00';
    for iTax := 1 to 4 do begin
      TaxData[iTax].Qty := '000000';
      TaxData[iTax].Value := '0000000000';
      TaxData[iTax].Sign := '00';
    end;{for}
    NewBalance.Covers := '0000';
    NewBalance.IV := '00';
    NewBalance.Value := '0000000000';
    NewBalance.Sign := '00';
    SetLength(Transactions,0);
    setlength(Links,0);
    Deposits := 0.0;
  end;{with}
end;

constructor TMemSalesInfo.CreateFrom(MemSalesInfo : TMemSalesInfo);
var
  iLink, iTX, iTax : integer;
begin
  {creates a copy of an existing object}
  inherited create;
  with MemSalesRec do begin
    iCardNo := MemSalesInfo.MemSalesRec.iCardNo;
    TrackNo := MemSalesInfo.MemSalesRec.TrackNo;
    ClerkNumber := MemSalesInfo.MemSalesRec.ClerkNumber;
    SlipLineCount := MemSalesInfo.MemSalesRec.SlipLineCount;
    for iTax := 1 to 4 do begin
      TaxData[iTax].Qty := MemSalesInfo.MemSalesRec.TaxData[iTax].Qty;
      TaxData[iTax].Value := MemSalesInfo.MemSalesRec.TaxData[iTax].Value;
      TaxData[iTax].Sign := MemSalesInfo.MemSalesRec.TaxData[iTax].Sign;
    end;{for}
    NewBalance.Covers := MemSalesInfo.MemSalesRec.NewBalance.Covers;
    NewBalance.IV := MemSalesInfo.MemSalesRec.NewBalance.IV;
    NewBalance.Value := MemSalesInfo.MemSalesRec.NewBalance.Value;
    NewBalance.Sign := MemSalesInfo.MemSalesRec.NewBalance.Sign;

    SetLength(Transactions,High(MemSalesInfo.MemSalesRec.Transactions) + 1);
    for iTX := 0 to High(MemSalesInfo.MemSalesRec.Transactions) do begin
      Transactions[iTX].Flag := MemSalesInfo.MemSalesRec.Transactions[iTX].Flag;
      Transactions[iTX].Number := MemSalesInfo.MemSalesRec.Transactions[iTX].Number;
      Transactions[iTX].Qty := MemSalesInfo.MemSalesRec.Transactions[iTX].Qty;
      Transactions[iTX].Spare := MemSalesInfo.MemSalesRec.Transactions[iTX].Spare;
      Transactions[iTX].Value := MemSalesInfo.MemSalesRec.Transactions[iTX].Value;
      Transactions[iTX].Sign := MemSalesInfo.MemSalesRec.Transactions[iTX].Sign;

      Transactions[iTX].itType := MemSalesInfo.MemSalesRec.Transactions[iTX].itType;
      Transactions[iTX].itNumber := MemSalesInfo.MemSalesRec.Transactions[iTX].itNumber;
      Transactions[iTX].itQuantity := MemSalesInfo.MemSalesRec.Transactions[iTX].itQuantity;
      Transactions[iTX].itAmount := MemSalesInfo.MemSalesRec.Transactions[iTX].itAmount;
    end;{for}

    setlength(Links,High(MemSalesInfo.MemSalesRec.Links) + 1);
    for iLink := 0 to High(MemSalesInfo.MemSalesRec.Links) do Links[iLink] := MemSalesInfo.MemSalesRec.Links[iLink];
    Deposits := MemSalesInfo.MemSalesRec.Deposits;
  end;{with}
end;

{TBalanceInfo}
constructor TBalanceInfo.CreateFrom(iBalance : Integer);
begin
  inherited create;
  Balance := iBalance
end;

{TTransInfo}
constructor TTransInfo.CreateFrom({TranTypeNo : String;} pQty : String6; pAmount : String10; pSign : String2);
begin
  inherited create;
{  TransRec.TranTypeNo := TranTypeNo;}
  TransRec.pQty := pQty;
  TransRec.pAmount := pAmount;
  TransRec.pSign := pSign;
end;

{TPLUInfo}
constructor TPLUInfo.CreateFrom(sPLU : String6; sQty : String6; sAmount : String10; sSign : String2);
begin
  with PLURec do begin
    PLU := sPLU;
    Qty := sQty;
    Amount := sAmount;
    Sign := sSign;
  end;{with}
end;

{TPLUSalesInfo}
constructor TPLUSalesInfo.Create;
begin
  inherited create;
  setlength(aPLURecs, 0);
end;

{TAllHourSalesInfo}
constructor TAllHourSalesInfo.Create;
begin
  inherited create;
  setlength(aHourSalesRecs,0);
end;

{THourSalesInfo}
constructor THourSalesInfo.CreateFrom(sHour : String2; sQty : String6; sAmount : String10; sSign : String2);
begin
  with HourSalesRec do begin
    Hour := sHour;
    Qty := sQty;
    Amount := sAmount;
    Sign := sSign;
  end;{with}
end;

{TClerkInfo}
constructor TClerkInfo.CreateFrom(sClerk : string2; sDataType : string2; sQty : String6; sAmount : String10; sSign : String2);
begin
  with ClerkData do begin
    Clerk := sClerk;
    DataType := sDataType;
    Qty := sQty;
    Amount := sAmount;
    Sign := sSign;
  end;{with}
end;

{TCashierSalesInfo}
constructor TCashierSalesInfo.CreateFrom(sCashierNo : string2; sDataType : string2; sQty : String6; sAmount : String10; sSign : String2);
begin
  with CashierSalesLine do begin
    CashierNo := sCashierNo;
    DataType := sDataType;
    Qty := sQty;
    Amount := sAmount;
    Sign := sSign;
  end;{with}
end;


{TMPComms}

procedure Register;
begin
  RegisterComponents('Card', [TMPComms]);
end;

procedure TMPComms.SetThreadPriority(ThreadPriority : TThreadPriority);
begin
  PollTillThread.Priority := ThreadPriority;
end;


procedure TMPComms.SetProperties(iBaudRate, iCommsTimeout, iComPortNo, iDefaultRetries
, iNoOfTills : integer; bVerifySends : boolean; sLogFile : string; cMultiID1, cMultiID2 : char
; b4MBTills : boolean; sWinCardVer, sPathEXE : string; bDetailedLogging : boolean; iMuxPause : integer
; bLogBigErrors, bAssumeMUXSwitchesOK : boolean);
begin
  BaudRate := iBaudRate;
  CommsTimeout := iCommsTimeout;
  ComPortNo := iComPortNo;
  DefaultRetries := iDefaultRetries;
  NoOfTills := iNoOfTills;
  VerifySends := bVerifySends;
  LogFile := sLogFile;
  MultiID1 := cMultiID1;
  MultiID2 := cMultiID2;
  FourMBTills := b4MBTills;
  sWinCardVersion := sWinCardVer;
  sPathOfEXE := sPathEXE;
  FbDetailedLogging := bDetailedLogging;
  FiMuxPause := iMuxPause;
  FbLogBigErrors := bLogBigErrors;
  iBigBadErrors := 0;
  FbAssumeMUXSwitchesOK := bAssumeMUXSwitchesOK;
end;

procedure TMPComms.ChangeEnabled(Value: Boolean);
var
  iPos, iCommand : integer;
  bFinished, bException : boolean;
  PreviousCursor : TCursor;

  function ArchiveCommslog(sFilename : string) : boolean;
  var
    SearchRec : TSearchRec;
    bContinue : boolean;
    iNoOfLargeNumberedFiles, iDeleteNo, iResult, iNewFileNo, iFileNo : integer;
    sDeleteFile, sLogDir : string;
    EntZip : TEntZip;
  begin{ArchiveCommslog}
    iNewFileNo := 0;

    {get / create commslog dir}
    sLogDir := sPathOfEXE + 'CommsLog\';
    if DirectoryExists(sLogDir) then
      begin
        iNoOfLargeNumberedFiles := 0;
        bContinue := (FindFirst(sLogDir + '*.ZIP', faAnyFile, SearchRec) = 0);
        while bContinue do begin
          iFileNo := StrToIntDef(copy(SearchRec.Name,1,8),0);
          if iFileNo > iNewFileNo then iNewFileNo := iFileNo;
          if iFileNo > (99999999 - MAX_NO_OF_COMS_LOGFILES) then inc(iNoOfLargeNumberedFiles);

          bContinue := (FindNext(SearchRec) = 0);
        end;{while}
        FindClose(SearchRec);

        if (iNewFileNo = 99999999) and (iNoOfLargeNumberedFiles <= MAX_NO_OF_COMS_LOGFILES) then begin
          iNewFileNo := MAX_NO_OF_COMS_LOGFILES - iNoOfLargeNumberedFiles{ + 1};
        end;{if}
      end
    else CreateDir(sLogDir);

    if FileExists(sFilename) then begin
      EntZip := TEntZip.Create;
      with EntZip do begin
        ZipName := sLogDir + PadString(psLeft, IntToStr(iNewFileNo + 1), '0', 8) + '.zip';

        Files.Add({sEXEDir + }sFilename);

        DOSPaths := TRUE;
        OverwriteExisting := TRUE;
        Recurse := FALSE;
        RemoveDots := TRUE;
        StripDrive := TRUE;
        StripPath := TRUE;

        iResult := Save;
        if iResult <> 0 then ShowMessage(ZipErr(iResult));
        Result := iResult = 0;

        Free;
      end;{with}

      {delete old file}
      iDeleteNo := iNewFileNo - MAX_NO_OF_COMS_LOGFILES + 1;
      if iDeleteNo <= 0 then iDeleteNo := 99999999 + iDeleteNo;
      sDeleteFile := sLogDir + PadString(psLeft, IntToStr(iDeleteNo), '0', 8) + '.zip';
      if FileExists(sDeleteFile) then DeleteFile(sDeleteFile);
    end;{if}
  end;{ArchiveCommslog}

begin{ChangeEnabled}
  if Value <> FbEnabled then begin
    FbEnabled := Value;
    if Value then
      begin
        {component enabled}
        InitializeCriticalSection(lpCriticalSection);

        FrmCommandList := nil;

        if ArchiveCommslog(FsLogFile) then DeleteFile(FsLogFile);

        lCommands := TList.create;
        if (PollTillThread = nil) then
          begin
            {link other components to this MPComms component}
            ComPort := TApdComPort(Owner.FindComponent(ApdComPort));
            DataPacket := TApdDataPacket(Owner.FindComponent(ApdDataPacket));
            Timeout := TTimer(Owner.FindComponent(Timer));
            if (ComPort = nil) then ShowMessage(Name + ' : ' + 'ApdComPort Property Incorrect')
            else
              if (DataPacket = nil) then ShowMessage(Name + ' : ' + 'ApdDataPacket Property Incorrect')
              else
                if (Timeout = nil) then ShowMessage(Name + ' : ' + 'Timer Property Incorrect')
                else begin
                  {setup default properties for linked components}
                  with DataPacket do begin
                    Enabled := FALSE;
                    AutoEnable := TRUE;
                    IncludeStrings := FALSE;
                    StartCond := scString;
                    StartString := STX;
                    endCond := [ecString];
                    EndString := CR;
                    Timeout := 20;
                  end;{with}

                  bException := FALSE;
                  with ComPort do begin
                    Open := FALSE;
                    AutoOpen := FALSE;
                    ComNumber := ComPortNo;
                    Parity := pEven;
                    Baud := BaudRate;
                    DataBits := 7;

                    {check if com port is in use}
                    try
                      Open := TRUE;
                    except
                      on EAlreadyOpen do begin
                        LogFileLine('* Com Port in use', FsLogFile); {log file}
                        bException := TRUE;
                        FbEnabled := FALSE;
                      end;{on}
                    end;{try}

                    {if com port available - start thread}
                    if not bException then begin
                      with Timeout do begin
                        Enabled := FALSE;
                        Interval := CommsTimeout;
                      end;{with}
                      PollTillThread := TPollTillThread.Create(ComPort, DataPacket
                      , Timeout, lCommands, FOnReceiveData, FOnCommsFail, DefaultRetries
                      , VerifySends, FsLogFile, FiNoOfTills, FcMultiID1
                      , FcMultiID2, Fb4MBTills, CommsSignal, sWinCardVersion, sPathOfEXE
                      , FbDetailedLogging, FiMuxPause, FbAssumeMUXSwitchesOK);
                      SetThreadPriority(tpLowest);
                    end;{if}
                  end;{with}
                end;{if}
          end
        else MessageDlg('PollTillThread Already Running',mtError,[mbOK],0)
      end
    else begin
      {disable component}

      {wait until till transfers are all completed}
      PreviousCursor := screen.cursor;
      screen.cursor := crHourGlass;
      FrmMessage := TFrmMessage.Create(self);
      FrmMessage.lMessage.Caption := 'Completing till transfers...';
      bFinished := FALSE;
      while (not bFinished) do begin
        bFinished := TRUE;
        For iPos := 0 to lCommands.Count - 1 do begin
          if not TCommand(lCommands[iPos]).Done then begin
            bFinished := FALSE;
            if not FrmMessage.Showing then FrmMessage.Show;
          end;{if}
        end;{for}
        Application.ProcessMessages;
      end;{while}
      if FrmMessage.Showing then FrmMessage.Close;

      FrmMessage.Release;

      {Clear up}
      Timeout.Enabled := FALSE;
      DataPacket.AutoEnable := FALSE;
      DataPacket.Enabled := FALSE;
      DataPacket.OnStringPacket := nil;
      ComPort.FlushInBuffer;
      ComPort.FlushOutBuffer;
      ComPort.Open := FALSE;
      ComPort.OnTriggerAvail := nil;
      ComPort := nil;
      DataPacket := nil;
      Timeout := nil;

      {kill thread}
      if PollTillThread = nil then MessageDlg('PollTillThread Not Running',mtError,[mbOK],0)
      else begin
        PollTillThread.Terminate;
        while (PollTillThread.FbOKToFreeMe = FALSE) or (PollTillThread.FbBusy = TRUE) do Application.ProcessMessages;
{        PollTillThread.Free;}
        PollTillThread := nil;
      end;{if}

      {empty command list}
      For iCommand := 0 to lCommands.Count - 1 do begin
        if TCommand(lCommands[iCommand]).Data <> nil then TCommand(lCommands[iCommand]).Data.Free;
        TCommand(lCommands[iCommand]).Free;
      end;{for}
      lCommands.Free;
      lCommands := nil;
      screen.cursor := PreviousCursor;

      if FrmMPCommsDebug <> nil then begin
        FrmMPCommsDebug.Close;
        FrmMPCommsDebug.Release;
        FrmMPCommsDebug := nil;
      end;{if}

      if FrmCommandList <> nil then begin
        FrmCommandList.Close;
        FrmCommandList.Release;
        FrmCommandList := nil;
      end;{if}
      DeleteCriticalSection(lpCriticalSection);
    end;
  end;
end;

procedure TMPComms.QCommand(ctCommandType : TCommandType; iTillNo, {iReference, }iNumber, iRetries : integer; DataToSend : TObject);
{call this to add a new command to the Queue}
var
  iFirstTill, iLastTill : integer;
  NewData : TObject;
  Command : TCommand;
begin
  if PollTillThread <> nil then begin

    {work out which tills to send the command to (0 - all tills)}
    if iTillNo = ALLTILLS then
      begin
        iFirstTill := 1;
        iLastTill := FiNoOfTills;
      end
    else begin
      iFirstTill := iTillNo;
      iLastTill := iTillNo;
    end;{if}

    {add commands to the queue}
    for iTillNo := iFirstTill to iLastTill do begin
      {add extra commands to read data, before writing data}
      case ctCommandType of
        cmdSetBalance : begin
          lCommands.Add(TCommand.Create(cmdPreGetMemberInfo, iTillNo, iNumber, iRetries, nil));
          if (FrmCommandList <> nil) and (not FrmCommandList.bUpdating) then FrmCommandList.UpdateList;
        end;
      end;{case}

      if DataToSend = nil then NewData := nil
      else begin
        case ctCommandType of
          cmdWaitForDeptInfo, cmdSetDeptInfo : begin
            NewData := TDeptInfo.Create;
            TDeptInfo(NewData).DeptRec := TDeptInfo(DataToSend).DeptRec;
          end;

          cmdWaitForTransInfo, cmdSetTransInfo : begin
            NewData := TTransInfo.Create;
            TTransInfo(NewData).TransRec := TTransInfo(DataToSend).TransRec;
          end;

          cmdSetGroupInfo, cmdWaitForGroupInfo : begin
            NewData := TGroupInfo.Create;
            TGroupInfo(NewData).GroupRec := TGroupInfo(DataToSend).GroupRec;
          end;

          cmdSetProductInfo, cmdWaitForProductInfo : begin
            NewData := TProductInfo.Create;
            TProductInfo(NewData).ProductRec := TProductInfo(DataToSend).ProductRec;
          end;

          cmdSetCardInfo, cmdGetCardInfo : begin
            NewData := TCardInfo.Create;
            TCardInfo(NewData).CardRec := TCardInfo(DataToSend).CardRec;
          end;

          cmdTillOnLine, cmdGetTillName : begin
            NewData := TTXWordInfo.Create;
            TTXWordInfo(NewData).Word := TTXWordInfo(DataToSend).Word;
          end;

          cmdSetBalance, cmdWaitForMemberInfo, cmdWaitForBalance, cmdBlankMemberInfo
          , cmdGetScreenBalance, cmdSetMemberInfo, cmdGetBestBalance, cmdGetBalance : begin
            NewData := TBalanceInfo.Create;
            TBalanceInfo(NewData).Balance := TBalanceInfo(DataToSend).Balance;
          end;
        end;{case}
      end;{if}

      Command := TCommand.Create(ctCommandType, iTillNo, iNumber, iRetries, NewData);
      lCommands.Add(Command);
      if (FrmCommandList <> nil) and (not FrmCommandList.bUpdating) then FrmCommandList.UpdateList;
    end;{for}
    DataToSend.Free;
  end;{if}
end;

function TMPComms.DoCommand(ctCommandType : TCommandType; iTill, iNumber, iRetries : integer; DataToSend : TObject): boolean;
{call this to actually do a command now !}
var
  iBigTries, iCommand, iCommands, iTillNo, iFirstTill, iLastTill : byte;
  Command, Command1, Command2 : TCommand;
  MemSalesInfo : TMemSalesInfo;
  bDoCommand, bOK : boolean;
  sErrMess : string;

  Procedure AddToTechLog(sLine : string);
  begin
    try
      AddLineToFile(DateToStr(Date) + ' ' + TimeToStr(now) + ' ' + sLine, 'CARDLOG.DAT');
    except
      on E:Exception do showmessage('TechSuppLog (' + sLine + ') : ' + E.ClassName + ' - ' + E.Message);
    end;
  end;{AddToTechLog}

begin
  iBigTries := 1;
  bOK := FALSE;
  PollTillThread.iTimeouts := 0;
  Repeat
    if iBigTries > 1 then begin
      LogFileLine(' ', FsLogFile);
      LogFileLine('-+*> DO BIG RETRY ' + IntToStr(iBigTries - 1) + ' <*+-', FsLogFile);
    end;{if}

    {work out which tills to send the command to (0 - all tills)}
    while PollTillThread.FbBusy do Application.ProcessMessages;
    PollTillThread.bDoingCommand := TRUE;
    if iTill = ALLTILLS then
      begin
        iFirstTill := 1;
        iLastTill := FiNoOfTills;
      end
    else begin
      iFirstTill := iTill;
      iLastTill := iTill;
    end;{if}

    for iTillNo := iFirstTill to iLastTill do begin
      Command1 := TCommand.Create(ctCommandType, iTillNo, iNumber, iRetries, DataToSend);
      Command1.Blank := ctCommandType in [cmdBlankMemberInfo];

      {Get Data for writing routine}
      case ctCommandType of
        cmdSetBalance : begin
          Command2 := Command1;
          Command1 := TCommand.Create(cmdPreGetMemberInfo, iTillNo, iNumber, FiRetries, nil);
          iCommands := 2;
        end;
      else iCommands := 1;
      end;{case}

      For iCommand := 1 to iCommands do begin

        {select command to do}
        Case iCommand  of
          1 : begin
            Command := Command1;
            bDoCommand := TRUE;
          end;

          2 : begin
            bDoCommand := Command1.Success;
            Command := Command2;
          end;
        end;{Case}

        if bDoCommand then begin
          with Command do begin
            case CommandType of
              {send previously read data to writing routine}
              cmdSetBalance : begin
  {              if Command1.Data <> nil then begin}
                  MemSalesInfo := TMemSalesInfo.CreateFrom(TMemSalesInfo(Command1.Data));
                  if (DataToSend <> nil) then begin
                    MemSalesInfo.MemSalesRec.NewBalance.Sign := CalcSignBytes(TBalanceInfo(DataToSend).Balance);
                    MemSalesInfo.MemSalesRec.NewBalance.Value := PadString(psLeft,IntToStr(ABS(TBalanceInfo(DataToSend).Balance)),'0',10);
                  end;{if}
                  Data := MemSalesInfo;
  {              end;{if}
              end;

              cmdBlankMemberInfo, cmdSetMemberInfo : Data := DataToSend;
            end;{case}

            if Tries = -1 then Tries := FiRetries - 1; {set default retries}
            while (TryNo <= (Tries + 1)) and (not Done) do begin
              PollTillThread.ExecuteCommand(Command);
              if Success then
                begin
                  bOK := TRUE;
                  if not Append then begin
                    {if there are no subsequent records to get}
                    Done := TRUE;
                    if Assigned(FOnReceiveData) then FOnReceiveData(Command); {trigger event}
                  end;{if}
                end
              else begin
                {try again}
                TryNo := TryNo + 1;
                if TryNo > (Tries + 1) then begin
                  Done := TRUE;
                  {log file}
                  LogFileLine(' ', FsLogFile);
                  LogFileLine('    -+*> DO COMMAND FAILED <*+-', FsLogFile);
                  LogFileLine('    Command Type : ' + GetCommandDesc(CommandType), FsLogFile);
                  LogFileLine('    Till No. : ' + IntToStr(TillNo) , FsLogFile);
                  LogFileLine('    Number : ' + IntToStr(Number) , FsLogFile);
                  if Assigned(FOnCommsFail) then FOnCommsFail(Command); {trigger event}
                  if (CommandType = cmdCancelling) or (Tries = 0) then bOK := TRUE;
                end;{if}
              end;{if}
            end;{while}
          end;{with}
        end;{if}
      end;{for}

      if (iBigTries > 10) and (not bOK) then begin
        LogFileLine('    -+*> DO COMMAND FAILURE : ' + GetCommandDesc(Command1.CommandType)
        + '<*+-', FsLogFile);

        sErrMess := 'Command "' + GetCommandDesc(Command1.CommandType) + '" has failed over 10 times.';
        if FbLogBigErrors then
          begin
            AddToTechLog(sErrMess);
            inc(iBigBadErrors);
            if iBigBadErrors > 10 then MsgBox('There have been some serious errors when communicating with your tills.' + CHR(13)
            + 'Please reset all tills, then click on OK to continue.',mtError, [mbOK], mbOK, 'Comms Error')
            else SleepEx(60000,FALSE); {12/9/00 : delay added to hopefully stop timeout errors}
          end
        else begin
          MsgBox(sErrMess, mtError,[mbOK],mbOK,'Communication Retry Error');
        end;{if}

        bOK := TRUE;
      end;{if}

      Command := nil; {Command1.Destroy; {sleuth}
      if iCommands = 2 then Command2.Destroy;
    end;{for}
    PollTillThread.bDoingCommand := FALSE;
    inc(iBigTries);
  Until bOK;

{  if DataToSend <> nil then DataToSend.Free;} {sleuth}
  Result := bOK;
end;

procedure TMPComms.ShowCommsDebug;
begin
  {Shows comms terminal window for debugging}
  if FrmMPCommsDebug = nil then begin
    FrmMPCommsDebug := TFrmMPCommsDebug.Create(self);
    FrmMPCommsDebug.Debug.ComPort := TApdComPort(Owner.FindComponent(ApdComPort));
    FrmMPCommsDebug.Debug.Active := TRUE;
    FrmMPCommsDebug.Show;
  end;{if}
end;

procedure TMPComms.ShowCommandList;
begin
  {Shows the current command list for debugging}
  if FrmCommandList = nil then begin
    FrmCommandList := TFrmCommandList.Create(self);
    FrmCommandList.Show;
  end;{if}
end;

procedure TMPComms.CancelAllTransfers;
begin
  {aborts current transfer, and sets all transfers waiting in the queue, to 'done'}
  if not PollTillThread.bCancel then begin
    LogFileLine('* Cancel All Transfers Called', FsLogFile);
    if PollTillThread <> nil then begin
      screen.cursor := crHourGlass;
      PollTillThread.bCancel := TRUE;
      while PollTillThread.bCancel = TRUE do Application.ProcessMessages;
      screen.cursor := crDefault;
    end;{if}
  end;{if}
end;

procedure TMPComms.CancelTransfersType(RemoveCommandType : TCommandType);
var
  iCmd : integer;
  Command : TCommand;
begin
  {sets all transfers of ref X, waiting in the queue, to 'done'}
  if (PollTillThread <> nil) and (not PollTillThread.bCancel) then begin
    LogFileLine('* Cancel Transfers Type : ' + GetCommandDesc(RemoveCommandType), FsLogFile);
    if PollTillThread <> nil then begin

      For iCmd := 0 to lCommands.Count - 1 do begin
        Command := TCommand(lCommands[iCmd]);
        if Command.CommandType = RemoveCommandType then begin
          if Command.Executing then Command.CommandType := cmdCancelling
          else begin
            TCommand(lCommands[iCmd]).Done := TRUE;
            TCommand(lCommands[iCmd]).Success := FALSE;
          end;{if}
        end;{if}
      end;{for}
    end;{if}
  end;{if}
end;

function TMPComms.GetCommandDesc(CommandType : TCommandType): string;
begin
  Result := PollTillThread.GetCommandDesc(CommandType);
end;

Procedure TMPComms.ResetBigBadErrorCount;
begin
  iBigBadErrors := 0;
end;




{TPollTillThread}

constructor TPollTillThread.Create(ComPort : TApdComPort; DataPacket : TApdDataPacket
; Timeout : TTimer; lCommands : TList; OnReceiveData, OnCommsFail: TCommsEvent
; iDefaultRetries : integer; bVerifySends : boolean; sLogFile : string
; iNoOfTills : integer; cMultiID1, cMultiID2 : char; b4MBTills : boolean; CommsSignal : TEvent
; sWinCardVersion, sPathOfEXE : string; bDetailedLogging : boolean; iMuxPause : integer
; bAssumeMUXSwitchesOK : boolean);
begin
  inherited create(TRUE);
  FComPort := ComPort;
  FDataPacket := DataPacket;
  FTimeout := Timeout;
  FlCommands := lCommands;
  FOnReceiveData := OnReceiveData;
  FOnCommsFail := OnCommsFail;
  FiDefaultRetries := iDefaultRetries;
  FbVerifySends := bVerifySends;
  FsLogFile := sLogFile;
  FsPrevReceive := 'X';
  FiNoOfTills := iNoOfTills;
  FiCurrentTillNo := 1;
{  ComPort.OnTriggerAvail := ComPortTriggerAvail;}
  DataPacket.OnStringPacket := DataPacketStringPacket;
  FTimeout.OnTimer := TimeoutTimer;
  FbTimeOut := TRUE;
  bCancel := FALSE;
  FslResponse := TStringList.Create;
  FcMultiID1 := cMultiID1;
  FcMultiID2 := cMultiID2;
  Fb4MBTills := b4MBTills;
  FbDetailedLogging := bDetailedLogging;
  FiMuxPause := iMuxPause;
  FbAssumeMUXSwitchesOK := bAssumeMUXSwitchesOK;

  LogFileLine('Windows Card System (Version ' + sWinCardVersion + ') Communications log file ', FsLogFile); {log file}
  LogFileLine('Date Started : ' + DateToStr(Date), FsLogFile);
  LogFileLine('Time Started : ' + TimeToStr(Time), FsLogFile);
  LogFileLine(' ', FsLogFile); {log file}

  SwitchMulti(1);
  Resume;
end;

procedure TPollTillThread.Execute;
var
  Command : TCommand;
  iCmd, iBigTries, iCommand : integer;
  MemSalesInfo : TMemSalesInfo;
  bOK, bSendCancelCommand : boolean;
begin
  Priority := tpLowest;
  bDoingCommand := FALSE;
  FbOKToFreeMe := FALSE;
  while (not Terminated) do begin
    if (FlCommands.Count > 0) then begin
      iCommand := 0;
      {loop around command list}
      repeat
        while bDoingCommand do Application.ProcessMessages;
        Command := TCommand(FlCommands[iCommand]);
        if Command.Tries = -1 then Command.Tries := FiDefaultRetries; {set default retries}

        {if the command is to be done}
        if (not Command.Done) and (Command.TryNo <= (Command.Tries + 1)) then
          begin
            iBigTries := 1;
            bOK := FALSE;
            Repeat
              if iBigTries > 1 then begin
                LogFileLine(' ', FsLogFile);
                LogFileLine('-+*> Q BIG RETRY ' + IntToStr(iBigTries - 1) + ' <*+-', FsLogFile);
              end;{if}

              {send previously read data to writing routine}
              case Command.CommandType of
                cmdSetBalance : begin
                  if TCommand(FlCommands[iCommand - 1]).Success then begin
                    MemSalesInfo := TMemSalesInfo.CreateFrom(TMemSalesInfo(TCommand(FlCommands[iCommand - 1]).Data));
                    if (Command.Data <> nil) then begin
                      MemSalesInfo.MemSalesRec.NewBalance.Sign := CalcSignBytes(TBalanceInfo(Command.Data).Balance);
                      MemSalesInfo.MemSalesRec.NewBalance.Value := PadString(psLeft,IntToStr(ABS(TBalanceInfo(Command.Data).Balance)),'0',10);
  {                    Command.Data.Free;}
                    end;{if}
                    Command.Data := MemSalesInfo;
                  end;{if}
                end;
              end;{case}

              ExecuteCommand(Command);

              if Command.Success then
                begin
                  if not Command.Append then begin
                    bOK := TRUE;
                    {if there are no subsequent records to get}
                    Command.Done := TRUE;
                    if Assigned(FOnReceiveData) then FOnReceiveData(Command); {trigger event}
                    inc(iCommand);
                    if (FrmCommandList <> nil) and (not FrmCommandList.bUpdating) then FrmCommandList.UpdateList;
                  end;{if}
                end
              else begin
                {try again}
                Command.TryNo := Command.TryNo + 1;
                if Command.TryNo > (Command.Tries + 1) then begin
                  Command.Done := TRUE;
                  {log file}
                  LogFileLine(' ', FsLogFile);
                  LogFileLine('    -+*> Q COMMAND FAILED <*+-', FsLogFile);
                  LogFileLine('    Command Type : ' + GetCommandDesc(Command.CommandType), FsLogFile);
                  LogFileLine('    Till No. : ' + IntToStr(Command.TillNo) , FsLogFile);
                  LogFileLine('    Number : ' + IntToStr(Command.Number) , FsLogFile);
                  if Assigned(FOnCommsFail) then FOnCommsFail(Command); {trigger event}
                  if (FrmCommandList <> nil) and (not FrmCommandList.bUpdating) then FrmCommandList.UpdateList;
                  if (Command.CommandType = cmdCancelling) or (Command.Tries = 0) then bOK := TRUE;
                end;{if}
              end;{if}
              inc(iBigTries);
            Until bOK or (iBigTries > 3);

            if not bOK then begin
              LogFileLine(' ', FsLogFile);
              LogFileLine('-+*> Q BIG FAIL <*+-', FsLogFile);
            end;{if}
          end
        else begin
          inc(iCommand);
        end;{if}

        if bCancel then begin
          bSendCancelCommand := FALSE;
          {flag all commands as 'done'}
          For iCmd := 0 to FlCommands.Count - 1 do begin
            if not TCommand(FlCommands[iCmd]).Done then begin
              bSendCancelCommand := TRUE;
              TCommand(FlCommands[iCmd]).Done := TRUE;
              TCommand(FlCommands[iCmd]).Success := FALSE;
            end;{if}
          end;{for}

          {send quit command}
          if bSendCancelCommand then begin
            LogFileLine('Command Sent : [STX][CR][LF]', FsLogFile);
            FComPort.Output := STX + CR + LF;
            iCommand := FlCommands.Count;
          end;{if}
        end;
      until (iCommand = FlCommands.Count) or Terminated;
    end;{if}
    if bCancel then begin
      bCancel := FALSE; {reset cancel flag}
      if (FrmCommandList <> nil) and (not FrmCommandList.bUpdating) then FrmCommandList.UpdateList;
    end;{if}
    Application.ProcessMessages;
  end;{while}

  {clear up}
  FslResponse.Clear;
  FslResponse.Free;
  FbOKToFreeMe := TRUE;
end;

procedure TPollTillThread.ExecuteCommand(var Command : TCommand);
begin
  if (Command.TillNo > FiNoOfTills) or (Command.TillNo < 0)
  then MessageDlg('Invalid Till Number',mtError,[mbOK],0)
  else begin
    Command.Executing := TRUE;

    FComPort.OnTriggerAvail := ComPortTriggerAvail;

    if Command.TillNo <> FiCurrentTillNo then SwitchMulti(Command.TillNo, Command.CommandType = cmdGetTillName); // Switch MUX

    {Execute appropriate command}
    case Command.CommandType of
      cmdWaitForGroupInfo : SRGroupInfo(Command, FALSE);
      cmdSetGroupInfo : SRGroupInfo(Command, TRUE);
      cmdWaitForProductInfo : SRProductInfo(Command, FALSE);
      cmdSetProductInfo : SRProductInfo(Command, TRUE);
      cmdGetCardInfo : SRCardInfo(Command, FALSE);
      cmdSetCardInfo : SRCardInfo(Command, TRUE);
      cmdTillOnLine, cmdGetTillName : SRTXWordInfo(Command, FALSE);
      cmdWaitForMemberInfo, cmdWaitForBalance, cmdPreGetMemberInfo, cmdGetScreenBalance
      ,cmdGetBestBalance, cmdGetBalance : SRMemberInfo(Command, FALSE);
      cmdSetBalance, cmdBlankMemberInfo, cmdSetMemberInfo : SRMemberInfo(Command, TRUE);
      cmdWaitForTransInfo : SRTransInfo(Command, FALSE);
      cmdSetTransInfo : SRTransInfo(Command, TRUE);
      cmdWaitForDeptInfo : SRDeptInfo(Command, FALSE);
      cmdGetMaximums : SRMaxInfo(Command, FALSE);
      cmdGetAllPLUSales : RAllPLUSalesInfo(Command);
      cmdGetAllHourlySales : RAllHourlySales(Command);
      cmdGetAllClerkInfo : RAllClerkRec(Command);
      cmdGetAllClerkData : RAllClerkData(Command);
      cmdClearSalesData : ClearSalesData(Command);
      cmdGetAllTransInfo : RAllTransInfo(Command);
      cmdGetAllCashierSales : RAllCashierSales(Command);
    end;{case}
    FComPort.OnTriggerAvail := nil;
    Command.Executing := FALSE;
  end;{if}
end;

procedure TPollTillThread.ClearSalesData(var Command : TCommand);
var
  TempCommand : TCommand;
  iCashier, iLine : integer;
  BlankTransInfo : TTransInfo;
  BlankPLUInfo : TPLUInfo;
  BlankHourSalesInfo : THourSalesInfo;
  BlankCashierSales : TCashierSalesInfo;
begin
  if Command.Data = nil then
    // Thermal Tills - Special Clear command
    begin
      if SendCommand(Char(Command.Number) + DEL + '101488', TRUE) then
        begin
          if SendCommand(Char(Command.Number) + DEL + '101488', TRUE) then Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    // Dot Matrix Tills - Have to clear out line by line
    case Char(Command.Number) of
      {Clear Transaction Data}
      ']' : begin
        Command.Success := TRUE;
        BlankTransInfo := TTransInfo.CreateFrom('000000','0000000000','00');
        for iLine := 1 to high(TAllTransInfo(Command.Data).aTransRec) do begin
          if (not ZeroFloat(TAllTransInfo(Command.Data).aTransRec[iLine].Qty))
          or (not ZeroFloat(TAllTransInfo(Command.Data).aTransRec[iLine].Amount))then begin
            {Blank this one}
            TempCommand := TCommand.Create(cmdSetTransInfo,Command.TillNo,iLine,0,BlankTransInfo);
            SRTransInfo(TempCommand, TRUE);
            TempCommand.Free;
          end;{if}
        end;{for}
        BlankTransInfo.Free;
      end;

      {Clear PLU Data}
      'V' : begin
        Command.Success := TRUE;
        BlankPLUInfo := TPLUInfo.CreateFrom('000000', '000000', '0000000000', '00');
        for iLine := 0 to high(TPLUSalesInfo(Command.Data).aPLURecs) do begin
          if (TPLUSalesInfo(Command.Data).aPLURecs[iLine].Qty <> '000000')
          or (TPLUSalesInfo(Command.Data).aPLURecs[iLine].Amount <> '0000000000') then begin
            {Blank this one}
            TempCommand := TCommand.Create(cmdGetPLUSales,Command.TillNo
            ,StrToIntDef(TPLUSalesInfo(Command.Data).aPLURecs[iLine].PLU,0),0,BlankPLUInfo);
            SRPLUSalesInfo(TempCommand, TRUE);
            TempCommand.Free;
          end;{if}
        end;{for}
        BlankPLUInfo.Free;
      end;

      {Clear Hourly Data}
      '\' : begin
        Command.Success := TRUE;
        BlankHourSalesInfo := THourSalesInfo.CreateFrom('00', '000000', '0000000000', '00');
        for iLine := 0 to high(TAllHourSalesInfo(Command.Data).aHourSalesRecs) do begin
          if (TAllHourSalesInfo(Command.Data).aHourSalesRecs[iLine].Qty <> '000000')
          or (TAllHourSalesInfo(Command.Data).aHourSalesRecs[iLine].Amount <> '0000000000') then begin
            {Blank this one}
            TempCommand := TCommand.Create(cmdGetPLUSales,Command.TillNo
            ,StrToIntDef(TAllHourSalesInfo(Command.Data).aHourSalesRecs[iLine].Hour,0),0,BlankHourSalesInfo);
            SRHourSalesInfo(TempCommand, TRUE);
            TempCommand.Free;
          end;{if}
        end;{for}
        BlankHourSalesInfo.Free;
      end;

      {Clear Cashier Data}
      'X' : begin
        Command.Success := TRUE;
        BlankCashierSales := TCashierSalesInfo.CreateFrom('00', '00', '000000', '0000000000', '00');
        for iCashier := 1 to 10 do begin
          for iLine := 1 to 15 do begin
            BlankCashierSales.CashierSalesLine := TAllCashierSales(Command.Data).aCashierSales[iCashier].aSalesLines[iLine];
            with BlankCashierSales.CashierSalesLine do begin
              if not ((CashierNo = '') and (DataType = '')) then begin
                Qty := '000000';
                Amount := '0000000000';
                Sign := '00';

                TempCommand := TCommand.Create(cmdGetPLUSales,Command.TillNo,0,0,BlankCashierSales);
                SRCashierSalesInfo(TempCommand, TRUE);
                TempCommand.Free;
              end;{if}
            end;{with}
          end;{for}
        end;{for}
        BlankCashierSales.Free;
      end;
    end;{case}
  end;{if}
end;

procedure TPollTillThread.RAllClerkRec(var Command : TCommand);
var
  AllClerkRec : TAllClerkRec;
  iPos : integer;
  iClerkNo : byte;
begin
  if SendCommand('4' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      AllClerkRec := TAllClerkRec.Create;
      setlength(AllClerkRec.aClerkRec,0);
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 96) then begin
          iClerkNo := StrToIntDef(copy(FslResponse[iPos],1,2),0);
          setlength(AllClerkRec.aClerkRec,iClerkNo + 1);
          with AllClerkRec.aClerkRec[iClerkNo] do begin
            ClerkNo := copy(FslResponse[iPos],1,2);
            SPNo8 := copy(FslResponse[iPos],3,8);
            SPNo7 := copy(FslResponse[iPos],11,8);
            SPNo6 := copy(FslResponse[iPos],19,8);
            SPNo5 := copy(FslResponse[iPos],27,8);
            SPNo4 := copy(FslResponse[iPos],35,8);
            SPNo3 := copy(FslResponse[iPos],43,8);
            SPNo2 := copy(FslResponse[iPos],51,8);
            SPNo1 := copy(FslResponse[iPos],59,8);
            SPRate := copy(FslResponse[iPos],67,4);
            Name := copy(FslResponse[iPos],71,8);
            EndNo := copy(FslResponse[iPos],79,6);
            StartNo := copy(FslResponse[iPos],85,6);
            IDNo := copy(FslResponse[iPos],91,6);
          end;{with}
        end;{if}
      end;{for}
      Command.Data := AllClerkRec;
    end
  else Command.Success := FALSE;
end;

procedure TPollTillThread.RAllCashierSales(var Command : TCommand);
var
  AllCashierSales : TAllCashierSales;
  iPos : integer;
  iType, iCashierNo : byte;
begin
  if SendCommand('X' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      AllCashierSales := TAllCashierSales.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 22) then begin
          iCashierNo := StrToIntDef(copy(FslResponse[iPos],1,2),0);
          iType := StrToIntDef(copy(FslResponse[iPos],3,2),0);
          with AllCashierSales.aCashierSales[iCashierNo].aSalesLines[iType] do begin
            CashierNo := copy(FslResponse[iPos],1,2);
            DataType := copy(FslResponse[iPos],3,2);
            Qty := copy(FslResponse[iPos],5,6);
            Amount := copy(FslResponse[iPos],11,10);
            Sign := copy(FslResponse[iPos],21,2);
          end;{with}
        end;{if}
      end;{for}
      Command.Data := AllCashierSales;
    end
  else Command.Success := FALSE;
end;

procedure TPollTillThread.RAllClerkData(var Command : TCommand);
var
  AllClerkData : TAllClerkData;
  iPos : integer;
  iDataType, iClerkNo : byte;
begin
  if SendCommand('Y' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      AllClerkData := TAllClerkData.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 22) then begin
          iClerkNo := StrToIntDef(copy(FslResponse[iPos],1,2),0);
          setlength(AllClerkData.aClerks,iClerkNo + 1);
          iDataType := StrToIntDef(copy(FslResponse[iPos],3,2),0);
          if (iDataType >= 1) and (iDataType <= 24) then {.063}
            begin
              with AllClerkData.aClerks[iClerkNo].aData[iDataType] do begin
                Clerk := copy(FslResponse[iPos],1,2);
                DataType := copy(FslResponse[iPos],3,2);
                Qty := copy(FslResponse[iPos],5,6);
                Amount := copy(FslResponse[iPos],11,10);
                Sign := copy(FslResponse[iPos],21,2);
              end;{with}
            end
          else LogFileLine('* Corrupt Clerk Data Encountered : ' + FslResponse[iPos], FsLogFile); {.044}
        end;{if}
      end;{for}
      Command.Data := AllClerkData;
    end
  else Command.Success := FALSE;
end;

procedure TPollTillThread.SRCardInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Card Info}
var
  sResponse : string;
  CardInfo : TCardInfo;
begin
  if bSend then
    {Send Info}
    begin
      CardInfo := TCardInfo(Command.Data);
      if SendCommand('2' + PadString(psLeft,IntToStr(Command.Number),'0',6)
      + CardInfo.CardRec.Name + CardInfo.CardRec.CardNo + CardInfo.CardRec.SearchCode, bSend) then
        begin
          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand('2' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', FALSE)
              and (FslResponse.Count > 0) and (copy(FslResponse[0],1,18) = CardInfo.CardRec.Name + CardInfo.CardRec.CardNo)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    {Get Info}
    if SendCommand('2' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', bSend)
    and (FslResponse.Count > 0) and (length(FslResponse[0]) = 20) then
      begin
        Command.Success := TRUE;
        sResponse := copy(FsCommand,2,6) + FslResponse[0];
        CardInfo := TCardInfo.CreateFrom('000000','','000000');
        with CardInfo.CardRec do begin
          TrackNo := copy(sResponse,1,6);
          Name := copy(sResponse,7,12);
          CardNo  := copy(sResponse,19,6);
          SearchCode := copy(sResponse,25,2);
        end;{with}
        Command.Data := CardInfo;
      end
    else Command.Success := FALSE;
  end;{if}
end;

(*
procedure TPollTillThread.GetAllCardsInfo(var Command : TCommand);
var
  CardInfo : TCardInfo;
  CardsInfo : TCardsInfo;
  iPos : integer;
begin
  if SendCommand('2' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      CardsInfo := TCardsInfo.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 26) and (copy(FslResponse[iPos],7,12) <> '            ')then begin
          CardInfo := TCardInfo.create('000000', '','000000');
          with CardInfo do begin
            TrackNo := copy(FslResponse[iPos],1,6);
            Name := copy(FslResponse[iPos],7,12);
            CardNo  := copy(FslResponse[iPos],19,6);
            SearchCode := copy(FslResponse[iPos],25,2);
          end;{with}
          CardsInfo.Cards.Add(CardInfo);
        end;{if}
      end;{for}
      Command.Data := CardsInfo;
    end
  else Command.Success := FALSE;
end;
*)

procedure TPollTillThread.SRProductInfo(var Command : TCommand; bSend : boolean);
{send / Receive product info}
var
  sResponse : string;
  ProductInfo : TProductInfo;
begin
  if bSend then
    {send data}
    begin
      ProductInfo := TProductInfo(Command.Data);
      with ProductInfo.ProductRec do begin
        if SendCommand('1' + PadString(psLeft,IntToStr(Command.Number),'0',6)
        + Code + SearchCode + Name + Dept + Group + HighAmt + Flag3 + Flag2
        + Flag1 + Price, bSend) then
          begin
            {verify data sent}
            if FbVerifySends then
              begin
                if SendCommand('1' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', FALSE)
                and (FslResponse.Count > 0)
                and (copy(FslResponse[0],1,32) = Code)
                and (copy(FslResponse[0],35,42) = Name + Dept + Group
                + HighAmt + Flag3 + Flag2 + Flag1 + Price)
                then Command.Success := TRUE
                else Command.Success := FALSE
              end
            else Command.Success := TRUE;
          end
        else Command.Success := FALSE;
      end;{with}
    end
  else begin
    {read data}
    if SendCommand('1' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', bSend)
    and (FslResponse.Count > 0) and (length(FslResponse[0]) = 76) then
      begin
        Command.Success := TRUE;
        sResponse := copy(FsCommand,2,6) + FslResponse[0];
        ProductInfo := TProductInfo.CreateFrom('000000', '00000000000000000000000000000000', '', '0000', '000000', '00', '00', '00', '00', '00000000');
        with ProductInfo.ProductRec do begin
          PLUNumber := copy(sResponse,1,6);
          Code := copy(sResponse,7,32);
          SearchCode := copy(sResponse,39,2);
          Name := copy(sResponse,41,16);
          Dept := copy(sResponse,57,4);
          Group := copy(sResponse,61,6);
          HighAmt := copy(sResponse,67,2);
          Flag3 := copy(sResponse,69,2);
          Flag2 := copy(sResponse,71,2);
          Flag1 := copy(sResponse,73,2);
          Price := copy(sResponse,75,8);
        end;{with}
        Command.Data := ProductInfo; ProductInfo := nil; {Sleuth}
      end
    else Command.Success := FALSE;
  end;{if}
end;

procedure TPollTillThread.SRGroupInfo(var Command : TCommand; bSend : boolean);
{Send / Receive group info}
var
  sResponse : string;
  GroupInfo : TGroupInfo;
begin
  if bSend then
    {send}
    begin
      GroupInfo := TGroupInfo(Command.Data);
      with GroupInfo.GroupRec do begin
        if SendCommand('c' + PadString(psLeft,IntToStr(Command.Number),'0',2)
        + Name + '00' + GroupNo, bSend) then
          begin
            {verify data sent}
            if FbVerifySends then
              begin
                if SendCommand('c' + PadString(psLeft,IntToStr(Command.Number),'0',2) + '?', FALSE)
                and (FslResponse.Count > 0)
                and (copy(FslResponse[0],1,12) = Name)
                and (copy(FslResponse[0],15,6) = GroupNo)
                then Command.Success := TRUE
                else Command.Success := FALSE
              end
            else Command.Success := TRUE;
          end
        else Command.Success := FALSE;
      end;{with}
    end
  else begin
    {read}
    if SendCommand('c' + PadString(psLeft,IntToStr(Command.Number),'0',2) + '?', bSend)
    and (FslResponse.Count > 0) and (length(FslResponse[0]) = 20) then
      begin
        Command.Success := TRUE;
        sResponse := copy(FsCommand,2,2) + FslResponse[0];
        GroupInfo := TGroupInfo.CreateFrom('00', '', '000000');
        with GroupInfo.GroupRec do begin
          TitleNumber := copy(sResponse,1,2);
          Name := copy(sResponse,3,12);
          {InvalidData := copy(sResponse,15,2);}
          GroupNo := copy(sResponse,17,6);
        end;{with}
        Command.Data := GroupInfo;
      end
    else Command.Success := FALSE;
  end;{if}
end;

procedure TPollTillThread.SRDeptInfo(var Command : TCommand; bSend : boolean);
{send / Receive department info}
var
  sResponse : string;
  DeptInfo : TDeptInfo;
begin
  if bSend then
    {send data}
    begin
      DeptInfo := TDeptInfo(Command.Data);
      with DeptInfo.DeptRec do begin
(*        if SendCommand('0' + PadString(psLeft,IntToStr(Command.Number),'0',6)
        + Code + SearchCode + Name + Dept + Group + HighAmt + Flag3 + Flag2
        + Flag1 + Price, bSend) then
          begin
            {verify data sent}
            if FbVerifySends then
              begin
                if SendCommand('1' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', FALSE)
                and (FslResponse.Count > 0)
                and (copy(FslResponse[0],1,32) = Code)
                and (copy(FslResponse[0],35,42) = Name + Dept + Group
                + HighAmt + Flag3 + Flag2 + Flag1 + Price)
                then Command.Success := TRUE
                else Command.Success := FALSE
              end
            else Command.Success := TRUE;
          end
        else Command.Success := FALSE;*)
      end;{with}
    end
  else begin
    {read data}
    if SendCommand('0' + PadString(psLeft,IntToStr(Command.Number),'0',4) + '?', bSend)
    and (FslResponse.Count > 0) and (length(FslResponse[0]) = 34) then
      begin
        Command.Success := TRUE;
        sResponse := copy(FsCommand,2,4) + FslResponse[0];
        DeptInfo := TDeptInfo.CreateFrom('0000', '0000000000000000', '00', '00', '00', '00', '00', '00000000');
        with DeptInfo.DeptRec do begin
          Number := copy(sResponse,1,4);
          Name := copy(sResponse,5,16);
          GroupNo := copy(sResponse,21,2);
          HighAmt := copy(sResponse,23,2);
          Flag3 := copy(sResponse,25,2);
          Flag2 := copy(sResponse,27,2);
          Flag1 := copy(sResponse,29,2);
          Price := copy(sResponse,31,8);
        end;{with}
        Command.Data := DeptInfo;
      end
    else Command.Success := FALSE;
  end;{if}
end;

(*
procedure TPollTillThread.GetAllProductsInfo(var Command : TCommand);
var
  iPos : integer;
  ProductsInfo : TProductsInfo;
  ProductInfo : TProductInfo;
begin
  if SendCommand('1' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      ProductsInfo := TProductsInfo.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 82)
        and (copy(FslResponse[iPos],41,16) <> '                ')
        then begin
          ProductInfo := TProductInfo.Create('000000', '00000000000000000000000000000000', '', '0000', '000000', '00', '00', '00', '00', '00000000');
          with ProductInfo do begin
            PLUNumber := copy(FslResponse[iPos],1,6);
            Code := copy(FslResponse[iPos],7,32);
            SearchCode := copy(FslResponse[iPos],39,2);
            Name := copy(FslResponse[iPos],41,16);
            Dept := copy(FslResponse[iPos],57,4);
            Group := copy(FslResponse[iPos],61,6);
            HighAmt := copy(FslResponse[iPos],67,2);
            Flag3 := copy(FslResponse[iPos],69,2);
            Flag2 := copy(FslResponse[iPos],71,2);
            Flag1 := copy(FslResponse[iPos],73,2);
            Price := copy(FslResponse[iPos],75,8);
          end;{with}
          ProductsInfo.Products.Add(ProductInfo);
        end;{if}
      end;{for}
      Command.Data := ProductsInfo;
    end
  else Command.Success := FALSE;
end;
*)

procedure TPollTillThread.SRTXWordInfo(var Command : TCommand; bSend : boolean);
{Send / Receive transaction word info (used for till name)}
var
  TXWordInfo : TTXWordInfo;
  sTXWordNo : string4;
  sWord : String8;
begin
  sTXWordNo := PadString(psLeft,IntToStr(Command.Number),'0',4);
  if bSend then
    {send}
    begin
      sWord := PadString(psRight,TTXWordInfo(Command.Data).Word,' ',8);
      if SendCommand('8' + sTXWordNo + sWord, bSend) then
        begin
          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand('8' + sTXWordNo + '?', FALSE)
              and (FslResponse.count > 0) and (FslResponse[0] = sWord)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    {Read}
    if SendCommand('8' + sTXWordNo + '?', bSend)
    and (FslResponse.count > 0) and (length(FslResponse[0]) = 8) then
      begin
        Command.Success := TRUE;
        TXWordInfo := TTXWordInfo.CreateFrom(FslResponse[0]);
        Command.Data := TXWordInfo;
      end
    else Command.Success := FALSE;
  end;{if}
end;

procedure TPollTillThread.SRTransInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Till Totals}
var
  iTTNLen : byte;
  sTXTypeNo : string;
  sResponse : string;
begin
  if Fb4MBTills then iTTNLen := 4
  else iTTNLen := 2;

  sTXTypeNo := PadString(psLeft,IntToStr(Command.Number),'0',iTTNLen);

  if bSend then
    {send}
    begin
      sResponse := TTransInfo(Command.Data).TransRec.pQty + TTransInfo(Command.Data).TransRec.pAmount
      + TTransInfo(Command.Data).TransRec.pSign;
      if SendCommand(']' + sTXTypeNo + sResponse, bSend) then
        begin

//*******************************************************************************
//*******************************************************************************
//Command.Success := FALSE;
//Exit;
//*******************************************************************************
//*******************************************************************************

          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand(']' + sTXTypeNo + '?', FALSE)
              and (FslResponse.count > 0) and (FslResponse[0] = sResponse)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    {Read}
    if SendCommand(']' + sTXTypeNo + '?', bSend)
    and (FslResponse.count > 0) and (length(FslResponse[0]) = 18) then
      begin
        Command.Success := TRUE;
        Command.Data := TTransInfo.CreateFrom(copy(FslResponse[0],1,6), copy(FslResponse[0],7,10),
        {copy(FslResponse[0],17,2)}'00');
      end
    else Command.Success := FALSE;
  end;{if}
end;

procedure TPollTillThread.RAllTransInfo(var Command : TCommand);
{Send / Receive Till Totals}
const
  NO_OF_TRIES = 3;
var
  iTrys, iTTNLen : byte;
  AllTransInfo : TAllTransInfo;
  iArrayPos, iPos : smallint;
begin
  if Fb4MBTills then iTTNLen := 4
  else iTTNLen := 2;

  {Read}
  Command.Success := FALSE; {must always be sucessful as you may get nothing back}
  iTrys := 0;

  Repeat
    inc(iTrys);
    if SendCommand(']' + '?', FALSE) and (FslResponse.count > 0) and (length(FslResponse[0]) = 18 + iTTNLen)
    then begin
      Command.Success := TRUE;
      AllTransInfo := TAllTransInfo.Create;
      with AllTransInfo do begin

        {Blank the array of totalisers}
        setlength(aTransRec, NO_OF_TOTALISERS + 1);
        for iPos := 0 to High(aTransRec) do begin
          aTransRec[iPos].Qty := 0;
          aTransRec[iPos].Amount := 0;
        end;{for}

        {fill the array of totalisers from the till response}
        for iPos := 0 to FslResponse.Count - 1 do begin
          if length(FslResponse[iPos]) = 18 + iTTNLen then begin
            iArrayPos := StrToIntDef(copy(FslResponse[iPos],1,iTTNLen),0);
            with aTransRec[iArrayPos] do begin
              Qty := TillStrToReal(copy(FslResponse[iPos],iTTNLen + 1,6), copy(FslResponse[iPos]
              ,iTTNLen + 17,2));
              Amount := TillStrToReal(copy(FslResponse[iPos],iTTNLen + 7,10), copy(FslResponse[iPos]
              ,iTTNLen + 17,2));
            End;{TTransRec}
          end;{if}
        end;{for}
      end;{with}
      Command.Data := AllTransInfo;
    end;{if}
  Until (Command.Success = TRUE) or (iTrys = NO_OF_TRIES);
  Command.Success := TRUE;
end;

procedure TPollTillThread.SRPLUSalesInfo(var Command : TCommand; bSend : boolean);
{Send / Receive PLU Sales Info}
var
  sResponse : string;
  sNo : string6;
begin
  sNo := PadString(psLeft,IntToStr(Command.Number),'0',6);

  if bSend then
    {send}
    begin
      sResponse := TPLUInfo(Command.Data).PLURec.Qty + TPLUInfo(Command.Data).PLURec.Amount
      + TPLUInfo(Command.Data).PLURec.Sign;
      if SendCommand('V' + sNo + sResponse, bSend) then
        begin
          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand('V' + sNo + '?', FALSE)
              and (FslResponse.count > 0) and (FslResponse[0] = sResponse)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    {Read
    if SendCommand(']' + sNo + '?', bSend)
    and (FslResponse.count > 0) and (length(FslResponse[0]) = 18) then
      begin
        Command.Success := TRUE;
        Command.Data := TTransInfo.CreateFrom(copy(FslResponse[0],1,6), copy(FslResponse[0],7,10)
        , copy(FslResponse[0],17,2));
      end
    else Command.Success := FALSE;}
  end;{if}
end;

procedure TPollTillThread.RAllPLUSalesInfo(var Command : TCommand);
var
  PLUSalesInfo : TPLUSalesInfo;
  iPos : integer;
begin
  if SendCommand('V' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      PLUSalesInfo := TPLUSalesInfo.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 24) then begin
          setlength(PLUSalesInfo.aPluRecs,high(PLUSalesInfo.aPluRecs) + 2);
          with PLUSalesInfo.aPLURecs[high(PLUSalesInfo.aPluRecs)] do begin
            PLU := copy(FslResponse[iPos],1,6);
            Qty := copy(FslResponse[iPos],7,6);
            Amount := copy(FslResponse[iPos],13,10);
            Sign := copy(FslResponse[iPos],23,2);
          end;{with}
        end;{if}
      end;{for}
      Command.Data := PLUSalesInfo;
    end
  else Command.Success := FALSE;
end;

procedure TPollTillThread.SRHourSalesInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Hourly Sales Info}
var
  sResponse : string;
  sNo : string6;
begin
  sNo := PadString(psLeft,IntToStr(Command.Number),'0',2);

  if bSend then
    {send}
    begin
      sResponse := THourSalesInfo(Command.Data).HourSalesRec.Qty
      + THourSalesInfo(Command.Data).HourSalesRec.Amount
      + THourSalesInfo(Command.Data).HourSalesRec.Sign;
      if SendCommand('\' + sNo + sResponse, bSend) then
        begin
          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand('\' + sNo + '?', FALSE)
              and (FslResponse.count > 0) and (FslResponse[0] = sResponse)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;
    end
  else begin
    {Read
    if SendCommand('\' + sNo + '?', bSend)
    and (FslResponse.count > 0) and (length(FslResponse[0]) = 18) then
      begin
        Command.Success := TRUE;
        Command.Data := TTransInfo.CreateFrom(copy(FslResponse[0],1,6), copy(FslResponse[0],7,10)
        , copy(FslResponse[0],17,2));
      end
    else Command.Success := FALSE;}
  end;{if}
end;

procedure TPollTillThread.SRCashierSalesInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Cashier Sales Info}
var
  sResponse : string;
  sNo : string4;
begin
  sNo := TCashierSalesInfo(Command.Data).CashierSalesLine.CashierNo;
  if bSend then
    {send}
    begin
      sResponse := TCashierSalesInfo(Command.Data).CashierSalesLine.DataType
      + TCashierSalesInfo(Command.Data).CashierSalesLine.Qty
      + TCashierSalesInfo(Command.Data).CashierSalesLine.Amount
      + TCashierSalesInfo(Command.Data).CashierSalesLine.Sign;
      if SendCommand('X' + sNo + sResponse, bSend) then
        begin
           Command.Success := TRUE;
{          if FbVerifySends then
            verify data sent
            begin
              if SendCommand('X' + sNo + '?', FALSE)
              and (FslResponse.count > 0) and (FslResponse[0] = sResponse)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;}
        end
      else Command.Success := FALSE;
    end
  else begin
    {Read
    if SendCommand('X' + sNo + '?', bSend)
    and (FslResponse.count > 0) and (length(FslResponse[0]) = 20) then
      begin
        Command.Success := TRUE;
        Command.Data := TTransInfo.CreateFrom(copy(FslResponse[0],1,6), copy(FslResponse[0],7,10)
        , copy(FslResponse[0],17,2));
      end
    else Command.Success := FALSE;}
  end;{if}
end;

procedure TPollTillThread.RAllHourlySales(var Command : TCommand);
var
  AllHourSalesInfo : TAllHourSalesInfo;
  iPos : integer;
begin
  if SendCommand('\' + '?', FALSE) and (FslResponse.Count > 0) then
    begin
      Command.Success := TRUE;
      AllHourSalesInfo := TAllHourSalesInfo.Create;
      For iPos := 0 to (FslResponse.Count - 1) do begin
        if (length(FslResponse[iPos]) = 20) then begin
          setlength(AllHourSalesInfo.aHourSalesRecs,high(AllHourSalesInfo.aHourSalesRecs) + 2);
          with AllHourSalesInfo.aHourSalesRecs[high(AllHourSalesInfo.aHourSalesRecs)] do begin
            Hour := copy(FslResponse[iPos],1,2);
            Qty := copy(FslResponse[iPos],3,6);
            Amount := copy(FslResponse[iPos],9,10);
            Sign := copy(FslResponse[iPos],19,2);
          end;{with}
        end;{if}
      end;{for}
      Command.Data := AllHourSalesInfo;
    end
  else Command.Success := FALSE;
end;

procedure TPollTillThread.SRMemberInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Member sales information}
var
  sBlankTXData, sBalanceData, sResponse : string;
  MemSalesInfo : TMemSalesInfo;
  iLink, {iMinuser, }iLastLine, iTX, iStartLine, previoushigh, iLine, iTax : integer;
begin
  if bSend then
    {send}
    begin
      Command.Success := TRUE;

      {set balance}
      if Command.Data = nil then MemSalesInfo := TMemSalesInfo.Create
      else MemSalesInfo := TMemSalesInfo(Command.Data);


      sBalanceData := '02';
      with MemSalesInfo.MemSalesRec do begin

        if Command.Blank then begin
          {Blank Tax Fields}
          for iTax := 1 to 4 do begin
            TaxData[iTax].Qty := '000000';
            TaxData[iTax].Value := '0000000000';
            TaxData[iTax].Sign := '00';
          end;{for}

          {Blank balance fields}
{          with NewBalance do begin
            Covers := '0000';
            IV := '00';
            Value := '0000000000';
            Sign := '00';
          end;{with}
        end;{if}

        for iTax := 1 to 4 do sBalanceData := sBalanceData + TaxData[iTax].Qty + TaxData[iTax].Value + TaxData[iTax].Sign;

        sBalanceData := sBalanceData + NewBalance.Covers + NewBalance.IV + NewBalance.Value + NewBalance.Sign;

        {set main track balance}
        if not SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6) + sBalanceData, TRUE)
        then Command.Success := FALSE;

        if Command.Success then begin
          {set additional track balances}
          for iLink := 0 to High(Links) do begin
            if not SendCommand('D' + Links[iLink] + sBalanceData, TRUE) then Command.Success := FALSE;
          end;{for}

          if Command.Blank
          and SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '0100000000', TRUE){blank 1st track no. header}
          and SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6) +  '53000000', TRUE){blank 1st track no. link}
          and Command.Success then begin

            {blank clerk data}

            for iLink := 0 to High(Links) do begin
              {blank additional track no. headers}
              if not SendCommand('D' + Links[iLink] + '0100000000', TRUE) then Command.Success := FALSE;

              {blank additional track no. links}
              if not SendCommand('D' + Links[iLink] + '53000000', TRUE) then Command.Success := FALSE;
            end;{for}

            {blank transaction lines}
            sBlankTXData := '00000000000000000000000000';
  {          if High(Links) >= 0 then iLastLine := 49
            else }iLastLine := High(Transactions);

            {remove all transaction lines}
            for iTX := 0 to iLastLine do begin
              if Transactions[iTX].TrackRef <> '' then begin
                {remove transaction line}
                if not SendCommand(Transactions[iTX].TrackRef + Transactions[iTX].PacketNumber
                + sBlankTXData, TRUE) then Command.Success := FALSE;
              end;{if}
            end;{for}

(*            {remove link line
            if iLastLine >= 49 then begin
              if not SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6)
              + '53000000', TRUE) then Command.Success := FALSE;
            end;{if}

  {          iMinuser := 0;}

            {remove all link lines}
            for iLink := 0 to High(Links) do begin
              {remove link line}
              if not SendCommand('D' + Links[iLink] + '53000000', TRUE) then Command.Success := FALSE;

              iMinuser := iMinuser + 50;
              if iLink = High(Links) then iLastLine := High(Transactions) - iMinuser + 3
              else iLastLine := 52;
              for iTX := 3 to iLastLine do begin
                {remove transaction line}
                if not SendCommand('D' + Links[iLink] + PadString(psLeft
                ,IntToStr(iTX),'0',2) + sBlankTXData, TRUE) then Command.Success := FALSE;

                {remove link line}
                if iTX = 52 then begin
                  if not SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6)
                  + '53000000', TRUE) then Command.Success := FALSE;
                end;{if}
              end;{for}
            end;{for}*)
          end;{if}
        end;{if}
      end;{with}
    end
  else begin
    {Read}

    {b000.845
    if SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', bSend)
    and (FslResponse.Count > 1) and (length(FslResponse[0]) = 10) and (length(FslResponse[1]) <> 10) then}

    {b000.846}
    if SendCommand('D' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', bSend)
    and (FslResponse.Count > 1) and (length(FslResponse[0]) = 10)
    and (length(FslResponse[1]) in [1, 28, 92])

    {NF: 12/02/2001 (v5.00.021)  - Added to hopefully fix range check errors}
    and (FslResponse[FslResponse.Count - 1] = 'D')

    then
      begin
{**********************************************************************************************************************}
{**********************************************************************************************************************}
//Command.Success := FALSE;
//Exit;
{**********************************************************************************************************************}
{**********************************************************************************************************************}
        Command.Success := TRUE;
        if Command.Append then MemSalesInfo := TMemSalesInfo(Command.Data) {continuation record}
        else begin
          {only on first record}
          MemSalesInfo := TMemSalesInfo.create;
{            setlength(Transactions,0);}
          sResponse := copy(FsCommand,2,6) + FslResponse[0];
          with MemSalesInfo.MemSalesRec do begin
            TrackNo := copy(sResponse,1,6);
            {PacketNumber := copy(sResponse,7,2);}
            ClerkNumber := copy(sResponse,9,6);
            SlipLineCount := copy(sResponse,15,2);
          end;{with}
        end;{if}

{        if (FslResponse.Count > 1) and
        ((length(FslResponse[1]) = 92) and (not Command.Append))
        or ((length(FslResponse[1]) = 28) and (Command.Append))
        then begin}
        if (FslResponse.Count > 1) and
        ((length(FslResponse[1]) = 92) or (length(FslResponse[1]) = 28)) then begin
          with MemSalesInfo.MemSalesRec do begin
            if Command.Append then
              begin
                previoushigh := high(Transactions) + 1;
                iStartLine := 1;
              end
            else begin
              {store header data}
              sResponse := FslResponse[1];
              {TrackNo : copy(sResponse,1,6);}
              {PacketNumber : copy(sResponse,1,2);}

              with NewBalance do begin
                Covers := copy(sResponse,75,4);
                IV := copy(sResponse,79,2);
                Value := copy(sResponse,81,10);
                Sign := copy(sResponse,91,2);
              end;{with}

              for iTax := 1 to 4 do begin
                sResponse := copy(FslResponse[1],3 + ((iTax - 1) * 18),18);
                TaxData[iTax].Qty := copy(sResponse,1,6);
                TaxData[iTax].Value := copy(sResponse,7,10);
                TaxData[iTax].Sign := copy(sResponse,17,2);
              end;{for}

              previoushigh := 0;
              iStartLine := 2;
            end;{if}

            setlength(Transactions, previoushigh + FslResponse.Count - 3);

            Command.Append := FALSE;
            for iLine := iStartLine to (FslResponse.Count - 1) do begin
              if (copy(FslResponse[iLine],1,2) = '53') and (length(FslResponse[iLine]) = 8) then
                begin
                  if not Fb4MBTills then begin
                    {on non thermal tills we will need to get another record manually}
                    Command.Append := TRUE;
                    Command.TryNo := 1;
                    Command.Number := StrToIntDef(copy(FslResponse[iLine],3,6),0);
                  end;{if}

                  {store link to next track no}
                  setlength(Links, high(Links) + 2);
                  Links[high(Links)] := copy(FslResponse[iLine],3,6);
                end
              else begin
                sResponse := '';
                if (copy(FslResponse[iLine],1,1) = 'D') then
                  begin
                    if (length(FslResponse[iLine]) <> 35) then
                      begin
                        if length(FslResponse[iLine]) <> 1 then begin
                          dec(previoushigh);
                          setlength(Transactions, previoushigh + FslResponse.Count - 3);
                        end;
                      end
                    else begin
                      {Thermal till extra lines that begin with D}
                      sResponse := copy(FslResponse[iLine],8,28);
                      Transactions[previoushigh + iLine - 2].TrackRef := copy(FslResponse[iLine],1,7);
                    end;
                  end
                else begin
                  {append new transaction line}
                  if length(FslResponse[iLine]) = 28 then begin
                    sResponse := FslResponse[iLine];
                    Transactions[previoushigh + iLine - 2].TrackRef := 'D' + PadString(psLeft,IntToStr(Command.Number),'0',6);
                  end;{if}
                end;{if}

                if sResponse <> '' then begin
                  with Transactions[previoushigh + iLine - 2]do begin
                    PacketNumber := copy(sResponse,1,2);
                    Flag := copy(sResponse,3,2);
                    Number := copy(sResponse,5,6);
                    Qty := copy(sResponse,11,6);
                    Spare := copy(sResponse,17,1);
                    Value := copy(sResponse,18,9);
                    Sign := copy(sResponse,27,2);
                  end;{with}
                end;{if}
              end;{if}
            end;{for}
          end;{with}
        end;{if}
        Command.Data := MemSalesInfo;   MemSalesInfo := nil; {SLEUTH}
      end
    else Command.Success := FALSE;
  end;{if}
end;

procedure TPollTillThread.SRMaxInfo(var Command : TCommand; bSend : boolean);
{Send / Receive Card Info}
var
  sResponse : string;
  MaxInfo : TMaxInfo;
begin
  if bSend then
    begin
    {Send Info}
(*    begin
      CardInfo := TCardInfo(Command.Data);
      if SendCommand('2' + PadString(psLeft,IntToStr(Command.Number),'0',6)
      + CardInfo.CardRec.Name + CardInfo.CardRec.CardNo + CardInfo.CardRec.SearchCode, bSend) then
        begin
          if FbVerifySends then
            {verify data sent}
            begin
              if SendCommand('2' + PadString(psLeft,IntToStr(Command.Number),'0',6) + '?', FALSE)
              and (FslResponse.Count > 0) and (copy(FslResponse[0],1,18) = CardInfo.CardRec.Name + CardInfo.CardRec.CardNo)
              then Command.Success := TRUE
              else Command.Success := FALSE
            end
          else Command.Success := TRUE;
        end
      else Command.Success := FALSE;*)
    end
  else begin
    {Get Info}
    if SendCommand('9' + '01' + '?', bSend)
    and (FslResponse.Count > 0) and (length(FslResponse[0]) = 38) then
      begin
        Command.Success := TRUE;
        sResponse := FslResponse[0];
        MaxInfo := TMaxInfo.Create;
        with MaxInfo.MaxRec do begin
          ShiftLevels   := copy(sResponse,1,2);
          InvalidData1  := copy(sResponse,3,2);
          Departments   := copy(sResponse,5,4);
          PLU           := copy(sResponse,9,6);
          InvalidData2  := copy(sResponse,15,4);
          Cashiers      := copy(sResponse,19,2);
          InvalidData3  := copy(sResponse,21,4);
          Clerks        := copy(sResponse,25,2);
          Guests        := copy(sResponse,27,6);
          InvalidData4  := copy(sResponse,33,4);
          Cards         := copy(sResponse,37,2);
        end;{with}
        Command.Data := MaxInfo;
      end
    else Command.Success := FALSE;
  end;{if}
end;

function TPollTillThread.SendCommand(Command: String; bSend : boolean): boolean;
begin
  FbBusy := TRUE;
  bCancel := FALSE;
  FbNAK := FALSE;
  FsPrevReceive := 'X';
  FbReceived := FALSE;
  FbTimeOut := FALSE;
  FslResponse.Clear;
  FsCommand := RemoveAllChars(Command,'?');
  FTimeout.Enabled := TRUE;
  FDataPacket.enabled := TRUE;

  {log file}
  LogFileLine(' ', FsLogFile);
  LogFileLine('-+*> NEW COMMAND <*+-', FsLogFile);
  LogFileLine('Command Sent : [STX]' + Command + '[CR][LF]', FsLogFile);

  {send command}
  FComPort.Output := STX + Command + CR + LF;

  {Wait until all data received - look in ComPortTriggerAvail to see when this is said to be the case}
  while (FbReceived = FALSE) and (bCancel = FALSE) do application.processmessages;
  FbBusy := FALSE;

  {determine success}
  Result := (not FbTimeOut) and (((FslResponse.Count > 0) and (not bSend)) or bSend)
  and (not bCancel) and (not FbNAK);
end;

procedure TPollTillThread.DataPacketStringPacket(Sender: TObject; Data: String);
var
  sLine : string;
begin
  {append received data to the response list}
  sLine := RemoveControlCodes(data);
  FslResponse.add(sLine);
  LogFileLine('Packet Received : ' + sLine, FsLogFile);
end;

procedure TPollTillThread.TimeoutTimer(Sender: TObject);
begin
  {timeout occured}
  inc(iTimeouts);
  LogFileLine('* Timeout Occured', FsLogFile);
  FTimeout.Enabled := FALSE;
  FbTimeOut := TRUE;
  FbReceived := TRUE;
  FslResponse.Clear;
  if iTimeouts >= 30 then begin
    iTimeouts := 0;
    LogFileLine('', FsLogFile);
    LogFileLine('-+*> BIG TIMEOUT <*+-', FsLogFile);
    MsgBox('Communications have timed out.' + CHR(13)
    + 'Please reset all tills, then click on OK to continue.',mtError, [mbOK], mbOK, 'Comms Error');
  end;{if}
end;

procedure TPollTillThread.ComPortTriggerAvail(CP: TObject; Count: Word);
var
  iPos : word;
  sReceived : string;
  procedure ContinueTransfer;
  begin
    FTimeout.Enabled := FALSE;
    FTimeout.Enabled := TRUE;

    FComPort.Output := ACK + DC1;
    if FbDetailedLogging then LogFileLine('Bytes Sent : [ACK][DC1]', FsLogFile);
  end;
begin
  if not bCancel then begin
    sReceived := '';
    for iPos := 1 to Count do sReceived := sReceived + FComPort.GetChar; {build Received string}

    if FbDetailedLogging and (FsLogFile <> '') then LogFileLine('Bytes Received : ' + DecodeCodes(sReceived), FsLogFile);{log file}

    if pos(NAK,sReceived) > 0 then begin
      FbNAK := TRUE;{set flag for NAK received}
      LogFileLine('* NAK Received', FsLogFile);
    end;{if}

    if (sReceived = DC1) or (FbTimeOut) or (FbNAK) or (sReceived[1] = NUL) then
      begin
        if ((sReceived = DC1) and (FsPrevReceive[length(FsPrevReceive)] = DC1) and (FbBusy))
        or (sReceived[1] = NUL) then
          begin
            {end of transfer}

            {send end transaction byte
            LogFileLine('Bytes Sent : [STX]' + FsCommand[1] + '[ETX][CR][LF]', FsLogFile);
            FComPort.Output := STX + FsCommand[1] + ETX + CR + LF;}

            LogFileLine('* EOT', FsLogFile);

            FbReceived := TRUE;
            FTimeout.Enabled := FALSE;
            FDataPacket.enabled := FALSE;
            FComport.FlushOutBuffer;
            FComport.FlushInBuffer;
          end
        else begin
          if FbBusy then begin
            ContinueTransfer;
          end;{if}
        end;{if}
      end
    else ContinueTransfer;
    FsPrevReceive := sReceived;
  end;{if}
end;

function TPollTillThread.RemoveControlCodes(data : string): string;
var
  iCharNo, iPos : integer;
begin
  if length(data) > 0 then begin
    {remove request string}
    iPos := Pos(FsCommand,data);
    if iPos > 0 then delete(data,iPos,length(FsCommand));

    {remove all non characters}
    iPos := 1;
    repeat
      iCharNo := Ord(data[iPos]);
      case iCharNo of
        {Special trap for shitty pound signs}
        28 : begin
          data[iPos] := '£';
          inc(iPos);
        end;

        {All other characters}
        else begin
          if (iCharNo < 32) or (iCharNo > 126) then
            begin
              if not (iCharNo in [3]) then LogFileLine('* Character Stripped : #' + IntToStr(iCharNo), FsLogFile);
              delete(data,iPos,1)
            end
          else inc(iPos);
        end;
      end;{case}
    until iPos > length(data);
    result := data;
  end;{if}
end;

function TPollTillThread.GetCommandDesc(CommandType : TCommandType): string;
begin
  Case CommandType of
    cmdGetTillName : Result := 'GetTillName';
    cmdWaitForProductInfo : Result := 'WaitForProductInfo';
    cmdSetProductInfo : Result := 'SetProductInfo';
    cmdGetCardInfo : Result := 'GetCardInfo';
    cmdSetCardInfo : Result := 'SetCardInfo';
    cmdBlankMemberInfo : Result := 'BlankMemberInfo';
    cmdGetScreenBalance : Result := 'GetScreenBalance';
    cmdGetBestBalance : Result := 'GetBestBalance';
    cmdGetBalance : Result := 'GetBalance';
    cmdSetBalance : Result := 'SetBalance';
    cmdWaitForGroupInfo : Result := 'WaitForGroupInfo';
    cmdSetGroupInfo : Result := 'SetGroupInfo';
    cmdWaitForTransInfo : Result := 'WaitForTransInfo';
    cmdSetTransInfo : Result := 'SetTransInfo';
    cmdWaitForDeptInfo : Result := 'WaitForDeptInfo';
    cmdPreGetMemberInfo : Result := 'PreGetMemberInfo';
    cmdWaitForBalance : Result := 'WaitForBalance';
    cmdWaitForMemberInfo : Result := 'WaitForMemberInfo';
    cmdCancelling : Result := 'Cancelling';
    cmdTillOnLine : Result := 'TillOnLine';
    cmdSetMemberInfo : Result := 'SetMemberInfo';
{    cmdGetAllProductsInfo : Result := 'GetAllProductsInfo';}
{    cmdGetAllCardsInfo : Result := 'GetAllCardsInfo';}
    cmdClearSalesData : Result := 'ClearSalesData';
    cmdGetMaximums : Result := 'GetMaximums';
    cmdGetAllPLUSales : Result := 'GetAllPLUSales';
    cmdGetAllHourlySales : Result := 'GetAllHourlySales';
    cmdGetAllClerkData : Result := 'GetAllClerkData';
    cmdGetAllClerkInfo : Result := 'GetAllClerkInfo';
    cmdGetAllTransInfo : Result := 'cmdGetAllTransInfo';
    cmdGetPLUSales : Result := 'cmdGetPLUSales';
  else Result := 'Command Not Found';
  end;{case}
end;

function TPollTillThread.SwitchMulti(iTillNo : integer; bDontCheck : boolean = FALSE) : boolean;
var
  cMux2No, cTillNo : char;
  sSwitch : string;
  iResult, iTries : integer;
  Command : TCommand;
  bSuccess : boolean;

  procedure SwitchMUX;
  begin
    {log file}
    LogFileLine(' ', FsLogFile);
    LogFileLine('  -+*> CHANGE TILL <*+-', FsLogFile);
    LogFileLine('  Command Sent : ' + sSwitch + '[CR][LF]', FsLogFile);
    LogFileLine(' ', FsLogFile);

    {send string}
    FbBusy := TRUE;
    FComPort.Output := sSwitch + CR + LF;
    FbBusy := FALSE;
    FiCurrentTillNo := iTillNo;
    SleepEx(FiMuxPause,FALSE); {12/9/00 : delay added to stop timeout errors after MUX change}
  end;{SwitchMUX}

begin
  // work out string to send
  cTillNo := IntToStr(iTillNo)[1];
  if iTillNo < 7 then sSwitch := FcMultiID1 + cTillNo + FcMultiID1 + cTillNo + FcMultiID1
  else begin
   if FiNoOfTills = 7 then sSwitch := FcMultiID1 + cTillNo + FcMultiID1 + cTillNo + FcMultiID1
   else begin
     cMux2No := IntToStr(iTillNo - 6)[1];
     sSwitch := FcMultiID1 + '7' + FcMultiID1 + '7' + FcMultiID1
     + FcMultiID2 + cMux2No + FcMultiID2 + cMux2No + FcMultiID2;
     end;{if}
   end;{if}


   Repeat

    iTries := 0;
    Result := FALSE;
    bSuccess := TRUE;

    Repeat
      SwitchMUX; // Try to Switch MUX

      if FbAssumeMUXSwitchesOK or bDontCheck then Result := TRUE
      else begin
        // Check to see if Mux Has Switched
        Command := TCommand.Create(cmdGetTillName, iTillNo, 59, FiDefaultRetries, nil);
        SRTXWordInfo(Command, FALSE);
        if Command.Success then
          begin
            if TTXWordInfo(Command.Data).Word = 'NRGT' + IntToStr(iTillNo) + '   ' then Result := TRUE;
          end
        else bSuccess := FALSE; // Didn't get anything (till probably not connected)

        Command.Free;
        inc(iTries);
      end;{if}

    until (Result = TRUE) or (iTries > 3) or (bSuccess = FALSE);

    if Result = TRUE then iResult := mrOK
    else begin
      if bSuccess = FALSE then iResult := mrCancel
      else begin
        iResult := MsgBox('Your multiplexor does not appear to be switching correctly.'#13#13
        + 'Do you wish to retry this operation ?',mtWarning,[mbRetry,mbCancel]
        ,mbRetry,'Multiplexor Error');
      end;{if}
    end;

  Until iResult in [mrCancel, mrOK];

end;

procedure LogFileLine(sLogLine, FsLogFile : string);
begin
  EnterCriticalSection(lpCriticalSection);
  try
    AddLineToFile(sLogLine, FsLogFile);{log file}
  except
    on E:Exception do {showmessage('Neil''s IO Error : ' + E.ClassName + ' / ' + E.Message)};
  end;
  LeaveCriticalSection(lpCriticalSection);
end;

function DecodeCodes(sReceived : string): string;
{Turns control codes into [DC1] type thing}
var
  sAdd, sResult : string;
  iPos, iASCIIValue : integer;
begin
  sResult := '';
  For iPos := 1 to length(sReceived) do begin
    iASCIIValue := Ord(sReceived[iPos]);
    if (iASCIIValue < 32) or (iASCIIValue > 126) then
      begin
        case iASCIIValue of
          0 : sAdd := '[NUL]';
          2 : sAdd := '[STX]';
          3 : sAdd := '[ETX]';
          6 : sAdd := '[ACK]';
          10 : sAdd := '[LF]';
          13 : sAdd := '[CR]';
          17 : sAdd := '[DC1]';
          21 : sAdd := '[NAK]';
        else sAdd := '[' + IntToStr(iASCIIValue) + ']';
        end;{case}
      end
    else sAdd := sReceived[iPos];
    sResult := sResult + sAdd;
  end;{for}
  Result := sResult;
end;

function CalcSign(sSign : string2): shortint;
{NF : Magic Procedure - Don't ask me how it works !}
var
  iAscSign : integer;
begin
  if (Ord(sSign[1]) >= 48) then iAscSign := Ord(sSign[1]) - 48
  else iAscSign := 0;

  if ((iAscSign and NegVal) = NegVal) then Result := -1
  else Result := 1;
end;

function CalcSignBytes(iValue : integer): string2;
begin
  if iValue < 0 then Result := '41'
{  else Result := '01';}
  else Result := '01'; {NF : CHANGED 05/23/00 !!.803}
end;

function TillStrToInt(sValue, sSign : String): integer;
begin
  if sValue = '' then sValue := '00';
  if sSign = '' then sSign := '00';
  Result := StrToIntDef(sValue,0) * CalcSign(sSign);
end;

function TillStrToReal(sValue, sSign : String): real;
begin
  if sValue = '' then sValue := '00';
  if sSign = '' then sSign := '00';
  Result := StrToIntDef(sValue,0) * CalcSign(sSign) / 100;
end;

function RealToTillStr(rReal : real; iLength : integer) : string;
begin
  Result:= PadString(psLeft,IntToStr(Round(ABS(rReal) * 100)),'0',iLength);
end;

function IntToTillStr(iValue, iLength : integer) : string;
begin
  Result:= PadString(psLeft,IntToStr(iValue),'0',iLength);
end;

{initialization

  if (Ord(sSign[1]) >= 48) then iAscSign := Ord(sSign[1]) - 48
  else iAscSign := 0;

  if ((iAscSign and NegVal) = NegVal) then ShowMessage('-1')
  else ShowMessage('1');}

end.
