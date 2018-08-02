
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVSerializer - class converting RichView       }
{       coordinates (RVData, ItemNo) to linear          }
{       coordinates (AbsoluteItemNo) and vice versa.    }
{       Used in parsers for spell-checkers.             }
{       See RVLinear.pas for converting                 }
{       (RVData, ItemNo, Offset) to AbsoluteItemNo'.    }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVSer;

interface
uses SysUtils, Classes, RVClasses,
     RichView, CRVData, CRVFData, RVERVData, RVItem, RVEdit, RVRVData;

type
  { TRVSerEntry - describes document fragment belonging to one RVData.
    There may be several entries for one RVData, if RVData contains tables.
    The first of such entries corresponds to items from 0 to the first table item.
    The second entry corresponds to items from the first table (because tables have
    two absolute indices (before and after) to the second table, and so on.
    Between them, entries corresponding to table cells are located.

    Properties:
    - RVData - main document or cell (not an inplace editor's RVData).
    - AbsFirstItemNo - absolute index of the first item in this entry.
      For non-first entry for this RVData, AbsFirstItemNo is an index of table.
    - FirstItemNo - index of item in RVData corresponding to AbsFirstItemNo.
    - IsFirst - true if this is the first entry for RVData
  }
  TRVSerEntry = class
    public
      RVData: TCustomRVData;
      AbsFirstItemNo, FirstItemNo: Integer;
      IsFirst: Boolean;
      constructor Create(ARVData: TCustomRVData);
  end;



  TRVSerializer = class (TRVList)
    private
      FCachedEntryNo: Integer;
      FRootRVData: TCustomRVFormattedData;
      procedure CreateEntries(RVData: TCustomRVData; var AbsItemNo: Integer);
    public
      AbsItemCount: Integer;
      constructor Create(RVData: TCustomRVFormattedData);
      procedure Rebuild;
      procedure AbsoluteToRV(AbsItemNo: Integer;
        var RVData: TCustomRVData; var ItemNo: Integer; var AfterItem: Boolean);
      procedure RVToAbsolute(RVData: TCustomRVData;
        ItemNo: Integer; AfterItem: Boolean; var AbsItemNo: Integer);
  end;

implementation

{============================== TRVSerEntry ===================================}
constructor TRVSerEntry.Create(ARVData: TCustomRVData);
begin
  inherited Create;
  RVData        := ARVData;
end;
{============================== TRVSerializer =================================}
constructor TRVSerializer.Create(RVData: TCustomRVFormattedData);

begin
  inherited Create;
  FRootRVData := RVData;
  Rebuild;
end;
{------------------------------------------------------------------------------}
procedure TRVSerializer.Rebuild;
begin
  AbsItemCount := 0;
  Clear;
  CreateEntries(FRootRVData, AbsItemCount);
end;
{------------------------------------------------------------------------------}
{
  Creating data structure for fast conversion of (RVData,ItemNo) <-> AbsItemNo.
  Unuque AbsItemNo is assigned for each item in document. For tables, two
  AbsItemNo-s are assigned (one before the table content, one after).
}
procedure TRVSerializer.CreateEntries(RVData: TCustomRVData;
  var AbsItemNo: Integer);
var SubRVData: TCustomRVData;
    SubPos: TRVStoreSubRVData;
    Entry: TRVSerEntry;
    i: Integer;
begin
  Entry := TRVSerEntry.Create(RVData.GetSourceRVData);
  Entry.AbsFirstItemNo := AbsItemNo;
  Entry.IsFirst := True;
  Add(Entry);
  for i := 0 to RVData.ItemCount-1 do begin
    SubRVData := TCustomRVData(RVData.GetItem(i).GetSubRVData(SubPos, rvdFirst));
    if SubRVData<>nil then begin
      inc(AbsItemNo);
      while SubRVData<>nil do begin
        CreateEntries(SubRVData.GetRVData, AbsItemNo);
        SubRVData := TCustomRVData(RVData.GetItem(i).GetSubRVData(SubPos, rvdNext));
      end;
      SubPos.Free;
      Entry := TRVSerEntry.Create(RVData.GetSourceRVData);
      Entry.AbsFirstItemNo := AbsItemNo;
      Entry.FirstItemNo := i;
      Add(Entry);
    end;
    inc(AbsItemNo);
  end;
end;
{------------------------------------------------------------------------------}
{ Converting AbsItemNo to RV coordinates. AfterItem
  is valid only for tables }
procedure TRVSerializer.AbsoluteToRV(AbsItemNo: Integer;
  var RVData: TCustomRVData; var ItemNo: Integer; var AfterItem: Boolean);

  function GetEntryIndex(AbsItemNo: Integer): Integer;
  var i: Integer;
  begin
    for i := Count-1 downto 0 do
      if (TRVSerEntry(Items[i]).AbsFirstItemNo<=AbsItemNo) then begin
        Result := i;
        exit;
      end;
    raise ERichViewError.Create('AbsoluteToRV failed');
  end;

var EntryNo: Integer;
  Entry: TRVSerEntry;

begin
  EntryNo := -1;
  if (FCachedEntryNo<Count) and
     (TRVSerEntry(Items[FCachedEntryNo]).AbsFirstItemNo<=AbsItemNo) and
     ((FCachedEntryNo=Count-1) or
      (TRVSerEntry(Items[FCachedEntryNo+1]).AbsFirstItemNo>AbsItemNo)) then
    EntryNo := FCachedEntryNo
  else begin
    inc(FCachedEntryNo);
    if (FCachedEntryNo<Count) and
       (TRVSerEntry(Items[FCachedEntryNo]).AbsFirstItemNo<=AbsItemNo) and
       ((FCachedEntryNo=Count-1) or
         (TRVSerEntry(Items[FCachedEntryNo+1]).AbsFirstItemNo>AbsItemNo)) then
      EntryNo := FCachedEntryNo
  end;
  if EntryNo<0 then begin
    EntryNo := GetEntryIndex(AbsItemNo);
    FCachedEntryNo := EntryNo;
  end;
  Entry := TRVSerEntry(Items[EntryNo]);
  RVData := Entry.RVData;
  ItemNo := AbsItemNo - Entry.AbsFirstItemNo + Entry.FirstItemNo;
  AfterItem := not Entry.IsFirst and (AbsItemNo=Entry.AbsFirstItemNo);
end;
{------------------------------------------------------------------------------}
{ Converting RV coordinates to AbsItemNo. AfterItem
  is valid only for tables }
procedure TRVSerializer.RVToAbsolute(RVData: TCustomRVData;
  ItemNo: Integer; AfterItem: Boolean; var AbsItemNo: Integer);
var i: Integer;
    Entry: TRVSerEntry;
begin;
  RVData := RVData.GetSourceRVData;
  for i := Count-1 downto 0 do begin
    Entry := TRVSerEntry(Items[i]);
    if (RVData=Entry.RVData) and
      ((Entry.FirstItemNo<ItemNo) or
       ((Entry.FirstItemNo=ItemNo) and (AfterItem or Entry.IsFirst))) then begin
      AbsItemNo := ItemNo-Entry.FirstItemNo+Entry.AbsFirstItemNo;
      exit;
    end;
  end;
  AbsItemNo := -1;
  raise ERichViewError.Create('RVToAbsolute failed');
end;

end.
