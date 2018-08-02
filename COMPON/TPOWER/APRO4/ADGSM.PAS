{*********************************************************}
{*                    ADGSM.PAS 4.03                     *}
{*        Copyright (c) TurboPower Software 2002         *}
{*                 All rights reserved.                  *}
{*********************************************************}

{Global defines potentially affecting this unit}
{$I AWDEFINE.INC}

unit adgsm;
interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  OoMisc, AdPort, AdPacket, AdExcept;

{$IFDEF AproBCB}
{*$HPPEMIT '' }
{*$HPPEMIT '#undef GetMessage' }
{*$HPPEMIT '#undef SendMessage' }
{*$HPPEMIT '' }
{$ENDIF}

const
  ApdGSMResponse = WM_USER + 100;

type
  TGSMStates = (gsNone, gsConfig, gsSendAll, gsListAll, gsSend, gsSendFStore,
                gsWrite, gsDelete, gsNofify);

  TApdSMSStatus = (srUnread, srRead, ssUnsent, ssSent, ssAll, ssUnknown);{!!.01}

  TApdCustomGSMPhone = class;

  TApdGSMNextMessageEvent = procedure (Pager : TApdCustomGSMPhone;
                          ErrorCode : Integer; var NextMessageReady : Boolean)
                          of object;
  TApdGSMNewMessageEvent = procedure (Pager : TApdCustomGSMPhone;
                         FIndex : Integer; Message : string) of object;
  TApdGSMMessageListEvent = procedure (Sender : TObject) of object;
  TApdGSMCompleteEvent = procedure (Pager : TApdCustomGSMPhone;
                                    State : TGSMStates;
                                    ErrorCode : Integer) of object;

  TApdSMSMessage = class(TObject)
  private
    FMessageIndex: Integer;
    FAddress: string;
    FMessage: string;
    FName: string;
    FStatus: TApdSMSStatus;
    FTimeStampStr: string;
    FTimeStamp: TDateTime;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }

    property Address : string
      read FAddress write FAddress;
    property Message : string
      read FMessage write FMessage;
    property MessageIndex : Integer
      read FMessageIndex write FMessageIndex;
    property Name : string
      read FName write FName;
    property Status : TApdSMSStatus
      read FStatus write FStatus;
    property TimeStamp : TDateTime
      read FTimeStamp write FTimeStamp;
    property TimeStampStr : string
      read FTimeStampStr write FTimeStampStr;
  end;

  TApdMessageStore = class(TStringList)
  private
    { private declarations }
    FCapacity : Integer;
    FGSMPhone : TApdCustomGSMPhone;
    {$IFDEF AproBCB}
    function GetSMSMessage(Index: Integer): TApdSMSMessage;
    {$ELSE}
    function GetMessage(Index: Integer): TApdSMSMessage;
    {$ENDIF}
    procedure SetMessage(Index: Integer; const Value : TApdSMSMessage);
    procedure SetMSCapacity(const Value: Integer);
  protected
    { protected declarations }
    JustClearStore : Boolean;
    function GetCapacity : Integer; override;
    procedure ClearStore;
  public
    { public declarations }
    constructor Create(GSMPhone : TApdCustomGSMPhone);
    function AddMessage(const Dest, Msg : string) : Integer;
    procedure Clear; override;
    procedure Delete(PhoneIndex: Integer); override;
    {$IFDEF AproBCB}
    property Messages[Index: Integer]: TApdSMSMessage
             read GetSMSMessage write SetMessage; default;
    {$ELSE}      
    property Messages[Index: Integer]: TApdSMSMessage
             read GetMessage write SetMessage; default;
    {$ENDIF}
    property Capacity : Integer read FCapacity write SetMSCapacity;
  end;

  TApdCustomGSMPhone = class(TApdBaseComponent)
  private
    { Private declarations }

    FOnNewMessage : TApdGSMNewMessageEvent;
    FOnNextMessage : TApdGSMNextMessageEvent;
    FOnMessageList : TApdGSMMessageListEvent;
    FOnGSMComplete: TApdGSMCompleteEvent;

    FComPort: TApdCustomComPort;
    FConnected : Boolean;                // Flag for connection status
    FErrorCode: Integer;
    FGSMState: TGSMStates;
    FHandle: THandle;
    FMessage : string;                   // Defines Message to be sent
    FMessageStore: TApdMessageStore;
    FNotifyOnNewMessage: Boolean;

    // True won't sychronize message store
    FQuickConnect: Boolean;
    // True won't give list of messages when first connected
    FConfigList: Boolean;                                                {!!.02}

    FSMSAddress: string;                 // Phone number
    FSMSCenter: string;                  // Service Center
    FTempWriteMess: string;              // Temp store when WriteToMemory

    ResponsePacket : TApdDataPacket;
    ErrorPacket : TApdDataPacket;
    NotifyPacket : TApdDataPacket;                                       {!!.02}
    TempSMSMessage : TApdSMSMessage;

    procedure SetMessage(const Value: string);
    procedure SetCenter(const Value: string);
    procedure SetNotifyOnNewMessage(const Value: Boolean);

  protected
    { Protected declarations }
    CmdIndex : Integer;
    ResponseStr : string;
    NotifyStr : string;                                                  {!!.02}
    procedure CheckPort;
    procedure WndProc(var Message: TMessage);
    procedure Notification(AComponent : TComponent;
                           Operation: TOperation); override;
    procedure ResponseStringPacket(Sender: TObject; Data : string);
    procedure NotifyStringPacket(Sender: TObject; Data : string);        {!!.02}
    procedure ErrorStringPacket(Sender: TObject; Data : string);
    procedure DoFail(const Msg: string; const ErrCode: Integer);

    { these methods manage the phone's message store }
    procedure DeleteFromMemoryIndex(PhoneIndex : Integer);
    property Handle : THandle read FHandle;
    procedure SetState(NewState : TGSMStates);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    {$IFDEF AproBCB}
    procedure SendSMSMessage;
    {$ELSE}
    procedure SendMessage;
    {$ENDIF}
    procedure SendAllMessages;
    procedure ListAllMessages;
    procedure Connect;
    procedure SendFromMemory(TheIndex : Integer);
    procedure WriteToMemory(const Dest, Msg: string);
    procedure ProcessResponse;
    procedure Synchronize;

    function StatusToStr(StatusString : TApdSMSStatus) : string;

    property ComPort : TApdCustomComPort
      read FComPort write FComPort;
    property SMSAddress : string
      read FSMSAddress write FSMSAddress;
    property SMSMessage : string
      read FMessage write SetMessage;
    property SMSCenter : string
      read FSMSCenter write SetCenter;
    property NotifyOnNewMessage : Boolean
             read FNotifyOnNewMessage
             write SetNotifyOnNewMessage default False;                  {!!.02}
    property MessageStore : TApdMessageStore
      read FMessageStore write FMessageStore;
    property QuickConnect : Boolean
      read FQuickConnect write FQuickConnect default False;
    { read only properties }
    property SMSErrorCode : Integer
      read FErrorCode;
    property GSMState : TGSMStates
      read FGSMState;
    property OnNewMessage : TApdGSMNewMessageEvent
             read FOnNewMessage write FOnNewMessage;
    property OnNextMessage : TApdGSMNextMessageEvent
             read FOnNextMessage write FOnNextMessage;
    property OnMessageList : TApdGSMMessageListEvent
             read FOnMessageList write FOnMessageList;
    property OnGSMComplete : TApdGSMCompleteEvent
      read FOnGSMComplete write FOnGSMComplete;

  end;

  TApdGSMPhone = class(TApdCustomGSMPhone)

  published
    property ComPort;
    property QuickConnect;
    property SMSAddress;
    property SMSMessage;
    property SMSCenter;
    property NotifyOnNewMessage;

    {published events}
    property OnNewMessage;
    property OnNextMessage;
    property OnMessageList;
    property OnGSMComplete;
    
  end;

implementation
{$IFDEF TRIALRUN}
  {$I TRIAL07.INC}
  {$I TRIAL03.INC}
  {$I TRIAL01.INC}
{$ENDIF}


const
  { +CMS ERROR:  =  Message Service Failure Result Code }
  GSMConfigAvail : array[0..6] of string =
              ('E0',
              '+CSMS=0',           // Select Message Service
               '+CPMS=?',           // Preferred Message Storage
               '+CMGF=1',           // Text Mode
               '+CSCS?',            // Set Character Set
               '+CSDH=1',           // Show Text Code Parameters
               '+CSMP?');           // Get Default values for SMS-SUBMIT
  GSMConfigResponse : array[0..6] of string =
              ('OK',
              '+CSMS: ',           // Response StartString expected
               '+CPMS: ',           // Response StartString expected
               'OK',                // No Response Expected, just OK
               '+CSCS: ',           // Show default character set like "PCCP437"
               'OK',                // No Response Expected, just OK
               '+CSMP: ');          // Response StartString expected

  GSMSendMessageCommands : array[0..6] of string =
    { leaving the first command commented out, will use this for querying later } 
               (//'+CNMI?',           // Default query for new message indication
                '+CNMI= 2,1,0,1,0',    // New message indication =2,1,0,1,0 or = 2,,2,,0
                '+CSCB?',           // Types of CBMs to be received by the ME
                '+CSMP=32,167,0,0', // status report wanted; otherwise default
                '+CMGF=1',          // Force Text Mode
                '+CSCA=',           // Service Center if FSMSCenter not empty
                '+CMGS=',           // Send Destination address
                '');                // Sending message text

  GSMSendMessageResponse : array[0..6] of string =
               (//'+CNMI: ',          // Response StartString expected
                'OK',
                '+CSCB: ',          // Response StartString expected
                'OK',               // No Response Expected, just OK
                'OK',               // No Response Expected, just OK
                'OK',               // No Response Expected, just OK
                #13#10,             // Response from phone to Send Message
                '+CMGS: ');         // Response StartString expected

  GSMListAllMessagesCommands : array[0..0] of string =
               ('+CMGL');           // List Messages on Phone
  GSMListAllMessagesResponse : array[0..0] of string =
               ('+CMGL: ');         // Response StartString expected

  GSMSendMessFromStorage : array[0..0] of string =
               ('+CMSS=');          // Send Message from Storage
  GSMSendMessFromStorageResp : array[0..0] of string =
               (#13#10'OK');        // Response StartString expected

  GSMWriteToMemoryCommands : array[0..1] of string =
               ('+CMGW=',           // Write Message to Memory
                '');                // Writing message text
  GSMWriteToMemoryResponse : array[0..1] of string =
               (#13#10,             // Response StartString expected
                '+CMGW: ');
  GSMDeleteAMessageCommand : array[0..0] of string =
               ('+CMGD=');            // Delete Message from Memory
  GSMDeleteAMessageResponse : array[0..0] of string =
               (#13#10'OK');               // No Response Expected, just OK

{ TApdCustomGSMPhone }

{ opens the port, issues configuration commands }
{Generates the OnMessageList (+CMGL) event when complete if not QuickConnect}
procedure TApdCustomGSMPhone.Connect;
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    CheckPort;
  end;
  if FNotifyOnNewMessage then begin                                      {!!.02}
    NotifyPacket.Enabled := True;                                        {!!.02}
    NotifyPacket.AutoEnable := True;                                     {!!.02}
  end;                                                                   {!!.02}
  FConfigList := True;                                                   {!!.02}
  CmdIndex := 0;
  ResponsePacket.StartString := GSMConfigResponse[CmdIndex];
  ResponsePacket.EndString := #13;
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  SetState(gsConfig);
  FComPort.Output := 'AT' + GSMConfigAvail[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (FGSMState = gsListAll) or (Res = wm_Quit)
        or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(ecSMSTimedOut,-8101);
    Exit;
  end;
end;

constructor TApdCustomGSMPhone.Create(AOwner: TComponent);
{$IFDEF TRIALRUN}
  {$I TRIAL04.INC}
{$ENDIF}
begin
  inherited;
  ResponsePacket := TApdDataPacket.Create(Self);
  ResponsePacket.OnStringPacket := ResponseStringPacket;
  ResponsePacket.StartCond := scString;
  ResponsePacket.EndCond := [ecString];
  ResponsePacket.EndString := #13;
  ResponsePacket.Enabled := False;
  ResponsePacket.AutoEnable := False;
  ResponsePacket.IncludeStrings := False;

  ErrorPacket := TApdDataPacket.Create(Self);
  ErrorPacket.OnStringPacket := ErrorStringPacket;
  ErrorPacket.IncludeStrings := False;
  ErrorPacket.StartCond := scString;
  ErrorPacket.StartString := #13#10'ERROR';
  ErrorPacket.EndCond := [ecString];
  ErrorPacket.EndString := #13;
  ErrorPacket.Enabled := False;
  ErrorPacket.AutoEnable := False;
  FConnected := False;
  FHandle := AllocateHWnd(WndProc);
  FMessageStore := TApdMessageStore.Create(Self);
  FComPort := SearchComPort(Owner);
  {$IFDEF TRIALRUN}
  TC;
  {$ENDIF}

  NotifyPacket := TApdDataPacket.Create(Self);                           {!!.02}
  NotifyPacket.OnStringPacket := NotifyStringPacket;                     {!!.02}
  NotifyPacket.StartCond := scString;                                    {!!.02}
  NotifyPacket.StartString := '+CMTI:';                                  {!!.02}
  NotifyPacket.EndCond := [ecString];                                    {!!.02}
  NotifyPacket.EndString := #13;                                         {!!.02}
  NotifyPacket.Enabled := False;                                         {!!.02}
  NotifyPacket.AutoEnable := False;                                      {!!.02}
  NotifyPacket.IncludeStrings := False;                                  {!!.02}
end;

destructor TApdCustomGSMPhone.Destroy;
begin
  FConnected := False;
  ResponsePacket.Free;
  ErrorPacket.Free;
  NotifyPacket.Free;                                                     {!!.02}
  FMessageStore.Clear;
  FMessageStore.Free;
  DeallocateHwnd(FHandle);
  inherited;
end;


{ +CMS ERROR: message Service Failure Result Code }
procedure TApdCustomGSMPhone.ErrorStringPacket(Sender: TObject;
  Data: string);
var
  ErrorCode : Integer;
  ErrorMessage : string;
  Temp : string;
begin
  //Display Message Service Failure Result Code
  Temp := Data;
  Temp := Copy(Data, 1, Pos(' ',Data));
  ErrorCode := -8000 - StrToInt(Temp);
  ErrorMessage := Copy(Data, Pos(' ',Data), Length(Data));
  raise Exception.Create('Exception ' + IntToStr(ErrorCode) + ' ' +
                          ErrorMessage);
end;

procedure TApdCustomGSMPhone.ResponseStringPacket(Sender: TObject;
  Data: string);
begin
  // Handle data from packet -State Machine-
  ResponseStr := Data;
  PostMessage(FHandle, ApdGSMResponse, 0,0);
end;

procedure TApdCustomGSMPhone.NotifyStringPacket(Sender: TObject;         {!!.02}
  Data: string);                                                         {!!.02}
var                                                                      {!!.02}
  MessageIndex : Integer;                                                {!!.02}
begin                                                                    {!!.02}
  NotifyStr := Data;                                                     {!!.02}
  if NotifyStr <> '' then begin                                          {!!.02}
    if assigned(FOnNewMessage) then begin                                {!!.02}
      NotifyStr := Copy(NotifyStr,
        Pos('",', NotifyStr) + 2, Length(NotifyStr));                    {!!.02}
      MessageIndex := StrToInt(NotifyStr);                               {!!.02}
      if Assigned(FOnNewMessage) then                                    {!!.02}
      { not passing the message, we don't have it yet }
        FOnNewMessage(Self, MessageIndex, '');                           {!!.02}
    end;                                                                 {!!.02}
  end;                                                                   {!!.02}
end;                                                                     {!!.02}

{ issues +CMGL to list all messages with a Status of ssUnsend}
procedure TApdCustomGSMPhone.ListAllMessages;
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    DoFail(ecBadOperation,-8302);
    Exit;
  end;
  CmdIndex := 0;
  SetState(gsListAll);
  FMessageStore.ClearStore;
  FComPort.FlushInBuffer;
  ResponsePacket.StartCond := scAnyData;                                 {!!.02}
  //ResponsePacket.StartString := #13#10;                                {!!.02}
  //ResponsePacket.StartString := '+CMGL: ';                             {!!.02}
  ResponsePacket.EndString := #13#10'OK'#13#10;                          {!!.02}
  ResponsePacket.IncludeStrings := True;
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  FComPort.Output := 'AT' + GSMListAllMessagesCommands[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(ecSMSTimedOut,-8101);
    Exit;
  end;
end;

{ issues +CMSS to send message from storage indexed by Index }
procedure TApdCustomGSMPhone.SendFromMemory(TheIndex: Integer);
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
  end;
  CmdIndex := 0;
  SetState(gsSendFStore);
  ResponsePacket.StartString := '+CMSS: ';
  ResponsePacket.EndString := #13#10'OK';
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  FComPort.Output := 'AT' + GSMSendMessFromStorage[CmdIndex] +
                     IntToStr(TheIndex) + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(ecSMSTimedOut,-8101);
    Exit;
  end;
end;

{ issues +CMGS to send message without placing the message in memory }
{$IFDEF AproBCB}
procedure TApdCustomGSMPhone.SendSMSMessage;
{$ELSE}
procedure TApdCustomGSMPhone.SendMessage;
{$ENDIF}
var
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    Connect;
  end;
  if FNotifyOnNewMessage then                                            {!!.01}
    CmdIndex := 0                                                        {!!.01}
  else                                                                   {!!.01}
    CmdIndex := 1;
  ResponsePacket.EndString := #13;                                       {!!.01}
  ResponsePacket.StartString := GSMSendMessageResponse[CmdIndex];
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  SetState(gsSend);
  FComPort.Output := 'AT' + GSMSendMessageCommands[CmdIndex] + #13;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(ecSMSTimedOut,-8101);
    Exit;
  end;
end;

procedure TApdCustomGSMPhone.SetMessage(const Value: string);
begin
  if Length(Value) > 160 then begin
    DoFail(ecSMSTooLong,-8102);
    Exit;
  end;
  FMessage := Value;
end;

{ enables/disables new message notification (+CNMI), new messages provided
  through OnNewMessage event }
procedure TApdCustomGSMPhone.SetNotifyOnNewMessage(const Value: Boolean);
begin
  FNotifyOnNewMessage := Value;
     // Return True for then +CMTI for New Message Indications to TE
end;

{ TApdMessageStore }
function TApdMessageStore.AddMessage(const Dest, Msg: string): Integer;
var
  SMS : TApdSMSMessage;
begin
  SMS := nil;
  try
    SMS := TApdSMSMessage.Create;
    SMS.Message := Msg;
    SMS.Address := Dest;
    SMS.TimeStampStr := FormatDateTime('yy/mm/dd/hh:mm:ss', Now);
    SMS.Status := ssUnsent;

    Result := AddObject(SMS.TimeStampStr, SMS);
  finally
    SMS.Free;
  end;
end;

{ Clear all Messages }
procedure TApdMessageStore.Clear;
begin
 inherited;exit;
  // Clear All messages
  while Count > 0 do begin
    if Objects[Count - 1] <> nil then begin
      TApdSMSMessage(Objects[Count - 1]).Free;
      Objects[Count - 1] := nil;
    end;
    Delete(Count - 1);
  end;
end;

{ Just clears our message store - not the phone }
procedure TApdMessageStore.ClearStore;
begin
  JustClearStore := True;
  Clear;
  JustClearStore := False;
end;

{ Create Message Store }
constructor TApdMessageStore.Create(GSMPhone : TApdCustomGSMPhone);
begin
  FGSMPhone := GSMPhone;
  JustClearStore := False;
end;

{ issues +CMGD to Delete Message at Index }
procedure TApdMessageStore.Delete(PhoneIndex: Integer);
var
  I : Integer;
begin
  //PhoneIndex := FGSMPhone.MessageStore.Messages[StoreIndex].MessageIndex;
  if (FGSMPhone.FConnected) and not(JustClearStore) then
    FGSMPhone.DeleteFromMemoryIndex(PhoneIndex)
  else begin
    for I := 0 to pred(Count) do
      if Messages[I].MessageIndex = PhoneIndex then
        Break;
    if I < Count then begin
      if Objects[I] <> nil then begin
        TApdSMSMessage(Objects[I]).Free;
        Objects[I] := nil;
      end;
      inherited Delete(I);
    end;
  end;
end;

{ Return the phone's message store capacity }
function TApdMessageStore.GetCapacity: Integer;
begin
  result := FCapacity;
end;

{ Get message number of Index }
{$IFDEF AproBCB}
function TApdMessageStore.GetSMSMessage(Index: Integer): TApdSMSMessage;
{$ELSE}
function TApdMessageStore.GetMessage(Index: Integer): TApdSMSMessage;
{$ENDIF}
begin
  Result := TApdSMSMessage(Objects[Index]);
end;

{ issues + to send all messages with a Status of ssUnsent }
procedure TApdCustomGSMPhone.SendAllMessages;
var
  Res : Integer;
  HighIndex: Integer;
  I: Integer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  CmdIndex := 0;
  { tell the GSMPhone to send all messages in it's store }
  HighIndex := FMessageStore.GetCapacity;
  for I := 0 to HighIndex do begin
    SendFromMemory(I);
  end;
end;

procedure TApdCustomGSMPhone.ProcessResponse;

  { Convert String to Integer }
  function GSMStrToInt(Str : string) : Integer;
  begin
    while Pos(' ', Str) > 0 do
      Str[Pos(' ', Str)] := '0';
    Result := StrToInt(Str);
  end;

var
  S : string;
  STemp : string;
  MsgRdy : Boolean;

  { Parse a message }
  function ParseAMessage : Boolean;
    { Get next field in message }
    function GetNextField( aDelimiter: String ): String;
    var
      aDelimiterPosition: Integer;
    begin
    {To retrieve the text from position 1 until the occurance of aDelimiter
     while advancing the pointer in S so that we can just call this function
     again and again. }
      if S[1] = '"' then begin
        aDelimiter := '"' + aDelimiter;
      end;
      aDelimiterPosition := Pos( aDelimiter, S );
      Result := Copy( S, 1, aDelimiterPosition - 1 );

      if ( Result <> '' ) and ( Result[ 1 ] = '"' ) then
        Result := Copy( Result, 2, Length( Result ) );
      if ( Result <> '' ) and ( Result[ Length( Result ) ] = '"' )then
        Result := Copy( Result, 1, Length( Result ) - 1 );

      S := Copy( S, aDelimiterPosition + Length( aDelimiter ), Length( S ));
    end;

  { Start procedure ParseAMessage }
  begin
    if Pos (#13#10, S) = 1 then
      GetNextField (#13#10);
    if Pos('+CMGL:', S) = 1 then begin
      // first line of the message
      // format is +CMGL: Index, status, address, address name, timestamp
      TempSMSMessage := TApdSMSMessage.Create;
      S := Copy(S, Pos(':', S) + 1, Length(S));
      // extract the index number
      TempSMSMessage.MessageIndex := GSMStrToInt(GetNextField(','));
      // extract the status
      STemp := GetNextField( ',' );
      if STemp = 'STO UNSENT' then TempSMSMessage.FStatus := ssUnsent
      else if STemp = 'STO SENT' then TempSMSMessage.FStatus := ssSent
      else if STemp = 'ALL' then TempSMSMessage.FStatus := ssAll
      else if STemp = 'REC UNREAD' then TempSMSMessage.FStatus := srUnread
      else if STemp = 'REC READ' then TempSMSMessage.FStatus := srRead
      else TempSMSMessage.FStatus := ssUnknown;                          {!!.01}

      // Read the address field with quotes (if any)
      TempSMSMessage.FAddress := GetNextField( ',' );
      // Name (??) field  followed by ,
      TempSMSMessage.FName := GetNextField( ',' );
      // DateTime Field followed by ,
      TempSMSMessage.FTimeStampStr := GetNextField( ',' );
      if TempSMSMessage.FTimeStampStr = '' then
        TempSMSMessage.FTimeStampStr := '<no timestamp>';
      // Message Type   followed by ,
      STemp := GetNextField( ',' );
      // Message Length followed by #13#10
      STemp := GetNextField( #13#10 );
      // Message        followed by #13#10
      TempSMSMessage.Message := GetNextField( #13#10 );
    end else begin
      // Message more than 1 line???
      TempSMSMessage.Message := TempSMSMessage.Message + #13#10 +
                      GetNextField( #13#10 );
    end;
    MessageStore.AddObject(TempSMSMessage.TimeStampStr, TempSMSMessage);
    Result := Pos('+CMGL:', S) = 0;
  end;

begin
  //State machine response handle
  case FGSMState of

    gsConfig: begin
                // Just sent +CSMS=0, successful so far, send the next command
                inc(CmdIndex);
                if CmdIndex > High(GSMConfigAvail) then begin
                    // generate the OnComplete event, we're done configuring
                  ResponseStr := '';                                     {!!.02}
                  if not FQuickConnect then begin                        {!!.02}
                    FGSMState := gsNone;                                 {!!.02}
                    ListAllMessages;                                     {!!.02}
                  end;                                                   {!!.02}
                  FGSMState := gsConfig;                                 {!!.02}
                  if Assigned(FOnGSMComplete) then                       {!!.02}
                    FOnGSMComplete(Self, FGSMState, FErrorCode);         {!!.02}
                  FGSMState := gsNone;  
                  FConfigList := False;                                  {!!.02}
                end else begin
                  // send the next command
                  ResponsePacket.StartString := GSMConfigResponse[CmdIndex];
                  ResponsePacket.EndString := #13;
                  ResponsePacket.Enabled := True;
                  DelayTicks(4, True);
                  FComPort.Output := 'AT' + GSMConfigAvail[CmdIndex] + #13;
                end;
              end;

    gsSend: begin
              // Just sent CNMI, successful so far, send the next command
              inc(CmdIndex);
              if CmdIndex > High(GSMSendMessageResponse) then begin
                // Sent message - see if another message is ready
                if Assigned(FOnNextMessage) then begin
                  MsgRdy := False;
                  FOnNextMessage(Self, FErrorCode, MsgRdy);
                  if MsgRdy then begin
                    { Will inc(CmdIndex) and start with the CSCA setting }
                    CmdIndex := 2;
                    PostMessage(FHandle, ApdGSMResponse, 0,0);
                  end;
                end;
                // generate the OnComplete event, we're done
                if Assigned(FOnGSMComplete) then begin
                  FOnGSMComplete(Self, FGSMState, FErrorCode);
                end;
                FGSMState := gsNone;
                ResponseStr := '';                                       {!!.02}
              end else begin
                if CmdIndex = High(GSMSendMessageCommands) - 1 then begin
                  // send the next command
                  ResponsePacket.StartString :=
                      GSMSendMessageResponse[CmdIndex];
                  ResponsePacket.EndString := '>'#32;
                  ResponsePacket.Enabled := True;
                  DelayTicks(4, True);
                  S := SMSAddress;
                  if S = '' then begin                                   {!!.02}
                    DoFail(ecBadOperation,-8302);                        {!!.02}
                    Exit;                                                {!!.02}
                  end;                                                   {!!.02}
                  if S[1] <> '"' then {begin}                            {!!.01}
                    S := '"' + S + '"';                                  {!!.01}
                  //else                                                 {!!.01}
                    //if S[2] <> '+' then                                {!!.01}
                      //S := '"+' + S + '"';                             {!!.01}
                  //end;                                                 {!!.01}
                  S := S + #13#10;
                  FComPort.Output := 'AT' + GSMSendMessageCommands[CmdIndex]
                                      + S;
                end else begin
                  if CmdIndex = High(GSMSendMessageCommands) then begin
                    ResponsePacket.StartString :=
                        GSMSendMessageResponse[CmdIndex];
                    ResponsePacket.EndString := #13#10;
                    ResponsePacket.Enabled := True;
                    DelayTicks(4, True);
                    STemp := FMessage;
                    if STemp[Length(STemp)] <> #26 then
                      STemp := STemp + #26;
                    FComPort.Output := STemp;
                  end else begin
                    ResponsePacket.StartString :=
                        GSMSendMessageResponse[CmdIndex];
                    ResponsePacket.Enabled := True;
                    DelayTicks(4, True);
                    if GSMSendMessageCommands[CmdIndex] = '+CSCA=' then begin
                      if (FSMSCenter <> '') and
                      (GSMSendMessageCommands[CmdIndex]='+CSCA=') then begin
                        if FSMSCenter[1] = '"' then {begin}              {!!.01}
                          FSMSCenter := copy(FSMSCenter, 2, Length(FSMSCenter));
                          {*if FSMSCenter[2] = '+' then
                            {FSMSCenter := copy(FSMSCenter, 3,
                                               {Length(FSMSCenter));*}   {!!.01}
                        if FSMSCenter[Length(FSMSCenter)] = '"' then     {!!.01}
                          FSMSCenter := copy(FSMSCenter, 1,              {!!.01}
                                               Length(FSMSCenter)-1);    {!!.01}
                        //end;                                           {!!.01}
                        FComport.Output := 'AT' +
                                GSMSendMessageCommands[CmdIndex]+'"'     {!!.01}
                                           + FSMSCenter + '"' + #13
                      end else begin
                        inc(CmdIndex);
                        ResponsePacket.StartString :=
                            GSMSendMessageResponse[CmdIndex];
                        ResponsePacket.EndString := '>'#32;
                        ResponsePacket.Enabled := True;
                        DelayTicks(4, True);
                        S := SMSAddress;
                        if S = '' then begin                             {!!.02}
                          DoFail(ecBadOperation,-8302);                  {!!.02}
                          Exit;                                          {!!.02}
                        end;                                             {!!.02}
                        if S[1] <> '"' then {begin}                      {!!.01}
                          S := '"' + S + '"';                            {!!.01}
                        //else                                           {!!.01}
                          //if S[2] <> '+' then                          {!!.01}
                            //S := '"+' + S + '"';                       {!!.01}
                        //end;                                           {!!.01}
                        S := S + #13#10;
                        FComPort.Output := 'AT' +
                                           GSMSendMessageCommands[CmdIndex] + S;
                      end
                    end else
                      FComPort.Output := 'AT' + GSMSendMessageCommands[CmdIndex]
                                         + #13;
                  end
                end
              end
            end;
    gsListAll : begin
                  // Just sent +CMGL, successful so far, send the next command
                  S := ResponseStr;
                  if Length(S) > 8 then                                  {!!.02}
                    //while FGSMState = gsListAll do begin
                      //ParseAMessage;                                   {!!.02}
                    //end;                                               {!!.02}
                  while ParseAMessage do                                 {!!.02}
                    DelayTicks(1, True);                                 {!!.02}
                  ResponsePacket.IncludeStrings := False;
                  ResponsePacket.StartCond := scString;                  {!!.02}
                  if Assigned(FOnMessageList) then
                    FOnMessageList(Self);
                  if Assigned(FOnGSMComplete) and not FConfigList then       {!!.02}
                    FOnGSMComplete(Self, FGSMState, FErrorCode);
                  FGSMState := gsNone;
                  ResponseStr := '';                                     {!!.02}
                end;

    gsSendFStore : begin
                     //Just sent +CMSS, successful so far, send the next command
                     inc(CmdIndex);
                     if CmdIndex > High(GSMSendMessFromStorage) then begin
                       // generate the OnComplete event, we're done
                       FMessageStore.ClearStore;
                       Synchronize;
                       if Assigned(FOnMessageList) then
                         FOnMessageList(Self);
                       if Assigned(FOnGSMComplete) then
                         FOnGSMComplete(Self, FGSMState, FErrorCode);
                       FGSMState := gsNone;
                       ResponseStr := '';                                {!!.02}
                     end else
                       // send the next command if there is one
                       FComPort.Output := 'AT' +
                                     GSMSendMessFromStorage[CmdIndex] + #13;
                   end;
    gsWrite : begin
                // Just sent +CMGW, successful so far, send the next command
                inc(CmdIndex);
                if CmdIndex > High(GSMWriteToMemoryCommands) then begin
                  FMessageStore.ClearStore;
                  Synchronize;
                  if Assigned(FOnMessageList) then
                    FOnMessageList(Self);
                  // generate the OnComplete event, we're done configuring
                  if Assigned(FOnGSMComplete) then
                    FOnGSMComplete(Self, FGSMState, FErrorCode);
                  FGSMState := gsNone;                                   {!!.02}
                  ResponseStr := '';                                     {!!.02}
                end else
                  // send the next command
                  ResponsePacket.StartString :=
                      GSMWriteToMemoryResponse[CmdIndex];
                  ResponsePacket.EndString := #13#10;
                  ResponsePacket.Enabled := True;
                  DelayTicks(4, True);
                  if FTempWriteMess[Length(FTempWriteMess)] <> #26 then
                      FTempWriteMess := FTempWriteMess + #26;
                  FComPort.Output := FTempWriteMess;
              end;
    gsDelete : begin
                 { Just sent +CMGD=,successful so far, send the next command}
                 inc(CmdIndex);
                 if CmdIndex > High(GSMDeleteAMessageCommand) then begin
                   // generate the OnComplete event, we're done
                   //ResponsePacket.IncludeStrings := False;             {!!.01}
                   FMessageStore.ClearStore;
                   Synchronize;
                   if Assigned(FOnMessageList) then
                     FOnMessageList(Self);
                   if Assigned(FOnGSMComplete) then
                     FOnGSMComplete(Self, FGSMState, FErrorCode);
                   FGSMState := gsNone;                                  {!!.02}
                   ResponseStr := '';                                    {!!.02}
                 end else
                   // send the next command
                   FComPort.Output := 'AT' + GSMDeleteAMessageCommand[CmdIndex]
                                      + #13;
               end;
  end; // End Case
end;

{ issues +CMGW to write message secified by FMessage and DestAddr to the phone
  memory, memory location returned as function result }
procedure TApdCustomGSMPhone.WriteToMemory(const Dest, Msg: string);
var
  S : string;
  Res : Integer;
  ET : EventTimer;
begin
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  SetState(gsWrite);
  ResponsePacket.StartString := GSMWriteToMemoryResponse[CmdIndex];
  ResponsePacket.EndString := '>'#32;
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  S := Dest;
  if S[1] <> '"' then begin
    if S[1] = '+' then
      S := '"' + S + '"'
    else
      if S[2] <> '+' then
        S := '"+' + S + '"';
  end;
  FComPort.Output := 'AT' + GSMWriteToMemoryCommands[CmdIndex] + S + #13#10;
  FTempWriteMess := Msg + #26;
  NewTimer(ET, 1080); // 60 second timer
  repeat
    Res := SafeYield;
  until (FGSMState = gsNone) or (Res = wm_Quit) or TimerExpired(ET);
  if TimerExpired(ET) then begin
    DoFail(ecSMSTimedOut,-8101);
    Exit;
  end;
end;

procedure TApdCustomGSMPhone.WndProc(var Message: TMessage);
begin
  with Message do begin
    if Msg = ApdGSMResponse then begin
      ProcessResponse   
    end else
      Result := DefWindowProc(FHandle, Msg, wParam, lParam);
  end;
end;

procedure TApdCustomGSMPhone.DeleteFromMemoryIndex(PhoneIndex: Integer);
var
  Res : Integer;
begin
  { Remove a single message from the phone's message store }
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  CmdIndex := 0;
  SetState(gsDelete);
  //ResponsePacket.IncludeStrings := True;                               {!!.01}
  ResponsePacket.StartString := GSMDeleteAMessageCommand[CmdIndex];
  ResponsePacket.EndString := #13#10'OK';
  ResponsePacket.Enabled := True;
  DelayTicks(4, True);
  FComPort.Output := 'AT' + GSMDeleteAMessageCommand[CmdIndex] +
                     IntToStr(PhoneIndex) + #13;
end;

procedure TApdCustomGSMPhone.CheckPort;
begin
  { Make sure comport is open }
  if Assigned(FComPort) then begin
    if (FComPort.DeviceLayer = dlWinSock) then
      { we can't do GSM through Winsock... }
      raise ECannotUseWithWinSock.Create(ecCannotUseWithWinSock, False);
    if not(FComPort.Open) then
      { open the port, let the TApdComPort raise any exceptions }
      FComPort.Open := True;
    FGSMState := gsNone;
    FConnected := True;
  end else
    raise EPortNotAssigned.Create(ecPortNotAssigned, False);
end;

procedure TApdCustomGSMPhone.Synchronize;
var
  Res : Integer;
begin
  // tell the phone to give us the message store
  if FGSMState > gsNone then begin
    DoFail(ecSMSBusy,-8100);
    Exit;
  end;
  if not FConnected then begin
    { Do connection/configuration stuff }
    FQuickConnect := False;
    Connect;
    repeat
      Res := SafeYield;
    until (FGSMState = gsNone) or (Res = wm_Quit);
  end;
  //FGSMState := gsNone;                                                 {!!.02}
  ListAllMessages;
end;

procedure TApdMessageStore.SetMSCapacity(const Value: Integer);
begin
  FCapacity := Value;
end;

procedure TApdMessageStore.SetMessage(Index: Integer;
                                      const Value: TApdSMSMessage);
begin
  Strings[Index] := Value.FTimeStampStr;
  Objects[Index] := Value;
  //if Value > 160 then DoFail(ecSMSTooLong,-8102);
end;

{ Notification }
procedure TApdCustomGSMPhone.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then begin
    if AComponent = FComPort then
      FComPort := nil;
  end else begin
    if (AComponent is TApdCustomComPort) and (FComPort = nil) then
      FComPort := TApdCustomComPort(AComponent);
  end;
end;

{ Set the Service Center Address/Phone Number }
procedure TApdCustomGSMPhone.SetCenter(const Value: string);
begin
  FSMSCenter := Value;
end;

{ TApdGSMPhone - TApdSMSStatus to string conversion}  
function TApdCustomGSMPhone.StatusToStr(StatusString: TApdSMSStatus): string;
const
    StatusStrings : array[0..ord(High(TApdSMSStatus))] of string =       {!!.01}
              ('REC UNREAD', 'REC READ', 'STO UNSENT', 'STO SENT', 'ALL',
               'Unknown');                                               {!!.01}
begin
  if ord(StatusString) > High(StatusStrings) then begin
    Result := StatusStrings[High(StatusStrings)];                        {!!.02}
    //DoFail(ecSMSUnknownStatus,-8103);                                  {!!.02}
    Exit;
  end;
  Result := StatusStrings[Ord(StatusString)];
end;

procedure TApdCustomGSMPhone.DoFail(const Msg: string;
  const ErrCode: Integer);
begin
  if Assigned(FOnGSMComplete) then begin
    FOnGSMComplete(Self, FGSMState, ErrCode);
    FGSMState := gsNone;
  end else begin
    //raise EApdGSMPhoneException.Create(Msg, ErrCode);
    FGSMState := gsNone;
    raise EApdGSMPhoneException.Create(ErrCode, Msg);
  end;
end;

procedure TApdCustomGSMPhone.SetState(NewState : TGSMStates);
begin
  FGSMState := NewState;
end;

end.
