unit vatReturnDBManager;

interface

uses
  Classes;


type
  TVATSubmissionRecord = class(TObject)
    CorrelationID          : string;
    IRMark                 : string;
    DateSubmitted          : string;
    DocumentType           : string;
    VatPeriod              : string;
    Username               : string;
    Status                 : smallint;
    PollingInterval        : integer;
    VATDueOnOutputs        : double;
    VATDueOnECAcquisitions : double;
    VATTotal               : double;
    VATReclaimedOnInputs   : double;
    vATNet                 : double;
    NetSalesAndOutputs     : double;
    NetPurchasesAndInputs  : double;
    NetECSupplies          : double;
    NetECAcquisitions      : double;
    HMRCNarrative          : array[0..2047] of Char;
    NotifyEmail            : string;
    DateCreated            : TDateTime;
    DateModified           : TDateTime;
    PositionId             : integer;
  end;

  TVATReturnDBManager = class
  protected
    // Database access methods - only used internally
    procedure ReadVATSubmissionsFromDB; virtual; abstract; // Read the submissions from the database
  public
    fVATRecords      : array of TVATSubmissionRecord;

    constructor Create(AOwner : TComponent); virtual;
    destructor  Destroy; override;

    function NumberOfRecords : integer;
    function GetRecordByIndex(index : integer) : TVATSubmissionRecord;
//    function GetSubmissionStatus(vatPeriod : string) : smallInt;
  end;

  // Function to return a new TContactsManager instance for the appropriate data
function NewVAT100DBManager : TVATReturnDBManager;

implementation

uses
  SQLUtils, VATReturnDBManagerPerv, VATReturnDBManagerSQL;

//=========================================================================
function NewVAT100DBManager : TVATReturnDBManager;
begin
  if SQLUtils.UsingSQL then
    Result := TVATReturnDBManagerSQL.Create(nil)
  else
    Result := TVATReturnDBManagerPerv.Create(nil);
end;

//==============================================================================
constructor TVATReturnDBManager.Create(AOwner : TComponent);
begin
  // Nothing to do here - all done in the sub-classes.
end;

//------------------------------------------------------------------------------
destructor TVATReturnDBManager.Destroy;
begin
  inherited;
end;

function TVATReturnDBManager.NumberOfRecords : integer;
begin
  Result := Length(fVATRecords);
end;

function TVATReturnDBManager.GetRecordByIndex(index : integer) : TVATSubmissionRecord;
begin
  Result := fVATRecords[index];
end;


end.
