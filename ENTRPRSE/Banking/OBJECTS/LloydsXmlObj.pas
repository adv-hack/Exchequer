unit LloydsXmlObj;

interface

uses
  ExpObj, CustAbsU, GmXml;

type

  TLloydsXMLExportObject = Class(TExportObject)
  private
    xml : TGmXML;
    function FormatThisDate(const sDate : string) : string;
  public
     constructor Create;
     destructor Destroy; override;
     function CreateOutFile(const AFileName : string;
                            const EventData :
                                TAbsEnterpriseSystem) : integer; override;
     function CloseOutFile : integer; override;

     function WriteRec(const EventData : TAbsEnterpriseSystem;
                       Mode : word) : Boolean; override;
  end;

implementation

uses
  SysUtils;

{ TLloydsXMLExportObject }

function TLloydsXMLExportObject.CloseOutFile: integer;
var
  dTotal : Double;
begin
  Try
    with xml.Nodes do
    begin
      AddCloseTag; //BeneficiaryList
      AddCloseTag; //Payment
      AddCloseTag; //PaymentList
      dTotal := TotalPenceWritten / 100;
      NodeByName['PaymentAmountField'].AsString := Format('%9.2n', [dTotal])
    end;

    xml.SaveToFile(OutFileName);
    Result := 0;
  Except
    Result := -1;
    raise;
  End;
end;

constructor TLloydsXMLExportObject.Create;
begin
  inherited;
  xml := TGmXml.Create(nil);

end;

function TLloydsXMLExportObject.CreateOutFile(const AFileName: string;
  const EventData: TAbsEnterpriseSystem): integer;
begin
  Result := 0;
  OutFileName := AFileName;
  GetEventData(EventData);

  xml.IncludeHeader := False;

  with xml.Nodes do
  begin
    AddOpenTag('PaymentList');
    AddOpenTag('Payment');

    AddLeaf('PaymentTypeField').AsString := 'BACS_Payment';
    AddLeaf('DebitSortCodeField').AsString := UserBankSort;
    AddLeaf('DebitAccountNumberField').AsString := UserBankAcc;
    AddLeaf('PaymentCurrencyField').AsString := 'GBP';
    AddLeaf('PaymentAmountField').AsString := '0.0';
    AddLeaf('PaymentReferenceNumberField').AsString := 'Payment ' + IntToStr(ProcControl.PayRun);
    AddLeaf('ValueDateField').AsString := FormatThisDate(ProcControl.PDate);

    AddOpenTag('BeneficiaryList');
  end;



end;

destructor TLloydsXMLExportObject.Destroy;
begin
  xml.Free;
  inherited;
end;

function TLloydsXMLExportObject.FormatThisDate(
  const sDate: string): string;
//Input: YYYYMMDD; Output: DD-MMM-YY
var
  yy, mm, dd : Word;
begin
  yy := StrToInt(Copy(sDate, 1, 4));
  mm := StrToInt(Copy(sDate, 5, 2));
  dd := StrToInt(Copy(sDate, 7, 2));

  Result := FormatDateTime('dd-mmm-yyyy', EncodeDate(yy, mm, dd));
end;

function TLloydsXMLExportObject.WriteRec(
  const EventData: TAbsEnterpriseSystem; Mode: word): Boolean;
begin
  Result := True;
  if Mode = wrPayLine then {don't want the contra}
  begin
    GetEventData(EventData);
    with EventData do
    begin
      with xml.Nodes.AddOpenTag('BeneficiaryItem') do
      begin
        Attributes.AddAttribute('AccountNumber', Supplier.acBankAcc);
        Attributes.AddAttribute('SortCode', Supplier.acBankSort);
        Attributes.AddAttribute('Amount', Format('%9.2n', [Transaction.thInvNetVal]));
        Attributes.AddAttribute('Name', Bacs_Safe(Trim(Copy(Supplier.acCompany, 1, 18))));
        Attributes.AddAttribute('PaymentReferenceNumber', Transaction.thOurRef);
      end;
      xml.Nodes.AddCloseTag;
      TotalPenceWritten := TotalPenceWritten + Round(Transaction.thInvNetVal * 100);
    end;
    inc(TransactionsWritten);
  end;
end;

end.
