
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVDrawLineInfo: stores formatting for          }
{       one item in RichView document.                  }
{       TRVDrawLines: a list of TRVDrawLineInfo.        }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit DLines;

interface
{$I RV_Defs.inc}
uses Classes, RVStyle, RVTypes, RVClasses;
type
{-----------------------------------------------------------------------}
{
  TRVDrawLineInfo stores formatting for one item in RichView document.
  These classes are often referred in other places as "draw items".
  One item can corresponds to several draw items:
  - each line of wrapped text item corresponds to one draw item.
  This class is actually used for the most of items. But in some cases
  (printing item on several pages) inherited classes are used instead.

}

  { This class is used in non-justify paragraphs with standard line spacing,
    except for special cases

    FloatingAboveUsed is True for all draw items of some line in the following cases:
    - left or right side of this line is adjusted because of side-aligned items
      from the lines above
    - this line is moved down because of side-aligned items from the lines above
  }
  TRVDrawLineInfo = class
    private
      procedure RaiseWrongAssignException(const Value: Integer);
    protected
      function GetSpaceAtLeft: Integer; virtual;
      procedure SetSpaceAtLeft(const Value: Integer); virtual;
      function GetExtraSpaceAbove: Integer; virtual;
      procedure SetExtraSpaceAbove(const Value: Integer); virtual;
      function GetExtraSpaceBelow: Integer; virtual;
      procedure SetExtraSpaceBelow(const Value: Integer); virtual;
      function GetObjectHeight: Integer; virtual;
      function GetObjectLeft: Integer; virtual;
      function GetObjectTop: Integer; virtual;
      function GetObjectWidth: Integer; virtual;
    public
      Left, Top, Width, Height: Integer; // coordinates, relative to the top left of document
      ItemNo, Offs, Length: Integer; // links to items; length is used for text drawitems
      {$IFDEF RVUSEBASELINE}BaseLine: Integer;{$ENDIF}      
      FromNewLine: ByteBool;  // true, if draw item starts a screen line
      FromNewPara: ByteBool;  // true, if draw item starts a paragraph or its section
      FloatingAboveUsed: ByteBool;
      constructor CreateEx(ALeft, ATop, AWidth, AHeight, AItemNo: Integer;
        AFromNewLine: ByteBool);
      procedure SetData(ALeft, ATop, AItemNo: Integer; AFromNewLine: ByteBool); virtual;
      procedure SetSize(AWidth, AHeight: Integer);virtual;
      function InitSplit(const SaD: TRVScreenAndDevice): Boolean; dynamic;
      function CanSplitFirst(Y: Integer; const SaD: TRVScreenAndDevice;
        FirstOnPage, PageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean; dynamic;
      function SplitAt(Y: Integer; const SaD: TRVScreenAndDevice;
        FirstOnPage: Boolean; var FootnoteRVDataList: TList;
        var MaxHeight: Integer; FootnotesChangeHeight: Boolean): Boolean; dynamic;
      property SpaceAtLeft: Integer read GetSpaceAtLeft write SetSpaceAtLeft;
      property ExtraSpaceBelow: Integer read GetExtraSpaceBelow write SetExtraSpaceBelow;
      property ExtraSpaceAbove: Integer read GetExtraSpaceAbove write SetExtraSpaceAbove;
      property ObjectWidth: Integer read GetObjectWidth;
      property ObjectHeight: Integer read GetObjectHeight;
      property ObjectLeft: Integer read GetObjectLeft;
      property ObjectTop: Integer read GetObjectTop;
  end;

  { This class is used in justified paragraphs with standard line spacing
    or for list markers }
  TRVJustifyDrawLineInfo = class (TRVDrawLineInfo)
    private
      FSpaceAtLeft: Integer;
    protected
      function GetSpaceAtLeft: Integer; override;
      procedure SetSpaceAtLeft(const Value: Integer); override;
    public
      SpaceAtLeft: Integer;
  end;

  { This class is used in paragraphs with simple line spacing (% and spacing after) }
  TRVSimpleLineHeightDrawLineInfo = class (TRVJustifyDrawLineInfo)
    private
      FExtraSpaceBelow: Integer;
    protected
      function GetExtraSpaceBelow: Integer; override;
      procedure SetExtraSpaceBelow(const Value: Integer); override;
  end;

  { This class is used in paragraphs with complex line spacing (at least and exact) }
  TRVComplexLineHeightDrawLineInfo = class (TRVSimpleLineHeightDrawLineInfo)
    private
      FExtraSpaceAbove: Integer;
    protected
      function GetExtraSpaceAbove: Integer; override;
      procedure SetExtraSpaceAbove(const Value: Integer); override;
  end;

  TRVDItemFloatingType = (rvdifLeft, rvdifRight);

  { This class is used for floating items }
  TRVFloatingDrawLineInfo = class (TRVComplexLineHeightDrawLineInfo)
    private
      function GetFloatBottom: Integer;
      function GetFloatRight: Integer;
    protected
      function GetObjectHeight: Integer; override;
      function GetObjectLeft: Integer; override;
      function GetObjectTop: Integer; override;
      function GetObjectWidth: Integer; override;
    public
      FloatLeft, FloatTop, FloatWidth, FloatHeight: Integer;
      FloatType: TRVDItemFloatingType;
      property FloatRight: Integer read GetFloatRight;
      property FloatBottom: Integer read GetFloatBottom;
  end;


  TRVDrawLineInfoClass = class of TRVDrawLineInfo;
{-----------------------------------------------------------------------}
{
  TRVDrawLines - a list of TRVDrawLineInfo (or inherited)
}
  TRVDrawLines = class (TList)
    private
      FStartDeletedIndex, FDeletedCount: Integer;
      function Get(Index: Integer): TRVDrawLineInfo;
      procedure Put(Index: Integer; const Value: TRVDrawLineInfo);
      procedure DeleteRange(Index1, Index2: Integer);
    public
      constructor Create;
      procedure MarkForDelete(Index1, Index2: Integer);
      procedure DeleteMarked;
      procedure Insert(Index: Integer; Item: Pointer);
      procedure Delete(Index: Integer);
      function GetString(Index: Integer; AItems: TList): TRVRawByteString;
      function GetSubString(Index: Integer; AItems: TList;
        AStartIndex, ALength: Integer): TRVRawByteString;
      function GetRightString(Index: Integer; AItems: TList;
        AStartIndex: Integer): TRVRawByteString;
      function FindFirstFloatingAboveDrawItem(Index, MinIndex, Bottom: Integer;
        UseBottom: Boolean): Integer;
      property Items[Index: Integer]: TRVDrawLineInfo read Get write Put; default;
  end;

  { A list of floating drawing items }
  TRVFloatingDrawItems = class (TRVDrawLines)
    private
      function MarkedHaveFloatType(Marks: TRVIntegerList; FloatType: TRVDItemFloatingType): Boolean;
    public
      procedure FillFloatingAboveDrawItem(DItemNo: Integer; Source: TRVDrawLines);
      procedure FillFloatingCrossingY(Y, DItemNo: Integer; Source: TRVDrawLines);
      procedure RemoveNonOverlapping(Y: Integer);
      procedure MarkNonOverlapping(Y: Integer; Marks: TRVIntegerList);
      procedure AdjustLineSize(MinLeftIndent, MinWidth, MaxRightSide: Integer;
        var Y, LeftIndent, LineWidth: Integer;
        AllowDelete, ClearLeft, ClearRight: Boolean;
        ClearIgnore: TList);
      function GetFloatBottom: Integer;
  end;

implementation
uses RVUni, RVItem, RVStr, RVFuncs;
{============================= TRVDrawLineInfo ============================}
{ Constructor. Assigns the main properties                                     }
constructor TRVDrawLineInfo.CreateEx(ALeft, ATop, AWidth, AHeight,
  AItemNo: Integer; AFromNewLine: ByteBool);
begin
  inherited Create;
  SetData(ALeft, ATop, AItemNo, AFromNewLine);
  SetSize(AWidth, AHeight);
end;
{------------------------------------------------------------------------------}
{ Assigning the main properties                                                }
procedure TRVDrawLineInfo.SetData(ALeft, ATop, AItemNo: Integer;
  AFromNewLine: ByteBool);
begin
  Left   := ALeft;
  Top    := ATop;
  ItemNo := AItemNo;
  FromNewLine := AFromNewLine;
end;
{------------------------------------------------------------------------------}
{ Assigning width and height                                                   }
procedure TRVDrawLineInfo.SetSize(AWidth, AHeight: Integer);
begin
  Width  := AWidth;
  Height := AHeight;
end;
{------------------------------------------------------------------------------}
{ CanSplitFirst, InitSplit, SplitAt are used for printing items across pages.
  Actual implementations are in inherited classes.
  CanSplitFirst: can item be split at position Y (relative to the top of item) }
function TRVDrawLineInfo.CanSplitFirst(Y: Integer;
  const Sad: TRVScreenAndDevice; FirstOnPage, PageHasFootnotes,
  FootnotesChangeHeight: Boolean): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
{ Initialize splitting. Return true if successful                              }
function TRVDrawLineInfo.InitSplit(const Sad: TRVScreenAndDevice): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
{ Split at the specified position (Y is relative to the top of item)           }
function TRVDrawLineInfo.SplitAt(Y: Integer; const Sad: TRVScreenAndDevice;
  FirstOnPage: Boolean; var FootnoteRVDataList: TList;
  var MaxHeight: Integer; FootnotesChangeHeight: Boolean): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
// This code is commented out, because in some intermediate state a document
// may be incorrect: paragraph may contain items with different ParaNo.
// For example, in TRVEditRVData.OnDeletePress_, until the paragraph is fixed in
// AdjustCaret
procedure TRVDrawLineInfo.RaiseWrongAssignException(const Value: Integer);
begin
//  if Value<>0 then
//    raise ERichViewError.Create(errWrongAssign);
end;
{------------------------------------------------------------------------------}
{ This drawing item type is used for paragraphs and items where SpaceAtLeft
  is not used. }
function TRVDrawLineInfo.GetSpaceAtLeft: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVDrawLineInfo.SetSpaceAtLeft(const Value: Integer);
begin
  RaiseWrongAssignException(Value);
end;
{------------------------------------------------------------------------------}
{ This drawing item type is used for paragraphs and items where ExtraSpaceAbove
  is not used. }
function TRVDrawLineInfo.GetExtraSpaceAbove: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVDrawLineInfo.SetExtraSpaceAbove(const Value: Integer);
begin
  RaiseWrongAssignException(Value);
end;
{------------------------------------------------------------------------------}
{ This drawing item type is used for paragraphs and items where ExtraSpaceBelow
  is not used. }
function TRVDrawLineInfo.GetExtraSpaceBelow: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVDrawLineInfo.SetExtraSpaceBelow(const Value: Integer);
begin
  RaiseWrongAssignException(Value);
end;
{------------------------------------------------------------------------------}
function TRVDrawLineInfo.GetObjectHeight: Integer;
begin
  Result := Height;
end;
{------------------------------------------------------------------------------}
function TRVDrawLineInfo.GetObjectLeft: Integer;
begin
  Result := Left;
end;
{------------------------------------------------------------------------------}
function TRVDrawLineInfo.GetObjectTop: Integer;
begin
  Result := Top;
end;
{------------------------------------------------------------------------------}
function TRVDrawLineInfo.GetObjectWidth: Integer;
begin
  Result := Width;
end;
{============================= TRVJustifyDrawLineInfo =========================}
function TRVJustifyDrawLineInfo.GetSpaceAtLeft: Integer;
begin
  Result := FSpaceAtLeft;
end;
{------------------------------------------------------------------------------}
procedure TRVJustifyDrawLineInfo.SetSpaceAtLeft(const Value: Integer);
begin
  FSpaceAtLeft := Value;
end;
{========================== TRVSimpleLineHeightDrawLineInfo ===================}
function TRVSimpleLineHeightDrawLineInfo.GetExtraSpaceBelow: Integer;
begin
  Result := FExtraSpaceBelow;
end;
{------------------------------------------------------------------------------}
procedure TRVSimpleLineHeightDrawLineInfo.SetExtraSpaceBelow(
  const Value: Integer);
begin
  FExtraSpaceBelow := Value;
end;
{========================= TRVComplexLineHeightDrawLineInfo ===================}
function TRVComplexLineHeightDrawLineInfo.GetExtraSpaceAbove: Integer;
begin
  Result := FExtraSpaceAbove;
end;
{------------------------------------------------------------------------------}
procedure TRVComplexLineHeightDrawLineInfo.SetExtraSpaceAbove(
  const Value: Integer);
begin
  FExtraSpaceAbove := Value;
end;
{================================ TRVDrawLines ================================}
{ Constructor                                                                  }
constructor TRVDrawLines.Create;
begin
  inherited Create;
  FStartDeletedIndex := -1;
  FDeletedCount      := 0;
end;
{------------------------------------------------------------------------------}
{ This method is used in editor for reformatting a part of document.
  It's more efficient to mark a range of items for deletion (freeing the
  corresponding objects) and reuse list items, than to perform actual deletion
  with subsequent insertion }
procedure TRVDrawLines.MarkForDelete(Index1, Index2: Integer);
var i: Integer;
begin
  FStartDeletedIndex := Index1;
  FDeletedCount      := Index2-Index1+1;
  for i := Index1 to Index2 do begin
    TObject(Items[i]).Free;
    Items[i] := nil;
  end;
end;
{------------------------------------------------------------------------------}
{ Deletes items marked by MarkForDelete                                        }
procedure TRVDrawLines.DeleteMarked;
begin
  if FDeletedCount<>0 then begin
    DeleteRange(FStartDeletedIndex, FStartDeletedIndex+FDeletedCount-1);
    FDeletedCount := 0;
  end;
end;
{------------------------------------------------------------------------------}
{ Inserts a new item at the position Index. Tries to reuse items marked by
  MarkForDelete                                                                }
procedure TRVDrawLines.Insert(Index: Integer; Item: Pointer);
begin
  if FDeletedCount=0 then
    inherited Insert(Index, Item)
  else begin
    Assert(Index=FStartDeletedIndex);
    inc(FStartDeletedIndex);
    dec(FDeletedCount);
    Items[Index] := Item;
  end;
end;
{------------------------------------------------------------------------------}
{ Deletes the item at the position Index. Takes marking for deletion into
  account                                                                      }
procedure TRVDrawLines.Delete(Index: Integer);
begin
  Items[Index].Free;
  if FDeletedCount=0 then
    inherited Delete(Index)
  else begin
    //Assert(Index=FStartDeletedIndex);
    dec(FStartDeletedIndex);
    inc(FDeletedCount);
  end;
end;
{------------------------------------------------------------------------------}
{ Internal method. Deletes a range of items from Index1 to Index2.
  Assumes that corresponding objects are alredy freed                          }
procedure TRVDrawLines.DeleteRange(Index1, Index2: Integer);
begin
  if Index2 < Count-1 then
    System.Move(List^[Index2 + 1], List^[Index1],
      (Count - Index2 -1) * SizeOf(Pointer));
  Count := Count - (Index2-Index1+1);
end;
{------------------------------------------------------------------------------}
{ Method for accessing property Items[Index]                                   }
function TRVDrawLines.Get(Index: Integer): TRVDrawLineInfo;
begin
  Result := TRVDrawLineInfo(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
{ Method for assigning property Items[Index]                                   }
procedure TRVDrawLines.Put(Index: Integer; const Value: TRVDrawLineInfo);
begin
  inherited Put(Index, Value);
end;
{------------------------------------------------------------------------------}
{ Returns a string corresponding to the Index-th draw item.
  String is taken from the list of items (AItems).
  If one item corresponds to one draw item, this is a AItems[drawitem.ItemNo].
  If not (because of text wrapping), this is a substring of it (starting from
  the drawitem.Offs, having length drawitem.Length
  In case of Unicode, returns "raw unicode" string                             }
function TRVDrawLines.GetString(Index: Integer; AItems: TList): TRVRawByteString;
begin
 {$IFDEF RVDONOTUSEUNICODE}
  with Items[Index] do
    Result := Copy(TRVItemList(AItems).Items[ItemNo], Offs, Length);
  {$ELSE}
  with Items[Index] do
    Result := RVU_Copy(TRVItemList(AItems).Items[ItemNo], Offs, Length,
      TCustomRVItemInfo(TRVItemList(AItems).Objects[ItemNo]).ItemOptions);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ The same, but returns substring of drawitem's text, starting at AStartIndex
  position (1-based).                                                          }
function TRVDrawLines.GetRightString(Index: Integer; AItems: TList;
  AStartIndex: Integer): TRVRawByteString;
begin
  {$IFDEF RVDONOTUSEUNICODE}
  with Items[Index] do
    Result := Copy(TRVItemList(AItems).Items[ItemNo], Offs+AStartIndex-1, Length-AStartIndex+1);
  {$ELSE}
  with Items[Index] do
    Result := RVU_Copy(TRVItemList(AItems).Items[ItemNo], Offs+AStartIndex-1, Length-AStartIndex+1,
      TCustomRVItemInfo(TRVItemList(AItems).Objects[ItemNo]).ItemOptions);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ The same, but returns substring of drawitem's text, starting at AStartIndex
  position (1-based) and having length ALength                                 }
function TRVDrawLines.GetSubString(Index: Integer; AItems: TList;
  AStartIndex, ALength: Integer): TRVRawByteString;
begin
  with Items[Index] do begin
    if AStartIndex+ALength>Length+1 then
      ALength := Length-AStartIndex+1;
    {$IFDEF RVDONOTUSEUNICODE}
    Result := Copy(TRVItemList(AItems).Items[ItemNo], Offs+AStartIndex-1, ALength);
    {$ELSE}
    Result := RVU_Copy(TRVItemList(AItems).Items[ItemNo], Offs+AStartIndex-1, ALength,
      TCustomRVItemInfo(TRVItemList(AItems).Objects[ItemNo]).ItemOptions);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the first (with less index) floating item that overlaps
  Items[Index] vertically. Only items in range MinIndex..Index-1 are returned.
  If Bottom>=0, only items overlapping Bottom are taken into account. }
function TRVDrawLines.FindFirstFloatingAboveDrawItem(Index, MinIndex, Bottom: Integer;
  UseBottom: Boolean): Integer;
var i, Y: Integer;
    FloatingDItem: TRVFloatingDrawLineInfo;
begin
  Result := -1;
  if UseBottom then
    Y := Bottom
  else
    Y := Items[Index].Top;
  for i := Index-1 downto MinIndex do begin
    if (Items[i] is TRVFloatingDrawLineInfo) then begin
      FloatingDItem := TRVFloatingDrawLineInfo(Items[i]);
      if FloatingDItem.FloatBottom>=Y then
        Result := i;
    end;
    if Items[i].FromNewLine and not Items[i].FloatingAboveUsed then
      exit;
  end;
end;
{============================ TRVFloatingDrawLineInfo =========================}
function TRVFloatingDrawLineInfo.GetFloatBottom: Integer;
begin
  Result := FloatTop + FloatHeight;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawLineInfo.GetFloatRight: Integer;
begin
  Result := FloatLeft + FloatWidth;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawLineInfo.GetObjectHeight: Integer;
begin
  Result := FloatHeight;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawLineInfo.GetObjectLeft: Integer;
begin
  Result := FloatLeft;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawLineInfo.GetObjectTop: Integer;
begin
  Result := FloatTop;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawLineInfo.GetObjectWidth: Integer;
begin
  Result := FloatWidth;
end;
{=========================== TRVFloatingDrawItems =============================}
{ Create a list of floating items above Source[DItemNo] }
procedure TRVFloatingDrawItems.FillFloatingAboveDrawItem(DItemNo: Integer;
  Source: TRVDrawLines);
begin
  FillFloatingCrossingY(Source[DItemNo].Top, DItemNo, Source);
end;
{------------------------------------------------------------------------------}
procedure TRVFloatingDrawItems.FillFloatingCrossingY(Y, DItemNo: Integer;
  Source: TRVDrawLines);
var i: Integer;
    FloatingDItem: TRVFloatingDrawLineInfo;
begin
  for i := DItemNo-1 downto 0 do begin
    if (Source[i] is TRVFloatingDrawLineInfo) then begin
      FloatingDItem := TRVFloatingDrawLineInfo(Source[i]);
      if FloatingDItem.FloatBottom>=Y-1 then
        Insert(0, FloatingDItem);
    end;
    if Source[i].FromNewLine and not Source[i].FloatingAboveUsed then
      exit;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVFloatingDrawItems.RemoveNonOverlapping(Y: Integer);
var i: Integer;
begin
  if Self=nil then
    exit;
  for i := Count-1 downto 0 do
    if TRVFloatingDrawLineInfo(Items[i]).FloatBottom<Y then
      TList(Self).Delete(i); // deleting without destroying
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawItems.GetFloatBottom: Integer;
var i: Integer;
begin
  Result := 0;
  if Self=nil then
    exit;
  for i := 0 to Count-1 do
    if TRVFloatingDrawLineInfo(Items[i]).FloatBottom>Result then
      Result := TRVFloatingDrawLineInfo(Items[i]).FloatBottom;
end;
{------------------------------------------------------------------------------}
function TRVFloatingDrawItems.MarkedHaveFloatType(Marks: TRVIntegerList;
  FloatType: TRVDItemFloatingType): Boolean;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if ((Marks=nil) or (Marks[i]<>0)) and
      (TRVFloatingDrawLineInfo(Items[i]).FloatType=FloatType) then begin
      Result := True;
      exit;
    end;
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVFloatingDrawItems.MarkNonOverlapping(Y: Integer;
  Marks: TRVIntegerList);
var i: Integer;
begin
  if Self=nil then
    exit;
  for i := Count-1 downto 0 do
    if TRVFloatingDrawLineInfo(Items[i]).FloatBottom<Y then
      Marks[i] := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVFloatingDrawItems.AdjustLineSize(
  MinLeftIndent, MinWidth, MaxRightSide: Integer;
  var Y, LeftIndent, LineWidth: Integer;
  AllowDelete, ClearLeft, ClearRight: Boolean;
  ClearIgnore: TList);

  {........................................}
  function UseClearFor(DItem: TRVDrawLineInfo): Boolean;
  begin
    Result := (ClearIgnore=nil) or (ClearIgnore.IndexOf(DItem)<0);
  end;
  {........................................}

var i, CurLineWidth, CurLeftIndent: Integer;
    FloatingDItem: TRVFloatingDrawLineInfo;
    TryAgain: Boolean;
    Marks: TRVIntegerList;
begin
  if Self=nil then
    exit;
  TryAgain := True;
  CurLineWidth := LineWidth;
  CurLeftIndent := LeftIndent;
  if not AllowDelete then
    Marks := TRVIntegerList.CreateEx(Count, 1)
  else
    Marks := nil;
  if AllowDelete then
    RemoveNonOverlapping(Y)
  else
    MarkNonOverlapping(Y, Marks);
  while TryAgain do begin
    CurLineWidth := LineWidth;
    CurLeftIndent := LeftIndent;
    if not MarkedHaveFloatType(Marks, rvdifLeft) then
      CurLeftIndent := MinLeftIndent;
    if not MarkedHaveFloatType(Marks, rvdifRight) then
      CurLineWidth := MaxRightSide-CurLeftIndent;
    if (Count=0) or ((Marks<>nil) and Marks.AreAllEqualTo(0)) then
      break;
    // checking left-aligned
    TryAgain := False;
    for i := Count-1 downto 0 do begin
      if (Marks<>nil) and (Marks[i]=0) then
        continue;
      FloatingDItem := TRVFloatingDrawLineInfo(Items[i]);
      if FloatingDItem.FloatType=rvdifLeft then begin
        if CurLeftIndent<FloatingDItem.FloatRight then begin
          dec(CurLineWidth, FloatingDItem.FloatRight-CurLeftIndent);
          CurLeftIndent := FloatingDItem.FloatRight;
        end;
        if (ClearLeft and UseClearFor(FloatingDItem)) or (CurLineWidth<MinWidth) then begin
          Y := FloatingDItem.FloatBottom+1;
          if AllowDelete then
            RemoveNonOverlapping(Y)
          else
            MarkNonOverlapping(Y, Marks);
          TryAgain := True;
          break;
        end;
        break;
      end;
    end;
    if TryAgain then
      continue;
    // checking right-aligned
    for i := Count-1 downto 0 do begin
      if (Marks<>nil) and (Marks[i]=0) then
        continue;
      FloatingDItem := TRVFloatingDrawLineInfo(Items[i]);
      if FloatingDItem.FloatType=rvdifRight then begin
        if FloatingDItem.FloatLeft<CurLeftIndent+CurLineWidth then begin
          if CurLeftIndent>FloatingDItem.FloatLeft then
              CurLineWidth := -1
            else
              CurLineWidth := FloatingDItem.FloatLeft-CurLeftIndent;
        end;
        if (ClearRight and UseClearFor(FloatingDItem)) or (CurLineWidth<MinWidth) then begin
          Y := FloatingDItem.FloatBottom+1;
          if AllowDelete then
            RemoveNonOverlapping(Y)
          else
            MarkNonOverlapping(Y, Marks);
          TryAgain := True;
          break;
        end;
        break;
      end;
    end;
  end;
  LineWidth := CurLineWidth;
  LeftIndent := CurLeftIndent;
  Marks.Free;
end;

end.
