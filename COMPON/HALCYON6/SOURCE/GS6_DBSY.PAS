unit gs6_dbsy;
{-----------------------------------------------------------------------------
                          dBase III/IV File Handler

       gs6_dbsy Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          4 Jun 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the objects to manipulate the data, index, and
       memo files that constitute a database.

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
   SysUtils,
   classes,
   gs6_cnst,
   gs6_date,
   gs6_tool,
   gs6_sort,
   gs6_disk,
   gs6_dbf,
   gs6_indx,
   {$IFDEF FOXOK}
   gs6_cdx,
   gs6_mix,
   {$ENDIF}
   {$IFDEF DBASE4OK}
   gs6_mdx,
   {$ENDIF}
   {$IFDEF DBASE3OK}
   gs6_ndx,
   {$ENDIF}
   {$IFDEF CLIPOK}
   gs6_ntx,
   {$ENDIF}
   gs6_Memo,
   gs6_sql,
   gs6_lcal,
   gs6_glbl;

{private}

const
   IndexesAvail    = 63;
   DBFCacheSize    : word = 32768;

type

   GSobjSortDB = class;

   GSO_dBHandler = class(GSO_dBaseFld)
      IndexMaster : GSobjIndexTag;
      PrimaryTagName: array[0..15] of char;
      IndexStack  : array[0..IndexesAvail] of GSobjIndexFile;
      CacheFirst  : Longint;
      CacheLast   : Longint;
      CachePtr    : GSptrByteArray;
      CacheRecs   : integer;
      CacheSize   : LongInt;
      CacheRead   : boolean;
      CacheAllowed: boolean;
      gsvFound    : boolean;
      gsvFindNear : boolean;
      gsvRecRead  : boolean;
      DoingSort   : boolean;
      ResyncIndex : boolean;
      ActiveIndexChg: boolean;
      FFilterSet  : TgsHugeSet;
      FFilterHndlr: TgsExpHandler;
      FFilterExpr : gsUTFString;
      FFilterLive : boolean;
      FFilterOn   : boolean;
      SearchMode  : word; {Mode flags for gsSearchDBF.  Default value is zero}
                          {Values are summed together for multiple conditions}
                          {1=Case Insensitive; 2=Use Exact; 4=Use Wildcards  }
                          {8=Use Filter; 16=Use Index; 32=Match at Start Only}

      constructor Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
      destructor  Destroy; override;
      procedure   gsAppend; override;
      function    gsBuildKey(const KeyValues: array of const; ExprHandler: TgsExpHandler): gsUTFString;
      procedure   gsCopyFile(const filname, apassword: gsUTFString);
      procedure   gsCopyFromIndex(ixColl: GSobjSortDB; const filname, apassword: gsUTFString);
      procedure   gsCopyMemoRecord(df : GSO_dBHandler);
      procedure   gsCopyRecord(filobj: GSO_dBHandler);
      procedure   gsCopyStructure(const filname: gsUTFString);
      function    gsDBFEvent(Event: dbFileEvent; Action: longint): boolean; override;
      Function    gsFind(const st : gsUTFString) : boolean; virtual;
      function    gsGetKey(RecNum : Longint; var keyst: gsUTFString): longint;
      Procedure   gsGetRec(RecNum : LongInt); override;
      Function    gsHuntDuplicate(const st, ky: gsUTFString) : longint; virtual;
      Function    gsIndex(const INames, Tag: gsUTFString): integer;   {!!RFG 091297}
      Procedure   gsIndexClear;
      function    gsIndexFileExtend(const IName: gsUTFString): gsUTFString;
      function    gsIndexFileIsOpen(const IName: gsUTFString): integer;
      function    gsIndexFileRemove(const IName: gsUTFString): integer;
      function    gsIndexFileKill(const IName: gsUTFString): integer;
      function    gsIndexKeyValue(Value: integer; ExpVar: TgsVariant): boolean;
      function    gsIndexTagRemove(const IName, Tag: gsUTFString): integer;
      procedure   gsIndexOrder(Value: integer);
      function    gsIndexPointer(Value: integer): GSobjIndexTag;
      function    gsIndexRoute(const IName: gsUTFString): integer;
      function    gsIndexInsert(ix : GSobjIndexFile) : integer;
      Function    gsIndexTo(const IName, tag, keyexpr, forexpr: gsUTFString;
                          uniq: GSsetIndexUnique;
                          ascnd: GSsetSortStatus): integer;
      Procedure   gsLoadToIndex(ixColl: GSobjSortDB; zfld: PChar);
      function    gsLocateRecord(const KeyFields: gsUTFString; const KeyValues: Variant;
                                 IsInsensitive, IsPartial: boolean): Boolean;
      Function    gsMemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
                     uniq: GSsetIndexUnique; ascnd: GSsetSortStatus): boolean;
      Function    gsSetTagTo(const TName: gsUTFString; SameRec: boolean): integer;
      Procedure   gsPack;
      Procedure   gsPutRec(RecNum : LongInt); override;
      Procedure   gsRefresh;
      Procedure   gsReIndex;
      Function    gsRename(const NewName: gsUTFString): boolean; override;
      function    gsRead(blk: gsuint32; var dat; len: gsuint32): integer; override;
      procedure   gsSetDBFCacheAllowed(tf: boolean);
      procedure   gsSetDBFCache(tf: boolean);
      procedure   gsResetRange;
      procedure   gsRefreshFilter;
      procedure   gsSetFilterExpr(const FiltExpr: gsUTFString; Insensitive, Wildcards: boolean);
      procedure   gsSetFilterActive(Value: boolean);
      function    gsSetRange(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean): boolean;
      procedure   gsSkip(RecCnt : LongInt); virtual;
      procedure   gsSortFile(const filname, apassword, zfld: gsUTFString; isascend : GSsetSortStatus);
      function    gsTestFilter : boolean; virtual;
      Function    gsWithIndex: boolean; override;
      Procedure   gsWrite(blk: gsuint32; var dat; len: gsuint32); override;
      Procedure   gsZap;
      Function    gsSearchDBF(const s: gsUTFString; var FNum : word;
                            var fromrec: longint; torec: longint): word;
      Procedure   gsSetLockProtocol(LokProtocol: GSsetLokProtocol); override;
      Function    gsLockIndexes: boolean; virtual;
      Function    gsUnLockIndexes: boolean;
      Procedure   gsSetPassword(const APassword: gsUTFString); virtual;
      Procedure   gsRewriteMemoRecord;
   end;

   GSobjSortDB = class(TgsSort)
      curFile: GSO_dBHandler;
      newFile: GSO_dBHandler;
      KeyCnt: longint;
      procedure    OutputWord;
   end;

implementation

const
   {$IFDEF DBASE3OK}
      IndexExt : gsUTFString = '.ndx';
   {$ELSE}
      {$IFDEF DBASE4OK}
         IndexExt : gsUTFString = '.mdx';
      {$ELSE}
         {$IFDEF FOXOK}
            IndexExt : gsUTFString= '.cdx';
         {$ELSE}
            {$IFDEF CLIPOK}
                IndexExt : gsUTFString = '.ntx';
            {$ELSE}
                IndexExt : gsUTFString = '.ndx';
            {$ENDIF}
         {$ENDIF}
      {$ENDIF}
   {$ENDIF}

constructor GSO_dBHandler.Create(const FName, APassword: gsUTFString; ReadWrite, Shared: boolean);
var
   i : integer;
begin
   inherited Create(FName, APassword, ReadWrite, Shared);
   CacheRead := false;
   CacheAllowed := true;
   CachePtr := nil;
   CacheFirst := -1;
   CacheLast := 0;
   gsvFound := false;
   gsvFindNear := false;
   gsvRecRead := false;
   IndexMaster := nil;
   PrimaryTagName[0] := #0;
   for i := 1 to IndexesAvail do IndexStack[i] := nil;
   DoingSort := false;
   ResyncIndex := false;
   SearchMode := 1;
   FFilterSet := nil;
   FFilterHndlr := nil;
   FFilterLive := false;
   FFilterOn := false;
   FFilterExpr := '';
end;

destructor GSO_dBHandler.Destroy;
var
   i : integer;
begin
   if FFilterSet <> nil then FFilterSet.Free;
   if FFilterHndlr <> nil then FFilterHndlr.Free;
   for i := 1 to IndexesAvail do
      if IndexStack[i] <> nil then
      begin
         IndexStack[i].Free;
         IndexStack[i] := nil;
      end;
   IndexMaster := nil;               {Set index active flag to false}
   if CachePtr <> nil then FreeMem(CachePtr, CacheSize);
   CachePtr := nil;
   CacheSize := 0;
   inherited Destroy;
end;

{------------------------------------------------------------------------------
                              Record Processing
------------------------------------------------------------------------------}

Function GSO_dBHandler.gsLockIndexes: boolean;
VAR
   i: integer;
   j: integer;
   r: boolean;
BEGIN
   for i := 1 to IndexesAvail do
      if (IndexStack[i] <> nil) and (IndexStack[i].DiskFile <> nil) then
      begin
         r := IndexStack[i].IndexLock;
         if not r then
         begin
            for j := 1 to i-1 do
               if IndexStack[j] <> nil then
               begin
                  IndexStack[j].DiskFile.gsUnLock;
               end;
            raise EHalcyonError.CreateFmt(gsErrIndexLocks,[FileName]);
            exit;
         end;
      end;
   gsLockIndexes := true;
end;

Function GSO_dBHandler.gsUnlockIndexes: boolean;
VAR
   i: integer;
BEGIN
   for i := 1 to IndexesAvail do
      if (IndexStack[i] <> nil) and (IndexStack[i].DiskFile <> nil) then
      begin
         IndexStack[i].DiskFile.gsUnLock;
      end;
   gsUnlockIndexes := true;
end;

Procedure GSO_dBHandler.gsAppend;
BEGIN
   if gsLockIndexes then
   begin
      try
         inherited gsAppend;
      finally
         gsUnlockIndexes;
      end;
   end;
end;

function GSO_dBHandler.gsDBFEvent(Event: dbFileEvent; Action: longint): boolean;
var
   i: integer;
   q: variant;
   r: integer;
begin
   case Event of
      dbPostWrite     : begin
                           if (FFilterHndlr <> nil) and (FFilterSet <> nil) then
                           begin
                              FFilterHndlr.ExpressionResult(q);
                              if q then
                                 r := 1
                              else
                                 r := 0;
                              FFilterSet.ChangeBit(RecNumber,r);
                           end;
                           ActiveIndexChg := false;
                           for i := 1 to IndexesAvail do
                           begin
                              if (IndexStack[i] <> nil) then
                              begin
                                 IndexStack[i].TagUpdate(RecNumber,Action = 0);
                              end;
                           end;
                           ResyncIndex := false;
                           if IndexMaster <> nil then
                           begin
                              ActiveIndexChg := IndexMaster.KeyUpdated;
                              ResyncIndex := IndexMaster.KeySync(RecNumber) <> RecNumber;
                              File_TOF := IndexMaster.TagBOF;
                              File_EOF := IndexMaster.TagEOF;
                           end;
                           if FFilterOn and (not ResyncIndex) then
                           begin
                              ResyncIndex := FFilterSet.BitValue(RecNumber);
                           end;
                           if (IndexMaster <> nil) and (not FFilterOn) then
                           begin
                              File_EOF := (Action = 0) or   {!!RFG 082097}
                                          (Action = NumRecs);
                              File_TOF := Action = 1;   {!!RFG 082097}
                           end;
                        end;
      dbFlush         : begin
                           if IndexMaster <> nil then IndexMaster.TagClose;
                           for i := 1 to IndexesAvail do
                              if (IndexStack[i] <> nil) and
                                 (IndexStack[i].DiskFile <> nil) then
                                 IndexStack[i].DiskFile.gsFlush;
                           ResyncIndex := false;
                           if IndexMaster <> nil then
                           begin
                              IndexMaster.TagOpen(1);
                              ResyncIndex := IndexMaster.KeySync(RecNumber) <> RecNumber;
                           end;
                        end;
   end;
   gsDBFEvent := inherited gsDBFEvent(Event, Action);
end;

Function GSO_dBHandler.gsFind(const st : gsUTFString) : boolean;
var
   RNum   : longint;
   ps: GSobjIndexKeyData;
   dv: longint;
begin
   gsvFound := false;
   gsFind := gsvFound;
   if NumRecs = 0 then exit;                    {!!RFG 022198}
   if dfLockStyle = ClipLock then
   begin
      if not gsLockIndexes then exit;
   end;
   if (IndexMaster <> nil) then
   begin
      ps := GSobjIndexKeyData.Create(256);
      ps.PutString(st);
      ps.Tag := IgnoreRecNum;
      RNum := IndexMaster.KeyFind(ps);
      if RNum > 0 then                {RNum = 0 if no match, otherwise}
                                      {it holds the valid record number}
      begin
         gsvFound := false;
         inherited gsGetRec(RNum);    {If match found, read the record}
         while ((not gsTestFilter) or
               (gsDelFlag and (not UseDeletedRec))) and
               (not File_EOF) do gsSkip(1);
         if not File_EOF then
         begin
            with IndexMaster do
            begin
               AdjustValue(ps,true);
               gsvFound := ps.Compare(CurKeyInfo,dv,MatchIsExact,pCollateTable) = 0;
               if not gsvFound then
                  if (not gsvExactMatch) and (dv > ps.SizeOfVar) then   {!RFG 080597}
                     gsvFound := true;  {Non-Exact match test}
            end;
            if (not gsvFound) and (not gsvFindNear) then
            begin
               gsGetRec(Bttm_Record);
               File_EOF := True;
            end;
         end;
      end else
      begin                           {If no matching index key, then}
         gsvFound := False;              {Set Match Found Flag False}
         if (IndexMaster.TagEOF) or (not gsvFindNear) then
         begin
            gsGetRec(Bttm_Record);
            File_EOF := True;
         end
         else
         begin
            RNum := IndexMaster.KeyRead(-5);  {Read current index pos}
            gsGetRec(RNum);                        {read the record}
         end;
      end;
      ps.Free;
   end else                           {If there is no index file, then}
   begin
      gsvFound := False;                 {Set Match Found Flag False}
      gsGetRec(Bttm_Record);
      File_EOF := True;
   end;
   if dfLockStyle = ClipLock then
   begin
      gsUnlockIndexes;
   end;
   gsFind := gsvFound;
end;                  {Find}

Function GSO_dBHandler.gsHuntDuplicate(const st, ky: gsUTFString) : longint;
var
   im: GSobjIndexTag;
   ps: GSobjIndexKeyData;
   i: integer;
   pc: array[0..79] of char;
   em: boolean;
begin                                 {!!RFG 082097}
   gsHuntDuplicate := -1;
   if dfLockStyle = ClipLock then
   begin
      if not gsLockIndexes then exit;
   end;
   im := nil;
   StrPCopy(pc,st);
   i := 0;
   while (i < IndexesAvail) and (im = nil) do
   begin
      inc(i);
      if IndexStack[i] <> nil then
         im := IndexStack[i].TagByName(pc);
   end;
   if (im <> nil) then
   begin
      ps := GSobjIndexKeyData.Create(256);
      ps.PutString(ky);
      ps.Tag := IgnoreRecNum;
      em := gsvExactMatch;
      gsvExactMatch := true;
      gsHuntDuplicate := im.HuntDuplicate(ps);
      gsvExactMatch := em;
      ps.Free;
   end;
   if dfLockStyle = ClipLock then
   begin
      gsUnlockIndexes;
   end;
end;

function GSO_dBHandler.gsGetKey(RecNum : Longint; var keyst: gsUTFString): longint;
begin
   if IndexMaster <> nil then
   begin
      gsGetKey := IndexMaster.KeyRead(RecNum);
      keyst := IndexMaster.CurKeyInfo.GetString;
   end
   else
   begin
      keyst := '';
      gsGetKey := 0;
   end;
end;

procedure GSO_dBHandler.gsGetRec(RecNum : LongInt);
var
   inum  : longint;
   rnum  : longint;
   knum  : longint;
   cread : boolean;
   okread: boolean;
begin
   ResyncIndex := false;
   if dState <> dbBrowse then
   begin
      inherited gsGetRec(RecNum);
      exit;
   end;
   gsvRecRead := false;
{
   if dfLockStyle = ClipLock then
   begin
      if not gsLockIndexes then exit;
   end;
}
   inum := 0;
   cread := CacheRead;
   okread := false;
   File_EOF := false;
   File_TOF := false;
   rnum := RecNum;
   knum := RecNum;
   if (knum = Top_Record) or (knum = Same_Record) then knum := Next_Record
      else if knum = Bttm_Record then knum := Prev_Record;
   repeat
      if (IndexMaster <> nil) and (knum < 0) then
      begin
         repeat
            CacheRead := false;
            rnum := IndexMaster.KeyRead(rnum);
            inum := rnum;
            File_EOF := IndexMaster.TagEOF;
            File_TOF := IndexMaster.TagBOF;
            if FFilterOn then
            begin
               okread := FFilterSet.BitValue(rnum);
               if not okread then rnum := knum;
            end
            else
               okread := true;
         until okread or File_EOF or File_TOF;
      end
      else
      if FFilterOn and (rnum < 0) then
      begin
         case rnum of
            Top_Record   : begin
                              File_TOF := FFilterSet.Highest < 1;
                              if not File_TOF then
                              begin
                                 rnum := 1;
                                 repeat
                                    okread := FFilterSet.BitValue(rnum);
                                    if not okread then inc(rnum);
                                 until okread or (rnum > FFilterSet.Highest);
                                 if not okread then File_EOF := true;
                              end
                              else
                                 File_EOF := true;
                           end;
            Next_Record  : begin
                              File_TOF := FFilterSet.Highest < 1;
                              if not File_TOF then
                              begin
                                 rnum := RecNumber+1;
                                 repeat
                                    okread := FFilterSet.BitValue(rnum);
                                    if not okread then inc(rnum);
                                 until okread or (rnum > FFilterSet.Highest);
                                 if not okread then File_EOF := true;
                              end
                              else
                                 File_EOF := true;
                           end;
            Prev_Record  : begin
                              File_TOF := FFilterSet.Highest < 1;
                              if not File_TOF then
                              begin
                                 rnum := RecNumber-1;
                                 okread := false;
                                 while (rnum > 0) and (not okread) do
                                 begin                                  {%FIX 00001}
                                    okread := FFilterSet.BitValue(rnum);
                                    if not okread then dec(rnum);
                                 end;;
                                 if not okread then File_TOF := true;
                              end
                              else
                                 File_EOF := true;
                           end;
            Bttm_Record  : begin
                              File_TOF := FFilterSet.Highest < 1;
                              if not File_TOF then
                              begin
                                 rnum := FFilterSet.Highest;
                                 repeat
                                    okread := FFilterSet.BitValue(rnum);
                                    if not okread then dec(rnum);
                                 until okread or (rnum = 0);
                                 if not okread then File_TOF := true;
                              end
                              else
                                 File_EOF := true;
                           end;
         end;
         inum := rnum;
      end;
      if (not File_EOF) and (not File_TOF) then   {Destroy if EOF reached}
      begin
         inherited gsGetRec(rnum);
         okread := not((rnum = 0) or (rnum > numrecs));
         if not okread then
         begin
            gsBlank;
            exit;
         end;
         if (knum < 0) and (not (File_EOF or File_TOF))then  {ignore if physical record access}
            okread := (not (gsDelFlag and (not UseDeletedRec))) and
                       gsTestFilter;
         rnum := knum;
      end;
   until okread or File_EOF or File_TOF;
   CacheRead := cread;
(*
   if File_TOF then
   begin
      if (RecNum <> Top_Record) and (RecNum <> Bttm_Record) then
         gsGetRec(Top_Record);   {Recursion for first filtered record}
      if File_TOF then
         gsBlank;
      File_TOF := True;
   end
   else
   if File_EOF then
   begin
      if (RecNum <> Top_Record) and (RecNum <> Bttm_Record) and
         (not gsvIndexState) then                               {!!RFG 083097}
         gsGetRec(Bttm_Record);  {Recursion for last filtered record}
      if File_EOF then
         gsBlank;
      File_EOF := True;
   end;
*)
   gsvRecRead := not (File_EOF or File_TOF);
   if IndexMaster <> nil then     {Resync index if necesary}
   begin
      if (RecNumber <> inum) and (gsvRecRead) then
         ResyncIndex := IndexMaster.KeySync(RecNumber) <> RecNumber;
   end;
   if FFilterOn and (not ResyncIndex) then
   begin
      if (RecNumber <> inum) and (gsvRecRead) then
         ResyncIndex := FFilterSet.BitValue(RecNumber);
   end;
   if dfLockStyle = ClipLock then
   begin
      gsUnlockIndexes;
   end;
end;

Procedure GSO_dBHandler.gsPutRec(RecNum : LongInt);
begin
   ResyncIndex := false;
   if gsLockIndexes then
   begin
      inherited gsPutRec(RecNum);
      gsUnlockIndexes;
   end;
end;

function GSO_dBHandler.gsRead(blk: gsuint32; var dat; len: gsuint32): integer;
var
   goodrec: integer;
   blkpsn: integer;
begin
   blkpsn := blk;
   if (not CacheRead) or (blkpsn < HeadLen) then
      gsRead := inherited gsRead(blk,dat,len)
   else
   begin
      if (CacheFirst = -1) or
         (blkpsn < CacheFirst) or
         (blkpsn >= CacheLast-RecLen) then
      begin
         goodrec := inherited gsRead(blk,CachePtr^,CacheSize);
         CacheFirst := blk;
         CacheLast := (blkpsn + goodrec);
      end;
      if blkpsn >= CacheLast then goodrec := 0
      else
      begin
         goodrec := RecLen;
         if DoingSort then
            CurRecord := @CachePtr^[blkpsn - CacheFirst]
         else
            Move(CachePtr^[blkpsn - CacheFirst],dat,RecLen);
      end;
      gsRead := goodrec;
   end;
end;

procedure GSO_dBHandler.gsRefresh;
begin
   gsGetRec(Same_Record);
end;

Function GSO_dBHandler.gsRename(const NewName: gsUTFString): boolean;
var
   i: integer;
   dbnamestring: gsUTFString;
   ixnamestring: gsUTFString;
begin
   dbnamestring := ExtractFileNameOnly(FileName);
   inherited gsRename(NewName);
   for i := 1 to IndexesAvail do
   begin
      if (IndexStack[i] <> nil) and (IndexStack[i].DiskFile <> nil) then
      begin
         ixnamestring := ExtractFileNameOnly(IndexStack[i].DiskFile.FileName);
         if gsStrCompareI(dbnamestring, ixnamestring) = 0 then
            IndexStack[i].Rename(NewName);
      end;
   end;
   Result := true;
end;

Procedure GSO_dBHandler.gsSetDBFCacheAllowed(tf: boolean);
begin
   CacheAllowed := tf;
   if not tf then
      gsSetDBFCache(false);
end;

Procedure GSO_dBHandler.gsSetDBFCache(tf: boolean);
begin
   if not CacheAllowed then tf := false;
   if tf and CacheRead then exit;
   CacheRead := tf;
   if not tf then
   begin
      if CachePtr <> nil then FreeMem(CachePtr, CacheSize);
      CachePtr := nil;
      CacheSize := 0;
   end
   else
   begin
      CacheSize := DBFCacheSize;
      CacheSize := CacheSize - (CacheSize mod RecLen);
      if CacheSize < RecLen then CacheSize := RecLen;
      GetMem(CachePtr, CacheSize);
      CacheFirst := -1;
      CacheRecs := CacheSize div RecLen;
   end;
end;

Procedure GSO_dBHandler.gsResetRange;
begin
   if IndexMaster = nil then exit;
   IndexMaster.SetRange(nil,false,nil,false,false);
end;

Procedure GSO_dBHandler.gsSetLockProtocol(LokProtocol: GSsetLokProtocol);
var
   i: integer;
begin
   inherited gsSetLockProtocol(LokProtocol);
   for i := 1 to IndexesAvail do
      if (IndexStack[i] <> nil) and (IndexStack[i].DiskFile <> nil) then
          IndexStack[i].ixSetLockProtocol(LokProtocol);
end;

procedure GSO_dBHandler.gsRefreshFilter;
var
   rn: longint;
   ix: gsObjIndexTag;
   cr: boolean;
   qb: variant;
begin
   if FFilterOn then
   begin
      FFilterOn := false;
      FFilterSet.Clear;
      rn := RecNumber;
      ix := IndexMaster;
      cr := CacheRead;
      if (ix = nil) then
      begin
         gsSetDBFCache(true);
      end;
      gsGetRec(Top_Record);
      while not File_EOF do
      begin
         FFilterHndlr.ExpressionResult(qb);
         if qb then
             FFilterSet.ChangeBit(RecNumber,1);
         gsGetRec(Next_Record);
      end;
      gsSetDBFCache(cr);
      IndexMaster := ix;
      gsGetRec(rn);
      gsSetFilterActive(true);
   end;
end;

procedure GSO_dBHandler.gsSetFilterExpr(const FiltExpr: gsUTFString; Insensitive, Wildcards: boolean);
var
   fa: boolean;
   rn: longint;
   ix: gsObjIndexTag;
   cr: boolean;
   qb: variant;
   bf: variant;
begin
   fa := FFilterLive;
   FFilterOn := false;
   if FFilterSet = nil then
      FFilterSet := TgsHugeSet.Create;
   if Length(FiltExpr) = 0 then
   begin
      if FFilterHndlr <> nil then
      begin
         FFilterHndlr.Free;
         FFilterHndlr := nil;
      end;
   end
   else
   begin
      if FFilterHndlr = nil then
         FFilterHndlr := TgsExpHandler.Create(DBFExpLink,'',false);
      if (FiltExpr <> FFilterExpr) or (FFilterHndlr.CaseInsensitive <> Insensitive) or
         (FFilterHndlr.UseWildCards <> WildCards) then
      begin
         FFilterExpr := FiltExpr;
         FFilterSet.Clear;
         FFilterHndlr.CaseInsensitive := Insensitive;
         FFilterHndlr.UseWildCards := WildCards;
         FFilterHndlr.Expression := FiltExpr;
         FFilterHndlr.ExpressionResult(bf);   {Execute expression to get result type}
         if FFilterHndlr.ResultType <> rtBoolean then
            raise EHalcyonError.Create(gsErrFilterExpression);
         rn := RecNumber;
         cr := CacheRead;
         ix := IndexMaster;
         if (ix = nil) or (not ix.RangeActive) then
         begin
            IndexMaster := nil;   {comment this out to filter only an index range}
            gsSetDBFCache(true);
         end;
         gsGetRec(Top_Record);
         while not File_EOF do
         begin
            FFilterHndlr.ExpressionResult(qb);
            if qb then
               FFilterSet.ChangeBit(RecNumber,1);
            gsGetRec(Next_Record);
         end;
         gsSetDBFCache(cr);
         IndexMaster := ix;
         gsGetRec(rn);
      end;
   end;
   gsSetFilterActive(fa);
end;

procedure GSO_dBHandler.gsSetFilterActive(Value: boolean);
begin
   FFilterLive := Value;
   FFilterOn := FFilterLive and (FFilterHndlr <> nil) and (FFilterHndlr.ArgCount > 0);
end;

Function GSO_dBHandler.gsSetRange(const RLo, RHi: gsUTFString; LoIn, HiIn, Partial: boolean): boolean;
var
   s1: TgsVariant;
   s2: TgsVariant;
begin
   Result := false;
   if IndexMaster = nil then exit;
   if length(RLo) > 0 then
   begin
      s1 := TgsVariant.Create(256);
      s1.PutString(RLo);
   end
   else
      s1 := nil;
   if length(RHi) > 0 then
   begin
      s2 := TgsVariant.Create(256);
      s2.PutString(RHi);
   end
   else
      s2 := nil;   
   Result := IndexMaster.SetRange(s1,LoIn,s2,HiIn, Partial);
   s2.Free;
   s1.Free;
   if Result then
      gsGetRec(Top_Record);
   if File_TOF then gsBlank;
end;

PROCEDURE GSO_dBHandler.gsSkip(RecCnt : LongInt);
VAR
   i  : integer;
   rn : longint;
   de : longint;
   dr : longint;
   rl : longint;
   rc : longint;
   im : pointer;

   procedure SkipFromDBF;
   begin
      rl := Recnumber + RecCnt;
      rc := rl;
      if (rl > NumRecs) then
      begin                         {flag out of file range}
         rc := 0;
         rl := NumRecs;
      end
      else
      if (rl < 1) then
      begin
         rc := 0;                   {flag out of file range}
         rl := 1;
      end;
   end;

   procedure SkipFromIndex;
   begin
      i := 1;
      repeat
         rc := IndexMaster.KeyRead(dr);
         if rc > 0 then
            rl := rc
         else
            rl := IndexMaster.KeyRead(de);
         inc(i);
      until (i > rn) or (rc = 0);
   end;


begin
   If RecCnt <> 0 then
   begin
      if RecCnt < 0 then de := Top_Record else de := Bttm_Record;
      rl := RecNumber;
      rn := abs(RecCnt);
      if RecCnt > 0 then dr := Next_Record else dr := Prev_Record;
      if (not FFilterLive) and UseDeletedRec then
      begin                                  {do fast skip}
         if (IndexMaster <> nil) then
         begin
            SkipFromIndex;
            if rl <> 0 then
            begin
               im := IndexMaster;
               IndexMaster := nil;
               gsGetRec(rl);
               IndexMaster := im;
            end;
         end
         else
         begin
            SkipFromDBF;
            gsGetRec(rl);
         end;
         if rc = 0 then
         begin
            File_EOF := de = Bttm_Record;
            File_TOF := de = Top_Record;
         end;
      end
      else
      begin
         repeat
            gsGetRec(dr);
            dec(rn);
         until (rn = 0) or File_EOF or File_TOF;
      end;
   end
   else gsGetRec(Same_Record);
end;

function GSO_dBHandler.gsTestFilter: boolean;
begin
   gsTestFilter := true;
end;

Function  GSO_dBHandler.gsWithIndex: boolean;
begin
   gsWithIndex := IndexStack[1] <> nil;
end;

Procedure GSO_dBHandler.gsWrite(blk: gsuint32; var dat; len: gsuint32);
var
   blkpsn: integer;
begin
   blkpsn := blk;
   inherited gsWrite(blk,dat,len);
   if blk = 0 then exit;
   if (CacheRead) then
   begin
      if (CacheFirst = -1) or
         (blkpsn < CacheFirst) or
         (blkpsn >= CacheLast-RecLen) then
      begin
      end
      else
         Move(dat,CachePtr^[blkpsn - CacheFirst],len);
   end;
end;

Procedure GSO_dBHandler.gsSetPassword(const APassword: gsUTFString);
var
   rn: longint;
   ix: gsObjIndexTag;
   cr: boolean;
   fl: integer;
   flds: PByteArray;
   i: integer;
   TmpState: dbFileState;
begin
   TmpState := dState;
   if FileShared then
   begin
      raise EHalcyonError.CreateFmt(gsErrNoFullAccess,['SetPassword',FileName]);
      exit;
   end;
   if gsvIsEncrypted and (APassword = gsvPasswordIn) then exit;
   if (not gsvIsEncrypted) and (APassword='') then exit;
 try
   dState := dbCopy;
   if not gsvIsEncrypted then gsvPasswordIn := '';
   gsvPasswordOut := APassword;
   gsvIsEncrypted := true;
   if WithMemo then
   begin
      MemoObject := gsMemoObject;
      if MemoObject <> nil then
      begin
         MemoObject.IsEncrypted := true;
         MemoObject.PasswordIn := gsvPasswordIn;
         MemoObject.PasswordOut := gsvPasswordOut;
      end;
   end;
   rn := RecNumber;
   ix := IndexMaster;
   IndexMaster := nil;
   cr := CacheRead;
   gsSetDBFCache(true);
   gsGetRec(Top_Record);
   while not File_EOF do
   begin
      if WithMemo then gsRewriteMemoRecord;
      gsPutRec(RecNumber);
      gsGetRec(Next_Record);
   end;
   fl := HeadLen-33;               {Size of field descriptors}
   if FileVers = VFP3File then
      fl := fl - 263;
   GetMem(flds, fl);             {Allocate memory for fields buffer.}
   DBEncryption(gsvPasswordOut,PByteArray(Fields),flds,1,fl);
   inherited gsWrite(32, flds^, fl);          {Store field data}
   FreeMem(flds, fl);             {Allocate memory for fields buffer.}
   gsSetDBFCache(cr);
   IndexMaster := ix;
   for i := 1 to IndexesAvail do
   begin
      if IndexStack[i] <> nil then
         IndexStack[i].ixEncrypt;
   end;
   gsvPasswordIn := APassword;
   gsvIsEncrypted := APassword <> '';
   if WithMemo and (MemoObject <> nil) then
   begin
      MemoObject.IsEncrypted := gsvIsEncrypted;
      MemoObject.PasswordIn := gsvPasswordIn;
   end;
   dStatus := Updated;
   gsHdrWrite;
   gsGetRec(rn);
 finally
   dState := TmpState;
 end;
end;

procedure GSO_dBHandler.gsRewriteMemoRecord;
var
   fp     : integer;
   mbuf   : PChar;
   vcnt   : longint;
   rcnt   : longint;
   blk    : longint;
begin
   for fp := 1 to NumFields do
   begin
      if Fields^[fp].dbFieldType in ['B','G','M'] then
      begin
         blk := Trunc(gsNumberGetN(fp));
         if (blk <> 0) then
         begin
            vcnt := MemoObject.moMemoSize(blk) + 16;
            rcnt := vcnt;
            GetMem(mbuf, vcnt);
            MemoObject.moMemoRead(mbuf, blk, rcnt);
            MemoObject.moMemoWrite(mbuf, blk, rcnt);
            FreeMem(mbuf, vcnt);
         end;
      end;
   end;
end;

{------------------------------------------------------------------------------
                              Index Processing
------------------------------------------------------------------------------}

function GSO_dBHandler.gsIndex(const INames, Tag: gsUTFString): integer;  {!!RFG 030101}
var
   NameList: PChar;
   IName: PChar;
   NameListBegin: PChar;
   NameListEnd: PChar;
   NoLongName: boolean;
   rsl: integer;
begin
   rsl := 1;
   gsIndex := rsl;                                         {!!RFG 091297}
   gsIndexClear;
   if INames = '' then exit;
   GetMem(NameList,260);
   GetMem(IName,260);
   StrPCopy(NameList,INames);
   NameListBegin := NameList;
   NameListEnd := StrEnd(NameList);
   dec(NameListEnd);
   while (NameListEnd[0] in [' ',',',';']) and (NameListEnd >= NameListBegin) do
   begin
      NameListEnd[0] := #0;
      dec(NameListEnd);
   end;
   if StrLen(NameListBegin) > 0 then
   begin
      NameListEnd := NameListBegin;
      NoLongName := true;
      while NameListEnd[0] <> #0 do
      begin
         if NameListEnd[0] = '"' then NoLongName := not NoLongName;
         if NoLongName and (NameListEnd[0] in [',',';']) then   {!!RFG 040501}
            NameListEnd[0] := #9;
         inc(NameListEnd);
      end;
      repeat
         while NameListBegin[0] in [#9,'"'] do inc(NameListBegin);
         NameListEnd := NameListBegin;
         while not (NameListEnd[0] in [#9,'"',#0]) do inc(NameListEnd);
         StrLCopy(IName,NameListBegin,NameListEnd-NameListBegin);
         if StrLen(NameListBegin) > 0 then
            rsl := gsIndexRoute(Trim(StrPas(IName)));           {!!RFG 040501}
         NameListBegin := NameListEnd;
      until (rsl <> 0) or (NameListEnd[0] = #0);   {!!RFG 091297}
      if rsl = 0 then                              {!!RFG 091297}
         gsSetTagTo(Tag,true);
   end;
   gsIndex := rsl;                                 {!!RFG 091297}
   FreeMem(NameList,260);
   FreeMem(IName,260);
end;

function GSO_dBHandler.gsIndexFileExtend(const IName: gsUTFString): gsUTFString;
var
   IFile: gsUTFString;
begin
   IFile := IName;
   if ExtractFilePath(IFile) = '' then
      IFile := ExtractFilePath(FileName)+ IFile;
   gsIndexFileExtend := ChangeFileExtEmpty(IFile,IndexExt);
end;

function GSO_dBHandler.gsIndexFileIsOpen(const IName: gsUTFString): integer;
var
   i: integer;
begin
   gsIndexFileIsOpen := 0;;
   for i := 1 to IndexesAvail do
   begin
      if IndexStack[i] <> nil then
         if IndexStack[i].IsFileName(IName) then
            gsIndexFileIsOpen := i;
   end;
end;

function GSO_dBHandler.gsIndexFileRemove(const IName: gsUTFString): integer;
var
   iz: integer;
begin
   gsIndexFileRemove := 1;
   if IName = '' then exit;
   iz := gsIndexFileIsOpen(IName);
   if iz = 0 then exit;
   if (IndexMaster <> nil) and (IndexMaster.Owner = IndexStack[iz]) then
      gsSetTagTo('',true);
   IndexStack[iz].Free;
   IndexStack[iz] := nil;
   gsIndexFileRemove := 0;
end;

function GSO_dBHandler.gsIndexFileKill(const IName: gsUTFString): integer;  {!!RFG 091397}
var
   iz: integer;
   b: boolean;
begin
   gsIndexFileKill := 1;
   if IName = '' then exit;
   if not FileExists(IName) then exit;
   iz := gsIndexFileIsOpen(IName);
   if iz > 0 then
   begin
      if (IndexMaster <> nil) and (IndexMaster.Owner = IndexStack[iz]) then
         gsSetTagTo('',true);
      IndexStack[iz].Free;
      IndexStack[iz] := nil;
   end;
   if not DeleteFile(IName) then
   begin
      iz := FileOpen(IName,fmOpenReadWrite+fmShareDenyNone);
      if iz > 0 then
      begin
         b := gsSysTruncate(iz,0) <> -1;
         FileClose(iz);
         if not b then exit;
      end
      else exit;
   end;
   gsIndexFileKill := 0;
end;

function GSO_dBHandler.gsIndexKeyValue(Value: integer; ExpVar: TgsVariant): boolean;
var
   p: GSobjIndexTag;
begin
   p := gsIndexPointer(Value);
   Result := p <> nil;
   if Result then
   begin
      p.ExprHandlr.ExpressionAsVariant(expvar);
   end;
end;

Procedure GSO_dBHandler.gsIndexOrder(Value: integer);
var
   p: GSobjIndexTag;
begin
   p := gsIndexPointer(Value);
   if p <> nil then
      gsSetTagTo(p.TagName,true)
   else
      gsSetTagTo('',true);
end;

Function GSO_dBHandler.gsIndexPointer(Value: integer): GSobjIndexTag;
var
   i: integer;
   n: integer;
   n1: integer;
   p: GSobjIndexTag;
begin
   p := nil;
   if Value > 0 then
   begin
      n := 0;
      n1 := 0;
      i := 1;
      while (n < Value) and (i <= IndexesAvail) do
      begin
         if IndexStack[i] <> nil then
         begin
            n1 := n1 + IndexStack[i].TagCount;
            if n1 >= Value then
            begin
               n1 := Value - n;
               n := Value;
               p := IndexStack[i].TagByNumber(pred(n1));
            end
            else
               n := n1;
         end;
         inc(i);
      end;
   end;
   gsIndexPointer := p;
end;

function GSO_dBHandler.gsIndexTagRemove(const IName, Tag: gsUTFString): integer;
var
   i   : integer;                     {Local working variable  }
   pc: array [0..16] of char;
   px: GSobjIndexTag;
   ix: GSobjIndexFile;
begin
   gsIndexTagRemove := 1;
   if Tag = '' then exit;
   StrPCopy(pc,Trim(Tag));
   ix := nil;
   px := nil;
   i := 0;
   while (i < IndexesAvail) and (px = nil) do
   begin
      inc(i);
      if IndexStack[i] <> nil then
      begin
         ix := IndexStack[i];
         px := ix.TagByName(pc);
      end;
   end;
   if (px <> nil) and (px = IndexMaster) then
      gsSetTagTo('',true);
   if px <> nil then
   begin
      gsIndexTagRemove := -1;
      if ix.DeleteTag(pc) then
      begin
         gsIndexTagRemove := 0;
         if ix.TagCount = 0 then
            gsIndexFileRemove(ix.GetFileName);
      end;
   end;
end;

function GSO_dBHandler.gsIndexRoute(const IName: gsUTFString): integer;
var
   IExt: gsUTFString;
   IFile: gsUTFString;
   ix: GSobjIndexFile;
begin
   gsIndexRoute := -1;
   if IName = '' then exit;
   IFile := gsIndexFileExtend(IName);
   if (gsIndexFileIsOpen(IFile) <> 0)then exit;
   IExt := ExtractFileExt(IFile);
   ix := nil;
{$IFDEF FOXOK}
   if gsStrCompareI(IExt, '.CDX') = 0 then
   begin
      ix := GSobjCDXFile.Create(Self,IName,FileReadWrite,FileShared,false,false);
   end;
{$ENDIF}
{$IFDEF CLIPOK}
   if gsStrCompareI(IExt, '.NTX') = 0 then
   begin
      ix := GSobjNTXFile.Create(Self,IName,FileReadWrite,FileShared,false,false);
   end;
{$ENDIF}
{$IFDEF DBASE4OK}
   if gsStrCompareI(IExt, '.MDX') = 0 then
   begin
      ix := GSobjMDXFile.Create(Self,IName,FileReadWrite,FileShared,false,false);
   end;
{$ENDIF}
{$IFDEF DBASE3OK}
   if gsStrCompareI(IExt, '.NDX') = 0 then
   begin
      ix := GSobjNDXFile.Create(Self,IName,FileReadWrite,FileShared,false,false);
   end;
{$ENDIF}

   if (ix = nil) or (not ix.CreateOK) then           {!!RFG 091297}
   begin
      if (ix <> nil) and (ix.Corrupted) then          {!!RFG 091297}
      begin
         raise EHalcyonError.CreateFmt(gsErrIndexCorrupted,[IFile]);
      end
      else
      begin
         raise EHalcyonError.CreateFmt(gsErrNoSuchFile,[IFile]);
      end;
      if ix <> nil then ix.Free;                      {!!RFG 091297}
   end
   else
   begin
      gsIndexRoute := 0;
      gsIndexInsert(ix);
      ix.ixSetLockProtocol(dfLockStyle);
   end;
end;

Procedure GSO_dBHandler.gsIndexClear;
var
   i: integer;
begin
   for i := 1 to IndexesAvail do
      if IndexStack[i] <> nil then
      begin
         IndexStack[i].Free;
         IndexStack[i] := nil;
      end;
   IndexMaster := nil;               {Set index active flag to false}
   PrimaryTagName[0] := #0;
{   IndexHandle := -1;}
end;

Function GSO_dBHandler.gsIndexInsert(ix : GSobjIndexFile) : integer;
var
   i   : integer;                     {Local working variable  }
begin
   i := 1;
   while (IndexStack[i] <> nil) and (i <= IndexesAvail) do inc(i);
   if i <= IndexesAvail then
   begin
      IndexStack[i] := ix;
      gsIndexInsert := i;
   end else gsIndexInsert := -1;
end;

Function GSO_dBHandler.gsIndexTo(const IName, tag, keyexpr, forexpr: gsUTFString;
                               uniq: GSsetIndexUnique;
                               ascnd: GSsetSortStatus): integer;
var
   IFile: gsUTFString;
   ITag: gsUTFString;
   IExt: gsUTFString;
   FormK: gsUTFString;
   FormF: gsUTFString;
   crd: boolean;
   ix: GSobjIndexFile;
begin
   crd := CacheRead;
   gsIndexTo := 0;
   gsIndexClear;
   gsSetDBFCache(true);
   IFile := gsIndexFileExtend(IName);
   IExt := ExtractFileExt(IName);
   if IExt = '' then IExt := IndexExt;
   FormK := keyexpr;
   ITag := tag;
   FormF := forexpr;
   ix := nil;
{$IFDEF FOXOK}
   if gsStrCompareI(IExt,'.cdx') = 0 then
   begin
      if (Length(ITag) = 0) then
      begin
         raise EHalcyonError.CreateFmt(gsErrIndexTagMissing,[ITag]);
      end;
      ix := GSobjCDXFile.Create(Self, IFile, FileReadWrite,FileShared,true,false);
      if ix <> nil then
      begin
         if ascnd in [AscendingGeneral, DescendingGeneral] then
         begin
            {$IFNDEF FOXGENERAL}
            raise EHalcyonError.CreateFmt(gsErrIndexCollate,[IFile]);
            {$ENDIF}
            GSbytCDXCollateInfo := General;
         end
         else
            GSbytCDXCollateInfo := Machine;
      end;
   end;
{$ENDIF}
{$IFDEF DBASE4OK}
   if gsStrCompareI(IExt,'.mdx') = 0 then
   begin
      if (Length(ITag) = 0) then
      begin
         raise EHalcyonError.CreateFmt(gsErrIndexTagMissing,[ITag]);
      end;
      ix := GSobjMDXFile.Create(Self, IFile, FileReadWrite,FileShared,true,false);
   end;
{$ENDIF}
{$IFDEF CLIPOK}
   if gsStrCompareI(IExt,'.ntx') = 0 then
   begin
      ITag := ExtractFileNameOnly(IFile);
      ix := GSobjNTXFile.Create(Self, IFile, FileReadWrite,FileShared,true,true);
   end;
{$ENDIF}
{$IFDEF DBASE3OK}
   if gsStrCompareI(IExt,'.ndx') = 0 then
   begin
      ITag := ExtractFileNameOnly(IFile);
      ix := GSobjNDXFile.Create(Self, IFile,FileReadWrite,FileShared,true,true);
   end;
{$ENDIF}
   if (ix <> nil) and (ix.CreateOK) then
   begin
      ix.Dictionary := ascnd in [AscendingGeneral, DescendingGeneral];
      if ascnd = AscendingGeneral then
         ascnd := Ascending
      else
         if ascnd = DescendingGeneral then
            ascnd := Descending;
      dState := dbIndex;
      try
         ix.AddTag(ITag, FormK, FormF, Ascnd=Ascending, Uniq=Unique);
      finally
         ix.Free;
         dState := dbBrowse;
      end;
   end
   else
   begin
      if (ix <> nil) and (ix.Corrupted) then            {!!RFG 091297}
         raise EHalcyonError.CreateFmt(gsErrIndexCorrupted,[IFile])
      else
         raise EHalcyonError.CreateFmt(gsErrNoSuchFile,[IFile]);
      if ix <> nil then ix.Free;
   end;
   gsSetDBFCache(crd);
end;

Function GSO_dBHandler.gsMemoryIndexAdd(const tag, keyexpr, forexpr: gsUTFString;
                                        uniq: GSsetIndexUnique;
                                        ascnd: GSsetSortStatus): boolean;
var
   ITag: gsUTFString;
   FormK: gsUTFString;
   FormF: gsUTFString;
   ix: GSobjIndexFile;
begin
   ITag := gsStrUpperCase(Trim(tag));
   FormK := Trim(keyexpr);
   if (Length(ITag) = 0) then
      raise EHalcyonError.CreateFmt(gsErrIndexTagEmpty,['']);
   if (Length(FormK) = 0) then
      raise EHalcyonError.CreateFmt(gsErrIndexKey,['']);
   gsIndexFileRemove(ITag);
   FormF := Trim(forexpr);
   ix := GSobjMIXFile.Create(Self, ITag);
   if (ix <> nil) and (ix.CreateOK) then
   begin
      if ascnd in [AscendingGeneral, DescendingGeneral] then
      begin
         {$IFNDEF FOXGENERAL}
         raise EHalcyonError.CreateFmt(gsErrIndexCollate,[ITag+'(Memory)']);
         {$ENDIF}
         GSbytCDXCollateInfo := General;
      end
      else
         GSbytCDXCollateInfo := Machine;
      ix.Dictionary := ascnd in [AscendingGeneral, DescendingGeneral];
      if ascnd = AscendingGeneral then
         ascnd := Ascending
      else
         if ascnd = DescendingGeneral then
            ascnd := Descending;
      ix.AddTag(ITag, FormK, FormF, Ascnd=Ascending, Uniq=Unique);
      gsIndexInsert(ix);
      gsSetTagTo(tag,false);
      gsMemoryIndexAdd := true;
   end
   else
   begin
      if ix <> nil then ix.Free;
      raise EHalcyonError.CreateFmt(gsErrIndexCorrupted,[ITag+'(Memory)']);
   end;
end;

Function GSO_dBHandler.gsSetTagTo(const TName: gsUTFString; SameRec: boolean): integer;
var
   i   : integer;                     {Local working variable  }
   pc: array [0..16] of char;
   px: GSobjIndexTag;
begin                                      {!!RFG 043098}
   if TName = '' then
   begin
      gsResetRange;
      if IndexMaster <> nil then IndexMaster.TagClose;
      IndexMaster := nil;
      gsSetDBFCache(true);
      if not SameRec then gsGetRec(Top_Record);
      gsSetTagTo := 0;
      exit;
   end;
   StrPCopy(pc,gsStrUpperCase(Trim(TName)));
   px := nil;
   i := 0;
   while (i < IndexesAvail) and (px = nil) do
   begin
      inc(i);
      if IndexStack[i] <> nil then
         px := IndexStack[i].TagByName(pc);
   end;
   if px = nil then
   begin
      raise EHalcyonError.CreateFmt(gsErrIndexTagMissing,[TName]);  {%FIX0016 raise exception for missing index tag}
   end;
   gsResetRange;
   if IndexMaster <> nil then IndexMaster.TagClose;
   IndexMaster := nil;
   gsSetDBFCache(false);
   StrCopy(PrimaryTagName,pc);
   IndexMaster := px;
   IndexMaster.TagOpen(1);
   if not SameRec then
      gsGetRec(Top_Record)
   else
   begin
      gsGetRec(RecNumber);       {%FIX 0002 Keep same record when changing tags}
      if ResyncIndex then
         gsGetRec(Top_Record);   {If record not in index then reset to TOF}
   end;
   gsSetTagTo := i;
end;

Procedure GSO_dBHandler.gsReIndex;
var
   rxIndexMaster : GSobjIndexTag;
   i   : integer;
   crd: boolean;
begin
   rxIndexMaster := IndexMaster;
   IndexMaster := nil;
   crd := CacheRead;             {!!RFG 041398}
   dState := dbIndex;
   gsSetDBFCache(true);          {!!RFG 041398}
  {$IFDEF DELPHI}try{$ENDIF}
   for i := 1 to IndexesAvail do
   begin
      if IndexStack[i] <> nil then
         IndexStack[i].ReIndex;
   end;
  {$IFDEF DELPHI}finally{$ENDIF}
   dState := dbBrowse;
   gsSetDBFCache(crd);           {!!RFG 041398}
   {$IFDEF DELPHI}end;{$ENDIF}
   IndexMaster := rxIndexMaster;
   if IndexMaster <> nil then IndexMaster.TagOpen(0);
   gsGetRec(Top_Record);
end;


{------------------------------------------------------------------------------
                  File Modifying Routine (Sort, Copy, Pack, Zap)
------------------------------------------------------------------------------}

Procedure GSO_dBHandler.gsCopyFile(const filname, apassword: gsUTFString);
var
   FCopy  : GSO_dBHandler;
   RecPos : longint;
   rsl: boolean;
   tc: integer;
begin
   tc := GSwrdAccessMiliSeconds div GSwrdAccessMSecDelay;
   repeat
      rsl := gsLockFile;
      if not rsl then
      begin
         gsSysSleep(GSwrdAccessMSecDelay);
         dec(tc);
      end;
   until rsl or (tc = 0);
   if not rsl then
      raise EHalcyonError.CreateFmt(gsErrNoFullAccess, ['CopyFile',FileName]);
   gsHdrRead;
   gsStatusUpdate(StatusStart,StatusCopy,NumRecs);
   RecPos := RecNumber;
   gsCopyStructure(filname);
   FCopy := GSO_dBHandler.Create(filname, '',true,false);
   FCopy.gsSetPassword(apassword);
   FCopy.gsLockFile;
   if WithMemo then
   begin
      MemoObject := gsMemoObject;
      FCopy.MemoObject := FCopy.gsMemoObject;
   end;
   gsGetRec(Top_Record);
   while not File_EOF do           {Read .DBF sequentially}
   begin
      gsStatusUpdate(StatusCopy,RecNumber,0);
      move(CurRecord^,FCopy.CurRecord^,RecLen+1);
      if WithMemo then gsCopyMemoRecord(FCopy);
      FCopy.gsAppend;
      gsGetRec(Next_Record);
   end;
   FCopy.gsLockOff;
   FCopy.Free;
   gsStatusUpdate(StatusStop,0,0);
   gsGetRec(RecPos);
   gsLockOff;
END;                        { CopyFile }

Procedure GSO_dBHandler.gsCopyRecord;  {(filobj : GSO_dBHandler);}
BEGIN
   move(CurRecord^,filobj.CurRecord^,RecLen+1);
   if WithMemo then
   begin
      MemoObject := gsMemoObject;
      filobj.MemoObject := filobj.gsMemoObject;
      gsCopyMemoRecord(filobj);
   end;
   filobj.gsAppend;
END;                        { CopyRecord }

procedure GSO_dBHandler.gsCopyMemoRecord(df : GSO_dbHandler);
var
   fp     : integer;
   mbuf   : PChar;
   rl     : FloatNum;
   tcnt   : longint;
   vcnt   : longint;
   rcnt   : longint;
   blk    : longint;
begin
   for fp := 1 to NumFields do
   begin
      if Fields^[fp].dbFieldType in ['B','G','M'] then
      begin
         blk := Trunc(gsNumberGetN(fp));
         if (blk <> 0) then
         begin
            vcnt := MemoObject.moMemoSize(blk) + 16;
            rcnt := vcnt;
            GetMem(mbuf, vcnt);
            MemoObject.moMemoRead(mbuf, blk, rcnt);
            tcnt := 0;
            df.MemoObject.moMemoWrite(mbuf, tcnt, rcnt);
            rl := tcnt;
            df.gsNumberPutN(fp,rl);
            FreeMem(mbuf, vcnt);
         end;
      end;
   end;
end;

procedure GSO_dBHandler.gsCopyStructure(const filname: gsUTFString);
var
   NuFile : GSO_DBFBuild;
   fp     : integer;
BEGIN
   case FileTarget of
      DB4WithMemo  : NuFile := GSO_DB4Build.Create(filname);
      FxPWithMemo  : NuFile := GSO_DBFoxBuild.Create(filname);
      else NuFile := GSO_DB3Build.Create(filname);
   end;
   for fp := 1 to NumFields do
      NuFile.InsertField(gsFieldName(fp),Fields^[fp].dbFieldType,
                          Fields^[fp].dbFieldLgth,Fields^[fp].dbFieldDec);
   NuFile.Free;
END;

Procedure GSO_dBHandler.gsPack;
var
   rxIndexMaster : GSobjIndexTag;
   fp            : integer;
   i, j          : longint;
   eofm: char;
   dbfchgd: boolean;
   crd: boolean;
begin      {Pack}
   eofm := EOFMark;
   if FileShared then
   begin
      raise EHalcyonError.CreateFmt(gsErrNoFullAccess, ['Pack',FileName]);
   end;
   rxIndexMaster := IndexMaster;
   crd := CacheRead;
   if WithMemo then
      MemoObject := gsMemoObject;
   IndexMaster := nil;               {Set index active flag to false}
   gsSetDBFCache(false);  {!!RGF 040698}   {Clear any current cached records}
   gsSetDBFCache(true);
   gsStatusUpdate(StatusStart,StatusPack,NumRecs);
   j := 0;
   for i := 1 to NumRecs do           {Read .DBF sequentially}
   begin
      gsRead(HeadLen+((i-1) * RecLen), CurRecord^, RecLen);
      if gsvIsEncrypted then
         DBEncryption(gsvPasswordIn,PByteArray(CurRecord),PByteArray(CurRecord),0,RecLen);
      RecNumber := i;
      if not gsDelFlag then             {Write to work file if not deleted}
      begin
         inc(j);                      {Increment record count for packed file }
         if j <> i then inherited gsPutRec(j);
      end
      else
         if WithMemo then
         begin
            for fp := 1 to NumFields do
            begin
               if Fields^[fp].dbFieldType in ['B','G','M'] then
               begin
                  MemoObject.MemoLocation := Trunc(gsNumberGetN(fp));
                  if (MemoObject.MemoLocation <> 0) then
                     MemoObject.moMemoBlockRelease(MemoObject.MemoLocation);
               end;
            end;
         end;
      gsStatusUpdate(StatusPack,i,0);
   end;
   dbfchgd := NumRecs > j;         {If records were deleted then...}
   if dbfchgd then
   begin
      NumRecs := j;                   {Store new record count in objectname}
      gsWrite(HeadLen+(j*RecLen), eofm, 1);
                                      {Write End of File byte at file end}
      gsTruncate(HeadLen+(j*RecLen)+1);
                                      {Set new file size for dBase file};
      dStatus := Updated;
      gsHdrWrite;
   end;
   gsStatusUpdate(StatusStop,0,0);
{ 03/28/99             Removed - the MemoObject must be set nil if doing this}
{                      Better to leave it assigned since it may be in use}
{
   if WithMemo then
      curMemo.Free;
}
   if dbfchgd then gsReIndex;
   IndexMaster := rxIndexMaster;
   gsSetDBFCache(crd);
   if IndexMaster <> nil then
   begin
      IndexMaster.TagOpen(0);
   end;
   gsGetRec(Top_Record);
END;                        { Pack }

                     {-------------------------------}

{-----------------------------------------------------------------------------
                               File Sorting Routines
-----------------------------------------------------------------------------}

Procedure GSO_dBHandler.gsLoadToIndex(ixColl: GSobjSortDB; zfld: PChar);
var
   exph: TgsExpHandler;
   Rsl: TgsVariant;
begin
   exph := TgsExpHandler.Create(DBFExpLink,zfld,false);
   Rsl := TgsVariant.Create(256);
   try
      gsStatusUpdate(StatusStart,StatusSort,NumRecs);
      gsGetRec(Top_Record);             {Read all dBase file records}
      while not File_EOF do
      begin
         exph.ExpressionAsVariant(rsl);
         ixColl.AddKey(Rsl,RecNumber);
         gsStatusUpdate(StatusSort,RecNumber,0);
         gsGetRec(Next_Record);
      end;
      gsStatusUpdate(StatusStop,0,0);
   finally
      Rsl.Free;
      exph.Free;
   end;
end;

procedure GSO_dBHandler.gsCopyFromIndex(ixColl: GSobjSortDB; const filname, apassword: gsUTFString);
var
   FCopy  : GSO_dBHandler;
BEGIN
   gsStatusUpdate(StatusStart,StatusCopy,ixColl.Count);
   ixColl.KeyCnt := 0;
   gsCopyStructure(filname);
   FCopy := GSO_dBHandler.Create(filname,'',true,false);
   FCopy.gsSetPassword(apassword);
   if WithMemo then
   begin
      MemoObject := gsMemoObject;
      FCopy.MemoObject := FCopy.gsMemoObject;
   end;
   ixColl.curFile := Self;
   ixColl.newFile := FCopy;
   ixColl.OutputWord;
   FCopy.Free;
   gsStatusUpdate(StatusStop,0,0);
end;

Procedure GSO_dBHandler.gsSortFile(const filname, apassword, zfld: gsUTFString; isascend : GSsetSortStatus);
var
   nufile: gsUTFString;
   iext: gsUTFString;
   zzf: gsUTFString;
   ixColl: GSobjSortDB;
   rn    : longint;
   frslt : integer;
   zlen: integer;
   pckey: PChar;
begin
   zzf := trim(zfld);
   zlen := Length(zzf);
   if (zlen = 0) or (zlen > 240) then
      raise EHalcyonError.CreateFmt(gsErrSortLength, [MaxSortSize,zlen]);
   nufile := Trim(filname);
   iext := ExtractFileExt(nufile);
   if length(iext) = 0 then
      nufile := nufile+'.dbf';
   frslt := FileOpen(nufile,fmOpenReadWrite + fmShareExclusive);
   if frslt > 0 then
   begin
      FileClose(frslt);
   end
   else
   begin
      if not FileExists(nufile) then
         raise EHalcyonError.CreateFmt(gsErrNoFullAccess, ['SortFile',nufile]);
   end;
   GetMem(pckey,255);
   StrPCopy(pckey,zzf);
   rn := RecNumber;
   if rn = 0 then rn := Top_Record;
   ixColl := GSobjSortDB.Create(240,false,isascend=SortUp,gsvTempDir);
   gsLoadToIndex(ixColl, pckey);
   gsCopyFromIndex(ixColl, filname, apassword);
   FreeMem(pckey,255);
   ixColl.Free;
   gsGetRec(rn);
end;

                     {-------------------------------}

Procedure GSO_dBHandler.gsZap;
var
   mbuf : array[0..dBaseMemoSize] of byte;
   i : longint;                    {Local variables   }
   ib: byte;
   eofm: char;
begin              {Zap}
   eofm := EOFMark;
   if FileShared then
   begin
      raise EHalcyonError.CreateFmt(gsErrNoFullAccess, ['Zap',FileName]);
   end;
   if WithMemo then
   begin
      MemoObject := gsMemoObject;
      MemoObject.gsRead(0,mbuf,512);
      i := 0;
      move(i,mbuf[0],SizeOf(i));
      if (MemoObject.TypeMemo = FXPWithMemo) or (MemoObject.TypeMemo = VFP3File) then
      begin
         ib := 512 div FoxMemoSize;
         if (512 mod FoxMemoSize) <> 0 then inc(ib);
         mbuf[3] := ib;
      end
      else
      begin
         ib := 1;
         mbuf[0] := ib;
      end;
      MemoObject.gsWrite(0,mbuf,512);
      MemoObject.gsTruncate(512);
      MemoObject.Free;
      MemoObject := nil;
   end;
   NumRecs := 0;                   {Store new record count in objectname}
   RecNumber := 0;
   dStatus := Updated;
   gsWrite(HeadLen, eofm, 1);
   gsTruncate(HeadLen+1);
   gsHdrWrite;
   gsGetRec(Top_Record);
   gsReIndex;
END;                        { Zap }

function GSO_dBHandler.gsLocateRecord(const KeyFields: gsUTFString; const KeyValues: Variant;
                                      IsInsensitive, IsPartial: boolean): Boolean;
var
   s1: gsUTFString;
   s2: gsUTFString;
   rxIndexMaster: GSobjIndexTag;
   tpIndexMaster: GSobjIndexTag;
   wkIndexTag: GSobjIndexTag;
   i: integer;
   j: integer;
   Psn: integer;
   expvar: TgsVariant;
   crd: boolean;
   matching: boolean;
   locating: boolean;
   tsl: TStringList;
   tslv: TStringList;
   cr: pointer;
begin
   Result := false;
   gsGetRec(Top_Record);
   if File_TOF then exit;
   cr := CurRecord;
   gsStuffABuffer(PChar(CurRecord),KeyFields,KeyValues);
   CurRecord := cr;
   rxIndexMaster := IndexMaster;
   tpIndexMaster := nil;
   if (not ((IndexMaster <> nil) and (IndexMaster.RangeActive))) then
   begin
      s1 := gsStrUpperCase(KeyFields);
      if s1[length(s1)] <> ';' then s1 := s1 + ';';
      wkIndexTag := IndexMaster;
      i := 0;
      if wkIndexTag = nil then   {if natural order, get first index}
      begin
         inc(i);
         wkIndexTag := gsIndexPointer(i);
      end;
      while (wkIndexTag <> nil) and (tpIndexMaster = nil) do
      begin
         if wkIndexTag <> nil then
         begin
            if (i=0) or (Length(wkIndexTag.ForExpr) = 0) then {if assigned index or not conditional}
            begin
               s2 := wkIndexTag.ExprHandlr.EnumerateType(gsSQLTypeVarDBF);
               if Length(s2) = 0 then s2 := ';';
               if s2[length(s2)] <> ';' then s2 := s2 + ';';
               for j := 1 to length(s2) do
                  if (s2[j] in ['+','-']) then s2[j] := ';';
               if length(s2) > length(s1) then
                  s2 := copy(s2,1,length(s1));
               if s2 = s1 then
                  tpIndexMaster := wkIndexTag;
            end;
         end;
         inc(i);
         wkIndexTag := gsIndexPointer(i);
      end;
   end;
   if tpIndexMaster <> nil then
   begin
      IndexMaster := tpIndexMaster;
      expvar := TgsVariant.Create(256);
      try
         tpIndexMaster.ExprHandlr.ExpressionAsVariant(expvar);
         s2 := expvar.GetString;
      finally
         expvar.Free;
      end;
      gsvExactMatch := not IsPartial;
      gsvFindNear := false;
      Result := gsFind(s2);
   end
   else
   begin
      crd := CacheRead;
      if (not ((IndexMaster <> nil) and (IndexMaster.RangeActive))) then
      begin
         IndexMaster := nil;
         gsSetDBFCache(true);
      end;
      tsl := TStringList.Create;
      tsl.Sorted := false;
      tslv := TStringList.Create;
      tslv.Sorted := false;
      try
         Psn := 1;
         while Psn < length(KeyFields) do
         begin
            s1 := gsExtractFieldName(KeyFields,Psn);
            tsl.Add(s1);
            s2 := gsStringGet(s1);
            if IsInsensitive then s2 := gsStrUpperCase(s2);
            tslv.Add(s2);
         end;
         locating := true;
         gsGetRec(Top_Record);             {Read all dBase file records}
         while locating and (not File_EOF) do
         begin
            i := 0;
            matching := true;
            while (i < tsl.Count) and matching do
            begin
               s1 := gsStringGet(tsl[i]);
               if IsInsensitive then s1 := gsStrUpperCase(s1);
               s2 := tslv[i];
               if IsPartial and (i = tsl.Count-1) then
                  s1 := copy(s1,1,length(s2));
               matching :=  s1 = s2;
               inc(i);
            end;
            locating := not matching;
            if locating then
               gsGetRec(Next_Record);
         end;
         Result := not locating;
         gsSetDBFCache(crd);
      finally
         tslv.Free;
         tsl.Free;
      end;
   end;
   IndexMaster := rxIndexMaster;
   if Result then
      gsGetRec(RecNumber);
end;


function GSO_dBHandler.gsBuildKey(const KeyValues: array of const; ExprHandler: TgsExpHandler): gsUTFString;
const
  BoolChars: array[Boolean] of Char = ('F', 'T');
var
   Psn: integer;
   Ctr: integer;
   il: gsUTFString;
   cf: gsUTFString;
   cv: Variant;
   tsl: TStringList;
   buf: PChar;
   expvar: TgsVariant;
   alh: integer;
begin
   Result := '';
   alh := High(KeyValues);
   GetMem(buf,RecLen);
   tsl := TStringList.Create;
   try
      tsl.Clear;
      il := ExprHandler.EnumerateType(gsSQLTypeVarDBF);
      if length(il) > 0 then
      begin
         Psn := 1;
         while Psn < length(il) do
         begin
            cf := gsExtractFieldName(il,Psn);
            if tsl.Count <= alh then
               tsl.Add(cf);
         end;
      end;
      cv := VarArrayCreate([0, alh], varVariant);
      for Ctr := 0 to High(KeyValues) do
        with KeyValues[Ctr] do
          case VType of
             vtInteger:    cv[Ctr] :=  IntToStr(VInteger);
             vtBoolean:    cv[Ctr] :=  BoolChars[VBoolean];
             vtChar:       cv[Ctr] :=  VChar;
             vtExtended:   cv[Ctr] :=  FloatToStr(VExtended^);
             vtString:     cv[Ctr] :=  VString^;
             vtPChar:      cv[Ctr] :=  StrPas(VPChar);
             vtAnsiString: cv[Ctr] :=  gsUTFString(VAnsiString);
             vtCurrency:   cv[Ctr] :=  CurrToStr(VCurrency^);
             vtVariant:    cv[Ctr] :=  gsUTFString(VVariant^);
            {$IFDEF VER120}
             vtInt64:      cv[Ctr] :=  IntToStr(VInt64^);
            {$ENDIF}
          end;
      il := '';
      for Ctr := 0 to alh do
         il := il+tsl[Ctr]+';';
      gsStuffABuffer(buf,il,cv);
      CurRecord := pointer(buf);
      expvar := TgsVariant.Create(256);
      try
         ExprHandler.ExpressionAsVariant(expvar);
         Result := expvar.GetString;
      finally
         expvar.Free;
      end;
      CurRecord := CurRecHold;
   finally
     tsl.Free;
     FreeMem(buf,RecLen);
   end;
end;

{------------------------------------------------------------------------------
                           Database Search Routine
------------------------------------------------------------------------------}

Function GSO_dBHandler.gsSearchDBF(const s : gsUTFString; var FNum : word;
                          var fromrec: longint; toRec: longint): word;
var
   BTable: gsUTFString;
   MTable: gsUTFString;
   crd : boolean;
   ia : pointer;
   lr : longint;
   sloc: word;
   i   : integer;
   Strt: word;
   Size: word;
   rnum: longint;
   rsl : integer;
   ns  : real;
   rs  : real;
   di  : longint;
   dr  : longint;
   li  : boolean;
   lv  : boolean;
   mp  : integer;
   ml  : integer;
   mc  : integer;
   fstrt: integer;
   ffini: integer;
   floc: integer;
   multifld: boolean;
   caseinsensitive: boolean;
   matchexact: boolean;
   usewildcards: boolean;
   useindex: boolean;
   usefilter: boolean;
   astrbegin: boolean;
   astrend: boolean;
   hasqmarks: boolean;
   startonly: boolean;
   bfr: PByteArray;
   bpat: pointer;

   function MatchField: integer;
   var
      mfi: integer;
      mfe: integer;
   begin
      MatchField := 0;
      if length(MTable) < length(BTable) then exit;
      if caseinsensitive then
         MTable := gsStrUpperCase(MTable);
      if hasqmarks then
         for mfi := 1 to length(BTable) do
            if BTable[mfi] = '?' then MTable[mfi] := '?';
      if matchexact then
      begin
         MTable := copy(MTable,1,length(BTable));
         if BTable = MTable then MatchField := 1;
      end
      else
      begin
         mfi := pos(BTable,MTable);
         if (mfi > 1) and (not astrbegin) then mfi := 0;
         if (mfi > 0) and (not astrend) then
         begin
            MTable := TrimRight(MTable);
            mfe := mfi + length(BTable) - 1;
            if length(MTable) > mfe then mfi := 0;
         end;
         MatchField := mfi;
      end;
   end;


begin
   rnum := 1;
   sloc := 0;
   if (FNum > NumFields) or (length(s) = 0) then
   begin
      gsSearchDBF := 0;
      exit;
   end;

   caseinsensitive := (SearchMode and 1) <> 0;
   matchexact := (SearchMode and 2) <> 0;
   usewildcards := (SearchMode and 4) <> 0;
   usefilter := (SearchMode and 8) <> 0;
   useindex := (SearchMode and 16) <> 0;
   startonly := (SearchMode and 32) <> 0;

{   if toRec = 0 then toRec := NumRecs;}
   fstrt := FNum;
   ffini := FNum;
   multifld := FNum = 0;
   if multifld then
   begin
      fstrt := 1;
      ffini := numFields;
   end;
   if caseinsensitive then
      BTable := gsStrUpperCase(s)
   else
      BTable := s;
   if usewildcards then
   begin
      astrbegin := BTable[1] = '*';
      astrend := BTable[length(BTable)] = '*';
      if astrbegin then system.delete(BTable,1,1);
      if astrend and (length(BTable) > 0) then
         system.delete(BTable,length(BTable),1);
      if astrbegin then
         hasqmarks := false
      else
         hasqmarks := pos('?',BTable) <> 0;
      if astrbegin or astrend or hasqmarks then
         matchexact := false;
   end
   else
   begin
      astrbegin := not startonly;
      astrend := not matchexact;
      hasqmarks := false;
   end;
   di := -2;
   val(s,ns,rsl);
   if rsl <> 0 then ns := 0.0;
   li := pos(s[1],LogicalTrue) > 0;
   gsStatusUpdate(StatusStart,StatusSearch,NumRecs);
   lr := RecNumber;
   ia := IndexMaster;

   if (not usefilter) and UseDeletedRec then
      dState := dbIndex;

   if (not useindex) then
      IndexMaster := nil;
   crd := CacheRead;
   if IndexMaster = nil then
      gsSetDBFCache(true);
   {$IFDEF DELPHI}try{$ENDIF}
   if fromrec = 0 then
      gsGetRec(Top_Record)
   else
   begin
      gsGetRec(fromrec);
      gsSkip(1);
   end;
   while (not File_EOF) and ((RecNumber <= toRec) or (torec = 0)) and
         (sloc = 0) do
   begin
      floc := fstrt;
      repeat
         FNum := floc;
         Strt := 1;
         if FNum > 1 then
            for i := 1 to FNum-1 do
               Strt := Strt + gsFieldLength(i);
         if sloc = 0 then
         case gsFieldType(FNum) of
         'C' : begin
                  MTable := gsFieldGetN(FNum);
                  sloc := MatchField;
               end;
         'F',
         'N' : begin
                  sloc := 0;
                  if rsl = 0 then
                  begin
                     rs := gsNumberGetN(FNum);
                     if rs = ns then sloc := 1;
                  end;
               end;
         'D' : begin
                  if di = -2 then
                  if (s[1] in ['0'..'9']) then
                  begin
                     try
                        di := DBFDate.CTOD(s);
                     except
                        di := -1;
                     end
                  end
                  else
                  begin
                     di := -1;
                  end;
                  sloc := 0;
                  dr := gsDateGetN(FNum);
                  if di = dr then sloc := 1;
               end;
         'L' : begin
                  sloc := 0;
                  if not multifld then
                  begin
                     lv := gsLogicGetN(FNum);
                     if li = lv then sloc := 1;
                  end;
               end;
         'M' : begin
                  ml := gsMemoSizeN(FNum);
                  if ml > 0 then
                  begin
                     GetMem(bfr,ml+1);
                     try
                        bfr^[ml] := 0;
                        gsMemoLoadN(FNum, bfr, ml);
                        bpat := @BTable[1];
                        if caseinsensitive then
                           mp := SearchBufI(bpat,bfr,0,length(BTable),ml)
                        else
                           mp := SearchBuf(bpat,bfr,0,length(BTable),ml);
                        if mp <> -1 then
                           if mp < $10000 then
                              sloc := mp and $0000FFFF
                           else
                              sloc := $FFFF;
                     finally
                        FreeMem(bfr,ml+1);
                     end;
                  end;
               end;
         end;
         inc(floc);
      until (floc > ffini) or (sloc > 0);
       if sloc = 0 then
      begin
         inc(rnum);
         gsStatusUpdate(StatusSearch,rnum,0);
         gsGetRec(Next_Record);
      end;
   end;
   {$IFDEF DELPHI}finally{$ENDIF}
   dState := dbBrowse;
   gsSetDBFCache(crd);
   IndexMaster := ia;
   if sloc > 0 then
   begin
      fromrec := RecNumber;
      gsGetRec(fromrec);            {Reset for index}
   end
   else
      if lr > 0 then gsGetRec(lr);
   gsSearchDBF := sloc;
   gsStatusUpdate(StatusStop,rnum,0);
   {$IFDEF DELPHI}end;{$ENDIF}
end;

{-----------------------------------------------------------------------------
                               GSobjSortDB
-----------------------------------------------------------------------------}

procedure GSobjSortDB.OutputWord;
var
  kw: TgsVariant;
   tag: longint;
begin
   kw := TgsVariant.Create(256);
   while GetNextKey(kw,tag) do
   begin
      curFile.gsGetRec(Tag);
      inc(KeyCnt);
      curFile.gsStatusUpdate(StatusCopy,KeyCnt,0);
      move(curFile.CurRecord^,newFile.CurRecord^,curFile.RecLen);
      if curFile.WithMemo then curFile.gsCopyMemoRecord(newFile);
      newFile.gsAppend;
   end;
   kw.Free;
end;

{-----------------------------------------------------------------------------
                                 Initialization
-----------------------------------------------------------------------------}

end.


