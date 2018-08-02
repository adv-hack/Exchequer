
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRichViewRVData represents RichViewEdit         }
{       document.                                       }
{       This is a type of TRichViewEdit.RVData.         }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVERVData;

{$I RV_Defs.inc}
interface
uses SysUtils, Windows, Graphics, Classes, Controls, Forms,
     CRVData, CRVFData, RVRVData, RVItem, RVUndo, RVBack,
     DLines, RVFuncs, RVEdit, RVUni,
     RVScroll, RichView, RVStyle, ComCtrls, TypInfo, RVClasses,
     RVRTFProps, RVResize,
     {$IFNDEF RVDONOTUSEDRAGDROP}
     ActiveX, RVDragDrop,
     {$ENDIF}
     RVRTFErr, RVTypes;

type
  TRVCharPos = class (TCollectionItem)
    public
      X, DrawItemNo, Offset, MoveRightTo: Integer;
      constructor Create(Owner: TCollection); override;
      procedure Assign(Source: TPersistent); override;
  end;

  TRVCharPosCollection = class (TCollection)
    private
      function GetItem(Index: Integer): TRVCharPos;
      procedure SetItem(Index: Integer; const Value: TRVCharPos);
    public
      property Items[Index: Integer]: TRVCharPos read GetItem write SetItem;
  end;

  TRVParaListOperation = (rvplopChange, rvplopRemove, rvplopLevel);

  TRVUndoDest = (udNone, udUndo, udRedo);

  TRVEditRVData = class (TRichViewRVData)
    private
      FPrevTextStyleNo: Integer;
      FCurTag: Integer;
      FResizer: TRVItemResizer;
      ResizingControl: TControl;
      FCustomCaretActive: Boolean;
      FCustomCaretRect: TRect;
      FCustomCaretOldPos: TPoint;
      FCustomCaretBack: TBitmap;
      FUpDownMovingX: Integer;
      FOnFormat: TNotifyEvent;
      function InsSomething(var info: TCustomRVItemInfo; var s, SplitText: TRVRawByteString;
        AutoTag, CallTEEvent: Boolean; var InsertPoint, ItemsAdded: Integer;
        var FullReformat: Boolean; var NewListNo: Integer;
        NoNewLineReset: Boolean): Boolean;
      function InsEmptyString(Index, Tag, ParaStyle, FontStyle: Integer;
        SameAsPrev, BR: Boolean):TCustomRVItemInfo;
      function InsString(s: TRVRawByteString; Index, Tag, ParaStyle, FontStyle: Integer;
        SameAsPrev, BR: Boolean; var FullReformat: Boolean): TCustomRVItemInfo;
      function InsString2(s: TRVRawByteString; Index, Tag: Integer;
        Source: TCustomRVItemInfo; SameAsPrev, BR: Boolean;
        var FullReformat: Boolean): TCustomRVItemInfo;
      function CreateTextItem(Tag, ParaStyle, FontStyle: Integer;
        SameAsPrev, BR: Boolean): TCustomRVItemInfo;
      function CreateTextItem2(Tag: Integer; Source: TCustomRVItemInfo;
        SameAsPrev, BR: Boolean): TCustomRVItemInfo;
      procedure InsertString(var s, SplitText: TRVRawByteString; StyleNo: Integer; AutoTag,
        CaretBefore: Boolean);
      procedure DoResizeControl(ItemNo, OldWidth, OldHeight,
        NewWidth, NewHeight: Integer);

      function GetLastParaItemEx(ItemNo: Integer): Integer;
      function SetParaStyle(StartItemNo,EndItemNo, ParaNo: Integer;
        var FullReformat: Boolean): Boolean;
      procedure AfterAddingText(const SplitText: TRVRawByteString;
        StartItemNo,EndItemNo, ItemsAdded, DIStartNo, DIEndNo: Integer;
        FullReformat, CaretBefore: Boolean);
      function ItemHasPersistentCheckpoint(ItemNo: Integer): Boolean;
      function ParaHasPersistentCheckpoint(ItemNo: Integer): Boolean;
      function MovePersistentCheckpoint(ItemNo: Integer;
        OnlyToPrev: Boolean): Boolean;
      procedure ClearCurTag;
      function GetOneSelectedItemNo: Integer;
      function InsertItemFromTextFile(var s, SplitText: TRVRawByteString;
        item: TCustomRVItemInfo; AutoTag, BR: Boolean;
        var FirstIP, InsertPoint, ItemsAdded, MarkerItemNo: Integer;
        var FirstItem, PageBreak, FromNewLine, FullReformat: Boolean): Boolean;
      function DoItemTextEdit(const OldText: TRVRawByteString; ItemNo: Integer): Boolean;
      function DoItemTextEditEx(const OldText: TRVRawByteString; ItemNo: Integer;
        UndoType: TRVUndoType): Boolean;
    protected
      procedure Formatted(FirstItemNo, LastItemNo: Integer; Partial: Boolean); override;    
      procedure DeselectPartiallySelectedItem(
        NewPartiallySelected: TCustomRVItemInfo); override;
      procedure SetPartialSelectedItem(Item: TCustomRVItemInfo); override;
      procedure AfterDeleteStyles(Data: TRVDeleteUnusedStylesData); override;
      {$IFNDEF RVDONOTUSELISTS}
      function ReplicateMarker(ReferenceItemNo, InsertItemNo: Integer;
        var FullReformat: Boolean; EditFlag, OnlyIfNotHidden: Boolean): Boolean;
      procedure AdjustMarkerCaret(Right: Boolean; var Offs: Integer);
      procedure AdjustMarkerPos(var ItemNo, Offs: Integer; DefRight: Boolean);
      {$ENDIF}
      function GetOffsInItem(CaretOffs: Integer): Integer;
      function CaretAtTheBeginningOfParaSectionEx(
        OnlyAllowBeginningOfPara: Boolean): Boolean;
      function CaretAtTheEndOfParaSectionEx(OnlyAllowEndOfPara: Boolean): Boolean;
      function CaretInTheLastLine: Boolean;
      function CaretAtTheBeginningOfLine: Boolean;
      function CaretAtTheEndOfLine: Boolean;
      procedure PostPaintTo(Canvas: TCanvas;
        XShift, YShift, FirstDrawItemNo, LastDrawItemNo: Integer;
        PrintMode, StrictTop, StrictBottom: Boolean); override;
      function GetResizeHandleAt(X, Y: Integer;
        var Index: TRVResizeHandleIndex): Boolean;
      {$IFNDEF RVDONOTUSEDRAGDROP}
      { Drag & drop: drop from }
      function InitDragging(var DropSource: TRVDropSource;
        var OKEffect: Integer): Boolean; override;
      procedure DoneDragging(FDeleteSelection: Boolean); override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSELIVESPELL}
      procedure LiveSpellingCheckCurrentItem; override;
      {$ENDIF}
      procedure DoAfterFormat; override;
    public
      {$IFNDEF RVDONOTUSEDRAGDROP}
      FDragDropCaretInfo: TRVDragDropCaretInfo; // info about drag&drop caret location
      {$ENDIF}
      FCurTextStyleNo, FCurParaStyleNo: Integer;
      UndoList, RedoList: TRVUndoList;
      UndoDest: TRVUndoDest;
      CaretDrawItemNo: Integer;
      CaretOffs: Integer;
      CharEnds: TRVCharPosCollection;
      CaretHeight: Integer;
      FRVFInserted: Boolean;
      procedure ActivateCustomCaretTimer;
      procedure DeactivateCustomCaretTimer;
      procedure DrawCustomCaret;
      procedure ClearCustomCaret;
      procedure DestroyCustomCaretBack;
      procedure PaintBuffered; override;
      {$IFNDEF RVDONOTUSELIVESPELL}
      procedure LaterSetBackLiveSpellingTo(ItemNo, Offs: Integer;
        ClearPainters: Boolean);
      {$ENDIF}
      {$IFNDEF RVDONOTUSEDRAGDROP}
      procedure CreateDragDropCaretInfo;
      procedure ReleaseDragDropCaretInfo;
      function GetDragDropCaretInfo: TRVDragDropCaretInfo; override;
      {$ENDIF}
      procedure AssignCurTag;
      function GetActualCurStyleNo: Integer;
      procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
      procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);override;
      function CancelResize: Boolean;
      procedure AdjustMouseUpSelection; override;
      procedure ResizeItem(ItemNo, Width, Height: Integer);
      procedure XorDrawing; override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      function InsertFirstRVFItem(var Index: Integer; var s: TRVRawByteString;
        var li: TCustomRVItemInfo; EditFlag: Boolean; var FullReformat: Boolean;
        var NewListNo: Integer): Boolean; override;
      function GetUndoList: TRVUndoList;
      procedure Change;
      procedure ChangeEx(ClearRedo: Boolean);
      procedure DoOnSelection(AllowScrolling: Boolean); override;
      procedure CreateResizer;
      procedure DestroyResizer;
      procedure UpdateResizer;
      procedure DoAfterFormatAndCaretPositioning(UpdateControl: Boolean);      
      procedure DoCurrentTextStyleConversion(var StyleNo: Integer;
        ParaStyleNo, ItemNo, UserData: Integer; ToWholeParagraphs: Boolean); override;
      procedure Do_ReformateRange(StartNo, EndNo: Integer; SuperReformat: Boolean);
      procedure Do_DeleteItem(ItemNo: Integer; var FullReformat: Boolean);
      procedure Do_InsertItem(ItemNo: Integer; var s: TRVRawByteString; item: TCustomRVItemInfo; FromUndo: Boolean;
                              var FullReformat: Boolean);
      procedure Do_ReplaceItem(ItemNo: Integer; item: TCustomRVItemInfo);
      procedure Do_DeleteItems(StartItemNo, EndItemNo: Integer; var FullReformat: Boolean);
      procedure Do_InsertItems(ItemNo: Integer; sl: TRVItemList; FromUndo: Boolean;
                               var FullReformat: Boolean);
      procedure Do_ModifyItem(ItemNo: Integer; const s: TRVRawByteString; Item: TCustomRVItemInfo);
      function Do_InsertItems_1(ItemNo,Count: Integer): TRVUndoInsertItemsInfo;
      procedure Do_InsertItems_2(ItemNo,Count: Integer; ui: TRVUndoInsertItemsInfo;
                                 var FullReformat: Boolean);
      procedure Do_DeleteSubstring(ItemNo, Index, ALength: Integer);
      procedure Do_InsertSubstring(ItemNo, Index: Integer; const s: TRVRawByteString);
      procedure Do_NewLine(ItemNo: Integer; SameAsPrev: Boolean; ParaNo: Integer;
                           var FullReformat: Boolean);
      procedure Do_BR(ItemNo: Integer; BR: Boolean; var FullReformat: Boolean);
      procedure Do_PageBreak(ItemNo: Integer; PageBreak: Boolean);
      procedure Do_ClearTextFlow(ItemNo: Integer; Left, Right: Boolean);
      procedure Do_ExtraIntProperty(ItemNo: Integer; Prop: TRVExtraItemProperty;
        Value: Integer);
      procedure Do_ExtraStrProperty(ItemNo: Integer; Prop: TRVExtraItemStrProperty;
        const Value: String);
      procedure Do_Concate(FirstItemNo: Integer);
      procedure Do_MoveCP(SrcItemNo, DestItemNo: Integer);
      function Do_Para(FirstItemNo, EndItemNo, ParaNo: Integer;
        var FullReformat: Boolean): Boolean;
      function Do_ParaList(FirstItemNo: Integer; ParaList: TRVIntegerList;
        var FullReformat: Boolean): Boolean;
      procedure Do_StyleNo(ItemNo, StyleNo: Integer);
      procedure Do_AssociatedTextStyleNo(ItemNo, TextStyleNo: Integer);
      procedure Do_Tag(ItemNo, Tag: Integer; AssignAsIs: Boolean);
      procedure Do_AddCP(ItemNo: Integer; Checkpoint: TRVCPInfo);
      procedure Do_DeleteCP(ItemNo: Integer);
      procedure Do_ChangeTextR(ItemNo: Integer; const s: TRVRawByteString);
      procedure Do_ChangeVAlign(ItemNo: Integer; VAlign: TRVVAlign);
      procedure Do_Resize(ItemNo: Integer; Width, Height: Integer;Reformat: Boolean);
      procedure Do_ItemModifyTerminator(ItemNo: Integer; Opening: Boolean);
      function Do_ModifyItemIntProperty(ItemNo: Integer; SubObject: TObject;
        const PropertyName: String; Value: LongInt;
        AffectSize, AffectWidth: Boolean;
        UndoInfoClass: TRVUndoInfoClass): TRVUndoModifyItemProps;
      function Do_ModifyItemStrProperty(ItemNo: Integer; SubObject: TObject;
        const PropertyName: String; const Value: String;
        UndoInfoClass: TRVUndoInfoClass): TRVUndoModifyItemProps;
      function Do_ModifyItemIntProperties(ItemNo: Integer; SubObject: TObject;
        PropList: TStringList; AffectSize, AffectWidth: Boolean;
        UndoInfoClass: TRVUndoInfoClass): TRVUndoModifyItemProps;

      procedure BeginUndoSequence(UndoType: TRVUndoType; AllowFinalize: Boolean);
      procedure SetUndoGroupMode(GroupUndo: Boolean);
      procedure FinalizeUndoGroup;
      procedure BeginNamedUndoSequence(UndoType: TRVUndoType; const Caption: String;
        AllowFinalize: Boolean);
      procedure EndUndoSequence;
      procedure BeginRedoSequence(UndoType: TRVUndoType; const Caption: String);

      procedure GetSelectionBoundsEx(var StartItemNo, StartItemOffs, EndItemNo,
                 EndItemOffs: Integer; Normalize: Boolean); override;
      procedure GetSelBounds(var StartNo, EndNo, StartOffs, EndOffs: Integer;
        Normalize: Boolean); override;
      procedure Clear; override;
      procedure PrepareForEdit;
      function DeleteSelection_: Boolean;
      function  CanDelete: Boolean;
      procedure InsertTextTyping(text: TRVRawByteString; Key: Char);
      procedure InsertTextA_(const text: TRVAnsiString; AutoTag, CaretBefore: Boolean);
      procedure InsertTextW_(const text: TRVRawByteString; AutoTag, CaretBefore: Boolean);
      function OnEnterPress_(Shift: Boolean; Recursive: Boolean): Boolean;
      function IsCharOffsAtTheLineEndAndItemEnd(Offs: Integer): Boolean;
      function IsCharOffsAtTheLineStartAndItemStart(Offs: Integer): Boolean;
      procedure OnDeletePress_(Ctrl: Boolean; MovedFromLineEnd: Boolean);
      procedure OnBackSpacePress_(Ctrl: Boolean; MultiDelete, FromNextLine: Boolean);
      procedure SetCurTextStyleNo(Value: Integer);
      procedure SetCurParaStyleNo(Value: Integer);
      procedure ClearTemporal; override;
      procedure StartPartialFormatting; override;
      procedure ApplyParaStyle(ParaStyleNo: Integer;
        ConvType: TRVEStyleConversionType; Recursive: Boolean);
      procedure UpdateSelectionEnd;
      function  OnHomePress(Shift, Ctrl: Boolean): Boolean;
      function  OnDownPress(Shift, Ctrl: Boolean): Boolean;
      function  OnEndPress(Shift, Ctrl: Boolean): Boolean;
      function  OnLeftPress(Shift, Ctrl: Boolean): Boolean;
      function  OnPgDownPress(Shift: Boolean): Boolean;
      function  OnPgUpPress(Shift: Boolean): Boolean;
      function  OnRightPress(Shift, Ctrl: Boolean): Boolean;
      function  OnUpPress(Shift,Ctrl: Boolean): Boolean;
      procedure MoveCaretToTheBeginningOfThePrevParagraph(Select: Boolean);
      procedure MoveCaretToTheEndOfTheNextParagraph(Select: Boolean);
      procedure ChangeCaret(ForceCreate, ScrollToCaret, DontChangeStyle, RefreshBefore: Boolean);
      function BuildJumpsCoords(IgnoreReadOnly: Boolean): Integer; dynamic;
      procedure ClearJumpsCoords; dynamic;
      procedure Format_(OnlyResized,ForceFormat,NoScroll: Boolean; depth: Integer;
        Canvas: TCanvas; OnlyTail, NoCaching, Reformatting, CallOnFormat: Boolean); override;
      procedure GetSelStart(var DINo, DIOffs: Integer);override;
      procedure SrchSelectIt(StartItemNo, StartOffs, EndItemNo, EndOffs: Integer;
        Invert: Boolean);override;
      procedure SrchStart(Down, FromStart: Boolean; var strt, offs: Integer);override;
      function GetCurItemNo: Integer;
      function GetOffsetInCurItem: Integer;
      function InsertSomething(info: TCustomRVItemInfo; var s, SplitText: TRVRawByteString;
        AutoTag, CaretBefore, CallTEEvent: Boolean): Boolean;
      function NotFormatted: Boolean;
      procedure StartShiftMoving;
      procedure EndShiftMoving;
      procedure ApplyStyleConversion_(UserData: Integer;
        ConvType: TRVEStyleConversionType; ApplyToWholeParas, Recursive: Boolean);
      function InsertRVFFromStreamEd_(Stream: TStream): Boolean;
      procedure OnChangeCaretLine(DLOffs: Integer);
      procedure ConcateAfterAdding(var InsertPoint, LastInserted, ItemsAdded, Offs: Integer);
      {$IFNDEF RVDONOTUSERTFIMPORT}
      function InsertRTFFromStreamEd_(Stream: TStream): Boolean;
      {$ENDIF}

      {$IFNDEF RVDONOTUSERTF}
      function SaveRTFToStream(Stream: TStream; const Path: String; SelectionOnly: Boolean;
        Level: Integer; Color: TColor; Background: TRVBackground; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVRTFFontTable; tpp: Double; CompleteDocument, HiddenParent: Boolean;
        Header, Footer: TCustomRVData):Boolean; override;
      {$ENDIF}

      function InsertTextFromStream(Stream: TStream; OEM, AutoTag: Boolean): Boolean;
      function InsertTextFromStreamW(Stream: TStream; AutoTag: Boolean): Boolean;
      function InsertTextFromFile(const FileName: String; OEM, AutoTag: Boolean): Boolean;
      function InsertTextFromFileW(const FileName: String; AutoTag: Boolean): Boolean;
      procedure KeyPress(var Key: Char);
      procedure AdjustControlPlacement(ItemNo: Integer);
      procedure ResizeControl(ItemNo, NewWidth, NewHeight: Integer; Reformat: Boolean);
      procedure Reformat(FullFormat,ForceFormat, NoScroll: Boolean; ItemNo: Integer;
        UpdateView:  Boolean);
      procedure ReformatEx(FullFormat,ForceFormat, NoScroll: Boolean; ItemNo: Integer;
        UpdateView:  Boolean; SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer);

      procedure Reformat_(FullFormat: Boolean; StartDrawItem, EndDrawItem, ItemsAdded: Integer);
      procedure BeginItemModify(ItemNo: Integer; var ModifyData: Integer);
      procedure EndItemModify(ItemNo: Integer; ModifyData: Integer);
      procedure EndItemModifyEx(ItemNo: Integer; ModifyData: Integer;
        SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer);
      procedure SelectCurrentWord;
      procedure InsertPageBreak;
      procedure SplitAtCaret;

      {$IFNDEF RVDONOTUSEHTML}
      function SaveHTMLToStreamEx(Stream: TStream;
        const Path, Title, ImagesPrefix,
        ExtraStyles, ExternalCSS, CPPrefix: String;
        Options: TRVSaveOptions; Color: TColor; var CurrentFileColor: TColor;
        var imgSaveNo: Integer;
        LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
        Background: TRVBackground; Bullets: TRVList): Boolean; override;
      function SaveHTMLToStream(Stream: TStream;
        const Path, Title, ImagesPrefix: String;
        Options: TRVSaveOptions; Color: TColor;
        var imgSaveNo: Integer;
         LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
         Background: TRVBackground; Bullets: TRVList): Boolean; override;
      {$ENDIF}
      function GetIMEWinCoord: TPoint;
      {$IFDEF RVUSELISTORSEQ}
      procedure PrepareForUpdateRangeAfterMarkersOrSeq(StartNo, EndNo: Integer;
        ForDeletion: Boolean;
        var FirstItemNo, LastMarkerIndex, LastSeqIndex: Integer;
        var ListNos: TRVIntegerList; var SeqNames: TStringList);
      procedure UpdateAfterMarkersOrSeq(FirstItemNo, LastMarkerIndex,
        LastSeqIndex: Integer;
        ListNos: TRVIntegerList; SeqNames: TStringList);
      procedure UpdateRangeAfterMarkersOrSeq(StartNo, EndNo: Integer);
      {$ENDIF}
      {$IFNDEF RVDONOTUSELISTS}
      procedure ApplyListStyle_(AListNo, AListLevel, AStartFrom: Integer;
        AUseStartFrom, ARecursive: Boolean; Operation: TRVParaListOperation;
        var ItemsAdded, StartNo, EndNo,
        SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer;
        ListNos: TRVIntegerList; var LastVWMarkerIndex: Integer);
      procedure ApplyListStyle(AListNo, AListLevel, AStartFrom: Integer;
        AUseStartFrom, ARecursive: Boolean; Operation: TRVParaListOperation);
      {$ENDIF}
      function GetUpDownMovingX: Integer;
      procedure SetUpDownMovingX(X: Integer);
      procedure ResetUpDownMovingX;

      constructor Create(RichView: TRVScroller); override;
      destructor Destroy; override;
      property OnFormat: TNotifyEvent read FOnFormat write FOnFormat;
  end;

const RichViewEditCaretWidth: Integer = 1;
      RichViewEditCaretHeightExtra: Integer = 0;
      RichViewEditMaxCaretHeight: Integer = 1000;
      RichViewEditMinCaretHeight: Integer = 0;
      RichViewEditDefaultProportionalResize: Boolean = True;
      RichViewEditEnterAllowsEmptyMarkeredLines: Boolean = False;

implementation
uses RVStr,
     {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
     {$ENDIF}
     {$IFNDEF RVDONOTUSESEQ}
     RVSeqItem,
     {$ENDIF}
     RVCtrlData;
{==============================================================================}
function RV_CreateTextCopy(li: TRVTextItemInfo;
                           RVData: TCustomRVData): TRVTextItemInfo;
begin
  Result := RichViewTextItemClass.Create(RVData);
  with Result do begin
    Assign(li);
    ItemOptions := [];  
    SameAsPrev := li.SameAsPrev;
    {$IFNDEF RVDONOTUSEUNICODE}
    if rvioUnicode in li.ItemOptions then
      Include(ItemOptions,rvioUnicode);
    {$ENDIF}
    Tag := RV_CopyTag(li.Tag, rvoTagsArePChars in RVData.Options);
    Checkpoint := nil;
  end;
end;
{================================== TRVCharPos ================================}
constructor TRVCharPos.Create(Owner: TCollection);
begin
  inherited Create(Owner);
  X := 0;
  DrawItemNo := -1;
  Offset := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVCharPos.Assign(Source: TPersistent);
begin
  if Source is TRVCharPos then begin
    X          := TRVCharPos(Source).X;
    DrawItemNo := TRVCharPos(Source).DrawItemNo;
    Offset     := TRVCharPos(Source).Offset;
  end;
end;
{============================= TRVCharPosCollection ===========================}
function TRVCharPosCollection.GetItem(Index: Integer): TRVCharPos;
begin
  Result := TRVCharPos(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVCharPosCollection.SetItem(Index: Integer;
  const Value: TRVCharPos);
begin
  inherited SetItem(Index, Value);
end;
{================================= TRVEditRVData ==============================}
constructor TRVEditRVData.Create(RichView: TRVScroller);
begin
  inherited Create(RichView);
  CharEnds := TRVCharPosCollection.Create(TRVCharPos);
  CaretDrawItemNo  := -1;
  CaretOffs        := -1;
  CaretHeight      := 0;
  FCurTextStyleNo  := 0;
  FCurParaStyleNo  := 0;
  FPrevTextStyleNo := 0;
  UndoList         := TRVUndoList.Create(TCustomRVFormattedData(Self.GetAbsoluteRootData));
  RedoList         := TRVRedoList.Create(TCustomRVFormattedData(Self.GetAbsoluteRootData));
  TabNavigation    := rvtnNone;
  FUpDownMovingX   := MaxInt;
end;
{------------------------------------------------------------------------------}
destructor TRVEditRVData.Destroy;
begin
  CharEnds.Free;
  UndoList.Free;
  RedoList.Free;
  CharEnds := nil;
  UndoList := nil;
  RedoList := nil;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ClearTemporal;
begin
  if CharEnds<>nil then
    CharEnds.Clear;
  CaretDrawItemNo := -1;
  CaretOffs   := -1;
  DestroyResizer;
  ClearCurTag;
  Exclude(State, rvstDoNotClearCurTag);
  DeactivateCustomCaretTimer;
  DestroyCustomCaretBack;
  if not (rvstPreserveSoftPageBreaks in State)
    and not (rvstCreatingInplace in GetAbsoluteRootData.State) then
    ResetUpDownMovingX;
  inherited ClearTemporal;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.StartPartialFormatting;
begin
  DestroyResizer;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Clear;
begin
  inherited Clear;
  if RichView<>nil then
    TCustomRichViewEdit(RichView).Modified := False;
  if UndoList<>nil then
    UndoList.Clear;
  if RedoList<>nil then
    RedoList.Clear;
  FPrevTextStyleNo := 0;
  SetCurTextStyleNo(0);  
  SetCurParaStyleNo(0);
  Include(State, rvstEditorUnformatted);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetUndoList: TRVUndoList;
begin
  case UndoDest of
    udUndo:
      begin
        if UndoList.Limit<>0 then
          Result := UndoList
        else
          Result := nil;
      end;
    udRedo:
      Result := RedoList;
    else
      Result := nil;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.BeginRedoSequence(UndoType: TRVUndoType; const Caption: String);
begin
  if RedoList.BeginItem(UndoType, Caption, GetCurItemNo, GetOffsetInCurItem, TCustomRichViewEdit(RichView)) then
    UndoDest := udRedo
  else
    UndoDest := udNone;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.FinalizeUndoGroup;
begin
  if not (rvstFinalizingUndo in State) then begin
    State := State + [rvstFinalizingUndo];
    try
      if FPartialSelectedItem<>nil then
        FPartialSelectedItem.FinalizeUndoGroup
      else if GetChosenItem<>nil then
        GetChosenItem.FinalizeUndoGroup;
    finally
      State := State - [rvstFinalizingUndo];
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.BeginUndoSequence(UndoType: TRVUndoType; AllowFinalize: Boolean);
begin
  if AllowFinalize then
    FinalizeUndoGroup;
  if UndoList.BeginItem(UndoType, '', GetCurItemNo, GetOffsetInCurItem, TCustomRichViewEdit(RichView)) then
    UndoDest := udUndo
  else
    UndoDest := udNone;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.BeginNamedUndoSequence(UndoType: TRVUndoType; const Caption: String;
                                               AllowFinalize: Boolean);
begin
  if AllowFinalize then
    FinalizeUndoGroup;
  if UndoList.BeginItem(UndoType, Caption, GetCurItemNo, GetOffsetInCurItem, TCustomRichViewEdit(RichView)) then
    UndoDest := udUndo
  else
    UndoDest := udNone;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SetUndoGroupMode(GroupUndo: Boolean);
begin
  UndoList.SetUndoGroupMode(GroupUndo, TCustomRichViewEdit(RichView));
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.EndUndoSequence;
begin
  UndoList.EndItem;
end;
{------------------------------------------------------------------------------}
// Returns the last paragraph item, for the paragraph containing the ItemNo-th item.
// Takes hidden items into account
function TRVEditRVData.GetLastParaItemEx(ItemNo: Integer): Integer;
begin
  Result := ItemNo+1;
  while Result<Items.Count do begin
    if IsParaStartEx(Result) then
      break;
    inc(Result)
  end;
  dec(Result);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.SetParaStyle(StartItemNo, EndItemNo, ParaNo: Integer;
  var FullReformat: Boolean): Boolean;
var i: Integer;
    NewWidth, OldWidth: Integer;
    item : TCustomRVItemInfo;
begin
  Result := False;
  OldWidth := CalculateParaSectionsMinWidthDef(StartItemNo, EndItemNo);
  for i := StartItemNo to EndItemNo do begin
    item := GetItem(i);
    if (item.ParaNo<>ParaNo) and
       (not (rvpaoStyleProtect in GetRVStyle.ParaStyles[item.ParaNo].Options) or
       ((i>0) and (item.SameAsPrev or item.BR) and (GetItemPara(i-1)=ParaNo)))
     then begin
      item.ParaNo := ParaNo;
      Result := True;
     end;
  end;
  if Result then begin
    NewWidth := CalculateParaSectionsMinWidthDef(StartItemNo, EndItemNo);
    FullReformat := {(OldWidth<>NewWidth) and}
                    ((NewWidth>DocumentWidth) or
                     (OldWidth>=DocumentWidth));
    end
  else
    FullReformat := False;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ItemModifyTerminator(ItemNo: Integer; Opening: Boolean);
var ui: TRVUndoModifyItemTerminator;
    List: TRVUndoList;
begin
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoModifyItemTerminator.Create;
    ui.ItemNo := ItemNo;
    ui.Opening := Opening;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ReformateRange(StartNo, EndNo: Integer;
  SuperReformat: Boolean);
var ui: TRVUndoReformateRange;
    List: TRVUndoList;
begin
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoReformateRange.Create;
    ui.Action := rvuMisc;
    ui.ItemNo := StartNo;
    ui.LastAffectedItemNo := EndNo;
    ui.SuperReformat := SuperReformat;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_DeleteItem(ItemNo: Integer; var FullReformat: Boolean);
var ui: TRVUndoDeleteItemInfo;
    item: TCustomRVItemInfo;
    List: TRVUndoList;
    LastAffectedItemNo: Integer;
    FR: Boolean;
begin
  item := GetItem(ItemNo);
  FullReformat := CalculateMinItemWidthPlusEx(ItemNo)=DocumentWidth;
  if item.Checkpoint<>nil then
    Do_DeleteCP(ItemNo);
  if False and (ItemNo>0) and item.CanBeBorderStart then
    LastAffectedItemNo := GetLastParaItemEx(ItemNo)
  else
    LastAffectedItemNo := -1;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoDeleteItemInfo.Create;
    ui.Action := rvuDeleteItem;
    ui.Item   := item;
    //!!ui.RVData := Self;
    ui.ItemNo := ItemNo;
    ui.LastAffectedItemNo := LastAffectedItemNo;
    ui.s      := Items[ItemNo];
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    item.MovingToUndoList(ItemNo, Self, ui);
    end
  else begin
    FreeItem(ItemNo, False);
  end;
  Items.Delete(ItemNo);
  if (LastAffectedItemNo<>-1) then begin // never happens
    Do_Para(ItemNo, LastAffectedItemNo-1,
            GetItem(ItemNo-1).ParaNo, FR);
    FullReformat := FR or FullReformat;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ModifyItem(ItemNo: Integer; const s: TRVRawByteString;
  Item: TCustomRVItemInfo);
var ui: TRVUndoModifyItemInfo;
    OldItem: TCustomRVItemInfo;
    List: TRVUndoList;
begin
  OldItem := GetItem(ItemNo);
  Item.Checkpoint := OldItem.Checkpoint;
  if Item.Checkpoint<>nil then
    Item.Checkpoint.ItemInfo := Item;
  OldItem.Checkpoint := nil;
  if (rvoTagsArePChars in Options) and (Item.Tag=OldItem.Tag) then
    Item.Tag := RV_CopyTag(OldItem.Tag,rvoTagsArePChars in Options);

  Item.ParaNo      := OldItem.ParaNo;
  Item.ItemOptions := OldItem.ItemOptions;
  Item.JumpID      := OldItem.JumpID;
  Item.DrawItemNo  := OldItem.DrawItemNo;
  Item.TransferProperties(OldItem, Self);

  if FActiveItem=OldItem then
    FActiveItem := Item;
  if FPartialSelectedItem=OldItem then
    FPartialSelectedItem := Item;

  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoModifyItemInfo.Create;
    ui.Action := rvuModifyItem;
    ui.Item   := OldItem;
    //!!ui.RVData := Self;
    ui.ItemNo := ItemNo;
    ui.s      := Items[ItemNo];
    //OldItem.MovingToUndoList;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    end
  else begin
    InternalFreeItem(OldItem, False); // never called for controls
  end;
  Items.Objects[ItemNo] := Item;
  Items[ItemNo] := s;  
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_DeleteItems(StartItemNo, EndItemNo: Integer; var FullReformat: Boolean);
var i: Integer;
    item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoDeleteItemsInfo;
    LastAffectedItemNo: Integer;
    FR: Boolean;
begin
  FullReformat := False;
  if StartItemNo>EndItemNo then exit;
  FullReformat := CalculateMinItemsWidthPlusEx(StartItemNo, EndItemNo)=DocumentWidth;
  for i := EndItemNo downto StartItemNo do begin
    item := GetItem(i);
    if item.Checkpoint<>nil then
      Do_DeleteCP(i);
  end;

  if False and (StartItemNo>0)  then
    LastAffectedItemNo := GetLastParaItemEx(EndItemNo)
  else
    LastAffectedItemNo := -1;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoDeleteItemsInfo.Create;
    ui.Action := rvuDeleteItems;
    ui.StartItemNo := StartItemNo;
    ui.LastAffectedItemNo := LastAffectedItemNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    for i := EndItemNo downto StartItemNo do begin
      item := GetItem(i);
      ui.List.AddObject(Items[i],item);
      item.MovingToUndoList(i, Self, ui);
      Items.Delete(i);
    end;
    end
  else begin
    for i := EndItemNo downto StartItemNo do begin
      FreeItem(i, False);
      Items.Delete(i);
    end;
  end;
  if (LastAffectedItemNo<>-1) then begin // never happens
    Do_Para(StartItemNo,LastAffectedItemNo-(EndItemNo-StartItemNo+1),
            GetItemPara(StartItemNo-1), FR);
    FullReformat := FullReformat or FR;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_DeleteSubstring(ItemNo, Index,ALength: Integer);
var s: TRVRawByteString;
    List: TRVUndoList;
    ui: TRVUndoDeleteSubstringInfo;
begin
  s := Items[ItemNo];
  if ALength=-1 then
    ALength := RVU_Length(s,GetItemOptions(ItemNo))-Index+1;
  if ALength=0 then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoDeleteSubstringInfo.Create;
    ui.Action := rvuDeleteSubstring;
    ui.ItemNo := ItemNo;
    ui.Index  := Index;
    ui.s      := RVU_Copy(Items[ItemNo],Index, ALength, GetItemOptions(ItemNo));
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  RVU_Delete(s, Index, ALength, GetItemOptions(ItemNo));
  ItemAction(rviaTextModifying, GetItem(ItemNo), s, Self); 
  Items[ItemNo] := s;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_Para(FirstItemNo, EndItemNo, ParaNo: Integer;
  var FullReformat: Boolean): Boolean;
var List: TRVUndoList;
    ui: TRVUndoParaListInfo;
    i: Integer;
begin
  Result := False;
  FullReformat := False;
  if EndItemNo<FirstItemNo then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoParaListInfo.Create;
    ui.Action := rvuPara;
    ui.StartItemNo := FirstItemNo;
    for i := FirstItemNo to EndItemNo do
      ui.List.Add(GetItemPara(i));
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  Result := SetParaStyle(FirstItemNo, EndItemNo, ParaNo, FullReformat);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_ParaList(FirstItemNo: Integer; ParaList: TRVIntegerList;
  var FullReformat: Boolean): Boolean;
var List: TRVUndoList;
    ui: TRVUndoParaListInfo;
    i: Integer;
    NewWidth, OldWidth: Integer;
begin
  Result := False;
  FullReformat := False;
  if ParaList.Count=0 then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoParaListInfo.Create;
    ui.Action := rvuPara;
    ui.StartItemNo := FirstItemNo;
    for i := FirstItemNo to FirstItemNo+ParaList.Count-1 do
      ui.List.Add(GetItemPara(i));
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  OldWidth := CalculateMinItemsWidthPlusEx(FirstItemNo, FirstItemNo+ParaList.Count-1);
  for i := 0 to ParaList.Count-1 do
    if GetItem(FirstItemNo+i).ParaNo<>ParaList[i] then begin
      GetItem(FirstItemNo+i).ParaNo := ParaList[i];
      Result := True;
    end;
  NewWidth := CalculateMinItemsWidthPlusEx(FirstItemNo, FirstItemNo+ParaList.Count-1);
  FullReformat := (OldWidth<>NewWidth) and
                  ((NewWidth>DocumentWidth) or
                   (OldWidth>=DocumentWidth));
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_StyleNo(ItemNo, StyleNo: Integer);
var List: TRVUndoList;
    ui: TRVUndoStyleNoInfo;
    item :TCustomRVItemInfo;
begin
  item := GetItem(ItemNo);
  if (item.StyleNo<0) or (item.StyleNo=StyleNo) then
    exit;

  List := GetUndoList;
  if List<>nil then begin
    ui             := TRVUndoStyleNoInfo.Create;
    ui.Action      := rvuStyleNo;
    ui.ItemNo      := ItemNo;
    ui.WasStyleNo  := item.StyleNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[GetActualStyle(item)].Unicode then begin
    if not GetRVStyle.TextStyles[GetActualStyle2(StyleNo, item.ParaNo)].Unicode then
      Exclude(item.ItemOptions, rvioUnicode)
    end
  else begin
    if GetRVStyle.TextStyles[GetActualStyle2(StyleNo,item.ParaNo)].Unicode then
      Include(item.ItemOptions, rvioUnicode)
  end;
  {$ENDIF}
  item.StyleNo := StyleNo;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_AssociatedTextStyleNo(ItemNo, TextStyleNo: Integer);
var List: TRVUndoList;
    ui: TRVUndoAssociatedTextStyleNoInfo;
    item :TCustomRVItemInfo;
begin
  item := GetItem(ItemNo);
  if item.AssociatedTextStyleNo=TextStyleNo then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui             := TRVUndoAssociatedTextStyleNoInfo.Create;
    ui.Action      := rvuStyleNo;
    ui.ItemNo      := ItemNo;
    ui.WasStyleNo  := item.AssociatedTextStyleNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.AssociatedTextStyleNo := TextStyleNo;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_InsertItem(ItemNo: Integer; var s: TRVRawByteString;
  item: TCustomRVItemInfo; FromUndo: Boolean; var FullReformat: Boolean);
var  List: TRVUndoList;
     ui: TRVUndoInsertItemInfo;
     LastAffectedItemNo: Integer;
     Checkpoint: TRVCPInfo;
begin
  FullReformat := False;
  if item.CanBeBorderStart and (ItemNo<Items.Count) and
     not GetItem(ItemNo).CanBeBorderStart then
    LastAffectedItemNo := GetLastParaItemEx(ItemNo)
  else
    LastAffectedItemNo := -1;

  Checkpoint := item.Checkpoint;
  item.Checkpoint := nil;

  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoInsertItemInfo.Create;
    ui.Action :=  rvuInsertItem;
    ui.ItemNo := ItemNo;
    ui.LastAffectedItemNo := LastAffectedItemNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.Inserting(Self, s, False);
  Items.InsertObject(ItemNo,s,item);
  item.Inserted(Self, ItemNo);
  {$IFNDEF RVDONOTUSESEQ}
  AddSeqInList(ItemNo);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  AddMarkerInList(ItemNo);
  {$ENDIF}
  if FromUndo then
    item.MovingFromUndoList(ItemNo, Self);  
  item.UpdatePaletteInfo(GetDoInPaletteMode, False, GetRVPalette, GetRVLogPalette);
  if LastAffectedItemNo>=0 then
     Do_Para(ItemNo+1, LastAffectedItemNo+1, item.ParaNo, FullReformat);
     //SetParaStyle(ItemNo+1,LastAffectedItemNo+1,item.ParaNo);
  if Checkpoint<>nil then
    Do_AddCP(ItemNo, Checkpoint);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ReplaceItem(ItemNo: Integer; item: TCustomRVItemInfo);
var List: TRVUndoList;
    ui: TRVUndoReplaceItemInfo;
    olditem :TCustomRVItemInfo;
    s: TRVRawByteString;
    StyleNo: Integer;
begin
  s := Items[ItemNo];
  olditem := GetItem(ItemNo);
  StyleNo := item.StyleNo;
  item.Assign(olditem);
  item.StyleNo := StyleNo;
  item.DrawItemNo := olditem.DrawItemNo;
  item.Tag        := olditem.Tag;
  item.ItemOptions:= olditem.ItemOptions;
  item.JumpID     := olditem.JumpID;
  item.Checkpoint := olditem.Checkpoint;
  if item.Checkpoint<>nil then
    item.Checkpoint.ItemInfo := item;
  olditem.Checkpoint := nil;
  olditem.Tag        := 0;
  if olditem=CaptureMouseItem then
    ReleaseMouseCapture(olditem);
  if olditem=FActiveItem then
    FActiveItem := item;
  List := GetUndoList;
  if List<>nil then begin
    ui             := TRVUndoReplaceItemInfo.Create;
    ui.Action      := rvuModifyItem;
    ui.ItemNo      := ItemNo;
    ui.item        := olditem;
    olditem.MovingToUndoList(ItemNo, Self, ui);
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    end
  else
    FreeItem(ItemNo, False);
  item.Inserting(Self, s, False);
  Items.Objects[ItemNo] := item;
  Items[ItemNo] := s;
  item.Inserted(Self, ItemNo);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_InsertItems_1(ItemNo,Count: Integer):TRVUndoInsertItemsInfo;
var List: TRVUndoList;
    ui: TRVUndoInsertItemsInfo;
begin
  Result   := nil;

  if Count=0 then
    exit;

  List := GetUndoList;
  if List<>nil then begin
    ui :=  TRVUndoInsertItemsInfo.Create;
    ui.Action := rvuInsertItems;
    ui.ItemNo := ItemNo;
    ui.Count  := Count;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    end
  else
    ui := nil;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_InsertItems_2(ItemNo,Count: Integer;
  ui: TRVUndoInsertItemsInfo; var FullReformat: Boolean);
var i: Integer;
    Checkpoint: TRVCPInfo;
    item: TCustomRVItemInfo;
    LastAffectedItemNo: Integer;    
begin
  FullReformat := False;
  if Count=0 then exit;
  if (ItemNo+Count<ItemCount) and not IsParaStartEx(ItemNo+Count) then
    LastAffectedItemNo := GetLastParaItemEx(ItemNo+Count-1)
  else
    LastAffectedItemNo := -1;

  if ui<>nil then begin
    ui.LastAffectedItemNo := LastAffectedItemNo;
  end;

  if LastAffectedItemNo<>-1 then
    Do_Para(ItemNo+Count-1, LastAffectedItemNo,
      GetItemPara(ItemNo+Count-1), FullReformat);

  for i := ItemNo to ItemNo+Count-1 do begin
    item := GetItem(i);
    if item.Checkpoint<>nil then begin
      Checkpoint := item.Checkpoint;
      item.Checkpoint := nil;
      Do_AddCP(i, Checkpoint);
    end;
  end;
end;
{------------------------------------------------------------------------------}
// in rev. order
procedure TRVEditRVData.Do_InsertItems(ItemNo: Integer; sl: TRVItemList;
  FromUndo: Boolean; var FullReformat: Boolean);
var  i: Integer;
     item: TCustomRVItemInfo;
     ui: TRVUndoInsertItemsInfo;
     s: TRVRawByteString;
begin
  FullReformat := False;
  if sl.Count=0 then exit;

  ui := Do_InsertItems_1(ItemNo, sl.Count);

  for i := 0 to sl.Count-1 do begin
    item := TCustomRVItemInfo(sl.Objects[i]);
    s := sl[i];
    item.Inserting(Self, s, False);
    Items.InsertObject(ItemNo, s, item);
    item.Inserted(Self, ItemNo);
    {$IFNDEF RVDONOTUSESEQ}
    AddSeqInList(ItemNo);
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    AddMarkerInList(ItemNo);
    {$ENDIF}
    if FromUndo then
      item.MovingFromUndoList(ItemNo, Self);
    item.UpdatePaletteInfo(GetDoInPaletteMode, False, GetRVPalette, GetRVLogPalette);
  end;

  Do_InsertItems_2(ItemNo, sl.Count, ui, FullReformat);

end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_InsertSubstring(ItemNo, Index: Integer;
  const s: TRVRawByteString);
var str: TRVRawByteString;
    List: TRVUndoList;
    ui: TRVUndoInsertSubstringInfo;
begin
  if (Length(s)=0) then exit;
  if (ItemNo<0) or (ItemNo>=Items.Count) or
     (GetItemStyle(ItemNo)<0) then
    raise Exception.Create(errRVUndo);
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoInsertSubstringInfo.Create;
    ui.Action := rvuInsertSubstring;
    ui.ItemNo := ItemNo;
    ui.Index  := Index;
    ui.Length := RVU_Length(s, GetItemOptions(ItemNo));
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  str := Items[ItemNo];
  RVU_Insert(s, str, Index, GetItemOptions(ItemNo));
  ItemAction(rviaTextModifying, GetItem(ItemNo), str, Self);
  Items[ItemNo] := str;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ChangeTextR(ItemNo: Integer; const s: TRVRawByteString);
var List: TRVUndoList;
    ui: TRVUndoChangeTextInfo;
    str: TRVRawByteString;
begin
  if Items[ItemNo]=s then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoChangeTextInfo.Create;
    ui.Action := rvuChangeText;
    ui.ItemNo := ItemNo;
    ui.s      := Items[ItemNo];
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  str := s;
  ItemAction(rviaTextModifying, GetItem(ItemNo), str, Self);
  Items[ItemNo] := str;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ChangeVAlign(ItemNo: Integer; VAlign: TRVVAlign);
var List: TRVUndoList;
    ui: TRVUndoChangeVAlignInfo;
    item: TCustomRVItemInfo;
begin
  item := GetItem(ItemNo);
  if (item as TRVRectItemInfo).VAlign = VAlign then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoChangeVAlignInfo.Create;
    ui.Action := rvuChangeText;
    ui.ItemNo := ItemNo;
    ui.VAlign := TRVRectItemInfo(item).VAlign;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  TRVRectItemInfo(item).Valign := VAlign;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_Resize(ItemNo, Width, Height: Integer;Reformat: Boolean);
var List: TRVUndoList;
    ui: TRVUndoResizeInfo;
    item: TRVControlItemInfo;
begin
  // for controls only
  item := TRVControlItemInfo(GetItem(ItemNo));
  if (item.Control.Width  = Width) and
     (item.Control.Height = Height) then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoResizeInfo.Create;
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.Width  := item.Control.Width;
    ui.Height := item.Control.Height;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  ResizeControl(ItemNo, Width, Height, Reformat);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_ModifyItemIntProperty(ItemNo: Integer;
                        SubObject: TObject;
                        const PropertyName: String;
                        Value: LongInt;
                        AffectSize, AffectWidth: Boolean;
                        UndoInfoClass: TRVUndoInfoClass):TRVUndoModifyItemProps;
var List: TRVUndoList;
    ui: TRVUndoModifyItemIntProperty;
    item: TCustomRVItemInfo;
    propinfo: PPropInfo;
    OldValue:LongInt;
begin
  Result := nil;
  item := GetItem(ItemNo);
  if SubObject=nil then
    SubObject := item;
  propinfo := GetPropInfo(SubObject.ClassInfo, PropertyName);
  OldValue := GetOrdProp(SubObject, propinfo);
  if OldValue=Value then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoModifyItemIntProperty(UndoInfoClass.Create);
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.PropertyName := PropertyName;
    ui.Value        := OldValue;
    ui.AffectSize   := AffectSize;
    ui.AffectWidth  := AffectWidth;
    ui.SubObject    := SubObject;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    end
  else
    ui := nil;
  item.BeforeUndoChangeProperty;
  try
    SetOrdProp(SubObject, propinfo,Value);
  finally
    item.AfterUndoChangeProperty;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_ModifyItemStrProperty(ItemNo: Integer; SubObject: TObject;
  const PropertyName: String; const Value: String;
  UndoInfoClass: TRVUndoInfoClass): TRVUndoModifyItemProps;
var List: TRVUndoList;
    ui: TRVUndoModifyItemStrProperty;
    item: TCustomRVItemInfo;
    propinfo: PPropInfo;
    OldValue:String;
begin
  Result := nil;
  item := GetItem(ItemNo);
  if SubObject=nil then
    SubObject := item;
  propinfo := GetPropInfo(SubObject.ClassInfo, PropertyName);
  OldValue := GetStrProp(SubObject, propinfo);
  if OldValue=Value then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoModifyItemStrProperty(UndoInfoClass.Create);
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.PropertyName := PropertyName;
    ui.Value        := OldValue;
    ui.SubObject    := SubObject;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    end
  else
    ui := nil;
  item.BeforeUndoChangeProperty;
  try
    SetStrProp(SubObject, propinfo, Value);
  finally
    item.AfterUndoChangeProperty;
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.Do_ModifyItemIntProperties(ItemNo: Integer;
  SubObject: TObject; PropList: TStringList; AffectSize,
  AffectWidth: Boolean;
  UndoInfoClass: TRVUndoInfoClass):TRVUndoModifyItemProps;
var List: TRVUndoList;
    ui: TRVUndoModifyItemIntProperties;
    item: TCustomRVItemInfo;
    propinfo: PPropInfo;
    i: Integer;
    OldValue, NewValue: LongInt;
begin
  item := GetItem(ItemNo);
  if SubObject=nil then
    SubObject := item;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoModifyItemIntProperties(UndoInfoClass.Create);
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.AffectSize   := AffectSize;
    ui.AffectWidth  := AffectWidth;
    ui.SubObject    := SubObject;
    end
  else
    ui := nil;
  item.BeforeUndoChangeProperty;
  try
    for i := PropList.Count-1 downto 0 do begin
      propinfo := GetPropInfo(SubObject.ClassInfo, PropList[i]);
      OldValue := GetOrdProp(SubObject, propinfo);
      NewValue := LongInt(PropList.Objects[i]);
      if OldValue<>NewValue then begin
        if ui<>nil then
          ui.PropList.AddObject(PropList[i], TObject(OldValue));
        SetOrdProp(SubObject, propinfo, NewValue);
      end;
    end;
  finally
    item.AfterUndoChangeProperty;
  end;
  if ui<>nil then begin
    if ui.PropList.Count=0 then begin
      ui.Free;
      ui := nil;
      end
    else
      List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  Result := ui;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_NewLine(ItemNo: Integer; SameAsPrev: Boolean;
  ParaNo: Integer; var FullReformat: Boolean);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoNewLineInfo;
    LastAffectedItemNo: Integer;
    FR: Boolean;
begin
  FullReformat := False;
  item := GetItem(ItemNo);
  if Item.GetBoolValue(rvbpFullWidth) then
    exit;
  if not SameAsPrev and (item.SameAsPrev = SameAsPrev) then exit;
  if SameAsPrev then begin
    Do_BR(ItemNo, False, FR);
    FullReformat := FullReformat or FR;
    Do_PageBreak(ItemNo, False);
  end;
  if (ItemNo<Items.Count-1) and
     not GetItem(ItemNo+1).CanBeBorderStart then
    LastAffectedItemNo := GetLastParaItemEx(ItemNo+1)
  else
    LastAffectedItemNo := -1;

  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoNewLineInfo.Create;
    ui.Action := rvuNewLine;
    ui.ItemNo := ItemNo;
    ui.WasSameAsPrev  := item.SameAsPrev;
    ui.WasParaNo      := item.ParaNo;
    ui.LastAffectedItemNo := LastAffectedItemNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;

  if LastAffectedItemNo=-1 then
    LastAffectedItemNo := ItemNo;

  if SameAsPrev then begin
    if ItemNo>0 then begin
      Do_Para(ItemNo,LastAffectedItemNo, GetItemPara(ItemNo-1), FR);
      FullReformat := FullReformat or FR;
    end
    end
  else begin
    if ParaNo<>-1 then begin
      Do_Para(ItemNo,LastAffectedItemNo, ParaNo, FR);
      FullReformat := FullReformat or FR;      
    end;
  end;
  item.SameAsPrev := SameAsPrev;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_BR(ItemNo: Integer; BR: Boolean; var FullReformat: Boolean);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoBRInfo;
    OldWidth, NewWidth: Integer;
begin
  FullReformat := False;
  item := GetItem(ItemNo);
  if item.SameAsPrev or item.BR=BR then
    exit;
  OldWidth := CalculateMinItemWidthPlusEx(ItemNo);
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoBRInfo.Create;
    ui.Action := rvuBR;
    ui.ItemNo := ItemNo;
    ui.WasBR  := item.BR;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.BR := BR;
  NewWidth := CalculateMinItemWidthPlusEx(ItemNo);
  FullReformat := (OldWidth<>NewWidth) and
                  ((NewWidth>DocumentWidth) or
                   (OldWidth>=DocumentWidth));
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_PageBreak(ItemNo: Integer; PageBreak: Boolean);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoPageBreakInfo;
begin
  {$IFNDEF RVDONOTUSELISTS}
  if (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker) then
    dec(ItemNo);
  {$ENDIF}
  item := GetItem(ItemNo);
  if item.SameAsPrev or item.PageBreakBefore=PageBreak then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoPageBreakInfo.Create;
    ui.Action := rvuPageBreak;
    ui.ItemNo := ItemNo;
    ui.WasPageBreak  := item.PageBreakBefore;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.PageBreakBefore := PageBreak;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ClearTextFlow(ItemNo: Integer; Left, Right: Boolean);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoClearTextFlowInfo;
begin
  {$IFNDEF RVDONOTUSELISTS}
  if (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker) then
    dec(ItemNo);
  {$ENDIF}
  item := GetItem(ItemNo);
  if item.SameAsPrev or ((item.ClearLeft=Left) and (item.ClearRight=Right)) then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoClearTextFlowInfo.Create;
    ui.Action := rvuPageBreak;
    ui.ItemNo := ItemNo;
    ui.WasClearLeft  := item.ClearLeft;
    ui.WasClearRight := item.ClearRight;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.ClearLeft := Left;
  item.ClearRight := Right;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ExtraIntProperty(ItemNo: Integer;
  Prop: TRVExtraItemProperty; Value: Integer);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoExtraIntProperty;
    OldValue: Integer;
begin
  item := GetItem(ItemNo);
  if not item.GetExtraIntProperty(Prop,OldValue) or (OldValue=Value) then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoExtraIntProperty.Create;
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.OldValue := OldValue;
    ui.Prop   := Prop;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.SetExtraIntProperty(Prop, Value);
  {$IFNDEF RVDONOTUSEANIMATION}
  if (Prop in [rvepAnimationInterval, rvepImageWidth, rvepImageHeight]) then
    item.UpdateAnimator(Self);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_ExtraStrProperty(ItemNo: Integer;
  Prop: TRVExtraItemStrProperty; const Value: String);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoExtraStrProperty;
    OldValue: String;
begin
  item := GetItem(ItemNo);
  if not item.GetExtraStrProperty(Prop, OldValue) or (OldValue=Value) then
    exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoExtraStrProperty.Create;
    ui.Action := rvuModifyItem;
    ui.ItemNo := ItemNo;
    ui.OldValue := OldValue;
    ui.Prop   := Prop;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  item.SetExtraStrProperty(Prop, Value);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_Tag(ItemNo, Tag: Integer; AssignAsIs: Boolean);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoTagInfo;
begin
  item := GetItem(ItemNo);
  if Tag=item.Tag then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoTagInfo.Create;
    ui.Action := rvuTag;
    ui.ItemNo := ItemNo;
    ui.WasTag  := RV_CopyTag(item.Tag, rvoTagsArePChars in Options);
    ui.TagsArePChars := rvoTagsArePChars in Options;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  if rvoTagsArePChars in Options then
    StrDispose(PChar(item.Tag));
  if AssignAsIs then
    item.Tag := Tag
  else
    item.Tag := RV_CopyTag(Tag, rvoTagsArePChars in Options);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_AddCP(ItemNo: Integer; Checkpoint: TRVCPInfo);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoAddCPInfo;
begin
  if ItemNo<>-1 then begin
    item := GetItem(ItemNo);
    if item.Checkpoint<>nil then
      raise ERichViewError.Create(errRVCP);
    end
  else begin
    item := nil;
    if NotAddedCP<>nil then
      raise ERichViewError.Create(errRVCP);
  end;
  if Checkpoint=nil then exit;
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoAddCPInfo.Create;
    ui.Action := rvuCheckpoint;
    ui.ItemNo := ItemNo;
    List.AddInfo(ui, TCustomRichViewEdit(RichView));
  end;
  if item<>nil then begin
    item.Checkpoint := Checkpoint;
    Checkpoint.ItemInfo := item;
    end
  else begin
    NotAddedCP := Checkpoint;
    Checkpoint.ItemInfo := nil;
  end;
  inc(CPCount);
  UpdateCPPos(Checkpoint, ItemNo);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_DeleteCP(ItemNo: Integer);
var item: TCustomRVItemInfo;
    List: TRVUndoList;
    ui: TRVUndoDeleteCPInfo;
    CP: TRVCPInfo;
begin
  if ItemNo<>-1 then begin
    item := GetItem(ItemNo);
    CP := item.Checkpoint;
    end
  else begin
    item := nil;
    CP := NotAddedCP;
  end;
  if CP=nil then
    raise ERichViewError.Create(errRVCP);
  List := GetUndoList;
  if List<>nil then begin
    ui := TRVUndoDeleteCPInfo.Create;
    ui.Action := rvuCheckpoint;
    ui.ItemNo := ItemNo;
    ui.Checkpoint := CP;
    ui.TagsArePChars := rvoTagsArePChars in Options;

    List.AddInfo(ui, TCustomRichViewEdit(RichView));
    UnlinkCheckpoint(CP,True);
    end
  else
    FreeCheckpoint(CP,True,True);
  if item<>nil then
    item.Checkpoint := nil
  else
    NotAddedCP := nil;
end;
{------------------------------------------------------------------------------}
{ Moving checkpoint (by copying-deleting) from the SrcItemNo-th item to
  the DestItemNo-th item                                                       }
procedure TRVEditRVData.Do_MoveCP(SrcItemNo, DestItemNo: Integer);
var CP: TRVCPInfo;
begin
  if GetItemCheckpoint(SrcItemNo)<>nil then begin    
    if GetItemCheckpoint(DestItemNo)<>nil then
      Do_DeleteCP(DestItemNo);
    CP := TRVCPInfo.Create;
    CP.Assign(GetItemCheckpoint(SrcItemNo), rvoTagsArePChars in Options);
    Do_AddCP(DestItemNo, CP);
    Do_DeleteCP(SrcItemNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Do_Concate(FirstItemNo: Integer);
var // FullReformat,
    FR: Boolean;
    SAP, BR, CL, CR: Boolean;
    item: TCustomRVItemInfo;
    CP: TRVCPInfo;
begin
  if (GetItemStyle(FirstItemNo+1)>=0) and (Items[FirstItemNo+1]='') then begin
    // the second item is empty: deleting it
    Do_DeleteItem(FirstItemNo+1, FR);
    exit;
  end;
  if (GetItemStyle(FirstItemNo)>=0) and (Items[FirstItemNo]='') then begin
    // the first item is empty: copying its paragraph and checkpoint properties
    // to the second item, deleting the second item
    item := GetItem(FirstItemNo);
    BR  := item.BR;
    SAP := item.SameAsPrev;
    CL  := item.ClearLeft;
    CR  := item.ClearRight;
    if not SAP then begin
      Do_NewLine(FirstItemNo+1, False, item.ParaNo, FR);
      Do_BR(FirstItemNo+1, BR, FR);
      Do_ClearTextFlow(FirstItemNo+1, CL, CR);
    end;
    if (GetItemCheckpoint(FirstItemNo)<>nil) and
       (GetItemCheckpoint(FirstItemNo+1)=nil) then begin
       CP := TRVCPInfo.Create;
       CP.Assign(GetItemCheckpoint(FirstItemNo), rvoTagsArePChars in Options);
       Do_AddCP(FirstItemNo+1, CP);
    end;
    Do_DeleteItem(FirstItemNo,FR);
    exit;
  end;
  // concatenation of two text items
  if (GetItemStyle(FirstItemNo)>=0) and (GetItemStyle(FirstItemNo+1)>=0) and
     ((rvioUnicode in GetItemOptions(FirstItemNo))=
      (rvioUnicode in GetItemOptions(FirstItemNo+1))) then begin
    Do_InsertSubstring(FirstItemNo, ItemLength(FirstItemNo)+1,Items[FirstItemNo+1]);
    if (GetItemCheckpoint(FirstItemNo+1)<>nil) and
       (GetItemCheckpoint(FirstItemNo)=nil) then begin
       CP := TRVCPInfo.Create;
       CP.Assign(GetItemCheckpoint(FirstItemNo+1), rvoTagsArePChars in Options);
       Do_AddCP(FirstItemNo, CP);
    end;
    Do_DeleteItem(FirstItemNo+1, FR);
  end;
  // assuming FullReformat=False for text
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsSomething(var info: TCustomRVItemInfo;
  var s, SplitText: TRVRawByteString; AutoTag, CallTEEvent: Boolean;
  var InsertPoint, ItemsAdded: Integer;
  var FullReformat: Boolean; var NewListNo: Integer;
  NoNewLineReset: Boolean): Boolean;
  {.............................................................}
  procedure AdjustTag(cur: TCustomRVItemInfo);
  begin
    if AutoTag and {(info.Tag=0) and} (cur.Tag<>0) and (info.StyleNo>=0) and
      (info.StyleNo=cur.StyleNo) then begin
      if (info.Tag<>0) and (rvoTagsArePChars in Options) then
        StrDispose(PChar(info.Tag));
      info.Tag := RV_CopyTag(cur.Tag, rvoTagsArePChars in Options)
    end;
  end;
  {.............................................................}
  procedure SetTagToCurTag;
  begin
    if AutoTag and (info.Tag=0) and (info.StyleNo>=0) and
      (info.StyleNo=FCurTextStyleNo) then
      info.Tag := RV_CopyTag(FCurTag, rvoTagsArePChars in Options)
  end;
  {.............................................................}
  // Inserting before or after non-text item.
  // If inserting a full-line item before the first item in bulleted paragraph,
  // inserting a empty string before, so result will look like
  // {bullet} {empty string (added)}
  // {new full-line item}
  // Special case: marker can be inserted only in place of empty line,
  // not here
  procedure IS_InsertNearNonText(CharPos: TRVCharPos; dli: TRVDrawLineInfo;
    var ItemParaNo: Integer; var InsertPoint: Integer; var ItemsAdded: Integer;
    var FullReformat: Boolean; NoNewLineReset: Boolean);
  var FR: Boolean;
  begin
    {$IFNDEF RVDONOTUSELISTS}
    if info.StyleNo=rvsListMarker then begin
      Result := True;
      info.Free;
      info := nil;
      exit;
    end;
    {$ENDIF}
    if CharPos.Offset=0 then begin // inserting before nontext
      InsertPoint := dli.ItemNo;
      if not GetItem(InsertPoint).SameAsPrev then begin
        info.SameAsPrev := False;
        info.BR := GetItem(InsertPoint).BR;
        if info.BR then
          ItemParaNo := -1;
        if GetItem(InsertPoint).PageBreakBefore then
          info.PageBreakBefore := True;
        info.ClearLeft := GetItem(InsertPoint).ClearLeft;
        info.ClearRight := GetItem(InsertPoint).ClearRight;
        Do_NewLine(InsertPoint, True, -1, FR);
        FullReformat := FullReformat or FR;
        end
      else begin
        ItemParaNo := -1;
        {$IFNDEF RVDONOTUSELISTS}
        if (InsertPoint>0) and (GetItemStyle(InsertPoint-1)=rvsListMarker) and
           (info.GetBoolValue(rvbpFullWidth) or
            ((info.Checkpoint<>nil) and info.Checkpoint.Persistent and
              ItemHasPersistentCheckpoint(InsertPoint-1))) then begin
          InsEmptyString(InsertPoint, 0, GetItemPara(InsertPoint),
            FCurTextStyleNo, True, False);
          inc(InsertPoint);
          inc(ItemsAdded);
        end;
        {$ENDIF}
      end;
      end
    else begin  // inserting after nontext
      ItemParaNo := -1;
      InsertPoint := dli.ItemNo+1;
      if GetItem(dli.ItemNo).GetBoolValue(rvbpFullWidth) then
        info.SameAsPrev := False;
    end;
  end;
  {.............................................................}
  // Replacing an empty line with new item
  // Exception: If inserting a full-line item in bulleted paragraph,
  // we do not replace empty string, but add new item after,
  // so result will look like:
  // {bullet} {old empty string}
  // {new full-line item}
  // Special case: if inserting marker, it deletes empty string and
  // replaces a marker before it (if exists)
  function IS_ReplaceEmptyText(CharPos: TRVCharPos;
                                dli: TRVDrawLineInfo;
                                var ItemParaNo: Integer;
                                var InsertPoint: Integer;
                                var ItemsAdded: Integer;
                                var FullReformat: Boolean): Boolean;
  var curitem: TCustomRVItemInfo;
      FR: Boolean;
      {$IFNDEF RVDONOTUSELISTS}
      PrevMarkerItemNo: Integer;
      {$ENDIF}
  begin
    Result := False;
    if IsSticking(dli.ItemNo-1, False) or
       IsSticking(dli.ItemNo, False) then begin
      info.Free;
      info := nil;
      exit;
    end;
    {$IFNDEF RVDONOTUSELISTS}
    if (dli.ItemNo>0) and (GetItemStyle(dli.ItemNo-1)=rvsListMarker) and
       (info.GetBoolValue(rvbpFullWidth) or
       (NoNewLineReset and not info.SameAsPrev) or
       ((info.Checkpoint<>nil) and info.Checkpoint.Persistent and
        ParaHasPersistentCheckpoint(dli.ItemNo)))
       then
      InsertPoint := dli.ItemNo+1
    else
    {$ENDIF}
    begin
      curitem := GetItem(dli.ItemNo);
      {$IFNDEF RVDONOTUSELISTS}
      if (info.StyleNo=rvsListMarker) and (TRVMarkerItemInfo(info).ListNo>=0) and
         GetRVStyle.ListStyles[TRVMarkerItemInfo(info).ListNo].HasNumbering then begin
        if dli.ItemNo=rvsListMarker then
          PrevMarkerItemNo := dli.ItemNo
        else begin
          PrevMarkerItemNo := dli.ItemNo-1;
          if PrevMarkerItemNo>=0 then begin
            PrevMarkerItemNo := GetFirstParaItem(PrevMarkerItemNo);
            if (GetItemStyle(PrevMarkerItemNo)<>rvsListMarker) then
              PrevMarkerItemNo := -1;
          end;
        end;
        if (PrevMarkerItemNo>=0) and (TRVMarkerItemInfo(GetItem(PrevMarkerItemNo)).ListNo>=0) and
          GetRVStyle.ListStyles[TRVMarkerItemInfo(GetItem(PrevMarkerItemNo)).ListNo].IsSimpleEqual(
            GetRVStyle.ListStyles[TRVMarkerItemInfo(info).ListNo], True, True) then begin
          NewListNo := TRVMarkerItemInfo(GetItem(PrevMarkerItemNo)).ListNo;
          TRVMarkerItemInfo(info).ListNo := NewListNo;
        end;
      end;
      {$ENDIF}
      if not curitem.SameAsPrev then begin
        info.SameAsPrev := False;
        {$IFNDEF RVDONOTUSELISTS}
        if info.StyleNo<>rvsListMarker then
        {$ENDIF}
          info.BR := curitem.BR;
      end;
      if info.BR then
        ItemParaNo := -1;
      if curitem.PageBreakBefore then
        info.ItemOptions := info.ItemOptions+[rvioPageBreakBefore];
      info.ClearLeft := curitem.ClearLeft;
      info.ClearRight := curitem.ClearRight;
      Do_DeleteItem(dli.ItemNo, FR);
      FullReformat := FullReformat or FR;
      InsertPoint := dli.ItemNo;
      dec(ItemsAdded);
      info.ParaNo := FCurParaStyleNo;
      {$IFNDEF RVDONOTUSELISTS}
      if (info.StyleNo=rvsListMarker) and (InsertPoint>0) and
         (GetItemStyle(InsertPoint-1)=rvsListMarker) then begin
        dec(InsertPoint);
        Do_DeleteItem(InsertPoint, FR);
        FullReformat := FullReformat or FR;
        dec(ItemsAdded);
      end;
      {$ENDIF}
    end;
    Result := True;
  end;
  {.............................................................}
  // Inserting in text (before, after, or between)
  // Special case: a full-line item is never inserted before the first text
  // item in bulleted paragraph. In this case, it splits this text item into
  // two parts, one of them is empty:
  // {bullet} {empty string (added) }
  // {new full-line item} { string } { rest of paragraph }
  // Another special case: marker can be inserted only in place of empty line,
  // not here
  function IS_InsertInText(CharPos: TRVCharPos;
                           dli: TRVDrawLineInfo;
                           var ItemParaNo: Integer;
                           var InsertPoint: Integer;
                           var ItemsAdded: Integer;
                           var FullReformat: Boolean): Boolean;
  var newsubstr: TCustomRVItemInfo;
      FR: Boolean;
      NewText: TRVRawByteString;
  begin
    {$IFNDEF RVDONOTUSELISTS}
    if info.StyleNo=rvsListMarker then begin
      Result := True;
      info.Free;
      info := nil;
      exit;
    end;
    {$ENDIF}
    Result := False;
    if (dli.Offs+CharPos.Offset-1<=1)
       {$IFNDEF RVDONOTUSELISTS}
       and not
       (((dli.ItemNo>0) and (GetItemStyle(dli.ItemNo-1)=rvsListMarker)) and
        (info.GetBoolValue(rvbpFullWidth) or
         ((info.Checkpoint<>nil) and info.Checkpoint.Persistent and
           ItemHasPersistentCheckpoint(dli.ItemNo-1))))
       {$ENDIF} then begin // inserting before text
      InsertPoint := dli.ItemNo;
      if IsSticking(InsertPoint-1, False) then begin
        info.Free;
        info := nil;
        exit;
      end;
      if not info.GetBoolValue(rvbpFullWidth) and not GetItem(InsertPoint).SameAsPrev and
        not (NoNewLineReset and (info.StyleNo>=0) and not info.SameAsPrev and (s='')) then begin
        info.SameAsPrev := False;
        info.BR := GetItem(InsertPoint).BR;
        info.PageBreakBefore := GetItem(InsertPoint).PageBreakBefore;
        info.ClearLeft := GetItem(InsertPoint).ClearLeft;
        info.ClearRight := GetItem(InsertPoint).ClearRight;
        if info.BR then
          ItemParaNo := -1;
        Do_NewLine(InsertPoint, True, -1, FR);
        FullReformat := FullReformat or FR;
        end
      else
        ItemParaNo := -1;
      AdjustTag(GetItem(InsertPoint));
      end
    else if dli.Offs+CharPos.Offset-1>ItemLength(dli.ItemNo) then begin // inserting after text
      ItemParaNo := -1;
      InsertPoint := dli.ItemNo+1;
      if IsSticking(InsertPoint-1, False) then begin
        info.Free;
        info := nil;
        exit;
      end;
      AdjustTag(GetItem(InsertPoint-1));
      end
    else begin // inserting in text
      if IsProtected(dli.ItemNo, rvprModifyProtect) then begin
        info.Free;
        info := nil;
        exit;
      end;
      ItemParaNo := -1;
      inc(ItemsAdded);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(dli.ItemNo, dli.Offs+CharPos.Offset-1, True);
      {$ENDIF}
      InsertPoint := dli.ItemNo+1;
      SplitText := Items[dli.ItemNo];
      NewText := RVU_Copy(SplitText, dli.Offs+CharPos.Offset-1,
        RVU_Length(Items[dli.ItemNo], GetItemOptions(dli.ItemNo)),
        GetItemOptions(dli.ItemNo));
      Do_DeleteSubstring(dli.ItemNo, dli.Offs+CharPos.Offset-1, -1);
      newsubstr := RV_CreateTextCopy(TRVTextItemInfo(GetItem(dli.ItemNo)), Self);
      newsubstr.SameAsPrev := True;
      if CallTEEvent then
        DoItemTextEdit(SplitText, dli.ItemNo);
      Do_InsertItem(InsertPoint, NewText, newsubstr, False, FR);
      if CallTEEvent then begin
        DoItemTextEdit(SplitText, InsertPoint);
        SplitText := '';
      end;
      AdjustTag(GetItem(InsertPoint));
      FullReformat := FullReformat or FR;
    end;
    Result := True;
  end;
  {.............................................................}
var dli: TRVDrawLineInfo;
    FR: Boolean;
    ItemParaNo: Integer;
    ItemNo1, ItemNo2: Integer;
begin
  SplitText := '';
  NewListNo := -1;
  FullReformat := False;
  FR := False;
  Result := True;
  ItemsAdded := 1;
  ItemParaNo := info.ParaNo;
  if info.SameAsPrev or (ItemParaNo>=GetRVStyle.ParaStyles.Count) then
    ItemParaNo := -1;
  if not NoNewLineReset and (DrawItems.Count<>0) and
     not info.GetBoolValue(rvbpFullWidth) and
     ((info.Checkpoint=nil) or not info.Checkpoint.Persistent)
     {$IFNDEF RVDONOTUSELISTS}
     and (info.StyleNo<>rvsListMarker)
     {$ENDIF}
   then begin
    info.SameAsPrev := True;
    info.ParaNo := GetItemPara(DrawItems[CaretDrawItemNo].ItemNo);
    end
  else begin
    info.SameAsPrev := False;
    info.ParaNo := FCurParaStyleNo;
  end;
  if IsParaProtected(info.ParaNo,rvpaoReadOnly) then begin
    info.Free;
    info := nil;
    Result := False;
    exit;
  end;
  SetTagToCurTag;
  dli := DrawItems[CharEnds.Items[CaretOffs].DrawItemNo];
  if GetItemStyle(dli.ItemNo)<0 then
    IS_InsertNearNonText(CharEnds.Items[CaretOffs], dli, ItemParaNo, InsertPoint,
      ItemsAdded, FullReformat, False)
  else if (Items[dli.ItemNo]='') then
    Result := IS_ReplaceEmptyText(CharEnds.Items[CaretOffs], dli, ItemParaNo,
      InsertPoint, ItemsAdded, FullReformat)
  else
    Result := IS_InsertInText(CharEnds.Items[CaretOffs], dli, ItemParaNo,
      InsertPoint, ItemsAdded, FullReformat);
  if not Result or (info=nil) then
    exit;
  {$IFNDEF RVDONOTUSELISTS}
  if (InsertPoint-1>=0) and (GetItemStyle(InsertPoint-1)=rvsListMarker) then
    info.SameAsPrev := True;
  {$ENDIF}
  if info.GetBoolValue(rvbpFullWidth) then begin
    if InsertPoint<>Items.Count then begin
       Do_NewLine(InsertPoint, False, -1, FR);
       FullReformat := FullReformat or FR;
       Do_BR(InsertPoint, False, FR);
       FullReformat := FullReformat or FR;
    end;
    if info.StyleNo=rvsBreak then
      info.ParaNo := 0;
  end;
  FullReformat := FullReformat or FR;
  Do_InsertItem(InsertPoint, s, info, False, FR);
  if InsertPoint+1<Items.Count then
    MovePersistentCheckpoint(InsertPoint+1, True);
  if (ItemParaNo>=0) and (ItemParaNo<>info.ParaNo) and (info.StyleNo<>rvsBreak) then begin
    ExpandToPara(InsertPoint, InsertPoint, ItemNo1, ItemNo2);
    Do_Para(ItemNo1, ItemNo2, ItemParaNo, FR);
    FullReformat := FullReformat or FR;
  end;
  if (InsertPoint+1<Items.Count) and not IsParaStart(InsertPoint+1) and
     ItemHasPersistentCheckpoint(InsertPoint+1) then begin
    Do_NewLine(InsertPoint+1, False, -1, FR);
    FullReformat := FullReformat or FR;
  end;
  {$IFNDEF RVDONOTUSELIVESPELL}
  LaterSetBackLiveSpellingTo(InsertPoint, 0, True);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertSomething(info: TCustomRVItemInfo;
  var s, SplitText: TRVRawByteString;
  AutoTag, CaretBefore, CallTEEvent: Boolean): Boolean;
var
  InsertPoint, Dummy : Integer;
  Offs, ItemsAdded: Integer;
  FullReformat : Boolean;
begin
  SplitText := '';
  if (info.StyleNo<>rvsBreak) and ((info.Checkpoint=nil) or not (info.Checkpoint.Persistent)) then
    info.ParaNo := FCurParaStyleNo;
  if (FPartialSelectedItem<>nil) or
     not InsSomething(info, s, SplitText, AutoTag, CallTEEvent, InsertPoint,
       ItemsAdded, FullReformat, Dummy, False) then begin
    Beep;
    Result := False;
    exit;
  end;
  if info=nil then begin
    // only possible if info was a marker, and it was not inserted, but this is
    // not error
    Result := True;
    exit;
  end;
  if (FullReformat or (CalculateMinItemWidthPlusEx(InsertPoint)>DocumentWidth)) and
     (DocumentWidth<>CalculateMinDocWidthPlus(0, nil,nil)) then begin
    Format_(False,True,False,0,GetFormatCanvas,False,False,False,False);
    Invalidate;
    ChangeCaret(False,True,True,False);
    end
  else begin
    FormatParas(CharEnds.Items[0].DrawItemNo, CharEnds.Items[CharEnds.Count-1].DrawItemNo,ItemsAdded);
    {$IFNDEF RVDONOTUSESEQ}
    if info is TRVSeqItemInfo then
      UpdateRangeAfterMarkersOrSeq(InsertPoint, InsertPoint);
    {$ENDIF}
  end;
  if CaretBefore then
    if info.StyleNo<0 then
      Offs := 0
    else
      Offs := 1
  else
    if info.StyleNo<0 then
      Offs := 1
    else
      Offs := RVU_Length(S, GetItemOptions(InsertPoint))+1;
  Item2DrawItem(InsertPoint, Offs, {->} CaretDrawItemNo, Offs, rvdpBetterBelow);
  OnChangeCaretLine(Offs-2);
  ChangeCaret(False, True, False, False);
  DoAfterFormatAndCaretPositioning(True);  
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CreateTextItem(Tag, ParaStyle, FontStyle: Integer;
  SameAsPrev, BR: Boolean): TCustomRVItemInfo;
begin
  Result            := RichViewTextItemClass.Create(Self);
  Result.StyleNo    := FontStyle;
  Result.ParaNo     := ParaStyle;
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[GetActualStyle(Result)].Unicode then
    Include(Result.ItemOptions,rvioUnicode);
  {$ENDIF}
  Result.SameAsPrev := SameAsPrev;
  Result.BR         := BR;
  Result.Tag        := Tag;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CreateTextItem2(Tag: Integer; Source: TCustomRVItemInfo;
  SameAsPrev, BR: Boolean): TCustomRVItemInfo;
begin
  Result            := RichViewTextItemClass.Create(Self);
  Result.Assign(Source);
  Result.ItemOptions := [];
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[Result.StyleNo].Unicode then
    Include(Result.ItemOptions,rvioUnicode);
  {$ENDIF}
  Result.SameAsPrev := SameAsPrev;
  Result.BR         := BR;
  Result.Tag        := Tag;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsString(s: TRVRawByteString; Index, Tag: Integer;
  ParaStyle, FontStyle: Integer; SameAsPrev, BR: Boolean;
  var FullReformat: Boolean): TCustomRVItemInfo;
begin
  Result := CreateTextItem(Tag, ParaStyle, FontStyle, SameAsPrev, BR);
  Do_InsertItem(Index, s, Result, False, FullReformat);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsString2(s: TRVRawByteString; Index, Tag: Integer;
  Source: TCustomRVItemInfo; SameAsPrev, BR: Boolean;
  var FullReformat: Boolean): TCustomRVItemInfo;
begin
  Result := CreateTextItem2(Tag, Source, SameAsPrev, BR);
  Do_InsertItem(Index, s, Result, False, FullReformat);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsEmptyString(Index, Tag, ParaStyle, FontStyle: Integer; SameAsPrev, BR: Boolean): TCustomRVItemInfo;
var FullReformat: Boolean;
begin
  Result := InsString('', Index, Tag, ParaStyle, FontStyle, SameAsPrev, BR, FullReformat);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CanDelete: Boolean;
var i, StyleNo: Integer;
    StartNo, EndNo, StartOffs, EndOffs: Integer;
    {................................................}
    function CompletelySelected(a,b, ItemNo: Integer): Boolean;
    begin
      Result := (a<=GetOffsBeforeItem(ItemNo)) and
                (b>=GetOffsAfterItem(ItemNo));
    end;
    {................................................}
    function NotSelected(a,b, ItemNo: Integer): Boolean;
    begin
      Result := (a=b) or (b<=GetOffsBeforeItem(ItemNo)) or
                (a>=GetOffsAfterItem(ItemNo));
    end;
    {................................................}
    function CD(a,b, ItemNo, StyleNo: Integer): Boolean;
    var Protection : TRVProtectOptions;
    begin
      if NotSelected(a, b, ItemNo) then
        Result := True
      else begin
        if StyleNo<0 then begin
          Result := not IsProtected(ItemNo, rvprDeleteProtect);
          end
        else begin
          Protection := GetRVStyle.TextStyles[StyleNo].Protection;
          Result := False;
          if (rvprDeleteProtect in Protection) and
             CompletelySelected(a,b, ItemNo) then exit;
          if (rvprModifyProtect in Protection) and
             not CompletelySelected(a,b, ItemNo) then exit;
          Result := True;
        end;
      end;
    end;
    {................................................}
    // Searching "persistent" checkpoints in the selected paragraphs
    // (not including the first one)
    function HasNonFirstPersistentCheckpoints: Boolean;
    var nonfirst: Boolean;
        i: Integer;
    begin
       Result := True;
       nonfirst := False;
       for i := StartNo+1 to EndNo do begin
         if not nonfirst and IsParaStart(i) then
           nonfirst := True;
         if nonfirst and ItemHasPersistentCheckpoint(i) then
           exit;
       end;
       if nonfirst then
         for i := EndNo+1 to ItemCount-1 do begin
           if IsParaStart(i) then
             break;
           if ItemHasPersistentCheckpoint(i) then
             exit;
         end;
       Result := False;
    end;
    {................................................}
begin
  if not SelectionExists(True, False) then begin
    if FPartialSelectedItem<>nil then
      Result := FPartialSelectedItem.CanDeletePartiallySelected
    else
      Result := True;
    exit;
  end;
  {$IFNDEF RVDONOTUSEINPLACE}
  if (GetChosenRVData<>nil) then begin
    if (GetChosenRVData is TRVEditRVData) then
      Result := TRVEditRVData(GetChosenRVData).CanDelete
    else
      Result := False;
    exit;
  end;
  {$ENDIF}
  Result := False;
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  for i := StartNo+1 to EndNo-1 do begin
    if IsProtected(i, rvprDeleteProtect) then
      exit;
  end;
  if (StartNo<>EndNo) then begin
    StyleNo := GetItemStyle(StartNo);
    if not CD(StartOffs, GetOffsAfterItem(StartNo), StartNo, StyleNo) then exit;
    StyleNo := GetItemStyle(EndNo);
    if not CD(GetOffsBeforeItem(EndNo), EndOffs, EndNo, StyleNo) then exit;
    end
  else begin
    StyleNo := GetItemStyle(StartNo);
    if not CD(StartOffs, EndOffs, StartNo, StyleNo) then exit;
  end;
  if IsItemParaProtected(StartNo) and
       (not IsParaStart(StartNo) or
        (StartOffs>GetOffsBeforeItem(StartNo))) then
      exit;
  if IsItemParaProtected(EndNo) and
       ((EndOffs<GetOffsAfterItem(EndNo)) or
        ((EndNo<Items.Count-1) and
         not IsParaStart(EndNo+1))
        ) then
      exit;
  if IsItemParaProtected(StartNo) and (StartNo=EndNo) and (StartOffs=EndOffs) then
    exit;
  Result := not IsParaProtected(FCurParaStyleNo,rvpaoReadOnly) and
    not HasNonFirstPersistentCheckpoints;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Reformat_(FullFormat: Boolean; StartDrawItem, EndDrawItem,
  ItemsAdded: Integer);
begin
  if FullFormat and (DocumentWidth<>CalculateMinDocWidthPlus(0,nil,nil)) then begin
    Format_(False, True, False, 0, GetFormatCanvas, False, False,False, False);
    Invalidate;
    end
  else
    FormatParas(StartDrawItem, EndDrawItem, ItemsAdded);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.DeleteSelection_: Boolean;
var  StartNo, EndNo, StartOffs, EndOffs, TagForEmptyItem: Integer;
     {$IFNDEF RVDONOTUSEDRAGDROP}
     DragDropCaretInfo: TRVDragDropCaretInfo;
     {$ENDIF}
    {........................................................}
    // Searching the checkpoint with "persistent" flag in the
    // first selected paragraph; if found, moving it to the
    // first selected item or (if this item is not the first
    // in paragraph and selected completely) to the item
    // before the first selected one
    procedure MovePersistentCP;
    var i: Integer;
        CPItemNo: Integer;
        MultiParagraphSelection: Boolean;
    begin
      CPItemNo := -1;
      MultiParagraphSelection := False;
      if ItemHasPersistentCheckpoint(StartNo) and
         (StartOffs<GetOffsAfterItem(StartNo)) then
        CPItemNo := StartNo
      else begin
        for i := StartNo+1 to EndNo-1 do begin
          if IsParaStart(i) then begin
            MultiParagraphSelection := True;
            break;
          end;
          if ItemHasPersistentCheckpoint(i) then begin
            CPItemNo := i;
            break
          end;
        end;
        if not MultiParagraphSelection and (EndNo>StartNo) and
           not IsParaStart(EndNo) and (EndOffs>=GetOffsAfterItem(EndNo)) and
           ItemHasPersistentCheckpoint(EndNo) then
          CPItemNo := EndNo;
      end;
      if CPItemNo>=0 then begin
        if (StartOffs<=GetOffsBeforeItem(StartNo)) and
           (StartNo>0) and not IsParaStart(StartNo) then
          i := StartNo-1
        else
          i := StartNo;
        if i<CPItemNo then
          Do_MoveCP(CPItemNo, i);
      end;
    end;
    {........................................................}
    // Deleting selection consisting of multiple items.
    // Step 1: Deleting from last item (which is selected completely or partially)
    procedure DelSel_DelFromLastItem(var FullReformat, ShouldAddEmpty,
      SubstringDeleted: Boolean; var ItemsDeleted, DeletedWidth: Integer);
    var FR: Boolean;
        OldText: TRVRawByteString;
    begin
      DeletedWidth := CalculateMinItemWidthPlusEx(EndNo);
      SubstringDeleted := False;
      FR := False;
      if EndOffs>=GetOffsAfterItem(EndNo) then begin
        // last item is selected completely - deleting it
        ShouldAddEmpty := (EndNo=Items.Count-1) or
                          not GetItem(EndNo+1).SameAsPrev;
        Do_DeleteItem(EndNo,FR);
        FullReformat := FullReformat or FR;
        inc(ItemsDeleted);
        {$IFNDEF RVDONOTUSEDRAGDROP}
        if (DragDropCaretInfo<>nil) then begin
          if DragDropCaretInfo.ItemNo=EndNo then
            DragDropCaretInfo.ItemOffs := GetOffsAfterItem(EndNo-1);
          dec(DragDropCaretInfo.ItemNo);
        end;
        {$ENDIF}
        end
      else begin
        // deleting substring from last item }
        if GetItemStyle(EndNo)>=0 then begin
          {$IFNDEF RVDONOTUSELIVESPELL}
          GetItem(EndNo).ClearWordPainters(0);
          {$ENDIF}
          OldText := Items[EndNo];
          Do_DeleteSubstring(EndNo, 1, EndOffs-1);
          DoItemTextEdit(OldText, EndNo);
        end;
        {$IFNDEF RVDONOTUSEDRAGDROP}
        if (DragDropCaretInfo<>nil) and (DragDropCaretInfo.ItemNo=EndNo) then
          dec(DragDropCaretInfo.ItemOffs, EndOffs-1);
        {$ENDIF}
        SubstringDeleted := True;
        ShouldAddEmpty := False;
      end;
    end;
    {........................................................}
    // Deleting selection consisting of multiple items.
    // Step 2: Deleting all items except from the first and the last one
    procedure DelSel_DelMiddleItems(var FullReformat: Boolean;
                                    var ItemsDeleted, DeletedWidth: Integer);
    var DeletedWidth1: Integer;
        FR: Boolean;
    begin
      FR := False;
      DeletedWidth1 := CalculateMinItemsWidthPlusEx(StartNo+1,EndNo-1);
      if DeletedWidth<DeletedWidth1 then
        DeletedWidth := DeletedWidth1;
      inc(ItemsDeleted,EndNo-StartNo-1);
      Do_DeleteItems(StartNo+1,EndNo-1,FR);
      {$IFNDEF RVDONOTUSEDRAGDROP}
      if (DragDropCaretInfo<>nil) then begin
        if (DragDropCaretInfo.ItemNo=EndNo-1) and (EndNo-StartNo-1>0) then
          DragDropCaretInfo.ItemOffs := GetOffsAfterItem(StartNo);
        dec(DragDropCaretInfo.ItemNo, EndNo-StartNo-1);
      end;
      {$ENDIF}
      FullReformat := FullReformat or FR;
    end;
    {........................................................}
    // Deleting selection consisting of multiple items.
    // Step 3: Deleting from the first item (which is selected completely or partially)
    // or
    // Deleting selection consisting of one item.
    procedure DelSel_DelFromFirstItem(StartOffs, EndOffs: Integer;
      var FullReformat, ShouldAddEmpty, SubstringDeleted: Boolean;
      var ItemsDeleted, DeletedWidth, ItemNo, ItemOffs: Integer);
    var item: TCustomRVItemInfo;
        FR, DeletedBR, DeletedSAP, NewPara: Boolean;
        DeletedWidth1, ParaNo: Integer;
        CPForEmptyString: TRVCPInfo;
        OldText: TRVRawByteString;
        WasTextItem: Boolean;
    begin
      CPForEmptyString := nil;
      DeletedWidth1 := CalculateMinItemWidthPlusEx(StartNo);
      if DeletedWidth<DeletedWidth1 then
        DeletedWidth := DeletedWidth1;
      item := GetItem(StartNo);
      if (StartOffs<=GetOffsBeforeItem(StartNo)) and
         (EndOffs  >=GetOffsAfterItem(StartNo)) then begin
        // first item is selected completely
        NewPara := not item.SameAsPrev;
        if ShouldAddEmpty then begin
          if not NewPara then
            ShouldAddEmpty := False;
//          if (ItemCount>1) and (GetRVStyle.SelectionMode=rvsmParagraph) then
//            ShouldAddEmpty := False;
          {$IFNDEF RVDONOTUSELISTS}
          if not ShouldAddEmpty and (StartNo>0) and (GetItemStyle(StartNo-1)=rvsListMarker) then
            ShouldAddEmpty := True;
          {$ENDIF}
          if ShouldAddEmpty and ItemHasPersistentCheckpoint(StartNo) then
            CPForEmptyString := item.Checkpoint.CreateCopy(rvoTagsArePChars in Options);
        end;
        DeletedBR := item.BR;
        DeletedSAP := item.SameAsPrev;
        ParaNo    := item.ParaNo;
        if not ShouldAddEmpty then
          MovePersistentCheckpoint(StartNo, False);
        WasTextItem := GetItemStyle(StartNo)>=0;
        OldText := Items[StartNo];
        Do_DeleteItem(StartNo,FR);
        inc(ItemsDeleted);
        FullReformat := FullReformat or FR;
        if ShouldAddEmpty then begin
          InsEmptyString(StartNo, TagForEmptyItem, ParaNo, FCurTextStyleNo, DeletedSAP, DeletedBR);
          if WasTextItem then
            DoItemTextEdit(OldText, StartNo);
          TagForEmptyItem := 0;
          if CPForEmptyString<>nil then
            Do_AddCP(StartNo, CPForEmptyString);
          dec(ItemsDeleted);
          ItemNo := StartNo;
          ItemOffs := 1;
          end
        else if NewPara and (StartNo<Items.Count)  then begin
          if not ((StartNo>0) and IsProtected(StartNo, rvprParaStartProtect)) then begin
            Do_NewLine(StartNo,False,-1,FR);
            FullReformat := FullReformat or FR;
            Do_BR(StartNo, DeletedBR, FR);
            FullReformat := FullReformat or FR;
          end;
          ItemNo := StartNo;
          ItemOffs := GetOffsBeforeItem(ItemNo);
          end
        else begin
          ItemNo := StartNo-1;
          ItemOffs := GetOffsAfterItem(ItemNo);
          if (StartNo<Items.Count) and SubstringDeleted then begin
            Do_NewLine(StartNo,True,-1,FR);
            FullReformat := FullReformat or FR;
          end;
        end;
        {$IFNDEF RVDONOTUSEDRAGDROP}
        if (DragDropCaretInfo<>nil) then begin
          if DragDropCaretInfo.ItemNo=StartNo then begin
            DragDropCaretInfo.ItemNo := ItemNo;
            DragDropCaretInfo.ItemOffs := ItemOffs;
            end
          else if not ShouldAddEmpty then
            dec(DragDropCaretInfo.ItemNo);
        end;
        {$ENDIF}
        end
      else begin
        // deleting substring from the first item
        if GetItemStyle(StartNo)>=0 then begin
          OldText := Items[StartNo];
          Do_DeleteSubstring(StartNo, StartOffs, EndOffs-StartOffs);
          DoItemTextEdit(OldText, StartNo);
          {$IFNDEF RVDONOTUSEDRAGDROP}
          if (DragDropCaretInfo<>nil) then begin
            if DragDropCaretInfo.ItemNo=StartNo then
              dec(DragDropCaretInfo.ItemOffs, EndOffs-StartOffs);
          end;
          {$ENDIF}
        end;
        ItemNo := StartNo;
        ItemOffs := StartOffs;
        if (StartNo+1<Items.Count) then
          if GetItem(StartNo).GetBoolValue(rvbpFullWidth) then begin
            Do_NewLine(StartNo+1,False,-1,FR);
            FullReformat := FullReformat or FR;
            end
          else if SubstringDeleted then begin
            Do_NewLine(StartNo+1,True,-1,FR);
            FullReformat := FullReformat or FR;
          end;
      end;
    end;
    {........................................................}
var DIStartNo, DIEndNo, DIStartOffs, DIEndOffs: Integer;
    ItemsDeleted, DeletedWidth, ACaretItemNo, ACaretOffs: Integer;
    FullReformat, ShouldAddEmpty, SubstringDeleted: Boolean;
    {$IFDEF RVUSELISTORSEQ}
    MS_FirstItemNo: Integer;
    M_LastMarkerIndex: Integer;
    M_ListNos: TRVIntegerList;
    S_LastSeqIndex: Integer;
    S_SeqNames: TStringList;
    {$ENDIF}
begin
  Result := True;
  if not SelectionExists(True, False) then begin
    if (FPartialSelectedItem<>nil) then begin
      Result := FPartialSelectedItem.CanDeletePartiallySelected;
      if Result then
        FPartialSelectedItem.DeletePartiallySelected
      else
        Beep;
      end
    else
      Result := True;
    exit;
  end;
  if not CanDelete or (GetChosenRVData<>nil) then begin
    Beep;
    Result := False;
    exit;
  end;
  {$IFNDEF RVDONOTUSEDRAGDROP}
  DragDropCaretInfo := GetDragDropCaretInfo;
  if DragDropCaretInfo<>nil then
    if DragDropCaretInfo.RVData<>Self then
      DragDropCaretInfo := nil
    else begin
      if Item_InsideSelection(DragDropCaretInfo.ItemNo, DragDropCaretInfo.ItemOffs, True) then begin
        Beep;
        Result := False;
        exit;
      end;
    end;
  {$ENDIF}
  BeginUndoSequence(rvutDelete, True);
  GetSelBounds(DIStartNo, DIEndNo, DIStartOffs, DIEndOffs, True);
  GetParaBoundsEx(DIStartNo,DIEndNo,DIStartNo,DIEndNo, True);
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, False);
  if FCurTextStyleNo = GetItemStyle(EndNo) then
    TagForEmptyItem := RV_CopyTag(GetItemTag(EndNo), rvoTagsArePChars in Options)
  else
    TagForEmptyItem := 0;
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  {$IFNDEF RVDONOTUSEDRAGDROP}
  if (DragDropCaretInfo<>nil) and
    ((DragDropCaretInfo.ItemNo<EndNo) or
    ((DragDropCaretInfo.ItemNo=EndNo) and
     (DragDropCaretInfo.ItemOffs<=EndOffs))) then
    DragDropCaretInfo := nil;
  {$ENDIF}
  Deselect(nil, False);

  if (StartNo>0) and GetItem(StartNo).SameAsPrev and
     (StartOffs<=GetOffsBeforeItem(StartNo)) then begin
     dec(StartNo);
     StartOffs := GetOffsAfterItem(StartNo);
  end;
  {$IFNDEF RVDONOTUSELISTS}
  AdjustMarkerPos(StartNo, StartOffs, True);
  AdjustMarkerPos(EndNo,   EndOffs, True);
  {$ENDIF}
  ItemsDeleted := 0;
  DeletedWidth := 0;
  ShouldAddEmpty := True;
  FullReformat := False;
  SubstringDeleted := False;
  {$IFDEF RVUSELISTORSEQ}
  PrepareForUpdateRangeAfterMarkersOrSeq(StartNo, EndNo, True, MS_FirstItemNo,
  M_LastMarkerIndex, S_LastSeqIndex, M_ListNos, S_SeqNames);
  {$ENDIF}
  MovePersistentCP;
  if StartNo=EndNo then begin
    // one item is selected
    ShouldAddEmpty := (EndNo+1>=Items.Count) or not GetItem(EndNo+1).SameAsPrev;
    DelSel_DelFromFirstItem(StartOffs, EndOffs, FullReformat, ShouldAddEmpty,
      SubstringDeleted, ItemsDeleted, DeletedWidth, ACaretItemNo, ACaretOffs)
    end
  else begin { delete selected itemS }
    DelSel_DelFromLastItem(FullReformat, ShouldAddEmpty, SubstringDeleted,
                           ItemsDeleted, DeletedWidth);
    DelSel_DelMiddleItems(FullReformat, ItemsDeleted, DeletedWidth);
    DelSel_DelFromFirstItem(StartOffs, GetOffsAfterItem(StartNo), FullReformat,
      ShouldAddEmpty, SubstringDeleted,  ItemsDeleted, DeletedWidth,
      ACaretItemNo, ACaretOffs);
  end;
  if (ACaretItemNo+1<Items.Count) and
    RV_CanConcateItems(ACaretItemNo, GetItem(ACaretItemNo), GetItem(ACaretItemNo+1), False, False) then begin
    {$IFNDEF RVDONOTUSEDRAGDROP}
    if (DragDropCaretInfo<>nil) then begin
      if DragDropCaretInfo.ItemNo=ACaretItemNo+1 then begin
        dec(DragDropCaretInfo.ItemNo);
        inc(DragDropCaretInfo.ItemOffs, ItemLength(ACaretItemNo));
        end
      else if DragDropCaretInfo.ItemNo>ACaretItemNo+1 then
        dec(DragDropCaretInfo.ItemNo);
    end;
    {$ENDIF}
    Do_Concate(ACaretItemNo);
    inc(ItemsDeleted);
  end;
  {$IFNDEF RVDONOTUSELIVESPELL}
  LaterSetBackLiveSpellingTo(ACaretItemNo, 0, True);
  {$ENDIF}
  Reformat_(FullReformat or (DeletedWidth>=DocumentWidth), DIStartNo, DIEndNo, -ItemsDeleted);
  Item2DrawItem(ACaretItemNo, ACaretOffs, CaretDrawItemNo, CaretOffs, rvdpBetterBelow);
  {$IFNDEF RVDONOTUSELISTS}
  AdjustMarkerCaret(True, CaretOffs);
  {$ENDIF}
  OnChangeCaretLine(CaretOffs-2);
  ChangeCaret(False,True,True,False);
  ApplyParaStyle(GetItemPara(ACaretItemNo), rvscParaStyle, False);
  {$IFDEF RVUSELISTORSEQ}
  UpdateAfterMarkersOrSeq(GetFirstParaItem(StartNo),
    M_LastMarkerIndex, S_LastSeqIndex, M_ListNos, S_SeqNames);
  M_ListNos.Free;
  S_SeqNames.Free;
  {$ENDIF}
  if (TagForEmptyItem<>0) and (rvoTagsArePChars in Options) then
    StrDispose(PChar(TagForEmptyItem));
  DoAfterFormatAndCaretPositioning(True);
  Change;
  DoSelect;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnEnterPress_(Shift: Boolean; Recursive: Boolean): Boolean;
    {................................................................}
    procedure UpdateCaretAtTheBeginningOfLine;
    begin
      CaretOffs := GetOffsBeforeDrawItem(CaretDrawItemNo);
      {$IFNDEF RVDONOTUSELISTS}
      AdjustMarkerCaret(True, CaretOffs);
      {$ENDIF}
      OnChangeCaretLine(CaretOffs-2);
      ChangeCaret(False,True,False,False);
    end;
    {................................................................}
    // Adding an empty line before or after the current paragraph section
    // Paragraph section bounds are calculated taking hidden items into account
    function AddEmptyLine(DrawItem: TRVDrawLineInfo): Boolean;
    var NewItem, SrcItem: TCustomRVItemInfo;
        ItemsAdded, InsertPoint, SrcItemNo, PrevItemNo, Last,
        StartPSItemNo, EndPSItemNo: Integer;
        //FullReformat,
        FR, Protectd: Boolean;
        s: TRVRawByteString;
        {$IFNDEF RVDONOTUSELISTS}
        AddedMarkerItemNo : Integer;
        {$ENDIF}
    begin
      Result := False;
      //FullReformat := False;
      Protectd := IsProtected(DrawItem.ItemNo, rvprParaStartProtect);
      if not Protectd then
        if (CaretOffs>0) or (CharEnds.Count=1) then
          Protectd := IsSticking(DrawItem.ItemNo, True)
        else
          Protectd := IsSticking(DrawItem.ItemNo-1, True);
      if Protectd then begin
        Beep;
        exit;
      end;

      Result := True;
      ItemsAdded := 1;
      {$IFNDEF RVDONOTUSELISTS}
      AddedMarkerItemNo := -1;
      {$ENDIF}
      SrcItemNo := DrawItem.ItemNo;
      SrcItem := GetItem(SrcItemNo);
      PrevItemNo := GetPrevNonHiddenItemNo(SrcItemNo);
      ExpandToParaSection(SrcItemNo, SrcItemNo, StartPSItemNo, EndPSItemNo);
      if IsHidden(StartPSItemNo) then
        while (StartPSItemNo-1>=0) and IsHidden(StartPSItemNo-1) do
          dec(StartPSItemNo);
      if IsHidden(EndPSItemNo) then
        while (EndPSItemNo+1<ItemCount) and IsHidden(EndPSItemNo+1) do
          inc(EndPSItemNo);
      {$IFNDEF RVDONOTUSELISTS}
      if GetItemStyle(StartPSItemNo)=rvsListMarker then
        inc(StartPSItemNo);
      {$ENDIF}
      // Correcting Shift for the case of hidden text before/after the current item
      if CaretOffs=CharEnds.Count-1 then begin
        // will be inserting after
        if GetItemPara(EndPSItemNo)<>GetItemPara(SrcItemNo) then
          Shift := False;
        end
      else begin
        // will be inserting before.
        // it will require assigning BR to the StartPSItemNo-th item
        if StartPSItemNo<>SrcItemNo then
          Shift := False;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if not Shift and not Recursive and (SrcItem.StyleNo>=0) and
         not RichViewEditEnterAllowsEmptyMarkeredLines and
        (GetItemTextR(SrcItemNo)='') and (PrevItemNo>=0) and
        (GetItemStyle(PrevItemNo)=rvsListMarker) then begin
        // removing list marker from the current line before adding a new line
        OnBackSpacePress_(False, False, False);
        OnEnterPress_(Shift, True);
        exit;
      end;
      {$ENDIF}
      NewItem := RichViewTextItemClass.Create(Self);
      // if we at the end of line, and the current item's style is a current text style,
      // and NextStyleNo for the current text style is defined, applying it
      if (CaretOffs=CharEnds.Count-1) and
         (SrcItem.StyleNo=FCurTextStyleNo) and
         (GetRVStyle.TextStyles[GetActualCurStyleNo].NextStyleNo<>-1) then
         SetCurTextStyleNo(GetRVStyle.TextStyles[GetActualCurStyleNo].NextStyleNo);
      // if we are adding a paragraph break,
      // and if we are at the end of paragraph (when calculating the last paragraph
      // item, we take hidden items into account; but not for checking paragraph start)...
      if not Shift and ((EndPSItemNo+1>=ItemCount) or not GetItem(EndPSItemNo+1).BR) then
        // if NextParaNo is defined for the current item's paragraph, or if this
        // paragraph is read-only, we apply either NextParaNo or (if not possible) 0
        if IsParaProtected(SrcItem.ParaNo,rvpaoReadOnly) or
           ((CaretOffs=CharEnds.Count-1) and
           (GetRVStyle.ParaStyles[SrcItem.ParaNo].NextParaNo<>-1)) then
          if GetRVStyle.ParaStyles[SrcItem.ParaNo].NextParaNo>=0 then
             SetCurParaStyleNo(GetRVStyle.ParaStyles[SrcItem.ParaNo].NextParaNo)
          else
             SetCurParaStyleNo(0);
      // preventing addition of Modify-Protect item
      if rvprModifyProtect in GetRVStyle.TextStyles[GetActualCurStyleNo].Protection then
        NewItem.StyleNo := 0
      else
        NewItem.StyleNo := FCurTextStyleNo;
      if Shift then
        NewItem.ParaNo := GetItemPara(SrcItemNo)
      else
        NewItem.ParaNo := FCurParaStyleNo;
      {$IFNDEF RVDONOTUSEUNICODE}
      if GetRVStyle.TextStyles[GetActualStyle(NewItem)].Unicode then
        Include(NewItem.ItemOptions, rvioUnicode);
      {$ENDIF}
      NewItem.SameAsPrev := False;
      if Shift then begin
        if CaretOffs=CharEnds.Count-1 then
          // inserting after...
          NewItem.BR := True
        else begin
          // inserting before...
          NewItem.BR := GetItem(SrcItemNo).BR;
          Do_BR(StartPSItemNo,True,FR);
          //FullReformat := FullReformat or FR;
        end;
      end;
      if SrcItem.StyleNo=NewItem.StyleNo then begin
        NewItem.Tag := RV_CopyTag(SrcItem.Tag, rvoTagsArePChars in Options);
        {$IFNDEF RVDONOTUSEITEMHINTS}
        NewItem.Hint := SrcItem.Hint;
        {$ENDIF}
      end;
      if CaretOffs=CharEnds.Count-1 then begin
        // inserting after...
        InsertPoint := EndPSItemNo+1;
        {$IFNDEF RVDONOTUSELISTS}
        if not Shift and (NewItem.ParaNo=SrcItem.ParaNo) and
           ReplicateMarker(SrcItemNo, InsertPoint, FR, True, False) then begin
          //FullReformat := FullReformat or FR;
          AddedMarkerItemNo := InsertPoint;
          inc(ItemsAdded);
          inc(InsertPoint);
          NewItem.SameAsPrev := True;
        end;
        {$ENDIF}
        Last := InsertPoint;
        end
      else begin
        InsertPoint := StartPSItemNo;
        Last := SrcItemNo+1;
        {$IFNDEF RVDONOTUSELISTS}
        if Shift then begin
          if (StartPSItemNo>0) and (GetItemStyle(StartPSItemNo-1)=rvsListMarker) then begin
            NewItem.SameAsPrev := True;
            Do_NewLine(StartPSItemNo, False,-1, FR);
            //FullReformat := FullReformat or FR;
            Do_BR(StartPSItemNo, True, FR);
            //FullReformat := FullReformat or FR;
          end;
          end
        else begin
          if (StartPSItemNo>0) and (GetItemStyle(StartPSItemNo-1)=rvsListMarker) then
            NewItem.SameAsPrev := True;
          if ReplicateMarker(StartPSItemNo, StartPSItemNo, FR, True, True) then begin
            //FullReformat := FullReformat or FR;
            AddedMarkerItemNo := StartPSItemNo+1;
            Do_NewLine(StartPSItemNo+1,True,-1,FR);
            //FullReformat := FullReformat or FR;
            inc(ItemsAdded);
            inc(Last);
            end
          else
            Do_NewLine(StartPSItemNo, False,-1, FR);
        end;
        {$ENDIF}
        SrcItemNo := Last;
      end;
      s := '';
      Do_InsertItem(InsertPoint, s, NewItem, False, FR);
      if (InsertPoint<SrcItemNo) and not IsProtected(SrcItemNo, rvprModifyProtect) then
        Do_MoveCP(SrcItemNo, InsertPoint);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(InsertPoint, 0, True);
      {$ENDIF}
      // FullReformat := FullReformat or FR;
      FormatParas(CharEnds.Items[0].DrawItemNo, CharEnds.Items[CharEnds.Count-1].DrawItemNo, ItemsAdded);
      Item2FirstDrawItem(Last, CaretDrawItemNo);
      UpdateCaretAtTheBeginningOfLine;
      {$IFNDEF RVDONOTUSELISTS}
      UpdateRangeAfterMarkersOrSeq(AddedMarkerItemNo,AddedMarkerItemNo);
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);
    end;
    {................................................................}
    // Moving the item to the right of caret to the new line
    // (or adding a marker instead)
    // This procedure is rarely executed, usually the item
    // to the right of the caret is not a current
    function WrapCurrentItem(DrawItem: TRVDrawLineInfo; OldWidth: Integer;
      NoWrap: Boolean): Boolean;
    var PItem1, PItem2, Last, ItemsAdded: Integer;
        FullReformat, FR: Boolean;
        {$IFNDEF RVDONOTUSELISTS}
        AddedMarkerItemNo : Integer;
        {$ENDIF}
    begin
      Result := False;
      if IsProtected(DrawItem.ItemNo, rvprParaStartProtect) or
        IsSticking(DrawItem.ItemNo-1, True) then begin
        Beep;
        exit;
      end;
      Result := True;
      {$IFNDEF RVDONOTUSELISTS}
      AddedMarkerItemNo := -1;
      {$ENDIF}
      FullReformat := False;
      GetParaBoundsEx(CharEnds.Items[0].DrawItemNo,
                   CharEnds.Items[CharEnds.Count-1].DrawItemNo,
                   PItem1, PItem2, True);
      ItemsAdded := 0;
      if Shift then begin
        Do_NewLine(DrawItem.ItemNo,False,-1, FR);
        FullReformat := FullReformat or FR;
        Do_BR(DrawItem.ItemNo,True, FR);
        FullReformat := FullReformat or FR;
        end
      else begin
       {$IFNDEF RVDONOTUSELISTS}
       if ReplicateMarker(DrawItem.ItemNo-1, DrawItem.ItemNo, FR, True, True) then begin
         {$IFNDEF RVDONOTUSELIVESPELL}
         LaterSetBackLiveSpellingTo(DrawItem.ItemNo, 0, True);
         {$ENDIF}
         AddedMarkerItemNo := DrawItem.ItemNo;
         FullReformat := FullReformat or FR;
         inc(ItemsAdded);
         end
       else
       {$ENDIF}
       begin
         Do_NewLine(DrawItem.ItemNo,False,-1, FR);
         FullReformat := FullReformat or FR;
       end;
      end;
      Last := DrawItem.ItemNo;
      Reformat_((NoWrap and (OldWidth>=DocumentWidth)) or FullReformat, PItem1, PItem2,ItemsAdded);
      Item2FirstDrawItem(Last, CaretDrawItemNo);
      UpdateCaretAtTheBeginningOfLine;
      {$IFNDEF RVDONOTUSELISTS}
      UpdateRangeAfterMarkersOrSeq(AddedMarkerItemNo,AddedMarkerItemNo);
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);
    end;
    {................................................................}
    // Moving the item to the right of caret to the new line
    // (or adding a marker instead)
    function WrapNextItem(OldWidth: Integer;
      NoWrap: Boolean): Boolean;
    var PItem1, PItem2, Last, ItemsAdded, DrawItemNo, ItemNo: Integer;
        FullReformat, FR: Boolean;
        {$IFNDEF RVDONOTUSELISTS}
        AddedMarkerItemNo : Integer;
        {$ENDIF}
    begin
      Result := False;
      DrawItemNo := CaretDrawItemNo+1;
      if DrawItemNo>=DrawItems.Count then
        exit;
      ItemNo := DrawItems[DrawItemNo].ItemNo;
      if IsFromNewLine(ItemNo) then
        exit;
      if IsProtected(ItemNo, rvprParaStartProtect) or
         IsSticking(ItemNo-1, True) then begin
         Beep;
         exit;
      end;
      GetParaBoundsEx(DrawItemNo, DrawItemNo, PItem1, PItem2, True);
      Result := True;
      {$IFNDEF RVDONOTUSELISTS}
      AddedMarkerItemNo := -1;
      {$ENDIF}
      FullReformat := False;
      Last := ItemNo;
      ItemsAdded := 0;
      if Shift then begin
         Do_NewLine(Last,False,-1, FR);
         FullReformat := FullReformat or FR;
         Do_BR(Last,True,FR);
         FullReformat := FullReformat or FR;
       end
      else begin
        {$IFNDEF RVDONOTUSELISTS}
        if ReplicateMarker(Last, Last, FR, True, True) then begin
         {$IFNDEF RVDONOTUSELIVESPELL}
         LaterSetBackLiveSpellingTo(Last, 0, True);
         {$ENDIF}
          AddedMarkerItemNo := Last;
          FullReformat := FullReformat or FR;
          inc(ItemsAdded);
          end
        else
        {$ENDIF}
        begin
          Do_NewLine(Last,False,-1, FR);
          FullReformat := FullReformat or FR;
        end;
      end;
      CaretDrawItemNo := DrawItemNo;
      if CaretDrawItemNo>PItem2 then
        PItem2 := CaretDrawItemNo;
      Reformat_((NoWrap and (OldWidth>=DocumentWidth)) or FullReformat, PItem1, PItem2,ItemsAdded);
      Item2FirstDrawItem(Last, CaretDrawItemNo);
      UpdateCaretAtTheBeginningOfLine;
      {$IFNDEF RVDONOTUSELISTS}
      UpdateRangeAfterMarkersOrSeq(AddedMarkerItemNo,AddedMarkerItemNo);
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);
    end;
    {................................................................}
    // Breaking a text line (removing part of text after caret,
    // adding it as a new item from new line; adding marker if needbe)
    function BreakTextItem(dli: TRVDrawLineInfo; OldWidth: Integer;
      NoWrap: Boolean): Boolean;
    var PItem1, PItem2, InsertPoint, ItemsAdded: Integer;
        li: TCustomRVItemInfo;
        FullReformat1, FullReformat2: Boolean;
        OldText, NewText: TRVRawByteString;
        {$IFNDEF RVDONOTUSELISTS}
        AddedMarkerItemNo : Integer;
        {$ENDIF}
    begin
      Result := False;
      if (GetItemStyle(dli.ItemNo)<0) or IsProtected(dli.ItemNo, rvprParaStartProtect) then begin
        Beep;
        exit;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      AddedMarkerItemNo := -1;
      {$ENDIF}
      with CharEnds.Items[CaretOffs] do begin
        if IsProtected(dli.ItemNo, rvprModifyProtect) then begin
          Beep;
          exit;
        end;
        Result := True;
        GetParaBoundsEx(CharEnds.Items[0].DrawItemNo,
                       CharEnds.Items[CharEnds.Count-1].DrawItemNo,
                       PItem1, PItem2, True);
        InsertPoint := dli.ItemNo+1;
        OldText := Items[dli.ItemNo];
        NewText := RVU_Copy(OldText, dli.Offs+Offset-1,
          RVU_Length(Items[dli.ItemNo], GetItemOptions(dli.ItemNo)),
          GetItemOptions(dli.ItemNo));
        Do_DeleteSubstring(dli.ItemNo, dli.Offs+Offset-1,-1);
        ItemsAdded := 1;
        FullReformat1 := False;
        FullReformat2 := False;
        li := RV_CreateTextCopy(TRVTextItemInfo(GetItem(dli.ItemNo)), Self);
        li.SameAsPrev := False;
        DoItemTextEdit(OldText, dli.ItemNo);        
        if Shift then
          li.BR := True
        else begin
           {$IFNDEF RVDONOTUSELISTS}
           if ReplicateMarker(InsertPoint-1, InsertPoint, FullReformat1, True, True) then begin
             AddedMarkerItemNo := InsertPoint;
             inc(ItemsAdded);
             inc(InsertPoint);
             li.SameAsPrev := True
           end;
           {$ENDIF}
        end;
        Do_InsertItem(InsertPoint, NewText, li, False, FullReformat2);
        DoItemTextEdit(OldText, InsertPoint);
        {$IFNDEF RVDONOTUSELIVESPELL}
        LaterSetBackLiveSpellingTo(dli.ItemNo, 0, True);
        {$ENDIF}
        Reformat_((NoWrap and (OldWidth>=DocumentWidth)) or FullReformat1 or FullReformat2, PItem1, PItem2,ItemsAdded);
        Item2FirstDrawItem(InsertPoint,CaretDrawItemNo);
        UpdateCaretAtTheBeginningOfLine;
        {$IFNDEF RVDONOTUSELISTS}
        UpdateRangeAfterMarkersOrSeq(AddedMarkerItemNo,AddedMarkerItemNo);
        {$ENDIF}
        DoAfterFormatAndCaretPositioning(True);
      end;
    end;
    {................................................................}
var DrawItem: TRVDrawLineInfo;
    Item: TCustomRVItemInfo;
    OldWidth: Integer;
    NoWrap: Boolean;
begin
  Result := False;
  CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  DrawItem := DrawItems[CaretDrawItemNo];
  Item  := GetItem(DrawItem.ItemNo);
  if IsParaProtected(Item.ParaNo,rvpaoDoNotWantReturns) or
     (Shift and IsParaProtected(Item.ParaNo, rvpaoReadOnly)) then begin
    Beep;
    exit;
  end;

  if CaretAtTheBeginningOfParaSectionEx(False) or CaretAtTheEndOfParaSectionEx(False) then begin
    if IsParaProtected(Item.ParaNo,rvpaoReadOnly) then begin
      if (CaretAtTheBeginningOfParaSectionEx(False) and
          not CaretAtTheBeginningOfParaSectionEx(True) and
          not CaretAtTheEndOfParaSectionEx(True))
          or
         (CaretAtTheEndOfParaSectionEx(False) and
          not CaretAtTheEndOfParaSectionEx(True) and
          not CaretAtTheBeginningOfParaSectionEx(True)) then begin
        Result := False;
        Beep;
        exit;
      end;
    end;
    BeginUndoSequence(rvutMiscTyping, True);
    Result := AddEmptyLine(DrawItem);
    UndoList.EndItem;
    exit;
  end;

  if IsParaProtected(Item.ParaNo,rvpaoReadOnly) then begin
    Result := False;
    Beep;
    exit;
  end;

  BeginUndoSequence(rvutMiscTyping, True);

  { breaking line }
  OldWidth := CalculateParaSectionMinWidthDef(DrawItem.ItemNo);
  NoWrap := (rvpaoNoWrap in GetRVStyle.ParaStyles[Item.ParaNo].Options) or not IsWordWrapAllowed;

  if GetOffsInItem(CaretOffs)<=GetOffsBeforeItem(DrawItem.ItemNo) then begin
     Result := WrapCurrentItem(DrawItem, OldWidth, NoWrap);
     UndoList.EndItem;
     exit;
  end;

  if GetOffsInItem(CaretOffs)>=GetOffsAfterItem(DrawItem.ItemNo) then begin
     Result := WrapNextItem(OldWidth, NoWrap);
     UndoList.EndItem;
     exit;
  end;
  Result := BreakTextItem(DrawItem, OldWidth, NoWrap);
  UndoList.EndItem;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.OnChangeCaretLine(DLOffs: Integer);
var First,Last,i: Integer;
    Canvas: TCanvas;
    UseFormatCanvas: Boolean;
const
    VARGE_VALUE = 100000;
    {........................................................}
    procedure SimpleBuildCaretPositions(Canvas: TCanvas; i: Integer);
    var
      item: TCustomRVItemInfo;
      ditem: TRVDrawLineInfo;
      arr: PRVIntegerArray;
      j, max: Integer;
      s: TRVRawByteString;
      BiDiMode: TRVBiDiMode;
      {$IFNDEF RVDONOTUSEUNICODE}
      PStart, PCur: Pointer;
      prevj: Integer;
      {$ENDIF}
    begin
      ditem := DrawItems[i];
      item  := GetItem(ditem.ItemNo);
      BiDiMode := GetParaBiDiMode(item.ParaNo);
      if (i=First) and ((item.StyleNo<0) or (Items[ditem.ItemNo]<>'')) then
        with TRVCharPos(CharEnds.Add) do begin
          if item.StyleNo<0 then
            Offset := 0
          else
            Offset := 1;
          if (item.StyleNo<0) and (BiDiMode=rvbdRightToLeft) then begin
            MoveRightTo := 2;
            X := ditem.Left+ditem.Width;
            end
          else begin
            MoveRightTo := 1;
            X := ditem.Left;
          end;
          DrawItemNo := i;
          if (i=CaretDrawItemNo) and (DLOffs<0) then
            CaretOffs := CharEnds.Count-1;
        end;
      max := 0;
      if (item.StyleNo>=0) and (Items[ditem.ItemNo]<>'') then begin
        GetRVStyle.ApplyStyle(Canvas, item.StyleNo, GetParaBiDiMode(item.ParaNo),
          True, nil, False, UseFormatCanvas);
        s := DrawItems.GetString(i,Items);
        s := RV_ReturnProcessedString(s, GetRVStyle.TextStyles[item.StyleNo],
          IsDrawItemLastOnWrappedLine(i), CanShowSpecialCharacters, False);
        GetMem(arr, (ditem.Length+2)*sizeof(Integer));
        try
          RVU_GetTextExtentExPoint(Canvas, s,
            MaxInt, max, arr, item.ItemOptions, GetRVStyle.GraphicInterface);
          {$IFNDEF RVDONOTUSEUNICODE}
          if RVNT and (rvioUnicode in item.ItemOptions) then begin
            SetLength(s, Length(s)+1);
            s[Length(s)] := #0;
            PStart := Pointer(s);
            PCur := PStart;
            prevj := 0;
            while PWord(PCur)^<>0 do begin
              with TRVCharPos(CharEnds.Add) do begin
                j := (PRVAnsiChar(PCur)-PRVAnsiChar(PStart)) div 2;
                Offset :=  j+2;
                MoveRightTo := 1;
                X := ditem.Left+RVConvertFromFormatCanvas(arr[j], UseFormatCanvas)+
                  ditem.SpaceAtLeft;
                DrawItemNo := i;
                if j>prevj+1 then begin
                  TRVCharPos(CharEnds.Items[CharEnds.Count-2]).X := ditem.Left+
                    RVConvertFromFormatCanvas(arr[j-1], UseFormatCanvas)+
                    ditem.SpaceAtLeft;
                  TRVCharPos(CharEnds.Items[CharEnds.Count-2]).Offset :=  j-1+2;
                end;
                if (i=CaretDrawItemNo) then begin
                  if (j=DLOffs) then
                    CaretOffs := CharEnds.Count-1
                  else if (j>DLOffs) and (prevj<DLOffs) then
                    CaretOffs := CharEnds.Count-2;
                end;
                prevj := j;
              end;
              PCur := CharNextW(PCur);
            end;
            CharEnds.Items[CharEnds.Count-1].Free;
            end
          else
          {$ENDIF}
            for j := 0 to max-2 do
              with TRVCharPos(CharEnds.Add) do begin
                Offset := j+2;
                MoveRightTo := 1;
                X := ditem.Left+RVConvertFromFormatCanvas(arr[j],UseFormatCanvas)+
                  ditem.SpaceAtLeft;
                DrawItemNo := i;
                if (i=CaretDrawItemNo) and (j=DLOffs) then
                  CaretOffs := CharEnds.Count-1;
              end;
        finally
          FreeMem(arr);
        end;
      end;
      with TRVCharPos(CharEnds.Add) do begin
        DrawItemNo := i;
        Offset := GetOffsAfterDrawItem(DrawItemNo);
        if (item.StyleNo<0) and (BiDiMode=rvbdRightToLeft) then begin
          X := ditem.Left;
          MoveRightTo := 1;
          end
        else begin
          X := ditem.Left+ditem.Width;
          if item.StyleNo<0 then
            MoveRightTo := 2
          else
            MoveRightTo := 1;
        end;
        if (i=CaretDrawItemNo-1) and (DLOffs<0) or
           (i=CaretDrawItemNo) and (DLOffs>max-2) then
          CaretOffs := CharEnds.Count-1;
      end;
    end;
    {........................................................}
    function AdvancedBuildCaretPositions(Canvas: TCanvas; i: Integer): Boolean;
    var
      item: TCustomRVItemInfo;
      ditem: TRVDrawLineInfo;
      arr: PRVIntegerArray;
      strt, j: Integer;
      s: TRVRawByteString;
      {$IFNDEF RVDONOTUSEUNICODE}
      PStart, PCur: Pointer;
      prevj: Integer;
      {$ENDIF}
    begin
      Result := True;
      ditem := DrawItems[i];
      item  := GetItem(ditem.ItemNo);
      if (item.StyleNo<0) or (Items[ditem.ItemNo]='') then begin
        SimpleBuildCaretPositions(Canvas, i);
        exit;
      end;
      s := DrawItems.GetString(i,Items);
      s := RV_ReturnProcessedString(s, GetRVStyle.TextStyles[item.StyleNo],
        IsDrawItemLastOnWrappedLine(i), CanShowSpecialCharacters, False);
      GetMem(arr, (ditem.Length+1)*sizeof(Integer));
      try
        GetRVStyle.ApplyStyle(Canvas, item.StyleNo, GetParaBiDiMode(item.ParaNo),
          True, nil, False, UseFormatCanvas);
        Result := RVU_GetTextCaretPos(Canvas, s, arr, item.ItemOptions,
          RVConvertToFormatCanvas(ditem.Width-ditem.SpaceAtLeft, UseFormatCanvas),
          RVConvertToFormatCanvas(2, UseFormatCanvas),
          GetRVStyle.GraphicInterface
          );
        if Result then begin
          {$IFNDEF RVDONOTUSEUNICODE}
          if RVNT and (rvioUnicode in item.ItemOptions) then begin
            SetLength(s, Length(s)+1);
            s[Length(s)] := #0;
            PStart := Pointer(s);
            PCur := PStart;
            prevj := 0;
            if i>First then
              PCur := CharNextW(Pointer(PCur));
            while True do
              with TRVCharPos(CharEnds.Add) do begin
                j := (PRVAnsiChar(PCur)-PRVAnsiChar(PStart)) div 2;
                Offset := j+1;
                MoveRightTo := 0;
                X := ditem.Left+RVConvertFromFormatCanvas(arr[j],UseFormatCanvas);
                inc(X,ditem.SpaceAtLeft);
                DrawItemNo := i;
                if ((i=CaretDrawItemNo) and (DLOffs<0) and (j=0)) or
                   ((i=CaretDrawItemNo) and ((j-1=DLOffs))) or
                   ((i=CaretDrawItemNo-1) and (DLOffs<0) and (j=ditem.Length)) or
                   ((i=CaretDrawItemNo) and (DLOffs>ditem.Length-2) and (j=ditem.Length)) then
                  CaretOffs := CharEnds.Count-1
                else if (i=CaretDrawItemNo) and (CharEnds.Count>1) and (j-1>DLOffs) and (prevj-1<DLOffs) then
                  CaretOffs := CharEnds.Count-2;
                 prevj := j;
                if PWord(PCur)^=0 then
                  break;
                PCur := CharNextW(PCur);
              end;
            end
          else
          {$ENDIF}
          begin
            strt := 0;
            if i>First then
              inc(strt);
            for j := strt to ditem.Length do
              with TRVCharPos(CharEnds.Add) do begin
                Offset := j+1;
                MoveRightTo := 0;
                X := ditem.Left+RVConvertFromFormatCanvas(arr[j], UseFormatCanvas);
                inc(X,ditem.SpaceAtLeft);
                DrawItemNo := i;
                if ((i=CaretDrawItemNo) and (DLOffs<0) and (j=0)) or
                   ((i=CaretDrawItemNo) and (j-1=DLOffs)) or
                   ((i=CaretDrawItemNo-1) and (DLOffs<0) and (j=ditem.Length)) or
                   ((i=CaretDrawItemNo) and (DLOffs>ditem.Length-2) and (j=ditem.Length)) then
                  CaretOffs := CharEnds.Count-1;
              end;
          end;
        end;
      finally
        FreeMem(arr);
      end;
    end;
    {........................................................}
begin
  {$IFDEF RVDEBUG}{$I Debug\h.inc}{$ENDIF}
  Canvas := GetFormatCanvas;
  UseFormatCanvas := Canvas<>GetCanvas;
  CharEnds.Clear;
  if CaretDrawItemNo = -1 then exit;
  CaretOffs := VARGE_VALUE;
  GetScreenLineBounds(CaretDrawItemNo, First, Last);
  {$IFNDEF RVDONOTUSELISTS}
  if GetDrawItemStyle(First)=rvsListMarker then begin
    if CaretDrawItemNo=First then begin
      inc(CaretDrawItemNo);
      DLOffs := GetOffsBeforeDrawItem(CaretDrawItemNo)-2;
    end;
    inc(First);
  end;
  {$ENDIF}
  for i := First to Last do
    if (GetItemBiDiMode(DrawItems[i].ItemNo)=rvbdUnspecified) or not AdvancedBuildCaretPositions(Canvas, i) then
      SimpleBuildCaretPositions(Canvas, i);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ChangeCaret(ForceCreate, ScrollToCaret, DontChangeStyle, RefreshBefore: Boolean);
var NewHeight: Integer;
    cx, cy, CurItemNo: Integer;
    item: TCustomRVItemInfo;
    {...........................................................}
    procedure MakeHot(JumpIndex: Integer);
    begin
      if not (rvoNoCaretHighlightJumps in
        TCustomRichViewEdit(FRichView).EditorOptions) then begin
        LastJumpMovedAbove := JumpIndex;
        State := State + [rvstDrawHover];
        Invalidate;
      end;
    end;
    {...........................................................}
    procedure MakeCold;
    begin
      if rvstDrawHover in State then begin
        LastJumpMovedAbove := -1;
        State := State - [rvstDrawHover];
        Invalidate;
      end;
    end;
   {...........................................................}
   procedure SwitchStyle(item: TCustomRVItemInfo);
   var NewStyleNo, ActNewStyleNo: Integer;
   begin
     if not DontChangeStyle then begin
       if item.StyleNo>=0 then begin
         NewStyleNo := item.StyleNo;
         ActNewStyleNo := GetActualStyle(item);
         end
       else begin
         NewStyleNo := item.AssociatedTextStyleNo;
         if (NewStyleNo<0) or not item.GetBoolValue(rvbpSwitchToAssStyleNo) then
           exit;
         ActNewStyleNo := NewStyleNo;
       end;
       if rvprDoNotAutoSwitch in GetRVStyle.TextStyles[ActNewStyleNo].Protection then begin
         if not (rvprDoNotAutoSwitch in GetRVStyle.TextStyles[FPrevTextStyleNo].Protection) then
           SetCurTextStyleNo(FPrevTextStyleNo)
         end
       else begin
         SetCurTextStyleNo(NewStyleNo);
         FPrevTextStyleNo := NewStyleNo;
       end;
     end;
   end;
   {...........................................................}
begin
 if rvstSkipformatting in State then exit;
 if RefreshBefore and not Assigned(OnFormat) then begin
   UpdateResizer;
   UpdateView;
 end;
 if (FPartialSelectedItem<>nil) or
    (TCustomRichView(FRichView).InplaceEditor<>nil) or
    (rvstCompletelySelected in State)
 then begin
   HideCaret(GetParentControl.Handle);
   TCustomRichViewEdit(FRichView).AfterCaretMove;
   exit;
 end;
 cx := 0; cy := 0; {<- avoiding warnings}
 if FResizer=nil then begin
   if CaretDrawItemNo=-1 then
     NewHeight := 0
   else begin
     if (CaretOffs<0) or (CaretOffs>=CharEnds.Count) then begin
       CaretDrawItemNo := 0;
       CaretOffs := 0;
       {$IFNDEF RVDONOTUSELISTS}
       AdjustMarkerCaret(True, CaretOffs);
       {$ENDIF}
       OnChangeCaretLine(CaretOffs-2);
       raise ERichViewError.Create(errRVCaretPosition);
     end;
     CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
     if (FSelEndNo=FSelStartNo) and (FSelEndOffs=FSelStartOffs) then begin
       FSelStartNo := CaretDrawItemNo;
       FSelStartOffs := CharEnds.Items[CaretOffs].Offset;
     end;
     FSelEndNo := CaretDrawItemNo;
     FSelEndOffs := CharEnds.Items[CaretOffs].Offset;
     NewHeight := DrawItems[CaretDrawItemNo].Height+2;
     if NewHeight<RichViewEditMinCaretHeight then
       NewHeight := RichViewEditMinCaretHeight;
     if NewHeight>RichViewEditMaxCaretHeight then
       NewHeight := RichViewEditMaxCaretHeight;
     with CharEnds.Items[CaretOffs] do begin
       cx := X-1+MoveRightTo;
       cy := DrawItems[CaretDrawItemNo].Top-1;
     end;
   end;
   if (CaretHeight<>NewHeight) or ForceCreate or True {!!!} then begin
     if (CaretHeight<>0) and GetParentControl.Focused then begin
       HideCaret(GetParentControl.Handle);
       DestroyCaret;
     end;
     if (NewHeight<>0) and
        {$IFNDEF RVDONOTUSEDRAGDROP}
        (GetDragDropCaretInfo=nil) and
        {$ENDIF}
        not (TCustomRichViewEdit(FRichView).ReadOnly and
         (rvoHideReadOnlyCaret in TCustomRichViewEdit(FRichView).EditorOptions)) and
        GetParentControl.Focused then begin
       if TCustomRichViewEdit(FRichView).CustomCaretInterval<=0 then begin
         CreateCaret(GetParentControl.Handle, 0,
           {MulDiv(}RichViewEditCaretWidth{,ZoomPercent,100)},
           {MulDiv(}NewHeight+RichViewEditCaretHeightExtra*2{,ZoomPercent,100)});
         SetCaretPos({MulDiv(}cx-GetHOffs-RichViewEditCaretWidth div 2{, ZoomPercent,100)},
           {MulDiv(}cy-GetVOffs+DrawItems[CaretDrawItemNo].Height+1-RichViewEditCaretHeightExtra-NewHeight{,ZoomPercent,100)});
         ShowCaret(GetParentControl.Handle);
       end;
       FCustomCaretRect := Bounds(cx-GetHOffs-RichViewEditCaretWidth div 2,
         cy-GetVOffs+DrawItems[CaretDrawItemNo].Height+1-RichViewEditCaretHeightExtra-NewHeight,
         RichViewEditCaretWidth, NewHeight+RichViewEditCaretHeightExtra*2);
     end;
     CaretHeight := NewHeight;
     end
   else begin
     if (NewHeight<>0) {and Focused} then begin
       if GetParentControl.Focused then SetCaretPos({MulDiv(}cx-GetHOffs-RichViewEditCaretWidth div 2{,ZoomPercent,100)},
                                                    {MulDiv(}cy-GetVOffs+DrawItems[CaretDrawItemNo].Height+1+RichViewEditCaretHeightExtra-NewHeight{,ZoomPercent,100)});
     end;
   end;
   end
 else begin
   HideCaret(GetParentControl.Handle);
   TCustomRichViewEdit(FRichView).AfterCaretMove;
 end;
 if (CaretDrawItemNo<>-1) then begin
   CurItemNo := DrawItems[CaretDrawItemNo].ItemNo;
   if (CurItemNo>0) and not IsFromNewLine(CurItemNo) and not IsHidden(CurItemNo-1) and
     {$IFNDEF RVDONOTUSELISTS}
     (GetItemStyle(CurItemNo-1)<>rvsListMarker) and
     {$ENDIF}
     (GetOffsetInCurItem<=GetOffsBeforeItem(CurItemNo)) then
     dec(CurItemNo);
   item := GetItem(CurItemNo);
   if not DontChangeStyle then
     SetCurParaStyleNo(item.ParaNo);
   if item.GetBoolValueEx(rvbpDisplayActiveState, GetRVStyle) then begin
     FActiveItem := item;
     Invalidate;
     end
   else
     if FActiveItem<>nil then begin
       FActiveItem := nil;
       invalidate;
     end;
   if (FSelStartNo>=0) and (FSelEndNo>=0) and
     not ((FSelStartNo=FSelEndNo) and (FSelStartOffs=FSelEndOffs)) then
     item := GetItem(DrawItems[FSelEndNo].ItemNo);
   if (FSelStartNo>=0) and (FSelEndNo>=0) and
      ((FSelStartNo>FSelEndNo) or ((FSelStartNo=FSelEndNo)and(FSelStartOffs>FSelEndOffs))) and
      (FSelEndOffs>=GetOffsAfterDrawItem(FSelEndNo)) and (FSelEndNo+1<DrawItems.Count) and
      GetItem(DrawItems[FSelEndNo+1].ItemNo).SameAsPrev then
     item := GetItem(DrawItems[FSelEndNo+1].ItemNo);
   SwitchStyle(item);
   if not TCustomRichViewEdit(FRichView).ReadOnly then
     if item.GetBoolValueEx(rvbpHotColdJump, GetRVStyle) then
       MakeHot(item.JumpID)
     else
       MakeCold;
 end;
  if (FResizer=nil) and ScrollToCaret and {Focused and} (CaretHeight<>0) and (CaptureMouseItem=nil) then begin { scrolling to caret pos }
    ShowRectangle(cx, cy, 5, CaretHeight);
  end;
  TCustomRichViewEdit(FRichView).AfterCaretMove;
end;
{------------------------------------------------------------------------------}
// Is the specified position in CharEnds located
// at the end of screen line AND at the end of item?
function TRVEditRVData.IsCharOffsAtTheLineEndAndItemEnd(Offs: Integer): Boolean;
begin
  Result := (Offs=CharEnds.Count-1) and
    (GetOffsInItem(Offs)>=GetOffsAfterItem(DrawItems[CharEnds.Items[Offs].DrawItemNo].ItemNo));
end;
{------------------------------------------------------------------------------}
// Is the specified position in CharEnds located
// at the end of screen line AND at the end of item?
function TRVEditRVData.IsCharOffsAtTheLineStartAndItemStart(Offs: Integer): Boolean;
begin
  Result := (Offs=0) and
    (GetOffsInItem(Offs)<=GetOffsBeforeItem(DrawItems[CharEnds.Items[Offs].DrawItemNo].ItemNo));
end;
{------------------------------------------------------------------------------}
// Ctrl is not used
procedure TRVEditRVData.OnDeletePress_(Ctrl: Boolean; MovedFromLineEnd: Boolean);
    {.....................................................................}
    procedure AdjustCaret(SavedCaretNo, SavedCaretOffs: Integer; ApplyPara: Boolean);
    begin
      Item2DrawItem(SavedCaretNo, SavedCaretOffs, CaretDrawItemNo, SavedCaretOffs,
        rvdpBetterBelow);
      {$IFNDEF RVDONOTUSELISTS}
      AdjustMarkerCaret(True, SavedCaretOffs);
      {$ENDIF}
      OnChangeCaretLine(SavedCaretOffs-2);
      ChangeCaret(False,True,False,True);
      if ApplyPara then
        ApplyParaStyle(FCurParaStyleNo, rvscParaStyle, False);
    end;
    {.....................................................................}
    // Deleting an empty string
    // This string can be at the position of caret (CaretToTheNext=True,
    // because caret will be moved to the next item after deleting)
    // or the next line (CaretToTheNext=False)
    // If (ItemNo-1)-th item is a marker, this function deletes it as well.
    procedure Del_DeleteEmptyString(ItemNo, First, Last: Integer;
      CaretToTheNext: Boolean);
    var FullReformat,FR: Boolean;
        ItemsAdded : Integer;
        SavedCaretNo, SavedCaretOffs: Integer;
        {$IFNDEF RVDONOTUSELISTS}
        MS_FirstItemNo: Integer;
        M_LastMarkerIndex: Integer;
        M_ListNos: TRVIntegerList;
        S_LastSeqIndex: Integer;
        S_SeqNames: TStringList;
        {$ENDIF}
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsProtected(ItemNo, rvprDeleteProtect) or
        IsItemParaProtected(ItemNo) or
        ParaHasPersistentCheckpoint(ItemNo) then begin
        Beep;
        exit;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker) and
         IsProtected(ItemNo-1, rvprDeleteProtect) then begin
        Beep;
        exit;
      end;
      {$ENDIF}
      FullReformat := False;
      if CaretToTheNext and (ItemNo+1<ItemCount) and not GetItem(ItemNo).BR then begin
        Do_BR(ItemNo+1,False,FR);
        FullReformat := FullReformat or FR;
      end;
      ItemsAdded := -1;
      {$IFNDEF RVDONOTUSELISTS}
      MS_FirstItemNo    := -1;
      M_LastMarkerIndex := -1;
      M_ListNos         := nil;
      S_LastSeqIndex    := -1;
      S_SeqNames        := nil;
      {$ENDIF}
      {$IFNDEF RVDONOTUSELISTS}
      if (ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker) then begin
        PrepareForUpdateRangeAfterMarkersOrSeq(ItemNo-1, ItemNo-1, True,
          MS_FirstItemNo, M_LastMarkerIndex, S_LastSeqIndex,
          M_ListNos, S_SeqNames);
        Do_DeleteItem(ItemNo, FR);
        FullReformat := FullReformat or FR;
        dec(ItemsAdded);
        dec(ItemNo);
      end;
      {$ENDIF}
      Do_DeleteItem(ItemNo, FR);
      {$IFNDEF RVDONOTUSELIVESPELL}
      if ItemNo<ItemCount then
        LaterSetBackLiveSpellingTo(ItemNo, 0, False);
      {$ENDIF}
      FullReformat := FullReformat or FR;
      if CaretToTheNext then begin
        SavedCaretNo := ItemNo;
        if SavedCaretNo=ItemCount then begin
          dec(SavedCaretNo);
          SavedCaretOffs := GetOffsAfterItem(SavedCaretNo);
          end
        else begin
          {$IFNDEF RVDONOTUSELISTS}
          if GetItemStyle(SavedCaretNo)=rvsListMarker then
            inc(SavedCaretNo);
          {$ENDIF}
          SavedCaretOffs := GetOffsBeforeItem(SavedCaretNo);
        end;
        end
      else begin
        SavedCaretNo := ItemNo-1;
        SavedCaretOffs := GetOffsAfterItem(SavedCaretNo);
      end;
      Reformat_(FullReformat, First, Last, ItemsAdded);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, not CaretToTheNext);
      {$IFNDEF RVDONOTUSELISTS}
      if not FullReformat then
        UpdateAfterMarkersOrSeq(MS_FirstItemNo, M_LastMarkerIndex, S_LastSeqIndex,
          M_ListNos, S_SeqNames);
      M_ListNos.Free;
      S_SeqNames.Free;
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.................................................................}
    // Concatenating two text items into one
    // This function is called only if caret is at the end of line,
    // and the last item in this line and the first item in the next line
    // can be combined.
    procedure Del_ConcateItems(ItemNo, First, Last: Integer);
    var ItemsAdded, OldWidth : Integer;
        SavedCaretOffs: Integer;
        OldText: TRVRawByteString;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsItemParaProtected(ItemNo) or IsItemParaProtected(ItemNo+1) or
         IsProtected(ItemNo+1, rvprParaStartProtect) or
         ParaHasPersistentCheckpoint(ItemNo+1) then begin
        Beep;
        exit;
      end;
      OldWidth := CalculateParaSectionMinWidthDef(ItemNo);
      SavedCaretOffs := GetOffsAfterItem(ItemNo);
      OldText := Items[ItemNo];
      Do_Concate(ItemNo);
      DoItemTextEdit(OldText, ItemNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(ItemNo, SavedCaretOffs, True);
      {$ENDIF}
      ItemsAdded := -1;
      Reformat_((OldWidth>=DocumentWidth), First, Last, ItemsAdded);
      AdjustCaret(ItemNo, SavedCaretOffs, True);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.................................................................}
    // Moving the next item to the end of current paragraph
    // This function is called only if caret is at the end of line
    // If the next item is a marker, it is deleted
    procedure Del_MoveToThis(ItemNo, First, Last: Integer);
    var ItemsAdded: Integer;
        SavedCaretItemNo, SavedCaretOffs: Integer;
        FullReformat1,FullReformat2: Boolean;
        {$IFNDEF RVDONOTUSELISTS}
        MS_FirstItemNo: Integer;
        M_LastMarkerIndex: Integer;
        M_ListNos: TRVIntegerList;
        S_LastSeqIndex: Integer;
        S_SeqNames: TStringList;
        {$IFNDEF RVDONOTUSELIVESPELL}
        Len: Integer;
        {$ENDIF}
        {$ENDIF}
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsItemParaProtected(ItemNo-1) or IsItemParaProtected(ItemNo) or
         IsProtected(ItemNo, rvprParaStartProtect) or
         ParaHasPersistentCheckpoint(ItemNo) then begin
        Beep;
        exit;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if (GetItemStyle(ItemNo)=rvsListMarker) and
        IsProtected(ItemNo, rvprDeleteProtect) then begin
        Beep;
        exit;
      end;
      {$ENDIF}
      FullReformat2 := False;
      Do_NewLine(ItemNo, True,-1, FullReformat1);
      ItemsAdded := 0;
      SavedCaretItemNo := GetPrevNonHiddenItemNo(ItemNo);
      SavedCaretOffs := GetOffsAfterItem(SavedCaretItemNo);
      {$IFNDEF RVDONOTUSELISTS}
      MS_FirstItemNo    := -1;
      M_LastMarkerIndex := -1;
      M_ListNos         := nil;
      S_LastSeqIndex    := -1;
      S_SeqNames        := nil;
      {$ENDIF}
      {$IFNDEF RVDONOTUSELISTS}
      if GetItemStyle(ItemNo)=rvsListMarker then begin
        PrepareForUpdateRangeAfterMarkersOrSeq(ItemNo, ItemNo, True, MS_FirstItemNo,
          M_LastMarkerIndex, S_LastSeqIndex, M_ListNos, S_SeqNames);
        Do_DeleteItem(ItemNo, FullReformat2);
        dec(ItemsAdded);
        if (ItemNo<ItemCount) then begin
          if RV_CanConcateItems(ItemNo-1, GetItem(ItemNo-1), GetItem(ItemNo), False, False) then begin
            {$IFNDEF RVDONOTUSELIVESPELL}
            Len := ItemLength(ItemNo-1);
            {$ENDIF}
            Do_Concate(ItemNo-1);
            {$IFNDEF RVDONOTUSELIVESPELL}
            LaterSetBackLiveSpellingTo(ItemNo-1, Len+1, True);
            {$ENDIF}
            dec(ItemsAdded);
          end
          {$IFNDEF RVDONOTUSELIVESPELL}
          else begin
            LaterSetBackLiveSpellingTo(ItemNo, 0, False);
          end;
          {$ENDIF}
          end
      end;
      {$ENDIF}
      Reformat_(FullReformat1 or FullReformat2, First, Last, ItemsAdded);
      AdjustCaret(SavedCaretItemNo, SavedCaretOffs, True);
      {$IFNDEF RVDONOTUSELISTS}
      if not (FullReformat1 or FullReformat2)  then
        UpdateAfterMarkersOrSeq(MS_FirstItemNo, M_lastMarkerIndex, S_LastSeqIndex,
          M_ListNos, S_SeqNames);
      M_ListNos.Free;
      S_SeqNames.Free;
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);

    end;
    {.................................................................}
    // Actions at the end of paragraph or its section.
    // This procedure is never called at the end of document, so the next item
    // must exist.
    procedure Del_AtTheEndOfParaSection(ItemNo, First, Last: Integer);
    var NextItemNo: Integer;
    begin
     NextItemNo := GetNextNonHiddenItemNo(ItemNo);
     if (GetItemStyle(ItemNo)>=0) and (ItemLength(ItemNo)=0) then
       Del_DeleteEmptyString(ItemNo, First, Last, True) // delete the current empty string
     else if (GetItemStyle(NextItemNo)>=0) and (ItemLength(NextItemNo)=0) then
       Del_DeleteEmptyString(NextItemNo, First, Last, False) // delete the next empty string
     else if (NextItemNo=ItemNo+1) and RV_CanConcateItems(ItemNo, GetItem(ItemNo), GetItem(NextItemNo), True, False) then
       Del_ConcateItems(ItemNo, First, Last) // joining ItemNo and ItemNo+1
     else // move the next non-hidden item to the previous line
       Del_MoveToThis(NextItemNo, First, Last)
    end;
    {.................................................................}
    // This procedure is called when the caret is not at the end of paragraph or its section
    // It can be at the end of screen line, though
    procedure Del_AtTheMiddle(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    begin
      if CaretDrawItemNo=DrawItems.Count then
        exit; // for any case
      if (CaretOffs=CharEnds.Count-1) then begin
        // We are at the end of screen line, but not item
        if (DrawItem.ItemNo <> DrawItems[CaretDrawItemNo+1].ItemNo) or
           (DrawItems[CaretDrawItemNo+1].Offs>DrawItem.Offs+DrawItem.Length) then begin
          // A space character was "eaten" between screen Items.
          // Moving to the next line and simulating BACKSPACE
          inc(CaretDrawItemNo);
          OnChangeCaretLine(0);
          CaretOffs := 0;
          OnBackspacePress_(False, True, False);
          ChangeCaret(False,True,False,True);
          end
        else begin
          // The current item was separated between lines.
          // Moving to the next line and simulating DELETE one more time.
          inc(CaretDrawItemNo);
          OnChangeCaretLine(0);
          CaretOffs := 0;
          OnDeletePress_(False, True);
          ChangeCaret(False,True,False,True);
       end;
       end
     else begin
       // "if" checks a special case when space char was "eaten" at the beginning of line
       if not (MovedFromLineEnd and
          (DrawItem.ItemNo<>DrawItems[CaretDrawItemNo-1].ItemNo) and
          (DrawItem.Offs>1)) then
         CaretOffs := CaretOffs+1;
       OnBackSpacePress_(False, True, False);
       ChangeCaret(False,True,False,True);
     end;
    end;
    {.................................................................}
var DrawItem: TRVDrawLineInfo;
    Item: TCustomRVItemInfo;
    First, Last: Integer;
begin
  CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  DrawItem := DrawItems[CaretDrawItemNo];
  Item := GetItem(DrawItem.ItemNo);

  if IsParaProtected(Item.ParaNo,rvpaoReadOnly) then begin
    Beep;
    exit;
  end;
  if IsCharOffsAtTheLineEndAndItemEnd(CaretOffs) then begin
    // ** we are at the end of item and screen line **
    if Item.GetBoolValue(rvbpFullWidth) or
      (
       (GetNextNonHiddenItemNo(DrawItem.ItemNo)>=0) and
       (GetItem(GetNextNonHiddenItemNo(DrawItem.ItemNo)).GetBoolValue(rvbpFullWidth)) and
       not ((Item.StyleNo>=0) and (ItemLength(DrawItem.ItemNo)=0))
      )
      then begin
         // If we are at the end of a table (or break), or the next line is a table (or break),
         // then deleting nothing, just move the caret to the next line.
         // The only exception: if we are at the empty paragraph.
         OnRightPress(False,False);
         exit;
    end;
    if DrawItem.ItemNo=GetLastNonHiddenItemNo then begin
      // If we are at the end of the document, and we are at the empty text line,
      // then deleting this line by simulating BACKSPACE
      if ((Item.StyleNo>=0) and (ItemLength(DrawItem.ItemNo)=0)) then
        OnBackSpacePress_(False,False,False);
        exit;
      end;
  end;

  First := CharEnds.Items[0].DrawItemNo;
  Last  := CharEnds.Items[CharEnds.Count-1].DrawItemNo;
  GetParaBoundsEx(First,Last,First,Last, True);

  if IsCharOffsAtTheLineEndAndItemEnd(CaretOffs) and
    (GetNextNonHiddenItemNo(DrawItem.ItemNo)>=0) and
    not IsFromNewLineEx(GetNextNonHiddenItemNo(DrawItem.ItemNo))
    then begin
    // ** we at the end of screen line, item,        **
    // ** but not a paragraph (or paragraph section) **
    // Moving the caret to the next position and simulating BACKSPACE
    inc(CaretDrawItemNo);
    OnChangeCaretLine(0);
    CaretOffs := 0;
    OnDeletePress_(Ctrl, True);
    ChangeCaret(False,True,False,True);
    exit;
  end;

  BeginUndoSequence(rvutDelete, True);

  if IsCharOffsAtTheLineEndAndItemEnd(CaretOffs) and
    (GetNextNonHiddenItemNo(DrawItem.ItemNo)>=0) and
    IsFromNewLineEx(GetNextNonHiddenItemNo(DrawItem.ItemNo)) then
      Del_AtTheEndOfParaSection(DrawItem.ItemNo, First, Last)
    else
      Del_AtTheMiddle(DrawItem, First, Last);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.OnBackSpacePress_(Ctrl: Boolean; MultiDelete, FromNextLine: Boolean);
    {.....................................................................}
    function GetPrevP(dli: TRVDrawLineInfo; CaretOffs: Integer): Integer;
    begin
      if DrawItems[CharEnds.Items[CaretOffs-1].DrawItemNo].ItemNo<>dli.ItemNo then
        Result := 0
      else
        Result := dli.Offs+CharEnds.Items[CaretOffs-1].Offset-2;
    end;
    {.....................................................................}
    function DeleteCount(s: TRVRawByteString; p, ItemNo: Integer): Integer;
    var ItemOptions: TRVItemOptions;
        IsSpace2, IsDelim1, IsDelim2: Boolean;
        CodePage: TRVCodePage;
    begin
      if Ctrl then begin
        ItemOptions := GetItemOptions(ItemNo);
        CodePage := GetItemCodePage(ItemNo);
        Result := 1;
        for p := p-1 downto 1 do begin
          IsSpace2 := RVU_IsSpace(s, p+1, ItemOptions);
          IsDelim1 := IsDelimiter(s, p,   ItemOptions, CodePage);
          IsDelim2 := IsDelimiter(s, p+1, ItemOptions, CodePage);
          if (IsDelim1 and not IsDelim2) or
            (not IsDelim1 and not IsSpace2 and IsDelim2) then
            break;
          inc(Result);
        end;
        end
      else if MultiDelete then
        Result := (p+1)-PrevCharStr(s,ItemNo,p+1)
      else
        Result := 1;
    end;
    {.....................................................................}
    procedure AdjustCaret(SavedCaretNo, SavedCaretOffs: Integer; ApplyPara: Boolean);
    begin
      Item2DrawItem(SavedCaretNo, SavedCaretOffs, CaretDrawItemNo, SavedCaretOffs, rvdpBetterBelow);
      {$IFNDEF RVDONOTUSELISTS}
      AdjustMarkerCaret(True, SavedCaretOffs);
      {$ENDIF}
      OnChangeCaretLine(SavedCaretOffs-2);
      ChangeCaret(False,True,False,True);
      if ApplyPara then
        ApplyParaStyle(FCurParaStyleNo, rvscParaStyle, False);
    end;
    {.....................................................................}
    // Deleting current empty line
    // This function is called only if this is an empty line without marker,
    // and this line is not the first
    procedure Backspace_DeleteCurrentEmptyString(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    var SavedCaretNo, SavedCaretOffs, ItemsAdded: Integer;
        FullReformat: Boolean;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsProtected(DrawItem.ItemNo, rvprDeleteProtect) or
         IsItemParaProtected(DrawItem.ItemNo) or
         ItemHasPersistentCheckpoint(DrawItem.ItemNo) then begin
        Beep;
        exit;
      end;
      SavedCaretNo := GetPrevNonHiddenItemNo(DrawItem.ItemNo);
      if SavedCaretNo>=0 then
        SavedCaretOffs := GetOffsAfterItem(SavedCaretNo)
      else
        SavedCaretOffs := -1;
      Do_DeleteItem(DrawItem.ItemNo, FullReformat);
      ItemsAdded := -1;
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(SavedCaretNo, 0, False);
      {$ENDIF}
      Reformat_(FullReformat, First, Last, ItemsAdded);
      if SavedCaretNo<0 then begin
        SavedCaretNo := GetFirstNonHiddenItemNo;
        SavedCaretOffs := GetOffsBeforeItem(SavedCaretNo);
      end;
      AdjustCaret(SavedCaretNo, SavedCaretOffs, True);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Deleting previous empty line
    // If this line is after marker, moving current item to this marker's paragraph
    // This function is called only if caret is at the beginning of line,
    // end previous line if finished by an empty text item
    procedure Backspace_DeletePrevEmptyString(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    var SavedCaretNo, SavedCaretOffs, ItemsAdded: Integer;
        FullReformat, FR: Boolean;
        ItemNo, PrevItemNo: Integer;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      ItemNo := DrawItems[CaretDrawItemNo].ItemNo;
      PrevItemNo := DrawItems[CaretDrawItemNo-1].ItemNo;
      if IsProtected(PrevItemNo, rvprDeleteProtect) or
         IsItemParaProtected(PrevItemNo) or
         IsItemParaProtected(ItemNo) or
         ParaHasPersistentCheckpoint(PrevItemNo) then begin
        Beep;
        exit;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if (PrevItemNo>0) and (GetItemStyle(PrevItemNo-1)=rvsListMarker) and
         ParaHasPersistentCheckpoint(ItemNo) then begin
        Beep;
        exit;
      end;
      {$ENDIF}
      FullReformat := False;
      if not GetItem(PrevItemNo).BR then begin
        Do_BR(ItemNo, False, FR);
        FullReformat := FullReformat or FR;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if (PrevItemNo>0) and (GetItemStyle(PrevItemNo-1)=rvsListMarker) then begin
        // The PrevItemNo+1-th item can be hidden. If we apply Do_NewLine to the
        // first visible item (ItemNo) instead, we may produce incorrect document.
        // (?) But probably, we should apply to the both?
        Do_NewLine(PrevItemNo+1, True, -1, FR);
        FullReformat := FullReformat or FR;
      end;
      {$ENDIF}
      SavedCaretNo := ItemNo;
      SavedCaretOffs := GetOffsBeforeItem(SavedCaretNo);
      dec(SavedCaretNo);
      Do_DeleteItem(PrevItemNo, FR);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(PrevItemNo, 0, False);
      {$ENDIF}
      FullReformat := FullReformat or FR;
      ItemsAdded := -1;
      Reformat_(FullReformat, First, Last, ItemsAdded);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, False);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Concatenating two text items into one
    // This function is called only if caret is at the beginning of line,
    // and the first item in this line and the last item in previous line
    // can be combined.
    procedure Backspace_ConcateItems(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    var ItemNo, SavedCaretNo, SavedCaretOffs, ItemsAdded: Integer;
        OldText: TRVRawByteString;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsItemParaProtected(DrawItem.ItemNo-1) or IsItemParaProtected(DrawItem.ItemNo) or
         IsProtected(DrawItem.ItemNo, rvprParaStartProtect) or
         ParaHasPersistentCheckpoint(DrawItem.ItemNo) then begin
        Beep;
        exit;
      end;
      ItemNo := DrawItem.ItemNo-1;
      SavedCaretOffs := ItemLength(ItemNo)+1;
      OldText := Items[ItemNo];
      Do_Concate(ItemNo);
      DoItemTextEdit(OldText, ItemNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(ItemNo, SavedCaretOffs, True);
      {$ENDIF}
      ItemsAdded := -1;
      SavedCaretNo := ItemNo;
      FormatParasExact(First, Last, ItemsAdded, False);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, True);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Moving current item to the end of previous paragraph
    // This function is called only if caret is at the beginning of line
    procedure Backspace_MoveToPrev(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    var SavedCaretNo, SavedCaretOffs, ItemsAdded: Integer;
        FullReformat: Boolean;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsProtected(DrawItem.ItemNo, rvprParaStartProtect) or
         IsItemParaProtected(DrawItem.ItemNo) or IsItemParaProtected(DrawItem.ItemNo-1) or
         ParaHasPersistentCheckpoint(DrawItem.ItemNo) then begin
        Beep;
        exit;
      end;
      Do_NewLine(DrawItem.ItemNo, True,-1, FullReformat);
      ItemsAdded := 0;
      SavedCaretNo := DrawItem.ItemNo;
      SavedCaretOffs := GetOffsBeforeItem(SavedCaretNo);
      Reformat_(FullReformat, First, Last, ItemsAdded);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, True);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Deleting the ItemNo-th item completely.
    // May be called for current item or previous item (marker).
    procedure Backspace_DeleteItem(ItemNo, First, Last: Integer);
    var Prev, SavedCaretNo, SavedCaretOffs, ItemsAdded, DeletedWidth: Integer;
        FullReformat, FR: Boolean;
        ASameAsPrev, ABR, APB, ACL, ACR: Boolean;
        Item: TCustomRVItemInfo;
        {$IFDEF RVUSELISTORSEQ}
        MS_FirstItemNo: Integer;
        M_LastMarkerIndex: Integer;
        M_ListNos: TRVIntegerList;
        S_LastSeqIndex: Integer;
        S_SeqNames: TStringList;
        {$ENDIF}
        {$IFNDEF RVDONOTUSELIVESPELL}
        Len: Integer;
        {$ENDIF}
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsItemParaProtected(ItemNo) or
         IsProtected(ItemNo, rvprDeleteProtect) or
         not MovePersistentCheckpoint(ItemNo, False) then begin
        Beep;
        exit;
      end;
      FullReformat := False;
      ItemsAdded := -1;
      Prev := ItemNo-1;
      if Prev>=0 then begin
        SavedCaretNo   := Prev;
        SavedCaretOffs := GetOffsAfterItem(Prev)
        end
      else begin
       SavedCaretNo    := -1; { avoiding warnings}
       SavedCaretOffs  := -1;
      end;
      Item := GetItem(ItemNo);
      {$IFDEF RVUSELISTORSEQ}
      PrepareForUpdateRangeAfterMarkersOrSeq(ItemNo, ItemNo, True, MS_FirstItemNo,
        M_LastMarkerIndex, S_LastSeqIndex,  M_ListNos, S_SeqNames);
      {$ENDIF}
      DeletedWidth := CalculateMinItemWidthPlusEx(ItemNo);
      ASameAsPrev := Item.SameAsPrev;
      ABR         := Item.BR;
      APB         := Item.PageBreakBefore;
      ACL         := Item.ClearLeft;
      ACR         := Item.ClearRight;
      Do_DeleteItem(ItemNo, FR);
      FullReformat := FullReformat or FR;
      {$IFNDEF RVDONOTUSELIVESPELL}
      Len := -1;
      {$ENDIF}
      if (ItemNo<Items.Count) and GetItem(ItemNo).SameAsPrev then
        if (not ASameAsPrev) or (ItemNo=0) then begin
          { move next item to the new line }
          // (?): this item can be hidden. Probably, we should process the next visible item instead?
          Do_NewLine(ItemNo, False, -1, FR);
          {$IFNDEF RVDONOTUSELIVESPELL}
          LaterSetBackLiveSpellingTo(ItemNo, 0, False);
          Len := 0;
          {$ENDIF}
          FullReformat := FullReformat or FR;
          Do_BR(ItemNo, ABR, FR);
          FullReformat := FullReformat or FR;
          Do_PageBreak(ItemNo, APB);
          Do_ClearTextFlow(ItemNo, ACL, ACR);
          SavedCaretNo := ItemNo;
          SavedCaretOffs := GetOffsBeforeItem(ItemNo);
          end
        else begin
          if RV_CanConcateItems(ItemNo-1, GetItem(ItemNo-1), GetItem(ItemNo), False, False) then begin
            { concate items before and after deleted }
            {$IFNDEF RVDONOTUSELIVESPELL}
            Len := ItemLength(ItemNo-1);
            {$ENDIF}
            Do_Concate(ItemNo-1);
            {$IFNDEF RVDONOTUSELIVESPELL}
            LaterSetBackLiveSpellingTo(ItemNo-1, Len+1, True);
            {$ENDIF}
            dec(ItemsAdded);
          end;
        end;
      {$IFNDEF RVDONOTUSELIVESPELL}
      if Len<0 then begin
        if ItemNo>=Items.Count then
         dec(ItemNo);
        LaterSetBackLiveSpellingTo(ItemNo, 0, False);
      end;
      {$ENDIF}
      Reformat_(FullReformat or (DeletedWidth>=DocumentWidth), First, Last, ItemsAdded);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, False);
      {$IFDEF RVUSELISTORSEQ}
      if not FullReformat then
        UpdateAfterMarkersOrSeq(MS_FirstItemNo, M_LastMarkerIndex, S_LastSeqIndex,
          M_ListNos, S_SeqNames);
      M_ListNos.Free;
      S_SeqNames.Free;
      {$ENDIF}
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Actions on backspace at the beginning of paragraph or its section
    procedure Backspace_AtTheBeginningOfParaSection(DrawItem: TRVDrawLineInfo; First, Last: Integer);
    var PrevItemNo: Integer;
    begin
      PrevItemNo := GetPrevNonHiddenItemNo(DrawItem.ItemNo);
      if PageBreaksBeforeItems[DrawItem.ItemNo] then begin
        if not TCustomRichViewEdit(RichView).BeforeChange(False) then
          exit;
        Do_PageBreak(DrawItem.ItemNo, False);
        Format_(True,True,False,0,GetFormatCanvas,False,False,False,False);
        DoAfterFormatAndCaretPositioning(True);
        Change;
        Invalidate;
        end
      {$IFNDEF RVDONOTUSELISTS}
      else if (CaretDrawItemNo>0) and (GetItemStyle(DrawItems[CaretDrawItemNo-1].ItemNo)=rvsListMarker) then
        Backspace_DeleteItem(DrawItems[CaretDrawItemNo-1].ItemNo, First, Last)
      {$ENDIF}
      else if (GetItemStyle(DrawItem.ItemNo)>=0) and (ItemLength(DrawItem.ItemNo)=0) then
        BackSpace_DeleteCurrentEmptyString(DrawItem, First, Last)
      else if (CaretDrawItemNo>0) and (GetItemStyle(DrawItems[CaretDrawItemNo-1].ItemNo)>=0) and
              (ItemLength(DrawItems[CaretDrawItemNo-1].ItemNo)=0) then
        BackSpace_DeletePrevEmptyString(DrawItem, First, Last)
      else if (PrevItemNo=DrawItem.ItemNo-1) and
        RV_CanConcateItems(PrevItemNo, GetItem(PrevItemNo), GetItem(DrawItem.ItemNo), True, False) then
        BackSpace_ConcateItems(DrawItem, First, Last)
      else
        Backspace_MoveToPrev(DrawItem, First, Last);
    end;
    {.....................................................................}
    // Deleting the ItemNo-th item and inserting an empty text instead
    procedure Backspace_ReplaceWithEmptyText(ItemNo, First, Last: Integer);
    var SavedCaretNo, SavedCaretOffs, ItemsAdded, DeletedWidth: Integer;
        FullReformat1, FullReformat2: Boolean;
        OldText, NewText: TRVRawByteString;
        WasTextItem: Boolean;
        TextItem, Item: TCustomRVItemInfo;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      if IsItemParaProtected(ItemNo) or
         IsProtected(ItemNo, rvprDeleteProtect) then begin
        Beep;
        exit;
      end;
      Item := GetItem(ItemNo);
      WasTextItem := Item.StyleNo>=0;
      OldText := Items[ItemNo];
      TextItem := CreateTextItem(0, FCurParaStyleNo, FCurTextStyleNo, Item.SameAsPrev, Item.BR);
      if Item.Checkpoint<>nil then begin
        TextItem.Checkpoint := Item.Checkpoint.CreateCopy(rvoTagsArePChars in Options);
        Do_DeleteCP(ItemNo);
      end;
      if Item.StyleNo=TextItem.StyleNo then
        TextItem.Tag := RV_CopyTag(Item.Tag, rvoTagsArePChars in Options);
      ItemsAdded := 0;
      SavedCaretNo := ItemNo;
      SavedCaretOffs := 1;
      DeletedWidth := CalculateMinItemWidthPlusEx(ItemNo);
      Do_DeleteItem(ItemNo, FullReformat1);
      NewText := '';
      Do_InsertItem(ItemNo, NewText, TextItem, False, FullReformat2);
      if WasTextItem then
        DoItemTextEdit(OldText, ItemNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(ItemNo, 0, True);
      {$ENDIF}
      Reformat_(FullReformat1 or FullReformat2 or (DeletedWidth>=DocumentWidth), First, Last, ItemsAdded);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, False);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Deleting characters from item (but not item itself)
    procedure Backspace_DeleteSubstring(dli: TRVDrawLineInfo; First, Last, Offset: Integer);
    var DeletedWidth, SavedCaretNo, SavedCaretOffs, CD: Integer;
        OldText, NewText: TRVRawByteString;
        r: Boolean;
    begin
      Include(State, rvstKeyPress);
      try
      r := TCustomRichViewEdit(RichView).BeforeChange(False);
      finally
        Exclude(State, rvstKeyPress);
      end;
      if not r then
        exit;
      if IsProtected(dli.ItemNo, rvprModifyProtect) then begin
        Beep;
        exit;
      end;
      DeletedWidth := CalculateParaSectionMinWidthDef(dli.ItemNo);
      OldText := Items[dli.ItemNo];
      NewText := OldText;
      SavedCaretOffs := dli.Offs+Offset-2;
      CD := DeleteCount(NewText, SavedCaretOffs, dli.ItemNo);
      SavedCaretOffs := SavedCaretOffs-CD+1;
      Do_DeleteSubstring(dli.ItemNo, SavedCaretOffs, CD);
      DoItemTextEdit(OldText, dli.ItemNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      TCustomRichView(RichView).AdjustLiveSpellingOnDelete(Self, dli.ItemNo,
        SavedCaretOffs, CD);
      {$ENDIF}
      SavedCaretNo := dli.ItemNo;
      Reformat_((DeletedWidth>=DocumentWidth), First, Last, 0);
      AdjustCaret(SavedCaretNo, SavedCaretOffs, False);
      DoAfterFormatAndCaretPositioning(True);
    end;
    {.....................................................................}
    // Actions on backspace when caret is not at the beginning of line
    procedure Backspace_NotAtTheBeginning(DrawItem: TRVDrawLineInfo; First, Last, Offset: Integer);
    var StyleNo: Integer;
    begin
      StyleNo := GetItemStyle(DrawItem.ItemNo);
      if ((StyleNo<0) and (Offset=1))
         or
         ((StyleNo>=0) and
         (ItemLength(DrawItem.ItemNo) = DeleteCount(Items[DrawItem.ItemNo],
          DrawItem.Offs+Offset-2, DrawItem.ItemNo))) then begin
        if (not GetItem(DrawItem.ItemNo).SameAsPrev
         {$IFNDEF RVDONOTUSELISTS}
           or ((DrawItem.ItemNo>0) and (GetItemStyle(DrawItem.ItemNo-1)=rvsListMarker))
         {$ENDIF}
           )
          and
          ((DrawItem.ItemNo>=ItemCount-1) or (not GetItem(DrawItem.ItemNo+1).SameAsPrev)) then
         Backspace_ReplaceWithEmptyText(DrawItem.ItemNo, First, Last)
       else
         Backspace_DeleteItem(DrawItem.ItemNo, First, Last)
       end
     else
       Backspace_DeleteSubstring(DrawItem, First, Last, Offset);
    end;
    {.....................................................................}
var DrawItem: TRVDrawLineInfo;
    Item: TCustomRVItemInfo;
    First, Last, Offset: Integer;
begin
  CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  DrawItem := DrawItems[CaretDrawItemNo];
  Offset := CharEnds.Items[CaretOffs].Offset;
  Item := GetItem(DrawItem.ItemNo);
  if FromNextLine and (CaretDrawItemNo+1<DrawItems.Count) then begin
    // may be space was eaten?
    if DrawItems[CaretDrawItemNo].ItemNo<>DrawItems[CaretDrawItemNo+1].ItemNo then
      Offset := GetOffsAfterItem(DrawItems[CaretDrawItemNo].ItemNo)-DrawItems[CaretDrawItemNo].Offs+1
  end;

  if IsParaProtected(Item.ParaNo,rvpaoReadOnly) then begin
    Beep;
    exit;
  end;
  if IsCharOffsAtTheLineStartAndItemStart(CaretOffs) then begin
    // ** We are at the beginning of a screen line and an item **
    if (DrawItem.ItemNo=GetFirstNonHiddenItemNo) then begin
      // We are at the very beginning. Removing page break, if exists
      if PageBreaksBeforeItems[DrawItem.ItemNo] then
        TCustomRichViewEdit(RichView).RemoveCurrentPageBreak;
      exit;
    end;
    if Item.GetBoolValue(rvbpFullWidth) or
       (
        (GetPrevNonHiddenItemNo(DrawItem.ItemNo)>=0) and
         GetItem(GetPrevNonHiddenItemNo(DrawItem.ItemNo)).GetBoolValue(rvbpFullWidth) and
         not ((Item.StyleNo>=0) and (ItemLength(DrawItem.ItemNo)=0))
        ) then begin
      // If we are at the beginning of a table (or break), or the previous line is a table (or break),
      // then deleting nothing, just moving the caret to the previous line.
      // The only exception: if we are at the empty paragraph.
      OnLeftPress(False,False);
      exit;
    end;
  end;
  First := CharEnds.Items[0].DrawItemNo;
  Last  := CharEnds.Items[CharEnds.Count-1].DrawItemNo;
  GetParaBoundsEx(First,Last,First,Last, True);

  if IsCharOffsAtTheLineStartAndItemStart(CaretOffs) and not IsFromNewLineEx(DrawItem.ItemNo)
    {$IFNDEF RVDONOTUSELISTS}
    and
    not ((CaretDrawItemNo>0) and (GetItemStyle(DrawItems[CaretDrawItemNo-1].ItemNo)=rvsListMarker))
    {$ENDIF}
    then begin
    // ** We at the beginning of screen line, item, but not paragraph or its section **
    // Moving the caret to the previous line and simulating BACKSPACE again
    dec(CaretDrawItemNo);
    OnChangeCaretLine(0);
    CaretOffs := CharEnds.Count-1;
    OnBackSpacePress_(Ctrl, MultiDelete, True);
    ChangeCaret(False,True,False,True);
    exit;
  end;


  BeginUndoSequence(rvutDelete, True);

  if CaretAtTheBeginningOfParaSectionEx(False) then
    Backspace_AtTheBeginningOfParaSection(DrawItem, First, Last)
  else
    Backspace_NotAtTheBeginning(DrawItem, First, Last, Offset);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ApplyParaStyle(ParaStyleNo: Integer;
  ConvType: TRVEStyleConversionType; Recursive: Boolean);
var i, StartNo,EndNo, SelStartNo, SelEndNo : Integer;
    DIStartNo, DIEndNo, DIStartOffs, DIEndOffs: Integer;
    CIN, CIOffs, SSIN, SSIOffs, SEIN, SEIOffs: Integer;
    FullReformat: Boolean;
    ParaList: TRVIntegerList;
    Changed: Boolean;
    {..................................................................}
    function GetNewStyleNo(OldStyleNo: Integer): Integer;
    begin
      Result := OldStyleNo;
      TCustomRichViewEdit(FRichView).FCurStyleConversion(TCustomRichViewEdit(FRichView),
        OldStyleNo, OldStyleNo, ParaStyleNo, False, Result, True);
    end;
    {...................................................................}
begin
  if FPartialSelectedItem<>nil then begin
    FPartialSelectedItem.ApplyStyleConversionToSubRVDatas(ParaStyleNo, True, ConvType);
    exit;
  end;
  if SelectionExists(True, False) then
    GetSelBounds(DIStartNo, DIEndNo, DIStartOffs, DIEndOffs, True)
  else begin
    DIStartNo := CaretDrawItemNo;
    DIEndNo   := CaretDrawItemNo;
    DIStartOffs := CharEnds.Items[CaretOffs].Offset;
    DIEndOffs := DIStartOffs;
  end;
  StartNo := DrawItems[DIStartNo].ItemNo;
  EndNo   := DrawItems[DIEndNo].ItemNo;
  with CharEnds.Items[CaretOffs] do begin
    CaretDrawItemNo := DrawItemNo;
    CIOffs            := Offset;
  end;
  SelStartNo := StartNo;
  SelEndNo := EndNo;
  if DIStartOffs>=GetOffsAfterDrawItem(DIStartNo) then
    inc(SelStartNo);
  if DIEndOffs<=GetOffsBeforeDrawItem(DIEndNo) then
    dec(SelEndNo);
  DrawItem2Item(CaretDrawItemNo, CIOffs, CIN, CIOffs);
  StoreSelBounds(SSIN,SEIN,SSIOffs,SEIOffs, False);

  ExpandToParaEx(StartNo, EndNo, StartNo, EndNo);

  if ConvType<>rvscParaStyle then begin
    ParaList := TRVIntegerList.Create;
    try
      ParaList.Capacity := EndNo-StartNo+1;
      for i := StartNo to EndNo do
        ParaList.Add(GetNewStyleNo(GetItemPara(i)));
      Changed := Do_ParaList(StartNo, ParaList, FullReformat);
    finally
      ParaList.Free;
    end;
    end
  else
    Changed := Do_Para(StartNo, EndNo, ParaStyleNo, FullReformat);
  if Recursive then
    for i := SelStartNo to SelEndNo do
      GetItem(i).ApplyStyleConversionToSubRVDatas(ParaStyleNo, False, ConvType);

  if Changed then begin
    Item2DrawItem(StartNo, GetOffsBeforeItem(StartNo), DIStartNo, DIStartOffs, rvdpBetterBelow);
    Item2DrawItem(EndNo,   GetOffsAfterItem(EndNo),    DIEndNo,   DIEndOffs, rvdpBetterBelow);
    DestroyResizer;
    try
      Include(State, rvstInvalidSelection);
      if FullReformat then
        Format_(False, True, False, 0, GetFormatCanvas, False, False, False,False)
      else
        FormatParas(DIStartNo, DIEndNo, 0);
    finally
      Exclude(State, rvstInvalidSelection);
    end;
    RestoreSelBounds(SSIN,SEIN,SSIOffs,SEIOffs);
    Item2DrawItem(CIN, CIOffs,CaretDrawItemNo, CaretOffs, rvdpBetterBelow);
    OnChangeCaretLine(CaretOffs-2);
  end;
  ChangeCaret(False,True,False,True);
  DoAfterFormatAndCaretPositioning(True);
  Change;
  Invalidate;
end;
{------------------------------------------------------------------------------}
// Assigns caret position to the selection ending bound.
procedure TRVEditRVData.UpdateSelectionEnd;
begin
  FSelEndNo := CharEnds.Items[CaretOffs].DrawItemNo;
  FSelEndOffs := CharEnds.Items[CaretOffs].Offset;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnHomePress(Shift, Ctrl: Boolean): Boolean;
begin
  Result := Ctrl;
  if Ctrl then begin
    CaretDrawItemNo := 0;
    OnChangeCaretLine(GetOffsBeforeItem(0)-2);
    CaretOffs := 0;
    end
  else begin
    CaretOffs := 0;
    CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  end;
  if Shift then
    UpdateSelectionEnd;
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnEndPress(Shift, Ctrl: Boolean): Boolean;
begin
  Result := Ctrl;
  if Ctrl then begin
    CaretDrawItemNo := DrawItems.Count-1;
    OnChangeCaretLine(0);
    CaretOffs := CharEnds.Count-1;
    end
  else begin
    CaretOffs := CharEnds.Count-1;
    CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  end;
  if Shift then
    UpdateSelectionEnd;  
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
{ Moving caret to the beginning of the previous paragraph.
  Used in paragraph selection mode, for arrow keys movement.                   }
procedure TRVEditRVData.MoveCaretToTheBeginningOfThePrevParagraph(Select: Boolean);
var DrawItemNo, DrawItemOffs: Integer;
begin
  DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  while (DrawItemNo>0) and not IsDrawItemParaStart(DrawItemNo) do
    dec(DrawItemNo);
  if DrawItemNo>0 then
    dec(DrawItemNo);
  while (DrawItemNo>0) and not IsDrawItemParaStart(DrawItemNo) do
    dec(DrawItemNo);
  DrawItemOffs := GetOffsBeforeDrawItem(DrawItemNo);
  CaretDrawItemNo := DrawItemNo;
  OnChangeCaretLine(DrawItemOffs-2);
  if Select then
    UpdateSelectionEnd;
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
{ Moving caret to the end of the next paragraph.
  Used in paragraph selection mode, for arrow keys movement.                   }
procedure TRVEditRVData.MoveCaretToTheEndOfTheNextParagraph(Select: Boolean);
var DrawItemNo, DrawItemOffs: Integer;
begin
  DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  while (DrawItemNo+1<DrawItems.Count-1) and
    not IsDrawItemParaStart(DrawItemNo+1) do
    inc(DrawItemNo);
  if DrawItemNo<DrawItems.Count-1 then
    inc(DrawItemNo);
  while (DrawItemNo+1<DrawItems.Count-1) and
    not IsDrawItemParaStart(DrawItemNo+1) do
    inc(DrawItemNo);
  DrawItemOffs := GetOffsAfterDrawItem(DrawItemNo);
  CaretDrawItemNo := DrawItemNo;
  OnChangeCaretLine(DrawItemOffs-2);
  if Select then
    UpdateSelectionEnd;
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnLeftPress(Shift, Ctrl: Boolean): Boolean;
var no,no2,offs: Integer;
    dli: TRVDrawLineInfo;
    li: TCustomRVItemInfo;
    // IsSpace1,
    IsSpace2, IsDelim1, IsDelim2: Boolean;
    s: TRVRawByteString;
    CodePage: TRVCodePage;
begin
  Result := False;
  if Shift and (FPartialSelectedItem<>nil) then begin
    FPartialSelectedItem.KeyDown(VK_LEFT, True);
    exit;
  end;
  dli := DrawItems[CharEnds.Items[CaretOffs].DrawItemNo];
  li  := GetItem(dli.ItemNo);
  offs := TRVCharPos(CharEnds.Items[CaretOffs]).Offset+dli.Offs-2;
  if Shift and (GetRVStyle.SelectionMode=rvsmParagraph) and
     IsMultiParagraphSelection then begin
    MoveCaretToTheBeginningOfThePrevParagraph(Shift);
    exit;
  end;
  if not Ctrl or (li.StyleNo<0) or (Offs<=0) then begin
    if not CaretAtTheBeginningOfLine then begin
      if Shift or Ctrl or not li.EnterItem(rvedRight,0) then
        dec(CaretOffs)
      end
    else begin
      if CaretDrawItemNo<>0 then begin
        dec(CaretDrawItemNo);
        {$IFNDEF RVDONOTUSELISTS}
        if (CaretDrawItemNo=0) and (GetItemStyle(0)=rvsListMarker) then
          Result := True;
        {$ENDIF}
        CaretOffs := GetOffsAfterDrawItem(CaretDrawItemNo);
        {$IFNDEF RVDONOTUSELISTS}
        AdjustMarkerCaret(False, CaretOffs);
        {$ENDIF}
        OnChangeCaretLine(CaretOffs-2);
        end
      else
        Result := True;
    end
    end
  else begin
    no2 := 0;
    s := Items[dli.ItemNo];
    for no := offs downto 1 do begin
      if (no2<>0) then begin
        //IsSpace1 := RVU_IsSpace(s, no, GetItemOptions(dli.ItemNo));
        IsSpace2 := RVU_IsSpace(s, no+1, GetItemOptions(dli.ItemNo));
        CodePage := GetItemCodePage(dli.ItemNo);
        IsDelim1 := IsDelimiter(s, no, GetItemOptions(dli.ItemNo), CodePage);
        IsDelim2 := IsDelimiter(s, no+1, GetItemOptions(dli.ItemNo), CodePage);
        if (IsDelim1 and not IsDelim2) or
           (not IsDelim1 and not IsSpace2 and IsDelim2) then
          break;
      end;
      inc(no2);
    end;
    if no2<=CaretOffs then
      dec(CaretOffs, no2)
    else begin
      Item2DrawItem(dli.ItemNo, offs-no2+1, CaretDrawItemNo, CaretOffs, rvdpBetterBelow);
      {$IFNDEF RVDONOTUSELISTS}
      AdjustMarkerCaret(False, CaretOffs);
      {$ENDIF}
      OnChangeCaretLine(CaretOffs-2);
    end;
  end;
  if Shift then
    UpdateSelectionEnd;
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnRightPress(Shift, Ctrl: Boolean): Boolean;
var no,no2,offs: Integer;
    dli: TRVDrawLineInfo;
    li: TCustomRVItemInfo;
    IsSpace1, IsSpace2, IsDelim1, IsDelim2: Boolean;
    s: TRVRawByteString;
    CodePage: TRVCodePage;
begin
  Result := False;
  if Shift and (FPartialSelectedItem<>nil) then begin
    FPartialSelectedItem.KeyDown(VK_RIGHT, True);
    exit;
  end;
  if Shift and (GetRVStyle.SelectionMode=rvsmParagraph) and
     IsMultiParagraphSelection then begin
    MoveCaretToTheEndOfTheNextParagraph(Shift);
    exit;
  end;
  if not (Ctrl) then begin
    if not CaretAtTheEndOfLine then begin
      dli := DrawItems[CharEnds.Items[CaretOffs+1].DrawItemNo];
      li  := GetItem(dli.ItemNo);
      if Shift or Ctrl or not li.EnterItem(rvedLeft,0) then
        inc(CaretOffs)
      end
    else begin
      if CaretDrawItemNo<>DrawItems.Count-1 then begin
        inc(CaretDrawItemNo);
        CaretOffs := GetOffsBeforeDrawItem(CaretDrawItemNo);
        {$IFNDEF RVDONOTUSELISTS}
        AdjustMarkerCaret(True, CaretOffs);
        {$ENDIF}
        OnChangeCaretLine(CaretOffs-2);
        end
      else
        Result := True;
    end
    end
  else begin
    inc(CaretOffs);
    if CaretOffs=CharEnds.Count then
      if CaretDrawItemNo=DrawItems.Count-1 then begin
        dec(CaretOffs);
        Result := True;
        exit;
        end
      else begin
        inc(CaretDrawItemNo);
        CaretOffs := GetOffsBeforeDrawItem(CaretDrawItemNo);
        {$IFNDEF RVDONOTUSELISTS}
        AdjustMarkerCaret(True, CaretOffs);
        {$ENDIF}
        OnChangeCaretLine(CaretOffs-2);
      end;
    dli := DrawItems[CharEnds.Items[CaretOffs].DrawItemNo];
    li  := GetItem(dli.ItemNo);
    if li.StyleNo>=0 then begin
      offs := TRVCharPos(CharEnds.Items[CaretOffs]).Offset+dli.Offs-1;
      no2 := 0;
      s := Items[dli.ItemNo];
      if offs>1 then begin
        CodePage := GetItemCodePage(dli.ItemNo);
        for no := offs to ItemLength(dli.ItemNo) do begin
          IsSpace1 := RVU_IsSpace(s, no-1, li.ItemOptions);
          IsDelim1 := IsDelimiter(s, no-1, li.ItemOptions, CodePage);
          IsSpace2 := RVU_IsSpace(s ,no,   li.ItemOptions);
          IsDelim2 := IsDelimiter(s, no,   li.ItemOptions, CodePage);
          if (IsSpace1 and not IsSpace2) or
             (IsDelim1 and not IsDelim2) or
             (not IsDelim1 and not IsSpace2 and IsDelim2) then
            break;
          inc(no2);
        end;
      end;
      if no2+CaretOffs<CharEnds.Count then
        inc(CaretOffs, no2)
      else begin
        Item2DrawItem(dli.ItemNo, offs+no2, CaretDrawItemNo, CaretOffs, rvdpBetterBelow);
        {$IFNDEF RVDONOTUSELISTS}
        AdjustMarkerCaret(True, CaretOffs);
        {$ENDIF}
        OnChangeCaretLine(CaretOffs-2);
      end;
    end;
  end;
  if Shift then
    UpdateSelectionEnd;
  ChangeCaret(False,True,False,False);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnUpPress(Shift,Ctrl: Boolean): Boolean;
var offs: Integer;
    item: TCustomRVItemInfo;
    ditem : TRVDrawLineInfo;
    x, DrawItemNo: Integer;
    r: Boolean;
    {.........................................................}
    // Moves the caret to the beginning of the current paragraph, or
    // if already at the beginning, to the beginning of the next paragraph
    procedure MoveToBeginningOfParagraph;
    var DrawItemNo, offs: Integer;
    begin
      DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
      if CaretOffs=0 then
        dec(DrawItemNo);
      if DrawItemNo<=0 then
        DrawItemNo := 0
      else begin
      {$IFNDEF RVDONOTUSELISTS}
       if (GetDrawItemStyle(DrawItemNo)=rvsListMarker) and (CaretOffs=0) then
         dec(DrawItemNo);
       {$ENDIF}
        while (DrawItemNo>0) and not IsDrawItemParaStart(DrawItemNo) do
          dec(DrawItemNo);
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if GetDrawItemStyle(DrawItemNo)=rvsListMarker then
        inc(DrawItemNo);
      {$ENDIF}
      offs := GetOffsBeforeDrawItem(DrawItemNo);
      CaretDrawItemNo := DrawItemNo;
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;      
      ChangeCaret(False,True,False,False);
    end;
    {.........................................................}
begin
  if Shift and (FPartialSelectedItem<>nil) then begin
    FPartialSelectedItem.KeyDown(VK_UP, True);
    Result := False;
    exit;
  end;
  DrawItemNo := CharEnds.Items[0].DrawItemNo;
  Result := DrawItemNo=0;
  if Ctrl then
    x := CharEnds.Items[CaretOffs].X
  else begin
    if GetUpDownMovingX<>MaxInt then
      x := GetUpDownMovingX
    else begin
      x := CharEnds.Items[CaretOffs].X;
      SetUpDownMovingX(x);
    end;
  end;
  if not Result then begin
    if Shift and (GetRVStyle.SelectionMode=rvsmParagraph) and
       IsMultiParagraphSelection then begin
      MoveCaretToTheBeginningOfThePrevParagraph(Shift);
      exit;
    end;
    if Ctrl then begin
      MoveToBeginningOfParagraph;
      exit;
    end;
    dec(DrawItemNo);
    {$IFNDEF RVDONOTUSELISTS}
    if GetDrawItemStyle(DrawItemNo)=rvsListMarker then begin
      Result := DrawItemNo=0;
      if not Result then
        dec(DrawItemNo)
      else begin
        if Shift and not CaretAtTheBeginningOfLine then begin
          CaretOffs := 0;
          UpdateSelectionEnd;
          ChangeCaret(False,True,False,False);
          end
        else
          ScrollTo(0,True);
        exit;
      end;
    end;
    {$ENDIF}
    FindDrawItemForSel(x, DrawItems[DrawItemNo].Top+1, CaretDrawItemNo, offs,
      False, True);
    ditem := DrawItems[CaretDrawItemNo];
    r := False;
    if (x>=ditem.Left) and (x<=ditem.Left+ditem.Width) then begin
      item := GetItem(ditem.ItemNo);
      if not Shift and not Ctrl and item.EnterItem(rvedBottom, x-ditem.Left) then
        r := True;
    end;
    if not r then begin
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;
      ChangeCaret(False,True,False,False);
    end;
    end
  else if Shift and not CaretAtTheBeginningOfLine then begin
    CaretOffs := 0;
    if Shift then
      UpdateSelectionEnd;
    ChangeCaret(False,True,False,False);
    end
  else if Ctrl then
    MoveToBeginningOfParagraph
  else
    ScrollTo(0,True);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnDownPress(Shift,Ctrl: Boolean): Boolean;
var offs: Integer;
    item: TCustomRVItemInfo;
    ditem : TRVDrawLineInfo;
    x: Integer;
    r: Boolean;
    {.........................................................}
    // Moves caret to the beginning of the next paragraph. If the current
    // paragraph is the last paragraph, moves to the end of it
    procedure MoveToBeginningOfTheNextParagraph;
    var DrawItemNo, offs: Integer;
    begin
      DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo+1;
      while (DrawItemNo<DrawItems.Count) and
        not IsDrawItemParaStart(DrawItemNo) do
        inc(DrawItemNo);
      if DrawItemNo<DrawItems.Count then begin
        {$IFNDEF RVDONOTUSELISTS}
        if GetDrawItemStyle(DrawItemNo)=rvsListMarker then
          inc(DrawItemNo);
        {$ENDIF}
        offs := GetOffsBeforeDrawItem(DrawItemNo);
        end
      else begin
        DrawItemNo := DrawItems.Count-1;
        offs := GetOffsAfterDrawItem(DrawItemNo);
      end;
      CaretDrawItemNo := DrawItemNo;
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;
      ChangeCaret(False,True,False,False);
    end;
    {.........................................................}
begin
  if Shift and (FPartialSelectedItem<>nil) then begin
    FPartialSelectedItem.KeyDown(VK_DOWN, True);
    Result := False;
    exit;
  end;
  if Ctrl then
    x := CharEnds.Items[CaretOffs].X
  else begin
    if GetUpDownMovingX<>MaxInt then
      x := GetUpDownMovingX
    else begin
      x := CharEnds.Items[CaretOffs].X;
      SetUpDownMovingX(x);
    end;
  end;
  Result := CaretInTheLastLine;
  if not Result then begin
    if Shift and (GetRVStyle.SelectionMode=rvsmParagraph) and
       IsMultiParagraphSelection then begin
      MoveCaretToTheEndOfTheNextParagraph(Shift);
      exit;
    end;
    if Ctrl then begin
      MoveToBeginningOfTheNextParagraph;
      exit;
    end;
    FindDrawItemForSel(x,
      DrawItems[CharEnds.Items[CharEnds.Count-1].DrawItemNo+1].Top-
      DrawItems[CharEnds.Items[CharEnds.Count-1].DrawItemNo+1].ExtraSpaceAbove+1,
      CaretDrawItemNo, offs, False, True);
    ditem := DrawItems[CaretDrawItemNo];
    r := False;
    if (x>=ditem.Left) and (x<=ditem.Left+ditem.Width) then begin
      item := GetItem(ditem.ItemNo);
      if not Shift and not Ctrl and item.EnterItem(rvedTop, x-ditem.Left) then
        r := True;
    end;
    if not r then begin
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;      
      ChangeCaret(False,True,False,False);
    end;
    end
  else begin
    if Shift and not CaretAtTheEndOfLine then begin
      CaretOffs := CharEnds.Count-1;
      if Shift then
        UpdateSelectionEnd;
      ChangeCaret(False,True,False,False);
      end
    else if Ctrl then
      MoveToBeginningOfTheNextParagraph
    else
      ScrollTo(DocumentHeight,True);
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnPgUpPress(Shift: Boolean): Boolean;
var offs,x,y: Integer;
    NewDrawLineNo: Integer;
begin
  Result := False;
  if GetUpDownMovingX<>MaxInt then
    x := GetUpDownMovingX
  else begin
    x := CharEnds.Items[CaretOffs].X;
    SetUpDownMovingX(x);
  end;
  y := GetVOffs-(GetHeight * 3 div 4);
  while y>0 do begin
    FindDrawItemForSel(x,y, NewDrawLineNo, offs, False, True);
    if (NewDrawLineNo<CaretDrawItemNo) then begin
      CaretDrawItemNo := NewDrawLineNo;
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;
      ChangeCaret(False,True,False,False);
      exit;
    end;
    dec(y, GetHeight div 2);
  end;
  OnHomePress(Shift, True)
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.OnPgDownPress(Shift: Boolean): Boolean;
var offs,x,y: Integer;
    NewDrawLineNo: Integer;
begin
  Result := False;
  if GetUpDownMovingX<>MaxInt then
    x := GetUpDownMovingX
  else begin
    x := CharEnds.Items[CaretOffs].X;
    SetUpDownMovingX(x);
  end;
  y := GetVOffs+(GetHeight * 3 div 4);
  while y<DocumentHeight do begin
    FindDrawItemForSel(x,y, NewDrawLineNo, offs, False, True);
    if (NewDrawLineNo>CaretDrawItemNo) then begin
      CaretDrawItemNo := NewDrawLineNo;
      OnChangeCaretLine(offs-2);
      if Shift then
        UpdateSelectionEnd;      
      ChangeCaret(False,False,False,False);
      ScrollTo(DrawItems[CaretDrawItemNo].Top,True);
      exit;
    end;
    inc(y, GetHeight div 2);
  end;
  OnEndPress(Shift, True)
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.BuildJumpsCoords(IgnoreReadOnly: Boolean): Integer;
begin
  if not IgnoreReadOnly and TCustomRichViewEdit(FRichView).ReadOnly
    and not (rvoNoReadOnlyJumps in TCustomRichViewEdit(FRichView).EditorOptions) then
    exit;
  if CaptureMouseItem<>nil then exit;
  ClearJumps;
  Result := 0;
  inherited BuildJumpsCoords(Result,jumps);
  Flags := Flags + [rvflUseJumps];
  State := State - [rvstDrawHover];
  Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ClearJumpsCoords;
begin
  if TCustomRichViewEdit(FRichView).ReadOnly and
    not (rvoNoReadOnlyJumps in TCustomRichViewEdit(FRichView).EditorOptions) then
    exit;
  if CaptureMouseItem<>nil then exit;
  if rvflUseJumps in Flags then begin
    ClearJumps;
    Flags := Flags - [rvflUseJumps];
    State := State - [rvstDrawHover];
    ChangeCaret(False,False,True,False);
    Invalidate;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.PrepareForEdit;
begin
  if (Items.Count=0) and (GetRVStyle<>nil) then begin
    AddNLR('',FCurTextStyleNo,FCurParaStyleNo);
    Format_(False, True, False, 0, GetFormatCanvas, False, False, False, True);
    if DrawItems.Count=0 then exit;
    CaretDrawItemNo := 0;
    OnChangeCaretLine(1-2);
    CaretOffs := 0;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Format_(OnlyResized,ForceFormat,NoScroll:Boolean;
  depth: Integer; Canvas: TCanvas; OnlyTail, NoCaching, Reformatting, CallOnFormat: Boolean);
var SavedCaretDrawItemNo, SavedCaretOffs, Offs: Integer;
    saved: Boolean;
begin
  if rvstSkipFormatting in State then
    exit;
  PrepareForEdit;
  if AlreadyFormatted then begin
    AlreadyFormatted := False;
    exit;
  end;
  saved := (depth=0) and
           (GetRVStyle<>nil) and
           not (rvstSkipformatting in State);
  if saved and (OnlyResized or OnlyTail) then begin
    if CaretDrawItemNo<>-1 then
      with CharEnds.Items[CaretOffs] do begin
        CaretDrawItemNo := DrawItemNo;
        Offs            := Offset;
      end;
    DrawItem2Item(CaretDrawItemNo, Offs, {->} SavedCaretDrawItemNo, SavedCaretOffs);
  end;
  inherited;
  if saved then begin
    if (OnlyResized or OnlyTail) then begin
      Item2DrawItem(SavedCaretDrawItemNo, SavedCaretOffs, {->} CaretDrawItemNo, Offs, rvdpBetterBelow);
      OnChangeCaretLine(Offs-2);
      end
    else begin
      Deselect(nil, False);
      if DrawItems.Count=0 then begin
          CaretDrawItemNo := -1;
          CaretOffs   := -1;
        end
      else begin
        CaretDrawItemNo := 0;
        OnChangeCaretLine(GetOffsBeforeItem(0)-2);
        CaretOffs   := 0;
      end;
    end;
    CreateResizer;
    ChangeCaret(False,False, not (rvstEditorUnformatted in State),False);
    if CallOnFormat then
      DoAfterFormatAndCaretPositioning(False);
  end;
  if depth=0 then
    Exclude(State, rvstEditorUnformatted);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ApplyStyleConversion_(UserData: Integer;
  ConvType: TRVEStyleConversionType; ApplyToWholeParas, Recursive: Boolean);
var StartNo,EndNo, StartOffs, EndOffs : Integer;
    SL, EL, SO, EO: Integer;
    DIStartNo, DIEndNo, DLStartOffs, DLEndOffs, i, ConvertedCurStyle: Integer;
    CLN, CLOffs: Integer;
    ItemsAdded, OldWidth, NewWidth: Integer;
    inverted: Boolean;
    {..................................................................}
    function GetNewStyleNo(OldStyleNo, ParaNo: Integer): Integer;
    begin
      Result := OldStyleNo;
      TCustomRichViewEdit(FRichView).FCurStyleConversion(
        TCustomRichViewEdit(FRichView), OldStyleNo, ParaNo, UserData, True, Result,
          ApplyToWholeParas);
    end;
    {...................................................................}
    function NeedClearTag(li: TCustomRVItemInfo; NewStyleNo: Integer): Boolean;
    begin
      Result :=
        (rvoClearTagOnStyleApp in TCustomRichViewEdit(FRichView).EditorOptions)
        and (li.StyleNo<>NewStyleNo);
    end;
    {...................................................................}
    procedure ClrTag(ItemNo, NewStyleNo: Integer);
    var li: TCustomRVItemInfo;
    begin
      li := GetItem(ItemNo);
      if NeedClearTag(li, NewStyleNo) then
        Do_Tag(ItemNo, 0, False);
    end;
    {...................................................................}
    procedure DoSetStyleNo(li: TCustomRVItemInfo; ItemNo, NewStyleNo: Integer);
    {$IFNDEF RVDONOTUSEUNICODE}
    var ActualNewStyleNo: Integer;
    {$ENDIF}
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      ActualNewStyleNo := GetActualStyle2(NewStyleNo,li.ParaNo);
       if GetRVStyle.TextStyles[GetActualStyle(li)].Unicode then begin
         if not GetRVStyle.TextStyles[ActualNewStyleNo].Unicode then begin
           Do_ChangeTextR(ItemNo, RVU_UnicodeToAnsi(GetStyleCodePage(ActualNewStyleNo), Items[ItemNo]));
         end;
         end
      else begin
        if GetRVStyle.TextStyles[NewStyleNo].Unicode then begin
          Do_ChangeTextR(ItemNo, RVU_AnsiToUnicode(GetStyleCodePage(GetActualStyle(li)), Items[ItemNo]));
        end;
      end;
      {$ENDIF}
      Do_StyleNo(ItemNo, NewStyleNo);
    end;
    {...................................................................}
    procedure ApplyToWhole(ItemNo: Integer);
    var NewStyleNo: Integer;
        li: TCustomRVItemInfo;
    begin
      li := GetItem(ItemNo);
      if (li.StyleNo<0) and Recursive then begin
        li.ApplyStyleConversion(Self, ItemNo, UserData, ConvType);
        exit;
      end;
      NewStyleNo := GetNewStyleNo(GetActualStyle(li), li.ParaNo);
      if (li.StyleNo<>NewStyleNo) then begin
        ClrTag(ItemNo, NewStyleNo);
        DoSetStyleNo(li, ItemNo, NewStyleNo);
      end;
    end;
    {...................................................................}
    function GetStr(const s: TRVRawByteString; OldStyleNo, NewStyleNo, ParaNo: Integer): TRVRawByteString;
    {$IFNDEF RVDONOTUSEUNICODE}
    var oldU, newU: Boolean;
    {$ENDIF}
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      oldU := GetRVStyle.TextStyles[GetActualStyle2(OldStyleNo,ParaNo)].Unicode;
      newU := GetRVStyle.TextStyles[GetActualStyle2(NewStyleNo,ParaNo)].Unicode;
      if oldU then
        if not newU then
          Result := RVU_UnicodeToAnsi(GetStyleCodePage(GetActualStyle2(NewStyleNo,ParaNo)), s)
        else
          Result := s
      else
        if newU then
          Result := RVU_AnsiToUnicode(GetStyleCodePage(GetActualStyle2(OldStyleNo,ParaNo)), s)
        else
      {$ENDIF}
          Result := s;
     end;
    {...................................................................}
    procedure ApplyToItemStart(ItemNo: Integer; StartOffs, EndOffs: Integer);
    var  s1: TRVRawByteString;
         tag: Integer;
         curitem, newitem: TCustomRVItemInfo;
         NewStyleNo: Integer;
         Dummy: Boolean;
    begin
      curitem := GetItem(ItemNo);
      NewStyleNo := GetNewStyleNo(GetActualStyle(curitem), curitem.ParaNo);
      if NewStyleNo=curitem.StyleNo then
        exit;
      s1 := RVU_Copy(Items[ItemNo], 1, EndOffs-1, curitem.ItemOptions);
      Do_DeleteSubstring(ItemNo, 1, EndOffs-1);
      if s1='' then
        exit;
      if NeedClearTag(curitem, NewStyleNo) then
        tag := 0
      else
        tag := RV_CopyTag(curitem.Tag, rvoTagsArePChars in Options);

      newitem := InsString(
        GetStr(s1, curitem.StyleNo, NewStyleNo, curitem.ParaNo), ItemNo, tag,
        curitem.ParaNo, NewStyleNo, curitem.SameAsPrev, curitem.BR, Dummy);
      if curitem.Checkpoint<>nil then begin
        Do_AddCP(ItemNo, curitem.Checkpoint.CreateCopy(rvoTagsArePChars in Options));
        Do_DeleteCP(ItemNo+1);
      end;
      if curitem.PageBreakBefore then
        newitem.PageBreakBefore := True;
      newitem.ClearLeft := curitem.ClearLeft;
      newitem.ClearRight := curitem.ClearRight;
      inc(ItemsAdded);
      Do_NewLine(ItemNo+1, True, -1, Dummy);
      EL := ItemNo;
      EO := GetOffsAfterItem(EL);
    end;
    {...................................................................}
    procedure ApplyToItemEnd(ItemNo, StartOffs, EndOffs: Integer);
    var  s2: TRVRawByteString;
         tag, NewStyleNo: Integer;
         curitem: TCustomRVItemInfo;
         Dummy: Boolean;
    begin
      curitem := GetItem(ItemNo);
      NewStyleNo := GetNewStyleNo(GetActualStyle(curitem), curitem.ParaNo);
      if NewStyleNo=curitem.StyleNo then
        exit;
      s2 := RVU_Copy(Items[ItemNo], StartOffs, RVU_Length(Items[ItemNo], curitem.ItemOptions), curitem.ItemOptions);
      Do_DeleteSubstring(ItemNo, StartOffs, -1);
      if s2='' then
        exit;
      if NeedClearTag(curitem, NewStyleNo) then
        tag := 0
      else
        tag := RV_CopyTag(curitem.Tag, rvoTagsArePChars in Options);
      s2 := GetStr(s2, curitem.StyleNo, NewStyleNo, curitem.ParaNo);
      InsString(s2, ItemNo+1, tag, curitem.ParaNo, NewStyleNo, True, False, Dummy);
      inc(ItemsAdded);
      SL := ItemNo;
      SO := GetOffsAfterItem(SL);
      if StartNo=EndNo then begin
        EL := ItemNo+1;
        EO := GetOffsAfterItem(EL);
        end
      else
        inc(EL);
    end;
    {...................................................................}
    procedure ApplyToItemMid(ItemNo, StartOffs, EndOffs: Integer);
    var  s1, s2, s3: TRVRawByteString;
         curitem, newitem: TCustomRVItemInfo;
         Tag, NewStyleNo: Integer;
         Dummy: Boolean;
    begin
      curitem := GetItem(ItemNo);
      NewStyleNo := GetNewStyleNo(GetActualStyle(curitem), curitem.ParaNo);
      if NewStyleNo=curitem.StyleNo then
        exit;
      s1 := RVU_Copy(Items[ItemNo], 1, StartOffs-1, curitem.ItemOptions);
      s2 := RVU_Copy(Items[ItemNo], StartOffs, EndOffs-StartOffs, curitem.ItemOptions);
      s3 := RVU_Copy(Items[ItemNo], EndOffs, RVU_Length(Items[ItemNo], curitem.ItemOptions), curitem.ItemOptions);
      if s1<>'' then begin
        Tag := RV_CopyTag(curitem.Tag, rvoTagsArePChars in Options);
        newitem := InsString2(s1, ItemNo, Tag, curitem, curitem.SameAsPrev, curitem.BR, Dummy);
        if curitem.Checkpoint<>nil then begin
          Do_AddCP(ItemNo, curitem.Checkpoint.CreateCopy(rvoTagsArePChars in Options));
          Do_DeleteCP(ItemNo+1);
        end;
        if curitem.PageBreakBefore then
          newitem.PageBreakBefore := True;
        newitem.ClearLeft := curitem.ClearLeft;
        newitem.ClearRight := curitem.ClearRight;
        inc(ItemsAdded);
        inc(ItemNo);
        Do_NewLine(ItemNo, True, -1, Dummy);
      end;
      if s3<>'' then begin
        tag :=RV_CopyTag(curitem.Tag, rvoTagsArePChars in Options);
        InsString2(s3, ItemNo+1, tag, curitem, True, False, Dummy);
        if (s1='') and (s2='') and (curitem.Checkpoint<>nil) then begin
          Do_AddCP(ItemNo+1, curitem.Checkpoint.CreateCopy(rvoTagsArePChars in Options));
          Do_DeleteCP(ItemNo);
        end;
        inc(ItemsAdded);
      end;

      ClrTag(ItemNo,NewStyleNo);
      Do_DeleteSubstring(ItemNo, EndOffs, -1);
      Do_DeleteSubstring(ItemNo, 1, StartOffs-1);
      DoSetStyleNo(curitem, ItemNo, NewStyleNo);
      SL := ItemNo-1;
      EL := ItemNo;
      SO := GetOffsAfterItem(SL);
      EO := GetOffsAfterItem(EL);

    end;
    {..................................................................}
    procedure ASC_Concate(StartNo, EndNo: Integer);
    var i: Integer;
    begin
      if StartNo>0 then
        dec(StartNo);
      if EndNo<Items.Count-1 then
        inc(EndNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(StartNo, 0, True);
      {$ENDIF}
      {$IFNDEF RVDONOTUSELIVESPELL}
      GetItem(EndNo).ClearWordPainters(0);
      {$ENDIF}
      for i := EndNo downto StartNo+1 do begin
        if RV_CanConcateItems(i-1, GetItem(i-1), GetItem(i), False, False) then begin
          dec(ItemsAdded);
          if i<=SL then begin
            if i=SL then
              inc(SO, RVU_Length(Items[i-1], GetItemOptions(i-1)));
            dec(SL);
          end;
          if i<=EL then begin
            if i=EL then
              inc(EO, RVU_Length(Items[i-1], GetItemOptions(i-1)));
            dec(EL);
          end;
          Do_Concate(i-1);
        end;
        {$IFNDEF RVDONOTUSELIVESPELL}
        GetItem(i-1).ClearWordPainters(0);
        {$ENDIF}
      end;
    end;
    {..................................................................}
begin
  if FPartialSelectedItem<>nil then begin
     FPartialSelectedItem.ApplyStyleConversionToSubRVDatas(UserData, True, ConvType);
     exit;
  end;
  if not (rvprDoNotAutoSwitch in
     GetRVStyle.TextStyles[GetActualCurStyleNo].Protection) then
    FPrevTextStyleNo := FCurTextStyleNo;
  ConvertedCurStyle := FCurTextStyleNo;
  TCustomRichViewEdit(FRichView).FCurStyleConversion(TCustomRichViewEdit(FRichView),
    FCurTextStyleNo, FCurParaStyleNo, UserData, False, ConvertedCurStyle,
    ApplyToWholeParas);
  if not ApplyToWholeParas and not SelectionExists(True, False) then begin
    if (GetItemStyle(GetCurItemNo)>=0) and (Items[GetCurItemNo]='') then begin
      BeginUndoSequence(rvutStyleNo, True);
      ApplyToWhole(GetCurItemNo);
      FormatParas(CaretDrawItemNo, CaretDrawItemNo, 0);
      SetCurTextStyleNo(ConvertedCurStyle);
      ChangeCaret(False,True,True,True);
      Change;
    end;
    SetCurTextStyleNo(ConvertedCurStyle);
    exit;
  end;
  BeginUndoSequence(rvutStyleNo, True);
  GetSelBounds(DIStartNo, DIEndNo, DLStartOffs, DLEndOffs, True);
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, True);
  OldWidth := CalculateParaSectionsMinWidthDef(StartNo, EndNo);
  StoreSelBounds(SL, EL, SO, EO, False);
  inverted := (SL<>StartNo) or (SO<>StartOffs);
  StoreSelBounds(SL, EL, SO, EO, True);
  StartNo := DrawItems[DIStartNo].ItemNo;
  EndNo   := DrawItems[DIEndNo].ItemNo;
  if ApplyToWholeParas then begin
    while (StartNo>0) and not IsParaStart(StartNo) do
      dec(StartNo);
    StartOffs := GetOffsBeforeItem(StartNo);
    while (EndNo+1<ItemCount) and not IsParaStart(EndNo+1) do
      inc(EndNo);
    EndOffs := GetOffsAfterItem(EndNo);
  end;
  GetParaBoundsEx(DIStartNo, DIEndNo,DIStartNo, DIEndNo, True);
  with CharEnds.Items[CaretOffs] do begin
    CaretDrawItemNo := DrawItemNo;
    CLOffs            := Offset;
  end;
  DrawItem2Item(CaretDrawItemNo, CLOffs, CLN, CLOffs);
  ItemsAdded := 0;

  if StartNo=EndNo then begin // (1) one item is selected
    if (GetItemStyle(StartNo)>=0) then begin
      if IsProtected(StartNo, rvprStyleSplitProtect) or
        ((StartOffs<=GetOffsBeforeItem(StartNo)) and (EndOffs>=GetOffsAfterItem(StartNo))) then
        ApplyToWhole(StartNo)
      else if StartOffs<=GetOffsBeforeItem(StartNo) then
        ApplyToItemStart(StartNo, StartOffs, EndOffs)
      else if EndOffs>=GetOffsAfterItem(StartNo) then
        ApplyToItemEnd(StartNo, StartOffs, EndOffs)
      else
        ApplyToItemMid(StartNo, StartOffs, EndOffs);
      end
    else if Recursive then
      GetItem(StartNo).ApplyStyleConversion(Self, StartNo, UserData, ConvType);
    end
  else begin // (2) 2 or more items are selected
    if GetItemStyle(EndNo)>=0 then begin
      if IsProtected(EndNo, rvprStyleSplitProtect) or (EndOffs>=GetOffsAfterItem(EndNo)) then
        ApplyToWhole(EndNo)
      else
        ApplyToItemStart(EndNo, 1, EndOffs);
      end
    else if Recursive then
      GetItem(EndNo).ApplyStyleConversion(Self, EndNo, UserData, ConvType);
    for i := EndNo-1 downto StartNo+1 do
      ApplyToWhole(i);
    if GetItemStyle(StartNo)>=0 then begin
      if IsProtected(EndNo, rvprStyleSplitProtect) or (StartOffs<=GetOffsBeforeItem(StartNo)) then
        ApplyToWhole(StartNo)
      else
        ApplyToItemEnd(StartNo, StartOffs, GetOffsAfterItem(StartNo));
      end
    else if (StartOffs<=GetOffsBeforeItem(StartNo)) and Recursive then
      GetItem(StartNo).ApplyStyleConversion(Self, StartNo, UserData, ConvType);
  end;

  if ApplyToWholeParas then
    ASC_Concate(StartNo, EndNo)
  else
    ASC_Concate(SL, EL);

  if SL<EL then begin
    StartNo := SL;
    EndNo   := EL;
    end
  else begin
    StartNo := EL;
    EndNo   := SL;
  end;
  NewWidth := CalculateParaSectionsMinWidthDef(StartNo,EndNo);
  try
    Include(State, rvstInvalidSelection);
    Reformat_((OldWidth<>NewWidth) and ((OldWidth>=DocumentWidth) or (NewWidth>=DocumentWidth)),
            DIStartNo, DIEndNo, ItemsAdded);
  finally
    Exclude(State, rvstInvalidSelection);
  end;
  if not (rvstSkipFormatting in State) then begin
    if not Inverted then begin
      Item2DrawItem(SL,SO, FSelStartNo, FSelStartOffs, rvdpBetterBelow);
      Item2DrawItem(EL,EO, FSelEndNo, FSelEndOffs, rvdpBetterBelow);
      end
    else begin
      Item2DrawItem(EL,EO, FSelStartNo, FSelStartOffs, rvdpBetterBelow);
      Item2DrawItem(SL,SO, FSelEndNo, FSelEndOffs, rvdpBetterBelow);
    end;
    CaretDrawItemNo := FSelEndNo;
    OnChangeCaretLine(FSelEndOffs-2);
    SetCurTextStyleNo(ConvertedCurStyle);
    ChangeCaret(False,True,True,True);
    DoAfterFormatAndCaretPositioning(True);
    Change;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertTextFromStreamW(Stream: TStream;
  AutoTag: Boolean): Boolean;
var FullText: TRVRawByteString;
begin
  Result := True;
  if Stream.Size=Stream.Position then
    exit;
  SetLength(FullText, Stream.Size-Stream.Position);
  Stream.ReadBuffer(PRVAnsiChar(FullText)^, Length(FullText));
  try
    InsertTextW_(FullText, AutoTag, False);
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertTextFromStream(Stream: TStream;
  OEM, AutoTag: Boolean): Boolean;
var FullText: TRVRawByteString;
begin
  Result := True;
  if Stream.Size=Stream.Position then
    exit;
  SetLength(FullText, Stream.Size-Stream.Position);
  Stream.ReadBuffer(PRVAnsiChar(FullText)^, Length(FullText));
  Replace0(FullText);
  if OEM then
    OEMToAnsi(PRVAnsiChar(FullText),PRVAnsiChar(FullText));
  try
    InsertTextA_(FullText, AutoTag, False);
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertTextFromFileW(const FileName: String; AutoTag: Boolean): Boolean;
var Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := InsertTextFromStreamW(Stream, AutoTag);
  except
    Result := False;
  end;
  Stream.Free;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertTextFromFile(const FileName: String; OEM, AutoTag: Boolean): Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := InsertTextFromStream(Stream, OEM, AutoTag);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AfterAddingText(const SplitText: TRVRawByteString;
  StartItemNo, EndItemNo, ItemsAdded, DIStartNo, DIEndNo: Integer;
  FullReformat, CaretBefore: Boolean);
var Offs, CDIOffs: Integer;
    FR, ConcateTwice: Boolean;
    {$IFNDEF RVDONOTUSELIVESPELL}
    Len: Integer;
    {$ENDIF}
    OldText: TRVRawByteString;
begin
  Do_InsertItems_2(StartItemNo+1, EndItemNo-StartItemNo,
    Do_InsertItems_1(StartItemNo+1, EndItemNo-StartItemNo),
    FR);
  if FR then
    FullReformat := True;
  // concating Items
  if CaretBefore then
    Offs := 1
  else
    Offs := ItemLength(EndItemNo)+1;

  ConcateTwice := (EndItemNo=StartItemNo) and (StartItemNo<>0) and
    RV_CanConcateItems(StartItemNo-1, GetItem(StartItemNo-1), GetItem(StartItemNo),
      False, True);

  if (EndItemNo<>Items.Count-1) then begin
    if RV_CanConcateItems(EndItemNo, GetItem(EndItemNo), GetItem(EndItemNo+1), False, True) then begin
      if SplitText<>'' then
        OldText := SplitText
      else
        OldText := Items[EndItemNo+1];
      Do_Concate(EndItemNo);
      if GetItemStyle(EndItemNo)>=0 then begin
        if not ConcateTwice then
          DoItemTextEdit(OldText, EndItemNo);
        {$IFNDEF RVDONOTUSELIVESPELL}
        GetItem(EndItemNo).ClearWordPainters(0);
        {$ENDIF}
        end
      else if not CaretBefore then
        Offs := 0;
      dec(ItemsAdded);
      end
    else if SplitText<>'' then
      DoItemTextEdit(SplitText, EndItemNo+1);
  end;
  {$IFNDEF RVDONOTUSELIVESPELL}
  Len := 0;
  {$ENDIF}
  if (StartItemNo<>0) then begin
    if RV_CanConcateItems(StartItemNo-1, GetItem(StartItemNo-1), GetItem(StartItemNo), False, True) then begin
      if (GetItemStyle(StartItemNo-1)>=0) and
         (CaretBefore or (StartItemNo=EndItemNo)) then
        inc(Offs, ItemLength(StartItemNo-1));
      {$IFNDEF RVDONOTUSELIVESPELL}
      Len := ItemLength(StartItemNo-1);
      {$ENDIF}
      if SplitText<>'' then
        OldText := SplitText
      else
        OldText := Items[StartItemNo-1];
      Do_Concate(StartItemNo-1);
      if GetItemStyle(StartItemNo-1)>=0 then
        DoItemTextEdit(OldText, StartItemNo-1)
      else
        Offs := 1;
      dec(ItemsAdded);
      dec(EndItemNo);
      dec(StartItemNo);
      {$IFNDEF RVDONOTUSELIVESPELL}
      GetItem(StartItemNo).ClearWordPainters(Len);
      {$ENDIF}
      end
    else if SplitText<>'' then
      DoItemTextEdit(SplitText, StartItemNo-1);
  end;
  AdjustInItemsRange(StartItemNo);
  AdjustInItemsRange(EndItemNo);
  if CalculateMinItemsWidthPlusEx(StartItemNo,EndItemNo)>DocumentWidth then
    FullReformat := True;
  // formatting
  Reformat_(FullReformat, DIStartNo,DIEndNo,ItemsAdded);
  if CaretBefore then
    Item2DrawItem(StartItemNo,Offs, CaretDrawItemNo, CDIOffs, rvdpBetterBelow)
  else
    Item2DrawItem(EndItemNo,Offs, CaretDrawItemNo, CDIOffs, rvdpBetterBelow);
  OnChangeCaretLine(CDIOffs-2);
  ChangeCaret(False,True,False,True);
  {$IFNDEF RVDONOTUSELISTS}
  if not FullReformat and (GetItemStyle(GetFirstParaItem(StartItemNo))=rvsListMarker) then
    UpdateRangeAfterMarkersOrSeq(StartItemNo, EndItemNo);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELIVESPELL}
  LaterSetBackLiveSpellingTo(StartItemNo, Len+1, True);
  {$ENDIF}
  DoAfterFormatAndCaretPositioning(True);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertItemFromTextFile(var s, SplitText: TRVRawByteString;
  item: TCustomRVItemInfo;
  AutoTag, BR: Boolean; var FirstIP, InsertPoint, ItemsAdded, MarkerItemNo: Integer;
  var FirstItem, PageBreak, FromNewLine, FullReformat: Boolean) : Boolean;
var Dummy: Integer;
  {$IFNDEF RVDONOTUSELISTS}
  FR: Boolean;
  {$ENDIF}
begin
  Result := False;
  if PageBreak then begin
    item.PageBreakBefore := True;
    PageBreak := False;
  end;
  {
  if ClearLeft then begin
    item.ClearLeft := True;
    ClearLeft := False;
  end;
  if ClearRight then begin
    item.ClearRight := True;
    ClearRight := False;
  end;
  }
  if FirstItem then begin
    if not InsSomething(item, s, SplitText, AutoTag, False, InsertPoint,
      ItemsAdded, FullReformat, Dummy, FromNewLine) then begin
      Beep;
      exit;
    end;
    FirstIP := InsertPoint;
    {$IFNDEF RVDONOTUSELISTS}
    MarkerItemNo := GetFirstParaItem(InsertPoint);
    if GetItemStyle(MarkerItemNo)<>rvsListMarker then
      MarkerItemNo := -1;
    {$ENDIF}
    FirstItem := False;
    end
  else begin
    inc(InsertPoint);
    inc(ItemsAdded);
    {$IFNDEF RVDONOTUSELISTS}
    if FromNewLine and not BR and (MarkerItemNo>=0) then begin
      FR := False;
      ReplicateMarker(MarkerItemNo, InsertPoint, FR, False, False);
      FullReformat := FullReformat or FR;
      inc(InsertPoint);
      inc(ItemsAdded);
      item.SameAsPrev := True;
      end
    else
    {$ENDIF}
    begin
      item.SameAsPrev := not FromNewLine;
      if FromNewLine and BR then
        item.BR := True;
    end;
    if AutoTag and (item.Tag=0) then
      Item.Tag := RV_CopyTag(FCurTag, rvoTagsArePChars in Options);
    item.Inserting(Self, s, False);
    Items.InsertObject(InsertPoint, s, item);
    item.Inserted(Self, InsertPoint);
  end;
  FromNewLine := False;      
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.InsertTextA_(const text: TRVAnsiString;
  AutoTag, CaretBefore: Boolean);
var DIStartNo, DIEndNo: Integer;
    fulltextstartptr, startptr, ptr, endptr: PRVAnsiChar;
    SkipIfEqual: TRVAnsiChar;
    ItemsAdded, FirstIP,InsertPoint: Integer;
    FirstItem: Boolean;
    {$IFNDEF RVDONOTUSEUNICODE}
    ToUnicode: Boolean;
    CodePage: Cardinal;
    {$ENDIF}
    MarkerItemNo: Integer;
    FullReformat: Boolean;
    FromNewLine, ProcessPageBreaks, PageBreak, ProcessTabs: Boolean;
    SplitText: TRVRawByteString;
    {............................................................}
    function InsertTextItem: Boolean;
    var s: TRVRawByteString;
        item: TCustomRVItemInfo;
    begin
      s := System.Copy(text, StartPtr-FullTextStartPtr+1, Ptr-StartPtr);
      if not ProcessTabs then
        s := RV_ReplaceTabsA(s, GetRVStyle.SpacesInTab);
      {$IFNDEF RVDONOTUSEUNICODE}
      if ToUnicode then
        s := RVU_AnsiToUnicode(CodePage, s);
      {$ENDIF}
      if (s='') and not FromNewLine and not FirstItem then begin
        Result := True;
        exit;
      end;
      item := CreateTextItem(0, FCurParaStyleNo, FCurTextStyleNo, False, False);
      Result := InsertItemFromTextFile(s, SplitText, item, AutoTag, False,
        FirstIP, InsertPoint, ItemsAdded, MarkerItemNo, FirstItem, PageBreak,
        FromNewLine, FullReformat);
    end;
    {............................................................}
    function InsertTabItem: Boolean;
    var s: TRVRawByteString;
        item: TRVTabItemInfo;    
    begin
      item := TRVTabItemInfo.Create(Self);
      item.StyleNo := rvsTab;
      item.TextStyleNo := FCurTextStyleNo;
      item.ParaNo := FCurParaStyleNo;
      Result := InsertItemFromTextFile(s, SplitText, item, AutoTag, False, FirstIP, InsertPoint,
        ItemsAdded, MarkerItemNo, FirstItem, PageBreak,
        FromNewLine, FullReformat);
    end;
    {............................................................}    
begin
  if Text='' then begin
    Invalidate;
    exit;
  end;
  SplitText := '';
  GetParaBoundsEx(CaretDrawItemNo,CaretDrawItemNo,DIStartNo,DIEndNo, True);
  FullReformat := False;
  FirstItem := True;
  InsertPoint := -1;
  FirstIP     := -1;
  ItemsAdded := 0;
  FullTextStartPtr := PRVAnsiChar(Text);
  StartPtr     := FullTextStartPtr;
  Ptr          := StartPtr;
  EndPtr       := FullTextStartPtr+Length(Text);
  SkipIfEqual  := #0;
  ProcessPageBreaks := SupportsPageBreaks;
  PageBreak         := False;
  ProcessTabs       := (GetRVStyle<>nil) and (GetRVStyle.SpacesInTab<=0);
  FromNewLine       := False;
  {$IFNDEF RVDONOTUSEUNICODE}
  ToUnicode   := GetRVStyle.TextStyles[GetActualCurStyleNo].Unicode;
  CodePage    := GetStyleCodePage(GetActualCurStyleNo);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  MarkerItemNo := -1;
  {$ENDIF}
  while Ptr<EndPtr do begin
    if SkipIfEqual<>#0 then begin
      if (ptr^=SkipIfEqual) then begin
        inc(StartPtr);
        inc(Ptr);
        SkipIfEqual := #0;
        continue;
      end;
      SkipIfEqual := #0;
    end;
    if ((Ptr^) in [#10, #12, #13]) or (ProcessTabs and ((Ptr^)=#9)) then begin
      if not InsertTextItem then
        exit;
      StartPtr := Ptr+1;
    end;
    case Ptr^ of
     #9: // tab
       begin
         if ProcessTabs then begin
           if not InsertTabItem then
             exit;
           FromNewLine := False;
         end;
       end;
     #12: // page break
       begin
         PageBreak := ProcessPageBreaks;
         FromNewLine := True;
       end;
     #13:
       begin
         FromNewLine := True;
         SkipIfEqual := #10;
       end;
     #10:
       begin
         FromNewLine := True;
         SkipIfEqual := #13;
       end;
    end;
    inc(ptr);
  end;
  if not InsertTextItem then
    exit;
  if InsertPoint=-1 then
    exit;
  AfterAddingText(SplitText, FirstIP, InsertPoint, ItemsAdded,
    DIStartNo, DIEndNo, FullReformat, CaretBefore);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.InsertTextTyping(text: TRVRawByteString; Key: Char);
var ditem: TRVDrawLineInfo;
    item: TCustomRVItemInfo;
    ItemNo, Offs, Len, TypingOffs : Integer;
    OldText, NewText: TRVRawByteString;
    Minus,SavedCaretOffs: Integer;
    ToNextItem: Boolean;
    {.....................................................}
    procedure DoInsert;
    var SplitText: TRVRawByteString;
    begin
      if not TCustomRichViewEdit(RichView).BeforeChange(False) then
        exit;
      BeginUndoSequence(rvutInsert, True);
      InsertString(Text,SplitText, FCurTextStyleNo, True, False);  { inserting character in new item }
      Change;
      Refresh;      
    end;
    {.....................................................}
begin
  if (GetRVStyle=nil) or (PartialSelectedItem<>nil) or not CanDelete then begin
    Beep;
    exit;
  end;
  Len := Length(text);
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[GetActualCurStyleNo].Unicode then
    Len := Length(text) div 2;
  {$ENDIF}
  CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  ditem := DrawItems[CaretDrawItemNo];
  Minus := 1;
  item := GetItem(ditem.ItemNo);
  if IsParaProtected(item.ParaNo,rvpaoReadOnly) then begin
   Beep;
   exit;
  end;
  Offs := CharEnds.Items[CaretOffs].Offset-1;
  ToNextItem := False;
  if item.StyleNo<>FCurTextStyleNo then
    if (GetOffsInItem(CaretOffs)>=GetOffsAfterItem(ditem.ItemNo)) and
       (CaretDrawItemNo<>DrawItems.Count-1) then begin
      ditem := DrawItems[CaretDrawItemNo+1];
      item := GetItem(ditem.ItemNo);
      Minus := 1;
      Offs := 0;
      ToNextItem := True;
      if (not item.SameAsPrev) or
         (item.StyleNo<>FCurTextStyleNo) then begin
        DoInsert;
        exit;
      end;
      dec(Offs, ditem.Offs-1);
      inc(CaretOffs);
      end
    else begin
       DoInsert;
       exit;
    end;
  { inserting in existing item }

  if item.StyleNo>=0 then begin
    if (rvprConcateProtect in GetRVStyle.TextStyles[GetActualStyle(item)].Protection) or
       (
       (rvprModifyProtect in GetRVStyle.TextStyles[GetActualStyle(item)].Protection) and
       ((ditem.Offs+Offs+1-Minus <= GetOffsBeforeItem(ditem.ItemNo)) or
        (ditem.Offs+Offs+1-Minus >= GetOffsAfterItem(ditem.ItemNo)))
       )
     then begin
      if ToNextItem then
        dec(CaretOffs);
      DoInsert;
      exit;
    end;
    if rvprModifyProtect in GetRVStyle.TextStyles[GetActualStyle(item)].Protection then begin
      if ToNextItem then
        dec(CaretOffs);
      Beep;
      exit;
    end;
  end;
  SavedCaretOffs := ditem.Offs+Offs;
  ItemNo := ditem.ItemNo;
  if Len>1 then begin
    BeginUndoSequence(rvutMiscTyping, True);
    Do_InsertSubstring(ItemNo, ditem.Offs+Offs+1-Minus, text);
    {$IFNDEF RVDONOTUSELIVESPELL}
    LaterSetBackLiveSpellingTo(ItemNo, 0, True);
    {$ENDIF}
    end
  else begin
    TypingOffs := ditem.Offs+Offs+1-Minus;
    OldText := Items[ItemNo];
    if Length(OldText)=0 then
      GetItem(ItemNo).ParaNo := FCurParaStyleNo;
    NewText := OldText;
    RVU_Insert(Text, NewText, SavedCaretOffs+1-Minus, GetItemOptions(ditem.ItemNo));
    Items[ItemNo] := NewText;
    if DoItemTextEditEx(OldText, ItemNo, rvutTyping) then begin
      Items[ItemNo] := OldText;
      Do_InsertSubstring(ItemNo, ditem.Offs+Offs+1-Minus, Text);
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(ItemNo, 0, True);
      {$ENDIF}
      end
    else begin
      Items[ItemNo] := OldText;
      UndoList.AddTyping(ItemNo, TypingOffs,
        rvioUnicode in GetItemOptions(ditem.ItemNo), TCustomRichViewEdit(RichView));
      {$IFNDEF RVDONOTUSELIVESPELL}
      TCustomRichView(RichView).AdjustLiveSpellingOnKeyPress(Self.GetSourceRVData, ItemNo,
        SavedCaretOffs+1-Minus, Key);
      {$ENDIF}
      ItemAction(rviaTextModifying, GetItem(ItemNo), NewText, Self);
      Items[ItemNo] := NewText;
    end;
  end;
  if CalculateParaSectionMinWidthDef(ItemNo)>DocumentWidth then begin
    Format_(False, True, False, 0, GetFormatCanvas, False, False, False, False);
    Invalidate;
    end
  else
    FormatParas(CharEnds.Items[0].DrawItemNo, CharEnds.Items[CharEnds.Count-1].DrawItemNo,0);
  Item2DrawItem(ItemNo, SavedCaretOffs+1, CaretDrawItemNo, CaretOffs, rvdpBetterBelow);
  OnChangeCaretLine(CaretOffs-Minus-1);
  ChangeCaret(False,True,False,False);
  DoAfterFormatAndCaretPositioning(True);
  Change;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.InsertTextW_(const text: TRVRawByteString;
  AutoTag, CaretBefore: Boolean);
var DIStartNo, DIEndNo: Integer;
    startptr,ptr,endptr: PWord;
    SkipIfEqual: Word;
    ItemsAdded, FirstIP,InsertPoint: Integer;
    FirstItem: Boolean;
    ANP: Boolean;
    ConvertToAnsi: Boolean;
    CodePage: Cardinal;
    FullReformat: Boolean;
    PageBreak, ProcessTabs, FromNewLine: Boolean;
    MarkerItemNo: Integer;
    SplitText: TRVRawByteString;
    {............................................................}
    function InsertTextItem: Boolean;
    var s: TRVRawByteString;
        item: TCustomRVItemInfo;
    begin
      s := System.Copy(text, PRVAnsiChar(startptr)-PRVAnsiChar(text)+1,
        PRVAnsiChar(ptr)-PRVAnsiChar(startptr));
      if not ProcessTabs then
        s := RV_ReplaceTabsW(s, GetRVStyle.SpacesInTab);
      if ConvertToAnsi then
        s := RVU_UnicodeToAnsi(CodePage, s);
      if (s='') and not FromNewLine and not FirstItem then
        Result := True
      else begin
        item := CreateTextItem(0, FCurParaStyleNo, FCurTextStyleNo, False, False);
        Result := InsertItemFromTextFile(s, SplitText, item, AutoTag, not ANP, FirstIP, InsertPoint,
          ItemsAdded, MarkerItemNo, FirstItem, PageBreak, FromNewLine,
          FullReformat);
      end;
      StartPtr := PWord(PRVAnsiChar(Ptr)+2);
    end;
    {............................................................}
    function InsertTabItem: Boolean;
    var s: TRVRawByteString;
        item: TRVTabItemInfo;
    begin
      item := TRVTabItemInfo.Create(Self);
      item.StyleNo := rvsTab;
      item.TextStyleNo := FCurTextStyleNo;
      item.ParaNo := FCurParaStyleNo;
      Result := InsertItemFromTextFile(s, SplitText, item, AutoTag, not ANP, FirstIP, InsertPoint,
        ItemsAdded, MarkerItemNo, FirstItem, PageBreak, FromNewLine,
        FullReformat);
    end;
    {............................................................}
begin
  SplitText := ''; 
  FullReformat := False;
  RVCheckUni(Length(text));

  {$IFNDEF RVDONOTUSEUNICODE}
  ConvertToAnsi := not GetRVStyle.TextStyles[GetActualCurStyleNo].Unicode;
  CodePage := GetStyleCodePage(GetActualCurStyleNo);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  MarkerItemNo := -1;
  {$ENDIF}
  ProcessTabs := (GetRVStyle<>nil) and (GetRVStyle.SpacesInTab<=0);

  GetParaBoundsEx(CaretDrawItemNo,CaretDrawItemNo,DIStartNo,DIEndNo, True);

  FirstItem := True;
  InsertPoint := -1;
  FirstIP     := -1;
  ItemsAdded  := 0;
  StartPtr    := PWord(PRVAnsiChar(Text));
  EndPtr      := PWord(PRVAnsiChar(Text)+Length(Text));
  RVU_ProcessByteOrderMark(StartPtr, Length(Text) div 2);
  Ptr         := StartPtr;
  if Ptr=EndPtr then begin
    Invalidate;
    exit;
  end;
  SkipIfEqual := 0;
  ANP         := True;
  PageBreak   := False;
  FromNewLine := False;

  while PRVAnsiChar(ptr)<PRVAnsiChar(endptr) do begin
    if SkipIfEqual<>0 then begin
      if (ptr^=SkipIfEqual) then begin
        inc(PRVAnsiChar(startptr),2);
        inc(PRVAnsiChar(ptr),2);
        SkipIfEqual := 0;
        continue;
      end;
      SkipIfEqual := 0;
    end;
    case ptr^ of
      UNI_LineSeparator, UNI_VerticalTab:
        begin
          if not InsertTextItem then
            exit;
          ANP := False;
          FromNewLine := True;
        end;
      UNI_ParagraphSeparator:
        begin
          if not InsertTextItem then
            exit;
          ANP := True;
          FromNewLine := True;
        end;
      UNI_FF:
        begin
          if not InsertTextItem then
            exit;
          PageBreak := SupportsPageBreaks;
          FromNewLine := True;
        end;
      UNI_CR:
        begin
          if not InsertTextItem then
            exit;
          ANP := True;
          SkipIfEqual := UNI_LF;
          FromNewLine := True;
        end;
      UNI_LF:
        begin
          if not InsertTextItem then
            exit;
          ANP := True;
          SkipIfEqual := UNI_CR;
          FromNewLine := True;
         end;
      UNI_Tab:
        begin
          if ProcessTabs then begin
            if not InsertTextItem then
              exit;
            if not InsertTabItem then
              exit;
            FromNewLine := False;
          end;
        end;
    end;
    inc(PRVAnsiChar(ptr), 2);
  end;
  if not InsertTextItem then
    exit;
  if InsertPoint=-1 then exit;
  AfterAddingText(SplitText, FirstIP, InsertPoint, ItemsAdded,
    DIStartNo, DIEndNo, FullReformat, CaretBefore);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertRVFFromStreamEd_(Stream: TStream):Boolean;
var
    Offs,CDIOffs : Integer;
    DIStartNo, DIEndNo: Integer;
    InsertPoint, LastInserted: Integer;
    dli: TRVDrawLineInfo;
    li: TCustomRVItemInfo;
    FullFormat, FR: Boolean;
    Color : TColor;
    NonFirstItemsAdded, ItemsAdded: Integer;
    ui: TRVUndoInsertItemsInfo;
    FailedBecauseOfProtect: Boolean;
begin
  GetParaBoundsEx(CaretDrawItemNo,CaretDrawItemNo,DIStartNo,DIEndNo, True);
  with CharEnds.Items[CaretOffs] do begin
    dli := DrawItems[DrawItemNo];
    li := GetItem(dli.ItemNo);
    InsertPoint := dli.ItemNo;
    if ((li.StyleNo>=0) and (dli.Offs+Offset-1>=GetOffsAfterItem(dli.ItemNo))) or
       ((li.StyleNo<0) and (Offset=1)) then
      inc(InsertPoint);
  end;
  BeginUndoSequence(rvutInsert, True);
  ItemsAdded := Items.Count;
  Color := TCustomRichView(FRichView).Color;
  FRVFInserted := False;
  Result := InsertRVFFromStream_(Stream, InsertPoint, -1, False, False, True,
    Color, TCustomRichView(FRichView).Background, nil, NonFirstItemsAdded,
    FailedBecauseOfProtect, FullFormat, False);
  if Result and FailedBecauseOfProtect or not FRVFInserted then
    exit;
  if not Result then begin
    TCustomRichViewEdit(FRichView).Format;
    Invalidate;
    Beep;
    exit;
  end;
  TCustomRichView(FRichView).Color := Color;
  ItemsAdded := Items.Count - ItemsAdded;
  LastInserted := InsertPoint+NonFirstItemsAdded;
  if LastInserted>=Items.Count then
    exit;
  Offs := GetOffsAfterItem(LastInserted);
  ui := Do_InsertItems_1(InsertPoint+1, NonFirstItemsAdded);
  Do_InsertItems_2(InsertPoint+1, NonFirstItemsAdded, ui, FR);

  if InsertPoint<0 then
    InsertPoint := 0;
  FullFormat := FullFormat or FR or (CalculateMinItemsWidthPlusEx(InsertPoint,LastInserted) > DocumentWidth);

  ConcateAfterAdding(InsertPoint, LastInserted, ItemsAdded, Offs);

  // formatting
  if FullFormat then begin
    Format_(False,True, False, 0,GetFormatCanvas,False, False, False, False);
    Invalidate;
    end
  else
    FormatParasExact(DIStartNo,DIEndNo,ItemsAdded, False);
  Item2DrawItem(LastInserted, Offs, CaretDrawItemNo, CDIOffs, rvdpBetterBelow);
  OnChangeCaretLine(CDIOffs-2);
  ChangeCaret(False,True,False,True);
  {$IFDEF RVUSELISTORSEQ}
  if not FullFormat then
    UpdateRangeAfterMarkersOrSeq(InsertPoint,LastInserted);
  {$ENDIF}
  DoAfterFormatAndCaretPositioning(True);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTFIMPORT}
function TRVEditRVData.InsertRTFFromStreamEd_(Stream: TStream): Boolean;
var
    Offs,CDIOffs : Integer;
    DIStartNo, DIEndNo: Integer;
    ItemsAdded, InsertPoint, LastInserted: Integer;
    dli: TRVDrawLineInfo;
    li: TCustomRVItemInfo;
    FullFormat, FR: Boolean;
    ui: TRVUndoInsertItemsInfo;
    rp: TRVRTFReaderProperties;
begin
  if Stream.Position=Stream.Size then begin
    Result := True;
    exit;
  end;
  Result := False;
  rp := TRVRTFReaderProperties(GetRTFProperties);
  if rp=nil then
    exit;
  GetParaBoundsEx(CaretDrawItemNo,CaretDrawItemNo,DIStartNo,DIEndNo, True);
  with CharEnds.Items[CaretOffs] do begin
    dli := DrawItems[DrawItemNo];
    li := GetItem(dli.ItemNo);
    InsertPoint := dli.ItemNo;
    if ((li.StyleNo>=0) and (dli.Offs+Offset-1>=GetOffsAfterItem(dli.ItemNo))) or
       ((li.StyleNo<0) and (Offset=1)) then
      inc(InsertPoint);
  end;
  BeginUndoSequence(rvutInsert, True);
  ItemsAdded := Items.Count;
  Result := rp.InsertFromStreamEd(Stream, Self, InsertPoint)=rtf_ec_OK;
  if Result and rp.FailedBecauseOfProtect or (InsertPoint<0) then
    exit;
  if not Result then begin
    TCustomRichViewEdit(FRichView).Format;
    Invalidate;
    Beep;
    exit;
  end;
  ItemsAdded := Items.Count-ItemsAdded;
  LastInserted := InsertPoint+rp.NonFirstItemsAdded;
  Offs := GetOffsAfterItem(LastInserted);

  ui := Do_InsertItems_1(InsertPoint+1, rp.NonFirstItemsAdded);
  Do_InsertItems_2(InsertPoint+1, rp.NonFirstItemsAdded, ui, FR);

  FullFormat := rp.FullReformat or FR or (CalculateMinItemsWidthPlusEx(InsertPoint,LastInserted) > DocumentWidth);

  ConcateAfterAdding(InsertPoint, LastInserted, ItemsAdded, Offs);

  // formatting
  if FullFormat then begin
    Format_(False,True,False, 0,GetFormatCanvas,False, False, False, False);
    Invalidate;
    end
  else
    FormatParasExact(DIStartNo,DIEndNo,ItemsAdded, False);
  Item2DrawItem(LastInserted, Offs, CaretDrawItemNo, CDIOffs, rvdpBetterBelow);
  OnChangeCaretLine(CDIOffs-2);
  ChangeCaret(False,True,False,True);
  {$IFDEF RVUSELISTORSEQ}
  if not FullFormat then
    UpdateRangeAfterMarkersOrSeq(InsertPoint,LastInserted);
  {$ENDIF}
  DoAfterFormatAndCaretPositioning(True);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
function TRVEditRVData.SaveRTFToStream(Stream: TStream; const Path: String;
  SelectionOnly: Boolean; Level: Integer; Color: TColor;
  Background: TRVBackground; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVRTFFontTable; tpp: Double; CompleteDocument, HiddenParent: Boolean;
  Header, Footer: TCustomRVData):Boolean;
begin
  if rvflRootEditor in Flags then
    BuildJumpsCoords(False);
    Result := inherited SaveRTFToStream(Stream, Path, SelectionOnly, Level, Color,
      Background, ColorList, StyleToFont,
      ListOverrideOffsetsList1, ListOverrideOffsetsList2, FontTable, tpp,
      CompleteDocument, HiddenParent, Header, Footer);
  if rvflRootEditor in Flags then
    ClearJumpsCoords;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ConcateAfterAdding(var InsertPoint, LastInserted, ItemsAdded, Offs: Integer);
var li, li2: TCustomRVItemInfo;
    i: Integer;
    atend, FirstDeleted: Boolean;
    fr: Boolean;
    {$IFNDEF RVDONOTUSELIVESPELL}
    Len: Integer;
    {$ENDIF}
begin
  atend := True;
  if LastInserted<>Items.Count-1 then begin
    li := GetItem(LastInserted);
    li2 := GetItem(LastInserted+1);
    if RV_CanConcateItems(LastInserted, li,li2,False,True) then begin
      FirstDeleted := (GetItemStyle(LastInserted)>=0) and (Items[LastInserted]='');
      Do_Concate(LastInserted);
      if GetItemStyle(LastInserted)>=0 then begin
        {$IFNDEF RVDONOTUSELIVESPELL}
        GetItem(LastInserted).ClearWordPainters(0)
        {$ENDIF}
        end
      else if FirstDeleted then begin
        Offs := 0;
        atend := False;
      end;
      dec(ItemsAdded);
      end
    else if li.GetBoolValue(rvbpFullWidth) and li2.SameAsPrev then
      Do_NewLine(LastInserted+1,False,li2.ParaNo,fr);
  end;
  for i := LastInserted downto InsertPoint+1 do begin
    li := GetItem(i-1);
    li2 := GetItem(i);
    SimpleConcateSubitems(i);
    if RV_CanConcateItems(i-1, li,li2,False,True) then begin
      FirstDeleted := (GetItemStyle(i-1)>=0) and (Items[i-1]='');
      if atend and (GetItemStyle(i-1)>=0) then
        inc(Offs, RVU_Length(Items[i-1], GetItemOptions(i-1)));
      Do_Concate(i-1);
      if atend and FirstDeleted and (GetItemStyle(i-1)<0) then begin
        Offs := 0;
        atend := False;
      end;
      dec(ItemsAdded);
      dec(LastInserted);
      end
    else
      atend := False;
  end;
  if (InsertPoint>=0) and (InsertPoint<ItemCount) then
   SimpleConcateSubitems(InsertPoint);
  if InsertPoint<>0 then begin
    li := GetItem(InsertPoint-1);
    li2 := GetItem(InsertPoint);
    if RV_CanConcateItems(InsertPoint-1, li,li2,False,True) then begin
      FirstDeleted := (GetItemStyle(InsertPoint-1)>=0) and (Items[InsertPoint-1]='');
      if atend and (GetItemStyle(InsertPoint-1)>=0) then
        inc(Offs, RVU_Length(Items[InsertPoint-1], GetItemOptions(InsertPoint-1)));
      {$IFNDEF RVDONOTUSELIVESPELL}
      Len := ItemLength(InsertPoint-1);
      {$ENDIF}
      Do_Concate(InsertPoint-1);
      if atend and FirstDeleted and (GetItemStyle(InsertPoint-1)<0) then begin
        Offs := 0;
      end;      
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(InsertPoint-1, Len+1, True);
      {$ENDIF}
      dec(ItemsAdded);
      dec(LastInserted);
      end
    else begin
      if (li2.StyleNo>=0) and li2.SameAsPrev and (Items[InsertPoint]='')
      {$IFNDEF RVDONOTUSELISTS}
      and (li.StyleNo<>rvsListMarker)
      {$ENDIF}
      then begin
        Do_DeleteItem(InsertPoint, fr);
        dec(ItemsAdded);
        dec(LastInserted);
        if InsertPoint=ItemCount then
          dec(InsertPoint);
      end;
      {$IFNDEF RVDONOTUSELIVESPELL}
      LaterSetBackLiveSpellingTo(InsertPoint, 0, True);
      {$ENDIF}
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.GetSelStart(var DINo, DIOffs: Integer);
begin
  inherited GetSelStart(DINo,DIOffs);
  if (DINo=-1) and (CaretDrawItemNo<>-1) then
    with CharEnds.Items[CaretOffs] do begin
      DINo   := DrawItemNo;
      DIOffs := Offset;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SrchSelectIt(StartItemNo, StartOffs,
  EndItemNo, EndOffs: Integer; Invert: Boolean);
begin
  {$IFNDEF RVDONOTUSELIVESPELL}
  LiveSpellingCheckCurrentItem;
  {$ENDIF}
  DeselectPartiallySelectedItem(nil);
  if not Invert then
    RestoreSelBounds(StartItemNo, EndItemNo, StartOffs, EndOffs)
  else
    RestoreSelBounds(EndItemNo, StartItemNo, EndOffs, StartOffs);
  Invalidate;
  DoOnSelection(True);
  DoSelect;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SrchStart(Down, FromStart: Boolean; var strt, offs: Integer);
begin
  if FromStart then begin
    if Down then begin
      strt := 0;
      offs := GetOffsBeforeItem(strt);
      end
    else begin
      strt := ItemCount-1;
      offs := GetOffsAfterItem(strt)+1;
    end;
    exit;
  end;
  strt := GetCurItemNo;
  offs := GetOffsetInCurItem;
  if Down and (offs>=GetOffsAfterItem(strt)) then begin
    inc(strt);
    if strt<Items.Count then
      offs := GetOffsBeforeItem(strt);
    end
  else if not Down and (offs<=GetOffsBeforeItem(strt)) then begin
    dec(strt);
    if strt>=0 then
      offs := GetOffsAfterItem(strt);
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetCurItemNo: Integer;
  {........................................}
  function IndexOf(obj: TCustomRVItemInfo): Integer;
  var ItemNo: Integer;
  begin
    Result := -1;
    if (CaretDrawItemNo>=0) and (CaretDrawItemNo<DrawItems.Count) then begin
      ItemNo := DrawItems[CaretDrawItemNo].ItemNo;
      if (ItemNo>=0) and (ItemNo<Items.Count) and (GetItem(ItemNo)=obj) then
        Result := ItemNo;
    end;
    if Result<0 then
      Result := Items.IndexOfObject(obj);
  end;
  {........................................}
begin
  PrepareForEdit;
  if FPartialSelectedItem<>nil then
    Result := IndexOf(FPartialSelectedItem)
  else if GetChosenItem<>nil then
    Result := IndexOf(GetChosenItem)
  else if (CaretDrawItemNo=-1) or (CaretDrawItemNo>=DrawItems.Count) then
    Result := -1
  else
    Result := DrawItems[CaretDrawItemNo].ItemNo
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetOffsetInCurItem: Integer;
begin
  PrepareForEdit;
  if FPartialSelectedItem<>nil then
    Result := 1
  else if (CaretDrawItemNo<0) or (CaretDrawItemNo>=DrawItems.Count) then
    Result := -1
  else begin
    if GetDrawItemStyle(CaretDrawItemNo)>=0 then
      Result := DrawItems[CaretDrawItemNo].Offs+CharEnds.Items[CaretOffs].Offset-1
    else
      Result := CharEnds.Items[CaretOffs].Offset;
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.NotFormatted: Boolean;
begin
  Result := DrawItems.Count=0;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.StartShiftMoving;
begin
 with CharEnds.Items[CaretOffs] do
   if not SelectionExists(True, False) then begin
     FSelStartNo   := DrawItemNo;
     FSelStartOffs := Offset;
     FSelEndNo     := DrawItemNo;
     FSelEndOffs   := Offset;
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.EndShiftMoving;
begin
  with CharEnds.Items[CaretOffs] do begin
    FSelEndNo     := DrawItemNo;
    FSelEndOffs   := Offset;
  end;
  if GetRVStyle.SelectionMode=rvsmParagraph then
    ExpandSelectionToParagraph(True);
  DoOnSelection(True);
  DoSelect;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.InsertString(var s, SplitText: TRVRawByteString; StyleNo: Integer;
  AutoTag, CaretBefore: Boolean);
var info: TCustomRVItemInfo;
begin
  info         := RichViewTextItemClass.Create(Self);
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[GetActualStyle2(StyleNo, FCurParaStyleNo)].Unicode then
    Include(info.ItemOptions,rvioUnicode);
  {$ENDIF}
  info.StyleNo := StyleNo;
  InsertSomething(info, s, SplitText, AutoTag, CaretBefore, True);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.KeyPress(var Key: Char);
var Text: TRVRawByteString;
{$IFNDEF RVUNICODESTR}
const LeadingByte: TRVAnsiChar = #0;
{$ENDIF}
begin
  if (GetRVStyle=nil) or (PartialSelectedItem<>nil) or not CanDelete then begin
    Beep;
    exit;
  end;
{$IFDEF RVUNICODESTR}
  if GetRVStyle.TextStyles[GetActualCurStyleNo].Unicode then
    Text := RVU_GetRawUnicode(Key)
  else
    Text := RVU_UnicodeToAnsi(RVU_GetKeyboardCodePage, RVU_GetRawUnicode(Key));
{$ELSE}
  Text := Key;
  if (LeadingByte = #0) and
    IsDBCSLeadByteEx(RVU_GetKeyboardCodePage, Byte(Key)) then begin
    LeadingByte := Key;
    exit;
  end;
  if LeadingByte<>#0 then begin
    Text := LeadingByte+Text;
    LeadingByte := #0;
  end;
  {$IFNDEF RVDONOTUSEUNICODE}
  if GetRVStyle.TextStyles[GetActualCurStyleNo].Unicode then begin
    Text := RVU_KeyToUnicode(Text);
    if Length(Text)=0 then
      exit;
  end;
  {$ENDIF}
{$ENDIF}
  InsertTextTyping(Text, Key);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.CreateResizer;
  {..............................................}
  function GetResizerDrawItemNo: Integer;
  begin
    Result := GetOneSelectedItemNo;
    if (Result>=0) and (GetItemStyle(Result)<0) and
       GetItem(Result).GetBoolValue(rvbpResizable) then
      Item2FirstDrawItem(Result, Result)
    else
      Result := -1;
  end;
  {..............................................}
var ResizerDrawItemNo: Integer;
    Item: TCustomRVItemInfo;
begin
  if rvstInvalidSelection in State then
    exit;
  DestroyResizer;
  if (TCustomRichViewEdit(RichView).ReadOnly and
     not (rvflDBRichViewEdit in GetAbsoluteRootData.Flags)) or
     (rvoNoImageResize in TCustomRichViewEdit(RichView).EditorOptions) then
    exit;
  ResizerDrawItemNo := GetResizerDrawItemNo;
  if (ResizerDrawItemNo>=0) and
    not IsItemParaProtected(DrawItems[ResizerDrawItemNo].ItemNo) then begin
    Item := GetItem(DrawItems[ResizerDrawItemNo].ItemNo);
    FResizer := TRVItemResizer.Create(DrawItems[ResizerDrawItemNo],
      Item, ResizerDrawItemNo,
      GetRVStyle.GetAsPixels(Item.GetBorderWidth),
      GetRVStyle.GetAsPixels(Item.GetBorderHeight));
    if GetItem(DrawItems[ResizerDrawItemNo].ItemNo).GetBoolValue(rvbpResizeHandlesOutside) then
      FResizer.Position := rvhpOutside;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DestroyResizer;
begin
  FResizer.Free;
  FResizer := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.UpdateResizer;
begin
  if (FResizer<>nil) and
     ((FResizer.DrawItemNo>=DrawItems.Count) or
      (DrawItems[FResizer.DrawItemNo]<>FResizer.DrawItem)) then
    CreateResizer;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoOnSelection(AllowScrolling: Boolean);

begin
  TCustomRichViewEdit(FRichView).Selecting;
  {$IFNDEF RVDONOTUSELISTS}
  if (FSelEndNo>=0) and (GetDrawItemStyle(FSelEndNo)=rvsListMarker) then begin
    inc(FSelEndNo);
    FSelEndOffs := GetOffsBeforeDrawItem(FSelEndNo);
  end;
  {$ENDIF}
  if (FSelEndNo>=0) then begin
    CaretDrawItemNo := FSelEndNo;
    OnChangeCaretLine(FSelEndOffs-2);
  end;
  CreateResizer;
  {$IFDEF RVDEBUG}{$I Debug\i.inc}{$ENDIF}
  ChangeCaret(False,AllowScrolling,False,False);
  {$IFNDEF RVDONOTUSEANIMATION}
  ResetAniBackground;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Reformat(FullFormat,ForceFormat,
   NoScroll: Boolean; ItemNo: Integer; UpdateView:  Boolean);
var StartNo, EndNo, StartOffs, EndOffs: Integer;
begin
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, False);
  ReformatEx(FullFormat, ForceFormat, NoScroll, ItemNo, UpdateView,
    StartNo, StartOffs, EndNo, EndOffs);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ReformatEx(FullFormat,ForceFormat, NoScroll: Boolean; ItemNo: Integer;
  UpdateView:  Boolean; SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer);
var ln, lo, dlo: Integer;
    curdlno,dummy: Integer;
begin
  DrawItem2Item(CaretDrawItemNo, CharEnds.Items[CaretOffs].Offset, ln, lo);
  if FullFormat then begin
    Format_(True,ForceFormat,NoScroll, 0,GetFormatCanvas,False, False, False, False);
    Invalidate;
    end
  else begin
    if ln=ItemNo then
      curdlno := CaretDrawItemNo
    else
      Item2DrawItem(ItemNo,0,curdlno,dummy, rvdpBetterBelow);
    FormatParas(curdlno,curdlno,0);
  end;
  Item2DrawItem(ln, lo, CaretDrawItemNo, dlo, rvdpBetterBelow);
  OnChangeCaretLine(dlo-2);
  if SelStartNo>=0 then
    RestoreSelBounds(SelStartNo, SelEndNo, SelStartOffs, SelEndOffs);
  ChangeCaret( False,UpdateView,False,UpdateView);
  DoAfterFormatAndCaretPositioning(True);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.InsertFirstRVFItem(var Index: Integer;
  var s: TRVRawByteString; var li: TCustomRVItemInfo; EditFlag: Boolean;
  var FullReformat: Boolean; var NewListNo: Integer):Boolean;
var ItemsAdded: Integer;
    SplitText: TRVRawByteString;
begin
  if EditFlag then begin
    Result := InsSomething(li, s, SplitText, False, EditFlag, Index, ItemsAdded,
      FullReformat, NewListNo, False);
    FRVFInserted := True;
    if not Result then Beep;
    end
  else
    Result := (inherited InsertFirstRVFItem(Index, s, li, EditFlag,
      FullReformat, NewListNo));
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AdjustControlPlacement(ItemNo: Integer);
var dlno: Integer;
    NewWidth, NewHeight, OldWidth, OldHeight: Integer;
begin
  CheckItemClass(ItemNo, TRVControlItemInfo);
  dlno := FindDrawItemByItem(ItemNo);
  if dlno<0 then
    exit;
  with GetItem(ItemNo) as TRVControlItemInfo do
    if (Control<>ResizingControl) then begin
      OldWidth  := DrawItems[dlno].Width-2;
      OldHeight := DrawItems[dlno].Height-2;
      NewWidth  := Control.Width;
      NewHeight := Control.Height;
      if (NewWidth<>OldWidth) or
         (NewHeight<>OldHeight) then
        DoResizeControl(ItemNo,OldWidth,OldHeight,NewWidth,NewHeight)
      else begin
        Control.Left := DrawItems[dlno].Left+1-GetHOffs;
        Control.Tag := DrawItems[dlno].Top+1-GetVOffs;
        RV_Tag2Y(Control);
      end;
      CreateResizer;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ResizeControl(ItemNo, NewWidth, NewHeight: Integer;Reformat: Boolean);
var OldWidth, OldHeight:Integer;
begin
  CheckItemClass(ItemNo, TRVControlItemInfo);
  with GetItem(ItemNo) as TRVControlItemInfo do begin
    OldWidth  := Control.Width;
    OldHeight := Control.Height;
    if (OldWidth=NewWidth) and (OldHeight=NewHeight) then exit;
    ResizingControl := Control;
    try
      Control.SetBounds(Control.Left, Control.Top, NewWidth, NewHeight);
    finally
      ResizingControl := nil;
    end;
  end;
  if Reformat then
    DoResizeControl(ItemNo,OldWidth,OldHeight,NewWidth,NewHeight);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoResizeControl(ItemNo, OldWidth,OldHeight,NewWidth,NewHeight: Integer);
var FullReformat: Boolean;
    NewFWidth, OldFWidth: Integer;
begin
  NewFWidth := CalculateMinItemWidthPlusEx(ItemNo);
  OldFWidth := NewFWidth-NewWidth+OldWidth;
  FullReformat := (OldFWidth<>NewFWidth) and
                  ((OldFWidth>=DocumentWidth) or
                   (NewFWidth> DocumentWidth));
  Reformat(FullReformat,False,False,ItemNo,True);
  Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SelectCurrentWord;
var first, last, ItemNo, Offs, Len: Integer;
    ItemOptions: TRVItemOptions;
    s: TRVRawByteString;
    CodePage: TRVCodePage;
begin
  PrepareForEdit;
  if GetItemStyle(GetCurItemNo)<0 then exit;
  Offs   := GetOffsetInCurItem;
  ItemNo := GetCurItemNo;
  Last   := Offs;
  First  := Offs;
  s      := Items[ItemNo];
  Len    := ItemLength(ItemNo);
  CodePage := GetItemCodePage(ItemNo);
  ItemOptions := GetItemOptions(ItemNo);
  while (Last<=Len) do begin
    if IsDelimiter(s, Last, ItemOptions, CodePage) then
      break;
    inc(Last);
  end;
  dec(First);
  while (First>0) do begin
    if IsDelimiter(s, First, ItemOptions, CodePage) then begin
      inc(First);
      break;
    end;
    dec(First);
  end;
  if First=0 then
    inc(First);
  SetSelectionBounds(ItemNo, First, ItemNo, Last);
  Invalidate;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SplitAtCaret;
var ItemNo, Offs, Len: Integer;
    s: TRVRawByteString;
    FR: Boolean;
begin
  ItemNo := GetCurItemNo;
  Offs := GetOffsetInCurItem;
  if (GetItemStyle(ItemNo)<0) or
    (Offs<=GetOffsBeforeItem(ItemNo)) or (Offs>=GetOffsAfterItem(ItemNo)) then
    exit;
  if IsProtected(ItemNo, rvprModifyProtect) then begin
    Beep;
    exit;
  end;
  Deselect(nil, True);
  BeginUndoSequence(rvutModifyItem, True);
  TCustomRichViewEdit(FRichView).SetUndoGroupMode(True);
  try
    s := Items[ItemNo];
    Len := RVU_Length(s, GetItemOptions(ItemNo))-Offs+1;
    s := RVU_Copy(s, Offs, Len,GetItemOptions(ItemNo));
    Do_DeleteSubstring(ItemNo, Offs, Len);
    InsString(s, ItemNo+1, RV_CopyTag(GetItemTag(ItemNo), rvoTagsArePChars in Options),
      GetItemPara(ItemNo), GetItem(ItemNo).StyleNo, True, False, FR);
  finally
    TCustomRichViewEdit(FRichView).SetUndoGroupMode(False);
  end;
  FormatParas(CaretDrawItemNo, CaretDrawItemNo, 1);
  {$IFNDEF RVDONOTUSELIVESPELL}
  LaterSetBackLiveSpellingTo(ItemNo, 0, True);
  {$ENDIF}
  DoAfterFormatAndCaretPositioning(True);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.InsertPageBreak;
var NeedReformat, FullReformat, InMiddle, InVeryBeginning, InPageBeginning: Boolean;
   ItemNo, Offs: Integer;
begin
  FullReformat := False;
  Deselect(nil, True);
  BeginUndoSequence(rvutInsertPageBreak, True);
  TCustomRichViewEdit(FRichView).SetUndoGroupMode(True);
  try
    ItemNo := GetCurItemNo;
    Offs   := GetOffsetInCurItem;
    InMiddle := (Offs>GetOffsBeforeItem(ItemNo)) or
       (
       GetItem(ItemNo).SameAsPrev
       {$IFNDEF RVDONOTUSELISTS}
       and not ((ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker))
      {$ENDIF}
       );
    InVeryBeginning := (Offs<=GetOffsBeforeItem(ItemNo)) and
      (
      (ItemNo=0)
      {$IFNDEF RVDONOTUSELISTS}
       or ((ItemNo=1) and (GetItemStyle(0)=rvsListMarker))
      {$ENDIF}
      );
    InPageBeginning := not InVeryBeginning and
      (Offs<=GetOffsBeforeItem(ItemNo)) and
      (
      PageBreaksBeforeItems[ItemNo]
      {$IFNDEF RVDONOTUSELISTS}
       or ((ItemNo>0) and (GetItemStyle(ItemNo-1)=rvsListMarker) and
         PageBreaksBeforeItems[ItemNo-1])
      {$ENDIF}
      );
    if InMiddle or InVeryBeginning or InPageBeginning then
      OnEnterPress_(False, False);
    ItemNo := GetCurItemNo;
    if InPageBeginning then begin
      if PageBreaksBeforeItems[ItemNo] then begin
        dec(ItemNo);
        {$IFNDEF RVDONOTUSELISTS}
        if GetItemStyle(ItemNo)=rvsListMarker then
          dec(ItemNo);
        {$ENDIF}
        if ItemNo<0 then
          ItemNo := 0;
      end;
    end;
    NeedReformat := True;//GetItem(ItemNo).BR;
    Do_BR(ItemNo,False, FullReformat);
    Do_PageBreak(ItemNo,True);
  finally
    TCustomRichViewEdit(FRichView).SetUndoGroupMode(False);
  end;
  if NeedReformat then
    Reformat(FullReformat, True, False, GetCurItemNo,True);
  Change;
  Refresh;  
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Change;
begin
  ChangeEx(True);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ChangeEx(ClearRedo: Boolean);
begin
  if FResizer<>nil then begin
    CreateResizer;
  end;
  ResetUpDownMovingX;  
  TCustomRichViewEdit(FRichView).Modified := True;
  if not (rvstDoNotClearCurTag in State) then
    ClearCurTag;
  TCustomRichViewEdit(FRichView).DoChange(ClearRedo);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SetCurParaStyleNo(Value: Integer);
begin
  TCustomRichViewEdit(FRichView).CurParaStyleNo := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SetCurTextStyleNo(Value: Integer);
begin
  TCustomRichViewEdit(FRichView).CurTextStyleNo := Value;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function TRVEditRVData.SaveHTMLToStreamEx(Stream: TStream;
  const Path, Title, ImagesPrefix, ExtraStyles, ExternalCSS, CPPrefix: String;
  Options: TRVSaveOptions; Color: TColor;
  var CurrentFileColor: TColor; var imgSaveNo: Integer;
  LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground; Bullets: TRVList): Boolean;
begin
  if rvflRootEditor in Flags then
    BuildJumpsCoords(False);
  Result := inherited SaveHTMLToStreamEx(Stream, Path, Title, ImagesPrefix, ExtraStyles,
    ExternalCSS, CPPrefix, Options, Color, CurrentFileColor, imgSaveNo,
    LeftMargin, TopMargin, RightMargin, BottomMargin, Background,Bullets);
  if rvflRootEditor in Flags then
    ClearJumpsCoords;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.SaveHTMLToStream(Stream: TStream;
  const Path, Title, ImagesPrefix: String;
  Options: TRVSaveOptions; Color: TColor; var imgSaveNo: Integer;
  LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground; Bullets: TRVList): Boolean;
begin
  if rvflRootEditor in Flags then
    BuildJumpsCoords(False);
  Result := inherited SaveHTMLToStream(Stream, Path, Title,ImagesPrefix,
    Options, Color, imgSaveNo, LeftMargin, TopMargin, RightMargin, BottomMargin,
    Background,Bullets);
  if rvflRootEditor in Flags then
    ClearJumpsCoords;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVEditRVData.GetIMEWinCoord: TPoint;
begin
   with CharEnds.Items[CaretOffs] do begin
     Result.x := X-1+MoveRightTo-GetHOffs;
     Result.y := DrawItems[CaretDrawItemNo].Top-1-GetVOffs;
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.GetSelectionBoundsEx(var StartItemNo,
  StartItemOffs, EndItemNo, EndItemOffs: Integer; Normalize: Boolean);
begin
  if SelectionExists(False,False) then
    inherited
  else begin
    StartItemNo   := GetCurItemNo;
    EndItemNo     := StartItemNo;
    StartItemOffs := GetOffsetInCurItem;
    EndItemOffs   := StartItemOffs;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.GetSelBounds(var StartNo, EndNo, StartOffs, EndOffs: Integer;
  Normalize: Boolean);
begin
  if (FSelStartNo>=0) and (FSelEndNo>=0) then
    inherited
  else begin
    StartNo       := CaretDrawItemNo;
    EndNo         := StartNo;
    if StartNo>=0 then
      StartOffs := CharEnds.Items[CaretOffs].Offset
    else
      StartOffs := -1;
    EndOffs := StartOffs;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.BeginItemModify(ItemNo: Integer; var ModifyData: Integer);
begin
  ModifyData := CalculateMinItemWidthPlusEx(ItemNo);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.EndItemModify(ItemNo, ModifyData: Integer);
var StartNo, EndNo, StartOffs, EndOffs: Integer;
begin
  StoreSelBounds(StartNo, EndNo, StartOffs, EndOffs, False);
  EndItemModifyEx(ItemNo, ModifyData, StartNo, StartOffs, EndNo, EndOffs);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.EndItemModifyEx(ItemNo: Integer; ModifyData: Integer;
  SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer);
var NewW: Integer;
    FullReformat: Boolean;
begin
  NewW := CalculateMinItemWidthPlusEx(ItemNo);
  FullReformat := (NewW<>ModifyData) and
                  ((ModifyData>=DocumentWidth) or (NewW>DocumentWidth));
  ReformatEx(FullReformat, True, False, ItemNo, False,
    SelStartNo, SelStartOffs, SelEndNo, SelEndOffs);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DeselectPartiallySelectedItem(NewPartiallySelected: TCustomRVItemInfo);
var r: Boolean;
    RVData: TCustomRVData;
begin
  r := (FPartialSelectedItem<>nil);
  if r then begin
    RVData := Self;
    while RVData<>nil do begin
      if (rvstClearing in RVData.State) then begin
        r := False;
        break;
      end;
      RVData := RVData.GetAbsoluteParentData;
    end;
  end;
  inherited DeselectPartiallySelectedItem(NewPartiallySelected);
  if r then
    TCustomRichViewEdit(FRichView).AfterCaretMove;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SetPartialSelectedItem(Item: TCustomRVItemInfo);
var r: Boolean;
begin
  r := FPartialSelectedItem<>Item;
  inherited SetPartialSelectedItem(Item);
  if r then
    TCustomRichViewEdit(FRichView).AfterCaretMove;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
begin
  inherited MarkStylesInUse(Data);
  if FCurTextStyleNo<>-1 then begin
    FCurTextStyleNo := GetActualCurStyleNo;
    Data.UsedTextStyles[FCurTextStyleNo] := 1;
  end;
  if FCurParaStyleNo<>-1 then
    Data.UsedParaStyles[FCurParaStyleNo] := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AfterDeleteStyles(Data: TRVDeleteUnusedStylesData);
{$IFNDEF RVDONOTUSEINPLACE}
var inplace: TControl;
{$ENDIF}
begin
  TCustomRichViewEdit(FRichView).ClearUndo;
  if FCurTextStyleNo<>-1 then
    dec(FCurTextStyleNo, Data.UsedTextStyles[FCurTextStyleNo]-1);
  if Data.UsedTextStyles[FPrevTextStyleNo]>0 then
    dec(FPrevTextStyleNo, Data.UsedTextStyles[FPrevTextStyleNo]-1)
  else
    FPrevTextStyleNo := 0;
  if FCurParaStyleNo<>-1 then
    dec(FCurParaStyleNo, Data.UsedParaStyles[FCurParaStyleNo]-1);
  {$IFNDEF RVDONOTUSEINPLACE}
  inplace := GetInplaceEditor;
  if inplace=nil then
  {$ENDIF}
  begin
    State := State + [rvstForceStyleChangeEvent];
    SetCurTextStyleNo(FCurTextStyleNo);
    State := State + [rvstForceStyleChangeEvent];
    SetCurParaStyleNo(FCurParaStyleNo);
  end;
  inherited AfterDeleteStyles(Data);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TRVEditRVData.ReplicateMarker(ReferenceItemNo,
  InsertItemNo: Integer; var FullReformat: Boolean;
  EditFlag, OnlyIfNotHidden: Boolean): Boolean;
var Marker: TRVMarkerItemInfo;
    s: TRVRawByteString;
begin
  Result := False;
  if ReferenceItemNo<0 then
    exit;
  ReferenceItemNo := GetFirstParaItem(ReferenceItemNo);
  if GetItemStyle(ReferenceItemNo)<>rvsListMarker then
    exit;
  if OnlyIfNotHidden and IsHidden(ReferenceItemNo) then
    exit;
  Marker := TRVMarkerItemInfo(RV_DuplicateItem(GetItem(ReferenceItemNo), Self,
    False));
  Marker.DeleteProtect := False;
  Marker.Reset := False;
  Marker.Hidden := False;
  s := Items[ReferenceItemNo];
  if EditFlag then
    Do_InsertItem(InsertItemNo, s, Marker, False, FullReformat)
  else begin
    Marker.Inserting(Self, s, False);
    Items.InsertObject(InsertItemNo,s,Marker);
    Marker.Inserted(Self, InsertItemNo);
    AddMarkerInList(InsertItemNo);
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AdjustMarkerPos(var ItemNo, Offs: Integer;
  DefRight: Boolean);
var Right: Boolean;
begin
  if GetItemStyle(ItemNo)<>rvsListMarker then
    exit;
  Right := (Offs=1) or DefRight;
  if ItemNo=0 then
    Right := True;
  if Right and (ItemNo+1>=Items.Count) then
    exit;
  if Right then begin
    inc(ItemNo);
    Offs := GetOffsBeforeItem(ItemNo);
    end
  else begin
    dec(ItemNo);
    Offs := GetOffsAfterItem(ItemNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AdjustMarkerCaret(Right: Boolean; var Offs: Integer);
begin
  if GetDrawItemStyle(CaretDrawItemNo)<>rvsListMarker then
    exit;
  if CaretDrawItemNo=0 then
    Right := True;
  if Right then begin
    inc(CaretDrawItemNo);
    Offs := GetOffsBeforeDrawItem(CaretDrawItemNo);
    end
  else begin
    dec(CaretDrawItemNo);
    Offs := GetOffsAfterDrawItem(CaretDrawItemNo);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
// Returns offset in the corresponding item for the specified position in CharEnds
function TRVEditRVData.GetOffsInItem(CaretOffs: Integer): Integer;
var DrawItemNo: Integer;
begin
  DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  if GetDrawItemStyle(DrawItemNo)>=0 then
    Result := DrawItems[DrawItemNo].Offs+CharEnds.Items[CaretOffs].Offset-1
  else
    Result := CharEnds.Items[CaretOffs].Offset;
end;
{------------------------------------------------------------------------------}
// Is the caret at the beginning of the paragraph or its section?
// The method takes hidden items into account.
function TRVEditRVData.CaretAtTheBeginningOfParaSectionEx(
  OnlyAllowBeginningOfPara: Boolean): Boolean;
var DrawItem: TRVDrawLineInfo;
    DrawItemNo: Integer;
begin
  Result := CaretOffs=0;
  if not Result then
    exit;
  DrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  DrawItem := DrawItems[DrawItemNo];
  Result := GetOffsInItem(CaretOffs)<=GetOffsBeforeItem(DrawItem.ItemNo);
  if not Result then
    exit;
  {$IFNDEF RVDONOTUSELISTS}
  if (DrawItemNo>0) and not IsFromNewLine(DrawItem.ItemNo) and
    (GetItemStyle(DrawItems[DrawItemNo-1].ItemNo)=rvsListMarker) then begin
    dec(DrawItemNo);
    DrawItem := DrawItems[DrawItemNo];
  end;
  {$ENDIF}
  if OnlyAllowBeginningOfPara then
    Result := IsParaStartEx(DrawItem.ItemNo)
  else
    Result := IsFromNewLineEx(DrawItem.ItemNo);
end;
{------------------------------------------------------------------------------}
// Is the caret at the end of the paragraph or its section?
// The method takes hidden items into account.
function TRVEditRVData.CaretAtTheEndOfParaSectionEx(
  OnlyAllowEndOfPara: Boolean): Boolean;
var DrawItem: TRVDrawLineInfo;
    NextItemNo: Integer;
begin
  CaretDrawItemNo := CharEnds.Items[CaretOffs].DrawItemNo;
  DrawItem := DrawItems[CaretDrawItemNo];
  Result := (CaretOffs=CharEnds.Count-1) and
    (GetOffsInItem(CaretOffs)>=GetOffsAfterItem(DrawItem.ItemNo));
  if not Result then
    exit;
  Result := CaretDrawItemNo=DrawItems.Count-1;
  if Result then
    exit;
  NextItemNo := DrawItems[CaretDrawItemNo+1].ItemNo;
  if OnlyAllowEndOfPara then
    Result := IsParaStartEx(NextItemNo)
  else
    Result := IsFromNewLineEx(NextItemNo);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CaretInTheLastLine: Boolean;
begin
  Result := CharEnds.Items[CharEnds.Count-1].DrawItemNo = DrawItems.Count-1;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CaretAtTheBeginningOfLine: Boolean;
begin
  Result := CaretOffs=0;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CaretAtTheEndOfLine: Boolean;
begin
  Result := CaretOffs=CharEnds.Count-1;
end;
{------------------------------------------------------------------------------}
{$IFDEF RVUSELISTORSEQ}
procedure TRVEditRVData.PrepareForUpdateRangeAfterMarkersOrSeq(StartNo,
  EndNo: Integer; ForDeletion: Boolean;
  var FirstItemNo, LastMarkerIndex, LastSeqIndex: Integer;
  var ListNos: TRVIntegerList;
  var SeqNames: TStringList);
var i: Integer;
    {$IFNDEF RVDONOTUSELISTS}
    Style: TRVStyle;    
    Markers: TRVMarkerList;
    ListNo: Integer;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    SeqList: TRVSeqList;
    SeqName: String;
    {$ENDIF}
begin
  ListNos := nil;
  SeqNames := nil;
  LastMarkerIndex := -1;
  LastSeqIndex    := -1;
  if StartNo<0 then
    exit;
  {$IFNDEF RVDONOTUSELISTS}
  Markers := GetMarkers(False);
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  SeqList := GetSeqList(False);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  if Markers=nil then
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
    if SeqList=nil then
  {$ENDIF}
      exit;
  AdjustInItemsRange(StartNo);
  AdjustInItemsRange(EndNo);
  ExpandToParaEx(StartNo, EndNo, StartNo, EndNo);
  {$IFNDEF RVDONOTUSELISTS}
  ListNos := TRVIntegerList.Create;
  Style := GetRVStyle;  
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  SeqNames := TStringList.Create;
  SeqNames.Sorted := True;
  //SeqNames.CaseSensitive := False;
  SeqNames.Duplicates := dupIgnore;
  {$ENDIF}
  for i := StartNo to EndNo do begin
    {$IFNDEF RVDONOTUSELISTS}
    if GetItemStyle(i)=rvsListMarker then begin
      ListNo := TRVMarkerItemInfo(GetItem(i)).ListNo;
      if (ListNo>=0) and Style.ListStyles[ListNo].HasVariableWidth then begin
        ListNos.AddUnique(ListNo);
        if not ForDeletion or (LastMarkerIndex<0) then
          LastMarkerIndex := TRVMarkerItemInfo(GetItem(i)).GetIndexInList(Markers);
      end;
    end;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    if GetItem(i) is TRVSeqItemInfo then begin
      SeqName := AnsiLowerCase(TRVSeqItemInfo(GetItem(i)).SeqName);
      SeqNames.Add(SeqName);
      if not ForDeletion or (LastSeqIndex<0) then
        LastSeqIndex := TRVSeqItemInfo(GetItem(i)).GetIndexInList(SeqList);
    end;
    {$ENDIF}
  end;
  if ForDeletion then begin
    {$IFNDEF RVDONOTUSELISTS}
    if (LastMarkerIndex>=0) then
      dec(LastMarkerIndex);
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    if (LastSeqIndex>=0) then
      dec(LastSeqIndex);
    {$ENDIF}
  end;
  FirstItemNo := EndNo;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.UpdateAfterMarkersOrSeq(FirstItemNo, LastMarkerIndex,
  LastSeqIndex: Integer; ListNos: TRVIntegerList; SeqNames: TStringList);
var LastMarkerItemNo, LastSeqItemNo, LastItemNo, StartNo, EndNo: Integer;
    {$IFNDEF RVDONOTUSELISTS}
    Markers: TRVMarkerList;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    SeqList: TRVSeqList;
    {$ENDIF}
    FullReformat: Boolean;
begin
  {$IFNDEF RVDONOTUSELISTS}
  Markers := GetMarkers(False);
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  SeqList := GetSeqList(False);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  if Markers=nil then
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
    if SeqList=nil then
  {$ENDIF}
      exit;
  if ((ListNos=nil) or (ListNos.Count=0)) and
     ((SeqNames=nil) or (SeqNames.Count=0)) then
    exit;
  LastMarkerItemNo := -1;
  LastSeqItemNo    := -1;
  FullReformat := False;
  {$IFNDEF RVDONOTUSELISTS}
  if (ListNos<>nil) and (ListNos.Count>0) then begin
    LastMarkerIndex := FindLastMarkerIndex(LastMarkerIndex, ListNos);
    if LastMarkerIndex>=0 then begin
      LastMarkerItemNo := FindItemLocalLocationFrom(FirstItemNo+1, TRVMarkerItemInfo(Markers[LastMarkerIndex]));
      FullReformat := LastMarkerItemNo<0;
    end;
  end;
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  if not FullReformat and (SeqNames<>nil) and (SeqNames.Count>0) then begin
    LastSeqIndex := FindLastSeqIndex(LastSeqIndex, SeqNames);
    if LastSeqIndex>=0 then begin
      LastSeqItemNo := FindItemLocalLocationFrom(FirstItemNo+1, TRVSeqItemInfo(SeqList[LastSeqIndex]));
      FullReformat := LastSeqItemNo<0;
    end;
  end;
  {$ENDIF}
  if not FullReformat then begin
    if LastMarkerItemNo<LastSeqItemNo then
      LastItemNo := LastSeqItemNo
    else
      LastItemNo := LastMarkerItemNo;
    if LastItemNo>=0 then begin
      ExpandToParaEx(FirstItemNo+1, LastItemNo, StartNo, EndNo);
      Do_ReformateRange(StartNo, EndNo, False);
      Item2FirstDrawItem(StartNo, StartNo);
      Item2LastDrawItem(EndNo, EndNo);
      FormatParasExact(StartNo, EndNo, 0, True);
    end;
    end
  else begin
    (GetAbsoluteRootData as TRichViewRVData).Format_(True, True, True, 0, nil,
      False, True, False, False);
    Do_ReformateRange(-1, -1, True);
    (GetAbsoluteRootData as TRichViewRVData).Invalidate;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.UpdateRangeAfterMarkersOrSeq(StartNo, EndNo: Integer);
var FirstItemNo: Integer;
  ListNos: TRVIntegerList;
  LastMarkerIndex: Integer;
  SeqNames: TStringList;
  LastSeqIndex: Integer;
begin
  PrepareForUpdateRangeAfterMarkersOrSeq(StartNo, EndNo, False, FirstItemNo,
    LastMarkerIndex, LastSeqIndex, ListNos, SeqNames);
  try
    UpdateAfterMarkersOrSeq(FirstItemNo, LastMarkerIndex, LastSeqIndex,
      ListNos, SeqNames);
  finally
    ListNos.Free;
    SeqNames.Free;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
procedure TRVEditRVData.ApplyListStyle_(AListNo, AListLevel, AStartFrom: Integer;
  AUseStartFrom, ARecursive: Boolean; Operation: TRVParaListOperation;
  var ItemsAdded, StartNo, EndNo,
  SelStartNo, SelStartOffs, SelEndNo, SelEndOffs: Integer;
  ListNos: TRVIntegerList; var LastVWMarkerIndex: Integer);
var i: Integer;
    FR: Boolean;
    OldMarker, Marker: TRVMarkerItemInfo;
    OldListNo, OldLevel, OldStartFrom: Integer;
    OldUseStartFrom: Boolean;
    OldMarkerCp: TRVCPInfo;
    OldMarkerTag: Integer;
    OldMarkerDeleteProtect: Boolean;
    s: TRVRawByteString;
    Markers: TRVMarkerList;
    {$IFNDEF RVDONOTUSELIVESPELL}
    FirstAffectedItemNo: Integer;
    {$ENDIF}
begin
  ExpandToPara(StartNo, EndNo, StartNo, EndNo);

  ItemsAdded := 0;
  OldListNo       := -1;
  OldLevel        := -1;
  OldStartFrom    := -1;
  OldUseStartFrom := False;

  Markers := GetMarkers(False);
  LastVWMarkerIndex := -1;
  OldMarkerCp     := nil;
  OldMarkerTag    := 0;
  OldMarkerDeleteProtect := False;

  {$IFNDEF RVDONOTUSELIVESPELL}
  FirstAffectedItemNo := -1;
  {$ENDIF}

  for i := EndNo downto StartNo do
    if IsParaStart(i) and not GetItem(i).GetBoolValue(rvbpFullWidth) then begin
       OldMarker := nil;
       if GetItemStyle(i)=rvsListMarker then begin
         OldListNo := TRVMarkerItemInfo(GetItem(i)).ListNo;
         if (OldListNo>=0) and (GetRVStyle.ListStyles[OldListNo].HasVariableWidth) then begin
           ListNos.AddUnique(OldListNo);
           LastVWMarkerIndex := TRVMarkerItemInfo(GetItem(i)).GetIndexInList(Markers);
         end;
         if (Operation in [rvplopLevel,rvplopChange]) then begin
           OldMarker       := TRVMarkerItemInfo(GetItem(i));
           OldListNo       := OldMarker.ListNo;
           OldLevel        := OldMarker.Level;
           OldStartFrom    := OldMarker.StartFrom;
           OldUseStartFrom := OldMarker.Reset;
           if OldMarker.Checkpoint<>nil then
             OldMarkerCp :=
               OldMarker.Checkpoint.CreateCopy(rvoTagsArePChars in Options)
           else
             OldMarkerCp := nil;
           OldMarkerTag := RV_CopyTag(OldMarker.Tag, rvoTagsArePChars in Options);
           OldMarkerDeleteProtect := OldMarker.DeleteProtect;
         end;
         if (Operation=rvplopRemove) and (i+1<Items.Count) then
           Do_NewLine(i+1, False, -1, FR);
         Do_DeleteItem(i, FR);
         {$IFNDEF RVDONOTUSELIVESPELL}
         FirstAffectedItemNo := i;
         {$ENDIF}
         dec(ItemsAdded);
         if (Operation=rvplopRemove) and (SelStartNo=i) then
           SelStartOffs := GetOffsBeforeItem(i)
         else if SelStartNo>i then
           dec(SelStartNo);
         if (Operation=rvplopRemove) and (SelEndNo=i) then
           SelEndOffs := GetOffsBeforeItem(i)
         else if SelEndNo>i then
           dec(SelEndNo);
         dec(EndNo);
       end;
       if (Operation<>rvplopRemove) then begin
         s := '';
         if (Operation = rvplopLevel) and (OldMarker<>nil) then begin
           Marker := TRVMarkerItemInfo.CreateEx(Self, OldListNo,
             OldLevel+AListLevel, OldStartFrom, OldUseStartFrom);
           if Marker.Level>=GetRVStyle.ListStyles[Marker.ListNo].Levels.Count then
             Marker.Level := GetRVStyle.ListStyles[Marker.ListNo].Levels.Count-1;
           if Marker.Level<0 then
             Marker.Level := 0;
           end
         else if Operation=rvplopChange then begin
           if AListLevel<0 then begin
             if OldMarker=nil then
               OldLevel := 0
             end
           else
             OldLevel := AListLevel;
           Marker := TRVMarkerItemInfo.CreateEx(Self, AListNo, OldLevel, AStartFrom, AUseStartFrom and (i=StartNo));
           end
         else
           Marker := nil;
         if Marker<>nil then begin
           if OldMarker<>nil then begin
             Marker.Checkpoint := OldMarkerCP;
             Marker.Tag := OldMarkerTag;
             Marker.DeleteProtect := OldMarkerDeleteProtect;
           end;
           Marker.ParaNo := GetItemPara(i);
           //if (SelStartNo=i) and (OldMarker=nil) then
           //  SelStartOffs := GetOffsBeforeItem(i);
           if SelStartNo>=i then
             inc(SelStartNo);
            //if (SelEndNo=i) and (OldMarker=nil) then
            // SelEndOffs := GetOffsBeforeItem(i);
           if SelEndNo>=i then
             inc(SelEndNo);
           inc(EndNo);
           Do_InsertItem(i, s, marker, False, FR);
           {$IFNDEF RVDONOTUSELIVESPELL}
           FirstAffectedItemNo := i;
           {$ENDIF}
           Do_NewLine(i+1, True, Marker.ParaNo, FR);
           inc(ItemsAdded);
         end;
       end;
  end;
  {$IFNDEF RVDONOTUSELIVESPELL}
  if (FirstAffectedItemNo>=0) and (FirstAffectedItemNo<ItemCount) then
    LaterSetBackLiveSpellingTo(FirstAffectedItemNo, 0, False);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ApplyListStyle(AListNo, AListLevel, AStartFrom: Integer;
                               AUseStartFrom, ARecursive: Boolean;
                               Operation: TRVParaListOperation);
var StartNo, EndNo, StartOffs, EndOffs: Integer;
    OldWidth, NewWidth, ItemsAdded: Integer;
    DIStartNo, DIEndNo: Integer;
    SL, EL, SO, EO: Integer;
    LastVWMarkerIndex: Integer;
    ListNos: TRVIntegerList;
begin
  LastVWMarkerIndex := -1;
  ListNos := TRVIntegerList.Create;
  try
    BeginUndoSequence(rvutList, True);
    SetUndoGroupMode(True);
    try
      GetSelectionBoundsEx(StartNo, StartOffs, EndNo, EndOffs, True);
      GetSelectionBoundsEx(SL, SO, EL, EO, False);
      Item2FirstDrawItem(StartNo,DIStartNo);
      Item2FirstDrawItem(EndNo,DIEndNo);
      GetParaBoundsEx(DIStartNo, DIEndNo,DIStartNo, DIEndNo, True);

      ExpandToPara(StartNo, EndNo, StartNo, EndNo);
      OldWidth := CalculateParaSectionsMinWidthDef(StartNo, EndNo);
      ApplyListStyle_(AListNo, AListLevel, AStartFrom,
        AUseStartFrom, ARecursive, Operation, ItemsAdded,StartNo, EndNo,
        SL, SO, EL, EO, ListNos, LastVWMarkerIndex);
      NewWidth := CalculateParaSectionsMinWidthDef(StartNo, EndNo);
      try
        Include(State, rvstInvalidSelection);
        Reformat_((OldWidth<>NewWidth) and ((NewWidth>DocumentWidth) or (OldWidth>=DocumentWidth)),
                DIStartNo, DIEndNo, ItemsAdded);
      finally
        Exclude(State, rvstInvalidSelection);
      end;
      Item2DrawItem(SL,SO, FSelStartNo, FSelStartOffs, rvdpBetterBelow);
      Item2DrawItem(EL,EO, FSelEndNo, FSelEndOffs, rvdpBetterBelow);
      CaretDrawItemNo := FSelEndNo;
      if FResizer<>nil then
        CreateResizer;      
      OnChangeCaretLine(FSelEndOffs-2);
      ChangeCaret(False, True, False, False);
    finally
      SetUndoGroupMode(False);
      UpdateAfterMarkersOrSeq(EndNo, LastVWMarkerIndex, -1, ListNos, nil);
      DoAfterFormatAndCaretPositioning(True);
      Change;
    end;
  finally
    ListNos.Free;
  end;
  Invalidate;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVEditRVData.PostPaintTo(Canvas: TCanvas; XShift, YShift,
  FirstDrawItemNo, LastDrawItemNo: Integer;
  PrintMode, StrictTop, StrictBottom: Boolean);
begin
  if not PrintMode and (FResizer<>nil) and
    (not StrictTop or (FResizer.DrawItemNo>=FirstDrawItemNo)) and
    (not StrictBottom or (FResizer.DrawItemNo<=LastDrawItemNo)) and
    (GetParentControl.Focused or (GetRVStyle.InactiveSelColor<>clNone)) then
    FResizer.Draw(Canvas, XShift, YShift, GetRVStyle.GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetResizeHandleAt(X, Y: Integer;
  var Index: TRVResizeHandleIndex): Boolean;
begin
  Result := (FResizer<>nil) and FResizer.GetResizeHandleAt(X, Y, GetHOffs, GetVOffs, Index);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.MouseMove(Shift: TShiftState; X, Y: Integer);
var Index: TRVResizeHandleIndex;
begin
  if (FResizer<>nil) and FResizer.Dragging then begin
    XorDrawing;
    FResizer.DragTo(Shift, X,Y, GetHOffs, GetVOffs);
    XorDrawingEx(X,Y);
    end
  else if GetResizeHandleAt(X, Y, Index) then begin
    SetCursor(FResizer.GetResizeHandleCursor(Index));
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Button in [mbLeft, mbRight] then
    SetUpDownMovingX(MaxInt);
  if (FResizer<>nil) and FResizer.MouseDown(X,Y, GetHOffs, GetVOffs) then begin
    XorDrawing;
    SetCursor(crCross);
    Windows.SetCursor(Screen.Cursors[crCross]);
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
var Dragging: Boolean;
begin
  if (FResizer<>nil) and (FResizer.Dragging or FResizer.DragCancelled) then begin
    Dragging := FResizer.Dragging;
    if Dragging then
      ClearXorDrawing;
    FResizer.MouseUp(X,Y, GetHOffs, GetVOffs);
    if Dragging then begin
      SetCursor(GetNormalCursor);
      ResizeItem(FResizer.ItemNo, FResizer.Width, FResizer.Height);
    end;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.XorDrawing;
begin
  if (FResizer<>nil) and (FResizer.Dragging) then begin
    FResizer.XorDrawing(GetCanvas, GetHOffs, GetVOffs);
    XorImageDrawn := not XorImageDrawn;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.CancelResize: Boolean;
begin
  Result := (FResizer<>nil) and FResizer.Dragging;
  if Result then begin
    ClearXorDrawing;
    FResizer.CancelDrag;
    SetCursor(GetNormalCursor);
    Windows.SetCursor(Screen.Cursors[GetNormalCursor]);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.AdjustMouseUpSelection;
begin
  if (FClickedDrawItemNo=LastDIMovedAbove) and (FClickedDrawItemNo>=0) and
     ((GetItem(DrawItems[FClickedDrawItemNo].ItemNo).GetBoolValue(rvbpResizable)
       and not (rvoNoImageResize in TCustomRichViewEdit(RichView).EditorOptions)) or
      GetItem(DrawItems[FClickedDrawItemNo].ItemNo).GetBoolValue(rvbpFloating) or
      GetItem(DrawItems[FClickedDrawItemNo].ItemNo).GetBoolValue(rvbpClickSelect)) and
     not SelectionExists(False, False) then begin
    FSelStartNo := FClickedDrawItemNo;
    FSelEndNo   := FClickedDrawItemNo;
    FSelStartOffs := 0;
    FSelEndOffs   := 1;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ResizeItem(ItemNo, Width, Height: Integer);
var item: TCustomRVItemInfo;
    edit: TCustomRichViewEdit;
    Data: Integer;
    Width2, Height2: TRVStyleLength;
begin
  item := GetItem(ItemNo);
  Width2  := GetRVStyle.PixelsToUnits(Width);
  Height2 :=  GetRVStyle.PixelsToUnits(Height);

  if item is TRVRectItemInfo then begin
    dec(Width, GetRVStyle.GetAsPixels(TRVRectItemInfo(item).GetBorderWidth)*2);
    dec(Height, GetRVStyle.GetAsPixels(TRVRectItemInfo(item).GetBorderHeight)*2);
    dec(Width2, TRVRectItemInfo(item).GetBorderWidth*2);
    dec(Height2, TRVRectItemInfo(item).GetBorderHeight*2);
  end;
  edit := TCustomRichViewEdit(RichView);
  if not edit.BeforeChange(False) then
    exit;
  BeginUndoSequence(rvutModifyItem, True);
  SetUndoGroupMode(True);
  try
    if item is TRVControlItemInfo then begin
      if Width<1 then
        Width := 1;
      if Height<1 then
        Height := 1;
      Do_Resize(ItemNo, Width, Height, True);
      end
    else begin
      if Width2<1 then
        Width2 := 1;
      if Height2<1 then
        Height2 := 1;
      BeginItemModify(ItemNo, Data);
      if item is TRVRectItemInfo then begin
        edit.SetItemExtraIntPropertyEd(ItemNo, rvepImageHeight, Height2, False);
        edit.SetItemExtraIntPropertyEd(ItemNo, rvepImageWidth, Width2, False);
      end;
      EndItemModify(ItemNo, Data);
    end;
  finally
    SetUndoGroupMode(False);
  end;
  Change;
  Invalidate;
  if Assigned(edit.GetRootEditor.OnItemResize) then
    edit.GetRootEditor.OnItemResize(edit.GetRootEditor, Self, ItemNo, -1, -1);
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetActualCurStyleNo: Integer;
begin
  Result := GetActualStyle2(FCurTextStyleNo, FCurParaStyleNo);
end;
{------------------------------------------------------------------------------}
{ Returns True if the ItemNo-th item has a checkpoint with "Persistent" flag   }
function TRVEditRVData.ItemHasPersistentCheckpoint(ItemNo: Integer): Boolean;
begin
  Result := (GetItem(ItemNo).Checkpoint<>nil) and
    GetItem(ItemNo).Checkpoint.Persistent;
end;
{------------------------------------------------------------------------------}
{ Returns True if the paragraph containing the ItemNo-th item has a checkpoint
  with "Persistent" flag                                                       }
function TRVEditRVData.ParaHasPersistentCheckpoint(ItemNo: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  i := ItemNo;
  while i>=0 do begin
    Result := ItemHasPersistentCheckpoint(i);
    if Result then
      exit;
    if IsParaStart(i) then
      break;
    dec(i);
  end;
  i := ItemNo+1;
  while i<ItemCount do begin
    if IsParaStart(i) then
      break;
    Result := ItemHasPersistentCheckpoint(i);
    if Result then
      exit;
    inc(i);
  end;
end;
{------------------------------------------------------------------------------}
{ Moves "persistent" checkpoint from the ItemNo-th item to the adjacent item
  in the same paragraph. If possible (and not OnlyToPrev), to the next item.
  If not, to the previous one. If moving is impossible, returns False.
  If the ItemNo-th item does not have "persistent" checkpoint, returns True.   }
function TRVEditRVData.MovePersistentCheckpoint(ItemNo: Integer;
  OnlyToPrev: Boolean): Boolean;
begin
  Result := True;
  if not ItemHasPersistentCheckpoint(ItemNo) then
    exit;
  if not OnlyToPrev and (ItemNo+1<ItemCount) and not IsParaStart(ItemNo+1) and
     not ItemHasPersistentCheckpoint(ItemNo+1) then
    Do_MoveCP(ItemNo, ItemNo+1)
  else if (ItemNo-1>=0) and not IsParaStart(ItemNo) and
     not ItemHasPersistentCheckpoint(ItemNo-1) then
    Do_MoveCP(ItemNo, ItemNo-1)
  else
    Result := False;
end;
{------------------------------------------------------------------------------}
{ Assigns 0 to FCurTag field. Frees memory.                                    }
procedure TRVEditRVData.ClearCurTag;
begin
  if rvoTagsArePChars in Options then
    StrDispose(PChar(FCurTag));
  FCurTag := 0;
end;
{------------------------------------------------------------------------------}
{ Assigns new value to FCurTag field.
  If a text item is selected, and its style is a current text style,
  assigns a copy of tag of this item.
  Otherwise, assigns 0.                                                        }
procedure TRVEditRVData.AssignCurTag;
var ItemNo: Integer;
begin
  ClearCurTag;
  //ItemNo := GetOneSelectedItemNo;
  ItemNo := GetCurItemNo;
  if (ItemNo>=0) and (GetItemStyle(ItemNo)=FCurTextStyleNo) then
    FCurTag := RV_CopyTag(GetItemTag(ItemNo), rvoTagsArePChars in Options);
end;
{------------------------------------------------------------------------------}
{ If only one item is completely selected, returns its index.
  Otherwise, returns -1.                                                       }
function TRVEditRVData.GetOneSelectedItemNo: Integer;
var itemno1, itemno2, itemoffs1, itemoffs2: Integer;
begin
  Result := -1;
  GetSelectionBoundsEx(itemno1, itemoffs1, itemno2, itemoffs2, True);
  if (itemno1<0) or (itemno2<0) then
    exit;
  if itemoffs1>=GetOffsAfterItem(itemno1) then begin
    inc(itemno1);
    if itemno1>=Items.Count then
      exit;
    itemoffs1 := GetOffsBeforeItem(itemno1);
  end;
  if itemoffs2<=GetOffsBeforeItem(itemno2) then begin
    dec(itemno2);
    if itemno2<0 then
      exit;
    itemoffs2 := GetOffsAfterItem(itemno2);
  end;
  if (itemno1=itemno2) and (itemoffs1<=GetOffsBeforeItem(itemno1)) and
     (itemoffs2>=GetOffsAfterItem(itemno2)) then
    Result := itemno1;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDRAGDROP}
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropTarget related                                               }
{------------------------------------------------------------------------------}
{ Returns information about drag&drop caret location.
  It is used by this RVData and all its children RVDatas (including inplace
  editors)                                                                     }
function TRVEditRVData.GetDragDropCaretInfo: TRVDragDropCaretInfo;
begin
  if rvflRoot in Flags then
    Result := FDragDropCaretInfo
  else
    Result := TCustomRVFormattedData(GetAbsoluteRootData).GetDragDropCaretInfo;
end;
{------------------------------------------------------------------------------}
{ Creates FDragDropCaretInfo (if not created) and increase reference count.
  Only for root editors.                                                       }
procedure TRVEditRVData.CreateDragDropCaretInfo;
begin
  if rvflRoot in Flags then begin
    if FDragDropCaretInfo=nil then
      FDragDropCaretInfo := TRVDragDropCaretInfo.Create;
    inc(FDragDropCaretInfo.RefCount);
  end;
end;
{------------------------------------------------------------------------------}
{ Decrease reference count. If zero, frees FDragDropCaretInfo.
  Only for root editors.                                                       }
procedure TRVEditRVData.ReleaseDragDropCaretInfo;
begin
  if rvflRoot in Flags then
    if FDragDropCaretInfo<>nil then begin
      dec(FDragDropCaretInfo.RefCount);
      if FDragDropCaretInfo.RefCount=0 then begin
        FDragDropCaretInfo.Free;
        FDragDropCaretInfo := nil;
      end;
    end;
end;
{------------------------------------------------------------------------------}
{ Drag&Drop: IDropSource related                                               }
{------------------------------------------------------------------------------}
{ Initializing dragging. Overrides in TRichViewRVData.InitDragging.
  Returns True on success.
  Returns DropSource and OKEffect for call of DoDragDrop.                      }
function TRVEditRVData.InitDragging(var DropSource: TRVDropSource;
  var OKEffect: Integer): Boolean;
begin
  Result := inherited InitDragging(DropSource, OKEffect);
  if Result and (rvflRoot in Flags) and
    (not TCustomRichViewEdit(FRichView).ReadOnly or (rvflDBRichViewEdit in Flags)) and
    CanDelete then
    OKEffect := OKEffect or DROPEFFECT_MOVE;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoneDragging(FDeleteSelection: Boolean);
begin
  inherited DoneDragging(FDeleteSelection);
  if FDeleteSelection then
    TCustomRichViewEdit(RichView).DeleteSelection;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVEditRVData.DoItemTextEdit(const OldText: TRVRawByteString;
  ItemNo: Integer): Boolean;
var NewTag, NewStyleNo: Integer;
begin
  Result := False;
  if Assigned(TCustomRichViewEdit(RichView).OnItemTextEdit) then begin
    NewTag := GetItemTag(ItemNo);
    NewStyleNo := GetActualStyle(GetItem(ItemNo));
    TCustomRichViewEdit(RichView).OnItemTextEdit(
      TCustomRichViewEdit(RichView).GetRootEditor, OldText,
      Self, ItemNo, NewTag, NewStyleNo);
    Result := (GetItemTag(ItemNo)<>NewTag) or (GetItemStyle(ItemNo)<>NewStyleNo);
    Do_Tag(ItemNo, NewTag, True);
    Do_StyleNo(ItemNo, NewStyleNo);
  end;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.DoItemTextEditEx(const OldText: TRVRawByteString; ItemNo: Integer;
  UndoType: TRVUndoType): Boolean;
var NewTag, NewStyleNo: Integer;
begin
  Result := False;
  if Assigned(TCustomRichViewEdit(RichView).OnItemTextEdit) then begin
    NewTag := GetItemTag(ItemNo);
    NewStyleNo := GetActualStyle(GetItem(ItemNo));
    TCustomRichViewEdit(RichView).OnItemTextEdit(
      TCustomRichViewEdit(RichView).GetRootEditor, OldText,
      Self, ItemNo, NewTag, NewStyleNo);
    Result := (GetItemTag(ItemNo)<>NewTag) or (GetItemStyle(ItemNo)<>NewStyleNo);
    if Result then
      BeginUndoSequence(UndoType, True);
    Do_Tag(ItemNo, NewTag, True);
    Do_StyleNo(ItemNo, NewStyleNo);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoCurrentTextStyleConversion(var StyleNo: Integer;
  ParaStyleNo, ItemNo, UserData: Integer; ToWholeParagraphs: Boolean);
var rve: TCustomRichViewEdit;
    NewStyleNo: Integer;
begin
  rve := TCustomRichViewEdit(RichView);
  if not Assigned(rve.FCurStyleConversion) then
    exit;
  rve.FCurStyleConversion(rve, StyleNo, ParaStyleNo, UserData, True, NewStyleNo,
    ToWholeParagraphs);
  Do_AssociatedTextStyleNo(ItemNo, NewStyleNo);
  StyleNo := NewStyleNo;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELIVESPELL}
procedure TRVEditRVData.LaterSetBackLiveSpellingTo(ItemNo, Offs: Integer;
  ClearPainters: Boolean);
begin
  if ClearPainters then
    GetItem(ItemNo).ClearWordPainters(Offs-1);
  TCustomRichView(RichView).LaterSetBackLiveSpellingTo(GetSourceRVData, ItemNo, Offs);
end;

procedure TRVEditRVData.LiveSpellingCheckCurrentItem;
var rve: TCustomRichViewEdit;
begin
  rve := TCustomRichViewEdit(RichView);
  rve.LiveSpellingCheckCurrentItem(rve.TopLevelEditor.RVData.GetSourceRVData,
    rve.TopLevelEditor.CurItemNo);
end;
{$ENDIF}
procedure TRVEditRVData.ActivateCustomCaretTimer;
begin
  if not FCustomCaretActive and
     (TCustomRichViewEdit(RichView).CustomCaretInterval>0) and
     RichView.HandleAllocated then begin
    SetTimer(TCustomRichViewEdit(RichView).Handle, RV_TIMERID_CUSTOMCARET,
      TCustomRichViewEdit(RichView).CustomCaretInterval, nil);
    FCustomCaretActive := True;
  end;
end;

procedure TRVEditRVData.DeactivateCustomCaretTimer;
begin
  if FCustomCaretActive and RichView.HandleAllocated then begin
    KillTimer(TCustomRichViewEdit(RichView).Handle, RV_TIMERID_CUSTOMCARET);
    FCustomCaretActive := False;
  end;
end;

procedure TRVEditRVData.DrawCustomCaret;
var r: TRect;
begin
  ClearCustomCaret;
  if (TCustomRichViewEdit(RichView).InplaceEditor=nil) and
     RichView.FocusedEx and
     (FResizer=nil) and
     (FPartialSelectedItem=nil) and
     {$IFNDEF RVDONOTUSEDRAGDROP}
     (TRVEditRVData(GetAbsoluteRootData).FDragDropCaretInfo=nil) and
     {$ENDIF}
     Assigned(TCustomRichViewEdit(RichView).OnDrawCustomCaret) then begin
    try
      r := FCustomCaretRect;
      if Assigned(TCustomRichViewEdit(RichView).OnMeasureCustomCaret) then
        TCustomRichViewEdit(RichView).OnMeasureCustomCaret(
          TCustomRichViewEdit(RichView).GetRootEditor, r);
      FCustomCaretBack := TBitmap.Create;
      FCustomCaretBack.Width := r.Right-r.Left;
      FCustomCaretBack.Height := r.Bottom-r.Top;
      GetRVStyle.GraphicInterface.CopyRect(FCustomCaretBack.Canvas,
        Rect(0, 0, FCustomCaretBack.Width, FCustomCaretBack.Height),
        RichView.Canvas, r);
      FCustomCaretOldPos := r.TopLeft;
      TCustomRichViewEdit(RichView).OnDrawCustomCaret(
        TCustomRichViewEdit(RichView).GetRootEditor, RichView.Canvas, r);
    except
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ClearCustomCaret;
begin
  if FCustomCaretBack<>nil then begin
    GetRVStyle.GraphicInterface.DrawGraphic(RichView.Canvas,
      FCustomCaretOldPos.X, FCustomCaretOldPos.Y,
      FCustomCaretBack);
    DestroyCustomCaretBack;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DestroyCustomCaretBack;
begin
  FCustomCaretBack.Free;
  FCustomCaretBack := nil;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.PaintBuffered;
begin
  ClearCustomCaret;
  inherited;
  if FCustomCaretActive then
    DrawCustomCaret;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoAfterFormat;
begin
  DeactivateCustomCaretTimer;
  ActivateCustomCaretTimer;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.DoAfterFormatAndCaretPositioning(UpdateControl: Boolean);
begin
  if (rvflRoot in Flags) and Assigned(FOnFormat) then
    FOnFormat(Self);
  if UpdateControl then
    UpdateView;
end;
{------------------------------------------------------------------------------}
function TRVEditRVData.GetUpDownMovingX: Integer;
var OX, OY: Integer;
begin
  Result := (GetAbsoluteRootData as TRVEditRVData).FUpDownMovingX;
  if (Result<>MaxInt) and not (rvflRoot in Flags) then begin
    GetOriginEx(OX, OY);
    dec(Result, OX);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.SetUpDownMovingX(X: Integer);
var OX, OY: Integer;
begin
  if (X<>MaxInt) and not (rvflRoot in Flags) then begin
    GetOriginEx(OX, OY);
    inc(X, OX);
  end;
  (GetAbsoluteRootData as TRVEditRVData).FUpDownMovingX := X;
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.ResetUpDownMovingX;
begin
  SetUpDownMovingX(MaxInt);
end;
{------------------------------------------------------------------------------}
procedure TRVEditRVData.Formatted(FirstItemNo, LastItemNo: Integer;
  Partial: Boolean);
var i: Integer;
begin
  if (DrawItems.Count=0) and (GetRVStyle<>nil) and (GetFirstNonHiddenItemNo<0) then
    for i := 0 to GetRVStyle.TextStyles.Count-1 do
      if not (rvteoHidden in GetRVStyle.TextStyles[i].Options) then begin
        AddNL('', i, 0);
        Format(True);
        exit;
      end;
end;

end.