unit RptPersist;

interface

uses
  Classes, // delphi
  CtrlPrms; // my own

type
  TCaller = (SAVE_CALLER, PRINT_CALLER);

  TReportPersistor = class(TPersistent)
  private
    { Private declarations }
    // Used by GetCtrlParams()
    FCtrlIdx : SmallInt;
    FRegionIdx : SmallInt;

    // Actual file name and path on the disk.
    ssRWVersion : ShortString;

    FFileName : ShortString;
    FFilePath : ShortString; // the complete path including file name

    // User description fields
    FReportName,
    FReportDescription : AnsiString;
    FPaperOrientation : Byte;

    FRptMainFile : ShortString;
    FRptMainFileNum : Byte;
    FRptIndexID : Byte;
    FRptKeyPath : Integer;

    FReportFileRead : Boolean;
    FWizardBasedReport : Boolean;

    FObjectFileName : ShortString;

    RegionParamList,
    CtrlBlockList : TList;
    BitMapList : TStringList;

    HndReportFile : File;

    procedure WriteHeader;
    procedure WriteRegionId(const siRegionId : SmallInt);
    procedure WriteRegionParams(const pRegionParams : Pointer);
    procedure WriteCtrlBlocks(const pReportBlock : Pointer);
    procedure WriteBMPBlocks(const pReportBMPs : TStringList);

    procedure ReadHeader;
    function ReadRegionId : SmallInt;
    function GetNextBlockSize : Integer;
    procedure ReadRegionParams(const pRegionParams : Pointer; const siBlockSize : SmallInt);
    function ReadCtrlBlocks(const CtrlBlocks : TList; const siBlockSize : Integer) : Boolean;
    procedure ReadBitMaps(const BitMapImgs : TStringList; const CtrlBlocks : TList);
    procedure ParseReportHeader(const siHeaderSize : SmallInt; const szHeader : PChar);
    procedure VersionOneParser(var sHdr : AnsiString; const siVerMinor : SmallInt);

    procedure SetReportFileName(const ssReportFilename : ShortString);

//    procedure AddToReportTree;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(ssFileName : ShortString; ssFilePath : ShortString; const bWizardBasedReport : Boolean = FALSE);
    destructor Destroy; override;

    procedure WriteReportFile;
    procedure ReadReportFile;

    procedure SaveObject(const ReportHandle : TMemoryStream; const bDispose : Boolean = FALSE);
    procedure LoadObject(const ReportHandle : TMemoryStream);

    procedure ClearRegionBlocks;
    procedure AddRegionBlock(const pBlock : Pointer; const RegionId : Byte);
    procedure ClearReportBlocks;
    procedure AddReportBlock(const pBlock, pBitMaps : Pointer; const RegionId : Byte);

    function GetRegionCount : SmallInt;
    function GetRegionParamsByName(const RegionName : ShortString;
                                   var RegionIdx : SmallInt;
                                   const Caller : TCaller = PRINT_CALLER) : PRegionParams;
    function GetRegionParamsByIdx(const RegionIdx : SmallInt;
                                  const Caller : TCaller = PRINT_CALLER ) : PRegionParams;
    procedure GetReportBlock(const RegionId : SmallInt; const lstReportBlocks : TList);
    function GetCtrlParams(const RegionId : SmallInt) : PCtrlParams;
    procedure GetImageData(const RegionId : SmallInt; const slBMPs : TStringList);
  published
    { Published declarations }
    property ReportName : AnsiString read FReportName write FReportName;
    property ReportDescription : AnsiString read FReportDescription write FReportDescription;
    property ReportPaperOrientation : Byte read FPaperOrientation write FPaperOrientation;
    property ReportFileRead : Boolean read FReportFileRead;
    property ReportFileName : ShortString read FFileName write SetReportFileName; // FFileName;
    property ReportFilePath : ShortString read FFilePath;

    property WizardBasedReport : Boolean read FWizardBasedReport write FWizardBasedReport;

    property ReportMainFile : ShortString read FRptMainFile write FRptMainFile;
    property ReportMainFileNum : Byte read FRptMainFileNum write FRptMainFileNum;
    property ReportIndexID : Byte read FRptIndexID write FRptIndexID;
    property ReportBTrvKeyPath : Integer read FRptKeyPath write FRptKeyPath;
  end;

implementation

uses
  Windows, Forms, Graphics, Dialogs, SysUtils, // delphi
  BtrvU2, // exchequer
  RPDefine, // RAVE
  GlobalTypes, VarConst; // my own

const
  MAX_HDR_SIZE = 4096;
  BLOCK_DELIMITER = '##';
  MAX_SMALLINT_LGTH = 8; // was 5 but this was truncating some values so it was 'extended'

constructor TReportPersistor.Create(ssFileName : ShortString; ssFilePath : ShortString; const bWizardBasedReport : Boolean = FALSE);
begin
  inherited Create;

  FCtrlIdx := 0;
  FRegionIdx := 1;

  // ALWAYS 5 characters long.
  // 1.00 upto Preview 2.07
  // 1.01 from Preview 2.08 (inclusive)
  // 1.02 from 2.28 - MH 10/03/05 - Added Input Field on Report Header for indexing
  ssRWVersion := ' 1.02';

  FFileName := ssFileName;
  FFilePath := ssFilePath;

  if (FFilePath[length(FFilePath)] <> '\') then
    FFilePath := FFilePath + '\';

  FReportFileRead := FALSE;
  FWizardBasedReport := bWizardBasedReport;

  RegionParamList := TList.Create;
  CtrlBlockList := TList.Create;
  BitMapList := TStringList.Create; 
end;

destructor TReportPersistor.Destroy;
var
  siObjCount, siObjIdx : Smallint;
begin
  if (assigned(RegionParamList)) then
  begin
    if (RegionParamList.Count > 0) then
      RegionParamList.Clear; 
    RegionParamList.Free;
  end;
  
  if (assigned(CtrlBlockList)) then
  begin
    siObjCount := (CtrlBlockList.Count - 1);

    for siObjIdx := 0 to siObjCount do
      if assigned(TList(CtrlBlockList.Items[siObjIdx])) then
        TList(CtrlBlockList.Items[siObjIdx]).Free;

{ TODO : Potential Memory Leak - CtrlBlockList is a TList containing TLists of ^TCtrlParams }

    CtrlBlockList.Free;
  end;

  if (assigned(BitMapList)) then
  begin
    siObjCount := (BitMapList.Count - 1);
    for siObjIdx := 0 to siObjCount do
      if assigned(TStringList(BitMapList.Objects[siObjIdx])) then
        TStringList(BitMapList.Objects[siObjIdx]).Free;
    BitMapList.Free;
  end;

  inherited Destroy;
end;

procedure TReportPersistor.WriteReportFile;
var
  siRegionIdx : SmallInt;
begin
  // try this here. Might stop the EInOutError exception (error code 123)
  while (Length(FFilePath) > 0) and (FFilePath[Length(FFilePath)] <> '\') do
    Delete(FFilePath,Length(FFilePath),1);

  AssignFile(HndReportFile, FFilePath + FFileName);
  try
    // This make each file block 1 byte long. This gives us the oppotunity to write 'variable' sized blocks to the file.
    try
      Rewrite(HndReportFile,1);
    except on E:EInOutError do
      ShowMessage('Rewrite() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
    end;

    try
      WriteHeader;
    except on E:EInOutError do
      ShowMessage('WriteHeader() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
    end;

    for siRegionIdx := 0 to (RegionParamList.Count - 1) do
    begin
      // region id + block_delimiter
      try
        WriteRegionId(siRegionIdx);
      except on E:EInOutError do
        ShowMessage('WriteRegionId() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
      end;

      try
        WriteRegionParams(RegionParamList.Items[siRegionIdx]);
      except on E:EInOutError do
        ShowMessage('WriteRegionParams() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
      end;

      try
        WriteCtrlBlocks(CtrlBlockList.Items[siRegionIdx]);
      except on E:EInOutError do
        ShowMessage('WriteCtrlBlocks() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
      end;

      try
        WriteBMPBlocks(TStringList(BitMapList.Objects[siRegionIdx]));
      except on E:EInOutError do
        ShowMessage('WriteBMPBlocks() - EInOutError ('+E.Message+') - FFilePath ('+FFilePath+') FFileName ('+FFileName+')');
      end;
    end; // for siRegionIdx := 1 to RegionParamList.Count do...

  finally
    CloseFile(HndReportFile);
  end;

//  AddToReportTree;

end;

procedure TReportPersistor.ReadReportFile;
var
  RegionParams : PRegionParams;
  ControlBlocks : TList;
  BitMapImages : TStringList;
  siRegionId : SmallInt;
  siBlockSize : Integer;
  BitMapsPresent : Boolean;
begin
  // moved to here from TReportPersistor.WriteReportFile()

  RegionParamList.Clear;
  CtrlBlockList.Clear;
  BitMapList.Clear;

  AssignFile(HndReportFile, FFilePath + FFileName);
  try
    FileMode := fmOpenRead; // added. Attempts to open 'read-only' files failing. Default FileMode = fmOpenReadWrite
    // This make each file block 1 byte long. This gives us the oppotunity to read 'variable' sized blocks to the file.
    Reset(HndReportFile,1);

    ReadHeader;

    while (not(Eof(HndReportFile))) do
    begin
      siRegionId := ReadRegionId;

      siBlockSize := GetNextBlockSize;
      GetMem(RegionParams, siBlockSize);
      ReadRegionParams(RegionParams, siBlockSize);

      if (assigned(RegionParams)) then
      begin
        if (siRegionId <> -1) then
        begin
          // PRegionParams
          while (siRegionId > RegionParamList.Count) do
            RegionParamList.Insert(RegionParamList.Count, nil);
          RegionParamList.Insert(siRegionId, RegionParams);
        end
        else
          RegionParamList.Insert(RegionParamList.Count, nil);
      end
      else
        RegionParamList.Insert(RegionParamList.Count, nil);

      siBlockSize := GetNextBlockSize;
      if (siBlockSize > 0) then
      begin
        ControlBlocks := TList.Create;
        BitMapsPresent := ReadCtrlBlocks(ControlBlocks, siBlockSize);
      end
      else
      begin
        ControlBlocks := nil;
        BitMapsPresent := FALSE;
      end;

      if (assigned(ControlBlocks)) then
      begin
        if ((siRegionId <> -1) and (ControlBlocks.Count > 0)) then
        begin
          while (siRegionId > CtrlBlockList.Count) do
            CtrlBlockList.Insert(CtrlBlockList.Count, nil);
          CtrlBlockList.Insert(siRegionId, ControlBlocks);
        end
        else
        begin
          CtrlBlockList.Insert(CtrlBlockList.Count, nil);
          ControlBlocks.Free;
        end;
      end
      else
      begin
        CtrlBlockList.Insert(CtrlBlockList.Count, nil);
      end; // if (assigned(ControlBlocks)) then...

      if (assigned(ControlBlocks)) then
      begin
        if BitMapsPresent then
        begin
          BitMapImages := TStringList.Create;
          ReadBitMaps(BitMapImages, ControlBlocks);

          if (assigned(BitMapImages)) then
          begin
            if ((siRegionId <> -1) and (BitMapImages.Count > 0)) then
            begin
              while (siRegionId > BitMapList.Count) do
                BitMapList.InsertObject(BitMapList.Count, IntToStr(BitMapList.Count), nil);
              BitMapList.InsertObject(siRegionId, IntToStr(siRegionId), BitMapImages);
            end
            else
            begin
              BitMapList.InsertObject(BitMapList.Count, IntToStr(BitMapList.Count), nil);
              BitMapImages.Free;
            end;
          end
          else
          begin
            BitMapList.InsertObject(BitMapList.Count, IntToStr(BitMapList.Count), nil);
            BitMapImages.Free;
          end;
        end; // if BitMapsPresent then...
      end
      else
      begin
        siBlockSize := GetNextBlockSize;
      end; // if (assigned(ControlBlocks)) then...
    end; // while (not(Eof(HndReportFile))) do...

    FReportFileRead := TRUE;

    FRptMainFile := ReportConstructInfo.ssMainFile;
    FRptMainFileNum := ReportConstructInfo.byMainFileNum;
    FRptIndexID := ReportConstructInfo.byIndexID;
    FRptKeyPath := ReportConstructInfo.iBTrvKeyPath;

    FPaperOrientation := Byte(ReportConstructInfo.oPaperOrientation);

  finally
    CloseFile(HndReportFile);
  end; // try...finally...
end;

//procedure TReportPersistor.SaveObject(const ReportHandle : TMemoryStream);
procedure TReportPersistor.SaveObject(const ReportHandle : TMemoryStream; const bDispose : Boolean = FALSE);
var
  siListIdx, siListCount : SmallInt;
  siItemIdx, siItemCount : SmallInt;
  BitMapsPresent : boolean;
  slBitMapFolios : TStringList;
  siStringLength : SmallInt;
  szStrBuffer : PChar;

  ReportStream : TFileStream;
  szStreamName : PChar;
  ssStreamName : ShortString;
  siPos : SmallInt;

  procedure AddBlockCount(const lwCount : LongWord);
  var
    sBlockCount : ShortString;
    szBlockCount : PChar;
  begin
    try
      sBlockCount := IntToStr(lwCount) + '#';
    except on EConvertError do
      begin
        ShowMessage('EConvertError - AddBlockCount');
        sBlockCount := '0#';
      end;
    end;              

    szBlockCount := StrAlloc((Length(sBlockCount) + 1));
    szBlockCount := StrPCopy(szBlockCount, sBlockCount);

    ReportStream.WriteBuffer(szBlockCount^, StrLen(szBlockCount));

    StrDispose(szBlockCount);
  end;

begin
  szStreamName := nil;
  if (ReportHandle.Size = 0) then
  begin
    try
      ssStreamName := ExtractFilePath(FFilePath);

      siPos := Pos('REPORTS', ssStreamName);
      Delete(ssStreamName, siPos, 7);
      Insert('SWAP', ssStreamName, siPos);

      // ensures that the SWAP directory has been created.
      ForceDirectories(ssStreamName);

      szStreamName := StrAlloc(MAX_PATH);
      FillChar(szStreamName^, MAX_PATH, Chr(0));
      szStreamName := StrPCopy(szStreamName, ssStreamName);

      if (GetTempFileName(szStreamName, '~RW', 0, szStreamName) = 0) then
        szStreamName := StrCat(szStreamName, 'RW.TMP');

      try
        ReportStream := TFileStream.Create(StrPas(szStreamName), fmCreate);
      except on E:EStreamError do
        ShowMessage('ReportStream Create error - SaveObject() - ('+E.Message+')');
      end;

      ReportStream.Position := 0;

      ReportHandle.Clear;
      ReportHandle.Position := 0;
      ReportHandle.WriteBuffer(szStreamName^, MAX_PATH);

    finally
      StrDispose(szStreamName);
    end; // try...finally
  end
  else
  begin
    szStreamName := StrAlloc(MAX_PATH);
    try
      ReportHandle.Position := 0;
      ReportHandle.ReadBuffer(szStreamName^, ReportHandle.Size);

      ssStreamName := Trim(StrPas(szStreamName));

      try
        ReportStream := TFileStream.Create(ssStreamName, fmOpenReadWrite);
      except on E:EFOpenError do
        begin
          ShowMessage('ReportStream Create error - LoadObject() - ('+E.Message+')');
          ShowMessage('ReportStream Create error - LoadObject() - ssStreamName ('+trim(ssStreamName)+')');
        end;
      end; // try..except
    finally
      StrDispose(szStreamName);
    end; // try..finally
  end; // if (ReportHandle.Size > 0) then...else...

  //  property ReportName : AnsiString read FReportName write FReportName;
  siStringLength := Length(FReportName);
  szStrBuffer := StrAlloc(siStringLength + 1);
  try
    szStrBuffer := StrPLCopy(szStrBuffer, FReportName, siStringLength);
    AddBlockCount(siStringLength);
    ReportStream.WriteBuffer(szStrBuffer^, siStringLength);
  finally
    StrDispose(szStrBuffer);
  end;

  //  property ReportDescription : AnsiString read FReportDescription write FReportDescription;
  siStringLength := Length(FReportDescription);
  szStrBuffer := StrAlloc(siStringLength + 1);
  try
    szStrBuffer := StrPLCopy(szStrBuffer, FReportDescription, siStringLength);
    AddBlockCount(siStringLength);
    ReportStream.WriteBuffer(szStrBuffer^, siStringLength);
  finally
    StrDispose(szStrBuffer);
  end;

  //  property ReportFileRead : Boolean read FReportFileRead;
  AddBlockCount(SizeOf(FReportFileRead));
  ReportStream.WriteBuffer(FReportFileRead, SizeOf(FReportFileRead));

  //  property ReportFileName : ShortString read FFileName write FFileName;
  siStringLength := Length(FFileName);
  szStrBuffer := StrAlloc(siStringLength + 1);
  try
    szStrBuffer := StrPLCopy(szStrBuffer, FFileName, siStringLength);
    AddBlockCount(siStringLength);
    ReportStream.WriteBuffer(szStrBuffer^, siStringLength);
  finally
    StrDispose(szStrBuffer);
  end;

  //  property ReportFilePath : ShortString read FFilePath;
  siStringLength := Length(FFilePath);
  szStrBuffer := StrAlloc(siStringLength + 1);
  try
    szStrBuffer := StrPLCopy(szStrBuffer, FFilePath, siStringLength);
    AddBlockCount(siStringLength);
    ReportStream.WriteBuffer(szStrBuffer^, siStringLength);
  finally
    StrDispose(szStrBuffer);
  end;

  //  property WizardBasedReport : Boolean read FWizardBasedReport write FWizardBasedReport;
  AddBlockCount(SizeOf(FWizardBasedReport));
  ReportStream.WriteBuffer(FWizardBasedReport, SizeOf(FWizardBasedReport));

  //  property ReportMainFile : ShortString read FRptMainFile write FRptMainFile;
  siStringLength := Length(FRptMainFile);
  szStrBuffer := StrAlloc(siStringLength + 1);
  try
    szStrBuffer := StrPLCopy(szStrBuffer, FRptMainFile, siStringLength);
    AddBlockCount(siStringLength);
    ReportStream.WriteBuffer(szStrBuffer^, siStringLength);
  finally
    StrDispose(szStrBuffer);
  end;

  //  property ReportMainFileNum : Byte read FRptMainFileNum write FRptMainFileNum;
  AddBlockCount(SizeOf(FRptMainFileNum));
  ReportStream.WriteBuffer(FRptMainFileNum, SizeOf(FRptMainFileNum));

  //  property ReportIndexID : Byte read FRptIndexID write FRptIndexID;
  AddBlockCount(SizeOf(FRptIndexID));
  ReportStream.WriteBuffer(FRptIndexID, SizeOf(FRptIndexID));

  //  property ReportBTrvKeyPath : Integer read FRptKeyPath write FRptKeyPath;
  AddBlockCount(SizeOf(FRptKeyPath));
  ReportStream.WriteBuffer(FRptKeyPath, SizeOf(FRptKeyPath));

  // property ReportPaperOrientation : Byte read FPaperOrientation write FPaperOrientation;
  AddBlockCount(SizeOf(FPaperOrientation));
  ReportStream.WriteBuffer(FPaperOrientation, SizeOf(FPaperOrientation));

  BitMapsPresent := FALSE;

  // Region Param List
  siListCount := RegionParamList.Count;
  AddBlockCount(siListCount);
  for siListIdx := 0 to (siListCount - 1) do
  begin
    if assigned(RegionParamList.Items[siListIdx]) then
    begin
      ReportStream.WriteBuffer(PRegionParams(RegionParamList.Items[siListIdx])^, SizeOf(TRegionParams));
      if bDispose then
      begin
        FreeMem(RegionParamList.Items[siListIdx]);
        RegionParamList.Items[siListIdx] := nil;
      end;
    end;
  end;

  // Control Param List
  slBitMapFolios := nil;
  siListCount := CtrlBlockList.Count;
  AddBlockCount(siListCount);
  for siListIdx := 0 to (siListCount - 1) do
  begin
    if (assigned(CtrlBlockList.Items[siListIdx])) then
    begin
      siItemCount := TList(CtrlBlockList.Items[siListIdx]).Count;
      AddBlockCount(siItemCount);
      for siItemIdx := 0 to (siItemCount - 1) do
      begin
        if (PCtrlParams(TList(CtrlBlockList.Items[siListIdx]).Items[siItemIdx])^.cpCtrlType = REPORT_IMAGE) then
        begin
          if (not(assigned(slBitMapFolios))) then
            slBitMapFolios := TStringList.Create;
          slBitMapFolios.Add(PCtrlParams(TList(CtrlBlockList.Items[siListIdx]).Items[siItemIdx])^.ImageParams.BitMapFolio);
          BitMapsPresent := TRUE;
        end;
        ReportStream.WriteBuffer(TList(CtrlBlockList.Items[siListIdx]).Items[siItemIdx]^, SizeOf(TCtrlParams));
      end; // for siItemIdx := 0 to (siItemCount - 1) do...
    end
    else
      AddBlockCount(0);
  end; // for siListIdx := 0 to (siListCount - 1) do...

  // store any bitmaps
  if (BitMapsPresent) then
  begin
    siListCount := BitMapList.Count;
    AddBlockCount(siListCount);
    for siListIdx := 0 to (siListCount - 1) do
    begin
      // each item in BitMapList, one item for each region, is a TStringlist of bitmaps objects.
      // in other words a TStringList containing bitmap objects for each region.
      if (assigned(BitMapList.Objects[siListIdx])) then
      begin
        siItemCount := TStringList(BitMapList.Objects[siListIdx]).Count;
        AddBlockCount(siItemCount);
        for siItemIdx := 0 to (siItemCount - 1) do
        begin
          // write order is Bitmap size # Bitmap folio # raw Bitmap
          // note terminating # not required in this sequence cos we'll only read the amount determined by
          // the Bitmap size after the Bitmap folio, which is delimited.
          AddBlockCount(TRawBMPStore(TStringList(BitMapList.Objects[siListIdx]).Objects[siItemIdx]).iBMPSize);
          AddBlockCount(StrToInt(slBitMapFolios[0]));
          slBitMapFolios.Delete(0);
          ReportStream.WriteBuffer(TRawBMPStore(TStringList(BitMapList.Objects[siListIdx]).Objects[siItemIdx]).pBMP^,
                                    TRawBMPStore(TStringList(BitMapList.Objects[siListIdx]).Objects[siItemIdx]).iBMPSize);
        end; // for siItemIdx := 0 to (siItemCount - 1) do...
      end
      else
        AddBlockCount(0);
    end; // for siListIdx := 0 to (siListCount) do...
  end; // if (BitMapsPresent) then...

  ReportStream.Free;

end;

procedure TReportPersistor.LoadObject(const ReportHandle : TMemoryStream);
var
  pParamsBuffer : Pointer;
  pStringBuffer : Pointer;
  lstParamsList : TList;
  siStringLength : SmallInt;
  siBlockIdx, siBlockCount : SmallInt;
  siItemIdx, siItemCount : SmallInt;
  BitmapsPresent : boolean;
  slRegionBitMapList : TStringList;
  oRawBitMap : TRawBMPStore;
  ssBMPFolio : ShortString;

  ReportStream : TFileStream;
  szStreamName : PChar;
  ssStreamName : ShortString;
  siPos : SmallInt;

  function GetBlockCount : LongWord;
  var
    sBlockCount : ShortString;
    szBlockCount : PChar;
  begin
    sBlockCount := '';
    szBlockCount := StrAlloc(6);

    FillChar(szBlockCount^, 5, 0);
    try
      ReportStream.ReadBuffer(szBlockCount^, 1);
    except on EReadError do
      szBlockCount := StrLCat(szBlockCount, '#', 6);
    end;
    while (szBlockCount[0] <> '#') do
    begin
      sBlockCount := sBlockCount + StrPas(szBlockCount);
      FillChar(szBlockCount^, 5, 0);
      try
        ReportStream.ReadBuffer(szBlockCount^, 1);
      except on EReadError do
        szBlockCount := StrLCat(szBlockCount, '#', 6);
      end;
    end;

    try
      Result := StrToInt(sBlockCount);
    except on EConvertError do
      Result := 0;
    end;
  end;

begin
  pParamsBuffer := nil;
  if (assigned(ReportHandle.Memory) and (ReportHandle.Size > 0)) then
  begin
    ReportHandle.Position := 0;

    szStreamName := StrAlloc(MAX_PATH);
    try
      FillChar(szStreamName^, MAX_PATH, chr(0));
      ReportHandle.ReadBuffer(szStreamName^, ReportHandle.Size);
      ssStreamName := Trim(StrPas(szStreamName));
    finally
      StrDispose(szStreamName);
    end;

    try
      ReportStream := TFileStream.Create(ssStreamName, fmOpenReadWrite);
    except on E:EFOpenError do
      begin
        ShowMessage('ReportStream Create error - LoadObject() - ('+E.Message+')');  
        ShowMessage('ReportStream Create error - LoadObject() - ssStreamName ('+trim(ssStreamName)+')');
      end;
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength + 1);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FReportName := StrPas(pStringBuffer);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength + 1);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FReportDescription := StrPas(pStringBuffer);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FReportFileRead := Boolean(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength + 1);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FFileName := StrPas(pStringBuffer);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength + 1);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
       if (assigned(pStringBuffer)) then
        FFilePath := StrPas(pStringBuffer);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FWizardBasedReport := Boolean(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength + 1);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FRptMainFile := StrPas(pStringBuffer);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FRptMainFileNum := Byte(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FRptIndexID := Byte(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FRptKeyPath := Integer(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    siStringLength := GetBlockCount;
    pStringBuffer := nil;
    GetMem(pStringBuffer, siStringLength);
    try
      try
        ReportStream.ReadBuffer(pStringBuffer^, siStringLength);
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pStringBuffer)) then
        FPaperOrientation := Byte(pStringBuffer^);
    finally
      FreeMem(pStringBuffer);
    end;

    BitMapsPresent := FALSE;

    // do RegionParam list.
    siBlockCount := GetBlockCount;

    RegionParamList.Clear;

    pParamsBuffer := nil;
    for siBlockIdx := 1 to siBlockCount do
    begin
      GetMem(pParamsBuffer, SizeOf(TRegionParams));
      try
        ReportStream.ReadBuffer(pParamsBuffer^, SizeOf(TRegionParams));
      except on EReadError do
        begin
          FreeMem(pParamsBuffer);
          pParamsBuffer := nil;
        end;
      end; // try...except
      if (assigned(pParamsBuffer)) then
        RegionParamList.Add(pParamsBuffer);
    end; // for siBlockIdx := 1 to siBlockCount do...

    // do the control block list
    siBlockCount := GetBlockCount;
{ TODO : Potential Memory Leak - CtrlBlockList still contains items when this is cleared }
    CtrlBlockList.Clear;
    for siBlockIdx := 1 to siBlockCount do
    begin
      siItemCount := GetBlockCount;
      lstParamsList := TList.Create;
      for siItemIdx := 1 to siItemCount do
      begin
        GetMem(pParamsBuffer, SizeOf(TCtrlParams));
        try
          ReportStream.ReadBuffer(pParamsBuffer^, SizeOf(TCtrlParams));
        except on EReadError do
          begin
            FreeMem(pParamsBuffer);
            pParamsBuffer := nil;
          end;
        end; // try...except
        if (assigned(pParamsBuffer)) then
        begin
          if (PCtrlParams(pParamsBuffer)^.cpCtrlType = REPORT_IMAGE) then
            BitMapsPresent := TRUE;

          lstParamsList.Add(pParamsBuffer);
        end;
      end; // for siItemIdx := 1 to siItemCount do...
      CtrlBlockList.Add(lstParamsList);
    end; // for siBlockIdx := 1 to siBlockCount do...

    // do the bitmaps if any
    if (BitMapsPresent) then
    begin
      BitMapList.Clear;

      // write order is Bitmap size # Bitmap folio # raw Bitmap
      // note terminating # not required in this sequence cos we'll only read the amount determined by
      // the Bitmap size after the Bitmap folio, which is delimited.
      siBlockCount := GetBlockCount;
      for siBlockIdx := 1 to siBlockCount do
      begin
        siItemCount := GetBlockCount;
        slRegionBitMapList := TStringList.Create;
        for siItemIdx := 1 to siItemCount do
        begin
          oRawBitMap := TRawBMPStore.Create;
          oRawBitMap.iBMPSize := GetBlockCount;

          // get the Bitmap folio in here. ssBMPFolio
          ssBMPFolio := IntToStr(GetBlockCount);
          GetMem(oRawBitMap.pBMP, oRawBitMap.iBMPSize);

          // get the raw bitmap
          ReportStream.ReadBuffer(oRawBitMap.pBMP^, oRawBitMap.iBMPSize);
          slRegionBitMapList.AddObject(ssBMPFolio, oRawBitMap);
        end; // for siItemIdx := 1 to siItemCount do...

        BitMapList.InsertObject((siBlockIdx-1), IntToStr((siBlockIdx-1)), slRegionBitMapList);

      end; // for siBlockIdx := 1 to siBlockCount do...

    end; // if (BitMapsPresent) then

    ReportStream.Free;

  end; // if (assigned(ReportHandle.Memory) and (ReportHandle.Size > 0)) then...
end;

procedure TReportPersistor.ClearRegionBlocks;
begin
  if (assigned(RegionParamList)) then
    if (RegionParamList.Count > 0) then
      RegionParamList.Clear;
{ TODO : Potential Memory Leak }
end;

procedure TReportPersistor.AddRegionBlock(const pBlock : Pointer; const RegionId : Byte);
begin
  if assigned(pBlock) then
    RegionParamList.Insert(RegionId, pBlock)
  else
    RegionParamList.Insert(RegionId, nil);
end;

procedure TReportPersistor.ClearReportBlocks;
begin
  if (assigned(CtrlBlockList)) then
    if (CtrlBlockList.Count > 0) then
      CtrlBlockList.Clear;
{ TODO : Potential Memory Leak }

  if (assigned(BitMapList)) then
    if (BitMapList.Count > 0) then
      BitMapList.Clear;
{ TODO : Potential Memory Leak }
end;

procedure TReportPersistor.AddReportBlock(const pBlock, pBitMaps : Pointer; const RegionId : Byte);
begin
  if assigned(pBlock) then
    CtrlBlockList.Insert(RegionId, pBlock)
  else
    CtrlBlockList.Insert(RegionId, nil);

  if (assigned(pBitMaps)) then
    BitMapList.InsertObject(RegionId, IntToStr(RegionId), pBitMaps)
  else
    BitMapList.InsertObject(RegionId, IntToStr(RegionId), nil);
end;

procedure TReportPersistor.WriteHeader;
var
  szHdr : PChar;
  siHdrSize : SmallInt;
  sHdrSize : ShortString;
  szHdrSize : PChar;

  szPrintParams : PChar;
  szMiscOpt : PChar;
  sMiscOpt : ShortString;
  siOptIdx : SmallInt;

  szTestModeParams : PChar;
begin
  szHdr := StrAlloc(MAX_HDR_SIZE + 1); // MAX_HDR_SIZE = 4096
  szPrintParams := StrAlloc(SizeOf(TPrintMethodParams));
  szTestModeParams := StrAlloc(255);
  try
    FillChar(szHdr^,MAX_HDR_SIZE, NULL_CHAR);
    FillChar(szPrintParams^, SizeOf(TPrintMethodParams), NULL_CHAR);
    FillChar(szTestModeParams^, 255, NULL_CHAR);

    szHdr := StrPLCopy(szHdr,
                       ssRWVersion + BLOCK_DELIMITER +
                       trim(FReportName) + BLOCK_DELIMITER +
                       trim(FReportDescription) + BLOCK_DELIMITER +
                       trim(FRptMainFile) + BLOCK_DELIMITER +
                       IntToStr(FRptMainFileNum) + BLOCK_DELIMITER +
                       IntToStr(FRptIndexID) + BLOCK_DELIMITER +
                       IntToStr(FRptKeyPath) + BLOCK_DELIMITER +
                       IntToStr(FPaperOrientation) + BLOCK_DELIMITER,
                       MAX_HDR_SIZE);

    with ReportConstructInfo.PrintMethodParams do
    begin
      sMiscOpt := '';
      for siOptIdx := Low(pmMiscOptions) to High(pmMiscOptions) do
        sMiscOpt := sMiscOpt + IntToStr(Ord(pmMiscOptions[siOptIdx]));

      szMiscOpt := StrAlloc(High(pmMiscOptions));
      szMiscOpt := StrPCopy(szMiscOpt, sMiscOpt);

      szPrintParams := StrPLCopy(szPrintParams,
                         IntToStr(pmPrintMethod) + BLOCK_DELIMITER +
                         IntToStr(Ord(pmBatch)) + BLOCK_DELIMITER + 
                         IntToStr(pmTypes) + BLOCK_DELIMITER +
                         trim(pmCoverSheet) + BLOCK_DELIMITER +
                         IntToStr(pmFaxMethod) + BLOCK_DELIMITER +
                         IntToStr(pmFaxPrinter) + BLOCK_DELIMITER +
                         trim(pmFaxFrom) + BLOCK_DELIMITER +
                         trim(pmFaxFromNo) + BLOCK_DELIMITER +
                         trim(pmFaxTo) + BLOCK_DELIMITER +
                         trim(pmFaxToNo) + BLOCK_DELIMITER +
                         trim(pmFaxMsg) + BLOCK_DELIMITER +
                         IntToStr(Ord(pmEmailMAPI)) + BLOCK_DELIMITER +
                         trim(pmEmailFrom) + BLOCK_DELIMITER +
                         trim(pmEmailFromAd) + BLOCK_DELIMITER +
                         trim(pmEmailTo) + BLOCK_DELIMITER +
                         trim(pmEmailToAddr) + BLOCK_DELIMITER +
                         trim(pmEmailCc) + BLOCK_DELIMITER +
                         trim(pmEmailBcc) + BLOCK_DELIMITER +
                         trim(pmEmailSubj) + BLOCK_DELIMITER +
                         trim(pmEmailMsg) + BLOCK_DELIMITER +
                         trim(pmEmailAttach) + BLOCK_DELIMITER +
                         IntToStr(pmEmailPriority) + BLOCK_DELIMITER +
                         IntToStr(Ord(pmEmailReader)) + BLOCK_DELIMITER +
                         IntToStr(pmEmailZIP) + BLOCK_DELIMITER +
                         IntToStr(pmEmailAtType) + BLOCK_DELIMITER +
                         IntToStr(pmFaxPriority) + BLOCK_DELIMITER +
                         IntToStr(pmXMLType) + BLOCK_DELIMITER +
                         IntToStr(Ord(pmXMLCreateHTML)) + BLOCK_DELIMITER +
                         trim(pmXMLFileDir) + BLOCK_DELIMITER +
                         trim(pmEmailFName) + BLOCK_DELIMITER +
                         szMiscOpt  + BLOCK_DELIMITER, 
                         SizeOf(TPrintMethodParams));

    end; // with ReportConstructInfo.PrintMethodParams...

    szHdr := StrLCat(szHdr, szPrintParams, MAX_HDR_SIZE);

    with ReportConstructInfo.TestModeParams do
    begin
      szTestModeParams := StrPLCopy(szTestModeParams,
                                    IntToStr(Ord(TestMode)) + BLOCK_DELIMITER +
                                    IntToStr(SampleCount) + BLOCK_DELIMITER +
                                    IntToStr(Ord(RefreshStart)) + BLOCK_DELIMITER +
                                    IntToStr(Ord(RefreshEnd)) + BLOCK_DELIMITER +
                                    IntToStr(FirstRecPos) + BLOCK_DELIMITER +
                                    IntToStr(LastRecPos) + BLOCK_DELIMITER,
                                    254);
      szHdr := StrLCat(szHdr, szTestModeParams, MAX_HDR_SIZE);
    end;

    // HM 10/03/05: Added Index Input Field for v1.02 (build 2.28)
    With ReportConstructInfo.IndexInput Do
    Begin
      szTestModeParams := StrPLCopy(szTestModeParams,
                                    ssDescription + BLOCK_DELIMITER +
                                    IntToStr(siType) + BLOCK_DELIMITER +
                                    ssFromValue + BLOCK_DELIMITER +
                                    ssToValue + BLOCK_DELIMITER +
                                    IntToStr(Ord(bAlwaysAsk)) + BLOCK_DELIMITER,
                                    254);
      szHdr := StrLCat(szHdr, szTestModeParams, MAX_HDR_SIZE);
    End; // With ReportConstructInfo.IndexInput

    siHdrSize := StrLen(szHdr);
    sHdrSize := IntToStr(siHdrSize) + BLOCK_DELIMITER;

    szHdrSize := StrAlloc(Length(sHdrSize) + 1);
    try
      FillChar(szHdrSize^, Length(sHdrSize), NULL_CHAR);
      szHdrSize := StrPLCopy(szHdrSize, sHdrSize, Length(sHdrSize));

      try
        BlockWrite(HndReportFile, szHdrSize^, StrLen(szHdrSize));
      except
        on E:EInOutError do
          ShowMessage('WriteHeader() ' + E.Message);
      end;

    finally
      StrDispose(szHdrSize);
    end;

    try
      BlockWrite(HndReportFile, szHdr^, StrLen(szHdr));
    except
      on E:EInOutError do
        ShowMessage('WriteHeader() ' + E.Message);
    end;

  finally
    StrDispose(szHdr);
    StrDispose(szPrintParams);
    StrDispose(szTestModeParams);
  end;
end;

procedure TReportPersistor.WriteRegionId(const siRegionId : SmallInt);
var
  ssRegionId : ShortString;
  szRegionId : PChar;
begin
  ssRegionId := IntToStr(siRegionId);

  szRegionId := StrAlloc(Length(ssRegionId) + 1);
  try
    FillChar(szRegionId^, Length(ssRegionId), NULL_CHAR);
    szRegionId := StrPLCopy(szRegionId, ssRegionId, Length(ssRegionId));

    try
      BlockWrite(HndReportFile, szRegionId^, StrLen(szRegionId));
    except
      on E:EInOutError do
        ShowMessage('WriteRegionId() ' + E.Message);
    end;
  finally
    StrDispose(szRegionId);
  end;

  try
    BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
  except
    on E:EInOutError do
      ShowMessage('WriteRegionId() ' + E.Message);
  end;
end;

procedure TReportPersistor.WriteRegionParams(const pRegionParams : Pointer);
var
  szBlockSize : PChar;
  siBlockSize : SmallInt;
begin
  if assigned(pRegionParams) then
  begin
    siBlockSize := SizeOf(TRegionParams);

    szBlockSize := StrAlloc(MAX_SMALLINT_LGTH);
    try
      FillChar(szBlockSize^, MAX_SMALLINT_LGTH, NULL_CHAR);
      szBlockSize := StrPLCopy(szBlockSize, IntToStr(siBlockSize), MAX_SMALLINT_LGTH);

      try
        BlockWrite(HndReportFile, szBlockSize^, StrLen(szBlockSize));
      except
        on E:EInOutError do
         ShowMessage('WriteRegionParams() ' + E.Message);
      end;

    finally
      StrDispose(szBlockSize);
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteRegionParams() ' + E.Message);
    end;

    try
      BlockWrite(HndReportFile, pRegionParams^, siBlockSize);
    except
      on E:EInOutError do
        ShowMessage('WriteRegionParams() ' + E.Message);
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteRegionParams() ' + E.Message);
    end;

  end; // if assigned(pRegionParams) then...
end;

procedure TReportPersistor.WriteCtrlBlocks(const pReportBlock : Pointer);
var
  szBlockSize : PChar;
  siBlockIdx : SmallInt;
  iBlockSize : Integer;
begin
  if assigned(pReportBlock) then
  begin
    iBlockSize := 0;
    for siBlockIdx := 0 to (TList(pReportBlock).Count - 1) do
      iBlockSize := iBlockSize + SizeOf(PCtrlParams(TList(pReportBlock).Items[(siBlockIdx-1)])^);

    szBlockSize := StrAlloc(MAX_SMALLINT_LGTH);
    try
      FillChar(szBlockSize^, MAX_SMALLINT_LGTH, NULL_CHAR);
      szBlockSize := StrPLCopy(szBlockSize, IntToStr(iBlockSize), MAX_SMALLINT_LGTH);

      try
        BlockWrite(HndReportFile, szBlockSize^, StrLen(szBlockSize));
      except
        on E:EInOutError do
         ShowMessage('WriteCtrlBlocks() ' + E.Message);
      end;

    finally
      StrDispose(szBlockSize);
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteCtrlBlocks() ' + E.Message);
    end;

    for siBlockIdx := 0 to (TList(pReportBlock).Count - 1) do
    begin
      try
        BlockWrite(HndReportFile, PCtrlParams(TList(pReportBlock).Items[siBlockIdx])^,
                                                            SizeOf(PCtrlParams(TList(pReportBlock).Items[siBlockIdx])^));
      except
        on E:EInOutError do
          ShowMessage('WriteCtrlBlocks() ' + E.Message);
      end;
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteCtrlBlocks() ' + E.Message);
    end;

  end
  else
  begin
    szBlockSize := StrAlloc(MAX_SMALLINT_LGTH);
    try
      FillChar(szBlockSize^, MAX_SMALLINT_LGTH, NULL_CHAR);
      szBlockSize := StrPLCopy(szBlockSize, '0', MAX_SMALLINT_LGTH);

      try
        BlockWrite(HndReportFile, szBlockSize^, StrLen(szBlockSize));
      except
        on E:EInOutError do
         ShowMessage('WriteCtrlBlocks() ' + E.Message);
      end;

    finally
      StrDispose(szBlockSize);
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteCtrlBlocks() ' + E.Message);
    end;
  end; // if assigned(pReportBlock) then...
end;

procedure TReportPersistor.WriteBMPBlocks(const pReportBMPs : TStringList);
var
  szBitMapFolio : PChar;
  szBlockSize : PChar;
  siBlockIdx,
  iBlockSize : Integer;
begin
  if assigned(pReportBMPs) then
  begin
    for siBlockIdx := 0 to (pReportBMPs.Count - 1) do
    begin
      iBlockSize := TRawBMPStore(pReportBMPs.Objects[siBlockIdx]).iBMPSize;

      szBlockSize := StrAlloc(MAX_SMALLINT_LGTH);
      try
        FillChar(szBlockSize^, MAX_SMALLINT_LGTH, NULL_CHAR);
        szBlockSize := StrPLCopy(szBlockSize, IntToStr(iBlockSize), MAX_SMALLINT_LGTH);

        try
          BlockWrite(HndReportFile, szBlockSize^, StrLen(szBlockSize));
        except
          on E:EInOutError do
           ShowMessage('WriteBMPBlocks() ' + E.Message);
        end;

      finally
        StrDispose(szBlockSize);
      end; // try...finally

      try
        BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
      except
        on E:EInOutError do
          ShowMessage('WriteBMPBlocks() ' + E.Message);
      end;

      // Bitmap folio
      szBitMapFolio := StrAlloc(Length(pReportBMPs.Strings[siBlockIdx]) + 1);
      try
        FillChar(szBitMapFolio^, Length(pReportBMPs.Strings[siBlockIdx]), NULL_CHAR);
        szBitMapFolio := StrPLCopy(szBitMapFolio, pReportBMPs.Strings[siBlockIdx], Length(pReportBMPs.Strings[siBlockIdx]));

        try
          BlockWrite(HndReportFile, szBitMapFolio^, StrLen(szBitMapFolio));
        except
          on E:EInOutError do
            ShowMessage('WriteBMPBlocks() ' + E.Message);
        end;

      finally
        StrDispose(szBitMapFolio);
      end;

      try
        BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
      except
        on E:EInOutError do
          ShowMessage('WriteBMPBlocks() ' + E.Message);
      end;

      // The actual Bitmap
      try
        BlockWrite(HndReportFile, TRawBMPStore(pReportBMPs.Objects[siBlockIdx]).pBMP^,
                                                               TRawBMPStore(pReportBMPs.Objects[siBlockIdx]).iBMPSize);
      except
        on E:EInOutError do
          ShowMessage('WriteBMPBlocks() ' + E.Message);
      end;

      try
        BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
      except
        on E:EInOutError do
          ShowMessage('WriteBMPBlocks() ' + E.Message);
      end;
    end; // for siBlockIdx := 0 to (pReportBMPs.Count - 1) do...
  end
  else
  begin
    szBlockSize := StrAlloc(MAX_SMALLINT_LGTH);
    try
      FillChar(szBlockSize^, MAX_SMALLINT_LGTH, NULL_CHAR);
      szBlockSize := StrPLCopy(szBlockSize, '0', MAX_SMALLINT_LGTH);

      try
        BlockWrite(HndReportFile, szBlockSize^, StrLen(szBlockSize));
      except
        on E:EInOutError do
         ShowMessage('WriteBMPBlocks() ' + E.Message);
      end;

    finally
      StrDispose(szBlockSize);
    end;

    try
      BlockWrite(HndReportFile, BLOCK_DELIMITER, Length(BLOCK_DELIMITER));
    except
      on E:EInOutError do
        ShowMessage('WriteBMPBlocks() ' + E.Message);
    end;
  end; // if assigned(pReportBlock) then...
end;


procedure TReportPersistor.ReadHeader;
var
  cHdrByte : Char;
  ssHdrSize : ShortString;
  siHdrSize : SmallInt;
  szHdr : PChar;
begin
  ssHdrSize := '';
  try
    BlockRead(HndReportFile, cHdrByte, 1);
    ssHdrSize := ssHdrSize + cHdrByte;
    while ((not (Eof(HndReportFile))) and (Pos(BLOCK_DELIMITER,ssHdrSize) = 0)) do
    begin
      BlockRead(HndReportFile, cHdrByte, 1);
      ssHdrSize := ssHdrSize + cHdrByte;
    end;
  except
    on E:EInOutError do
      ShowMessage('ReadHeader() ' + E.Message);
  end;

  if (Length(ssHdrSize) > 0) then
  begin
    ssHdrSize := Copy(ssHdrSize, 1, (Pos(BLOCK_DELIMITER, ssHdrSize) - 1) );
    try
      siHdrSize := StrToInt(ssHdrSize);
    except on E:EConvertError do
      siHdrSize := 0;
    end;

    if (siHdrSize > 0) then
    begin
        szHdr := StrAlloc(siHdrSize + 1);
      try
        FillChar(szHdr^, (siHdrSize + 1), NULL_CHAR);

        try
          BlockRead(HndReportFile, szHdr^, siHdrSize);
          ParseReportHeader(siHdrSize, szHdr);
        except
          on E:EInOutError do
            ShowMessage('ReadHeader() ' + E.Message);
        end;

      finally
        StrDispose(szHdr);
      end; // try...finally
    end; // if (siHdrSize > 0) then...
  end; // if (Length(ssHdrSize) > 0) then...
end;

procedure TReportPersistor.ParseReportHeader(const siHeaderSize : SmallInt; const szHeader : PChar);
var
  sHdr : AnsiString;
  ssHeaderField : ShortString;
  ssVersionMajor, ssVersionMinor : ShortString;
  siVersionMajor, siVersionMinor : SmallInt;
  siDotPos : SmallInt;
begin
  if (StrLen(szHeader) > 0) then
  begin
    sHdr := StrPas(szHeader);

    ssHeaderField := '';
    // check against siHeaderSize to stop string overruns.
    while (Length(sHdr) > 0) and (Pos(BLOCK_DELIMITER,ssHeaderField) = 0) do
    begin
      ssHeaderField := ssHeaderField + sHdr[1];
      Delete(sHdr,1,1);
    end;
    ssHeaderField := Copy(ssHeaderField, 1, (Pos(BLOCK_DELIMITER, ssHeaderField) - 1) );

    // expecting the first field to be a version number
    siDotPos := Pos('.',ssHeaderField);
    ssVersionMajor := Copy(ssHeaderField, 1, (siDotPos - 1) );
    ssVersionMinor := Copy(ssHeaderField, (siDotPos + 1), (Length(ssHeaderField) - siDotPos) );
    try
      siVersionMajor := StrToInt(trim(ssVersionMajor));
      siVersionMinor := StrToInt(trim(ssVersionMinor));
    except
      on E : EConvertError do
      begin
        siVersionMajor := 1;     // THINK. May need to make these properties of the Report Persistor object...
        siVersionMinor := 0;
      end;
    end;

    case siVersionMajor of
      1 : VersionOneParser(sHdr, siVersionMinor);
      else
        ShowMessage('Unknown report format in report file ('+FFileName+')');
    end;

  end; // if (StrLen(szHeader) > 0) then...
end;

procedure TReportPersistor.VersionOneParser(var sHdr : AnsiString; const siVerMinor : SmallInt);
var
  ssFileStr : ShortString;
  siOptIdx : SmallInt;

  Function ReadString (Var sFileString : AnsiString) : ShortString;
  Var
    iBlockPos : SmallInt;
  Begin // ReadString
    iBlockPos := Pos(BLOCK_DELIMITER, sFileString);
    If (iBlockPos > 0) Then
    Begin
      Result := Copy (sFileString, 1, iBlockPos - 1);
      Delete (sFileString, 1, iBlockPos + 1);
    End // If (iBlockPos > 0)
    Else
      Result := '';
  End; // ReadString

  Function ReadInteger (Var sFileString : AnsiString) : Integer;
  Begin // ReadInteger
    try
      Result := StrToInt(ReadString(sFileString));
    Except
      On EConvertError Do
        Result := 0;
    end;
  End; // ReadInteger

begin
  ResetPrintMethodParams;

  if (siVerMinor >= 0) then // basic parameters common to all reports
  begin
    FReportName := '';
    // ensure that we don't run out of header and wait for the delimiter to come to the front of the string.
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      FReportName := FReportName + sHdr[1];
      Delete(sHdr,1,1);
    end;
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

    FReportDescription := '';
    // ensure that we don't run out of header and wait for the delimiter to come to the front of the string.
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      FReportDescription := FReportDescription + sHdr[1];
      Delete(sHdr,1,1);
    end;
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

    ReportConstructInfo.ssMainFile := '';
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      ReportConstructInfo.ssMainFile :=  ReportConstructInfo.ssMainFile + sHdr[1];
      Delete(sHdr,1,1);
    end;
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

    ssFileStr := '';
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      ssFileStr :=  ssFileStr + sHdr[1];
      Delete(sHdr,1,1);
    end;
    ReportConstructInfo.byMainFileNum := StrToInt(ssFileStr);
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

    ssFileStr := '';
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      ssFileStr :=  ssFileStr + sHdr[1];
      Delete(sHdr,1,1);
    end;
    ReportConstructInfo.byIndexID := StrToInt(ssFileStr);
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));
          
    ssFileStr := '';
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      ssFileStr :=  ssFileStr + sHdr[1];
      Delete(sHdr,1,1);
    end;
    ReportConstructInfo.iBTrvKeyPath := StrToInt(ssFileStr);
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

    ssFileStr := '';
    while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
    begin
      ssFileStr :=  ssFileStr + sHdr[1];
      Delete(sHdr,1,1);
    end;
    if (length(ssFileStr) > 0) then
      ReportConstructInfo.oPaperOrientation := TOrientation(StrToInt(ssFileStr))
    else
      ReportConstructInfo.oPaperOrientation := poPortrait;
    // remove delimiter from header string
    Delete(sHdr,1,Length(BLOCK_DELIMITER));

  end; // siVerMinor - 1

  // additional delivery method parameters, added in Preview 2.08
  if (siVerMinor >= 1) then
  begin
    with ReportConstructInfo.PrintMethodParams do
    begin
      ssFileStr := ''; pmPrintMethod := 0; // Flag: 0=Printer, 1=Fax, 2=Email, 3=XML, 4=File, 5=Excel, 6=Text, 7=HTML
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmPrintMethod := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmBatch := FALSE; // Flag: Printing a batch - disable To details as specified later
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmBatch := (sHdr[1] = '1');
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmTypes := 0; // Flag: 2=Allow Fax, 4=AllowEmail, 8=AllowXML, 16=AllowExcel, 32=HTML
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmTypes := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmCoverSheet := ''; // Cover Sheet
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmCoverSheet := pmCoverSheet + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmFaxMethod := 0; // Fax: Send method:- 0=Enterprise, 1=MAPI
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmFaxMethod := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmFaxPrinter := 0; // Fax: Selected Printer
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmFaxPrinter := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmFaxFrom := ''; // Fax: From Name
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmFaxFrom := pmFaxFrom + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmFaxFromNo := '';  // Fax: From Fax Number
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmFaxFromNo := pmFaxFromNo + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmFaxTo := '';  // Fax: To Name
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmFaxTo := pmFaxTo + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmFaxToNo := '';  // Fax: To Fax Number
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmFaxToNo := pmFaxToNo + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmFaxMsg := ''; // Fax: Message (max 255)
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmFaxMsg := pmFaxMsg + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailMAPI := FALSE; // Email: Send using MAPI
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailMAPI := (sHdr[1] = '1');
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailFrom := '';  // Email: From Name
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailFrom := pmEMailFrom + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailFromAd := ''; // Email: From Address
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailFromAd := pmEmailFromAd + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailTo := ''; // Email: Name
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailTo := pmEMailTo + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailToAddr := '';  // Email: Addr
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailToAddr := pmEmailToAddr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailCc := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailCc := pmEmailCc + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailBcc := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailBcc := pmEmailBcc + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailSubj := '';  // Email: Subject
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailSubj := pmEmailSubj + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailMsg := '';  // Email: Message (max 255)
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailMsg := pmEmailMsg + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailAttach := '';  // Email: Attachments (for future use - maybe)
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailAttach := pmEmailAttach + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmEmailPriority := 0; // Email: Priority - 0=Low, 1=Normal, 2=High
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmEmailPriority := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailReader := FALSE; // Email: Attach Acrobat/Exchequer Reader
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailReader := (sHdr[1] = '1');
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmEmailZIP := 0; // Email: ZIP Attachment as self-extracting .EXE
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmEmailZIP := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmEmailAtType := 0; // Email: Attachment methodology:- 0-RPPro, 1-Adobe, 2-RAVE PDF, 3-RAVE HTML
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmEmailAtType := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmFaxPriority := 0; // Fax: Priority:- 0=Urgent, 1=Normal, 2=OffPeak
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmFaxPriority := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      ssFileStr := ''; pmXMLType := 0; // XML Method: 0=File, 1=Email
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      pmXMLType := StrToInt(ssFileStr);
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmXMLCreateHTML := FALSE; // XML: Also create HTML file
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmXMLCreateHTML := (sHdr[1] = '1');
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmXMLFileDir := '';  // XML: Path to save .XML File in
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmXMLFileDir := pmXMLFileDir + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      pmEmailFName := '';  // Email form attachment name
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        pmEmailFName := pmEmailFName + sHdr[1];
        Delete(sHdr,1,1);
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      // Array of miscellaneous booleans for storing misc options from print dialog
      // Print to Excel : 1=Open XLS automatically, 2=Hide Page Headers/Footers, 3=Hide Totals
      // Print to HTMl  : 1=Open .HTML automatically
      // 10 = When printing a form which is account based, override cover sheets from account details
      for siOptIdx := Low(pmMiscOptions) to High(pmMiscOptions) do
        pmMiscOptions[siOptIdx] := FALSE;

      ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      for siOptIdx := Low(pmMiscOptions) to High(pmMiscOptions) do
        pmMiscOptions[siOptIdx] := (ssFileStr[siOptIdx] = '1');
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

    end; // with ReportConstructInfo.PrintMethodParams do...

    // code for testmode parameters here.
    with ReportConstructInfo.TestModeParams do
    begin
      TestMode := FALSE; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      TestMode := (ssFileStr[1] = '1');
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      SampleCount := 0; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      try
        SampleCount := StrToInt(ssFileStr);
      except on EConvertError do
        SampleCount := 0;
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      RefreshStart := FALSE; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      RefreshStart := (ssFileStr[1] = '1');
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      RefreshEnd := FALSE; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      RefreshEnd := (ssFileStr[1] = '1');
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      FirstRecPos := 0; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      try
        FirstRecPos := StrToInt(ssFileStr);
      except on EConvertError do
        FirstRecPos := 0;
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));

      LastRecPos := 0; ssFileStr := '';
      while (length(sHdr)>0) and (Pos(BLOCK_DELIMITER,sHdr)<>1) do
      begin
        ssFileStr := ssFileStr + sHdr[1];
        Delete(sHdr,1,1);
      end;
      try
        LastRecPos := StrToInt(ssFileStr);
      except on EConvertError do
        LastRecPos := 0;
      end;
      // remove delimiter from header string
      Delete(sHdr,1,Length(BLOCK_DELIMITER));
    end;

  end; // if (siVerMinor >= 1) then...

  // HM 10/03/05: Added Input Field on Report Header for Indexing in v1.02 (build 2.28)
  If (siVerMinor >= 2) then
  begin
    With ReportConstructInfo.IndexInput do
    Begin
      ssDescription := ReadString (sHdr);
      siType := ReadInteger(sHdr);
      ssFromValue := ReadString (sHdr);
      ssToValue := ReadString (sHdr);
      bAlwaysAsk := (ReadString (sHdr) = '1');
    End; // With ReportConstructInfo.IndexInput
  End; // If (siVerMinor >= 2)
end;

//-------------------------------------------------------------------------

function TReportPersistor.ReadRegionId : SmallInt;
var
  ssRegionId : ShortString;
  cFileByte : Char;
begin
  ssRegionId := '';
  while ((not (Eof(HndReportFile))) and (Pos(BLOCK_DELIMITER,ssRegionId) = 0)) do
  begin
    BlockRead(HndReportFile, cFileByte, 1);
    ssRegionId := ssRegionId + cFileByte;
  end;

  if (Length(ssRegionId) > Length(BLOCK_DELIMITER)) then
  begin
    ssRegionId := Copy(ssRegionId, 1, (Pos(BLOCK_DELIMITER,ssRegionId) - 1) );
    try
      Result := StrToInt(ssRegionId);
    except on
      E : EConvertError do
        Result := -1;
    end;
  end
  else
    Result := -1;
end;

function TReportPersistor.GetNextBlockSize : Integer;
var
  cFileByte : Char;
  ssBlockSize : ShortString;
begin
  ssBlockSize := '';
  while ((not (Eof(HndReportFile))) and (Pos(BLOCK_DELIMITER,ssBlockSize) = 0)) do
  begin
    BlockRead(HndReportFile, cFileByte, 1);
    ssBlockSize := ssBlockSize + cFileByte;
  end;
  ssBlockSize := Copy(ssBlockSize, 1, (Pos(BLOCK_DELIMITER,ssBlockSize) - 1));
  try
    Result := StrToInt(ssBlockSize);
  except on
    E:EConvertError do
      Result := 0;
  end;
end;

procedure TReportPersistor.ReadRegionParams(const pRegionParams : Pointer; const siBlockSize : SmallInt);
var
  pDelimiters : PChar;
begin
  if (siBlockSize > 0) and (assigned(pRegionParams)) then
  begin
    try
      BlockRead(HndReportFile, pRegionParams^, siBlockSize);
    except
      on E:EInOutError do
        ShowMessage('ReadRegionParams() ' + E.Message);
    end;

    pDelimiters := StrAlloc(Length(BLOCK_DELIMITER));
    try
      FillChar(pDelimiters^, Length(BLOCK_DELIMITER), NULL_CHAR);

      try
         BlockRead(HndReportFile, pDelimiters^, Length(BLOCK_DELIMITER));
      except
        on E:EInOutError do
          ShowMessage('ReadRegionParams() ' + E.Message);
      end;
    finally
      StrDispose(pDelimiters);
    end;

  end; // if (siBlockSize > 0) then...
end;

function TReportPersistor.ReadCtrlBlocks(const CtrlBlocks : TList; const siBlockSize : Integer) : Boolean;
var
  pReportBlock : Pointer;
  pDelimiters : PChar;
  siBlockCounter,
  siNumberOfBlocks : SmallInt;
begin
  Result := FALSE;
  if (siBlockSize >= SizeOf(TCtrlParams)) then
  begin
    siNumberOfBlocks := (siBlockSize div SizeOf(TCtrlParams));
    siBlockCounter := 0;

    while (siBlockCounter < siNumberOfBlocks) do
    begin
      // There is no corresponding StrDispose(), cos that messes up the content of the CtrlBlocks TList structure
      GetMem(pReportBlock, SizeOf(TCtrlParams));

      try
        BlockRead(HndReportFile, pReportBlock^, SizeOf(TCtrlParams));
        Inc(siBlockCounter);
      except
        on E:EInOutError do
          ShowMessage('ReadCtrlBlocks() ' + E.Message);
      end;

      if (PCtrlParams(pReportBlock)^.cpCtrlType = REPORT_IMAGE) then
        Result := TRUE;

      CtrlBlocks.Add(pReportBlock);
    end; // while (siBlockCounter < siNumberOfBlocks) do...

    pDelimiters := StrAlloc(Length(BLOCK_DELIMITER));
    try
      FillChar(pDelimiters^, Length(BLOCK_DELIMITER), NULL_CHAR);
      try
        BlockRead(HndReportFile, pDelimiters^, Length(BLOCK_DELIMITER));
      except
        on E:EInOutError do
          ShowMessage('ReadCtrlBlocks() ' + E.Message);
      end;
    finally
      StrDispose(pDelimiters);
    end; // try...finally

  end; // if (siBlockSize >= SizeOf(TCtrlParams)) then...
end;

procedure TReportPersistor.ReadBitMaps(const BitMapImgs : TStringList; const CtrlBlocks : TList);
var
  iBlockSize : Integer;
  siCtrlIdx, siCtrlCount : SmallInt;
  ssBMPFolio : ShortString;
  oRawBMP : TRawBMPStore;
  pDelimiters : PChar;

  function GetBMPFolio : ShortString;
  var
    cFileByte : Char;
    ssFolio : ShortString;
  begin
    ssFolio := '';
    while ((not (Eof(HndReportFile))) and (Pos(BLOCK_DELIMITER,ssFolio) = 0)) do
    begin
      BlockRead(HndReportFile, cFileByte, 1);
      ssFolio := ssFolio + cFileByte;
    end;
    ssFolio := Copy(ssFolio, 1, (Pos(BLOCK_DELIMITER,ssFolio) - 1));

    Result := ssFolio;
  end; // function GetBMPFolio

begin
  if (assigned(CtrlBlocks)) then
  begin
    if (CtrlBlocks.Count > 0) then
    begin
      siCtrlIdx := 0;
      siCtrlCount := (CtrlBlocks.Count - 1);
      while (siCtrlIdx <= siCtrlCount) do
      begin
        if (PCtrlParams(CtrlBlocks.Items[siCtrlIdx])^.cpCtrlType = REPORT_IMAGE) then
        begin
          iBlockSize := GetNextBlockSize;
          if (iBlockSize > 0) then
          begin
            ssBMPFolio := GetBMPFolio;

            oRawBmp := TRawBMPStore.Create;

            oRawBmp.iBMPSize := iBlockSize;
            GetMem(oRawBmp.pBMP, iBlockSize);

            try
              BlockRead(HndReportFile, oRawBMP.pBMP^, oRawBMP.iBMPSize);
              BitMapImgs.AddObject(ssBMPFolio, oRawBMP);
            except on
              E:EInOutError do
                ShowMessage('ReadBitMaps() ' + E.Message);
            end;

            pDelimiters := StrAlloc(Length(BLOCK_DELIMITER));
            try
              FillChar(pDelimiters^, Length(BLOCK_DELIMITER), NULL_CHAR);
              try
                BlockRead(HndReportFile, pDelimiters^, Length(BLOCK_DELIMITER));
              except
                on E:EInOutError do
                  ShowMessage('ReadBitMaps() ' + E.Message);
              end;
            finally
              StrDispose(pDelimiters);
            end;

          end; // if (iBlockSize > 0) then...

          Inc(siCtrlIdx);
        end
        else
          Inc(siCtrlIdx);
      end; // while (siCtrlIdx <= siCtrlCount) do...
    end; // if (siCtrlCount > 0) then...
  end // if (assigned(CtrlBlocks)) then...
  else
  begin
    // just here to more the file reading along....yeah yeah it's a hack :)
    GetNextBlockSize;
  end; // if (assigned(CtrlBlocks)) then...else...
end;

function TReportPersistor.GetRegionParamsByName(const RegionName : ShortString;
                                                var RegionIdx : SmallInt;
                                                const Caller : TCaller = PRINT_CALLER) : PRegionParams;
var
  siRegionIdx : SmallInt;
begin
  siRegionIdx := 0; Result := nil;
  while (siRegionIdx <= (RegionParamList.Count-1)) do
  begin
    if (PRegionParams(RegionParamList.Items[siRegionIdx]).rpRegionName = RegionName) then
    begin
      Result := PRegionParams(RegionParamList.Items[siRegionIdx]);
      RegionIdx := siRegionIdx;
    end;
    Inc(siRegionIdx);
  end;
end;

function TReportPersistor.GetRegionParamsByIdx(const RegionIdx : SmallInt;
                                               const Caller : TCaller = PRINT_CALLER ) : PRegionParams;
begin
  if (RegionIdx < RegionParamList.Count) then
    Result := PRegionParams(RegionParamList.Items[RegionIdx])
  else
    Result := nil;
end;

function TReportPersistor.GetRegionCount : SmallInt;
begin
  Result := RegionParamList.Count;
end;

procedure TReportPersistor.GetReportBlock(const RegionId : SmallInt; const lstReportBlocks : TList);
begin
  if (RegionId <= TList(CtrlBlockList).Count) then
  begin
    if (assigned(CtrlBlockList.Items[RegionId])) then
      lstReportBlocks.Assign(TList(CtrlBlockList.Items[RegionId]))
    else
      lstReportBlocks.Clear;
  end
  else
    lstReportBlocks.Clear;
end;

function TReportPersistor.GetCtrlParams(const RegionId : SmallInt) : PCtrlParams;
//  FCtrlIdx : SmallInt;
//  FRegionIdx : SmallInt;
begin
  if (FRegionIdx <> RegionId) then
  begin // new region so reset back to the start of the ReportCtrl list for that region.
    FCtrlIdx := 0;
    FRegionIdx := RegionId;
  end;

  if (FRegionIdx <= TList(CtrlBlockList).Count) then
  begin
    if (assigned(TList(CtrlBlockList.Items[FRegionIdx]))) then
    begin
      if FCtrlIdx < TList(CtrlBlockList.Items[FRegionIdx]).Count then
        Result := PCtrlParams(TList(CtrlBlockList.Items[FRegionIdx]).Items[FCtrlIdx])
      else
        Result := nil;
    end
    else
      Result := nil;
  end
  else
    Result := nil;

  Inc(FCtrlIdx);
end;

procedure TReportPersistor.GetImageData(const RegionId : SmallInt; const slBMPs : TStringList);
var
  siBMPCount, siBMPIdx : SmallInt;
begin
  if RegionId <= (BitMapList.Count - 1) then
  begin
    if (assigned(BitMapList.Objects[RegionId])) then
    begin
      // look a bit lame, but it has the same effect as TStringList.Assign, but Assign doesn't
      // like the type cast of the BitMapList.Objects, it throws an EConvertError exception
      siBMPCount := (TStringList(BitMapList.Objects[RegionId]).Count - 1);
      for siBMPIdx := 0 to siBMPCount do
      begin
        slBMPs.AddObject(TStringList(BitMapList.Objects[RegionId]).Strings[siBMPIdx],
                         TStringList(BitMapList.Objects[RegionId]).Objects[siBMPIdx]);
      end;
    end
    else
      slBMPs.Clear;
  end
  else
    slBMPs.Clear;
end;

{
procedure TReportPersistor.AddToReportTree;
var
  lBtrvError : LongInt;
  ssKeyS : ShortString;
begin
  lBtrvError := 0;

  ssKeyS := '';
  if (lBtrvError = 0) then
    lBtrvError := Find_Rec(B_GetFirst, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);
  while (lBtrvError = 0) and (ReportTreeRec.ReportName <> FReportName) do
    lBtrvError := Find_Rec(B_GetNext, F[ReportTreeF], ReportTreeF, RecPtr[ReportTreeF]^, TreeParentIDK, ssKeyS);

  if (lBtrvError = 9) then
  begin
    ReportTreeRec.DiskFileName := FFileName;
    ReportTreeRec.ReportName := FReportName;
    ReportTreeRec.ReportDesc := FReportDescription;
    ReportTreeRec.BranchType := 'R';
    ReportTreeRec.ParentID := FullNodeIDKey('0');
    ReportTreeRec.ChildID := FullNodeIDKey('0');
    ReportTreeRec.LastRunDetails := '';

    lBtrvError := Add_Rec(F[ReportTreeF],ReportTreeF,RecPtr[ReportTreeF]^,TreeParentIDK);
  end;
end;
}

procedure TReportPersistor.SetReportFileName(const ssReportFileName : ShortString);
var
  ssFileName : ShortString;
  siIdx : Integer;
begin
  // removes illegal characters from the report file name.
  ssFileName := ssReportFileName; siIdx := 1;
  while (Length(ssFileName) > 0) and (siIdx <= Length(ssFileName)) do
    if ssFileName[siIdx] in ['<','>',':','"','/','\'] then
      Delete(ssFileName, siIdx, 1)
    else
      Inc(siIdx);
  FFileName := ssFileName;
end;

end.
