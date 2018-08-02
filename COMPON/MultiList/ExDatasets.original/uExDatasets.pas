unit uExDatasets;

interface

uses
  Classes, SysUtils, Dialogs;

type
//  String255 = string[255];
  TDBType = (dbPervasive, dbMSSQL);
  TDatasetType = (dtCursor, dtResultSet);
  TSelectType = (stNavigate, stRecordClick, stRecordDblClick, stKeyPress, stScrollbarClick);
  TDBMDataType = (dtString, dtInteger, dtDate, dtTime, dtDateTime, dtBoolean, dtFloat, dtCurrency);

  TBlockDetails = record
    FieldNames: string;
    KeyValue: variant;
    SortKey: string;
///    SortValue: variant;
    SortValue: string;
    RecCount: integer;
    ScrollDown: boolean;
    Searching: boolean;
    Refreshing: boolean;
  end;

  TExDatasets = class(TComponent)
  protected
    fDatasets: TStringList;
    fOnLoaded: TNotifyEvent;
    fKeepConnection: boolean;
    fPrimaryKey: string;
    fRecCount: array of integer;
    fStatus: array of integer;
    fSearchIndex: byte; //NF: enables indexes to be be set by DBMultiList
    fSearchDataType : TDBMDataType; //NF: enables integer indexes to be used
    fOpen : boolean; //NF: Open property rather that function
    procedure Loaded; override;
    procedure SetRecCount(DatasetID: integer; NewRecCount: integer);
    procedure SetStatus(DatasetID: integer; NewStatus: integer);
    function Authenticate(Password: string): integer;
//    function FreeDataset(DatasetID: integer): integer; virtual; abstract;
    function GetRecCount(DatasetID: integer): integer;
    function GetStatus(DatasetID: integer): integer;
    procedure SetSearchDataType(NewSearchDataType : TDBMDataType);
    procedure SetOpen(Value : boolean);
    procedure SetSearchIndex(NewIndex: byte); virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetBlockFirst(DatasetID: integer); virtual; abstract;
    procedure GetBlockPrior(DatasetID: integer); virtual; abstract;
    procedure GetBlockNext(DatasetID: integer); virtual; abstract;
    procedure GetBlockLast(DatasetID: integer); virtual; abstract;
    procedure SelectRecord(SelectType: TSelectType; RecordNo: integer); virtual; abstract;
    procedure SetBounds; virtual; abstract;
    function isBtrieve: boolean;
    function OpenData: integer; virtual; abstract;
    function GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean; virtual; abstract;
    function Field(DatasetID: integer; FieldName: string): variant; virtual; abstract;
    function FreeDataset(DatasetID: integer): integer; virtual; abstract;
    property Open: boolean read fOpen write SetOpen;
    property PrimaryKey: string read fPrimaryKey;
    property RecCount[DatasetID: integer]: integer read GetRecCount;
    property Status[DatasetID: integer]: integer read GetStatus;
    property OnLoaded: TNotifyEvent read fOnLoaded write fOnLoaded;
    property SearchDataType: TDBMDataType read fSearchDataType write SetSearchDataType; //NF: enables integer indexes to be used
    property SearchIndex: byte read fSearchIndex write SetSearchIndex; //NF: enables indexes to be be set by DBMultiList
//    property SearchIndex: byte read fSearchIndex write fSearchIndex; //NF: enables indexes to be be set by DBMultiList
  published
    property KeepConnection: boolean read fKeepConnection write fKeepConnection default true;
  end;

implementation

//*** TExDatasets **************************************************************

constructor TExDatasets.Create(AOwner: TComponent);
begin
  {Create the necessary connection types and the dataset container;}

  inherited;

  fDatasets:= TStringList.Create;
  fKeepConnection:= true;
  fSearchDataType := dtString; //NF: Most indexes are string based
  fOpen := FALSE; //NF: Default to closed
end;

procedure TExDatasets.Loaded;
begin
  inherited;

  if Assigned(OnLoaded) then OnLoaded(Self);
end;

function TExDatasets.Authenticate(Password: string): integer;
begin
  {For use should access to TExDatasets be provided through a DLL or COM etc;}

  try
    Result:= 0;
  except
    Result:= -1;
  end;
end;

destructor TExDatasets.Destroy;
var
ItemsIndex: integer;
begin
  {Free all datasets and free the container; Close the database connections;}

  try

    if Assigned(fDatasets) then
    begin
      for ItemsIndex:= 0 to fDatasets.Count - 1 do begin
//        FreeDataset(ItemsIndex);
        if fOpen then FreeDataset(ItemsIndex); //NF:
      end;
      FreeAndNil(fDatasets);
    end;

    fRecCount:= nil;
    fStatus:= nil;

  except
  end;

  inherited;
end;

function TExDatasets.isBtrieve: boolean;
begin
  Result:= fPrimaryKey = 'RecordAddress';
end;

//*** Property Get/Settings ****************************************************

function TExDatasets.GetRecCount(DatasetID: integer): integer;
begin
  Result:= -1;
  try
    if (DatasetID >= Low(fRecCount)) and (DatasetID <= High(fRecCount)) then
    begin
      Result:= fRecCount[DatasetID];
    end;
  except
  end;
end;

function TExDatasets.GetStatus(DatasetID: integer): integer;
begin
  Result:= -1;
  try
    if (DatasetID >= Low(fStatus)) and (DatasetID <= High(fStatus)) then
    begin
      Result:= fStatus[DatasetID];
    end;
  except
  end;
end;

procedure TExDatasets.SetRecCount(DatasetID: integer; NewRecCount: integer);
begin
  if (DatasetID >= Low(fRecCount)) and (DatasetID <= High(fRecCount)) then fRecCount[DatasetID]:= NewRecCount;
end;

procedure TExDatasets.SetStatus(DatasetID, NewStatus: integer);
begin
  if (DatasetID >= Low(fStatus)) and (DatasetID <= High(fStatus)) then fStatus[DatasetID]:= NewStatus;
end;

//******************************************************************************

procedure TExDatasets.SetSearchDataType(NewSearchDataType: TDBMDataType);
begin
  fSearchDataType := NewSearchDataType;
  SetBounds;
end;

procedure TExDatasets.SetOpen(Value: boolean);
begin
  fOpen := Value;
//  if fOpen = 0 then OpenData
//  else FreeDataset(fOpen);
end;

end.
