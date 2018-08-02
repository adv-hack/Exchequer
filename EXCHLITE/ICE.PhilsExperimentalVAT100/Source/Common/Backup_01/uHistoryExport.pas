unit uHistoryExport;
{
  Backup version.
  
  This is the version as it was before it was decided to do the History by
  collecting all the history records up to the start of the year containing
  the drip-feed period and then summarising an opening balance for any
  remaining periods up to the drip-feed period.
  
  This original version instead collects all history records up to the start
  of the drip-feed period, and calculates the year to date figures for the
  periods in the year up to the start of the drip-feed period.
}
interface

uses
  Classes, SysUtils, ComObj, Controls, Variants, Forms,
  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
  ComnUnit,
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uExportBaseClass,
  uXMLFileManager,
  uXMLWriter
  ;

{$I ice.inc}

type
  {
    YTD Totalling:
    Because a drip-feed period could be for part of a year, and the opening
    balance needs to be correct up to the end of the period immediately
    preceding the drip-feed period, the Year-To-Date figures must be
    recalculated to only include the preceding periods.

    The system assumes that for every set of records of a given Class, Code,
    and Currency, the set will *always* end with a YTD (254 or 255) record. It
    further assumes that the records are processed in ascending Class, Code,
    and Currency order.
  }

  { Record for recording YTD totals. }
  TYTDRec = record
    InUse: Boolean;
    Code: Str20;
    ExClass: Char;
    Cr: Byte;
    Yr: Byte;
    Pr: Byte;
    Sales: Double;
    Purchases: Double;
    Budget: Double;
    Cleared: Double;
    Budget2: Double;
    Value1: Double;
    Value2: Double;
    Value3: Double;
  end;
  TYTDArray = array of TYTDRec;

  THistoryExport = class(_ExportBase)
  private
    fFromDate: TDateTime;
    fToDate: TDateTime;
    FileManager: TXMLFileManager;
    XMLWriter: TXMLWriter;
    fEndPeriod: Integer;
    fStartPeriod: Integer;

    { YTD tracking }
    YTDRec: TYTDRec;
    IsYTDRecord: Boolean;
    AutoRetained: TYTDArray;
    PLHeaders: TYTDArray;

    TraceLines: TStringList;

    function BuildRecord: Boolean;
    procedure SetFromDate(const Value: TDateTime);
    procedure SetToDate(const Value: TDateTime);

    { YTD tracking }
    procedure ClearYTD;
    function OpenGLStructure: LongInt;
    procedure UpdateYTD;
    procedure UpdateAutoRetained;
    procedure CopyAutoRetainToYTD;
    procedure ReadPLParentRecords(StartYear, EndYear: Byte);

    procedure Trace(Msg: string; Full: Boolean = False; TraceYTD: Boolean = False);
    procedure WriteTrace;

  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
    property FromDate: TDateTime read fFromDate write SetFromDate;
    property ToDate: TDateTime read fToDate write SetToDate;
    property StartPeriod: Integer read fStartPeriod write fStartPeriod;
    property EndPeriod: Integer read fEndPeriod write fEndPeriod;
  end;

implementation

uses BtKeys1U, ETStrU, SavePos;

// =============================================================================
// THistoryExport
// =============================================================================

function THistoryExport.BuildRecord: Boolean;

  function StringToHexString(const s : ShortString) : string;
  var
    i : longint;
  begin
    Result := '';
    for i := 1 to Length(s) do
    begin
      Result := Result + IntToHex(Ord(s[i]), 2);
    end;
  end;

begin
  Result := False;
  XMLWriter.AddOpeningTag('histrec');
  try
    if IsYTDRecord then
    begin
      { Use YTDRec to populate XML record }
      XMLWriter.AddLeafTag('nhcode',      StringToHexString(YTDRec.Code));
      XMLWriter.AddLeafTag('nhexclass',   Ord(YTDRec.ExCLass));
      XMLWriter.AddLeafTag('nhcr',        YTDRec.Cr);
      XMLWriter.AddLeafTag('nhyr',        YTDRec.Yr);
      XMLWriter.AddLeafTag('nhpr',        YTDRec.Pr);
      XMLWriter.AddLeafTag('nhsales',     FormatFloat('0.0000', YTDRec.Sales));
      XMLWriter.AddLeafTag('nhpurchases', FormatFloat('0.0000', YTDRec.Purchases));
      XMLWriter.AddLeafTag('nhbudget',    FormatFloat('0.0000', YTDRec.Budget));
      XMLWriter.AddLeafTag('nhcleared',   FormatFloat('0.0000', YTDRec.Cleared));
      XMLWriter.AddLeafTag('nhbudget2',   FormatFloat('0.0000', YTDRec.Budget2));
      XMLWriter.AddLeafTag('nhvalue1',    FormatFloat('0.0000', YTDRec.Value1));
      XMLWriter.AddLeafTag('nhvalue2',    FormatFloat('0.0000', YTDRec.Value2));
      XMLWriter.AddLeafTag('nhvalue3',    FormatFloat('0.0000', YTDRec.Value3));
      ClearYTD;
    end
    else
    begin
      { Use current NHist record to populate XML record }
      XMLWriter.AddLeafTag('nhcode',      StringToHexString(NHist.Code));
      XMLWriter.AddLeafTag('nhexclass',   Ord(NHist.ExCLass));
      XMLWriter.AddLeafTag('nhcr',        NHist.Cr);
      XMLWriter.AddLeafTag('nhyr',        NHist.Yr);
      XMLWriter.AddLeafTag('nhpr',        NHist.Pr);
      XMLWriter.AddLeafTag('nhsales',     FormatFloat('0.0000', NHist.Sales));
      XMLWriter.AddLeafTag('nhpurchases', FormatFloat('0.0000', NHist.Purchases));
      XMLWriter.AddLeafTag('nhbudget',    FormatFloat('0.0000', NHist.Budget));
      XMLWriter.AddLeafTag('nhcleared',   FormatFloat('0.0000', NHist.Cleared));
      XMLWriter.AddLeafTag('nhbudget2',   FormatFloat('0.0000', NHist.Budget2));
      XMLWriter.AddLeafTag('nhvalue1',    FormatFloat('0.0000', NHist.Value1));
      XMLWriter.AddLeafTag('nhvalue2',    FormatFloat('0.0000', NHist.Value2));
      XMLWriter.AddLeafTag('nhvalue3',    FormatFloat('0.0000', NHist.Value3));
    end;

    Result := True;

  except
    on e:Exception do
      DoLogMessage('THistoryExport.BuildHeaderRecord',
                   cBUILDINGXMLERROR,
                   'Error: ' + e.message);
  end;
  XMLWriter.AddClosingTag('histrec');
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.ClearYTD;
begin
  FillChar(YTDRec, SizeOf(YTDRec), 0);
  YTDRec.InUse := False
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.CopyAutoRetainToYTD;
var
  Entry: Integer;
  Found: Boolean;
  Rec: TYTDRec;
begin
  { Find the array entry matching the current currency. }
  Found := False;
  for Entry := Low(AutoRetained) to High(AutoRetained) do
  begin
    if AutoRetained[Entry].Cr = NHist.Cr then
    begin
      Found := True;
      Rec := AutoRetained[Entry];
      Break;
    end;
  end;
  if Found then
  begin
    YTDRec.Code      := NHist.Code;
    YTDRec.ExClass   := NHist.ExCLass;
    YTDRec.Cr        := NHist.Cr;
    YTDRec.Yr        := NHist.Yr;
    YTDRec.Pr        := NHist.Pr;
    YTDRec.Sales     := Rec.Sales;
    YTDRec.Purchases := Rec.Purchases;
    YTDRec.Budget    := Rec.Budget;
    YTDRec.Budget2   := Rec.Budget2;
    YTDRec.Value1    := Rec.Value1;
    YTDRec.Value2    := Rec.Value2;
    YTDRec.Value3    := Rec.Value3;
  end;

  { Now find the parent P&L records, and update those as well. }
  for Entry := Low(PLHeaders) to High(PLHeaders) do
  begin
    if (PLHeaders[Entry].Cr = NHist.Cr) and
       (PLHeaders[Entry].Yr = NHist.Yr) then
    begin
      { Subtract the original AutoRetained values from the parent record,
        and add the recalculated AutoRetained values. }
      Rec := PLHeaders[Entry];
      Rec.Sales     := Rec.Sales     - NHist.Sales     + YTDRec.Sales;
      Rec.Purchases := Rec.Purchases - NHist.Purchases + YTDRec.Purchases;
      Rec.Budget    := Rec.Budget    - NHist.Budget    + YTDRec.Budget;
      Rec.Budget2   := Rec.Budget2   - NHist.Budget2   + YTDRec.Budget2;
      Rec.Value1    := Rec.Value1    - NHist.Value1    + YTDRec.Value1;
      Rec.Value2    := Rec.Value2    - NHist.Value2    + YTDRec.Value2;
      Rec.Value3    := Rec.Value3    - NHist.Value3    + YTDRec.Value3;
      PLHeaders[Entry] := Rec;
    end;
  end;

end;

// -----------------------------------------------------------------------------

constructor THistoryExport.Create;
begin
  inherited Create;
  UseFiles := True;
  FileManager := TXMLFileManager.Create;
  FileManager.BaseFileName := 'his';
  XMLWriter := TXMLWriter.Create;
  XMLWriter.NameSpace := 'hist';
  TraceLines := TStringList.Create;
end;

// -----------------------------------------------------------------------------

destructor THistoryExport.Destroy;
begin
  TraceLines.Clear;
  Close_File(F[SysF]);
  Close_File(F[NomF]);
  Close_File(F[NHistF]);
  FileManager.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

function THistoryExport.LoadFromDB: Boolean;
var
  Res : Integer;
  Key : string[255];
  FileName: string;

  CurrentCode : string[20];
  CurrentCurr : Byte;
  GLCodeChanged: Boolean;
  XMLFileOpen: Boolean;

  Entry: Integer;
  NomCode: LongInt;
  IsPartYear: Boolean;

  // ...........................................................................
  function IsCCDept: Boolean;
  begin
    Result := (NHist.Code[7] > #32) or (NHist.Code[8] > #32);
  end;
  // ...........................................................................
  function IsHeaderForAutoRetained: Boolean;
  var
    Entry: Integer;
    HistCode: LongInt;
    HeaderCode: LongInt;
  begin
    Result := False;
    for Entry := Low(PLHeaders) to High(PLHeaders) do
    begin
      Move(PLHeaders[Entry].Code[1], HeaderCode, SizeOf(HeaderCode));
      Move(NHist.Code[1], HistCode, SizeOf(HistCode));
      if (HeaderCode = HistCode) and
         (PLHeaders[Entry].Cr = NHist.Cr) and
         (PLHeaders[Entry].Yr = NHist.Yr) then
      begin
        Result := True;
        Break;
      end;
    end;
  end;
  // ...........................................................................
  function WantGLHistory: Boolean;
  var
    YearPeriodCheck: LongInt;
    YearCheck: LongInt;
  begin
    { Set the period/year as (Year - 1900) * 1000 + Period
      E.g. 01/2005 = 105 * 1000 + 1 = 105001) }
    YearPeriodCheck := (Integer(NHist.Yr) * 1000) + NHist.Pr;
    YearCheck       := (Integer(NHist.Yr) * 1000);
    if (
         (YearPeriodCheck < StartPeriod) and
         (YearPeriodCheck > (StartPeriod div 1000) * 1000)
       ) then
    begin
      { Within range }
      Result := True;
      if IsPartYear then
      begin
        IsYTDRecord := False;
        { Cumulate YTD figures }
        UpdateYTD;
        { If this is a P&L record, update the matching AutoRetain figures. }
        if NHist.ExCLass = PLNHCode then
          UpdateAutoRetained;
      end;
    end
    else if
       (
        (YearCheck <= (StartPeriod div 1000) * 1000) and
        (NHist.ExCLass in [PLNHCode, BankNHCode, CtrlNHCode, NomHedCode]) and
        (NHist.Pr in [254, 255])
       ) then
    begin
      { YTD for cumulative types }
      Result := True;
      if IsPartYear then
      begin
        IsYTDRecord := True;
        if not YTDRec.InUse then
        begin
          { If this is an AutoRetain YTD for the drip-feed year, update it with
            the stored figures... }
          Move(NHist.Code[1], NomCode, SizeOf(NomCode));
          if IsPartYear and
             (YearCheck = (StartPeriod div 1000) * 1000) and
             (NHist.ExCLass = CtrlNHCode) and
             (NomCode = Syss.NomCtrlCodes[ProfitBF]) then
            CopyAutoRetainToYTD
          { ...but if this is a header for an AutoRetained YTD, then ignore
            it... }
          else if (NHist.ExCLass = NomHedCode) and IsHeaderForAutoRetained then
            Result := False
          else
            { ...otherwise  simply copy the YTD figures from the current record. }
            UpdateYTD;
        end
        else
          YTDRec.Pr := NHist.Pr;
      end;
    end
    else
      Result := False;
  end;
  // ...........................................................................
  function WantCustomerHistory: Boolean;
  var
    YearPeriodCheck: LongInt;
    YearCheck: LongInt;
  begin
    { Set the period/year as (Year - 1900) * 1000 + Period
      E.g. 01/2005 = 105 * 1000 + 1 = 105001) }
    YearPeriodCheck := (Integer(NHist.Yr) * 1000) + NHist.Pr;
    YearCheck       := (Integer(NHist.Yr) * 1000);
    if (
        (YearPeriodCheck < StartPeriod) and
        (YearPeriodCheck > (StartPeriod div 1000) * 1000)
       ) then
    begin
      { Within range }
      Result := True;
      if IsPartYear then
      begin
        IsYTDRecord := False;
        { Cumulate YTD figures }
        UpdateYTD;
      end;
    end
    else if
       (
        (YearCheck <= ((StartPeriod div 1000) * 1000)) and
        (NHist.Pr in [254, 255])
       ) then
    begin
      { YTD for cumulative types }
      Result := True;
      if IsPartYear then
      begin
        IsYTDRecord := True;
        if not YTDRec.InUse then
          UpdateYTD
        else
          YTDRec.Pr := NHist.Pr;
      end;
    end
    else
    begin
      Result := False;
    end;
  end;
  // ...........................................................................
  function WantThisHistoryRecord : Boolean;
  begin
    //P&L and Ctrl Recs - all records within a period/year range set by the user
    //Balance Sheet Recs - As P&L/Ctrl + Last YTD for each GL/Currency
    //Header Recs - As P&L/Ctrl + All YTDs?
    if (NHist.ExCLass in [PLNHCode, BankNHCode, CtrlNHCode, NomHedCode]) then
      { GL History }
      Result := WantGLHistory
    else if (NHist.ExCLass in [CustHistCde, CustHistGPCde]) then
      { Customer History }
      Result := WantCustomerHistory
    else
      Result := False;

    if Result then
    begin
      // Have we started a new code?
      GLCodeChanged := (NHist.Code <> CurrentCode);
      //Have we started a new Code or Currency?
      if (NHist.Code <> CurrentCode) or (NHist.Cr <> CurrentCurr) then
      begin
        //Reset
        CurrentCode := NHist.Code;
        CurrentCurr := NHist.Cr;
      end;
    end
    else
      GLCodeChanged := False;
  end;
  // ...........................................................................

begin
  GLCodeChanged := False;
  XMLFileOpen   := False;

  CurrentCurr := 255;
  CurrentCode := '';

  ClearYTD;

  FileManager.Directory := DataPath + cICEFOLDER;
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');

  Key := '';

  if (Param2 > 1900) then
    Param2 := Param2 - 1900;
  if (Param4 > 1900) then
    Param4 := Param4 - 1900;

  { Determine whether the first period of the drip-feed is the also the
    first period in the year -- if this is so, we do not need to handle
    the auto-retained figures separately. }
  IsPartYear := (Param1 <> 1);

  fStartPeriod := (Integer(Param2) * 1000) + Param1;
  fEndPeriod   := (Integer(Param4) * 1000) + Param3;

  { Open the GL Structure table. }
  Res := OpenGLStructure;

  if (Res = 0) then
    { Open the GL Codes table. }
    Res := Open_File(F[NomF], SetDrive + FileNames[NomF], 0);

  if (Res = 0) then
    { Open the History table. }
    Res := Open_File(F[NHistF], SetDrive + FileNames[NHistF], 0);

  IsYTDRecord := False;
  if (Res = 0) then
  begin
    ReadPLParentRecords(Param2, Param4);
    
    Res := Find_Rec(B_GetFirst, F[NHistF], NHistF, NHist, 0, Key);

    while (Res = 0) do
    begin

      Application.ProcessMessages;

      if (not IsCCDept) and WantThisHistoryRecord then
      begin

        { If we are on a new GL code, and there is an XML file currently
          open, we need to finish and close the XML file, and add it to
          the list of exported files. }
        if GLCodeChanged and XMLFileOpen then
        begin
          XMLWriter.Finish;
          FileName := FileManager.SaveXML(XMLWriter.XML.Text);
          Files.Add(FileName);
          XMLFileOpen := False;
        end;

        { If there is no XML file open, we need to start a new one. }
        if not XMLFileOpen then
        begin
          XMLWriter.Start(cHISTORYTABLE, 'history');
          XMLFileOpen := True;
        end;

        { Build the required XML record from the Transaction details. }
        BuildRecord;

      end;

      Res := Find_Rec(B_GetNext, F[NHistF], NHistF, NHist, 0, Key);

      WriteTrace;
      
    end;

    { If there is an XML file still open we need to finish and close it. }
    if XMLFileOpen then
    begin
      XMLWriter.Finish;
      FileName := FileManager.SaveXML(XMLWriter.XML.Text);
      Files.Add(FileName);
    end;

    if IsPartYear then
    begin
      { Finally, add the YTD records for P&L. }
      XMLWriter.Start(cHISTORYTABLE, 'history');
      for Entry := Low(PLHeaders) to High(PLHeaders) do
      begin
        YTDRec := PLHeaders[Entry];
        IsYTDRecord := True;
        BuildRecord;
      end;
      XMLWriter.Finish;
      FileName := FileManager.SaveXML(XMLWriter.XML.Text);
      Files.Add(FileName);
    end;

    Result := True;
  end
  else
  begin
    Result := False;
    DoLogMessage('THistoryExport.LoadFromDB',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(Res));
  end;

end;

// -----------------------------------------------------------------------------

function THistoryExport.OpenGLStructure: LongInt;
var
  Key: Str255;
  FuncRes: LongInt;
begin
  { Get the identifier for the G/L Structure record (the System Settings tables
    holds multiple types of information -- the identifier allows the program to
    locate the correct record for specific information). }
  Key := SysNames[SysR];

  SetDrive := DataPath;

  { Open the System Settings table... }
  FuncRes := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  if (FuncRes = 0) then
  begin
    { ...and find the G/L Structure record. }
    FuncRes := Find_Rec(B_GetEq, F[SysF], SysF, RecPtr[SysF]^, 0, Key);

    if (FuncRes = 0) then
      FuncRes := GetPos(F[SysF], SysF, SysAddr[SysR]);

  end;
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.ReadPLParentRecords(StartYear, EndYear: Byte);
{ Creates (in the PLHeaders array) a copy of the parent records of the
  AutoRetained records, for each currency. }
var
  AutoRetainGL: LongInt;
  BaseKey, GLKey, HeaderKey, Key: Str255;
  FuncRes: LongInt;
  PLHeader: TYTDRec;
  BTPos: TBtrieveSavePosition;
begin
  { Look up the AutoRetained nominal code in the G/L Control Codes array. }
  AutoRetainGL := Syss.NomCtrlCodes[ProfitBF];

  { Locate all records that are of type 'C' and match the AutoRetained G/L Code
    and the drip-feed year. }
  BaseKey := FullNomKey(AutoRetainGL);
  Key     := 'C' + BaseKey;
  FuncRes := Find_Rec(B_GetGEq, F[NHistF], NHistF, NHist, 0, Key);

  BTPos := TBtrieveSavePosition.Create;
  try
    { For each record: }
    while (FuncRes = 0) and (Copy(NHist.Code, 1, Length(BaseKey)) = BaseKey) do
    begin
      if ((NHist.Yr >= StartYear) and (NHist.Yr <= EndYear)) then
      begin
        { Locate the matching entry in the G/L Tree Structure. }
        GLKey := FullNomKey(AutoRetainGL);
        FuncRes := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, 0, GLKey);
        { While there are more parent records in the G/L Tree Structure: }
        while (FuncRes = 0) and (Nom.Cat <> 0) do
        begin
          { Locate the parent record. }
          GLKey := FullNomKey(Nom.Cat);
          FuncRes := Find_Rec(B_GetEq, F[NomF], NomF, RecPtr[NomF]^, 0, GLKey);
          if (FuncRes = 0) then
          begin
            { Copy the details to an array, identifying it by currency and year. }
            PLHeader.Code    := FullNomKey(Nom.NomCode);
            PLHeader.ExClass := 'H';
            PLHeader.Yr      := NHist.Yr;
            PLHeader.Pr      := 255;
            PLHeader.Cr      := NHist.Cr;
            { Find the History record (preserving the original position in the
              History file), and copy the details. }
            HeaderKey := LJVar(FullNomKey(Nom.NomCode), 20);
            Key := 'H' + HeaderKey  + Chr(NHist.Cr) + Chr(NHist.Yr) + Chr(255);
            BTPos.SaveFilePosition(NHistF, 0);
            FuncRes := Find_Rec(B_GetEq, F[NHistF], NHistF, RecPtr[NHistF]^, 0, Key);
            if (FuncRes = 0) then // and (Copy(NHist.Code, 1, Length(HeaderKey)) = HeaderKey) then
            begin
              PLHeader.Sales     := NHist.Sales;
              PLHeader.Purchases := NHist.Purchases;
              PLHeader.Budget    := NHist.Budget;
              PLHeader.Budget2   := NHist.Budget2;
              PLHeader.Value1    := NHist.Value1;
              PLHeader.Value2    := NHist.Value2;
              PLHeader.Value3    := NHist.Value3;
              { Add the record to the array. }
              SetLength(PLHeaders, Length(PLHeaders) + 1);
              PLHeaders[High(PLHeaders)] := PLHeader;
            end;
            { Restore the original position. }
            BTPos.RestoreSavedPosition(True);
          end;
        end; { while (FuncRes = 0) and (Nom.Cat <> 0)... }
      end; { if (NHist.Yr >= StartYear)... }
      { Get the next History record. }
      FuncRes := Find_Rec(B_GetNext, F[NHistF], NHistF, NHist, 0, Key);
    end; { while (FuncRes = 0) and Copy(... }
  finally
    BTPos.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.SetFromDate(const Value: TDateTime);
var
  DateStr: string[8];
  Yr, Pr: Byte;
begin
  fFromDate := Value;
  DateStr := FormatDateTime('yyyymmdd', fFromDate);
  SimpleDate2Pr(DateStr, Pr, Yr);
  fStartPeriod := (Integer(Yr) * 1000) + Pr;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.SetToDate(const Value: TDateTime);
var
  DateStr: string[8];
  Yr, Pr: Byte;
begin
  fToDate := Value;
  DateStr := FormatDateTime('yyyymmdd', fToDate);
  SimpleDate2Pr(DateStr, Pr, Yr);
  fEndPeriod := (Integer(Yr) * 1000) + Pr;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.Trace(Msg: string; Full: Boolean; TraceYTD: Boolean);
begin
  if Full then
    if TraceYTD then
      TraceLines.Add(
           Msg + ': ' +
                 ' Code: ' +  YTDRec.Code +
                 ' Class: ' + YTDRec.ExCLass +
                 ' Cr: ' + IntToStr(YTDRec.Cr) +
                 ' Yr: ' + IntToStr(YTDRec.Yr) +
                 ' Pr: ' + IntToStr(YTDRec.Pr) +
                 ' Sales: ' + Format('%10.4f', [YTDRec.Sales]) +
                 ' Purchases: ' + Format('%10.4f', [YTDRec.Purchases])
      )
    else
      TraceLines.Add(
           Msg + ': ' +
                 ' Code: ' + NHist.Code +
                 ' Class: ' + NHist.ExCLass +
                 ' Cr: ' + IntToStr(NHist.Cr) +
                 ' Yr: ' + IntToStr(NHist.Yr) +
                 ' Pr: ' + IntToStr(NHist.Pr) +
                 ' Sales: ' + Format('%10.4f', [NHist.Sales]) +
                 ' Purchases: ' + Format('%10.4f', [NHist.Purchases])
      )
  else
    TraceLines.Add(Msg);
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.UpdateAutoRetained;
var
  Entry: Integer;
  EntryPos: Integer;
  Rec: TYTDRec;
begin
  { Find the array entry matching the current currency. }
  EntryPos := -1;
  for Entry := Low(AutoRetained) to High(AutoRetained) do
  begin
    if AutoRetained[Entry].Cr = NHist.Cr then
    begin
      EntryPos := Entry;
      Rec := AutoRetained[Entry];
      Break;
    end;
  end;

  { Add a new array entry if required. }
  if EntryPos = -1 then
  begin
    SetLength(AutoRetained, Length(AutoRetained) + 1);
    EntryPos := High(AutoRetained);
    Rec := AutoRetained[EntryPos];
    FillChar(Rec, SizeOf(Rec), 0);
  end;

  { Update the array entry with the current figures. }
  Rec.InUse     := True;
  Rec.Cr        := NHist.Cr;
  Rec.Yr        := NHist.Yr;
  Rec.Pr        := 255;
  Rec.Sales     := Rec.Sales     + NHist.Sales;
  Rec.Purchases := Rec.Purchases + NHist.Purchases;
  Rec.Budget    := Rec.Budget    + NHist.Budget;
  Rec.Budget2   := Rec.Budget2   + NHist.Budget2;
  Rec.Value1    := Rec.Value1    + NHist.Value1;
  Rec.Value2    := Rec.Value2    + NHist.Value2;
  Rec.Value3    := Rec.Value3    + NHist.Value3;

  AutoRetained[EntryPos] := Rec;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.UpdateYTD;
begin
  YTDRec.InUse     := True;
  YTDRec.Code      := NHist.Code;
  YTDRec.ExClass   := NHist.ExCLass;
  YTDRec.Cr        := NHist.Cr;
  YTDRec.Yr        := NHist.Yr;
  YTDRec.Pr        := NHist.Pr;
  YTDRec.Sales     := YTDRec.Sales     + NHist.Sales;
  YTDRec.Purchases := YTDRec.Purchases + NHist.Purchases;
  YTDRec.Budget    := YTDRec.Budget    + NHist.Budget;
  YTDRec.Cleared   := YTDRec.Cleared   + NHist.Cleared;
  YTDRec.Budget2   := YTDRec.Budget2   + NHist.Budget2;
  YTDRec.Value1    := YTDRec.Value1    + NHist.Value1;
  YTDRec.Value2    := YTDRec.Value2    + NHist.Value2;
  YTDRec.Value3    := YTDRec.Value3    + NHist.Value3;
end;

// -----------------------------------------------------------------------------

procedure THistoryExport.WriteTrace;
var
  Entry: Integer;
begin
  for Entry := 0 to TraceLines.Count - 1 do
    LogMessage(TraceLines[Entry]);
  TraceLines.Clear;
end;

// -----------------------------------------------------------------------------

end.
