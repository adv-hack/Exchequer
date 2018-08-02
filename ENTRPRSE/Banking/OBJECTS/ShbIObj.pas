unit ShbIObj;

interface

uses
  ExpObj, CustAbsU, Classes, {$IFDEF EX600}CTKUtil04, Enterprise04_TLB{$ELSE}CTKUtil, Enterprise01_TLB{$ENDIF},
   ComObj,  ShbBObj;

type
  TSHBIntExporter = Class(TShbBacsExporter)
    FToolkit : IToolkit;
    FAcCode : string;
    FPayDetails : Array[1..4] of string;
    FDefChargeCode : string;
    constructor Create(const EventData: TAbsEnterpriseSystem);
    destructor Destroy; override;
    function ClientID : string;
    function OurACNo : string;
    function CurrencyCode(Currency : Integer) : string;
    function CheckCharge(const s : string) : Boolean;
    function ChargesCode(const Target : TAbsCustomer) : string;
    function OurNameAndAddress(const EventData : TAbsEnterpriseSystem) : string;
    function SupplierPostCode(const Target : TAbsCustomer) : string;
    function SupplierNameAndAddress(const Target : TAbsCustomer) : string;
    function SupplierBankDetails(const Target : TAbsCustomer) : string;
    function PaymentDetails(const EventData : TAbsEnterpriseSystem) : string;
    function SpecialInstructions(const Target : TAbsCustomer) : string;
    function ProcessNarrative(const s, OurRef : string; RunNo : longint) : string;

    function ValidateRec(const EventData : TAbsEnterpriseSystem) : Boolean; override;
    function WriteRec(const EventData : TAbsEnterpriseSystem; Mode : word) : Boolean; override;
    function ValidateSystem(const EventData : TAbsEnterpriseSystem) : Boolean; override;

  end;

implementation

uses
  SysUtils, IniFiles, Dialogs, Controls, MultIni;

{ TSHBIntExporter }
const
  MessageType = 'PMT '; //Includes message priority field - 1 space



function TSHBIntExporter.ChargesCode(
  const Target : TAbsCustomer): string;
var
  s : string;
begin
  s := Target.acUserDef1;
  if not CheckCharge(s) then
    s := UpperCase(Trim(FDefChargeCode));

  Result := StringOfChar(' ', 38) +
            LJVar(s, 3) +
            StringOfChar(' ', 12);
end;

constructor TSHBIntExporter.Create(const EventData: TAbsEnterpriseSystem);
var
  Res : Integer;
begin
  inherited Create;
  FToolkit := CreateToolkitWithBackdoor;
  FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
  Res := FToolkit.OpenToolkit;
  if Res <> 0 then
   ShowMessage('Error opening COM Toolkit:'#13#13 +
               QuotedStr(FToolkit.LastErrorString));

end;

function TSHBIntExporter.CurrencyCode(Currency: Integer): string;
begin
  Result := LJVar(FToolkit.SystemSetup.ssCurrency[Currency].scPrintSymb, 3);
end;

destructor TSHBIntExporter.Destroy;
begin
  if Assigned(FToolkit) then
  begin
    FToolkit.CloseToolkit;
    FToolkit := nil;
  end;
  inherited;
end;


function TSHBIntExporter.ClientID: string;
begin
  Result := LJVar(FUserID, 12);
end;

function TSHBIntExporter.OurACNo: string;
begin
  Result := LJVar(FAcCode, 16)
end;

function TSHBIntExporter.OurNameAndAddress(
  const EventData: TAbsEnterpriseSystem): string;
begin
  with EventData do
    Result := LJVar(Setup.ssUserName, 35) +
              LJVar(Setup.ssDetailAddr[1], 35) +
              LJVar(Setup.ssDetailAddr[2], 35);
end;

function TSHBIntExporter.PaymentDetails(
  const EventData: TAbsEnterpriseSystem): string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to 4 do
    Result := Result + ProcessNarrative(FPayDetails[i],
                                      EventData.Transaction.thOurRef, ProcControl.PayRun);
end;

function TSHBIntExporter.SpecialInstructions(
  const Target : TAbsCustomer): string;
begin
     Result := LJVar(Target.acUserDef2, 35) +
               LJVar(Target.acUserDef3, 35) +
               LJVar(Target.acUserDef4, 35) +
               StringOfChar(' ', 35);
end;

function TSHBIntExporter.SupplierBankDetails(
  const Target : TAbsCustomer): string;
begin
   Result := LJVar(Target.acDelAddress[1], 35) +
             LJVar(Target.acDelAddress[2], 35) +
             LJVar(Target.acDelAddress[3], 35) +
             LJVar(Target.acDelAddress[4], 35) +
             LJVar(Target.acDelAddress[5], 35);
end;

function TSHBIntExporter.SupplierNameAndAddress(
  const Target : TAbsCustomer): string;
begin
    Result := LJVar(Target.acCompany, 35) +
              LJVar(Target.acAddress[1], 35) +
              LJVar(Target.acAddress[2], 35) +
              LJVar(Target.acAddress[3], 35);
end;

function TSHBIntExporter.SupplierPostCode(
  const Target : TAbsCustomer): string;
begin
  Result := StringOfChar(' ', 70) + LJVar(Target.acAddress[5], 35);
end;

function TSHBIntExporter.ValidateRec(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  s : string;
  Target : TAbsCustomer;
begin
  with EventData do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;
    Result := (Trim(Target.acCompany) <> '');

    if Result then
    begin
      s :=Target.acUserDef1;
      if not CheckCharge(s) then
        s := UpperCase(Trim(FDefChargeCode));

      Result := CheckCharge(s);
    end;
  end;
end;

function TSHBIntExporter.WriteRec(const EventData: TAbsEnterpriseSystem;
  Mode: word): Boolean;
var
  OutS : AnsiString;
  Pence : longint;
  Target : TAbsCustomer;
begin
  GetEventData(EventData);
  with EventData do
  begin
    if IsReceipt then
      Target := Customer
    else
      Target := Supplier;
    if Mode = wrPayLine then
    begin
      Pence := Pennies(ProcControl.Amount);
      TotalPenceWritten := TotalPenceWritten + Pence;
      Inc(TransactionsWritten);

      OutS := ClientID +
              OurACNo +
              StringOfChar(' ', 7) +
              LJVar(IntToStr(ProcControl.PayRun), 16) +
              MessageType +
              ProcControl.PDate +
              CurrencyCode(EventData.Transaction.thCurrency) +
              ZerosAtFront(Pence, 15) +
              ChargesCode(Target) +
              OurNameAndAddress(EventData) +
              SupplierPostCode(Target) +
              SupplierNameAndAddress(Target) +
              SupplierBankDetails(Target) +
              PaymentDetails(EventData) +
              SpecialInstructions(Target);

              Result := WriteThisRec(OutS);


    end //if payline
    else
      Result := True;
  end; //with
end;

function TSHBIntExporter.ProcessNarrative(const s, OurRef : string; RunNo : longint): string;
begin
  Result := StringReplace(s, '%T', OurRef, [rfReplaceAll, rfIgnoreCase]);
  Result := StringReplace(Result, '%B', IntToStr(RunNo), [rfReplaceAll, rfIgnoreCase]);
  Result := LJVar(Result, 35);
end;

function TSHBIntExporter.ValidateSystem(
  const EventData: TAbsEnterpriseSystem): Boolean;
var
  Res, i : longint;
  IniFilename : string;
begin
  FUserID := UserID;
  GetEventData(EventData);
  IniFilename := IncludeTrailingBackslash(EventData.Setup.ssDataPath) + 'SHBBacs.ini';
  with TIniFile.Create(IniFilename) do
  Try
    if Trim(FUserID) = '' then
      FUserID := ReadString('Settings','ClientID','');
    for i := 1 to 4 do
      FPayDetails[i] := ReadString('International', 'Narrative_' + IntToStr(i), '');
    FDefChargeCode := ReadString('International', 'DefaultCharge', '');
  Finally
    Free;
  End;
  Result := FUserID <> '';
  if not Result then
  {$IFDEF Multibac}
    ShowExportMessage('SHB Intl Export', 'Unable to read Client ID from ' + IniFilename, '')
  {$ELSE}
    ShowExportMessage('SHB Intl Export', 'No Client ID defined', '')
  {$ENDIF}
  else
  with FToolkit do
  begin
    Res := GeneralLedger.GetEqual(GeneralLedger.BuildCodeIndex(ProcControl.BankGL));
    Result := Res = 0;
    if Result then
      FAcCode := GeneralLedger.glAltCode;
  end;

end;

function TSHBIntExporter.CheckCharge(const s: string): Boolean;
var
  s1 : string;
begin
  s1 := UpperCase(Trim(s));
  Result := (s1 = 'OUR') or (s1 = 'BEN');
end;

end.
