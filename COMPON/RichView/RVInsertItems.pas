unit RVInsertItems;

interface

{$I RV_Defs.inc}

uses RichView, RVUni, RVTypes, RVItem, CRVData;

// Functions for inserting text
procedure RVInsertStringA(RVData: TCustomRVData; ItemNo: Integer;
  const s: TRVAnsiString; StyleNo, ParaNo: Integer; Tag: Integer=0);
procedure RVInsertStringW(RVData: TCustomRVData; ItemNo: Integer;
  const s: TRVUnicodeString; StyleNo, ParaNo: Integer; Tag: Integer=0);
procedure RVInsertString(RVData: TCustomRVData; ItemNo: Integer;
  const s: String; StyleNo, ParaNo: Integer; Tag: Integer=0);

// Functions for converting Strings to item text

function RVConvertStringToItemText(const Text: String;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString; overload;
function RVConvertStringToItemText(const Text: String;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString; overload;

function RVConvertAnsiStringToItemText(const Text: TRVAnsiString;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString; overload;
function RVConvertAnsiStringToItemText(const Text: TRVAnsiString;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString; overload;

function RVConvertUnicodeStringToItemText(const Text: TRVUnicodeString;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString; overload;
function RVConvertUnicodeStringToItemText(const Text: TRVUnicodeString;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString; overload;

implementation

const
  errInvalidItemIndex = 'Invalid item index for insertion';
{------------------------------------------------------------------------------}
function RVConvertStringToItemText(const Text: String;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString;
begin
  {$IFDEF RVUNICODESTR}
   Result := RVConvertUnicodeStringToItemText(Text, UnicodeItem, CodePage);
  {$ELSE}
   Result := RVConvertAnsiStringToItemText(Text, UnicodeItem, CodePage);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function RVConvertStringToItemText(const Text: String;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString;
begin
  Result := RVConvertStringToItemText(Text,
    RVData.GetRVStyle.TextStyles[StyleNo].Unicode,
    RVData.GetStyleCodePage(StyleNo));
end;
{------------------------------------------------------------------------------}
function RVConvertAnsiStringToItemText(const Text: TRVAnsiString;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString;
begin
  if UnicodeItem then
    Result := RVU_AnsiToUnicode(CodePage, Text)
  else
    Result := Text;
end;
{------------------------------------------------------------------------------}
function RVConvertAnsiStringToItemText(const Text: TRVAnsiString;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString;
begin
  Result := RVConvertAnsiStringToItemText(Text,
    RVData.GetRVStyle.TextStyles[StyleNo].Unicode,
    RVData.GetStyleCodePage(StyleNo));
end;
{------------------------------------------------------------------------------}
function RVConvertUnicodeStringToItemText(const Text: TRVUnicodeString;
  UnicodeItem: Boolean; CodePage: Cardinal): TRVRawByteString;
begin
  Result := RVU_GetRawUnicode(Text);
  if not UnicodeItem then
    Result := RVU_UnicodeToAnsi(CodePage, Result);
end;
{------------------------------------------------------------------------------}
function RVConvertUnicodeStringToItemText(const Text: TRVUnicodeString;
  RVData: TCustomRVData; StyleNo: Integer): TRVRawByteString;
begin
  Result := RVConvertUnicodeStringToItemText(Text,
    RVData.GetRVStyle.TextStyles[StyleNo].Unicode,
    RVData.GetStyleCodePage(StyleNo));
end;
{------------------------------------------------------------------------------}
procedure CheckInsertionIndex(RVData: TCustomRVData; ItemNo: Integer);
begin
  if (ItemNo<0) or (ItemNo>RVData.ItemCount) then
    raise ERichViewError.Create(errInvalidItemIndex);
end;
{------------------------------------------------------------------------------}
procedure InsertItem(RVData: TCustomRVData; ItemNo: Integer;
  var s: TRVRawByteString; Item: TCustomRVItemInfo);
begin
  if item.ParaNo<0 then
    if ItemNo=0 then begin
      item.ParaNo := 0;
      item.SameAsPrev := False;
      end
    else begin
      item.ParaNo := RVData.GetItemPara(ItemNo-1);
      item.SameAsPrev := True;
    end
  else
    item.SameAsPrev := False;
  item.Inserting(RVData, s, False);
  RVData.Items.InsertObject(ItemNo, s, item);
  item.Inserted(RVData, ItemNo);
end;
{------------------------------------------------------------------------------}
procedure RVInsertStringA(RVData: TCustomRVData; ItemNo: Integer;
  const s: TRVAnsiString; StyleNo, ParaNo: Integer; Tag: Integer=0);
var item: TRVTextItemInfo;
    sr: TRVRawByteString;
begin
  CheckInsertionIndex(RVData, ItemNo);
  item := RichViewTextItemClass.Create(RVData);
  item.StyleNo := StyleNo;
  item.ParaNo := ParaNo;
  item.Tag := Tag;  
  StyleNo := RVData.GetActualStyle(Item);
  sr := RVConvertAnsiStringToItemText(s, RVData, StyleNo);
  if RVData.GetRVStyle.TextStyles[StyleNo].Unicode then
    Item.ItemOptions := Item.ItemOptions+[rvioUnicode];
  InsertItem(RVData, ItemNo, sr, Item);
end;
{------------------------------------------------------------------------------}
procedure RVInsertStringW(RVData: TCustomRVData; ItemNo: Integer;
  const s: TRVUnicodeString; StyleNo, ParaNo: Integer; Tag: Integer=0);
var item: TRVTextItemInfo;
    sr: TRVRawByteString;
begin
  CheckInsertionIndex(RVData, ItemNo);
  item := RichViewTextItemClass.Create(RVData);
  item.StyleNo := StyleNo;
  item.ParaNo := ParaNo;
  item.Tag := Tag;
  StyleNo := RVData.GetActualStyle(Item);
  sr := RVConvertUnicodeStringToItemText(s, RVData, StyleNo);
  if RVData.GetRVStyle.TextStyles[StyleNo].Unicode then
    Item.ItemOptions := Item.ItemOptions+[rvioUnicode];
  InsertItem(RVData, ItemNo, sr, Item);
end;
{------------------------------------------------------------------------------}
procedure RVInsertString(RVData: TCustomRVData; ItemNo: Integer;
  const s: String; StyleNo, ParaNo: Integer; Tag: Integer=0);
begin
  {$IFDEF RVUNICODESTR}
  RVInsertStringW(RVData, ItemNo, s, StyleNo, ParaNo, Tag);
  {$ELSE}
  RVInsertStringA(RVData, ItemNo, s, StyleNo, ParaNo, Tag);
  {$ENDIF}
end;

end.
