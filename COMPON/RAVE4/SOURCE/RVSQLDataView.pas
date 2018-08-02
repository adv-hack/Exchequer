{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

unit RVSQLDataView;

interface

{$I RPVer.pas}

{ TODO 3 : Changing event support }

uses
  Classes,
  DB,
  LinkIL,
  RVClass, RVData, RVDatabase, RVDefine;

type
  TRaveSQLDataView = class(TRaveBaseDataView)
  protected
    FActive: boolean;
    FDatabase: TRaveDatabase;
    FDataBuffer: TRaveDataBuffer;
    FDataset: TDataset;
    FDBLink: TILLink;
    FParams: TStringList;
    FSQL: string;
    FQueryStruct: string;
    //
    procedure GetRow(EventType: integer); override;
    procedure SetActive(const AValue: boolean);
    procedure SetParams(AParams: TStringList);
    procedure Changing(OldItem: TRaveComponent;
                       NewItem: TRaveComponent); override;
  public
    procedure CreateFields(AFieldList: TList); override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open; override;
    procedure Close; override;
    procedure SetFilter(FilterList: TStringList); override;
    procedure SetRemoteSort(SortList: TStringList); override;
    //
    property Active: boolean read FActive write SetActive;
  published
    property Database: TRaveDatabase read FDatabase write FDatabase;
    property Params: TStringList read FParams write SetParams;
    property QueryStruct: string read FQueryStruct write FQueryStruct;
    property SQL: string read FSQL write FSQL;
  end; { TRaveSQLDataView }

  procedure RaveRegister;

implementation

uses
  RPDefine, RVDataField, RVUtil,
  SysUtils,
  TypInfo;

procedure RaveRegister;
begin { RaveRegister }
{TransOff}
  RegisterRaveComponents('',[TRaveSQLDataView]);
  RegisterRaveDataObject('SQL Data View',TRaveSQLDataView);

{!!! RegisterRaveModuleClasses('RVData',[TRaveSQLDataView]); }

{$IFDEF DESIGNER}
  RegisterRaveProperties(TRaveSQLDataView,
   {Beginner}     'Database;SQL',
   {Intermediate} '',
   {Developer}    '',
   {Hidden}       'QueryStruct;Params');

  SetPropDesc(TRaveSQLDataView,'Database',Trans('Defines the database component ' +
   'used to gain connections to the data.'));
  SetPropDesc(TRaveSQLDataView,'Params',Trans('Defines the source of data for ' +
   'parameters (i.e. ":ParamName") defined in the SQL property.  Each line should ' +
   'be a parameter name=data text pair.'));
  SetPropDesc(TRaveSQLDataView,'SQL',Trans('Defines the SQL that will be used to ' +
   'generate a result set from the database.'));
{$ENDIF}
{TransOn}
end;

{ TRaveSQLDataView }

procedure TRaveSQLDataView.Close;
begin
  //no inherited;
  if Active then begin
    FDataset.Free;
    FDatabase.ReleaseLink(FDBLink);
    FDatabase.Close;
    FDBLink := nil;
    DataOpened := false;
    FActive := false;
  end;
end;

procedure TRaveSQLDataView.CreateFields(AFieldList: TList);
var
  i: integer;
  FieldInfo: TRaveDataFieldInfo;
begin
  Open; try
    for i := 0 to FDataset.FieldCount - 1 do begin
      FieldInfo := TRaveDataFieldInfo.Create;
      FieldInfo.FieldName := FDataset.Fields[i].FieldName;
      FieldInfo.DataType := TRPDataSetType[FDataset.Fields[i].DataType];
      FieldInfo.Width := FDataset.Fields[i].DataSize;
      If FDataset.Fields[i].DisplayName = FDataset.Fields[i].FieldName then begin
        FieldInfo.FullName := '';
      end else begin
        FieldInfo.FullName := FDataset.Fields[i].DisplayName;
      end; { else }
      FieldInfo.Description := '';
      AFieldList.Add(FieldInfo);
    end;
  finally Close; end;
end;

constructor TRaveSQLDataView.Create(AOwner: TComponent);
begin
  inherited;
  FParams := TStringList.Create;
  FDataBuffer := TRaveDataBuffer.Create;
end;

destructor TRaveSQLDataView.Destroy;
begin
  FreeAndNil(FDataBuffer);
  Close;
  FreeAndNil(FParams);
  inherited;
end;

procedure TRaveSQLDataView.Changing(OldItem: TRaveComponent;
                                    NewItem: TRaveComponent);

begin { Changing }
  inherited Changing(OldItem,NewItem);
  If Assigned(Database) and (OldItem = Database) then begin
    Database := NewItem as TRaveDatabase;
  end; { if }
end;  { Changing }

procedure TRaveSQLDataView.GetRow(EventType: integer);
type
  TGraphicHeader = record
    Count: word; { Fixed at 1 }
    HType: word; { Fixed at $0100 }
    Size: longint; { Size not including header }
  end; { TGraphicHeader }
var
  I1: integer;
  DR: TRaveDataRow;
  Field: TRaveDataField;
  DataSetField: TField;
  Stream: TMemoryStream;
  P1: pointer;
  I2: integer;
  Header: TGraphicHeader;
begin { GetRow }
  If DataOpened then begin
  // Process EventType
    Case EventType of
      DATAFIRST: begin
        FDataSet.First;
        AtEOF := FDataSet.EOF;
      end;
      DATANEXT: begin
        FDataSet.Next;
        AtEOF := FDataSet.EOF;
      end;
      DATAGETROW: begin
        AtEOF := FDataSet.BOF and FDataSet.EOF;
      end;
    end; { case }

    If AtEOF then begin
      If Saving then begin { Mark last item as EOF }
        If EventType = DATAFIRST then begin { Add dummy record }
          FEmpty := true;
          AddValueListItem;
        end; { if }
        ValueListTail.DataRowType := rtLast;
      end; { if }
    end else begin
    // Read current row into DataBuffer
      FDataBuffer.Init(FieldNameList.Count);
      For I1 := 0 to FieldNameList.Count - 1 do begin
        Field := TRaveDataField(FieldNameList.Objects[I1]);
        If Field = nil then Continue; //!!!
        If Field.Calculated then begin
        //!!!
        end else begin
          DataSetField := FDataSet.FieldByName(Field.FieldName);
          With DataSetField do begin
            If IsNull then begin
              FDataBuffer.WriteNullData;
            end else begin
              Case TRPDataSetType[DataType] of
                dtString: begin
                  FDataBuffer.WriteStrData(DisplayText,AsString);
                end;
                dtInteger: begin
                  FDataBuffer.WriteIntData(DisplayText,AsInteger);
                end;
                dtBoolean: begin
                  FDataBuffer.WriteBoolData(DisplayText,AsBoolean);
                end;
                dtFloat: begin
                  FDataBuffer.WriteFloatData(DisplayText,AsFloat);
                end;
                dtCurrency: begin
                  FDataBuffer.WriteCurrData(DisplayText,AsCurrency);
                end;
                dtBCD: begin
                  FDataBuffer.WriteBCDData(DisplayText,AsCurrency);
                end;
                dtDate, dtTime, dtDateTime: begin
                  FDataBuffer.WriteDateTimeData(DisplayText,AsDateTime);
                end;
                dtBlob, dtMemo, dtGraphic: begin
                  Stream := TMemoryStream.Create;
                  try
                   TBlobField(DataSetField).SaveToStream(Stream);
                    P1 := Stream.Memory;
                    I2 := Stream.Size;
                    If TRPDataSetType[DataType] = dtGraphic then begin
                      Move(P1^,Header,SizeOf(Header));
                      If (Header.Count = 1) and (Header.HType = $0100) and
                       (Header.Size = (I2 - SizeOf(Header))) then begin
                        P1 := pointer(PChar(P1) + 8);
                        I2 := I2 - 8;
                      end; { if }
                    end; { if }
                    FDataBuffer.WriteBlobData(P1^,I2);
                  finally
                    Stream.Free;
                  end; { tryf }
                end;
              end; { case }
            end; { else }
          end; { with }
        end; { else }
      end; { for }

    // Assign to data row
      If Saving then begin { Create value list item }
        AddValueListItem;
        If EventType = DATAFIRST then begin
          ValueListTail.DataRowType := rtFirst;
        end; { if }
        DR := ValueListTail;
      end else begin { Use DataView DataRow }
        DR := DataRow;
      end; { else }

    // Get Row Data
      DR.Init(FDataBuffer.BufferSize);
      Move(FDataBuffer.Buffer^,DR.DataPtr^,FDataBuffer.BufferSize);
    end; { else }
  end else begin
    AtEOF := true;
    AbortReport(self);
  end; { else }
end;  { GetRow }

procedure TRaveSQLDataView.Open;
var
  I1, I2: integer;
  DataSetField: TField;
  RaveField: TRaveDataField;
  LParams: TStringList;
begin
  //no inherited;
  if not Active then begin
    if FDatabase = nil then begin
      raise exception.Create('Database is nil.');
    end;
    FDatabase.Open;
    FDBLink := FDatabase.GetLink;

    LParams := TStringList.Create; try
      LParams.Assign(Params);
      for I1 := 0 to LParams.Count - 1 do begin
        LParams.Values[LParams.Names[I1]] := ProcessDataStr(self,nil,
         LParams.Values[LParams.Names[I1]]);
      end; { for }
      FDataset := FDBLink.Query(SQL, true, LParams);
    finally LParams.Free; end;

    // Build FieldNameList from DataSet.TField components
    FieldNameList.Clear;
    For I1 := 0 to FDataSet.FieldCount - 1 do begin
      DataSetField := FDataSet.Fields[I1];
      // Find matching TRaveDataField component
      RaveField := nil;
      For I2 := 0 to ChildCount - 1 do begin
        If CompareText(TRaveDataField(Child[I2]).FieldName,DataSetField.FieldName) = 0 then begin
          RaveField := TRaveDataField(Child[I2]);

          If RaveField.DataType <> TRPDataSetType[DataSetField.DataType] then begin
            RaveError(Trans(Format(
            {Trans+}'Field %0:s:%1:s.  Datatype expected: %2:s  Datatype found: %3:s',
            [Name,RaveField.FieldName,
             GetEnumName(TypeInfo(TRPDataType),Ord(RaveField.DataType)),
             GetEnumName(TypeInfo(TRPDataType),Ord(TRPDataSetType[DataSetField.DataType]))])));
            RaveField := nil;
          end; { if }
          Break;
        end; { if }
      end; { for }
      If Assigned(RaveField) then begin
        RaveField.DataIndex := I1;
      end; { if }
      FieldNameList.AddObject(StripJoinChars(DataSetField.FieldName),RaveField);
    end; { for }

    DataOpened := true;
    FActive := true;
  end;
end;

procedure TRaveSQLDataView.SetActive(const AValue: boolean);
begin
  if AValue then begin
    Open;
  end else begin
    Close;
  end;
end;

procedure TRaveSQLDataView.SetFilter(FilterList: TStringList);
begin
  Close;
  Open;
end;

procedure TRaveSQLDataView.SetRemoteSort(SortList: TStringList);
begin
  raise Exception.Create('SetRemoteSort not supported.');
end;

procedure TRaveSQLDataView.SetParams(AParams: TStringList);
begin
  FParams.Assign(AParams);
end;

initialization
  RegisterProc('RVCL',RaveRegister);
end.