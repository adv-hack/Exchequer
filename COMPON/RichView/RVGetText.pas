
{*******************************************************}
{                                                       }
{       RichView                                        }
{       A set of functions retrieving text from         }
{       document.                                       }
{                                                       }
{       Copyright (c) 2003, Sergey Tkachenko            }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVGetText;

interface
uses RVItem, RichView, RVEdit, CRVData, RVTypes, CRVFData;

// Returns text of line with caret
function GetCurrentLineText(rve: TCustomRichViewEdit): TRVAnsiString;

// Returns visible text (may be, with a line before and after)
function GetVisibleText(rv: TCustomRichView): TRVAnsiString;

// Returns all text
function GetAllText(rv: TCustomRichView): TRVAnsiString;

// Returns all text in RVData
function GetRVDataText(RVData: TCustomRVData): TRVAnsiString;

// Returns text of paragraph section with caret
// (paragraph section is a part of document limited either by
// paragraph breaks or by new line breaks (added with Shift+Enter)
function GetCurrentParaSectionText(rve: TCustomRichViewEdit): TRVAnsiString;

// Returns text of paragraph with caret
function GetCurrentParaText(rve: TCustomRichViewEdit): TRVAnsiString;

// Returns character to the left of caret.
// If caret is at the beginning of line, - to the right.
// If no character, returns empty TRVAnsiString
function GetCurrentChar(rve: TCustomRichViewEdit): TRVAnsiString;

// Returns the current word
function GetCurrentWord(rve: TCustomRichViewEdit): TRVAnsiString;

implementation
uses RVStyle;

function GetItemText(rv: TCustomRichView; ItemNo: Integer): TRVAnsiString;
begin
  if rv.GetItemStyle(ItemNo)>=0 then
    Result := rv.GetItemTextA(ItemNo)
  else if rv.GetItem(ItemNo).GetBoolValue(rvbpAlwaysInText) then
    Result := rv.GetItem(ItemNo).AsText(0, rv.RVData, rv.GetItemTextR(ItemNo), '', True, False)
  else
    Result := '';
end;

function GetItemText2(RVData: TCustomRVData; ItemNo: Integer): TRVAnsiString;
begin
  if RVData.GetItemStyle(ItemNo)>=0 then
    Result := RVData.GetItemTextA(ItemNo)
  else if RVData.GetItem(ItemNo).GetBoolValue(rvbpAlwaysInText) then
    Result := RVData.GetItem(ItemNo).AsText(0, RVData, RVData.GetItemTextR(ItemNo), '', True, False)
  else
    Result := '';
end;


function GetCurrentLineText(rve: TCustomRichViewEdit): TRVAnsiString;
var i, DNo1, DNo2, DOffs: Integer;
    No1, No2, Offs1, Offs2: Integer;
    s: TRVAnsiString;
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
      s := rve.GetItemTextA(No1);
      Result := Copy(s, Offs1, Length(s));
    end;
    for i := No1+1 to No2-1 do
      if rve.GetItemStyle(i)>=0 then
        Result := Result+rve.GetItemTextA(i);
    if rve.GetItemStyle(No2)>=0 then begin
      s := rve.GetItemTextA(No2);
      Result := Result+Copy(s, 1, Offs2-1);
    end;
    end
  else if rve.GetItemStyle(No1)<0 then
    Result := GetItemText(rve, No1)
  else
    Result := Copy(rve.GetItemTextA(No1), Offs1, Offs2-Offs1);
end;

function GetVisibleText(rv: TCustomRichView): TRVAnsiString;
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


function GetRVDataText(RVData: TCustomRVData): TRVAnsiString;
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

function GetAllText(rv: TCustomRichView): TRVAnsiString;
begin
  Result := GetRVDataText(rv.RVData);
end;

function GetCurrentParaSectionText(rve: TCustomRichViewEdit): TRVAnsiString;
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

function GetCurrentParaText(rve: TCustomRichViewEdit): TRVAnsiString;
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

function GetCurrentChar(rve: TCustomRichViewEdit): TRVAnsiString;
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
    Result := rve.GetItemTextA(ItemNo);
    if Length(Result)>=Offs then
      Result := Result[Offs]
    else
      Result := '';
  end;
end;

function GetCurrentWord(rve: TCustomRichViewEdit): TRVAnsiString;
var first, last, ItemNo, Offs, Len: Integer;
    s: TRVAnsiString;
    CodePage: TRVCodePage;
begin
  Result := '';
  rve := rve.TopLevelEditor;
  if rve.GetItemStyle(rve.CurItemNo)<0 then
    exit;
  Offs   := rve.OffsetInCurItem;
  ItemNo := rve.CurItemNo;
  Last   := Offs;
  First  := Offs;
  s      := rve.GetItemTextA(ItemNo);
  Len    := Length(s);
  CodePage := rve.RVData.GetItemCodePage(ItemNo);
  while (Last<=Len) do begin
    if rve.RVData.IsDelimiterA(s[Last], CodePage) then
      break;
    inc(Last);
  end;
  dec(First);
  while (First>0) do begin
    if rve.RVData.IsDelimiterA(s[First], CodePage) then begin
      inc(First);
      break;
    end;
    dec(First);
  end;
  if First=0 then
    inc(First);
  Result := Copy(s, First, Last-First);
end;



end.
