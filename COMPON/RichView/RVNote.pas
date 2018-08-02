{*******************************************************}
{                                                       }
{       RichView                                        }
{       Item types:                                     }
{       - footnote,                                     }
{       - endnote,                                      }
{       - reference to footnote/endnote.                }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}


unit RVNote;

{$I RV_Defs.inc}

interface

uses {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
  Classes, SysUtils, Graphics,
  {$IFNDEF RVDONOTUSESEQ}
  RVStyle, CRVData, RVItem, DLines, RVClasses, RVUni,
  RVLabelItem, RVSeqItem,
  RVRVData, RVSubData, RichView, RVFMisc, RVScroll,
  {$ENDIF}
   RVStr, RVTypes;

{$IFNDEF RVDONOTUSESEQ}

type
  TRVNoteData = class (TRVSubData)
    public
      SRVHeight: Integer;
      FNoteTextForPrinting: String;
      function GetNoteText: String; override;
      function GetNoteTextForPrinting: String;
  end;


  TCustomRVNoteItemInfo = class (TRVSeqItemInfo)
    private
      FDocument: TRVNoteData;
    protected
      procedure SetParentRVData(const Value: TPersistent); override;
      procedure SetNumberType(const Value: TRVSeqType); override;
      {$IFNDEF RVDONOTUSERTF}
      function GetRTFDestinationModifier: TRVAnsiString; dynamic;
      {$ENDIF}
      procedure Do_ChangeDoc(Stream: TStream; ItemNo: Integer);
    public
      destructor Destroy; override;
      procedure MovingToUndoList(ItemNo: Integer; RVData,
        AContainerUndoItem: TObject); override;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      {$IFNDEF RVDONOTUSERTF}
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1,
        ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
        HiddenParent: Boolean); override;
      procedure FillRTFTables(ColorList: TRVColorList;
        ListOverrideCountList: TRVIntegerList; RVData: TPersistent); override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSEHTML}
      function GetHTMLAnchorName: TRVAnsiString; dynamic;
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path,
        imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      procedure ReplaceDocumentEd(Stream: TStream);
      property Document: TRVNoteData read FDocument;
  end;

  TRVEndnoteItemInfo = class(TCustomRVNoteItemInfo)
    private
      procedure Init(RVData: TPersistent);
    protected
      function GetNumberType: TRVSeqType; override;
      {$IFNDEF RVDONOTUSERTF}
      function GetRTFDestinationModifier: TRVAnsiString; override;
      {$ENDIF}
    public
      constructor CreateEx(RVData: TPersistent;
        ATextStyleNo, AStartFrom: Integer; AReset: Boolean);
      constructor Create(RVData: TPersistent); override;
      {$IFNDEF RVDONOTUSEHTML}
      function GetHTMLAnchorName: TRVAnsiString; override;
      {$ENDIF}
      function AsText(LineWidth: Integer;
        RVData: TPersistent; const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
  end;

  TRVFootnoteItemInfo = class(TCustomRVNoteItemInfo)
    private
      procedure Init(RVData: TPersistent);
    protected
      function GetNumberType: TRVSeqType; override;
      function GetTextForPrintMeasuring(RVData: TPersistent): String; override;
      function GetTextForPrinting(RVData: TPersistent;
        DrawItem: TRVDrawLineInfo): String; override;
    public
      SRVCounter, SRVOldCounter: Integer;
      constructor CreateEx(RVData: TPersistent;
        ATextStyleNo, AStartFrom: Integer; AReset: Boolean);
      constructor Create(RVData: TPersistent); override;
      function CreatePrintingDrawItem(RVData, ParaStyle: TObject;
        const sad: TRVScreenAndDevice): TRVDrawLineInfo; override;
      {$IFNDEF RVDONOTUSEHTML}
      function GetHTMLAnchorName: TRVAnsiString; override;
      {$ENDIF}
      procedure CalcDisplayString(List: TRVSeqList); override;      
      function AsText(LineWidth: Integer;
        RVData: TPersistent; const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
  end;

  TRVNoteReferenceItemInfo = class (TRVLabelItemInfo)
    protected
      function GetTextForPrinting(RVData: TPersistent;
        DrawItem: TRVDrawLineInfo): String; override;
    public
      constructor Create(RVData: TPersistent); override;
      constructor CreateEx(RVData: TPersistent; TextStyleNo: Integer);
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      {$IFNDEF RVDONOTUSERTF}
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1,
        ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
        HiddenParent: Boolean); override;
      {$ENDIF}
      {$IFNDEF RVDONOTUSEHTML}
      procedure SaveToHTML(Stream: TStream; RVData: TPersistent;
        ItemNo: Integer; const Text: TRVRawByteString; const Path,
        imgSavePrefix: String; var imgSaveNo: Integer;
        CurrentFileColor: TColor; SaveOptions: TRVSaveOptions;
        UseCSS: Boolean; Bullets: TRVList); override;
      {$ENDIF}
  end;

  TCustomRVNoteItemInfoClass = class of TCustomRVNoteItemInfo;
  TRVEndnoteItemInfoClass = class of TRVEndnoteItemInfo;

const
  RV_FOOTNOTE_SEQNAME = '@footnote@';
  RV_ENDNOTE_SEQNAME  = '@endnote@';
  RV_FOOTNOTE_HTML_ANCHOR = 'footnote%d';
  RV_ENDNOTE_HTML_ANCHOR = 'endnote%d';
  rvsFootnote = -203;
  rvsEndnote  = -204;
  rvsNoteReference = -205;

function GetNextNote(RVData: TCustomRVData; Note: TCustomRVNoteItemInfo;
  NoteClass: TCustomRVNoteItemInfoClass; AllowHidden: Boolean): TCustomRVNoteItemInfo;
function RVGetFirstEndnote(RichView: TCustomRichView; AllowHidden: Boolean): TRVEndnoteItemInfo;
function RVGetNextEndnote(RichView: TCustomRichView;
  Endnote: TRVEndnoteItemInfo; AllowHidden: Boolean): TRVEndnoteItemInfo;
function RVGetFirstEndnoteInRootRVData(RVData: TCustomRVData; AllowHidden: Boolean): TRVEndnoteItemInfo;

function RVGetFirstFootnote(RichView: TCustomRichView; AllowHidden: Boolean): TRVFootnoteItemInfo;
function RVGetNextFootnote(RichView: TCustomRichView;
  Footnote: TRVFootnoteItemInfo; AllowHidden: Boolean): TRVFootnoteItemInfo;
function RVGetFirstFootnoteInRootRVData(RVData: TCustomRVData; AllowHidden: Boolean): TRVFootnoteItemInfo;

function RVGetNoteTextStyleNo(RVStyle: TRVStyle; StyleNo: Integer): Integer;

{$ENDIF}

implementation

{$IFNDEF RVDONOTUSESEQ}

uses RVUndo, RVERVData, RVEdit, PtblRV, PtRVData;

{================================ TRVUndoChangeDocInfo ========================}
type
  TRVUndoChangeDocInfo = class(TRVUndoItemNoInfo)
    private
      Stream: TRVMemoryStream;
    public
      function RequiresFormat: Boolean; override;
      procedure Undo(RVData: TRichViewRVData); override;
  end;
{------------------------------------------------------------------------------}
function TRVUndoChangeDocInfo.RequiresFormat: Boolean;
begin
  Result := False;
end;
{------------------------------------------------------------------------------}
procedure TRVUndoChangeDocInfo.Undo(RVData: TRichViewRVData);
var Item: TCustomRVNoteItemInfo;
begin
  Item := RVData.GetItem(ItemNo) as TCustomRVNoteItemInfo;
  Item.Do_ChangeDoc(Stream, ItemNo);
end;
{====================== TCustomRVNoteItemInfo =================================}
destructor TCustomRVNoteItemInfo.Destroy;
begin
  FDocument.Free;
  FDocument := nil;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.MovingFromUndoList(ItemNo: Integer;
  RVData: TObject);
begin
  inherited;
  FDocument.MovingFromUndoList;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.MovingToUndoList(ItemNo: Integer; RVData,
  AContainerUndoItem: TObject);
begin
  inherited;
  FDocument.MovingToUndoList(TRVUndoInfo(AContainerUndoItem));
end;
{------------------------------------------------------------------------------}
function TCustomRVNoteItemInfo.ReadRVFLine(const s: TRVRawByteString;
  RVData: TPersistent; ReadType, LineNo, LineCount: Integer;
  var Name: TRVRawByteString; var ReadMode: TRVFReadMode;
  var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
var TmpStream: TRVMemoryStream;
  Color: TColor;
  Index, Dummy1: Integer;
  Dummy2, Dummy3: Boolean;
begin
  Result := True;
  case LineNo of
    0..3:
      LoadPropertiesFromRVF(s, LineNo, RVData, UTF8Strings, AssStyleNameUsed);
    4:
      Reset := s<>'0';
    5:
      StartFrom := RVStrToInt(s);
    6:
      begin
        Name := s;
        ParentRVData := RVData;
      end;
    else
      if LineNo=LineCount-1 then begin
        TmpStream := TRVMemoryStream.Create;
        try
          if ReadType=2 then begin
            TmpStream.SetSize(Length(s));
            Move(PRVAnsiChar(s)^, TmpStream.Memory^, Length(s));
            end
          else
            Result := RVFTextString2Stream(s, TmpStream);
          TmpStream.Position := 0;
          Index := 0;
          Color := clNone;
          Result := Document.InsertRVFFromStream_(TmpStream, Index, -1, False,
            False, False, Color, nil, nil, Dummy1, Dummy2, Dummy3, True);
        finally
          TmpStream.Free;
        end;
        end
      else
        SetExtraPropertyFromRVFStr(s, UTF8Strings);
  end;
  if (ReadType=2) and (LineNo=LineCount-2) then
    ReadMode := rmBeforeBinary;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.SaveRVF(Stream: TStream;
  RVData: TPersistent; ItemNo, ParaNo: Integer; const Name: TRVRawByteString;
  Part: TRVMultiDrawItemPart; ForceSameAsPrev: Boolean);
var TmpStream: TRVMemoryStream;
    SaveType: Integer;
begin
  if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
    SaveType := 2 // save binary
  else
    SaveType := 0; // save hex dump
  RVFWriteLine(Stream,
    {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
      [StyleNo, 8+GetRVFExtraPropertyCount {Line count after header},
       RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
       Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
       SaveType,
       RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
       SaveRVFHeaderTail(RVData)]));
  // lines after header
  {0,1,2,3}SavePropertiesToRVF(Stream, RVData);
  {4}RVFWriteLine(Stream, RVIntToStr(ord(Reset)));
  {5}RVFWriteLine(Stream, RVIntToStr(StartFrom));
  {6}RVFWriteLine(Stream, Name);
  SaveRVFExtraProperties(Stream);
  TmpStream := TRVMemoryStream.Create;
  try
    Document.SaveRVFToStream(TmpStream);
    if rvfoSaveBinary in TCustomRVData(RVData).RVFOptions then
      RVFSaveStreamToStream(TmpStream, Stream)
    else
      RVFWriteLine(Stream, RVFStream2TextString(TmpStream));
  finally
    TmpStream.Free;
  end;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.SetNumberType(const Value: TRVSeqType);
begin
  // does nothing
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.SetParentRVData(const Value: TPersistent);
begin
  inherited;
  if FDocument<>nil then
    FDocument.MainRVData := TCustomRVData(ParentRVData).GetAbsoluteRootData;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.MarkStylesInUse(
  Data: TRVDeleteUnusedStylesData);
begin
  inherited;
  Document.DoMarkStylesInUse(Data);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.UpdateStyles(
  Data: TRVDeleteUnusedStylesData);
begin
  inherited;
  Document.DoUpdateStyles(Data);
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.Assign(Source: TCustomRVItemInfo);
var Stream: TRVMemoryStream;
begin
  if Source is TCustomRVNoteItemInfo then begin
    Stream := TRVMemoryStream.Create;
    try
      TCustomRVNoteItemInfo(Source).Document.SaveRVFToStream(Stream);
      Stream.Position := 0;
      Document.LoadRVFFromStream(Stream);
    finally
      Stream.Free;
    end;
  end;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.ReplaceDocumentEd(Stream: TStream);
begin
  if TCustomRVData(ParentRVData).GetRVData is TRVEditRVData then
    TRVEditRVData(TCustomRVData(ParentRVData).GetRVData).BeginUndoSequence(
      rvutModifyItem, True);
  Do_ChangeDoc(Stream, -1);
  if TCustomRVData(ParentRVData).GetRVData is TRVEditRVData then
    TRVEditRVData(TCustomRVData(ParentRVData).GetRVData).Change;
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.Do_ChangeDoc(Stream: TStream; ItemNo: Integer);
var ui: TRVUndoChangeDocInfo;
    List: TRVUndoList;
    RVFOptions: TRVFOptions;
begin
  ui := nil;
  if TCustomRVData(ParentRVData).GetRVData is TRVEditRVData then begin
    if ItemNo<0 then
      ItemNo := TCustomRVData(ParentRVData).GetRVData.GetItemNo(Self);
    if ItemNo>=0 then begin
      List := TRVEditRVData(TCustomRVData(ParentRVData).GetRVData).GetUndoList;
      if List<>nil then begin
        ui := TRVUndoChangeDocInfo.Create;
        ui.Action := rvuModifyItem;
        ui.ItemNo := ItemNo;
        List.AddInfo(ui,
          TCustomRichViewEdit(TRVEditRVData(TCustomRVData(ParentRVData).GetRVData).RichView));
      end;
    end;
  end;
  if (ui<>nil) and (Document.ItemCount>=0) then begin
    ui.Stream := TRVMemoryStream.Create;
    RVFOptions := Document.RVFOptions;
    try
      Document.RVFOptions := Document.RVFOptions-
        [rvfoSaveTextStyles, rvfoSaveParaStyles];
      Document.SaveRVFToStream(ui.Stream);
    finally
      Document.RVFOptions := RVFOptions;
    end;
  end;
  Document.Clear;
  if Stream<>nil then begin
    Stream.Position := 0;
    Document.LoadRVFFromStream(Stream);
  end;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
procedure TCustomRVNoteItemInfo.FillRTFTables(ColorList: TRVColorList;
  ListOverrideCountList: TRVIntegerList; RVData: TPersistent);
begin
  inherited;
  Document.MakeRTFTables(ColorList, ListOverrideCountList, False);
end;
{------------------------------------------------------------------------------}
function TCustomRVNoteItemInfo.GetRTFDestinationModifier: TRVAnsiString;
begin
  Result := ' ';
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.SaveRTF(Stream: TStream;
  const Path: String; RVData: TPersistent; ItemNo: Integer;
  TwipsPerPixel: Double; Level: Integer;
  ColorList: TRVColorList; StyleToFont, ListOverrideOffsetsList1,
  ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
  HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVFWrite(Stream, '\chftn{\footnote');
  RVFWrite(Stream, GetRTFDestinationModifier);
  TCustomRVData(Document).SaveRTFToStream(Stream, Path, False, 0, clNone, nil,
    ColorList, StyleToFont, ListOverrideOffsetsList1, ListOverrideOffsetsList2,
    TRVRTFFontTable(FontTable), TwipsPerPixel, False, False, nil, nil);
  RVFWrite(Stream, '}');
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');  
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function TCustomRVNoteItemInfo.GetHTMLAnchorName: TRVAnsiString;
begin
  Result := '';
end;
{------------------------------------------------------------------------------}
procedure TCustomRVNoteItemInfo.SaveToHTML(Stream: TStream;
  RVData: TPersistent; ItemNo: Integer; const Text: TRVRawByteString; const Path,
  imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
begin
  RVFWrite(Stream, '<a href="#'+GetHTMLAnchorName+'">');
  inherited;
  RVFWrite(Stream, '</a>');  
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TCustomRVNoteItemInfo.GetBoolValue(
  Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpFloating:
      Result := False;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{============================ TRVEndnoteItemInfo ==============================}
constructor TRVEndnoteItemInfo.Create(RVData: TPersistent);
begin
  inherited;
  Init(RVData);
end;
{------------------------------------------------------------------------------}
constructor TRVEndnoteItemInfo.CreateEx(RVData: TPersistent;
  ATextStyleNo, AStartFrom: Integer; AReset: Boolean);
begin
  inherited CreateEx(RVData, RV_ENDNOTE_SEQNAME, rvseqLowerRoman,
    ATextStyleNo, AStartFrom, AReset);
  Init(RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVEndnoteItemInfo.Init(RVData: TPersistent);
begin
  FDocument := TRVNoteData.Create(Self, TCustomRVData(RVData));
  FDocument.MainRVData := TCustomRVData(ParentRVData).GetAbsoluteRootData;
  StyleNo := rvsEndnote;
  SeqName := RV_ENDNOTE_SEQNAME;
end;
{------------------------------------------------------------------------------}
function TRVEndnoteItemInfo.GetNumberType: TRVSeqType;
begin
  Result := TCustomRVData(ParentRVData).GetRVStyle.EndnoteNumbering;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
function TRVEndnoteItemInfo.GetRTFDestinationModifier: TRVAnsiString;
begin
  Result := '\ftnalt ';
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function TRVEndnoteItemInfo.GetHTMLAnchorName: TRVAnsiString;
begin
  Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(RV_ENDNOTE_HTML_ANCHOR, [FCachedIndexInList]);
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function GetStr(const s: TRVAnsiString; CodePage: TRVCodePage; Unicode: Boolean): TRVRawByteString;
begin
  if Unicode then
    Result := RVU_AnsiToUnicode(CodePage, s)
  else
    Result := s;
end;

function TRVEndnoteItemInfo.AsText(LineWidth: Integer;
  RVData: TPersistent; const Text: TRVRawByteString; const Path: String;
  TextOnly,Unicode: Boolean): TRVRawByteString;
var CodePage: TRVCodePage;
begin
  if TextOnly then
    Result := ''
  else begin
    CodePage := TCustomRVData(RVData).GetDefaultCodePage;
    Result := inherited AsText(LineWidth, RVData, Text, Path, TextOnly, Unicode);
    Result := GetStr('[',CodePage,Unicode)+Result+GetStr(']',CodePage,Unicode);
  end;
end;
{========================= TRVFootnoteItemInfo ================================}
constructor TRVFootnoteItemInfo.Create(RVData: TPersistent);
begin
  inherited;
  Init(RVData);
end;
{------------------------------------------------------------------------------}
constructor TRVFootnoteItemInfo.CreateEx(RVData: TPersistent; ATextStyleNo,
  AStartFrom: Integer; AReset: Boolean);
begin
  inherited CreateEx(RVData, RV_FOOTNOTE_SEQNAME, rvseqDecimal,
    ATextStyleNo, AStartFrom, AReset);
  Init(RVData);
end;
{------------------------------------------------------------------------------}
function TRVFootnoteItemInfo.GetNumberType: TRVSeqType;
begin
  Result := TCustomRVData(ParentRVData).GetRVStyle.FootnoteNumbering;
end;
{------------------------------------------------------------------------------}
function TRVFootnoteItemInfo.GetTextForPrintMeasuring(RVData: TPersistent): String;
begin
  if TCustomRVData(ParentRVData).GetRVStyle.FootnotePageReset then
    Result := GetDisplayString(TCustomRVData(RVData).GetSeqList(False), 4)
  else
    Result := inherited GetTextForPrintMeasuring(RVData);
end;
{------------------------------------------------------------------------------}
function TRVFootnoteItemInfo.GetTextForPrinting(RVData: TPersistent;
  DrawItem: TRVDrawLineInfo): String;
begin
  if DrawItem is TRVFootnoteDrawItem then
    Result := GetDisplayString(nil, TRVFootnoteDrawItem(DrawItem).DocumentRVData.IndexOnPage)
  else
    Result := inherited GetTextForPrinting(RVData, DrawItem);
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteItemInfo.CalcDisplayString(List: TRVSeqList);
begin
  if SRVCounter>=0 then begin
    Text := GetDisplayString(List, SRVCounter);
    FUpdated := False;
    end
  else
    inherited;
end;
{------------------------------------------------------------------------------}
function TRVFootnoteItemInfo.CreatePrintingDrawItem(RVData, ParaStyle: TObject;
  const sad: TRVScreenAndDevice): TRVDrawLineInfo;
begin
  if TCustomRVData(ParentRVData).GetRVStyle.FootnotePageReset then
    Result := TRVFootnoteDrawItem.Create
  else
    Result := inherited CreatePrintingDrawItem(RVData, ParaStyle, sad);
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteItemInfo.Init(RVData: TPersistent);
begin
  FDocument := TRVNoteData.Create(Self, TCustomRVData(RVData));
  FDocument.MainRVData := TCustomRVData(ParentRVData).GetAbsoluteRootData;
  StyleNo := rvsFootnote;
  SeqName := RV_FOOTNOTE_SEQNAME;
  SRVCounter := -1;
end;
{------------------------------------------------------------------------------}
function TRVFootnoteItemInfo.AsText(LineWidth: Integer;
  RVData: TPersistent; const Text: TRVRawByteString; const Path: String;
  TextOnly,Unicode: Boolean): TRVRawByteString;
var Stream: TRVMemoryStream;
    CodePage: TRVCodePage;
    DocText: TRVRawByteString;
begin
  if TextOnly then begin
    Result := '';
    exit;
  end;
  Result := inherited AsText(LineWidth, RVData, Text, Path, TextOnly, Unicode);
  CodePage := TCustomRVData(RVData).GetDefaultCodePage;
  Stream := TRVMemoryStream.Create;
  try
    FDocument.SaveTextToStream(Path, Stream, 0, False, TextOnly, Unicode, False);
    SetLength(DocText, Stream.Size);
    Stream.Position := 0;
    Stream.ReadBuffer(PRVAnsiChar(DocText)^, Length(DocText));
  finally
    Stream.Free;
  end;
  Result := GetStr(' [', CodePage, Unicode)+DocText+
    GetStr(']', CodePage, Unicode);
end;
{------------------------------------------------------------------------------}
procedure TRVFootnoteItemInfo.OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
  Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
  sad: PRVScreenAndDevice; var HShift, Desc: Integer;
  NoCaching, Reformatting, UseFormatCanvas: Boolean);
begin
  SRVCounter := -1;
  inherited;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
function TRVFootnoteItemInfo.GetHTMLAnchorName: TRVAnsiString;
begin
  Result := {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(RV_FOOTNOTE_HTML_ANCHOR, [FCachedIndexInList]);
end;
{$ENDIF}
{=========================== TRVNoteReferenceItemInfo =========================}
constructor TRVNoteReferenceItemInfo.Create(RVData: TPersistent);
begin
  inherited CreateEx(RVData, TextStyleNo, TCustomRVData(RVData).GetNoteText);
  StyleNo := rvsNoteReference;
end;
{------------------------------------------------------------------------------}
constructor TRVNoteReferenceItemInfo.CreateEx(RVData: TPersistent;
  TextStyleNo: Integer);
begin
  inherited CreateEx(RVData, TextStyleNo, TCustomRVData(RVData).GetNoteText);
  StyleNo := rvsNoteReference;
end;
{------------------------------------------------------------------------------}
procedure TRVNoteReferenceItemInfo.OnDocWidthChange(DocWidth: Integer;
  dli: TRVDrawLineInfo; Printing: Boolean; Canvas: TCanvas;
  RVData: TPersistent; sad: PRVScreenAndDevice; var HShift, Desc: Integer;
  NoCaching, Reformatting, UseFormatCanvas: Boolean);
begin
  if Text<>TCustomRVData(ParentRVData).GetNoteText then
    Text := TCustomRVData(ParentRVData).GetNoteText;
  inherited;
end;
{------------------------------------------------------------------------------}
function TRVNoteReferenceItemInfo.GetTextForPrinting(RVData: TPersistent;
  DrawItem: TRVDrawLineInfo): String;
begin
  if TCustomRVData(ParentRVData).GetRVStyle.FootnotePageReset and
     (RVData is TRVFootnotePtblRVData) then
    Result := TRVFootnotePtblRVData(RVData).Footnote.
      GetDisplayString(nil, TRVFootnotePtblRVData(RVData).IndexOnPage)
  else
    Result := TCustomRVData(ParentRVData).GetNoteText;
end;
{------------------------------------------------------------------------------}
function TRVNoteReferenceItemInfo.ReadRVFLine(const s: TRVRawByteString;
  RVData: TPersistent; ReadType, LineNo, LineCount: Integer;
  var Name: TRVRawByteString; var ReadMode: TRVFReadMode;
  var ReadState: TRVFReadState; UTF8Strings: Boolean;
  var AssStyleNameUsed: Boolean): Boolean;
begin
  case LineNo of
    0..3:
      LoadPropertiesFromRVF(s, LineNo, RVData, UTF8Strings, AssStyleNameUsed);
    4:
      begin
        Name := s;
        ParentRVData := RVData;
        Text := TCustomRVData(RVData).GetNoteText;
      end;
    else
      SetExtraPropertyFromRVFStr(s, UTF8Strings);
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVNoteReferenceItemInfo.SaveRVF(Stream: TStream;
  RVData: TPersistent; ItemNo, ParaNo: Integer; const Name: TRVRawByteString;
  Part: TRVMultiDrawItemPart; ForceSameAsPrev: Boolean);
begin
   RVFWriteLine(Stream,
     {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
       [StyleNo, 5+GetRVFExtraPropertyCount {Line count after header},
        RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
        Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
        0 {text mode saving},
        RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
        SaveRVFHeaderTail(RVData)]));
   // lines after header
   {0,1,2,3}SavePropertiesToRVF(Stream, RVData);
   {4}RVFWriteLine(Stream, Name);
   SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
procedure TRVNoteReferenceItemInfo.SaveRTF(Stream: TStream;
  const Path: String; RVData: TPersistent; ItemNo: Integer;
  TwipsPerPixel: Double; Level: Integer;
  ColorList: TRVColorList; StyleToFont, ListOverrideOffsetsList1,
  ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
  HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v\chftn}')
  else
    RVFWrite(Stream, '\chftn ');
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVNoteReferenceItemInfo.SaveToHTML(Stream: TStream;
  RVData: TPersistent; ItemNo: Integer; const Text: TRVRawByteString; const Path,
  imgSavePrefix: String; var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
begin
  Self.Text := TCustomRVData(ParentRVData).GetNoteText;
  inherited;
end;
{$ENDIF}
{================================ TRVNoteData =================================}
function TRVNoteData.GetNoteText: String;
begin
  Result := TCustomRVNoteItemInfo(Owner).Text;
end;
{------------------------------------------------------------------------------}
function TRVNoteData.GetNoteTextForPrinting: String;
begin
  if FNoteTextForPrinting='' then
    Result := GetNoteText
  else
    Result := FNoteTextForPrinting;
end;
{==============================================================================}
function RVGetNoteTextStyleNo(RVStyle: TRVStyle; StyleNo: Integer): Integer;
var TextStyle: TFontInfo;
begin
  TextStyle := TFontInfo.Create(nil);
  try
    TextStyle.Assign(RVStyle.TextStyles[StyleNo]);
    TextStyle.SubSuperScriptType := rvsssSuperScript;
    TextStyle.Protection := [rvprDoNotAutoSwitch];
    Result := RVStyle.TextStyles.FindSuchStyle(StyleNo, TextStyle,
      RVAllFontInfoProperties);
    if Result<0 then begin
      RVStyle.TextStyles.Add;
      Result := RVStyle.TextStyles.Count-1;
      RVStyle.TextStyles[Result].Assign(TextStyle);
      RVStyle.TextStyles[Result].Standard := False;
    end;
  finally
    TextStyle.Free;
  end;
end;
{------------------------------------------------------------------------------}
function GetNextNote(RVData: TCustomRVData; Note: TCustomRVNoteItemInfo;
  NoteClass: TCustomRVNoteItemInfoClass; AllowHidden: Boolean): TCustomRVNoteItemInfo;
var SeqList: TRVSeqList;
  i,j: Integer;
begin
  if rvoShowHiddenText in RVData.Options then
    AllowHidden := True;
  Result := nil;
  SeqList := RVData.GetSeqList(False);
  if SeqList=nil then
    exit;
  if Note<>nil then
    j := Note.GetIndexInList(SeqList)+1
  else
    j := 0;
  for i := j to SeqList.Count-1 do
    if (TCustomRVNoteItemInfo(SeqList.Items[i]) is NoteClass) and
      (AllowHidden or not TCustomRVNoteItemInfo(SeqList.Items[i]).Hidden) then begin
      Result := SeqList.Items[i];
      exit;
    end;
end;
{------------------------------------------------------------------------------}
function RVGetFirstEndnote(RichView: TCustomRichView; AllowHidden: Boolean): TRVEndnoteItemInfo;
begin
  Result := TRVEndnoteItemInfo(GetNextNote(RichView.RVData, nil,
    TRVEndnoteItemInfo, AllowHidden));
end;
{------------------------------------------------------------------------------}
function RVGetFirstEndnoteInRootRVData(RVData: TCustomRVData; AllowHidden: Boolean): TRVEndnoteItemInfo;
begin
  Result := TRVEndnoteItemInfo(GetNextNote(RVData, nil,
    TRVEndnoteItemInfo, AllowHidden));
end;
{------------------------------------------------------------------------------}
function RVGetNextEndnote(RichView: TCustomRichView;
  Endnote: TRVEndnoteItemInfo; AllowHidden: Boolean): TRVEndnoteItemInfo;
begin
  Result := TRVEndnoteItemInfo(GetNextNote(RichView.RVData, Endnote,
    TRVEndnoteItemInfo, AllowHidden));
end;
{------------------------------------------------------------------------------}
function RVGetFirstFootnote(RichView: TCustomRichView; AllowHidden: Boolean): TRVFootnoteItemInfo;
begin
  Result := TRVFootnoteItemInfo(GetNextNote(RichView.RVData, nil,
    TRVFootnoteItemInfo, AllowHidden));
end;
{------------------------------------------------------------------------------}
function RVGetNextFootnote(RichView: TCustomRichView;
  Footnote: TRVFootnoteItemInfo; AllowHidden: Boolean): TRVFootnoteItemInfo;
begin
  Result := TRVFootnoteItemInfo(GetNextNote(RichView.RVData, Footnote,
    TRVFootnoteItemInfo, AllowHidden));
end;
{------------------------------------------------------------------------------}
function RVGetFirstFootnoteInRootRVData(RVData: TCustomRVData; AllowHidden: Boolean): TRVFootnoteItemInfo;
begin
  Result := TRVFootnoteItemInfo(GetNextNote(RVData, nil,
    TRVFootnoteItemInfo, AllowHidden));
end;

initialization

  RegisterRichViewItemClass(rvsEndnote, TRVEndnoteItemInfo);
  RegisterRichViewItemClass(rvsFootnote, TRVFootnoteItemInfo);
  RegisterRichViewItemClass(rvsNoteReference, TRVNoteReferenceItemInfo);

{$ENDIF}

end.