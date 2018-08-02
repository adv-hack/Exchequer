unit gs6_mdx;
{-----------------------------------------------------------------------------
                            dBase III Index Handler

       gs6_mdx Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          4 Jun 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit handles the objects for Borland's dBase .MDX compound
       index files.

       Changes:
-----------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc,
   SysUtils,
   gs6_dbf,
   gs6_Date,
   gs6_disk,
   gs6_cnst,
   gs6_sql,
   gs6_glbl,
   gs6_indx,
   gs6_sort,
   gs6_lcal,
   gs6_tool;

{private}

const
   MDXBlokSize = 512;
   MDXSignature = $02;
   MDXTagsAvail = 48;
type

   GSptrMDXTagDesc = ^GSrecMDXTagDesc;
   GSrecMDXTagDesc = packed record
      TagHeader   : longint;              {Tag Header block (512-byte blocks)}
      TagName     : array[0..10] of char;  {Tag Name}
      FieldTag    : byte;                 {is $10 if index uses a DBF field}
      PrevTag     : byte;                 {Points to tag < this tag}
      NextTag     : byte;                 {Points to tag > this tag}
      OwnrTag     : byte;                 {Tag that pointed here}
      TagSig      : byte;                 {Unknown, appears to always be $02}
      IndexType   : char;                 {Type of index (char, date, number)}
      Unknown3    : array[0..10] of byte;
   end;

   GSptrMDXFileHdr = ^GSrecMDXFileHdr;
   GSrecMDXFileHdr = packed record
      Version      : byte;                 {Version number (2)}
      BuildDate    : array[0..2] of byte;  {YMD of last reindex}
      DBFFileName  : array[0..8] of char;  {DBF name, null terminated}
      Unknown0     : array[0..6] of char;  {unknown}
      ChunksInPage : word;                 {pages in this header}
      BytesInPage  : word;                 {Bytes in a page}
      Production   : byte;                 {1=production index, else 0}
      TagsAvail    : byte;                 {Tags that can be used (48)}
      TagDescSize  : word;                 {Tag descriptor size (32)}
      TagsUsed     : word;                 {Tags in use}
      Unknown1     : word;
      NextBlock    : longint;              {Next available block}
      FreeList     : longint;              {Starting block in the free list}
      FreeBlks     : longint;
      CreateDate   : array[0..2] of byte;  {YMD of creation date}
      Unknown3     : byte;
      Unknown4     : array[0..463] of byte;{filler to 512 bytes}
      TagArray     : array[0..255] of GSrecMDXTagDesc;
                                           {Up to 255 tag descriptions}
   end;

   GSptrMDXTagHead = ^GSrecMDXTagHead;
   GSrecMDXTagHead = packed record
      Root         : longint;             {Location of root page (times 512)}
      Unknown1     : longint;
      TypeFlags    : byte;                {is $10-Normal; $50-Uniq; $x8 Descend}
      TypeKey      : char;                {Type of key (C, D, N)}
      Unknown2     : word;
      KeyLength    : word;                {Key length}
      KeysMax      : word;                {Max keys on page}
      NumericKey   : word;                {1 if numeric, 0 if not (for NDX)}
      EntryLength  : word;                {Key + 4 (8 for NDX) + set modulo 4}
      Version      : byte;                {Version number}
      Unknown3     : word;
      UniqueFlag   : byte;                {is non-zero if unique, zero otherwise}
      KeyExpr      : array[0..219] of char;  {key expression null terminated}
      Unknown4     : byte;
      ForExists    : byte;
      KeyExists    : byte;
      Unknown5     : byte;
      FirstBlock   : longint;
      FinalBlock   : longint;
      Unknown6     : array[0..505] of byte;  {filler to get to FOR expression}
      ForExpr      : array[0..219] of char;  {For expression null terminated}
      Unknown7     : array[0..41] of byte;   {filler}
   end;

   GSptrMDXDataBlk  = ^GSrecMDXDataBlk;
   GSrecMDXDataBlk  = packed Record
      Entry_Ct     : longint;
      LastUsed     : longint;
      Data_Ary     : array [0..pred(MDXBlokSize*2)] of byte {Array of entries}
   end;

   GSptrMDXElement = ^GSrecMDXElement;
   GSrecMDXElement = packed Record
      Block_Ax  : Longint;
      Char_Fld  : array [0..255] of char;
   end;

   GSobjMDXTag = class(GSobjIndexTag)
      PagSize:    longint;
      MDXFirstAvail: longint;
      MDXFinalAvail: longint;
      constructor Create(PIF: GSobjIndexFile;const ITN: gsUTFString; TagHdr: longint);
      destructor  Destroy; override;
      procedure   AdjustValue(AKey: TgsVariant; DoTrim: boolean); override;
      function    IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                           boolean; override;
      function    KeyAdd(st:GSobjIndexKeyData): boolean; override;
      function    PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean; override;
      function    PageStore(PIK: GSobjIndexKey): Boolean; override;
      function    TagLoad: Boolean; override;
      function    TagStore: Boolean; override;
      function    NewRoot: longint; override;
      procedure   DoIndex;
   end;

   GSobjMDXFile = class(GSobjIndexFile)
      MDXOpening  : boolean;
      MDXPageSize : word;
      MDXHeadSize : word;
      MDXTagNum   : word;
      MDXChunks   : word;
      MDXChanged  : boolean;
      constructor Create(PDB: GSO_dBaseFld; const FN: gsUTFString;
                         ReadWrite, Shared, Create, Overwrite: boolean);
      destructor  Destroy; override;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean; override;
      function    DeleteTag(const ITN: gsUTFString): boolean; override;
      function    GetAvailPage: longint; override;
      function    ResetAvailPage: longint; override;
      function    PageRead(Blok: longint; var Page; Size: integer):
                           boolean; override;
      function    PageWrite(Blok: longint; var Page; Size: integer):
                            boolean; override;
      procedure   Reindex; override;
      function    Rename(const NewName: gsUTFString): boolean; override;
   end;

implementation

type
   GSobjSortMDX = class(TgsSort)
      curFile: GSO_dBaseFld;
      curTag: GSobjMDXTag;
      KeyWork: array[0..255] of char;
      KeyCnt: longint;
      KeyTot: longint;
      Closing: boolean;
      PagSize: longint;
      NodeList: array[0..31] of GSptrMDXDataBlk;

      constructor  Create(ATag: GSobjMDXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
      destructor   Destroy; override;
      procedure    AddToNode(Lvl: integer; Tag: Longint; Value: PChar);
      procedure    OutputWord;
   end;

{-----------------------------------------------------------------------------
   gsFltBCD type simulates the type used by dBase IV to store .MDX numeric
   values.  This routine uses 'best guess' estimates of how the field is
   computed.  There are some inconsistencies.  For example, gsFltBCD[1]
   contains the sign and number of used bits, but does not follow a logical
   pattern since numbers with less than 32768 (ignoring decimal place) show
   41 bits used.  All other cases show actual bits used.

   Memory layout is:

                                 gsFltBCD Bytes
        ÚÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÁÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄ......ÄÄÄÄ¿
       [0]      [1]     [2]     [3]     [4]     [5]     [6]           [11]
    76543210 76543210 7-4 3-0 7-4 3-0 7-4 3-0 7-4 3-0 7-4 3-0        7-4 3-0
    pppppppp³seeeeeee³d00 d01³d02 d03³d04 d05³d06 d07³d08 d09³......³d19 d20³
    ÀÁÁÅÁÁÁÙ ³ÀÁÁÅÁÁÙ ÀÁÁÄÁÁÁÄÁÁÁÄÁÁÁÄÁÁÁÂÁÁÁÄÁÁÁÄÁÁÁÄÁÁÁÄÁÁÁÄ......ÄÁÁÁÄÁÁÙ
    Digits   ³   ÀÄÄÄ¿               BCD Digits
    Left of  À Sign  À BCD Digits
    Decimal            Used.  (In
    ($34 = 0)          Bits (BCD
                       digits * 4)
                       + 1 for sign

-----------------------------------------------------------------------------}
type
   gsFltBCD    = array[0..11] of byte;

function Flt2BCD(ANum: FloatNum; var WrkBCD: gsFltBCD): boolean;
var
   DecPlaces     : integer;
   TotPlaces     : integer;
   DigitPos      : integer;
   wbyte1        : byte;
   wbyte2        : byte;
   WrkNum        : extended;
   WrkRec        : TFloatRec;

begin
   FillChar(WrkBCD,SizeOf(gsFltBCD),#0);
   WrkNum := ANum;
   FloatToDecimal(WrkRec, WrkNum, fvExtended, 16, 15);
   if WrkRec.Exponent > 15 then
   begin
      WrkRec.Exponent := 15;
      FillChar(WrkRec.Digits[0],15,'9');
   end;
   DecPlaces := $34 + WrkRec.Exponent;
   {load digits}
   TotPlaces := 0;
   DigitPos := 2;
   while (WrkRec.Digits[TotPlaces] <> #0) and (TotPlaces < 16) do
   begin
      wbyte1 := ord(WrkRec.Digits[TotPlaces]) and $0F;
      wbyte1 := wbyte1 shl 4;
      inc(TotPlaces);
      if (WrkRec.Digits[TotPlaces] <> #0) then
         wbyte2 := ord(WrkRec.Digits[TotPlaces]) and $0F
      else
         wbyte2 := 0;
      inc(TotPlaces);
      WrkBCD[DigitPos] := wbyte1 or wbyte2;
      inc(DigitPos);
   end;
   dec(DigitPos);
   while (DigitPos >= 2) and (WrkBCD[DigitPos] = 0) do
   begin
      dec(DigitPos);
      Dec(TotPlaces,2);
   end;
   WrkBCD[0] := DecPlaces;
   WrkBCD[1] := (TotPlaces*4) + 1;
   if WrkRec.Negative then WrkBCD[1] := WrkBCD[1] or $80;
   Result := true;
end;

function BCD2Flt(WrkBCD: gsFltBCD): FloatNum;
var
   fn: FloatNum;
   ix: integer;
   ct: integer;
   lp: integer;
   rp: integer;
begin
   fn := 0;
   ct := WrkBCD[1] and $7F;
   ct := ct shr 3;
   for ix := 2 to ct+1 do
   begin
      fn := (fn*10) + WrkBCD[ix] shr 4;
      fn := (fn*10) + WrkBCD[ix] and $0F;
   end;
   lp := WrkBCD[0] - $34;
   rp := (ct shl 1) - lp;
   while rp < 0 do
   begin
      fn := fn * 10;
      inc(rp);
   end;
   while rp > 0 do
   begin
      fn := fn / 10;
      dec(rp);
   end;
   if WrkBCD[1] >= 128 then
     fn := fn * -1;
   Result := fn;
end;

{-----------------------------------------------------------------------------
                                 GSobjSortMDX
-----------------------------------------------------------------------------}

constructor GSobjSortMDX.Create(ATag: GSobjMDXTag; Uniq, Ascnd: boolean; WorkDir: PChar);
var
   KeyLen: integer;
begin
   case ATag.KeyType of
      'C' : KeyLen := ATag.KeyLength;
      'D' : KeyLen := SizeOf(FloatNum);
      'N' : KeyLen := SizeOf(FloatNum);
      else  KeyLen := 239;
   end;
   inherited Create(KeyLen+1,Uniq, Ascnd, WorkDir);
   CurTag := ATag;
   CurFile := ATag.Owner.Owner;
   KeyTot := CurFile.NumRecs;
   KeyCnt := 0;
   PagSize := GSobjMDXFile(CurTag.Owner).MDXPageSize;
   Closing := false;
   KeyWork[0] := #0;
   FillChar(NodeList, SizeOf(NodeList), #0);
end;

destructor GSobjSortMDX.Destroy;
var
   i: integer;
   pa: longint;
   ec: integer;
   elm: GSptrMDXElement;
begin
   Closing := true;
   for i := 0 to 30 do
      if NodeList[i] <> nil then
      begin
         pa := CurTag.Owner.GetAvailPage;
         if NodeList[i+1]  = nil then CurTag.RootBlock := pa;
         ec := NodeList[i]^.Entry_Ct;
         if i > 0 then dec(NodeList[i]^.Entry_Ct);
         NodeList[i]^.LastUsed := GSobjMDXTag(CurTag).MDXFinalAvail;
         CurTag.Owner.PageWrite(pa, NodeList[i]^, PagSize);
         if GSobjMDXTag(CurTag).MDXFirstAvail = 0 then
            GSobjMDXTag(CurTag).MdxFirstAvail := pa;
         GSobjMDXTag(CurTag).MDXFinalAvail := pa;
         elm := Addr(NodeList[i]^.Data_Ary[pred(ec) *  CurTag.EntryLength]);
         Move(elm^.Char_Fld, KeyWork[0], CurTag.KeyLength);
         KeyWork[CurTag.KeyLength] := #0;
         if NodeList[i+1] <> nil then
            AddToNode(i+1,pa,KeyWork);
         FreeMem(NodeList[i],PagSize);
      end;
   inherited Destroy;
end;

procedure GSobjSortMDX.AddToNode(Lvl: integer; Tag: Longint; Value: PChar);
var
   ec: integer;
   pa: longint;
   ps: PChar;
   elm: GSptrMDXElement;
begin
   if NodeList[Lvl] = nil then
   begin
      GetMem(NodeList[Lvl],PagSize);
      FillChar(NodeList[Lvl]^,PagSize,#0);
   end;
   ec := NodeList[Lvl]^.Entry_Ct;
   if (ec >= CurTag.MaxKeys) then
   begin
      if Lvl > 0 then dec(NodeList[Lvl]^.Entry_Ct);
      pa := CurTag.Owner.GetAvailPage;
      NodeList[Lvl]^.LastUsed := GSobjMDXTag(CurTag).MDXFinalAvail;
      CurTag.Owner.PageWrite(pa, NodeList[Lvl]^, PagSize);
      if GSobjMDXTag(CurTag).MDXFirstAvail = 0 then
         GSobjMDXTag(CurTag).MdxFirstAvail := pa;
      GSobjMDXTag(CurTag).MDXFinalAvail := pa;
      GetMem(ps,CurTag.Keylength+1);
      elm := Addr(NodeList[Lvl]^.Data_Ary[pred(ec) *  CurTag.EntryLength]);
      Move(elm^.Char_Fld, ps[0], CurTag.KeyLength);
      ps[CurTag.KeyLength] := #0;
      AddToNode(Lvl+1,pa,ps);
      FreeMem(ps,CurTag.Keylength+1);
      FillChar(NodeList[Lvl]^,PagSize,#0);
      ec := 0;
   end;
   elm := Addr(NodeList[Lvl]^.Data_Ary[ec *  CurTag.EntryLength]);
   elm^.Block_AX := Tag;
   Move(Value[0],elm^.Char_Fld,CurTag.KeyLength);
   inc(NodeList[Lvl]^.Entry_Ct);
end;

procedure GSobjSortMDX.OutputWord;
var
   d: double;
   BCDWrk: gsFltBCD;
   kw: TgsVariant;
   tag: longint;
begin
   kw := TgsVariant.Create(256);
   while GetNextKey(kw,tag) do
   begin
      inc(KeyCnt);
      curFile.gsStatusUpdate(StatusIndexWr,KeyCnt,0);
      case CurTag.KeyType of
         'D' : begin      {convert to double}
                  d := kw.GetFloat;
                  move(d,KeyWork[0],8);
               end;
         'N' : begin      {convert to BCD value}
                  d := kw.GetFloat;
                  Flt2BCD(d,BCDWrk);
                  Move(BCDWrk, KeyWork[0], SizeOf(BCDWrk));
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
                                 GSobjMDXTag
-----------------------------------------------------------------------------}

constructor GSobjMDXTag.Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
begin
   inherited Create(PIF, ITN, TagHdr);
   TagSig := 'MDX';
   DefaultLen := 10;
   PagSize := GSobjMDXFile(Owner).MDXPageSize;
   MdxFirstAvail := 0;
   MdxFinalAvail := 0;
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

destructor GSobjMDXTag.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjMDXTag.AdjustValue(AKey: TgsVariant; DoTrim: boolean);
var
   numwk: double;
   BCDWrk: gsFltBCD;
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
                     Flt2BCD(numwk,BCDWrk);  {Adjust for floating point limits}
                     numwk := BCD2Flt(BCDWrk);
                     AKey.PutFloat(numwk);
                  end;
   end;
end;

procedure GSobjMDXTag.DoIndex;
var
   withFor: boolean;
   ixColl: GSobjSortMDX;
   ps: TgsVariant;
   fchg: boolean;
begin
   ps := TgsVariant.Create(256);
   with Owner.Owner do
   begin
      ixColl := GSobjSortMDX.Create(Self, UniqueKey, AscendKey, PChar(pCollateTable));
      gsStatusUpdate(StatusStart,StatusIndexTo,Owner.Owner.NumRecs);
      gsGetRec(Top_Record);             {Read all dBase file records}
      while not File_EOF do
      begin
         withFor := Conditional and (Length(ForExpr) > 0);
         if withFor then
            withFor := SolveFilter
         else withFor := true;
         if withFor then
         begin
            SolveExpression(ps, fchg);
            AdjustValue(ps,true);
            ixColl.AddKey(ps,RecNumber);
         end;
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

function GSobjMDXTag.IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   ps: TgsVariant;
   chg: boolean;
   i: integer;
   MDXFill: GSptrByteArray;
begin
   IndexTagNew := inherited IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
   InvertCmpr := not AscendKey;
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
   i := KeyLength+4;
   while (i mod 4) <> 0 do i := i + 1;
   MaxKeys := pred((PagSize-8) div i);
   EntryLength := i;
   ps.Free;
   GetMem(MDXFill, PagSize);
   FillChar(MDXFill^, PagSize, #0);
   Owner.PageWrite(TagBlock, MDXFill^, PagSize);
   if Owner.Owner.NumRecs > 0 then
   begin
      DoIndex;
   end
   else
   begin
      RootBlock := Owner.GetAvailPage;
      Owner.PageWrite(RootBlock, MDXFill^, PagSize);
      TagChanged := true;
      TagStore;
      MdxFirstAvail := RootBlock;
      MdxFinalAvail := RootBlock;
   end;
   FreeMem(MDXFill, PagSize);
   IndexTagNew := true;
end;

function GSobjMDXTag.KeyAdd(st: GSobjIndexKeyData): boolean;
var
   tt: longint;
begin
   tt := st.Xtra;
   st.Xtra := 0;
   KeyAdd := inherited KeyAdd(st);
   st.Xtra := tt;
end;

function GSobjMDXTag.PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean;
var
   MDXData: GSptrMDXDataBlk;
   MDXElem: GSptrMDXElement;
   i: integer;
   Cnt: integer;
   IsLeaf: boolean;
   KeyB: PChar;
   KeyE: PChar;
   p: GSobjIndexKeyData;
   len: integer;
   BCDWrk: gsFltBCD;
   BCDVal: FloatNum;
   d: FloatNum;
begin
   KeyB := nil;
   GetMem(MDXData, PagSize);
   Owner.PageRead(PN, MDXData^, PagSize);
   PIK.Left := MDXData^.LastUsed;
   Cnt := MDXData^.Entry_Ct;
   MDXElem := Addr(MDXData^.Data_Ary[Cnt*EntryLength]);
   if MDXElem^.Block_AX = 0 then
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
         MDXElem := Addr(MDXData^.Data_Ary[i*EntryLength]);
         len := 1;
         if (i < pred(Cnt)) or isLeaf then
         begin
            case KeyType of
            'C' : begin                  {Character field; trim right spaces}
                     KeyB := Addr(MDXElem^.Char_Fld);
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
                 end;

           'D' : begin                {Format Date key}
                    KeyB := Addr(MDXElem^.Char_Fld);
                    len := SizeOf(Double);
                 end;

           'N' : begin      {convert to BCD value}
                    Move(MDXElem^.Char_Fld[0], BCDWrk[0], KeyLength);
                    BCDVal := BCD2Flt(BCDWrk);
                    KeyB := Addr(BCDVal);
                    len := SizeOf(Double);
                 end;
            end;
         end;
         p := GSobjIndexKeyData.Create(0);
         p.Xtra := 0;
         p.Tag := MDXElem^.Block_AX;
         if {(len > 0) and} ((i < pred(Cnt)) or isLeaf) then  {%FIX0013}
         begin
            p.PutBinary(KeyB, len);
            case KeyType of
               'C' : p.TypeOfVar := gsvtText;
               'D' : p.TypeOfVar := gsvtFloat;
               'N' : p.TypeOfVar := gsvtFloat;
            end;
         end
         else
         begin                       {here for last entry in node page}
            if not InvertCmpr then
            begin
               case KeyType of
                 'C' : p.PutString(#$FF);
                 'D' : begin
                          d := 1.7E308;  {max double value}
                          p.PutFloat(d);
                       end;
                 'N' : begin
                          d := 1.7E308;  {max double value}
                          p.PutFloat(d);
                       end;
               end;
            end
            else
            begin
               case KeyType of
                 'C' : p.PutString('');
                 'D' : begin
                          d := 1.7E-308;  {min double value}
                          p.PutFloat(d);
                       end;
                 'N' : begin
                          d := 1.7E-308;  {min double value}
                          p.PutFloat(d);
                       end;
               end;
            end;   
         end;
         PIK.Add(p);
      end;
   end;
   FreeMem(MDXData, PagSize);
   PageLoad := true;
end;

function GSobjMDXTag.PageStore(PIK: GSobjIndexKey): Boolean;
var
   MDXData: GSptrMDXDataBlk;
   MDXElem: GSptrMDXElement;
   Cnt: integer;
   kcnt: integer;
   epos: integer;
   p: GSobjIndexKeyData;
   WrkAry: gsFltBCD;
   BCDVal: FloatNum;
   NPN: longint;
   TmpTag: Longint;
   pt: GSsetPageType;
begin
   pt := PIK.PageType;
   p := nil;
   GetMem(MDXData, PagSize);
   FillChar(MDXData^, PagSize, #0);
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
         MDXData^.Entry_Ct := epos;
         MDXData^.LastUsed := MDXFinalAvail;
         NPN := Owner.GetAvailPage;
         if MDXFirstAvail = 0 then MdxFirstAvail := NPN;
         MDXFinalAvail := NPN;
         TagChanged := true;
         TmpTag := p.Tag;
         p.Tag := NPN;
         PIK.AddNodeKey(p);
         p.Tag := TmpTag;
         PIK.PageType := pt;
         if PIK.PageType = Root then PIK.PageType := Node;
         Owner.PageWrite(NPN, MDXData^, PagSize);
         FillChar(MDXData^, PagSize, #0);
         kcnt := MaxKeys;
         epos := 0;
      end;
      p := PIK.Items[PIK.CurKey];
      MDXElem := Addr(MDXData^.Data_Ary[epos*EntryLength]);
      MDXData^.LastUsed := PIK.Left;
      MDXElem^.Block_AX := p.Tag;
      case KeyType of
         'C' : begin
                  FillChar(MDXElem^.Char_Fld, KeyLength, #32);
                  Move(p.Memory^, MDXElem^.Char_Fld, p.SizeOfVar);
               end;
         'D' : begin
                  FillChar(MDXElem^.Char_Fld, SizeOf(Double), #0);
                  Move(p.Memory^, MDXElem^.Char_Fld, p.SizeOfVar);
               end;
         'N' : begin
                  BCDVal := p.GetFloat;
                  Flt2BCD(BCDVal,WrkAry);
                  Move(WrkAry, MDXElem^.Char_Fld, SizeOf(gsFltBCD));
               end;
      end;
      inc(PIK.CurKey);
      dec(kcnt);
      inc(epos);
   until PIK.CurKey >= PIK.Count;
   if (PIK.PageType < Leaf) then dec(epos);
   MDXData^.Entry_Ct := epos;
   MDXData^.LastUsed := PIK.Left;
   Owner.PageWrite(PIK.Page, MDXData^, PagSize);
   FreeMem(MDXData, PagSize);
   PageStore := true;
end;

function GSobjMDXTag.TagLoad: Boolean;
var
   MDXHdr: GSptrMDXTagHead;
begin
   TagLoad := true;
   GetMem(MDXHdr, PagSize);
   Owner.PageRead(TagBlock, MDXHdr^, PagSize);
   RootBlock := MDXHdr^.Root;
   KeyLength := MDXHdr^.KeyLength;
   MaxKeys := MDXHdr^.KeysMax;
   EntryLength := MDXHdr^.EntryLength;
   KeyType := MDXHdr^.TypeKey;
   MdxFirstAvail := MDXHdr^.FirstBlock;
   MdxFinalAvail := MDXHdr^.FinalBlock;
   UniqueKey := (MDXHdr^.UniqueFlag <> 0);
   AscendKey := (MDXHdr^.TypeFlags and $08) = 0;
   InvertCmpr := not AscendKey;
   KeyExpr := StrPas(MDXHdr^.KeyExpr);
   PostTagExpression;
   Conditional := MDXHdr^.ForExists <> 0;
   if Conditional then
   begin
      ForExpr := StrPas(MDXHdr^.ForExpr);
      PostTagFilter;
   end;
   FreeMem(MDXHdr, PagSize);
   TagChanged := false;
end;

function GSobjMDXTag.TagStore: Boolean;
var
   MDXHdr: GSptrMDXTagHead;
   TypFlg: byte;
begin
   TagStore := true;
   TypFlg := $10;
   if TagChanged then
   begin
      GetMem(MDXHdr, PagSize);
      FillChar(MDXHdr^,PagSize,#0);
      MDXHdr^.Root := RootBlock;
      MDXHdr^.KeyLength := KeyLength;
      MDXHdr^.KeysMax := MaxKeys;
      MDXHdr^.EntryLength := EntryLength;
      MDXHdr^.TypeKey := KeyType;
      MDXHdr^.FirstBlock := MdxFirstAvail;
      MDXHdr^.FinalBlock := MdxFinalAvail;
      MDXHdr^.KeyExists := 1;
      StrPCopy(MDXHdr^.KeyExpr, KeyExpr);
      if Conditional then
      begin
         MDXHdr^.ForExists := 1;
         StrPCopy(MDXHdr^.ForExpr, ForExpr);
      end;
      if UniqueKey then
      begin
         MDXHdr^.UniqueFlag := $40;
         TypFlg := $50;
      end;
      if not AscendKey then TypFlg := TypFlg or $08;
      MDXHdr^.TypeFlags := TypFlg;
      Owner.PageWrite(TagBlock, MDXHdr^, PagSize);
      FreeMem(MDXHdr, PagSize);
   end;
   TagChanged := false;
end;

function GSobjMDXTag.NewRoot: longint;
var
   MDXHdr: GSptrMDXTagHead;
begin
   GetMem(MDXHdr, PagSize);
   Owner.PageRead(TagBlock, MDXHdr^, PagSize);
   NewRoot := MDXHdr^.Root;
   FreeMem(MDXHdr, PagSize);
end;

{-----------------------------------------------------------------------------
                                 GSobjMDXFile
-----------------------------------------------------------------------------}

constructor GSobjMDXFile.Create(PDB: GSO_dBaseFld; const FN: string;
                                ReadWrite, Shared, Create, Overwrite: boolean);
var
   extpos: string;
   i: integer;
   MDXHdr: GSptrMDXFileHdr;
   tns: gsUTFString;
   m,d,y: word;
   da: array[0..2] of byte;
   s: string;
begin
   inherited Create(PDB);
   DiskFile := IndexFileOpen(PDB,FN,'.mdx',ReadWrite, Shared, Create, Overwrite);
   if DiskFile = nil then exit;
   MDXOpening := true;
   MDXChanged := false;
   if DiskFile.FileFound and (DiskFile.gsFileSize > MDXBlokSize)then
   begin
      GetMem(MDXHdr, MDXBlokSize);
      PageRead(0, MDXHdr^, MDXBlokSize);
      with MDXHdr^ do
      begin
         MDXPageSize := BytesInPage;
         MDXTagNum := TagsAvail;
         MDXChunks := ChunksInPage;
         MDXHeadSize := MDXChunks*MDXPageSize;
      end;
      FreeMem(MDXHdr, MDXBlokSize);
      GetMem(MDXHdr, MDXHeadSize);
      PageRead(0, MDXHdr^, MDXHeadSize);
      NextAvail := DiskFile.gsFileSize div MDXBlokSize;
      for i := 1 to MDXHdr^.TagsUsed do
      begin
         tns := gsStrUpperCase(StrPas(MDXHdr^.TagArray[i].TagName));
         TagList.Add(GSobjMDXTag.Create(Self,tns,MDXHdr^.TagArray[i].TagHeader));
      end;
      FreeMem(MDXHdr, MDXHeadSize);
   end
   else
   begin
      MDXPageSize := 1024;
      MDXHeadSize := MDXBlokSize + (MDXTagsAvail * SizeOf(GSrecMDXTagDesc));
      MDXChunks := MDXPageSize div MDXBlokSize;
      MDXTagNum := MDXTagsAvail;
      GetMem(MDXHdr, MDXHeadSize);
      FillChar(MDXHdr^, MDXHeadSize, #0);
      NextAvail := MDXHeadSize div MDXBlokSize;
      with MDXHdr^ do
      begin
         Version := MDXSignature;
         DBFDate.Jul2MDY(DBFDate.Date,m,d,y);
         y := y mod 100;
         da[0] := y;
         da[1] := m;
         da[2] := d;
         move(da,BuildDate,3);
         move(da,CreateDate,3);
         if PDB <> nil then
         begin                                                  {!!RFG 022198}
            s := ExtractFileNameOnly(PDB.FileName);
            s := system.copy(s,1,8);
            StrPCopy(DBFFileName,s);
         end;
         ChunksInPage := MDXChunks;
         BytesInPage := MDXPageSize;
         Production := 1;
         TagsAvail := MDXTagsAvail;
         TagDescSize := SizeOf(GSrecMDXTagDesc);
         TagsUsed := TagList.Count;
         NextBlock := MDXHeadSize div MDXBlokSize;
      end;
      PageWrite(0, MDXHdr^, MDXHeadSize);
      FreeMem(MDXHdr, MDXHeadSize);
   end;
   if (PDB <> nil) and (PDB.IndexFlag = $00) then
   begin
      extpos := ChangeFileExt(DiskFile.FileName,ExtractFileExt(PDB.FileName));
      if (AnsiCompareFileName(PDB.FileName,extpos) = 0) then
      begin
         PDB.IndexFlag := $01;
         PDB.WithIndex := true;
         PDB.dStatus := Updated;
         PDB.gsHdrWrite;
      end;
   end;
   MDXOpening := false;
   CreateOK := true;
end;

destructor GSobjMDXFile.Destroy;
var
   MDXHdr: GSptrMDXFileHdr;
   m,d,y: word;
   da: array[0..2] of byte;
begin
   if MDXChanged then
   begin
      GetMem(MDXHdr, MDXHeadSize);
      PageRead(0, MDXHdr^, MDXHeadSize);
      with MDXHdr^ do
      begin
         DBFDate.Jul2MDY(DBFDate.Date,m,d,y);
         y := y mod 100;
         da[0] := y;
         da[1] := m;
         da[2] := d;
         move(da,BuildDate,3);
         TagsUsed := TagList.Count;
         NextBlock := NextAvail;
      end;
      PageWrite(0, MDXHdr^, MDXHeadSize);
      FreeMem(MDXHdr, MDXHeadSize);
   end;
   inherited Destroy;
end;

function GSobjMDXFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   p: GSobjIndexTag;
   q: GSobjIndexTag;
   i: integer;
   j: integer;
   MDXHdr: GSptrMDXFileHdr;
   dr: integer;
begin
   j := -1;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      if gsStrCompareI(p.TagName, ITN) = 0 then j := i;
   end;
   if j <> -1 then
   begin
      p := TagList.Items[j];
      TagList.FreeOne(p);
   end;
   p := GSobjMDXTag.Create(Self,ITN,-1);
   i := 0;
   j := -1;
   while (i < TagList.Count) and (j = -1) do
   begin
      q := TagList.Items[i];
      dr := gsStrCompareI(q.TagName, ITN);
      if dr = 1 then j := i;
      inc(i);
   end;
   if j = -1 then j := TagList.Count;
   TagList.Insert(j,p);
   AddTag := p.IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);

   GetMem(MDXHdr, MDXHeadSize);
   PageRead(0, MDXHdr^, MDXHeadSize);
   MDXHdr^.TagsUsed := TagList.Count;
   with MDXHdr^ do
   begin
      for i := 1 to TagList.Count do
      begin
         FillChar(TagArray[i],SizeOf(GSrecMDXTagDesc),#0);
         TagArray[pred(i)].NextTag := i;
         p := TagList.Items[pred(i)];
         StrPCopy(TagArray[i].TagName, p.TagName);
         TagArray[i].TagHeader := p.TagBlock;
         TagArray[i].IndexType := p.KeyType;
         TagArray[i].TagSig := MDXSignature;
      end;
   end;
   PageWrite(0, MDXHdr^, MDXHeadSize);
   FreeMem(MDXHdr, MDXHeadSize);
   MDXChanged := true;
end;

function GSobjMDXFile.DeleteTag(const ITN: gsUTFString): boolean;
var
   p: GSobjIndexTag;
   i: integer;
   j: integer;
   MDXHdr: GSptrMDXFileHdr;
begin
   DeleteTag := false;
   j := -1;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      if gsStrCompareI(p.TagName, ITN) = 0 then j := i;
   end;
   if j <> -1 then
   begin
      p := TagList.Items[j];
      TagList.FreeOne(p);
      DeleteTag := true;
   end;
   GetMem(MDXHdr, MDXHeadSize);
   PageRead(0, MDXHdr^, MDXHeadSize);
   MDXHdr^.TagsUsed := TagList.Count;
   with MDXHdr^ do
   begin
      for i := 1 to TagList.Count do
      begin
         TagArray[pred(i)].NextTag := i;
         p := TagList.Items[pred(i)];
         StrPCopy(TagArray[i].TagName, p.TagName);
         TagArray[i].TagHeader := p.TagBlock;
         TagArray[i].IndexType := p.KeyType;
         TagArray[i].TagSig := MDXSignature;
      end;
   end;
   PageWrite(0, MDXHdr^, MDXHeadSize);
   FreeMem(MDXHdr, MDXHeadSize);
   MDXChanged := true;
   if TagList.Count = 0 then Reindex;
end;

function GSobjMDXFile.GetAvailPage: longint;
begin
   if NextAvail = -1 then ResetAvailPage;
   GetAvailPage := NextAvail;
   inc(NextAvail, MDXChunks);
end;

function GSobjMDXFile.ResetAvailPage: longint;
begin
   NextAvail := DiskFile.gsFileSize div MDXBlokSize;
   ResetAvailPage := NextAvail;
end;

function GSobjMDXFile.PageRead(Blok: longint; var Page; Size: integer):
                               boolean;
begin
   PageRead := inherited PageRead(Blok*MDXBlokSize, Page, Size);
end;

function GSobjMDXFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
begin
   PageWrite := inherited PageWrite(Blok*MDXBlokSize, Page, Size);
end;

procedure GSobjMDXFile.Reindex;
var
   p: GSobjMDXTag;
   i: integer;
   MDXHdr: GSptrMDXFileHdr;

   procedure PostTag;
   var
      MDXData: GSptrMDXDataBlk;
   begin
      p.TagStore;
      if (Owner.NumRecs > 0) then
      begin
         p.DoIndex;
      end
      else
      begin
         GetMem(MDXData, MDXBlokSize);
         FillChar(MDXData^, MDXBlokSize, #0);
         p.RootBlock := GetAvailPage;
         PageWrite(p.RootBlock, MDXData^, MDXBlokSize);
         FreeMem(MDXData, MDXBlokSize);
         p.MdxFirstAvail := p.RootBlock;
         p.MdxFinalAvail := p.RootBlock;
         p.TagChanged := true;
         p.TagStore;
      end;
   end;

begin
   DiskFile.gsLockFile;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      p.TagClose;
   end;
   DiskFile.gsTruncate(MDXHeadSize);
   NextAvail := MdxHeadSize div MDXBlokSize;   {Room for tag index}
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      p.TagBlock := GetAvailPage;
      p.TagChanged := true;
      PostTag;
   end;
   GetMem(MDXHdr, MDXHeadSize);
   PageRead(0, MDXHdr^, MDXHeadSize);
   MDXHdr^.TagsUsed := TagList.Count;
   with MDXHdr^ do
   begin
      for i := 1 to TagList.Count do
      begin
         p := TagList.Items[pred(i)];
         TagArray[i].TagHeader := p.TagBlock;
      end;
   end;
   PageWrite(0, MDXHdr^, MDXHeadSize);
   FreeMem(MDXHdr, MDXHeadSize);
   DiskFile.gsUnLock;
end;

function GSobjMDXFile.Rename(const NewName: string): boolean;
var
   fno: string;
   MDXHdr: GSptrMDXFileHdr;
begin
   Result := inherited Rename(NewName);
   if Result then
   begin
      GetMem(MDXHdr, 32);
      PageRead(0, MDXHdr^, 32);
      FillChar(MDXHdr^.DBFFileName, SizeOf(MDXHdr^.DBFFileName), #0);
      fno := UpperCase(ExtractFileNameOnly(NewName));
      fno := system.copy(fno,1,8);
      StrPCopy(MDXHdr^.DBFFileName,fno);
      PageWrite(0, MDXHdr^, 32);
      FreeMem(MDXHdr, 32);
   end;
end;


end.


