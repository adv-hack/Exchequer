unit RecordHelperClass;

interface

{Helper class to deal with using old and new records. The interface is generic but implemented by differenct objects
for different record types. The user retrieves an interface by calling GetRecordHelper passing in the appropriate
THelperRecordType enumeration member. The function will return an instance of the interface implemented by the correct object.
Objects for single record types (eg Transaction Header, Customer, etc) will only need to know the sizes of the old and new
records; if we need any objects for array-type records (eg Transaction Lines) then they will need to do some extra processing.

The user sets the RecordSize and RecordPointer properties, and then everything else is taken care of by the object. If the
RecordPointer is nil or the RecordSize is not the old size or the new size then the ErrorCode property will be set to the
appropriate error code; otherwise it will be 0, and the RecordPointer property can then be used in place of the pointer passed
in to the calling function.}

type

  //Enumeration passed in to GetRecordHelper function to specify type of record we're dealing with
  THelperRecordType = (rhTransHead);

  //Generic interface
  IToolkitRecordHelper = Interface
    ['{D54D4934-6962-4A15-BF16-5A891F04157F}']
    function GetRecordSize : Integer;
    procedure SetRecordSize(Value : Integer);
    property RecordSize : Integer read GetRecordSize write SetRecordSize;

    function GetRecordPointer : Pointer;
    procedure SetRecordPointer(Value : Pointer);
    property RecordPointer : Pointer read GetRecordPointer write SetRecordPointer;

    function GetErrorCode : Integer;
    property ErrorCode : Integer read GetErrorCode;
  end;

  //Function to return an interface instance
  function GetRecordHelper(WhichOne : THelperRecordType) : IToolkitRecordHelper;

implementation

uses
  VarCnst3, SysUtils;

const
  //Sizes of old records
  OLD_HEADER_SIZE = 1194;

type

  //Base object - should never be implemented
  TToolkitRecordHelper = Class(TInterfacedObject, IToolkitRecordHelper)
  protected
    FRecordPointer : Pointer;
    FNewRecordPointer : Pointer;
    FRecordSize : Integer;
    FOldRecordSize : Integer;
    FNewRecordSize : Integer;
    function GetNewRecordPointer : Pointer; virtual;

    function GetRecordSize : Integer;
    procedure SetRecordSize(Value : Integer);

    function GetRecordPointer : Pointer;
    procedure SetRecordPointer(Value : Pointer);

    function InvalidRecordSize : Boolean;
    function NilPointer : Boolean;

    function GetErrorCode : Integer;
  public
    constructor Create;
    destructor Destroy; override;

    property RecordPointer : Pointer read GetRecordPointer write SetRecordPointer;
    property RecordSize : Integer read GetRecordSize write SetRecordSize;
    property ErrorCode : Integer read GetErrorCode;
  end;

  //Record specific objects

  TTransactionHeaderHelper = Class(TToolkitRecordHelper)
  public
    constructor Create;
  end;

//Return an IToolkitRecordHelper instance implemented by the correct type of object
function GetRecordHelper(WhichOne : THelperRecordType) : IToolkitRecordHelper;
begin
  Case(WhichOne) of
    rhTransHead : Result := TTransactionHeaderHelper.Create;
  end;
end;

{ TToolkitRecordHelper }

constructor TToolkitRecordHelper.Create;
begin
  inherited;
  FRecordPointer := nil;
  FNewRecordPointer := nil;
  FRecordSize := 0;
end;

destructor TToolkitRecordHelper.Destroy;
begin
  //If we are using FNewRecordPointer then an old record was passed in,
  //so we need to move the data back to the original pointer then
  //free the memory used by the new record pointer
  if Assigned(FNewRecordPointer) then
  begin
    Move(FNewRecordPointer^, FRecordPointer^, FRecordSize);
    FreeMem(FNewRecordPointer);
  end;
  inherited;
end;

function TToolkitRecordHelper.GetErrorCode: Integer;
begin
  //Return the appropriate error code depending upon
  //the record size and pointer.
  if NilPointer then
    Result := 32767
  else
  if InvalidRecordSize then
    Result := 32766
  else
    Result := 0;
end;

function TToolkitRecordHelper.InvalidRecordSize: Boolean;
begin
  //If the Record Size doesn't match the size of either the new or the old records
  //then it is invalid
  Result := (FRecordSize <> FOldRecordSize) and (FRecordSize <> FNewRecordSize);
end;

function TToolkitRecordHelper.GetNewRecordPointer: Pointer;
begin
  if not Assigned(FNewRecordPointer) then
  begin
    GetMem(FNewRecordPointer, FNewRecordSize);
    FillChar(FNewRecordPointer^, FNewRecordSize, 0);

    Move(FRecordPointer^, FNewRecordPointer^, FRecordSize);
  end;

  Result := FNewRecordPointer;
end;

function TToolkitRecordHelper.GetRecordPointer: Pointer;
begin
  //Return the appropriate pointer depending upon the
  //record size set.
  if (FRecordSize = FOldRecordSize) then
    Result := GetNewRecordPointer
  else
    Result := FRecordPointer;
end;

function TToolkitRecordHelper.GetRecordSize: Integer;
begin
  Result := FRecordSize;
end;

function TToolkitRecordHelper.NilPointer: Boolean;
begin
  //FRecordPointer always contains the record pointer
  //that was passed in
  Result := FRecordPointer = nil;
end;

procedure TToolkitRecordHelper.SetRecordPointer(Value: Pointer);
begin
  FRecordPointer := Value;
end;

procedure TToolkitRecordHelper.SetRecordSize(Value: Integer);
begin
  FRecordSize := Value;
end;

{ TTransactionHeaderHelper }

constructor TTransactionHeaderHelper.Create;
begin
  inherited;
  FOldRecordSize := OLD_HEADER_SIZE;
  FNewRecordSize := SizeOf(TBatchTHRec);
end;


end.
