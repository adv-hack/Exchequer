unit gs6_ntx;
{-----------------------------------------------------------------------------
                          Basic Index File Routine

       gsf_Ntx Copyright (c) 1996 Griffin Solutions, Inc.

       Date
          18 Apr 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the objects to manage Clipper NTX index
       files.

   Changes:

 ------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysUtils,
   gs6_dbf,
   gs6_date,
   gs6_disk,
   gs6_glbl,
   gs6_indx,
   gs6_sort,
   gs6_sql,
   gs6_lcal,
   gs6_tool;

{private}

const
   NTXBlokSize = 1024;

type

   GSptrNTXHeader  = ^GSrecNTXHeader;
   GSrecNTXHeader  = packed Record
      SigByte     : SmallInt;                      {!!RFG 101497}
      IndxUpdt    : SmallInt;                      {!!RFG 101497}
      Root        : Longint;
      FreeBlk     : Longint;
      Entry_Sz    : SmallInt;
      Key_Lgth    : SmallInt;
      Key_Dcml    : SmallInt;
      Max_Keys    : SmallInt;
      Min_Keys    : SmallInt;
      Key_Form    : array [0..255] of char;
      UniqueNTX   : byte;
      DescendNTX  : byte;
      SomeThing   : word;                             {!!RFG 101497}
      For_Form    : array [0..255] of char;
      IndexName   : array [0..10] of char;
      Unused      : array [0..474] of char;           {!!RFG 101497}
   end;


   GSptrNTXDataBlk  = ^GSrecNTXDataBlk;
   GSrecNTXDataBlk  = packed Record
      case byte of
         0 : (Data_Ary    : array [0..NTXBlokSize-1] of byte);
         1 : (Indx_Ary    : array [0..(NTXBlokSize div 2)-1] of word);
         2 : (Entry_Ct    : SmallInt);
   end;

   GSptrNTXElement = ^GSrecNTXElement;
   GSrecNTXElement = packed Record
      Block_Ax  : Longint;
      Recrd_Ax  : Longint;
      Char_Fld  : array [0..255] of char;
   end;

   GSobjNTXTag = class(GSobjIndexTag)
      KeyDecimals: integer;
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
      procedure   PostTagExpression; override;
      procedure   DoIndex;
   end;


   GSobjNTXFile = class(GSobjIndexFile)
      UpdtCtr:    SmallInt;
      constructor Create(PDB: GSO_dBaseFld; const FN: gsUTFString;
                         ReadWrite, Shared, Create, Overwrite: boolean);
      destructor  Destroy; override;
      function    AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean; override;
      function    GetAvailPage: longint; override;
      function    ResetAvailPage: longint; override;
      function    PageRead(Blok: longint; var Page; Size: integer): boolean; override;
      function    PageWrite(Blok: longint; var Page; Size: integer): boolean; override;
      procedure   ReIndex; override;
      function    TagUpdate(AKey: longint; IsAppend: boolean): boolean; override;
      procedure   Zap; virtual;
      function    ExternalChange: boolean; override;  {!!RFG 101497}
   end;

implementation

type
   GSobjSortNTX = class(TgsSort)
      curFile: GSO_dBaseFld;
      curTag: GSobjNTXTag;
      KeyWork: TgsVariant;
      KeyCnt: longint;
      KeyTot: longint;
      Closing: boolean;
      NodeList: array[0..31] of GSptrNTXDataBlk;

      constructor  Create(ATag: GSobjNTXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
      destructor   Destroy; override;
      procedure    AddToNode(Lvl: integer; Tag, Link: Longint;
                             Value: TgsVariant);
      procedure    OutputWord;
   end;

{-----------------------------------------------------------------------------
                                 GSobjSortNTX
-----------------------------------------------------------------------------}

constructor GSobjSortNTX.Create(ATag: GSobjNTXTag; Uniq, Ascnd: Boolean; WorkDir: PChar);
begin
   inherited Create(ATag.KeyLength+1, Uniq, Ascnd, WorkDir);  {Always an ascending sort}
   CurTag := ATag;
   CurFile := ATag.Owner.Owner;
   KeyTot := CurFile.NumRecs;
   KeyCnt := 0;
   Closing := false;
   KeyWork := TgsVariant.Create(256);
   FillChar(NodeList, SizeOf(NodeList), #0);
end;

destructor GSobjSortNTX.Destroy;
var
   i: integer;
   pa: longint;
   ec: integer;
   elm: GSptrNTXElement;
begin
   Closing := true;
   for i := 0 to 30 do
      if NodeList[i] <> nil then
      begin
         pa := CurTag.Owner.GetAvailPage;
         if NodeList[i+1]  = nil then CurTag.RootBlock := pa;
         ec := NodeList[i]^.Entry_Ct;
         elm := Addr(NodeList[i]^.Data_Ary[NodeList[i]^.Indx_Ary[ec]]);
         if i > 0 then
         begin
            elm^.Recrd_AX := 0;
            dec(NodeList[i]^.Entry_Ct);
         end;
         CurTag.Owner.PageWrite(pa, NodeList[i]^, NTXBlokSize);
         KeyWork.PutBinary(@elm^.Char_Fld, CurTag.KeyLength);
         if NodeList[i+1] <> nil then
         begin
            AddToNode(i+1,elm^.Recrd_AX,pa,KeyWork);
         end;
         FreeMem(NodeList[i],NTXBlokSize);
      end;
   KeyWork.Free;
   inherited Destroy;
end;

procedure GSobjSortNTX.AddToNode(Lvl: integer; Tag, Link: Longint;
                                 Value: TgsVariant);
var
   ec: integer;
   ix: integer;
   pa: longint;
   ps: GSobjIndexKeyData;
   tg: longint;
   elm: GSptrNTXElement;
   postit: boolean;
begin
   if NodeList[Lvl] = nil then
   begin
      GetMem(NodeList[Lvl],NTXBlokSize);
      FillChar(NodeList[Lvl]^,NTXBlokSize,#0);
      for ix := 1 to succ(CurTag.MaxKeys) do
         NodeList[Lvl]^.Indx_Ary[ix] :=
                      (pred(ix)*CurTag.EntryLength)+((CurTag.MaxKeys+2)*2);
   end;
   ec := NodeList[Lvl]^.Entry_Ct;
   postit := true;
   if (ec >= KeyTot) then
   begin
      pa := CurTag.Owner.GetAvailPage;
      if Lvl > 0 then
      begin
         ps := GSobjIndexKeyData.Create(256);
         elm := Addr(NodeList[Lvl]^.Data_Ary[NodeList[Lvl]^.Indx_Ary[ec]]);
         ps.PutBinary(@elm^.Char_Fld, CurTag.KeyLength);
         tg := elm^.Recrd_AX;
         dec(NodeList[Lvl]^.Entry_Ct);
         elm^.Recrd_AX := 0;
         CurTag.Owner.PageWrite(pa, NodeList[Lvl]^, NTXBlokSize);
         AddToNode(Lvl+1,tg,pa,ps);
         ps.Free;
      end
      else
      begin
         CurTag.Owner.PageWrite(pa, NodeList[Lvl]^, NTXBlokSize);
         AddToNode(Lvl+1,Tag,pa,Value);
         postit := false;
      end;
      FillChar(NodeList[Lvl]^,NTXBlokSize,#0);
      for ix := 1 to succ(CurTag.MaxKeys) do
         NodeList[Lvl]^.Indx_Ary[ix] :=
                      (pred(ix)*CurTag.EntryLength)+((CurTag.MaxKeys+2)*2);
      ec := 0;
   end;
   if postit then
   begin
      elm := Addr(NodeList[Lvl]^.Data_Ary[NodeList[Lvl]^.Indx_Ary[succ(ec)]]);
      elm^.Recrd_AX := Tag;
      elm^.Block_AX := Link;
      Move(Value.Memory^[0],elm^.Char_Fld,CurTag.KeyLength);
      inc(NodeList[Lvl]^.Entry_Ct);
   end;
end;

procedure GSobjSortNTX.OutputWord;

var
   tag: longint;
begin
   while GetNextKey(KeyWork,Tag) do
   begin
      inc(KeyCnt);
      curFile.gsStatusUpdate(StatusIndexWr,KeyCnt,0);
      KeyWork.PadR(CurTag.KeyLength);
      AddToNode(0,Tag,0,KeyWork);
   end;
end;

{-----------------------------------------------------------------------------
                                 GSobjNTXTag
-----------------------------------------------------------------------------}

constructor GSobjNTXTag.Create(PIF: GSobjIndexFile; const ITN: gsUTFString; TagHdr: longint);
begin
   inherited Create(PIF, ITN, TagHdr);
   TagSig := 'NTX';
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

destructor GSobjNTXTag.Destroy;
begin
   inherited Destroy;
end;

procedure GSobjNTXTag.AdjustValue(AKey: TgsVariant; DoTrim: boolean);
var
   numwk: FloatNum;
   dtewk: longint;
   v: integer;
   st: string;
   IsNeg: boolean;
begin
   case KeyType of
      'C'     : begin
                     st := AKey.GetString;
                     if DoTrim then st := TrimRight(st);
                     AKey.PutString(st);
                   if Owner.Dictionary then
                      AKey.UpperCase(Owner.Owner.UpperTable);
                end;
      'N'     : begin
                   numwk := AKey.GetFloat;
                   IsNeg := numwk < 0.0;
                   if IsNeg then
                      numwk := numwk * (-1);
                   str(numwk:KeyLength:KeyDecimals,st);
                   for v := 1 to length(st) do
                      if st[v] = #$20 then st[v] := #$30;
                   if IsNeg then
                   begin
                      for v := 1 to length(st) do
                         if st[v] in ['0'..'9'] then
                            st[v] := chr($2C  - (ord(st[v])-$30));
                   end;
                   AKey.PutString(st);
                end;
      'D'     : begin
                   dtewk := AKey.GetDate;
                   if dtewk > 0 then
                      st := DBFDate.DTOS(dtewk)
                   else
                      st := '00000000';
                   AKey.PutString(st);
                end;
   end;
end;

procedure GSobjNTXTag.DoIndex;
var
   ixColl: GSobjSortNTX;
   fchg: boolean;
   withFor: boolean;                                            {!!RFG 101497}
   ps: TgsVariant;
   kc: integer;
   kv: integer;
begin
   ps := TgsVariant.Create(256);
   with Owner.Owner do
   begin
      ixColl := GSobjSortNTX.Create(Self, UniqueKey, AscendKey, PChar(pCollateTable));
      gsStatusUpdate(StatusStart,StatusIndexTo,Owner.Owner.NumRecs);
      gsGetRec(Top_Record);             {Read all dBase file records}
      while not File_EOF do
      begin
         withFor := Conditional and (Length(ForExpr) > 0);
         if withFor then
            withFor := SolveFilter
         else
            withFor := true;
         if withFor then
         begin
            SolveExpression(ps, fchg);
            AdjustValue(ps, true);
            ixColl.AddKey(ps,RecNumber);
         end;
         gsStatusUpdate(StatusIndexTo,RecNumber,0);
         gsGetRec(Next_Record);
      end;
      gsStatusUpdate(StatusStop,0,0);
   end;
   Owner.Owner.gsStatusUpdate(StatusStart,StatusIndexWr,ixColl.KeyTot);
   kc := ixColl.Count div MaxKeys;
   if (kc * MaxKeys) <= ixColl.Count then inc(kc);
   kv := ixColl.Count div kc;
   if (kv * kc) < ixColl.Count then inc(kv);
   ixColl.KeyTot := kv;
   ixColl.OutputWord;
   Owner.Owner.gsStatusUpdate(StatusStop,0,0);
   ixColl.Free;
   ps.Free;
   TagChanged := true;
   TagStore;
end;

function GSobjNTXTag.IndexTagNew(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   ps: TgsVariant;
   chg: boolean;
   i: integer;
   NTXFill: GSptrByteArray;
   fn: integer;
   fl: integer;
   fd: integer;
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
                       KeyDecimals := 0;
                    end;
      gsvtFloat   : begin
                       fl := 18;
                       fd := 4;
                       if Owner.Owner <> nil then
                       begin
                          fn := Owner.Owner.gsFieldNo(KeyExp);
                          if fn > 0 then
                          begin
                             fl := Owner.Owner.gsFieldLength(fn);
                             fd := Owner.Owner.gsFieldDecimals(fn);
                          end;
                       end;
                       KeyType := 'N';
                       KeyLength := fl;
                       KeyDecimals := fd;
                    end;
      gsvtDate    : begin
                       KeyType := 'D';
                       KeyLength := 8;
                       KeyDecimals := 0;
                    end;
   end;
(*
   if KeyDecimals > 0 then
      KeyLength := KeyLength + KeyDecimals + 1;
*)
   i := KeyLength+8;
   MinKeys := (((NTXBlokSize-4) div (i+2)) - 1) div 2;
   MaxKeys := MinKeys * 2;
   EntryLength := i;
   ps.Free;
   GetMem(NTXFill, NTXBlokSize);
   FillChar(NTXFill^, NTXBlokSize, #0);
   Owner.PageWrite(TagBlock, NTXFill^, NTXBlokSize);
   if Owner.Owner.NumRecs > 0 then
   begin
      DoIndex;
   end
   else
   begin
      RootBlock := Owner.GetAvailPage;
      Owner.PageWrite(RootBlock, NTXFill^, NTXBlokSize);
      TagChanged := true;
      TagStore;
   end;
   FreeMem(NTXFill, NTXBlokSize);
   IndexTagNew := true;
end;

function GSobjNTXTag.KeyAdd(st: GSobjIndexKeyData): boolean;
begin
   KeyAdd := inherited KeyAdd(st);
end;

function GSobjNTXTag.PageLoad(PN: longint; PIK: GSobjIndexKey): Boolean;
var
   NTXData: GSptrNTXDataBlk;
   NTXElem: GSptrNTXElement;
   i: integer;
   Cnt: integer;
   IsLeaf: boolean;
   KeyB: PChar;
   KeyE: PChar;
   p: GSobjIndexKeyData;
   q: GSobjIndexKeyData;
   len: integer;
   OnBottom: boolean;
   ik: GSobjIndexKey;
   plc: integer;
   pb: GSobjIndexKeyData;
begin
   GetMem(NTXData, NTXBlokSize);
   Owner.PageRead(PN, NTXData^, NTXBlokSize);
   Cnt := NTXData^.Entry_Ct;
   NTXElem := Addr(NTXData^.Data_Ary[NTXData^.Indx_Ary[1]]);
   if NTXElem^.Block_AX = 0 then
   begin
      PIK.PageType := Leaf;
      IsLeaf := true;
   end
   else
   begin
      PIK.PageType := Node;
      IsLeaf := false;
   end;
   if Cnt > 0 then
   begin
      for i := 1 to Cnt do
      begin
         NTXElem := Addr(NTXData^.Data_Ary[NTXData^.Indx_Ary[i]]);
         KeyB := Addr(NTXElem^.Char_Fld);
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
         p := GSobjIndexKeyData.Create(0);
         p.PutBinary(KeyB, len);
         if KeyType = 'C' then p.TypeOfVar := gsvtText;      {%FIX0014}
         if IsLeaf then
            p.Tag := NTXElem^.Recrd_AX
         else
            p.Tag := NTXElem^.Block_AX;
         p.Xtra := NTXElem^.Recrd_AX;
         PIK.Add(p);
      end;
   end;
   if (((PIK.Owner = nil) or (Cnt = 0)) and (not isLeaf)) then
   begin
      NTXElem := Addr(NTXData^.Data_Ary[NTXData^.Indx_Ary[succ(Cnt)]]);
      p := GSobjIndexKeyData.Create(0);
      p.PutString(#$FF);
      p.Tag := NTXElem^.Block_AX;
      p.Xtra := 0;
      PIK.Add(p);
   end
   else
   begin
      if (PIK.Owner <> nil) then
(*         ((PIK.Owner.CurKey < pred(PIK.Owner.Count)) or (not IsLeaf)) then*)
      begin
         OnBottom := true;
         ik := PIK.Owner;
         plc := PIK.Page;
         while OnBottom and (ik <> nil) do
         begin
            if ik.Count > 0 then
            begin
               pb := ik.Items[pred(ik.Count)];
               OnBottom := plc = pb.Tag;
               plc := ik.Page;
            end;
            ik := ik.Owner;
         end;
         if (not OnBottom) or (not isLeaf) then
         begin
            NTXElem := Addr(NTXData^.Data_Ary[NTXData^.Indx_Ary[succ(Cnt)]]);
            q := PIK.Owner.Items[PIK.Owner.CurKey];
            p := q.CloneLinks;
            if IsLeaf then
               p.Tag := p.Xtra
            else
               p.Tag := NTXElem^.Block_AX;
            PIK.Add(p);
         end;
      end;
   end;
   FreeMem(NTXData, NTXBlokSize);
   PageLoad := true;
end;

function GSobjNTXTag.PageStore(PIK: GSobjIndexKey): Boolean;
var
   NTXData: GSptrNTXDataBlk;
   NTXElem: GSptrNTXElement;
   kcnt: integer;
   epos: integer;
   p: GSobjIndexKeyData;
   ix: integer;
   NPN: longint;
   OnBottom: boolean;
   ik: GSobjIndexKey;
   Cnt: integer;
   TmpTag: longint;
   pt: GSsetPageType;
   plc: integer;
begin
   pt := PIK.PageType;
   OnBottom := true;
   p := nil;
   ik := PIK.Owner;
   plc := PIK.Page;
   while OnBottom and (ik <> nil) do
   begin
      if ik.Count > 0 then
      begin
         p := ik.Items[pred(ik.Count)];
         OnBottom := plc = p.Tag;
         plc := ik.Page;
      end;
      ik := ik.Owner;
   end;
   GetMem(NTXData, NTXBlokSize);
   FillChar(NTXData^, NTXBlokSize, #0);
   for ix := 1 to succ(MaxKeys) do
      NTXData^.Indx_Ary[ix] := (pred(ix)*EntryLength)+((MaxKeys+2)*2);
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
      if (kcnt = 0) then
      begin
         dec(epos);
         NTXData^.Entry_Ct := epos;
         NPN := Owner.GetAvailPage;
         TmpTag := p.Tag;
         p.Tag := NPN;
         PIK.AddNodeKey(p);
         p.Tag := TmpTag;
         PIK.PageType := pt;
         if PIK.PageType = Root then PIK.PageType := Node;
         Owner.PageWrite(NPN, NTXData^, NTXBlokSize);
         FillChar(NTXData^, NTXBlokSize, #0);
         for ix := 1 to succ(MaxKeys) do
            NTXData^.Indx_Ary[ix] := (pred(ix)*EntryLength)+((MaxKeys+2)*2);
         kcnt := MaxKeys;
         epos := 0;
      end;
      p := PIK.Items[PIK.CurKey];
      NTXElem := Addr(NTXData^.Data_Ary[NTXData^.Indx_Ary[succ(epos)]]);
      if PIK.PageType >= Leaf then
            NTXElem^.Recrd_AX := p.Tag
         else
         begin
            NTXElem^.Block_AX := p.Tag;
            NTXElem^.Recrd_AX := p.Xtra;
         end;
      FillChar(NTXElem^.Char_Fld, KeyLength, #32);
      Move(p.Memory^, NTXElem^.Char_Fld, p.SizeOfVar);
      inc(PIK.CurKey);
      dec(kcnt);
      inc(epos);
   until PIK.CurKey >= PIK.Count;
   if (PIK.PageType < Leaf) then
   begin
      dec(epos);
   end
   else
      if not OnBottom then dec(epos);
   NTXData^.Entry_Ct := epos;
   Owner.PageWrite(PIK.Page, NTXData^, NTXBlokSize);
   FreeMem(NTXData, NTXBlokSize);
   PageStore := true;
end;

function GSobjNTXTag.TagLoad: Boolean;
var
   NTXHdr: GSptrNTXHeader;
   pv: TgsVariant;
   chg: boolean;
begin
   TagLoad := true;
   GetMem(NTXHdr, NTXBlokSize);
   Owner.PageRead(TagBlock, NTXHdr^, NTXBlokSize);
   RootBlock := NTXHdr^.Root;
   GSobjNTXFile(Owner).UpdtCtr := NTXHdr^.IndxUpdt;
   KeyLength := NTXHdr^.Key_Lgth;
   MaxKeys := NTXHdr^.Max_Keys;
   MinKeys := NTXHdr^.Min_Keys;
   KeyDecimals := NTXHdr^.Key_Dcml;
   EntryLength := NTXHdr^.Entry_Sz;
   UniqueKey := (NTXHdr^.UniqueNTX and 1) = 1;
   AscendKey := (NTXHdr^.DescendNTX and 1) = 0;
   InvertCmpr := not AscendKey;
   KeyExpr := StrPas(NTXHdr^.Key_Form);
   PostTagExpression;
   Conditional := (NTXHdr^.SigByte and 1) > 0;
   if Conditional then
   begin
      ForExpr := StrPas(NTXHdr^.For_Form);
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
   FreeMem(NTXHdr, NTXBlokSize);                       {!!RFG 101497}
   TagChanged := false;
end;

function GSobjNTXTag.TagStore: Boolean;
var
   NTXHdr: GSptrNTXHeader;
begin
   TagStore := true;
   if TagChanged then
   begin
      GetMem(NTXHdr, NTXBlokSize);
      FillChar(NTXHdr^,NTXBlokSize,#0);
      if Conditional then                      {!!RFG 101497}
         NTXHdr^.SigByte := 7                  {!!RFG 101497}
      else                                     {!!RFG 101497}
         NTXHdr^.SigByte := 6;                 {!!RFG 101497}
      NTXHdr^.IndxUpdt := GSobjNTXFile(Owner).UpdtCtr;
      NTXHdr^.Root := RootBlock;
      NTXHdr^.Key_Lgth := KeyLength;
      NTXHdr^.Max_Keys := MaxKeys;
      NTXHdr^.Min_Keys := MinKeys;
      NTXHdr^.Entry_Sz := EntryLength;
      NTXHdr^.Key_Dcml := KeyDecimals;
      if UniqueKey then
         NTXHdr^.UniqueNTX := 1;
      if not AscendKey then
         NTXHdr^.DescendNTX := 1;
      StrPCopy(NTXHdr^.Key_Form, KeyExpr);
      if Conditional then                               {!!RFG 101497}
         StrPCopy(NTXHdr^.For_Form, ForExpr);            {!!RFG 101497}
      Owner.PageWrite(TagBlock, NTXHdr^, NTXBlokSize);
      FreeMem(NTXHdr, NTXBlokSize);
   end;
   TagChanged := false;
end;

function GSobjNTXTag.NewRoot: longint;
var
   NTXHdr: GSptrNTXHeader;
begin
   GetMem(NTXHdr, SizeOf(GSrecNTXHeader));
   Owner.PageRead(TagBlock, NTXHdr^, SizeOf(GSrecNTXHeader));
   NewRoot := NTXHdr^.Root;
   FreeMem(NTXHdr, SizeOf(GSrecNTXHeader));
end;

procedure GSobjNTXTag.PostTagExpression;
var
   dLink: TgsExpUserLink;
begin
   inherited PostTagExpression;
   dLink := ExprHandlr.UserLink;
   if dLink <> nil then
      dlink.DefaultStrSize := -1;
end;


{-----------------------------------------------------------------------------
                                 GSobjNTXFile
-----------------------------------------------------------------------------}

constructor GSobjNTXFile.Create(PDB: GSO_dBaseFld; const FN: string;
                                ReadWrite, Shared, Create, Overwrite: boolean);
var
   p: array[0..15] of char;
begin
   inherited Create(PDB);
   DiskFile := IndexFileOpen(PDB,FN,'.ntx',ReadWrite, Shared, Create, Overwrite);
   if DiskFile <> nil then
   begin
      if not Create then
      begin
         StrPCopy(p,ExtractFileNameOnly(IndexName));
         TagList.Add(GSobjNTXTag.Create(Self,p,0));
         NextAvail := DiskFile.gsFileSize;
      end
      else
      begin
         NextAvail := 0;
         UpdtCtr := 1;
      end;
      CreateOK := true;
   end;
end;

destructor GSobjNTXFile.Destroy;
begin
   inherited Destroy;
end;

function GSobjNTXFile.AddTag(const ITN,KeyExp,ForExp: gsUTFString; Ascnd,Uniq: boolean): boolean;
var
   p: GSobjIndexTag;
begin
   NextAvail := 0;
   p := GSobjNTXTag.Create(Self,ITN,-1);
   TagList.Add(p);
   AddTag := p.IndexTagNew(ITN,KeyExp,ForExp,Ascnd,Uniq);
end;

function GSobjNTXFile.GetAvailPage: longint;
begin
   if NextAvail = -1 then ResetAvailPage;
   GetAvailPage := NextAvail;
   inc(NextAvail,NTXBlokSize);
end;

function GSobjNTXFile.ResetAvailPage: longint;
begin
   NextAvail := DiskFile.gsFileSize;
   ResetAvailPage := NextAvail;
end;

function GSobjNTXFile.PageRead(Blok: longint; var Page; Size: integer):
                               boolean;
begin
   PageRead := inherited PageRead(Blok, Page, Size);
end;

function GSobjNTXFile.PageWrite(Blok: longint; var Page; Size: integer):
                                  boolean;
begin
   PageWrite := inherited PageWrite(Blok, Page, Size);
end;

procedure GSobjNTXFile.Reindex;
var
   p: GSobjNTXTag;
begin
   if TagList.Count = 0 then exit;
   Zap;
   p := TagList.Items[0];
   p.IndexTagNew(p.TagName,p.KeyExpr,p.ForExpr,p.AscendKey,p.UniqueKey);
end;

function GSobjNTXFile.TagUpdate(AKey: longint; IsAppend: boolean): boolean;
var
   p: GSobjIndexTag;
begin
   if TagList.Count = 0 then
   begin
      TagUpdate := false;
      exit;
   end;
   if UpdtCtr > 32766 then                 {!!RFG 102497}
      UpdtCtr := 0;
   inc(UpdtCtr);
   p := TagList.Items[0];
   p.TagChanged := true;
   p.TagStore;
   TagUpdate := inherited TagUpdate(AKey, IsAppend);
end;

procedure GSobjNTXFile.Zap;
var
   p: GSobjIndexTag;
   NTXFill: GSptrByteArray;
begin
   if TagList.Count = 0 then exit;
   DiskFile.gsLockFile;
   p := TagList.Items[0];
   p.TagClose;
   DiskFile.gsTruncate(NTXBlokSize*2);
   p.TagChanged := true;
   p.RootBlock := NTXBlokSize;
   NextAvail := NTXBlokSize*2;
   UpdtCtr := 1;                            {!!RFG 101497}
   p.TagStore;
   GetMem(NTXFill,NTXBlokSize);
   FillChar(NTXFill^, NTXBlokSize, #0);
   PageWrite(NTXBlokSize, NTXFill^, NTXBlokSize);
   FreeMem(NTXFill,NTXBlokSize);
   DiskFile.gsUnLock;
end;

function GSobjNTXFile.ExternalChange: boolean;   {!!RFG 091297}
var
   NTXHdr: GSptrNTXHeader;
   chg: boolean;
begin
   ExternalChange := false;
   if (DiskFile = nil) or (not DiskFile.FileShared) then exit;
   GetMem(NTXHdr, NTXBlokSize);
   PageRead(0, NTXHdr^, NTXBlokSize);
   chg :=  UpdtCtr <> NTXHdr^.IndxUpdt;
   FreeMem(NTXHdr, NTXBlokSize);
   ExternalChange := chg;
end;




end.


