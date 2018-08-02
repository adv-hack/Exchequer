unit vatReturnDBManagerSQL;

interface

uses
  Classes,
  GlobVar,
  vatReturnDBManager;

type
  TVATReturnDBManagerSQL = class(TVATReturnDBManager)
  private
    FCompanyCode : ShortString;

  protected
    procedure ReadVATSubmissionsFromDB; override;     // Read the contacts from the database
  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;
  end;

implementation

uses
  SQLUtils,
  SQLCallerU,
  ADOConnect;

//------------------------------------------------------------------------------
constructor TVATReturnDBManagerSQL.Create(AOwner : TComponent);
begin
  inherited;

  // Lookup the data path in the Company Table to determine the Company Code - cache in local
  // variable for performance
  FCompanyCode := SQLUtils.GetCompanyCode(SetDrive);

  // Get the list of VAT Submissions
  ReadVATSubmissionsFromDB;
end;


//------------------------------------------------------------------------------
destructor TVATReturnDBManagerSQL.Destroy;
begin
  inherited;
end;


//------------------------------------------------------------------------------
procedure TVATReturnDBManagerSQL.ReadVATSubmissionsFromDB;  // Read the contacts from the database
var
  sSQL : String;
  index : integer;

  // CJS 2015-08-24 - ABSEXCH-16778 - Garbled HMRC Narrative on VAT Submission
  Buffer: AnsiString;
  BytesToCopy: Integer;
begin
  with TSQLCaller.Create(GlobalADOConnection) do
  begin
    try
      // Set up a SQL query
      sSQL := 'SELECT [vatCorrelationID], [vatIRMark], [vatDateSubmitted], [vatDocumentType], [vatPeriod], ' +
              '[vatUsername], [vatStatus], [vatPollingInterval], [vatDueOnOutputs], [vatDueOnECAcquisitions], ' +
              '[vatTotal], [vatReclaimedOnInputs], [vatNet], [vatNetSalesAndOutputs], [vatNetPurchasesAndInputs], ' +
              '[vatNetECSupplies], [vatNetECAcquisitions], [vatHMRCNarrative], [vatNotifyEmail] ' +
              'FROM [COMPANY].[VAT100] ' +
              'ORDER BY VATPeriod';

      // Execute the query
      Select(sSQL, FCompanyCode);

      if (ErrorMsg = '') And (Records.RecordCount > 0) then
      Begin
        Records.First;

        While (Not Records.EOF) Do
        Begin
          // Set the size of the array
          Setlength(fVATRecords, Length(fVATRecords)+1);
          index := High(fVATRecords);
          fVATRecords[index] := TVatSubmissionRecord.Create;

          fVATRecords[index].CorrelationID          := Records.FieldByName('vatCorrelationID').Value;
          fVATRecords[index].IRMark                 := Records.FieldByName('vatIRMark').Value;
          fVATRecords[index].DateSubmitted          := Records.FieldByName('vatDateSubmitted').Value;
          fVATRecords[index].DocumentType           := Records.FieldByName('vatDocumentType').Value;
          fVATRecords[index].VATPeriod              := Records.FieldByName('vatPeriod').Value;
          fVATRecords[index].Username               := Records.FieldByName('vatUsername').Value;
          fVATRecords[index].Status                 := Records.FieldByName('vatStatus').Value;
          fVATRecords[index].PollingInterval        := Records.FieldByName('vatPollingInterval').Value;
          fVATRecords[index].VATDueOnOutputs        := Records.FieldByName('vatDueOnOutputs').Value;
          fVATRecords[index].VATDueOnECAcquisitions := Records.FieldByName('vatDueOnECAcquisitions').Value;
          fVATRecords[index].VATTotal               := Records.FieldByName('vatTotal').Value;
          fVATRecords[index].VATReclaimedOnInputs   := Records.FieldByName('vatReclaimedOnInputs').Value;
          fVATRecords[index].VATNet                 := Records.FieldByName('vatNet').Value;
          fVATRecords[index].NetSalesAndOutputs     := Records.FieldByName('vatNetSalesAndOutputs').Value;
          fVATRecords[index].NetPurchasesAndInputs  := Records.FieldByName('vatNetPurchasesAndInputs').Value;
          fVATRecords[index].NetECSupplies          := Records.FieldByName('vatNetECSupplies').Value;
          fVATRecords[index].NetECAcquisitions      := Records.FieldByName('vatNetECAcquisitions').Value;
          fVATRecords[index].NotifyEmail            := Records.FieldByName('vatNotifyEmail').Value;

          // CJS 2015-08-24 - ABSEXCH-16778 - Garbled HMRC Narrative on VAT Submission
          Buffer := Records.FieldByName('vatHMRCNarrative').AsString;
          BytesToCopy := Length(Buffer);
          if (BytesToCopy > SizeOf(fVATRecords[index].HMRCNarrative)) then
            BytesToCopy := SizeOf(fVATRecords[index].HMRCNarrative);

          // PKR. 10/09/2015. Changed Buffer start index back to 1.  This was 1 originally and then
          // changed to 2 for some unknown reason, resulting in a missing leading character.
          Move(Buffer[1], fVATRecords[index].HMRCNarrative[0], BytesToCopy);

          Records.Next;
        end;
      end;
    finally
      Free;
    end; // Try..Finally
  end;
end;



end.
