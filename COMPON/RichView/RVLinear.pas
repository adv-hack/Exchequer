
{*******************************************************}
{                                                       }
{       RichView                                        }
{       A set of procedures implementing RichEdit-like  }
{       selection (SelStart and SelLength)              }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

{
  v1.7:
  fix: converting Unicode to DBCS (for D3-D2007).
    Note: when working with DBCS text, offsets are offsets in bytes,
    not characters
  chg: now, for D3-D2007, Unicode text is converted to ANSI using
    RVStyle.DefCodePage
  v1.6:
  new: GetTextRange returns text in the specified range. The returned text
    has exactly RangeLength number of characters, this function is completely
    compatible with other functions in this unit.
    Nontext items (except for tables and tabs) are saved as RVNonTextCharacter).
  v1.5:
  new: RVGetSelectionEx and RVSetSelectionEx stores the selection in the record
    TRVSelection. These functions can store even multicell selection
  v1.4:
  fix: RVGetSelection works with TRichView
  v1.3:
  new: RVCharsPerLineBreak - number of characters per line break
  v1.1:
  chg: linear position is counted from 0, like in RichEdit.
    If you need to count it from 1 (for compatibility reasons), remove the
    dot from the define below.
}

{.$DEFINE RVLIN_STARTFROM1}

{$I RV_Defs.inc}

unit RVLinear;

interface
uses RichView, {$IFNDEF RVDONOTUSERVF}RVEdit, RVTable, {$ENDIF}
  CRVData, CRVFData, RVUni, RVItem, RVTypes;

{$IFNDEF RVDONOTUSERVF}
function RVGetLinearCaretPos(rve: TCustomRichViewEdit): Integer;
procedure RVSetLinearCaretPos(rve: TCustomRichViewEdit; LinearPos: Integer);
{$ENDIF}

procedure RVGetSelection(rv: TCustomRichView; var SelStart, SelLength: Integer);
procedure RVSetSelection(rv: TCustomRichView; SelStart, SelLength: Integer);

function RVGetTextRange(rv: TCustomRichView; RangeStart, RangeLength: Integer): String;
function RVGetTextLength(rv: TCustomRichView): Integer;

const RVCharsPerLineBreak: Integer = 1;
      RVNonTextCharacter: Char = ' ';

function RichViewToLinear(rv: TCustomRichView; CurRVData, RVData: TCustomRVData;
  ItemNo, ItemOffs: Integer; var LinearPos: Integer): Boolean;
function LinearToRichView(rv: TCustomRichView; CurRVData: TCustomRVData;
  var LinearPos: Integer; var RVData: TCustomRVData;
  var ItemNo, ItemOffs: Integer): Boolean;  

{$IFNDEF RVDONOTUSERVF}
type
  TRVSelection = record
    SelStart, SelLength: Integer;
    MultiCell: Boolean;
    StartRow, StartCol, RowOffs, ColOffs: Integer;
  end;

procedure RVGetSelectionEx(rv: TCustomRichView; var Selection: TRVSelection);
procedure RVSetSelectionEx(rv: TCustomRichView; const Selection: TRVSelection);
{$ENDIF}

implementation

uses RVStyle;

function GetAbstractCharCountInItem(RVData: TCustomRVData;
  ItemNo: Integer): Integer; forward;

function GetAbstractCharCountInRVData(RVData: TCustomRVData): Integer;
var i: Integer;
begin
  Result := 0;
  for i := 0 to RVData.Items.Count-1 do
    inc(Result, GetAbstractCharCountInItem(RVData, i));
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVUNICODESTR}
function GetAnsiText(RVData: TCustomRVData; ItemNo: Integer): String;
begin
  if rvioUnicode in RVData.GetItemOptions(ItemNo) then
    Result := RVU_UnicodeToAnsi(RVData.GetRVStyle.DefCodePage, RVData.Items[ItemNo])
  else
    Result := RVData.Items[ItemNo];
end;

function GetAnsiText2(RVData: TCustomRVData; ItemNo: Integer;
  const Text: TRVRawByteString): String;
begin
  if rvioUnicode in RVData.GetItemOptions(ItemNo) then
    Result := RVU_UnicodeToAnsi(RVData.GetRVStyle.DefCodePage, Text)
  else
    Result := Text;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function GetAbstractCharCountInItem(RVData: TCustomRVData; ItemNo: Integer): Integer;
var StoreSub: TRVStoreSubRVData;
    SubRVData: TCustomRVData;
begin
  if RVData.IsFromNewLine(ItemNo) then
    Result := RVCharsPerLineBreak
  else
    Result := 0;
  if RVData.GetItemStyle(ItemNo)>=0 then begin
    inc(Result, Length(
      {$IFDEF RVUNICODESTR}
      RVData.GetItemTextW(ItemNo)
      {$ELSE}
      GetAnsiText(RVData, ItemNo)
      {$ENDIF}
     ));
    exit;
  end;
  SubRVData := TCustomRVData(RVData.GetItem(ItemNo).GetSubRVData(StoreSub, rvdFirst));
  if SubRVData<>nil then begin
    repeat
      inc(Result, GetAbstractCharCountInRVData(SubRVData.GetRVData));
      SubRVData := TCustomRVData(RVData.GetItem(ItemNo).GetSubRVData(StoreSub, rvdNext));
    until SubRVData=nil;
    StoreSub.Free;
    inc(Result, RVCharsPerLineBreak);
    end
  else
    inc(Result);
end;
{------------------------------------------------------------------------------}
function GetAbstractCharCountInTextItemPart(RVData: TCustomRVData; ItemNo, PartLen: Integer): Integer;
var s: String;
begin
   {$IFDEF RVUNICODESTR}
   if rvioUnicode in RVData.GetItemOptions(ItemNo) then
     Result := PartLen
   else begin
     s := Copy(RVData.GetItemTextW(ItemNo), 1, PartLen);
     Result := Length(RVU_UnicodeToAnsi(RVData.GetItemCodePage(ItemNo), RVU_GetRawUnicode(s)));
   end;
   {$ELSE}
   if rvioUnicode in RVData.GetItemOptions(ItemNo) then begin
     s := Copy(GetAnsiText(RVData, ItemNo), 1, PartLen);
     Result := Length(RVU_AnsiToUnicode(RVData.GetRVStyle.DefCodePage, s)) div 2;
     end
   else
     Result := PartLen;
   {$ENDIF}
end;
{------------------------------------------------------------------------------}
// For the given text item, converts Offs from offset in item to offset in resulting
// string (may be different if the item is Unicode, resulting string is DBCS)
function RVOffsToCharOffs(RVData: TCustomRVData; ItemNo, Offs: Integer): Integer;
{$IFNDEF RVUNICODESTR}
var s: String;
{$ENDIF}
begin
  Result := Offs;
  {$IFDEF RVUNICODESTR}
  // DBCS in RV is not supported, so it can be either Unicode or nonDBCS ANSI
  {$ELSE}
  // if beginning of string, or already non-Unicode, it's ok
  if (Result<=1) or not (rvioUnicode in RVData.GetItemOptions(ItemNo)) then
    exit;
  s := GetAnsiText2(RVData, ItemNo,
    RVU_Copy(RVData.Items[ItemNo], 1, Offs-1, RVData.GetItemOptions(ItemNo)));
  Result := Length(s)+1;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RichViewToLinear(rv: TCustomRichView; CurRVData, RVData: TCustomRVData;
  ItemNo, ItemOffs: Integer; var LinearPos: Integer): Boolean;
var i, SubLinPos: Integer;
    StoreSub: TRVStoreSubRVData;
    SubRVData: TCustomRVData;
    item: TCustomRVItemInfo;
begin
  Result := False;
  LinearPos := 0;
  if CurRVData=RVData then begin
    for i := 0 to ItemNo-1 do
      inc(LinearPos, GetAbstractCharCountInItem(CurRVData, i));
    if CurRVData.GetItemStyle(ItemNo)>=0 then begin
      if CurRVData.IsFromNewLine(ItemNo) then
        inc(LinearPos, RVCharsPerLineBreak);
      inc(LinearPos, RVOffsToCharOffs(CurRVData, ItemNo, ItemOffs)-1)
      end
    else if ItemOffs>0 then
      inc(LinearPos, GetAbstractCharCountInItem(CurRVData, ItemNo))
    else if CurRVData.IsFromNewLine(ItemNo) then
      inc(LinearPos, RVCharsPerLineBreak);
    Result := True;
    end
  else begin
    for i := 0 to CurRVData.Items.Count-1 do begin
      item := CurRVData.GetItem(i);
      SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdFirst));
      if SubRVData<>nil then begin
        if not item.SameAsPrev then
          inc(LinearPos, RVCharsPerLineBreak);
         repeat
           Result := RichViewToLinear(rv, SubRVData.GetRVData, RVData, ItemNo, ItemOffs, SubLinPos);
           inc(LinearPos, SubLinPos);
           if Result then
             break;
           SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
         until SubRVData=nil;
         StoreSub.Free;
         if Result then
           exit;
         inc(LinearPos, RVCharsPerLineBreak);
        end
      else
        inc(LinearPos, GetAbstractCharCountInItem(CurRVData, i));
    end;
  end;
end;
{------------------------------------------------------------------------------}
function LinearToRichView(rv: TCustomRichView; CurRVData: TCustomRVData;
  var LinearPos: Integer; var RVData: TCustomRVData;
  var ItemNo, ItemOffs: Integer): Boolean;
var i, SubLinPos: Integer;
    StoreSub: TRVStoreSubRVData;
    SubRVData: TCustomRVData;
    item: TCustomRVItemInfo;
begin
  Result := False;
  for i := 0 to CurRVData.Items.Count-1 do begin
    item := CurRVData.GetItem(i);
    SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdFirst));
    if SubRVData<>nil then begin
      if (i>0) and not item.SameAsPrev then
        dec(LinearPos, RVCharsPerLineBreak);
      if LinearPos=0 then begin
        RVData := CurRVData;
        ItemNo := i;
        ItemOffs := 0;
        Result := True;
        StoreSub.Free;
        exit;
      end;
      repeat
        dec(LinearPos, RVCharsPerLineBreak);
        Result := LinearToRichView(rv, SubRVData.GetRVData, LinearPos, RVData, ItemNo, ItemOffs);
        if Result then
          break;
        SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
      until SubRVData=nil;
      StoreSub.Free;
      if Result then
        exit;
      dec(LinearPos, RVCharsPerLineBreak);
      if LinearPos=0 then begin
        RVData := CurRVData;
        ItemNo := i;
        ItemOffs := 1;
        Result := True;
        exit;
      end;
      end
    else begin
      SubLinPos := GetAbstractCharCountInItem(CurRVData, i);
      if i=0 then
        dec(SubLinPos, RVCharsPerLineBreak);
      if (SubLinPos>=LinearPos) then begin
        if (i>0) and not item.SameAsPrev then
          dec(LinearPos, RVCharsPerLineBreak);
        RVData := CurRVData;
        ItemNo := i;
        if item.StyleNo>=0 then
          ItemOffs := GetAbstractCharCountInTextItemPart(RVData, i, LinearPos)+1
        else
          ItemOffs := LinearPos;
        if ItemOffs<RVData.GetOffsBeforeItem(ItemNo) then
          ItemOffs := RVData.GetOffsBeforeItem(ItemNo);
        if ItemOffs>RVData.GetOffsAfterItem(ItemNo) then
          ItemOffs := RVData.GetOffsAfterItem(ItemNo);
        Result := True;
        exit;
      end;
      dec(LinearPos, SubLinPos);
    end;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
function RVGetLinearCaretPos(rve: TCustomRichViewEdit): Integer;
var tle: TCustomRichViewEdit;
begin
  tle := rve;
  while tle.InplaceEditor<>nil do
    tle := TCustomRichViewEdit(tle.InplaceEditor);
  if tle.CurItemNo<0 then
    Result := 0
  else begin
    RichViewToLinear(rve, rve.RVData, tle.RVData, tle.CurItemNo,
      tle.OffsetInCurItem, Result);
    dec(Result, RVCharsPerLineBreak);
  end;
  {$IFDEF RVLIN_STARTFROM1}
  inc(Result);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure RVSetLinearCaretPos(rve: TCustomRichViewEdit; LinearPos: Integer);
var RVData: TCustomRVData;
    ItemNo, ItemOffs: Integer;
begin
  {$IFDEF RVLIN_STARTFROM1}
  dec(LinearPos);
  {$ENDIF}
  if LinearToRichView(rve, rve.RVData, LinearPos, RVData, ItemNo, ItemOffs) then begin
    RVData := RVData.Edit;
    TCustomRVFormattedData(RVData).SetSelectionBounds(ItemNo, ItemOffs,
      ItemNo, ItemOffs);
    TCustomRVFormattedData(RVData).Invalidate;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure RVGetSelection(rv: TCustomRichView; var SelStart, SelLength: Integer);
var ItemNo1, ItemNo2, ItemOffs1, ItemOffs2: Integer;
    RVData: TCustomRVFormattedData;
begin
  RVData := rv.RVData;
  while RVData.GetChosenRVData<>nil do
    RVData := TCustomRVFormattedData(RVData.GetChosenRVData);
  RVData.GetSelectionBoundsEx(ItemNo1, ItemOffs1, ItemNo2, ItemOffs2, False);
  if ItemNo1<0 then begin
    {$IFDEF RVLIN_STARTFROM1}
    SelStart := 1;
    {$ELSE}
    SelStart := 0;
    {$ENDIF}
    SelLength := 0;
    end
  else begin
    RichViewToLinear(rv, rv.RVData, RVData, ItemNo1, ItemOffs1, SelStart);
    RichViewToLinear(rv, rv.RVData, RVData, ItemNo2, ItemOffs2, SelLength);
    dec(SelStart, RVCharsPerLineBreak);
    dec(SelLength, RVCharsPerLineBreak);
    SelLength := SelLength-SelStart;
    {$IFDEF RVLIN_STARTFROM1}
    inc(SelStart);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
procedure RVSetSelection(rv: TCustomRichView; SelStart, SelLength: Integer);
var ItemNo1, ItemNo2, ItemOffs1, ItemOffs2: Integer;
  RVData1, RVData2: TCustomRVData;
begin
  {$IFDEF RVLIN_STARTFROM1}
  dec(SelStart);
  {$ENDIF}
  inc(SelLength, SelStart);
  if LinearToRichView(rv, rv.RVData, SelStart, RVData1, ItemNo1, ItemOffs1) and
     LinearToRichView(rv, rv.RVData, SelLength, RVData2, ItemNo2, ItemOffs2) and
     (RVData1=RVData2)
  then begin
    RVData1 := RVData1.Edit;
    TCustomRVFormattedData(RVData1).SetSelectionBounds(ItemNo1, ItemOffs1,
      ItemNo2, ItemOffs2);
    TCustomRVFormattedData(RVData1).Invalidate;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
procedure RVGetSelectionEx(rv: TCustomRichView; var Selection: TRVSelection);
var RVData: TCustomRVFormattedData;
begin
  RVData := rv.RVData;
  while RVData.GetChosenRVData<>nil do
    RVData := TCustomRVFormattedData(RVData.GetChosenRVData);
  Selection.MultiCell := (RVData.PartialSelectedItem<>nil) and
    (RVData.PartialSelectedItem is TRVTableItemInfo);
  if Selection.MultiCell then
    with Selection do begin
      TRVTableItemInfo(RVData.PartialSelectedItem).GetSelectionBounds(StartRow,
        StartCol, RowOffs, ColOffs);
      RichViewToLinear(rv, rv.RVData, RVData,
        TRVTableItemInfo(RVData.PartialSelectedItem).GetMyItemNo, 0, SelStart);
      SelLength := 0;
      dec(SelStart, RVCharsPerLineBreak);
      {$IFDEF RVLIN_STARTFROM1}
      inc(SelStart);
      {$ENDIF}
    end
  else
    RVGetSelection(rv, Selection.SelStart, Selection.SelLength);
end;
{------------------------------------------------------------------------------}
procedure RVSetSelectionEx(rv: TCustomRichView; const Selection: TRVSelection);
var RVData: TCustomRVData;
    SelStart, ItemNo, ItemOffs: Integer;
begin
  if Selection.MultiCell then begin
    SelStart := Selection.SelStart;
    {$IFDEF RVLIN_STARTFROM1}
    dec(SelStart);
    {$ENDIF}
    if LinearToRichView(rv, rv.RVData, SelStart, RVData, ItemNo, ItemOffs) then begin
      RVData := RVData.Edit;
      if RVData.GetItemStyle(ItemNo)=rvsTable then
        with Selection do
          TRVTableItemInfo(RVData.GetItem(ItemNo)).Select(StartRow, StartCol,
            RowOffs, ColOffs);
    end;
    end
  else
    RVSetSelection(rv, Selection.SelStart, Selection.SelLength);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function GetTextRange_(rv: TCustomRichView; CurRVData: TCustomRVData;
  var LinearPos: Integer; RangeLength: Integer; var s: String;
  var CollectingText: Boolean): Boolean;
var i, ItemLen, Offs: Integer;
    StoreSub: TRVStoreSubRVData;
    SubRVData: TCustomRVData;
    item: TCustomRVItemInfo;
    LineBreak: String;

    function CheckExit: Boolean;
    begin
      if LinearPos<=0 then begin
        if CollectingText then begin
          Result := True;
          exit;
        end;
        CollectingText := True;
        if RangeLength>0 then
          LinearPos := RangeLength
        else
          LinearPos := MaxInt;
      end;
      Result := False;      
    end;

begin
  Result := False;
  if RVCharsPerLineBreak=1 then
    LineBreak := #13
  else
    LineBreak := #13#10;
  for i := 0 to CurRVData.Items.Count-1 do begin
    item := CurRVData.GetItem(i);
    SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdFirst));
    if SubRVData<>nil then begin
      if (i>0) and not item.SameAsPrev then begin
        dec(LinearPos, RVCharsPerLineBreak);
        if CollectingText then
          s := s+LineBreak;
      end;
      if CheckExit then begin
        Result := True;
        StoreSub.Free;
        exit;
      end;
      repeat
        dec(LinearPos, RVCharsPerLineBreak);
        if CollectingText then
          s := s+LineBreak;
        Result := GetTextRange_(rv, SubRVData.GetRVData, LinearPos, RangeLength,
          s, CollectingText);
        if Result then
          break;
        SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
      until SubRVData=nil;
      StoreSub.Free;
      if Result then
        exit;
      dec(LinearPos, RVCharsPerLineBreak);
      if CollectingText then
        s := s+LineBreak;
      if CheckExit then begin
        Result := True;
        exit;
      end;
      end
    else begin
      if CheckExit then begin
        Result := True;
        exit;
      end;
      if (i>0) and not item.SameAsPrev then begin
        dec(LinearPos, RVCharsPerLineBreak);
        if CollectingText then
          s := s+LineBreak;
        if CheckExit then begin
          Result := True;
          exit;
        end;
      end;
      if item.StyleNo<0 then begin
        dec(LinearPos);
        if CollectingText then
          if item.StyleNo=rvsTab then
            s := s+#9
          else
            s := s+RVNonTextCharacter;
        if CheckExit then begin
          Result := True;
          exit;
        end;
        end
      else begin
        ItemLen := Length(
          {$IFDEF RVUNICODESTR}
          CurRVData.GetItemTextW(i)
          {$ELSE}
          GetAnsiText(CurRVData, i)
          {$ENDIF});
        Offs    := 1;
        if ItemLen>=LinearPos then begin
          if CollectingText then
            s := s+Copy(
              {$IFDEF RVUNICODESTR}
              CurRVData.GetItemTextW(i),
              {$ELSE}
              GetAnsiText(CurRVData, i),
              {$ENDIF}
              Offs, LinearPos);
          dec(ItemLen, LinearPos);
          inc(Offs, LinearPos);
          LinearPos := 0;
          if CheckExit then begin
            Result := True;
            exit;
          end;
          if ItemLen>=LinearPos then begin
            if CollectingText then
              s := s+Copy(
                {$IFDEF RVUNICODESTR}
                CurRVData.GetItemTextW(i),
                {$ELSE}
                GetAnsiText(CurRVData, i),
                {$ENDIF}
                Offs, LinearPos);
            LinearPos := 0;
            if CheckExit then begin
              Result := True;
              exit;
            end;
            end
          else begin
            if CollectingText then
              s := s+Copy(
                {$IFDEF RVUNICODESTR}
                CurRVData.GetItemTextW(i),
                {$ELSE}
                GetAnsiText(CurRVData, i),
                {$ENDIF}
                Offs, ItemLen);
            dec(LinearPos, ItemLen);
          end;
          end
        else begin
          if CollectingText then
            s := s+Copy(
              {$IFDEF RVUNICODESTR}
              CurRVData.GetItemTextW(i),
              {$ELSE}
              GetAnsiText(CurRVData, i),
              {$ENDIF}
              Offs, ItemLen);
          dec(LinearPos, ItemLen);
        end;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function RVGetTextRange(rv: TCustomRichView; RangeStart, RangeLength: Integer): String;
var f: Boolean;
begin
  f := False;
  Result := '';
  if RangeLength=0 then
    exit;
  f := False;
  GetTextRange_(rv, rv.RVData, RangeStart, RangeLength, Result, f);
end;
{------------------------------------------------------------------------------}
function RVGetTextLength(rv: TCustomRichView): Integer;
begin
  Result := 0;
  if rv.ItemCount=0 then
    exit;
  RichViewToLinear(rv, rv.RVData, rv.RVData, rv.ItemCount-1,
    rv.GetOffsAfterItem(rv.ItemCount-1), Result);
  if Result>0 then
    dec(Result, RVCharsPerLineBreak);
end;


end.
