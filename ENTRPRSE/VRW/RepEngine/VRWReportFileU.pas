unit VRWReportFileU;
{
  Classes to save and load report files.

  TVRWReportFile_Ver_1 can read old (version 1) format report files, and can write
  them back as version 2 format report files.

  TVRWReportFile_Ver_2 can read and write new (version 2) format report files.

  These classes should not be instantiated directly. Instead, the factory
  function GetVRWReportFile should be used to get an interface to the
  appropriate class for the required file format version.
}
interface

uses SysUtils, Classes,
  GlobalTypes, CtrlPrms, VRWReportIF, RepEngIF, oRepEngineManager, RptPersist,
  Graphics, GmXML, ExtCtrls;

type
  IVRWReportFile = interface
    function GetConversionError: string;
    procedure Init(Report: IVRWReport; ReportFileName,
      ReportFilePath: ShortString);
    procedure Read;
    procedure Write(WithCompression: Boolean);
    property ConversionError: string read GetConversionError;
  end;

  TVRWReportFileInfo = record
    Version: SmallInt;
    Compressed: Boolean;
  end;

  { Base class. Cannot be instantiated (contains abstract methods). }
  TVRWReportFile = class(TInterfacedObject, IVRWReportFile)
  private
    FConversionError: string;
    FFileName: ShortString;
    FFilePath: ShortString;
    FReport: IVRWReport;
    procedure SetFilePath(const Value: ShortString);
  public
    function GetConversionError: string;
    procedure Init(Report: IVRWReport; ReportFilePath,
      ReportFileName: ShortString); virtual;
    procedure Read; virtual; abstract;
    procedure Write(WithCompression: Boolean = True); virtual; abstract;
    property FileName: ShortString read FFileName write FFileName;
    property FilePath: ShortString read FFilePath write SetFilePath;
    property Report: IVRWReport read FReport write FReport;
  end;

  { Class to read version 1 (old-style) ERF report files. }
  TVRWReportFile_Ver_1 = class(TVRWReportFile)
  { Yes, it's a non-standard naming convention, but this class should never
    be referenced by name outside of this unit -- the GetVRWReportFile function
    should be used to get an IVRWReportFile interface instead. }
  private
    ReportPersistor : TReportPersistor;
    function AdjustFormula(Formula: ShortString): ShortString;
    function ArrayToOptionArray(BooleanArray: array of Boolean): TOptionArray;
    procedure ClearPersistor;
    procedure LoadReportFile;
    procedure PopulateControls(Region: IVRWRegion; RegionIndex: SmallInt);
    procedure PopulateImage(RegionIndex: SmallInt; Control: IVRWImageControl);
    procedure PopulateRegions;
    procedure PopulateReport;
    procedure ReadText(Control: IVRWTextControl;
      pControlParameters: PCtrlParams);
    procedure ReadImage(Control: IVRWImageControl;
      pControlParameters: PCtrlParams; RegionIndex: SmallInt);
    procedure ReadLine(Control: IVRWBoxControl;
      pControlParameters: PCtrlParams);
    procedure ReadField(Control: IVRWFieldControl;
      pControlParameters: PCtrlParams);
    procedure ReadFormula(Control: IVRWFormulaControl;
      pControlParameters: PCtrlParams);
  public
    destructor Destroy; override;
    procedure Init(Report: IVRWReport; ReportFileName,
      ReportFilePath: ShortString); override;
    procedure Read; override;
    procedure Write(WithCompression: Boolean); override;
  end;

  { Class to read version 2 (new-style) ERF report files. }
  TVRWReportFile_Ver_2 = class(TVRWReportFile)
  private
    procedure ReadInputFields(Node: TgmXMLNode);
    procedure ReadRegions(Node: TgmXMLNode);
    procedure ReadControls(Region: IVRWRegion; Node: TgmXMLNode);
    procedure ReadFontStyle(Nodes: TgmXMLNodeList; NodeName: string;
      Style: TFontStyle; var Styles: TFontStyles);
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: ShortString): ShortString; overload;
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: LongInt): LongInt; overload;
    function ReadXML(Nodes: TgmXMLNodeList; PropertyName: ShortString;
      Default: Boolean): Boolean; overload;
    function StringToOptionArray(OptionStr: string): TOptionArray;
    function OptionArrayToString(OptionArray: TOptionArray): string;
  public
    procedure Read; override;
    procedure Write(WithCompression: Boolean); override;
  end;

function GetVRWReportFile(FileName: ShortString;
  var Version: SmallInt): IVRWReportFile;

function GetVRWReportFileWriter(Version: SmallInt): IVRWReportFile;

function ERFVersion(FileName: ShortString): TVRWReportFileInfo;

implementation

uses HexConverter, Dialogs, ZLib;

const
  { Identifying string -- appears unencrypted at the start of the new format
    report files. The first byte indicates whether or not the file is
    compressed, and the last byte is intended to be the version number. }
  VER_2_FILE_ID            = #221#250#206#208#200;
  VER_2_COMPRESSED_FILE_ID = #222#250#206#208#200;

function ERFVersion(FileName: ShortString): TVRWReportFileInfo;
var
  FileIn: TFileStream;
  Buffer: array[0..Length(VER_2_FILE_ID) - 1] of Char;
begin
  FileIn := TFileStream.Create(FileName, fmOpenRead, fmShareDenyNone);
  try
    { Read the first chunk of the file }
    FileIn.Read(Buffer, Length(Buffer));
    { Look for the version's file identifier }
    if (Buffer = VER_2_FILE_ID) then
    begin
      { New format file, uncompressed }
      Result.Version := 2;
      Result.Compressed := False;
    end
    else if (Buffer = VER_2_COMPRESSED_FILE_ID) then
    begin
      { New format file, compressed }
      Result.Version := 2;
      Result.Compressed := False;
    end
    else
    begin
      { If it wasn't found, assume that this is an old format file }
      Result.Version := 1;
      Result.Compressed := False;
    end;
  finally
    FileIn.Free;
  end;
end;

function GetVRWReportFile(FileName: ShortString;
  var Version: SmallInt): IVRWReportFile;
{ Factory function to return an instance of the correct Report File for reading
  the specified report file. Returns nil if the version is not supported. }
var
  Info: TVRWReportFileInfo;
begin
  Info := ERFVersion(FileName);
  case Info.Version of
    1: Result := TVRWReportFile_Ver_1.Create;
    2: Result := TVRWReportFile_Ver_2.Create;
  else
    Result := nil;
  end;
end;

function GetVRWReportFileWriter(Version: SmallInt): IVRWReportFile;
{ Factory function to return an instance of the correct Report File for writing
  the specified version. Returns nil if the version is not supported. }
begin
  case Version of
    1: Result := TVRWReportFile_Ver_1.Create;
    2: Result := TVRWReportFile_Ver_2.Create;
  else
    Result := nil;
  end;
end;

procedure CompressStream(inpStream, outStream: TStream);
{ Uses ZLib to compress the data from inpStream, outputting the compressed
  results in outStream. Not currently used. }
var
  InpBuf, OutBuf: Pointer;
  InpBytes, OutBytes: integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  try
    GetMem(InpBuf,inpStream.size);
    inpStream.Position := 0;
    InpBytes := inpStream.Read(InpBuf^,inpStream.size);
    CompressBuf(InpBuf,InpBytes,OutBuf,OutBytes);
    outStream.Write(OutBuf^,OutBytes);
  finally
    if InpBuf <> nil then FreeMem(InpBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
end;

procedure ExpandStream(inpStream, outStream: TStream);
{ Uses ZLib to uncompress the data from inpStream, outputting the uncompressed
  results in outStream. Used by the TVRWReportFile.Read routine. }
var
  InpBuf,OutBuf: Pointer;
  OutBytes,sz: integer;
begin
  InpBuf := nil;
  OutBuf := nil;
  sz := inpStream.size-inpStream.Position;
  if sz > 0 then try
    GetMem(InpBuf,sz);
    inpStream.Read(InpBuf^,sz);
    DecompressBuf(InpBuf,sz,0,OutBuf,OutBytes);
    outStream.Write(OutBuf^,OutBytes);
  finally
    if InpBuf <> nil then FreeMem(InpBuf);
    if OutBuf <> nil then FreeMem(OutBuf);
  end;
  outStream.Position := 0;
end;

{ TVRWReportFile }

function TVRWReportFile.GetConversionError: string;
begin
  Result := FConversionError;
end;

procedure TVRWReportFile.Init(Report: IVRWReport; ReportFilePath,
  ReportFileName: ShortString);
begin
  FReport  := Report;
  FileName := ReportFileName;
  FilePath := ReportFilePath;
end;

procedure TVRWReportFile.SetFilePath(const Value: ShortString);
begin
  FFilePath := IncludeTrailingPathDelimiter(Value);
end;

{ TVRWReportFile_Ver_1 }

function TVRWReportFile_Ver_1.AdjustFormula(
  Formula: ShortString): ShortString;
{ Version 1 formulas did not include brackets with TotalField functions, but
  Version 2 requires them. This function makes sure that correct brackets
  exist.

  This function cannot deal with more than one TotalField in a formula, though
  it will look for them, and will signal the problem by returning a message
  in ErrorStr.
}
var
  CharPos: Integer;
  Count: Integer;
begin
  Count := 0;
  Result := Formula;
  CharPos := Pos('TOTALFIELD ', Uppercase(Result));
  while (CharPos <> 0) do
  begin
    Count := Count + 1;
    Result := Copy(Result, 0, CharPos - 1) +
              'TotalField[' +
              Copy(Result, CharPos + 11, Length(Result)) +
              ']';
    CharPos := Pos('TOTALFIELD ', Uppercase(Result));
  end;
  if (Count > 1) then
    FConversionError := FConversionError +
      'Formula contains more than one TotalField function, and ' +
      'will need to be corrected manually' +
      #13#10#13#10;
end;

function TVRWReportFile_Ver_1.ArrayToOptionArray(
  BooleanArray: array of Boolean): TOptionArray;
var
  OptionPos: Integer;
begin
  for OptionPos := Low(BooleanArray) to High(BooleanArray) do
  begin
    if (OptionPos >= Low(Result)) and (OptionPos <= High(Result)) then
      Result[OptionPos] := BooleanArray[OptionPos];
  end;
end;

procedure TVRWReportFile_Ver_1.ClearPersistor;
begin
  if Assigned(ReportPersistor) then
    FreeAndNil(ReportPersistor);
  ReportPersistor := TReportPersistor.Create(FileName, FilePath);
end;

destructor TVRWReportFile_Ver_1.Destroy;
begin
  { Release the interface reference }
  FReport := nil;
  inherited;
end;

procedure TVRWReportFile_Ver_1.Init(Report: IVRWReport; ReportFileName,
  ReportFilePath: ShortString);
begin
  inherited;
end;

procedure TVRWReportFile_Ver_1.LoadReportFile;
begin
  ClearPersistor;
  ReportPersistor.ReadReportFile;
end;

procedure TVRWReportFile_Ver_1.PopulateControls(Region: IVRWRegion;
  RegionIndex: SmallInt);
var
  ControlList: TList;
  ControlType: TControlType;
  ControlIndex: Integer;
  pControlParameters: PCtrlParams;
  Control: IVRWControl;
begin
  ControlList := TList.Create;
  try
    { Read the control details into ControlList, for all the controls in the
      current region }
    ReportPersistor.GetReportBlock(RegionIndex, ControlList);
    for ControlIndex := 0 to ControlList.Count - 1 do
    begin
      { Read the control details as returned by the Report Persistor }
      pControlParameters := PCtrlParams(ControlList.Items[ControlIndex]);
      { Convert the old control type to the new control type }
      case pControlParameters.cpCtrlType of
        REPORT_TEXT:     ControlType := ctText;
        REPORT_LINE:     ControlType := ctBox;
        REPORT_FORMULA:  ControlType := ctFormula;
        REPORT_DB_FIELD: ControlType := ctField;
        REPORT_IMAGE:    ControlType := ctImage;
      else
        ControlType := ctUnknown;
      end;
      { Create a new control, and fill in the generic details }
      Control := Region.rgControls.Add(Report, ControlType);
      Control.vcTop    := Round((pControlParameters.cpRegionPoint.Y - REGION_BANNER_HEIGHT) / ScalingFactor);
      Control.vcLeft   := Round(pControlParameters.cpRegionPoint.X / ScalingFactor);
      Control.vcWidth  := Round(pControlParameters.cpCtrlWidth / ScalingFactor);
      Control.vcHeight := Round(pControlParameters.cpCtrlHeight / ScalingFactor);
      Control.vcZOrder := pControlParameters.cpZOrder;
      if Length(pControlParameters.DBFieldParams.cpFieldFormat) > 3 then
        { Occasionally -- and only for Formula controls -- the Field Format in
          old reports was filled with garbage (actually, filled with a partial
          and sometimes corrupted copy of the formula definition). If we detect
          Field Formats which are longer than acceptable, ignore them and
          replace them with 'R' (Right-Justify) }
        Control.vcFieldFormat := 'R'
      else
        Control.vcFieldFormat := pControlParameters.DBFieldParams.cpFieldFormat;
      { Now fill in the details that are specific to particular control types }
      case ControlType of
        ctText:    ReadText(Control as IVRWTextControl, pControlParameters);
        ctImage:   ReadImage(Control as IVRWImageControl, pControlParameters, RegionIndex);
        ctBox:     ReadLine(Control as IVRWBoxControl, pControlParameters);
        ctField:   ReadField(Control as IVRWFieldControl, pControlParameters);
        ctFormula: ReadFormula(Control as IVRWFormulaControl, pControlParameters);
      end;
      if (ControlType = ctField) and (Region.rgType <> rtSectionHdr) then
        (Control as IVRWFieldControl).vcSortOrder := '';
      { Release the interface reference }
      Control := nil;
    end;
  finally
    ControlList.Free;
  end;
end;

procedure TVRWReportFile_Ver_1.PopulateImage(RegionIndex: SmallInt;
  Control: IVRWImageControl);
var
  Images: TStringList;
  BmpStream: TMemoryStream;
  BmpIndex: SmallInt;
begin
  { Retrieve the images from the loaded report. }
  Images := TStringList.Create;
  try
    ReportPersistor.GetImageData(RegionIndex, Images);
    { Locate the image which matches the identifier }
    BmpIndex := Images.IndexOf(Control.vcFolio);
    { If the image was found, load it into the control }
    if (BmpIndex > -1) then
    begin
      BmpStream := TMemoryStream.Create;
      try
        { Copy the bitmap into the memory stream }
        BmpStream.WriteBuffer(TRawBMPStore(Images.Objects[BmpIndex]).pBMP^,
                              TRawBMPStore(Images.Objects[BmpIndex]).iBMPSize);
        BmpStream.Position := 0;
        { Copy the bitmap from the memory stream into the TImage }
        Control.vcImage.Picture.Bitmap.LoadFromStream(BmpStream);
        Control.vcImageStream.LoadFromStream(BmpStream);
        Control.vcImageStream.Position := 0;
        Control.ReadImageBuffer;
      finally
        BmpStream.Free;
      end;
    end;
  finally
    Images.Free;
  end;
end;

procedure TVRWReportFile_Ver_1.PopulateRegions;
{ Finds all the regions loaded by the Report Persistor, and creates entries in
  the report for each of them. Assumes that the Report Persistor has already
  loaded the report file. }
var
  RegionCount, RegionIndex: Integer;
  pRegionParameters: PRegionParams;
  Section: TSectionObj;
  Region: IVRWRegion;
  RegionType: TRegionType;
begin
  RegionCount := ReportPersistor.GetRegionCount;
  for RegionIndex := 0 to RegionCount - 1 do
  begin
    pRegionParameters := ReportPersistor.GetRegionParamsByIdx(RegionIndex);
    { Create a TSectionObj to get the details, as this has built-in
      functionality for parsing the section name }
    Section := TSectionObj.Create(pRegionParameters^.rpRegionName);
    try
      { Convert the old Section Type into the new Region Type. There are more
        efficient ways of doing this, but this is the safest way. }
      case Section.ssSectionType of
        sstRepHdr:     RegionType := rtRepHdr;
        sstPageHdr:    RegionType := rtPageHdr;
        sstSectionHdr: RegionType := rtSectionHdr;
        sstRepLines:   RegionType := rtRepLines;
        sstSectionFtr: RegionType := rtSectionFtr;
        sstPageFtr:    RegionType := rtPageFtr;
        sstRepFtr:     RegionType := rtRepFtr;
      else
        RegionType := rtUnknown;
      end;
      { Create a new region, and copy the details into it }
      Region := Report.vrRegions.Add(Report, RegionType, Section.ssSectionNumber);
      Region.rgTop := Round(pRegionParameters^.rpTop / ScalingFactor);
      Region.rgHeight := Round((pRegionParameters^.rpHeight - REGION_BANNER_HEIGHT) / ScalingFactor);
      Region.rgVisible := pRegionParameters^.rpRegionVisible;
      { Read the controls for this region }
      PopulateControls(Region, RegionIndex);
      { Release the interface reference }
      Region := nil;
    finally
      FreeAndNil(Section);
    end;
  end;
end;

procedure TVRWReportFile_Ver_1.PopulateReport;
var
  OldPrintMethodParams: TPrintMethodParams;
  NewPrintMethodParams: IVRWPrintMethodParams;
  OldTestModeParams: TTestModeParams;
  NewTestModeParams: IVRWTestModeParams;
begin
  Report.Clear;
  { Read the report details }
  Report.vrVersion := '';
  Report.vrFilename := ReportPersistor.ReportFilePath +
                       ReportPersistor.ReportFileName;
  Report.vrName := ReportPersistor.ReportName;
  Report.vrDescription := ReportPersistor.ReportDescription;
  Report.vrPaperOrientation := ReportPersistor.ReportPaperOrientation;
  Report.vrIsWizardBased := ReportPersistor.WizardBasedReport;
  Report.vrMainFile := ReportPersistor.ReportMainFile;
  Report.vrMainFileNum := ReportPersistor.ReportMainFileNum;
  Report.vrIndexID := ReportPersistor.ReportIndexID;
//  Report.vrKeyPath := ReportPersistor.ReportBTrvKeyPath;
  { Copy the print method parameters }
  NewPrintMethodParams := Report.GetVrPrintMethodParams;
  OldPrintMethodParams := ReportConstructInfo.PrintMethodParams;
  try
    NewPrintMethodParams.pmPrintMethod   := OldPrintMethodParams.pmPrintMethod;
    NewPrintMethodParams.pmBatch         := OldPrintMethodParams.pmBatch;
    NewPrintMethodParams.pmTypes         := OldPrintMethodParams.pmTypes;
    NewPrintMethodParams.pmCoverSheet    := OldPrintMethodParams.pmCoverSheet;
    NewPrintMethodParams.pmFaxMethod     := OldPrintMethodParams.pmFaxMethod;
    NewPrintMethodParams.pmFaxPrinter    := OldPrintMethodParams.pmFaxPrinter;
    NewPrintMethodParams.pmFaxFrom       := OldPrintMethodParams.pmFaxFrom;
    NewPrintMethodParams.pmFaxFromNo     := OldPrintMethodParams.pmFaxFromNo;
    NewPrintMethodParams.pmFaxTo         := OldPrintMethodParams.pmFaxTo;
    NewPrintMethodParams.pmFaxToNo       := OldPrintMethodParams.pmFaxToNo;
    NewPrintMethodParams.pmFaxMsg        := OldPrintMethodParams.pmFaxMsg;
    NewPrintMethodParams.pmEmailMAPI     := OldPrintMethodParams.pmEmailMAPI;
    NewPrintMethodParams.pmEmailFrom     := OldPrintMethodParams.pmEmailFrom;
    NewPrintMethodParams.pmEmailFromAd   := OldPrintMethodParams.pmEmailFromAd;
    NewPrintMethodParams.pmEmailTo       := OldPrintMethodParams.pmEmailTo;
    NewPrintMethodParams.pmEmailToAddr   := OldPrintMethodParams.pmEmailToAddr;
    NewPrintMethodParams.pmEmailCc       := OldPrintMethodParams.pmEmailCc;
    NewPrintMethodParams.pmEmailBcc      := OldPrintMethodParams.pmEmailBcc;
    NewPrintMethodParams.pmEmailSubj     := OldPrintMethodParams.pmEmailSubj;
    NewPrintMethodParams.pmEmailMsg      := OldPrintMethodParams.pmEmailMsg;
    NewPrintMethodParams.pmEmailAttach   := OldPrintMethodParams.pmEmailAttach;
    NewPrintMethodParams.pmEmailPriority := OldPrintMethodParams.pmEmailPriority;
    NewPrintMethodParams.pmEmailReader   := OldPrintMethodParams.pmEmailReader;
    NewPrintMethodParams.pmEmailZIP      := OldPrintMethodParams.pmEmailZIP;
    NewPrintMethodParams.pmEmailAtType   := OldPrintMethodParams.pmEmailAtType;
    NewPrintMethodParams.pmFaxPriority   := OldPrintMethodParams.pmFaxPriority;
    NewPrintMethodParams.pmXMLType       := OldPrintMethodParams.pmXMLType;
    NewPrintMethodParams.pmXMLCreateHTML := OldPrintMethodParams.pmXMLCreateHTML;
    NewPrintMethodParams.pmXMLFileDir    := OldPrintMethodParams.pmXMLFileDir;
    NewPrintMethodParams.pmEmailFName    := OldPrintMethodParams.pmEmailFName;
    NewPrintMethodParams.pmMiscOptions   := ArrayToOptionArray(OldPrintMethodParams.pmMiscOptions);
  finally
    NewPrintMethodParams := nil;
  end;
  { Copy the Test Mode parameters }
  OldTestModeParams := ReportConstructInfo.TestModeParams;
  NewTestModeParams := Report.vrTestModeParams;
  try
    NewTestModeParams.tmTestMode     := OldTestModeParams.TestMode;
    NewTestModeParams.tmSampleCount  := OldTestModeParams.SampleCount;
    NewTestModeParams.tmRefreshStart := OldTestModeParams.RefreshStart;
    NewTestModeParams.tmRefreshEnd   := OldTestModeParams.RefreshEnd;
    NewTestModeParams.tmFirstRecPos  := OldTestModeParams.FirstRecPos;
    NewTestModeParams.tmLastRecPos   := OldTestModeParams.LastRecPos;
  finally
    NewTestModeParams := nil;
  end;
  { Read the regions }
  PopulateRegions;
  Report.vrRegions.Sort;
end;

procedure TVRWReportFile_Ver_1.Read;
begin
  LoadReportFile;
  PopulateReport;
end;

procedure TVRWReportFile_Ver_1.ReadField(Control: IVRWFieldControl;
  pControlParameters: PCtrlParams);
{ Used by PopulateControls to fill in the field details that are specific to
  this type of control. pControlParameters holds the control details as read
  from the report file. }
begin
  with Control do
  begin
    vcCaption     := pControlParameters.DBFieldParams.cpCaption;
    vcFont.Name   := pControlParameters.DBFieldParams.cpFont.Name;
    vcFont.Size   := pControlParameters.DBFieldParams.cpFont.Size;
    vcFont.Style  := TFontStyles(pControlParameters.DBFieldParams.cpFont.Style);
    vcFont.Color  := pControlParameters.DBFieldParams.cpFont.Color;
    vcFieldName   := pControlParameters.DBFieldParams.cpDBFieldName;
    vcSortOrder   := pControlParameters.DBFieldParams.cpSortOrder;
    vcSelectCriteria := pControlParameters.DBFieldParams.cpSelectCriteria;
    vcPrintIf     := pControlParameters.DBFieldParams.cpPrintIfCriteria;
    vcPrintField  := pControlParameters.DBFieldParams.cpPrintField;
    vcSubTotal    := pControlParameters.DBFieldParams.cpSubTotal;
    vcPageBreak   := pControlParameters.DBFieldParams.cpPageBreak;
    vcRecalcBreak := pControlParameters.DBFieldParams.cpRecalcBreak;
    vcSelectSummary := pControlParameters.DBFieldParams.cpSelectSummary;
    vcInputLine.rfName := pControlParameters.DBFieldParams.cpInputLine.ssName;
    vcInputLine.rfDescription := pControlParameters.DBFieldParams.cpInputLine.ssDescription;
    vcInputLine.rfType := pControlParameters.DBFieldParams.cpInputLine.siType;
    vcInputLine.rfAlwaysAsk := pControlParameters.DBFieldParams.cpInputLine.bAlwaysAsk;
    vcInputLine.rfFromValue := pControlParameters.DBFieldParams.cpInputLine.ssFromValue;
    vcInputLine.rfToValue   := pControlParameters.DBFieldParams.cpInputLine.ssToValue;
    vcRangeFilter.rfName        := vcInputLine.rfName;
    vcRangeFilter.rfDescription := vcInputLine.rfDescription;
    vcRangeFilter.rfType        := vcInputLine.rfType;
    vcRangeFilter.rfAlwaysAsk   := vcInputLine.rfAlwaysAsk;
    vcRangeFilter.rfFromValue   := vcInputLine.rfFromValue;
    vcRangeFilter.rfToValue     := vcInputLine.rfToValue;
    vcVarNo       := pControlParameters.DBFieldParams.cpVarNo;
    vcVarLen      := pControlParameters.DBFieldParams.cpVarLen;
    vcVarDesc     := pControlParameters.DBFieldParams.cpVarDesc;
    vcVarType     := pControlParameters.DBFieldParams.cpVarType;
    vcVarNoDecs   := pControlParameters.DBFieldParams.cpVarNoDecs;
    vcPeriodField := pControlParameters.DBFieldParams.cpPeriodField;
    vcPeriod      := pControlParameters.DBFieldParams.cpPeriod;
    vcYear        := pControlParameters.DBFieldParams.cpYear;
    vcParsedInputLine := pControlParameters.DBFieldParams.cpParsedInputLine;
    vcCurrency    := pControlParameters.DBFieldParams.cpCurrency;
    vcFieldIdx    := pControlParameters.DBFieldParams.cpFieldIdx;
  end;
end;

procedure TVRWReportFile_Ver_1.ReadFormula(Control: IVRWFormulaControl;
  pControlParameters: PCtrlParams);
{ Used by PopulateControls to fill in the field details that are specific to
  this type of control. pControlParameters holds the control details as read
  from the report file. }
begin
  with Control do
  begin
    vcCaption    := pControlParameters.FormulaParams.cpCaption;
    vcFont.Name  := pControlParameters.FormulaParams.cpFont.Name;
    vcFont.Size  := pControlParameters.FormulaParams.cpFont.Size;
    vcFont.Style := TFontStyles(pControlParameters.FormulaParams.cpFont.Style);
    vcFont.Color := pControlParameters.FormulaParams.cpFont.Color;
    vcComments   := pControlParameters.FormulaParams.cpComments;
    vcFormulaDefinition := pControlParameters.FormulaParams.cpFormulaDefinition;
    vcFormulaDefinition := AdjustFormula(vcFormulaDefinition);
    vcDecimalPlaces := pControlParameters.FormulaParams.cpDecimalPlaces;
    case pControlParameters.FormulaParams.cpTotalType of
      NO_TOTAL:           vcTotalType := ttNone;
      TOTAL_FIELD:        vcTotalType := ttTotal;
      COUNT_FIELD:        vcTotalType := ttCount;
      RANGE_FILTER_FIELD: vcTotalType := ttRangeFilter;
      CALC_FIELD:         vcTotalType := ttCalc;
    else
      vcTotalType := ttUnknown;
    end;
    vcFormulaName := pControlParameters.FormulaParams.cpFormulaName;
    vcSortOrder   := pControlParameters.FormulaParams.cpSortOrder;
    vcPrintIf     := pControlParameters.FormulaParams.cpPrintIfCriteria;
    vcPrintField  := pControlParameters.FormulaParams.cpPrintField;
    vcFieldIdx    := pControlParameters.FormulaParams.cpFieldIdx;
    vcPeriod      := pControlParameters.FormulaParams.cpPeriod;
    vcYear        := pControlParameters.FormulaParams.cpYear;
    vcCurrency    := pControlParameters.FormulaParams.cpCurrency;
  end;
end;

procedure TVRWReportFile_Ver_1.ReadImage(Control: IVRWImageControl;
  pControlParameters: PCtrlParams; RegionIndex: SmallInt);
{ Used by PopulateControls to fill in the field details that are specific to
  this type of control. pControlParameters holds the control details as read
  from the report file. }
begin
  with Control do
  begin
    vcFolio := pControlParameters.ImageParams.BitMapFolio;
  end;
  PopulateImage(RegionIndex, Control);
end;
(*
procedure TVRWReportFile_Ver_1.ReadImageBuffer(Control: IVRWImageControl);
var
  BMPSize: Integer;
begin
  BMPSize := Control.vcImageStream.Size;
  if (BMPSize > 0) then
  begin
    Control.vcBMPStore.iBMPSize := BMPSize;
    GetMem(Control.vcBMPStore.pBMP, BMPSize);
    Control.vcBMPStore.iBMPSize := BMPSize;
    try
      Control.vcImageStream.ReadBuffer(Control.vcBMPStore.pBMP^,
                                       BMPSize);
    except

    end;
  end;
end;
*)
procedure TVRWReportFile_Ver_1.ReadLine(Control: IVRWBoxControl;
  pControlParameters: PCtrlParams);
{ Used by PopulateControls to fill in the field details that are specific to
  this type of control. pControlParameters holds the control details as read
  from the report file.

  In version 2 reports the Line control has been replaced by a Box control with
  only one side visible. }
begin
  with Control do
  begin
    case pControlParameters.LineParams.LineOrientation of
      VERTICAL:
        begin
          vcBoxLines[biTop].vcLineStyle := psClear;
          vcBoxLines[biRight].vcLineStyle := psClear;
          vcBoxLines[biBottom].vcLineStyle := psClear;
          vcBoxLines[biLeft].vcLineStyle :=
            TPenStyle(pControlParameters.LineParams.PenParams.Style);
          vcBoxLines[biLeft].vcLineColor :=
            pControlParameters.LineParams.PenParams.Color;
          vcBoxLines[biLeft].vcLineWidth :=
            pControlParameters.LineParams.PenParams.Width;
        end;
      HORIZONTAL:
        begin
          vcBoxLines[biTop].vcLineStyle :=
            TPenStyle(pControlParameters.LineParams.PenParams.Style);
          vcBoxLines[biTop].vcLineColor :=
            pControlParameters.LineParams.PenParams.Color;
          vcBoxLines[biTop].vcLineWidth :=
            pControlParameters.LineParams.PenParams.Width;
          vcBoxLines[biRight].vcLineStyle := psClear;
          vcBoxLines[biBottom].vcLineStyle := psClear;
          vcBoxLines[biLeft].vcLineStyle := psClear;
        end;
    end;
    vcFilled := False;
  end;
end;

procedure TVRWReportFile_Ver_1.ReadText(Control: IVRWTextControl;
  pControlParameters: PCtrlParams);
{ Used by PopulateControls to fill in the field details that are specific to
  this type of control. pControlParameters holds the control details as read
  from the report file. }
begin
  with Control do
  begin
    vcCaption    := pControlParameters.TextParams.cpCaption;
    vcFont.Name  := pControlParameters.TextParams.cpFont.Name;
    vcFont.Size  := pControlParameters.TextParams.cpFont.Size;
    vcFont.Style := TFontStyles(pControlParameters.TextParams.cpFont.Style);
    vcFont.Color := pControlParameters.TextParams.cpFont.Color;
  end;
end;

procedure TVRWReportFile_Ver_1.Write(WithCompression: Boolean);
var
  ReportFile: IVRWReportFile;
begin
  { Report files are always written out in Version 2 format, so use an instance
    of the Version 2 Report File class to do the actual writing. }
  ReportFile := TVRWReportFile_Ver_2.Create;
  try
    ReportFile.Init(Report, FileName, FilePath);
    ReportFile.Write(WithCompression);
  finally
    { Release the interface reference }
    ReportFile := nil;
  end;
end;

{ TVRWReportFile_Ver_2 }

procedure TVRWReportFile_Ver_2.Read;
var
  XML: TgmXML;
  RootNode, Node: TGmXmlNode;
  iNode: Integer;
  InputStream: TFileStream;
  ResultStream: TMemoryStream;
  Version: array[0..Length(VER_2_FILE_ID) - 1] of Byte;
  Style: TFontStyles;
  PrintMethodParams: IVRWPrintMethodParams;
begin
  Report.Clear;
  Report.vrFilename := FilePath + FileName;
  PrintMethodParams := Report.vrPrintMethodParams;
  Style := Report.vrFont.Style;
  ResultStream := nil;
  InputStream := TFileStream.Create(FilePath + FileName, fmOpenRead, fmShareDenyNone);
  XML := TgmXML.Create(nil);
  try
    { Read the header }
    InputStream.Read(Version, Length(VER_2_FILE_ID));
    ResultStream := TMemoryStream.Create;
    { The first byte of the version array indicates whether the file is
      compressed or not }
    if (Version[0] = 221) then
      { Uncompressed file }
      ResultStream.LoadFromStream(InputStream)
    else
      { Compressed file: Expand into ResultStream }
      ExpandStream(InputStream, ResultStream);
    { Read the uncompressed XML data from ResultStream }
    ResultStream.Position := 0;
    XML.LoadFromStream(ResultStream);
    { Parse the XML file, extracting the report data and creating the report
      structure from it }
    RootNode := XML.Nodes.Root;
    for iNode := 0 to RootNode.Children.Count - 1 do
    begin
      Node := RootNode.Children.Node[iNode];
      if (Node.Name = 'vrRegions') then
        ReadRegions(Node)
      else if (Node.Name = 'vrInputFields') then
        ReadInputFields(Node)
      else if (Node.Name = 'vrVersion') then
        Report.vrVersion := Node.AsDisplayString
      else if (Node.Name = 'vrFilename') then
        Report.vrFilename := Node.AsDisplayString
      else if (Node.Name = 'vrName') then
        Report.vrName := Node.AsDisplayString
      else if (Node.Name = 'vrDescription') then
        Report.vrDescription := Node.AsDisplayString
      else if (Node.Name = 'vrMainFile') then
        Report.vrMainFile := Node.AsDisplayString
      else if (Node.Name = 'vrMainFileNum') then
        Report.vrMainFileNum := Node.AsInteger
      else if (Node.Name = 'vrIndexID') then
        Report.vrIndexID := Node.AsInteger
//      else if (Node.Name = 'vrKeyPath') then
//        Report.vrKeyPath := Node.AsInteger
      else if (Node.Name = 'vrPaperOrientation') then
        Report.vrPaperOrientation := Node.AsInteger
      else if (Node.Name = 'vrIsWizardBased') then
        Report.vrIsWizardBased := Node.AsBoolean
      else if (Node.Name = 'vrFont_Name') then
        Report.vrFont.Name := Node.AsDisplayString
      else if (Node.Name = 'vrFont_Size') then
        Report.vrFont.Size := Node.AsInteger
      else if (Node.Name = 'vrFont_Color') then
        Report.vrFont.Color := Node.AsInteger
      else if (Node.Name = 'vrFont_Bold') then
        ReadFontStyle(RootNode.Children, 'vrFont_Bold',      fsBold,       Style)
      else if (Node.Name = 'vrFont_Italic') then
        ReadFontStyle(RootNode.Children, 'vrFont_Italic',    fsItalic,     Style)
      else if (Node.Name = 'vrFont_Underline') then
        ReadFontStyle(RootNode.Children, 'vrFont_Underline', fsUnderline,  Style)
      else if (Node.Name = 'vrFont_StrikeOut') then
        ReadFontStyle(RootNode.Children, 'vcFont_StrikeOut', fsStrikeOut,  Style)
      else if (Node.Name = 'vrPrintMethodParams_pmPrintMethod') then
        PrintMethodParams.pmPrintMethod := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmBatch') then
        PrintMethodParams.pmBatch := Node.AsBoolean
      else if (Node.Name = 'vrPrintMethodParams_pmTypes') then
        PrintMethodParams.pmTypes := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmCoverSheet') then
        PrintMethodParams.pmCoverSheet := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmFaxMethod') then
        PrintMethodParams.pmFaxMethod := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmFaxPrinter') then
        PrintMethodParams.pmFaxPrinter := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmFaxFrom') then
        PrintMethodParams.pmFaxFrom := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmFaxFromNo') then
        PrintMethodParams.pmFaxFromNo := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmFaxTo') then
        PrintMethodParams.pmFaxTo := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmFaxToNo') then
        PrintMethodParams.pmFaxToNo := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmFaxMsg') then
        PrintMethodParams.pmFaxMsg := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailMAPI') then
        PrintMethodParams.pmEmailMAPI := Node.AsBoolean
      else if (Node.Name = 'vrPrintMethodParams_pmEmailFrom') then
        PrintMethodParams.pmEmailFrom := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailFromAd') then
        PrintMethodParams.pmEmailFromAd := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailTo') then
        PrintMethodParams.pmEmailTo := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailToAddr') then
        PrintMethodParams.pmEmailToAddr := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailCc') then
        PrintMethodParams.pmEmailCc := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailBcc') then
        PrintMethodParams.pmEmailBcc := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailSubj') then
        PrintMethodParams.pmEmailSubj := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailMsg') then
        PrintMethodParams.pmEmailMsg := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailAttach') then
        PrintMethodParams.pmEmailAttach := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailPriority') then
        PrintMethodParams.pmEmailPriority := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmEmailReader') then
        PrintMethodParams.pmEmailReader := Node.AsBoolean
      else if (Node.Name = 'vrPrintMethodParams_pmEmailZIP') then
        PrintMethodParams.pmEmailZIP := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmEmailAtType') then
        PrintMethodParams.pmEmailAtType := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmFaxPriority') then
        PrintMethodParams.pmFaxPriority := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmXMLType') then
        PrintMethodParams.pmXMLType := Node.AsInteger
      else if (Node.Name = 'vrPrintMethodParams_pmXMLCreateHTML') then
        PrintMethodParams.pmXMLCreateHTML := Node.AsBoolean
      else if (Node.Name = 'vrPrintMethodParams_pmXMLFileDir') then
        PrintMethodParams.pmXMLFileDir := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmEmailFName') then
        PrintMethodParams.pmEmailFName := Node.AsString
      else if (Node.Name = 'vrPrintMethodParams_pmMiscOptions') then
        PrintMethodParams.pmMiscOptions := StringToOptionArray(Node.AsString)
      else if (Node.Name = 'vrTestModeParams_tmTestMode') then
        Report.vrTestModeParams.tmTestMode := Node.AsBoolean
      else if (Node.Name = 'vrTestModeParams_tmSampleCount') then
        Report.vrTestModeParams.tmSampleCount := Node.AsInteger
      else if (Node.Name = 'vrTestModeParams_tmRefreshStart') then
        Report.vrTestModeParams.tmRefreshStart := Node.AsBoolean
      else if (Node.Name = 'vrTestModeParams_tmRefreshEnd') then
        Report.vrTestModeParams.tmRefreshEnd := Node.AsBoolean
      else if (Node.Name = 'vrTestModeParams_tmFirstRecPos') then
        Report.vrTestModeParams.tmFirstRecPos := Node.AsInteger
      else if (Node.Name = 'vrTestModeParams_tmLastRecPos') then
        Report.vrTestModeParams.tmLastRecPos := Node.AsInteger
      else if (Node.Name = 'vrRangeFilter_rfName') then
        Report.vrRangeFilter.rfName := Node.AsString
      else if (Node.Name = 'vrRangeFilter_rfDescription') then
        Report.vrRangeFilter.rfDescription := Node.AsString
      else if (Node.Name = 'vrRangeFilter_rfFromValue') then
        Report.vrRangeFilter.rfFromValue := Node.AsString
      else if (Node.Name = 'vrRangeFilter_rfToValue') then
        Report.vrRangeFilter.rfToValue := Node.AsString
      else if (Node.Name = 'vrRangeFilter_rfType') then
        Report.vrRangeFilter.rfType := Node.AsInteger
      else if (Node.Name = 'vrRangeFilter_rfAlwaysAsk') then
        Report.vrRangeFilter.rfAlwaysAsk := Node.AsBoolean
      else if (Node.Name = 'vrPaperCode') then
        Report.vrPaperCode := Node.AsString;
    end;
    Report.vrFont.Style := Style;
  finally
    PrintMethodParams := nil;
    Report.vrRegions.Sort;
    if Assigned(ResultStream) then
      ResultStream.Free;
    InputStream.Free;
    XML.Free;
  end;
end;

procedure TVRWReportFile_Ver_2.ReadControls(Region: IVRWRegion; Node: TgmXMLNode);
{ Populates the supplied region with any controls found as children of the
  specified node in the XML tree. This is used by ReadRegions below. }
var
  iNode: Integer;
  ControlNode: TgmXMLNode;
  ImageNode: TgmXMLNode;
  Nodes: TgmXMLNodeList;
  ControlType: TControlType;
  ControlName: string;
  Control: IVRWControl;
  Converter: THexConverter;
  Style: TFontStyles;
begin
  Converter := THexConverter.Create(nil);
  try
    for iNode := 0 to Node.Children.Count - 1 do
    begin
      ControlNode := Node.Children.Node[iNode];
      if (ControlNode.Name = 'control') then
      begin
        Nodes := ControlNode.Children;
        { Read basic control details }
        ControlType := TControlType(Nodes.NodeByName['vcType'].AsInteger);
        ControlName := Nodes.NodeByName['vcName'].AsDisplayString;
        { Create control }
        Control := Region.rgControls.Add(Report, ControlType, ControlName);
        { Fill in the other control details }
        Control.vcTop         := ReadXML(Nodes, 'vcTop',        Control.vcTop);
        Control.vcLeft        := ReadXML(Nodes, 'vcLeft',       Control.vcLeft);
        Control.vcWidth       := ReadXML(Nodes, 'vcWidth',      Control.vcWidth);
        Control.vcHeight      := ReadXML(Nodes, 'vcHeight',     Control.vcHeight);
        Control.vcZOrder      := ReadXML(Nodes, 'vcZOrder',     Control.vcZOrder);
        Control.vcVisible     := ReadXML(Nodes, 'vcVisible',    Control.vcVisible);
        Control.vcPrintIf     := ReadXML(Nodes, 'vcPrintIf',    Control.vcPrintIf);
        Control.vcCaption     := ReadXML(Nodes, 'vcCaption',    Control.vcCaption);
        Control.vcFont.Name   := ReadXML(Nodes, 'vcFont_Name',  Control.vcFont.Name);
        Control.vcFont.Size   := ReadXML(Nodes, 'vcFont_Size',  Control.vcFont.Size);
        Control.vcFont.Color  := ReadXML(Nodes, 'vcFont_Color', Control.vcFont.Color);
        Control.vcFieldFormat := ReadXML(Nodes, 'vcFieldFormat', Control.vcFieldFormat);
        Style := Control.vcFont.Style;
        ReadFontStyle(Nodes, 'vcFont_Bold',      fsBold,       Style);
        ReadFontStyle(Nodes, 'vcFont_Italic',    fsItalic,     Style);
        ReadFontStyle(Nodes, 'vcFont_Underline', fsUnderline,  Style);
        ReadFontStyle(Nodes, 'vcFont_StrikeOut', fsStrikeOut,  Style);
        Control.vcFont.Style := Style;
        { Fill in the type-specific details }
        case ControlType of
          ctText: ;
          ctImage:
            with Control as IVRWImageControl do
            begin
              ImageNode := Nodes.NodeByName['vcImage'];
              if (ImageNode <> nil) then
              begin
                Converter.DecodeImage(ImageNode.AsString, vcImage);
                Converter.Decode(ImageNode.AsString, vcImageStream);
                vcImageStream.Position := 0;
                ReadImageBuffer;
              end;
            end;
          ctLine:
            with Control as IVRWLineControl do
            begin
              vcLineOrientation := TLineOrientation(ReadXML(Nodes, 'vcLineOrientation', Ord(vcLineOrientation)));
              vcLineLength := ReadXML(Nodes, 'vcLineLength', vcLineLength);
              vcPenColor   := ReadXML(Nodes, 'vcPenColor',   vcPenColor);
              vcPenMode    := ReadXML(Nodes, 'vcPenMode',    vcPenMode);
              vcPenStyle   := ReadXML(Nodes, 'vcPenStyle',   vcPenStyle);
              vcPenWidth   := ReadXML(Nodes, 'vcPenWidth',   vcPenWidth);
            end;
          ctBox:
            with Control as IVRWBoxControl do
            begin
              vcFilled    := ReadXML(Nodes, 'vcFilled', vcFilled);
              vcFillColor := ReadXML(Nodes, 'vcFillColor', vcFillColor);
              with vcBoxLines[biTop] do
              begin
                vcLineStyle := TPenStyle(ReadXML(Nodes, 'vcTop_LineStyle', Ord(vcLineStyle)));
                vcLineColor := ReadXML(Nodes, 'vcTop_LineColor', vcLineColor);
                vcLineWidth := ReadXML(Nodes, 'vcTop_LineWidth', vcLineWidth);
              end;
              with vcBoxLines[biLeft] do
              begin
                vcLineStyle := TPenStyle(ReadXML(Nodes, 'vcLeft_LineStyle', Ord(vcLineStyle)));
                vcLineColor := ReadXML(Nodes, 'vcLeft_LineColor', vcLineColor);
                vcLineWidth := ReadXML(Nodes, 'vcLeft_LineWidth', vcLineWidth);
              end;
              with vcBoxLines[biBottom] do
              begin
                vcLineStyle := TPenStyle(ReadXML(Nodes, 'vcBottom_LineStyle', Ord(vcLineStyle)));
                vcLineColor := ReadXML(Nodes, 'vcBottom_LineColor', vcLineColor);
                vcLineWidth := ReadXML(Nodes, 'vcBottom_LineWidth', vcLineWidth);
              end;
              with vcBoxLines[biRight] do
              begin
                vcLineStyle := TPenStyle(ReadXML(Nodes, 'vcRight_LineStyle', Ord(vcLineStyle)));
                vcLineColor := ReadXML(Nodes, 'vcRight_LineColor', vcLineColor);
                vcLineWidth := ReadXML(Nodes, 'vcRight_LineWidth', vcLineWidth);
              end;
            end;
          ctField:
            with Control as IVRWFieldControl do
            begin
              vcFieldName       := ReadXML(Nodes, 'vcFieldName',       vcFieldName);
              vcSelectCriteria  := ReadXML(Nodes, 'vcSelectCriteria',  vcSelectCriteria);
              vcSubTotal        := ReadXML(Nodes, 'vcSubTotal',        vcSubTotal);
              vcPageBreak       := ReadXML(Nodes, 'vcPageBreak',       vcPageBreak);
              vcRecalcBreak     := ReadXML(Nodes, 'vcRecalcBreak',     vcRecalcBreak);
              vcSelectSummary   := ReadXML(Nodes, 'vcSelectSummary',   vcSelectSummary);
              vcRangeFilter.rfName        := ReadXML(Nodes, 'vcRangeFilter_Name', vcRangeFilter.rfName);
              vcRangeFilter.rfDescription := ReadXML(Nodes, 'vcRangeFilter_Description', vcRangeFilter.rfDescription);
              vcRangeFilter.rfType        := ReadXML(Nodes, 'vcRangeFilter_Type', vcRangeFilter.rfType);
              vcRangeFilter.rfAlwaysAsk   := ReadXML(Nodes, 'vcRangeFilter_AlwaysAsk', vcRangeFilter.rfAlwaysAsk);
              vcRangeFilter.rfFromValue   := ReadXML(Nodes, 'vcRangeFilter_FromValue', vcRangeFilter.rfFromValue);
              vcRangeFilter.rfToValue     := ReadXML(Nodes, 'vcRangeFilter_ToValue', vcRangeFilter.rfToValue);

              vcInputLine.rfName        := ReadXML(Nodes, 'vcInputLine_Name', vcInputLine.rfName);
              vcInputLine.rfDescription := ReadXML(Nodes, 'vcInputLine_Description', vcInputLine.rfDescription);
              vcInputLine.rfType        := ReadXML(Nodes, 'vcInputLine_Type', vcInputLine.rfType);
              vcInputLine.rfAlwaysAsk    := ReadXML(Nodes, 'vcInputLine_AlwaysAsk', vcInputLine.rfAlwaysAsk);
              vcInputLine.rfFromValue   := ReadXML(Nodes, 'vcInputLine_FromValue', vcInputLine.rfFromValue);
              vcInputLine.rfToValue     := ReadXML(Nodes, 'vcInputLine_ToValue', vcInputLine.rfToValue);

              vcVarNo           := ReadXML(Nodes, 'vcVarNo',           vcVarNo);
              vcVarLen          := ReadXML(Nodes, 'vcVarLen',          vcVarLen);
              vcVarDesc         := ReadXML(Nodes, 'vcVarDesc',         vcVarDesc);
              vcVarType         := ReadXML(Nodes, 'vcVarType',         vcVarType);
              vcVarNoDecs       := ReadXML(Nodes, 'vcVarNoDecs',       vcVarNoDecs);
              vcPeriodField     := ReadXML(Nodes, 'vcPeriodField',     vcPeriodField);
              vcParsedInputLine := ReadXML(Nodes, 'vcParsedInputLine', vcParsedInputLine);
              if (Region.rgType = rtSectionHdr) then
                vcSortOrder := ReadXML(Nodes, 'vcSortOrder',       vcSortOrder)
              else
                vcSortOrder := '';
              vcPeriod          := ReadXML(Nodes, 'vcPeriod',          vcPeriod);
              vcYear            := ReadXML(Nodes, 'vcYear',            vcYear);
              vcCurrency        := ReadXML(Nodes, 'vcCurrency',        vcCurrency);
              vcFieldIdx        := ReadXML(Nodes, 'vcFieldIdx',        vcFieldIdx);
              vcPrintField      := ReadXML(Nodes, 'vcPrintField',      vcPrintField);
            end;
          ctFormula:
            with Control as IVRWFormulaControl do
            begin
              vcFormulaName       := ReadXML(Nodes, 'vcFormulaName',       vcFormulaName);
              vcComments          := ReadXML(Nodes, 'vcComments',          vcComments);
              vcFormulaDefinition := ReadXML(Nodes, 'vcFormulaDefinition', vcFormulaDefinition);
              vcDecimalPlaces     := ReadXML(Nodes, 'vcDecimalPlaces',     vcDecimalPlaces);
              vcTotalType         := TTotalType(ReadXML(Nodes, 'vcTotalType', Ord(vcTotalType)));

              // CJS 2011-11-01: ABSEXCH-11577 - included vcPageBreak
              vcPageBreak         := ReadXML(Nodes, 'vcPageBreak',         vcPageBreak);

              vcSortOrder         := ReadXML(Nodes, 'vcSortOrder',         vcSortOrder);
              vcPeriod            := ReadXML(Nodes, 'vcPeriod',            vcPeriod);
              vcYear              := ReadXML(Nodes, 'vcYear',              vcYear);
              vcCurrency          := ReadXML(Nodes, 'vcCurrency',          vcCurrency);
              vcFieldIdx          := ReadXML(Nodes, 'vcFieldIdx',          vcFieldIdx);
              vcPrintField        := ReadXML(Nodes, 'vcPrintField',        vcPrintField);
            end;
        end;
        { Release the interface reference }
        Control := nil;
      end;
    end;
  finally
    Converter.Free;
  end;
end;

procedure TVRWReportFile_Ver_2.ReadFontStyle(Nodes: TgmXMLNodeList; NodeName: string;
  Style: TFontStyle; var Styles: TFontStyles);
begin
  if ReadXML(Nodes, NodeName, (Style in Styles)) then
    Styles := Styles + [Style]
  else
    Styles := Styles - [Style];
end;

procedure TVRWReportFile_Ver_2.ReadInputFields(Node: TgmXMLNode);
{ Reads the Input Fields from the file. }
var
  FieldNode: TgmXMLNode;
  InputField: IVRWInputField;
  iNode: Integer;
begin
  if (Node <> nil) then
  begin
    for iNode := 0 to Node.Children.Count - 1 do
    begin
      FieldNode := Node.Children.Node[iNode];
      { Create field }
      InputField := (Report as IVRWReport3).vrInputFields.Add;
      InputField.rfId          := ReadXML(FieldNode.Children, 'rfID', InputField.rfId);
      InputField.rfName        := ReadXML(FieldNode.Children, 'rfName', InputField.rfName);
      InputField.rfDescription := ReadXML(FieldNode.Children, 'rfDescription', InputField.rfDescription);
      InputField.rfType        := ReadXML(FieldNode.Children, 'rfType', InputField.rfType);
      InputField.rfAlwaysAsk   := ReadXML(FieldNode.Children, 'rfAlwaysAsk', InputField.rfAlwaysAsk);
      InputField.rfFromValue   := ReadXML(FieldNode.Children, 'rfFromValue', InputField.rfFromValue);
      InputField.rfToValue     := ReadXML(FieldNode.Children, 'rfToValue', InputField.rfToValue);
      { Release the interface reference }
      InputField := nil;
    end;
  end;
end;

function TVRWReportFile_Ver_2.ReadXML(Nodes: TgmXMLNodeList;
  PropertyName: ShortString; Default: ShortString): ShortString;
{ Finds the node which matches the specified property name, and returns the
  value. Returns Default if the node cannot be found. Used by ReadControls. }
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsDisplayString;
  end;
end;

function TVRWReportFile_Ver_2.ReadXML(Nodes: TgmXMLNodeList;
  PropertyName: ShortString; Default: LongInt): LongInt;
{ Finds the node which matches the specified property name, and returns the
  value. Returns Default if the node cannot be found. Used by ReadControls. }
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsInteger;
  end;
end;

function TVRWReportFile_Ver_2.ReadXML(Nodes: TgmXMLNodeList;
  PropertyName: ShortString; Default: Boolean): Boolean;
{ Finds the node which matches the specified property name, and returns the
  value. Returns Default if the node cannot be found. Used by ReadControls. }
var
  Node: TgmXMLNode;
begin
  Result := Default;
  if (Nodes <> nil) then
  begin
    Node := Nodes.NodeByName[PropertyName];
    if (Node <> nil) then
      Result := Node.AsBoolean;
  end;
end;

procedure TVRWReportFile_Ver_2.ReadRegions(Node: TgmXMLNode);
var
  RegionType: TRegionType;
  SectionNumber: SmallInt;
  RegionName: ShortString;
  RegionNode: TgmXMLNode;
  Region: IVRWRegion;
  iNode: Integer;
begin
  if (Node <> nil) then
  begin
    for iNode := 0 to Node.Children.Count - 1 do
    begin
      RegionNode := Node.Children.Node[iNode];
      { Collect region details }
      RegionType := TRegionType(RegionNode.Children.NodeByName['rgType'].AsInteger);
      SectionNumber := RegionNode.Children.NodeByName['rgSectionNumber'].AsInteger;
      RegionName := RegionNode.Children.NodeByName['rgName'].AsDisplayString;
      { Create region }
      Region := Report.vrRegions.Add(Report, RegionType, SectionNumber, RegionName);
      Region.rgTop         := ReadXML(RegionNode.Children, 'rgTop', Region.rgTop);
      Region.rgHeight      := ReadXML(RegionNode.Children, 'rgHeight', Region.rgHeight);
      Region.rgDescription := ReadXML(RegionNode.Children, 'rgDescription', Region.rgDescription);
      Region.rgVisible     := ReadXML(RegionNode.Children, 'rgVisible', Region.rgVisible);
      { Read controls }
      ReadControls(Region, RegionNode);
      { Release the interface reference }
      Region := nil;
    end;
  end;
end;

procedure TVRWReportFile_Ver_2.Write(WithCompression: Boolean);
{ Writes the report to file. If WithCompression is false, the XML file is
  written to disk without compression, so that it can be read by any text
  viewing program.

  Note that the uncompressed version still includes the opening file signature,
  which is not valid XML and so XML viewing programs will probably fail to
  open the file. }
type
  PFontStyles = ^TFontStyles;
var
  XML: TgmXML;
  Node: TgmXMLNode;
  Stream: TFileStream;
  RegionNo, FieldNo, ControlNo: SmallInt;
  InputField: IVRWInputField;
  Region: IVRWRegion;
  Control: IVRWControl;
  Converter: THexConverter;
  CompressionStream: TCompressionStream;
  PrintMethodParams: IVRWPrintMethodParams;
begin
  XML := TgmXML.Create(nil);
  XML.Encoding := 'ISO-8859-1';
  CompressionStream := nil;
  Converter := THexConverter.Create(nil);
  try
    { Write report header }
    XML.Nodes.AddOpenTag('report');
    XML.Nodes.AddLeaf('vrVersion').AsString := Report.vrVersion;
    XML.Nodes.AddLeaf('vrFileName').AsString := Report.vrFilename;
    XML.Nodes.AddLeaf('vrName').AsString := Report.vrName;
    XML.Nodes.AddLeaf('vrDescription').AsString := Report.vrDescription;
    XML.Nodes.AddLeaf('vrMainFile').AsString := Report.vrMainFile;
    XML.Nodes.AddLeaf('vrMainFileNum').AsInteger := Report.vrMainFileNum;
    XML.Nodes.AddLeaf('vrIndexID').AsInteger := Report.vrIndexID;
//    XML.Nodes.AddLeaf('vrKeyPath').AsInteger := Report.vrKeyPath;
    XML.Nodes.AddLeaf('vrPaperOrientation').AsInteger := Report.vrPaperOrientation;
    XML.Nodes.AddLeaf('vrIsWizardBased').AsBoolean := Report.vrIsWizardBased;
    XML.Nodes.AddLeaf('vrFont_Name').AsString := Report.vrFont.Name;
    XML.Nodes.AddLeaf('vrFont_Size').AsInteger := Report.vrFont.Size;
    XML.Nodes.AddLeaf('vrFont_Color').AsInteger := Report.vrFont.Color;
    XML.Nodes.AddLeaf('vrFont_Bold').AsBoolean := (fsBold in Report.vrFont.Style);
    XML.Nodes.AddLeaf('vrFont_Italic').AsBoolean := (fsItalic in Report.vrFont.Style);
    XML.Nodes.AddLeaf('vrFont_Underline').AsBoolean := (fsUnderline in Report.vrFont.Style);
    XML.Nodes.AddLeaf('vrFont_StrikeOut').AsBoolean := (fsStrikeOut	in Report.vrFont.Style);
    { Write Print Method parameters }
    PrintMethodParams := Report.vrPrintMethodParams;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmPrintMethod').AsInteger := PrintMethodParams.pmPrintMethod;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmBatch').AsBoolean := PrintMethodParams.pmBatch;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmTypes').AsInteger := PrintMethodParams.pmTypes;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmCoverSheet').AsString := PrintMethodParams.pmCoverSheet;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxMethod').AsInteger := PrintMethodParams.pmFaxMethod;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxPrinter').AsInteger := PrintMethodParams.pmFaxPrinter;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxFrom').AsString := PrintMethodParams.pmFaxFrom;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxFromNo').AsString := PrintMethodParams.pmFaxFromNo;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxTo').AsString := PrintMethodParams.pmFaxTo;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxToNo').AsString := PrintMethodParams.pmFaxToNo;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxMsg').AsString := PrintMethodParams.pmFaxMsg;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailMAPI').AsBoolean := PrintMethodParams.pmEmailMAPI;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailFrom').AsString := PrintMethodParams.pmEmailFrom;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailFromAd').AsString := PrintMethodParams.pmEmailFromAd;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailTo').AsString := PrintMethodParams.pmEmailTo;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailToAddr').AsString := PrintMethodParams.pmEmailToAddr;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailCc').AsString := PrintMethodParams.pmEmailCc;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailBcc').AsString := PrintMethodParams.pmEmailBcc;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailSubj').AsString := PrintMethodParams.pmEmailSubj;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailMsg').AsString := PrintMethodParams.pmEmailMsg;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailAttach').AsString := PrintMethodParams.pmEmailAttach;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailPriority').AsInteger := PrintMethodParams.pmEmailPriority;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailReader').AsBoolean := PrintMethodParams.pmEmailReader;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailZIP').AsInteger := PrintMethodParams.pmEmailZIP;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailAtType').AsInteger := PrintMethodParams.pmEmailAtType;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmFaxPriority').AsInteger := PrintMethodParams.pmFaxPriority;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmXMLType').AsInteger := PrintMethodParams.pmXMLType;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmXMLCreateHTML').AsBoolean := PrintMethodParams.pmXMLCreateHTML;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmXMLFileDir').AsString := PrintMethodParams.pmXMLFileDir;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmEmailFName').AsString := PrintMethodParams.pmEmailFName;
    XML.Nodes.AddLeaf('vrPrintMethodParams_pmMiscOptions').AsString := OptionArrayToString(PrintMethodParams.pmMiscOptions);
    XML.Nodes.AddLeaf('vrTestModeParams_tmTestMode').AsBoolean := Report.vrTestModeParams.tmTestMode;
    XML.Nodes.AddLeaf('vrTestModeParams_tmSampleCount').AsInteger := Report.vrTestModeParams.tmSampleCount;
    XML.Nodes.AddLeaf('vrTestModeParams_tmRefreshStart').AsBoolean := Report.vrTestModeParams.tmRefreshStart;
    XML.Nodes.AddLeaf('vrTestModeParams_tmRefreshEnd').AsBoolean := Report.vrTestModeParams.tmRefreshEnd;
    XML.Nodes.AddLeaf('vrTestModeParams_tmFirstRecPos').AsInteger := Report.vrTestModeParams.tmFirstRecPos;
    XML.Nodes.AddLeaf('vrTestModeParams_tmLastRecPos').AsInteger := Report.vrTestModeParams.tmLastRecPos;
    XML.Nodes.AddLeaf('vrRangeFilter_rfName').AsString := Report.vrRangeFilter.rfName;
    XML.Nodes.AddLeaf('vrRangeFilter_rfDescription').AsString := Report.vrRangeFilter.rfDescription;
    XML.Nodes.AddLeaf('vrRangeFilter_rfFromValue').AsString := Report.vrRangeFilter.rfFromValue;
    XML.Nodes.AddLeaf('vrRangeFilter_rfToValue').AsString := Report.vrRangeFilter.rfToValue;
    XML.Nodes.AddLeaf('vrRangeFilter_rfType').AsInteger := Report.vrRangeFilter.rfType;
    XML.Nodes.AddLeaf('vrRangeFilter_rfAlwaysAsk').AsBoolean := Report.vrRangeFilter.rfAlwaysAsk;
    XML.Nodes.AddLeaf('vrPaperCode').AsString := Report.vrPaperCode;
    { Write input fields }
    XML.Nodes.AddOpenTag('vrInputFields');
    for FieldNo := 0 to (Report as IVRWReport3).vrInputFields.rfCount - 1 do
    begin
      InputField := (Report as IVRWReport3).vrInputFields.rfItems[FieldNo];
      XML.Nodes.AddOpenTag('inputfield');
      XML.Nodes.AddLeaf('rfID').AsInteger := InputField.rfId;
      XML.Nodes.AddLeaf('rfName').AsString := InputField.rfName;
      XML.Nodes.AddLeaf('rfDescription').AsString := InputField.rfDescription;
      XML.Nodes.AddLeaf('rfType').AsInteger := InputField.rfType;
      XML.Nodes.AddLeaf('rfAlwaysAsk').AsBoolean := InputField.rfAlwaysAsk;
      XML.Nodes.AddLeaf('rfFromValue').AsString := InputField.rfFromValue;
      XML.Nodes.AddLeaf('rfToValue').AsString := InputField.rfToValue;
      XML.Nodes.AddCloseTag;
      InputField := nil;
    end;
    XML.Nodes.AddCloseTag;
    { Write regions }
    XML.Nodes.AddOpenTag('vrRegions');
    for RegionNo := 0 to Report.vrRegions.rlCount - 1 do
    begin
      { Write region header }
      Region := Report.vrRegions.rlItems[RegionNo];
      XML.Nodes.AddOpenTag('region');
      XML.Nodes.AddLeaf('rgName').AsString := Region.rgName;
      XML.Nodes.AddLeaf('rgDescription').AsString := Region.rgDescription;
      XML.Nodes.AddLeaf('rgType').AsInteger := Ord(Region.rgType);
      XML.Nodes.AddLeaf('rgSectionNumber').AsInteger := Region.rgSectionNumber;
      XML.Nodes.AddLeaf('rgTop').AsInteger := Region.rgTop;
      XML.Nodes.AddLeaf('rgHeight').AsInteger := Region.rgHeight;
      XML.Nodes.AddLeaf('rgVisible').AsBoolean := Region.rgVisible;
      { Write controls }
      for ControlNo := 0 to Region.rgControlCount - 1 do
      begin
        Control := Region.rgControls.clItems[ControlNo];
        if not Control.vcDeleted then
        begin
          { Write general control details }
          XML.Nodes.AddOpenTag('control');
          XML.Nodes.AddLeaf('vcName').AsString := Control.vcName;
          XML.Nodes.AddLeaf('vcCaption').AsString := Control.vcCaption;
          XML.Nodes.AddLeaf('vcType').AsInteger := Ord(Control.vcType);
          XML.Nodes.AddLeaf('vcTop').AsInteger := Control.vcTop;
          XML.Nodes.AddLeaf('vcLeft').AsInteger := Control.vcLeft;
          XML.Nodes.AddLeaf('vcWidth').AsInteger := Control.vcWidth;
          XML.Nodes.AddLeaf('vcHeight').AsInteger := Control.vcHeight;
          XML.Nodes.AddLeaf('vcZOrder').AsInteger := Control.vcZOrder;
          XML.Nodes.AddLeaf('vcVisible').AsBoolean := Control.vcVisible;
          XML.Nodes.AddLeaf('vcPrintIf').AsString := Control.vcPrintIf;
          XML.Nodes.AddLeaf('vcFont_Name').AsString := Control.vcFont.Name;
          XML.Nodes.AddLeaf('vcFont_Size').AsInteger := Control.vcFont.Size;
          XML.Nodes.AddLeaf('vcFont_Color').AsInteger := Control.vcFont.Color;
          XML.Nodes.AddLeaf('vcFont_Bold').AsBoolean := (fsBold in Control.vcFont.Style);
          XML.Nodes.AddLeaf('vcFont_Italic').AsBoolean := (fsItalic in Control.vcFont.Style);
          XML.Nodes.AddLeaf('vcFont_Underline').AsBoolean := (fsUnderline in Control.vcFont.Style);
          XML.Nodes.AddLeaf('vcFont_StrikeOut').AsBoolean := (fsStrikeOut	in Control.vcFont.Style);
          XML.Nodes.AddLeaf('vcFieldFormat').AsString := Control.vcFieldFormat;

          { Write control type-specific details }
          { Line }
          if Supports(Control, IVRWLineControl) then
          with Control as IVRWLineControl do
          begin
            XML.Nodes.AddLeaf('vcLineOrientation').AsInteger := Ord(vcLineOrientation);
            XML.Nodes.AddLeaf('vcLineLength').AsInteger := vcLineLength;
            XML.Nodes.AddLeaf('vcPenColor').AsInteger := vcPenColor;
            XML.Nodes.AddLeaf('vcPenMode').AsInteger := vcPenMode;
            XML.Nodes.AddLeaf('vcPenStyle').AsInteger := vcPenStyle;
            XML.Nodes.AddLeaf('vcPenWidth').AsInteger := vcPenWidth;
          end;
          { Box }
          if Supports(Control, IVRWBoxControl) then
          with Control as IVRWBoxControl do
          begin
            XML.Nodes.AddLeaf('vcFilled').AsBoolean := vcFilled;
            XML.Nodes.AddLeaf('vcFillColor').AsInteger := vcFillColor;
            with vcBoxLines[biTop] do
            begin
              XML.Nodes.AddLeaf('vcTop_LineStyle').AsInteger := Ord(vcLineStyle);
              XML.Nodes.AddLeaf('vcTop_LineColor').AsInteger := vcLineColor;
              XML.Nodes.AddLeaf('vcTop_LineWidth').AsInteger := vcLineWidth;
            end;
            with vcBoxLines[biLeft] do
            begin
              XML.Nodes.AddLeaf('vcLeft_LineStyle').AsInteger := Ord(vcLineStyle);
              XML.Nodes.AddLeaf('vcLeft_LineColor').AsInteger := vcLineColor;
              XML.Nodes.AddLeaf('vcLeft_LineWidth').AsInteger := vcLineWidth;
            end;
            with vcBoxLines[biBottom] do
            begin
              XML.Nodes.AddLeaf('vcBottom_LineStyle').AsInteger := Ord(vcLineStyle);
              XML.Nodes.AddLeaf('vcBottom_LineColor').AsInteger := vcLineColor;
              XML.Nodes.AddLeaf('vcBottom_LineWidth').AsInteger := vcLineWidth;
            end;
            with vcBoxLines[biRight] do
            begin
              XML.Nodes.AddLeaf('vcRight_LineStyle').AsInteger := Ord(vcLineStyle);
              XML.Nodes.AddLeaf('vcRight_LineColor').AsInteger := vcLineColor;
              XML.Nodes.AddLeaf('vcRight_LineWidth').AsInteger := vcLineWidth;
            end;
          end;
          { Field }
          if Supports(Control, IVRWFieldControl) then
          with Control as IVRWFieldControl do
          begin
            XML.Nodes.AddLeaf('vcFieldName').AsString := vcFieldName;
            XML.Nodes.AddLeaf('vcSelectCriteria').AsString := vcSelectCriteria;
            XML.Nodes.AddLeaf('vcSubTotal').AsBoolean := vcSubTotal;
            XML.Nodes.AddLeaf('vcPageBreak').AsBoolean := vcPageBreak;
            XML.Nodes.AddLeaf('vcRecalcBreak').AsBoolean := vcRecalcBreak;
            XML.Nodes.AddLeaf('vcSelectSummary').AsBoolean := vcSelectSummary;

            XML.Nodes.AddLeaf('vcInputLine_Name').AsString := vcInputLine.rfName;
            XML.Nodes.AddLeaf('vcInputLine_Description').AsString := vcInputLine.rfDescription;
            XML.Nodes.AddLeaf('vcInputLine_Type').AsInteger := vcInputLine.rfType;
            XML.Nodes.AddLeaf('vcInputLine_AlwaysAsk').AsBoolean := vcInputLine.rfAlwaysAsk;
            XML.Nodes.AddLeaf('vcInputLine_FromValue').AsString := vcInputLine.rfFromValue;
            XML.Nodes.AddLeaf('vcInputLine_ToValue').AsString := vcInputLine.rfToValue;

            XML.Nodes.AddLeaf('vcRangeFilter_Name').AsString := vcRangeFilter.rfName;
            XML.Nodes.AddLeaf('vcRangeFilter_Description').AsString := vcRangeFilter.rfDescription;
            XML.Nodes.AddLeaf('vcRangeFilter_Type').AsInteger := vcRangeFilter.rfType;
            XML.Nodes.AddLeaf('vcRangeFilter_AlwaysAsk').AsBoolean := vcRangeFilter.rfAlwaysAsk;
            XML.Nodes.AddLeaf('vcRangeFilter_FromValue').AsString := vcRangeFilter.rfFromValue;
            XML.Nodes.AddLeaf('vcRangeFilter_ToValue').AsString := vcRangeFilter.rfToValue;

            XML.Nodes.AddLeaf('vcInputLine_Name').AsString := vcInputLine.rfName;
            XML.Nodes.AddLeaf('vcInputLine_Description').AsString := vcInputLine.rfDescription;
            XML.Nodes.AddLeaf('vcInputLine_Type').AsInteger := vcInputLine.rfType;
            XML.Nodes.AddLeaf('vcInputLine_AlwaysAsk').AsBoolean := vcInputLine.rfAlwaysAsk;
            XML.Nodes.AddLeaf('vcInputLine_FromValue').AsString := vcInputLine.rfFromValue;
            XML.Nodes.AddLeaf('vcInputLine_ToValue').AsString := vcInputLine.rfToValue;

            XML.Nodes.AddLeaf('vcVarNo').AsInteger := vcVarNo;
            XML.Nodes.AddLeaf('vcVarLen').AsInteger := vcVarLen;
            XML.Nodes.AddLeaf('vcVarDesc').AsString := vcVarDesc;
            XML.Nodes.AddLeaf('vcVarType').AsInteger := vcVarType;
            XML.Nodes.AddLeaf('vcVarNoDecs').AsInteger := vcVarNoDecs;
            XML.Nodes.AddLeaf('vcPeriodField').AsBoolean := vcPeriodField;
            XML.Nodes.AddLeaf('vcParsedInputLine').AsString := vcParsedInputLine;

            XML.Nodes.AddLeaf('vcSortOrder').AsString := vcSortOrder;
            XML.Nodes.AddLeaf('vcPeriod').AsString := vcPeriod;
            XML.Nodes.AddLeaf('vcYear').AsString := vcYear;
            XML.Nodes.AddLeaf('vcCurrency').AsInteger := vcCurrency;
            XML.Nodes.AddLeaf('vcFieldIdx').AsInteger := vcFieldIdx;
            XML.Nodes.AddLeaf('vcPrintField').AsBoolean := vcPrintField;
          end;
          { Formula }
          if Supports(Control, IVRWFormulaControl) then
          with Control as IVRWFormulaControl do
          begin
            XML.Nodes.AddLeaf('vcFormulaName').AsString := vcFormulaName;
            XML.Nodes.AddLeaf('vcComments').AsString := vcComments;
            XML.Nodes.AddLeaf('vcFormulaDefinition').AsString := vcFormulaDefinition;
            XML.Nodes.AddLeaf('vcDecimalPlaces').AsInteger := vcDecimalPlaces;
            XML.Nodes.AddLeaf('vcTotalType').AsInteger := Ord(vcTotalType);

            // CJS 2011-11-01: ABSEXCH-11577
            XML.Nodes.AddLeaf('vcPageBreak').AsBoolean := vcPageBreak;

            XML.Nodes.AddLeaf('vcSortOrder').AsString := vcSortOrder;
            XML.Nodes.AddLeaf('vcPeriod').AsString := vcPeriod;
            XML.Nodes.AddLeaf('vcYear').AsString := vcYear;
            XML.Nodes.AddLeaf('vcCurrency').AsInteger := vcCurrency;
            XML.Nodes.AddLeaf('vcFieldIdx').AsInteger := vcFieldIdx;
            XML.Nodes.AddLeaf('vcPrintField').AsBoolean := vcPrintField;
          end;
          { Image }
          if Supports(Control, IVRWImageControl) then
          with Control as IVRWImageControl do
          begin
            Node := XML.Nodes.AddLeaf('vcImage');
            Node.AsString := Converter.EncodeImage(vcImage);
          end;
          XML.Nodes.AddCloseTag;  // control
        end; // if not Control.vcDeleted...
        Control := nil;
      end;
      XML.Nodes.AddCloseTag;  // region
      Region := nil;
    end;  // for RegionNo...
    XML.Nodes.AddCloseTag;  // vrRegions
    XML.Nodes.AddCloseTag;  // Report
    try
      Stream := TFileStream.Create(FilePath + FileName, fmCreate);
      try
        if (WithCompression) then
        begin
          Stream.Write(VER_2_COMPRESSED_FILE_ID, Length(VER_2_FILE_ID));
          CompressionStream := TCompressionStream.Create(clDefault, Stream);
          XML.SaveToStream(CompressionStream);
        end
        else
        begin
          Stream.Write(VER_2_FILE_ID, Length(VER_2_FILE_ID));
          XML.SaveToStream(Stream);
        end;
      finally
        if Assigned(CompressionStream) then
          CompressionStream.Free;
        Stream.Free;
      end;
    except
      on E:Exception do
      begin
        ShowMessage('Could not create report file ' +
                    FilePath + FileName + ' : ' +
                    #13#10#13#10 +
                    E.Message);
      end;
    end;
  finally
    XML.Free;
  end;
end;
(*
procedure TVRWReportFile_Ver_2.ReadImageBuffer(Control: IVRWImageControl);
var
  BMPSize: Integer;
begin
  BMPSize := Control.vcImageStream.Size;
  if (BMPSize > 0) then
  begin
    Control.vcBMPStore.iBMPSize := BMPSize;
    GetMem(Control.vcBMPStore.pBMP, BMPSize);
    Control.vcBMPStore.iBMPSize := BMPSize;
    try
      Control.vcImageStream.ReadBuffer(Control.vcBMPStore.pBMP^,
                                       BMPSize);
    except

    end;
  end;
end;
*)
function TVRWReportFile_Ver_2.OptionArrayToString(
  OptionArray: TOptionArray): string;
var
  OptionPos: Integer;
begin
  Result := '';
  for OptionPos := Low(OptionArray) to High(OptionArray) do
  begin
    if OptionArray[OptionPos] then
      Result := Result + 'T'
    else
      Result := Result + 'F';
  end;
end;

function TVRWReportFile_Ver_2.StringToOptionArray(
  OptionStr: string): TOptionArray;
var
  OptionPos, CharPos: Integer;
begin
  CharPos := 1;
  for OptionPos := Low(Result) to High(Result) do
  begin
    if (CharPos < Length(OptionStr)) then
      Result[OptionPos] := (OptionStr[CharPos] = 'T')
    else
      Result[OptionPos] := False;
    CharPos := CharPos + 1;
  end;
end;

end.
