unit gs6_dbf;
{-----------------------------------------------------------------------------
                          dBase III/IV File Handler

       gs6_DBF Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the object for all dBase III/IV file (.DBF)
       operations.  The object to manipulate the fields in the
       records of a dBase file is also contained here.

   Changes:
------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
  {$IFDEF LINUX}
  variants,
  {$ELSE}
     {$IFDEF VER140}
     Variants,
     {$ENDIF}
  {$ENDIF}
   SysHalc,
   classes,
   gs6_glbl,
   gs6_disk,
   gs6_memo,
   gs6_date,
   gs6_tool,
   gs6_cnst,
   gs6_sql,
   gs6_encrxm,         {Set name to encryption unit you want to use}
   gs6_lcal,
   SysUtils;

type

   dbFileStatus = (NotUpdated, Updated);
   dbFileState = (dbInactive, dbBrowse, dbEdit, dbAppend, dbIndex, dbCopy);
   dbFileEvent = (dbRecordChange, dbFieldChange, dbTableChange, dbRecordWrite,
                  dbPreRead, dbPreWrite, dbPostRead, dbPostWrite, dbFlush);

   dbInsertFieldProc  = Function(FldNo: integer; var s: gsUTFString;
                                 var t: char; var l,d: integer): boolean;


   GSP_DBFHeader = ^GSR_DBFHeader;  
   GSR_DBFHeader = packed Record
      DBType     : Byte;
      Year       : Byte;
      Month      : Byte;
      Day        : Byte;
      RecordCount: LongInt;
      Location   : Word;
      RecordLen  : Word;
      Reserve1   : Array[0..1] of Byte;
      TranIncmpl : byte;
      Encrypted  : byte;
      MultUseFlg : Longint;
      UserIDLast : Longint;               {!!RFG 081897}
      Reserve2   : Array[0..3] of Byte;
      DBTableFlag: Byte;                  {Table Flags}
                                          {  1 = production index}
                                          {  2 = has memos (VFP)}
                                          {  4 = is a DBC (VFP)}
      LangID     : Byte;
      Reserve3   : Array[0..1] of Byte;
   end;

   GSP_DBFField = ^GSR_DBFField;
   GSR_DBFField = packed Record
      dbFieldName    : array[0..10] of char;
      dbFieldType    : Char;
      dbFieldOffset  : Longint;
      dbFieldLgth    : Byte;
      dbFieldDec     : Byte;
      dbFieldFlag    : Byte;          {Added for VFP Field Flags}
                                      {    1 = System Column}
                                      {    2 = Can store null values}
                                      {    4 = Binary Column (Char and Memo)}
              {Following fields available for use}
      ResBytes     : array[0..4] of byte;
      ResWord      : word;
              {Used Internally}
      dbFieldNum     : word;          {Used by GS to hold the field number}
      dbFiller       : array[0..3] of byte;
   end;

   GSP_FieldArray = ^GSA_FieldArray;
   GSA_FieldArray  = ARRAY[1..4096] OF GSR_DBFField;     {%CHG0010}

   GSO_dBaseDBF = class(GSO_DiskFile)
      HeadProlog   : GSR_DBFHeader;   {Image of file header}
      dAlias       : gsUTFString;
      dStatus      : dbFileStatus;    {Holds Status Code of file}
      dState       : dbFileState;
      NumRecs      : LongInt;         {Number of records in file}
      HeadLen      : Integer;         {Header + Field Descriptor length}
      RecLen       : Integer;         {Length of record}
      NumFields    : Integer;         {Number of fields in the record}
      Fields       : GSP_FieldArray;  {Pointer to memory array holding}
                                      {field descriptors}
      RecNumber    : LongInt;         {Physical record number last read}
      CurRecord    : GSptrCharArray;  {Pointer to memory array holding}
                                      {the current record data.  Refer}
                                      {to Appendix B for record structure}
      CurRecHold   : GSptrCharArray;
      OrigRec      : GSptrCharArray;  {Keeps original record on change}
      CurRecEncrypt: PByteArray;
      CurRecChg    : PByteArray;
      File_EOF     : boolean;         {True if access tried beyond end of file}
      File_TOF     : boolean;         {True if access tried before record 1}
      FileVers     : byte;
      FileTarget   : byte;            {Used to determine memo conversion type}
      FileIsLocked : boolean;
      IndexFlag    : byte;
      MemoFlag     : byte;
      DBCFlag      : byte;
      UpdateTime   : longint;             {!!RFG 081897}
                                {bits 0-9 = sec100; 10-15 = sec; 16-21 = min}
                                {22-27 = hour                               }
      ExtTableChg  : boolean;
      IntTableChg  : boolean;
      RecModified  : boolean;
      UseDeletedRec: Boolean;
      gsvExactMatch: boolean;
      gsvAutoFlush: boolean;
      gsvIsEncrypted: boolean;
      gsvPasswordIn: gsUTFString;
      gsvPasswordOut: gsUTFString;
      gsvTempDir   : PChar;
      gsvUserID    : longint;             {!!RFG 081897}
      gsvIndexState: boolean;             {!!RFG 083097}
      WithMemo    : boolean;              {True if memo file present}
      WithIndex   : boolean;              {True if production index present}
      HdrLocked    : integer;             {!!RFG 121097}
      UseFileSize  : boolean;             {!!RFG 020598}
      DBFExpLink   : TgsExpUserLink;
      FDBFFieldList  : TStringList;
      dfDirtyReadLmt : gsuint32;
      dfDirtyReadMin : gsuint32;
      dfDirtyReadMax : gsuint32;
      dfDirtyReadRng : gsuint32;
      dfLockStyle    : GSsetLokProtocol;
      UpperTable     : pointer;
      LowerTable     : pointer;
      MemoObject     : GSobjMemo;

      CONSTRUCTOR Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
      DESTRUCTOR  Destroy; override;
      Procedure   gsAppend; virtual;
      procedure   gsAssignUserID(Usr: longint);
      function    gsDBFEvent(Event: dbFileEvent; Action: longint): boolean; virtual;
      Function    gsDelFlag: boolean;
      Function    gsExternalChange: integer;
      Procedure   gsFlush; override;
      Procedure   gsGetRec(RecNum: LongInt); virtual;
      Procedure   gsHdrRead;
      Procedure   gsHdrWrite;
      Function    gsLockAppend: boolean; virtual;
      Function    gsFLock: boolean; virtual;
      Function    gsLockFullFile: boolean; virtual;
      Function    gsLockTheFile(fposn,flgth: gsuint32): boolean;
      Function    gsLockOff: Boolean; virtual;
      Function    gsMemoObject: GSobjMemo;
      Function    gsRename(const NewName: gsUTFString): boolean; override;
      Function    gsRLock: boolean; virtual;
      Procedure   gsPutRec(RecNum : LongInt); virtual;
      procedure   gsReturnDateTimeUser(var dt, tm, us: longint);
      Procedure   gsSetLockProtocol(LokProtocol: GSsetLokProtocol); virtual;
      Procedure   gsStatusUpdate(stat1,stat2,stat3 : longint); override;
      Function    gsWithIndex: boolean; virtual;
   end;

   GSO_dBaseFld = class(GSO_dBaseDBF)
      FieldPtr    : GSP_DBFField;
      OEMChars    : boolean;
      Constructor Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
      Destructor  Destroy; override;
      Function    gsAnalyzeField(const fldst: gsUTFString) : GSP_DBFField; virtual;
      Procedure   gsBlank; virtual;
      Function    gsCheckField(const st : gsUTFString; ftyp : char) : GSP_DBFField;
      Procedure   gsClearFldChanged;
      Function    gsDateGet(const st : gsUTFString) : longint; virtual;
      Function    gsDateGetN(n : integer) : longint; virtual;
      Function    gsDatePut(const st: gsUTFString; jdte: longint): Boolean; virtual;
      Function    gsDatePutN(n : integer; jdte : longint): Boolean; virtual;
      Procedure   gsDeleteRec; virtual;
      Function    gsFieldGet(const fnam : gsUTFString) : gsUTFString; virtual;
      Function    gsFieldGetN(fnum : integer) : gsUTFString; virtual;
      Function    gsFieldLocate(fdsc: GSP_FieldArray; const st: gsUTFString;
                              var i: integer): boolean;
      Function    gsFieldNo(const st: gsUTFString): integer;
      Function    gsFieldPull(fr: GSP_DBFField; fp: GSptrCharArray) : gsUTFString;
      Procedure   gsFieldPush(fr: GSP_DBFField;const st : gsUTFString;
                            fp: GSptrCharArray);
      Function    gsFieldPut(const fnam, st : gsUTFString): Boolean; virtual;
      Function    gsFieldPutN(fnum: integer; const st: gsUTFString): Boolean; virtual;
      Function    gsFieldDecimals(i : integer) : integer; virtual;
      Function    gsFieldLength(i : integer) : integer; virtual;
      Function    gsFieldOffset(i : integer) : longint; virtual;
      Function    gsFieldName(i : integer) : gsUTFString; virtual;
      Function    gsFieldType(i : integer) : char; virtual;
      Procedure   gsGetRec(RecNum: LongInt); override;
      Function    gsLogicGet(const st : gsUTFString) : boolean; virtual;
      Function    gsLogicGetN(n : integer) : boolean; virtual;
      Function    gsLogicPut(const st : gsUTFString; b : boolean): Boolean; virtual;
      Function    gsLogicPutN(n : integer; b : boolean): Boolean; virtual;
      Function    gsMemoFieldCheck(n: integer): GSobjMemo;
      Function    gsMemoFieldNumber(const st: gsUTFString): integer;
      Function    gsMemoSize(const fnam: gsUTFString): longint;
      Function    gsMemoSizeN(fnum: integer): longint;
      Function    gsMemoLoad(const fnam: gsUTFString;buf: pointer;
                           var cb: longint): boolean;
      Function    gsMemoSave(const fnam: gsUTFString; buf: pointer;
                           var cb: longint): longint;
      Function    gsMemoLoadN(fnum: integer;buf: pointer;
                            var cb: longint): boolean;
      Function    gsMemoSaveN(fnum: integer;buf: pointer;
                            var cb: longint): longint;
      Function    gsNumberGet(const st : gsUTFString) : Extended; virtual;
      Function    gsNumberGetN(n : integer) : Extended; virtual;
      Function    gsNumberPut(const st: gsUTFString; r: Extended): Boolean; virtual;
      Function    gsNumberPutN(n : integer; r : Extended): Boolean; virtual;
      Function    gsStringGet(const fnam : gsUTFString) : gsUTFString; virtual;
      Function    gsStringGetN(fnum : integer) : gsUTFString; virtual;
      Function    gsStringPut(const fnam, st : gsUTFString): Boolean; virtual;
      Function    gsStringPutN(fnum: integer; const st: gsUTFString): Boolean; virtual;
      procedure   gsStuffABuffer(Buffer: PChar; const KeyFields: gsUTFString; const KeyValues: Variant);
      Procedure   gsUndelete; virtual;
   end;


   GSO_DBFBuild = class(TgsCollection)
      dbTypeNoMo  : byte;
      dbTypeMemo  : byte;
      dFile       : GSO_DiskFile;
      mFile       : GSO_DiskFile;
      HeadRec     : GSR_DBFHeader;
      FileName    : gsUTFString;
      hasMemo     : boolean;
      dbRecLen    : integer;
      dbTitle     : gsUTFString;
      GoodToGo    : boolean;
      Constructor Create(const FName: gsUTFString);
      Destructor  Destroy; override;
      Procedure   Complete; virtual;
      procedure   FreeItem(Item: Pointer); override;
      Procedure   InsertField(const s: gsUTFString; t: char; l,d: integer); virtual;
      Procedure   WriteDBF; virtual;
      Procedure   WriteDBT; virtual;
   end;

   GSO_DB3Build = GSO_DBFBuild;

   GSO_DB4Build = class(GSO_DBFBuild)
      Constructor Create(const FName: gsUTFString);
      Procedure   WriteDBT; override;
   end;

   GSO_DBFoxBuild = class(GSO_DBFBuild)
      Constructor Create(const FName: gsUTFString);
      Procedure   WriteDBT; override;
   end;



Function gsExtractFieldName(const Fields: gsUTFString; var Pos: Integer): gsUTFString;

Function gsCreateDBF(const fname: gsUTFString; ftype: char;
                                          fproc: dbInsertFieldProc): boolean;
Function gsCreateDBFEx(const fname: gsUTFString; ftype: char;
                                    fproc: dbInsertFieldProc): GSO_DiskFile;

function DBEncryption(const Key: gsUTFString; BufferIn, BufferOut: PByteArray; ReadOrWrite, Size: Integer): Integer;

{------------------------------------------------------------------------------
                            IMPLEMENTATION SECTION
------------------------------------------------------------------------------}

implementation

const
   EohMark  = #$0D;          {Byte stored at end of the header}

type

   TgsDBFFields = class(TObject)
   private
      DataTable: GSO_dBaseFld;
      FFieldName: gsUTFString;
      FFieldLen: integer;
      FFieldDec: integer;
      FFieldType: gsUTFChar;
      FFieldNo: integer;
      FFieldOffset: integer;
      FFieldVar: TgsUserDefFieldVar;
      procedure SetValue(Value: variant); virtual;
      function GetValue: variant; virtual;
   public
      constructor Create(ADataTable: GSO_dBaseFld; const AFieldName: gsUTFString;
                         AFieldType: gsUTFChar; AFieldLen, AFieldDec, AFieldNo, AOffset: integer;
                         AFieldVar: TgsUserDefFieldVar);
      destructor Destroy; override;
      function FieldDescriptor: gsUTFString;
      property Value: variant read GetValue write SetValue;
      property FieldName: gsUTFString read FFieldName;
      property FieldLen: integer read FFieldLen;
      property FieldDec: integer read FFieldDec;
      property FieldType: gsUTFChar read FFieldType;
      property FieldNo: integer read FFieldNo;
      property FieldVar: TgsUserDefFieldVar read FFieldVar;
   end;

   TgslDBFRecNo = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFDeleted = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFBOF = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFEOF = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFType = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFLen = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFFieldNo = class(TgsUserDefFunction)
   private
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld);
      function FunctionName: gsUTFString; override;
      procedure FunctionResult(Caller: TgsExpFunction; var BufVar: variant;
                      var ExpResult: TgsExpResultType); override;
   end;

   TgslDBFFieldVars = class(TgsUserDefFieldVar)
   private
      DataField: integer;
      DataTable: GSO_dBaseFld;
   public
      constructor Create(ADataTable: GSO_dBaseFld; ADataField: integer; AName: gsUTFString);
      function FieldVarType: integer; override;
      procedure FieldVarResult(var BufVar: variant;
                   var ExpResult: TgsExpResultType); override;
   end;


function DBEncryption(const Key: gsUTFString; BufferIn, BufferOut: PByteArray; ReadOrWrite, Size: Integer): Integer;
begin
   Result := Encryption(Key,BufferIn,BufferOut,ReadOrWrite,Size);
end;


{---------------------------------------------------------------------------
                             RecNo() Function
----------------------------------------------------------------------------}

constructor TgslDBFRecno.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFRecno.FunctionName: gsUTFString;
begin
   FunctionName := 'RECNO';
end;

procedure TgslDBFRecno.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   rnf: FloatNum;
begin
   ExpResult := rtFloat;
   rnf := DataTable.RecNumber;
   BufVar := rnf;
end;

{---------------------------------------------------------------------------
                             Deleted() Function
----------------------------------------------------------------------------}

constructor TgslDBFDeleted.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFDeleted.FunctionName: gsUTFString;
begin
   FunctionName := 'DELETED';
end;

procedure TgslDBFDeleted.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   df: boolean;
begin
   ExpResult := rtBoolean;
   df := DataTable.gsDelFlag;
   BufVar := df;
end;

{---------------------------------------------------------------------------
                             BOF() Function
----------------------------------------------------------------------------}

constructor TgslDBFBOF.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFBOF.FunctionName: gsUTFString;
begin
   FunctionName := 'BOF';
end;

procedure TgslDBFBOF.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   df: boolean;
begin
   ExpResult := rtBoolean;
   df := DataTable.File_TOF;
   BufVar := df;
end;

{---------------------------------------------------------------------------
                             EOF() Function
----------------------------------------------------------------------------}

constructor TgslDBFEOF.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFEOF.FunctionName: gsUTFString;
begin
   FunctionName := 'EOF';
end;

procedure TgslDBFEOF.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   df: boolean;
begin
   ExpResult := rtBoolean;
   df := DataTable.File_EOF;
   BufVar := df;
end;

{---------------------------------------------------------------------------
                             Type() Function
----------------------------------------------------------------------------}

constructor TgslDBFType.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFType.FunctionName: gsUTFString;
begin
   FunctionName := 'TYPE';
end;

procedure TgslDBFType.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s1: gsUTFString;
   fx: GSP_DBFField;
begin
   ExpResult := rtText;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := gsStrUpperCase(BufVar);
   fx := DataTable.gsAnalyzeField(s1);
   BufVar := fx^.dbFieldType;
end;


{---------------------------------------------------------------------------
                             Len() Function
----------------------------------------------------------------------------}

constructor TgslDBFLen.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFLen.FunctionName: gsUTFString;
begin
   FunctionName := 'LEN';
end;

procedure TgslDBFLen.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s1: gsUTFString;
   fx: GSP_DBFField;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := gsStrUpperCase(BufVar);
   fx := DataTable.gsAnalyzeField(s1);
   BufVar := fx^.dbFieldLgth;
end;

{---------------------------------------------------------------------------
                             FieldNo() Function
----------------------------------------------------------------------------}

constructor TgslDBFFieldNo.Create(ADataTable: GSO_dBaseFld);
begin
   inherited Create;
   DataTable := ADataTable;
end;

function TgslDBFFieldNo.FunctionName: gsUTFString;
begin
   FunctionName := 'FIELDNO';
end;

procedure TgslDBFFieldNo.FunctionResult(Caller: TgsExpFunction;
         var BufVar: variant; var ExpResult: TgsExpResultType);
var
   r: TgsExpResultType;
   s1: gsUTFString;
begin
   ExpResult := rtFloat;
   Caller.FetchArg(0, BufVar, r, rtText);
   s1 := gsStrUpperCase(BufVar);
   BufVar := DataTable.gsFieldNo(s1);
end;

{---------------------------------------------------------------------------
                             FieldVars Function
----------------------------------------------------------------------------}

constructor TgslDBFFieldVars.Create(ADataTable: GSO_dBaseFld; ADataField: integer; AName: gsUtfString);
begin
   inherited Create(AName);
   DataTable := ADataTable;
   DataField := ADataField;
   VarLength := DataTable.Fields^[DataField].dbFieldLgth;
   if DataTable.Fields^[DataField].dbFieldType = 'C' then
   begin
      VarLength := (DataTable.Fields^[DataField].dbFieldDec*256) + VarLength;
   end;
end;

function TgslDBFFieldVars.FieldVarType: integer;
begin
   Result := gsSQLTypeVarDBF;
end;

procedure TgslDBFFieldVars.FieldVarResult(var BufVar: variant;
                      var ExpResult: TgsExpResultType);
var
   s: gsUTFString;
   p: PChar;
   f: FloatNum;
   j: longint;
   b: boolean;
begin
   case DataTable.Fields^[DataField].dbFieldType of
      'C' : begin
               ExpResult := rtText;
               s := DataTable.gsFieldGetN(DataField);
               BufVar := s;
            end;
      'N',
      'F' : begin
               ExpResult := rtFloat;
               f := DataTable.gsNumberGetN(DataField);
               BufVar := f;
            end;
      'D' : begin
               ExpResult := rtDate;
               j := DataTable.gsDateGetN(DataField);
               f := j;
               BufVar := f;
            end;
      'L' : begin
               ExpResult := rtBoolean;
               b := DataTable.gsLogicGetN(DataField);
               BufVar := b;
            end;
      'M' : begin
               ExpResult := rtText;
               j := DataTable.gsMemoSizeN(DataField);
               if j > 0 then
               begin
                  p := AllocMem(j+1);
                  DataTable.gsMemoLoadN(DataField,pointer(p),j);
                  BufVar := StrPas(p);
                  FreeMem(p);
               end
               else
                  BufVar := '';
            end;
      else  begin
               ExpResult := rtMemo;
               BufVar := DataTable.gsFieldGetN(DataField);
            end;
   end;
end;

{------------------------------------------------------------------------------
                                Global Routines
------------------------------------------------------------------------------}

function gsExtractFieldName(const Fields: gsUTFString; var Pos: Integer): gsUTFString;
var
  I: Integer;
begin
  I := Pos;
  while (I <= Length(Fields)) and (Fields[I] <> ';') do Inc(I);
  Result := Trim(Copy(Fields, Pos, I - Pos));
  if (I <= Length(Fields)) and (Fields[I] = ';') then Inc(I);
  Pos := I;
end;

Function gsCreateDBFEx(const fname: gsUTFString; ftype: char;
                                    fproc: dbInsertFieldProc): GSO_DiskFile;
var
   fx: GSO_DBFBuild;
   i: integer;
   s: gsUTFString;
   t: char;
   l: integer;
   d: integer;
   b: boolean;
begin
   gsCreateDBFEx := nil;
   if fname = '' then exit;
   if @fproc = nil then exit;
   fx := nil;
   case ftype of
      '3',
      'C' : fx := GSO_DB3Build.Create(fname);
      '4',
      '5' : fx := GSO_DB4Build.Create(fname);
      'F' : fx := GSO_DBFoxBuild.Create(fname);
   end;
   if fx = nil then exit;
   i := 1;
   repeat
      b := fproc(i,s,t,l,d);
      inc(i);
      if (b) and (length(s) > 0) then
         fx.InsertField(s,t,l,d);
   until (not b) or (length(s) = 0);
   fx.GoodToGo := b;
   fx.Complete;
   gsCreateDBFEx := fx.dFile;
   fx.dFile := nil;
   fx.GoodToGo := false;                                     {RFG 071697}
   fx.Free;                                          {RFG 071697}
end;

Function gsCreateDBF(const FName: gsUTFString; ftype: char; fproc: dbInsertFieldProc): boolean;
var
   p: GSO_DiskFile;
begin
   p := gsCreateDBFEx(FName,ftype,fproc);
   gsCreateDBF := p <> nil;
   if p <> nil then
      p.Free;
end;


{------------------------------------------------------------------------------
                                GSO_dBaseDBF
------------------------------------------------------------------------------}


CONSTRUCTOR GSO_dBaseDBF.Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
const
   ext: gsUTFString = '.DBF';
VAR
   fl  : integer;                   {field length working variable}
   Pth : gsUTFString;
begin
   Pth := ChangeFileExtEmpty(FName,ext);
   inherited Create(Pth, ReadWrite, Shared);
   if not FileExist then
      raise EHalcyonError.CreateFmt(gsErrNoSuchFile,[FileName]);
   gsvPasswordIn := APassword;
   dAlias := gsStrUpperCase(ExtractFileName(FName));
   dAlias := ChangeFileExt(dAlias,'');
   gsvPasswordOut := APassword;
   gsSetLockProtocol(Default);
   DBFExpLink := nil;
   CurRecord := nil;
   CurRecHold := nil;
   Fields := nil;
   CurRecChg := nil;
   OrigRec := nil;
   gsvTempDir := nil;
   gsReset;                       {File length of one byte}
   FileIsLocked := false;
                  {ProcessHeader}
   if gsRead(0, HeadProlog, 32) <> 32 then
      raise EHalcyonError.CreateFmt(gsErrReadFailed,[FileName]);
   case HeadProlog.DBType of        {test for valid dBase types}
      SpecialFile, 
      DB3File,
      DB3WithMemo,
      {DB4File,}
      DB4WithMemo,
      {FxPFile,}
      FXPWithMemo,
      VFP3File    : begin                            {Good File}
                       FileVers := HeadProlog.DBType;
                       FileTarget := FileVers;     {set copy type to current type}
                       NumRecs := HeadProlog.RecordCount;
                       HeadLen := HeadProlog.Location;  {length of header}
                       RecLen := HeadProlog.RecordLen;  {Length of record}
                       IndexFlag := HeadProlog.DBTableFlag and $01;
                       MemoFlag := HeadProlog.DBTableFlag and $02;
                       DBCFlag := HeadProlog.DBTableFlag and $04;
                       UpdateTime := HeadProlog.MultUseFlg;
                       gsvIsEncrypted := HeadProlog.Encrypted <> 0;
                    end;
       else         begin
                       raise EHalcyonError.CreateFmt(gsErrDBFHeader,[FileName]);
                    end;
   end;                      {CASE}
   if gsvIsEncrypted and (APassword = '') then
   begin
      raise EHalcyonEncryption.CreateFmt(gsErrNoPassword,[FileName]);
   end
   else
      if (not gsvIsEncrypted) and (APassword <> '') then
      begin
         raise EHalcyonEncryption.CreateFmt(gsErrUnExpectedPassword,[FileName]);
      end;
  Case FileVers of
      DB3WithMemo,
      DB4WithMemo,
      FXPWithMemo : WithMemo := true;
      VFP3File    : WithMemo := (HeadProlog.DBTableFlag and $02) <> 0;
      else WithMemo := false;
   end;
   RecNumber := 0;                 {Set current record to zero}
   File_EOF := false;              {Set End of File flag to false}
   File_TOF := true;               {Set Top of File flag to true};
   NumRecs := (gsFileSize-HeadLen) div RecLen;   {!!RFG 020598}
   fl := HeadLen-33;               {Size of field descriptors}
   if FileVers = VFP3File then
      fl := fl - 263;
   GetMem(Fields, fl);             {Allocate memory for fields buffer.}
   NumFields := fl div 32;         {Number of fields}
   if inherited gsRead(32, Fields^, fl) <> fl then     {Store field data}
      raise EHalcyonError.CreateFmt(gsErrReadFailed,[FileName]);
   if gsvIsEncrypted then
   begin
      DBEncryption(gsvPasswordIn,PByteArray(Fields),PByteArray(Fields),0,fl);
   end;
   dStatus := NotUpdated;         {Set file status to 'Not Updated'   }
   FDBFFieldList := TStringList.Create;
   FDBFFieldList.Sorted := false;
   FDBFFieldList.Duplicates := dupError;
   GetMem(CurRecord, RecLen+1);    {Allocate memory for record buffer}
   FillChar(CurRecord^,RecLen,' ');
   CurRecord^[RecLen] := EofMark;  {End of file flag after record}
   CurRecHold := CurRecord;
   GetMem(OrigRec, RecLen+1);
   FillChar(OrigRec^,RecLen,' ');
   GetMem(CurRecEncrypt, RecLen+1);
   FillChar(CurRecEncrypt^,RecLen,' ');
   GetMem(CurRecChg,succ(NumFields));
   MemoObject := nil;
   ExtTableChg := false;
   IntTableChg := false;
   UseDeletedRec := true;
   gsvExactMatch := false;
   gsvUserID := 0;
   gsvIndexState := false;
   gsvAutoFlush := false;
   RecModified := false;
   HdrLocked := 0;
   dState := dbBrowse;
   gsHdrRead;
   gsDBFEvent(dbTableChange,0);
end;

Destructor GSO_dBaseDBF.Destroy;
var
   fl: longint;
   i: integer;
begin
   IF dStatus = Updated THEN
   begin
      gsHdrRead;                  {!!RFG 091697}
      gsHdrWrite;                {Write new header information if the}
   end;                                 {file was updated in any way}
   if MemoObject <> nil then
   begin
      MemoObject.Free;
      MemoObject := nil;
   end;
   StrDispose(gsvTempDir);
   gsvTempDir := nil;
   if (CurRecHold <> nil) then
      FreeMem(CurRecHold, RecLen+1);{DeAllocate memory for record buffer}
   CurRecHold := nil;
   if CurRecChg <> nil then
      FreeMem(CurRecChg,succ(NumFields));
   CurRecChg := nil;
   if Fields <> nil then
   begin
      fl := HeadLen-33;               {Size of field descriptors}
      if FileVers = VFP3File then
         fl := fl - 263;
      FreeMem(Fields, fl);  {DeAllocate memory for fields buffer.}
      Fields := nil;
   end;
   if OrigRec <> nil then
      FreeMem(OrigRec, RecLen+1);   {DeAllocate memory for record buffer}
   OrigRec := nil;
   if CurRecEncrypt <> nil then
      FreeMem(CurRecEncrypt, RecLen+1);   {DeAllocate memory for record buffer}
   CurRecEncrypt := nil;
   if FDBFFieldList <> nil then
   begin
      for i := 0 to FDBFFieldList.Count-1 do
          FDBFFieldList.Objects[i].Free;
      FDBFFieldList.Free;
   end;   
   inherited Destroy;
end;

Procedure GSO_dBaseDBF.gsAppend;
BEGIN
   gsLockAppend;
   try
      gsDBFEvent(dbPreWrite,0);
      RecModified := true;
      dStatus := Updated;             {Set file status to 'Updated'}
      gsHdrRead;                        {!!RFG 091697}
      CurRecord^[0] := GS_dBase_UnDltChr;
      inc(NumRecs);
      RecNumber := NumRecs;               {Store record number as current record }
      if gsvIsEncrypted then
      begin
         DBEncryption(gsvPasswordOut,PByteArray(CurRecord),CurRecEncrypt,1,RecLen);
         CurRecEncrypt^[RecLen] := ord(EofMark);
         gsWrite(HeadLen+((RecNumber-1)*RecLen), CurRecEncrypt^, RecLen+1);
      end
      else
      begin
         CurRecord^[RecLen] := EofMark;
         gsWrite(HeadLen+((RecNumber-1)*RecLen), CurRecord^, RecLen+1);
      end;
      gsHdrWrite;
   finally
      gsLockOff;
   end;
   File_EOF := false;
   File_TOF := false;
   gsDBFEvent(dbPostWrite,0);
   if gsvAutoFlush then gsFlush;
   Move(CurRecord^, OrigRec^, RecLen);
END;

procedure  GSO_dBaseDBF.gsAssignUserID(Usr: longint);
begin
   gsvUserID := Usr;
end;

function GSO_dBaseDBF.gsDBFEvent(Event: dbFileEvent; Action: longint): boolean;
begin
   gsDBFEvent := true;
   case Event of
      dbPostRead,
      dbPostWrite     : begin
                           RecModified := false;
                           if dState <> dbCopy then
                              dState := dbBrowse;
                        end;
      dbPreRead       : begin
                        end;
   end;
end;

Function GSO_dBaseDBF.gsDelFlag: boolean;
begin
   if CurRecord = nil then
      gsDelFlag := false
   else
      if CurRecord^[0] = GS_dBase_DltChr then
         gsDelFlag := true
      else
         gsDelFlag := false;
end;

Function GSO_dBaseDBF.gsExternalChange: integer;
var
   r: integer;         {!!RFG 082897}
begin
   r := 0;
   gsHdrRead;
   if ExtTableChg then
      r := 2;
   if IntTableChg then
      r := r + 1;
   ExtTableChg := false;
   IntTableChg := false;
   gsExternalChange := r;
end;

Procedure GSO_dBaseDBF.gsFlush;
begin
   inherited gsFlush;
   MemoObject := gsMemoObject;
   if MemoObject <> nil then
      MemoObject.gsFlush;    {flush Memo file first time only}
   gsDBFEvent(dbFlush,RecNumber);
end;

Procedure GSO_dBaseDBF.gsGetRec(RecNum : LongInt);
VAR
   RNum   : LongInt;                  {Local working variable  }
   RNumInt: integer;
BEGIN
   if NumRecs = 0 then
      gsHdrRead;                    {Ensure nobody else added records}
   if (NumRecs = 0) then
   begin
      File_EOF := true;
      File_TOF := true;
      exit;
   end;
   if RecNum = 0 then exit;         {!!RFG 022198}
   RNum := RecNum;                    {Store RecNum locally for modification}
   if RecNum >= MaxInt then            {Set RNumInt to valid value for case}
      RNumInt := 1                    {testing                            }
   else
      RNumInt := RecNum;
   File_EOF := false;                 {Initialize End of File Flag to false}
   File_TOF := false;
   case RNumInt of
      Same_Record : RNum := RecNumber;
      Next_Record : RNum := RecNumber + 1;   {Advance one record}
      Prev_Record : begin
                       RNum := RecNumber - 1;   {Back up one record}
                       if RNum = 0 then
                       begin
                          File_TOF := true;
                          Exit;
                       end;
                    end;
      Top_Record  : RNum := 1;               {Set to the first record}
      Bttm_Record : RNum := NumRecs;
      else
         if (RNum < 1) then
         begin
            raise EHalcyonError.CreateFmt(gsErrDBFRecordNo,[RNum,FileName]);
         end;
   end;
   if (RNum > NumRecs) then
   begin
      gsHdrRead;    {Confirm NumRecs set to the last record}
      if (RNum > NumRecs) then
      begin {see if normal skip to 1+last or REAL range error}
         if (RNum > succ(NumRecs)) then  {Out of range?}
         begin
            raise EHalcyonError.CreateFmt(gsErrDBFRecordNo,[RNum,FileName]);
         end;
         File_EOF := true;
         exit;
      end;
   end;
   gsDBFEvent(dbPreRead,RecNum);
   if gsRead(HeadLen+((RNum-1) * RecLen), CurRecord^, RecLen) <> RecLen then  {Read RecLen bytes into memory buffer}
      raise EHalcyonError.CreateFmt(gsErrReadFailed,[FileName]);
   if gsvIsEncrypted then   {see if encrypted}
   begin
      DBEncryption(gsvPasswordIn,PByteArray(CurRecord),PByteArray(CurRecord),0,RecLen);
   end;
   RecNumber := RNum;                 {Set objectname.RecNumber = this record }
   gsDBFEvent(dbPostRead,RNum);
   Move(CurRecord^, OrigRec^, RecLen);
END;                  {GetRec}

Procedure GSO_dBaseDBF.gsHdrRead;
var
   rs: longint;
begin
   if (not FileShared) then
      ExtTableChg := false
   else
   begin
      inherited gsRead(0, HeadProlog, 32);
      rs := (gsFileSize-HeadLen) div RecLen;
      ExtTableChg :=  (NumRecs <> rs) or
                      (UpdateTime <> HeadProlog.MultUseFlg);
      NumRecs := rs;
      UpdateTime := HeadProlog.MultUseFlg;
   end;
end;

Procedure GSO_dBaseDBF.gsHdrWrite;
var
   yy, mm, dd : word;     {Local variables to get today's date}
   hour, min, sec, sec100: word;
begin
   if (not FileReadWrite) or (dStatus <> Updated) then exit;
   if FileIsLocked then exit;
   DecodeTime(Time,hour,min,sec,sec100);
   UpdateTime := hour;
   UpdateTime := (UpdateTime shl 6) + min;
   UpdateTime := (UpdateTime shl 6) + sec;
   UpdateTime := (UpdateTime shl 10) + sec100;
   DecodeDate(Date,yy,mm,dd);
   HeadProlog.year := yy mod 100;  {Extract the Year}
   HeadProlog.month := mm;         {Extract the Month}
   HeadProlog.day := dd;           {Extract the Day}
   HeadProlog.RecordCount := NumRecs; {Update number records in file}
   HeadProlog.DBTableFlag := IndexFlag or MemoFlag or DBCFlag;
   HeadProlog.MultUseFlg := UpdateTime;
   if gsvIsEncrypted then
      HeadProlog.Encrypted := 1
   else
      HeadProlog.Encrypted := 0;
   HeadProlog.UserIDLast := gsvUserID;   {!!RFG 081897}
   gsWrite(0, HeadProlog, 32);
   dStatus := NotUpdated;          {Reset updated status}
end;

Function GSO_dBaseDBF.gsLockAppend: boolean;
begin
   gsLockAppend := gsLockTheFile(dfDirtyReadMax,1);
end;

Function GSO_dBaseDBF.gsFLock: boolean;
begin
   if not FileIsLocked then
   begin                    {Lock file, allow dirty read}
      FileIsLocked := gsLockTheFile(dfDirtyReadMin, dfDirtyReadRng);
      if FileIsLocked then gsHdrRead;     {Call to update rec count}
      gsFLock := FileIsLocked;
   end
   else
      gsFLock := gsLockTheFile(dfDirtyReadMin, dfDirtyReadRng);
end;

Function GSO_dBaseDBF.gsLockFullFile: boolean;
begin
   if not FileIsLocked then
   begin                    {Lock file, allow no read}
      FileIsLocked := gsLockTheFile(0, MaxRecNum);
      if FileIsLocked then gsHdrRead;     {Call to update rec count}
      gsLockFullFile := FileIsLocked;
   end
   else
      gsLockFullFile := gsLockTheFile(0, MaxRecNum);
end;

Function GSO_dBaseDBF.gsLockTheFile(fposn,flgth: gsuint32): boolean;
var
   rsl: boolean;
begin
   rsl := FileIsLocked;
   if not rsl then
      rsl := gsLockRecord(fposn,flgth)
   else
      IncLockCount;
   gsLockTheFile := rsl;
end;

Function GSO_dBaseDBF.gsMemoObject: GSobjMemo;
begin
   Result := MemoObject;
   if MemoObject <> nil then exit;
   case FileVers of
      DB3WithMemo : Result := GSobjMemo.Create(Self,FileName, gsvPasswordIn, FileReadWrite, FileShared, FileVers);
      DB4WithMemo : Result := GSobjMemo4.Create(Self,FileName, gsvPasswordIn, FileReadWrite, FileShared, FileVers);
      VFP3File    : if MemoFlag <> 0 then
                       Result := GSobjFXMemo20.Create(Self,FileName, gsvPasswordIn, FileReadWrite, FileShared, FileVers);
      FXPWithMemo : Result := GSobjFXMemo20.Create(Self,FileName, gsvPasswordIn, FileReadWrite, FileShared, FileVers);
   end;
   if Result <> nil then
   begin
      Result.moSetLockProtocol(dfLockStyle);
      Result.IsEncrypted := true;
      Result.PasswordIn := gsvPasswordIn;
      Result.PasswordOut := gsvPasswordOut;
   end;
end;

Function GSO_dBaseDBF.gsRename(const NewName: gsUTFString): boolean;
begin
   MemoObject := gsMemoObject;
   inherited gsRename(NewName);
   if MemoObject <> nil then
      MemoObject.moRename(NewName);    {rename Memo file first time only}
   Result := true;
end;


Function GSO_dBaseDBF.gsRLock: boolean;
var
  rsl: boolean;
  rn: gsuint32;
  rl: gsuint32;
  hl: gsuint32;
begin
   rsl := false;
   rn := RecNumber;
   rl := RecLen;
   hl := HeadLen;
   case dfLockStyle of
      DB4Lock  : begin
                    rsl := gsLockTheFile(dfDirtyReadMax - rn - 1, 1);
                 end;
      ClipLock : begin
                    rsl := gsLockTheFile(dfDirtyReadMin + rn, 1);
                 end;
      Default,
      FoxLock  : begin
                    if gsWithIndex then
                       rsl := gsLockTheFile(dfDirtyReadMax - rn, 1)
                    else
                       rsl := gsLockTheFile(dfDirtyReadMin+
                                  (hl+((rn-1)*rl)), 1);
                 end;
   end;
   gsrLock := rsl;
end;

Function GSO_dBaseDBF.gsLockOff: boolean;
begin
   gsLockOff := true;
   if not LockCount > 0 then exit;
   GSLockOff := gsUnlock;
   if FileIsLocked and (LockCount = 0) then
      gsHdrWrite; {Now update header, since no header writes while file is locked}
   FileIsLocked := FileIsLocked and (LockCount > 0);
end;

Procedure GSO_dBaseDBF.gsPutRec(RecNum : LongInt);
begin
   gsDBFEvent(dbPreWrite,RecNum);
   IF (RecNum > NumRecs) or (RecNum < 1) or (dState = dbAppend) then
      gsAppend
   else
   begin
      dStatus := Updated;            {Set file status to 'Updated'}
      if gsvIsEncrypted then
      begin
         DBEncryption(gsvPasswordOut,PByteArray(CurRecord),CurRecEncrypt,1,RecLen);
         gsWrite(HeadLen+((RecNum-1)*RecLen), CurRecEncrypt^, RecLen);
      end
      else
         gsWrite(HeadLen+((RecNum-1)*RecLen), CurRecord^, RecLen);
      RecNumber := RecNum;
      IntTableChg := true;
      gsHdrRead;
      gsHdrWrite;
      gsDBFEvent(dbPostWrite,RecNum);
      if gsvAutoFlush then gsFlush;
      Move(CurRecord^, OrigRec^, RecLen);
   end;
END;                        {PutRec}

procedure GSO_dBaseDBF.gsReturnDateTimeUser(var dt, tm, us: longint);
begin
   gsHdrRead;
   dt := HeadProlog.Year;
   dt := (dt shl 8) + HeadProlog.Month;
   dt := (dt shl 8) + HeadProlog.Day;
   tm := UpdateTime;
   us := HeadProlog.UserIDLast;
end;


Procedure GSO_dBaseDBF.gsSetLockProtocol(LokProtocol: GSsetLokProtocol);
begin
   dfLockStyle := LokProtocol;
   case LokProtocol of
      DB4Lock  : begin
                    dfDirtyReadMin := $40000000;
                    dfDirtyReadMax := $EFFFFFFF;
                    dfDirtyReadRng := $B0000000;
                 end;
      ClipLock : begin
                    dfDirtyReadMin := 1000000000;
                    dfDirtyReadMax := 1000000000;
                    dfDirtyReadRng := 1000000000;
                 end;
      Default,
      FoxLock  : begin
                    dfDirtyReadMin := $40000000;
                    dfDirtyReadMax := $7FFFFFFE;
                    dfDirtyReadRng := $3FFFFFFF;
                 end;
   end;
   If MemoObject <> nil then
      MemoObject.moSetLockProtocol(LokProtocol);
end;

Procedure GSO_dBaseDBF.gsStatusUpdate(stat1,stat2,stat3 : longint);
begin
end;

Function  GSO_DBaseDBF.gsWithIndex: boolean;
begin
   gsWithIndex := false;
end;

{------------------------------------------------------------------------------
                                GSO_dBaseFld
------------------------------------------------------------------------------}

constructor GSO_dBaseFld.Create(const FName,APassword: gsUTFString; ReadWrite, Shared: boolean);
var
   i   : integer;
   offset : integer;
   fv: TgslDBFFieldVars;
   fn: gsUTFString;
   ffl: TgsdBFFields;
begin
   inherited Create(FName, APassword, ReadWrite, Shared);
   Case FileVers of
      DB3WithMemo,
      DB4WithMemo,
      FXPWithMemo : WithMemo := true;
      VFP3File    : WithMemo := (HeadProlog.DBTableFlag and $02) <> 0;
      else WithMemo := false;
   end;

   {$IFDEF NODBFSTR256}
   for i := 1 to NumFields do
   begin
      if Fields^[i].dbFieldType = 'C' then
         Fields^[i].dbFieldDec := 0;
   end;
   {$ENDIF}

   if gsvIsEncrypted then
   begin
      offset := 1;
      for i := 1 to NumFields do
      begin
         offset := offset + Fields^[i].dbFieldLgth;
         if Fields^[i].dbFieldType = 'C' then
            offset := offset + (Fields^[i].dbFieldDec * 256);
      end;
      if offset <> RecLen then
         raise EHalcyonEncryption.CreateFmt(gsErrBadPassword,[FileName]);
   end;
   DBFExpLink := TgsExpUserLink.Create;
   DBFExpLink.RegisterFunction(TgslDBFRecNo.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFDeleted.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFBOF.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFEOF.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFType.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFLen.Create(Self));
   DBFExpLink.RegisterFunction(TgslDBFFieldNo.Create(Self));
   offset := 1;
   for i := 1 to NumFields do
   begin
      fn := StrPas(Fields^[i].dbFieldName);
      fv := TgslDBFFieldVars.Create(Self,i,Fields^[i].dbFieldName);
      ffl := TgsDBFFields.Create(Self, StrPas(Fields^[i].dbFieldName),
                                 Fields^[i].dbFieldType,Fields^[i].dbFieldLgth,
                                 Fields^[i].dbFieldDec, i, offset, fv);
      FDBFFieldList.AddObject(StrPas(Fields^[i].dbFieldName),ffl);
      DBFExpLink.RegisterFieldVar(TgslDBFFieldVars.Create(Self,i,fn+';'+dAlias+'.'+fn));
      Fields^[i].dbFieldNum := i;
      Fields^[i].dbFieldOffset := offset;
      offset := offset + Fields^[i].dbFieldLgth;
      if Fields^[i].dbFieldType = 'C' then
         offset := offset + (Fields^[i].dbFieldDec * 256);
   end;
   OEMChars := true;
   WithIndex := IndexFlag <> 0;
   gsClearFldChanged;
end;

Destructor GSO_dBaseFld.Destroy;
begin
   DBFExpLink.Free;
   inherited Destroy;
end;

function GSO_dBaseFld.gsAnalyzeField(const fldst : gsUTFString): GSP_DBFField;
var
   LastFieldCk : integer;
   FST: gsUTFString;
begin
   LastFieldCk := NumFields;
   if gsFieldLocate(Fields,fldst,LastFieldCk) then
      gsAnalyzeField := @Fields^[LastFieldCk]
   else
   begin
      FST := FileName+'->'+fldst;
      raise EHalcyonError.CreateFmt(gsErrFieldName,[FST]);
   end;
end;

procedure GSO_dBaseFld.gsBlank;
var
   i: integer;
begin
   FillChar(CurRecord^[0], RecLen, ' '); {Fill spaces for RecLen bytes}
   for i := 1 to NumFields do
   begin
      if Fields^[i].dbFieldType in ['N','F'] then
         gsNumberPutN(i,0.0);
      if FileVers = VFP3File then
         if Fields^[i].dbFieldType in ['I','B','G','M','T','Y'] then
            gsNumberPutN(i,0.0);
   end;
   FillChar(CurRecChg^,succ(NumFields),#1);
   RecModified := true;
   gsDBFEvent(dbRecordChange,0);
end;

function  GSO_dBaseFld.gsCheckField;
                          {(const st: String255; ftyp: char): GSP_DBFField;}
var
   FPtr : GSP_DBFField;
   typOk: boolean;
begin
   FPtr := gsAnalyzeField(st);
   if FPtr <> nil then
   begin
      if FPtr^.dbFieldType <> ftyp then
      begin
         typOk := false;
         case ftyp of
            'N' : typOk := (FPtr^.dbFieldType in ['M','F','B','G','I']);
            'G' : typOk := (FPtr^.dbFieldType in ['M','B']);
         end;
         if not typOk then
         begin
            raise EHalcyonError.CreateFmt(gsErrFieldType,[st]);
            FPtr := nil;
         end;
      end;
   end;
   gsCheckField := FPtr;
end;

procedure GSO_dBaseFld.gsClearFldChanged;
begin
   FillChar(CurRecChg^,succ(NumFields),#0);
end;

function  GSO_dBaseFld.gsDateGet(const st: gsUTFString): longint;
begin
   FieldPtr := gsCheckField(st,'D');
   if (FieldPtr <> nil) then
      gsDateGet := gsDateGetN(FieldPtr^.dbFieldNum)
   else
      gsDateGet := gsDateJulInv;
end;

function  GSO_dBaseFld.gsDateGetN;  {(n : integer) : longint;}
var
   v : longint;
   s : gsUTFString;
   ep : gsUTFString;
begin
   if (n > NumFields) or (n < 1) then v := 0
   else
   begin
      FieldPtr := @Fields^[n];
      s := gsFieldPull(FieldPtr, CurRecord);
      try
         v := DBFDate.CTOD(s);
      except
         ep := ExtractFileNameOnly(FileName)+'->';
         ep := ep + StrPas(FieldPtr^.dbFieldName);
         ep := ep + ' ('+s+')';
         raise EHalcyonError.CreateFmt(gsErrFieldDate,[ep]);
         v := 0;
      end;
   end;
   gsDateGetN := v;
end;

function GSO_dBaseFld.gsDatePut(const st : gsUTFString; jdte : longint): boolean;
begin
   FieldPtr := gsCheckField(st,'D');
   if (FieldPtr <> nil) then
       gsDatePut := gsDatePutN(FieldPtr^.dbFieldNum, jdte)
   else
      gsDatePut := false;
end;

function GSO_dBaseFld.gsDatePutN;  {(n : integer; jdte : longint)}
var
   fn: gsUTFString;
begin
   if (n > NumFields) or (n < 1) then
      gsDatePutN := false
   else
   begin
      FieldPtr := @Fields^[n];
      if FieldPtr^.dbFieldType = 'D' then
      begin
         if jdte = gsDateJulInv then
         begin
            fn :=  StrPas(FieldPtr^.dbFieldName);
            raise EHalcyonError.CreateFmt(gsErrFieldInput,['Date',fn]);
            exit;
         end;
         gsFieldPush(FieldPtr,DBFDate.DTOS(jdte), CurRecord);
         gsDatePutN := true;
      end
      else
         gsDatePutN := false;
   end;
end;

procedure GSO_dBaseFld.gsDeleteRec;
begin
   if CurRecord^[0] = GS_dBase_DltChr then exit;
   CurRecord^[0] := GS_dBase_DltChr;  {Put '*' in first byte of current record}
   CurRecChg^[0] := 1;
   RecModified := true;
   gsPutRec(RecNumber);    {Write the current record to disk }
end;

Function GSO_dBaseFld.gsFieldGet;  {(const fnam : String255) : String255}
begin
   FieldPtr := gsAnalyzeField(fnam);
   if (FieldPtr <> nil)  then
      gsFieldGet := gsFieldPull(FieldPtr, CurRecord)
         else gsFieldGet := '';
end;

Function GSO_dBaseFld.gsFieldGetN;  {(fnum : integer) : String255}
begin
   if (fnum > NumFields) or (fnum < 1) then
   begin
      gsFieldGetN := '';
      exit;
   end;
   FieldPtr := @Fields^[fnum];
   gsFieldGetN := gsFieldPull(FieldPtr, CurRecord);
end;

Function GSO_dBaseFld.gsFieldLocate(fdsc: GSP_FieldArray; const st: gsUTFString;
                                  var i: integer): boolean;
var
   mtch : boolean;
   ix   : integer;
   za   : array[0..11] of char;
begin
   StrPCopy(za,st);
   ix := StrLen(za);
   while (za[ix] = ' ') and (ix > 0) do
   begin
      za[ix] := #0;
      dec(ix);
   end;
   ix := NumFields;
   i := 1;
   mtch := false;
   while (i <= ix) and not mtch do
   begin
      if gsBufCompareI(za,GSR_DBFField(fdsc^[i]).dbFieldName) = 0 then
         mtch := true
      else
         inc(i);
   end;
   gsFieldLocate := mtch;
end;

Function GSO_dBaseFld.gsFieldNo(const st : gsUTFString): integer;
var
   LastFieldCk : integer;
begin
   if not gsFieldLocate(Fields,st,LastFieldCk) then
      LastFieldCk := 0;
   gsFieldNo := LastFieldCk;
end;

Function GSO_dBaseFld.gsFieldPull(fr: GSP_DBFField; fp: GSptrCharArray) : gsUTFString;
var
   s: AnsiString;
   siz: word;
begin
   with fr^ do
   begin
      siz := dbFieldLgth;
      if dbFieldType = 'C' then
         siz := siz + (dbFieldDec * 256);
      SetLength(s,siz);
      move(fp^[dbFieldOffset],s[1],siz);
      gsFieldPull := s;
   end;
end;

Procedure GSO_dBaseFld.gsFieldPush(fr: GSP_DBFField; const st : gsUTFString;
                                 fp: GSptrCharArray);
var
   len: integer;
   siz: integer;
begin
   len := length(st);
   with fr^ do
   begin
      siz := dbFieldLgth;
      {$IFDEF WIN32}
      if dbFieldType = 'C' then
         siz := siz + (dbFieldDec * 256);
      {$ENDIF}
      FillChar(fp^[dbFieldOffset],siz,#32);
      if len > 0 then
      begin
         if len > siz then len := siz;
         if dbFieldType in ['C','L','D'] then
            move(st[1],fp^[dbFieldOffset],len)
         else
            move(st[1],fp^[dbFieldOffset+(siz-len)],len);
      end;
      CurRecChg^[Fr^.dbFieldNum] := 1;
   end;
   RecModified := true;
{   gsDBFEvent(dbFieldChange,fr^.dbFieldNum);}
end;

function GSO_dBaseFld.gsFieldPut(const fnam, st : gsUTFString): boolean;
begin
   FieldPtr := gsAnalyzeField(fnam);
   if (FieldPtr <> nil)  then
   begin
      gsFieldPush(FieldPtr,st, CurRecord);
      gsFieldPut := true;
   end
   else
      gsFieldPut := false;
end;

function GSO_dBaseFld.gsFieldPutN(fnum : integer; const st : gsUTFString): boolean;
begin
   if (fnum > NumFields) or (fnum < 1) then
      gsFieldPutN := false
   else
   begin
      FieldPtr := @Fields^[fnum];
      gsFieldPush(FieldPtr,st, CurRecord);
      gsFieldPutN := true;
   end;
end;

function GSO_dBaseFld.gsFieldDecimals;  {(i : integer) : integer}
begin
   if (i > NumFields) or (i < 1) then
   begin
      gsFieldDecimals := 0;
      exit;
   end;
   FieldPtr := @Fields^[i];
   if not (FieldPtr^.dbFieldType = 'C') then
      gsFieldDecimals := FieldPtr^.dbFieldDec
   else
      gsFieldDecimals := 0;
end;

function GSO_dBaseFld.gsFieldLength(i : integer) : integer;
var
   siz: integer;
begin
   if (i > NumFields) or (i < 1) then
   begin
      gsFieldLength := 0;
      exit;
   end;
   FieldPtr := @Fields^[i];
   siz := FieldPtr^.dbFieldLgth;
   {$IFDEF WIN32}
   if FieldPtr^.dbFieldType = 'C' then
         siz := siz + (FieldPtr^.dbFieldDec * 256);
   {$ENDIF}
   gsFieldLength := siz;
end;

function GSO_dBaseFld.gsFieldName(i : integer) : gsUTFString;
begin
   if (i > NumFields) or (i < 1) then
   begin
      gsFieldName := '';
      exit;
   end;
   FieldPtr := @Fields^[i];
   gsFieldName := StrPas(FieldPtr^.dbFieldName);
end;

function GSO_dBaseFld.gsFieldType;  {(i : integer) : char}
begin
   if (i > NumFields) or (i < 1) then
   begin
      gsFieldType := #0;
      exit;
   end;
   FieldPtr := @Fields^[i];
   gsFieldType := FieldPtr^.dbFieldType;
end;

function GSO_dBaseFld.gsFieldOffset;  {(i : integer) : integer}
begin
   if (i > NumFields) or (i < 1) then
   begin
      gsFieldOffset := 0;
      exit;
   end;
   FieldPtr := @Fields^[i];
   gsFieldOffset := FieldPtr^.dbFieldOffset;
end;

Procedure GSO_dBaseFld.gsGetRec(RecNum : LongInt);
begin
   inherited gsGetRec(RecNum);
   gsClearFldChanged;           {Clear changed flag for all fields}
end;

function  GSO_dBaseFld.gsLogicGet(const st : gsUTFString) : boolean;
begin
   FieldPtr := gsCheckField(st,'L');
   if (FieldPtr <> nil) then
      gsLogicGet := gsLogicGetN(FieldPtr^.dbFieldNum)
   else
      gsLogicGet := false;
end;

function  GSO_dBaseFld.gsLogicGetN;  {(n : integer) : boolean}
var
   v : boolean;
begin
   if (n > NumFields) or (n < 1) then v := false
   else
   begin
      FieldPtr := @Fields^[n];
      v := pos(gsFieldPull(FieldPtr, CurRecord), LogicalTrue) > 0;
   end;
   gsLogicGetN := v;
end;

function GSO_dBaseFld.gsLogicPut(const st : gsUTFString; b : boolean): boolean;
begin
   FieldPtr := gsCheckField(st,'L');
   if (FieldPtr <> nil)  then
      gsLogicPut := gsLogicPutN(FieldPtr^.dbFieldNum, b)
   else
      gsLogicPut := false;
end;

function GSO_dBaseFld.gsLogicPutN;  {(n : integer; b : boolean)}
var
   fn: gsUTFString;
begin
   if (n > NumFields) or (n < 1) then
      gsLogicPutN := false
   else
   begin
      FieldPtr := @Fields^[n];
      if FieldPtr^.dbFieldType = 'L' then
      begin
         if b then
            gsFieldPush(FieldPtr, 'T', CurRecord)
         else
            gsFieldPush(FieldPtr, 'F', CurRecord);
         gsLogicPutN := true;
      end
      else
      begin
         fn :=  StrPas(FieldPtr^.dbFieldName);
         raise EHalcyonError.CreateFmt(gsErrFieldInput,['Logical',fn]);
         gsLogicPutN := false;
      end;
   end;
end;

Function GSO_dBaseFld.gsMemoFieldCheck(n: integer): GSobjMemo;
begin
   if (n > NumFields) or (n < 1) or
      (not (Fields^[n].dbFieldType in ['M','G','B'])) then gsMemoFieldCheck := nil
   else
   begin
      if MemoObject = nil then
         MemoObject := gsMemoObject;
      gsMemoFieldCheck := MemoObject;
   end;
end;

Function GSO_dBaseFld.gsMemoFieldNumber(const st: gsUTFString): integer;
var
   i: integer;
begin
   FieldPtr := gsCheckField(st,'G');
   if (FieldPtr <> nil) then
   begin
      i := FieldPtr^.dbFieldNum;
      gsMemoFieldNumber := i;
      if MemoObject = nil then
         MemoObject := gsMemoObject;
   end
   else
      gsMemoFieldNumber := 0;
end;

Function GSO_dBaseFld.gsMemoSize(const fnam: gsUTFString): longint;
begin
   gsMemoSize := gsMemoSizeN(gsMemoFieldNumber(fnam));
end;

Function GSO_dBaseFld.gsMemoSizeN(fnum: integer): longint;
var
   m : GSobjMemo;
   blk: longint;
begin
   m := gsMemoFieldCheck(fnum);
   if m <> nil then
   begin
      blk := trunc(gsNumberGetN(fnum));
      gsMemoSizeN := m.moMemoSize(blk);
   end
   else
      gsMemoSizeN := 0;
end;

Function GSO_dBaseFld.gsMemoLoad(const fnam: gsUTFString;buf: pointer;
                           var cb: longint): boolean;
begin
   gsMemoLoad := gsMemoLoadN(gsMemoFieldNumber(fnam),buf,cb);
end;

Function GSO_dBaseFld.gsMemoSave(const fnam: gsUTFString;buf: pointer;
                           var cb: longint): longint;
begin
   gsMemoSave := gsMemoSaveN(gsMemoFieldNumber(fnam),buf,cb);
end;

Function GSO_dBaseFld.gsMemoLoadN(fnum: integer;buf: pointer;
                            var cb: longint): boolean;
var
   m : GSobjMemo;
   i: longint;
   f: FloatNum;
begin
   m := gsMemoFieldCheck(fnum);
   if m <> nil then
   begin
      f := gsNumberGetN(fnum);
      i := trunc(f);
      m.moMemoRead(buf,i,cb);
      gsMemoLoadN := true;
   end
   else
      gsMemoLoadN := false;
end;

Function GSO_dBaseFld.gsMemoSaveN(fnum: integer;buf: pointer;
                            var cb: longint): longint;
var
   m : GSobjMemo;
   f: FloatNum;
   i: longint;
begin
   m := gsMemoFieldCheck(fnum);
   if m <> nil then
   begin
      f := gsNumberGetN(fnum);
      i := trunc(f);
      gsMemoSaveN := m.moMemoWrite(buf,i,cb);
      f := i;
      if cb = 0 then f := 0;
      gsNumberPutN(fnum, f);
   end
   else
      gsMemoSaveN := 0;
end;

function GSO_dBaseFld.gsNumberGet(const st : gsUTFString) : Extended;
begin
   FieldPtr := gsCheckField(st,'N');
   if (FieldPtr <> nil) then
      gsNumberGet := gsNumberGetN(FieldPtr^.dbFieldNum)
   else
      gsNumberGet := 0.0;
end;

function  GSO_dBaseFld.gsNumberGetN(n : integer) : Extended;
var
   v : FloatNum;
   li: longint;
   r : integer;
   s : gsUTFString;
   ep: gsUTFString;
   cp: Comp;
begin
   if (n > NumFields) or (n < 1) then v := 0.0
   else
   begin
      FieldPtr := @Fields^[n];
      if (FileVers = VFP3File) and
         (FieldPtr^.dbFieldType in ['Y','T','B','I','M','G']) then
      begin
         case FieldPtr^.dbFieldType of
            'I',
            'M',
            'G'  : begin
                      Move(CurRecord^[FieldPtr^.dbFieldOffset],li,SizeOf(Longint));
                      if li = $20202020 then
                         v := 0
                      else
                         v := li;
                   end;
            'B'  : begin
                      Move(CurRecord^[FieldPtr^.dbFieldOffset],v,8);
                   end;
            'T'  : begin
                      Move(CurRecord^[FieldPtr^.dbFieldOffset],cp,8);
                      if (cp = 0) then
                      begin
                         v := 0;
                      end
                      else
                      begin
                         Move(CurRecord^[FieldPtr^.dbFieldOffset],li,SizeOf(Longint));
                         v := li - GSTimeStampDiff;
                         v := v * GSMSecsInDay;
                         Move(CurRecord^[FieldPtr^.dbFieldOffset+SizeOf(Longint)],li,SizeOf(Longint));
                         v := v+li;
                      end;
                   end;
            'Y'  : begin
                      Move(CurRecord^[FieldPtr^.dbFieldOffset],cp,8);
                      v := cp;
                      v := v/10000;
                   end;
         end;
      end
      else
      begin
         s := TrimRight(gsFieldPull(FieldPtr, CurRecord));
         if length(s) = 0 then
            v := 0.0
         else
         begin
            val(s,v,r);
            if r <> 0 then
            begin
               ep := ExtractFileNameOnly(FileName)+'->';
               ep := ep + StrPas(FieldPtr^.dbFieldName);
               ep := ep + ' ('+s+')';
               raise EHalcyonError.CreateFmt(gsErrFieldNumber,[ep]);
               v := 0;
            end;
         end;
      end;
   end;
   gsNumberGetN := v;
end;

function GSO_dBaseFld.gsNumberPut(const st : gsUTFString; r : Extended): boolean;
begin
   FieldPtr := gsCheckField(st,'N');
   if (FieldPtr <> nil)  then
      gsNumberPut := gsNumberPutN(FieldPtr^.dbFieldNum, r)
   else
      gsNumberPut := false;
end;

function GSO_dBaseFld.gsNumberPutN(n : integer; r : Extended): boolean;
var
   s: gsUTFString;
   m: boolean;
   li: longint;
   z: FloatNum;
   cp: Comp;
begin
   if (n > NumFields) or (n < 1) then
      gsNumberPutN := false
   else
   begin
      FieldPtr := @Fields^[n];
      m := FieldPtr^.dbFieldType in ['N','M','F','B','G'];
      if (not m) and (FileVers = VFP3File) then
         m := FieldPtr^.dbFieldType in ['B','I','T','Y'];
      if m then
      begin
         if (FileVers = VFP3File) and
            (FieldPtr^.dbFieldType in ['Y','T','B','I','M','G']) then
         begin
            case FieldPtr^.dbFieldType of
               'I',
               'M',
               'G'  : begin
                         li := trunc(r);
                         Move(li,CurRecord^[FieldPtr^.dbFieldOffset],SizeOf(Longint));
                      end;
               'B'  : begin
                         Move(r,CurRecord^[FieldPtr^.dbFieldOffset],8);
                      end;
               'T'  : begin
                         if r = 0 then
                         begin
                            cp := 0;
                            Move(cp,CurRecord^[FieldPtr^.dbFieldOffset],8);
                         end
                         else
                         begin
                            z := r / GSMSecsInDay;
                            li := trunc(z);
                            z := li;
                            li := li + GSTimeStampDiff;
                            Move(li,CurRecord^[FieldPtr^.dbFieldOffset],SizeOf(Longint));
                            li := trunc(r - (z * GSMSecsInDay));
                            Move(li,CurRecord^[FieldPtr^.dbFieldOffset+SizeOf(Longint)],SizeOf(Longint));
                         end;
                      end;
               'Y'  : begin
                         cp := r*10000;
                         Move(cp,CurRecord^[FieldPtr^.dbFieldOffset],8);
                      end;
            end;
            CurRecChg^[FieldPtr^.dbFieldNum] := 1;
            gsNumberPutN := true;
         end
         else
         begin
            Str(r:FieldPtr^.dbFieldLgth:FieldPtr^.dbFieldDec,s);
            if length(s) > FieldPtr^.dbFieldLgth then
            begin
               s := StrPas(FieldPtr^.dbFieldName) + ' - ' + s;  {!!RFG 032598}
               raise EHalcyonError.CreateFmt(gsErrNumberTooBig,[s]);
               gsNumberPutN := false;
            end
            else
            begin
               gsFieldPush(FieldPtr, s, CurRecord);
               gsNumberPutN := true;
            end;
         end;
      end
      else
      begin
         raise EHalcyonError.CreateFmt(gsErrFieldType,[Strpas(FieldPtr^.dbFieldName)]);
         gsNumberPutN := false;
      end;
   end;
end;

Function GSO_dBaseFld.gsStringGet(const fnam : gsUTFString): gsUTFString;
var
   Fldnum: integer;
   FST: gsUTFString;
begin
   if gsFieldLocate(Fields,fnam,Fldnum) then
      gsStringGet := gsStringGetN(FldNum)
   else
   begin
      gsStringGet := '';
      FST := FileName+'->'+fnam;
      raise EHalcyonError.CreateFmt(gsErrFieldName,[FST]);
   end;
end;

Function GSO_dBaseFld.gsStringGetN(fnum : integer) : gsUTFString;
var
   s : gsUTFString;
   cb: integer;
   d : longint;
begin
   if (fnum > NumFields) or (fnum < 1) then
   begin
      gsStringGetN := '';
      exit;
   end;
   FieldPtr := @Fields^[fnum];
   with FieldPtr^ do
   begin
      s := gsFieldPull(FieldPtr, CurRecord);
      s := TrimRight(s);
      case dbFieldType of
         'D' : begin
                  d := DBFDate.CTOD(s);
                  s := TrimRight(DBFDate.DTOC(d));
               end;
         'L' : begin
                  if pos(s,LogicalTrue) > 0 then
                     s := 'T'
                  else
                     s := 'F';
               end;
         'M' : begin
                  cb := gsMemoSizeN(fnum);
                  SetLength(s,cb+1);
                  gsMemoLoadN(fnum,PChar(s),cb);
                  Delete(s,length(s),1);
               end;
         'G' : begin
                  s := TrimLeft(s);
                  if s > '0' then  s := '-GENERAL--' else s := '-general--';
               end;
         'B' : begin
                  s := TrimLeft(s);
                  if s > '0' then  s := '--BINARY--' else s := '--binary--';
               end;
         'F',
         'N' : begin
                  s := TrimLeft(s);
                  if length(s) = 0 then
                  begin
                     Str(0.0:FieldPtr^.dbFieldLgth:FieldPtr^.dbFieldDec,s);
                     s := TrimLeft(s);
                  end;
               end;
      end;
   end;
   gsStringGetN := s;
end;

function GSO_dBaseFld.gsStringPut(const fnam, st : gsUTFString): boolean;
begin
   FieldPtr := gsAnalyzeField(fnam);
   if (FieldPtr <> nil) then
      gsStringPut := gsStringPutN(FieldPtr^.dbFieldNum, st)
   else
      gsStringPut := false;
end;

function GSO_dBaseFld.gsStringPutN(fnum : integer; const st : gsUTFString): boolean;
var
   v : FloatNum;
   r : integer;
   b : boolean;
   s : gsUTFString;
   s1: gsUTFString;
   cb: integer;
begin
   if (fnum > NumFields) or (fnum < 1) then
      gsStringPutN := false
   else
   begin
      FieldPtr := @Fields^[fnum];
      s1 := StrPas(FieldPtr^.dbFieldName);
      case FieldPtr^.dbFieldType of
         'L' : begin
                  if length(st) > 0 then
                     s := copy(st,1,1)
                  else
                     s := 'F';
                  b := pos(s,LogicalTrue) > 0;
                  if not b then
                  begin
                     if pos(s,LogicalFalse) = 0 then
                     begin
                        val(st,v,r);
                        if r <> 0 then
                        begin
                           raise EHalcyonError.CreateFmt(gsErrFieldInput,['Logical',s1]);
                           gsStringPutN := false;
                           exit;
                        end;
                        r := trunc(v);
                        b := r <> 0;
                     end;
                  end;
                  gsStringPutN := gsLogicPutN(fnum, b);
               end;
         'D' : gsStringPutN := gsDatePutN(fnum,DBFDate.CTOD(st));
         'N' : begin
                  s := TrimRight(st);
                  if length(s) = 0 then
                     v := 0.0
                  else
                  begin
                     val(s,v,r);
                     if (r <> 0) then
                     begin
                        raise EHalcyonError.CreateFmt(gsErrFieldInput,['Number',s1]);
                        gsStringPutN := false;
                        exit;
                     end;
                  end;
                  gsStringPutN := gsNumberPutN(fnum, v);
               end;
         'M' : begin
                  cb := length(st);
                  gsMemoSaveN(fnum,PChar(st),cb);
                  gsStringPutN := true;
               end;
      else
         gsFieldPush(FieldPtr,st,CurRecord);
         gsStringPutN := true;
      end;
   end;
end;

Procedure GSO_dBaseFld.gsStuffABuffer(Buffer: PChar; const KeyFields: gsUTFString; const KeyValues: Variant);
var
   Psn: integer;
   Ctr: integer;
   cf: gsUTFString;
   cv: gsUTFString;
   tsl: TStringList;
begin
   CurRecord := pointer(Buffer);
   gsBlank;
   if length(KeyFields) > 0 then
   begin
      tsl := TStringList.Create;
      Psn := 1;
      while Psn < length(KeyFields) do
      begin
         cf := gsExtractFieldName(KeyFields,Psn);
         tsl.Add(cf);
      end;
      if (VarType(KeyValues) and varArray) = 0 then
      begin
         if KeyValues <> Null then
            cv := KeyValues
         else
            cv := '';
         gsStringPut(tsl[0],cv);
      end
      else
      begin
         for Ctr := 0 to tsl.Count-1 do
         begin
            if KeyValues[Ctr] <> Null then
               cv := KeyValues[Ctr]
            else
               cv := '';
            gsStringPut(tsl[Ctr],cv);
         end;
      end;
      tsl.Free;
   end;
   CurRecord := CurRecHold;
end;

Procedure GSO_dBaseFld.gsUnDelete;
begin
   if CurRecord^[0] = GS_dBase_UnDltChr then exit;
   CurRecord^[0] := GS_dBase_UnDltChr;  {Put ' ' in first byte of current record}
   CurRecChg^[0] := 1;
   RecModified := true;
   gsPutRec(RecNumber);             {Write the current record to disk }
end;


{-----------------------------------------------------------------------------
                              TgsDBFFields
-----------------------------------------------------------------------------}

constructor TgsDBFFields.Create(ADataTable: GSO_dBaseFld; const AFieldName: gsUTFString;
                 AFieldType: gsUTFChar; AFieldLen, AFieldDec, AFieldNo, AOffset: integer;
                 AFieldVar: TgsUserDefFieldVar);
begin
   inherited Create;
   DataTable := ADataTable;
   FFieldName := AFieldName;
   FFieldType := AFieldType;
   FFieldLen := AFieldLen;
   FFieldDec := AFieldDec;
   FFieldNo := AFieldNo;
   FFieldOffset := AOffSet;
   FFieldVar := AFieldVar;
end;

destructor TgsDBFFields.Destroy;
begin
   FFieldVar.Free;
   inherited Destroy;
end;

function TgsDBFFields.FieldDescriptor: gsUTFString;
begin
   Result := FFieldName+';'+FFieldType+';'+IntToStr(FFieldLen)+';'+IntToStr(FFieldDec);
end;

procedure TgsDBFFields.SetValue(Value: variant);
begin
end;

function TgsDBFFields.GetValue: variant;
begin
   Result := null;
end;


{-----------------------------------------------------------------------------
                              GSO_DBFBuild
-----------------------------------------------------------------------------}

Constructor GSO_DBFBuild.Create(const FName: gsUTFString);
const
   ext : gsUTFString = '.DBF';
begin
   inherited Create;
   hasMemo := false;
   dbTypeNoMo := DB3File;
   dbTypeMemo := DB3WithMemo;
   FileName := Trim(FName);
   FileName := ChangeFileExtEmpty(FileName,ext);
   dbRecLen := 1;
   dbTitle := ExtractFileNameOnly(FileName);
   GoodToGo := true;
   dFile := nil;
end;

Destructor GSO_DBFBuild.Destroy;
begin
   if dFile = nil then Complete;
   if dFile <> nil then
      dFile.Free;
   inherited Destroy;
end;

procedure GSO_DBFBuild.Complete;
begin
   if GoodToGo then
   begin
      dFile := nil;
      dFile := GSO_DiskFile.Create(FileName,true,false);
      if (dFile = nil) then exit;
      dFile.gsRewrite;
      WriteDBF;
      if HasMemo then WriteDBT;
   end;
end;

procedure GSO_DBFBuild.FreeItem;  {(Item: Pointer)}
begin
  if Item <> nil then
  begin
     FreeMem(Item, SizeOf(GSR_DBFField));
  end;
end;


procedure GSO_DBFBuild.InsertField(const s : gsUTFString; t : char; l,d : integer);
var
   f : GSP_DBFField;
   j : integer;
   s1: gsUTFString;
begin
   j := length(s);
   if j = 0 then exit;
   s1 := gsStrUpperCase(s);
   if j > 10 then System.Delete(s1,11,j-10);
   GetMem(f, SizeOf(GSR_DBFField));
   FillChar(f^, SizeOf(GSR_DBFField), #0);
   System.Move(s1[1],f^.dbFieldName,j);
   s1 := gsStrUpperCase(t);
   f^.dbFieldType := s1[1];
   case f^.dbFieldType of
      'D' : begin
               l := 8;
               d := 0;
            end;
      'L' : begin
               l := 1;
               d := 0;
            end;
      'B',
      'G',
      'M' : begin
               l := 10;
               d := 0;
               hasMemo := true;
            end;
      'C' : begin
               d := l div 256;
               l := l mod 256;
            end;
   end;
   f^.dbFieldLgth := l;
   f^.dbFieldDec := d;
   f^.dbFieldOffset := 0;
   f^.dbFieldNum := 0;
   if f^.dbFieldType = 'M' then hasMemo := true;
   dbRecLen := dbRecLen + l;
   if f^.dbFieldType = 'C' then
      dbRecLen := dbRecLen + (d * 256);
   Add(f);
end;

Procedure GSO_DBFBuild.WriteDBF;
var
   i : integer;
   yy, mm, dd : word;             {Variables to hold GetDate values}
   eofm: char;
   eohm: char;
BEGIN
   eofm := EOFMark;
   eohm := EOHMark;
   if hasMemo then HeadRec.DBType := dbTypeMemo
      else HeadRec.DBType := dbTypeNoMo;
   DecodeDate(Date,yy,mm,dd);
   HeadRec.year := yy mod 100; {Year}
   HeadRec.month := mm; {Month}
   HeadRec.day := dd; {Day}
   HeadRec.RecordCount := 0;
   HeadRec.Location := (Count*32) + 33;
   HeadRec.RecordLen := dbRecLen;
   FillChar(HeadRec.Reserve1,20,#0);
   dFile.gsWrite(0, HeadRec, 32);
   i := 1;
   while i <= Count do
   begin
      dFile.gsWrite(i*32, Items[i-1]^, 32);
      inc(i);
   end;
   dFile.gsWrite(i*32, eohm, 1);            {Put EOH marker }
   dFile.gsWrite((i*32)+1, eofm, 1);            {Put EOF marker }
END;

Procedure GSO_DBFBuild.WriteDBT;
var
   buf : array[0..512] of byte;
begin
   FillChar(buf,512,#0);
   buf[0] := $01;
   System.Move(dbTitle[1],buf[8],length(dbTitle));
   FileName := ChangeFileExt(FileName,'.DBT');
   mFile := GSO_DiskFile.Create(FileName,true,false);
   buf[512] := byte(EOFMark);
   mFile.gsRewrite;
   mFile.gsWrite(0, buf, SizeOf(buf));
   mFile.Free;
end;

{-----------------------------------------------------------------------------
                                GSO_DB4Build
-----------------------------------------------------------------------------}

Constructor GSO_DB4Build.Create(const FName: gsUTFString);
begin
   inherited Create(FName);
   dbTypeNoMo := DB4File;
   dbTypeMemo := DB4WithMemo;
end;

Procedure GSO_DB4Build.WriteDBT;
var
   buf : array[0..31] of byte;
begin
   FillChar(buf,32,#0);
   buf[0] := $01;
   System.Move(dbTitle[1],buf[8],length(dbTitle));
   buf[18] := $02;
   buf[19] := $01;
   buf[21] := $02;
   FileName := ChangeFileExt(FileName,'.DBT');
   mFile := GSO_DiskFile.Create(FileName,true,false);
   mFile.gsRewrite;
   mFile.gsWrite(0, buf, 24);
   mFile.Free;
end;

{-----------------------------------------------------------------------------
                                GSO_DBFoxBuild
-----------------------------------------------------------------------------}

Constructor GSO_DBFoxBuild.Create(const FName: gsUTFString);
begin
   inherited Create(FName);
   dbTypeNoMo := DB3File;
   dbTypeMemo := FXPWithMemo;
end;

Procedure GSO_DBFoxBuild.WriteDBT;
var
   buf : array[0..511] of byte;
   ib   : word;
begin
   ib := 512 div FoxMemoSize;
   if (512 mod FoxMemoSize) <> 0 then inc(ib);
   FillChar(buf,512,#0);
   buf[2] := Hi(ib);
   buf[3] := Lo(ib);
   buf[6] := Hi(FoxMemoSize);
   buf[7] := Lo(FoxMemoSize);
   FileName := ChangeFileExt(FileName,'.fpt');
   mFile := GSO_DiskFile.Create(FileName,true,false);
   mFile.gsRewrite;
   mFile.gsWrite(0, buf, 512);
   if (512 mod FoxMemoSize) <> 0 then
   begin
      FillChar(buf,512,#0);
      mFile.gsWrite(512, buf, 512 mod FoxMemoSize); {!!RFG 022798}
   end;
   mFile.Free;
end;



end.

