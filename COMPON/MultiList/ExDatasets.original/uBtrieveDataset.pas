unit uBtrieveDataset;

interface

uses Classes, Dialogs, Variants, uExDatasets, uBtrv, SysUtils;

type
  TFilterRecordEvent = procedure(Sender: TObject; PData: Pointer; var Include: boolean) of object;
  TGetFieldValueEvent = procedure(Sender: TObject; PData: Pointer; FieldName: string; var FieldValue: string) of object;
  TBtrieveSelectEvent = procedure(Sender: TObject; SelectType: TSelectType; Address: integer; PData: Pointer) of object;
  EBtrieveDatasetError = class(Exception);

  TBtrieveDataset = class(TExDatasets)
  private
    fCursor: integer;
    fDataRecord: Pointer;
    fDataset: array of variant;
    fExtended: Pointer;
    fExtendedInit: Pointer;

    fBoundLow: Str255;
    fBoundHigh: Str255;
    fBufferSize: integer;
    fExtendedInitSize: integer;
    fExtendedSize: integer;
    fFieldList: TStringlist;
//    fFileOpen: boolean;
    fFileName: string;
    fFileVar: FileVar;
    fInternalRefresh: boolean;
//    fSearchIndex: byte;
    fSearchKey: Str255;
    fLastRecordPos : integer; // NF: allows us to get the current record

    fOnFilterRecord: TFilterRecordEvent;
    fOnGetFieldValue: TGetFieldValueEvent;
    fOnSelectRecord: TBtrieveSelectEvent;
    procedure ResetDataset;
    procedure InitFieldList(FieldNames: string);
    procedure SetSearchKey(NewSearchKey: Str255);
    function FindRecord(SearchType: integer; var SKey: Str255): integer;
    function FindRecordAddress: integer;
    function isWithinBounds(const SearchLow: Str255; const SearchHigh: Str255): boolean;
    function isValidExtended: boolean;
    function LoadDataset(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
    function LoadExtended(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
    function RestorePosition(KeyValue: LongInt): integer;
//    function GetLastRecordNeeded(var SearchHigh: Str255) : integer;
  protected
//    function FreeDataset(DatasetID: integer): integer; override;
    procedure SetSearchIndex(NewIndex: byte); override;
  public
    function FreeDataset(DatasetID: integer): integer; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CancelExtended;
    procedure GetBlockFirst(DatasetID: integer); override;
    procedure GetBlockPrior(DatasetID: integer); override;
    procedure GetBlockNext(DatasetID: integer); override;
    procedure GetBlockLast(DatasetID: integer); override;
    procedure InitExtended(ExtendedBuffer: Pointer; BufferSize: integer);
    procedure SelectRecord(SelectType: TSelectType; RecordNo: integer); override;
    function Field(DatasetID: integer; FieldName: string): variant; override;
    function GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean; override;
//    function Open: integer; override;
    function OpenData: integer; override;
    procedure SetBounds; override;
    function GetRecord : Pointer;
    property GetRecordPosition : longint read fLastRecordPos;
  published
    property FileName: string read fFileName write fFileName;
    property SearchKey: Str255 read fSearchKey write SetSearchKey;
//    property SearchIndex: byte read fSearchIndex write SetSearchIndex;
    property OnFilterRecord: TFilterRecordEvent read fOnFilterRecord write fOnFilterRecord;
    property OnGetFieldValue: TGetFieldValueEvent read fOnGetFieldValue write fOnGetFieldValue;
    property OnSelectRecord: TBtrieveSelectEvent read fOnSelectRecord write fOnSelectRecord;
  end;

const
  PKey = 'RecordAddress';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SBS', [TBtrieveDataset]);
end;

//*** Startup and Shutdown *****************************************************

constructor TBtrieveDataset.Create(AOwner: TComponent);
begin
  inherited;

  fBufferSize:= 10 * 1024;
  fExtendedSize:= 10 * 1024;

  fFieldList:= TStringlist.Create;
  fPrimaryKey:= PKey;
  SearchKey:= '';

  fDatasets.Add('');
  SetLength(fRecCount, 1);
  SetLength(fStatus, 1);
end;

destructor TBtrieveDataset.Destroy;
begin
  inherited;
  if Assigned(fFieldList) then fFieldList.Free;
end;

//function TBtrieveDataset.Open: integer;
function TBtrieveDataset.OpenData: integer;
begin
  Result := 0;
  if not Open then begin
//    SetBounds;
    GetMem(fDataRecord, fBufferSize);
    GetMem(fExtended, fExtendedSize);
    Result := Open_File(fFileVar, fFileName, 0);
    Open := Result = 0;
    ResetDataset;
    SetBounds;
  end;{if}
end;

procedure TBtrieveDataset.ResetDataset;
begin
  fCursor:= -1;
  fDataset:= nil;
end;

function TBtrieveDataset.FreeDataset(DatasetID: integer): integer;
begin
  Result:= 0;
  if Assigned(fExtended) then FreeMem(fExtended);
  if Assigned(fDataRecord) then FreeMem(fDataRecord);
  if Open then begin
    Result := Close_File(fFileVar);
    Open := Result <> 0;
  end;{if}
//  if Assigned(fFieldList) then fFieldList.Free;
end;

//*** Data Retrieval ***********************************************************

function TBtrieveDataset.GetBlock(DatasetID: integer; BlockDetails: TBlockDetails): boolean;
begin
  Result:= false;

  if Open then with BlockDetails do
  begin
    InitFieldList(FieldNames);
    if Assigned(fExtendedInit) then Result:= LoadExtended(BlockDetails, VarIsEmpty(KeyValue))
    else Result:= LoadDataset(BlockDetails, VarIsEmpty(KeyValue));
  end;
end;

function TBtrieveDataset.LoadDataset(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
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

    if Searching then SearchLow:= fSearchKey + SortValue
    + Copy(fBoundLow,length(fSearchKey + SortValue)+1, 255)
    else SearchLow:= fBoundLow;
    SearchHigh:= fBoundHigh;

    if FirstOrLast or Searching or fInternalRefresh then
    begin
      fInternalRefresh:= false;
      if ScrollDown then Status:= FindRecord(B_GetGEq, SearchLow)
      else Status:= FindRecord(B_GetLessEq, SearchHigh);
//      else Status:= GetLastRecordNeeded(SearchHigh);
    end
    else begin
//      if VarType(FieldValue) = varString then Exit; //NF:
      Status:= RestorePosition(KeyValue);
      if (Status = 0) and (RecCount = 1) then
      begin
        if ScrollDown then Status:= FindRecord(B_GetNext, SearchLow)
        else Status:= FindRecord(B_GetPrev, SearchHigh);
      end;{if}
    end;{if}


    {Add to the dataset record by record until the end of the file is reached,
     or the number of records required has been loaded; Field will only be loaded
     with specific strings if the BtrieveDataset OnGetFieldValue event has been
     handled by the user;}

    while (RecIndex < RecCount) and (Status = 0) and isWithinBounds(SearchLow, SearchHigh) do
    begin
      Include:= true;
      if Assigned(OnFilterRecord) then OnFilterRecord(Self, fDataRecord, Include);
      if Include then
      begin
        SetLength(fDataset, Succ(Length(fDataset)));

        if Assigned(OnGetFieldValue) then
        begin

//          SetLength(fDataset, Succ(Length(fDataset)));

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
            OnGetFieldValue(Self, fDataRecord, FieldName, FieldValue);
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

function TBtrieveDataset.LoadExtended(BlockDetails: TBlockDetails; FirstOrLast: boolean): boolean;
var
RecIndex, ColIndex, Status: integer;
FieldValues: array of variant;
FieldName, FieldValue: string;
SearchLow, SearchHigh: Str255;
Include, StandardCall: boolean;
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
     fExtended buffer;}

    if Searching then SearchLow:= fSearchKey + SortValue + StringOfChar(#0, 255)
    else SearchLow:= fBoundLow;
    SearchHigh:= fBoundHigh;
    StandardCall:= true;

    if FirstOrLast or Searching or fInternalRefresh then
    begin
      fInternalRefresh:= false;
      if ScrollDown then Status:= FindRecord(B_GetGEq, SearchLow)
      else Status:= FindRecord(B_GetLessEq, SearchHigh);
//      else Status:= GetLastRecordNeeded(SearchHigh);
    end
    else
    begin
      Status:= RestorePosition(KeyValue);
      if (Status = 0) and (RecCount = 1) then
      begin
        StandardCall:= false;
        if ScrollDown then Status:= FindRecord(B_GetNextEx, SearchLow)
        else Status:= FindRecord(B_GetPrevEx, SearchHigh);
      end;
    end;


    {Add to the dataset record by record until the end of the file is reached,
     or the number of records required has been loaded; Field will only be loaded
     with specific strings if the BtrieveDataset OnGetFieldValue event has been
     handled by the user;}

    while (RecIndex < RecCount) and (Status = 0) and isWithinBounds(SearchLow, SearchHigh) do
    begin
      Include:= true;
      if Assigned(OnFilterRecord) then
      begin
        if StandardCall then OnFilterRecord(Self, fDataRecord, Include)
        else if isValidExtended then OnFilterRecord(Self, Pointer(LongInt(fExtended) + 8), Include)
        else Include:= false;
      end;

      if Include then
      begin
        SetLength(fDataset, Succ(Length(fDataset)));

        if Assigned(OnGetFieldValue) then
        begin

//          SetLength(fDataset, Succ(Length(fDataset)));

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
            if StandardCall then OnGetFieldValue(Self, fDataRecord, FieldName, FieldValue)
            else OnGetFieldValue(Self, Pointer(LongInt(fExtended) + 8), FieldName, FieldValue);
            FieldValues[ColIndex]:= FieldValue;
          end;
          FieldValues[High(FieldValues)]:= FindRecordAddress;
          fDataset[High(fDataset)]:= FieldValues;
        end;

        inc(RecIndex);
      end;

      {Move the cursor to the next record in the appropriate direction, retrieving
       the new record into the fExtended buffer; Increment the record index
       count so that we can determine when the required number of records have
       been loaded;}

      StandardCall:= false;
      if ScrollDown then Status:= FindRecord(B_GetNextEx, SearchLow)
      else Status:= FindRecord(B_GetPrevEx, SearchHigh);
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
      LoadExtended(BlockDetails, true);
    end
    else
    begin
      SetRecCount(0, RecIndex);
      GetBlockFirst(0);
    end;
  end;
end;

function TBtrieveDataset.FindRecord(SearchType: integer; var SKey: Str255): integer;
begin
  if Assigned(fExtendedInit) and (SearchType in [B_GetNextEx, B_GetPrevEx]) then
  begin
    fExtendedSize:= fExtendedInitSize;
    Move(fExtendedInit^, fExtended^, fExtendedSize);
    Result:= Btrv(SearchType, fFileVar, fExtended^, fExtendedSize, SKey[1], fSearchIndex, nil);
  end
  else
  begin
    fBufferSize:= 10 * 1024;
    Result:= Btrv(SearchType, fFileVar, fDataRecord^, fBufferSize, SKey[1], fSearchIndex, nil);
  end;
end;
{
function TBtrieveDataset.GetLastRecordNeeded(var SearchHigh: Str255) : integer;
begin
  if (fSearchDataType = dtInteger) then
  begin
    Result := FindRecord(B_GetGEq, SearchHigh);
    if Result = 9 then Result := FindRecord(B_GetLast, SearchHigh)
    else begin
      Result := FindRecord(B_GetPrev, SearchHigh)
    end;{if}
{  end
  else Result := FindRecord(B_GetLessEq, SearchHigh);
end;
}

function TBtrieveDataset.FindRecordAddress: integer;
var
SearchKey: PChar;
RecAddress, AddressSize: LongInt;
Status: SmallInt;
begin
  AddressSize:= SizeOf(RecAddress);
  Status:= Btrv(22, fFileVar, RecAddress, AddressSize, SearchKey, 0, nil);
  if Status = 0 then
    begin
      Result:= RecAddress;
    end
  else Result:= -1;
end;

function TBtrieveDataset.RestorePosition(KeyValue: LongInt): integer;
var
  DummyKey: Str255;
begin
  FillChar(DummyKey,SizeOf(DummyKey),#0);
  Move(KeyValue, fDataRecord^, SizeOf(KeyValue));
  Result:= Btrv(23, fFileVar, fDataRecord^, fBufferSize, DummyKey[1], fSearchIndex, nil);
end;

function TBtrieveDataset.Field(DatasetID: integer; FieldName: string): variant;
var
ColIndex: integer;
begin
  Result:= '';
  if (fCursor < Low(fDataset)) or (fCursor > High(fDataset)) then Exit;
//  if fDataset[fCursor] = Unassigned then Exit; //NF:

  if FieldName = fPrimaryKey then Result:= fDataset[fCursor][fFieldList.Count]
  else
  begin
    ColIndex:= fFieldList.IndexOf(FieldName);
    if ColIndex >= 0 then Result:= fDataset[fCursor][ColIndex];
  end;
end;

//*** Cursor Movement **********************************************************

procedure TBtrieveDataset.GetBlockFirst;
begin
  if Length(fDataset) <= 0 then Exit;
  fCursor:= 0;
end;

procedure TBtrieveDataset.GetBlockPrior;
begin
  if fCursor < 1 then Exit;
  dec(fCursor);
end;

procedure TBtrieveDataset.GetBlockNext;
begin
  if (fCursor < 0) or (fCursor >= High(fDataSet)) then Exit;
  inc(fCursor);
end;

procedure TBtrieveDataset.GetBlockLast;
begin
  if Length(fDataset) <= 0 then Exit;
  fCursor:= High(fDataSet);
end;

//*** Public Methods ***********************************************************

procedure TBtrieveDataset.CancelExtended;
begin
  fInternalRefresh:= true;
  fExtended:= nil;
  fExtendedInit:= nil;
end;

procedure TBtrieveDataset.InitExtended(ExtendedBuffer: Pointer; BufferSize: integer);
begin
  if not Assigned(OnFilterRecord) then raise EBtrieveDatasetError.Create('A FilterRecord event has not been assigned.');

  fInternalRefresh:= true;
  fExtendedInit:= ExtendedBuffer;
  fExtendedInitSize:= BufferSize;
end;

procedure TBtrieveDataset.SelectRecord(SelectType: TSelectType; RecordNo: integer);
var
Status: integer;
DummyKey: Str255;
begin
//  if Assigned(OnSelectRecord) then
//  begin
    Move(RecordNo, fDataRecord^, SizeOf(RecordNo));
    Status:= Btrv(23, fFileVar, fDataRecord^, fBufferSize, DummyKey[1], fSearchIndex, nil);
    if Status = 0 then begin
      fLastRecordPos := RecordNo; // NF: allows us to get the current record
      if Assigned(OnSelectRecord) then OnSelectRecord(Self, SelectType, RecordNo, fDataRecord);
    end;
//  end;
end;

//*** Helper Functions *********************************************************

function TBtrieveDataset.isWithinBounds(const SearchLow: Str255; const SearchHigh: Str255): boolean;
begin
//  Result:= (SearchLow >= fBoundLow) and (SearchLow <= fBoundHigh) and (SearchHigh >= fBoundLow) and (SearchHigh <= fBoundHigh);
  Result:= (Copy(SearchLow,1,Length(fSearchKey)) >= Copy(fBoundLow,1,Length(fSearchKey)))
  and (Copy(SearchLow,1,Length(fSearchKey)) <= Copy(fBoundHigh,1,Length(fSearchKey)))
  and (Copy(SearchHigh,1,Length(fSearchKey)) >= Copy(fBoundLow,1,Length(fSearchKey)))
  and (Copy(SearchHigh,1,Length(fSearchKey)) <= Copy(fBoundHigh,1,Length(fSearchKey)));
end;

function TBtrieveDataset.isValidExtended: boolean;
begin
  Result:= (SmallInt(fExtended^) = 1) and (fExtendedSize > 8);
  if not Result then ShowMessage('fExtendedSize: ' + inttostr(fExtendedSize) + ', Rec returned: ' + IntToStr(SmallInt(fExtended^)));
end;

procedure TBtrieveDataset.InitFieldList(FieldNames: string);
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

procedure TBtrieveDataset.SetBounds;
var
  iSeg, iCurrIndexNo, iSkipLength, iNoOfSegs, iRecLength, iStatus : integer;
  DBaseInfo                    :  record
    FS                      :  FileStatSpec;
    KeySegs                      :  array[1..MaxNoKeys] of KeySpec;
    AltColt                 :  AltColtSeq;
  end;
  KeyBuff                   :  Str255;

const
  Seg = 16;

begin
//    result := fSearchKey + #255#255#255#127 + StringOfChar(#255,255);
  iRecLength := SizeOf(DBaseInfo);
  iStatus := Btrv(15, fFileVar, DBaseInfo, iRecLength, KeyBuff[1], -1, nil);
  if iStatus = 0 then
  begin
    iNoOfSegs := Round((iRecLength - SizeOf(FileStatSpec) - SizeOf(AltColtSeq)) / SizeOf(KeySpec));
//    showmessage(intToStr(iNoOfSegs));
    iSkipLength := Length(fSearchKey);
    iCurrIndexNo := 0;
    FillChar(fBoundHigh,SizeOf(fBoundHigh),#0);
    fBoundHigh := fSearchKey;
    FillChar(fBoundLow,SizeOf(fBoundLow),#0);
    fBoundLow := fSearchKey;
    For iSeg := 1 to iNoOfSegs do
    begin
      with DBaseInfo.KeySegs[iSeg] do begin
        if (iSkipLength <= 0) and (iCurrIndexNo = fSearchIndex) then
        begin
//          if (ExtTypeVal = BInteger) and ((KeyFlags and ExtType) = ExtType)
          if (ExtTypeVal in [BInteger, BFloat]) and ((KeyFlags and ExtType) = ExtType)
          then begin
            case ExtTypeVal of
              BInteger : begin
                fBoundHigh := fBoundHigh + #255#255#255#127;
                fBoundLow := fBoundLow + #0#0#0#128;
              end;

              BFloat : begin
{                fBoundHigh := fBoundHigh + #118#59#119#48#209#66#238#127;
//                fBoundLow := fBoundLow + #1#0#0#0#0#0#0#0
                fBoundLow := fBoundLow + #0#0#0#0#0#0#0#0}

                fBoundHigh := fBoundHigh + #124#59#119#48#209#66#238#127;
                fBoundLow := fBoundLow + #0#200#78#103#109#193#171#195;
              end;
            end;{case}
          end
          else begin
            fBoundHigh := fBoundHigh + StringOfChar(#255,KeyLen);
            fBoundLow := fBoundLow + StringOfChar(#0,KeyLen);
          end
        end;
        iSkipLength := iSkipLength - KeyLen;
        if ((KeyFlags and Seg) <> Seg) then Inc(iCurrIndexNo);
      end;
    end;{for}
//      result := fSearchKey + #255#255#255#127 + StringOfChar(#255,255);
  end
  else begin
    fBoundHigh := StringOfChar(#255,255);
    fBoundLow := fSearchKey + StringOfChar(#0, 255);
  end;

//  fBoundLow := fSearchKey + StringOfChar(#0, 255);

  // NF: allows integer indexes to be used
//  if (fSearchDataType = dtInteger) then fBoundHigh := FullNomKey(2147483647)
//  if (fSearchDataType = dtInteger) then fBoundHigh := fSearchKey + StringOfChar(#255,255)
//  if (fSearchDataType = dtInteger) then fBoundHigh := fSearchKey + #255#255#255#127 + StringOfChar(#255,255)
//  else fBoundHigh:= fSearchKey + StringOfChar(#255, 255);
end;{SetBounds}

//*** Property Handling ********************************************************

procedure TBtrieveDataset.SetSearchKey(NewSearchKey: Str255);
begin
  fInternalRefresh:= true;

  fSearchKey:= NewSearchKey;

  SetBounds;

//  fBoundLow:= NewSearchKey + StringOfChar(#0, 255);

  // NF: allows integer indexes to be used
//  if (fSearchDataType = dtInteger) then fBoundHigh := FullNomKey(2147483647)
//  else fBoundHigh:= NewSearchKey + StringOfChar(#255, 255);
end;

procedure TBtrieveDataset.SetSearchIndex(NewIndex: byte);
begin
  fSearchIndex := NewIndex;
end;

//******************************************************************************

function TBtrieveDataset.GetRecord : Pointer;
begin
  if (RestorePosition(fLastRecordPos) = 0)
  then Result := fDataRecord
  else Result := nil;
end;

end.
