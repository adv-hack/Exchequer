
{*******************************************************}
{                                                       }
{       RichView                                        }
{       TRVRTFReaderProperties:                         }
{       - property of TRichView                         }
{         (RichView.RTFReadProperties)                  }
{       - intermediate class between RichView and       }
{         RTF parser (TRVRTFReader)                     }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVRTFProps;

interface
{$I RV_Defs.inc}
uses {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Windows, Classes, Forms, Math,
     {$IFNDEF RVDONOTUSERTFIMPORT}
     RVRTF,
     {$ENDIF}
     {$IFNDEF RVDONOTUSELISTS}
     RVMarker,
     {$ENDIF}
     {$IFNDEF RVDONOTUSEDOCPARAMS}
     RVDocParams, Printers,
     {$ENDIF}     
     {$IFNDEF RVDONOTUSEOLECONTAINER}
     (*
     OleCtnrs, ActiveX, ComObj,
     *)
     {$ENDIF}
     RVScroll, CRVData, CRVFData, RVStyle, Graphics, RVRTFErr, RVUni, RVItem,
     RVMapWht, RVFuncs,
     RVClasses, RVTypes;

{$IFNDEF RICHVIEWCBDEF3}
{$DEFINE RVDONOTUSEUNICODE}
{$ENDIF}
{$IFDEF RVDONOTUSERVF}
{$DEFINE RVDONOTUSETABLES}
{$ENDIF}

const
  RV_TableGridEps: Integer = 1;

type

  TRVAllowUseStyleEvent = procedure (StyleNo: Integer; TextStyle: Boolean;
                                     var Allow: Boolean) of object;
  {$IFNDEF RVDONOTUSERTFIMPORT}
  TRVCustomImageItemEvent = procedure (RVData: TCustomRVData;
    Graphic: TGraphic; Hypertext: Boolean; var item: TCustomRVItemInfo;
    var FreeGraphic: Boolean; RTFPicture: TRVRTFPicture;
    const FileName: String;
    var  Name: TRVRawByteString) of object;

  TRVRTFReaderClass = class of TRVRTFReader;    
  {$ENDIF}

  TRVRTFReaderProperties = class (TPersistent)
    private
      FUnicodeMode: TRVReaderUnicode;
      FTextStyleMode: TRVReaderStyleMode;
      FParaStyleMode: TRVReaderStyleMode;
      FIgnorePictures, FIgnoreTables, FIgnoreBookmarks,
      FIgnoreNotes, FIgnoreSequences: Boolean;
      FUseHypertextStyles: Boolean;
      FParaNo: Integer;
      FStyleNo: Integer;
      //FAdjustVisibleBorders: Boolean;
      FExplicitTableWidth: Boolean;
      FSkipHiddenText: Boolean;
      FHideTableGridLines: Boolean;
      FLineBreaksAsParagraphs: Boolean;
      FHeaderRVData, FFooterRVData: TCustomRVData;
      {$IFNDEF RVDONOTUSERTFIMPORT}
      FBookmarkName: String;
      FEmptyPara: Integer;
      RVData, CurrentRVData: TCustomRVData;
      RVStyle: TRVStyle;
      PageBreak: Boolean;
      PageBreakRVData: TCustomRVData;
      PixelsPerTwip: Double;
      Reader: TRVRTFReader;
      FirstTime: Boolean;
      {$IFDEF RICHVIEWCBDEF3}
      FUseCharsetForUnicode: Boolean;
      FCharsetForUnicode: TFontCharset;
      {$ENDIF}
      {$IFDEF RVRECHECKRTFPARA}
      FFirstParaInserted: Boolean;
      {$ENDIF}
      InsertPoint, CurrentRow, CurrentCol: Integer;
      SubDataList: TRVList;
      FHeaderYMM, FFooterYMM: Integer;
      FConvertHighlight: TRVRTFHighlight;
      HFType: TRVRTFHeaderFooterType;
      FBasePath: String;
      FExtractMetafileBitmaps, FBasePathLinks, FUseSingleCellPadding: Boolean;
      {$IFNDEF RVDONOTUSELISTS}
      IgnoreLists: Boolean;
      LastMarkerIndex: Integer;
      IsLastMarkerWord97: Boolean;
      LevelToListNo: TRVIntegerList;
      ListTableMap97: TRVIntegerList;
      ListStylesCountBefore: Integer;
      {$ENDIF}
      {$IFNDEF RVDONOTUSESEQ}
      LastNoteRefIndex: Integer;
      {$ENDIF}
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      FReadDocParameters: Boolean;
      {$ENDIF}
      FStoreImagesFileNames: Boolean;
      procedure InitReader;
      procedure DoneReader;
      function ReturnParaNo(Position: TRVRTFPosition): Integer;
      function CreateTextItem(const Text: TRVAnsiString;
        {$IFDEF RICHVIEWCBDEF3}const WideText: WideString;{$ENDIF}
        StyleNo, ParaNo: Integer; UseUnicode: Boolean;
        var ResText: TRVRawByteString): TRVTextItemInfo;
      {$IFNDEF RVDONOTUSELISTS}
      function GetMarkerIndex(RTFMarker: TRVRTFMarkerProperties): Integer;
      function InsertMarker(ParaNo: Integer): Boolean;
      function InsertMarker97(ParaNo: Integer): Boolean;
      procedure ReaderUpdateMarker(Sender: TObject);
      procedure CopyListLevel97(RVLevel : TRVListLevel; RTFLevel: TRVRTFListLevel97);
      procedure MergeListTable97;
      function AreListStylesEqual97(RVList: TRVListInfo;
        RTFList: TRVRTFList97): Boolean;
      function FindListStyle97(RTFList: TRVRTFList97;
        ForbiddenStyles: TRVIntegerList): Integer;
      {$ENDIF}
      procedure InsertItem(var Text: TRVRawByteString; item: TCustomRVItemInfo;
        Position: TRVRTFPosition);
      procedure CurrentBorder(var RVBorderStyle: TRVBorderStyle;
        var RVBorderWidth, RVBorderIntWidth: TRVStyleLength; var RVBorderColor: TColor;
        var RVBorderOffs: TRVRect);
      function FindParaNo(RVBorderStyle: TRVBorderStyle;
        RVBorderWidth, RVBorderIntWidth: Integer; RVBorderColor: TColor;
        RVBorderOffs: TRVRect): Integer;
      {$IFNDEF RVDONOTUSETABLES}
      function GetEmptyParaNo(Alignment: TRVAlignment; LeftIndentTw: Integer): Integer;
      function GetEmptyStyleNo: Integer;
      {$ENDIF}
      function FindBestParaNo: Integer;
      function FindStyleNo(AUnicode, AHypertext, SwitchProtect: Boolean): Integer;
      function FindBestStyleNo(AUnicode, AHypertext, ASwitchProtect: Boolean): Integer;
      procedure AddPara(RVBorderStyle: TRVBorderStyle;
        RVBorderWidth, RVBorderIntWidth: TRVStyleLength; RVBorderColor: TColor;
        RVBorderOffs: TRVRect);
      procedure AddStyle(AUnicode, AHypertext, ASwitchProtect: Boolean);
      function ReturnParaNo_: Integer;
      function ReturnStyleNo(AUnicode, ASwitchProtect: Boolean): Integer;
      function IsHypertext_: Boolean;
      function IsHypertext(var Target, Hint, Extras: String): Boolean;
      function AllowUseStyle(StyleNo: Integer; TextStyle: Boolean): Boolean;
      {$ENDIF}
      procedure SetParaNo(const Value: Integer);
      procedure SetStyleNo(const Value: Integer);
      procedure SetHideTableGridLines(const Value: Boolean);
      procedure SetIgnoreBookmarks(const Value: Boolean);
      procedure SetIgnoreNotes(const Value: Boolean);
      procedure SetIgnorePictures(const Value: Boolean);
      procedure SetIgnoreSequences(const Value: Boolean);
      procedure SetIgnoreTables(const Value: Boolean);
      procedure SetLineBreaksAsParagraphs(const Value: Boolean);
      procedure SetParaStyleMode(const Value: TRVReaderStyleMode);
      {$IFNDEF RVDONOTUSERTFIMPORT}
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      procedure SetReadDocParameters(const Value: Boolean);
      {$ENDIF}
      procedure SetUseSingleCellPadding(const Value: Boolean);
      procedure SetExtractMetafileBitmaps(const Value: Boolean);
      procedure SetConvertHighlight(const Value: TRVRTFHighlight);
      procedure SetStoreImagesFileNames(const Value: Boolean);
      procedure SetBasePathLinks(const Value: Boolean);
      {$IFDEF RICHVIEWCBDEF3}
      procedure SetCharsetForUnicode(const Value: TFontCharset);
      procedure SetUseCharsetForUnicode(const Value: Boolean);
      {$ENDIF}
      {$ENDIF}
      procedure SetSkipHiddenText(const Value: Boolean);
      procedure SetTextStyleMode(const Value: TRVReaderStyleMode);
      procedure SetUnicodeMode(const Value: TRVReaderUnicode);
      procedure SetUseHypertextStyles(const Value: Boolean);
    protected
      {$IFNDEF RVDONOTUSERTFIMPORT}
      procedure ReaderProgress(Sender: TRVRTFReader; Stage: TRVRTFProgressStage;
        PercentDone: Byte);
      procedure NewReaderText(Sender: TRVRTFReader; const Text: TRVAnsiString;
        Position: TRVRTFPosition);
      {$IFNDEF RVDONOTUSESEQ}
      procedure NewReaderSeq(Sender: TRVRTFReader;Position: TRVRTFPosition;
        const SeqName: String; NumberingType: TRVRTFSeqType;
        Reset: Boolean; StartFrom: Integer);
      procedure ReaderNote(Sender: TRVRTFReader; What: TRVRTFNoteEventType;
        Position: TRVRTFPosition);
      {$ENDIF}
      procedure ReaderEndParsing(Sender: TObject);
      {$IFDEF RICHVIEWCBDEF3}
      procedure NewReaderUnicodeText(Sender: TRVRTFReader;
        const Text: TRVUnicodeString; Position: TRVRTFPosition);
      {$ENDIF}
      procedure NewReaderPicture(Sender: TRVRTFReader; RTFPicture: TRVRTFPicture;
        Graphic: TGraphic; Position: TRVRTFPosition; const FileName: String;
        var Inserted: Boolean);
      procedure ReaderImportPicture(Sender: TRVRTFReader; const Location: String;
        var Graphic: TGraphic; var Invalid: Boolean);
      {$IFNDEF RVDONOTUSEOLECONTAINER}
      (*
      procedure NewReaderObject(Sender: TRVRTFReader; RTFObject: TRVRTFObject;
        Position: TRVRTFPosition; var Inserted: Boolean);
      *)
      {$ENDIF}
      {$IFNDEF RVDONOTUSETABLES}
      procedure AssignRowProperties;
      procedure ReaderTable(Sender: TRVRTFReader;
        WhatHappens: TRVRTFTableEventKind; var Processed: Boolean);
      {$ENDIF}
      procedure ReaderPageBreak(Sender: TObject);
      procedure ReaderHeaderFooter(Sender: TRVRTFReader; HFType: TRVRTFHeaderFooterType;
        Starting: Boolean; var Supported: Boolean);
      procedure ReaderBookmarkStart(Sender: TRVRTFReader;
        const BookmarkName: String);
      procedure ReaderTranslateKeyword(Sender: TRVRTFReader; const Keyword: TRVAnsiString;
        Param: integer; fParam: boolean; var Text: TRVAnsiString; var DoDefault: Boolean); dynamic;
      {$ENDIF}
      procedure Changed; virtual;
    public
      EditFlag: Boolean;
      ErrorCode: TRVRTFErrorCode;
      FailedBecauseOfProtect, FullReformat: Boolean;
      NonFirstItemsAdded: Integer;
      AllowNewPara: Boolean;
      OnAllowUseStyle:   TRVAllowUseStyleEvent;
      {$IFNDEF RVDONOTUSERTFIMPORT}
      OnCustomImageItem: TRVCustomImageItemEvent;
      {$ENDIF}
      Index: Integer;
      constructor Create;
      procedure Assign(Source: TPersistent); override;
      function ReadFromFile(const AFileName: String; ARVData: TCustomRVData): TRVRTFErrorCode;
      {$IFDEF RVUSEWORDDOC}
      function ReadFromWordDocFile(const AFileName: String; ARVData: TCustomRVData): TRVRTFErrorCode;
      {$ENDIF}
      function ReadFromStream(AStream: TStream; ARVData: TCustomRVData): TRVRTFErrorCode;
      function InsertFromStreamEd(AStream: TStream; ARVData: TCustomRVData; var AIndex: Integer): TRVRTFErrorCode;
      //property AdjustVisibleBorders: Boolean read FAdjustVisibleBorders write FAdjustVisibleBorders;
      property ExplicitTableWidth: Boolean read FExplicitTableWidth write FExplicitTableWidth default False;
      {$IFNDEF RVDONOTUSERTFIMPORT}
      function GetRVRTFReaderClass: TRVRTFReaderClass; virtual;
      procedure SetHeader(RVData: TCustomRVData);
      procedure SetFooter(RVData: TCustomRVData);
      property HeaderYMM: Integer read FHeaderYMM;
      property FooterYMM: Integer read FFooterYMM;
      property BasePath: String read FBasePath write FBasePath;
      property RTFReader: TRVRTFReader read Reader;
      {$ENDIF}
      property HeaderRVData: TCustomRVData read FHeaderRVData;
      property FooterRVData: TCustomRVData read FFooterRVData;      
    published
      property UnicodeMode: TRVReaderUnicode read FUnicodeMode write SetUnicodeMode
        default {$IFDEF RVUNICODEWINDOW}rvruOnlyUnicode{$ELSE}rvruNoUnicode{$ENDIF};
      property TextStyleMode: TRVReaderStyleMode read FTextStyleMode write SetTextStyleMode default rvrsUseClosest;
      property ParaStyleMode: TRVReaderStyleMode read FParaStyleMode write SetParaStyleMode default rvrsUseClosest;
      property IgnorePictures: Boolean read FIgnorePictures write SetIgnorePictures default False;
      property IgnoreNotes: Boolean read FIgnoreNotes write SetIgnoreNotes default False;
      property IgnoreSequences: Boolean read FIgnoreSequences write SetIgnoreSequences default False;
      property IgnoreTables: Boolean read FIgnoreTables write SetIgnoreTables default False;
      property IgnoreBookmarks: Boolean read FIgnoreBookmarks write SetIgnoreBookmarks default False;
      property UseHypertextStyles: Boolean read FUseHypertextStyles write SetUseHypertextStyles default False;
      property TextStyleNo: Integer read FStyleNo write SetStyleNo default 0;
      property ParaStyleNo: Integer read FParaNo write SetParaNo default 0;
      property SkipHiddenText: Boolean read FSkipHiddenText write SetSkipHiddenText default True;
      property AutoHideTableGridLines: Boolean read FHideTableGridLines write SetHideTableGridLines default False;
      property LineBreaksAsParagraphs: Boolean read FLineBreaksAsParagraphs write SetLineBreaksAsParagraphs default False;
      {$IFNDEF RVDONOTUSERTFIMPORT}
      {$IFNDEF RVDONOTUSEDOCPARAMS}
      property ReadDocParameters: Boolean read FReadDocParameters write SetReadDocParameters default False;
      {$ENDIF}
      property UseSingleCellPadding: Boolean read FUseSingleCellPadding write SetUseSingleCellPadding default False;
      property ExtractMetafileBitmaps: Boolean read FExtractMetafileBitmaps write SetExtractMetafileBitmaps default True;
      property ConvertHighlight: TRVRTFHighlight read FConvertHighlight write SetConvertHighlight default rtfhlColorTable;
      property StoreImagesFileNames: Boolean read FStoreImagesFileNames write SetStoreImagesFileNames default False;
      property BasePathLinks: Boolean read FBasePathLinks write SetBasePathLinks default True;
      {$IFDEF RICHVIEWCBDEF3}
      property UseCharsetForUnicode: Boolean read FUseCharsetForUnicode write SetUseCharsetForUnicode default False;
      property CharsetForUnicode: TFontCharset read FCharsetForUnicode write SetCharsetForUnicode default DEFAULT_CHARSET;      
      {$ENDIF}
      {$ENDIF}
  end;

implementation
uses
  {$IFNDEF RVDONOTUSESEQ}
  RVSeqItem, RVNote,
  {$ENDIF}
  {$IFNDEF RVDONOTUSETABLES}
  RVTable,
  {$ENDIF}
  RVStr;

{$IFNDEF RVDONOTUSERTFIMPORT}
type
  TSubDataInfo = class
  public
    PrevRVData: TCustomRVData;
    ParentRow, ParentCol: Integer;
  end;

{$IFNDEF RVDONOTUSETABLES}
{=============================== TTableInfo ===================================}


  TTableSubDataInfo = class (TSubDataInfo)
    public
      BookmarkName: String;
      HRules: TRVIntegerList;
      table, lastrow: TRVTableItemInfo;
      Alignment: TRVRTFAlignment;
      AlignmentDefined, AlignmentEqual: Boolean;
      VSpacingTw, VBorderSpacing1Tw,VBorderSpacing2Tw: Integer;
      HSpacingTw, CellHPaddingTw, CellVPaddingTw, CellHPaddingCount, CellVPaddingCount,
      BestWidth: Integer;
      BorderWidthTw, CellBorderWidthTw, CellCount, BorderCount, CellBorderCount: Integer;
      UseHSpacing, UseVSpacing, Word2000, CellFlatBorder, RichViewSpecial: Boolean;
      RowFinished, IsLastRow, Hidden: Boolean;
      constructor Create;
      destructor Destroy; override;
      procedure Finalize(RVStyle: TRVStyle;
        DefStyleNo, DefParaNo: Integer;
        ExplicitTableWidth, AutoHideGridLines, UseSingleCellPadding: Boolean);
  end;
{------------------------------------------------------------------------------}
constructor TTableSubDataInfo.Create;
begin
  inherited Create;
  HRules := TRVIntegerList.Create;
  CellFlatBorder := True;
  AlignmentEqual := True;
  Hidden := True;
end;
{------------------------------------------------------------------------------}
destructor TTableSubDataInfo.Destroy;
begin
  lastrow.Free;
  HRules.Free;
  inherited Destroy;
end;
{------------------------------------------------------------------------------}
procedure TTableSubDataInfo.Finalize(RVStyle: TRVStyle;
  DefStyleNo, DefParaNo: Integer;
  ExplicitTableWidth, AutoHideGridLines, UseSingleCellPadding: Boolean);
var r,c: Integer;
    //r2,c2: Integer;
    Cell1: TRVTableCellData;
    //Cell2: TRVTableCellData;
begin
  if CellFlatBorder then
    table.CellBorderStyle := rvtbColor;
  if table.BorderColor=table.BorderLightColor then
    table.BorderStyle := rvtbColor;
  if UseSingleCellPadding then begin
    if CellHPaddingCount+CellVPaddingCount>0 then
      table.CellPadding := RVStyle.TwipsToUnits(
        Round((CellHPaddingTw+CellVPaddingTw) /
        (CellHPaddingCount+CellVPaddingCount)))
    else
      table.CellPadding := 0;
    end
    else
  begin
    if CellHPaddingCount>0 then
      table.CellHPadding := RVStyle.TwipsToUnits(Round(CellHPaddingTw / CellHPaddingCount))
    else
      table.CellHPadding := 0;
    if CellVPaddingCount>0 then
      table.CellVPadding := RVStyle.TwipsToUnits(Round(CellVPaddingTw / CellVPaddingCount))
    else
      table.CellVPadding := 0;
  end;
  for r := 0 to table.Rows.Count-1 do
    for c := 0 to table.Rows[r].Count-1 do begin
      Cell1 := table.Cells[r,c];
      if (Cell1<>nil) then begin
        if not RichViewSpecial and (Cell1.BestWidth>table.CellHPadding*2) then
          Cell1.BestWidth := Cell1.BestWidth-table.CellHPadding*2;
        if (Cell1.Items.Count=0) then
         Cell1.AddNLR('', DefStyleNo, DefParaNo);
      end;
    end;
  {
  if (not UseVSpacing or not UseHSpacing) and AdjustVisibleBorders then
    for r := 0 to table.Rows.Count-1 do
      for c := 0 to table.Rows[r].Count-1 do begin
        Cell1 := table.Cells[r,c];
        if (Cell1<>nil) and Cell1.VisibleBorders.Left and not UseHSpacing and (c>0) then begin
          Cell2 := table.Rows.GetMainCell(r,c-1,r2,c2);
          if Cell2.VisibleBorders.Right then
            Cell1.VisibleBorders.Left := False;
        end;
        if (Cell1<>nil) and Cell1.VisibleBorders.Top and not UseVSpacing and (r>0) then begin
          Cell2 := table.Rows.GetMainCell(r-1,c,r2,c2);
          if Cell2.VisibleBorders.Bottom then
            Cell1.VisibleBorders.Top := False;
        end;
      end;
  }
  // BestWidth and BestHeight
  if RichViewSpecial then
    if BestWidth>0 then
      table.BestWidth := RVStyle.TwipsToUnits(BestWidth)
    else
      table.BestWidth := BestWidth
  else
    if BestWidth>0 then begin
      if BorderCount>0 then
        table.BestWidth := RVStyle.TwipsToUnits(Round(BestWidth-BorderWidthTw/BorderCount))
      else
        table.BestWidth := RVStyle.TwipsToUnits(BestWidth);
      end
    else if BestWidth<0 then
      table.BestWidth := BestWidth div 50
    else if ExplicitTableWidth then
      table.BestWidth := RVStyle.TwipsToUnits(HRules[HRules.Count-1]-HRules[0]);
  // Border widths
  if CellBorderCount>0 then begin
    table.CellBorderWidth :=  RVStyle.TwipsToUnits(Round(CellBorderWidthTw/CellBorderCount));
    if (RVStyle.Units=rvstuPixels) and (table.CellBorderWidth=0) and
       (Round(CellBorderWidthTw/CellBorderCount)>=5) then
      table.CellBorderWidth := 1;
  end;
  if BorderCount>0 then begin
    table.BorderWidth :=  RVStyle.TwipsToUnits(Round(BorderWidthTw/BorderCount));
    if (RVStyle.Units=rvstuPixels) and (table.BorderWidth=0) and (Round(BorderWidthTw/BorderCount)>=5) then
      table.BorderWidth := 1;
  end;
  // Spacing
  if UseVSpacing then begin
    if table.Rows.Count>1 then
      table.CellVSpacing := RVStyle.TwipsToUnits(Round(VSpacingTw / (table.Rows.Count-1)));
      table.BorderVSpacing := RVStyle.TwipsToUnits(VBorderSpacing1Tw+VBorderSpacing2Tw);
    end
  else begin
    table.CellVSpacing := -table.CellBorderWidth;
    table.BorderVSpacing := -table.CellBorderWidth;
  end;
  if UseHSpacing then
    table.CellHSpacing := RVStyle.TwipsToUnits(Round(HSpacingTw / table.Rows.Count))
  else begin
    table.CellHSpacing := -1;
  end;
  table.BorderHSpacing := table.CellHSpacing;
  if not UseVSpacing and not UseHSpacing and (table.BorderWidth=table.CellBorderWidth) then begin
    table.BorderWidth := 0;
    table.BorderHSpacing := 0;
    table.BorderVSpacing := 0;
  end;
  if AutoHideGridLines then
    table.Options := table.Options + [rvtoHideGridLines];
end;
{$ENDIF}
{==============================================================================}
procedure BorderRTF2RV(StyleRTF:TRVRTFBorderType; WidthRTF: Integer;
  var StyleRV: TRVBorderStyle; var WidthRV, IntWidthRV: TRVStyleLength;
  RVStyle: TRVStyle; InvertSides: Boolean);
begin
  IntWidthRV := 0;
  case StyleRTF of
    rtf_brdr_None:
      begin
        StyleRV := rvbNone;
        WidthRV := 0;
      end;
    rtf_brdr_SingleThickness,
    rtf_brdr_Inset, rtf_brdr_Outset, rtf_brdr_Shadow,
    rtf_brdr_Dot, rtf_brdr_Dash, rtf_brdr_DashSmall,
    rtf_brdr_DotDash, rtf_brdr_DotDotDash,
    rtf_brdr_Wavy, rtf_brdr_Striped,
    rtf_brdr_Emboss, rtf_brdr_Engrave:
      begin
       // WidthRTF = width of line
        StyleRV := rvbSingle;
        WidthRV    := RVStyle.TwipsToUnits(WidthRTF);
      end;
    rtf_brdr_DoubleThickness:
      begin
        // WidthRTF = width of line / 2
        StyleRV := rvbSingle;
        WidthRV    := RVStyle.TwipsToUnits(WidthRTF*2);
      end;
    rtf_brdr_Double, rtf_brdr_DoubleWavy:
      begin
        // WidthRTF = width of line = width of space
        StyleRV := rvbDouble;
        WidthRV    := RVStyle.TwipsToUnits(WidthRTF);
        IntWidthRV := WidthRV*2-1;
      end;
    rtf_brdr_Triple:
      begin
        // WidthRTF = width of line = width of space
        StyleRV := rvbTriple;
        WidthRV    := RVStyle.TwipsToUnits(WidthRTF);
        IntWidthRV := WidthRV*2-1;
      end;
    rtf_brdr_Hairline:
      begin
        StyleRV := rvbSingle;
        WidthRV := 1;
      end;
    rtf_brdr_ThickThinSmall:
      begin
        // original: one-pixel thin line, one-pixel space, WidthRTF thick line
        if InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV    := RVStyle.TwipsToUnits(Round(WidthRTF/2));
        IntWidthRV := WidthRV+(WidthRV+1) div 2;
      end;
    rtf_brdr_ThickThinMed:
      begin
        // original: WidthRTF thick line, thin line - half (?), space = thin line,
        if InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV    := RVStyle.TwipsToUnits(Round(WidthRTF/2));
        IntWidthRV := WidthRV*2+(WidthRV+1) div 2;
      end;
    rtf_brdr_ThickThinLarge:
      begin
        // original: one-pixel thin line, two-pixel thick line (?), WidthRTF space
        if InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV    := RVStyle.TwipsToUnits(15);
        IntWidthRV :=  RVStyle.TwipsToUnits(WidthRTF+15);
      end;
    rtf_brdr_ThinThickSmall:
      begin
        if not InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV := RVStyle.TwipsToUnits(Round(WidthRTF*3/8)+15);
        IntWidthRV := WidthRV+(WidthRV+1) div 2;
      end;
    rtf_brdr_ThinThickMed:
      begin
        if not InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV    := RVStyle.TwipsToUnits(Round(WidthRTF/2));
        IntWidthRV := WidthRV*2+(WidthRV+1) div 2;
      end;
    rtf_brdr_ThinThickLarge:
      begin
        if not InvertSides then
          StyleRV := rvbThickInside
        else
          StyleRV    := rvbThickOutside;
        WidthRV    := RVStyle.TwipsToUnits(15);
        IntWidthRV := RVStyle.TwipsToUnits(WidthRTF+15);
      end;
    rtf_brdr_ThinThickThinSmall:
      begin
        StyleRV    := rvbTriple;
        WidthRV    := RVStyle.TwipsToUnits(Round(WidthRTF/3));
        IntWidthRV := WidthRV*2-1;;
      end;
    rtf_brdr_ThinThickThinMed:
      begin
        StyleRV    := rvbTriple;
        WidthRV    := RVStyle.TwipsToUnits(Round(WidthRTF/2));
        IntWidthRV := WidthRV*3-1;
      end;
    rtf_brdr_ThinThickThinLarge:
      begin
        StyleRV    := rvbTriple;
        WidthRV    := RVStyle.TwipsToUnits(15);
        IntWidthRV := RVStyle.TwipsToUnits(WidthRTF);
      end;
  end;
end;
{$ENDIF}
{=========================== TRVRTFReaderProperties ===========================}
constructor TRVRTFReaderProperties.Create;
begin
  inherited Create;
  FUnicodeMode   :=
    {$IFDEF RVUNICODEWINDOW}rvruOnlyUnicode{$ELSE}rvruNoUnicode{$ENDIF};
  FTextStyleMode := rvrsUseClosest;
  FParaStyleMode := rvrsUseClosest;
  FSkipHiddenText  := True;
  //AdjustVisibleBorders := True;
  FHideTableGridLines := False;
  AllowNewPara   := True;
  {$IFNDEF RVDONOTUSERTFIMPORT}
  FConvertHighlight := rtfhlColorTable;
  FExtractMetafileBitmaps := True;
  FBasePathLinks := True;
  {$IFDEF RICHVIEWCBDEF3}
  FUseCharsetForUnicode := False;
  FCharsetForUnicode := DEFAULT_CHARSET;
  {$ENDIF}
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.Assign(Source: TPersistent);
begin
  if Source is TRVRTFReaderProperties then begin
    FUnicodeMode   := TRVRTFReaderProperties(Source).FUnicodeMode;
    FTextStyleMode := TRVRTFReaderProperties(Source).FTextStyleMode;
    FParaStyleMode := TRVRTFReaderProperties(Source).FParaStyleMode;
    FIgnorePictures  := TRVRTFReaderProperties(Source).FIgnorePictures;
    FIgnoreNotes     := TRVRTFReaderProperties(Source).FIgnoreNotes;
    FIgnoreSequences := TRVRTFReaderProperties(Source).FIgnoreSequences;
    FIgnoreTables    := TRVRTFReaderProperties(Source).FIgnoreTables;
    FSkipHiddenText  := TRVRTFReaderProperties(Source).FSkipHiddenText;
    FParaNo        := TRVRTFReaderProperties(Source).FParaNo;
    FStyleNo        := TRVRTFReaderProperties(Source).FStyleNo;
    FUseHypertextStyles := TRVRTFReaderProperties(Source).FUseHypertextStyles;
    FLineBreaksAsParagraphs := TRVRTFReaderProperties(Source).FLineBreaksAsParagraphs;
    {$IFNDEF RVDONOTUSERTFIMPORT}
    FExtractMetafileBitmaps := TRVRTFReaderProperties(Source).FExtractMetafileBitmaps;
    FConvertHighlight := TRVRTFReaderProperties(Source).FConvertHighlight;
    {$ENDIF}
    end
  else
    inherited Assign(Source);
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.ReadFromFile(const AFileName: String;
  ARVData: TCustomRVData): TRVRTFErrorCode;
begin
{$IFNDEF RVDONOTUSERTFIMPORT}
  try
    RVData := ARVData;
    EditFlag := False;
    InsertPoint := RVData.Items.Count;
    Index := -1;
    Reader := GetRVRTFReaderClass.Create(nil);
    try
      InitReader;
      Result := Reader.ReadFromFile(AFileName);
      ErrorCode := Result;
    finally
      DoneReader;
      Reader.Free;
    end;
  except
    Result := rtf_ec_Exception;
  end;
{$ELSE}
  Result := rtf_ec_OK;
{$ENDIF}
end;
{------------------------------------------------------------------------------}
{$IFDEF RVUSEWORDDOC}
function TRVRTFReaderProperties.ReadFromWordDocFile(const AFileName: String; ARVData: TCustomRVData): TRVRTFErrorCode;
begin
{$IFNDEF RVDONOTUSERTFIMPORT}
  try
    RVData := ARVData;
    EditFlag := False;
    InsertPoint := RVData.Items.Count;
    Index := -1;
    Reader := GetRVRTFReaderClass.Create(nil);
    try
      InitReader;
      Result := Reader.ReadFromWordDocFile(AFileName);
      ErrorCode := Result;
    finally
      DoneReader;
      Reader.Free;
    end;
  except
    Result := rtf_ec_Exception;
  end;
{$ELSE}
  Result := rtf_ec_OK;
{$ENDIF}
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.ReadFromStream(AStream: TStream;
  ARVData: TCustomRVData): TRVRTFErrorCode;
begin
{$IFNDEF RVDONOTUSERTFIMPORT}
  try
    RVData := ARVData;
    Reader := GetRVRTFReaderClass.Create(nil);
    EditFlag := False;
    InsertPoint := RVData.Items.Count;
    Index := -1;
    try
      InitReader;
      Result := Reader.ReadFromStream(AStream);
      ErrorCode := Result;
    finally
      DoneReader;
      Reader.Free;
    end;
  except
    Result := rtf_ec_Exception;
  end;
{$ELSE}
  Result := rtf_ec_OK;
{$ENDIF}
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.InsertFromStreamEd(AStream: TStream;
  ARVData: TCustomRVData; var AIndex: Integer): TRVRTFErrorCode;
begin
{$IFNDEF RVDONOTUSERTFIMPORT}
  RVData := ARVData;
  Reader := GetRVRTFReaderClass.Create(nil);
  EditFlag := True;
  InsertPoint := AIndex;
  Index := -1;
  try
    InitReader;
    Result := Reader.ReadFromStream(AStream);
    ErrorCode := Result;
  finally
    Reader.Free;
    DoneReader;
    AIndex := Index;
  end;
{$ELSE}
  Result := rtf_ec_OK;
{$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetParaNo(const Value: Integer);
begin
  if Value<0 then
    raise Exception.Create(errRVNegative);
  if FParaNo<>Value then begin
    FParaNo := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetStyleNo(const Value: Integer);
begin
  if Value<0 then
    raise Exception.Create(errRVNegative);
  if FStyleNo<>Value then begin
    FStyleNo := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetParaStyleMode(
  const Value: TRVReaderStyleMode);
begin
  if FParaStyleMode<>Value then begin
    FParaStyleMode := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTFIMPORT}
{$IFNDEF RVDONOTUSEDOCPARAMS}
procedure TRVRTFReaderProperties.SetReadDocParameters(const Value: Boolean);
begin
  if FReadDocParameters<>Value then begin
    FReadDocParameters := Value;
    Changed;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetUseSingleCellPadding(const Value: Boolean);
begin
  if FUseSingleCellPadding<>Value then begin
    FUseSingleCellPadding := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetExtractMetafileBitmaps(
  const Value: Boolean);
begin
  if FExtractMetafileBitmaps<>Value then begin
    FExtractMetafileBitmaps := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetConvertHighlight(
  const Value: TRVRTFHighlight);
begin
  if FConvertHighlight<>Value then begin
    FConvertHighlight := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetStoreImagesFileNames(const Value: Boolean);
begin
  if FStoreImagesFileNames<>Value then begin
    FStoreImagesFileNames := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetBasePathLinks(const Value: Boolean);
begin
  if FBasePathLinks<>Value then begin
    FBasePathLinks := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
procedure TRVRTFReaderProperties.SetCharsetForUnicode(
  const Value: TFontCharset);
begin
  if FCharsetForUnicode<>Value then begin
    FCharsetForUnicode := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetUseCharsetForUnicode(const Value: Boolean);
begin
  if FUseCharsetForUnicode<>Value then begin
    FUseCharsetForUnicode := Value;
    Changed;
  end;
end;
{$ENDIF}
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetSkipHiddenText(const Value: Boolean);
begin
  if FSkipHiddenText<>Value then begin
    FSkipHiddenText := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetTextStyleMode(
  const Value: TRVReaderStyleMode);
begin
  if FTextStyleMode<>Value then begin
    FTextStyleMode := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetUnicodeMode(const Value: TRVReaderUnicode);
begin
  if FUnicodeMode<>Value then begin
    FUnicodeMode := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetUseHypertextStyles(const Value: Boolean);
begin
  if FUseHypertextStyles<>Value then begin
    FUseHypertextStyles := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetHideTableGridLines(const Value: Boolean);
begin
  if FHideTableGridLines<>Value then begin
    FHideTableGridLines := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetIgnoreBookmarks(const Value: Boolean);
begin
  if FIgnoreBookmarks<>Value then begin
    FIgnoreBookmarks := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetIgnoreNotes(const Value: Boolean);
begin
  if FIgnoreNotes<>Value then begin
    FIgnoreNotes := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetIgnorePictures(const Value: Boolean);
begin
  if FIgnorePictures<>Value then begin
    FIgnorePictures := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetIgnoreSequences(const Value: Boolean);
begin
  if FIgnoreSequences<>Value then begin
    FIgnoreSequences := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetIgnoreTables(const Value: Boolean);
begin
  if FIgnoreTables<>Value then begin
    FIgnoreTables := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetLineBreaksAsParagraphs(
  const Value: Boolean);
begin
  if FLineBreaksAsParagraphs<>Value then begin
    FLineBreaksAsParagraphs := Value;
    Changed;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTFIMPORT}
function TRVRTFReaderProperties.GetRVRTFReaderClass: TRVRTFReaderClass;
begin
  Result := TRVRTFReader;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetFooter(RVData: TCustomRVData);
begin
  FFooterRVData := RVData;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.SetHeader(RVData: TCustomRVData);
begin
  FHeaderRVData := RVData;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.NewReaderPicture(Sender: TRVRTFReader;
  RTFPicture: TRVRTFPicture; Graphic: TGraphic; Position: TRVRTFPosition;
  const FileName: String; var Inserted: Boolean);
var item: TCustomRVItemInfo;
    Target, Hint, Extras: String;
    StyleNo, ItemTag,v: Integer;
    ItemName: TRVRawByteString;
    Hyp, FreeGraphic: Boolean;
    MustApplyScale: Boolean;
begin
  Inserted := False;
  if FSkipHiddenText and Reader.RTFState.CharProps.Hidden then
    exit;
  ItemName := '';
  Hint := '';
  if LineBreaksAsParagraphs and (Position=rtf_ts_NewLine) then
    Position := rtf_ts_NewPara;
  if Assigned(OnCustomImageItem) then begin
    Hyp := IsHypertext(Target, Hint, Extras);
    item := nil;
    FreeGraphic := False;
    OnCustomImageItem(CurrentRVData, Graphic, Hyp, item, FreeGraphic, RTFPicture,
      FileName, ItemName);
    if FreeGraphic then
      Graphic.Free;
    if Hyp and (item<>nil) then
      RVData.ReadHyperlink(Target, Extras, rvlfRTF, item.StyleNo, item.Tag, ItemName);
    end
  else begin
    if Graphic=nil then begin
      if RTFPicture.ShpPict then
        exit;
      Graphic := RV_CreateGraphics(TGraphicClass(RVStyle.InvalidPicture.Graphic.ClassType));
      Graphic.Assign(RVStyle.InvalidPicture.Graphic);
    end;
    StyleNo  := rvsPicture;
    ItemTag  := 0;
    if IsHypertext(Target, Hint, Extras) then begin
      RVData.ReadHyperlink(Target, Extras, rvlfRTF, StyleNo, ItemTag, ItemName);
      item := CreateRichViewItem(StyleNo,RVData) as TRVGraphicItemInfo;
      TRVGraphicItemInfo(item).Image := Graphic;
      TRVGraphicItemInfo(item).Tag := ItemTag;
      end
    else
      item := TRVGraphicItemInfo.CreateEx(CurrentRVData, Graphic, rvvaBaseline);
  end;
  if item<>nil then begin
    if RVStyle.Units=rvstuTwips then
      item.ConvertToDifferentUnits(rvstuTwips, nil, False);
    MustApplyScale := (item is TRVGraphicItemInfo) and (RTFPicture<>nil) and
      ((TRVGraphicItemInfo(item).Image is TMetafile) or
      (RTFPicture.PicScaleX<>100) or
      (RTFPicture.PicScaleY<>100));
    if MustApplyScale or
       (RTFPicture<>nil) and
       ((RTFPicture.SuggestedWidthTw>0) or (RTFPicture.SuggestedHeightTw>0)) then begin
      if RTFPicture.SuggestedWidthTw>0 then
        v := RVStyle.TwipsToUnits(RTFPicture.SuggestedWidthTw)
      else
        v := RVStyle.PixelsToUnits(TRVGraphicItemInfo(item).Image.Width);
      if MustApplyScale or (v<>RVStyle.PixelsToUnits(TRVGraphicItemInfo(item).Image.Width)) then
        TRVGraphicItemInfo(item).ImageWidth := Round(v/100*RTFPicture.PicScaleX);
      if RTFPicture.SuggestedHeightTw>0 then
        v := RVStyle.TwipsToUnits(RTFPicture.SuggestedHeightTw)
      else
        v := RVStyle.PixelsToUnits(TRVGraphicItemInfo(item).Image.Height);
      if MustApplyScale or (v<>RVStyle.PixelsToUnits(TRVGraphicItemInfo(item).Image.Height)) then
        TRVGraphicItemInfo(item).ImageHeight := Round(v/100*RTFPicture.PicScaleY);
    end;
    item.ParaNo := ReturnParaNo(Position);
    {$IFNDEF RVDONOTUSEITEMHINTS}
    item.Hint := Hint;
    {$ENDIF}
    if StoreImagesFileNames then
      item.SetExtraStrProperty(rvespImageFileName, FileName);
    item.BeforeLoading(rvlfRTF);
    InsertItem(ItemName, item, Position);
    Inserted := True;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderImportPicture(Sender: TRVRTFReader;
  const Location: String; var Graphic: TGraphic; var Invalid: Boolean);
begin
  Graphic := CurrentRVData.ImportPicture(Location, 0, 0, Invalid);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEOLECONTAINER}
(*
type
  TStreamHeader = record
    case Integer of
      0: ( { New }
        Signature: Integer;
        DrawAspect: Integer;
        DataSize: Integer);
      1: ( { Old }
        PartRect: TSmallRect);
  end;

  TRTFObjectHeader = record
    Signature: Integer;
    DrawAspect: Integer;
    ProgIdSize: Integer;
  end;

const
  StreamSignature = $434F4442; {'BDOC'}

procedure TRVRTFReaderProperties.NewReaderObject(Sender: TRVRTFReader;
  RTFObject: TRVRTFObject; Position: TRVRTFPosition; var Inserted: Boolean);
var ole: TOLEContainer;
    item: TRVControlItemInfo;
    s: TRVRawByteString;
    Size: Integer;
    Stream: TStream;
    header: TStreamHeader;
    rtfheader: TRTFObjectHeader;
    StreamAdapter: TStreamAdapter;
    OleObject: IOleObject;

    TempLockBytes: ILockBytes;
    TempStorage: IStorage;
    DataHandle: HGlobal;
    Buffer: Pointer;

begin
  case RTFObject.ObjType of
    rtf_obj_Emb:
      begin
        ole := TOLEContainer.Create(nil);
        try
          ole.Visible := False;
          ole.Parent := RVData.GetParentControl;
          ole.Width := Round(RTFObject.WidthTw*PixelsPerTwip);
          ole.Height := Round(RTFObject.HeightTw*PixelsPerTwip);
          RTFObject.Data.ReadBuffer(rtfheader, sizeof(rtfheader));
          RTFObject.Data.Seek(rtfheader.ProgIdSize+12, soFromCurrent);
          header.Signature := StreamSignature;
          header.DrawAspect := 1;//rtfheader.DrawAspect;
          Header.DataSize := RTFObject.Data.Size-RTFObject.Data.Position;
          Stream := TMemoryStream.Create;
          Stream.WriteBuffer(header, sizeof(header));
          Stream.CopyFrom(RTFObject.Data, Header.DataSize);
          Stream.Position := 0;
          ole.LoadFromStream(Stream);
          Stream.Free;
          item := TRVControlItemInfo.CreateEx(CurrentRVData, ole, rvvaBaseline);
          s := '';
          InsertItem(s, item, Position);
          Inserted := True;
        except
          ole.Free;
        end;
      end;
  end;
end;
*)
{$ENDIF}
{------------------------------------------------------------------------------}
function GetIndex(List: TRVIntegerList; Value: Integer): Integer;
var i: Integer;
begin
  for i := 0 to List.Count-1 do
    if List[i]>=Value-RV_TableGridEps then begin
      Result := i;
      exit;
    end;
  Result := List.Count;
end;
{$IFNDEF RVDONOTUSETABLES}
{------------------------------------------------------------------------------}
procedure MergeCol(table: TRVTableItemInfo; c: Integer);
var r: Integer;
begin
  if c>=table.Rows[0].Count-2 then
    exit;
  for r := 0 to table.Rows.Count-2 do
    if table.Cells[r,c]<>nil then
      table.Cells[r,c].Clear;
  for r := 0 to table.Rows.Count-2 do
    if (table.Cells[r,c]<>nil) and (table.Cells[r,c+1]<>nil) then begin
      table.Cells[r,c].AssignAttributesFrom(table.Cells[r,c+1], True,1,1);
      table.Rows.MergeCells(r,c, table.Cells[r,c+1].ColSpan+1,table.Cells[r,c+1].RowSpan,True,False);
    end;
end;
{------------------------------------------------------------------------------}
procedure GetBorderColors(Border: TRVRTFParaBorder; var c1, c2: TColor);
begin
  c1 := clNone;
  c2 := clNone;
  if Border.Sides[rtf_side_Left].BorderType<>rtf_brdr_None then
    c1 := Border.Sides[rtf_side_Left].Color
  else if Border.Sides[rtf_side_Top].BorderType<>rtf_brdr_None then
    c1 := Border.Sides[rtf_side_Top].Color;
  if Border.Sides[rtf_side_Right].BorderType<>rtf_brdr_None then
    c2 := Border.Sides[rtf_side_Right].Color
  else if Border.Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None then
    c2 := Border.Sides[rtf_side_Bottom].Color;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.AssignRowProperties;
var info: TTableSubDataInfo;
    i,span,r,c,idx,val,strt: Integer;
    RowProps: TRVRTFRowProperties;
    side: TRVRTFSide;
    c1,c2: TColor;
    {............................................................}
    procedure AssignCellProperties(Cell: TRVTableCellData; Props: TRVRTFCellProperties; RuleIndex1,RuleIndex2: Integer);
    var side: TRVRTFSide;
        w: Integer;
        c1, c2: TColor;
    begin
       inc(info.CellCount);
       Cell.Color := Props.Color;
       if RowProps.RichViewSpecial then
         Cell.BestHeight := RVStyle.TwipsToUnits(Props.BestHeightTw)
       else if RowProps.HeightTw>0 then
         Cell.BestHeight := RVStyle.TwipsToUnits(RowProps.HeightTw);
       for side := Low(TRVRTFSide) to High(TRVRTFSide) do begin
         if Props.Border.Sides[side].BorderType<>rtf_brdr_None then begin
           inc(info.CellBorderCount);
           inc(info.CellBorderWidthTw, Props.Border.Sides[side].WidthTw);
         end;
       end;
       Cell.VisibleBorders.Left := Props.Border.Sides[rtf_side_Left].BorderType<>rtf_brdr_None;
       Cell.VisibleBorders.Top := Props.Border.Sides[rtf_side_Top].BorderType<>rtf_brdr_None;
       Cell.VisibleBorders.Right := Props.Border.Sides[rtf_side_Right].BorderType<>rtf_brdr_None;
       Cell.VisibleBorders.Bottom := Props.Border.Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None;
       GetBorderColors(Props.Border,c1,c2);
       Cell.BorderColor := c1;
       Cell.BorderLightColor := c2;
       info.CellFlatBorder := info.CellFlatBorder and ((c1=c2) or (c1=clNone) or (c2=clNone));
       if RowProps.RichViewSpecial then
         if Props.BestWidth>0 then
           Cell.BestWidth := RVStyle.TwipsToUnits(Props.BestWidth)
         else
           Cell.BestWidth := Props.BestWidth         
       else begin
         info.Word2000 := info.Word2000 or (Props.BestWidth<>0);
         if not info.Word2000 then begin
           w := info.HRules[RuleIndex2]-info.HRules[RuleIndex1];
           Cell.BestWidth := RVStyle.TwipsToUnits(w)
           end
         else
           if Props.BestWidth>0 then begin
             w := Props.BestWidth;
             Cell.BestWidth := RVStyle.TwipsToUnits(w)
             end
           else
             Cell.BestWidth := Props.BestWidth div 50;
       end;
       case Props.VAlign of
         rtf_val_Top:
           Cell.VAlign := rvcTop;
         rtf_val_Bottom:
           Cell.VAlign := rvcBottom;
         rtf_val_Center:
           Cell.VAlign := rvcMiddle;
       end;
    end;
    {............................................................}
    procedure HideBorders(Row,Col: Integer);
    var Cell: TRVTableCellData;
    begin
      Cell := info.table.Cells[Row,Col];
      if Cell<>nil then begin
        Cell.VisibleBorders.SetAll(False);
        Cell.Clear;
        Cell.AddNLR('',GetEmptyStyleNo,GetEmptyParaNo(rvaLeft, 0));
      end;
    end;
    {............................................................}
begin
  info := TTableSubDataInfo(SubDataList[SubDataList.Count-1]);
  info.table.InsertRows(info.table.Rows.Count,1,-1);
  if info.table.Rows[0].Count<info.lastrow.Rows[0].Count then begin
    c := info.table.Rows[0].Count;
    span := info.lastrow.Rows[0].Count-info.table.Rows[0].Count+1;
    info.table.InsertCols(c,span,-1);
    if CurrentRow>1 then begin
      info.table.MergeCells(0,c,span,info.table.Rows.Count,True);
      HideBorders(0,c);
    end;
  end;
  RowProps := Reader.RTFState.RowProps;
  if RowProps.Heading then
    info.table.HeadingRowCount := info.table.Rows.Count;

  if CurrentRow=0 then begin
    info.Alignment := RowProps.Alignment;
    info.AlignmentDefined := RowProps.AlignmentDefined;
    info.AlignmentEqual := info.AlignmentDefined;
    end
  else
    info.AlignmentEqual := info.AlignmentEqual and RowProps.AlignmentDefined
      and (info.Alignment=RowProps.Alignment);

  //assigning table attributes
  if RowProps.UseSpacing[rtf_side_Top] then
    if CurrentRow=0 then begin
      info.VBorderSpacing1Tw := RowProps.SpacingTw[rtf_side_Top];
      info.table.VisibleBorders.Top :=
        (RowProps.Border.Sides[rtf_side_Top].BorderType<>rtf_brdr_None);
      info.table.VisibleBorders.Left :=
        (RowProps.Border.Sides[rtf_side_Left].BorderType<>rtf_brdr_None);
      info.table.VisibleBorders.Right :=
        (RowProps.Border.Sides[rtf_side_Right].BorderType<>rtf_brdr_None);
      end
    else
      inc(info.VSpacingTw, RowProps.SpacingTw[rtf_side_Top]);
  info.table.VisibleBorders.Bottom :=
    (RowProps.Border.Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None);
  inc(info.VSpacingTw, info.VBorderSpacing2Tw);
  info.UseHSpacing := info.UseHSpacing or
    (RowProps.UseSpacing[rtf_side_Left] and (RowProps.SpacingTw[rtf_side_Left]>=0)) or
    (RowProps.UseSpacing[rtf_side_Right] and (RowProps.SpacingTw[rtf_side_Right]>=0));
  info.UseVSpacing := info.UseVSpacing or
    (RowProps.UseSpacing[rtf_side_Top] and (RowProps.SpacingTw[rtf_side_Top]>=0)) or
    (RowProps.UseSpacing[rtf_side_Bottom] and (RowProps.SpacingTw[rtf_side_Bottom]>=0));
  for side := Low(TRVRTFSide) to High(TRVRTFSide) do
    if RowProps.SpacingTw[side]<0 then
      RowProps.FUseSpacing[side] := False;
  if RowProps.UseSpacing[rtf_side_Bottom] then
    info.VBorderSpacing2Tw := RowProps.SpacingTw[rtf_side_Bottom];
  if RowProps.UseSpacing[rtf_side_Left] then
    inc(info.HSpacingTw, RowProps.SpacingTw[rtf_side_Left])
  else begin
    inc(info.HSpacingTw, RowProps.GapHTw);
    if RowProps.UsePadding[rtf_side_Left] then
      dec(info.HSpacingTw, RowProps.PaddingTw[rtf_side_Left]);
  end;
  if RowProps.UseSpacing[rtf_side_Right] then
    inc(info.HSpacingTw, RowProps.SpacingTw[rtf_side_Right])
  else begin
    inc(info.HSpacingTw, RowProps.GapHTw);
    if RowProps.UsePadding[rtf_side_Right] then
      dec(info.HSpacingTw, RowProps.PaddingTw[rtf_side_Right]);
  end;
  for side := Low(TRVRTFSide) to High(TRVRTFSide) do begin
    if RowProps.Border.Sides[side].BorderType<>rtf_brdr_None then begin
      inc(info.BorderWidthTw, RowProps.Border.Sides[side].WidthTw);
      inc(info.BorderCount);
    end;
    if side in [rtf_side_Left, rtf_side_Right] then begin
      if RowProps.UsePadding[side] then
        inc(info.CellHPaddingTw, RowProps.PaddingTw[side]);
      inc(info.CellHPaddingCount);
      end
    else begin
      if RowProps.UsePadding[side] then
        inc(info.CellVPaddingTw, RowProps.PaddingTw[side]);
      inc(info.CellVPaddingCount);
    end;
  end;
  if RowProps.RichViewSpecial then begin
    info.BestWidth := RowProps.BestWidth;
    info.RichViewSpecial := True;
    end
  else
    if ((info.BestWidth<=0)  and (RowProps.BestWidth<info.BestWidth)) or
       ((info.BestWidth>=0) and (RowProps.BestWidth>info.BestWidth)) then
      info.BestWidth := RowProps.BestWidth;
  GetBorderColors(RowProps.Border,c1,c2);
  if c1<>clNone then
    info.table.BorderLightColor := c1;
  if c2<>clNone then
    info.table.BorderColor := c2;
  // assigning cells


  if (RowProps.CellProps.Count>0) and
    (RowProps.LeftTw-RowProps.CellProps[0].RightBoundaryTw>RV_TableGridEps) then
    RowProps.LeftTw := RowProps.CellProps[0].RightBoundaryTw-10;
  if CurrentRow=0 then begin
    info.HRules.Add(RowProps.LeftTw);
    for i := 0 to RowProps.CellProps.Count-1 do
      info.HRules.Add(RowProps.CellProps[i].RightBoundaryTw);
  end;

  strt := 0;
  if CurrentRow>0 then begin
    val := RowProps.LeftTw;
    idx := GetIndex(info.HRules, val);
    if idx=0 then begin
      if abs(info.HRules[idx]-val)>RV_TableGridEps then begin
        info.HRules.Insert(0, val);
        info.table.InsertCols(0,1,-1);
        info.table.Cells[CurrentRow,0].Clear;
        info.table.Cells[CurrentRow,0].AssignAttributesFrom(info.table.Cells[CurrentRow,1],True,1,1);
        info.table.Rows.MergeCells(0,0,1,CurrentRow,True,False);
        HideBorders(0,0);
        strt := 0;
      end;
     end
    else if idx=info.HRules.Count then begin
      info.HRules.Add(val);
      info.table.InsertCols(idx-1,2,-1);
      info.table.Rows.MergeCells(0,idx,1,CurrentRow,True,False);
      HideBorders(0,idx);
      MergeCol(info.table,idx-1);
      info.table.Rows.MergeCells(CurrentRow,0,idx,1,True,False);
      HideBorders(CurrentRow,0);
      if info.table.Cells[CurrentRow,0]<>nil then
        info.table.Cells[CurrentRow,0].BestWidth := RVStyle.TwipsToUnits(info.HRules[idx]-info.HRules[0]-RowProps.GapHTw*2);
      strt := idx;
      end
    else begin
      if abs(info.HRules[idx]-val)>RV_TableGridEps then begin
        info.HRules.Insert(idx, val);
        info.HRules.Sort;
        info.table.InsertCols(idx-1,1,-1);
        HideBorders(CurrentRow,idx-1);
        MergeCol(info.table,idx-1);
      end;
      info.table.Rows.MergeCells(CurrentRow,0,idx,1,True,False);
      info.table.Cells[CurrentRow, 0].BestWidth :=
        RVStyle.TwipsToUnits(info.HRules[idx]-info.HRules[0]);
      if idx>0 then
        HideBorders(CurrentRow,0);
      strt := idx;
    end;

    for i := 0 to RowProps.CellProps.Count-1 do begin
      val := RowProps.CellProps[i].RightBoundaryTw;
      if RowProps.CellProps[i].HMerge=rtf_cm_First then
        if strt<info.HRules.Count-1 then begin
          val := info.HRules[strt+1];
          if val>RowProps.CellProps[i+1].RightBoundaryTw then
            val := RowProps.CellProps[i+1].RightBoundaryTw;
          end
        else
          val := RowProps.CellProps[i+1].RightBoundaryTw;
      idx := GetIndex(info.HRules, val);
      if (idx=info.HRules.Count) then begin
        //if strt<info.HRules.Count-1 then begin
          info.table.InsertCols(idx-1,1,-1);
        //end;
        info.HRules.Add(val);
        info.table.Rows.MergeCells(0,idx-1,1,CurrentRow,True,False);
        info.table.Cells[0, idx-1].BestWidth :=
          RVStyle.TwipsToUnits(info.HRules[idx]-info.HRules[idx-1]);
        HideBorders(0,idx-1);
        end
      else if abs(info.HRules[idx]-val)>RV_TableGridEps then begin
        info.HRules.Insert(idx, val);
        info.HRules.Sort;
        try
          info.table.InsertCols(idx-1,1,-1);
        except
         ;
        end;
        MergeCol(info.table,idx-1);
      end;
      info.table.Rows.MergeCells(CurrentRow,strt,idx-strt,1,True,False);
      if (strt>0) and (RowProps.CellProps[i].HMerge=rtf_cm_Merged) then begin
        info.table.Rows.GetMainCell(CurrentRow,strt-1,r,c);
        info.table.Rows.MergeCells(r,c,idx-c,CurrentRow-r+1,True,False);
      end;
      if RowProps.CellProps[i].VMerge=rtf_cm_Merged then begin
        info.table.Rows.GetMainCell(CurrentRow-1,strt,r,c);
        span := idx-c;
        if info.table.Cells[r,c].ColSpan>span then
          span := info.table.Cells[r,c].ColSpan;
        info.table.Rows.MergeCells(r,c,span,CurrentRow-r+1,True,False);
      end;
      if info.table.Cells[CurrentRow,strt]<>nil then begin
        AssignCellProperties(info.table.Cells[CurrentRow,strt],RowProps.CellProps[i],strt,idx);
        info.table.Cells[CurrentRow,strt].Clear;
        info.table.Cells[CurrentRow,strt].DrainFrom(info.lastrow.Cells[0,i]);
      end;
      strt := idx;
      //if strt>=info.table.Rows.Count then
      //  dec(strt);
    end;
    for i := strt to info.table.Rows[CurrentRow].Count-1 do begin
      HideBorders(CurrentRow,i);
    end;
    end
  else // CurrentRow=0
    for i := 0 to RowProps.CellProps.Count-1 do begin
      if RowProps.CellProps[i].HMerge=rtf_cm_Merged then begin
        info.table.Rows.GetMainCell(CurrentRow,i-1,r,c);
        info.table.Rows.MergeCells(r,c,i-c+1,1,True,False);
      end;
      if info.table.Cells[CurrentRow,i]<>nil then begin
        AssignCellProperties(info.table.Cells[CurrentRow,i], RowProps.CellProps[i],i,i+1);
        info.table.Cells[CurrentRow,i].Clear;
        info.table.Cells[CurrentRow,i].DrainFrom(info.lastrow.Cells[0,i]);
      end;
    end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderTable(Sender: TRVRTFReader;
  WhatHappens: TRVRTFTableEventKind; var Processed: Boolean);
var info: TTableSubDataInfo;
    i: Integer;
    s: TRVRawByteString;
    APageBreak: Boolean;
    APageBreakRVData: TCustomRVData;
    Alignment: TRVAlignment;
begin
  Processed := True;
  case WhatHappens of
    rvf_tbl_TableStart:
      begin
        if SubDataList=nil then
          SubDataList := TRVList.Create;
        info := TTableSubDataInfo.Create;
        info.table := TRVTableItemInfo.CreateEx(0,0,CurrentRVData);
        if PageBreak and (PageBreakRVData=CurrentRVData) then begin
          info.table.PageBreakBefore := True;
          PageBreak := False;
          PageBreakRVData := nil;
        end;
        info.BookmarkName := FBookmarkName;
        FBookmarkName := '';
        info.table.BeforeLoading(rvlfRTF);
        info.table.Color := clNone;
        info.table.BorderStyle := rvtbRaisedColor;
        info.table.CellBorderStyle := rvtbLoweredColor;
        info.table.CellBorderColor := clWindowText;
        info.table.BorderColor := clWindowText;
        info.table.BorderLightColor := clWindowText;
        info.table.CellBorderLightColor := clWindowText;
        info.lastrow := TRVTableItemInfo.CreateEx(1,1,CurrentRVData);
        info.lastrow.BeforeLoading(rvlfRTF);
        info.ParentRow := CurrentRow;
        info.ParentCol := CurrentCol;
        info.PrevRVData := CurrentRVData;
        CurrentRow := 0;
        CurrentCol := 0;
        CurrentRVData := info.lastrow.Cells[0,0];
        CurrentRVData.Clear;
        SubDataList.Add(info);
      end;
    rvf_tbl_TableEnd, rvf_tbl_TableForcedEnd:
      begin
        info := TSubDataInfo(SubDataList[SubDataList.Count-1]) as TTableSubDataInfo;
        if (WhatHappens=rvf_tbl_TableEnd) and not info.RowFinished then begin
          Processed := False;
          exit;
        end;
        info.Finalize(RVStyle,
          GetEmptyStyleNo, GetEmptyParaNo(rvaLeft, 0), ExplicitTableWidth,
          AutoHideTableGridLines, UseSingleCellPadding);
        if PageBreak and (PageBreakRVData=CurrentRVData) then
          PageBreakRVData := info.PrevRVData;
        APageBreak := PageBreak;
        APageBreakRVData := PageBreakRVData;
        PageBreak := False;
        PageBreakRVData := nil;
        CurrentRVData := info.PrevRVData;
        CurrentRow := info.ParentRow;
        CurrentCol := info.ParentCol;
        info.table.DeleteCols(info.HRules.Count-1,info.table.Rows[0].Count-info.HRules.Count+1,False);
        if info.AlignmentDefined then
          Alignment := TRVAlignment(ord(info.Alignment))
        else
          Alignment := rvaLeft; //TRVAlignment(ord(Reader.RTFState.ParaProps.Alignment));
        info.table.ParaNo := GetEmptyParaNo(Alignment, info.HRules[0]);
        s := '';
        FBookmarkName := info.BookmarkName;
        if (info.table.Rows.Count=0) or (info.table.Rows[0].Count=0) then begin
          info.table.Free;
          info.table := nil
          end
        else begin
          info.table.DeleteEmptyRows;
          info.table.Hidden := info.Hidden;
          InsertItem(s, info.table, rtf_ts_NewPara);
        end;
        if not info.RowFinished then begin
          {$IFNDEF RVDONOTUSELISTS}
          IgnoreLists := True;
          {$ENDIF}
          try
            for i := 0 to info.lastrow.Cells[0,0].Items.Count-1 do begin
              s := info.lastrow.Cells[0,0].Items[i];
              InsertItem(s, info.lastrow.Cells[0,0].GetItem(i), rtf_ts_NewPara);
              info.lastrow.Cells[0,0].Items.Objects[i] := nil;
            end;
          finally
            {$IFNDEF RVDONOTUSELISTS}
            IgnoreLists := False;
            LastMarkerIndex := -1;
            {$ENDIF}
            {$IFNDEF RVDONOTUSESEQ}
            LastNoteRefIndex := -1;
            {$ENDIF}
          end;
        end;
        SubDataList.Delete(SubDataList.Count-1);
        PageBreak := APageBreak;
        PageBreakRVData := APageBreakRVData;
      end;
    rvf_tbl_CellEnd:
      begin
        info := TSubDataInfo(SubDataList[SubDataList.Count-1]) as TTableSubDataInfo;
        if not Reader.RTFState.CharProps.Hidden then
          info.Hidden := False;
        if info.IsLastRow then begin
           info.IsLastRow := False;
           ReaderTable(Sender, rvf_tbl_TableEnd, Processed);
           if Processed then
             ReaderTable(Sender, rvf_tbl_TableStart, Processed);
           Processed := True;
           info := TSubDataInfo(SubDataList[SubDataList.Count-1]) as TTableSubDataInfo;
        end;

        if info.lastrow.Cells[0,CurrentCol].Items.Count=0 then begin
           NewReaderText(Sender,'',rtf_ts_NewPara);
           {$IFNDEF RVDONOTUSELISTS}
           ReaderUpdateMarker(Sender);
           {$ENDIF}
        end;
        inc(CurrentCol);
        if CurrentCol=info.lastrow.Rows[0].Count then
          info.lastrow.InsertCols(CurrentCol,1,-1);
        CurrentRVData := info.lastrow.Cells[0,CurrentCol];
        CurrentRVData.Clear;
      end;
    rvf_tbl_RowEnd:
      begin
        AssignRowProperties;
        info := TSubDataInfo(SubDataList[SubDataList.Count-1]) as TTableSubDataInfo;
        if not Reader.RTFState.CharProps.Hidden then
          info.Hidden := False;        
        info.RowFinished := True;
        inc(CurrentRow);
        CurrentCol := 0;
        info.lastrow.Rows.Reset(1,1);
        info.IsLastRow := Reader.RTFState.RowProps.LastRow;
        CurrentRVData := info.lastrow.Cells[0,CurrentCol];
        CurrentRVData.Clear;
      end;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.CreateTextItem(const Text: TRVAnsiString;
  {$IFDEF RICHVIEWCBDEF3}const WideText: WideString;{$ENDIF}
  StyleNo, ParaNo: Integer; UseUnicode: Boolean;
  var ResText: TRVRawByteString): TRVTextItemInfo;
var
  Target, Hint, Extras: String;
  AStyleNo,ItemTag: Integer;
  {$IFNDEF RVDONOTUSEUNICODE}
  CodePage: TRVCodePage;
  {$ENDIF}
begin
  Hint := '';
  Result := RichViewTextItemClass.Create(CurrentRVData);
  Result.BeforeLoading(rvlfRTF);
  {$IFNDEF RVDONOTUSEUNICODE}
  if RVStyle.TextStyles[StyleNo].Unicode then
    Include(Result.ItemOptions, rvioUnicode);
  if not UseUnicode then
    if RVStyle.TextStyles[StyleNo].Unicode then begin
      if Reader.FontTable.Count=0 then
        CodePage := CP_ACP
      else
        CodePage := RVU_Charset2CodePage(
          Reader.FontTable[Reader.RTFState.CharProps.FontIndex].Charset);
      ResText := RVU_AnsiToUnicode(CodePage, Text)
      end
    else
      ResText := Text
  else
    if RVStyle.TextStyles[StyleNo].Unicode then begin
      SetLength(ResText, Length(WideText)*2);
      Move(Pointer(WideText)^, PRVAnsiChar(ResText)^, Length(ResText));
      end
    else
      ResText := Reader.UnicodeToAnsi(WideText);
  {$ELSE}
  ResText := Text;
  {$ENDIF}
  ResText := CurrentRVData.ReplaceTabs(ResText, StyleNo, False);
  ItemTag := 0;
  if IsHypertext(Target, Hint, Extras) then begin
    AStyleNo := StyleNo;
    CurrentRVData.ReadHyperlink(Target, Extras, rvlfRTF, AStyleNo, ItemTag, ResText);
    if AStyleNo>=0 then
      StyleNo := AStyleNo;
  end;
  Result.StyleNo := StyleNo;
  Result.ParaNo  := ParaNo;
  Result.Tag     := ItemTag;
  {$IFNDEF RVDONOTUSEITEMHINTS}
  Result.Hint    := Hint;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.InsertItem(var Text: TRVRawByteString;
  item: TCustomRVItemInfo; Position: TRVRTFPosition);
var Dummy: Integer;
    cp: TRVCPInfo;
   {$IFDEF RVRECHECKRTFPARA}
   {........................................................................}
   procedure RecheckPara(RVData: TCustomRVData; ItemNo: Integer);
   var i, ParaNo: Integer;
   begin
     if not FFirstParaInserted then
       exit;
     ParaNo := ReturnParaNo_;
     if ParaNo<>RVData.GetItemPara(ItemNo) then
       for i := ItemNo downto 0 do begin
         RVData.GetItem(i).ParaNo := ParaNo;
         if RVData.IsParaStart(i) then
           break;
       end;
   end;
   {........................................................................}
   {$ENDIF}
begin
  case Position of
     rtf_ts_ContinuePara:
         item.SameAsPrev := True;
     rtf_ts_NewLine,
     rtf_ts_NewPara:
       begin
         if (Position = rtf_ts_NewLine) and not LineBreaksAsParagraphs then
           item.BR := True
         else begin
           if not AllowNewPara then
             item.BR := True
           else begin
             {$IFDEF RVRECHECKRTFPARA}
             FFirstParaInserted := True;
             {$ENDIF}
             {$IFNDEF RVDONOTUSELISTS}
             if (item.StyleNo<>rvsListMarker) and not IgnoreLists {$IFNDEF RVDONOTUSETABLES} and (item.StyleNo<>rvsTable){$ENDIF} then
               if InsertMarker(item.ParaNo) then
                 item.SameAsPrev := True;
             {$ENDIF}
           end;
         end;
       end;
  end;
  if (Item is TRVNonTextItemInfo) {$IFNDEF RVDONOTUSETABLES}and not (Item is TRVTableItemInfo){$ENDIF} and
    RTFReader.RTFState.CharProps.Hidden then
    TRVNonTextItemInfo(Item).Hidden := True;
  if FBookmarkName<>'' then begin
    cp := TRVCPInfo.Create;
    cp.Name := FBookmarkName;
    cp.ItemNo := InsertPoint;
    item.Checkpoint := cp;
    cp.ItemInfo := item;
    FBookmarkName := '';
  end;
  if PageBreak and (PageBreakRVData=CurrentRVData) then begin
    item.PageBreakBefore := True;
    PageBreak := False;
    PageBreakRVData := nil;
  end;
  if RVData=CurrentRVData then begin
    if FirstTime then begin
      FirstTime := False;
      if not EditFlag and ((InsertPoint=0) or
       (CurrentRVData.GetItem(InsertPoint-1).GetBoolValue(rvbpFullWidth))) then
        item.SameAsPrev := False;
      if not RVData.InsertFirstRVFItem(InsertPoint, Text, Item, EditFlag, FullReformat, Dummy) then begin
        FailedBecauseOfProtect := True;
        abort;
      end;
      if item<>nil then begin
        Item.AfterLoading(rvlfRTF);
        if not EditFlag and (Item.Checkpoint<>nil) then begin
          inc(RVData.CPCount);
          RVData.UpdateCPPos(Item.Checkpoint, InsertPoint);
        end;
        inc(InsertPoint);
        Index := InsertPoint-1;
        end
      else
        FirstTime := True;
      {$IFNDEF RVDONOTUSELISTS}
      if (item<>nil) and (item.StyleNo=rvsListMarker) then
        LastMarkerIndex := Index;
      {$ENDIF}
      {$IFNDEF RVDONOTUSESEQ}
      if (item<>nil) and (item.StyleNo=rvsNoteReference) then
        LastNoteRefIndex := Index
      else
        LastNoteRefIndex := -1;
      {$ENDIF}
      end
    else begin
      if (InsertPoint=0) or
       (CurrentRVData.GetItem(InsertPoint-1).GetBoolValue(rvbpFullWidth)) then
        item.SameAsPrev := False;
      Item.Inserting(RVData, Text, False);
      RVData.Items.InsertObject(InsertPoint, Text, Item);
      if not EditFlag and (Item.Checkpoint<>nil) then begin
        inc(RVData.CPCount);
        RVData.UpdateCPPos(Item.Checkpoint, InsertPoint);
      end;
      Item.Inserted(RVData, InsertPoint);
      Item.AfterLoading(rvlfRTF);
      {$IFNDEF RVDONOTUSESEQ}
      RVData.AddSeqInList(InsertPoint);
      if item.StyleNo=rvsNoteReference then
        LastNoteRefIndex := InsertPoint
      else
        LastNoteRefIndex := -1;
      {$ENDIF}
      {$IFNDEF RVDONOTUSELISTS}
      RVData.AddMarkerInList(InsertPoint);
      if item.StyleNo=rvsListMarker then
        LastMarkerIndex := InsertPoint;
      {$ENDIF}
      {$IFDEF RVRECHECKRTFPARA}
      RecheckPara(RVData, InsertPoint);
      {$ENDIF}
      inc(InsertPoint);
      inc(NonFirstItemsAdded);
    end;
    end
  else begin
    if (CurrentRVData.Items.Count=0) or
       (CurrentRVData.GetItem(CurrentRVData.Items.Count-1).GetBoolValue(rvbpFullWidth)) then
      item.SameAsPrev := False;
    Item.Inserting(CurrentRVData, Text, False);
    CurrentRVData.Items.AddObject(Text, Item);
    if Item.Checkpoint<>nil then begin
      inc(CurrentRVData.CPCount);
      CurrentRVData.UpdateCPPos(Item.Checkpoint, CurrentRVData.ItemCount-1);
    end;
    Item.Inserted(CurrentRVData, CurrentRVData.ItemCount-1);
    if (CurrentRVData=FHeaderRVData) or (CurrentRVData=FFooterRVData) then
      Item.AfterLoading(rvlfRTF);
    {$IFNDEF RVDONOTUSESEQ}
    CurrentRVData.AddSeqInList(CurrentRVData.ItemCount-1);
    if item.StyleNo=rvsNoteReference then
      LastNoteRefIndex := CurrentRVData.ItemCount-1;
    {$ENDIF}
    {$IFNDEF RVDONOTUSELISTS}
    CurrentRVData.AddMarkerInList(CurrentRVData.ItemCount-1);
    if item.StyleNo=rvsListMarker then
      LastMarkerIndex := CurrentRVData.ItemCount-1;
    {$ENDIF}
    {$IFNDEF RVDONOTUSETABLES}
    if CurrentRVData is TRVTableCellData then
      TTableSubDataInfo(SubDataList[SubDataList.Count-1]).RowFinished := False;
    {$ENDIF}
    {$IFDEF RVRECHECKRTFPARA}
    RecheckPara(CurrentRVData, CurrentRVData.ItemCount-1);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSELISTS}
procedure ConvMarker(RTFMarker: TRVRTFMarkerProperties;
                     var RVType: TRVListType;
                     var FormatStr1,FormatStr2: String);
begin
  if (RTFMarker.Level=11) or
     ((RTFMarker.Level=10) and (RTFMarker.ListType=rtf_pn_Default)) then begin
    RVType := rvlstBullet;
    FormatStr1 := String(RTFMarker.TextBefore);
    FormatStr2 := String(RTFMarker.TextBefore);
    end
  else begin
    case RTFMarker.ListType of
      rtf_pn_Default, rtf_pn_Decimal:
        RVType := rvlstDecimal;
      rtf_pn_LowerLetter:
        RVType := rvlstLowerAlpha;
      rtf_pn_UpperLetter:
        RVType := rvlstUpperAlpha;
      rtf_pn_LowerRoman:
        RVType := rvlstLowerRoman;
      rtf_pn_UpperRoman:
        RVType := rvlstUpperRoman;
    end;
    FormatStr1 := String(RTFMarker.TextBefore+'%s'+RTFMarker.TextAfter);
    FormatStr2 := String(RTFMarker.TextBefore+'%0:s'+RTFMarker.TextAfter);
  end;
end;
{------------------------------------------------------------------------------}
function GetMarkerFontName(Reader: TRVRTFReader;
  RTFMarker: TRVRTFCustomMarkerProperties): String;
begin
  if RTFMarker.FontIndex<0 then
    Result := Reader.FontTable[0].Name//RVFONT_SYMBOL
  else
    Result := Reader.FontTable[RTFMarker.FontIndex].Name;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
function GetMarkerCharset(Reader: TRVRTFReader;
  RTFMarker: TRVRTFCustomMarkerProperties): TFontCharset;
begin
  if RTFMarker.FontIndex<0 then
    Result := Reader.FontTable[0].Charset// SYMBOL_CHARSET
  else
    Result := Reader.FontTable[RTFMarker.FontIndex].Charset;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RICHVIEWCBDEF4}
function max(a,b:Integer): Integer;
begin
  if a>b then
    Result := a
  else
    Result := b;
end;
{$ENDIF}

function TRVRTFReaderProperties.GetMarkerIndex(RTFMarker: TRVRTFMarkerProperties): Integer;
var i: Integer;
    Level : TRVListLevel;
    FormatStr1,FormatStr2, FontName: String;
    ListType: TRVListType;
    FirstIndent, LeftIndent, PNIndent, PNSpace: TRVStyleLength;
    MarkerAlign: TRVRTFAlignment;
    {..............................................}
    function IsEqualIndents(Level : TRVListLevel): Boolean;
    begin
      if RTFMarker.Hanging then
        Result :=
          (Level.LeftIndent=LeftIndent) and
          (Level.FirstIndent=max(PNSpace, FirstIndent+PNIndent))
      else
        Result :=
          (Level.LeftIndent=LeftIndent) and
          (Level.FirstIndent=max(0, FirstIndent+max(PNIndent,PNSpace)));
      if not Result then
        exit;
      case MarkerAlign of
        rtf_al_Left:
          Result := Level.MarkerIndent=LeftIndent+FirstIndent;
        rtf_al_Right:
          Result := Level.MarkerIndent=Level.FirstIndent+Level.LeftIndent;
        rtf_al_Center:
          Result := Level.MarkerIndent=(LeftIndent+FirstIndent+Level.FirstIndent+Level.LeftIndent) div 2;
      end;
    end;
    {..............................................}
begin
  Result := -1;
  if ParaStyleMode<>rvrsAddIfNeeded then
    exit;  
  if (RTFMarker=nil) or (RTFMarker.FontIndex>=Reader.FontTable.Count) or (RTFMarker.Level<=0) then
    exit;
  if LevelToListNo.Count=0 then
    LevelToListNo.InitWith(-1, 11);
  if (RTFMarker.Level<11) and (LevelToListNo[RTFMarker.Level-1]>=0) then begin
    Result := LevelToListNo[RTFMarker.Level-1];
    exit;
  end;
  FontName := GetMarkerFontName(Reader, RTFMarker);
  ConvMarker(RTFMarker, ListType, FormatStr1,FormatStr2);
  MarkerAlign := RTFMarker.Alignment;
  if RTFMarker.Level=11 then
    MarkerAlign := rtf_al_Left;
  LeftIndent := RVStyle.TwipsToUnits(Reader.RTFState.ParaProps.LeftIndentTw);
  FirstIndent := RVStyle.TwipsToUnits(Reader.RTFState.ParaProps.FirstIndentTw);
  PNIndent := RVStyle.TwipsToUnits(RTFMarker.IndentTw);
  PNSpace  := RVStyle.TwipsToUnits(RTFMarker.SpaceTw);
  for i := 0 to RVStyle.ListStyles.Count-1 do begin
    if RVStyle.ListStyles[i].Levels.Count=0 then
      continue;
    Level := RVStyle.ListStyles[i].Levels[0];
    if (Level.ListType=ListType) and
       (Level.MarkerAlignment=TRVMarkerAlignment(MarkerAlign)) and
       IsEqualIndents(Level) and
       (Level.Font.Size=RTFMarker.FontSize) and
       (Level.Font.Style=RTFMarker.FontStyle) and
       (Level.Font.Color=RTFMarker.Color) and
       (AnsiCompareText(Level.Font.Name, FontName)=0) and
       ((Level.FormatString=FormatStr1) or (Level.FormatString=FormatStr2)) then begin
      Result := i;
      LevelToListNo[RTFMarker.Level-1] := Result;
      exit;
    end;
  end;
  Result := RVStyle.ListStyles.Count;
  Level := RVStyle.ListStyles.Add.Levels.Add;
  RVStyle.ListStyles[Result].Standard := False;
  Level.ListType   := ListType;
  Level.LeftIndent := LeftIndent;
  Level.MarkerIndent := LeftIndent+FirstIndent;
  if RTFMarker.Hanging then
    Level.FirstIndent := max(PNSpace, FirstIndent+PNIndent)
  else
    Level.FirstIndent := max(0, FirstIndent+max(PNIndent,PNSpace));
  Level.MarkerAlignment := TRVMarkerAlignment(MarkerAlign);
  case MarkerAlign of
    rtf_al_Right:
      begin
        Level.MarkerIndent := Level.FirstIndent+Level.LeftIndent;
      end;
    rtf_al_Center:
      begin
        Level.MarkerIndent := (Level.FirstIndent+Level.LeftIndent+Level.MarkerIndent) div 2;
      end;
  end;
  Level.Font.Size  := RTFMarker.FontSize;
  Level.Font.Style := RTFMarker.FontStyle;
  Level.Font.Color := RTFMarker.Color;
  Level.Font.Name  := FontName;
  Level.FormatString := FormatStr1;
  LevelToListNo[RTFMarker.Level-1] := Result;
  CurrentRVData.AfterAddStyle(RVStyle.ListStyles[Result]);
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.InsertMarker(ParaNo: Integer): Boolean;
var marker: TRVMarkerItemInfo;
    s: TRVRawByteString;
begin
  Result := False;
  if ParaStyleMode<>rvrsAddIfNeeded then
    exit;
  if not Reader.RTFState.ParaProps.HasMarker then
    LevelToListNo.Clear;
  if Reader.RTFState.ParaProps.ListOverrideIndex>=0 then begin
    MergeListTable97;
    InsertMarker97(ParaNo);
    Result := True;
    exit;
  end;
  Result := Reader.RTFState.ParaProps.HasMarker and
    (Reader.RTFState.ParaProps.MarkerProps.Level>0);
  if not Result then
    exit;
  if LevelToListNo.Count=0 then
    LevelToListNo.InitWith(-1, 11);
  marker := TRVMarkerItemInfo.CreateEx(CurrentRVData,
    -1, -1, Reader.RTFState.ParaProps.MarkerProps.Start,
    LevelToListNo[Reader.RTFState.ParaProps.MarkerProps.Level-1]<0);
  marker.ParaNo := ParaNo;
  marker.BeforeLoading(rvlfRTF);
  s := '';
  InsertItem(s, marker, rtf_ts_NewPara);
  IsLastMarkerWord97 := False;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.InsertMarker97(ParaNo: Integer): Boolean;
var marker: TRVMarkerItemInfo;
    s: TRVRawByteString;
    ListLevel, ListNo, ListMappedNo: Integer;
    ListOverride: TRVRTFListOverride97;
    Start: Integer;
    UseStart: Boolean;
begin
  Result := False;
  if ParaStyleMode<>rvrsAddIfNeeded then
    exit;
  ListLevel := Reader.RTFState.ParaProps.ListLevel;
  ListOverride := Reader.ListOverrideTable[Reader.RTFState.ParaProps.ListOverrideIndex];
  if (ListLevel<ListOverride.Count) and not ListOverride[ListLevel].Used then begin
    Start := ListOverride[ListLevel].Start;
    UseStart := ListOverride[ListLevel].UseStart;
    ListOverride[ListLevel].Used := True;
    end
  else begin
    Start := 1;
    UseStart := False;
  end;
  ListNo := ListOverride.ListIndex;
  ListMappedNo := ListTableMap97[ListNo];
  marker := TRVMarkerItemInfo.CreateEx(CurrentRVData,
    ListMappedNo, Reader.RTFState.ParaProps.ListLevel, Start, UseStart);
  marker.ParaNo := ParaNo;
  marker.BeforeLoading(rvlfRTF);
  s := '';
  InsertItem(s, marker, rtf_ts_NewPara);
  IsLastMarkerWord97 := True;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderUpdateMarker(Sender: TObject);
var Marker: TRVMarkerItemInfo;
    ListLevel, ListNo: Integer;
    FIDif: TRVStyleLength;
    ListOverride: TRVRTFListOverride97;
    Level: TRVListLevel;
    {.....................................................}
    procedure AddNewLevels97;
    var i: Integer;
    begin
      for i := RVStyle.ListStyles[Marker.ListNo].Levels.Count to Reader.ListTable[ListNo].Count-1 do begin
        RVStyle.ListStyles[Marker.ListNo].Levels.Add;
        CopyListLevel97(RVStyle.ListStyles[Marker.ListNo].Levels[i],
          Reader.ListTable[ListNo].Items[i]);
      end;
    end;
    {.....................................................}
begin
  if ParaStyleMode<>rvrsAddIfNeeded then
    exit;
  if LastMarkerIndex>=0 then begin
    if not IsLastMarkerWord97 then begin
      Marker := CurrentRVData.GetItem(LastMarkerIndex) as TRVMarkerItemInfo;
      Marker.ListNo := GetMarkerIndex(Reader.RTFState.ParaProps.MarkerProps);
      if Marker.ListNo>=0 then begin
        Marker.Level := 0;
        CurrentRVData.RecalcMarker(LastMarkerIndex, True);
      end;
      end
    else begin
      ListLevel := Reader.RTFState.ParaProps.ListLevel;
      if Reader.RTFState.ParaProps.ListOverrideIndex>=0 then begin
        Reader.RTFState.ParaProps.Finalize;
        ListOverride := Reader.ListOverrideTable[Reader.RTFState.ParaProps.ListOverrideIndex];
        ListNo := ListOverride.ListIndex;
        if not Reader.ListTable[ListNo].Items[ListLevel].FIndentsUpdated then begin
          Marker := CurrentRVData.GetItem(LastMarkerIndex) as TRVMarkerItemInfo;
          AddNewLevels97;
          Level := RVStyle.ListStyles[Marker.ListNo].Levels[Marker.Level];
          if (Marker.ListNo>=ListStylesCountBefore) then begin
            FIDif := Level.LeftIndent+Level.FirstIndent-Level.MarkerIndent;
            Level.MarkerIndent := RVStyle.TwipsToUnits(
              Reader.RTFState.ParaProps.LeftIndentTw+Reader.RTFState.ParaProps.FirstIndentTw);
            Level.LeftIndent := RVStyle.TwipsToUnits(
               Reader.RTFState.ParaProps.LeftIndentTw);
          if (Reader.RTFState.ParaProps.FirstIndentTw<0) and
               ((Reader.RTFState.ParaProps.MarkerTabTw=RV_UNDEFINED_TAB_POS) or
                (Reader.RTFState.ParaProps.MarkerTabTw>-Reader.RTFState.ParaProps.FirstIndentTw)) then
              Reader.RTFState.ParaProps.MarkerTabTw := Reader.RTFState.ParaProps.LeftIndentTw; //- Reader.RTFState.ParaProps.FirstIndentTw;
            if Reader.RTFState.ParaProps.MarkerTabTw=RV_UNDEFINED_TAB_POS then
              Level.FirstIndent := Level.MarkerIndent-Level.LeftIndent+FIDif
            else
              Level.FirstIndent :=
                RVStyle.TwipsToUnits(Reader.RTFState.ParaProps.MarkerTabTw)
                -Level.LeftIndent;
          end;
          Reader.ListTable[ListNo].Items[ListLevel].FIndentsUpdated := True;
        end;
        if not Reader.ListTable[ListNo].Items[ListLevel].FFontSizeDefined then begin
          Marker := CurrentRVData.GetItem(LastMarkerIndex) as TRVMarkerItemInfo;
          AddNewLevels97;
          if (Marker.ListNo>=ListStylesCountBefore) then begin
            RVStyle.ListStyles[Marker.ListNo].Levels[Marker.Level].Font.Size :=
              Reader.RTFState.CharProps.Size;
            RVStyle.ListStyles[Marker.ListNo].Levels[Marker.Level].Font.Style :=
              RVStyle.ListStyles[Marker.ListNo].Levels[Marker.Level].Font.Style+
              Reader.RTFState.CharProps.Style;
            RVStyle.ListStyles[Marker.ListNo].Levels[Marker.Level].Font.Color :=
              Reader.RTFState.CharProps.Color;
            Reader.ListTable[ListNo].Items[ListLevel].FFontSize :=
              Reader.RTFState.CharProps.Size;
            Reader.ListTable[ListNo].Items[ListLevel].FFontSizeDefined :=
              True;
          end;
        end;
      end;
    end;
    LastMarkerIndex := -1;
  end;
end;
{------------------------------------------------------------------------------}
procedure ConvMarker97(Reader: TRVRTFReader;
                     RTFMarker: TRVRTFListLevel97;
                     var RVType: TRVListType;
                     var FormatStr1,FormatStr2: String;
                     var FormatStrW:
                     {$IFDEF RICHVIEWCBDEF3}WideString{$ELSE}String{$ENDIF}
                     );
var i: Integer;
    s1,s2: String;
{$IFNDEF RVDONOTUSEUNICODE}
    FontName: String;
{$ENDIF}
begin
  case RTFMarker.ListType of
    rtf_pn_Decimal, rtf_pn_Default:
      RVType := rvlstDecimal;
    rtf_pn_LowerLetter:
      RVType := rvlstLowerAlpha;
    rtf_pn_UpperLetter:
      RVType := rvlstUpperAlpha;
    rtf_pn_LowerRoman:
      RVType := rvlstLowerRoman;
    rtf_pn_UpperRoman:
      RVType := rvlstUpperRoman;
    rtf_pn_Bullet:
      RVType := rvlstBullet;
  end;
  FormatStr1 := Copy(RTFMarker.Text, 2, Length(RTFMarker.Text)-1);
  FormatStr2 := FormatStr1;
  for i := Length(FormatStr1) downto 1 do
    if FormatStr1[i] <= #9 then begin
      s2 := '%'+IntToStr(ord(FormatStr1[i]))+':s';
      if FormatStr1[i]=#0 then
        s1 := '%s'
      else
        s1 := s2;
      Delete(FormatStr1,i,1);
      Insert(s1, FormatStr1, i);
      Delete(FormatStr2,i,1);
      Insert(s2, FormatStr2, i);
    end;
  FormatStrW := '';
  {$IFNDEF RVDONOTUSEUNICODE}
  if (RTFMarker.TextW<>'') and (RTFMarker.ListType=rtf_pn_Bullet) then begin
    RVType := rvlstUnicodeBullet;
    FormatStrW := Copy(RTFMarker.TextW, 2, Length(RTFMarker.TextW)-1);

    if (Length(FormatStrW)=1) then begin
      FontName := GetMarkerFontName(Reader, RTFMarker);
      if (Word(FormatStrW[1])>=61601) and (Word(FormatStrW[1])<=61694) and
         (CompareText(FontName, RVFONT_SYMBOL)=0) then begin
        FormatStr1 := chr(Word(FormatStrW[1])-61601+161);
        FormatStr2 := FormatStr1;
        RVType := rvlstBullet;
      end;
      if (Word(FormatStrW[1])>=61473) and (Word(FormatStrW[1])<=61695) and
         (CompareText(FontName, RVFONT_WINGDINGS)=0) then begin
        FormatStr1 := chr(Word(FormatStrW[1])-61473+33);
        FormatStr2 := FormatStr1;
        RVType := rvlstBullet;
      end;
    end;
  end;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
function AreLevelsEqual97(RVLevel: TRVListLevel; RTFLevel: TRVRTFListLevel97;
  RVType: TRVListType; const FontName, FormatStr1, FormatStr2: String;
  const FormatStrW: {$IFDEF RICHVIEWCBDEF3}WideString{$ELSE}String{$ENDIF};
  RVStyle: TRVStyle): Boolean;
var FirstIndent: TRVStyleLength;
begin
  Result :=  (RVLevel.ListType = RVType) and
            (RVLevel.StartFrom = RTFLevel.Start) and
            (RVLevel.MarkerAlignment = TRVMarkerAlignment(RTFLevel.Alignment)) and
            (RVLevel.LeftIndent = RVStyle.TwipsToUnits(RTFLevel.LeftIndentTw)) and
            (RVLevel.MarkerIndent = RVStyle.TwipsToUnits(RTFLevel.FirstIndentTw)+RVLevel.LeftIndent) and
            (RTFLevel.NoRestart = not (rvloLevelReset in RVLevel.Options)) and
            (RTFLevel.Legal = (rvloLegalStyleNumbering in RVLevel.Options)) and
            (RVLevel.Font.Style = RTFLevel.FontStyle) and
            (RVLevel.Font.Color = RTFLevel.Color) and
            (RVLevel.Font.Size  = RTFLevel.FontSize) and
            (CompareText(RVLevel.Font.Name, FontName) = 0);
  if not Result then
    exit;
  if RTFLevel.TabPosTw<>RV_UNDEFINED_TAB_POS then
    FirstIndent := RVStyle.TwipsToUnits(RTFLevel.TabPosTw)-RVLevel.LeftIndent
  else
    FirstIndent := 0;
  Result := (RVLevel.FirstIndent = FirstIndent);
  if not Result then
    exit;  
  case RVType of
    rvlstDecimal,rvlstLowerAlpha,
    rvlstUpperAlpha,rvlstLowerRoman,
    rvlstUpperRoman,rvlstBullet:
      Result := (RVLevel.FormatString=FormatStr1) or
                (RVLevel.FormatString=FormatStr2);
    {$IFNDEF RVDONOTUSEUNICODE}
    rvlstUnicodeBullet:
      Result := (RVLevel.FormatStringW=FormatStrW);
    {$ENDIF}
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.AreListStylesEqual97(RVList: TRVListInfo; RTFList: TRVRTFList97): Boolean;
var
  RVType: TRVListType;
  FontName, FormatStr1, FormatStr2: String;
  FormatStrW: {$IFDEF RICHVIEWCBDEF3}WideString{$ELSE}String{$ENDIF};
  RTFLevel: TRVRTFListLevel97;
  i: Integer;
begin
  Result := RVList.Levels.Count>=RTFList.Count;
  if not Result then
    exit;
  for i := 0 to RTFList.Count-1 do begin
     RTFLevel := RTFList.Items[i];
      ConvMarker97(Reader, RTFLevel, RVType, FormatStr1, FormatStr2, FormatStrW);
      FontName := GetMarkerFontName(Reader, RTFLevel);
      Result := AreLevelsEqual97(RVList.Levels[i], RTFLevel, RVType,
        FontName,FormatStr1,FormatStr2,FormatStrW,RVStyle);
      if not Result then
        exit;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.FindListStyle97(RTFList: TRVRTFList97;
  ForbiddenStyles: TRVIntegerList): Integer;
var i: Integer;
begin
  if ParaStyleMode=rvrsAddIfNeeded then
    for i := 0 to RVStyle.ListStyles.Count-1 do
      if (ForbiddenStyles.IndexOf(Pointer(i))<0) and
         AreListStylesEqual97(RVStyle.ListStyles[i], RTFList) then begin
        Result := i;
        exit;
      end;
  Result := -1;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.CopyListLevel97(RVLevel: TRVListLevel;
  RTFLevel: TRVRTFListLevel97);
var
    FormatStr1,FormatStr2,FontName: String;
    FormatStrW: {$IFDEF RICHVIEWCBDEF3}WideString{$ELSE}String{$ENDIF};
    {$IFDEF RICHVIEWCBDEF3}
    Charset: TFontCharset;
    {$ENDIF}
    RVType: TRVListType;
begin
  ConvMarker97(Reader, RTFLevel, RVType, FormatStr1, FormatStr2, FormatStrW);
  FontName := GetMarkerFontName(Reader, RTFLevel);
  {$IFDEF RICHVIEWCBDEF3}
  Charset  := GetMarkerCharset(Reader, RTFLevel);
  {$ENDIF}
  RVLevel.ListType := RVType;
  RVLevel.FormatString := FormatStr1;
  {$IFNDEF RVDONOTUSEUNICODE}
  RVLevel.FormatStringW := FormatStrW;
  {$ENDIF}
  RVLevel.MarkerAlignment := TRVMarkerAlignment(RTFLevel.Alignment);
  RVLevel.Font.Name := FontName;
  {$IFDEF RICHVIEWCBDEF3}
  RVLevel.Font.Charset  := Charset;
  {$ENDIF}
  RVLevel.Font.Style := RTFLevel.FontStyle;
  RVLevel.Font.Color := RTFLevel.Color;
  RVLevel.Font.Size  := RTFLevel.FontSize;
  RVLevel.LeftIndent := RVStyle.TwipsToUnits(RTFLevel.LeftIndentTw);
  RVLevel.MarkerIndent := RVStyle.TwipsToUnits(RTFLevel.FirstIndentTw)+RVLevel.LeftIndent;
  if RTFLevel.TabPosTw<>RV_UNDEFINED_TAB_POS then
    RVLevel.FirstIndent := RVStyle.TwipsToUnits(RTFLevel.TabPosTw)-RVLevel.LeftIndent
  else
    RVLevel.FirstIndent := 0;
  RVLevel.StartFrom   := RTFLevel.Start;
  if RTFLevel.NoRestart then
    RVLevel.Options := RVLevel.Options - [rvloLevelReset];
  if RTFLevel.Legal then
    RVLevel.Options := RVLevel.Options + [rvloLegalStyleNumbering];
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.MergeListTable97;
var i,j: Integer;
    RVLevel : TRVListLevel;
    RTFLevel: TRVRTFListLevel97;
    ListNo: Integer;
    ForbiddenStyles: TRVIntegerList;
begin
  if ParaStyleMode<>rvrsAddIfNeeded then
    exit;
  if ListTableMap97<>nil then
    exit;
  ListStylesCountBefore := RVStyle.ListStyles.Count;
  ForbiddenStyles := TRVIntegerList.Create;
  try
    ListTableMap97 := TRVIntegerList.Create;
    for i := 0 to Reader.ListTable.Count-1 do begin
      ListNo := FindListStyle97(Reader.ListTable[i], ForbiddenStyles);
      if ListNo>=0 then begin
        ListTableMap97.Add(ListNo);
        ForbiddenStyles.Add(ListNo);
        end
      else begin
        RVStyle.ListStyles.Add;
        RVStyle.ListStyles[RVStyle.ListStyles.Count-1].Standard := False;
        ListTableMap97.Add(RVStyle.ListStyles.Count-1);
        ForbiddenStyles.Add(RVStyle.ListStyles.Count-1);
        for j := 0 to Reader.ListTable[i].Count-1 do begin
          RTFLevel := Reader.ListTable[i].Items[j];
          RVLevel := RVStyle.ListStyles[RVStyle.ListStyles.Count-1].Levels.Add;
          CopyListLevel97(RVLevel, RTFLevel);
        end;
        CurrentRVData.AfterAddStyle(RVStyle.ListStyles[RVStyle.ListStyles.Count-1]);
      end;
    end;
  finally
    ForbiddenStyles.Free;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderProgress(Sender: TRVRTFReader;
  Stage: TRVRTFProgressStage; PercentDone: Byte);
begin
  RVData.DoProgress(rvloLoading, TRVProgressStage(Stage), PercentDone);
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.NewReaderText(Sender: TRVRTFReader;
  const Text: TRVAnsiString; Position: TRVRTFPosition);
var StyleNo : Integer;
    item    : TCustomRVItemInfo;
    s: TRVRawByteString;
begin
  if FSkipHiddenText and Reader.RTFState.CharProps.Hidden then
    exit;
  if LineBreaksAsParagraphs and (Position=rtf_ts_NewLine) then
    Position := rtf_ts_NewPara;
  StyleNo := ReturnStyleNo(UnicodeMode=rvruOnlyUnicode, False);
  {$IFNDEF RVDONOTUSETABS}
  if (RVStyle.SpacesInTab=0) and (Text=#09) then begin
    item := TRVTabItemInfo.Create(CurrentRVData);
    item.StyleNo := rvsTab;
    TRVTabItemInfo(item).TextStyleNo := StyleNo;
    TRVTabItemInfo(item).ParaNo := ReturnParaNo(Position);
    s := '';
    end
  else
  {$ENDIF}
    item := CreateTextItem(Text, {$IFDEF RICHVIEWCBDEF3} '',{$ENDIF}
      StyleNo, ReturnParaNo(Position), False, s);
  InsertItem(s, item, Position);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSESEQ}
procedure TRVRTFReaderProperties.NewReaderSeq(Sender: TRVRTFReader;
  Position: TRVRTFPosition;
  const SeqName: String; NumberingType: TRVRTFSeqType;
  Reset: Boolean; StartFrom: Integer);
var Item: TRVSeqItemInfo;
    s: TRVRawByteString;
    SeqName2: String;
begin
  if FSkipHiddenText and Reader.RTFState.CharProps.Hidden then
    exit;
  if LineBreaksAsParagraphs and (Position=rtf_ts_NewLine) then
    Position := rtf_ts_NewPara;
  if (CompareText(SeqName,RV_FOOTNOTE_SEQNAME)=0) or
     (CompareText(SeqName,RV_ENDNOTE_SEQNAME)=0) then
    SeqName2 := '_'+SeqName
  else
    SeqName2 := SeqName;
  Item := TRVSeqItemInfo.CreateEx(CurrentRVData, SeqName2,
    TRVSeqType(NumberingType), ReturnStyleNo(False, False), StartFrom, Reset);
  Item.ParaNo := ReturnParaNo(Position);
  Item.BeforeLoading(rvlfRTF);
  s := '';
  InsertItem(s, Item, Position);
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderNote(Sender: TRVRTFReader;
  What: TRVRTFNoteEventType; Position: TRVRTFPosition);
var NoteRef: TRVNoteReferenceItemInfo;
    EndNote: TRVEndnoteItemInfo;
    FootNote: TRVFootnoteItemInfo;
    s: TRVRawByteString;
    SubData: TSubDataInfo;
begin
  case What of
    rtf_ne_Character:
      begin
        if LineBreaksAsParagraphs and (Position=rtf_ts_NewLine) then
          Position := rtf_ts_NewPara;
        NoteRef := TRVNoteReferenceItemInfo.CreateEx(CurrentRVData,
          ReturnStyleNo(False, True));
        NoteRef.ParaNo := ReturnParaNo(Position);
        NoteRef.BeforeLoading(rvlfRTF);
        s := '';
        InsertItem(s, NoteRef, Position);
      end;
    rtf_ne_Start:
      begin
        if LastNoteRefIndex<0 then
          ReaderNote(Sender, rtf_ne_Character, Position);
        if LastNoteRefIndex<0 then
          exit;
        Footnote := TRVFootnoteItemInfo.CreateEx(CurrentRVData, 0, 1, False);
        Footnote.Assign(CurrentRVData.GetItem(LastNoteRefIndex));
        CurrentRVData.FreeItem(LastNoteRefIndex, False);
        Footnote.BeforeLoading(rvlfRTF);
        s := '';
        Footnote.Inserting(CurrentRVData, s, False);
        CurrentRVData.Items.Objects[LastNoteRefIndex] := Footnote;
        CurrentRVData.Items[LastNoteRefIndex] := s;
        CurrentRVData.AddSeqInList(LastNoteRefIndex);
        Footnote.Inserted(RVData, LastNoteRefIndex);
        if SubDataList=nil then
          SubDataList := TRVList.Create;
        SubData := TSubDataInfo.Create;
        SubData.PrevRVData := CurrentRVData;
        SubData.ParentRow := CurrentRow;
        SubData.ParentCol := CurrentCol;
        SubDataList.Add(SubData);
        CurrentRow := -1;
        CurrentCol := -1;
        CurrentRVData := Footnote.Document;
      end;
    rtf_ne_EndNote:
      begin
        if not (CurrentRVData is TRVNoteData) or (LastNoteRefIndex<0) then
          exit;
        SubData := TSubDataInfo(SubDataList[SubDataList.Count-1]);
        Endnote := TRVEndnoteItemInfo.CreateEx(SubData.PrevRVData, 0, 1, False);
        Endnote.Assign(SubData.PrevRVData.GetItem(LastNoteRefIndex));
        Endnote.SeqName := RV_ENDNOTE_SEQNAME;
        SubData.PrevRVData.FreeItem(LastNoteRefIndex, False);
        s := '';
        Endnote.Inserting(SubData.PrevRVData, s, False);
        SubData.PrevRVData.Items.Objects[LastNoteRefIndex] := Endnote;
        SubData.PrevRVData.Items[LastNoteRefIndex] := s;
        SubData.PrevRVData.AddSeqInList(LastNoteRefIndex);
        Endnote.Inserted(SubData.PrevRVData, LastNoteRefIndex);
        CurrentRVData := Endnote.Document;
        LastNoteRefIndex := -1;
      end;
    rtf_ne_End:
      begin
        if not (CurrentRVData is TRVNoteData) then
          exit;
        CurrentRVData.MassSimpleConcateAll;
        SubData := TSubDataInfo(SubDataList[SubDataList.Count-1]);
        CurrentRow := SubData.ParentRow;
        CurrentCol := SubData.ParentCol;
        CurrentRVData := SubData.PrevRVData;
        SubDataList.Delete(SubDataList.Count-1);
        LastNoteRefIndex := -1;
        if RVData=CurrentRVData then
          CurrentRVData.AfterReadNote(CurrentRVData, InsertPoint-1)
        else
          CurrentRVData.AfterReadNote(CurrentRVData, CurrentRVData.ItemCount-1)
      end;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderEndParsing(Sender: TObject);
{$IFNDEF RVDONOTUSEDOCPARAMS}
var DocParams: TRVDocParameters;
    RTFDocProps: TRVRTFDocProperties;
{$ENDIF}
begin
  if EditFlag then
    exit;
  {$IFNDEF RVDONOTUSEDOCPARAMS}
  if ReadDocParameters then begin
    DocParams := RVData.GetAbsoluteRootData.GetDocParameters(True);
    RTFDocProps := Reader.DocProps;
    DocParams.PageWidth := DocParams.FromTwips(RTFDocProps.PaperWidthTw);
    DocParams.PageHeight := DocParams.FromTwips(RTFDocProps.PaperHeightTw);
    DocParams.LeftMargin := DocParams.FromTwips(RTFDocProps.LeftMarginTw);
    DocParams.RightMargin := DocParams.FromTwips(RTFDocProps.RightMarginTw);
    DocParams.TopMargin := DocParams.FromTwips(RTFDocProps.TopMarginTw);
    DocParams.BottomMargin := DocParams.FromTwips(RTFDocProps.BottomMarginTw);
    DocParams.ZoomPercent := RTFDocProps.ViewScale;
    case RTFDocProps.ZoomKind of
      rtf_zk_None:
        DocParams.ZoomMode := rvzmCustom;
      rtf_zk_FullPage:
        DocParams.ZoomMode := rvzmFullPage;
      rtf_zk_BestFit:
        DocParams.ZoomMode := rvzmPageWidth;
    end;
    DocParams.MirrorMargins := RTFDocProps.MirrorMargins;
    DocParams.Author := RTFDocProps.Author;
    DocParams.Title  := RTFDocProps.Title;
    DocParams.Comments := RTFDocProps.Comments;
    if RTFDocProps.Landscape then
      DocParams.Orientation := poLandscape
    else
      DocParams.Orientation := poPortrait;
    if Reader.RTFState.SectProps.FooterYTw>0 then
      DocParams.FooterY := DocParams.FromTwips(Reader.RTFState.SectProps.FooterYTw);
    if Reader.RTFState.SectProps.HeaderYTw>0 then
      DocParams.HeaderY := DocParams.FromTwips(Reader.RTFState.SectProps.HeaderYTw);
  end;
  {$ENDIF}
  {$IFDEF RICHVIEW_DPMARGINS}
  if not EditFlag then begin
    if Reader.RTFState.DocProps.LeftMarginTw>0 then
      RVData.GetAbsoluteRootData.GetDocProperties.Values['LeftMarginMM'] :=
        IntToStr(Round(Reader.RTFState.DocProps.LeftMarginTw*127/(1440*5)));
    if Reader.RTFState.DocProps.TopMarginTw>0 then
      RVData.GetAbsoluteRootData.GetDocProperties.Values['TopMarginMM'] :=
        IntToStr(Round(Reader.RTFState.DocProps.TopMarginTw*127/(1440*5)));
    if Reader.RTFState.DocProps.RightMarginTw>0 then
      RVData.GetAbsoluteRootData.GetDocProperties.Values['RightMarginMM'] :=
        IntToStr(Round(Reader.RTFState.DocProps.RightMarginTw*127/(1440*5)));
    if Reader.RTFState.DocProps.BottomMarginTw>0 then
      RVData.GetAbsoluteRootData.GetDocProperties.Values['BottomMarginMM'] :=
        IntToStr(Round(Reader.RTFState.DocProps.BottomMarginTw*127/(1440*5)));
  end;
  {$ENDIF}
  if not IgnoreNotes then
    RVData.GetRVStyle.FootnotePageReset := Reader.DocProps.FootnotePageRestart;
end;
{------------------------------------------------------------------------------}
{$IFDEF RICHVIEWCBDEF3}
procedure TRVRTFReaderProperties.NewReaderUnicodeText(Sender: TRVRTFReader;
  const Text: TRVUnicodeString; Position: TRVRTFPosition);
var StyleNo : Integer;
    item    : TCustomRVItemInfo;
    s,s2: TRVRawByteString;
    CodePage: TRVCodePage;
    Unicode: Boolean;
    FontIndex: Integer;
begin
  if FSkipHiddenText and Reader.RTFState.CharProps.Hidden then
    exit;
  if LineBreaksAsParagraphs and (Position=rtf_ts_NewLine) then
    Position := rtf_ts_NewPara;
  s2 := '';
  Unicode := UnicodeMode in [rvruOnlyUnicode, rvruMixed];
  if UnicodeMode = rvruMixed then begin
    FontIndex := Reader.RTFState.CharProps.FontIndex;
    if (FontIndex>=0) and (FontIndex<Reader.FontTable.Count) then begin
      CodePage := RVU_Charset2CodePage(Reader.FontTable[FontIndex].Charset);
      if CodePage=CP_ACP then
        CodePage := Reader.CodePage;
      s2 := RVU_GetRawUnicode(Text);
      if (CodePage<>CP_ACP) and RVU_CanBeConvertedToAnsi(CodePage, s2) then begin
        s2 := RVU_UnicodeToAnsi(CodePage, s2);
        Unicode := False;
      end;
    end;
  end;
  StyleNo := ReturnStyleNo(Unicode, False);
  {$IFNDEF RVDONOTUSETABS}
  if (RVStyle.SpacesInTab=0) and (Text=#09) then begin
    item := TRVTabItemInfo.Create(CurrentRVData);
    item.StyleNo := rvsTab;
    TRVTabItemInfo(item).TextStyleNo := StyleNo;
    TRVTabItemInfo(item).ParaNo := ReturnParaNo(Position);
    s := '';
    end
  else
  {$ENDIF}
  begin
    if Unicode then
      item := CreateTextItem('', Text, StyleNo, ReturnParaNo(Position), True, s)
    else
      item := CreateTextItem(s2, '', StyleNo, ReturnParaNo(Position), False, s)
  end;
  InsertItem(s, item, Position);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderHeaderFooter(Sender: TRVRTFReader;
  HFType: TRVRTFHeaderFooterType; Starting: Boolean;
  var Supported: Boolean);
begin
  // 1 twip = 20 points = 1/1440 inch
  Supported := False;
  if Starting then begin
    case HFType of
      rtf_hf_Header:
        begin
          if FHeaderRVData<>nil then begin
            CurrentRVData := FHeaderRVData;
            CurrentRVData.Clear;
            Supported := True;
            Self.HFType := HFType;
          end;
          FHeaderYMM := Round(Reader.RTFState.SectProps.HeaderYTw*127/(1440*5));
        end;
      rtf_hf_Footer:
        begin
          if FFooterRVData<>nil then begin
            CurrentRVData := FFooterRVData;
            CurrentRVData.Clear;
            Supported := True;
            Self.HFType := HFType;
          end;
          FFooterYMM := Round(Reader.RTFState.SectProps.FooterYTw*127/(1440*5));          
        end;
    end;
    end
  else begin
    CurrentRVData.MassSimpleConcateAll;
    CurrentRVData := RVData;
    Self.HFType := rtf_hf_MainText;
  end;
  RVStyle := CurrentRVData.GetRVStyle;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderBookmarkStart(Sender: TRVRTFReader;
  const BookmarkName: String);
begin
  FBookmarkName := BookmarkName;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderTranslateKeyword(Sender: TRVRTFReader;
  const Keyword: TRVAnsiString; Param: integer; fParam: boolean;
  var Text: TRVAnsiString; var DoDefault: Boolean);
begin
  //method could be overwritten be descandent classes to return
  //different text for specific keywords not handled by the reader
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.ReaderPageBreak(Sender: TObject);
begin
  PageBreakRVData := CurrentRVData;
  PageBreak := True;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.InitReader;
begin
  PixelsPerTwip := RV_GetPixelsPerInch / (72*20);
  RVStyle := RVData.GetRVStyle;
  Reader.PixelsPerInch := RV_GetPixelsPerInch;
  Reader.ConvertHighlight := TRVRTFHighlightConvert(ConvertHighlight);
  Reader.BasePath := BasePath;
  Reader.ExtractMetafileBitmaps := ExtractMetafileBitmaps;
  HFType := rtf_hf_MainText;
  {$IFNDEF RVDONOTUSELISTS}
  Reader.OnUpdateMarker := ReaderUpdateMarker;
  LastMarkerIndex := -1;
  LevelToListNo := TRVIntegerList.Create;
  {$ENDIF}
  {$IFDEF RVRECHECKRTFPARA}
  FFirstParaInserted := False;
  {$ENDIF}
  {$IFNDEF RVDONOTUSESEQ}
  if not IgnoreSequences then
    Reader.OnNewSeq := NewReaderSeq;
  if not IgnoreNotes then
    Reader.OnNote := ReaderNote;
  LastNoteRefIndex := -1;
  {$ENDIF}
  Reader.OnNewText := NewReaderText;
  {$IFNDEF RVDONOTUSEUNICODE}
  if UnicodeMode in [rvruMixed, rvruOnlyUnicode] then
    Reader.OnNewUnicodeText := NewReaderUnicodeText;
  {$ENDIF}
  if not IgnorePictures then begin
    Reader.OnNewPicture := NewReaderPicture;
    Reader.OnImportPicture := ReaderImportPicture;
  end;
  if RVData.IsAssignedOnProgress then
    Reader.OnProgress := ReaderProgress
  else
    Reader.OnProgress := nil;
  Reader.OnTranslateKeyword := ReaderTranslateKeyword;
  {$IFNDEF RVDONOTUSEOLECONTAINER}
  (*
  Reader.OnNewObject := NewReaderObject;
  *)
  {$ENDIF}
  Reader.DefCodePage := RVData.GetDefaultCodePage;
  Reader.OnRequiredPageBreak := ReaderPageBreak;
  Reader.TabAsSeparateChar := RVStyle.SpacesInTab=0;
  Reader.OnEndParsing := ReaderEndParsing;
  {$IFNDEF RVDONOTUSETABLES}
  if not FIgnoreTables then
    Reader.OnTable     := ReaderTable;
  {$ENDIF}
  PageBreak := False;
  PageBreakRVData := nil;
  NonFirstItemsAdded := 0;
  FirstTime := True;
  FailedBecauseOfProtect := False;
  FullReformat := False;
  SubDataList    := nil;
  CurrentRVData := RVData;
  CurrentRow := -1;
  CurrentCol := -1;
  FEmptyPara := -1;
  FHeaderYMM := -1;
  FFooterYMM := -1;
  if not EditFlag then begin
    if ((FHeaderRVData<>nil) or (FFooterRVData<>nil)) then
      Reader.OnHeaderFooter := ReaderHeaderFooter;
    if (FHeaderRVData<>nil) then
      FHeaderRVData.Clear;
    if (FFooterRVData<>nil) then
      FFooterRVData.Clear;
  end;
  {$IFNDEF RVDONOTUSELISTS}
  ListStylesCountBefore := 0;
  {$ENDIF}
  FBookmarkName := '';
  if not IgnoreBookmarks then
    Reader.OnBookmarkStart := ReaderBookmarkStart;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.DoneReader;
begin
  {$IFNDEF RVDONOTUSELISTS}
  ReaderUpdateMarker(nil);
  {$ENDIF}
  SubDataList.Free;
  SubDataList := nil;
  {$IFNDEF RVDONOTUSELISTS}
  LevelToListNo.Free;
  LevelToListNo := nil;
  ListTableMap97.Free;
  ListTableMap97 := nil;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.CurrentBorder(
  var RVBorderStyle: TRVBorderStyle; var RVBorderWidth,
  RVBorderIntWidth: TRVStyleLength; var RVBorderColor: TColor;
  var RVBorderOffs: TRVRect);
var side: TRVRTFSide;
begin
  with Reader.RTFState.ParaProps do begin
    if HasBorder then
      with Border do begin
        RVBorderOffs := TRVRect.Create;
        RVBorderOffs.Left   := RVStyle.TwipsToUnits(Sides[rtf_side_Left  ].SpaceTw);
        RVBorderOffs.Top    := RVStyle.TwipsToUnits(Sides[rtf_side_Top   ].SpaceTw);
        RVBorderOffs.Right  := RVStyle.TwipsToUnits(Sides[rtf_side_Right ].SpaceTw);
        RVBorderOffs.Bottom := RVStyle.TwipsToUnits(Sides[rtf_side_Bottom].SpaceTw);
        if Sides[rtf_side_Top].BorderType<>rtf_brdr_None then
          side := rtf_side_Top
        else if Sides[rtf_side_Left].BorderType<>rtf_brdr_None then
          side := rtf_side_Left
        else   if Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None then
          side := rtf_side_Bottom
        else
          side := rtf_side_Right;
        RVBorderColor := Sides[side].Color;
        BorderRTF2RV(Sides[side].BorderType, Sides[side].WidthTw,
          RVBorderStyle, RVBorderWidth, RVBorderIntWidth,
          RVStyle, side in [rtf_side_Bottom, rtf_side_Right]);
      end
    else begin
      RVBorderStyle := rvbNone;
      RVBorderWidth := 0;
      RVBorderIntWidth := 0;
      RVBorderColor   := clNone;
      RVBorderOffs := nil;
    end;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSETABS}
function GetTabLeaderChar(RTFLeader: TRVRTFTabLeader): String;
begin
  case RTFLeader of
    rtf_tl_Dot:       Result := '.';
    rtf_tl_MiddleDot: Result := RVCHAR_MIDDLEDOT;
    rtf_tl_Hyphen:    Result := '-';
    rtf_tl_Underline: Result := '_';
    rtf_tl_EqualSign: Result := '=';
    else              Result := '';
  end;
end;
{------------------------------------------------------------------------------}
function GetRVTabAlign(Align: TRVRTFTabAlign): TRVTabAlign;
begin
  case Align of
    rtf_tab_Right, rtf_tab_Decimal: Result := rvtaRight;
    rtf_tab_Center: Result := rvtaCenter;
    else            Result := rvtaLeft;
  end;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
const NONRTFPARAOPTIONS = [rvpaoNoWrap,rvpaoReadOnly,rvpaoStyleProtect,rvpaoDoNotWantReturns];
function TRVRTFReaderProperties.FindBestParaNo: Integer;
var i: Integer;
    Para: TParaInfo;
    w, bw, maxw,LS: Integer;
    RVBorderStyle: TRVBorderStyle;
    RVBorderWidth, RVBorderIntWidth: TRVStyleLength;
    RVBorderOffs: TRVRect;
    {..........................................................}
    function CompareBorderSide( RVBorder:TRVBorder;
      RVBorderStyle: TRVBorderStyle; RVBorderWidth,RVBorderIntWidth: TRVStyleLength;
      RVBorderColor: TColor; SideVisible: Boolean): Integer;

    begin
      Result := 0;
      with Reader.RTFState.ParaProps do
        if HasBorder and (RVBorderStyle<>rvbNone) then begin
          if (RVBorder.Style=rvbNone) or not SideVisible then
            exit;
          inc(Result, RVSMW_BORDERSIDE);
          inc(Result, RV_CompareInts(RVStyle.TwipsToUnits(RVBorderWidth),
            RVStyle.TwipsToUnits(RVBorder.Width), RVSMW_WIDTH div 15));
          inc(Result, RV_CompareInts(RVStyle.TwipsToUnits(RVBorderIntWidth),
            RVStyle.TwipsToUnits(RVBorder.InternalWidth), RVSMW_WIDTH));
          inc(Result, RV_CompareColors(RVBorder.Color, RVBorderColor, RVSMW_EACHRGBCOLOR, RVSMW_COLORSET));
          if RVBorderStyle=RVBorder.Style then
            inc(Result, RVSMW_BORDERSTYLE);
          end
        else
          if (RVBorder.Style=rvbNone) or not SideVisible then
            inc(Result, RVSMW_BORDERNOSIDE);
    end;
    {..........................................................}
    function CompareLS: Integer;
    begin
      case Para.LineSpacingType of
        rvlsPercent:
          if not Reader.RTFState.ParaProps.LineSpacingMulti then
            Result := - 4*RVSMW_LINESPACING
          else
            Result := RV_CompareInts(LS, Para.LineSpacing, RVSMW_LINESPACING);
        rvlsLineHeightAtLeast:
          if Reader.RTFState.ParaProps.LineSpacingMulti then
            Result := - 4*RVSMW_LINESPACING
          else if LS<0 then
            Result := - 3*RVSMW_LINESPACING
          else
            Result := RV_CompareInts(LS, RVStyle.GetAsTwips(Para.LineSpacing), RVSMW_LINESPACING div 15);
        rvlsLineHeightExact:
          if Reader.RTFState.ParaProps.LineSpacingMulti then
            Result := - 4*RVSMW_LINESPACING
          else if LS>0 then
            Result := - 3*RVSMW_LINESPACING
          else
            Result := RV_CompareInts(-LS, RVStyle.GetAsTwips(Para.LineSpacing), RVSMW_LINESPACING div 15);
        else
          Result := - 4*RVSMW_LINESPACING;
      end;
    end;
    {..........................................................}
    {$IFNDEF RVDONOTUSETABS}
    function CompareTabs(RVTabs: TRVTabInfos; RTFTabs: TRVRTFTabList): Integer;
    var i: Integer;
        RVTab: TRVTabInfo;
        RTFTab: TRVRTFTab;
        MinCount: Integer;
    begin
      Result := 0;
      if RVStyle.SpacesInTab>0 then
        exit;
      if RVTabs.Count<RTFTabs.Count then
        MinCount := RVTabs.Count
      else
        MinCount := RTFTabs.Count;
      for i := 0 to MinCount-1 do begin
        RVTab := RVTabs[i];
        RTFTab := RTFTabs[i];
        inc(Result, RV_CompareInts(RTFTab.PositionTW, RVStyle.GetAsTwips(RVTab.Position),  RVSMW_TABPOS div 15));
        if GetRVTabAlign(RTFTab.Align) = RVTab.Align then
          inc(Result, RVSMW_TABALIGN);
        if GetTabLeaderChar(RTFTab.Leader) = RVTab.Leader then
          inc(Result, RVSMW_LEADER);
      end;
      dec(Result, (RVTabs.Count-MinCount)*RVSMW_NOTAB);
      dec(Result, (RTFTabs.Count-MinCount)*RVSMW_NOTAB);
    end;
    {$ENDIF}
    {..........................................................}
begin
  Result := 0;
  maxw   := 0;

  with Reader.RTFState.ParaProps do begin
     if LineSpacingMulti then
       LS := LineSpacing * 100 div 240
     else
       LS := LineSpacing;
    if HasBorder then begin
        RVBorderOffs := TRVRect.Create;
        RVBorderOffs.Left   := RVStyle.TwipsToUnits(Border.Sides[rtf_side_Left  ].SpaceTw);
        RVBorderOffs.Top    := RVStyle.TwipsToUnits(Border.Sides[rtf_side_Top   ].SpaceTw);
        RVBorderOffs.Right  := RVStyle.TwipsToUnits(Border.Sides[rtf_side_Right ].SpaceTw);
        RVBorderOffs.Bottom := RVStyle.TwipsToUnits(Border.Sides[rtf_side_Bottom].SpaceTw);
      end
    else
      RVBorderOffs := nil;
    for i := 0 to RVStyle.ParaStyles.Count-1 do begin
      if not AllowUseStyle(i, False) then
        continue;
      Para := RVStyle.ParaStyles[i];
      bw := Para.Border.GetTotalWidth;
      w := 0;
      if ord(Para.Alignment)=ord(Alignment) then
        inc(w, RVSMW_ALIGNMENT);
      if (CurrentRVData.GetBiDiMode<>rvbdUnspecified) and
        (ord(Para.BiDiMode)=ord(BiDiMode)) then
        inc(w, RVSMW_PARABIDIMODE);
      if Para.Options*NONRTFPARAOPTIONS<>[] then
        dec(w, RVSMW_PROTECTION);
      inc(w, RV_CompareInts(LeftIndentTw+bw,  RVStyle.GetAsTwips(Para.LeftIndent),  RVSMW_INDENT div 15));
      inc(w, RV_CompareInts(RightIndentTw+bw, RVStyle.GetAsTwips(Para.RightIndent), RVSMW_INDENT div 15));
      inc(w, RV_CompareInts(FirstIndentTw, RVStyle.GetAsTwips(Para.FirstIndent), RVSMW_INDENT div 15));
      inc(w, RV_CompareInts(SpaceBeforeTw+bw, RVStyle.GetAsTwips(Para.SpaceBefore), RVSMW_INDENT div 15));
      inc(w, RV_CompareInts(SpaceAfterTw+bw,  RVStyle.GetAsTwips(Para.SpaceAfter),  RVSMW_INDENT div 15));
      if Para.OutlineLevel=OutlineLevel then
        inc(w, RVSMW_OUTLINELEVEL);
      inc(w, RV_CompareColors(Para.Background.Color, Color, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET));
      if (rvpaoKeepLinesTogether in Para.Options) = KeepLinesTogether then
        inc(w, RVSMW_KEEPLINESTOGETHER);
      if (rvpaoKeepWithNext in Para.Options) = KeepWithNext then
        inc(w, RVSMW_KEEPWITHNEXT);
      inc(w, CompareLS);
      if HasBorder then begin
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Left),
          RVStyle.GetAsTwips(Para.Border.BorderOffsets.Left),   RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Top),
          RVStyle.GetAsTwips(Para.Border.BorderOffsets.Top),    RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Right),
          RVStyle.GetAsTwips(Para.Border.BorderOffsets.Right),  RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Bottom),
          RVStyle.GetAsTwips(Para.Border.BorderOffsets.Bottom), RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Left),
          RVStyle.GetAsTwips(Para.Background.BorderOffsets.Left),   RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Top),
          RVStyle.GetAsTwips(Para.Background.BorderOffsets.Top),    RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Right),
          RVStyle.GetAsTwips(Para.Background.BorderOffsets.Right),  RVSMW_INDENT div 15));
        inc(w, RV_CompareInts(RVStyle.GetAsTwips(RVBorderOffs.Bottom),
          RVStyle.GetAsTwips(Para.Background.BorderOffsets.Bottom), RVSMW_INDENT div 15));
        BorderRTF2RV(Border.Sides[rtf_side_Left].BorderType, Border.Sides[rtf_side_Left].WidthTw,
          RVBorderStyle, RVBorderWidth, RVBorderIntWidth,
          RVStyle, False);
        inc(w, CompareBorderSide(Para.Border, RVBorderStyle, RVBorderWidth,
          RVBorderIntWidth, Border.Sides[rtf_side_Left].Color,
          Para.Border.VisibleBorders.Left));
        BorderRTF2RV(Border.Sides[rtf_side_Top].BorderType, Border.Sides[rtf_side_Top].WidthTw,
          RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVStyle, False);
        inc(w, CompareBorderSide(Para.Border, RVBorderStyle, RVBorderWidth,
          RVBorderIntWidth, Border.Sides[rtf_side_Top].Color,
          Para.Border.VisibleBorders.Top));
        BorderRTF2RV(Border.Sides[rtf_side_Right].BorderType, Border.Sides[rtf_side_Right].WidthTw,
          RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVStyle, True);
        inc(w, CompareBorderSide(Para.Border, RVBorderStyle, RVBorderWidth,
          RVBorderIntWidth, Border.Sides[rtf_side_Right].Color,
          Para.Border.VisibleBorders.Right));
        BorderRTF2RV(Border.Sides[rtf_side_Bottom].BorderType, Border.Sides[rtf_side_Bottom].WidthTw,
          RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVStyle, True);
        inc(w, CompareBorderSide(Para.Border, RVBorderStyle, RVBorderWidth,
          RVBorderIntWidth, Border.Sides[rtf_side_Bottom].Color,
          Para.Border.VisibleBorders.Bottom));
        {$IFNDEF RVDONOTUSETABS}
        inc(w, CompareTabs(Para.Tabs, Tabs));
        {$ENDIF}
        end
      else
        if Para.Border.Style=rvbNone then
          inc(w, RVSMW_BORDERNOSIDE);
      if w>maxw then begin
        Result := i;
        maxw := w;
      end;
    end;
    RVBorderOffs.Free;
  end;
end;
{------------------------------------------------------------------------------}
function GetRVBorderTotalWidth(RVBorderStyle: TRVBorderStyle;
  RVBorderWidth, RVBorderIntWidth: TRVStyleLength): TRVStyleLength;
begin
  case RVBorderStyle of
    rvbSingle:
      Result := RVBorderWidth;
    rvbDouble:
      Result := 2*RVBorderWidth+RVBorderIntWidth;
    rvbTriple:
      Result := 3*RVBorderWidth+2*RVBorderIntWidth;
    rvbThickInside, rvbThickOutside:
      Result := 3*RVBorderWidth+RVBorderIntWidth;
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
procedure AdjustIndents(RVBorderStyle: TRVBorderStyle;
  RVBorderWidth, RVBorderIntWidth: Integer; RVBorderOffs: TRVRect;
   var LeftIndent, RightIndent, SpaceBefore, SpaceAfter: TRVStyleLength);
var w: Integer;
begin
 if RVBorderOffs<>nil then begin
   w := GetRVBorderTotalWidth(RVBorderStyle, RVBorderWidth, RVBorderIntWidth)-1;
   if LeftIndent<RVBorderOffs.Left+w then
     LeftIndent := RVBorderOffs.Left+w;
   if SpaceBefore<RVBorderOffs.Top+w then
     SpaceBefore := RVBorderOffs.Top+w;
   if RightIndent<RVBorderOffs.Right+w then
     RightIndent := RVBorderOffs.Right+w;
   if SpaceAfter<RVBorderOffs.Bottom+w then
     SpaceAfter := RVBorderOffs.Bottom+w;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.FindParaNo(RVBorderStyle: TRVBorderStyle;
  RVBorderWidth, RVBorderIntWidth: Integer; RVBorderColor: TColor;
  RVBorderOffs: TRVRect): Integer;
    {..........................................................}
    function EqualBorders(RVBorder:TRVBorder; RVBackground: TRVBackgroundRect;
      RVBorderStyle: TRVBorderStyle;
      RVBorderWidth,RVBorderIntWidth: Integer; RVBorderColor: TColor;
      RVBorderOffs: TRVRect):Boolean;

    begin
      with Reader.RTFState.ParaProps do
        if HasBorder then
        Result := (RVBorder.Style=RVBorderStyle) and
                  (RVBorder.Width=RVBorderWidth) and
                  ((RVBorder.InternalWidth=RVBorderIntWidth) or (RVBorderStyle=rvbSingle)) and
                  (RVBorder.Color=RVBorderColor) and
                  (RVBorder.VisibleBorders.Left   = (Border.Sides[rtf_side_Left].BorderType<>rtf_brdr_None))  and
                  (RVBorder.VisibleBorders.Top    = (Border.Sides[rtf_side_Top].BorderType<>rtf_brdr_None))   and
                  (RVBorder.VisibleBorders.Right  = (Border.Sides[rtf_side_Right].BorderType<>rtf_brdr_None)) and
                  (RVBorder.VisibleBorders.Bottom = (Border.Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None)) and
                  (RVBorderOffs<>nil) and RVBorder.BorderOffsets.IsEqual(RVBorderOffs) and
                  RVBorder.BorderOffsets.IsEqual(RVBackground.BorderOffsets)
      else
        Result := RVBorder.Style=rvbNone;
    end;
    {..........................................................}
    function EqualLS(Para: TParaInfo; LS: Integer; LSMulti: Boolean): Boolean;
    begin
      case Para.LineSpacingType of
        rvlsPercent:
          if not LSMulti then
            Result := False
          else
            Result := LS=Para.LineSpacing;
        rvlsSpaceBetween:
          Result := False;
        rvlsLineHeightAtLeast:
          if LSMulti then
            Result := False
          else
            Result := (LS>0) and (LS=RVStyle.GetAsTwips(Para.LineSpacing));
        rvlsLineHeightExact:
          if LSMulti then
            Result := False
          else
            Result := (LS<0) and (-LS=RVStyle.GetAsTwips(Para.LineSpacing));
        else
          Result := False;
      end;
    end;
    {..........................................................}
    {$IFNDEF RVDONOTUSETABS}
    function EqualTabs(RVTabs: TRVTabInfos; RTFTabs: TRVRTFTabList): Boolean;
    var i: Integer;
        RVTab: TRVTabInfo;
        RTFTab: TRVRTFTab;
    begin
      if RVStyle.SpacesInTab>0 then begin
        Result := True;
        exit;
      end;
      Result := RVTabs.Count=RTFTabs.Count;
      if not Result then
        exit;
      for i := 0 to RTFTabs.Count-1 do begin
        RVTab := RVTabs[i];
        RTFTab := RTFTabs[i];
        Result :=
          (RTFTab.PositionTw = RVStyle.GetAsTwips(RVTab.Position)) and
          (GetRVTabAlign(RTFTab.Align)     = RVTab.Align) and
          (GetTabLeaderChar(RTFTab.Leader) = RVTab.Leader);
        if not Result then
          exit;
      end;
    end;
    {$ENDIF}
    {..........................................................}
var i: Integer;
    Para: TParaInfo;
    LeftIndent, RightIndent, FirstIndent, SpaceBefore, SpaceAfter: TRVStyleLength;
    LS: Integer;
    LSMulti: Boolean;
    LBiDiMode: TRVBiDiMode;
begin
  Result := -1;
  with Reader.RTFState.ParaProps do begin
   LeftIndent   := LeftIndentTw;
   RightIndent  := RightIndentTw;
   FirstIndent  := FirstIndentTw;
   SpaceBefore  := SpaceBeforeTw;
   SpaceAfter   := SpaceAfterTw;
   LBiDiMode := TRVBiDiMode(BiDiMode);
   if CurrentRVData.GetBiDiMode=rvbdUnspecified then
     LBiDiMode := rvbdUnspecified;
   AdjustIndents(RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVBorderOffs,
     LeftIndent, RightIndent, SpaceBefore, SpaceAfter);
   LSMulti := LineSpacingMulti;
   if LSMulti then
     LS := LineSpacing * 100 div 240
   else begin
     LS := LineSpacing;
     if LS<MINEXACTLINESPACING then begin
       LS := 100;
       LSMulti := True;
     end;
   end;
   for i := 0 to RVStyle.ParaStyles.Count-1 do begin
     Para := RVStyle.ParaStyles[i];
     if (ord(Para.Alignment)=ord(Alignment)) and
        (RVStyle.GetAsTwips(Para.LeftIndent) = LeftIndent) and
        (RVStyle.GetAsTwips(Para.RightIndent) = RightIndent) and
        (RVStyle.GetAsTwips(Para.FirstIndent) = FirstIndent) and
        (RVStyle.GetAsTwips(Para.SpaceBefore) = SpaceBefore) and
        (RVStyle.GetAsTwips(Para.SpaceAfter)  = SpaceAfter) and
        (Para.OutlineLevel = OutlineLevel) and
        (Para.Background.Color = Color) and
        (Para.BiDiMode = LBiDiMode) and
        (Para.Options*NONRTFPARAOPTIONS = []) and
        ((rvpaoKeepLinesTogether in Para.Options) = KeepLinesTogether) and
        ((rvpaoKeepWithNext in Para.Options) = KeepWithNext) and
        EqualLS(Para,LS, LSMulti) and
        {$IFNDEF RVDONOTUSETABS}
        EqualTabs(Para.Tabs, Tabs) and
        {$ENDIF}
        EqualBorders(Para.Border, Para.Background, RVBorderStyle, RVBorderWidth,
          RVBorderIntWidth, RVBorderColor, RVBorderOffs)
       then begin
         Result := i;
         break;
       end;
     end;
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSETABLES}
function TRVRTFReaderProperties.GetEmptyStyleNo: Integer;
begin
  case TextStyleMode of
    rvrsUseSpecified:
      Result := TextStyleNo;
    else
      Result := 0;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.GetEmptyParaNo(Alignment: TRVAlignment;
  LeftIndentTw: Integer): Integer;
var pi: TParaInfo;
begin
  if (Alignment=rvaLeft) and (LeftIndentTw=0) and (FEmptyPara>=0) then begin
    Result := FEmptyPara;
    exit;
  end;
  case ParaStyleMode of
    rvrsUseSpecified:
      Result := ParaStyleNo;
    rvrsUseClosest:
      Result := 0;
    else
      begin
        pi := RVStyle.ParaStyles[0];
        if (RVStyle.GetAsTwips(pi.LeftIndent)=LeftIndentTw) and
           (pi.RightIndent=0) and
           (pi.FirstIndent=0) and
           (pi.Alignment=Alignment) then
          Result := 0
        else begin
          pi := TParaInfo.Create(nil);
          try
            pi.Assign(RVStyle.ParaStyles[0]);
            pi.LeftIndent  := RVStyle.TwipsToUnits(LeftIndentTw);
            pi.RightIndent := 0;
            pi.FirstIndent := 0;
            pi.Alignment   := Alignment;
            Result := RVStyle.ParaStyles.FindSuchStyle(0,pi,RVAllParaInfoProperties);
            if Result=-1 then begin
              RVStyle.ParaStyles.Add.Assign(pi);
              Result := RVStyle.ParaStyles.Count-1;
              RVStyle.ParaStyles[Result].Standard := False;
              CurrentRVData.AfterAddStyle(RVStyle.ParaStyles[Result]);
            end;
          finally
            pi.Free;
          end;
        end;
      end;
  end;
  if (Alignment=rvaLeft) and (LeftIndentTw=0) then
    FEmptyPara := Result;
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.AddPara(RVBorderStyle: TRVBorderStyle;
  RVBorderWidth, RVBorderIntWidth: TRVStyleLength; RVBorderColor: TColor;
  RVBorderOffs: TRVRect);
var Para: TParaInfo;
    LeftIndent, RightIndent, SpaceBefore, SpaceAfter: TRVStyleLength;
    {$IFNDEF RVDONOTUSETABS}
    i: Integer;
    RVTab: TRVTabInfo;
    {$ENDIF}
begin
  Para := TParaInfo(RVStyle.ParaStyles.Add);
  Para.Standard := False;
  with Reader.RTFState.ParaProps do begin
    Para.Alignment   := TRVAlignment(Alignment);
    Para.FirstIndent := RVStyle.TwipsToUnits(FirstIndentTw);
    LeftIndent  := RVStyle.TwipsToUnits(LeftIndentTw);
    RightIndent := RVStyle.TwipsToUnits(RightIndentTw);
    SpaceBefore := RVStyle.TwipsToUnits(SpaceBeforeTw);
    SpaceAfter  := RVStyle.TwipsToUnits(SpaceAfterTw);
    AdjustIndents(RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVBorderOffs,
      LeftIndent, RightIndent, SpaceBefore, SpaceAfter);
    Para.LeftIndent  := LeftIndent;
    Para.RightIndent := RightIndent;
    Para.SpaceBefore := SpaceBefore;
    Para.SpaceAfter  := SpaceAfter;
    Para.OutlineLevel := OutlineLevel;
    if CurrentRVData.GetBiDiMode<>rvbdUnspecified then
      Para.BiDiMode := TRVBiDiMode(BiDiMode);
    if LineSpacingMulti then begin
      Para.LineSpacing := LineSpacing*100 div 240;
      //Para.LineSpacingType := rvlsPercent; // default
      end
    else if LineSpacing>0 then begin
      Para.LineSpacing := RVStyle.TwipsToUnits(LineSpacing);
      Para.LineSpacingType := rvlsLineHeightAtLeast;
      end
    else begin
      Para.LineSpacing := RVStyle.TwipsToUnits(-LineSpacing);
      if RVStyle.GetAsPixels(Para.LineSpacing)<MINEXACTLINESPACING then begin
        Para.LineSpacing := 100;
        Para.LineSpacingType := rvlsPercent;
        end
      else
        Para.LineSpacingType := rvlsLineHeightExact;
    end;
    Para.Background.Color := Color;
    if KeepLinesTogether then
      Para.Options := Para.Options + [rvpaoKeepLinesTogether];
    if KeepWithNext then
      Para.Options := Para.Options + [rvpaoKeepWithNext];
    {$IFNDEF RVDONOTUSETABS}
    if HasTabs then
      for i := 0 to Tabs.Count-1 do begin
        RVTab := Para.Tabs.Add;
        RVTab.Position := RVStyle.TwipsToUnits(Tabs[i].PositionTw);
        RVTab.Leader   := GetTabLeaderChar(Tabs[i].Leader);
        RVTab.Align    := GetRVTabAlign(Tabs[i].Align);
      end;
    {$ENDIF}
    if HasBorder then begin
      Para.Border.Style         := RVBorderStyle;
      Para.Border.Width         := RVBorderWidth;
      Para.Border.InternalWidth := RVBorderIntWidth;
      with Border do begin
        Para.Border.Color         := RVBorderColor;
        Para.Border.VisibleBorders.Left   := Sides[rtf_side_Left].BorderType  <>rtf_brdr_None;
        Para.Border.VisibleBorders.Top    := Sides[rtf_side_Top].BorderType   <>rtf_brdr_None;
        Para.Border.VisibleBorders.Right  := Sides[rtf_side_Right].BorderType <>rtf_brdr_None;
        Para.Border.VisibleBorders.Bottom := Sides[rtf_side_Bottom].BorderType<>rtf_brdr_None;
      end;
      if RVBorderOffs<>nil then begin
        Para.Border.BorderOffsets.Assign(RVBorderOffs);
        Para.Background.BorderOffsets.Assign(RVBorderOffs);
      end;
    end;
  end;
  CurrentRVData.AfterAddStyle(Para);
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.ReturnParaNo_: Integer;
var RVBorderStyle: TRVBorderStyle;
    RVBorderWidth, RVBorderIntWidth: TRVStyleLength;
    RVBorderColor: TColor;
    RVBorderOffs: TRVRect;
begin
  case ParaStyleMode of
    rvrsUseSpecified:
      Result := ParaStyleNo;
    rvrsUseClosest:
      Result := FindBestParaNo;
    else
      begin
        CurrentBorder(RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVBorderColor,
          RVBorderOffs);
        Result := FindParaNo(RVBorderStyle, RVBorderWidth, RVBorderIntWidth,
          RVBorderColor, RVBorderOffs);
        if Result<0 then begin
          AddPara(RVBorderStyle, RVBorderWidth, RVBorderIntWidth, RVBorderColor,
            RVBorderOffs);
          Result := RVStyle.ParaStyles.Count-1;
        end;
        RVBorderOffs.Free;
      end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.ReturnParaNo(Position: TRVRTFPosition): Integer;
begin
  case Position of
  rtf_ts_NewPara:
    begin
      Result := ReturnParaNo_;
    end;
  else
    begin
      if CurrentRVData=RVData then begin
        if (InsertPoint-1<RVData.Items.Count) and (InsertPoint>0) then begin
          Result := RVData.GetItemPara(InsertPoint-1);
          end
        else
          Result := 0;
        end
      else begin
        if CurrentRVData.Items.Count=0 then
          Result := 0
        else
          Result := CurrentRVData.GetItemPara(CurrentRVData.Items.Count-1);
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.FindBestStyleNo(AUnicode, AHypertext,
  ASwitchProtect: Boolean): Integer;
var i: Integer;
    FontStyle: TFontInfo;
    FN: String;
    {$IFDEF RICHVIEWCBDEF3}
    Charset: TFontCharset;
    {$ENDIF}
    w, maxw, FontSize: Integer;
    fs: TFontStyle;
    Protection: TRVProtectOptions;
begin
  Result := 0;
  maxw   := 0;
  Protection := [];
  if ASwitchProtect then
    Include(Protection, rvprDoNotAutoSwitch);
  with Reader.RTFState.CharProps do begin
    if FontName='' then
      FN := AnsiLowerCase(Reader.FontTable[FontIndex].Name)
    else
      FN := AnsiLowerCase(FontName);
    {$IFDEF RICHVIEWCBDEF3}
    Charset := Reader.FontTable[FontIndex].Charset;
    if (FontName=RVFONT_SYMBOL) or (FontName=RVFONT_WINGDINGS) then
      Charset := SYMBOL_CHARSET
    else begin
      if (Charset=254) or (Charset=MAC_CHARSET) then
        Charset := ANSI_CHARSET;
      if FUseCharsetForUnicode and AUnicode then
        Charset := FCharsetForUnicode;
    end;
    {$ENDIF}
    FontSize := Size;
    if FontSize=0 then
      FontSize := 1;
    for i := 0 to RVStyle.TextStyles.Count-1 do begin
      if not AllowUseStyle(i, True) then
        continue;
      FontStyle := RVStyle.TextStyles[i];
      w := 0;
      if {$IFNDEF RVDONOTUSEUNICODE}
        (FontStyle.Unicode = AUnicode) and
        {$ENDIF}
        ((AHypertext and FontStyle.Jump) or
         (not AHypertext and (UseHypertextStyles or not FontStyle.Jump))) then begin
        if (AnsiLowerCase(FontStyle.FontName)=FN) then
          inc(w,RVSMW_FONTNAME);
        {$IFDEF RICHVIEWCBDEF3}
        if Charset=FontStyle.Charset then
          inc(w, RVSMW_FONTCHARSET)
        else
          if (Charset=DEFAULT_CHARSET) or
             (FontStyle.Charset=DEFAULT_CHARSET) then
            inc(w, RVSMW_FONTCHARSET div 4);
        {$ENDIF}
        {$IFDEF RVLANGUAGEPROPERTY}
        if Language = FontStyle.Language then
          inc(w, RVSMW_LANGUAGE);
        {$ENDIF}
        if (CurrentRVData.GetBiDiMode<>rvbdUnspecified) and
          (ord(FontStyle.BiDiMode)=ord(BiDiMode)) then
          inc(w, RVSMW_TEXTBIDIMODE);
        inc(w, RV_CompareInts(FontSize, FontStyle.Size, RVSMW_FONTSIZE));
        inc(w, RV_CompareColors(FontStyle.Color, Color, RVSMW_EACHRGBCOLOR, RVSMW_COLORSET));
        inc(w, RV_CompareColors(FontStyle.BackColor, BackColor, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET));
        inc(w, RV_CompareColors(FontStyle.UnderlineColor, UnderlineColor, RVSMW_EACHRGBBCOLOR, RVSMW_BCOLORSET));
        if (rvfsAllCaps in FontStyle.StyleEx) = (rtf_fs_AllCaps in StyleEx) then
          inc(w, RVSMW_ALLCAPS);
        for fs := Low(TFontStyle) to High(TFontStyle) do
          if (fs in FontStyle.Style) = (fs in Style) then
            inc(w, RVSMW_FONTEACHSTYLE);
        if (fsUnderline in FontStyle.Style * Style) then
          if ord(FontStyle.UnderlineType)<>ord(UnderlineType) then
            dec(w, RVSMW_FONTEACHSTYLE div 2);
        if (FontStyle.Style=[])=(Style=[]) then
          inc(w, RVSMW_FONTSTYLESET);
        inc(w, Round((1 - abs(FontStyle.CharScale-CharScaleX) / 100)*RVSMW_CHARSCALE));
        inc(w, RV_CompareInts(CharSpacingTw, RVStyle.GetAsTwips(FontStyle.CharSpacing), RVSMW_FONTSIZE));
        if (rvteoHidden in FontStyle.Options) = Hidden then
          inc(w, RVSMW_HIDDEN);
        if ord(FontStyle.SubSuperScriptType)=ord(SScriptType) then
          inc(w, RVSMW_SUBSUPERSCRIPTTYPE);
        if RV_Sign(FontStyle.VShift)<>RV_Sign(VShiftPt) then
          dec(w, RVSMW_VSHIFT)
        else
          inc(w, RV_CompareInts(FontStyle.VShift, Round((50*VShiftPt)/FontSize) , RVSMW_VSHIFT));
        if FontStyle.StyleEx<>[] then
          w := w div 4;
        if FontStyle.Protection=Protection then
          inc(w, RVSMW_PROTECTION);
        if w>maxw then begin
          maxw := w;
          Result := i;
        end;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.FindStyleNo(AUnicode, AHypertext,
  SwitchProtect: Boolean): Integer;
var i: Integer;
    FontStyle: TFontInfo;
    FontSize: Integer;
    FN: String;
    {$IFDEF RICHVIEWCBDEF3}
    Charset: TFontCharset;
    {$ENDIF}
    Protection: TRVProtectOptions;
    LBiDiMode: TRVBiDiMode;
begin
  Result := -1;
  with Reader.RTFState.CharProps do begin
    {
    if Reader.FontTable.Count=0 then begin
      Result := 0;
      exit;
    end;
    }
    LBiDiMode := TRVBiDiMode(BiDiMode);
    if CurrentRVData.GetBiDiMode=rvbdUnspecified then
      LBiDiMode := rvbdUnspecified;
    if FontName='' then
      if (FontIndex>=0) and (FontIndex<Reader.FontTable.Count) then
        FN := AnsiLowerCase(Reader.FontTable[FontIndex].Name)
      else
        FN := RVStyle.TextStyles[0].FontName
    else
      FN := AnsiLowerCase(FontName);
    {$IFDEF RICHVIEWCBDEF3}
    if (FontIndex>=0) and (FontIndex<Reader.FontTable.Count) then
      Charset := Reader.FontTable[FontIndex].Charset
    else
      Charset := RVStyle.TextStyles[0].Charset;
    if (FontName=RVFONT_SYMBOL) or (FontName=RVFONT_WINGDINGS) then
      Charset := SYMBOL_CHARSET
    else begin
      if (Charset=254) or (Charset=MAC_CHARSET) then
        Charset := ANSI_CHARSET;
      if FUseCharsetForUnicode and AUnicode then
        Charset := FCharsetForUnicode;
    end;
    {$ENDIF}
    FontSize := Size;
    if FontSize=0 then
      FontSize := 1;
    Protection := [];
    if SwitchProtect then
      Include(Protection, rvprDoNotAutoSwitch);
    for i := 0 to RVStyle.TextStyles.Count-1 do begin
      FontStyle := RVStyle.TextStyles[i];
      if (AnsiLowerCase(FontStyle.FontName)=FN) and
         (FontStyle.Size=FontSize) and
         (FontStyle.Color=Color) and
         (FontStyle.BackColor=BackColor) and
         (FontStyle.Style=Style) and
         (FontStyle.BiDiMode=LBiDiMode) and
         {$IFDEF RVLANGUAGEPROPERTY}
         (FontStyle.Language = Language) and
         {$ENDIF}
         {$IFDEF RICHVIEWCBDEF3}
         ((FontStyle.Charset=Charset)
          {or (FontStyle.Charset=DEFAULT_CHARSET)}) // <-- not very good solution
          and
         {$ENDIF}
         (FontStyle.CharScale=CharScaleX) and
         (RVStyle.GetAsTwips(FontStyle.CharSpacing)=CharSpacingTw) and
         ((rvfsAllCaps in FontStyle.StyleEx)=(rtf_fs_AllCaps in StyleEx)) and
         (ord(FontStyle.SubSuperScriptType)=ord(SScriptType)) and
         (FontStyle.VShift=Round((50*VShiftPt)/FontSize)) and
         (FontStyle.Protection=Protection) and
         (ord(FontStyle.UnderlineType)=ord(UnderlineType)) and
         (FontStyle.UnderlineColor=UnderlineColor) and                  
         {$IFNDEF RVDONOTUSEUNICODE}
         (FontStyle.Unicode=AUnicode) and
         {$ENDIF}
         ((rvteoHidden in FontStyle.Options) = Hidden) and         
         (FontStyle.StyleEx = []) and
         ((AHypertext and FontStyle.Jump) or
          (not AHypertext and (UseHypertextStyles or not FontStyle.Jump))) then begin
        Result := i;
        break;
      end;
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.AddStyle(AUnicode, AHypertext, ASwitchProtect: Boolean);
var FontStyle: TFontInfo;
begin
  FontStyle := TFontInfo(RVStyle.TextStyles.Add);
  FontStyle.Standard := False;
  with Reader.RTFState.CharProps do begin

    FontStyle.Jump      := AHypertext;
    {$IFNDEF RVDONOTUSEUNICODE}
    FontStyle.Unicode   := AUnicode;
    {$ENDIF}
    FontStyle.Style     := Style;
    FontStyle.Size      := Size;
    if FontStyle.Size=0 then
      FontStyle.Size := 1;
    FontStyle.Color     := Color;
    FontStyle.BackColor := BackColor;
    if FontName='' then
      if (FontIndex>=0) and (FontIndex<Reader.FontTable.Count) then
        FontStyle.FontName := AnsiLowerCase(Reader.FontTable[FontIndex].Name)
      else
        FontStyle.FontName := RVStyle.TextStyles[0].FontName
    else begin
      FontStyle.FontName  := FontName;
      // FontStyle.Protection := FontStyle.Protection+[rvprStyleProtect,rvprDoNotAutoSwitch];
    end;
    {$IFDEF RICHVIEWCBDEF3}
    if (FontIndex>=0) and (FontIndex<Reader.FontTable.Count) then
      FontStyle.Charset   := Reader.FontTable[FontIndex].Charset
    else
      FontStyle.Charset   := RVStyle.TextStyles[0].Charset;
    if (FontName=RVFONT_SYMBOL) or (FontName=RVFONT_WINGDINGS) then
      FontStyle.Charset := SYMBOL_CHARSET
    else begin
      if (FontStyle.Charset=254) or (FontStyle.Charset=MAC_CHARSET) then
        FontStyle.Charset := ANSI_CHARSET;
      if FUseCharsetForUnicode and AUnicode then
        FontStyle.Charset := FCharsetForUnicode;
    end;
    {$ENDIF}
    FontStyle.CharScale := CharScaleX;
    FontStyle.CharSpacing := RVStyle.TwipsToUnits(CharSpacingTw);
    FontStyle.SubSuperScriptType := TRVSubSuperScriptType(ord(SScriptType));
    FontStyle.VShift := Round((50*VShiftPt)/FontStyle.Size);
    if rtf_fs_AllCaps in StyleEx then
      FontStyle.StyleEx := FontStyle.StyleEx+[rvfsAllCaps];
    FontStyle.UnderlineType := TRVUnderlineType(UnderlineType);
    FontStyle.UnderlineColor := UnderlineColor;
    {$IFDEF RVLANGUAGEPROPERTY}
    FontStyle.Language := Language;
    {$ENDIF}
    if Hidden then
      FontStyle.Options := FontStyle.Options+[rvteoHidden];
    if ASwitchProtect then
      FontStyle.Protection := [rvprDoNotAutoSwitch];
    if CurrentRVData.GetBiDiMode<>rvbdUnspecified then
      FontStyle.BiDiMode := TRVBiDiMode(BiDiMode);
  end;
  CurrentRVData.AfterAddStyle(FontStyle);
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.ReturnStyleNo(AUnicode,
  ASwitchProtect: Boolean): Integer;
var ht: Boolean;
begin
  case TextStyleMode of
    rvrsUseSpecified:
      Result := TextStyleNo;
    rvrsUseClosest:
      Result := FindBestStyleNo(AUnicode, IsHypertext_, ASwitchProtect);
    else
      begin
        ht := IsHypertext_;
        Result := FindStyleNo(AUnicode, ht, ASwitchProtect);
        if Result<0 then begin
          AddStyle(AUnicode, ht, ASwitchProtect);
          Result := RVStyle.TextStyles.Count-1;
        end;
      end;
  end;
end;
const HYPERLINK = 'HYPERLINK';
{------------------------------------------------------------------------------}
function GetFullPath(const Path, BasePath: String): String;
begin
  if (Path='') or (Path[1]='#') or
    ((Length(Path)>=2) and ((Path[1]='\') or (Path[1]='/')) and (Path[2]=Path[1])) or
    ((Pos(':', Path)>0) and (RVIsURL(Path) or ((Length(Path)>1) and (Path[2]=':')))) then
    Result := Path
  else if (Path<>'') and ((Path[1]='\') or (Path[1]='/')) then
    Result := RVExtractDomain(BasePath)+Path
  else
    Result := BasePath+Path;
end;
{------------------------------------------------------------------------------}
type
  TRTFHyperlinkParseState = (rtfhypNothingSpecial, rtfhypSlash,
    rtfhypBeforeHint, rtfhypBeforeBookmark,
    rtfhypStartHint, rtfhypStartBookmark,
    rtfhypHint, rtfhypBookmark    );
function TRVRTFReaderProperties.IsHypertext(var Target, Hint,
  Extras: String): Boolean;

var p: Integer;
    s: String;
    LocalTarget: String;
    removed, quoted: Boolean;
    i, startindex, len: Integer;
    State: TRTFHyperlinkParseState;
begin
  s := Trim(Reader.RTFState.FieldCode);
  if s='' then begin
    Result := False;
    exit;
  end;
  if s[1]='\' then
    s := Copy(s, 2, Length(s));
  p := Pos(HYPERLINK, UpperCase(s));
  Result := p=1;
  if not Result then
    exit;
  Target := Reader.GetFieldCommandValueEx(s, startindex, len, False);
  Extras := s;
  Delete(Extras, startindex, len);
  Delete(Extras, 1, Length(HYPERLINK));
  Extras := Trim(Extras);
  removed := False;
  for p := Length(Target) downto 2 do begin
    removed := not removed and (Target[p]='\') and (Target[p-1]='\');
    if removed then
      Delete(Target, p, 1);
  end;
  quoted := False;
  State := rtfhypNothingSpecial;
  Hint := '';
  LocalTarget := '';
  for i := 1 to Length(Extras) do
    case State of
    rtfhypNothingSpecial:
      begin
        if not quoted then begin
          if Extras[i]='\' then
           State := rtfhypSlash
          else if Extras[i]='"' then
            quoted := True;
          end
        else if Extras[i]='"' then
          quoted := False;
      end;
    rtfhypSlash:
      case Extras[i] of
        'o':
          State := rtfhypBeforeHint;
        'l':
          State := rtfhypBeforeBookmark;
        else
          State := rtfhypNothingSpecial;
      end;
    rtfhypBeforeHint:
      if Extras[i]=' ' then
        State := rtfhypStartHint
      else
        State := rtfhypNothingSpecial;
    rtfhypBeforeBookmark:
      if Extras[i]=' ' then
        State := rtfhypStartBookmark
      else
        State := rtfhypNothingSpecial;
    rtfhypStartHint:
      begin
        if Extras[i]='"' then
          quoted := True
        else
          Hint := Hint+Extras[i];
        State := rtfhypHint;
      end;
    rtfhypStartBookmark:
      begin
        if Extras[i]='"' then
          quoted := True
        else
          LocalTarget := LocalTarget+Extras[i];
        State := rtfhypBookmark;
      end;
    rtfhypHint:
      begin
        if (quoted and (Extras[i]='"') and (Extras[i-1]<>'\')) or
           (not quoted and (Extras[i]=' ')) then begin
          State := rtfhypNothingSpecial;
          quoted := False;
          end
        else begin
          if (i>1) and (Extras[i]='"') and (Extras[i-1]='\') then
            Delete(Hint, Length(Hint), 1);
          Hint := Hint+Extras[i];
        end;
      end;
    rtfhypBookmark:
      begin
        if (quoted and (Extras[i]='"') and (Extras[i-1]<>'\')) or
           (not quoted and (Extras[i]=' ')) then begin
          State := rtfhypNothingSpecial;
          quoted := False;
          end
        else begin
          if (i>1) and (Extras[i]='"') and (Extras[i-1]='\') then
            Delete(Hint, Length(Hint), 1);
          LocalTarget := LocalTarget+Extras[i];
        end;
      end;
    end;
  if (LocalTarget<>'') and (LocalTarget[1]<>'#') then
    LocalTarget := '#'+LocalTarget;
  Target := Target+LocalTarget;
  Target := RV_DecodeURL(Target, False);
  if BasePathLinks then
    Target := GetFullPath(Target, BasePath);
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.IsHypertext_: Boolean;
begin
  if Reader.RTFState.FieldCode='' then
    Result := False
  else
    Result := Pos(HYPERLINK, Reader.RTFState.FieldCode)>0;
end;
{------------------------------------------------------------------------------}
function TRVRTFReaderProperties.AllowUseStyle(StyleNo: Integer;
  TextStyle: Boolean): Boolean;
begin
  Result := True;
  if Assigned(OnAllowUseStyle) then
    OnAllowUseStyle(StyleNo, TextStyle, Result);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
procedure TRVRTFReaderProperties.Changed;
begin

end;

end.
