unit DragStk;

{ prutherford440 09:50 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Forms;

var
  CancelExport : boolean;

procedure DoDragnetStockExport;

implementation

uses
  UseDLLU, SysUtils, IOUtil, {EBusUtil,} Base36, Classes, EBusVar,{ EBusBtrv,}
  CommsInt, ExptProg, Controls, eBusCnst, StrUtil, DragUtil,FileUtil,
  Dialogs; // For ShowMessage

{$I EXCHDLL.INC}
{$I EXDLLBT.INC}

const
  StockF = 5;

  CATDESC_NAME = 'CatDesc.txt';
  CATTREE_NAME = 'CatTree.txt';
  CATIDX_NAME = 'CatIdx.txt';
  MAINCAT_NAME = 'MainCat.txt';
  STOCKITM_NAME = 'StockItm.txt';
  CATALOG_NAME = 'Catalog.txt';

type
  {$I ExDLLBG.INC}
  PBatchSKRec = ^TBatchSKRec;
  TStockLevelCodes = array[1..7] of string[4];

  TMainCatInfo = class
    private
      fDepth : byte;
      fCataloguesUsedIn : TCharSet;
      procedure SetDepth(Value : byte);
      procedure SetCataloguesUsedIn(Value : TCharSet);
    public
      property Depth : byte read fDepth write SetDepth;
      property CataloguesUsedIn : TCharSet read fCataloguesUsedIn write SetCataloguesUsedIn;
      class function StringToCharSet(const s : string) : TCharSet;
      class function CharSetToString(cs : TCharSet) : string;
      constructor Create(SetDepth : byte; SetCataloguesUsedIn : string);
  end;

  TDragNetStockExport = class
    private
      CatTree  : TFileExport;
      CatDesc  : TFileExport;
      CatIdx   : TFileExport;
      MainCat  : TFileExport;
      StockItm : TFileExport;

      Publisher : string[8];
      Password  : string[20];
      AdminEmail : string[100];
      CompanyCode : char;
      CatalogueID : char;
      CataloguesEnabled : boolean;        // Whether to bother with catalogues at all
      ExportDir : string;
      StockLevelCodes : TStockLevelCodes; // Stock group folios stored as base 36
      lstTopLevelStockGroups : TStringList;
      frmExportProgress : TfrmExportProgress;
      bIgnoreWebInclude : boolean;

      procedure WriteCatDescLine(Folio : longint; Description : array of shortstring);
      procedure WriteCatTreeLine;
      procedure WriteCatIdxLine(StockCode : shortstring);
      procedure WriteMainCatLine(FolioCode : shortstring; Info : TMainCatInfo;
        const Description : string);
      procedure WriteStockItmLine(TopStockLevelGroup : shortstring; StockRec : PBatchSKRec);
      procedure UpdateTopLevelStockGroups(TopStockLevelGroup : shortstring; Depth : byte;
        CataloguesUsedIn : string);
      procedure ProcessStockTree(SearchCode : TCharArray255; Depth : byte);
      procedure ExportMainCat;
      procedure ExportCatalog;
      procedure InitialiseExports;
      procedure FinaliseExports;
      procedure ReadDragNetSettings;
      procedure CreateStockZipFile;
      procedure CleanUpAfterCancel;
      function  ExportThisStockItem(StockRec : PBatchSKRec) : boolean;
      function  AssignExportFileList : TStringList;
      function EncodeAsBase36(LongNum : LongInt) : shortstring;
      function DecodeFromBase36(Base36Str : shortstring) : longint;
    public
      procedure ExportStockInfo;
      constructor Create(CatalogueCode : char; CataloguesUsed : boolean);
  end; // TDragNetStockExport

//-----------------------------------------------------------------------

function Ex_BtrieveFindRec(P      : pointer;
                           PSize  : longint) : smallint;
                           stdcall external 'ENTDLL32.DLL' index 101;

//-----------------------------------------------------------------------

function Ex_BtrieveGetPos(FileNum      : smallint;
                          var Position : longint) : smallint;
                          stdcall external 'ENTDLL32.DLL' index 102;

//-----------------------------------------------------------------------

function Ex_BtrieveSetPos(FileNum    : smallint;
                          Position   : longint;
                          SearchPath : smallint) : smallint;
                          stdcall external 'ENTDLL32.DLL' index 103;

//-----------------------------------------------------------------------

function Ex_BtrieveRecCount(FileNum : smallint;
                            var RecCount : longint) : smallint;
                            stdcall external 'ENTDLL32.DLL' index 124;

//-----------------------------------------------------------------------

function ConCatDesc(DescLines : array of shortstring) : string;
var
  i : integer;
begin
  Result := '';
  for i := 0 to High(DescLines) do
    Result := Result + Trim(DescLines[i]) + ' ';
  Result := TrimRight(Result);
end; // ConCatDesc

//=======================================================================

constructor TMainCatInfo.Create(SetDepth : byte; SetCataloguesUsedIn : string);
begin
  inherited Create;
  Depth := SetDepth;
  CataloguesUsedIn := [];
  CataloguesUsedIn := StringToCharSet(SetCataloguesUsedIn);
end;

//-----------------------------------------------------------------------

procedure TMainCatInfo.SetDepth(Value : byte);
begin
  fDepth := Value;
end;

//-----------------------------------------------------------------------

procedure TMainCatInfo.SetCataloguesUsedIn(Value : TCharSet);
begin
  fCataloguesUsedIn := Value;
end;

//-----------------------------------------------------------------------

class function TMainCatInfo.StringToCharSet(const s : string) : TCharSet;
var
  i : integer;
begin
  Result := [];
  for i := 1 to length(s) do
    if s[i] in ALLOWED_DNET_CAT_CODES then
      Include(Result, s[i]);
end; // TMainCatInfo.StringToCharSet

//-----------------------------------------------------------------------

class function TMainCatInfo.CharSetToString(cs : TCharSet) : string;
var
  ch : char;
begin
  Result := '';
  for ch := low(char) to high(char) do
    if ch in cs then
      Result := Result + ch;
end;

//=======================================================================

constructor TDragNetStockExport.Create(CatalogueCode : char; CataloguesUsed : boolean);
begin
  inherited Create;
  CatalogueID := CatalogueCode;
  CataloguesEnabled := CataloguesUsed;

{************************************ READ FROM BTRIEVE FILE ****************************************}
  bIgnoreWebInclude := TRUE;
end;

//-----------------------------------------------------------------------

procedure TDragNetStockExport.WriteCatDescLine(Folio : longint;
            Description : array of shortstring);
begin
  with CatDesc do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CatalogueID,1);
    WriteString(EncodeAsBase36(Folio),4);
    WriteString(ConCatDesc(Description),40);
    NewLine;
  end;
end; // TDragNetStockExport.WriteCatDescLine

//-----------------------------------------------------------------------

procedure TDragNetStockExport.WriteCatTreeLine;
var
  i : byte;
begin
  with CatTree do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CatalogueID,1);
    for i := 1 to 7 do
      WriteString(StockLevelCodes[i],4);
    NewLine;
  end;
end; // TDragNetStockExport.WriteCatTreeLine

//-----------------------------------------------------------------------

procedure TDragNetStockExport.WriteCatIdxLine(StockCode : shortstring);
var
  i : byte;
begin
  with CatIdx do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CatalogueID,1);
    for i := 1 to 7 do
      WriteString(StockLevelCodes[i],4);
    WriteString(StockCode,16);
    NewLine;
  end;
end; // TDragNetStockExport.WriteCatIdxLine

//-----------------------------------------------------------------------

procedure TDragNetStockExport.WriteStockItmLine(TopStockLevelGroup : shortstring;
            StockRec : PBatchSKRec);
var
  i : byte;
  DecimalFactor : char;
begin
  with StockItm, StockRec^ do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CatalogueID,1);
    WriteString(StockCode,16);
    WriteString(TopStockLevelGroup,4);
    for i := 1 to 4 do
      WriteBlank(15); // Search keys in export but not in use
    WriteString(AltCode,16);
    WriteBlank(16);   // 2nd alternate code
    WriteString(Desc[1],40);
    WriteString(ConcatDesc([Desc[1],Desc[2],Desc[3],Desc[4],Desc[5]]),215);
    WriteNum(SaleBands[1].SalesPrice * 100,9,0);  // Selling price band A
    WriteBlank(9);         // Sale price
    WriteBlank(19);        // Sale start date
    WriteBlank(19);        // Sale end date
    WriteBlank(9);         // Next price
    WriteBlank(19);        // Next price start
    WriteBlank(4);         // Discount code
    WriteString(BooleanAs01(false),1); // Settlement discount
    WriteString(BooleanAs01(false),1); // Line discount
    WriteString(BooleanAs01(false),1); // Overall discount
    WriteString(BooleanAs01(false),1); // Settlement discount for sale items
    WriteString(BooleanAs01(false),1); // Overall discount for sale items
    WriteString(BooleanAs01(false),1); // Line discount for sale items
    WriteString(BooleanAs01(false),1); // Sale price overrides discount
    WriteString(VATCode,1);
    WriteNum(SWeight,7,2); // Sales unit weight
    WriteBlank(16);        // Superceding stock code
    WriteBlank(19);        // Date supercedes
    WriteString(UnitS,8);  // Descriptive selling unit quantity
    if trunc(SellUnit) = 1 then
      DecimalFactor := 'D'
    else
      DecimalFactor := 'F';
    WriteString(DecimalFactor,1); // Decimal or factor
    WriteNum(2,2,0);       // D.P. for non factored items - Enterprise system set-up ???
    WriteNum(2,2,0);       // Price D.P. - Enterprise system set-up ???
    WriteString(BooleanAs01(true),1);  // Item type, true => stock item
    WriteNum(round(SellUnit),9,0); // Issue quantity ???
    WriteNum(round(SellUnit),6,0); // Factor quantity ???
    WriteString(BooleanAs01(false),1);  // Split pack
    WriteBlank(6);    // Split pack surcharge
    WriteBlank(11);   // Quantity ordered to date
    WriteBlank(19);   // Date last ordered
    NewLine;
  end; // with
end; // TDragNetStockExport.WriteStockItmLine

//-----------------------------------------------------------------------

function TDragNetStockExport.ExportThisStockItem(StockRec : PBatchSKRec) : boolean;
begin
  with StockRec^ do
  begin
    Result := (WebInclude > 0) or bIgnoreWebInclude;
    if Result and CataloguesEnabled then
      Result := Pos(CatalogueID, WebLiveCat) > 0;
  end;
end; // TDragNetStockExport.ExportThisStockItem

//-----------------------------------------------------------------------

procedure TDragNetStockExport.ProcessStockTree(SearchCode : TCharArray255; Depth : byte);
// SearchPath : 0 Stock Code
//              1 Stock Folio Number
//              2 Stock Group
var
  StockRec : PBatchSKRec;
  Status : integer;
  Position : longint;
  TempSearchCode : TCharArray255;
  CurGroup : string;
begin
  new(StockRec);
  // Find record in stock file
  Status := Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 2, B_GetGEq, false);
  CurGroup := StockRec^.StockCat;

  Application.ProcessMessages;

  // Check we're processing same stock group code
  while (Status = 0) and (Trim(StockRec^.StockCat) = Trim(CurGroup)) and not CancelExport do
  begin
    // Depth checking ?????
    with StockRec^ do
      if StockType = 'G' then
      begin
        if not CancelExport then
          frmExportProgress.IncProgressCounter;
        StockLevelCodes[Depth] := EncodeAsBase36(StockFolio);
        WriteCatTreeLine;
        WriteCatDescLine(StockFolio,[Desc[1],Desc[2],Desc[3],Desc[4],Desc[5]]);

        // Store Btrieve position
        Ex_BtrieveGetPos(StockF, Position);

        // Recurse down a level
        FillChar(TempSearchCode, SizeOf(TempSearchCode), #0);
        Move(StockCode[1], TempSearchCode, length(StockCode));
        inc(Depth);
        ProcessStockTree(TempSearchCode, Depth);

        // Restore Btrieve position - moved back up a level
        Ex_BtrieveSetPos(StockF, Position, 2);
        StockLevelCodes[Depth] := StringOfChar(' ',4);
        dec(Depth);
      end
      else
      begin // Not a group => stock item, BOM etc - need to exclude some ???
        Application.ProcessMessages;
        if not CancelExport then
          frmExportProgress.IncProgressCounter;
        if ExportThisStockItem(StockRec) then
        begin
          WriteCatIdxLine(StockCode);
          WriteStockItmLine(StockLevelCodes[1], StockRec);

          // Need to call at the stock item level to find out how deep this branch is
          UpdateTopLevelStockGroups(StockLevelCodes[1], Depth-1, StockRec^.WebLiveCat);
        end;
      end;
    Status := Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 2, B_GetNext, false);
  end; // while

  dispose(StockRec);
end; // TDragNetStockExport.ProcessStockTree

//-----------------------------------------------------------------------

procedure TDragNetStockExport.UpdateTopLevelStockGroups(TopStockLevelGroup : shortstring;
            Depth : byte; CataloguesUsedIn : string);
// Notes : MainCat export shows all the top level stock groups along with their maximum
//         depth.  This depth can vary depending on the branch in the stock tree.
var
{  CurDepth : byte;}
  Posn : integer;
  MainCatInfo : TMainCatInfo;
begin
  with lstTopLevelStockGroups do
  begin
    Posn := IndexOf(TopStockLevelGroup);
    if Posn >= 0 then
    begin
      MainCatInfo := TMainCatInfo(Objects[Posn]);
      if Depth > MainCatInfo.Depth then
        MainCatInfo.Depth := Depth;
      MainCatInfo.CataloguesUsedIn := MainCatInfo.CataloguesUsedIn +
        TMainCatInfo.StringToCharSet(CataloguesUsedIn);
    end
    else
    begin
      MainCatInfo := TMainCatInfo.Create(Depth, CataloguesUsedIn);
      AddObject(StockLevelCodes[1], MainCatInfo);
    end;
  end;
end; // TDragNetStockExport.UpdateTopLevelStockGroups

//-----------------------------------------------------------------------

procedure TDragNetStockExport.WriteMainCatLine(FolioCode : shortstring;
   Info : TMainCatInfo; const Description : string);
begin
  with MainCat do
  begin
    WriteString(Publisher,8);
    WriteString(CompanyCode,1);
    WriteString(CatalogueID,1);
    WriteString(FolioCode,4);
    WriteString(IntToStr(Info.Depth),1);
    WriteString(copy(Description,1,40),40);
    // Catalogues this category appears in
    WriteString(TMainCatInfo.CharSetToString(Info.CataloguesUsedIn),35);
    WriteString(BooleanAs01(false),1);  // Memo field used for stock description
    WriteString(BooleanAs01(true),1);   // Extended description used for stock description
    WriteString(BooleanAs01(false),1);  // Short description used for stock description
    NewLine;
  end;
end; // TDragNetStockExport.WriteMainCatLine

//-----------------------------------------------------------------------

procedure TDragNetStockExport.ExportMainCat;
var
  StockRec : ^TBatchSKRec;
  i : integer;
  CurFolio : longint;
  SearchCode : array[0..255] of char;
  Description : string;
begin
  new(StockRec);
  with lstTopLevelStockGroups do
    for i := 0 to Count -1 do
    begin
      CurFolio := DecodeFromBase36(Strings[i]);
      System.Move(CurFolio, SearchCode, SizeOf(CurFolio));
      Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 1, B_GetEq, false);

      with StockRec^ do
        Description := ConcatDesc([Desc[1],Desc[2],Desc[3],Desc[4],Desc[5]]);
      WriteMainCatLine(Strings[i], TMainCatInfo(Objects[i]), Description);
    end;
  dispose(StockRec);
end; // TDragNetStockExport.ExportMainCat

//-----------------------------------------------------------------------

procedure TDragNetStockExport.ExportCatalog;
var
  Params : TEBusCatalogue;

  procedure ReadCatalogueSettings;
  begin
{    if not CataloguesEnabled or not
      ((ReadNoLockEBusLevel2(Params, EBUS_DRAGNET, EBUS_COMPANY, EBUS_CATALOGUE,
        EBusParams.CurCompCode, CatalogueID)) = 0) then
    begin // Apply suitable defaults ...}
      Params.CatTitle := 'Standard Catalogue';
      Params.CatCreditLimitApplies := true;
      Params.CatOnHoldApplies := true;
{    end;}
  end; // ReadCatalogueSettings;

begin
  with TFileExport.Create(ExportDir + CATALOG_NAME) do
    try
      ReadCatalogueSettings;
      WriteString(Publisher,8);
      WriteString(CompanyCode,1);
      WriteString(CatalogueID,1);
      WriteString(Params.CatTitle,60);  // Catalogue title - from E-Business set-up
      WriteString(BooleanAs01(true),1);      // Line discount - TRUE
      WriteString(BooleanAs01(false),1);     // Overall discount - FALSE
      WriteString(BooleanAs01(true),1);      // Settlement discount - TRUE
      WriteString(BooleanAs01(false),1);     // Special prices - FALSE
      // Customers on hold can order ? E-Business set-up
      WriteString(BooleanAs01(Params.CatOnHoldApplies),1);
      // Customers over credit limit can order E-Business set-up
      WriteString(BooleanAs01(Params.CatCreditLimitApplies),1);
      WriteString(BooleanAs01(true),1);      // Account customers allowed - TRUE
      NewLine;
    finally
      Free;
    end;
end; // TDragNetStockExport.ExportCatalog

//-----------------------------------------------------------------------

procedure TDragNetStockExport.ReadDragNetSettings;
{var
  Params : TEBusDragNetCat;}
begin
{  ReadEBusinessParams(Params, EBUS_DRAGNET, false);
  with Params^ do
  begin
    Publisher := DNetPublisherCode;
    Password := DNetPublisherPassword;
    ExportDir := AddBackSlash(DNetExportDirectory);
    AdminEmail := DNetAdminEmailAddress;
  end;
  GetDragNetCompCode(EBusParams.CurCompCode, CompanyCode);}

{************************************ READ IN FROM BTRIEVE FILES *************************************}
  Publisher := 'XCHEQUER';
  Password := 'PASSWORD';
  ExportDir := 'C:\DRAGNET\';
  AdminEmail := 'nfrewer@exchequer.com';

  CompanyCode := 'A';
{************************************ READ IN FROM BTRIEVE FILES *************************************}

end; // TDragNetStockExport.ReadDragNetSettings

//-----------------------------------------------------------------------

procedure TDragNetStockExport.InitialiseExports;
begin
  ReadDragNetSettings;

  CatDesc := TFileExport.Create(ExportDir + CATDESC_NAME);
  CatTree := TFileExport.Create(ExportDir + CATTREE_NAME);
  CatIdx := TFileExport.Create(ExportDir + CATIDX_NAME);
  MainCat := TFileExport.Create(ExportDir + MAINCAT_NAME);
  StockItm := TFileExport.Create(ExportDir + STOCKITM_NAME);
  lstTopLevelStockGroups := TStringList.Create;
end; // TDragNetStockExport.InitialiseExports

//-----------------------------------------------------------------------

procedure TDragNetStockExport.ExportStockInfo;
var
  i : byte;
  RecCount : longint;
begin
  try
    frmExportProgress := TfrmExportProgress.Create(nil);
    try
      frmExportProgress.CatalogueCode := CatalogueID;
      frmExportProgress.Show;
      InitialiseExports;
      frmExportProgress.ProgressMsg := 'Processing ... ' + CATALOG_NAME;
      ExportCatalog;
      for i := Low(StockLevelCodes) to High(StockLevelCodes) do
        StockLevelCodes[i] := StringOfChar(' ', 4);

      frmExportProgress.ProgressMsg := 'Processing ... Stock tree';
      Ex_BtrieveRecCount(StockF, RecCount);
      frmExportProgress.TotalRecCount := RecCount;

      ProcessStockTree('', 1);

      frmExportProgress.ProgressMsg := 'Processing ... ' + MAINCAT_NAME;
      ExportMainCat;
      if not WriteDragNetIDFile(ExportDir, Publisher, Password, CompanyCode, CatalogueID,
                                  AdminEmail, dntStock) then ; // raise error

    except
      on E:EInOutError do
        MessageDlg('The Dr@gNet stock exports have failed with error code ' +
          IntToStr(E.ErrorCode), mtError, [mbOK], 0);
    end;
  finally
    FinaliseExports;
  end;
end; // TDragNetStockExport.ExportStockInfo

//-----------------------------------------------------------------------

procedure TDragNetStockExport.FinaliseExports;
var
  i : integer;
begin
  CatDesc.Free;
  CatTree.Free;
  CatIdx.Free;
  MainCat.Free;
  StockItm.Free;
  with lstTopLevelStockGroups do
  begin
    for i := 0 to Count - 1 do
      TMainCatInfo(Objects[i]).Free;
    Free;
  end;
end; // TDragNetStockExport.Destroy

//-----------------------------------------------------------------------

function TDragNetStockExport.AssignExportFileList : TStringList;
// Notes : Calling code needs to Free the returned string list
begin
  Result := TStringList.Create;
  with Result do
  begin
    Add(ExportDir + CATDESC_NAME);
    Add(ExportDir + CATTREE_NAME);
    Add(ExportDir + CATIDX_NAME);
    Add(ExportDir + MAINCAT_NAME);
    Add(ExportDir + STOCKITM_NAME);
    Add(ExportDir + CATALOG_NAME);
    Add(ExportDir + 'ID.TXT');
  end;
end; // TDragNetStockExport.AssignExportFileList

//-----------------------------------------------------------------------

procedure TDragNetStockExport.CreateStockZipFile;
var
{  Result : smallint;}
  ZipFileList : TStringList;
begin
  with TEntZip.Create do
  try
    frmExportProgress.ProgressMsg := 'Compressing data files ... this may take a while';
    ZipFileList := AssignExportFileList;
    Files.Assign(ZipFileList);

    ZipName := ExportDir + 'CAT_' + CompanyCode + CatalogueID + '.ZIP';
    OverwriteExisting := true;
    StripDrive := true;
    StripPath := true;
    { Return values ...  0=OK, 1=no files to compress, 2=failed to delete existing .ZIP file }
    {                    3=DLL Not Found, }
    // Not possible to get progress of zip at moment - callbacks available
    // from Abbrevia code but not implemented in Entcomms.dll
{    Result := }Save;
    DeleteFiles(ZipFileList);
    ZipFileList.Free;
  finally
    Free;
  end;
end; // TDragNetStockExport.CreateStockZipFile

//-----------------------------------------------------------------------

procedure TDragNetStockExport.CleanUpAfterCancel;
var
  DelFileList : TStringList;
begin
  DelFileList := AssignExportFileList;
  DeleteFiles(DelFileList);
  DelFileList.Free;
end;

//-----------------------------------------------------------------------

function TDragNetStockExport.EncodeAsBase36(LongNum : LongInt) : shortstring;
var
  Value : shortstring;
begin
  Result := StringOfChar(' ',4);
  if Encode36(LongNum, Value) then
    Result := Value;
end;

//-----------------------------------------------------------------------

function TDragNetStockExport.DecodeFromBase36(Base36Str : shortstring) : longint;
var
  Value : longint;
begin
  Result := -1;
  if Decode36(Base36Str, Value) then
    Result := Value
end;

//=======================================================================

type
  TDragNetStockExportControl = class
    private
      fCataloguesSelected : TOpenCharArray;
      fCataloguesEnabled,
      fFinishStockExports : boolean;
    protected
      procedure CheckForCatalogues;
      procedure SelectCatalogues;
      procedure ProcessOneExport(CatalogueCode : char);
    public
      constructor Create;
      procedure   DoDragnetStockExport;
  end;

//-----------------------------------------------------------------------

constructor TDragNetStockExportControl.Create;
begin
  inherited Create;
  fFinishStockExports := false;
end;

//-----------------------------------------------------------------------

procedure TDragNetStockExportControl.CheckForCatalogues;
{var
  Params : TEBusDragNetCompany;}
begin

{************************************ READ FROM BTREIVE FILE ****************************************

  ReadNoLockEBusLevel1(Params, EBUS_DRAGNET, EBUS_COMPANY, EBusParams.CurCompCode);
  fCataloguesEnabled := Params^.DNetUseCatalogues;

************************************ READ FROM BTREIVE FILE ****************************************}

  fCataloguesEnabled := TRUE;
end;

//-----------------------------------------------------------------------

procedure TDragNetStockExportControl.SelectCatalogues;
begin
  SetLength(fCataloguesSelected, 1);
  // If no catalogues at all, 'A' becomes the single default
  fCataloguesSelected[0] := 'A';

{  if not fCataloguesEnabled then
  begin
    SetLength(fCataloguesSelected, 1);
    // If no catalogues at all, 'A' becomes the single default
    fCataloguesSelected[0] := 'A';
  end
  else
  begin
    with TfrmCataloguesSelect.Create(nil) do
    try
      SetLength(fCataloguesSelected,0);
      if ShowModal = mrOK then
        GetCatalogueCodeList(fCataloguesSelected);
    finally
      Release;
    end;
  end;}
end;

//-----------------------------------------------------------------------

procedure TDragNetStockExportControl.DoDragnetStockExport;
{var
  CatNum : integer;}
begin
  SelectCatalogues;
  ProcessOneExport(fCataloguesSelected[0]);

{  if EBusParams.ACompanyActive(true) then
  begin
    CheckForCatalogues;
    SelectCatalogues;
    CatNum := 0;
    while (CatNum < length(fCataloguesSelected)) and not fFinishStockExports do
    begin
      ProcessOneExport(fCataloguesSelected[CatNum]);
      inc(CatNum);
    end;
  end;}
end;

//-----------------------------------------------------------------------

procedure TDragNetStockExportControl.ProcessOneExport(CatalogueCode : char);
begin
  with TDragNetStockExport.Create(CatalogueCode, fCataloguesEnabled) do
  try
    ExportStockInfo;
    if not CancelExport then
    begin
      CreateStockZipFile;
      frmExportProgress.Close;
    end
    else
    begin
      CleanUpAfterCancel;
      fFinishStockExports := true;
    end;
  finally
    Free;
  end;
end; // TDragNetStockExportControl.ProcessOneExport

//-----------------------------------------------------------------------

procedure DoDragnetStockExport;
var
  Status : integer;
begin
  Status := Ex_InitDLL;
  if Status <> 0 then
    ShowMessage('Ex_InitDLL = ' + IntToStr(Status))
  else
    with TDragNetStockExportControl.Create do
    try
      DoDragnetStockExport;
    finally
      Free;
      Ex_CloseDLL;
    end;
end;

end.


