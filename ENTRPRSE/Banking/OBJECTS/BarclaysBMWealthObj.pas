unit BarclaysBMWealthObj;
{ prutherford440 15:11 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

{$H-}

uses
  CustAbsU, NatW01, ExpObj, BaseSEPAExportClass, LegacySepaObj, MT103Helper, BarclaysBMSepaObj;

//PR: 21/12/2016 ABSEXCH-18048 Descendant of Barclays BM Sepa allowing different currency
type
  TBarclaysBMWealthObj = Class(TBarclaysBMSepaObject)
  protected
    FCurrency : string;
    function ReadIniFile : Integer;
  public
  //PR: 21/12/2016 ABSEXCH-18048 Read currency from ini file
    function WriteRec(const EventData : TAbsEnterpriseSystem;
                                 Mode : word) : Boolean; override;
    function CreateOutFile(const AFileName : string;
                           const EventData :
                            TAbsEnterpriseSystem) : integer; override;
  end;

implementation

uses
  SysUtils, IniFiles, VAOUtil;

const
  IniFileName = 'BMWealth.ini';

{ TBarclaysBMWealthObj }

function TBarclaysBMWealthObj.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := Inherited CreateOutFile(AFilename, EventData);
  if Result = 0 then
    ReadIniFile;
end;

//PR: 21/12/2016 ABSEXCH-18048 Read currency from ini file
function TBarclaysBMWealthObj.ReadIniFile: Integer;
var
  TheIni : TIniFile;
begin
  //PR: 22/12/2016 ABSEXCH-18048 Was trying to pick ini file up from output folder.
  TheIni := TIniFile.Create(VAOInfo.vaoCompanyDir + IniFileName);
  Try
    FCurrency := TheIni.ReadString('Settings','Currency','EUR');
    if Trim(FCurrency) = '' then
      FCurrency := 'EUR';
  Finally
    TheIni.Free;
  End;
end;

function TBarclaysBMWealthObj.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
var
  pence : longint;
  Amount : Double;
  OutString : string;
  Target : TAbsCustomer4;
begin
  Result := True;
  if Mode <> wrContra then
  Try
    GetEventData(EventData);
    with EventData do
    begin
      Target := TAbsCustomer4(GetTarget(EventData));

      Amount := ProcControl.Amount;
      TotalPenceWritten := TotalPenceWritten + Pennies(Amount);
      inc(TransactionsWritten);

      with FMT103 do
      begin
        WriteSenderRef(Transaction.thOurRef);
        WriteValueDateAndAmount(YYMMDD(ProcControl.PDate), ProcControl.Amount, FCurrency);
        WriteOurIBAN(FSepaObject.CompanyIBAN);
        WriteTheirBIC(Target.acBankSortCode);
        WriteTheirIBAN(Target.acBankAccountCode);
        // HV 20/10/2016 2017-R1 ABSEXCH-17620: Reduce the number of characters exported from 45 to 35
        // PR 16/03/2017 2017-R1 ABSEXCH-1804: Reduce the number of characters exported from 35 to 34
        WriteTheirName(Trim(Copy(Bacs_Safe(Target.acCompany), 1, 34)));
        WritePaymentDetails('');
        WriteChargingInstructions;
        WriteEndOfRecord;
      end;

    end;
  Except
    on E:Exception do
    begin
      Result := False;
      LogIt('Exception in WriteRec: ' + E.Message);
    end;
  End;

end;

end.
