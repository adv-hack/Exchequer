{*************************************************************************}
{ Rave Reports version 4.0                                                }
{ Copyright (c), 1995-2001, Nevrona Designs, all rights reserved          }
{*************************************************************************}

{.$DEFINE DBG} { Used for data connection thread debugging }

unit RPCon;

interface

uses
  Windows, SysUtils, Classes, Forms, RPDefine;

const
  DataConVersion: longint = 30003; { 3.0003 }

type
  TRPCustomConnection = class;
  TRPConnectorEvent = procedure(Connection: TRPCustomConnection) of object;
  TRPEOFEvent = procedure(    Connection: TRPCustomConnection;
                          var Eof: boolean) of object;
  TRPValidateRowEvent = procedure(    Connection: TRPCustomConnection;
                                  var ValidRow: boolean) of object;
  TRuntimeVisibility = (rtNone,rtDeveloper,rtEndUser);

  TDataConnectManager = class
  protected
    FConnectList: TList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddConnection(Connection: TRPCustomConnection);
    procedure RemoveConnection(Connection: TRPCustomConnection);
    function FindConnection(ConnectName: string): TRPCustomConnection;
  end; { TDataConnectManager }

  TDataConnectThread = class(TThread)
  protected
    SyncMethod: TThreadMethod;
    SyncRan: boolean;
    FDataCon: TRPCustomConnection;
    procedure SyncExecute;
    procedure DoEvent(AMethod: TThreadMethod);
  public
    procedure Execute; override;
    property DataCon: TRPCustomConnection read FDataCon write FDataCon;
  end; { TDataConnectThread }

  TDataConnectFieldDef = class
  protected
    FDataType: TRPDataType;
    FFieldName: string;
    FIncluded: boolean;
    FFieldIndex: integer;
    StrData: string;
    BinData: pointer;
    DataSize: integer;
  public
    constructor Create(ADataType: TRPDataType;
                       AFieldName: string;
                       AIncluded: boolean);
    destructor Destroy; override;
    procedure Clear;
    procedure SetFilter(var Value);
    function FilterValid(var Value): boolean;

    property DataType: TRPDataType read FDataType;
    property FieldIndex: integer read FFieldIndex write FFieldIndex;
    property FieldName: string read FFieldName;
    property Included: boolean read FIncluded;
  end; { TDataConnectFieldDef }

  TRPCustomConnection = class(TRPComponent)
  protected
  {$IFDEF DBG}
    DebugMap: THandle; { Handle to MMF }
    DebugBuf: PChar; { Pointer to MMF }
  {$ENDIF}
    NormFileMap: THandle; { Handle to normal MMF }
    NormFileBuf: PChar; { Pointer to normal MMF }
    AltFileMap: THandle; { Handle to alternate MMF }
    AltFileBuf: PChar; { Pointer to alternate MMF }
    CurrentMapSize: longint; { Size of current MMF }
    CurrentFileMap: byte; { 0=FileBuf; 1=AltFileBuf[1]; 2=AltFileBuf[2] }
    FileBuf: PChar; { Pointer to current MMF }
    FilePtr: PChar; { Utility pointer for accessing FileBuf }
    RowHeaderPtr: PChar; { Where the row header in FileBuf is stored }
    ErrorResult: boolean; { Is an error result being sent back? }

    Thread: TDataConnectThread;
    Runtime: boolean; { Are we in runtime or design-time? }
    ModeStr: string; { Runtime mode string DT or RT }
    ThreadDone: boolean;
    FieldDefList: TList; { List of TDataConnectFieldDef }
    FieldIdx: integer; { Which field is being written, starts at 0 }
    IncludedFieldIdx: integer; { FieldIdx if non-included fields are removed }
    FDataIndex: integer; { Utility index for custom connections }
    FDataRows: integer; { Utility row count for custom connections }
    FFilterFieldName: string; { Filter field name from GetFilterItem }
    FFilterFieldOp: string; { Filter field operator from GetFilterItem }
    FFilterFieldData: string; { Filter field data from GetFilterItem }

    FLocalFilter: boolean; { Use local filtering? }
    LocalFilterValid: boolean; { Does this record pass local filtering rules? }
    FRTVisible: TRuntimeVisibility; { Visibility of data at runtime }
    FFieldAliasList: TStrings; { List of Field Aliases }

    FOnFirst: TRPConnectorEvent;
    FOnNext: TRPConnectorEvent;
    FOnEOF: TRPEOFEvent;
    FOnGetCols: TRPConnectorEvent;
    FOnGetRow: TRPConnectorEvent;
    FOnSetFilter: TRPConnectorEvent;
    FOnGetSorts: TRPConnectorEvent;
    FOnSetSort: TRPConnectorEvent;
    FOnOpen: TRPConnectorEvent;
    FOnRestore: TRPConnectorEvent;
    FOnValidateRow: TRPValidateRowEvent;

  {$IFDEF DBG}
    procedure Dbg(Value: string);
    procedure TDbg(Value: string);
  {$ENDIF}
    procedure ClearFieldDefs;
    procedure ClearFilterData;
    procedure CheckDataType(ValidDataTypes: TRPDataTypeSet);
    procedure AddingNative;
    procedure AddingFormatted;
    procedure AllocateSpace(AddSize: longint);
    function LocalFilterAbort(var FilterData): boolean;
    procedure SetRTVisible(Value: TRuntimeVisibility);
    procedure ReturnError(Msg: string;
                          ErrorType: TRaveConnectionError);
    procedure ReadVisible(Reader: TReader);
    procedure DefineProperties(Filer: TFiler); override;
    procedure SetFieldAliasList(Value: TStrings);
    function GetFieldAlias(FieldName: string): string;
    procedure NextField;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  { Utility methods }
    procedure WriteStr(Value: string);
    procedure WriteInt(Value: longint);
    procedure WriteInt64(Value: Int64);
    procedure WriteBool(Value: boolean);
    procedure WriteFloat(Value: extended);
    procedure WriteCurr(Value: currency);
    procedure WriteDateTime(Value: TDateTime);
    procedure WriteBuf(var Buffer;
                           Len: integer);
    procedure WriteField(Name: string;
                         DataType: TRPDataType;
                         Width: integer;
                         FullName: string;
                         Description: string);
    procedure WriteNullData;
    procedure WriteStrData(FormatData: string;
                           NativeData: string);
    procedure WriteIntData(FormatData: string;
                           NativeData: integer);
    procedure WriteInt64Data(FormatData: string;
                             NativeData: Int64);
    procedure WriteBoolData(FormatData: string;
                            NativeData: boolean);
    procedure WriteFloatData(FormatData: string;
                             NativeData: extended);
    procedure WriteCurrData(FormatData: string;
                            NativeData: currency);
    procedure WriteBCDData(FormatData: string;
                           NativeData: currency);
    procedure WriteDateTimeData(FormatData: string;
                                NativeData: TDateTime);
    procedure WriteBlobData(var Buffer;
                                Len: longint);
    function ReadStr: string;
    function ReadInt: integer;
    function ReadBool: boolean;
    function ReadFloat: extended;
    function ReadCurr: currency;
    function ReadDateTime: TDateTime;
    procedure ReadBuf(var Buffer;
                          Len: integer);
    function CurrentFieldDef: TDataConnectFieldDef;
    function FindFieldDef(FieldName: string): TDataConnectFieldDef;
    function ReadFilterItem(var FieldName: string;
                            var FieldOp: string;
                            var FieldData: string): boolean;
    function GetFilterItem: boolean;
    procedure ClearBuffer;
    procedure FixupBufferHeader;
    procedure ClearBufferHeader;

    procedure ExecFirst;
    procedure ExecNext;
    procedure ExecEOF;
    function GetEOF: boolean;
    procedure ExecGetCols;
    procedure ExecGetRow;
    procedure ExecSetFilter;
    procedure ExecGetSorts;
    procedure ExecSetSort;
    procedure ExecOpen;
    procedure ExecRestore;
    function ExecValidateRow: boolean;

  { Thread Event methods }
    procedure DoFirst; virtual;
    procedure DoNext; virtual;
    function DoEOF: boolean; virtual;
    procedure DoGetCols; virtual;
    procedure DoGetRow; virtual;
    procedure DoSetFilter; virtual;
    procedure DoGetSorts; virtual;
    procedure DoSetSort; virtual;
    procedure DoOpen; virtual;
    procedure DoRestore; virtual;
    function DoValidateRow: boolean; virtual;

    property DataIndex: integer read FDataIndex write FDataIndex;
    property DataRows: integer read FDataRows write FDataRows;
    property FilterFieldName: string read FFilterFieldName;
    property FilterFieldOp: string read FFilterFieldOp;
    property FilterFieldData: string read FFilterFieldData;
  published
    property FieldAliasList: TStrings read FFieldAliasList write SetFieldAliasList;
    property LocalFilter: boolean read FLocalFilter write FLocalFilter default true;
    property RuntimeVisibility: TRuntimeVisibility read FRTVisible write SetRTVisible
     stored true;
    property OnFirst: TRPConnectorEvent read FOnFirst write FOnFirst;
    property OnNext: TRPConnectorEvent read FOnNext write FOnNext;
    property OnEOF: TRPEOFEvent read FOnEOF write FOnEOF;
    property OnGetCols: TRPConnectorEvent read FOnGetCols write FOnGetCols;
    property OnGetRow: TRPConnectorEvent read FOnGetRow write FOnGetRow;
    property OnSetFilter: TRPConnectorEvent read FOnSetFilter write FOnSetFilter;
    property OnGetSorts: TRPConnectorEvent read FOnGetSorts write FOnGetSorts;
    property OnSetSort: TRPConnectorEvent read FOnSetSort write FOnSetSort;
    property OnOpen: TRPConnectorEvent read FOnOpen write FOnOpen;
    property OnRestore: TRPConnectorEvent read FOnRestore write FOnRestore;
    property OnValidateRow: TRPValidateRowEvent read FOnValidateRow write FOnValidateRow;
  end; { TRPCustomConnection }

var
  DataConnectManager: TDataConnectManager;
  ManualSync: boolean = false;

  procedure ExecSyncMethod;

implementation

uses
  TypInfo;

(*****************************************************************************}
( class TDataConnectManager
(*****************************************************************************)

  constructor TDataConnectManager.Create;

  begin { Create }
    inherited Create;
    FConnectList := TList.Create;
  end;  { Create }

  destructor TDataConnectManager.Destroy;

  begin { Destroy }
    FConnectList.Free;
    inherited Destroy;
  end;  { Destroy }

  procedure TDataConnectManager.AddConnection(Connection: TRPCustomConnection);

  begin { AddConnection }
    FConnectList.Add(Connection);
  end;  { AddConnection }

  procedure TDataConnectManager.RemoveConnection(Connection: TRPCustomConnection);

  begin { RemoveConnection }
    FConnectList.Remove(Connection);
  end;  { RemoveConnection }

  function TDataConnectManager.FindConnection(ConnectName: string): TRPCustomConnection;

  var
    I1: integer;

  begin { FindConnection }
    For I1 := 0 to FConnectList.Count - 1 do begin
      Result := TRPCustomConnection(FConnectList[I1]);
      If CompareText(Result.Name,ConnectName) = 0 then begin
        Exit;
      end; { if }
    end; { for }
    Result := nil;
  end;  { FindConnection }

(*****************************************************************************}
( class TDataConnectThread
(*****************************************************************************)

var
  DataConMethod: TThreadMethod = nil;

  procedure ExecSyncMethod;

  begin { ExecSyncMethod }
    If Assigned(DataConMethod) then begin
      try
        DataConMethod;
      finally
        DataConMethod := nil;
      end; { tryf }
    end; { if }
  end;  { ExecSyncMethod }

  procedure TDataConnectThread.SyncExecute;

  begin { SyncExecute }
    try
      SyncMethod;
    except
    {!!! Log error message and report back to controller }
    end; { tryx }
    SyncRan := true;
  end;  { SyncExecute }

  procedure TDataConnectThread.DoEvent(AMethod: TThreadMethod);

  begin { DoEvent }
    SyncMethod := AMethod;
    SyncRan := false;
    If ManualSync then begin
      DataConMethod := SyncExecute;
    end else begin
      Synchronize(SyncExecute);
    end; { else }
    While not SyncRan do begin
      Sleep(0);
    end; { while }
  end;  { DoEvent }

  procedure TDataConnectThread.Execute;

  var
    I1: integer;
    WaitResult: DWORD;
    EventList: array[1..2] of THandle;
    CompletedEvent: THandle;
    CompletedXTEvent: THandle;
    ConnectEvent: THandle;
    DisconnectEvent: THandle;
    DataEvent: THandle;
    Connected: boolean;
    OldDataConName: string;

  begin { Execute }
    Connected := false;
    With DataCon do begin
      {$IFDEF DBG}TDbg({Trans-}'Begin');{$ENDIF}
    { Create Events }
      CompletedEvent := InitEvent(CompletedEventName);
      DisconnectEvent := InitManualEvent(DisconnectEventName);
      ConnectEvent := InitEvent(ConnectEventName);
      OldDataConName := '!';
      DataEvent := 0;
      CompletedXTEvent := 0;
      try
        Repeat
          If OldDataConName <> Name then begin { Recreate named events }
            If DataEvent <> 0 then begin
              CloseHandle(DataEvent);
            end; { if }
            If CompletedXTEvent <> 0 then begin
              CloseHandle(CompletedXTEvent);
            end; { if }
            If Runtime then begin
              DataEvent := InitEvent(DataRTEventName + Name);
              CompletedXTEvent := InitEvent(AcknowledgeRTEventName + Name);
            end else begin
              DataEvent := InitEvent(DataDTEventName + Name);
              CompletedXTEvent := InitEvent(AcknowledgeDTEventName + Name);
            end; { else }
            OldDataConName := Name;
          end; { if }
          EventList[1] := DataEvent;
          If Connected then begin
            EventList[2] := DisconnectEvent;
          end else begin
            EventList[2] := ConnectEvent;
          end; { else }
          WaitResult := WaitForMultipleObjects(2,@EventList,false,1000);
          If not Terminated then begin
            If WaitResult = WAIT_OBJECT_0 then begin { Data Request }
              ClearBuffer;
              I1 := ReadInt;
              {$IFDEF DBG}TDbg({Trans-}'Received Data Request #' + IntToStr(I1));{$ENDIF}
              Case I1 of
                DATAFIRST: begin
                  DoEvent(ExecFirst);
                end;
                DATANEXT: begin
                  DoEvent(ExecNext);
                end;
                DATAEOF: begin
                  DoEvent(ExecEOF);
                end;
                DATAGETCOLS: begin
                  DoEvent(ExecGetCols);
                end;
                DATAGETROW: begin
                  DoEvent(ExecGetRow);
                end;
                DATASETFILTER: begin
                  DoEvent(ExecSetFilter);
                end;
                DATAGETSORTS: begin
                  DoEvent(ExecGetSorts);
                end;
                DATASETSORT: begin
                  DoEvent(ExecSetSort);
                end;
                DATAOPEN: begin
                  DoEvent(ExecOpen);
                end;
                DATARESTORE: begin
                  DoEvent(ExecRestore);
                end;
                DATAACKNOWLEDGE: begin
                  ClearBuffer;
                  WriteStr(Name);
                  WriteBool(Runtime);
                  WriteInt(Application.Handle); { Application Handle }
                  WriteInt(integer(FDataCon)); { Connection Handle }
                  WriteInt(DataConVersion); { Version }
                  WriteInt(integer(DataCon.RuntimeVisibility)); { Runtime visibility }
                end;
                DATAFREEALTBUF: begin
                  If CurrentFileMap > 0 then begin
                    UnmapViewOfFile(AltFileBuf);
                    CloseHandle(AltFileMap);
                    CurrentFileMap := 0;
                    CurrentMapSize := FileMapSize;
                    FileBuf := NormFileBuf;
                    FilePtr := FileBuf;
                  end; { if }
                end;
              end; { case }
              If I1 = DATAACKNOWLEDGE then begin
                {$IFDEF DBG} If Runtime then begin
                  TDbg({Trans-}'Signal AckRTCompleted');
                end else begin
                  TDbg({Trans-}'Signal AckDTCompleted');
                end; {$ENDIF}
                SetEvent(CompletedXTEvent);
              end else begin
                If not ErrorResult then begin
                  {$IFDEF DBG}TDbg({Trans-}'Signal Completed');{$ENDIF}
                  SetEvent(CompletedEvent); { Signal Completed }
                end; { if }
              end; { else }
            end else if WaitResult = (WAIT_OBJECT_0 + 1) then begin { Connect Request }
              Connected := not Connected;
              If Connected then begin
                {$IFDEF DBG}TDbg({Trans-}'Received Connect Request');{$ENDIF}
                ClearBuffer; { Copy data connection name to buffer }
                WriteStr(Name);
                WriteBool(Runtime);
                WriteInt(Application.Handle);
                WriteInt(integer(FDataCon));
                WriteInt(DataConVersion);
                WriteInt(integer(DataCon.RuntimeVisibility));
                {$IFDEF DBG}TDbg({Trans-}'Signal Completed');{$ENDIF}
                SetEvent(CompletedEvent); { Signal Completed }
              end else begin
                {$IFDEF DBG}TDbg({Trans-}'Received Disconnect Request');{$ENDIF}
              end; { else }
            end; { else }
          end else begin
            {$IFDEF DBG}TDbg({Trans-}'Received Terminate Request (' + IntToStr(WaitResult) + ')');{$ENDIF}
          end; { else }
          ErrorResult := false;
        until Terminated;
      finally
        CloseHandle(CompletedXTEvent);
        CloseHandle(CompletedEvent);
        CloseHandle(ConnectEvent);
        CloseHandle(DisconnectEvent);
        CloseHandle(DataEvent);
        ThreadDone := true;
      end; { tryf }
      {$IFDEF DBG}TDbg({Trans-}'End');{$ENDIF}
    end; { with }
  end;  { Execute }

(*****************************************************************************}
( class TDataConnectFieldDef
(*****************************************************************************)

const
  DataTypeSize: array[TRPDataType] of byte = (SizeOf(string),SizeOf(integer),
   SizeOf(boolean),SizeOf(Extended),SizeOf(Currency),SizeOf(Currency),
   SizeOf(TDateTime),SizeOf(TDateTime),SizeOf(TDateTime),0,0,0,SizeOf(Int64));

  constructor TDataConnectFieldDef.Create(ADataType: TRPDataType;
                                          AFieldName: string;
                                          AIncluded: boolean);

  begin { Create }
    inherited Create;
    FDataType := ADataType;
    FFieldName := AFieldName;
    FIncluded := AIncluded;
  end;  { Create }

  destructor TDataConnectFieldDef.Destroy;

  begin { Destroy }
    Clear;
    inherited Destroy;
  end;  { Destroy }

  procedure TDataConnectFieldDef.Clear;

  begin { Clear }
    If DataType = dtString then begin
      StrData := '';
    end else begin
      If DataSize > 0 then begin
        FreeMem(BinData,DataSize);
        BinData := nil;
      end; { if }
    end; { else }
    DataSize := 0;
  end;  { Clear }

  procedure TDataConnectFieldDef.SetFilter(var Value);

  begin { SetFilter }
    Clear;
    DataSize := DataTypeSize[DataType];
    If DataType = dtString then begin
      StrData := string(Value);
    end else begin
      If DataSize > 0 then begin
        GetMem(BinData,DataSize);
        Case DataType of
          dtInteger: integer(BinData^) := integer(Value);
          dtBoolean: boolean(BinData^) := boolean(Value);
          dtFloat: extended(BinData^) := extended(Value);
          dtCurrency,dtBCD: currency(BinData^) := currency(Value);
          dtDate,dtTime,dtDateTime: TDateTime(BinData^) := TDateTime(Value);
        { dtBlob,dtMemo,dtGraphic }
        end; { case }
      end; { if }
    end; { else }
  end;  { SetFilter }

  function TDataConnectFieldDef.FilterValid(var Value): boolean;

  begin { FilterValid }
    Result := true;
    If DataSize > 0 then begin
      Case DataType of
        dtString: Result := CompareStr(StrData,string(Value)) = 0;
        dtInteger: Result := integer(BinData^) = integer(Value);
        dtBoolean: Result := boolean(BinData^) = boolean(Value);
        dtFloat: Result := Extended(BinData^) = Extended(Value);
        dtCurrency,dtBCD: Result := Currency(BinData^) = Currency(Value);
        dtDate,dtTime,dtDateTime: Result := TDateTime(BinData^) = TDateTime(Value);
      { dtBlob,dtMemo,dtGraphic }
      end; { case }
    end; { if }
  end;  { FilterValid }

(*****************************************************************************}
( class TRPCustomConnection
(*****************************************************************************)

  constructor TRPCustomConnection.Create(AOwner: TComponent);

  begin { Create }
    inherited Create(AOwner);
    FieldDefList := TList.Create;
    DataConnectManager.AddConnection(self);
    Runtime := not (csDesigning in ComponentState);
    If Runtime then begin
      ModeStr := {Trans-}'RT';
    end else begin
      ModeStr := {Trans-}'DT';
    end; { else }
    CurrentMapSize := FileMapSize;
    CurrentFileMap := 0;
    NormFileMap := InitFileMap(FileMapName,CurrentMapSize);
    NormFileBuf := InitFileBuf(NormFileMap);
    FileBuf := NormFileBuf;
  {$IFDEF DBG}
    DebugMap := InitDebugMap;
    DebugBuf := InitFileBuf(DebugMap);
  {$ENDIF}
    If not Runtime then begin { Always create thread in design-time }
      ThreadDone := false;
      Thread := TDataConnectThread.Create(true);
      Thread.FreeOnTerminate := true;
      Thread.DataCon := self;
      Thread.Resume;
    end else begin
      Thread := nil;
    end; { else }
    FLocalFilter := true;
    FRTVisible := rtDeveloper;
    FFieldAliasList := TStringList.Create;
  end;  { Create }

  destructor TRPCustomConnection.Destroy;

  var
    DataEvent: THandle;
    ControllerMutex: THandle;
    WaitResult: DWORD;

  begin { Destroy }
    DataConnectManager.RemoveConnection(self);
    If Assigned(Thread) then begin
      Thread.Terminate;

    { Try to gain control of RAVE Data Communication System }
      ControllerMutex := InitMutex(ControllerMutexName);
      try
      { Try safe terminate, otherwise just allow thread to terminate on its own }
        {$IFDEF DBG}Dbg({Trans-}'Attempt to Gain Control');{$ENDIF}
        WaitResult := WaitForSingleObject(ControllerMutex,1000);
        {$IFDEF DBG}Dbg({Trans-}'Received Control (' + IntToStr(WaitResult) + ')');{$ENDIF}
        If WaitResult = WAIT_OBJECT_0 then begin
          If Runtime then begin
            DataEvent := InitEvent(DataRTEventName + Name);
          end else begin
            DataEvent := InitEvent(DataDTEventName + Name);
          end; { else }
          try
            {$IFDEF DBG}Dbg({Trans-}'Signal Terminate (DataRequest)');{$ENDIF}
            SetEvent(DataEvent); { Signal Data Event with Terminated = true }
            Repeat
              Sleep(0);
            until ThreadDone;
          finally
            CloseHandle(DataEvent);
            {$IFDEF DBG}Dbg({Trans-}'Release Control');{$ENDIF}
            ReleaseMutex(ControllerMutex);
          end; { tryf }
        end; { if }
      finally
        CloseHandle(ControllerMutex);
      end; { tryf }
    end; { if }

  { Free resources }
    If CurrentFileMap > 0 then begin
      UnmapViewOfFile(AltFileBuf);
      CloseHandle(AltFileMap);
    end; { if }
    UnmapViewOfFile(NormFileBuf);
    CloseHandle(NormFileMap);
  {$IFDEF DBG}
    UnmapViewOfFile(DebugBuf);
    CloseHandle(DebugMap);
  {$ENDIF}
    ClearFieldDefs;
    FieldDefList.Free;
    FFieldAliasList.Free;

    inherited Destroy;
  end;  { Destroy }

  procedure TRPCustomConnection.ReturnError(Msg: string;
                                            ErrorType: TRaveConnectionError);

  var
    ErrorEvent: THandle;

  begin { ReturnError }
    ClearBuffer;
    WriteInt(Ord(ErrorType));
    WriteStr(Msg);
    ErrorResult := true;
    ErrorEvent := InitEvent(ErrorEventName);
    SetEvent(ErrorEvent);
    CloseHandle(ErrorEvent);
  end;  { ReturnError }

  procedure TRPCustomConnection.ReadVisible(Reader: TReader);

  begin { ReadVisible }
    If Reader.ReadBoolean then begin
      SetRTVisible(rtEndUser);
    end; { if }
  end;  { ReadVisible }

  procedure TRPCustomConnection.DefineProperties(Filer: TFiler);

  begin { DefineProperties }
    inherited DefineProperties(Filer);
    Filer.DefineProperty({Trans-}'Visible',ReadVisible,nil,false);
  end;  { DefineProperties }

  procedure TRPCustomConnection.SetRTVisible(Value: TRuntimeVisibility);

  begin { SetRTVisible }
    FRTVisible := Value;
    If not Assigned(Thread) and
     (FRTVisible in [rtDeveloper,rtEndUser]) then begin { Create thread }
      ThreadDone := false;
      Thread := TDataConnectThread.Create(true);
      Thread.FreeOnTerminate := true;
      Thread.DataCon := self;
      Thread.Resume;
    end; { if }
  end;  { SetRTVisible }

  procedure TRPCustomConnection.SetFieldAliasList(Value: TStrings);

  begin { SetFieldAliasList }
    FFieldAliasList.Assign(Value);
  end;  { SetFieldAliasList }

  function TRPCustomConnection.GetFieldAlias(FieldName: string): string;

  var
    I1: integer;
    I2: integer;
    S1: string;

  begin { GetFieldAlias }
    Result := FieldName;
    For I1 := 0 to FFieldAliasList.Count - 1 do begin
      S1 := FFieldAliasList[I1];
      I2 := Pos('=',S1);
      If (I2 > 0) and (CompareText(FieldName,Trim(Copy(S1,1,I2 - 1))) = 0) then begin
        Result := Trim(Copy(S1,I2 + 1,Length(S1) - I2));
        Exit;
      end; { if }
    end; { for }
  end;  { GetFieldAlias }

  procedure TRPCustomConnection.WriteStr(Value: string);

  var
    I1: integer;

  begin { WriteStr }
    I1 := Length(Value);
    WriteInt(I1);
    If I1 > 0 then begin
      Move(Value[1],FilePtr^,I1);
      Inc(FilePtr,I1);
    end; { if }
  end;  { WriteStr }

  procedure TRPCustomConnection.WriteInt(Value: longint);

  begin { WriteInt }
    longint(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(longint));
  end;  { WriteInt }

  procedure TRPCustomConnection.WriteInt64(Value: Int64);

  begin { WriteInt64 }
    Int64(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(Int64));
  end;  { WriteInt64 }

  procedure TRPCustomConnection.WriteBool(Value: boolean);

  begin { WriteBool }
    boolean(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(boolean));
  end;  { WriteBool }

  procedure TRPCustomConnection.WriteFloat(Value: extended);

  begin { WriteFloat }
    extended(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(extended));
  end;  { WriteFloat }

  procedure TRPCustomConnection.WriteCurr(Value: currency);

  begin { WriteCurr }
    currency(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(currency));
  end;  { WriteCurr }

  procedure TRPCustomConnection.WriteDateTime(Value: TDateTime);

  begin { WriteDateTime }
    TDateTime(pointer(FilePtr)^) := Value;
    Inc(FilePtr,SizeOf(TDateTime));
  end;  { WriteDateTime }

  procedure TRPCustomConnection.WriteBuf(var Buffer;
                                             Len: integer);

  begin { WriteBuf }
   Move(Buffer,FilePtr^,Len);
   Inc(FilePtr,Len);
  end;  { WriteBuf }

  procedure TRPCustomConnection.ClearFieldDefs;

  var
    I1: integer;

  begin { ClearFieldDefs }
    For I1 := 0 to (FieldDefList.Count - 1) do begin
      If Assigned(FieldDefList[I1]) then begin
        TDataConnectFieldDef(FieldDefList[I1]).Free;
      end; { if }
    end; { for }
    FieldDefList.Clear;
  end;  { ClearFieldDefs }

  procedure TRPCustomConnection.ClearFilterData;

  var
    I1: integer;

  begin { ClearFilterData }
    For I1 := 0 to (FieldDefList.Count - 1) do begin
      If Assigned(FieldDefList[I1]) then begin
        TDataConnectFieldDef(FieldDefList[I1]).Clear;
      end; { if }
    end; { for }
  end;  { ClearFilterData }

  function TRPCustomConnection.CurrentFieldDef: TDataConnectFieldDef;

  begin { CurrentFieldDef }
    If FieldIdx >= FieldDefList.Count then begin
      Result := nil;
    end else begin
      Result := TDataConnectFieldDef(FieldDefList[FieldIdx]);
    end; { else }
  end;  { CurrentFieldDef }

  procedure TRPCustomConnection.CheckDataType(ValidDataTypes: TRPDataTypeSet);

  begin { CheckDataType }
    If FieldIdx >= FieldDefList.Count then begin
      RaiseError(Trans('Attempt to write more fields than defined.'));
    end else begin
      If not (TDataConnectFieldDef(FieldDefList[FieldIdx]).DataType in ValidDataTypes) then begin
        RaiseError(Trans(Format({Trans+}
         'Attempt to write different data type than defined (Column %0:s/%1:s).',
         [IntToStr(FieldIdx + 1),IntToStr(FieldDefList.Count)])));
      end; { if }
    end; { else }
  end;  { CheckDataType }

  procedure TRPCustomConnection.WriteField(Name: string;
                                           DataType: TRPDataType;
                                           Width: integer;
                                           FullName: string;
                                           Description: string);

  var
    FieldDef: TDataConnectFieldDef;
    PrevFieldIndex: integer;
    FieldAlias: string;

  begin { WriteField }
    If FieldDefList.Count = 0 then begin
      PrevFieldIndex := -1;
    end else begin
      PrevFieldIndex := TDataConnectFieldDef(FieldDefList[FieldDefList.Count - 1]).FieldIndex;
    end; { else }

    FieldAlias := GetFieldAlias(Name);
    FieldDef := TDataConnectFieldDef.Create(DataType,Name,FieldAlias <> '');
    If FieldDef.Included then begin
      FieldDef.FieldIndex := PrevFieldIndex + 1;
      WriteStr('N');
      WriteStr(FieldAlias);
      If DataType <> dtString then begin
        WriteStr('T');
        WriteStr(GetEnumName(TypeInfo(TRPDataType),Ord(DataType)));
      end; { if }
      If Width > 0 then begin
        WriteStr('W');
        WriteStr(IntToStr(Width));
      end; { if }
      If FullName <> '' then begin
        WriteStr('L');
        WriteStr(FullName);
      end; { if }
      If Description <> '' then begin
        WriteStr('D');
        WriteStr(Description);
      end; { if }
      WriteStr('');
    end else begin
      FieldDef.FieldIndex := PrevFieldIndex;
    end; { else }
    FieldDefList.Add(FieldDef);
  end;  { WriteField }

  procedure TRPCustomConnection.AddingNative;

  begin { AddingNative }
    integer(pointer(RowHeaderPtr + (IncludedFieldIdx * 8))^) := FilePtr -
     RowHeaderPtr;
  end;  { AddingNative }

  procedure TRPCustomConnection.AddingFormatted;

  begin { AddingFormatted }
    integer(pointer(RowHeaderPtr + (IncludedFieldIdx * 8) + 4)^) := FilePtr -
     RowHeaderPtr;
  end;  { AddingFormatted }

  procedure TRPCustomConnection.AllocateSpace(AddSize: longint);

  var
    NewFileMapIdx: byte;
    NewFileMap: THandle;
    NewFileBuf: PChar;
    NewSize: longint;
    SavePtr: PChar;

  begin { AllocateSpace }
    If (FilePtr - FileBuf + AddSize) > CurrentMapSize then begin
      NewFileMapIdx := CurrentFileMap mod 2 + 1;
      NewSize := (FilePtr - FileBuf) + AddSize + 65536;

    { Create new file map }
      NewFileMap := InitFileMap(AltFileMapName + IntToStr(NewFileMapIdx),NewSize);
      NewFileBuf := InitFileBuf(NewFileMap);

    { Copy data from old buffer to new }
      Move(FileBuf^,NewFileBuf^,FilePtr - FileBuf);

    { Reassign utility pointers }
      FilePtr := NewFileBuf + (FilePtr - FileBuf);
      RowHeaderPtr := NewFileBuf + (RowHeaderPtr - FileBuf);

    { Free old alternate file map if necessary }
      If CurrentFileMap > 0 then begin
        UnmapViewOfFile(AltFileBuf);
        CloseHandle(AltFileMap);
      end; { if }

    { Write out NewFileMapIdx to normal buffer for redirect }
      SavePtr := FilePtr;
      FilePtr := NormFileBuf;
      WriteInt(0);
      WriteInt(NewFileMapIdx);
      FilePtr := SavePtr;

    { Assign new file map to Alt vars and status vars }
      AltFileMap := NewFileMap;
      AltFileBuf := NewFileBuf;
      CurrentMapSize := NewSize;
      CurrentFileMap := NewFileMapIdx;
      FileBuf := AltFileBuf;
    end; { if }
  end;  { AllocateSpace }

  function TRPCustomConnection.LocalFilterAbort(var FilterData): boolean;

  begin { LocalFilterAbort }
    If LocalFilter and LocalFilterValid then begin
      LocalFilterValid := CurrentFieldDef.FilterValid(FilterData);
    end; { if }
    Result := LocalFilter and not LocalFilterValid;
  end;  { LocalFilterAbort }

  procedure TRPCustomConnection.NextField;

  begin { NextField }
    If CurrentFieldDef.Included then begin
      Inc(IncludedFieldIdx);
    end; { if }
    Inc(FieldIdx);
  end;  { NextField }

  procedure TRPCustomConnection.WriteNullData;

  begin { WriteNullData }
    If LocalFilter and (CurrentFieldDef.DataSize <> 0) then begin
      LocalFilterValid := false;
    end; { if }
    If LocalFilterValid and CurrentFieldDef.Included then begin
      CheckDataType([Low(TRPDataType)..High(TRPDataType)]);
      integer(pointer(RowHeaderPtr + (IncludedFieldIdx * 8))^) := -1;
    end; { if }
    NextField;
  end;  { WriteNullData }

  procedure TRPCustomConnection.WriteStrData(FormatData: string;
                                             NativeData: string);

  begin { WriteStrData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtString]);
      If (NativeData <> FormatData) and (FormatData <> '') then begin
        AllocateSpace(Length(FormatData) + Length(NativeData) + 8);
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(Length(NativeData) + 4);
      end; { else }
      AddingNative;
      WriteStr(NativeData);
    end; { if }
    NextField;
  end;  { WriteStrData }

  procedure TRPCustomConnection.WriteIntData(FormatData: string;
                                             NativeData: integer);

  begin { WriteIntData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtInteger]);
      If (IntToStr(NativeData) <> FormatData) and (FormatData <> '') then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteInt(NativeData);
    end; { if }
    NextField;
  end;  { WriteIntData }

  procedure TRPCustomConnection.WriteInt64Data(FormatData: string;
                                               NativeData: Int64);

  begin { WriteInt64Data }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtInt64]);
      If (IntToStr(NativeData) <> FormatData) and (FormatData <> '') then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteInt64(NativeData);
    end; { if }
    NextField;
  end;  { WriteInt64Data }

  procedure TRPCustomConnection.WriteBoolData(FormatData: string;
                                              NativeData: boolean);

  begin { WriteBoolData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtBoolean]);
      If FormatData <> '' then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteBool(NativeData);
    end; { if }
    NextField;
  end;  { WriteBoolData }

  procedure TRPCustomConnection.WriteFloatData(FormatData: string;
                                               NativeData: extended);

  begin { WriteFloatData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtFloat]);
      If FormatData <> '' then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteFloat(NativeData);
    end; { if }
    NextField;
  end;  { WriteFloatData }

  procedure TRPCustomConnection.WriteCurrData(FormatData: string;
                                              NativeData: currency);

  begin { WriteCurrData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtCurrency]);
      If FormatData <> '' then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteCurr(NativeData);
    end; { if }
    NextField;
  end;  { WriteCurrData }

  procedure TRPCustomConnection.WriteBCDData(FormatData: string;
                                             NativeData: currency);

  begin { WriteBCDData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtBCD]);
      If FormatData <> '' then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteCurr(NativeData);
    end; { if }
    NextField;
  end;  { WriteBCDData }

  procedure TRPCustomConnection.WriteDateTimeData(FormatData: string;
                                                  NativeData: TDateTime);

  begin { WriteDateTimeData }
    If CurrentFieldDef.Included and not LocalFilterAbort(NativeData) then begin
      CheckDataType([dtDateTime,dtDate,dtTime]);
      If FormatData <> '' then begin
        AllocateSpace(Length(FormatData) + 4 + SizeOf(NativeData));
        AddingFormatted;
        WriteStr(FormatData);
      end else begin
        AllocateSpace(SizeOf(NativeData));
      end; { else }
      AddingNative;
      WriteDateTime(NativeData);
    end; { if }
    NextField;
  end;  { WriteDateTimeData }

  procedure TRPCustomConnection.WriteBlobData(var Buffer;
                                                  Len: longint);

  begin { WriteBlobData }
    If LocalFilterValid and CurrentFieldDef.Included then begin
      CheckDataType([dtBlob,dtMemo,dtGraphic]);
      AllocateSpace(Len + 4);
      AddingNative;
      WriteInt(Len);
      If Len > 0 then begin
        WriteBuf(Buffer,Len);
      end; { if }
    end; { if }
    NextField;
  end;  { WriteBlobData }

  function TRPCustomConnection.ReadStr: string;

  var
    I1: integer;

  begin { ReadStr }
    I1 := ReadInt;
    SetLength(Result,I1);
    If I1 > 0 then begin
      Move(FilePtr^,Result[1],I1);
      Inc(FilePtr,I1);
    end; { if }
  end;  { ReadStr }

  function TRPCustomConnection.ReadInt: integer;

  begin { ReadInt }
    Result := integer(pointer(FilePtr)^);
    Inc(FilePtr,SizeOf(integer));
  end;  { ReadInt }

  function TRPCustomConnection.ReadBool: boolean;

  begin { ReadBool }
    Result := boolean(pointer(FilePtr)^);
    Inc(FilePtr,SizeOf(boolean));
  end;  { ReadBool }

  function TRPCustomConnection.ReadFloat: extended;

  begin { ReadFloat }
    Result := extended(pointer(FilePtr)^);
    Inc(FilePtr,SizeOf(extended));
  end;  { ReadFloat }

  function TRPCustomConnection.ReadCurr: currency;

  begin { ReadCurr }
    Result := currency(pointer(FilePtr)^);
    Inc(FilePtr,SizeOf(currency));
  end;  { ReadCurr }

  function TRPCustomConnection.ReadDateTime: TDateTime;

  begin { ReadDateTime }
    Result := TDateTime(pointer(FilePtr)^);
    Inc(FilePtr,SizeOf(TDateTime));
  end;  { ReadDateTime }

  procedure TRPCustomConnection.ReadBuf(var Buffer;
                                            Len: integer);

  begin { ReadBuf }
   Move(FilePtr^,Buffer,Len);
   Inc(FilePtr,Len);
  end;  { ReadBuf }

  function TRPCustomConnection.FindFieldDef(FieldName: string): TDataConnectFieldDef;

  var
    I1: integer;

  begin { FindFieldDef }
    For I1 := 0 to FieldDefList.Count - 1 do begin
      Result := TDataConnectFieldDef(FieldDefList[I1]);
      If CompareText(Result.FieldName,FieldName) = 0 then Exit;
    end; { for }
    Result := nil;
  end;  { FindFieldDef }

  function TRPCustomConnection.ReadFilterItem(var FieldName: string;
                                              var FieldOp: string;
                                              var FieldData: string): boolean;

  var
    DataType: TRPDataType;
    FieldDef: TDataConnectFieldDef;
    DataInt: integer;
    DataBool: boolean;
    DataFloat: extended;
    DataCurr: currency;
    DataDateTime: TDateTime;

  begin { ReadFilterItem }
    FieldName := ReadStr;
    Result := (FieldName <> '');
    If Result then begin
      FieldOp := ReadStr;
      FieldData := ReadStr;
      DataType := TRPDataType(ReadInt);
      Case DataType of
        dtString: begin end; { Nothing to read, use FieldData }
        dtInteger: DataInt := ReadInt;
        dtBoolean: DataBool := ReadBool;
        dtFloat: DataFloat := ReadFloat;
        dtCurrency,dtBCD: DataCurr := ReadCurr;
        dtDate,dtTime,dtDateTime: DataDateTime := ReadDateTime;
      { dtBlob,dtMemo,dtGraphic }
      end; { case }

    { Assign filter data to FieldDef }
      FieldDef := FindFieldDef(FieldName);
      If Assigned(FieldDef) and (DataType = FieldDef.DataType) then begin
        Case DataType of
          dtString: FieldDef.SetFilter(FieldData);
          dtInteger: FieldDef.SetFilter(DataInt);
          dtBoolean: FieldDef.SetFilter(DataBool);
          dtFloat: FieldDef.SetFilter(DataFloat);
          dtCurrency,dtBCD: FieldDef.SetFilter(DataCurr);
          dtDate,dtTime,dtDateTime: FieldDef.SetFilter(DataDateTime);
        { dtBlob,dtMemo,dtGraphic }
        end; { case }
      end; { if }
    end; { if }
  end;  { ReadFilterItem }

  function TRPCustomConnection.GetFilterItem: boolean;

  begin { GetFilterItem }
    Result := ReadFilterItem(FFilterFieldName,FFilterFieldOp,FFilterFieldData);
  end;  { GetFilterItem }

  procedure TRPCustomConnection.ClearBuffer;

  begin { ClearBuffer }
  { Free AltFileBuf }
    If CurrentFileMap > 0 then begin
      UnmapViewOfFile(AltFileBuf);
      CloseHandle(AltFileMap);
      FileBuf := NormFileBuf;
      CurrentFileMap := 0;
      CurrentMapSize := FileMapSize;
    end; { if }
    FilePtr := FileBuf + 2 * SizeOf(longint); { Save space for bufsize & mapidx }
  end;  { ClearBuffer }

  procedure TRPCustomConnection.FixupBufferHeader;

  var
    SavePtr: PChar;

  begin { FixupBufferHeader }
  { Write out buffer size and CurrentFileMap }
    SavePtr := FilePtr;
    FilePtr := FileBuf;
    WriteInt(SavePtr - FileBuf); { Buffer size }
    WriteInt(CurrentFileMap); { File Map # }
    FilePtr := SavePtr;
  end;  { FixupBufferHeader }

  procedure TRPCustomConnection.ClearBufferHeader;

  var
    SavePtr: PChar;

  begin { ClearBufferHeader }
  { Clear buffer header values }
    SavePtr := FilePtr;
    FilePtr := FileBuf;
    WriteInt(0); { Buffer size }
    WriteInt(0); { File Map # }
    FilePtr := SavePtr;
  end;  { ClearBufferHeader }

{$IFDEF DBG}
  procedure TRPCustomConnection.Dbg(Value: string);

  begin { Dbg }
    WriteDebug({Trans-}'    DataCon(' + Name + '_' + ModeStr + {Trans-}'): ' +
     Value,DebugBuf);
  end;  { Dbg }

  procedure TRPCustomConnection.TDbg(Value: string);

  begin { TDbg }
    WriteDebug({Trans-}'    Thread(' + Name + '_' + ModeStr + {Trans-}'): ' +
     Value,DebugBuf);
  end;  { TDbg }
{$ENDIF}

  procedure TRPCustomConnection.ExecFirst;

  begin { ExecFirst }
    If Assigned(FOnFirst) then begin
      FOnFirst(self);
    end else begin
      DoFirst;
    end; { else }
    If LocalFilter then begin { Preread row for local filtering }
      ExecGetRow;
    end; { if }
    If not ExecValidateRow then begin
      ExecNext;
    end else begin
      If not LocalFilter then begin { Row was already read if LocalFilter }
        ExecGetRow;
      end; { if }
    end; { else }
  end;  { ExecFirst }

  procedure TRPCustomConnection.ExecNext;

  begin { ExecNext }
    Repeat
      If Assigned(FOnNext) then begin
        FOnNext(self);
      end else begin
        DoNext;
      end; { else }
      If LocalFilter then begin { Preread row for local filtering }
        ExecGetRow;
      end; { if }
    until ExecValidateRow or GetEOF;
    If not LocalFilter then begin { Row was already read if LocalFilter }
      ExecGetRow;
    end; { if }
  end;  { ExecNext }

  procedure TRPCustomConnection.ExecEOF;

  var
    AtEOF: boolean;

  begin { ExecEOF }
    If Assigned(FOnEOF) then begin
      FOnEOF(self,AtEOF);
    end else begin
      AtEOF := DoEOF;
    end; { else }
    ClearBuffer;
    WriteBool(AtEOF);
    FixupBufferHeader;
  end;  { ExecEOF }

  function TRPCustomConnection.GetEOF: boolean;

  begin { GetEOF }
    If Assigned(FOnEOF) then begin
      FOnEOF(self,Result);
    end else begin
      Result := DoEOF;
    end; { else }
  end;  { GetEOF }

  procedure TRPCustomConnection.ExecGetRow;

  var
    I1: integer;
  {$IFDEF DBG}
    TempPtr: PChar;
    S1: string;
  {$ENDIF}

  begin { ExecGetRow }
    ClearBuffer;
    If GetEOF then begin
      WriteBool(true);
      Exit; { Don't write out row data }
    end else begin
      WriteBool(false);
    end; { else }

  { Init row processing variables and allocate space for row header }
    FieldIdx := 0;
    IncludedFieldIdx := 0;
    WriteInt(0); { Place holder for data size }
    RowHeaderPtr := FilePtr; { Save current file position }
    For I1 := 0 to FieldDefList.Count - 1 do begin
      If TDataConnectFieldDef(FieldDefList[I1]).Included then begin
        WriteInt(0); { Offset for native data }
        WriteInt(0); { Offset for formatted data }
      end; { if }
    end; { for }

  { Add all row data }
    LocalFilterValid := true;
    If Assigned(FOnGetRow) then begin
      FOnGetRow(self);
    end else begin
      DoGetRow;
    end; { else }

  { Update data size }
    I1 := FilePtr - RowHeaderPtr;
    FilePtr := RowHeaderPtr - 4;
    WriteInt(I1);
    FilePtr := RowHeaderPtr + I1;
    FixupBufferHeader;

  {$IFDEF DBG}
    TempPtr := FileBuf + 2 * SizeOf(longint); { Save space for bufsize & mapidx }
    S1 := '';
    While TempPtr <> FilePtr do begin
      S1 := S1 + ' ' + IntToHex(byte(TempPtr^),2);
      Inc(TempPtr);
    end; { while }
    TDbg({Trans-}'GetRow Data:' + S1);
  {$ENDIF}
  end;  { ExecGetRow }

  procedure TRPCustomConnection.ExecGetCols;

  var
    SavePtr: PChar;
    I1: integer;
    FieldCount: integer;

  begin { ExecGetCols }
  { Init field processing allocate space for field count }
    ClearBuffer;
    ClearFieldDefs;
    WriteInt(0); { Place holder for field count }

  { Add all field data }
    If Assigned(FOnGetCols) then begin
      FOnGetCols(self);
    end else begin
      DoGetCols;
    end; { else }

  { Update field count }
    SavePtr := FilePtr;
    ClearBuffer;
  { Figure out how many included fields for FieldCount }
    FieldCount := 0;
    For I1 := 0 to FieldDefList.Count - 1 do begin
      If TDataConnectFieldDef(FieldDefList[I1]).Included then begin
        Inc(FieldCount);
      end; { if }
    end; { for }
    WriteInt(FieldCount); { Write field count }
    FilePtr := SavePtr;
    FixupBufferHeader;
  end;  { ExecGetCols }

  procedure TRPCustomConnection.ExecSetFilter;

  var
    FieldName: string;
    FieldOp: string;
    FieldData: string;

  begin { ExecSetFilter }
    ClearFilterData;
    If LocalFilter then begin { Read in native filter data using ReadFilterItem }
      While ReadFilterItem(FieldName,FieldOp,FieldData) do begin
      end; { while }
    end else if Assigned(FOnSetFilter) then begin
      FOnSetFilter(self);
    end else begin
      DoSetFilter;
    end; { else }
    ClearBufferHeader;
  end;  { ExecSetFilter }

  procedure TRPCustomConnection.ExecGetSorts;

  begin { ExecGetSorts }
    ClearBuffer;
    If Assigned(FOnGetSorts) then begin
      FOnGetSorts(self);
    end else begin
      DoGetSorts;
    end; { else }
    FixupBufferHeader;
  end;  { ExecGetSorts }

  procedure TRPCustomConnection.ExecSetSort;

  begin { ExecSetSort }
    If Assigned(FOnSetSort) then begin
      FOnSetSort(self);
    end else begin
      DoSetSort;
    end; { if }
    ClearBufferHeader;
  end;  { ExecSetSort }

  procedure TRPCustomConnection.ExecOpen;

  begin { ExecOpen }
    ClearBuffer;
    If Assigned(FOnOpen) then begin
      FOnOpen(self);
    end else begin
      DoOpen;
    end; { else }
    ClearBufferHeader;
  end;  { ExecOpen }

  procedure TRPCustomConnection.ExecRestore;

  begin { ExecRestore }
    ClearBuffer;
    If Assigned(FOnRestore) then begin
      FOnRestore(self);
    end else begin
      DoRestore;
    end; { if }
    ClearBufferHeader;
  end;  { ExecRestore }

  function TRPCustomConnection.ExecValidateRow: boolean;

  begin { ExecValidateRow }
    If LocalFilter then begin
      Result := LocalFilterValid;
    end else begin
      Result := true;
    end; { else }
    If Result then begin
      If Assigned(FOnValidateRow) then begin
        FOnValidateRow(self,Result);
      end else begin
        Result := DoValidateRow;
      end; { else }
    end; { if }
  end;  { ExecValidateRow }

  procedure TRPCustomConnection.DoFirst;

  begin { DoFirst }
    FDataIndex := 0;
  end;  { DoFirst }

  procedure TRPCustomConnection.DoNext;

  begin { DoNext }
    Inc(FDataIndex);
  end;  { DoNext }

  function TRPCustomConnection.DoEOF: boolean;

  begin { DoEOF }
    Result := DataIndex >= DataRows;
  end;  { DoEOF }

  procedure TRPCustomConnection.DoGetRow;

  begin { DoGetRow }
    WriteStr('[' + Trans('Inactive at design-time') + ']');
  end;  { DoGetRow }

  procedure TRPCustomConnection.DoGetCols;

  begin { DoGetCols }
    WriteField({Trans-}'FieldName',dtString,30,{Trans-}'FieldName','');
  end;  { DoGetCols }

  procedure TRPCustomConnection.DoSetFilter;

  begin { DoSetFilter }
  end;  { DoSetFilter }

  procedure TRPCustomConnection.DoGetSorts;

  begin { DoGetSorts }
    WriteStr('');
  end;  { DoGetSorts }

  procedure TRPCustomConnection.DoSetSort;

  begin { DoSetSort }
  end;  { DoSetSort }

  procedure TRPCustomConnection.DoOpen;

  begin { DoOpen }
    DataRows := 1;
    DataIndex := 0;
  end;  { DoOpen }

  procedure TRPCustomConnection.DoRestore;

  begin { DoRestore }
  end;  { DoRestore }

  function TRPCustomConnection.DoValidateRow: boolean;

  begin { DoValidateRow }
    Result := true;
  end;  { DoValidateRow }

initialization
  DataConnectManager := TDataConnectManager.Create;
finalization
  DataConnectManager.Free;
end.