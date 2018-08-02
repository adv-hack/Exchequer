unit uHistoryExport;

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
  THistoryExport = class(_ExportBase)
  private
    fFromDate: TDateTime;
    fToDate: TDateTime;
    FileManager: TXMLFileManager;
    XMLWriter: TXMLWriter;
    fEndPeriod: Integer;
    fStartPeriod: Integer;

    TraceLines: TStringList;

    function BuildRecord: Boolean;
    procedure SetFromDate(const Value: TDateTime);
    procedure SetToDate(const Value: TDateTime);

    function OpenGLStructure: LongInt;

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

  // ...........................................................................
  function IsCCDept: Boolean;
  begin
    Result := (NHist.Code[7] > #32) or (NHist.Code[8] > #32);
  end;
  // ...........................................................................
  function WantGLHistory: Boolean;
  var
    YearCheck: LongInt;
  begin
    YearCheck := (Integer(NHist.Yr) * 1000);
    if (
        (YearCheck < (StartPeriod div 1000) * 1000) and
        (NHist.ExCLass in [PLNHCode, BankNHCode, CtrlNHCode, NomHedCode]) and
        (NHist.Pr in [254, 255])
       ) then
      { YTD for cumulative types }
      Result := True
    else
      Result := False;
  end;
  // ...........................................................................
  function WantCustomerHistory: Boolean;
  var
    YearCheck: LongInt;
  begin
    YearCheck := (Integer(NHist.Yr) * 1000);
    if (
        (YearCheck < ((StartPeriod div 1000) * 1000)) and
        (NHist.Pr in [254, 255])
       ) then
      { YTD for cumulative types }
      Result := True
    else
      Result := False;
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

  FileManager.Directory := DataPath + cICEFOLDER;
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');

  Key := '';

  if (Param2 > 1900) then
    Param2 := Param2 - 1900;
  if (Param4 > 1900) then
    Param4 := Param4 - 1900;

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

  if (Res = 0) then
  begin
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
