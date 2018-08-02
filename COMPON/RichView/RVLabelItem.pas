{*******************************************************}
{                                                       }
{       RichView                                        }
{       Label Item - item class for RichView.           }
{       Non-text item that looks like a text            }
{       (but cannot be wrapped and edited)              }
{       Does not support Unicode.                       }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}

unit RVLabelItem;

{$I RV_Defs.inc}

interface
uses
     {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Classes, Windows, Graphics, RVFuncs, Controls,
     RVScroll, RVStyle, RVItem, RVFMisc, DLines,
     RVClasses, RVTypes, RVUni;

const
  rvsLabel = -200;

type
  TRVLabelItemInfo = class(TRVRectItemInfo)
    private
      Width, Height, Descend, YOffs: Integer;
      FMinWidth: TRVStyleLength;
      FAlignment: TAlignment;
      FCanUseCustomPPI: Boolean;
      FParentRVData: TPersistent;
      FTextStyleNo: Integer;
      FText: String;
      procedure SetMinWidth(const Value: TRVStyleLength);
      procedure SetAlignment(const Value: TAlignment);
      function GetRVStyle: TRVStyle;
      procedure SetText(const Value: String);
    protected
      FUpdated: Boolean;
      procedure DoPaint(r: TRect; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo; ColorMode: TRVColorMode;
        const Text: String); virtual;
      function GetAssociatedTextStyleNo: Integer; override;
      procedure SetAssociatedTextStyleNo(Value: Integer); override;
      procedure SetParentRVData(const Value: TPersistent); virtual;
      procedure SavePropertiesToRVF(Stream: TStream; RVData: TPersistent);
      procedure LoadPropertiesFromRVF(const s: TRVRawByteString; Index: Integer;
        RVData: TPersistent; UTF8Strings: Boolean; var TextStyleNameUsed: Boolean);
      function GetRVFExtraPropertyCount: Integer; override;
      procedure SaveRVFExtraProperties(Stream: TStream); override;
      function GetTextForPrintMeasuring(RVData: TPersistent): String; dynamic;
      function GetTextForPrinting(RVData: TPersistent;
        DrawItem: TRVDrawLineInfo): String; virtual;
      function GetTextStyleNo: Integer; virtual;
      procedure SetTextStyleNo(const Value: Integer); virtual;
      procedure DoUpdateMe(var Width, Height, YOffs, Descend: Integer;
        CanUseCustomPPI, CompareMinWidth: Boolean;
        RVData: TPersistent; const Text: String; DefCanvas: TCanvas);
    public
      ProtectTextStyleNo, RemoveInternalLeading: Boolean;
      Cursor: TCursor;
      constructor Create(RVData: TPersistent); override;
      constructor CreateEx(RVData: TPersistent; TextStyleNo: Integer;
        const Text: String);
      function GetHeight(RVStyle: TRVStyle): Integer; override;
      function GetWidth(RVStyle: TRVStyle): Integer; override;
      procedure MovingToUndoList(ItemNo: Integer; RVData,
        AContainerUndoItem: TObject); override;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); override;
      function MouseMove(Shift: TShiftState; X, Y, ItemNo: Integer;
        RVData: TObject): Boolean; override;
      function GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
        RVData: TPersistent): Integer; override;
      function GetBoolValue(Prop: TRVItemBoolProperty): Boolean; override;
      function GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
        RVStyle: TRVStyle): Boolean; override;
      procedure Paint(x,y: Integer; Canvas: TCanvas; State: TRVItemDrawStates;
        Style: TRVStyle; dli: TRVDrawLineInfo); override;
      procedure Print(Canvas: TCanvas; x,y,x2: Integer;
        Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
        RichView: TRVScroller;
        dli: TRVDrawLineInfo; Part: Integer;
        ColorMode: TRVColorMode; RVData: TPersistent); override;
      procedure AfterLoading(FileFormat: TRVLoadFormat); override;
      function SetExtraCustomProperty(const PropName: TRVAnsiString;
        const Value: String): Boolean; override;
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      procedure MarkStylesInUse(Data: TRVDeleteUnusedStylesData); override;
      procedure UpdateStyles(Data: TRVDeleteUnusedStylesData); override;
      procedure ApplyStyleConversion(RVData: TPersistent;
        ItemNo, UserData: Integer;
        ConvType: TRVEStyleConversionType); override;
      procedure UpdateMe;
      procedure OnDocWidthChange(DocWidth: Integer; dli: TRVDrawLineInfo;
        Printing: Boolean; Canvas: TCanvas; RVData: TPersistent;
        sad: PRVScreenAndDevice; var HShift, Desc: Integer;
        NoCaching, Reformatting, UseFormatCanvas: Boolean); override;
      function GetFinalPrintingWidth(Canvas: TCanvas;
        dli: TRVDrawLineInfo; RVData: TPersistent): Integer;
      procedure Execute(RVData:TPersistent);override;
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
      function AsText(LineWidth: Integer;
        RVData: TPersistent; const Text: TRVRawByteString; const Path: String;
        TextOnly,Unicode: Boolean): TRVRawByteString; override;
      procedure Inserted(RVData: TObject; ItemNo: Integer); override;
      procedure Changed;
      procedure ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
        RVStyle: TRVStyle; Recursive: Boolean); override;
      property TextStyleNo: Integer read GetTextStyleNo write SetTextStyleNo;
      property Text: String read FText write SetText;
      property MinWidth: TRVStyleLength read FMinWidth write SetMinWidth;
      property Alignment: TAlignment read FAlignment write SetAlignment;
      property RVStyle: TRVStyle read GetRVStyle;
      property ParentRVData: TPersistent read FParentRVData write SetParentRVData;
  end;

implementation
uses CRVData, CRVFData, RichView, RVUndo, RVGrIn;
{==============================================================================}
{ TRVLabelItemInfo }
constructor TRVLabelItemInfo.CreateEx(RVData: TPersistent;
  TextStyleNo: Integer; const Text: String);
begin
   inherited Create(RVData);
   StyleNo := rvsLabel;
   VAlign := rvvaBaseLine;
   Self.TextStyleNo := TextStyleNo;
   Self.Text    := Text;
   ParentRVData := RVData;
   FCanUseCustomPPI := rvflCanUseCustomPPI in TCustomRVData(RVData).Flags;
   Cursor := crDefault;
end;
{------------------------------------------------------------------------------}
constructor TRVLabelItemInfo.Create(RVData: TPersistent);
begin
  inherited Create(RVData);
  StyleNo := rvsLabel;
  ParentRVData := RVData;
  FCanUseCustomPPI := rvflCanUseCustomPPI in TCustomRVData(RVData).Flags;
  Cursor := crDefault;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.AfterLoading(FileFormat: TRVLoadFormat);
begin
  inherited;
  FUpdated := False;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVLabelItemInfo then begin
    TextStyleNo := TRVLabelItemInfo(Source).TextStyleNo;
    Text    := TRVLabelItemInfo(Source).Text;
    ProtectTextStyleNo := TRVLabelItemInfo(Source).ProtectTextStyleNo;
    MinWidth := TRVLabelItemInfo(Source).MinWidth;
    Alignment := TRVLabelItemInfo(Source).Alignment;
    Cursor := TRVLabelItemInfo(Source).Cursor;
  end;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.DoPaint(r: TRect; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo;
  ColorMode: TRVColorMode; const Text: String);
var TextDrawState: TRVTextDrawStates;
    i, Len, TextWidth, Dummy, l, w, w2: Integer;
    PDx: PRVIntegerArray;
begin
  TextDrawState := [];
  if rvidsSelected in State then
    include(TextDrawState, rvtsSelected);
  if rvidsControlFocused in State then
    include(TextDrawState, rvtsControlFocused);
  if rvidsHover in State then
    include(TextDrawState, rvtsHover);
  RVStyle.ApplyStyle(Canvas, TextStyleNo, rvbdUnspecified,
    rvidsCanUseCustomPPI in State, nil, False, False);
  RVStyle.ApplyStyleColor(Canvas,TextStyleNo,TextDrawState, False, ColorMode);
  if not (rvidsSelected in State) and
     ((Style.FieldHighlightType=rvfhAlways) or
      ((Style.FieldHighlightType=rvfhCurrent) and
      ([rvidsCurrent,rvidsControlFocused]*State=[rvidsCurrent,rvidsControlFocused]))) then begin
    Canvas.Brush.Style := bsSolid;
    Canvas.Brush.Color := Style.FieldHighlightColor;
  end;
  if Canvas.Brush.Style<>bsClear then
    Style.GraphicInterface.FillRect(Canvas, r);
  if Hidden then
    Canvas.Font.Style := Canvas.Font.Style-[fsUnderline];
  TextWidth := Style.GraphicInterface.TextWidth(Canvas, Text);
  if (MinWidth>0) or (TextWidth=r.Right-r.Left) or
    (RVStyle.TextStyles[TextStyleNo].BiDiMode<>rvbdUnspecified) then
    Style.GraphicInterface.DrawText(Canvas, PChar(Text), Length(Text), r,
      Alignment)
  else begin
    Len := Length(Text);
    GetMem(PDx, Len*2*sizeof(Integer));
    try
      RVU_GetTextExtentExPoint(Canvas,
        {$IFDEF RVUNICODESTR}RVU_GetRawUnicode{$ENDIF}(Text),
         $FFFFFFF, Dummy, PDx,
        [{$IFDEF RVUNICODESTR}rvioUnicode{$ENDIF}], Style.GraphicInterface);
      for i := Len-1 downto 1 do
        dec(PDx[i], PDx[i-1]);
      w := r.Right-r.Left-TextWidth;
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
      Style.GraphicInterface.ExtTextOut_(Canvas, r.Left, r.Top, 0, nil,
        Pointer(Text), Len, Pointer(PDx));
    finally
      FreeMem(PDx);
    end;
  end;
  if Hidden then
    RVDrawHiddenUnderline(Canvas, Canvas.Font.Color,
      r.Left, r.Right, r.Bottom, Style.GraphicInterface);
  Canvas.Brush.Style := bsClear;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Paint(x, y: Integer; Canvas: TCanvas;
  State: TRVItemDrawStates; Style: TRVStyle; dli: TRVDrawLineInfo);
begin
  UpdateMe;
  DoPaint(Bounds(x, y+YOffs, Width, Height), Canvas, State, Style, dli, rvcmColor, Text);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Print(Canvas: TCanvas; x, y, x2: Integer;
  Preview, Correction: Boolean; const sad: TRVScreenAndDevice;
  RichView: TRVScroller; dli: TRVDrawLineInfo; Part: Integer;
  ColorMode: TRVColorMode; RVData: TPersistent);
var r: TRect;
   DrawStates: TRVItemDrawStates;
begin
  UpdateMe;
  inc(y, RV_YToDevice(YOffs, sad));
  {
  r := Rect(x, y, Width, Height);
  r.Right  := RV_XToDevice(r.Right,  sad);
  r.Bottom := RV_YToDevice(r.Bottom, sad);
  inc(r.Right,  x);
  inc(r.Bottom, y);
  }
  r := Bounds(x, y, dli.Width, dli.Height);
  DrawStates := [];
  if rvflCanUseCustomPPI in TCustomRVData(RVData).Flags then
    Include(DrawStates, rvidsCanUseCustomPPI);
  DoPaint(r, Canvas, DrawStates, TCustomRVData(RVData).GetRVStyle, dli, ColorMode,
    GetTextForPrinting(RVData, dli));
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetBoolValueEx(Prop: TRVItemBoolPropertyEx;
  RVStyle: TRVStyle): Boolean;
begin
  case Prop of
    rvbpDisplayActiveState:
      Result := RVStyle.FieldHighlightType=rvfhCurrent;
    rvbpActualPrintSize:
      Result := True;
    rvbpJump, rvbpAllowsFocus,rvbpXORFocus:
      Result := RVStyle.TextStyles[TextStyleNo].Jump;
    rvbpHotColdJump:
      Result := RVStyle.TextStyles[TextStyleNo].Jump and
                RVStyle.StyleHoverSensitive(StyleNo);
   rvbpPrintToBMP:
     Result := False;
   else
     Result := inherited GetBoolValueEx(Prop, RVStyle);
  end;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetBoolValue(Prop: TRVItemBoolProperty): Boolean;
begin
  case Prop of
    rvbpCanSaveUnicode:
      Result := True;
    rvbpAlwaysInText:
      Result := True;
    rvbpDrawingChangesFont:
      Result := True;
    rvbpSwitchToAssStyleNo:
      Result := not ProtectTextStyleNo;
    else
      Result := inherited GetBoolValue(Prop);
  end;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetHeight(RVStyle: TRVStyle): Integer;
begin
  UpdateMe;
  Result := Height;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetWidth(RVStyle: TRVStyle): Integer;
begin
  UpdateMe;
  Result := Width;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetMinWidth(sad: PRVScreenAndDevice; Canvas: TCanvas;
  RVData: TPersistent): Integer;
begin
  UpdateMe;
  Result := Width;
  if Sad<>nil then
    Result := RV_XToDevice(Result, sad^);
  if TCustomRVData(RVData).GetRVStyle.GetAsDevicePixelsX(MinWidth, sad)>Result then
    Result := TCustomRVData(RVData).GetRVStyle.GetAsDevicePixelsX(MinWidth, sad);
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetTextForPrintMeasuring(RVData: TPersistent): String;
begin
  Result := Text;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetTextForPrinting(RVData: TPersistent;
  DrawItem: TRVDrawLineInfo): String;
begin
  Result := Text;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SavePropertiesToRVF(Stream: TStream; RVData: TPersistent);
begin
   RVFWriteLine(Stream, RVFSaveText(TCustomRVData(RVData).GetRVStyle,
    rvfoUseStyleNames in TCustomRVData(RVData).RVFOptions, TextStyleNo));
   RVFWriteLine(Stream, RVIntToStr(MinWidth));
   RVFWriteLine(Stream, RVIntToStr(ord(Alignment)));
   if ProtectTextStyleNo then
     RVFWriteLine(Stream, 'protect')
   else
     RVFWriteLine(Stream, 'no-protect');
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
   // if you want to modify saving/loading, modify
   // 1) second parameter in header - number of additional lines
   // 2) lines after header
   // Do not change other parameters in header
   RVFWriteLine(Stream,
     {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
       [StyleNo, 6+GetRVFExtraPropertyCount {Line count after header},
        RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
        Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
        0 {text mode saving},
        RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
        SaveRVFHeaderTail(RVData)]));
   // lines after header
   {0} RVFWriteLine(Stream, StringToRVFString(Text));
   {1,2,3,4} SavePropertiesToRVF(Stream, RVData);
   {5} RVFWriteLine(Stream, Name);
   SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetRVFExtraPropertyCount: Integer;
begin
  Result := inherited GetRVFExtraPropertyCount;
  if RemoveInternalLeading then
    inc(Result);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SaveRVFExtraProperties(Stream: TStream);
begin
  inherited SaveRVFExtraProperties(Stream);
  if RemoveInternalLeading then
    RVFWriteLine(Stream, 'removeinternalleading'+'=1');
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.SetExtraCustomProperty(const PropName: TRVAnsiString;
  const Value: String): Boolean;
begin
  if PropName='removeinternalleading' then begin
    Result := True;
    RemoveInternalLeading := Value<>'0';
    end
  else
    Result := inherited SetExtraCustomProperty(PropName, Value);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.LoadPropertiesFromRVF(const s: TRVRawByteString; Index: Integer;
  RVData: TPersistent; UTF8Strings: Boolean; var TextStyleNameUsed: Boolean);
var P: PRVAnsiChar;
    V: Integer;
begin
  case Index of
    0:
      begin
        P := PRVAnsiChar(s);
        RVFReadTextStyle(TCustomRVData(RVData).GetRVStyle, P, V,
          UTF8Strings, TextStyleNameUsed);
        TextStyleNo := V;
      end;
    1:
      MinWidth := RVStrToInt(s);
    2:
      Alignment := TAlignment(RVStrToInt(s));
    3:
      ProtectTextStyleNo := s='protect';
  end;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
  ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
  var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  case LineNo of
    0:
      Text := RVFStringToString(s, UTF8Strings);
    1..4:
      LoadPropertiesFromRVF(s, LineNo-1, RVData, UTF8Strings, AssStyleNameUsed);
    5:
      begin
        Name := s;
        ParentRVData := RVData;
      end;
    else
      SetExtraPropertyFromRVFStr(s, UTF8Strings);
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.MarkStylesInUse(Data: TRVDeleteUnusedStylesData);
begin
  inherited MarkStylesInUse(Data);
  Data.UsedTextStyles[TextStyleNo] := 1;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.UpdateStyles(Data: TRVDeleteUnusedStylesData);
begin
  inherited UpdateStyles(Data);
  TextStyleNo := TextStyleNo-(Data.UsedTextStyles[TextStyleNo]-1);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.ApplyStyleConversion(RVData: TPersistent;
  ItemNo, UserData: Integer; ConvType: TRVEStyleConversionType);
var V: Integer;
begin
  if ProtectTextStyleNo then
    exit;
  V := TextStyleNo;
  TCustomRVFormattedData(RVData).DoCurrentTextStyleConversion(V, ParaNo,
    ItemNo, UserData, False);
  TextStyleNo := V;
  FUpdated := False;
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
procedure TRVLabelItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer; TwipsPerPixel: Double;
  Level: Integer; ColorList: TRVColorList; StyleToFont,
  ListOverrideOffsetsList1, ListOverrideOffsetsList2: TRVIntegerList;
  FontTable: TRVList; HiddenParent: Boolean);
begin
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVFWrite(Stream,
    {$IFDEF RVUNICODESTR}
    RVMakeRTFStrW(Text, TCustomRVData(RVData).GetStyleCodePage(TextStyleNo),
      rvrtfDuplicateUnicode in TCustomRVData(RVData).RTFOptions, False, False, False)
    {$ELSE}
    RVMakeRTFStr(Text, False, True, False)
    {$ENDIF}
    );
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');    
end;
{$ENDIF}
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSEHTML}
procedure TRVLabelItemInfo.SaveToHTML(Stream: TStream; RVData: TPersistent;
  ItemNo: Integer; const Text: TRVRawByteString; const Path, imgSavePrefix: String;
  var imgSaveNo: Integer; CurrentFileColor: TColor;
  SaveOptions: TRVSaveOptions; UseCSS: Boolean; Bullets: TRVList);
var s: TRVRawByteString;
begin
  if UseCSS and (VAlign in [rvvaLeft, rvvaRight]) then begin
    if VAlign=rvvaLeft then
      s := 'left'
    else
      s := 'right';
    RVFWrite(Stream, '<div style="float: '+s+';">');
  end;
  {$IFDEF RVUNICODESTR}
  s := RVU_GetRawUnicode(Self.Text);
  if rvsoUTF8 in SaveOptions then
    s := RVU_GetHTMLUTF8EncodedUnicode(s, False, TCustomRVData(RVData).NextItemFromSpace(ItemNo))
  else
    s := RVU_GetHTMLEncodedUnicode(s, False, TCustomRVData(RVData).NextItemFromSpace(ItemNo));
  {$ELSE}
  s := RV_MakeHTMLStr(Self.Text, False, TCustomRVData(RVData).NextItemFromSpace(ItemNo));
  if rvsoUTF8 in SaveOptions then
    s := RVU_AnsiToUTF8(TCustomRVData(RVData).GetStyleCodePage(TextStyleNo), s);
  {$ENDIF}
  RVFWrite(Stream, s);
  if UseCSS and (VAlign in [rvvaLeft, rvvaRight]) then
    RVFWrite(Stream, '</div>');

end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.AsText(LineWidth: Integer; RVData: TPersistent;
  const Text: TRVRawByteString; const Path: String;
  TextOnly, Unicode: Boolean): TRVRawByteString;
begin
  {$IFDEF RVUNICODESTR}
  if Unicode then
    Result := RVU_GetRawUnicode(Self.Text)
  else
    Result := TRVAnsiString(Self.Text);
  {$ELSE}
  if Unicode then
    Result := RVU_AnsiToUnicode(TCustomRVData(RVData).GetRVStyle.DefCodePage, Self.Text)
  else
    Result := Self.Text;
  {$ENDIF}
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Inserted(RVData: TObject; ItemNo: Integer);
begin
  if RVData<>nil then begin
    ParentRVData := TCustomRVData(RVData);
    FCanUseCustomPPI := rvflCanUseCustomPPI in TCustomRVData(RVData).Flags;
  end;
  inherited Inserted(RVData, ItemNo);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Execute(RVData: TPersistent);
begin
  if RVData is TCustomRVFormattedData then begin
    if GetBoolValueEx(rvbpJump, TCustomRVData(RVData).GetRVStyle) then
      TCustomRVFormattedData(RVData).DoJump(JumpID+
          TCustomRVFormattedData(RVData).FirstJumpNo)
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetMinWidth(const Value: TRVStyleLength);
begin
  if FMinWidth<>Value then begin
    FMinWidth := Value;
    FUpdated := False;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetAlignment(const Value: TAlignment);
begin
  FAlignment := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.DoUpdateMe(var Width, Height, YOffs, Descend: Integer;
  CanUseCustomPPI, CompareMinWidth: Boolean;
  RVData: TPersistent; const Text: String; DefCanvas: TCanvas);
var Canvas: TCanvas;
    UseFormatCanvas: Boolean;
    TextMetric: TTextMetric;
begin
   if (RVStyle=nil) then
     exit;
   if RVData is TCustomRVFormattedData then
     Canvas := TCustomRVFormattedData(RVData).GetFormatCanvasEx(nil)
   else
     Canvas := nil;
   UseFormatCanvas := Canvas<>nil;
   if not UseFormatCanvas then begin
     Canvas := DefCanvas;
     if Canvas=nil then
       Canvas := RVStyle.GraphicInterface.CreateScreenCanvas;
   end;
   try
     RVStyle.ApplyStyle(Canvas, TextStyleNo, rvbdUnspecified, CanUseCustomPPI,
       nil, False, UseFormatCanvas);
     FillChar(TextMetric, sizeof(TextMetric), 0);
     RVStyle.GraphicInterface.GetTextMetrics(Canvas, TextMetric);
     Descend := TextMetric.tmDescent;
     Height  := TextMetric.tmHeight;
     if RemoveInternalLeading then begin
       dec(Height, TextMetric.tmInternalLeading);
       YOffs := - TextMetric.tmInternalLeading;
       end
     else
       YOffs := 0;
     Width := RVStyle.GraphicInterface.TextWidth(Canvas, Text);
     if UseFormatCanvas then begin
       Height := RVConvertFromFormatCanvas(Height, UseFormatCanvas);
       Width  := RVConvertFromFormatCanvas(Width, UseFormatCanvas);
       YOffs  := RVConvertFromFormatCanvas(YOffs, UseFormatCanvas);
       Descend := RVConvertFromFormatCanvas(Descend, UseFormatCanvas);
     end;
     if CompareMinWidth and (Width<RVStyle.GetAsPixels(MinWidth)) then
       Width := RVStyle.GetAsPixels(MinWidth);
   finally
     if not UseFormatCanvas and (Canvas<>DefCanvas) then
       RVStyle.GraphicInterface.DestroyScreenCanvas(Canvas);
   end;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.UpdateMe;
begin
   if FUpdated then
     exit;
   DoUpdateMe(Width, Height, YOffs, Descend, FCanUseCustomPPI, True,
     FParentRVData, Text, nil);
   FUpdated := True;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.OnDocWidthChange(DocWidth: Integer;
  dli: TRVDrawLineInfo; Printing: Boolean; Canvas: TCanvas;
  RVData: TPersistent; sad: PRVScreenAndDevice; var HShift, Desc: Integer;
  NoCaching, Reformatting, UseFormatCanvas: Boolean);
var LYOffs, w: Integer;
begin
  inherited;
  if not UseFormatCanvas and ((sad=nil) or
     ((sad.ppixScreen=sad.ppixDevice) and (sad.ppiyScreen=sad.ppiyDevice))) then begin
    UpdateMe;
    dli.Width := Width;
    dli.Height := Height;
    Desc := Descend;
    end
  else begin
    DoUpdateMe(dli.Width, dli.Height, LYOffs, Desc,
      rvflCanUseCustomPPI in TCustomRVData(RVData).Flags, False,
      RVData, GetTextForPrintMeasuring(RVData), Canvas);
    if MinWidth>0 then begin
      w := TCustomRVData(RVData).GetRVStyle.GetAsDevicePixelsX(MinWidth, sad);
      if w>dli.Width then
        dli.Width := w;
    end;
  end;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetFinalPrintingWidth(Canvas: TCanvas;
  dli: TRVDrawLineInfo; RVData: TPersistent): Integer;
var a,b,c: Integer;
begin
  DoUpdateMe(Result, a, b, c, rvflCanUseCustomPPI in TCustomRVData(RVData).Flags,
    True, RVData, GetTextForPrinting(RVData, dli), Canvas);
  {
  TCustomRVData(RVData).GetRVStyle.ApplyStyle(Canvas, TextStyleNo, rvbdUnspecified,
    rvflCanUseCustomPPI in TCustomRVData(RVData).Flags, nil, False, False);
  Result := TCustomRVData(RVData).GetRVStyle.GraphicInterface.TextWidth(
    Canvas, GetTextForPrinting(RVData, dli));
  }
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.MouseMove(Shift: TShiftState; X, Y,
  ItemNo: Integer; RVData: TObject): Boolean;
begin
  Result := inherited MouseMove(Shift, X, Y, ItemNo, RVData);
  if Cursor<>crDefault then begin
    TCustomRVFormattedData(RVData).SetCursor(Cursor);
    Result := True;
  end;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetAssociatedTextStyleNo: Integer;
begin
  Result := TextStyleNo;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetAssociatedTextStyleNo(Value: Integer);
begin
  TextStyleNo := Value;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetRVStyle: TRVStyle;
begin
  Result := TCustomRVData(FParentRVData).GetRVStyle;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetParentRVData(const Value: TPersistent);
begin
  FParentRVData := Value;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.MovingFromUndoList(ItemNo: Integer;
  RVData: TObject);
begin
  inherited;
  ParentRVData := TCustomRVData(RVData);
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.MovingToUndoList(ItemNo: Integer; RVData,
  AContainerUndoItem: TObject);
begin
  inherited;
  ParentRVData := TRVUndoInfo(AContainerUndoItem).GetUndoListOwnerRVData;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.Changed;
begin
  FUpdated := False;
end;
{------------------------------------------------------------------------------}
function TRVLabelItemInfo.GetTextStyleNo: Integer;
begin
  Result := FTextStyleNo;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetText(const Value: String);
begin
  FText := Value;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.SetTextStyleNo(const Value: Integer);
begin
  FTextStyleNo := Value;
  Changed;
end;
{------------------------------------------------------------------------------}
procedure TRVLabelItemInfo.ConvertToDifferentUnits(NewUnits: TRVStyleUnits;
  RVStyle: TRVStyle; Recursive: Boolean);
begin
  inherited;
  MinWidth := RVStyle.GetAsDifferentUnits(MinWidth, NewUnits);
end;

initialization

  RegisterRichViewItemClass(rvsLabel, TRVLabelItemInfo);

end.
