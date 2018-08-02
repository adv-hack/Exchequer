unit vatReturnDBManagerPerv;

interface

uses
  SysUtils,
  Classes,
  GlobVar,
  vatReturnDBManager,
  oVAT100BtrieveFile;

type
  TVATReturnDBManagerPerv = class(TVATReturnDBManager)
  private
    FVAT100: TVAT100BtrieveFile;
  protected
    // Read the records from the database into the internal FVATRecords array
    procedure ReadVATSubmissionsFromDB; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

uses oBtrieveFile;

// =============================================================================
// TVATReturnDBManagerPerv
// =============================================================================
constructor TVATReturnDBManagerPerv.Create(AOwner: TComponent);
begin
  inherited;
  FVAT100 := TVAT100BtrieveFile.Create;
  ReadVATSubmissionsFromDB;
end;

// -----------------------------------------------------------------------------

destructor TVATReturnDBManagerPerv.Destroy;
begin
  FVAT100.CloseFile;
  FreeAndNil(FVAT100);
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TVATReturnDBManagerPerv.ReadVATSubmissionsFromDB;  // Read the contacts from the database
var
  FuncRes: Integer;
  Entry: Integer;
begin
  FuncRes := FVAT100.OpenFile(SetDrive + VAT100FileName);
  if (FuncRes = 0) then
  try
    FVAT100.Index := vatIdxCorrelationId;
    FuncRes := FVAT100.GetFirst;
    while (FuncRes = 0) do
    begin
      SetLength(fVATRecords, Length(fVATRecords) + 1);
      Entry := High(fVATRecords);
      fVATRecords[Entry] := TVatSubmissionRecord.Create;

      with FVAT100.Rec do
      begin
        fVATRecords[Entry].CorrelationID          := vatCorrelationID;
        fVATRecords[Entry].IRMark                 := vatIRMark;
        fVATRecords[Entry].DateSubmitted          := vatDateSubmitted;
        fVATRecords[Entry].DocumentType           := vatDocumentType;
        fVATRecords[Entry].VATPeriod              := vatPeriod;
        fVATRecords[Entry].Username               := vatUsername;
        fVATRecords[Entry].Status                 := vatStatus;
        fVATRecords[Entry].PollingInterval        := vatPollingInterval;
        fVATRecords[Entry].VATDueOnOutputs        := vatDueOnOutputs;
        fVATRecords[Entry].VATDueOnECAcquisitions := vatDueOnECAcquisitions;
        fVATRecords[Entry].VATTotal               := vatTotal;
        fVATRecords[Entry].VATReclaimedOnInputs   := vatReclaimedOnInputs;
        fVATRecords[Entry].VATNet                 := vatNet;
        fVATRecords[Entry].NetSalesAndOutputs     := vatNetSalesAndOutputs;
        fVATRecords[Entry].NetPurchasesAndInputs  := vatNetPurchasesAndInputs;
        fVATRecords[Entry].NetECSupplies          := vatNetECSupplies;
        fVATRecords[Entry].NetECAcquisitions      := vatNetECAcquisition;
        fVATRecords[Entry].NotifyEmail            := vatNotifyEmail;
        Move(vatHMRCNarrative, fVATRecords[Entry].HMRCNarrative, SizeOf(fVATRecords[Entry].HMRCNarrative));
      end;

      FuncRes := FVAT100.GetNext;
    end;
  finally
    FVAT100.CloseFile;
  end;
end;

// -----------------------------------------------------------------------------

end.
