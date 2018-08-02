
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TCustomRVData is a basic class representing     }
{       RichView document.                              }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit CRVData;

interface
{$I RV_Defs.inc}
uses
  {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  {$IFNDEF RVDONOTUSEJPEGIMAGE}
  Jpeg,
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  RVSeqItem,
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  RVMarker,
  {$ENDIF}
  {$IFDEF RICHVIEWDEF4}
  ImgList,
  {$ENDIF}
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  RVDocParams,
  {$ENDIF}
  RVStyle, RVBack, RVFuncs, RVItem, RVScroll, RVUni, RVClasses,
  RVRTFErr, RVTypes;

type

  { State of RVData }
  TRVState = (
    rvstMakingSelection,     // Mouse selection is in process
    rvstLineSelection,       // Line selection (started from the left margin)
                             //   is in process
    rvstDrawHover,           // There is a highlighted hyperlink
    rvstSkipFormatting,      // Reformatting is not allowed
    rvstFormattingPart,      // Part of document is being formatted
    //rvstIgnoreNextMouseDown, // Next mouse-down event must be ignored
    rvstChangingBkPalette,   // Palette of background image is being updated
                             //   (avoiding recursive call)
    rvstCompletelySelected,  // RVData is completely selected (table cell)
    rvstClearing,            // Document is being cleared
                             //   (avoiding recursive call)
    rvstDoNotMoveChildren,   // Call of AdjustChildrenCoords is not allowed
    rvstForceStyleChangeEvent, // Editor must call events for changing styles
                             //   even if next value assigned to current style
                             //   is equal to the current value
    rvstIgnoreNextChar,      // Next call of WMChar or KeyPress must be ignored
                             //  (the character is already processed in WMKeyDown)
    rvstDoNotTab,            // Next call of DoTabNavigation will be ignored
    rvstDeselecting,         // Deselection is in process
                             //   (avoiding recursive call)
    rvstUnAssigningChosen,   // Unassigning chosen data is in process
                             //   (avoiding recursive call)
    rvstNoScroll,            // Scrolling is not allowed
    rvstFinalizingUndo,      // Avoiding recursive calls of FinalizeUndoGroup
    rvstRTFSkipPar,          // Saving to RTF: do not save paragraph mark
    rvstLoadingAsPartOfItem, // This RVData is loaded from RVF as a part of item
                             //   (cell is loaded with table)
                             //   (not calling AfterLoading(rvlfRVF) for items
                             //   of this RVData: will be called for the container item
    rvstNoKillFocusEvents,   // Disabling processing of WMKillFocus
    rvstEditorUnformatted,   // TRichViewEdit was not formatted before the call of Format
    rvstNameSet,             // TRichView.Name was assigned. Used to detect placing
                             // the component on the form from the Component Palette
    rvstFirstParaAborted,    // This is a page saved and reloaded in ReportHelper,
                             //   and the first paragraph is not completely on this page
    rvstLastParaAborted,     // The same for the last paragraph
    rvstInvalidSelection,    // Selection is not valid: do not create item resizer
    rvstDoNotClearCurTag,    // TRVEditRVData.ChangeEx must not clear "current tag"
                             //   ("current tag" is used in methods for inserting text)
    rvstStartingDragDrop,    // Dragging from this RichView is about to start
                             //   (WM_RVDRAGDROP was posted). Only in absolute
                             //    root RVData
    rvstCanDragDropDeleteSelection, // After dragging from this editor, selection
                             //  must be deleted (set when moving data to
                             //  another control)
    rvstKeyPress,            // do some special processing related to d&d in keypress
    rvstDoNotSaveContent,   // used to copy unselected cells to the Clipboard
    rvstPreserveSoftPageBreaks, // if set, Clear does not clear soft page breaks
    rvstNoDBExitUpdate,     // if set, DBRichViewEdit does not update data when losing focus
    rvstSavingPage,         // set in SavePageAsRVF for root RVData
    rvstCreatingInplace,    // set in root RVData when creating inplace
    rvstNoSpecialCharacters); // this RVData never displays special characters    

  TRVStates = set of TRVState;

  { Flags for RVData }
  TRVFlag = (
    rvflUseJumps,            // List of hyperlink coords must be maintained
    rvflIgnoreMouseLeave,    // Needs ignoring mouse leaving message
    rvflTrim,                // Formatting routine may not show spaces in line
                             //   wrap places (always set)
    rvflShareContents,       // This RVData uses smb. else's items
    rvflUseExternalLeading,  // Formatting routine uses font external leading
                             // (never set)
    rvflMouseXYAlwaysCorrect,// Mouse processing procedures may not preprocess
                             //   coordinates (used in table cells)
    rvflAllowCustomDrawItems,// Formatting routine may create drawing items
                             // of custom types (not only defined in DLines.pas) -
                             // used in RVPrint and RVReportHelper
    rvflPrinting,            // This is RVData with formatting for printing (or
                             //   reports)
    rvflRootEditor,          // This is TRVEditRVData (not RVData of inplace)
    rvflRoot,                // This is TRichViewRVData or TRVEditRVData
                             //  (not RVData of inplace)
    rvflDBRichViewEdit,      // This is TDBRichViewEdit.RVData
    rvflCanUseCustomPPI,     // Allows using RVStyle.TextStyles.PixelsPerInch
    rvflCanProcessGetText);    // Allows processing WM_GETTEXT, WM_SETTEXT, WM_GETTEXTLENGTH
  TRVFlags = set of TRVFlag;

  { Which part to save in RVF? }
  TRVFSaveScope = (
     rvfss_Full,              // the whole document
     rvfss_Selection,         // selection
     rvfss_Page,              // page (for TRVPrint or TRVReportHelper)
     rvfss_FullInPage);        // the whole document, as a part of page

  PRVIntegerList = ^TRVIntegerList;
  TRVRTFFontTable = class;
  TCustomRVData = class;

  TRVEnumItemsProc = procedure (RVData: TCustomRVData; ItemNo: Integer;
    var UserData1: Integer; const UserData2: String;
    var ContinueEnum: Boolean) of object;

  { ----------------------------------------------------------------------------
    TRVLayoutInfo: information about document layout for saving and loading in
    RVF.
    Main properties:
    - margins,
    - min- and maxtextwidth,
    - bidimode.
    For saving RVReportHelper page, additional properties:
    - LastParaAborted: <>0 if the last page paragraph is not completely on the page;
    - FirstParaAborted: the same for the first page paragraph;
    - FirstMarkerListNo, FirstMarkerLevel - information about marker of the
      first page paragraph (marker is before this page)
  }
  TRVLayoutInfo = class
    public
      Loaded: Boolean;
      LeftMargin, RightMargin, TopMargin, BottomMargin: Integer;
      MinTextWidth, MaxTextWidth: Integer;
      BiDiMode: TRVBiDiMode;
      LastParaAborted, FirstParaAborted: Integer;
      FirstMarkerListNo, FirstMarkerLevel: Integer;
      constructor Create;
      procedure SaveToStream(Stream: TStream; IncludeSize, OnlyPageInfo: Boolean);
      procedure LoadFromStream(Stream: TStream; IncludeSize: Boolean);
      procedure SaveTextToStream(Stream: TStream; OnlyPageInfo: Boolean);
      procedure LoadText(const s: TRVAnsiString);
      procedure LoadBinary(const s: TRVRawByteString);
  end;
  {$IFNDEF RVDONOTUSEHTML}
  { ----------------------------------------------------------------------------
    TRVHTMLBulletInfo: information for saving shared images in HTML
      (several items can use the same image file).
    Used by: "bullets", "hotspots", list markers with pictures and image lists.
  }
  TRVHTMLBulletInfo = class
    public
      FileName: String;
      ImageList: TCustomImageList;
      ImageIndex: Integer;
      BackColor: TColor;
      Graphic: TGraphic;
  end;
  {$ENDIF}
  { ----------------------------------------------------------------------------
    TRVRTFFontTableItem: item of RTF font table (TRVRTFFontTable)
  }
  TRVRTFFontTableItem = class
    public
      FontName: String;
      {$IFDEF RICHVIEWCBDEF3}
      Charset: TFontCharset;
      {$ENDIF}
  end;
  { ----------------------------------------------------------------------------
    TRVRTFFontTable: RTF font table. Created for saving to RTF, contains all
    fonts used in the document (both by styles and by items)
  }
  TRVRTFFontTable = class (TRVList)
    private
      function Get(Index: Integer): TRVRTFFontTableItem;
      procedure Put(Index: Integer; const Value: TRVRTFFontTableItem);
    public
      function Find(const FontName: String
        {$IFDEF RICHVIEWCBDEF3}; Charset: TFontCharset{$ENDIF}): Integer;
      function AddUnique(const FontName: String
        {$IFDEF RICHVIEWCBDEF3}; Charset: TFontCharset{$ENDIF}): Integer;
      property Items[Index: Integer]: TRVRTFFontTableItem read Get write Put; default;
  end;
  { ----------------------------------------------------------------------------
    TCustomRVData: RichView document. This class is not used directly.
    Direct descendant: TCustomRVFormattedData.
  }
  TCustomRVData = class(TPersistent)
  private
    { Private declarations }
    FFirstJumpNo: Integer;
    FItems: TRVItemList;
    procedure CheckItemIndex(i: Integer);
    { Property values }
    function GetPageBreaksBeforeItems(Index: Integer): Boolean;
    procedure SetPageBreaksBeforeItems(Index: Integer;  Value: Boolean);
    function GetClearLeft(Index: Integer): Boolean;
    function GetClearRight(Index: Integer): Boolean;
    procedure SetClearLeft(Index: Integer; const Value: Boolean);
    procedure SetClearRight(Index: Integer; const Value: Boolean);
    function GetItemCount: Integer;
    { HTML & RTF }
    {$IFNDEF RVDONOTUSEHTML}
    function ShouldSaveTextToHTML(StyleNo: Integer): Boolean;
    function GetHTMLATag(ItemNo: Integer; CSS: TRVRawByteString): String;
    {$ENDIF}
    {$IFNDEF RVDONOTUSERTF}
    function ShouldSaveTextToRTF(StyleNo: Integer): Boolean;
    {$ENDIF}
    { Others }
    procedure AddNLRTag_(const s: TRVRawByteString; StyleNo, ParaNo, Tag: Integer);
    {$IFNDEF RVDONOTUSEUNICODE}
    procedure AddNLATag_(const s: TRVAnsiString; StyleNo, ParaNo, Tag: Integer);
    {$ENDIF}
    function AddTextUniversal(const text: TRVRawByteString;
      StyleNo, FirstParaNo, OtherParaNo: Integer;
      AsSingleParagraph, CheckUnicode: Boolean; Tag: Integer): Boolean;
  protected
    { Protected declarations }
    FAllowNewPara: Boolean;
    FirstCP, LastCP, NotAddedCP: TRVCPInfo;
    function IsWordWrapAllowed: Boolean; virtual;
    function NextCharStr(const str: TRVRawByteString; ItemNo, Index: Integer): Integer;
    function PrevCharStr(const str: TRVRawByteString; ItemNo, Index: Integer): Integer;
    function NextChar(ItemNo: Integer; Index: Integer): Integer;
    function PrevChar(ItemNo: Integer; Index: Integer): Integer;
    procedure CheckItemClass(ItemNo: Integer;
      RequiredClass: TCustomRVItemInfoClass);
    function ShareItems: Boolean; dynamic;
    function CanLoadLayout: Boolean; dynamic;
    function GetURL(id: Integer): String; dynamic; abstract;
    function GetOptions: TRVOptions; virtual;
    procedure SetOptions(const Value: TRVOptions); virtual;
    function GetRVFOptions: TRVFOptions; virtual;
    procedure SetRVFOptions(const Value: TRVFOptions); virtual;
    function GetRTFOptions: TRVRTFOptions; virtual;
    procedure SetRTFOptions(const Value: TRVRTFOptions); virtual;
    function GetRVFWarnings: TRVFWarnings; virtual;
    procedure SetRVFWarnings(const Value: TRVFWarnings); virtual;
    function GetDelimiters: String; dynamic;
    function GetRVFTextStylesReadMode: TRVFReaderStyleMode; virtual;
    function GetRVFParaStylesReadMode: TRVFReaderStyleMode; virtual;
    procedure RVFGetLimits(SaveScope: TRVFSaveScope;
      var StartItem, EndItem, StartOffs, EndOffs: Integer;
      var StartPart, EndPart: TRVMultiDrawItemPart;
      var SelectedItem: TCustomRVItemInfo); dynamic;
    function GetExtraDocuments: TStrings; dynamic;
    function GetRTFProperties:TPersistent  {TRVRTFReaderProperties}; dynamic;
    {$IFNDEF RVDONOTUSERVF}
    procedure DoOnStyleReaderError(Reader: TReader; const Message: string;
      var Handled: Boolean);
    function InsertRVFFromStream_(Stream: TStream; var Index: Integer;
      AParaNo: Integer; AllowReplaceStyles, AppendMode, EditFlag: Boolean;
      var Color: TColor; Background: TRVBackground;
      Layout: TRVLayoutInfo; var NonFirstItemsAdded: Integer;
      var Protect, FullReformat: Boolean; LoadAsSubDoc: Boolean):Boolean;
    procedure DataWriter(Stream: TStream); dynamic;
    procedure DataReader(Stream: TStream);
    procedure ApplyLayoutInfo (Layout: TRVLayoutInfo); 
    {$ENDIF}
    procedure NormalizeParas(StartItemNo: Integer);
    procedure InsertCheckpoint(ItemNo, Tag: Integer; const Name: String;
      RaiseEvent: Boolean);
    procedure UnlinkCheckpoint(cp: TRVCPInfo; DecCPCount: Boolean);
    function FindCPBeforeItem(ItemNo: Integer): TRVCPInfo;
    procedure UpdateCPItemNo;
    procedure InternalFreeItem(item: TCustomRVItemInfo; Clearing: Boolean); virtual;
    function IsDelimiter(const s: TRVRawByteString; Index: Integer;
      ItemOptions: TRVItemOptions; CodePage: TRVCodePage): Boolean;
    procedure Replace0(var s: TRVRawByteString);
    function RV_CanConcateItems(FirstItemNo: Integer; item1, item2: TCustomRVItemInfo;
      IgnorePara, AllowConcateNonText: Boolean): Boolean;
    procedure SimpleConcate(FirstItemNo: Integer; item1, item2: TCustomRVItemInfo);
    procedure MassSimpleConcate(FirstItemNo, LastItemNo: Integer);
    procedure SimpleConcateSubitems(ItemNo: Integer);
    function SupportsPageBreaks: Boolean; dynamic;
    {$IFNDEF RVDONOTUSEHTML}
    procedure SaveHTMLCheckpoint(Stream: TStream; Checkpoint: TRVCPInfo;
      var cpno: Integer; const Prefix: String; FromNewLine: Boolean;
      Options: TRVSaveOptions);
    function GetTextForHTML(const Path: String; ItemNo: Integer; CSSVersion: Boolean;
      SaveOptions: TRVSaveOptions): TRVRawByteString;
    {$IFNDEF RVDONOTUSESEQ}
    procedure SaveHTMLNotes(const Path, ImagesPrefix, CPPrefix: String;
      Stream: TStream; CSSVersion: Boolean; Options: TRVSaveOptions; 
      Color: TColor; var imgSaveNo: Integer; Bullets: TRVList;
      NoteClass: TCustomRVItemInfoClass);
     {$ENDIF}
    {$ENDIF}
    function GetFirstParaItem(ItemNo: Integer): Integer;
    function GetFirstParaSectionItem(ItemNo: Integer): Integer;
    {$IFDEF RVUSELISTORSEQ}
    function FindPreviousItem(ItemNo: Integer;
      ItemClass: TCustomRVItemInfoClass): TCustomRVItemInfo;
    function FindItemLocalLocationFrom(StartItemNo: Integer;
      ItemToFind: TCustomRVItemInfo): Integer;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESEQ}
    function FindPreviousSeq(ItemNo: Integer): TRVSeqItemInfo;
    procedure DestroySeqList; dynamic;
    function FindLastSeqIndex(StartAfterMeIndex: Integer;
      SeqNames: TStringList): Integer;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    procedure DestroyMarkers; dynamic;
    function FindPreviousMarker(ItemNo: Integer): TRVMarkerItemInfo;
    function FindLastMarkerIndex(StartAfterMeIndex: Integer;
      ListStyles: TRVIntegerList): Integer;
    {$ENDIF}
    function GetFlags: TRVFlags; virtual;                   abstract;
    procedure SetFlags(const Value: TRVFlags); virtual;     abstract;
    procedure AddStringFromFile(const s: TRVAnsiString; StyleNo,ParaNo: Integer;
      FromNewLine, AsSingleParagraph: Boolean; var FirstTime, PageBreak: Boolean);
    procedure AfterDeleteStyles(Data: TRVDeleteUnusedStylesData); dynamic;
    function GetMaxLength: Integer; virtual;      
  public
    State: TRVStates;
    FFirstParaListNo, FFirstParaLevel: Integer;
    CPCount: Integer;
    { Constructors - destructors }
    constructor Create;
    destructor Destroy; override;
    { Document/control & styles properties }
    function GetRVData: TCustomRVData; virtual;
    function GetSourceRVData: TCustomRVData; virtual;
    function GetStyleCodePage(StyleNo: Integer): TRVCodePage;
    function GetItemCodePage(ItemNo: Integer): TRVCodePage;
    function GetItemCodePage2(Item: TCustomRVItemInfo): TRVCodePage;
    function GetStyleLocale(StyleNo: Integer): Cardinal;
    function GetDefaultCodePage: TRVCodePage;
    function GetRVStyle: TRVStyle; virtual;
    function GetParentControl: TWinControl; dynamic;
    procedure GetParentInfo(var ParentItemNo: Integer;
      var Location: TRVStoreSubRVData); dynamic;
    function GetChosenRVData: TCustomRVData; dynamic;
    function GetChosenItem: TCustomRVItemInfo; dynamic;
    function GetParentData: TCustomRVData; virtual;
    function GetRootData: TCustomRVData; virtual;
    function GetAbsoluteParentData: TCustomRVData; virtual;
    function GetAbsoluteRootData: TCustomRVData; virtual;
    {$IFNDEF RVDONOTUSESEQ}
    function GetNoteText: String; dynamic;
    {$ENDIF}
    { Palette }
    function GetRVPalette: HPALETTE; virtual;
    function GetRVLogPalette: PLogPalette; virtual;
    function GetDoInPaletteMode: TRVPaletteAction; virtual;
    procedure UpdateItemsPaletteInfo;
    { Item properties }
    function GetItemOptions(ItemNo: Integer): TRVItemOptions;
    function GetItemNo(Item: TCustomRVItemInfo): Integer;
    function GetItem(ItemNo: Integer): TCustomRVItemInfo;
    function SetItemExtraIntProperty(ItemNo: Integer;
      Prop: TRVExtraItemProperty; Value: Integer): Boolean;
    function GetItemExtraIntProperty(ItemNo: Integer;
      Prop: TRVExtraItemProperty; var Value: Integer): Boolean;
    function SetItemExtraStrProperty(ItemNo: Integer;
      Prop: TRVExtraItemStrProperty; const Value: String): Boolean;
    function GetItemExtraStrProperty(ItemNo: Integer;
      Prop: TRVExtraItemStrProperty; var Value: String): Boolean;
    function GetItemTag(ItemNo: Integer): Integer;
    function GetItemVAlign(ItemNo: Integer): TRVVAlign;
    function IsParaStart(ItemNo: Integer): Boolean;
    function GetItemPara(ItemNo: Integer): Integer;
    function IsFromNewLine(ItemNo: Integer): Boolean;
    function GetOffsAfterItem(ItemNo: Integer): Integer;
    function GetOffsBeforeItem(ItemNo: Integer): Integer;
    function ItemLength(ItemNo: Integer): Integer;
    procedure SetItemTag(ItemNo: Integer; ATag: Integer);
    procedure SetItemVAlign(ItemNo: Integer; AVAlign: TRVVAlign);
    function GetItemStyle(ItemNo: Integer): Integer;
    function GetActualStyle(Item: TCustomRVItemInfo): Integer;
    function GetActualStyle2(StyleNo, ParaNo: Integer): Integer;
    function GetItemTextR(ItemNo: Integer): TRVRawByteString;
    procedure SetItemTextR(ItemNo: Integer; const s: TRVRawByteString);
    procedure SetItemTextA(ItemNo: Integer; const s: TRVAnsiString);
    procedure SetItemText(ItemNo: Integer; const s: String);
    function GetItemTextA(ItemNo: Integer): TRVAnsiString;
    function GetItemText(ItemNo: Integer): String;    
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    function GetTextInItemFormatW(ItemNo: Integer; const s: TRVUnicodeString): TRVRawByteString;
    function GetItemTextW(ItemNo: Integer): TRVUnicodeString;
    procedure SetItemTextW(ItemNo: Integer; const s: TRVUnicodeString);
    {$ENDIF}
    function GetTextInItemFormatA(ItemNo: Integer; const s: TRVAnsiString): TRVRawByteString;
    {$ENDIF}
    function FindControlItemNo(actrl: TControl): Integer;
    function IsHiddenItem(ItemNo: Integer): Boolean;    
    { BiDi }
    function GetItemBiDiMode(ItemNo: Integer): TRVBiDiMode;
    function GetParaBiDiMode(ParaNo: Integer): TRVBiDiMode;
    function GetBiDiMode: TRVBiDiMode; virtual;
    { Operations on items - internal }
    procedure FreeItem(ItemNo: Integer; Clearing: Boolean);
    { Operations on items - public }
    procedure Clear; dynamic;
    procedure DeleteItems(FirstItemNo, Count: Integer); dynamic;
    procedure DeleteSection(const CpName: String);
    procedure MassSimpleConcateAll;
    { Related to events }
    function IsAssignedOnProgress: Boolean; dynamic;
    procedure DoProgress(Operation: TRVLongOperation; Stage: TRVProgressStage;
      PercentDone: Byte); dynamic;
    function GetExtraRTFCode(Area: TRVRTFSaveArea; Obj: TObject;
      Index1, Index2: Integer; InStyleSheet: Boolean): TRVAnsiString; dynamic;
    function GetExtraHTMLCode(Area: TRVHTMLSaveArea;
      CSSVersion: Boolean): String; dynamic;
    function GetParaHTMLCode(RVData: TCustomRVData; ItemNo: Integer;
      ParaStart, CSSVersion: Boolean): String; dynamic;
    function GetParaHTMLCode2(RVData: TCustomRVData; ItemNo: Integer;
      ParaStart, CSSVersion: Boolean; Options: TRVSaveOptions;
      RVStyle: TRVStyle): TRVRawByteString;
    procedure ReadHyperlink(const Target, Extras: String; DocFormat: TRVLoadFormat;
      var StyleNo, ItemTag: Integer; var ItemName: TRVRawByteString); dynamic;
    procedure WriteHyperlink(id: Integer; RVData: TCustomRVData; ItemNo: Integer;
       SaveFormat: TRVSaveFormat; var Target, Extras: String); dynamic;
    function SaveItemToFile(const Path: String; RVData: TCustomRVData;
      ItemNo: Integer; SaveFormat: TRVSaveFormat; Unicode: Boolean;
      var Text: TRVRawByteString): Boolean; virtual;
    function ImportPicture(const Location: String;
      Width, Height: Integer; var Invalid: Boolean): TGraphic; dynamic;
    function GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
      const UpperRVDataHint: String): String; dynamic;
    function DoSavePicture(DocumentSaveFormat: TRVSaveFormat;
      const imgSavePrefix, Path: String; var imgSaveNo: Integer;
      OverrideFiles: Boolean; CurrentFileColor: TColor;
      gr: TGraphic): String; virtual;
    function SavePicture(DocumentSaveFormat: TRVSaveFormat;
      const imgSavePrefix, Path: String; var imgSaveNo: Integer;
      OverrideFiles: Boolean; CurrentFileColor: TColor;
      gr: TGraphic): String;
    function RVFPictureNeeded(const ItemName: String; ItemTag: Integer; PictureInsideRVF: Boolean): TGraphic; dynamic;
    procedure ControlAction(RVData: TCustomRVData; ControlAction: TRVControlAction;
      ItemNo: Integer; Item: TCustomRVItemInfo); dynamic;
    procedure ItemAction(ItemAction: TRVItemAction; Item: TCustomRVItemInfo;
      var Text: TRVRawByteString; RVData: TCustomRVData); virtual;
    {$IFNDEF RVDONOTUSESEQ}
    procedure AfterReadNote(RVData: TCustomRVData; ItemNo: Integer); dynamic;
    {$ENDIF}
    procedure DoBeforeSaving; dynamic;
    procedure ControlAction2(RVData: TCustomRVData; ControlAction: TRVControlAction;
      ItemNo: Integer; var Control:  TControl); dynamic; abstract;
    function RVFControlNeeded(const ItemName: String; ItemTag: Integer): TControl; dynamic;
    function RVFImageListNeeded(ImageListTag: Integer): TCustomImageList; dynamic;
    procedure HTMLSaveImage(RVData: TCustomRVData; ItemNo: Integer;
      const Path: String; BackgroundColor: TColor; var Location: String;
      var DoDefault: Boolean); dynamic;
    procedure SaveImage2(Graphic: TGraphic; SaveFormat: TRVSaveFormat;
      const Path, ImagePrefix: String; var ImageSaveNo: Integer;
      var Location: String; var DoDefault: Boolean); dynamic;
    function SaveComponentToFile(const Path: String; SaveMe: TComponent;
      SaveFormat: TRVSaveFormat): String; virtual;
    { Text save and load }
    {$IFNDEF RVDONOTUSEUNICODE}
    function LoadTextFromStreamW(Stream: TStream; StyleNo, ParaNo: Integer;
      DefAsSingleParagraph: Boolean):Boolean;
    function LoadTextW(const FileName: String; StyleNo, ParaNo: Integer;
      DefAsSingleParagraph: Boolean):Boolean;
    {$ENDIF}
    function SaveTextToStream(const Path: String; Stream: TStream;
      LineWidth: Integer; SelectionOnly, TextOnly, Unicode,
      UnicodeWriteSignature: Boolean):Boolean;
    function SaveText(const FileName: String; LineWidth: Integer;
      Unicode: Boolean):Boolean;
    function LoadText(const FileName: String; StyleNo, ParaNo: Integer;
      AsSingleParagraph: Boolean):Boolean;
    function LoadTextFromStream(Stream: TStream; StyleNo, ParaNo: Integer;
      AsSingleParagraph: Boolean):Boolean;
    { HTML save }
    {$IFNDEF RVDONOTUSEHTML}
    function NextItemFromSpace(ItemNo: Integer): Boolean;    
    function SaveBackgroundToHTML(bmp: TBitmap; Color: TColor;
      const Path, ImagesPrefix: String; var imgSaveNo: Integer;
      SaveOptions: TRVSaveOptions): String;
    function SaveHTMLToStreamEx(Stream: TStream;
      const Path, Title, ImagesPrefix, ExtraStyles, ExternalCSS, CPPrefix: String;
      Options: TRVSaveOptions; Color: TColor; var CurrentFileColor: TColor;
      var imgSaveNo: Integer; LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
      Background: TRVBackground; Bullets: TRVList): Boolean; dynamic;
    function SaveHTMLToStream(Stream: TStream;
      const Path, Title, ImagesPrefix: String;
      Options: TRVSaveOptions; Color: TColor; var imgSaveNo: Integer;
      LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
      Background: TRVBackground; Bullets: TRVList): Boolean; dynamic;
    function SaveHTMLEx(const FileName, Title, ImagesPrefix,
      ExtraStyles, ExternalCSS, CPPrefix: String;
      Options: TRVSaveOptions; Color: TColor; var CurrentFileColor: TColor;
      var imgSaveNo: Integer; LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
      Background: TRVBackground): Boolean;
    function SaveHTML(const FileName, Title, ImagesPrefix: String;
      Options: TRVSaveOptions; Color: TColor; var imgSaveNo: Integer;
      LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
      Background: TRVBackground): Boolean;
    {$ENDIF}
    function GetNextFileName(const ImagesPrefix, Path, Ext: String;
      var imgSaveNo: Integer; OverrideFiles: Boolean): String; dynamic;
    { RVF save and load }
    {$IFNDEF RVDONOTUSERVF}
    procedure DoOnCtrlReaderError(Reader: TReader; const Message: string;
      var Handled: Boolean);    
    function LoadRVFFromStream(Stream: TStream; var Color: TColor;
      Background: TRVBackground; Layout: TRVLayoutInfo):Boolean;
    function InsertRVFFromStream(Stream: TStream; Index: Integer;
      var Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo;
      AllowReplaceStyles: Boolean):Boolean;
    function AppendRVFFromStream(Stream: TStream; ParaNo: Integer;
      var Color: TColor; Background: TRVBackground):Boolean;
    function LoadRVF(const FileName: String;
      var Color: TColor; Background: TRVBackground;
      Layout: TRVLayoutInfo):Boolean;
    //SelectionOnly=True - reserved here
    function SaveRVFToStream(Stream: TStream; SelectionOnly: Boolean;
      Color: TColor; Background: TRVBackground;
      Layout: TRVLayoutInfo; Root: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}):Boolean;
    function SaveRVFToStreamEx(Stream: TStream; SaveScope: TRVFSaveScope;
      Color: TColor; Background: TRVBackground;
      Layout: TRVLayoutInfo; Root: Boolean):Boolean;
    //SelectionOnly=True - reserved here
    function SaveRVF(const FileName: String; SelectionOnly: Boolean;
      Color: TColor; Background: TRVBackground;
      Layout: TRVLayoutInfo; Root: Boolean):Boolean;
    {$ENDIF}
    procedure InitStyleMappings(var PTextStylesMapping, PParaStylesMapping,
      PListStylesMapping: PRVIntegerList; var PUnits: PRVStyleUnits); dynamic;
    procedure DoneStyleMappings(AsSubDoc: Boolean); dynamic;    
    function InsertFirstRVFItem(var Index: Integer; var s: TRVRawByteString;
      var item: TCustomRVItemInfo; EditFlag: Boolean; var FullReformat: Boolean;
      var NewListNo: Integer): Boolean; dynamic;
    function GetRVFSaveScope(SelectionOnly: Boolean):TRVFSaveScope;
    { RTF save and load }
    {$IFNDEF RVDONOTUSERTF}
    {$IFNDEF RVDONOTUSELISTS}
    procedure SaveRTFListTable97(Stream: TStream; ColorList: TRVColorList;
      ListOverrideOffsetsList: TRVIntegerList; FontTable: TRVRTFFontTable;
      tpp: Double; Header, Footer: TCustomRVData);
    {$ENDIF}
    function SaveRTFToStream(Stream: TStream; const Path: String; SelectionOnly: Boolean;
      Level: Integer; Color: TColor; Background: TRVBackground; ColorList: TRVColorList;
      StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
      FontTable: TRVRTFFontTable; tpp: Double; CompleteDocument, HiddenParent: Boolean;
      Header, Footer: TCustomRVData):Boolean; dynamic;
    function SaveRTF(const FileName: String; SelectionOnly: Boolean;
      Color: TColor; Background: TRVBackground):Boolean;
    {$ENDIF}
    {$IFNDEF RVDONOTUSERTFIMPORT}
    function LoadRTFFromStream(Stream: TStream):TRVRTFErrorCode;
    function LoadRTF(const FileName: String):TRVRTFErrorCode;
    {$IFDEF RVUSEWORDDOC}
    function LoadWordDoc(const FileName: String):TRVRTFErrorCode;
    {$ENDIF}
    {$ENDIF}
    procedure MakeRTFTables(ColorList: TRVColorList;
      ListOverrideCountList: TRVIntegerList; TopLevel: Boolean);
    { Adding items - general }
    procedure AddItemR(const Text: TRVRawByteString; Item: TCustomRVItemInfo);
    procedure AddItem(const Text: String; Item: TCustomRVItemInfo);
    //procedure AddItem(const Text: String; Item: TCustomRVItemInfo);
    procedure AddItemAsIsR(const Text: TRVRawByteString; Item: TCustomRVItemInfo);
    { Adding items - text }
    procedure AddFmt(const FormatStr: String; const Args: array of const;
      StyleNo, ParaNo: Integer);
    procedure AddNLR(const s: TRVRawByteString; StyleNo, ParaNo: Integer);
    procedure AddNL(const s: String; StyleNo, ParaNo: Integer);
    procedure AddNLRTag(const s: TRVRawByteString; StyleNo, ParaNo, Tag: Integer);
    procedure AddNLTag(const s: String; StyleNo, ParaNo, Tag: Integer);
    procedure AddTextNLR(const s: TRVRawByteString; StyleNo, FirstParaNo, OtherParaNo: Integer
      {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
    procedure AddTextNL(const s: String; StyleNo, FirstParaNo, OtherParaNo: Integer
      {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
    procedure AddTextNLA(const s: TRVAnsiString; StyleNo, FirstParaNo, OtherParaNo: Integer
      {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
    procedure AddTextBlockNLA(const s: TRVAnsiString; StyleNo, ParaNo: Integer
      {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
    procedure AddNLATag(const s: TRVAnsiString; StyleNo, ParaNo, Tag: Integer);
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    procedure AddNLWTag(const s: TRVUnicodeString; StyleNo, ParaNo, Tag: Integer);
    {$ENDIF}
    procedure AddNLWTagRaw(const s: TRVRawByteString; StyleNo, ParaNo, Tag: Integer);
    procedure AddTextNLWRaw(const s: TRVRawByteString; StyleNo, FirstParaNo,
      OtherParaNo: Integer; DefAsSingleParagraph: Boolean);
    procedure AddTextNLW(const s: TRVUnicodeString; StyleNo, FirstParaNo,
      OtherParaNo: Integer; DefAsSingleParagraph: Boolean);
    {$ENDIF}
    { Adding items - others }
    {$IFNDEF RVDONOTUSETABS}
    procedure AddTab(TextStyleNo, ParaNo: Integer);
    {$ENDIF}
    procedure AddBreakExTag(Width: TRVStyleLength; Style: TRVBreakStyle;
      Color: TColor; Tag: Integer);
    procedure AddBreak;
    procedure AddBreakEx(Width: TRVStyleLength; Style: TRVBreakStyle; Color: TColor);
    procedure AddBreakTag(Tag: Integer);
    procedure AddBulletEx(const Name: TRVAnsiString; ImageIndex: Integer;
      ImageList: TCustomImageList; ParaNo: Integer);
    procedure AddBulletExTag(const Name: TRVAnsiString; ImageIndex: Integer;
      ImageList: TCustomImageList; ParaNo, Tag: Integer);
    procedure AddHotspotEx(const Name: TRVAnsiString; ImageIndex,
      HotImageIndex: Integer; ImageList: TCustomImageList; ParaNo: Integer);
    procedure AddHotspotExTag(const Name: TRVAnsiString; ImageIndex,
      HotImageIndex: Integer; ImageList: TCustomImageList; ParaNo, Tag: Integer);
    procedure AddPictureExTag(const Name: TRVAnsiString; gr: TGraphic; ParaNo: Integer;
      VAlign: TRVVAlign; Tag: Integer);
    procedure AddControlExTag(const Name: TRVAnsiString; ctrl: TControl;
      ParaNo: Integer; VAlign: TRVVAlign; Tag: Integer);
    procedure AddPictureEx(const Name: TRVAnsiString; gr: TGraphic; ParaNo: Integer;
      VAlign: TRVVAlign);
    procedure AddControlEx(const Name: TRVAnsiString; ctrl: TControl;
      ParaNo: Integer; VAlign: TRVVAlign);
    procedure AddHotPicture(const Name: TRVAnsiString; gr: TGraphic; ParaNo: Integer;
      VAlign: TRVVAlign);
    procedure AddHotPictureTag(const Name: TRVAnsiString; gr: TGraphic; ParaNo: Integer;
      VAlign: TRVVAlign; Tag: Integer);
    { Checkpoints - internal }
    procedure FreeCheckpoint(var cp: TRVCPInfo; AdjustLinks, DecCPCount: Boolean);
    procedure SetCP(Item: TCustomRVItemInfo; var PrevCP, CP: TRVCPInfo);
    procedure UpdateCPPos(cp: TRVCPInfo; ItemNo: Integer);
    { Checkpoints - public }
    function AddNamedCheckpointExTag(const CpName: String; RaiseEvent: Boolean;
      Tag: Integer): Integer;
    procedure SetCheckpointInfo(ItemNo: Integer; ATag: Integer; const AName: String;
      ARaiseEvent: Boolean);
    function RemoveCheckpoint(ItemNo: Integer): Boolean;
    function GetFirstCheckpoint: TCheckpointData;
    function GetNextCheckpoint(CheckpointData: TCheckpointData): TCheckpointData;
    function GetLastCheckpoint: TCheckpointData;
    function GetPrevCheckpoint(CheckpointData: TCheckpointData): TCheckpointData;
    function GetItemCheckpoint(ItemNo: Integer):TCheckpointData;
    function FindCheckpointByName(const Name: String): TCheckpointData;
    function FindCheckpointByTag(Tag: Integer): TCheckpointData;
    function GetCheckpointByNo(No: Integer): TCheckpointData;
    function GetCheckpointItemNo(CheckpointData: TCheckpointData): Integer;
    function GetCheckpointNo(CheckpointData: TCheckpointData): Integer;
    procedure GetCheckpointInfo(CheckpointData: TCheckpointData;
      var Tag: Integer; var Name: String; var RaiseEvent: Boolean);
    { Get info for specific item types }
    procedure GetBreakInfo(ItemNo: Integer; var AWidth: TRVStyleLength;
      var AStyle: TRVBreakStyle; var AColor: TColor; var ATag: Integer);
    procedure GetBulletInfo(ItemNo: Integer; var AName: TRVAnsiString;
      var AImageIndex: Integer; var AImageList: TCustomImageList;
      var ATag: Integer);
    procedure GetHotspotInfo(ItemNo: Integer; var AName: TRVAnsiString;
      var AImageIndex, AHotImageIndex: Integer; var AImageList: TCustomImageList;
      var ATag: Integer);
    procedure GetPictureInfo(ItemNo: Integer; var AName: TRVAnsiString;
      var Agr: TGraphic; var AVAlign: TRVVAlign; var ATag: Integer);
    procedure GetControlInfo(ItemNo: Integer; var AName: TRVAnsiString;
      var Actrl: TControl; var AVAlign: TRVVAlign; var ATag: Integer);
    procedure GetTextInfo(ItemNo: Integer; var AText: String;
      var ATag: Integer);
    { Set info for specific item types }
    procedure SetGrouped(ItemNo: Integer; Grouped: Boolean);
    procedure SetBreakInfo(ItemNo: Integer; AWidth: TRVStyleLength; AStyle: TRVBreakStyle;
      AColor: TColor; ATag: Integer);
    procedure SetBulletInfo(ItemNo: Integer; const AName: TRVAnsiString;
      AImageIndex: Integer; AImageList: TCustomImageList; ATag: Integer);
    procedure SetHotspotInfo(ItemNo: Integer; const AName: TRVAnsiString;
      AImageIndex, AHotImageIndex: Integer; AImageList: TCustomImageList;
      ATag: Integer);
    function SetPictureInfo(ItemNo: Integer; const  AName: TRVAnsiString;
      Agr: TGraphic; AVAlign: TRVVAlign; ATag: Integer): Boolean;
    function SetControlInfo(ItemNo: Integer; const AName: TRVAnsiString;
      AVAlign: TRVVAlign; ATag: Integer): Boolean;
    { Styles }
    procedure DoMarkStylesInUse(Data: TRVDeleteUnusedStylesData);
    procedure DoUpdateStyles(Data: TRVDeleteUnusedStylesData);
    procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); dynamic;
    procedure DeleteMarkedStyles(Data: TRVDeleteUnusedStylesData);
    procedure DeleteUnusedStyles(TextStyles, ParaStyles, ListStyles: Boolean);
    procedure AfterAddStyle(StyleInfo: TCustomRVInfo); dynamic;
    { Numbered sequences }
    {$IFNDEF RVDONOTUSESEQ}
    function GetSeqList(AllowCreate: Boolean): TRVSeqList; dynamic;
    procedure AddSeqInList(ItemNo: Integer);
    procedure DeleteSeqFromList(Item: TCustomRVItemInfo; Clearing: Boolean);
    {$ENDIF}
    { Paragraph list markers}
    {$IFNDEF RVDONOTUSELISTS}
    function GetMarkers(AllowCreate: Boolean): TRVMarkerList; dynamic;
    function GetPrevMarkers: TRVMarkerList; dynamic;
    function SetListMarkerInfo(AItemNo, AListNo, AListLevel, AStartFrom,
      AParaNo: Integer; AUseStartFrom: Boolean): Integer;
    procedure RecalcMarker(AItemNo: Integer; AllowCreateList: Boolean);
    procedure RemoveListMarker(ItemNo: Integer);
    function GetListMarkerInfo(AItemNo: Integer; var AListNo, AListLevel,
      AStartFrom: Integer; var AUseStartFrom: Boolean): Integer;
    procedure AddMarkerInList(ItemNo: Integer);
    procedure DeleteMarkerFromList(Item: TCustomRVItemInfo; Clearing: Boolean);
    {$ENDIF}
    { Others }
    function IsDelimiterA(ch: TRVAnsiChar; CodePage: TRVCodePage): Boolean;
    function IsDelimiterW(ch: TRVUnicodeChar): Boolean;
    function EnumItems(Proc: TRVEnumItemsProc; var UserData1: Integer;
      const UserData2: String): Boolean;
    procedure ShareItemsFrom(Source: TCustomRVData);
    procedure AssignItemsFrom(Source: TCustomRVData);
    procedure DrainFrom(Victim: TCustomRVData);
    procedure SetParagraphStyleToAll(ParaNo: Integer);
    procedure SetAddParagraphMode(AllowNewPara: Boolean);
    procedure AppendFrom(Source: TCustomRVData);
    procedure Inserting(RVData: TCustomRVData; Safe: Boolean);
    function Edit: TCustomRVData; dynamic;
    procedure Beep;
    procedure ExpandToParaSection(ItemNo1,ItemNo2: Integer;
      var FirstItemNo, LastItemNo: Integer);
    procedure ExpandToPara(ItemNo1,ItemNo2: Integer;
      var FirstItemNo, LastItemNo: Integer);
    function ReplaceTabs(const s: TRVRawByteString; StyleNo: Integer;
      UnicodeDef: Boolean): TRVRawByteString;
    procedure AdjustInItemsRange(var ItemNo: Integer);
    function GetColor: TColor; virtual;
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    function GetDocParameters(AllowCreate: Boolean): TRVDocParameters; dynamic;
    {$ENDIF}
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
      RVStyle: TRVStyle; ConvertItems: Boolean); dynamic;
    { Properties }
    function GetDocProperties: TStringList; dynamic;
    property Flags: TRVFlags read GetFlags write SetFlags;
    property Items: TRVItemList read FItems;
    property ItemCount: Integer read GetItemCount;
    property Options: TRVOptions read GetOptions write SetOptions;
    property RVFOptions: TRVFOptions read GetRVFOptions write SetRVFOptions;
    property RTFOptions: TRVRTFOptions read GetRTFOptions write SetRTFOptions;
    property RVFWarnings: TRVFWarnings read GetRVFWarnings write SetRVFWarnings;
    property FirstJumpNo: Integer read FFirstJumpNo write FFirstJumpNo;
    property PageBreaksBeforeItems[Index: Integer]: Boolean
      read GetPageBreaksBeforeItems write SetPageBreaksBeforeItems;
    property ClearLeft[Index: Integer]: Boolean
      read GetClearLeft write SetClearLeft;
    property ClearRight[Index: Integer]: Boolean
      read GetClearRight write SetClearRight;
  end;


  procedure RVCheckUni(Length: Integer);
  function RVCompareLocations(RVData1: TCustomRVData; ItemNo1: Integer;
    RVData2: TCustomRVData; ItemNo2: Integer): Integer;

{$IFNDEF RVDONOTUSERTF}
procedure RVSaveFontToRTF(Stream: TStream; Font: TFont;
  ColorList: TRVColorList; FontTable: TRVRTFFontTable;
  RVStyle: TRVStyle);
{$ENDIF}

const
  RichViewSavePInHTML:     Boolean = False;
  RichViewSaveDivInHTMLEx: Boolean = False;
  RichViewSavePageBreaksInText: Boolean = False;
  RichViewDoNotCheckRVFStyleRefs: Boolean = False;
  RichViewAllowCopyTableCells: Boolean = True;

  cssBKAttStrFixed = 'fixed';
  cssBKAttStrScroll = 'scroll';
  cssBKRepStrRepeat = 'repeat';
  cssBKRepStrNoRepeat = 'no-repeat';

  rv_cssBkAttachment : array[TBackgroundStyle] of PRVAnsiChar
      = ('', cssBKAttStrFixed, cssBKAttStrFixed, cssBKAttStrScroll, cssBKAttStrFixed,
        cssBKAttStrFixed, cssBKAttStrFixed, cssBKAttStrFixed, cssBKAttStrFixed);
  rv_cssBkRepeat     : array[TBackgroundStyle] of PRVAnsiChar =
        ('', cssBKRepStrNoRepeat, cssBKRepStrRepeat, cssBKRepStrRepeat,
        cssBKRepStrNoRepeat, cssBKRepStrNoRepeat, cssBKRepStrNoRepeat,
        cssBKRepStrNoRepeat, cssBKRepStrNoRepeat);

procedure RV_RegisterHTMLGraphicFormat(ClassType: TGraphicClass);
procedure RV_RegisterPngGraphic(ClassType: TGraphicClass);
function RV_IsHTMLGraphicFormat(gr: TGraphic): Boolean;
function StringToHTMLString(const s: String; Options: TRVSaveOptions;
  RVStyle: TRVStyle): TRVRawByteString;
function StringToHTMLString2(const s: String; Options: TRVSaveOptions;
  CodePage: TRVCodePage): TRVRawByteString;
function StringToHTMLString3(const s: String; UTF8: Boolean;
  CodePage: TRVCodePage): TRVRawByteString;

var RVPngGraphiClass: TGraphicClass;

implementation
uses RVFMisc, RVStr,
  {$IFNDEF RVDONOTUSESEQ}
  RVNote,
  {$ENDIF}
  {$IFNDEF RVDONOTUSETABLES}
  RVTable,
  {$ENDIF}
  RVRTFProps;

const RVF_DOCPROP_TEXTSTYLES  = 1;
      RVF_DOCPROP_PARASTYLES  = 2;
      RVF_DOCPROP_LISTSTYLES  = 4;
      RVF_DOCPROP_LAYOUT      = 3;
      RVF_DOCPROP_DOCPROPLIST = 5;
      RVF_DOCPROP_PREVMARKERS = 6;
      RVF_DOCPROP_DOCPARAMETERS = 7;
      RVF_DOCPROP_EXTRADOCUMENT = 8;
      RVF_DOCPROP_UNITS       = 9;

const RVFVersion = 1;
      RVFSubVersion = 3;
      RVFSubSubVersion: TRVAnsiString =
      {$IFDEF RVUNICODESTR}
        ' 1';
      {$ELSE}
        '';
      {$ENDIF}

const
  crlf = #13#10;
{==============================================================================}
{ Raises an exception - error in processing Unicode text.                      }
procedure RVRaiseUni;
begin
  raise ERichViewError.Create(errRVUnicode);
end;
{------------------------------------------------------------------------------}
{ Raises an exception is Length is odd value. It's used to check lengths of
  "raw Unicode" string.                                                        }
procedure RVCheckUni(Length: Integer);
begin
  if Length mod 2 <> 0 then
    RVRaiseUni;
end;
{========================== HTML Graphic Classes ==============================}
{ List of HTML graphic classes.
  Pictures of HTML graphic classes will be saved in HTML without
  converting to Jpegs.
  Initialization: nilled.
  Finalization: freed and nilled.                                              }
var HTMLGraphicFormats: TList;
{------------------------------------------------------------------------------}
{ Registers the graphic class ClassType as an HTML graphic class.              }
procedure RV_RegisterHTMLGraphicFormat(ClassType: TGraphicClass);
begin
  if HTMLGraphicFormats=nil then
    HTMLGraphicFormats := TList.Create;
  if HTMLGraphicFormats.IndexOf(ClassType)<0 then
    HTMLGraphicFormats.Add(ClassType);
end;
{------------------------------------------------------------------------------}
{ Is this a picture of HTML graphic class?                                     }
function RV_IsHTMLGraphicFormat(gr: TGraphic): Boolean;
begin
  Result := (HTMLGraphicFormats<>nil) and
    (HTMLGraphicFormats.IndexOf(gr.ClassType)>=0)
end;
{================================ Png =========================================}
procedure RV_RegisterPngGraphic(ClassType: TGraphicClass);
begin
  RVPngGraphiClass := ClassType;
end;
{================================= HTML =======================================}
{ Converts s to ANSI or UTF-8, depending on Options.
  The conversion uses RVStyle.DefCodePage }
function StringToHTMLString(const s: String; Options: TRVSaveOptions;
  RVStyle: TRVStyle): TRVRawByteString;
begin
  if rvsoUTF8 in Options then
    {$IFDEF RVUNICODESTR}
    Result := Utf8Encode(s)
    {$ELSE}
    Result := RVU_AnsiToUTF8(RVStyle.DefCodePage, s)
    {$ENDIF}
  else
    {$IFDEF RVUNICODESTR}
    Result := RVU_UnicodeToAnsi(RVStyle.DefCodePage, RVU_GetRawUnicode(s));
    {$ELSE}
    Result := s;
    {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Converts s to ANSI or UTF-8, depending on Options.
  The conversion uses CodePage }
function StringToHTMLString2(const s: String; Options: TRVSaveOptions;
  CodePage: TRVCodePage): TRVRawByteString;
begin
  if rvsoUTF8 in Options then
    {$IFDEF RVUNICODESTR}
    Result := Utf8Encode(s)
    {$ELSE}
    Result := RVU_AnsiToUTF8(CodePage, s)
    {$ENDIF}
  else
    {$IFDEF RVUNICODESTR}
    Result := RVU_UnicodeToAnsi(CodePage, RVU_GetRawUnicode(s));
    {$ELSE}
    Result := s;
    {$ENDIF}
end;
{ The same, but boolean instead of Options }
function StringToHTMLString3(const s: String; UTF8: Boolean;
  CodePage: TRVCodePage): TRVRawByteString;
begin
  if UTF8 then
    {$IFDEF RVUNICODESTR}
    Result := Utf8Encode(s)
    {$ELSE}
    Result := RVU_AnsiToUTF8(CodePage, s)
    {$ENDIF}
  else
    {$IFDEF RVUNICODESTR}
    Result := RVU_UnicodeToAnsi(CodePage, RVU_GetRawUnicode(s));
    {$ELSE}
    Result := s;
    {$ENDIF}
end;
{================================ TRTFFontTable ===============================}
{ Returns an index of (FontName, Charset) item, or -1 if not found.
  Charset is not supported in D2/CB1 version.
  FontName is case insensitive.                                                }
function TRVRTFFontTable.Find(const FontName: String
  {$IFDEF RICHVIEWCBDEF3}; Charset: TFontCharset{$ENDIF}): Integer;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if (AnsiCompareText(Items[i].FontName,FontName)=0)
       {$IFDEF RICHVIEWCBDEF3}
       and (Items[i].Charset = Charset)
       {$ENDIF}
       then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ Adds (FontName, Charset) item if it does not present.
  In any case, returns an index of (FontName, Charset) item.
  Charset is not supported in D2/CB1 version.
  FontName is case insensitive.                                                }  
function TRVRTFFontTable.AddUnique(const FontName: String
 {$IFDEF RICHVIEWCBDEF3}; Charset: TFontCharset{$ENDIF}): Integer;
var item: TRVRTFFontTableItem;
begin
  Result := Find(FontName{$IFDEF RICHVIEWCBDEF3}, Charset{$ENDIF});
  if Result<0 then begin
    item := TRVRTFFontTableItem.Create;
    item.FontName := FontName;
    {$IFDEF RICHVIEWCBDEF3}
    item.Charset := Charset;
    {$ENDIF}
    Add(item);
    Result := Count-1;
  end;
end;
{------------------------------------------------------------------------------}
{ Reads Items[Index]                                                            }
function TRVRTFFontTable.Get(Index: Integer): TRVRTFFontTableItem;
begin
  Result := TRVRTFFontTableItem(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
{ Writes Items[Index]                                                          }
procedure TRVRTFFontTable.Put(Index: Integer; const Value: TRVRTFFontTableItem);
begin
  inherited Put(Index, Value);
end;
{============================ TRVLayoutInfo ===================================}
{ Constructor.                                                                 }
constructor TRVLayoutInfo.Create;
begin
  inherited Create;
  FirstMarkerListNo := -1;
end;
{------------------------------------------------------------------------------}
{ Loads iteslf from the Stream.
  If IncludeSize=True, first reads size (4 bytes) of the rest of data; reports
  error if the size is too small; reads at least size bytes (for compatibility
  with possible future extensions).                                            }
procedure TRVLayoutInfo.LoadFromStream(Stream: TStream; IncludeSize: Boolean);
var v, version: Integer;
const defsize1 = sizeof(Integer)*(4+2)+sizeof(TRVBiDiMode);
begin
   if IncludeSize then
     Stream.ReadBuffer(v, sizeof(Integer)); // ignoring
   Stream.ReadBuffer(version,      sizeof(Integer));
   Stream.ReadBuffer(v,            sizeof(Integer));
   if (version=0) and (v<defsize1) then
     raise ERichViewError.Create(errRVFDocProp);
   if version=0 then begin
     Stream.ReadBuffer(LeftMargin,   sizeof(Integer));
     Stream.ReadBuffer(RightMargin,  sizeof(Integer));
     Stream.ReadBuffer(TopMargin,    sizeof(Integer));
     Stream.ReadBuffer(BottomMargin, sizeof(Integer));
     Stream.ReadBuffer(MinTextWidth, sizeof(Integer));
     Stream.ReadBuffer(MaxTextWidth, sizeof(Integer));
     Stream.ReadBuffer(BiDiMode,     sizeof(TRVBiDiMode));
     dec(v, defsize1);
   end;
   if v>=sizeof(Integer)*4 then begin
     Stream.ReadBuffer(FirstParaAborted, sizeof(Integer));
     Stream.ReadBuffer(LastParaAborted, sizeof(Integer));
     Stream.ReadBuffer(FirstMarkerListNo, sizeof(Integer));
     Stream.ReadBuffer(FirstMarkerLevel, sizeof(Integer));
     dec(v, sizeof(Integer)*4);
   end;
   if v>0 then
     Stream.Seek(v,soFromCurrent);
   Loaded := True;
end;
{------------------------------------------------------------------------------}
{ Saves itself to the stream.
  If IncluseSize=True, first saves its size (4 bytes).
  Size is usually processed by RVF loading procedures.                         }
procedure TRVLayoutInfo.SaveToStream(Stream: TStream;
  IncludeSize, OnlyPageInfo: Boolean);
var v,size,version: Integer;
const defsize1 = sizeof(Integer)*(4+2)+sizeof(TRVBiDiMode);
begin
   if OnlyPageInfo then begin
     size := 0;
     version := 1;
     end
   else begin
     size := defsize1;
     version := 0;
   end;
   if (FirstParaAborted<>0) or (LastParaAborted<>0) then
     inc(size, sizeof(Integer)*4);
   if IncludeSize then begin
     v := size+sizeof(Integer)*2;
     Stream.WriteBuffer(v, sizeof(Integer));
   end;
   Stream.WriteBuffer(version,      sizeof(Integer));
   v := size;
   Stream.WriteBuffer(v,            sizeof(Integer));
   if not OnlyPageInfo then begin
     Stream.WriteBuffer(LeftMargin,   sizeof(Integer));
     Stream.WriteBuffer(RightMargin,  sizeof(Integer));
     Stream.WriteBuffer(TopMargin,    sizeof(Integer));
     Stream.WriteBuffer(BottomMargin, sizeof(Integer));
     Stream.WriteBuffer(MinTextWidth, sizeof(Integer));
     Stream.WriteBuffer(MaxTextWidth, sizeof(Integer));
     Stream.WriteBuffer(BiDiMode,     sizeof(TRVBiDiMode));
   end;
   if (FirstParaAborted<>0) or (LastParaAborted<>0) then begin
     Stream.WriteBuffer(FirstParaAborted, sizeof(Integer));
     Stream.WriteBuffer(LastParaAborted, sizeof(Integer));
     Stream.WriteBuffer(FirstMarkerListNo, sizeof(Integer));
     Stream.WriteBuffer(FirstMarkerLevel, sizeof(Integer));
   end;
end;
{------------------------------------------------------------------------------}
{ Loads itself from the hexadecimal string: extracts the string to a temporal
  memory stream, and calls LoadFromStream(..., False).                         }
procedure TRVLayoutInfo.LoadText(const s: TRVAnsiString);
var TmpStream: TRVMemoryStream;
begin
   TmpStream := TRVMemoryStream.Create;
   try
     RVFTextString2Stream(s, TmpStream);
     TmpStream.Position := 0;
     LoadFromStream(TmpStream, False);
   finally
     TmpStream.Free;
   end;
end;
{------------------------------------------------------------------------------}
{ Loads itself from the binary string: copies the string to a temporal memory
  stream, and calls LoadFromStream(..., False).                                }
procedure TRVLayoutInfo.LoadBinary(const s: TRVRawByteString);
var TmpStream: TMemoryStream;
begin
   TmpStream := TMemoryStream.Create;
   try
     TmpStream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
     TmpStream.Position := 0;
     LoadFromStream(TmpStream, False);
   finally
     TmpStream.Free;
   end;
end;
{------------------------------------------------------------------------------}
{ Saves itself to stream as a hexadecimal string that can be loaded by
  LoadText.                                                                    }
procedure TRVLayoutInfo.SaveTextToStream(Stream: TStream; OnlyPageInfo: Boolean);
var TmpStream: TRVMemoryStream;
    s: TRVAnsiString;
begin
   TmpStream := TRVMemoryStream.Create;
   try
     SaveToStream(TmpStream, False, OnlyPageInfo);
     TmpStream.Position := 0;
     s := RVFStream2TextString(TmpStream);
     RVFWriteLine(Stream, s);
   finally
     TmpStream.Free;
   end;
end;
{$I+}
{================================ TCustomRVData ===============================}
constructor TCustomRVData.Create;
begin
  inherited Create;
  if not ShareItems then
    FItems := TRVItemList.Create;
  FAllowNewPara  := True;
  CPCount        := 0;
  State          := [];
end;
{------------------------------------------------------------------------------}
destructor TCustomRVData.Destroy;
begin
  Clear;
  if not ShareItems then
    FItems.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SavePicture(DocumentSaveFormat: TRVSaveFormat;
  const imgSavePrefix, Path: String; var imgSaveNo: Integer;
  OverrideFiles: Boolean; CurrentFileColor: TColor;
  gr: TGraphic): String;
var fn: String;
    bmp: TBitmap;
    ext: String;
    {$IFNDEF RVDONOTUSEJPEGIMAGE}
    jpg: TJpegImage;
    {$ENDIF}
begin
   {$IFNDEF RVDONOTUSEJPEGIMAGE}
   if DocumentSaveFormat=rvsfHTML then begin
     ext := '.jpg';
     if RV_IsHTMLGraphicFormat(gr) then
       ext := '.'+GraphicExtension(TGraphicClass(gr.ClassType));
     end
   else
     ext := '.bmp';
   {$ELSE}
   ext := '.bmp';
   {$ENDIF}
   fn := GetNextFileName(imgSavePrefix, Path, Ext, imgSaveNo, OverrideFiles);
   Result := ExtractFilePath(imgSavePrefix);
   if (Length(Result)>0) and (Result[Length(Result)]<>'\') then
     Result := Result+'\';
   Result := Result+ExtractFileName(fn);
   {$IFNDEF RVDONOTUSEJPEGIMAGE}
   if (DocumentSaveFormat=rvsfHTML) and
      ((gr is TJpegImage) or RV_IsHTMLGraphicFormat(gr)) then begin
     gr.SaveToFile(fn);
     exit;
   end;
   {$ENDIF}
   bmp := TBitmap.Create;
   try
     if gr is TBitmap then
       bmp.Assign(gr)
     else begin
       {$IFDEF RICHVIEWCBDEF3}
       bmp.PixelFormat := pf32bit;
       {$ENDIF}
       bmp.Height := gr.Height;
       bmp.Width := gr.Width;
       if CurrentFileColor=clNone then
         CurrentFileColor := clWhite;
       bmp.Canvas.Brush.Color := CurrentFileColor;
       bmp.Canvas.Pen.Color := CurrentFileColor;
       GetRVStyle.GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,gr.Width,gr.Height));
       GetRVStyle.GraphicInterface.DrawGraphic(bmp.Canvas, 0, 0, gr);
     end;
     {$IFNDEF RVDONOTUSEJPEGIMAGE}
     if DocumentSaveFormat=rvsfHTML then begin
       jpg := TJpegImage.Create;
       try
         jpg.Assign(bmp);
         jpg.SaveToFile(fn);
       finally
         jpg.Free;
       end;
       end
     else
       bmp.SaveToFile(fn);
     {$ELSE}
       bmp.SaveToFile(fn);
     {$ENDIF}
   finally
     bmp.Free;
   end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.DoSavePicture(DocumentSaveFormat: TRVSaveFormat;
  const imgSavePrefix, Path: String; var imgSaveNo: Integer;
  OverrideFiles: Boolean; CurrentFileColor: TColor;
  gr: TGraphic): String;
var DoDefault: Boolean;
begin
   Result := '';
   SaveImage2(gr, DocumentSaveFormat, Path, imgSavePrefix, imgSaveNo, Result,
     DoDefault);
   if not DoDefault then
     exit;
  Result := SavePicture(DocumentSaveFormat, imgSavePrefix, Path, imgSaveNo,
    OverrideFiles, CurrentFileColor, gr);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.ItemLength(ItemNo: Integer): Integer;
begin
  with GetItem(ItemNo) do
    if StyleNo<0 then
      Result := 1
    else
      Result := RVU_Length(Items[ItemNo], ItemOptions);
end;
{------------------------------------------------------------------------------}
{ Returns the file name in the directory Path. File name is built as
  ImagesPrefix + <number> + Ext.
  If OverrideFiles=True, <number> is imgSaveNo+1.
  If not, <number> is increased until file name does not belong to an existing
  file.
  On exit, imgSaveNo = <number>.
  Notes:
  - ImagesPrefix can contain path. It may be the full path (contains ':')
    or relative path. In the last case the file is assumed to be in
    Path + ExtractFilePath(ImagesPrefix).
  - It's assumed that the directory exists. }
function TCustomRVData.GetNextFileName(const ImagesPrefix, Path, Ext: String;
  var imgSaveNo: Integer; OverrideFiles: Boolean): String;
var FullPath: String;
begin
  if {$IFDEF RICHVIEWCBDEF3}AnsiPos{$ELSE}Pos{$ENDIF}(':',ImagesPrefix)>0 then
    FullPath := ImagesPrefix
  else
    FullPath := Path+ImagesPrefix;
  while True do begin
    inc(imgSaveNo);
    Result := FullPath+IntToStr(imgSaveNo)+Ext;
    if not FileExists(Result) then
      exit;
    {$WARNINGS OFF}
    if OverrideFiles and ((FileGetAttr(Result) and faReadOnly)=0) then
      exit;
    {$WARNINGS ON}
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddItemR(const Text: TRVRawByteString; Item: TCustomRVItemInfo);
var s: TRVRawByteString;
    OldCP: TRVCPInfo;
begin
  if (Item.ParaNo=-1) and (Items.Count<>0) and
     not GetItem(Items.Count-1).GetBoolValue(rvbpFullWidth) then begin
    Item.SameAsPrev := True;
    Item.ParaNo := GetItemPara(Items.Count-1);
    end
  else begin
    {$IFNDEF RVDONOTUSELISTS}
    if (Items.Count<>0) and (GetItemStyle(Items.Count-1)=rvsListMarker) then
      AddNLR('',0,-1);
    {$ENDIF}
    Item.SameAsPrev := False;
    Item.BR := (Item.BR  or not FAllowNewPara) and not Item.GetBoolValue(rvbpFullWidth) and
      (Items.Count<>0);
    if Item.ParaNo=-1 then
      Item.ParaNo := 0;
  end;
  if Item.Checkpoint<>nil then begin
    OldCP := Item.Checkpoint;
    with Item.Checkpoint do
      AddNamedCheckpointExTag(Name, RaiseEvent, Tag);
    OldCP.Free;
  end;
  SetCP(Item, LastCP, NotAddedCP);
  Item.UpdatePaletteInfo(GetDoInPaletteMode, False, GetRVPalette, GetRVLogPalette);
  s := Text;
  Item.Inserting(Self, s, False);
  Items.AddObject(s, Item);
  Item.Inserted(Self, Items.Count-1);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddItem(const Text: String; Item: TCustomRVItemInfo);
begin
  AddItemR(
    RVU_StringToRawByteString(Text, rvioUnicode in Item.ItemOptions,
      GetItemCodePage2(Item)),
    Item);
  {$IFNDEF RVDONOTUSESEQ}
  AddSeqInList(ItemCount-1);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddItemAsIsR(const Text: TRVRawByteString; Item: TCustomRVItemInfo);
var s: TRVRawByteString;
begin
  if Item.Checkpoint<>nil then
    with Item.Checkpoint do
      AddNamedCheckpointExTag(Name, RaiseEvent, Tag);
  SetCP(Item, LastCP, NotAddedCP);
  Item.UpdatePaletteInfo(GetDoInPaletteMode, False, GetRVPalette, GetRVLogPalette);
  s := Text;
  Item.Inserting(Self, s, False);
  Items.AddObject(s, Item);
  Item.Inserted(Self, Items.Count-1);
end;
{------------------------------------------------------------------------------}
{ Does not replace tabs }
procedure TCustomRVData.AddNLRTag_(const s: TRVRawByteString; StyleNo, ParaNo, Tag: Integer);
var Item: TCustomRVItemInfo;
begin
  Item := RichViewTextItemClass.Create(Self);
  if StyleNo<0 then
    Item.StyleNo := rvsDefStyle
  else
    Item.StyleNo := StyleNo;
  Item.ParaNo  := ParaNo;
  Item.Tag     := Tag;
  {$IFNDEF RVDONOTUSEUNICODE}
  if (GetRVStyle<>nil) and (GetRVStyle.TextStyles[GetActualStyle(Item)].Unicode) then
    Include(Item.ItemOptions, rvioUnicode);
  {$ENDIF}
  AddItemR(s, Item);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
procedure TCustomRVData.AddNLATag_(const s: TRVAnsiString; StyleNo, ParaNo, Tag: Integer);
var ress: TRVRawByteString;
    LParaNo: Integer;
begin
  LParaNo := ParaNo;
  if (StyleNo<0) or (StyleNo=rvsDefStyle) then begin
    StyleNo := rvsDefStyle;
    if LParaNo=-1 then begin
     if Items.Count<>0 then
       LParaNo := GetItemPara(Items.Count-1)
     else
       LParaNo := 0;
    end;
  end;
  if (GetRVStyle<>nil) and
     (GetRVStyle.TextStyles[GetActualStyle2(StyleNo, LParaNo)].Unicode) then
    ress := RVU_AnsiToUnicode(GetStyleCodePage(GetActualStyle2(StyleNo, LParaNo)), s)
  else
    ress := s;
  AddNLRTag_(ress, StyleNo, ParaNo, Tag);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLRTag(const s: TRVRawByteString;
  StyleNo, ParaNo, Tag: Integer);
var Item: TCustomRVItemInfo;
begin
  Item := RichViewTextItemClass.Create(Self);
  if StyleNo<0 then
    Item.StyleNo := rvsDefStyle
  else
    Item.StyleNo := StyleNo;
  Item.ParaNo  := ParaNo;
  Item.Tag     := Tag;
  {$IFNDEF RVDONOTUSEUNICODE}
  if (GetRVStyle<>nil) and (GetRVStyle.TextStyles[GetActualStyle(Item)].Unicode) then
    Include(Item.ItemOptions, rvioUnicode);
  {$ENDIF}
  AddItemR(ReplaceTabs(s, GetActualStyle(Item), False), Item);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLTag(const s: String; StyleNo, ParaNo, Tag: Integer);
begin
  {$IFDEF RVUNICODESTR}
  AddNLWTag(s, StyleNo, ParaNo, Tag);
  {$ELSE}
  AddNLATag(s, StyleNo, ParaNo, Tag);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
function TCustomRVData.GetTextInItemFormatA(ItemNo: Integer;
  const s: TRVAnsiString): TRVRawByteString;
begin
  if (GetItemStyle(ItemNo)>=0) and (rvioUnicode in GetItemOptions(ItemNo)) then
    Result := RVU_AnsiToUnicode(GetItemCodePage(ItemNo), s)
  else
    Result := s;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLWTagRaw(const s: TRVRawByteString;
  StyleNo, ParaNo, Tag: Integer);
var ansis: TRVRawByteString;
begin
  ansis := s;
  if StyleNo<0 then
    StyleNo := rvsDefStyle;
  if (GetRVStyle<>nil) and
     not GetRVStyle.TextStyles[GetActualStyle2(StyleNo, ParaNo)].Unicode then
    ansis := RVU_UnicodeToAnsi(GetStyleCodePage(GetActualStyle2(StyleNo, ParaNo)), ansis);
  AddNLRTag(ansis, StyleNo, ParaNo, Tag);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
function TCustomRVData.GetTextInItemFormatW(ItemNo: Integer;
  const s: TRVUnicodeString): TRVRawByteString;
begin
  Result := RVU_GetRawUnicode(s);
  if (GetItemStyle(ItemNo)<0) or not (rvioUnicode in GetItemOptions(ItemNo)) then
    Result := RVU_UnicodeToAnsi(GetItemCodePage(ItemNo), Result);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLWTag(const s: TRVUnicodeString;
  StyleNo, ParaNo, Tag: Integer);
begin
  AddNLWTagRaw(RVU_GetRawUnicode(s), StyleNo, ParaNo, Tag);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemTextW(ItemNo: Integer): TRVUnicodeString;
var s: TRVRawByteString;
begin
  s := Items[ItemNo];
  if (GetItemStyle(ItemNo)<0) or (not (rvioUnicode in GetItemOptions(ItemNo))) then
    s := RVU_AnsiToUnicode(GetItemCodePage(ItemNo), s);
  Result := RVU_RawUnicodeToWideString(s);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemTextW(ItemNo: Integer; const s: TRVUnicodeString);
begin
  Items[ItemNo] := GetTextInItemFormatW(ItemNo, s);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLATag(const s: TRVAnsiString; StyleNo, ParaNo, Tag: Integer);
var ress: TRVRawByteString;
    LParaNo: Integer;
begin
  LParaNo := ParaNo;
  if (StyleNo<0) or (StyleNo=rvsDefStyle) then begin
    StyleNo := rvsDefStyle;
    if LParaNo=-1 then begin
     if Items.Count<>0 then
       LParaNo := GetItemPara(Items.Count-1)
     else
       LParaNo := 0;
    end;
  end;
  if (GetRVStyle<>nil) and
     (GetRVStyle.TextStyles[GetActualStyle2(StyleNo, LParaNo)].Unicode) then
    ress := RVU_AnsiToUnicode(GetStyleCodePage(GetActualStyle2(StyleNo, LParaNo)), s)
  else
    ress := s;
  AddNLRTag(ress, StyleNo, ParaNo, Tag);
end;
{$ELSE}
procedure TCustomRVData.AddNLATag(const s: TRVAnsiString; StyleNo, ParaNo, Tag: Integer);
begin
  AddNLRTag(s, StyleNo, ParaNo, Tag);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemTextA(ItemNo: Integer; const s: TRVAnsiString);
begin
  Items[ItemNo] :=
    {$IFNDEF RVDONOTUSEUNICODE}
    GetTextInItemFormatA(ItemNo, s);
    {$ELSE}
    s;
    {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemText(ItemNo: Integer; const s: String);
begin
  {$IFDEF RVUNICODESTR}
  SetItemTextW(ItemNo, s);
  {$ELSE}
  SetItemTextA(ItemNo, s);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemTextA(ItemNo: Integer): TRVAnsiString;
begin
  Result := Items[ItemNo];
  {$IFNDEF RVDONOTUSEUNICODE}
  if (GetItemStyle(ItemNo)>=0) and (rvioUnicode in GetItemOptions(ItemNo)) then
    Result := RVU_UnicodeToAnsi(GetItemCodePage(ItemNo), Result);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemText(ItemNo: Integer): String;
begin
  {$IFDEF RVUNICODESTR}
  Result := GetItemTextW(ItemNo);
  {$ELSE}
  Result := GetItemTextA(ItemNo);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNLR(const s: TRVRawByteString; StyleNo, ParaNo: Integer);
begin
  AddNLRTag(s, StyleNo, ParaNo, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddNL(const s: String; StyleNo, ParaNo: Integer);
begin
  {$IFDEF RVUNICODESTR}
  AddNLWTag(s, StyleNo, ParaNo, 0);
  {$ELSE}
  AddNLATag(s, StyleNo, ParaNo, 0);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddFmt(const FormatStr: String; const Args: array of const;
  StyleNo, ParaNo: Integer);
begin
  AddNLTag(Format(FormatStr,Args), StyleNo, ParaNo, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddTextNLR(const s: TRVRawByteString; StyleNo,
  FirstParaNo, OtherParaNo : Integer
  {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
begin
  AddTextUniversal(s, StyleNo, FirstParaNo, OtherParaNo, False, False,
    {$IFDEF RICHVIEWDEF4}Tag{$ELSE}0{$ENDIF});
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddTextNL(const s: String; StyleNo,
  FirstParaNo, OtherParaNo : Integer
  {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
begin
  {$IFDEF RVUNICODESTR}
  AddTextNLW(s, StyleNo, FirstParaNo, OtherParaNo, False);
  {$ELSE}
  AddTextNLA(s, StyleNo, FirstParaNo, OtherParaNo {$IFDEF RICHVIEWDEF4},0{$ENDIF});
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddTextNLA(const s: TRVAnsiString; StyleNo,
  FirstParaNo, OtherParaNo : Integer
  {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
begin
  AddTextUniversal(s, StyleNo, FirstParaNo, OtherParaNo, False, True,
    {$IFDEF RICHVIEWDEF4}Tag{$ELSE}0{$ENDIF});
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddTextBlockNLA(const s: TRVAnsiString; StyleNo, ParaNo: Integer
  {$IFDEF RICHVIEWDEF4};Tag: Integer=0{$ENDIF});
begin
  AddTextUniversal(s, StyleNo, ParaNo, ParaNo, True, True,
    {$IFDEF RICHVIEWDEF4}Tag{$ELSE}0{$ENDIF});
end;
{------------------------------------------------------------------------------}
function TCustomRVData.AddNamedCheckpointExTag(const CpName: String;
  RaiseEvent: Boolean; Tag: Integer): Integer;
begin
  {$IFDEF RVALLOWCPBYCP}
  if NotAddedCP<>nil then begin
    Result := CPCount-1;
    exit;
  end;
  {$ELSE}
  if NotAddedCP<>nil then
    raise ERichViewError.Create(errCPByCP);
  {$ENDIF}
  NotAddedCP := TRVCPInfo.Create;
  NotAddedCP.Name := CPName;
  NotAddedCP.Tag := Tag;
  NotAddedCP.Next := nil;
  NotAddedCP.Prev := nil;
  //NotAddedCP.ItemNo := -1;
  NotAddedCP.RaiseEvent := RaiseEvent;
  Result := CPCount;
  inc(CPCount);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSETABS}
procedure TCustomRVData.AddTab(TextStyleNo, ParaNo: Integer);
var Item: TRVTabItemInfo;
begin
  Item := TRVTabItemInfo.Create(Self);
  Item.StyleNo := rvsTab;
  Item.TextStyleNo := TextStyleNo;
  Item.ParaNo  := ParaNo;
  Item.SameAsPrev := ParaNo=-1;
  AddItemR('', Item);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBreakExTag(Width: TRVStyleLength; Style: TRVBreakStyle;
  Color: TColor; Tag: Integer);
var Item: TRVBreakItemInfo;
begin
  Item := TRVBreakItemInfo.CreateEx(Self, Width, Style, Color);
  Item.SameAsPrev := False;
  Item.ParaNo     := 0;
  Item.Tag        := Tag;
  AddItemR('',Item);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBreakEx(Width: TRVStyleLength; Style: TRVBreakStyle;
  Color: TColor);
begin
  AddBreakExTag(Width, Style, Color, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBreakTag(Tag: Integer);
begin
  AddBreakExTag(1, rvbsLine, clNone, Tag);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBreak;
begin
  AddBreakTag(0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddHotspotExTag(const Name: TRVAnsiString;
  ImageIndex, HotImageIndex: Integer; ImageList: TCustomImageList;
  ParaNo, Tag: Integer);
var Item: TRVHotspotItemInfo;
begin
  Item               := TRVHotspotItemInfo.CreateEx(Self, ImageIndex, HotImageIndex,
                                                    ImageList, rvvaBaseLine);
  Item.ParaNo        := ParaNo;
  Item.Tag := Tag;
  AddItemR(Name, Item);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddHotspotEx(const Name: TRVAnsiString;
  ImageIndex, HotImageIndex: Integer; ImageList: TCustomImageList;
  ParaNo: Integer);
begin
  AddHotspotExTag(Name, ImageIndex, HotImageIndex, ImageList, ParaNo, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBulletExTag(const Name: TRVAnsiString;
  ImageIndex: Integer; ImageList: TCustomImageList;
  ParaNo, Tag: Integer);
var Item: TRVBulletItemInfo;
begin
  Item            := TRVBulletItemInfo.CreateEx(Self, ImageIndex, ImageList, rvvaBaseline);
  Item.ParaNo     := ParaNo;
  Item.Tag        := Tag;
  AddItemR(Name, Item);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddBulletEx(const Name: TRVAnsiString; ImageIndex: Integer;
  ImageList: TCustomImageList; ParaNo: Integer);
begin
  AddBulletExTag(Name, ImageIndex, ImageList, ParaNo, 0)
end;
{------------------------------------------------------------------------------}
{ "gr" does not copied, do not free it!                                        }
procedure TCustomRVData.AddPictureExTag(const Name: TRVAnsiString; gr: TGraphic;
  ParaNo: Integer; VAlign: TRVVAlign; Tag: Integer);
var Item: TRVGraphicItemInfo;
begin
  Item := TRVGraphicItemInfo.CreateEx(Self, gr, VAlign);
  Item.ParaNo  := ParaNo;
  Item.Tag     := Tag;
  AddItemR(Name, Item);
end;
{------------------------------------------------------------------------------}
{ gr does not copied, do not free it!                                          }
procedure TCustomRVData.AddPictureEx(const Name: TRVAnsiString; gr: TGraphic;
  ParaNo: Integer; VAlign: TRVVAlign);
begin
  AddPictureExTag(Name, gr, ParaNo, VAlign, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddHotPicture(const Name: TRVAnsiString; gr: TGraphic;
  ParaNo: Integer; VAlign: TRVVAlign);
begin
  AddHotPictureTag(Name, gr, ParaNo, VAlign, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddHotPictureTag(const Name: TRVAnsiString; gr: TGraphic;
  ParaNo: Integer; VAlign: TRVVAlign; Tag: Integer);
var Item: TRVHotGraphicItemInfo;
begin
  Item := TRVHotGraphicItemInfo.CreateEx(Self, gr, VAlign);
  Item.ParaNo  := ParaNo;
  Item.Tag     := Tag;
  AddItemR(Name, Item);
end;
{------------------------------------------------------------------------------}
{ do not free ctrl yourself!                                                   }
procedure TCustomRVData.AddControlExTag(const Name: TRVAnsiString; ctrl: TControl;
  ParaNo: Integer; VAlign: TRVVAlign; Tag: Integer);
var Item: TRVControlItemInfo;
begin
  Item         := TRVControlItemInfo.CreateEx(Self, ctrl, VAlign);
  Item.StyleNo := rvsComponent;
  Item.ParaNo  := ParaNo;
  Item.Tag     := Tag;
  AddItemR(Name, Item);
  ctrl.Parent := GetParentControl;
end;
{------------------------------------------------------------------------------}
{ do not free ctrl yourself!                                                   }
procedure TCustomRVData.AddControlEx(const Name: TRVAnsiString; ctrl: TControl;
  ParaNo: Integer; VAlign: TRVVAlign);
begin
  AddControlExTag(Name, ctrl, ParaNo, VAlign, 0);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetAddParagraphMode(AllowNewPara: Boolean);
begin
 FAllowNewPara := AllowNewPara;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetCP(Item: TCustomRVItemInfo; var PrevCP, CP: TRVCPInfo);
begin
  if CP=nil then
    exit;
  CP.Prev := PrevCP;
  CP.ItemInfo := Item;
  if (PrevCP=nil) then begin // inserting before first, making first
    if FirstCP<>nil then
      FirstCP.Prev := CP;
    CP.Next := FirstCP;
    FirstCP := CP;
    end
  else
    CP.Next := PrevCP.Next;
  if PrevCP<>nil then
    PrevCP.Next := CP;
  if CP.Next<>nil then
    CP.Next.Prev := CP;
  if PrevCP=LastCP then
    LastCP := CP;
  Item.Checkpoint := CP;
  CP := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.UnlinkCheckpoint(cp: TRVCPInfo; DecCPCount: Boolean);
begin
  if cp<>nil then begin
    cp.ItemInfo := nil;
    if FirstCP = cp then FirstCP := cp.Next;
    if LastCP = cp  then LastCP  := cp.Prev;
    if cp.Prev<>nil then cp.Prev.Next := cp.Next;
    if cp.Next<>nil then cp.Next.Prev := cp.Prev;
    if DecCPCount then
      dec(CPCount);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.FreeCheckpoint(var cp: TRVCPInfo; AdjustLinks,DecCPCount: Boolean);
begin
  if cp<>nil then begin
    if AdjustLinks then
      UnlinkCheckpoint(cp,False);
    if rvoTagsArePChars in Options then
      StrDispose(PChar(cp.Tag));
    cp.Free;
    cp := nil;
    if DecCPCount then
      dec(CPCount);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.ShareItems: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.CanLoadLayout: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteItems(FirstItemNo, Count: Integer);
var i: Integer;
begin
  if ShareItems then exit;
  if FirstItemNo>=Items.Count then exit;
  if FirstItemNo+Count>Items.Count then
    Count := Items.Count-FirstItemNo;
  for i := FirstItemNo to FirstItemNo+Count-1 do
    FreeItem(i,False);
  for i :=1 to Count do
    Items.Delete(FirstItemNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteSection(const CpName: String);
var startno, endno: Integer;
    cp: TRVCPInfo;
begin
  if ShareItems then exit;
   cp := FirstCP;
   startno := -1;
   endno := -1;
   while cp<>nil do begin
     if cp.Name=CpName then begin
       startno := Items.IndexOfObject(cp.ItemInfo);
       endno := Items.Count-1;
       break;
     end;
     cp := cp.Next;
   end;
   if startno=-1 then exit;
   cp := cp.Next;
   while cp<>nil do begin
     if cp.Name<>'' then begin
       endno := Items.IndexOfObject(cp.ItemInfo)-1;
       break;
     end;
     cp := cp.Next;
   end;
   DeleteItems(startno, endno-startno+1);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.InternalFreeItem(item: TCustomRVItemInfo; Clearing: Boolean);
begin
  if Item=nil then
    exit;
  {$IFNDEF RVDONOTUSESEQ}
  DeleteSeqFromList(item, Clearing);
  {$ENDIF}
  {$IFNDEF RVDONOTUSELISTS}
  DeleteMarkerFromList(item, Clearing);
  {$ENDIF}
  FreeCheckpoint(Item.Checkpoint, True, True);
  if rvoTagsArePChars in Options then
    StrDispose(PChar(Item.Tag));
  Item.Free;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.FreeItem(ItemNo: Integer; Clearing: Boolean);
var item: TCustomRVItemInfo;
    s: TRVRawByteString;
begin
  item := TCustomRVItemInfo(Items.Objects[ItemNo]);
  if item=nil then
    exit;
  s := Items[ItemNo];
  ItemAction(rviaDestroying, item, s, Self);
  ControlAction(Self, rvcaDestroy, ItemNo, item);
  InternalFreeItem(item, Clearing);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.Clear;
var i: Integer;
    Clearing: Boolean;
begin
  Clearing := rvstClearing in State;
  Include(State, rvstClearing);
  try
    Exclude(State, rvstFirstParaAborted);
    Exclude(State, rvstLastParaAborted);
    FFirstParaListNo := -1;
    FFirstParaLevel  := -1;
    if not ShareItems then begin
      for i:=0 to Items.Count-1 do
        FreeItem(i,True);
      Items.Clear;
    end;
    FreeCheckpoint(NotAddedCP, False, True);
    FirstCP := nil;
    LastCP  := nil;
    if GetDocProperties<>nil then
      GetDocProperties.Clear;
  finally
    if not Clearing then
      Exclude(State, rvstClearing);  
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetOffsBeforeItem(ItemNo: Integer): Integer;
begin
  if GetItemStyle(ItemNo)<0 then
    Result := 0
  else
    Result := 1;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetOffsAfterItem(ItemNo: Integer): Integer;
begin
  if GetItemStyle(ItemNo)<0 then
    Result := 1
  else
    Result := RVU_Length(Items[ItemNo], GetItemOptions(ItemNo))+1;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.ReplaceTabs(const s: TRVRawByteString; StyleNo: Integer;
  UnicodeDef: Boolean): TRVRawByteString;
begin
  if GetRVStyle = nil then begin
    {$IFNDEF RVDONOTUSEUNICODE}
    if UnicodeDef then
      Result := RV_ReplaceTabsW(s,8)
    else
    {$ENDIF}
      Result := RV_ReplaceTabsA(s,8)
    end
  else
    {$IFNDEF RVDONOTUSEUNICODE}
    if GetRVStyle.TextStyles[StyleNo].Unicode then
      Result := RV_ReplaceTabsW(s, GetRVStyle.SpacesInTab)
    else
    {$ENDIF}
      Result := RV_ReplaceTabsA(s, GetRVStyle.SpacesInTab);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddStringFromFile(const s: TRVAnsiString;
  StyleNo,ParaNo: Integer; FromNewLine, AsSingleParagraph: Boolean;
  var FirstTime, PageBreak: Boolean);
begin
  if not FromNewLine then
    ParaNo := -1;
  {$IFNDEF RVDONOTUSEUNICODE}
  AddNLATag(s,StyleNo,ParaNo,0);
  {$ELSE}
  AddNLRTag(s,StyleNo,ParaNo,0);
  {$ENDIF}
  if AsSingleParagraph and FirstTime then begin
    SetAddParagraphMode(False);
    FirstTime := False;
  end;
  if PageBreak then begin
    PageBreaksBeforeItems[Items.Count-1] := True;
    PageBreak := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadText(const FileName: String; StyleNo, ParaNo: Integer;
  AsSingleParagraph: Boolean): Boolean;
var Stream: TFileStream;
{
    f: TextFile;
    s: String;
}
begin
{
  AssignFile(f, FileName);
  Reset(f);
  while not eof(f) do begin
    Readln(f, s);
    AddTextNL(s, StyleNo, ParaNo, ParaNo);
  end;
  CloseFile(f);
  Result := True;
  exit;
  }
  try
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      Result := LoadTextFromStream(Stream, StyleNo, ParaNo, AsSingleParagraph)
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.AddTextUniversal(const text: TRVRawByteString; StyleNo, FirstParaNo,
  OtherParaNo: Integer; AsSingleParagraph, CheckUnicode: Boolean; Tag: Integer): Boolean;
var ANP: Boolean;
    FromNewLine, FirstTime, ProcessPageBreaks, PageBreak, ProcessTabs,
    CopyTags: Boolean;
    ParaNo : Integer;
    fulltextstartptr, startptr, ptr, endptr: PRVAnsiChar;
    SkipIfEqual: TRVAnsiChar;
    TabItem: TRVTabItemInfo;
    {........................................................}
    procedure AddTextItem;
    var AParaNo, ATag: Integer;
        s: TRVRawByteString;
    begin
      s := System.Copy(text, startptr-fulltextstartptr+1, ptr-startptr);
      if (s='') and not FromNewLine then
        exit;
      if FromNewLine or PageBreak then
        AParaNo := ParaNo
      else
        AParaNo := -1;
      if CopyTags then
        ATag := RV_CopyTag(Tag, True)
      else
        ATag := Tag;
      {$IFNDEF RVDONOTUSEUNICODE}
      if not CheckUnicode then
      {$ENDIF}
        if ProcessTabs then
          AddNLRTag_(s, StyleNo, AParaNo, ATag)
        else
          AddNLRTag(s, StyleNo, AParaNo, ATag)
      {$IFNDEF RVDONOTUSEUNICODE}
      else
        if ProcessTabs then
          AddNLATag_(s, StyleNo, AParaNo, ATag)
        else
          AddNLATag(s, StyleNo, AParaNo, ATag)
      {$ENDIF};
      FromNewLine := False;
      if PageBreak then begin
        PageBreaksBeforeItems[Items.Count-1] := True;
        PageBreak := False;
      end;
      if AsSingleParagraph and FirstTime then begin
        SetAddParagraphMode(False);
        FirstTime := False;
      end;      
    end;
    {........................................................}
begin
  ANP := FAllowNewPara;
  FirstTime := True;
  Result := True;
  ProcessPageBreaks := SupportsPageBreaks;
  PageBreak         := False;
  ProcessTabs       := (GetRVStyle<>nil) and (GetRVStyle.SpacesInTab<=0);
  CopyTags          := (Tag<>0) and (rvoTagsArePChars in Options);
  ParaNo            := FirstParaNo;
  FromNewLine       := ParaNo>=0;
  try
    fulltextstartptr := PRVAnsiChar(text);
    startptr := fulltextstartptr;
    ptr      := startptr;
    endptr   := PRVAnsiChar(text)+Length(text);
    SkipIfEqual := #0;
    while ptr<endptr do begin
      if SkipIfEqual<>#0 then begin
        if (ptr^=SkipIfEqual) then begin
          inc(startptr);
          inc(ptr);
          SkipIfEqual := #0;
          continue;
        end;
        SkipIfEqual := #0;
      end;
      if ((ptr^) in [#10, #12, #13]) or (ProcessTabs and ((ptr^)=#9)) then begin
        AddTextItem;
        startptr := ptr+1;
      end;
      case ptr^ of
       #9: // tab
         begin
           if ProcessTabs then begin
             TabItem := TRVTabItemInfo.Create(Self);
             TabItem.StyleNo := rvsTab;
             TabItem.TextStyleNo := StyleNo;
             if FromNewLine then
               TabItem.ParaNo := ParaNo
             else
               TabItem.ParaNo := -1;
             AddItemR('', TabItem);
             FromNewLine := False;
           end;
         end;
       #12: // page break
         begin
           PageBreak := ProcessPageBreaks;
           FromNewLine := True;
           ParaNo := OtherParaNo;
         end;
       #13:
         begin
           FromNewLine := True;
           SkipIfEqual := #10;
           ParaNo := OtherParaNo;
         end;
       #10:
         begin
           FromNewLine := True;
           SkipIfEqual := #13;
           ParaNo := OtherParaNo;
         end;
      end;
      inc(ptr);
    end;
    AddTextItem;
  except
    Result := False;
  end;
  SetAddParagraphMode(ANP);
  if CopyTags then
    StrDispose(PChar(Tag));
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadTextFromStream(Stream: TStream; StyleNo,
  ParaNo: Integer; AsSingleParagraph: Boolean):Boolean;
var FullText: TRVRawByteString;
begin
  if Stream.Size=Stream.Position then begin
    Result := True;
    exit;
  end;
  SetLength(FullText, Stream.Size-Stream.Position);
  Stream.ReadBuffer(PRVAnsiChar(FullText)^, Length(FullText));
  Replace0(FullText);
  Result := AddTextUniversal(FullText, StyleNo, ParaNo, ParaNo,
    AsSingleParagraph, True, 0);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveTextToStream(const Path: String; Stream: TStream;
  LineWidth: Integer;
  SelectionOnly, TextOnly, Unicode, UnicodeWriteSignature: Boolean):Boolean;
var i, StartItemNo,EndItemNo,StartOffs,EndOffs: Integer;
    SelectedItem: TCustomRVItemInfo;
    {$IFNDEF RVDONOTUSELISTS}
    MarkerItemNo: Integer;
    {$ENDIF}
    Item: TCustomRVItemInfo;
    s: TRVRawByteString;
    NotUsedPart: TRVMultiDrawItemPart;
    CustomSave: Boolean;
    {$IFNDEF RVDONOTUSEUNICODE}
    UniSign: Word;
    {$ENDIF}
    {..................................................}
    function GetStr(Item:TCustomRVItemInfo; const s: TRVRawByteString;
      CustomSave: Boolean) : TRVRawByteString;
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if not CustomSave then begin
        if (Item=nil) or (Item.StyleNo<0) then begin
          if Unicode and ((Item=nil) or not Item.GetBoolValue(rvbpCanSaveUnicode)) then
            Result := RVU_AnsiToUnicode(GetDefaultCodePage, s)
          else
            Result := s
          end
        else if (rvioUnicode in Item.ItemOptions) and not Unicode then
          Result := RVU_UnicodeToAnsi(GetDefaultCodePage, s)
        else if not (rvioUnicode in Item.ItemOptions) and Unicode then
          Result := RVU_AnsiToUnicode(GetStyleCodePage(GetActualStyle(Item)), s)
        else
          Result := s;
        end
      else
      {$ENDIF}
        Result := s;
    end;
    {..................................................}
    function GetTextStr(ItemNo, StartOffs, EndOffs: Integer;
      var CustomSave: Boolean): TRVRawByteString;
    begin
      if TextOnly and
        (rvteoHidden in GetRVStyle.TextStyles[GetActualStyle(GetItem(ItemNo))].Options) then begin
        Result := '';
        exit;
      end;
      if StartOffs<0 then
        Result := Items[ItemNo]
      else
        Result := RVU_Copy(Items[ItemNo], StartOffs, EndOffs-StartOffs,
          GetItem(ItemNo).ItemOptions);
      CustomSave := SaveItemToFile(Path, Self, ItemNo, rvsfText, Unicode, Result);
    end;
    {..................................................}
    function GetNonTextStr(ItemNo, StartOffs, EndOffs: Integer;
      var CustomSave: Boolean): TRVRawByteString;
    var SaveUnicode: Boolean;
        Item: TCustomRVItemInfo;
    begin
      CustomSave := False;
      Item := GetItem(ItemNo);
      Result := '';
      if TextOnly and TRVNonTextItemInfo(Item).Hidden then
        exit;
      if (not TextOnly or Item.GetBoolValue(rvbpAlwaysInText)) and
         (StartOffs<EndOffs) then begin
        CustomSave := SaveItemToFile(Path, Self, ItemNo, rvsfText, Unicode, Result);
        if not CustomSave then begin
          {$IFNDEF RVDONOTUSEUNICODE}
          SaveUnicode := Unicode and Item.GetBoolValue(rvbpCanSaveUnicode);
          {$ELSE}
          SaveUnicode := False;
          {$ENDIF}
          Result := GetItem(ItemNo).AsText(LineWidth, Self, Items[ItemNo], Path,
            TextOnly, SaveUnicode);
        end;
      end;
    end;
    {..................................................}
    procedure WriteCRLF;
    begin
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode then
        RVFWrite(Stream, #13#0#10#0)
      else
      {$ENDIF}
        RVFWrite(Stream, crlf);
    end;
    {..................................................}
    {$IFNDEF RVDONOTUSESEQ}
    procedure WriteEndNotes;
    var EndNote: TRVEndnoteItemInfo;
        s: TRVRawByteString;
    begin
      if SelectionOnly or TextOnly or not (rvflRoot in Flags) then
        exit;
      EndNote := RVGetFirstEndnoteInRootRVData(Self, True);
      if EndNote=nil then
        exit;
      WriteCRLF;        
      if LineWidth>=3 then begin
        SetLength(s, LineWidth div 3);
        FillChar(PRVAnsiChar(s)^, LineWidth div 3, ord('-'));
        {$IFNDEF RVDONOTUSEUNICODE}
        if Unicode then
          s := RVU_AnsiToUnicode(GetDefaultCodePage, s);
        {$ENDIF}
        RVFWrite(Stream, s);
      end;
      WriteCRLF;
      repeat
        EndNote.Document.SaveTextToStream(Path, Stream, 0, False, TextOnly, Unicode, False);
        EndNote :=
          TRVEndnoteItemInfo(GetNextNote(Self, EndNote, TRVEndnoteItemInfo, True));
        if EndNote<>nil then
          WriteCRLF;
      until EndNote=nil;
    end;
    {$ENDIF}
    {..................................................}
begin
  try
    Result := True;
    if not SelectionOnly then
      DoBeforeSaving;
    RVFGetLimits(GetRVFSaveScope(SelectionOnly), StartItemNo, EndItemNo,
      StartOffs, EndOffs, NotUsedPart, NotUsedPart, SelectedItem);
    if SelectedItem<>nil then begin
      SelectedItem.SaveTextSelection(Stream, Self, LineWidth, Path, TextOnly,
        Unicode);
      exit;
    end;
    if (StartItemNo=-1) or (StartItemNo>EndItemNo) then
      exit;
    {$IFNDEF RVDONOTUSEUNICODE}
    if Unicode and UnicodeWriteSignature then begin
      UniSign := UNI_LSB_FIRST;
      Stream.WriteBuffer(UniSign, 2);
    end;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    if SelectionOnly then begin
      MarkerItemNo := GetFirstParaSectionItem(StartItemNo);
      if (GetItemStyle(MarkerItemNo)=rvsListMarker) then begin
        s := GetNonTextStr(MarkerItemNo, 0, 1, CustomSave);
        RVFWrite(Stream, GetStr(GetItem(MarkerItemNo), s, CustomSave));
      end;
    end;
    {$ENDIF}
    Item := GetItem(StartItemNo);
    if StartItemNo = EndItemNo then begin
      if Item.StyleNo<0 then
        s := GetNonTextStr(StartItemNo, StartOffs, EndOffs, CustomSave)
      else
        s := GetTextStr(StartItemNo, StartOffs, EndOffs, CustomSave);
      RVFWrite(Stream, GetStr(Item, s, CustomSave));
      end
    else begin
      if Item.StyleNo < 0 then
        s := GetNonTextStr(StartItemNo, StartOffs, 1, CustomSave)
      else
        s := GetTextStr(StartItemNo, StartOffs, RVU_Length(Items[StartItemNo],
          Item.ItemOptions)+1, CustomSave);
      RVFWrite(Stream, GetStr(Item, s, CustomSave));
      for i := StartItemNo+1 to EndItemNo-1 do begin
        Item := GetItem(i);
        if not (TextOnly and IsHiddenItem(i)) then
          if Item.PageBreakBefore and RichViewSavePageBreaksInText then
            RVFWrite(Stream, GetStr(nil, #$0C, False))
          else if not Item.SameAsPrev then
            WriteCRLF;
        if Item.StyleNo < 0 then
          s := GetNonTextStr(i, 0, 1, CustomSave)
        else
          s := GetTextStr(i, -1, -1, CustomSave);
        RVFWrite(Stream, GetStr(Item, s, CustomSave));
      end;
      Item := GetItem(EndItemNo);
      if not (TextOnly and IsHiddenItem(EndItemNo)) then
        if Item.PageBreakBefore and RichViewSavePageBreaksInText then
          RVFWrite(Stream, GetStr(nil, #$0C, False))
        else if not Item.SameAsPrev then
          WriteCRLF;
       if Item.StyleNo < 0 then
        s := GetNonTextStr(EndItemNo, 0, EndOffs, CustomSave)
      else
        s := GetTextStr(EndItemNo, 1, EndOffs, CustomSave);
      RVFWrite(Stream, GetStr(Item, s, CustomSave));
    end;
    {$IFNDEF RVDONOTUSESEQ}
    WriteEndNotes;
    {$ENDIF}
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveText(const FileName: String; LineWidth: Integer;
  Unicode: Boolean): Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      Result := SaveTextToStream(ExtractFilePath(FileName), Stream, LineWidth,
        False, False, Unicode, Unicode);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
procedure TCustomRVData.AddTextNLWRaw(const s: TRVRawByteString; StyleNo, FirstParaNo,
  OtherParaNo : Integer; DefAsSingleParagraph: Boolean);
var
    ParaNo: Integer;
    startptr,ptr,endptr: PWord;
    SkipIfEqual: Word;
    ANP: Boolean;
    ProcessTabs, ProcessPageBreaks, PageBreak, FromNewLine: Boolean;
    TabItem: TRVTabItemInfo;
    {.................................}
    procedure AddTextItem(AllowAddingEmpty: Boolean);
    var str: TRVRawByteString;
        AParaNo: Integer;
    begin
      if (startptr=ptr) and (not FromNewLine or not AllowAddingEmpty) then
        exit;
      str := Copy(s, PRVAnsiChar(startptr)-PRVAnsiChar(s)+1, PRVAnsiChar(ptr)-PRVAnsiChar(startptr));
      if FromNewLine or PageBreak then
        AParaNo := ParaNo
      else
        AParaNo := -1;
      AddNLWTagRaw(str, StyleNo, AParaNo, 0);
      FromNewLine := False;
      if PageBreak then begin
        PageBreaksBeforeItems[Items.Count-1] := True;
        PageBreak := False;
      end;
    end;
    {.................................}
begin
   ANP := FAllowNewPara;
   RVCheckUni(Length(s));
   startptr := PWord(PRVAnsiChar(s));
   endptr   := PWord(PRVAnsiChar(s)+Length(s));
   RVU_ProcessByteOrderMark(startptr, Length(s) div 2);
   ptr      := startptr;
   if ptr=endptr then begin
     if FirstParaNo<>-1 then
       AddNLR(s, StyleNo, FirstParaNo);
     exit;
   end;
   ParaNo := FirstParaNo;
   FromNewLine := ParaNo>=0;
   SkipIfEqual := 0;
   ProcessPageBreaks := SupportsPageBreaks;
   PageBreak         := False;
   ProcessTabs       := (GetRVStyle<>nil) and (GetRVStyle.SpacesInTab<=0);
   //SetAddParagraphMode(not DefAsSingleParagraph);
   while PRVAnsiChar(ptr)<PRVAnsiChar(endptr) do begin
     if SkipIfEqual<>0 then begin
       if (ptr^=SkipIfEqual) then begin
         inc(PRVAnsiChar(startptr),2);
         inc(PRVAnsiChar(ptr), 2);
         SkipIfEqual := 0;
         continue;
       end;
       SkipIfEqual := 0;
     end;
     case ptr^ of
       UNI_LineSeparator, UNI_VerticalTab:
         begin
           AddTextItem(True);
           SetAddParagraphMode(False);
           ParaNo := OtherParaNo;
           FromNewLine := True;
           startptr := PWord(PRVAnsiChar(ptr)+2);
         end;
       UNI_ParagraphSeparator:
         begin
           AddTextItem(True);
           SetAddParagraphMode(True);
           ParaNo := OtherParaNo;
           FromNewLine := True;
           startptr := PWord(PRVAnsiChar(ptr)+2);
         end;
       UNI_FF:
         begin
           AddTextItem(True);
           PageBreak := ProcessPageBreaks;
           ParaNo := OtherParaNo;
           FromNewLine := True;
           startptr := PWord(PRVAnsiChar(ptr)+2);
         end;
       UNI_CR:
         begin
           AddTextItem(True);
           SetAddParagraphMode(not DefAsSingleParagraph);
           SkipIfEqual := UNI_LF;
           ParaNo := OtherParaNo;
           FromNewLine := True;
           startptr := PWord(PRVAnsiChar(ptr)+2);
         end;
       UNI_LF:
         begin
           AddTextItem(True);
           SetAddParagraphMode(not DefAsSingleParagraph);
           SkipIfEqual := UNI_CR;
           ParaNo := OtherParaNo;
           FromNewLine := True;
           startptr := PWord(PRVAnsiChar(ptr)+2);
         end;
       UNI_Tab:
         begin
           if ProcessTabs then begin
             AddTextItem(False);
             TabItem := TRVTabItemInfo.Create(Self);
             TabItem.StyleNo := rvsTab;
             TabItem.TextStyleNo := StyleNo;
             if FromNewLine then
               TabItem.ParaNo := ParaNo
             else
               TabItem.ParaNo := -1;
             AddItemR('', TabItem);
             FromNewLine := False;
             SetAddParagraphMode(not DefAsSingleParagraph);
             startptr := PWord(PRVAnsiChar(ptr)+2);
           end;
         end;
     end;
     inc(PRVAnsiChar(ptr), 2);
   end;
   AddTextItem(True);
   SetAddParagraphMode(ANP);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddTextNLW(const s: TRVUnicodeString; StyleNo, FirstParaNo,
  OtherParaNo: Integer; DefAsSingleParagraph: Boolean);
begin
  AddTextNLWRaw(RVU_GetRawUnicode(s), StyleNo, FirstParaNo, OtherParaNo,
    DefAsSingleParagraph);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadTextFromStreamW(Stream: TStream; StyleNo, ParaNo: Integer;
      DefAsSingleParagraph: Boolean):Boolean;
var s: TRVRawByteString;
begin
  Result := True;
  try
    RVCheckUni(Stream.Size-Stream.Position);
    SetLength(s, Stream.Size-Stream.Position);
    Stream.ReadBuffer(PRVAnsiChar(s)^,Stream.Size-Stream.Position);
    AddTextNLWRaw(s, StyleNo, ParaNo, ParaNo, DefAsSingleParagraph);
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadTextW(const FileName: String; StyleNo, ParaNo: Integer;
  DefAsSingleParagraph: Boolean): Boolean;
var Stream: TFileStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadTextFromStreamW(Stream, StyleNo, ParaNo, DefAsSingleParagraph);
  finally
    Stream.Free;
  end;
end;
{$ENDIF}
{$IFNDEF RVDONOTUSEHTML}
{------------------------------------------------------------------------------}
function TCustomRVData.SaveHTML(const FileName, Title, ImagesPrefix: String;
  Options: TRVSaveOptions; Color: TColor;
  var imgSaveNo: Integer;
  LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground): Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      Result := SaveHTMLToStream(Stream, ExtractFilePath(FileName),
        Title, ImagesPrefix, Options, Color, imgSaveNo,
        LeftMargin, TopMargin, RightMargin, BottomMargin,
        Background, nil);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveHTMLEx(const FileName, Title, ImagesPrefix,
  ExtraStyles, ExternalCSS, CPPrefix: String; Options: TRVSaveOptions;
  Color: TColor; var CurrentFileColor: TColor;
  var imgSaveNo: Integer;
  LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground):Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      Result := SaveHTMLToStreamEx(Stream, ExtractFilePath(FileName),
        Title, ImagesPrefix, ExtraStyles, ExternalCSS, CPPrefix, Options,
        Color, CurrentFileColor, imgSaveNo, LeftMargin, TopMargin,
        RightMargin, BottomMargin, Background, nil);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.ShouldSaveTextToHTML(StyleNo: Integer): Boolean;
begin
  with GetRVStyle.TextStyles[StyleNo] do
    Result := (rvteoHTMLCode in Options) or not (rvteoRTFCode in Options)
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetHTMLATag(ItemNo: Integer; CSS: TRVRawByteString): String;
var Target, Extras: String;
begin
  WriteHyperlink(GetItem(ItemNo).JumpID+FirstJumpNo, Self, ItemNo, rvsfHTML,
    Target, Extras);
  if (Target<>'') or (Extras<>'') then begin
    if Extras<>'' then
      Extras := ' '+Extras;
    if CSS<>'' then
      CSS := ' '+CSS;
    if Target = '' then
      Result := Format('<a%s%s>',[CSS, Extras])
    else
      Result := Format('<a%s href="%s"%s>',[CSS, Target, Extras]);
    end
  else
    Result := '';
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SaveHTMLCheckpoint(Stream: TStream;
  Checkpoint: TRVCPInfo; var cpno: Integer; const Prefix: String;
  FromNewLine: Boolean; Options: TRVSaveOptions);
var CPId: TRVRawByteString;
begin
  if Checkpoint<>nil then begin
    if FromNewLine then
      RVWriteLn(Stream,'');
    if (rvsoUseCheckpointsNames in Options) and (Checkpoint.Name<>'') then
      CPId := StringToHTMLString(Checkpoint.Name, Options, GetRVStyle)
    else
      CPId := StringToHTMLString(Prefix+IntToStr(cpno), Options, GetRVStyle);
    RVWriteLn(Stream,'<a name="'+CPId+'"></a>');
    inc(cpno);
  end;
end;
{------------------------------------------------------------------------------}
// Returns true if the next item is in the same paragraph, is a text item,
// and its first character is a space character
function TCustomRVData.NextItemFromSpace(ItemNo: Integer): Boolean;
var s: TRVRawByteString;
begin
  inc(ItemNo);
  Result := False;
  if (ItemNo=ItemCount) or IsFromNewLine(ItemNo) or (GetItemStyle(ItemNo)<0) then
    exit;
  s := GetItemTextR(ItemNo);
  if s='' then
    exit;
  {$IFNDEF RVDONOTUSEUNICODE}
  if rvioUnicode in GetItemOptions(ItemNo) then
    Result := (s[1]=' ') and (s[2]=#0)
  else
  {$ENDIF}
    Result := s[1]=' ';

end;
{------------------------------------------------------------------------------}
{ Returns text string for saving to HTML. Path - path for saving HTML (pictures).
  ItemNo - index of text item to save.
  CSSVersion is True is called from SaveHTMLEx.
  Calls OnSaveItemToHTML, if assigned.
  If CSSVersion, special processing for "Symbol" font                          }
function TCustomRVData.GetTextForHTML(const Path: String; ItemNo: Integer;
  CSSVersion: Boolean; SaveOptions: TRVSaveOptions): TRVRawByteString;
var Item: TCustomRVItemInfo;
    FontInfo: TFontInfo;
    StyleNo: Integer;
begin
  Result := Items[ItemNo];
  if not SaveItemToFile(Path, Self, ItemNo, rvsfHTML,
    rvsoUTF8 in SaveOptions, Result) then begin
    if (Result='') and IsFromNewLine(ItemNo) and
      ((ItemNo+1=ItemCount) or IsParaStart(ItemNo+1)) then begin
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<br%s>', [RV_HTMLGetEndingSlash(SaveOptions)]);
      exit;
    end;
    Item := GetItem(ItemNo);
    StyleNo := GetActualStyle(Item);
    FontInfo := GetRVStyle.TextStyles[StyleNo];
    {$IFNDEF RVDONOTUSEUNICODE}
    if rvioUnicode in Item.ItemOptions then
      if CSSVersion and (AnsiCompareText(FontInfo.FontName, RVFONT_SYMBOL)=0) then
        Result := RV_MakeHTMLSymbolStrRaw(Result)
      else if rvsoUTF8 in SaveOptions then
        Result := RVU_GetHTMLUTF8EncodedUnicode(Result, rvteoHTMLCode in FontInfo.Options,
          NextItemFromSpace(ItemNo))
      else
        Result := RVU_GetHTMLEncodedUnicode(Result, rvteoHTMLCode in FontInfo.Options,
          NextItemFromSpace(ItemNo))
    else
    {$ENDIF}
      if CSSVersion and (AnsiCompareText(FontInfo.FontName, RVFONT_SYMBOL)=0) then
        Result := RV_MakeHTMLSymbolStrA(Result)
      else begin
        Result := RV_MakeHTMLStr(Result, rvteoHTMLCode in FontInfo.Options,
          NextItemFromSpace(ItemNo));
        if rvsoUTF8 in SaveOptions then
          Result := RVU_AnsiToUTF8(GetStyleCodePage(StyleNo), Result);
      end;
    end
  {$IFNDEF RVDONOTUSEUNICODE}
  else if rvsoUTF8 in SaveOptions then
    Result := UTF8Encode(RVU_RawUnicodeToWideString(Result));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TCustomRVData.SaveHTMLNotes(const Path, ImagesPrefix, CPPrefix: String;
  Stream: TStream; CSSVersion: Boolean;
  Options: TRVSaveOptions; Color: TColor; var imgSaveNo: Integer; Bullets: TRVList;
  NoteClass: TCustomRVItemInfoClass);
var Note: TCustomRVNoteItemInfo;
    ColorStr: TRVAnsiString;
    SeqList: TRVSeqList;
const BreakColor = $C0C0C0;
begin
  if (Self is TRVNoteData) or not (rvflRoot in Flags) then
    exit;
  SeqList := GetSeqList(False);
  Include(Options, rvsoMiddleOnly);
  Exclude(Options, rvsoFirstOnly);
  Exclude(Options, rvsoLastOnly);
  Note := GetNextNote(GetAbsoluteRootData, nil,
    TCustomRVNoteItemInfoClass(NoteClass), True);
  if Note<>nil then begin
    if CSSVersion or (rvsoForceNonTextCSS in Options) then
      ColorStr := 'style= "color : '+RV_GetHTMLRGBStr(BreakColor, False)+'"'
    else
      ColorStr := 'color='+ RV_GetHTMLRGBStr(BreakColor, True);
    RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<hr %s %s width="30%%" align="left" size="2" %s>',
      [RV_HTMLGetNoValueAttribute('noshade', Options), ColorStr,
       RV_HTMLGetEndingSlash(Options)]));
  end;
  while Note<>nil do begin
    Note.GetIndexInList(SeqList);
    RVFWrite(Stream, '<a name="'+Note.GetHTMLAnchorName+'"></a>');
    if CSSVersion then
      Note.Document.SaveHTMLToStreamEx(Stream, Path, '', ImagesPrefix, '', '',
        CPPrefix, Options, Color, Color,  imgSaveNo,
        0, 0, 0, 0, nil, Bullets)
    else
      Note.Document.SaveHTMLToStream(Stream, Path, '', ImagesPrefix, Options, Color, imgSaveNo,
        0, 0, 0, 0, nil, Bullets);
    Note := GetNextNote(GetAbsoluteRootData, Note,
      TCustomRVNoteItemInfoClass(NoteClass), True);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVData.SaveHTMLToStream(Stream: TStream;
  const Path, Title, ImagesPrefix: String;
  Options: TRVSaveOptions; Color: TColor;
  var imgSaveNo: Integer; LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground; Bullets: TRVList): Boolean;
    {......................................................}
    procedure WriteExtraHTMLCode(Area: TRVHTMLSaveArea; AddSpace: Boolean;
      RVStyle: TRVStyle);
    var s: String;
        s2: TRVRawByteString;
    begin
      s := GetExtraHTMLCode(Area, False);
      if s<>'' then begin
        s2 := StringToHTMLString(s, Options, RVStyle);
        if AddSpace then
          RVWrite(Stream,' '+s2)
        else
          RVWrite(Stream, s2);
      end;
    end;
    {...........................................................}
    procedure SaveFirst(Stream: TStream; const Path: String; Title: String);
    var s: TRVRawByteString;
        s2: String;
    begin
      if rvsoXHTML in Options then begin
        RVWrite(Stream, '<?xml version="1.0"');
        {$IFDEF RICHVIEWCBDEF3}
        if rvsoUTF8 in Options then
          s := 'UTF-8'
        else
          s := RV_CharSet2HTMLLang(GetRVStyle.TextStyles[0].CharSet);
        if s<>'' then
          RVWrite(Stream,{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' encoding="%s"',[s]));
        {$ENDIF}
        RVWriteLn(Stream, '?>');
      end;
      s := StringToHTMLString(Title, Options, GetRVStyle);
      RVWriteLn(Stream,'<html><head><title>'+s+'</title>');
      {$IFDEF RICHVIEWCBDEF3}
      if rvsoUTF8 in Options then
        s := 'UTF-8'
      else
        s := RV_CharSet2HTMLLang(GetRVStyle.TextStyles[0].CharSet);
      if s<>'' then
        RVWriteLn(Stream,{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<meta http-equiv="Content-Type" content="text/html; charset=%s"%s>',
          [s, RV_HTMLGetEndingSlash(Options)]));
      {$ENDIF}
      WriteExtraHTMLCode(rv_thms_Head, False, GetRVStyle);
      RVWriteLn(Stream,'</head>');
      RVWrite(Stream,'<body');
      if Color<>clNone then
         RVWrite(Stream,' bgcolor='+RV_GetHTMLRGBStr(Color, True));
      if (Background.Style<>bsNoBitmap) and
         (not Background.Bitmap.Empty) then begin
         s2 := SaveBackgroundToHTML(Background.Bitmap, Color, Path, ImagesPrefix,
           imgSaveNo, Options);
         if s2<>'' then begin
           s := StringToHTMLString(s2, Options, GetRVStyle);
           RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' background="%s"', [s]));
           if (Background.Style<>bsTiledAndScrolled) then
             RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' bgproperties=%s', [RV_HTMLGetStrAttrVal('fixed', Options)]));
         end;
      end;
      WriteExtraHTMLCode(rv_thms_BodyAttribute, True, GetRVStyle);
      RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' leftmargin=%s topmargin=%s rightmargin=%s bottommargin=%s>',
        [RV_HTMLGetIntAttrVal(LeftMargin,   Options),
         RV_HTMLGetIntAttrVal(TopMargin,    Options),
         RV_HTMLGetIntAttrVal(RightMargin,  Options),
         RV_HTMLGetIntAttrVal(BottomMargin, Options)]));
      WriteExtraHTMLCode(rv_thms_Body, False, GetRVStyle);
    end;
    {...........................................................}
    procedure SaveLast(Stream: TStream);
    begin
      WriteExtraHTMLCode(rv_thms_End, False, GetRVStyle);
      RVWriteLn(Stream,'</body></html>');
    end;
    {......................................................}
    function GetPageBreakCSS(item: TCustomRVItemInfo): TRVAnsiString;
    begin
      if (rvsoForceNonTextCSS in Options) and item.PageBreakBefore then 
        Result := ' style="page-break-before: always;"'
      else
        Result := '';
    end;
    {...........................................................}
    function GetBiDiModeAttr(BiDiMode: TRVBiDiMode): TRVAnsiString;
    begin
      case BiDiMode of
        rvbdLeftToRight:
          Result := 'LTR';
        rvbdRightToLeft:
          Result := 'RTL';
        else
          Result := '';
      end;
      if Result<>'' then
        Result := ' dir='+RV_HTMLGetStrAttrVal(Result,  Options);
    end;
    {...........................................................}
    function GetAlignAttr(Alignment: TRVAlignment): TRVAnsiString;
    begin
      case Alignment of
        rvaCenter:
          Result := 'center';
        rvaRight:
          Result := 'right';
        rvaJustify:
          Result := 'justify';
        else
          Result := '';
      end;
      if Result<>'' then
        Result := ' align='+RV_HTMLGetStrAttrVal(Result,  Options);
    end;
    {...........................................................}
    function GetBRClear(item: TCustomRVItemInfo): TRVAnsiString;
    begin
      if item.ClearLeft then
        if item.ClearRight then
          Result := 'all'
        else
          Result := 'left'
      else
        if item.ClearRight then
          Result := 'right'
        else begin
          Result := '';
          exit;
        end;
      Result := ' clear='+RV_HTMLGetStrAttrVal(Result,  Options);
    end;    
    {...........................................................}
    function GetOpenDIVTag(ParaStyle: TParaInfo; item: TCustomRVItemInfo;
      const OpenFont: TRVAnsiString): TRVAnsiString;
    var s: TRVAnsiString;
    begin
      Result := GetAlignAttr(ParaStyle.Alignment)+
        GetBiDiModeAttr(ParaStyle.BiDiMode)+
        GetPageBreakCSS(item);
      if ParaStyle.IsHeading(6) then
        s := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('h%d', [ParaStyle.OutlineLevel])
      else if RichViewSavePInHTML then
        s := 'p'
      else
        s := 'div';
      Result := '<'+s+Result+'>';
      if item.ClearLeft or item.ClearRight then
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<font size=1><br%s%s></font>%s',
          [GetBRClear(item), RV_HTMLGetEndingSlash(Options), Result]);
      if ParaStyle.IsHeading(6) then
        Result := Result+OpenFont;
    end;
    {...........................................................}
    {$IFNDEF RVDONOTUSELISTS}
    function GetOpenMarkerDIVTag(ParaStyle: TParaInfo; item: TCustomRVItemInfo): TRVAnsiString;
    begin
      Result := GetAlignAttr(ParaStyle.Alignment)+
        GetBiDiModeAttr(ParaStyle.BiDiMode)+
        GetPageBreakCSS(item);
      if Result='' then
        exit;
      Result := '<div'+Result+'>';
    end;
    {$ENDIF}
    {...........................................................}
    function GetCloseDIVTag(ParaStyle: TParaInfo;
      const CloseFont: TRVAnsiString): TRVAnsiString;
    begin
      if ParaStyle.IsHeading(6) then
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%s</h%d>',
          [CloseFont, ParaStyle.OutlineLevel])
      else if RichViewSavePInHTML then
        Result := '</p>'
      else
        Result := '</div>';
    end;
    {...........................................................}
    procedure SaveMiddle(Stream: TStream; const Path: String);
    var
      i: Integer;
      item: TCustomRVItemInfo;
      CloseDIV: Boolean;
      s2, s3, OpenFont, CloseFont: TRVRawByteString;
      HintTag2: TRVRawByteString;
      ATag, HintTag: String;
      cpno: Integer;
      CreateBulletList: Boolean;
      RVStyle: TRVStyle;
      TextStyleNo: Integer;
      {$IFNDEF RVDONOTUSELISTS}
      marker: TRVMarkerItemInfo;
      CloseMarkerDiv: Boolean;
      {$ENDIF}
    begin
      DoBeforeSaving;
      cpno := 0;
      {$IFNDEF RVDONOTUSELISTS}
      marker := nil;
      CloseMarkerDiv := False;
      {$ENDIF}
      RVStyle := GetRVStyle;
      CreateBulletList := Bullets=nil;
      if CreateBulletList then
        Bullets := TRVList.Create;
      try
        if not (rvsoDefault0Style in Options) then begin
          OpenFont := StringToHTMLString2(
            RV_HTMLOpenFontTag(RVStyle.TextStyles[0],
              RVStyle.TextStyles[0], False, Options),
            Options, CP_ACP);
          CloseFont := RV_HTMLCloseFontTag(RVStyle.TextStyles[0],
            RVStyle.TextStyles[0], False);
          RVWriteLn(Stream, OpenFont);
          end
        else begin
          OpenFont := '';
          CloseFont := '';
        end;
        CloseDIV := False;
        for i:=0 to Items.Count-1 do begin
          item := GetItem(i);
          if not item.SameAsPrev then begin
            if item.BR then
              RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<br%s%s>',
                [GetBRClear(item), RV_HTMLGetEndingSlash(Options)]))
            else begin
              {$IFNDEF RVDONOTUSELISTS}
              if marker<>nil then begin
                if CloseMarkerDiv then
                  RVWriteLn(Stream,'</li></div>')
                else
                  RVWriteLn(Stream,'</li>');
                RVWrite(Stream, GetParaHTMLCode2(Self, i, False, False, Options, RVStyle));
              end;
              {$ENDIF}
              if CloseDIV then begin
                RVWriteLn(Stream,GetCloseDIVTag(RVStyle.ParaStyles[GetItemPara(i-1)], CloseFont));
                RVWrite(Stream, GetParaHTMLCode2(Self, i, False, False, Options, RVStyle));
                CloseDIV := False;
              end;
            end;
            if not item.BR then
              case item.StyleNo of
                rvsBreak: ;
                {$IFNDEF RVDONOTUSELISTS}
                rvsListMarker:
                  begin
                    if (rvsoMarkersAsText in Options) or
                       (TRVMarkerItemInfo(item).GetLevelInfo(RVStyle)=nil) then begin
                      RVWrite(Stream, GetParaHTMLCode2(Self, i, True, False, Options, RVStyle));
                      RVWrite(Stream, GetOpenDIVTag(RVStyle.ParaStyles[item.ParaNo], item, OpenFont));
                      CloseDIV := True;
                      end
                    else begin
                      TRVMarkerItemInfo(item).SaveHTMLSpecial(Stream, marker, RVStyle, False);
                      RVWrite(Stream, GetParaHTMLCode2(Self, i, True, False, Options, RVStyle));
                      marker := TRVMarkerItemInfo(item);
                      s3 := GetOpenMarkerDIVTag(RVStyle.ParaStyles[marker.ParaNo], marker);
                      CloseMarkerDiv := s3<>'';
                      if CloseMarkerDiv then
                        RVWrite(Stream, s3);
                      if marker.GetLevelInfo(RVStyle).HasNumbering then
                        RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<li value=%s%s>',
                          [RV_HTMLGetIntAttrVal(marker.Counter, Options), GetPageBreakCSS(marker)]))
                      else
                        RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<li%s>',[GetPageBreakCSS(marker)]));
                    end;
                  end;
                {$ENDIF}
                else
                  begin
                    {$IFNDEF RVDONOTUSELISTS}
                    if marker<>nil then begin
                      marker.HTMLOpenOrCloseTags(Stream, marker.Level, -1, RVStyle, False);
                      marker := nil;
                    end;
                    {$ENDIF}
                    RVWrite(Stream, GetParaHTMLCode2(Self, i, True, False, Options, RVStyle));
                    RVWrite(Stream, GetOpenDIVTag(RVStyle.ParaStyles[item.ParaNo], item, OpenFont));
                    CloseDIV := True;
                  end;
              end;
          end;
          SaveHTMLCheckpoint(Stream, item.Checkpoint, cpno, RVDEFAULTCHECKPOINTPREFIX, True, Options);
          ATag := '';
          HintTag := '';
          HintTag2 := '';
          if item.GetBoolValueEx(rvbpJump, RVStyle) then
            ATag := GetHTMLATag(i, '');
          if ATag<>'' then
            RVWrite(Stream, StringToHTMLString(ATag, Options, RVStyle))
          else begin
            item.GetExtraStrProperty(rvespHint, HintTag);
            if HintTag<>'' then begin
              HintTag := RV_GetHintStr(rvsfHTML, HintTag);
              HintTag2 := StringToHTMLString(HintTag, Options, RVStyle)
            end;
          end;
          if (item.StyleNo<0) and (item.AssociatedTextStyleNo<0) then begin // non-text
            s2 := '';
            if SaveItemToFile(Path, Self, i, rvsfHTML, rvsoUTF8 in Options, s2) then begin
              {$IFNDEF RVDONOTUSEUNICODE}
              if rvsoUTF8 in Options then
                s2 := UTF8Encode(RVU_RawUnicodeToWideString(s2));
              {$ENDIF}
              RVWrite(Stream, s2)
              end
            else begin
              item.SaveToHTML(Stream, Self, i, Items[i], Path, ImagesPrefix,
                imgSaveNo, Color, Options, False, Bullets);
              if item.StyleNo=rvsBreak then
                RVWriteLn(Stream,'');
            end;
            end
          else begin
            if item.StyleNo<0 then
              TextStyleNo := item.AssociatedTextStyleNo
            else
              TextStyleNo := GetActualStyle(item);
            if ShouldSaveTextToHTML(TextStyleNo) then begin // text or tab
              if HintTag2<>'' then
                RVWrite(Stream, '<span '+HintTag2+'>');
              if TextStyleNo<>0 then begin
                s3 := StringToHTMLString2(
                  RV_HTMLOpenFontTag(RVStyle.TextStyles[TextStyleNo],
                    RVStyle.TextStyles[0], True, Options),
                  Options, CP_ACP);
                RVWrite(Stream, s3);
              end;
              if item.StyleNo>=0 then begin
                s2 := GetTextForHTML(Path, i, False, Options);
                RVWrite(Stream, s2);
                end
              else begin
                s2 := '';
                if SaveItemToFile(Path, Self, i, rvsfHTML, rvsoUTF8 in Options, s2) then begin
                  {$IFNDEF RVDONOTUSEUNICODE}
                  if rvsoUTF8 in Options then
                    s2 := UTF8Encode(RVU_RawUnicodeToWideString(s2));
                  {$ENDIF}
                  RVWrite(Stream, s2)
                  end
                 else
                   item.SaveToHTML(Stream, Self, i, Items[i], Path, ImagesPrefix,
                     imgSaveNo, Color, Options, False, Bullets);
              end;
              if TextStyleNo<>0 then
                RVWrite(Stream,
                  RV_HTMLCloseFontTag(RVStyle.TextStyles[TextStyleNo],
                    RVStyle.TextStyles[0], True));
              if HintTag<>'' then
                RVWrite(Stream, '</span>');
            end;
          end;
          if ATag<>'' then
            RVWrite(Stream,'</a>');
        end;
        {$IFNDEF RVDONOTUSELISTS}
        if marker<>nil then begin
          if CloseMarkerDiv then
            RVWriteLn(Stream,'</li></div>')
          else
            RVWriteLn(Stream,'</li>');
          RVWrite(Stream, GetParaHTMLCode2(Self, ItemCount, False, False, Options, RVStyle));
          marker.HTMLOpenOrCloseTags(Stream, marker.Level, -1, RVStyle, False);
        end;
        {$ENDIF}
        if CloseDIV then begin
          RVWriteLn(Stream,GetCloseDIVTag(RVStyle.ParaStyles[GetItemPara(ItemCount-1)], CloseFont));
          RVWrite(Stream, GetParaHTMLCode2(Self, ItemCount, False, False, Options, RVStyle));
        end;
        if not (rvsoDefault0Style in Options) then
          RVWriteLn(Stream, CloseFont);
        SaveHTMLCheckpoint(Stream, NotAddedCP, cpno, RVDEFAULTCHECKPOINTPREFIX, False, Options);
        {$IFNDEF RVDONOTUSESEQ}
        SaveHTMLNotes(Path, ImagesPrefix, '', Stream, False, Options, Color,
          imgSaveNo, Bullets, TRVFootnoteItemInfo);
        SaveHTMLNotes(Path, ImagesPrefix, '', Stream, False, Options, Color,
          imgSaveNo, Bullets, TRVEndNoteItemInfo);
        {$ENDIF}
      finally
        if CreateBulletList then begin
          Bullets.Free;
        end;
      end;
    end;
    {...........................................................}
begin
  Result := False;
  if GetRVStyle = nil then exit;
  Result := True;
  try
    if not (rvsoMiddleOnly in Options) and
       not (rvsoLastOnly in Options) then
       SaveFirst(Stream, Path, Title);
    if not (rvsoFirstOnly in Options) and
       not (rvsoLastOnly in Options) then
       SaveMiddle(Stream, Path);
    if not (rvsoFirstOnly in Options) and
       not (rvsoMiddleOnly in Options) then
       SaveLast(Stream);
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveBackgroundToHTML(bmp: TBitmap; Color: TColor;
  const Path, ImagesPrefix: String; var imgSaveNo: Integer;
  SaveOptions: TRVSaveOptions): String;
var DoDefault: Boolean;
begin
  Result := '';
  HTMLSaveImage(Self, -1, Path, Color, Result, DoDefault);
  if DoDefault then
    Result := RV_GetHTMLPath(DoSavePicture(rvsfHTML, ImagesPrefix, Path,
      imgSaveNo, rvsoOverrideImages in SaveOptions, Color, bmp));
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveHTMLToStreamEx(Stream: TStream;
  const Path, Title, ImagesPrefix, ExtraStyles, ExternalCSS, CPPrefix: String;
  Options: TRVSaveOptions; Color: TColor; var CurrentFileColor: TColor;
  var imgSaveNo: Integer; LeftMargin, TopMargin, RightMargin, BottomMargin: Integer;
  Background: TRVBackground; Bullets: TRVList): Boolean;
    {......................................................}
    procedure WriteExtraHTMLCode(Area: TRVHTMLSaveArea; AddSpace: Boolean;
      RVStyle: TRVStyle);
    var s: String;
        s2: TRVRawByteString;
    begin
      s := GetExtraHTMLCode(Area, True);
      if s<>'' then begin
        s2 := StringToHTMLString(s, Options, RVStyle);
        if AddSpace then
          RVWrite(Stream,' '+s2)
        else
          RVWrite(Stream, s2);
      end;
    end;
    {......................................................}
    function GetBackgroundVPos(BStyle: TBackgroundStyle): TRVAnsiString;
    begin
      case BStyle of
        bsTopLeft, bsTopRight:
          Result := 'top';
        bsBottomLeft, bsBottomRight:
          Result := 'bottom';
        else
          Result := 'center';
      end;
    end;
    {......................................................}
    function GetBackgroundHPos(BStyle: TBackgroundStyle): TRVAnsiString;
    begin
      case BStyle of
        bsTopLeft, bsBottomLeft:
          Result := 'left';
        bsTopRight, bsBottomRight:
          Result := 'right';
        else
          Result := 'center';
      end;
    end;
    {......................................................}
    function GetBodyCSS(const Delim, Quote: TRVAnsiString): TRVRawByteString;
    var s: TRVRawByteString;
        s2: String;
    begin
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('margin: %dpx %dpx %dpx %dpx;',
        [TopMargin, RightMargin, BottomMargin, LeftMargin]);
      s := RV_GetHTMLRGBStr(Color, False);
      if s<>'' then
        Result := Result+Delim+'background-color: '+s+';';
      if (Background.Style<>bsNoBitmap) and
         (not Background.Bitmap.Empty) then begin
         s2 := SaveBackgroundToHTML(Background.Bitmap, Color, Path, ImagesPrefix,
           imgSaveNo, Options);
         if s2<>'' then begin
           s := StringToHTMLString(s2, Options, GetRVStyle);
           Result := Result + Delim+ {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('background-image: url(%s%s%s);', [Quote,s,Quote])+
             Delim + 'background-repeat: '+TRVAnsiString(rv_cssBkRepeat[Background.Style])+';' +
             Delim + 'background-attachment: '+TRVAnsiString(rv_cssBkAttachment[Background.Style])+';';
           if Background.Style in [bsStretched, bsCentered, bsTopLeft, bsTopRight,
             bsBottomLeft, bsBottomRight] then
               Result := Result + Delim + 'background-position: '+GetBackgroundVPos(Background.Style)+
                ' '+GetBackgroundHPos(Background.Style)+';';
         end;
      end;
    end;
    {......................................................}

    procedure SaveFirst(Stream: TStream; const Path, Title, ExtraStyles,
      ExternalCSS: String);
    var s: TRVRawByteString;
        CSSOptions: TRVSaveCSSOptions;
    begin
      if rvsoXHTML in Options then begin
        RVWrite(Stream, '<?xml version="1.0"');
        {$IFDEF RICHVIEWCBDEF3}
        if rvsoUTF8 in Options then
          s := 'UTF-8'
        else
          s := RV_CharSet2HTMLLang(GetRVStyle.TextStyles[0].CharSet);
        if s<>'' then
          RVWrite(Stream,{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' encoding="%s"',[s]));
        {$ENDIF}
        RVWriteLn(Stream, '?>');
        RVWriteLn(Stream, '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">');
        RVWriteLn(Stream, '<html xmlns="http://www.w3.org/1999/xhtml">');
        end
      else begin
        RVWriteLn(Stream,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">');
        RVWrite(Stream, '<html>');
      end;
      s := StringToHTMLString(Title, Options, GetRVStyle);
      RVWriteLn(Stream,'<head><title>'+s+'</title>');
      {$IFDEF RICHVIEWCBDEF3}
      if rvsoUTF8 in Options then
        s := 'UTF-8'
      else
        s := RV_CharSet2HTMLLang(GetRVStyle.TextStyles[0].CharSet);
      if s<>'' then
        RVWriteLn(Stream,
          {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<meta http-equiv="Content-Type" content="text/html; charset=%s"%s>',
            [s, RV_HTMLGetEndingSlash(Options)]));
      {$ENDIF}
      RVWriteLn(Stream,
        {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<meta http-equiv="Content-Style-Type" content="text/css"%s>',
          [RV_HTMLGetEndingSlash(Options)]));
      if not (rvsoInlineCSS in Options) or (ExtraStyles<>'') then begin
        RVWrite(Stream, '<style type="text/css">');
        if rvsoXHTML in Options then
          RVWriteLn(Stream,'')
        else
          RVWriteLn(Stream,'<!--');
        if not (rvsoInlineCSS in Options) then begin
          RVWriteLn(Stream, 'body {');
          RVWriteLn(Stream, '  '+GetBodyCSS(#13#10'  ', '"'));
          RVWriteLn(Stream, '}');
          if (ExternalCSS='') then begin
            CSSOptions := [];
            if (rvsoNoDefCSSStyle in Options) then
              Include(CSSOptions, rvcssNoDefCSSStyle);
            if (rvsoUTF8 in Options) then
              Include(CSSOptions, rvcssUTF8);
            if (rvsoDefault0Style in Options) then
              Include(CSSOptions, rvcssDefault0Style);
            GetRVStyle.SaveCSSToStream(Stream, CSSOptions);
          end;
        end;
        if ExtraStyles<>'' then
          RVWriteLn(Stream, StringToHTMLString(ExtraStyles, Options, GetRVStyle));
        if not (rvsoXHTML in Options) then
          RVWrite(Stream,'-->');
        RVWriteLn(Stream,'</style>');
      end;
      if (ExternalCSS<>'') and not (rvsoInlineCSS in Options) then
        RVWriteLn(Stream, '<link type="text/css" href="'+
          StringToHTMLString(ExternalCSS, Options, GetRVStyle)+
          '" rel="stylesheet"'+RV_HTMLGetEndingSlash(Options)+'>');
      WriteExtraHTMLCode(rv_thms_Head, False, GetRVStyle);
      RVWriteLn(Stream,'</head>');
      RVWrite(Stream,'<body');
      if rvsoInlineCSS in Options then
        RVWrite(Stream,' style="'+GetBodyCSS(' ', '''')+'"');
      WriteExtraHTMLCode(rv_thms_BodyAttribute, True, GetRVStyle);
      RVWriteLn(Stream,'>');
      WriteExtraHTMLCode(rv_thms_Body, False, GetRVStyle);
    end;
    {......................................................}
    procedure SaveLast(Stream: TStream);
    begin
      WriteExtraHTMLCode(rv_thms_End, False, GetRVStyle);
      RVWriteLn(Stream,'</body></html>');
    end;
    {......................................................}
    function GetTextCSS(TextStyleNo: Integer; RVStyle: TRVStyle): TRVRawByteString;
    var MemoryStream: TStream;
    begin
      if (rvsoInlineCSS in Options) then begin
        MemoryStream := TMemoryStream.Create;
        try
          RVStyle.TextStyles[TextStyleNo].SaveCSSToStream(MemoryStream,
            nil, False, rvsoUTF8 in Options);
          SetLength(Result, MemoryStream.Size);
          MemoryStream.Position := 0;
          MemoryStream.ReadBuffer(PRVAnsiChar(Result)^, Length(Result));
        finally
          MemoryStream.Free;
        end;
        Result := 'style="'+Result+'"';
        end
      else
        Result := 'class='+RV_HTMLGetStrAttrVal('rvts'+RVIntToStr(TextStyleNo), Options);
    end;
    {......................................................}
    function GetClearFloatingCSSValue(item: TCustomRVItemInfo;
      OnlyValue, SpaceBefore: Boolean): TRVAnsiString;
    begin
      if item.ClearLeft then
        if item.ClearRight then
          Result := 'clear: both;'
        else
          Result := 'clear: left;'
      else
        if item.ClearRight then
          Result := 'clear: right;'
        else
          Result := '';
      if (Result<>'') and not OnlyValue then
          Result := 'style="'+Result+'"';
      if (Result<>'') and SpaceBefore then
        Result := ' '+Result;
    end;
    {......................................................}
    function GetPageBreakAndClearFloatingCSS(item: TCustomRVItemInfo;
      OnlyValue, SpaceBefore: Boolean): TRVAnsiString;
    begin
      if item.PageBreakBefore then
        Result := 'page-break-before: always;'
      else
        Result := '';
      if item.ClearLeft then
        RV_AddStrA(Result, GetClearFloatingCSSValue(item, True, False));
      if (Result<>'') and not OnlyValue then
          Result := 'style="'+Result+'"';
      if (Result<>'') and SpaceBefore then
        Result := ' '+Result;
    end;
    {......................................................}
    function GetParaCSSValue(item: TCustomRVItemInfo; RVStyle: TRVStyle;
      IgnoreLeftIndents: Boolean): TRVAnsiString;
    var MemoryStream: TStream;
    begin
      if (rvsoInlineCSS in Options) then begin
        MemoryStream := TMemoryStream.Create;
        try
          RVStyle.ParaStyles[item.ParaNo].SaveCSSToStream(MemoryStream, nil,
            False, False, IgnoreLeftIndents);
          SetLength(Result, MemoryStream.Size);
          MemoryStream.Position := 0;
          MemoryStream.ReadBuffer(PRVAnsiChar(Result)^, Length(Result));
        finally
          MemoryStream.Free;
        end;
        end
      else
        Result := '';
      Result := Result+GetPageBreakAndClearFloatingCSS(item, True, Result<>'')
    end;
    {......................................................}
    function GetParaCSS(item: TCustomRVItemInfo; RVStyle: TRVStyle;
      IgnoreLeftIndents: Boolean): TRVAnsiString;
    begin
      if (rvsoInlineCSS in Options) then
        Result := 'style="'+GetParaCSSValue(item, RVStyle, IgnoreLeftIndents)+'"'
      else if (Item.ParaNo>0) or (rvsoNoDefCSSStyle in Options) then
        Result := 'class='+RV_HTMLGetStrAttrVal('rvps'+RVIntToStr(item.ParaNo), Options)+
         GetPageBreakAndClearFloatingCSS(item, False, True)
      else
        Result := GetPageBreakAndClearFloatingCSS(item, False, False);
    end;
    {......................................................}
    // Workaround for Mozilla / Firefox
    function GetTableDiv(item: TCustomRVItemInfo; RVStyle: TRVStyle): TRVAnsiString;
    begin
      Result := '';
      if rvsoXHTML in Options then
        exit;
      case RVStyle.ParaStyles[item.ParaNo].Alignment of
        rvaRight:
          Result := 'right';
        rvaCenter:
          Result := 'center';
      end;
      if Result<>'' then
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<div align=%s>', [Result]);
    end;
    {......................................................}
    function GetItemTextStyleNo(ItemNo: Integer): Integer;
    var item: TCustomRVItemInfo;
    begin
      item := GetItem(ItemNo);
      if item.StyleNo>=0 then
        Result := GetActualStyle(item)
      else begin
        Result := item.AssociatedTextStyleNo;
        if Result<0 then
          Result := item.StyleNo;
      end;
    end;
    {......................................................}
    function GetParagraphTag(ParaNo: Integer): TRVAnsiString;
    begin
      if GetRVStyle.ParaStyles[ParaNo].IsHeading(6) then
        Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('h%d',
          [GetRVStyle.ParaStyles[ParaNo].OutlineLevel])
      else if RichViewSaveDivInHTMLEx then
        Result := 'div'
      else
        Result := 'p';
    end;
    {......................................................}
    procedure SaveMiddle(Stream: TStream; const Path: String; CPPrefix: String);
    var i: Integer;
        item: TCustomRVItemInfo;
        s, TableDiv: TRVRawByteString;
        HintAttr, ATag: String;
        cpno, OpenedPara, TextStyleNo: Integer;
        CreateBulletList, Use0StyleAsDef, DIVOpened: Boolean;
        RVStyle: TRVStyle;
        {$IFNDEF RVDONOTUSELISTS}
        s2: String;
        marker: TRVMarkerItemInfo;
        {$ENDIF}
    begin
      DoBeforeSaving;
      if CPPrefix='' then
        CPPrefix := RVDEFAULTCHECKPOINTPREFIX;
      RVStyle := GetRVStyle;
      cpno    := 0;
      OpenedPara := -1;
      DIVOpened := False;
      TableDiv := '';
      {$IFNDEF RVDONOTUSELISTS}
      marker := nil;
      {$ENDIF}
      CreateBulletList := Bullets=nil;
      if CreateBulletList then
        Bullets := TRVList.Create;
      try
        Use0StyleAsDef := (RVStyle.TextStyles.Count>=1) and
          not RVStyle.TextStyles[0].Jump and
          (RVStyle.TextStyles[0].BackColor=clNone) and
          not (rvsoNoDefCSSStyle in Options);
        for i:=0 to Items.Count-1 do begin
          item := GetItem(i);
          if (not item.SameAsPrev) then begin
            if (i>0) and ((OpenedPara<0) {$IFNDEF RVDONOTUSELISTS}and (marker=nil){$ENDIF}) {or
               item.BR} then
              RVWriteLn(Stream,'');
            if item.BR then
              RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<br%s%s>',
                [GetClearFloatingCSSValue(item, False, True), RV_HTMLGetEndingSlash(Options)]))
            else begin
              {$IFNDEF RVDONOTUSELISTS}
              if marker<>nil then begin
                RVWriteLn(Stream,'</li>');
                RVWrite(Stream, GetParaHTMLCode2(Self, i, False, True, Options, RVStyle));
                end
              else if (OpenedPara>=0) then
              {$ENDIF}
              begin
                if DIVOpened then begin
                  if TableDiv<>'' then
                    RVWrite(Stream,'</div>');
                  RVWriteLn(Stream,'</div>');
                  TableDiv := '';
                  end
                else
                  RVWriteLn(Stream,
                    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('</%s>',
                     [GetParagraphTag(OpenedPara)]));
                DIVOpened := False;
                RVWrite(Stream, GetParaHTMLCode2(Self, i, False, True, Options, RVStyle));
              end;
              CurrentFileColor := RVStyle.ParaStyles[item.ParaNo].Background.Color;
              if CurrentFileColor=clNone then
                CurrentFileColor := Color;
              case item.StyleNo of
                rvsBreak:
                  OpenedPara := -1;
                {$IFNDEF RVDONOTUSELISTS}
                rvsListMarker:
                  begin
                    if TRVMarkerItemInfo(item).GetLevelInfo(RVStyle)<>nil then begin
                      if rvsoMarkersAsText in Options then begin
                        RVWrite(Stream, GetParaHTMLCode2(Self, i, True, True, Options, RVStyle));
                        if ((item.ParaNo=0) and not (rvsoNoDefCSSStyle in Options)) or
                           (rvsoInlineCSS in Options) then
                          RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<%s style="%s %s">',
                            [GetParagraphTag(item.ParaNo), GetParaCSSValue(item, RVStyle, True),
                             TRVMarkerItemInfo(item).GetLevelInfo(RVStyle).GetIndentCSSForTextVersion(RVStyle)]))
                        else
                          RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<%s %s style="%s">',
                            [GetParagraphTag(item.ParaNo), GetParaCSS(item, RVStyle, True),
                             TRVMarkerItemInfo(item).GetLevelInfo(RVStyle).GetIndentCSSForTextVersion(RVStyle)]));
                        OpenedPara := item.ParaNo;
                        end
                      else begin
                        TRVMarkerItemInfo(item).SaveHTMLSpecial(Stream, marker, RVStyle, True);
                        RVWrite(Stream, GetParaHTMLCode2(Self, i, True, True, Options, RVStyle));
                        marker := TRVMarkerItemInfo(item);
                        if (marker.GetLevelInfo(RVStyle).HasNumbering) and
                          not (rvsoXHTML in Options) then
                          RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
                            Format('<li value=%s',[RV_HTMLGetIntAttrVal(marker.Counter, Options)]))
                        else
                          RVWrite(Stream,'<li');
                        s := GetParaCSS(item, RVStyle, True);
                        if s<>'' then
                          RVWrite(Stream, ' '+s);
                        s2 := marker.GetLICSS(Self, i, Path, ImagesPrefix,
                          imgSaveNo, CurrentFileColor, Options, Bullets);
                        RVWrite(Stream, StringToHTMLString(s2, Options, RVStyle));
                        RVWrite(Stream,'>');
                        OpenedPara := -1;
                      end
                      end
                    else begin
                      {$IFNDEF RVDONOTUSELISTS}
                      if marker<>nil then begin
                        marker.HTMLOpenOrCloseTags(Stream, marker.Level, -1, RVStyle, True);
                        marker := nil;
                      end;
                      {$ENDIF}
                      RVWrite(Stream, GetParaHTMLCode2(Self, i, True, True, Options, RVStyle));
                      s := GetParaCSS(item, RVStyle, False);
                      if s<>'' then
                        s := ' '+s;
                      RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<%s%s>',
                        [GetParagraphTag(item.ParaNo), s]));
                      OpenedPara := item.ParaNo;
                    end;
                  end;
                {$ENDIF}
                else
                  begin
                    {$IFNDEF RVDONOTUSELISTS}
                    if marker<>nil then begin
                      marker.HTMLOpenOrCloseTags(Stream, marker.Level, -1, RVStyle, True);
                      marker := nil;
                    end;
                    {$ENDIF}
                    RVWrite(Stream, GetParaHTMLCode2(Self, i, True, True, Options, RVStyle));
                    s := GetParaCSS(item, RVStyle, False);
                    if s<>'' then
                      s := ' '+s;
                    TableDiv := '';
                    if item.GetBoolValue(rvbpNoHTML_P) then begin
                      RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<div%s>',[s]));
                      TableDiv := GetTableDiv(item, RVStyle);
                      RVWrite(Stream, TableDiv);
                      DIVOpened := True;
                      end
                    else
                      RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<%s%s>',
                        [GetParagraphTag(item.ParaNo), s]));
                    OpenedPara := item.ParaNo;
                  end;
              end
            end;
          end;
          SaveHTMLCheckpoint(Stream, item.Checkpoint, cpno, CPPrefix, False, Options);
          if (item.StyleNo<0) and (item.AssociatedTextStyleNo<0) then begin
            ATag := '';
            if item.GetBoolValueEx(rvbpJump, RVStyle) then begin
              ATag := GetHTMLATag(i, '');
              if ATag<>'' then
                RVWrite(Stream, StringToHTMLString(ATag, Options, RVStyle));
            end;
            s := '';
            if SaveItemToFile(Path, Self, i, rvsfHTML, rvsoUTF8 in Options, s) then begin
              {$IFNDEF RVDONOTUSEUNICODE}
              if rvsoUTF8 in Options then
                s := UTF8Encode(RVU_RawUnicodeToWideString(s));
              {$ENDIF}
              RVWrite(Stream, s);
              end
            else
              item.SaveToHTML(Stream, Self, i, Items[i], Path, ImagesPrefix,
                imgSaveNo, CurrentFileColor, Options, True, Bullets);
            if item.GetBoolValueEx(rvbpJump, RVStyle) then begin
              if ATag<>'' then
                RVWrite(Stream, '</a>');
            end;
            end
          else begin
            if RVStyle.ParaStyles[item.ParaNo].IsHeading(6) then
              RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<span %s>',
                [GetTextCSS(0, RVStyle)]));
            TextStyleNo := GetItemTextStyleNo(i);
            if ShouldSaveTextToHTML(TextStyleNo) then begin
              ATag := '';
              if item.GetBoolValueEx(rvbpJump, RVStyle) then
                ATag := GetHTMLATag(i, GetTextCSS(TextStyleNo, RVStyle));
              if ATag<>'' then
                RVWrite(Stream, StringToHTMLString(ATag, Options, RVStyle))
              else begin
                if (TextStyleNo<>0) or not Use0StyleAsDef or (rvsoInlineCSS in Options) then
                  RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<span %s>',
                    [GetTextCSS(TextStyleNo, RVStyle)]));
              end;
              HintAttr := '';
              if ATag='' then begin
                item.GetExtraStrProperty(rvespHint, HintAttr);
                HintAttr := RV_GetHintStr(rvsfHTML, HintAttr);
                if HintAttr<>'' then
                  RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<span %s>',
                    [StringToHTMLString(HintAttr, Options, RVStyle)]));
              end;
              if item.StyleNo>=0 then begin
                s := GetTextForHTML(Path, i, True, Options);
                RVWrite(Stream, s);
                end
              else begin
                s := '';
                if SaveItemToFile(Path, Self, i, rvsfHTML, rvsoUTF8 in Options, s) then begin
                  {$IFNDEF RVDONOTUSEUNICODE}
                  if rvsoUTF8 in Options then
                    s := UTF8Encode(RVU_RawUnicodeToWideString(s));
                  {$ENDIF}
                  RVWrite(Stream, s);
                  end
                else
                  item.SaveToHTML(Stream, Self, i, Items[i], Path, ImagesPrefix,
                    imgSaveNo, CurrentFileColor, Options, True, Bullets);
              end;
              if HintAttr<>'' then
                RVWrite(Stream,'</span>');
              if ATag<>'' then
                RVWrite(Stream,'</a>')
              else if (TextStyleNo<>0) or not Use0StyleAsDef or (rvsoInlineCSS in Options) then
                RVWrite(Stream, '</span>');
              if RVStyle.ParaStyles[item.ParaNo].IsHeading(6) then
                RVWrite(Stream, '</span>');
            end;
          end;
        end;
        {$IFNDEF RVDONOTUSELISTS}
        if marker<>nil then begin
          RVWriteLn(Stream,'</li>');
          RVWrite(Stream, GetParaHTMLCode2(Self, ItemCount, False, True, Options, RVStyle));
          marker.HTMLOpenOrCloseTags(Stream, marker.Level, -1, RVStyle, True);
        end;
        {$ENDIF}
        if (OpenedPara<>-1) then begin
          if DIVOpened then begin
            if TableDiv<>'' then
              RVWrite(Stream,'</div>');
            RVWriteLn(Stream,'</div>')
            end
          else
            RVWriteLn(Stream,
              {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('</%s>',
                [GetParagraphTag(OpenedPara)]));
          RVWrite(Stream, GetParaHTMLCode2(Self, ItemCount, False, True, Options, RVStyle));
        end;
        SaveHTMLCheckpoint(Stream, NotAddedCP, cpno, CPPrefix, False, Options);
        {$IFNDEF RVDONOTUSESEQ}
        SaveHTMLNotes(Path, ImagesPrefix, '', Stream, True, Options, Color,
          imgSaveNo, Bullets, TRVFootnoteItemInfo);
        SaveHTMLNotes(Path, ImagesPrefix, '', Stream, True, Options, Color,
          imgSaveNo, Bullets, TRVEndNoteItemInfo);
        {$ENDIF}
      finally
        if CreateBulletList then begin
          Bullets.Free;
        end;
      end;
    end;
    {......................................................}
begin
  Result := False;
  if GetRVStyle = nil then exit;
  Result := True;
  CurrentFileColor := Color;
  try
    if not (rvsoMiddleOnly in Options) and
       not (rvsoLastOnly in Options) then
       SaveFirst(Stream, Path, Title, ExtraStyles, ExternalCSS);
    if not (rvsoFirstOnly in Options) and
       not (rvsoLastOnly in Options) then
       SaveMiddle(Stream, Path, CPPrefix);
    if not (rvsoFirstOnly in Options) and
       not (rvsoMiddleOnly in Options) then
       SaveLast(Stream);
  except
    Result := False;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.CheckItemClass(ItemNo: Integer; RequiredClass: TCustomRVItemInfoClass);
begin
  if not (GetItem(ItemNo) is RequiredClass) then
    raise ERichViewError.Create(errRVTypesMismatch);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindControlItemNo(actrl: TControl): Integer;
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    if GetItem(i).OwnsControl(actrl) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.RemoveCheckpoint(ItemNo: Integer): Boolean;
var OldCP: TRVCPInfo;
begin
  with GetItem(ItemNo) do begin
    OldCP := Checkpoint;
    FreeCheckpoint(Checkpoint, True, True);
  end;
  Result := OldCP<>nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetGrouped(ItemNo: Integer; Grouped: Boolean);
begin
  with GetItem(ItemNo) do
  if Grouped then
    Include(ItemOptions, rvioGroupWithNext)
  else
    Exclude(ItemOptions, rvioGroupWithNext)
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetBreakInfo(ItemNo: Integer; AWidth: TRVStyleLength;
  AStyle: TRVBreakStyle; AColor: TColor; ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVBreakItemInfo);
  with TRVBreakItemInfo(GetItem(ItemNo)) do begin
    Color     := AColor;
    LineWidth := AWidth;
    Style     := AStyle;
  end;
  SetItemTag(ItemNo, ATag);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetBulletInfo(ItemNo: Integer; const AName: TRVAnsiString;
  AImageIndex: Integer; AImageList: TCustomImageList; ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVBulletItemInfo);
  with TRVBulletItemInfo(GetItem(ItemNo)) do
    ImageIndex := AImageIndex;
  SetItemTag(ItemNo, ATag);
  Items[ItemNo] := AName;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SetControlInfo(ItemNo: Integer; const AName: TRVAnsiString;
  AVAlign: TRVVAlign; ATag: Integer): Boolean;
begin
  CheckItemClass(ItemNo, TRVControlItemInfo);
  with TRVControlItemInfo(GetItem(ItemNo))  do begin
    Result := (VAlign<>AVAlign);
    VAlign := AVAlign;
  end;
  SetItemTag(ItemNo, ATag);
  Items[ItemNo] := AName;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetHotspotInfo(ItemNo: Integer;
  const AName: TRVAnsiString; AImageIndex, AHotImageIndex: Integer;
  AImageList: TCustomImageList; ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVHotspotItemInfo);
  with TRVHotspotItemInfo(GetItem(ItemNo)) do begin
    ImageIndex    := AImageIndex;
    HotImageIndex := AHotImageIndex;
  end;
  SetItemTag(ItemNo, ATag);
  Items[ItemNo] := AName;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetCheckpointInfo(ItemNo, ATag: Integer;
  const AName: String; ARaiseEvent: Boolean);
begin
  with GetItem(ItemNo) do begin
    if Checkpoint=nil then
      InsertCheckpoint(ItemNo, ATag, AName, ARaiseEvent)
    else begin
      if rvoTagsArePChars in Options then
        StrDispose(PChar(Checkpoint.Tag));
      Checkpoint.Tag        := ATag;
      Checkpoint.Name       := AName;
      Checkpoint.RaiseEvent := ARaiseEvent;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemTag(ItemNo, ATag: Integer);
begin
  with GetItem(ItemNo) do begin
    if Tag=ATag then exit;
    if rvoTagsArePChars in Options then
      StrDispose(PChar(Tag));
    Tag := ATag;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemVAlign(ItemNo: Integer; AVAlign: TRVVAlign);
var Item: TCustomRVItemInfo;
begin
  Item := GetItem(ItemNo);
  if {$IFNDEF RVDONOTUSETABS}(item is TRVTabItemInfo) or {$ENDIF}
     {$IFNDEF RVDONOTUSELISTS}(item is TRVMarkerItemInfo) or{$ENDIF}
    not (item is TRVRectItemInfo) then
    raise ERichViewError.Create(errRVTypesMismatch);
  TRVRectItemInfo(Item).VAlign := AVAlign
end;
{------------------------------------------------------------------------------}
{ Sets item's property of integer type.
  ItemNo - index of item. Prop identifies the property. Value - new property
  value.
  Returns true is this item type has this property                             }
function TCustomRVData.SetItemExtraIntProperty(ItemNo: Integer;
  Prop: TRVExtraItemProperty; Value: Integer): Boolean;
begin
  Result := GetItem(ItemNo).SetExtraIntProperty(Prop, Value);
  {$IFNDEF RVDONOTUSEANIMATION}
  if Result and (Prop in [rvepAnimationInterval, rvepImageWidth, rvepImageHeight]) then
    GetItem(ItemNo).UpdateAnimator(Self);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Gets item's property of integer type.
  ItemNo - index of item. Prop identifies the property. Value receives a
  property value.
  Returns true is this item type has this property                             }
function TCustomRVData.GetItemExtraIntProperty(ItemNo: Integer;
  Prop: TRVExtraItemProperty; var Value: Integer): Boolean;
begin
  Result := GetItem(ItemNo).GetExtraIntProperty(Prop, Value);
end;
{------------------------------------------------------------------------------}
{ Sets item's property of string type.
  ItemNo - index of item. Prop identifies the property. Value - new property
  value.
  Returns true is this item type has this property                             }
function TCustomRVData.SetItemExtraStrProperty(ItemNo: Integer;
  Prop: TRVExtraItemStrProperty; const Value: String): Boolean;
begin
  Result := GetItem(ItemNo).SetExtraStrProperty(Prop, Value);
end;
{------------------------------------------------------------------------------}
{ Gets item's property of string type.
  ItemNo - index of item. Prop identifies the property. Value receives a
  property value.
  Returns true is this item type has this property                             }
function TCustomRVData.GetItemExtraStrProperty(ItemNo: Integer;
  Prop: TRVExtraItemStrProperty; var Value: String): Boolean;
begin
  Result := GetItem(ItemNo).GetExtraStrProperty(Prop, Value);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SetPictureInfo(ItemNo: Integer; const AName: TRVAnsiString;
  Agr: TGraphic; AVAlign: TRVVAlign; ATag: Integer): Boolean;
begin
  CheckItemClass(ItemNo, TRVGraphicItemInfo);
  with TRVGraphicItemInfo(GetItem(ItemNo)) do begin
    Result := (Agr.Width<>Image.Width) or
              (Agr.Height<>Image.Height) or
              (VAlign<>AVAlign);
    if Agr<>Image then begin
      if not Shared then
        Image.Free;
      Image := Agr;
      {$IFNDEF RVDONOTUSEANIMATION}
      UpdateAnimator(Self);
      {$ENDIF}
    end;
    VAlign := AVAlign;
  end;
  SetItemTag(ItemNo, ATag);
  Items[ItemNo] := AName;
  GetItem(ItemNo).UpdatePaletteInfo(GetDoInPaletteMode, True, GetRVPalette,
    GetRVLogPalette);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemStyle(ItemNo: Integer): Integer;
begin
  Result := GetActualStyle(GetItem(ItemNo));
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetActualStyle(Item: TCustomRVItemInfo): Integer;
begin
  Result := Item.StyleNo;
  if Result=rvsDefStyle then begin
    if GetRVStyle.ParaStyles[Item.ParaNo].DefStyleNo>=0 then
      Result := GetRVStyle.ParaStyles[Item.ParaNo].DefStyleNo
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetActualStyle2(StyleNo, ParaNo: Integer): Integer;
begin
  Result := StyleNo;
  if Result=rvsDefStyle then begin
    if GetRVStyle.ParaStyles[ParaNo].DefStyleNo>=0 then
      Result := GetRVStyle.ParaStyles[ParaNo].DefStyleNo
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetBreakInfo(ItemNo: Integer; var AWidth: TRVStyleLength;
  var AStyle: TRVBreakStyle; var AColor: TColor; var ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVBreakItemInfo);
  with TRVBreakItemInfo(GetItem(ItemNo)) do begin
    AWidth := LineWidth;
    AStyle := Style;
    AColor := Color;
    ATag := Tag;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetBulletInfo(ItemNo: Integer; var AName: TRVAnsiString;
  var AImageIndex: Integer; var AImageList: TCustomImageList; var ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVBulletItemInfo);
  with GetItem(ItemNo) as TRVBulletItemInfo do begin
    AImageIndex := ImageIndex;
    AImageList := ImageList;
    ATag := Tag;
  end;
  AName := Items[ItemNo];
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetControlInfo(ItemNo: Integer; var AName: TRVAnsiString;
  var Actrl: TControl; var AVAlign: TRVVAlign; var ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVControlItemInfo);
  with TRVControlItemInfo(GetItem(ItemNo)) do begin
    Actrl := Control;
    ATag := Tag;
    AVAlign := VAlign;
  end;
  AName := Items[ItemNo];
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetHotspotInfo(ItemNo: Integer; var AName: TRVAnsiString;
  var AImageIndex, AHotImageIndex: Integer; var AImageList: TCustomImageList;
  var ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVHotspotItemInfo);
  with TRVHotspotItemInfo(GetItem(ItemNo)) do begin
    AImageIndex := ImageIndex;
    AHotImageIndex := HotImageIndex;
    AImageList := ImageList;
    ATag := Tag;
  end;
  AName := Items[ItemNo];
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemTag(ItemNo: Integer): Integer;
begin
  Result := GetItem(ItemNo).Tag;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemVAlign(ItemNo: Integer): TRVVAlign;
var Item: TCustomRVItemInfo;
begin
  Item := GetItem(ItemNo);
  if {$IFNDEF RVDONOTUSETABS}(item is TRVTabItemInfo) or {$ENDIF}
     {$IFNDEF RVDONOTUSELISTS}(item is TRVMarkerItemInfo) or{$ENDIF} 
    not (item is TRVRectItemInfo) then
    raise ERichViewError.Create(errRVTypesMismatch);
  Result := TRVRectItemInfo(Item).VAlign;  
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetPictureInfo(ItemNo: Integer; var AName: TRVAnsiString;
  var Agr: TGraphic; var AVAlign: TRVVAlign; var ATag: Integer);
begin
  CheckItemClass(ItemNo, TRVGraphicItemInfo);
  with GetItem(ItemNo) as TRVGraphicItemInfo do begin
    Agr := Image;
    ATag := Tag;
    AVAlign := VAlign;
  end;
  AName := Items[ItemNo];
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetTextInfo(ItemNo: Integer; var AText: String;
  var ATag: Integer);
begin
  if (GetItemStyle(ItemNo)<0) then
    raise ERichViewError.Create(errRVTypesMismatch);
  ATag  := GetItem(ItemNo).Tag;
  AText := GetItemText(ItemNo);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsFromNewLine(ItemNo: Integer): Boolean;
begin
  Result := not GetItem(ItemNo).SameAsPrev;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemPara(ItemNo: Integer): Integer;
begin
  Result := GetItem(ItemNo).ParaNo;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsParaStart(ItemNo: Integer): Boolean;
begin
  Result := not GetItem(ItemNo).SameAsPrev and
            not GetItem(ItemNo).BR;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.CheckItemIndex(i: Integer);
begin
  if (i<0) or (i>=Items.Count) then
    raise ERichViewError.Create(errRVItemRangeError);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetPageBreaksBeforeItems(Index: Integer): Boolean;
begin
  CheckItemIndex(Index);
  Result := GetItem(Index).PageBreakBefore;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetPageBreaksBeforeItems(Index: Integer;
  Value: Boolean);
begin
  CheckItemIndex(Index);
  {$IFNDEF RVDONOTUSELISTS}
  if (Index>0) and (GetItemStyle(Index-1)=rvsListMarker) then
    dec(Index);
  {$ENDIF}
  GetItem(Index).PageBreakBefore := Value;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetClearLeft(Index: Integer): Boolean;
begin
  CheckItemIndex(Index);
  Result := GetItem(Index).ClearLeft;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetClearRight(Index: Integer): Boolean;
begin
  CheckItemIndex(Index);
  Result := GetItem(Index).ClearRight;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetClearLeft(Index: Integer; const Value: Boolean);
begin
  CheckItemIndex(Index);
  GetItem(Index).ClearLeft := Value;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetClearRight(Index: Integer;
  const Value: Boolean);
begin
  CheckItemIndex(Index);
  GetItem(Index).ClearRight := Value;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindCheckpointByName(
  const Name: String): TCheckpointData;
var cp: TRVCPInfo;
begin
  Result := nil;
  cp := FirstCP;
  while cp<>nil do begin
    if cp.Name=Name then begin
      Result := cp;
      exit;
    end;
    cp := cp.Next;
  end;
  if (NotAddedCP<>nil) and (NotAddedCP.Name=Name) then
    Result := NotAddedCP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindCheckpointByTag(Tag: Integer): TCheckpointData;
var cp: TRVCPInfo;
begin
  Result := nil;
  cp := FirstCP;
  while cp<>nil do begin
    if RV_CompareTags(cp.Tag,Tag, rvoTagsArePChars in Options) then begin
      Result := cp;
      exit;
    end;
    cp := cp.Next;
  end;
  if (NotAddedCP<>nil) and RV_CompareTags(NotAddedCP.Tag,Tag,rvoTagsArePChars in Options) then
    Result := NotAddedCP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetCheckpointByNo(No: Integer): TCheckpointData;
var i: Integer;
    cp: TRVCPInfo;
begin
  if (no<0) or (no>=CPCount) then begin
    raise ERichViewError.Create(SysUtils.Format(errRVNoSuchCP,[no]));
    exit;
  end;
  if (no=CPCount-1) and (NotAddedCP<>nil) then
    Result := NotAddedCP
  else begin
    cp := FirstCP;
    for i := 1 to no do begin
      if cp = nil then break;
      cp := cp.Next;
    end;
    //Assert(cp<>nil, 'Can''t find checkpoint');
    Result := cp;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetFirstCheckpoint: TCheckpointData;
begin
  Result := FirstCP;
  if Result = nil then
    Result := NotAddedCP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetLastCheckpoint: TCheckpointData;
begin
  Result := NotAddedCP;
  if Result = nil then
    Result := LastCP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetNextCheckpoint(CheckpointData: TCheckpointData): TCheckpointData;
begin
  Result := nil;
  if CheckpointData=nil then
    raise ERichViewError.Create(errRVNil);
  if CheckpointData=NotAddedCP then exit;
  Result := TRVCPInfo(CheckpointData).Next;
  if Result = nil then
    Result := NotAddedCP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetPrevCheckpoint(CheckpointData: TCheckpointData): TCheckpointData;
begin
  if CheckpointData=nil then
    raise ERichViewError.Create(errRVNil);
  if CheckpointData=NotAddedCP then begin
    Result := LastCP;
    exit;
  end;
  Result := TRVCPInfo(CheckpointData).Prev;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemCheckpoint(ItemNo: Integer): TCheckpointData;
begin
  Result := GetItem(ItemNo).Checkpoint;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetCheckpointItemNo(CheckpointData: TCheckpointData): Integer;
begin
  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNil);

  if CheckpointData=NotAddedCP then
    Result := -1
  else begin
    Result := Items.IndexOfObject(TRVCPInfo(CheckpointData).ItemInfo);
    if Result=-1 then
      raise ERichViewError.Create(errRVNoSuchCP2);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetCheckpointNo(CheckpointData: TCheckpointData): Integer;
var cp: TRVCPInfo;
begin
  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNil);

  cp := FirstCP;
  Result := 0;

  while cp<>nil do begin
    if cp=CheckpointData then exit;
    cp := cp.Next;
    inc(Result);
  end;

  if CheckpointData=NotAddedCP then exit;

  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNoSuchCP2);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetCheckpointInfo(CheckpointData: TCheckpointData;
  var Tag: Integer; var Name: String; var RaiseEvent: Boolean);
begin
  if CheckpointData = nil then
    raise ERichViewError.Create(errRVNil);
  Name       := TRVCPInfo(CheckpointData).Name;
  Tag        := TRVCPInfo(CheckpointData).Tag;
  RaiseEvent := TRVCPInfo(CheckpointData).RaiseEvent;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.NormalizeParas(StartItemNo: Integer);
var i,ParaNo: Integer;
begin
  if Items.Count=0 then exit;
  i := StartItemNo;
  if i>=Items.Count then
    i := Items.Count-1;
  while (i>0) and not GetItem(i).CanBeBorderStart do
    dec(i);
  ParaNo := GetItemPara(i);
  inc(i);
  while (i<Items.Count) and not GetItem(i).CanBeBorderStart do begin
    GetItem(i).ParaNo := ParaNo;
    inc(i);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindCPBeforeItem(ItemNo: Integer): TRVCPInfo;
begin
  UpdateCPItemNo;
  if (FirstCP=nil) or
     (FirstCP.ItemNo>=ItemNo) then begin
    Result := nil; // no CP before
    exit;
  end;
  Result := FirstCP;
  while Result.Next<>nil do begin
    if Result.Next.ItemNo>=ItemNo then exit;
    Result := Result.Next;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetExtraDocuments: TStrings;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.RVFGetLimits(SaveScope: TRVFSaveScope; var StartItem,
  EndItem, StartOffs, EndOffs: Integer; var StartPart, EndPart: TRVMultiDrawItemPart;
  var SelectedItem: TCustomRVItemInfo);
begin
  StartItem := 0;
  EndItem   := Items.Count-1;
  if StartItem<Items.Count then begin
    StartOffs := GetOffsBeforeItem(StartItem);
    if EndItem>=0 then
      EndOffs   := GetOffsAfterItem(EndItem);
  end;
  StartPart := nil;
  EndPart   := nil;
  SelectedItem := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVFOptions: TRVFOptions;
begin
  Result := GetRootData.GetRVFOptions;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetExtraRTFCode(Area: TRVRTFSaveArea; Obj: TObject;
  Index1, Index2: Integer; InStyleSheet: Boolean): TRVAnsiString;
begin
  Result := GetAbsoluteRootData.GetExtraRTFCode(Area, Obj, Index1, Index2, InStyleSheet);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetExtraHTMLCode(Area: TRVHTMLSaveArea; CSSVersion: Boolean): String;
begin
  Result := GetAbsoluteRootData.GetExtraHTMLCode(Area, CSSVersion);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsAssignedOnProgress: Boolean;
begin
 Result := GetAbsoluteRootData.IsAssignedOnProgress;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoProgress(Operation: TRVLongOperation;
  Stage: TRVProgressStage; PercentDone: Byte);
begin
  GetAbsoluteRootData.DoProgress(Operation, Stage, PercentDone);
end;  
{------------------------------------------------------------------------------}
function TCustomRVData.GetParaHTMLCode(RVData: TCustomRVData; ItemNo: Integer;
  ParaStart, CSSVersion: Boolean): String;
begin
  Result := GetAbsoluteRootData.GetParaHTMLCode(RVData, ItemNo, ParaStart,
    CSSVersion);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetParaHTMLCode2(RVData: TCustomRVData; ItemNo: Integer;
  ParaStart, CSSVersion: Boolean; Options: TRVSaveOptions;
  RVStyle: TRVStyle): TRVRawByteString;
begin
  Result := StringToHTMLString(
    GetParaHTMLCode(RVData, ItemNo, ParaStart, CSSVersion),
    Options, RVStyle);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetRVFOptions(const Value: TRVFOptions);
begin
  GetRootData.SetRVFOptions(Value);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVFWarnings: TRVFWarnings;
begin
  Result := GetRootData.GetRVFWarnings;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetRVFWarnings(const Value: TRVFWarnings);
begin
  GetRootData.SetRVFWarnings(Value);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVFSaveScope(SelectionOnly: Boolean):TRVFSaveScope;
begin
  if SelectionOnly then
    Result := rvfss_Selection
  else if rvstSavingPage in GetAbsoluteRootData.State then
    Result := rvfss_FullInPage
  else
    Result := rvfss_Full;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERVF}
{------------------------------------------------------------------------------}
type
  TRVFHeader = record
    StyleNo,ParaNo, ReadType, ExtraValue: Integer;
    DataCount, DataRead: Integer;
    Item: TCustomRVItemInfo;
    ClassName: String;
    Name: TRVRawByteString;
    Version, SubVersion: Integer;
    UTF8Strings: Boolean;
    RaiseEvent: Integer;
    PersistentCheckpoint: Integer;
    CheckPointTag: Integer;
    AssociatedTextStyleNameUsed: Boolean;
    PUnits: PRVStyleUnits;
  end;
  {------------------------------------------------------------------------------}
procedure TCustomRVData.DataReader(Stream: TStream);
var Size: Integer;
    MemStream: TRVMemoryStream;
    Color: TColor;
    Back: TRVBackground;
    Layout: TRVLayoutInfo;
    R: Boolean;
begin
  MemStream := TRVMemoryStream.Create;
  Layout := TRVLayoutInfo.Create;
  Include(State, rvstLoadingAsPartOfItem);
  try
    Stream.ReadBuffer(Size, SizeOf(Size));
    MemStream.SetSize(Size);
    Stream.ReadBuffer(MemStream.Memory^, Size);
    Back := nil;
    R := LoadRVFFromStream(MemStream, Color, Back, Layout);
    if GetParentData<>nil then
      GetParentData.RVFWarnings := GetParentData.RVFWarnings+RVFWarnings;
    if not R then
      raise EReadError.Create(errRVFSubDoc);
    if Layout.Loaded then
      ApplyLayoutInfo(Layout);
  finally
    MemStream.Free;
    Layout.Free;
    Exclude(State, rvstLoadingAsPartOfItem);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.ApplyLayoutInfo(Layout: TRVLayoutInfo);
begin
 if Layout.FirstParaAborted<>0 then begin
    Include(State, rvstFirstParaAborted);
    FFirstParaListNo := Layout.FirstMarkerListNo;
    FFirstParaLevel := Layout.FirstMarkerLevel;
    end
  else begin
    Exclude(State, rvstFirstParaAborted);
    FFirstParaListNo := -1;
    FFirstParaLevel := -1;
  end;
  if Layout.LastParaAborted<>0 then
    Include(State, rvstLastParaAborted)
  else
    Exclude(State, rvstLastParaAborted); 
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DataWriter(Stream: TStream);
var StartPos,Size: Integer;
    sb: Boolean;
begin
  Size := 0;
  StartPos := Stream.Position;
  Stream.WriteBuffer(Size, SizeOf(Size));
  sb := rvfoSaveBack in RVFOptions;
  RVFOptions := RVFOptions - [rvfoSaveBack];
  GetRVData.SaveRVFToStream(Stream, False, clNone, nil, nil, False);
  if sb then
    RVFOptions := RVFOptions + [rvfoSaveBack];
  Size := Stream.Position-SizeOf(Size)-StartPos;
  Stream.Position := StartPos;
  Stream.WriteBuffer(Size, SizeOf(Size));
  Stream.Position := StartPos+SizeOf(Size)+Size;
end;
{------------------------------------------------------------------------------}
function InsertRVFHeaderData(RVData: TCustomRVData; const Caption: TRVRawByteString;
  var Header: TRVFHeader; var PrevCP, CurCP: TRVCPInfo;
  var Index, InsertPoint: Integer; var FirstTime: Boolean; AParaNo: Integer;
  AppendMode, EditFlag: Boolean; var NonFirstItemsAdded: Integer;
  var FullReformat: Boolean; TextStylesMapping,
  ListStylesMapping: TRVIntegerList): Boolean;
var item: TCustomRVItemInfo;
    CP: TRVCPInfo;
    Caption2: TRVRawByteString;
    NewListNo: Integer;
    {$IFNDEF RVDONOTUSELISTS}
    OldListNo: Integer;
    {$ENDIF}
begin
  Result := True;
  {$IFNDEF RVDONOTUSELISTS}
  OldListNo := -1;
  {$ENDIF}
  if (Header.StyleNo=rvsBack) or
     (Header.StyleNo=rvsVersionInfo) then exit;
  if Header.Item<>nil then begin
    if Header.StyleNo>=0 then begin
      if EditFlag and
         (rvprRVFInsertProtect in RVData.GetRVStyle.TextStyles[RVData.GetActualStyle(Header.Item)].Protection) then
        exit;
      item := RichViewTextItemClass.Create(RVData);
      item.BeforeLoading(rvlfRVF);
      item.Assign(Header.Item);
      item.Tag := RV_CopyTag(Header.Item.Tag, rvoTagsArePChars in RVData.Options);
      end
    else begin
      item := Header.Item;
      if Header.PUnits^<>RVData.GetRVStyle.Units then begin
        item.ConvertToDifferentUnits(RVData.GetRVStyle.Units, nil, False);
        RVData.RVFWarnings := RVData.RVFWarnings+[rvfwConvUnits];
      end;
      Header.Item := nil;
      if (item.AssociatedTextStyleNo>=0) and not RichViewDoNotCheckRVFStyleRefs then begin
        if (TextStylesMapping<>nil) and not Header.AssociatedTextStyleNameUsed then begin
          if item.AssociatedTextStyleNo>=TextStylesMapping.Count then begin
            RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
            if rvfoConvUnknownStylesToZero in RVData.RVFOptions then
              item.AssociatedTextStyleNo := 0
            else begin
              item.Free;
              exit;
            end;
          end;
          item.AssociatedTextStyleNo := TextStylesMapping[item.AssociatedTextStyleNo];
        end;
        if item.AssociatedTextStyleNo>=RVData.GetRVStyle.TextStyles.Count then begin
          RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
          if rvfoConvUnknownStylesToZero in RVData.RVFOptions then
            item.AssociatedTextStyleNo := 0
          else begin
            item.Free;
            exit;
          end;
        end;
      end;
      if not item.GetBoolValue(rvbpValid) then begin
        item.Free;
        exit;
      end;
    end;
    if (Header.ParaNo=-1) and (RVData.Items.Count<>0) and (InsertPoint>0) and
       not RVData.GetItem(InsertPoint-1).GetBoolValue(rvbpFullWidth) then begin
      item.SameAsPrev := True;
      item.ParaNo := RVData.GetItem(InsertPoint-1).ParaNo;
      end
    else begin
      item.SameAsPrev := False;
      if (Header.ParaNo<>-1) then
        item.ParaNo := Header.ParaNo
      else
        item.ParaNo := 0;
    end;
    item.UpdatePaletteInfo(RVData.GetDoInPaletteMode, False,
      RVData.GetRVPalette, RVData.GetRVLogPalette);
    if CurCP<> nil then begin
      if CurCP=RVData.NotAddedCP then begin
        dec(RVData.CPCount);
        RVData.NotAddedCP := nil;
      end;
      CP := CurCP;
      if not EditFlag then begin
        inc(RVData.CPCount);
        RVData.SetCP(item, PrevCP, CurCP)
        end
      else begin
        item.Checkpoint := CurCP;
        CurCP.ItemInfo := item;
        CurCP := nil;
      end;
      PrevCP := CP;
    end;
    Caption2 := Caption;
    {$IFNDEF RVDONOTUSEUNICODE}
    if (rvioUnicode in item.ItemOptions) and (item.StyleNo>=0) and
       (Header.ReadType=3) then
      Caption2 := RVDecodeString(Caption);
    if (rvioUnicode in item.ItemOptions) and
       (item.StyleNo>=0) and
       (RVData.GetRVStyle<>nil) and
       not RVData.GetRVStyle.TextStyles[RVData.GetActualStyle(item)].Unicode then begin
      Caption2 := RVU_UnicodeToAnsi(RVData.GetStyleCodePage(RVData.GetActualStyle(item)), Caption);
      Exclude(item.ItemOptions, rvioUnicode);
      RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvFromUnicode];
    end;
    if not (rvioUnicode in item.ItemOptions) and
       (item.StyleNo>=0) and
       (RVData.GetRVStyle<>nil) and
       RVData.GetRVStyle.TextStyles[RVData.GetActualStyle(item)].Unicode then begin
      Caption2 := RVU_AnsiToUnicode(RVData.GetStyleCodePage(RVData.GetActualStyle(item)), Caption);
      Include(item.ItemOptions, rvioUnicode);
      RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvToUnicode];
    end;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    if (item.StyleNo=rvsListMarker) and not RichViewDoNotCheckRVFStyleRefs then begin
      if (ListStylesMapping<>nil) and (TRVMarkerItemInfo(item).ListNo>=0) and
        not Header.AssociatedTextStyleNameUsed then begin
        if TRVMarkerItemInfo(item).ListNo>=ListStylesMapping.Count then begin
          RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
          TRVMarkerItemInfo(item).ListNo := 0;
          end
        else begin
          OldListNo := TRVMarkerItemInfo(item).ListNo;
          TRVMarkerItemInfo(item).ListNo := ListStylesMapping[OldListNo];
        end;
      end;
      if TRVMarkerItemInfo(item).ListNo>=RVData.GetRVStyle.ListStyles.Count then begin
        RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
        TRVMarkerItemInfo(item).ListNo := 0;
        if TRVMarkerItemInfo(item).ListNo>=RVData.GetRVStyle.ListStyles.Count then
          TRVMarkerItemInfo(item).ListNo := -1;
      end;
    end;
    {$ENDIF}
    if FirstTime then begin
      if AppendMode then begin
        if AParaNo=-1 then begin
          item.SameAsPrev := (InsertPoint>0) and
            not RVData.GetItem(InsertPoint-1).GetBoolValue(rvbpFullWidth);
          if item.SameAsPrev then
            item.ParaNo := RVData.GetItem(InsertPoint-1).ParaNo
          else
            item.ParaNo := 0;
          end
        else begin
          item.SameAsPrev := False;
          item.ParaNo := AParaNo;
        end;
      end;
      if not RVData.InsertFirstRVFItem(InsertPoint, Caption2, item, EditFlag,
        FullReformat, NewListNo) then begin
        Result := False;
        exit;
      end;
      if item<>nil then begin
        {$IFNDEF RVDONOTUSESEQ}
        if item is TCustomRVNoteItemInfo then
          RVData.AfterReadNote(RVData, InsertPoint);
        {$ENDIF}      
        inc(InsertPoint);
        Index := InsertPoint-1;
        FirstTime := False;
      end;
      {$IFNDEF RVDONOTUSELISTS}
      if (OldListNo>=0) and (NewListNo>=0) then
        ListStylesMapping[OldListNo] := NewListNo;
      {$ENDIF}
      end
    else begin
      item.Inserting(RVData, Caption2, False);
      RVData.Items.InsertObject(InsertPoint, Caption2, item);
      item.Inserted(RVData, InsertPoint);
      {$IFNDEF RVDONOTUSESEQ}
      RVData.AddSeqInList(InsertPoint);
      if item is TCustomRVNoteItemInfo then
        RVData.AfterReadNote(RVData, InsertPoint);
      {$ENDIF}      
      {$IFNDEF RVDONOTUSELISTS}
      RVData.AddMarkerInList(InsertPoint);
      {$ENDIF}
      inc(InsertPoint);
      inc(NonFirstItemsAdded);
    end;
    if item<>nil then begin
      RVData.ControlAction(RVData, rvcaAfterRVFLoad, InsertPoint-1, item);
      if not (rvstLoadingAsPartOfItem in RVData.State) then
        item.AfterLoading(rvlfRVF);
      end
    else
      RVData.FreeCheckpoint(CurCP, False, False);
    end
  else begin
    // unknown item type
    if CurCP<> nil then begin
       if not EditFlag then begin
         inc(RVData.CPCount);
         item := RichViewTextItemClass.Create(RVData);
         RVData.SetCP(item, PrevCP, CurCP);
         RVData.InternalFreeItem(item,False);
         end
       else begin
         RVData.FreeCheckpoint(CurCP, False, False);
       end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function RVFReadHeader(RVData: TCustomRVData; const CurrentLine: TRVRawByteString;
  var Header: TRVFHeader; AParaNo: Integer; var Color: TColor;
  Background: TRVBackground;
  TextStylesMapping, ParaStylesMapping: TRVIntegerList;
  AllowReplaceStyles: Boolean): Boolean;
var P: PRVAnsiChar;
    ItemOptions: Integer;
    ABackgroundStyle, AColor, Tag, Tmp: Integer;
    TextStyleNameUsed, ParaStyleNameUsed: Boolean;
begin
  P := PRVAnsiChar(CurrentLine);
  Result := False;
  Header.DataRead := 0;
  Header.AssociatedTextStyleNameUsed := False;
  if not RVFReadTextStyle(RVData.GetRVStyle,P,Header.StyleNo, Header.UTF8Strings,
    TextStyleNameUsed) then
    exit; {error}
  if Header.StyleNo = rvsVersionInfo then begin
    Header.DataCount := 0;
    Result := (RVFReadInteger(P,Header.Version) and
               RVFReadInteger(P,Header.SubVersion));
    if RVFReadInteger(P, Tmp) and (Tmp>=1) then
      Header.UTF8Strings := True;
    exit;
  end;
  if not (RVFReadInteger(P,Header.DataCount) and
    RVFReadParaStyle(RVData.GetRVStyle,P,Header.ParaNo, Header.UTF8Strings,
    ParaStyleNameUsed)) then
    exit; {error}
  if (Header.StyleNo<>rvsBack) and (Header.StyleNo<>rvsCheckpoint) and
     (Header.StyleNo<>rvsDocProperty) then
    Header.Item := CreateRichViewItem(Header.StyleNo, RVData);
  if Header.Item<>nil then
    Header.Item.BeforeLoading(rvlfRVF);
  if (Header.Version>=1)and(Header.SubVersion>=2) then begin
    if not RVFReadInteger(P,ItemOptions) then
      exit; {error}
    if Header.Item<>nil then
      Header.Item.ItemOptions := TRVItemOptions(Byte(ItemOptions));
  end;
  if not (RVFReadInteger(P,Header.ReadType) and
     RVFReadTag(P, rvoTagsArePChars in RVData.Options,
     (Header.Version>1) or (Header.SubVersion>2), Tag, Header.UTF8Strings)) then
    exit; {error}
  if Header.StyleNo = rvsDocProperty then begin
    if not RVFReadInteger(P,Header.ExtraValue) then
      exit; {error}
    {$IFNDEF RVDONOTUSEDOCPARAMS}
    if (Header.ExtraValue=RVF_DOCPROP_DOCPARAMETERS) and
       (RVData.GetDocParameters(False)<>nil) and
       AllowReplaceStyles and (rvfoLoadDocProperties in RVData.RVFOptions) then
      RVData.GetDocParameters(False).Reset;
    {$ENDIF}
  end;
  if Header.StyleNo=rvsCheckpoint then
    Header.CheckpointTag := Tag
  else if Header.Item<>nil then
    Header.Item.Tag := Tag;
  if (Header.Item<>nil) and (Header.StyleNo>=0) and
     not RichViewDoNotCheckRVFStyleRefs then begin
    if (TextStylesMapping<>nil) and (Header.StyleNo<>rvsDefStyle) and
      not TextStyleNameUsed then begin
      if Header.StyleNo>=TextStylesMapping.Count then begin
        RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
        if rvfoConvUnknownStylesToZero in RVData.RVFOptions then
          Header.StyleNo := 0
        else
          exit;
        end
      else
        Header.StyleNo := TextStylesMapping[Header.StyleNo];
    end;
    Header.Item.StyleNo := Header.StyleNo;
    if (Header.StyleNo<>rvsDefStyle) and
       (Header.StyleNo>=RVData.GetRVStyle.TextStyles.Count) then begin
      RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
      if rvfoConvUnknownStylesToZero in RVData.RVFOptions then
        Header.Item.StyleNo := 0
      else
        exit;
    end;
  end;
  if (Header.Item<>nil) and (Header.ParaNo>=0) and
      not RichViewDoNotCheckRVFStyleRefs then begin
    if (ParaStylesMapping<>nil) and not ParaStyleNameUsed then begin
      if Header.ParaNo>=ParaStylesMapping.Count then begin
        RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
        exit;
      end;
      Header.ParaNo := ParaStylesMapping[Header.ParaNo];
    end;
    if Header.ParaNo>=RVData.GetRVStyle.ParaStyles.Count then begin
      RVData.RVFWarnings := RVData.RVFWarnings + [rvfwConvUnknownStyles];
      if rvfoConvUnknownStylesToZero in RVData.RVFOptions then
        Header.ParaNo := 0
      else
        exit;
    end;
  end;
  case Header.StyleNo of
  {*}rvsCheckpoint:
    begin
      if not (P^ in [#0, #10, #13]) then begin
        if not RVFReadInteger(P,Header.RaiseEvent) then
          exit;
        end
      else
        Header.RaiseEvent := 0;
      if not (P^ in [#0, #10, #13]) then begin
        if not RVFReadInteger(P,Header.PersistentCheckpoint) then
          exit;
        end
      else
        Header.PersistentCheckpoint := 0;
    end;
  {*}rvsBack:
    begin
      if not (RVFReadInteger(P, ABackgroundStyle) and
         RVFReadInteger(P, AColor)) then
        exit;
      if (rvfoLoadBack in RVData.RVFOptions) and AllowReplaceStyles then begin
        Color := AColor;
        if Background<>nil then begin
          Background.Style := TBackgroundStyle(ABackgroundStyle);
          Background.Bitmap.Handle := 0;
        end;
      end;
    end;
  {*}else
    begin
      if Header.Item = nil then begin
        Result := True;
        exit;
      end;
      if not Header.Item.ReadRVFHeaderTail(P, RVData, Header.UTF8Strings,
        Header.AssociatedTextStyleNameUsed) then
        exit;
    end;
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoOnStyleReaderError(Reader: TReader;
  const Message: string; var Handled: Boolean);
begin
  RVFWarnings := RVFWarnings + [rvfwUnknownStyleProperties];
  Handled := True;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoOnCtrlReaderError(Reader: TReader; const Message: string;
  var Handled: Boolean);
begin
  RVFWarnings := RVFWarnings + [rvfwUnknownCtrlProperties];
  Handled := True;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.InsertRVFFromStream_(Stream: TStream; var Index: Integer;
  AParaNo: Integer; AllowReplaceStyles, AppendMode, EditFlag: Boolean;
  var Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo;
  var NonFirstItemsAdded: Integer; var Protect, FullReformat: Boolean;
  LoadAsSubDoc: Boolean):Boolean;
var BufferString, CurrentLine: TRVRawByteString;
    Size: Integer;
    P, EndP: PRVAnsiChar;
    ReadState:TRVFReadState;
    ReadMode: TRVFReadMode;
    Header: TRVFHeader;
    FirstInsert: Boolean;
    PrevCP, CurCP: TRVCPInfo;
    PTextStylesMapping: PRVIntegerList;
    PParaStylesMapping: PRVIntegerList;
    PListStylesMapping: PRVIntegerList;    
    InsertPoint: Integer;
  {.......................................................}
   procedure FreeCheckpointTag; // in-out: Header
   begin
     if rvoTagsArePChars in Options then
       StrDispose(PChar(Header.CheckpointTag));
     Header.CheckpointTag := 0;
   end;
  {.......................................................}
  {$IFDEF RICHVIEWCBDEF3}
  procedure ReadStyles(Styles: TCustomRVInfos; StylesReadMode: TRVFReaderStyleMode);
  var Reader: TReader;
      TmpStream: TRVMemoryStream;
      Val: TValueType;
      {$IFDEF RICHVIEWDEF2009}
      DUS: Boolean;
      {$ENDIF}
  begin
    TmpStream := TRVMemoryStream.Create;
    try
      case Header.ReadType of
        0: // text
          RVFTextString2Stream(CurrentLine, TmpStream);
        2: // binary
          TmpStream.WriteBuffer(PRVAnsiChar(CurrentLine)^, Length(CurrentLine));
      end;
      if (TmpStream.Size>0) and (StylesReadMode<>rvf_sIgnore) then begin
        TmpStream.Position := 0;
        TmpStream.ReadBuffer(Val, sizeof(Val));
        if Val<>vaCollection then
          abort;
        Reader := TReader.Create(TmpStream, 4096);
        try
          Reader.OnError := DoOnStyleReaderError;
          {$IFDEF RICHVIEWDEF2009}
          DUS := GetRVStyle.DefaultUnicodeStyles;
          //GetRVStyle.DefaultUnicodeStyles := False;
          {$ENDIF}
          if Styles is TRVListInfos then
            TRVListInfos(Styles).FRVData := Self;
          try
            Reader.ReadCollection(Styles);
          finally
            if Styles is TRVListInfos then
              TRVListInfos(Styles).FRVData := nil;
            {$IFDEF RICHVIEWDEF2009}
            GetRVStyle.DefaultUnicodeStyles := DUS;
            {$ENDIF}
          end;
        finally
          Reader.Free;
        end;
      end;
    finally
      TmpStream.Free;
    end;
    if Header.PUnits^<>GetRVStyle.Units then
      Styles.ConvertToDifferentUnits(GetRVStyle.Units);
  end;
  {.......................................................}
  procedure MergeStyles(Base, Loaded: TCustomRVInfos;
                        var Mapping: TRVIntegerList;
                        StylesReadMode: TRVFReaderStyleMode);
  begin
    if (Loaded.Count=0) or (StylesReadMode = rvf_sIgnore) or (Mapping<>nil) then
      exit;
    if AllowReplaceStyles then begin
      if Base is TRVListInfos then
        TRVListInfos(Base).FRichViewAllowAssignListID := True;
      try
        Base.Assign(Loaded);
      finally
        if Base is TRVListInfos then
          TRVListInfos(Base).FRichViewAllowAssignListID := False;
      end;
      exit;
    end;
    Mapping := TRVIntegerList.Create;
    case StylesReadMode of
      rvf_sInsertMap:
        Base.MergeWith(Loaded, rvs_merge_Map, Mapping, PTextStylesMapping^, Self);
      rvf_sInsertMerge:
        Base.MergeWith(Loaded, rvs_merge_SmartMerge, Mapping, PTextStylesMapping^, Self);
    end;
  end;
  {.......................................................}
  procedure ClearExtraDocuments;
  var ExtraDocuments: TStrings;
      i: Integer;
  begin
    ExtraDocuments := GetExtraDocuments;
    if ExtraDocuments=nil then
      exit;
    for i := 0 to ExtraDocuments.Count-1 do
      (ExtraDocuments.Objects[i] as TCustomRVData).Clear;
  end;
  {.......................................................}
   procedure ReadDocProperty;
   var Styles, BaseStyles: TCustomRVInfos;
       StylesReadMode: TRVFReaderStyleMode;
       PMapping: PRVIntegerList;
       {$IFNDEF RVDONOTUSELISTS}
       i, ListNo: Integer;
       {$ENDIF}
       ExtraDocuments: TStrings;
       Index: Integer;
       TmpStream: TRVMemoryStream;
       TmpColor: TColor;
   begin
     case Header.DataRead of
       0:
         begin
           if Header.ExtraValue=RVF_DOCPROP_UNITS then
             Header.PUnits^ := TRVStyleUnits(RVStrToInt(CurrentLine))
           else if AllowReplaceStyles and (rvfoLoadDocProperties in RVFOptions) then
             case Header.ExtraValue of
               RVF_DOCPROP_DOCPROPLIST:
                 if GetDocProperties<>nil then
                   GetDocProperties.Add(RVFStringToString(CurrentLine, Header.UTF8Strings));
               {$IFNDEF RVDONOTUSEDOCPARAMS}
               RVF_DOCPROP_DOCPARAMETERS:
                 GetDocParameters(True).ReadProperyFromString(CurrentLine, Header.UTF8Strings);
               {$ENDIF}
               RVF_DOCPROP_EXTRADOCUMENT:
                 Header.ClassName := RVFStringToString(CurrentLine, Header.UTF8Strings);
             end;
           // if Header.ExtraValue<>values above
           // then ignoring this line (should be name of TRVStyle)
           if Header.ReadType=2 then ReadMode := rmBeforeBinary;
         end;
       1:
         begin
           case Header.ExtraValue of
             RVF_DOCPROP_TEXTSTYLES:
               begin
                 if AllowReplaceStyles and (rvfoCanChangeUnits in RVFOptions) and
                    (Header.PUnits^<>GetRVStyle.Units) then
                   GetRVStyle.ConvertToDifferentUnits(Header.PUnits^);
                 if Header.PUnits^<>GetRVStyle.Units then
                   RVFWarnings := RVFWarnings+[rvfwConvUnits];
                 Styles := TFontInfos.Create(GetRVStyle.GetTextStyleClass, nil);
                 StylesReadMode := GetRVFTextStylesReadMode;
                 BaseStyles := GetRVStyle.TextStyles;
                 PMapping := PTextStylesMapping;
               end;
             RVF_DOCPROP_PARASTYLES:
               begin
                 if AllowReplaceStyles and (rvfoCanChangeUnits in RVFOptions) and
                    (Header.PUnits^<>GetRVStyle.Units) then
                   GetRVStyle.ConvertToDifferentUnits(Header.PUnits^);
                 if Header.PUnits^<>GetRVStyle.Units then
                   RVFWarnings := RVFWarnings+[rvfwConvUnits];
                 Styles := TParaInfos.Create(GetRVStyle.GetParaStyleClass, nil);
                 StylesReadMode := GetRVFParaStylesReadMode;
                 BaseStyles := GetRVStyle.ParaStyles;
                 PMapping := PParaStylesMapping;
               end;
             RVF_DOCPROP_LISTSTYLES:
               begin
                 Styles := TRVListInfos.Create(GetRVStyle.GetListStyleClass, nil);
                 StylesReadMode := GetRVFParaStylesReadMode;
                 BaseStyles := GetRVStyle.ListStyles;
                 PMapping := PListStylesMapping;
               end;
             RVF_DOCPROP_LAYOUT:
               begin
                 if (Layout=nil) or (not AllowReplaceStyles) or
                    not (rvfoLoadLayout in RVFOptions) then
                   exit;
                 case Header.ReadType of
                   0: // text
                      Layout.LoadText(CurrentLine);
                   2: // binary
                      Layout.LoadBinary(CurrentLine);
                 end;
                 if (Layout.FirstParaAborted<>0) and (Layout.FirstMarkerListNo>=0) and
                    (PListStylesMapping^<>nil) then
                   Layout.FirstMarkerListNo := PListStylesMapping^[Layout.FirstMarkerListNo];
                 exit;
               end;
             RVF_DOCPROP_PREVMARKERS:
               begin
                 {$IFNDEF RVDONOTUSELISTS}
                 if (GetPrevMarkers=nil) or (not AllowReplaceStyles) or
                   not (rvfoLoadLayout in RVFOptions) then
                   exit;
                 case Header.ReadType of
                   0: // text
                      GetPrevMarkers.LoadText(CurrentLine, Self);
                   2: // binary
                      GetPrevMarkers.LoadBinary(CurrentLine, Self);
                 end;
                 if (PListStylesMapping^<>nil) then
                   for i := 0 to GetPrevMarkers.Count-1 do begin
                     ListNo := TRVMarkerItemInfo(GetPrevMarkers.Items[i]).ListNo;
                     if ListNo>=0 then
                     TRVMarkerItemInfo(GetPrevMarkers.Items[i]).ListNo :=
                       PListStylesMapping^[ListNo];
                   end;
                 {$ENDIF}
                 exit;
               end;
             RVF_DOCPROP_DOCPROPLIST:
               begin
                 if AllowReplaceStyles and (rvfoLoadDocProperties in RVFOptions) and
                   (GetDocProperties<>nil) then
                   GetDocProperties.Add(RVFStringToString(CurrentLine, Header.UTF8Strings));
                 exit;
               end;
             {$IFNDEF RVDONOTUSEDOCPARAMS}
             RVF_DOCPROP_DOCPARAMETERS:
               begin
                 if AllowReplaceStyles and (rvfoLoadDocProperties in RVFOptions) then
                   GetDocParameters(True).ReadProperyFromString(CurrentLine, Header.UTF8Strings);
                 exit;
               end;
             {$ENDIF}
             RVF_DOCPROP_EXTRADOCUMENT:
               begin
                 if not AllowReplaceStyles then
                   exit;
                 ExtraDocuments := GetExtraDocuments;
                 if ExtraDocuments=nil then
                   exit;
                 Index := ExtraDocuments.IndexOf(Header.ClassName);
                 if Index<0 then
                   exit;
                 case Header.ReadType of
                   0: // text
                     begin
                       TmpStream := TRVMemoryStream.Create;
                       RVFTextString2Stream(CurrentLine, TmpStream);
                     end;
                   2: // binary
                     TmpStream := RVFStringToStream(CurrentLine);
                   else
                     TmpStream := nil;
                 end;
                 try
                   (ExtraDocuments.Objects[Index] as TCustomRVData).
                     LoadRVFFromStream(TmpStream, TmpColor, nil, nil);
                 finally
                   TmpStream.Free;
                 end;
                 exit;
               end;
             else
               exit;
           end;
           try
             ReadStyles(Styles, StylesReadMode);
             MergeStyles(BaseStyles, Styles, PMapping^, StylesReadMode);
           finally
             Styles.Free;
           end;
         end;
       else
         if AllowReplaceStyles and (rvfoLoadDocProperties in RVFOptions) then
           case Header.ExtraValue of
             RVF_DOCPROP_DOCPROPLIST:
               if GetDocProperties<>nil then
                 GetDocProperties.Add(RVFStringToString(CurrentLine, Header.UTF8Strings));
             {$IFNDEF RVDONOTUSEDOCPARAMS}
             RVF_DOCPROP_DOCPARAMETERS:
               GetDocParameters(True).ReadProperyFromString(CurrentLine, Header.UTF8Strings);
             {$ENDIF}
           end;
     end;
   end;
  {$ENDIF}
  {.......................................................}
                             // in    : CurrentLine
   procedure ReadBackground; // in-out: Header
                             // out   : ReadMode, ReadState
   var bmp : TBitmap;
   begin
     case Header.DataRead of
       0:
         begin
           // ignoring this line (should be TBitmap)
           if Header.ReadType=2 then ReadMode := rmBeforeBinary;
         end;
       1:
         begin
           if rvfoLoadBack in RVFOptions then begin
             if Background<>nil then begin
               if Header.ReadType=2 then
                 RVFLoadPictureBinary(CurrentLine, Background.Bitmap)
               else
                 if not RVFLoadPicture(CurrentLine, Background.Bitmap) then abort; {error}
               end
             else begin
               bmp := TBitmap.Create;
               if Header.ReadType=2 then
                 RVFLoadPictureBinary(CurrentLine, bmp)
               else
                 if not RVFLoadPicture(CurrentLine, bmp) then abort; {error}
               bmp.Free;
             end;
           end;
           ReadState := rstSkip;
         end;
     end;
   end;
  {.......................................................}
                               // in: ReadMode
                               // in-out: P
    procedure ReadCurrentLine; // out: CurrentLine
    var Start: PRVAnsiChar;
        Size: Integer;
    begin
      Start := P;
      case ReadMode of
        rmBinary:
          begin
            Move(P^,Size, SizeOf(Size));
            inc(Start, SizeOf(Size));
            inc(P,     SizeOf(Size)+Size);
          end;
        rmUnicode:
          begin
            while (PWord(P)^<>UNI_ParagraphSeparator) and
                  (PWord(P)^<>0) and
                  (P<EndP) do Inc(P,2);
          end;
        else
          begin
            while not (P^ in [#0, #10, #13]) do Inc(P);
          end;
      end;
      SetString(CurrentLine, Start, P - Start);
    end;
  { // test: allowing zero characters in Unicode
    procedure ReadCurrentLine; // out: CurrentLine
    var Start: PRVAnsiChar;
        Size: Integer;
        Ptr: PWordArray;
        i: Integer;
    begin
      Start := P;
      case ReadMode of
        rmBinary:
          begin
            Move(P^,Size, SizeOf(Size));
            inc(Start, SizeOf(Size));
            inc(P,     SizeOf(Size)+Size);
          end;
        rmUnicode:
          begin
            while (PWord(P)^<>UNI_ParagraphSeparator) and
                  (P<EndP) do Inc(P,2);
          end;
        else
          begin
            while not (P^ in [#0, #10, #13]) do Inc(P);
          end;
      end;
      SetString(CurrentLine, Start, P - Start);
      if ReadMode = rmUnicode then begin
        Ptr := Pointer(CurrentLine);
        for i := 0 to Length(CurrentLine) div 2 - 1 do
          if Ptr[i]=0 then
            Ptr[i] := ord('?');
      end;
    end; }
  {.......................................................}
   procedure SkipCurrentLineTail; // in-out: P, ReadMode
   begin
     case ReadMode of
       rmText:
         begin
           if P^ = #13 then Inc(P);
           if P^ = #10 then Inc(P);
         end;
       rmBeforeUnicode:
         begin
           if P^ = #13 then Inc(P) else abort; {error}
           if P^ = #10 then Inc(P) else abort; {error}
           ReadMode := rmUnicode;
         end;
       rmUnicode:
         begin
           if PWord(P)^=UNI_ParagraphSeparator then
             Inc(P, 2);
         end;
       rmAfterUnicode:
         begin
           if PWord(P)^=UNI_ParagraphSeparator then
             Inc(P, 2);
           ReadMode := rmText;
         end;
       rmBeforeBinary:
         begin
           if P^ = #13 then Inc(P) else abort; {error}
           if P^ = #10 then Inc(P) else abort; {error}
           ReadMode := rmBinary;
         end;
       rmBinary:
         begin
           ReadMode := rmText;
         end;
     end;
   end;
  {.......................................................}
  var StartIndex: Integer;
begin
  NonFirstItemsAdded := 0;
  Protect          := True;
  FirstInsert      := True;
  StartIndex       := Index;
  InsertPoint      := Index;
  if Index>Items.Count then
    Index := Items.Count;
  if Index=Items.Count then begin
    PrevCP := LastCP;
    if EditFlag then
      CurCP := nil
    else
      CurCP  := NotAddedCP;
    end
  else begin
    PrevCP := FindCPBeforeItem(Index);
    CurCP := nil;
  end;
  RVFWarnings := [];
  if AllowReplaceStyles and (GetDocProperties<>nil) then
    GetDocProperties.Clear;
  if AllowReplaceStyles then
    ClearExtraDocuments;
  FillChar(Header,sizeof(Header),0);
  Header.Version := 1;
  Header.SubVersion := 0;
  InitStyleMappings(PTextStylesMapping, PParaStylesMapping, PListStylesMapping,
    Header.PUnits);
  try
    Size := Stream.Size - Stream.Position;
    SetString(BufferString, nil, Size);
    Stream.Read(Pointer(BufferString)^, Size);
    P := Pointer(BufferString);
    EndP := PRVAnsiChar(BufferString)+Size;
    ReadState := rstHeader;
    ReadMode := rmText;
    if P <> nil then
      while P < EndP do begin
        ReadCurrentLine;
        case ReadState of
          rstHeader:
            begin
              if not RVFReadHeader(Self, CurrentLine, Header, AParaNo,
                Color, Background, PTextStylesMapping^, PParaStylesMapping^,
                AllowReplaceStyles) then
                abort; {error}
              if (Header.DataCount=0) then begin
                if not InsertRVFHeaderData(Self, '', Header, PrevCP, CurCP,
                  Index, InsertPoint, FirstInsert, AParaNo, AppendMode, EditFlag,
                  NonFirstItemsAdded, FullReformat, PTextStylesMapping^,
                  PListStylesMapping^) then
                  abort; {error}
                ReadState := rstHeader;
                end
              else
                if ((Header.Item=nil) and (Header.StyleNo<>rvsCheckpoint) and
                    (Header.StyleNo<>rvsBack)
                    {$IFDEF RICHVIEWCBDEF3}
                    and (Header.StyleNo<>rvsDocProperty)
                    {$ENDIF}
                    ) or
                   ((Header.Item<>nil) and
                    not Header.Item.GetBoolValue(rvbpRequiresRVFLines)) then
                  ReadState := rstSkip
                else begin
                  ReadState := rstData;
                  {$IFNDEF RVDONOTUSEUNICODE}
                  if (Header.Item<>nil) and
                     (rvioUnicode in Header.Item.ItemOptions) and
                     (Header.ReadType<>3) then
                    ReadMode := rmBeforeUnicode;
                  {$ENDIF}
                end;
            end;
          rstData:
            begin
              if Header.StyleNo<0 then begin
                case Header.StyleNo of
                {*} rvsBack:
                   ReadBackground;
                {$IFDEF RICHVIEWCBDEF3}
                {*} rvsDocProperty:
                   ReadDocProperty;
                {$ENDIF}
                {*} rvsCheckpoint:
                  begin
                    if CurCP = nil then begin
                      CurCP := TRVCPInfo.Create;
                      CurCP.Name := RVFStringToString(CurrentLine, Header.UTF8Strings);
                      CurCP.Tag  := Header.CheckpointTag;
                      CurCP.RaiseEvent := Boolean(Header.RaiseEvent);
                      CurCP.Persistent := Boolean(Header.PersistentCheckpoint);
                      Header.CheckpointTag := 0;
                    end;
                  end;
                {*} else
                  begin
                    if Header.Item<>nil then
                      if not Header.Item.ReadRVFLine(CurrentLine, Self,
                         Header.ReadType, Header.DataRead, Header.DataCount,
                         Header.Name, ReadMode, ReadState, Header.UTF8Strings,
                         Header.AssociatedTextStyleNameUsed) then
                        abort;
                    if Header.DataRead=Header.DataCount-1 then
                      if not InsertRVFHeaderData(Self, Header.Name, Header,
                         PrevCP, CurCP, Index, InsertPoint, FirstInsert, AParaNo,
                         AppendMode, EditFlag, NonFirstItemsAdded, FullReformat,
                         PTextStylesMapping^, PListStylesMapping^) then
                        abort; {error}
                  end
                end
                end
              else begin
                if not InsertRVFHeaderData(Self, CurrentLine, Header, PrevCP, CurCP,
                   Index, InsertPoint, FirstInsert, AParaNo, AppendMode, EditFlag,
                   NonFirstItemsAdded, FullReformat, PTextStylesMapping^,
                   PListStylesMapping^) then
                  abort; {error}
                if Header.DataRead=Header.DataCount-1 then begin
                  if rvoTagsArePChars in Options then
                    StrDispose(PChar(Header.Item.Tag));
                  Header.Item.Free;
                  Header.Item := nil;
                end;
              end;
              inc(Header.DataRead);
              if Header.DataRead=Header.DataCount then begin
                ReadState := rstHeader;
                if ReadMode=rmUnicode then
                  ReadMode := rmAfterUnicode;
              end;
            end;
          rstSkip:
            begin
              inc(Header.DataRead);
              if (Header.DataRead=Header.DataCount-1) and (Header.ReadType=2) then
                ReadMode := rmBeforeBinary
              else if Header.DataRead=Header.DataCount then begin
                if not InsertRVFHeaderData(Self, Header.Name, Header, PrevCP, CurCP,
                   Index, InsertPoint, FirstInsert, AParaNo, AppendMode, EditFlag,
                   NonFirstItemsAdded, FullReformat, PTextStylesMapping^,
                   PListStylesMapping^) then
                  abort; {error}
                ReadState := rstHeader;
              end;
            end;
        end;
        SkipCurrentLineTail;
      end; // of while
    Result := (ReadState = rstHeader);
    {$IFNDEF RVDONOTUSELISTS}
    if (InsertPoint-1>=0) and (InsertPoint-1<ItemCount) and
       (GetItemStyle(InsertPoint-1)=rvsListMarker) and
       ((InsertPoint=ItemCount) or IsParaStart(InsertPoint)) then begin
      Header.StyleNo := 0;
      Header.ParaNo := -1;
      Header.Item := RichViewTextItemClass.Create(Self);
      InsertRVFHeaderData(Self, '', Header, PrevCP, CurCP, Index, InsertPoint,
        FirstInsert, AParaNo, AppendMode, EditFlag,
        NonFirstItemsAdded, FullReformat, PTextStylesMapping^, PListStylesMapping^);
      Header.Item.Free;
      Header.Item := nil;
    end;
    {$ENDIF}
    if not EditFlag then
      NormalizeParas(StartIndex);
    Protect := False;
  except
    Result := False;
  end;

  DoneStyleMappings(LoadAsSubDoc);
  FreeCheckpointTag;
  if Result and (InsertPoint=Items.Count) and (NotAddedCP=nil) then begin
    if CurCP<> nil then inc(CPCount);
    NotAddedCP := CurCP
    end
  else
    if NotAddedCP<>CurCP then
      FreeCheckpoint(CurCP, False, False); // ignore cp from stream
  Header.Item.Free;      
end;
{------------------------------------------------------------------------------}
function TCustomRVData.AppendRVFFromStream(Stream: TStream; ParaNo: Integer;
                             var Color: TColor;
                             Background: TRVBackground):Boolean;
var Dummy: Integer;
    Dummy2, Dummy3: Boolean;
    Index: Integer;
begin
  Index := Items.Count;
  Result := InsertRVFFromStream_(Stream, Index, ParaNo, False, True, False,
    Color, Background, nil, Dummy, Dummy2, Dummy3, False);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.InsertRVFFromStream(Stream: TStream; Index: Integer;
  var Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo;
  AllowReplaceStyles: Boolean):Boolean;
var Dummy: Integer;
    Dummy2,Dummy3: Boolean;
begin
  // AParaNo is used only if AppendMode=True
  Result := InsertRVFFromStream_(Stream, Index, -1, AllowReplaceStyles, False,
    False, Color, Background, Layout, Dummy, Dummy2, Dummy3, False);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadRVF(const FileName: String; var Color: TColor;
  Background: TRVBackground; Layout: TRVLayoutInfo):Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName,fmOpenRead or fmShareDenyWrite);
    try
      Result := LoadRVFFromStream(Stream, Color, Background, Layout);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadRVFFromStream(Stream: TStream; var Color: TColor;
  Background: TRVBackground; Layout: TRVLayoutInfo):Boolean;
begin
  Clear;
  Result := InsertRVFFromStream(Stream,0, Color, Background, Layout, True);
end;
{------------------------------------------------------------------------------}
procedure RVFWriteCheckpoint(Stream: TStream; TagsArePChars: Boolean;
  cp: TRVCPInfo);
begin
  if cp=nil then
    exit;
  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %s %d %d',
    [rvsCheckpoint, 1, 0, 0, 0, RVFSaveTag(TagsArePChars,cp.Tag),
     Integer(cp.RaiseEvent), Integer(cp.Persistent)]));
  RVFWriteLine(Stream, StringToRVFString(cp.Name));
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveRVF(const FileName: String; SelectionOnly: Boolean;
  Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo;
  Root: Boolean):Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName,fmCreate);
    try
      Result := SaveRVFToStream(Stream, SelectionOnly, Color, Background,
        Layout, Root);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveRVFToStream(Stream: TStream; SelectionOnly: Boolean;
  Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo;
  Root: Boolean):Boolean;
begin
  Result := SaveRVFToStreamEx(Stream, GetRVFSaveScope(SelectionOnly), Color,
    Background, Layout, Root);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveRVFToStreamEx(Stream: TStream; SaveScope: TRVFSaveScope;
  Color: TColor; Background: TRVBackground; Layout: TRVLayoutInfo; Root: Boolean):Boolean;
var i: Integer;
    Header: TRVFHeader;
    SectionBackOffs: Integer;
    StartItem, EndItem, StartOffs, EndOffs: Integer;
    StartPart, EndPart: TRVMultiDrawItemPart;
    MarkerItemNo: Integer;
    SelectedItem: TCustomRVItemInfo;
   {.......................................................}
     procedure RVFSaveVersionInfo;
     begin
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d%s',
         [rvsVersionInfo, RVFVersion, RVFSubVersion, RVFSubSubVersion]));
     end;
   {.......................................................}
   {$IFDEF RICHVIEWCBDEF3}
     procedure RVFSaveStyles(Id: Integer; Styles: TCollection);
     var SaveType: Integer;
         Writer: TWriter;
         TmpStream: TRVMemoryStream;
         Pos,Pos2: Integer;
     begin
       if rvfoSaveBinary in RVFOptions then
         SaveType := 2 // save binary
       else
         SaveType := 0; // save hex dump
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
          [rvsDocProperty, 2, 0, 0, SaveType, 0, Id]));
       RVFWriteLine(Stream, TRVAnsiString(GetRVStyle.Name));
       if rvfoSaveBinary in RVFOptions then begin
         Pos := Stream.Position;
         Stream.WriteBuffer(Pos, sizeof(Pos));
         Writer := TWriter.Create(Stream, 4096);
         if Styles is TRVListInfos then
           TRVListInfos(Styles).FRVData := Self;
         try
           Writer.WriteCollection(Styles)
         finally
           Writer.Free;
           if Styles is TRVListInfos then
             TRVListInfos(Styles).FRVData := nil;
         end;
         Pos2 := Stream.Position;
         Stream.Position := Pos;
         Pos := Pos2-Pos-sizeof(Pos);
         Stream.WriteBuffer(Pos, sizeof(Pos));
         Stream.Position := Pos2;
         end
       else begin
         TmpStream := TRVMemoryStream.Create;
         try
           Writer := TWriter.Create(TmpStream, 4096);
           if Styles is TRVListInfos then
             TRVListInfos(Styles).FRVData := Self;
           try
             Writer.WriteCollection(Styles);
           finally
             Writer.Free;
             if Styles is TRVListInfos then
               TRVListInfos(Styles).FRVData := nil;
           end;
           TmpStream.Position := 0;
           RVFWriteLine(Stream, RVFStream2TextString(TmpStream));
         finally
           TmpStream.Free;
         end;
       end;
     end;
   {$ENDIF}
   {.......................................................}
   {
   function MakeTemporalLayout: TRVLayoutInfo;
   begin
     Result := nil;
     if not (rvstFirstParaAborted in State) and
        not (rvstLastParaAborted in State) then
       exit;
     Result := TRVLayoutInfo.Create;
     Result.FirstParaAborted  := ord(rvstFirstParaAborted in State);
     Result.LastParaAborted   := ord(rvstLastParaAborted in State);
     Result.FirstMarkerListNo := FFirstParaListNo;
     Result.FirstMarkerLevel  := FFirstParaLevel;
   end;
   }
   {.......................................................}
     procedure RVFSaveLayout;
     var SaveType : Integer;
     begin
       if rvfoSaveBinary in RVFOptions then
         SaveType := 2 // save binary
       else
         SaveType := 0; // save hex dump
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
          [rvsDocProperty, 2, 0, 0, SaveType, 0, RVF_DOCPROP_LAYOUT]));
       RVFWriteLine(Stream, '');
       case SaveType of
         2:
           Layout.SaveToStream(Stream,True, Self<>GetRootData);
         0:
           Layout.SaveTextToStream(Stream, Self<>GetRootData);
       end;
     end;
   {.......................................................}
     procedure RVFSaveUnits;
     begin
       if GetRVStyle.Units<>rvstuPixels then begin
         RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
            [rvsDocProperty, 1, 0, 0, 0, 0, RVF_DOCPROP_UNITS]));
         RVFWriteLine(Stream, '1'); // ord(rvstuTwips)
       end;
     end;
   {.......................................................}
     procedure RVFSaveSubDocuments;
     var SaveType, i, v: Integer;
         DocStream: TRVMemoryStream;
         ExtraDocuments: TStrings;
     begin
       ExtraDocuments := GetExtraDocuments;
       if ExtraDocuments=nil then
         exit;
       if rvfoSaveBinary in RVFOptions then
         SaveType := 2 // save binary
       else
         SaveType := 0; // save hex dump
       for i := 0 to ExtraDocuments.Count-1 do begin
         RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
            [rvsDocProperty, 2, 0, 0, SaveType, 0, RVF_DOCPROP_EXTRADOCUMENT]));
         RVFWriteLine(Stream, StringToRVFString(ExtraDocuments[i]));
         DocStream := TRVMemoryStream.Create;
         try
           (ExtraDocuments.Objects[i] as TCustomRVData).SaveRVFToStream(DocStream,
             False, clNone, nil, nil, True);
           case SaveType of
           2:
             begin
               v := DocStream.Size;
               Stream.WriteBuffer(v, sizeof(v));
               Stream.WriteBuffer(DocStream.Memory^, v);
             end;
           0:
             RVFWriteLine(Stream, RVFStream2TextString(DocStream));
           end;
         finally
           DocStream.Free;
         end;
       end;
     end;
   {.......................................................}
   {$IFNDEF RVDONOTUSEDOCPARAMS}
     procedure RVFSaveDocParameters;
     var DocParameters: TRVDocParameters;
         Count: Integer;
     begin
       DocParameters := GetDocParameters(False);
       if DocParameters=nil then
         Count := 0
       else
         Count := DocParameters.GetRVFLineCount;
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
          [rvsDocProperty, Count, 0, 0, 0, 0,
           RVF_DOCPROP_DOCPARAMETERS]));
       if DocParameters<>nil then
         DocParameters.SaveToRVF(Stream);
     end;
   {$ENDIF}
   {.......................................................}
   {$IFNDEF RVDONOTUSELISTS}
     procedure RVFSavePrevMarkers(StartItemNo: Integer);
     var SaveType, MarkerIndex : Integer;
         Marker: TRVMarkerItemInfo;
     begin
       if StartItemNo=0 then
         exit;
       Marker := FindPreviousMarker(StartItemNo-1);
       if Marker=nil then
         exit;
       MarkerIndex := Marker.GetIndexInList(GetMarkers(False));
       if MarkerIndex<0 then
         exit;
       if rvfoSaveBinary in RVFOptions then
         SaveType := 2 // save binary
       else
         SaveType := 0; // save hex dump
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
          [rvsDocProperty, 2, 0, 0, SaveType, 0, RVF_DOCPROP_PREVMARKERS]));
       RVFWriteLine(Stream, '');
       case SaveType of
         2:
           GetMarkers(False).SaveToStream(Stream, MarkerIndex+1, True);
         0:
           GetMarkers(False).SaveTextToStream(Stream, MarkerIndex+1);
       end;
     end;
   {$ENDIF}
   {.......................................................}
     procedure RVFSaveDocPropertiesStringList;
     var i: Integer;
         dp: TStringList;
     begin
       dp := GetAbsoluteRootData.GetDocProperties;
       if (dp=nil) or (dp.Count=0) then
         exit;
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d',
          [rvsDocProperty, dp.Count, 0, 0, 0, 0, RVF_DOCPROP_DOCPROPLIST]));
       for i := 0 to dp.Count-1 do
         RVFWriteLine(Stream, StringToRVFString(dp.Strings[i]));
     end;
   {.......................................................}
     procedure RVFSaveBackground;
     var SaveType, LineCount: Integer;
     begin
       if Background=nil then exit;
       if Background.Bitmap.Empty or (Background.Style=bsNoBitmap) then
         RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d %d',
                            [rvsBack, 0, -1, 0, 0, 0, ord(Background.Style), Color]))
       else begin
         LineCount := 2;
         if rvfoSaveBinary in RVFOptions then
           SaveType := 2 // save binary
         else
           SaveType := 0 // save hex dump
         ;
         RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %d %d %d %d %d %d',
            [rvsBack, LineCount, 0, 0, SaveType, 0, ord(Background.Style), Color]));
         if SaveType<>1 then begin
           RVFWriteLine(Stream, TRVAnsiString(Background.Bitmap.ClassName));
           if rvfoSaveBinary in RVFOptions then
             RVFSavePictureBinary(Stream, Background.Bitmap)
           else
             RVFWriteLine(Stream, RVFSavePicture(Background.Bitmap));
         end;
       end;
     end;
   {.......................................................}
   { Saves text of the ItemNo-th item in range from StartOffs to EndOffs characters.
     If the ItemNo-th item is not a text item, saves an empty text line of style
     GetItem(ItemNo).AssociatedTextStyleNo (it's assumed that it's >=0).
     If StartOffs=GetOffsetBeforeItem(ItemNo) and the item has a checkpoint,
     it's saved too.
     If ForceSavingPara, item's paragraph index is saved, even if it does not
     start a new paragraph. }
    procedure WritePartialTextLine(ItemNo, StartOffs, EndOffs: Integer;
      ForceSavingPara: Boolean); // in: Stream
    var AFromStart: Boolean;
        AParaNo, TextStyleNo: Integer;
        SaveMode: Integer;
        Tail: TRVRawByteString;
        Text: TRVRawByteString;
        item: TCustomRVItemInfo;
        {$IFNDEF RVDONOTUSEUNICODE}
        Unicode: Boolean;
        {$ENDIF}
        ItemOptions: TRVItemOptions;
    begin
      AFromStart := (StartOffs <= GetOffsBeforeItem(ItemNo));
      item := GetItem(ItemNo);
      TextStyleNo := item.StyleNo;
      if TextStyleNo<0 then
        TextStyleNo := item.AssociatedTextStyleNo;
      {$IFNDEF RVDONOTUSEUNICODE}
      Unicode := GetRVStyle.TextStyles[TextStyleNo].Unicode;
      {$ENDIF}
      {$IFDEF RICHVIEWCBDEF3}
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode and not (rvfoSaveBinary in RVFOptions) then
        SaveMode := 3
      else
      {$ENDIF}
        SaveMode := 0;
     {$ELSE}
     SaveMode := 0;
     {$ENDIF}
     if (AFromStart and not item.SameAsPrev) or ForceSavingPara then
       AParaNo := item.ParaNo
     else
       AParaNo   := -1;
     if AFromStart then
       RVFWriteCheckpoint(Stream, rvoTagsArePChars in Options, item.Checkpoint);
     Tail := '';
     {$IFNDEF RVDONOTUSEITEMHINTS}
     {$IFDEF RICHVIEWCBDEF3}
     if item.Hint<>'' then
       Tail := ' '+StringToRVFString(AnsiQuotedStr(item.Hint, '"'));
     {$ENDIF}
     {$ENDIF}
     ItemOptions := GetItemOptions(ItemNo);
     {$IFNDEF RVDONOTUSEUNICODE}
     if Unicode then
       Include(ItemOptions, rvioUnicode);
     {$ENDIF}
     RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%s %d %s %d %d %s%s',
       [RVFSaveText(GetRVStyle, rvfoUseStyleNames in RVFOptions, TextStyleNo), 1,
       RVFSavePara(GetRVStyle, rvfoUseStyleNames in RVFOptions, AParaNo),
       Byte(ItemOptions) and RVItemOptionsMask,
       SaveMode, RVFSaveTag(rvoTagsArePChars in Options, item.Tag),
       Tail]));
     if item.StyleNo>=0 then
       Text := RVU_Copy(Items[ItemNo], StartOffs, EndOffs-StartOffs, GetItemOptions(ItemNo))
     else
       Text := '';
     RVFWriteLineX(Stream, Text,
       {$IFNDEF RVDONOTUSEUNICODE}Unicode{$ELSE}False{$ENDIF}, SaveMode=3);
     MarkerItemNo := -1;
    end;
   {.......................................................}
    function IsTheSameStyleText: Boolean; // in: i, Header
    begin
      with GetItem(i) do
        Result := (not SameAsPrev) and (StyleNo>=0) and (StyleNo=Header.StyleNo) and
          (ParaNo=Header.ParaNo) and
          ((Byte(ItemOptions) and RVItemOptionsMask) = (Byte(Header.Item.ItemOptions)and RVItemOptionsMask)) and
          RV_CompareTags(Tag, Header.Item.Tag, rvoTagsArePChars in Options) and
          {$IFNDEF RVDONOTUSEITEMHINTS}
          (Hint=Header.Item.Hint) and
          {$ENDIF}
          (Checkpoint=nil);
    end;
  {.......................................................}
   procedure RVFWritePrevStrings(i: Integer); // in: Header, SectionBackOffs
   var j: Integer;
       ItemOptions: TRVItemOptions;
       SaveMode: Integer;
       Tail: TRVRawByteString;
   begin
     {$IFDEF RICHVIEWCBDEF3}
      if (rvfoSaveBinary in RVFOptions) or
         not (rvioUnicode in GetItemOptions(i-SectionBackOffs)) then
        SaveMode := 0
      else
        SaveMode := 3;
     {$ELSE}
     SaveMode := 0;
     {$ENDIF}
     RVFWriteCheckpoint(Stream, rvoTagsArePChars in Options, Header.Item.Checkpoint);
     if MarkerItemNo>=0 then begin
       ItemOptions := RVFGetItemOptions(Header.Item.ItemOptions, MarkerItemNo>=0);
       RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%s %d %s %d %d %s',
         [RVFSaveText(GetRVStyle, rvfoUseStyleNames in RVFOptions, Header.StyleNo),
         1,
         RVFSavePara(GetRVStyle, rvfoUseStyleNames in RVFOptions, -1),
         Byte(ItemOptions) and RVItemOptionsMask,
         SaveMode, RVFSaveTag(rvoTagsArePChars in Options, Header.Item.Tag)]));
       RVFWriteLineX(Stream, Items[i-SectionBackOffs],
         rvioUnicode in GetItemOptions(i-SectionBackOffs), SaveMode=3);
       dec(SectionBackOffs);
       MarkerItemNo := -1;
     end;
     if SectionBackOffs=0 then
       exit;
     Tail := '';
     {$IFNDEF RVDONOTUSEITEMHINTS}
     {$IFDEF RICHVIEWCBDEF3}
     if GetItem(i-SectionBackOffs).Hint<>'' then
       Tail := ' '+StringToRVFString(AnsiQuotedStr(GetItem(i-SectionBackOffs).Hint, '"'));
     {$ENDIF}
     {$ENDIF}
     RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%s %d %s %d %d %s%s',
       [RVFSaveText(GetRVStyle, rvfoUseStyleNames in RVFOPtions, Header.StyleNo),
       SectionBackOffs,
       RVFSavePara(GetRVStyle, rvfoUseStyleNames in RVFOPtions, Header.ParaNo),
       Byte(Header.Item.ItemOptions) and RVItemOptionsMask,
       SaveMode, RVFSaveTag(rvoTagsArePChars in Options, Header.Item.Tag),
       Tail]));
     for j := i-SectionBackOffs to i-1 do
       RVFWriteLineX(Stream, Items[j], rvioUnicode in GetItemOptions(j), SaveMode=3);
     SectionBackOffs := 0;
   end;
  {.......................................................}
   procedure RVFSetHeaderHeader(i: Integer); // in: Header
   begin
     with GetItem(i) do begin
       Header.Item.Checkpoint := Checkpoint;
       Header.Item.ItemOptions := ItemOptions;
       Header.StyleNo      := StyleNo;
       //if StyleNo>=0 then
         Header.Item.StyleNo := StyleNo;
       {$IFNDEF RVDONOTUSEITEMHINTS}
       Header.Item.Hint := Hint;
       {$ENDIF}
       if SameAsPrev and not ((i=StartItem) and (SaveScope=rvfss_Page)) then
         Header.ParaNo   := -1
       else
         Header.ParaNo   := ParaNo;
       Header.Item.Tag     := Tag;
     end;
   end;
  {.......................................................}
   procedure RVFWriteNonText(i: Integer; Part: TRVMultiDrawItemPart); // in: Header
   {$IFNDEF RVDONOTUSELISTS}
   var StartFrom: Integer;
       Reset: Boolean;
       marker: TRVMarkerItemInfo;
   {$ENDIF}
   begin
     with GetItem(i) do begin
       RVFWriteCheckpoint(Stream, rvoTagsArePChars in Options, Checkpoint);
       {$IFNDEF RVDONOTUSELISTS}
       if StyleNo=rvsListMarker then begin
         marker := TRVMarkerItemInfo(GetItem(i));
         StartFrom := marker.StartFrom;
         Reset     := marker.Reset;
         if SaveScope in [rvfss_Page, rvfss_FullInPage] then begin
           marker.StartFrom := marker.Counter;
           marker.Reset     := True;
         end;
         end
       else begin
         StartFrom := 0;    // avoiding warnings
         Reset     := False;
         marker    := nil;
       end;
       {$ENDIF}
       SaveRVF(Stream, Self, i, Header.ParaNo, Items[i], Part, MarkerItemNo>=0);
       {$IFNDEF RVDONOTUSELISTS}
       if StyleNo=rvsListMarker then begin
         marker.StartFrom := StartFrom;
         marker.Reset     := Reset;
       end;
       {$ENDIF}
       MarkerItemNo := -1;
     end;
   end;
  {.......................................................}
  { Should the first selected item be saved as an empty text line? }
  function ShouldSaveEndOfNonTextItemAsEmptyText: Boolean;
  begin
    Result := (SaveScope=rvfss_Selection) and
      (GetItem(StartItem).AssociatedTextStyleNo>=0) and
      (StartOffs>=GetOffsAfterItem(StartItem)) and
      GetItem(StartItem).GetBoolValue(rvbpSwitchToAssStyleNo) and
      ((StartItem+1=ItemCount) or IsFromNewLine(StartItem+1));
  end;
  {.......................................................}
  { Should the last selected item be saved as an empty text line? }  
  function ShouldSaveBeginningOfNonTextItemAsEmptyText: Boolean;
  begin
    Result := (SaveScope=rvfss_Selection) and
      (GetItem(EndItem).AssociatedTextStyleNo>=0) and
      (EndOffs<=GetOffsBeforeItem(EndItem)) and
      GetItem(EndItem).GetBoolValue(rvbpSwitchToAssStyleNo) and
      IsFromNewLine(EndItem);
  end;
  {.......................................................}
begin
  Result := True;
  if (Items.Count=0) {or (SelectionOnly and not SelectionExists)} then
    exit;
  if SaveScope<>rvfss_Selection then
    DoBeforeSaving;
  FillChar(Header, sizeof(Header), 0);
  Header.Item := RichViewTextItemClass.Create(Self);
  try
    RVFSaveVersionInfo;
    if Root then
      RVFSaveUnits;    
    if (SaveScope<>rvfss_Selection) and (rvfoSaveBack in RVFOptions) then
      RVFSaveBackground;
    if Root then begin
      {$IFDEF RICHVIEWCBDEF3}
      if (rvfoSaveTextStyles in RVFOptions) then
        RVFSaveStyles(RVF_DOCPROP_TEXTSTYLES, GetRVStyle.TextStyles);
      if (rvfoSaveParaStyles in RVFOptions) and (Self=GetRootData) then begin
        RVFSaveStyles(RVF_DOCPROP_PARASTYLES, GetRVStyle.ParaStyles);
        RVFSaveStyles(RVF_DOCPROP_LISTSTYLES, GetRVStyle.ListStyles);
      end;
      {$ENDIF}
      if (rvfoSaveDocProperties in RVFOptions) and (SaveScope<>rvfss_Page) then begin
        RVFSaveDocPropertiesStringList;
        {$IFNDEF RVDONOTUSEDOCPARAMS}
        RVFSaveDocParameters;
        {$ENDIF}
      end;
    end;
    if (SaveScope=rvfss_Page) and (Layout<>nil) then begin
      RVFGetLimits(SaveScope,StartItem,EndItem,StartOffs,EndOffs,StartPart,EndPart, SelectedItem);
      if (StartItem>=0) and (StartItem<=EndItem) then begin
        if (StartOffs>GetOffsBeforeItem(StartItem)) or
           ((StartOffs<=GetOffsBeforeItem(StartItem)) and not IsParaStart(StartItem)) then begin
          Layout.FirstParaAborted := 1;
          {$IFNDEF RVDONOTUSELISTS}
          MarkerItemNo := GetFirstParaItem(StartItem);
          if (MarkerItemNo<>StartItem) and (GetItemStyle(MarkerItemNo)=rvsListMarker) then begin
            Layout.FirstMarkerListNo := TRVMarkerItemInfo(GetItem(MarkerItemNo)).ListNo;
            Layout.FirstMarkerLevel := TRVMarkerItemInfo(GetItem(MarkerItemNo)).Level;
          end;
          {$ENDIF}
        end;
        if (EndOffs<GetOffsAfterItem(EndItem)) or
           ((EndOffs>=GetOffsAfterItem(EndItem)) and not ((EndItem+1=ItemCount) or (IsParaStart(EndItem+1)))) then
          Layout.LastParaAborted := 1;
        {$IFNDEF RVDONOTUSELISTS}
        if (Self=GetRootData) then
          RVFSavePrevMarkers(StartItem);
        {$ENDIF}
      end;
    end;
    if (SaveScope<>rvfss_Selection) then
      RVFSaveSubDocuments;
    if (SaveScope<>rvfss_Selection) and (rvfoSaveLayout in RVFOptions) then begin
      if Layout<>nil then
        RVFSaveLayout
      {
      else begin
        Layout := MakeTemporalLayout;
        if Layout<>nil then
          RVFSaveLayout;
        Layout.Free;
        Layout := nil;
      end;
      }
    end;

    {$IFNDEF RVDONOTUSEINPLACE}
    if (SaveScope=rvfss_Selection) and (GetChosenRVData<>nil) then begin
      Result := GetChosenRVData.SaveRVFToStreamEx(Stream, SaveScope,
        clNone, nil, nil, True);
      Header.Item.Free;
      exit;
    end;
    {$ENDIF}
    RVFGetLimits(SaveScope,StartItem, EndItem, StartOffs, EndOffs,
      StartPart, EndPart, SelectedItem);
    if SelectedItem<>nil then begin
      if RichViewAllowCopyTableCells then
        SelectedItem.SaveRVFSelection(Stream, Self, -1, SelectedItem.ParaNo);
      Header.Item.Free;
      exit;
    end;
    if (StartItem=-1) or (StartItem>EndItem) then begin
      Header.Item.Free;
      exit;
    end;
    if (StartItem=EndItem) and
       ((StartOffs>GetOffsBeforeItem(StartItem)) or
        (EndOffs  <GetOffsAfterItem(EndItem))) then begin
      // only part of text line is selected
      WritePartialTextLine(StartItem, StartOffs, EndOffs, SaveScope=rvfss_Page);
      Header.Item.Free;
      exit;
    end;
    SectionBackOffs := 0;
    if (StartPart<>nil) then begin
      Header.ParaNo := GetItem(StartItem).ParaNo;
      RVFWriteNonText(StartItem, StartPart);
      inc(StartItem);
      if StartItem<ItemCount then
        StartOffs := GetOffsBeforeItem(StartItem);
    end;
    MarkerItemNo := -1;
    {$IFNDEF RVDONOTUSELISTS}
    if (SaveScope=rvfss_Selection) and (StartPart=nil) then begin
      MarkerItemNo := GetFirstParaItem(StartItem);
      if (MarkerItemNo<>StartItem) and (GetItemStyle(MarkerItemNo)=rvsListMarker) then begin
        Header.ParaNo := GetItem(MarkerItemNo).ParaNo;
        RVFWriteNonText(MarkerItemNo, nil);
        MarkerItemNo := GetFirstParaItem(StartItem);
        end
      else
        MarkerItemNo := -1;
    end;
    {$ENDIF}
    if (EndPart<>nil) then begin
      dec(EndItem);
      if EndItem>=0 then
        EndOffs := GetOffsAfterItem(EndItem);
    end;
    for i := StartItem to EndItem do begin
      if (i=StartItem) then begin
        if ((GetItemStyle(i)>=0) or ShouldSaveEndOfNonTextItemAsEmptyText()) and
         ((StartOffs>GetOffsBeforeItem(i)) or (SaveScope=rvfss_Page)) then begin
          WritePartialTextLine(StartItem, StartOffs, GetOffsAfterItem(StartItem), SaveScope=rvfss_Page);
          continue;
        end;
        if (StartOffs>GetOffsBeforeItem(i)) then
          continue;
      end;
      if (i>StartItem) and IsTheSameStyleText then
        inc(SectionBackOffs)
      else begin
        if SectionBackOffs>0 then
          RVFWritePrevStrings(i);
        RVFSetHeaderHeader(i);
        if Header.StyleNo<0 then begin
          if (i<EndItem) or (EndOffs=1) then
            RVFWriteNonText(i, nil)
          end
        else
          SectionBackOffs := 1;
      end;
    end;
    if (Header.StyleNo<0) and ShouldSaveBeginningOfNonTextItemAsEmptyText() then
      WritePartialTextLine(EndItem, GetOffsBeforeItem(EndItem), EndOffs, False)
    else if (Header.StyleNo>=0) and (EndOffs<GetOffsAfterItem(EndItem)) then begin
      dec(SectionBackOffs);
      if SectionBackOffs>0 then
        RVFWritePrevStrings(EndItem);
      WritePartialTextLine(EndItem, GetOffsBeforeItem(EndItem), EndOffs, False);
      end
    else begin
      if SectionBackOffs<>0 then
        RVFWritePrevStrings(EndItem+1);
      if (EndItem=Items.Count-1) and (EndOffs=1) then
        RVFWriteCheckpoint(Stream, rvoTagsArePChars in Options, NotAddedCP);
    end;
    if (EndPart<>nil) then begin
      RVFSetHeaderHeader(EndItem+1);
      RVFWriteNonText(EndItem+1, EndPart);
    end;
  except;
    Result := False;
  end;
  Header.Item.Free;
end;
{$ENDIF}{RVDONOTUSERVF}
{------------------------------------------------------------------------------}
function TCustomRVData.InsertFirstRVFItem(var Index: Integer;
  var s: TRVRawByteString; var item: TCustomRVItemInfo; EditFlag: Boolean;
  var FullReformat: Boolean;
  var NewListNo: Integer): Boolean;
begin
  FullReformat := False;
  NewListNo := -1;
  item.Inserting(Self, s, False);
  Items.InsertObject(Index, s, item);
  item.Inserted(Self, Index);
  {$IFNDEF RVDONOTUSESEQ}
  AddSeqInList(Index);
  {$ENDIF}  
  {$IFNDEF RVDONOTUSELISTS}
  AddMarkerInList(Index);
  {$ENDIF}
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.UpdateItemsPaletteInfo;
var i: Integer;
begin
  if not ShareItems then
    for i := 0 to Items.Count-1 do
      GetItem(i).UpdatePaletteInfo(GetDoInPaletteMode, False,
        GetRVPalette, GetRVLogPalette);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.InsertCheckpoint(ItemNo, Tag: Integer;
                             const Name: String; RaiseEvent: Boolean);
var
  cp: TRVCPInfo;
begin
  if GetItem(ItemNo).Checkpoint<>nil then
    raise ERichViewError.Create(errRVCPExists);
  cp            := TRVCPInfo.Create;
  cp.Tag        := Tag;
  cp.Name       := Name;
  cp.RaiseEvent := RaiseEvent;
  cp.ItemInfo   := GetItem(ItemNo);
  cp.Next := nil;
  cp.Prev := nil;
  GetItem(ItemNo).Checkpoint := cp;
  inc(CPCount);
  UpdateCPPos(cp, ItemNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.UpdateCPPos(cp: TRVCPInfo; ItemNo: Integer);
var cpi: TRVCPInfo;
begin
  if ItemNo=-1 then exit;
  UpdateCPItemNo;
  cp.Prev := nil;
  cp.Next := nil;
  if FirstCP = nil then begin
    FirstCP := cp;
    LastCP  := cp;
    end
  else if FirstCP.ItemNo>cp.ItemNo then begin
    cp.Next := FirstCP;
    FirstCP.Prev := cp;
    FirstCP      := cp;
    end
  else if LastCP.ItemNo<=cp.ItemNo then begin
    LastCP.Next := cp;
    cp.Prev := LastCP;
    LastCP := cp
    end
  else begin
    cpi := FirstCP;
    while cpi.Next<>nil do begin
      if cpi.Next.ItemNo>cp.ItemNo then break;
      cpi := cpi.Next;
    end;
    if cpi.Next<>nil then cpi.Next.Prev := cp;
    cp.Next := cpi.Next;
    cpi.Next := cp;
    cp.Prev := cpi;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.ShareItemsFrom(Source: TCustomRVData);
begin
  if ShareItems then begin
    Clear;
    FItems := Source.Items;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AssignItemsFrom(Source: TCustomRVData);
begin
  FItems := Source.Items;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AppendFrom(Source: TCustomRVData);
var i: Integer;
    item,itemcopy: TCustomRVItemInfo;
begin
  if (rvoTagsArePChars in Options) <> (rvoTagsArePChars in Source.Options) then
    raise ERichViewError.Create(errRVTagsTypesMismatch);
  for i:=0 to Source.Items.Count-1 do begin
    item := Source.GetItem(i);
    itemcopy := RV_DuplicateItem(item, Self, True);
    if itemcopy.GetBoolValue(rvbpValid) then begin
      if itemcopy.SameAsPrev then
        itemcopy.ParaNo := -1;
      AddItemR(Source.Items[i],itemcopy);
      {$IFNDEF RVDONOTUSESEQ}
      AddSeqInList(ItemCount-1);
      {$ENDIF}
      {$IFNDEF RVDONOTUSELISTS}
      AddMarkerInList(ItemCount-1);
      {$ENDIF}
      end
    else
      InternalFreeItem(itemcopy,False);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.UpdateCPItemNo;
var i,cnt: Integer;
begin
  cnt := 0;
  if cnt=CPCount then exit;
  for i := 0 to Items.Count-1 do
    if GetItem(i).Checkpoint<>nil then begin
      GetItem(i).Checkpoint.ItemNo := i;
      inc(cnt);
      if cnt=CPCount then
        exit;
    end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsDelimiterA(ch: TRVAnsiChar; CodePage: TRVCodePage): Boolean;
var Del: String;
begin
  Del := GetDelimiters;
  {$IFDEF RVUNICODESTR}
  Result := Pos(RVU_RawUnicodeToWideString(RVU_AnsiToUnicode(CodePage, ch)), Del)<>0;
  {$ELSE}
  Result := RV_CharPos(PRVAnsiChar(Del), ch, Length(Del))<>0;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsDelimiterW(ch: TRVUnicodeChar): Boolean;
var Del: String;
begin
  Del := GetDelimiters;
  {$IFDEF RVUNICODESTR}
  Result := Pos(ch, Del)<>0;
  {$ELSE}
  Result := (ord(ch)<256) and (Pos(Char(ch), Del)<>0);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsDelimiter(const s: TRVRawByteString; Index: Integer;
  ItemOptions: TRVItemOptions; CodePage: TRVCodePage): Boolean;
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  if rvioUnicode in ItemOptions then
    Result := IsDelimiterW(TRVUnicodeChar(PWord(PRVAnsiChar(s)+(Index-1)*2)^))
  else
  {$ENDIF}
    Result := IsDelimiterA(s[Index], CodePage);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemOptions(ItemNo: Integer): TRVItemOptions;
begin
  Result := GetItem(ItemNo).ItemOptions;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetStyleCodePage(StyleNo: Integer): TRVCodePage;
begin
  {$IFDEF RICHVIEWCBDEF3}
  if (GetRVStyle<>nil) then
    if (StyleNo>=0) and (GetRVStyle.TextStyles[StyleNo].Charset<>DEFAULT_CHARSET) then
      Result := RVU_Charset2CodePage(GetRVStyle.TextStyles[StyleNo].Charset)
    else
      Result := GetRVStyle.DefCodePage
  else
  {$ENDIF}
    Result := CP_ACP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemCodePage(ItemNo: Integer): TRVCodePage;
begin
  Result := GetStyleCodePage(GetActualStyle(GetItem(ItemNo)))
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemCodePage2(Item: TCustomRVItemInfo): TRVCodePage;
begin
  Result := GetStyleCodePage(GetActualStyle(Item));
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetStyleLocale(StyleNo: Integer): Cardinal;
begin
  {$IFDEF RICHVIEWCBDEF3}
  if (GetRVStyle<>nil) and (StyleNo>=0) then
    Result := RVMAKELCID(RVU_Charset2Language(GetRVStyle.TextStyles[StyleNo].Charset))
  else
  {$ENDIF}
    Result := RVMAKELCID(LANG_NEUTRAL);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetDefaultCodePage: TRVCodePage;
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  if (GetRVStyle<>nil) then
    Result := GetRVStyle.DefCodePage
  else
  {$ENDIF}
    Result := CP_ACP;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetDoInPaletteMode: TRVPaletteAction;
begin
  Result := GetRootData.GetDoInPaletteMode;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetOptions: TRVOptions;
begin
  Result := GetRootData.GetOptions;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetOptions(const Value: TRVOptions);
begin
  GetRootData.SetOptions(Value);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetDocProperties: TStringList;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVLogPalette: PLogPalette;
begin
  Result := GetRootData.GetRVLogPalette;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVPalette: HPALETTE;
begin
  Result := GetRootData.GetRVPalette;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetDelimiters: String;
begin
  Result := GetRootData.GetDelimiters;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVFParaStylesReadMode: TRVFReaderStyleMode;
begin
  Result := GetRootData.GetRVFParaStylesReadMode;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVFTextStylesReadMode: TRVFReaderStyleMode;
begin
  Result := GetRootData.GetRVFTextStylesReadMode;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.RVFPictureNeeded(const ItemName: String;
  ItemTag: Integer; PictureInsideRVF: Boolean): TGraphic;
begin
  Result := GetRootData.RVFPictureNeeded(ItemName, ItemTag,PictureInsideRVF);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveComponentToFile(const Path: String;
  SaveMe: TComponent; SaveFormat: TRVSaveFormat): String;
begin
  Result := GetAbsoluteRootData.SaveComponentToFile(Path, SaveMe, SaveFormat);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveItemToFile(const Path: String;
  RVData: TCustomRVData; ItemNo: Integer; SaveFormat: TRVSaveFormat;
  Unicode: Boolean; var Text: TRVRawByteString): Boolean;
begin
  Result := GetAbsoluteRootData.SaveItemToFile(Path, RVData, ItemNo, SaveFormat,
    Unicode, Text);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.ImportPicture(const Location: String; Width,
  Height: Integer; var Invalid: Boolean): TGraphic;
begin
  Result := GetAbsoluteRootData.ImportPicture(Location, Width, Height, Invalid);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemHint(RVData: TCustomRVData; ItemNo: Integer;
  const UpperRVDataHint: String): String;
begin
  Result := GetAbsoluteParentData.GetItemHint(RVData, ItemNo, UpperRVDataHint);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.RVFControlNeeded(const ItemName: String; ItemTag: Integer): TControl;
begin
  Result := GetRootData.RVFControlNeeded(ItemName, ItemTag);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.RVFImageListNeeded(ImageListTag: Integer): TCustomImageList;
begin
  Result := GetRootData.RVFImageListNeeded(ImageListTag);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.HTMLSaveImage(RVData: TCustomRVData;
  ItemNo: Integer; const Path: String; BackgroundColor: TColor;
  var Location: String; var DoDefault: Boolean);
begin
  GetAbsoluteRootData.HTMLSaveImage(RVData, ItemNo, Path, BackgroundColor,
    Location, DoDefault);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SaveImage2(Graphic: TGraphic;
  SaveFormat: TRVSaveFormat; const Path, ImagePrefix: String;
  var ImageSaveNo: Integer; var Location: String; var DoDefault: Boolean);
begin
  GetAbsoluteRootData.SaveImage2(Graphic, SaveFormat, Path, ImagePrefix,
    ImageSaveNo, Location, DoDefault);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVStyle: TRVStyle;
begin
  Result := GetParentData.GetRVStyle;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetParentControl: TWinControl;
begin
  Result := GetRootData.GetParentControl;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.ReadHyperlink(const Target, Extras: String;
  DocFormat: TRVLoadFormat; var StyleNo, ItemTag: Integer;
  var ItemName: TRVRawByteString);
begin
  GetRootData.ReadHyperlink(Target, Extras, DocFormat, StyleNo, ItemTag, ItemName);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.WriteHyperlink(id: Integer; RVData: TCustomRVData;
  ItemNo: Integer; SaveFormat: TRVSaveFormat; var Target, Extras: String);
begin
  GetAbsoluteRootData.WriteHyperlink(id, RVData, ItemNo, SaveFormat,
    Target, Extras);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.ControlAction(RVData: TCustomRVData;
  ControlAction: TRVControlAction; ItemNo: Integer; Item: TCustomRVItemInfo);
begin
  if (item is TRVControlItemInfo) then
    GetAbsoluteRootData.ControlAction2(RVData, ControlAction, ItemNo,
      TRVControlItemInfo(item).Control);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.ItemAction(ItemAction: TRVItemAction;
  Item: TCustomRVItemInfo; var Text: TRVRawByteString; RVData: TCustomRVData);
begin

end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TCustomRVData.AfterReadNote(RVData: TCustomRVData; ItemNo: Integer);
begin
  GetAbsoluteRootData.AfterReadNote(RVData, ItemNo);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoBeforeSaving;
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.Replace0(var s: TRVRawByteString);
var p: Integer;
begin
  while True do begin
    p := RVPos(#0,s);
    if p=0 then break;
    s[p] := RVDEFAULTCHARACTER;
  end;
end;
{------------------------------- RTF ------------------------------------------}
procedure TCustomRVData.SetRTFOptions(const Value: TRVRTFOptions);
begin
  GetRootData.SetRTFOptions(Value);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRTFOptions: TRVRTFOptions;
begin
  Result := GetRootData.GetRTFOptions;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.MakeRTFTables(ColorList: TRVColorList;
  ListOverrideCountList: TRVIntegerList; TopLevel: Boolean);
   const ArrDefColorTable: array [0..16] of TColor =
         (
         clWindowText, clBlack, clBlue, clAqua,
         clLime, clFuchsia, clRed, clYellow,
         clWhite, clNavy, clTeal, clGreen,
         clPurple, clMaroon, clOlive,
         clGray, clSilver
         );
   var i{$IFNDEF RVDONOTUSELISTS},j{$ENDIF}: Integer;
       RVStyle: TRVStyle;
begin
   RVStyle := GetRVStyle;
   if TopLevel then begin
     ColorList.Clear;
     ListOverrideCountList.Clear;
     for i := Low(ArrDefColorTable) to High(ArrDefColorTable) do
       ColorList.Add(ArrDefColorTable[i]);
     for i := 0 to RVStyle.TextStyles.Count-1 do
       with RVStyle.TextStyles[i] do begin
         ColorList.AddUnique(Color);
         ColorList.AddUnique(BackColor);
         ColorList.AddUnique(HoverColor);
         ColorList.AddUnique(HoverBackColor);
         ColorList.AddUnique(UnderlineColor);
         ColorList.AddUnique(HoverUnderlineColor);         
       end;
     for i := 0 to RVStyle.ParaStyles.Count-1 do
       with RVStyle.ParaStyles[i] do begin
         if (Border.Style<>rvbNone) then
           ColorList.AddUnique(Border.Color);
         ColorList.AddUnique(Background.Color);
       end;
     {$IFNDEF RVDONOTUSELISTS}
     for i := 0 to RVStyle.ListStyles.Count-1 do begin
       ListOverrideCountList.Add(1);
       for j := 0 to RVStyle.ListStyles[i].Levels.Count-1 do
         with RVStyle.ListStyles[i].Levels[j] do
           if UsesFont then
             ColorList.AddUnique(Font.Color);
     end;
     {$ENDIF}
   end;
   for i := 0 to Items.Count-1 do
     with GetItem(i) do
       if StyleNo<0 then
         FillRTFTables(ColorList, ListOverrideCountList, Self);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
function TCustomRVData.SaveRTF(const FileName: String; SelectionOnly: Boolean;
  Color: TColor; Background: TRVBackground):Boolean;
var Stream: TFileStream;
begin
  try
    Stream := TFileStream.Create(FileName,fmCreate);
    try
      Result := SaveRTFToStream(Stream, ExtractFilePath(FileName), SelectionOnly,
        0, Color, Background, nil, nil, nil, nil, nil, 0.0, True, False, nil, nil);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure RVSaveFontToRTF(Stream: TStream; Font: TFont;
                          ColorList: TRVColorList; FontTable: TRVRTFFontTable;
                          RVStyle: TRVStyle);
var idx: Integer;
    {$IFDEF RICHVIEWCBDEF3}
    Language: Cardinal;
    {$ENDIF}
begin
  idx := FontTable.Find(Font.Name {$IFDEF RICHVIEWCBDEF3}, Font.Charset{$ENDIF});
  if idx>=0 then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\f%d', [idx]));
  if fsBold in Font.Style then
    RVFWrite(Stream, '\b');
  if fsItalic in Font.Style then
    RVFWrite(Stream, '\i');
  if fsUnderline in Font.Style then
    RVFWrite(Stream, '\ul');
  if fsStrikeOut in Font.Style then
    RVFWrite(Stream, '\strike');
  RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\fs%d', [Font.Size*2]));
  {$IFDEF RICHVIEWCBDEF3}
  if (Font.Charset<>DEFAULT_CHARSET) and (Font.Charset<>RVStyle.TextStyles[0].Charset) then begin
    Language := RVU_Charset2Language(Font.Charset);
    if Language<>0 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\lang%d', [Language]));
  end;
  {$ENDIF}
  if Font.Color<>clWindowText then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\cf%d', [ColorList.IndexOf(Pointer(Font.Color))]));
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
procedure TCustomRVData.SaveRTFListTable97(Stream: TStream; ColorList: TRVColorList;
  ListOverrideOffsetsList: TRVIntegerList;
  FontTable: TRVRTFFontTable; tpp: Double; Header, Footer: TCustomRVData);
var IDList, TemplateIDList: TRVIntegerList;
    i,j, id, levelcount, idx: Integer;
    s1,s2: TRVAnsiString;
    RVStyle: TRVStyle;
    LevelInfo: TRVListLevel;
    {...................................................}
    function GetLevelNfc(LevelInfo: TRVListLevel): Integer;
    begin
      case LevelInfo.ListType of
        rvlstBullet,
        {$IFNDEF RVDONOTUSEUNICODE}
        rvlstUnicodeBullet,
        {$ENDIF}
        rvlstPicture, rvlstImageList:
          Result := 23;
        rvlstDecimal,rvlstImageListCounter:
          Result := 0;
        rvlstLowerAlpha:
          Result := 4;
        rvlstUpperAlpha:
          Result := 3;
        rvlstLowerRoman:
          Result := 2;
        rvlstUpperRoman:
          Result := 1;
        else
          Result := 255;
      end;
    end;
    {...................................................}
    function GetLevelJc(LevelInfo: TRVListLevel): Integer;
    begin
      case LevelInfo.MarkerAlignment of
        rvmaLeft:
          Result := 0;
        rvmaCenter:
          Result := 1;
        rvmaRight:
          Result := 2;
        else
          Result := -1;
      end;
    end;
    {...................................................}
    procedure GetLevelText(LevelInfo: TRVListLevel;
      var LevelText, LevelNumbers: TRVAnsiString);
    var  s: String;
        i: Integer;
    begin
      case LevelInfo.ListType of
        rvlstBullet:
          begin
            {$IFDEF RVUNICODESTR}
            LevelText := RVMakeRTFStrW(LevelInfo.FormatString, RVStyle.DefCodePage,
              rvrtfDuplicateUnicode in RTFOptions, False, False, False);
            {$ELSE}
            LevelText := RVMakeRTFStr(LevelInfo.FormatString, False, False, False);
            {$ENDIF}
            LevelText := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\''%.2x%s',[Length(LevelInfo.FormatString),LevelText]);
            LevelNumbers := '';
          end;
        {$IFNDEF RVDONOTUSEUNICODE}
        {$IFDEF RICHVIEWCBDEF3}
        rvlstUnicodeBullet:
          begin
            LevelText := RVMakeRTFStrW(LevelInfo.FormatStringW, RVStyle.DefCodePage,
              rvrtfDuplicateUnicode in RTFOptions, False, False, False);
            LevelText := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\''%.2x%s',[Length(LevelInfo.FormatStringW),LevelText]);
            LevelNumbers := '';
          end;
        {$ENDIF}
        {$ENDIF}
        rvlstDecimal,rvlstImageListCounter,
        rvlstLowerAlpha,rvlstUpperAlpha,
        rvlstLowerRoman,rvlstUpperRoman:
          begin
            {$IFDEF RVUNICODESTR}
            LevelText := RVMakeRTFStrW(LevelInfo.FormatString, RVStyle.DefCodePage,
              rvrtfDuplicateUnicode in RTFOptions, False, False, True);
            {$ELSE}
            LevelText := RVMakeRTFStr(LevelInfo.FormatString, False, False, True);
            {$ENDIF}
            LevelText := Format(LevelText, ['\''00','\''01','\''02','\''03','\''04','\''05','\''06','\''07','\''08']);
            s := Format(LevelInfo.FormatString, [#0, #1, #2, #3, #4, #5, #6, #7, #8]);
            LevelNumbers := '';
            for i := 1 to Length(s) do
              if s[i]<#9 then
                LevelNumbers := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%s\''%.2x',[LevelNumbers,i]);
            LevelText := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\''%.2x%s',[Length(s),LevelText]);
          end;
        else
          begin
            LevelText := '\''00';
            LevelNumbers := '';
          end;
      end;
    end;
    {...................................................}
    // Returns RVData in the same order as their bodies are saved in RTF
    function GetRVDataByIndex(RVDataIndex: Integer; var RVData: TCustomRVData): Boolean;
    begin
      Result := True;
      case RVDataIndex of
        0: RVData := Header;
        1: RVData := Footer;
        2: RVData := Self;
        else Result := False;
      end;
    end;
    {...................................................}
    procedure SaveListOverrideTable;
    var i,j,k, Index, RVDataIndex: Integer;
        Markers: TRVMarkerList;
        Marker: TRVMarkerItemInfo;
        RVData: TCustomRVData;
    begin
      index := 1;
      for i := 0 to IDList.Count-1 do begin
        RVFWriteLine(Stream,
          {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\listoverride\listid%d\listoverridecount0\ls%d}', [IDList[i],index]));
        inc(index);
        RVDataIndex := 0;
        while GetRVDataByIndex(RVDataIndex, RVData) do begin
          if RVData<>nil then begin
            Markers := RVData.GetMarkers(False);
            if (Markers<>nil) and (ListOverrideOffsetsList[i]>1) then begin
              for j := 0 to Markers.Count-1 do begin
                Marker := Markers[j];
                if (Marker.ListNo=i) and (Marker.Level>=0) and Marker.Reset then begin
                  RVFWrite(Stream,
                    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\listoverride\listid%d\listoverridecount%d',
                    [IDList[i],Marker.Level+1]));
                  for k := 0 to Marker.Level-1 do
                    RVFWrite(Stream, '{\lfolevel}');
                  RVFWrite(Stream,
                    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\lfolevel\listoverridestartat\levelstartat%d}', [Marker.StartFrom]));
                  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\ls%d}', [index]));
                  inc(index);
                end;
              end;
            end;
          end;
          inc(RVDataIndex);
        end;
      end;
    end;
    {...................................................}
    // transforming a list of counts to a list of offsets
    procedure FinalizeListOverrideTable;
    var i, prevcount,curcount: Integer;
    begin
      if RVStyle.ListStyles.Count>0 then begin
        prevcount := ListOverrideOffsetsList[0];
        ListOverrideOffsetsList[0] := 1; // starting from 1
        for i := 1 to RVStyle.ListStyles.Count-1 do begin
          curcount := ListOverrideOffsetsList[i];
          ListOverrideOffsetsList[i] := ListOverrideOffsetsList[i-1]+prevcount;
          prevcount := curcount;
        end;
      end;
    end;
    {...................................................}
begin
  RVStyle := GetRVStyle;
  if (RVStyle.ListStyles.Count=0) then begin
    RVFWriteLine(Stream, '');
    exit;
  end;

  IDList := TRVIntegerList.Create;
  TemplateIDList := TRVIntegerList.Create;
  try
    // writing list table
    RVFWrite(Stream, '{\*\listtable');
    for i := 0 to RVStyle.ListStyles.Count-1 do begin
      repeat
        id := Random(MaxInt);
      until IDList.IndexOf(Pointer(id))<0;
      TemplateIDList.Add(id);
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\list\listtemplateid%d',[id]));
      if RVStyle.ListStyles[i].Levels.Count=1 then
        RVFWrite(Stream, '\listsimple1');
      RVFWrite(Stream, GetExtraRTFCode(rv_rtfs_ListStyle, RVStyle.ListStyles[i], i , -1, False));
      RVFWriteLine(Stream, '');
      levelcount := RVStyle.ListStyles[i].Levels.Count;
      if levelcount>1 then
        levelcount := 9;
      for j := 0 to levelcount-1 do begin
        // writing list level
        if j<RVStyle.ListStyles[i].Levels.Count then
          idx := j
        else
          idx := RVStyle.ListStyles[i].Levels.Count-1;
        LevelInfo := RVStyle.ListStyles[i].Levels[idx];
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\listlevel\levelnfc%d\leveljc%d\li%d\fi%d\jclisttab\tx%d',
          [GetLevelNfc(LevelInfo), GetLevelJc(LevelInfo),
           RVStyle.GetAsTwips(LevelInfo.LeftIndent),
           RVStyle.GetAsTwips(LevelInfo.MarkerIndent-LevelInfo.LeftIndent),
           RVStyle.GetAsTwips(LevelInfo.FirstIndent+LevelInfo.LeftIndent)]));
        if GetLevelNfc(LevelInfo)<>23 then
          RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\levelstartat%d', [LevelInfo.StartFrom]));
        if rvloLegalStyleNumbering in LevelInfo.Options then
          RVFWrite(Stream, '\levellegal1');
        if not (rvloLevelReset in LevelInfo.Options) then
          RVFWrite(Stream, '\levelnorestart1');
        GetLevelText(LevelInfo, s1, s2);
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\leveltext%s;}{\levelnumbers%s;}', [s1,s2]));
        if LevelInfo.UsesFont then
          RVSaveFontToRTF(Stream, LevelInfo.Font, ColorList, FontTable, RVStyle);
        RVFWrite(Stream, GetExtraRTFCode(rv_rtfs_ListStyle, RVStyle.ListStyles[i], i , j, False)); 
        RVFWriteLine(Stream, '}');
      end;
      repeat
        id := Random(MaxInt);
      until TemplateIDList.IndexOf(Pointer(id))<0;
      IDList.Add(id);
      RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\listid%d}',[id]));
    end;
    RVFWriteLine(Stream, '}');
    // writing list override table (in the order as subdocuments are saved in RTF)
    RVFWriteLine(Stream, '{\*\listoverridetable');
    SaveListOverrideTable;
    RVFWriteLine(Stream, '}');
    FinalizeListOverrideTable
  finally
    IDList.Free;
    TemplateIDList.Free;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVData.ShouldSaveTextToRTF(StyleNo: Integer): Boolean;
begin
  with GetRVStyle.TextStyles[StyleNo] do
    Result := (rvteoRTFCode in Options) or not (rvteoHTMLCode in Options)
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SaveRTFToStream(Stream: TStream; const Path: String;
  SelectionOnly: Boolean; Level: Integer; Color: TColor;
  Background: TRVBackground; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVRTFFontTable; tpp: Double; CompleteDocument, HiddenParent: Boolean;
  Header, Footer: TCustomRVData): Boolean;
var RVStyle: TRVStyle;
    {$IFNDEF RVDONOTUSELISTS}
    LastListLevel: TRVListLevel;
    {$ENDIF}
    LastParaNo, LastTextStyleNo, CurTextStyleNo: Integer;

    function GetTwipsPerPixel: Double;
    var DC: HDC;
    begin
      DC := CreateCompatibleDC(0);
      if RichViewPixelsPerInch>0 then
        Result := (72*20) / RichViewPixelsPerInch
      else
        Result := (72*20) / GetDeviceCaps(DC, LOGPIXELSY);
      DeleteDC(DC);
    end;
   {.................................................}
   procedure MakeFontTable(FontTable: TRVRTFFontTable;StyleToFont: TRVIntegerList);
   var i {$IFNDEF RVDONOTUSELISTS},j{$ENDIF}: Integer;
       Index: Integer;
   begin
     FontTable.Clear;
     StyleToFont.Clear;
     for i := 0 to RVStyle.TextStyles.Count-1 do begin
       Index := FontTable.AddUnique(RVStyle.TextStyles[i].FontName
         {$IFDEF RICHVIEWCBDEF3}
         , RVStyle.TextStyles[i].Charset
         {$ENDIF});
       StyleToFont.Add(Index);
     end;
     {$IFNDEF RVDONOTUSELISTS}
     for i := 0 to RVStyle.ListStyles.Count-1 do
       for j := 0 to RVStyle.ListStyles[i].Levels.Count-1 do
         if RVStyle.ListStyles[i].Levels[j].UsesFont then
           with RVStyle.ListStyles[i].Levels[j].Font do
             FontTable.AddUnique(Name {$IFDEF RICHVIEWCBDEF3}, Charset{$ENDIF});
     {$ENDIF}
   end;
   {.................................................}
   procedure SaveFontTable(FontTable: TRVRTFFontTable);
   var i: Integer;
       Charset: Integer;
       FontName: TRVAnsiString;
   begin
     RVFWrite(Stream, '{\fonttbl');
     for i := 0 to FontTable.Count-1 do begin
       {$IFDEF RICHVIEWCBDEF3}
       Charset := FontTable[i].Charset;
       {$ELSE}
       Charset := 1;
       {$ENDIF}
       RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\f%d\fnil',[i]));
       if Charset<>1 then
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\fcharset%d',[Charset]));
       FontName := MakeRTFIdentifierStr(FontTable[i].FontName, CP_ACP, rvrtfDuplicateUnicode in RTFOptions);
       RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(' %s;}',[FontName]));
     end;
     RVFWrite(Stream, '}');
   end;
   {.................................................}
   procedure SaveColorTable(List: TList);
   var i: Integer;
       Color: Integer;
   begin
     RVFWrite(Stream, '{\colortbl;');
     for i := 1 to List.Count-1 do begin
       Color := ColorToRGB(Integer(List.Items[i]));
       RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\red%d\green%d\blue%d;',
                [
                  Color and $0000FF,
                  (Color and $00FF00) shr 8,
                  (Color and $FF0000) shr 16
                ]));
     end;
     RVFWrite(Stream, '}');
   end;
   {.................................................}
   procedure SaveTextStyle(StyleNo: Integer; StyleToFont, ColorTable: TRVIntegerList;
     ToStyleSheet: Boolean);
   begin
     if not ToStyleSheet then
       LastTextStyleNo := StyleNo;
     if StyleNo>=RVStyle.TextStyles.Count then
       StyleNo := 0;
     RVStyle.TextStyles[StyleNo].SaveRTFToStream(Stream, StyleNo, tpp,
       StyleToFont, ColorTable);
     if not (rvteoHidden in RVStyle.TextStyles[StyleNo].Options) and HiddenParent then
       RVFWrite(Stream, '\v ');
     with RVStyle.TextStyles[StyleNo] do begin
       RVFWrite(Stream, GetExtraRTFCode(rv_rtfs_TextStyle,
         RVStyle.TextStyles[StyleNo], StyleNo, -1, ToStyleSheet));
       RVFWrite(Stream, ' ');
     end;
   end;
   {.................................................}
   {$IFNDEF RVDONOTUSELISTS}
   function IsListLevelNew(item: TCustomRVItemInfo): Boolean;
   begin
     if item.StyleNo<>rvsListMarker then begin
       Result := LastListLevel<>nil;
       exit;
     end;
     Result := TRVMarkerItemInfo(item).GetLevelInfo(RVStyle)<>LastListLevel;
   end;
   {$ENDIF}
   {.................................................}
   {$IFNDEF RVDONOTUSETABS}
   function GetTabAlignStr(Align: TRVTabAlign): TRVAnsiString;
   begin
     case Align of
       rvtaRight:  Result := '\tqr';
       rvtaCenter: Result := '\tqc';
       else        Result := '';
     end;
   end;
   {.................................................}
   function GetTabLeader(const LeaderStr: String): TRVAnsiString;
   begin
     if LeaderStr='' then
       Result := ''
     else
       case LeaderStr[1] of
         '-':  Result := '\tlhyph';
         '_':  Result := '\tlul';
         RVCHAR_MIDDLEDOT: Result := '\tlmdot';
         '=': Result := '\tleq';
         else  Result := '\tldot';
       end;
   end;
   {.................................................}
   procedure SaveTabs(ParaNo, MinAllowedPosition: Integer);
   var i: Integer;
   begin
     with RVStyle.ParaStyles[ParaNo] do
       for i := 0 to Tabs.Count-1 do
         if Tabs[i].Position>MinAllowedPosition then begin
           RVFWrite(Stream, GetTabAlignStr(Tabs[i].Align)+GetTabLeader(Tabs[i].Leader)+
             '\tx'+RVIntToStr(RVStyle.GetAsTwips(Tabs[i].Position)));
         end;
   end;
   {$ENDIF}   
   {.................................................}
   procedure SaveParaStyle(ParaNo: Integer; ColorTable: TList; ToStyleSheet: Boolean;
     item: TCustomRVItemInfo);
   var s,s2,s3,s4: TRVAnsiString;
       bw,sb,sa: TRVStyleLength;
       {$IFNDEF RVDONOTUSETABS}
       MinAllowedTabPos: Integer;
       {$ENDIF}
   begin
     if not ToStyleSheet then
       LastParaNo := ParaNo;
     {$IFNDEF RVDONOTUSETABS}
     MinAllowedTabPos := 0;
     {$ENDIF}
     with RVStyle.ParaStyles[ParaNo] do begin
       case Alignment of
         rvaLeft:
           s := 'l';
         rvaRight:
           s := 'r';
         rvaCenter:
           s := 'c';
         rvaJustify:
           s := 'j';
       end;
       case LineSpacingType of
         rvlsPercent:
           if LineSpacing<>100 then
             RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\sl%d\slmult1', [LineSpacing*240 div 100]));
         rvlsLineHeightAtLeast:
           RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\sl%d\slmult0', [RVStyle.GetAsTwips(LineSpacing)]));
         rvlsLineHeightExact:
           RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\sl%d\slmult0', [-RVStyle.GetAsTwips(LineSpacing)]));
       end;
       if rvpaoKeepLinesTogether in Options then
         RVFWrite(Stream, '\keep');
       if rvpaoKeepWithNext in Options then
         RVFWrite(Stream, '\keepn');

       {$IFNDEF RVDONOTUSELISTS}
       LastListLevel := nil;
       if (item<>nil) and (item.StyleNo = rvsListMarker) and
          (TRVMarkerItemInfo(item).GetLevelInfo(RVStyle)<>nil) then begin
         LastListLevel := TRVMarkerItemInfo(item).GetLevelInfo(RVStyle);
         with LastListLevel do begin
           {$IFNDEF RVDONOTUSETABS}
           MinAllowedTabPos := FirstIndent+LeftIndent; // MinAllowedTabPos must be in RVStyle.Units
           {$ENDIF}
           RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\li%d\fi%d\jclisttab\tx%d',
            [RVStyle.GetAsTwips(LeftIndent),
             RVStyle.GetAsTwips(MarkerIndent-LeftIndent),
             RVStyle.GetAsTwips(FirstIndent+LeftIndent)]))
         end;
         end
       else
       {$ENDIF}
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\fi%d\li%d',
           [RVStyle.GetAsTwips(FirstIndent), RVStyle.GetAsTwips(LeftIndent)]));
       {$IFNDEF RVDONOTUSETABS}
       SaveTabs(ParaNo, MinAllowedTabPos);
       {$ENDIF}
       sb := SpaceBefore;
       sa := SpaceAfter;
       RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\q%s\ri%d',
         [s, RVStyle.GetAsTwips(RightIndent)]));
       case BiDiMode of
         rvbdLeftToRight:
           RVFWrite(Stream, '\ltrpar');
         rvbdRightToLeft:
           RVFWrite(Stream, '\rtlpar');
       end;
       If IsHeading(9) then
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\outlinelevel%d', [OutlineLevel-1]));
       if Background.Color<>clNone then
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\cbpat%d', [ColorTable.IndexOf(Pointer(Background.Color))]));
       if (Border.Style<>rvbNone) and (Border.Color<>clNone) then begin
         RVFWrite(Stream, '\brdrbtw'); // <- does not work, unfortunately
         s2 := '\brdr';
         bw := Border.Width;
         case Border.Style of
           rvbSingle:
             s2 := s2+'s';
           rvbDouble:
             s2 := s2+'db';
           rvbTriple:
             s2 := s2+'triple';
           rvbThickInside:
             begin
               s2 := s2+'thtnmg';
               bw := bw*2;
             end;
           rvbThickOutside:
             begin
               s2 := s2+'tnthmg';
               bw := bw*2;
             end;
         end;
         case Border.Style of
           rvbThickInside:
             s3 := '\brdrtnthmg';
           rvbThickOutside:
             s3 := '\brdrthtnmg';
           else
             s3 := s2;
         end;
         s4 := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrcf%d\brdrw%d',
               [ColorTable.IndexOf(Pointer(Border.Color)),
                RVStyle.GetAsTwips(bw)
               ]);
         s2 := s2 + s4;
         s3 := s3 + s4;
         s := '';
         with Border.VisibleBorders do begin
           if Left   then s := s+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrl\brsp%d',[RVStyle.GetAsTwips(Border.BorderOffsets.Left)])+s2;
           if Top    then begin
             s := s+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrt\brsp%d',[RVStyle.GetAsTwips(Border.BorderOffsets.Top)])+s2;
             dec(sb, Border.BorderOffsets.Top);
             if sb<0 then
               sb := 0;
           end;
           if Right  then s := s+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrr\brsp%d',[RVStyle.GetAsTwips(Border.BorderOffsets.Right)])+s3;
           if Bottom then begin
             s := s+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\brdrb\brsp%d',[RVStyle.GetAsTwips(Border.BorderOffsets.Bottom)])+s3;
             dec(sa, Border.BorderOffsets.Bottom);
             if sa<0 then
               sa := 0;
           end;
         end;
         RVFWrite(Stream, s);
       end;
       RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\sb%d\sa%d',
         [RVStyle.GetAsTwips(sb), RVStyle.GetAsTwips(sa)]));
       if not ToStyleSheet and (Level<>1) then
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\itap%d',[Level]));
       if Level=1 then
         RVFWrite(Stream, '\intbl');

       RVFWrite(Stream, GetExtraRTFCode(rv_rtfs_ParaStyle, RVStyle.ParaStyles[ParaNo], ParaNo, -1, ToStyleSheet));
       RVFWrite(Stream, ' ');
     end;
   end;
   {.................................................}
   procedure SaveStyleSheet(StyleToFont, ColorTable: TRVIntegerList);
   var i: Integer;
   begin
     RVFWrite(Stream, '{\stylesheet');
     for i := 0 to RVStyle.ParaStyles.Count-1 do begin
       if RVStyle.ParaStyles[i].Standard then begin
         RVFWrite(Stream, '{');
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\s%d',[i]));
         SaveParaStyle(i, ColorTable,True,nil);
         RVFWrite(Stream, MakeRTFIdentifierStr(RVStyle.ParaStyles[i].StyleName,
           RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions));
         RVFWrite(Stream, ';}');
       end;
     end;
     for i := 0 to RVStyle.TextStyles.Count-1 do begin
       if RVStyle.TextStyles[i].Standard then begin
         RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\*\cs%d',[i+RVStyle.ParaStyles.Count]));
         SaveTextStyle(i, StyleToFont, ColorTable,True);
         RVFWrite(Stream, MakeRTFIdentifierStr(RVStyle.TextStyles[i].StyleName,
           RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions)+';}');
       end;
     end;
     RVFWrite(Stream, '}');
   end;
   {.................................................}
   procedure SaveHeader(ColorList: TRVColorList; StyleToFont: TRVIntegerList;
                        FontTable: TRVRTFFontTable);
   var CodePage: TRVCodePage;
       Language: Cardinal;
       UC: Integer;
   begin
     {$IFNDEF RVDONOTUSEUNICODE}
     {$IFDEF RICHVIEWCBDEF3}
     CodePage := GetRVStyle.DefCodePage;
     {$IFDEF RVLANGUAGEPROPERTY}
     Language := GetRVStyle.TextStyles[0].Language;
     if Language=0 then
       Language := $0400;
     {$ELSE}
     Language := RVU_Charset2Language(GetRVStyle.TextStyles[0].CharSet);
     {$ENDIF}
     {$ELSE}
     CodePage := 1252;
     Language := $0400;
     {$ENDIF}
     {$ELSE}
     CodePage := 1252;
     Language := $0400;
     {$ENDIF}
     if rvrtfDuplicateUnicode in RTFOptions then
       UC := 1
     else
       UC := 0;
     RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\rtf1\ansi\ansicpg%d\uc%d\deff0\deflang%d\deflangfe%d',
       [CodePage, UC, Language, Language]));
     case GetBiDiMode of
       rvbdLeftToRight:
         RVFWrite(Stream, '\ltrdoc');
       rvbdRightToLeft:
         RVFWrite(Stream, '\rtldoc');
     end;
     {$IFNDEF RVDONOTUSESEQ}
     if RVGetFirstEndnoteInRootRVData(Self, True)<>nil then
       RVFWrite(Stream,
         '\fet2{\*\aftnsep\pard\plain\chftnsep }{\*\aftnsepc\pard\plain\chftnsepc}');
     if RVGetFirstFootnoteInRootRVData(Self, True)<>nil then
       RVFWrite(Stream,
         '\fet2{\*\ftnsep\pard\plain\chftnsep }{\*\ftnsepc\pard\plain\chftnsepc}');
     {$ENDIF}
     {$IFNDEF RVDONOTUSEDOCPARAMS}
     if (rvrtfSaveDocParameters in RTFOptions) then begin
       if GetDocParameters(False)<>nil then
         GetDocParameters(False).SaveToRTF(Stream, rvrtfDuplicateUnicode in RTFOptions)
       else
         RVFWriteLine(Stream, '\paperw11906\paperh16838\margl1800\margr1800\margt1440\margb1440');
     end;
     {$ENDIF}
     SaveFontTable(FontTable);
     SaveColorTable(ColorList);
     if rvrtfSaveStyleSheet in RTFOptions then
       SaveStyleSheet(StyleToFont, ColorList);
     {$IFNDEF RVDONOTUSELISTS}
     SaveRTFListTable97(Stream, ColorList, ListOverrideOffsetsList1, FontTable,tpp,
       Header, Footer);
     ListOverrideOffsetsList2.Assign(ListOverrideOffsetsList1);
     {$ELSE}
     RVFWriteLine(Stream, '');
     {$ENDIF}
     if Header<>nil then begin
       RVFWrite(Stream, '{\header ');
       Header.SaveRTFToStream(Stream, Path, False, Level, clNone, nil, ColorList,
         StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
         FontTable, tpp, False, False, nil, nil);
       RVFWrite(Stream, '\par}');
     end;
     if Footer<>nil then begin
       RVFWrite(Stream, '{\footer ');
       Footer.SaveRTFToStream(Stream, Path, False, Level, clNone, nil, ColorList,
         StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
         FontTable, tpp, False, False, nil, nil);
       RVFWrite(Stream, '\par}');
     end;
     RVFWriteLine(Stream, GetExtraRTFCode(rv_rtfs_Doc, nil, -1, -1, False));     
   end;
   {.................................................}
   function GetPartOfUrlExtras(const Extras: String; FirstPart: Boolean): String;
   var p: Integer;
   begin
     Result := '';
     if Extras='' then
       exit;
     p := Pos(#0, Extras);
     if FirstPart then begin
       if p=0 then
         exit;
       Result := Copy(Extras, 1, p-1);
       if (Result<>'') and (Result[Length(Result)]<>' ') then
         Result := Result+' ';
       end
     else begin
       if p=0 then
         Result := Extras
       else
         Result := Copy(Extras, p+1, Length(Extras));
       if (Result<>'') and (Result[1]<>' ') then
         Result := ' '+Result;
     end;
   end;
   {.................................................}
var i, CPIndex: Integer;
    item: TCustomRVItemInfo;
    s: TRVRawByteString;
    StartItem,EndItem,StartOffs,EndOffs
    {$IFNDEF RVDONOTUSELISTS}
    ,MarkerItemNo
    {$ENDIF}
    : Integer;
    UrlTarget, UrlExtras: String;
    UrlExtras1, UrlExtras2, UrlTarget2: TRVAnsiString;
    NotUsedPart: TRVMultiDrawItemPart;
    SelectedItem: TCustomRVItemInfo;
begin
  if not SelectionOnly then
    DoBeforeSaving;
  {$IFNDEF RVDONOTUSEINPLACE}
  if SelectionOnly and (GetChosenRVData<>nil) then begin
    Result := GetChosenRVData.SaveRTFToStream(Stream, Path, SelectionOnly, Level,
      Color, Background, ColorList, StyleToFont,
      ListOverrideOffsetsList1, ListOverrideOffsetsList2,
      FontTable, tpp, True, HiddenParent, nil, nil);
    exit;
  end;
  {$ENDIF}
  Result := True;
  RVFGetLimits(GetRVFSaveScope(SelectionOnly),StartItem,EndItem,StartOffs,EndOffs,NotUsedPart,NotUsedPart, SelectedItem);
  if (SelectedItem<>nil) or (StartItem=-1) or (StartItem>EndItem) then
    exit;
  LastParaNo := -1;
  LastTextStyleNo := -1;
  {$IFNDEF RVDONOTUSELISTS}
  LastListLevel := nil;
  {$ENDIF}
  if (Level=0) and CompleteDocument then begin
    ColorList   := TRVColorList.Create;
    StyleToFont := TRVIntegerList.Create;
    FontTable := TRVRTFFontTable.Create;
    ListOverrideOffsetsList1 := TRVIntegerList.Create;
    ListOverrideOffsetsList2 := TRVIntegerList.Create;    
  end;
  RVStyle := GetRVStyle;
  CPIndex := 0;
  try
    Include(State, rvstRTFSkipPar);
    if (Level=0) and CompleteDocument then begin
      tpp := GetTwipsPerPixel;
      MakeFontTable(FontTable, StyleToFont);
      MakeRTFTables(ColorList, ListOverrideOffsetsList1, True);
      if Header<>nil then
        Header.MakeRTFTables(ColorList, ListOverrideOffsetsList1, False);
      if Footer<>nil then
        Footer.MakeRTFTables(ColorList, ListOverrideOffsetsList1, False);
      if (Color<>clWindow) then
        ColorList.AddUnique(Color);
      SaveHeader(ColorList, StyleToFont, FontTable);
      {$IFNDEF RVDONOTUSELISTS}
      if SelectionOnly then begin
        MarkerItemNo := GetFirstParaItem(StartItem);
        if (MarkerItemNo<>StartItem) and (GetItemStyle(MarkerItemNo)=rvsListMarker) then begin
          if (rvrtfSaveStyleSheet in RTFOptions) and
            RVStyle.ParaStyles[GetItem(MarkerItemNo).ParaNo].Standard then
              RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\s%d', [GetItem(MarkerItemNo).ParaNo]));
          SaveParaStyle(GetItem(MarkerItemNo).ParaNo, ColorList,False, GetItem(MarkerItemNo));
          GetItem(MarkerItemNo).SaveRTF(Stream, Path, Self, MarkerItemNo,
            tpp, Level, ColorList, StyleToFont,
            ListOverrideOffsetsList1, ListOverrideOffsetsList2, FontTable, HiddenParent);
          Exclude(State, rvstRTFSkipPar);
        end;
      end;
      {$ENDIF}
    end;
    for i := StartItem to EndItem do begin
      if GetItemStyle(StartItem)<0 then begin
        if (i=StartItem) and (StartOffs>=GetOffsAfterItem(i)) then
          continue;
        if (i=EndItem) and (EndOffs<=GetOffsBeforeItem(i)) then
          continue;
      end;
      if not ((StartItem=EndItem) and (GetItemStyle(StartItem)>=0)) then begin
        if (i=StartItem) and (StartOffs>=GetOffsAfterItem(i)) and (Items[i]<>'') then
          continue
        else if (i=EndItem) and (EndOffs<=GetOffsBeforeItem(i)) and (Items[i]<>'') then
          continue;
      end;
      item := GetItem(i);
      if not item.SameAsPrev then begin
        RVFWriteLine(Stream,'');
        if item.GetBoolValue(rvbpFullWidth) and PageBreaksBeforeItems[i] then begin
          RVFWrite(Stream,'\page ');
          {$IFNDEF RVDONOTUSETABLES}
          if (i>StartItem) and (item is TRVTableItemInfo) and (GetItem(i-1) is TRVTableItemInfo) then
            RVFWrite(Stream,'\par ');
          {$ENDIF}
        end;
        if item.BR then
          RVFWrite(Stream,'\line ')
        else begin
          if not (rvstRTFSkipPar in State) then begin
            RVFWrite(Stream, '\par ');
            {$IFNDEF RVDONOTUSELISTS}
            if (i>0) and (GetItemStyle(GetFirstParaItem(i-1))=rvsListMarker) then begin
              RVFWrite(Stream, '\plain');
              LastTextStyleNo := -1;
            end;
            {$ENDIF}
          end;
          if not item.GetBoolValue(rvbpFullWidth) and PageBreaksBeforeItems[i]  then
            RVFWrite(Stream,'\page ');
          if (item.ParaNo<>LastParaNo)
             {$IFNDEF RVDONOTUSELISTS}or IsListLevelNew(item){$ENDIF} then begin
            RVFWrite(Stream, '\pard');
            if (rvrtfSaveStyleSheet in RTFOptions) and
              RVStyle.ParaStyles[item.ParaNo].Standard then
              RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\s%d', [item.ParaNo]));
            SaveParaStyle(item.ParaNo, ColorList,False,item);
          end;
        end;
      end;
      Exclude(State, rvstRTFSkipPar);      
      if item.Checkpoint<>nil then begin
        // I decided to use names of checkpoints here (if assigned).
        // If several checkpoints have the same name, only one of them
        // will be used as a bookmark in MS Word.
        s := MakeRTFIdentifierStr(MakeRTFBookmarkNameStr(item.Checkpoint.Name),
          RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions);
        if s='' then
          s := 'RichViewCheckpoint'+RVIntToStr(CPIndex);
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\*\bkmkstart %s}{\*\bkmkend %s}',[s,s]));
        inc(CPIndex);
      end;
      if item.GetBoolValueEx(rvbpJump,RVStyle) then begin
        WriteHyperlink(item.JumpID+FirstJumpNo, Self, i, rvsfRTF,
          UrlTarget, UrlExtras);
        if UrlTarget='' then
          UrlExtras := '';
        if (UrlTarget<>'') and (UrlTarget[1]='#') then begin
          UrlTarget2 := MakeRTFIdentifierStr(
            MakeRTFBookmarkNameStr(Copy(UrlTarget, 2, Length(UrlTarget)-1)),
            RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions);
          if Pos(#0, UrlExtras)=0 then
            UrlExtras := '\l'+#0+UrlExtras
          else
            UrlExtras := '\l '+UrlExtras;
          end
        else
          {$IFDEF RVUNICODESTR}
          UrlTarget2 := RVMakeRTFStrW(UrlTarget, RVStyle.DefCodePage,
            rvrtfDuplicateUnicode in RTFOptions, True, False, False);
          {$ELSE}
          UrlTarget2 := RVMakeRTFFileNameStr(UrlTarget, RVStyle.DefCodePage,
            rvrtfDuplicateUnicode in RTFOptions);
          {$ENDIF}
        {$IFDEF RVUNICODESTR}
        UrlExtras1 := RVMakeRTFStrW(GetPartOfUrlExtras(UrlExtras, True),
          RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions, False, False, False);
        UrlExtras2 := RVMakeRTFStrW(GetPartOfUrlExtras(UrlExtras, False),
          RVStyle.DefCodePage, rvrtfDuplicateUnicode in RTFOptions, False, False, False);
        {$ELSE}
        UrlExtras1 := RVMakeRTFStr(GetPartOfUrlExtras(UrlExtras, True), False, False, False);
        UrlExtras2 := RVMakeRTFStr(GetPartOfUrlExtras(UrlExtras, False), False, False, False);
        {$ENDIF}
        if (UrlTarget2<>'') then begin
          if UrlExtras<>'' then
            UrlExtras := ' '+UrlExtras;
          RVFWrite(Stream,
            {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\field{\*\fldinst HYPERLINK %s"%s"%s}{\fldrslt ',
              [UrlExtras1, UrlTarget2, UrlExtras2]));
          LastTextStyleNo := -1;
        end;
        end
      else begin
        UrlTarget := '';
        UrlExtras := '';
      end;
      if ((item.StyleNo>=0) or (item.AssociatedTextStyleNo>=0)) and
         ShouldSaveTextToRTF(GetActualStyle(item)) then begin
        if item.StyleNo>=0 then begin
          if (i=StartItem) then
            if (i=EndItem) then
              s := RVU_Copy(Items[i], StartOffs, EndOffs-StartOffs, item.ItemOptions)
            else
              s := RVU_Copy(Items[i], StartOffs,
                RVU_Length(Items[i],item.ItemOptions)-StartOffs+1, item.ItemOptions)
          else
            if i=EndItem then
              s := RVU_Copy(Items[i], 1, EndOffs-1, item.ItemOptions)
            else
              s := Items[i];
          CurTextStyleNo := GetActualStyle(item);
          end
        else begin
          s := '';
          CurTextStyleNo := item.AssociatedTextStyleNo;
        end;
        if LastTextStyleNo<>CurTextStyleNo then begin
          RVFWrite(Stream, '\plain ');
          if (rvrtfSaveStyleSheet in RTFOptions) and
            RVStyle.TextStyles[CurTextStyleNo].Standard then
            RVFWrite(Stream,{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\cs%d', [CurTextStyleNo+RVStyle.ParaStyles.Count]));
          SaveTextStyle(CurTextStyleNo, StyleToFont, ColorList, False);
          if (RVStyle.TextStyles[CurTextStyleNo].BiDiMode=rvbdUnspecified) then
             case GetParaBiDiMode(item.ParaNo) of
               rvbdLeftToRight:
                 RVFWrite(Stream, '\ltrch ');
               rvbdRightToLeft:
                 RVFWrite(Stream, '\rtlch ');
             end;
        end;
        if SaveItemToFile(Path, Self, i, rvsfRTF, False, s) then
          RVFWrite(Stream, s)
        else begin
          if item.StyleNo>=0 then begin
            {$IFNDEF RVDONOTUSEUNICODE}
            if rvioUnicode in item.ItemOptions then
              RVWriteUnicodeRTFStr(Stream, s, GetStyleCodePage(GetActualStyle(item)),
                rvrtfDuplicateUnicode in RTFOptions, False,
                rvteoRTFCode in RVStyle.TextStyles[GetActualStyle(item)].Options,
                False, False)
            else
            {$ENDIF}
              RVFWrite(Stream, RVMakeRTFStr(s,rvteoRTFCode in
                RVStyle.TextStyles[GetActualStyle(item)].Options, True, False));
            end
          else
            item.SaveRTF(Stream, Path, Self, i, tpp, Level, ColorList,
              StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
              FontTable, HiddenParent);
        end;
        end
      else begin
        if (LastParaNo<>-1) and (RVStyle.ParaStyles[LastParaNo].BiDiMode=rvbdRightToLeft) then
          RVFWrite(Stream, '\ltrpar');
        s := '';
        if SaveItemToFile(Path, Self, i, rvsfRTF, False, s) then
          RVFWrite(Stream, s)
        else
          item.SaveRTF(Stream, Path, Self, i, tpp, Level, ColorList,
            StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
            FontTable, HiddenParent);
        LastTextStyleNo := -1;
        if (LastParaNo<>-1) and (RVStyle.ParaStyles[LastParaNo].BiDiMode=rvbdRightToLeft) then
          RVFWrite(Stream, '\rtlpar');        
      end;
      if (UrlTarget<>'') or (UrlExtras<>'') then begin
        RVFWrite(Stream, '}}');
        LastTextStyleNo := -1;
      end;
    end;
    if NotAddedCP<>nil then begin
      // I decided to use names of checkpoints here (if assigned).
      // If several checkpoints have the same name, only one of them
      // will be used as a bookmark in MS Word.
      s := MakeRTFIdentifierStr(MakeRTFBookmarkNameStr(NotAddedCP.Name), RVStyle.DefCodePage,
        rvrtfDuplicateUnicode in RTFOptions);
      if s='' then
        s := 'RichViewCheckpoint'+RVIntToStr(CPIndex);
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('{\*\bkmkstart %s}{\*\bkmkend %s}',[s,s]));
    end;
    if (Level=0) and CompleteDocument and
      (not SelectionOnly or
       (((EndItem=ItemCount-1) or IsParaStart(EndItem+1)) and (EndOffs>=GetOffsAfterItem(EndItem)))) then
        RVFWrite(Stream, '\par');
    if (Level=0) and CompleteDocument then
      RVFWrite(Stream, '}');
  except
    Result := False;
  end;
  if (Level=0) and CompleteDocument then begin
    ColorList.Free;
    StyleToFont.Free;
    FontTable.Free;
    ListOverrideOffsetsList1.Free;
    ListOverrideOffsetsList2.Free;    
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVData.GetParentData: TCustomRVData;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRootData: TCustomRVData;
begin
  Result := Self;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetAbsoluteParentData: TCustomRVData;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetAbsoluteRootData: TCustomRVData;
begin
  Result := Self;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
function TCustomRVData.GetNoteText: String;
begin
  Result := GetAbsoluteRootData.GetNoteText;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.DrainFrom(Victim: TCustomRVData);
var i: Integer;
    item: TCustomRVItemInfo;
begin
  if Victim=nil then exit;
  if (rvoTagsArePChars in Options) <> (rvoTagsArePChars in Victim.Options) then
    raise ERichViewError.Create(errRVTagsTypesMismatch);
  for i := 0 to Victim.Items.Count-1 do begin
    item := Victim.GetItem(i);
    if item.SameAsPrev then
      item.ParaNo := -1;
    AddItemR(Victim.Items[i], item);
  end;
  if NotAddedCP=nil then
    NotAddedCP := Victim.NotAddedCP
  else
    Victim.NotAddedCP.Free;
  Victim.Items.Clear;
  Victim.FirstCP := nil;
  Victim.LastCP := nil;
  Victim.NotAddedCP := nil;
  Victim.CPCount := 0;
  Include(Victim.State, rvstPreserveSoftPageBreaks);
  try
    Victim.Clear;
  finally
    Exclude(Victim.State, rvstPreserveSoftPageBreaks);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemNo(Item: TCustomRVItemInfo): Integer;
begin
  Result := Items.IndexOfObject(Item);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.Inserting(RVData: TCustomRVData; Safe: Boolean);
var i: Integer;
    s: TRVRawByteString;
begin
  for i := 0 to Items.Count-1 do begin
    s := Items[i];
    GetItem(i).Inserting(RVData, s, Safe);
    Items[i] := s;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.Beep;
begin
  if (GetRVStyle<>nil) and (GetRVStyle.UseSound) then
    MessageBeep(MB_OK);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetParagraphStyleToAll(ParaNo: Integer);
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    if GetItemStyle(i)<>rvsBreak then
      GetItem(i).ParaNo := ParaNo;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRVData: TCustomRVData;
begin
  Result := Self;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetSourceRVData: TCustomRVData;
begin
  Result := Self;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItem(ItemNo: Integer): TCustomRVItemInfo;
begin
  Result := TCustomRVItemInfo(Items.Objects[ItemNo]);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetRTFProperties: TPersistent;
begin
  Result := GetRootData.GetRTFProperties;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEDOCPARAMS}
function TCustomRVData.GetDocParameters(AllowCreate: Boolean): TRVDocParameters;
begin
  Result := GetRootData.GetDocParameters(AllowCreate);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVData.RV_CanConcateItems(FirstItemNo: Integer;
  item1, item2: TCustomRVItemInfo; IgnorePara: Boolean;
  AllowConcateNonText: Boolean): Boolean;
var RVStyle: TRVStyle;
begin
  RVStyle := GetRVStyle;
  if (item1=nil) or (item2=nil) then begin
    Result := False;
    exit;
  end;
  if not AllowConcateNonText and
    ((item1.StyleNo<0) or (item2.StyleNo<0)) then begin
    Result := False;
    exit;
  end;
  if (((item1.StyleNo>=0) and (GetItemTextR(FirstItemNo)='')) or
     ((item2.StyleNo>=0) and (GetItemTextR(FirstItemNo+1)=''))
      {$IFNDEF RVDONOTUSELISTS}and (item1.StyleNo<>rvsListMarker){$ENDIF}) and
     (IgnorePara or item2.SameAsPrev) then begin
    Result := True;
    exit;
  end;
  if (item1.StyleNo<0) or (item2.StyleNo<0) then begin
    Result := False;
    exit;
  end;
  Result := (item1.StyleNo=item2.StyleNo) and
            (IgnorePara or item2.SameAsPrev) and
            {$IFNDEF RVDONOTUSEUNICODE}
            (RVStyle.TextStyles[GetActualStyle(item1)].Unicode=
              RVStyle.TextStyles[GetActualStyle(item2)].Unicode) and
            {$ENDIF}
            {$IFNDEF RVDONOTUSEITEMHINTS}
            (item1.Hint=item2.Hint) and
            {$ENDIF}
            RV_CompareTags(item1.Tag,item2.Tag, rvoTagsArePChars in Options) and
            (item2.Checkpoint=nil) and
            (
            (Length(Items[FirstItemNo])=0) or
            (Length(Items[FirstItemNo+1])=0) or
            ([rvprConcateProtect,rvprModifyProtect]*
              RVStyle.TextStyles[GetActualStyle(item1)].Protection=[])
            )
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SimpleConcate(FirstItemNo: Integer; item1,
  item2: TCustomRVItemInfo);
begin
  if (item2.StyleNo>=0) and (GetItemTextR(FirstItemNo+1)='') then begin
    // merging because the second item is empty: deleting the second item
    InternalFreeItem(item2,False);
    Items.Delete(FirstItemNo+1);
    exit;
  end;
  if (item1.StyleNo>=0) and (GetItemTextR(FirstItemNo)='') then begin
    // merging because the first item is empty: transferring parastart properties
    // from item1 to item2 and deleting the first item
    item2.AssignParaProperties(item1);
    InternalFreeItem(item1,False);
    Items.Delete(FirstItemNo);
    exit;
  end;
  // merging because of two items of the same style
  if (item1.StyleNo>=0) and (item2.StyleNo>=0)
    {$IFNDEF RVDONOTUSEUNICODE}
    and
    (GetRVStyle.TextStyles[GetActualStyle(item1)].Unicode=
     GetRVStyle.TextStyles[GetActualStyle(item2)].Unicode)
     {$ENDIF} then begin
    if (GetItemTextR(FirstItemNo)='') and (GetItemTextR(FirstItemNo+1)<>'') then begin
      item1.StyleNo := item2.StyleNo;
      if item1.Tag=0 then begin
        item1.Tag := Item2.Tag;
        Item2.Tag := 0;
      end;
    end;
    Items[FirstItemNo] := Items[FirstItemNo]+Items[FirstItemNo+1];
  end;
  InternalFreeItem(item2,False);
  Items.Delete(FirstItemNo+1);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.MassSimpleConcate(FirstItemNo,
  LastItemNo: Integer);
var i: Integer;
    item1,
    item2: TCustomRVItemInfo;
begin
  if FirstItemNo<0 then
    FirstItemNo := 0;
  if LastItemNo>=Items.Count then
    LastItemNo := Items.Count-1;
  for i := LastItemNo downto FirstItemNo+1 do begin
    SimpleConcateSubitems(i);
    item1 := GetItem(i-1);
    item2 := GetItem(i);
    if RV_CanConcateItems(i-1, item1, item2, False, True) then
      SimpleConcate(i-1, item1, item2);
  end;
  if (FirstItemNo>=0) and (FirstItemNo<=LastItemNo) then
    SimpleConcateSubitems(FirstItemNo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.MassSimpleConcateAll;
begin
  MassSimpleConcate(0, ItemCount-1);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SimpleConcateSubitems(ItemNo: Integer);
var StoreSub: TRVStoreSubRVData;
    SubRVData: TCustomRVData;
    item: TCustomRVItemInfo;
    i: Integer;
begin
  item := GetItem(ItemNo);
  SubRVData := TCustomRVData(item.GetSubRVData(StoreSub,rvdFirst));
  while SubRVData<>nil do begin
    SubRVData.MassSimpleConcate(0, SubRVData.ItemCount-1);
    for i := 0 to SubRVData.ItemCount-1 do
      SubRVData.SimpleConcateSubitems(i);
    SubRVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
  end;
  StoreSub.Free;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTFIMPORT}
function TCustomRVData.LoadRTF(const FileName: String): TRVRTFErrorCode;
var rp: TRVRTFReaderProperties;
    ItemNo: Integer;
begin
  rp := TRVRTFReaderProperties(GetRTFProperties);
  if rp<>nil then begin
    ItemNo := Items.Count-1;
    rp.BasePath := ExtractFilePath(FileName);
    try
      Result := rp.ReadFromFile(FileName, Self);
    finally
      rp.BasePath := '';
    end;
    MassSimpleConcate(ItemNo, Items.Count-1);
    end
  else
    Result := rtf_ec_Assertion;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.LoadRTFFromStream(Stream: TStream): TRVRTFErrorCode;
var rp: TRVRTFReaderProperties;
    ItemNo: Integer;
begin
  rp := TRVRTFReaderProperties(GetRTFProperties);
  if rp<>nil then begin
    ItemNo := Items.Count-1;
    Result := rp.ReadFromStream(Stream, Self);
    MassSimpleConcate(ItemNo, ItemCount-1);
    end
  else
    Result := rtf_ec_Assertion;
end;
{------------------------------------------------------------------------------}
{$IFDEF RVUSEWORDDOC}
function TCustomRVData.LoadWordDoc(const FileName: String):TRVRTFErrorCode;
var rp: TRVRTFReaderProperties;
    ItemNo: Integer;
begin
  rp := TRVRTFReaderProperties(GetRTFProperties);
  if rp<>nil then begin
    ItemNo := Items.Count-1;
    Result := rp.ReadFromWordDocFile(FileName, Self);
    MassSimpleConcate(ItemNo, Items.Count-1);
    end
  else
    Result := rtf_ec_Assertion;
end;
{$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVData.AfterAddStyle(StyleInfo: TCustomRVInfo);
begin
  GetAbsoluteRootData.AfterAddStyle(StyleInfo);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoMarkStylesInUse(Data: TRVDeleteUnusedStylesData);
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    GetItem(i).MarkStylesInUse(Data);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoUpdateStyles(Data: TRVDeleteUnusedStylesData);
var i: Integer;
begin
  for i := 0 to Items.Count-1 do
    GetItem(i).UpdateStyles(Data);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
    {............................................}
    procedure ExpandStyle(Index, FirstIndex: Integer; Styles: TCustomRVInfos;
      Used, Expanded: TRVIntegerList);
    var Style: TCustomRVInfo;
    begin
      if Expanded[Index]<>0 then
        exit;
      Used[Index] := 1;
      Expanded[Index] := 1;
      Style := TCustomRVInfo(Styles.Items[Index]);
      if Style.BaseStyleNo>=0 then begin
        if Style.BaseStyleNo >= Styles.Count then
          Style.BaseStyleNo := -1
        else
          ExpandStyle(Style.BaseStyleNo, FirstIndex, Styles, Used, Expanded);
      end;
      if (Styles is TFontInfos) and (TFontInfo(Style).NextStyleNo>=0) then begin
        if TFontInfo(Style).NextStyleNo>= Styles.Count then
          TFontInfo(Style).NextStyleNo := -1
        else
          ExpandStyle(TFontInfo(Style).NextStyleNo, FirstIndex, Styles, Used, Expanded)
        end
      else if (Styles is TParaInfos) and (TParaInfo(Style).NextParaNo>=0) then begin
        if TParaInfo(Style).NextParaNo >= Styles.Count then
          TParaInfo(Style).NextParaNo := -1
        else
          ExpandStyle(TParaInfo(Style).NextParaNo, FirstIndex, Styles, Used, Expanded);
      end;
    end;
    {............................................}
    procedure ExpandStyles(Styles: TCustomRVInfos; Used: TRVIntegerList);
    var i: Integer;
        Expanded: TRVIntegerList;
    begin
      Expanded := TRVIntegerList.CreateEx(Used.Count, 0);
      for i := 0 to Used.Count-1 do
        if (Used[i]<>0) then
          ExpandStyle(i, i, Styles, Used, Expanded);
      Expanded.Free;
    end;
    {............................................}
    procedure MarkDefStyles;
    var i: Integer;
        RVStyle: TRVStyle;
    begin
      RVStyle := GetRVStyle;
      for i := 0 to RVStyle.ParaStyles.Count-1 do
        if (Data.UsedParaStyles[i]<>0) and
           (RVStyle.ParaStyles[i].DefStyleNo>=0) then
          Data.UsedTextStyles[RVStyle.ParaStyles[i].DefStyleNo] := 1;
    end;
    {............................................}
begin
  Data.Init(GetRVStyle);
  DoMarkStylesInUse(Data);
  if Data.ParaStyles then
    ExpandStyles(GetRVStyle.ParaStyles, Data.UsedParaStyles);
  if Data.TextStyles then begin
    MarkDefStyles;
    {$IFNDEF RVDONOTUSEUNICODE}
    if (GetRVStyle.DefUnicodeStyle>=0) then
      if GetRVStyle.DefUnicodeStyle>=Data.UsedTextStyles.Count then
        GetRVStyle.DefUnicodeStyle := -1
      else
        Data.UsedTextStyles[GetRVStyle.DefUnicodeStyle] := 1;
    {$ENDIF}
    ExpandStyles(GetRVStyle.TextStyles, Data.UsedTextStyles);
  end;
  if Data.ListStyles then
    ExpandStyles(GetRVStyle.ListStyles, Data.UsedListStyles);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteMarkedStyles(Data: TRVDeleteUnusedStylesData);
begin
  Data.ConvertFlagsToShifts(Self.GetRVStyle);
  DoUpdateStyles(Data);
  AfterDeleteStyles(Data);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteUnusedStyles(TextStyles, ParaStyles, ListStyles: Boolean);
var Data: TRVDeleteUnusedStylesData;
begin
  Data := TRVDeleteUnusedStylesData.Create(TextStyles, ParaStyles, ListStyles);
  try
    MarkStylesInUse(Data);
    DeleteMarkedStyles(Data);
    {$IFNDEF RVDONOTUSEUNICODE}
    if TextStyles and (GetRVStyle.DefUnicodeStyle>=0) then
      if GetRVStyle.DefUnicodeStyle>=Data.UsedTextStyles.Count then
        GetRVStyle.DefUnicodeStyle := -1
      else
        GetRVStyle.DefUnicodeStyle :=
          GetRVStyle.DefUnicodeStyle-Data.UsedTextStyles[GetRVStyle.DefUnicodeStyle]+1;
    {$ENDIF}
  finally
    Data.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AfterDeleteStyles(Data: TRVDeleteUnusedStylesData);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.InitStyleMappings(var PTextStylesMapping,
  PParaStylesMapping, PListStylesMapping: PRVIntegerList;
  var PUnits: PRVStyleUnits);
begin
  GetRootData.InitStyleMappings(
    PTextStylesMapping, PParaStylesMapping, PListStylesMapping, PUnits);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DoneStyleMappings(AsSubDoc: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVData.SupportsPageBreaks: Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AdjustInItemsRange(var ItemNo: Integer);
begin
  if ItemNo>=Items.Count then
    ItemNo := Items.Count-1;
  if ItemNo<0 then
    ItemNo := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.NextChar(ItemNo, Index: Integer): Integer;
begin
  Result := NextCharStr(Items[ItemNo], ItemNo, Index);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.PrevChar(ItemNo, Index: Integer): Integer;
begin
  Result := PrevCharStr(Items[ItemNo], ItemNo, Index);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.IsWordWrapAllowed: Boolean;
begin
  Result := GetAbsoluteRootData.IsWordWrapAllowed;
end;
{------------------------------------------------------------------------------}
// Returns True if "hidden" option is set for this item
function TCustomRVData.IsHiddenItem(ItemNo: Integer): Boolean;
{$IFNDEF RVDONOTUSELISTS}
var i: Integer;
{$ENDIF}
begin
  if GetItemStyle(ItemNo)<0 then begin
    Result := TRVNonTextItemInfo(GetItem(ItemNo)).Hidden;
    {$IFNDEF RVDONOTUSELISTS}
    // hiding paragraph marker if the whole paragraph section is hidden
    if not Result and (GetItemStyle(ItemNo)=rvsListMarker) then begin
      for i := ItemNo+1 to ItemCount-1 do begin
        if IsFromNewLine(i) then
          break;
        if not IsHiddenItem(i) then
          exit;
      end;
      Result := True;
    end;
    {$ENDIF}
    end
  else
    Result := rvteoHidden in GetRVStyle.TextStyles[GetItemStyle(ItemNo)].Options;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.NextCharStr(const str: TRVRawByteString;
  ItemNo, Index: Integer): Integer;
{$IFNDEF RVDONOTUSEUNICODE}
var s: TRVRawByteString;
    p1,p2: Pointer;
{$ENDIF}
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  if RVNT and (rvioUnicode in GetItemOptions(ItemNo)) then begin
    s := str;
    SetLength(s, Length(s)+1);
    s[Length(s)]:=#0;
    p1 := Pointer(s);
    p2 := CharNextW(Pointer(PRVAnsiChar(p1)+(Index-1)*2));
    Result := (PRVAnsiChar(p2)-PRVAnsiChar(p1)) div 2+1;
    end
  else
  {$ENDIF}
    Result := Index+1;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.PrevCharStr(const str: TRVRawByteString;
  ItemNo, Index: Integer): Integer;
{$IFNDEF RVDONOTUSEUNICODE}
var s: TRVRawByteString;
    p1,p2: Pointer;
{$ENDIF}
begin
  {$IFNDEF RVDONOTUSEUNICODE}
  if RVNT and (rvioUnicode in GetItemOptions(ItemNo)) then begin
    s := str;
    SetLength(s, Length(s)+1);
    s[Length(s)]:=#0;
    p1 := Pointer(s);
    p2 := CharPrevW(p1, Pointer(PRVAnsiChar(p1)+(Index-1)*2));
    if p2=PRVAnsiChar(p1)+(Index-1)*2 then
      p2 := p1;
    Result := (PRVAnsiChar(p2)-PRVAnsiChar(p1)) div 2+1;
    end
  else
  {$ENDIF}
    Result := Index-1;
end;
{------------------------------------------------------------------------------}
// Returns the first item in the paragraph, where the ItemNo-th item belongs.
function TCustomRVData.GetFirstParaItem(ItemNo: Integer): Integer;
begin
  Result := ItemNo;
  while (Result>0) and not IsParaStart(Result) do
    dec(Result);
end;
{------------------------------------------------------------------------------}
// Returns the first item in the paragraph section , where the ItemNo-th item belongs.
function TCustomRVData.GetFirstParaSectionItem(ItemNo: Integer): Integer;
begin
  Result := ItemNo;
  while (Result>0) and not IsFromNewLine(Result) do
    dec(Result);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.GetParentInfo(var ParentItemNo: Integer;
  var Location: TRVStoreSubRVData);
begin
  ParentItemNo := -1;
  Location   := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetBiDiMode: TRVBiDiMode;
begin
  Result := GetRootData.GetBiDiMode;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemBiDiMode(ItemNo: Integer): TRVBiDiMode;
var item: TCustomRVItemInfo;
begin
  item := GetItem(ItemNo);
  if item.StyleNo>=0 then
    Result := GetRVStyle.TextStyles[GetActualStyle(item)].BiDiMode
  else
    Result := rvbdUnspecified;
  if Result=rvbdUnspecified then
    Result := GetParaBiDiMode(item.ParaNo);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetParaBiDiMode(
  ParaNo: Integer): TRVBiDiMode;
begin
  Result := GetRVStyle.ParaStyles[ParaNo].BiDiMode;
  if Result=rvbdUnspecified then
    Result := GetBiDiMode;
end;
{------------------------------------------------------------------------------}
{$IFDEF RVUSELISTORSEQ}
function TCustomRVData.FindPreviousItem(ItemNo: Integer;
  ItemClass: TCustomRVItemInfoClass): TCustomRVItemInfo;
   {...................................................}
   function FindItemInRVData(RVData: TCustomRVData; LastItemNo: Integer): TCustomRVItemInfo; forward;
   {...................................................}
   function FindItemInItem(Item: TCustomRVItemInfo; StoreSub: TRVStoreSubRVData): TCustomRVItemInfo;
   var RVData: TCustomRVData;
   begin
     Result := nil;
     if StoreSub=nil then
       RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdLast))
     else
       RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdPrev));
     if RVData<>nil then begin
       repeat
         Result := FindItemInRVData(RVData, RVData.Items.Count-1);
         if Result<>nil then
           break;
         RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdPrev));
       until RVData=nil;
     end;
     StoreSub.Free;
   end;
   {...................................................}
   function FindItemInRVData(RVData: TCustomRVData; LastItemNo: Integer): TCustomRVItemInfo;
   var i: Integer;
   begin
     for i := LastItemNo downto 0 do begin
       if RVData.GetItem(i) is ItemClass then
         Result := RVData.GetItem(i)
       else
         Result := FindItemInItem(RVData.GetItem(i), nil);
       if Result<>nil then
         exit;
     end;
     Result := nil;
   end;
   {...................................................}
var RVData: TCustomRVData;
    StoreSub: TRVStoreSubRVData;
begin
  Result := nil;
  RVData := Self;
  while RVData<>nil do begin
    Result := FindItemInRVData(RVData, ItemNo);
    if Result<>nil then
      break;
    RVData.GetParentInfo(ItemNo, StoreSub);
    if ItemNo<0 then begin
      StoreSub.Free;
      break;
    end;
    RVData := RVData.GetAbsoluteParentData;
    Result := FindItemInItem(RVData.GetItem(ItemNo), StoreSub);
    if Result<>nil then
      break;
    dec(ItemNo);
  end;
end;
{------------------------------------------------------------------------------}
{ Returns index of item in the given RVData containing ItemToFind (or index of
  this item itself. The search is started from StartItemNo }
function TCustomRVData.FindItemLocalLocationFrom(StartItemNo: Integer;
  ItemToFind: TCustomRVItemInfo): Integer;
   {...................................................}
   function FindItemInRVData(RVData: TCustomRVData;
     FirstItemNo: Integer): Integer; forward;
   {...................................................}
   function FindItemInItem(Item: TCustomRVItemInfo): Boolean;
   var RVData: TCustomRVData;
       StoreSub: TRVStoreSubRVData;
   begin
     Result := False;
     RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdFirst));
     if RVData<>nil then begin
       repeat
         Result := FindItemInRVData(RVData.GetRVData, 0)>=0;
         if Result then
           break;
         RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
       until RVData=nil;
     end;
     StoreSub.Free;
   end;
   {...................................................}
   function FindItemInRVData(RVData: TCustomRVData; FirstItemNo: Integer): Integer;
   var i: Integer;
   begin
     for i := FirstItemNo to RVData.ItemCount-1 do
       if (RVData.GetItem(i)=ItemToFind) or
           FindItemInItem(RVData.GetItem(i)) then begin
         Result := i;
         exit;
       end;
     Result := -1;
   end;
   {...................................................}
begin;
  Result := FindItemInRVData(Self, StartItemNo);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TCustomRVData.AddSeqInList(ItemNo: Integer);
var List: TRVSeqList;
    PrevSeq: TRVSeqItemInfo;
    Index: Integer;
begin
  if not (GetItem(ItemNo) is TRVSeqItemInfo) then
    exit;
  List := GetSeqList(True);
  if List=nil then
    exit;
  if TRVSeqItemInfo(GetItem(ItemNo)).GetIndexInList(List)>=0 then
    exit;
  PrevSeq := FindPreviousSeq(ItemNo-1);
  Index := List.InsertAfter(TRVSeqItemInfo(GetItem(ItemNo)), PrevSeq);
  GetSeqList(False).RecalcCounters(Index, GetRVStyle);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteSeqFromList(Item: TCustomRVItemInfo;
  Clearing: Boolean);
var List: TRVSeqList;
    Index: Integer;
begin
  if Item is TRVSeqItemInfo then begin
    List := GetSeqList(False);
    if List=nil then
      exit;
    Index := TRVSeqItemInfo(Item).GetIndexInList(List);
    List.Delete(Index);
    if List.Count=0 then
      DestroySeqList
    else if not Clearing then
      List.RecalcCounters(Index, GetRVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetSeqList(AllowCreate: Boolean): TRVSeqList;
begin
  Result := GetAbsoluteRootData.GetSeqList(AllowCreate);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DestroySeqList;
begin
  GetAbsoluteRootData.DestroySeqList;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindPreviousSeq(ItemNo: Integer): TRVSeqItemInfo;
begin
   Result := TRVSeqItemInfo(FindPreviousItem(ItemNo, TRVSeqItemInfo));
end;
{------------------------------------------------------------------------------}
{ Returns index in GetSeqList of the last seq item having SeqName listed in SeqNames }
{ Note: SeqNames must be sorted! }
function TCustomRVData.FindLastSeqIndex(StartAfterMeIndex: Integer;
  SeqNames: TStringList): Integer;
var i, j: Integer;
    SeqList: TRVSeqList;
begin
  Result := -1;
  SeqList := GetSeqList(False);
  if SeqList=nil then
    exit;
  for i := SeqList.Count-1 downto StartAfterMeIndex+1 do
    if SeqNames.Find(TRVSeqItemInfo(SeqList[i]).SeqName, j) then begin
      Result := i;
      exit;
    end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
function TCustomRVData.SetListMarkerInfo(AItemNo, AListNo, AListLevel,
  AStartFrom, AParaNo: Integer; AUseStartFrom: Boolean): Integer;
var Marker: TRVMarkerItemInfo;
    s: TRVRawByteString;
    Markers: TRVMarkerList;
begin
  if (AItemNo>=Items.Count) or (AItemNo<0) then
    Result := Items.Count
  else begin
    Result := GetFirstParaItem(AItemNo);
    if GetItem(Result).GetBoolValue(rvbpFullWidth) then begin
      Result := -1;
      exit;
    end;
  end;
  if (Result<Items.Count) and (GetItemStyle(Result)=rvsListMarker) then begin
    Marker := TRVMarkerItemInfo(GetItem(Result));
    Marker.ListNo    := AListNo;
    Marker.Level     := AListLevel;
    Marker.StartFrom := AStartFrom;
    Marker.Reset     := AUseStartFrom;
    Markers := GetMarkers(False);
    if Markers<>nil then
      Markers.RecalcCounters(Marker.GetIndexInList(Markers), GetRVStyle);
    end
  else begin
    Marker := TRVMarkerItemInfo.CreateEx(Self, AListNo, AListLevel, AStartFrom, AUseStartFrom);
    s := '';
    Marker.Inserting(Self,s,False);
    if Result<Items.Count then begin
      GetItem(Result).SameAsPrev := True;
      Marker.ParaNo := GetItemPara(Result);
      end
    else begin
      Marker.ParaNo := AParaNo;
      if AParaNo<0 then
        if Items.Count=0 then
          Marker.ParaNo := 0
        else
          Marker.ParaNo := GetItemPara(Items.Count-1);
    end;
    Items.InsertObject(Result, s, Marker);
    Marker.Inserted(Self, Result);
    AddMarkerInList(Result);
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.RecalcMarker(AItemNo: Integer; AllowCreateList: Boolean);
var Markers: TRVMarkerList;
begin
  if GetItemStyle(AItemNo)<>rvsListMarker then
    exit;
  Markers := GetMarkers(AllowCreateList);
  if Markers=nil then
    exit;
  Markers.RecalcCounters(TRVMarkerItemInfo(GetItem(AItemNo)).GetIndexInList(Markers), GetRVStyle);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.RemoveListMarker(ItemNo: Integer);
begin
  ItemNo := GetFirstParaItem(ItemNo);
  if GetItemStyle(ItemNo)=rvsListMarker then begin
    DeleteItems(ItemNo,1);
    if ItemNo<Items.Count then
      GetItem(ItemNo).SameAsPrev := False;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetListMarkerInfo(AItemNo: Integer;
                                 var AListNo, AListLevel, AStartFrom: Integer;
                                 var AUseStartFrom: Boolean): Integer;
begin
  Result := GetFirstParaItem(AItemNo);
  if GetItemStyle(Result)<>rvsListMarker then begin
    Result := -1;
    exit;
  end;
  with TRVMarkerItemInfo(GetItem(Result)) do begin
    AListNo := ListNo;
    AListLevel := Level;
    AStartFrom := StartFrom;
    AUseStartFrom := Reset;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetMarkers(AllowCreate: Boolean): TRVMarkerList;
begin
  Result := GetAbsoluteRootData.GetMarkers(AllowCreate);
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetPrevMarkers: TRVMarkerList;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DestroyMarkers;
begin
  GetAbsoluteRootData.DestroyMarkers;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.AddMarkerInList(ItemNo: Integer);
var List: TRVMarkerList;
    PrevMarker: TRVMarkerItemInfo;
    Index: Integer;
begin
  if GetItemStyle(ItemNo)<>rvsListMarker then
    exit;
  List := GetMarkers(True);
  if List=nil then
    exit;
  if TRVMarkerItemInfo(GetItem(ItemNo)).GetIndexInList(List)>=0 then
    exit;
  PrevMarker := FindPreviousMarker(ItemNo-1);
  Index := List.InsertAfter(TRVMarkerItemInfo(GetItem(ItemNo)), PrevMarker);
  GetMarkers(False).RecalcCounters(Index, GetRVStyle);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.DeleteMarkerFromList(Item: TCustomRVItemInfo; Clearing: Boolean);
var List: TRVMarkerList;
    Index: Integer;
begin
  if Item.StyleNo=rvsListMarker then begin
    List := GetMarkers(False);
    if List=nil then
      exit;
    Index := TRVMarkerItemInfo(Item).GetIndexInList(List);
    List.Delete(Index);
    if List.Count=0 then
      DestroyMarkers
    else if not Clearing then
      List.RecalcCounters(Index, GetRVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.FindPreviousMarker(ItemNo: Integer): TRVMarkerItemInfo;
begin
   Result := TRVMarkerItemInfo(FindPreviousItem(ItemNo, TRVMarkerItemInfo));
end;
{------------------------------------------------------------------------------}
{ Returns index in GetMarkers of the last marker of style listed in ListStyles }
function TCustomRVData.FindLastMarkerIndex(StartAfterMeIndex: Integer;
  ListStyles: TRVIntegerList): Integer;
var i, j, ListNo: Integer;
    ok: Boolean;
    Markers: TRVMarkerList;
begin
  Result := -1;
  Markers := GetMarkers(False);
  if Markers=nil then
    exit;
  for i := Markers.Count-1 downto StartAfterMeIndex+1 do begin
    ok := False;
    ListNo := TRVMarkerItemInfo(Markers[i]).ListNo;
    for j := 0 to ListStyles.Count-1 do
      if ListStyles[j] = ListNo then begin
        ok := True;
        break;
      end;
    if ok then begin
      Result := i;
      exit;
    end;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVData.GetChosenItem: TCustomRVItemInfo;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetChosenRVData: TCustomRVData;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetItemTextR(ItemNo: Integer): TRVRawByteString;
begin
  Result := Items[ItemNo];
end;
{------------------------------------------------------------------------------}
procedure TCustomRVData.SetItemTextR(ItemNo: Integer; const s: TRVRawByteString);
begin
  if rvioUnicode in GetItemOptions(ItemNo) then
    RVCheckUni(Length(s));
  Items[ItemNo] := s;
end;
{------------------------------------------------------------------------------}
{ Returns the first and the last item of paragraph section containing
  the given range of items }
procedure TCustomRVData.ExpandToParaSection(ItemNo1,ItemNo2: Integer;
  var FirstItemNo, LastItemNo: Integer);
begin
  FirstItemNo := ItemNo1;
  while (FirstItemNo>0) and not IsFromNewLine(FirstItemNo) do
    dec(FirstItemNo);
  LastItemNo := ItemNo2+1;
  while (LastItemNo<Items.Count) and not IsFromNewLine(LastItemNo) do
    inc(LastItemNo);
  dec(LastItemNo);
end;
{------------------------------------------------------------------------------}
{ Returns the first and the last item of paragraph containing
  the given range of items }
procedure TCustomRVData.ExpandToPara(ItemNo1,ItemNo2: Integer;
  var FirstItemNo, LastItemNo: Integer);
begin
  FirstItemNo := ItemNo1;
  while (FirstItemNo>0) and not IsParaStart(FirstItemNo) do
    dec(FirstItemNo);
  LastItemNo := ItemNo2+1;
  while (LastItemNo<Items.Count) and not IsParaStart(LastItemNo) do
    inc(LastItemNo);
  dec(LastItemNo);
end;
{------------------------------------------------------------------------------}
{ READ method for ItemCount property }
function TCustomRVData.GetItemCount: Integer;
begin
  Result := Items.Count;
end;
{------------------------------------------------------------------------------}
{ Inits editing mode and returns RVData of inplace editor. For most RVDatas,
  this method does nothing and returns themselves.
  Overriden in TRVTableCellData. }
function TCustomRVData.Edit: TCustomRVData;
begin
  Result := Self;
end;
{------------------------------------------------------------------------------}
{ Enumerates all items from the first to the last one: calls Proc for each item.
  Items in sub-documents (cells) are included. If they are edited, RVData of
  inplace editor is used as a parameter. Value of UserData is passed as a
  last parameter of Proc. }
function TCustomRVData.EnumItems(Proc: TRVEnumItemsProc; var UserData1: Integer;
      const UserData2: String): Boolean;
var i: Integer;
    RVData: TCustomRVData;
    StoreSub: TRVStoreSubRVData;
    item: TCustomRVItemInfo;
begin
  Result := True;
  for i := 0 to ItemCount-1 do begin
    Proc(Self, i, UserData1, UserData2, Result);
    if not Result then
      exit;
    item := GetItem(i);
    RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdFirst));
    if RVData<>nil then begin
       repeat
         Result := RVData.GetRVData.EnumItems(Proc, UserData1, UserData2);
         if not Result then
           break;
         RVData := TCustomRVData(item.GetSubRVData(StoreSub, rvdNext));
       until RVData=nil;
     end;
     StoreSub.Free;
   end;
end;
{------------------------------------------------------------------------------}
{ Compares two locations in the same document:
  (RVData1, ItemNo1) and (RVData2, ItemNo2).
  Return value: 0 if equal, <0 if (1) before (2), >0 if (1) after (2).
  Table is assumed before its cells. }
function RVCompareLocations(RVData1: TCustomRVData; ItemNo1: Integer;
  RVData2: TCustomRVData; ItemNo2: Integer): Integer;
var CurItemNo2: Integer;
    CurRVData2: TCustomRVData;
    StoreSub1,StoreSub2: TRVStoreSubRVData;
begin
  RVData1 := RVData1.GetSourceRVData;
  RVData2 := RVData2.GetSourceRVData;
  CurRVData2 := RVData2;
  CurItemNo2 := ItemNo2;
  StoreSub1 := nil;
  StoreSub2 := nil;
  while True do begin
    while True do begin
      if RVData1=CurRVData2 then begin
        Result := ItemNo1-CurItemNo2; // different items?
        if Result=0 then
          if StoreSub1<>nil then
            if StoreSub2<>nil then
              Result := StoreSub1.Compare(StoreSub2) // cells in the same table?
            else
              Result := +1 // (1) is from table cell, (2) is a table itself
          else
            if StoreSub2<>nil then
              Result := -1  // (2) is from table cell, (1) is a table itself
            else
              Result := 0; // the same item;
        StoreSub1.Free;
        StoreSub2.Free;
        exit;
      end;
      StoreSub2.Free;
      CurRVData2.GetParentInfo(CurItemNo2, StoreSub2);
      if CurItemNo2<0 then
        break;
      CurRVData2 := CurRVData2.GetAbsoluteParentData.GetSourceRVData;
    end;
    StoreSub1.Free;
    RVData1.GetParentInfo(ItemNo1, StoreSub1);
    if ItemNo1<0 then
      raise ERichViewError.Create(errRVCompare);
    RVData1 := RVData1.GetAbsoluteParentData.GetSourceRVData;
    CurRVData2 := RVData2;
  end;
end;
{------------------------------------------------------------------------------}
{ Access to TCustomRichView.MaxLength property }
function TCustomRVData.GetMaxLength: Integer;
begin
  Result := GetAbsoluteRootData.GetMaxLength;
end;
{------------------------------------------------------------------------------}
function TCustomRVData.GetColor: TColor;
begin
  Result := clNone;
end;
{------------------------------------------------------------------------------}
// Convert all units from GetRVStyle.Units to NewUnits
procedure TCustomRVData.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
   RVStyle: TRVStyle; ConvertItems: Boolean);
var i: Integer;
    RVData: TCustomRVData;
begin
  if not ConvertItems then
    exit;
  RVData := GetRVData;
  for i := 0 to RVData.ItemCount-1 do
    RVData.GetItem(i).ConvertToDifferentUnits(NewUnits, RVStyle, True);
end;

initialization
  {$IFNDEF RVDONOTUSERVF}
  RegisterClasses([TBitmap, TIcon, TMetafile]);
  {$IFNDEF RVDONOTUSEJPEGIMAGE}
  RegisterClasses([TJpegImage]);
  {$ENDIF}
  {$ENDIF}
  HTMLGraphicFormats := nil;
  RVPngGraphiClass   := nil;
finalization
  HTMLGraphicFormats.Free;
  HTMLGraphicFormats := nil;


end.