unit uComTKDataset;

interface

uses
  {$IFDEF PRE_571002_MULTILIST}
    Enterprise01_TLB
  {$ELSE}
    EnterpriseBeta_TLB
  {$ENDIF}
  , Classes, Dialogs, Variants, uExDatasets, SysUtils, uBtrv, APIUtil;

type
  TFilterRecordEvent = procedure(Sender: TObject; ID: IDispatch; var Include: boolean) of object;
  TGetFieldValueEvent = procedure(Sender: TObject; ID: IDispatch; FieldName: string; var FieldValue: string) of object;
  TComTKSelectEvent = procedure(Sender: TObject; SelectType: TSelectType; Address: integer; ID: IDispatch) of object;

  TComTKDataset = class(TExDatasets)
  private
    fCursor: integer;
    fDataRecord: Pointer;
    fDataset: array of variant;
    fBoundLow: Str255;
    fBoundHigh: Str255;
    fFieldList: TStringlist;
    fInternalRefresh: boolean;
//    fSearchIndex: byte;
    fSearchKey: Str255;
    fLastRecordPos : integer;

    {$IFDEF PRE_571002_MULTILIST}
      fToolkitObject : IBtrieveFunctions2;
    {$ELSE}
    fToolkitObject : IDatabaseFunctions;
    {$ENDIF}

    fOnFilterRecord: TFilterRecordEvent;
    fOnGetFieldValue: TGetFieldValueEvent;
    fOnSelectRecord: TComTKSelectEvent;

    procedure ResetDataset;
    procedure InitFieldList(FieldNames: string);
    procedure SetSearchKey(NewSearchKey: Str255);
    {$IFDEF PRE_571002_MULTILIST}
      procedure SetToolkitObject(NewTKO: IBtrieveFunctions2);
    {$ELSE}
    procedure SetToolkitObject(NewTKO: IDatabaseFunctions);
    {$ENDIF}
    function FindRecord(SearchType: integer; var SKey: Str255): integer;
    function FindRecordAddress: integer;
    function isWithinBounds(const SearchLow: Str255; const SearchHigh: Str255): boolean;
    function LoadDataset(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
    function RestorePosition(KeyValue: LongInt): integer;
    procedure FillDataRecord;
  public
    function FreeDataset(DatasetID: integer): integer; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetBlockFirst(DatasetID: integer); override;
    procedure GetBlockPrior(DatasetID: integer); override;
    procedure GetBlockNext(DatasetID: integer); override;
    procedure GetBlockLast(DatasetID: integer); override;
    procedure SelectRecord(SelectType: TSelectType; RecordNo: integer); override;
    function Field({DatasetID: integer;} FieldName: string; ForDisplay: Boolean = False): variant; override;
    function GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean; override;
    function OpenData: integer; override;
    procedure SetBounds; override;
    {$IFDEF PRE_571002_MULTILIST}
      property ToolkitObject : IBtrieveFunctions2 read fToolkitObject write SetToolkitObject;
    {$ELSE}
    property ToolkitObject : IDatabaseFunctions read fToolkitObject write SetToolkitObject;
    {$ENDIF}
    function GetRecord : IDispatch;
  protected
    procedure SetSearchIndex(NewIndex: byte); override;
  published
    property SearchKey: Str255 read fSearchKey write SetSearchKey;
//    property SearchIndex: byte read fSearchIndex write SetSearchIndex;
    property OnFilterRecord: TFilterRecordEvent read fOnFilterRecord write fOnFilterRecord;
    property OnGetFieldValue: TGetFieldValueEvent read fOnGetFieldValue write fOnGetFieldValue;
    property OnSelectRecord: TComTKSelectEvent read fOnSelectRecord write fOnSelectRecord;
  end;

const
  PKey = 'RecordAddress';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TComTKDataset]);
end;

//*** Startup and Shutdown *****************************************************

constructor TComTKDataset.Create(AOwner: TComponent);
begin
  inherited;

  fFieldList:= TStringlist.Create;
  fPrimaryKey:= PKey;
  fSearchKey:= '';

  fDatasets.Add('');
  SetLength(fRecCount, 1);
  SetLength(fStatus, 1);
  fLastRecordPos := 0;
end;

destructor TComTKDataset.Destroy;
begin
  inherited;
  if Assigned(fFieldList) then fFieldList.Free;
end;

function TComTKDataset.OpenData: integer;
begin
  Result := 0;
  if not Open then begin
    if Assigned(ToolkitObject) then Result:= 0
    else Result:= -1;
    Open := Result = 0;
    ResetDataset;
  end;{if}
end;

procedure TComTKDataset.ResetDataset;
begin
  fCursor:= -1;
  fDataset:= nil;
end;

function TComTKDataset.FreeDataset(DatasetID: integer): integer;
begin
  Result:= 0;
end;

//*** Data Retrieval ***********************************************************

function TComTKDataset.GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean;
begin
  Result:= false;
  if Open then begin
    with BlockDetails do begin
      InitFieldList(FieldNames);
      Result:= LoadDataset(BlockDetails, VarIsEmpty(KeyValue));
    end;{with}
  end;{if}
end;

function TComTKDataset.LoadDataset(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
var
RecIndex, ColIndex, Status: integer;
FieldValues: array of variant;
FieldName, FieldValue: string;
SearchLow, SearchHigh: Str255;
Include: boolean;
begin
  {Return a false result, unless either end of the required resultset is reached;
   Clear the dataset to be displayed;}

  Result:= false;
  ResetDataset;
  RecIndex:= 0;

  with BlockDetails do
  begin


    {If the first or the last block is required, first retrieve all values greater
     than the lower bound, or all values lower than the upper bound; Otherwise
     restore the navigational cursor to the record address supplied by the
     BlockDetails KeyValue and retrieve the current database record to the
     fDataRecord buffer;}

    if Searching then SearchLow:= fSearchKey + SortValue + StringOfChar(#0, 255)
    else SearchLow:= fBoundLow;
    SearchHigh:= fBoundHigh;

    if FirstOrLast or Searching or fInternalRefresh then
    begin
      fInternalRefresh:= false;
      if ScrollDown then Status := FindRecord(B_GetGEq, SearchLow)
      else Status := FindRecord(B_GetLessEq, SearchHigh);
    end
    else
    begin
      Status:= RestorePosition(KeyValue);
      if (Status = 0) and (RecCount = 1) then
      begin
        if ScrollDown then Status:= FindRecord(B_GetNext, SearchLow)
        else Status:= FindRecord(B_GetPrev, SearchHigh);
      end;
    end;


    {Add to the dataset record by record until the end of the file is reached,
     or the number of records required has been loaded; Field will only be loaded
     with specific strings if the ComTKDataset OnGetFieldValue event has been
     handled by the user;}

    while (RecIndex < RecCount) and (Status = 0) and isWithinBounds(SearchLow, SearchHigh) do
    begin
      Include:= true;
      if Assigned(OnFilterRecord) then OnFilterRecord(Self, IDispatch(fDataRecord), Include);
      if Include then
      begin
        SetLength(fDataset, Succ(Length(fDataset)));

        if Assigned(OnGetFieldValue) then
        begin


          {Empty the FieldValues array and set it to hold the number of columns
           governed by the FieldList; Initialise a FieldDetails record and pass it
           by reference to the OnGetFieldValue event; This event will set the
           FieldValue to control what is displayed, otherwise an empty string will
           be loaded; Add the column FieldValue to the FieldValues array for ease
           of loading into fDataset;}

          FieldValues:= nil;
          SetLength(FieldValues, Succ(fFieldList.Count));

          for ColIndex:= 0 to Pred(fFieldList.Count) do
          begin
            FieldValue:= '';
            FieldName:= fFieldList[ColIndex];

            try
              OnGetFieldValue(Self, IDispatch(fDataRecord), FieldName, FieldValue);
            except
              MsgBox('An Exception occurred when calling the event "OnGetFieldValue" on the TComTKDataset : '
              + Self.Name, mtError, [mbOK], mbOK, 'OnGetFieldValue Exception');
            end;{try}

            FieldValues[ColIndex]:= FieldValue;
          end;
          FieldValues[High(FieldValues)]:= FindRecordAddress;
          fDataset[High(fDataset)]:= FieldValues;
        end;

        inc(RecIndex);
      end;

      {Move the cursor to the next record in the appropriate direction, retrieving
       the new record into the fDataRecord buffer; Increment the record index
       count so that we can determine when the required number of records have
       been loaded;}

      if ScrollDown then Status:= FindRecord(B_GetNext, SearchLow)
      else Status:= FindRecord(B_GetPrev, SearchHigh);
    end;


    {If the end of the file was reached before returning the requested number of
     records, reload the dataset from the beginning or end of the table resultset;
     This will involve adding the records in reverse order, so set the result
     to true to notify the consumer that the record order must be reversed,
     toggle the scroll direction and reload the dataset; Endless recursion for
     small sub-screen resultsets is avoided by checking the FirstOrLast parameter;
     NOTE: The RecCount is only set where all records were retrieved or the required
     block was loaded from the beginning or end;}

    if (RecIndex <> RecCount) and not(FirstOrLast) then
    begin
      Result:= true;
      ScrollDown:= not ScrollDown;
      LoadDataset(BlockDetails, true);
    end
    else
    begin
      SetRecCount(0, RecIndex);
      GetBlockFirst(0);
    end;
  end;
end;

procedure TComTKDataset.FillDataRecord;
begin{FillDataRecord}
  fDataRecord := Pointer(ToolkitObject);
end;{FillDataRecord}

function TComTKDataset.FindRecord(SearchType: integer; var SKey: Str255): integer;
begin
  Result := -1;
  if Assigned(ToolkitObject) then begin
    Case SearchType of
      B_GetEq : Result := ToolkitObject.GetEqual(SKey);
      B_GetNext : Result := ToolkitObject.GetNext;
      B_GetNextEx : Result := ToolkitObject.GetNext;
      B_GetPrev : Result := ToolkitObject.GetPrevious;
      B_GetPrevEx : Result := ToolkitObject.GetPrevious;
      B_GetGretr : Result := ToolkitObject.GetGreaterThan(SKey);
      B_GetGEq : Result := ToolkitObject.GetGreaterThanOrEqual(SKey);
      B_GetLess : Result := ToolkitObject.GetLessThan(SKey);
      B_GetLessEq : Result := ToolkitObject.GetLessThanOrEqual(SKey);
      B_GetFirst : Result := ToolkitObject.GetFirst;
      B_GetLast : Result := ToolkitObject.GetLast;
    end;{Case}

    SKey := ToolkitObject.KeyString2;

    if Result = 0 then begin
      FindRecordAddress;
      FillDataRecord;
    end;{if}
  end;{if}
end;

function TComTKDataset.FindRecordAddress: integer;
begin
  ToolkitObject.SavePosition;
  Result := ToolkitObject.Position;
end;

function TComTKDataset.RestorePosition(KeyValue: LongInt): integer;
begin
  ToolkitObject.Position := KeyValue;
  Result := ToolkitObject.RestorePosition;
  if Result = 0 then FillDataRecord;
end;

function TComTKDataset.Field({DatasetID: integer;} FieldName: string; ForDisplay: Boolean = False): variant;
var
ColIndex: integer;
begin
  Result:= '';
  if (fCursor < Low(fDataset)) or (fCursor > High(fDataset)) then Exit;

  if FieldName = fPrimaryKey then Result:= fDataset[fCursor][fFieldList.Count]
  else
  begin
    ColIndex:= fFieldList.IndexOf(FieldName);
    if ColIndex >= 0 then Result:= fDataset[fCursor][ColIndex];
  end;
end;

//*** Cursor Movement **********************************************************

procedure TComTKDataset.GetBlockFirst;
begin
  if Length(fDataset) <= 0 then Exit;
  fCursor:= 0;
end;

procedure TComTKDataset.GetBlockPrior;
begin
  if fCursor < 1 then Exit;
  dec(fCursor);
end;

procedure TComTKDataset.GetBlockNext;
begin
  if (fCursor < 0) or (fCursor >= High(fDataSet)) then Exit;
  inc(fCursor);
end;

procedure TComTKDataset.GetBlockLast;
begin
  if Length(fDataset) <= 0 then Exit;
  fCursor:= High(fDataSet);
end;

//*** Public Methods ***********************************************************
procedure TComTKDataset.SelectRecord(SelectType: TSelectType; RecordNo: integer);
begin
  if (RestorePosition(RecordNo) = 0) then begin
    fLastRecordPos := RecordNo;
    if Assigned(OnSelectRecord) then OnSelectRecord(Self, SelectType, RecordNo, IDispatch(fDataRecord));
  end;{if}
end;

//*** Helper Functions *********************************************************

function TComTKDataset.isWithinBounds(const SearchLow: Str255; const SearchHigh: Str255): boolean;
begin
{  Result:= (SearchLow >= fBoundLow) and (SearchLow <= fBoundHigh)
  and (SearchHigh >= fBoundLow) and (SearchHigh <= fBoundHigh);}

  Result:= (Copy(SearchLow,1,Length(fSearchKey)) >= Copy(fBoundLow,1,Length(fSearchKey)))
  and (Copy(SearchLow,1,Length(fSearchKey)) <= Copy(fBoundHigh,1,Length(fSearchKey)))
  and (Copy(SearchHigh,1,Length(fSearchKey)) >= Copy(fBoundLow,1,Length(fSearchKey)))
  and (Copy(SearchHigh,1,Length(fSearchKey)) <= Copy(fBoundHigh,1,Length(fSearchKey)));

end;

procedure TComTKDataset.InitFieldList(FieldNames: string);
var
CharIndex: integer;
FieldName: string;
begin
  fFieldList.Clear;
  FieldName:= '';

  for CharIndex:= 1 to Length(FieldNames) do
  begin
    if FieldNames[CharIndex] = ',' then
    begin
      fFieldList.Add(FieldName);
      FieldName:= '';
    end
    else if FieldNames[CharIndex] <> #32 then FieldName:= FieldName + FieldNames[CharIndex];
  end;
end;

//*** Property Handling ********************************************************

procedure TComTKDataset.SetSearchKey(NewSearchKey: Str255);
begin
  fInternalRefresh:= true;
  fSearchKey:= NewSearchKey;
end;

{$IFDEF PRE_571002_MULTILIST}
  procedure TComTKDataset.SetToolkitObject(NewTKO: IBtrieveFunctions2);
{$ELSE}
  procedure TComTKDataset.SetToolkitObject(NewTKO: IDatabaseFunctions);
{$ENDIF}
begin
  fInternalRefresh:= true;
  fToolkitObject := NewTKO;
end;

//******************************************************************************

procedure TComTKDataset.SetSearchIndex(NewIndex: byte);
begin
  fSearchIndex := NewIndex;
//  inherited;
  if Assigned(ToolkitObject) then ToolkitObject.Index := NewIndex;
end;

function TComTKDataset.GetRecord : IDispatch;
begin
  if fLastRecordPos = 0 then Result := nil
  else begin
    if (RestorePosition(fLastRecordPos) = 0)
    then Result := IDispatch(fDataRecord);
  end;{if}
end;

procedure TComTKDataset.SetBounds;
begin
  fBoundLow:= fSearchKey + StringOfChar(#0, 255);

  // NF: allows integer indexes to be used
  { CJS 2012-08-03 ABSEXCH-2449 - Fix required for the search, to support this
                                  JIRA issue. Protected by IFDEF ODD so that
                                  it is not necessary to test this fix against
                                  everything else which might use this dataset.
  }
  {$IFDEF ODD}
  if (fSearchDataType = dtInteger) then fBoundHigh := fSearchKey + FullNomKey(2147483647)
  {$ELSE}
  if (fSearchDataType = dtInteger) then fBoundHigh := FullNomKey(2147483647)
  {$ENDIF}
  else fBoundHigh:= fSearchKey + StringOfChar(#255, 255);
end;

end.

