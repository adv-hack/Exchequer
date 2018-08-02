unit CardReaderU;
{
  Component for handling communications with an Omni 3750 Chip & Pin Terminal.

  Before using the TCardReader component, the Address and Port properties must
  be set correctly for the terminal that is being used. The Port property will
  default to 25000, which should be correct, but can be changed if necessary.

  To authorise a transaction using Chip & Pin, fill in the required
  TCardReader.Transaction properties, then call TCardReader.Authorise.

  If the authorise fails, check the TCardReader.Error property for details.
  Other results will be returned in the TCardReader.Output object property.

  Example usage:

    Reader := TCardReader.Create(nil);
    try
      Reader.Address := '192.168.0.251';  // IP Address of the Omni terminal.
      Reader.Transaction.TransactionValue := '24.05';
      case Reader.Authorise of
        caAuthorised: // Card authorised, continue to process transaction.
        caInvalid:    // Card was rejected. Check Reader.Error for details.
        caError:      // An error occurred. Check Reader.Error for details.
      end;
    finally
      Reader.Free;
    end;
}
interface

uses SysUtils, Classes, Forms, ScktComp;

type
  TCardReaderStatusEvent = procedure (Sender: TObject; StatusMsg: string) of object;
  TCardReaderStatus = (csIdle, csConnecting, csConnected, csConnectionFailed,
                       csWaitingForAuthorisation, csWaitingForCardDetails,
                       csResponseReceived);
  TCardReaderAuthorisation = (caAuthorised, caInvalid, caError);
  TTrack2Record = string;
  { The TTransactionInput class holds the details of a transaction record. The
    AsString property returns these as a comma-separated record in the format
    required by the Ocius terminal. All these properties are stored as strings,
    as that is how the Ocius terminal requires them. }
  TTransactionInput = class(TObject)
  private
    FRecordType: ShortString;
    FModifier: ShortString;
    FAccountNumber: ShortString;
    FTransactionType: ShortString;
    FTrack2: ShortString;
    FCV2: ShortString;
    FTrack1: ShortString;
    FChequeNumber: ShortString;
    FMerchantReferenceNumber: ShortString;
    FChequeType: ShortString;
    FCashBackValue: ShortString;
    FSortCode: ShortString;
    FBankAccountNumber: ShortString;
    FTransactionValue: ShortString;
    FAccountID: ShortString;
    FExpiry: ShortString;
    FCardHolderName: ShortString;
    FTransactionDateAndTime: ShortString;
    FStart: ShortString;
    FCardHolderBillingAddress: ShortString;
    FEFTSequenceNumber: ShortString;
    FIssueNumber: ShortString;
    FAuthorisationSource: ShortString;
    FAuthorisationCode: ShortString;
    function GetAsString: string;
  public
    constructor Create;
    property RecordType: ShortString read FRecordType write FRecordType;
    property AccountNumber: ShortString read FAccountNumber write FAccountNumber;
    property TransactionType: ShortString read FTransactionType write FTransactionType;
    property Modifier: ShortString read FModifier write FModifier;
    property Track1: ShortString read FTrack1 write FTrack1;
    property Track2: ShortString read FTrack2 write FTrack2;
    property CV2: ShortString read FCV2 write FCV2;
    property Expiry: ShortString read FExpiry write FExpiry;
    property IssueNumber: ShortString read FIssueNumber write FIssueNumber;
    property Start: ShortString read FStart write FStart;
    property TransactionValue: ShortString read FTransactionValue write FTransactionValue;
    property CashBackValue: ShortString read FCashBackValue write FCashBackValue;
    property BankAccountNumber: ShortString read FBankAccountNumber write FBankAccountNumber;
    property SortCode: ShortString read FSortCode write FSortCode;
    property ChequeNumber: ShortString read FChequeNumber write FChequeNumber;
    property ChequeType: ShortString read FChequeType write FChequeType;
    property CardHolderName: ShortString read FCardHolderName write FCardHolderName;
    property CardHolderBillingAddress: ShortString read FCardHolderBillingAddress write FCardHolderBillingAddress;
    property EFTSequenceNumber: ShortString read FEFTSequenceNumber write FEFTSequenceNumber;
    property AuthorisationSource: ShortString read FAuthorisationSource write FAuthorisationSource;
    property AuthorisationCode: ShortString read FAuthorisationCode write FAuthorisationCode;
    property TransactionDateAndTime: ShortString read FTransactionDateAndTime write FTransactionDateAndTime;
    property MerchantReferenceNumber: ShortString read FMerchantReferenceNumber write FMerchantReferenceNumber;
    property AccountID: ShortString read FAccountID write FAccountID;
    property AsString: string read GetAsString;
  end;

  { The TTransactionOutput class holds the transaction output details returned
    by the Ocius terminal after a transaction has been handled. All these
    properties are stored as strings, as that is how the Ocius terminal returns
    them. }
  TTransactionOutput = class(TObject)
  private
    FAsString: string;
    FAuthorisationCode: string;
    FAuthorisationMessage: string;
    FMerchantNumber: string;
    FIssueNumber: string;
    FStart: string;
    FFloorLimit: string;
    FResult: string;
    FCashBackValue: string;
    FReferralTelephoneNumber: string;
    FExpiryDate: string;
    FPAN: string;
    FTransactionDateAndTime: string;
    FSchemeName: string;
    FTransactionValue: string;
    FEFTSequenceNumber: string;
    FGratuityValue: string;
    FTerminateLoop: string;
    FTerminalID: string;
  public
    procedure ParseOutput(OutputString: string);
    property AsString: string read FAsString write FAsString;
    property Result: string read FResult;
    property TerminateLoop: string read FTerminateLoop;
    property TransactionValue: string read FTransactionValue;
    property CashBackValue: string read FCashBackValue;
    property GratuityValue: string read FGratuityValue;
    property PAN: string read FPAN;
    property ExpiryDate: string read FExpiryDate;
    property IssueNumber: string read FIssueNumber;
    property Start: string read FStart;
    property TransactionDateAndTime: string read FTransactionDateAndTime;
    property MerchantNumber: string read FMerchantNumber;
    property TerminalID: string read FTerminalID;
    property SchemeName: string read FSchemeName;
    property FloorLimit: string read FFloorLimit;
    property EFTSequenceNumber: string read FEFTSequenceNumber;
    property AuthorisationCode: string read FAuthorisationCode;
    property ReferralTelephoneNumber: string read FReferralTelephoneNumber;
    property AuthorisationMessage: string read FAuthorisationMessage;
  end;

  TCardReader = class(TComponent)
  private
    ClientSocket: TClientSocket;
    Socket: TCustomWinSocket;
    WaitStartTime: TDateTime;
    FError: string;
    FCardDetails: TTrack2Record;
    FTransaction: TTransactionInput;
    FOutput: TTransactionOutput;
    FStatus: TCardReaderStatus;
    FOnStatusChange: TCardReaderStatusEvent;
    FTimeOut: Integer;
    FCancelled: Boolean;
    function GetAddress: string;
    function GetPort: Integer;
    function OpenSocket: Boolean;
    procedure ParseCardDetails(DetailString: string);
    procedure SetAddress(const Value: string);
    procedure SetPort(const Value: Integer);
    procedure StatusMsg(Msg: string);
    function TimedOut: Boolean;
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Authorise: TCardReaderAuthorisation;
    procedure Cancel;
    procedure GetSettingsFromINI;
    function ReadCard: Boolean;

    { Calling the Cancel method will set this flag, forcing any active
      operations to be aborted. }
    property Cancelled: Boolean read FCancelled;

    { If any errors occur during Authorise, the description is stored in
      the Error property. }
    property Error: string read FError;

    { Credit Card details as read from the Omni terminal using ReadCard. }
    property CardDetails: TTrack2Record read FCardDetails;

    { Transaction details to be sent to the Omni terminal for authorisation. }
    property Transaction: TTransactionInput read FTransaction;

    { Output details returned by the Omni terminal after authorisation. }
    property Output: TTransactionOutput read FOutput;

  published
    { IP Address of Omni terminal. }
    property Address: string read GetAddress write SetAddress;

    { Port used for Omni terminal, usually 25000. }
    property Port: Integer read GetPort write SetPort;

    { Current status (Idle or Authorising) of the Card Reader. Mainly used
      internally, but available for reading if necessary. }
    property Status: TCardReaderStatus read FStatus;

    { Time to wait (in milliseconds) before cancelling an operation. Defaults
      to 60000 (60 seconds). }
    property TimeOut: Integer read FTimeOut write FTimeOut;

    { OnStatusChanged is called whenever a significant event occurs (connecting,
      authorising, etc). The procedure will be passed the CardReader object
      and a status message. Mainly for debugging purposes. }
    property OnStatusChange: TCardReaderStatusEvent
      read FOnStatusChange write FOnStatusChange;
  end;
  ECardReaderError = class(Exception)
  end;

implementation

uses Controls, Dialogs, DateUtils, CardReaderErrors, Inifiles;

{ TCardReader }

function TCardReader.Authorise: TCardReaderAuthorisation;
{ Authorises the transaction. The Transaction details must already be set up,
  otherwise the authorisation will automatically fail.

  Returns caAuthorised, caInvalid, or caError. For caInvalid or caError, the
  Error property holds a description of the error. }
var
  Response: Word;
begin
  { Assume the worst. }
  Result := caError;
  { Connect }
  if OpenSocket then
  try
    try
      StatusMsg('Sending transaction record');
      FStatus := csWaitingForAuthorisation;
      WaitStartTime := Now;
      Socket.SendText(Transaction.AsString);

      StatusMsg('Waiting for authorisation');
      while (Status <> csResponseReceived) and
            (not TimedOut) and
            (not Cancelled) do
      begin
        Application.ProcessMessages;
        if TimedOut then
        begin
          Response := MessageDlg('Timed out waiting for authorisation',
                                 mtError,
                                 [mbAbort, mbRetry],
                                 0);
          if Response = mrAbort then
            FCancelled := True
          else
            WaitStartTime := Now;
        end
      end;

      StatusMsg('Checking authorisation response');

      if Cancelled then
      begin
        Result := caError;
        FError := 'Authorisation cancelled';
        StatusMsg('Cancelled');
      end
      { Check the output record to see if the transaction was authorised or
        declined. }
      else if (Output.Result = '0') then
      begin
        Result := caAuthorised;
        StatusMsg('Authorised');
      end
      else if (Output.Result = '7') then
      begin
        Result := caInvalid;
        FError := Output.AuthorisationMessage;
        StatusMsg('Declined: ' + Error);
      end
      else
      begin
        Result := caError;
        FError := Output.AuthorisationMessage;
        StatusMsg('Error: ' + Output.Result + ' : ' + Error);
      end;

    except
      on E:Exception do
      begin
        FError := 'An unexpected error occured while trying to authorise ' +
                  'the transaction:' +
                  #13#10#13#10 +
                  E.Message;
        StatusMsg(Error);
      end;
    end;
  finally
    { Make sure we are disconnected (the Omni terminal tends to disconnect
      automatically, but we'll check just in case). }
    if ClientSocket.Active then
      ClientSocket.Close;
    StatusMsg('Authorisation finished');
    FStatus := csIdle;
  end;
end;

procedure TCardReader.Cancel;
begin
  if (Status <> csIdle) then
  begin
    FCancelled := True;
    ClientSocket.Close;
    FStatus := csIdle;
  end;
end;

procedure TCardReader.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  { Store the Socket reference -- this is needed for reading and writing to
    the socket. }
  self.Socket := Socket;
  FStatus := csConnected;
  StatusMsg('Connected');
end;

procedure TCardReader.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  { Don't change the status to idle if we are still waiting for a response
    from the terminal. The terminal will disconnect, but we will still receive
    data from it -- setting the status to csIdle as soon as we disconnect will
    result in some data not being received. }
  if (not (Status in [csWaitingForAuthorisation, csWaitingForCardDetails])) then
    FStatus := csIdle;
  StatusMsg('Disconnected');
end;

procedure TCardReader.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  StatusMsg('Error: ' + IntToStr(ErrorCode));
  Socket.Close;
  FStatus := csIdle;
  if (ErrorEvent = eeConnect) then
  begin
    FError  := 'Connection failed. Error: ' + IntToStr(ErrorCode);
    FStatus := csConnectionFailed;
  end;
  ErrorCode := 0;
end;

procedure TCardReader.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Response: string;
begin
  StatusMsg('Receiving data from terminal');
  Response := Socket.ReceiveText;
  { Are we waiting for authorisation? }
  if (Status = csWaitingForAuthorisation) then
  begin
    { Is this an output record? }
    if (Copy(Response, 1, 1) <> #6) then
    begin
      StatusMsg('Transaction response received');
      { Copy the results into the Output object. }
      Output.ParseOutput(Response);
      FStatus := csResponseReceived;
    end;
  end
  { Are we waiting for card details? }
  else if (Status = csWaitingForCardDetails) then
  begin
    { Is this an output record? }
    if (Copy(Response, 1, 1) <> #6) then
    begin
      { Extract the Track2 credit card record into the CardDetails property. }
      ParseCardDetails(Response);
      FStatus := csResponseReceived;
    end;
  end;
end;

constructor TCardReader.Create(AOwner: TComponent);
begin
  inherited;
  FTransaction := TTransactionInput.Create;
  FOutput      := TTransactionOutput.Create;
  FStatus      := csIdle;
  FTimeOut     := 60000;
  ClientSocket := TClientSocket.Create(nil);
  ClientSocket.ClientType := ctNonBlocking;
  ClientSocket.OnConnect := ClientSocketConnect;
  ClientSocket.OnDisconnect := ClientSocketDisconnect;
  ClientSocket.OnError := ClientSocketError;
  ClientSocket.OnRead := ClientSocketRead;
  GetSettingsFromINI;
end;

destructor TCardReader.Destroy;
begin
  Socket := nil;
  ClientSocket.Close;
  FreeAndNil(ClientSocket);
  FreeAndNil(FOutput);
  FreeAndNil(FTransaction);
  inherited;
end;

function TCardReader.GetAddress: string;
begin
  Result := ClientSocket.Address;
end;

function TCardReader.GetPort: Integer;
begin
  Result := ClientSocket.Port;
end;

procedure TCardReader.GetSettingsFromINI;
var
  INIFile : TINIFile;
begin
  INIFile := TINIFile.Create(ExtractFileDir(ParamStr(0))+'\ExCommid.INI');
  try
    Transaction.AccountNumber :=
      INIFile.ReadString('OMNI3750', 'AccountNo', '');
    Transaction.AccountID :=
      INIFile.ReadString('OMNI3750', 'AccountID', '');
    Address := INIFile.ReadString('OMNI3750', 'Address', '192.168.0.251');
    Port    := INIFile.ReadInteger('OMNI3750', 'Port', 25000);
    TimeOut := INIFile.ReadInteger('OMNI3750', 'Timeout', 45) * 1000;
  finally
    INIFile.Free;
  end;
end;

function TCardReader.OpenSocket: Boolean;
begin
  FStatus := csConnecting;
  WaitStartTime := Now;
  try
    try
      StatusMsg('Opening socket');
      ClientSocket.Open;
      { Wait for the connection to be established. See ClientSocketConnect. }
      StatusMsg('Waiting for connection');
      while (FStatus = csConnecting) and
            (not TimedOut) and
            (not Cancelled) do
        Application.ProcessMessages;
    except
      on E:Exception do
      begin
        FError := E.Message;
        FStatus := csIdle;
      end;
    end;
  finally
    if (Status = csConnectionFailed) then
      Result := False
    else
      Result := (FStatus = csConnected);
  end;
end;

procedure TCardReader.ParseCardDetails(DetailString: string);
var
  CharPos: Integer;
begin
  { Find the start of the Track2 record contents }
  DetailString := Copy(DetailString, 3, Length(DetailString));
  { Find the end of the Track2 record contents }
  CharPos := Pos('?', DetailString);
  if (CharPos <> 0) then
    DetailString := Copy(DetailString, 1, CharPos - 1);
  FCardDetails := DetailString;
end;

function TCardReader.ReadCard: Boolean;
begin
  { Assume the worst. }
  Result := False;
  { Connect }
  if OpenSocket then
  try
    try
      StatusMsg('Sending card details request to terminal');
      FStatus := csWaitingForCardDetails;
      WaitStartTime := Now;
      Socket.SendText('G,');

      StatusMsg('Waiting for card details from terminal');
      while (Status <> csResponseReceived) and
            (not TimedOut) and
            (not Cancelled) do
        Application.ProcessMessages;

      StatusMsg('Checking card details response');
      if TimedOut then
      begin
        Result := False;
        StatusMsg('Timed out');
      end
      else if Cancelled then
      begin
        Result := False;
        StatusMsg('Cancelled');
      end
      else
      begin
        { Card details retrieved into CardDetails property
          -- see ClientSocketRead. }
        Result := True;
        StatusMsg('Card details retrieved');
      end;

    except
      on E:Exception do
      begin
        FError := 'An unexpected error occured while trying to retrieve the ' +
                  'card details:' +
                  #13#10#13#10 +
                  E.Message;
        StatusMsg(Error);
      end;
    end;
  finally
    { Make sure we are disconnected (the Omni terminal tends to disconnect
      automatically, but we'll check just in case). }
    if ClientSocket.Active then
      ClientSocket.Close;
    StatusMsg('Card details request finished');
    FStatus := csIdle;
  end;
end;

procedure TCardReader.SetAddress(const Value: string);
begin
  ClientSocket.Address := Value;
end;

procedure TCardReader.SetPort(const Value: Integer);
begin
  ClientSocket.Port := Value;
end;

procedure TCardReader.StatusMsg(Msg: string);
begin
  if Assigned(FOnStatusChange) then
    OnStatusChange(self, Msg);
end;

function TCardReader.TimedOut: Boolean;
var
  Duration: Integer;
begin
  if (TimeOut <> 0) then
  begin
    Duration := DateUtils.MilliSecondsBetween(Now, WaitStartTime);
    Result := (Duration > TimeOut);
  end
  else
    Result := False;
end;

{ TTransactionInput }

constructor TTransactionInput.Create;
begin
  inherited Create;
  { Default property values. }
  FRecordType := 'T';             // Transaction record type.
  FTransactionType := '01';       // 01: Purchase; 02: Refund.
  FModifier := '0000';            // No special handling required.
  FCashBackValue := '0'           // No cashback.
end;

function TTransactionInput.GetAsString: string;
{ Returns a string in the format required by the Ocius terminal. }
begin
  Result :=
    RecordType + ',' +
    AccountNumber + ',' +
    TransactionType + ',' +
    Modifier + ',' +
    Track1 + ',' +
    Track2 + ',' +
    CV2 + ',' +
    Expiry + ',' +
    IssueNumber + ',' +
    Start + ',' +
    TransactionValue + ',' +
    CashBackValue + ',' +
    BankAccountNumber + ',' +
    SortCode + ',' +
    ChequeNumber + ',' +
    ChequeType + ',' +
    CardHolderName + ',' +
    CardHolderBillingAddress + ',' +
    EFTSequenceNumber + ',' +
    AuthorisationSource + ',' +
    AuthorisationCode + ',' +
    TransactionDateAndTime + ',' +
    MerchantReferenceNumber + ',' +
    AccountID;
end;

{ TTransactionOutput }

procedure TTransactionOutput.ParseOutput(OutputString: string);

  function NextToken(var TokenString: string): string;
  var
    CharPos: Integer;
  begin
    CharPos := Pos(',', TokenString);
    if (CharPos = 0) then
    begin
      Result := TokenString;
      TokenString := '';
    end
    else
    begin
      Result := Copy(TokenString, 1, CharPos - 1);
      TokenString := Trim(Copy(TokenString, CharPos + 1, Length(TokenString)));
    end;
  end;

begin
  FResult                  := NextToken(OutputString);
  FTerminateLoop           := NextToken(OutputString);
  FTransactionValue        := NextToken(OutputString);
  FCashBackValue           := NextToken(OutputString);
  FGratuityValue           := NextToken(OutputString);
  FPAN                     := NextToken(OutputString);
  FExpiryDate              := NextToken(OutputString);
  FIssueNumber             := NextToken(OutputString);
  FStart                   := NextToken(OutputString);
  FTransactionDateAndTime  := NextToken(OutputString);
  FMerchantNumber          := NextToken(OutputString);
  FTerminalID              := NextToken(OutputString);
  FSchemeName              := NextToken(OutputString);
  FFloorLimit              := NextToken(OutputString);
  FEFTSequenceNumber       := NextToken(OutputString);
  FAuthorisationCode       := NextToken(OutputString);
  FReferralTelephoneNumber := NextToken(OutputString);
  FAuthorisationMessage    := NextToken(OutputString);
end;

end.
