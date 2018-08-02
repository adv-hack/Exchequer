unit gs6_sort;
{-----------------------------------------------------------------------------
                              Sort Routine

       gs6_sort Copyright (c) 1998 Griffin Solutions, Inc.

       Date
          1 Jun 1998

       Programmer:
          Richard F. Griffin                     tel: (478) 953-2680
          Griffin Solutions, Inc.             e-mail: halcyon@grifsolu.com
          102 Molded Stone Pl
          Warner Robins, GA  31088

       -------------------------------------------------------------
       This unit contains the object to sort any number of key values

   Changes:
------------------------------------------------------------------------------}
{$I gs6_flag.pas}
interface
uses
   SysUtils,
   Classes,
   gs6_cnst,
   gs6_glbl,
   gs6_tool;


type

   TgsSortTrieType = (sttChar, sttFloat);

   PgsSortTrie = ^TgsSortTrie;
   TgsSortTrie = packed record
      FLevelN: PgsSortTrie;
      FLevel0: PgsSortTrie;
      FStatus: byte;
      FValu: byte;
   end;

   TgsSort = class(TObject)
 {  private}
      FType: TgsSortTrieType;
      FUnique: boolean;
      FAscend: boolean;
      FCount: longint;
      FStack: TList;
      FSortingPages: TList;
      FCollectingPages: TgsCollection;
      FCurCollection: TObject;
      FMemReq: longint;
      FOutCnt: integer;
      FOutPos: integer;
      FStrLen: integer;
      FCollPgs: longint;
      FStackNotInit: boolean;
      FPointerCount: integer;
      FInputVariant: TgsVariant;
      FCollectVariant: TgsVariant;
      FUniqueKey: TgsVariant;
      FCollPosn: integer;
      FMemory: pointer;
      FRoot: TgsSortTrie;
      FKeyPos: longint;
      FCollateTable: PByteArray;
{   protected}
      procedure StuffKey(AKey: TgsVariant; Tag: longint; KeyType: byte);
      procedure AddDateKey(AKey: TgsVariant; Tag: longint);
      procedure AddFloatKey(AKey: TgsVariant; Tag: longint);
      procedure AddTextKey(AKey: TgsVariant; Tag: longint);
      function GetNextAvailKey(var AKey: TgsVariant; var Tag: longint): boolean;
      function GetTriePointer: PgsSortTrie;
      function SizeTriePointer(ByteCount: integer): boolean;
      procedure ReinitSorting;
      procedure CompressKeys;
{   public}
      procedure InitKeyCollection;
      function CollectKeys: boolean;
      constructor Create(AKeyLen: integer; Uniq, Ascnd: Boolean; ACollateTable: pointer);
      destructor Destroy; override;
      procedure AddKey(AKey: TgsVariant; Tag: longint);
      function GetFirstKey(var AKey: TgsVariant; var Tag: longint): boolean;
      function GetNextKey(var AKey: TgsVariant; var Tag: longint): boolean;
      property Count: longint read FCount;
      property PointerCount: integer read FPointerCount;
      property Ascending: boolean read FAscend;
   end;


implementation

const
   CollectionSize = 16384;
   KeysPerPage = 4096;
   KeyIsBinary = $10;
   KeyIsText   = $20;
   KeyIsFloat  = $30;
   KeyIsDate   = $40;
   FloatLen    = SizeOf(FloatNum)-1;

type
   TgsPageCollection = class(TObject)
      FOwner: TgsSort;
      FPageList: TList;
      FCurKey: TgsVariant;
      FPagePos: integer;
      FWorkBuf: PByteArray;
      constructor Create(AOwner: TgsSort);
      destructor  Destroy; override;
      function    PullKey: boolean;
      procedure   Add(NewKey: TgsVariant; AType, Trailing: byte);
      procedure   CompareKey(var NextKey: TgsVariant; var GoodPage: TgsPageCollection);
   end;

constructor TgsPageCollection.Create(AOwner: TgsSort);
begin
   inherited Create;
   FOwner := AOwner;
   FPageList := TList.Create;
   FCurKey := TgsVariant.Create(256);
   FPagePos := -1;
   FWorkBuf := nil;
end;

destructor TgsPageCollection.Destroy;
var
   i: integer;
begin
   FCurKey.Free;
   for i := 0 to FPageList.Count -1 do
   begin
      FreeMem(FPageList.Items[i],CollectionSize);
   end;
   FPageList.Free;
   inherited Destroy;
end;

function TgsPageCollection.PullKey: boolean;
var
   i: integer;
   typ: byte;
   len: byte;
   trl: byte;
begin
   Result := FPagePos <> -1;
   if not Result then exit;
   typ := FWorkBuf^[FPagePos];
   Result := typ <> 0;
   if not Result then                         {test for 'EOF' on this page}
   begin                                      {if true, see if another page}
      i := FPageList.IndexOf(FWorkBuf);
      inc(i);
      if (i > 0) and (i < FPageList.Count) then
      begin
         FWorkBuf := FPageList.Items[i];
         FPagePos := 0;
         typ := FWorkBuf^[FPagePos];
         Result := typ <> 0;
      end;
   end;
   if Result then
   begin
      inc(FPagePos);
      len := FWorkBuf^[FPagePos];
      inc(FPagePos);
      trl := FWorkBuf^[FPagePos];
      inc(FPagePos);
      case typ of
         KeyIsBinary: FCurKey.TypeOfVar := gsvtBinary;
         KeyIsText  : FCurKey.TypeOfVar := gsvtText;
         KeyIsFloat : FCurKey.TypeOfVar := gsvtFloat;
         KeyIsDate  : FCurKey.TypeOfVar := gsvtDate;
      end;
      Move(FWorkBuf^[FPagePos],FCurKey.Memory^[len-trl],trl);
      FCurKey.SizeOfVar := len;
      inc(FPagePos,trl);
   end
   else
      FPagePos := -1;
end;

procedure TgsPageCollection.Add(NewKey: TgsVariant; AType, Trailing: byte);
var
   len: byte;
begin
   if NewKey = nil then
   begin                     {Flag for insertion done.  Set to first key}
      FWorkBuf := FPageList.Items[0];
      FPagePos := 0;
      PullKey;
      exit;
   end;
   len := NewKey.SizeOfVar;
   if (FPagePos = -1) or ((FPagePos+len+3) >= CollectionSize) then
   begin
      GetMem(FWorkBuf, CollectionSize);
      FPageList.Add(FWorkBuf);
      FPagePos:= 0;
   end;
   FWorkBuf^[FPagePos] := AType;
   inc(FPagePos);
   FWorkBuf^[FPagePos] := len;
   inc(FPagePos);
   FWorkBuf^[FPagePos] := Trailing;
   inc(FPagePos);
   Move(NewKey.Memory^[len-Trailing],FWorkBuf^[FPagePos],Trailing);
   inc(FPagePos,Trailing);
   FWorkBuf^[FPagePos] := 0;              {'EOF' flag at end of used buffer}
end;

procedure TgsPageCollection.CompareKey(var NextKey: TgsVariant; var GoodPage: TgsPageCollection);
var
   ep: integer;
   rsl: boolean;
   isFloat: boolean;
begin
   if FPagePos = -1 then exit;
   isFloat := (NextKey <> nil) and (NextKey.TypeOfVar = gsvtFloat);
   if isFloat then
      NextKey.TypeOfVar := gsvtBinary;
   if FOwner.Ascending then
      rsl := (NextKey = nil) or (FCurKey.CompareBin(NextKey, ep, MatchIsHigh, FOwner.FCollateTable) < 0)
   else
      rsl := (NextKey = nil) or (FCurKey.CompareBin(NextKey, ep, MatchIsHigh, FOwner.FCollateTable) > 0);
   if isFloat then
      NextKey.TypeOfVar := gsvtFloat;
   if rsl then
   begin
      NextKey := FCurKey;
      GoodPage := Self;
   end;
end;



constructor TgsSort.Create(AKeyLen: integer; Uniq, Ascnd: Boolean; ACollateTable: pointer);
begin
   inherited Create;
   if AKeyLen > MaxSortSize then
         raise EHalcyonError.CreateFMT(gsErrSortLength,[AKeyLen]);
   FType := sttChar;
   FUnique := Uniq;
   FAscend := Ascnd;
   FCollateTable := ACollateTable;
   FCount := 0;
   FStack := nil;
   FSortingPages := TList.Create;
   FCollectingPages := TgsCollection.Create;
   FMemReq := KeysPerPage * SizeOf(TgsSortTrie);
   GetMem(FMemory,FMemReq);
   FillChar(FMemory^,FMemReq,#0);
   FSortingPages.Add(FMemory);
   FKeyPos := 0;
   FRoot.FStatus := 0;
   FRoot.FValu := 0;
   FRoot.FLevel0 := nil;
   FRoot.FLevelN := nil;
   FCount := 0;
   FOutCnt := AKeyLen;
   FStackNotInit := true;
   FInputVariant := TgsVariant.Create(FOutCnt+4); {include 4 bytes for Tag}
   FCollectVariant := TgsVariant.Create(FOutCnt+4); {include 4 bytes for Tag}
   FPointerCount := 0;
   FUniqueKey := nil;
end;

destructor  TgsSort.Destroy;
var
   i: integer;
begin
   FInputVariant.Free;
   FCollectVariant.Free;
   FCollectingPages.Free;
   if Assigned(FSortingPages) then
   begin
      for i := 0 to FSortingPages.Count-1 do
        FreeMem(FSortingPages[i],FMemReq);
      FSortingPages.Free;
   end;
   if Assigned(FStack) then FStack.Free;
   if FUniqueKey <> nil then
   begin
      FUniqueKey.Free;
      FUniqueKey := nil;
   end;
   inherited Destroy;
end;

procedure TgsSort.StuffKey(AKey: TgsVariant; Tag: longint; KeyType: byte);
var
   UsedBytes: integer;
   CurBytePos: integer;
   CurByte: byte;
   ChildTrie: PgsSortTrie;
   NewTrie: PgsSortTrie;
   OwnerTrie: PgsSortTrie;
   OneBackTrie: PgsSortTrie;
   CmpVal: integer;
   XtraByte: integer;
   TagBytePos: integer;
   ByteFill: array[0..3] of byte;
   ByteBack: array[0..3] of byte;
begin
   TagBytePos := AKey.SizeOfVar;
   Move(Tag,ByteFill,4);
   ByteBack[0] := ByteFill[3];
   ByteBack[1] := ByteFill[2];
   ByteBack[2] := ByteFill[1];
   ByteBack[3] := ByteFill[0];
   AKey.AppendBinary(@ByteBack,4);
   SizeTriePointer(AKey.SizeOfVar);
   UsedBytes := AKey.SizeOfVar-1;
   OwnerTrie := Addr(FRoot);
   CurBytePos := 0;
   while CurBytePos <= UsedBytes do
   begin
      ChildTrie := OwnerTrie^.FLevelN;
      if (ChildTrie <> nil) then
      begin
         XtraByte := ChildTrie^.FStatus and $07;
         if XtraByte > 0 then
         begin
            NewTrie := GetTriePointer;
            NewTrie^.FLevelN := ChildTrie^.FLevelN;
            ChildTrie^.FLevelN := NewTrie;
            ChildTrie^.FStatus := ChildTrie^.FStatus and $F0;
            pointer(ByteFill) := ChildTrie^.FLevel0;
            ChildTrie^.FLevel0 := nil;
            NewTrie^.FValu := ByteFill[0];
            dec(XtraByte);
            NewTrie^.FStatus := ChildTrie^.FStatus or XtraByte;
            Move(ByteFill[1],ByteFill[0],3);
            ByteFill[3] := 0;
            NewTrie^.FLevel0 := pointer(ByteFill);
         end;
      end;
      OneBackTrie := nil;
      CurByte := AKey.Memory^[CurBytePos];
      inc(CurBytePos);
      if FAscend then
      begin
         CmpVal := 1;
         while (ChildTrie <> nil) and (CmpVal > 0) do
         begin
            if (KeyType = KeyIsText) and (FCollateTable <> nil) and
               (CurBytePos <= TagBytePos) then
            begin
               CmpVal := FCollateTable[CurByte];
               CmpVal := CmpVal - FCollateTable[ChildTrie^.FValu];
            end
            else
               CmpVal := CurByte-ChildTrie^.FValu;
            if CmpVal > 0 then
            begin
               OneBackTrie := ChildTrie;
               ChildTrie := ChildTrie^.FLevel0;
            end;
         end;
      end
      else
      begin
         CmpVal := 1;
         while (ChildTrie <> nil) and (CmpVal > 0) do
         begin
            if (KeyType = KeyIsText) and (FCollateTable <> nil) and
               (CurBytePos <= TagBytePos) then
            begin
               CmpVal := FCollateTable[ChildTrie^.FValu];
               CmpVal := CmpVal - FCollateTable[CurByte];
            end
            else
               CmpVal := ChildTrie^.FValu-CurByte;
            if CmpVal > 0 then
            begin
               OneBackTrie := ChildTrie;
               ChildTrie := ChildTrie^.FLevel0;
            end;
         end;
      end;
      if CmpVal <> 0 then
      begin
         NewTrie := GetTriePointer;
         NewTrie^.FValu := CurByte;
         NewTrie^.FLevelN := nil;
         NewTrie^.FStatus := KeyType;
         if CmpVal > 0 then
         begin
            NewTrie^.FLevel0 := nil;
            if ChildTrie <> nil then
               ChildTrie^.FLevel0 := NewTrie
            else
               if OneBackTrie <> nil then
                  OneBackTrie^.FLevel0 := NewTrie
               else
               begin
                  OwnerTrie^.FLevelN := NewTrie;
                  XtraByte := 0;                       {Stuff next four chars}
                  longint(ByteFill) := 0;
                  while (CurBytePos <= UsedBytes) and (XtraByte < 4) do
                  begin
                     ByteFill[XtraByte] := AKey.Memory^[CurBytePos];
                     inc(XtraByte);
                     inc(CurBytePos);
                  end;
                  NewTrie^.FLevel0 := pointer(ByteFill);
                  NewTrie^.FStatus := KeyType or XtraByte;
               end;
         end
         else
         begin
            if ChildTrie <> nil then
            begin
               if (OneBackTrie <> nil) then
               begin
                  NewTrie^.FLevel0 := OneBackTrie^.FLevel0;
                  OneBackTrie^.FLevel0 := NewTrie;
               end
               else
               begin
                  NewTrie^.FLevel0 := OwnerTrie^.FLevelN;
                  OwnerTrie^.FLevelN := NewTrie;
               end;
            end
            else
            begin
               OwnerTrie^.FLevelN := NewTrie;
            end;
         end;
         OwnerTrie := NewTrie;
      end
      else
         OwnerTrie := ChildTrie;
   end;
   if OwnerTrie <> nil then
      OwnerTrie^.FStatus := OwnerTrie^.FStatus or KeyType;
   inc(FCount);
end;

procedure TgsSort.AddKey(AKey: TgsVariant; Tag: longint);
begin
   if not FStackNotInit then          {FStackNotInit is set false on GetFirstKey}
      raise EHalcyonError.Create(gsErrSortBegun);
   if AKey.SizeOfVar > FOutCnt then
         raise EHalcyonError.CreateFmt(gsErrSortLength,[FOutCnt,AKey.SizeOfVar]);
   case AKey.TypeOfVar of
      gsvtBinary: StuffKey(AKey,Tag,KeyIsBinary);
      gsvtText  : AddTextKey(AKey, Tag);
      gsvtFloat : AddFloatKey(AKey, Tag);
      gsvtDate  : AddDateKey(AKey, Tag);
      else raise EHalcyonError.Create(gsErrVariantSort);
   end;
end;

procedure TgsSort.AddDateKey(AKey: TgsVariant; Tag: longint);
var
   v: integer;
begin
   FInputVariant.PutBinary(AKey.Memory,AKey.SizeOfVar);
   for v := 0 to 3 do
      FInputVariant.Memory^[3-v] := AKey.Memory^[v];
   StuffKey(FInputVariant,Tag,KeyIsDate);
end;

procedure TgsSort.AddFloatKey(AKey: TgsVariant; Tag: longint);
var
   v: integer;
   adjlen: integer;
begin
   FInputVariant.PutBinary(AKey.Memory,AKey.SizeOfVar);
   if AKey.Memory^[FloatLen] > 127 then      {if negative number}
   begin
      for v := 0 to FloatLen do
      begin
         FInputVariant.Memory^[FloatLen-v] := AKey.Memory^[v] xor $FF;
      end;
   end
   else
   begin
      FInputVariant.Memory^[0] := AKey.Memory^[FloatLen] or $80;
      for v := 0 to FloatLen-1 do
         FInputVariant.Memory^[FloatLen-v] := AKey.Memory^[v];
   end;
   v := 0;
   while (v < FloatLen) and (AKey.Memory^[v] = 0) do inc(v);
   adjlen := SizeOf(FloatNum)-v;
   FInputVariant.SizeOfVar := adjlen;
   StuffKey(FInputVariant,Tag,KeyIsFloat);
end;

procedure TgsSort.AddTextKey(AKey: TgsVariant; Tag: longint);
var
   i: integer;
begin
   FInputVariant.PutBinary(AKey.Memory,AKey.SizeOfVar);
   i := FInputVariant.SizeOfVar - 1;                    {strip trailing spaces}
   while (i >= 0) and (FInputVariant.Memory^[i] = $20) do dec(i);
   inc(i);
   FInputVariant.SizeOfVar := i;
   StuffKey(FInputVariant,Tag,KeyIsText);
end;

procedure TgsSort.ReinitSorting;
begin
   FKeyPos := 0;
   FRoot.FStatus := 0;
   FRoot.FValu := 0;
   FRoot.FLevel0 := nil;
   FRoot.FLevelN := nil;
   FStackNotInit := true;
   FPointerCount := 0;
end;

procedure TgsSort.CompressKeys;
begin
   InitKeyCollection;
   repeat
   until not CollectKeys;
   if FCurCollection <> nil then
      TgsPageCollection(FCurCollection).Add(nil,0,0);
   ReinitSorting;
end;

function TgsSort.GetFirstKey(var AKey: TgsVariant; var Tag: longint): boolean;
var
   i: integer;
begin
   Result := false;
   CompressKeys;
   if FCollectingPages.Count = 0 then exit;
   if Assigned(FSortingPages) then
   begin
      for i := 0 to FSortingPages.Count-1 do
        FreeMem(FSortingPages[i],FMemReq);
      FSortingPages.Free;
      FSortingPages := nil;
   end;
   FStackNotInit := false;
   if FUniqueKey <> nil then
   begin
      FUniqueKey.Free;
      FUniqueKey := nil;
   end;
   Result := GetNextAvailKey(AKey,Tag);
   if FUnique then
   begin
      FUniqueKey := TgsVariant.Create(FOutCnt);
      FUniqueKey.Assign(AKey);
   end;
end;

function TgsSort.GetNextKey(var AKey: TgsVariant; var Tag: longint): boolean;
var
   ep: integer;
begin
   Result := GetNextAvailKey(AKey, Tag);
   if Result then
   begin
      if FUnique then
      begin
         if FUniqueKey = nil then
         begin
            FUniqueKey := TgsVariant.Create(FOutCnt);
         end
         else
         begin
            while Result and (FUniqueKey.CompareBin(AKey,ep,MatchIsExact,FCollateTable) = 0) do
               Result := GetNextAvailKey(AKey,Tag);
         end;
         FUniqueKey.Assign(AKey);
     end;
   end;
end;

function TgsSort.GetNextAvailKey(var AKey: TgsVariant; var Tag: longint): boolean;
var
   ByteBack: array[0..3] of byte;
   v: integer;
   i: integer;
   tvar: TgsVariant;
   tpc: TgsPageCollection;
begin
   if FStackNotInit then
   begin
      Result := GetFirstKey(AKey,Tag);
      if FUniqueKey <> nil then            {GetNextKey will rebuild this}
      begin
         FUniqueKey.Free;
         FUniqueKey := nil;
      end;
      exit;
   end;
   Result := false;
   tvar := nil;
   tpc := nil;
   for i := 0 to FCollectingPages.Count-1 do
      TgsPageCollection(FCollectingPages.Items[i]).CompareKey(tvar,tpc);
   if (tvar <> nil) and (tpc <> nil) then
   begin
      i := tvar.SizeOfVar;
      ByteBack[0] := tvar.Memory^[i-1];
      ByteBack[1] := tvar.Memory^[i-2];
      ByteBack[2] := tvar.Memory^[i-3];
      ByteBack[3] := tvar.Memory^[i-4];
      Move(ByteBack ,Tag, SizeOf(longint));
      tvar.SizeOfVar := i-4;
      AKey.Assign(tvar);
      case (AKey.TypeOfVar) of
         gsvtFloat: begin
                       FillChar(AKey.Memory^,SizeOf(FloatNum),#0);
                       AKey.SizeOfVar := SizeOf(FloatNum);
                       if tvar.Memory^[0] < 128 then      {if negative number}
                       begin
                          for v := 0 to i-5 do
                             AKey.Memory^[FloatLen-v] := tvar.Memory^[v] xor $FF;
                       end
                       else
                       begin
                          AKey.Memory^[FloatLen] := tvar.Memory^[0] and $7F;
                          for v := 1 to i-5 do
                             AKey.Memory^[FloatLen-v] := tvar.Memory^[v];
                       end;
                    end;
          gsvtDate: begin
                       for v := 0 to 3 do
                          AKey.Memory^[3-v] := tvar.Memory^[v];
                    end;
            {KeyIsText is ok until we add TrimRight}
      end;
      tpc.PullKey;
      Result := true;
   end;
end;

procedure TgsSort.InitKeyCollection;
begin
   if Assigned(FStack) then
      FStack.Clear
   else
      FStack := TList.Create;
   FStrLen := 0;
   if FRoot.FLevelN <> nil then
   begin
      FStack.Add(FRoot.FLevelN);
      FCurCollection := TgsPageCollection.Create(Self);
      FCollectingPages.Add(FCurCollection);
   end;
end;

function TgsSort.CollectKeys: boolean;
var
   CurNode: PgsSortTrie;
   WrkNode: PgsSortTrie;
   XtraByte: integer;
   IsLevel: boolean;
   StartLen: integer;
   UsedLen: integer;
begin
   Result := false;
   if FStack.Count = 0 then exit;
   StartLen := FStrLen;
   while (not Result) and (FStack.Count > 0) do
   begin
      CurNode := PgsSortTrie(FStack[FStack.Count-1]);
      if CurNode = nil then exit;
      XtraByte := CurNode^.FStatus and $07;
      FCollectVariant.Memory^[FStrLen] := CurNode^.FValu;
      if XtraByte > 0 then
         Move(CurNode^.FLevel0,FCollectVariant.Memory^[FStrLen+1],XtraByte);
      inc(FStrLen,XtraByte+1);
      if CurNode.FLevelN = nil then
      begin
         Result := true;
         UsedLen := FStrLen-StartLen;
         FCollectVariant.SizeOfVar := FStrLen;
         TgsPageCollection(FCurCollection).Add(FCollectVariant,CurNode^.FStatus and $F0,UsedLen);
         repeat
            XtraByte := CurNode^.FStatus and $07;
            dec(FStrLen,XtraByte+1);
            WrkNode := CurNode^.FLevel0;
            FStack.Delete(FStack.IndexOf(CurNode));
            IsLevel := (XtraByte = 0) and (WrkNode <>  nil);
            if IsLevel then
               FStack.Add(WrkNode)
            else
               if FStack.Count > 0 then
                  CurNode := PgsSortTrie(FStack[FStack.Count-1]);
         until IsLevel or (FStack.Count = 0);
      end
      else
         FStack.Add(CurNode.FLevelN);
   end;
end;

function TgsSort.SizeTriePointer(ByteCount: integer): boolean;
begin
   Result := true;
   if FKeyPos+(ByteCount*SizeOf(TgsSortTrie)) >= FMemReq then
   begin
      if FSortingPages.Count = 32 then
      begin
         if (FMemory = FSortingPages.Items[31]) then
         begin
            CompressKeys;
            FMemory := FSortingPages.Items[0];
            Result := false;
         end;
      end;
   end;
end;

function TgsSort.GetTriePointer: PgsSortTrie;
begin
   if FKeyPos >= FMemReq then
   begin
      if FSortingPages.Count < 32 then
      begin
         GetMem(FMemory,FMemReq);
         FillChar(FMemory^,FMemReq,#0);
         FSortingPages.Add(FMemory);
         FKeyPos := 0;
      end
      else
      begin
         if (FMemory = FSortingPages.Items[31]) then
         begin
            CompressKeys;
            FMemory := FSortingPages.Items[0];
         end
         else
            FMemory := FSortingPages.Items[FSortingPages.IndexOf(FMemory)+1];
         FKeyPos := 0;
      end;

   end;
   Result := Ptr(longint(FMemory)+FKeyPos);
   FKeyPos := FKeyPos + SizeOf(TgsSortTrie);
   inc(FPointerCount);
end;


end.


