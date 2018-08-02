unit UKIntrastatReport;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}
{$WARN SYMBOL_PLATFORM OFF}
interface

uses Dialogs, Windows, DB, Graphics, SysUtils, Contnrs, StrUtils, RpDevice,
     GlobVar, VarConst, BTSupU3, SQLCallerU, SQLRep_BaseReport, ReportU, BtrvU2,
     Scrtch2U, IntrastatDataClass, ExBtth1U;

type
  TIntrastatParametersRec = record
    StartDate : LongDate;
    EndDate   : LongDate;
    Period    : Byte;
    Year      : Byte;
    ISReportMode : TIntrastatReportMode;
    ISDirection : TIntrastatDirection;
    OutOfPeriodOnly : Boolean; //PR: 29/01/2016 ABSEXCH-17208 v2016 R1 Added out of period flag
  end;

  // Main report object
  TUKIntrastatReport = object(TGenReport)
     procedure RepSetTabs; virtual;
     procedure RepPrintPageHeader; virtual;
     Procedure RepPrintHeader(Sender  :  TObject); Virtual;
     Procedure RepPrint(Sender  :  TObject); Virtual;
  private
     oData : IIntrastatDataClass;

     // Cached SQL Emulator info to reduce overhead
     CompanyCode         : AnsiString;
     ConnectionString    : WideString;  //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

     FShowTransportMode : Boolean;
     FShowDeliveryTerms : Boolean;
     Procedure PrintTotals;
     Function GetReportInput  :  Boolean; Virtual;
     Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;
  public
     MaxProgress         : LongInt;
     ReportParameters    : PostRepParam;

     ReportParams           :  TIntrastatParametersRec;

     Constructor Create(AOwner  :  TObject);
     Destructor  Destroy; Virtual;

     Procedure PrintReportLine; Virtual;
     Procedure PrintEndPage; Virtual;

     Procedure Process; Virtual;
     Procedure Finish;  Virtual;
  End;

  //CSV export object
  TIntrastatCSVExporter = Object(TThreadQueue)
  private
     oData : IIntrastatDataClass;
     FFile : TextFile;
     CompanyCode         : AnsiString;
     ConnectionString    : WideString;   //VA:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

     function WriteLine : Integer;
     function WriteHeader : Integer;
     function GetPeriodString : string;
  public
     FileName : string;
     ReportParams : TIntrastatParametersRec;
     Constructor Create(AOwner  :  TObject);
     Destructor  Destroy; Virtual;
     Procedure Process; Virtual;
     Procedure Finish; Virtual;
     function CreateFile : Boolean;
  end;



Procedure RunUKIntrastatReport(Parameters :  TIntrastatParametersRec;
                               AOwner    :  TObject);

Procedure RunUKIntrastatCSVExport(Parameters :  TIntrastatParametersRec;
                                  AOwner    :  TObject);


implementation

uses
    SQLUtils, RpDefine, Comnu2, ETDateU, ETMiscU, ETStrU, BTKeys1U, CurrncyU,
    SysU1, ExThrd2U, BTSupU1, BTSupU2, SalTxl1U, ComnUnit,
    SQLRep_Config, EntLoggerClass, oSystemSetup, StrUtil, ApiUtil;


// =============================================================================

Procedure RunUKIntrastatReport(Parameters :  TIntrastatParametersRec;
                               AOwner    :  TObject);
Var
  IntrastatReport       : ^TUKIntrastatReport;
Begin

  If (Create_BackThread) then
  Begin

    New(IntrastatReport,Create(AOwner));

    try
      With IntrastatReport^ do
      Begin
        ReportParams := Parameters;

       {$IFDEF EXSQL}
          if SQLUtils.UsingSQL then
             GetConnectionString(CompanyCode, False, ConnectionString);
       {$ENDIF}

        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(IntrastatReport,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(IntrastatReport,Destroy);
        end;
      end; {with..}

    except
      Dispose(IntrastatReport,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

Procedure RunUKIntrastatCSVExport(Parameters :  TIntrastatParametersRec;
                                  AOwner    :  TObject);
Var
  IntrastatExport       : ^TIntrastatCSVExporter;
Begin

  If (Create_BackThread) then
  Begin

    New(IntrastatExport,Create(AOwner));

    try
      With IntrastatExport^ do
      Begin
        ReportParams := Parameters;

        //Create csv file outside thread so we display error message if required
        if CreateFile then
        begin

         {$IFDEF EXSQL}
            if SQLUtils.UsingSQL then
               GetConnectionString(CompanyCode, False, ConnectionString);
         {$ENDIF}

          If (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(IntrastatExport,'Intrastat Export');
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(IntrastatExport,Destroy);
          end;

        end
          else (Dispose(IntrastatExport,Destroy));
      end; {with..}

    except
      Dispose(IntrastatExport,Destroy);

    end; {try..}
  end; {If process got ok..}

end;

Procedure TUKIntrastatReport.Process;
Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

  //Assign exlocal
  oData.isdExLocal := MTExLocal;

  InitStatusMemo(4);

  Try

    Inherited Process;

  finally

  end; {try..}
end;

Procedure TUKIntrastatReport.Finish;
Begin
  Inherited Finish;
end;

Constructor TUKIntrastatReport.Create(AOwner  :  TObject);
Begin
  Inherited Create(AOwner);

  //Get data object
  oData := GetIntrastatDataObject;
  FShowTransportMode := SystemSetup.Intrastat.isShowModeOfTransport;

  //PR: 29/01/2016 ABSEXCH-17205 v2016 R1
  FShowDeliveryTerms := SystemSetup.Intrastat.isShowDeliveryTerms;

end;


Destructor TUKIntrastatReport.Destroy;
Begin

  if Assigned(oData) then
    oData := nil;

  Inherited Destroy;
end;

function TUKIntrastatReport.GetReportInput: Boolean;
Var
  NYear,
  VSYr,VSPr  :  Integer;
Begin
  Begin
    ThTitle := 'Intra SSD';

    RepTitle := 'Intra EC Trade Statistics';

    PageTitle := Reptitle + ' ' + DirectionString[ReportParams.ISDirection] + ' - Supplementary Declaration - ' +
      SOutPeriod(ReportParams.Period, ReportParams.Year);

    //Set properties on data obejct
    oData.isdReportMode := ReportParams.ISReportMode;
    oData.isdReportDirection := ReportParams.ISDirection;
    oData.isdStartDate := ReportParams.StartDate;
    oData.isdEndDate := ReportParams.EndDate;

    //PR: 29/01/2016 ABSEXCH-17208 v2016 R1 Set out of period flag
    oData.isdOutOfPeriodOnly := ReportParams.OutOfPeriodOnly;

    RFont.Size:=7;


  end; {With..}

  Result:=BOn;
end;

Procedure TUKIntrastatReport.PrintTotals;
var
  LTotalValue : Double;
Begin
  with RepFiler1 do
  begin
    DefLine(-2,MarginLeft,PageWidth-MarginRight-1,0);
    DefFont (0,[fsBold]);
    LTotalValue := oData.isdTotalLessCreditNotes + oData.isdTotalCreditNotes;
    SendLine(Concat(#9, 'Total: ',#9,#9, FormatFloat(GenRNDMask,LTotalValue),
                    #9,#9,#9, FormatFloat(GenRNDMask,oData.isdTotalWeight),
                    #9, FormatFloat(GenRNDMask,oData.isdTotalSupplementaryUnits)));

    ClearTabs;
    SetTab (MarginLeft, pjLeft, 28, 4, 0, 0);
    SetTab (NA, pjRight, 20, 4, 0, 0);
    SetTab (NA, pjLeft, 120, 4, 0, 0);
    SetTabCount;

    //PR: 25/01/2016 ABSEXCH-17190 v2016 R1 Set tabs for excel if required
    If (RDevRec.fePrintMethod = 5 {XLSX}) Then
      SendTabsToXLSX(True {UpdateExistingTabs});
    SendLine(Concat(#9, 'Total Value: ',#9, FormatFloat(GenRNDMask,oData.isdTotalLessCreditNotes),
                    #9,'    Total Value (excluding Credit Notes) - Value of Credit Notes (NoTC 2nd digit = 6)'));
  end;
end;

Procedure TUKIntrastatReport.RepPrintHeader(Sender  :  TObject);
Begin

  With RepFiler1 do
  Begin

    If (CurrentPage=1) then
    Begin
      RepSetTabs;
    end;

    RepPrintPageHeader;

  end; {With..}
end;

// -----------------------------------------------------------------------------

procedure TUKIntrastatReport.RepPrintPageHeader;
Var
  GenStr  :  Str255;
  n       :  VATType;
  ClosedDate : String;
Begin
  With RepFiler1 do
  Begin
    DefFont (3,[fsBold]);

    Self.PrintLeft(Trim(PageTitle), MarginLeft);
    DefFont (3,[]);
    Self.PrintRight('Printed: ' +POutDate(EtDateU.Today) + ' - ' + FormatDateTime('hh:nn:ss', Time), PageWidth - MarginRight);
    Self.CRLF;
    DefFont (3,[fsBold]);

    //If closed date hasn't been set then show n/a rather than dd/mm/yyyy
    ClosedDate := IfThen(ReportParams.ISDirection = idDispatches, SystemSetup.Intrastat.isLastClosedDispatchesDate,
                             SystemSetup.Intrastat.isLastClosedArrivalsDate);
    if not ValidDate(ClosedDate) then
      ClosedDate := 'N/A'
    else
      ClosedDate := POutDate(ClosedDate);

    Self.PrintLeft('Intrastat Report Dates: ' + POutDate(ReportParams.StartDate) + ' - ' +
                    POutDate(ReportParams.EndDate) + '; Closed Date: ' +
                    ClosedDate, MarginLeft);

    DefFont (3,[]);
    Self.PrintRight(Concat('User : ',Trim(EntryRec^.Login),'. Page : ',IntToStr(CurrentPage),
                           ' of ',Macro(midTotalPages)), PageWidth - MarginRight);
    Self.CRLF;

    DefFont (3,[fsBold]);

    Self.PrintLeft('Trader VAT Reg No: ' + Syss.UserVATReg, MarginLeft);
    ClearTabs;
    RepSetTabs;
    DefFont(0,[fsBold]);

    Self.CRLF;
    Self.CRLF;

    SendLine(ConCat(#9,'Line'#9,'Commodity',#9,'Value',#9,IfThen(FShowDeliveryTerms,'Deliv',''),
                    #9,' ',#9,'Net',#9,'Supplementary',#9,IfThen(ReportParams.ISDirection = idDispatches, 'To', 'From'),
                    #9,'Traders',#9,IfThen(FShowTransportMode,'Mode of',''),#9,#9,IfThen(ReportParams.IsReportMode = irmAudit, 'Stock', '')));

    SendLine(ConCat(#9,'No'#9,'code',#9,'Sterling',#9,IfThen(FShowDeliveryTerms,'terms',''),#9,'NoTC',
                    #9,'Mass(kg)',#9,'units',#9,'Ctry',#9,'reference',
                    #9,IfThen(FShowTransportMode, 'Transport', ''),#9,#9,IfThen(ReportParams.IsReportMode = irmAudit, 'Code', '')));

    DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


// -----------------------------------------------------------------------------

procedure TUKIntrastatReport.RepSetTabs;
begin
  With RepFiler1 do
  Begin
    ClearTabs;

    SetTab (MarginLeft, pjLeft, 10, 4, 0, 0);   // Line number
    SetTab (NA, pjLeft, 18, 4, 0, 0);           // Commodity Code
    SetTab (NA, pjRight, 20, 4, 0, 0);          // Value
    SetTab (NA, pjLeft, 12, 4, 0, 0);           // Delivery Terms
    SetTab (NA, pjLeft, 10, 4, 0, 0);           // NoTC
    SetTab (NA, pjRight, 15, 4, 0, 0);          // Net Weight
    SetTab (NA, pjRight, 22, 4, 0, 0);          // Supplementary units
    SetTab (NA, pjLeft, 14, 4, 0, 0);           // Country
    SetTab (NA, pjLeft, 18, 4, 0, 0);           // Traders reference //PR: 25/01/2016 ABSEXCH-17194 v2016 R1Widened field
    SetTab (NA, pjLeft, 15, 4, 0, 0);           // Transport Mode
    SetTab (NA, pjLeft, 4, 4, 0, 0);            // Process/Out of period
    SetTab (NA, pjLeft, 25, 4, 0, 0);           // Stock Code
  end; {With..}

  SetTabCount;

  //PR: 25/01/2016 ABSEXCH-17190 v2016 R1 Set tabs for excel if required
  If (RDevRec.fePrintMethod = 5 {XLSX}) Then
    SendTabsToXLSX(False {UpdateExistingTabs});

end;

Procedure TUKIntrastatReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  if (ReportParams.ISReportMode in [irmDetailed, irmAudit]) then
  With MTExLocal^ do
  Begin
    SendRepDrillDown(1,TotTabs,1,oData.isdOurRef,InvF,InvOurRefK,0);

    SendRepDrillDown(2,2,2,oData.isdStockCode,StockF,StkCodeK,0);
    SendRepDrillDown(6,7,2,oData.isdStockCode,StockF,StkCodeK,0);

    if ReportParams.ISReportMode = irmAudit then //StockCode column
      SendRepDrillDown(12,12,2,oData.isdStockCode,StockF,StkCodeK,0);
  end; {With..}
end;

Procedure TUKIntrastatReport.PrintReportLine;
Var
  Rnum,
  Rnum2      :  Real;
  Lnum       :  LongInt;
  n,TmpDecs,
  TmpDecs2   :  Byte;
  RepCnst    :  Integer;
  LineTot,
  TmpTot     :  AgedTyp;
  GenStr     :  Str80;
  TriInd,
  Cntry      :  Str10;
  TBo,
  Ok2Print   :  Boolean;
  UWeight,
  StatUplift :  Double;
  LineAgg,
  TmpLineAgg :  TAggSSD;
  ThisLine : string;
  SuppUnitString : string;
Begin

  With RepFiler1 do
  Begin
    SetReportDrillDown(0);

    //If auditing then put line for section total
    if (ReportParams.ISReportMode = irmAudit) and (oData.isdAggregated) then
    begin
      DefLine(-1,MarginLeft,PageWidth-MarginRight-1,0);
      DefFont(0,[fsBold]);
    end;

    //Only include supp units if the string value is populated
    If Trim(oData.isdSupplementaryUnitsString) <> '' then
      SuppUnitString := FormatBFloat(GenRNDMask,oData.isdSupplementaryUnits,BOn) + ' ' +
                         oData.isdSupplementaryUnitsString
    else
      SuppUnitString := '';

    SendLine(ConCat(#9,IfThen(oData.isdLineNumber > 0, Form_Int(oData.isdLineNumber,0), ''),
            #9,oData.isdCommodityCode,
            #9,FormatFloat(GenRNDMask,oData.isdValue),
            #9,oData.isdDeliveryTerms,
            #9,oData.isdNatureOfTransaction,
            #9,FormatFloat(GenRNDMask,oData.isdWeight),
            #9,SuppUnitString,
            #9,oData.isdCountry,
            #9,oData.isdOurRef,
            #9,IfThen(FShowTransportMode, oData.isdTransportMode, ''),
            #9,IfThen(oData.isdOutOfPeriod, '*', oData.isdProcess),
               //Only include stock code if audit report
            #9,IfThen(ReportParams.ISReportMode = irmAudit, oData.isdStockCode,'')));


    //If audit then change font after printing aggregated total
    if (ReportParams.ISReportMode = irmAudit)  and (oData.isdAggregated) then
    begin
      Self.CRLF;
      DefFont(0,[]);
    end;

  end;
end;

Procedure TUKIntrastatReport.PrintEndPage;
Var
  TmpRepMode  :  Integer;
Begin
  PrintTotals;
end;

//Main print procecure
procedure TUKIntrastatReport.RepPrint(Sender: TObject);
var
  Res : Integer;
begin
  ShowStatus(2,'Processing Report.');

  With RepFiler1 do
  Begin
    //Load the data for the report
    Res := oData.LoadData;

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;


    Res := oData.GetFirst;
    While (Res = 0) and (Not RepAbort) do
    Begin
      ThrowNewPage(5);

      PrintReportLine;

      Inc(ICount);
      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      Res := oData.GetNext;

      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}

    ThrowNewPage(5);

    PrintEndPage;
  end; {With..}

end;

{ TIntrastatCSVExporter }

constructor TIntrastatCSVExporter.Create(AOwner: TObject);
var
  FilesOK : Boolean;
begin
  FilesOK := True;
  Inherited Create(AOwner);

  If (Not Assigned(RepExLocal)) then { Open up files here }
    FilesOK:=Create_ReportFiles;

  If (FilesOK) then
    MTExLocal:=RepExLocal;

  //Get data object
  oData := GetIntrastatDataObject;
end;

function TIntrastatCSVExporter.CreateFile: Boolean;
const
  DIR_STRING = 'Reports\Intrastat\';
var
  i : integer;
  ThisFilename : string;
begin
  Result := False;
  //Check that the output directory exists; if not, try to create it; if can't create then abort;
  if not DirectoryExists(SetDrive + DIR_STRING) then
    if not CreateDir(SetDrive + DIR_STRING) then
    begin
      msgBox('Directory ' + SetDrive + DIR_STRING + 'does not exist and'#10 +
             'it was not possible to create it.', mtError, [mbOK], mbOK, 'Intrastat Export');
      EXIT;
    end;

  //Find a unique file name
  i := 1;
  FileName := SetDrive + DIR_STRING + GetCompanyCode(SetDrive) + '-Intrastat' +
              DirectionString[ReportParams.ISDirection] + GetPeriodString;
  ThisFilename := FileName;

  //If the file already exists then add (n) to end until we find a name that doesn't exist.
  while FileExists(ThisFilename + '.csv') do
  begin
    inc(i);
    ThisFileName := Filename + '(' + IntToStr(i) + ')';
  end;

  //Create file for writing
  Try
    Filename := ThisFilename + '.csv';
    AssignFile(FFile, Filename);
    Rewrite(FFile);
    Result := True;
  Except
    on E:Exception do
    begin
      msgBox('Unable to create file ' + Filename + '. Exception: '#10 + E.Message,
             mtError, [mbOK], mbOK, 'Intrastat Export');
    end;
  End;
end;

destructor TIntrastatCSVExporter.Destroy;
begin
  oData := nil;
  inherited;
end;

procedure TIntrastatCSVExporter.Finish;
begin
  MTExLocal.LThShowMsg(nil, 0, 'Report written to ' + Filename);

  //PR: 10/02/2016 v2016 R1 ABSEXCH-17278 Close file, set read-only and show in explorer
  if FileExists(Filename) then
  begin
    CloseFile(FFile);
    FileSetAttr(FileName, faReadOnly);

    RunApp('explorer.exe /select,' + WingetShortPathName(Filename), False{Don't wait});

  end;

  inherited;
end;

function TIntrastatCSVExporter.GetPeriodString: string;
begin
  Result := Copy(ReportParams.StartDate, 5, 2) + Copy(ReportParams.StartDate, 3, 2);
end;

procedure TIntrastatCSVExporter.Process;
var
  Res : Integer;
begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

  InitStatusMemo(4);
  //Set properties on data object
  oData.isdReportMode := ReportParams.ISReportMode;
  oData.isdReportDirection := ReportParams.ISDirection;
  oData.isdStartDate := ReportParams.StartDate;
  oData.isdEndDate := ReportParams.EndDate;

  //Assign exlocal
  oData.isdExLocal := MTExLocal;


  //Execute the data object
  oData.LoadData;

  //Write the header.
  WriteHeader;
  Res := oData.GetFirst;

  while Res = 0 do
  begin
    WriteLine;

    Res := oData.GetNext;
  end;
end;

function TIntrastatCSVExporter.WriteHeader: Integer;
var
  OutString : string;
  CompanyName : string;
begin
  Result := 0;
  CompanyName := AnsiReplaceStr(Syss.UserName, ',', #32);

  OutString := ArrayOfStringToString(['T',
                                      RemoveAllChars(Copy(Syss.UserVATReg, 3, Length(Syss.UserVATReg)), #32),
                                      '',
                                      UpperCase(LeftStr(CompanyName, 30)),
                                      IfThen(oData.isdCount > 0, 'X', 'N'),
                                      DirectionChar[ReportParams.ISDirection],
                                      FormatDateTime('ddmmyy', SysUtils.Date),
                                      GetPeriodString,
                                      'CSV02'], False, ',');

  WriteLn(FFile, OutString);
end;

function TIntrastatCSVExporter.WriteLine: Integer;
const
  ThisMask = '##########0';
var
  OutString : string;
begin
  Result := 0;
  OutString := ArrayOfStringToString([oData.isdCommodityCode,
                                      FormatFloat(ThisMask,oData.isdValue),
                                      oData.isdDeliveryTerms,
                                      oData.isdNatureOfTransaction,
                                      FormatFloat(ThisMask,oData.isdWeight),
                                      FormatBFloat(ThisMask,oData.isdSupplementaryUnits, True),
                                      oData.isdCountry,
                                      oData.isdOurRef], False, ',');
  WriteLn(FFile, OutString);
end;

End.

