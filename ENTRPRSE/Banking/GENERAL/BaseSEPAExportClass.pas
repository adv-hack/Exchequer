unit BaseSEPAExportClass;

interface

uses
  ExpObj, CustAbsU, Classes, BaseSEPAXMLClass, XmlConst;

type

  //Class to store a list of TPaymentData records
  TPaymentDataList = Class
  private
    FSum : Double;
    FList : TList;
    function GetCount: Integer;
  protected
    function GetItem(Index : Integer) : PPaymentData;
    procedure SetItem(Index: Integer; pData: PPaymentData);
  public
    constructor Create;
    destructor Destroy; override;
    function Add(pData: PPaymentData) : Integer;
    property Sum : Double read FSum;
    property Items[Index: Integer]: PPaymentData read GetItem write SetItem; default;
    property Count : Integer read GetCount;
  end;


  TBaseSEPAExportClass = Class(TExportObject)
  protected
    FSumOfTransactions : Double;
    FDDList : Array[ddNA..ddOneOff] of TPaymentDataList;
    FXML : TBaseSEPAXMLClass;
    FIniFileName : string;
    FCompanyBIC : string;
    FCompanyIBAN : string;
    function ReadIniFile : boolean; virtual;
    function DDSequence(DDMode : Byte) : TDirectDebitSequence; virtual;
    function SepaSafe(const Value : string) : string; virtual;
    function RemoveSpaces(const Value : string) : string;
    function FormatSEPADate(const ExDate : string) : string; virtual;
    function ValidateBIC(const BIC : string) : Boolean; virtual;
    function ValidateIBAN(const IBAN : string) : Boolean; virtual;
    function ValidMandateDate(const ADate : string) : Boolean; virtual;
    function ReplaceWithSEPAChar(cFrom : Char) : Char; virtual;
    procedure CreateXMLHelper; virtual;
    procedure InitialiseXMLHelper(const EventData : TAbsEnterpriseSystem); virtual;
    function FillAddress(PD : PPaymentData; Target : TAbsCustomer4) : Boolean; virtual;
  public
    function CreateOutFile(const AFileName : string;
                            const EventData :
                            TAbsEnterpriseSystem) : integer; override;
    function CloseOutFile : integer; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                      Mode : word) : Boolean; override;

    property IniFilename : string read FIniFilename write FIniFilename;
    property CompanyBIC : string read FCompanyBIC;
    property CompanyIBAN : string read FCompanyIBAN;

  end;

implementation

uses
  SysUtils, SEPADebitClass, SEPACreditClass, IniFiles, MultIni;

{ TBaseSEPAExportClass }

//This is where the xml gets put together and written
function TBaseSEPAExportClass.CloseOutFile: integer;
var
  i : TDirectDebitSequence;
  iTrans : Integer;
  lValue : Double;
begin
  if Failed = 0 then
  with FXML do
  begin
    {SS:20/09/2016:ABSEXCH-15056:Total on pop up information window is out by 1c on Batch Receipts. See attached document for steps to recreate.
    :Using an expression as parameter in the trunk, results in the bug for some values.}
    lValue := Round(FSumOfTransactions * 100);
    TotalPenceWritten := Trunc(lValue);
    WriteXMLDocumentHeader;
    WriteXMLGroupHeader(TransactionsWritten, FSumOfTransactions);

    //Read all lists and write payment info + payments
    for i := ddNA to ddOneOff do
    begin
      if FDDList[i].Count > 0 then
      begin
        WriteXMLPaymentInfo(i, FDDList[i].Count, FDDList[i].Sum);

        for iTrans := 0 to FDDList[i].Count - 1 do
          WriteXMLPayment(FDDList[i].Items[iTrans]^);

        CloseTag; //Payment info
      end;
    end;
  end;

  if FXML.WriteXML(OutFileName) then
    Result := 0
  else
  begin
    Result := -1;
    Failed := flFile;
  end;

  //Release resources
  FreeAndNil(FXML);
  for i := ddNA to ddOneOff do
    FreeAndNil(FDDList[i]);
end;

function TBaseSEPAExportClass.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  VAOPath : string;
  LRequiredPath : String;
  i : TDirectDebitSequence;
begin
  Result := 0;

  FSumOfTransactions := 0;
  GetEventData(EventData);
  IsReceipt := ProcControl.SalesPurch;

  //Create appropriate xml object
  CreateXMLHelper;

  if not ReadIniFile then
  begin
    Failed := flUserID;
    Result := -1;
    ShowExportMessage('Error','Invalid User ID','Run aborted');
    Exit;
  end;


  //Set properties on xml object
  InitialiseXMLHelper(EventData);

  LRequiredPath := CheckPath(EventData.Setup.ssDataPath);
  with TIniFile.Create(LRequiredPath + VAOIniFilename) do
  Try
    VAOPath := CheckPath(ReadString('Paths','Output',''));
  Finally
    Free;
  End;
  OutFileName := AFilename;
  if VAOPath <> '' then
    OutFileName := VAOPath + ExtractFilename(OutFilename);

  for i := ddNA to ddOneOff do
    FDDList[i] := TPaymentDataList.Create;

end;

procedure TBaseSEPAExportClass.CreateXMLHelper;
begin
  if IsReceipt then
    FXML := TSEPADebitClass.Create
  else
    FXML := TSEPACreditClass.Create;
end;

//Converts from direct debit mode on customer record to TDirectDebitSequence
function TBaseSEPAExportClass.DDSequence(DDMode: Byte): TDirectDebitSequence;
begin
  if not IsReceipt then
    Result := ddNA
  else
  Case DDMode of
     0  : Result := ddFirst;
     1  : Result := ddRecurring;
     2  : raise Exception.Create('Invalid Direct Debit Mode');
     3  : Result := ddFinal;
     4  : Result := ddOneOff;
     else
       Result := ddNA;
  end;
end;

//Convert Exchequer date (YYYYMMDD) to SEPA date (YYYY-MM-DD)
function TBaseSEPAExportClass.FillAddress(PD: PPaymentData; Target : TAbsCustomer4) : Boolean;
begin
  Result := True;
end;

function TBaseSEPAExportClass.FormatSEPADate(const ExDate: string): string;
begin
  Result := ExDate;
  Insert('-', Result, 7);
  Insert('-', Result, 5);
end;

procedure TBaseSEPAExportClass.InitialiseXMLHelper(const EventData : TAbsEnterpriseSystem);
begin
  FXML.CompanyName := SepaSafe(EventData.Setup.ssUserName);
  FXML.CompanyBIC := FCompanyBIC;
  FXML.CompanyIBAN := FCompanyIBAN;
  FXML.ExecutionDate := FormatSEPADate(ProcControl.PDate);

  //Message ID should be a unique identifier for the file
  FXML.MessageID := FormatDateTime('yyyymmddhhnnss', Now) + '-' + IntToStr(ProcControl.PayRun);
  FXML.SetPaymentInfoID;
end;

function TBaseSEPAExportClass.ReadIniFile: boolean;
var
  TheIni : TIniFile;
begin
{$IFNDEF MULTIBACS}
  if FIniFilename <> '' then
  begin
    TheIni := TIniFile.Create(DataPath + FIniFilename);
    Try
      if IsReceipt then
        FXML.OriginatorID := TheIni.ReadString('EFT','RecUserID','')
      else
        FXML.OriginatorID := TheIni.ReadString('EFT','UserID','');
    Finally
      TheIni.Free;
    End;
  end;
{$ELSE}
  if IsReceipt then
    FXML.OriginatorID := UserRecID
  else
    FXML.OriginatorID := UserID;
{$ENDIF}
  Result := FXML.OriginatorID <> '';
end;

function TBaseSEPAExportClass.RemoveSpaces(const Value: string): string;
var
  i : integer;
begin
  Result := Value;
  i := 1;

  while (i <= Length(Result)) do
  begin
    if Result[i] = ' ' then
      Delete(Result, i, 1)
    else
      inc(i);
  end;
end;

function TBaseSEPAExportClass.ReplaceWithSEPAChar(cFrom: Char): Char;
begin
begin
  Case cFrom of
    '&' : Result := '+';
    else
      Result := ' ';
  end;
end;
end;

function TBaseSEPAExportClass.SepaSafe(const Value: string): string;
{Allowable characters in SEPA are:
a b c d e f g h i j k l m n o p q r s t u v w x y z
A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
0 1 2 3 4 5 6 7 8 9
/ – ? : ( ) . , ‘ +
Space

Some banks allow xml escaped chars e.g. &Amp; However as not all do, we will not use as default.
We will replace '&' with '+'.

/ – ? : ( ) . , ‘ + cannot be the first or last char in a string

}
const
  AlphaNumericChars = ['a'..'z', 'A'..'Z', '0'..'9', ' '];
  RestrictedChars  = ['/','-','?',':','(',')','.',',',#145 {Single quote}, '+'];
  SEPAChars = AlphaNumericChars + RestrictedChars;
var
  i : integer;
begin
  Result := Value;
  for i := 1 to Length(Result) do
  begin
    if not (Result[i] in SEPAChars) then
      Result[i] := ReplaceWithSEPAChar(Result[i]);

    //Check that first and last char are not restricted chars
    if (i = 1) or (i = Length(Result)) then
      if Result[i] in RestrictedChars then
        Result[i] := ' ';
  end;
end;

function TBaseSEPAExportClass.ValidateBIC(const BIC: string) : Boolean;
begin
  //BIC must be either 8 or 11 chars
  Result := Length(BIC) in [8, 11];
end;

function TBaseSEPAExportClass.ValidateIBAN(const IBAN: string): Boolean;
begin
  //We don't know valid lengths for IBAN - just ensure that it is populated.
  Result := Trim(IBAN) <> '';
end;

function TBaseSEPAExportClass.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  Target : TAbsCustomer4;
begin
  Result := True;

  //Do we want customer or supplier?
  if IsReceipt then
    Target := TAbsCustomer4(EventData.Customer)
  else
    Target := TAbsCustomer4(EventData.Supplier);

  if not ValidateBIC(Target.acBankSortCode) then
  begin
    LogIt(Trim(Target.acCompany) + ': Invalid BIC');
    Result := False;
    Failed := flBank;
  end;

  If not ValidateIBAN(Target.acBankAccountCode) then
  begin
    LogIt(Trim(Target.acCompany) + ': No IBAN supplied');
    Result := False;
    Failed := flBank;
  end;

  if IsReceipt then //Validate Direct Debit fields
  begin
    if (Target.acDirDebMode = 2) then
    begin
      LogIt(Trim(Target.acCompany) + ': Re-presentation mode is not valid for SEPA; direct debit mode ' +
                                     'for re-presented requests should be the same as for the requests that failed.');
      Result := False;
      Failed := flDDMode;
    end
    else
    if Trim(Target.acMandateID) = '' then
    begin
      LogIt(Trim(Target.acCompany) + ': Invalid Direct Debit Mandate ID.');
      Result := False;
      Failed := flDDMandate;
    end
    else
    if not ValidMandateDate(Target.acMandateDate) then
    begin
      LogIt(Trim(Target.acCompany) + ': Invalid Direct Debit Mandate Date.');
      Result := False;
      Failed := flDDMandateDate;
    end;
  end;  //IsReceipt

end;

function TBaseSEPAExportClass.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;

  {$IFDEF MULTIBACS}
  FCompanyBIC := UserBankSort;
  FCompanyIBAN := UserBankAcc;
  {$ELSE}
  FCompanyBIC := TAbsSetup10(EventData.Setup).ssBankSortCode;
  FCompanyIBAN := TAbsSetup10(EventData.Setup).ssBankAccountCode;
  {$ENDIF}

  if not ValidateBIC(FCompanyBIC) then
  begin
    LogIt('Invalid System BIC');
    Result := False;
  end;

  If not ValidateIBAN(FCompanyIBAN) then
  begin
    LogIt('No System IBAN supplied');
    Result := False;
  end;

  if not Result then
    Failed := flBank;

end;

//Create a Payment Data record and add it to the appropriate list
function TBaseSEPAExportClass.ValidMandateDate(
  const ADate: string): Boolean;
var
  dtDate : TDateTime;
begin
  //SS:20/09/2016:ABSEXCH-15056:Remove warnings.
  Result := False;
  Try
    Result := TryEncodeDate(StrToInt(Copy(ADate, 1, 4)),
                            StrToInt(Copy(ADate, 5, 2)),
                            StrToInt(Copy(ADate, 7, 2)),
                            dtDate);
    if Result then
      Result := dtDate <= Date;
  Except
  End;
end;

function TBaseSEPAExportClass.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  PData : PPaymentData;
  Target : TAbsCustomer4;
begin
  Result := True;

  if Mode = wrPayline then
  begin
    //Get EL's hidden data
    GetEventData(EventData);

    //Do we want customer or supplier?
    if IsReceipt then
      Target := TAbsCustomer4(EventData.Customer)
    else
      Target := TAbsCustomer4(EventData.Supplier);

    New(PData);
    FillChar(PData^, SizeOf(PData^), 0);

    //Set universal fields
    PData.Amount     := ProcControl.Amount;
    PData.PayCcy     := ProcControl.PayCurr;      
    PData.BIC        := Target.acBankSortCode;
    PData.IBAN       := Target.acBankAccountCode;
    PData.Name       := SepaSafe(Trim(Target.acCompany));                               
    //HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)
    PData.PaymentRef := Copy(SEPASafe(Trim(EventData.Transaction.thOurRef)), 1, 35);

    //Set address fields - implemented by descendants which require address
    FillAddress(PData, Target);

    //PR: 14/11/2013 No longer use customer/supplier reference field as EndToEndId needs to be unique for Danske bank
    //PR: 23/07/2014 ABSEXGENERIC-357 Use cust/supp ref field + OurRef if ref populated, else use CompanyName + OurRef
    if PData.Ref = EmptyStr then
    begin
      if (Trim(Target.acBankRef) <> '') then
        PData.Ref := Copy(SEPASafe(Trim(Target.acBankRef)), 1, 25) + ' ' + EventData.Transaction.thOurRef
      else
        PData.Ref := Copy(SEPASafe(Trim(EventData.Setup.ssUserName)), 1, 25) + ' ' + EventData.Transaction.thOurRef;
    end;


    //If receipt then we need D/D mandate details
    if IsReceipt then
    begin
      PData.MandateID   := Target.acMandateID;
      PData.MandateDate := FormatSEPADate(Target.acMandateDate);
    end;

    //Add to list
    FDDList[DDSequence(Target.acDirDebMode)].Add(PData);

    //Update counts
    TransactionsWritten := TransactionsWritten + 1;
    FSumOfTransactions := FSumOfTransactions + ProcControl.Amount;
  end;
end;

{ TPaymentDataList }

function TPaymentDataList.Add(pData: PPaymentData): Integer;
begin
  //SS:20/09/2016:ABSEXCH-15056:Remove warnings.
  Result := 0;
  FSum := FSum + pData.Amount;

  FList.Add(pData);
end;

constructor TPaymentDataList.Create;
begin
  inherited;
  FList := TList.Create;
  FSum := 0;
end;

destructor TPaymentDataList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

function TPaymentDataList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TPaymentDataList.GetItem(Index: Integer): PPaymentData;
begin
  Result := PPaymentData(FList[Index]);
end;

procedure TPaymentDataList.SetItem(Index: Integer; pData: PPaymentData);
begin
  FList[Index] := pData;
end;


end.
