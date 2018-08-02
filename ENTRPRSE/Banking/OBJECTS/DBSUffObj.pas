unit DBSUffObj;

interface

uses
  ExpObj, CustAbsU, Enterprise04_TLB, ActiveX;

type

  //Record to store OurRefs and YourRefs from matching PINs
  //PR: 09/11/2016 Changed OurRefs & YourRefs to AnsiString as was being truncated where a lot of PINs;
  TMatchingRefs = Record
    OurRefs  : Ansistring;
    YourRefs : Ansistring;
  end;

  TDBSUFFObject = Class(TExportObject)
    protected
      FUserId : string;
      IdealIniFile   : String;
//      FBatchID : String; PR: 25/07/2016 Removed at DR's request
      FToolkit : IToolkit;
      FPaymentType : string;
      function GetBatchId : string;
      function WriteHeader(const EventData : TAbsEnterpriseSystem) : Boolean;
      function WriteTrailer : Boolean;
      function BACS_Safe(TStr  :  Str255)  :  Str255; override;
      function GetUniqueFilename(const AFileName : string) : string;
      function GetMatching(const PPYRef : string; const DeliveryCode : string) : TMatchingRefs;
    public
      function CreateOutFile(const AFileName : string;
                            const EventData :
                             TAbsEnterpriseSystem) : integer; override;
      function WriteRec(const EventData : TAbsEnterpriseSystem;
                            Mode : word) : Boolean; override;
      function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;
      procedure Initialize; override;
    end;


implementation

uses
  SysUtils, IniFiles, MultIni, CtkUtil04;

{ TDBSUFFObject }

const
  IniFileName = 'DBSUff.ini';

function TDBSUFFObject.BACS_Safe(TStr: Str255): Str255;
begin
  Result := TStr;
  if Pos(',', Result) > 0 then
    Result := DQuotedStr(Result);
end;

function TDBSUFFObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin

  if FUserId = '' then
  begin
    ShowExportMessage('Error','Invalid Organization ID','Run aborted');
    Result := -1;
    Failed := flUserID;
  end
  else
    Result := 0;

  if Result = 0 then
    Result := inherited CreateOutFile(GetUniqueFilename(AFileName), EventData);

  if Result = 0 then
  begin
    if WriteHeader(EventData) then
      Result := 0
    else
      Result := -1;
  end;
end;

function TDBSUFFObject.GetBatchId: string;
begin
//  Result := FBatchId;  //Changed to use value loaded from ini file
  Result := ''; //PR: 25/07/2016 Changed again at DR's request
end;

//Find matching PINs for currenct PPY
function TDBSUFFObject.GetMatching(const PPYRef : string; const DeliveryCode : string): TMatchingRefs;
var
  Res, Res1 : Integer;
  oTrans : ITransaction;

  //Remove last '/' from string
  procedure RemoveLastChar(var AString : AnsiString);
  var
    i : integer;
  begin
    i := Length(AString);
    if (i > 0) and (AString[i] = '/') then
      Delete(AString, i, 1);
  end;

  //Truncate OurRefs string to 140 chars
  procedure TrimOurRefs(var AString : Ansistring);
  const
    MAX_OUR_REFS_LEN = 140;
  begin
    if Length(AString) > MAX_OUR_REFS_LEN then
      AString := Copy(AString, 1, MAX_OUR_REFS_LEN);
  end;

  //Truncate YourRefs string to 70,000 chars
  procedure TrimYourRefs(var AString : Ansistring);
  const
    MAX_YOUR_REFS_LEN = 70000;
  begin
    if Length(AString) > MAX_YOUR_REFS_LEN then
      AString := Copy(AString, 1, MAX_YOUR_REFS_LEN);
  end;


begin
  Result.OurRefs := '';
  Result.YourRefs := '';
  with FToolkit.Transaction do
  begin
    //Find PPY in COM Toolkit
    Index := thIdxOurRef;
    Res := GetEqual(BuildOurRefIndex(PPYRef));

    if Res = 0 then
    begin
      //Run through matching
      with thMatching as IMatching2 do
      begin
        maSearchType := maSearchTypeFinancial;
        Res := GetFirst;

        while Res = 0 do
        begin
          Result.OurRefs := Result.OurRefs + maDocRef + '/';

          //Only want yourRefs (D64) if remittances sent by email
          if DeliveryCode = 'E' then
            Result.YourRefs := Result.YourRefs + Trim(maDocYourRef) + '/';

          Res := GetNext;
        end; //while Res = 0

        //Remove final '/' character
        RemoveLastChar(Result.OurRefs);
        RemoveLastChar(Result.YourRefs);

        //Ensure length of OurRefs string is <= 140
        TrimOurRefs(Result.OurRefs);
      end; //with thMatching
    end; //if Res = 0
  end;
end;

function TDBSUFFObject.GetUniqueFilename(const AFileName : string): string;
var
  i : integer;
  Ext : string;
  Stem : string;
begin
  Result := AFilename;

  for i := Length(Result) downto 1 do
  begin
    if Result[i] = '.' then
    begin
      Ext := Copy(Result, i, Length(Result));
      Delete(Result, i, Length(Result));
      Stem := Result;
      Break;
    end;
  end;

  i := 1;
  while FileExists(Stem + Ext) do
  begin
    inc(i);
    Stem := Result + IntTostr(i);
  end;

  Result := Stem + Ext;
end;

procedure TDBSUFFObject.Initialize;
var
  TheIni : TIniFile;
  i : Integer;
  Res : Integer;
begin
  inherited;
  TheIni := TIniFile.Create(DataPath + IniFileName);
  Try
    FPaymentType := TheIni.ReadString('Settings', 'PaymentType', 'LVT');
  {$IFNDEF MULTIBACS}
    FUserId := TheIni.ReadString('Settings', 'OrgId', '');
  {$ELSE}
    FUserID := UserID;
  {$ENDIF}
  Finally
    TheIni.Free;
  end;

  CoInitialize(nil);
  FToolkit := CreateToolkitWithBackdoor;
  if Assigned(FToolkit) then
  begin
    FToolkit.Configuration.DataDirectory := DataPath;
    Res := FToolkit.OpenToolkit;
    if Res <> 0 then
    begin
      ShowExportMessage('Error', 'Unable to open the COM Toolkit. Error ' + IntTosTr(Res), 'Run Aborted.');
    end;
  end;
end;

function TDBSUFFObject.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  Result := True;
end;

function TDBSUFFObject.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
begin
  if (FPaymentType = 'LVT') or (FPaymentType = 'BPY') then
    Result := True
  else
  begin
    Result := False;
    ShowExportMessage('Error', 'Invalid payment type (' + FPaymentType + '). Must be LVT or BPY', 'Run aborted');
  end;
end;

function TDBSUFFObject.WriteHeader(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := WriteThisRec('HEADER' + ',' +
                          FormatDateTime('ddmmyyyy', Date) + ',' +
                          FUserId + ',' +
                          Bacs_Safe(Copy(EventData.Setup.ssUserName, 1, 35)));

end;

function TDBSUFFObject.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutString, Reference : AnsiString;
  Pence : longint;
  Target : TAbsCustomer;
  DeliveryCode : string;
  EmailAddress : string;
  Matching     : TMatchingRefs;
begin
  if Mode = wrPayline then
  begin
    GetEventData(EventData);
    Pence := Pennies(ProcControl.Amount);

    Target := GetTarget(EventData);
    with EventData do
    begin
      //Check remittance delivery - 2 & 4 are email
      if TAbsCustomer2(Target).acStateDeliveryMode in [2, 4] then
      begin
        EmailAddress := Trim(Target.acEmailAddr);
        DeliveryCode := 'E';
      end
      else
      begin
        DeliveryCode := '';
        EmailAddress := '';
      end;
      //Reference string
{      if not IsBlank(Bacs_Safe(Target.acBankRef)) then
        Reference := Bacs_Safe(Copy(Target.acBankRef, 1, 35))
      else}
        Reference := Target.acCode + '/' + Transaction.thOurRef;

      Matching := GetMatching(Transaction.thOurRef, DeliveryCode);

      OutString := 'PAYMENT,' + FPaymentType + ',' + UserBankAcc + ',' +
                ProcControl.PayCurr + ',' +
                Bacs_Safe(Copy(Target.acBankRef, 1, 35)) + ',' +
                ProcControl.PayCurr + ',' +
                GetBatchId + ',' +
                DDMMYYYY(ProcControl.PDate) + ',,' +
                UserBankAcc + ',' +
                BACS_Safe(Copy(Target.acCompany, 1, 35)) + ',,,,,' +
                TAbsCustomer4(Target).acBankAccountCode + ',,,,,' +
                TAbsCustomer4(Target).acBankSortCode + ',,,,,,0,' +
                Pounds(Pence) + ',,,,,' +
                '20,' + Reference + ',,' +
                Matching.OurRefs + ',,,,,,,' +
                'IVPT,,' +
                DeliveryCode + ',,,,,,,,,' +
                EmailAddress + ',,,,,,,,,,' +
                Matching.YourRefs + ',,,,';

    end; //with EventData

    TotalPenceWritten := TotalPenceWritten + Pence;
    inc(TransactionsWritten);

    Result := WriteThisRec(OutString);
  end  //Mode = wrPayline
  else
    Result := WriteTrailer; //no contra
end;

function TDBSUFFObject.WriteTrailer: Boolean;
begin
  Result := WriteThisRec('TRAILER' + ',' +
                          IntToStr(TransactionsWritten) + ',' +
                          Pounds(TotalPenceWritten));
end;

end.
