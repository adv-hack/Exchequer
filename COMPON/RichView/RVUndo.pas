{*******************************************************}
{                                                       }
{       RichView                                        }
{       Undo/redo in TRichViewEdit.                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVUndo;
interface
{$I RV_Defs.inc}
uses SysUtils, Classes, RVClasses, RVItem, RVEdit, RVStyle, CRVData, CRVFData, RVRVData,
     RichView, RVTypes;
type
{
  Overview: TRVUndoList - list (TRVEditRVData.UndoList and RedoList) of
    a group of undo items (TRVUndoInfos). Each group is is undone and redone
    as one action.
    Undo group is a list of undo items. They have different
    types, all inherited from TRVUndoInfo.
}
  {
    Type of undo operation
  }
  TRVUndoAction = (rvuMisc, rvuDeleteItem,rvuDeleteItems,rvuDeleteSubstring,
                   rvuInsertItem,rvuInsertItems,rvuInsertSubstring,
                   rvuNewLine, rvuBR, rvuPara, rvuPageBreak, rvuTyping,
                   rvuTag, rvuStyleNo, rvuCheckpoint, rvuModifyItem,
                   rvuChangeText, rvuChangeVAlign, rvuChangeListMarker);

  TRVUndoList = class;

  {
    Basic class of undo item
  }
  TRVUndoInfo = class
    public
      Action: TRVUndoAction;  // type of elementary undo operation; maintained, but not used.
      FUndoList: TRVUndoList; // a reference to undo list containing this undo item
      constructor Create; virtual;
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; dynamic;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; dynamic;
      function RequiresFormat: Boolean; dynamic;
      function RequiresSuperFormat: Boolean; dynamic;
      function RequiresFormattedDocBefore: Boolean; dynamic;
      procedure Undo(RVData: TRichViewRVData); dynamic;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);dynamic;
      function ItemsAdded: Integer; dynamic;
      function GetUndoListOwnerRVData: TCustomRVFormattedData;
  end;

  TRVUndoInfoClass = class of TRVUndoInfo;

  {
    Basic class of elementary undo item for operations on the ItemNo-th item.
    Operation may affect a range of items ItemNo..LastAffectedItemNo
    (if LastAffectedItemNo<>-1)
  }
  TRVUndoItemNoInfo = class(TRVUndoInfo)
    public
      ItemNo, LastAffectedItemNo: Integer;
      constructor Create; override;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);override;
  end;
  {
    Fake undo item. Used to reformat a range of items after performing undo.
    (used for undo operation on paragraph numbering, affecting subsequent
    paragraphs)
  }
  TRVUndoReformateRange = class(TRVUndoItemNoInfo)
    public
      SuperReformat: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresSuperFormat: Boolean; override;
  end;
  {
    Undo changing VAlign of item
  }
  TRVUndoChangeVAlignInfo = class(TRVUndoItemNoInfo)
    public
      VAlign: TRVVAlign;
      procedure Undo(RVData: TRichViewRVData); override;
  end;
  {
    Undo resizing inserted controls
  }
  TRVUndoResizeInfo = class(TRVUndoItemNoInfo)
    private
      OldWidth: Integer;
    public
      Width, Height: Integer;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;
  {
    Basic undo operation on text of the ItemNo-th item
  }
  TRVUndoRawStringInfo = class(TRVUndoItemNoInfo)
    public
      s: TRVRawByteString;
  end;
  {
    Undo changing item text
  }
  TRVUndoChangeTextInfo = class(TRVUndoRawStringInfo)
    private
      OldWidth: Integer;
    public
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;
  {
    Basic undo operation on substring of text of the ItemNo-th item
  }
  TRVUndoSubStringInfo = class(TRVUndoRawStringInfo)
    public
      Index: Integer;
  end;
  {
    Basic undo operation on item
  }
  TRVUndoItemInfo = class(TRVUndoRawStringInfo)
    public
      Item: TCustomRVItemInfo;
      destructor Destroy; override;
  end;
  {
    Undo changing item (undoes operation replacing item's object)
  }
  TRVUndoReplaceItemInfo = class(TRVUndoItemInfo)
    public
      ItemNo: Integer;
      function RequiresFormat: Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoItemListInfo = class(TRVUndoInfo)
    public
      List: TRVItemList;
      constructor Create; override;
      destructor Destroy; override;
  end;

  TRVUndoItemRangeInfo = class(TRVUndoItemListInfo)
    public
      StartItemNo, LastAffectedItemNo: Integer;
      constructor Create; override;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);override;
  end;

  TRVUndoListInfo = class(TRVUndoInfo)
    public
      List: TRVIntegerList;
      constructor Create; override;
      destructor Destroy; override;
  end;

  TRVUndoParaListInfo = class(TRVUndoListInfo)
    private
      FR: Boolean;
    public
      StartItemNo: Integer;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);override;
  end;

  TRVUndoParaInfo = class(TRVUndoItemNoInfo)
    private
      FR: Boolean;
    public
      ParaNo, Count: Integer;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);override;
  end;

  TRVUndoStyleNoInfo = class(TRVUndoItemNoInfo)
    private
      OldWidth: Integer;
    public
      WasStyleNo: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVUndoAssociatedTextStyleNoInfo = class(TRVUndoStyleNoInfo)
    public
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoDeleteItemInfo = class(TRVUndoItemInfo)
    private
      FR: Boolean;
    public
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      function ItemsAdded: Integer; override;
  end;

  TRVUndoModifyItemInfo = class(TRVUndoItemInfo)
    public
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;


  TRVUndoNewLineInfo = class(TRVUndoItemNoInfo)
    private
      FR: Boolean;
    public
      WasSameAsPrev: Boolean;
      WasParaNo: Integer;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoBRInfo = class(TRVUndoItemNoInfo)
    public
      WasBR: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoPageBreakInfo = class(TRVUndoItemNoInfo)
    public
      WasPageBreak: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoClearTextFlowInfo = class(TRVUndoItemNoInfo)
    public
      WasClearLeft, WasClearRight: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoExtraIntProperty = class(TRVUndoItemNoInfo)
    private
      OldWidth: Integer;
    public
      OldValue: Integer;
      Prop: TRVExtraItemProperty;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVUndoExtraStrProperty = class(TRVUndoItemNoInfo)
    public
      OldValue: String;
      Prop: TRVExtraItemStrProperty;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFormat: Boolean; override;
  end;

  TRVUndoDeleteItemsInfo = class(TRVUndoItemRangeInfo)
    private
      EndItemNo: Integer;
      FR: Boolean;
    public
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      function ItemsAdded: Integer; override;
  end;

  TRVUndoDeleteSubstringInfo = class(TRVUndoSubStringInfo)
    private
      OldWidth: Integer;
    public
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVUndoInsertSubstringInfo = class(TRVUndoItemNoInfo)
    private
      OldWidth: Integer;
    public
      Index, Length: Integer;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVRedoTypingInfo = class(TRVUndoSubStringInfo)
    private
      OldWidth: Integer;
    public
      Unicode: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVUndoTypingInfo = class(TRVUndoInsertSubstringInfo)
    private
      OldWidth: Integer;
    public
      Unicode: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
  end;

  TRVUndoInsertItemsInfo = class(TRVUndoItemNoInfo)
    private
      FR: Boolean;
    public
      Count: Integer;
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      function ItemsAdded: Integer; override;
  end;

  TRVUndoInsertItemInfo = class(TRVUndoItemNoInfo)
    private
      FR: Boolean;
    public
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      function ItemsAdded: Integer; override;
  end;

  TRVUndoTagInfo = class(TRVUndoItemNoInfo)
    public
      WasTag: Integer;
      TagsArePChars: Boolean;
      function RequiresFormat: Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TRVUndoAddCPInfo = class(TRVUndoItemNoInfo)
    public
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoDeleteCPInfo = class(TRVUndoItemNoInfo)
    public
      Checkpoint: TRVCPInfo;
      TagsArePChars: Boolean;
      procedure Undo(RVData: TRichViewRVData); override;
      destructor Destroy; override;
  end;

  TRVUndoModifyItemProps = class(TRVUndoItemNoInfo)
    private
      OldW: Integer;
    public
      AffectWidth,AffectSize: Boolean;
      SubObject: TObject;
      function GetOppositeClass: TRVUndoInfoClass; virtual;
      function RequiresFormat: Boolean; override;
      function RequiresFullReformat1(RVData: TRichViewRVData): Boolean; override;
      function RequiresFullReformat2(RVData: TRichViewRVData): Boolean; override;
      procedure SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps); dynamic;
  end;

  TRVUndoModifyItemTerminator = class (TRVUndoModifyItemProps)
    public
      Opening: Boolean;
      constructor Create; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoModifyItemIntProperty = class(TRVUndoModifyItemProps)
    public
      PropertyName: String;
      Value: LongInt;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoModifyItemStrProperty = class(TRVUndoModifyItemProps)
    public
      PropertyName: String;
      Value: String;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVUndoModifyItemIntProperties = class(TRVUndoModifyItemProps)
    public
      PropList: TStringList;
      constructor Create; override;
      destructor Destroy; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;

  TRVCompositeUndo = class (TRVUndoInfo)
    public
      ItemNo: Integer;
      IsRedo: Boolean;
      UndoList: TRVUndoList;
      destructor Destroy; override;
      procedure Undo(RVData: TRichViewRVData); override;
      procedure SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);override;
      function RequiresFormat: Boolean; override;
      //!!procedure ChangeRVData(ARVData: TRichViewRVData; Restoring: Boolean); override;
  end;


  TRVUndoInfos = class (TRVList)
    private
      procedure PerformUndo(RVData: TRichViewRVData; Reformat: Boolean);
    public
      Caption: String;
      UndoType: TRVUndoType;
      CaretItemNo, CaretOffs: Integer;
      procedure Undo(RVData: TRichViewRVData; Reformat: Boolean);
      procedure Redo(RVData: TRichViewRVData; Reformat: Boolean);
      //!!procedure ChangeRVData(RVData: TRichViewRVData; Restoring: Boolean);
      function CanDelete: Boolean;
      procedure ChangeUndoList(UndoList: TRVUndoList);
  end;


  TRVUndoList = class (TRVList)
    private
      FReformatLock: Integer;
      procedure Pop;
    public
      FRVData: TCustomRVFormattedData;
      Limit: Integer;
      GroupModeCount: Integer;
      constructor Create(ARVData: TCustomRVFormattedData);
      procedure PopIfEmpty;
      function BeginItem(UndoType: TRVUndoType; const Caption: String; CaretItemNo, CaretOffs: Integer;
        Editor: TCustomRichViewEdit): Boolean;
      procedure EndItem; // optional
      procedure AddInfo(Info: TRVUndoInfo; Editor: TCustomRichViewEdit);
      procedure AddInfos(Infos: TRVUndoInfos; Editor: TCustomRichViewEdit);
      procedure AddTyping(CaretItemNo, CaretOffs: Integer; Unicode: Boolean; Editor: TCustomRichViewEdit);
      procedure AddUntyping(const c: TRVRawByteString; CaretItemNo, CaretOffs: Integer; Editor: TCustomRichViewEdit);
      procedure Undo(RVData: TRichViewRVData);
      procedure Redo(RVData: TRichViewRVData);
      function CurrentUndoType: TRVUndoType;
      function CurrentUndoCaption: String;
      procedure LockRFR;
      procedure UnlockRFR;
      procedure SetUndoGroupMode(GroupUndo: Boolean; Editor: TCustomRichViewEdit);
      //!!procedure ChangeRVData(ARVData: TRichViewRVData; Restoring: Boolean);
  end;

  TRVRedoList = class (TRVUndoList);

implementation

uses RVScroll, RVERVData,
     {$IFDEF RVDEBUGUNDO}TypInfo,{$ENDIF}
     RVStr;
{$IFDEF RVDEBUGUNDO}
const UNDO_FILE = '\undolog.txt';
procedure WriteLog(const s: String); forward;
function GetUndoDescrStr(rv: TCustomRichViewEdit; List: TRVUndoList): String; forward;
{$ENDIF}
{==============================================================================}
function NFR2(ItemNo, OldWidth: Integer; RVData: TRichViewRVData): Boolean;
var NewWidth: Integer;
begin
  NewWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  Result := (OldWidth<>NewWidth) and
            ((OldWidth>=RVData.DocumentWidth) or (NewWidth>RVData.DocumentWidth));
end;
{==============================================================================}
procedure FreeItem(item: TCustomRVItemInfo; RVData: TCustomRVData);
var s: TRVRawByteString;
begin
  if item=nil then exit;
  s := '';
  RVData.ItemAction(rviaDestroying, Item, s, nil);
  RVData.ControlAction(RVData, rvcaDestroyInUndoList, -1, item);
  if rvoTagsArePChars in RVData.Options then
    StrDispose(PChar(item.Tag));
  item.Tag := 0;
  if item.Checkpoint<>nil then begin
    if rvoTagsArePChars in RVData.Options then
      StrDispose(PChar(item.Checkpoint.Tag));
    item.Checkpoint.Tag := 0;
    item.Checkpoint.Free;
    item.Checkpoint     := nil;
  end;
  item.Free;
end;
{================================= TRVUndoList ================================}
constructor TRVUndoList.Create(ARVData: TCustomRVFormattedData);
begin
  inherited Create;
  FRVData := ARVData;
  Limit := -1;
end;
{------------------------------------------------------------------------------}
function TRVUndoList.BeginItem(UndoType: TRVUndoType; const Caption: String;
  CaretItemNo, CaretOffs: Integer; Editor: TCustomRichViewEdit): Boolean;
var Item: TRVUndoInfos;
    s: String;
begin
  if Limit=0 then begin
    Result := False;
    exit;
  end;

  Result := True;

  if (GroupModeCount>0) and (Count>0) and
     not (
     (TRVUndoInfos(Items[Count-1]).Count=1) and
     (TRVUndoInfo(TRVUndoInfos(Items[Count-1]).Items[0]).Action = rvuTyping)
     ) then begin
    {$IFDEF RVDEBUGUNDO}
    //WriteLog(Format('EXISTING undo list is used for %s(%s)', [GetEnumName(typeInfo(TRVUndoType), ord(UndoType)), Caption])+GetUndoDescrStr(Editor, Self));
    {$ENDIF}
    exit;
  end;

  if (Count=Limit) then
    Delete(0);

  s := Caption;
  if (Count>0) and (TRVUndoInfos(Items[Count-1]).Count=0) then begin
    CaretItemNo := TRVUndoInfos(Items[Count-1]).CaretItemNo;
    CaretOffs   := TRVUndoInfos(Items[Count-1]).CaretOffs;
    s           := TRVUndoInfos(Items[Count-1]).Caption;
    Delete(Count-1);
  end;
  Item := TRVUndoInfos.Create;
  Item.UndoType := UndoType;
  Item.Caption := s;
  Item.CaretItemNo := CaretItemNo;
  Item.CaretOffs := CaretOffs;
  Add(Item);
  {$IFDEF RVDEBUGUNDO}
  WriteLog(Format('NEW undo list %p created for %s(%s)', [Pointer(Item), GetEnumName(typeInfo(TRVUndoType), ord(UndoType)), Caption])+GetUndoDescrStr(Editor, Self));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.EndItem;
begin
  if (Count>0) and (TRVUndoInfos(Items[Count-1]).Count=0) then
    Delete(Count-1);
end;
{------------------------------------------------------------------------------}
function TRVUndoList.CurrentUndoType: TRVUndoType;
begin
  if Count=0 then
    Result := rvutNone
  else
    Result := TRVUndoInfos(Items[Count-1]).UndoType;
end;
{------------------------------------------------------------------------------}
function TRVUndoList.CurrentUndoCaption: String;
begin
  if Count=0 then
    Result := ''
  else
    Result := TRVUndoInfos(Items[Count-1]).Caption;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.AddTyping(CaretItemNo, CaretOffs: Integer; Unicode: Boolean;
  Editor: TCustomRichViewEdit);
var info: TRVUndoTypingInfo;
    infos: TRVUndoInfos;
    cancombine: Boolean;
begin
  if Limit=0 then exit;
  if (Count>0) and (TRVUndoInfos(Items[Count-1]).Count=0) then
    Delete(Count-1);
  cancombine := False;
  if (Count>0) then begin
    infos := TRVUndoInfos(Items[Count-1]);
    if (infos.Count>0) and (TRVUndoInfo(infos.Items[0]) is TRVUndoTypingInfo) then begin
      info := TRVUndoTypingInfo(infos.Items[0]);
      if (info.ItemNo = CaretItemNo) and (info.Index+info.Length = CaretOffs) then begin
        inc(info.Length);
        inc(infos.CaretOffs);
        cancombine := True;
      end;
    end;
  end;
  if not cancombine then begin
    BeginItem(rvutTyping,'',CaretItemNo,CaretOffs, Editor);
    info := TRVUndoTypingInfo.Create;
    info.Action := rvuTyping;
    info.ItemNo := CaretItemNo;
    info.Index  := CaretOffs;
    info.Length := 1;
    info.Unicode := Unicode;
    AddInfo(info, Editor);
  end;
  {$IFDEF RVDEBUGUNDO}
  WriteLog(' + typing'+GetUndoDescrStr(Editor, Self));
  {$ENDIF}  
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.AddUntyping(const c: TRVRawByteString; CaretItemNo, CaretOffs: Integer;
  Editor: TCustomRichViewEdit);
var info: TRVRedoTypingInfo;
    infos: TRVUndoInfos;
    unicode, cancombine: Boolean;
    Len: Integer;
begin
  Unicode := Length(c)>1;
  if (Count>0) and (TRVUndoInfos(Items[Count-1]).Count=0) then
    Delete(Count-1);
  cancombine := False;
  if (Count>0) then begin
    infos := TRVUndoInfos(Items[Count-1]);
    if (infos.Count>0) and (TRVUndoInfo(infos.Items[0]) is TRVRedoTypingInfo) then begin
      info := TRVRedoTypingInfo(infos.Items[0]);
      Len := Length(info.s);
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode then begin
        RVCheckUni(Len);
        Len := Len div 2;
      end;
      {$ENDIF}
      if (info.ItemNo = CaretItemNo) and (info.Index-Len = CaretOffs) then begin
        info.s := info.s+c;
        dec(infos.CaretOffs);
        cancombine := True;
      end;
    end;
  end;
  if not cancombine then begin
    BeginItem(rvutTyping,'',CaretItemNo,CaretOffs, Editor);
    info := TRVRedoTypingInfo.Create;
    info.Action := rvuTyping;
    info.ItemNo := CaretItemNo;
    info.Index  := CaretOffs;
    info.s      := c;
    info.Unicode := Unicode;
    AddInfo(info, Editor);
  end;
  {$IFDEF RVDEBUGUNDO}
  WriteLog(' + untyping'+GetUndoDescrStr(Editor, Self));
  {$ENDIF}  
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.AddInfo(Info: TRVUndoInfo; Editor: TCustomRichViewEdit);
var infos: TRVUndoInfos;
begin
  if Count=0 then
    raise ERichViewError.Create(errRVUndoEmpty);
  infos := TRVUndoInfos(Items[Count-1]);
  if (infos.Count=1) and (TRVUndoInfo(infos.Items[0]).Action = rvuTyping) then begin
    {$IFDEF RVDEBUGUNDO}
    WriteLog(Format('INCORRECT !!! + undo info %s in %p', [Info.ClassName, Pointer(Infos)])+GetUndoDescrStr(Editor, Self));
    {$ENDIF}
    raise ERichViewError.Create(errRVUndoAdd);
  end;
  Info.FUndoList := Self;
  infos.Add(Info);
  {$IFDEF RVDEBUGUNDO}
  WriteLog(Format('+ undo info %s in %p. Count in list = %d ', [Info.ClassName, Pointer(Infos), Infos.Count])+GetUndoDescrStr(Editor, Self));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.AddInfos(Infos: TRVUndoInfos; Editor: TCustomRichViewEdit);
begin
  Add(Infos);
  Infos.ChangeUndoList(Self);
  {$IFDEF RVDEBUGUNDO}
  WriteLog(Format('NEW undo info list: %p ', [Pointer(Infos)])+GetUndoDescrStr(Editor, Self));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.PopIfEmpty;
var infos: TRVUndoInfos;
begin
  if (Count=0) or (GroupModeCount>0) then exit;
  infos := TRVUndoInfos(Items[Count-1]);
  if infos.Count=0 then
    Delete(Count-1);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.Pop;
var infos: TRVUndoInfos;
begin
  infos := TRVUndoInfos(Items[Count-1]);
  if infos.CanDelete then
    Delete(Count-1)
  else
    if TRVUndoInfo(infos.Items[0]) is TRVUndoTypingInfo then
      dec(infos.CaretOffs)
    else //TRVRedoTypingInfo
      inc(infos.CaretOffs)
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.Undo(RVData: TRichViewRVData);

begin
  if Count=0 then
    raise ERichViewError.Create(errRVUndoEmptyBuffer);
  TRVUndoInfos(Items[Count-1]).Undo(RVData, FReformatLock<=0);
  Pop;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.Redo(RVData: TRichViewRVData);
begin
  if Count=0 then
    raise ERichViewError.Create(errRVUndoEmptyBuffer);
  TRVUndoInfos(Items[Count-1]).Redo(RVData, FReformatLock<=0);
  Pop;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.LockRFR;
begin
  inc(FReformatLock);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.UnlockRFR;
begin
  dec(FReformatLock);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoList.SetUndoGroupMode(GroupUndo: Boolean; Editor: TCustomRichViewEdit);
begin
  if GroupUndo then
    inc(GroupModeCount)
  else
    dec(GroupModeCount);
  {$IFDEF RVDEBUGUNDO}
  if GroupUndo then
    WriteLog('UNDO GROUPMODE ON , Counter='+IntToStr(GroupModeCount)+GetUndoDescrStr(Editor, Self))
  else
    WriteLog('UNDO GROUPMODE OFF, Counter='+IntToStr(GroupModeCount)+GetUndoDescrStr(Editor, Self));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{
procedure TRVUndoList.ChangeRVData(ARVData: TRichViewRVData;
  Restoring: Boolean);
var i: Integer;
begin
  for i := 0 to Count-1 do
    TRVUndoInfos(Items[i]).ChangeRVData(ARVData, Restoring);
end;
//!!
}
{=============================== TRVUndoInfos =================================}
function TRVUndoInfos.CanDelete: Boolean;
begin
  Result := True;
  if Count=0 then exit;
  if TRVUndoInfo(Items[0]) is TRVUndoTypingInfo then
    Result := TRVUndoTypingInfo(Items[0]).Length=0
  else if TRVUndoInfo(Items[0]) is TRVRedoTypingInfo then
    Result := Length(TRVRedoTypingInfo(Items[0]).s)=0
  else if TRVUndoInfo(Items[0]) is TRVCompositeUndo then
    Result := TRVCompositeUndo(Items[0]).UndoList.Count=0;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfos.ChangeUndoList(UndoList: TRVUndoList);
var i: Integer;
begin
  for i := 0 to Count-1 do
    TRVUndoInfo(Items[i]).FUndoList := UndoList;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfos.PerformUndo(RVData: TRichViewRVData; Reformat: Boolean);
var i, ItemsAdded,ItemsAdded1, StartItemNo, EndItemNo, StartDItemNo, EndDItemNo,
    StartItemNo1, EndItemNo1, TerminatorCount,TerminatorW: Integer;
    RF, RFR, SRF: Boolean;
    ui: TRVUndoInfo;
begin
   if Count=0 then exit;

   RVData.Deselect(nil, True);
   StartItemNo := RVData.Items.Count-1;
   EndItemNo    := 0;
   ItemsAdded := 0;
   RFR        := False;
   RF         := False;
   SRF        := False;
   for i := Count-1 downto 0 do begin
     ui := TRVUndoInfo(Items[i]);
     RF := RF or ui.RequiresFormat;
     SRF := SRF or ui.RequiresSuperFormat;
     ui.SetItemsRange(StartItemNo1, EndItemNo1, RVData);
     {
     if ItemsAdded<0 then
       inc(StartItem1,ItemsAdded);
     }
     if ItemsAdded>0 then
       inc(EndItemNo1,ItemsAdded);
     ItemsAdded1 := ui.ItemsAdded;
     if ItemsAdded1>0 then
       inc(EndItemNo1, ItemsAdded1);
     inc(ItemsAdded,ItemsAdded1);
     if StartItemNo1<StartItemNo then
       StartItemNo := StartItemNo1;
     if EndItemNo1>EndItemNo then
       EndItemNo := EndItemNo1;
   end;

   if EndItemNo<StartItemNo then begin
     StartItemNo1 := StartItemNo;
     StartItemNo := EndItemNo;
     EndItemNo   := StartItemNo1;
   end;
   if StartItemNo<0 then
     StartItemNo := 0;
   if EndItemNo<StartItemNo then
     EndItemNo := StartItemNo;
   if EndItemNo+ItemsAdded<StartItemNo then
     EndItemNo := StartItemNo-ItemsAdded;
   if EndItemNo>=RVData.Items.Count then
     EndItemNo := RVData.Items.Count-1;
   RVData.Item2DrawItem(StartItemNo, 1, StartDItemNo, StartItemNo1, rvdpBetterBelow);
   RVData.Item2DrawItem(EndItemNo,   1, EndDItemNo, EndItemNo1, rvdpBetterBelow);
   if StartDItemNo=-1 then
     StartDItemNo := 0;
   if EndDItemNo=-1 then
     EndDItemNo := RVData.DrawItems.Count-1;
   RVData.GetParaBoundsEx(StartDItemNo,EndDItemNo, StartDItemNo, EndDItemNo, True);
   TerminatorCount := 0;
   TerminatorW     := 0;
   for i := Count-1 downto 0 do begin
     ui := TRVUndoInfo(Items[i]);
     if TerminatorCount=0 then
       RFR := RF and (RFR or ui.RequiresFullReformat1(RVData));
     if ui is TRVUndoModifyItemTerminator then begin
       if not TRVUndoModifyItemTerminator(ui).Opening then begin
         if TerminatorCount=0 then
           TerminatorW := TRVUndoModifyItemTerminator(ui).OldW;
         inc(TerminatorCount);
         end
       else begin
         dec(TerminatorCount);
         if TerminatorCount=0 then
           TRVUndoModifyItemTerminator(ui).OldW := TerminatorW;
       end;
     end;
     if ui.RequiresFormattedDocBefore then begin
       RVData.Format(False);
       RF := False;
     end;
     ui.Undo(RVData);
     if TerminatorCount=0 then
       RFR := RF and (RFR or ui.RequiresFullReformat2(RVData));
   end;
   {$IFNDEF RVDONOTUSELIVESPELL}
   RVData.AdjustInItemsRange(StartItemNo);
   RVData.AdjustInItemsRange(EndItemNo);
   RVData.ExpandToParaSection(StartItemNo, EndItemNo, StartItemNo, EndItemNo);
   for i := StartItemNo to EndItemNo do
     RVData.GetItem(i).ClearLiveSpellingResult;
   (RVData as TRVEditRVData).LaterSetBackLiveSpellingTo(StartItemNo, 0, False);
   {$ENDIF}
   if Reformat and RF then
     if RFR and (RVData.DocumentWidth<>RVData.CalculateMinDocWidthPlus(0,nil,nil)) then
       RVData.Format(False)
     else
       RVData.FormatParas(StartDItemNo, EndDItemNo, ItemsAdded);
   if TCustomRichView(RVData.RichView).InplaceEditor=nil then
     RVData.DoSetSelectionBounds(CaretItemNo,CaretOffs,CaretItemNo,CaretOffs);
   RVData.Invalidate;
   if SRF then
     (RVData.GetAbsoluteRootData as TRichViewRVData).Format_(True, True, True, 0, nil,
       False, True, False, False);
   if RVData is TRVEditRVData then
     TRVEditRVData(RVData).DoAfterFormatAndCaretPositioning(True);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfos.Redo(RVData: TRichViewRVData; Reformat: Boolean);
begin
   TRVEditRVData(RVData).BeginNamedUndoSequence(UndoType, Caption, True);
   PerformUndo(RVData, Reformat);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfos.Undo(RVData: TRichViewRVData; Reformat: Boolean);
begin
   TRVEditRVData(RVData).BeginRedoSequence(UndoType, Caption);
   PerformUndo(RVData, Reformat);
end;
{=============================== TRVUndoInfo ==================================}
constructor TRVUndoInfo.Create;
begin
  inherited Create;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfo.Undo(RVData: TRichViewRVData);
begin

end;
{------------------------------------------------------------------------------}
procedure TRVUndoInfo.SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);
begin
  // empty
end;
{------------------------------------------------------------------------------}
{
procedure TRVUndoInfo.ChangeRVData(ARVData: TRichViewRVData; Restoring: Boolean);
begin
  // empty
end;
//!!
}
{------------------------------------------------------------------------------}
function TRVUndoInfo.RequiresFullReformat1(RVData: TRichViewRVData): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.RequiresFormat: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.RequiresSuperFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.RequiresFormattedDocBefore: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.RequiresFullReformat2(RVData: TRichViewRVData): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.ItemsAdded: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVUndoInfo.GetUndoListOwnerRVData: TCustomRVFormattedData;
begin
  Result := FUndoList.FRVData;
end;
{================================ TRVUndoItemNoInfo ===========================}
constructor TRVUndoItemNoInfo.Create;
begin
  inherited Create;
  LastAffectedItemNo := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoItemNoInfo.SetItemsRange(var StartItem, EndItem: Integer; RVData: TRichViewRVData);
begin
  if ItemNo>=0 then begin
    StartItem := ItemNo;
    if LastAffectedItemNo>=0 then
      EndItem := LastAffectedItemNo
    else
      EndItem := ItemNo;
  end;
end;
{=============================== TRVUndoItemListInfo ==========================}
constructor TRVUndoItemListInfo.Create;
begin
  inherited Create;
  List := TRVItemList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVUndoItemListInfo.Destroy;
var i: Integer;
begin
  for i := 0 to List.Count-1 do
    FreeItem(List.Objects[i], GetUndoListOwnerRVData);
  List.Free;
  inherited Destroy;
end;
{========================== TRVUndoItemRangeInfo ==============================}
constructor TRVUndoItemRangeInfo.Create;
begin
  inherited Create;
  LastAffectedItemNo := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoItemRangeInfo.SetItemsRange(var StartItem,
  EndItem: Integer; RVData: TRichViewRVData);
begin
  StartItem := StartItemNo;
  if LastAffectedItemNo=-1 then
    EndItem := StartItemNo+List.Count
  else
    EndItem := LastAffectedItemNo;
end;
{============================== TRVUndoItemInfo ===============================}
destructor TRVUndoItemInfo.Destroy;
begin
  FreeItem(Item, GetUndoListOwnerRVData);
  inherited Destroy;
end;
{================================== TRVUndoDeleteItem =========================}
function TRVUndoDeleteItemInfo.ItemsAdded: Integer;
begin
  Result := +1;
end;
{------------------------------------------------------------------------------}
function TRVUndoDeleteItemInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result :=  FR or
            (RVData.CalculateMinItemWidthPlusEx(ItemNo)>
             RVData.DocumentWidth);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoDeleteItemInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_InsertItem(ItemNo,s,Item, True, FR);
  Item := nil;
end;
{================================= TRVUndoDeleteItems =========================}
function TRVUndoDeleteItemsInfo.ItemsAdded: Integer;
begin
  Result := +List.Count;
end;
{------------------------------------------------------------------------------}
function TRVUndoDeleteItemsInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := FR or
            (RVData.CalculateMinItemsWidthPlusEx(StartItemNo, EndItemNo)>RVData.DocumentWidth);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoDeleteItemsInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_InsertItems(StartItemNo,List,True,FR);
  EndItemNo := StartItemNo+List.Count-1;
  List.Clear;
end;
{=========================== TRVUndoDeleteSubstring ===========================}
function TRVUndoDeleteSubstringInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoDeleteSubstringInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_InsertSubstring(ItemNo, Index, s);
end;
{============================ TRVUndoInsertItem ===============================}
function TRVUndoInsertItemInfo.ItemsAdded: Integer;
begin
  Result := -1;
end;
{------------------------------------------------------------------------------}
function TRVUndoInsertItemInfo.RequiresFullReformat1(
  RVData: TRichViewRVData): Boolean;
begin
 Result := RVData.CalculateMinItemWidthPlusEx(ItemNo)>=
           RVData.DocumentWidth;
end;
{------------------------------------------------------------------------------}
function TRVUndoInsertItemInfo.RequiresFullReformat2(RVData: TRichViewRVData): Boolean;
begin
 Result := FR;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInsertItemInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_DeleteItem(ItemNo, FR);
end;
{============================ TRVUndoInsertSubstring ==========================}
function TRVUndoInsertSubstringInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInsertSubstringInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_DeleteSubstring(ItemNo, Index, Length);
end;
{========================= TRVUndoInsertItems =================================}
function TRVUndoInsertItemsInfo.ItemsAdded: Integer;
begin
  Result := -Count;
end;
{------------------------------------------------------------------------------}
function TRVUndoInsertItemsInfo.RequiresFullReformat1(
  RVData: TRichViewRVData): Boolean;
begin
  Result := RVData.CalculateMinItemsWidthPlusEx(ItemNo,ItemNo+Count-1)>=RVData.DocumentWidth;
end;
{------------------------------------------------------------------------------}
function TRVUndoInsertItemsInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := FR;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoInsertItemsInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_DeleteItems(ItemNo,ItemNo+Count-1,FR);
end;
{============================== TRVUndoNewLine ================================}
function TRVUndoNewLineInfo.RequiresFullReformat2(RVData: TRichViewRVData): Boolean;
begin
  Result := FR;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoNewLineInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_NewLine(ItemNo, WasSameAsPrev, WasParaNo, FR);
end;
{=============================== TRVUndoBR ====================================}
procedure TRVUndoBRInfo.Undo(RVData: TRichViewRVData);
var FR: Boolean;
begin
  TRVEditRVData(RVData).Do_BR(ItemNo, WasBR, FR);
end;
{========================== TRVUndoPageBreakInfo ==============================}
procedure TRVUndoPageBreakInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_PageBreak(ItemNo, WasPageBreak);
end;
{========================== TRVUndoClearTextFlowInfo ==========================}
procedure TRVUndoClearTextFlowInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ClearTextFlow(ItemNo, WasClearLeft, WasClearRight);
end;
{========================= TRVUndoExtraIntProperty ============================}
function TRVUndoExtraIntProperty.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoExtraIntProperty.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_ExtraIntProperty(ItemNo, Prop, OldValue);
end;
{========================== TRVUndoExtraStrProperty ============================}
function TRVUndoExtraStrProperty.RequiresFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoExtraStrProperty.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ExtraStrProperty(ItemNo, Prop, OldValue);
end;
{============================= TRVUndoListInfo ================================}
constructor TRVUndoListInfo.Create;
begin
  inherited Create;
  List := TRVIntegerList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVUndoListInfo.Destroy;
begin
  List.Free;
  inherited Destroy;
end;
{============================ TRVUndoParaListInfo =============================}
function TRVUndoParaListInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := FR;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoParaListInfo.SetItemsRange(var StartItem, EndItem: Integer;
                                            RVData: TRichViewRVData);
begin
  StartItem := StartItemNo;
  EndItem := StartItem+List.Count;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoParaListInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ParaList(StartItemNo, List, FR);
end;
{============================== TRVUndoParaInfo ===============================}
function TRVUndoParaInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := FR;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoParaInfo.SetItemsRange(var StartItem, EndItem: Integer;
                                        RVData: TRichViewRVData);
begin
  StartItem := ItemNo;
  EndItem := StartItem+Count;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoParaInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_Para(ItemNo, ItemNo+Count-1, ParaNo, FR);
end;
{============================ TRVUndoTypingInfo ===============================}
function TRVUndoTypingInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoTypingInfo.Undo(RVData: TRichViewRVData);
var s: TRVRawByteString;
    c: TRVRawByteString;
    idx: Integer;
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  s := RVData.Items[ItemNo];
  {$IFNDEF RVDONOTUSEUNICODE}
  if Unicode then begin
    RVCheckUni(System.Length(s));
    idx := (Index+Length-2)*2+1;
    c := s[idx]+s[idx+1];
    Delete(s, idx, 2);
    end
  else
  {$ENDIF}
  begin
    idx := Index+Length-1;
    c := s[idx];
    Delete(s, idx, 1);
  end;
  dec(Length);
  RVData.Items[ItemNo] := s;
  TRVEditRVData(RVData).RedoList.AddUntyping(c, ItemNo, Index+Length+1, TCustomRichViewEdit(RVData.RichView));
end;
{=========================== TRVRedoTypingInfo ================================}
function TRVRedoTypingInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVRedoTypingInfo.Undo(RVData: TRichViewRVData);
var str: TRVRawByteString;
    l: Integer;
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  str := RVData.Items[ItemNo];
  {$IFNDEF RVDONOTUSEUNICODE}
  if Unicode then begin
    RVCheckUni(Length(s));
    RVCheckUni(Length(str));
    l := Length(s);
    Insert(s[l-1]+s[l], str, (Index-1)*2-l+1);
    s := Copy(s,1,l-2);
    l := l div 2;
    end
  else
  {$ENDIF}
  begin
    l := Length(s);
    Insert(TRVRawByteString(s[l]), str, Index-l);
    s := Copy(s,1,l-1);
  end;
  RVData.Items[ItemNo] := str;
  TRVEditRVData(RVData).UndoList.AddTyping(ItemNo, Index-l, Unicode, TCustomRichViewEdit(RVData.RichView));
end;
{============================= TRVUndoTagInfo =================================}
destructor TRVUndoTagInfo.Destroy;
begin
  if TagsArePChars then
    StrDispose(PChar(WasTag));
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVUndoTagInfo.RequiresFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoTagInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_Tag(ItemNo, WasTag, False);
end;
{============================ TRVUndoStyleNoInfo ==============================}
function TRVUndoStyleNoInfo.RequiresFullReformat2(RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoStyleNoInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_StyleNo(ItemNo, WasStyleNo);
end;
{==================== TRVUndoAssociatedTextStyleNoInfo ========================}
procedure TRVUndoAssociatedTextStyleNoInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_AssociatedTextStyleNo(ItemNo, WasStyleNo);
end;
{============================== TRVUndoAddCPInfo ==============================}
procedure TRVUndoAddCPInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_DeleteCP(ItemNo);
end;
{============================= TRVUndoDeleteCPInfo ============================}
destructor TRVUndoDeleteCPInfo.Destroy;
begin
  if Checkpoint<>nil then begin
    if TagsArePChars then
      StrDispose(PChar(Checkpoint.Tag));
    Checkpoint.Tag := 0;
    Checkpoint.Free;
  end;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoDeleteCPInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_AddCP(ItemNo, Checkpoint);
  Checkpoint := nil;
end;
{============================ TRVUndoModifyItemInfo ===========================}
function TRVUndoModifyItemInfo.RequiresFullReformat1(RVData: TRichViewRVData): Boolean;
var Item1: TCustomRVItemInfo;
    w1,w2: Integer;
begin
  Item1 := RVData.GetItem(ItemNo);
  w2 := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  w1 := w2-Item1.GetMinWidth(nil,nil,RVData)+Item.GetMinWidth(nil,nil,RVData);
  Result := (w1<>w2) and
            ((w1>RVData.DocumentWidth) or (w2>=RVData.DocumentWidth));
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyItemInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ModifyItem(ItemNo, s, Item);
  Item := nil;
end;
{========================== TRVUndoChangeTextInfo =============================}
function TRVUndoChangeTextInfo.RequiresFullReformat2(RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoChangeTextInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_ChangeTextR(ItemNo, s);
end;
{===================== TRVUndoChangeVAlignInfo ================================}
procedure TRVUndoChangeVAlignInfo.Undo(RVData: TRichViewRVData);
begin
   TRVEditRVData(RVData).Do_ChangeVAlign(ItemNo, VAlign);
end;
{============================ TRVUndoResizeInfo ===============================}
function TRVUndoResizeInfo.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
begin
  Result := NFR2(ItemNo, OldWidth, RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoResizeInfo.Undo(RVData: TRichViewRVData);
begin
  OldWidth := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  TRVEditRVData(RVData).Do_Resize(ItemNo, Width, Height, False);
end;
{======================= TRVUndoModifyItemProps ===============================}
function TRVUndoModifyItemProps.GetOppositeClass: TRVUndoInfoClass;
begin
  Result := TRVUndoInfoClass(ClassType);
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyItemProps.SetOppositeUndoInfoProps(UndoInfo: TRVUndoModifyItemProps);
begin
  // empty
end;
{------------------------------------------------------------------------------}
function TRVUndoModifyItemProps.RequiresFormat: Boolean;
begin
  Result := AffectSize;
end;
{------------------------------------------------------------------------------}
function TRVUndoModifyItemProps.RequiresFullReformat1(
  RVData: TRichViewRVData): Boolean;
begin
  Result := AffectSize and AffectWidth;
  if not Result then
    exit;
  OldW := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  Result := OldW >= RVData.DocumentWidth;
end;
{------------------------------------------------------------------------------}
function TRVUndoModifyItemProps.RequiresFullReformat2(
  RVData: TRichViewRVData): Boolean;
var NewW: Integer;
begin
  Result := AffectSize and AffectWidth;
  if not Result then
    exit;
  NewW := RVData.CalculateMinItemWidthPlusEx(ItemNo);
  Result :=  (NewW<>OldW) and (NewW>RVData.DocumentWidth);
end;
{========================== TRVUndoModifyItemIntProperty ======================}
procedure TRVUndoModifyItemIntProperty.Undo(RVData: TRichViewRVData);
begin
  SetOppositeUndoInfoProps(
    TRVEditRVData(RVData).Do_ModifyItemIntProperty(ItemNo, SubObject,
      PropertyName, Value, AffectSize, AffectWidth, GetOppositeClass));
end;
{========================== TRVUndoModifyItemStrProperty ======================}
procedure TRVUndoModifyItemStrProperty.Undo(RVData: TRichViewRVData);
begin
  SetOppositeUndoInfoProps(
    TRVEditRVData(RVData).Do_ModifyItemStrProperty(ItemNo, SubObject,
      PropertyName, Value, GetOppositeClass));
end;
{============================ TRVUndoModifyItemIntProperties ==================}
constructor TRVUndoModifyItemIntProperties.Create;
begin
  inherited Create;
  PropList := TStringList.Create;
end;
{------------------------------------------------------------------------------}
destructor TRVUndoModifyItemIntProperties.Destroy;
begin
  PropList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyItemIntProperties.Undo(RVData: TRichViewRVData);
begin
  SetOppositeUndoInfoProps(TRVEditRVData(RVData).Do_ModifyItemIntProperties(ItemNo, SubObject, PropList,
      AffectSize, AffectWidth, GetOppositeClass));
end;

{================================ TRVUndoModifyItemTerminator =================}
constructor TRVUndoModifyItemTerminator.Create;
begin
  inherited Create;
  AffectWidth := True;
  AffectSize := True;
  Action     := rvuModifyItem;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoModifyItemTerminator.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ItemModifyTerminator(ItemNo, not Opening);
end;
{============================== TRVCompositeUndo ==============================}
destructor TRVCompositeUndo.Destroy;
begin
  UndoList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TRVCompositeUndo.RequiresFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVCompositeUndo.SetItemsRange(var StartItem, EndItem: Integer;
  RVData: TRichViewRVData);
begin
  StartItem := ItemNo;
  EndItem   := ItemNo;
end;
{------------------------------------------------------------------------------}
procedure TRVCompositeUndo.Undo(RVData: TRichViewRVData);
begin
  UndoList.Undo(RVData);
end;
{===================== TRVUndoReplaceItemInfo =================================}
function TRVUndoReplaceItemInfo.RequiresFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoReplaceItemInfo.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ReplaceItem(ItemNo, item);
  item := nil;
end;

{============================= TRVUndoReformateRange ==========================}
function TRVUndoReformateRange.RequiresSuperFormat: Boolean;
begin
  Result := SuperReformat;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoReformateRange.Undo(RVData: TRichViewRVData);
begin
  TRVEditRVData(RVData).Do_ReformateRange(ItemNo, LastAffectedItemNo, SuperReformat);
end;

{$IFDEF RVDEBUGUNDO}
function GetUndoDescrStr(rv: TCustomRichViewEdit; List: TRVUndoList): String;
begin
  if rv<>nil then
    Result := Format('[Edit: %p(%s,class=%s), RootEdit: %p(%s)]',
      [Pointer(rv), rv.Name, rv.ClassName, Pointer(rv.RootEditor),
       rv.RootEditor.Name])
  else
    Result := '[Edit: NIL]';
  Result := Result+Format('[Undo List=%p(%s)]',[Pointer(List),List.ClassName]);
end;

procedure WriteLog(const s: String);
var F: TextFile;
begin
  AssignFile(F, UNDO_FILE);
  Append(F);
  Writeln(F, s);
  CloseFile(F);
end;

procedure ClearLog;
var F: TextFile;
begin
  AssignFile(F, UNDO_FILE);
  Rewrite(F);
  CloseFile(F);
end;

initialization
  ClearLog;
{$ENDIF}


end.
