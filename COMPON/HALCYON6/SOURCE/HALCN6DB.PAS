unit Halcn6db;
{$I gs6_flag.pas}
interface

uses
  SysHalc, Classes, SysUtils,
  {$IFDEF WIN32}
  Messages, Graphics, Controls, Forms, Dialogs,
  {$ENDIF}
  {$IFDEF LINUX}
  Types, QGraphics, QControls, QForms, QDialogs, variants,
  {$ELSE}
     {$IFDEF VER140}
      Variants,
     {$ENDIF}
  {$ENDIF}
  DB, DBCommon, gs6_glbl, gs6_dbsy, gs6_dbf, gs6_indx, gs6_tool,
  gs6_sql, gs6_cnst;


const
   HalcyonDefaultDirectory = 'Default Directory';

   HStatusStart     = -1;
   HStatusStop      = 0;
   HStatusIndexTo   = 1;
   HStatusIndexWr   = 2;
   HStatusSort      = 5;
   HStatusCopy      = 6;
   HStatusPack      = 11;
   HStatusSearch    = 21;

type
   THalcyonDataSet = class;

   TgsLokProtocol = (Default, DB4Lock, ClipLock, FoxLock);
   TgsIntFields = (asInteger{$IFDEF HASINT64},asLargeInt{$ENDIF},asFloat);
   TgsDBFActivity = (aNormal, aIndexing, aCopying);

   TgsStatusReport = procedure(stat1,stat2,stat3 : longint) of object;

   {--object DBFObject--}
   DBFObject = class(GSO_dBHandler)
   protected
      LinkTab     : THalcyonDataSet;
   public
      constructor Attach(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean; TTab: THalcyonDataSet);
      Function    gsTestFilter : boolean; override;
      Procedure   gsStatusUpdate(stat1,stat2,stat3 : longint); override;
   end;
   {--End object DBFObject--}

   TgsSortStatus = (Ascending, Descending, SortUp, SortDown,
                    SortDictUp, SortDictDown, NoSort,
                    AscendingGeneral, DescendingGeneral);

   TgsIndexUnique = (Unique, Duplicates);

  THalcyonDataSet = class(TDataSet)
  private
    { Private declarations }
    FDatabaseName: gsUTFString;
    FDBFHandle: DBFObject;
    FBeforeBOF: boolean;
    FAfterEOF: boolean;
    FExclusive  : boolean;
    FRecordSize: Word;
    FBookmarkOfs: Word;
    FRecInfoOfs: Word;
    FRecBufSize: Word;
    FIndexDefs: TIndexDefs;
    FIndexFiles: TStringList;
    FIndexName: gsUTFString;
    FReadOnly: Boolean;
    FTableName: AnsiString;
    FUseDeleted: boolean;
    FAutoFlush: boolean;
    FOnStatus: TgsStatusReport;
    FEncryption: gsUTFString;
    FUseDBFCache: boolean;
    FLokProtocol: TgsLokProtocol;
    FExactCount: boolean;
    FActivity: TgsDBFActivity;
    FTempDir: array[0..259] of char;
    FUserID: longint;
    FDoingEdit: boolean;                    {!!RFG 100197}
    FTranslateASCII: boolean;              {!!RFG 032798}
    FMasterLink: TMasterDataLink;
    FRenaming: boolean;
    FUpdatingIndexDesc: boolean;
    FKeyBuffer: PChar;
    FLargeIntegerAs: TgsIntFields;
    procedure CheckMasterRange;
    procedure  DoOnFilter(var tf: boolean);
    procedure DoOnStatus(stat1, stat2, stat3: longint);
    function GetActiveRecBuf(var RecBuf: PChar): Boolean;
    function GetIndexName: gsUTFString;
    function GetVersion: gsUTFString;
    function GetMasterKey: gsUTFString;
    procedure MasterChanged(Sender: TObject);
    procedure MasterDisabled(Sender: TObject);
    procedure SetVersion(const st: gsUTFString);
    procedure InitBufferPointers;
    procedure OpenDBFFile(ReadWrite, Shared: boolean);
    procedure RestoreCurRecord;
    function SetCurRecord(CurRec: PChar): PChar;
    procedure SetDatabaseName(const Value: gsUTFString);
    procedure SetIndexDefs(Value: TIndexDefs);
    procedure SetIndexName(const Value: gsUTFString);
    procedure SetReadOnly(Value: Boolean);
    procedure SetTableName(const Value: AnsiString);
    procedure SetUseDeleted(tf: boolean);
    procedure SetAutoFlush(tf: boolean);
    procedure SetEncrypted(const Value: gsUTFString);
    procedure DoOnIndexFilesChange(Sender: TObject);
    function  ConvertDatabaseNameAlias: gsUTFString;
    function SetPrimaryTag(const TName: gsUTFString; SameRec: boolean): integer;{!!RFG 043098}
  protected
    { Protected declarations }
    procedure AddFieldDesc(FieldNo: Word);
    function AllocRecordBuffer: PChar; override;
    procedure AssignUserID(id: longint);
    procedure CheckActive; override;
    procedure CheckActiveSet;
    procedure ClearCalcFields(Buffer: PChar); override;
    function ConfirmEdit: boolean;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    function GetCanModify: Boolean; override;                 {!!RFG 100197}
    function GetDataSource: TDataSource; override;
    function GetIsIndexField(Field: TField): Boolean; override;
    function GetMasterFields: gsUTFString;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult; override;
    function GetRecordCount: Integer; override;
    function GetRecNo: Integer; override;
    function GetRecordSize: Word; override;
    procedure InternalAddRecord(Buffer: Pointer; Append: Boolean); override;
    procedure InternalCancel; override;
    procedure InternalClose; override;
    procedure InternalDelete; override;
    procedure InternalRecall; virtual;
    procedure InternalFirst; override;
    procedure InternalGotoBookmark(Bookmark: Pointer); override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure DoAfterInsert; override;
    procedure InternalEdit; override;
    procedure InternalLast; override;
    procedure InternalOpen; override;
    procedure InternalPost; override;
    procedure InternalRefresh; override;
    procedure InternalSetToRecord(Buffer: PChar); override;
    function IsCursorOpen: Boolean; override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure SetDataSource(Value: TDataSource);
    procedure SetFieldData(Field: TField; Buffer: Pointer); override;
    procedure SetMasterFields(const Value: gsUTFString);
    procedure SetRecNo(Value: Integer); override;
    procedure SetFilterData(const Text: gsUTFString; Options: TFilterOptions);
    procedure SetFiltered(Value: Boolean); override;
    procedure SetFilterOptions(Value: TFilterOptions); override;
    procedure SetFilterText(const Value: string); override;
    procedure UpdateIndexDefs; override;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure AddAlias(const AliasValue, PathValue: gsUTFString);
    function BookmarkValid(Bookmark: TBookmark): Boolean; override;
    function CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer; override; {!!RFG 100197}
      procedure  CopyRecordTo(area: THalcyonDataSet);
      procedure  CopyStructure(const filname, apassword: gsUTFString);
      procedure  CopyTo(const filname, apassword: gsUTFString);
    function  CreateDBF(const fname, apassword: gsUTFString; ftype: char;
                       fproc: dbInsertFieldProc): boolean;
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
    procedure EditKey;
    Function  ExternalChange : integer;
    function  Find(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
    function FindKey(const KeyValues: array of const): Boolean;
    procedure FindNearest(const KeyValues: array of const);
    function  FindThisRecord(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
    function  FLock : boolean;
    procedure FlushDBF;
    function  GetCurrentRecord(Buffer: PChar): Boolean; override;
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; override;
    function  GetIndexList: TStrings;
    procedure GetIndexNames(List: TStrings);
    procedure GetIndexTagList(List: TStrings);
    procedure GetDatabaseNames(List: TStrings);
    procedure GetTableNames(List: TStrings);
    function GotoKey: Boolean;
    procedure GotoNearest;
    function   HuntDuplicate(const st, ky: gsUTFString): longint;
    procedure  Index(const IName, Tag: gsUTFString);
    Procedure  IndexFileInclude(const IName: gsUTFString);
    Procedure  IndexFileRemove(const IName: gsUTFString);
    Procedure  IndexTagRemove(const IName, Tag: gsUTFString);
    Function   IndexCount: integer;
    Function   IndexCurrent: gsUTFString;
    Function   IndexCurrentOrder: integer;
    Function   IndexExpression(Value: integer): gsUTFString;
    Function   IndexFilter(Value: integer): gsUTFString;
    Function   IndexKeyLength(Value: integer): integer;
    Function   IndexUnique(Value: integer): boolean;
    Function   IndexAscending(Value: integer): boolean;
    Function   IndexFileName(Value: integer): gsUTFString;
    Procedure  IndexIsProduction(tf: boolean);
    Function   IndexKeyValue(Value: integer): gsUTFString;
    Procedure  IndexOn(const IName, tag, keyexp, forexp : gsUTFString;
                       uniq: TgsIndexUnique; ascnd: TgsSortStatus);
    Function   IndexTagName(Value: integer): gsUTFString;
    function  IsDeleted: boolean;
    function IsSequenced: Boolean; override;
    function Locate(const KeyFields: string; const KeyValues: Variant;
      Options: TLocateOptions): Boolean; override;
    function Lookup(const KeyFields: string; const KeyValues: Variant;
      const ResultFields: string): Variant; override;
    Function MemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
            uniq: TgsIndexUnique; ascnd: TgsSortStatus): boolean;
    procedure  Pack;
    procedure Post; override;
    procedure Recall;
    procedure Reindex;
    procedure  RenameTable(const NewTableName: gsUTFString);
    function   RLock : boolean;
    procedure  ReturnDateTimeUser(var dt, tm, us: longint);
    procedure  SetDBFCache(tf: boolean);
    procedure  SetKey;
    procedure  SetLockProtocol(LokProtocol: TgsLokProtocol);
    procedure  SetTagTo(const TName: gsUTFString);
    procedure  SetTempDirectory(const Value: gsUTFString);
    procedure  SortTo(const filname, apassword, formla: gsUTFString; sortseq: TgsSortStatus);
    procedure  Unlock;
    procedure  Zap;
    procedure SetIndexList(Items: TStrings);
    procedure SetRange(const RLo, RHi: gsUTFString);
    procedure SetRangeEx(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean);
    {$IFDEF VER120}
    function Translate(Src, Dest: PChar; ToOem: Boolean): Integer; override;
    {$ELSE}
    procedure Translate(Src, Dest: PChar; ToOem: Boolean);  override;
    {$ENDIF}
    procedure EncryptFile(const APassword: gsUTFString);
       {Added because EncryptFile is reserved in CBuilder}
    procedure EncryptDBFFile(const APassword: gsUTFString);
     {dBase file search routine}
    function   SearchDBF(const s : gsUTFString; var FNum : word;
                           var fromrec: longint; toRec: longint): word;

     {dBase field handling routines}

      Function   MemoSize(const fnam: gsUTFString): longint;
      Function   MemoSizeN(fnum: integer): longint;
      Procedure  MemoLoad(const fnam: gsUTFString;buf: pointer; var cb: longint);
      Function   MemoSave(const fnam: gsUTFString;buf: pointer; var cb: longint): longint;
      Procedure  MemoLoadN(fnum: integer;buf: pointer; var cb: longint);
      Function   MemoSaveN(fnum: integer;buf: pointer; var cb: longint): longint;
      function   DateGet(const st : gsUTFString) : longint;
      function   DateGetN(n : integer) : longint;
      procedure  DatePut(const st : gsUTFString; jdte : longint);
      procedure  DatePutN(n : integer; jdte : longint);
      function   FieldGet(const fnam : gsUTFString) : gsUTFString;
      function   FieldGetN(fnum : integer) : gsUTFString;
      procedure  FieldPut(const fnam, st : gsUTFString);
      procedure  FieldPutN(fnum : integer; st : gsUTFString);
      function   FloatGet(const st : gsUTFString) : FloatNum;
      function   FloatGetN(n : integer) : FloatNum;
      procedure  FloatPut(const st : gsUTFString; r : FloatNum);
      procedure  FloatPutN(n : integer; r : FloatNum);
      function   LogicGet(const st : gsUTFString) : boolean;
      function   LogicGetN(n : integer) : boolean;
      procedure  LogicPut(const st : gsUTFString; b : boolean);
      procedure  LogicPutN(n : integer; b : boolean);
      function   IntegerGet(const st : gsUTFString) : Int64;
      function   IntegerGetN(n : integer) : Int64;
      procedure  IntegerPut(const st : gsUTFString; i : Int64);
      procedure  IntegerPutN(n : integer; i : Int64);
      function   StringGet(const fnam : gsUTFString) : gsUTFString;
      function   StringGetN(fnum : integer) : gsUTFString;
      procedure  StringPut(const fnam, st : gsUTFString);
      procedure  StringPutN(fnum : integer; st : gsUTFString);
      property  DBFHandle: DBFObject read FDBFHandle;
   published
    { Published declarations }
    property About: gsUTFString read GetVersion write SetVersion;
    property Active;
    property AutoCalcFields;
    property AutoFlush: boolean read FAutoFlush write SetAutoFlush;
    property DatabaseName: gsUTFString read FDatabaseName write SetDatabaseName;
    property EncryptionKey: gsUTFString read FEncryption write SetEncrypted;
    property ExactCount: boolean read FExactCount write FExactCount default false;
    property Exclusive: boolean read FExclusive write FExclusive;
    property Filter;
    property Filtered;
    property FilterOptions;
    property IndexDefs: TIndexDefs read FIndexDefs write SetIndexDefs stored false;
    property IndexFiles: TStrings read GetIndexList write SetIndexList;
    property IndexName: gsUTFString read GetIndexName write SetIndexName;
    property LargeIntegerAs: TgsIntFields read FLargeIntegerAs write FLargeIntegerAs;
    property LockProtocol: TgsLokProtocol read FLokProtocol write SetLockProtocol;
    property MasterFields: gsUTFString read GetMasterFields write SetMasterFields;
    property MasterSource: TDataSource read GetDataSource write SetDataSource;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property TableName: AnsiString read FTableName write SetTableName;
    property TranslateASCII: boolean read FTranslateASCII write FTranslateASCII;
    property UseDeleted: boolean read FUseDeleted write SetUseDeleted;
    property UserID: longint read FUserid write AssignUserID;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnFilterRecord;
    property OnNewRecord;
    property OnPostError;
    property OnStatus: TgsStatusReport read FOnStatus write FOnStatus;
 end;

  TgsDBFTypes = (Clipper,DBaseIII,DBaseIV,FoxPro2);

  TCreateHalcyonDataSet = class(TComponent)
  private
     FFieldList: TStringList;
     FAutoOver: boolean;
     FTable: THalcyonDataSet;
     FType: TgsDBFTypes;
     procedure SetFieldList(Value: TStringList);
  public
     constructor Create(AOwner: TComponent); override;
     destructor  Destroy; override;
     function Execute: boolean;
  published
     property AutoOverwrite: boolean read FAutoOver write FAutoOver;
     property CreateFields: TStringList read FFieldList write SetFieldList;
     property DBFTable: THalcyonDataSet read FTable write FTable;
     property DBFType: TgsDBFTypes read FType write FType;
  end;

implementation
uses DBConsts, {DsgnIntf,} IniFiles;

var
   AliasList: TStringList;

type
  PRecInfo = ^TRecInfo;
  TRecInfo = record
    RecordNumber: Longint;
    UpdateStatus: TUpdateStatus;
    BookmarkFlag: TBookmarkFlag;
  end;



{ THCBlobStream }
type
  THCBlobStream = class(TStream)
  private
    FField: TBlobField;
    FDataSet: THalcyonDataSet;
    FBuffer: PChar;
    FFieldNo: Integer;
    FModified: Boolean;
    FMemory: pchar;
    FMemorySize: integer;
    FPosition: integer;
    procedure ReadBlobData;
  public
    constructor Create(Field: TBlobField; Mode: TBlobStreamMode);
    destructor Destroy; override;
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure Truncate;
  end;

{ THCBlobStream }


constructor THCBlobStream.Create(Field: TBlobField; Mode: TBlobStreamMode);
begin
  FMemory := nil;
  FField := Field;
  FFieldNo := FField.FieldNo;
  FDataSet := FField.DataSet as THalcyonDataSet;
  if not FDataSet.GetActiveRecBuf(FBuffer) then exit;   {!!RFG 010798}
  if Mode <> bmRead then
  begin
    if FField.ReadOnly then
       DatabaseErrorFmt(SFieldReadOnly, [FField.DisplayName]);
    if not (FDataSet.State in [dsEdit, dsInsert]) then
       DatabaseError(gsErrNotEditing);
  end;
  if Mode = bmWrite then Truncate
  else ReadBlobData;
end;

destructor THCBlobStream.Destroy;
var
   msiz: longint;
begin
  if FModified and (FDataset.State in [dsEdit, dsInsert]) then
  try
    FDataset.SetCurRecord(FDataSet.ActiveBuffer);
    if FMemory = nil then
    begin
       GetMem(FMemory,4);    {!!RFG 021498}
       FMemory[0] := #0;     {!!RFG 021498}
       FMemorySize := 3;     {!!RFG 051299}
       FPosition := 0;       {!!RFG 021498}
       msiz := 0;            {!!RFG 021498}
    end
    else
    begin
       msiz := Size;
       if FField.Transliterate then
       begin
           FDataSet.Translate(FMemory, FMemory, True);
       end;
    end;
    FDataSet.DBFHandle.gsMemoSaveN(FFieldNo, FMemory, msiz);
    FDataSet.RestoreCurRecord;
    FField.Modified := True;
    FDataSet.DataEvent(deFieldChange, Longint(FField));
 finally
    if FMemory <> nil then
     begin
        FreeMem(FMemory,FMemorySize+1);
        FMemorySize := 0;
        FPosition := 0;
        FMemory := nil;
     end;
  end;
end;

procedure THCBlobStream.ReadBlobData;
var
  BlobLen: Integer;
begin
  FDataSet.SetCurRecord(FBuffer{FDataSet.ActiveBuffer});
  BlobLen := FDataSet.DBFHandle.gsMemoSizeN(FFieldNo);
  if BlobLen > 0 then
  begin
    if FMemory <> nil then
       FreeMem(FMemory,FMemorySize+1);
    GetMem(FMemory,BlobLen+1);
    FMemory[BlobLen] := #0;
    FMemorySize := BlobLen;
    FPosition := 0;
    FDataSet.DBFHandle.gsMemoLoadN(FFieldNo, FMemory, BlobLen);
    if FField.Transliterate then
    begin
        FDataSet.Translate(FMemory, FMemory, False);
    end;
  end;
  FDataSet.RestoreCurRecord;
end;

function THCBlobStream.Read(var Buffer; Count: Longint): Longint;
begin
   if FMemory = nil then
   begin
      Result := 0;
      exit;
   end;
   if FPosition+Count > FMemorySize then
      Count := (FMemorySize-FPosition)+1;
   Move(FMemory[FPosition],Buffer,Count);
   FPosition := FPosition+Count;              {!!RFG 041298}
   Result := Count;
end;

function THCBlobStream.Write(const Buffer; Count: Longint): Longint;
var
   pmem: pchar;
begin
  if Count = 0 then
  begin
     Result := 0;
     exit;
  end;
  if FMemory = nil then
  begin
     GetMem(FMemory,Count+1);
     FMemory[Count] := #0;
     FMemorySize := Count;
     FPosition := 0;
  end
  else
  begin
     GetMem(pmem,FPosition+Count+1);
     pmem[FPosition+Count] := #0;
     Move(FMemory[0],pmem[0],FPosition);
     FreeMem(FMemory,FMemorySize+1);
     FMemory := pmem;
     FMemorySize := FPosition+Count;
  end;
  Move(Buffer, FMemory[FPosition], Count);
  FPosition := FPosition+Count;
  Result := Count;
  FModified := True;
end;

function THCBlobStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    0: FPosition := Offset;
    1: Inc(FPosition, Offset);
    2: FPosition := FMemorySize + Offset;
  end;
  Result := FPosition;
end;


procedure THCBlobStream.Truncate;
begin
  if FMemory <> nil then
  begin
     FreeMem(FMemory,FMemorySize+1);
     FMemorySize := 0;
     FPosition := 0;
     FMemory := nil;
  end;
  FModified := True;
end;


(*----------------------------------------------------------------------------
                                     DBFObject
------------------------------------------------------------------------------*)

Constructor DBFObject.Attach(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean; TTab: THalcyonDataSet);
begin
   LinkTab := TTab;
   inherited Create(FName,APassword,ReadWrite,Shared);
   LinkTab := TTab;   {just for safety}
end;

Function DBFObject.gsTestFilter : boolean;
var
   chk: boolean;
begin
   chk := true;
   if LinkTab <> nil then
      LinkTab.DoOnFilter(chk);
   if chk then
      gsTestFilter := inherited gsTestFilter
   else
      gsTestFilter := false;
end;

Procedure DBFObject.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
   if LinkTab <> nil then
      LinkTab.DoOnStatus(stat1,stat2,stat3)
   else
      inherited gsStatusUpdate(stat1,stat2,stat3);
end;

{-----------------------------------------------------------------------------
                              Begin TCreateHalcyonDataSet
-----------------------------------------------------------------------------}

constructor TCreateHalcyonDataSet.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FFieldList := TStringList.Create;
end;

destructor TCreateHalcyonDataSet.Destroy;
begin
   FFieldList.Free;
   inherited Destroy;
end;

function TCreateHalcyonDataSet.Execute: boolean;
var
   f: GSO_DBFBuild;
   fil: gsUTFString;
   s: gsUTFString;
   v: boolean;
   i: integer;
   p: integer;
   fs: gsUTFString;
   ft: gsUTFString;
   fl: integer;
   fd: integer;
   sl: TStringList;
   sv: integer;

   procedure LoadField;
   begin
      p := pos(';',s);
      fs := '';
      if p > 0 then
      begin
         fs := system.copy(s,1,pred(p));
         system.delete(s,1,p);
      end
      else v := false;

      p := pos(';',s);
      ft := ' ';
      if p = 2 then
      begin
         ft := system.copy(s,1,1);
         system.delete(s,1,p);
      end
      else v := false;

      p := pos(';',s);
      fl := 0;
      if p > 0 then
      begin
         try
            fl := StrToInt(system.copy(s,1,pred(p)));
            system.delete(s,1,p);
         except
            on Exception do v := false;
         end;
      end
      else v := false;

      fd := 0;
      try
         fd := StrToInt(system.copy(s,1,3));
      except
         on Exception do v := false;
      end;

   end;

begin
   Result := false;
   if not Assigned(FTable) then
   begin
      DatabaseError(gsErrTableIsNil);
   end;
   if FTable.Active then
   begin
      DatabaseError(gsErrTableIsActive);
      exit;
   end;
   fil := FTable.ConvertDatabaseNameAlias;
   fil := fil + FTable.TableName;
   if FileExists(fil) and not FAutoOver then
   begin
      if MessageDlg(gsErrOverwriteTable, mtWarning, mbOKCancel, 0) = mrCancel then
         exit;
   end;
   if FFieldList.Count = 0 then
   begin
      DatabaseError(gsErrInvalidFieldList);
      exit;
   end;
   sl := TStringList.Create;
   for i := 0 to pred(FFieldList.Count) do
   begin
      v := true;
      s := FFieldlist.Strings[i];
      While (length(s) > 0) and (s[length(s)] in [' ',';']) do
         system.Delete(s,length(s),1);
      if s <> '' then
         LoadField;
      if v then
      begin
         fs := gsStrUpperCase(fs);
         v := not sl.Find(fs, sv);
      end;
      if not v then
      begin
         sl.Free;
         DatabaseError(gsErrInvalidFieldList);
         exit;
      end;
      sl.Add(fs);
   end;
   sl.Free;

   case FType of
      Clipper,
      DBaseIII : f := GSO_DB3Build.Create(fil);
      DBaseIV  : f := GSO_DB4Build.Create(fil);
      FoxPro2  : f := GSO_DBFoxBuild.Create(fil);
      else       f := GSO_DB3Build.Create(fil);
   end;
   for i := 0 to pred(FFieldList.Count) do
   begin
      s := FFieldlist.Strings[i];
      While (length(s) > 0) and (s[length(s)] in [' ',';']) do
         system.Delete(s,length(s),1);
      if s <> '' then
         LoadField;
      f.InsertField(fs,ft[1],fl,fd);
   end;
   f.Complete;
   Result :=  (f.dFile <> nil);
   f.Free;
   if Result then FTable.Open;
end;

procedure TCreateHalcyonDataSet.SetFieldList(Value: TStringList);
begin
   FFieldList.Assign(Value);
end;



(*---------------------------------------------------------------------------
                               THalcyonDataSet
------------------------------------------------------------------------------*)

constructor THalcyonDataSet.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   FMasterLink := TMasterDataLink.Create(Self);
   FMasterLink.OnMasterChange := MasterChanged;
   FMasterLink.OnMasterDisable := MasterDisabled;
   FIndexDefs := TIndexDefs.Create(Self);
   FIndexFiles := TStringList.Create;
   FIndexFiles.OnChange := DoOnIndexFilesChange;
   FActivity := aNormal;
   FTranslateASCII := true;
   FLokProtocol := Default;
   FKeyBuffer := nil;
   FRenaming := false;
   FUpdatingIndexDesc := false;
   FEncryption := '';
end;

destructor THalcyonDataSet.Destroy;
begin
   FIndexFiles.Free;
   FIndexDefs.Free;
   FMasterLink.Free;
   if FKeyBuffer <> nil then FreeMem(FKeyBuffer,FRecBufSize);
   FKeyBuffer := nil;
   inherited Destroy;
end;

function THalcyonDataSet.GetVersion: gsUTFString;
begin
   Result := gs6_Version;
end;

procedure THalcyonDataSet.SetVersion(const st: gsUTFString);
begin
end;


procedure THalcyonDataSet.AddFieldDesc(FieldNo: Word);
var
  iFldType: TFieldType;
  Size: Word;
  Name: gsUTFString;
  typ: char;
begin
   iFldType := ftUnknown;
   Name := FDBFHandle.gsFieldName(FieldNo);
   Size := 0;
   Typ := FDBFHandle.gsFieldType(FieldNo);
   case Typ of
     'C' : begin
              iFldType := ftString;      { Char gsUTFString }
              Size := FDBFHandle.gsFieldLength(FieldNo); {!!RFG 031498}
            end;
      'F',
      'N' : begin
               if (FDBFHandle.gsFieldDecimals(FieldNo) > 0) then
               begin
                  iFldType := ftFloat;        { Number }
               end
               else
               begin
                  if (FDBFHandle.gsFieldLength(FieldNo) > 9) then
                  begin
                     case FLargeIntegerAs of
                        asFloat    : iFldType := ftFloat;
                        asInteger  : iFldType := ftInteger;
                       {$IFDEF HASINT64}
                        asLargeInt : iFldType := ftLargeInt;
                       {$ENDIF}
                     end;
                  end
                  else
                  begin
                     if (FDBFHandle.gsFieldLength(FieldNo) > 4) then
                     begin
                        iFldType := ftInteger;
                     end
                     else
                     begin
                        iFldType := ftSmallInt;
                     end;
                  end;
               end;
            end;
      'M' : begin
               iFldType := ftMemo;
            end;
      'G',
      'B' : begin
               iFldType := ftBlob;
            end;
      'L' : begin
               iFldType := ftBoolean;          { Logical }
            end;
      'D' : begin
               iFldType := ftDate;          { Date }
            end;
      'I' : begin
               iFldType := ftInteger;        {VFP integer}
            end;
      'T' : begin
               iFldType := ftDateTime;       {VFP datetime}
            end;
      'Y' : begin
               iFldType := ftCurrency;       {VFP datetime}
            end;
   end;
   if iFldType <> ftUnknown then
      FieldDefs.Add(Name, iFldType, Size, false);
end;

procedure THalcyonDataSet.ClearCalcFields(Buffer: PChar);
begin
  FillChar(Buffer[RecordSize], CalcFieldsSize, 0);
end;

function THalcyonDataSet.ConfirmEdit: boolean;
begin
    Result := State in dsEditModes;
    if not Result then DatabaseError(gsErrNotEditing);
end;

function THalcyonDataSet.CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream;
begin
  Result := THCBlobStream.Create(Field as TBlobField, Mode);
end;

function THalcyonDataSet.GetCurrentRecord(Buffer: PChar): Boolean;
begin
  if not IsEmpty and (GetBookmarkFlag(ActiveBuffer) = bfCurrent) then
  begin
    UpdateCursorPos;
    Move(FDBFHandle.CurRecord^,Buffer[0],FDBFHandle.RecLen);
    Result := true;
  end else
    Result := False;
end;

function THalcyonDataSet.GetIndexList: TStrings;
begin
   if FIndexFiles = nil then
      FIndexFiles := TStringList.Create;
   Result := FIndexFiles;
end;

function THalcyonDataSet.GetIndexName: gsUTFString;
begin
  Result := FIndexName;
end;

procedure THalcyonDataSet.GetIndexNames(List: TStrings);
const
   IDXExtns : array[0..3] of gsUTFString = ('.cdx','.mdx','.ndx','.ntx');
var
   f    : TSearchRec;
   i    : integer;
   j    : integer;
begin
   for j := 0 to 3 do
   begin
      i := Sysutils.FindFirst(ConvertDatabaseNameAlias+'*'+ IDXExtns[j], faAnyFile, F);
      while i = 0 do
      begin
         List.Add(F.Name);
         i := Sysutils.FindNext(F);
      end;
      SysUtils.FindClose(F);
   end;
end;

function THalcyonDataSet.GetRecordCount: Integer;
var
   rn: integer;
begin
  if FDBFHandle <> nil then
  begin
     if FExactCount then
     begin
        Result := 0;
        rn := FDBFHandle.RecNumber;
        FDBFHandle.gsGetRec(Top_Record);
        while not FDBFHandle.File_EOF do
        begin
           inc(Result);
           FDBFHandle.gsGetRec(Next_Record);
        end;
        FDBFHandle.gsGetRec(rn);
     end
     else
        Result := FDBFHandle.NumRecs;
  end
  else
  begin
     Result := 0;
     DatabaseErrorFmt(SDataSetClosed,[FTableName]);
  end;
end;

function THalcyonDataSet.GetRecNo: Integer;
var
  BufPtr: PChar;
begin
  BufPtr := nil;
  case State of
    dsInactive: DatabaseErrorFmt(SDataSetClosed,[FTableName]);
    dsCalcFields: BufPtr := CalcBuffer
  else
    BufPtr := ActiveBuffer;
  end;
  if BufPtr <> nil then
     Result := PRecInfo(BufPtr + FRecInfoOfs).RecordNumber
  else
     Result := 0;
end;

procedure THalcyonDataSet.SetRecNo(Value: Integer);
begin
  CheckBrowseMode;
  FDBFHandle.CurRecord := FDBFHandle.CurRecHold;
  FDBFHandle.gsGetRec(Value);
  Resync([]);
  DoAfterScroll;
end;

function THalcyonDataSet.GetActiveRecBuf(var RecBuf: PChar): Boolean;
begin
  case State of
    dsBrowse: if IsEmpty then RecBuf := nil else RecBuf := ActiveBuffer;
    dsEdit, dsInsert: RecBuf := ActiveBuffer;
    dsSetKey: RecBuf := FKeyBuffer;
    dsCalcFields: RecBuf := CalcBuffer;
    dsFilter: RecBuf := PChar(FDBFHandle.CurRecord);
    dsNewValue: RecBuf := ActiveBuffer;              {!!RFG 100197}
    dsOldValue: if FDoingEdit then                   {!!RFG 100197}
                   RecBuf := PChar(FDBFHandle.OrigRec) {!!RFG 100197}
                else
                   RecBuf := ActiveBuffer;           {!!RFG 100197}
  else
    RecBuf := nil;
  end;
  Result := RecBuf <> nil;
end;

procedure THalcyonDataSet.GetTableNames(List: TStrings);
var
  F: TSearchRec;
  I: Integer;
  ts: TStringList;
begin
   ts := TStringList.Create;
   ts.Sorted := true;
   i := SysUtils.FindFirst(ConvertDatabaseNameAlias+'*.dbf', faAnyFile, F);
   while i = 0 do
   begin
      ts.Add(F.Name);
      i := SysUtils.FindNext(F);
   end;
   SysUtils.FindClose(F);
   List.Clear;
   for i := 0 to pred(ts.Count) do
      List.Add(ts[i]);
   ts.Free;
end;

procedure THalcyonDataSet.OpenDBFFile(ReadWrite, Shared: boolean);
const
   ext : gsUTFString  = '.DBF';
var
   TPath: gsUTFString;
begin
   FDBFHandle := nil;
   if FTableName = '' then
      DatabaseError(gsErrNoTableName);
   FTableName := ChangeFileExtEmpty(FTableName,ext);
   TPath := ConvertDatabaseNameAlias;
   if not FileExists(TPath + FTableName) then
      DatabaseErrorFmt(gsErrCannotFindFile,[TPath + FTableName]);
   FDBFHandle := DBFObject.Attach(TPath + FTableName, FEncryption, ReadWrite, Shared, Self);
end;

procedure THalcyonDataSet.InitBufferPointers;
begin
   BookmarkSize := 11;                          {!!RFG 100297}
   FRecordSize := FDBFHandle.RecLen;
   FRecInfoOfs := FRecordSize + CalcFieldsSize;
   FBookmarkOfs := FRecInfoOfs + SizeOf(TRecInfo);
   FRecBufSize := FBookmarkOfs + BookmarkSize;
end;

procedure THalcyonDataSet.SetDatabaseName(const Value: gsUTFString);
var
   s: gsUTFString;
begin
  if FDatabaseName <> Value then
  begin
    s := Value;
    if gsStrCompareI(s,HalcyonDefaultDirectory) <> 0 then
    begin
       if length(s) > 0 then
          if s[length(s)] = GSFileSep then
             system.delete(s,length(s),1);
       if AliasList.Values[s] = '' then
          AliasList.Add(s+'='+s);
    end;
    CheckInactive;
    FDatabaseName := s;              {%FIX0007}
    DataEvent(dePropertyChange, 0);
  end;
end;

procedure THalcyonDataSet.SetIndexName(const Value: gsUTFString);
var
   RI: boolean;
   NR: boolean;
begin
   FIndexName := Value;
   if FDBFHandle <> nil then
    begin
      SetPrimaryTag(Value, True);
      RI := DBFHandle.ResyncIndex;
      NR := (DBFHandle.File_TOF or DBFHandle.File_EOF);
      CheckMasterRange;
      try                                   {!!RFG 100297}
         if RI or NR then
            First
         else
            Resync([rmExact, rmCenter]);       {!!RFG 100297}
      except                                {!!RFG 100297}
      end;                                  {!!RFG 100297}
      DoAfterScroll;
   end;

end;

procedure THalcyonDataSet.SetIndexList(Items: TStrings);
var
   i: integer;
   iname: gsUTFString;
   TPath: gsUTFString;
begin
   IndexDefs.Updated := False;
   IndexDefs.Clear;
   if FIndexFiles <> Items then
      FIndexFiles.Assign(Items);
   if (FIndexFiles.Count > 0) and (FDBFHandle <> nil) then
   begin
      FDBFHandle.gsIndex('','');
      for i := 0 to pred(FIndexFiles.Count) do
      begin
         iname := FIndexFiles.Strings[i];
         iname := ChangeFileExtEmpty(iname,'.ndx');
         TPath := ExtractFilePath(iname);
         iname := ExtractFileName(iname);
         if TPath = '' then
            TPath := ConvertDatabaseNameAlias;
         if not FileExists(TPath + iname) then
            DatabaseErrorFmt(gsErrCannotFindFile,[TPath + iname])  {!!RFG 102097}
         else
            if FDBFHandle.gsIndexRoute(TPath+iname) > 0 then
               DatabaseErrorFmt(gsErrErrorGettingFile,[TPath + iname]); {!!RFG 102097}
      end;
      UpdateIndexDefs;
      SetPrimaryTag(FIndexName,false);
   end;
end;

function THalcyonDataSet.ConvertDatabaseNameAlias: gsUTFString;
var
   s: gsUTFString;
   t: gsUTFString;
begin
   t := FDatabaseName;
   if gsStrCompareI(t,HalcyonDefaultDirectory) = 0 then
      Result := ExtractFilePath(ParamStr(0))
   else
   begin
      s := AliasList.Values[t];
      if s <> '' then
         Result := s
      else
         Result := FDatabaseName;
   end;
   if length(Result) > 0 then
      if Result[length(Result)] <> GSFileSep then
         Result := Result + GSFileSep;
end;

procedure THalcyonDataSet.DoOnIndexFilesChange(Sender: TObject); {!!RFG 031398}
var
   i: integer;
   iname: gsUTFString;
   TPath: gsUTFString;
   dbactive: boolean;
begin
   if FRenaming then exit;
   if (csReading in ComponentState) then exit;        {!!RFG 041398}
   dbactive := FDBFHandle <> nil;
   if not dbactive then
   begin
      try
         Active := true;
      except
      end;
   end;
   if FDBFHandle = nil then exit;
   FDBFHandle.gsIndex('','');                     {!!RFG 043098}
   if (FIndexFiles.Count > 0) then
   begin
      for i := 0 to pred(FIndexFiles.Count) do
      begin
         iname := FIndexFiles.Strings[i];
         iname := ChangeFileExtEmpty(iname,'.NDX');
         TPath := ExtractFilePath(iname);
         iname := ExtractFileName(iname);
         if TPath = '' then
            TPath := ConvertDatabaseNameAlias;
         if not FileExists(TPath + iname) then
            DatabaseErrorFmt(gsErrCannotFindFile,[TPath + iname])
         else
            case FDBFHandle.gsIndexRoute(TPath+iname) of
               0    : begin
                      end;
               -1   : DatabaseErrorFmt(gsErrIndexAlreadyOpen,[TPath + iname]);
               else   DatabaseErrorFmt(gsErrErrorGettingFile,[TPath + iname]);
            end;
      end;
      if dbactive then
         SetPrimaryTag(FIndexName,true);
   end
   else
      FIndexName := '';
   Active := dbactive;
end;

procedure THalcyonDataSet.SetReadOnly(Value: boolean);
begin
   if Active then
      FReadOnly := Value or (not FDBFHandle.FileReadWrite)
   else
      FReadOnly := Value;
end;

procedure THalcyonDataSet.SetTableName(const Value: AnsiString);
begin
  CheckInactive;
  if not (csDesigning in ComponentState) and
     not(csReading in ComponentState) and
     (FTableName <> Value) then
  begin
     IndexFiles.Clear;
  end;   
  FTableName := Value;
  DataEvent(dePropertyChange, 0);
end;

Procedure THalcyonDataSet.SetUseDeleted(tf: boolean);
begin
   FUseDeleted := tf;
   if FDBFHandle <> nil then
      FDBFHandle.UseDeletedRec := tf;
end;

Procedure THalcyonDataSet.SetAutoFlush(tf: boolean);
begin
   FAutoFlush := tf;
   if FDBFHandle <> nil then
      FDBFHandle.gsvAutoFlush := tf;
end;

procedure THalcyonDataset.SetEncrypted(const Value: gsUTFString);
begin
   CheckInactive;
   FEncryption := Value;
end;

procedure THalcyonDataset.EncryptFile(const APassword: gsUTFString);
begin
   CheckActive;
   FEncryption := APassword;
   FDBFHandle.gsSetPassword(APassword);
end;

procedure THalcyonDataset.EncryptDBFFile(const APassword: gsUTFString);
begin
   CheckActive;
   FEncryption := APassword;
   FDBFHandle.gsSetPassword(APassword);
end;

function THalcyonDataSet.AllocRecordBuffer: PChar;
begin
  Result := AllocMem(FRecBufSize);
end;

procedure THalcyonDataSet.FreeRecordBuffer(var Buffer: PChar);
begin
  FreeMem(Buffer);
end;

procedure THalcyonDataSet.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Buffer[FBookmarkOfs], Data^, BookmarkSize);
end;

function THalcyonDataSet.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
  Result := PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag;
end;

function THalcyonDataSet.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
var
  IsBlank: boolean;
  RecBuf: PChar;
  s: gsUTFString;
  l: boolean;
  d: longint;
  f: double;
  fext: Extended;
  i: longint;
  i64: Int64;
  yy,mm,dd: word;
  td: TDateTime;
  ts: TTimeStamp;
begin
  Result := false;
  if (State = dsBrowse) and IsEmpty then Exit;
  IsBlank := false;                              {!!RFG 090697}
  if (State = dsInactive) or (GetActiveRecBuf(RecBuf)) then
  begin
     with Field do
     begin
        if FieldNo > 0 then
        begin
           SetCurRecord(RecBuf);
           if Buffer <> nil then           {!!RFG 090697}
              FillChar(Buffer^,DataSize,#0);
           try
              case DataType of
                 ftString  : begin
                                s := FDBFHandle.gsStringGetN(FieldNo);
                                IsBlank := length(s) = 0;
                                if not IsBlank then
                                begin
                                   if Buffer <> nil then {!!RFG 090697}
                                      move(s[1],Buffer^,length(s));
                                end;
                             end;
                 ftBoolean : begin
                                if Buffer <> nil then {!!RFG 090697}
                                begin
                                   l := FDBFHandle.gsLogicGetN(FieldNo);
                                   if Buffer <> nil then {!!RFG 090697}
                                   move(l,Buffer^,DataSize);
                                end;
                             end;
{!!RFG 090697}    ftDate   : begin
                                IsBlank := true;
                                d := 0;
                                s := FDBFHandle.gsFieldGetN(FieldNo);
                                s := TrimRight(s);                {!!RFG 120897}
                                if (length(s) = 8) and (s <> '00000000') then
                                try
                                   yy := StrToInt(system.copy(s,1,4));
                                   mm := StrToInt(system.Copy(s,5,2));
                                   dd := StrToInt(system.Copy(s,7,2));
                                   td := EncodeDate(yy,mm,dd);
                                   ts := DateTimeToTimeStamp(td);
                                   d := ts.Date;
                                   IsBlank := false;
                                except
                                   d := 0;
                                end;
                                if Buffer <> nil then {!!RFG 090697}
                                   move(d,Buffer^,DataSize);
                             end;
{!!RFG 011898}    ftDateTime: begin
                                 if Buffer <> nil then {!!RFG 090697}
                                 begin
                                    td := FDBFHandle.gsNumberGetN(FieldNo);
                                    move(td,Buffer^,DataSize);
                                    IsBlank := td = 0;
                                 end;
                             end;
                  ftFloat  : begin
                                if Buffer <> nil then {!!RFG 090697}
                                begin
                                   f := FDBFHandle.gsNumberGetN(FieldNo);
                                   move(f,Buffer^,DataSize);
                                end;
                             end;
                  ftCurrency: begin
                                if Buffer <> nil then {!!RFG 090697}
                                begin
                                   f := FDBFHandle.gsNumberGetN(FieldNo);
                                   move(f,Buffer^,DataSize);
                                end;
                             end;
                  {$IFDEF HASINT64}
                  ftLargeint,
                  {$ENDIF}
                  ftSmallint,
                  ftInteger: begin
                                if Buffer <> nil then {!!RFG 090697}
                                begin
                                   fext := FDBFHandle.gsNumberGetN(FieldNo);
                                   {$IFDEF HASINT64}
                                   i64 := Round(fext);
                                   {$ELSE}
                                   i64 := fext;
                                   {$ENDIF}
                                   move(i64,Buffer^,DataSize);
                                end;
                             end;
                  ftMemo,
                  ftBlob   : begin      {!!RFG 040898}
                                f := FDBFHandle.gsNumberGetN(FieldNo);
                                i := round(f);
                                IsBlank := i = 0;
                             end;
              end;
           finally
              RestoreCurRecord;
           end;
        end else
        if State in [dsBrowse, dsEdit, dsInsert, dsCalcFields] then
        begin
           Inc(RecBuf, FRecordSize + Offset);
           Result := Boolean(RecBuf[0]);
           if Result and (Buffer <> nil) then
             Move(RecBuf[1], Buffer^, DataSize);
            exit;                                {!!RFG 090697}
        end;
     end;
  end;
  Result := not IsBlank;            {!!RFG 090697}
end;

function THalcyonDataSet.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
var
   Status: boolean;
   RN: longint;
   SRN: array[0..10] of char;
begin
   Result := grOk;
   SetCurRecord(Buffer);
   Status := true;
    try
      case GetMode of
         gmCurrent: begin
                       if FBeforeBOF then
                          Result := grBOF
                       else
                          if FAfterEOF then
                             Result := grEOF
                          else
                             FDBFHandle.gsGetRec(Same_Record);
                    end;
         gmNext:    begin
                       if FBeforeBOF then
                       begin
                          FDBFHandle.gsGetRec(Top_Record);
                          FBeforeBOF := false;
                       end
                       else
                          if FAfterEOF then
                          begin
                             Result := grEOF;
                          end
                          else
                             FDBFHandle.gsGetRec(Next_Record);
                    end;
         gmPrior:   begin
                       if FBeforeBOF then
                       begin
                          Result := grBOF;
                       end
                       else
                          if FAfterEOF and ((not (State = dsInsert)) or (ActiveRecord = 0)) then
                          begin
                             FDBFHandle.gsGetRec(Bttm_Record);
                             FAfterEOF := false;
                          end
                          else
                             FDBFHandle.gsGetRec(Prev_Record);
                    end;
       end;
     except
       Status := false;
     end;
    RestoreCurRecord;
    if FDBFHandle.File_EOF then
       Result := grEOF
    else
       if FDBFHandle.File_TOF then
          Result := grBOF;
    if Status and (Result = grOk) then
    begin
       with PRecInfo(Buffer + FRecInfoOfs)^ do
       begin
          BookmarkFlag := bfCurrent;
          RecordNumber := FDBFHandle.RecNumber;
       end;
       GetCalcFields(Buffer);
       RN := FDBFHandle.RecNumber;
       Str(RN:10,SRN);                            {!!RFG 100297}
       Move(SRN[0], Buffer[FBookmarkOfs], 11);    {!!RFG 100297}
       if Result = grError then Result := grOK;
    end
    else
    begin
      if not Status then
      begin
         Result := grError;
         if DoCheck then
           raise EDatabaseError.Create(gsErrRecordOutOfRange);  {!!RFG 102097}
      end;
    end;
 end;

function THalcyonDataSet.GetRecordSize: Word;
begin
  Result := FRecordSize;
end;

procedure THalcyonDataSet.InternalAddRecord(Buffer: Pointer; Append: Boolean);
begin
   SetCurRecord(PChar(Buffer));
   FDBFHandle.gsAppend;
   FDBFHandle.gsUnlock;
   FDoingEdit := false;
   RestoreCurRecord;
end;

procedure THalcyonDataSet.InternalCancel;
begin
   FDBFHandle.gsUnlock;
   FDoingEdit := false;           {!!RFG 100197}
end;

procedure THalcyonDataSet.InternalClose;
begin
   BindFields(False);
   if DefaultFields then DestroyFields;
   if FDBFHandle <> nil then
      FDBFHandle.Free;
   FDBFHandle := nil;
end;

procedure THalcyonDataSet.InternalDelete;
begin
   SetCurRecord(ActiveBuffer);
   FDBFHandle.UseDeletedRec := true;
   try
      FDBFHandle.gsDeleteRec;
   except
      DatabaseError(gsErrDeleteRecord);
   end;
   RestoreCurRecord;
   FDBFHandle.UseDeletedRec := FUseDeleted;
   FDBFHandle.gsGetRec(Same_Record);
   if FDBFHandle.File_EOF then              {%FIX0011}
   begin
      FDBFHandle.gsGetRec(Prev_Record);
      FDBFHandle.File_EOF := true;
   end;
end;

procedure THalcyonDataSet.InternalFirst;
begin
   FBeforeBOF := true;
   FAfterEOF := false;
end;

procedure THalcyonDataSet.InternalGotoBookmark(Bookmark: Pointer);
var
   RN: integer;
begin
   SetCurRecord(PChar(DBFHandle.CurRecHold));
   try
      RN := StrToInt(PChar(BookMark));
      FDBFHandle.gsGetRec(RN);
   except
      DataBaseError(gsErrInvalidBookmark+FTableName);
   end;
   RestoreCurRecord;
end;

procedure THalcyonDataSet.InternalHandleException;
begin
end;

procedure THalcyonDataSet.InternalInitFieldDefs;
var
   I: Integer;
   IsClosed: boolean;
begin
   FieldDefs.Clear;
   IsClosed := FDBFHandle = nil;
   if IsClosed then
   begin
      OpenDBFFile(false,true);
   end;
   if FDBFHandle <> nil then
      for I := 0 to pred(FDBFHandle.NumFields) do
         AddFieldDesc(I + 1);
   if IsClosed then
   begin
      if FDBFHandle <> nil then
         FDBFHandle.Free;
      FDBFHandle := nil;
   end;
end;

procedure THalcyonDataSet.InternalInitRecord(Buffer: PChar);   {!!RFG 042198}
begin
   SetCurRecord(Buffer);
   FDBFHandle.gsBlank;
   if (State <> dsEdit) then
      Move(FDBFHandle.CurRecord^[0],FDBFHandle.OrigRec^[0],FDBFHandle.RecLen); {!!RFG 100197}
   RestoreCurRecord;
end;

procedure THalcyonDataSet.InternalLast;
begin
   SetCurRecord(PChar(DBFHandle.CurRecHold));
   FDBFHandle.gsGetRec(Bttm_Record);
   FAfterEOF := true;
   RestoreCurRecord;
end;

procedure THalcyonDataSet.InternalOpen;
begin
   OpenDBFFile(not FReadOnly, not FExclusive);
   FDBFHandle.gsvAutoFlush := FAutoFlush;
   FDBFHandle.UseDeletedRec := FUseDeleted;
   FDBFHandle.gsSetDBFCache(FUseDBFCache);    {!!RFG 011898}
   FDBFHandle.gsSetLockProtocol(GSsetLokProtocol(FLokProtocol));
   FDBFHandle.gsAssignUserID(FUserID);

   InternalInitFieldDefs;

{   GetIndexInfo;}

   if DefaultFields then CreateFields;
   BindFields(True);
   InitBufferPointers;
   if Filtered then
   begin
      DBFHandle.gsSetFilterActive(true);  {%FIX0002}
      DBFHandle.gsSetFilterExpr(Filter, foCaseInsensitive in FilterOptions, not (foNoPartialCompare in FilterOptions));
   end;
   InternalFirst;
   SetIndexList(FIndexFiles);
   FDoingEdit := false;          {!!RFG 100197}
   CheckMasterRange;
end;

procedure THalcyonDataSet.DoAfterInsert;
begin
   FDBFHandle.File_TOF := false;
   FDBFHandle.File_EOF := true;
   inherited DoAfterInsert;
end;

procedure THalcyonDataSet.InternalEdit;
begin
   SetCurRecord(ActiveBuffer);
   FDBFHandle.gsGetRec(PRecInfo(ActiveBuffer + FRecInfoOfs).RecordNumber);
   if not FDBFHandle.gsRLock then
      DatabaseError(gsErrRecordLockAlready);
   FDoingEdit := true;          {!!RFG 100197}
   RestoreCurRecord;
end;

procedure THalcyonDataSet.InternalPost;
begin
   SetCurRecord(ActiveBuffer);
   try
      if State = dsEdit then
         FDBFHandle.gsPutRec(FDBFHandle.RecNumber)
      else
         FDBFHandle.gsAppend;
   finally
      RestoreCurRecord;
   end;
   FDBFHandle.gsUnlock;
   FDoingEdit := false;        {!!RFG 100197}
   FAfterEOF := false;         {!!RFG 102097}
   FBeforeBOF := false;        {!!RFG 102097}
 end;

procedure THalcyonDataSet.InternalRefresh;
begin
   SetCurRecord(ActiveBuffer);
   FDBFHandle.gsGetRec(PRecInfo(ActiveBuffer + FRecInfoOfs).RecordNumber);
   RestoreCurRecord;
   FDBFHandle.gsRefreshFilter;
end;

procedure THalcyonDataSet.InternalSetToRecord(Buffer: PChar);
begin
  InternalGotoBookmark(Buffer + FBookmarkOfs);
end;

function THalcyonDataSet.IsCursorOpen: Boolean;
begin
  Result := FDBFHandle <> nil;
end;

procedure THalcyonDataSet.SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag);
begin
  PRecInfo(Buffer + FRecInfoOfs).BookmarkFlag := Value;
end;

procedure THalcyonDataSet.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Move(Data^, ActiveBuffer[FBookmarkOfs], BookmarkSize);
end;

procedure THalcyonDataSet.SetFieldData(Field: TField; Buffer: Pointer);
var
   RecBuf: PChar;
   td: TDateTime;
   ts: TTimeStamp;
   s: gsUTFString;
   f: double;
   i64: Int64;
   fext: Extended;
   b: boolean;
begin
   with Field do
   begin
      if not (State in dsWriteModes) then DatabaseError(gsErrNotEditing);
      if (State = dsSetKey) and
         ((FieldNo < 0) or (FDBFHandle.NumFields > 0) and
         not IsIndexField) then
            DatabaseErrorFmt(SNotIndexField, [DisplayName]);
      GetActiveRecBuf(RecBuf);
      if FieldNo > 0 then
      begin
         if State = dsCalcFields then DatabaseError(gsErrNotEditing);
         if ReadOnly and not (State in [dsSetKey, dsFilter]) then
            DatabaseErrorFmt(SFieldReadOnly, [DisplayName]);
         Validate(Buffer);
         if FieldKind <> fkInternalCalc then
         begin
            SetCurRecord(RecBuf);
            try
               case DataType of
                  ftString  : begin
                                 s := '';
                                 if Buffer <> nil then          {!!RFG 020398}
                                    s := StrPas(PChar(Buffer));
                                 FDBFHandle.gsStringPutN(FieldNo,s);
                              end;
                  ftBoolean : begin
                                 b := false;
                                 if Buffer <> nil then
                                    b := boolean(Buffer^);       {!!RFG 020398}
                                 FDBFHandle.gsLogicPutN(FieldNo, b);
                              end;
                  ftDate    : begin                 {!!RFG 090997}
                                 ts.Time := 0;
                                 if Buffer <> nil then
                                 begin
                                    try
                                       ts.Date := LongInt(Buffer^);
                                       td := TimeStampToDateTime(ts);
                                       s := FormatDateTime('yyyymmdd',td);
                                    except
                                       s := '        ';
                                    end;
                                 end
                                 else
                                    s := '        ';
                                 FDBFHandle.gsFieldPutN(FieldNo,s);
                              end;
                  ftDateTime: begin
                                 f := 0.0;
                                 if Buffer <> nil then          {!!RFG 020398}
                                    move(Buffer^,f,DataSize);
                                 FDBFHandle.gsNumberPutN(FieldNo, f);
                              end;
                  ftFloat   : begin
                                 f := 0.0;
                                 if Buffer <> nil then          {!!RFG 020398}
                                    move(Buffer^,f,DataSize);
                                 FDBFHandle.gsNumberPutN(FieldNo, f);
                              end;
                  ftSmallInt: begin
                                 i64 := 0;
                                 if Buffer <> nil then          {!!RFG 020398}
                                    i64 := Smallint(Buffer^);      {!!RFG 021998}
                                 fext := i64;
                                 FDBFHandle.gsNumberPutN(FieldNo,fext);
                              end;
                  ftInteger : begin
                                 i64 := 0;
                                 if Buffer <> nil then          {!!RFG 020398}
                                    i64 := Integer(Buffer^);      {!!RFG 021998}
                                 fext := i64;
                                 FDBFHandle.gsNumberPutN(FieldNo,fext);
                              end;
                  {$IFDEF HASINT64}
                  ftLargeint : begin
                                 i64 := 0;
                                 if Buffer <> nil then
                                    i64 := Int64(Buffer^);
                                 fext := i64;
                                 FDBFHandle.gsNumberPutN(FieldNo,fext);
                              end;
                  {$ENDIF}
               end;
            finally
               RestoreCurRecord;
            end;
         end;
      end else {fkCalculated, fkLookup}
      begin
         Inc(RecBuf, FRecordSize + Offset);
         Boolean(RecBuf[0]) := LongBool(Buffer);
         if Boolean(RecBuf[0]) then Move(Buffer^, RecBuf[1], DataSize);
      end;
      if not (State in [dsCalcFields, dsFilter, dsSetKey, dsNewValue]) then
         DataEvent(deFieldChange, Longint(Field));
   end;
end;

procedure THalcyonDataSet.DoOnFilter(var tf: boolean);
var
   ts: TDataSetState;
begin
   if FRenaming then exit;
   if State = dsInactive then exit;
   if not Filtered then exit;
   if Assigned(OnFilterRecord) then
   begin
      ts := SetTempState(dsFilter);
      try                              {!!RFG 050898}
         OnFilterRecord(Self,tf);
      finally
         RestoreState(ts);
      end;
   end;
end;

procedure THalcyonDataset.DoOnStatus(stat1, stat2, stat3: longint);
begin
   if FRenaming then exit;
   if assigned(FOnStatus) then FOnStatus(stat1,stat2,stat3);
end;


{$IFDEF VER120}
function THalcyonDataSet.Translate(Src, Dest: PChar; ToOem: Boolean): integer;
{$ELSE}
procedure THalcyonDataSet.Translate(Src, Dest: PChar; ToOem: Boolean);
{$ENDIF}
var
  Len: Integer;
begin
  {$IFDEF VER120}
  Result := StrLen(Src);
  {$ENDIF}
  if Src = nil then                       {!!RFG 111897}
  begin                                   {!!RFG 111897}
     if Dest <> nil then Dest[0] := #0;   {!!RFG 111897}
  end                                     {!!RFG 111897}
  else                                    {!!RFG 111897}
  begin
     if FTranslateASCII then              {!!RFG 032798}
     begin
        Len := StrLen(Src);
        if ToOem then
          gsSysCharToOEM(Src, Dest, Len)
        else
          gsSysOEMToChar(Src, Dest, Len);
     end
     else
     begin
        if Src <> Dest then
           Move(Src[0], Dest[0], StrLen(Src));
     end;
  end;                                    {!!RFG 111897}
end;

Function THalcyonDataSet.IsDeleted : boolean;
begin
   Result := false;
   if ActiveBuffer = nil then exit;
   Result := ActiveBuffer[0] = '*';
end;

procedure THalcyonDataSet.InternalRecall;
begin
   SetCurRecord(ActiveBuffer);
   FDBFHandle.UseDeletedRec := true;
   try
      FDBFHandle.gsUnDelete;
   except
      RestoreCurRecord;
      DatabaseError(gsErrUndeleteRecord);
   end;
   RestoreCurRecord;
   FDBFHandle.UseDeletedRec := FUseDeleted;
end;

procedure THalcyonDataSet.Recall;
begin
  CheckActive;
  if State in [dsInsert, dsSetKey] then Cancel else
  begin
    if RecordCount = 0 then DatabaseError(SDataSetEmpty);
    DataEvent(deCheckBrowseMode, 0);
    DoBeforeScroll;
    UpdateCursorPos;
    InternalRecall;
    FreeFieldBuffers;
    SetState(dsBrowse);
    Resync([]);
    DoAfterScroll;
  end;
end;

procedure THalcyonDataSet.RestoreCurRecord;
begin
   if State = dsFilter then exit;            {!!RFG 050898}
   FDBFHandle.CurRecord := FDBFHandle.CurRecHold;
end;

function THalcyonDataSet.SetCurRecord(CurRec: PChar): PChar;
begin
   Result := PChar(FDBFHandle.CurRecord);
   if State = dsFilter then exit;            {!!RFG 050898}
   if CurRec <> nil then
   begin
      FDBFHandle.CurRecord := pointer(CurRec);
   end
   else
      Result := nil;
end;

Function THalcyonDataset.Find(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
var
   ps: array[0..255] of char;
   rn: longint;
begin
   CheckBrowseMode;
   FAfterEOF := false;
   if DBFHandle.IndexMaster = nil then
      DataBaseError(gsErrIndexFind);
   rn := GetRecNo;
   if (FDBFHandle.NumRecs = 0) or (rn=0) or (ActiveBuffer = nil) then    {!!RFG 04261999}
   begin
      Result := false;
      exit;
   end;
   DoBeforeScroll;
   CursorPosChanged;
   FDBFHandle.gsvExactMatch := IsExact;
   FDBFHandle.gsvFindNear := IsNear;
   StrPCopy(ps,ss);
   Translate(ps,ps,true);
   Result := FDBFHandle.gsFind(StrPas(ps));
   if Result or (IsNear and (not FDBFHandle.File_EOF)) then
   begin
      Resync([rmExact, rmCenter]);
   end
   else
   begin
      Last;
      exit;
   end;
   DoAfterScroll;
end;

procedure THalcyonDataSet.GetIndexTagList(List: TStrings);
var
   i: integer;
   j: integer;
   k: integer;
   t: GSobjIndexTag;
   dbactive: boolean;
begin
   List.Clear;
   dbactive := FDBFHandle <> nil;
   if not dbactive then
      try
         Active := true;
      except
      end;
   if FDBFHandle = nil then exit;
   for i := 1 to IndexesAvail do
   begin
      if FDBFHandle.IndexStack[i] <> nil then
      begin
         k := FDBFHandle.IndexStack[i].TagCount;
         for j := 0 to pred(k) do
         begin
            t := FDBFHandle.IndexStack[i].TagByNumber(j);
            List.Add(t.TagName);
         end;
      end;
   end;
   Active := dbactive;
end;

procedure THalcyonDataSet.GetDatabaseNames(List: TStrings);
var
   i: integer;
   s: gsUTFString;
begin
   List.Clear;
   for i := 0 to AliasList.Count-1 do
   begin
      s  := AliasList[i];
      system.delete(s,pos('=',s),255);
      List.Add(s);
   end;
end;

procedure THalcyonDataSet.SetRange(const RLo, RHi: gsUTFString);
var
   pLo: array[0..255] of char;
   pHi: array[0..255] of char;
begin
   CheckBrowseMode;
   StrPCopy(pLo,RLo);
   StrPCopy(pHi,RHi);
   Translate(pLo,pLo,true);
   Translate(pHi,pHi,true);
   if FDBFHandle.gsSetRange(StrPas(pLo),StrPas(pHi),true,true,false) then
      First;
end;

procedure THalcyonDataSet.SetRangeEx(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean);
var
   pLo: array[0..255] of char;
   pHi: array[0..255] of char;
begin
   CheckBrowseMode;
   StrPCopy(pLo,RLo);
   StrPCopy(pHi,RHi);
   Translate(pLo,pLo,true);
   Translate(pHi,pHi,true);
   FDBFHandle.gsSetRange(StrPas(pLo),StrPas(pHi),LoIn,HiIn,Partial);
   First;
end;

Procedure THalcyonDataSet.Reindex;
begin
   CheckBrowseMode;
   FDBFHandle.gsReindex;
end;

Function THalcyonDataSet.CreateDBF(const fname, apassword: gsUTFString; ftype: char;
                                fproc: dbInsertFieldProc): boolean;
begin
   CreateDBF := gsCreateDBF(fname,ftype,fproc);
end;

Procedure THalcyonDataSet.FlushDBF;
begin
   CheckBrowseMode;
   FDBFHandle.gsGetRec(Same_Record);
   FDBFHandle.dStatus := gs6_DBF.Updated;
   FDBFHandle.gsFlush;
end;

Procedure THalcyonDataSet.Index(const IName, Tag: gsUTFString);
var
   sl: TStringList;
   s: gsUTFString;
   i: integer;
   lm: integer;
   nq: boolean;
begin
   CheckBrowseMode;
   IndexDefs.Updated := False;
   sl := TStringList.Create;
   lm := length(IName);
   nq := true;
   i := 1;
   s := '';
   while (i <=lm) and (IName[i] in [' ',',',';']) do inc(i);
   while i <= lm do
   begin
      if (IName[i] in [',',';']) and nq then                  {!!RFG 040501}
      begin
         if length(s) > 0 then
            sl.Add(Trim(s));                                  {!!RFG 040501}
         s := '';
         while (i <=lm) and (IName[i] in [' ',',',';']) do inc(i);
      end
      else
      begin
         if IName[i] = '"' then
            nq := not nq
         else
            s := s + IName[i];
         inc(i);
      end;
   end;
   if length(s) > 0 then
      sl.Add(Trim(s));                                        {!!RFG 040501}
   FIndexFiles.Assign(sl);
   sl.Free;
   IndexName := Tag;
end;

Procedure  THalcyonDataSet.IndexFileInclude(const IName: gsUTFString);
begin
   CheckActive;
   IndexDefs.Updated := False;
   FDBFHandle.gsIndexRoute(IName);
end;

Procedure  THalcyonDataSet.IndexFileRemove(const IName: gsUTFString);
begin
   CheckActive;
   IndexDefs.Updated := False;
   FDBFHandle.gsIndexFileRemove(IName);
end;

Procedure THalcyonDataSet.IndexTagRemove(const IName, Tag: gsUTFString);
begin
   CheckActive;
   IndexDefs.Updated := False;
   FDBFHandle.gsIndexTagRemove(IName, Tag);
end;

Procedure THalcyonDataSet.IndexOn(const IName, tag, keyexp, forexp: gsUTFString;
                         uniq: TgsIndexUnique; ascnd: TgsSortStatus);
begin
   CheckBrowseMode;
   IndexDefs.Updated := False;
   FActivity := aIndexing;
   DisableControls;
   try
      FDBFHandle.gsIndexTo(IName, tag, keyexp, forexp,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
   finally
      FActivity := aNormal;
      EnableControls;
      First;
   end;
end;

function THalcyonDataSet.IndexExpression(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   Result := '';
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      Result := p.IndexExpression;
end;

function THalcyonDataSet.IndexFilter(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   Result := '';
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if (p <> nil) and (Length(p.ForExpr) > 0) then
      Result := p.ForExpr;
end;

function THalcyonDataSet.IndexKeyLength(Value: integer): integer;
var
   p: GSobjIndexTag;
begin
   IndexKeyLength := 0;
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if (p <> nil) then
      Result := p.KeyLength;
end;

function THalcyonDataSet.IndexUnique(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   Result := false;
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      Result := p.UniqueKey;
end;

function THalcyonDataSet.IndexAscending(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   Result := true;
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      Result := p.AscendKey;
end;

function THalcyonDataSet.IndexFileName(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   Result := '';
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      Result := p.Owner.IndexName;
end;

function THalcyonDataSet.IndexTagName(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   Result := '';
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      Result := p.TagName;
end;

function THalcyonDataSet.IndexCount: integer;
var
   i: integer;
   n: integer;
begin
   n := 0;
   CheckActive;
   i := 1;
   while (i <= IndexesAvail) do
   begin
      if FDBFHandle.IndexStack[i] <> nil then
         n := n + FDBFHandle.IndexStack[i].TagCount;
      inc(i);
   end;
   Result := n;
end;

function THalcyonDataSet.IndexCurrent: gsUTFString;
begin
   Result := '';
   CheckActive;
   if FDBFHandle.IndexMaster <> nil then
      Result := FDBFHandle.IndexMaster.TagName;
end;

function THalcyonDataset.IndexKeyValue(Value: integer): gsUTFString;
var
   expvar: TgsVariant;
begin
   Result := '';
   CheckActiveSet;
   expvar := TgsVariant.Create(256);
   if FDBFHandle.gsIndexKeyValue(Value,expvar) then
      Result := expvar.GetString;
   expvar.Free;
   if not FUpdatingIndexDesc then
      RestoreCurRecord;
end;

function THalcyonDataSet.IndexCurrentOrder: integer;
var
   p: GSobjIndexTag;
   i: integer;
   n: integer;
   ni: integer;
begin
   Result := 0;
   CheckActive;
   with FDBFHandle do
   begin
      p := nil;
      n := 0;
      if IndexMaster <> nil then
      begin
         ni := 0;
         i := 1;
         while (p = nil) and (i <= IndexesAvail) do
         begin
            if IndexStack[i] <> nil then
            begin
               p := IndexStack[i].TagByNumber(ni);
               inc(ni);
               if p <> nil then
               begin
                  inc(n);
                  if gsStrCompare(p.TagName,PrimaryTagName) <> 0 then
                     p := nil;
               end
               else
               begin
                  inc(i);
                  ni := 0;
               end;
            end;
         end;
      end;
   end;
   if p <> nil then
      Result := n;
end;

procedure THalcyonDataSet.IndexIsProduction(tf: boolean);
begin
   CheckActive;
   if tf then
      FDBFHandle.IndexFlag := $01
   else
      FDBFHandle.IndexFlag := $00;
   FDBFHandle.WithIndex := tf;
   FDBFHandle.dStatus := gs6_dbf.Updated;
   FDBFHandle.gsHdrWrite;          {!!RFG 081897}
end;

function THalcyonDataSet.Locate(const KeyFields: gsUTFString;const KeyValues: Variant;Options: TLocateOptions): Boolean;
var
   rnum: longint;
begin
   CheckActive;
   CheckBrowseMode;
   rnum := GetRecNo;
   SetCurRecord(PChar(DBFHandle.CurRecHold));
   FAfterEOF := false;
   Result := DBFHandle.gsLocateRecord(KeyFields, KeyValues,(loCaseInsensitive in Options),(loPartialKey in Options));
   if Result then
   begin
      DoBeforeScroll;
      Resync([rmExact, rmCenter]);
      DoAfterScroll;
   end
   else
   begin
      FDBFHandle.gsGetRec(rnum);
   end;
end;

function THalcyonDataSet.Lookup(const KeyFields: gsUTFString; const KeyValues: Variant;
  const ResultFields: gsUTFString): Variant;
var                                            {!!RFG 100997}
   rnum: longint;
begin
   CheckActive;
   CheckBrowseMode;
   rnum := GetRecNo;
   SetCurRecord(TempBuffer);
   FAfterEOF := false;
   if DBFHandle.gsLocateRecord(KeyFields, KeyValues,false,false) then
   begin
      SetTempState(dsCalcFields);
      try
         CalculateFields(TempBuffer);
         Result := FieldValues[ResultFields];
      finally
         RestoreState(dsBrowse);
      end;
   end
   else
      Result := null;
   RestoreCurRecord;
   FDBFHandle.gsGetRec(rnum);
end;

function THalcyonDataSet.IsSequenced: Boolean;
begin
  Result := (FDBFHandle.IndexMaster = nil) and (not Filtered);
end;

Procedure THalcyonDataSet.CopyRecordTo(area: THalcyonDataSet);
begin
   CheckBrowseMode;
   if area.FDBFHandle = nil then
   begin
      DatabaseError(SDataSetClosed);
      exit;
   end;
   SetCurRecord(ActiveBuffer);
   FDBFHandle.gsCopyRecord(area.FDBFHandle);
   area.RecNo := area.FDBFHandle.RecNumber;
   RestoreCurRecord;
   Refresh;
end;

Procedure THalcyonDataSet.CopyStructure(const filname, apassword: gsUTFString);
var
   FCopy  : GSO_dBHandler;
begin
   CheckActive;
   FDBFHandle.gsCopyStructure(filname);
   if apassword <> '' then
   begin
      FCopy := GSO_dBHandler.Create(filname, '',true,false);
      FCopy.gsSetPassword(apassword);
      FCopy.Free;
   end;
end;

Procedure THalcyonDataSet.CopyTo(const filname, apassword: gsUTFString);
begin
   CheckBrowseMode;
   FActivity := aCopying;
   DisableControls;
   try
      FDBFHandle.gsCopyFile(filname, apassword);
   finally
      FActivity := aNormal;
      EnableControls;
      First;
   end;
end;

Function THalcyonDataSet.FLock : boolean;
begin
   CheckActive;
   FLock := FDBFHandle.gsFLock;
end;

Procedure THalcyonDataSet.Pack;
begin
   CheckBrowseMode;
   FDBFHandle.gsSetDBFCacheAllowed(false);  {!!RFG 040698}
   FDBFHandle.gsPack;
   First;
end;

Function THalcyonDataSet.RLock : boolean;
var
   rn: longint;
begin
   CheckActive;
   rn := FDBFHandle.RecNumber;            {!!FIX0022}
   FDBFHandle.RecNumber := GetRecNo;
   RLock := FDBFHandle.gsRLock;
   FDBFHandle.RecNumber := rn;
end;

Procedure THalcyonDataSet.SetDBFCache(tf: boolean);
begin
   FUseDBFCache := tf;
   if FDBFHandle = nil then exit;
   FDBFHandle.gsSetDBFCache(tf);
end;

Procedure THalcyonDataSet.SetLockProtocol(LokProtocol: TgsLokProtocol);
begin
   FLokProtocol := LokProtocol;
   if FDBFHandle = nil then exit;
   FDBFHandle.gsSetLockProtocol(GSsetLokProtocol(LokProtocol))
end;

Procedure THalcyonDataSet.SetTagTo(const TName: gsUTFString);
begin
   CheckActive;
   IndexName := TName;
end;

Procedure THalcyonDataSet.SetTempDirectory(const Value: gsUTFString);
begin
   FillChar(FTempDir[0],SizeOf(FTempDir),#0);
   if length(Value) > 0 then
   begin
      StrPCopy(FTempDir,Value);
      if Value[length(Value)] <> GSFileSep then
         FTempDir[StrLen(FTempDir)] := GSFileSep;
   end;
   if FDBFHandle = nil then exit;
   StrDispose(FDBFHandle.gsvTempDir);
   FDBFHandle.gsvTempDir := StrNew(FTempDir);
end;

Procedure THalcyonDataSet.SortTo(const filname, apassword, formla: gsUTFString; sortseq : TgsSortStatus);
begin
   CheckBrowseMode;
   FActivity := aCopying;
   DisableControls;
   try
      FDBFHandle.gsSortFile(filname, apassword, formla, GSsetSortStatus(sortseq));
   finally
      FActivity := aNormal;
      EnableControls;
      First;
   end;
   CheckBrowseMode;
end;

Procedure THalcyonDataSet.Unlock;
begin
   CheckActive;
   FDBFHandle.gsLockOff;
end;

Procedure THalcyonDataSet.Zap;
begin
   CheckBrowseMode;
   FDBFHandle.gsZap;
   First;
end;





{------------------------------------------------------------------------------
                           Database Search Routine
------------------------------------------------------------------------------}

Function THalcyonDataSet.SearchDBF(const s : gsUTFString; var FNum : word;
                          var fromrec: longint; toRec: longint): word;
begin
   CheckBrowseMode;
   DisableControls;
   try
      DoBeforeScroll;
      Result := FDBFHandle.gsSearchDBF(s,FNum,fromrec,torec);
      if Result > 0 then
      begin
         Resync([rmExact, rmCenter]);
         DoAfterScroll;
      end;
   finally
      EnableControls;
   end;
end;
{------------------------------------------------------------------------------
                           Field Access Routines
------------------------------------------------------------------------------}



Function THalcyonDataSet.MemoSize(const fnam: gsUTFString): longint;
begin
   CheckActiveSet;
   MemoSize := FDBFHandle.gsMemoSize(fnam);
   RestoreCurRecord;
end;

Function THalcyonDataSet.MemoSizeN(fnum: integer): longint;
begin
   CheckActiveSet;
   MemoSizeN := FDBFHandle.gsMemoSizeN(fnum);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.MemoLoad(const fnam: gsUTFString;buf: pointer; var cb: longint);
begin
   CheckActiveSet;
   FDBFHandle.gsMemoLoad(fnam,buf,cb);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.MemoLoadN(fnum: integer;buf: pointer; var cb: longint);
begin
   CheckActiveSet;
   FDBFHandle.gsMemoLoadN(fnum,buf,cb);
   RestoreCurRecord;
end;

Function THalcyonDataSet.MemoSave(const fnam: gsUTFString;buf: pointer; var cb: longint): longint;
begin
   MemoSave := 0;
   CheckActiveSet;
   if ConfirmEdit then
      MemoSave := FDBFHandle.gsMemoSave(fnam,buf,cb);
   RestoreCurRecord;
end;

Function THalcyonDataSet.MemoSaveN(fnum: integer;buf: pointer; var cb: longint): longint;
begin
   MemoSaveN := 0;
   CheckActiveSet;
   if ConfirmEdit then
      MemoSaveN := FDBFHandle.gsMemoSaveN(fnum,buf,cb);
   RestoreCurRecord;
end;


Function THalcyonDataSet.DateGet(const st : gsUTFString) : longint;
begin
   CheckActiveSet;
   DateGet := FDBFHandle.gsDateGet(st);
   RestoreCurRecord;
end;

Function THalcyonDataSet.DateGetN(n : integer) : longint;
begin
   CheckActiveSet;
   DateGetN := FDBFHandle.gsDateGetN(n);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.DatePut(const st : gsUTFString; jdte : longint);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsDatePut(st, jdte);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.DatePutN(n : integer; jdte : longint);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsDatePutN(n, jdte);
   RestoreCurRecord;
end;

Function THalcyonDataSet.FieldGet(const fnam : gsUTFString) : gsUTFString;
begin
   CheckActiveSet;
   FieldGet := FDBFHandle.gsFieldGet(fnam);
   RestoreCurRecord;
end;

Function THalcyonDataSet.FieldGetN(fnum : integer) : gsUTFString;
begin
   CheckActiveSet;
   FieldGetN := FDBFHandle.gsFieldGetN(fnum);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.FieldPut(const fnam, st : gsUTFString);
begin
   CheckActiveSet;
   FDBFHandle.gsFieldPut(fnam, st);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.FieldPutN(fnum : integer; st : gsUTFString);
begin
   CheckActiveSet;
   FDBFHandle.gsFieldPutN(fnum, st);
   RestoreCurRecord;
end;

Function THalcyonDataSet.FloatGet(const st : gsUTFString) : FloatNum;
begin
   CheckActiveSet;
   FloatGet := FDBFHandle.gsNumberGet(st);
   RestoreCurRecord;
end;

Function THalcyonDataSet.FloatGetN(n : integer) : FloatNum;
begin
   CheckActiveSet;
   FloatGetN := FDBFHandle.gsNumberGetN(n);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.FloatPut(const st : gsUTFString; r : FloatNum);
begin
   CheckActiveSet;
   FDBFHandle.gsNumberPut(st, r);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.FloatPutN(n : integer; r : FloatNum);
begin
   CheckActiveSet;
   FDBFHandle.gsNumberPutN(n, r);
   RestoreCurRecord;
end;

Function THalcyonDataSet.LogicGet(const st : gsUTFString) : boolean;
begin
   CheckActiveSet;
   LogicGet := FDBFHandle.gsLogicGet(st);
   RestoreCurRecord;
end;

Function THalcyonDataSet.LogicGetN(n : integer) : boolean;
begin
   CheckActiveSet;
   LogicGetN := FDBFHandle.gsLogicGetN(n);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.LogicPut(const st : gsUTFString; b : boolean);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsLogicPut(st, b);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.LogicPutN(n : integer; b : boolean);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsLogicPutN(n, b);
   RestoreCurRecord;
end;

Function THalcyonDataSet.IntegerGet(const st : gsUTFString) : Int64;
var
   r : Extended;
begin
   CheckActiveSet;
   r := FDBFHandle.gsNumberGet(st);
   {$IFDEF HASINT64}
   IntegerGet := Trunc(r);
   {$ELSE}
   IntegerGet := r;
   {$ENDIF}
   RestoreCurRecord;
end;

Function THalcyonDataSet.IntegerGetN(n : integer) : Int64;
var
   r : Extended;
begin
   CheckActiveSet;
   r := FDBFHandle.gsNumberGetN(n);
   {$IFDEF HASINT64}
   IntegerGetN := Trunc(r);
   {$ELSE}
   IntegerGetN := r;
   {$ENDIF}
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.IntegerPut(const st : gsUTFString; i : Int64);
var
   r : Extended;
begin
   CheckActiveSet;
   r := i;
   FDBFHandle.gsNumberPut(st, r);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.IntegerPutN(n : integer; i : Int64);
var
   r : Extended;
begin
   CheckActiveSet;
   r := i;
   FDBFHandle.gsNumberPutN(n, r);
   RestoreCurRecord;
end;

Function THalcyonDataSet.StringGet(const fnam : gsUTFString) : gsUTFString;
var
   st: gsUTFString;
begin
   CheckActiveSet;
   st := FDBFHandle.gsStringGet(fnam);
   Result := st;
   RestoreCurRecord;
end;

Function THalcyonDataSet.StringGetN(fnum : integer) : gsUTFString;
var
   st: gsUTFString;
begin
   CheckActiveSet;
   st := FDBFHandle.gsStringGetN(fnum);
   Result := st;
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.StringPut(const fnam, st : gsUTFString);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsStringPut(fnam, st);
   RestoreCurRecord;
end;

Procedure THalcyonDataSet.StringPutN(fnum : integer; st : gsUTFString);
begin
   CheckActiveSet;
   if ConfirmEdit then
      FDBFHandle.gsStringPutN(fnum, st);
   RestoreCurRecord;
end;

Function THalcyonDataSet.MemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
            uniq: TgsIndexUnique; ascnd: TgsSortStatus): boolean;
begin
   CheckBrowseMode;
   FActivity := aIndexing;
   DisableControls;
   try
      Result := FDBFHandle.gsMemoryIndexAdd(Tag, keyexpr, forexpr,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
      if Result then
         FIndexName := StrPas(FDBFHandle.PrimaryTagName);
   finally
      FActivity := aNormal;
      EnableControls;
      First;
   end;
end;

procedure THalcyonDataSet.CheckActive;
begin
   if FUpdatingIndexDesc then exit;
   inherited CheckActive;
   case FActivity of
      aIndexing : DatabaseError(gsErrBusyIndexing);
      aCopying  : DatabaseError(gsErrBusyCopying);
   end;
end;

procedure THalcyonDataSet.CheckActiveSet;
begin
   CheckActive;
   if not FUpdatingIndexDesc then
      SetCurRecord(ActiveBuffer);
end;

Procedure THalcyonDataset.ReturnDateTimeUser(var dt, tm, us: longint);
begin
   dt := 0;
   tm := 0;
   us := 0;
   CheckActive;
   FDBFHandle.gsReturnDateTimeUser(dt,tm,us);
end;

Function THalcyonDataset.ExternalChange : integer;
begin
   CheckActive;
   ExternalChange := FDBFHandle.gsExternalChange;
end;

procedure THalcyonDataset.AssignUserID(id: longint);
begin
   FUserID := id;
   if FDBFHandle <> nil then
      FDBFHandle.gsAssignUserID(id);
end;

function THalcyonDataSet.GetCanModify: Boolean;   {!!RFG 100197}
begin
  Result := not FReadOnly;
end;

function THalcyonDataSet.CompareBookmarks(Bookmark1, Bookmark2: TBookmark): Integer;
begin                                                     {!!RFG 100197}
   Result := 9;
   if Bookmark1 = nil then
   begin
      if Bookmark2 <> nil then
         Result := -1
      else
         Result := 0;
   end
   else
      if Bookmark2 = nil then
         Result := 1;
   if Result = 9 then
   begin
      Result := gsBufCompare(PChar(BookMark1),PChar(Bookmark2));
      if Result < 0 then
         Result := -1
      else
         if Result > 0 then
            Result := 1;
   end;
end;

function THalcyonDataSet.HuntDuplicate(const st, ky: gsUTFString): longint;
begin                                                       {!!RFG 082097}
   HuntDuplicate := -1;
   if FDBFHandle = nil then exit;
   HuntDuplicate := FDBFHandle.gsHuntDuplicate(st,ky);
end;

function THalcyonDataSet.SetPrimaryTag(const TName: gsUTFString; SameRec: boolean): integer; {!!RFG 043098}
var
   rn: longint;
begin
   if FDBFHandle = nil then
   begin
      Result := 0;
      exit;
   end;
   Result := FDBFHandle.gsSetTagTo(TName, false);
   if SameRec and Active and (not (DBFHandle.File_TOF or DBFHandle.File_EOF)) then
   begin
      rn := GetRecNo;
      if rn > 0 then
         DBFHandle.gsGetRec(rn);
   end;
end;

function THalcyonDataSet.GetDataSource: TDataSource;
begin
  Result := FMasterLink.DataSource;
end;

procedure THalcyonDataSet.SetDataSource(Value: TDataSource);
begin
  if IsLinkedTo(Value) then DatabaseError(SCircularDataLink);
  FMasterLink.DataSource := Value;

end;


function THalcyonDataset.GetMasterKey: gsUTFString;
var
   ds: TDataSet;
   Psn: integer;
   Ctr: integer;
   mfc: integer;
   mf: gsUTFString;
   il: gsUTFString;
   cf: gsUTFString;
   cv: Variant;
   wv: variant;
   tsl: TStringList;
   buf: PChar;
   expvar: TgsVariant;
begin
   if DBFHandle.IndexMaster = nil then
   begin
      DataBaseErrorFmt(gsErrRelationIndex,[FTableName]);
   end;
   ds := MasterSource.Dataset;
   if ds.State = dsInsert then
   begin
      Result := #1;
      exit;
   end;
   mf := MasterFields;
   if length(mf) > 0 then
   begin
      GetMem(buf,DBFHandle.RecLen);
      tsl := TStringList.Create;
    try
      Psn := 1;
      while Psn < length(mf) do
      begin
         cf := gsExtractFieldName(mf,Psn);
         tsl.Add(cf);
      end;
      mfc := tsl.Count;
      cv := VarArrayCreate([0, tsl.Count-1], varVariant);
      for Ctr := 0 to mfc-1 do
      begin
         wv := ds.FieldByName(tsl[Ctr]).AsString;
         cv[Ctr] := wv;
      end;
      tsl.Clear;
      il := FDBFHandle.IndexMaster.ExprHandlr.EnumerateType(gsSQLTypeVarDBF);
      if length(il) > 0 then
      begin
         Psn := 1;
         while Psn < length(il) do
         begin
            cf := gsExtractFieldName(il,Psn);
            tsl.Add(cf);
         end;
      end;
      if mfc > tsl.Count then
      begin
         DataBaseErrorFmt(gsErrRelationFields,[FTableName]);
      end;
      il := '';
      for Ctr := 0 to mfc-1 do
         il := il+tsl[Ctr]+';';
      DBFHandle.gsStuffABuffer(buf,il,cv);
      DBFHandle.CurRecord := pointer(buf);

      expvar := TgsVariant.Create(256);
      try
         FDBFHandle.IndexMaster.ExprHandlr.ExpressionAsVariant(expvar);
         Result := expvar.GetString;
      finally
         expvar.Free;
      end;
      DBFHandle.CurRecord := DBFHandle.CurRecHold;
    finally
      tsl.Free;
      FreeMem(buf,DBFHandle.RecLen);
    end;
   end;
end;


function THalcyonDataSet.GetMasterFields: gsUTFString;
begin
  Result := FMasterLink.FieldNames;
end;

procedure THalcyonDataSet.SetMasterFields(const Value: gsUTFString);
begin
  FMasterLink.FieldNames := Value;
end;

procedure THalcyonDataSet.MasterChanged(Sender: TObject);
var
   mf: gsUTFString;
begin
   if Assigned(MasterSource) and Assigned(MasterSource.DataSet) and
      MasterSource.Dataset.Active and (not MasterSource.Dataset.IsEmpty) then
   begin
      CheckBrowseMode;
      mf := GetMasterKey;
      if mf <> #1 then
         SetRangeEx(mf,mf,true,true,true);
   end;
end;

procedure THalcyonDataSet.MasterDisabled(Sender: TObject);
begin
   SetRange('','');
end;

procedure THalcyonDataSet.CheckMasterRange;
var
   mf: gsUTFString;
begin
   if Assigned(DBFHandle) and Assigned(MasterSource) and
      Assigned(MasterSource.DataSet) and
      MasterSource.Dataset.Active and (not MasterSource.Dataset.IsEmpty) then
   begin
      mf := GetMasterKey;
      if mf <> #1 then
         DBFHandle.gsSetRange(mf,mf,true,true,true);             {%FIX0008}
   end;
end;

procedure THalcyonDataSet.SetFilterData(const Text: gsUTFString; Options: TFilterOptions);
begin
   if Active and Filtered then
   begin
      CheckBrowseMode;
      DBFHandle.gsSetFilterActive(true);  {%FIX0002}
      DBFHandle.gsSetFilterExpr(Text, foCaseInsensitive in Options, not (foNoPartialCompare in Options));
      First;
   end;
   inherited SetFilterText(Text);
   inherited SetFilterOptions(Options);
end;

procedure THalcyonDataSet.SetFilterText(const Value: gsUTFString);
begin
  SetFilterData(Value, FilterOptions);
end;

procedure THalcyonDataSet.SetFilterOptions(Value: TFilterOptions);
begin
  SetFilterData(Filter, Value);
end;

procedure THalcyonDataSet.SetFiltered(Value: Boolean);
begin
   if Active then
   begin
      CheckBrowseMode;
      if Filtered <> Value then
      begin
         inherited SetFiltered(Value);
         DBFHandle.gsSetFilterActive(Value);
         if Value then
            SetFilterData(Filter,FilterOptions);
      end;
      First;
   end
   else
    inherited SetFiltered(Value);
end;

procedure THalcyonDataSet.RenameTable(const NewTableName: gsUTFString);
var
   i: integer;
   dbnamestring: gsUTFString;
   ixnamestring: gsUTFString;
   exnamestring: gsUTFString;
   exclu: boolean;
   filtr: boolean;
begin
   CheckInactive;
   exclu := FExclusive;
   FExclusive := true;
   filtr := Filtered;
   Filtered := false;
   FRenaming := true;
   try
      Open;
      dbnamestring := ExtractFileNameOnly(FDBFHandle.FileName);
      DBFHandle.gsRename(NewTableName);
      if FIndexFiles.Count > 0 then
      begin
         for i := 0 to pred(FIndexFiles.Count) do
         begin
            ixnamestring := ExtractFileNameOnly(FIndexFiles[i]);
            if gsStrCompareI(dbnamestring, ixnamestring) = 0 then
            begin
               exnamestring := ExtractFileExt(FIndexFiles[i]);
               FIndexFiles[i] := ChangeFileExt(NewTableName,exnamestring);
            end;
         end;
      end;
      Close;
      DatabaseName := ExtractFilePath(NewTableName);
      TableName := ExtractFileName(NewTableName);
   finally
      Filtered := filtr;
      FExclusive := exclu;
      FRenaming := false;
   end;
end;

procedure THalcyonDataSet.SetIndexDefs(Value: TIndexDefs);
begin
  IndexDefs.Assign(Value);
end;

procedure THalcyonDataSet.UpdateIndexDefs;
var
  AExpr: gsUTFString;
  AName: gsUTFString;
  AField: gsUTFString;
  Opts: TIndexOptions;
  I, J, K: integer;
begin
   if DBFHandle = nil then exit;
 try
   FUpdatingIndexDesc := true;
   IndexDefs.Clear;
   with DBFHandle do
   begin
      J := IndexCount;
      for I := 1 to J do
      begin
         Opts := [];
         AName := IndexTagName(I);
         AExpr := IndexExpression(I);
         if (Pos('(',AExpr)<>0) then
         begin
            Include(Opts,ixExpression);
            AField := AExpr;
         end
         else
         begin
            AField := '';
            for K := 1 to length(AExpr) do
               if (AExpr[K] in ['+','-']) then
                  AField := AField + ';'
               else
                  if AExpr[K] <> ' ' then
                     AField := AField + AExpr[K];
         end;
         IndexDefs.Add(AName,AField,Opts);
      end;
   end;
  finally
   FUpdatingIndexDesc := false;
  end;
end;

function THalcyonDataset.FindKey(const KeyValues: array of const): Boolean;
var
   s: gsUTFString;
   rnum: longint;
begin
   CheckActive;
   CheckBrowseMode;
   if DBFHandle.IndexMaster = nil then
      DataBaseError(gsErrIndexFind);
   Result := false;
   if (FDBFHandle.NumRecs = 0) or (RecNo=0) or (ActiveBuffer = nil) then exit;
   rnum := GetRecNo;
   DoBeforeScroll;
   CursorPosChanged;
   s := DBFHandle.gsBuildKey(KeyValues,FDBFHandle.IndexMaster.ExprHandlr);
   if FindThisRecord(s,false,false) then
   begin
      Result := true;
      Resync([rmExact, rmCenter]);
      DoAfterScroll;
   end
   else
      FDBFHandle.gsGetRec(rnum);
   DoAfterScroll;
end;

procedure THalcyonDataset.FindNearest(const KeyValues: array of const);
var
   s: gsUTFString;
begin
   CheckActive;
   CheckBrowseMode;
   if DBFHandle.IndexMaster = nil then
      DataBaseError(gsErrIndexFind);
   if (FDBFHandle.NumRecs = 0) or (RecNo=0) or (ActiveBuffer = nil) then exit;
   DoBeforeScroll;
   CursorPosChanged;
   s := DBFHandle.gsBuildKey(KeyValues,FDBFHandle.IndexMaster.ExprHandlr);
   FindThisRecord(s,false,true);
   Resync([rmExact, rmCenter]);
   DoAfterScroll;
end;

Function THalcyonDataset.FindThisRecord(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
var
   ps: array[0..255] of char;
begin
   FDBFHandle.gsvExactMatch := IsExact;
   FDBFHandle.gsvFindNear := IsNear;
   StrPCopy(ps,ss);
   Translate(ps,ps,true);
   Result := FDBFHandle.gsFind(StrPas(ps));
end;

procedure THalcyonDataset.SetKey;
begin
  CheckBrowseMode;
  if FKeyBuffer <> nil then FreeMem(FKeyBuffer,FRecBufSize);
  FKeyBuffer := AllocMem(FRecBufSize);
  DBFHandle.CurRecord := Pointer(FKeyBuffer);
  DBFHandle.gsBlank;
  DBFHandle.CurRecord := DBFHandle.CurRecHold;
  SetState(dsSetKey);
end;

procedure THalcyonDataset.EditKey;
begin
   if FKeyBuffer = nil then
      SetKey
   else
   begin
      CheckBrowseMode;
      SetState(dsSetKey);
   end;
end;

function THalcyonDataset.GotoKey: Boolean;
var
   s: gsUTFString;
   rnum: longint;
   expvar: TgsVariant;
begin
   CheckActive;
   CheckBrowseMode;
   if DBFHandle.IndexMaster = nil then
      DataBaseError(gsErrIndexFind);
   Result := false;
   if FKeyBuffer = nil then
      DataBaseError(gsErrIndexKey);
   if (FDBFHandle.NumRecs = 0) or (RecNo=0) or (ActiveBuffer = nil) then exit;
   rnum := GetRecNo;
   DoBeforeScroll;
   CursorPosChanged;
   DBFHandle.CurRecord := Pointer(FKeyBuffer);
   expvar := TgsVariant.Create(256);
   try
      FDBFHandle.IndexMaster.ExprHandlr.ExpressionAsVariant(expvar);
      s := expvar.GetString;
   finally
      expvar.Free;
   end;
   DBFHandle.CurRecord := DBFHandle.CurRecHold;
   if FindThisRecord(s,false,false) then
   begin
      Result := true;
      Resync([rmExact, rmCenter]);
      DoAfterScroll;
   end
   else
      FDBFHandle.gsGetRec(rnum);
   DoAfterScroll;
end;

procedure THalcyonDataset.GoToNearest;
var
   s: gsUTFString;
   expvar: TgsVariant;
begin
   CheckActive;
   CheckBrowseMode;
   if DBFHandle.IndexMaster = nil then
      DataBaseError(gsErrIndexFind);
   if FKeyBuffer = nil then
      DataBaseError(gsErrIndexKey);
   if (FDBFHandle.NumRecs = 0) or (RecNo=0) or (ActiveBuffer = nil) then exit;
   DoBeforeScroll;
   CursorPosChanged;
   DBFHandle.CurRecord := Pointer(FKeyBuffer);
   expvar := TgsVariant.Create(256);
   try
      FDBFHandle.IndexMaster.ExprHandlr.ExpressionAsVariant(expvar);
      s := expvar.GetString;
   finally
      expvar.Free;
   end;
   DBFHandle.CurRecord := DBFHandle.CurRecHold;
   FindThisRecord(s,false,true);
   Resync([rmExact, rmCenter]);
   DoAfterScroll;
end;

function THalcyonDataSet.GetIsIndexField(Field: TField): Boolean;
var
   il: gsUTFString;
   Psn: integer;
   cf: gsUTFString;
   fn: gsUTFString;
begin
   Result := False;
   if FDBFHandle.IndexMaster = nil then exit;
   fn := gsStrUpperCase(Field.FieldName);
   il := FDBFHandle.IndexMaster.ExprHandlr.EnumerateType(gsSQLTypeVarDBF);
   if length(il) > 0 then
   begin
      Psn := 1;
      while (not Result) and (Psn < length(il)) do
      begin
         cf := gsStrUpperCase(gsExtractFieldName(il,Psn));
         Result := cf = fn;
      end;
   end;
end;

procedure THalcyonDataSet.Post;
begin
   inherited Post;
   if State = dsSetKey then
      SetState(dsBrowse);
end;

function THalcyonDataset.BookmarkValid(Bookmark: TBookmark): Boolean;
var
   RN: integer;
begin
   CheckActive;
   try
      RN := StrToInt(PChar(BookMark));
      Result := (RN > 0) and (RN <= FDBFHandle.NumRecs);
   except
      Result := false;
   end;
end;

procedure THalcyonDataset.AddAlias(const AliasValue, PathValue: gsUTFString);
var
   s1: gsUTFString;
   s2: gsUTFString;
begin
   s1 := Trim(gsStrUpperCase(AliasValue));
   s2 := Trim(PathValue);
   if AliasList.IndexOfName(s1) = -1 then
      AliasList.Add(s1+'='+s2)
   else
     DatabaseErrorFmt(gsErrAliasAssigned, [s1]);
end;


procedure LoadConfiguration;
var
   cfgFile: TIniFile;
   FileString: gsUTFString;
begin
   FileString := gsSysRootDirectory;
   if length(FileString) > 0 then
      if FileString[length(FileString)] <> GSFileSep then
         FileString := FileString + GSFileSep;
   FileString := FileString + 'halcyon.cfg';
   cfgFile := TIniFile.Create(FileString);
   cfgFile.ReadSectionValues('Alias',AliasList);
   cfgFile.Free;
end;


Initialization
   AliasList := TStringList.Create;
   AliasList.Add(HalcyonDefaultDirectory);
   LoadConfiguration;

Finalization
begin
   AliasList.Free;
end;



end.

