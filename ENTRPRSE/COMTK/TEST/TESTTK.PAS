unit testtk;

{ prutherford440 09:55 04/12/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Enterprise01_TLB, EnterpriseForms_TLB, Classes, ComObj, ComCtrls, TestLog;

const
  RecordsToRead = 20;
  MaxLicences = 10;


type
  TLicenceArray = Array[1..MaxLicences] of TReleaseCodeStatus;

  TTestToolkit = Class
   private
    FToolkit : IToolkit;
    FPrintingToolkitI : IEFPrintingToolkit;
    FReport   : TRichLog;
    FStart, FTime : Cardinal;
    FValidateData : Boolean;
    FDataPath : string;
    FLicenceTest : TLicenceArray;
    function OK : Boolean;
    procedure StartTimer;
    procedure EndTimer;
    procedure ReportTime;
    function DocTypeToString(dt : TDocTypes) : String;
    function ValidatePath(const APath : string) : Boolean;
    function ValidateCode(var ACode : string; AType : Byte) : Boolean;
    function ValidateCurrency(var ACurr : string) : Boolean;
    procedure LoadLicences(var L : TLicenceArray);
    function CheckLicences : Boolean;
   protected
    function GetTKOpen : Boolean;
    function GetErrorString : string;
    function GetEntPath : string;
    function GetTKVersion : string;
    function GetPTKVersion : string;
   public
    constructor Create;
    destructor Destroy; override;
    procedure BlankLine;
    function Open : longint;
    procedure Close;
    function CCs : Boolean; //cost centres & depts on or off
    function Locations : Boolean;
    function JobCostingLicenced : Boolean;

    procedure ShowLicences;
    procedure TestCustomersOrSuppliers(Cust : Boolean);
    procedure TestCCDeps(CC : Boolean);
    procedure TestGeneralLedger;
    procedure TestLocations;
    procedure TestStock;
    procedure TestEmployees;
    procedure TestJobs;
    procedure TestJobAnalysis;
    procedure TestJobTypes;
    procedure TestTimeRates;
    procedure TestTransactions;



    function AvailableCompanies : integer;
    procedure Btrieve;
    procedure BtrieveFiles;
    procedure EntSettings;
    function CheckDataPath(i : integer) : Boolean;
    function ChangeCompany(i : integer) : Boolean;
    function GetDataPath(i : integer) : string;

    function ValidateExit(var ExitText : string; ValidType : Byte) : Boolean;
    procedure Browse;
    procedure LoadBaseLicences;
    function IsClientServer : Boolean;
    procedure InitFormTk;
    Property Toolkit : IToolkit Read FToolkit;
    property Report : TRichLog read FReport write FReport;
    property ToolkitIsOpen : Boolean read GetTKOpen;
    property ErrorString : string read GetErrorString;
    property EnterprisePath : string read GetEntPath;
    property ToolkitVersion : string read GetTKVersion;
    property ValidateData : Boolean read FValidateData write FValidateData;
    property DataPath : string read FDataPath write FDataPath;
    property PrintToolkitVersion : string read GetPTKVersion;
  end;

implementation

uses
  SysUtils, Forms, Windows, ActiveX, TestCons, Dialogs, CodeList, SecCodes, Variants, CtkUtil, SQLUtils;


constructor TTestToolkit.Create;
var
  a, b, c : longint;
begin
  inherited Create;
  FReport := nil;
  FToolkit := CreateToolkitWithBackdoor as IToolkit2;
  FValidateData := True;
end;

procedure TTestToolkit.InitFormTK;
begin
  FPrintingToolkitI := CreateOleObject ('EnterpriseForms.PrintingToolkit') As IEFPrintingToolkit;
end;

destructor TTestToolkit.Destroy;
begin
  FPrintingToolkitI := nil;
  if OK then //Ftoolkit not closed yet
    FToolkit.CloseToolkit;
  FToolkit := nil;
  inherited Destroy;
end;

procedure TTestToolkit.StartTimer;
begin
  FStart := GetTickCount;
  FTime := 0;
end;

procedure TTestToolkit.EndTimer;
begin
  FTime := GetTickCount - FStart;
end;

procedure TTestToolkit.ReportTime;
begin
  FReport.Report('Time elapsed: ' + IntToStr(FTime) + 'ms', 1);
end;

function TTestToolkit.Open : longint;
begin
  if Assigned(FToolkit) then
  begin
    Result := FToolkit.OpenToolkit;
    if Result = 0 then
      FReport.Report('Toolkit opened successfully')
    else
      FReport.ReportError('Failed to open toolkit. Error: ' +
         FToolkit.LastErrorString);
    BlankLine;
  end
  else
    Result := -1;

end;

procedure TTestToolkit.Close;
begin
  if OK then
  begin
    FToolkit.CloseToolkit;
    if FToolkit.Status = tkClosed then
      FReport.Report('Toolkit closed')
    else
      FReport.Report('Error closing Toolkit');
    BlankLine;
  end;
end;

function TTestToolkit.CCs : Boolean;
begin
  if OK then
    Result := FToolkit.SystemSetup.ssUseCCDept
  else
    Result := False;
end;

function TTestToolkit.Locations : Boolean;
begin
  if OK then
    Result := FToolkit.SystemSetup.ssUseLocations
  else
    Result := False;
end;

function TTestToolkit.JobCostingLicenced : Boolean;
begin
  if OK then
    Result := FToolkit.SystemSetUp.ssReleaseCodes.rcJobCosting in [rc30Day, rcEnabled]
  else
    Result := False;
end;

function TTestToolkit.DocTypeToString(dt : TDocTypes) : String;
begin
  Case dt of
    dtSIN  : Result := 'SIN';
    dtSRC  : Result := 'SRC';
    dtSCR  : Result := 'SCR';
    dtSJI  : Result := 'SJI';
    dtSJC  : Result := 'SJC';
    dtSRF  : Result := 'SRF';
    dtSRI  : Result := 'SRI';
    dtSQU  : Result := 'SQU';
    dtSOR  : Result := 'SOR';
    dtSDN  : Result := 'SDN';
    dtSBT  : Result := 'SBT';
    dtPIN  : Result := 'PIN';
    dtPPY  : Result := 'PPY';
    dtPCR  : Result := 'PCR';
    dtPJI  : Result := 'PJI';
    dtPJC  : Result := 'PJC';
    dtPRF  : Result := 'PRF';
    dtPPI  : Result := 'PPI';
    dtPQU  : Result := 'PQU';
    dtPOR  : Result := 'POR';
    dtPDN  : Result := 'PDN';
    dtPBT  : Result := 'PBT';
    dtNMT  : Result := 'NMT';
    dtADJ  : Result := 'ADJ';
    dtTSH  : Result := 'TSH';
    dtWOR  : Result := 'WOR';
  end; {case}
end;

function TTestToolkit.OK : Boolean;
begin
  Result := Assigned(FToolkit);
  if Result then
    Result := Result and (FToolkit.Status = tkOpen);
end;

procedure TTestToolkit.BlankLine;
begin
  if Assigned(FReport) then
    FReport.Line;
end;

procedure TTestToolkit.ShowLicences;
var
  s : string;

  function StatusString(Status : TReleaseCodeStatus) : string;
  begin
    if Status = rc30Day then
      Result := '30 Day'
    else
    if Status = rcEnabled then
      Result := 'Enabled'
    else
      Result := 'Disabled';
  end;

begin
  if OK then
  begin
    FReport.ReportBoldU('Modules:');

    with FToolkit.SystemSetup.ssReleaseCodes as ISystemSetupReleaseCodes3, FReport do
    begin
      s := StatusString(rcAccountStockAnalysis);
      Report(Format('%23s  %-8s', ['Account Stock Analysis:', s]), 1);

      s := StatusString(rcCommitment);
      Report(Format('%23s  %-8s', ['Commitment Accounting:', s]), 1);

      s := StatusString(rcEBusiness);
      Report(Format('%23s  %-8s', ['eBusiness:', s]), 1);

      s := StatusString(rcJobCosting);
      Report(Format('%23s  %-8s', ['Job Costing:', s]), 1);

      s := StatusString(rcMultiCurrency);
      Report(Format('%23s  %-8s', ['Multi-Currency:', s]), 1);

      s := StatusString(rcOLESave);
      Report(Format('%23s  %-8s', ['OLE Save functions:', s]), 1);

      s := StatusString(rcPaperless);
      Report(Format('%23s  %-8s', ['Paperless:', s]), 1);

      s := StatusString(rcReportWriter);
      Report(Format('%23s  %-8s', ['Report Writer:', s]), 1);

      s := StatusString(rcTeleSales);
      Report(Format('%23s  %-8s', ['TeleSales:', s]), 1);

      s := StatusString(rcToolkitDLL);
      Report(Format('%23s  %-8s', ['Toolkit DLL:', s]), 1);

      s := StatusString(rcAppsAndVals);
      Report(Format('%23s  %-8s', ['Apps & Vals:', s]), 1);

      s := StatusString(rcEnhancedSecurity);
      Report(Format('%23s  %-8s', ['Enhanced Security:', s]), 1);

      s := StatusString(rcFullStockControl);
      Report(Format('%23s  %-8s', ['Full Stock Control:', s]), 1);

      s := StatusString(rcGoodsReturns);
      Report(Format('%23s  %-8s', ['Goods Returns:', s]), 1);

      s := StatusString(rcSentimail);
      Report(Format('%23s  %-8s', ['Sentimail:', s]), 1);

      s := StatusString(rcTradeCounter);
      Report(Format('%23s  %-8s', ['Trade Counter:', s]), 1);

      s := StatusString(rcVisualReportWriter);
      Report(Format('%23s  %-8s', ['Visual Report Writer:', s]), 1);

      s := StatusString(rcWOPProfessional);
      Report(Format('%23s  %-8s', ['WOP (Professional):', s]), 1);

      s := StatusString(rcWOPStandard);
      Report(Format('%23s  %-8s', ['WOP (Standard):', s]), 1);
    end;

    FReport.Line;

{    if not CheckLicences then
      FReport.ReportError('Licences differ from Company 1');}
  end;{if ok}
end;



procedure TTestToolkit.TestCustomersOrSuppliers(Cust : Boolean);
//Read first 20 customer or supplier recs
var
  Status, i : integer;
  s : string;
  Bal : Double;
  BalanceException : string;
  CustSupp : IAccount;
begin
  if OK then
  begin
    if Cust then
    begin
      CustSupp := FToolkit.Customer;
      s := 'Customer';
    end
    else
    begin
      CustSupp := FToolkit.Supplier;
      s := 'Supplier';
    end;

    FReport.ReportBold('Reading ' + s + 's 1-'+IntToStr(RecordsToRead) + ': ');
    FReport.DetailLine;
    i := 1;
    with CustSupp do
    begin
      BalanceException := '';
      StartTimer;
      Index := acIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError(s + '.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%6s   %11s',['Code','Balance']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          if Assigned(acHistory) then
          with acHistory do
          Try
            Bal := acBalance;
            FReport.ReportDetailsOnly(Format('%6s   %11.2m',[acCode, Bal]));
          Except
            on E: Exception do
            begin
              BalanceException := acCode + ': ' + E.Message;
              FReport.ReportError('Balance exception on ' + BalanceException);
            end;
          End;
          Status := GetNext;
          inc(i);
        end;
        FReport.DetailLine;
        EndTimer;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.Report(s + '.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
    CustSupp := nil;
  end; {if OK}
end;

function TTestToolkit.AvailableCompanies : integer;
begin
  if OK then
  begin
    Try
      Result := FToolkit.Company.cmCount
    Except
      Result := 0;
    End;
  end
  else
    Result := 0;

  if Result = 0 then
    FReport.ReportError('No companies found in Multi-Company Manager');
end;

procedure TTestToolkit.Btrieve;
var
  V : Variant;
  a, b, c : longint;
begin
  if OK then
  begin
    with FToolkit do
    begin
      EncodeOpCode(64, a, b, c);
      V := Configuration.SetDebugMode(a, b, c);
      if VarType(V) <> varEmpty then
      begin
        FReport.ReportBoldU('Btrieve versions:');
        BlankLine;
        FReport.ReportBold('Drivers:');
        FReport.Report(Format('%10s %-5s',['MKDB:',V.BtrieveVersion(1)]));
        FReport.Report(Format('%10s %-5s',['Requester:',V.BtrieveVersion(2)]));
        FReport.Report(Format('%10s %-5s',['Server:',V.BtrieveVersion(3)]));
        BlankLine;
      end; {if assigned(v)}
    end; {with ftoolkit}
  end;{if OK}
end;

procedure TTestToolkit.BtrieveFiles;
var
  V : Variant;
  i : integer;
  a, b, c : longint;
begin
  if OK then
  begin
    if FToolkit.Status = tkOpen then
    with FToolkit do
    begin
      EncodeOpCode(64, a, b, c);
      V := Configuration.SetDebugMode(a, b, c);
      if VarType(V) <> varEmpty then
      begin
        FReport.ReportBoldU('Btrieve versions:');
        BlankLine;
        FReport.ReportBold('Files:');
        BlankLine;
        FReport.ReportBold(Format('%-7s  %3s%-8s', ['Name','   Ver', '   Recs']));
        FReport.Report(Format('%-8s    %2s    %d', ['EXCHQSS', V.FileVersion('EXCHQSS'),
                                                  Integer(V.RecordCount('EXCHQSS'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['EXCHQNUM', V.FileVersion('EXCHQNUM'),
                                                  Integer(V.RecordCount('EXCHQNUM'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['CUSTSUPP', V.FileVersion('CUSTSUPP'),
                                                  Integer(V.RecordCount('CUSTSUPP'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['JOBDET', V.FileVersion('JOBDET'),
                                                  Integer(V.RecordCount('JOBDET'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['JOBCTRL', V.FileVersion('JOBCTRL'),
                                                  Integer(V.RecordCount('JOBCTRL'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['JOBHEAD', V.FileVersion('JOBHEAD'),
                                                  Integer(V.RecordCount('JOBHEAD'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['JOBMISC', V.FileVersion('JOBMISC'),
                                                  Integer(V.RecordCount('JOBMISC'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['EXCHQCHK', V.FileVersion('EXCHQCHK'),
                                                  Integer(V.RecordCount('EXCHQCHK'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['EXSTKCHK', V.FileVersion('EXSTKCHK'),
                                                  Integer(V.RecordCount('EXSTKCHK'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['MLOCSTK', V.FileVersion('MLOCSTK'),
                                                  Integer(V.RecordCount('MLOCSTK'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['STOCK', V.FileVersion('STOCK'),
                                                  Integer(V.RecordCount('STOCK'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['DETAILS', V.FileVersion('DETAILS'),
                                                  Integer(V.RecordCount('DETAILS'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['DOCUMENT', V.FileVersion('DOCUMENT'),
                                                  Integer(V.RecordCount('DOCUMENT'))]));
        FReport.Report(Format('%-8s    %2s    %d', ['NOMINAL', V.FileVersion('NOMINAL'),
                                                  Integer(V.RecordCount('NOMINAL'))]));
      end; {if assigned(v)}
    end; {with ftoolkit}
  end;{if OK}
end;


function TTestToolkit.CheckDataPath(i : integer) : Boolean;
var
  s : string;
begin
  if Assigned(FToolkit) then
  begin
    Result := ValidCompany(Trim(FToolkit.Company.cmCompany[i].coPath));
  end
  else
    Result := False;
end;

function TTestToolkit.GetDataPath(i : integer) : string;
begin
  Result := '';
  if OK then
    Result := Trim(FToolkit.Company.cmCompany[i].coPath);
end;

function TTestToolkit.ChangeCompany(i : integer) : Boolean;
var
  s : string;
  Res : integer;
begin
  if Assigned(FToolkit) then
  with FToolkit do
  begin
    Res := CloseToolkit;
    if {Res <> 0}Status <> tkClosed then
    begin
      FReport.ReportError('Unable to close Toolkit. Error ' + IntToStr(Res));
      Result := False;
    end
    else
    begin
        s := Company.cmCompany[i].coPath;
        Configuration.DataDirectory := s;
        OpenToolkit;
        if Status = tkOpen then
        begin
          FReport.ReportBoldU('Reading Company ' + IntToStr(i) + ': ' + Company.cmCompany[i].coCode +
           ' (' + QuotedStr(Company.cmCompany[i].coName) + ')');
          FReport.ReportBold('(Path: ' + Trim(Configuration.DataDirectory) + ')');
          BlankLine;
          Result := True;
        end
        else
        begin
          FReport.ReportError('Can''t open Toolkit for Company ' + IntToStr(i) + ': ' + LastErrorString);
          Result := False;
        end;
    end;//Res = 0
  end; //with
end;

procedure TTestToolkit.TestCCDeps(CC : Boolean);
var
  i : integer;
  Status : SmallInt;
  CCDep : ICCDept;
  s : string;
begin

  if OK then
  begin
    if CC then
    begin
      CCDep := FToolkit.CostCentre;
      s := 'Cost Centre';
    end
    else
    begin
      CCDep := FToolkit.Department;
      s := 'Department';
    end;

    Try
      FReport.ReportBold('Reading ' + s + 's 1-'+IntToStr(RecordsToRead) + ': ');
      FReport.DetailLine;
      i := 1;
      CCDep.Index := cdIdxCode;
      Status := CCDep.GetFirst;

      if Status <> 0 then
        FReport.ReportError(s + '.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%8s   %-10s',['Code', 'Description']),1);
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%8s   %-10s',[CCDep.cdCode, CCDep.cdName]),1);
          Status := CCDep.GetNext;
          inc(i);
        end;
        FReport.DetailLine;
        EndTimer;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.Report('Customer.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{Status = 0}
      BlankLine;



    Finally
      CCDep := nil;
    End;

  end; {if OK}

end;

procedure TTestToolkit.TestGeneralLedger;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading General Ledger Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.GeneralLedger do
    begin
      FReport.DetailLine;
      StartTimer;
      Index := glIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('GeneralLedger.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%8s   %-11s',['Code','Description']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%8s   %-11s',[IntToStr(glCode),glName]));
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('GeneralLedger.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;

procedure TTestToolkit.TestLocations;
var
  Status, Status2, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Locations 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.Location do
    begin
      FReport.DetailLine;
      FReport.ReportDetailsOnlyBold(Format('%5s   %-11s', ['Code','Name']));
      StartTimer;
      Index := loIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('Location.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%5s   %-30s',[loCode, loName]));
          if Locations then
          begin
             Status2 := loStockList.GetFirst;
             if not (Status2 in [0, 9]) then
               FReport.ReportError('Error ' + IntToStr(Status2) +
                               ' - ' + FToolkit.LastErrorString + ' on StockLocation.GetFirst')
             else
             if Status2 = 0 then
               FReport.ReportDetailsOnly('(loStockList: First StockCode : ' +
                    loStockList.slStockCode + ')', 1);
          end;

          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('Location.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;

procedure TTestToolkit.TestStock;
var
  Status, Status2, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Stock Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.Stock do
    begin
      FReport.DetailLine;
      FReport.ReportDetailsOnlyBold(Format('%-10s  %-20s',['Code', 'Description']));
      StartTimer;
      Index := stIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('Stock.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%10s  %-20s',[stCode, stDesc[1]]));
          if Locations then
          begin
             Status2 := stLocationList.GetFirst;
             if not (Status2 in [0, 9]) then
               FReport.ReportError('Error ' + IntToStr(Status2) +
                               ' - ' + FToolkit.LastErrorString + ' on StockLocation.GetFirst')
             else
             if Status2 = 0 then
               FReport.ReportDetailsOnly('(stLocationList: First LocationCode : ' +
                    stLocationList.slLocationCode + ')', 1);
          end;
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('Stock.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;


procedure TTestToolkit.TestEmployees;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Employee Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.JobCosting.Employee do
    begin
      FReport.DetailLine;
      StartTimer;
      Index := emIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('Employee.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%-10s  %-20s',['Code','Name']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%-10s  %-20s',[emCode, emName]));
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('Employee.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;

procedure TTestToolkit.TestJobs;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Job Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.JobCosting.Job do
    begin
      FReport.DetailLine;
      StartTimer;
      Index := jrIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('Job.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%-10s  %-20s',['Code','Description']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%-10s  %-20s',[jrCode, jrDesc]));
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('Job.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;


procedure TTestToolkit.TestJobAnalysis;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Job Analysis Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.JobCosting.JobAnalysis do
    begin
      FReport.DetailLine;
      StartTimer;
      Index := anIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('JobAnalysis.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%-10s  %-20s',['Code','Description']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%-10s  %-20s',[anCode, anDescription]));
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('JobAnalysis.GetNext returned ' + IntToStr(Status));
        ReportTime;

      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;

procedure TTestToolkit.TestJobTypes;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Job Type Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.JobCosting.JobType do
    begin
      FReport.DetailLine;
      StartTimer;
      Index := jtIdxCode;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('JobType.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold(Format('%-10s  %-20s',['Code','Name']));
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(Format('%-10s  %-20s',[jtCode, jtName]));
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('JobType.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;

procedure TTestToolkit.TestTimeRates;
var
  Status, i : integer;
  s : string;
begin
  if OK then
  begin
    FReport.ReportBold('Reading Time Rate Records 1-'+IntToStr(RecordsToRead) + ': ');
    i := 1;
    with FToolkit.JobCosting.TimeRates do
    begin
      FReport.DetailLine;
      StartTimer;
      Status := GetFirst;
      if Status <> 0 then
        FReport.ReportError('TimeRates.GetFirst returned error ' + IntToStr(Status))
      else
      begin
        FReport.ReportDetailsOnlyBold('Descripton');
        while (Status = 0) and (i <= RecordsToRead) do
        begin
          FReport.ReportDetailsOnly(trDescription);
          Status := GetNext;
          inc(i);
        end;
        EndTimer;
        FReport.DetailLine;
        if Status in [0, 9] then
        begin
          FReport.Report(IntToStr(i-1) + ' records read successfully', 1);
          if Status = 9 then
            FReport.Report('End of file reached', 1);
        end
        else
          FReport.ReportError('TimeRates.GetNext returned ' + IntToStr(Status));
        ReportTime;
      end;{status = 0}
    end; {with}
    BlankLine;
  end; {if OK}
end;



procedure TTestToolkit.TestTransactions;
var
  Status, i, j : integer;
  dt : TDocTypes;
  DocPrefix : string;
  Val : Double;
  DetailsList : TStringList;
begin
  if OK then
  begin
    Try
      DetailsList := TStringList.Create;
      FReport.ReportBold('Reading Transaction Records 1-'+IntToStr(RecordsToRead) + ': ');

      with FToolkit.Transaction do
      begin
        StartTimer;
        for dt := dtSIN to dtWOR do
        begin
          DetailsList.Clear;
          i := 0;
          Index := thIdxOurRef;
          DocPrefix := DocTypeToString(dt);
          Status := GetGreaterThanOrEqual(BuildOurRefIndex(DocPrefix));
          if (Status = 9) or
             (Status = 0) and (thDocType <> dt) then
              FReport.Report(DocPrefix + ': No records found',1)
          else if Status <> 0 then
            FReport.Report('Error on Transaction.GetGreaterThanOrEqual for ' + DocPrefix +
                             ': ' + FToolkit.LastErrorString)
          else
          begin
            inc(i);
            while (Status = 0) and (thDocType = dt) and (i <= RecordsToRead) do
            begin
              if thLines.thLineCount > 0 then
              begin
                Val := 0;
                for j := 1 to thLines.thLineCount do
                begin
                  {what?}
                  Try  //tlNetValue is unit price not net line total
                    Val := Val + (thLines.thLine[j].tlNetValue * thLines.thLine[j].tlQty);
                  Except
                    on E: Exception do
                      FReport.ReportError('Error in transaction ' + thOurRef + ' Line '+
                                   IntToStr(j) + ': ' + E.Message);
                  End;
                end;
              end;
              DetailsList.Add(Format('%9s   %11.2m   %5s', [thOurRef, Val, IntToStr(thLines.thLineCount)]));
              Status := GetNext;
             inc(i);
            end; //while
          end;
          if (Status in [0, 9])  then
          begin
            if (i > 0) then
            begin
              FReport.DetailLine;
              FReport.ReportDetailsOnlyBold(Format('%-9s       %-10s  %-5s', [' ', ' ', 'Line']));
              FReport.ReportDetailsOnlyBold(Format('%-9s       %-10s  %-5s', ['OurRef', 'Value', 'Count']));
              for j := 0 to DetailsList.Count - 1 do
                FReport.ReportDetailsOnly(DetailsList[j]);
              FReport.DetailLine;
              FReport.Report(DocPrefix + ': ' + IntToStr(i-1) + ' records read successfully', 1);
              if Status = 9 then
                FReport.Report('No further records', 1);
            end;
          end
          else
            FReport.Report('Error on Transaction.GetGreaterThanOrEqual for ' + DocPrefix +
                             ': ' + FToolkit.LastErrorString);
        end; //for dt
        EndTimer;
        ReportTime;
      end; {with}
      BlankLine;
    Finally
      DetailsList.Free;
    End;
  end; {if OK}
end;

function TTestToolkit.GetTKOpen : Boolean;
begin
  Result := OK;
end;

procedure TTestToolkit.EntSettings;
var
  s : string;

  function GetCurrencyVersionString(Curr : TEnterpriseCurrencyVersion) : string;
  begin
    Case Curr of
      enProfessional  :   Result := 'Professional';
      enEuro          :   Result := 'Euro';
      enGlobal        :   Result := 'Global';
    end;
  end;

  function GetModuleVersionString(Mo : TEnterpriseModuleVersion) : string;
  begin
    Case Mo of
      enModStandard  :   Result := 'Standard';
      enModStock     :   Result := 'Stock';
      enModSpop      :   Result := 'OrderProcessing';
    end;
  end;


begin
  if OK then
  with FToolkit.Enterprise do
  begin
    FReport.ReportBoldU('Exchequer information');
    BlankLine;
    FReport.Report(Format('%21s  %-12s', ['Exchequer directory:',
                             FToolkit.Configuration.EnterpriseDirectory]));

    if enEnterpriseVersion <> '' then
      s := enEnterpriseVersion
    else
      s := 'Not available';

    FReport.Report(Format('%21s  %-12s', ['Exchequer version:', s]));
    FReport.Report(Format('%21s  %-12s', ['Currency version:',
                                          GetCurrencyVersionString(enModuleVersion)]));
    FReport.Report(Format('%21s  %-14s', ['Module version:',
                                          GetModuleVersionString(enModuleVersion)]));

    BlankLine;
    if enClientServer then
    begin
      FReport.Report('Client-Server version');
      Blankline;
    end;
  end; //with
end;

function TTestToolkit.GetErrorString : string;
begin
  if Assigned(FToolkit) then
    Result := FToolkit.LastErrorString
  else
    Result := '';
end;

function TTestToolkit.GetEntPath : string;
begin
  if Assigned(FToolkit) then
    Result := FToolkit.Configuration.EnterpriseDirectory
  else
    Result := '';
end;

function TTestToolkit.GetTKVersion : string;
begin
  if Assigned(FToolkit) then
    Result := FToolkit.Version
  else
    Result := '';
end;

function TTestToolkit.GetPTKVersion : string;
begin
  if Assigned(FPrintingToolkitI) then
    Result := FPrintingToolkitI.Version
  else
    Result := '';
end;


//Validation routines

function TTestToolkit.ValidateExit(var ExitText : string; ValidType : Byte) : Boolean;
begin
  if not FValidateData then
    Result := True
  else
  begin
    Case ValidType of
      vaPath       :   Result := ValidatePath(ExitText);
      vaNominal,
      vaCC,
      vaDept,
      vaVAT        :   Result := ValidateCode(ExitText, ValidType);
      vaCurrency   :   Result := ValidateCurrency(ExitText);
      vaUnknown    :   Result := True
      else
        Result := True;
    end;
  end;
end;

function TTestToolkit.ValidatePath(const APath : string) : Boolean;
begin
{  if FileExists(IncludeTrailingBackSlash(APath) + 'EXCHQSS.DAT') then
    Result := True
  else
  begin
    ShowMessage(IncludeTrailingBackSlash(APath) + ' is not a valid Exchequer data directory');
    Result := False;
  end;}
  Result := ValidCompany(APath);
  if not Result then
    ShowMessage(IncludeTrailingBackSlash(APath) + ' is not a valid Exchequer data directory');
end;

function TTestToolkit.ValidateCode(var ACode : string; AType : Byte) : Boolean;
var
  ResStr : string;
  OldDataPath : string;
  WasOpen : Boolean;
  i : integer;
begin
  Result := False;
  if Assigned(FToolkit) then
  begin
    if FToolkit.Status = tkOpen then
    begin
      FToolkit.CloseToolkit;
      WasOpen := True;
    end
    else
      WasOpen := False;

    OldDataPath := FToolkit.Configuration.DataDirectory;
    FToolkit.Configuration.DataDirectory := FDataPath;
    FToolkit.OpenToolkit;

        with TfrmCodeList.Create(nil) do
        begin
          Try
            Case AType of
              vaCC   : if CCs then
                         ResStr := GetCCDep(FToolkit.CostCentre, ACode, 0)
                       else
                         Result := True;
              vaDept : if CCs then
                         ResStr := GetCCDep(FToolkit.Department, ACode, 1)
                       else
                         Result := True;
              vaNominal : ResStr := GetGLCode(FToolkit.GeneralLedger, ACode);
              vaCurrency : begin
                             Try
                               i := StrToInt(ACode);
                             Except
                               i := -1;
                             End;
                             ResStr := GetCurrency(FToolkit.SystemSetup,i);
                           end;
            end;{case}
          Finally
            Free;
          End;
        end;

    if (ResStr <> '') or (Result = True) then
    begin
      if not Result then
        ACode := ResStr;
      Result := True;
    end
    else
      Result := False;

    FToolkit.CloseToolkit;
    FToolkit.Configuration.DataDirectory := OldDataPath;
    if WasOpen then
      FToolkit.OpenToolkit;
  end
  else
    Result := True;
end;

function TTestToolkit.ValidateCurrency(var ACurr : string) : Boolean;
var
  i : integer;
begin
  if Assigned(FToolkit) then
  begin
    Case FToolkit.Enterprise.enCurrencyVersion of
      enProfessional : Result := ACurr = '0';
      enEuro         : Result := (ACurr = '0') or (ACurr = '1');
      enGlobal       : Result := ValidateCode(ACurr, vaCurrency);
      else
        Result := True;
      end;{case}
  end
  else
    Result := True;

end;

procedure TTestToolkit.Browse;
var
  OldStatus : TToolkitStatus;
begin
  if Assigned(FToolkit) then
  begin
    OldStatus := FToolkit.Status;
    if OldStatus = TkClosed then
      FToolkit.OpenToolkit;
    FToolkit.Functions.entBrowseObject(FToolkit, True);
    if OldStatus = TkClosed then
      FToolkit.CloseToolkit;
  end;
end;

procedure TTestToolkit.LoadLicences(var L : TLicenceArray);
begin
  if OK then
  with FToolkit.SystemSetup.ssReleaseCodes do
  begin
    L[1] := rcAccountStockAnalysis;
    L[2] := rcCommitment;
    L[3] := rcEBusiness;
    L[4] := rcJobCosting;
    L[5] := rcMultiCurrency;
    L[6] := rcOLESave;
    L[7] := rcPaperless;
    L[8] := rcReportWriter;
    L[9] := rcTelesales;
    L[10] := rcToolkitDLL;
  end;
end;

procedure TTestToolkit.LoadBaseLicences;
begin
  LoadLicences(FLicenceTest);
end;

function TTestToolkit.CheckLicences : Boolean;
begin
  if OK then
  with FToolkit.SystemSetup.ssReleaseCodes do
  begin
    Result :=     (FlicenceTest[1] = rcAccountStockAnalysis) and
                  (FlicenceTest[2] = rcCommitment) and
                  (FlicenceTest[3] = rcEBusiness) and
                  (FlicenceTest[4] = rcJobCosting) and
                  (FlicenceTest[5] = rcMultiCurrency) and
                  (FlicenceTest[6] = rcOLESave) and
                  (FlicenceTest[7] = rcPaperless) and
                  (FlicenceTest[8] = rcReportWriter) and
                  (FlicenceTest[9] = rcTelesales) and
                  (FlicenceTest[10] = rcToolkitDLL);
  end
  else
    Result := False;
end;

function TTestToolkit.IsClientServer : Boolean;
begin
  if Assigned(FToolkit) then
    Result := FToolkit.Enterprise.enClientServer
  else
    Result := False;
end;

end.
