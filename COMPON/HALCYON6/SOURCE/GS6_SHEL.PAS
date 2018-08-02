unit gs6_shel;
{-----------------------------------------------------------------------------
                            dBase File Interface

       gs6_shel Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Aug 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit provides access to Griffin Solutions dBase Objects
       using high-level procedures and functions that make Object
       Oriented Programming transparent to the user.  It provides a
       selection of commands similar to the dBase format.

   Changes:


------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   Classes,
   gs6_dbsy,
   gs6_tool,
   gs6_sort,
   gs6_date,
   gs6_disk,
   gs6_dbf,
   gs6_sql,
   gs6_indx,
   gs6_cnst,
   gs6_glbl;

type
   gsSortStatus = (Ascending, Descending, SortUp, SortDown,
                   SortDictUp, SortDictDown, NoSort,
                   AscendingGeneral, DescendingGeneral);

   gsIndexUnique = (Unique, Duplicates);

   gsLokProtocol = (Default, DB4Lock, ClipLock, FoxLock);

   gsDBFTypes = (Clipper,DBaseIII,DBaseIV,FoxPro2);

   gsDBFState = (dssInactive, dssRecLoad, dssBrowse, dssEdit, dssAppend, dssIndex);

   gsDBFFilterOption = (foCaseInsensitive, foNoPartialCompare);
   gsDBFFilterOptions = set of gsDBFFilterOption;

   FilterCheck   = Function: boolean;
   StatusProc    = CaptureStatus;

   DBFObject = class(GSO_dBHandler)
      DBFFilter   : FilterCheck;
      DBFStatus   : StatusProc;
      constructor Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
      Procedure   gsStatusUpdate(stat1,stat2,stat3 : longint); override;
      Function    gsTestFilter : boolean; override;
   end;

   TgsDBFTable = class(TObject)
   private
      DBFState      : gsDBFState;
      DBFName       : gsUTFString;
      DBFReadWrite  : boolean;
      DBFShared     : boolean;
      DBFUseDeleted : boolean;
      DBFAutoFlush  : boolean;
      DBFFilter     : FilterCheck;
      DBFStatus     : StatusProc;
      FDBFHandle    : DBFObject;
      FExactCount   : boolean;
      FFilterText   : gsUTFString;
      FFilterOptions: gsDBFFilterOptions;
      FFiltered     : Boolean;
   protected
      procedure CheckActive;
      procedure ConfirmBrowse;
      procedure ConfirmEdit;
      function  GetActiveState: boolean;
      procedure SetActiveState(Value: boolean);
      function  GetRecno: longint;
      procedure SetRecNo(Value: longint);
      procedure SetState(Value: gsDBFState);
      procedure SetFiltered(Value: Boolean); virtual;
      procedure SetFilterOptions(Value: gsDBFFilterOptions); virtual;
      procedure SetFilterText(const Value: gsUTFString); virtual;
      procedure SetFilterData(const Text: gsUTFString; Options: gsDBFFilterOptions);
   public
      constructor Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
      destructor  Destroy; override;
      Procedure   Append;
      procedure   AssignUserID(id: longint);
      procedure   Cancel;
      Procedure   ClearRecord;
      Procedure   CopyStructure(const filname, apassword: gsUTFString);
      Procedure   CopyTo(const filname, apassword: gsUTFString);
      Function    BOF : boolean;
      Function    Deleted : boolean;
      Procedure   Delete;
      Procedure   Edit;
      Function    EOF : boolean;
      Function    ExternalChange: integer;
      Function    Field(n : integer) : gsUTFString;
      Function    FieldCount : integer;
      Function    FieldDec(n : integer) : integer;
      Function    FieldLen(n : integer) : integer;
      Function    FieldNo(const fn : gsUTFString) : integer;
      Function    FieldType(n : integer) : char;
      Function    Find(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
      Function    FLock : boolean;
      Procedure   FlushDBF;
      Procedure   Go(n : longint);
      Procedure   Last;
      Procedure   First;
      procedure   Next;
      procedure   Post;
      procedure   Prior;
      Procedure   MoveBy(n : longint);
      procedure   Refresh;
      Function   HuntDuplicate(const st, ky: gsUTFString) : longint;
      Function   Index(const INames,Tag : gsUTFString): integer;
      Function   IndexCount: integer;
      Function   IndexCurrent: gsUTFString;
      Function   IndexCurrentOrder: integer;
      Function   IndexExpression(Value: integer): gsUTFString;
      Function   IndexKeyLength(Value: integer): integer;
      Function   IndexKeyType(Value: integer): char;
      Function   IndexFilter(Value: integer): gsUTFString;
      Function   IndexUnique(Value: integer): boolean;
      Function   IndexAscending(Value: integer): boolean;
      Function   IndexFileName(Value: integer): gsUTFString;
      Procedure  IndexIsProduction(tf: boolean);
      function   IndexKeyValue(Value: integer): gsUTFString;
      Function   IndexMaintained: boolean;
      Procedure  IndexFileInclude(const IName: gsUTFString);
      Procedure  IndexFileRemove(const IName: gsUTFString);
      Procedure  IndexTagRemove(const IName, Tag: gsUTFString);
      Procedure  IndexOn(const IName, tag, keyexp, forexp: gsUTFString;
                      uniq: gsIndexUnique; ascnd: gsSortStatus);
      Function   IndexTagName(Value: integer): gsUTFString;
      Function   LUpdate: gsUTFString;
      Function   MemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
                 uniq: gsIndexUnique; ascnd: gsSortStatus): boolean;
      Procedure  Pack;
      function    QueryHandler: TgsExpUserLink;
      Procedure  Recall;
      Function   RecordCount : longint;
      Function   RecSize : word;
      Procedure  Reindex;
      procedure  RenameTable(const NewTableName: gsUTFString);
      Function   RLock : boolean;
      procedure  ReturnDateTimeUser(var dt, tm, us: longint);
      Function   SearchDBF(const s: gsUTFString; var FNum : word;
                        var fromrec: longint; torec: longint): word;
      procedure  SetAutoFlush(tf: boolean);
      Procedure  SetDBFCache(tf: boolean);
      Procedure  SetDBFCacheAllowed(tf: boolean);
      Procedure  SetFilterThru(UserRoutine : FilterCheck);
      Procedure  SetLockProtocol(LokProtocol: gsLokProtocol);
      Procedure  SetOrderTo(order : integer);
      Procedure  SetRange(const RLo, RHi: gsUTFString);
      Procedure  SetRangeEx(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean);
      Procedure  SetStatusCapture(UserRoutine : StatusProc);
      Procedure  SetTagTo(const TName: gsUTFString);
      Procedure  SetUseDeleted(tf: boolean);
      Procedure  SortTo(const filname, apassword, formla: gsUTFString; sortseq: gsSortStatus);
      Procedure  Unlock;
      Procedure  Zap;

     {dBase field handling routines}

      Function   MemoSize(const fnam: gsUTFString): longint;
      Function   MemoSizeN(fnum: integer): longint;
      Procedure  MemoLoad(const fnam: gsUTFString;buf: PChar; var cb: longint);
      Function   MemoSave(const fnam: gsUTFString;buf: PChar; var cb: longint): longint;
      Procedure  MemoLoadN(fnum: integer;buf: PChar; var cb: longint);
      Function   MemoSaveN(fnum: integer;buf: PChar; var cb: longint): longint;
      Function   DateGet(const st : gsUTFString) : longint;
      Function   DateGetN(n : integer) : longint;
      Procedure  DatePut(const st : gsUTFString; jdte : longint);
      Procedure  DatePutN(n : integer; jdte : longint);
      Function   FieldGet(const fnam : gsUTFString) : gsUTFString;
      Function   FieldGetN(fnum : integer) : gsUTFString;
      Procedure  FieldPut(const fnam, st : gsUTFString);
      Procedure  FieldPutN(fnum : integer; st : gsUTFString);
      Function   FloatGet(const st : gsUTFString) : FloatNum;
      Function   FloatGetN(n : integer) : FloatNum;
      Procedure  FloatPut(const st : gsUTFString; r : FloatNum);
      Procedure  FloatPutN(n : integer; r : FloatNum);
      Function   LogicGet(const st : gsUTFString) : boolean;
      Function   LogicGetN(n : integer) : boolean;
      Procedure  LogicPut(const st : gsUTFString; b : boolean);
      Procedure  LogicPutN(n : integer; b : boolean);
      Function   IntegerGet(const st : gsUTFString) : Int64;
      Function   IntegerGetN(n : integer) : Int64;
      Procedure  IntegerPut(const st : gsUTFString; i : Int64);
      Procedure  IntegerPutN(n : integer; i : Int64);
      Function   StringGet(const fnam : gsUTFString) : gsUTFString;
      Function   StringGetN(fnum : integer) : gsUTFString;
      Procedure  StringPut(const fnam, st : gsUTFString);
      Procedure  StringPutN(fnum : integer; st : gsUTFString);
      function   GetFileVersion: byte;
      procedure  EncryptFile(const APassword: gsUTFString);
       {Added because EncryptFile is reserved in CBuilder}
      procedure  EncryptDBFFile(const APassword: gsUTFString);

      property Active: boolean read GetActiveState write SetActiveState;
      property DBFHandle: DBFObject read FDBFHandle;
      property RecNo: longint read GetRecNo write SetRecNo;
      property FileVersion: byte read GetFileVersion;
      property ExactCount: boolean read FExactCount write FExactCount default false;
      property State: gsDBFState read  DBFState write DBFState;
      property Filter: gsUTFString read FFilterText write SetFilterText;
      property Filtered: Boolean read FFiltered write SetFiltered default False;
      property FilterOptions: gsDBFFilterOptions read FFilterOptions write SetFilterOptions default [];
   end;


     {dBase type functions}
function CreateDBF(const fname, apassword: gsUTFString; ftype: gsDBFTypes; FieldList: TStringList): boolean;

     {Default capture procedures}
Function  DefFilterCk: boolean;
Procedure DefCapStatus(stat1,stat2,stat3 : longint);

implementation

{-----------------------------------------------------------------------------
                            Data Capture Procedures
------------------------------------------------------------------------------}

{$F+}
Function DefFilterCk: boolean;
begin
   DefFilterCk := true;
end;

Procedure DefCapStatus(stat1,stat2,stat3 : longint);
begin
end;
{$F-}

{-----------------------------------------------------------------------------
                              Global procedures/functions
------------------------------------------------------------------------------}

function CreateDBF(const fname, apassword: gsUTFString; ftype: gsDBFTypes; FieldList: TStringList): boolean;
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
   FCopy  : GSO_dBHandler;

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
   if FieldList.Count = 0 then
   begin
      raise EHalcyonError.Create(gsErrInvalidFieldList);
      exit;
   end;
   fil := fname;
   sl := TStringList.Create;
   for i := 0 to pred(FieldList.Count) do
   begin
      v := true;
      s := Fieldlist.Strings[i];
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
         raise EHalcyonError.Create(gsErrInvalidFieldList);
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
   for i := 0 to pred(FieldList.Count) do
   begin
      s := Fieldlist.Strings[i];
      While (length(s) > 0) and (s[length(s)] in [' ',';']) do
         system.Delete(s,length(s),1);
      if s <> '' then
         LoadField;
      f.InsertField(fs,ft[1],fl,fd);
   end;
   f.Complete;
   Result :=  (f.dFile <> nil);
   f.Free;
   if apassword <> '' then
   begin
      FCopy := GSO_dBHandler.Create(fname, '',true,false);
      FCopy.gsSetPassword(apassword);
      FCopy.Free;
   end;
end;

{-----------------------------------------------------------------------------
                              DBFObject Class
------------------------------------------------------------------------------}


constructor DBFObject.Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
begin
   inherited Create(FName,APassword,ReadWrite,Shared);
   DBFFilter := DefFilterCk;
   DBFStatus := DefCapStatus;
end;

Procedure DBFObject.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
   DBFStatus(stat1,stat2,stat3);
end;

Function DBFObject.gsTestFilter : boolean;
begin
   if dState = dbIndex then
      gsTestFilter := true
   else
   begin
      if DBFFilter then
         gsTestFilter := inherited gsTestFilter
      else
         gsTestFilter := false;
   end;
end;

{-----------------------------------------------------------------------------
                                TgsDBFTable Class
------------------------------------------------------------------------------}

constructor TgsDBFTable.Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
begin
   inherited Create;
   FDBFHandle := nil;
   DBFName := FName;
   DBFReadWrite := ReadWrite;
   DBFShared := Shared;
   DBFUseDeleted := false;
   DBFAutoFlush := false;
   DBFFilter := DefFilterCk;
   DBFStatus := DefCapStatus;
   FDBFHandle := DBFObject.Create(DBFName, APassword, DBFReadWrite, DBFShared);
   FDBFHandle.UseDeletedRec := DBFUseDeleted;
   FDBFHandle.gsvAutoFlush := DBFAutoFlush;
   FDBFHandle.DBFFilter := DBFFilter;
   FDBFHandle.DBFStatus := DBFStatus;
   DBFState := dssBrowse;
   First;
end;

destructor TgsDBFTable.Destroy;
begin
   if FDBFHandle <> nil then FDBFHandle.Free;
end;

procedure TgsDBFTable.CheckActive;
begin
   if not Assigned(FDBFHandle) then
   begin
      raise EHalcyonError.Create(gsErrTableIsNil);
   end;
end;

procedure TgsDBFTable.ConfirmEdit;
begin
   if not (DBFState in [dssEdit, dssAppend]) then
   begin
      raise EHalcyonError.Create(gsErrNotEditing);
   end;
end;

procedure TgsDBFTable.ConfirmBrowse;
begin
   if not (DBFState in [dssBrowse]) then
   begin
      raise EHalcyonError.Create(gsErrNotBrowsing);
   end;
end;

Function TgsDBFTable.GetActiveState: boolean;
begin
   Result := FDBFHandle <> nil;
end;

procedure TgsDBFTable.SetActiveState(Value: boolean);
begin
   if Value then
      CheckActive
   else
   begin
      if FDBFHandle <> nil then
      begin
         FDBFHandle.Free;
         FDBFHandle := nil;
         DBFState := dssInactive;
      end;
   end;
end;

Function TgsDBFTable.GetRecNo : longint;
begin
   CheckActive;
   Result := FDBFHandle.RecNumber;
end;

procedure TgsDBFTable.SetRecNo(Value: longint);
begin
   Go(Value);
end;

procedure TgsDBFTable.SetState(Value: gsDBFState);
begin
   if Value = DBFState then exit;
   DBFState := Value;
end;



Procedure TgsDBFTable.AssignUserID(id: longint);
begin
   CheckActive;
   FDBFHandle.gsAssignUserID(id);
end;

procedure TgsDBFTable.Cancel;
begin
   CheckActive;
   SetState(dssBrowse);
   Go(Same_Record);
   Unlock;
end;

Procedure TgsDBFTable.ClearRecord;
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsBlank;
end;

Procedure TgsDBFTable.CopyStructure(const filname, apassword: gsUTFString);
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

Procedure TgsDBFTable.CopyTo(const filname, apassword: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsCopyFile(filname, apassword);
end;

Function TgsDBFTable.BOF : boolean;
begin
   CheckActive;
   BOF := FDBFHandle.File_TOF
end;

Function TgsDBFTable.Deleted : boolean;
begin
   CheckActive;
   Deleted := FDBFHandle.gsDelFlag;
end;

Procedure TgsDBFTable.Delete;
begin
   CheckActive;
   FDBFHandle.gsDeleteRec;
end;

procedure TgsDBFTable.Append;
begin
   Post;
   if DBFState in [dssEdit,dssAppend] then exit;
   if not DBFReadWrite then
      raise EHalcyonError.Create(gsErrDataSetReadOnly);
   SetState(dssAppend);
   ClearRecord;
   FDBFHandle.RecModified := False;
end;


Procedure TgsDBFTable.Edit;
begin
   Post;
   if DBFState in [dssRecLoad, dssEdit,dssAppend] then exit;
   if not DBFReadWrite then
      raise EHalcyonError.Create(gsErrDataSetReadOnly);
   if RecordCount = 0 then
      Append
   else
   begin
      Go(Same_Record);
      if not RLock then
         raise EHalcyonError.Create(gsErrRecordLockAlready);
      SetState(dssEdit);
   end;
end;

procedure TgsDBFTable.Post;
begin
   CheckActive;
   case DBFState of
      dssEdit   : begin
                     FDBFHandle.gsPutRec(FDBFHandle.RecNumber);
                     SetState(dssBrowse);
                     UnLock;
                  end;
      dssAppend : begin
                     FDBFHandle.gsAppend;
                     SetState(dssBrowse);
                  end;
   end;
end;

Function TgsDBFTable.EOF : boolean;
begin
   CheckActive;
   EOF := FDBFHandle.File_EOF;
end;

Function TgsDBFTable.ExternalChange: integer;
begin
   CheckActive;
   ExternalChange := FDBFHandle.gsExternalChange;
end;

Function TgsDBFTable.Field(n : integer) : gsUTFString;
begin
   CheckActive;
   Field := FDBFHandle.gsFieldName(n);
end;

Function TgsDBFTable.FieldCount : integer;
begin
   CheckActive;
   FieldCount := FDBFHandle.NumFields;
end;

Function TgsDBFTable.FieldDec(n : integer) : integer;
begin
   CheckActive;
   FieldDec := FDBFHandle.gsFieldDecimals(n);
end;

Function TgsDBFTable.FieldLen(n : integer) : integer;
begin
   CheckActive;
   FieldLen := FDBFHandle.gsFieldLength(n);
end;

Function TgsDBFTable.FieldNo(const fn : gsUTFString) : integer;
var
   mtch : boolean;
   i,
   ix   : integer;
   za   : gsUTFString;
begin
   CheckActive;
   ix := FDBFHandle.NumFields;
   i := 1;
   mtch := false;
   while (i <= ix) and not mtch do
   begin
      za := StrPas(FDBFHandle.Fields^[i].dbFieldName);
      if gsStrCompareI(za,fn) = 0 then
         mtch := true
      else
         inc(i);
   end;
   if mtch then
      FieldNo := i
   else
      FieldNo := 0;
end;

Function TgsDBFTable.FieldType(n : integer) : char;
begin
   CheckActive;
   FieldType := FDBFHandle.gsFieldType(n);
end;

function TgsDBFTable.Find(const ss : gsUTFString; IsExact, IsNear: boolean): boolean;
begin
   CheckActive;
   FDBFHandle.gsvFindNear := IsNear;
   FDBFHandle.gsvExactMatch := IsExact;
   Result := FDBFHandle.gsFind(ss);
end;

Function TgsDBFTable.FLock : boolean;
begin
   CheckActive;
   FLock := FDBFHandle.gsFLock;
end;

Procedure TgsDBFTable.FlushDBF;
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.dStatus := Updated;
   FDBFHandle.gsFlush;
end;

Procedure TgsDBFTable.Go(n : longint);
var
   feof: boolean;
   fbof: boolean;
begin
   feof := false;
   fbof := false;
   Post;
   begin
      if n = Same_Record then              {!!RFG 081897}
      begin                                {!!RFG 081897}
         feof := FDBFHandle.File_EOF;      {!!RFG 081897}
         fbof := FDBFHandle.File_TOF;      {!!RFG 081897}
      end;                                 {!!RFG 081897}
      FDBFHandle.gsGetRec(n);
      if n = Same_Record then              {!!RFG 081897}
      begin                                {!!RFG 081897}
         FDBFHandle.File_EOF := feof;      {!!RFG 081897}
         FDBFHandle.File_TOF := fbof;      {!!RFG 081897}
      end;
   end;
end;

Procedure TgsDBFTable.Last;
begin
   Post;
   FDBFHandle.gsGetRec(Bttm_Record);
end;

Procedure TgsDBFTable.First;
begin
   Post;
   FDBFHandle.gsGetRec(Top_Record);
end;

Function TgsDBFTable.HuntDuplicate(const st, ky: gsUTFString): longint;
begin
   CheckActive;
   HuntDuplicate := FDBFHandle.gsHuntDuplicate(st, ky);
end;

Function TgsDBFTable.Index(const INames, Tag : gsUTFString): integer;
begin
   CheckActive;
   Index := FDBFHandle.gsIndex(INames,Tag);
end;

Procedure TgsDBFTable.IndexFileInclude(const IName: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsIndexRoute(IName);
end;

Procedure TgsDBFTable.IndexFileRemove(const IName: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsIndexFileRemove(IName);
end;

Procedure TgsDBFTable.IndexTagRemove(const IName, Tag: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsIndexTagRemove(IName, Tag);
end;

Procedure TgsDBFTable.IndexOn(const IName, tag, keyexp, forexp: gsUTFString;
                  uniq: gsIndexUnique; ascnd: gsSortStatus);
begin
   CheckActive;
   FDBFHandle.gsIndexTo(IName, tag, keyexp, forexp,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
end;

function TgsDBFTable.IndexExpression(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   CheckActive;
    p := FDBFHandle.gsIndexPointer(Value);
    if p <> nil then
       IndexExpression := p.KeyExpr
    else
       IndexExpression := '';
end;

function TgsDBFTable.IndexKeyLength(Value: integer): integer;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexKeyLength := p.KeyLength
   else
      IndexKeyLength := 0;
end;

function TgsDBFTable.IndexKeyType(Value: integer): char;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexKeyType := p.KeyType
   else
      IndexKeyType := 'C';
end;

function TgsDBFTable.IndexFilter(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if (p <> nil) and (length(p.ForExpr) > 0) then
      IndexFilter := p.ForExpr
   else
      IndexFilter := '';
end;

function TgsDBFTable.IndexUnique(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexUnique := p.KeyIsUnique
   else
      IndexUnique := false;
end;

function TgsDBFTable.IndexAscending(Value: integer): boolean;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexAscending := p.KeyIsAscending
   else
      IndexAscending := false;
end;

function TgsDBFTable.IndexFileName(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexFileName := p.Owner.IndexName
   else
      IndexFileName := '';
end;

function TgsDBFTable.IndexTagName(Value: integer): gsUTFString;
var
   p: GSobjIndexTag;
begin
   CheckActive;
   p := FDBFHandle.gsIndexPointer(Value);
   if p <> nil then
      IndexTagName := p.TagName
   else
      IndexTagName := '';
end;

function TgsDBFTable.IndexCount: integer;
var
   i: integer;
   n: integer;
begin
   CheckActive;
   n := 0;
   i := 1;
   while (i <= IndexesAvail) do
   begin
      if FDBFHandle.IndexStack[i] <> nil then
         n := n + FDBFHandle.IndexStack[i].TagCount;
      inc(i);
   end;
   IndexCount := n;
end;

function TgsDBFTable.IndexCurrent: gsUTFString;
begin
   CheckActive;
   if FDBFHandle.IndexMaster <> nil then
      IndexCurrent := FDBFHandle.IndexMaster.TagName
   else
      IndexCurrent := '';
end;

function TgsDBFTable.IndexCurrentOrder: integer;
var
   p: GSobjIndexTag;
   i: integer;
   n: integer;
   ni: integer;
begin
   CheckActive;
   IndexCurrentOrder := 0;
   with FDBFHandle do
   begin
      if IndexMaster <> nil then
      begin
         p := nil;
         n := 0;
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
         if p <> nil then
            IndexCurrentOrder := n;
      end;
   end;
end;

procedure TgsDBFTable.IndexIsProduction(tf: boolean);
begin
   CheckActive;
   if tf then
      FDBFHandle.IndexFlag := $01
   else
      FDBFHandle.IndexFlag := $00;
   FDBFHandle.WithIndex := tf;
   FDBFHandle.dStatus := Updated;
   FDBFHandle.gsHdrWrite;
end;

function TgsDBFTable.IndexKeyValue(Value: integer): gsUTFString;
var
   expvar: TgsVariant;
begin
   Result := '';
   CheckActive;
   expvar := TgsVariant.Create(256);
   if FDBFHandle.gsIndexKeyValue(Value,expvar) then
      Result := expvar.GetString;
   expvar.Free;
end;


Function TgsDBFTable.IndexMaintained: boolean;
begin
   CheckActive;
   IndexMaintained := FDBFHandle.IndexFlag > 0;
end;

Function TgsDBFTable.LUpdate: gsUTFString;
var
   fd: longint;
   td: TDateTime;
begin
   if FDBFHandle = nil then
      LUpdate := ''
   else
   begin
      fd := FileGetDate(FDBFHandle.FileHandle);
      td := FileDateToDateTime(fd);
      LUpdate := DateToStr(td);
   end;
end;

Function TgsDBFTable.MemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
            uniq: gsIndexUnique; ascnd: gsSortStatus): boolean;
begin
   CheckActive;
   MemoryIndexAdd := FDBFHandle.gsMemoryIndexAdd(Tag, keyexpr, forexpr,
                      GSsetIndexUnique(uniq), GSsetSortStatus(ascnd));
end;


Procedure TgsDBFTable.Pack;
begin
   Post;
   FDBFHandle.gsPack;
end;

function TgsDBFTable.QueryHandler: TgsExpUserLink;
begin
   CheckActive;
   Result := FDBFHandle.DBFExpLink;
end;


Procedure TgsDBFTable.Recall;
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.gsUndelete;
end;

Function TgsDBFTable.RecordCount : longint;
var
   rn: integer;
begin
  CheckActive;
  if FExactCount then
  begin
     Result := 0;
     rn := GetRecNo;
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
end;

Function TgsDBFTable.RecSize : word;
begin
   CheckActive;
   RecSize := FDBFHandle.RecLen;
end;

Procedure TgsDBFTable.Reindex;
begin
   CheckActive;
   FDBFHandle.gsReindex;
end;

Function TgsDBFTable.RLock : boolean;
begin
   CheckActive;
   RLock := FDBFHandle.gsRLock;
end;

procedure TgsDBFTable.ReturnDateTimeUser(var dt, tm, us: longint);
begin
   dt := 0;
   tm := 0;
   us := 0;
   CheckActive;
   FDBFHandle.gsReturnDateTimeUser(dt, tm, us);
end;

Function TgsDBFTable.SearchDBF(const s: gsUTFString; var FNum : word;
                   var fromrec: longint; torec: longint): word;
begin
   CheckActive;
   SearchDBF := FDBFHandle.gsSearchDBF(s,FNum,fromrec,torec);
end;

Procedure TgsDBFTable.SetDBFCacheAllowed(tf: boolean);
begin
   if FDBFHandle = nil then exit;
   FDBFHandle.gsSetDBFCacheAllowed(tf);
end;

Procedure TgsDBFTable.SetDBFCache(tf: boolean);
begin
   if FDBFHandle = nil then exit;
   if tf and (FDBFHandle.IndexMaster <> nil) then exit;
   FDBFHandle.gsSetDBFCache(tf);
end;

Procedure TgsDBFTable.SetFilterThru(UserRoutine : FilterCheck);
begin
   if not (FDBFHandle = nil) then exit;
   FDBFHandle.DBFFilter := UserRoutine;
end;

Procedure TgsDBFTable.SetLockProtocol(LokProtocol: gsLokProtocol);
begin
   if FDBFHandle <> nil then
      FDBFHandle.gsSetLockProtocol(GSsetLokProtocol(LokProtocol));
end;

Procedure TgsDBFTable.SetOrderTo(order : integer);
begin
   CheckActive;
   FDBFHandle.gsIndexOrder(order);
end;

Procedure TgsDBFTable.SetRange(const RLo, RHi: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsSetRange(RLo,RHi,true,true,false);
end;

Procedure TgsDBFTable.SetRangeEx(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean);
begin
   CheckActive;
   FDBFHandle.gsSetRange(RLo,RHi,LoIn,HiIn,Partial);
end;

Procedure TgsDBFTable.SetStatusCapture(UserRoutine : CaptureStatus);
begin
   CheckActive;
   FDBFHandle.DBFStatus := UserRoutine;
end;

Procedure TgsDBFTable.SetTagTo(const TName: gsUTFString);
begin
   CheckActive;
   FDBFHandle.gsSetTagTo(TName,true);
end;

Procedure TgsDBFTable.SetUseDeleted(tf: boolean);
begin
   DBFUseDeleted := tf;
   if FDBFHandle <> nil then
      FDBFHandle.UseDeletedRec := tf;
end;

Procedure TgsDBFTable.SetAutoFlush(tf: boolean);
begin
   DBFAutoFlush := tf;
   if FDBFHandle <> nil then
      FDBFHandle.gsvAutoFlush := tf;
end;

Procedure TgsDBFTable.MoveBy(n : longint);
begin
   Post;
   FDBFHandle.gsSkip(n);
end;

Procedure TgsDBFTable.Next;
begin
   Post;
   FDBFHandle.gsGetRec(Next_Record);
end;

Procedure TgsDBFTable.Prior;
begin
   Post;
   FDBFHandle.gsGetRec(Prev_Record);
end;

Procedure TgsDBFTable.Refresh;
begin
   Cancel;
   FDBFHandle.gsGetRec(Same_Record);
end;

Procedure TgsDBFTable.SortTo(const filname, apassword, formla: gsUTFString; sortseq : gsSortStatus);
begin
   CheckActive;
   FDBFHandle.gsSortFile(filname, apassword, formla, GSsetSortStatus(sortseq));
end;

Procedure TgsDBFTable.Unlock;
begin
   CheckActive;
   FDBFHandle.gsLockOff;
end;

Procedure TgsDBFTable.Zap;
begin
   CheckActive;
   FDBFHandle.gsZap;
end;


procedure TgsDBFTable.SetFilterData(const Text: gsUTFString; Options: gsDBFFilterOptions);
begin
   if Active and Filtered then
   begin
      ConfirmBrowse;
      DBFHandle.gsSetFilterActive(true);
      DBFHandle.gsSetFilterExpr(Text, foCaseInsensitive in Options, not (foNoPartialCompare in Options));
      First;
   end;
end;

procedure TgsDBFTable.SetFilterText(const Value: gsUTFString);
begin
  FFilterText := Value;
  SetFilterData(Value, FilterOptions);
end;

procedure TgsDBFTable.SetFilterOptions(Value: gsDBFFilterOptions);
begin
  FFilterOptions := Value;
  SetFilterData(Filter, Value);
end;

procedure TgsDBFTable.SetFiltered(Value: Boolean);
begin
   if Active then
   begin
      ConfirmBrowse;
      if Filtered <> Value then
      begin
         FFiltered := Value;
         DBFHandle.gsSetFilterActive(Value);
         if Value then
            SetFilterData(Filter,FilterOptions);
      end;
      First;
   end
   else
     FFiltered := Value;
end;



{------------------------------------------------------------------------------
                           Field Access Routines
------------------------------------------------------------------------------}

Function TgsDBFTable.MemoSize(const fnam: gsUTFString): longint;
begin
   CheckActive;
   MemoSize := FDBFHandle.gsMemoSize(fnam);
end;

Function TgsDBFTable.MemoSizeN(fnum: integer): longint;
begin
   CheckActive;
   MemoSizeN := FDBFHandle.gsMemoSizeN(fnum);
end;

Function TgsDBFTable.MemoSave(const fnam: gsUTFString;buf: PChar; var cb: longint): longint;
begin
   CheckActive;
   ConfirmEdit;
   MemoSave := FDBFHandle.gsMemoSave(fnam,buf,cb);
end;

Procedure TgsDBFTable.MemoLoad(const fnam: gsUTFString;buf: PChar; var cb: longint);
begin
   CheckActive;
   FDBFHandle.gsMemoLoad(fnam,buf,cb);
end;

Procedure  TgsDBFTable.MemoLoadN(fnum: integer;buf: PChar; var cb: longint);
begin
   CheckActive;
   FDBFHandle.gsMemoLoadN(fnum,buf,cb);
end;

Function   TgsDBFTable.MemoSaveN(fnum: integer;buf: PChar; var cb: longint): longint;
begin
   CheckActive;
   ConfirmEdit;
   MemoSaveN := FDBFHandle.gsMemoSaveN(fnum,buf,cb);
end;


Function TgsDBFTable.DateGet(const st : gsUTFString) : longint;
begin
   CheckActive;
   DateGet := FDBFHandle.gsDateGet(st);
end;

Function TgsDBFTable.DateGetN(n : integer) : longint;
begin
   CheckActive;
   DateGetN := FDBFHandle.gsDateGetN(n);
end;

Procedure TgsDBFTable.DatePut(const st : gsUTFString; jdte : longint);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsDatePut(st, jdte);
end;

Procedure TgsDBFTable.DatePutN(n : integer; jdte : longint);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsDatePutN(n, jdte);
end;

Function TgsDBFTable.FieldGet(const fnam : gsUTFString) : gsUTFString;
begin
   CheckActive;
   FieldGet := FDBFHandle.gsFieldGet(fnam);
end;

Function TgsDBFTable.FieldGetN(fnum : integer) : gsUTFString;
begin
   CheckActive;
   FieldGetN := FDBFHandle.gsFieldGetN(fnum);
end;

Procedure TgsDBFTable.FieldPut(const fnam, st : gsUTFString);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsFieldPut(fnam, st);
end;

Procedure TgsDBFTable.FieldPutN(fnum : integer; st : gsUTFString);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsFieldPutN(fnum, st);
end;

Function TgsDBFTable.FloatGet(const st : gsUTFString) : FloatNum;
begin
   CheckActive;
   FloatGet := FDBFHandle.gsNumberGet(st);
end;

Function TgsDBFTable.FloatGetN(n : integer) : FloatNum;
begin
   CheckActive;
   FloatGetN := FDBFHandle.gsNumberGetN(n);
end;

Procedure TgsDBFTable.FloatPut(const st : gsUTFString; r : FloatNum);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsNumberPut(st, r);
end;

Procedure TgsDBFTable.FloatPutN(n : integer; r : FloatNum);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsNumberPutN(n, r);
end;

Function TgsDBFTable.LogicGet(const st : gsUTFString) : boolean;
begin
   CheckActive;
   LogicGet := FDBFHandle.gsLogicGet(st);
end;

Function TgsDBFTable.LogicGetN(n : integer) : boolean;
begin
   CheckActive;
   LogicGetN := FDBFHandle.gsLogicGetN(n);
end;

Procedure TgsDBFTable.LogicPut(const st : gsUTFString; b : boolean);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsLogicPut(st, b);
end;

Procedure TgsDBFTable.LogicPutN(n : integer; b : boolean);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsLogicPutN(n, b);
end;

Function TgsDBFTable.IntegerGet(const st : gsUTFString) : Int64;
var
   r : Extended;
begin
   CheckActive;
   r := FDBFHandle.gsNumberGet(st);
   {$IFDEF HASINT64}
   IntegerGet := Trunc(r);
   {$ELSE}
   IntegerGet := r;
   {$ENDIF}
end;

Function TgsDBFTable.IntegerGetN(n : integer) : Int64;
var
   r : Extended;
begin
   CheckActive;
   r := FDBFHandle.gsNumberGetN(n);
   {$IFDEF HASINT64}
   IntegerGetN := Trunc(r);
   {$ELSE}
   IntegerGetN := r;
   {$ENDIF}
end;

Procedure TgsDBFTable.IntegerPut(const st : gsUTFString; i : Int64);
var
   r : Extended;
begin
   CheckActive;
   ConfirmEdit;
   r := i;
   FDBFHandle.gsNumberPut(st, r);
end;

Procedure TgsDBFTable.IntegerPutN(n : integer; i : Int64);
var
   r : Extended;
begin
   CheckActive;
   ConfirmEdit;
   r := i;
   FDBFHandle.gsNumberPutN(n, r);
end;

Function TgsDBFTable.StringGet(const fnam : gsUTFString) : gsUTFString;
begin
   CheckActive;
   StringGet := FDBFHandle.gsStringGet(fnam);
end;

Function TgsDBFTable.StringGetN(fnum : integer) : gsUTFString;
begin
   CheckActive;
   StringGetN := FDBFHandle.gsStringGetN(fnum);
end;

Procedure TgsDBFTable.StringPut(const fnam, st : gsUTFString);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsStringPut(fnam, st);
end;

Procedure TgsDBFTable.StringPutN(fnum : integer; st : gsUTFString);
begin
   CheckActive;
   ConfirmEdit;
   FDBFHandle.gsStringPutN(fnum, st);
end;

Function TgsDBFTable.GetFileVersion: byte;
begin
   if FDBFHandle <> nil then
      Result := FDBFHandle.FileVers
   else
      Result := 0;
end;

procedure TgsDBFTable.RenameTable(const NewTableName: gsUTFString);
begin
   CheckActive;
   DBFHandle.gsRename(NewTableName);
   DBFName := NewTableName;
end;

procedure TgsDBFTable.EncryptFile(const APassword: gsUTFString);
begin
   CheckActive;
   DBFHandle.gsSetPassword(APassword);
end;

procedure TgsDBFTable.EncryptDBFFile(const APassword: gsUTFString);
begin
   CheckActive;
   DBFHandle.gsSetPassword(APassword);
end;

{------------------------------------------------------------------------------
                           Setup and Exit Routines
------------------------------------------------------------------------------}

end.

