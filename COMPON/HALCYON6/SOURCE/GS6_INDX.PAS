unit gs6_indx;
{-----------------------------------------------------------------------------
                          Basic Index File Routine

       gs6_indx Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          4 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the base objects to manage database index
       files.

   Changes:
------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_DBF,
   gs6_date,
   gs6_sql,
   gs6_disk,
   gs6_cnst,
   gs6_glbl,
   gs6_sort,
   gs6_lcal,
   gs6_tool;

{private}

type

   GSsetPageType = (Unknown, Root, Node, Leaf, RootLeaf);

   GSobjIndexKey = class;
   GSobjIndexTag = class;
   GSobjIndexFile = class;

   GSobjIndexKeyData = class(TgsVariant)
      Xtra: longint;
      Tag: longint;
      constructor Create(Size: word);
      function AssignLinks(AGSptrLinks: GSobjIndexKeyData): boolean;
      function CloneLinks: GSobjIndexKeyData;
   end;

   GSobjIndexKey = class(TgsCollection)
      Page       : longint;
      Left       : longint;
      Right      : longint;
      Owner      : GSobjIndexKey;
      Child      : GSobjIndexKey;
      TagParent  : GSobjIndexTag;
      PageType   : GSsetPageType;
      CurKey     : integer;
      Changed    : boolean;
      NewRoot    : boolean;
      LastEntry  : boolean;
      Reload     : boolean;
      Space      : word;
      RNMask     : longint;
      DCMask     : byte;
      TCMask     : byte;
      RNBits     : byte;
      DCBits     : byte;
      TCBits     : byte;
      ReqByte    : byte;
      ChkBOF     : boolean;          {!!RFG 082097}
      ChkEOF     : boolean;          {!!RFG 082097}

      constructor Create(PIT: GSobjIndexTag; PIK: GSobjIndexKey;
                       FilePosn: longint);
      destructor  Destroy; override;
      procedure   AddNodeKey(Key: GSobjIndexKeyData);
      procedure   DeleteKey;
      procedure   DeleteNodeKey;
      function    GetChild(Tag: longint): boolean;
      procedure   InsertKey(Key: GSobjIndexKeyData; AddAfter: boolean);
      function    PageLoad: boolean;
      function    PageStore: boolean;
      function    ReadBottomKey: boolean;
      function    ReadCurrentKey: boolean;
      function    ReadNextKey: boolean;
      function    ReadPreviousKey: boolean;
      function    ReadTopKey: boolean;
  (*    function    ReadPercent(APct: integer) : LongInt;*)
      procedure   ReplaceNodeKey(Key: GSobjIndexKeyData);
      function    RetrieveKey(Key: GSobjIndexKeyData): integer;
      function    SeekKey(Tag: longint; Key: GSobjIndexKeyData; IfPartial: integer): integer;
      function    SeekNodeTag(Tag: longint): integer;
   end;

   GSobjIndexTag = class(TObject)
      TagSig     : gsUTFString;
      TagName    : gsUTFString;
      KeyExpr    : gsUTFString;
      KeyLength  : SmallInt;
      DefaultLen : SmallInt;
      EntryLength: Word;
      MaxKeys    : Word;
      MinKeys    : Word;
      ForExpr    : gsUTFString;
      RangeLo    : GSobjIndexKeyData;
      RangeHi    : GSobjIndexKeyData;
      RangeExtent: integer;
      LoInRange  : boolean;
      HiInRange  : boolean;
      Owner      : GSobjIndexFile;
      TagBlock   : longint;
      RootBlock  : longint;
      RootPage   : GSobjIndexKey;
      TagChanged : boolean;
      AscendKey  : boolean;
      UniqueKey  : boolean;
      Conditional: boolean;
      KeyType    : char;
      CurKeyInfo : GSobjIndexKeyData;
      TagBOF     : boolean;
      TagEOF     : boolean;
      KeyUpdated : boolean;    {set for update via KeyUpdate}
      InvertCmpr : boolean;
      InvertRead : boolean;
      TagUpdating: boolean;
      ExprHandlr : TgsExpHandler;
      FltrHandlr : TgsExpHandler;

      constructor Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
      destructor  Destroy; override;
      procedure   AdjustValue(AKey: TgsVariant; DoTrim: boolean); virtual;
      function    HuntDuplicate(Key: GSobjIndexKeyData): longint;
      function    IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                           boolean; virtual;
      function    KeyAdd(Key: GSobjIndexKeyData): boolean; virtual;
      function    KeyByPercent(APct: integer) : LongInt;
      function    KeyFind(Key: GSobjIndexKeyData) : longint;
      function    KeyInRange: integer;
      function    KeyIsAscending: boolean;
      function    KeyIsPercentile: integer;
      function    KeyIsUnique: boolean;
      function    KeySync(ATag: longint): longint;
      function    KeyRead(TypRead: longint) : longint;
      function    KeyUpdate(AKey: longint; IsAppend: boolean): boolean;
      procedure   GetRange(var RLo, RHi: TgsVariant);
      function    GetRangeCount: longint;
      function    NewRoot: longint; virtual;
      function    SetRange(RLo: TgsVariant; LoIn: Boolean;
                           RHi: TgsVariant; HiIn: Boolean; Partial: boolean): boolean;
      function    GetRangeActive: boolean;
      procedure   SetRoot(PIK: GSobjIndexKey);
      function    PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean; virtual;
      function    PageStore(PIK: GSobjIndexKey): Boolean; virtual;
      function    TagLoad: Boolean; virtual;
      function    TagStore: Boolean; virtual;
      procedure   TagClose;
      procedure   TagOpen(Posn: integer); {0=top, 1=current}
      function    GetIndexExpression: gsUTFString;
      procedure   PostTagExpression; virtual;
      procedure   PostTagFilter; virtual;
      function    SolveExpression(AVar: TgsVariant; var Chg: boolean): boolean; virtual;
      function    SolveFilter: boolean; virtual;
      property    IndexExpression: gsUTFString read GetIndexExpression;
      property    RangeActive: boolean read GetRangeActive;
   end;

   GSobjIndexFile = class(TObject)
      IndexName   : gsUTFString;
      TagList     : TgsCollection;
      TagRoot     : longint;
      Owner       : GSO_dBaseFld;
      DiskFile    : GSO_DiskFile;
      KeyWithRec  : boolean;
      Dictionary  : boolean;
      NextAvail   : longint;
      Exact       : boolean;
      CreateOK    : boolean;
      Corrupted   : boolean;                 {!!RFG 091197}
      dfLockStyle    : GSsetLokProtocol;
      dfDirtyReadMax : gsuint32;
      dfDirtyReadLmt : gsuint32;
      dfDirtyReadMin : gsuint32;
      dfDirtyReadRng : gsuint32;

      constructor Create(PDB: GSO_dBaseFld);
      destructor  Destroy; override;
      function    IndexFileOpen(PDB: GSO_dBaseFld; const FN, EX: gsUTFString;
                   ReadWrite, Shared, Create, Overwrite: boolean): GSO_DiskFile;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                         boolean; virtual;
      function    DeleteTag(const ITN: gsUTFString): boolean; virtual;
      function    GetAvailPage: longint; virtual;
      function    ResetAvailPage: longint; virtual;
      function    IndexLock: boolean;
      function    IsFileName(const IName: gsUTFString): boolean;
      function    KeyByName(const AKey: gsUTFString; AFor: boolean): GSobjIndexTag;
      function    PageRead(Blok: longint; var Page; Size: integer):
                         boolean; virtual;
      function    PageWrite(Blok: longint; var Page; Size: integer):
                         boolean; virtual;
      procedure   Reindex; virtual;
      function    Rename(const NewName: gsUTFString): boolean ; virtual;
      function    GetFileName: string;
      function    TagCount: integer;
      function    TagByName(const ITN: gsUTFString): GSobjIndexTag;
      function    TagByNumber(N: integer): GSobjIndexTag;
      function    TagUpdate(AKey: longint; IsAppend: boolean): boolean; virtual;
      function    ExternalChange: boolean; virtual;          {!!RFG 091297}
      Procedure   ixSetLockProtocol(LokProtocol: GSsetLokProtocol); virtual;
      Procedure   ixEncrypt; virtual;
   end;

implementation

{----------------------------------------------------------------------------
                        GSobjIndexKeyData
----------------------------------------------------------------------------}

constructor GSobjIndexKeyData.Create(Size: word);
begin
   inherited Create(Size);
   Tag := 0;
   Xtra := 0;
end;

function GSobjIndexKeyData.AssignLinks(AGSptrLinks: GSobjIndexKeyData): boolean;
begin
   Assign(AGSptrLinks);
   Tag := AGSptrLinks.Tag;
   Xtra := AGSptrLinks.Xtra;
   AssignLinks := true;
end;

function GSobjIndexKeyData.CloneLinks: GSobjIndexKeyData;
var
   cl: GSobjIndexKeyData;
begin
   cl := GSobjIndexKeyData.Create(0);
   cl.AssignLinks(Self);
   CloneLinks := cl;
end;


{----------------------------------------------------------------------------
                        GSobjIndexKey
----------------------------------------------------------------------------}

Constructor GSobjIndexKey.Create(PIT: GSobjIndexTag; PIK: GSobjIndexKey;
                               FilePosn: longint);
begin
   inherited Create;
   Page := FilePosn;
   Left := -1;
   Right := -1;
   Owner := PIK;
   Child := nil;
   TagParent := PIT;
   PageType := Unknown;
   CurKey := -1;
   Changed := false;
   NewRoot := false;
   LastEntry := false;
   Reload := false;
   if Page > 0 then
      if not PageLoad then exit;
end;

destructor GSobjIndexKey.Destroy;
begin
   if Child <> nil then
      Child.Free;
   Child := nil;
   if Changed then PageStore;
   Changed := false;
   if NewRoot and (Owner <> nil) then
   begin
      Owner.Child := nil;
      Owner.Free;
      Owner := nil;
   end;
   NewRoot := false;
   if Owner <> nil then
      Owner.Child := nil;
   Owner := nil;
   inherited Destroy;
end;

procedure GSobjIndexKey.AddNodeKey(Key: GSobjIndexKeyData);
begin
   if Owner = nil then
   begin
      TagParent.SetRoot(Self);
      NewRoot := true;
   end;
   Owner.CurKey := Owner.SeekNodeTag(Page);
   Owner.Child := nil;
   Owner.InsertKey(Key, false);
   inc(Owner.CurKey);
   Owner.Child := Self;
   Reload := true;
end;

procedure GSobjIndexKey.DeleteKey;
var
   p: GSobjIndexKeyData;
   Lastone: boolean;
   TempTag: longint;
begin
   Changed := true;
   if Child <> nil then
      Child.DeleteKey
   else
   begin
      lastone := CurKey >= pred(Count);
      p := Items[CurKey];
      FreeOne(p);
      if (CurKey >= Count) then
         CurKey := pred(Count);
      if (CurKey < 0) then CurKey := 0;
      if lastone and (Owner <> nil) then
      begin
         if Count > 0 then
         begin
            p := Items[CurKey];
            TempTag := p.Tag;
            p.Tag := Page;
            ReplaceNodeKey(p);
            p.Tag := TempTag;
         end
         else
            DeleteNodeKey;
      end;
   end;
end;

procedure GSobjIndexKey.DeleteNodeKey;
var
   OldCurKey: integer;
begin
   if (Owner <> nil) then
   begin
      OldCurKey := Owner.CurKey;
      Owner.CurKey := Owner.SeekNodeTag(Page);
      if Owner.CurKey <> -1 then
      begin
         Owner.Child := nil;
         Owner.DeleteKey;
         Owner.Child := Self;
      end;
      Owner.CurKey := OldCurKey;
   end;
end;

function GSobjIndexKey.GetChild(Tag: longint): boolean;
begin
   if PageType < Leaf then
   begin
      if Child <> nil then
      begin
         if (Child.Page <> Tag) or (Child.Reload) then
         begin
            Child.Free;
            Child := nil;
         end;
      end;
      if Child = nil then
         Child := GSobjIndexKey.Create(TagParent,Self,Tag);
   end;
   GetChild := Child <> nil;
end;

procedure GSobjIndexKey.InsertKey(Key: GSobjIndexKeyData; AddAfter: boolean);
var
   p: GSobjIndexKeyData;
begin
   if Child <> nil then
      Child.InsertKey(Key, AddAfter)
   else
   begin
      p := Key.CloneLinks;
      if AddAfter then inc(CurKey);
      if CurKey > Count then CurKey := Count;
      if CurKey < 0 then CurKey := 0;
      if (Owner <> nil) and (CurKey >= Count) then
      begin
         p.Tag := Page;
         ReplaceNodeKey(p);
         p.Tag := Key.Tag;
      end;
      Insert(CurKey,p);
      Changed := true;
   end;
end;

function GSobjIndexKey.PageLoad: boolean;
begin
   FreeAll;
   PageLoad := TagParent.PageLoad(Page,Self);
   Changed := false;
end;

function GSobjIndexKey.PageStore: boolean;
begin
   if Page = 0 then
   begin
      Page := TagParent.Owner.GetAvailPage;
   end;
   PageStore := TagParent.PageStore(Self);
   Changed := false;
end;

function GSobjIndexKey.ReadBottomKey: boolean;
var
   p: GSobjIndexKeyData;
begin
   ReadBottomKey := false;
   if (Count = 0) then exit;
   CurKey := pred(Count);
   p := Items[CurKey];
   if PageType < Leaf then
   begin
      if GetChild(p.Tag) then
         ReadBottomKey := Child.ReadBottomKey;
   end
   else
   begin
      ReadBottomKey := true;
      TagParent.CurKeyInfo.Assign(p);
      TagParent.CurKeyInfo.Tag := p.Tag;
   end;
end;

function GSobjIndexKey.ReadCurrentKey: boolean;
var
   p: GSobjIndexKeyData;
begin
   ReadCurrentKey := false;
   if (Count = 0) or (CurKey >= Count) or (CurKey < 0) then exit;
   p := Items[CurKey];
   if PageType < Leaf then
   begin
      if GetChild(p.Tag) then
         ReadCurrentKey := Child.ReadCurrentKey;
   end
   else
   begin
      ReadCurrentKey := true;
      TagParent.CurKeyInfo.Assign(p);
      TagParent.CurKeyInfo.Tag := p.Tag;
   end;
end;

function GSobjIndexKey.ReadNextKey: boolean;
var
   p: GSobjIndexKeyData;
   b: boolean;
begin
   ReadNextKey := false;
   if (Count = 0) then exit;
   b := false;
   if PageType < Leaf then
   begin
      while (not b) and (CurKey < Count) do
      begin
         p := Items[CurKey];
         if GetChild(p.Tag) then
         begin
            if Child.CurKey = -1 then
            begin
               if Child.PageType < Leaf then
                  Child.CurKey := 0;
            end;
            b := Child.ReadNextKey;
         end
         else
            b := false;
         if (not b) then inc(CurKey);
      end;
      if (not b) then CurKey := pred(Count);
      ReadNextKey := b;
   end
   else
   begin
      inc(CurKey);
      if CurKey < Count then
      begin
         p := Items[CurKey];
         ReadNextKey := true;
         TagParent.CurKeyInfo.Assign(p);
         TagParent.CurKeyInfo.Tag := p.Tag;
      end
      else
      begin
         CurKey := Count;
         ReadNextKey := false;
      end;   
   end;
end;

function GSobjIndexKey.ReadPreviousKey: boolean;
var
   p: GSobjIndexKeyData;
   b: boolean;
begin
   ReadPreviousKey := false;
   if (Count = 0) then exit;
   b := false;
   if PageType < Leaf then
   begin
      if CurKey >= Count then exit;
      while (not b) and (CurKey >= 0) do
      begin
         p := Items[CurKey];
         if GetChild(p.Tag) then
         begin
            if Child.CurKey = -1 then
            begin
               Child.CurKey := Child.Count;
               if Child.PageType < Leaf then
                  dec(Child.CurKey);
            end;
            b := Child.ReadPreviousKey;
         end
         else
            b := false;
         if (not b) then dec(CurKey);
      end;
      if (not b) then CurKey := 0;
      ReadPreviousKey := b;
   end
   else
   begin
      dec(CurKey);
      if CurKey >= 0 then
      begin
         p := Items[CurKey];
         ReadPreviousKey := true;
         TagParent.CurKeyInfo.Assign(p);
         TagParent.CurKeyInfo.Tag := p.Tag;
      end
      else
      begin
         CurKey := -1;
         ReadPreviousKey := false;
      end;
   end;
end;

function GSobjIndexKey.ReadTopKey: boolean;
var
   p: GSobjIndexKeyData;
begin
   ReadTopKey := false;
   if (Count = 0) then exit;
   CurKey := 0;
   p := Items[CurKey];
   if PageType < Leaf then
   begin
      if GetChild(p.Tag) then
         ReadTopKey := Child.ReadTopKey;
   end
   else
   begin
      CurKey := 0;
      ReadTopKey := true;
      TagParent.CurKeyInfo.Assign(p);
      TagParent.CurKeyInfo.Tag := p.Tag;
   end;
end;

procedure GSobjIndexKey.ReplaceNodeKey(Key: GSobjIndexKeyData);
var
   lastone: boolean;
   OldCurKey: integer;
begin
   if (Owner <> nil) then
   begin
      OldCurKey := Owner.CurKey;
      Owner.CurKey := Owner.SeekNodeTag(Page);
      lastone := Owner.CurKey >= pred(Owner.Count);
      Owner.Child := nil;
      if Owner.CurKey <> -1 then
         Owner.DeleteKey
      else
      begin
         Owner.CurKey := pred(Owner.Count);
         lastone := true;
      end;
      Owner.InsertKey(Key, lastone);
      Owner.Child := Self;
      Owner.CurKey := OldCurKey;
   end;
end;


function GSobjIndexKey.RetrieveKey(Key: GSobjIndexKeyData): integer;
var
   p: GSobjIndexKeyData;
   rkey: integer;
begin
   if Owner = nil then      {!!RFG 082097}
   begin                    {If at root, initialize EOF/BOF flags}
      ChkBOF := true;
      ChkEOF := true;
   end
   else
   begin
      ChkBOF := Owner.ChkBOF;
      ChkEOF := Owner.ChkEOF;
   end;
   ChkBOF := ChkBOF and (CurKey = 0);  {Testing thru links for BOF}
   ChkEOF := ChkEOF and (CurKey = pred(Count)); {Testing for EOF}
   if Child <> nil then
      RetrieveKey := Child.RetrieveKey(Key)
   else
   begin
      p := Items[CurKey];
      Key.Assign(p);
      Key.Tag := p.Tag;
      rkey := 0;
      if ChkBOF then rkey := 1;           {!!RFG 082097}
      if ChkEOF then rkey := rkey + 2;    {!!RFG 082097}
      RetrieveKey := rkey;                {!!RFG 082097}
   end;
end;

function GSobjIndexKey.SeekKey(Tag: longint; Key: GSobjIndexKeyData;
                                IfPartial: integer): integer;
var
   k: integer;
   p: GSobjIndexKeyData;
   dav: longint;
begin
   k := 1;
   CurKey := 0;
   if Count > 0 then
   begin
      while (k > 0) and (CurKey < Count) do
      begin
         p := Items[CurKey];
         k := Key.Compare(p,dav,IfPartial, pCollateTable);
         if TagParent.InvertCmpr then k := -k;
         if (k = 0) and (Tag = MaxRecNum) then k := ValueHigh;
         if (k = 0) and (Tag <> IgnoreRecNum) then
         begin
            if GSobjIndexFile(TagParent.Owner).KeyWithRec then
            begin
               if Tag > p.Xtra then k := ValueHigh
               else
                  if Tag < p.Xtra then k := ValueLow;
            end;
         end;
         if (k <= 0) or (CurKey = pred(Count)) then
         begin
            if PageType < Leaf then
            begin
               GetChild(p.Tag);
               k := Child.SeekKey(Tag, Key, IfPartial);
            end
            else
               if (k = 0) and (Tag <> IgnoreRecNum) then
               begin
                  if GSobjIndexFile(TagParent.Owner).KeyWithRec then
                  begin
                     if Tag > p.Tag then k := ValueHigh
                        else
                           if Tag < p.Tag then k := ValueLow;
                  end
                  else
                     if Tag <> p.Tag then k := ValueHigh;
               end;
         end;
         if k > 0 then inc(CurKey);
      end;
   end;
   SeekKey := k;
end;

function GSobjIndexKey.SeekNodeTag(Tag: longint): integer;
var
   i: integer;
   p: GSobjIndexKeyData;
   FoundIt: integer;
begin
   FoundIt := -1;
   i := 0;
   if Count > 0 then
   begin
      while (FoundIt < 0) and (i < Count) do
      begin
         p := Items[i];
         if p.Tag = Tag then
            FoundIt := i;
         inc(i);
      end;
   end;
   SeekNodeTag := FoundIt;
end;

{----------------------------------------------------------------------------
                              GSobjIndexTag
----------------------------------------------------------------------------}

constructor GSobjIndexTag.Create(PIF: GSobjIndexFile; const ITN: gsUTFString;
                                                    TagHdr: longint);
begin
   inherited Create;
   TagSig := 'UNK';
   TagName := ITN;
   KeyExpr := '';
   ForExpr := '';
   KeyLength := 0;
   DefaultLen := 0;
   EntryLength := 0;
   MaxKeys := 0;
   MinKeys := 0;
   RangeLo := GSobjIndexKeyData.Create(0);
   RangeHi := GSobjIndexKeyData.Create(0);
   Owner:= PIF;
   TagBlock := TagHdr;
   TagChanged := false;
   RootBlock := 0;
   RootPage := nil;
   AscendKey := true;
   UniqueKey := false;
   InvertCmpr := false;
   InvertRead := false;
   Conditional := false;
   KeyType := 'C';
   CurKeyInfo := GSobjIndexKeyData.Create(0);
   TagBOF := false;
   TagEOF := false;
   KeyUpdated := false;
   TagUpdating := false;
   ExprHandlr := nil;
   FltrHandlr := nil;
end;

destructor GSobjIndexTag.Destroy;
begin
   if RootPage <> nil then
      RootPage.Free;
   RootPage := nil;
   if TagChanged then TagStore;
   RangeLo.Free;
   RangeHi.Free;
   if RootPage <> nil then
      RootPage.Free;
   RootPage := nil;
   CurKeyInfo.Free;
   FltrHandlr.Free;
   ExprHandlr.Free;
   inherited Destroy;
end;

procedure GSobjIndexTag.AdjustValue(AKey: TgsVariant; DoTrim: boolean);
begin
end;

function GSobjIndexTag.HuntDuplicate(Key: GSobjIndexKeyData): longint;
var
   RP: GSobjIndexKey;
   LK: GSobjIndexKeyData;
begin                                   {!!RFG 082097}
   Owner.Exact := true;
   RP := RootPage;
   RootPage := nil;
   LK := CurKeyInfo.CloneLinks;
   HuntDuplicate := KeyFind(Key);
   TagClose;
   RootPage := RP;
   CurKeyInfo.AssignLinks(LK);
end;

function GSobjIndexTag.IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                                boolean;
begin
   IndexTagNew := false;
   KeyExpr := KeyExp;
   ForExpr := ForExp;
   AscendKey := Ascnd;
   UniqueKey := Uniq;
   Conditional := (Length(ForExpr) > 0);
   PostTagExpression;
   PostTagFilter;
end;

procedure GSobjIndexTag.GetRange(var RLo, RHi: TgsVariant);
begin
   RLo.Assign(RangeLo);
   RHi.Assign(RangeHi);
end;

function GSobjIndexTag.GetRangeCount: longint;
var
   cky: GSobjIndexKeyData;
   rc: longint;
begin
      if (Conditional) or (RangeActive) then
      begin
         RootPage.RetrieveKey(CurKeyInfo);
         cky := CurKeyInfo.CloneLinks;
         rc := 0;
         KeyRead(Top_Record);
         while not TagEOF do
         begin
            KeyRead(Prev_Record);
            inc(rc);
         end;
         KeyFind(cky);
         RootPage.RetrieveKey(CurKeyInfo);
         cky.Free;
      end
      else
         rc := Owner.Owner.NumRecs;
   GetRangeCount := rc;
end;



function GSobjIndexTag.KeyAdd(Key: GSobjIndexKeyData): boolean;
var
   K : integer;
   fp: integer;
   stot: GSobjIndexKeyData;
   FRN: longint;
begin
   KeyAdd := false;
   if not TagUpdating then TagOpen(0);
   if (RootPage = nil) then exit;
   stot := Key.CloneLinks;
   AdjustValue(stot,true);
   TagBOF := false;
   TagEOF := false;                   {End-of-File initially set false}
   K := 1;
   if Owner.KeyWithRec then
      FRN := stot.Tag
   else
      if InvertCmpr then
         FRN := MinRecNum
      else
         FRN := MaxRecNum;
   if UniqueKey then
   begin
      K := RootPage.SeekKey(IgnoreRecNum, stot, MatchIsExact);
      FRN := stot.Tag;
   end;
   if K <> 0 then         {If unique and no match...}
   begin
      K := RootPage.SeekKey(FRN, stot, MatchIsExact);
      case K of
         ValueEqual,
         ValueLow : begin
                       RootPage.InsertKey(stot, false);
                       if not TagUpdating then TagOpen(0);
                       RootPage.SeekKey(FRN, stot, MatchIsExact);
                       if (FRN = MaxRecNum) then
                          RootPage.ReadPreviousKey;
                       fp := RootPage.RetrieveKey(CurKeyInfo);
                       if InvertRead then             {Descending index}
                       begin
                          TagEOF := (fp and 1) > 0;   {!!RFG 082097}
                          TagBOF := (fp and 2) > 0;   {!!RFG 082097}
                       end
                       else
                       begin
                          TagBOF := (fp and 1) > 0;   {!!RFG 082097}
                          TagEOF := (fp and 2) > 0;   {!!RFG 082097}
                       end;
                       KeyAdd := True;
                    end;
         ValueHigh: begin;
                       if InvertRead then
                          KeyRead(Top_Record)
                       else
                          KeyRead(Bttm_Record);
                       RootPage.InsertKey(stot, true);    {!RFG 080297}
                       if not TagUpdating then TagOpen(0);
                       if InvertRead then
                       begin
                          KeyRead(Top_Record);
                          TagBOF := true;
                       end
                       else
                       begin
                          KeyRead(Bttm_Record);  {get new bottom record}
                          TagEOF := true;
                       end;
                       KeyAdd := True;
                    end;
      end;
   end;
   stot.Free;
end;

function GSobjIndexTag.KeyFind(Key: GSobjIndexKeyData) : longint;
var
   K: integer;
   stot: GSobjIndexKeyData;
   ip: integer;
   rk: integer;
begin
   if Owner.Owner <> nil then
      Owner.Exact := Owner.Owner.gsvExactMatch;
   KeyFind := 0;
   CurKeyInfo.Tag := 0;
   TagOpen(0);
   if (RootPage = nil) then exit;
   stot := Key.CloneLinks;
   AdjustValue(stot,true);
   TagBOF := false;
   TagEOF := false;                   {End-of-File initially set false}
   if Owner.Exact or TagUpdating then      {%FIX0018 Fix partial match errors on update}
      ip := MatchIsExact
   else
      ip := MatchIsPartial;
   K := RootPage.SeekKey(stot.Tag, stot, ip);
   case K of
      ValueEqual : begin
                      RootPage.RetrieveKey(CurKeyInfo);
                      if KeyInRange = 0 then
                         KeyFind := CurKeyInfo.Tag     {!!RFG 091797}
                      else                              {!!RFG 091797}
                         TagEOF := true;                {!!RFG 091797}
                   end;
      ValueLow   : begin
                      rk := RootPage.RetrieveKey(CurKeyInfo);
                      case rk of
                         0 : begin
                                if not KeyInRange = 0 then
                                   TagEOF := true;
                             end;
                         1 : TagBOF := true;
                         2,
                         3 : TagEOF := true
                      end;
                   end;
      ValueHigh  : begin
                      TagEOF := true;
                   end;
   end;
   stot.Free;
end;

Function GSobjIndexTag.KeyByPercent(APct: integer) : LongInt;
begin
   KeyByPercent := 0;
   RunError(5);
(*
   if APct > 100 then APct := 100;
   KeyByPercent := 0;
   CurTagValue := 0;
   if (RootPage = nil) then exit;
   TagBOF := false;
   TagEOF := false;                   {End-of-File initially set false}
   case APct of
        0 : KeyByPercent := KeyRead(Top_Record);
      100 : KeyByPercent := KeyRead(Bttm_Record);
      else  begin
            end;
   end;
*)
end;

Function GSobjIndexTag.KeyInRange: integer;
var
   h: integer;
   d: longint;
begin
   KeyInRange := 0;
   if not RangeActive then exit;
   if TagBOF then
      KeyInRange := -1;
   if TagEOF then
      KeyInRange := 1;
   if (TagBOF) or (TagEOF) then exit;
   h := 0;
   if RangeHi.SizeOfVar > 0 then
{*}      h := RangeHi.Compare(CurKeyInfo,d,RangeExtent,pCollateTable);
   if InvertCmpr then h := -h;
   if HiInRange and (h = 0) then h := 1;
   if h > 0 then
   begin
{      if RangeLo.SizeOfVar > 0 then}   {commented out to account for empty strings}
         h := RangeLo.Compare(CurKeyInfo,d,MatchIsPartial,pCollateTable);
      if InvertCmpr then h := -h;
      if LoInRange and (h = 0) then h := -1;
      inc(h);
   end;
   KeyInRange := h;
end;

Function GSobjIndexTag.KeyIsAscending: boolean;
begin
   KeyIsAscending := AscendKey;
end;

Function GSobjIndexTag.KeyIsPercentile: integer;
begin
   KeyIsPercentile := -1;
end;

Function GSobjIndexTag.KeyIsUnique: boolean;
begin
   KeyIsUnique := UniqueKey;
end;

function GSobjIndexTag.KeyRead(TypRead: longint) : longint;
var
   KeyStatus: integer;
   XofFile: boolean;

   function TestRange: integer;
   var
      h: integer;
      l: integer;
      d: longint;
   begin
      TestRange := 0;
      if not RangeActive then exit;
      if (TagBOF) or (TagEOF) then exit;
      h := 0;
      l := 0;
      if RangeHi.SizeOfVar > 0 then
      begin
{*}         h := RangeHi.Compare(CurKeyInfo,d,RangeExtent,pCollateTable);
         if InvertCmpr then h := -h;
         TagEOF := h = -1;
      end;
      if h >= 0 then
      begin
         if RangeLo.SizeOfVar > 0 then
         begin
            l := RangeLo.Compare(CurKeyInfo,d,MatchIsPartial,pCollateTable);
            if InvertCmpr then l := -l;
            TagBOF := l = 1;
         end;
         if l < 0 then l := 0;
         TestRange := l;
      end
      else
      begin
         TestRange := h;
      end;
      if (TagBOF) or (TagEOF) then TestRange := 0;
   end;

begin
   KeyRead := 0;
   CurKeyInfo.Tag := 0;
   if (RootPage = nil) then exit;
   if InvertRead then             {Descending index}
   begin
      case TypRead of
         Next_Record : TypRead := Prev_Record;
         Prev_Record : TypRead := Next_Record;
         Top_Record  : TypRead := Bttm_Record;
         Bttm_Record : TypRead := Top_Record;
      end;
   end;
   TagBOF := false;
   TagEOF := false;                   {End-of-File initially set false}
   case TypRead of                    {Select KeyRead Action}

      Next_Record : begin
                       Repeat
                          TagEOF := not RootPage.ReadNextKey;
                       until TestRange = 0;
                    end;

      Prev_Record : begin
                       Repeat
                          TagBOF := not RootPage.ReadPreviousKey;
                       until TestRange = 0;
                    end;

      Top_Record  : begin
                       TagOpen(2);
                       if (RangeLo.SizeOfVar > 0) and not TagUpdating then
                       begin
                          TagEOF :=
                             RootPage.SeekKey(IgnoreRecNum, RangeLo, MatchIsPartial) = 1;
                          if not TagEOF then
                             RootPage.RetrieveKey(CurKeyInfo);
                       end
                       else
                          TagBOF := not RootPage.ReadTopKey;
                       TestRange;
                       if TagEOF then TagBOF := true;
                       TagEOF := TagBOF;
                    end;

      Bttm_Record : begin
                      TagOpen(2);
                      if (RangeHi.SizeOfVar > 0) and not TagUpdating then
                       begin
                          KeyStatus := RootPage.SeekKey(MaxRecNum,RangeHi,RangeExtent);
                          case KeyStatus of
                             1 : TagEOF := not RootPage.ReadBottomKey;
                             0 : RootPage.RetrieveKey(CurKeyInfo);
                            -1 : TagBOF := not RootPage.ReadPreviousKey;
                          end;
                       end
                       else
                          TagEOF := not RootPage.ReadBottomKey;
                       if TestRange <> 0 then
                       Repeat
                          TagBOF := not RootPage.ReadPreviousKey;
                       until TestRange = 0;
                       if TagBOF then TagEOF := true;
                       TagBOF := TagEOF;
                    end;

      Same_Record : begin
                       TagEOF := not RootPage.ReadCurrentKey;
                       TagBOF := TagEOF;
                       TestRange;
                    end;

      else          CurKeyInfo.Tag := 0;   {if no valid action, return zero}
   end;
   if TagEOF or TagBOF then
   begin
      CurKeyInfo.Tag := 0;
      if InvertRead then             {Descending index}
      begin
         XofFile := TagEOF;
         TagEOF := TagBOF;
         TagBOF := XofFile;
      end;
   end;
   KeyRead := CurKeyInfo.Tag;
end;

function GSobjIndexTag.KeySync(ATag: longint): longint;
begin
   if (CurKeyInfo = nil) or (ATag <> CurKeyInfo.Tag) then TagOpen(1);
   Result := CurKeyInfo.Tag;
{
   raise EHalcyonError.CreateFmt(gsErrIndexKeySync, [StrPas(Owner.DiskFile.FileName)+'->'+StrPas(TagName)]);
}
end;

function GSobjIndexTag.KeyUpdate(AKey: longint; IsAppend: boolean): boolean;
var
   Chg: boolean;
   Chg2: boolean;
   Fnd: boolean;
   withFor: boolean;
   testFor: boolean;
   Hld: GSptrCharArray;
   isActive: boolean;
   RslStr: GSobjIndexKeyData;
   RslStr2: GSobjIndexKeyData;
   cpos: integer;
begin
   KeyUpdate := false;
   KeyUpdated := false;
   if Owner.Owner.OrigRec = nil then exit;  {no changes}
   if (not Conditional) and (not Owner.Owner.RecModified) then exit;
   TagUpdating := true;
   RslStr := GSobjIndexKeyData.Create(256);
   try
      testFor := Conditional and (Length(ForExpr) > 0);
      if testFor then
         withFor := SolveFilter
       else
         withFor := true;
      Chg := true;
      SolveExpression(RslStr, Chg);
      RslStr.Tag := AKey;
      RslStr.Xtra := AKey;
      isActive := RootPage <> nil;
      if IsAppend then
      begin
         if WithFor then
         begin
            TagOpen(2);
            KeyAdd(RslStr);
            KeyUpdated := true;
            if not isActive then TagClose;
         end;
      end
      else
      begin
         if Chg or testFor then
         begin
            Hld := Owner.Owner.CurRecord;
            Owner.Owner.CurRecord := Owner.Owner.OrigRec;
            RslStr2 := RslStr.CloneLinks;
            try
               SolveExpression(RslStr2, Chg2);
               Fnd := KeyFind(RslStr2) > 0;             {!!RFG 120897}
               if (RslStr.Compare(RslStr2,cpos,MatchIsExact,pCollateTable) <> 0) or
                  ((not withFor) and testFor) then
               begin
                  if Fnd then RootPage.DeleteKey;
                  KeyUpdated := true;
               end
               else
                  withFor := not Fnd;  {Don't add key, it matches the old}
               Owner.Owner.CurRecord := Hld;
            finally
               RslStr2.Free;
            end;
            if withFor then
            begin
               KeyAdd(RslStr);
               KeyUpdated := true;
            end;
            if not isActive then TagClose;
         end;
      end;
      KeyUpdate := KeyUpdated;
   finally
      RslStr.Free;
      TagUpdating := false;
   end;
end;


function GSobjIndexTag.SetRange(RLo: TgsVariant; LoIn: Boolean;
                                 RHi: TgsVariant; HiIn: Boolean;
                                 Partial: boolean): boolean;
var
   notblnk: boolean;
   s: gsUTFString;
   k1: integer;
   k2: integer;
   dav: integer;
begin
   if (RLo <> nil) then
   begin
      s := TrimRight(RLo.GetString);
      notblnk := length(s) > 0;
      AdjustValue(RLo,notblnk);
   end;
   if (RHi <> nil) then
   begin
      s := TrimRight(RHi.GetString);
      notblnk := length(s) > 0;
      AdjustValue(RHi,notblnk);
   end;
   k1 := RangeLo.Compare(RLo,dav,MatchIsExact,nil);
   k2 := RangeHi.Compare(RHi,dav,MatchIsExact,nil);
   Result := not ((k1 = 0) and (k2 = 0));
   if not Result then exit;
   RangeLo.Clear;
   RangeHi.Clear;
   if Partial then
      RangeExtent := MatchIsPartial
   else
      RangeExtent := MatchIsExact;
   LoInRange := LoIn;
   HiInRange := HiIn;
   if (RLo <> nil) and (RLo.SizeOfVar > 0) then
   begin
      RangeLo.Assign(RLo);
   end;
   if (RHi <> nil) and (RHi.SizeOfVar > 0) then
   begin
      RangeHi.Assign(RHi);
   end;
   KeyRead(Top_Record);
end;

function GSobjIndexTag.GetRangeActive: boolean;
begin
   Result := (RangeLo.SizeOfVar > 0) or (RangeHi.SizeOfVar > 0);
end;

procedure GSobjIndexTag.SetRoot(PIK: GSobjIndexKey);
var
   NRN: longint;
   p: GSobjIndexKeyData;
   TmpTag: longint;
   TmpStr: GSobjIndexKeyData;
begin
   PIK.Owner := GSobjIndexKey.Create(Self, nil, 0);
   PIK.Owner.Page := PIK.Page;
   PIK.Owner.PageType := Root;
   PIK.PageType := Unknown;
   NRN := Owner.GetAvailPage;
   PIK.Page := NRN;
   if PIK.Count > 0 then
   begin
      p := PIK.Items[pred(PIK.Count)];
      TmpTag := p.Tag;
      p.Tag := PIK.Page;
      PIK.Owner.InsertKey(p,true);
      p.Tag := TmpTag;
   end
   else
   begin
      TmpStr := GSobjIndexKeyData.Create(0);
      TmpStr.Tag := PIK.Page;
      PIK.Owner.InsertKey(TmpStr,true);
      TmpStr.Free;
   end;
   PIK.Owner.Child := PIK;
   RootPage := PIK.Owner;
   TagChanged := true;
end;

function GSobjIndexTag.PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean;
begin
   PageLoad := false;
end;

function GSobjIndexTag.PageStore(PIK: GSobjIndexKey): Boolean;
begin
   PageStore := false;
end;

function GSobjIndexTag.TagLoad: boolean;
begin
   TagLoad := false;
   TagChanged := false;
end;

function GSobjIndexTag.TagStore: Boolean;
begin
   TagStore := false;
   TagChanged := false;
end;

procedure GSobjIndexTag.TagClose;
begin
   if RootPage <> nil then
   begin
      RootPage.Free;
      RootPage := nil;
   end;
   if TagChanged then TagStore;
   CurKeyInfo.Tag := 0;
end;

function GSobjIndexTag.NewRoot: longint;
begin
   NewRoot := RootBlock;
end;

procedure GSobjIndexTag.TagOpen(Posn: integer);
var
   Sek: integer;
   Chg: boolean;
   Fnd: boolean;
{   nrb: longint;}
   TmpStr: GSobjIndexKeyData;
{   isShared: boolean;}
begin
(*
   if Owner.DiskFile <> nil then
      isShared := Owner.DiskFile.FileShared
   else
      isShared := false;
   if isShared or (RootPage = nil) then
*)
   begin
      TagClose;
      RootPage := GSobjIndexKey.Create(Self, nil, RootBlock);
   end;
   if Posn = 2 then exit;
   if (Posn = 0) or (Length(KeyExpr) = 0) or
      (Owner.Owner.RecNumber = 0) or
      (Owner.Owner.RecNumber > Owner.Owner.NumRecs) or
      (RootPage = nil) or (RootPage.Count = 0) then
      KeyRead(Top_Record)
   else
   begin
      TmpStr := GSobjIndexKeyData.Create(256);
      Fnd := SolveExpression(TmpStr, Chg);
      if Fnd then
      begin
         AdjustValue(TmpStr,true);
         Sek := RootPage.SeekKey(Owner.Owner.RecNumber, TmpStr, MatchIsExact);
         if (Sek = 0) then
         begin
            RootPage.RetrieveKey(CurKeyInfo);
            KeyRead(Same_Record);   {Check BOF/EOF on range}
            if CurKeyInfo.Tag = 0 then
            begin
               KeyRead(Top_Record);
            end;
         end
         else
            KeyRead(Top_Record);
      end
      else
         KeyRead(Top_Record);
      TmpStr.Free;
   end;
end;

function GSobjIndexTag.GetIndexExpression: gsUTFString;
begin
   if assigned(ExprHandlr) then
   begin
      Result := ExprHandlr.Expression;
   end
   else
      Result := '';
end;

procedure GSobjIndexTag.PostTagExpression;
var
   dLink: TgsExpUserLink;
begin
   ExprHandlr.Free;
   ExprHandlr := nil;
   if Owner.Owner = nil then exit;
   if assigned(Owner.Owner) then
      dLink := Owner.Owner.DBFExpLink
   else
      dLink := nil;
   ExprHandlr := TgsExpHandler.Create(dLink,KeyExpr,false);
end;

procedure GSobjIndexTag.PostTagFilter;
var
   dLink: TgsExpUserLink;
begin
   if assigned(FltrHandlr) then
      FltrHandlr.Free;
   FltrHandlr := nil;
   if Owner.Owner = nil then exit;
   if assigned(Owner.Owner) then
      dLink := Owner.Owner.DBFExpLink
   else
      dLink := nil;
   FltrHandlr := TgsExpHandler.Create(dLink,ForExpr,false);
end;

function GSobjIndexTag.SolveExpression(AVar: TgsVariant; var Chg: boolean): boolean;
begin
   if ExprHandlr <> nil then
   begin
      ExprHandlr.ExpressionAsVariant(AVar);
      Result := true;
   end
   else
   begin
      Result := false;
   end;
   Chg := true;
end;

function GSobjIndexTag.SolveFilter: boolean;
var
   q: variant;
begin
   Result := false;
   if FltrHandlr <> nil then
   begin
      FltrHandlr.ExpressionResult(q);
      if FltrHandlr.ResultType = rtBoolean then
      begin
         if q then
             Result := true
         else
             Result := false;
      end;
   end;
end;


{----------------------------------------------------------------------------
                              GSobjIndexFile
----------------------------------------------------------------------------}

constructor GSobjIndexFile.Create(PDB: GSO_dBaseFld);
begin
   inherited Create;
   if PDB <> nil then
   begin
      Exact := PDB.gsvExactMatch;
   end
   else
   begin
      Exact := true;
   end;
   DiskFile := nil;
   IndexName := '';
   Corrupted := false;                           {!!RFG 091197}
   TagList := TgsCollection.Create;
   TagRoot := 0;
   Owner := PDB;
   NextAvail := -1;
   KeyWithRec := false;
   Dictionary := false;
   CreateOK := false;
end;

destructor GSobjIndexFile.Destroy;
begin
   if TagList <> nil then
      TagList.Free;
   if DiskFile <> nil then
      DiskFile.Free;
   inherited Destroy;
end;

function GSobjIndexFile.IndexFileOpen(PDB: GSO_dBaseFld; const FN, EX: gsUTFString;
                           ReadWrite, Shared, Create, Overwrite: boolean): GSO_DiskFile;
var
   Pth: gsUTFString;
   dFile: GSO_DiskFile;
begin
   Pth := Trim(FN);
   Pth := ChangeFileExtEmpty(Pth, EX);
   IndexName := ExtractFileName(Pth);
   if PDB <> nil then
      if ExtractFilePath(Pth) = '' then
         Pth := ExtractFilePath(PDB.FileName)+Pth;
   if Create and not Overwrite then
   begin
      if FileExists(Pth) then
         Create := false;
   end;
   if Create then
   begin
      dFile := GSO_DiskFile.Create(Pth, true, false);
      dFile.gsRewrite;
   end
   else
   begin
      dFile := GSO_DiskFile.Create(Pth, ReadWrite, Shared);
      if not dFile.FileFound then
      begin
         dFile.Free;
         dFile := nil;
      end
      else
         dFile.gsReset;
   end;
   IndexFileOpen := dFile;
end;

function GSobjIndexFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
begin
   AddTag := false;
end;

function GSobjIndexFile.DeleteTag(const ITN: gsUTFString): boolean;
begin
   DeleteTag := false;
end;


function GSobjIndexFile.GetAvailPage: longint;
begin
   GetAvailPage := -1;
end;

function GSobjIndexFile.ResetAvailPage: longint;
begin
   ResetAvailPage := -1;
end;

Function GSobjIndexFile.IndexLock : boolean;
var
   rsl: boolean;
   tc: integer;
begin
   IndexLock := false;
   if DiskFile = nil then exit;
   with DiskFile do
   begin
      if not FileShared then
      begin
         IndexLock := true;
         exit;
      end;
      tc := GSwrdAccessMiliSeconds div GSwrdAccessMSecDelay;
      rsl := false;
      repeat
         case dfLockStyle of
            DB4Lock  : begin
                          rsl := gsLockRecord(dfDirtyReadMax - 1, 2);
                       end;
            ClipLock : begin
                          rsl := gsLockRecord(dfDirtyReadMin, 1);
                       end;
            Default,
            FoxLock  : begin
                          rsl := gsLockRecord(dfDirtyReadMax - 1, 1);
                       end;
         end;
         if not rsl then
         begin
            gsSysSleep(GSwrdAccessMSecDelay);
            dec(tc);
         end;
      until rsl or (tc = 0);
      IndexLock := rsl;
      if not rsl then
         raise EHalcyonError.CreateFmt(gsErrLockFailed, [FileName]);
   end;
end;

function GSobjIndexFile.IsFileName(const IName: gsUTFString): boolean;
var
   PcWk: gsUTFString;
begin
   PcWk := ExtractFileName(IName);
   IsFileName := gsStrCompareI(PcWk, IndexName) = 0;
end;

function GSobjIndexFile.KeyByName(const AKey: gsUTFString; AFor: boolean): GSobjIndexTag;
var
   i: integer;
   m: integer;
   p: GSobjIndexTag;
begin
   if TagList.Count = 0 then
   begin
      KeyByName := nil;
   end
   else
   begin
      i := 0;
      repeat
         p := TagList.Items[i];
         inc(i);
         m := gsStrCompareI(AKey, p.KeyExpr);
         if AFor and p.Conditional then m := 1;
      until (m=0) or (i = TagList.Count);
      if m = 0 then
         KeyByName := p
      else
         KeyByName := nil;
   end;
end;

function GSobjIndexFile.PageRead(Blok: longint; var Page; Size: integer):
                                 boolean;
var
   pb: PByteArray;
   d: integer;
   dl: integer;
begin
   PageRead := false;
   if DiskFile = nil then exit;
   PageRead := DiskFile.gsRead(Blok, Page, Size) = Size;
   if Owner <> nil then
      if Owner.gsvIsEncrypted then
      begin
         pb := @Page;
         d := 0;
         dl := Size;
         repeat
            if dl > 512 then dl := 512;
            DBEncryption(Owner.gsvPasswordIn,@pb^[d],@pb^[d],0,dl);
            inc(d,512);
            dl := Size-d;
         until dl <= 0;
      end;
end;

function GSobjIndexFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
var
   pb: PByteArray;
   d: integer;
   dl: integer;
begin
   PageWrite := false;
   if DiskFile = nil then exit;
   if Owner <> nil then
   begin
      if Owner.gsvIsEncrypted then
      begin
         GetMem(pb,Size);
         Move(Page,pb^,Size);
         d := 0;
         dl := Size;
         repeat
            if dl > 512 then dl := 512;
            DBEncryption(Owner.gsvPasswordOut,@pb^[d],@pb^[d],1,dl);
            inc(d,512);
            dl := Size-d;
         until dl <= 0;
         DiskFile.gsWrite(Blok, pb^, Size);
         FreeMem(pb,Size);
      end
      else
         DiskFile.gsWrite(Blok, Page, Size);
   end      
   else
      DiskFile.gsWrite(Blok, Page, Size);
   PageWrite := true;
end;

procedure GSobjIndexFile.ReIndex;
begin
end;

function GSobjIndexFile.Rename(const NewName: gsUTFString): boolean;
var
   filenew: gsUTFString;
   extn: gsUTFString;
begin
   if DiskFile <> nil then
   begin
      extn := ExtractFileExt(IndexName);
      filenew := ChangeFileExt(NewName,extn);
      Result := DiskFile.gsRename(filenew);
      if Result then
      begin
         IndexName := ExtractFileName(filenew);
      end;
   end
   else
      Result := false;
end;


function GSobjIndexFile.GetFileName: gsUTFString;
begin
   GetFileName := IndexName;
end;

function GSobjIndexFile.TagCount: integer;
begin
   TagCount := TagList.Count;
end;

function GSobjIndexFile.TagByName(const ITN: gsUTFString): GSobjIndexTag;
var
   i: integer;
   m: integer;
   p: GSobjIndexTag;
begin
   if TagList.Count = 0 then
   begin
      TagByName := nil;
   end
   else
   begin
      i := 0;
      repeat
         p := TagList.Items[i];
         inc(i);
         m := gsStrCompareI(ITN, p.TagName);
      until (m=0) or (i = TagList.Count);
      if m = 0 then
         TagByName := p
      else
         TagByName := nil;
   end;
end;

function GSobjIndexFile.TagByNumber(N: integer): GSobjIndexTag;
begin
   if (N < 0) or (N >= TagList.Count) then
      TagByNumber := nil
   else
      TagByNumber := TagList.Items[N];
end;

function GSobjIndexFile.TagUpdate(AKey: longint; IsAppend: boolean): boolean;
var
   p: GSobjIndexTag;
   i: integer;
   b: boolean;
   c: boolean;
begin
   NextAvail := -1;
   b := false;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      c := p.KeyUpdate(AKey,IsAppend);
      b := b or c;
   end;
   TagUpdate := b;
end;

function GSobjIndexFile.ExternalChange: boolean;   {!!RFG 091297}
begin
   ExternalChange := false;
end;

Procedure GSobjIndexFile.ixSetLockProtocol(LokProtocol: GSsetLokProtocol);
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
end;

Procedure GSobjIndexFile.ixEncrypt;
var
   pb: PByteArray;
   ds: integer;
   dc: integer;
   i: integer;
begin
   if DiskFile = nil then exit;
   if Owner = nil then exit;
   GetMem(pb,512);
   ds := DiskFile.gsFileSize;
   dc := ds div 512;
   for i := 0 to dc-1 do
   begin
      DiskFile.gsRead(i*512,pb^,512);
      DBEncryption(Owner.gsvPasswordIn,pb,pb,0,512);
      DBEncryption(Owner.gsvPasswordOut,pb,pb,1,512);
      DiskFile.gsWrite(i*512,pb^,512);
   end;
   FreeMem(pb,512);
end;

end.


