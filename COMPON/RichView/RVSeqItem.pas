{*******************************************************}
{                                                       }
{       RichView                                        }
{       Sequence Item - item class for RichView.        }
{       Automatic numbering                             }
{                                                       }
{       Copyright (c) Sergey Tkachenko                  }
{       svt@trichview.com                               }
{       http://www.trichview.com                        }
{                                                       }
{*******************************************************}
unit RVSeqItem;

{$I RV_Defs.inc}

interface
uses
     {$IFDEF RICHVIEWDEF2009}AnsiStrings,{$ENDIF}
     SysUtils, Classes,
     {$IFNDEF RVDONOTUSESEQ}
     RVLabelItem,
     {$ENDIF}
     RVFuncs, RVFMisc, RVStyle, RVItem, RVClasses, RVTypes;

{$IFNDEF RVDONOTUSESEQ}

const
  rvsSequence = -202;

type

  TRVSeqList = class;

  TRVSeqItemInfo = class(TRVLabelItemInfo)
    private
      FNumberType: TRVSeqType;
    protected
      FCachedIndexInList: Integer;
      procedure CalcDisplayString(List: TRVSeqList); dynamic;
      function GetNumberType: TRVSeqType; virtual;
      procedure SetNumberType(const Value: TRVSeqType); virtual;
    public
      Counter, StartFrom: Integer;
      Reset: Boolean;
      SeqName, FormatString: String;
      constructor CreateEx(RVData: TPersistent; const ASeqName: String;
        ANumberType: TRVSeqType;
        ATextStyleNo, AStartFrom: Integer; AReset: Boolean);
      constructor Create(RVData: TPersistent); override;
      function GetIndexInList(List: TList): Integer;
      procedure MovingToUndoList(ItemNo: Integer; RVData,
        AContainerUndoItem: TObject); override;
      procedure MovingFromUndoList(ItemNo: Integer; RVData: TObject); override;
      procedure Assign(Source: TCustomRVItemInfo); override;
      function GetDisplayString(List: TRVSeqList; ACounter: Integer): String;      
      {$IFNDEF RVDONOTUSERTF}
      procedure SaveRTF(Stream: TStream; const Path: String;
        RVData: TPersistent; ItemNo: Integer;
        TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
        StyleToFont, ListOverrideOffsetsList1,
        ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
        HiddenParent: Boolean); override;
      {$ENDIF}
      procedure SaveRVF(Stream: TStream; RVData: TPersistent;
        ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
        ForceSameAsPrev: Boolean); override;
      function ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
        ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
        var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
        UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean; override;
      property NumberType: TRVSeqType read GetNumberType write SetNumberType;
  end;

  TRVSeqList = class (TList)
  public
    function InsertAfter(InsertMe, AfterMe: TRVSeqItemInfo): Integer;
    procedure RecalcCounters(StartFrom: Integer; RVStyle: TRVStyle);
    procedure RecalcDisplayStrings(RVStyle: TRVStyle);
  end;

{$ENDIF}

implementation

{$IFNDEF RVDONOTUSESEQ}
uses CRVData, RVScroll;

{================================== TRVSeqItemInfo ============================}
constructor TRVSeqItemInfo.Create(RVData: TPersistent);
begin
  inherited;
  StyleNo := rvsSequence;
  FCachedIndexInList := -1;
end;
{------------------------------------------------------------------------------}
constructor TRVSeqItemInfo.CreateEx(RVData: TPersistent;
  const ASeqName: String; ANumberType: TRVSeqType;
  ATextStyleNo, AStartFrom: Integer; AReset: Boolean);
begin
  inherited CreateEx(RVData, ATextStyleNo, '');
  StartFrom := AStartFrom;
  Reset := AReset;
  if ASeqName<>'' then
    SeqName := ASeqName
  else
    SeqName := 'trichview';
  NumberType := ANumberType;
  StyleNo := rvsSequence;
  FCachedIndexInList := -1;
end;
{------------------------------------------------------------------------------}
function TRVSeqItemInfo.GetDisplayString(List: TRVSeqList; ACounter: Integer): String;
  {.......................................................}
  function Number2Str: String;
  begin
    case NumberType of
      rvseqDecimal:
        Result := IntToStr(ACounter);
      rvseqLowerAlpha:
        Result := LowerCase(RV_IntToAlpha(ACounter));
      rvseqUpperAlpha:
        Result := RV_IntToAlpha(ACounter);
      rvseqUpperRoman:
        Result := RV_IntToRoman(ACounter);
      rvseqLowerRoman:
        Result := LowerCase(RV_IntToRoman(ACounter));
      else
        Result := '';
    end;
  end;
  {.......................................................}
begin
  Result := Number2Str;
  if FormatString<>'' then
    Result := Format(FormatString, [Result]);
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.CalcDisplayString(List: TRVSeqList);
begin
  Text := GetDisplayString(List, Counter);
  FUpdated := False;
end;
{------------------------------------------------------------------------------}
function TRVSeqItemInfo.GetIndexInList(List: TList): Integer;
begin
  if List=nil then begin
    Result := -1;
    exit;
  end;
  if (FCachedIndexInList<0) or (FCachedIndexInList>=List.Count) or
     (List.Items[FCachedIndexInList]<>Self) then
    FCachedIndexInList := List.IndexOf(Self);
  Result := FCachedIndexInList;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.MovingFromUndoList(ItemNo: Integer;
  RVData: TObject);
begin
  inherited;
  TCustomRVData(RVData).AddSeqInList(ItemNo);
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.Assign(Source: TCustomRVItemInfo);
begin
  if Source is TRVSeqItemInfo then begin
    NumberType := TRVSeqItemInfo(Source).NumberType;
    StartFrom := TRVSeqItemInfo(Source).StartFrom;
    Reset     := TRVSeqItemInfo(Source).Reset;
    SeqName   := TRVSeqItemInfo(Source).SeqName;
    FormatString := TRVSeqItemInfo(Source).FormatString;    
  end;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.MovingToUndoList(ItemNo: Integer; RVData,
  AContainerUndoItem: TObject);
begin
  inherited;
  TCustomRVData(RVData).DeleteSeqFromList(TCustomRVData(RVData).GetItem(ItemNo),
    False);
end;
{------------------------------------------------------------------------------}
{$IFNDEF RVDONOTUSERTF}
function GetRTFNumberingType(st: TRVSeqType): String;
begin
  case st of
    rvseqLowerAlpha:
      Result := 'alphabetic';
    rvseqUpperAlpha:
      Result := 'ALPHABETIC';
    rvseqLowerRoman:
      Result := 'roman';
    rvseqUpperRoman:
      Result := 'ROMAN';
    else
      Result := '';
  end;
  if Result<>'' then
    Result := ' \\* '+Result;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.SaveRTF(Stream: TStream; const Path: String;
  RVData: TPersistent; ItemNo: Integer;
  TwipsPerPixel: Double; Level: Integer; ColorList: TRVColorList;
  StyleToFont, ListOverrideOffsetsList1,
  ListOverrideOffsetsList2: TRVIntegerList; FontTable: TRVList;
  HiddenParent: Boolean);
var ResetStr, SeqNameStr, TextStr: TRVAnsiString;
begin
  if Reset then
    ResetStr := ' \\r '+RVIntToStr(StartFrom)
  else
    ResetStr := '';
  SeqNameStr := MakeRTFIdentifierStr(SeqName,
    TCustomRVData(RVData).GetRVStyle.DefCodePage,
    rvrtfDuplicateUnicode in TCustomRVData(RVData).RTFOptions);
  TextStr := MakeRTFIdentifierStr(Text,
    TCustomRVData(RVData).GetRVStyle.DefCodePage,
    rvrtfDuplicateUnicode in TCustomRVData(RVData).RTFOptions);
  if Hidden or HiddenParent then
    RVFWrite(Stream, '{\v');
  RVFWrite(Stream, {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format(
    '{\field{\*\fldinst {SEQ %s%s%s \\* MERGEFORMAT }}{\fldrslt {%s}}}',
    [SeqNameStr, GetRTFNumberingType(NumberType), ResetStr, TextStr]));
  if Hidden or HiddenParent then
    RVFWrite(Stream, '}');    
end;
{$ENDIF}
{------------------------------------------------------------------------------}
function TRVSeqItemInfo.ReadRVFLine(const s: TRVRawByteString; RVData: TPersistent;
  ReadType, LineNo, LineCount: Integer; var Name: TRVRawByteString;
  var ReadMode: TRVFReadMode; var ReadState: TRVFReadState;
  UTF8Strings: Boolean; var AssStyleNameUsed: Boolean): Boolean;
begin
  case LineNo of
    0:
      SeqName := RVFStringToString(s, UTF8Strings);
    1:
      NumberType := TRVSeqType(RVStrToInt(s));
    2:
      Reset := s<>'0';
    3:
      StartFrom := RVStrToInt(s);
    4..7:
      LoadPropertiesFromRVF(s, LineNo-4, RVData, UTF8Strings, AssStyleNameUsed);
    8:
      begin
        Name := s;
        ParentRVData := RVData;
      end;
    9:
      FormatString := RVFStringToString(s, UTF8Strings);
    else
      SetExtraPropertyFromRVFStr(s, UTF8Strings);
  end;
  Result := True;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.SaveRVF(Stream: TStream; RVData: TPersistent;
  ItemNo, ParaNo: Integer; const Name: TRVRawByteString; Part: TRVMultiDrawItemPart;
  ForceSameAsPrev: Boolean);
begin
   RVFWriteLine(Stream,
     {$IFDEF RVUNICODESTR}AnsiStrings.{$ENDIF}Format('%d %d %s %d %d %s %s',
       [StyleNo, 10+GetRVFExtraPropertyCount {Line count after header},
        RVFItemSavePara(ParaNo, TCustomRVData(RVData), ForceSameAsPrev),
        Byte(RVFGetItemOptions(ItemOptions, ForceSameAsPrev)) and RVItemOptionsMask,
        0 {text mode saving},
        RVFSaveTag(rvoTagsArePChars in TCustomRVData(RVData).Options,Tag),
        SaveRVFHeaderTail(RVData)]));
   // lines after header
   {0}RVFWriteLine(Stream, StringToRVFString(SeqName));
   {1}RVFWriteLine(Stream, RVIntToStr(ord(NumberType)));
   {2}RVFWriteLine(Stream, RVIntToStr(ord(Reset)));
   {3}RVFWriteLine(Stream, RVIntToStr(StartFrom));
   {4,5,6,7} SavePropertiesToRVF(Stream, RVData);
   {8}RVFWriteLine(Stream, Name);
   {9}RVFWriteLine(Stream, StringToRVFString(FormatString));
   SaveRVFExtraProperties(Stream);
end;
{------------------------------------------------------------------------------}
function TRVSeqItemInfo.GetNumberType: TRVSeqType;
begin
  Result := FNumberType;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqItemInfo.SetNumberType(const Value: TRVSeqType);
begin
  FNumberType := Value;
end;
{================================== TRVSeqList ================================}
function TRVSeqList.InsertAfter(InsertMe,
  AfterMe: TRVSeqItemInfo): Integer;
begin
  if AfterMe = nil then
    Result := 0
  else
    Result := AfterMe.GetIndexInList(Self)+1;
  Insert(Result, InsertMe);
  InsertMe.FCachedIndexInList := Result;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqList.RecalcCounters(StartFrom: Integer; RVStyle: TRVStyle);
var i,j: Integer;
    SeqName: String;
    Seq, SeqJ: TRVSeqItemInfo;
begin
  if StartFrom>=Count then
    exit;
  SeqName := AnsiLowerCase(TRVSeqItemInfo(Items[StartFrom]).SeqName);
  for i := StartFrom to Count-1 do begin
    Seq := TRVSeqItemInfo(Items[i]);
    if AnsiLowerCase(Seq.SeqName)=SeqName then begin
      if Seq.Reset then
        Seq.Counter := Seq.StartFrom
      else begin
        Seq.Counter := 1;
        for j := i-1 downto 0 do begin
          SeqJ := TRVSeqItemInfo(Items[j]);
          if AnsiLowerCase(SeqJ.SeqName)=SeqName then begin
            Seq.Counter := SeqJ.Counter+1;
            break;
          end;
        end;
      end;
      Seq.CalcDisplayString(Self);
    end;
  end;
end;
{------------------------------------------------------------------------------}
procedure TRVSeqList.RecalcDisplayStrings(RVStyle: TRVStyle);
var i: Integer;
begin
  for i := 0 to Count-1 do
    TRVSeqItemInfo(Items[i]).CalcDisplayString(Self);
end;
{==============================================================================}

initialization

  RegisterRichViewItemClass(rvsSequence, TRVSeqItemInfo);

{$ENDIF}

end.
