{*******************************************************}
{                                                       }
{       RichView                                        }
{       Basic item types.                               }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVItem;

interface

{$I RV_Defs.inc}

uses
     {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Classes, Windows, Graphics, Controls, Forms,
     {$IFNDEF RVDONOTUSEJPEGIMAGE}
     Jpeg,
     {$ENDIF}
     {$IFDEF RICHVIEWDEF4}
     ImgList,
     {$ENDIF}
     {$IFNDEF RVDONOTUSELIVESPELL}
     RVWordPaint,
     {$ENDIF}
     RVClasses, RVFuncs, RVScroll, RVStyle, DLines, RVGrIn, RVTypes;

type
  { Exception class }
  ERichViewError = class(Exception);

  { Options for RichViewItems }
  TRVItemOption = (
    rvioSameAsPrev,      // item is not a first item on the paragraph [section]
    rvioPageBreakBefore, // item starts a page (rvioSameAsPrev must be excluded)
    rvioBR,              // item starts a paragraph section, but not a paragraph
                         // (rvioSameAsPrev must be excluded)
    rvioUnicode,         // this is an Unicode text item
    rvioClearLeft,       // resets floatings from left
    rvioClearRight,      // resets floatings from right
    rvioGroupWithNext);  // item is grouped with next item
  TRVItemOptions = set of TRVItemOption;

  TRVItemState = (
    rvisSpellChecked);   // this item is completely spell-checked (live spell)
  TRVItemStates = set of TRVItemState;

  { Item drawing states. Used in item.Paint() }
  TRVItemDrawState = (
    rvidsSelected,       // the item is selected
    rvidsCurrent,        // the item is current (active) - at the caret position
    rvidsHover,          // the item is a hypertext item under the mouse pointer
    rvidsPrinting,       // this is not drawing but printing (or previewing)
    rvidsPreview,        // this is drawing for print preview
    rvidsPreviewCorrection, // this is drawing for print preview with preview
                         // correction
    rvidsControlFocused, // RichView has input focus
    rvidsControlDisabled, // RichView is disabled
    rvidsCanUseCustomPPI,// rvflCanUseCustomPPI is in RVData.Flags
    rvidsRTL,            // Current paragraph is RTL
    rvidsShowSpecialCharacters, // rvoShowSpecialCharacters in RVData.Options
    rvidsDrawInplaceOnMainCanvas,
    rvidsPrintSimulation);
  TRVItemDrawStates = set of TRVItemDrawState;

  { RVF reading: reading mode }
  TRVFReadMode = (
    rmText,              // reading ANSI text
    rmBeforeBinary,      // reading line break after ANSI text before binary data
    rmBinary,            // reading binary data
    rmBeforeUnicode,     // reading line break after ANSI text before Unicode text
    rmUnicode,           // reading Unicode text
    rmAfterUnicode);     // reading line break after Unicode text before ANSI text
  { RVF reading: reading state }
  TRVFReadState = (
    rstHeader,           // reading item header
    rstData,             // reading item data lines
    rstSkip);            // skipping unknown lines

  { Identifiers of item boolean properties, for item.GetBoolValue() }
  TRVItemBoolProperty = (
    rvbpIgnorePara,      // ignore paragraph properties (for "breaks")
    rvbpFullWidth,       // full line item (such as "break" or table) [y/n?]
    rvbpValid,           // the item is valid (has correct data)
    rvbpRequiresRVFLines,   // the item has one or more data lines in RVF
    rvbpDrawingChangesFont, // drawing of item may change Canvas.Font
    rvbpCanSaveUnicode,  // the item can represent itself in Unicode
                         // (item.AsText() returns a "raw" Unicode, if Unicode
                         // parameter is True), so RichView does not need
                         // to convert the result of item.AsText() to Unicode
    rvbpAlwaysInText,    // the item must be saved in text, event when saving
                         // the selection
    rvbpImmediateControlOwner, // this item directly owns a VCL control
    rvbpResizable,       // the item can be resized by mouse (RichViewEdit
                         // must create a resizer for it, if this item is selected)
    rvbpResizeHandlesOutside, // resize handles must be drawn not inside, but
                         // outside of item rectangle
    rvbpHasSubRVData,    // item has subdocuments
    rvbpClickSelect,     // item is selected on single click (resizable items
                         //   are always selected on single click)
    rvbpNoHTML_P,        // this item cannot be nested in HTML's <p>...</p>
                         // (<div>...</div> must be used)
    rvbpSwitchToAssStyleNo, // when this item is current, editor must set
                         // current text style to the value of AssociatedTextStyleNo
                         // (if it's >=0)
    rvbpFloating);       // floating item

  { Identifiers of item boolean properties, for item.GetBoolValueEx() }
  TRVItemBoolPropertyEx = (
    rvbpDisplayActiveState, // the item shows its active state (at the position
                            // of caret)
    rvbpPrintToBMP,      // item.PrintToBitmap() must be used instead of item.Print()
    rvbpJump,            // this is a hypertext item
    rvbpAllowsFocus,     // this item can have input focus
    rvbpHotColdJump,     // this hypertext item can be highlighted under
                         // the mouse pointer
    rvbpXORFocus,        // RichView must draw XOR dotted frame, if this item
                         // has input focus
    rvbpActualPrintSize  // item.OnDocWidthChange() returns item size in printer
                         // (not screen) resolution
    );

  { From there the caret enters into the item, for method EnterItem() }
  TRVEnterDirection = (rvedLeft, rvedRight, rvedTop, rvedBottom);

  { Extra item integer properties }
  TRVExtraItemProperty = (
    rvepUnknown,         // (none)
    rvepVShift,          // vertical offset, in pixels or %
    rvepVShiftAbs,       // if <>0, vertical offset is in pixels
    rvepImageWidth,      // image width (for stretching)
    rvepImageHeight,     // image height (for stretching)
    rvepTransparent,     // bitmap image is transparent, see TBitmap.Transparent
    rvepTransparentMode, // see TBitmep.TransparentMode
    rvepTransparentColor,// see TBitmap.TransparentColor
    rvepMinHeightOnPage, // if <>0, the item can be splitted between pages
                         // if the rest of page > this value; such items
                         // are always printed from the new line
    rvepSpacing,         // spacing around the item
    rvepResizable,       // this item (control) is resizable
    rvepDeleteProtect,   // this item cannot be deleted by editing operations
    rvepNoHTMLImageSize, // if<>0, image size is not saved in HTML,
                         //   even if rvsoImageSizes is included in Options
                         //   for SaveHTML
                         //   (this option is ignored if rvepImageWidth or Height
                         //   are non-zero
    rvepAnimationInterval, // for bitmap image items. If nonzero and
                         // imagewidth and/or imageheight are defined,
                         // playing bitmap animation (in imagewidth x imageheight)
                         // frame
    rvepVisible,         // for controls: replacement of TControl.Visible property
    rvepHidden,
    rvepShared);          // shared content (do not free it when the item is destroyed)


  TRVExtraItemStrProperty = (
    rvespUnknown,        // (none)
    rvespHint,           // hint
    rvespAlt,            // text representation of images
    rvespImageFileName); // image file name
  { Type of style changing operation }
  TRVEStyleConversionType = (
    rvscParaStyle,           // ApplyParaStyle
    rvscTextStyle,           // ApplyTextStyle
    rvscParaStyleConversion, // ApplyParaStyleConversion
    rvscTextStyleConversion, // ApplyStyleConversion
    rvscParaStyleTemplate,   // ApplyParaStyleTemplate
    rvscTextStyleTemplate);  // ApplyTextStyleTemplate

  TCustomRVItemInfo = class;

  { ----------------------------------------------------------------------------
    TRVMultiDrawItemPart: ancestor class of items in
    TRVMultiDrawItemInfo.PartsList.
    Inherited classes:
    - TRVImagePrintPart (for TRVMultiImagePrintInfo.PartsList);
    - TRVTablePrintPart (for TRVTablePrintInfo.PartsList).
  }
  TRVMultiDrawItemPart = class
    public
      Height: Integer;
      function GetSoftPageBreakInfo: Integer; dynamic;
      function IsComplexSoftPageBreak(DrawItem: TRVDrawLineInfo): Boolean; dynamic;
      procedure AssignSoftPageBreaksToItem(DrawItem: TRVDrawLineInfo;
        Item: TCustomRVItemInfo); dynamic;
      function GetImageHeight: Integer; virtual;
  end;

  TRVDeleteUnusedStylesData = class
    private
      FInitialized, FConvertedToShifts: Boolean;
      FUsedTextStyles, FUsedParaStyles, FUsedListStyles: TRVIntegerList;
      FTextStyles, FParaStyles, FListStyles: Boolean;
    public
      constructor Create(ATextStyles, AParaStyles, AListStyles: Boolean);
      destructor Destroy; override;
      procedure Init(RVStyle: TRVStyle);
      procedure ConvertFlagsToShifts(RVStyle: TRVStyle);
      property UsedTextStyles: TRVIntegerList read FUsedTextStyles;
      property UsedParaStyles: TRVIntegerList read FUsedParaStyles;
      property UsedListStyles: TRVIntegerList read FUsedListStyles;
      property TextStyles: Boolean read FTextStyles;
      property ParaStyles: Boolean read FParaStyles;
      property ListStyles: Boolean read FListStyles;
      property ConvertedToShifts: Boolean read FConvertedToShifts;
  end;

{------------------------------------------------------------------------------}
  TRVCPInfo = class;
  TRVCPInfo = class
    public
      Name: String;
      Next, Prev: TRVCPInfo;
      RaiseEvent, Persistent: Boolean;
      ItemInfo : TCustomRVItemInfo;
      ItemNo: Integer; // <- not maintained automatically
      Tag: Integer;
      procedure Assign(Source: TRVCPInfo; TagsArePChars: Boolean);
      function CreateCopy(TagsArePChars: Boolean): TRVCPInfo;
  end;
{------------------------------------------------------------------------------}
 TRVSubRVDataPos = (rvdFirst, rvdLast, rvdChosenUp, rvdChosenDown, rvdNext, rvdPrev);
 TRVStoreSubRVData = class
   function Duplicate: TRVStoreSubRVData; dynamic;
   function Compare(StoreSub: TRVStoreSubRVData): Integer; dynamic;
 end;

{------------------------------------------------------------------------------}
  TCustomRVItemInfo = class (TPersistent)
    private
      function GetSameAsPrev: Boolean;
      procedure SetSameAsPrev(const Value: Boolean);
      function GetBR: Boolean;
      procedure SetBR(Value: Boolean);
      function GetPageBreakBefore: Boolean;
      procedure SetPageBreakBefore(const Value: Boolean);
      function GetClearLeft: Boolean;
      function GetClearRight: Boolean;
      procedure SetClearLeft(const Value: Boolean);
      procedure SetClearRight(const Value: Boolean);
    protected
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; dynamic;
      function GetRVFExtraPropertyCount: Integer; dynamic;
      procedure SaveRVFExtraProperties(Stream: TStream); dynamic;
      procedure SetExtraPropertyFromRVFStr(const Str: TRVRawByteString;
        UTF8Strings: Boolean);
      function GetAssociatedTextStyleNo: Integer; virtual;
      procedure SetAssociatedTextStyleNo(Value: Integer); virtual;
    public
      ItemText: TRVRawByteString;
      StyleNo,ParaNo: Integer;
      ItemOptions: TRVItemOptions;
      {$IFNDEF RVDONOTUSELIVESPELL}
      ItemState: TRVItemStates;
      WordPaintList: TRVWordPainterList;
      {$ENDIF}
      Checkpoint: TRVCPInfo;
      JumpID: Integer;
      Tag: Integer;
      DrawItemNo: Integer;
      {$IFNDEF RVDONOTUSEITEMHINTS}
      Hint: String;
      {$ENDIF}
      constructor Create(RVData: TPersistent); virtual;
      {$IFNDEF RVDONOTUSELIVESPELL}
      destructor Destroy; override;
      procedure ClearLiveSpellingResult;
      procedure ClearWordPainters(Index: Integer);
      function AdjustWordPaintersOnInsert(Index: Integer; const Text: String;
        ch: Char; RVData: TPersistent): Boolean;
      function AdjustWordPaintersOnDelete(Index, Count: Integer): Boolean;
      function GetMisspelling(Offs: Integer; var MisOffs, MisLength: Integer): Boolean;
      procedure AddMisspelling(StartOffs, Length: Integer);
      function IsMisspelled(Index: Integer): Boolean;
      function ValidateMisspelledWord(const AItemText, AWord: String): Boolean;
      {$ENDIF}
      procedure Assign(Source: TCustomRVItemInfo); {$IFDEF RICHVIEWDEF4} reintroduce; {$ENDIF} dynamic;
      procedure AssignParaProperties(Source: TCustomRVItemInfo);
      procedure TransferProperties(Source: TCustomRVItemInfo; RVData: TPersistent); dynamic;
      function GetSubRVDataAt(X,Y: Integer; ReturnClosest: Boolean): TPersistent; dynamic;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
        RVData: TPersistent): Integer; virtual;
      function OwnsControl(AControl: TControl): Boolean; dynamic;
      function OwnsInplaceEditor(AEditor: TControl): Boolean; dynamic;
      function CanBeBorderStart: Boolean;
      function ParaStart(CountBR: Boolean): Boolean;
      property SameAsPrev: Boolean read GetSameAsPrev write SetSameAsPrev;
      function AsImage: TGraphic; virtual;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
        const imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); dynamic;
      {$ENDIF}
      function AsText(LineWidth: Integer; RVData: TPersistent;
        const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; dynamic;
      procedure UpdatePaletteInfo(PaletteAction: TRVPaletteAction;
        ForceRecreateCopy: Boolean; Palette: HPALETTE;
        LogPalette: PLogPalette); dynamic;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; dynamic;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; virtual;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
        RVStyle: TRVStyle): Boolean; virtual;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; dynamic;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); dynamic;
      procedure SaveRVFSelection(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer); dynamic;
      procedure SaveTextSelection(Stream: TStream; RVData: TPersistent;
        LineWidth: Integer;
        const Path: String; TextOnly,Unicode: Boolean); dynamic;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer;
        ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1,
        ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
        HiddenParent: Boolean); dynamic;
      procedure FillRTFTables(ColorList: TRVColorList;
        ListOverrideCountList: TRVIntegerList; RVData: TPersistent); dynamic;
      procedure PaintFullWidth(Left, Right, Top: Integer; Canvas: TCanvas;
        State: TRVItemDrawStates;
        Style: TRVStyle; const ClipRect: TRect;
        dli: TRVDrawLineInfo; ExtraX, ExtraY: Integer); virtual;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); virtual;
      function PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean;
        RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
        ColorMode: TRVColorMode):Boolean; virtual;
      procedure Print(Canvas: TCanvas; x,y,x2: Integer; Preview, Correction: Boolean;
        const sad: TRVScreenAndDevice; RichView: TRVScroller; dli: TRVDrawLineInfo;
        Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent); virtual;
      function GetImageWidth(RVStyle: TRVStyle): Integer; virtual;
      function GetImageHeight(RVStyle: TRVStyle): Integer; virtual;
      function GetImageWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; virtual;
      function GetImageHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; virtual;
      function GetBorderWidth: TRVStyleLength; virtual;
      function GetBorderHeight: TRVStyleLength; virtual;

      procedure MovingToUndoList(ItemNo: Integer;
        RVData, AContainerUndoItem: TObject); dynamic;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); dynamic;
      procedure Hiding; dynamic;
      procedure Unhiding(RVData: TObject); dynamic;
      procedure FinalizeUndoGroup; dynamic;

      function MouseMove(Shift: TShiftState; X,Y, ItemNo: Integer;
        RVData: TObject):Boolean; dynamic;
      function MouseDown(Button: TMouseButton; Shift: TShiftState;
        X,Y, ItemNo: Integer; RVData: TObject):Boolean; dynamic;
      function MouseUp(Button: TMouseButton; Shift: TShiftState;
        X,Y, ItemNo: Integer; RVData: TObject):Boolean; dynamic;

      procedure BeforeLoading(FileFormat: TRVLoadFormat); dynamic;
      procedure AfterLoading(FileFormat: TRVLoadFormat); dynamic;
      procedure DeselectPartial; dynamic;
      function PartiallySelected: Boolean; dynamic;
      function CanDeletePartiallySelected: Boolean; dynamic;
      procedure DeletePartiallySelected; dynamic;
      procedure ApplyStyleConversionToSubRVDatas(UserData: Integer;
        SelectedOnly: Boolean; ConvType: TRVEStyleConversionType);dynamic;
      procedure ApplyStyleConversion(RVData: TPersistent; ItemNo,
        UserData: Integer; ConvType: TRVEStyleConversionType); dynamic;
      function CreatePrintingDrawItem(RVData, ParaStyle: TObject;
        const sad: TRVScreenAndDevice): TRVDrawLineInfo; virtual;

      procedure StartExport; dynamic;
      procedure EndExport; dynamic;

      procedure Inserting(RVData: TObject; var Text: TRVRawByteString; Safe: Boolean); virtual;
      procedure Inserted(RVData: TObject; ItemNo: Integer); virtual;
      procedure BeforeUndoChangeProperty; dynamic;
      procedure AfterUndoChangeProperty; dynamic;

      function EnterItem(From: TRVEnterDirection; Coord: Integer): Boolean; dynamic;
      function GetHypertextCursor(RVStyle: TRVStyle): TCursor; dynamic;
      procedure BuildJumps(Left,Top: Integer; var StartJumpNo: Integer; jumps: TList); dynamic;
      procedure Focusing;dynamic;
      function MoveFocus(GoForward: Boolean; var TopLevelRVData: TPersistent;
        var TopLevelItemNo: Integer): Boolean; dynamic;
      procedure ClearFocus; dynamic;
      procedure Execute(RVData:TPersistent);dynamic;
      function AdjustFocusToControl(Control: TControl;
        var TopLevelRVData: TPersistent;
        var TopLevelItemNo: Integer):Boolean;dynamic;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); virtual;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); dynamic;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); dynamic;
      function GetSubRVData(var StoreState: TRVStoreSubRVData;
        Position: TRVSubRVDataPos): TPersistent; dynamic;
      procedure ChooseSubRVData(StoreState: TRVStoreSubRVData); dynamic;
      procedure CleanUpChosen; dynamic;
      procedure ResetSubCoords; dynamic;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty;
        Value: Integer): Boolean; dynamic;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty;
        var Value: Integer): Boolean; dynamic;
      function SetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        const Value: String): Boolean; dynamic;
      function GetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        var Value: String): Boolean; dynamic;
      function SetExtraCustomProperty(const PropName: TRVAnsiString;
        const Value: String): Boolean; dynamic;
      function GetSoftPageBreakDY(Data: Integer): Integer; dynamic;
      function GetActualStyleNo(RVStyle: TRVStyle): Integer;
      procedure DrawBackgroundForPrinting(Canvas: TCanvas;
        const Rect, FullRect: TRect; ColorMode: TRVColorMode;
        ItemBackgroundLayer: Integer;
        GraphicIterface: TRVGraphicInterface); virtual;
      procedure ClearSoftPageBreaks; dynamic;
      {$IFNDEF RVDONOTUSEANIMATION}
      procedure UpdateAnimator(RVData: TObject); dynamic;
      {$ENDIF}
      procedure KeyDown(Key: Word; Shift: Boolean); dynamic;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; Recursive: Boolean); dynamic;
      property BR: Boolean read GetBR write SetBR;
      property PageBreakBefore: Boolean read GetPageBreakBefore write SetPageBreakBefore;
      property ClearLeft: Boolean read GetClearLeft write SetClearLeft;
      property ClearRight: Boolean read GetClearRight write SetClearRight;      
      property AssociatedTextStyleNo: Integer read GetAssociatedTextStyleNo write SetAssociatedTextStyleNo;
  end;

  TCustomRVItemInfoClass = class of TCustomRVItemInfo;

  { TRVItemList - list of items. For compatibility, it simulates a TStringList,
    i.e. text of items is available as default Items property, while items
    themselves are accessible as Objects property.
    Now, item text is a part of item class: TCustomRVItemInfo.ItemText }
  TRVItemList = class(TList)
  private
    function GetItem(Index: Integer): TRVRawByteString;
    function GetObject(Index: Integer): TCustomRVItemInfo;
    procedure SetItem(Index: Integer; const Value: TRVRawByteString);
    procedure SetObject(Index: Integer; const Value: TCustomRVItemInfo);
  public
    procedure AddObject(const ItemText: TRVRawByteString; Item: TCustomRVItemInfo);
    procedure InsertObject(Index: Integer; const ItemText: TRVRawByteString; Item: TCustomRVItemInfo);
    function IndexOfObject(Item: TCustomRVItemInfo): Integer;
    property Items[Index: Integer]: TRVRawByteString read GetItem write SetItem; default;
    property Objects[Index: Integer]: TCustomRVItemInfo read GetObject write SetObject;
  end;


  TRVTextItemInfo = class (TCustomRVItemInfo)
    public
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean; override;
      procedure Execute(RVData:TPersistent);override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); override;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
  end;

  TRVTextItemInfoClass = class of TRVTextItemInfo;

  TRVNonTextItemInfo = class (TCustomRVItemInfo)
    protected
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
    public
      DeleteProtect, Hidden: Boolean;
      function GetLeftOverhang: Integer; virtual;
      procedure AdjustInserted(x,y: Integer; adjusty: Boolean; RVStyle: TRVStyle); virtual;
      procedure Assign(Source: TCustomRVItemInfo); override;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean; override;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean; override;
      function GetHeight(RVStyle: TRVStyle): Integer; virtual;
      function GetWidth(RVStyle: TRVStyle): Integer;  virtual;
      function GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; virtual;
      function GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;  virtual;
  end;

  TRVFullLineItemInfo = class (TRVNonTextItemInfo)
    public
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
  end;

  TRVRectItemInfo = class (TRVNonTextItemInfo)
    protected
      FMinHeightOnPage: Integer;
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; override;
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
      {$IFNDEF RVDONOTUSEHTML}
      function GetVShiftCSS(RVStyle: TRVStyle): TRVAnsiString;
      {$ENDIF}
    public
      VAlign: TRVVAlign;
      VShift: Integer;
      VShiftAbs: Boolean;
      Spacing: TRVStyleLength;
      constructor Create(RVData: TPersistent); override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean; override;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean; override;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBorderWidth: TRVStyleLength; override;
      function GetBorderHeight: TRVStyleLength; override;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits; RVStyle: TRVStyle;
        Recursive: Boolean); override;
  end;

  TRVTabItemInfo = class (TRVRectItemInfo)
    private
      procedure DrawTab(Canvas: TCanvas; x, y: Integer; dli: TRVDrawLineInfo;
        Style: TRVStyle; TextDrawState: TRVTextDrawStates;
        CanUseCustomPPI, RTL, SpecialChars, Printing: Boolean;
        ColorMode: TRVColorMode);
    protected
      function GetAssociatedTextStyleNo: Integer; override;
      procedure SetAssociatedTextStyleNo(Value: Integer); override;
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; override;
      function GetActualStyleNo(RVStyle: TRVStyle): Integer;
    public
      TextStyleNo: Integer;
      Leader: String;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
        RVStyle: TRVStyle): Boolean; override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); override;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); override;
      procedure Print(Canvas: TCanvas; x,y,x2: Integer;
        Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
        RichView: TRVScroller; 
        dli: TRVDrawLineInfo; Part: Integer; ColorMode: TRVColorMode;
        RVData: TPersistent); override;
      procedure ApplyStyleConversion(RVData: TPersistent;
        ItemNo, UserData: Integer;
        ConvType: TRVEStyleConversionType); override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer;
        ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1,
        ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
        HiddenParent: Boolean); override;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
        const imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function AsText(LineWidth: Integer; RVData: TPersistent;
        const Text: TRVRawByteString; const Path: String;
        TextOnly, Unicode: Boolean): TRVRawByteString; override;
  end;

  TRVControlItemInfo = class (TRVRectItemInfo)
    protected
      FResizable, FVisible, FShared: Boolean;
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
    public
      Control:  TControl;
      PercentWidth: Integer;
      constructor CreateEx(RVData: TPersistent;AControl: TControl; AVAlign: TRVVAlign);
      constructor Create(RVData: TPersistent); override;
      function GetHeight(RVStyle: TRVStyle): Integer; override;
      function GetWidth(RVStyle: TRVStyle): Integer; override;
      function GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      function GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;  override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      destructor Destroy; override;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas; RVData: TPersistent): Integer; override;
      procedure AdjustInserted(x,y: Integer; adjusty: Boolean; RVStyle: TRVStyle); override;
      function PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean; RichView: TRVScroller;
        dli: TRVDrawLineInfo; Part: Integer; ColorMode: TRVColorMode):Boolean; override;
      function CreatePrintingDrawItem(RVData, ParaStyle: TObject;
        const sad: TRVScreenAndDevice): TRVDrawLineInfo; override;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); override;
      function OwnsControl(AControl: TControl): Boolean; override;
      function AsText(LineWidth: Integer; RVData: TPersistent;
        const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
        const imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean; override;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean; override;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVList; HiddenParent: Boolean); override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean; override;
      function GetImageHeight(RVStyle: TRVStyle): Integer; override;
      function GetImageWidth(RVStyle: TRVStyle): Integer; override;
      procedure MovingToUndoList(ItemNo: Integer; RVData, AContainerUndoItem: TObject); override;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); override;
      procedure Hiding; override;
      procedure Unhiding(RVData: TObject); override;
      procedure Inserting(RVData: TObject; var Text: TRVRawByteString; Safe: Boolean); override;
      procedure Focusing; override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo; Printing: Boolean;
        Canvas: TCanvas; RVData: TPersistent; sad: PRVScreenAndDevice;
        var HShift, Desc: Integer; NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      property MinHeightOnPage: Integer read FMinHeightOnPage write FMinHeightOnPage;
  end;

  TRVGraphicItemInfo = class (TRVRectItemInfo)
    protected
      {$IFNDEF RVDONOTUSEANIMATION}
      FAnimator: TObject;
      {$ENDIF}
      FResizable, FShared: Boolean;
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
      procedure PrepareImage;
    public
      Image, ImageCopy: TGraphic;
      ImageWidth, ImageHeight: TRVStyleLength;
      Interval : Integer;
      NoHTMLImageSize: Boolean;
      Alt, ImageFileName: String;
      constructor CreateEx(RVData: TPersistent; AImage: TGraphic; AVAlign: TRVVAlign); virtual;
      constructor Create(RVData: TPersistent); override;
      function GetHeight(RVStyle: TRVStyle): Integer; override;
      function GetWidth(RVStyle: TRVStyle): Integer; override;
      function GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      function GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;  override;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; Recursive: Boolean); override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      procedure TransferProperties(Source: TCustomRVItemInfo;
        RVData: TPersistent); override;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty;
        Value: Integer): Boolean; override;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty;
        var Value: Integer): Boolean; override;
      function SetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        const Value: String): Boolean; override;
      function GetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        var Value: String): Boolean; override;
      procedure UpdatePaletteInfo(PaletteAction: TRVPaletteAction;
        ForceRecreateCopy: Boolean; Palette: HPALETTE;
        LogPalette: PLogPalette); override;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
        RVData: TPersistent): Integer; override;
      destructor Destroy; override;
      function AsImage: TGraphic; override;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean; override;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
        const imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
        SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVList; HiddenParent: Boolean); override;
      function PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean; RichView: TRVScroller;
        dli: TRVDrawLineInfo; Part: Integer; ColorMode: TRVColorMode):Boolean; override;
      procedure Print(Canvas: TCanvas; x,y,x2: Integer; Preview, Correction: Boolean;
        const sad: TRVScreenAndDevice; RichView: TRVScroller; dli: TRVDrawLineInfo;
        Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent); override;
      function GetImageHeight(RVStyle: TRVStyle): Integer; override;
      function GetImageWidth(RVStyle: TRVStyle): Integer; override;
      function GetImageHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      function GetImageWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      procedure MovingToUndoList(ItemNo: Integer; RVData, AContainerUndoItem: TObject); override;
      function CreatePrintingDrawItem(RVData, ParaStyle: TObject;
        const sad: TRVScreenAndDevice): TRVDrawLineInfo; override;
      {$IFNDEF RVDONOTUSEANIMATION}
      procedure UpdateAnimator(RVData: TObject); override;
      {$ENDIF}
      property MinHeightOnPage: Integer read FMinHeightOnPage write FMinHeightOnPage;
      property Shared: Boolean read FShared write FShared;
  end;

  TRVGraphicItemInfoClass = class of TRVGraphicItemInfo;

  TRVHotGraphicItemInfo = class(TRVGraphicItemInfo)
    public
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean; override;
      constructor CreateEx(RVData: TPersistent; AImage: TGraphic; AVAlign: TRVVAlign); override;
      procedure Execute(RVData:TPersistent); override;
  end;

  TRVBulletItemInfo = class (TRVRectItemInfo)
    protected
      function GetImageIndex(Hot: Boolean): Integer; virtual;
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; override;
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
    public
      ImageList: TCustomImageList;
      ImageIndex: Integer;
      NoHTMLImageSize: Boolean;
      Alt: String;
      constructor CreateEx(RVData: TPersistent; AImageIndex: Integer;
        AImageList: TCustomImageList; AVAlign: TRVVAlign);
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent; ItemNo: Integer;
        const Text: TRVRawByteString; const Path: String; const imgSavePrefix: String;
        var imgSaveNo: Integer; CurrentFileColor: TColor;
        SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function GetHeight(RVStyle: TRVStyle): Integer; override;
      function GetWidth(RVStyle: TRVStyle): Integer; override;
      function GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      function GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer; override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
        RVData: TPersistent): Integer; override;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); override;
      function PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean; RichView: TRVScroller;
        dli: TRVDrawLineInfo; Part: Integer; ColorMode: TRVColorMode):Boolean; override;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVList; HiddenParent: Boolean); override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
        RVStyle: TRVStyle): Boolean; override;
      function SetExtraIntProperty(Prop: TRVExtraItemProperty;
        Value: Integer): Boolean; override;
      function GetExtraIntProperty(Prop: TRVExtraItemProperty;
        var Value: Integer): Boolean; override;
      function SetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        const Value: String): Boolean; override;
      function GetExtraStrProperty(Prop: TRVExtraItemStrProperty;
        var Value: String): Boolean; override;
      function GetImageHeight(RVStyle: TRVStyle): Integer; override;
      function GetImageWidth(RVStyle: TRVStyle): Integer; override;
  end;

  TRVHotspotItemInfo = class (TRVBulletItemInfo)
    protected
      function GetImageIndex(Hot: Boolean): Integer; override;
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; override;
    public
      HotImageIndex: Integer;
      constructor CreateEx(RVData: TPersistent; AImageIndex, AHotImageIndex: Integer;
                           AImageList: TCustomImageList; AVAlign: TRVVAlign);
      procedure Assign(Source: TCustomRVItemInfo); override;
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
                        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
                        ForceSameAsPrev: Boolean); override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;override;
      procedure Execute(RVData:TPersistent);override;
  end;

  TRVBreakItemInfo = class (TRVFullLineItemInfo)
    protected
      function SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString; override;
    public
      LineWidth: TRVStyleLength;
      Style: TRVBreakStyle;
      Color: TColor;
      constructor CreateEx(RVData: TPersistent; ALineWidth: Byte; AStyle: TRVBreakStyle; AColor: TColor);
      procedure Assign(Source: TCustomRVItemInfo); override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      procedure PaintFullWidth(Left, Right, Top: Integer; Canvas: TCanvas;
        State: TRVItemDrawStates; Style: TRVStyle; const ClipRect: TRect;
        dli: TRVDrawLineInfo; ExtraX, ExtraY: Integer); override;
      procedure Print(Canvas: TCanvas; x,y,x2: Integer; Preview, Correction: Boolean;
        const sad: TRVScreenAndDevice; RichView: TRVScroller; dli: TRVDrawLineInfo;
        Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent); override;
      function AsText(LineWidth: Integer; RVData: TPersistent;
        const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
        const imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent; ItemNo, ParaNo: Integer;
                        const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
                        ForceSameAsPrev: Boolean); override;
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
        FontTable: TRVList; HiddenParent: Boolean); override;
      procedure FillRTFTables(ColorList: TRVColorList; ListOverrideCountList: TRVIntegerList;
        RVData: TPersistent); override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;override;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; Recursive: Boolean); override;

  end;

  function RV_DuplicateItem(Source: TCustomRVItemInfo;
    RVData: TPersistent; DuplicateCheckpoint: Boolean): TCustomRVItemInfo;
  procedure RegisterRichViewItemClass(StyleNo: Integer; ItemClass: TCustomRVItemInfoClass);
  function CreateRichViewItem(StyleNo: Integer; RVData: TPersistent): TCustomRVItemInfo;
  function RVFGetItemOptions(ItemOptions: TRVItemOptions; ForceSameAsPrev: Boolean): TRVItemOptions;
  procedure RVSaveImageToRTF(Stream: TStream; RVStyle: TRVStyle;
    Image: TGraphic; ImageWidth, ImageHeight: TRVStyleLength; Options: TRVRTFOptions;
    Animator: TObject);
  procedure RVSaveImageListImageToRTF(Stream: TStream;
    TwipsPerPixel: Double; ImageList: TCustomImageList; ImageIndex: Integer;
    RTFOptions: TRVRTFOptions);
  {$IFNDEF RVDONOTUSEHTML}
  procedure RVSaveImageSharedImageInHTML(ImageList: TCustomImageList;
    ImageIndex: Integer; Graphic: TGraphic; var Location: String;
    RVData: TPersistent; const Path,
    imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
    SaveOptions: TRVSaveOptions;
    Bullets: TRVList);
  function RV_GetExtraIMGStr(SaveOptions: TRVSaveOptions; Width, Height: Integer;
    NoHTMLImageSize: Boolean): TRVAnsiString;
  {$ENDIF}

var
  RichViewTextItemClass: TRVTextItemInfoClass;
  RichViewFloatingPlaceHolderHeight: Integer = 5;

const
  RVItemOptionsMask = $3F;

procedure WriteRVFExtraIntPropertyStr(Stream: TStream; Prop: TRVExtraItemProperty;
  Value: Integer);
procedure WriteRVFExtraStrPropertyStr(Stream: TStream; Prop: TRVExtraItemStrProperty;
  const Value: String);
procedure RVDrawEdge(Canvas: TCanvas; r: TRect;
  TopLeftColor, BottomRightColor: TColor; LineWidth: Integer;
  GraphicInterface: TRVGraphicInterface);

implementation
uses RVFMisc,RichView, PtblRV, PtRVData, CRVData, CRVFData, RVUni, RVStr, CtrlImg,
     RVAnimate
     {$IFNDEF RVDONOTUSELISTS}
     , RVMarker
     {$ENDIF}
     ;
procedure RichView_InitializeList; forward;

{------------------------------------------------------------------------------}
function RVFGetItemOptions(ItemOptions: TRVItemOptions;
  ForceSameAsPrev: Boolean): TRVItemOptions;
begin
  Result := ItemOptions;
  if ForceSameAsPrev then begin
    Include(Result, rvioSameAsPrev);
    Exclude(Result, rvioBR);
    Exclude(Result, rvioPageBreakBefore);
    Exclude(Result, rvioClearLeft);
    Exclude(Result, rvioClearRight);    
  end;
end;
{============================= TRVDeleteUnusedStylesData ======================}
constructor TRVDeleteUnusedStylesData.Create(ATextStyles, AParaStyles,
  AListStyles: Boolean);
begin
  inherited Create;
  FTextStyles := ATextStyles;
  FParaStyles := AParaStyles;
  FListStyles := AListStyles;
end;
{------------------------------------------------------------------------------}
destructor TRVDeleteUnusedStylesData.Destroy;
begin
  FUsedTextStyles.Free;
  FUsedParaStyles.Free;
  FUsedListStyles.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVDeleteUnusedStylesData.Init(RVStyle: TRVStyle);
    {............................................}
    procedure MarkStandardStyles(Styles: TCustomRVInfos; Used: TRVIntegerList);
    var i: Integer;
    begin
      for i := 0 to Used.Count-1 do
        if TCustomRVInfo(Styles.Items[i]).Standard then
          Used[i] := 1;
    end;
    {............................................}
begin
  if FInitialized then
    exit;
  FUsedTextStyles := TRVIntegerList.CreateEx(RVStyle.TextStyles.Count, ord(not FTextStyles));
  FUsedParaStyles := TRVIntegerList.CreateEx(RVStyle.ParaStyles.Count, ord(not FParaStyles));
  FUsedListStyles := TRVIntegerList.CreateEx(RVStyle.ListStyles.Count, ord(not FListStyles));
  {$IFNDEF RVDONOTUSEUNICODE}
  if FTextStyles and (RVStyle.DefUnicodeStyle>=0) then
    if RVStyle.DefUnicodeStyle>=FUsedTextStyles.Count then
      RVStyle.DefUnicodeStyle := -1
    else
      FUsedTextStyles[RVStyle.DefUnicodeStyle] := 1;
  {$ENDIF}
  if FTextStyles then
    MarkStandardStyles(RVStyle.TextStyles, FUsedTextStyles);
  if FParaStyles then
    MarkStandardStyles(RVStyle.ParaStyles, FUsedParaStyles);
  if FListStyles then
    MarkStandardStyles(RVStyle.ListStyles, FUsedListStyles);
  FInitialized := True;
end;
{------------------------------------------------------------------------------}
procedure TRVDeleteUnusedStylesData.ConvertFlagsToShifts(RVStyle: TRVStyle);
    {............................................}
    procedure UpdStyles(Styles: TCustomRVInfos; Used: TRVIntegerList);
    var i,idx,val: Integer;
        IsTextStyle, IsParaStyle: Boolean;
    begin
      IsTextStyle := Styles is TFontInfos;
      IsParaStyle := Styles is TParaInfos;
      idx := 1;
      for i := 0 to Used.Count-1 do
        if Used[i]=0 then
          inc(idx)
        else
          Used[i] := idx;
      for i := Used.Count-1 downto 0 do
        if Used[i]=0 then
          Styles.Items[i].Free;
      for i := 0 to Styles.Count-1 do begin
        val := TCustomRVInfo(Styles.Items[i]).BaseStyleNo;
        if val>=0 then
          if val>=Used.Count then
            TCustomRVInfo(Styles.Items[i]).BaseStyleNo := -1
          else
            TCustomRVInfo(Styles.Items[i]).BaseStyleNo := val-Used[val]+1;
        if IsTextStyle then begin
          val := TFontInfo(Styles.Items[i]).NextStyleNo;
          if val>=0 then
            if val>=Used.Count then
              TFontInfo(Styles.Items[i]).NextStyleNo := -1
            else
              TFontInfo(Styles.Items[i]).NextStyleNo := val-Used[val]+1;
          end
        else if IsParaStyle then begin
          val := TParaInfo(Styles.Items[i]).NextParaNo;
          if val>=0 then
            if val>=Used.Count then
              TParaInfo(Styles.Items[i]).NextParaNo := -1
            else
              TParaInfo(Styles.Items[i]).NextParaNo := val-Used[val]+1;
          if FTextStyles then begin
            val := TParaInfo(Styles.Items[i]).DefStyleNo;
            if val>=0 then
              if val>=FUsedTextStyles.Count then
                TParaInfo(Styles.Items[i]).DefStyleNo := -1
              else
                TParaInfo(Styles.Items[i]).DefStyleNo := val-FUsedTextStyles[val]+1;
          end;
        end;
      end;
    end;
    {............................................}
begin
  if FConvertedToShifts then
    exit;
  if FTextStyles then
    UpdStyles(RVStyle.TextStyles, FUsedTextStyles);
  if FParaStyles then
    UpdStyles(RVStyle.ParaStyles, FUsedParaStyles);
  if FListStyles then
    UpdStyles(RVStyle.ListStyles, FUsedListStyles);
  FConvertedToShifts := True;
end;
{============================= TRVCPInfo ======================================}
procedure TRVCPInfo.Assign(Source: TRVCPInfo; TagsArePChars: Boolean);
begin
  Name       := Source.Name;
  RaiseEvent := Source.RaiseEvent;
  Tag        := RV_CopyTag(Source.Tag, TagsArePChars);
  Persistent := Source.Persistent;
  //DrawItemNo, Next, Prev, ItemInfo are not copied
end;
{------------------------------------------------------------------------------}
function TRVCPInfo.CreateCopy(TagsArePChars: Boolean): TRVCPInfo;
begin
  Result := TRVCPInfo.Create;
  Result.Assign(Self,TagsArePChars);
end;
{========================= TRVImagePrintPart ==================================}
type
  TRVImagePrintPart = class (TRVMultiDrawItemPart)
    public
      ImgTop, ImgHeight: Integer;
      function GetSoftPageBreakInfo: Integer; override;
      function GetImageHeight: Integer; override;
  end;

function TRVImagePrintPart.GetSoftPageBreakInfo: Integer;
begin
  Result := ImgTop;
end;
{------------------------------------------------------------------------------}
function TRVImagePrintPart.GetImageHeight: Integer;
begin
  Result := ImgHeight;
end;
{========================= TRVMultiImagePrintInfo =============================}
type
  TRVMultiImagePrintInfo = class (TRVMultiDrawItemInfo)
    private
      FItem: TRVRectItemInfo;
      FRVData: TCustomRVData;
    public
      constructor Create(AItem: TRVRectItemInfo; RVData: TCustomRVData);
      procedure SetSize(AWidth, AHeight: Integer); override;
      function InitSplit(const Sad: TRVScreenAndDevice): Boolean; override;
      function CanSplitFirst(Y: Integer; const Sad: TRVScreenAndDevice;
        FirstOnPage, PageHasFootnotes, FootnotesChangeHeight: Boolean): Boolean; override;
      function SplitAt(Y: Integer; const Sad: TRVScreenAndDevice;
        FirstOnPage: Boolean; var FootnoteRVDataList: TList;
        var MaxHeight: Integer; FootnotesChangeHeight: Boolean): Boolean; override;
  end;
{------------------------------------------------------------------------------}
constructor TRVMultiImagePrintInfo.Create(AItem: TRVRectItemInfo; RVData: TCustomRVData);
begin
  inherited Create;
  FItem := AItem;
  FRVData := RVData;
end;
{------------------------------------------------------------------------------}
function TRVMultiImagePrintInfo.CanSplitFirst(Y: Integer;
  const Sad: TRVScreenAndDevice; FirstOnPage, PageHasFootnotes,
  FootnotesChangeHeight: Boolean): Boolean;
var RVStyle: TRVStyle;
begin
  RVStyle := FRVData.GetRVStyle;
  Y := RV_YToScreen(Y, sad);
  Result :=
    (Y>0) and
    FItem.GetBoolValueEx(rvbpPrintToBMP, nil) and
    (FItem.FMinHeightOnPage>0) and
    not FItem.GetBoolValue(rvbpFloating) and
    (Y>=FItem.FMinHeightOnPage+RVStyle.GetAsPixels(FItem.GetBorderHeight)*2) and
    ((FItem.GetImageHeight(RVStyle)-Y >= FItem.FMinHeightOnPage) or
    (Y>FItem.GetImageHeight(RVStyle)+RVStyle.GetAsPixels(FItem.GetBorderHeight)*2));
end;
{------------------------------------------------------------------------------}
function TRVMultiImagePrintInfo.InitSplit(const Sad: TRVScreenAndDevice): Boolean;
var part: TRVImagePrintPart;
begin
  Result := FItem.FMinHeightOnPage<>0;
  if not Result then
    exit;
  part := TRVImagePrintPart.Create;
  part.ImgTop := 0;
  part.ImgHeight := FItem.GetImageHeight(FRVData.GetRVStyle);
  part.Height := RV_YToDevice(part.ImgHeight+FRVData.GetRVStyle.GetAsPixels(FItem.GetBorderHeight)*2, sad);
  PartsList.Add(part);
end;
{------------------------------------------------------------------------------}
function TRVMultiImagePrintInfo.SplitAt(Y: Integer;
  const Sad: TRVScreenAndDevice; FirstOnPage: Boolean;
  var FootnoteRVDataList: TList; var MaxHeight: Integer;
  FootnotesChangeHeight: Boolean): Boolean;
var PrevHeight, NewHeight, PrevTop: Integer;
    part: TRVImagePrintPart;
    DblBorderHeight: Integer;
begin
  if FItem.FMinHeightOnPage<=0 then begin
    Result := False;
    exit;
  end;
  if PartsList.Count=0 then
    raise ERichViewError.Create(errRVPrint);
  part := TRVImagePrintPart(PartsList[PartsList.Count-1]);
  if (part.ImgHeight<=FItem.FMinHeightOnPage) then begin
    Result := False;
    exit;
  end;
  DblBorderHeight := FRVData.GetRVStyle.GetAsPixels(FItem.GetBorderHeight)*2;
  PrevHeight := RV_YToScreen(Y, sad)-DblBorderHeight;
  NewHeight := part.ImgHeight-PrevHeight;
  if (NewHeight<FItem.FMinHeightOnPage) or (PrevHeight<FItem.FMinHeightOnPage) then begin
    Result := False;
    exit;
  end;
  part.ImgHeight := PrevHeight;
  part.Height := RV_YToDevice(part.ImgHeight+DblBorderHeight, sad);
  PrevTop := part.ImgTop;

  part := TRVImagePrintPart.Create;
  part.ImgTop := PrevTop+PrevHeight;
  part.ImgHeight := NewHeight;
  part.Height := RV_YToDevice(part.ImgHeight+DblBorderHeight, sad);
  PartsList.Add(part);
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVMultiImagePrintInfo.SetSize(AWidth, AHeight: Integer);
begin
  // do nothing
end;
{==============================================================================}
type
  TRichViewItemTypeInfo = class
    public
      StyleNo: Integer;
      ItemClass: TCustomRVItemInfoClass;
  end;

const RichViewItemClassesList: TList = nil;
{------------------------------------------------------------------------------}
const RVFExtraItemIntPropNames: array [TRVExtraItemProperty] of TRVAnsiString =
  ('', 'vshift', 'vshiftabs', 'width', 'height', 'transparent', 'tmode',
   'tcolor', 'minheightonpage', 'spacing', 'resizable', 'unremovable',
   'nohtmlsize', 'ainterval', 'visible', 'hidden', 'shared');
const RVFExtraItemStrPropNames: array [TRVExtraItemStrProperty] of TRVAnsiString =
  ('', 'hint', 'alt', 'filename');

function GetRVFExtraIntPropertyByName(const PropName: TRVAnsiString):TRVExtraItemProperty;
var i: TRVExtraItemProperty;
begin
  Result := rvepUnknown;
  for i := Low(TRVExtraItemProperty) to High(TRVExtraItemProperty) do
    if RVFExtraItemIntPropNames[i]=PropName then begin
      Result := i;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
function GetRVFExtraStrPropertyByName(const PropName: TRVAnsiString):TRVExtraItemStrProperty;
var i: TRVExtraItemStrProperty;
begin
  Result := rvespUnknown;
  for i := Low(TRVExtraItemStrProperty) to High(TRVExtraItemStrProperty) do
    if RVFExtraItemStrPropNames[i]=PropName then begin
      Result := i;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure WriteRVFExtraIntPropertyStr(Stream: TStream; Prop: TRVExtraItemProperty;
  Value: Integer);
begin
  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%s=%d', [RVFExtraItemIntPropNames[Prop], Value]));
end;
{------------------------------------------------------------------------------}
procedure WriteRVFExtraStrPropertyStr(Stream: TStream; Prop: TRVExtraItemStrProperty;
  const Value: String);
begin
  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%s=%s', [RVFExtraItemStrPropNames[Prop], StringToRVFString(Value)]));
end;
{------------------------------------------------------------------------------}
procedure RegisterRichViewItemClass(StyleNo: Integer; ItemClass: TCustomRVItemInfoClass);
var i: Integer;
    item: TRichViewItemTypeInfo;
begin
  if RichViewItemClassesList=nil then
    RichView_InitializeList;
  if StyleNo>=-9 then
    raise ERichViewError.Create(errRVItemReg2);
  for i := 0 to RichViewItemClassesList.Count-1 do
    if TRichViewItemTypeInfo(RichViewItemClassesList[i]).StyleNo=StyleNo then begin
      if TRichViewItemTypeInfo(RichViewItemClassesList[i]).ItemClass=ItemClass then
        exit;
      raise ERichViewError.Create(errRVItemReg2);
    end;
  item := TRichViewItemTypeInfo.Create;
  item.StyleNo := StyleNo;
  item.ItemClass := ItemClass;
  RichViewItemClassesList.Add(item);
end;
{------------------------------------------------------------------------------}
function CreateRichViewItem(StyleNo: Integer; RVData: TPersistent): TCustomRVItemInfo;
var i: Integer;
begin
  if StyleNo>=0 then begin
    Result := RichViewTextItemClass.Create(RVData);
    Result.StyleNo := StyleNo;
    exit;
  end;
  Result := nil;
  case StyleNo of
    rvsBullet:
      Result := TRVBulletItemInfo.Create(RVData);
    rvsHotspot:
      Result := TRVHotspotItemInfo.Create(RVData);
    rvsPicture:
      Result := TRVGraphicItemInfo.Create(RVData);
    rvsComponent:
      Result := TRVControlItemInfo.Create(RVData);
    rvsBreak:
      Result := TRVBreakItemInfo.Create(RVData);
    rvsHotPicture:
      Result := TRVHotGraphicItemInfo.Create(RVData);
    {$IFNDEF RVDONOTUSELISTS}
    rvsListMarker:
      Result := TRVMarkerItemInfo.Create(RVData);
    {$ENDIF}
    rvsTab:
      Result := TRVTabItemInfo.Create(RVData);
  end;
  if Result<>nil then begin
    Result.StyleNo := StyleNo;
    exit;
  end;
  for i := 0 to RichViewItemClassesList.Count-1 do
    if TRichViewItemTypeInfo(RichViewItemClassesList[i]).StyleNo=StyleNo then begin
      Result := TRichViewItemTypeInfo(RichViewItemClassesList[i]).ItemClass.Create(RVData);
      Result.StyleNo := StyleNo;
      exit;
    end;
  Result := nil;
end;
{------------------------------------------------------------------------------}
procedure RichView_InitializeList;
begin
  if RichViewItemClassesList=nil then
    RichViewItemClassesList := TList.Create;
end;
{------------------------------------------------------------------------------}
procedure RichView_FinalizeList;
var i: Integer;
begin
  for i := 0 to RichViewItemClassesList.Count-1 do
    TRichViewItemTypeInfo(RichViewItemClassesList.Items[i]).Free;
  RichViewItemClassesList.Free;
end;
{==============================================================================}
function RV_DuplicateItem(Source: TCustomRVItemInfo; RVData: TPersistent;
  DuplicateCheckpoint: Boolean): TCustomRVItemInfo;
var TagsArePChars: Boolean;
begin
  TagsArePChars := rvoTagsArePChars in TCustomRVData(RVData).Options;
  Result := TCustomRVItemInfoClass(Source.ClassType).Create(RVData);
  Result.StyleNo := Source.StyleNo;
  Result.Assign(Source);
  if DuplicateCheckpoint and (Source.Checkpoint<>nil) then begin
    Result.Checkpoint := TRVCPInfo.Create;
    Result.Checkpoint.Assign(Source.Checkpoint, TagsArePChars);
  end;
  Result.Tag  := RV_CopyTag(Source.Tag, TagsArePChars)
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function GetHTMLImageAlign(Align: TRVVAlign; SaveOptions: TRVSaveOptions;
  CSSVersion: Boolean): TRVAnsiString;
begin
  case Align of
    rvvaMiddle:
      Result := 'middle';
    rvvaAbsTop:
      Result := 'top';
    rvvaAbsBottom:
      Result := 'absbottom';
    rvvaAbsMiddle:
      Result := 'absmiddle';
    rvvaLeft:
      Result := 'left';
    rvvaRight:
      Result := 'right';
    else
      begin
        Result := '';
        exit;
      end;
  end;
  if (rvsoXHTML in SaveOptions) then
    Result := '"'+Result+'"';
  Result := ' align='+Result;
end;
{$ENDIF}
{======================= TCustomRVItemInfo ====================================}
constructor TCustomRVItemInfo.Create;
begin
  inherited Create;
  DrawItemNo := -1;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELIVESPELL}
destructor TCustomRVItemInfo.Destroy;
begin
  WordPaintList.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ClearLiveSpellingResult;
var i: Integer;
begin
  Exclude(ItemState, rvisSpellChecked);
  if WordPaintList<>nil then begin
    for i := WordPaintList.Count-1 downto 0 do
      if WordPaintList[i] is TRVWordMisspellPainter then
        WordPaintList.Delete(i);
    if WordPaintList.Count=0 then begin
      WordPaintList.Free;
      WordPaintList := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ClearWordPainters(Index: Integer);
var i: Integer;
begin
  Exclude(ItemState, rvisSpellChecked);
  if WordPaintList<>nil then begin
    if Index<=1 then begin
      WordPaintList.Free;
      WordPaintList := nil;
      end
    else begin
      for i := WordPaintList.Count-1 downto 0 do
        if WordPaintList[i].StartOffs+WordPaintList[i].Length>Index then
          WordPaintList.Delete(i);
      if WordPaintList.Count=0 then begin
        WordPaintList.Free;
        WordPaintList := nil;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.AdjustWordPaintersOnInsert(Index: Integer;
  const Text: String; ch: Char; RVData: TPersistent): Boolean;
var i, d, d2: Integer;
begin
  Result :=
  {$IFDEF RVUNICODESTR}
    TCustomRVData(RVData).IsDelimiterW(ch);
  {$ELSE}
    TCustomRVData(RVData).IsDelimiterA(ch, TCustomRVData(RVData).GetItemCodePage2(Self));
  {$ENDIF}
  if Result then
    d := 0
  else
    d := 1;
  if not Result and (Index-1>0) and (Index-1<=Length(Text)) and
    ((Text[Index-1]='''') or (Text[Index-1]=RVCHAR_RQUOTE)) then
    d2 := 2
  else
    d2 := d;
  if WordPaintList<>nil then begin
    for i := WordPaintList.Count-1 downto 0 do
      if WordPaintList[i].StartOffs+WordPaintList[i].Length+d2>Index then
        if WordPaintList[i].StartOffs<Index+d then begin
          WordPaintList.Delete(i);
          Result := True;
          end
        else
          inc(WordPaintList[i].StartOffs);
    if WordPaintList.Count=0 then begin
      WordPaintList.Free;
      WordPaintList := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.AdjustWordPaintersOnDelete(Index, Count: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  if WordPaintList<>nil then begin
    for i := WordPaintList.Count-1 downto 0 do
      if WordPaintList[i].StartOffs+WordPaintList[i].Length+1>Index+Count-1 then
        if WordPaintList[i].StartOffs<=Index+1 then begin
          WordPaintList.Delete(i);
          Result := True;
          end
        else
          dec(WordPaintList[i].StartOffs, Count);
    if WordPaintList.Count=0 then begin
      WordPaintList.Free;
      WordPaintList := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetMisspelling(Offs: Integer;
  var MisOffs, MisLength: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  if WordPaintList<>nil then begin
    for i := WordPaintList.Count-1 downto 0 do
      if (WordPaintList[i].StartOffs+WordPaintList[i].Length+1>Offs) and
         (WordPaintList[i].StartOffs<=Offs) and
         (WordPaintList[i] is TRVWordMisspellPainter) then begin
        Result := True;
        MisOffs := WordPaintList[i].StartOffs;
        MisLength := WordPaintList[i].Length;
        exit;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.IsMisspelled(Index: Integer): Boolean;
var i: Integer;
begin
  Result := False;
  if WordPaintList<>nil then
    for i := 0 to WordPaintList.Count-1 do begin
      Result := (WordPaintList[i].StartOffs<=Index) and
        (WordPaintList[i].StartOffs+WordPaintList[i].Length>Index) and
        (WordPaintList[i] is TRVWordMisspellPainter);
      if Result then
        exit;
    end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.ValidateMisspelledWord(const AItemText, AWord: String): Boolean;
var i: Integer;
    painter: TRVWordPainter;
begin
  Result := False;
  if WordPaintList<>nil then begin
    for i := WordPaintList.Count-1 downto 0 do begin
      painter := WordPaintList[i];
      if (painter is TRVWordMisspellPainter) and
         (Copy(AItemText, painter.StartOffs, painter.Length)=AWord) then begin
        WordPaintList.Delete(i);
        Result := True;
      end;
    end;
    if WordPaintList.Count=0 then begin
      WordPaintList.Free;
      WordPaintList := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.AddMisspelling(StartOffs, Length: Integer);
var painter: TRVWordMisspellPainter;
begin
  painter := TRVWordMisspellPainter.Create(StartOffs, Length);
  if WordPaintList=nil then
    WordPaintList := TRVWordPainterList.Create;
  WordPaintList.Add(painter)
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source.ClassType=ClassType then
    StyleNo := Source.StyleNo;
  ParaNo  := Source.ParaNo;
  ItemOptions := Source.ItemOptions;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  Hint    := Source.Hint;
  {$ENDIF}
  // Checkpoint, JumpID and Tag are not assigned
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.AssignParaProperties(Source: TCustomRVItemInfo);
begin
  SameAsPrev := Source.SameAsPrev;
  BR := Source.BR;
  PageBreakBefore := Source.PageBreakBefore;
  ClearLeft := Source.ClearLeft;
  ClearRight := Source.ClearRight;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.TransferProperties(Source: TCustomRVItemInfo;
  RVData: TPersistent);
begin
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  Result := True;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetSameAsPrev: Boolean;
begin
  Result := (rvioSameAsPrev in ItemOptions);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetSameAsPrev(const Value: Boolean);
begin
  if Value then begin
    Exclude(ItemOptions, rvioPageBreakBefore);
    Exclude(ItemOptions, rvioBR);
    Include(ItemOptions , rvioSameAsPrev);
    end
  else
    Exclude(ItemOptions, rvioSameAsPrev);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetBR(Value: Boolean);
begin
  if GetBoolValue(rvbpFullWidth) then
    Value := False;
  if Value then begin
    Exclude(ItemOptions, rvioSameAsPrev);
    Include(ItemOptions, rvioBR);
    end
  else
    Exclude(ItemOptions, rvioBR);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetBR: Boolean;
begin
  Result := (rvioBR in ItemOptions);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetPageBreakBefore: Boolean;
begin
  Result := (rvioPageBreakBefore in ItemOptions);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetPageBreakBefore(const Value: Boolean);
begin
  if Value then begin
    Exclude(ItemOptions, rvioSameAsPrev);
    Exclude(ItemOptions, rvioBR);
    Include(ItemOptions, rvioPageBreakBefore);
    end
  else
    Exclude(ItemOptions, rvioPageBreakBefore);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetClearLeft: Boolean;
begin
  Result := (rvioClearLeft in ItemOptions);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetClearRight: Boolean;
begin
  Result := (rvioClearRight in ItemOptions);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetClearLeft(const Value: Boolean);
begin
  if Value then begin
    if not (rvioSameAsPrev in ItemOptions) then
      Include(ItemOptions, rvioClearLeft);
    end
  else
    Exclude(ItemOptions, rvioClearLeft);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetClearRight(const Value: Boolean);
begin
  if Value then begin
    if not (rvioSameAsPrev in ItemOptions) then
      Include(ItemOptions, rvioClearRight);
    end
  else
    Exclude(ItemOptions, rvioClearRight);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.CanBeBorderStart: Boolean;
begin
  Result := not (rvioSameAsPrev in ItemOptions) and
            not (rvioBR in ItemOptions)
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.ParaStart(CountBR: Boolean): Boolean;
begin
  Result := not (rvioSameAsPrev in ItemOptions) and
            (CountBR or not (rvioBR in ItemOptions));
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.UpdatePaletteInfo(PaletteAction: TRVPaletteAction;
  ForceRecreateCopy: Boolean; Palette: HPALETTE; LogPalette: PLogPalette);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.AsImage: TGraphic;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TCustomRVItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
  const imgSavePrefix: String;
  var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
begin
  // nothing to do here
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String;
  TextOnly,Unicode: Boolean): TRVRawByteString;
begin
  Result := '';
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.OwnsControl(AControl: TControl): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetSubRVDataAt(X,Y: Integer; ReturnClosest: Boolean): TPersistent;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.OwnsInplaceEditor(AEditor: TControl): Boolean;
begin
   Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
  ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
  var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  Result := True;
  SetExtraPropertyFromRVFStr(s, UTF8Strings);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  // nothing to do here
  Result := '';
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := 0;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  if Hint<>'' then
    inc(Result);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  {$IFNDEF RVDONOTUSEITEMHINTS}
  if Hint<>'' then
    WriteRVFExtraStrPropertyStr(Stream, rvespHint, Hint);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetExtraPropertyFromRVFStr(const Str: TRVRawByteString;
  UTF8Strings: Boolean);
var PropName: TRVAnsiString;
    PropValStr: TRVRawByteString;
    PropVal: Integer;
    IntProp: TRVExtraItemProperty;
    StrProp: TRVExtraItemStrProperty;
    p: Integer;
begin
  p := RVPos('=', Str);
  if p=0 then
    exit;
  PropName := Copy(Str,1,p-1);
  PropValStr := Copy(Str,p+1, Length(Str));
  IntProp := GetRVFExtraIntPropertyByName(PropName);
  if IntProp<>rvepUnknown then begin
    PropVal  := RVStrToIntDef(PropValStr,0);
    SetExtraIntProperty(IntProp, PropVal);
    end
  else begin
    StrProp := GetRVFExtraStrPropertyByName(PropName);
    if StrProp<>rvespUnknown then begin
      SetExtraStrProperty(StrProp, RVFStringToString(PropValStr, UTF8Strings));
      end
    else
      SetExtraCustomProperty(PropName, RVFStringToString(PropValStr, UTF8Strings));
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SaveRVFSelection(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
// Unlike AsText(), this method MUST support Unicode, regardless rvbpCanSaveUnicode
// Unlike AsText(), this method if optional
procedure TCustomRVItemInfo.SaveTextSelection(Stream: TStream; RVData: TPersistent;
  LineWidth: Integer; const Path: String; TextOnly,Unicode: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.FillRTFTables(ColorList: TRVColorList;
  ListOverrideCountList: TRVIntegerList; RVData: TPersistent);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean;
  RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode):Boolean;
begin
  // nothing was printed
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer;
  Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
  RichView: TRVScroller; dli: TRVDrawLineInfo;
  Part: Integer; ColorMode: TRVColorMode;
  RVData: TPersistent);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpIgnorePara, rvbpFullWidth,rvbpDrawingChangesFont,
    rvbpCanSaveUnicode,rvbpAlwaysInText,rvbpImmediateControlOwner,
    rvbpResizable, rvbpResizeHandlesOutside, rvbpHasSubRVData,
    rvbpClickSelect, rvbpNoHTML_P, rvbpFloating:
      Result := False;
    else
      Result := True;
  end;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpPrintToBMP:
      Result := True;
    else
      Result := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.PaintFullWidth(Left, Right, Top: Integer;
  Canvas: TCanvas; State: TRVItemDrawStates; Style: TRVStyle;
  const ClipRect: TRect; dli: TRVDrawLineInfo; ExtraX, ExtraY: Integer);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetImageHeight(RVStyle: TRVStyle): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetImageWidth(RVStyle: TRVStyle): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetImageWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  if sad=nil then
    Result := GetImageWidth(RVStyle)
  else
    Result := RV_XToDevice(GetImageWidth(RVStyle), sad^);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetImageHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  if sad=nil then
    Result := GetImageHeight(RVStyle)
  else
    Result := RV_YToDevice(GetImageHeight(RVStyle), sad^);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetBorderHeight: TRVStyleLength;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetBorderWidth: TRVStyleLength;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.MovingToUndoList(ItemNo: Integer;
  RVData, AContainerUndoItem: TObject);
var s: TRVRawByteString;
begin
  s := TCustomRVFormattedData(RVData).GetItemTextR(ItemNo);
  TCustomRVData(RVData).ItemAction(rviaMovingToUndoList, Self, s, TCustomRVData(RVData));
  {$IFNDEF RVDONOTUSELIVESPELL}
  ClearWordPainters(0);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.MovingFromUndoList(ItemNo: Integer; RVData: TObject);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Hiding;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Unhiding(RVData: TObject);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.FinalizeUndoGroup;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.BeforeLoading(FileFormat: TRVLoadFormat);
begin
  // nothing to do here    // currently only fo RVF and RTF
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.AfterLoading(FileFormat: TRVLoadFormat);
begin
  // nothing to do here     // currently only fo RVF and RTF
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.MouseMove(Shift: TShiftState; X, Y, ItemNo: Integer;
  RVData: TObject): Boolean;
var s: String;
begin
  if rvoShowItemHints in TCustomRVData(RVData).Options then begin
    s := TCustomRVData(RVData).GetItemHint(TCustomRVData(RVData), -1, '');
    s := TCustomRVData(RVData).GetAbsoluteRootData.GetItemHint(
      TCustomRVData(RVData), ItemNo, s);
    TCustomRVFormattedData(RVData).SetControlHint(s);
  end;
  Result := False; // default cursor;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y, ItemNo: Integer; RVData: TObject): Boolean;
begin
  Result := False; // default cursor;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y, ItemNo: Integer; RVData: TObject): Boolean;
begin
  Result := False; // default cursor;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
                                       RVData: TPersistent): Integer;
begin
  Result := 20; // min width of doc - 20 pixels
  if sad<>nil then
    Result := MulDiv(Result, sad.ppixDevice, sad.ppixScreen);  
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.DeselectPartial;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.BuildJumps(Left,Top: Integer; var StartJumpNo: Integer;
  jumps: TList);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Focusing;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.MoveFocus(GoForward: Boolean;
  var TopLevelRVData: TPersistent; var TopLevelItemNo: Integer): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ClearFocus;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Execute(RVData: TPersistent);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.AdjustFocusToControl(Control: TControl;
  var TopLevelRVData: TPersistent; var TopLevelItemNo: Integer):Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.PartiallySelected: Boolean;
begin
  Result :=  False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.CanDeletePartiallySelected: Boolean;
begin
  Result :=  False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.DeletePartiallySelected;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ApplyStyleConversionToSubRVDatas(
  UserData: Integer; SelectedOnly: Boolean; ConvType: TRVEStyleConversionType);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ApplyStyleConversion(RVData: TPersistent;
  ItemNo, UserData: Integer; ConvType: TRVEStyleConversionType);
begin
  ApplyStyleConversionToSubRVDatas(UserData, False, ConvType);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.CreatePrintingDrawItem(RVData, ParaStyle: TObject;
  const sad: TRVScreenAndDevice): TRVDrawLineInfo;
begin
  Result :=
    TCustomRVFormattedData(RVData).GetStandardDrawLineInfoClass(Self, TParaInfo(ParaStyle)).Create;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.StartExport;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.EndExport;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Inserting(RVData: TObject; var Text: TRVRawByteString;
  Safe: Boolean);
begin
  if RVData<>nil then
    TCustomRVData(RVData).ItemAction(rviaInserting, Self, Text, TCustomRVData(RVData));
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.Inserted(RVData: TObject; ItemNo: Integer);
var s: TRVRawByteString;
begin
  if RVData<>nil then begin
    {$IFNDEF RVDONOTUSEANIMATION}
    UpdateAnimator(RVData);
    {$ENDIF}  
    s := '';
    TCustomRVData(RVData).ItemAction(rviaInserted, Self, s, TCustomRVData(RVData));
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.AfterUndoChangeProperty;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.BeforeUndoChangeProperty;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.EnterItem(From: TRVEnterDirection; Coord: Integer): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetHypertextCursor(RVStyle: TRVStyle): TCursor;
begin
  Result := RVStyle.JumpCursor;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.OnDocWidthChange(DocWidth: Integer;
  dli: TRVDrawLineInfo; Printing: Boolean; Canvas: TCanvas;
  RVData: TPersistent; sad: PRVScreenAndDevice; var HShift, Desc: Integer;
  NoCaching, Reformatting, UseFormatCanvas: Boolean);
begin
  HShift := 0;
  Desc := 1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
begin
  Data.UsedParaStyles[ParaNo] := 1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.UpdateStyles(Data: TRVDeleteUnusedStylesData);
begin
  dec(ParaNo, Data.UsedParaStyles[ParaNo]-1);
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetSubRVData(var StoreState: TRVStoreSubRVData;
                                         Position: TRVSubRVDataPos): TPersistent;
begin
  Result := nil;
  StoreState := nil;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ChooseSubRVData(StoreState: TRVStoreSubRVData);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.CleanUpChosen;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ResetSubCoords;
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetExtraStrProperty(Prop: TRVExtraItemStrProperty;
  var Value: String): Boolean;
begin
  Result := False;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  case Prop of
    rvespHint:
      begin
        Value := Hint;
        Result := True;
      end;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.SetExtraStrProperty(Prop: TRVExtraItemStrProperty;
  const Value: String): Boolean;
begin
  Result := False;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  case Prop of
    rvespHint:
      begin
        Hint := Value;
        Result := True;
      end;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetSoftPageBreakDY(Data: Integer): Integer;
begin
  Result := Data;
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.SetExtraCustomProperty(const PropName: TRVAnsiString;
        const Value: String): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ClearSoftPageBreaks;
begin

end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.DrawBackgroundForPrinting(Canvas: TCanvas;
  const Rect, FullRect: TRect; ColorMode: TRVColorMode;
  ItemBackgroundLayer: Integer; GraphicIterface: TRVGraphicInterface);
begin
  // This method is only for items containing subdocuments, i.e. tables.
  // Used for drawing background in bitmap
  // ItemBackgroundLayer: 0 - do not draw; -1 - draw completely; others - item specific
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEANIMATION}
procedure TCustomRVItemInfo.UpdateAnimator(RVData: TObject);
begin

end;
{$ENDIF}
{------------------------------------------------------------------------------}
// Occurs when item is partially selected (multicell selection in tables)
// Currently, Only for Shift+Keys
procedure TCustomRVItemInfo.KeyDown(Key: Word; Shift: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TCustomRVItemInfo.GetActualStyleNo(RVStyle: TRVStyle): Integer;
begin
  Result := StyleNo;
  if Result=rvsDefStyle then begin
    if RVStyle.ParaStyles[ParaNo].DefStyleNo>=0 then
      Result := RVStyle.ParaStyles[ParaNo].DefStyleNo
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
// For non-text items, can return the associated text style. It will be used
// for saving in RTF and HTML
function TCustomRVItemInfo.GetAssociatedTextStyleNo: Integer;
begin
  Result := -1;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVItemInfo.SetAssociatedTextStyleNo(Value: Integer);
begin

end;
{============================= TRVNonTextItemInfo =============================}
procedure TRVNonTextItemInfo.AdjustInserted(x, y: Integer; adjusty: Boolean;
  RVStyle: TRVStyle);
begin
  // nothing to do here
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  if sad=nil then
    Result := GetHeight(RVStyle)
  else
    Result := RV_YToDevice(GetHeight(RVStyle), sad^);
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  if sad=nil then
    Result := GetWidth(RVStyle)
  else
    Result := RV_XToDevice(GetWidth(RVStyle), sad^);
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetLeftOverhang: Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVNonTextItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVNonTextItemInfo then begin
    DeleteProtect := TRVNonTextItemInfo(Source).DeleteProtect;
    Hidden := TRVNonTextItemInfo(Source).Hidden;
  end;
  inherited;
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty;
  var Value: Integer): Boolean;
begin
  case Prop of
    rvepDeleteProtect:
      begin
        Value := ord(DeleteProtect);
        Result := True;
      end;
    rvepHidden:
      begin
        Value := ord(Hidden);
        Result := True;
      end;
    else
      Result := inherited GetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty;
  Value: Integer): Boolean;
begin
  case Prop of
    rvepDeleteProtect:
      begin
        DeleteProtect := Value<>0;
        Result := True;
      end;
    rvepHidden:
      begin
        Hidden := Value<>0;
        Result := True;
      end;
    else
      Result := inherited SetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVNonTextItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if DeleteProtect then
    inc(Result);
  if Hidden then
    inc(Result);  
end;
{------------------------------------------------------------------------------}
procedure TRVNonTextItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited;
  if DeleteProtect then
    WriteRVFExtraIntPropertyStr(Stream, rvepDeleteProtect, ord(DeleteProtect));
  if Hidden then
    WriteRVFExtraIntPropertyStr(Stream, rvepHidden, ord(Hidden));
end;
{=========================== TRVFullLineItemInfo ==============================}
function TRVFullLineItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpFullWidth:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{=============================== TRVRectItemInfo ==============================}
constructor TRVRectItemInfo.Create(RVData: TPersistent);
begin
  inherited Create(RVData);
  Spacing := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVRectItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVRectItemInfo then begin
    FMinHeightOnPage := TRVRectItemInfo(Source).FMinHeightOnPage;
    VAlign           := TRVRectItemInfo(Source).VAlign;
    VShift           := TRVRectItemInfo(Source).VShift;
    VShiftAbs        := TRVRectItemInfo(Source).VShiftAbs;
    Spacing          := TRVRectItemInfo(Source).Spacing;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.GetBorderHeight: TRVStyleLength;
begin
  Result := Spacing;
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.GetBorderWidth: TRVStyleLength;
begin
  Result := Spacing;
end;
{------------------------------------------------------------------------------}
procedure TRVRectItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
begin
  inherited;
  Spacing := RVStyle.GetAsDifferentUnits(Spacing, NewUnits);
  if VShiftAbs then
    VShift := RVStyle.GetAsDifferentUnits(VShift, NewUnits);
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpFloating:
      Result := VAlign in [rvvaLeft, rvvaRight];
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var va: Integer;
begin
  Result := True;
  if not (P^ in [#0, #10, #13]) then begin
    Result := RVFReadInteger(P,va);
    if Result then
      VAlign := TRVVAlign(va);
    end
  else
    VAlign := rvvaBaseLine;
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  Result := RVIntToStr(ord(VAlign));
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if VShift<>0 then
    inc(Result);
  if VShiftAbs then
    inc(Result);
  if Spacing<>1 then
    inc(Result);
end;
{------------------------------------------------------------------------------}
procedure TRVRectItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited;
  if VShift<>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepVShift, VShift);
  if VShiftAbs then
    WriteRVFExtraIntPropertyStr(Stream, rvepVShiftAbs, 1);
  if Spacing<>1 then
    WriteRVFExtraIntPropertyStr(Stream, rvepSpacing, Spacing);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function TRVRectItemInfo.GetVShiftCSS(RVStyle: TRVStyle): TRVAnsiString;
begin
  Result := '';
  if (VShift=0) or (GetImageHeight(RVStyle)=0) or (VAlign<>rvvaBaseLine) then
    exit;
  if VShiftAbs then
    Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
      'vertical-align : s;', [RVStyle.GetCSSSize(VShift)])
  else
    Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
      'vertical-align : %d;', [MulDiv(GetImageHeight(RVStyle),VShift,100)])
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVRectItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean;
begin
  Result := True;
  case Prop of
    rvepVShift:
      VShift := Value;
    rvepVShiftAbs:
      VShiftAbs := Value<>0;
    rvepSpacing:
      begin
        Spacing := Value;
        if Spacing<0 then
          Spacing := 0;
      end;
    else
      Result := inherited SetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVRectItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean;
begin
  Result := True;
  case Prop of
    rvepVShift:
      Value := VShift;
    rvepVShiftAbs:
      Value := ord(VShiftAbs);
    rvepSpacing:
      Value := Spacing;
    else
      Result := inherited GetExtraIntProperty(Prop, Value);
  end;
end;
{================================ TRVControlItemInfo ==========================}
constructor TRVControlItemInfo.CreateEx(RVData: TPersistent; AControl: TControl; AVAlign: TRVVAlign);
begin
  inherited Create(RVData);
  StyleNo  := rvsComponent;
  Control  := AControl;
  VAlign   := AVAlign;
  FVisible := True;
end;
{------------------------------------------------------------------------------}
constructor TRVControlItemInfo.Create(RVData: TPersistent);
begin
  inherited Create(RVData);
  StyleNo  := rvsComponent;
  FVisible := True;
end;
{------------------------------------------------------------------------------}
destructor TRVControlItemInfo.Destroy;
begin
  if not FShared then
    Control.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVControlItemInfo then begin
    PercentWidth := TRVControlItemInfo(Source).PercentWidth;
    FResizable   := TRVControlItemInfo(Source).FResizable;
    FVisible     := TRVControlItemInfo(Source).FVisible;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.AdjustInserted(x, y: Integer; adjusty: Boolean;
  RVStyle: TRVStyle);
begin
  Control.Left := x+RVStyle.GetAsPixels(GetBorderWidth);
  Control.Tag  := y+RVStyle.GetAsPixels(GetBorderHeight);
  if adjusty then
    RV_Tag2Y(Control);
  Control.Visible := FVisible;    
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  Result := Control.Height+RVStyle.GetAsPixels(GetBorderHeight)*2;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  Result := Control.Width+RVStyle.GetAsPixels(GetBorderWidth)*2;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  Result := Control.Height;
  if sad<>nil then
    Result := RV_YToDevice(Result, sad^);
  inc(Result, RVStyle.GetAsDevicePixelsY(GetBorderHeight, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  Result := Control.Width;
  if sad<>nil then
    Result := RV_XToDevice(Result, sad^);
  inc(Result, RVStyle.GetAsDevicePixelsX(GetBorderWidth, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetImageHeight(RVStyle: TRVStyle): Integer;
begin
  Result := Control.Height;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetImageWidth(RVStyle: TRVStyle): Integer;
begin
  Result := Control.Width;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  RVData: TPersistent): Integer;
var RVStyle: TRVStyle;
begin
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  if PercentWidth<>0 then
    Result := 20
  else
    Result := Control.Width;
  if sad<>nil then
    Result := RV_XToDevice(Result, sad^);
  inc(Result, RVStyle.GetAsDevicePixelsX(GetBorderWidth, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.CreatePrintingDrawItem(RVData, ParaStyle: TObject;
  const sad: TRVScreenAndDevice): TRVDrawLineInfo;
var RVStyle: TRVStyle;
begin
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  if not GetBoolValueEx(rvbpPrintToBMP, nil) or (MinHeightOnPage=0) then begin
    Result := inherited CreatePrintingDrawItem(RVData, ParaStyle, sad);
    exit;
  end;
  Result := TRVMultiImagePrintInfo.Create(Self, TCustomRVData(RVData));
  Result.Width  := GetWidthEx(RVStyle, @sad);
  Result.Height := GetHeightEx(RVStyle, @sad);
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean;
  RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode): Boolean;
var ctrlbmp: TBitmap;
    Top: Integer;
begin
  Result := False;
  if not FVisible then
    exit;  
  ctrlbmp := nil;
  if (RichView is TPrintableRV) and (TPrintableRV(RichView).RVPrint<>nil) and
     Assigned(TPrintableRV(RichView).RVPrint.OnPrintComponent) then
    TPrintableRV(RichView).RVPrint.OnPrintComponent(TPrintableRV(RichView).RVPrint, Control, ctrlbmp)
  else
    ctrlbmp := DrawControl(Control);
  if (dli is TRVMultiImagePrintInfo) and (Part>=0) then
    Top := -TRVImagePrintPart(TRVMultiImagePrintInfo(dli).PartsList[Part]).ImgTop
  else
    Top := 0;
  if (ctrlbmp<>nil) then
    try
      Result := True;
      if MinHeightOnPage<=0 then begin
        if ctrlbmp.Width>bkgnd.Width then
          bkgnd.Width := ctrlbmp.Width;
        if ctrlbmp.Height>bkgnd.Height then
          bkgnd.Height := ctrlbmp.Height;
        TCustomRichView(RichView).Style.GraphicInterface.DrawGraphic(Bkgnd.Canvas,
          (Bkgnd.Width-ctrlbmp.Width) div 2, (Bkgnd.Height-ctrlbmp.Height) div 2,
          ctrlbmp);
        end
      else
        TCustomRichView(RichView).Style.GraphicInterface.DrawGraphic(Bkgnd.Canvas,
          0, Top, ctrlbmp);
    finally
      ctrlbmp.Free;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
var DblBorderWidth, DblBorderHeight: Integer;
begin
  if not FVisible then
    exit;
  DblBorderWidth  := Style.GetAsPixels(GetBorderWidth)*2;
  DblBorderHeight := Style.GetAsPixels(GetBorderHeight)*2;
  if (rvidsCurrent in State) and (Style.CurrentItemColor<>clNone) then begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := Style.CurrentItemColor;
    Canvas.Pen.Style := psSolid;
    Style.GraphicInterface.Rectangle(Canvas, x-1, y-1,
      x+Control.Width+DblBorderWidth+1, y+Control.Height+DblBorderHeight+1);
  end;
  if (rvidsSelected in State) then begin
    if rvidsControlFocused in State then
      Canvas.Pen.Color := Style.SelColor
    else
      Canvas.Pen.Color := Style.InactiveSelColor;
    if Canvas.Pen.Color<>clNone then begin
      Canvas.Pen.Width := 1;
      Canvas.Pen.Style := psSolid;
      Style.GraphicInterface.Rectangle(Canvas, x, y,
        x+Control.Width+DblBorderWidth, y+Control.Height+DblBorderHeight);
    end;
  end;
  if Hidden then
    RVDrawHiddenUnderline(Canvas, Style.TextStyles[0].Color,
      x, x+Control.Width+DblBorderWidth, y+Control.Height+DblBorderHeight+1,
      Style.GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.OwnsControl(AControl: TControl): Boolean;
begin
  Result := (AControl=Control);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVControlItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
  const imgSavePrefix: String; var imgSaveNo: Integer;
  CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
  UseCSS: Boolean; Bullets: TRVList);
var s: String;
begin
  s := TCustomRVData(RVData).SaveComponentToFile(Path, Control, rvsfHTML);
  if s<>'' then
    RVWrite(Stream, StringToHTMLString(s, SaveOptions, TCustomRVData(RVData).GetRVStyle));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVControlItemInfo.ReadRVFLine(const s: TRVRawByteString;
  RVData: TPersistent; ReadType, LineNo, LineCount: Integer;
  var Name: TRVRawByteString; var ReadMode: TRVFReadMode;
  var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var ControlClass: TControlClass;
    Formatting: Boolean;
    ControlClassName: String;
    OnError: TReaderError;
begin
  Result := True;
  case ReadType of
    1: // ask owner
      begin
        case LineNo of
          0:
            begin
              Name := s;
              Control := TCustomRVData(RVData).RVFControlNeeded(
                {$IFDEF RVUNICODESTR}String(TRVAnsiString(s)),{$ELSE}s,{$ENDIF}
                 Tag);
              Control.Visible := False;
              Control.Parent := TCustomRVData(RVData).GetParentControl;
            end;
          else
            begin
              SetExtraPropertyFromRVFStr(s, UTF8Strings);
            end;
        end;
      end;
    else // read from file
      begin
        if LineNo=0 then
          Name := s
        else if LineNo=1 then begin
          {$IFDEF RVUNICODESTR}
          ControlClassName := String(s);
          {$ELSE}
          ControlClassName := s; // workaround for Delphi 3-6 bug
          {$ENDIF}
          ControlClass := TControlClass(GetClass(ControlClassName));
          if ControlClass<>nil then begin
            Control := ControlClass.Create(nil);
            Control.Visible := False;
            Control.Parent := TCustomRVData(RVData).GetParentControl;
          end;
          end
        else if LineNo=LineCount-1 then begin
          Formatting := rvstSkipFormatting in TCustomRVData(RVData).GetAbsoluteRootData.State;
          TCustomRVData(RVData).GetAbsoluteRootData.State :=
            TCustomRVData(RVData).GetAbsoluteRootData.State+[rvstSkipFormatting];
          try
            if rvfoIgnoreUnknownCtrlProperties in TCustomRVData(RVData).GetAbsoluteRootData.RVFOptions then
              OnError := TCustomRVData(RVData).DoOnCtrlReaderError
            else
              OnError := nil;
            if ReadType=2 then
              RVFLoadControlBinary(s, TComponent(Control), '',
                TCustomRVData(RVData).GetParentControl, OnError)
            else
              Result := RVFLoadControl(s, TComponent(Control), '',
                TCustomRVData(RVData).GetParentControl, OnError);
          finally
            if not Formatting then
              TCustomRVData(RVData).GetAbsoluteRootData.State :=
                TCustomRVData(RVData).GetAbsoluteRootData.State-[rvstSkipFormatting];
          end;
          if Result then
            if Control=nil then begin
              TCustomRVData(RVData).RVFWarnings := TCustomRVData(RVData).RVFWarnings + [rvfwUnknownCtrls];
              if not (rvfoIgnoreUnknownCtrls in TCustomRVData(RVData).RVFOptions) then
                Result := False;
            end;
          ReadState := rstSkip;
          end
        else
          SetExtraPropertyFromRVFStr(s, UTF8Strings);
        if (ReadType=2) and (LineNo=LineCount-2) then
            ReadMode := rmBeforeBinary;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpValid:
      Result := Control<>nil;
    rvbpImmediateControlOwner:
      Result := True;
    rvbpResizable:
      Result := FResizable and (PercentWidth=0);
    {$IFDEF RVUNICODESTR}
    rvbpCanSaveUnicode:
      Result := True;
    {$ENDIF}
    rvbpResizeHandlesOutside:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpDisplayActiveState:
      Result := True;
    rvbpAllowsFocus:
      Result := (Control<>nil) and (Control is TWinControl) and
                TWinControl(Control).TabStop and
                TWinControl(Control).CanFocus;
    rvbpActualPrintSize:
      Result := (PercentWidth>0) and (PercentWidth<=100);
    rvbpXORFocus:
      Result := False;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String;
  TextOnly, Unicode: Boolean): TRVRawByteString;
begin
  {$IFDEF RVUNICODESTR}
  Result := RVU_GetRawUnicode(
    TCustomRVData(RVData).SaveComponentToFile(Path, Control, rvsfText));
  if not Unicode then
    Result := RVU_UnicodeToAnsi(TCustomRVData(RVData).GetRVStyle.DefCodePage, Result);
  {$ELSE}
  Result := TCustomRVData(RVData).SaveComponentToFile(Path, Control, rvsfText);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
var s: String;
begin
  s := TCustomRVData(RVData).SaveComponentToFile('', Control, rvsfRTF);
  if s<>'' then begin
    if Hidden or HiddenParent then
      RVFWrite(Stream, '{\v');
    RVWrite(Stream, TRVAnsiString(s));
    if Hidden or HiddenParent then
      RVFWrite(Stream, '}');
  end;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if MinHeightOnPage>0 then
    inc(Result);
  if FResizable then
    inc(Result);
  if not FVisible then
    inc(Result);
  if FShared then
    inc(Result);  
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited SaveRVFExtraProperties(Stream);
  if MinHeightOnPage>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepMinHeightOnPage, MinHeightOnPage);
  if FResizable then
    WriteRVFExtraIntPropertyStr(Stream, rvepResizable, ord(FResizable));
  if not FVisible then
    WriteRVFExtraIntPropertyStr(Stream, rvepVisible, ord(FVisible));
  if FShared then
    WriteRVFExtraIntPropertyStr(Stream, rvepShared, ord(FShared));
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty; Value: Integer): Boolean;
begin
  case Prop of
    rvepResizable:
      begin
        FResizable := Value<>0;
        Result := True;
      end;
    rvepVisible:
      begin
        FVisible := Value<>0;
        if (Control<>nil) and (Control.Parent<>nil) then
          Control.Visible := FVisible;
        Result := True;
      end;
    rvepMinHeightOnPage:
      begin
        MinHeightOnPage := Value;
        Result := True;
      end;
    rvepShared:
      begin
        FShared := Value<>0;
        Result := True;
      end;
    else
      Result := inherited SetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVControlItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty; var Value: Integer): Boolean;
begin
  case Prop of
    rvepResizable:
      begin
        Value := ord(FResizable);
        Result := True;
      end;
    rvepVisible:
      begin
        Value := ord(FVisible);
        Result := True;
      end;
    rvepMinHeightOnPage:
      begin
        Value := MinHeightOnPage;
        Result := True;
      end;
    rvepShared:
      begin
        Value := ord(FShared);
        Result := True;
      end;
    else
      Result := inherited GetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString;
  Part: TRVMultiDrawItemPart; ForceSameAsPrev: Boolean);
var SaveType, LineCount: Integer;
begin
   if rvfoSaveControlsBody in TCustomRVData(RVData).RVFOptions then begin
     if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
       SaveType := 2 // save binary
     else
       SaveType := 0; // save hex dump
     LineCount := 3+GetRVFExtraPropertyCount;
     end
   else begin
     SaveType := 1; // do not save
     LineCount := 1+GetRVFExtraPropertyCount;
   end;
   RVFWriteLine(Stream,
     {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
            [StyleNo, LineCount,
             RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
             Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
             SaveType,
             RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
             SaveRVFHeaderTail(RVData)]));
   RVFWriteLine(Stream, Name);
   if SaveType<>1 then begin
     RVFWriteLine(Stream, TRVAnsiString(Control.ClassName));
     SaveRVFExtraProperties(Stream);
     TCustomRVData(RVData).ControlAction(TCustomRVData(RVData), rvcaBeforeRVFSave, ItemNo, Self);
     if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
       RVFSaveControlBinary(Stream, Control)
     else
       RVFWriteLine(Stream, RVFSaveControl(Control));
     TCustomRVData(RVData).ControlAction(TCustomRVData(RVData), rvcaAfterRVFSave, ItemNo, Self);
     end
   else
      SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.MovingToUndoList(ItemNo: Integer; RVData, AContainerUndoItem: TObject);
begin
  Control.Visible := False;
  Control.Parent := nil;
  TCustomRVData(RVData).ControlAction(TCustomRVData(RVData), rvcaMoveToUndoList,
    ItemNo, Self);
  inherited MovingToUndoList(ItemNo, RVData, AContainerUndoItem);
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.MovingFromUndoList(ItemNo: Integer; RVData: TObject);
begin
  TCustomRVData(RVData).ControlAction(TCustomRVData(RVData), rvcaMoveFromUndoList, ItemNo, Self);
  Control.Parent := TCustomRVData(RVData).GetParentControl;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Hiding;
begin
  Control.Visible := False;
  Control.Parent := nil;
  inherited Hiding;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Unhiding(RVData: TObject);
begin
  Control.Visible := False;
  Control.Parent := TCustomRVData(RVData).GetParentControl;
  inherited Unhiding(RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Inserting(RVData: TObject; var Text: TRVRawByteString;
  Safe: Boolean);
begin
  Control.Visible := False;
  if not Safe and (RVData<>nil) then
    Control.Parent := TCustomRVData(RVData).GetParentControl
  else
    Control.Parent := nil;
  inherited Inserting(RVData, Text, Safe);
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.Focusing;
begin
  if Control is TWinControl then
    TWinControl(Control).SetFocus;
end;
{------------------------------------------------------------------------------}
procedure TRVControlItemInfo.OnDocWidthChange(DocWidth: Integer;
  dli: TRVDrawLineInfo; Printing: Boolean; Canvas: TCanvas;
  RVData: TPersistent; sad: PRVScreenAndDevice;
  var HShift, Desc: Integer; NoCaching, Reformatting, UseFormatCanvas: Boolean);
var RVStyle: TRVStyle;
begin
  HShift := 0;
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  if (PercentWidth>0) and (PercentWidth<=100) then begin
    dli.Width := DocWidth * PercentWidth div 100;
    if not Printing then
      Control.Width := dli.Width-RVStyle.GetAsPixels(GetBorderWidth)*2;    
    dli.Height := RV_YToDevice(Control.Height, sad^)+
      RVStyle.GetAsDevicePixelsY(GetBorderHeight, sad)*2;
    Desc := RVStyle.GetAsDevicePixelsY(GetBorderHeight, sad);;
    end
  else
    Desc := RVStyle.GetAsPixels(GetBorderHeight);
end;
{============================ TRVGraphicItemInfo ==============================}
constructor TRVGraphicItemInfo.CreateEx(RVData: TPersistent; AImage: TGraphic; AVAlign: TRVVAlign);
begin
  inherited Create(RVData);
  StyleNo := rvsPicture;
  Image   := AImage;
  VAlign  := AVAlign;
  FResizable := True;
end;
{------------------------------------------------------------------------------}
constructor TRVGraphicItemInfo.Create(RVData: TPersistent);
begin
  inherited Create(RVData);
  StyleNo := rvsPicture;
  FResizable := True;
end;
{------------------------------------------------------------------------------}
destructor TRVGraphicItemInfo.Destroy;
begin
  if not FShared then
    Image.Free;
  ImageCopy.Free;
  {$IFNDEF RVDONOTUSEANIMATION}
  FAnimator.Free;
  {$ENDIF}
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.Assign(Source: TCustomRVItemInfo);
var  grclass: TGraphicClass;
begin
  if Source is TRVGraphicItemInfo then begin
    Alt := TRVGraphicItemInfo(Source).Alt;
    FResizable := TRVGraphicItemInfo(Source).FResizable;
    ImageFileName := TRVGraphicItemInfo(Source).ImageFileName;
    ImageWidth := TRVGraphicItemInfo(Source).ImageWidth;
    ImageHeight := TRVGraphicItemInfo(Source).ImageHeight;
    NoHTMLImageSize := TRVGraphicItemInfo(Source).NoHTMLImageSize;
    if not FShared then
      Image.Free;
    FShared := TRVGraphicItemInfo(Source).FShared;
    ImageCopy.Free;
    grclass := TGraphicClass(TRVGraphicItemInfo(Source).Image.ClassType);
    Image := RV_CreateGraphics(grclass);
    Image.Assign(TRVGraphicItemInfo(Source).Image);
    if TRVGraphicItemInfo(Source).ImageCopy<>nil then begin
      grclass := TGraphicClass(TRVGraphicItemInfo(Source).ImageCopy.ClassType);
      ImageCopy := RV_CreateGraphics(grclass);
      ImageCopy.Assign(TRVGraphicItemInfo(Source).ImageCopy);
      end
    else
      ImageCopy := nil;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.TransferProperties(Source: TCustomRVItemInfo;
  RVData: TPersistent);
begin
  {$IFNDEF RVDONOTUSEANIMATION}
  if (FAnimator=nil) and (Source is TRVGraphicItemInfo) then begin
    FAnimator := TRVGraphicItemInfo(Source).FAnimator;
    TRVGraphicItemInfo(Source).FAnimator := nil;
    if FAnimator<>nil then
      TRVAnimator(FAnimator).Update(nil, Self);
    UpdateAnimator(RVData);
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.PrepareImage;
begin
  if Image is TIcon then
    TIcon(Image).Handle;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  PrepareImage;
  if (ImageHeight>0) then
    Result := RVStyle.GetAsPixels(ImageHeight)
  else
    Result := Image.Height;
  inc(Result, RVStyle.GetAsPixels(GetBorderHeight)*2);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  PrepareImage;
  if (ImageWidth>0) then
    Result := RVStyle.GetAsPixels(ImageWidth)
  else
    Result := Image.Width;
  inc(Result, RVStyle.GetAsPixels(GetBorderWidth)*2);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  PrepareImage;
  if (ImageHeight>0) then
    Result := RVStyle.GetAsDevicePixelsY(ImageHeight, sad)
  else begin
    Result := Image.Height;
    if sad<>nil then
      Result := RV_YToDevice(Result, sad^);
  end;
  inc(Result, RVStyle.GetAsDevicePixelsY(GetBorderHeight, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  PrepareImage;
  if (ImageWidth>0) then
    Result := RVStyle.GetAsDevicePixelsX(ImageWidth, sad)
  else begin
    Result := Image.Width;
    if sad<>nil then
      Result := RV_XToDevice(Result, sad^);
  end;
  inc(Result, RVStyle.GetAsDevicePixelsX(GetBorderWidth, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetImageHeight(RVStyle: TRVStyle): Integer;
begin
  PrepareImage;
  if (ImageHeight>0) then
    Result := RVStyle.GetAsPixels(ImageHeight)
  else
    Result := Image.Height;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetImageWidth(RVStyle: TRVStyle): Integer;
begin
  PrepareImage;
  if (ImageWidth>0) then
    Result := RVStyle.GetAsPixels(ImageWidth)
  else
    Result := Image.Width;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetImageHeightEx(RVStyle: TRVStyle;
  sad: PRVScreenAndDevice): Integer;
begin
  PrepareImage;
  if (ImageHeight>0) then
    Result := RVStyle.GetAsDevicePixelsY(ImageHeight, sad)
  else if sad=nil then
    Result := Image.Height
  else
    Result := RV_YToDevice(Image.Height, sad^);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetImageWidthEx(RVStyle: TRVStyle;
  sad: PRVScreenAndDevice): Integer;
begin
  PrepareImage;
  if (ImageWidth>0) then
    Result := RVStyle.GetAsDevicePixelsX(ImageWidth, sad)
  else if sad=nil then
    Result := Image.Width
  else
    Result := RV_XToDevice(Image.Width, sad^);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  RVData: TPersistent): Integer;
begin
  Result := GetWidthEx(TCustomRVData(RVData).GetRVStyle, sad);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
begin
  inherited;
  ImageWidth := RVStyle.GetAsDifferentUnits(ImageWidth, NewUnits);
  ImageHeight := RVStyle.GetAsDifferentUnits(ImageHeight, NewUnits);  
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEANIMATION}
procedure TRVGraphicItemInfo.UpdateAnimator(RVData: TObject);
begin
  if RVData is TCustomRVFormattedData then begin
    if not TCustomRVFormattedData(RVData).AllowAnimation then begin
      FAnimator.Free;
      FAnimator := nil;
      end
    else
      RV_MakeAnimator(Self, TCustomRVFormattedData(RVData), TRVAnimator(FAnimator));
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
var w,h: Integer;
    BorderWidthPix, BorderHeightPix: Integer;
    SelColor: TColor;
  {...............................................}
  procedure DrawBmp;
  begin
    if (ImageWidth=0) and (ImageHeight=0) then
      Style.GraphicInterface.DrawBitmap(Canvas, x, y, TBitmap(ImageCopy))
    else
      Style.GraphicInterface.StretchDrawBitmap(Canvas, Bounds(x, y, w, h), TBitmap(ImageCopy))
  end;
  {...............................................}
  procedure DrawImage(Image: TGraphic);
  var DCState: Integer;
  begin
    DCState := 0;
    try
      if (ImageWidth=0) and (ImageHeight=0) then begin
        if True{Image is TMetafile} then begin
          DCState := Style.GraphicInterface.SaveCanvasState(Canvas);
          Style.GraphicInterface.IntersectClipRect(Canvas, x, y, x+Image.Width, y+Image.Height);
        end;
        try
          Style.GraphicInterface.DrawGraphic(Canvas, x, y, Image);
        except
        end;
        end
      else begin
        if True{Image is TMetafile} then begin
          DCState := Style.GraphicInterface.SaveCanvasState(Canvas);
          Style.GraphicInterface.IntersectClipRect(Canvas, x, y, x+w, y+h);
        end;
        try
          Style.GraphicInterface.StretchDrawGraphic(Canvas, Bounds(x, y, w, h), Image);
        except
        end;
      end;
    finally
      if DCState<>0 then
        Style.GraphicInterface.RestoreCanvasState(Canvas, DCState);
      if not RVNT then
        Canvas.Refresh;
    end;
  end;
  {...............................................}
begin
  w := GetImageWidth(Style);
  h := GetImageHeight(Style);
  BorderWidthPix  := Style.GetAsPixels(GetBorderWidth);
  BorderHeightPix := Style.GetAsPixels(GetBorderHeight);
  inc(x, BorderWidthPix);
  inc(y, BorderHeightPix);
  {$IFNDEF RVDONOTUSEANIMATION}
  if FAnimator<>nil then
    TRVAnimator(FAnimator).Draw(x,y,Canvas, False)
  else
  {$ENDIF}
    if ImageCopy<>nil then
      if ImageCopy is TBitmap then
        DrawBmp
      else
        DrawImage(ImageCopy)
    else
      DrawImage(Image);
  if (rvidsSelected in State) then begin
    if rvidsControlFocused in State then
      SelColor := Style.SelColor
    else
      SelColor := Style.InactiveSelColor;
    {$IFDEF RVSHADESELECTION}
    ShadeRectangle(Canvas, Bounds(x,y,w,h), SelColor);
    {$ELSE}
    Canvas.Pen.Color := SelColor;
    Canvas.Brush.Style := bsClear;
    if Canvas.Pen.Color<>clNone then begin
      Canvas.Pen.Style := psSolid;
      Canvas.Pen.Width := 1;
      Style.GraphicInterface.Rectangle(Canvas,
        x-BorderWidthPix, y-BorderHeightPix,
        x+w+BorderWidthPix, y+h+BorderHeightPix);
    end;
    {$ENDIF}
  end;
  if (rvidsCurrent in State) and (Style.CurrentItemColor<>clNone) then begin
    Canvas.Pen.Width := 1;
    Canvas.Pen.Color := Style.CurrentItemColor;
    Canvas.Pen.Style := psSolid;
    Canvas.Brush.Style := bsClear;
    Style.GraphicInterface.Rectangle(Canvas,
      x-BorderWidthPix-1, y-BorderHeightPix-1,
      x+w+BorderWidthPix+1, y+h+BorderHeightPix+1);
  end;
  if Hidden then
    RVDrawHiddenUnderline(Canvas, Style.TextStyles[0].Color,
      x-BorderWidthPix-1, x+w+BorderWidthPix+1, y+h+BorderHeightPix+1,
      Style.GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.AsImage: TGraphic;
begin
  Result := Image;
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.MovingToUndoList(ItemNo: Integer; RVData, AContainerUndoItem: TObject);
begin
  ImageCopy.Free;
  ImageCopy := nil;
  {$IFNDEF RVDONOTUSEANIMATION}
  if FAnimator<>nil then begin
    FAnimator.Free;
    FAnimator := nil;
  end;
  {$ENDIF}
  inherited MovingToUndoList(ItemNo, RVData, AContainerUndoItem);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.UpdatePaletteInfo(PaletteAction: TRVPaletteAction;
                                               ForceRecreateCopy: Boolean;
                                               Palette: HPALETTE;
                                               LogPalette: PLogPalette);
begin
  if not (PaletteAction in [rvpaCreateCopies,rvpaCreateCopiesEx]) or ForceRecreateCopy or
     (Palette=0) then begin
    ImageCopy.Free;
    ImageCopy := nil;
  end;
//  if ImageCopy=nil then
//    ImageCopy := TBitmap.Create;
//  ImageCopy.Width  := Image.Width;
//  ImageCopy.Height := Image.Height;
//  TBitmap(ImageCopy).Canvas.Draw(0,0,Image);
  case PaletteAction of
  {*} rvpaAssignPalette:
      begin
        if LogPalette<>nil then
          RV_SetPaletteToPicture(Image,LogPalette);
      end;
  {*} rvpaCreateCopies,rvpaCreateCopiesEx:
      begin
        if (LogPalette<>nil) and (ImageCopy=nil) then begin
          {$IFNDEF RVDONOTUSEJPEGIMAGE}
          if (PaletteAction=rvpaCreateCopiesEx) and
             (Image is TJpegImage) then
            ImageCopy := TBitmap.Create
          else
          {$ENDIF}
            ImageCopy := RV_CreateGraphics(TGraphicClass(Image.ClassType));
          ImageCopy.Assign(Image);
          RV_SetPaletteToPicture(ImageCopy,LogPalette);
          if ImageCopy is TBitmap then
            TBitmap(ImageCopy).IgnorePalette := True;
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpResizable:
      Result := (Image<>nil) and not (Image is TIcon) and FResizable;
    rvbpValid:
      Result := Image<>nil;
    rvbpResizeHandlesOutside:
      {$IFNDEF RVDONOTUSEANIMATION}
      Result := FAnimator<>nil;
      {$ELSE}
      Result := False;
      {$ENDIF}
    rvbpDrawingChangesFont:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpDisplayActiveState:
      Result := True;
    rvbpPrintToBMP:
      Result := not (Image is TMetafile);
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function RV_GetExtraIMGStr(SaveOptions: TRVSaveOptions; Width, Height: Integer;
  NoHTMLImageSize: Boolean): TRVAnsiString;
begin
  if rvsoNoHypertextImageBorders in SaveOptions then
    Result := ' border=0 '
  else
    Result := ' ';
  if (rvsoImageSizes in SaveOptions) and not NoHTMLImageSize then
    Result := Result+{$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('width=%d height=%d ',[Width, Height]);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVGraphicItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
  const imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
  {.................................................................}
  function GetExtraIMGStr: TRVAnsiString;
  var s: TRVAnsiString;
      RVStyle: TRVStyle;
  begin
    Result := '';
    if rvsoNoHypertextImageBorders in SaveOptions then
      RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('border=%s',[RV_HTMLGetIntAttrVal(0, SaveOptions)]));
    RVStyle := TCustomRVData(RVData).GetRVStyle;
    if ((rvsoImageSizes in SaveOptions) and not NoHTMLImageSize) or
       (ImageWidth>0) or (ImageHeight>0) then
      RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('width=%s height=%s', [
         RV_HTMLGetIntAttrVal(GetImageWidth(RVStyle), SaveOptions),
         RV_HTMLGetIntAttrVal(GetImageHeight(RVStyle), SaveOptions)]));
    if (Alt<>'') or UseCSS then begin
      s := StringToHTMLString(RV_MakeHTMLValueStr(Alt), SaveOptions, RVStyle);
      RV_AddStrA(Result, 'alt="'+s+'"');
    end;
    if Spacing>0 then
      RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('hspace=%s vspace=%s', [
          RV_HTMLGetIntAttrVal(RVStyle.GetAsPixels(Spacing), SaveOptions),
          RV_HTMLGetIntAttrVal(RVStyle.GetAsPixels(Spacing), SaveOptions)]));
    {$IFNDEF RVDONOTUSEITEMHINTS}
    if Hint<>'' then begin
      s := StringToHTMLString(RV_GetHintStr(rvsfHTML, Hint), SaveOptions, RVStyle);
      RV_AddStrA(Result, s);
    end;
    {$ENDIF}
    if UseCSS then begin
      s := GetVShiftCSS(RVStyle);
      if Hidden then
        RV_AddStrA(s, 'display : none;');
      if s<>'' then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('style="%s"',[s]));
    end;
    if Result<>'' then
      Result := ' '+Result+' '
    else
      Result := ' ';
  end;
  {.................................................................}
var Location: String;
    DoDefault: Boolean;
begin
  if (ImageFileName<>'') and (rvsoUseItemImageFileNames in SaveOptions) then
    Location := RVExtractRelativePath(Path, ImageFileName)
  else
    Location := '';
  TCustomRVData(RVData).HTMLSaveImage(TCustomRVData(RVData), ItemNo, Path, CurrentFileColor, Location, DoDefault);
  if DoDefault then
    if (ImageFileName<>'') and (rvsoUseItemImageFileNames in SaveOptions) then
      Location := RVExtractRelativePath(Path, ImageFileName)
    else
      Location := TCustomRVData(RVData).DoSavePicture(rvsfHTML, imgSavePrefix, Path,
        imgSaveNo, rvsoOverrideImages in SaveOptions, CurrentFileColor, Image);
  if Location<>'' then
    RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<img%s%ssrc="%s"%s>',
      [GetHTMLImageAlign(VAlign, SaveOptions, UseCSS), GetExtraIMGStr,
       StringToHTMLString(RV_GetHTMLPath(Location), SaveOptions, TCustomRVData(RVData).GetRVStyle),
       RV_HTMLGetEndingSlash(SaveOptions)]));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
  ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
  var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var grcls : TGraphicClass;
    ifn: String;
    GraphicClassName: String;
    {$IFDEF RVFPICTURENEEDED2}
    Image2: TGraphic;
    {$ENDIF}
begin
  Result := True;
  case ReadType of
    1: // ask user
      begin
        case LineNo of
          0:
            begin
              Image := TCustomRVData(RVData).RVFPictureNeeded(
                {$IFDEF RVUNICODESTR}String(TRVAnsiString(s)),{$ELSE}s,{$ENDIF}
                Tag, False);
              Name := s;
            end;
          else
            begin
              ifn := ImageFileName;
              SetExtraPropertyFromRVFStr(s, UTF8Strings);
              if (ifn<>ImageFileName) and (ImageFileName<>'') and (Image=nil) then
                Image := TCustomRVData(RVData).RVFPictureNeeded(ImageFileName, Tag, False);
            end;
        end;
      end;
    else // load picture from file
      begin
        if LineNo=0 then
          Name := s
        else if LineNo=1 then begin
          {$IFDEF RVUNICODESTR}
          GraphicClassName := String(s);
          {$ELSE}
          GraphicClassName := s; // workaround for Delphi 3-6 bug
          {$ENDIF}
          grcls := TGraphicClass(GetClass(GraphicClassName));
          if grcls=nil then begin
            TCustomRVData(RVData).RVFWarnings :=
              TCustomRVData(RVData).RVFWarnings + [rvfwUnknownPicFmt];
            if not (rvfoIgnoreUnknownPicFmt in TCustomRVData(RVData).RVFOptions) then
              Result := False;
            end
          else begin
            Image := RV_CreateGraphics(grcls);
          end;
          end
        else if LineNo=LineCount-1 then begin
          {$IFDEF RVFPICTURENEEDED2}
          Image2 := TCustomRVData(RVData).RVFPictureNeeded(
            {$IFDEF RVUNICODESTR}String(TRVAnsiString(Name)),{$ELSE}Name,{$ENDIF}
            Tag, True);
          if ImageFileName<>'' then
            Image2 := TCustomRVData(RVData).RVFPictureNeeded(
              ImageFileName, Tag, True);
          if Image2<>nil then begin
            Image.Free;
            Image := Image2
            end
          else
          {$ENDIF}
            if Image<>nil then begin
            try
              if ReadType=2 then
                RVFLoadPictureBinary(s, Image)
              else
                Result := RVFLoadPicture(s, Image);
               {$IFNDEF RVDONOTCORRECTWMFSCALE}
                if (Image is TMetafile)
                   {$IFNDEF RVCORRECTWMFSCALE2} and not TMetafile(Image).Enhanced{$ENDIF} and
                   (TMetafile(Image).Inch=0)  then
                   TMetafile(Image).Inch := 1440;
               {$ENDIF}
            except
              Image.Free;
              Image := RV_CreateGraphics(TGraphicClass(TCustomRVData(RVData).
                GetRVStyle.InvalidPicture.Graphic.ClassType));
              Image.Assign(TCustomRVData(RVData).GetRVStyle.InvalidPicture.Graphic);
              TCustomRVData(RVData).RVFWarnings :=
                TCustomRVData(RVData).RVFWarnings+[rvfwInvalidPicture];
            end;
          end;
          ReadState := rstSkip;
          end
        else
          SetExtraPropertyFromRVFStr(s, UTF8Strings);
        if (ReadType=2) and (LineNo=LineCount-2) then
            ReadMode := rmBeforeBinary;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if not FResizable then
    inc(Result);
  if ImageWidth>0 then
    inc(Result);
  if ImageHeight>0 then
    inc(Result);
  if MinHeightOnPage>0 then
    inc(Result);
  if NoHTMLImageSize then
    inc(Result);
  if Interval>0 then
    inc(Result);
  if FShared then
    inc(Result);
  {$IFDEF RICHVIEWCBDEF3}
  if (Image<>nil) and (Image is TBitmap) and TBitmap(Image).Transparent then begin
    inc(Result,2);
    if TBitmap(Image).TransparentMode=tmFixed then
      inc(Result);
  end;
  {$ENDIF}
  if ImageFileName<>'' then
    inc(Result);
  if Alt<>'' then
    inc(Result);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited SaveRVFExtraProperties(Stream);
  if not FResizable then
    WriteRVFExtraIntPropertyStr(Stream, rvepResizable, ord(FResizable));
  if ImageWidth>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepImageWidth, ImageWidth);
  if ImageHeight>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepImageHeight, ImageHeight);
  if MinHeightOnPage>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepMinHeightOnPage, MinHeightOnPage);
  if NoHTMLImageSize then
    WriteRVFExtraIntPropertyStr(Stream, rvepNoHTMLImageSize, 1);
  if Interval>0 then
    WriteRVFExtraIntPropertyStr(Stream, rvepAnimationInterval, Interval);
  if FShared then
    WriteRVFExtraIntPropertyStr(Stream, rvepShared, ord(FShared));
  {$IFDEF RICHVIEWCBDEF3}
  if (Image<>nil) and (Image is TBitmap) and TBitmap(Image).Transparent then begin
    WriteRVFExtraIntPropertyStr(Stream, rvepTransparent, 1);
    WriteRVFExtraIntPropertyStr(Stream, rvepTransparentMode,
      ord(TBitmap(Image).TransparentMode));
    if TBitmap(Image).TransparentMode=tmFixed then
      WriteRVFExtraIntPropertyStr(Stream, rvepTransparentColor,
        TBitmap(Image).TransparentColor);
  end;
  {$ENDIF}
  if ImageFileName<>'' then
    WriteRVFExtraStrPropertyStr(Stream, rvespImageFileName, ImageFileName);
  if Alt<>'' then
    WriteRVFExtraStrPropertyStr(Stream, rvespAlt, Alt);
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty;
  Value: Integer): Boolean;
begin
  Result := False;
  case Prop of
    rvepResizable:
      begin
        FResizable := Value<>0;
        Result := True;
      end;
    rvepImageWidth:
      begin
        ImageWidth := Value;
        Result := True;
      end;
    rvepImageHeight:
      begin
        ImageHeight := Value;
        Result := True;
      end;
    rvepMinHeightOnPage:
      begin
        MinHeightOnPage := Value;
        Result := True;
      end;
    rvepNoHTMLImageSize:
      begin
        NoHTMLImageSize := Value<>0;
        Result := True;
      end;
    rvepAnimationInterval:
      begin
        Interval := Value;
        Result := True;
      end;
    rvepShared:
      begin
        FShared := Value<>0;
        Result := True;
      end;
    {$IFDEF RICHVIEWCBDEF3}
    rvepTransparent:
      if (Image<>nil) and (Image is TBitmap) then begin
        TBitmap(Image).Transparent := Value<>0;
        Result := True;
      end;
    rvepTransparentMode:
      if (Image<>nil) and (Image is TBitmap) then begin
        TBitmap(Image).TransparentMode := TTransparentMode(Value);
        Result := True;
      end;
    rvepTransparentColor:
      begin
        if (Image<>nil) and (Image is TBitmap) then begin
          TBitmap(Image).TransparentColor := TColor(Value);
          Result := True;
        end;
      end;
    {$ENDIF}
    else
      Result := inherited SetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty;
  var Value: Integer): Boolean;
begin
  Result := False;
  case Prop of
    rvepResizable:
      begin
        Value := ord(FResizable);
        Result := True;
      end;
    rvepImageWidth:
      begin
        Value := ImageWidth;
        Result := True;
      end;
    rvepImageHeight:
      begin
        Value := ImageHeight;
        Result := True;
      end;
    rvepMinHeightOnPage:
      begin
        Value := MinHeightOnPage;
        Result := True;
      end;
    rvepNoHTMLImageSize:
      begin
        Value := ord(NoHTMLImageSize);
        Result := True;
      end;
    rvepAnimationInterval:
      begin
        Value := Interval;
        Result := True;
      end;
    rvepShared:
      begin
        Value := ord(FShared);
        Result := True;
      end;
    {$IFDEF RICHVIEWCBDEF3}
    rvepTransparent:
      if (Image<>nil) and (Image is TBitmap) then begin
        Value := ord(TBitmap(Image).Transparent);
        Result := True;
      end;
    rvepTransparentMode:
      if (Image<>nil) and (Image is TBitmap) then begin
        Value := ord(TBitmap(Image).TransparentMode);
        Result := True;
      end;
    rvepTransparentColor:
      begin
        if (Image<>nil) and (Image is TBitmap) then begin
          Value := Integer(TBitmap(Image).TransparentColor);
          Result := True;
        end;
      end;
    {$ENDIF}
    else
      Result := inherited GetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.GetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; var Value: String): Boolean;
begin
  case Prop of
    rvespImageFileName:
      begin
        Value := ImageFileName;
        Result := True;
      end;
    rvespAlt:
      begin
        Value := Alt;
        Result := True;
      end;
    else
      Result := inherited GetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.SetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; const Value: String): Boolean;
begin
  case Prop of
    rvespImageFileName:
      begin
        ImageFileName := Value;
        Result := True;
      end;
    rvespAlt:
      begin
        Alt := Value;
        Result := True;
      end;
    else
      Result := inherited SetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.SaveRVF(Stream: TStream;
  RVData: TPersistent; ItemNo, ParaNo: Integer;
  const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
var SaveType, LineCount, Pos: Integer;
    InvalidGraphic: TGraphic;
begin
  if rvfoSavePicturesBody in TCustomRVData(RVData).RVFOptions then begin
    if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
      SaveType := 2 // save binary
    else
      SaveType := 0; // save hex dump
    LineCount := 3+GetRVFExtraPropertyCount;
    end
  else begin
    SaveType := 1; // do not save
    LineCount := 1+GetRVFExtraPropertyCount;
  end;
  RVFWriteLine(Stream,
    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
    [StyleNo, LineCount,
    RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
    Byte(RVFGetItemOptions(ItemOptions,ForceSameAsPrev)) and RVItemOptionsMask,
    SaveType,
    RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options, Tag),
     SaveRVFHeaderTail(RVData)]));
  RVFWriteLine(Stream, Name);
  if SaveType<>1 then begin
    Pos := Stream.Position;
    try
      RVFWriteLine(Stream, TRVAnsiString(Image.ClassName));
      SaveRVFExtraProperties(Stream);
      if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
        RVFSavePictureBinary(Stream, Image)
      else
        RVFWriteLine(Stream, RVFSavePicture(Image));
    except
      if Stream.Size=Stream.Position then
        Stream.Size := Pos;
      Stream.Position := Pos;
      InvalidGraphic := TCustomRVData(RVData).GetRVStyle.InvalidPicture.Graphic;
      RVFWriteLine(Stream, TRVAnsiString(InvalidGraphic.ClassName));
      SaveRVFExtraProperties(Stream);
      if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
        RVFSavePictureBinary(Stream, InvalidGraphic)
      else
        RVFWriteLine(Stream, RVFSavePicture(InvalidGraphic));
    end;
    end
  else
    SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
{ Saves Image to Stream in RTF format. The image can be scaled to
  ImageWidth x ImageHeight (if they are positive values).
  TwipsPerPixel is used to convert pixels to twips.
  If Animator<>nil, this picture is an animation, and Animator is used to
  save the first frame.
}
procedure RVSaveImageToRTF(Stream: TStream; RVStyle: TRVStyle;
  Image: TGraphic; ImageWidth, ImageHeight: TRVStyleLength; Options: TRVRTFOptions;
  Animator: TObject);
var wmf: TMetafile;
    FreeWMF: Boolean;
    png: TGraphic;
    {$IFDEF RICHVIEWCBDEF3}
    bmp: TBitmap;
    slw: Integer;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEANIMATION}
    MetCanvas: TMetafileCanvas;
    Size: TSize;
    {$ENDIF}
    picw, pich: TRVStyleLength;
    {..........................................................}
    procedure WritePicture(gr: TGraphic; SkipBytes: Integer);
    var s: TRVRawByteString;
    begin
      if rvrtfSavePicturesBinary in Options then begin
        s := RVFSavePictureBinaryWithoutSize(gr);
        if Length(s)>SkipBytes then begin
          RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
            Format('{\bin%d ', [Length(s)-SkipBytes]));
          Stream.WriteBuffer((PRVAnsiChar(s)+SkipBytes)^, Length(s)-SkipBytes);
          RVFWrite(Stream, '}');
        end;
        end
      else begin
        s := RVFSavePicture(gr);
        if Length(s)>SkipBytes*2 then
          RVFWrite(Stream, PRVAnsiChar(s)+SkipBytes*2);
      end
    end;
    {..........................................................}
    procedure WriteBitmap(bmp: TBitmap);
    begin
      WritePicture(bmp, sizeof(TBitmapFileHeader));
    end;
    {..........................................................}
    procedure WriteMetafile(wmf: TMetafile);
    begin
      WritePicture(wmf, 22); // sizeof(TMetafileHeader) = 22
    end;
    {..........................................................}
begin
  if Image=nil then
    exit;
  RVFWrite(Stream,'{\pict');

  if (Animator=nil)
     {$IFNDEF RVDONOTUSEANIMATION}
     or not TRVAnimator(Animator).ExportIgnoresScale
     {$ENDIF} then begin
    if (ImageWidth>0) and (Image.Width>0) then begin
      picw := RVStyle.PixelsToUnits(Image.Width);
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('\picscalex%d', [Round(ImageWidth*100/picw)]));
    end;
    if (ImageHeight>0) and (Image.Height>0) then begin
      pich := RVStyle.PixelsToUnits(Image.Height);
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('\picscaley%d', [Round(ImageHeight*100/pich)]));
    end;
  end;

  {$IFDEF RICHVIEWCBDEF3} // requires ScanLine property...
  // Saving bitmaps ...
  if (Image is TBitmap) and (Animator=nil) then begin
    if (rvrtfPNGInsteadOfBitmap in Options) and (RVPngGraphiClass<>nil) then begin
      png := RV_CreateGraphics(RVPngGraphiClass);
      try
        png.Assign(Image);
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('\pngblip\picw%d\pich%d ', [png.Width, png.Height]));
        WritePicture(png, 0);
      finally
        png.Free;
      end;
      end
    else begin
      if TBitmap(Image).Height>1 then
        slw := abs(PRVAnsiChar(TBitmap(Image).ScanLine[1])-PRVAnsiChar(TBitmap(Image).ScanLine[0]))
      else
        slw := Image.Width;
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('\dibitmap0\wbmwidthbytes%d\picw%d\pich%d\picwgoal%d\pichgoal%d ',
          [ slw, Image.Width, Image.Height, Image.Width*15, Image.Height*15]));
      WriteBitmap(TBitmap(Image));
    end;
  end
  // Saving metafiles ...
  else
  {$ENDIF}
    if (Image is TMetafile) and (Animator=nil)  then begin
      if TMetafile(Image).Enhanced then
        if not (rvrtfSaveEMFAsWMF in Options) then begin
          RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
            Format('\emfblip\picw%d\pich%d\picwgoal%d\pichgoal%d ',
              [TMetafile(Image).MMWidth, TMetafile(Image).MMHeight,
               RVStyle.PixelsToTwips(TMetafile(Image).Width),
               RVStyle.PixelsToTwips(TMetafile(Image).Height)]));
          WritePicture(Image, 0);
          wmf := nil;
          FreeWMF := False;
          end
        else begin
          wmf := TMetafile.Create;
          wmf.Assign(Image);
          wmf.Enhanced := False;
          FreeWMF := True;
        end
      else begin
        wmf := TMetafile(Image);
        FreeWMF := False;
      end;
      if wmf<>nil then begin
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('\wmetafile8\picw%d\pich%d\picwgoal%d\pichgoal%d ',
            [wmf.MMWidth, wmf.MMHeight,
             RVStyle.PixelsToTwips(wmf.Width),
             RVStyle.PixelsToTwips(wmf.Height)]));
        WriteMetafile(wmf);
        if FreeWMF then
          wmf.Free;
      end;
    end
  else
  // Saving Jpegs ...
   {$IFNDEF RVDONOTUSEJPEGIMAGE}
  if (Image is TJpegImage) and (rvrtfSaveJpegAsJpeg in Options) and
     (Animator=nil) then begin
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
      '\jpegblip\picw%d\pich%d\picwgoal%d\pichgoal%d ',
      [Image.Width, Image.Height,
       RVStyle.PixelsToTwips(Image.Width),
       RVStyle.PixelsToTwips(Image.Height)]));
    WritePicture(Image, 0);
    end
  else
  {$ENDIF}
  // Saving PNG...
  if (RVPngGraphiClass<>nil) and (Image is RVPngGraphiClass) and 
    (Animator=nil) then begin
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
      '\pngblip\picw%d\pich%d ', [Image.Width, Image.Height]));
    WritePicture(Image, 0);
    end
  else
  {$IFDEF RICHVIEWCBDEF3}
  if (rvrtfSaveBitmapDefault in Options) or (Image is TBitmap) then begin
    // Saving other image formats, such as icons, as bitmaps
    bmp := TBitmap.Create;
    {$IFNDEF RVDONOTUSEANIMATION}
    if Animator<>nil then begin
      Size := TRVAnimator(Animator).GetExportImageSize;
      bmp.Width  := Size.cx;
      bmp.Height := Size.cy;
      TRVAnimator(Animator).DrawForExport(bmp.Canvas);
      end
    else
    {$ENDIF}
      try
        bmp.Assign(Image);
      except
        bmp.Width := Image.Width;
        bmp.Height := Image.Height;
        bmp.Canvas.Brush.Color := clWhite;
        bmp.Canvas.FillRect(Rect(0,0,bmp.Width,bmp.Height));
        bmp.Canvas.Draw(0,0,Image);
      end;
    if (rvrtfPNGInsteadOfBitmap in Options) and (RVPngGraphiClass<>nil) then begin
      png := RV_CreateGraphics(RVPngGraphiClass);
      try
        png.Assign(bmp);
        RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('\pngblip\picw%d\pich%d ', [png.Width, png.Height]));
        WritePicture(png, 0);
      finally
        png.Free;
      end;
      end
    else begin
      if bmp.Height>1 then
        slw := abs(PRVAnsiChar(bmp.ScanLine[1])-PRVAnsiChar(bmp.ScanLine[0]))
      else
        slw := bmp.Width;
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
       Format('\dibitmap0\wbmwidthbytes%d\picw%d\pich%d\picwgoal%d\pichgoal%d ',
         [slw, bmp.Width, bmp.Height, bmp.Width*15, bmp.Height*15]));
      WriteBitmap(bmp);
    end;
    bmp.Free;
    end
  else
  {$ENDIF}
  begin
    // Saving other image formats, such as icons, as metafiles
    wmf :=  TMetafile.Create;
    wmf.Enhanced := False;
    {$IFNDEF RVDONOTUSEANIMATION}
    if Animator<>nil then begin
      Size := TRVAnimator(Animator).GetExportImageSize;
      wmf.Width  := Size.cx;
      wmf.Height := Size.cy;
      MetCanvas := TMetafileCanvas.Create(wmf, 0);
      TRVAnimator(Animator).DrawForExport(MetCanvas);
      MetCanvas.Free;
      end
    else
    {$ENDIF}
    begin
      wmf.Width := Image.Width;
      wmf.Height := Image.Height;
      with TMetafileCanvas.Create(wmf, 0) do begin
        Draw(0,0, Image);
        Free;
      end;
    end;
    if rvrtfSaveEMFDefault in Options then begin
      wmf.Enhanced := True;
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
        '\emfblip\picw%d\pich%d\picwgoal%d\pichgoal%d ',
        [wmf.MMWidth, wmf.MMHeight,
         RVStyle.PixelsToTwips(wmf.Width),
         RVStyle.PixelsToTwips(wmf.Height)]));
      WritePicture(wmf, 0);
      end
    else begin
      // Unfortunately, some RTF readers can read only wmetafile8 (for ex., WordPad).
      // MS Word reads all correctly
      // (there are some problems with picture size when saving wmetafile8)
      // May be it will be better to store unknown formats as bitmaps,
      // but it's not recommended, and some quality losing is possible.
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
        '\wmetafile1\picw%d\pich%d ', [wmf.Width, wmf.Height]));
      WriteMetafile(wmf);
    end;
    wmf.Free;
  end;
  RVFWrite(Stream,'}');
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVSaveImageToRTF(Stream, TCustomRVData(RVData).GetRVStyle, Image, ImageWidth, ImageHeight,
    TCustomRVData(RVData).RTFOptions,
    {$IFNDEF RVDONOTUSEANIMATION}FAnimator{$ELSE}nil{$ENDIF});
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean;
  RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode):Boolean;
var Top, Height: Integer;
    SourceImage: TGraphic;
    {$IFDEF RICHVIEWCBDEF3}
    TmpBackground: TBitmap;
    {$ENDIF}
    GraphicInterface: TRVGraphicInterface;
begin
  Result := True;
  GraphicInterface := TCustomRichView(RichView).Style.GraphicInterface;
  if Preview and (ImageCopy<>nil) then
    SourceImage := ImageCopy
  else
    SourceImage := Image;
  // If the source picture is increased in at least one
  // dimension, resizing background image (for providing higher quality).
  // Images printed on several pages (Part>=0) cannot be resized in height,
  // so height is checked only if Part<0.
  // If the source image is transparent, background is stretched; otherwise
  // the content of bkgnd does not matter
  if (bkgnd.Width<SourceImage.Width) or
     ((Part<0) and (bkgnd.Height<SourceImage.Height)) then begin
    {$IFDEF RICHVIEWCBDEF3}
    if SourceImage.Transparent then begin
      TmpBackground := TBitmap.Create;
      TmpBackground.Assign(bkgnd);
      end
    else
      TmpBackground := nil;
    try
    {$ENDIF}
      if bkgnd.Width<SourceImage.Width then
        bkgnd.Width := SourceImage.Width;
      if (Part<0) and (bkgnd.Height<SourceImage.Height) then
        bkgnd.Height := SourceImage.Height;
    {$IFDEF RICHVIEWCBDEF3}
      if TmpBackground<>nil then
        GraphicInterface.StretchDrawGraphic(bkgnd.Canvas,
          Rect(0,0,bkgnd.Width,bkgnd.Height), TmpBackground);
    finally
      TmpBackground.Free;
    end;
    {$ENDIF}
  end;
  if (dli is TRVMultiImagePrintInfo) and (Part>=0) then begin
    // Drawing the image part. Multipage images cannot be scaled in height,
    // so we use SourceImage.Height
    Top := -TRVImagePrintPart(TRVMultiImagePrintInfo(dli).PartsList[Part]).ImgTop;
    Height := SourceImage.Height;
    end
  else begin
    // Drawing the whole image
    Top := 0;
    Height := bkgnd.Height;
  end;
  GraphicInterface.StretchDrawGraphic(bkgnd.Canvas,
    Bounds(0,Top,bkgnd.Width,Height), SourceImage);
end;
{------------------------------------------------------------------------------}
procedure TRVGraphicItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer;
  Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
  RichView: TRVScroller; dli: TRVDrawLineInfo;
  Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent);
var DCState: Integer;
    R: TRect;
    GraphicInterface: TRVGraphicInterface;
    RVStyle: TRVStyle;
begin
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  GraphicInterface := RVStyle.GraphicInterface;
  // will be called only for metafiles
  DCState := GraphicInterface.SaveCanvasState(Canvas);
  try
    R := Bounds(
      x+RVStyle.GetAsDevicePixelsX(GetBorderWidth, @sad),
      y+RVStyle.GetAsDevicePixelsY(GetBorderHeight, @sad),
      GetImageWidthEx(RVStyle, @sad), GetImageHeightEx(RVStyle, @sad));
    with R do
      GraphicInterface.IntersectClipRect(Canvas, Left, Top, Right, Bottom);
    GraphicInterface.StretchDrawGraphic(Canvas, r, Image);
  finally
    GraphicInterface.RestoreCanvasState(Canvas, DCState);
  end;
end;
{------------------------------------------------------------------------------}
function TRVGraphicItemInfo.CreatePrintingDrawItem(RVData, ParaStyle: TObject;
  const sad: TRVScreenAndDevice): TRVDrawLineInfo;
var RVStyle: TRVStyle;
begin
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  if not GetBoolValueEx(rvbpPrintToBMP, RVStyle) or (MinHeightOnPage=0) or
    ((ImageHeight>0) and (RVStyle.GetAsPixels(ImageHeight)<>Image.Height)) then begin
    Result := inherited CreatePrintingDrawItem(RVData, ParaStyle, sad);
    exit;
  end;
  Result := TRVMultiImagePrintInfo.Create(Self, TCustomRVData(RVData));
  Result.Width  := GetWidthEx(RVStyle, @sad);
  Result.Height := GetHeightEx(RVStyle, @sad);
end;
{============================ TRVHotGraphicItemInfo ===========================}
constructor TRVHotGraphicItemInfo.CreateEx(RVData: TPersistent;
  AImage: TGraphic; AVAlign: TRVVAlign);
begin
  inherited CreateEx(RVData, AImage, AVAlign);
  StyleNo := rvsHotPicture;
end;
{------------------------------------------------------------------------------}
function TRVHotGraphicItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpJump, rvbpAllowsFocus, rvbpXORFocus:
      Result := True;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVHotGraphicItemInfo.Execute(RVData:TPersistent);
begin
  if RVData is TCustomRVFormattedData then
    TCustomRVFormattedData(RVData).DoJump(JumpID+
      TCustomRVFormattedData(RVData).FirstJumpNo)
end;
{============================== TRVBulletItemInfo =============================}
constructor TRVBulletItemInfo.CreateEx(RVData: TPersistent; AImageIndex: Integer; AImageList: TCustomImageList; AVAlign: TRVVAlign);
begin
  inherited Create(RVData);
  StyleNo    := rvsBullet;
  ImageIndex := AImageIndex;
  ImageList  := AImageList;
  VAlign     := AVAlign;
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVBulletItemInfo then begin
    ImageList  := TRVBulletItemInfo(Source).ImageList;
    ImageIndex := TRVBulletItemInfo(Source).ImageIndex;
    NoHTMLImageSize := TRVBulletItemInfo(Source).NoHTMLImageSize;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  Result := TImageList(ImageList).Height+RVStyle.GetAsPixels(GetBorderHeight)*2;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  Result := TImageList(ImageList).Width+RVStyle.GetAsPixels(GetBorderWidth)*2;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetImageHeight(RVStyle: TRVStyle): Integer;
begin
  Result := TImageList(ImageList).Height;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetImageWidth(RVStyle: TRVStyle): Integer;
begin
  Result := TImageList(ImageList).Width;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetHeightEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  Result := TImageList(ImageList).Height;
  if sad<>nil then
    Result := RV_YToDevice(Result, sad^);
  inc(Result, RVStyle.GetAsDevicePixelsY(GetBorderHeight, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetWidthEx(RVStyle: TRVStyle; sad: PRVScreenAndDevice): Integer;
begin
  Result := TImageList(ImageList).Width;
  if sad<>nil then
    Result := RV_XToDevice(Result, sad^);
  inc(Result, RVStyle.GetAsDevicePixelsX(GetBorderWidth, sad)*2);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  RVData: TPersistent): Integer;
begin
  Result := GetWidthEx(TCustomRVData(RVData).GetRVStyle, sad);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetImageIndex(Hot: Boolean): Integer;
begin
  Result := ImageIndex;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpValid:
      Result := ImageList<>nil;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpDisplayActiveState:
      Result := True;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetExtraIntProperty(Prop: TRVExtraItemProperty;
  var Value: Integer): Boolean;
begin
  case Prop of
    rvepNoHTMLImageSize:
      begin
        Value := ord(NoHTMLImageSize);
        Result := True;
      end;
    else
      Result := inherited GetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.SetExtraIntProperty(Prop: TRVExtraItemProperty;
  Value: Integer): Boolean;
begin
  case Prop of
    rvepNoHTMLImageSize:
      begin
        NoHTMLImageSize := Value<>0;
        Result := True;
      end;
    else
      Result := inherited SetExtraIntProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; var Value: String): Boolean;
begin
  case Prop of
    rvespAlt:
      begin
        Value := Alt;
        Result := True;
      end;
    else
      Result := inherited GetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.SetExtraStrProperty(
  Prop: TRVExtraItemStrProperty; const Value: String): Boolean;
begin
  case Prop of
    rvespAlt:
      begin
        Alt := Value;
        Result := True;
      end;
    else
      Result := inherited SetExtraStrProperty(Prop, Value);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if NoHTMLImageSize then
    inc(Result);
  if Alt<>'' then
    inc(Result);
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited SaveRVFExtraProperties(Stream);
  if NoHTMLImageSize then
    WriteRVFExtraIntPropertyStr(Stream, rvepNoHTMLImageSize, 1);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.PrintToBitmap(Bkgnd: TBitmap; Preview: Boolean;
  RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode): Boolean;
begin
  Result := True;
  ImageList.Draw(Bkgnd.Canvas,0,0, ImageIndex);
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
var SelColor: TColor;
    BorderWidthPix, BorderHeightPix: Integer;
begin
  if (rvidsSelected in State) then begin
    if rvidsControlFocused in State then
      SelColor := Style.SelColor
    else
      SelColor := Style.InactiveSelColor;
    end
  else
    SelColor := clNone;
  BorderWidthPix  := Style.GetAsPixels(GetBorderWidth);
  BorderHeightPix := Style.GetAsPixels(GetBorderHeight);
  Style.GraphicInterface.DrawImageList(Canvas, ImageList,
    GetImageIndex(rvidsHover in State), x+BorderWidthPix, y+BorderHeightPix, SelColor);
  if (rvidsCurrent in State) and (Style.CurrentItemColor<>clNone) then begin
    Canvas.Pen.Color := Style.CurrentItemColor;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    Style.GraphicInterface.Rectangle(Canvas, x,y,
      x+TImageList(ImageList).Width+BorderWidthPix*2,
      y+TImageList(ImageList).Height+BorderHeightPix*2);
  end;
  if Hidden then
    RVDrawHiddenUnderline(Canvas, Style.TextStyles[0].Color,
      x, x+TImageList(ImageList).Width+BorderWidthPix*2,
      y+TImageList(ImageList).Height+BorderHeightPix*2,
      Style.GraphicInterface);
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var ImageListNo: Integer;
begin
  Result := (RVFReadInteger(P,ImageListNo) and
             RVFReadInteger(P,ImageIndex));
  if not Result then exit;
  ImageList := TCustomRVData(RVData).RVFImageListNeeded(ImageListNo);
  if ImageList<>nil then
    if ImageList.Count<=ImageIndex then begin
      TCustomRVData(RVData).RVFWarnings := TCustomRVData(RVData).RVFWarnings+[rvfwConvLargeImageIdx];
      if rvfoConvLargeImageIdxToZero in TCustomRVData(RVData).RVFOptions then
        ImageIndex := 0
      else
        Result := False;
    end;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.ReadRVFLine(const s: TRVRawByteString;
  RVData: TPersistent; ReadType, LineNo, LineCount: Integer;
  var Name: TRVRawByteString; var ReadMode: TRVFReadMode;
  var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  if (LineNo=0) then
    Name := s
  else
    SetExtraPropertyFromRVFStr(s, UTF8Strings);
  Result := True;
end;
{------------------------------------------------------------------------------}
function TRVBulletItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  Result :=  {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%d %d', [ImageList.Tag, ImageIndex]);
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo,ParaNo: Integer; const Name: TRVRawByteString;
  Part: TRVMultiDrawItemPart; ForceSameAsPrev: Boolean);
begin

  RVFWriteLine(Stream,
    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
          [StyleNo, 1+GetRVFExtraPropertyCount,
           RVFItemSavePara(ParaNo,TCustomRVData(RVData), ForceSameAsPrev),
           Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
           0, RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options, Tag),
           SaveRVFHeaderTail(RVData)]));
  RVFWriteLine(Stream, Name);
  SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
procedure RVSaveImageListImageToRTF(Stream: TStream;
                                    TwipsPerPixel: Double;
                                    ImageList: TCustomImageList;
                                    ImageIndex: Integer;
                                    RTFOptions: TRVRTFOptions);
var s: TRVAnsiString;
    wmf: TMetafile;
    {$IFDEF RICHVIEWCBDEF3}
    bmp: TBitmap;
    slw: Integer;
    {$ENDIF}
    Canvas: TMetafileCanvas;
begin
  if (ImageList=nil) or (ImageIndex<0) or
     (ImageIndex>=ImageList.Count) then
    exit;
  RVFWrite(Stream,'{\pict');
  {$IFDEF RICHVIEWCBDEF3}
  if rvrtfSaveBitmapDefault in RTFOptions then begin
    bmp := TBitmap.Create;
    ImageList.GetBitmap(ImageIndex, bmp);
    s := RVFSavePicture(bmp);
    if bmp.Height>1 then
      slw := abs(PRVAnsiChar(bmp.ScanLine[1])-PRVAnsiChar(bmp.ScanLine[0]))
    else
      slw := bmp.Width;
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\dibitmap0\wbmwidthbytes%d\picw%d\pich%d\picwgoal%d\pichgoal%d ',
        [slw, bmp.Width, bmp.Height, bmp.Width*15, bmp.Height*15]));
    RVFWrite(Stream, PRVAnsiChar(s)+sizeof(TBitmapFileHeader)*2);
    bmp.Free;
    end
  else
  {$ENDIF}
  begin
    wmf :=  TMetafile.Create;
    wmf.Enhanced := False;
    wmf.Width := TImageList(ImageList).Width;
    wmf.Height := TImageList(ImageList).Height;
    Canvas := TMetafileCanvas.Create(wmf, 0);
    ImageList.Draw(Canvas, 0, 0, ImageIndex);
    Canvas.Free;
    s := RVFSavePicture(wmf);
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\wmetafile1\picw%d\pich%d ', [wmf.Width, wmf.Height]));
    RVFWrite(Stream,PRVAnsiChar(s)+22*2); // sizeof(TMetafileHeader)=22
    wmf.Free;
  end;
  RVFWrite(Stream,'}');
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVSaveImageListImageToRTF(Stream, TwipsPerPixel,
    ImageList, ImageIndex, TCustomRVData(RVData).RTFOptions);
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure RVSaveImageSharedImageInHTML(ImageList: TCustomImageList;
  ImageIndex: Integer; Graphic: TGraphic;
  var Location: String;
  RVData: TPersistent; const Path,
  imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions;
  Bullets: TRVList);
var j: Integer;
    bmp: TBitmap;
    bi : TRVHTMLBulletInfo;
    GraphicInterface: TRVGraphicInterface;
begin
  Location := '';
  GraphicInterface := TCustomRVData(RVData).GetRVStyle.GraphicInterface;
  for j:=0 to Bullets.Count-1 do begin
    bi := TRVHTMLBulletInfo(Bullets[j]);
    if (ImageList = bi.ImageList) and
       (ImageIndex = bi.ImageIndex) and
       (Graphic = bi.Graphic) and
       (CurrentFileColor = bi.BackColor) then begin
      Location := bi.FileName;
      break;
    end;
  end;
  if Location='' then begin
    bmp := TBitmap.Create;
    try
      if ImageList<>nil then begin
        bmp.Width := TImageList(ImageList).Width;
        bmp.Height := TImageList(ImageList).Height;
        bmp.Canvas.Brush.Color := CurrentFileColor;
        bmp.Canvas.Pen.Color := CurrentFileColor;
        GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,bmp.Width,bmp.Height));
        GraphicInterface.DrawImageList(bmp.Canvas, ImageList, ImageIndex, 0, 0, clNone);
        end
      else begin
        bmp.Width := Graphic.Width;
        bmp.Height := Graphic.Width;
        bmp.Canvas.Brush.Color := CurrentFileColor;
        bmp.Canvas.Pen.Color := CurrentFileColor;
        GraphicInterface.FillRect(bmp.Canvas, Rect(0,0,bmp.Width,bmp.Height));
        GraphicInterface.DrawGraphic(bmp.Canvas, 0,0, Graphic);
      end;
      Location := TCustomRVData(RVData).DoSavePicture(rvsfHTML, imgSavePrefix, Path,
                     imgSaveNo, rvsoOverrideImages in SaveOptions,
                     CurrentFileColor, bmp);
      Location := RV_GetHTMLPath(Location);
      bi := TRVHTMLBulletInfo.Create;
      bi.FileName   := Location;
      bi.BackColor  := CurrentFileColor;
      bi.ImageList  :=  ImageList;
      bi.ImageIndex := ImageIndex;
      bi.Graphic    := Graphic;
      Bullets.Add(bi);
    finally
      bmp.Free;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBulletItemInfo.SaveToHTML(Stream: TStream;
  RVData: TPersistent; ItemNo: Integer; const Text: TRVRawByteString; const Path,
  imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions;
  UseCSS: Boolean; Bullets: TRVList);
var
    Location: String;
    DoDefault: Boolean;
    RVStyle: TRVStyle;
    {....................................................}
    function GetCSS: TRVAnsiString;
    var s: TRVAnsiString;
    begin
      Result := '';
      if UseCSS then begin
        Result := GetVShiftCSS(TCustomRVData(RVData).GetRVStyle);
        if Hidden then
          RV_AddStrA(Result, 'display : none;');
        if Result<>'' then
          RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('style="%s"',[Result]));
      end;
      if (Alt<>'') or UseCSS then begin
        s := StringToHTMLString(Alt, SaveOptions, TCustomRVData(RVData).GetRVStyle);
        RV_AddStrA(Result, 'alt="'+s+'"');
      end;
      {$IFNDEF RVDONOTUSEITEMHINTS}
      if Hint<>'' then begin
        s := StringToHTMLString(RV_GetHintStr(rvsfHTML, Hint), SaveOptions,
          TCustomRVData(RVData).GetRVStyle);
        RV_AddStrA(Result, s);
      end;
      {$ENDIF}
      if Spacing>0 then
        RV_AddStrA(Result, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('hspace=%s vspace=%s', [
          RV_HTMLGetIntAttrVal(RVStyle.GetAsPixels(Spacing), SaveOptions),
          RV_HTMLGetIntAttrVal(RVStyle.GetAsPixels(Spacing), SaveOptions)]));
      if Result<>'' then
        Result := ' '+Result+' ';
    end;
    {....................................................}
begin
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  TCustomRVData(RVData).HTMLSaveImage(TCustomRVData(RVData), ItemNo, Path,
    CurrentFileColor, Location, DoDefault);
  if DoDefault then
    RVSaveImageSharedImageInHTML(ImageList, ImageIndex, nil, Location, RVData, Path,
      imgSavePrefix, imgSaveNo, CurrentFileColor, SaveOptions, Bullets);
  RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('<img%s%ssrc="'+
    StringToHTMLString(Location, SaveOptions, TCustomRVData(RVData).GetRVStyle)+'"%s>',
    [RV_GetExtraIMGStr(SaveOptions, TImageList(ImageList).Width,
      TImageList(ImageList).Height, NoHTMLImageSize), GetCSS,
      RV_HTMLGetEndingSlash(SaveOptions)]));
end;
{$ENDIF}
{============================= TRVHotspotItemInfo =============================}
constructor TRVHotspotItemInfo.CreateEx(RVData: TPersistent; AImageIndex, AHotImageIndex: Integer;
                                        AImageList: TCustomImageList; AVAlign: TRVVAlign);
begin
  inherited CreateEx(RVData, AImageIndex, AImageList, AVAlign);
  StyleNo       := rvsHotspot;
  HotImageIndex := AHotImageIndex;
end;
{------------------------------------------------------------------------------}
procedure TRVHotspotItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVHotspotItemInfo then
    HotImageIndex := TRVHotspotItemInfo(Source).HotImageIndex;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
function TRVHotspotItemInfo.GetImageIndex(Hot: Boolean): Integer;
begin
  if Hot then
    Result := HotImageIndex
  else
    Result := ImageIndex;
end;
{------------------------------------------------------------------------------}
function TRVHotspotItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  Result := (inherited ReadRVFHeaderTail(P, RVData, UTF8Strings, AssStyleNameUsed));
  if not Result then
    exit;
  if not (P^ in [#0, #10, #13]) then begin
    Result := RVFReadInteger(P,HotImageIndex);
    if not Result then
      exit;
    end
  else
    HotImageIndex := ImageIndex;
  if ImageList<>nil then
    if ImageList.Count<=HotImageIndex then begin
      TCustomRVData(RVData).RVFWarnings := TCustomRVData(RVData).RVFWarnings+[rvfwConvLargeImageIdx];
    if rvfoConvLargeImageIdxToZero in TCustomRVData(RVData).RVFOptions then
      HotImageIndex := 0
    else
      Result := False;
    end;
end;
{------------------------------------------------------------------------------}
function TRVHotspotItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%s %d', [inherited SaveRVFHeaderTail(RVData), HotImageIndex]);
end;
{------------------------------------------------------------------------------}
procedure TRVHotspotItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo,ParaNo: Integer; const Name: TRVRawByteString;
  Part: TRVMultiDrawItemPart; ForceSameAsPrev: Boolean);
begin
  RVFWriteLine(Stream,
    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
          [StyleNo, 1+GetRVFExtraPropertyCount,
           RVFItemSavePara(ParaNo,TCustomRVData(RVData),ForceSameAsPrev),
           Byte(RVFGetItemOptions(ItemOptions,ForceSameAsPrev)) and RVItemOptionsMask,
           0, RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options, Tag),
           SaveRVFHeaderTail(RVData)]));
  RVFWriteLine(Stream, Name);
  SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
function TRVHotspotItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpJump, rvbpAllowsFocus,rvbpXORFocus:
       Result := True;
    rvbpHotColdJump:
       Result := ImageIndex<>HotImageIndex;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVHotspotItemInfo.Execute(RVData: TPersistent);
begin
  if RVData is TCustomRVFormattedData then
    TCustomRVFormattedData(RVData).DoJump(JumpID+
      TCustomRVFormattedData(RVData).FirstJumpNo)
end;
{============================ TRVBreakItemInfo ================================}
constructor TRVBreakItemInfo.CreateEx(RVData: TPersistent; ALineWidth: Byte; AStyle: TRVBreakStyle; AColor: TColor);
begin
  inherited Create(RVData);
  StyleNo   := rvsBreak;
  LineWidth := ALineWidth;
  Style     := AStyle;
  Color     := AColor;
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVBreakItemInfo then begin
    LineWidth := TRVBreakItemInfo(Source).LineWidth;
    Color     := TRVBreakItemInfo(Source).Color;
    Style     := TRVBreakItemInfo(Source).Style;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Drawing 3d edge with colors TopLeftColor, BottomRightColor.
  r - outer rectangle (right bottom coordinates inclusive).
  LineWidth - width of edge.                                                   }
procedure RVDrawEdge(Canvas: TCanvas; r: TRect;
  TopLeftColor, BottomRightColor: TColor; LineWidth: Integer;
  GraphicInterface: TRVGraphicInterface);
var i: Integer;
    DrawBottom: Boolean;
begin
  if LineWidth<=0 then
    LineWidth := 1;
  DrawBottom := r.Bottom-r.Top>=LineWidth;
  for i := LineWidth-1 downto 0 do begin
    Canvas.Pen.Color := TopLeftColor;
    GraphicInterface.MoveTo(Canvas, r.Left, r.Bottom);
    GraphicInterface.LineTo(Canvas, r.Left, r.Top);
    GraphicInterface.LineTo(Canvas, r.Right, r.Top);
    if DrawBottom then begin
      Canvas.Pen.Color := BottomRightColor;
      GraphicInterface.LineTo(Canvas, r.Right, r.Bottom);
      GraphicInterface.LineTo(Canvas, r.Left, r.Bottom);
      InflateRect(r, -1, -1);
      end
    else
      InflateRect(r, 0, -1);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
  Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
  sad: PRVScreenAndDevice; var HShift, Desc: Integer; NoCaching, Reformatting,
  UseFormatCanvas: Boolean);
var dx, dy, w: Integer;
begin
  dx := RV_XToDevice(5, sad^);
  dy := RV_YToDevice(5, sad^);
  w := TCustomRVData(RVData).GetRVStyle.GetAsPixels(LineWidth);
  if w>10 then
    dy := RV_YToDevice(w div 2, sad^);
  dli.Height := dy*2+1;
  dli.Width := DocWidth-dx*2;
  Desc := dy;
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.PaintFullWidth(Left, Right, Top: Integer;
  Canvas: TCanvas; State: TRVItemDrawStates; Style: TRVStyle;
  const ClipRect: TRect; dli: TRVDrawLineInfo; ExtraX, ExtraY: Integer);
var LineWidthPix: Integer;
begin
  dec(Left,ExtraX);
  Right := Left+dli.Width;
  dec(Top, ExtraY-(dli.Height div 2));
  if Color = clNone then
    Canvas.Pen.Color := Style.TextStyles[0].Color
  else
    Canvas.Pen.Color := Color;
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Brush.Style := bsClear;
  LineWidthPix := Style.GetAsPixels(LineWidth);
  case Self.Style of
    rvbsLine:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsNormal, LineWidthPix,
        Left, Right, Top, 0, Style.GraphicInterface);
    rvbsRectangle:
      begin
        Canvas.Pen.Width := 1;
        Style.GraphicInterface.Rectangle(Canvas, Left, Top-LineWidthPix div 2,
          Right, Top-LineWidthPix div 2+LineWidthPix);
      end;
    rvbs3d:
      begin
        Canvas.Pen.Width := 1;
        RVDrawEdge(Canvas,
          Rect(Left, Top-LineWidthPix div 2, Right-1, Top-LineWidthPix div 2+LineWidthPix-1),
          clBtnShadow, clBtnFace, 1, Style.GraphicInterface);
      end;
    rvbsDotted:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsRoundDotted, LineWidthPix,
        Left, Right, Top, 0, Style.GraphicInterface);
    rvbsDashed:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsDashed, LineWidthPix,
        Left, Right, Top, 0, Style.GraphicInterface);
  end;
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Width := 1;  
  Canvas.Brush.Style := bsClear;
  if rvidsSelected in State then begin
    if rvidsControlFocused in State then
      Canvas.Pen.Color := Style.SelColor
    else
      Canvas.Pen.Color := Style.InactiveSelColor;
    if Canvas.Pen.Color<>clNone then
      Style.GraphicInterface.Rectangle(Canvas, Left, Top-LineWidthPix div 2-1,
          Right, Top-LineWidthPix div 2+LineWidthPix+1);
  end;
  if Hidden then
    RVDrawHiddenUnderline(Canvas, Style.TextStyles[0].Color,
      Left, Right, Top-LineWidthPix div 2+LineWidthPix+1,
      Style.GraphicInterface);
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer;
  Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
  RichView: TRVScroller;  
  dli: TRVDrawLineInfo;Part: Integer; ColorMode: TRVColorMode; RVData: TPersistent);
var w: Integer;
    clr: TColor;
begin
  Canvas.Pen.Style := psInsideFrame;
  Canvas.Pen.Mode := pmCopy;
  if Color = clNone then
    clr := TCustomRVData(RVData).GetRVStyle.TextStyles[0].Color
  else
    clr := Color;
  Canvas.Pen.Color := RV_GetColor(clr, ColorMode);;
  inc(y, dli.Height div 2);
  x2 := x + dli.Width;
  w := TCustomRVData(RVData).GetRVStyle.GetAsDevicePixelsY(LineWidth, @sad);
  case Style of
    rvbsLine:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsNormal, w,
        x, x2, y-(w div 2), 0, TCustomRVData(RVData).GetRVStyle.GraphicInterface);
    rvbsRectangle:
      begin
        Canvas.Pen.Width := RV_YToDevice(1, sad);
        TCustomRVData(RVData).GetRVStyle.GraphicInterface.Rectangle(Canvas,
          x, y-(w div 2), x2, y-(w div 2)+w);
      end;
    rvbs3d:
      begin
        Canvas.Pen.Width := 1;
        RVDrawEdge(Canvas,
          Rect(x, y-(w div 2), x2-1, y-(w div 2)+w-1),
          RV_GetColor(clBtnShadow, ColorMode),
          RV_GetColor(clBtnHighlight, ColorMode),
          Round(sad.ppiyDevice/sad.ppiyScreen),
          TCustomRVData(RVData).GetRVStyle.GraphicInterface);
      end;
    rvbsDotted:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsRoundDotted, w,
        x, x2, y-(w div 2), 0, TCustomRVData(RVData).GetRVStyle.GraphicInterface);
    rvbsDashed:
      RVDrawCustomHLine(Canvas, Canvas.Pen.Color, rvlsDashed, w,
        x, x2, y-(w div 2), 0, TCustomRVData(RVData).GetRVStyle.GraphicInterface);
  end;
  Canvas.Pen.Style := psSolid;
end;
{------------------------------------------------------------------------------}
function TRVBreakItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String;
  TextOnly,Unicode: Boolean): TRVRawByteString;
var c: TRVAnsiChar;
begin
  if TCustomRVData(RVData).GetRVStyle.GetAsPixels(Self.LineWidth)>1 then
    c := '='
  else
    c := '-';
  if LineWidth<1 then
    LineWidth := 1;
  SetLength(Result, LineWidth);
  FillChar(PRVAnsiChar(Result)^, LineWidth, ord(c));
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVBreakItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path: String;
  const imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
var Title, CSS, NoShade, Border: TRVAnsiString;
    RVStyle: TRVStyle;
    LineWidthPix: Integer;
    LColor: TColor;
begin
  if rvsoForceNonTextCSS in SaveOptions then
    UseCSS := True;
  RVStyle := TCustomRVData(RVData).GetRVStyle;
  Title := '';
  {$IFNDEF RVDONOTUSEITEMHINTS}
  if Hint<>'' then begin
    Title := StringToHTMLString(RV_GetHintStr(rvsfHTML, Hint)+' ', SaveOptions,
      RVStyle);
  end;
  {$ENDIF}
  if Color<>clNone then
    LColor := Color
  else
    LColor := RVStyle.TextStyles[0].Color;
  CSS := '';
  if UseCSS then begin
    CSS := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('height: %s;',
      [RVStyle.GetCSSSize(LineWidth)]);
    if Style<>rvbs3d then
      RV_AddStrA(CSS, 'color : '+RV_GetHTMLRGBStr(LColor, False)+';'); // IE only
    case Style of
      rvbsLine:
        RV_AddStrA(CSS,
          ' background-color : '+RV_GetHTMLRGBStr(LColor, False)+';'+
          ' border-width : 0px;');
      rvbsDotted, rvbsDashed, rvbsRectangle:
        begin
          case Style of
            rvbsDotted:
              Border := 'dotted';
            rvbsDashed:
              Border := 'dashed';
            else
              Border := 'solid';
          end;
          RV_AddStrA(CSS, 'background-color : transparent; border-style : '+Border+';'+
            ' border-color : '+RV_GetHTMLRGBStr(LColor, False)+';');
          if Style=rvbsRectangle then
            RV_AddStrA(CSS, 'border-width : 1px;');
        end;
    end;
    if Hidden then
      RV_AddStrA(CSS, 'display : none;');
  end;
  LineWidthPix := RVStyle.GetAsPixels(LineWidth);
  if Style<>rvbs3d then
    NoShade := RV_HTMLGetNoValueAttribute('noshade', SaveOptions)+' '
  else
    NoShade := '';
  if UseCSS and (CSS<>'') then
    RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('<hr %s%sstyle="%s"%s>',
        [NoShade, Title, CSS,
         RV_HTMLGetEndingSlash(SaveOptions)]))
  else
    RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('<hr %ssize=%s %scolor=%s%s>',
        [NoShade,
         RV_HTMLGetIntAttrVal(LineWidthPix, SaveOptions),
         Title, RV_GetHTMLRGBStr(LColor, True),
         RV_HTMLGetEndingSlash(SaveOptions)]))
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVBreakItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var bc, bs,bw: Integer;
begin
  if not (P^ in [#0, #10, #13]) then begin
    Result := (RVFReadInteger(P,bc) and
               RVFReadInteger(P,bs) and
               RVFReadInteger(P,bw));
    if Result then begin
      LineWidth := bw;
      Style     := TRVBreakStyle(bs);
      Color     := bc;
    end;
    end
  else begin
    Color := clNone;
    Style := rvbsLine;
    LineWidth := TCustomRVData(RVData).GetRVStyle.PixelsToUnits(1);
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
function TRVBreakItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%d %d %d', [Integer(Color), Integer(Style), Integer(LineWidth)]);
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
  RVFWriteLine(Stream,
    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%d %d %s %d %d %s %s', [StyleNo, GetRVFExtraPropertyCount,
      RVFItemSavePara(ParaNo, TCustomRVData(RVData), False),
      Byte(ItemOptions) and RVItemOptionsMask,
      0, RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
      SaveRVFHeaderTail(RVData)]));
  SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.FillRTFTables(ColorList: TRVColorList;
  ListOverrideCountList: TRVIntegerList; RVData: TPersistent);
begin
  ColorList.AddUnique(Color);
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
var ColorIdx: Integer;
    tbl: TRVAnsiString;
begin
  if Color = clNone then
    ColorIdx := 0
  else
    ColorIdx := ColorList.IndexOf(Pointer(Color));
  case Level of
    0:
      tbl := '';
    1:
      tbl := '\intbl\itap1';
    else
      tbl := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('\itap%d',[Level]);
  end;
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('\pard%s\plain\fs6\brdrb\brdrs\brdrw%d\brdrcf%d\par\pard%s',
      [tbl, TCustomRVData(RVData).GetRVStyle.GetAsTwips(LineWidth), ColorIdx, tbl]));
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');      
end;
{------------------------------------------------------------------------------}
function TRVBreakItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpIgnorePara:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVBreakItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpActualPrintSize:
      Result := True;
    rvbpPrintToBMP:
      Result := False;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBreakItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
begin
  inherited;
  LineWidth := RVStyle.GetAsDifferentUnits(LineWidth, NewUnits);
end;
{================================ TRVTextItemInfo =============================}
procedure TRVTextItemInfo.Execute(RVData: TPersistent);
begin
  if RVData is TCustomRVFormattedData then begin
    if GetBoolValueEx(rvbpJump, TCustomRVData(RVData).GetRVStyle) then
      TCustomRVFormattedData(RVData).DoJump(JumpID+
          TCustomRVFormattedData(RVData).FirstJumpNo)
  end;
end;
{------------------------------------------------------------------------------}
function TRVTextItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpActualPrintSize:
      Result := True;
    rvbpJump, rvbpAllowsFocus,rvbpXORFocus:
      Result := RVStyle.TextStyles[GetActualStyleNo(RVStyle)].Jump;
    rvbpHotColdJump:
      Result := RVStyle.TextStyles[GetActualStyleNo(RVStyle)].Jump and
                RVStyle.StyleHoverSensitive(GetActualStyleNo(RVStyle));
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTextItemInfo.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
begin
  inherited MarkStylesInUse(Data);
  if StyleNo<>rvsDefStyle then
    Data.UsedTextStyles[StyleNo] := 1;
end;
{------------------------------------------------------------------------------}
function TRVTextItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  Result := True;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  {$IFDEF RICHVIEWCBDEF3}
  if P^<>#0 then
    Hint := RVFStringToString(AnsiExtractQuotedStr(P, '"'), UTF8Strings);
  {$ENDIF}
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVTextItemInfo.UpdateStyles(Data: TRVDeleteUnusedStylesData);
begin
  inherited UpdateStyles(Data);
  if StyleNo<>rvsDefStyle then
    dec(StyleNo, Data.UsedTextStyles[StyleNo]-1);
end;
{=========================== TRVStoreSubRVData ================================}
{ Must be overriden to return a copy of itself. }
function TRVStoreSubRVData.Duplicate: TRVStoreSubRVData;
begin
  Result := nil;
end;
{------------------------------------------------------------------------------}
{ Compares itself with StoreSub. Self and StoreSub must be of the same item.
  Return value: 0 if the same subdocument, <0 if Self is before StoreSub,
    > 0 if Self is after StoreSub. }
function TRVStoreSubRVData.Compare(StoreSub: TRVStoreSubRVData): Integer;
begin
  Result := 0;
end;
{=========================== TRVMultiDrawItemPart =============================}
function TRVMultiDrawItemPart.GetSoftPageBreakInfo: Integer;
begin
  Result := -1;
end;
{------------------------------------------------------------------------------}
function TRVMultiDrawItemPart.IsComplexSoftPageBreak(
  DrawItem: TRVDrawLineInfo): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVMultiDrawItemPart.AssignSoftPageBreaksToItem(DrawItem: TRVDrawLineInfo;
  Item: TCustomRVItemInfo);
begin

end;
{------------------------------------------------------------------------------}
function TRVMultiDrawItemPart.GetImageHeight: Integer;
begin
  Result := 0;
end;
{============================== TRVTabItemInfo ================================}
procedure TRVTabItemInfo.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
begin
  inherited MarkStylesInUse(Data);
  if TextStyleNo<>rvsDefStyle then
    Data.UsedTextStyles[TextStyleNo] := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.UpdateStyles(Data: TRVDeleteUnusedStylesData);
begin
  inherited UpdateStyles(Data);
  if TextStyleNo<>rvsDefStyle then
    dec(TextStyleNo, Data.UsedTextStyles[TextStyleNo]-1)
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.ApplyStyleConversion(RVData: TPersistent;
  ItemNo, UserData: Integer;
  ConvType: TRVEStyleConversionType);
begin
  TextStyleNo := GetActualStyleNo(TCustomRVData(RVData).GetRVStyle);
  TCustomRVFormattedData(RVData).DoCurrentTextStyleConversion(TextStyleNo, ParaNo,
    ItemNo, UserData, False);
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx; RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpPrintToBMP:
      Result := False;
    rvbpActualPrintSize:
      Result := True;
    else
      Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpDrawingChangesFont, rvbpAlwaysInText, rvbpSwitchToAssStyleNo:
      Result := True;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.OnDocWidthChange(DocWidth: Integer;
  dli: TRVDrawLineInfo; Printing: Boolean; Canvas: TCanvas;
  RVData: TPersistent; sad: PRVScreenAndDevice; var HShift, Desc: Integer;
  NoCaching, Reformatting, UseFormatCanvas: Boolean);
var TextMetric: TTextMetric;
begin
  TCustomRVData(RVData).GetRVStyle.ApplyStyle(Canvas,
    GetActualStyleNo(TCustomRVData(RVData).GetRVStyle), rvbdUnspecified,
    rvflCanUseCustomPPI in TCustomRVData(RVData).Flags, nil, False,
    False);
  TCustomRVData(RVData).GetRVStyle.GraphicInterface.GetTextMetrics(Canvas, TextMetric);
  Desc := TextMetric.tmDescent;
  dli.Height := TextMetric.tmHeight;
  dli.Width := 0;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
  RVFWriteLine(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('%d %d %s %d %d %s %s',
      [StyleNo, 0, RVFItemSavePara(ParaNo, TCustomRVData(RVData), False),
       Byte(ItemOptions) and RVItemOptionsMask,
       0, RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
       SaveRVFHeaderTail(RVData)]));
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.SaveRVFHeaderTail(RVData: TPersistent): TRVRawByteString;
begin
  Result := RVFSaveText(TCustomRVData(RVData).GetRVStyle,
    rvfoUseStyleNames in TCustomRVData(RVData).RVFOptions, TextStyleNo);
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.ReadRVFHeaderTail(var P: PRVAnsiChar; RVData: TPersistent;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  Result := True;
  if not (P^ in [#0, #10, #13]) then begin
    Result := RVFReadTextStyle(TCustomRVData(RVData).GetRVStyle, P, TextStyleNo,
      UTF8Strings, AssStyleNameUsed);
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.DrawTab(Canvas: TCanvas; x, y: Integer;
  dli: TRVDrawLineInfo; Style: TRVStyle; TextDrawState: TRVTextDrawStates;
  CanUseCustomPPI, RTL, SpecialChars, Printing: Boolean;
  ColorMode: TRVColorMode);
  {.........................................}
  procedure DrawArrow(const r: TRect);
  var x,y,len: Integer;
  begin
    len := r.Right-r.Left;
    if len<5 then
      len := 5;
    if len>10 then
      len := 10;
    if not (rvtsSelected in TextDrawState) and (Style.SpecialCharactersColor<>clNone) then
      Canvas.Pen.Color := Style.SpecialCharactersColor
    else
      Canvas.Pen.Color := Canvas.Font.Color;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    x := (R.Right+R.Left+len) div 2;
    y := (R.Top+R.Bottom) div 2;
    Style.GraphicInterface.Line(Canvas, x,y, x-len-1,y);
    if RTL then begin
      x := x-len+1;
      Style.GraphicInterface.Line(Canvas, x,y-1, x,y+2);
      inc(x);
      Style.GraphicInterface.Line(Canvas, x,y-2, x,y+3);
      inc(x);
      Style.GraphicInterface.Line(Canvas, x,y-2, x,y+3);
      end
    else begin
      dec(x);
      Style.GraphicInterface.Line(Canvas, x,y-1, x,y+2);
      dec(x);
      Style.GraphicInterface.Line(Canvas, x,y-2, x,y+3);
      dec(x);
      Style.GraphicInterface.Line(Canvas, x,y-2, x,y+3);
    end;
  end;
  {.........................................}
var w,r, ax,ay: Integer;
    potm: POutlineTextMetric;
    ATextStyleNo, LineWidth: Integer;
    Color: TColor;
begin
  ATextStyleNo := GetActualStyleNo(Style);
  Style.ApplyStyleColor(Canvas, ATextStyleNo, TextDrawState, Printing, ColorMode);
  Style.ApplyStyle(Canvas, ATextStyleNo, rvbdUnspecified, CanUseCustomPPI,
    nil, False, False);
  {
  Canvas.Pen.Style := psSolid;
  Canvas.Pen.Color := clRed;
  Canvas.Pen.Width := 1;
  Canvas.Rectangle(x, y, x+dli.Width, y+dli.Height);
  }
  if (Canvas.Brush.Color<>clNone) and (Canvas.Brush.Style<>bsClear)  then
    Style.GraphicInterface.FillRect(Canvas, Bounds(x, y, dli.Width, dli.Height));
  if ([fsUnderline, fsStrikeOut] * Canvas.Font.Style <> []) or
     (rvfsOverline in Style.TextStyles[ATextStyleNo].StyleEx) or Hidden then begin
    potm := RV_GetOutlineTextMetrics(Canvas, Style.GraphicInterface);
    try
      if (fsUnderline in Canvas.Font.Style) or Hidden then begin
        if (rvtsSelected in TextDrawState) or Hidden then
          Color := Canvas.Font.Color
        else begin
          Color := Style.TextStyles[ATextStyleNo].Color;
          if Style.TextStyles[ATextStyleNo].UnderlineColor<>clNone then
            Color := Style.TextStyles[ATextStyleNo].UnderlineColor;
          if (rvtsHover in TextDrawState) and
             (Style.TextStyles[ATextStyleNo].HoverUnderlineColor<>clNone) then
            Color := Style.TextStyles[ATextStyleNo].HoverUnderlineColor;
        end;
        if potm<>nil then
          if Hidden then
            RVDrawHiddenUnderline(Canvas, Color, x-1, x+dli.Width+1,
              y-potm.otmsUnderscorePosition+potm.otmTextMetrics.tmAscent+
              potm.otmsUnderscoreSize div 2, Style.GraphicInterface)
          else
            RVDrawUnderline(Canvas, Style.TextStyles[ATextStyleNo].UnderlineType,
              Color, x-1, x+dli.Width+1,
              y-potm.otmsUnderscorePosition+potm.otmTextMetrics.tmAscent+
              potm.otmsUnderscoreSize div 2,
              potm.otmsUnderscoreSize, Style.GraphicInterface)
        else
          if Hidden then
            RVDrawHiddenUnderline(Canvas, Color, x-1, x+dli.Width+1,
              y+dli.Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
              Style.GraphicInterface)
          else
            RVDrawUnderline(Canvas, Style.TextStyles[ATextStyleNo].UnderlineType,
              Color, x-1, x+dli.Width+1,
              y+dli.Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
              RVGetDefaultUnderlineWidth(Canvas.Font.Size),
              Style.GraphicInterface);
      end;
      if rvfsOverline in Style.TextStyles[ATextStyleNo].StyleEx then begin
        if potm<>nil then
          LineWidth := potm.otmsUnderscoreSize
        else
          LineWidth := RVGetDefaultUnderlineWidth(Canvas.Font.Size);
          RVDrawUnderline(Canvas, rvutNormal,
            Canvas.Font.Color, x, x+dli.Width,
            y-LineWidth div 2, LineWidth, Style.GraphicInterface)
      end;
      if (fsStrikeOut in Canvas.Font.Style) and (potm<>nil) then begin
        Canvas.Pen.Color := Canvas.Font.Color;
        Canvas.Pen.Style := psInsideFrame;        
        Canvas.Pen.Width := potm.otmsStrikeoutSize;
        w := y-potm.otmsStrikeoutPosition+potm.otmTextMetrics.tmAscent+
          Integer(potm.otmsStrikeoutSize) div 2;
        Style.GraphicInterface.Line(Canvas, x-1, w, x+dli.Width+1, w);
      end;
      Canvas.Pen.Style := psSolid;
    finally
      if potm<>nil then
        FreeMem(potm);
    end;
  end;
  ax := x;
  ay := y;
  if Leader<>'' then begin
    Style.ApplyStyle(Canvas, ATextStyleNo, rvbdUnspecified, CanUseCustomPPI,
      nil, False, False);
    w := Style.GraphicInterface.TextWidth(Canvas, Leader);
    if w=0 then
      exit;
    r := x+dli.Width-w;
    inc(x, w);
    while x+w<=r do begin
      Style.GraphicInterface.TextOut_(Canvas, x, y, PChar(Leader),
        Length(Leader));
      inc(x, w);
    end;
  end;
  if SpecialChars and (rvscTab in RVVisibleSpecialCharacters) then
    DrawArrow(Bounds(ax, ay, dli.Width, dli.Height));  
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
var TextDrawState: TRVTextDrawStates;
begin
  TextDrawState := [];
  if rvidsSelected in State then
    include(TextDrawState, rvtsSelected);
  if rvidsControlFocused in State then
    include(TextDrawState, rvtsControlFocused);
  if rvidsHover in State then
    include(TextDrawState, rvtsHover);
  DrawTab(Canvas, x, y, dli, Style, TextDrawState, rvidsCanUseCustomPPI in State,
    rvidsRTL in State, rvidsShowSpecialCharacters in State, False, rvcmColor);
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer; Preview,
  Correction: Boolean; const sad: TRVScreenAndDevice; RichView: TRVScroller; 
  dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode; RVData: TPersistent);
begin
  DrawTab(Canvas, x, y, dli, TCustomRVData(RVData).GetRVStyle, [],
    rvflCanUseCustomPPI in TCustomRVData(RVData).Flags, False, False, True,
    ColorMode);
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.GetAssociatedTextStyleNo: Integer;
begin
  Result := TextStyleNo;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.SetAssociatedTextStyleNo(Value: Integer);
begin
  TextStyleNo := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVTabItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList; StyleToFont,
  ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v\tab}')
  else
    RVWrite(Stream, '\tab ');
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVTabItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path, imgSavePrefix: String;
  var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
var SpacesInTab: Integer;
    Filler: TRVAnsiString;
    Len: Integer;
begin
  SpacesInTab := TCustomRVData(RVData).GetRVStyle.SpacesInTab;
  if SpacesInTab<=0 then
    SpacesInTab := 8;
  if Leader='' then begin
    Filler := ' &nbsp;';
    Len := 2;
    end
  else begin
    Filler := RV_MakeHTMLStr(
      StringToHTMLString(Leader, SaveOptions, TCustomRVData(RVData).GetRVStyle),
      False, TCustomRVData(RVData).NextItemFromSpace(ItemNo));
    Len := Length(Leader);
  end;
  if Hidden and UseCSS then
    RVFWrite(Stream, '<span style="{display : none}">');
  SpacesInTab := (SpacesInTab+Len-1) div Len;
  while SpacesInTab<>0 do begin
    RVFWrite(Stream, Filler);
    dec(SpacesInTab);
  end;
  if Hidden and UseCSS then
    RVFWrite(Stream, '</span>');  
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVTabItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String;
  TextOnly, Unicode: Boolean): TRVRawByteString;
begin
  Result := #09;
end;
{------------------------------------------------------------------------------}
function TRVTabItemInfo.GetActualStyleNo(RVStyle: TRVStyle): Integer;
begin
  Result := TextStyleNo;
  if Result = rvsDefStyle then
    if RVStyle.ParaStyles[ParaNo].DefStyleNo>=0 then
      Result := RVStyle.ParaStyles[ParaNo].DefStyleNo
    else
      Result := 0;
end;
{================================== TRVItemList ===============================}
procedure TRVItemList.AddObject(const ItemText: TRVRawByteString;
  Item: TCustomRVItemInfo);
begin
   Item.ItemText := ItemText;
   Add(Item);
end;
{------------------------------------------------------------------------------}
procedure TRVItemList.InsertObject(Index: Integer;
  const ItemText: TRVRawByteString; Item: TCustomRVItemInfo);
begin
   Item.ItemText := ItemText;
   Insert(Index, Item);
end;
{------------------------------------------------------------------------------}
function TRVItemList.IndexOfObject(Item: TCustomRVItemInfo): Integer;
begin
   Result := inherited IndexOf(Item);
end;
{------------------------------------------------------------------------------}
function TRVItemList.GetItem(Index: Integer): TRVRawByteString;
begin
  Result := TCustomRVItemInfo(inherited Get(Index)).ItemText;
end;
{------------------------------------------------------------------------------}
function TRVItemList.GetObject(Index: Integer): TCustomRVItemInfo;
begin
  Result := TCustomRVItemInfo(inherited Get(Index));
end;
{------------------------------------------------------------------------------}
procedure TRVItemList.SetItem(Index: Integer; const Value: TRVRawByteString);
begin
  TCustomRVItemInfo(inherited Get(Index)).ItemText := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVItemList.SetObject(Index: Integer; const Value: TCustomRVItemInfo);
begin
  inherited Put(Index, Value);
end;
{==============================================================================}

initialization
  RichView_InitializeList;
  RichViewTextItemClass := TRVTextItemInfo;
finalization
  RichView_FinalizeList;

end.