unit RaboOBJ;

{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  ExpObj, CustAbsU;

type

  TRaboBankExportObject = Class(TExportObject)
  protected  //PR: 05/01/2012 Changed from private to allow a descendant to use TotalAccountNos
     SenderID : string;
     FileID : string;
     FBatchNo : Integer;
     BatchSerial : string;
     NAP : string;
     TotalAccountNos : Int64;
     FInitiatorName : string;
     FOurAccountNo : Int64;
     function TotalAmountString : string;
     function TotalAccountNosString : string;
     function OurAccountNoString : string;
     function InitiatorName(const EventData : TAbsEnterpriseSystem) : string;
     function WriteHeader(const EventData : TAbsEnterpriseSystem) : Integer;
     function WriteTrailer : Integer;
     function ProcessDate(const ADate : string) : string;
     function TransType : string;
     function TransGroup : string;
     function NextBatchNo : string;
     function GetUserBankAccount(const EventData: TAbsEnterpriseSystem) : Int64;
     procedure ReadIniFile(const EventData : TAbsEnterpriseSystem);
  public
     function CreateOutFile(const AFileName : string;
                            const EventData :
                                TAbsEnterpriseSystem) : integer; override;
     function CloseOutFile : integer; override;

     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
     function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean;
                                      override;
     function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
  end;

implementation

uses
  SysUtils, {$IFDEF MULTIBACS}Multini,{$ENDIF} IniFiles, Enterprise04_TLB, CtkUtil04, ActiveX, DateUtils;

function TRaboBankExportObject.CloseOutFile: integer;
begin
  WriteTrailer;
  Result := Inherited CloseOutFile;
end;

function TRaboBankExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  TotalAccountNos := 0;
  NAP := '1';
  FileId := FormatDateTime('dd', Date) + NextBatchNo;
  BatchSerial := '0001';


  Result := inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
    Result := WriteHeader(EventData);

end;

function TRaboBankExportObject.GetUserBankAccount(const EventData: TAbsEnterpriseSystem): Int64;
var
  oToolkit : IToolkit;
  Res : Integer;
begin
  Try
  {$IFDEF MULTIBACS}
   if Length(Trim(UserBankAcc)) > 10 then
     Result := -1
   else 
     Result := StrToInt64(UserBankAcc);
  {$ELSE}
  //PR: 22/03/2011 Wasn't calling CoInitialize
   CoInitialize(nil);
   oToolkit := CreateToolkitWithBackdoor;
   Try
     oToolkit.Configuration.DataDirectory :=  EventData.Setup.ssDataPath;
     Res := oToolkit.OpenToolkit;
     if Res = 0 then
     begin
       if Length(oToolkit.SystemSetup.ssBankAccountNo) > 10 then
         Result := -1
       else
         Result := StrToInt64(oToolkit.SystemSetup.ssBankAccountNo);
     end
     else
       Result := -1;
   Finally
     oToolkit.CloseToolkit;
     oToolkit := nil;
   End;
  {$ENDIF}
  Except
    Result := -1;
  End;
end;

function TRaboBankExportObject.InitiatorName(
  const EventData: TAbsEnterpriseSystem): string;
begin
  Result := LJVar(FInitiatorName, 35);
end;

function TRaboBankExportObject.NextBatchNo: string;
begin
  Result := ZerosAtFront(FBatchNo, 2);
end;

function TRaboBankExportObject.OurAccountNoString: string;
begin
  Result := ZerosAtFront(FOurAccountNo, 10);
end;

function TRaboBankExportObject.ProcessDate(const ADate: string): string;
begin
//PR: 23/06/2011 Always show date - according to Amanda, Rabobank rejected file without date.
//If Date is less than 5 days ago, it will be processed immediately, so any previous date can
//be treated as today.
  //YYYYMMDD -> DDMMYY
  if ADate >= FormatDateTime('yyyymmdd', Date) then
    Result := DDMMYY(ADate)
  else
    Result := FormatDateTime('ddmmyy', Date);
end;

procedure TRaboBankExportObject.ReadIniFile(
  const EventData: TAbsEnterpriseSystem);
var
  LRequiredPath : string;
  sToday : string;
  sBatchNo : string;
begin
  LRequiredPath := CheckPath(EventData.Setup.ssDataPath);
  with TIniFile.Create(LRequiredPath + 'RaboBank.ini') do
  Try
    {$IFDEF MULTIBACS}
    SenderId := UserID;
    if Trim(SenderId) = '' then
    {$ENDIF}
      SenderID := ReadString('Settings', 'UserId', Copy(EventData.Setup.ssUserName, 1, 5));

    SenderId := LJVar(SenderID, 5);
{The FileId field consists of ddnn where dd is the day of the month from creation date, and nn is a unique number for the month.
To acheive this, we store the last FileId + 1 in the ini file. If dd is not the same as the current day of the month then we start
again at dd01, otherwise we use the loaded value and write an incremented value back to the ini file.}

    sToday := FormatDateTime('dd', Date);
    sBatchNo := ReadString('Settings', 'BatchNo', sToday + '01');

    if Copy(sBatchNo, 1, 2) = sToday then
      sBatchNo := Copy(sBatchNo, 3, 2)
    else
      sBatchNo := '01';

    FBatchNo := StrToInt(sBatchNo);

    WriteString('Settings', 'BatchNo', sToday + ZerosAtFront(FBatchNo + 1, 2));
  Finally
    Free;
  End;

end;

function TRaboBankExportObject.TotalAccountNosString: string;
var
  Len : Integer;
begin
  Result := ZerosAtFront(TotalAccountNos, 10);
  Len := Length(Result);
  if Len > 10 then
    Result := Copy(Result, Len - 9, Len)
end;

function TRaboBankExportObject.TotalAmountString: string;
begin
  Result := ZerosAtFront(TotalPenceWritten, 18);
end;

function TRaboBankExportObject.TransGroup: string;
begin
  if IsReceipt then
    Result := '10'
  else
    Result := '00';
end;

function TRaboBankExportObject.TransType: string;
begin
  if IsReceipt then
    Result := '1001'
  else
    Result := '0005';
end;

function TRaboBankExportObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;
end;

function TRaboBankExportObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  ReadIniFile(EventData);
  FInitiatorName := EventData.Setup.ssUserName;
  FOurAccountNo := GetUserBankAccount(EventData);

  if (Trim(SenderId) = '') or (Length(SenderId) > 5) then
    Failed := flUserId
  else
  if FOurAccountNo = -1 then
    Failed := flBank;

  Result := Failed = 0;
end;

function TRaboBankExportObject.WriteHeader(
  const EventData: TAbsEnterpriseSystem): Integer;
var
  OutString : string;
  bRes : Boolean;
begin
  GetEventData(EventData);

  //Write File Header
  OutString := '0001A' + FormatDateTime('ddmmyy', Date) +
               'CLIEOP03' + SenderId + FileId + '1' + StringOfChar(' ', 21);
  bRes := WriteThisRec(OutString);

  //Write Batch Header
  OutString := '0010B' + TransGroup + OurAccountNoString + BatchSerial + 'EUR' + StringOfChar(' ', 26);
  bRes := WriteThisRec(OutString);

  //Write Initiator
  OutString := '0030B' + NAP +  ProcessDate(ProcControl.PDate) + InitiatorName(EventData) + 'P  ';
  bRes := WriteThisRec(OutString);
end;

function TRaboBankExportObject.WriteRec(const EventData : TAbsEnterpriseSystem;
                                         Mode : word) : Boolean;

var
  OutString : string;
  Target : TAbsCustomer;
  Amount : longint;
  AccNo : Int64;
begin
  //Write Transaction
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    GetEventData(EventData);
    with EventData do
    begin

      if IsReceipt then
        Target := Customer
      else
        Target := Supplier;

      AccNo := StrToInt64(Target.acBankAcc);
      Amount := Pennies(Transaction.thTotalInvoiced);

      TotalPenceWritten := TotalPenceWritten + Amount;
      TotalAccountNos := TotalAccountNos + AccNo + FOurAccountNo;
      inc(TransactionsWritten);

      if IsReceipt then
        OutString := '0100A' + TransType + ZerosAtFront(Amount, 12) +
                     ZerosAtFront(AccNo, 10) + OurAccountNoString + StringOfChar(' ', 9)
      else
        OutString := '0100A' + TransType + ZerosAtFront(Amount, 12) +
                     OurAccountNoString + ZerosAtFront(AccNo, 10) + StringOfChar(' ', 9);

      Result := WriteThisRec(OutString);

      if Result then
      begin
        OutString := '0150A' + LJVar(EventData.Transaction.thOurRef, 45);
        Result := WriteThisRec(OutString);
      end;

      if Result and not IsReceipt then
      begin
        OutString := '0170B' + LJVar(Target.acCompany, 35) + StringOfChar(' ', 10);
        Result := WriteThisRec(OutString);
      end;
    end; {with EventData}
  end; {if mode = wrpayline}
end;



function TRaboBankExportObject.WriteTrailer : Integer;
var
  OutString : string;
  bRes : Boolean;
begin
  //Write Batch Close
  OutString := '9990A' + TotalAmountString + TotalAccountNosString +
               ZerosAtFront(TransactionsWritten, 7) + StringOfChar(' ', 10);
  bRes := WriteThisRec(OutString);

  //Write File Close
  OutString := '9999A' + StringOfChar(' ', 45);
  bRes := WriteThisRec(OutString);
end;

end.
