{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVStyle: settings and formatting for           }
{       RichView.                                       }
{       (registered on "RichView" page of               }
{       the Component Palette)                          }
{       Declarations of types used elsewhere.           }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVStyle;

interface
{$R RVStyle}
{$I RV_Defs.inc}

{$IFDEF RICHVIEWDEF6}
{$WARN SYMBOL_DEPRECATED OFF}
{$ENDIF}
uses
  {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  {$IFNDEF RVDONOTUSEINI}
  IniFiles, Registry,
  {$ENDIF}
  {$IFDEF RICHVIEWDEF4}
  ImgList,
  {$ENDIF}
  RVClasses, RVMapWht, RVScroll, RVTypes, RVGrIn, RVWinGrIn;

{$IFDEF RVNORANGECHECK}
{$R-}
{$ENDIF}  

 {---------------------------------------------------------------------------- }
 
const

  { Cursors }
  crJump = 101; // hand point, used as a default value for TRVStyle.JumpCursor
                // property
  crRVFlipArrow = 106; // arrow to top right, used as a default value for
                // TRVStyle.LineSelectCursor property

  { Indices for TRVStyle.TextStyles in its default state }
  rvsNormal     = 0;
  rvsHeading    = 1;
  rvsSubheading = 2;
  rvsKeyword    = 3;
  rvsJump1      = 4;
  rvsJump2      = 5;

  { Standard item types (styles) }
  rvsBreak      = -1; // "break" - horizontal line
  rvsCheckpoint = -2; // "checkpoint" (not an item, for internal use)
  rvsPicture    = -3; // picture (in class inherited from TGraphic)
  rvsHotspot    = -4; // "hotspot": hypertext image from image-list
  rvsComponent  = -5; // component (inherited from TControl)
  rvsBullet     = -6; // "bullet": image from image-list
  rvsBack       = -7; // background (not an item)
  rvsVersionInfo= -8; // version info (not an item, for internal use)
  rvsDocProperty= -9; // document property (not an item, for internal use)
  rvsHotPicture = -10; // "hot picture": hypertext picture
  rvsListMarker = -11; // list marker (paragraph bullet/numbering)
  rvsTab        = -12; // tab character

  LAST_DEFAULT_STYLE_NO = rvsJump2;

  { constant used for representing default text style for paragraph }
  rvsDefStyle = MaxInt;

  DEFAULT_FLOATINGLINECOLOR = $BDA28A;

 {---------------------------------------------------------------------------- }

type
  { Structure containing information for resolutions of screen and some
    device, for internal use }
  TRVScreenAndDevice = record
       ppixScreen, ppiyScreen, ppixDevice, ppiyDevice: Integer;
       LeftMargin, RightMargin: Integer;
   end;
  PRVScreenAndDevice= ^TRVScreenAndDevice;

  { Effects under the mouse pointer (not including color change) }
  TRVHoverEffect = (rvheUnderline);
  TRVHoverEffects = set of TRVHoverEffect;

  TParaInfo = class;

  { Saving format }
  TRVSaveFormat = (rvsfText, rvsfHTML, rvsfRTF, rvsfRVF);
  { Loading format }
  TRVLoadFormat = (rvlfText, rvlfHTML { not implemented }, rvlfRTF, rvlfRVF,
    rvlfURL, rvlfOther);

  { Part of RTF file, used in TCustomRichView.OnSaveRTFExtra }
  TRVRTFSaveArea = (
    rv_rtfs_TextStyle, // in character attributes
    rv_rtfs_ParaStyle, // in paragraph attributes
    rv_rtfs_ListStyle, // in list attributes
    rv_rtfs_CellProps, // in table cell
    rv_rtfs_RowProps,  // in table row
    rv_rtfs_Doc);      // at the beginning of document
  { Part of HTML file, used in TCustomRichView.OnSaveHTMLExtra }
  TRVHTMLSaveArea = (
    rv_thms_Head,      // <HEAD>*</HEAD>
    rv_thms_BodyAttribute, // <BODY *>
    rv_thms_Body,      // <BODY>*
    rv_thms_End       // *</BODY>
    );  

  { Values for TCustomRichView.RTFReadProperties.UnicodeMode }
  TRVReaderUnicode = (
    rvruMixed,         // Use ANSI text as possible, Unicode if necessary
    rvruNoUnicode,     // Use only ANSI text, ignore Unicode in RTF
    rvruOnlyUnicode);  // Use Unicode text, convert all text from RTF to Unicode

  { Values for TCustomRichView.RTFReadProperties.TextStyleMode and
    .ParaStyleMode }
  TRVReaderStyleMode = (
    rvrsUseSpecified,  // Use the specified style
                       // (TCustomRichView.RTFReadProperties.TextStyleNo or
                       // .ParaStyleNo)
    rvrsUseClosest,    // Use the most similar of existing styles, do not
                       // modify collection of styles
    rvrsAddIfNeeded);  // Add new styles if necessary (result is the most
                       // similar to the original RTF

  { Values for TCustomRichView.RVFTextStylesReadMode and
    .RVFParaStylesReadMode }
  TRVFReaderStyleMode = (
    rvf_sIgnore,       // Ignore styles in RVF.
    rvf_sInsertMap,    // RVF loading: styles from RVF replace previous styles.
                       // RVF inserting: use the most similar of existing
                       // styles, do not modify collection of styles.
    rvf_sInsertMerge); // RVF loading: styles from RVF replace previous styles.
                       // RVF inserting: add new styles if necessary

  { Values for TCustomRVPrint.ColorMode }
  TRVColorMode = (
    rvcmColor,         // Colors are not changed
    rvcmPrinterColor,  // Colors are not changed, except for some system colors
                       // converted to black and white
    rvcmGrayScale,     // Colors are converted to shades of gray
    rvcmBlackAndWhite, // Colors are converted to black and white
    rvcmBlackOnWhite); // Black text on white background

  { Code page, for example TRVStyle.DefCodePage }
  TRVCodePage = type cardinal;

  { Background style of item (for example, of table or table cell }
  TRVItemBackgroundStyle = (
    rvbsColor,         // no image
    rvbsStretched,     // stretched image
    rvbsTiled,         // tiled image
    rvbsCentered);     // image in center

  { Type of script for text }
  TRVSubSuperScriptType = (
    rvsssNormal,       // normal text
    rvsssSubscript,    // subscript
    rvsssSuperScript); // superscript

  { Underline type }
  TRVUnderlineType = (rvutNormal, rvutThick, rvutDouble,
    rvutDotted, rvutThickDotted,
    rvutDashed, rvutThickDashed,
    rvutLongDashed, rvutThickLongDashed,
    rvutDashDotted, rvutThickDashDotted,
    rvutDashDotDotted, rvutThickDashDotDotted);

  { Reference to information about "checkpoint" }
  TCheckpointData = type Pointer;

  TRVStyle = class;

  { Text properties, used in TRVStyle.OnDrawStyleText }
  TRVTextDrawState = (
    rvtsSelected,      // selected
    rvtsHover,         // under mouse
    rvtsItemStart,     // starting item
    rvtsItemEnd,       // ending item
    rvtsDrawItemStart, // starting drawing item
    rvtsDrawItemEnd,   // ending drawing item
    rvtsControlFocused, // set if TRichView has input focus
    rvtsSpecialCharacters, // display dots in spaces
    rvtstControlDisabled);     // the control is disabled

  TRVTextDrawStates = set of TRVTextDrawState;

  { Type of page break }
  TRVPageBreakType = (
  rvpbSoftPageBreak,   // "soft" page break (created automatically)
  rvpbPageBreak);      // page break set by user

  { Visual style of "break" (horizontal line), not used }
  TRVBreakStyle =
    (rvbsLine,          // line of the given width
     rvbsRectangle,     // rectangle of the given height (border width=1)
     rvbs3d,            // sunken rectangle of the given height (border width=1)
     rvbsDotted,        // dotted line of the given width (line of circles w x w)
     rvbsDashed);       // dashed line of the given width (line of rectanges 2w x w)

  { Vertical alignment of item }
  TRVVAlign = (
    rvvaBaseline,      // bottom of picture -> baseline
    rvvaMiddle,        // center of picture -> baseline
    rvvaAbsTop,        // top of picture    -> top of line
    rvvaAbsBottom,     // bottom of picture -> bottom of line
    rvvaAbsMiddle,     // center of picture -> center of line
    rvvaLeft,          // align to left side (floating)
    rvvaRight          // align to right side (floating)
    );

  { Types of paragraph border, TParaInfo.Border.Style }
  TRVBorderStyle = (rvbNone, rvbSingle, rvbDouble, rvbTriple,
    rvbThickInside, rvbThickOutside);

  { Sequence type. Type TRVStyle.FootnoteNumbering and EndnoteNumbering,
    see also RVSeqItem unit. }
  TRVSeqType = (rvseqDecimal, rvseqLowerAlpha, rvseqUpperAlpha, rvseqLowerRoman,
    rvseqUpperRoman);

  { Paragraph list type, TRVListLevel.ListType property }
  TRVListType = (rvlstBullet, rvlstPicture, rvlstImageList,
    rvlstDecimal, rvlstLowerAlpha, rvlstUpperAlpha, rvlstLowerRoman,
    rvlstUpperRoman, rvlstImageListCounter
    {$IFNDEF RVDONOTUSEUNICODE}
    ,rvlstUnicodeBullet
    {$ENDIF});

  { Alignment of paragraph marker, TRVListLevel.MarkerAlignment property }
  TRVMarkerAlignment = (rvmaLeft, rvmaRight, rvmaCenter);

  { Options for paragraph bullets/numbering, TRVListLevel.Options }
  TRVListLevelOption = (
    rvloContinuous, // (reserved for future use, must always be set)
    rvloLevelReset, // Reset numbering on each level - normal behavior
    rvloLegalStyleNumbering); // Use decimal representation of numbering of
                    // other levels
  TRVListLevelOptions = set of TRVListLevelOption;

  TRVMarkerFormatString = type String;

  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWCBDEF3}
  TRVMarkerFormatStringW = type TRVUnicodeString;
  {$ENDIF}
  {$ENDIF}

  { Options for saving/loading RVF files/streams }
  TRVFOption = (
    rvfoSavePicturesBody, // Save pictures (if not set - images are requested
                          // in event)
    rvfoSaveControlsBody, // Save controls (if not set - controls are
                          // requested in event)
    rvfoIgnoreUnknownPicFmt, // Ignore pictures of unknown types
                             // (if not set - report error)
    rvfoIgnoreUnknownCtrls,  // Ignore controls of unknown types
                             // (if not set - report error)
    rvfoIgnoreUnknownCtrlProperties, // Ignore error when reading properties
                             // of inserted controls (if not set - report error)
    rvfoConvUnknownStylesToZero, // Convert unknown text, paragraph or list
                                 // styles to 0-th styke (if not set - report error)
    rvfoConvLargeImageIdxToZero, // Convert too large image indices in "bullets"
                                 // and "hotspots" to 0 (if not set - report error)
    rvfoSaveBinary,       // Binary RVF saving mode
    rvfoUseStyleNames,    // (Obsolete)
    rvfoSaveBack,         // Save background
    rvfoLoadBack,         // Load background
    rvfoSaveTextStyles,   // Save collection of text styles (RVStyle.TextStyles)
    rvfoSaveParaStyles,   // Save collections of paragraph and list styles
                          // (RVStyle.ParaStyles and .ListStyles)
    rvfoSaveLayout,       // Save layout properties (margins, etc.)
    rvfoLoadLayout,       // Load layout properties
    rvfoSaveDocProperties,// Save DocProperties stringlist and DocParameters
    rvfoLoadDocProperties, // Load DocProperties stringlist and DocParameters
    rvfoCanChangeUnits    // Allows changing units to Units from RVF
    );
  TRVFOptions = set of TRVFOption;

  { Operation, see TRichView.OnProgress event. }
  TRVLongOperation = (
    rvloLoading,          // Saving
    rvloConverting);      // Not used by the component. Allows to call


  { Operation progress, see TRichView.OnProgress event. }
  TRVProgressStage = (
    rvpstgStarting,       // The operation is about to begin
    rvpstgRunning,        // The operation is underway and has not yet completed
    rvpstgEnding);        // The operation has just completed


  { Warnings for loading RVF files/streams }
  TRVFWarning = (
    rvfwUnknownPicFmt, // Picture of unknown/unregistered type (use RegisterClass)
    rvfwUnknownCtrls,  // Control of unknown/unregistered type (use RegisterClass)
    rvfwConvUnknownStyles, // Invalid index of text/paragraph/list style
    rvfwConvLargeImageIdx, // Invalid image index in "bullet" or "hotspot"
    rvfwConvToUnicode,     // Mismatched Unicode/ANSI type of text
                           // (was converted to Unicode)
    rvfwConvFromUnicode,   // Mismatched Unicode/ANSI type of text
                           // (was converted to ANSI)
    rvfwInvalidPicture, // Invalid picture data (was replaced with
                         // RVStyle.InvalidPicture.Graphic)
    rvfwUnknownStyleProperties, // Unknown properties of items in the collections
                           // of text/paragraph/lists. Probably, RVF was saved with
                           // newer version of component
    rvfwUnknownCtrlProperties, // Unknown properties of controls
    rvfwConvUnits);      // Units of measurement were converted
  TRVFWarnings = set of TRVFWarning;

  { Action with controls inserted in TRichView, parameter of
    TCustomRichView.OnControlAction }
  TRVControlAction = (
    rvcaAfterRVFLoad,      // Control is loaded from RVF file or stream
    rvcaDestroy,           // Control is being destroyed (in TCustomRichView)
    rvcaMoveToUndoList,    // Control is moved from editor to undo/redo buffer
    rvcaMoveFromUndoList,  // Control is moved from undo/redo buffer back to editor
    rvcaDestroyInUndoList, // Control is being destroyed (in undo buffer)
    rvcaBeforeRVFSave,     // Before saving control to RVF file or stream
    rvcaAfterRVFSave);     // After saving control to RVF file or stream

  { Action with items, parameter of TCustomRichView.OnItemAction }
  TRVItemAction = (
    rviaInserting,         // Before insertion in TCustomRichView
    rviaInserted,          // After insertion in TCustomRichView
    rviaTextModifying,     // Text of item is being modified as a result of
                           // editing operation
    rviaDestroying,        // Item is being destroyed
    rviaMovingToUndoList); // Item is moved to undo/redo buffer

  { Options for protected text, TFontInfo.Protection property }
  TRVProtectOption = (
    rvprStyleProtect,   // Protect from ApplyTextStyle
    rvprStyleSplitProtect, // Protects from applying style to the part of item
    rvprModifyProtect,  // Protect from text modifying (but not from
                        // deletion as a whole)
    rvprDeleteProtect,  // Protect from deletion as a whole
    rvprConcateProtect, // Protect from concatenation with adjacent text
    rvprRVFInsertProtect, // Protect from insertion from RVF
    rvprDoNotAutoSwitch, // TCustomRichViewEdit.CurTextStyleNo will never
                        // be set to the text of this style automatically
    rvprParaStartProtect, // (See the help file)
    rvprSticking,       // Disallows inserting between protected (by rvprSticking) text items
    rvprSticking2,      // Disallows inserting between protected (by rvprSticking2) text items
    rvprSticking3,      // Disallows inserting between protected (by rvprSticking3) text items    
    rvprStickToTop,     // If this text is at the beginning, disallow inserting
                        // before it
    rvprStickToBottom); // If this text is at the end, disallow inserting
                        // after it
  TRVProtectOptions = set of TRVProtectOption;

  { Options for paragraph styles, TParaInfo.Options property }
  TRVParaOption = (
    rvpaoNoWrap,         // Disallow word wrapping
    rvpaoReadOnly,       // Disallow changes in paragraph (but it can be deleted
                         // as a whole
    rvpaoStyleProtect,   // Protect from ApplyParaStyle
    rvpaoDoNotWantReturns, // Ignore ENTER key
    rvpaoKeepLinesTogether, // Print the whole paragraph on one page, if possible
    rvpaoKeepWithNext, // Print this paragraph on the same page as the next one
    rvpaoWidowOrphanControl); // reserved
  TRVParaOptions = set of TRVParaOption;

  { Options for text styles, TTextInfo.Options property }
  TRVTextOption = (
    rvteoHTMLCode,  // Save text to HTML as is
    rvteoRTFCode,   // Save text to RTF as is
    rvteoHidden);   // Hidden text
  TRVTextOptions = set of TRVTextOption;

  { Options for saving HTML files, TCustomRichView.SaveHTML and SaveHTMLEx methods }
  TRVSaveOption = (
    rvsoOverrideImages, // Overwrite image files (if not set - use unique)
    rvsoFirstOnly,      // Save only heading part of HTML
    rvsoMiddleOnly,     // Save only middle part of HTML (document itself)
    rvsoLastOnly,       // Save only ending part of HTML
    rvsoDefault0Style,  // Do not save properties for the 0-th text style
    rvsoNoHypertextImageBorders, // Supress borders for hypertext images
    rvsoImageSizes,     // Write image size
    rvsoForceNonTextCSS,// Always use CSS for non-text items
    rvsoUseCheckpointsNames, // Use "checkpoint names" instead of indices
    rvsoMarkersAsText,  // Save paragraph bullets/numbering without <UL>/<OL>
    rvsoInlineCSS,      // Write CSS directly in <P> and <SPAN> tags
                        //   (only for SaveHTMLEx)
    rvsoNoDefCSSStyle,  // Use named CSS for all text styles, even for
                        //   TextStyles[0] (by default, properties of
                        //   TextStyles[0] are assigned to BODY and TABLE).
                        //   This option generates larger HTML (not recommended).
                        //   (only for SaveHTMLEx)
    rvsoUseItemImageFileNames, // If set, images having specified
                        //   (in extra string properties) file names will not
                        //   be saved, but their file names will be written
                        //   in HTML (relative to the HTML file path)
    rvsoXHTML,          // Save XHTML
    rvsoUTF8);          // Use UTF8 encoding
  TRVSaveOptions = set of TRVSaveOption;

  { Options for saving RTF files, TCustomRichView.RTFOptions }
  TRVRTFOption = (
    rvrtfSaveStyleSheet,    // Save style sheet
    rvrtfDuplicateUnicode,  // Save optional ANSI representation of Unicode text
    rvrtfSaveEMFAsWMF,      // Save 32-bit metafiles as 16-bit metafiles
                            //   (more compatible RTF)
    rvrtfSaveJpegAsJpeg,    // Save TJpegImage as jpeg (less compatible RTF)
    rvrtfSaveBitmapDefault, // Save "exotic" picture types as bitmaps (if not
                            //   set - as metafiles)
    rvrtfSaveEMFDefault,    // Save "exotic" picture types as 32-bit metafiles
    rvrtfSavePicturesBinary, // Use binary mode for picture saving
    rvrtfPNGInsteadOfBitmap, // Saves all bitmaps (and other pictures,
                             //   if rvrtfSaveBitmapDefault is included) as PNG
    rvrtfSaveDocParameters, // Save DocParameters properties
    rvrtfSaveHeaderFooter);
  TRVRTFOptions = set of TRVRTFOption;

  { Advanced font styles, TFontInfo.StyleEx }
  TRVFontStyle = (
    rvfsOverline,   // Line above text
    rvfsAllCaps    // All capitals
    );
  TRVFontStyles = set of TRVFontStyle;

  { Paragraph alignment, TParaInfo.Alignment }
  TRVAlignment = (rvaLeft, rvaRight, rvaCenter, rvaJustify);

  { Measuring units, used in TCustomRichView.DocParameters }
  TRVUnits = (
    rvuInches,
    rvuCentimeters,
    rvuMillimeters,
    rvuPicas,
    rvuPixels,
    rvuPoints);
  {$IFDEF RICHVIEWDEF4}
  {$HPPEMIT 'typedef Extended TRVLength;'}
  {$ENDIF}
  TRVLength = type Extended;

  { Line wrapping modes }
  TRVLineWrapMode = (
     rvWrapAnywhere, // wrap in any place
     rvWrapSimple,   // process each text item separately (faster)
     rvWrapNormal);  // advanced line wrapping

  TRVExtraFontInfo = record
    ScriptHeight: Integer;
  end;
  PRVExtraFontInfo = ^TRVExtraFontInfo;

{$IFNDEF RVDONOTUSEINI}
{$IFDEF RICHVIEWDEF4}
  TRVIniFile = Inifiles.TCustomIniFile;
{$ELSE}
  TRVIniFile = TIniFile;
{$ENDIF}
{$ENDIF}

  { Parameters of TRVStyle.SaveCSS }
  TRVSaveCSSOption = (
    rvcssOnlyDifference,      // do not use
    rvcssIgnoreLeftAlignment, // do not use
    rvcssNoDefCSSStyle,       // see rvsoNoDefCSSStyle
    rvcssUTF8,                // convert font names to UTF8
    rvcssDefault0Style);
  TRVSaveCSSOptions = set of TRVSaveCSSOption;

  { Enumeration of properties of TFontInfo }
  TRVFontInfoProperty = (
    rvfiFontName, rvfiSize, rvfiCharset, rvfiUnicode,
    rvfiBold, rvfiItalic, rvfiUnderline, rvfiStrikeout,
    rvfiOverline, rvfiAllCaps, rvfiSubSuperScriptType,
    rvfiVShift, rvfiColor, rvfiBackColor,
    rvfiJump, rvfiHoverBackColor, rvfiHoverColor, rvfiHoverUnderline,
    rvfiJumpCursor,
    rvfiNextStyleNo, rvfiProtection, rvfiCharScale, rvfiBaseStyleNo,
    rvfiBiDiMode, rvfiCharSpacing, rvfiHTMLCode, rvfiRTFCode, rvfiHidden,
    {$IFDEF RVLANGUAGEPROPERTY}
    rvfiLanguage,
    {$ENDIF}
    rvfiUnderlineType, rvfiUnderlineColor, rvfiHoverUnderlineColor,
    rvfiCustom);

  { Enumeration of properies of TParaInfo }
  TRVParaInfoProperty = (
    rvpiFirstIndent, rvpiLeftIndent, rvpiRightIndent,
    rvpiSpaceBefore, rvpiSpaceAfter, rvpiAlignment,
    rvpiNextParaNo, rvpiDefStyleNo, rvpiLineSpacing, rvpiLineSpacingType,
    rvpiBackground_Color,
    rvpiBackground_BO_Left, rvpiBackground_BO_Top,
    rvpiBackground_BO_Right, rvpiBackground_BO_Bottom,
    rvpiBorder_Color, rvpiBorder_Style,
    rvpiBorder_Width, rvpiBorder_InternalWidth,
    rvpiBorder_BO_Left, rvpiBorder_BO_Top,
    rvpiBorder_BO_Right, rvpiBorder_BO_Bottom,
    rvpiBorder_Vis_Left, rvpiBorder_Vis_Top,
    rvpiBorder_Vis_Right, rvpiBorder_Vis_Bottom,
    rvpiNoWrap, rvpiReadOnly, rvpiStyleProtect, rvpiDoNotWantReturns,
    rvpiKeepLinesTogether, rvpiKeepWithNext, rvpiTabs,
    rvpiBiDiMode, rvpiOutlineLevel, rvpiCustom);

  TRVParaInfoProperty1 = rvpiFirstIndent..rvpiBorder_Vis_Bottom;
  TRVParaInfoProperty2 = rvpiNoWrap..rvpiOutlineLevel;

  TRVFontInfoProperty1 = rvfiFontName..rvfiJumpCursor;
  TRVFontInfoProperty2 = rvfiNextStyleNo..rvfiHoverUnderlineColor;

  TRVFontInfoProperties = set of TRVFontInfoProperty;
  TRVParaInfoProperties = set of TRVParaInfoProperty;
  TRVParaInfoProperties1 = set of TRVParaInfoProperty1;
  TRVParaInfoProperties2 = set of TRVParaInfoProperty2;
  TRVFontInfoProperties1 = set of TRVFontInfoProperty1;
  TRVFontInfoProperties2 = set of TRVFontInfoProperty2;

  { Type of line spacing, TParaInfo.LineSpacingType }
  TRVLineSpacingType = (
    rvlsPercent,        // TParaInfo.LineSpacing specifies spacing in percents
    rvlsSpaceBetween,   // ... in RVStyle.Units
    rvlsLineHeightAtLeast, // ... in RVStyle.Units
    rvlsLineHeightExact);  // ... in RVStyle.Units

  { Type for value of line spacing, TParaInfo.LineSpacing }
  TRVLineSpacingValue = type Integer;

  { Mode of merging collections of styles, for internal use }
  TRVStyleMergeMode = (
    rvs_merge_SmartMerge, // Reuse styles, add if necessary
    rvs_merge_Map,        // Use the most similar of existing styles. Do not add styles
    rvs_merge_Append);    // Append one collection to another

  { Text selection mode }
  TRVSelectionMode = (
    rvsmChar,       // Select by characters
    rvsmWord,       // Select by word
    rvsmParagraph); // Select by paragraphs

  { Text selection style }
  TRVSelectionStyle = (
    rvssItems,      // Highlighted items
    rvssLines);     // Highlighted lines (like in Word). Not supported,
                    // if BiDiMode<>rvbdUnspecified

  { Tab alignment (relative to text after the tab) }
  TRVTabAlign = ( rvtaLeft, rvtaRight, rvtaCenter );

  { Type for TRVStyleTemplate.Id and references to it }
  TRVStyleTemplateId = type Integer;
  { Type for TRVStyleTemplate.Name }
  TRVStyleTemplateName = type String;

  { Characters shown in "show special characters" mode.
    Type of RVVisibleSpecialCharacters variable }
  TRVSpecialCharacter = (rvscSpace, rvscNBSP, rvscTab, rvscParagraph, rvscSoftHyphen,
    rvscParagraphAttrs, rvcFloatingLines);
  TRVSpecialCharacters = set of TRVSpecialCharacter;

  { Characters to show as paragraph marks in "show special characters" mode }
  TRVParagraphMarks =
    (rvpmStandard,  // pilcrow for paragraph break, bended arrow for line break
     rvpmArrows);   // bended arrow for paragraph break, arrow down for line break


  { Field highlighting type, TRVStyle.FieldHighlightType }
  TRVFieldHighlightType = (
    rvfhNever,   // fields are not highlighted
    rvfhCurrent, // field at the position of caret is highlighted
    rvfhAlways); // fields are always highlighted

  { Measuring units for properties of RVStyle, TRVStyle.Units }
  TRVStyleUnits =
    (rvstuPixels, // pixels
     rvstuTwips); // twips
  PRVStyleUnits = ^TRVStyleUnits;
  { Value measured in TRVStyleUnits }
  TRVStyleLength = type Integer;

  { --------------------- Types for events of TRVStyle ----------------------- }
  TRVDrawTextBackEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    StyleNo: Integer; Left, Top, Width, Height: Integer;
    DrawState: TRVTextDrawStates; var DoDefault: Boolean) of object;

  TRVApplyStyleEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    StyleNo: Integer; var DoDefault: Boolean) of object;

  TRVAfterApplyStyleEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    StyleNo: Integer) of object;

  TRVApplyStyleColorEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    StyleNo: Integer; DrawState: TRVTextDrawStates;
    var DoDefault: Boolean) of object;

  TRVDrawStyleTextEvent = procedure (Sender: TRVStyle; const s: TRVRawByteString;
    Canvas: TCanvas; StyleNo: Integer; SpaceBefore,
    Left, Top, Width, Height: Integer;
    DrawState: TRVTextDrawStates; var DoDefault: Boolean) of object;

  TRVStyleHoverSensitiveEvent = procedure (Sender: TRVStyle; StyleNo: Integer;
    var Sensitive: Boolean) of object;

  TRVDrawCheckpointEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    X,Y, ItemNo, XShift: Integer; RaiseEvent: Boolean; Control: TControl;
    var DoDefault: Boolean) of object;

  TRVDrawPageBreakEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    Y, XShift: Integer; PageBreakType: TRVPageBreakType; Control: TControl;
    var DoDefault: Boolean) of object;

  TRVDrawParaRectEvent = procedure (Sender: TRVStyle; Canvas: TCanvas;
    ParaNo: Integer; ARect: TRect; var DoDefault: Boolean) of object;

  TRVGetGraphicInterfaceEvent = procedure (Sender: TRVStyle;
    var GraphicInterface: TRVGraphicInterface) of object;

  { ---------------------------------------------------------------------------
    TCustomRVInfo: ancestor class for text, paragraph and list styles
    (TFontInfo, TParaInfo, TRVListInfo)
    Properties:
    - BaseStyleNo - index of base style (reserved for future use)
    - StyleName   - name of style
    - Standard    - if True, this is a "real" style; if False, this style
                    represents formatting and can be deleted by
                    TCustomRichView.DeleteUnusedStyles
    - StyleTemplateId - id of TRVStyle.StyleTemplates collection item,
                    or value <= 0 for no style template.
  }
  TCustomRVInfo = class(TCollectionItem)
    private
      FBaseStyleNo: Integer;
      FName: String;
      FStandard: Boolean;
      {$IFNDEF RVDONOTUSESTYLETEMPLATES}
      FStyleTemplateId: TRVStyleTemplateId;
      {$ENDIF}
    protected
      function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
        IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; dynamic;
      function IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean; dynamic;
      function SimilarityValue(Value: TCustomRVInfo): Integer; dynamic;
    public
      constructor Create(Collection: TCollection); override;
      procedure Assign(Source: TPersistent); override;
      {$IFDEF RICHVIEWCBDEF3}
      function GetDisplayName: String; override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs, DefName: String);
      {$ENDIF}
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits); dynamic; abstract;
      function GetRVStyle: TRVStyle; virtual;
    published
      property BaseStyleNo: Integer read FBaseStyleNo write FBaseStyleNo default -1;
      property StyleName: String    read FName        write FName;
      property Standard: Boolean    read FStandard    write FStandard default True;
      {$IFNDEF RVDONOTUSESTYLETEMPLATES}
      property StyleTemplateId: TRVStyleTemplateId read FStyleTemplateId write FStyleTemplateId default -1;
      {$ENDIF}
  end;
  { ---------------------------------------------------------------------------
    TCustomRVFontInfo: ancestor of TFontInfo and TRVSTFontInfo
    Properties:
    - Charset, FontName, Size, Style, Color - see properties for TFont
      (FontName = Name)
    - VShift - vertical offet of text, % of text height.
      Positive values - up, negative values - down.
    - BackColor - color of text background, clNone for transparent
    - HoverBackColor - color of text background under mouse (only for hypertext),
      clNone for no effect
    - HoverColor - color of text under mouse (only for hypertext), clNone to
      use TRVStyle.HoverColor
    - HoverEffects - other effects under mouse
    -  StyleEx - advanced visual text styles, see TRVFontStyles
    - Jump - if true, this text is a hypertext
    - JumpCursor - cursor for hypertext
    - CharScale - horizontal character scale value, %
    - CharSpacing - spacing between characters, pixels
    - BiDiMode - bi-di mode of text
    - Language - text language (enabled by RVLANGUAGEPROPERTY compiler define)
    - Protection - protection options, see TRVProtectOptions
    - Options - see TRVTextOptions
    - SubSuperScriptType - normal/subscript/superscript
    - UnderlineType - style of underline, if fsUnderline is in Style
    - UnderlineColor - color of underline, clNone for default color
    - HoverUnderlineColor - color of underline under mouse, clNone for the
      same color as UnderlineColor
  }
  TCustomRVFontInfo = class(TCustomRVInfo)
  private
    { Private declarations }
    FBiDiMode: TRVBiDiMode;
    FJump: Boolean;
    FJumpCursor: TCursor;
    FFontName: TFontName;
    FSize: Integer;
    FColor, FBackColor, FHoverColor, FHoverBackColor,
    FUnderlineColor, FHoverUnderlineColor: TColor;
    FUnderlineType: TRVUnderlineType;
    FHoverEffects: TRVHoverEffects;
    FStyle: TFontStyles;
    FStyleEx: TRVFontStyles;
    FVShift: Integer;
    {$IFDEF RICHVIEWCBDEF3}
    FCharset: TFontCharset;
    {$ENDIF}
    {$IFDEF RVLANGUAGEPROPERTY}
    FLanguage: Cardinal;
    {$ENDIF}
    FProtection: TRVProtectOptions;
    FOptions: TRVTextOptions;
    FCharScale: Integer;
    FCharSpacing: TRVStyleLength;
    FSubSuperScriptType: TRVSubSuperScriptType;
    procedure SingleSymbolsReader(reader: TReader);
  protected
    procedure DefineProperties(Filer: TFiler);override;
    function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; override;
    function SimilarityValue(Value: TCustomRVInfo): Integer; override;
    function GetScriptHeight(Canvas: TCanvas; GraphicInterface: TRVGraphicInterface): Integer;
  public
    { Public declarations }
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignTo(Dest: TPersistent); override;
    procedure AssignSelectedProperties(Source: TCustomRVFontInfo; Props: TRVFontInfoProperties);
    procedure AssignToLogFont(var LogFont: TLogFont; Canvas: TCanvas;
      CanUseCustomPPI: Boolean; ExcludeUnderline, ToFormatCanvas: Boolean);
    procedure Apply(Canvas: TCanvas; DefBiDiMode: TRVBiDiMode;
      CanUseCustomPPI: Boolean; ExtraFontInfo: PRVExtraFontInfo;
      IgnoreSubSuperScript, ToFormatCanvas: Boolean;
      GraphicInterface: TRVGraphicInterface);
    procedure ApplyBiDiMode(Canvas: TCanvas; DefBiDiMode: TRVBiDiMode;
      ToFormatCanvas: Boolean; GraphicInterface: TRVGraphicInterface);
    procedure ApplyColor(Canvas: TCanvas; RVStyle: TRVStyle;
      DrawState: TRVTextDrawStates; Printing: Boolean; ColorMode: TRVColorMode);
    function IsEqual(Value: TCustomRVFontInfo; IgnoreList: TRVFontInfoProperties): Boolean; dynamic;
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String); dynamic;
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String;
      JumpByDefault: Boolean; DefJumpCursor: TCursor); dynamic;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEHTML}
    procedure SaveCSSToStream(Stream: TStream; BaseStyle: TCustomRVFontInfo;
      Multiline, UTF8: Boolean);
    {$ENDIF}
    {$IFNDEF RVDONOTUSERTF}
    procedure SaveRTFToStream(Stream: TStream; StyleNo: Integer;
      TwipsPerPixel: Double; StyleToFont, ColorTable: TRVIntegerList);
    {$ENDIF}
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits); override;
   published
    { Published declarations }
    {$IFDEF RICHVIEWCBDEF3}
    property Charset: TFontCharset read FCharset write FCharset
      default DEFAULT_CHARSET;
    {$ENDIF}
    property FontName:  TFontName   read FFontName   write FFontName;
    property Size:      Integer     read FSize       write FSize       default 10;
    property Style:     TFontStyles read FStyle      write FStyle      default [];
    property VShift:    Integer     read FVShift     write FVShift     default 0;
    property Color:     TColor      read FColor      write FColor      default clWindowText;
    property BackColor: TColor      read FBackColor  write FBackColor  default clNone;
    property HoverBackColor: TColor read FHoverBackColor write FHoverBackColor default clNone;
    property HoverColor: TColor     read FHoverColor write FHoverColor default clNone;
    property HoverEffects: TRVHoverEffects read FHoverEffects write FHoverEffects default [];
    property StyleEx:   TRVFontStyles read FStyleEx  write FStyleEx    default [];
    property Jump:       Boolean    read FJump       write FJump       default False;
    property JumpCursor: TCursor    read FJumpCursor write FJumpCursor default crJump;
    property CharScale: Integer     read FCharScale  write FCharScale  default 100;
    property CharSpacing: TRVStyleLength  read FCharSpacing write FCharSpacing default 0;
    property BiDiMode: TRVBiDiMode  read FBiDiMode   write FBiDiMode   default rvbdUnspecified;
    property SubSuperScriptType: TRVSubSuperScriptType read FSubSuperScriptType write FSubSuperScriptType default rvsssNormal;
    {$IFDEF RVLANGUAGEPROPERTY}
    property Language: Cardinal     read FLanguage   write FLanguage  default 0;
    {$ENDIF}
    property Protection: TRVProtectOptions read FProtection write FProtection default [];
    property Options: TRVTextOptions read FOptions write FOptions default [];
    property UnderlineType: TRVUnderlineType read FUnderlineType write FUnderlineType default rvutNormal;
    property UnderlineColor: TColor read FUnderlineColor write FUnderlineColor default clNone;
    property HoverUnderlineColor: TColor read FHoverUnderlineColor write FHoverUnderlineColor default clNone;    
  end;
  { ---------------------------------------------------------------------------
   TFontInfo: text style, item in the collection TRVStyle.TextStyles
    (collection type is TFontInfos)
    Properties:
    - NextStyleNo - index of text style for the next paragraph, if user
      pressed ENTER at the end of paragraph of this style. -1 for the same style
    - Unicode - if False, this text has ANSI encoding. If True, it is Unicode
    - ModifiedProperties1, 2 - list of properties which are not inherited
      from StyleTemplate identified by StyleTemplateId property
  }
  TFontInfo = class (TCustomRVFontInfo)
  private
    {$IFNDEF RVDONOTUSEUNICODE}
    FUnicode: Boolean;
    {$ENDIF}
    FNextStyleNo: Integer;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    FModifiedProperties1: TRVFontInfoProperties1;
    FModifiedProperties2: TRVFontInfoProperties2;    
    {$ENDIF}
  protected
    function IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean; override;
    function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; override;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    procedure ExcludeUnmodifiedProperties(Source: TCustomRVFontInfo;
      PossibleProps: TRVFontInfoProperties);
    {$ENDIF}
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TCustomRVFontInfo; IgnoreList: TRVFontInfoProperties): Boolean; override;
    procedure Draw(const s: TRVRawByteString; Canvas: TCanvas; ThisStyleNo: Integer;
      SpaceAtLeft, Left, Top, Width, Height, BaseLine: Integer;
      RVStyle: TRVStyle;
      DrawState: TRVTextDrawStates; Printing, PreviewCorrection: Boolean;
      ColorMode: TRVColorMode; DefBiDiMode: TRVBiDiMode;
      RefCanvas: TCanvas; GraphicInterface: TRVGraphicInterface);
    procedure DrawVertical(const s: TRVRawByteString; Canvas: TCanvas; // <-  do not ask me what is it :)
      ThisStyleNo: Integer; SpaceBefore, Left, Top, Width, Height: Integer;
      RVStyle: TRVStyle; DrawState: TRVTextDrawStates);
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String); override;
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String;
      JumpByDefault: Boolean; DefJumpCursor: TCursor); override;
    {$ENDIF}
  published
    property NextStyleNo: Integer   read FNextStyleNo write FNextStyleNo default -1;
    {$IFNDEF RVDONOTUSEUNICODE}
    property Unicode: Boolean       read FUnicode    write FUnicode
      {$IFNDEF RICHVIEWDEF2009}default False{$ENDIF};
    {$ENDIF}
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    property ModifiedProperties1: TRVFontInfoProperties1
      read FModifiedProperties1 write FModifiedProperties1 default [];
    property ModifiedProperties2: TRVFontInfoProperties2
      read FModifiedProperties2 write FModifiedProperties2 default [];
    {$ENDIF}
  end;

  TErrFontInfo = class(TFontInfo)
  private
    FRVStyle: TRVStyle;
  public
    constructor CreateErr(RVStyle: TRVStyle);
    function GetRVStyle: TRVStyle; override;
  end;
  { ---------------------------------------------------------------------------
    TCustomRVInfos: ancestor class for collections of styles
    (TFontInfos, TParaInfos, TRVListInfos)
  }
  TCustomRVInfos = class (TCollection)
  protected
    FOwner: TPersistent;
  public
    constructor Create(ItemClass: TCollectionItemClass; Owner: TPersistent);
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent; override;
    {$ENDIF}
    procedure AssignTo(Dest: TPersistent); override;
    procedure MergeWith(Styles:TCustomRVInfos; Mode:TRVStyleMergeMode;
      Mapping: TRVIntegerList; TextStyleMapping: TRVIntegerList;
      RVData: TPersistent{$IFDEF RICHVIEWDEF4}=nil{$ENDIF});
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
  end;
  {----------------------------------------------------------------------------
    TFontInfos: collection of text styles (of TFontInfo), TRVStyle.TextStyles
    Properties:
    - Items[] - items
    - InvalidItem - returned when accessing item with invalid index
  }
  TFontInfos = class (TCustomRVInfos)
  private
    FInvalidItem: TFontInfo;
    function GetItem(Index: Integer): TFontInfo;
    procedure SetItem(Index: Integer; Value: TFontInfo);
    function GetInvalidItem: TFontInfo;
    procedure SetInvalidItem(const Value: TFontInfo);
  public
    PixelsPerInch: Integer;
    destructor Destroy; override;
    {$IFDEF RICHVIEWCBDEF3}
    function FindStyleWithCharset(BaseStyle: Integer;
      Charset: TFontCharset): Integer;
    {$ENDIF}
    function FindStyleWithFontStyle(BaseStyle: Integer; Value,
      Mask: TFontStyles): Integer;
    function FindStyleWithFontSize(BaseStyle: Integer; Size: Integer): Integer;
    function FindStyleWithColor(BaseStyle: Integer;
      Color, BackColor: TColor): Integer;
    function FindStyleWithFontName(BaseStyle: Integer;
      const FontName: TFontName): Integer;
    function FindSuchStyle(BaseStyle: Integer; Style: TFontInfo;
      Mask: TRVFontInfoProperties): Integer;
    function FindStyleWithFont(BaseStyle: Integer; Font: TFont): Integer;
    function Add: TFontInfo;
    function AddFont(Name: TFontName; Size: Integer; Color, BackColor: TColor;
      Style:TFontStyles): TFontInfo;
    {$IFDEF RICHVIEWCBDEF3}
    function AddFontEx(Name: TFontName; Size: Integer; Color, BackColor: TColor;
      Style:TFontStyles; Charset: TFontCharset): TFontInfo;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section: String);
    procedure LoadFromINI(ini: TRVIniFile; const Section: String;
      DefJumpCursor: TCursor); 
    {$ENDIF}
    property Items[Index: Integer]: TFontInfo read GetItem write SetItem; default;
    property InvalidItem: TFontInfo read GetInvalidItem write SetInvalidItem;
  end;
  { ---------------------------------------------------------------------------
    TRVRect: rectangle.
    Properties:
    - Left, Top, Right, Bottom  (measured in RVStyle.Units)
  }
  TRVRect = class (TPersistent)
    private
      FOwner: TPersistent;
      FTop, FLeft, FRight, FBottom: TRVStyleLength;
      function IsEqualEx(Value: TRVRect; IgnL,IgnT,IgnR,IgnB: Boolean): Boolean;
      function SimilarityValue(Value: TRVRect; Weight: TRVStyleLength; Wht: Integer): Integer;
    public
      constructor CreateOwned(AOwner: TPersistent);
      procedure Assign(Source: TPersistent); override;
      procedure AssignValidProperties(Source: TRVRect; ValL, ValT, ValR, ValB: Boolean);
      procedure SetAll(Value: TRVStyleLength);
      procedure InflateRect(var Rect: TRect; RVStyle: TRVStyle);
      procedure InflateRectSaD(var Rect: TRect; RVStyle: TRVStyle; const sad: TRVScreenAndDevice);
      procedure AssignToRect(var Rect: TRect);
      procedure AssignToRectIfGreater(var Rect: TRect);
      function IsEqual(Value: TRVRect): Boolean;
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
      procedure ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
      property Owner: TPersistent read FOwner;
    published
      property Left: TRVStyleLength   read FLeft   write FLeft   default 0;
      property Right: TRVStyleLength  read FRight  write FRight  default 0;
      property Top: TRVStyleLength    read FTop    write FTop    default 0;
      property Bottom: TRVStyleLength read FBottom write FBottom default 0;
  end;
  { ---------------------------------------------------------------------------
    TRVBooleanRect: 4 boolean values
    Properties:
    - Left, Top, Right, Bottom
  }
  TRVBooleanRect = class (TPersistent)
    private
      FTop: Boolean;
      FLeft: Boolean;
      FRight: Boolean;
      FBottom: Boolean;
      function IsEqualEx(Value: TRVBooleanRect; IgnL,IgnT,IgnR,IgnB: Boolean): Boolean;
    public
      constructor Create(DefValue: Boolean);
      procedure SetAll(Value: Boolean);
      procedure SetValues(ALeft, ATop, ARight, ABottom: Boolean);
      procedure Assign(Source: TPersistent); override;
      procedure AssignValidProperties(Source: TRVBooleanRect;
         ValL, ValT, ValR, ValB: Boolean);
      function IsEqual(Value: TRVBooleanRect): Boolean;
      function IsEqual2(ALeft, ATop, ARight, ABottom: Boolean): Boolean;
      function IsAllEqual(Value: Boolean): Boolean;
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
    published
      property Left: Boolean   read FLeft   write FLeft   default True;
      property Right: Boolean  read FRight  write FRight  default True;
      property Top: Boolean    read FTop    write FTop    default True;
      property Bottom: Boolean read FBottom write FBottom default True;
  end;
  { ---------------------------------------------------------------------------
    TRVBorder: paragraph border
    Properties:
    - Width - [thin] line width
    - InternalWidth - spacing between border lines (for double or triple borders)
    - Color - border color
    - Style - border type, see TRVBorderStyle
    - VisibleBorders - turn on/off border sides
    - BorderOffsets - padding between text and border
  }
  TRVBorder = class (TPersistent)
    private
      FColor: TColor;
      FStyle: TRVBorderStyle;
      FWidthX: TRVStyleLength;
      FInternalWidthX: TRVStyleLength;
      FVisibleBorders: TRVBooleanRect;
      FBorderOffsets: TRVRect;
      FOwner: TPersistent;
      procedure SetBorderOffsets(const Value: TRVRect);
      procedure SetVisibleBorders(const Value: TRVBooleanRect);
      function SimilarityValue(Value: TRVBorder; Wht: Integer): Integer;
    protected
      procedure DoDraw(ARect: TRect; Canvas: TCanvas;
        WidthLR, WidthTB, InternalWidthLR, InternalWidthTB: Integer;
        ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
    public
      constructor Create(AOwner: TPersistent);
      destructor Destroy; override;
      procedure Draw(Rect: TRect; Canvas: TCanvas; RVStyle: TRVStyle;
        GraphicInterface: TRVGraphicInterface);
      procedure DrawSaD(Rect: TRect; Canvas: TCanvas; RVStyle: TRVStyle;
        const sad: TRVScreenAndDevice;
        ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
      procedure Assign(Source: TPersistent); override;
      function IsEqual(Value: TRVBorder): Boolean;
      function IsEqual_Para(Value: TRVBorder; IgnoreList: TRVParaInfoProperties): Boolean;
      procedure AssignValidProperties(Source: TRVBorder; ValidProperties: TRVParaInfoProperties1);
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
      function GetTotalWidth: TRVStyleLength;
      procedure ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
      property Owner: TPersistent read FOwner;
    published
      property Width:         TRVStyleLength  read FWidthX          write FWidthX         default 1;
      property InternalWidth: TRVStyleLength  read FInternalWidthX  write FInternalWidthX default 1;
      property Color:         TColor          read FColor          write FColor         default clWindowText;
      property Style:         TRVBorderStyle  read FStyle          write FStyle         default rvbNone;
      property VisibleBorders: TRVBooleanRect read FVisibleBorders write SetVisibleBorders;
      property BorderOffsets: TRVRect read FBorderOffsets write SetBorderOffsets;
  end;
  { ---------------------------------------------------------------------------
    TRVBackgroundRect: properties for paragraph background
    Properties:
    - Color - background color (clNone for transparent)
    - BorderOffsets - padding (widths of colored area around paragraph text)
  }
  TRVBackgroundRect = class (TPersistent)
    private
      FBorderOffsets: TRVRect;
      FColor: TColor;
      FOwner: TPersistent;
      procedure SetBorderOffsets(const Value: TRVRect);
      function SimilarityValue(Value: TRVBackgroundRect; Wht: Integer): Integer;
    public
      constructor Create(AOwner: TPersistent);
      destructor Destroy; override;
      procedure Assign(Source: TPersistent); override;
      procedure PrepareDraw(var Rect: TRect; RVStyle: TRVStyle);
      procedure PrepareDrawSaD(var Rect: TRect; RVStyle: TRVStyle;
        const sad: TRVScreenAndDevice);
      procedure Draw(Rect: TRect; Canvas: TCanvas; Printing: Boolean;
        ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
      function IsEqual(Value: TRVBackgroundRect): Boolean;
      function IsEqual_Para(Value: TRVBackgroundRect;
        IgnoreList: TRVParaInfoProperties): Boolean;
      procedure AssignValidProperties(Source: TRVBackgroundRect;
        ValidProperties: TRVParaInfoProperties1);
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
      property Owner: TPersistent read FOwner;
    published
      property Color: TColor read FColor write FColor default clNone;
      property BorderOffsets: TRVRect read FBorderOffsets write SetBorderOffsets;
  end;
{$IFNDEF RVDONOTUSETABS}
  {----------------------------------------------------------------------------
    TRVTabInfo: properties of paragraph's tabs.
    Properties:
    - Align - alignment of tab relative to the next text
    - Position - distance between the left (right for RTL) margin and the tab;
        assignment resorts the tab collection
    - Leader - characters to fill the tab   }
  TRVTabInfo = class (TCollectionItem)
    private
      FPosition: TRVStyleLength;
      FLeader: String;
      FAlign: TRVTabAlign;
      function StoreLeader: Boolean;
      procedure SetPosition(const Value: TRVStyleLength);
    protected
      {$IFDEF RICHVIEWCBDEF3}
      function GetDisplayName: String; override;
      {$ENDIF}
    public
      function IsEqual(Value: TRVTabInfo): Boolean;
      function SimilarityValue(Value: TRVTabInfo; Wht: Integer): Integer;
      procedure Assign(Source: TPersistent); override;
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
    published
      property Align: TRVTabAlign read FAlign write FAlign default rvtaLeft;
      property Position: TRVStyleLength read FPosition write SetPosition;
      property Leader: String read FLeader write FLeader stored StoreLeader;
  end;
  {----------------------------------------------------------------------------
  { TRVTabInfos: tabs of paragraphs, type of TParaInfo.Tabs
    (collection of TRVTabInfo)
    Properties:
    Items[] - tabs
  }
  TRVTabInfos = class (TCollection)
    private
      FOwner: TPersistent;
      function GetItem(Index: Integer): TRVTabInfo;
      procedure SetItem(Index: Integer; Value: TRVTabInfo);
    public
      constructor Create(Owner: TPersistent);
      {$IFDEF RICHVIEWCBDEF3}
      function GetOwner: TPersistent;  override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSEINI}
      procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
      procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
      {$ENDIF}
      function Add: TRVTabInfo;
      procedure SortTabs;
      function IsEqual(Value: TRVTabInfos): Boolean;
      function Find(Position: Integer): Integer;
      function SimilarityValue(Value: TRVTabInfos; Wht: Integer): Integer;
      procedure Intersect(Value: TRVTabInfos);
      procedure AddFrom(Source: TRVTabInfos);
      procedure DeleteList(Positions: TRVIntegerList);
      procedure ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
      property Items[Index: Integer]: TRVTabInfo
         read GetItem write SetItem; default;
  end;
{$ENDIF}
  {----------------------------------------------------------------------------
    TCustomRVParaInfo: ancestor of TParaInfo and TRVSTParaInfo
    Properties:
    - FirstIndent - first line indent, pixels (added to LeftIndent, can be negative)
    - LeftIndent, RightIndent, SpaceBefore, SpaceAfter - indents to the left,
      right, top, bottom of the paragraph, pixels
    - Alignment - paragraph alignmentm see TRVAlignment
    - Border - paragraph border, see TRVBorder
    - Background - paragraph background, see TRVBackgroundRect
    - LineSpacing - line spacing value, pixels or percents
    - LineSpacingType - line spacing type, see TRVLineSpacingType
    - Options - see TRVParaOptions
    - BiDiMode - paragraph bi-di mode
    - OutlineLevel: 0 - body text, 1..9 - headers
  }
  TCustomRVParaInfo = class (TCustomRVInfo)
  private
    FFirstIndent, FLeftIndent, FRightIndent: TRVStyleLength;
    FSpaceBefore, FSpaceAfter: TRVStyleLength;
    FLineSpacing: TRVLineSpacingValue;
    FLineSpacingType: TRVLineSpacingType;
    FAlignment: TRVAlignment;
    FBorder: TRVBorder;
    FBackground: TRVBackgroundRect;
    FOptions: TRVParaOptions;
    FBiDiMode: TRVBiDiMode;
    FOutlineLevel: Integer;
    {$IFNDEF RVDONOTUSETABS}
    FTabs: TRVTabInfos;
    {$ENDIF}
    procedure SetBorder(const Value: TRVBorder);
    procedure SetBackground(const Value: TRVBackgroundRect);
    function ExtraLineSpacing: Boolean;
    {$IFNDEF RVDONOTUSETABS}
    procedure SetTabs(const Value: TRVTabInfos);
    {$ENDIF}
    procedure SetSpaceAfter(const Value: TRVStyleLength);
    procedure SetSpaceBefore(const Value: TRVStyleLength);
  protected
    function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; override;
    function SimilarityValue(Value: TCustomRVInfo): Integer; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure AssignSelectedProperties(Source: TCustomRVParaInfo;
      Props: TRVParaInfoProperties);
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String); dynamic;
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String); dynamic;
    {$ENDIF}
    function IsEqual(Value: TCustomRVParaInfo; IgnoreList: TRVParaInfoProperties): Boolean; dynamic;
    {$IFNDEF RVDONOTUSEHTML}
    procedure SaveCSSToStream(Stream: TStream; BaseStyle: TParaInfo;
      Multiline, IgnoreLeftAlignment, IgnoreLeftIndents: Boolean);
    {$ENDIF}
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits); override;
  published
    property FirstIndent: TRVStyleLength read FFirstIndent write FFirstIndent default 0;
    property LeftIndent:  TRVStyleLength read FLeftIndent  write FLeftIndent  default 0;
    property RightIndent: TRVStyleLength read FRightIndent write FRightIndent default 0;
    property SpaceBefore: TRVStyleLength read FSpaceBefore write SetSpaceBefore default 0;
    property SpaceAfter:  TRVStyleLength read FSpaceAfter  write SetSpaceAfter  default 0;
    property Alignment:   TRVAlignment  read FAlignment   write FAlignment   default rvaLeft;
    property Border:      TRVBorder     read FBorder      write SetBorder;
    property Background:  TRVBackgroundRect read FBackground write SetBackground;
    property LineSpacing: TRVLineSpacingValue  read FLineSpacing write FLineSpacing default 100;
    property LineSpacingType: TRVLineSpacingType read FLineSpacingType write FLineSpacingType default rvlsPercent;
    property Options: TRVParaOptions    read FOptions     write FOptions    default [];
    property BiDiMode: TRVBiDiMode      read FBiDiMode    write FBidiMode default rvbdUnspecified;
    property OutlineLevel: Integer read FOutlineLevel write FOutlineLevel default 0;
    {$IFNDEF RVDONOTUSETABS}
    property Tabs: TRVTabInfos          read FTabs        write SetTabs;
    {$ENDIF}
  end;
  {----------------------------------------------------------------------------
    TParaInfo: paragraph style, item in the collection TRVStyle.ParaStyles
    (collection type is TParaInfos)
    Properties:
    - NextParaNo - index of paragraph style for the next paragraph, if user
      pressed ENTER at the end of paragraph of this style. -1 for the same style
    - DefStyleNo - index of text style used for this paragraph by default
    - ModifiedProperties1, ModifiedProperties2 - list of properties not inherited
      from StyleTemplate identified by StyleTemplateId property
  }
  TParaInfo = class (TCustomRVParaInfo)
  private
    FNextParaNo: Integer;
    FDefStyleNo: Integer;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    FModifiedProperties1: TRVParaInfoProperties1;
    FModifiedProperties2: TRVParaInfoProperties2;
    {$ENDIF}
  protected
    function IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean; override;
    function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; override;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    procedure ExcludeUnmodifiedProperties(Source: TCustomRVParaInfo;
      PossibleProps: TRVParaInfoProperties);
    {$ENDIF}
  public
    constructor Create(Collection: TCollection); override;
    procedure Assign(Source: TPersistent); override;
    function IsEqual(Value: TCustomRVParaInfo; IgnoreList: TRVParaInfoProperties): Boolean; override;
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String); override;
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String); override;
    {$ENDIF}
    function IsHeading(MaxLevel: Integer): Boolean;
  published
    property NextParaNo: Integer        read FNextParaNo  write FNextParaNo default -1;
    property DefStyleNo: Integer        read FDefStyleNo  write FDefStyleNo default -1;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    property ModifiedProperties1: TRVParaInfoProperties1
      read FModifiedProperties1 write FModifiedProperties1 default [];
    property ModifiedProperties2: TRVParaInfoProperties2
      read FModifiedProperties2 write FModifiedProperties2 default [];
    {$ENDIF}
  end;
  { -------------------------------------------------------------------------- }
  TErrParaInfo = class(TParaInfo)
  private
    FRVStyle: TRVStyle;
  public
    constructor CreateErr(RVStyle: TRVStyle);
    function GetRVStyle: TRVStyle; override;
  end;
  { ---------------------------------------------------------------------------
    TParaInfos: collection of paragraph styles (of TParaInfo), TRVStyle.ParaStyles
    Properties:
    - Items[] - items
    - InvalidItem - returned when accessing item with invalid index
  }
  TParaInfos = class(TCustomRVInfos)
  private
    FInvalidItem: TParaInfo;
    function GetItem(Index: Integer): TParaInfo;
    procedure SetItem(Index: Integer; Value: TParaInfo);
    function GetInvalidItem: TParaInfo;
    procedure SetInvalidItem(const Value: TParaInfo);
  public
    function Add: TParaInfo;
    procedure AssignTo(Dest: TPersistent); override;
    destructor Destroy; override;
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section: String);
    procedure LoadFromINI(ini: TRVIniFile; const Section: String);
    {$ENDIF}
    function FindSuchStyle(BaseStyle: Integer; Style: TParaInfo;
      Mask: TRVParaInfoProperties): Integer;
    function FindStyleWithAlignment(BaseStyle: Integer;
      Alignment: TRVAlignment): Integer;
    property Items[Index: Integer]: TParaInfo
      read GetItem write SetItem; default;
    property InvalidItem: TParaInfo read GetInvalidItem write SetInvalidItem;
  end;
  { ---------------------------------------------------------------------------
    TRVMarkerFont: font for paragraph marker.
    Overrides default values of properties (to Arial, 8pt)
  }
  TRVMarkerFont = class (TFont)
  private
    function StoreName: Boolean;
    function StoreHeight: Boolean;
  public
    constructor Create;
    function IsEqual(Font: TFont): Boolean;
    function IsDefault: Boolean;
  published
    {$IFDEF RICHVIEWCBDEF3}
    property Charset default DEFAULT_CHARSET;
    {$ENDIF}
    property Color default clWindowText;
    property Name stored StoreName;
    property Style default [];
    property Height stored StoreHeight;
  end;
  { ---------------------------------------------------------------------------
    TRVListLevel: level of paragraph bullets/numbering. Item of collection
    RVListInfo.Levels (collection type is TRVListLevelCollection)
    Properties:
    - ListType - type of bullets/numbering, see TRVListType
    - StartFrom - level numbering starts from this value
    - ImageList, ImageIndex - used if ListType = rvlstImageList or
      rvlstImageListCounter
    - FormatString - format string for ListType = rvlstBullet or text numbering
    - FormatStringW - text, used if ListType = rvlstUnicodeBullet
    - LeftIndent - left indent (right indent for RTL paragraphs), pixels;
      overrides setting for paragraph
    - FirstIndent - first line indent, pixels; added to left indent,
      overrides setting for paragraph
    - MarkerIndent - indent of list marker, pixels (see also MarkerAlignment)
    - MarkerAlignment - alignment of list marker relative to position specified
      in MarkerIndent
    - Picture - used if ListType = rvlstPicture
    - Font - font of list marker, used for text list types
    - Options - see TRVListLevelOptions
  }
  TRVListLevel = class (TCollectionItem)
  private
    FListType: TRVListType;
    FPicture: TPicture;
    FImageList: TCustomImageList;
    FImageIndex: Integer;
    FFormatString: TRVMarkerFormatString;
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    FFormatStringW: TRVMarkerFormatStringW;
    {$ENDIF}
    {$ENDIF}
    FLeftIndent, FFirstIndent, FMarkerIndent: TRVStyleLength;
    FMarkerAlignment: TRVMarkerAlignment;
    FFont: TRVMarkerFont;
    FOptions: TRVListLevelOptions;
    FStartFrom: Integer;
    function GetPicture: TPicture;
    procedure SetPicture(const Value: TPicture);
    function GetFont: TRVMarkerFont;
    procedure SetFont(const Value: TRVMarkerFont);
    function StoreFont: Boolean;
    function StorePicture: Boolean;
    procedure ImageListTagWriter(Writer: TWriter);
    procedure ImageListTagReader(Reader: TReader);
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    procedure FormatStringWCodeWriter(Writer: TWriter);
    procedure FormatStringWCodeReader(Reader: TReader);
    {$ENDIF}
    {$ENDIF}
    procedure FormatStringCodeWriter(Writer: TWriter);
    procedure FormatStringCodeReader(Reader: TReader);
    procedure FormatStringCodeWReader(Reader: TReader);
    {$IFDEF RVUNICODESTR}
    procedure FormatStringCodeWWriter(Writer: TWriter);
    {$ENDIF}
    function StoreImageList: Boolean;
    function GetRVFRVData: TPersistent;
  protected
    {$IFDEF RICHVIEWCBDEF3}
    function GetDisplayName: String; override;
    {$ENDIF}
    function IsSimpleEqual(Value: TRVListLevel): Boolean;
    procedure DefineProperties(Filer: TFiler); override;
    function SimilarityValue(Value: TRVListLevel): Integer;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    {$IFNDEF RVDONOTUSEHTML}
    function GetHTMLOpenTagForCSS: String;
    function GetIndentCSSForTextVersion(RVStyle: TRVStyle): TRVAnsiString;
    procedure HTMLOpenTag(Stream: TStream; UseCSS: Boolean; RVStyle: TRVStyle);
    procedure HTMLCloseTag(Stream: TStream; UseCSS: Boolean);
    {$ENDIF}
    function HasPicture: Boolean;
    function UsesFont: Boolean;
    function HasNumbering: Boolean;
    function HasVariableWidth: Boolean;
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
    {$ENDIF}
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits; RVStyle: TRVStyle);
  published
    property ListType: TRVListType read FListType write FListType default rvlstBullet;
    property StartFrom: Integer read FStartFrom write FStartFrom default 1;
    property ImageList: TCustomImageList read FImageList write FImageList stored StoreImageList;
    property ImageIndex: Integer read FImageIndex write FImageIndex default 0;
    property FormatString: TRVMarkerFormatString read FFormatString write FFormatString stored False;
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    property FormatStringW: TRVMarkerFormatStringW read FFormatStringW write FFormatStringW stored False;
    {$ENDIF}
    {$ENDIF}
    property LeftIndent: TRVStyleLength read FLeftIndent write FLeftIndent default 0;
    property FirstIndent: TRVStyleLength read FFirstIndent write FFirstIndent default 10;
    property MarkerIndent: TRVStyleLength read FMarkerIndent write FMarkerIndent default 0;
    property MarkerAlignment: TRVMarkerAlignment read FMarkerAlignment write FMarkerAlignment default rvmaLeft;
    property Picture: TPicture read GetPicture write SetPicture stored StorePicture;
    property Font: TRVMarkerFont read GetFont write SetFont stored StoreFont;
    property Options: TRVListLevelOptions read FOptions write FOptions default [rvloContinuous, rvloLevelReset];
  end;
  { ---------------------------------------------------------------------------
    TRVListLevelCollection: collection of levels of paragraph bullets/numbering.
    A type of TRVListInfo.Levels. Type of collection item is TRVListLevel
    Properties:
    Items[] - list levels
  }
  TRVListLevelCollection = class (TCollection)
  private
    FOwner: TPersistent;
    function GetItem(Index: Integer): TRVListLevel;
    procedure SetItem(Index: Integer; const Value: TRVListLevel);
  public
    constructor Create(Owner: TPersistent);
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent;  override;
    {$ENDIF}
    function Add: TRVListLevel;
    {$IFDEF RICHVIEWDEF4}
    function Insert(Index: Integer): TRVListLevel;
    {$ENDIF}
    function IsSimpleEqual(Value: TRVListLevelCollection): Boolean;
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits; RVStyle: TRVStyle);
    property Items[Index: Integer]: TRVListLevel
       read GetItem write SetItem; default;
  end;
  {----------------------------------------------------------------------------
    TRVListInfo: style of paragraph bullets/numbering, item in the collection
    TRVStyle.ListStyles (collection type is TRVListInfos)
    Properties:
    - Levels[] - collection of list levels; must have at least one item in
      order to display bullet/numbering
    - OneLevelPreview - for using in user interface (if True, preview
      of this paragraph list should show only one level)
    - ListID (read-only) - a random number for distinguishing lists with the same
      properties when pasting RVF
  }
  TRVListInfo = class (TCustomRVInfo)
  private
    FLevels: TRVListLevelCollection;
    FOneLevelPreview: Boolean;
    FListID: Integer;
    procedure SetLevels(const Value: TRVListLevelCollection);
    function GetListID: Integer;
    procedure ReadListID(Reader: TReader);
    procedure WriteListID(Writer: TWriter);
  protected
    function SimilarityValue(Value: TCustomRVInfo): Integer; override;
    procedure DefineProperties(Filer: TFiler); override;
  public
    function IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean; override;
    function IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean; override;
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String); dynamic;
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String); dynamic;
    {$ENDIF}
    function HasNumbering: Boolean;
    function AllNumbered: Boolean;
    function HasVariableWidth: Boolean;
    property ListID: Integer read GetListID;
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits); override;
  published
    property Levels: TRVListLevelCollection read FLevels write SetLevels;
    property OneLevelPreview: Boolean read FOneLevelPreview write FOneLevelPreview default False;
  end;
  { ---------------------------------------------------------------------------
    TRVListInfos: collection of styles of paragraph lists (of TRVListInfo),
    TRVStyle.ListStyles
    Properties:
    - Items[] - items
  }
  TRVListInfos = class (TCustomRVInfos)
  private
    function GetItem(Index: Integer): TRVListInfo;
    procedure SetItem(Index: Integer; const Value: TRVListInfo);
    procedure RemoveImageList(ImageList: TCustomImageList);
  public
    FRVData: TPersistent;
    FRichViewAllowAssignListID: Boolean;
    function Add: TRVListInfo;
    {$IFDEF RICHVIEWDEF4}
    function Insert(Index: Integer): TRVListInfo;
    {$ENDIF}
    {$IFNDEF RVDONOTUSEINI}
    procedure LoadFromINI(ini: TRVIniFile; const Section: String);
    procedure SaveToINI(ini: TRVIniFile; const Section: String);
    {$ENDIF}
    function FindSuchStyle(Style: TRVListInfo; AddIfNotFound: Boolean): Integer;
    function FindStyleWithLevels(Levels: TRVListLevelCollection;
      const StyleNameForAdding: String; AddIfNotFound: Boolean): Integer;
    property Items[Index: Integer]: TRVListInfo
       read GetItem write SetItem; default;
  end;

  TRVFontInfoClass = class of TFontInfo;
  TRVParaInfoClass = class of TParaInfo;
  TRVListInfoClass = class of TRVListInfo;

  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  { ---------------------------------------------------------------------------
    TRVSTFontInfo, TRVSTParaInfo, TRVSTListInfo: classes for properties of
    TRVStyleTemplate. Hide some properties.
  }

  TRVSTFontInfo = class (TCustomRVFontInfo)
  private
    {$IFDEF RICHVIEWCBDEF3}
    FOwner: TPersistent;
    {$ENDIF}
    procedure SetNoProp(const Value: Integer);
  public
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent; override;
    {$ENDIF}
  published
    property StyleTemplateId: Integer write SetNoProp;
    property StyleName: Integer write SetNoProp;
    property Standard: Integer write SetNoProp;
    property BaseStyleNo: Integer write SetNoProp;
  end;

  TRVSTParaInfo = class (TCustomRVParaInfo)
  private
    {$IFDEF RICHVIEWCBDEF3}
    FOwner: TPersistent;
    {$ENDIF}
    procedure SetNoProp(const Value: Integer);
  public
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent; override;
    {$ENDIF}
  published
    property StyleTemplateId: Integer write SetNoProp;
    property StyleName: Integer write SetNoProp;
    property Standard: Integer write SetNoProp;
    property BaseStyleNo: Integer write SetNoProp;
  end;

  TRVSTListInfo = class (TRVListInfo)
  private
    {$IFDEF RICHVIEWCBDEF3}
    FOwner: TPersistent;
    {$ENDIF}
    procedure SetNoProp(const Value: Integer);
  public
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent; override;
    {$ENDIF}
  published
    property StyleTemplateId: Integer write SetNoProp;
    property StyleName: Integer write SetNoProp;
    property Standard: Integer write SetNoProp;
    property BaseStyleNo: Integer write SetNoProp;
  end;

  TRVStyleTemplate = class (TCollectionItem)
  private
    FName: TRVStyleTemplateName;
    FId: TRVStyleTemplateId;
    FParentId: TRVStyleTemplateId;
    FTextStyle: TRVSTFontInfo;
    FParaStyle: TRVSTParaInfo;
    FListStyle: TRVSTListInfo;
    FValidTextProperties1: TRVFontInfoProperties1;
    FValidTextProperties2: TRVFontInfoProperties2;
    FValidParaProperties1: TRVParaInfoProperties1;
    FValidParaProperties2: TRVParaInfoProperties2;
    FParent: TRVStyleTemplate;
    FChildren: TList;
    function GetId: TRVStyleTemplateId;
    procedure SetTextStyle(const Value: TRVSTFontInfo);
    // procedure SetListStyle(const Value: TRVSTListInfo);
    procedure SetParaStyle(const Value: TRVSTParaInfo);
    procedure ReadID(Reader: TReader);
    procedure WriteID(Writer: TWriter);
    procedure AddChild(Child: TRVStyleTemplate);
    procedure RemoveChild(Child: TRVStyleTemplate);
    procedure SetParentId(const Value: TRVStyleTemplateId);
    procedure UpdateParentReference;
    procedure SetName(const Value: TRVStyleTemplateName);
  protected
    procedure DefineProperties(Filer: TFiler); override;
    function AssignToTextStyle(ATextStyle: TCustomRVFontInfo;
      AllowedProps: TRVFontInfoProperties): TRVFontInfoProperties;
    function AssignToParaStyle(AParaStyle: TCustomRVParaInfo;
      AllowedProps: TRVParaInfoProperties): TRVParaInfoProperties;
    procedure AssignTo(Dest: TPersistent); override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    {$IFDEF RICHVIEWCBDEF3}
    function GetDisplayName: String; override;
    {$ENDIF}
    procedure Assign(Source: TPersistent); override;
    function IsAncestorFor(StyleTemplate: TRVStyleTemplate): Boolean;
    procedure ExcludeUnmodifiedTextStyleProperties(ATextStyle: TFontInfo;
      PossibleProps: TRVFontInfoProperties);
    procedure ExcludeUnmodifiedParaStyleProperties(AParaStyle: TParaInfo;
      PossibleProps: TRVParaInfoProperties);
    procedure ApplyToTextStyle(ATextStyle: TCustomRVFontInfo;
      AParaStyle: TCustomRVParaInfo; OverrideModifiedProperties: Boolean);
    procedure ApplyToParaStyle(AParaStyle: TCustomRVParaInfo;
      OverrideModifiedProperties: Boolean);
    {$IFNDEF RVDONOTUSEINI}
    procedure LoadFromINI(ini: TRVIniFile; const Section, fs: String);
    procedure SaveToINI(ini: TRVIniFile; const Section, fs: String);
    {$ENDIF}
  published
    property TextStyle: TRVSTFontInfo read FTextStyle write SetTextStyle;
    property ParaStyle: TRVSTParaInfo read FParaStyle write SetParaStyle;
    // property ListStyle: TRVSTListInfo read FListStyle write SetListStyle;
    property ValidTextProperties1: TRVFontInfoProperties1
      read FValidTextProperties1 write FValidTextProperties1 default [];
    property ValidTextProperties2: TRVFontInfoProperties2
      read FValidTextProperties2 write FValidTextProperties2 default [];
    property ValidParaProperties1: TRVParaInfoProperties1
      read FValidParaProperties1 write FValidParaProperties1 default [];
    property ValidParaProperties2: TRVParaInfoProperties2
      read FValidParaProperties2 write FValidParaProperties2 default [];
    property Name: TRVStyleTemplateName read FName write SetName;
    property Id: TRVStyleTemplateId read GetId;
    property ParentId: TRVStyleTemplateId read FParentId write SetParentId default -1;
  end;

  TRVStyleTemplateCollection = class (TCollection)
  private
    FNameCounter: Integer;
    FDefStyleName: String;
    FNormalStyleTemplate: TRVStyleTemplate;
    function GetItem(Index: Integer): TRVStyleTemplate;
    procedure SetItem(Index: Integer; const Value: TRVStyleTemplate);
    procedure AssignUniqueNameTo(Item: TRVStyleTemplate);
    function StoreDefStyleName: Boolean;
    procedure UpdateParentReferences;
  protected
    FOwner: TPersistent;
  public
    constructor Create(Owner: TPersistent);
    procedure ResetNameCounter;
    procedure Sort;
    function FindById(Id: TRVStyleTemplateId): Integer;
    function FindByName(const Name: TRVStyleTemplateName): Integer;
    function GetNormalStyleTemplate: TRVStyleTemplate;
    procedure AssignToStrings(Strings: TStrings; AssignObjects: Boolean);
    procedure Assign(Source: TPersistent); override;
    procedure AssignStyleTemplates(Source: TRVStyleTemplateCollection; CopyIds: Boolean);
    procedure ClearParaFormat(AParaStyle: TCustomRVParaInfo);
    procedure ClearTextFormat(ATextStyle: TCustomRVFontInfo; AParaStyle: TCustomRVParaInfo);
    {$IFNDEF RVDONOTUSEINI}
    procedure LoadFromINI(ini: TRVIniFile; const Section: String);
    procedure SaveToINI(ini: TRVIniFile; const Section: String);
    {$ENDIF}
    {$IFDEF RICHVIEWCBDEF3}
    function GetOwner: TPersistent; override;
    {$ENDIF}
    property Items[Index: Integer]: TRVStyleTemplate read GetItem write SetItem; default;
  published
    property DefStyleName: String read FDefStyleName write FDefStyleName stored StoreDefStyleName;
  end;
  {$ENDIF}

  { ---------------------------------------------------------------------------
    TRVStyle: component. Contains properties affecting TCustomRichView.
    Assign TCustomRichView.Style to TRVStyle object.
    Properties:
    - TextStyles - collection of text styles, see TFontInfos, TFontInfo
    - ParaStyles - collection of paragraph styles, see TParaInfos, TParaInfo
    - ListStyles - collection of styles of paragraph lists, see TRVListInfos,
      TRVListInfo

    - SpacesInTab - a number of space characters used to replace TAB;
      If zero, TABs will not be replaced but inserted as a special item type.
    - DefTabWidth - default tab width for the document

    - JumpCursor - hypertext cursor for non-text items ("hot-pictures",
      "hotspots")
    - LineSelectCursor - cursor for line selection (when mouse pointer is
      above the left margin of RichView

    - Color - background color, if TCustomRichView.Color = clNone
    - HoverColor - color of hypertext under mouse (if TFontInfo.HoverColor =
      clNone), clNone for no effect.
    - CurrentItemColor - color of border around current image or control in
      editor. clNone for no effect.
    - SelColor - background color of selection, clNone for invisible selection
      (i.s.). Used if TCustomRichView has input focus.
    - SelTextColor -  color of selected text, clNone for i.s. Used if
      TCustomRichView has input focus.
    - InactiveSelColor - background color of selection, clNone for i.s. Used if
      TCustomRichView does not have input focus.
    - InactiveSelTextColor - color of selected text, clNone for i.s. Used if
      TCustomRichView does not have input focus.
    - CheckpointColor - color of "checkpoints"; used if rvoShowCheckpoints is
      in TCustomRichView.Options. For "checkpoints" with no "raise-event" flag
    - CheckpointEvColor - the same, but for "checkpoints" with "raise-event"
      flag
    - PageBreakColor - color of explicit page breaks. Used if rvoShowPageBreaks
      is in TCustomRichView.Options.
    - SoftPageBreakColor - the same for "soft" (automatic) page breaks
    - LiveSpellingColor - color of live spelling underline
    - FloatingLineColor - color for drawing placeholders for floating (side-
      -aligned) items
    - SpecialCharactersColor - color for drawing special characters (clNone for
      default color)

    - SelectionMode: mode of making selection, see TRVSelectionMode
    - SelectionStyle: visual appearance of selection, see TRVSelectionStyle

    - FullRedraw - (see the help file)
    - UseSound - allows beeping on incorrect operations (such as attempting
      deleting protected text)
    - DefUnicodeStyle - index (in TextStyles) of style that should be used
      for Unicode (if Unicode operation is performed in TCustomRichViewEdit
      but the current style is not Unicode). -1 for no special processing.
    - DefCodePage - code page for ANSI <-> Unicode conversion
    - InvalidPicture - picture to replace invalid/damaged pictures

    - FieldHighlightColor - color to highlight fields (TRVLabelItemInfo
      and descendent item types)
    - FieldHighlightType - specifies when fields are highlighted
    - DisabledFontColor - color for text, when disabled, if <>clNone
    - FootnoteNumbering, EndnoteNumbering - numbering style of footnotes and
      endnotes.
    - FootnotePageReset - if True, footnote numbering will be started from 1
      on each page.
    - LineWrapMode - line wrapping mode
    - Units - measuring units for properties of RVStyle and its subproperties

    Events:
    - OnApplyStyle: TRVApplyStyleEvent - allows to set additional properties
      to Canvas then applying text style (by default font, spacing, bidi-mode
      are set)
    - OnAfterApplyStyle: TRVAfterApplyStyleEvent - the same, but occurs after
      default applying
    - OnApplyStyleColor: TRVApplyStyleColorEvent - allows to override color
      applied to Canvas's font and brush then applying text style
    - OnDrawStyleText: TRVDrawStyleTextEvent - event for text custom drawing
    - OnStyleHoverSensitive - asks, if the text should be redrawn when mouse
      enters/leaves it; used for custom drawing
    - OnDrawTextBack: TRVDrawTextBackEvent - event for text custom drawing
      (drawing text background)
    - OnDrawCheckpoint: TRVDrawCheckpointEvent - allows to override default
      drawing of "checkpoints"
    - OnDrawPageBreak: TRVDrawPageBreakEvent - allows to override default
      drawing of page breaks
    - OnDrawParaBack: TRVDrawParaRectEvent - custom drawing of paragraph
      background
  }
  TRVStyle = class(TComponent)
  private
    { Private declarations }
    FInvalidPicture: TPicture;
    FColor, FHoverColor, FCurrentItemColor, FSelColor, FSelTextColor,
    FInactiveSelColor, FInactiveSelTextColor,
    FCheckpointColor, FCheckpointEvColor: TColor;
    FJumpCursor: TCursor;
    FTextStyles: TFontInfos;
    FParaStyles: TParaInfos;
    FListStyles: TRVListInfos;
    FFullRedraw: Boolean;
    FSpacesInTab: Integer;
    FDefTabWidth: TRVStyleLength;
    FPageBreakColor, FSoftPageBreakColor: TColor;
    FLiveSpellingColor: TColor;
    FOnApplyStyleColor: TRVApplyStyleColorEvent;
    FOnApplyStyle: TRVApplyStyleEvent;
    FOnAfterApplyStyle: TRVAfterApplyStyleEvent;
    FOnDrawStyleText: TRVDrawStyleTextEvent;
    FOnStyleHoverSensitive: TRVStyleHoverSensitiveEvent;
    FOnDrawTextBack: TRVDrawTextBackEvent;
    FOnDrawCheckpoint: TRVDrawCheckpointEvent;
    FOnDrawPageBreak: TRVDrawPageBreakEvent;
    FOnDrawParaBack: TRVDrawParaRectEvent;
    FFieldHighlightColor, FDisabledFontColor: TColor;
    FFieldHighlightType: TRVFieldHighlightType;
    FFootnoteNumbering, FEndnoteNumbering: TRVSeqType;
    FFootnotePageReset: Boolean;
    FDefaultUnicodeStyles: Boolean;
    {$IFNDEF RVDONOTUSEUNICODE}
    FDefUnicodeStyle: Integer;
    {$ENDIF}
    FDefCodePage:TRVCodePage;
    FUseSound: Boolean;
    FSelectionMode: TRVSelectionMode;
    FSelectionStyle: TRVSelectionStyle;
    FLineSelectCursor: TCursor;
    FFloatingLineColor: TColor;
    FSpecialCharactersColor: TColor;
    FLineWrapMode: TRVLineWrapMode;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    FStyleTemplates: TRVStyleTemplateCollection;
    {$ENDIF}
    FGraphicInterface: TRVGraphicInterface;
    FUnits: TRVStyleUnits;
    procedure SetTextStyles(Value: TFontInfos);
    procedure SetParaStyles(Value: TParaInfos);
    procedure SetListStyles(Value: TRVListInfos);
    function GetHoverColorByColor(Color: TColor): TColor;
    function GetInvalidPicture: TPicture;
    procedure SetInvalidPicture(const Value: TPicture);
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    procedure SetStyleTemplates(const Value: TRVStyleTemplateCollection);
    {$ENDIF}
  protected
    { Protected declarations }
    procedure ReadState(Reader: TReader);override;
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    procedure Loaded; override;
    procedure CreateGraphicInterface; dynamic;
  public
    ItemNo, OffsetInItem: Integer;
    RVData: TPersistent;
    procedure ResetTextStyles;
    procedure ResetParaStyles;
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetTextStyleClass: TRVFontInfoClass; virtual;
    function GetParaStyleClass: TRVParaInfoClass; virtual;
    function GetListStyleClass: TRVListInfoClass; virtual;
    procedure GetNextTab(ParaNo, X: Integer; sad: TRVScreenAndDevice;
      var Position: Integer; var Leader: String; var Align: TRVTabAlign;
      DefBiDiMode: TRVBiDiMode; LeftIndent, RightIndent: Integer);
    function AddTextStyle: Integer; {$IFDEF RICHVIEWDEF6}deprecated;{$ENDIF}
    procedure DeleteTextStyle(Index: Integer); {$IFDEF RICHVIEWDEF6}deprecated;{$ENDIF}
    {$IFNDEF RVDONOTUSEINI}
    procedure SaveINI(const FileName, Section: String); {WARNING: before saving all Section will be removed}
    procedure LoadINI(const FileName, Section: String);
    procedure SaveToINI(ini: TRVIniFile; Section: String);
    procedure LoadFromINI(ini: TRVIniFile; Section: String);
    {$IFDEF RICHVIEWDEF4}
    procedure SaveReg(const BaseKey: String); {WARNING: will be created 'RVStyle' subkey. If it
                                               already exists, all data and subkeys in this 'RVStyle'
                                               key will be erased}
    procedure LoadReg(const BaseKey: String);
    {$ENDIF}
    {$ENDIF}
    {$IFNDEF RVDONOTUSEHTML}
    procedure SaveCSSToStream(Stream: TStream; AOptions: TRVSaveCSSOptions);
    function SaveCSS(const FileName: String; AOptions: TRVSaveCSSOptions): Boolean;
    function GetCSSSize(Value: TRVStyleLength): TRVAnsiString;
    {$ENDIF}
    function GetHoverColor(StyleNo: Integer): TColor;

    procedure DrawTextBack(Canvas: TCanvas; ItemNo, StyleNo: Integer;
      RVData: TPersistent; Left, Top, Width, Height: Integer;
      DrawState: TRVTextDrawStates);
    procedure ApplyStyle(Canvas: TCanvas; StyleNo: Integer;
      DefBiDiMode: TRVBiDiMode; CanUseCustomPPI: Boolean;
      ExtraFontInfo: PRVExtraFontInfo; IgnoreSubSuperScript, ToFormatCanvas: Boolean);
    procedure ApplyStyleColor(Canvas: TCanvas; StyleNo: Integer;
      DrawState: TRVTextDrawStates; Printing: Boolean; ColorMode: TRVColorMode);
    procedure DrawStyleText(const s: TRVRawByteString; Canvas: TCanvas;
      ItemNo, OffsetInItem, StyleNo: Integer; RVData: TPersistent;
      SpaceBefore, Left, Top, Width, Height, BaseLine: Integer;
      DrawState: TRVTextDrawStates; Printing, PreviewCorrection: Boolean;
      ColorMode: TRVColorMode; DefBiDiMode: TRVBidiMode;
      RefCanvas: TCanvas);
    procedure DrawCheckpoint(Canvas: TCanvas; X,Y, AreaLeft, Width: Integer;
      RVData: TPersistent; ItemNo, XShift: Integer;
      RaiseEvent: Boolean; Control: TControl);
    procedure DrawPageBreak(Canvas: TCanvas; Y, XShift: Integer;
      PageBreakType: TRVPageBreakType; Control: TControl;
      RVData: TPersistent; ItemNo: Integer);
    procedure DrawParaBack(Canvas: TCanvas; ParaNo: Integer; const Rect: TRect;
      Printing: Boolean; ColorMode: TRVColorMode);
    function StyleHoverSensitive(StyleNo: Integer): Boolean;
    // conversion to other units
    function GetAsPixels(Value: TRVStyleLength): Integer;
    function GetAsDevicePixelsX(Value: TRVStyleLength; PSaD: PRVScreenAndDevice): Integer;
    function GetAsDevicePixelsY(Value: TRVStyleLength; PSaD: PRVScreenAndDevice): Integer;
    function GetAsTwips(Value: TRVStyleLength): Integer;
    function GetAsDifferentUnits(Value: TRVStyleLength; Units: TRVStyleUnits): TRVStyleLength;
    function GetAsPoints(Value: TRVStyleLength): Extended;
    function GetAsRVUnits(Value: TRVStyleLength; RVUnits: TRVUnits): TRVLength;
    // conversion from other units
    function TwipsToUnits(Value: Integer): TRVStyleLength;
    function PixelsToUnits(Value: Integer): TRVStyleLength;
    function DifferentUnitsToUnits(Value: TRVStyleLength; Units: TRVStyleUnits): TRVStyleLength;
    function RVUnitsToUnits(Value: TRVLength; RVUnits: TRVUnits): TRVStyleLength;
    // conversion from Units to other units
    class function GetAsPixelsEx(Value: TRVStyleLength; Units: TRVStyleUnits): Integer;
    class function GetAsTwipsEx(Value: TRVStyleLength; Units: TRVStyleUnits): Integer;
    class function GetAsRVUnitsEx(Value: TRVStyleLength; Units: TRVStyleUnits; RVUnits: TRVUnits): TRVLength;
    // conversion from other units to Units
    class function RVUnitsToUnitsEx(Value: TRVLength; RVUnits: TRVUnits; Units: TRVStyleUnits): TRVStyleLength;
    class function TwipsToUnitsEx(Value: Integer; Units: TRVStyleUnits): TRVStyleLength;
    class function PixelsToUnitsEx(Value: Integer; Units: TRVStyleUnits): TRVStyleLength;
    // conversion betweein other units
    class function RVUnitsToPixels(Value: TRVLength; RVUnits: TRVUnits): Integer;
    class function PixelsToRVUnits(Value: Integer; RVUnits: TRVUnits): TRVLength;
    class function PixelsToTwips(Value: Integer): Integer;
    class function TwipsToPixels(Value: Integer): Integer;
    // converting properties
    procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
    procedure ConvertToTwips;
    procedure ConvertToPixels;
    property DefaultUnicodeStyles: Boolean read FDefaultUnicodeStyles
      write FDefaultUnicodeStyles;
    property GraphicInterface: TRVGraphicInterface read FGraphicInterface;
  published
    { Published declarations }
    property TextStyles:  TFontInfos read FTextStyles  write SetTextStyles;
    property ParaStyles:  TParaInfos read FParaStyles  write SetParaStyles;
    property ListStyles:  TRVListInfos read FListStyles write SetListStyles;
    property SpacesInTab: Integer     read FSpacesInTab write FSpacesInTab   default 0;
    property DefTabWidth: TRVStyleLength  read FDefTabWidth write FDefTabWidth   default 48;
    property JumpCursor:  TCursor    read FJumpCursor  write FJumpCursor    default crJump;
    property LineSelectCursor: TCursor read FLineSelectCursor write FLineSelectCursor default crRVFlipArrow;
    property FullRedraw:  Boolean    read FFullRedraw  write FFullRedraw    default False;
    property UseSound:    Boolean    read FUseSound    write FUseSound      default True;
    property Color:             TColor     read FColor             write FColor             default clWindow;
    property HoverColor:        TColor     read FHoverColor        write FHoverColor        default clNone;
    property CurrentItemColor:  TColor     read FCurrentItemColor  write FCurrentItemColor  default clNone;
    property SelColor:          TColor     read FSelColor          write FSelColor          default clHighlight;
    property SelTextColor:      TColor     read FSelTextColor      write FSelTextColor      default clHighlightText;
    property InactiveSelColor:     TColor  read FInactiveSelColor     write FInactiveSelColor      default clHighlight;
    property InactiveSelTextColor: TColor  read FInactiveSelTextColor write FInactiveSelTextColor  default clHighlightText;
    property CheckpointColor:   TColor     read FCheckpointColor   write FCheckpointColor   default clGreen;
    property CheckpointEvColor: TColor     read FCheckpointEvColor write FCheckpointEvColor default clLime;
    property PageBreakColor:    TColor     read FPageBreakColor    write FPageBreakColor    default clBtnShadow;
    property SoftPageBreakColor: TColor    read FSoftPageBreakColor  write FSoftPageBreakColor default clBtnFace;
    property LiveSpellingColor: TColor     read FLiveSpellingColor write FLiveSpellingColor default clRed;
    property FloatingLineColor: TColor     read FFloatingLineColor write FFloatingLineColor default DEFAULT_FLOATINGLINECOLOR;
    property SpecialCharactersColor: TColor read FSpecialCharactersColor write FSpecialCharactersColor default clNone;

    property SelectionMode: TRVSelectionMode read FSelectionMode write FSelectionMode default rvsmWord;
    property SelectionStyle: TRVSelectionStyle read FSelectionStyle write FSelectionStyle default rvssItems;

    property FieldHighlightColor: TColor read FFieldHighlightColor write FFieldHighlightColor default clBtnFace;
    property FieldHighlightType: TRVFieldHighlightType read FFieldHighlightType write FFieldHighlightType default rvfhCurrent;
    property DisabledFontColor: TColor read FDisabledFontColor write FDisabledFontColor default clNone;

    property FootnoteNumbering: TRVSeqType read FFootnoteNumbering write FFootnoteNumbering default rvseqDecimal;
    property EndnoteNumbering: TRVSeqType read FEndnoteNumbering write FEndnoteNumbering default rvseqLowerRoman;
    property FootnotePageReset: Boolean read FFootnotePageReset write FFootnotePageReset default True;

    property LineWrapMode: TRVLineWrapMode read FLineWrapMode write FLineWrapMode default rvWrapNormal;

    {$IFNDEF RVDONOTUSEUNICODE}
    property DefUnicodeStyle:   Integer    read FDefUnicodeStyle   write FDefUnicodeStyle   default -1;
    {$ENDIF}
    property DefCodePage:      TRVCodePage read FDefCodePage       write FDefCodePage       default CP_ACP;
    property InvalidPicture: TPicture      read GetInvalidPicture    write SetInvalidPicture;
    property Units: TRVStyleUnits read FUnits write FUnits default rvstuPixels;

    property OnApplyStyle: TRVApplyStyleEvent read FOnApplyStyle write FOnApplyStyle;
    property OnAfterApplyStyle: TRVAfterApplyStyleEvent read FOnAfterApplyStyle write FOnAfterApplyStyle;    
    property OnApplyStyleColor: TRVApplyStyleColorEvent read FOnApplyStyleColor write FOnApplyStyleColor;
    property OnDrawStyleText: TRVDrawStyleTextEvent read FOnDrawStyleText write FOnDrawStyleText;
    property OnStyleHoverSensitive: TRVStyleHoverSensitiveEvent read FOnStyleHoverSensitive write FOnStyleHoverSensitive;
    property OnDrawTextBack: TRVDrawTextBackEvent read FOnDrawTextBack write FOnDrawTextBack;
    property OnDrawCheckpoint: TRVDrawCheckpointEvent read FOnDrawCheckpoint write FOnDrawCheckpoint;
    property OnDrawPageBreak: TRVDrawPageBreakEvent read FOnDrawPageBreak write FOnDrawPageBreak;
    property OnDrawParaBack: TRVDrawParaRectEvent read FOnDrawParaBack write FOnDrawParaBack;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    property StyleTemplates: TRVStyleTemplateCollection read FStyleTemplates write SetStyleTemplates;
    {$ENDIF}
  end;

  procedure RVWrite(Stream: TStream; const s: TRVAnsiString);
  procedure RVWriteLn(Stream: TStream; const s: TRVAnsiString);
  procedure RVWriteX(Stream: TStream; const s: TRVAnsiString; Multiline: Boolean);

const
  { default value for TCustomRichView.RTFOptions }
  rvrtfDefault: TRVRTFOptions =
    [rvrtfDuplicateUnicode, rvrtfSaveEMFAsWMF, rvrtfSaveJpegAsJpeg];
  { all properties of TFontInfo }
  RVAllFontInfoProperties: TRVFontInfoProperties =
    [Low(TRVFontInfoProperty)..High(TRVFontInfoProperty)];
  { all properties of TParaInfo }
  RVAllParaInfoProperties: TRVParaInfoProperties =
    [Low(TRVParaInfoProperty)..High(TRVParaInfoProperty)];
  { ...divided into 2 parts }
  RVAllParaInfoProperties1: TRVParaInfoProperties =
    [Low(TRVParaInfoProperty1)..High(TRVParaInfoProperty1)];
  RVAllParaInfoProperties2: TRVParaInfoProperties =
    [Low(TRVParaInfoProperty2)..High(TRVParaInfoProperty2)];
  { all properties of TRVBackgroundRect }
  RVAllParaBackgroundProperties: TRVParaInfoProperties =
    [rvpiBackground_Color..rvpiBackground_BO_Bottom];
  { all properties of TRVBorder }
  RVAllParaBorderProperties: TRVParaInfoProperties =
    [rvpiBorder_Color..rvpiBorder_Vis_Bottom];

  { If True, Standard properties of styles added from inserted RVF will
    be reset to False. }
  RichViewResetStandardFlag: Boolean = True;
  { If True, 'LstId' pseudo-property will not be saved when storing
    list styles in RVF. This pseudo-property allows smarter inserting RVF
    with lists, but does not allow aplications built with older version of
    TRichView to load new RVFs }
  RVNoLstIDProperty: Boolean = False;
  { If True, FindSuchStyle method take StyleName property into account when
    comparing styles }
  RichViewCompareStyleNames: Boolean = False;
  { Visible special characters }
  RVVisibleSpecialCharacters: TRVSpecialCharacters = [rvscSpace..rvcFloatingLines];
  { Paragraph marks in "show special characters" mode }
  RVParagraphMarks: TRVParagraphMarks = rvpmStandard;

procedure RVDrawUnderline(Canvas: TCanvas; UnderlineType: TRVUnderlineType;
  Color: TColor; Left, Right, Y, BaseLineWidth: Integer;
  GraphicInterface: TRVGraphicInterface);
procedure RVDrawHiddenUnderline(Canvas: TCanvas;
  Color: TColor; Left, Right, Y: Integer;
  GraphicInterface: TRVGraphicInterface);  

const
  RVFORMATCANVASFACTOR: Integer = 100;
  RVFORMATCANVASRESOLUTION: Integer = 96*100{RVFORMATCANVASFACTOR};
  ScaleRichViewTextDrawAlwaysUseGlyphs: Boolean = False;
function RVConvertFromFormatCanvas(V: Integer; UseFormatCanvas: Boolean): Integer;
function RVConvertToFormatCanvas(V: Integer; UseFormatCanvas: Boolean): Integer;

implementation
uses RVUni, RVStr, CRVData, CRVFData, RVItem, RVFuncs, RVFMisc;
{==============================================================================}
function RVConvertFromFormatCanvas(V: Integer; UseFormatCanvas: Boolean): Integer;
begin
  if not UseFormatCanvas then
    Result := V
  else
    Result := Round(V / RVFORMATCANVASFACTOR);
end;
{------------------------------------------------------------------------------}
function RVConvertToFormatCanvas(V: Integer; UseFormatCanvas: Boolean): Integer;
begin
  if not UseFormatCanvas then
    Result := V
  else
    Result := V * RVFORMATCANVASFACTOR;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
const arrNoYes: array [False..True] of String = (RVINIFILENO,RVINIFILEYES);
{ Write integer Value to ini only if it is not equal to DefValue               }
procedure WriteIntToIniIfNE(ini: TRVIniFile; const Section, Key: String;
  Value, DefValue: Integer);
begin
  if Value<>DefValue then
    ini.WriteInteger(Section, Key, Value);
end;
{------------------------------------------------------------------------------}
{ Write boolean Value to ini only if it is not equal to DefValue.
  Value is written as "Yes" or "No"                                            }
procedure WriteBoolToIniIfNE(ini: TRVIniFile; const Section, Key: String;
                               Value, DefValue: Boolean);
begin
  if Value<>DefValue then
    ini.WriteString(Section, Key, arrNoYes[Value]);
end;
{------------------------------------------------------------------------------}
{ Read boolean value ("Yes"/"No" from ini                                      }
function IniReadBool(ini: TRVIniFile; const Section, Key: String;
                        DefValue: Boolean): Boolean;
begin
  Result := UpperCase(ini.ReadString(Section, Key, arrNoYes[DefValue]))=RVINIFILEYESU;
end;
{------------------------------------------------------------------------------}
{ Writing long string to ini. String is splitted on parts by 500 characters.
  String is written in keys Key+'_'+number. Number is 0-based                  }
procedure WriteLongStringToINI(ini: TRVIniFile; const Section, Key, Value: String);
var l,i: Integer;
    s: String;
begin
  i := 0;
  l := 500;
  while l<Length(Value) do begin
    s := Copy(Value, l-500+1, 500);
    ini.WriteString(Section, Key+'_'+IntToStr(i), s);
    inc(i);
    inc(l,500);
  end;
  s := Copy(Value, l-500+1, Length(Value));
  if s<>'' then
    ini.WriteString(Section, Key+'_'+IntToStr(i), s);
end;
{------------------------------------------------------------------------------}
{ Reading strings saved with WriteLongStringToINI                              }
function ReadLongStringFromINI(ini: TRVIniFile; const Section, Key: String): String;
var i: Integer;
    s: String;
begin
  Result := '';
  i := 0;
  while True do begin
    s := ini.ReadString(Section, Key+'_'+IntToStr(i), '');
    if s='' then
      break;
    Result := Result+s;
    inc(i);
  end;
end;
{------------------------------------------------------------------------------}
{ Encoding font styles in string                                               }
function FontStylesToString(Styles: TFontStyles): String;
begin
  Result := '';
  if fsBold in Styles then
    Result := Result + 'B';
  if fsItalic in Styles then
    Result := Result + 'I';
  if fsUnderline in Styles then
    Result := Result + 'U';
  if fsStrikeOut in Styles then
    Result := Result + 'S';
end;
{------------------------------------------------------------------------------}
{ Decoding string in font styles                                               }
function StringToFontStyles(const Styles: string): TFontStyles;
var i: Integer;
begin
  Result := [];
  for i := 1 to Length(Styles) do
    case Styles[i] of
      'B','b':
        Include(Result, fsBold);
      'I','i':
        Include(Result, fsItalic);
      'U','u':
        Include(Result, fsUnderline);
      'S','s':
        Include(Result, fsStrikeOut);
    end;
end;
{------------------------------------------------------------------------------}
{ Encoding font in string like "Arial,8,BI,0,clWindowText,0"                   }
function FontToString(Font: TFont): String;
begin
  with Font do
    Result := Format('%s,%d,%s,%d,%s,%d', [Name, Height,
      FontStylesToString(Style), Ord(Pitch), ColorToString(Color),
      {$IFDEF RICHVIEWCBDEF3} Charset {$ELSE} 0 {$ENDIF}]);
end;
{------------------------------------------------------------------------------}
{ Decoding string created with FontToString                                    }
procedure StringToFont(const s: string; Font: TFont);
var
  i,j, State: Integer;
  s2: string;
begin
  i := 1;
  State := 1;
  while i<=Length(s) do begin
    j := i;
    while (j<=Length(s)) and (s[j]<>',') do
      inc(j);
    if (j<=Length(s)) and (s[j]=',') then begin
      s2 := Copy(s, i, j-i);
      i := j+1;
      end
    else begin
      s2 := Copy(s, i, j-i+1);
      i := j;
    end;
    case State of
      1: Font.Name := s2;
      2: Font.Height := StrToInt(s2);
      3: Font.Style := StringToFontStyles(s2);
      4: Font.Pitch := TFontPitch(StrToInt(s2));
      5: Font.Color := StringToColor(s2);
      {$IFDEF RICHVIEWCBDEF3}
      6: Font.Charset := TFontCharset(StrToInt(s2));
      {$ENDIF}
    end;
    inc(State);
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Are rectangles r1 and r2 equal? }
function AreRectsEqual(const r1,r2: TRect): Boolean;
begin
  Result := (r1.Left=r2.Left) and (r1.Top=r2.Top) and
    (r1.Bottom=r2.Bottom) and (r1.Right=r2.Right);
end;
{------------------------------------------------------------------------------}
procedure ScaleRect(var R: TRect; sad: TRVScreenAndDevice);
begin
  exit;
  R.Left   := MulDiv(R.Left,   sad.ppixDevice, sad.ppixScreen);
  R.Right  := MulDiv(R.Right,  sad.ppixDevice, sad.ppixScreen);
  R.Top    := MulDiv(R.Top,    sad.ppiyDevice, sad.ppiyScreen);
  R.Bottom := MulDiv(R.Bottom, sad.ppiyDevice, sad.ppiyScreen);
end;
(*
{------------------------------------------------------------------------------}
procedure IniSavePen(ini: TRVIniFile; const Section,Key: String; Pen: TPen;
                     DefStyle: TPenStyle; DefColor: TColor);
begin
  WriteIntToIniIfNE(ini, Section, Key+'Style', ord(Pen.Style), ord(DefStyle));
  WriteIntToIniIfNE(ini, Section, Key+'Color', Pen.Color,      DefColor);
  WriteIntToIniIfNE(ini, Section, Key+'Width', Pen.Width,      1);
  WriteIntToIniIfNE(ini, Section, Key+'Mode',  ord(Pen.Mode),  ord(pmCopy));
end;
{------------------------------------------------------------------------------}
procedure IniLoadPen(ini: TRVIniFile; const Section,Key: String; Pen: TPen;
                     DefStyle: TPenStyle; DefColor: TColor);
begin
  Pen.Style := TPenStyle(ini.ReadInteger(Section, Key+'Style', ord(DefStyle)));
  Pen.Color := ini.ReadInteger(Section, Key+'Color', DefColor);
  Pen.Width := ini.ReadInteger(Section, Key+'Width', 1);
  Pen.Mode  := TPenMode(ini.ReadInteger(Section, Key+'Mode', ord(pmCopy)));
end;
*)
{=========================== TCustomRVInfo ====================================}
{ Constructor }
constructor TCustomRVInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FBaseStyleNo  := -1;
  FStandard     := True;
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  FStyleTemplateId := -1;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Assigns properties of Source to Self, if source is TCustomRVInfo }
procedure TCustomRVInfo.Assign(Source: TPersistent);
begin
  if Source is TCustomRVInfo then begin
    FName        := TCustomRVInfo(Source).FName;
    FBaseStyleNo := TCustomRVInfo(Source).FBaseStyleNo;
    FStandard    := TCustomRVInfo(Source).FStandard;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    FStyleTemplateId := TCustomRVInfo(Source).FStyleTemplateId;
    {$ENDIF}
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
function TCustomRVInfo.IsSimpleEqual(Value: TCustomRVInfo;
  IgnoreReferences: Boolean; IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVInfo.IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
function TCustomRVInfo.SimilarityValue(Value: TCustomRVInfo): Integer;
begin
  Result := 0;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads properties from the ini-file, from the section Section.
  fs is a format string for keys, it is like 'Font%s1', 'Font%s2', etc.
  DefName is a default style name.                                             }
procedure TCustomRVInfo.LoadFromINI(ini: TRVIniFile; const Section,
  fs, DefName: String);
begin
  StyleName   := ini.ReadString (Section, Format(fs,[RVINI_STYLENAME]), DefName);
  BaseStyleNo := ini.ReadInteger(Section, Format(fs,[RVINI_BASESTYLENO]), -1);
  Standard    := Boolean(ini.ReadInteger(Section, Format(fs,[RVINI_STANDARD]), Integer(True)));
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  StyleTemplateId := ini.ReadInteger(Section, Format(fs,[RVINI_STYLETEMPLATEID]), -1);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Saves properties to the ini-file, in the section Section, using the format
  string fs for keys. }
procedure TCustomRVInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  ini.WriteString(Section,  Format(fs,[RVINI_STYLENAME]), StyleName);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_BASESTYLENO]),BaseStyleNo,-1);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_STANDARD]), Integer(Standard), Integer(True));
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_STYLETEMPLATEID]), StyleTemplateId, -1);
  {$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Returns a name of the collection item, for design-time collection editor. }
function TCustomRVInfo.GetDisplayName: String;
begin
  Result := FName;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVInfo.GetRVStyle: TRVStyle;
begin
  if Collection=nil then
    Result := nil
  else
    Result :=  TRVStyle(TCustomRVInfos(Collection).FOwner);
end;
{============================= TCustomRVInfos =================================}
{ Constructor }
constructor TCustomRVInfos.Create(ItemClass: TCollectionItemClass;
                                  Owner: TPersistent);
begin
  inherited Create(ItemClass);
  FOwner := Owner;
end;
{------------------------------------------------------------------------------}
{ Allows assigning properties to TStrings: style names are assigned. }
procedure TCustomRVInfos.AssignTo(Dest: TPersistent);
var i: Integer;
begin
  if Dest is TStrings then begin
    TStrings(Dest).Clear;
    for i:=0 to Count-1 do
      TStrings(Dest).Add(TCustomRVInfo(Items[i]).FName);
    end
  else
    inherited AssignTo(Dest);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ For designtime collection editor. }
function TCustomRVInfos.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Adds items from Styles according to the method specified in the Mode.
  Mapping is filled: on exit, Mapping.Count = Styles.Count, and
  Mapping[i] is an index of the item of this collection which was created basing
  on Styles[i].
  Reference properties (BaseStyleNo, NextStyleNo, NextParaNo, DefStyleNo) are
  adjusted in the added items.
  If the global variable RichViewResetStandardFlag is True (default), Standard
  properties of all added styles are set to False.
  This method assumes that Styles have the same type as Self.
  Notes:
  * in rvs_merge_Map mode:
    - SimilarityValue method of items is used;
    - the method tries to keep Jump and Unicode properties if possible.
  * in rvs_merge_SmartMerge mode:
    - the method tries to map the style to the style with the same index,
      if possible;
    - IsSimpleEqualEx method of items is used;
    - several styles can be mapped in the same style, except for numbered lists:
      they are always mapped to the unique style.
}
procedure TCustomRVInfos.MergeWith(Styles: TCustomRVInfos;
  Mode: TRVStyleMergeMode; Mapping: TRVIntegerList;
  TextStyleMapping: TRVIntegerList; RVData: TPersistent);
var i,j,idx,oldcount: Integer;
    Style: TCustomRVInfo;
    wht, maxwht: Integer;
    ForbiddenStyles: TRVIntegerList;
    {.............................................}
    procedure AdjustReferences;
    var i: Integer;
        Style: TCustomRVInfo;
    begin
      for i := oldcount to Count-1 do begin
        Style := TCustomRVInfo(Items[i]);
        if RichViewResetStandardFlag then
          Style.Standard := False;
        if Style.BaseStyleNo>=0 then
          Style.BaseStyleNo := Mapping[Style.BaseStyleNo];
        if (Style is TFontInfo) and (TFontInfo(Style).NextStyleNo>=0) then
          TFontInfo(Style).NextStyleNo := Mapping[TFontInfo(Style).NextStyleNo];
        if (Style is TParaInfo) then begin
          if (TParaInfo(Style).NextParaNo>=0) then
            TParaInfo(Style).NextParaNo := Mapping[TParaInfo(Style).NextParaNo];
          if (TParaInfo(Style).DefStyleNo>=0) and (TextStyleMapping<>nil) then
            TParaInfo(Style).DefStyleNo :=
              TextStyleMapping[TParaInfo(Style).DefStyleNo];
        end;
      end;
    end;
    {.............................................}
begin
  Mapping.Clear;
  Mapping.Capacity := Styles.Count;
  oldcount := Count;
  case Mode of
    rvs_merge_Append: // Append one collection to another
      for i := 0 to Styles.Count-1 do begin
        Mapping.Add(Count);
        Add.Assign(Styles.Items[i]);
        if RVData<>nil then
          TCustomRVData(RVData).AfterAddStyle(TCustomRVInfo(Items[Count-1]));
      end;
    rvs_merge_Map: // Use the most similar of existing styles. Do not add styles
      for i := 0 to Styles.Count-1 do begin
        Style := TCustomRVInfo(Styles.Items[i]);
        maxwht := 0;
        idx := -1;
        if (Style is TFontInfo) then begin
          {$IFNDEF RVDONOTUSEUNICODE}
          for j := 0 to Count-1 do
            if (TFontInfo(Items[j]).Jump=TFontInfo(Style).Jump) and
               (TFontInfo(Items[j]).Unicode=TFontInfo(Style).Unicode) then begin
              wht := Style.SimilarityValue(TFontInfo(Items[j]));
              if (idx=-1) or (wht>maxwht) then begin
                maxwht := wht;
                idx := j;
              end;
            end;
          {$ENDIF}
          if idx=-1 then
            for j := 0 to Count-1 do
              if (TCustomRVFontInfo(Items[j]).Jump=TCustomRVFontInfo(Style).Jump) then begin
                wht := Style.SimilarityValue(TCustomRVInfo(Items[j]));
                if (idx=-1) or (wht>maxwht) then begin
                  maxwht := wht;
                  idx := j;
                end;
              end;
          {$IFNDEF RVDONOTUSEUNICODE}
          if idx=-1 then
            for j := 0 to Count-1 do
              if (TFontInfo(Items[j]).Unicode=TFontInfo(Style).Unicode) then begin
                wht := Style.SimilarityValue(TCustomRVInfo(Items[j]));
                if (idx=-1) or (wht>maxwht) then begin
                  maxwht := wht;
                  idx := j;
                end;
              end;
          {$ENDIF}
        end;
        if idx=-1 then
          for j := 0 to Count-1 do begin
            wht := Style.SimilarityValue(TCustomRVInfo(Items[j]));
            if (idx=-1) or (wht>maxwht) then begin
              maxwht := wht;
              idx := j;
            end;
          end;
        Mapping.Add(idx);
      end;
    rvs_merge_SmartMerge: // Reuse styles, add if necessary
      begin
        if Self is TRVListInfos then
          ForbiddenStyles := TRVIntegerList.Create
        else
          ForbiddenStyles := nil;
        for i := 0 to Styles.Count-1 do begin
          idx := -1;
          Style := TCustomRVInfo(Styles.Items[i]);
          if (i<Count) and Style.IsSimpleEqualEx(TCustomRVInfo(Items[i]), Mapping) and
             ((ForbiddenStyles=nil) or (ForbiddenStyles.IndexOf(Pointer(i))<0)) then
            idx := i;
          if idx<0 then
            for j := 0 to Count-1 do
              if Style.IsSimpleEqualEx(TCustomRVInfo(Items[j]), Mapping) and
                ((ForbiddenStyles=nil) or (ForbiddenStyles.IndexOf(Pointer(j))<0)) then begin
                idx := j;
                break;
              end;
          if idx<0 then begin
            idx := Count;
            Add.Assign(Styles.Items[i]);
            if Self is TRVListInfos then
              TRVListInfo(Items[idx]).FListID := TRVListInfo(Styles.Items[i]).ListID;
            if RVData<>nil then
              TCustomRVData(RVData).AfterAddStyle(TCustomRVInfo(Items[idx]));
          end;
          Mapping.Add(idx);
          if ForbiddenStyles<>nil then begin
            if TRVListInfo(Style).HasNumbering then
              ForbiddenStyles.Add(idx);
          end;
        end;
        ForbiddenStyles.Free;
      end;
  end;
  AdjustReferences;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVInfos.ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
var i: Integer;
begin
  for i := 0 to Count-1 do
    TCustomRVInfo(Items[i]).ConvertToDifferentUnits(NewUnits);
end;
{=========================== TCustomRVFontInfo ================================}
{ Constructor }
constructor TCustomRVFontInfo.Create(Collection: TCollection);
begin
 inherited Create(Collection);
 FFontName  := RVDEFAULTSTYLEFONT;
 FSize      := 10;
 FColor     := clWindowText;
 FBackColor := clNone;
 FHoverBackColor := clNone;
 FHoverColor := clNone;
 FStyle     := [];
 FStyleEx   := [];
 {$IFDEF RICHVIEWCBDEF3}
 FCharset   := DEFAULT_CHARSET;
 {$ENDIF}
 Jump       := False;
 JumpCursor := crJump;
 FName      := RVDEFAULTTEXTSTYLENAME;
 FVShift    := 0;
 FCharScale    := 100;
 FUnderlineColor := clNone;
 FHoverUnderlineColor := clNone;
end;
{------------------------------------------------------------------------------}
{ Assigns properties of Source to Self, if it is TCustomRVFontInfo or TFont.   }
procedure TCustomRVFontInfo.Assign(Source: TPersistent);
begin
  if Source is TCustomRVFontInfo then begin
      FFontName   := TCustomRVFontInfo(Source).FFontName;
      FSize       := TCustomRVFontInfo(Source).FSize;
      FColor      := TCustomRVFontInfo(Source).FColor;
      FBackColor  := TCustomRVFontInfo(Source).FBackColor;
      FHoverBackColor  := TCustomRVFontInfo(Source).FHoverBackColor;
      FHoverColor  := TCustomRVFontInfo(Source).FHoverColor;
      FHoverEffects := TCustomRVFontInfo(Source).FHoverEffects;
      FStyle      := TCustomRVFontInfo(Source).FStyle;
      FStyleEx    := TCustomRVFontInfo(Source).FStyleEx;
      {$IFDEF RICHVIEWCBDEF3}
      FCharset    := TCustomRVFontInfo(Source).FCharset;
      {$ENDIF}
      {$IFDEF RVLANGUAGEPROPERTY}
      FLanguage   := TCustomRVFontInfo(Source).FLanguage;
      {$ENDIF}
      FJump       := TCustomRVFontInfo(Source).FJump;
      FJumpCursor := TCustomRVFontInfo(Source).FJumpCursor;
      FProtection := TCustomRVFontInfo(Source).FProtection;
      FOptions    := TCustomRVFontInfo(Source).FOptions;
      FVShift     := TCustomRVFontInfo(Source).FVShift;
      FCharScale  := TCustomRVFontInfo(Source).FCharScale;
      FCharSpacing := TCustomRVFontInfo(Source).FCharSpacing;
      FBiDiMode   := TCustomRVFontInfo(Source).FBiDiMode;
      FSubSuperScriptType := TCustomRVFontInfo(Source).FSubSuperScriptType;
      FUnderlineType := TCustomRVFontInfo(Source).UnderlineType;
      FUnderlineColor := TCustomRVFontInfo(Source).FUnderlineColor;
      FHoverUnderlineColor := TCustomRVFontInfo(Source).FHoverUnderlineColor;
      inherited Assign(Source);
    end
  else if Source is TFont then begin
      FFontName := TFont(Source).Name;
      FSize     := TFont(Source).Size;
      FColor    := TFont(Source).Color;
      FStyle    := TFont(Source).Style;
      {$IFDEF RICHVIEWCBDEF3}
      FCharset  := TFont(Source).Charset;
      {$ENDIF}
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Allows assigning properties to TFont. }
procedure TCustomRVFontInfo.AssignTo(Dest: TPersistent);
begin
  if Dest is TFont then begin
      TFont(Dest).Name    := FFontName;
      TFont(Dest).Size    := FSize;
      TFont(Dest).Color   := FColor;
      TFont(Dest).Style   := FStyle;
      {$IFDEF RICHVIEWCBDEF3}
      TFont(Dest).Charset := FCharset;
      {$ENDIF}
    end
  else
    inherited AssignTo(Dest);
end;
{------------------------------------------------------------------------------}
{ Assigns properties listed in Props to Self. }
procedure TCustomRVFontInfo.AssignSelectedProperties(
  Source: TCustomRVFontInfo; Props: TRVFontInfoProperties);
   {.............................................................}
   procedure ChangeFontStyle(FontStyle: TFontStyle; TextPropId: TRVFontInfoProperty);
   begin
     if TextPropId in Props then
       if FontStyle in Source.Style then
         Style := Style+[FontStyle]
       else
         Style := Style-[FontStyle];
   end;
   {.............................................................}
   procedure ChangeFontStyleEx(FontStyle: TRVFontStyle; TextPropId: TRVFontInfoProperty);
   begin
     if TextPropId in Props then
       if FontStyle in Source.StyleEx then
         StyleEx := StyleEx+[FontStyle]
       else
         StyleEx := StyleEx-[FontStyle];
   end;
   {.............................................................}
   procedure ChangeHoverEffect(Effect: TRVHoverEffect; TextPropId: TRVFontInfoProperty);
   begin
     if TextPropId in Props then
       if Effect in Source.HoverEffects then
         HoverEffects := HoverEffects+[Effect]
       else
         HoverEffects := HoverEffects-[Effect];
   end;
   {.............................................................}
   procedure ChangeTextOption(TextOption: TRVTextOption; TextOptionId: TRVFontInfoProperty);
   begin
     if TextOptionId in Props then
       if TextOption in Source.Options then
         Options := Options+[TextOption]
       else
         Options := Options-[TextOption];
   end;
   {.............................................................}
begin
  if (rvfiFontName in Props) then
    FontName := Source.FontName;
  if (rvfiSize in Props) then
    Size     := Source.Size;
  {$IFDEF RICHVIEWCBDEF3}
  if (rvfiCharset in Props) then
    Charset  := Source.Charset;
  {$ENDIF}
  ChangeFontStyle(fsBold,      rvfiBold);
  ChangeFontStyle(fsItalic,    rvfiItalic);
  ChangeFontStyle(fsUnderline, rvfiUnderline);
  ChangeFontStyle(fsStrikeOut, rvfiStrikeOut);
  ChangeFontStyleEx(rvfsOverline, rvfiOverline);
  ChangeFontStyleEx(rvfsAllCaps, rvfiAllCaps);
  if (rvfiVShift in Props) then
    VShift := Source.VShift;
  if (rvfiColor in Props) then
    Color := Source.Color;
  if (rvfiBackColor in Props) then
    BackColor := Source.BackColor;
  if (rvfiJump in Props) then
    Jump := Source.Jump;
  if (rvfiHoverBackColor in Props) then
    HoverBackColor := Source.HoverBackColor;
  if (rvfiHoverColor in Props) then
    HoverColor := Source.HoverColor;
   ChangeHoverEffect(rvheUnderline, rvfiHoverUnderline);
  if (rvfiJumpCursor in Props) then
    JumpCursor := Source.JumpCursor;
  if (rvfiProtection in Props) then
    Protection := Source.Protection;
  if (rvfiCharScale in Props) then
    CharScale := Source.CharScale;
  if (rvfiBiDiMode in Props) then
    BiDiMode := Source.BiDiMode;
  if (rvfiCharSpacing in Props) then
    CharSpacing := Source.CharSpacing;
  if (rvfiSubSuperScriptType in Props) then
    SubSuperScriptType := Source.SubSuperScriptType;
  if (rvfiUnderlineType in Props) then
    UnderlineType := Source.UnderlineType;
  if (rvfiUnderlineColor in Props) then
    UnderlineColor := Source.UnderlineColor;
  if (rvfiHoverUnderlineColor in Props) then
    HoverUnderlineColor := Source.HoverUnderlineColor;
  ChangeTextOption(rvteoHTMLCode, rvfiHTMLCode);
  ChangeTextOption(rvteoRTFCode,  rvfiRTFCode);
  ChangeTextOption(rvteoHidden,  rvfiHidden);  
  {$IFDEF RVLANGUAGEPROPERTY}
  if (rvfiLanguage in Props) then
    Language := Source.Language;
  {$ENDIF}
  { rvfiBaseStyleNo, rvfiNextStyleNo - not assigned }
  { rvfiUnicode ??? }
end;
{------------------------------------------------------------------------------}
{ Assigns properties to TLogFont record. If CanUseCustomPPI and
  TextStyles.PixelsPerInch is nonzero, it is used instead of
  Canvas.Font.PixelsPerInch,
  If ExcludeUnderline=True, underline is not assigned. }
procedure TCustomRVFontInfo.AssignToLogFont(var LogFont: TLogFont; Canvas: TCanvas;
  CanUseCustomPPI: Boolean; ExcludeUnderline, ToFormatCanvas: Boolean);
var ppi: Integer;
begin
  FillChar(LogFont, sizeof(LogFont), 0);
  with LogFont do begin
    if ToFormatCanvas then
      lfHeight := -MulDiv(Size, RVFORMATCANVASRESOLUTION, 72)
    else begin
      ppi := 0;
      if CanUseCustomPPI and (Collection<>nil) then
        ppi := TFontInfos(Collection).PixelsPerInch;
      if ppi=0 then
        ppi := Canvas.Font.PixelsPerInch;
      lfHeight := -MulDiv(Size, ppi, 72);
    end;
    if fsBold in Style then
      lfWeight := FW_BOLD
    else
      lfWeight := FW_NORMAL;
    lfItalic := Byte(fsItalic in Style);
    lfUnderline := Byte((fsUnderline in Style) and not ExcludeUnderline);
    lfStrikeOut := Byte(fsStrikeOut in Style);
    {$IFDEF RICHVIEWCBDEF3}
    lfCharSet := Byte(Charset);
    {$ENDIF}
    StrPCopy(lfFaceName, FontName);
    lfQuality := DEFAULT_QUALITY;
    lfOutPrecision := OUT_DEFAULT_PRECIS;
    lfClipPrecision := CLIP_DEFAULT_PRECIS;
    lfPitchAndFamily := DEFAULT_PITCH;
  end;
end;
{------------------------------------------------------------------------------}
{ Is this item equal to Value (all properties are equal)?
  if IgnoreReferences=True, NextStyleNo property is ignored, otherwise they
  must be equal.
  IgnoreID is not used (used only in TRVListInfo). }
function TCustomRVFontInfo.IsSimpleEqual(Value: TCustomRVInfo;
  IgnoreReferences, IgnoreID: Boolean): Boolean;
begin
   Result := (Size        = TCustomRVFontInfo(Value).Size   ) and
             {$IFDEF RICHVIEWCBDEF3}
             (Charset     = TCustomRVFontInfo(Value).Charset) and
             {$ENDIF}
             (Style       = TCustomRVFontInfo(Value).Style  ) and
             (StyleEx     = TCustomRVFontInfo(Value).StyleEx) and
             (AnsiCompareText(FontName, TCustomRVFontInfo(Value).FontName)=0) and
             (VShift      = TCustomRVFontInfo(Value).VShift ) and
             (Color       = TCustomRVFontInfo(Value).Color  ) and
             (BackColor   = TCustomRVFontInfo(Value).BackColor) and
             (Jump        = TCustomRVFontInfo(Value).Jump   ) and
             {$IFDEF RVLANGUAGEPROPERTY}
             (Language     = TCustomRVFontInfo(Value).Language) and
             {$ENDIF}
             (not Jump or
              ((HoverColor     = TCustomRVFontInfo(Value).HoverColor) and
               (HoverEffects   = TCustomRVFontInfo(Value).HoverEffects) and
               (HoverBackColor = TCustomRVFontInfo(Value).HoverBackColor) and
               (HoverUnderlineColor = TCustomRVFontInfo(Value).HoverUnderlineColor) and
               (JumpCursor     = TCustomRVFontInfo(Value).JumpCursor))
             ) and
             (Protection  = TCustomRVFontInfo(Value).Protection ) and
             (Options     = TCustomRVFontInfo(Value).Options )    and
             (CharScale   = TCustomRVFontInfo(Value).CharScale  ) and
             (CharSpacing = TCustomRVFontInfo(Value).CharSpacing) and
             (BiDiMode    = TCustomRVFontInfo(Value).BiDiMode  ) and
             (SubSuperScriptType = TCustomRVFontInfo(Value).SubSuperScriptType) and
             (UnderlineType = TCustomRVFontInfo(Value).UnderlineType) and
             (UnderlineColor = TCustomRVFontInfo(Value).UnderlineColor) and                          
             (not RichViewCompareStyleNames or (StyleName=TCustomRVFontInfo(Value).StyleName));
end;
{------------------------------------------------------------------------------}
{ Calculates a similarity value between Self and Value.
  The larger value means more similar. }
function TCustomRVFontInfo.SimilarityValue(Value: TCustomRVInfo): Integer;
var fs: TFontStyle;
    he: TRVHoverEffect;
    Wht: Integer;
begin
   if GetRVStyle.Units = rvstuPixels then
     Wht := 1
   else
     Wht := 15;
   Result :=
     RV_CompareInts(TCustomRVFontInfo(Value).Size, Size, RVSMW_FONTSIZE)+
     RV_CompareInts(TCustomRVFontInfo(Value).VShift, VShift, RVSMW_VSHIFTRATIO)+
     RV_CompareInts(TCustomRVFontInfo(Value).CharScale, CharScale, RVSMW_CHARSCALE)+
     RV_CompareInts(TCustomRVFontInfo(Value).CharSpacing, CharSpacing, RVSMW_CHARSPACING div Wht)+
     RV_CompareColors(TCustomRVFontInfo(Value).Color, Color, RVSMW_EACHRGBCOLOR, RVSMW_COLORSET)+
     RV_CompareColors(TCustomRVFontInfo(Value).BackColor, BackColor, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET);
   if TCustomRVFontInfo(Value).BiDiMode=BiDiMode then
     inc(Result, RVSMW_TEXTBIDIMODE);
   if TCustomRVFontInfo(Value).SubSuperScriptType=SubSuperScriptType then
     inc(Result, RVSMW_SUBSUPERSCRIPTTYPE);
   if AnsiCompareText(TCustomRVFontInfo(Value).FontName, FontName)=0 then
     inc(Result, RVSMW_FONTNAME);
   for fs := Low(TFontStyle) to High(TFontStyle) do
     if (fs in TCustomRVFontInfo(Value).Style) = (fs in Style) then
       inc(Result, RVSMW_FONTEACHSTYLE);
   if (rvfsOverline in TCustomRVFontInfo(Value).StyleEx)=(rvfsOverline in StyleEx) then
     inc(Result, RVSMW_OVERLINE);
   if (rvfsAllCaps in TCustomRVFontInfo(Value).StyleEx)=(rvfsAllCaps in StyleEx) then
     inc(Result, RVSMW_OVERLINE);
   if ((TCustomRVFontInfo(Value).Style=[]) and (TCustomRVFontInfo(Value).StyleEx=[]))
      =
      ((Style=[]) and (StyleEx=[])) then
     inc(Result, RVSMW_FONTSTYLESET);

   {$IFDEF RVLANGUAGEPROPERTY}
   if TCustomRVFontInfo(Value).Language = Language then
     inc(Result, RVSMW_LANGUAGE);
   {$ENDIF}

   if Jump and TCustomRVFontInfo(Value).Jump then begin
     for he := Low(TRVHoverEffect) to High(TRVHoverEffect) do
       if (he in TCustomRVFontInfo(Value).HoverEffects) = (he in HoverEffects) then
         inc(Result, RVSMW_HOVEREACHEFFECT);
     if TCustomRVFontInfo(Value).JumpCursor=JumpCursor then
       inc(Result, RVSMW_CURSOR);
     inc(Result,
         RV_CompareColors(TCustomRVFontInfo(Value).HoverColor,HoverColor, RVSMW_EACHRGBCOLOR, RVSMW_COLORSET) div 2+
         RV_CompareColors(TCustomRVFontInfo(Value).HoverBackColor,HoverBackColor, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET) div 2);
   end;
   if TCustomRVFontInfo(Value).Protection<>Protection then
     dec(Result, RVSMW_PROTECTION);
   if (rvteoHTMLCode in TCustomRVFontInfo(Value).Options)=(rvteoHTMLCode in Options) then
     inc(Result, RVSMW_SPECIALCODE);
   if (rvteoRTFCode in TCustomRVFontInfo(Value).Options)=(rvteoRTFCode in Options) then
     inc(Result, RVSMW_SPECIALCODE);
   if (rvteoHidden in TCustomRVFontInfo(Value).Options)=(rvteoHidden in Options) then
     inc(Result, RVSMW_HIDDEN);
  {$IFDEF RICHVIEWCBDEF3}
  if Charset=TCustomRVFontInfo(Value).Charset then
    inc(Result, RVSMW_FONTCHARSET)
  else
    if (Charset=DEFAULT_CHARSET) or
       (TCustomRVFontInfo(Value).Charset=DEFAULT_CHARSET) then
      inc(Result, RVSMW_FONTCHARSET div 4);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Is this item equal to Value?
  Equality is determined by comparing all properties NOT included in IgnoreList. } 
function TCustomRVFontInfo.IsEqual(Value: TCustomRVFontInfo; IgnoreList: TRVFontInfoProperties): Boolean;
begin
   Result := ((rvfiSize        in IgnoreList) or (Size        = Value.Size       )) and
             {$IFDEF RICHVIEWCBDEF3}
             ((rvfiCharset     in IgnoreList) or (Charset     = Value.Charset    )) and
             {$ENDIF}
             ((rvfiBold        in IgnoreList) or ((fsBold       in Style)   = (fsBold       in Value.Style  ))) and
             ((rvfiItalic      in IgnoreList) or ((fsItalic     in Style)   = (fsItalic     in Value.Style  ))) and
             ((rvfiUnderline   in IgnoreList) or ((fsUnderline  in Style)   = (fsUnderline  in Value.Style  ))) and
             ((rvfiStrikeout   in IgnoreList) or ((fsStrikeout  in Style)   = (fsStrikeout  in Value.Style  ))) and
             ((rvfiOverline    in IgnoreList) or ((rvfsOverline in StyleEx) = (rvfsOverline in Value.StyleEx))) and
             ((rvfiAllCaps     in IgnoreList) or ((rvfsAllCaps  in StyleEx) = (rvfsAllCaps  in Value.StyleEx))) and
             ((rvfiFontName    in IgnoreList) or (AnsiCompareText(FontName,Value.FontName)=0)) and
             ((rvfiVShift      in IgnoreList) or (VShift      = Value.VShift     )) and
             ((rvfiColor       in IgnoreList) or (Color       = Value.Color      )) and
             ((rvfiBackColor   in IgnoreList) or (BackColor   = Value.BackColor  )) and
             ((rvfiJump        in IgnoreList) or (Jump        = Value.Jump       )) and
             {$IFDEF RVLANGUAGEPROPERTY}
             ((rvfiLanguage    in IgnoreList) or (Language    = Value.Language   )) and
             {$ENDIF}
             (not Jump or
             ((rvfiHoverColor     in IgnoreList) or (HoverColor     = Value.HoverColor   )) and
             ((rvfiHoverBackColor in IgnoreList) or (HoverBackColor = Value.HoverBackColor)) and
             ((rvfiHoverUnderline in IgnoreList) or ((rvheUnderline in HoverEffects) = (rvheUnderline in Value.HoverEffects))) and
             ((rvfiJumpCursor     in IgnoreList) or (JumpCursor     = Value.JumpCursor))
             ) and
             ((rvfiProtection  in IgnoreList) or (Protection  = Value.Protection)) and
             ((rvfiHidden      in IgnoreList) or ((rvteoHidden in Options)  = (rvteoHidden in Value.Options))) and             
             ((rvfiRTFCode     in IgnoreList) or ((rvteoRTFCode in Options)  = (rvteoRTFCode in Value.Options))) and
             ((rvfiHTMLCode    in IgnoreList) or ((rvteoHTMLCode in Options) = (rvteoHTMLCode in Value.Options))) and
             ((rvfiCharScale   in IgnoreList) or (CharScale  = Value.CharScale)) and
             ((rvfiCharSpacing in IgnoreList) or (CharSpacing  = Value.CharSpacing)) and
             ((rvfiBiDiMode    in IgnoreList) or (BiDiMode  = Value.BiDiMode)) and
             ((rvfiSubSuperScriptType in IgnoreList) or (SubSuperScriptType  = Value.SubSuperScriptType)) and
             ((rvfiUnderlineType in IgnoreList) or (UnderlineType  = Value.UnderlineType)) and
             ((rvfiUnderlineColor in IgnoreList) or (UnderlineColor  = Value.UnderlineColor)) and
             ((rvfiHoverUnderlineColor in IgnoreList) or (HoverUnderlineColor  = Value.HoverUnderlineColor)) and                                       
             ((rvfiBaseStyleNo in IgnoreList) or (BaseStyleNo = Value.BaseStyleNo));
   if Result and RichViewCompareStyleNames then
     Result := StyleName=Value.StyleName;
end;
{------------------------------------------------------------------------------}
{ Calculates sub/superscript height }
function TCustomRVFontInfo.GetScriptHeight(Canvas: TCanvas;
  GraphicInterface: TRVGraphicInterface): Integer;
var potm: POutlineTextmetric;
begin
  Result := 0;
  if SubSuperScriptType=rvsssNormal then
    exit;
  potm := RV_GetOutlineTextMetrics(Canvas, GraphicInterface);
  if potm<>nil then
    try
      case SubSuperScriptType of
        rvsssSubscript:
          Result := potm.otmptSubscriptSize.Y;
        rvsssSuperscript:
          Result := potm.otmptSuperscriptSize.Y;
      end;
      if Result<(potm.otmTextMetrics.tmHeight div 3) then
        Result := potm.otmTextMetrics.tmHeight div 3;
    finally
      FreeMem(potm);
    end
  else begin
    Result := Abs(Round(Canvas.Font.Height*2/3));
  end;
end;
{------------------------------------------------------------------------------}
{ Applies this text style to the Canvas. Colors are not applied, see ApplyColor.
  DefBiDiMode is a bi-di mode of paragraph containing text item of this style.
  Notes:
  - if FCharScale=100, this method assigns Canvas.Font properties,
     otherwise it assigns Canvas.Font.Handle.
  - if FCharScale<>100, underline is not applied (will be drawn manually).
  - if CanUseCustomPPI and owning collection is defined and has nonzero
    PixelsPerInch property, font size is assigned according to this PixelsPerInch.
}
procedure TCustomRVFontInfo.Apply(Canvas: TCanvas; DefBiDiMode: TRVBiDiMode;
  CanUseCustomPPI: Boolean; ExtraFontInfo: PRVExtraFontInfo;
  IgnoreSubSuperScript, ToFormatCanvas: Boolean;
  GraphicInterface: TRVGraphicInterface);
var LogFont: TLogFont;
    ppi, h: Integer;
    tm: TTextMetric;
    Font: TFont;
begin
{$IFNDEF RVDONOTUSECHARSCALE}
  if FCharScale=100 then begin
{$ENDIF}
    Font := Canvas.Font;
    if Font.Style<>Style then
      Font.Style := Style;
    if ToFormatCanvas then
      Font.Height := - MulDiv(Size, RVFORMATCANVASRESOLUTION, 72)
    else begin
      ppi := 0;
      if CanUseCustomPPI and (Collection<>nil) then
        ppi := TFontInfos(Collection).PixelsPerInch;
      if ppi=0 then begin
        //if Font.Size<>Size then
          Font.Size := Size
        end
      else begin
        h := - MulDiv(Size, ppi, 72);
        //if Font.Height<>h then
          Font.Height := h;
      end;
    end;
    // If Charscale is used, we need to recreate font handle when applying
    // a font style. Assigning Font.Name recreates in all version of Delphi
    // Assigning Font.Height (or Size) only in Delphi prior to 2007.

    // So we need not to apply the same font name (so we activate the next "if")
    // in the following cases:
    // - either in Delphi prior to 2007
    // - or CharScale is not used
    {$IFNDEF RICHVIEWDEF2007}
    if AnsiCompareText(Font.Name,FontName)<>0 then
    {$ELSE}
    {$IFDEF RVDONOTUSECHARSCALE}
    if AnsiCompareText(Font.Name,FontName)<>0 then
    {$ENDIF}
    {$ENDIF}
      Font.Name := FontName;
    {$IFDEF RICHVIEWCBDEF3}
    if Font.CharSet<>CharSet then
      Font.CharSet  := CharSet;
    {$ENDIF}
    if not IgnoreSubSuperScript and (SubSuperScriptType<>rvsssNormal) then begin
      if ExtraFontInfo=nil then
        Font.Height := -GetScriptHeight(Canvas, GraphicInterface)
      else
        Font.Height := -ExtraFontInfo.ScriptHeight;
    end;
{$IFNDEF RVDONOTUSECHARSCALE}
    end
  else begin
    AssignToLogFont(LogFont, Canvas, CanUseCustomPPI, True, ToFormatCanvas);
    GraphicInterface.SetLogFont(Canvas, LogFont);
    if not IgnoreSubSuperScript and (SubSuperScriptType<>rvsssNormal) then begin
      if ExtraFontInfo=nil then
        LogFont.lfHeight := -GetScriptHeight(Canvas, GraphicInterface)
      else
        LogFont.lfHeight := -ExtraFontInfo.ScriptHeight;
      GraphicInterface.SetLogFont(Canvas, LogFont);
    end;
    if GraphicInterface.GetTextMetrics(Canvas, tm) then
      LogFont.lfWidth := tm.tmAveCharWidth*FCharScale div 100
    else
      LogFont.lfWidth := GraphicInterface.TextWidth(Canvas, 'x')*FCharScale div 100;
    GraphicInterface.SetLogFont(Canvas, LogFont);
  end;
{$ENDIF}
  ApplyBiDiMode(Canvas, DefBiDiMode, ToFormatCanvas, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Applies BiDiMode and CharSpacing to Canvas }
procedure TCustomRVFontInfo.ApplyBiDiMode(Canvas: TCanvas; DefBiDiMode: TRVBiDiMode;
  ToFormatCanvas: Boolean; GraphicInterface: TRVGraphicInterface);
begin
  if BiDiMode<>rvbdUnspecified then
    DefBiDiMode := BiDiMode;
  case DefBiDiMode of
    rvbdLeftToRight:
      begin
        {$IFNDEF RVDONOTUSECHARSPACING}
        GraphicInterface.SetTextCharacterExtra(Canvas, 0);
        {$ENDIF}
        GraphicInterface.SetTextAlign(Canvas, TA_LEFT);
      end;
    rvbdRightToLeft:
      begin
        {$IFNDEF RVDONOTUSECHARSPACING}
        GraphicInterface.SetTextCharacterExtra(Canvas, 0);
        {$ENDIF}
        GraphicInterface.SetTextAlign(Canvas, TA_RTLREADING);
      end;
    else begin
      {$IFNDEF RVDONOTUSECHARSPACING}
      if ToFormatCanvas then
        GraphicInterface.SetTextCharacterExtra(Canvas, GetRVStyle.GetAsPixels(FCharSpacing) *RVFORMATCANVASFACTOR)
      else
        GraphicInterface.SetTextCharacterExtra(Canvas, GetRVStyle.GetAsPixels(FCharSpacing));
      {$ENDIF}
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ Applies color properties of this style to the Canvas.
  Colors depend on values in DrawState (specifically: rvtsSelected, rvtsHover,
  rvtsControlFocused).
  ColorMode is used to adjust colors. }
procedure TCustomRVFontInfo.ApplyColor(Canvas: TCanvas; RVStyle: TRVStyle;
  DrawState: TRVTextDrawStates; Printing: Boolean; ColorMode: TRVColorMode);
begin
  if (rvtsHover in DrawState) and (rvheUnderline in HoverEffects) then
    Canvas.Font.Style := Canvas.Font.Style+[fsUnderline];
  if rvtsSelected in DrawState then begin
    Canvas.Brush.Style := bsSolid;
    if rvtsControlFocused in DrawState then
      Canvas.Brush.Color := RVStyle.SelColor
    else
      Canvas.Brush.Color := RVStyle.InactiveSelColor;
    {$IFDEF RVUSETEXTHOVERCOLORWITHSELECTED}
    if rvtsHover in DrawState then begin
      Canvas.Font.Color := RVStyle.GetHoverColorByColor(HoverColor);
      if Canvas.Font.Color=clNone then
        Canvas.Font.Color := Color;
      end
    else
    {$ENDIF}
    if rvtsControlFocused in DrawState  then
      Canvas.Font.Color := RVStyle.SelTextColor
    else
      Canvas.Font.Color := RVStyle.InactiveSelTextColor;
    if Canvas.Font.Color=clNone then
      Canvas.Font.Color  := Color;
    end
  else begin
    if rvtsHover in DrawState then begin
       if (rvtstControlDisabled in DrawState) and (RVStyle.DisabledFontColor<>clNone) then
         Canvas.Font.Color  := RVStyle.DisabledFontColor
       else begin
         Canvas.Font.Color  := RVStyle.GetHoverColorByColor(HoverColor);
         if Canvas.Font.Color=clNone then
           Canvas.Font.Color := Color;
       end;
       Canvas.Brush.Color := HoverBackColor;
       end
     else if not Printing then begin
       if (rvtstControlDisabled in DrawState) and (RVStyle.DisabledFontColor<>clNone) then
         Canvas.Font.Color  := RVStyle.DisabledFontColor
       else
         Canvas.Font.Color  := Color;
       Canvas.Brush.Color := BackColor;
       end
     else
       case ColorMode of
         rvcmColor:
           begin
             Canvas.Font.Color  := Color;
             Canvas.Brush.Color := BackColor;
           end;
         rvcmPrinterColor:
           begin
             Canvas.Font.Color  := RV_GetPrnColor(Color);
             Canvas.Brush.Color := RV_GetPrnColor(BackColor);
           end;
         rvcmGrayScale:
           begin
             Canvas.Font.Color  := RV_GetGray(RV_GetPrnColor(Color));
             Canvas.Brush.Color := RV_GetGray(RV_GetPrnColor(BackColor));
           end;
         rvcmBlackAndWhite:
           begin
             if BackColor=clNone then begin
               Canvas.Brush.Color := clNone;
               if RV_GetPrnColor(Color)<>clWhite then
                 Canvas.Font.Color  := clBlack
               else
                 Canvas.Font.Color  := clWhite;
               end
             else if RV_GetLuminance(RV_GetPrnColor(BackColor))>RV_GetLuminance(RV_GetPrnColor(Color)) then begin
               Canvas.Brush.Color := clWhite;
               Canvas.Font.Color := clBlack;
               end
             else begin
               Canvas.Brush.Color := clBlack;
               Canvas.Font.Color := clWhite;
             end;
           end;
         rvcmBlackOnWhite:
           begin
             Canvas.Font.Color  := clBlack;
             Canvas.Brush.Color := clNone;
           end;
       end;
  end;
  if Canvas.Brush.Color=clNone then
    Canvas.Brush.Style := bsClear
  else
    Canvas.Brush.Style := bsSolid;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
const IniProtectMask = $3FF;
{ Loads properties from the ini-file, from the section Section.
  fs is a format string for keys, it is like 'Font%s1', 'Font%s2', etc.
  DefName is a default style name.
  JumpByDefault - for backward compatibility, defines if this style should be
  hypertext if this is not explicitly specified in the ini-file.
  DefJumpCursor - hypertext cursor assigned to this style if, if another
  cursor is not specified in the ini-file explicitly.
}
procedure TCustomRVFontInfo.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String; JumpByDefault: Boolean; DefJumpCursor: TCursor);
var s: String;
    pr: Word;
begin
  inherited LoadFromINI(ini, Section, fs, RVDEFAULTTEXTSTYLENAME);
  FontName   := ini.ReadString (Section, Format(fs,[RVINI_FONTNAME]),  RVDEFAULTSTYLEFONT);
  s := UpperCase(ini.ReadString(Section, Format(fs,[RVINI_JUMP]),      RVINIUNKNOWN));
  if (s=RVINIUNKNOWN) then begin // for compatibility with old saving format
    Jump := JumpByDefault;
    JumpCursor := DefJumpCursor;
    end
  else begin
    Jump       := (s=RVINIFILEYESU);
    JumpCursor := ini.ReadInteger(Section, Format(fs,[RVINI_JUMPCURSOR]), crJump);
  end;
  Size       := ini.ReadInteger(Section, Format(fs,[RVINI_SIZE]),        10);
  Color      := ini.ReadInteger(Section, Format(fs,[RVINI_COLOR]),       clWindowText);
  BackColor  := ini.ReadInteger(Section, Format(fs,[RVINI_BACKCOLOR]),   clNone);
  HoverBackColor  := ini.ReadInteger(Section, Format(fs,[RVINI_HOVERBACKCOLOR]), clNone);
  HoverColor := ini.ReadInteger(Section, Format(fs,[RVINI_HOVERCOLOR]), clNone);
  FHoverEffects := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_HOVERUNDERLINE]), False) then
    Include(FHoverEffects, rvheUnderline);
  {$IFDEF RICHVIEWCBDEF3}
  Charset    := ini.ReadInteger(Section, Format(fs,[RVINI_CHARSET]),    DEFAULT_CHARSET);
  {$ENDIF}
  {$IFDEF RVLANGUAGEPROPERTY}
  Language := ini.ReadInteger(Section, Format(fs,[RVINI_LANGUAGE]), 0);
  {$ENDIF}
  CharScale  := ini.ReadInteger(Section, Format(fs,[RVINI_CHARSCALE]),  100);
  CharSpacing := ini.ReadInteger(Section, Format(fs,[RVINI_CHARSPACING]),  0);
  BiDiMode   := TRVBiDiMode(ini.ReadInteger(Section, Format(fs,[RVINI_BIDIMODE]),  0));
  Style    := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_BOLD]), False) then
    Include(FStyle, fsBold);
  if IniReadBool(ini, Section, Format(fs,[RVINI_UNDERLINE]), False) then
    Include(FStyle, fsUnderline);
  if IniReadBool(ini, Section, Format(fs,[RVINI_STRIKEOUT]), False) then
    Include(FStyle, fsStrikeOut);
  if IniReadBool(ini, Section, Format(fs,[RVINI_ITALIC]), False) then
    Include(FStyle, fsItalic);
  StyleEx  := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_OVERLINE]), False) then
    Include(FStyleEx, rvfsOverline);
  if IniReadBool(ini, Section, Format(fs,[RVINI_ALLCAPS]), False) then
    Include(FStyleEx, rvfsAllCaps);
  FOptions  := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_HIDDEN]), False) then
    Include(FOptions, rvteoHidden);
  if IniReadBool(ini, Section, Format(fs,[RVINI_RTFCODE]), False) then
    Include(FOptions, rvteoRTFCode);
  if IniReadBool(ini, Section, Format(fs,[RVINI_HTMLCODE]), False) then
    Include(FOptions, rvteoHTMLCode);
  pr := ini.ReadInteger(Section, Format(fs,[RVINI_PROTECTION]), 0) and IniProtectMask;
  Protection := TRVProtectOptions(pr);
  if iniReadBool(ini, Section, Format(fs,[RVINI_SINGLESYMBOLS]), False) then begin
    Include(FProtection, rvprStyleProtect);
    Include(FProtection, rvprDoNotAutoSwitch);
  end;
  VShift := ini.ReadInteger(Section, Format(fs,[RVINI_VSHIFT]),      0);
  SubSuperScriptType := TRVSubSuperScriptType(ini.ReadInteger(Section, Format(fs,[RVINI_SCRIPT]), ord(rvsssNormal)));
  UnderlineType := TRVUnderlineType(ini.ReadInteger(Section, Format(fs,[RVINI_UNDERLINETYPE]), ord(rvutNormal)));
  UnderlineColor := ini.ReadInteger(Section, Format(fs,[RVINI_UNDERLINECOLOR]), clNone);
  HoverUnderlineColor := ini.ReadInteger(Section, Format(fs,[RVINI_HOVERUNDERLINECOLOR]), clNone);    
end;
{------------------------------------------------------------------------------}
{ Saves properties to the ini-file, to the section Section.
  fs is a format string for keys, it is like 'Font%s1', 'Font%s2', etc. }
procedure TCustomRVFontInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  inherited SaveToINI(ini, Section, fs);
  ini.WriteString(Section,  Format(fs,[RVINI_FONTNAME]),       FontName);
  ini.WriteString(Section,  Format(fs,[RVINI_JUMP]),       arrNoYes[Jump]);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_SIZE]),       Size,       10);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_COLOR]),      Color,      clWindowText);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_BACKCOLOR]),  BackColor,  clNone);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_HOVERBACKCOLOR]), HoverBackColor, clNone);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_HOVERCOLOR]), HoverColor, clNone);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_HOVERUNDERLINE]), rvheUnderline in HoverEffects, False);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_JUMPCURSOR]), JumpCursor, crJump);
  {$IFDEF RICHVIEWCBDEF3}
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_CHARSET]),    Charset,    DEFAULT_CHARSET);
  {$ENDIF}
  WriteIntToIniIfNE(ini, Section,  Format(fs,[RVINI_CHARSCALE]),  CharScale,  100);
  WriteIntToIniIfNE(ini, Section,  Format(fs,[RVINI_CHARSPACING]), CharSpacing,  0);  
  WriteIntToIniIfNE(ini, Section,  Format(fs,[RVINI_BiDiMode]),  ord(BiDiMode),  0);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_BOLD]),      fsBold      in Style, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_UNDERLINE]), fsUnderline in Style, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_STRIKEOUT]), fsStrikeOut in Style, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_ITALIC]),    fsItalic    in Style, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_OVERLINE]),  rvfsOverline in StyleEx, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_ALLCAPS]),   rvfsAllCaps in StyleEx, False);
  WriteIntToIniIfNE(ini, Section,  Format(fs,[RVINI_PROTECTION]), Word(Protection) and IniProtectMask, 0);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_HIDDEN]),     rvteoHidden  in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_RTFCODE]),    rvteoRTFCode  in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_HTMLCODE]),   rvteoHTMLCode  in Options, False);
  WriteIntToIniIfNE(ini, Section,  Format(fs,[RVINI_VSHIFT]),     VShift,     0);
  {$IFDEF RVLANGUAGEPROPERTY}
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LANGUAGE]),Language,0);
  {$ENDIF}
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_SCRIPT]), ord(SubSuperScriptType), ord(rvsssNormal));
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_UNDERLINETYPE]), ord(UnderlineType), ord(rvutNormal));
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_UNDERLINECOLOR]), UnderlineColor, clNone);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_HOVERUNDERLINECOLOR]), HoverUnderlineColor, clNone);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function GetHTMLDirection(BiDiMode: TRVBiDiMode): TRVAnsiString;
begin
  case BiDiMode of
    rvbdLeftToRight:
      Result := 'ltr';
    rvbdRightToLeft:
      Result := 'rtl';
    else
      Result := 'inherit';
  end;
end;
{------------------------------------------------------------------------------}
function GetTextDecoration(TextStyle: TCustomRVFontInfo; Hover: Boolean): TRVAnsiString;
  {.................................}
  procedure AddVal(Condition: Boolean; var s: TRVAnsiString;
    const Value: TRVAnsiString);
  begin
    if Condition then begin
      if s<>'' then
        s := s+' ';
      s := s+Value;
    end;
  end;
  {.................................}
var IncludeUnderline: Boolean;
begin
  Result := '';
  IncludeUnderline := (fsUnderline in TextStyle.Style) or
    (Hover and (rvheUnderline in TextStyle.HoverEffects));
  if IncludeUnderline and
    ((TextStyle.UnderlineType<>rvutNormal) or
     (TextStyle.UnderlineColor<>clNone) or
     (TextStyle.HoverUnderlineColor<>clNone)) then
    IncludeUnderline := False;
  AddVal(IncludeUnderline, Result, 'underline');
  AddVal(fsStrikeOut in TextStyle.Style,    Result, 'line-through');
  AddVal(rvfsOverline in TextStyle.StyleEx, Result, 'overline');
  if Result='' then
    Result := 'none'
end;
{------------------------------------------------------------------------------}
function GetCSSUnderlineBorder(UnderlineType: TRVUnderlineType;
  FontSize: Integer): TRVAnsiString;
var Width: Integer;
begin
  Width := RVGetDefaultUnderlineWidth(FontSize);
  case UnderlineType of
    rvutThick:
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('solid %dpx', [Width*2]);
    rvutDouble:
      Result := 'double';
    rvutDotted:
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('dotted %dpx', [Width]);
    rvutThickDotted:
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('dotted %dpx', [Width*2]);
    rvutDashed, rvutLongDashed, rvutDashDotted, rvutDashDotDotted:
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('dashed %dpx', [Width]);
    rvutThickDashed, rvutThickLongDashed, rvutThickDashDotted, rvutThickDashDotDotted:
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('dashed %dpx', [Width*2]);
    else
      Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('solid %dpx', [Width]);;
  end;
end;
{------------------------------------------------------------------------------}
function GetCustomUnderlineCSS(TextStyle: TCustomRVFontInfo;
  Hover: Boolean): TRVAnsiString;
var Color: TColor;
    IncludeUnderline: Boolean;
begin
  Result := '';
  IncludeUnderline := (fsUnderline in TextStyle.Style) or
    (Hover and (rvheUnderline in TextStyle.HoverEffects));
  if IncludeUnderline then begin
    Color := TextStyle.UnderlineColor;
    if Hover and (TextStyle.HoverUnderlineColor<>clNone) then
      Color := TextStyle.HoverUnderlineColor;
    if (TextStyle.UnderlineType<>rvutNormal) or (Color<>clNone) or
       (TextStyle.HoverUnderlineColor<>clNone) then
      Result := GetCSSUnderlineBorder(TextStyle.UnderlineType, TextStyle.Size);
    if Color<>clNone then
      RV_AddStrA(Result, RV_GetHTMLRGBStr(Color, False));
    if Result<>'' then
      Result := 'border-bottom: '+Result
    //else if Hover then
    //  Result := 'border-bottom: none';
  end;
end;
{------------------------------------------------------------------------------}
{ Saves this text style as a part of CSS to the Stream.
  if BaseStyle<>nil, only a difference between this style and BaseStyle is
  saved.
  If Multiline=False, all text will be written on a single line. }
type
  TFontFamily = record
    N1: string;
    N2: string;
  end;
const
  cFontArial = 'Arial';
  cFontArialBlack = 'Arial Black';
  cFontArialUnicodeMS = 'Arial Unicode MS';
  cFontBookAntiqua = 'Book Antiqua';
  cFontCharcoal = 'Charcoal';
  cFontComicSansMS = 'Comic Sans MS';
  cFontCourier = 'Courier';
  cFontCourierNew = 'Courier New';
  cFontGadget = 'Gadget';
  cFontGeneva = 'Geneva';
  cFontGeorgia = 'Georgia';
  cFontHelvetica = 'Helvetica';
  cFontImpact = 'Impact';
  cFontLucidaConsole = 'Lucida Console';
  cFontMonaco = 'Monaco';
  cFontMSSansSerif = 'MS Sans Serif';
  cFontMSSerif = 'MS Serif';
  cFontNewYork = 'New York';
  cFontPalatinoLinotype = 'Palatino Linotype';
  cFontPalatino = 'Palatino';
  cFontTahoma = 'Tahoma';
  cFontTimes = 'Times';
  cFontTimesNewRoman = 'Times New Roman';
  cFontTrebuchetMS = 'Trebuchet MS';
  cFontVerdana = 'Verdana';

  cStyleCursive = 'cursive';
  cStyleFantasy = 'fantasy';
  cStyleMonospace = 'monospace';
  cStyleSansSerif = 'sans-serif';
  cStyleSerif = 'serif';

  QCQ = ''', ''';
  QC =  ''', ';

  FontFamilies: array[0..15] of TFontFamily = (
    (N1: cFontArial;             N2: ''''+cFontArial        +QCQ+cFontHelvetica+QC+cStyleSansSerif;),
    (N1: cFontTrebuchetMS;       N2: ''''+cFontTrebuchetMS  +QCQ+cFontHelvetica+QC+cStyleSansSerif;),
    (N1: cFontTimesNewRoman;     N2: ''''+cFontTimesNewRoman+QCQ+cFontTimes    +QC+cStyleSerif;),
    (N1: cFontVerdana;           N2: ''''+cFontVerdana      +QCQ+cFontGeneva   +QC+cStyleSansSerif;),
    (N1: cFontTahoma;            N2: ''''+cFontTahoma       +QCQ+cFontGeneva   +QC+cStyleSansSerif;),
    (N1: cFontMSSansSerif;       N2: ''''+cFontMSSansSerif  +QCQ+cFontGeneva   +QC+cStyleSansSerif;),
    (N1: cFontArialBlack;        N2: ''''+cFontArialBlack   +QCQ+cFontGadget   +QC+cStyleSansSerif;),
    (N1: cFontMSSerif;           N2: ''''+cFontMSSerif      +QCQ+cFontNewYork  +QC+cStyleSerif;),
    (N1: cFontBookAntiqua;       N2: ''''+cFontBookAntiqua  +QCQ+cFontPalatino +QC+cStyleSerif;),
    (N1: cFontPalatinoLinotype;  N2: ''''+cFontPalatinoLinotype+QCQ+cFontPalatino+QC+cStyleSerif;),
    (N1: cFontGeorgia;           N2: ''''+cFontGeorgia                         +QC+cStyleSerif;),
    (N1: cFontLucidaConsole;     N2: ''''+cFontLucidaConsole+QCQ+cFontMonaco   +QC+cStyleMonospace;),
    (N1: cFontCourierNew;        N2: ''''+cFontCourierNew   +QCQ+cFontCourier  +QC+cStyleMonospace;),
    (N1: cFontComicSansMS;       N2: ''''+cFontComicSansMS                     +QC+cStyleCursive;),
    (N1: cFontImpact;            N2: ''''+cFontImpact       +QCQ+cFontCharcoal +QC+cStyleFantasy;),
    (N1: cFontArialUnicodeMS;    N2: ''''+cFontArialUnicodeMS+QCQ+cFontArial+QCQ+cFontHelvetica+QC+cStyleSansSerif;)
  );

procedure TCustomRVFontInfo.SaveCSSToStream(Stream: TStream; BaseStyle: TCustomRVFontInfo;
  Multiline, UTF8: Boolean);
const
    cssFontStyle  : array[Boolean] of TRVAnsiString = ('normal','italic');
    cssFontWeight : array[Boolean] of TRVAnsiString = ('normal','bold');
    {..................................................}
    function GetTextVAlign(FontStyle: TCustomRVFontInfo): TRVAnsiString;
    begin
      case FontStyle.SubSuperScriptType of
        rvsssSubscript:
          Result := 'sub';
        rvsssSuperScript:
          Result := 'super';
        else
          begin
            if FontStyle.VShift>0 then
              Result := 'super'
            else if FontStyle.VShift<0 then
              Result := 'sub'
            else
              Result := '';
          end;
      end;
    end;
    {..................................................}
    function GetTextSize(FontStyle: TCustomRVFontInfo): Integer;
    begin
      Result := FontStyle.Size;
      if FontStyle.SubSuperScriptType<>rvsssNormal then
        Result := RV_GetDefSubSuperScriptSize(Result);
    end;
    {..................................................}
    function GetFontFamily(const FontName: String): String;
    var i: Integer;
    begin
      for i := Low(FontFamilies) to High(FontFamilies) do
        if AnsiCompareText(FontName, FontFamilies[i].N1) = 0 then begin
          Result := FontFamilies[i].N2;
          exit;
        end;
      Result := ''''+FontName+'''';
    end;
    {..................................................}
    {
    function GetFontFamily(const FontName: String): String;
    begin
      if (AnsiCompareText(FontName,'Arial')=0) or
         (AnsiCompareText(FontName,'Trebuchet MS')=0) then
        Result := ''''+FontName+''', ''Helvetica'', sans-serif'
      else if (AnsiCompareText(FontName,'Times New Roman')=0) then
        Result := '''Times New Roman'', ''Times'', serif'
      else if (AnsiCompareText(FontName,'Verdana')=0) or
        (AnsiCompareText(FontName,'Tahoma')=0) or
        (AnsiCompareText(FontName,'MS Sans Serif')=0) then
        Result := ''''+FontName+''', ''Geneva'', sans-serif'
      else if (AnsiCompareText(FontName,'Arial Black')=0) then
        Result := '''Arial Black'', ''Gadget'', sans-serif'
      else if (AnsiCompareText(FontName,'MS Serif')=0) then
        Result := '''MS Serif'', ''New York'', serif'
      else if (AnsiCompareText(FontName,'Book Antiqua')=0) or
       (AnsiCompareText(FontName,'Palatino Linotype')=0) then
        Result := ''''+FontName+''', ''Palatino'', serif'
      else if (AnsiCompareText(FontName,'Georgia')=0) then
        Result := '''Georgia'', serif'
      else if (AnsiCompareText(FontName,'Lucida Console')=0) then
        Result := '''Lucida Console'', ''Monaco'', monospace'
      else if (AnsiCompareText(FontName,'Courier New')=0) then
        Result := '''Courier New'', ''Courier'', monospace'
      else if (AnsiCompareText(FontName,'Comic Sans MS')=0) then
        Result := '''Comic Sans MS'', cursive'
      else if (AnsiCompareText(FontName,'Impact')=0) then
        Result := '''Impact'', ''Charcoal'', fantasy'
      else if (AnsiCompareText(FontName,'Arial Unicode MS')=0) then
        Result := '''Arial Unicode MS'', ''Arial'', ''Helvetica'', sans-serif'
      else
        Result := ''''+FontName+'''';
    end;
    }
    {..................................................}
var s: TRVAnsiString;
begin
  if (BaseStyle=nil) or (GetTextSize(BaseStyle)<>GetTextSize(Self)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' font-size: %dpt;',[GetTextSize(Self)]), Multiline);
  if (rvteoHidden in Options) and ((BaseStyle=nil) or not (rvteoHidden in BaseStyle.Options)) then
    RVWriteX(Stream, ' display: none;', Multiline);
  if ((BaseStyle=nil) and (BiDiMode<>rvbdUnSpecified)) or
     ((BaseStyle<>nil) and (BiDiMode<>BaseStyle.BiDiMode)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' direction: %s;',[GetHTMLDirection(BiDiMode)]), Multiline);
  if (BaseStyle=nil) or (AnsiCompareText(BaseStyle.FontName, FontName)<>0) then begin
    s := StringToHTMLString3(GetFontFamily(FontName), UTF8, CP_ACP);
    if AnsiCompareText(FontName, RVFONT_SYMBOL)=0 then
      s := '''Arial Unicode MS'', ''Lucida Sans Unicode'', ''Arial'', ''Helvetica'', sans-serif';
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' font-family: %s;',[s]), Multiline);
  end;
  if (BaseStyle=nil) or ((fsItalic in BaseStyle.Style)<>(fsItalic in Style)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' font-style: %s;',[cssFontStyle[fsItalic in Style]]),
      Multiline);
  if (BaseStyle=nil) or ((fsBold in BaseStyle.Style)<>(fsBold in Style)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' font-weight: %s;',[cssFontWeight[fsBold in Style]]),
      Multiline);
  if (BaseStyle=nil) or (BaseStyle.Color<>Color) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' color: %s;',[RV_GetHTMLRGBStr(Color, False)]), Multiline);
  if ((BaseStyle=nil) and (CharSpacing<>0)) or
     ((BaseStyle<>nil) and (BaseStyle.CharSpacing<>CharSpacing)) then
     RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
       Format(' letter-spacing: %s;',[GetRVStyle.GetCSSSize(CharSpacing)]), Multiline);
  if (rvfsAllCaps in StyleEx) then begin
    if (BaseStyle=nil) or not (rvfsAllCaps in BaseStyle.StyleEx) then
      RVWriteX(Stream, ' text-transform: uppercase;', Multiline);
    end
  else if (BaseStyle<>nil) and (rvfsAllCaps in BaseStyle.StyleEx) then
      RVWriteX(Stream, ' text-transform: none;', Multiline);
  if ((BaseStyle=nil) and ((BackColor<>clNone) or not Multiline)) or
     ((BaseStyle<>nil) and (BaseStyle.BackColor<>BackColor)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' background-color: %s;',[RV_GetCSSBkColor(BackColor)]),
      Multiline);
  s := GetTextVAlign(Self);
  if ((BaseStyle=nil) and (s<>'')) or
     ((BaseStyle<>nil) and
      (s<>GetTextVAlign(BaseStyle))) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' vertical-align: %s;',[s]), Multiline);
  s := GetTextDecoration(Self, False);
  if (BaseStyle=nil) or
     (s<>GetTextDecoration(BaseStyle, False))
     or (Jump and (s='none')) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' text-decoration: %s;',[s]), Multiline);
  s := GetCustomUnderlineCSS(Self, False);
  if (s<>'') and ((BaseStyle=nil) or
     (s<>GetCustomUnderlineCSS(BaseStyle, False))) then
    RVWriteX(Stream, ' '+s+';', Multiline);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
{ Saving RTF code for the given text style }
procedure TCustomRVFontInfo.SaveRTFToStream(Stream: TStream; StyleNo: Integer;
      TwipsPerPixel: Double; StyleToFont, ColorTable: TRVIntegerList);
var idx: Integer;
  {$IFDEF RICHVIEWCBDEF3}
  {$IFNDEF RVLANGUAGEPROPERTY}
  ALanguage: Cardinal;
  {$ENDIF}
  {$ENDIF}
  {.....................................................................}
  function GetUnderlineKeyword: TRVAnsiString;
  begin
    case UnderlineType of
      rvutThick:
        Result := 'ulth';
      rvutDouble:
        Result := 'uldb';
      rvutDotted:
        Result := 'uld';
      rvutThickDotted:
        Result := 'ulthd';
      rvutDashed:
        Result := 'uldash';
      rvutThickDashed:
        Result := 'ulthdash';
      rvutLongDashed:
        Result := 'ulldash';
      rvutThickLongDashed:
        Result := 'ulthldash';
      rvutDashDotted:
        Result := 'uldashd';
      rvutThickDashDotted:
        Result := 'ulthdashd';
      rvutDashDotDotted:
        Result := 'uldashdd';
      rvutThickDashDotDotted:
        Result := 'ulthdashdd';      
      else
        Result := 'ul';
    end;
  end;
  {.....................................................................}
begin
  RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('\f%d', [StyleToFont.Items[StyleNo]]));
  if fsBold in Style then
    RVFWrite(Stream, '\b');
  if fsItalic in Style then
    RVFWrite(Stream, '\i');
  if fsUnderline in Style then begin
    RVFWrite(Stream, '\'+GetUnderlineKeyword);
    if UnderlineColor<>clNone then begin
      idx := ColorTable.IndexOf(Pointer(UnderlineColor));
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('\ulc%d', [idx]));
    end;
  end;
  if fsStrikeOut in Style then
    RVFWrite(Stream, '\strike');
  case SubSuperScriptType of
    rvsssSubscript:
      RVFWrite(Stream, '\sub');
    rvsssSuperScript:
      RVFWrite(Stream, '\super');
  end;
  if VShift>0 then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\up%d', [Round((VShift*Size)/50)]))
  else if VShift<0 then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\dn%d', [-Round((VShift*Size)/50)]));
  if CharScale<>100 then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\charscalex%d',[CharScale]));
  if CharSpacing<>0 then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\expndtw%d',[GetRVStyle.GetAsTwips(CharSpacing)]));
  if rvfsAllCaps in StyleEx then
    RVFWrite(Stream, '\caps');
  case BiDiMode of
    rvbdLeftToRight:
      RVFWrite(Stream, '\ltrch');
    rvbdRightToLeft:
      RVFWrite(Stream, '\rtlch');
  end;
  {$IFDEF RICHVIEWCBDEF3}
  {$IFDEF RVLANGUAGEPROPERTY}
  if (Language<>0) and
     ((Collection=nil) or
      (Language<>TCustomRVFontInfo(Collection.Items[0]).Language)) then
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\lang%d', [Language]));
  {$ELSE}
  if (Charset<>DEFAULT_CHARSET) and
     ((Collection=nil) or
      (Charset<>TCustomRVFontInfo(Collection.Items[0]).Charset)) then begin
    ALanguage := RVU_Charset2Language(Charset);
    if ALanguage<>0 then
      RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('\lang%d', [ALanguage]));
  end;
  {$ENDIF}
  {$ENDIF}
  if rvteoHidden in Options then
    RVFWrite(Stream, '\v');
  RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
    Format('\fs%d', [Size*2]));
  if BackColor<>clNone then begin
    idx := ColorTable.IndexOf(Pointer(BackColor));
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\chcbpat%d', [idx]));
  end;
  if Color<>clWindowText then begin
    idx := ColorTable.IndexOf(Pointer(Color));
    RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('\cf%d', [idx]));
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Method for backward compatibility:
  allows loading the deleted SingleSymbols property. }
procedure TCustomRVFontInfo.DefineProperties(Filer: TFiler);
begin
  Filer.DefineProperty(RVINI_SINGLESYMBOLS, SingleSymbolsReader, nil, False);
end;
{------------------------------------------------------------------------------}
{ Method for backward compatibility:
  loads the deleted SingleSymbols property as [rvprStyleProtect, rvprDoNotAutoSwitch]
  Protection options. }
procedure TCustomRVFontInfo.SingleSymbolsReader(reader: TReader);
var ss: Boolean;
begin
  ss := reader.ReadBoolean;
  if ss then begin
    Include(FProtection, rvprStyleProtect);
    Include(FProtection, rvprDoNotAutoSwitch);
  end;
end;
{------------------------------------------------------------------------------}
// Converts all sizes from RVStyle.Units to NewUnits
procedure TCustomRVFontInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
begin
  CharSpacing := GetRVStyle.GetAsDifferentUnits(CharSpacing, NewUnits);
end;
{================================= TFontInfo ==================================}
{ Constructor }
constructor TFontInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FNextStyleNo := -1;
  {$IFDEF RICHVIEWDEF2009}
  if (Collection=nil) or not (Collection is TFontInfos) or
    (TFontInfos(Collection).Owner=nil) or
    not (TFontInfos(Collection).Owner is TRVStyle) or
    TRVStyle(TFontInfos(Collection).Owner).DefaultUnicodeStyles then
    Unicode := True;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TFontInfo.Assign(Source: TPersistent);
begin
  if Source is TFontInfo then begin
    FNextStyleNo:= TFontInfo(Source).FNextStyleNo;
    {$IFNDEF RVDONOTUSEUNICODE}
    FUnicode    := TFontInfo(Source).FUnicode;
    {$ENDIF}
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    FModifiedProperties1 := TFontInfo(Source).FModifiedProperties1;
    FModifiedProperties2 := TFontInfo(Source).FModifiedProperties2;    
    {$ENDIF}
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Is this item equal to Value (all properties are equal)?
  NextStyleNo property (adjusted using Mapping) is taken into account.
  Mapping is from the Value's collection to this collection, see
  TCustomRVInfos.MergeWith.
}
function TFontInfo.IsSimpleEqualEx(Value: TCustomRVInfo; Mapping: TRVIntegerList): Boolean;
begin
  Result := IsSimpleEqual(Value, True, False);
  if not Result then
    exit;
  if Value is TFontInfo then begin
    Result := False;
    if (TFontInfo(Value).NextStyleNo>=0) then begin
      if (TFontInfo(Value).NextStyleNo>=Mapping.Count) then
        TFontInfo(Value).NextStyleNo := -1 // fix up
      else if (Mapping[TFontInfo(Value).NextStyleNo]<>NextStyleNo) then
        exit;
    end;
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
{ Is this item equal to Value (all properties are equal)?
  if IgnoreReferences=True, NextStyleNo property is ignored, otherwise they
  must be equal.
  IgnoreID is not used (used only in TRVListInfo). }
function TFontInfo.IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences: Boolean;
      IgnoreID: Boolean{$IFDEF RICHVIEWDEF4}=True{$ENDIF}): Boolean;
begin
  Result := inherited IsSimpleEqual(Value, IgnoreReferences, IgnoreID);
  if Result and (Value is TFontInfo) then begin
    Result :=
    {$IFNDEF RVDONOTUSEUNICODE}
    (Unicode = TFontInfo(Value).Unicode) and
    {$ENDIF}
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    (ModifiedProperties1 = TFontInfo(Value).ModifiedProperties1) and
    (ModifiedProperties2 = TFontInfo(Value).ModifiedProperties2) and    
    (StyleTemplateID = TFontInfo(Value).StyleTemplateID) and
    {$ENDIF}
    (IgnoreReferences or (NextStyleNo = TFontInfo(Value).NextStyleNo));
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
{ Checks all properties listed in PossibleProps. If they are equal in Self and
  Source, exclude them in Self.ModifiedProperties }
procedure TFontInfo.ExcludeUnmodifiedProperties(
  Source: TCustomRVFontInfo; PossibleProps: TRVFontInfoProperties);
   {.............................................................}
   procedure ChangeFontStyle(FontStyle: TFontStyle; TextPropId: TRVFontInfoProperty1);
   begin
     if (TextPropId in PossibleProps) and
        ((FontStyle in Style)=(FontStyle in Source.Style)) then
       Exclude(FModifiedProperties1, TextPropId);
   end;
   {.............................................................}
   procedure ChangeFontStyleEx(FontStyle: TRVFontStyle; TextPropId: TRVFontInfoProperty1);
   begin
     if (TextPropId in PossibleProps) and
        ((FontStyle in StyleEx)=(FontStyle in Source.StyleEx)) then
       Exclude(FModifiedProperties1, TextPropId);
   end;
   {.............................................................}
   procedure ChangeTextOption(TextOption: TRVTextOption; TextOptionId: TRVFontInfoProperty);
   begin
     if (TextOptionId in PossibleProps) and
        ((TextOption in Options)=(TextOption in Source.Options)) then
       Exclude(FModifiedProperties2, TextOptionId);
   end;
   {.............................................................}
begin
  if (rvfiFontName in PossibleProps) and not (rvfiFontName in ModifiedProperties1) and
    (CompareText(FontName , Source.FontName)=0) then
    Exclude(FModifiedProperties1, rvfiFontName);
  if (rvfiSize in PossibleProps) and (Size=Source.Size) then
    Exclude(FModifiedProperties1, rvfiSize);
  {$IFDEF RICHVIEWCBDEF3}
  if (rvfiCharset in PossibleProps) and (Charset=Source.Charset) then
    Exclude(FModifiedProperties1, rvfiCharset);
  {$ENDIF}
  ChangeFontStyle(fsBold,      rvfiBold);
  ChangeFontStyle(fsItalic,    rvfiItalic);
  ChangeFontStyle(fsUnderline, rvfiUnderline);
  ChangeFontStyle(fsStrikeOut, rvfiStrikeOut);
  ChangeFontStyleEx(rvfsOverline, rvfiOverline);
  ChangeFontStyleEx(rvfsAllCaps, rvfiAllCaps);
  if (rvfiVShift in PossibleProps) and (VShift = Source.VShift) then
    Exclude(FModifiedProperties1, rvfiVShift);
  if (rvfiColor in PossibleProps) and (Color = Source.Color) then
    Exclude(FModifiedProperties1, rvfiColor);
  if (rvfiBackColor in PossibleProps) and (BackColor = Source.BackColor) then
    Exclude(FModifiedProperties1, rvfiBackColor);
  if (rvfiHoverColor in PossibleProps) and (HoverColor = Source.HoverColor) then
    Exclude(FModifiedProperties1, rvfiHoverColor);
  if (rvfiHoverBackColor in PossibleProps) and (HoverBackColor = Source.HoverBackColor) then
    Exclude(FModifiedProperties1, rvfiHoverBackColor);
  if (rvfiJump in PossibleProps) and (Jump = Source.Jump) then
    Exclude(FModifiedProperties1, rvfiJump);
  if (rvfiJumpCursor in PossibleProps) and (JumpCursor = Source.JumpCursor) then
    Exclude(FModifiedProperties1, rvfiJumpCursor);
  if (rvfiProtection in PossibleProps) and (Protection = Source.Protection) then
    Exclude(FModifiedProperties2, rvfiProtection);
  if (rvfiCharScale in PossibleProps) and (CharScale = Source.CharScale) then
    Exclude(FModifiedProperties2, rvfiCharScale);
  if (rvfiBiDiMode in PossibleProps) and (BiDiMode = Source.BiDiMode) then
    Exclude(FModifiedProperties2, rvfiBiDiMode);
  if (rvfiCharSpacing in PossibleProps) and (CharSpacing = Source.CharSpacing) then
    Exclude(FModifiedProperties2, rvfiCharSpacing);
  ChangeTextOption(rvteoHTMLCode, rvfiHTMLCode);
  ChangeTextOption(rvteoRTFCode,  rvfiRTFCode);
  ChangeTextOption(rvteoHidden,  rvfiHidden);  
  {$IFDEF RVLANGUAGEPROPERTY}
  if (rvfiLanguage in PossibleProps) and (Language=Source.Language) then
    Exclude(FModifiedProperties2, rvfiLanguage);
  {$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Is this item equal to Value?
  Equality is determined by comparing all properties NOT included in IgnoreList. }
function TFontInfo.IsEqual(Value: TCustomRVFontInfo;
  IgnoreList: TRVFontInfoProperties): Boolean;
begin
  Result := inherited IsEqual(Value, IgnoreList);
  if Result and (Value is TFontInfo) then begin
    Result :=
      {$IFNDEF RVDONOTUSEUNICODE}
      ((rvfiUnicode     in IgnoreList) or (Unicode = TFontInfo(Value).Unicode    )) and
      {$ENDIF}
      ((rvfiNextStyleNo in IgnoreList) or (NextStyleNo = TFontInfo(Value).NextStyleNo))
      {$IFNDEF RVDONOTUSESTYLETEMPLATES}
      and
      (StyleTemplateId=Value.StyleTemplateId) and
      (ModifiedProperties1=TFontInfo(Value).ModifiedProperties1) and
      (ModifiedProperties2=TFontInfo(Value).ModifiedProperties2)      
      {$ENDIF}
      ;
  end;
end;
{------------------------------------------------------------------------------}
{ Converts UnderlineType to LineStyle and PeriodLength }
procedure ConvertUnderlineToRVLine(UnderlineType: TRVUnderlineType;
  var LineStyle: TRVLineStyle; var PeriodLength: Integer);
begin
  case UnderlineType of
    rvutNormal, rvutThick, rvutDouble:
      begin
        LineStyle := rvlsNormal;
        PeriodLength := 0;
      end;
    rvutDotted, rvutThickDotted:
      begin
        LineStyle := rvlsDotted;
        PeriodLength := 4;
      end;
    rvutDashed, rvutThickDashed:
      begin
        LineStyle := rvlsDashed;
        PeriodLength := 12;
      end;
    rvutLongDashed, rvutThickLongDashed:
      begin
        LineStyle := rvlsDashed;
        PeriodLength := 24;
      end;
    rvutDashDotted, rvutThickDashDotted:
      begin
        LineStyle := rvlsDashDotted;
        PeriodLength := 14;
      end;
    rvutDashDotDotted, rvutThickDashDotDotted:
      begin
        LineStyle := rvlsDashDotDotted;
        PeriodLength := 16;
      end;
  end;
end;
{------------------------------------------------------------------------------}
{ Draws line on Canvas from (Left,Y) to (Right,Y), using the specified
  attributes }
procedure RVDrawUnderline(Canvas: TCanvas; UnderlineType: TRVUnderlineType;
  Color: TColor; Left, Right, Y, BaseLineWidth: Integer;
  GraphicInterface: TRVGraphicInterface);
var LineStyle: TRVLineStyle;
    PeriodLength, LineWidth: Integer;
begin
  if UnderlineType in [rvutThick, rvutThickDotted, rvutThickDashed,
    rvutThickLongDashed, rvutThickDashDotted, rvutThickDashDotDotted] then
    BaseLineWidth := BaseLineWidth*2;
  ConvertUnderlineToRVLine(UnderlineType, LineStyle, PeriodLength);
  if UnderlineType<>rvutDouble then
    RVDrawCustomHLine(Canvas, Color, LineStyle, BaseLineWidth,
      Left, Right, Y, PeriodLength, GraphicInterface)
  else begin
    LineWidth := Round(BaseLineWidth/2);
    if LineWidth=0 then
      LineWidth := 1;
    RVDrawCustomHLine(Canvas, Color, LineStyle, LineWidth,
      Left, Right, Y-BaseLineWidth, PeriodLength, GraphicInterface);
    RVDrawCustomHLine(Canvas, Color, LineStyle, LineWidth,
      Left, Right, Y+BaseLineWidth, PeriodLength, GraphicInterface);
  end;
end;
{------------------------------------------------------------------------------}
procedure RVDrawHiddenUnderline(Canvas: TCanvas;
  Color: TColor; Left, Right, Y: Integer;
  GraphicInterface: TRVGraphicInterface);
begin
  RVDrawCustomHLine(Canvas, Color, rvlsHidden, 1,
    Left, Right, Y, 3, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Draws the string s onto the Canvas.
  For Unicode text, s contains "raw Unicode".
  Item occupies the rectangle Bounds(Left, Top, Width, Height), text is started
  at the position (Left+SpaceBefore, Top). SpaceBefore can be positive in
  justify-aligned paragraphs.
  If RVUSEBASELINE is defined, and Printing=True, BaseLine parameter is valid,
  and text is drawn relative to base line BaseLine instead of relative to Top.
  This item is RVStyle.TextStyles[ThisStyleNo].
  DefBiDiMode is a bi-di mode of the paragraph containing this item.
  Printing is True if this is printing/print preview.
  PreviewCorrection is True if this is a print preview requiring correction.
  ColorMode is used to adjust colors.

  Notes:
  - if (BiDiMode is unspecified) and Printing and PreviewCorrection, a special
    procedure is used: it adjusts character positions to fit the required text
    width (Width-SpaceBefore), see PrintText(..., True);
  - if (BiDiMode is unspecified) and Printing and not PreviewCorrection and
    (CharExtra<>0) a special procedure is used to apply CharExtra (because
    some printers ignore direct setting), see PrintText(..., False)
  - this procedure draws dots (#$B7/#$B0) in place of spaces/nonbreaking spaces,
    if rvtsSpecialCharacters is in DrawState, see DrawDots.
}
procedure TFontInfo.Draw(const s: TRVRawByteString; Canvas: TCanvas;
  ThisStyleNo: Integer;
  SpaceAtLeft, Left, Top, Width, Height, BaseLine: Integer; RVStyle: TRVStyle;
  DrawState: TRVTextDrawStates; Printing, PreviewCorrection: Boolean;
  ColorMode: TRVColorMode; DefBiDiMode: TRVBiDiMode; RefCanvas: TCanvas;
  GraphicInterface: TRVGraphicInterface);

var CharExtra: Integer;
  {......................................................}
  function PrintText(Spacing, Y: Integer; AutoCalcSpacing: Boolean): Boolean;
  var PDx: PRVIntegerArray;
      PGlyphs: PRVWordArray;
      Dummy: Integer;
      ItemOptions: TRVItemOptions;
      i, Len, w,w2,l, nGlyphs: Integer;
      FontHandle: HFont;
      ETOOption: Integer;
      ok: Boolean;
      Str: Pointer;
      StrLen: Integer;
      sz: TSize;
  begin
    Result := True;
    {$IFNDEF RVDONOTUSEUNICODE}
    if Unicode then begin
      ItemOptions := [rvioUnicode];
      Len := Length(s) div 2;
      end
    else
    {$ENDIF}
    begin
      ItemOptions := [];
      Len := Length(s);
    end;
    if Len=0 then begin
      Result := False;
      exit;
    end;
    PGlyphs := nil;
    ETOOption := 0;
    Str := PRVAnsiChar(s);
    StrLen := Len;
    GetMem(PDx, Len*2*sizeof(Integer));
    try
      if AutoCalcSpacing and (RefCanvas<>nil) then begin
        GraphicInterface.SetTextAlign(RefCanvas,
          GraphicInterface.GetTextAlign(Canvas));
        FontHandle := GraphicInterface.SetFontHandle(RefCanvas,
          GraphicInterface.GetFontHandle(Canvas));
        try
          ok := False;
          if (DefBiDiMode<>rvbdUnspecified) or ScaleRichViewTextDrawAlwaysUseGlyphs then begin
            GetMem(PGlyphs, Len*sizeof(Word)*2);
            ok := RVU_GetTextGlyphDX(RefCanvas, s, PDx, PGlyphs, ItemOptions,
                Width-SpaceAtLeft, nGlyphs, GraphicInterface);
            if not ok then begin
              FreeMem(PGlyphs);
              PGlyphs := nil;
              end
            else begin
              ETOOption := ETO_GLYPH_INDEX;
              Str := PGlyphs;
              StrLen := nGlyphs;
              for i := 0 to nGlyphs-1 do
                inc(PDx[i], CharExtra);
            end;
          end;
          if not ok then begin
            RVStyle.GraphicInterface.SetTextCharacterExtra(RefCanvas, CharExtra);
            RVU_GetTextExtentExPoint(RefCanvas, s, $FFFFFFF, Dummy, PDx,
              ItemOptions, RVStyle.GraphicInterface);
            for i := Len-1 downto 1 do
              dec(PDx[i], PDx[i-1]);
          end;
        finally
          GraphicInterface.SetFontHandle(RefCanvas, FontHandle);
        end;
        end
      else begin
        RVU_GetTextExtentExPoint(Canvas, s, $FFFFFFF, Dummy, PDx, ItemOptions,
          RVStyle.GraphicInterface);
        for i := Len-1 downto 1 do
          dec(PDx[i], PDx[i-1]);
        if not AutoCalcSpacing then begin
          for i := 0 to Len-1 do
            inc(PDx[i], Spacing);
          end
        else begin
          w := RVU_TextWidth(s, Canvas, ItemOptions, RVStyle.GraphicInterface);
          if w=Width-SpaceAtLeft then begin
            Result := False;
            exit;
          end;
          w := Width-SpaceAtLeft-w;
          if Abs(w)>=Len then begin
            w2 := w div Len;
            for i := 0 to Len-1 do
              inc(PDx[i], w2);
            w := w mod Len;
          end;
          l := Len;
          i := 0;
          while (i<Len) and (w<>0) do begin
            inc(i, (l-1) div (Abs(w)+1));
            if w<0 then begin
              dec(PDx[i]);
              inc(w);
              end
            else begin
              inc(PDx[i]);
              dec(w);
            end;
            l := Len-i;
          end;
        end;
      end;
      if RefCanvas=nil then begin
        {$IFDEF RVDONOTUSEUNICODE}
        RVStyle.GraphicInterface.ExtTextOut_(Canvas,
          (Left+SpaceAtLeft), Y, ETOOption, nil, Str, StrLen, Pointer(PDx));
        {$ELSE}
          if not Unicode then
            RVStyle.GraphicInterface.ExtTextOut_A(Canvas,
              (Left+SpaceAtLeft), Y, ETOOption, nil, Str, StrLen, Pointer(PDx))
          else
            RVStyle.GraphicInterface.ExtTextOut_W(Canvas,
              (Left+SpaceAtLeft), Y, ETOOption, nil, Str, StrLen, Pointer(PDx));
        {$ENDIF}
        end
      else begin
        RVStyle.GraphicInterface.GetWindowExtEx(Canvas, sz);
        RVStyle.GraphicInterface.SetWindowExtEx(Canvas,
          sz.cx * RVFORMATCANVASFACTOR, sz.cy * RVFORMATCANVASFACTOR, @sz);
        {$IFDEF RVDONOTUSEUNICODE}
        RVStyle.GraphicInterface.ExtTextOut_A(Canvas,
          (Left+SpaceAtLeft)*RVFORMATCANVASFACTOR, Y*RVFORMATCANVASFACTOR,
          ETOOption, nil, Str, StrLen, Pointer(PDx));
        {$ELSE}
          if not Unicode then
            RVStyle.GraphicInterface.ExtTextOut_A(Canvas,
              (Left+SpaceAtLeft)*RVFORMATCANVASFACTOR, Y*RVFORMATCANVASFACTOR,
              ETOOption, nil, Str, StrLen, Pointer(PDx))
          else
            RVStyle.GraphicInterface.ExtTextOut_W(Canvas,
              (Left+SpaceAtLeft)*RVFORMATCANVASFACTOR, Y*RVFORMATCANVASFACTOR,
              ETOOption, nil, Str, StrLen, Pointer(PDx));
        {$ENDIF}
        RVStyle.GraphicInterface.SetWindowExtEx(Canvas, sz.cx, sz.cy, nil);
      end;
    finally
      FreeMem(PDx);
      if PGlyphs<>nil then
        FreeMem(PGlyphs);
    end;
  end;
  {......................................................}
  function GetUnderlineColor: TColor;
  begin
    Result := Canvas.Font.Color;
    if rvtsSelected in DrawState then
      exit;
    if UnderlineColor<>clNone then
      Result := UnderlineColor;
    if (rvtsHover in DrawState) and (HoverUnderlineColor<>clNone) then
      Result := HoverUnderlineColor;
  end;
  {......................................................}
  procedure DrawDots(Y: Integer);
  var res: TGCPResultsA;
    i, Len, Spacing, X, LLeft, LY, LSpaceAtLeft: Integer;
    sz: TSize;
    POrder,POrderRev: PRVUnsignedArray;
    PDX: PRVIntegerArray;
    ok: Boolean;
    ItemOptions: TRVItemOptions;
    wb7,wb0, spshift, nbspshift: Integer;
    Cnv: TCanvas;
    FontHandle: HFont;
    OldColor: TColor;
    {. . . . . . . . . . . . . . . . . . . . . . . . . . .}
    procedure DrawDot(var w, shift: Integer; sp, dot: Char);
    var BrushColor: TColor;
        BrushStyle: TBrushStyle;
    begin
      if w=0 then begin
        w := Cnv.TextWidth(dot);
        shift := Round((Cnv.TextWidth(sp)-w)/2);
      end;
      BrushColor := Canvas.Brush.Color;
      BrushStyle := Canvas.Brush.Style;
      Canvas.Brush.Style := bsClear;
      RVStyle.GraphicInterface.TextOut_(Canvas, LLeft+shift, LY, @dot, 1);
      Canvas.Brush.Color := BrushColor;
      Canvas.Brush.Style := BrushStyle;
    end;
    {. . . . . . . . . . . . . . . . . . . . . . . . . . .}
    procedure DoDrawDots(SpaceCode: Integer);
    begin
      case SpaceCode of
        ord(' '):
          if rvscSpace in RVVisibleSpecialCharacters then
            DrawDot(wb7, spshift, ' ', RVCHAR_MIDDLEDOT);
        $A0:
          if rvscNBSP in RVVisibleSpecialCharacters then
            DrawDot(wb0, nbspshift, RVCHAR_NBSP, RVCHAR_DEGREE);
      end;
    end;    
    {. . . . . . . . . . . . . . . . . . . . . . . . . . .}
  begin
    if Printing and (RefCanvas=nil) then
      exit;
    LLeft := Left;
    LY := Y;
    LSpaceAtLeft := SpaceAtLeft;
    Len := Length(s);
    if Len=0 then
      exit;
    wb7 := 0;
    wb0 := 0;
    spshift := 0;
    nbspshift := 0;
    if RefCanvas<>nil then begin
      GraphicInterface.SetTextAlign(RefCanvas,
        GraphicInterface.GetTextAlign(Canvas));
      FontHandle :=  GraphicInterface.SetFontHandle(RefCanvas,
        GraphicInterface.GetFontHandle(Canvas));
      Cnv := RefCanvas;
      GraphicInterface.GetWindowExtEx(Canvas, sz);
      GraphicInterface.SetWindowExtEx(Canvas,
        sz.cx * RVFORMATCANVASFACTOR, sz.cy * RVFORMATCANVASFACTOR, @sz);
      LLeft := LLeft * RVFORMATCANVASFACTOR;
      LY := LY * RVFORMATCANVASFACTOR;
      LSpaceAtLeft := LSpaceAtLeft * RVFORMATCANVASFACTOR;      
      end
    else begin
      Cnv := Canvas;
      FontHandle := 0;
    end;
    if not (rvtsSelected in DrawState) and
      (RVStyle.SpecialCharactersColor<>clNone) then begin
      OldColor := Cnv.Font.Color;
      Cnv.Font.Color := RVStyle.SpecialCharactersColor;
      end
    else
      OldColor := clNone;
    try
      {$IFNDEF RVDONOTUSEUNICODE}
      if Unicode then
        Len := Len div 2;
      if (Unicode and not RVNT) or (DefBiDiMode=rvbdUnspecified) then
        ok := False
      else {$ENDIF} begin // drawing dots for bidirected text
        Spacing := RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas);
        FillChar(res, sizeof(TGCPResults), 0);
        res.lStructSize := sizeof(TGCPResults);
        GetMem(POrder,    Len*sizeof(Cardinal));
        GetMem(POrderRev, Len*sizeof(Cardinal));
        GetMem(PDX,       Len*sizeof(Integer));
        try
          FillChar(POrder^, Len*sizeof(Cardinal), 0);
          FillChar(POrderRev^, Len*sizeof(Cardinal), -1);
          res.lpOrder := @(POrder[0]);
          res.lpDx    := @(PDX[0]);
          res.nGlyphs := Len;
          {$IFNDEF RVDONOTUSEUNICODE}
          if Unicode then
            ok := RVStyle.GraphicInterface.GetCharacterPlacement_W(Cnv,
              Pointer(s), Len, res, True)<>0
          else
          {$ENDIF}
            ok := RVStyle.GraphicInterface.GetCharacterPlacement_A(Cnv,
              PRVAnsiChar(s), Len, res, RVStyle.GraphicInterface.FontHasLigationGlyphs(Cnv))<>0;
          if ok and (Len>1) then begin
            ok := False;
            for i := 0 to Len-1 do
              if POrder[i]<>0 then begin
                ok := True;
                break;
              end;
          end;
          if ok then begin
            for i := 0 to Len-1 do
              POrderRev[POrder[i]] := i;
            inc(LLeft, LSpaceAtLeft);
            {$IFNDEF RVDONOTUSEUNICODE}
            if not Unicode then
            {$ENDIF}
              for i := 0 to Len-1 do begin
                if POrderRev[i]<>$FFFFFFFF then
                  DoDrawDots(ord(s[POrderRev[i]+1]));
                inc(LLeft, PDX[i]+Spacing);
              end
            {$IFNDEF RVDONOTUSEUNICODE}
            else
              for i := 0 to Len-1 do begin
                if POrderRev[i]<>$FFFFFFFF then
                  DoDrawDots(PRVWordArray(PRVAnsiChar(s))[POrderRev[i]]);
                inc(LLeft, PDX[i]+Spacing);
              end;
            {$ENDIF}
          end;
        finally
          FreeMem(POrder);
          FreeMem(POrderRev);
          FreeMem(PDX);
        end;
      end;
      if ok then begin
        if RefCanvas<>nil then
          RVStyle.GraphicInterface.SetWindowExtEx(Canvas, sz.cx, sz.cy, nil);
        exit;
      end;
      // drawing dots for left-to-right text (or if drawing for bidirected text failed
      GetMem(PDX, (Len+2)*sizeof(Integer));
      try
        if RefCanvas<>nil then
          RVStyle.GraphicInterface.SetTextCharacterExtra(RefCanvas,
            RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas));
        {$IFNDEF RVDONOTUSEUNICODE}
        if Unicode then
          ItemOptions := [rvioUnicode]
        else
        {$ENDIF}
          ItemOptions := [];
        RVU_GetTextExtentExPoint(Cnv, s, $FFFFFFF, X, PDX, ItemOptions,
          RVStyle.GraphicInterface);
        inc(LLeft, LSpaceAtLeft);
        X := LLeft;
        {$IFNDEF RVDONOTUSEUNICODE}
        if not Unicode then
        {$ENDIF}
          for i := 0 to Len-1 do begin
            if s[i+1] in [' ',#$A0] then begin
              LLeft := X;
              if i>0 then
                inc(LLeft, PDX[i-1]);
              DoDrawDots(ord(s[i+1]));
            end;
          end
        {$IFNDEF RVDONOTUSEUNICODE}
        else
          for i := 0 to Len-1 do begin
            if (PRVWordArray(PRVAnsiChar(s))[i]=ord(' ')) or
               (PRVWordArray(PRVAnsiChar(s))[i]=$A0) then begin
              LLeft := X;
              if i>0 then
                inc(LLeft, PDX[i-1]);
              DoDrawDots(PRVWordArray(PRVAnsiChar(s))[i]);
            end;
          end;
        {$ENDIF}
      finally
        FreeMem(PDX);
      end;
    finally
      if FontHandle<>0 then
        RVStyle.GraphicInterface.SetFontHandle(RefCanvas, FontHandle);
    end;
    if RefCanvas<>nil then
      RVStyle.GraphicInterface.SetWindowExtEx(Canvas, sz.cx, sz.cy, nil);
    if OldColor<>clNone then
      Cnv.Font.Color := OldColor;
  end;
  {......................................................}
var
    potm: POutlineTextMetric;
    Y, LineWidth: Integer;
    TextDone, CustomUnderline: Boolean;

begin
  //RefCanvas := nil;
  {$IFDEF RVUSEBASELINE}
  if Printing then begin
    GraphicInterface.SetTextAlign(Canvas, TA_BASELINE);
    Y := BaseLine;
    end
  else
  {$ENDIF}
    Y := Top;
  if (RefCanvas=Canvas) then
    RefCanvas := nil;
  if CharScale=100 then
    CustomUnderline := ((fsUnderline in Canvas.Font.Style) and
    ((UnderlineType<>rvutNormal) or (GetUnderlineColor<>Canvas.Font.Color) or
    (SpaceAtLeft<>0))) or (rvteoHidden in Options)
  else
    CustomUnderline := (fsUnderline in Style) or (rvteoHidden in Options);
  if (CustomUnderline or (SpaceAtLeft<>0)) and (CharScale=100) then
    Canvas.Font.Style := Canvas.Font.Style-[fsUnderline];
  TextDone := False;
  if BiDiMode<>rvbdUnspecified then
    DefBiDiMode := BiDiMode;
  if Printing and ((DefBiDiMode=rvbdUnspecified) or (RefCanvas<>nil)) then begin
    if (Canvas.Brush.Style<>bsClear) and (RefCanvas=nil) then begin
      Canvas.Pen.Style := psClear;
      GraphicInterface.FillRect(Canvas, Bounds(Left,Top,Width,Height));
      Canvas.Brush.Style := bsClear;
      Canvas.Pen.Style := psSolid;
    end;
    if not PreviewCorrection then begin
      CharExtra := RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas);
      if CharExtra<>0 then begin
         RVStyle.GraphicInterface.SetTextCharacterExtra(Canvas, 0);
         TextDone := PrintText(CharExtra, Y, False);
         RVStyle.GraphicInterface.SetTextCharacterExtra(Canvas, CharExtra);
      end;
      end
    else begin
      CharExtra := RVStyle.GraphicInterface.GetTextCharacterExtra(Canvas);
      if (CharExtra<>0) {and (RefCanvas=nil)} then
        RVStyle.GraphicInterface.SetTextCharacterExtra(Canvas, 0);
      TextDone := PrintText(0, Y, True);
      if CharExtra<>0 then
        RVStyle.GraphicInterface.SetTextCharacterExtra(Canvas, CharExtra);
    end;
  end;
  if not TextDone then begin
    {$IFDEF RVDONOTUSEUNICODE}
    RVStyle.GraphicInterface.TextOut_A(Canvas, Left+SpaceAtLeft, Y, PChar(s), Length(s));
    {$ELSE}
      if not Unicode then
        RVStyle.GraphicInterface.TextOut_A(Canvas, Left+SpaceAtLeft, Y, PRVAnsiChar(s), Length(s))
      else
        RVStyle.GraphicInterface.TextOut_W(Canvas, Left+SpaceAtLeft, Y, Pointer(s), Length(s) div 2);
    {$ENDIF}
  end;
  if (rvtsSpecialCharacters in DrawState) and
     (RVVisibleSpecialCharacters * [rvscSpace, rvscNBSP]<>[]) then
    DrawDots(Y);
  if (SpaceAtLeft<>0) and (not Printing or (RefCanvas<>nil)) then begin
    if (rvtsSelected in DrawState) and (Length(s)=0) then
      RVStyle.ApplyStyleColor(Canvas, ThisStyleNo, DrawState-[rvtsSelected], Printing, ColorMode);
    if Canvas.Brush.Style<>bsClear then
    RVStyle.GraphicInterface.FillRect(Canvas, Bounds(Left,Top,SpaceAtLeft,Height));
  end;
  Canvas.Brush.Style := bsClear;
  potm := nil;
  try
    if CustomUnderline or (fsUnderline in Canvas.Font.Style) then begin
      if (CustomUnderline or (SpaceAtLeft<>0)) then begin
        potm := RV_GetOutlineTextMetrics(Canvas, GraphicInterface);
        if potm<>nil then
          if rvteoHidden in Options then
            RVDrawHiddenUnderline(Canvas, Canvas.Font.Color, Left, Left+Width,
              Top+
              RVConvertFromFormatCanvas(-potm.otmsUnderscorePosition+
                potm.otmTextMetrics.tmAscent+potm.otmsUnderscoreSize div 2, RefCanvas<>nil),
              RVStyle.GraphicInterface)
          else
            RVDrawUnderline(Canvas, UnderlineType, GetUnderlineColor,
              Left, Left+Width,
              Top+
              RVConvertFromFormatCanvas(-potm.otmsUnderscorePosition+
                potm.otmTextMetrics.tmAscent+potm.otmsUnderscoreSize div 2, RefCanvas<>nil),
              RVConvertFromFormatCanvas(potm.otmsUnderscoreSize, RefCanvas<>nil),
              RVStyle.GraphicInterface)
          else
            if rvteoHidden in Options then
              RVDrawHiddenUnderline(Canvas, Canvas.Font.Color,
                Left, Left+Width,
                Top+Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
                RVStyle.GraphicInterface)
            else
              RVDrawUnderline(Canvas, UnderlineType, GetUnderlineColor,
                Left, Left+Width,
                Top+Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
                RVGetDefaultUnderlineWidth(Canvas.Font.Size),
                RVStyle.GraphicInterface);
          Canvas.Pen.Style := psSolid;
        end
      else if SpaceAtLeft<>0 then begin
        potm := RV_GetOutlineTextMetrics(Canvas, GraphicInterface);
        if potm<>nil then
          if rvteoHidden in Options then
            RVDrawHiddenUnderline(Canvas, Canvas.Font.Color,
              Left, Left+SpaceAtLeft,
              Top+
              RVConvertFromFormatCanvas(-potm.otmsUnderscorePosition+
                potm.otmTextMetrics.tmAscent+potm.otmsUnderscoreSize div 2, RefCanvas<>nil),
              RVStyle.GraphicInterface)
          else
            RVDrawUnderline(Canvas, UnderlineType, GetUnderlineColor,
              Left, Left+SpaceAtLeft,
              Top+
              RVConvertFromFormatCanvas(-potm.otmsUnderscorePosition+
                potm.otmTextMetrics.tmAscent+potm.otmsUnderscoreSize div 2, RefCanvas<>nil),
              RVConvertFromFormatCanvas(potm.otmsUnderscoreSize, RefCanvas<>nil),
              RVStyle.GraphicInterface)
        else
          if rvteoHidden in Options then
            RVDrawHiddenUnderline(Canvas, Canvas.Font.Color,
              Left, Left+SpaceAtLeft,
              Top+Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
              RVStyle.GraphicInterface)
          else
            RVDrawUnderline(Canvas, UnderlineType, GetUnderlineColor,
              Left, Left+SpaceAtLeft,
              Top+Height-RVGetDefaultUnderlineWidth(Canvas.Font.Size) div 2,
              RVGetDefaultUnderlineWidth(Canvas.Font.Size),
              RVStyle.GraphicInterface);
        Canvas.Pen.Style := psSolid;
      end;
    end;
    if rvfsOverline in StyleEx then begin
      if potm=nil then
        potm := RV_GetOutlineTextMetrics(Canvas, GraphicInterface);
      if potm<>nil then
        LineWidth := RVConvertFromFormatCanvas(potm.otmsUnderscoreSize, RefCanvas<>nil)
      else
        LineWidth :=  RVGetDefaultUnderlineWidth(Canvas.Font.Size);
      RVDrawUnderline(Canvas, rvutNormal, Canvas.Font.Color,
        Left, Left+Width, Top-LineWidth div 2, LineWidth,
        RVStyle.GraphicInterface);
      Canvas.Pen.Style := psSolid;
    end;
  finally
    if potm<>nil then
      FreeMem(potm);
  end;
  {$IFDEF RVUSEBASELINE}
  if Printing then
    GraphicInterface.SetTextAlign(Canvas, TA_TOP);
  {$ENDIF}
  if CustomUnderline and (CharScale=100) then
    Canvas.Font.Style := Canvas.Font.Style+[fsUnderline];
end;
{------------------------------------------------------------------------------}
{ You do not see this :) }
procedure TFontInfo.DrawVertical(const s: TRVRawByteString; Canvas: TCanvas;
  ThisStyleNo, SpaceBefore, Left, Top, Width, Height: Integer;
  RVStyle: TRVStyle; DrawState: TRVTextDrawStates);
begin
  {$IFDEF RVDONOTUSEUNICODE}
  RVStyle.GraphicInterface.TextOut_(Canvas, Left, Top+SpaceBefore,
    PChar(s), Length(s));
  {$ELSE}
  if not Unicode then
    RVStyle.GraphicInterface.TextOut_A(Canvas, Left, Top+SpaceBefore,
      PRVAnsiChar(s), Length(s))
  else
    RVStyle.GraphicInterface.TextOut_W(Canvas, Left, Top+SpaceBefore,
      Pointer(s), Length(s) div 2);
  {$ENDIF}
  if (SpaceBefore<>0) then begin
    if (rvtsSelected in DrawState) and (Length(s)=0) then
      RVStyle.ApplyStyleColor(Canvas, ThisStyleNo, DrawState-[rvtsSelected], False, rvcmColor);
    if Canvas.Brush.Style<>bsClear then
    RVStyle.GraphicInterface.FillRect(Canvas, Bounds(Left, Top, Height,SpaceBefore));
  end;
  Canvas.Brush.Style := bsClear;
  if rvfsOverline in StyleEx then begin
    Canvas.Pen.Color := Canvas.Font.Color;
    RVStyle.GraphicInterface.Line(Canvas, Left, Top, Left, Top+Width);
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads properties from the ini-file, from the section Section.
  fs is a format string for keys, it is like 'Font%s1', 'Font%s2', etc. }
procedure TFontInfo.LoadFromINI(ini: TRVIniFile; const Section, fs: String;
  JumpByDefault: Boolean; DefJumpCursor: TCursor);
begin
  inherited;
  NextStyleNo   := ini.ReadInteger(Section, Format(fs,[RVINI_NEXTSTYLENO]), -1);
  {$IFNDEF RVDONOTUSEUNICODE}
  Unicode       := iniReadBool(ini, Section, Format(fs,[RVINI_UNICODE]), False);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Saves properties to the ini-file, to the section Section.
  fs is a format string for keys, it is like 'Font%s1', 'Font%s2', etc. }
procedure TFontInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  inherited;
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_NEXTSTYLENO]),NextStyleNo,-1);
  {$IFNDEF RVDONOTUSEUNICODE}
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_UNICODE]), Unicode, False);
  {$ENDIF}
end;
{$ENDIF}
{============================== TErrFontInfo ==================================}
constructor TErrFontInfo.CreateErr(RVStyle: TRVStyle);
begin
  Create(nil);
  FRVStyle := RVStyle;
end;
{------------------------------------------------------------------------------}
function TErrFontInfo.GetRVStyle: TRVStyle;
begin
  Result := FRVStyle;
end;
{================================== TFontInfos ================================}
{ Destructor }
destructor TFontInfos.Destroy;
begin
  FInvalidItem.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
{ Adds new item to the end (perfotms typecasting) }
function TFontInfos.Add: TFontInfo;
begin
  Result := TFontInfo(inherited Add);
end;
{------------------------------------------------------------------------------}
{ Deprecated method }
function TFontInfos.AddFont(Name: TFontName; Size: Integer;
                   Color,BackColor: TColor; Style:TFontStyles): TFontInfo;
begin
   Result := Add;
   Result.FontName  := Name;
   Result.Size      := Size;
   Result.Color     := Color;
   Result.BackColor := BackColor;
   Result.Style     := Style;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Deprecated method }
function TFontInfos.AddFontEx(Name: TFontName; Size: Integer;
                   Color, BackColor: TColor; Style:TFontStyles;
                   Charset: TFontCharset): TFontInfo;
begin
   Result := AddFont(Name, Size, Color, BackColor, Style);
   Result.Charset := Charset;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for the property Items[].
  Returns the Index-th item. If the index is out of range (0..Count-1), returns
  InvalidItem instead. This method never generates exceptions. }
function TFontInfos.GetItem(Index: Integer): TFontInfo;
begin
  if (Index<0) or (Index>=Count) then
    Result := InvalidItem
  else
    Result := TFontInfo(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for the property Items[]. }
procedure TFontInfos.SetItem(Index: Integer; Value: TFontInfo);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{ READ method for the property InvalidItem.
  It's returned when accessing Items[] with invalid index.
  By default it has all properties of Items[0], but white on red. }
function TFontInfos.GetInvalidItem: TFontInfo;
begin
  if FInvalidItem=nil then begin
    FInvalidItem := TErrFontInfo.CreateErr(FOwner as TRVStyle);
    if Count>0 then
      FInvalidItem.Assign(Items[0]);
    FInvalidItem.BackColor := clRed;
    FInvalidItem.Color := clWhite;
  end;
  Result := FInvalidItem;
end;
{------------------------------------------------------------------------------}
{ WRITE method for the property InvalidItem. }
procedure TFontInfos.SetInvalidItem(const Value: TFontInfo);
begin
  if InvalidItem<>Value then
    InvalidItem.Assign(Value);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section. }
procedure TFontInfos.LoadFromINI(ini: TRVIniFile; const Section: String;
  DefJumpCursor: TCursor);
var i, cnt: Integer;
begin
  // for compatibility with old versions, default count of styles is
  // LAST_DEFAULT_STYLE_NO+1
  cnt := ini.ReadInteger(Section, RVINI_TEXTSTYLECOUNT,   LAST_DEFAULT_STYLE_NO+1);
  Clear;
  for i := 0 to cnt-1 do begin
    Add;
    Items[i].LoadFromINI(ini, Section, RVINI_TEXTSTYLEPREFIX+IntToStr(i),
      i in [rvsJump1, rvsJump2], DefJumpCursor);
  end;
end;
{------------------------------------------------------------------------------}
{ Saves itself to the ini-file, to the section Section. }
procedure TFontInfos.SaveToINI(ini: TRVIniFile; const Section: String);
var i: Integer;
begin
  ini.WriteInteger(Section, RVINI_TEXTSTYLECOUNT, Count);
  for i:=0 to Count-1 do
    Items[i].SaveToINI(ini, Section, RVINI_TEXTSTYLEPREFIX+IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Returns the index of the style having all properties of Font.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithFont(BaseStyle: Integer; Font: TFont): Integer;
var i: Integer;
    {........................................}
    function Matched(fi: TFontInfo): Boolean;
    begin
      Result := (fi.Size=Font.Size) and
                (fi.Style=Font.Style) and
                (fi.FontName=Font.Name) and
                {$IFDEF RICHVIEWCBDEF3}
                (fi.Charset=Font.Charset) and
                {$ENDIF}
                (fi.Color=Font.Color);
    end;
    {........................................}
begin
  if Matched(Items[BaseStyle]) then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and Matched(Items[i]) and
       Items[BaseStyle].IsEqual(Items[i], [rvfiFontName, rvfiSize, rvfiCharset,
                                           rvfiBold, rvfiItalic, rvfiUnderline,
                                           rvfiStrikeout, rvfiColor]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the style having the specified font Size.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithFontSize(BaseStyle, Size: Integer): Integer;
var i: Integer;
begin
  if Items[BaseStyle].Size = Size then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and (Items[i].Size=Size) and
       Items[BaseStyle].IsEqual(Items[i], [rvfiSize]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the style having the specified values of Color and BackColor.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithColor(BaseStyle: Integer; Color,
  BackColor: TColor): Integer;
var i: Integer;
begin
  if (Items[BaseStyle].Color     = Color) and
     (Items[BaseStyle].BackColor = BackColor) then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and
       (Items[i].Color     = Color) and
       (Items[i].BackColor = BackColor) and
       Items[BaseStyle].IsEqual(Items[i], [rvfiColor, rvfiBackColor]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the style having the specified value of FontName.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithFontName(BaseStyle: Integer;
  const FontName: TFontName): Integer;
var i: Integer;
begin
  if Items[BaseStyle].FontName = FontName then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and (Items[i].FontName=FontName) and
       Items[BaseStyle].IsEqual(Items[i], [rvfiFontName]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ The most universal method for text style searching.
  Returns the index of the style having all properties of Style listed in Mask.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindSuchStyle(BaseStyle: Integer; Style: TFontInfo;
  Mask: TRVFontInfoProperties): Integer;
var i: Integer;
begin
  Mask := RVAllFontInfoProperties - Mask;
  if Style.IsEqual(Items[BaseStyle], Mask) then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and Style.IsEqual(Items[i], Mask) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Returns the index of the style having the specified value of Charset.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithCharset(BaseStyle: Integer; Charset: TFontCharset): Integer;
var i: Integer;
begin
  if (Items[BaseStyle].Charset=Charset)
     {$IFNDEF RVDONOTUSEUNICODE}
     and not Items[BaseStyle].Unicode
     {$ENDIF}
     then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and (Items[i].Charset=Charset) and
       {$IFNDEF RVDONOTUSEUNICODE}
       not Items[i].Unicode and
       {$ENDIF}
       Items[BaseStyle].IsEqual(Items[i], [rvfiCharset, rvfiUnicode]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Returns the index of the style having the specified font styles.
  Mask defines which font styles to check. Value defines the required values
  of them.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TFontInfos.FindStyleWithFontStyle(BaseStyle: Integer; Value,
  Mask: TFontStyles): Integer;
var i: Integer;
    IgnoreList: TRVFontInfoProperties;
    {........................................}
    function Matched(fi: TFontInfo): Boolean;
    var i: TFontStyle;
    begin
      for i := Low(TFontStyle) to High(TFontStyle) do
        if (i in Mask) and ((i in fi.Style)<>(i in Value)) then begin
          Result := False;
          exit;
        end;
      Result := True;
    end;
    {........................................}
begin
  if Matched(Items[BaseStyle]) then begin
    Result := BaseStyle;
    exit;
  end;
  IgnoreList := [];
  if fsBold in Mask then
    Include(IgnoreList, rvfiBold);
  if fsItalic in Mask then
    Include(IgnoreList, rvfiItalic);
  if fsUnderline in Mask then
    Include(IgnoreList, rvfiUnderline);
  if fsStrikeout in Mask then
    Include(IgnoreList, rvfiStrikeout);

  for i := 0 to Count-1 do
    if (i<>BaseStyle) and Matched(Items[i]) and
       Items[BaseStyle].IsEqual(Items[i], IgnoreList) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{================================== TRVRect ===================================}
constructor TRVRect.CreateOwned(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
end;
{------------------------------------------------------------------------------}
{ Assigns TRVRect (Source) to TRVRect (Self). }
procedure TRVRect.Assign(Source: TPersistent);
begin
  if Source is TRVRect then begin
    Left   := TRVRect(Source).Left;
    Right  := TRVRect(Source).Right;
    Top    := TRVRect(Source).Top;
    Bottom := TRVRect(Source).Bottom;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Assigns properties from value. Val* specify properties to assign. }
procedure TRVRect.AssignValidProperties(Source: TRVRect;
  ValL, ValT, ValR, ValB: Boolean);
begin
  if ValL then
    Left := Source.Left;
  if ValT then
    Top := Source.Top;
  if ValR then
    Right := Source.Right;
  if ValB then
    Bottom := Source.Bottom;
end;
{------------------------------------------------------------------------------}
{ Assigns Value to all sides. }
procedure TRVRect.SetAll(Value: TRVStyleLength);
begin
  Left   := Value;
  Top    := Value;
  Right  := Value;
  Bottom := Value;
end;
{------------------------------------------------------------------------------}
{ Assigns itself to TRect. }
procedure TRVRect.AssignToRect(var Rect: TRect);
begin
  Rect.Left   := Left;
  Rect.Top    := Top;
  Rect.Right  := Right;
  Rect.Bottom := Bottom;
end;
{------------------------------------------------------------------------------}
{ Assigns itself to TRect. Only sides having greater values are assigned. }
procedure TRVRect.AssignToRectIfGreater(var Rect: TRect);
begin
  if Left>Rect.Left then
    Rect.Left   := Left;
  if Top>Rect.Top then
    Rect.Top    := Top;
  if Right>Rect.Right then
    Rect.Right  := Right;
  if Bottom>Rect.Bottom then
    Rect.Bottom := Bottom;
end;
{------------------------------------------------------------------------------}
{ Grows TRect by adding/subtracting sides.
  Rect is measured in screen pixels.
}
procedure TRVRect.InflateRect(var Rect: TRect; RVStyle: TRVStyle);
begin
  dec(Rect.Left,   RVStyle.GetAsPixels(Left));
  dec(Rect.Top,    RVStyle.GetAsPixels(Top));
  inc(Rect.Right,  RVStyle.GetAsPixels(Right));
  inc(Rect.Bottom, RVStyle.GetAsPixels(Bottom));
end;
{------------------------------------------------------------------------------}
{ Grows TRect by adding/subtracting sides adjusted to the resolution specified
  in sad.
  Rect is measured in device pixels.
 }
procedure TRVRect.InflateRectSaD(var Rect: TRect; RVStyle: TRVStyle;
  const sad: TRVScreenAndDevice);
begin
  dec(Rect.Left,   RVStyle.GetAsDevicePixelsX(Left,   @sad));
  dec(Rect.Top,    RVStyle.GetAsDevicePixelsY(Top,    @sad));
  inc(Rect.Right,  RVStyle.GetAsDevicePixelsX(Right,  @sad));
  inc(Rect.Bottom, RVStyle.GetAsDevicePixelsY(Bottom, @sad));
end;
{------------------------------------------------------------------------------}
{ Is this rectangle equal to Value? }
function TRVRect.IsEqual(Value: TRVRect): Boolean;
begin
  Result := (Left=Value.Left) and (Right=Value.Right) and
            (Top =Value.Top)  and (Bottom=Value.Bottom);
end;
{------------------------------------------------------------------------------}
{ Are the specified sides equal to the sides of Value?
  Ign* specify sides to ignore when comparing. }
function TRVRect.IsEqualEx(Value: TRVRect; IgnL, IgnT, IgnR,
  IgnB: Boolean): Boolean;
begin
  Result := (IgnL or (Left=Value.Left)) and
            (IgnR or (Right=Value.Right)) and
            (IgnT or (Top =Value.Top)) and
            (ignB or (Bottom=Value.Bottom));
end;
{------------------------------------------------------------------------------}
{ Returns the value of similarity between this rectangle and Value.
  The larger return value - the larger similarity.
  Result is proportional to Weight. }
function TRVRect.SimilarityValue(Value: TRVRect; Weight: TRVStyleLength;
  Wht: Integer): Integer;
begin
  Result := RV_CompareInts(Left,   Value.Left,   Weight)+
            RV_CompareInts(Top,    Value.Top,    Weight)+
            RV_CompareInts(Right,  Value.Right,  Weight)+
            RV_CompareInts(Bottom, Value.Bottom, Weight);
  Result := Result div Wht;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVRect.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
begin
  Left    := ini.ReadInteger(Section, Format(fs,[RVINI_LEFT]),   0);
  Right   := ini.ReadInteger(Section, Format(fs,[RVINI_RIGHT]),  0);
  Top     := ini.ReadInteger(Section, Format(fs,[RVINI_TOP]),    0);
  Bottom  := ini.ReadInteger(Section, Format(fs,[RVINI_BOTTOM]), 0);
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVRect.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LEFT]),   Left,   0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_RIGHT]),  Right,  0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_TOP]),    Top,    0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_BOTTOM]), Bottom, 0);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
// Converts from RVStyle.Units to NewUnits.
procedure TRVRect.ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
begin
  Left := RVStyle.GetAsDifferentUnits(Left, NewUnits);
  Right := RVStyle.GetAsDifferentUnits(Right, NewUnits);
  Top := RVStyle.GetAsDifferentUnits(Top, NewUnits);
  Bottom := RVStyle.GetAsDifferentUnits(Bottom, NewUnits);
end;
{================================ TRVBooleanRect ==============================}
{ Constructor, assigns DefValue to all sides. }
constructor TRVBooleanRect.Create(DefValue: Boolean);
begin
  inherited Create;
  SetAll(DefValue);
end;
{------------------------------------------------------------------------------}
{ Assigns Value to all sides. }
procedure TRVBooleanRect.SetAll(Value: Boolean);
begin
  Left   := Value;
  Top    := Value;
  Right  := Value;
  Bottom := Value;
end;
{------------------------------------------------------------------------------}
{ Assigns parameters to sides. }
procedure TRVBooleanRect.SetValues(ALeft, ATop, ARight, ABottom: Boolean);
begin
  Left   := ALeft;
  Top    := ATop;
  Right  := ARight;
  Bottom := ABottom;
end;
{------------------------------------------------------------------------------}
{ Assigns TRVBooleanRect (Source) to TRVBooleanRect (Self). }
procedure TRVBooleanRect.Assign(Source: TPersistent);
begin
  if Source is TRVBooleanRect then begin
    Left   := TRVBooleanRect(Source).Left;
    Right  := TRVBooleanRect(Source).Right;
    Top    := TRVBooleanRect(Source).Top;
    Bottom := TRVBooleanRect(Source).Bottom;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Assigns values from Source. Val* specify properties to assign. }
procedure TRVBooleanRect.AssignValidProperties(Source: TRVBooleanRect;
  ValL, ValT, ValR, ValB: Boolean);
begin
  if ValL then
    Left := Source.Left;
  if ValT then
    Top := Source.Top;
  if ValR then
    Right := Source.Right;
  if ValB then
    Bottom := Source.Bottom;
end;
{------------------------------------------------------------------------------}
{ Is this boolean rectangle equal to Value? }
function TRVBooleanRect.IsEqual(Value: TRVBooleanRect): Boolean;
begin
  Result := (Left=Value.Left) and (Right=Value.Right) and
            (Top =Value.Top)  and (Bottom=Value.Bottom);
end;
{------------------------------------------------------------------------------}
{ Are the sides equal to the parameters? }
function TRVBooleanRect.IsEqual2(ALeft, ATop, ARight, ABottom: Boolean): Boolean;
begin
  Result := (Left=ALeft) and (Right=ARight) and
            (Top =ATop)  and (Bottom=ABottom);
end;
{------------------------------------------------------------------------------}
{ All all the sides equal to the Value? }
function TRVBooleanRect.IsAllEqual(Value: Boolean): Boolean;
begin
  Result := (Left=Value) and (Right=Value) and
            (Top =Value) and (Bottom=Value);
end;
{------------------------------------------------------------------------------}
{ Are the specified sides equal to the sides of Value?
  Ign* specify sides to ignore when comparing. }
function TRVBooleanRect.IsEqualEx(Value: TRVBooleanRect; IgnL, IgnT, IgnR,
  IgnB: Boolean): Boolean;
begin
  Result := (IgnL or (Left=Value.Left)) and
            (IgnR or (Right=Value.Right)) and
            (IgnT or (Top =Value.Top)) and
            (ignB or (Bottom=Value.Bottom));
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVBooleanRect.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  Left    := IniReadBool(ini, Section, Format(fs,[RVINI_LEFT]),   True);
  Right   := IniReadBool(ini, Section, Format(fs,[RVINI_RIGHT]),  True);
  Top     := IniReadBool(ini, Section, Format(fs,[RVINI_TOP]),    True);
  Bottom  := IniReadBool(ini, Section, Format(fs,[RVINI_BOTTOM]), True);
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVBooleanRect.SaveToINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_LEFT]),   Left,   True);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_RIGHT]),  Right,  True);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_TOP]),    Top,    True);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_BOTTOM]), Bottom, True);
end;
{$ENDIF}
{============================= TRVBorder ======================================}
{ Constructor. Sets border style to "none", color to clWindowText, width to 1. }
constructor TRVBorder.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FBorderOffsets := TRVRect.CreateOwned(Self);
  FVisibleBorders := TRVBooleanRect.Create(True);
  Style := rvbNone;
  Color := clWindowText;
  Width := 1;
  InternalWidth := 1;
end;
{------------------------------------------------------------------------------}
{ Destructor }
destructor TRVBorder.Destroy;
begin
  FBorderOffsets.Free;
  FVisibleBorders.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Assigns TRVBorder (Source) to TRVBorder (Self). }
procedure TRVBorder.Assign(Source: TPersistent);
begin
  if Source is TRVBorder then begin
    Width := TRVBorder(Source).Width;
    Style := TRVBorder(Source).Style;
    Color := TRVBorder(Source).Color;
    InternalWidth := TRVBorder(Source).InternalWidth;
    VisibleBorders.Assign(TRVBorder(Source).VisibleBorders);
    BorderOffsets.Assign(TRVBorder(Source).BorderOffsets);
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ WRITE method for BorderOffsets property. }
procedure TRVBorder.SetBorderOffsets(const Value: TRVRect);
begin
  FBorderOffsets.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ WRITE method for VisibleBorders property. }
procedure TRVBorder.SetVisibleBorders(const Value: TRVBooleanRect);
begin
  FVisibleBorders.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ Draws border on Canvas at the rectangle Rect. Widths and offsets are adjusted
  according to the device resolution specified in sad.
  Colors are corrected according to ColorMode. }
procedure TRVBorder.DrawSaD(Rect: TRect; Canvas: TCanvas; RVStyle: TRVStyle;
  const sad: TRVScreenAndDevice; ColorMode: TRVColorMode;
  GraphicInterface: TRVGraphicInterface);
begin
  if Style = rvbNone then exit;
  ScaleRect(Rect, sad); // does nothing
  BorderOffsets.InflateRectSaD(Rect, RVStyle, sad);
  DoDraw(Rect, Canvas,
    RVStyle.GetAsDevicePixelsX(Width, @sad), RVStyle.GetAsDevicePixelsY(Width, @sad),
    RVStyle.GetAsDevicePixelsX(InternalWidth, @sad), RVStyle.GetAsDevicePixelsY(InternalWidth, @sad),
    ColorMode, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Draws border on Canvas at the rectangle Rect. }
procedure TRVBorder.Draw(Rect: TRect; Canvas: TCanvas; RVStyle: TRVStyle;
  GraphicInterface: TRVGraphicInterface);
var w, iw: Integer;
begin
  if Style = rvbNone then exit;
  BorderOffsets.InflateRect(Rect, RVStyle);
  w := RVStyle.GetAsPixels(Width);
  iw := RVStyle.GetAsPixels(InternalWidth);
   DoDraw(Rect, Canvas, w, w, iw, iw, rvcmColor, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Draws border on Canvas at the rectangle Rect. This method is called by Draw
  and DrawSaD.
  Colors are corrected according to ColorMode. }
procedure TRVBorder.DoDraw(ARect: TRect; Canvas: TCanvas;
  WidthLR, WidthTB, InternalWidthLR, InternalWidthTB: Integer;
  ColorMode: TRVColorMode;
  GraphicInterface: TRVGraphicInterface);
var Count, wTB, wLR: Integer;
begin
  InflateRect(ARect,1,1);
  with Canvas.Pen do begin
    //Width := Self.Width;
    case ColorMode of
      rvcmColor:
        Color := Self.Color;
      rvcmPrinterColor:
        Color := RV_GetPrnColor(Self.Color);
      rvcmGrayScale:
        Color := RV_GetGray(RV_GetPrnColor(Self.Color));
      rvcmBlackAndWhite,  rvcmBlackOnWhite:
        Color := clBlack;
    end;
  end;
  case Style of
    rvbSingle:
      Count := 1;
    rvbDouble, rvbThickInside, rvbThickOutside:
      Count := 2;
    rvbTriple:
      Count := 3;
    else
      Count := 1;
  end;
  while Count>0 do begin
    if ((Count=1) and (Style=rvbThickOutside)) or
       ((Count=2) and (Style=rvbThickInside)) then
      wTB := WidthTB*2
    else
      wTB := WidthTB;
    //if wTB=1 then begin
    //  Canvas.Pen.Style := psInsideFrame;
    //  Canvas.Pen.Width := wTB;
    //  end
    //else
    begin
      Canvas.Brush.Style := bsSolid;
      Canvas.Brush.Color := Color;
      Canvas.Pen.Width := 0;
      Canvas.Pen.Style := psClear;
    end;
    if WidthLR<>WidthTB then begin
      if ((Count=1) and (Style=rvbThickOutside)) or
         ((Count=2) and (Style=rvbThickInside)) then
        wLR := WidthLR*2
      else
        wLR := WidthLR;
      end
    else begin
      wLR  := wTB;
    end;
    if VisibleBorders.Top then
      //if wTB=1 then
      //  GraphicInterface.Line(Canvas, ARect.Left,ARect.Top,  ARect.Right+1,ARect.Top)
      //else
        GraphicInterface.FillRect(Canvas,
          Rect(ARect.Left-wLR+1, ARect.Top-wTB+1, ARect.Right+wLR, ARect.Top+1));
    if VisibleBorders.Bottom then
      //if wTB=1 then
      //  GraphicInterface.Line(Canvas, ARect.Left,ARect.Bottom, ARect.Right+1,ARect.Bottom)
      //else
        GraphicInterface.FillRect(Canvas,
          Rect(ARect.Left-wLR+1, ARect.Bottom, ARect.Right+wLR, ARect.Bottom+wTB));
    if wLR<>wTB then
      //if wLR=1 then begin
      //  Canvas.Pen.Style := psInsideFrame;
      //  Canvas.Pen.Width := wLR;
      //  end
      //else
      begin
        Canvas.Brush.Style := bsSolid;
        Canvas.Brush.Color := Color;
        Canvas.Pen.Width := 0;
        Canvas.Pen.Style := psClear;;
      end;
    if VisibleBorders.Right then
      //if wLR=1 then
      //  GraphicInterface.Line(Canvas, ARect.Right,ARect.Top, ARect.Right,ARect.Bottom+1)
      //else
        GraphicInterface.FillRect(Canvas,
          Rect(ARect.Right, ARect.Top-wTB+1, ARect.Right+wLR, ARect.Bottom+wTB));
    if VisibleBorders.Left then
      //if wLR=1 then
      //  GraphicInterface.Line(Canvas, ARect.Left,ARect.Top, ARect.Left,ARect.Bottom+1)
      //else
        GraphicInterface.FillRect(Canvas,
          Rect(ARect.Left-wLR+1, ARect.Top-wTB+1, ARect.Left+1, ARect.Bottom+wTB));
    InflateRect(ARect, InternalWidthLR+wLR, InternalWidthTB+wTB);
    dec(Count);
  end;
  Canvas.Pen.Width := 1;
end;
{------------------------------------------------------------------------------}
{ Is this border equal to Value? }
function TRVBorder.IsEqual(Value: TRVBorder): Boolean;
begin
  Result := (Style = Value.Style) and
            (Color = Value.Color) and
            (Width = Value.Width) and
            (InternalWidth = Value.InternalWidth) and
            BorderOffsets.IsEqual(Value.BorderOffsets) and
            VisibleBorders.IsEqual(Value.VisibleBorders);
end;
{------------------------------------------------------------------------------}
{ Are the specified properties of this border equal to the properties of Value?
  IgnoreList specifies properties that must be ignored when comparing. }
function TRVBorder.IsEqual_Para(Value: TRVBorder; IgnoreList: TRVParaInfoProperties): Boolean;
begin
  Result := ((rvpiBorder_Style in IgnoreList) or (Style = Value.Style)) and
            ((rvpiBorder_Color in IgnoreList) or (Color = Value.Color)) and
            ((rvpiBorder_Width in IgnoreList) or (Width = Value.Width)) and
            ((rvpiBorder_InternalWidth in IgnoreList) or (InternalWidth = Value.InternalWidth)) and
            BorderOffsets.IsEqualEx(Value.BorderOffsets,
              rvpiBorder_BO_Left in IgnoreList,
              rvpiBorder_BO_Top in IgnoreList,
              rvpiBorder_BO_Right in IgnoreList,
              rvpiBorder_BO_Bottom in IgnoreList) and
            VisibleBorders.IsEqualEx(Value.VisibleBorders,
              rvpiBorder_Vis_Left in IgnoreList,
              rvpiBorder_Vis_Top in IgnoreList,
              rvpiBorder_Vis_Right in IgnoreList,
              rvpiBorder_Vis_Bottom in IgnoreList);
end;
{------------------------------------------------------------------------------}
{ Assign properties from Source, listed in ValidProperties. }
procedure TRVBorder.AssignValidProperties(Source: TRVBorder;
  ValidProperties: TRVParaInfoProperties1);
begin
  if (rvpiBorder_Style in ValidProperties) then
    Style := Source.Style;
  if (rvpiBorder_Color in ValidProperties) then
    Color := Source.Color;
  if (rvpiBorder_Width in ValidProperties) then
    Width := Source.Width;
  if (rvpiBorder_InternalWidth in ValidProperties) then
    InternalWidth := Source.InternalWidth;
  BorderOffsets.AssignValidProperties(Source.BorderOffsets,
    rvpiBorder_BO_Left   in ValidProperties,
    rvpiBorder_BO_Top    in ValidProperties,
    rvpiBorder_BO_Right  in ValidProperties,
    rvpiBorder_BO_Bottom in ValidProperties);
  VisibleBorders.AssignValidProperties(Source.VisibleBorders,
    rvpiBorder_Vis_Left   in ValidProperties,
    rvpiBorder_Vis_Top    in ValidProperties,
    rvpiBorder_Vis_Right  in ValidProperties,
    rvpiBorder_Vis_Bottom in ValidProperties);
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this border and Value.
  The larger value - the higher similarity. }
function TRVBorder.SimilarityValue(Value: TRVBorder; Wht: Integer): Integer;
var vis1,vis2: array[0..3] of Boolean;
    sum,i: Integer;
begin
  Result := 0;
  vis1[0] := ((Style<>rvbNone) and VisibleBorders.Left);
  vis2[0] := ((Value.Style<>rvbNone) and Value.VisibleBorders.Left);
  vis1[1] := ((Style<>rvbNone) and VisibleBorders.Top);
  vis2[1] := ((Value.Style<>rvbNone) and Value.VisibleBorders.Top);
  vis1[2] := ((Style<>rvbNone) and VisibleBorders.Right);
  vis2[2] := ((Value.Style<>rvbNone) and Value.VisibleBorders.Right);
  vis1[3] := ((Style<>rvbNone) and VisibleBorders.Bottom);
  vis2[3] := ((Value.Style<>rvbNone) and Value.VisibleBorders.Bottom);
  sum := 0;
  for i := 0 to 3 do begin
    inc(sum, ord(vis1[i] and vis2[i]));
  end;
  if sum>0 then begin
    Result := RV_CompareColors(Color, Value.Color, RVSMW_EACHRGBCOLOR, RVSMW_COLORSET)+
              RV_CompareInts(Width, Value.Width, RVSMW_WIDTH div Wht)+
              RV_CompareInts(InternalWidth, Value.InternalWidth, RVSMW_WIDTH div Wht);
    if Style = Value.Style then
      inc(Result, RVSMW_BORDERSTYLE);
    Result := Result * sum;
  end;
  for i := 0 to 3 do begin
    if not vis1[i] and not vis2[i] then
      inc(Result, RVSMW_BORDERNOSIDE);
    if vis1[i] <> vis2[i] then
      dec(Result, RVSMW_BORDERNOSIDE);
  end;
  if vis1[0] and vis2[0] then
    inc(Result, RV_CompareInts(BorderOffsets.Left, Value.BorderOffsets.Left, RVSMW_PADDING div Wht));
  if vis1[1] and vis2[1] then
    inc(Result, RV_CompareInts(BorderOffsets.Top, Value.BorderOffsets.Top, RVSMW_PADDING div Wht));
  if vis1[2] and vis2[2] then
    inc(Result, RV_CompareInts(BorderOffsets.Right, Value.BorderOffsets.Right, RVSMW_PADDING div Wht));
  if vis1[3] and vis2[3] then
    inc(Result, RV_CompareInts(BorderOffsets.Bottom, Value.BorderOffsets.Bottom, RVSMW_PADDING div Wht));
end;
{------------------------------------------------------------------------------}
{ Returns the total width of border, including all line widths and gaps. }
function TRVBorder.GetTotalWidth: TRVStyleLength;
begin
  case Style of
    rvbSingle:
      Result := Width;
    rvbDouble:
      Result := 2*Width+InternalWidth;
    rvbTriple:
      Result := 3*Width+2*InternalWidth;
    rvbThickInside, rvbThickOutside:
      Result := 3*Width+InternalWidth;
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVBorder.ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
begin
  BorderOffsets.ConvertToDifferentUnits(RVStyle, NewUnits);
  Width := RVStyle.GetAsDifferentUnits(Width, NewUnits);
  InternalWidth := RVStyle.GetAsDifferentUnits(InternalWidth, NewUnits);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVBorder.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
begin
  Width := ini.ReadInteger(Section, Format(fs,[RVINI_WIDTH]), 1);
  Style := TRVBorderStyle(ini.ReadInteger(Section, Format(fs,[RVINI_STYLE]), ord(rvbNone)));
  Color := ini.ReadInteger(Section, Format(fs,[RVINI_COLOR]), clWindowText);
  InternalWidth := ini.ReadInteger(Section, Format(fs,[RVINI_INTERNALWIDTH]), 1);
  BorderOffsets.LoadFromINI(ini,  Section, Format(fs,[RVINI_BOFFSPREFIX]));
  VisibleBorders.LoadFromINI(ini, Section, Format(fs,[RVINI_VISBPREFIX]));
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVBorder.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_WIDTH]), Width, 1);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_STYLE]), ord(Style), ord(rvbNone));
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_COLOR]), Color, clWindowText);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_INTERNALWIDTH]), InternalWidth, 1);
  BorderOffsets.SaveToINI(ini,    Section, Format(fs,[RVINI_BOFFSPREFIX]));
  VisibleBorders.SaveToINI(ini, Section, Format(fs,[RVINI_VISBPREFIX]));
end;
{$ENDIF}
{============================== TRVBackgroundRect =============================}
{ Constructor, creates a transparent border with zero padding. }
constructor TRVBackgroundRect.Create(AOwner: TPersistent);
begin
  inherited Create;
  FOwner := AOwner;
  FBorderOffsets := TRVRect.CreateOwned(Self);
  Color := clNone
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TRVBackgroundRect.Destroy;
begin
  FBorderOffsets.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Assigns TRVBackgroundRect (Source) to TRVBackgroundRect (Self). }
procedure TRVBackgroundRect.Assign(Source: TPersistent);
begin
  if Source is TRVBackgroundRect then begin
    Color := TRVBackgroundRect(Source).Color;
    BorderOffsets := TRVBackgroundRect(Source).BorderOffsets;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Adds padding (BorderOffs) to Rect. }
procedure TRVBackgroundRect.PrepareDraw(var Rect: TRect; RVStyle: TRVStyle);
begin
  BorderOffsets.InflateRect(Rect, RVStyle);
end;
{------------------------------------------------------------------------------}
{ Adds corrected padding (BorderOffs) to Rect.
  Corrections is made according to the device resolution specified in sad. }
procedure TRVBackgroundRect.PrepareDrawSaD(var Rect: TRect; RVStyle: TRVStyle;
  const sad: TRVScreenAndDevice);
begin
  BorderOffsets.InflateRectSaD(Rect, RVStyle, sad);
end;
{------------------------------------------------------------------------------}
{ Draws background on the Canvas at the rectangle Rect.
  If Printing, this is a printing or print preview.
  Colors are corrected according to the ColorMode. }
procedure TRVBackgroundRect.Draw(Rect: TRect; Canvas: TCanvas;
  Printing: Boolean; ColorMode: TRVColorMode; GraphicInterface: TRVGraphicInterface);
begin
  if (Color=clNone) or (ColorMode in [rvcmBlackAndWhite, rvcmBlackOnWhite]) then
    exit;
  Canvas.Brush.Style := bsSolid;
  case ColorMode of
    rvcmColor:
      Canvas.Brush.Color := Color;
    rvcmPrinterColor:
      Canvas.Brush.Color := RV_GetPrnColor(Color);
    rvcmGrayScale:
      Canvas.Brush.Color := RV_GetGray(RV_GetPrnColor(Color));
  end;
  Canvas.Pen.Style := psClear;
  inc(Rect.Right);
  inc(Rect.Bottom);
  GraphicInterface.FillRect(Canvas, Rect);
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
end;
{------------------------------------------------------------------------------}
{ WRITE method for BorderOffsets property. }
procedure TRVBackgroundRect.SetBorderOffsets(const Value: TRVRect);
begin
  FBorderOffsets.Assign(Value);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVBackgroundRect.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  Color := ini.ReadInteger(Section, Format(fs,[RVINI_COLOR]), clNone);
  BorderOffsets.LoadFromINI(ini,  Section, Format(fs,[RVINI_BOFFSPREFIX]));
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVBackgroundRect.SaveToINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_COLOR]), Color, clNone);
  BorderOffsets.SaveToINI(ini,    Section, Format(fs,[RVINI_BOFFSPREFIX]));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Is this background equal to Value? }
function TRVBackgroundRect.IsEqual(Value: TRVBackgroundRect): Boolean;
begin
  Result := (Color = Value.Color) and
            BorderOffsets.IsEqual(Value.BorderOffsets);
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this background and Value.
  The larger value - the higher similarity. }
function TRVBackgroundRect.SimilarityValue(
  Value: TRVBackgroundRect; Wht: Integer): Integer;
begin
  Result := RV_CompareColors(Color, Value.Color, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET)+
            BorderOffsets.SimilarityValue(Value.BorderOffsets, RVSMW_PADDING, Wht);
end;
{------------------------------------------------------------------------------}
{ Are the specified properties of this background equal to the properties of Value?
  IgnoreList specifies properties that must be ignored when comparing. }
function TRVBackgroundRect.IsEqual_Para(Value: TRVBackgroundRect;
  IgnoreList: TRVParaInfoProperties): Boolean;
begin
  Result := ((rvpiBackground_Color in IgnoreList) or (Color = Value.Color)) and
            BorderOffsets.IsEqualEx(Value.BorderOffsets,
            rvpiBackground_BO_Left in IgnoreList,
            rvpiBackground_BO_Top in IgnoreList,
            rvpiBackground_BO_Right in IgnoreList,
            rvpiBackground_BO_Bottom in IgnoreList);
end;
{------------------------------------------------------------------------------}
{ Assigns properties from Source, listed in ValidProperties }
procedure TRVBackgroundRect.AssignValidProperties(Source: TRVBackgroundRect;
  ValidProperties: TRVParaInfoProperties1);
begin
  if (rvpiBackground_Color in ValidProperties) then
    Color := Source.Color;
  BorderOffsets.AssignValidProperties(Source.BorderOffsets,
    rvpiBackground_BO_Left in ValidProperties,
    rvpiBackground_BO_Top in ValidProperties,
    rvpiBackground_BO_Right in ValidProperties,
    rvpiBackground_BO_Bottom in ValidProperties);
end;
{=========================== TRVTabInfo =======================================}
{$IFNDEF RVDONOTUSETABS}
{$IFDEF RICHVIEWCBDEF3}
{ Designtime support. Returns a string to display for the tab in the collection
  editor.
  This string has format "<align> at <position>".
  If Leader is not empty, it's added to the end of the string. }
function TRVTabInfo.GetDisplayName: String;
begin
  Result := RVAlignStr[ord(Align)]+' at '+IntToStr(Position);
  if Leader<>'' then
    Result := Result+' ('+Leader+Leader+Leader+
      Leader+Leader+Leader+')';
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Is this tabstop equal to Value? }
function TRVTabInfo.IsEqual(Value: TRVTabInfo): Boolean;
begin
  Result := (Position=Value.Position) and
            (Align=Value.Align) and
            (Leader=Value.Leader);
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this tabstop and Value.
  The larger value - the higher similarity. }
function TRVTabInfo.SimilarityValue(Value: TRVTabInfo; Wht: Integer): Integer;
begin
  Result := RV_CompareInts(Position, Value.Position, RVSMW_TABPOS div Wht);
  if Align=Value.Align then
    inc(Result, RVSMW_TABALIGN);
  if Leader=Value.Leader then
    inc(Result, RVSMW_LEADER);
end;
{------------------------------------------------------------------------------}
{ WRITE method for Position property.
  Assigns the property value and resort the collection of tabstops. }
procedure TRVTabInfo.SetPosition(const Value: TRVStyleLength);
begin
  if Value <> FPosition then begin
    FPosition := Value;
    if Collection<>nil then
      with TRVTabInfos(Collection) do begin
        BeginUpdate;
        try
          SortTabs;
        finally
          EndUpdate;
        end;
      end;
  end;
end;
{------------------------------------------------------------------------------}
{ STORED method for Leader property.
  Should Leader value be stored? }
function TRVTabInfo.StoreLeader: Boolean;
begin
  Result := Leader<>'';
end;
{------------------------------------------------------------------------------}
{ Assigns the tabstop Source to Self. }
procedure TRVTabInfo.Assign(Source: TPersistent);
begin
  if Source is TRVTabInfo then begin
    Position := TRVTabInfo(Source).Position;
    Align    := TRVTabInfo(Source).Align;
    Leader   := TRVTabInfo(Source).Leader;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Function for comparing position of tabstops. Used to sort the collection.    }
function CompareTabs(Item1, Item2: Pointer): Integer;
begin
  Result := TRVTabInfo(Item1).Position-TRVTabInfo(Item2).Position;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVTabInfo.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  Position := ini.ReadInteger(Section, Format(fs,[RVINI_TABPOSITION]), 0);
  Align    := TRVTabAlign(ini.ReadInteger(Section, Format(fs,[RVINI_TABALIGN]), 0));
  Leader   := ini.ReadString(Section, Format(fs,[RVINI_TABLEADER]), '');
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVTabInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_TABPOSITION]), Position, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_TABALIGN]), ord(Align), 0);
  if Leader<>'' then
    ini.WriteString(Section, Format(fs,[RVINI_TABLEADER]), Leader);
end;
{$ENDIF}
{=============================== TRVTabInfos ==================================}
{ Constructor. Creates empty collection of TRVTabInfo. }
constructor TRVTabInfos.Create(Owner: TPersistent);
begin
  inherited Create(TRVTabInfo);
  FOwner := Owner;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Designtime support. Required for the collection editor. }
function TRVTabInfos.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Sorts tabs by Position in ascending order.
  This method is called automatically when Items[].Position is changed         }
procedure TRVTabInfos.SortTabs;
var
  i: Integer;
  List: TList;
begin
  List := TList.Create;
  try
    for i := 0 to Count - 1 do
      List.Add(Items[i]);
    List.Sort(CompareTabs);
    for i := 0 to List.Count - 1 do
      TRVTabInfo(List.Items[i]).Index := i
  finally
    List.Free;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVTabInfos.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String);
var i,c: Integer;
begin
  Clear;
  c := ini.ReadInteger(Section, Format(fs,[RVINI_TABCOUNT]), 0);
  for i := 0 to c-1 do
    Add.LoadFromINI(ini, Section, Format(fs,[''])+RVINI_TABPREFIX+IntToStr(i));
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TRVTabInfos.SaveToINI(ini: TRVIniFile; const Section,
  fs: String);
var i: Integer;
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_TABCOUNT]), Count, 0);
  for i := 0 to Count-1 do
    Items[i].SaveToINI(ini, Section, Format(fs,[''])+RVINI_TABPREFIX+IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Adds a new item (added because of typecasting). }
function TRVTabInfos.Add: TRVTabInfo;
begin
  Result := TRVTabInfo(inherited Add);
end;
{------------------------------------------------------------------------------}
{ READ method for Items[] property. }
function TRVTabInfos.GetItem(Index: Integer): TRVTabInfo;
begin
  Result := TRVTabInfo(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for Items[] property. }
procedure TRVTabInfos.SetItem(Index: Integer; Value: TRVTabInfo);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{ Is this collection of tabstops equal to Value? }
function TRVTabInfos.IsEqual(Value: TRVTabInfos): Boolean;
var i: Integer;
begin
  Result := Count=Value.Count;
  if not Result then
    exit;
  for i := 0 to Count-1 do
    if not Items[i].IsEqual(Value[i]) then begin
      Result := False;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
{ Returns index of tab with the given Position (or -1 if not found).
  Collection must be sorted.                                                   }
function TRVTabInfos.Find(Position: Integer): Integer;
var a,b,c: Integer;
begin
  Result := -1;
  if Count=0 then
    exit;
  a := 0;
  b := Count-1;
  while (b-a)>1 do begin
     c := (a+b) div 2;
    if Items[c].Position<Position then
      a := c
    else
      b := c;
  end;
  if Items[a].Position=Position then
    Result := a
  else if Items[b].Position=Position then
    Result := b;
end;
{------------------------------------------------------------------------------}
{ Deletes all tabs that not present in Value. Only tabs with all
  common properties are not deleted.                                           }
procedure TRVTabInfos.Intersect(Value: TRVTabInfos);
var i, Index: Integer;
begin
  for i := Count-1 downto 0 do begin
    Index := Value.Find(Items[i].Position);
    if (Index<0) or not Items[i].IsEqual(Value[Index]) then
      Items[i].Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Adds tabs from sources. New tabs are inserted, existing tabs are updated.    }
procedure TRVTabInfos.AddFrom(Source: TRVTabInfos);
var i, Index: Integer;
begin
  for i := 0 to Source.Count-1 do begin
    Index := Find(Source[i].Position);
    if Index<0 then begin
      Add;
      Index := Count-1;
    end;
    Items[Index].Assign(Source[i]);
  end;
end;
{------------------------------------------------------------------------------}
{ Deletes tabs with the specified positions                                    }
procedure TRVTabInfos.DeleteList(Positions: TRVIntegerList);
var i, Index: Integer;
begin
  for i := 0 to Positions.Count-1 do begin
    Index := Find(Positions[i]);
    if Index>=0 then
      Items[Index].Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this collection of tabstops and Value.
  The greater value - the higher similarity. }
function TRVTabInfos.SimilarityValue(Value: TRVTabInfos; Wht: Integer): Integer;
var i, MinCount: Integer;
begin
  if Count<Value.Count then
    MinCount := Count
  else
    MinCount := Value.Count;
  Result := 0;
  for i := 0 to MinCount-1 do
    inc(Result, Items[i].SimilarityValue(Value[i], Wht));
  dec(Result, (Count-MinCount)*RVSMW_NOTAB);
  dec(Result, (Value.Count-MinCount)*RVSMW_NOTAB);
end;
{------------------------------------------------------------------------------}
{ Converts all tab positions from RVStyle.Units to NewUnits }
procedure TRVTabInfos.ConvertToDifferentUnits(RVStyle: TRVStyle; NewUnits: TRVStyleUnits);
var i: Integer;
begin
  BeginUpdate;
  try
    for i := 0 to Count-1 do
      Items[i].FPosition := RVStyle.GetAsDifferentUnits(Items[i].Position, NewUnits);
    SortTabs;
  finally
    EndUpdate;
  end;
end;
{$ENDIF}
{============================= TCustomRVParaInfo ==============================}
{ Constructor. Creates left-aligned parameters with zero indents and spacing,
  without background, border and tabs.
  Default style name is 'Paragraph Style'. }
constructor TCustomRVParaInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FirstIndent := 0;
  LeftIndent  := 0;
  RightIndent := 0;
  Alignment   := rvaLeft;
  FName       := RVDEFAULTPARASTYLENAME;
  FBorder     := TRVBorder.Create(Self);
  FBackground := TRVBackgroundRect.Create(Self);
  {$IFNDEF RVDONOTUSETABS}
  FTabs       := TRVTabInfos.Create(Self);
  {$ENDIF}
  LineSpacingType := rvlsPercent;
  LineSpacing := 100;
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TCustomRVParaInfo.Destroy;
begin
  FBorder.Free;
  FBackground.Free;
  {$IFNDEF RVDONOTUSETABS}
  FTabs.Free;
  {$ENDIF}
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ WRITE method for Border property. }
procedure TCustomRVParaInfo.SetBorder(const Value: TRVBorder);
begin
  FBorder.Assign(Value);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSETABS}
{ WRITE method for Tabs property. }
procedure TCustomRVParaInfo.SetTabs(const Value: TRVTabInfos);
begin
  FTabs.Assign(Value);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ WRITE method for SpaceAfter property. }
procedure TCustomRVParaInfo.SetSpaceAfter(const Value: TRVStyleLength);
begin
  FSpaceAfter := Value;
  if FSpaceAfter<0 then
    FSpaceAfter := 0;
end;
{------------------------------------------------------------------------------}
{ WRITE method for SpaceBefore property. }
procedure TCustomRVParaInfo.SetSpaceBefore(const Value: TRVStyleLength);
begin
  FSpaceBefore := Value;
  if FSpaceBefore<0 then
    FSpaceBefore := 0;
end;
{------------------------------------------------------------------------------}
{ WRITE method for Background property. }
procedure TCustomRVParaInfo.SetBackground(const Value: TRVBackgroundRect);
begin
  FBackground.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ Is there nondefault line spacing? }
function TCustomRVParaInfo.ExtraLineSpacing: Boolean;
begin
  case LineSpacingType of
    rvlsPercent:
      Result := LineSpacing<>100;
    rvlsSpaceBetween, rvlsLineHeightAtLeast, rvlsLineHeightExact:
      Result := LineSpacing>0;
    else
      Result := False;
  end;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is TCustomRVParaInfo. }
procedure TCustomRVParaInfo.Assign(Source: TPersistent);
begin
  if Source is TCustomRVParaInfo then begin
    FirstIndent := TCustomRVParaInfo(Source).FirstIndent;
    LeftIndent  := TCustomRVParaInfo(Source).LeftIndent;
    RightIndent := TCustomRVParaInfo(Source).RightIndent;
    Alignment   := TCustomRVParaInfo(Source).Alignment;
    SpaceBefore := TCustomRVParaInfo(Source).SpaceBefore;
    SpaceAfter  := TCustomRVParaInfo(Source).SpaceAfter;
    LineSpacing := TCustomRVParaInfo(Source).LineSpacing;
    LineSpacingType := TCustomRVParaInfo(Source).LineSpacingType;
    Background  := TCustomRVParaInfo(Source).Background;
    Border      := TCustomRVParaInfo(Source).Border;
    {$IFNDEF RVDONOTUSETABS}
    Tabs        := TCustomRVParaInfo(Source).Tabs;
    {$ENDIF}
    Options     := TCustomRVParaInfo(Source).Options;
    BiDiMode    := TCustomRVParaInfo(Source).BiDiMode;
    OutlineLevel := TCustomRVParaInfo(Source).OutlineLevel;    
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Assigns properties listed in Props1 and Props2 from Source to Self. }
procedure TCustomRVParaInfo.AssignSelectedProperties(
  Source: TCustomRVParaInfo; Props: TRVParaInfoProperties);
   {.............................................................}
   procedure ChangeOption(Option: TRVParaOption; OptionId: TRVParaInfoProperty2);
   begin
     if OptionId in Props then
       if Option in Source.Options then
         Options := Options+[Option]
       else
         Options := Options-[Option];
   end;
   {.............................................................}
begin
  if (rvpiFirstIndent in Props) then
    FirstIndent := Source.FirstIndent;
  if (rvpiLeftIndent in Props) then
    LeftIndent := Source.LeftIndent;
  if (rvpiRightIndent in Props) then
    RightIndent := Source.RightIndent;
  if (rvpiSpaceBefore in Props) then
    SpaceBefore := Source.SpaceBefore;
  if (rvpiSpaceAfter in Props) then
    SpaceAfter := Source.SpaceAfter;
  if (rvpiAlignment in Props) then
    Alignment := Source.Alignment;
  if (rvpiLineSpacing in Props) then
    LineSpacing := Source.LineSpacing;
  if (rvpiLineSpacingType in Props) then
    LineSpacingType := Source.LineSpacingType;
  Background.AssignValidProperties(Source.Background, Props);
  Border.AssignValidProperties(Source.Border, Props);
  ChangeOption(rvpaoNoWrap, rvpiNoWrap);
  ChangeOption(rvpaoReadOnly, rvpiReadOnly);
  ChangeOption(rvpaoStyleProtect, rvpiStyleProtect);
  ChangeOption(rvpaoDoNotWantReturns, rvpiDoNotWantReturns);
  ChangeOption(rvpaoKeepLinesTogether, rvpiKeepLinesTogether);
  ChangeOption(rvpaoKeepWithNext, rvpiKeepWithNext);
  {$IFNDEF RVDONOTUSETABS}
  if (rvpiTabs in Props) then
    Tabs := Source.Tabs;
  {$ENDIF}
  if (rvpiBiDiMode in Props) then
    BiDiMode := Source.BiDiMode;
  if (rvpiOutlineLevel in Props) then
    OutlineLevel := Source.OutlineLevel;
  { rvpiNextParaNo, rvpiDefStyleNo - not assigned }
end;
{------------------------------------------------------------------------------}
{ Is this paragraph style equal to Value?
  IgnoreID parameter is not used.
  BaseStyleNo is ignored. }
function TCustomRVParaInfo.IsSimpleEqual(Value: TCustomRVInfo;
  IgnoreReferences, IgnoreID: Boolean): Boolean;
begin
  Result :=
    (Alignment       = TCustomRVParaInfo(Value).Alignment  ) and
    (FirstIndent     = TCustomRVParaInfo(Value).FirstIndent) and
    (LeftIndent      = TCustomRVParaInfo(Value).LeftIndent ) and
    (RightIndent     = TCustomRVParaInfo(Value).RightIndent) and
    (SpaceBefore     = TCustomRVParaInfo(Value).SpaceBefore) and
    (SpaceAfter      = TCustomRVParaInfo(Value).SpaceAfter) and
    (LineSpacing     = TCustomRVParaInfo(Value).LineSpacing) and
    (LineSpacingType = TCustomRVParaInfo(Value).LineSpacingType) and
    (Options         = TCustomRVParaInfo(Value).Options) and
    (BiDiMode        = TCustomRVParaInfo(Value).BiDiMode) and
    (OutlineLevel    = TCustomRVParaInfo(Value).OutlineLevel) and    
    Background.IsEqual(TCustomRVParaInfo(Value).Background) and
    {$IFNDEF RVDONOTUSETABS}
    Tabs.IsEqual(TParaInfo(Value).Tabs) and
    {$ENDIF}
    Border.IsEqual(TParaInfo(Value).Border) and
    (not RichViewCompareStyleNames or (StyleName=TCustomRVParaInfo(Value).StyleName));
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this paragraph style and Value.
  The greater value - the higher similarity.
  BaseStyleNo, NextParaNo, DefStyleNo are ignored. }
function TCustomRVParaInfo.SimilarityValue(Value: TCustomRVInfo): Integer;
var Wht: Integer;
begin
  if GetRVStyle.Units=rvstuPixels then
    Wht := 1
  else
    Wht := 15;
  Result :=
    RV_CompareInts(FirstIndent, TParaInfo(Value).FirstIndent, RVSMW_INDENT div Wht)+
    RV_CompareInts(LeftIndent,  TParaInfo(Value).LeftIndent,  RVSMW_INDENT div Wht)+
    RV_CompareInts(RightIndent, TParaInfo(Value).RightIndent, RVSMW_INDENT div Wht)+
    RV_CompareInts(SpaceBefore, TParaInfo(Value).SpaceBefore, RVSMW_INDENT div Wht)+
    RV_CompareInts(SpaceAfter, TParaInfo(Value).SpaceAfter, RVSMW_INDENT div Wht)+
    Background.SimilarityValue(TParaInfo(Value).Background, Wht)+
    {$IFNDEF RVDONOTUSETABS}
    Tabs.SimilarityValue(TParaInfo(Value).Tabs, Wht)+
    {$ENDIF}
    Border.SimilarityValue(TParaInfo(Value).Border, Wht);
  if (Alignment = TParaInfo(Value).Alignment) then
    inc(Result, RVSMW_ALIGNMENT);
  if (BiDiMode = TParaInfo(Value).BiDiMode) then
    inc(Result, RVSMW_PARABIDIMODE);
  if (OutlineLevel = TParaInfo(Value).OutlineLevel) then
    inc(Result, RVSMW_OUTLINELEVEL);
  if ((rvpaoNoWrap in Options) = (rvpaoNoWrap in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_NOWRAP);
  if ((rvpaoReadOnly in Options) = (rvpaoReadOnly in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_READONLY);
  if ((rvpaoStyleProtect in Options) = (rvpaoStyleProtect in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_STYLEPROTECT);
  if ((rvpaoDoNotWantReturns in Options) = (rvpaoDoNotWantReturns in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_DONOTWANTRETURNS);
  if ((rvpaoKeepLinesTogether in Options) = (rvpaoKeepLinesTogether in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_KEEPLINESTOGETHER);
  if ((rvpaoKeepWithNext in Options) = (rvpaoKeepWithNext in TParaInfo(Value).Options)) then
    inc(Result, RVSMW_KEEPWITHNEXT);
  if (LineSpacingType=TParaInfo(Value).LineSpacingType) then
    if LineSpacingType=rvlsPercent then
      inc(Result, RV_CompareInts(LineSpacing, TParaInfo(Value).LineSpacing, RVSMW_LINESPACING))
    else
      inc(Result, RV_CompareInts(LineSpacing, TParaInfo(Value).LineSpacing, RVSMW_LINESPACING div Wht))
  else if ExtraLineSpacing<>TParaInfo(Value).ExtraLineSpacing then
    dec(Result, RVSMW_LINESPACING*4);
end;
{------------------------------------------------------------------------------}
{ Is the specified properties of this paragraph style equal to the properties of
  Value. IgnoreList lists properties which will be ignored when comparing.
  BaseStyleNo is always ignored. }
function TCustomRVParaInfo.IsEqual(Value: TCustomRVParaInfo;
  IgnoreList: TRVParaInfoProperties): Boolean;
begin
  Result :=
    ((rvpiAlignment       in IgnoreList) or (Alignment       = Value.Alignment)) and
    ((rvpiFirstIndent     in IgnoreList) or (FirstIndent     = Value.FirstIndent)) and
    ((rvpiLeftIndent      in IgnoreList) or (LeftIndent      = Value.LeftIndent)) and
    ((rvpiRightIndent     in IgnoreList) or (RightIndent     = Value.RightIndent)) and
    ((rvpiSpaceBefore     in IgnoreList) or (SpaceBefore     = Value.SpaceBefore)) and
    ((rvpiSpaceAfter      in IgnoreList) or (SpaceAfter     = Value.SpaceAfter)) and
    ((rvpiLineSpacing     in IgnoreList) or (LineSpacing     = Value.LineSpacing)) and
    ((rvpiLineSpacingType in IgnoreList) or (LineSpacingType = Value.LineSpacingType)) and
    ((rvpiNoWrap          in IgnoreList) or ((rvpaoNoWrap in Options) = (rvpaoNoWrap in TParaInfo(Value).Options))) and
    ((rvpiReadOnly        in IgnoreList) or ((rvpaoReadOnly in Options) = (rvpaoReadOnly in TParaInfo(Value).Options))) and
    ((rvpiStyleProtect    in IgnoreList) or ((rvpaoStyleProtect in Options) = (rvpaoStyleProtect in TParaInfo(Value).Options))) and
    ((rvpiDoNotWantReturns in IgnoreList) or ((rvpaoDoNotWantReturns in Options) = (rvpaoDoNotWantReturns in TParaInfo(Value).Options))) and
    ((rvpiKeepLinesTogether in IgnoreList) or ((rvpaoKeepLinesTogether in Options) = (rvpaoKeepLinesTogether in TParaInfo(Value).Options))) and
    ((rvpiKeepWithNext    in IgnoreList) or ((rvpaoKeepWithNext in Options) = (rvpaoKeepWithNext in TParaInfo(Value).Options))) and
    ((rvpiBiDiMode        in IgnoreList) or (BiDiMode        = Value.BiDiMode)) and
    ((rvpiOutlineLevel    in IgnoreList) or (OutlineLevel = Value.OutlineLevel)) and    
    {$IFNDEF RVDONOTUSETABS}
    ((rvpiTabs            in IgnoreList) or Tabs.IsEqual(Value.Tabs)) and
    {$ENDIF}
    Background.IsEqual_Para(Value.Background, IgnoreList) and
    Border.IsEqual_Para(Value.Border, IgnoreList);
  if Result and RichViewCompareStyleNames then
    Result := StyleName=Value.StyleName;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TCustomRVParaInfo.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
begin
  inherited LoadFromINI(ini, Section, fs, RVDEFAULTPARASTYLENAME);
  SpaceBefore := ini.ReadInteger(Section,  Format(fs,[RVINI_SPACEBEFORE]),  0);
  SpaceAfter  := ini.ReadInteger(Section,  Format(fs,[RVINI_SPACEAFTER]),  0);
  LeftIndent  := ini.ReadInteger(Section,  Format(fs,[RVINI_LEFTINDENT]),  0);
  RightIndent := ini.ReadInteger(Section,  Format(fs,[RVINI_RIGHTIDENT]),  0);
  FirstIndent := ini.ReadInteger(Section,  Format(fs,[RVINI_FIRSTINDENT]), 0);
  LineSpacing := ini.ReadInteger(Section,  Format(fs,[RVINI_LINESPACING]), 100);
  LineSpacingType := TRVLineSpacingType(ini.ReadInteger(Section,  Format(fs,[RVINI_LINESPACINGTYPE]), ord(rvlsPercent)));
  Alignment   := TRVAlignment(ini.ReadInteger(Section, Format(fs,[RVINI_ALIGNMENT]), ord(rvaLeft)));
  BiDiMode    := TRVBiDiMode(ini.ReadInteger(Section, Format(fs,[RVINI_BIDIMODE]), 0));
  OutlineLevel := ini.ReadInteger(Section, Format(fs,[RVINI_OUTLINELEVEL]), 0);  
  Options := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_NOWRAP]), False) then
    Include(FOptions, rvpaoNoWrap);
  if IniReadBool(ini, Section, Format(fs,[RVINI_READONLY]), False) then
    Include(FOptions, rvpaoReadOnly);
  if IniReadBool(ini, Section, Format(fs,[RVINI_STYLEPROTECT]), False) then
    Include(FOptions, rvpaoStyleProtect);
  if IniReadBool(ini, Section, Format(fs,[RVINI_DONOTWANTRETURNS]), False) then
    Include(FOptions, rvpaoDoNotWantReturns);
  if IniReadBool(ini, Section, Format(fs,[RVINI_KEEPLINESTOGETHER]), False) then
    Include(FOptions, rvpaoKeepLinesTogether);
  if IniReadBool(ini, Section, Format(fs,[RVINI_KEEPWITHNEXT]), False) then
    Include(FOptions, rvpaoKeepWithNext);
  Border.LoadFromINI(ini,  Section, Format(fs,[RVINI_BORDERPREFIX]));
  Background.LoadFromINI(ini,  Section, Format(fs,[RVINI_BACKGROUNDPREFIX]));
  {$IFNDEF RVDONOTUSETABS}
  Tabs.LoadFromINI(ini, Section, Format(fs, [RVINI_TABPREFIX]));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TCustomRVParaInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  inherited SaveToINI(ini, Section, fs);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_SPACEBEFORE]), SpaceBefore, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_SPACEAFTER]),  SpaceAfter,  0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LEFTINDENT]),  LeftIndent,  0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_RIGHTIDENT]),  RightIndent, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_FIRSTINDENT]), FirstIndent, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LINESPACING]), LineSpacing, 100);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LINESPACINGTYPE]), ord(LineSpacingType), ord(rvlsPercent));
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_ALIGNMENT]),   ord(Alignment), ord(rvaLeft));
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_BIDIMODE]),   ord(BiDiMode), 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_OUTLINELEVEL]), OutlineLevel, 0);  
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_NOWRAP]),  rvpaoNoWrap in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_READONLY]),  rvpaoReadOnly in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_STYLEPROTECT]),  rvpaoStyleProtect in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_DONOTWANTRETURNS]), rvpaoDoNotWantReturns in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_KEEPLINESTOGETHER]), rvpaoKeepLinesTogether in Options, False);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_KEEPWITHNEXT]), rvpaoKeepWithNext in Options, False);
  Border.SaveToINI(ini,  Section, Format(fs,[RVINI_BORDERPREFIX]));
  Background.SaveToINI(ini,  Section, Format(fs,[RVINI_BACKGROUNDPREFIX]));
  {$IFNDEF RVDONOTUSETABS}
  Tabs.SaveToINI(ini, Section, Format(fs, [RVINI_TABPREFIX]));
  {$ENDIF}
end;
{$ENDIF}
{$IFNDEF RVDONOTUSEHTML}
{------------------------------------------------------------------------------}
{ Saves this paragraph style as a part of CSS to the Stream.
  if BaseStyle<>nil, only a difference between this style and BaseStyle is
  saved.
  If Multiline=False, all text will be written on a single line.
  If IgnoreLeftAlignment, left value of alignment is not saved.
  If IgnoreLeftIndents, left and first line indents are not saved. }
procedure TCustomRVParaInfo.SaveCSSToStream(Stream: TStream; BaseStyle: TParaInfo;
  Multiline, IgnoreLeftAlignment, IgnoreLeftIndents: Boolean);
const cssTextAlign  : array[TRVAlignment] of TRVAnsiString =
  ('left', 'right', 'center', 'justify');
    {..................................................}
    function GetBorderStyle(bs: TRVBorderStyle): String;
    begin
      Result := '';
      case bs of
        rvbNone:
          Result := 'none';
        rvbSingle:
          Result := 'solid';
        rvbDouble, rvbTriple, rvbThickInside, rvbThickOutside:
          Result := 'double';
      end;
    end;
    {..................................................}
    function GetBorderWidth(Border: TRVBorder): TRVStyleLength;
    begin
      Result := 0;
      if Border.Color=clNone then
        exit;
      case Border.Style of
        rvbSingle:
          Result := Border.Width;
        rvbDouble:
          Result := Border.Width*2+Border.InternalWidth;
        rvbThickInside, rvbThickOutside:
          Result := Border.Width*3+Border.InternalWidth;
        rvbTriple:
          Result := Border.Width*3+Border.InternalWidth*2;
      end;
    end;
    {..................................................}
    procedure AdjustRect(var R: TRect);
    begin
      if R.Left<0 then
        R.Left := 0;
      if R.Top<0 then
        R.Top := 0;
      if R.Right<0 then
        R.Right := 0;
      if R.Bottom<0 then
        R.Bottom := 0;
    end;
    {..................................................}
var r, baser: TRect;
    RVStyle: TRVStyle;
begin
  RVStyle := GetRVStyle;
  if ((BaseStyle=nil) and (not IgnoreLeftAlignment or (Alignment<>rvaLeft))) or
     ((BaseStyle<>nil) and (BaseStyle.Alignment<>Alignment)) then
    RVWriteX(Stream, ' text-align: '+cssTextAlign[Alignment]+';', Multiline);
  if ((BaseStyle=nil) and (BiDiMode<>rvbdUnSpecified)) or
     ((BaseStyle<>nil) and (BiDiMode<>BaseStyle.BiDiMode)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' direction: %s;',[GetHTMLDirection(BiDiMode)]), Multiline);
  if not IgnoreLeftIndents and ((BaseStyle=nil) or (BaseStyle.FirstIndent<>FirstIndent)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' text-indent: %s;', [RVStyle.GetCSSSize(FirstIndent)]), Multiline);
  case LineSpacingType of
    rvlsPercent:
      if ((BaseStyle=nil) and (LineSpacing<>100)) or
         ((BaseStyle<>nil) and ((BaseStyle.LineSpacingType<>LineSpacingType) or
          (BaseStyle.LineSpacing<>LineSpacing))) then
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' line-height: %d.%.2d;',[LineSpacing div 100, LineSpacing mod 100]),
          Multiline)
      else if (BaseStyle<>nil) and ((BaseStyle.LineSpacingType<>LineSpacingType) or
          (BaseStyle.LineSpacing<>LineSpacing)) then
        RVWriteX(Stream, ' line-height: normal;', Multiline);
    rvlsLineHeightAtLeast, rvlsLineHeightExact:
      if (BaseStyle=nil)  or
         ((BaseStyle<>nil) and ((BaseStyle.LineSpacingType<>LineSpacingType) or
          (BaseStyle.LineSpacing<>LineSpacing))) then
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' line-height: %s;',[RVStyle.GetCSSSize(LineSpacing)]), Multiline);
  end;
  if rvpaoNoWrap in Options then
    RVWriteX(Stream, ' white-space: nowrap;', Multiline)
  else if (BaseStyle<>nil) and (rvpaoNoWrap in BaseStyle.Options) then
    RVWriteX(Stream, ' white-space: normal;', Multiline);
  if rvpaoKeepLinesTogether in Options then
    RVWriteX(Stream, ' page-break-inside: avoid;', Multiline)
  else if (BaseStyle<>nil) and (rvpaoKeepLinesTogether in BaseStyle.Options) then
    RVWriteX(Stream, ' page-break-inside: auto;', Multiline);
  if rvpaoKeepWithNext in Options then
    RVWriteX(Stream, ' page-break-after: avoid;', Multiline)
  else if (BaseStyle<>nil) and (rvpaoKeepWithNext in BaseStyle.Options) then
    RVWriteX(Stream, ' page-break-after: auto;', Multiline);
  if (Border.Style <> rvbNone) and (Border.Color<>clNone) then begin
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' border-color: %s;', [RV_GetHTMLRGBStr(Border.Color, False)]),
      Multiline);
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' border-style: %s;', [GetBorderStyle(Border.Style)]),
      Multiline);
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' border-width: %s;', [RVStyle.GetCSSSize(GetBorderWidth(Border))]),
      Multiline);
    if not Border.VisibleBorders.Top then
      RVWriteX(Stream, ' border-top: none;', Multiline);
    if not Border.VisibleBorders.Right then
      RVWriteX(Stream, ' border-right: none;', Multiline);
    if not Border.VisibleBorders.Bottom then
      RVWriteX(Stream, ' border-bottom: none;', Multiline);
    if not Border.VisibleBorders.Left then
      RVWriteX(Stream, ' border-left: none;', Multiline);
    Border.BorderOffsets.AssignToRect(r);
    end
  else begin
    if (BaseStyle<>nil) and (BaseStyle.Border.Style <> rvbNone) and
       (BaseStyle.Border.Color<>clNone) then
      RVWriteX(Stream, ' border: none;', Multiline);
    r := Rect(0,0,0,0);
    //RVWriteX(Stream, ' border: none;', Multiline);
  end;
  if (BaseStyle<>nil) and (BaseStyle.Border.Style <> rvbNone) and
    (BaseStyle.Border.Color<>clNone) then
    BaseStyle.Border.BorderOffsets.AssignToRect(baser)
  else
    baser := Rect(0,0,0,0);
  if ((BaseStyle=nil) and (Background.Color<>clNone)) or
     ((BaseStyle<>nil) and (Background.Color<>BaseStyle.Background.Color)) then
    RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format(' background: %s;', [RV_GetCSSBkColor(Background.Color)]), Multiline);
  if Background.Color<>clNone then
    Background.BorderOffsets.AssignToRectIfGreater(r);
  if (BaseStyle=nil) or not AreRectsEqual(baser,r) then
    with r do
      RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format(' padding: %s %s %s %s;',
          [RVStyle.GetCSSSize(Top), RVStyle.GetCSSSize(Right),
           RVStyle.GetCSSSize(Bottom), RVStyle.GetCSSSize(Left)]), Multiline);
  if (BaseStyle<>nil) then begin
    baser.Left   := BaseStyle.LeftIndent-baser.Left-GetBorderWidth(BaseStyle.Border);
    baser.Right  := BaseStyle.RightIndent-baser.Right-GetBorderWidth(BaseStyle.Border);
    baser.Top    := BaseStyle.SpaceBefore-baser.Top-GetBorderWidth(BaseStyle.Border);
    baser.Bottom := BaseStyle.SpaceAfter-baser.Bottom-GetBorderWidth(BaseStyle.Border);
  end;
  AdjustRect(baser);
  r.Left   := LeftIndent-r.Left-GetBorderWidth(Border);
  r.Right  := RightIndent-r.Right-GetBorderWidth(Border);
  r.Top    := SpaceBefore-r.Top-GetBorderWidth(Border);
  r.Bottom := SpaceAfter-r.Bottom-GetBorderWidth(Border);
  AdjustRect(r);  
  if (BaseStyle=nil) or not AreRectsEqual(baser,r) then
    with r do
      if not IgnoreLeftIndents then
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' margin: %s %s %s %s;',
            [RVStyle.GetCSSSize(Top), RVStyle.GetCSSSize(Right),
             RVStyle.GetCSSSize(Bottom), RVStyle.GetCSSSize(Left)]), Multiline)
      else begin
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' margin-top: %s;', [RVStyle.GetCSSSize(Top)]), Multiline);
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' margin-right: %s;', [RVStyle.GetCSSSize(Right)]), Multiline);
        RVWriteX(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format(' margin-bottom: %s;', [RVStyle.GetCSSSize(Bottom)]), Multiline);
      end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TCustomRVParaInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
var RVStyle: TRVStyle;
begin
  RVStyle := GetRVStyle;
  LeftIndent := RVStyle.GetAsDifferentUnits(LeftIndent, NewUnits);
  FirstIndent := RVStyle.GetAsDifferentUnits(FirstIndent, NewUnits);
  RightIndent := RVStyle.GetAsDifferentUnits(RightIndent, NewUnits);
  SpaceBefore := RVStyle.GetAsDifferentUnits(SpaceBefore, NewUnits);
  SpaceAfter := RVStyle.GetAsDifferentUnits(SpaceAfter, NewUnits);
  if LineSpacingType in [rvlsSpaceBetween, rvlsLineHeightAtLeast, rvlsLineHeightExact] then
    LineSpacing := RVStyle.GetAsDifferentUnits(LineSpacing, NewUnits);
  {$IFNDEF RVDONOTUSETABS}
  Tabs.ConvertToDifferentUnits(RVStyle, NewUnits);
  {$ENDIF}
  Border.ConvertToDifferentUnits(RVStyle, NewUnits);
  Background.BorderOffsets.ConvertToDifferentUnits(RVStyle, NewUnits);
end;
{=================================== TParaInfo ================================}
{ Constructor }
constructor TParaInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  NextParaNo  := -1;
  DefStyleNo  := -1;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is TCustomRVParaInfo }
procedure TParaInfo.Assign(Source: TPersistent);
begin
  if Source is TParaInfo then begin
    NextParaNo  := TParaInfo(Source).NextParaNo;
    DefStyleNo  := TParaInfo(Source).DefStyleNo;
    {$IFNDEF RVDONOTUSESTYLETEMPLATES}
    ModifiedProperties1 := TParaInfo(Source).ModifiedProperties1;
    ModifiedProperties2 := TParaInfo(Source).ModifiedProperties2;
    {$ENDIF}
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
procedure TParaInfo.ExcludeUnmodifiedProperties(Source: TCustomRVParaInfo;
  PossibleProps: TRVParaInfoProperties);
   {.............................................................}
   procedure ChangeOption(Option: TRVParaOption; OptionId: TRVParaInfoProperty2);
   begin
     if (OptionId in PossibleProps) and
        ((Option in Options)=(Option in Source.Options)) then
       Exclude(FModifiedProperties2, OptionId);
   end;
   {.............................................................}
begin
  if (rvpiFirstIndent in PossibleProps) and (FirstIndent=Source.FirstIndent) then
    Exclude(FModifiedProperties1, rvpiFirstIndent);
  if (rvpiLeftIndent in PossibleProps) and (LeftIndent=Source.LeftIndent) then
    Exclude(FModifiedProperties1, rvpiLeftIndent);
  if (rvpiRightIndent in PossibleProps) and (RightIndent=Source.RightIndent) then
    Exclude(FModifiedProperties1, rvpiRightIndent);
  if (rvpiSpaceBefore in PossibleProps) and (SpaceBefore=Source.SpaceBefore) then
    Exclude(FModifiedProperties1, rvpiSpaceBefore);
  if (rvpiSpaceAfter in PossibleProps) and (SpaceAfter=Source.SpaceAfter) then
    Exclude(FModifiedProperties1, rvpiSpaceAfter);
  if (rvpiAlignment in PossibleProps) and (Alignment=Source.Alignment) then
    Exclude(FModifiedProperties1, rvpiAlignment);
  if (rvpiLineSpacing in PossibleProps) and (LineSpacing=Source.LineSpacing) then
    Exclude(FModifiedProperties1, rvpiLineSpacing);
  if (rvpiLineSpacingType in PossibleProps) and (LineSpacingType=Source.LineSpacingType) then
    Exclude(FModifiedProperties1, rvpiLineSpacingType);

  if (rvpiBackground_Color in PossibleProps) and (Background.Color=Source.Background.Color) then
    Exclude(FModifiedProperties1, rvpiBackground_Color);
  if (rvpiBackground_BO_Left in PossibleProps) and
     (Background.BorderOffsets.Left=Source.Background.BorderOffsets.Left) then
    Exclude(FModifiedProperties1, rvpiBackground_BO_Left);
  if (rvpiBackground_BO_Top in PossibleProps) and
     (Background.BorderOffsets.Top=Source.Background.BorderOffsets.Top) then
    Exclude(FModifiedProperties1, rvpiBackground_BO_Top);
  if (rvpiBackground_BO_Right in PossibleProps) and
     (Background.BorderOffsets.Right=Source.Background.BorderOffsets.Right) then
    Exclude(FModifiedProperties1, rvpiBackground_BO_Right);
  if (rvpiBackground_BO_Bottom in PossibleProps) and
     (Background.BorderOffsets.Bottom=Source.Background.BorderOffsets.Bottom) then
    Exclude(FModifiedProperties1, rvpiBackground_BO_Bottom);

  if (rvpiBorder_Style in PossibleProps) and (Border.Style=Source.Border.Style) then
    Exclude(FModifiedProperties1, rvpiBorder_Style);
  if (rvpiBorder_Color in PossibleProps) and (Border.Color=Source.Border.Color) then
    Exclude(FModifiedProperties1, rvpiBorder_Color);
  if (rvpiBorder_Width in PossibleProps) and (Border.Width=Source.Border.Width) then
    Exclude(FModifiedProperties1, rvpiBorder_Width);
  if (rvpiBorder_InternalWidth in PossibleProps) and (Border.Width=Source.Border.InternalWidth) then
    Exclude(FModifiedProperties1, rvpiBorder_InternalWidth);
  if (rvpiBorder_BO_Left in PossibleProps) and
     (Border.BorderOffsets.Left=Source.Border.BorderOffsets.Left) then
    Exclude(FModifiedProperties1, rvpiBorder_BO_Left);
  if (rvpiBorder_BO_Top in PossibleProps) and
     (Border.BorderOffsets.Top=Source.Border.BorderOffsets.Top) then
    Exclude(FModifiedProperties1, rvpiBorder_BO_Top);
  if (rvpiBorder_BO_Right in PossibleProps) and
     (Border.BorderOffsets.Right=Source.Border.BorderOffsets.Right) then
    Exclude(FModifiedProperties1, rvpiBorder_BO_Right);
  if (rvpiBorder_BO_Bottom in PossibleProps) and
     (Border.BorderOffsets.Bottom=Source.Border.BorderOffsets.Bottom) then
    Exclude(FModifiedProperties1, rvpiBorder_BO_Bottom);

  if (rvpiBorder_Vis_Left in PossibleProps) and
     (Border.VisibleBorders.Left=Source.Border.VisibleBorders.Left) then
    Exclude(FModifiedProperties1, rvpiBorder_Vis_Left);
  if (rvpiBorder_Vis_Top in PossibleProps) and
     (Border.VisibleBorders.Top=Source.Border.VisibleBorders.Top) then
    Exclude(FModifiedProperties1, rvpiBorder_Vis_Top);
  if (rvpiBorder_Vis_Right in PossibleProps) and
     (Border.VisibleBorders.Right=Source.Border.VisibleBorders.Right) then
    Exclude(FModifiedProperties1, rvpiBorder_Vis_Right);
  if (rvpiBorder_Vis_Bottom in PossibleProps) and
     (Border.VisibleBorders.Bottom=Source.Border.VisibleBorders.Bottom) then
    Exclude(FModifiedProperties1, rvpiBorder_Vis_Bottom);

  ChangeOption(rvpaoNoWrap, rvpiNoWrap);
  ChangeOption(rvpaoReadOnly, rvpiReadOnly);
  ChangeOption(rvpaoStyleProtect, rvpiStyleProtect);
  ChangeOption(rvpaoDoNotWantReturns, rvpiDoNotWantReturns);
  ChangeOption(rvpaoKeepLinesTogether, rvpiKeepLinesTogether);
  ChangeOption(rvpaoKeepWithNext, rvpiKeepWithNext);

  {$IFNDEF RVDONOTUSETABS}
  if (rvpiTabs in PossibleProps) and Tabs.IsEqual(Source.Tabs) then
    Exclude(FModifiedProperties2, rvpiTabs);
  {$ENDIF}
  if (rvpiBiDiMode in PossibleProps) and (BiDiMode=Source.BiDiMode) then
    Exclude(FModifiedProperties2, rvpiBiDiMode);
  if (rvpiOutlineLevel in PossibleProps) and
    (OutlineLevel = Source.OutlineLevel) then
    Exclude(FModifiedProperties2, rvpiOutlineLevel);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TParaInfo.LoadFromINI(ini: TRVIniFile; const Section,
  fs: String);
begin
  inherited LoadFromINI(ini, Section, fs);
  NextParaNo  := ini.ReadInteger(Section,  Format(fs,[RVINI_NEXTPARANO]), -1);
  DefStyleNo  := ini.ReadInteger(Section,  Format(fs,[RVINI_DEFSTYLENO]), -1);
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TParaInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  inherited SaveToINI(ini, Section, fs);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_NEXTPARANO]), NextParaNo, -1);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_DEFSTYLENO]), DefStyleNo, -1);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TParaInfo.IsHeading(MaxLevel: Integer): Boolean;
begin
  Result := (OutlineLevel>=1) and (OutlineLevel<=MaxLevel);
end;
{------------------------------------------------------------------------------}
{ Is this paragraph style equal to Value?
  Mapping is used to compare NextParaNo.
  Mapping is from the Value's collection to this collection, see
  TCustomRVInfos.MergeWith.
}
function TParaInfo.IsSimpleEqualEx(Value: TCustomRVInfo;
  Mapping: TRVIntegerList): Boolean;
begin
  Result := IsSimpleEqual(Value, True, False);
  if not Result then
    exit;
  if Value is TParaInfo then begin
    Result := False;
    {
    if (Value.BaseStyleNo>=0) then begin
      if (Value.BaseStyleNo>=Mapping.Count) then
        Value.BaseStyleNo := -1 // fix up
      else if (Mapping[Value.BaseStyleNo]<>BaseStyleNo) then
        exit;
    end;
    }
    if (TParaInfo(Value).NextParaNo>=0) then begin
      if (TParaInfo(Value).NextParaNo>=Mapping.Count) then
        TParaInfo(Value).NextParaNo := -1 // fix up
      else if (Mapping[TParaInfo(Value).NextParaNo]<>NextParaNo) then
        exit;
    end;
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
{ Is this paragraph style equal to Value?
  If IgnoreReferences, NextParaNo and DefStyleNo are ignored.
  IgnoreID parameter is not used.
  BaseStyleNo is ignored. }
function TParaInfo.IsSimpleEqual(Value: TCustomRVInfo; IgnoreReferences,
  IgnoreID: Boolean): Boolean;
begin
  Result := inherited IsSimpleEqual(Value, IgnoreReferences, IgnoreID);
  if not Result then
    exit;
  if Value is TParaInfo then
    Result :=
      {$IFNDEF RVDONOTUSESTYLETEMPLATES}
      (ModifiedProperties1 = TParaInfo(Value).ModifiedProperties1) and
      (ModifiedProperties2 = TParaInfo(Value).ModifiedProperties2) and
      (StyleTemplateID = TParaInfo(Value).StyleTemplateID) and
      {$ENDIF}
      (IgnoreReferences or (NextParaNo = TParaInfo(Value).NextParaNo)) and
      (IgnoreReferences or (DefStyleNo = TParaInfo(Value).DefStyleNo));
end;
{------------------------------------------------------------------------------}
{ Is the specified properties of this paragraph style equal to the properties of
  Value. IgnoreList lists properties which will be ignored when comparing.
  BaseStyleNo is always ignored. }
function TParaInfo.IsEqual(Value: TCustomRVParaInfo;
  IgnoreList: TRVParaInfoProperties): Boolean;
begin
  Result := inherited IsEqual(Value, IgnoreList);
  if Result and (Value is TParaInfo) then begin
    Result := ((rvpiNextParaNo in IgnoreList) or (NextParaNo = TParaInfo(Value).NextParaNo)) and
              ((rvpiDefStyleNo in IgnoreList) or (DefStyleNo = TParaInfo(Value).DefStyleNo))
              {$IFNDEF RVDONOTUSESTYLETEMPLATES}
              and
              (StyleTemplateId=Value.StyleTemplateId) and
              (ModifiedProperties1=TParaInfo(Value).ModifiedProperties1) and
              (ModifiedProperties2=TParaInfo(Value).ModifiedProperties2)
              {$ENDIF}
              ;
  end
end;
{================================ TErrParaInfo ================================}
constructor TErrParaInfo.CreateErr(RVStyle: TRVStyle);
begin
  Create(nil);
  FRVStyle := RVStyle;
end;

function TErrParaInfo.GetRVStyle: TRVStyle;
begin
  Result := FRVStyle;
end;
{============================== TParaInfos ====================================}
destructor TParaInfos.Destroy; 
begin
  FInvalidItem.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Assigns style names to TStrings. Called from TStrings.Assign. }
procedure TParaInfos.AssignTo(Dest: TPersistent);
var i: Integer;
begin
  if Dest is TStrings then begin
    TStrings(Dest).Clear;
    for i:=0 to Count-1 do
      TStrings(Dest).Add(Items[i].FName);
    end
  else
    inherited AssignTo(Dest);
end;
{------------------------------------------------------------------------------}
{ Adds a new item. }
function TParaInfos.Add: TParaInfo;
begin
  Result := TParaInfo(inherited Add);
end;
{------------------------------------------------------------------------------}
{ READ method for the property Items[].
  Returns the Index-th item. If the index is out of range (0..Count-1), returns
  InvalidItem instead. This method never generates exceptions. }
function TParaInfos.GetItem(Index: Integer): TParaInfo;
begin
  if (Index<0) or (Index>=Count) then
    Result := InvalidItem
  else
    Result := TParaInfo(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for the property Items[]. }
procedure TParaInfos.SetItem(Index: Integer; Value: TParaInfo);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{ READ method for the property InvalidItem.
  It's returned when accessing Items[] with invalid index.
  By default it has all properties of Items[0] and red border. }
function TParaInfos.GetInvalidItem: TParaInfo;
var RVStyle: TRVStyle;
begin
  if FInvalidItem=nil then begin
    RVStyle := (FOwner as TRVStyle);
    FInvalidItem := TErrParaInfo.CreateErr(RVStyle);
    if Count>0 then
      FInvalidItem.Assign(Items[0]);
    FInvalidItem.SpaceBefore := RVStyle.PixelsToUnits(3);
    FInvalidItem.SpaceAfter  := RVStyle.PixelsToUnits(3);
    FInvalidItem.LeftIndent  := RVStyle.PixelsToUnits(3);
    FInvalidItem.RightIndent := RVStyle.PixelsToUnits(3);
    FInvalidItem.Border.Color := clRed;
    FInvalidItem.Border.Style := rvbSingle;
    FInvalidItem.Border.Width := RVStyle.PixelsToUnits(2);
    FInvalidItem.Border.BorderOffsets.SetAll(RVStyle.PixelsToUnits(1));
  end;
  Result := FInvalidItem;
end;
{------------------------------------------------------------------------------}
{ WRITE method for the property InvalidItem. }
procedure TParaInfos.SetInvalidItem(const Value: TParaInfo);
begin
  if InvalidItem<>Value then
    InvalidItem.Assign(Value);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TParaInfos.LoadFromINI(ini: TRVIniFile; const Section: String);
var i, cnt: Integer;
begin
  cnt := ini.ReadInteger(Section, RVINI_PARASTYLECOUNT, 2);
  Clear;
  for i:=0 to cnt-1 do begin
    Add;
    Items[i].LoadFromINI(ini, Section, RVINI_PARASTYLEPREFIX+IntToStr(i));
  end;
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys. }
procedure TParaInfos.SaveToINI(ini: TRVIniFile; const Section: String);
var i: Integer;
begin
  ini.WriteInteger(Section,RVINI_PARASTYLECOUNT, Count);
  for i:=0 to Count-1 do
    Items[i].SaveToINI(ini, Section, RVINI_PARASTYLEPREFIX+IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Returns the index of the style having the specified Alignment.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TParaInfos.FindStyleWithAlignment(BaseStyle: Integer;
  Alignment: TRVAlignment): Integer;
var i: Integer;
begin
  if Items[BaseStyle].Alignment = Alignment then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and (Items[i].Alignment=Alignment) and
       Items[BaseStyle].IsEqual(Items[i], [rvpiAlignment]) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ The most universal method for paragraph style searching.
  Returns the index of the style having all properties of Style listed in Mask.
  Starts searching from Items[BaseStyle], then searches in other Items.
  If not found, returns -1. }
function TParaInfos.FindSuchStyle(BaseStyle: Integer; Style: TParaInfo;
  Mask: TRVParaInfoProperties): Integer;
var i: Integer;
begin
  Mask := RVAllParaInfoProperties - Mask;
  if Style.IsEqual(Items[BaseStyle], Mask) then begin
    Result := BaseStyle;
    exit;
  end;
  for i := 0 to Count-1 do
    if (i<>BaseStyle) and Style.IsEqual(Items[i], Mask) then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{============================== TRVMarkerFont =================================}
{ Constructor. Sets values default for ListLevel.Font. }
constructor TRVMarkerFont.Create;
begin
  inherited Create;
  Name := RVDEFAULTSTYLEFONT;
  Size := 8;
end;
{------------------------------------------------------------------------------}
{ Is this font equal to Font? }
function TRVMarkerFont.IsEqual(Font: TFont): Boolean;
begin
  Result :=
    (Height=Font.Height) and
    (Style=Font.Style) and
    (Color=Font.Color) and
    {$IFDEF RICHVIEWCBDEF3}
    (Charset=Font.Charset) and
    {$ENDIF}
    (AnsiCompareText(Name, Font.Name)=0);
end;
{------------------------------------------------------------------------------}
{ Do all properties of this font have default values? }
function TRVMarkerFont.IsDefault: Boolean;
begin
  Result :=
    (Size=8) and
    (Color=clWindowText) and
    {$IFDEF RICHVIEWCBDEF3}
    (Charset=DEFAULT_CHARSET) and
    {$ENDIF}
    (Style=[]) and
    (AnsiCompareText(Name,RVDEFAULTSTYLEFONT)=0);
end;
{------------------------------------------------------------------------------}
{ STORED method for Name property. }
function TRVMarkerFont.StoreName: Boolean;
begin
  Result := Name<>RVDEFAULTSTYLEFONT;
end;
{------------------------------------------------------------------------------}
{ STORED method for Height property. }
function TRVMarkerFont.StoreHeight: Boolean;
begin
  Result := Size<>8;
end;
{============================== TRVListLevel ==================================}
{ Constructor. Creates a dot bullet with FirstIndent=10. }
constructor TRVListLevel.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FFirstIndent := 10;
  FStartFrom   := 1;
  FFormatString  := RVCHAR_MIDDLEDOT;
  FOptions     := [rvloContinuous, rvloLevelReset];
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TRVListLevel.Destroy;
begin
  FPicture.Free;
  FFont.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is TRVListLevel. }
procedure TRVListLevel.Assign(Source: TPersistent);
begin
  if Source is TRVListLevel then begin
    ListType        := TRVListLevel(Source).ListType;
    StartFrom       := TRVListLevel(Source).StartFrom;
    ImageList       := TRVListLevel(Source).ImageList;
    ImageIndex      := TRVListLevel(Source).ImageIndex;
    FormatString    := TRVListLevel(Source).FormatString;
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    FormatStringW   := TRVListLevel(Source).FormatStringW;
    {$ENDIF}
    {$ENDIF}
    LeftIndent      := TRVListLevel(Source).LeftIndent;
    FirstIndent     := TRVListLevel(Source).FirstIndent;
    MarkerIndent    := TRVListLevel(Source).MarkerIndent;
    MarkerAlignment := TRVListLevel(Source).MarkerAlignment;
    Picture         := TRVListLevel(Source).FPicture;
    Font            := TRVListLevel(Source).FFont;
    Options         := TRVListLevel(Source).Options;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RICHVIEWDEF3}
{ Are the Length bytes referenced by P1 and P2 the same? }
function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,1
        SHR     ECX,1
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
        INC     EAX
@@2:    POP     EDI
        POP     ESI
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Do Picture1 and Picture2 contain the same picture? }
function ArePicturesEqual(FPicture1, FPicture2: TPicture): Boolean;
var Stream1, Stream2: TRVMemoryStream;
begin
  Result := ((FPicture1=nil) or (FPicture1.Graphic=nil)) =
            ((FPicture2=nil) or (FPicture2.Graphic=nil));

  if not Result then
    exit;
  if (FPicture1=nil) or (FPicture2.Graphic=nil) then
    exit;
  Result := FPicture1.ClassType=FPicture2.ClassType;
  if not Result then
    exit;
  Result := (FPicture1.Width=FPicture2.Width) and
            (FPicture1.Height=FPicture2.Height);
  if not Result then
    exit;
  Stream1 := TRVMemoryStream.Create;
  Stream2 := TRVMemoryStream.Create;
  try
    FPicture1.Graphic.SaveToStream(Stream1);
    FPicture2.Graphic.SaveToStream(Stream2);
    Result := (Stream1.Size=Stream2.Size) and
      CompareMem(Stream1.Memory,Stream2.Memory,Stream1.Size);
  finally
    Stream1.Free;
    Stream2.Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Is this list level equal to Value? }
function TRVListLevel.IsSimpleEqual(Value: TRVListLevel): Boolean;
begin
  Result :=
    (ListType = Value.ListType) and
    (not HasNumbering or (StartFrom = Value.StartFrom)) and
    (ImageList = Value.ImageList) and
    (ImageIndex = Value.ImageIndex) and
    (FormatString = Value.FormatString) and
    {$IFNDEF RVDONOTUSEUNICODE}
    {$IFDEF RICHVIEWCBDEF3}
    (FormatStringW = Value.FormatStringW) and
    {$ENDIF}
    {$ENDIF}
    (LeftIndent = Value.LeftIndent) and
    (FirstIndent = Value.FirstIndent) and
    (MarkerIndent = Value.MarkerIndent) and
    (MarkerAlignment = Value.MarkerAlignment) and
    (
      ((FFont=nil) or (FFont.IsDefault)) and ((Value.FFont=nil) or (Value.FFont.IsDefault)) or
      ((FFont<>nil) and (Value.FFont<>nil) and FFont.IsEqual(Value.FFont))
    ) and
    (Options = Value.Options) and
    ArePicturesEqual(FPicture, Value.FPicture);
end;
{------------------------------------------------------------------------------}
{ Returns a value of similarity between this list level and Value.
  The greater value - the higher similarity. }
function TRVListLevel.SimilarityValue(Value: TRVListLevel): Integer;
begin
  Result := 0;
  if ListType=Value.ListType then
    inc(Result, RVMW_LISTTYPE);
  if StartFrom=Value.StartFrom then
    inc(Result, RVMW_LISTMISC);
  if ImageList=Value.ImageList then
    inc(Result, RVMW_LISTMISC);
  if ImageIndex=Value.ImageIndex then
    inc(Result, RVMW_LISTMISC);
  if FormatString=Value.FormatString then
    inc(Result, RVMW_LISTMISC);
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWCBDEF3}
  if FormatStringW=Value.FormatStringW then
    inc(Result, RVMW_LISTMISC);
  {$ENDIF}
  {$ENDIF}
  if LeftIndent=Value.LeftIndent then
    inc(Result, RVMW_LISTMISC);
  if FirstIndent=Value.FirstIndent then
    inc(Result, RVMW_LISTMISC);
  if MarkerIndent=Value.MarkerIndent then
    inc(Result, RVMW_LISTMISC);
  if MarkerAlignment=Value.MarkerAlignment then
    inc(Result, RVMW_LISTMISC);
  if Options=Value.Options then
    inc(Result, RVMW_LISTMISC);
  if ((FFont=nil) or (FFont.IsDefault)) and ((Value.FFont=nil) or (Value.FFont.IsDefault)) or
      ((FFont<>nil) and (Value.FFont<>nil) and FFont.IsEqual(Value.FFont)) then
    inc(Result, RVMW_LISTMISC);
  if ArePicturesEqual(FPicture, Value.FPicture) then
    inc(Result, RVMW_LISTMISC);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Designtime support. Returns a string which will be displayed for this item
  in the collection editor.
  It has a format
    "<list type> <left indent>/<marker indent>/<first line indent>". }
function TRVListLevel.GetDisplayName: String;
begin
  Result := Format(RVLISTLEVELDISPLAYNAME, [RVListTypeStr[ord(ListType)],
    LeftIndent, MarkerIndent, FirstIndent]);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for Picture property. }
function TRVListLevel.GetPicture: TPicture;
begin
  if FPicture=nil then
    FPicture := TPicture.Create;
  Result := FPicture;
end;
{------------------------------------------------------------------------------}
{ WRITE method for Picture property. }
procedure TRVListLevel.SetPicture(const Value: TPicture);
begin
  if Value<>FPicture then begin
    if (Value=nil) or (Value.Graphic=nil) then begin
      FPicture.Free;
      FPicture := nil;
      end
    else begin
      GetPicture.Assign(Value);
      {$IFDEF RICHVIEWDEF3}
      FPicture.Graphic.Transparent := True;
      {$ENDIF}
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ STORED method for Picture property. }
function TRVListLevel.StorePicture: Boolean;
begin
  Result := FPicture<>nil;
end;
{------------------------------------------------------------------------------}
{ Is value of Picture property nonempty? }
function TRVListLevel.HasPicture: Boolean;
begin
  Result := (FPicture<>nil) and (FPicture.Graphic<>nil);
end;
{------------------------------------------------------------------------------}
{ Does this list level uses Font? (it depends on ListType). }
function TRVListLevel.UsesFont: Boolean;
begin
  Result := ListType in [rvlstBullet,
                 rvlstDecimal, rvlstLowerAlpha, rvlstUpperAlpha,
                 rvlstLowerRoman, rvlstUpperRoman
                 {$IFNDEF RVDONOTUSEUNICODE}, rvlstUnicodeBullet{$ENDIF} ];
end;
{------------------------------------------------------------------------------}
{ Does this list level uses numbering? (it depends on ListType). }
function TRVListLevel.HasNumbering: Boolean;
begin
  Result := ListType in [rvlstDecimal, rvlstLowerAlpha, rvlstUpperAlpha,
                 rvlstLowerRoman, rvlstUpperRoman, rvlstImageListCounter];
end;
{------------------------------------------------------------------------------}
{ Is width of marker of this list level variable? (it depends on ListType). }
function TRVListLevel.HasVariableWidth: Boolean;
begin
  Result := ListType in [rvlstDecimal, rvlstLowerAlpha, rvlstUpperAlpha,
                 rvlstLowerRoman, rvlstUpperRoman];
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
{ (reserved) }
function TRVListLevel.GetHTMLOpenTagForCSS: String;
begin
  if HasNumbering then
    Result := 'ol'
  else
    Result := 'ul';
end;
{------------------------------------------------------------------------------}
{ Returns CSS to insert in <P> tag when SaveHTMLEx is called with
  rvsoMarkersAsText option. }
function TRVListLevel.GetIndentCSSForTextVersion(RVStyle: TRVStyle): TRVAnsiString;
begin
  if MarkerIndent-LeftIndent>=0 then
    Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('text-indent: %s; margin-left: %s;',
        [RVStyle.GetCSSSize(MarkerIndent-LeftIndent),
         RVStyle.GetCSSSize(LeftIndent)])
  else
    Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('text-indent: %s; padding-left: %s; margin-left: %s;',
        [RVStyle.GetCSSSize(MarkerIndent-LeftIndent),
         RVStyle.GetCSSSize(LeftIndent-MarkerIndent),
         RVStyle.GetCSSSize(MarkerIndent)]);
end;
{------------------------------------------------------------------------------}
{ Writes opening HTML tag for this list level in Stream.
  Used TRVMarkerItemInfo.HTMLOpenOrCloseTags. }
procedure TRVListLevel.HTMLOpenTag(Stream: TStream; UseCSS: Boolean;
  RVStyle: TRVStyle);
  {..............................................}
  function GetListType: TRVAnsiString;
  begin
    case ListType of
      rvlstLowerAlpha:
        Result := 'a';
      rvlstUpperAlpha:
        Result := 'A';
      rvlstLowerRoman:
        Result := 'i';
      rvlstUpperRoman:
        Result := 'I';
      else
        Result := '';
    end;
    if Result<>'' then
      Result := ' type="'+Result+'"';
  end;
  {..............................................}
var CSS: TRVAnsiString;
    PrevIndent: TRVStyleLength;
begin
  if UseCSS then begin
    PrevIndent := 0;
    if Index>0 then
       PrevIndent := TRVListLevelCollection(Collection).Items[Index-1].LeftIndent;
    if MarkerIndent>=LeftIndent then
      CSS := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('text-indent: %s; margin-left: %s; list-style-position: inside;',
          [RVStyle.GetCSSSize(MarkerIndent-LeftIndent),
           RVStyle.GetCSSSize(LeftIndent-PrevIndent)])
    else
      CSS := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
        Format('text-indent: %s; margin-left: %s; list-style-position: outside;',
          [RVStyle.GetCSSSize(FirstIndent),
           RVStyle.GetCSSSize(LeftIndent-PrevIndent)]);
    CSS := ' style="'+CSS+'"';
    end
  else
    CSS := '';
  if HasNumbering then
    RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('<ol%s%s>',[GetListType,CSS]))
  else
    RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
      Format('<ul%s>',[CSS]));
end;
{------------------------------------------------------------------------------}
{ Writes closing HTML tag for this list level in Stream.
  Used TRVMarkerItemInfo.HTMLOpenOrCloseTags. }
procedure TRVListLevel.HTMLCloseTag(Stream: TStream; UseCSS: Boolean);
begin
  if HasNumbering then
    RVWrite(Stream,'</ol>')
  else
    RVWrite(Stream,'</ul>');
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for Font property. }
function TRVListLevel.GetFont: TRVMarkerFont;
begin
  if FFont=nil then
    FFont := TRVMarkerFont.Create;
  Result := FFont;
end;
{------------------------------------------------------------------------------}
{ WRITE method for Font property. }
procedure TRVListLevel.SetFont(const Value: TRVMarkerFont);
begin
  if Value<>FFont then begin
    if (Value=nil) then begin
      FFont.Free;
      FFont := nil;
      end
    else
      GetFont.Assign(Value);
  end;
end;
{------------------------------------------------------------------------------}
{ STORED method for Font property. }
function TRVListLevel.StoreFont: Boolean;
begin
  Result := FFont<>nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys.
  ImageList is not loaded (to-do) }
procedure TRVListLevel.SaveToINI(ini: TRVIniFile; const Section, fs: String);
var Stream: TRVMemoryStream;
begin
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LISTTYPE]), ord(ListType), ord(rvlstBullet));
  // ImageList ?
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_IMAGEINDEX]), ImageIndex, 0);
  ini.WriteString(Section,  Format(fs,[RVINI_FORMATSTRING]), FormatString);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LEFTINDENT]), LeftIndent, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_FIRSTINDENT]), FirstIndent, 10);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_MARKERINDENT]), MarkerIndent, 0);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_MARKERALIGNMENT]), ord(FMarkerAlignment), ord(rvmaLeft));
  if (FPicture<>nil) and (FPicture.Graphic<>nil) then begin
    ini.WriteString(Section,  Format(fs,[RVINI_GRAPHICCLASS]), FPicture.Graphic.ClassName);
    Stream :=  TRVMemoryStream.Create;
    try
      FPicture.Graphic.SaveToStream(Stream);
      Stream.Position := 0;
      WriteLongStringToINI(ini, Section,  Format(fs,[RVINI_PICTURE]),
        String(RVFStream2TextString(Stream)));
    finally
      Stream.Free;
    end;
  end;
  if FFont<>nil then
    ini.WriteString(Section,  Format(fs,[RVINI_FONT]), FontToString(FFont));
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_LOCONTINUOUS]), rvloContinuous in Options, True);
  WriteBoolToIniIfNE(ini, Section, Format(fs,[RVINI_LOLEVELRESET]), rvloLevelReset in Options, True);
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWCBDEF3}
  if FFormatStringW<>'' then begin
    Stream := TRVMemoryStream.Create;
    try
      Stream.WriteBuffer(Pointer(FFormatStringW)^, Length(FFormatStringW)*2);
      Stream.Position := 0;
      ini.WriteString(Section,  Format(fs,[RVINI_FORMATSTRINGW]),
        String(RVFStream2TextString(Stream)));
    finally
      Stream.Free;
    end;
  end;
  {$ENDIF}
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file, in the section Section.
  fs is a format string for ini keys.
  ImageList is not stored (to-do). }
procedure TRVListLevel.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
var s: String;
  Stream: TRVMemoryStream;
  GraphicClass: TGraphicClass;
  Graphic: TGraphic;
begin
  ListType := TRVListType(ini.ReadInteger(Section, Format(fs,[RVINI_LISTTYPE]), ord(rvlstBullet)));
  // ImageList ?
  ImageIndex := ini.ReadInteger(Section, Format(fs,[RVINI_IMAGEINDEX]), 0);
  FormatString := ini.ReadString(Section,  Format(fs,[RVINI_FORMATSTRING]), '');
  LeftIndent := ini.ReadInteger(Section, Format(fs,[RVINI_LEFTINDENT]), 0);
  FirstIndent := ini.ReadInteger(Section, Format(fs,[RVINI_FIRSTINDENT]), 10);
  MarkerIndent := ini.ReadInteger(Section, Format(fs,[RVINI_MARKERINDENT]), 0);
  FMarkerAlignment := TRVMarkerAlignment(ini.ReadInteger(Section, Format(fs,[RVINI_MARKERALIGNMENT]), ord(rvmaLeft)));
  s := ini.ReadString(Section,  Format(fs,[RVINI_GRAPHICCLASS]), '');
  GraphicClass := nil;
  if s<>'' then
    GraphicClass := TGraphicClass(GetClass(s));
  if GraphicClass=nil then
    Picture := nil
  else begin
    Graphic := RV_CreateGraphics(GraphicClass);
    Picture.Graphic := Graphic;
    Graphic.Free;
    Stream :=  TRVMemoryStream.Create;
    s := ReadLongStringFromINI(ini, Section,  Format(fs,[RVINI_PICTURE]));
    RVFTextString2Stream(TRVAnsiString(s), Stream);
    Stream.Position := 0;
    try
      Picture.Graphic.LoadFromStream(Stream);
    except
      Picture := nil;
    end;
    Stream.Free;
  end;
  s := ini.ReadString(Section,  Format(fs,[RVINI_FONT]), '');
  if s='' then
    Font := nil
  else
    StringToFont(s, Font);
  FOptions := [];
  if IniReadBool(ini, Section, Format(fs,[RVINI_LOCONTINUOUS]), True) then
    Include(FOptions,rvloContinuous);
  if IniReadBool(ini, Section, Format(fs,[RVINI_LOLEVELRESET]), True) then
    Include(FOptions,rvloLevelReset);
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWCBDEF3}
  s := ini.ReadString(Section,  Format(fs,[RVINI_FORMATSTRINGW]), '');
  Stream := TRVMemoryStream.Create;
  RVFTextString2Stream(TRVAnsiString(s), Stream);
  SetLength(FFormatStringW, Stream.Size div 2);
  Stream.Position := 0;
  Stream.ReadBuffer(Pointer(FFormatStringW)^, Stream.Size);
  Stream.Free;
  {$ENDIF}
  {$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Writes ImageList.Tag as ILTag pseudo-property. }
procedure TRVListLevel.ImageListTagWriter(Writer: TWriter);
begin
  Writer.WriteInteger(FImageList.Tag);
end;
{ Returns RVData used to store this list level.
  There are two possibilities
  - storing in DFM: no RVData (nil)
  - storing in RVF: returns RVData assigned to RVStyle.ListStyles.FRVData. }
{------------------------------------------------------------------------------}
function TRVListLevel.GetRVFRVData: TPersistent;
begin
  if (Collection<>nil) and (TRVListLevelCollection(Collection).FOwner<>nil) and
     (TRVListInfo(TRVListLevelCollection(Collection).FOwner).Collection<>nil) then
    Result := TRVListInfos(TRVListInfo(TRVListLevelCollection(Collection).FOwner).Collection).FRVData
  else
    Result := nil;
end;
{------------------------------------------------------------------------------}
{ Reads ILTag pseudo-property. When loading from RVF file, it contains a Tag
  property of ImageList. It's used to call RVData.RVFImageListNeeded, which
  calls RichView.OnRVFImageListNeeded event.
  There must be no this property when loading from DFM. }
procedure TRVListLevel.ImageListTagReader(Reader: TReader);
var RVData: TCustomRVData;
    Tag: Integer;
begin
  RVData := TCustomRVData(GetRVFRVData);
  Tag := Reader.ReadInteger;
  if RVData<>nil then
    FImageList := RVData.RVFImageListNeeded(Tag)
  else
    FImageList := nil;
end;
{------------------------------------------------------------------------------}
{ STORED method for ILTag pseudo-property. It should be stored only if RVData is
  assigned, i.e. when saving to RVF file. }
function TRVListLevel.StoreImageList: Boolean;
begin
  Result := GetRVFRVData=nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEUNICODE}
{$IFDEF RICHVIEWCBDEF3}
{ READ method for FormatStringWCode pseudo-property. This pseudo-property is
  used for storing FormatStringW property.
  This trick is used because new and old version of Delphi save strings
  differently. If we will use standard Delphi streaming method for these
  properties, programs compiled with older version of Delphi will not be able to
  open RVF files saved with newer versions of Delphi. }
procedure TRVListLevel.FormatStringWCodeReader(Reader: TReader);
begin
  FFormatStringW := RVDecodeWideString(TRVAnsiString(Reader.ReadString));
end;
{------------------------------------------------------------------------------}
{ WRITE method for FormatStringWCode pseudo-property }
procedure TRVListLevel.FormatStringWCodeWriter(Writer: TWriter);
{$IFDEF RVUNICODESTR}
var ValueType: TValueType;
    Len: Integer;
    s: TRVAnsiString;
{$ENDIF}
begin
  {$IFDEF RVUNICODESTR}
  // In Delphi 2009+, Reader.WriteString saves Unicode string (vaWString)
  // To provide compatibility, we are saving as ANSI string
  s := RVEncodeWideString(FFormatStringW);
  Len := Length(s);
  if Len <= 255 then begin
    ValueType := vaString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Byte));
    end
  else begin
    ValueType := vaLString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Integer));
  end;
  Writer.Write(Pointer(s)^, Length(s));
  {$ELSE}
  Writer.WriteString(RVEncodeWideString(FFormatStringW));
  {$ENDIF}
end;
{$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for FormatStringCode pseudo-property. This pseudo-property is
  used for storing FormatString property. }
procedure TRVListLevel.FormatStringCodeReader(Reader: TReader);
begin
  {$IFDEF RVUNICODESTR}
  FFormatString := String(RVDecodeString(TRVAnsiString(Reader.ReadString)));
  {$ELSE}
  FFormatString := RVDecodeString(Reader.ReadString);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ WRITE method for FormatStringCode pseudo-property. This pseudo-property is
  used for storing FormatString property. }
procedure TRVListLevel.FormatStringCodeWriter(Writer: TWriter);
{$IFDEF RVUNICODESTR}
var ValueType: TValueType;
    Len: Integer;
    s: TRVAnsiString;
{$ENDIF}
begin
  {$IFDEF RVUNICODESTR}
  // In Delphi 2009+, Reader.WriteString saves Unicode string (vaWString)
  // To provide compatibility, we are saving as ANSI string.
  s := RVEncodeString(TRVAnsiString(FFormatString));
  Len := Length(s);
  if Len <= 255 then begin
    ValueType := vaString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Byte));
    end
  else begin
    ValueType := vaLString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Integer));
  end;
  Writer.Write(Pointer(s)^, Length(s));
  {$ELSE}
  Writer.WriteString(RVEncodeString(FFormatString));
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ READ method for FormatStringCodeW pseudo-property. This pseudo-property is
  used for storing FormatString property in 2009+, and overrides
  FormatStringCode. }
procedure TRVListLevel.FormatStringCodeWReader(Reader: TReader);
begin
  {$IFDEF RVUNICODESTR}
  FFormatString := RVDecodeWideString(TRVAnsiString(Reader.ReadString));
  {$ELSE}
  Reader.ReadString; // skipping
  {$ENDIF}
end;
 {$IFDEF RVUNICODESTR}
{------------------------------------------------------------------------------}
{ WRITE method for FormatStringCodeW pseudo-property. This pseudo-property is
  used for storing FormatString property in 2009+, and overrides
  FormatStringCode. }
procedure TRVListLevel.FormatStringCodeWWriter(Writer: TWriter);
var ValueType: TValueType;
    Len: Integer;
    s: TRVAnsiString;
begin
  // In Delphi 2009+, Reader.WriteString saves Unicode string (vaWString)
  // To provide compatibility, we are saving as ANSI string
  s := RVEncodeWideString(FFormatString);
  Len := Length(s);
  if Len <= 255 then begin
    ValueType := vaString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Byte));
    end
  else begin
    ValueType := vaLString;
    Writer.Write(ValueType, sizeof(ValueType));
    Writer.Write(Len, SizeOf(Integer));
  end;
  Writer.Write(Pointer(s)^, Length(s));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Defines additional properties (pseudo-properties): ILTag, FormatStringWCode,
  FormatStringCode. }
procedure TRVListLevel.DefineProperties(Filer: TFiler);
begin
  inherited;
  if GetRVFRVData<>nil then
    Filer.DefineProperty('ILTag', ImageListTagReader, ImageListTagWriter, FImageList<>nil);
  {$IFNDEF RVDONOTUSEUNICODE}
  {$IFDEF RICHVIEWCBDEF3}
  Filer.DefineProperty('FormatStringWCode', FormatStringWCodeReader, FormatStringWCodeWriter, FFormatStringW<>'');
  {$ENDIF}
  {$ENDIF}
  Filer.DefineProperty('FormatStringCode', FormatStringCodeReader, FormatStringCodeWriter, FFormatString<>#$B7);
  {$IFDEF RVUNICODESTR}
  Filer.DefineProperty('FormatStringCodeW', FormatStringCodeWReader, FormatStringCodeWWriter, FFormatString<>#$B7);
  {$ELSE}
  Filer.DefineProperty('FormatStringCodeW', FormatStringCodeWReader, nil, False);
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVListLevel.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle);
begin
  LeftIndent := RVStyle.GetAsDifferentUnits(LeftIndent, NewUnits);
  FirstIndent := RVStyle.GetAsDifferentUnits(FirstIndent, NewUnits);
  MarkerIndent := RVStyle.GetAsDifferentUnits(MarkerIndent, NewUnits);  
end;
{========================= TRVListLevelCollection =============================}
{ Constructor. Creates empty collection of list levels. }
constructor TRVListLevelCollection.Create(Owner: TPersistent);
begin
  inherited Create(TRVListLevel);
  FOwner := Owner;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Designtime support, for the IDE collection editor. }
function TRVListLevelCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for Items[] property. }
function TRVListLevelCollection.GetItem(Index: Integer): TRVListLevel;
begin
  Result := TRVListLevel(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for Items[] property. }
procedure TRVListLevelCollection.SetItem(Index: Integer;
  const Value: TRVListLevel);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF4}
{ Inserts a new list level in the collection. This method is added for typecasting. }
function TRVListLevelCollection.Insert(Index: Integer): TRVListLevel;
begin
  Result := TRVListLevel(inherited Insert(Index));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Is this collection of list levels equal to Value? }
function TRVListLevelCollection.IsSimpleEqual(Value: TRVListLevelCollection): Boolean;
var i: Integer;
begin
  Result := False;
  if Count<>Value.Count then
    exit;
  for i := 0 to Count-1 do
    if not Items[i].IsSimpleEqual(Value[i]) then
      exit;
  Result := True;
end;
{------------------------------------------------------------------------------}
{ Adds new list level to the end of the collection. This method is added for
  typecasting. }
function TRVListLevelCollection.Add: TRVListLevel;
begin
  Result := TRVListLevel(inherited Add);
end;
{------------------------------------------------------------------------------}
// Converts sizes from RVStyle.Units to NewUnits
procedure TRVListLevelCollection.ConvertToDifferentUnits(NewUnits: TRVStyleUnits; RVStyle: TRVStyle);
var i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].ConvertToDifferentUnits(NewUnits, RVStyle);
end;
{=========================== TRVListInfo ======================================}
{ Constructor. Creates a list style with 0 levels. }
constructor TRVListInfo.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FLevels := TRVListLevelCollection.Create(Self);
  StyleName := RVDEFAULTLISTSTYLENAME;
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TRVListInfo.Destroy;
begin
  FLevels.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is TRVListInfo. }
procedure TRVListInfo.Assign(Source: TPersistent);
begin
  if Source is TRVListInfo then begin
    Levels := TRVListInfo(Source).Levels;
    OneLevelPreview := TRVListInfo(Source).OneLevelPreview;
    if (Collection<>nil) and
        TRVListInfos(Collection).FRichViewAllowAssignListID then
      FListID := TRVListInfo(Source).FListID;
  end;
  inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Is this list style equal to Value?
  Mapping is not used. }
function TRVListInfo.IsSimpleEqualEx(Value: TCustomRVInfo;
  Mapping: TRVIntegerList): Boolean;
begin
  Result := IsSimpleEqual(Value, True, False);
  {
  if not Result then
    exit;
  Result := False;
  if (Value.BaseStyleNo>=0) then begin
    if (Value.BaseStyleNo>=Mapping.Count) then
      Value.BaseStyleNo := -1 // fix up
    else if (Mapping[Value.BaseStyleNo]<>BaseStyleNo) then
      exit;
  end;
  Result := True;
  }
end;
{------------------------------------------------------------------------------}
{ Is this list style equal to Value?
  If IgnoreID, ListID properties are ignored. }
function TRVListInfo.IsSimpleEqual(Value: TCustomRVInfo;
  IgnoreReferences, IgnoreID: Boolean): Boolean;
begin
  Result := (OneLevelPreview=TRVListInfo(Value).OneLevelPreview) and
    (Levels.Count = TRVListInfo(Value).Levels.Count) and
    (IgnoreID or (ListID = TRVListInfo(Value).ListID));
  if not Result then
    exit;
  Result := Levels.IsSimpleEqual(TRVListInfo(Value).Levels);
  if Result and RichViewCompareStyleNames then
    Result := StyleName=Value.StyleName;  
end;
{------------------------------------------------------------------------------}
{ Returns the value of similarity between this paragraph list and Value.
  The larger return value - the larger similarity. }
function TRVListInfo.SimilarityValue(Value: TCustomRVInfo): Integer;
var i,min,max: Integer;
begin
  Result := 0;
  if OneLevelPreview=TRVListInfo(Value).OneLevelPreview then
    inc(Result, RVMW_LISTMISC);
  if ListID=TRVListInfo(Value).ListID then
    inc(Result, RVMW_LISTMISC div 2);
  min := Levels.Count;
  max := min;
  if TRVListInfo(Value).Levels.Count<min then
    min := TRVListInfo(Value).Levels.Count;
  if TRVListInfo(Value).Levels.Count>max then
    max := TRVListInfo(Value).Levels.Count;
  for i := 0 to min-1 do
    inc(Result, Levels[i].SimilarityValue(TRVListInfo(Value).Levels[i]));
  dec(Result, RVMW_LISTMISC*(max-min));
end;
{------------------------------------------------------------------------------}
{ READ method for LstID pseudo-property.
  This pseudo-property is used to store ListID property (which cannot be stored
  by itself, because it's readonly. }
procedure TRVListInfo.ReadListID(Reader: TReader);
begin
  FListID := Reader.ReadInteger;
end;
{------------------------------------------------------------------------------}
{ WRITE method for LstID pseudo-property. }
procedure TRVListInfo.WriteListID(Writer: TWriter);
begin
  Writer.WriteInteger(ListID);
end;
{------------------------------------------------------------------------------}
{ Defines additional property: LstID.
  See also comments to RVNoLstIDProperty. }
procedure TRVListInfo.DefineProperties(Filer: TFiler);
begin
  inherited;
  if not RVNoLstIDProperty then
    Filer.DefineProperty('LstID', ReadListID, WriteListID, True);
end;
{------------------------------------------------------------------------------}
{ WRITE method for Levels[] property. }
procedure TRVListInfo.SetLevels(const Value: TRVListLevelCollection);
begin
  if FLevels<>Value then
    FLevels.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ READ method for ListID property. }
function TRVListInfo.GetListID: Integer;
begin
  while FListID=0 do
    FListID := Random(MaxInt);
  Result := FListID;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Stores itself to the ini-file, to the section Section.
  fs is a format string for ini keys. }
procedure TRVListInfo.SaveToINI(ini: TRVIniFile; const Section, fs: String);
var i: Integer;
begin
  inherited SaveToINI(ini, Section, fs);
  WriteIntToIniIfNE(ini, Section, Format(fs,[RVINI_LEVELSCOUNT]),Levels.Count,0);
  WriteBoolToIniIfNE(ini,Section, RVINI_ONELEVELPREVIEW, OneLevelPreview, False);
  WriteIntToIniIfNE(ini, Section, RVINI_LISTID , FListID, 0);
  for i := 0 to Levels.Count-1 do
    Levels[i].SaveToINI(ini, Section, Format(fs,[''])+RVINI_LEVELPREFIX+IntToStr(i));
end;
{------------------------------------------------------------------------------}
{ Loads itself from the ini-file, from the section Section.
  fs is a format string for ini keys. }
procedure TRVListInfo.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
var cnt,i: Integer;
begin
  inherited LoadFromINI(ini, Section, fs, RVDEFAULTLISTSTYLENAME);
  OneLevelPreview := IniReadBool(ini, Section, RVINI_ONELEVELPREVIEW, False);
  FListID := ini.ReadInteger(Section, RVINI_LISTID, 0);
  cnt := ini.ReadInteger(Section, Format(fs,[RVINI_LEVELSCOUNT]), 0);
  for i := 0 to cnt-1 do
    Levels.Add.LoadFromINI(ini, Section, Format(fs,[''])+RVINI_LEVELPREFIX+IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Is at least one of list levels a numbered list? }
function TRVListInfo.HasNumbering: Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Levels.Count-1 do
    if Levels[i].HasNumbering then begin
      Result := True;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
{ Are all list levels numbered lists? }
function TRVListInfo.AllNumbered: Boolean;
var i: Integer;
begin
  Result := True;
  for i := 0 to Levels.Count-1 do
    if not Levels[i].HasNumbering then begin
      Result := False;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
{ Does at least one of list levels have markers of variable width? }
function TRVListInfo.HasVariableWidth: Boolean;
var i: Integer;
begin
  Result := False;
  for i := 0 to Levels.Count-1 do
    if Levels[i].HasVariableWidth then begin
      Result := True;
      exit;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVListInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
begin
  Levels.ConvertToDifferentUnits(NewUnits, GetRVStyle);
end;
{============================== TRVListInfos ==================================}
{ READ method for Items[] property.
  TODO: to implement InvalidItem, like for other styles. }
function TRVListInfos.GetItem(Index: Integer): TRVListInfo;
begin
  Result := TRVListInfo(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for Items[] property. }
procedure TRVListInfos.SetItem(Index: Integer; const Value: TRVListInfo);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWDEF4}
{ Inserts a new list style in the collection. This method is added for typecasting. }
function TRVListInfos.Insert(Index: Integer): TRVListInfo;
begin
  Result := TRVListInfo(inherited Insert(Index));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Adds a new list style to the collection. This method is added for typecasting. }
function TRVListInfos.Add: TRVListInfo;
begin
  Result := TRVListInfo(inherited Add);
end;
{------------------------------------------------------------------------------}
{ Removes all references from list levels to ImageList.
  Called from TRVStyle.Notification, when removing ImageList. }
procedure TRVListInfos.RemoveImageList(ImageList: TCustomImageList);
var i, j: Integer;
begin
  for i := 0 to Count-1 do
    for j := 0 to Items[i].Levels.Count-1 do
      if Items[i].Levels[j].FImageList=ImageList then
        Items[i].Levels[j].FImageList := nil;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section. }
procedure TRVListInfos.LoadFromINI(ini: TRVIniFile; const Section: String);
var i, cnt: Integer;
begin
  cnt := ini.ReadInteger(Section, RVINI_LISTSTYLECOUNT, 0);
  Clear;
  for i:=0 to cnt-1 do
    Add.LoadFromINI(ini, Section, RVINI_LISTSTYLEPREFIX+IntToStr(i));
end;
{------------------------------------------------------------------------------}
{ Stores itself to the ini-file, to the section Section. }
procedure TRVListInfos.SaveToINI(ini: TRVIniFile; const Section: String);
var i: Integer;
begin
  ini.WriteInteger(Section,RVINI_LISTSTYLECOUNT, Count);
  for i:=0 to Count-1 do
    Items[i].SaveToINI(ini, Section, RVINI_LISTSTYLEPREFIX+IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Searches for the list style equal to Style.
  If AddIfNotFound, adds such style (with Standard property = False) to the end
  of collection.
  ListID properties of list styles are ignored when comparing. 
  Returns index of the found style (or -1 if not found and not added). } 
function TRVListInfos.FindSuchStyle(Style: TRVListInfo; AddIfNotFound: Boolean): Integer;
var i: Integer;
begin
  for i:=0 to Count-1 do
    if Items[i].IsSimpleEqual(Style, False, True) then begin
      Result := i;
      exit;
    end;
  if AddIfNotFound then begin
    Add.Assign(Style);
    Result := Count-1;
    if RichViewResetStandardFlag then
      Items[Result].Standard := False;
    end
  else
    Result := -1;
end;
{------------------------------------------------------------------------------}
{ Searches for the list style having levels equal to Levels.
  If AddIfNotFound, adds such style (with properties Standard=False;
  OneLevelPreview=True; StyleNo=StyleNameForAdding) to the end
  of collection.
  Returns index of the found style (or -1 if not found and not added). }
function TRVListInfos.FindStyleWithLevels(Levels: TRVListLevelCollection;
  const StyleNameForAdding: String; AddIfNotFound: Boolean): Integer;
var i: Integer;
begin
  for i:=0 to Count-1 do
    if Items[i].Levels.IsSimpleEqual(Levels) then begin
      Result := i;
      exit;
    end;
  if AddIfNotFound then begin
    Add;
    Result := Count-1;
    if RichViewResetStandardFlag then
      Items[Result].Standard := False;
    Items[Result].StyleName := StyleNameForAdding;
    Items[Result].OneLevelPreview := True;
    Items[Result].Levels := Levels;
    end
  else
    Result := -1;
end;
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
{=============== TRVSTFontInfo, TRVSTParaInfo, TRVSTListInfo ==================}
{ Hiding properties }
procedure TRVSTFontInfo.SetNoProp(const Value: Integer);
begin
  raise ERichViewError.Create(errRVInvProp);
end;
{------------------------------------------------------------------------------}
procedure TRVSTParaInfo.SetNoProp(const Value: Integer);
begin
  raise ERichViewError.Create(errRVInvProp);
end;
{------------------------------------------------------------------------------}
procedure TRVSTListInfo.SetNoProp(const Value: Integer);
begin
  raise ERichViewError.Create(errRVInvProp);
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Allowing designtime editing of subcollections }
function TRVSTFontInfo.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{------------------------------------------------------------------------------}
function TRVSTParaInfo.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{------------------------------------------------------------------------------}
function TRVSTListInfo.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}
{============================= TRVStyleTemplate ===============================}
{ Constructor }
constructor TRVStyleTemplate.Create(Collection: TCollection);
begin
  inherited Create(Collection);
  FTextStyle := TRVSTFontInfo.Create(nil);
  FParaStyle := TRVSTParaInfo.Create(nil);
  FListStyle := TRVSTListInfo.Create(nil);
  {$IFDEF RICHVIEWCBDEF3}
  FParaStyle.FOwner := Self;
  FTextStyle.FOwner := Self;
  FListStyle.FOwner := Self;
  {$ENDIF}
  FParentId  := -1;
  if (Collection<>nil) and
     not ((TRVStyleTemplateCollection(Collection).FOwner<>nil) and
          (csLoading in TRVStyle(TRVStyleTemplateCollection(Collection).FOwner).ComponentState)) then
    TRVStyleTemplateCollection(Collection).AssignUniqueNameTo(Self);
end;
{------------------------------------------------------------------------------}
{ Destructor }
destructor TRVStyleTemplate.Destroy;
var i: Integer;
begin
  if FParent<>nil then
    FParent.RemoveChild(Self);
  if FChildren<>nil then
    for i := 0 to FChildren.Count-1 do
      TRVStyleTemplate(FChildren.Items[i]).ParentId := -1;
  if (Collection<>nil) and
     (TRVStyleTemplateCollection(Collection).FNormalStyleTemplate=Self) then
    TRVStyleTemplateCollection(Collection).FNormalStyleTemplate := nil;
  FChildren.Free;
  FTextStyle.Free;
  FParaStyle.Free;
  FListStyle.Free;
  inherited;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is TRVStyleTemplate }
procedure TRVStyleTemplate.Assign(Source: TPersistent);
begin
  if Source is TRVStyleTemplate then begin
    TextStyle := TRVStyleTemplate(Source).TextStyle;
    ParaStyle := TRVStyleTemplate(Source).ParaStyle;
    // ListStyle := TRVStyleTemplate(Source).ListStyle;
    if (Collection<>nil) and (Collection=TRVStyleTemplate(Source).Collection) then
      FParentId := TRVStyleTemplate(Source).ParentId;
    Name      := TRVStyleTemplate(Source).Name;
    ValidTextProperties1  := TRVStyleTemplate(Source).ValidTextProperties1;
    ValidTextProperties2  := TRVStyleTemplate(Source).ValidTextProperties2;
    ValidParaProperties1 := TRVStyleTemplate(Source).ValidParaProperties1;
    ValidParaProperties2 := TRVStyleTemplate(Source).ValidParaProperties2;
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Allows applying style template to text and paragraph styles using their
  Assign method. }
procedure TRVStyleTemplate.AssignTo(Dest: TPersistent);
begin
  inherited;
  if Dest is TCustomRVFontInfo then
    ApplyToTextStyle(TCustomRVFontInfo(Dest), nil, True)
  else if Dest is TCustomRVParaInfo then
    ApplyToParaStyle(TCustomRVParaInfo(Dest), True);
end;
{------------------------------------------------------------------------------}
{ Assigns valid properties of this style template (and its parents) to ATextStyle.
  Only propeties listed in AllowedProps can be changed.
  Return value: list of assigned properties. }
function TRVStyleTemplate.AssignToTextStyle(ATextStyle: TCustomRVFontInfo;
  AllowedProps: TRVFontInfoProperties): TRVFontInfoProperties;
var Props: TRVFontInfoProperties;
    Template: TRVStyleTemplate;
begin
  Props := ValidTextProperties1+ValidTextProperties2;
  Result := [];
  Template := Self;
  while True do begin
    Props := Props * AllowedProps;
    if Props<>[] then begin
      ATextStyle.AssignSelectedProperties(Template.TextStyle, Props);
      Result := Result+Props;
    end;
    Template := Template.FParent;
    if Template=nil then
      break;
    Props := Template.ValidTextProperties1+Template.ValidTextProperties2-Result;
  end;
end;
{------------------------------------------------------------------------------}
{ Applies this style template (and its parents) to ATextStyle.
  1) Assigns properties listed in ValidTextProperies of this style template
    (and its parents).
    if ATextStyle is TFontInfo, then properties listed in
    ATextStyle.ModifiedProperties are assigned only if
    OverrideModifiedProperties = True.    
  2) If AParaStyle<>nil and has StyleTemplate, does the
    same with the paragraph's style template (but without overriding properties
    assigned on the step 1.)
  3) If ATextStyle is TFontInfo then
    4) If OverrideModifiedProperties = True, excludes the applied properties from
       ATextStyle.ModifiedProperties.
    5) Reverts other (not applied and not listed in ModifiedProperties)
      properties to their default values.
  Default values are taken from the style template having name 'Normal'.
  If this style template does not exist, RVStyle.TextStyles[0] is used instead.
}
procedure TRVStyleTemplate.ApplyToTextStyle(ATextStyle: TCustomRVFontInfo;
  AParaStyle: TCustomRVParaInfo; OverrideModifiedProperties: Boolean);
var AppliedProps, AppliedProps2, DefProps: TRVFontInfoProperties;
    Template: TRVStyleTemplate;
    Index: Integer;
begin
  AppliedProps := RVAllFontInfoProperties;
  if not OverrideModifiedProperties and (ATextStyle is TFontInfo) then
    AppliedProps := AppliedProps
      -TFontInfo(ATextStyle).ModifiedProperties1-TFontInfo(ATextStyle).ModifiedProperties2;
  AppliedProps := AssignToTextStyle(ATextStyle, AppliedProps);
  if (AParaStyle<>nil) and (AParaStyle.StyleTemplateId>0) and (Collection<>nil) then begin
    Index := TRVStyleTemplateCollection(Collection).FindById(AParaStyle.StyleTemplateId);
    if Index>=0 then begin
      Template := TRVStyleTemplateCollection(Collection).Items[Index];
      AppliedProps2 := RVAllFontInfoProperties-AppliedProps;
      if (ATextStyle is TFontInfo) and (TFontInfo(ATextStyle).StyleTemplateId<>Template.Id) then
        AppliedProps2 := AppliedProps2
          -TFontInfo(ATextStyle).ModifiedProperties1-TFontInfo(ATextStyle).ModifiedProperties2;
      AppliedProps := AppliedProps+Template.AssignToTextStyle(ATextStyle, AppliedProps2);
    end;
  end;
  if ATextStyle is TFontInfo then begin
    if OverrideModifiedProperties then begin
      TFontInfo(ATextStyle).ModifiedProperties1 := TFontInfo(ATextStyle).ModifiedProperties1-AppliedProps;
      TFontInfo(ATextStyle).ModifiedProperties2 := TFontInfo(ATextStyle).ModifiedProperties2-AppliedProps;      
      TFontInfo(ATextStyle).StyleTemplateId := Id;
    end;
    DefProps := RVAllFontInfoProperties - AppliedProps
      - TFontInfo(ATextStyle).ModifiedProperties1 - TFontInfo(ATextStyle).ModifiedProperties2;
    if DefProps=[] then
      exit;
    if Collection<>nil then
      Template := TRVStyleTemplateCollection(Collection).FNormalStyleTemplate
    else
      Template := nil;
    if Template<>nil then
      Template.AssignToTextStyle(ATextStyle, DefProps)
    else if (Collection<>nil) and
            (TRVStyleTemplateCollection(Collection).FOwner<>nil) then
      ATextStyle.AssignSelectedProperties(
       (TRVStyleTemplateCollection(Collection).FOwner as TRVStyle).TextStyles[0],
       DefProps);
  end;
end;
{------------------------------------------------------------------------------}
{ Assigns valid properties of this style template (and its parents) to AParaStyle.
  Only propeties listed in AllowedProps can be changed.
  Return value: list of assigned properties. }
function TRVStyleTemplate.AssignToParaStyle(AParaStyle: TCustomRVParaInfo;
  AllowedProps: TRVParaInfoProperties): TRVParaInfoProperties;
var Props: TRVParaInfoProperties;
    Template: TRVStyleTemplate;
begin
  Props := ValidParaProperties1+ValidParaProperties2;
  Result := [];
  Template := Self;
  while True do begin
    Props := Props * AllowedProps;
    if (Props<>[]) then begin
      AParaStyle.AssignSelectedProperties(Template.ParaStyle, Props);
      Result := Result+Props;
    end;
    Template := Template.FParent;
    if Template=nil then
      break;
    Props := Template.ValidParaProperties1+Template.ValidParaProperties2-Result;
  end;
end;
{------------------------------------------------------------------------------}
{ Applies this style template (and its parents) to AParaStyle.
  1) Assigns properties listed in ValidParaProperies (1 and 2) of this style template
    (and its parents). if AParaStyle is TParaInfo, then properties listed in
    AParaStyle.ModifiedProperties (1 and 2) are assigned only if
    OverrideModifiedProperties = True.
  2) If AParaStyle is TParaInfo then
    3) If OverrideModifiedProperties = True, excludes the applied properties from
       AParaStyle.ModifiedProperties (1 and 2).
    4) Reverts other (not applied and not listed in ModifiedProperties (1 and 2))
      properties to their default values.
  Default values are taken from the style template having name 'Normal'.
  If this style template does not exist, RVStyle.ParaStyles[0] is used instead.
}
procedure TRVStyleTemplate.ApplyToParaStyle(AParaStyle: TCustomRVParaInfo;
  OverrideModifiedProperties: Boolean);
var AppliedProps, DefProps: TRVParaInfoProperties;
    Template: TRVStyleTemplate;
begin
  AppliedProps := RVAllParaInfoProperties;
  if not OverrideModifiedProperties and (AParaStyle is TParaInfo) then
    AppliedProps := AppliedProps - TParaInfo(AParaStyle).ModifiedProperties1 -
      TParaInfo(AParaStyle).ModifiedProperties2;
  AppliedProps := AssignToParaStyle(AParaStyle, AppliedProps);
  if AParaStyle is TParaInfo then begin
    if OverrideModifiedProperties then begin
      TParaInfo(AParaStyle).ModifiedProperties1 :=
        TParaInfo(AParaStyle).ModifiedProperties1 - (AppliedProps * RVAllParaInfoProperties1);
      TParaInfo(AParaStyle).ModifiedProperties2 :=
        TParaInfo(AParaStyle).ModifiedProperties2 - (AppliedProps * RVAllParaInfoProperties2);
      AParaStyle.StyleTemplateId := Id;
    end;
    DefProps := RVAllParaInfoProperties - AppliedProps
      - TParaInfo(AParaStyle).ModifiedProperties1
      - TParaInfo(AParaStyle).ModifiedProperties1;
    if DefProps=[] then
      exit;
    if Collection<>nil then
      Template := TRVStyleTemplateCollection(Collection).FNormalStyleTemplate
    else
      Template := nil;
    if Template<>nil then
      Template.AssignToParaStyle(AParaStyle, DefProps)
    else if (Collection<>nil) and
            (TRVStyleTemplateCollection(Collection).FOwner<>nil) then
      AParaStyle.AssignSelectedProperties(
       (TRVStyleTemplateCollection(Collection).FOwner as TRVStyle).ParaStyles[0],
       DefProps);
  end;
end;
{------------------------------------------------------------------------------}
{ Checks properties listed in PossibleProps.
  If they are in ValidTextProperties of this style template (or its parents),
  and their values are equal in ATextStyle and TextStyle property, they are excluded
  from ATextStyle.ModifiedProperties. }
procedure TRVStyleTemplate.ExcludeUnmodifiedTextStyleProperties(ATextStyle: TFontInfo;
      PossibleProps: TRVFontInfoProperties);
var Template: TRVStyleTemplate;
    Props: TRVFontInfoProperties;
begin
  Template := Self;
  while (PossibleProps<>[]) and (Template<>nil) do begin
    Props := PossibleProps * (Template.ValidTextProperties1+Template.ValidTextProperties2);
    ATextStyle.ExcludeUnmodifiedProperties(TextStyle, Props);
    PossibleProps := PossibleProps - Props;
    Template := Template.FParent;
  end;
end;
{------------------------------------------------------------------------------}
{ Checks properties listed in PossibleProps.
  If they are in ValidParaProperties (-1 or -2) of this style
  template (or its parents), and their values are equal in AParaStyle and
  ParaStyle property, they are excluded from AParaStyle.ModifiedProperties
  (-1 or -2). }
procedure TRVStyleTemplate.ExcludeUnmodifiedParaStyleProperties(AParaStyle: TParaInfo;
      PossibleProps: TRVParaInfoProperties);
var Template: TRVStyleTemplate;
    Props: TRVParaInfoProperties;
begin
  Template := Self;
  while (PossibleProps<>[]) and (Template<>nil) do begin
    Props := PossibleProps * (Template.ValidParaProperties1+Template.ValidParaProperties2);
    AParaStyle.ExcludeUnmodifiedProperties(ParaStyle, Props);
    PossibleProps := PossibleProps - Props;
    Template := Template.FParent;
  end;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Returns a name of the collection item, for design-time collection editor. }
function TRVStyleTemplate.GetDisplayName: String;
begin
  Result := Name;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for Id property. Value of this property is stored in FId field.
  If it's <= 0, it's undefined, and this method generates random value for it.
  If this item is inserted in the collection, the generated value is unique. }
function TRVStyleTemplate.GetId: TRVStyleTemplateId;
var i: Integer;
    found: Boolean;
begin
  if FId<=0 then
    repeat
      FId := Random(MaxInt);
      found := False;
      if Collection<>nil then
        for i := 0 to Collection.Count-1 do
          if (Collection.Items[i]<>Self) and
            (FId = TRVStyleTemplate(Collection.Items[i]).Id) then begin
            found := True;
            break;
          end;
    until not found;
  Result := FId;
end;
{------------------------------------------------------------------------------}
{ WRITE method for ListStyle property }
{
procedure TRVStyleTemplate.SetListStyle(const Value: TRVSTListInfo);
begin
  FListStyle.Assign(Value);
end;
}
{------------------------------------------------------------------------------}
{ WRITE method for ParaStyle property }
procedure TRVStyleTemplate.SetParaStyle(const Value: TRVSTParaInfo);
begin
  FParaStyle.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ WRITE method for TextStyle property }
procedure TRVStyleTemplate.SetTextStyle(const Value: TRVSTFontInfo);
begin
  FTextStyle.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ Overriden to add IDProp pseudo-property }
procedure TRVStyleTemplate.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('IDProp', ReadID, WriteID, True);
end;
{------------------------------------------------------------------------------}
{ READ method for IDProp pseudo-property.
  This pseudo-property is used to store Id property (which cannot be stored
  by itself, because it's readonly. }
procedure TRVStyleTemplate.ReadID(Reader: TReader);
begin
  FId := Reader.ReadInteger;
end;
{------------------------------------------------------------------------------}
{ WRITE method for IDProp pseudo-property. }
procedure TRVStyleTemplate.WriteID(Writer: TWriter);
begin
  Writer.WriteInteger(Id);
end;
{------------------------------------------------------------------------------}
{ Adds Child to the FChildren collection. }
procedure TRVStyleTemplate.AddChild(Child: TRVStyleTemplate);
begin
  if FChildren=nil then
    FChildren := TList.Create;
  FChildren.Add(Child);
end;
{------------------------------------------------------------------------------}
{ Removes Child from the FChildren collection. }
procedure TRVStyleTemplate.RemoveChild(Child: TRVStyleTemplate);
begin
  if FChildren<>nil then begin
    FChildren.Remove(Child);
    if FChildren.Count=0 then begin
      FChildren.Free;
      FChildren := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ WRITE method for ParentId property.
  If possible, references to parent and children are updated. }
procedure TRVStyleTemplate.SetParentId(const Value: TRVStyleTemplateId);
var CanUpdateReferences: Boolean;
    Index: Integer;
begin
  if Value=FParentId then
    exit;
  CanUpdateReferences := (Collection<>nil) and
    (TRVStyleTemplateCollection(Collection).FOwner<>nil) and
    not (csLoading in (TRVStyleTemplateCollection(Collection).FOwner as TComponent).ComponentState);
  if CanUpdateReferences and (ParentId>0) then begin
    Index := TRVStyleTemplateCollection(Collection).FindById(ParentId);
    if Index>=0 then
      TRVStyleTemplateCollection(Collection).Items[Index].RemoveChild(Self);
  end;
  FParentId := Value;
  FParent   := nil;
  if CanUpdateReferences and (ParentId>0) then begin
    Index := TRVStyleTemplateCollection(Collection).FindById(ParentId);
    if Index>=0 then begin
      FParent := TRVStyleTemplateCollection(Collection).Items[Index];
      if IsAncestorFor(FParent) then begin
        FParentId := -1;
        FParent := nil;
        raise ERichViewError.Create(errRVBadStyleTemplateParent);
      end;
      FParent.AddChild(Self);
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ WRITE method for Name property.
  Maintains TRVStyle.StyleTemplates.FNormalStyleTemplate property. }
procedure TRVStyleTemplate.SetName(const Value: TRVStyleTemplateName);
begin
  if Value<>FName then begin
    if FName=RVNORMALSTYLETEMPLATENAME then
      if (Collection<>nil) and
         (TRVStyleTemplateCollection(Collection).FNormalStyleTemplate=Self) then
        TRVStyleTemplateCollection(Collection).FNormalStyleTemplate := nil;
    FName := Value;
    if FName=RVNORMALSTYLETEMPLATENAME then
      if (Collection<>nil) then
        TRVStyleTemplateCollection(Collection).FNormalStyleTemplate := Self;
  end;
end;
{------------------------------------------------------------------------------}
{ Updates references to parent and children. Called from
  TRVStyleTemplateCollection.UpdateParentReferences. }
procedure TRVStyleTemplate.UpdateParentReference;
var Index: Integer;
begin
  FParent := nil;
  if ParentId>0 then begin
    Index := TRVStyleTemplateCollection(Collection).FindById(ParentId);
    if Index>=0 then begin
      FParent := TRVStyleTemplateCollection(Collection).Items[Index];
      FParent.AddChild(Self);
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ Is Self an ancestor for StyleTemplate?
  I.e., of Self=StyleTemplate, or Self=StyleTemplate.FParent, or
  Self=StyleTemplate.FParent.FParent, etc. }
function TRVStyleTemplate.IsAncestorFor(StyleTemplate: TRVStyleTemplate): Boolean;
var Ancestors: TList;
begin
  Result := False;
  Ancestors := TList.Create;
  try
    while StyleTemplate<>nil do begin
      if StyleTemplate=Self then begin
        Result := True;
        break;
      end;
      Ancestors.Add(StyleTemplate);
      StyleTemplate := StyleTemplate.FParent;
      if (StyleTemplate<>nil) and (Ancestors.IndexOf(StyleTemplate)>=0) then
        StyleTemplate := nil; // exiting circular reference (bad)
    end;
  finally
    Ancestors.Free;
  end;
end;
{$IFNDEF RVDONOTUSEINI}
procedure TRVStyleTemplate.LoadFromINI(ini: TRVIniFile; const Section, fs: String);
begin
  FId       := ini.ReadInteger(Section, Format(fs, [RVINI_ST_ID]), -1);
  FName     := ini.ReadString( Section, Format(fs, [RVINI_ST_NAME]), '');
  FParentId := ini.ReadInteger(Section, Format(fs, [RVINI_ST_PARENTID]), -1);
  // Load the associated text and para style
  Self.TextStyle.LoadFromINI(ini, Section, RVINI_TEXTSTYLEPREFIX + IntToStr(Id), False, crJump);
  Self.ParaStyle.LoadFromINI(ini, Section, RVINI_PARASTYLEPREFIX + IntToStr(Id));
end;
{------------------------------------------------------------------------------}
procedure TRVStyleTemplate.SaveToINI(ini: TRVIniFile; const Section, fs: String);
begin
  ini.WriteInteger(Section, Format(fs, [RVINI_ST_ID]), Id);
  ini.WriteString( Section, Format(fs, [RVINI_ST_NAME]), Name);
  ini.WriteInteger(Section, Format(fs, [RVINI_ST_PARENTID]), ParentId);
  // Save associated text and para style
  TextStyle.SaveToINI(ini, Section, RVINI_TEXTSTYLEPREFIX + IntToStr(Id));
  ParaStyle.SaveToINI(ini, Section, RVINI_PARASTYLEPREFIX + IntToStr(Id));
end;
{$ENDIF}
{========================== TRVStyleTemplateCollection ========================}
{ Constructor }
constructor TRVStyleTemplateCollection.Create(Owner: TPersistent);
begin
  inherited Create(TRVStyleTemplate);
  FOwner := Owner;
  FDefStyleName := RVDEFAULTSTYLETEMPLATENAME;
end;
{------------------------------------------------------------------------------}
{ Resets counter used to generate unique item names }
procedure TRVStyleTemplateCollection.ResetNameCounter;
begin
  FNameCounter := 0;
end;
{------------------------------------------------------------------------------}
{ Function for comparing names of style templates. Used to sort the collection.
  Case sensitive.}
function CompareStyleTemplateNames(Item1, Item2: Pointer): Integer;
begin
  Result :=  AnsiCompareStr(TRVStyleTemplate(Item1).Name,TRVStyleTemplate(Item2).Name);
end;
{------------------------------------------------------------------------------}
{ Sorts items by Name in ascending order, case sensitive }
procedure TRVStyleTemplateCollection.Sort;
var
  i: Integer;
  List: TList;
begin
  List := TList.Create;
  try
    for i := 0 to Count - 1 do
      List.Add(Items[i]);
    List.Sort(CompareStyleTemplateNames);
    for i := 0 to List.Count - 1 do
      TRVStyleTemplate(List.Items[i]).Index := i
  finally
    List.Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the item having the given Id.
  If not found, returns -1. }
function TRVStyleTemplateCollection.FindById(Id: TRVStyleTemplateId): Integer;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if Items[i].Id=Id then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ Returns the index of the item having the given Name (case sensitive)
  If not found, returns -1. }
function TRVStyleTemplateCollection.FindByName(const Name: TRVStyleTemplateName): Integer;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if Items[i].Name=Name then begin
      Result := i;
      exit;
    end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
{ The the style template named 'Normal'), or nil if not found. Fast. }
function TRVStyleTemplateCollection.GetNormalStyleTemplate: TRVStyleTemplate;
begin
  Result := FNormalStyleTemplate;
end;
{------------------------------------------------------------------------------}
{ Assigns item names to Strings. If AssignObjects=True, then items are assigned
  to Strings.Objects. }
procedure TRVStyleTemplateCollection.AssignToStrings(Strings: TStrings;
  AssignObjects: Boolean);
var i: Integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    {$IFDEF RICHVIEWCBDEF3}
    Strings.Capacity := Count;
    {$ENDIF}
    for i := 0 to Count-1 do
      if AssignObjects then
        Strings.AddObject(Items[i].Name, Items[i])
      else
        Strings.Add(Items[i].Name);
  finally
    Strings.EndUpdate;
  end;
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self, if Source is a TRVStyleTemplateCollection. }
procedure TRVStyleTemplateCollection.Assign(Source: TPersistent);
begin
  if Source is TRVStyleTemplateCollection then
    AssignStyleTemplates(TRVStyleTemplateCollection(Source), False)
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
{ Assigns Source to Self. Two possible modes are possible:
  1. CopyIds=True : Id and ParentId properties are copied. Self becomes
     the exact copy of Source.
  2. CopyIds=False: Id properties are not copied, but ParentId properties
     point to items with the same indices as in the Source. }
procedure TRVStyleTemplateCollection.AssignStyleTemplates(
  Source: TRVStyleTemplateCollection; CopyIds: Boolean);
var i: Integer;
begin
  if Source=Self then
    exit;
  inherited Assign(Source);
  if CopyIDs then begin
    for i := 0 to Count-1 do
      Items[i].FId := Source.Items[i].Id;
    for i := 0 to Count-1 do
      Items[i].ParentId := Source.Items[i].ParentId;
    end
  else begin
    for i := 0 to Count-1 do
      if Source.Items[i].FParent<>nil then
        Items[i].ParentId := Items[Source.Items[i].FParent.Index].Id;
  end;
end;
{------------------------------------------------------------------------------}
{ Clears format from ATextStyle:
  - if 'Normal' StyleTemplate exists, applies it;
  - otherwise assigns the TextStyle[0] and clears references.
  AParaStyle is a style of paragraph where this text is located }
procedure TRVStyleTemplateCollection.ClearTextFormat(ATextStyle: TCustomRVFontInfo;
  AParaStyle: TCustomRVParaInfo);
begin
  if FNormalStyleTemplate<>nil then
    FNormalStyleTemplate.ApplyToTextStyle(ATextStyle, AParaStyle, True)
  else if (FOwner<>nil) then begin
    ATextStyle.Assign((FOwner as TRVStyle).TextStyles[0]);
    if ATextStyle is TFontInfo then begin
      TFontInfo(ATextStyle).ModifiedProperties1 := [];
      TFontInfo(ATextStyle).ModifiedProperties2 := [];      
      TFontInfo(ATextStyle).StyleTemplateId := -1;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ Clears format from AParaStyle:
  - if 'Normal' StyleTemplate exists, applies it;
  - otherwise assigns the ParaStyle[0] and clears references. }
procedure TRVStyleTemplateCollection.ClearParaFormat(AParaStyle: TCustomRVParaInfo);
begin
  if FNormalStyleTemplate<>nil then
    FNormalStyleTemplate.ApplyToParaStyle(AParaStyle, True)
  else if (FOwner<>nil) then begin
    AParaStyle.Assign((FOwner as TRVStyle).ParaStyles[0]);
    if AParaStyle is TParaInfo then begin
      TParaInfo(AParaStyle).ModifiedProperties1 := [];
      TParaInfo(AParaStyle).ModifiedProperties2 := [];
      TParaInfo(AParaStyle).StyleTemplateId := -1;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
procedure TRVStyleTemplateCollection.LoadFromINI(ini: TRVIniFile;
  const Section: String);
var i, total: integer;
begin
  total := ini.ReadInteger(Section, RVINI_STCOUNT, 0);
  Clear;
  for i := 0 to total - 1 do begin
    Add;
    Items[i].LoadFromINI(ini, Section, RVINI_STPREFIX + IntToStr(i));
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVStyleTemplateCollection.SaveToINI(ini: TRVIniFile;
  const Section: String);
var i: integer;
begin
  ini.WriteInteger(Section, RVINI_STCOUNT, Count);
  for i := 0 to Count - 1 do
    Items[i].SaveToINI(ini, Section, RVINI_STPREFIX + IntToStr(i));
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
{ Designtime support. Required for the collection editor. }
function TRVStyleTemplateCollection.GetOwner: TPersistent;
begin
  Result := FOwner;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ READ method for the property Items[]. }
function TRVStyleTemplateCollection.GetItem(Index: Integer): TRVStyleTemplate;
begin
  Result := TRVStyleTemplate(inherited GetItem(Index));
end;
{------------------------------------------------------------------------------}
{ WRITE method for the property Items[]. }
procedure TRVStyleTemplateCollection.SetItem(Index: Integer;
  const Value: TRVStyleTemplate);
begin
  inherited SetItem(Index, Value);
end;
{------------------------------------------------------------------------------}
{ STORE method for DefStyleName property }
function TRVStyleTemplateCollection.StoreDefStyleName: Boolean;
begin
  Result := FDefStyleName<>RVDEFAULTSTYLETEMPLATENAME;
end;
{------------------------------------------------------------------------------}
{ Generates unique style name }
procedure TRVStyleTemplateCollection.AssignUniqueNameTo(Item: TRVStyleTemplate);
var i: Integer;
    found: Boolean;
    Name: String;
begin
  if (Count=1) and (Items[0]=Item) then
    FNameCounter := 0;
  if FNameCounter=MaxInt then
    FNameCounter := 0;
  repeat
    inc(FNameCounter);
    Name := Format(FDefStyleName, [FNameCounter]);
    found := False;
    for i := 0 to Count-1 do
      if (Items[i]<>Item) and (Items[i].Name=Name) then begin
        found := True;
        break;
      end;
  until not found;
  Item.Name := Name;
end;
{------------------------------------------------------------------------------}
{ Updates references to parent and children of each item.
  Normally, references are updated automatically. Updates are deferred only
  when loading the collection from stream. }
procedure TRVStyleTemplateCollection.UpdateParentReferences;
var i: Integer;
begin
  for i := 0 to Count-1 do
    Items[i].UpdateParentReference;
end;
{$ENDIF}
{============================== TRVStyle ======================================}
{ Constructor. Assigns default values to properties. Adds some default items
  to TextStyles and ParaStyles.
  Loads crJump and crRVFlipArrow cursors. }
constructor TRVStyle.Create(AOwner: TComponent);
var jumpcur : HCURSOR;
const IDC_HAND = MakeIntResource(32649);
begin
  inherited Create(AOwner);
  {$IFDEF RICHVIEWDEF2009}
  FDefaultUnicodeStyles := True;
  {$ENDIF}
  jumpcur := LoadCursor(0, IDC_HAND);
  if jumpcur=0 then
    jumpcur := LoadCursor(hInstance,RVRC_JUMP_CURSOR);
  Screen.Cursors[crJump] := jumpcur;
  Screen.Cursors[crRVFlipArrow] := LoadCursor(hInstance,RVRC_FLIPARROW_CURSOR);
  CreateGraphicInterface;
  FSpacesInTab       := 0;
  FDefTabWidth       := 48;
  FFullRedraw        := False;
  FJumpCursor        := crJump;
  FLineSelectCursor  := crRVFlipArrow;
  FColor             := clWindow;
  FHoverColor        := clNone;
  FCurrentItemColor  := clNone;
  FSelColor          := clHighlight;
  FSelTextColor      := clHighlightText;
  FInactiveSelColor     := clHighlight;
  FInactiveSelTextColor := clHighlightText;
  FCheckpointColor   := clGreen;
  FCheckpointEvColor := clLime;
  FPageBreakColor    := clBtnShadow;
  FSoftPageBreakColor := clBtnFace;
  FLiveSpellingColor := clRed;
  FFloatingLineColor := DEFAULT_FLOATINGLINECOLOR;
  FSpecialCharactersColor := clNone;
  FUseSound          := True;
  FSelectionMode     := rvsmWord;
  FSelectionStyle    := rvssItems;
  {$IFNDEF RVDONOTUSEUNICODE}
  FDefUnicodeStyle   := -1;
  FDefCodePage       := CP_ACP;
  {$ENDIF}
  FFieldHighlightColor := clBtnFace;
  FDisabledFontColor  := clNone;
  FFieldHighlightType := rvfhCurrent;
  FFootnoteNumbering := rvseqDecimal;
  FEndnoteNumbering  := rvseqLowerRoman;
  FFootnotePageReset := True;
  FTextStyles := TFontInfos.Create(GetTextStyleClass, Self);
  FParaStyles := TParaInfos.Create(GetParaStyleClass, Self);
  FListStyles := TRVListInfos.Create(GetListStyleClass, Self);
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  FStyleTemplates := TRVStyleTemplateCollection.Create(Self);
  {$ENDIF}
  FLineWrapMode := rvWrapNormal;
  ResetParaStyles;
  ResetTextStyles;
end;
{------------------------------------------------------------------------------}
{ Returns class of item of ParaStyles collection. You can override this method
  to add new properties to paragraph style. }
function TRVStyle.GetParaStyleClass: TRVParaInfoClass;
begin
  Result := TParaInfo;
end;
{------------------------------------------------------------------------------}
{ Returns class of item of TextStyles collection. You can override this method
  to add new properties to text style. }
function TRVStyle.GetTextStyleClass: TRVFontInfoClass;
begin
  Result := TFontInfo;
end;
{------------------------------------------------------------------------------}
{ Returns class of item of ListStyles collection. You can override this method
  to add new properties to list style. }
function TRVStyle.GetListStyleClass: TRVListInfoClass;
begin
  Result := TRVListInfo;
end;
{------------------------------------------------------------------------------}
{ Delphi streaming support (required for D2) }
procedure TRVStyle.ReadState(Reader: TReader);
begin
  {$IFNDEF RICHVIEWDEF3}
  ParaStyles.Clear;
  TextStyles.Clear;
  {$ENDIF}
  inherited ReadState(Reader);
end;
{------------------------------------------------------------------------------}
{ Destructor. }
destructor TRVStyle.Destroy;
begin
  FTextStyles.Free;
  FParaStyles.Free;
  FListStyles.Free;
  FInvalidPicture.Free;
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  FStyleTemplates.Free;
  {$ENDIF}
  FGraphicInterface.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
{ Applies TextStyle[StyleNo] to the Canvas (all properties except for colors).
  DefBiDiMode - bi-di mode of paragraph.
  CanUseCustomPPI allows using TextStyles.PixelsPerInch property.
  This method calls OnApplyStyle event, then (if allowed) TextStyles[StyleNo].Apply
  method and OnAfterApplyStyle event. }
procedure TRVStyle.ApplyStyle(Canvas: TCanvas; StyleNo: Integer;
  DefBiDiMode: TRVBiDiMode; CanUseCustomPPI: Boolean;
  ExtraFontInfo: PRVExtraFontInfo; IgnoreSubSuperScript,
  ToFormatCanvas: Boolean);
var DoDefault: Boolean;
begin
  DoDefault := True;
  if Assigned(FOnApplyStyle) then 
    FOnApplyStyle(Self, Canvas, StyleNo, DoDefault);
  if DoDefault then begin
    FTextStyles[StyleNo].Apply(Canvas, DefBiDiMode, CanUseCustomPPI,
      ExtraFontInfo, IgnoreSubSuperScript, ToFormatCanvas, GraphicInterface);
    if Assigned(FOnAfterApplyStyle) then
      FOnAfterApplyStyle(Self, Canvas, StyleNo);
    end
  else if ToFormatCanvas then
    Canvas.Font.Height := Canvas.Font.Height*RVFORMATCANVASFACTOR;
end;
{------------------------------------------------------------------------------}
{ Applies colors of TextStyle[StyleNo] to the Canvas.
  DrawState defines a state of text (selected, hot, etc.).
  This method calls OnApplyStyleColor event, then (if allowed)
  TextStyles[StyleNo].ApplyColor method.
  Colors are corrected according to the ColorMode.
  If Printing, this is a printing or print preview. }
procedure TRVStyle.ApplyStyleColor(Canvas: TCanvas; StyleNo: Integer;
  DrawState: TRVTextDrawStates; Printing: Boolean; ColorMode: TRVColorMode);
var DoDefault: Boolean;
begin
  if Assigned(FOnApplyStyleColor) then begin
    DoDefault := True;
    FOnApplyStyleColor(Self, Canvas, StyleNo, DrawState, DoDefault);
    if DoDefault then
      FTextStyles[StyleNo].ApplyColor(Canvas, Self, DrawState, Printing, ColorMode);
    end
  else
    FTextStyles[StyleNo].ApplyColor(Canvas, Self, DrawState, Printing, ColorMode);
end;
{------------------------------------------------------------------------------}
{ Draws string s on Canvas using TextStyles[StyleNo].
  It's assumed that ApplyStyleColor and ApplyStyle were already called.
  (RVData, ItemNo, OffsetInItem) specify a location of this string in document.
  These properties will be assigned to the corresponding fields of Self (for using
  in events).
  If TextStyles[StyleNo].Unicode, s must contain a "raw unicode".
  Drawing item rectangle is Bounds(Left, Top, Width, Height).
  Text position is (Left+SpaceBefore, Top).
  If RVUSEBASELINE is defined, and Printing=True, BaseLine parameter is valid,
  and text is drawn relative to base line BaseLine instead of relative to Top.  
  DrawState defines a state of text (selected, hot, etc.).
  Colors are corrected according to the ColorMode.
  If Printing, this is a printing or print preview.
  If PreviewCorrection and Printing, this is a print preview that allows correction.
  DefBiDiMode - bi-di mode of paragraph.
}
procedure TRVStyle.DrawStyleText(const s: TRVRawByteString; Canvas: TCanvas;
  ItemNo, OffsetInItem, StyleNo: Integer; RVData: TPersistent;
  SpaceBefore, Left, Top, Width, Height, BaseLine: Integer;
  DrawState: TRVTextDrawStates;
  Printing, PreviewCorrection: Boolean; ColorMode: TRVColorMode;
  DefBiDiMode: TRVBidiMode; RefCanvas: TCanvas);
var DoDefault: Boolean;
begin
  if Assigned(FOnDrawStyleText) then begin
    DoDefault := True;
    Self.ItemNo := ItemNo;
    Self.RVData := RVData;
    Self.OffsetInItem := OffsetInItem;
    FOnDrawStyleText(Self, s, Canvas, StyleNo,
      SpaceBefore, Left, Top, Width, Height, DrawState, DoDefault);
    end
  else
    DoDefault := True;
  if DoDefault then
    FTextStyles[StyleNo].Draw(s, Canvas, StyleNo, SpaceBefore, Left, Top,
      Width, Height, BaseLine,
      Self, DrawState, Printing, PreviewCorrection, ColorMode, DefBiDiMode,
      RefCanvas, GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Does text of TextStyles[StyleNo] require redrawing when mouse moves in/out?
  This function checks HoverColors (fore- and background) and calls
  OnStyleHoverSensitive event. }
function TRVStyle.StyleHoverSensitive(StyleNo: Integer): Boolean;
begin
  Result := (GetHoverColor(StyleNo)<>clNone) or
            (FTextStyles[StyleNo].HoverBackColor<>FTextStyles[StyleNo].BackColor) or
            (FTextStyles[StyleNo].HoverUnderlineColor<>clNone) or
            (FTextStyles[StyleNo].HoverEffects<>[]);
  if Assigned(FOnStyleHoverSensitive) then
    FOnStyleHoverSensitive(Self, StyleNo, Result);
end;
{------------------------------------------------------------------------------}
{ Draws text background at Bounds(Left,Top,Width,Height) on Canvas.
  This method calls OnDrawTextBackground event. If this event is not processed,
  it does nothing (because background is drawn in DrawStyleText).
  (RVData, ItemNo) specify position of text item in document.
  These properties will be assigned to the corresponding fields of Self
  (for using in event).
  DrawState defines a state of text (selected, hot, etc.) }
procedure TRVStyle.DrawTextBack(Canvas: TCanvas; ItemNo, StyleNo: Integer;
  RVData: TPersistent; Left, Top, Width, Height: Integer;
  DrawState: TRVTextDrawStates);
var DoDefault: Boolean;
begin
  if Assigned(FOnDrawTextBack) then begin
    DoDefault := True;
    Self.ItemNo := ItemNo;
    Self.RVData := RVData;
    FOnDrawTextBack(Self, Canvas, StyleNo, Left, Top, Width, Height, DrawState, DoDefault);
  end;
end;
{------------------------------------------------------------------------------}
{ Draw checkpoint on Canvas.
  (X,Y) - top left corner of item owning the checkpoint.
  XShift specifies a horizontal scrolling position (useful if you want to draw
  something on margin rather than relative to the item's X coordinate).
  RaiseEvent - property of checkpoint.
  Control - TRichView where to draw.
  ItemNo - index of item owning this checkpoint.
  NOTE: this is old method. When it was created, it was possible to get additional
  checkpoint info using Control and ItemNo. TODO: to add RVData parameter.
  This method calls OnDrawCheckpoint event. Then (if allowed) draws checkpoint
  as a horizontal dotted line with a small circle at (X,Y).
  If RaiseEvent, CheckpointEvColor color is used, otherwise CheckpointColor.
}
procedure TRVStyle.DrawCheckpoint(Canvas: TCanvas; X,Y, AreaLeft, Width: Integer;
  RVData: TPersistent; ItemNo, XShift: Integer;
  RaiseEvent: Boolean; Control: TControl);
var DoDefault: Boolean;
begin
  DoDefault := True;
  if Assigned(FOnDrawCheckpoint) then begin
    Self.RVData := RVData;
    Self.ItemNo := ItemNo;
    FOnDrawCheckpoint(Self, Canvas, X, Y, ItemNo, XShift, RaiseEvent, Control,
      DoDefault);
  end;
  if DoDefault then begin
    Canvas.Pen.Width := 1;
    if RaiseEvent then
      Canvas.Pen.Color := CheckpointEvColor
    else
      Canvas.Pen.Color := CheckpointColor;
    Canvas.Brush.Style := bsClear;
    if ItemNo<>-1 then begin
      Canvas.Pen.Style := psSolid;
      GraphicInterface.Ellipse(Canvas, X-2,Y-2, X+2, Y+2);
    end;
    Canvas.Pen.Style := psDot;
    GraphicInterface.Line(Canvas,
      AreaLeft-XShift, Y, AreaLeft+Width-XShift, Y);
  end;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
end;
{------------------------------------------------------------------------------}
{ Draws page break on Canvas. Y - vertical coordinate. XShift specifies
  a horizontal scrolling. Control is TRichView where to draw.
  PageBreakType - type of pagebreak (hard (explicit) or soft (automatic)).
  This method calls OnDrawPageBreak event. Then (if allowed) - draws a line
  with "dog ear" effect, using PageBreakColor or SoftPageBreakColor. }
procedure TRVStyle.DrawPageBreak(Canvas: TCanvas; Y, XShift: Integer;
  PageBreakType: TRVPageBreakType; Control: TControl;
  RVData: TPersistent; ItemNo: Integer);
var DoDefault: Boolean;
    x: Integer;
const CORNERSIZE=8;
begin
  DoDefault := True;
  if Assigned(FOnDrawPageBreak) then begin
    Self.RVData := RVData;
    Self.ItemNo := ItemNo;
    FOnDrawPageBreak(Self, Canvas, Y, XShift, PageBreakType, Control, DoDefault);
  end;
  if DoDefault then begin
    if PageBreakType = rvpbPageBreak then
      Canvas.Pen.Color := PageBreakColor
    else
      Canvas.Pen.Color := SoftPageBreakColor;
    Canvas.Pen.Width := 1;
    Canvas.Pen.Style := psSolid;
    x := TCustomRVFormattedData(RVData).GetWidth-XShift-CORNERSIZE;
    Canvas.Brush.Color := clWindow;
    Canvas.Brush.Style := bsSolid;
    GraphicInterface.Line(Canvas, -XShift,Y, X,Y);
    GraphicInterface.Polygon(Canvas, [Point(X,Y), Point(X+CORNERSIZE,Y+CORNERSIZE),
                   Point(X,Y+CORNERSIZE)]);
  end;
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
end;
{------------------------------------------------------------------------------}
{ Draw background of ParaStyles[ParaNo] on Canvas at Rect.
  If Printing, this is printing or print preview.
  Colors are corrected according to ColorMode.
  This method calls OnDrawParaBack event, then (if allowed)
  ParaStyles[ParaNo].Background.Draw method.
  Note: when calling this method, Self.RVData and Self.ItemNo
  (index of the last item of the paragraph) are assigned. }
procedure TRVStyle.DrawParaBack(Canvas: TCanvas; ParaNo: Integer; const Rect: TRect;
  Printing: Boolean; ColorMode: TRVColorMode);
var DoDefault: Boolean;
begin
  DoDefault := True;
  if Assigned(FOnDrawParaBack) then
    FOnDrawParaBack(Self, Canvas, ParaNo, Rect, DoDefault);
  if DoDefault then
    FParaStyles[ParaNo].Background.Draw(Rect, Canvas, Printing, ColorMode,
      GraphicInterface);
end;
{------------------------------------------------------------------------------}
{ Clears TextStyles and fills it with default items. }
procedure TRVStyle.ResetTextStyles;
var fi: TFontInfo;
    i : Integer;
begin
  FTextStyles.Clear;
  for i := 0 to LAST_DEFAULT_STYLE_NO do begin
    fi := FTextStyles.Add;
    case i of
     rvsNormal:
        begin
           fi.StyleName := RVDEFSTYLENAME0;
        end;
     rvsHeading:
        begin
           fi.Style := fi.Style + [fsBold];
           fi.Color := clBlue;
           fi.StyleName := RVDEFSTYLENAME1;
        end;
     rvsSubheading:
        begin
           fi.Style := fi.Style + [fsBold];
           fi.Color := clNavy;
           fi.StyleName := RVDEFSTYLENAME2;
        end;
     rvsKeyword:
        begin
           fi.Style := fi.Style + [fsItalic];
           fi.Color := clMaroon;
           fi.StyleName := RVDEFSTYLENAME3;
        end;
     rvsJump1, rvsJump2:
        begin
           fi.Style := fi.Style + [fsUnderline];
           fi.Color := clGreen;
           fi.Jump  := True;
           fi.JumpCursor := JumpCursor;
           if i=rvsJump1 then
             fi.StyleName := RVDEFSTYLENAME4
           else
             fi.StyleName := RVDEFSTYLENAME5;
        end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{ Clears ParaStyles and fills it with default items. }
procedure TRVStyle.ResetParaStyles;
begin
  FParaStyles.Clear;
  FParaStyles.Add;
  with FParaStyles.Add as TParaInfo do begin
    StyleName := RVDEFPARASTYLENAME1;
    Alignment := rvaCenter;
  end;
end;
{------------------------------------------------------------------------------}
{ WRITE method for TextStyles property. }
procedure TRVStyle.SetTextStyles(Value: TFontInfos);
begin
  if FTextStyles<>Value then
    FTextStyles.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ WRITE method for ParaStyles property. }
procedure TRVStyle.SetParaStyles(Value: TParaInfos);
begin
  if FParaStyles<>Value then
    FParaStyles.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ WRITE method for ListStyles property. }
procedure TRVStyle.SetListStyles(Value: TRVListInfos);
begin
  if FListStyles<>Value then
    FListStyles.Assign(Value);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESTYLETEMPLATES}
{ WRITE method for StyleTemplates property }
procedure TRVStyle.SetStyleTemplates(const Value: TRVStyleTemplateCollection);
begin
  if FStyleTemplates<>Value then
    FStyleTemplates.Assign(Value);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Returns "hot" (under mouse) color for the specified Color. }
function TRVStyle.GetHoverColorByColor(Color: TColor): TColor;
begin
  if Color<>clNone then
    Result := Color
  else
    Result := HoverColor;
end;
{------------------------------------------------------------------------------}
{ Returns "hot" (under mouse) text color for TextStyle[StyleNo]. }
function TRVStyle.GetHoverColor(StyleNo: Integer): TColor;
begin
  if FTextStyles[StyleNo].HoverColor<>clNone then
    Result := FTextStyles[StyleNo].HoverColor
  else
    Result := HoverColor;
end;
{------------------------------------------------------------------------------}
{ (Deprecated) }
function TRVStyle.AddTextStyle: Integer;
begin
   FTextStyles.Add;
   AddTextStyle := FTextStyles.Count-1;
end;
{------------------------------------------------------------------------------}
{ (Deprecated) }
procedure TRVStyle.DeleteTextStyle(Index: Integer);
begin
   FTextStyles[Index].Free;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEINI}
{ Loads itself from the ini-file, from the section Section. }
procedure TRVStyle.LoadFromINI(ini: TRVIniFile; Section: String);
begin
  Units             := TRVStyleUnits(ini.ReadInteger(Section, RVINI_UNITS, ord(rvstuPixels)));
  Color             := ini.ReadInteger(Section, RVINI_COLOR,             clWindow);
  HoverColor        := ini.ReadInteger(Section, RVINI_HOVERCOLOR,        clNone);
  CurrentItemColor  := ini.ReadInteger(Section, RVINI_CURRENTITEMCOLOR,  clNone);
  SelColor          := ini.ReadInteger(Section, RVINI_SELCOLOR,          clHighlight);
  SelTextColor      := ini.ReadInteger(Section, RVINI_SELTEXTCOLOR,      clHighlightText);
  InactiveSelColor     := ini.ReadInteger(Section, RVINI_ISELCOLOR,      clHighlight);
  InactiveSelTextColor := ini.ReadInteger(Section, RVINI_ISELTEXTCOLOR,  clHighlightText);
  CheckpointColor   := ini.ReadInteger(Section, RVINI_CPCOLOR,   clGreen);
  CheckpointEvColor := ini.ReadInteger(Section, RVINI_CPEVCOLOR, clLime);
  PageBreakColor    := ini.ReadInteger(Section, RVINI_PAGEBREAKCOLOR,  clBtnShadow);
  SoftPageBreakColor := ini.ReadInteger(Section, RVINI_SOFTPAGEBREAKCOLOR, clBtnFace);
  LiveSpellingColor := ini.ReadInteger(Section, RVINI_LIVESPELLINGCOLOR, clRed);
  FloatingLineColor := ini.ReadInteger(Section, RVINI_FLOATLINECOLOR, DEFAULT_FLOATINGLINECOLOR);
  SpecialCharactersColor := ini.ReadInteger(Section, RVINI_SPECCHARCOLOR, clNone);
  JumpCursor        := ini.ReadInteger(Section, RVINI_JUMPCURSOR,        crJump);
  UseSound          := Boolean(ini.ReadInteger(Section, RVINI_USESOUND,  Integer(True)));
  SelectionMode     := TRVSelectionMode(ini.ReadInteger(Section, RVINI_SELECTIONMODE, ord(rvsmWord)));
  SelectionStyle    := TRVSelectionStyle(ini.ReadInteger(Section, RVINI_SELECTIONSTYLE, ord(rvssItems)));
  SpacesInTab       := ini.ReadInteger(Section, RVINI_SPACESINTAB, 0);
  DefTabWidth       := ini.ReadInteger(Section, RVINI_DEFTABWIDTH, 48);
  {$IFNDEF RVDONOTUSEUNICODE}
  DefUnicodeStyle   := ini.ReadInteger(Section, RVINI_DEFUNICODESTYLE,   -1);
  DefCodePage       := ini.ReadInteger(Section, RVINI_DEFCODEPAGE,   CP_ACP);
  {$ENDIF}
  FieldHighlightColor := ini.ReadInteger(Section, RVINI_FIELDHIGHLIGHTCOLOR, clBtnFace);
  DisabledFontColor := ini.ReadInteger(Section, RVINI_DISABLEDFONTCOLOR, clNone);

  FieldHighlightType := TRVFieldHighlightType(
    ini.ReadInteger(Section, RVINI_FIELDHIGHLIGHTTYPE, ord(rvfhCurrent)));
  FootnoteNumbering := TRVSeqType(
    ini.ReadInteger(Section, RVINI_FOOTNOTENUMBERING, ord(rvseqDecimal)));
  EndnoteNumbering := TRVSeqType(
    ini.ReadInteger(Section, RVINI_ENDNOTENUMBERING, ord(rvseqLowerRoman)));
  FootnotePageReset:= IniReadBool(ini, Section, RVINI_FOOTNOTEPAGERESET, True);
  LineWrapMode := TRVLineWrapMode(ini.ReadInteger(Section, RVINI_LINEWRAPMODE, ord(rvWrapNormal)));

  ParaStyles.LoadFromINI(ini, Section);
  TextStyles.LoadFromINI(ini, Section, JumpCursor);
  ListStyles.LoadFromINI(ini, Section);
end;
{------------------------------------------------------------------------------}
{ Stores itself to the ini-file, to the section Section.
  WARNING: this Section is erased before writing! }
procedure TRVStyle.SaveToINI(ini: TRVIniFile; Section: String);
begin
  ini.EraseSection(Section);
  WriteIntToIniIfNE(ini, Section, RVINI_UNITS,             ord(Units),        ord(rvstuPixels));  
  WriteIntToIniIfNE(ini, Section, RVINI_COLOR,             Color,             clWindow);
  WriteIntToIniIfNE(ini, Section, RVINI_HOVERCOLOR,        HoverColor,        clNone);
  WriteIntToIniIfNE(ini, Section, RVINI_CURRENTITEMCOLOR,  CurrentItemColor,  clNone);
  WriteIntToIniIfNE(ini, Section, RVINI_SELCOLOR,          SelColor,          clHighlight);
  WriteIntToIniIfNE(ini, Section, RVINI_SELTEXTCOLOR,      SelTextColor,      clHighlightText);
  WriteIntToIniIfNE(ini, Section, RVINI_ISELCOLOR,         InactiveSelColor,     clHighlight);
  WriteIntToIniIfNE(ini, Section, RVINI_ISELTEXTCOLOR,     InactiveSelTextColor, clHighlightText);
  WriteIntToIniIfNE(ini, Section, RVINI_CPCOLOR,   CheckpointColor,   clGreen);
  WriteIntToIniIfNE(ini, Section, RVINI_CPEVCOLOR, CheckpointEvColor, clLime);
  WriteIntToIniIfNE(ini, Section, RVINI_PAGEBREAKCOLOR,    PageBreakColor,      clBtnShadow);
  WriteIntToIniIfNE(ini, Section, RVINI_SOFTPAGEBREAKCOLOR, SoftPageBreakColor, clBtnFace);
  WriteIntToIniIfNE(ini, Section, RVINI_LIVESPELLINGCOLOR, LiveSpellingColor, clRed);
  WriteIntToIniIfNE(ini, Section, RVINI_FLOATLINECOLOR, FloatingLineColor, DEFAULT_FLOATINGLINECOLOR);
  WriteIntToIniIfNE(ini, Section, RVINI_SPECCHARCOLOR, SpecialCharactersColor, clNone);
  WriteIntToIniIfNE(ini, Section, RVINI_JUMPCURSOR,        JumpCursor,        crJump);
  WriteBoolToIniIfNE(ini, Section, RVINI_USESOUND,         UseSound,          True);
  WriteIntToIniIfNE(ini, Section, RVINI_SELECTIONMODE,     ord(SelectionMode),  ord(rvsmWord));
  WriteIntToIniIfNE(ini, Section, RVINI_SELECTIONSTYLE,    ord(SelectionStyle), ord(rvssItems));
  WriteIntToIniIfNE(ini, Section, RVINI_SPACESINTAB,       SpacesInTab, 0);
  WriteIntToIniIfNE(ini, Section, RVINI_DEFTABWIDTH,       DefTabWidth, 48);
  WriteIntToIniIfNE(ini, Section, RVINI_SELECTIONSTYLE,    ord(SelectionStyle), ord(rvssItems));
  {$IFNDEF RVDONOTUSEUNICODE}
  WriteIntToIniIfNE(ini, Section, RVINI_DEFUNICODESTYLE,   DefUnicodeStyle,   -1);
  WriteIntToIniIfNE(ini, Section, RVINI_DEFCODEPAGE,       DefCodePage,   CP_ACP);
  {$ENDIF}
  WriteIntToIniIfNE(ini, Section, RVINI_FIELDHIGHLIGHTCOLOR, FieldHighlightColor, clBtnFace);
  WriteIntToIniIfNE(ini, Section, RVINI_DISABLEDFONTCOLOR,   DisabledFontColor, clNone);  
  WriteIntToIniIfNE(ini, Section, RVINI_FIELDHIGHLIGHTTYPE, ord(FieldHighlightType), ord(rvfhCurrent));
  WriteIntToIniIfNE(ini, Section, RVINI_FOOTNOTENUMBERING, ord(FootnoteNumbering), ord(rvseqDecimal));
  WriteIntToIniIfNE(ini, Section, RVINI_ENDNOTENUMBERING, ord(EndnoteNumbering), ord(rvseqLowerRoman));
  WriteBoolToIniIfNE(ini, Section, RVINI_FOOTNOTEPAGERESET, FootnotePageReset, True);
  WriteIntToIniIfNE(ini, Section, RVINI_LINEWRAPMODE, ord(LineWrapMode), ord(rvWrapNormal));

  ParaStyles.SaveToINI(ini, Section);
  TextStyles.SaveToINI(ini, Section);
  ListStyles.SaveToINI(ini, Section);
end;
{------------------------------------------------------------------------------}
{ Stores itself in the ini-file FileName, in the section Section. }
procedure TRVStyle.SaveINI(const FileName, Section: String);
var ini: TIniFile;
begin
  ini := TIniFile.Create(FileName);
  try
    SaveToINI(ini, Section);
  finally
    ini.Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Loads itself from the ini-file FileName, from the section Section. }
procedure TRVStyle.LoadINI(const FileName, Section: String);
var ini: TIniFile;
begin
  ini := TIniFile.Create(filename);
  try
    LoadFromINI(ini, Section);
  finally
    ini.Free;
  end;
end;
{$IFDEF RICHVIEWDEF4}
{------------------------------------------------------------------------------}
{ Loads itself from the Registry, from the key BaseKey"\RVStyle". }
procedure TRVStyle.LoadReg(const BaseKey: String);
var ini: TRegistryIniFile;
begin
  ini := TRegistryIniFile.Create(BaseKey);
  try
    LoadFromINI(ini, RVSTYLE_REG);
  finally
    ini.Free;
  end;
end;
{------------------------------------------------------------------------------}
{ Stores itself to the Registry, to the key BaseKey"\RVStyle". }
procedure TRVStyle.SaveReg(const BaseKey: String);
var ini: TRegistryIniFile;
begin
  ini := TRegistryIniFile.Create(BaseKey);
  try
    SaveToINI(ini, RVSTYLE_REG);
  finally
    ini.Free;
  end;
end;
{$ENDIF}
{$ENDIF}
{-----------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
{------------------------------------------------------------------------------}
function TRVStyle.GetCSSSize(Value: TRVStyleLength): TRVAnsiString;
var pt: Extended;
    wh, fr: Integer;
begin
  if Units=rvstuTwips then begin
    pt := GetAsPoints(Value);
    wh := Round(Int(pt));
    fr := Round(Frac(pt)*10);
    Result := RVIntToStr(wh);
    if fr<>0 then
      Result := Result+'.'+RVIntToStr(fr);
    Result := Result+'pt';
    end
  else
    Result := RVIntToStr(GetAsPixels(Value))+'px';
end;
{-----------------------------------------------------------------------}
{ Exports as CSS (Cascading Style Sheet) file. }
function TRVStyle.SaveCSS(const FileName: String;
  AOptions: TRVSaveCSSOptions): Boolean;
var Stream: TFileStream;
begin
  Result := True;
  try
    Stream := TFileStream.Create(FileName, fmCreate);
    try
      SaveCSSToStream(Stream, AOptions);
    finally
      Stream.Free;
    end;
  except
    Result := False;
  end;
end;
{-----------------------------------------------------------------------}
{ Exports as CSS (Cascading Style Sheet) to the Stream. }
procedure TRVStyle.SaveCSSToStream(Stream: TStream; AOptions: TRVSaveCSSOptions);
var i: Integer;
    s: TRVAnsiString;
    Comments: TRVRawByteString;
    BaseStyle: TFontInfo;
    BaseParaStyle: TParaInfo;
    {..................................................}
    {$IFNDEF RVDONOTUSELISTS}
    (* Reserved for future - when browser will be CSS2 compatible    
    function GetListTagSequence(ListNo, Level: Integer): String;
    var i: Integer;
    begin
      Result := Format('%s.RVLS%d',
        [ListStyles[ListNo].Levels[0].GetHTMLOpenTagForCSS, ListNo]);
      with ListStyles[ListNo] do
        for i := 1 to Level do
          Result := Result+' '+Levels[i].GetHTMLOpenTagForCSS;
    end;
    {..................................................}
    function GetListTypeStr(ListType: TRVListType; Legal: Boolean): String;
    begin
      case ListType of
        rvlstBullet, rvlstPicture, rvlstUnicodeBullet, rvlstImageList:
           Result := '';
        rvlstLowerAlpha:
           Result := 'lower-alpha';
        rvlstUpperAlpha:
           Result := 'upper-alpha';
        rvlstLowerRoman:
           Result := 'lower-roman';
         rvlstUpperRoman:
           Result := 'upper-roman';
         else
           Result := 'decimal';
      end;
      if Legal and (Result<>'') then
         Result := 'decimal';
    end;
    {..................................................}
    function GetListContentStr(ListNo, Level: Integer): String;
    var CountersVal: array [0..255] of TVarRec;
        CountersStr: array [0..255] of String;
        s: String;
        i: Integer;
        Legal: Boolean;
    begin
      for i := 0 to 255 do begin
        CountersVal[i].VAnsiString := nil;
        CountersVal[i].VType := vtAnsiString;
      end;
      Legal := rvloLegalStyleNumbering in ListStyles[ListNo].Levels[Level].Options;
      for i := 0 to Level do begin
        s := GetListTypeStr(ListStyles[ListNo].Levels[i].ListType, Legal and (i<>Level));
        if s<>'' then begin
          CountersStr[i] := Format(#1' counter(c%dl%d,%s) '#1,[ListNo,i,s]);
          CountersVal[i].VAnsiString := PChar(CountersStr[i]);
        end
      end;
      s := Format(ListStyles[ListNo].Levels[Level].FormatString, CountersVal);
      repeat
        i := Pos(#1#1, s);
        if i>0 then
          Delete(s, i, 2);
      until i = 0;
      if Length(s)>0 then begin
        if s[1]=#1 then
          Delete(s,1,1)
        else
          s := '"'+s;
        if s[Length(s)]=#1 then
          Delete(s,Length(s),1)
        else
          s := s+'"';
      end;
      for i := 1 to Length(s) do
        if s[i]=#1 then
          s[i] := '"';
      Result := s;
    end;
    {..................................................}
    function GetListContent(ListNo, Level: Integer): String;
    var LevelInfo: TRVListLevel;
    begin
      LevelInfo := ListStyles[ListNo].Levels[Level];
      case LevelInfo.ListType of
        rvlstUnicodeBullet:
          {$IFDEF RICHVIEWCBDEF3}
          Result := RVU_GetHTMLEncodedUnicode(RVU_GetRawUnicode(LevelInfo.FFormatStringW), False,False);
          {$ELSE}
          Result := LevelInfo.FFormatStringW;
          {$ENDIF}
        rvlstBullet:
          Result := LevelInfo.FFormatString;
        else
          Result := GetListContentStr(ListNo,Level);
      end;
    end;
    *)
    {$ENDIF}
    {..................................................}
begin
  RVWriteLn(Stream, '/* ========== Text Styles ========== */');
  RVWriteLn(Stream, 'hr { color: '+RV_GetHTMLRGBStr(FTextStyles[0].Color, False)+'}');
  for i:=0 to FTextStyles.Count-1 do
    with FTextStyles[i] do begin
      if (i=0) and (rvcssDefault0Style in AOptions) then
        continue;
      if Standard then
        Comments := StringToHTMLString3(Format(' /* %s */', [StyleName]),
          rvcssUTF8 in AOptions, DefCodePage)
      else
        Comments := '';
      if (i=0) and not Jump and (BackColor=clNone) and
         not (rvcssNoDefCSSStyle in AOptions) then
        RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('body, table, span.rvts0%s', [Comments]))
      else if Jump then
        RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('a.rvts%d, span.rvts%d%s',[i,i, Comments]))
      else
        RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('span.rvts%d%s', [i, Comments]));
      if (rvcssOnlyDifference in AOptions) and
        (BaseStyleNo>=0) and (BaseStyleNo<TextStyles.Count) then
        BaseStyle := TextStyles[BaseStyleNo]
      else begin
        BaseStyle := nil;
        if (i>0) and not TextStyles[0].Jump and
           (TextStyles[0].BackColor=clNone) and
           not (rvcssNoDefCSSStyle in AOptions) then
          BaseStyle := TextStyles[0];
      end;
      RVWriteLn(Stream, '{');
      SaveCSSToStream(Stream, BaseStyle, True, rvcssUTF8 in AOptions);
      RVWriteLn(Stream, '}');
      if Jump and
        ((GetHoverColorByColor(HoverColor)<>clNone) or
         (HoverBackColor<>clNone) or
         (HoverEffects<>[])) then begin
        RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('a.rvts%d:hover {', [i]));
        if (((BaseStyle=nil) or not BaseStyle.Jump) and (GetHoverColorByColor(HoverColor)<>clNone)) or
           ((BaseStyle<>nil) and (GetHoverColorByColor(HoverColor)<>GetHoverColorByColor(BaseStyle.HoverColor))) then
          RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
            Format(' color: %s;', [RV_GetHTMLRGBStr(GetHoverColorByColor(HoverColor), False)]));
        if (((BaseStyle=nil) or not BaseStyle.Jump)  and (HoverBackColor<>clNone)) or
           ((BaseStyle<>nil) and (HoverBackColor<>BaseStyle.HoverBackColor)) then
          RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
            Format(' background-color: %s;', [RV_GetHTMLRGBStr(HoverBackColor, False)]));
        if (((BaseStyle=nil) or not BaseStyle.Jump)  and (rvheUnderline in HoverEffects)) or
           ((BaseStyle<>nil) and ((rvheUnderline in HoverEffects)<>(rvheUnderline in BaseStyle.HoverEffects))) then begin
          s := GetTextDecoration(FTextStyles[i], True);
          if s<>'' then
            RVWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
              Format(' text-decoration: %s;', [s]));
        end;
        if ((rvheUnderline in HoverEffects) or (fsUnderline in Style)) and
           (HoverUnderlineColor<>clNone) then begin
          s := GetCustomUnderlineCSS(FTextStyles[i], True);
          if s<>'' then
            RVWrite(Stream, ' '+s+';');
        end;
        RVWriteLn(Stream, ' }');
      end;
    end;
  RVWriteLn(Stream, '/* ========== Para Styles ========== */');
  for i:=0 to FParaStyles.Count-1 do
    with FParaStyles[i] do begin
      if Standard then
        Comments := StringToHTMLString3(Format(' /* %s */', [StyleName]),
          rvcssUTF8 in AOptions, DefCodePage)
      else
        Comments := '';
      if (i=0) and not (rvcssNoDefCSSStyle in AOptions) then
        RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('p,ul,ol%s',[Comments]))
      else
        RVWriteLn(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}
          Format('.rvps%d%s',[i,Comments]));
      if (rvcssOnlyDifference in AOptions) and
        (BaseStyleNo>=0) and (BaseStyleNo<ParaStyles.Count) then
        BaseParaStyle := ParaStyles[BaseStyleNo]
      else begin
        if (i>0) and not (rvcssNoDefCSSStyle in AOptions) then
          BaseParaStyle := ParaStyles[0]
        else
          BaseParaStyle := nil;
      end;
      if (OutlineLevel>=1) and (OutlineLevel<=6) then
        BaseParaStyle := nil;
      RVWriteLn(Stream, '{');
      SaveCSSToStream(Stream, BaseParaStyle, True,
        rvcssIgnoreLeftAlignment in AOptions, False);
      RVWriteLn(Stream, '}');
    end;
  {$IFNDEF RVDONOTUSELISTS}
  (*
  RVWriteLn(Stream, '/*----------List Styles----------*/');
  for i:=0 to FListStyles.Count-1 do
    for j:=0 to FListStyles[i].Levels.Count-1 do
      with FListStyles[i].Levels[j] do begin
        s := GetListTagSequence(i,j);
        if j=0 then
          descr := Format('/* %s */ ',[FListStyles[i].StyleName])
        else
          descr := '';
        if MarkerIndent>=LeftIndent then
          s2 := Format('text-indent: %dpx !important; margin-left !important: %d; list-style:inside;',
            [MarkerIndent-LeftIndent, LeftIndent])
        else
          s2 := Format('text-indent: %dpx !important; margin-left: %d !important; list-style:outside;',
            [FirstIndent, LeftIndent]);
        RVWriteLn(Stream, Format('%s %s{ %s }', [s, descr, s2]));
      end;
  *)
  (*
  RVWriteLn(Stream, '/*----------List Styles----------*/');
  for i:=0 to FListStyles.Count-1 do
    for j:=0 to FListStyles[i].Levels.Count-1 do
      with FListStyles[i].Levels[j] do begin
        s := GetListTagSequence(i,j);
        if j=0 then
          descr := Format('/* %s */ ',[FListStyles[i].StyleName])
        else
          descr := '';
        if HasNumbering then begin
          if (rvloLevelReset in Options) then begin
            RVWriteLn(Stream, Format('%s %s{ counter-reset: c%dl%d; }', [s, descr, i,j]));
            descr := '';
          end;
          RVWriteLn(Stream, Format('%s > LI %s{ counter-increment: c%dl%d; }', [s, descr, i,j]));
          descr := '';
        end;
        RVWriteLn(Stream, Format('%s > LI:before %s{ content:%s }', [s, descr, GetListContent(i,j)]));
      end;
  *)
  {$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{ Adjusting link when removing linked components. }
procedure TRVStyle.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation=opRemove) and (AComponent is TCustomImageList) then
    FListStyles.RemoveImageList(TCustomImageList(AComponent));
end;
{------------------------------------------------------------------------------}
procedure TRVStyle.Loaded;
begin
  inherited Loaded;
  {$IFNDEF RVDONOTUSESTYLETEMPLATES}
  StyleTemplates.UpdateParentReferences;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
{ READ method for InvalidPicture property. }
function TRVStyle.GetInvalidPicture: TPicture;
begin
  if FInvalidPicture=nil then begin
    FInvalidPicture := TPicture.Create;
    FInvalidPicture.Bitmap.Handle := LoadBitmap(hInstance, 'RV_BAD_PICTURE');
  end;
  Result := FInvalidPicture;
end;
{------------------------------------------------------------------------------}
{ Write method for InvalidPicture property. }
procedure TRVStyle.SetInvalidPicture(const Value: TPicture);
begin
  if Value=nil then begin
    FInvalidPicture.Free;
    FInvalidPicture := nil;
    exit;
  end;
  if FInvalidPicture=Value then
    exit;
  if FInvalidPicture=nil then
    FInvalidPicture := TPicture.Create;
  FInvalidPicture.Assign(Value);
end;
{------------------------------------------------------------------------------}
{ Returns the next tabstop after X. X is measured from the very left
  of document, including the left margin. All values are in pixels.
  The following values are returned: Position (from the very left), Align, Leader.
  LeftIndent and RightIndent are values of LeftIndent and RightIndent. They are
  in the target device resolution. sad specifies the resolution of target device.
  DefBiDiMode - bi-di mode of document (some corrections are done for RTL paragraphs).
  How it works:
  - first it searches in ParaStyles[ParaNo].Tabs[].Positions; LeftIndent is also
    treated as a tabstop (RightIndent for RTL paragraphs).
  - if not found, it calculates position using DefTabWidth property.
}
procedure TRVStyle.GetNextTab(ParaNo, X: Integer; sad: TRVScreenAndDevice;
  var Position: Integer; var Leader: String; var Align: TRVTabAlign;
  DefBiDiMode: TRVBiDiMode; LeftIndent, RightIndent: Integer);
var
    {$IFNDEF RVDONOTUSETABS}
    Tabs: TRVTabInfos;
    Pos, Indent, i: Integer;
    Found: Boolean;
    {$ENDIF}
    dtw: Integer;
begin
  if DefBiDiMode=rvbdUnspecified then
    DefBiDiMode := ParaStyles[ParaNo].BiDiMode;
  dec(X, sad.LeftMargin);
  if (DefBiDiMode=rvbdRightToLeft) then begin
    inc(X,RightIndent);
    dec(X,LeftIndent);
    {$IFNDEF RVDONOTUSETABS}
    Indent := RightIndent;
    {$ENDIF}
    end
   {$IFNDEF RVDONOTUSETABS}
  else
    Indent := LeftIndent
   {$ENDIF};
  {$IFNDEF RVDONOTUSETABS}
  Tabs := ParaStyles[ParaNo].Tabs;
  for i := 0 to Tabs.Count-1 do begin
    Found := False;
    Pos := GetAsDevicePixelsX(Tabs[i].Position, @sad);
    if (Indent>X) and (Indent<Pos) then begin
      Found := True;
      Position := Indent+sad.LeftMargin;
      Leader := '';
      Align := rvtaLeft;
      end
    else if Pos>X then begin
      Found := True;
      Position := Pos+sad.LeftMargin;
      Leader := Tabs[i].Leader;
      Align := Tabs[i].Align;
    end;
    if Found then begin
      if DefBiDiMode=rvbdRightToLeft then begin
        dec(Position,RightIndent);
        inc(Position,LeftIndent);
      end;
      exit;
    end;
  end;
  if (Indent>X) and
     ((Tabs.Count=0) or (Indent>GetAsDevicePixelsX(Tabs[Tabs.Count-1].Position, @sad))) then begin
    Position := Indent+sad.LeftMargin;
    Leader := '';
    Align := rvtaLeft;
    if (DefBiDiMode=rvbdRightToLeft) then begin
      dec(Position,RightIndent);
      inc(Position,LeftIndent);
    end;
    exit;
  end;
  {$ENDIF}
  dtw := GetAsDevicePixelsX(DefTabWidth, @sad);
  if dtw<=0 then
    dtw := 1;
  Position := ((X+dtw) div dtw)*dtw+sad.LeftMargin;
  if  (DefBiDiMode=rvbdRightToLeft) then begin
    dec(Position,RightIndent);
    inc(Position,LeftIndent);
  end;
  Align := rvtaLeft;
  Leader := '';
end;
{-----------------------------------------------------------------------}
procedure TRVStyle.CreateGraphicInterface;
begin
  if FGraphicInterface=nil then
    FGraphicInterface := TRVWinGraphicInterface.Create;
end;
{-----------------------------------------------------------------------}
// Converts Value from Units to pixels
function TRVStyle.GetAsPixels(Value: TRVStyleLength): Integer;
begin
  if FUnits=rvstuPixels then
    Result := Value
  else begin
   if RichViewPixelsPerInch>0 then
     Result := Round(Value / 1440 * RichViewPixelsPerInch)
   else
     Result := Round(Value / 1440 * Screen.PixelsPerInch);
   if Result=0 then
     if Value>0 then
       Result := 1
     else if Value<0 then
       Result := -1;
  end;
end;
{-----------------------------------------------------------------------}
// The same, but Units is the parameter 
class function TRVStyle.GetAsPixelsEx(Value: TRVStyleLength; Units: TRVStyleUnits): Integer;
begin
  if Units=rvstuPixels then
    Result := Value
  else begin
   if RichViewPixelsPerInch>0 then
     Result := Round(Value / 1440 * RichViewPixelsPerInch)
   else
     Result := Round(Value / 1440 * Screen.PixelsPerInch);
   if Result=0 then
     if Value>0 then
       Result := 1
     else if Value<0 then
       Result := -1;
  end;
end;
// Converts Value (measured in Units) to twips
{-----------------------------------------------------------------------}
// Converts Value from Units to device pixels, horizontal
function TRVStyle.GetAsDevicePixelsX(Value: TRVStyleLength; PSaD: PRVScreenAndDevice): Integer;
begin
  if PSaD=nil then
    Result := GetAsPixels(Value)
  else if FUnits=rvstuPixels then
    Result := Round(Value / PSaD.ppixScreen * PSaD.ppixDevice)
  else begin
    Result := Round(Value / 1440 * PSaD.ppixDevice);
    if Result=0 then
      if Value>0 then
        Result := 1
      else if Value<0 then
        Result := -1;
  end;
end;
{-----------------------------------------------------------------------}
// Converts to Value from Units to device pixels, vertical
function TRVStyle.GetAsDevicePixelsY(Value: TRVStyleLength; PSaD: PRVScreenAndDevice): Integer;
begin
  if PSaD=nil then
    Result := GetAsPixels(Value)
  else if FUnits=rvstuPixels then
    Result := Round(Value / PSaD.ppiyScreen * PSaD.ppiyDevice)
  else begin
    Result := Round(Value / 1440 * PSaD.ppiyDevice);
    if Result=0 then
      if Value>0 then
        Result := 1
      else if Value<0 then
        Result := -1;
  end;
end;
{-----------------------------------------------------------------------}
// Converts Value from Units to twips
function TRVStyle.GetAsTwips(Value: TRVStyleLength): Integer;
begin
  if FUnits=rvstuTwips then
    Result := Value
  else if RichViewPixelsPerInch>0 then
    Result := Round(Value / RichViewPixelsPerInch * 1440)
  else
    Result := Round(Value / Screen.PixelsPerInch * 1440)
end;
{-----------------------------------------------------------------------}
// The same, but units is the parameter
class function TRVStyle.GetAsTwipsEx(Value: TRVStyleLength; Units: TRVStyleUnits): Integer;
begin
  if Units=rvstuTwips then
    Result := Value
  else if RichViewPixelsPerInch>0 then
    Result := Round(Value / RichViewPixelsPerInch * 1440)
  else
    Result := Round(Value / Screen.PixelsPerInch * 1440)
end;
{-----------------------------------------------------------------------}
// If Self is defined, converts Value from Self.Units to Units.
// If Self is nil, converts from pixels/twips to opposite units.
function TRVStyle.GetAsDifferentUnits(Value: TRVStyleLength; Units: TRVStyleUnits): TRVStyleLength;
begin
  if Self<>nil then
    if Units=rvstuPixels then
      Result := GetAsPixels(Value)
    else
      Result := GetAsTwips(Value)
  else
    if Units=rvstuPixels then
      Result := TRVStyle.TwipsToPixels(Value)
    else
      Result := TRVStyle.PixelsToTwips(Value)
end;
{-----------------------------------------------------------------------}
// Convert value from Units to Self.Units
function TRVStyle.DifferentUnitsToUnits(Value: TRVStyleLength; Units: TRVStyleUnits): TRVStyleLength;
begin
  if Units=rvstuPixels then
    Result := PixelsToUnits(Value)
  else
    Result := TwipsToUnits(Value)
end;
{-----------------------------------------------------------------------}
// Converts Value from Units to points
function TRVStyle.GetAsPoints(Value: TRVStyleLength): Extended;
begin
  if FUnits=rvstuTwips then
    Result := Value / 20
  else if RichViewPixelsPerInch>0 then
    Result := Value / RichViewPixelsPerInch * 72
  else
    Result := Value / Screen.PixelsPerInch * 72
end;
{-----------------------------------------------------------------------}
// Converts Value from Twips to Units
function TRVStyle.TwipsToUnits(Value: Integer): TRVStyleLength;
begin
  if FUnits=rvstuTwips then
    Result := Value
  else begin
    if RichViewPixelsPerInch>0 then
      Result := Round(Value / 1440 * RichViewPixelsPerInch)
    else
      Result := Round(Value / 1440 * Screen.PixelsPerInch);
    if Result=0 then
      if Value>0 then
        Result := 1
      else if Value<0 then
        Result := -1;
  end;
end;
{-----------------------------------------------------------------------}
// The same, but Units is in the parameter
class function TRVStyle.TwipsToUnitsEx(Value: Integer; Units: TRVStyleUnits): TRVStyleLength;
begin
  if Units=rvstuTwips then
    Result := Value
  else begin
    if RichViewPixelsPerInch>0 then
      Result := Round(Value / 1440 * RichViewPixelsPerInch)
    else
      Result := Round(Value / 1440 * Screen.PixelsPerInch);
    if Result=0 then
      if Value>0 then
        Result := 1
      else if Value<0 then
        Result := -1;
  end;
end;
{-----------------------------------------------------------------------}
// Converts Value from Pixels to Units
function TRVStyle.PixelsToUnits(Value: Integer): TRVStyleLength;
begin
  if FUnits=rvstuPixels then
    Result := Value
  else if RichViewPixelsPerInch>0 then
    Result := Round(Value / RichViewPixelsPerInch * 1440)
  else
    Result := Round(Value / Screen.PixelsPerInch * 1440)
end;
{-----------------------------------------------------------------------}
// The same, but Units is in the parameter
class function TRVStyle.PixelsToUnitsEx(Value: Integer; Units: TRVStyleUnits): TRVStyleLength;
begin
  if Units=rvstuPixels then
    Result := Value
  else if RichViewPixelsPerInch>0 then
    Result := Round(Value / RichViewPixelsPerInch * 1440)
  else
    Result := Round(Value / Screen.PixelsPerInch * 1440)
end;
{-----------------------------------------------------------------------}
// Converts Value from Pixels to Twips
class function TRVStyle.PixelsToTwips(Value: Integer): Integer;
begin
  if RichViewPixelsPerInch>0 then
    Result := Round(Value / RichViewPixelsPerInch * 1440)
  else
    Result := Round(Value / Screen.PixelsPerInch * 1440)
end;
{-----------------------------------------------------------------------}
// Converts Value from Twips to Pixels
class function TRVStyle.TwipsToPixels(Value: Integer): Integer;
begin
  if RichViewPixelsPerInch>0 then
    Result := Round(Value / 1440 * RichViewPixelsPerInch)
  else
    Result := Round(Value / 1440 * Screen.PixelsPerInch);
  if Result=0 then
    if Value>0 then
      Result := 1
    else if Value<0 then
      Result := -1;
end;
{-----------------------------------------------------------------------}
// Converts Value from Units to RVUnits
function TRVStyle.GetAsRVUnits(Value: TRVStyleLength; RVUnits: TRVUnits): TRVLength;
begin
  if (Units=rvstuPixels) and (RVUnits=rvuPixels) then
    Result := Value
  else
    Result := RV_TwipsToUnits(GetAsTwips(Value), RVUnits);
end;
{-----------------------------------------------------------------------}
// The same, but units is in the parameter
class function TRVStyle.GetAsRVUnitsEx(Value: TRVStyleLength; Units: TRVStyleUnits;
  RVUnits: TRVUnits): TRVLength;
begin
  if (Units=rvstuPixels) and (RVUnits=rvuPixels) then
    Result := Value
  else
    Result := RV_TwipsToUnits(GetAsTwipsEx(Value, Units), RVUnits);
end;
{-----------------------------------------------------------------------}
// Converts Value from RVUnits to Units
function TRVStyle.RVUnitsToUnits(Value: TRVLength; RVUnits: TRVUnits): TRVStyleLength;
begin
  if (Units=rvstuPixels) and (RVUnits=rvuPixels) then
    Result := Round(Value)
  else
    Result := TwipsToUnits(RV_UnitsToTwips(Value, RVUnits));
end;
{-----------------------------------------------------------------------}
// The same, but Units is in the parameter
class function TRVStyle.RVUnitsToUnitsEx(Value: TRVLength; RVUnits: TRVUnits;
  Units: TRVStyleUnits): TRVStyleLength;
begin
  if (Units=rvstuPixels) and (RVUnits=rvuPixels) then
    Result := Round(Value)
  else
    Result := TwipsToUnitsEx(RV_UnitsToTwips(Value, RVUnits), Units);
end;
{-----------------------------------------------------------------------}
// Converts Value from RVUnits to pixels
class function TRVStyle.RVUnitsToPixels(Value: TRVLength; RVUnits: TRVUnits): Integer;
begin
  if RVUnits=rvuPixels then
    Result := Round(Value)
  else
    Result := TwipsToPixels(RV_UnitsToTwips(Value, RVUnits));
end;
{-----------------------------------------------------------------------}
// Converts Value from pixels to RVUnits
class function TRVStyle.PixelsToRVUnits(Value: Integer; RVUnits: TRVUnits): TRVLength;
begin
  if RVUnits=rvuPixels then
    Result := Value
  else
    Result := RV_TwipsToUnits(PixelsToTwips(Value), RVUnits);
end;
{-----------------------------------------------------------------------}
// Converts (changes values of) all RVStyle properties from Units to NewUnits.
// After the conversion, assign Units := NewUnits.
procedure TRVStyle.ConvertToDifferentUnits(NewUnits: TRVStyleUnits);
begin
  if Units = NewUnits then
    exit;
  DefTabWidth := GetAsDifferentUnits(DefTabWidth, NewUnits);
  if TextStyles.FInvalidItem<>nil then
    TextStyles.FInvalidItem.ConvertToDifferentUnits(NewUnits);
  if ParaStyles.FInvalidItem<>nil then
    ParaStyles.FInvalidItem.ConvertToDifferentUnits(NewUnits);
  TextStyles.ConvertToDifferentUnits(NewUnits);
  ParaStyles.ConvertToDifferentUnits(NewUnits);
  ListStyles.ConvertToDifferentUnits(NewUnits);
  Units := NewUnits
end;
{-----------------------------------------------------------------------}
procedure TRVStyle.ConvertToTwips;
begin
  ConvertToDifferentUnits(rvstuTwips);
end;
{-----------------------------------------------------------------------}
procedure TRVStyle.ConvertToPixels;
begin
  ConvertToDifferentUnits(rvstuPixels);
end;
{==============================================================================}
{ Writes s to Stream. }
procedure RVWrite(Stream: TStream; const s: TRVAnsiString);
begin
  Stream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
end;
{-----------------------------------------------------------------------}
{ Writes s+line break to Stream }
procedure RVWriteLn(Stream: TStream; const s: TRVAnsiString);
var crlf: TRVAnsiString;
begin
  Stream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
  crlf := #13#10;
  Stream.WriteBuffer(PRVAnsiChar(crlf)^, 2);
end;
{-----------------------------------------------------------------------}
{ Writes s to Stream. If Multiline, writes line break after it. }
procedure RVWriteX(Stream: TStream; const s: TRVAnsiString; Multiline: Boolean);
var crlf: TRVAnsiString;
begin
  Stream.WriteBuffer(PRVAnsiChar(s)^, Length(s));
  if Multiline then begin
    crlf := #13#10;
    Stream.WriteBuffer(PRVAnsiChar(crlf)^, 2);
  end;
end;

end.