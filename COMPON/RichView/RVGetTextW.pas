
{*******************************************************}
{                                                       }
{       RichView                                        }
{       A set of functions retrieving WideString text   }
{       from document.                                  }
{                                                       }
{       Copyright (c) 2003, Sergey Tkachenko            }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVGetTextW;

interface
uses RVUni, RVItem, RichView, RVEdit, CRVData, RVTypes, CRVFData;

{$I RV_Defs.inc}

{$IFNDEF RVDONOTUSEUNICODE}

// Returns text of line with caret
function GetCurrentLineText(rve: TCustomRichViewEdit): TRVUnicodeString;

// Returns visible text (may be, with a line before and after)
function GetVisibleText(rv: TCustomRichView): TRVUnicodeString;

// Returns all text
function GetAllText(rv: TCustomRichView): TRVUnicodeString;

// Returns all text in RVData
function GetRVDataText(RVData: TCustomRVData): TRVUnicodeString;

// Returns text of paragraph section with caret
// (paragraph section is a part of document limited either by
// paragraph breaks or by new line breaks (added with Shift+Enter)
function GetCurrentParaSectionText(rve: TCustomRichViewEdit): TRVUnicodeString;

// Returns text of paragraph with caret
function GetCurrentParaText(rve: TCustomRichViewEdit): TRVUnicodeString;

// Returns character to the left of caret.
// If caret is at the beginning of line, - to the right.
// If no character, returns empty string
function GetCurrentChar(rve: TCustomRichViewEdit): TRVUnicodeString;

// Returns the current word
function GetCurrentWord(rve: TCustomRichViewEdit): TRVUnicodeString;

{$ENDIF}

implementation

{$IFNDEF RVDONOTUSEUNICODE}

function GetItemText(rv: TCustomRichView; ItemNo: Integer): TRVUnicodeString;
var s: TRVRawByteString;
begin
  if rv.GetItemStyle(ItemNo)>=0 then
    Result := rv.GetItemTextW(ItemNo)
  else if rv.GetItem(ItemNo).GetBoolValue(rvbpAlwaysInText) then begin
    s := rv.GetItem(ItemNo).AsText(0, rv.RVData, rv.GetItemTextR(ItemNo), '', True, True);
    if not rv.GetItem(ItemNo).GetBoolValue(rvbpCanSaveUnicode) then
      s := RVU_AnsiToUnicode(rv.RVData.GetDefaultCodePage, s);
    Result := RVU_RawUnicodeToWideString(s);
    end
  else
    Result := '';
end;

function GetItemText2(RVData: TCustomRVData; ItemNo: Integer): TRVUnicodeString;
var s: TRVRawByteString;
begin
  if RVData.GetItemStyle(ItemNo)>=0 then
    Result := RVData.GetItemTextW(ItemNo)
  else if RVData.GetItem(ItemNo).GetBoolValue(rvbpAlwaysInText) then begin
    s := RVData.GetItem(ItemNo).AsText(0, RVData, RVData.GetItemTextR(ItemNo), '', True, True);
    if not RVData.GetItem(ItemNo).GetBoolValue(rvbpCanSaveUnicode) then
      s := RVU_AnsiToUnicode(RVData.GetDefaultCodePage, s);
    Result := RVU_RawUnicodeToWideString(s);
    end
  else
    Result := '';
end;


function GetCurrentLineText(rve: TCustomRichViewEdit): TRVUnicodeString;
var i, DNo1, DNo2, DOffs: Integer;
    No1, No2, Offs1, Offs2: Integer;
    s: TRVUnicodeString;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  rve.RVData.Item2DrawItem(rve.CurItemNo, rve.OffsetInCurItem, DNo1, DOffs, rvdpBetterBelow);
  DNo2 := DNo1+1;
  while not rve.RVData.DrawItems[DNo1].FromNewLine do
    dec(DNo1);
  while (DNo2<rve.ItemCount) and not rve.RVData.DrawItems[DNo2].FromNewLine do
    inc(DNo2);
  dec(DNo2);
  rve.RVData.DrawItem2Item(DNo1, rve.RVData.GetOffsBeforeDrawItem(DNo1), No1, Offs1);
  rve.RVData.DrawItem2Item(DNo2, rve.RVData.GetOffsAfterDrawItem(DNo2), No2, Offs2);
  if No1<>No2 then begin
    if rve.GetItemStyle(No1)>=0 then begin
      s := rve.GetItemTextW(No1);
      Result := Copy(s, Offs1, Length(s));
    end;
    for i := No1+1 to No2-1 do
      if rve.GetItemStyle(i)>=0 then
        Result := Result+rve.GetItemTextW(i);
    if rve.GetItemStyle(No2)>=0 then begin
      s := rve.GetItemTextW(No2);
      Result := Result+Copy(s, 1, Offs2-1);
    end;
    end
  else if rve.GetItemStyle(No1)<0 then
    Result := GetItemText(rve, No1)
  else
    Result := Copy(rve.GetItemTextW(No1), Offs1, Offs2-Offs1);
end;

function GetVisibleText(rv: TCustomRichView): TRVUnicodeString;
var i: Integer;
begin
  i := rv.FirstItemVisible;
  if i<0 then begin
    Result := '';
    exit;
  end;
  Result := GetItemText(rv, i);
  for i := i+1 to rv.LastItemVisible do begin
    if rv.IsFromNewLine(i) then
      Result := Result + #13#10;
    Result := Result+GetItemText(rv, i);
  end;
end;


function GetRVDataText(RVData: TCustomRVData): TRVUnicodeString;
var i: Integer;
begin
  if RVData.ItemCount=0 then begin
    Result := '';
    exit;
  end;
  i := 0;
  Result := GetItemText2(RVData, i);
  for i := i+1 to RVData.ItemCount-1 do begin
    if RVData.IsFromNewLine(i) then
      Result := Result + #13#10;
    Result := Result+GetItemText2(RVData, i);
  end;
end;

function GetAllText(rv: TCustomRichView): TRVUnicodeString;
begin
  Result := GetRVDataText(rv.RVData);
end;

function GetCurrentParaSectionText(rve: TCustomRichViewEdit): TRVUnicodeString;
var i: Integer;
    No1, No2, Offs1, Offs2: Integer;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  rve.RVData.GetSelectionBoundsEx(No1,Offs1,No2,Offs2,True);
  rve.RVData.ExpandToParaSection(No1,No2,No1,No2);
  for i := No1 to No2 do
    if rve.GetItemStyle(i)>=0 then
      Result := Result+GetItemText(rve, i);
end;

function GetCurrentParaText(rve: TCustomRichViewEdit): TRVUnicodeString;
var i: Integer;
    No1, No2, Offs1, Offs2: Integer;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  rve.RVData.GetSelectionBoundsEx(No1,Offs1,No2,Offs2,True);
  rve.RVData.ExpandToPara(No1,No2,No1,No2);
  Result := GetItemText(rve,No1);
  for i := No1+1 to No2 do begin
    if rve.IsFromNewLine(i) then
      Result := Result + #13#10;
    Result := Result+GetItemText(rve,i);
  end;
end;

function GetCurrentChar(rve: TCustomRichViewEdit): TRVUnicodeString;
var ItemNo, Offs: Integer;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  ItemNo := rve.CurItemNo;
  Offs := rve.OffsetInCurItem;
  if (Offs<rve.GetOffsBeforeItem(ItemNo)) and
    (ItemNo>0) and not rve.IsFromNewLine(ItemNo) then begin
    dec(ItemNo);
    Offs := rve.GetOffsAfterItem(ItemNo);
  end;
  if rve.GetItemStyle(ItemNo)>=0 then begin
    dec(Offs);
    if Offs=0 then Offs := 1;
    Result := rve.GetItemTextW(ItemNo);
    if Length(Result)>=Offs then
      Result := Result[Offs]
    else
      Result := '';
  end;
end;

function GetCurrentWord(rve: TCustomRichViewEdit): TRVUnicodeString;
var first, last, ItemNo, Offs, Len: Integer;
    s: TRVUnicodeString;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  if rve.GetItemStyle(rve.CurItemNo)<0 then
    exit;
  Offs   := rve.OffsetInCurItem;
  ItemNo := rve.CurItemNo;
  Last   := Offs;
  First  := Offs;
  s      := rve.GetItemTextW(ItemNo);
  Len    := Length(s);
  while (Last<=Len) do begin
    if rve.RVData.IsDelimiterW(s[Last]) then
      break;
    inc(Last);
  end;
  dec(First);
  while (First>0) do begin
    if  rve.RVData.IsDelimiterW(s[First]) then begin
      inc(First);
      break;
    end;
    dec(First);
  end;
  if First=0 then
    inc(First);
  Result := Copy(s, First, Last-First);
end;

{$ENDIF}

end.
