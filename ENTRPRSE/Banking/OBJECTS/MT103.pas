unit MT103;

interface

uses
  ExpObj, CustAbsU, Enterprise04_TLB;

type
  //Base object for HSBC MT103 files
  TMT103ExportObject = Class(TExportObject)
  protected
    Target : TAbsCustomer;
    TKTarget : IAccount;
    LEventData : TAbsEnterpriseSystem;
    FToolkit : IToolkit;
    procedure GetTargetViaToolkit;
    function GetTheirAccountNo : string; virtual; abstract;
    function GetOurAccountNo : string; virtual; abstract;
    function GetTheirBankAccountRef : string; virtual; abstract;
    procedure DoWriteValue(CurrCode : string);

    procedure WriteSendersRef;  //20
    procedure WriteOperationCode; virtual; //23B
    procedure WriteValue; virtual; abstract;//32A
    procedure WriteOurDetails; virtual; //50k
    procedure WriteTheirBank; virtual; abstract;//57a
    procedure WriteTheirDetails; virtual; //59a
    procedure WriteCharges; virtual; //71A
    procedure WriteReceiverInfo; virtual; abstract; //72B
    procedure WritePaymentRef;

  public
    function CreateOutFile(const AFileName : string;
                           const EventData :
                           TAbsEnterpriseSystem) : integer;  override;
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
    constructor Create;
    destructor Destroy; override;
  end;

  //HSBC MT103 Eurozone files
  TMT103EurozoneExportObject = Class(TMT103ExportObject)
  private
    function GetBIC : string;
  protected
    function GetOurAccountNo : string; override;
    function GetTheirAccountNo : string; override;
    function GetTheirBankAccountRef : string; override;
    procedure WriteValue; override;//32A
    procedure WriteReceiverInfo; override; //72B
    procedure WriteTheirBank; override;//57a
  public
    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

  //HSBC MT103 Priority payment files (UK)
  TMT103PriorityExportObject = Class(TMT103ExportObject)
  private
    function GetSortCode : string;
  protected
    function GetOurAccountNo : string; override;
    function GetTheirAccountNo : string; override;
    function GetTheirBankAccountRef : string; override;
    procedure WriteValue; override;//32A
    procedure WriteReceiverInfo; override; //72B
    procedure WriteTheirBank; override;//57a
  end;

implementation

uses
  SysUtils, StrUtils, CtkUtil04, ActiveX, IniFiles;

{ TMT103ExportObject }

constructor TMT103ExportObject.Create;
begin
  inherited Create;
  {$IFNDEF MULTIBACS}
  CoInitialize(nil);
  {$ENDIF}
  FToolkit := CreateToolkitWithBackdoor;
end;

function TMT103ExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
var
  Res : Integer;
begin
  //Create the file
  Result := inherited CreateOutFile(AFileName, EventData);

  //Open the toolkit
  FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
  Res := FToolkit.OpenToolkit;
  if Res <> 0 then
  begin
    Result := -1;
    raise Exception.Create('Unable to create COM Toolkit');
  end;
end;

destructor TMT103ExportObject.Destroy;
begin
  FToolkit := nil;
  inherited;
end;

procedure TMT103ExportObject.GetTargetViaToolkit;
var
  Res : Integer;
begin
  TKTarget := nil;
  with FToolkit.Supplier do
    Res := GetEqual(BuildCodeIndex(Target.acCode));

  if Res = 0 then
    TKTarget := FToolkit.Supplier;
end;

procedure TMT103ExportObject.WriteCharges;
begin
  WriteThisRec(':71A:SHA');
end;

procedure TMT103ExportObject.WriteOperationCode;
begin
  WriteThisRec(':23B:CRED');
end;

procedure TMT103ExportObject.WriteOurDetails;
var
  i : Integer;
begin
  WriteThisRec(GetOurAccountNo);
  WriteThisRec(Bacs_Safe(LEventData.Setup.ssUserName));
  for i := 1 to 3 do
    WriteThisRec(Bacs_Safe(LEventData.Setup.ssDetailAddr[i]));
end;

function TMT103ExportObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  Pence : longint;
begin
  Result := True;
  if Mode = wrPayLine then
  Try
    Result := True;

    Target := EventData.Supplier;
    GetTargetViaToolkit;

    //Take local reference to EventData
    LEventData := EventData;

    //Get info stored in odd places
    GetEventData(EventData);

    //Keep track of amount output
    Pence := Pennies(ProcControl.Amount);
    TotalPenceWritten := TotalPenceWritten + Pence;
    Inc(TransactionsWritten);

    //Write data to file
    WriteSendersRef;
    WriteOperationCode;
    WriteValue;
    WriteOurDetails;
    WriteTheirBank;
    WriteTheirDetails;
    WritePaymentRef;
    WriteCharges;
    WriteReceiverInfo;

  Except
    on E:Exception do
    begin
      Result := False;
      LogIt('Exception in WriteRec: ' + E.Message);
    end;
  End;
end;

procedure TMT103ExportObject.WritePaymentRef;
begin
  WriteThisRec(':70:PAYMENT ' + LEventData.Transaction.thOurRef);
end;

procedure TMT103ExportObject.WriteSendersRef;
begin
  //HV 11/01/2016, JIRA-15550, Issue related to configuration of HSBC MT03 BACS output - Tags 20 and 59 incorrect
  if GetTheirBankAccountRef <> '' then
    WriteThisRec(':20:' + LeftStr(Trim(GetTheirBankAccountRef),16))
  else
    WriteThisRec(':20:' + LEventData.Transaction.thOurRef + '-' + FormatDateTime('ddmmyy', Date));
end;

procedure TMT103ExportObject.WriteTheirDetails;
var
  i : Integer;
begin
  WriteThisRec(':59:/' + GetTheirAccountNo);
  //HV 11/01/2016, JIRA-15550, Issue related to configuration of HSBC MT03 BACS output - Tags 20 and 59 incorrect
  WriteThisRec(LeftStr(Bacs_Safe(Trim(Target.acCompany)),35));
  for i := 1 to 3 do
    WriteThisRec(LeftStr(Bacs_Safe(Trim(Target.acAddress[i])),35));
end;

procedure TMT103ExportObject.DoWriteValue(CurrCode: string);
var
  ValueS : string;
begin
  //Get payment value
  ValueS := Format('%15.2f', [ProcControl.Amount]);

  //use comma instead of decimal point
  ValueS[Length(ValueS) - 2] := ',';

  WriteThisRec(':32A:' + Copy(ProcControl.PDate, 3, 6) + CurrCode + Trim(ValueS));
end;

{ TMT103EurozoneExportObject }

function TMT103EurozoneExportObject.GetBIC: string;
begin
  if Assigned(TKTarget) then
    Result := TKTarget.acBankSort
  else
    Result := '';
end;

function TMT103EurozoneExportObject.GetOurAccountNo: string;
begin
  Result := ':50K:/' + UserBankSort + UserBankAcc;
end;

function TMT103EurozoneExportObject.GetTheirAccountNo: string;
begin
  if Assigned(TKTarget) then
    Result := TKTarget.acBankAcc //HV 11/01/2016, JIRA-15550, Issue related to configuration of HSBC MT03 BACS output - Tags 20 and 59 incorrect
  else
    Result := '';
end;

//HV 11/01/2016, JIRA-15550, Issue related to configuration of HSBC MT03 BACS output - Tags 20 and 59 incorrect
function TMT103EurozoneExportObject.GetTheirBankAccountRef: string;
begin
  if Assigned(TKTarget) then
    Result := TKTarget.acBankRef
  else
    Result := '';
end;

function TMT103EurozoneExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  TempStr : string;
  Target : TAbsCustomer;
begin
  Result := True;
  GetEventData(EventData);
  with EventData do
    Target := GetTarget(EventData);

  TempStr := Target.acBankSort;

  //BIC must be either 8 chars or 11 chars
  if (Length(TempStr) <> 8) and (Length(TempStr) <> 11) then
  begin
    LogIt(Target.acCompany + ': Invalid BIC - ' + TempStr);
    Result := False;
  end;
end;

procedure TMT103EurozoneExportObject.WriteReceiverInfo;
begin
  WriteThisRec(':72:/REC/EZONE');
end;

procedure TMT103EurozoneExportObject.WriteTheirBank;
begin
//For Eurozone must be BIC
  WriteThisRec(':57A:' + GetBIC);
end;

procedure TMT103EurozoneExportObject.WriteValue;
begin
  DoWriteValue('EUR');
end;

{ TMT103PriorityExportObject }

function TMT103PriorityExportObject.GetOurAccountNo: string;
begin
  Result := ':50K:/' + UserBankAcc;
end;

function TMT103PriorityExportObject.GetSortCode: string;
begin
  Result := Target.acBankSort;
end;

function TMT103PriorityExportObject.GetTheirAccountNo: string;
begin
  Result := Target.acBankAcc;
end;

//HV 11/01/2016, JIRA-15550, Issue related to configuration of HSBC MT03 BACS output - Tags 20 and 59 incorrect
function TMT103PriorityExportObject.GetTheirBankAccountRef: string;
begin
  Result := Target.acBankRef;
end;

procedure TMT103PriorityExportObject.WriteReceiverInfo;
begin
  WriteThisRec(':72:/REC/LCC-GB');
end;

procedure TMT103PriorityExportObject.WriteTheirBank;
begin
  WriteThisRec(':57C://SC' + GetSortCode);
end;

procedure TMT103PriorityExportObject.WriteValue;
begin
  DoWriteValue('GBP');
end;

end.

