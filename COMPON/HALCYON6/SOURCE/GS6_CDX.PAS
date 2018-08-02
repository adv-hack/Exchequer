unit gs6_cdx;
{-----------------------------------------------------------------------------
                          Basic Index File Routine

       gs6_cdx Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          31 May 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the objects to manage dBase CDX index
       files.

------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysHalc, 
   SysUtils,
   gs6_dbf,
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
   CDXBlokSize = 512;
   CDXSigDefault = $01;
   CDXSigGeneral = $02;

{public}

{$IFDEF FOXGENERAL}

   {Code Page - 1252 (WINDOWS ANSI)}
   {COLLATE=GENERAL}
   GSaryCDXCollateTable : Array[0..255] of Byte = (
            {00  01  02  03  04  05  06  07  08  09  0A  0B  0C  0D  0E  0F}
      {00}  $10,$10,$10,$10,$10,$10,$10,$10,$10,$11,$10,$10,$10,$10,$10,$10,
      {01}  $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,
      {02}  $11,$12,$13,$14,$15,$16,$17,$18,$19,$1A,$1B,$1C,$1D,$1E,$1F,$20,
      {03}  $56,$57,$58,$59,$5A,$5B,$5C,$5D,$5E,$5F,$21,$22,$23,$24,$25,$26,
      {04}  $27,$60,$61,$62,$64,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6F,$70,$72,
      {05}  $73,$74,$75,$76,$77,$78,$7A,$7B,$7C,$7D,$7E,$28,$29,$2A,$2B,$2C,
      {06}  $2D,$60,$61,$62,$64,$66,$67,$68,$69,$6A,$6B,$6C,$6D,$6F,$70,$72,
      {07}  $73,$74,$75,$76,$77,$78,$7A,$7B,$7C,$7D,$7E,$2E,$2F,$30,$31,$10,
      {08}  $10,$10,$18,$32,$13,$33,$34,$35,$36,$37,$76,$18,$00,$10,$10,$10,
      {09}  $10,$18,$18,$13,$13,$38,$1E,$1E,$39,$3A,$76,$18,$00,$10,$10,$7D,
      {0A}  $20,$3B,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$13,$45,$1E,$46,$47,
      {0B}  $48,$49,$58,$59,$4A,$4B,$4C,$4D,$4E,$57,$4F,$13,$50,$51,$52,$53,
      {0C}  $60,$60,$60,$60,$60,$60,$06,$62,$66,$66,$66,$66,$6A,$6A,$6A,$6A,
      {0D}  $65,$70,$72,$72,$72,$72,$72,$54,$81,$78,$78,$78,$78,$7D,$12,$0C,
      {0E}  $60,$60,$60,$60,$60,$60,$06,$62,$66,$66,$66,$66,$6A,$6A,$6A,$6A,
      {0F}  $65,$70,$72,$72,$72,$72,$72,$55,$81,$78,$78,$78,$78,$7D,$12,$7D);

   GSaryCDXCollateMask : Array[0..255] of Byte = (
            {00  01  02  03  04  05  06  07  08  09  0A  0B  0C  0D  0E  0F}
      {00}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {01}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {02}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {03}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {04}  $00,$20,$00,$20,$00,$20,$00,$00,$00,$20,$00,$00,$00,$00,$20,$20,
      {05}  $00,$00,$00,$20,$00,$20,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,
      {06}  $00,$20,$00,$20,$00,$20,$00,$00,$00,$20,$00,$00,$00,$00,$20,$20,
      {07}  $00,$00,$00,$20,$00,$20,$00,$00,$00,$20,$00,$00,$00,$00,$00,$00,
      {08}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$00,$80,$00,$00,$00,
      {09}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$28,$00,$80,$00,$00,$24,
      {0A}  $21,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {0B}  $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,
      {0C}  $22,$21,$23,$25,$24,$26,$80,$27,$22,$21,$23,$24,$22,$21,$23,$24,
      {0D}  $00,$25,$22,$21,$23,$25,$24,$00,$00,$22,$21,$23,$24,$21,$80,$80,
      {0E}  $22,$21,$23,$25,$24,$26,$80,$27,$22,$21,$23,$24,$22,$21,$23,$24,
      {0F}  $00,$25,$22,$21,$23,$25,$24,$00,$00,$22,$21,$23,$24,$21,$80,$24);

   GSaryCDXCollateLigature : Array[0..31] of Byte = (
            {00  01  02  03  04  05  06  07  08  09  0A  0B  0C  0D  0E  0F}
      {00}  $00,$02,$72,$20,$66,$20,$00,$02,$60,$20,$66,$20,$00,$02,$76,$20,
      {01}  $76,$20,$00,$02,$77,$00,$69,$00,$00,$00,$00,$00,$00,$00,$00,$00);

{$ENDIF}

{private}

type

   GSsetCDXCollateType = (NoCollate, Machine, General);

   GSptrCDXHeader  = ^GSrecCDXHeader;
   GSrecCDXHeader  = packed Record
      Root       : LongInt;                {byte offset to root node}
      FreePtr    : LongInt;                {byte offset to next free block}
      ChgFlag    : Longint;                {Increments on modification}
      Key_Lgth   : Word;                   {length of key}
      IndexOpts  : Byte;
                         {bit field :   1 = unique
                                        8 = FOR clause
                                       32 = compact index
                                       64 = compound index}
      IndexSig   : Byte;
      Reserve3   : array [0..477] of Byte;
      Col8Kind   : array[0..7] of Char;
      AscDesc    : Word;     {0 = ascending; 1=descending}
      Reserve4   : Word;
      ForExpLen  : Word;     {length of FOR clause}
      Reserve5   : Word;
      KeyExpLen  : Word;     {length of index expression}
      KeyPool    : array[0..pred(CDXBlokSize)] of char;
   end;

   GSptrCDXDataBlk  = ^GSrecCDXDataBlk;
   GSrecCDXDataBlk  = packed Record
      Node_Atr     : word;
      Entry_Ct     : word;
      Left_Ptr     : longint;
      Rght_Ptr     : Longint;
         case byte of
            0   :  (
                    FreeSpace  : Word;    {free space in this key}
                    RecNumMask : LongInt; {bit mask for record number}
                    DupCntMask : Byte;    {bit mask for duplicate byte count}
                    TrlCntMask : Byte;    {bit mask for trailing bytes count}
                    RecNumBits : Byte;    {num bits used for record number}
                    DupCntBits : Byte;    {num bits used for duplicate count}
                    TrlCntBits : Byte;    {num bits used for trail count}
                    ShortBytes : Byte;    {bytes needed for recno+dups+trail}
                    ExtData    : array [0..CDXBlokSize - 25] of Char;
                   );
            1    : (IntData  : array [0..CDXBlokSize - 13] of Char;)
   end;

   GSptrCDXElement = ^GSrecCDXElement;
   GSrecCDXElement = packed Record
      Block_Ax  : Longint;
      Recrd_Ax  : Longint;
      Char_Fld  : array [0..255] of char;
   end;

   GSobjCDXTag = class(GSobjIndexTag)
      OptFlags    : byte;
      CollateType : GSsetCDXCollateType;
      ChgIndicator: longint;
      constructor Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
      destructor  Destroy; override;
      procedure   AdjustValue(AKey: TgsVariant; DoTrim: boolean); override;
      function    IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                           boolean; override;
      function    KeyAdd(st: GSobjIndexKeyData): boolean; override;
      function    PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean; override;
      function    PageStore(PIK: GSobjIndexKey): Boolean; override;
      function    TagLoad: Boolean; override;
      function    TagStore: Boolean; override;
      function    NewRoot: longint; override;
      procedure   DoIndex;

      procedure   ExtNodeBuild(DataBuf: GSptrCDXDataBlk; PIK: GSobjIndexKey);
      procedure   ExtNodeWrite(DataBuf: GSptrCDXDataBlk;
                               PIK: GSobjIndexKey);
      procedure   IntNodeBuild(DataBuf: GSptrCDXDataBlk; PIK: GSobjIndexKey);
      procedure   IntNodeWrite(DataBuf: GSptrCDXDataBlk;
                               PIK: GSobjIndexKey);
   end;


   GSobjCDXFile = class(GSobjIndexFile)
      CDXOpening  : boolean;
      CompoundTag : GSobjCDXTag;
      constructor Create(PDB: GSO_dBaseFld; const FN: string;
                         ReadWrite, Shared, Create, Overwrite: boolean);
      destructor  Destroy; override;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean):
                         boolean; override;
      function    DeleteTag(const ITN: gsUTFString): boolean; override;
      function    GetAvailPage: longint; override;
      function    ResetAvailPage: longint; override;
      function    PageRead(Blok: longint; var Page; Size: integer):
                           boolean; override;
      function    PageWrite(Blok: longint; var Page; Size: integer):
                            boolean; override;
      procedure   Reindex; override;
      function    TagUpdate(AKey: longint; IsAppend: boolean): boolean; override;
      function    ExternalChange: boolean; override;          {!!RFG 091297}
   end;

var
   GSbytCDXCollateInfo : GSsetCDXCollateType;

implementation

const
   ExtSpace = CDXBlokSize-24;

type

   GSobjSortCDX = class(TgsSort)
      curFile: GSO_dBaseFld;
      curTag: GSobjCDXTag;
      KeyWork: TgsVariant;
      KeyCnt: longint;
      KeyTot: longint;
      LastKey: TgsVariant;
      LastTag: longint;
      Closing: boolean;
      NodeList: array[0..31] of GSptrCDXDataBlk;

      constructor  Create(ATag: GSobjCDXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
      destructor   Destroy; override;
      procedure    AddToNode(Lvl: integer; Tag, Link: Longint;
                             Value: TgsVariant);
      procedure    OutputWord;
   end;

{------------------------------------------------------------------------------
                    Conversion/Comparison of Number Fields
------------------------------------------------------------------------------}

function FlipLongint(LVal: longint): longint;
var
   LValAry : array[0..3] of byte absolute LVal;
   NVal    : longint;
   NValAry : array[0..3] of byte absolute NVal;
begin
   NValAry[0] := LValAry[3];
   NValAry[1] := LValAry[2];
   NValAry[2] := LValAry[1];
   NValAry[3] := LValAry[0];
   FlipLongint := NVal;
end;

function FindDupLength(s1, s2: TgsVariant): word;
var
   i : integer;
begin
   s1.Compare(s2,i,MatchIsExact,nil);
   if i > 0 then dec(i);
   FindDupLength := i;
end;

function MakeMask(bc: byte):longint;
var
   i: integer;
   m: longint;
begin
   m := 0;
   for i := 1 to bc do m := (m shl 1) + 1;
   MakeMask := m;
end;

{-----------------------------------------------------------------------------
                                 GSobjSortCDX
-----------------------------------------------------------------------------}

constructor GSobjSortCDX.Create(ATag: GSobjCDXTag; Uniq, Ascnd: boolean; WorkDir: PChar);
begin
   inherited Create(ATag.KeyLength+1, Uniq, true, WorkDir);  {always an ascending sort}
   CurTag := ATag;
   CurFile := ATag.Owner.Owner;
   KeyTot := CurFile.NumRecs;
   KeyCnt := 0;
   Closing := false;
   KeyWork := TgsVariant.Create(256);
   LastKey := TgsVariant.Create(256);
   LastTag := 0;
   FillChar(NodeList, SizeOf(NodeList), #0);
end;

destructor GSobjSortCDX.Destroy;
var
   i: integer;
   pa: longint;
begin
   Closing := true;
   for i := 0 to 30 do
      if NodeList[i] <> nil then
      begin
         pa := NodeList[i]^.Rght_Ptr;
         NodeList[i]^.Rght_Ptr := -1;
         if NodeList[i]^.Entry_Ct > 0 then
         begin
            if NodeList[i+1]  = nil then
            begin
               CurTag.RootBlock := pa;
               inc(NodeList[i]^.Node_Atr);
            end;
            CurTag.Owner.PageWrite(pa, NodeList[i]^, CDXBlokSize);
            if NodeList[i+1] <> nil then
               AddToNode(i+1, pa, LastTag, LastKey);
         end;
         FreeMem(NodeList[i],CDXBlokSize);
      end;
   LastKey.Free;
   KeyWork.Free;
   inherited Destroy;
end;

procedure GSobjSortCDX.AddToNode(Lvl: integer; Tag, Link: Longint;
                                 Value: TgsVariant);

   procedure SetMask;
   var
      i: integer;
      bitcnt: integer;
      sr: longint;
   begin
      sr := KeyTot;
      i := CurTag.KeyLength;
      bitcnt := 0;
      repeat
         inc(bitcnt);
         i := i shr 1;
      until i = 0;
      with NodeList[0]^ do
      begin
         ShortBytes := 3;
         RecNumBits := 24 - (bitcnt*2);
         RecNumMask := MakeMask(RecNumBits);
         while (sr > RecNumMask) and (RecNumMask <> -1) do
         begin
            inc(ShortBytes);
            inc(RecNumBits,8);
            RecNumMask := (RecNumMask shl 8) or $FF;
         end;
         FreeSpace := ExtSpace;
         DupCntBits := bitcnt;
         TrlCntBits := bitcnt;
         DupCntMask := MakeMask(DupCntBits);
         TrlCntMask := MakeMask(TrlCntBits);
      end;
   end;

   procedure AddExternal;
   var
      v: integer;
      r: longint;
      k: integer;
      pa: Longint;
      m : longint;
      c: word;
      ct: word;
      cd: word;
   begin
      if NodeList[Lvl]^.Entry_Ct = 0 then
      begin
         FillChar(NodeList[Lvl]^.ExtData,SizeOf(NodeList[Lvl]^.ExtData),#0);
         NodeList[Lvl]^.FreeSpace := ExtSpace;
         LastKey.PutString('');
      end;
      m := not NodeList[Lvl]^.RecNumMask;
      ct := CurTag.KeyLength - Value.SizeOfVar;
      cd := FindDupLength(Value, LastKey);
      v := (NodeList[Lvl]^.Entry_Ct*NodeList[Lvl]^.ShortBytes);
      k := NodeList[Lvl]^.FreeSpace + v;
      NodeList[Lvl]^.FreeSpace := NodeList[Lvl]^.FreeSpace -
                     ((CurTag.KeyLength+NodeList[Lvl]^.ShortBytes)-(cd+ct));
      c := (ct shl (16-NodeList[Lvl]^.TrlCntBits)) or
           (cd shl (16-(NodeList[Lvl]^.TrlCntBits+NodeList[Lvl]^.DupCntBits)));
      system.move(c, NodeList[Lvl]^.ExtData[(v+NodeList[Lvl]^.ShortBytes)-2], 2);
      system.move(NodeList[Lvl]^.ExtData[v], r, 4);
      r := r and m;
      r := r or Tag;
      system.move(r, NodeList[Lvl]^.ExtData[v], 4);
      k := k - CurTag.KeyLength + cd + ct;
      if CurTag.KeyLength-(cd+ct) > 0 then
         system.move(Value.Memory^[cd], NodeList[Lvl]^.ExtData[k],
                     CurTag.KeyLength -(cd+ct));
      inc(NodeList[Lvl]^.Entry_Ct);
      if (NodeList[Lvl]^.FreeSpace <
         (CurTag.EntryLength+NodeList[Lvl]^.ShortBytes){$IFDEF FOXGENERAL}*2{$ENDIF}) then  {a little slack}
      begin
         pa := NodeList[Lvl]^.Rght_Ptr;
         if KeyCnt < KeyTot then
            NodeList[Lvl]^.Rght_Ptr := CurTag.Owner.GetAvailPage
         else
            NodeList[Lvl]^.Rght_Ptr := -1;
         NodeList[Lvl]^.Node_Atr := 2;
         CurTag.Owner.PageWrite(pa,NodeList[Lvl]^, CDXBlokSize);
         NodeList[Lvl]^.Left_Ptr := pa;
         AddToNode(Lvl+1,pa,Link,Value);
         NodeList[Lvl]^.Entry_Ct := 0;
      end;
   end;

   procedure AddInternal;
   var
      v: integer;
      r: longint;
      pa: Longint;
   begin
      if NodeList[Lvl]^.Entry_Ct = 0 then
         FillChar(NodeList[Lvl]^.IntData,SizeOf(NodeList[Lvl]^.IntData),#0);
      v := (NodeList[Lvl]^.Entry_Ct*CurTag.EntryLength);
      if CurTag.KeyType = 'C' then
         FillChar(NodeList[Lvl]^.IntData[v], CurTag.KeyLength, #32);
      system.move(Value.Memory^[0], NodeList[Lvl]^.IntData[v], Value.SizeOfVar);
      v := v+CurTag.KeyLength;
      r := FlipLongint(Link);
      system.move(r, NodeList[Lvl]^.IntData[v], 4);
      v := v+4;
      r := FlipLongint(Tag);
      system.move(r, NodeList[Lvl]^.IntData[v], 4);
      inc(NodeList[Lvl]^.Entry_Ct);
      if (NodeList[Lvl]^.Entry_Ct  >= (CurTag.MaxKeys)) then
      begin
         pa := NodeList[Lvl]^.Rght_Ptr;
         if not Closing then
            NodeList[Lvl]^.Rght_Ptr := CurTag.Owner.GetAvailPage
         else
            NodeList[Lvl]^.Rght_Ptr := -1;
         NodeList[Lvl]^.Node_Atr := 0;
         CurTag.Owner.PageWrite(pa,NodeList[Lvl]^, CDXBlokSize);
         NodeList[Lvl]^.Left_Ptr := pa;
         AddToNode(Lvl+1,pa,Link,Value);
         NodeList[Lvl]^.Entry_Ct := 0;
      end;
   end;

begin
   if NodeList[Lvl] = nil then
   begin
      GetMem(NodeList[Lvl],CDXBlokSize);
      FillChar(NodeList[Lvl]^,CDXBlokSize,#0);
      if Lvl = 0 then SetMask;
      with NodeList[Lvl]^ do
      begin
         Left_Ptr := -1;
         Rght_Ptr := CurTag.Owner.GetAvailPage;
         if Lvl = 0 then
            Node_Atr := 2
         else
            Node_Atr := 0;
      end;
   end;
   if Lvl = 0 then
      AddExternal
   else
      AddInternal;
end;

procedure GSobjSortCDX.OutputWord;
var
   tmp: TgsVariant;
   tag: longint;
begin
   while GetNextKey(KeyWork,Tag) do
   begin
      inc(KeyCnt);
      curFile.gsStatusUpdate(StatusIndexWr,KeyCnt,0);
      AddToNode(0,Tag,Tag,KeyWork);
      LastTag := Tag;
      tmp := LastKey;
      LastKey := KeyWork;
      KeyWork := tmp;
   end;
end;

{-----------------------------------------------------------------------------
                                 GSobjCDXTag
-----------------------------------------------------------------------------}

constructor GSobjCDXTag.Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
begin
   inherited Create(PIF, ITN, TagHdr);
   DefaultLen := 10;
   TagSig := 'CDX';
   TagName := gsStrUpperCase(TagName);
   if TagHdr <> -1 then
   begin
     Owner.Corrupted := not TagLoad;             {!!RFG 091197}
     if Owner.Corrupted then exit;               {!!RFG 091197}
   end
   else
   begin
      TagBlock := Owner.GetAvailPage;
      Owner.GetAvailPage;           {Need two blocks allocated for header}
      TagChanged := true;
   end;
   OptFlags := $60;
end;

destructor GSobjCDXTag.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjCDXTag.AdjustValue(AKey: TgsVariant; DoTrim: boolean);
var
   numwk: double;
   numar: array[0..7] of byte absolute numwk;
   numrl: array[0..7] of byte;
   v: integer;
   {$IFDEF FOXGENERAL}
   ps2: array[0..255] of char;
   byt: byte;
   msk: byte;
   psp: pchar;
   stw: array[0..255] of char;
   stwp: PChar;
   {$ENDIF}

begin
{$IFDEF FOXGENERAL}
   stwp := stw;
   if KeyType = 'C' then
   begin
      if AKey.TypeOfVar <> gsvtText then
         AKey.PutString(AKey.GetString);
      if DoTrim then AKey.TrimR;
      if (AKey.SizeOfVar = 0) or (CollateType < General) or
         ((OptFlags and 128) <> 0) then  exit;
      FillChar(ps2[0],256,#0);
      psp := ps2;
      v := 0;
      repeat
         byt := GSaryCDXCollateTable[AKey.Memory^[v]];
         msk := GSaryCDXCollateMask[AKey.Memory^[v]];
         if (not (byt in [$00,$06,$12,$18])) or
            (GSaryCDXCollateLigature[byt+1] = 0) then
            stwp[0] := chr(byt)
         else
         begin
            stwp[0] := chr(GSaryCDXCollateLigature[byt+2]);
            stwp := stwp+1;
            stwp[0] := chr(GSaryCDXCollateLigature[byt+4]);
         end;
         stwp := stwp+1;
         if (not (msk = 0)) then
         begin
            if msk <> $80 then
            begin
               psp[0] := chr(msk or $F0);
               psp := psp+1;
            end
            else
            begin
               msk := GSaryCDXCollateLigature[byt+3];
               if msk <> $00 then
               begin
                  psp[0] := chr(msk or $F0);
                  psp := psp+1;
               end;
               msk := GSaryCDXCollateLigature[byt+5];
               if msk <> $00 then
               begin
                  psp[0] := chr(msk or $F0);
                  psp := psp+1;
               end;
            end;
         end;
         inc(v);
      until v = AKey.SizeOfVar;
      stwp[0] := #0;
      psp := psp-1;
      while (psp >= ps2) and (psp[0] = chr($F0)) do psp := psp-1;
      psp := psp+1;
      psp[0] := #0;
      StrCat(stw,ps2);
      AKey.PutBinary(@stw, StrLen(stw));          {%FIX0014}
      exit;
   end;
{$ELSE}
   if KeyType = 'C' then
   begin
      if AKey.TypeOfVar <> gsvtText then          {%FIX0003}
         AKey.PutString(AKey.GetString);
      if DoTrim then AKey.TrimR;
      exit;
   end;
{$ENDIF}

   if KeyType = 'D' then
      AKey.PutFloat(AKey.GetDate);
   numwk := AKey.GetFloat;
   {convert to double and flip bytes for compare}
   if numar[7] > 127 then      {if negative number}
   begin
      for v := 0 to 7 do
         numrl[7-v] := numar[v] xor $FF;
      v := 7;
      while (numrl[v] = $FF) and (v >= 0) do dec(v);
   end
   else
   begin
      numrl[0] := numar[7] or $80;
      for v := 0 to 6 do
         numrl[7-v] := numar[v];
      v := 7;
      while (numrl[v] = $00) and (v >= 0) do dec(v);
   end;
   AKey.PutBinary(@numrl,v+1);
end;

procedure GSobjCDXTag.DoIndex;
var
   withFor: boolean;
   ixColl: GSobjSortCDX;
   ps: GSobjIndexKeyData;
   fchg: boolean;

   procedure EmptyIndex;
   var
      ix: word;
      bc: word;
      CDXData: GSptrCDXDataBlk;
   begin
      GetMem(CDXData, CDXBlokSize);
      FillChar(CDXData^, CDXBlokSize, #0);
      RootBlock := Owner.GetAvailPage;
      CDXData^.Node_Atr := 3;
      CDXData^.Left_Ptr := -1;
      CDXData^.Rght_Ptr := -1;
      ix := KeyLength;
      bc := 0;
      repeat
         inc(bc);
         ix := ix shr 1;
      until ix = 0;
      with CDXData^ do
      begin
         ShortBytes := 3;
         RecNumBits := 24 - (bc*2);
         RecNumMask := MakeMask(RecNumBits);
         FreeSpace := ExtSpace;
         DupCntBits := bc;
         TrlCntBits := bc;
         DupCntMask := MakeMask(DupCntBits);
         TrlCntMask := MakeMask(TrlCntBits);
      end;
      Owner.PageWrite(RootBlock, CDXData^, CDXBlokSize);
      FreeMem(CDXData, CDXBlokSize);
   end;

   procedure ProcessRecord;
   begin
      withFor := Conditional and (Length(ForExpr) > 0);
      if withFor then
         withFor := SolveFilter
      else
         withFor := true;
      if withFor then
      begin
         SolveExpression(ps, fchg);
         AdjustValue(ps,true);
         ixColl.AddKey(ps,Owner.Owner.RecNumber);
      end;
   end;

begin
   if ((OptFlags and 128) <> 0) then
   begin
      EmptyIndex;
   end
   else
   begin
      ps := GSobjIndexKeyData.Create(256);
      with Owner.Owner do
      begin
         ixColl := GSobjSortCDX.Create(Self, UniqueKey, true, PChar(pCollateTable));
         gsStatusUpdate(StatusStart,StatusIndexTo,Owner.Owner.NumRecs);
         if Owner.DiskFile <> nil then
         begin
            RecNumber := 1;            {Read all dBase file records}
            while RecNumber <= NumRecs do
            begin
               gsRead(HeadLen+((RecNumber-1) * RecLen), CurRecord^, RecLen);
               if gsvIsEncrypted then
               begin
                  DBEncryption(gsvPasswordIn,PByteArray(CurRecord),PByteArray(CurRecord),0,RecLen);
               end;
               ProcessRecord;
               gsStatusUpdate(StatusIndexTo,RecNumber,0);
               inc(RecNumber);
            end;
         end
         else
         begin
            gsvIndexState := true;            {!!RFG 083097}
            gsGetRec(Top_Record);    {Read all dBase file records}
            while not File_EOF do
            begin
               ProcessRecord;
               gsStatusUpdate(StatusIndexTo,RecNumber,0);
               gsGetRec(Next_Record);
            end;
            gsvIndexState := false;          {!!RFG 083097}
         end;
         gsStatusUpdate(StatusStop,0,0);
      end;
{      ixColl^.KeyTot := ixColl^.Count;}  (*%FIX 0001 Error on filtered CDX indexes*)
      Owner.Owner.gsStatusUpdate(StatusStart,StatusIndexWr,ixColl.KeyTot);
      if ixColl.Count > 0 then
         ixColl.OutputWord
      else
         EmptyIndex;
      Owner.Owner.gsStatusUpdate(StatusStop,0,0);
      ixColl.Free;
      ps.Free;
   end;
   TagChanged := true;
   TagStore;
end;

procedure GSobjCDXTag.ExtNodeBuild(DataBuf: GSptrCDXDataBlk; PIK: GSobjIndexKey);
var
   i : integer;
   v : integer;
   s : array[0..255] of char;
   d : byte;
   t : byte;
   r : longint;
   c : word;
   k: integer;
   p: GSobjIndexKeyData;
   sp: integer;
   w: integer;                             {!!RFG 090597}
begin
   k := ExtSpace;
   with PIK, DataBuf^ do
   begin
      Space := FreeSpace;
      RNMask := RecNumMask;
      DCMask := DupCntMask;
      TCMask := TrlCntMask;
      RNBits := RecNumBits;
      DCBits := DupCntBits;
      TCBits := TrlCntBits;
      ReqByte:= ShortBytes;
      FillChar(s,SizeOf(s),' ');
      i := 0;
      while i < DataBuf^.Entry_Ct do
      begin
         v := (i*ReqByte);
         system.move(ExtData[(v+ReqByte)-2], c, 2);
         t := (c shr (16-TCBits)) and TCMask;
         d := (c shr (16-(TCBits+DCBits))) and DCMask;
         system.move(ExtData[v], r, 4);
         r := r and RNMask;
         k := k - KeyLength + d + t;
         if KeyLength -(d+t) > 0 then
            system.move(ExtData[k],s[d], KeyLength -(d+t));
         s[KeyLength-t] := #0;
         if KeyType = 'C' then
         begin
            {$IFDEF FOXGENERAL}
            if (CollateType = General) and (KeyType = 'C') then
            begin
               sp := KeyLength - t - 1;
               while (sp > 0) and (s[sp] < #16) do
               begin
                  s[sp] := chr(ord(s[sp]) or $F0);
                  dec(sp);
               end;
            end;
            {$ENDIF}
            TrimRight(s);
            w := StrLen(s);
            t := KeyLength-w;
         end;
         p := GSobjIndexKeyData.Create(0);
         p.Tag := r;
         p.Xtra := r;
         p.PutBinary(@s,KeyLength - t);
         if KeyType = 'C' then p.TypeOfVar := gsvtText;      {%FIX0014}
         Add(p);
         inc(i);
      end;
   end;
end;

procedure GSobjCDXTag.ExtNodeWrite(DataBuf: GSptrCDXDataBlk;
                                   PIK: GSobjIndexKey);
var
   v : integer;
   r : longint;
   m : longint;
   kcnt : integer;
   c: word;
   ct: word;
   cd: word;
   p : GSobjIndexKeyData;
   q : GSobjIndexKeyData;
   k : integer;
   NPN: longint;
   na: word;
   rp: longint;
   lp: longint;
   ck: integer;
   TmpTag: longint;
   sp: integer;                       {!!RFG 090597}
   procedure SetMask;
   var
      i: integer;
      bitcnt: integer;
      sr: longint;
   begin
      if OptFlags > 128 then       {Tag List?}
         sr := Owner.DiskFile.gsFileSize
      else
         sr := Owner.Owner.NumRecs;
      i := KeyLength;
      bitcnt := 0;
      repeat
         inc(bitcnt);
         i := i shr 1;
      until i = 0;
      with PIK do
      begin
         ReqByte := 3;
         RNBits := 24 - (bitcnt*2);
         RNMask := MakeMask(RNBits);
         while sr > RNMask do
         begin
            inc(ReqByte);
            inc(RNBits,8);
            RNMask := (RNMask shl 8) or $FF;
            if RNMask < 0 then                   {!!RFG 012298}
            begin
               RNMask := $7FFFFFFF;
               RNBits := 31;
            end;
         end;
         Space := ExtSpace;
         DCBits := bitcnt;
         TCBits := bitcnt;
         DCMask := MakeMask(DCBits);
         TCMask := MakeMask(TCBits);
      end;
   end;

   function KeysSuggested: word;
   var
      sr : longint;
      i  : integer;
      cd : integer;
      mp : integer;
      lm : integer;
   begin
      with PIK do
      begin
         sr := 0;
         cd := 0;
         mp := 0;
         lm := SizeOf(DataBuf^.IntData) div 2;
         q := nil;
         for i := 0 to Count-1 do
         begin
            p := Items[i];
            if q <> nil then
               cd := FindDupLength(p, q);
            q := p;
            cd := (p.SizeofVar-cd);
            sr := sr + cd + ReqByte;
            if sr < lm then inc(mp);
         end;
         if sr < ExtSpace then mp := Count;
      end;
      KeysSuggested := mp;
   end;

   procedure FillBuffer;
   var
      i: integer;
   begin
      FillChar(DataBuf^.ExtData,SizeOf(DataBuf^.ExtData),#0);
      with DataBuf^, PIK do
      begin
         FreeSpace := Space;
         RecNumMask := RNMask;
         DupCntMask := DCMask;
         TrlCntMask := TCMask;
         RecNumBits := RNBits;
         DupCntBits := DCBits;
         TrlCntBits := TCBits;
         ShortBytes := ReqByte;
         m := not RNMask;
         q := nil;
         Space := ExtSpace;
      end;
      i := 0;
      k := ExtSpace;
      q := nil;
      with PIK do
      begin
         while (i < kcnt) and (ck < PIK.Count) do
         begin
            p := Items[ck];
            ct := KeyLength - p.SizeofVar;
            if q <> nil then
               cd := FindDupLength(p, q)
            else
               cd := 0;
            q := p;
            Space := Space - ((KeyLength+ReqByte)-(cd+ct));
            v := (i*ReqByte);
            c := (ct shl (16-TCBits)) or (cd shl (16-(TCBits+DCBits)));
            system.move(c, DataBuf^.ExtData[(v+ReqByte)-2], 2);
            system.move(DataBuf^.ExtData[v], r, 4);
            r := r and m;
            r := r or p.Tag;
            system.move(r, DataBuf^.ExtData[v], 4);
            k := k - KeyLength + cd + ct;
            if KeyLength-(cd+ct) > 0 then
            system.move(p.Memory^[cd], DataBuf^.ExtData[k], KeyLength -(cd+ct));
            {$IFDEF FOXGENERAL}
            if (CollateType = General) and (KeyType = 'C') then
            begin
               sp := KeyLength - (cd+ct) - 1;
               while (sp >= 0) and (DataBuf^.ExtData[k+sp] >= chr($F0)) do
               begin
                  DataBuf^.ExtData[k+sp] :=
                     chr(ord(DataBuf^.ExtData[k+sp]) and $0F);
                  dec(sp);
               end;
            end;
            {$ENDIF}
            inc(i);
            inc(ck);
            inc(DataBuf^.Entry_Ct);
         end;
      end;
   end;

begin
   SetMask;
   kcnt := KeysSuggested;
   ck := 0;
      DataBuf^.Entry_Ct := 0;
      if kcnt < PIK.Count then
      begin
         FillBuffer;
         NPN := Owner.GetAvailPage;
         TmpTag := p.Tag;
         p.Tag := NPN;
         PIK.AddNodeKey(p);
         p.Tag := TmpTag;
         PIK.PageType := Leaf;
         DataBuf^.Node_Atr := 2;
         na := DataBuf^.Node_Atr;
         rp := DataBuf^.Rght_Ptr;
         lp := DataBuf^.Left_Ptr;
         DataBuf^.Rght_Ptr := PIK.Page;
         DataBuf^.FreeSpace := PIK.Space;
         Owner.PageWrite(NPN, DataBuf^, CDXBlokSize);
         if lp > 0 then
         begin
            Owner.PageRead(lp, DataBuf^, CDXBlokSize);
            DataBuf^.Rght_Ptr := NPN;
            Owner.PageWrite(lp, DataBuf^, CDXBlokSize);
         end;
         FillChar(DataBuf^, CDXBlokSize, #0);
         DataBuf^.Node_Atr := na;
         DataBuf^.Left_Ptr := NPN;
         DataBuf^.Rght_Ptr := rp;
         DataBuf^.Entry_Ct := 0;
         kcnt := PIK.Count;
      end;
      FillBuffer;
      DataBuf^.FreeSpace := PIK.Space;
   Owner.PageWrite(PIK.Page, DataBuf^, CDXBlokSize);
end;



procedure GSobjCDXTag.IntNodeBuild(DataBuf: GSptrCDXDataBlk; PIK: GSobjIndexKey);
var
   i : integer;
   v : integer;
   s : array[0..255] of char;
   n : longint;
   r : longint;
   p: GSobjIndexKeyData;
   sp: integer;                            {!!RFG 090597}
begin
   i := 0;
   while i < DataBuf^.Entry_Ct do
   begin
      v := (i*EntryLength);
      system.move(DataBuf^.IntData[v], s[0], KeyLength);
      s[KeyLength] := #0;
      {$IFDEF FOXGENERAL}
      if (CollateType = General) and (KeyType = 'C') then
      begin
         sp := KeyLength - 1;
         while (sp > 0) and (s[sp] = ' ') do dec(sp);
         while (sp > 0) and (s[sp] < #16) do
         begin
            s[sp] := chr(ord(s[sp]) or $F0);
            dec(sp);
         end;
      end;
      {$ENDIF}
      v := v+KeyLength;
      system.move(DataBuf^.IntData[v], r, 4);
      r := FlipLongint(r);
      v := v+4;
      system.move(DataBuf^.IntData[v], n, 4);
      n := FlipLongint(n);
      if KeyType = 'C' then
      begin
         TrimRight(s);
         v := StrLen(s);
      end
      else
      begin
         v := SizeOf(Double);
         while (v > 0) and (s[pred(v)] = #0) do dec(v);
      end;
      p := GSobjIndexKeyData.Create(0);
      p.Tag := n;
      p.Xtra := r;
      p.PutBinary(@s,v);
      if KeyType = 'C' then p.TypeOfVar := gsvtText;   {%FIX0014}
      PIK.Add(p);
      inc(i);
   end;
end;

procedure GSobjCDXTag.IntNodeWrite(DataBuf: GSptrCDXDataBlk;
                                   PIK: GSobjIndexKey);
var
   i: integer;
   Cnt: integer;
   kcnt: integer;
   p: GSobjIndexKeyData;
   v: integer;
   r: longint;
   NPN: longint;
   na: word;
   rp: longint;
   lp: longint;
   ck: integer;
   TmpTag: longint;
   kt: char;
   sp: integer;                        {!!RFG 090597}

   procedure FillBuffer;
   begin
      i := 0;
      if KeyType = 'C' then
         kt := ' '
      else
         kt := #0;
      FillChar(DataBuf^.IntData,SizeOf(DataBuf^.IntData),kt);
      while (i < kcnt) and (ck < PIK.Count) do
      begin
         p := PIK.Items[ck];
         v := (i*EntryLength);
         system.move(p.Memory^[0], DataBuf^.IntData[v], p.SizeofVar);
         {$IFDEF FOXGENERAL}
         if (CollateType = General) and (KeyType = 'C') then
         begin
            sp := p.SizeofVar;
            dec(sp);
            while (sp >= 0) and (DataBuf^.IntData[v+sp] >= chr($F0)) do
            begin
               DataBuf^.IntData[v+sp] :=
                  chr(ord(DataBuf^.IntData[v+sp]) and $0F);
               dec(sp);
            end;
         end;
         {$ENDIF}
         v := v+KeyLength;
         r := FlipLongint(p.Xtra);
         system.move(r, DataBuf^.IntData[v], 4);
         v := v+4;
         r := FlipLongint(p.Tag);
         system.move(r, DataBuf^.IntData[v], 4);
         inc(i);
         inc(ck);
         inc(DataBuf^.Entry_Ct);
      end;
   end;

begin
   if PIK.Count > MaxKeys then
   begin
      Cnt := Pik.Count div 2;
      Cnt := Pik.Count - Cnt;  {Get odd extra key}
   end
   else
   begin
      Cnt := PIK.Count;
   end;
   ck := 0;
   kcnt := Cnt;
   if PIK.Count > 0 then
   begin
      DataBuf^.Entry_Ct := 0;
      if kcnt < PIK.Count then
      begin
         FillBuffer;
         NPN := Owner.GetAvailPage;
         TmpTag := p.Tag;
         p.Tag := NPN;
         PIK.AddNodeKey(p);
         p.Tag := TmpTag;
         PIK.PageType := Node;
         DataBuf^.Node_Atr := 0;
         na := DataBuf^.Node_Atr;
         rp := DataBuf^.Rght_Ptr;
         lp := DataBuf^.Left_Ptr;
         DataBuf^.Rght_Ptr := PIK.Page;
         Owner.PageWrite(NPN, DataBuf^, CDXBlokSize);
         if lp > 0 then
         begin
            Owner.PageRead(lp, DataBuf^, CDXBlokSize);
            DataBuf^.Rght_Ptr := NPN;
            Owner.PageWrite(lp, DataBuf^, CDXBlokSize);
         end;
         FillChar(DataBuf^, CDXBlokSize, #32);
         DataBuf^.Node_Atr := na;
         DataBuf^.Left_Ptr := NPN;
         DataBuf^.Rght_Ptr := rp;
         DataBuf^.Entry_Ct := 0;
         kcnt := MaxKeys;
      end;
      FillBuffer;
   end;
   Owner.PageWrite(PIK.Page, DataBuf^, CDXBlokSize);
end;

function GSobjCDXTag.IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   ps: TgsVariant;
   chg: boolean;
   i: integer;
   CDXFill: GSptrByteArray;
begin
   IndexTagNew := inherited IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
   InvertRead := not AscendKey;
   if (Length(KeyExp) = 0) then
   begin
      KeyType := 'C';
      KeyLength := 10;
   end
   else
   begin
      ps := TgsVariant.Create(256);
      try
         if not SolveExpression(ps, chg) then exit;
         case ps.TypeOfVar of
            gsvtText,
            gsvtBoolean : begin
                             KeyType := 'C';
                             KeyLength := ps.SizeOfVar;
                             if CollateType = General then KeyLength := KeyLength *2;
                          end;
            gsvtFloat   : begin
                             KeyType := 'N';
                             KeyLength := 8;
                          end;
            gsvtDate    : begin
                             KeyType := 'D';
                             KeyLength := 8;
                          end;
        end;
      finally
         ps.Free;
      end;
   end;
   i := KeyLength+8;
(*   while (i mod 4) <> 0 do i := i + 1;*)
   MaxKeys := ((CDXBlokSize-12) div i);          {!!RFG 100797}
   EntryLength := i;
   GetMem(CDXFill, SizeOf(GSrecCDXHeader));
   FillChar(CDXFill^, SizeOf(GSrecCDXHeader), #0);
   Owner.PageWrite(TagBlock, CDXFill^, SizeOf(GSrecCDXHeader));
   FreeMem(CDXFill, SizeOf(GSrecCDXHeader));
   DoIndex;
   IndexTagNew := true;
end;

function GSobjCDXTag.KeyAdd(st: GSobjIndexKeyData): boolean;
var
   tt: longint;
begin
   tt := st.Xtra;
   st.Xtra := st.Tag;
   KeyAdd := inherited KeyAdd(st);
   st.Xtra := tt;
end;

function GSobjCDXTag.PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean;
var
   CDXData: GSptrCDXDataBlk;
   Cnt: integer;
   IsLeaf: boolean;
begin
   GetMem(CDXData, CDXBlokSize);
   Owner.PageRead(PN, CDXData^, CDXBlokSize);
   Cnt := CDXData^.Entry_Ct;
   if Cnt > 16 then
      PIK.Capacity := (Cnt+1);
   if CDXData^.Node_Atr > 1 then
   begin
      PIK.PageType := Leaf;
      IsLeaf := true;
   end
   else
   begin
      PIK.PageType := Node;
      IsLeaf := false;
   end;
   PIK.Left := CDXData^.Left_Ptr;
   PIK.Right := CDXData^.Rght_Ptr;
   if Cnt > 0 then
   begin
      if IsLeaf then
         ExtNodeBuild(CDXData, PIK)
      else
         IntNodeBuild(CDXData, PIK);
   end;
   FreeMem(CDXData, CDXBlokSize);
   PageLoad := true;
end;

function GSobjCDXTag.PageStore(PIK: GSobjIndexKey): Boolean;
var
   CDXData: GSptrCDXDataBlk;
begin
   GetMem(CDXData, CDXBlokSize);
   FillChar(CDXData^, CDXBlokSize, #0);
   With CDXData^ do
   begin
      if PIK.PageType < Leaf then
         Node_Atr := 0
      else
         Node_Atr := 2;
      if PIK.Owner = nil then inc(Node_Atr);
      Left_Ptr := PIK.Left;
      Rght_Ptr := PIK.Right;
      if Node_Atr < 2 then
         IntNodeWrite(CDXData, PIK)
      else
         ExtNodeWrite(CDXData, PIK);
   end;
   FreeMem(CDXData, CDXBlokSize);
   PageStore := true;
end;

function GSobjCDXTag.TagLoad: Boolean;
var
   CDXHdr: GSptrCDXHeader;
   ps: PChar;
   pv: TgsVariant;
   chg: boolean;
begin
   TagLoad := false;                      {!!RFG 091197}
   GetMem(CDXHdr, CDXBlokSize*2);
   Owner.PageRead(TagBlock, CDXHdr^, CDXBlokSize*2);
   RootBlock := CDXHdr^.Root;
   if RootBlock = 0 then exit;                      {!!RFG 091197}
   if (Owner.DiskFile <> nil) then                 {!!RFG 091197}
   begin
      if RootBlock mod CDXBlokSize <> 0 then exit;  {!!RFG 091197}
      if (RootBlock > Owner.DiskFile.gsFileSize) then exit;    {!!RFG 091197}
   end;
   KeyLength := CDXHdr^.Key_Lgth;
   if KeyLength > 240 then exit;                    {!!RFG 091197}
   MaxKeys := (CDXBlokSize-12) div (KeyLength+8);
   EntryLength := KeyLength+8;
   OptFlags := CDXHdr^.IndexOpts;
   ChgIndicator := CDXHdr^.ChgFlag;
   UniqueKey := (OptFlags and 1) = 1;
   Conditional := (OptFlags and 8) <> 0;
   AscendKey := CDXHdr^.AscDesc = 0;
   InvertRead := not AscendKey;
   ps := CDXHdr^.Col8Kind;
   if (StrIComp(ps,'GENERAL') = 0) then
   begin
      {$IFNDEF FOXGENERAL}
         Owner.FoundError(cdxNoCollateGen,cdxInitError,'General Collate Invalid');
      {$ENDIF}
      CollateType := General;
   end
   else
      if (StrIComp(ps,'MACHINE') = 0) then
         CollateType := Machine
      else
         CollateType := NoCollate;
   ps := CDXHdr^.KeyPool;
   if (OptFlags < 128) and (StrLen(ps) = 0) then exit;      {!!RFG 091197}
   KeyExpr := StrPas(ps);
   PostTagExpression;
   if Conditional then
   begin
      ps := StrEnd(CDXHdr^.KeyPool)+1;
      ForExpr := StrPas(ps);
      PostTagFilter;
   end;
   pv := TgsVariant.Create(256);
   SolveExpression(pv, chg); {get KeyType}
   case pv.TypeOfVar of
      gsvtText,
      gsvtBoolean   : KeyType := 'C';
      gsvtFloat     : KeyType := 'N';
      gsvtDate      : KeyType := 'D';
   end;
   pv.Free;
   FreeMem(CDXHdr, CDXBlokSize*2);
   TagChanged := false;
   TagLoad := true;                       {!!RFG 091197}
end;

function GSobjCDXTag.TagStore: Boolean;
var
   CDXHdr: GSptrCDXHeader;
   se: PChar;
begin
   TagStore := true;
   if TagChanged then
   begin
      if UniqueKey then
         OptFlags := OptFlags or $01;
      if Conditional then
         OptFlags := OptFlags or $08;
      GetMem(CDXHdr, SizeOf(GSrecCDXHeader));
      FillChar(CDXHdr^,SizeOf(GSrecCDXHeader),#0);
      CDXHdr^.Root := RootBlock;
      CDXHdr^.Key_Lgth := KeyLength;
      CDXHdr^.IndexOpts := OptFlags;
      CDXHdr^.ChgFlag := ChgIndicator;
      CDXHdr^.IndexSig := CDXSigDefault;
      if not AscendKey then
         CDXHdr^.AscDesc := 1;

      if ((OptFlags and 128) = 0) then
      begin
         if CollateType = General then
         begin
            StrCopy(CDXHdr^.Col8Kind,'GENERAL');
            CDXHdr^.IndexSig := CDXSigGeneral;
         end;
      end;

      if Length(KeyExpr) <> 0 then
      begin
         CDXHdr^.Reserve4 := succ(Length(KeyExpr));
         CDXHdr^.KeyExpLen := succ(Length(KeyExpr));
         StrPCopy(CDXHdr^.KeyPool, KeyExpr);
      end
      else
         CDXHdr^.KeyExpLen := 1;

      if (Length(ForExpr) <> 0) and Conditional then
      begin
         CDXHdr^.ForExpLen := succ(Length(ForExpr));
         se := StrEnd(CDXHdr^.KeyPool) + 1;
         StrPCopy(se, ForExpr);
      end
      else
         CDXHdr^.ForExpLen := 1;

      Owner.PageWrite(TagBlock, CDXHdr^, SizeOf(GSrecCDXHeader));
      FreeMem(CDXHdr, SizeOf(GSrecCDXHeader));
   end;
   TagChanged := false;
end;

function GSobjCDXTag.NewRoot: longint;
var
   CDXHdr: GSptrCDXHeader;
begin
   GetMem(CDXHdr, SizeOf(GSrecCDXHeader));
   Owner.PageRead(TagBlock, CDXHdr^, SizeOf(GSrecCDXHeader));
   NewRoot := CDXHdr^.Root;
   FreeMem(CDXHdr, SizeOf(GSrecCDXHeader));
end;

{-----------------------------------------------------------------------------
                                 GSobjCDXFile
-----------------------------------------------------------------------------}

constructor GSobjCDXFile.Create(PDB: GSO_dBaseFld; const FN: string;
                                ReadWrite, Shared, Create, Overwrite: boolean);
var
   p: array[0..259] of char;
   ps: array[0..15] of char;
   extpos: string;
begin
   inherited Create(PDB);
   DiskFile := IndexFileOpen(PDB,FN,'.cdx', ReadWrite, Shared, Create, Overwrite);
   if DiskFile = nil then exit;
   KeyWithRec := true;
   CDXOpening := true;
   if (DiskFile.FileFound) and (DiskFile.gsFileSize > CDXBlokSize) then {!!RFG 091397}
   begin
      StrPCopy(p,ExtractFileNameOnly(DiskFile.FileName));
      CompoundTag := GSobjCDXTag.Create(Self,p,0);
      if not Corrupted then                       {!!RFG 091197}
      begin
         GSobjCDXTag(CompoundTag).OptFlags := $E0;
         ResetAvailPage;
         with CompoundTag do
         begin
            TagOpen(0);
            while (not TagEOF) and (not Corrupted) do     {!!RFG 091197}
            begin
               CurKeyInfo.UpperCase(Owner.Owner.UpperTable);
               TagList.Add(GSobjCDXTag.Create(Self,
                               CurKeyInfo.GetPChar(ps),CurKeyInfo.Tag));
               KeyRead(Next_Record);
            end;
         end;
      end;
   end
   else
   begin
      NextAvail := 0;
      StrPCopy(p,ExtractFileNameOnly(DiskFile.FileName));
      CompoundTag := GSobjCDXTag.Create(Self,p,-1);
      GSobjCDXTag(CompoundTag).OptFlags := $E0;
      CompoundTag.IndexTagNew(p,'','',true,false);
      CompoundTag.TagOpen(0);
   end;
   GSbytCDXCollateInfo := Machine;
   if (not Corrupted) and (PDB <> nil) and (PDB.IndexFlag = $00) then {!!RFG 091197}
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
   CDXOpening := false;
   CreateOK := not Corrupted;             {!!RFG 091197}
end;

destructor GSobjCDXFile.Destroy;
begin
   if CompoundTag <> nil then
   begin
      CompoundTag.TagClose;
      CompoundTag.Free;
      CompoundTag := nil;
   end;
   inherited Destroy;
end;

function GSobjCDXFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   p: GSobjCDXTag;
   i: integer;
   j: integer;
   ps: GSobjIndexKeyData;
begin
   CompoundTag.TagOpen(0);
   ps := GSobjIndexKeyData.Create(0);
   ps.PutString(ITN);
   ps.UpperCase(Owner.UpperTable);
   j := -1;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      if gsStrCompareI(p.TagName, ps.GetString) = 0 then j := i;
   end;
   if j <> -1 then
   begin
      p := TagList.Items[j];
      ps.Tag := p.TagBlock;
      if CompoundTag.KeyFind(ps) > 0 then
         CompoundTag.RootPage.DeleteKey;
      TagList.FreeOne(p);
   end;
   p := GSobjCDXTag.Create(Self,ITN,-1);
   p.CollateType := GSbytCDXCollateInfo;
   TagList.Add(p);
   ps.Tag := p.TagBlock;
   AddTag := p.IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
   CompoundTag.KeyAdd(ps);
   ps.Free;
   CompoundTag.RootPage.Changed := true;
   CompoundTag.TagClose;
end;

function GSobjCDXFile.DeleteTag(const ITN: gsUTFString): boolean;
var
   p: GSobjCDXTag;
   i: integer;
   j: integer;
   ps: GSobjIndexKeyData;
begin
   DeleteTag := false;
   if TagList.Count = 0 then exit;
   ps := GSobjIndexKeyData.Create(0);
   ps.PutString(ITN);
   ps.UpperCase(Owner.UpperTable);
   j := -1;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      if gsStrCompareI(p.TagName, ps.GetString) = 0 then j := i;
   end;
   if j <> -1 then
   begin
      CompoundTag.TagOpen(0);
      p := TagList.Items[j];
      ps.Tag := p.TagBlock;
      if CompoundTag.KeyFind(ps) > 0 then
         CompoundTag.RootPage.DeleteKey;
      TagList.FreeOne(p);
      CompoundTag.RootPage.Changed := true;
      CompoundTag.TagClose;
      if TagList.Count = 0 then Reindex;
   end;
   ps.Free;
   DeleteTag := j <> -1;
end;

function GSobjCDXFile.GetAvailPage: longint;
begin
   if NextAvail = -1 then ResetAvailPage;
   GetAvailPage := NextAvail;
   inc(NextAvail,CDXBlokSize);
end;

function GSobjCDXFile.ResetAvailPage: longint;
begin
   NextAvail := DiskFile.gsFileSize;
   ResetAvailPage := NextAvail;
end;

function GSobjCDXFile.PageRead(Blok: longint; var Page; Size: integer):
                               boolean;
begin
   PageRead := inherited PageRead(Blok, Page, Size);
end;

function GSobjCDXFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
begin
   PageWrite := inherited PageWrite(Blok, Page, Size);
end;

procedure GSobjCDXFile.Reindex;
var
   p: GSobjCDXTag;
   ps: GSobjIndexKeyData;
   i: integer;
begin
   DiskFile.gsLockFile;
   with CompoundTag do
   begin
      TagOpen(0);
      while not TagEOF do
      begin
         RootPage.DeleteKey;
         KeyRead(Bttm_Record);
      end;
   end;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      p.TagClose;
   end;
   DiskFile.gsTruncate(CDXBlokSize*3);
   NextAvail := CDXBlokSize*3;   {Room for tag index}
   CompoundTag.RootPage.Page := CDXBlokSize*2;
   CompoundTag.RootBlock := CDXBlokSize*2;
   CompoundTag.ChgIndicator := 0;
   CompoundTag.TagChanged := true;
   CompoundTag.RootPage.Changed := true;
   CompoundTag.TagClose;
   for i := 0 to pred(TagList.Count) do
   begin
      p := TagList.Items[i];
      p.TagBlock := GetAvailPage;
      GetAvailPage;                {Need two blocks for tag header}
      p.TagChanged := true;
      p.ChgIndicator := 0;
      p.TagStore;
      p.DoIndex;
      ps := GSobjIndexKeyData.Create(0);
      ps.PutString(p.TagName);
      ps.Tag := p.TagBlock;
      CompoundTag.KeyAdd(ps);
      ps.Free;
   end;
   CompoundTag.TagClose;
   DiskFile.gsUnLock;
end;

function GSobjCDXFile.TagUpdate(AKey: longint; IsAppend: boolean): boolean;
begin
   Result := inherited TagUpdate(AKey, IsAppend);
   if Result then
   begin
      inc(CompoundTag.ChgIndicator);
      CompoundTag.TagChanged := true;
      CompoundTag.TagStore;
   end;
end;

function GSobjCDXFile.ExternalChange: boolean;   {!!RFG 091297}
var
   CDXHdr: GSptrCDXHeader;
   chg: boolean;
begin
   ExternalChange := false;
   if (DiskFile = nil) or (not DiskFile.FileShared) then exit;
   GetMem(CDXHdr, CDXBlokSize);
   PageRead(0, CDXHdr^, CDXBlokSize);
   chg := CompoundTag.ChgIndicator <> CDXHdr^.ChgFlag;
   FreeMem(CDXHdr, CDXBlokSize);
   ExternalChange := chg;
end;

end.


