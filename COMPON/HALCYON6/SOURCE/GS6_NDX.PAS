unit gs6_ndx;
{-----------------------------------------------------------------------------
                          Basic Index File Routine

       gs6_Ndx Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          18 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the objects to manage dBase NDX index
       files.

   Changes:

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysUtils,
   gs6_dbf,
   gs6_disk,
   gs6_glbl,
   gs6_indx,
   gs6_Sort,
   gs6_lcal,
   gs6_tool;

{private}

const
   NDXBlokSize = 512;

type

   GSptrNDXHeader  = ^GSrecNDXHeader;
   GSrecNDXHeader  = packed Record
      Root        : Longint;
      Next_Blk    : Longint;
      Unknwn1     : Longint;
      Key_Lgth    : SmallInt;
      Max_Keys    : SmallInt;
      Data_Typ    : SmallInt;
      Entry_Sz    : SmallInt;
      Unknwn2     : Array[0..2] of byte;
      UniqueNDX   : Byte;
      Key_Form    : Array [0..NdxBlokSize-25] of char;
   end;

   GSptrNDXDataBlk  = ^GSrecNDXDataBlk;
   GSrecNDXDataBlk  = packed Record
      Entry_Ct     : SmallInt;
      Unknwn1      : SmallInt;
      Data_Ary     : array [0..NdxBlokSize-5] of byte {Array of key entries}
   end;

   GSptrNDXElement = ^GSrecNDXElement;
   GSrecNDXElement = packed Record
      Block_Ax  : Longint;
      Recrd_Ax  : Longint;
      Char_Fld  : array [0..255] of char;
   end;

   GSobjNDXTag = class(GSobjIndexTag)
      constructor Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
      destructor  Destroy; override;
      procedure   AdjustValue(AKey: TgsVariant; DoTrim: boolean); override;
      function    IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean; override;
      function    KeyAdd(st: GSobjIndexKeyData): boolean; override;
      function    PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean; override;
      function    PageStore(PIK: GSobjIndexKey): Boolean; override;
      function    TagLoad: Boolean; override;
      function    TagStore: Boolean; override;
      function    NewRoot: longint; override;
      procedure   DoIndex;
   end;


   GSobjNDXFile = class(GSobjIndexFile)
      constructor Create(PDB: GSO_dBaseFld; const FN: gsUTFString;
                         ReadWrite, Shared, Create, Overwrite: boolean);
      destructor  Destroy; override;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean; override;
      function    GetAvailPage: longint; override;
      function    ResetAvailPage: longint; override;
      function    PageRead(Blok: longint; var Page; Size: integer): boolean; override;
      function    PageWrite(Blok: longint; var Page; Size: integer): boolean; override;
      procedure   ReIndex; override;
      procedure   Zap; virtual;
   end;

implementation

type
   GSobjSortNdx = class(TgsSort)
      curFile: GSO_dBaseFld;
      curTag: GSobjNDXTag;
      KeyWork: array[0..255] of char;
      KeyCnt: longint;
      KeyTot: longint;
      Closing: boolean;
      NodeList: array[0..31] of GSptrNDXDataBlk;

      constructor  Create(ATag: GSobjNDXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
      destructor   Destroy; override;
      procedure    AddToNode(Lvl: integer; Tag: Longint; Value: PChar);
      procedure    OutputWord;
   end;

{-----------------------------------------------------------------------------
                                 GSobjSortNdx
-----------------------------------------------------------------------------}

constructor GSobjSortNdx.Create(ATag: GSobjNDXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
begin
   inherited Create(ATag.KeyLength+1, Uniq, true, WorkDir);   {always an ascending sort}
   CurTag := ATag;
   CurFile := ATag.Owner.Owner;
   KeyTot := CurFile.NumRecs;
   KeyCnt := 0;
   Closing := false;
   KeyWork[0] := #0;
   FillChar(NodeList, SizeOf(NodeList), #0);
end;

destructor GSobjSortNdx.Destroy;
var
   i: integer;
   pa: longint;
   ec: integer;
   elm: GSptrNdxElement;
begin
   Closing := true;
   for i := 0 to 30 do
      if NodeList[i] <> nil then
      begin
         pa := CurTag.Owner.GetAvailPage;
         if NodeList[i+1]  = nil then CurTag.RootBlock := pa;
         ec := NodeList[i]^.Entry_Ct;
         if i > 0 then dec(NodeList[i]^.Entry_Ct);
         CurTag.Owner.PageWrite(pa, NodeList[i]^, NdxBlokSize);
         elm := Addr(NodeList[i]^.Data_Ary[pred(ec) *  CurTag.EntryLength]);
         Move(elm^.Char_Fld, KeyWork[0], CurTag.KeyLength);
         KeyWork[CurTag.KeyLength] := #0;
         if NodeList[i+1] <> nil then
            AddToNode(i+1,pa,KeyWork);
         FreeMem(NodeList[i],NdxBlokSize);
      end;
   inherited Destroy;
end;

procedure GSobjSortNdx.AddToNode(Lvl: integer; Tag: Longint; Value: PChar);
var
   ec: integer;
   pa: longint;
   ps: PChar;
   elm: GSptrNdxElement;
begin
   if NodeList[Lvl] = nil then
   begin
      GetMem(NodeList[Lvl],NdxBlokSize);
      FillChar(NodeList[Lvl]^,NdxBlokSize,#0);
   end;
   ec := NodeList[Lvl]^.Entry_Ct;
   if (ec >= CurTag.MaxKeys) then
   begin
      if Lvl > 0 then dec(NodeList[Lvl]^.Entry_Ct);
      pa := CurTag.Owner.GetAvailPage;
      CurTag.Owner.PageWrite(pa, NodeList[Lvl]^, NdxBlokSize);
      GetMem(ps,CurTag.Keylength+1);
      elm := Addr(NodeList[Lvl]^.Data_Ary[pred(ec) *  CurTag.EntryLength]);
      Move(elm^.Char_Fld, ps[0], CurTag.KeyLength);
      ps[CurTag.KeyLength] := #0;
      AddToNode(Lvl+1,pa,ps);
      FreeMem(ps,CurTag.Keylength+1);
      FillChar(NodeList[Lvl]^,NdxBlokSize,#0);
      ec := 0;
   end;
   elm := Addr(NodeList[Lvl]^.Data_Ary[ec *  CurTag.EntryLength]);
   if Lvl = 0 then
      elm^.Recrd_AX := Tag
   else
      elm^.Block_AX := Tag;
   Move(Value[0],elm^.Char_Fld,CurTag.KeyLength);
   inc(NodeList[Lvl]^.Entry_Ct);
end;

procedure GSobjSortNdx.OutputWord;
var
   d: double;
   kw: TgsVariant;
   tag: longint;
begin
   kw := TgsVariant.Create(256);
   while GetNextKey(kw,tag) do
   begin
      inc(KeyCnt);
      curFile.gsStatusUpdate(StatusIndexWr,KeyCnt,0);
      case CurTag.KeyType of
         'N',
         'D' : begin      {convert to double}
                  d := kw.GetFloat;
                  move(d,KeyWork[0],8);
               end;
         'C' : begin
                  kw.GetPChar(KeyWork);
                  StrPadR(KeyWork, ' ', CurTag.KeyLength);
               end;
      end;
      KeyWork[CurTag.KeyLength] := #0;
      AddToNode(0,Tag,KeyWork);
   end;
   kw.Free;
end;

{-----------------------------------------------------------------------------
                                 GSobjNDXTag
-----------------------------------------------------------------------------}

constructor GSobjNDXTag.Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
begin
   inherited Create(PIF, ITN, TagHdr);
   TagSig := 'NDX';
   DefaultLen := 1;
   if TagHdr <> -1 then
   begin
     TagLoad;
   end
   else
   begin
      TagBlock := Owner.GetAvailPage;
      TagChanged := true;
   end;
end;

destructor GSobjNDXTag.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjNDXTag.AdjustValue(AKey: TgsVariant; DoTrim: boolean);
var
   numwk: double;
   s: string;
begin
   case KeyType of
      'C'       : begin
                     s := AKey.GetString;
                     if DoTrim then s := TrimRight(s);
                     AKey.PutString(s);
                  end;
      'D'       : begin   {convert to double}
                          {test for date string where the date is empty}
                          {If an empty date field then set double value to 1E100}
                     numwk := AKey.GetDate;
                     if numwk < 0.1 then
                        numwk := 1e100;
                     AKey.PutFloat(numwk);
                  end;
      'N'       : begin
                     numwk := AKey.GetFloat;
                     AKey.PutFloat(numwk);
                  end;
   end;
end;

procedure GSobjNDXTag.DoIndex;
var
   ixColl: GSobjSortNdx;
   ps: TgsVariant;
   fchg: boolean;
begin
   ps := TgsVariant.Create(256);
   with Owner.Owner do
   begin
      ixColl := GSobjSortNdx.Create(Self, UniqueKey, AscendKey, PChar(pCollateTable));
      gsStatusUpdate(StatusStart,StatusIndexTo,Owner.Owner.NumRecs);
      gsGetRec(Top_Record);             {Read all dBase file records}
      while not File_EOF do
      begin
         SolveExpression(ps, fchg);
         AdjustValue(ps, true);
         ixColl.AddKey(ps,RecNumber);
         gsStatusUpdate(StatusIndexTo,RecNumber,0);
         gsGetRec(Next_Record);
      end;
      gsStatusUpdate(StatusStop,0,0);
   end;
   Owner.Owner.gsStatusUpdate(StatusStart,StatusIndexWr,ixColl.KeyTot);
   ixColl.OutputWord;
   Owner.Owner.gsStatusUpdate(StatusStop,0,0);
   ixColl.Free;
   ps.Free;
   TagChanged := true;
   TagStore;
end;

function GSobjNDXTag.IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   ps: TgsVariant;
   chg: boolean;
   i: integer;
   NdxFill: GSptrByteArray;
begin
   IndexTagNew := inherited IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
   ps := TgsVariant.Create(256);
   if not SolveExpression(ps, chg) then
      exit;
   case ps.TypeOfVar of
      gsvtText,
      gsvtBoolean : begin
                       KeyType := 'C';
                       KeyLength := ps.SizeOfVar;
                    end;
      gsvtFloat   : begin
                       KeyType := 'N';
                       KeyLength := 12;
                    end;
      gsvtDate    : begin
                       KeyType := 'D';
                       KeyLength := 8;
                    end;
   end;
   i := KeyLength+8;
   while (i mod 4) <> 0 do i := i + 1;
   MaxKeys := ((NDXBlokSize-8) div i);
   EntryLength := i;
   ps.Free;
   GetMem(NdxFill, NDXBlokSize);
   FillChar(NdxFill^, NDXBlokSize, #0);
   Owner.PageWrite(TagBlock, NdxFill^, NdxBlokSize);
   if Owner.Owner.NumRecs > 0 then
   begin
      DoIndex;
   end
   else
   begin
      RootBlock := Owner.GetAvailPage;
      Owner.PageWrite(RootBlock, NdxFill^, NdxBlokSize);
      TagChanged := true;
      TagStore;
   end;
   FreeMem(NdxFill, NDXBlokSize);
   IndexTagNew := true;
end;

function GSobjNDXTag.KeyAdd(st: GSobjIndexKeyData): boolean;
var
   tt: longint;
begin
   tt := st.Xtra;
   st.Xtra := 0;
   KeyAdd := inherited KeyAdd(st);
   st.Xtra := tt;
end;

function GSobjNDXTag.PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean;
var
   NdxData: GSptrNDXDataBlk;
   NdxElem: GSptrNDXElement;
   i: integer;
   Cnt: integer;
   IsLeaf: boolean;
   KeyB: PChar;
   KeyE: PChar;
   p: GSobjIndexKeyData;
   len: integer;
   d: double;
begin
   GetMem(NdxData, NDXBlokSize+EntryLength);
   Owner.PageRead(PN, NdxData^, NDXBlokSize);
   Cnt := NdxData^.Entry_Ct;
   NdxElem := Addr(NdxData^.Data_Ary[0]);
   if NdxElem^.Block_AX = 0 then
   begin
      PIK.PageType := Leaf;
      IsLeaf := true;
   end
   else
   begin
      PIK.PageType := Node;
      inc(Cnt);
      IsLeaf := false;
   end;
   if Cnt > 0 then
   begin
      for i := 0 to pred(Cnt) do
      begin
         NdxElem := Addr(NdxData^.Data_Ary[i*EntryLength]);
         if KeyType = 'C' then
         begin                  {Character field; trim right spaces}
            KeyB := Addr(NdxElem^.Char_Fld);
            KeyE := KeyB+pred(KeyLength);
            while (KeyE[0] = #32) and (KeyE >= KeyB) do
            begin
               KeyE[0] := #0;
               dec(KeyE);
            end;
            if KeyB[0] = #0 then
               len := 0
            else
               len := succ(KeyE-KeyB);
         end
         else
         begin                {Format Number key}
            KeyB := Addr(NDXElem^.Char_Fld);
            len := SizeOf(Double);
         end;
         p := GSobjIndexKeyData.Create(0);
         p.Xtra := 0;
         if {(len > 0) and }((i < pred(Cnt)) or isLeaf) then   {%FIX0013}
         begin
            p.PutBinary(KeyB, len);
            if KeyType = 'C' then p.TypeOfVar := gsvtText;     {%FIX0014}
         end
         else
         begin                       {here for last entry in node page}
            if KeyType = 'C' then
               p.PutString(#$FF)
            else
            begin
               d := 1.7E308;  {max double value}
               p.PutFloat(d);
            end;
         end;
         if IsLeaf then
            p.Tag := NdxElem^.Recrd_AX
         else
            p.Tag := NdxElem^.Block_AX;
         PIK.Add(p);
      end;
   end;
   FreeMem(NdxData, NDXBlokSize+EntryLength);
   PageLoad := true;
end;

function GSobjNDXTag.PageStore(PIK: GSobjIndexKey): Boolean;
var
   NdxData: GSptrNDXDataBlk;
   NdxElem: GSptrNDXElement;
   Cnt: integer;
   kcnt: integer;
   epos: integer;
   p: GSobjIndexKeyData;
   NPN: longint;
   TmpTag: longint;
   pt: GSsetPageType;
begin
   pt := PIK.PageType;
   p := nil;
   GetMem(NdxData, NDXBlokSize);
   FillChar(NdxData^, NDXBlokSize, #0);
   if PIK.Count > MaxKeys then
   begin
      Cnt := PIK.Count div 2;
      Cnt := PIK.Count - Cnt;  {Get odd extra key}
   end
   else
   begin
      Cnt := PIK.Count;
   end;
   PIK.CurKey := 0;
   kcnt := Cnt;
   epos := 0;
   if PIK.Count > 0 then
   repeat
      if kcnt = 0 then
      begin
         if (PIK.PageType < Leaf) then dec(epos);
         NdxData^.Entry_Ct := epos;
         NPN := Owner.GetAvailPage;
         TmpTag := p.Tag;
         p.Tag := NPN;
         PIK.AddNodeKey(p);
         p.Tag := TmpTag;
         PIK.PageType := pt;
         if PIK.PageType = Root then PIK.PageType := Node;
         Owner.PageWrite(NPN, NdxData^, NDXBlokSize);
         FillChar(NdxData^, NDXBlokSize, #0);
         kcnt := MaxKeys;
         epos := 0;
      end;
      p := PIK.Items[PIK.CurKey];
      NdxElem := Addr(NdxData^.Data_Ary[epos*EntryLength]);
      if PIK.PageType >= Leaf then
            NdxElem^.Recrd_AX := p.Tag
         else
            NdxElem^.Block_AX := p.Tag;
      if KeyType = 'C' then
      begin
         FillChar(NdxElem^.Char_Fld, KeyLength, #32);
      end;
      Move(p.Memory^, NdxElem^.Char_Fld, p.SizeOfVar);
      inc(PIK.CurKey);
      dec(kcnt);
      inc(epos);
   until PIK.CurKey >= PIK.Count;
   if (PIK.PageType < Leaf) then dec(epos);
   NdxData^.Entry_Ct := epos;
   Owner.PageWrite(PIK.Page, NdxData^, NDXBlokSize);
   FreeMem(NdxData, NDXBlokSize);
   PageStore := true;
end;

function GSobjNDXTag.TagLoad: Boolean;
var
   NdxHdr: GSptrNDXHeader;
   pv: TgsVariant;
   chg: boolean;
begin
   TagLoad := true;
   GetMem(NdxHdr, NDXBlokSize);
   Owner.PageRead(TagBlock, NdxHdr^, NDXBlokSize);
   RootBlock := NdxHdr^.Root;
   KeyLength := NdxHdr^.Key_Lgth;
   MaxKeys := NdxHdr^.Max_Keys;
   EntryLength := NdxHdr^.Entry_Sz;
   UniqueKey := (NdxHdr^.UniqueNDX and 1) = 1;
   KeyExpr := StrPas(NdxHdr^.Key_Form);
   PostTagExpression;
   pv := TgsVariant.Create(256);
   SolveExpression(pv, chg); {get KeyType}
   case pv.TypeOfVar of
      gsvtText,
      gsvtBoolean   : KeyType := 'C';
      gsvtFloat     : KeyType := 'N';
      gsvtDate      : KeyType := 'D';
   end;
   pv.Free;
   FreeMem(NdxHdr, NDXBlokSize);
   TagChanged := false;
end;

function GSobjNDXTag.TagStore: Boolean;
var
   NdxHdr: GSptrNDXHeader;
begin
   TagStore := true;
   if TagChanged then
   begin
      GetMem(NdxHdr, NDXBlokSize);
      FillChar(NdxHdr^,NDXBlokSize,#0);
      NdxHdr^.Root := RootBlock;
      NdxHdr^.Next_Blk := Owner.NextAvail;
      NdxHdr^.Key_Lgth := KeyLength;
      NdxHdr^.Max_Keys := MaxKeys;
      NdxHdr^.Entry_Sz := EntryLength;
      case KeyType of
         'D',
         'F',
         'N'  : begin
                   NdxHdr^.Data_Typ := 1;
                   NdxHdr^.Key_Lgth := 8;
                end;
         else NdxHdr^.Data_Typ := 0;
      end;
      if UniqueKey then
         NdxHdr^.UniqueNDX := 1;
      StrPCopy(NdxHdr^.Key_Form, KeyExpr);
      Owner.PageWrite(TagBlock, NdxHdr^, NDXBlokSize);
      FreeMem(NdxHdr, NDXBlokSize);
   end;
   TagChanged := false;
end;

function GSobjNDXTag.NewRoot: longint;
var
   NDXHdr: GSptrNDXHeader;
begin
   GetMem(NDXHdr, SizeOf(GSrecNDXHeader));
   Owner.PageRead(TagBlock, NDXHdr^, SizeOf(GSrecNDXHeader));
   NewRoot := NDXHdr^.Root;
   FreeMem(NDXHdr, SizeOf(GSrecNDXHeader));
end;


{-----------------------------------------------------------------------------
                                 GSobjNDXFile
-----------------------------------------------------------------------------}

constructor GSobjNDXFile.Create(PDB: GSO_dBaseFld; const FN: string;
                                ReadWrite, Shared, Create, Overwrite: boolean);
var
   p: array[0..259] of char;
begin
   inherited Create(PDB);
   DiskFile := IndexFileOpen(PDB,FN,'.ndx',ReadWrite, Shared, Create, Overwrite);
   if DiskFile <> nil then
   begin
      if not Create then
      begin
         StrPCopy(p,ExtractFileNameOnly(IndexName));
         TagList.Add(GSobjNDXTag.Create(Self,p,0));
         ResetAvailPage;
      end
      else
         NextAvail := 0;
      CreateOK := true;
   end;
end;

destructor GSobjNDXFile.Destroy;
begin
   inherited Destroy;
end;

function GSobjNDXFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   p: GSobjIndexTag;
begin
   NextAvail := 0;
   p := GSobjNDXTag.Create(Self,ITN,-1);
   TagList.Add(p);
   AddTag := p.IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
end;

function GSobjNDXFile.GetAvailPage: longint;
begin
   if NextAvail = -1 then ResetAvailPage;
   GetAvailPage := NextAvail;
   inc(NextAvail);
end;

function GSobjNDXFile.ResetAvailPage: longint;
begin
   NextAvail := DiskFile.gsFileSize div NdxBlokSize;
   ResetAvailPage := NextAvail;
end;

function GSobjNDXFile.PageRead(Blok: longint; var Page; Size: integer):
                               boolean;
begin
   PageRead := inherited PageRead(Blok*NDXBlokSize, Page, Size);
end;

function GSobjNDXFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
begin
   PageWrite := inherited PageWrite(Blok*NDXBlokSize, Page, Size);
end;

procedure GSobjNDXFile.Reindex;
var
   p: GSobjNDXTag;
begin
   if TagList.Count = 0 then exit;
   Zap;
   DiskFile.gsLockFile;
   p := TagList.Items[0];
   NextAvail := 1;
   p.DoIndex;
   DiskFile.gsUnlock;
end;

procedure GSobjNDXFile.Zap;
var
   p: GSobjIndexTag;
   NdxFill: GSptrByteArray;
begin
   if TagList.Count = 0 then exit;
   DiskFile.gsLockFile;
   p := TagList.Items[0];
   p.TagClose;
   DiskFile.gsTruncate(NdxBlokSize*2);
   p.TagChanged := true;
   p.RootBlock := 1;
   NextAvail := 2;
   p.TagStore;
   GetMem(NdxFill,NdxBlokSize);
   FillChar(NdxFill^, NdxBlokSize, #0);
   PageWrite(1, NdxFill^, NdxBlokSize);
   FreeMem(NdxFill,NdxBlokSize);
   DiskFile.gsUnLock;
end;


end.


