unit oPIIDataAccess;

interface

uses
  GlobVar, VarConst, ExWrap1U;

type
  TPIIDataType = (dtNote, dtLink, dtLetter, dtTransaction, dtLine, dtJob, dtEmployee, dtCISVoucher);
  TPIIOwnerType = (otCustomer, otSupplier, otEmployee, otTransaction, otJob, otConsumer);

  IPIIDataAccess = Interface
  ['{7943310B-6152-47B8-B342-D34E6F3868B1}']
    function FindEmployee(const ACode       : string;
                          var RecordAddress : longint) : Boolean;
    function FindAccount(const ACode       : string;
                         var RecordAddress : longint) : Boolean;

    //Functions used for iterating through records
    function FindFirst(const DataType : TPIIDataType;
                       const OwnerType : TPIIOwnerType;
                       var KeyString : Str255;
                       var RecordAddress : longint;
                       const IndexNo : Integer = 0) : Boolean;
    function FindNext(const DataTyp : TPIIDataType;
                      const OwnerType : TPIIOwnerType;
                      var KeyString : Str255;
                      var RecordAddress : longint;
                       const IndexNo : Integer = 0) : Boolean;

    function GetRecord(BtrOp: Integer; var KeyString : Str255;
       FileNo: Integer; IndexNo : Integer): Integer;

    function GetDirect(FileNo : Integer; RecAddress : Integer) : Integer;


    function GetDataPointer : Pointer;

    function GetExLocal : TdExLocalPtr;

    property DataPointer : Pointer read GetDataPointer;
    property ExLocal : TdExLocalPtr read GetExLocal;
  end;

  function GetDataAccess : IPIIDataAccess;

  function CheckKey(const Key1, Key2 : string; KeyLength : Integer) : Boolean;

  function GetNoteOwnerType(const SubType : Char) : TPIIOwnerType;
  
implementation

uses
  BtrvU2, BtKeys1U, SysUtils;

const
  PFixSubTypes : Array[TPIIDataType, TPIIOwnerType] of String[2] =
                 (
                  ('NA', 'NA', 'NE', 'ND', 'NJ', 'NA'),
                  ('WC', 'WS', 'WE', 'WT', 'WJ', 'WU'),
                  ('WC', 'WS', 'WE', 'WT', 'WJ', 'WU'),
                  ('',   '',   '',   '',   '',   '' ),
                  ('',   '',   '',   '',   '',   '' ),
                  ('',   '',   '',   '',   '',   '' ),
                  ('',   'JE',   '',   '',   '', '' ),
                  ('',   '',   'TS',   '',   '', '' )
                 );

  KeyLengths : Array[TPIIDataType, TPIIOwnerType] of Byte =
                (
                 (8, 8, 8, 6, 6, 8),
                 (8, 8, 8, 6, 6, 6),
                 (8, 8, 8, 6, 6, 6),
                 (6, 6, 6, 0, 6, 0),
                 (0, 0, 0, 4, 0, 0),
                 (0, 0, 0, 0, 0, 0),
                 (0, 8, 0, 0, 0, 0),
                 (0, 0, 8, 0, 0, 0)
                );

  FileNos : Array[TPIIDataType] of Integer = (PwrdF, MiscF, MiscF, InvF, IDetailF, JobF, JMiscF, JDetlF);

  PII_SCANNER_CID = 60;

type
  TPIIDataAccess = Class(TInterfacedObject, IPIIDataAccess)
  protected
    FDataPointer : Pointer;
    FExLocal : ^TdMTExLocal;
    function GetRecord(BtrOp : Integer; var KeyString : Str255;
                       FileNo: Integer; IndexNo : Integer) : Integer; virtual; abstract;

    function GetRecordAddress(FileNo : Integer) : longint; virtual; abstract;

    function FindEmployee(const ACode       : string;
                          var RecordAddress : longint) : Boolean;
    function FindAccount(const ACode       : string;
                         var RecordAddress : longint) : Boolean;

    //Functions used for iterating through records
    function FindFirst(const DataType : TPIIDataType;
                       const OwnerType : TPIIOwnerType;
                       var KeyString : Str255;
                       var RecordAddress : longint;
                       const IndexNo : Integer = 0) : Boolean;
    function FindNext(const DataType : TPIIDataType;
                      const OwnerType : TPIIOwnerType;
                      var KeyString : Str255;
                      var RecordAddress : longint;
                      const IndexNo : Integer = 0) : Boolean;

    function CheckRecord(const DataType : TPIIDataType;
                        const OwnerType : TPIIOwnerType;
                        const KeyString : string) : Boolean;
    function GetDirect(FileNo : Integer; RecAddress : Integer) : Integer; virtual; abstract;

    function GetDataPointer : Pointer;
    function GetExLocal : TdExLocalPtr;
  end;

  TPervasivePIIDataAccess = Class(TPIIDataAccess)
  protected

    function GetRecordAddress(FileNo : Integer) : longint; override;
  public
    constructor Create;
    destructor Destroy; override;
    function GetRecord(BtrOp : Integer; var KeyString : Str255;
                       FileNo: Integer; IndexNo : Integer) : Integer; override;
    function GetDirect(FileNo : Integer; RecAddress : Integer) : Integer; override;                      
  end;


function GetDataAccess : IPIIDataAccess;
begin
  Result := TPervasivePIIDataAccess.Create;
end;

function CheckKey(const Key1, Key2 : string; KeyLength : Integer) : Boolean;
begin
  Result := Copy(Key1, 1, KeyLength) = Copy(Key2, 1, KeyLength);
end;

function GetNoteOwnerType(const SubType : Char) : TPIIOwnerType;
begin
  Case SubType of
    'A' : Result := otCustomer;
    'E' : Result := otEmployee;
    'D' : Result := otTransaction;
    'J' : Result := otJob;
  end;
end;


{ TPIIDataAccess }

function TPIIDataAccess.FindAccount(const ACode: string;
  var RecordAddress: Integer): Boolean;
var
  AcCode : Str255;
begin
  AcCode := ACode;
  Result := GetRecord(B_GetEq, AcCode, CustF, CustCodeK) = 0;
  if Result then
  begin
    RecordAddress := GetRecordAddress(CustF);
    FDataPointer := FExLocal.LRecPtr[CustF];
  end;
end;

function TPIIDataAccess.FindEmployee(const ACode: string;
  var RecordAddress: Integer): Boolean;
var
  EmpCode : Str255;
begin
  EmpCode := 'JE' + FullEmpCode(ACode);
  Result := GetRecord(B_GetEq, EmpCode, JMiscF, JMK) = 0;
  if Result then
  begin
    RecordAddress := GetRecordAddress(JMiscF);
    FDataPointer := FExLocal.LRecPtr[JMiscF];
  end;
end;

function TPIIDataAccess.FindFirst(const DataType: TPIIDataType;
  const OwnerType: TPIIOwnerType; var KeyString : Str255;
  var RecordAddress: Integer; const IndexNo : Integer = 0): Boolean;
var
  KeyS : string;
  KeyLen : Integer;
begin
  KeyString := PFixSubTypes[DataType, OwnerType] + KeyString;
  KeyS := KeyString;
  KeyLen := KeyLengths[DataType, OwnerType];
  if KeyLen = 0 then
    KeyLen := Length(Keys);
  Result := GetRecord(B_GetGEq, KeyString,
                      FileNos[DataType], IndexNo) = 0;
  if Result and CheckKey(KeyS, KeySTring, KeyLen) then
  begin
    RecordAddress := GetRecordAddress(FileNos[DataType]);
    FDataPointer := FExLocal.LRecPtr[FileNos[DataType]];
  end
  else
    Result := False;
end;

function TPIIDataAccess.FindNext(const DataType: TPIIDataType;
  const OwnerType: TPIIOwnerType; var KeyString : Str255;
  var RecordAddress: Integer; const IndexNo : Integer = 0): Boolean;
var
  KeyS : string;
  KeyLen : Integer;
begin
  KeyS := KeyString;
  KeyLen := KeyLengths[DataType, OwnerType];
  if KeyLen = 0 then
    KeyLen := Length(Keys);
  Result := GetRecord(B_GetNext, KeyString,
                      FileNos[DataType], IndexNo) = 0;
  if Result and CheckKey(KeyS, KeySTring, KeyLen) then
  begin
    RecordAddress := GetRecordAddress(FileNos[DataType]);
    FDataPointer := FExLocal.LRecPtr[FileNos[DataType]];
  end
  else
    Result := False;
end;

function TPIIDataAccess.CheckRecord(const DataType : TPIIDataType;
                                    const OwnerType : TPIIOwnerType;
                                    const KeyString : string) : Boolean;
var
  ExpectedKey : string;
  ActualKey   : string;
begin
{  ExpectedKey := Copy(PFixSubTypes[DataType, OwnerType] + KeyString, 1, KeyLengths[DataType, OwnerType]);
  ActualKey := Copy(FKeyString, 1, KeyLengths[DataType, OwnerType]);}
  Result := Trim(ActualKey) = Trim(ExpectedKey);
end;


function TPIIDataAccess.GetDataPointer: Pointer;
begin
  Result := FDataPointer;
end;

function TPIIDataAccess.GetExLocal: TdExLocalPtr;
begin
  Result := FExLocal;
end;

{ TPervasivePIIDataAccess }

constructor TPervasivePIIDataAccess.Create;
begin
  inherited;
  New(FExLocal,Create(PII_SCANNER_CID));
  FExLocal.Open_System(CustF, TotFiles);
end;

destructor TPervasivePIIDataAccess.Destroy;
begin
  FExLocal.Close_Files;
  Dispose(FExLocal, Destroy);
  inherited;
end;

function TPervasivePIIDataAccess.GetDirect(FileNo,
  RecAddress: Integer): Integer;
begin
  FExLocal.LastRecAddr[FileNo] := RecAddress;
  Result := FExLocal.LGetDirectRec(FileNo, 0);
end;

function TPervasivePIIDataAccess.GetRecord(BtrOp: Integer; var KeyString : Str255;
  FileNo: Integer; IndexNo : Integer): Integer;
begin
  Result := FExLocal.LFind_Rec(BtrOp, FileNo, IndexNo, KeyString);
end;

function TPervasivePIIDataAccess.GetRecordAddress(
  FileNo: Integer): longint;
var
  Res : Integer;
begin
  Res := FExLocal.LGetPos(FileNo, Result);
  if Res <> 0 then
    Result := 0;
end;



{ TEBusinessPIIDataAccess }

end.
