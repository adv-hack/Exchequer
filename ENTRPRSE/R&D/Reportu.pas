unit ReportU;

{$I DEFOVR.Inc}


interface

// MH 08/01/2016 2016-R1 ABSEXCH-10720: Only include the .XLSX support in projects that
// need it to reduce compilation errors in other components, e.g. Scheduler, Sentimail...
{$IF Defined(Enter1)}
  {$DEFINE XLSXSupport}
{$IFEND}

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls, StrUtils,
  StdCtrls,ExtCtrls,Grids,GlobVar,VarConst,BtrvU2,BTSupU3,ExBtTh1U,{Printers,}
  RPBase,RpDefine,RpDevice, RpFiler,

  {$IFNDEF RW}
    Recon3U,
  {$ENDIF}

  {$IFDEF FRM}
    FrmThrdU,
  {$ENDIF}

  {$IFDEF XLSXSupport}
  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Added the Export To Excel sub-object for printing to .xlsx
  RepExcelExport,

  //PR: 25/06/2016 2016-R3 ABSEXCH-17645 Need to read ini file for fix for out of memory error in export to .xlsx
  IniFiles,
  {$ENDIF XLSXSupport}

  // MH 04/10/2013 MRD1.1.27: Added report filter on account types
  ConsumerUtils,

  Scrtch2U,
  uReportParams;


//PR: 22/10/2009 Added some constants to make identitfying Report Modes easier for Parameter Printing.
const
  //PL 18/04/2017 2017-R1 ABSEXCH-18497 Std. Report: New Menu Positions
  rmStockValuationLive  = 4;
  rmStockValuationPosted= 5;
  rmStockAging          = 44;
  rmTrialBalanceSet     = [1, 8, 10, 80];
  rmGLHistory           = 2;
  rmStockTakeList       = 2;
  rmNominalAuditTrail   = 3;
  rmDocumentAuditTrail  = 7;




type

  TRecordAddress = class(TObject)
  private
    FAddress: LongInt;
  public
    constructor Create(WithAddress: LongInt);
    property Address: LongInt read FAddress write FAddress;
  end;

  TGenReport  =  Object(TThreadQueue)
                       RepFiler1   :  TReportFiler;

                       Procedure RAfterPrint(Sender  :  TObject);

                       Procedure RBeforePrint(Sender  :  TObject);

                       Procedure RNewPage(Sender  :  TObject);


                       Procedure RPrint(Sender  :  TObject);

                       Procedure RPrintFooter(Sender  :  TObject);

                       Procedure RPrintHeader(Sender  :  TObject);

                       Function RPrintPage(Sender  :  TObject;
                                      var PageNum  :  Integer)  :  Boolean;


                       Procedure RepAfterPrint(Sender  :  TObject); Virtual;

                       Procedure RepBeforePrint(Sender  :  TObject); Virtual;

                       Procedure RepNewPage(Sender  :  TObject); Virtual;

                       Function RepPrintExcelTotals  :  Boolean;

                       Procedure RepPrint(Sender  :  TObject); Virtual;

                       Procedure RepPrintFooter(Sender  :  TObject); Virtual;

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Function RepPrintPage(Sender  :  TObject;
                                        var PageNum  :  Integer)  :  Boolean; Virtual;


                       // MH 05/01/2016 2016-R1 ABSEXCH-10720: Helper methods for printing to XLSX files
                       // Replacement for call to RAVE TBaseReport.CRLF that redirects it to the XLSX conversion thingie
                       Procedure CRLF;
                       // Replacement for call to RAVE TBaseReport.PrintCentre that redirects it to the XLSX conversion thingie
                       procedure PrintCenter(Text: string; Pos: double);
                       // Replacement for call to RAVE TBaseReport.PrintLeft redirects it to the XLSX conversion thingie
                       Procedure PrintLeft(Text: string; Pos: double);
                       // Replacement for call to RAVE TBaseReport.PrintRight redirects it to the XLSX conversion thingie
                       procedure PrintRight(Text: string; Pos: double);
                       // Takes the tab settings from the report and passes them into the XLSX thingie to setup
                       // the column widths and alignment
                       Procedure SendTabsToXLSX (Const UpdateExistingTabs : Boolean);
                       // Replacement for call to RAVE TBaseReport.Print redirects it to the XLSX conversion thingie
                       // Appends text to the current cell
                       procedure Print(Text: string);
                     private

                       LocalPrinterIndex,
                       TestLoop   :  Integer;

                       {$IFDEF LTE}
                       LBitMap    :  TBitMap;
                       {$ENDIF}

                       // MH 05/01/2016 2016-R1 ABSEXCH-10720: Added the Export To Excel sub-object for printing to .xlsx
                       {$IFDEF XLSXSupport}
                       ExportToExcel : TExportReportToExcel;
                       {$ENDIF XLSXSupport}
                     public
                       RDelSwapFile,
                       RNoPageLine,
                       RUseForms  :  Boolean;
                       {RCopies    :  Integer;}
                       RFont      :  TFont;
                       ROrient    :  TOrientation;
                       RForm      :  Str10;

                       RDevRec    :  TSBSPrintSetupInfo;

                       ReportMode:  Byte;

                       // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
                       FilteringMode : Integer;

                       TotTabs,
                       RepLen,
                       RepLenCnst,
                       B_Start,
                       B_Next    :  SmallInt;

                       RFnum,
                       RKeyPath  :  Integer;


                       {RPrinterNo :  Integer;
                       RToPrinter :  Boolean;}

                       RCount,
                       ICount    :  LongInt;

                       ThTitle,
                       PageTitle,
                       RepTitle,
                       RepTitle2,
                       TmpSwapFileName,
                       KeyS,
                       // MH 06/01/2014 v7.0.8 ABSEXCH-14908: Added RepStartKey to allow reports to jump into a specific key for the starting location
                       //                                     which can be longer than the RepKey filter being assigned
                       RepStartKey,
                       RepKey    :  Str255;

                       HideRecCount,
                       RepAbort,
                       NoDeviceP :  Boolean;

                       ReportParam,
                       RepORecPtr,
                       RepObjPtr :  Pointer;


                       {$IFDEF FRM}
                         eCommFrmList
                                 :  TeCommFrmList;
                       {$ENDIF}

                       {$IFDEF REPPFC}
                         UseSQLPrefillCache : Boolean;
                         SQLPrefillCacheID : LongInt;
                         SQLWhereClause : ANSIString;
                         SQLColumns : ANSIString;
                       {$ENDIF}
                       bIsSQLReport : Boolean;
                       bPrintParams : Boolean;
                       oPrintParams : TReportParameters;
                       Procedure ParamPrint(ThisLine  :  String);
                       procedure ParamNewPage(Sender : Tobject);
                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure SetReportMargins;

                       Function InitRep1  :  Boolean;

                       Procedure DelSwpFile;

                       procedure DefFont (Const FontSze    : Integer;
                                          Const FontStyle  : TFontStyles);

                       Procedure DefLine(Const PWidth,
                                               LStart,
                                               LWidth,
                                               AHeight  :  Double);

                       Procedure SendText(ThisLine  :  String);

                       Procedure SendLine(ThisLine  :  String);

                       Procedure SetTabCount;

                       Procedure SendRepSubHedDrillDown(X1,X2        :  Double;
                                                        TLevel       :  Byte;
                                                        DKey         :  Str255;
                                                        DFnum,DKP    :  SmallInt;
                                                        DMode        :  Byte);


                       Procedure SendRepDrillDown(TStart,TEnd  :  Integer;
                                                  TLevel       :  Byte;
                                                  DKey         :  Str255;
                                                  DFnum,DKP    :  SmallInt;
                                                  DMode        :  Byte);

                       Function GetReportInput  :  Boolean; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       function RPJust2DT(RPJust  :  TPrintJustify)  :  Byte;

                       Procedure RPJustXY(Var TX,TY       :  Integer;
                                        Const ThisRect  :  TRect;
                                        Const RPJust    :  TPrintJustify);

                       Procedure PrintHedTit; Virtual;

                       Procedure PrintStdPage; Virtual;

                       Procedure ThrowNewPage(LinesRemain  :  Integer);

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       function MatchProc(B_Func  :  SmallInt;
                                          BKey    :  Str255)  :  SmallInt; Virtual;

                       Procedure PrintEndPage; Virtual;

                       function ChkRepAbort  :  Boolean; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                       Function Start  :  Boolean; Virtual;

                       // MH 22/02/2012 v6.10 ABSEXCH-12025: Modified to support a new clearer layout
                       Procedure PrintCustLine(Const Ccode  :  Str10;
                                               Const Cont   :  Boolean;
                                               Const UseClearerFormat : Boolean = False);


                       {$IFDEF LTE}

                         Function LCheckParentRV(GLCat  :  LongInt;
                                                 Mode   :  Byte;
                                             Var Level  :  LongInt)  :  Boolean;
                       {$ENDIF}

                       Procedure PrintNomLine(Const Ccode  :  Str10;
                                              Const Cont   :  Boolean);

                       {$IFDEF STK}
                         Procedure PrintStkLine(Const Ccode  :  Str20;
                                                Const Cont   :  Boolean);

                         Function Stk_InGroup(StkGroup  :  Str20;
                                              StockR    :  StockRec)  :  Boolean;

                         {$IFDEF SOP}
                            Function MLocRepTitle(Lc  :  Str10)  :  Str80;

                         {$ENDIF}

                       {$ENDIF}

                       {$IFDEF JC}

                         Procedure PrintEmplLine(Const ECode  :  Str10;
                                                 Const Cont   :  Boolean);

                         Procedure PrintJobLine(Const JCode  :  Str10;
                                                Const Cont   :  Boolean);

                         {* Similar routine exisits in JobPostU *}
                         Function LRepGetJobMisc(ACode  :  Str10;
                                                  GMode  :  Byte)  :  Boolean;


                         Function LGet_StdPR(ThisCode  :  Str20;
                                             Fnum,
                                             Keypath,
                                             GMode     :  Integer)  :  Boolean;

                         Function LGet_StdPRDesc(ThisCode  :  Str20;
                                                 Fnum,
                                                 Keypath,
                                                 GMode     :  Integer)  :  Str255;

                         Function LJob_InGroup(JobGroup  :  Str20;
                                               JobR      :  JobRecType)  :  Boolean;

                       {$ENDIF}


                       Function  Get_OCBal(NomType  :  Char;
                                           NomCode  :  Str10;
                                           Rcr,
                                           NYr,NPr,
                                           Mode     :  Byte;
                                           CloseBal :  Boolean)  :  Double;

                       Function  Send_FrmPrint(      ecPrnInfo    : TSBSPrintSetupInfo;
                                               Const ecDefMode    : Integer;
                                               Const ecFormName   : ShortString;
                                               Const ecMFN, MKP   : Integer;
                                               Const ecMKeyRef    : Str255;
                                               Const ecTFN, TKP   : Integer;
                                               Const ecTKeyRef    : Str255;
                                               Const ecDescr      : ShortString;
                                               Const ecAddBatchInfo
                                                                  : StaCtrlRec;
                                               Const ProcessErr   : Boolean;
                                               Const ecCommMode   : Byte)  :  Boolean;


                       Function Being_Posted(Const LMode  :  Byte)  :  Boolean;

                       Function TB_Difference  :  Double;

                       Procedure Print_WarnDifference(RepDiff  :  Double;
                                                      ErrRunNo :  LongInt;
                                                      WriteLog :  Boolean);

                   end; {Class..}


{$IFNDEF RW}
  TADebReport  =  Object(TGenReport)

                       Procedure PrintMDNomLine(Const Ccode  :  Str10;
                                                Const Cont   :  Boolean);

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       TotalPostedBalance : Double;
                       FTraderAcCode,
                       FTraderCompany,
                       FTraderPhone       : ShortString;      // SSK 05/04/2017 2017-R1 ABSEXCH-18439: new variables declared

                       FSummaryRecCount   : integer;          // SSK 05/04/2017 2017-R1 ABSEXCH-18439: variable for Summary report record count
                       // MH 04/10/2013 MRD1.1.29: Added report filter on account types
                       oTraderCache : TTraderCache;

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure Print_EuroConv;

                     public
                       CRepParam  :  DueRepPtr;
                       IsMDC,
                       IsPay      :  Boolean;
                       EuroConv_Detected
                                  :  Boolean;

                       TmpLastC   :  Str10;
                       TmpLastNC  :  LongInt;


                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Function Calc_PrevAgedBal(InvR  :  InvRec;
                                                 RPr,RYr,
                                                 RCr   :  Byte;

                                                 MTyp  :  Char;

                                                 OldKPath
                                                       :  Integer;

                                                 ANow  :  Boolean)  :  Double;

                       Function IncludePayType  :  Boolean;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintDueTot(GMode     :  Byte);

                       Procedure CalcDueTotals(CrDr      :  DrCrType;
                                               SD,SDA    :  Real);


                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;
                       Procedure PrintDuesSummary(pMode: byte);    // SSK 05/04/2017 2017-R1 ABSEXCH-18439: this will Print Lines for Dues Summary Report

                   end; {Class..}



  TMDCReport  =  Object(TADebReport)

                       procedure RepBeforePrint(Sender: TObject); Virtual;
                       procedure RepPrint(Sender: TObject); Virtual;

                     private
                       ExtCustObj :  GetExNObjCid;
                       ExtCustRec :  ExtCusRecPtr;
                       AddressList: TStringList;
                       AddressListIndex: Integer;


                       Procedure Build_MDCAgedDoc(Var FoundOk  :   Boolean);

                       Procedure Build_MDCAgeCust(Var FoundOk    :  Boolean);

                       procedure ClearAddressList;
                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;


                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;

                   end; {Class..}


  TStaReport  =  Object(TGenReport)


                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       CustAlObj  :  GetExNObjCid;

                       Function GetReportInput  :  Boolean; Virtual;

                        function RightFEAcc(Const SFiltBy,StatDMode  :  Byte)  :  Boolean;

                     public
                       CRepParam  :  CustRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure Add_Match2Sta(StaCtrl  :  StaCtrlRec;
                                               InvR     :  InvRec;
                                               Fnum,
                                               Keypath,
                                               Fnum2,
                                               Keypath2,
                                               KeyPathI :  Integer);

                       Procedure Build_Statement(StaCtrl  :  StaCtrlRec;
                                                 Fnum,
                                                 Keypath  :  Integer);

                       Procedure Process_AutoCustNotes(Fnum,KeyPath  :  Integer;
                                                       CCode         :  Str10;
                                                       NDate         :  LongDate;
                                                       NDesc         :  Str80);

                       Procedure Add_AutoNotes(NoteType,
                                               NoteSType  :  Char;
                                               FolioCode  :  Str10;
                                               NDate      :  LongDate;
                                               NDesc      :  Str80;
                                           Var DLineCount :  LongInt);

                       function Get_LetterDesc  :  Str255;

                       Function IncDocInStat(DVal  :  Double)  :  Boolean;

                       Function  LCustBal_OS(CustCode  :  Str10;
                                             CSupp     :  Char;
                                             CustBal   :  Real;
                                             CompDate  :  LongDate)  :  Boolean;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


  // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
  Procedure AddGenRep2Thread(      LMode                 : Byte;
                                   AOwner                : TObject;
                             Const OptionalFilteringMode : Integer = -1);

  Procedure AddADebRep2Thread(LMode    :  Byte;
                              IsCust   :  Boolean;
                              IRepParam:  DueRepPtr;
                              AOwner   :  TObject);

  Procedure AddAMDCRep2Thread(LMode    :  Byte;
                              IsCust   :  Boolean;
                              IRepParam:  DueRepPtr;
                              AOwner   :  TObject);

  Procedure AddStaRep2Thread(LMode    :  Byte;
                             IRepParam:  CustRepPtr;
                             AOwner   :  TObject);

  Procedure Test_Report(AOwner  :  TObject);

  function FormatGLRange(GLStart, GLEnd : longint) : String;
{$ENDIF} { RW }
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  TEditVal,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTSFrmU1,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,

  {$IFNDEF RW}
    DocSupU1,
  {$ENDIF}

  VarRec2U,


  {$IFDEF FRM}
    GlobType,
    DLLInt,
    PrintFrm,

    PrntDlg2,
  {$ENDIF}

  {$IFDEF C_On}
    NoteSupU,
  {$ENDIF}

  {$IFDEF JC}
    VarJCstU,
  {$ENDIF}

  InvListU,
  {$IFNDEF RW}
  LedgSupU,
  LedgSu2U,
  SalTxl1U,

  ExThrd2U,
  Event1U,

  {$ENDIF}


  {$IFNDEF RW}
    {$IFNDEF XO}
      {$IFNDEF OLE}
        {$IFNDEF EDLL}
          {$IFNDEF ENDV}
            {$IFNDEF EXDLL}
              {$IFNDEF COMP}
                {$IFNDEF EBAD}
                  Excep2U,
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}

  // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
  AccountContactRoleUtil,

  RpMemo,
  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}
  ExWrap1U,
  BtSupU2;


{$IFDEF REPMETRICS}
Var
  DebugList : TStringList;
{$ENDIF}

Var
  MDCADCalled, MDCADFail1, MDCADFail2, MDCACIncluded : Integer;

//PR: 22/10/2009 Added for parameter printing
function FormatGLRange(GLStart, GLEnd : longint) : String;
begin
  if (GLStart = 0) and ((GLEnd = 0) or (GLEnd = MaxInt)) then
    Result := ''
  else
  if ((GLEnd = 0) or (GLEnd = MaxInt)) then
    Result := IntToStr(GLStart) + ' to End'
  else
    Result := Format('%d to %d', [GLStart, GLEnd]);
end;


//-------------------------------------------------------------------------

// Replacement for call to RAVE TBaseReport.CRLF that redirects it to the XLSX conversion thingie
Procedure TGenReport.CRLF;
Begin // CRLF
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the XLSX conversion thingie to move to the next row
    ExportToExcel.EndLine
  Else
  {$ENDIF XLSXSupport}
    RepFiler1.CRLF;
End; // CRLF

//------------------------------

// Replacement for call to RAVE TBaseReport.Print redirects it to the XLSX conversion thingie
// Appends text to the current cell
procedure TGenReport.Print(Text: string);
Begin // Print
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the XLSX conversion thingie to print the text centred at the specified MM position
    ExportToExcel.Print(Text, RepFiler1.FontName, RepFiler1.FontSize, RepFiler1.Bold, RepFiler1.Italic, RepFiler1.UnderLine)
  Else
  {$ENDIF XLSXSupport}
    RepFiler1.Print(Text);
End; // Print

//------------------------------

// Replacement for call to RAVE TBaseReport.PrintCentre that redirects it to the XLSX conversion thingie
procedure TGenReport.PrintCenter(Text: string; Pos: double);
Begin // PrintCenter
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the XLSX conversion thingie to print the text centred at the specified MM position
    ExportToExcel.PrintCenter(Text, Pos, RepFiler1.FontName, RepFiler1.FontSize, RepFiler1.Bold, RepFiler1.Italic, RepFiler1.UnderLine)
  Else
  {$ENDIF XLSXSupport}
    RepFiler1.PrintCenter(Text, Pos);
End; // PrintCenter

//------------------------------

// Replacement for call to RAVE TBaseReport.PrintLeft redirects it to the XLSX conversion thingie
Procedure TGenReport.PrintLeft(Text: string; Pos: double);
Begin // PrintLeft
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the XLSX conversion thingie to print the text left aligned (i.e. column 0)
    ExportToExcel.PrintLeft(Text, RepFiler1.FontName, RepFiler1.FontSize, RepFiler1.Bold, RepFiler1.Italic, RepFiler1.UnderLine)
  Else
  {$ENDIF XLSXSupport}
    RepFiler1.PrintLeft(Text, Pos);
End; // PrintLeft

//------------------------------

// Replacement for call to RAVE TBaseReport.PrintRight redirects it to the XLSX conversion thingie
procedure TGenReport.PrintRight(Text: string; Pos: double);
Begin // PrintRight
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the XLSX conversion thingie to print the text right aligned (i.e. last column)
    ExportToExcel.PrintRight(Text, RepFiler1.FontName, RepFiler1.FontSize, RepFiler1.Bold, RepFiler1.Italic, RepFiler1.UnderLine)
  Else
  {$ENDIF XLSXSupport}
    RepFiler1.PrintRight(Text, Pos);
End; // PrintRight

//------------------------------

// Takes the tab settings from the report and passes them into the XLSX thingie to setup
// the column widths and alignment
Procedure TGenReport.SendTabsToXLSX (Const UpdateExistingTabs : Boolean);
{$IFDEF XLSXSupport}
Var
  I : Integer;
{$ENDIF XLSXSupport}
Begin // SendTabsToXLSX
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
  Begin
    ExportToExcel.MarginLeft := RepFiler1.MarginLeft;
    For I := 1 To RepFiler1.GetTabCount Do
    Begin
      // Note: Excel starts off at Column 0 and widths are specified in MM
      ExportToExcel.SetColumnWidth(I - 1, Round(RepFiler1.TabWidth(I)), RepFiler1.GetTab(I).Justify, UpdateExistingTabs);
    End; // For I
  End // If Assigned(ExportToExcel)
  {$ENDIF XLSXSupport}
End; // SendTabsToXLSX

//-------------------------------------------------------------------------

{ ========== TGenReport methods =========== }

Procedure TGenReport.ParamPrint(ThisLine  :  String);
begin
  with RepFiler1 do
  begin
    ThrowNewPage(5);
    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    SendLine(ThisLine);
  end;
end;

Constructor TGenReport.Create(AOwner  :  TObject);

Const
  {$IFDEF LTE}
    RepLogo = 'IAOLOG_1';
  {$ELSE}
    RepLogo = 'ENTLOG_1';
  {$ENDIF}

Begin
  Inherited Create(AOwner);

  bIsSQLReport := False;

  fTQNo:=2;
  fCanAbort:=BOn;
  fPrintJob:=BOn;

  fOwnMT:=BOff; {* This must be set if MTExLocal is created/destroyed by thread *}

  MTExLocal:=nil;

  RFnum:=0;
  RKeypath:=0;
  RepLen:=0;
  RepLenCnst:=0;
  ICount:=0;
  RCount:=0;
  ReportMode:=0;
  TestLoop:=0;
  RepAbort:=BOff;
  NoDeviceP:=BOff;
  HideRecCount:=BOff;

  // MH 06/01/2014 v7.0.8 ABSEXCH-14908: Added RepStartKey to allow reports to jump into a specific key for the starting location
  //                                     which can be longer than the RepKey filter being assigned
  RepStartKey := '';

  {RPrinterNo:=-1;
  RToPrinter:=BOff;
  RCopies:=1;}

  FillChar(RDevRec,Sizeof(RDevRec),0);

  {RPDev.DeviceIndex:=-1;  Needs to be done properly in v4.40

  RDevRec:=RPDev.SBSSetUpInfo;}

  RDelSwapFile:=BOff;

  FillChar(TmpSwapFileName,Sizeof(TmpSwapFileName),0);

  With RDevRec do
  Begin
    DevIdx:=-1;
    Preview:=BOn;
    NoCopies:=1;
  end;

  LocalPrinterIndex:=-1;

  RUseForms:=BOff;

  RNoPageLine:=BOff;

  RForm:='';

  B_Start:=B_GetGEq;
  B_Next:=B_GetNext;

  ThTitle:='';
  RepTitle2:='';
  RepTitle:='';
  PageTitle:='';

  RepKey:='';
  KeyS:='';

  ReportParam:=nil;
  RepORecPtr:=nil;
  RepObjPtr:=nil;

  // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
  FilteringMode := -1;

  RepFiler1:=TReportFiler.Create(Application.MainForm);

  {$IFDEF FRM}
    eCommFrmList:=nil;
  {$ENDIF}

  RFont:=TFont.Create;

  try
    RFont.Assign(Application.MainForm.Font);
  except
    RFont.Free;
    RFont:=nil;
  end;

  ROrient:=RPDefine.PoPortrait;

  {$IFDEF LTE}
  LBitMap:=TBitMap.Create; {*Disabled, as caused printing to printer to make machine VERY slow }
  try
    LBitMap.Handle:=LoadBitMap(HInstance,RepLogo);
  except
    LBitMap.Free;
    LBitMap:=nil;
  end;
  {$ENDIF}

  {$IFDEF REPPFC}
    UseSQLPrefillCache := False;
  {$ENDIF}

  oPrintParams := TReportParameters.Create;
end;


Destructor TGenReport.Destroy;

Begin
  If (Assigned(RepFiler1)) then
    RepFiler1.Free;

  If (Assigned(RFont)) then
    RFont.Free;

  {$IFDEF LTE}
  If (Assigned(LBitMap)) then
    LBitMap.Free;
  {$ENDIF}

  If (Assigned(oPrintParams)) then
    oPrintParams.Free;

  Inherited Destroy;
end;



{$IFDEF XEx32 }

Procedure TGenReport.PrintHedTit;


Begin

  With RepFiler1 do
  Begin
    DefFont ((6*Ord(CurrentPage=1))+(2*Ord(CurrentPage>1)),[fsBold,fsUnderLine]);
    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintCenter (Trim(Syss.UserName), PageWidth / 2);
    Self.CRLF;

    If (HedTit2<>'') then
    Begin
      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.CRLF;
      DefFont (0,[fsBold,fsUnderLine]);
      Self.PrintCenter (Trim(HedTit2), PageWidth / 2);
      Self.CRLF;
    end;

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.CRLF;

    If (CurrentPage=1) then
    Begin
      DefFont (0,[]);

      // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
      Self.PrintLeft ('Date : ' + DateToStr(Now),MarginLeft);
      Self.PrintRight ('Time : ' + TimeToStr(Now), PageWidth - 10);
      Self.CRLF;
      Self.CRLF;
    end;
  end;
end;


Procedure TGenReport.PrintStdPage;

Begin
  With RepFiler1 do
  Begin
    DefFont ((6*Ord(CurrentPage=1))+(2*Ord(CurrentPage>1)),[fsBold,fsUnderLine]);
    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintCenter (PageTitle, PageWidth / 2);
    Self.CRLF;
    Self.CRLF;
    DefFont (0,[]);

    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
    Self.PrintLeft('User : '+Trim(EntryRec^.Login),MarginLeft);
    Self.PrintRight ('Page : ' + IntToStr(CurrentPage), PageWidth - 10);
    Self.CRLF;
    Self.CRLF;
  end; {with..}
end; {Proc..}


{$ENDIF}



Procedure TGenReport.PrintHedTit;

Var
  ShowSize  :  Byte;

Begin

  With RepFiler1 do
  Begin

    ShowSize:=(2*Ord(CurrentPage=1))+(1*Ord(CurrentPage>1));

    DefFont (ShowSize,[fsBold]);

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.PrintLeft(Trim(Syss.UserName), MarginLeft);

    DefFont (0,[]);

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.PrintRight(ConCat('Printed :',DateToStr(Now),' - ',TimeToStr(Now)),PageWidth-MarginRight);
    Self.CRLF;
  end;
end;


Procedure TGenReport.PrintStdPage;

Begin
  With RepFiler1 do
  Begin
    DefFont ((1*Ord(CurrentPage=1))-(1*Ord(CurrentPage>1)),[fsBold]);
    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.PrintLeft (PageTitle, MarginLeft);
    DefFont (0,[]);
    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    {$IFDEF XLSXSupport}
    If Assigned(ExportToExcel) Then
      // MH 06/01/2016 2016-R1 ABSEXCH-10720: Don't print the Page X of Y to Excel as the macro won't work
      Self.PrintRight (Concat('User : ',Trim(EntryRec^.Login),'. Page : ',IntToStr(CurrentPage)), PageWidth - MarginRight)
    Else
    {$ENDIF XLSXSupport}
      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintRight (Concat('User : ',Trim(EntryRec^.Login),'. Page : ',IntToStr(CurrentPage),' of ',Macro(midTotalPages)), PageWidth - MarginRight);
    Self.CRLF;

    If (RepTitle2<>'') then
    Begin
      DefFont (0,[fsBold]);
      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintLeft (Trim(RepTitle2), MarginLeft);
      Self.CRLF;
    end;

    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;
  end; {with..}
end; {Proc..}



procedure TGenReport.DefFont (Const FontSze    : Integer;
                              Const FontStyle  : TFontStyles);

begin
  With RepFiler1 do
  Begin
    {SetFont (RFont.Name, RFont.Size+FontSize);}

    FontName:=RFont.Name;
    FontSize:=RFont.Size+FontSze;


    Bold := (fsBold In FontStyle);

    UnderLine :=(fsUnderLine In FontStyle);
    Italic:=(fsItalic In FontStyle);

  end; { with.. }
end;


Procedure TGenReport.DefLine(Const PWidth,
                                   LStart,
                                   LWidth,
                                   AHeight  :  Double);

Begin
  With RepFiler1 do
  Begin
    SetPen(clBlack,psSolid,Round(PWidth),pmCopy);

    MoveTo(LStart,YD2U(CursorYPos)-(4.3+AHeight));
    LineTo(LWidth,YD2U(CursorYPos)-(4.3+AHeight));
    MoveTo(1,YD2U(CursorYPos));
  end;
  end;


Procedure TGenReport.RepAfterPrint(Sender  :  TObject);
Begin


end;


Procedure TGenReport.RepBeforePrint(Sender  :  TObject);
Begin

  If (RUseForms) then
  Begin
    {InPrint:=BOff; {* Force in print off otherwise, batch will not work *}

    {$IFDEF FRM}

      pfInitNewBatch(BOff,BOn);

    {$ENDIF}

    {InPrint:=BOn;}
  end
  else
    Begin
      RepFiler1.Title:=Application.Title+'. '+RepTitle;

      (****
      {* Set extension to EFP for faxing via MAPI or if emailing in Enterprise format *}
      If ((RDevRec.fePrintMethod=1) and (RDevRec.feFaxMethod = 1)) Or
         ((RDevRec.fePrintMethod=2) and (RDevRec.feEmailAtType = 0)) then
        RepFiler1.FileName:=GetTempFNameExt('!REP','.EDF')
      else
        RepFiler1.FileName:=GetTempFNameExt('!REP','.SWP');
      ****)

      // MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
      // than uploading them to the network Exchequer\Swap folder, this should improve performance
      // and lower network traffic slightly.
      If ((RDevRec.fePrintMethod=1) and (RDevRec.feFaxMethod = 1)) Or
         ((RDevRec.fePrintMethod=2) and (RDevRec.feEmailAtType = 0)) then
        RepFiler1.FileName := GetWinTempPrintingFilename ('.EDF')
      else
        RepFiler1.FileName := GetWinTempPrintingFilename ('.SWP');


    end;

end;


Procedure TGenReport.RepNewPage(Sender  :  TObject);
Begin


end;


Function TGenReport.RepPrintPage(Sender  :  TObject;
                            var PageNum  :  Integer)  :  Boolean;

Begin
  Result:=True;
end;

Procedure TGenReport.RepPrintFooter(Sender  :  TObject);
Begin


end;


{* v5.52. function to surpress paging for excel output *}

Procedure TGenReport.ThrowNewPage(LinesRemain  :  Integer);


Begin
  With RepFiler1 do
    // MH 23/06/2015 Prototype ABSEXCH-10720: eDocEngine requires the Page Breaks to be written
    // when printing to Excel, otherwise any data is lost when it reaches the bottom of the page
    If ((LinesLeft<LinesRemain) or (LinesRemain=-1)) {and ((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[2]))} then
//    If ((LinesLeft<LinesRemain) or (LinesRemain=-1)) and ((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[2])) then
      NewPage;
end;


Function TGenReport.RepPrintExcelTotals  :  Boolean;
Begin
  Result:=((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[3]));
end;

Procedure TGenReport.RepPrint(Sender  :  TObject);

Var
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;
  {$IFDEF REPMETRICS}
    Hits, Skips  : LongInt;
    StartTime    : TDateTime;
  {$ENDIF}
  {$IFDEF REPPFC}
    Res : LongInt;
  {$ENDIF}
Begin

  ShowStatus(2,'Processing Report.');

  With MTExLocal^,RepFiler1 do
  Begin
    Case RepLen of

      256  :  RepLen:=0;

      257  :  RepLen:=RepLenCnst;    {* Force a replen const thru for checking *}

      else    RepLen:=Length(RepKey);

    end; {Case..}

    // MH 06/01/2014 v7.0.8 ABSEXCH-14908: Added RepStartKey to allow reports to jump into a specific key for the starting location
    //                                     which can be longer than the RepKey filter being assigned
    If (RepStartKey <> '') Then
      KeyS := RepStartKey
    Else
      KeyS:=RepKey;

    {$IFDEF REPMETRICS}
      // MH Add rough performance metrics to help with testing SQL version includes correct data
      Hits := 0;
      Skips := 0;
      StartTime := Now;
    {$ENDIF}

    {$IFDEF REPPFC}
      If UseSQLPrefillCache Then
      Begin
        Res := CreateCustomPrefillCache(SetDrive+FileNames[RFNum], SQLWhereClause, SQLColumns, SQLPrefillCacheID, MTExLocal^.ExClientId);
        If (Res <> 0) Then
        Begin
          UseSQLPrefillCache := False;
          SQLPrefillCacheID := 0;
        End; // If (Res <> 0)
      End; // If UseSQLPrefillCache

      If UseSQLPrefillCache Then
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
    If (RepObjPtr=NIL) then
      LStatus:=LFind_Rec(B_Start,RFnum,RKeypath,KeyS)
    else
      LStatus:=MatchProc(B_Start,KeyS);

    If (Assigned(ThreadRec)) then
      RepAbort:=ThreadRec^.THAbort;

    While (LStatusOk) and (CheckKey(RepKey,KeyS,RepLen,BOn)) and (Not RepAbort) do
    Begin

      {$IFDEF REPPFC}
        If (Not UseSQLPrefillCache) Then
      {$ENDIF}
          TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOff,BOff);

      If (IncludeRecord) then
      Begin
        ThrowNewPage(5);

        PrintReportLine;

        Inc(ICount);
        {$IFDEF REPMETRICS}
          Inc (Hits);
        {$ENDIF}
//        DebugList.Add (IntToStr(LId.NomCode) + ',' +
//                       IntToStr(LId.Currency) + ',' +
//                       IntToStr(LId.PYr) + ',' +
//                       IntToStr(LId.PPr) + ',' +
//                       IntToStr(LId.PostedRun) + ',' +
//                       IntToStr(LId.FolioRef) + ',' +
//                       IntToStr(LId.ABSLineNo) +
//                       ',Passed');
      end {If Ok..}
      Else
      Begin
        {$IFDEF REPMETRICS}
          Inc(Skips);
        {$ENDIF}

//        DebugList.Add (IntToStr(LId.NomCode) + ',' +
//                       IntToStr(LId.Currency) + ',' +
//                       IntToStr(LId.PYr) + ',' +
//                       IntToStr(LId.PPr) + ',' +
//                       IntToStr(LId.PostedRun) + ',' +
//                       IntToStr(LId.FolioRef) + ',' +
//                       IntToStr(LId.ABSLineNo) +
//                       ',Skipped');
      End; // Else

      Inc(RCount);

      If (Assigned(ThreadRec)) then
        UpDateProgress(RCount);

      {$IFDEF REPPFC}
        If (Not UseSQLPrefillCache) Then
      {$ENDIF}
          TmpStat:=LPresrv_BTPos(RFnum,RKeypath,LocalF^[RFnum],TmpRecAddr,BOn,BOff);

    {$IFDEF REPPFC}
      If UseSQLPrefillCache Then
        UseCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}

      If (RepObjPtr=NIL) then
        LStatus:=LFind_Rec(B_Next,RFnum,RKeypath,KeyS)
      else
        LStatus:=MatchProc(B_Next,KeyS);


      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;
    end; {While..}


    ThrowNewPage(5);

    {If ((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[3])) then}
      PrintEndPage;

    {$IFDEF REPMETRICS}
      {$IFDEF REPPFC}
      DebugList.Add (RepTitle);
      DebugList.Add ('UseSQLPFC: ' + BoolToStr(UseSQLPrefillCache, True));
      DebugList.Add ('SQLWhereClause: ' + SQLWhereClause);
      DebugList.Add ('SQLColumns: ' + SQLColumns);
      DebugList.Add ('Hits: ' + IntToStr(Hits));
      DebugList.Add ('Skips: ' + IntToStr(Skips));
      DebugList.Add ('Elapsed Time: ' + FormatDateTime('hh.nn.ss.zzz', Now - StartTime));
      {$ENDIF}
    {$ENDIF}

    {$IFDEF REPPFC}
      If UseSQLPrefillCache Then
        DropCustomPrefillCache(SQLPrefillCacheID, MTExLocal^.ExClientID);
    {$ENDIF}
  end; {With..}


end;




Procedure TGenReport.RAfterPrint(Sender  :  TObject);
Begin
  RepAfterPrint(Sender);

end;


Procedure TGenReport.RBeforePrint(Sender  :  TObject);
Begin
  RepBeforePrint(Sender);

end;


Procedure TGenReport.RNewPage(Sender  :  TObject);
Begin
  RepNewPage(Sender);

end;


Function TGenReport.RPrintPage(Sender  :  TObject;
                          var PageNum  :  Integer)  :  Boolean;

Begin
  Result:=RepPrintPage(Sender,PageNum);
end;

Procedure TGenReport.RPrintFooter(Sender  :  TObject);
Begin
  RepPrintFooter(Sender);

end;


Procedure TGenReport.RPrintHeader(Sender  :  TObject);
Begin
  RepPrintHeader(Sender);
end;



function TGenReport.RPJust2DT(RPJust  :  TPrintJustify)  :  Byte;

Begin
  Case RPJust of

    pjCenter  :  Result:=DT_Center;
    pjRight   :  Result:=DT_Right;
    else         Result:=DT_Left;

  end; {Case..}

end;


Procedure TGenReport.RPJustXY(Var TX,TY       :  Integer;
                            Const ThisRect    :  TRect;
                            Const RPJust      :  TPrintJustify);

Var
  FontHeight  : Integer;

Begin

  With ThisRect do
  Begin
    TY:=Bottom;

    Case RPJust of

      pjCenter  :  TX:=Round((Right-Left)/2)+Left;

      pjRight  :  TX:=Right;

      else        TX:=Left;
    end; {Case..}
  end; {With..}
end; {Proc..}



Procedure TGenReport.SendText(ThisLine  :  String);

Var
  ThisPos,
  ThisPos2,
  ThisCol,
  ThisX,
  ThisY      :  Integer;

  ThisTab    :  PTab;

  ThisRect   :  TRect;
  ThisText,
  ProcessLn  :  String;

  TAbort     :  Boolean;
  I : Integer;

  // HM 17/01/02: Replacement function for TextRect2 that uses standard RAVE
  // commands to allow usage of RAVE PDF/HTML formats.
  Procedure ExtTextRect2 (      ftText    : ShortString;
                          Const ftJustify : TPrintJustify;
                          Const ftLeft,
                                ftTop,
                                ftWidth,
                                ftHeight  : Double;
                          Const VCenter   : Boolean = False);
  Var
    TempYPos            : Double;
    ThisRect            :  TRect;

    // String to Float conversion function which supports '-' signs on right
    // hand edge of number
    Procedure StrToDouble (    StrNum : Str30;
                           Var StrOK  : Boolean;
                           Var RNum   : Double;
                           Var NoDecs : Byte);
    Var
      Neg  : Boolean;
      Chk  : Integer;
    Begin { StrToDouble }
      StrOK  := FALSE;
      Rnum   := 0.00;
      NoDecs := 0;
      Neg    := False;

      // strip off any spaces
      StrNum := Trim(StrNum);

      // Remove any 000's commas as they cause problems too
      If (Length(StrNum) > 0) Then
        While (Pos(',', StrNum) > 0) Do
          Delete (StrNum, Pos(',', StrNum), 1);

      // Check for -ve sign
      If (Length(StrNum) > 0) Then
        If (StrNum[Length(StrNum)] = '-') Then Begin
          Neg := True;
          Delete (StrNum, Length(StrNum), 1);
        End; { If (StrNum[Length(StrNum)] = '-') }

      If (StrNum <> '') Then Begin
        If (Pos ('.', StrNum) > 0) Then Begin
          // Calculate number of decimal places in string
          NoDecs := Length(StrNum) - Pos ('.', StrNum);
        End; { If }

        // Convert string to float with error checking
        Val (StrNum, Rnum, Chk);
        StrOK := (Chk = 0);

        // Restore -ve sign to number
        If StrOK And Neg Then RNum := -RNum;
      End { If (StrNum <> '')  }
      Else
        StrOK:=True;
    End; { StrToDouble }

    // Squashes the text down so that it fits within the column without loss
    Procedure SquashText;
    Var
      sStr                : ANSIString;
      FieldMask, BaseMask : Str255;
      Rect                : TRect;
      PaintFlags          : Word;
      RNum                : Double;
      NoDecs, I           : Byte;
    Begin { SquashText }
      With RepFiler1 Do Begin
        // Trim text based on justification before checking whether it will fit
        Case ftJustify Of
          pjLeft   : ftText := TrimRight(ftText);
          pjCenter : ftText := Trim(ftText);
          pjRight  : ftText := TrimLeft(ftText);
        End; { Case }

        // Check whether text will fit or not
        If (TextWidth(ftText) > ftWidth) Then Begin
          // Won't fit - determine whether text is text or number
          StrToDouble (ftText, OK, RNum, NoDecs);
          If OK Then Begin
            // Number - check whether Integer or Floating Point
            If (System.Pos ('.', ftText) > 0) Then Begin
              // Floating Point - 1) Retry without commas, but with full number
              //                  2) Incrementally reduce decimals
              //                  3) Display #'s like MS Excel

              // 1) Reformat without any thousands separators to see if that will fit
              While (System.Pos (',', ftText) > 0) Do
                System.Delete (ftText, System.Pos (',', ftText), 1);

              If (TextWidth(ftText) > ftWidth) Then Begin
                // 2) reduce the decs - retry at full decs just in case the formatting is different
                { Generate a new formatting mask without commas }
                BaseMask := GenRealMask;
                While (System.Pos (',', BaseMask) > 0) Do System.Delete (BaseMask, System.Pos (',', BaseMask), 1);

                For I := NoDecs DownTo 0 Do Begin
                  { Generate a new mask with the correct decimals }
                  FieldMask := FormatDecStrSD(I, BaseMask, BOff);

                  { reformat field into what it should look like }
                  ftText := FormatFloat (FieldMask, Round_Up(RNum, I));

                  If (TextWidth(ftText) < ftWidth) Then Break;
                End; { For I }
              End; { If (TextWidth(ftText) > ftWidth) }
            End; { If (Pos ('.', ftText) > 0) }

            If (TextWidth(ftText) > ftWidth) Then
              // No way to shorten string without misleading users so
              // display ### like MS Excel to indicate the field can't fit
              // NOTE: Integers just display ###'s if they don't fit
              ftText := StringOfChar ('#', Trunc(ftWidth / TextWidth('#')));
          End { If OK }
          Else
            // Normal string - trim off characters until fits
            While (ftText <> '') And (TextWidth(ftText) > ftWidth) Do
              System.Delete (ftText, Length(ftText), 1);
        End; { If (TextWidth(ftText) > ftWidth) }
      End; { With RepFiler1 }
    End; { SquashText }

  Begin { ExtTextRect2 }
    With RepFiler1 Do Begin
      // 'Adjust' text to ensure that it will fit correctly within the column
      SquashText;

      // Check RDevRec to determine how to print the text - stick with old method for Preview,
      // Printer and Adobe, and use the new method for RAVE PDF/HTML only.
// HM 01/08/03 (EN552XL): Extended to use standard commands for export to Excel (Preview & File)
// HM 22/03/04: Extended for Print to HTML support
// MH 20/09/07: Added mode 4 at PR's request for Scheduler
      If ((RDevRec.fePrintMethod In [2, 4]) And (RDevRec.feEmailAtType In [2, 3])) Or
          (RDevRec.fePrintMethod = 5) Or (RDevRec.fePrintMethod = 7) Then Begin
        // Sending Email with either RAVE PDF or RAVE HTML format attachments - use
        // standard RAVE commands to allow Renderer components to convert output
        TempYPos := YD2U(CursorYPos);

        With TMemoBuf.Create Do
          Try
            BaseReport := RepFiler1;

            If (RDevRec.fePrintMethod = 5) and (ftJustify=pjRight) then
            Begin
              Justify := pjLeft;

              { Excel does not like right justification, or the minus at the end of the figure. Alter both factors
                 when outputting to excel }

              If (ftText[Length(ftText)]='-') then
                Text:='-'+Copy(ftText,1,Pred(Length(ftText)))
              else
                Text:=ftText;

              Text:=Strip('A',[ThousandSeparator],Text);
            end
            else
              Begin
                Text := ftText;

                Justify := ftJustify;
              end;

            FontTop := ftTop;
            PrintStart := ftLeft;
            PrintEnd := ftLeft + ftWidth;

            PrintHeight (ftHeight, False);
          Finally
            Free;
          End;

        GotoXY (CursorXPos, TempYPos);
      End { If (RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType In [2, 3]) }
      Else Begin
        // Standard routine for Preview/Printer/Adobe Acrobat support
        ThisRect := CreateRect(ftLeft, ftTop, ftLeft + ftWidth, ftTop + ftHeight);

        RPJustXY(ThisX,ThisY,ThisRect,ftJustify);

        TextRect2 (ThisRect,                        // Clipping Rectangle
                   XD2U(ThisX),                     // X Start Position
                   YD2U(ThisY),                     // Y Start Postion
                   RPJust2DT(ftJustify),            // Justification
                   ftText);                         // Text
      End; { Else }
    End; { With TheReport }
  End; { ExtTextRect2 }


Begin
  ThisText:='';

  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
    // Tell the excel export we are printing a line - this works around a problem where SendText
    // has been called to print several columns already, e.g. Full TB totals lines, using a
    // different font
    ExportToExcel.StartLine;
  {$ENDIF XLSXSupport}

  With RepFiler1 do
  Begin
    ThisCol:=0;
    ThisX:=0; ThisY:=0;

    TAbort:=BOff;

    ProcessLn:=ThisLine;

    ThisPos2:=Pos(#9,ProcessLn);

    While (ThisPos2<>0) and (Not TAbort) do
    Begin
      Inc(ThisCol);

      ThisPos:=ThisPos2;

      Delete(ProcessLn,ThisPos,1);

      ThisPos2:=Pos(#9,ProcessLn);

      If (ThisPos2=0) then
      Begin
        ThisPos2:=Succ(Length(ProcessLn));
        TAbort:=BOn;
      end;

      If (ThisPos2>ThisPos) then {* Only print if there is data there *}
      Begin
        ThisText:=Copy(ProcessLn,ThisPos,ThisPos2-ThisPos);

        ThisTab:=GetTab(ThisCol);

        If (Assigned(ThisTab)) then
        With ThisTab^ do
        Begin
          Tab(NA,NA,NA,NA,NA);
          {ThisRect:=CreateRect(TabStart(ThisCol),YD2U(CursorYPos)-YI2U(LineHeight),TabEnd(ThisCol),YD2U(CursorYPos));

          RPJustXY(ThisX,ThisY,ThisRect,Justify);

          TextRect2(ThisRect,XD2U(ThisX),YD2U(ThisY),RPJust2DT(Justify),ThisText);}

          // MH 05/01/2016 2016-R1 ABSEXCH-10720: Added the Export To Excel sub-object for printing to .xlsx
          {$IFDEF XLSXSupport}
          If Assigned(ExportToExcel) Then
            // Send the text out to Excel
            ExportToExcel.PrintColumn (ThisText, RepFiler1.FontName, RepFiler1.FontSize, Bold, Italic, UnderLine)
          Else
          {$ENDIF XLSXSupport}
            ExtTextRect2 (ThisText,
                          Justify,
                          TabStart(ThisCol),                    // Left
                          YD2U(CursorYPos)-(LineHeight),        // Top
                          TabEnd(ThisCol)-TabStart(ThisCol),    // Width
                          LineHeight);                          // Height

        end;
      end
      Else
      Begin
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: For empty columns we still need to tell the Excel
        // interface to print it - otherwise columns get out of sync
        {$IFDEF XLSXSupport}
        If Assigned(ExportToExcel) Then
          ExportToExcel.PrintColumn ('', RepFiler1.FontName, RepFiler1.FontSize, Bold, Italic, UnderLine);
        {$ENDIF XLSXSupport}
      End; // Else
    end; {While..}

    {PrintLn(ThisLine);}
  end;
end; {Proc..}



Procedure TGenReport.SetTabCount;

Begin
  TotTabs:=RepFiler1.GetTabCount;

end;

Procedure TGenReport.SendRepSubHedDrillDown(X1,X2        :  Double;
                                            TLevel       :  Byte;
                                            DKey         :  Str255;
                                            DFnum,DKP    :  SmallInt;
                                            DMode        :  Byte);

Var
  Y1,Y2  :  Double;

Begin
  With RepFiler1 do
    // HM 12/08/03: Removed Drill-Down info when previewing and exporting to Excel as the
    //              third-party renderers can't handle the Drill-Down commands
    // HM 22/03/04: Extended for printing to HTML
    If (RDevRec.Preview) And (RDevRec.fePrintMethod <> 5) And (RDevRec.fePrintMethod <> 7) then
    Begin
      {Only generate drill down info when previewing non Excel/HTML output}
      Y1:=YD2U(CursorYPos)-LineHeight;
      Y2:=YD2U(CursorYPos);

      If (X2>X1) and (Strip('R',[#32],DKey)<>'') and (DFnum>0) then {Check for a valid rectangle with a valid key and file no}
        DrillDownArea(X1,Y1,X2,Y2,TLevel,DKey,DFnum,DKP,DMode);
    end;
end;

Procedure TGenReport.SendRepDrillDown(TStart,TEnd  :  Integer;
                                      TLevel       :  Byte;
                                      DKey         :  Str255;
                                      DFnum,DKP    :  SmallInt;
                                      DMode        :  Byte);

Var
  X1,X2  :  Double;

Begin
  With RepFiler1 do
  Begin
    X1:=TabStart(TStart);
    X2:=TabEnd(TEnd);

    SendRepSubHedDrillDown(X1,X2,TLevel,DKey,DFnum,DKP,DMode);
  end;
end;


Procedure TGenReport.SendLine(ThisLine  :  String);
Begin
  SendText(ThisLine);
  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
  Self.CRLF;
end;


Procedure TGenReport.PrintEndPage;
Begin
  If RepPrintExcelTotals then
  With RepFiler1 do
  Begin

    {$B-}
    If (Assigned(ThreadRec)) and (ThreadRec^.ThAbort) then
    Begin
    {$B+}
      DefFont(0,[fsItalic,fsBold]);
      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter('Aborted by user...',PageWidth/2);
      Self.CrLF;
      DefFont(0,[]);
    end;


    If (ICount>0) then
    Begin
      SetPen(clBlack,psSolid,-2,pmCopy);

      MoveTo(1,YD2U(CursorYPos)-4);
      LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4);
      MoveTo(1,YD2U(CursorYPos));
    end;

    If (Not HideRecCount) then
    begin
      // MH 26/08/2011 v6.8: Modified to allow SQL reports to be distinguished
      If bIsSQLReport Then
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintLeft('Total Rows : ' + IntToStr(ICount),MarginLeft)
      Else
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintLeft('Total Records : ' + IntToStr(ICount),MarginLeft);
    End; // If (Not HideRecCount)

  if bPrintParams and Assigned(oPrintParams) then
  begin
    //In case parameters need a new page we have to ensure that the standard headers aren't printed, so replace event handlers.
    RepFiler1.OnNewPage := nil;
    RepFiler1.OnPrintHeader := nil;
    // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CRLF;
    Self.CRLF;
    ThrowNewPage(7);
    RepFiler1.OnNewPage := ParamNewPage;
    oPrintParams.ReportFiler := RepFiler1;
    oPrintParams.PrintParamsProc := ParamPrint;
    oPrintParams.OnCRLF := Self.CRLF;
    oPrintParams.OnPrintLeft := Self.PrintLeft;
    oPrintParams.Print;
  end;

    {PrintBitMapRect(PageWidth-MarginRight-10,YD2U(CursorYPos)-2,PageWidth-MarginRight,YD2U(CursorYPos)+5.3,LBitMap);}

    // MH 20/04/2010 v6.4: Removed graphic at end of report as (a) obsolete branding (b) customer complaint about ink usage!
    {$IFDEF LTE}
      // HM 22/03/04: Suppressed bitmap when printing to HTML (7)
      If (Not NoXLogo) And (RDevRec.fePrintMethod <> 7) then
        PrintBitMapRect(PageWidth-MarginRight-7,YD2U(CursorYPos)-2,PageWidth-MarginRight,YD2U(CursorYPos)+5.3,LBitMap);
    {$ENDIF}
  end;

end;


{Function TGenReport.PO2RO(PR  :  TPrinterOrientation)  :  TOrientation;

Begin
  Case PR of
    Printers.PoPortrait  :  Result:=RpDefine.PoPortrait;
    Printers.PoLandscape :  Result:=RpDefine.PoLandScape;
  end; {Case..
end;}


Procedure TGenReport.RPrint(Sender  :  TObject);



Begin

  RepPrint(Sender);

end;



Procedure TGenReport.Process;
Var
  Ok2Cont  :  Boolean;
  MaxCount :  LongInt;

Begin
  With RepFiler1 do
  Begin
    PrinterIndex:=LocalPrinterIndex;

    Orientation:=ROrient;

    SetReportMargins;

  end;

  Inherited Process;

  ShowStatus(0,RepTitle);

  If (RFNum <> 0) Then
  Begin
  With MTExLocal^ do
    MaxCount:=Used_RecsCId(LocalF^[RFnum],RFnum,ExCLientId);

  InitProgress(MaxCount+Round(MaxCount/10));
  End; // If (RFNum <> 0)

  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Create the Export To Excel sub-object for printing to .xlsx
  {$IFDEF XLSXSupport}
  If (RDevRec.fePrintMethod = 5) Then
  Begin
    ExportToExcel := TExportReportToExcel.Create;

    //PR: 25/06/2016 2016-R3 ABSEXCH-17645 Check if we have an ini file to override default rows
    with TIniFile.Create(SetDrive + XLSX_INC_ROWS_FILENAME) do
    Try
      ExportToExcel.IncrementRowsBy := ReadInteger('Settings','Rows', XLSX_INC_ROWS_BY_DEFAULT);
    Finally
      Free;
    End;
  End; // If (RDevRec.fePrintMethod = 5)
  {$ENDIF XLSXSupport}

  With RepFiler1 do
    Execute;

  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Save the report to .xlsx and tidy up
  {$IFDEF XLSXSupport}
  If Assigned(ExportToExcel) Then
  Begin
    ExportToExcel.SaveToFile (RDevRec.feXMLFileDir);     // Destination Filename for .xlsx file

    // Destroy the Export To Excel sub-object
    FreeAndNIL(ExportToExcel);
  End; // If Assigned(ExportToExcel)
  {$ENDIF XLSXSupport}
end;


Procedure TGenReport.SetReportMargins;

Begin
  With RepFiler1 do
  Begin
    MarginLeft:=LeftWaste+1;
    MarginRight:=1+RightWaste;
    MarginTop:=1+TopWaste;
    MarginBottom:=1+BottomWaste;
  end;

end;

Function TGenReport.InitRep1  :  Boolean;

Begin
  Result:=BOn;

  try
    With RepFiler1 do
    Begin
      //LastPage := 20000;

      StreamMode:=smFile;
      Units:=unMM;

      FileName:=SetDrive+'Rep99.Swp';  {* EX32, replace with new valid file *}

      {PrinterIndex:=RPrinterNo;}

      LocalPrinterIndex:=RDevRec.DevIdx;

      SetReportMargins;

      OnAfterPrint:=RAfterPrint;
      OnBeforePrint:=RBeforePrint;
      OnNewPage:=RNewPage;
      RepFiler1.OnPrint:=RPrint;
      OnPrintFooter:=RPrintFooter;
      OnPrintHeader:=RPrintHeader;

    end; {With..}
  except
    RepFiler1.Free;
    RepFiler1:=nil;
    Result:=BOff;
  end; {try..}

end;




Procedure TGenReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    Case ReportMode of

        0,1:  Begin
                SetTab (MarginLeft, pjLeft, 16, 4, 0, 0);
                SetTab (NA, pjLeft, 45, 4, 0, 0);
                SetTab (NA, pjLeft, 32, 4, 0, 0);
                SetTab (NA, pjLeft, 31, 4, 0, 0);
                SetTab (NA, pjLeft, 31, 4, 0, 0);
                SetTab (NA, pjLeft, 20, 4, 0, 0);
                SetTab (NA, pjRight,20, 4, 0, 0);
              end;

        4  :  Begin

                {$IFDEF MC_On}
                  SetTab (MarginLeft+5, pjRight, 20, 4, 0, 0);
                  SetTab (NA, pjLeft, 70, 4, 0, 0);
                  SetTab (NA, PJCenter, 10, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);
                  SetTab (NA, pjLeft, 40, 4, 0, 0);

                {$ELSE}
                  SetTab (MarginLeft+5, pjRight, 20, 4, 0, 0);
                  SetTab (NA, pjLeft, 70, 4, 0, 0);
                  SetTab (NA, PJCenter, 40, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);
                  SetTab (NA, PJCenter, 20, 4, 0, 0);

                {$ENDIF}

              end;
        9,10
           :  Begin
                SetTab (MarginLeft, pjLeft, 70, 4, 0, 0);
                SetTab (NA, pjCenter, 25, 4, 0, 0);
                SetTab (NA, pjLeft, 20, 4, 0, 0);
                SetTab (NA, pjLeft, 80, 4, 0, 0);
              end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;


Procedure TGenReport.RepPrintPageHeader;

Var
  JStr  :  Str20;

Begin
  With RepFiler1 do
  Begin
    DefFont(0,[fsBold]);

    Case ReportMode of

      0,1 :  SendLine (#9 + 'Acc No'+ #9 + 'Name' + #9 + 'Contact' + #9 + 'TelNo'+#9+'Fax No'+#9+'Ref/Acc No'+#9+'Cr/Limit');

      4   :  Begin
               If (JbCostOn) then
                 JStr:='Force JC?'
               else
                 JStr:='';

               {$IFDEF MC_On}
                 SendLine(ConCat(#9,'Code',#9,'General Ledger Account',#9,'Type',#9,'Inact?',#9,JStr,#9,'Revalue?',#9,'Force Currency'));

               {$ELSE}

                 SendLine(ConCat(#9,'Code',#9,'General Ledger Account',#9,'Type',#9,'Inact?',#9,JStr));

               {$ENDIF}
             end;

      9,10
          :  SendLine(ConCat(#9,CCVATName^+' Registration No.',#9,'EC Member',#9,'A/C No.',#9,'Company name'));

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


Procedure TGenReport.RepPrintHeader(Sender  :  TObject);
Begin
  // MH 23/06/2015 Prototype ABSEXCH-10720: Always print header for Page 1, suppress on subsequent
  // pages when printing to Excel unless the user has selected to print the page headers
  If (RepFiler1.CurrentPage = 1) Or (RDevRec.fePrintMethod <> 5) Or ((RDevRec.fePrintMethod = 5) And RDevRec.feMiscOptions[2]) Then
  Begin
    With RepFiler1 do
    Begin

      If (CurrentPage=1) then
      Begin
        RepSetTabs;

        // MH 09/12/2015: Need to setup column and widths so we can do PrintRight commands
        SendTabsToXLSX(False {UpdateExistingTabs});
      end;

      PrintHedTit;

      PrintStdPage;

      RepPrintPageHeader;

      If (Not RNoPageLine) then
      Begin
        SetPen(clBlack,psSolid,-2,pmCopy);

        MoveTo(1,YD2U(CursorYPos)-4.3);
        LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
        MoveTo(1,YD2U(CursorYPos));
      end;
    end; {With..}
  End; // If (RepFiler1.CurrentPage = 1) Or (RDevRec.fePrintMethod <> 5) Or ((RDevRec.fePrintMethod = 5) And RDevRec.feMiscOptions[2])
end;


function TGenReport.MatchProc(B_Func  :  SmallInt;
                              BKey    :  Str255)  :  SmallInt;

Begin
  Result:=4;

end;

function TGenReport.IncludeRecord  :  Boolean;

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      0,1  :  Result:=LCust.CustSupp=TradeCode[(ReportMode=0)];

      9,10 :  Result:=(LCust.EECMember);

      else    Result:=BOn;
    end; {case..}

  end; {With..}
end;



Procedure TGenReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      0,1,9,10  :  SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);

      4         :  SendRepDrillDown(1,TotTabs,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);

    end; {Case..}
  end; {With..}
end;


{$IFDEF LTE}

  { ==== Procedure to check if nom's immediate parent is set to revalue  ==== }

  Function TGenReport.LCheckParentRV(GLCat  :  LongInt;
                                     Mode   :  Byte;
                                 Var Level  :  LongInt)  :  Boolean;

  Const
    Fnum     =  NomF;
    Keypath  =  NomCodeK;

  Var
    LKeyS,
    LKeyChk   :  Str255;


    IsDRCr,
    FoundOk  :  Boolean;

    TmpKPath,
    TmpStat
             : Integer;

    TmpRecAddr
             :  LongInt;

    TmpNom   :  NominalRec;

  Begin
    With MTExLocal^ do
    Begin

      FoundOk:=BOff;

      TmpNom:=LNom;

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(NomF,TmpKPath,LocalF^[NomF],TmpRecAddr,BOff,BOff);

      IsDrCr:=((LNom.NomCode=Syss.NomCtrlCodes[Debtors]) or (LNom.NomCode=Syss.NomCtrlCodes[Creditors])) and (Mode=0);

      FoundOK:=(GLCat=0) and (Mode=0) and (LNom.ReValue) and (Not IsDrCr) ;

      If (Not FoundOk) and (GLCat<>0) and (Not IsDrCr) then
      Begin
        LKeyChk:=FullNomKey(GLCat);

        LKeyS:=LKeyChk;

        LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,LKeyS);

        Case Mode of
          1  :  Begin
                  If (LStatusOk) and (LNom.Cat<>0) and (Level<3) then
                  Begin
                    Level:=Succ(Level);

                    FoundOk:=LCheckParentRV(LNom.Cat,Mode,Level);

                  end
                  else
                    FoundOk:=(LStatusOk) and (LNom.Cat=0) and (Level<3);


                end;

          else  FoundOk:=(LStatusOk) and (LNom.ReValue);
        end; {Case..}
      end;


      TmpStat:=Presrv_BTPos(NomF,TmpKPath,LocalF^[NomF],TmpRecAddr,BOn,BOff);

      LNom:=TmpNom;


      Result:=FoundOk;
    end; {With..}
  end;
{$ENDIF}


Procedure TGenReport.PrintReportLine;


Var
  RevalStr,
  ForceCStr,
  ForceJStr,
  ForceIStr  :  Str30;

  RVLevel    :  Integer;

Begin
  With MTExLocal^do
  Begin
    DefFont (0,[]);

    RevalStr:=''; ForceCStr:='';

    SetReportDrillDown(0);

    Case ReportMode of
      0,1  :  With LCust do
                SendLine (#9 + Trim(CustCode) +
                          #9 + Trim(Company) +
                          #9 + Trim(Contact) +
                          #9 + Trim(Phone)+
                          #9 + Trim(Fax)+
                          #9 + Trim(RefNo)+
                          #9 + FormatFloat(GenRealMask,CreditLimit));

      4    :  With LNom do
                Begin
                  If (JBCostOn) and (ForceJC) then
                    ForceJStr:=YesNoBo(ForceJC)
                  else
                    ForceJStr:='';

                  If (HideAC=1) then
                    ForceIStr:=YesNoBo(BOn)
                  else
                    ForceIStr:='';

                {$IFDEF MC_On}
                  Begin
                    {$IFDEF LTE}
                      RVLevel:=0;

                      If (LNom.NomType<>NomHedCode) and (LNom.Cat<>0) then
                        Revalue:=LCheckParentRV(Cat,0,RVLevel);
                    {$ENDIF}

                    If (Revalue) then
                      ReValStr:=YesNoBo(Revalue)
                    else
                      ReValStr:='';

                    If (DefCurr<>0) then
                      ForceCStr:=CurrDesc(DefCurr)
                    else
                      ForceCStr:='';

                    SendLine (ConCat(#9,Form_Int(NomCode,0),#9,Trim(Desc),#9,NomType,#9,ForceIStr,#9,ForceJStr,#9,ReValStr,#9,ForceCStr));
                  end;

                {$ELSE}
                  SendLine (ConCat(#9,Form_Int(NomCode,0),#9,Trim(Desc),#9,NomType,#9,ForceIStr,#9,ForceJStr));

                {$ENDIF}
              end;

      9,10
           :  With LCust do
                SendLine (ConCat(#9,Trim(VATRegNo),#9,YesNoBo(EECMember),#9,Trim(CustCode),#9,Trim(Company)));

    end; {Case..}
  end; {With..}
end;




Function TGenReport.GetReportInput  :  Boolean;

Var
 fSortxNCde
        :  Boolean;
 mbRet  :  Word;

Begin
  Result:=BOn;  fSortxNCde:=BOff;

  Case ReportMode of
    // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
    0    :  Begin
              RepTitle:=TradeType[(ReportMode=0)]+' List';
              THTitle:=RepTitle;

              RFnum:=CustF;

              If (FilteringMode <> -1) Then
              Begin
                Case TReportIncludeAccountTypes(FilteringMode) Of
                  atCustomersAndConsumers : Begin
                                              // Switch to CustSupp+Code index and specify correct CustSupp key
                                              RKeyPath := ATCodeK;
                                              RepKey := TradeCode[BOn]; // CustSupp='C'
                                            End; // atCustomersOnly
                  atCustomersOnly         : Begin
                                              // Switch to SubType+Code index and specify correct subtype key
                                              RKeyPath := CustACCodeK;
                                              RepKey := ConsumerUtils.CUSTOMER_CHAR;  // SubType='C'
                                            End; // atCustomersOnly
                  atConsumersOnly         : Begin
                                              // Switch to SubType+Code index and specify correct subtype key
                                              RKeyPath := CustACCodeK;
                                              RepKey := ConsumerUtils.CONSUMER_CHAR;  // SubType='U'
                                            End; // atConsumersOnly
                Else
                  Raise Exception.Create ('TGenReport.GetReportInput: Unhandled Account Type setting (' + IntToStr(FilteringMode) + ')');
                End; // Case IncludeAccountTypes
                RepLen := Length(RepKey);
              End; // If (FilteringMode <> -1)
            End; // 0 - Customer List

    // Supplier List
    1    :  Begin
              RepTitle:=TradeType[(ReportMode=0)]+' List';
              THTitle:=RepTitle;

              RFnum:=CustF;
            end;

    4    :  Begin
              RepTitle:='General Ledger Code List';
              ThTitle:='G/L Code List';

              RFnum:=NomF;

              mbRet:=MessageDlg('The General Ledger Code List is printed in description order by default.'+#13+'Do you wish to print the report in code order instead?',mtConfirmation,[mbYes,mbNo,mbCancel],0);

              fSortxNCde:=(mbRet=mrYes);

              Result:=(mbRet<>mrCancel);

              If (fSortxNCde) then
                RKeypath:=NomCodeK
              else
                RKeypath:=NomDescK;

              RFont.Size:=10;
            end;


    9,10
         :  Begin
              RepTitle:=TradeType[(ReportMode=9)]+' '+CCVATName^+' Registration No. List';

              ThTitle:=TradeType[(ReportMode=9)]+' '+CCVATName^+' Reg List';

              RFnum:=CustF;
              RKeyPath:=CustCntyK;

              RepKey:=TradeCode[(ReportMode=9)];

              RepLen:=0;

              RFont.Size:=10;
            end;

  end; {Case..}

  PageTitle:=RepTitle;


end;


Function TGenReport.Start  :  Boolean;

Var
  mbRet  :  Word;

Begin
  Result:=GetReportInput;

  If (Result) then
  Begin

    {$IFDEF FRM}
      If (Not NoDeviceP) then
      Begin
        If (RUseForms) then
          Result:=pfSelectFormPrinter(RDevRec,BOn,RForm,RFont,ROrient)
        else
        Begin
          RDevRec.feEmailSubj:=RepTitle+'. From '+Syss.UserName;

          Result:=pfSelectPrinter(RDevRec,RFont,ROrient);
        end;
      end;
    {$ELSE}

      RFont.Assign(Application.MainForm.Font);

      With RDevRec do
      Begin
        DevIdx:=-1;
        Preview:=BOn;
      end;

    {$ENDIF}

    {$IFDEF EXSQL}
    if Result and SQLUtils.UsingSQL then
    begin
      // CJS - 18/04/2008: Thread-safe SQL Version (using unique ClientIDs)
      if (not Assigned(LPostLocal)) then
        Result := Create_LocalThreadFiles;

      If (Result) then
        MTExLocal := LPostLocal;

    end
    else
    {$ENDIF}
    begin
      If (Not Assigned(RepExLocal)) and (Result) then { Open up files here }
        Result:=Create_ReportFiles;

      If (Result) then
        MTExLocal:=RepExLocal;
    end;

    If (Result) then
      InitRep1;


  end;

  {$IFDEF EXSQL}
  if Result and SQLUtils.UsingSQL then
    Reset_LocalThreadFiles;
  {$ENDIF}

end;

// This function acts as a 'Can Continue' check -- it returns False if the
// report should not continue, otherwise it returns True.
function TGenReport.ChkRepAbort  :  Boolean;
begin
  // If the report is being run in a thread, check the Abort flag on the
  // thread (this is set by the Object Thread Controller
  If (Assigned(ThreadRec)) then
    RepAbort := ThreadRec^.THAbort
   //PR: 09/12/2014 Adjust for sentimail 
  {$IFNDEF SENT}
  else
    // CJS - Order Payments - Phase 5 - T067 - VAT Return
    // If there is no thread, check the FCancelled flag instead -- this will
    // have been set via the OnUpdateProgress event handler, if assigned (see
    // ExBtTh1U.pas).
    RepAbort := FCancelled;
  {$ELSE}
    ;
  {$ENDIF not SENT}


  Result := not RepAbort;
end;


Procedure TGenReport.DelSwpFile;

Var
  DelF    :  File of Byte;
  IOTmp   :  Integer;

Begin
  {$I-}

   AssignFile(DelF,RepFiler1.FileName);

   Erase(DelF);

   IOTmp:=IOResult;

   If (Not (IOTmp In [0,2])) then {* File not found do not report... *}
     MTExLocal^.LReport_IOError(IOTmp,RepFiler1.FileName);

 {$I+}

end;





Procedure TGenReport.Finish;

Var
  PParam   :  ^TPrintParam;

Begin


  New(PParam);

  FillChar(PParam^,Sizeof(PParam^),0);

  ShowStatus(2,'Printing Report.');

  With PParam^ do
  Begin
    PDevRec:=RDevRec;

    {ToPrinter:=RToPrinter;
    PrinterNo:=RPrinterNo;}
    FileName:=RepFiler1.FileName;
    RepCaption:=RepTitle;

    {If (Copies<1) then
      Copies:=1;

    Copies:=RCopies;}

    PBatch:=RUseForms;
    DelSwapFile:=RDelSwapFile;
    SwapFileName:=TmpSwapFileName;

    {$IFDEF FRM}  {* Connect eComm jobs list here *}
       If (Assigned(eCommFrmList)) then
         eCommLink:=eCommFrmList;
    {$ENDIF}

    With MTExLocal^ do
    Begin
      If (Assigned(LThPrintJob)) and (Not ThreadRec^.ThAbortPrint) then {* Call back to Synchronise method *}
      Begin
         ThreadRec^.THAbort:=BOn; {* Force abort, as control now handed over to DLL *}
        LThPrintJob(nil,LongInt(@PParam^),0);
      end
      else
        If (ThreadRec^.ThAbortPrint) then
        Begin
          RepFiler1.Abort;
          DelSwpFile;

          
          {$IFDEF FRM}
            If (Assigned(PParam)) then {* When DBD is removed, this line needs to be outside FRM}
              Dispose(PParam);

            If (Assigned(eCommFrmList)) then
              eCommFrmList.Destroy;
          {$ENDIF}

        end;
    end; {else..}

    {PostMessage(Application.MainForm.Handle,WM_FormCloseMsg,98,LongInt(@PParam^));}

    If (Assigned(ThreadRec)) then
      UpdateProgress(ThreadRec^.PTotal);



  end; {With..}

  InPrint:=BOff;

  Inherited Finish;
end;


{ ====================== Get Full Cust Rec & Print ====================== }

  // MH 22/02/2012 v6.10 ABSEXCH-12025: Modified to support a new clearer layout
  Procedure TGenReport.PrintCustLine(Const Ccode  :  Str10;
                                     Const Cont   :  Boolean;
                                     Const UseClearerFormat : Boolean = False);

  Var
    ContStr, sSubTitle  :  Str255;

    AltStr,
    PhoneStr :  Str30;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      LGetMainRec(CustF,Ccode);

      DefFont(0,[fsBold]);

      // Code + Company
      sSubTitle := dbFormatName(LCust.CustCode, LCust.Company);

      // MH 22/02/2012 v6.10 ABSEXCH-12025: Modified to support a new clearer layout
      If UseClearerFormat Then
      Begin
        // AltCode if set
        If (Trim(LCust.CustCode2) <> '') Then
          sSubTitle := sSubTitle + ', ' + Trim(LCust.CustCode2);

        // Phone if set
        If (Trim(LCust.Phone) <> '') Then
          sSubTitle := sSubTitle + ', ' + Trim(LCust.Phone);
      End // If UseClearerFormat
      Else
      Begin
        If (Trim(LCust.CustCode2) <> '') then
          sSubTitle := sSubTitle + '/' + Trim(LCust.CustCode2) + '.';

        If (Trim(LCust.Phone) <> '') then
          sSubTitle := sSubTitle + LCust.Phone + '.';
      End; // Else

      If (Cont) Then
        sSubTitle := sSubTitle + ' (continued...)';

      // Set print preview drill-down information
      SendRepSubHedDrillDown (MarginLeft, PageWidth + MarginLeft, 1, LCust.CustCode, CustF, CustCodeK,0);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintLeft(sSubTitle, MarginLeft);
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

    end; {With..}
  end;



{ ====================== Get Full Cust Rec & Print ====================== }

  Procedure TGenReport.PrintNomLine(Const Ccode  :  Str10;
                                    Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      LGetMainRec(NomF,Ccode);

      DefFont(0,[fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

        SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);

      With LNom do
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintLeft(ConCat(dbFormatName(Form_Int(NomCode,0),Desc)+ContStr),MarginLeft);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

    end; {With..}
  end;


{ ======== }



{$IFDEF STK}

{ ====================== Get Full Stock Rec & Print ====================== }

  Procedure TGenReport.PrintStkLine(Const Ccode  :  Str20;
                                    Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;
    TStock   :  StockRec;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      TStock:=LStock;

      If (CCode<>NdxWeight) then
        LGetMainRec(StockF,Ccode);

      DefFont(0,[fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,LStock.StockCode,StockF,StkCodeK,0);

      With LStock do
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintLeft(ConCat(dbFormatName(StockCode,Desc[1])+ContStr),MarginLeft);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

      LStock:=TStock;

    end; {With..}
  end;


  { ======= Function to Check belongs to tree ====== }

Function TGenReport.Stk_InGroup(StkGroup  :  Str20;
                                StockR    :  StockRec)  :  Boolean;


Const
  Fnum     =  StockF;
  Keypath  =  StkCodeK;


Var
  KeyS2    :  Str255;
  FoundOk :  Boolean;
  TmpKPath,
  TmpStat :  Integer;

  TStock  :  StockRec;

  TmpRecAddr
          :  LongInt;


Begin
  With MTExLocal^ do
  Begin
    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    TStock:=LStock;

    KeyS2:=StockR.StockCat;

    FoundOk:=((EmptyKey(StkGroup,StkKeyLen)) or (FullStockCode(StkGroup)=FullStockCode(KeyS2))) or
             ((StockR.StockType<>StkGrpCode) and (FullStockCode(StkGroup)=FullStockCode(StockR.StockCode)));


    If (Not FoundOk) then
      LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS2);


    While (LStatusOk) and (Not FoundOk) and (Not EmptyKey(LStock.StockCat,StkKeyLen)) and (ChkRepAbort) do
    With LStock do
    Begin

      FoundOk:=((FullStockCode(StkGroup)=StockCode) or (FullStockCode(StkGroup)=FullStockCode(StockCat)));

      If (Not FoundOk) then
      Begin
        KeyS2:=StockCat;

        LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS2);

      end;

    end; {While..}

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

    LStock:=TStock;

    Stk_InGroup:=FoundOk;
   end; {With..}
end; {Func..}


{$IFDEF SOP}
  Function TGenReport.MLocRepTitle(Lc  :  Str10)  :  Str80;

  Begin
    If (Not EmptyKey(Lc,LocKeyLen)) then
    With MLocCtrl^.MLocLoc do
    Begin
      If (loCode<>lc) then
        Global_GetMainRec(MLocF,Quick_MLKey(Lc));

      Result:='Locn : '+dbFormatName(loCode,loName);
    end
    else
      Result:='';
  end;


 {$ENDIF}

{$ENDIF}


{$IFDEF JC}

  { ====================== Get Full Employee Rec & Print ====================== }

  Procedure TGenReport.PrintEmplLine(Const ECode  :  Str10;
                                     Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      If (LJobMisc^.EmplRec.EmpCode<>ECode) then
        LGetMainRec(JMiscF,PartCCKey(JARCode,JASubAry[3])+ECode);

      DefFont(0,[fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      With LJobMisc^.EmplRec do
      Begin
        SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmpCode),JMiscF,JMK,0);

        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintLeft(ConCat(dbFormatName(EmpCode,EmpName)+ContStr),MarginLeft);
      end;

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CrLF;

      DefLine(-1,1,100,-0.3);

      DefFont(0,[]);

    end; {With..}
  end;


  { ====================== Get Full Employee Rec & Print ====================== }

  Procedure TGenReport.PrintJobLine(Const JCode  :  Str10;
                                    Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;
    LOk      :  Boolean;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      If (LJobRec^.JobCode<>JCode) then
        LOk:=LGetMainRec(JobF,JCode)
      else
        LOk:=(JCode<>'');

      If (LOk) then
      Begin

        DefFont(0,[fsBold]);

        If (Cont) then
          ContStr:=' (continued...)'
        else
          ContStr:='';

        With LJobRec^ do
        Begin
          SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,JobCode,JobF,JobCodeK,0);

          // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
          Self.PrintLeft(ConCat('Job : ',dbFormatName(JobCode,JobDesc)+ContStr),MarginLeft);
        end;

        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.CrLF;

        DefLine(-1,1,100,-0.3);

        DefFont(0,[]);
      end;
    end; {With..}
  end;



  
  {* Similar routine exisits in JobPostU *}
  Function TGenReport.LRepGetJobMisc(ACode  :  Str10;
                                     GMode  :  Byte)  :  Boolean;

  Const
    Fnum     = JMiscF;
    Keypath  = JMK;


  Var
    KeyChk  :  Str255;


  Begin
    KeyChk:=FullJAKey(JARCode,JASubAry[GMode],ACode);

    With MTExLocal^ do
    Begin
      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

      Result:=LStatusOk;
    end;

  end;


  Function TGenReport.LGet_StdPR(ThisCode  :  Str20;
                                 Fnum,
                                 Keypath,
                                 GMode     :  Integer)  :  Boolean;


  Var
    LOk         :  Boolean;

    KeyChk,
    KeyS2        :  Str255;

  Begin

    With MTExLocal^ do
    Begin

      KeyChk:=PartCCKey(JBRCode,JBSubAry[3])+FullJBCode(FullNomKey(PRateCode),0,ThisCode);

      KeyS2:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,JCK,KeyS2);

      LOk:=((LStatusOk) and (CheckKey(KeyChk,KeyS2,Pred(Length(KeyChk)),BOn)));

      Result:=LOk;
    end; {With..}

  end; {Proc..}


  { ====== Wrapper procedure to get details of std payrates ======= }

  Function TGenReport.LGet_StdPRDesc(ThisCode  :  Str20;
                                     Fnum,
                                     Keypath,
                                     GMode     :  Integer)  :  Str255;


  Var
    LOk         :  Boolean;
    TCtrlRec    :  JobCtrlRec;

    TmpStatus   :  Integer;
    TmpRecAddr  :  Longint;

    GenStr      :  Str255;

  Begin

    GenStR:='';

    TmpRecAddr:=0;

    With MTExLocal^ do
    Begin

      TCtrlRec:=LJobCtrl^;

      TmpStatus:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      If (LGet_StdPR(ThisCode,Fnum,Keypath,GMode)) then
        GenStr:=LJobCtrl^.EmplPay.PayRDesc;

      TmpStatus:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LJobCtrl^:=TCtrlRec;

      LGet_StdPRDesc:=GenStr;
    end; {With..}

  end; {Proc..}



    { ======= Function to Check belongs to tree ====== }

  Function TGenReport.LJob_InGroup(JobGroup  :  Str20;
                                   JobR      :  JobRecType)  :  Boolean;


  Const
    Fnum     =  JobF;
    Keypath  =  JobCodeK;


  Var
    KeyS2   :  Str255;
    FoundOk :  Boolean;
    TmpKPath,
    TmpStat :  Integer;

    TJob    :  JobRecType;

    TmpRecAddr
            :  LongInt;


  Begin
    With MTExLocal^ do
    Begin

      TmpKPath:=GetPosKey;

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

      TJob:=LJobRec^;

      KeyS2:=JobR.JobCat;

      FoundOk:=((EmptyKey(JobGroup,JobKeyLen)) or (FullJobCode(JobGroup)=FullJobCode(KeyS2)));


      If (Not FoundOk) then
        LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS2);


      While (LStatusOk) and (Not FoundOk) and (Not EmptyKey(LJobRec^.JobCat,JobKeyLen)) do
      With LJobRec^ do
      Begin

        FoundOk:=((FullJobCode(JobGroup)=JobCode) or (FullJobCode(JobGroup)=FullJobCode(JobCat)));

        If (Not FoundOk) then
        Begin
          KeyS2:=JobCat;

          LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyS2);

        end;

      end; {While..}

      TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

      LJobRec^:=TJob;

      LJob_InGroup:=FoundOk;
    end; {With..}
  end; {Func..}


{$ENDIF}


{ ====== Function to Calculate O/CBal ======= }

Function  TGenReport.Get_OCBal(NomType  :  Char;
                               NomCode  :  Str10;
                               Rcr,
                               NYr,NPr,
                               Mode     :  Byte;
                               CloseBal :  Boolean)  :  Double;

Var
  Purch,Sales,Cleared
        :  Double;

Begin

  If (Not CloseBal) then
  Begin
    If ((Not (NomType In ProfitBFSet)) or (NPr<>1)) then  {* For A types, if beginning of year o/Bal should be 0 *}
      AdjPr(Nyr,NPr,CloseBal)
    else       {* Force Not find if beginning of Year & A Type Nominal *}
      NPr:=0;
  end;

  With MTExLocal^ do
    Get_OCBal:=LProfit_To_Date(NomType,NomCode,RCr,NYr,NPr,Purch,Sales,Cleared,BOn);

end;



{* Procedure to direct Form print to normal Add Batch routine, or eComms list *}
{******** This routine replicated in FrmThrdU for doc printing }

Function  TGenReport.Send_FrmPrint(      ecPrnInfo    : TSBSPrintSetupInfo;
                                   Const ecDefMode    : Integer;
                                   Const ecFormName   : ShortString;
                                   Const ecMFN, MKP   : Integer;
                                   Const ecMKeyRef    : Str255;
                                   Const ecTFN, TKP   : Integer;
                                   Const ecTKeyRef    : Str255;
                                   Const ecDescr      : ShortString;
                                   Const ecAddBatchInfo
                                                      : StaCtrlRec;
                                   Const ProcessErr   : Boolean;
                                   Const ecCommMode   : Byte)   :   Boolean;
var
  // CJS 2016-01-25 - ABSEXCH-15531 - Cheque numbers incrementing twice
  ResetChequeMode: Boolean;
Begin
  Result:=BOff;

  // CJS 2016-01-25 - ABSEXCH-15531 - Cheque numbers incrementing twice
  ResetChequeMode := False;

  {$IFDEF FRM}
     If (ecCommMode In [0,3,4]) or (Not Assigned(eCommFrmList)) or (ecPrnInfo.Preview) then
     Begin
       Result:=pfAddBatchForm(ecPRnInfo,ecDefMode,ecFormName,
                                         ecMFN,MKP,ecMKeyRef,
                                         ecTFN,TKP,ecTKeyRef,
                                         ecDescr,
                                         ecAddBatchInfo,
                                         ProcessErr);

       // CJS 2016-01-25 - ABSEXCH-15531 - Cheque numbers incrementing twice
       // Reset the Cheque Printing Mode if already printed to paper - otherwise
       // it can increment the Cheque Number twice
       ResetChequeMode := True;
     end;

     If (ecCommMode In [1..4]) and (Assigned(eCommFrmList)) and (Not ecPrnInfo.Preview) then
     With eCommFrmList, MTExLocal^ do
     Begin
       Try
         Case ecCommMode of
           1,2  :  ecPrnInfo.fePrintMethod:=ecCommMode;
           3,4  :  ecPrnInfo.fePrintMethod:=ecCommMode-2;
         end;

         If (ecPrnInfo.fePrintMethod=1) then {* Set Fax destination Printer *}
           ecPrnInfo.DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.FaxPrnN)
         else
           If (ecPrnInfo.fePrintMethod=2) then {* Set Email destination printer *}
           With ecPrnInfo do
           Begin
             DevIdx:=pfFind_DefaultPrinter(SyssEDI2^.EDI2Value.EmailPrnN);

             //feEmailTo:=feEmailTo+';'+feEmailToAddr+';';

             // MH 31/01/14 v7.0.9: Modified as was causing multiple semi-colon's on the end which was crashing MAPI
             //PR: 19/05/2014 ABSEXCH-15327 All names and addresses should now be in feEmailTo
             // feEmailTo:=feEmailTo+';'+feEmailToAddr;
             While (Length(feEmailTo) > 0) And (feEmailTo[Length(feEmailTo)] = ';') Do
               System.Delete (feEmailTo, Length(feEmailTo), 1);
             feEmailTo := feEmailTo + ';';


             If (UserProfile^.EmailAddr='') or (Not UserProfile^.Loaded) then
               feEmailFromAd:= SyssEDI2^.EDI2Value.EmAddress
             else
               feEmailFromAd:= UserProfile^.EmailAddr;


             If (UserProfile^.UserName='') or (Not UserProfile^.Loaded) then
               feEmailFrom:= SyssEDI2^.EDI2Value.EmName
             else
               feEmailFrom:= UserProfile^.UserName;

           end;

         // CJS 2016-01-25 - ABSEXCH-15531 - Cheque numbers incrementing twice
         // Reset the Cheque Printing Mode if already printed to paper - otherwise it can
         // increment the Cheque Number twice
         If ResetChequeMode Then
           ecPrnInfo.ChequeMode := False;

         AddeCommVisiRec(ecPrnInfo,
                         ecDefMode,
                         ecFormName,
                         ecMFN, MKP,
                         ecMKeyRef,
                         ecTFN, TKP,
                         ecTKeyRef,
                         ecDescr,
                         dbFormatName(LCust.CustCode,LCust.Company),
                         ecAddBatchInfo);
         Result:=BOn;

       except
         Result:=BOff;
       end;


     end;


  {$ENDIF}
end;



Function TGenReport.Being_Posted(Const LMode  :  Byte)  :  Boolean;

Const
  LockSet  :  Set of Byte = [1..4,9,21..24];
  Fnum     =  MiscF;
  Keypath  =  MIK;


Var
  n     :  Byte;
  KeyStr:  Str255;
  LAddr :  LongInt;


Begin
  Result:=BOff;

  With MTExLocal^ do
  For n:=1 to 30 do
    If (n In LockSet) then
    Begin
      KeyStr:=FullPLockKey(PostUCode,PostLCode,n);

      LStatus:=LFind_Rec(B_GetEq+B_MultNWLock,Fnum,KeyPath,KeyStr);

      Result:=(LStatus=85) or (LStatus=84);

      If (LStatusOK) then {We need to unlock}
      Begin
        LStatus:=LGetPos(Fnum,LAddr);

        LStatus:=UnLockMLock(Fnum,LAddr);

        If (LStatus<>81) then
          LReport_BError(Fnum,LStatus);

      end;

      If (Result) then
        Break;
    end;


end;


{== Add up level 0 TB ==}

Function TGenReport.TB_Difference  :  Double;

Const
  Fnum     =  NomF;
  Keypath  =  NomCatK;


Var

  KeyChk,
  KeyStr :  Str255;

  ChkCr,
  ChkPr,
  ChkYr  :  Byte;

  Purch,Sales,Cleared
         :  Double;


Begin
  Result:=0.0; RepAbort:=BOff;

  ChkCr:=0; ChkPr:=99; ChkYr:=150;


  KeyChk:=FullNomKey(0);
  KeyStr:=KeyChk;

  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyStr);


    While (LStatusOk) and (CheckKey(KeyChk,KeyStr,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With LNom do
    Begin
      Result:=Result+Round_Up(LProfit_To_Date(NomType,FullNomKey(NomCode),ChkCr,ChkYr,ChkPr,Purch,Sales,Cleared,BOn),2);


      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyStr);

    end;

  end; {With..}

end;


Procedure TGenReport.Print_WarnDifference(RepDiff  :  Double;
                                          ErrRunNo :  LongInt;
                                          WriteLog :  Boolean);

Var
  Middle         :  Longint;
  TheDifference  :  Double;
  PrintedWarn    :  Boolean;

  GenStr         :  String;


Begin
  PrintedWarn:=BOff;  GenStr:='';

  With RepFiler1 do
  Begin
    Middle:=Round(PageWidth / 2);

    TheDifference:=RepDiff;


    If (ABS(TheDifference)>0.10) then
    Begin
      If (LinesLeft<5) then
        ThrowNewPage(5);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CRLF;
      DefFont (6,[fsBold,fsUnderLine]);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter ('WARNING!', Middle);
      Self.CRLF;

      PrintedWarn:=BOn;

      DefFont (3,[fsBold]);

      {$IFNDEF RW}
        GenStr:='Posting run '+Form_Int(ErrRunno,0)+' has an imbalance of '+FormatBFloat(GenRealMask,TheDifference,BOff);

        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintCenter(GenStr, Middle);
        Self.CRLF;

        {$IFNDEF XO}
          {$IFNDEF OLE}
            {$IFNDEF EDLL}
              {$IFNDEF ENDV}
                {$IFNDEF EXDLL}
                  {$IFNDEF COMP}
                    {$IFNDEF EBAD}
                      If (WriteLog) then {It is being run from the posting routine itself}
                        AddErrorLog(GenStr,'',4);
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}

    end;


    If (Not Being_Posted(0)) then {* We cannot check the TB as it is being posted elsewhere *}
    Begin
      TheDifference:=Round_Up(TB_Difference,2);


      If (ABS(TheDifference)>0.10) then
      Begin
        If (LinesLeft<5) then
          ThrowNewPage(5);


        DefFont (6,[fsBold,fsUnderLine]);

        If (Not PrintedWarn) then
        Begin
          // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
          Self.CRLF;
          Self.PrintCenter ('WARNING!', Middle);
          Self.CRLF;
        end
        else
        Begin
          // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
          Self.PrintCenter ('&', Middle);
          Self.CRLF;
        end;

        PrintedWarn:=BOn;

        DefFont (3,[fsBold]);

        {$IFNDEF RW}
          GenStr:='The Trial Balance has an imbalance of '+FormatBFloat(GenRealMask,TheDifference,BOff);

          {$IFNDEF XO}
            {$IFNDEF OLE}
              {$IFNDEF EDLL}
                {$IFNDEF ENDV}
                  {$IFNDEF EXDLL}
                    {$IFNDEF COMP}
                      {$IFNDEF EBAD}
                      If (WriteLog) then {It is being run from the posting routine itself, so add log once}
                        AddErrorLog(GenStr,'',4);
                      {$ENDIF}
                    {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}


        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintCenter(GenStr, Middle);
        Self.CRLF;

      end;
    end;

    If (PrintedWarn) then
    Begin
      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter('Please contact your Helpdesk for advice on correcting this problem.', Middle);
      Self.CRLF;
      Self.CRLF;

      DefFont (0,[]);
    end;

  end;
end;



{$IFNDEF RW}

  // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
  Procedure AddGenRep2Thread(      LMode                 : Byte;
                                   AOwner                : TObject;
                             Const OptionalFilteringMode : Integer = -1);


  Var
    EntTest  :  ^TGenReport;

  Begin

    If (Create_BackThread) then
    Begin
      New(EntTest,Create(AOwner));

      try
        With EntTest^ do
        Begin
          ReportMode:=LMode;
          // MH 30/10/2013 v7.X MRD1.1: Added Customer/Consumer filtering into Customer List Report
          FilteringMode := OptionalFilteringMode;

          If (Start) and (Create_BackThread) then
          Begin
            With BackThread do
              AddTask(EntTest,ThTitle);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(EntTest,Destroy);
          end;
        end; {with..}

      except
        Dispose(EntTest,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  Procedure Test_Report(AOwner  :  TObject);

  Var
    EntTest  :  ^TStaReport;

  Begin
    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=2;
        If (Start) then
        Begin
          Process;

          {Finish;}

          With MTExLocal^ do
            If (CRepParam^.ScrPtr^.ShowMonthDoc) then
              Close_File(F[ReportF]);


          {$IFDEF FRM}
            pfPrintBatch('',1,BOff,'');
          {$ENDIF}

          Dispose(EntTest,Destroy);
        end;
      end; {With..}
    except
      Dispose(EntTest,Destroy);

    end; {Try..}

  end;


  { ========== TADebReport methods =========== }

  Constructor TADebReport.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    New(CRepParam);

    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    // MH 04/10/2013 MRD1.1.29: Added report filter on account types
    oTraderCache := NIL;

    TmpLastC:='';
    TmpLastNC:=-1;
    IsPay:=BOff;
    IsMDC:=BOff;
    EuroConv_Detected:=BOff;

    FTraderAcCode := '';
    FTraderCompany := '';
    FTraderPhone := '';

  end;


  Destructor TADebReport.Destroy;

  Begin
    // MH 04/10/2013 MRD1.1.29: Added report filter on account types
    If Assigned(oTraderCache) Then
      FreeAndNIL(oTraderCache);

    Dispose(CRepParam);

    Inherited Destroy;
  end;




  Procedure TADebReport.Process;

  Begin
    Inherited Process;
  end;



  Procedure TADebReport.RepSetTabs;

  Begin
    With RepFiler1, CRepParam^ do
    Begin
      Case ReportMode of

          0  :  Begin
                  if not Summary then
                  begin
                    SetTab (MarginLeft, pjLeft, 4, 4, 0, 0);
                    SetTab (NA, pjLeft, 31, 4, 0, 0);
                    SetTab (NA, pjLeft, 39{31}, 4, 0, 0);  // MHYR
                    SetTab (NA, pjLeft, 19{22}, 4, 0, 0);  // MHYR
                    SetTab (NA, pjRight, 31, 4, 0, 0);
                    SetTab (NA, pjRight, 29, 4, 0, 0);
                    SetTab (NA, pjRight, 29, 4, 0, 0);
                    SetTab (NA, pjRight, 29, 4, 0, 0);
                    SetTab (NA, pjLeft, 22, 4, 0, 0);
                    SetTab (NA, pjRight, 29, 4, 0, 0);
                    SetTab (NA, pjCenter, 20, 4, 0, 0);
                  end
                  else
                  begin
                    SetTab (MarginLeft, pjLeft, 15, 4, 0, 0);  // A/C Code
                    SetTab (NA, pjLeft, 47, 4, 0, 0);          // Account Name
                    SetTab (NA, pjLeft, 31, 4, 0, 0);          // Telephone No.
                    SetTab (NA, pjRight, 34, 4, 0, 0);         // Posted Balance
                    SetTab (NA, pjRight, 34, 4, 0, 0);         // Debit
                    SetTab (NA, pjRight, 34, 4, 0, 0);         // Credit
                  end;
                end;

          1  :  Begin
                  // MH 06/10/2014 Order Payments: Added Order Payments indicator
                  SetTab (MarginLeft,  pjLeft, 18, 4, 0, 0);  // Ourref
                  SetTab (NA, pjLeft,  32, 4, 0, 0);          // YourRef
                  SetTab (NA, pjLeft,  15, 4, 0, 0);          // Date
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Total OS
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Not Due
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Current
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Age1
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Age2
                  SetTab (NA, pjRight, 25, 4, 0, 0);          // Age3
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Age4
                  SetTab (NA, pjRight, 26, 4, 0, 0);          // Total Due
                  SetTab (NA, pjLeft,   8, 4, 0, 0);          // Discount Status / Hold Flag
                end;

          2  :  Begin
                  SetTab (MarginLeft, pjLeft, 15, 4, 0, 0);
                  SetTab (NA, pjLeft, 42, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                  SetTab (NA, pjRight, 28, 4, 0, 0);
                end;


      end; {Case..}
    end; {With..}

    SetTabCount;
  end;


  Procedure TADebReport.RepPrintPageHeader;

  Var
    n       :  Byte;
    GenStrDate,
    GenStr  :  Str255;

  Begin
    GenStr:=''; n:=0;  GenStrDate:='';

    With RepFiler1,CRepParam^ do
    Begin
      DefFont(0,[fsBold]);

      Case ReportMode of

        0  :  begin
                if not Summary then       // SSK 06/04/2017 2017-R1 ABSEXCH-18439: else part added for Dues Summary Report
                  SendLine(ConCat(#9,#9,'Our Ref',#9,'Your Ref',#9,'Date Due',#9,'Posted Bal',#9,'Debit',#9,'Credit',#9,'S.Disc',#9,'Expires',#9,'Available',#9,'Status'))
                else
                  SendLine(ConCat(#9,'A/C Cde',#9,'Account Name',#9,'Telephone No.',#9,'Posted Bal.',#9,'Debit',#9,'Credit'));  // SSK 13/04/2017 2017-R1 ABSEXCH-18581: changed A/C Code to A/C Cde
              end;


        1  :  Begin
                If ((IsPay) and (Syss.StaUIDate)) or ((Not IsPay) and (Syss.PurchUIDate)) then
                  GenStrDate:='Trans. Date'
                else
                  GenStrDate:='Due Date';

                GenStr:=ConCat(#9,'Our Ref',#9,'Your Ref',#9,GenStrDate,#9,'Total O/S',#9,'Not Due',#9,'Current');

                For n:=1 to 4 do
                  GenStr:=GenStr+ConCat(#9,AgeTit[n]);

                GenStr:=GenStr+ConCat(#9,'Total Due',#9,'SD');

                SendLine(GenStr);
              end;


        2  :  Begin
                GenStr:=ConCat(#9,'A/C Cde',#9,'Account Name',#9,'Posted Bal.',#9,'Total O/S',#9,'Not Due',#9,'Current');   // SSK 13/04/2017 2017-R1 ABSEXCH-18581: changed A/C Code back to A/C Cde

                For n:=1 to 4 do
                  GenStr:=GenStr+ConCat(#9,AgeTit[n]);

                SendLine(GenStr);
              end;

      end; {case..}

      DefFont(0,[]);
    end; {With..}
  end; {Proc..}

  { ====================== Get Full Cust Rec & Print ====================== }

  Procedure TADebReport.PrintMDNomLine(Const Ccode  :  Str10;
                                       Const Cont   :  Boolean);

  Var
    ContStr  :  Str255;

  Begin
    With MTExLocal^,RepFiler1 do
    Begin
      LGetMainRec(NomF,Ccode);

      DefFont(1,[fsUnderline,fsBold]);

      If (Cont) then
        ContStr:=' (continued...)'
      else
        ContStr:='';

      SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,FullNomKey(LNom.NomCode),NomF,NomCodeK,0);

      With LNom do
        // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
        Self.PrintCenter(ConCat(dbFormatName(Form_Int(NomCode,0),Desc)+ContStr),(PageWidth/2));

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CrLF;

      {DefLine(-1,1,100,-0.3);}

      DefFont(0,[]);

    end; {With..}
  end;


  Procedure TADebReport.RepPrintHeader(Sender  :  TObject);


  Begin
    Inherited RepPrintHeader(Sender);

    Case ReportMode of
      0,1  :  If (RepFiler1.CurrentPage>1) then
              Begin
                If (TmpLastNC<>-1) and (ReportMode<>0) then
                  PrintMDNomLine(FullNomKey(TmpLastNC),BOn);

                // MH 22/02/2012 v6.10 ABSEXCH-12025: Modified to use a new clearer layout for Consolidated Aged Debtors/Creditors
                PrintCustLine(TmpLastC,BOn, (Not IsMDC));
              end;

    end; {Case..}


  end;



  Procedure TADebReport.PrintDueTot(GMode     :  Byte);

    Var
      n          :  Byte;

      PosttotMsg,
      PostBalMsg :  Str80;

      GenStr     :  Str255;


    Begin

      PosttotMsg:=''; PostBalMsg:=''; GenStr:='';


      DefFont(0,[]);

      With MTExLocal^,RepFiler1 do
        With CRepParam^ do
          Case ReportMode of
            0  :  Begin
                    Case GMode of
                      0  :  begin
                              If not Summary then
                                DefLine(-1,105,270,0);
                            end;

                      1  :  Begin
                              CustTotal:=RepTotal;
                              PostTotMsg:='Grand ';
                              CustAged:=RepAged;
                            end;

                      2  :  Begin
                              CustTotal:=PostTotal;
                              PostTotMsg:='Posted ';
                              CustAged:=PostAged;

                              {PostedBal:=CustTotal[BOff]-CustTotal[BOn];}

                              PostedBal:=ThisPostedBal;

                              Blank(CustTotal,Sizeof(CustTotal));
                            end;
                    end; {Case..}

                    // SSK 05/04/2017 2017-R1 ABSEXCH-18439: condition checked to separate Summary report from the detail one
                    If not Summary then
                    begin
                      ShowDrCr((CustTotal[BOff]-CustTotal[BOn]),CustTotal);

                      SendLine(ConCat(#9,#9,#9,#9,PostTotMsg,'Totals ..:',#9,FormatFloat(GenRealMask,PostedBal),
                            #9,FormatBFloat(GenRealMask,CustTotal[BOff],BOn),
                            #9,FormatBFloat(GenRealMask,CustTotal[BOn],BOn),
                            #9,FormatBFloat(GenRealMask,CustAged[6],BOn),#9,
                            #9,FormatBFloat(GenRealMask,CustAged[7],BOn)));

                    end
                    else
                      PrintDuesSummary(Gmode);

                    Case GMode of
                      0  :  If not Summary then DefLine(-1,105,270,0);
                      1  :  If not Summary then DefLine(-2,1,PageWidth-MarginRight-1,-0.5);
                    end; {Case..}

                    CustTotal[BOff]:=0; CustTotal[BOn]:=0;

                    Blank(CustAged,Sizeof(CustAged));

                    PostedBal:=0;

                  end; {Case..}

            1
               :  Begin

                    Case GMode of
                      0  :  Begin

                              DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);
                              PostBalMsg:='Posted Bal: ';
                              PostTotMsg:='Totals ..: ';

                              // MH 22/02/2012 v6.10 ABSEXCH-12026: Modified Posted Bals total to be a total of the individual account's Posted Bal
                              // fields instead of a random number generated from transactions using a completely different process
                              TotalPostedBalance := TotalPostedBalance + PostedBal;
                            end;

                      1  :  Begin
                              PostTotMsg:='Totals ..: ';
                              CustAged:=RepAged;

                            end;
                      2  :  Begin
                              PostBalMsg:='Posted Bals: ';

                              {CustAged:=PostAged;

                              PostTotMsg:='Postd Total: ';}

                              PostTotMsg:='';
                              Blank(CustAged,Sizeof(CustAged));


                              {PostedBal:=CustAged[7];

                              CustAged[7]:=0;}

                              // MH 22/02/2012 v6.10 ABSEXCH-12026: Modified Posted Bals total to be a total of the individual account's Posted Bal
                              // fields instead of a random number generated from transactions using a completely different process
                              PostedBal := TotalPostedBalance;
                              //PostedBal:=ThisPostedBal;
                            end;

                      3  :  Begin
                              CustAged:=MDCAged;

                              DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);

                              PostTotMsg:='Ctrl Total: ';
                              PostBalMsg:='Posted Bals: ';

                              PostedBal:=ThisPostedBal;

                            end;

                      4  :  Begin
                              CustAged:=GlobAged;

                              PostTotMsg:='Grand Total: ';
                              PostBalMsg:='Posted Bals: ';

                              PostedBal:=GrandPostedBal;
                            end;
                    end; {Case..}



                    GenStr:=(ConCat(#9,PostBalMsg,#9,FormatBFloat(GenRealMask,PostedBal,(GMode=1)),#9));

                    If (GMode<>2) then
                    Begin
                      GenStr:=GenStr+ConCat(PostTotMsg,#9,FormatFloat(GenRealMask,Custaged[7]));

                      For n:=0 to 6 do
                        GenStr:=GenStr+(ConCat(#9,FormatFloat(GenRealMask,Custaged[n])));

                    end;


                    SendLine(GenStr);

                    Case GMode of
                            // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
                      0  :  Self.CRLF;

                      1  :  DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

                      3  :  Begin
                              Blank(MDCAged,Sizeof(MDCAged));
                              ThisPostedBal:=0;
                              // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
                              Self.CRLF;
                            end;


                    end; {Case..}

                    Blank(CustAged,Sizeof(CustAged));

                    PostedBal:=0;


                  end;

            2
               :  Begin

                    Case GMode of

                      1  :  Begin
                              PostTotMsg:='Totals ..: ';

                              CustAged:=RepAged;

                              {PostedBal:=PostAged[7];}

                              PostedBal:=ThisPostedBal;

                            end;

                      3  :  Begin
                              CustAged:=MDCAged;

                              PostTotMsg:='Ctrl Totals: ';
                              PostBalMsg:='Posted Bals: ';

                              PostedBal:=ThisPostedBal;

                              DefLine(-1.3,1,PageWidth-MarginRight-1,-0.5);
                            end;

                      4  :  Begin
                              CustAged:=GlobAged;

                              PostTotMsg:='Grand Total: ';
                              PostBalMsg:='Posted Bals: ';

                              PostedBal:=GrandPostedBal;
                            end;


                    end; {Case..}


                                                                              {* Note vv *}

                    Case GMode of
                      0  :  Begin

                              LGetMainRec(CustF,LastCust);

                              GenStr:=(ConCat(#9,LCust.CustCode,
                                  #9,LCust.Company,
                                  #9,FormatFloat(GenRealMask,PostedBal),
                                  #9,FormatFloat(GenRealMask,CustAged[7])));

                              SetReportDrillDown(0);

                            end;

                      else
                             GenStr:=ConCat(#9,#9,
                                   PostTotMsg,#9,FormatFloat(GenRealMask,PostedBal),
                                   #9,FormatFloat(GenRealMask,CustAged[7]));

                    end; {Case..}

                    For n:=0 to 5 do
                      GenStr:=GenStr+ConCat(#9,FormatFloat(GenRealMask,Custaged[n]));


                    SendLine(GenStr);


                    Case GMode of
                      3  :  Begin
                              Blank(MDCAged,Sizeof(MDCAged));
                              ThisPostedBal:=0;
                              // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
                              Self.CRLF;
                            end;
                    end;

                    Blank(CustAged,Sizeof(CustAged));

                    PostedBal:=0;


                  end;



          end; {Case..}

    end;




    { ======================= Calculate Due Totals ==================== }

    Procedure TADebReport.CalcDueTotals(CrDr      :  DrCrType;
                                        SD,SDA    :  Real);

    Var
      nBo        :  Boolean;
      Rnum       :  Real;

    Begin

      Rnum:=0;

      With MTExLocal^,CRepParam^ do
        Case ReportMode of
          0
             :  Begin
                  For nBo:=BOff to BOn do
                  Begin
                    CustTotal[NBo]:=CustTotal[NBo]+CrDr[NBo];
                    RepTotal[NBo]:=RepTotal[NBo]+CrDr[NBo];

                  end;

                  CustAged[6]:=CustAged[6]+SD;
                  CustAged[7]:=CustAged[7]+SDA;

                  RepAged[6]:=RepAged[6]+SD;
                  RepAged[7]:=RepAged[7]+SDA;

                  If (LInv.RunNo>0) then
                  Begin
                    PostAged[6]:=PostAged[6]+SD;
                    PostAged[7]:=PostAged[7]+SDA;
                  end;

                end;
          1,2
             :  With LInv do
                Begin

                  Rnum:=Currency_Txlate(ThisInvBal,RCr,RTxCr);

                  MasterAged(CustAged,Get_StaChkDate(LInv),DueLimit,Rnum,RAgeBy,RAgeInt);

                  MasterAged(RepAged,Get_StaChkDate(LInv),DueLimit,Rnum,RAgeBy,RAgeInt);

                  MasterAged(GlobAged,Get_StaChkDate(LInv),DueLimit,Rnum,RAgeBy,RAgeInt);

                  MasterAged(MDCAged,Get_StaChkDate(LInv),DueLimit,Rnum,RAgeBy,RAgeInt);
                end;
        end; {Case..With..}
    end;



  Procedure TADebReport.SetReportDrillDown(DDMode  :  Byte);

  Begin
    With MTExLocal^ do
    Begin
      Case ReportMode of
        2         :  SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);

        0,1       :  SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);

      end; {Case..}
    end; {With..}
  end;


  Procedure TADebReport.PrintReportLine;


  Const
    Fnum    =  InvF;
    KeyPath =  InvFolioK;

  Var
    CrDr       :  DrCrType;
    LineAged   :  AgedTyp;

    Rnum,
    Sales,Purch,
    SDisc,
    SAvail,

    Cleared    :  Double;

    n,UOR      :  Byte;
    PostChar   :  String[1];

    AgedDate,
    SExpires   :  Str20;

    LGenStr,
    GenStr     :  Str255;

    OrdPayFlag : String[1];
Begin

    Rnum:=0; PostChar:='';

    Purch:=0; Sales:=0; Cleared:=0;

    GenStr:=''; LGenStr:='';

    SDisc:=0.0; SAvail:=0.0;  UOR:=0;
    
    With MTExLocal^,RepFiler1 do
      With CRepParam^ do
      Begin

        Case ReportMode of
          0..2
               :  With LInv Do
                  Begin
                    If (CustCode<>LastCust) then
                    Begin
                      If (LastCust<>'') then
                        PrintDueTot(0);

                      Case ReportMode of

                                // MH 22/02/2012 v6.10 ABSEXCH-12025: Modified to use a new clearer layout for Consolidated Aged Debtors/Creditors
                        0,1  : begin
                                 If (Not Summary) then
                                   PrintCustLine(CustCode,BOff, True)
                                 else
                                 begin  // SSK 04/04/2017 2017-R1 ABSEXCH-18439: store trader's info to display in Summary Only Report
                                   FTraderAcCode := trim(LCust.CustCode);
                                   FTraderCompany := trim(LCust.Company);
                                   FTraderPhone := trim(LCust.Phone);
                                 end;

                               end;



                      end; {Case..}

                      LastCust:=CustCode;

                      TmpLastC:=CustCode;

                      PostedBal:=LProfit_to_Date(CustHistPCde,CustCode,RCr,RYr,RPr,Purch,Sales,Cleared,BOn);

                      PostedBal:=Currency_Txlate(PostedBal,RCr,RTxCr);
                    end;


                    {If (RCr=0) then
                      Rnum:=BaseTotalOS(Inv)
                    else
                      Rnum:=CurrencyOS(Inv,On,Off,Off);}

                    Rnum:=Currency_Txlate(ThisInvBal,RCr,RTxCr);

                    If (DiscSetAm<>0) and (Not DiscTaken) then
                    Begin
                      SExpires:=CalcDueDate(TransDate,DiscDays);

                      {$IFDEF MC_On}
                        If (RCr=0) then
                        Begin
                          UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

                          SDisc:=Round_Up(Conv_TCurr(DiscSetAm,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);

                        end
                        else
                          SDisc:=DiscSetAm;

                        SDisc:=Currency_Txlate(SDisc,RCr,RTxCr);

                      {$ELSE}
                        SDisc:=DiscSetAm;

                      {$ENDIF}

                      SDisc:=SDisc*DocCnst[InvDocHed]*DocNotCnst;

                      If (SExpires>=DueLimit) then
                        SAvail:=SDisc
                      else
                        SAvail:=0.0;

                      SExpires:=POutDate(SExpires);
                    end
                    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Include Prompt Payment Discount Goods and VAT Values
                    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                    else If ((thPPDGoodsValue <> 0.0) Or (thPPDVATValue <> 0.0)) And (thPPDTaken = ptPPDNotTaken) Then
                    Begin
                      // Prompt Payment Discount available
                      SExpires:=CalcDueDate(TransDate, thPPDDays);

                      {$IFDEF MC_On}
                        If (RCr=0) then
                    Begin
                          UOR := fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);
                          SDisc := Round_Up(Conv_TCurr(Round_Up(thPPDGoodsValue + thPPDVATValue, 2),XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff),2);
                        end
                        else
                          SDisc:=Round_Up(thPPDGoodsValue + thPPDVATValue, 2);

                        SDisc:=Currency_Txlate(SDisc,RCr,RTxCr);
                      {$ELSE}
                        SDisc:=Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
                      {$ENDIF}

                      SDisc:=SDisc*DocCnst[InvDocHed]*DocNotCnst;

                      If (SExpires>=DueLimit) then
                        SAvail:=SDisc
                      else
                        SAvail:=0.0;

                      SExpires:=POutDate(SExpires);
                    End // If ((thPPDGoodsValue <> 0.0) Or (thPPDVATValue <> 0.0)) And (thPPDTaken = ptPPDNotTaken)
                    Else
                    Begin
                      SExpires:='';
                      SAvail:=0.0;
                      SDisc:=0.0;
                    end;


                    PostChar:=IfThen(RunNo=0,'*','');

                    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Include Prompt Payment Discount Goods and VAT Values
                    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                    GenStr:=DiscStatus[0 + (1*Ord((DiscSetAm<>0) Or ((thPPDGoodsValue + thPPDVATValue) <> 0.0))) + (1*Ord(DiscTaken Or (thPPDTaken <> ptPPDNotTaken)))];

                    GenStr:=GenStr+DisplayHold(HoldFlg);

                  end;

        end; {Case..}


        DefFont (0,[]);

        If (Not Summary) then
          SetReportDrillDown(0);

        Case ReportMode of
          0  :  With LInv do
                Begin
                  ShowDrCr(Rnum,CrDr);
                  If (Not Summary) then                      // SSK 05/04/2017 2017-R1 ABSEXCH-18439: skip for Dues Summary Report
                  begin
                    SendLine(ConCat(#9,PostChar,#9,OurRef,
                                    #9,YourRef,
                                    #9,POutDate(DueDate),#9,
                                    #9,FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                                    #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn),
                                    #9,FormatBFloat(GenRealMask,SDisc,BOn),
                                    #9,SExpires,
                                    #9,FormatBFloat(GenRealMask,SAvail,BOn),
                                    #9,GenStr));
                  end;

                end;
          1  :  If (Not Summary) then
                With LInv do
                Begin
                  Blank(LineAged,SizeOf(LineAged));


                    AgedDate:=Get_StaChkDate(LInv);

                    MasterAged(LineAged,AgedDate,DueLimit,Rnum,RAgeBy,RAgeInt);

                  // MH 06/10/2014 Order Payments: Added Order Payments indicator
                  OrdPayFlag := IfThen((Filt='C') And (thOrderPaymentElement <> opeNA), '!', '');

                  LGenStr:=ConCat(#9,OurRef,PostChar,OrdPayFlag,#9,YourRef,
                                  #9,POutDate(AgedDate),
                                  #9,FormatFloat(GenRealMask,Lineaged[7]));


                  For n:=0 to 6 do
                    LGenStr:=LGenStr+ConCat(#9,FormatBFloat(GenRealMask,Lineaged[n],BOn));

                  SendLine(Concat(LGenStr,#9,GenStr));
                end;


        end; {Case..}


        CalcDueTotals(CrDr,SDisc,SAvail);

      end; {With(s)..}
  end;


  { === Function to Back calculate the o/s balance of a transaction for a previous period === }


  Function TADebReport.Calc_PrevAgedBal(InvR  :  InvRec;
                                        RPr,RYr,
                                        RCr   :  Byte;

                                        MTyp  :  Char;

                                        OldKPath
                                              :  Integer;

                                        ANow  :  Boolean)  :  Double;


   Const
     Fnum      =  PWrdF;


   Var
     UOR       :  Byte;
     KeyCS,
     KeyChk,
     KeyI      :  Str255;

     Keypath   :  Integer;


     DNum,
     AddVar,
     VRate,
     InitValue :  Double;

     FoundOk,
     DiffCurr,
     MatchedDoc:  Boolean;

     // CA 22/05/2013 v7.0.4 ABSEXCH-12134 ***  New Variables required for enhancement
     OldInv    : InvRec;
     Loop      : Integer;
     TransCnst : Integer;

   Begin
     Result:=0;
     InitValue:=0;
     UOR:=0;
     DiffCurr:=BOff;
     AddVar:=0.0; VRate:=0.0;


     If (ANow) then
     Begin
       If (RCr=0) then
         Result:=BaseTotalOS(InvR)
       else
         Result:=CurrencyOS(InvR,BOn,BOff,BOff);
     end
     else
     With MTExLocal^,InvR do
     If (Not (InvDocHed In DirectSet+PSOPSet)) then
     Begin

       // CA 22/05/2013 v7.0.4 ABSEXCH-12134 ** Placed here to ensure appropriate record is used
       OldInv := LInv;

       // Calculation must now be down outside the main loop
      {* Modded so currency 1 items take into account variance when variance taken, otherwise var amount
         remains o/s v4.30 *}
      If (RCr=0) or ((RCr=1) and (InvDocHed In RecieptSet) and
         (Round_Up(TotalReserved, 2) = (Round_up(Variance, 2) + Round_up(PostDiscAm, 2)))) then //HV 24/04/2017 2017-R2 ABSEXCH-16868: back dated aged report incorrectly shows discount as outstanding
         InitValue:=ConvCurrITotal(LInv,BOff,BOn,BOn)
       else
         InitValue:=Itotal(LInv);

       InitValue:=InitValue*DocCnst[InvDocHed]*DocNotCnst;


       // CA 22/05/2013 v7.0.4 ABSEXCH-12134 ** New loop created with the appropriate transaction which will
       //                                      be used in the calculation process
       for Loop:=0 to 1 Do
       Begin

           if Loop = 0 Then
           Begin
              MatchedDoc := True;
              TransCnst  := -1;
           end
           else
              Begin
                 MatchedDoc := False;
                 TransCnst  := 1;
              End;

           If (MatchedDoc) then
             Keypath:=PWK
           else
             Keypath:=HelpNdxK;

         KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);
         KeyCS:=KeyChk;

         LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

         While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) do
         With LPassword.MatchPayRec do
         Begin

           If (MatchType=MTyp) then
           Begin
             If (MatchedDoc) then
               KeyI:=PayRef
             else
               KeyI:=DocCode;

             FoundOk:=LCheckRecExsists(KeyI,InvF,InvOurRefK);

             {*If the other part of the match cannot be found, and it has been purged, assume it was purged *}
             If (Not FoundOk) and (Syss.AuditYr<>0) then
             Begin
               If (RCr=0) then
                  Result:= Result + (SettledVal * TransCnst)
               else
                  Result:= Result + (OwnCVal * TransCnst);
             end;

             If (FoundOk) and (Pr2Fig(LInv.AcYr,LInv.AcPr)<=Pr2Fig(RYr,RPr)) then
             Begin
               If (Not DiffCurr) then {*v4.31.004 if matched with mixed currency readd in variance on receipts*}
                 DiffCurr:=LInv.Currency<>InvR.Currency;

               If (MatchedDoc) or (RCr=0) then
               Begin
                 If (RCr=0) then
                   Result := Result + (SettledVal * TransCnst)
                 else
                   Result := Result + (OwnCVal * TransCnst);
               end
               else
               Begin
                 If (LInv.Currency=MCurrency) then {* Go via docs own currency rate *}
                 Begin

                   If (MCurrency<>InvR.Currency) then {* Convert via sterling *}
                   Begin
                     UOR    := fxUseORate(BOff,BOn,LInv.CXRate,LInv.UseORate,MCurrency,0);

                     Dnum   := Conv_TCurr(OwnCVal,XRate(LInv.CXRate,BOff,MCurrency),MCurrency,UOR,BOff);

                     UOR    := fxUseORate(BOff,BOn,InvR.CXRate,InvR.UseORate,InvR.Currency,0);

                     Result := Result + (Conv_TCurr(Dnum,XRate(InvR.CXRate,BOff,InvR.Currency),InvR.Currency,UOR,BOn) * TransCnst);
                   end
                   else
                     Result := Result + (OwnCVal * TransCnst);

                 end
                 else
                 Begin
                     If (MCurrency<>InvR.Currency) then
                       Result:= Result + (Currency_ConvFT(OwnCVal,MCurrency,InvR.Currency,UseCoDayRate) * TransCnst)
                     else
                       Result:= Result + (OwnCVal * TransCnst);
                 end;
               end;
             end; {If Found & in Period..}
           end; {If right type of match record }
           LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

         end;  {Loop..}
       end; {While..}

       LInv := OldInv;

       {* v4.31.004 add back in variance to receipts matched with mixed currencies as it will be needed*}

       If (InvR.InvDocHed In RecieptSet) and (DiffCurr) and (RCr>1) and (Variance<>0.0) then
       Begin
         VRate     := XRate(InvR.CXRate,BOff,InvR.Currency);
         AddVar    := Round_Up(Conv_TCurr(InvR.Variance,VRate,InvR.Currency,InvR.UseORate,BOn),2)*DocCnst[InvR.InvDocHed]*DocNotCnst;
         InitValue := InitValue+AddVar;
       end;

       // CA 22/05/2013 v7.0.4 ABSEXCH-12134 ** Calculation has to be performed to ensure the appropriate result is produced
       Result:=Round_Up(InitValue+Result,2);

       {$IFDEF MC_On} {* v4.30 Surpress odd fractions due to rounding because vat element
                      normally is rounded up seperately, and matched amount is one lump *}
        If (ABS(Result)<0.02) and (Result<>0.00) and (RCr<>0) then
          Result:=0.0;

      {$ENDIF}
     end; {If Calc old Balance}
   end; {Func..}



  { == Function Include Paytpe == }

  Function TADebReport.IncludePayType  :  Boolean;

  Const
    AgeTypes  :  Array[0..4] of Char = (#0,BACSCCode,BACSRCode,BACS2Code,BACS3Code);

  Begin
    With MTExLocal^,CRepParam^ do
    Begin
      {$B-}
      Result:=(ReportMode<>0) or (RAgeBy=0) or (LCust.PayType=AgeTypes[RAgeBy]);
      {$B+}
    end;
  end;


  function TADebReport.IncludeRecord  :  Boolean;


  Var
    TmpInclude :  Boolean;

    Rnum,
    Purch,
    Sales,
    Cleared,
    PostedValue:  Double;

    SExpires   :  LongDate;
    SDiscAmount : Double;

    KeyCS      :  Str255;


  Begin
    Rnum:=0; PostedValue:=0;

    TmpInclude:=BOff;

    KeyCS:='';

    {$B-}

    With MTExLocal^,RepFiler1 do
      With CRepParam^ do
      Begin
        Case ReportMode of
          0,1,2
               :  With LInv do
                  Begin

                    {$IFDEF PF_On}

                      LGetMainRec(CustF,CustCode);

                    {$ENDIF}

                    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Include Prompt Payment Discount Goods and VAT Values
                    If ((thPPDGoodsValue + thPPDVATValue) <> 0.0) Then
                    Begin
                      // Prompt Payment Discount
                      SExpires := CalcDueDate(TransDate, thPPDDays);
                      SDiscAmount := Round_Up(thPPDGoodsValue + thPPDVATValue, 2);
                    End // If ((thPPDGoodsValue + thPPDVATValue) <> 0.0)
                    Else
                    Begin
                      // Settlement Discount / Legacy behaviour
                      SExpires := CalcDueDate(TransDate, DiscDays);
                      SDiscAmount := DiscSetAm;
                    End; // Else

                    // MH 04/10/2013 MRD1.1.29: Added report filter on account types for Receipts Due report
                    If (ReportMode = 0) And Syss.ssConsumersEnabled And (CRepParam^.IncludeAccountTypes <> atCustomersAndConsumers) Then
                    Begin
                      // Apply additional filtering on Customer/Consumer sub type
                      If (Not Assigned(oTraderCache)) Then
                        oTraderCache := TTraderCache.Create;

                      // Check the caching object to avoid multiple reads of the same record
                      TmpInclude := (oTraderCache.GetSubType(LInv.CustCode) = IfThen(CRepParam^.IncludeAccountTypes = atCustomersOnly, ConsumerUtils.CUSTOMER_CHAR, ConsumerUtils.CONSUMER_CHAR));
                    End // If (ReportMode = 0) And Syss.ssConsumersEnabled And (CRepParam^.IncludeAccountTypes <> atCustomersAndConsumers)
                    Else
                      TmpInclude := True;

                    TmpInclude := TmpInclude And
                                  // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Include Prompt Payment Discount Goods and VAT Values
                                  ((CustSupp=Filt) and (((DueDate<=DueLimit) or (IncSDisc and (SExpires>=DueLimit) and (SDiscAmount<>0.0)))
                                   or (ReportMode<>0))

                                  and (RunNo>=0)
                                  and (Not (InvDocHed In QuotesSet))
                                  and ((GetHoldType(HoldFlg)<>HoldQ) or (RunNo>0))

                                  and ((Pr2Fig(AcYr,AcPr)<=Pr2Fig(RYr,RPr)) or (Not PrevMode))

                                  and (IncludePayType)
                                  and ((CtrlNom=Check_MDCCC(CtrlNomFilt)) or (CtrlNom=CtrlNomFilt) or (CtrlNomFilt=0))
                                  and ((Currency=RCr) or (RCr=0)));


                    If (RCr=0) then
                      Rnum:=ConvCurrITotal(LInv,BOff,BOn,BOn)
                    else
                      Rnum:=Itotal(LInv);


                    Rnum:=Currency_Txlate(Rnum*DocCnst[InvDocHed]*DocNotCnst,RCr,RTxCr);

                    {$IFDEF PF_On}  {* Filter on cost Ctr & Dep *}


                          TmpInclude:=((TmpInclude)
                                       and (Match_WildChar(LCust.CustCC,RCCDep[BOn],BOff,BOn))
                                       and (Match_WildChar(LCust.CustDep,RCCDep[BOff],BOff,BOn)));

                    {$ENDIF}



                    If ((TmpInclude) and (Pr2Fig(ACYr,AcPr)<=Pr2Fig(RYr,RPr)))
                       and (RunNo>0) and (Not (InvDocHed In DirectSet)) then
                    Begin
                      If (Syss.AuditYr=0) then {* Use Invoice Value *}
                        PostedValue:=Rnum
                      else
                        If (KeepCust<>CustCode) then
                        Begin
                          {$IFDEF EXSQL}
                          if SQLUtils.UsingSQL then
                            PostedValue:=Currency_Txlate(LProfit_to_Date(CustHistPCde,CustCode,RCr,RYr,RPr,Purch,Sales,Cleared,BOn),RCr,RTxCr)
                          else
                          {$ENDIF}
                            PostedValue:=Currency_Txlate(Profit_to_Date(CustHistPCde,CustCode,RCr,RYr,RPr,Purch,Sales,Cleared,BOn),RCr,RTxCr);
                          KeepCust:=CustCode;
                        end;

                      Case ReportMode of
                        0  :  PostTotal[(Rnum<0)]:=PostTotal[(Rnum<0)]+ABS(Rnum);

                        1,2
                           :  MasterAged(PostAged,DueDate,DueLimit,Rnum,RAgeBy,RAgeInt);

                      end; {Case..}{If..}

                      ThisPostedBal:=ThisPostedBal+PostedValue;
                    end;


                    If (TmpInclude) then
                      ThisInvBal:=Calc_PrevAgedBal(LInv,RPr,RYr,RCr,DocMatchTyp[BOff],RKeypath,Not PrevMode);


                    Rnum:=ThisInvBal;


                    {If (RCr=0) then
                      Rnum:=BaseTotalOS(Inv)
                    else
                      Rnum:=CurrencyOS(Inv,On,Off,Off);}

                    TmpInclude:=(TmpInclude and ((Rnum<>0) or (Not OSOnly)) );

                    If ((DueDate>DueLimit) and (ReportMode=0)) then
                    Begin
                      KeyS:=Filt+CustCode+NdxWeight;

                      B_Next:=B_GetGEq;
                    end
                    else
                      B_Next:=B_GetNext;
                  end;

        end; {Case..}

        If (TmpInclude) and (Not EuroConv_Detected) then
          EuroConv_Detected:=(LInv.OldORates[UseCoDayRate]<>0.0);

      end; {With..}

      {$B+}

      Result:=TmpInClude;
  end;

  Procedure TADebReport.Print_EuroConv;

  Var
    Middle         :  Longint;
    GenStr         :  Str255;


  Begin

    With RepFiler1 do
    Begin
      Middle:=Round(PageWidth / 2);

      If (LinesLeft<5) then
        ThrowNewPage(5);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.CRLF;
      DefFont (0,[fsBold,fsUnderLine]);

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter ('Note', Middle);
      Self.CRLF;

      DefFont (0,[fsBold]);

      GenStr:='Base conversion transactions are contained within this report, which may contain small rounding differences that are not considered material.';

      // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
      Self.PrintCenter(GenStr, Middle);
      Self.CRLF;
      Self.CRLF;


    end;
  end;


  Procedure TADebReport.PrintEndPage;

  Begin
    With RepFiler1,CRepParam^ do
    Begin
      If (Not IsMDC) then
      Begin
        PrintDueTot(0);

        If RepPrintExcelTotals then
        Begin
          If (ReportMode<>2) then
          Begin
            DefFont(-2,[fsItalic,fsBold]);

            // MH 03/06/2015 2015-R1 ABSEXCH-16376: Remove Order Payments note from non-SPOP systems
            {$IFDEF SOP}
            If (ReportMode = 1) And (CRepParam^.Filt = 'C') Then
              // MH 06/10/2014 Order Payments: Extended explanitory text for Aged Debtors Split by Control Account
              //PrintLn('* denotes unposted transactions, ! denotes Order Payment transactions')
              // MH 08/01/2015 v7.1 ABSEXCH-15970: Suppress message for non-UK companies
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.PrintLeft('* denotes unposted transactions' + IfThen(CurrentCountry = UKCCode, ', ! denotes Order Payment transactions', ''),MarginLeft)
            Else
            {$ENDIF SOP}
              // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
              if not Summary then     // SSK 10/04/2017 2017-R1 ABSEXCH-18580: skip it for Summary report
                Self.PrintLeft('* denotes unposted transactions',MarginLeft);

          end;

            DefLine(-1,1,PageWidth-MarginRight-1,0);

          PrintDueTot(1);

          If (ReportMode<>2)then
            PrintDueTot(2);
        end;
      end;

      If (EuroConv_Detected) and RepPrintExcelTotals  then
        Print_EuroConv;

      if (ReportMode = 0) and Summary then ICount := FSummaryRecCount;   // SSK 10/04/2017 2017-R1 ABSEXCH-18580: bring proper record count for Dues Summary Report

        Inherited PrintEndPage;
    end; {With..}
  end;


  Function TADebReport.GetReportInput  :  Boolean;

  Var
    BoLoop
       :  Boolean;
    n  :  Integer;

    FoundCode
       :  Str20;

    FoundInt
       :  LongInt;


  Begin
    RFnum:=InvF;

    RKeyPath:=InvCDueK;

    RepKey:=TradeCode[IsPay];



    With CRepParam^ do
    Begin

      Filt:=TradeCode[IsPay];


      Case ReportMode of

        0    :  Begin
                  OSOnly:=BOn;

                  RPr:=GetLocalPr(0).CPr;

                  RYr:=GetLocalPr(0).CYr;


                  If (IsPay) then
                    ThTitle:='Receipts due'
                  else
                    ThTitle:='Payments due';

                  RepTitle:=ThTitle+' by '+PoutDate(DueLimit);

                  PageTitle:=RepTitle;

                  Case RAgeBy of

                    1 :  RepTitle2:='Cheque based accounts';
                    2 :  RepTitle2:='Electronic payment (BACS) based accounts';
                    3 :  RepTitle2:='Cheque based accounts (2)';
                    4 :  RepTitle2:='Cheque based accounts (3)';

                  end; {Case..}

                  if Summary then               // SSK 10/04/2017 2017-R1 ABSEXCH-18580: choose portrait orientation for Summary Report
                    ROrient:=RPDefine.poPortrait
                  else
                    ROrient:=RPDefine.PoLandscape;
                end;

        1,2  :  Begin
                  DueLimit:=Today;

                  If (IsPay) then
                    ThTitle:='Debtors'
                  else
                    ThTitle:='Creditors';

                  ThTitle:='Aged '+ThTitle+' Report';

                  RepTitle:=ThTitle;

                  PageTitle:=ThTitle+' - Posted bal as at '+PPR_OutPr(RPr,RYr)+' Aged by '+AgedHed[RAgeBy];

                  {$IFDEF  PF_On}

                    For BoLoop:=BOff to BOn do
                      If (Not EmptyKeyS(RCCDep[BoLoop],ccKeyLen,BOff)) then
                      With MTExLocal^ do
                      Begin
                        FoundCode:=RCCDep[BoLoop];

                        GetCCDep(Application.MainForm,FoundCode,FoundCode,BoLoop,-1);

                        If (RepTitle2<>'') then
                          RepTitle2:=RepTitle2+', ';

                        RepTitle2:=RepTitle2+CostCtrRTitle[BoLoop]+' '+RccDep[BoLoop]+'-'+Password.CostCtrRec.CCDesc;

                      end; {Loop..}

                  {$ENDIF}

                  For n:=1 to 4 do
                  Begin

                    AgeTit[n]:=Form_Int((RAgeInt*n),0)+' '+AgedHed[RAgeBy];

                    If ((n*RAgeInt)>1) then
                      AgeTit[n]:=AgeTit[n]+'s';

                    If (n=4) then
                      AgeTit[n]:=AgeTit[n]+'+';

                  end;

                  If (PrevMode) then
                    DueLimit:=LPr2Date(RPr,RYr,MTExLocal);

                  RFont.Size:=7;
                  ROrient:=RPDefine.PoLandscape;

                  If (Not EmptyKey(ACFilt,CustKeyLen)) then
                  Begin
                    If (GetCust(Application.MainForm,FullCustCode(ACFilt),FoundCode,BOff,-1)) then
                    With Cust do
                    Begin
                      RepKey:=RepKey+CustCode;

                      If (RepTitle2<>'') then
                        RepTitle2:=RepTitle2+'. ';

                      RepTitle2:=RepTitle2+'Account Filter : '+dbFormatName(CustCode,Company);
                    end;
                  end;


                  If (CtrlNomFilt<>0) then
                  Begin
                    If (GetNom(Application.MainForm,Form_Int(CtrlNomFilt,0),FoundInt,-1)) then
                    With Nom do
                    Begin
                      If (RepTitle2<>'') then
                        RepTitle2:=RepTitle2+'. ';

                      RepTitle2:=RepTitle2+'G/L Ctrl Code Filter : '+dbFormatName(Form_Int(CtrlNomFilt,0),Desc);
                    end;
                  end;

                end;




      end; {Case..}

      {$IFDEF MC_On}

        If (RTxCr<>0) and (RTxCr<>RCr) then
          RepTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+RepTitle
        else
          RepTitle:=CurrDesc(RCr)+RepTitle;

        If (RTxCr<>0) and (RTxCr<>RCr) then
          PageTitle:=CurrDesc(RCr)+'to '+CurrDesc(RTxCr)+PageTitle
        else
          PageTitle:=CurrDesc(RCr)+PageTitle;

      {$ENDIF}

    end; {With..}

    // MH 22/02/2012 v6.10 ABSEXCH-12026: Modified Posted Bals total to be a total of the individual account's Posted Bal
    // fields instead of a random number generated from transactions using a completely different process
    TotalPostedBalance := 0.0;

    Result:=BOn;
  end;





  Procedure TADebReport.Finish;


  Begin
    Inherited Finish;
  end;

  
  //SS:11/04/2017 2017-R1 ABSEXCH-18439: Fixed build fail issue raised due to the $IFNDEF RW.
  procedure TADebReport.PrintDuesSummary(pMode: byte);
  begin
    // SSK 04/04/2017 2017-R1 ABSEXCH-18439: this will Print SummaryLine & Footer
    with CRepParam^, RepFiler1 do
    begin
      if (pMode = 0) then   // 0  means print the line
      begin
        // Set print preview drill-down information
        SendRepDrillDown(1,TotTabs,1,FullCustCode(FTraderAcCode),CustF,CustCodeK,0);     // SSK 11/04/2017 2017-R1 ABSEXCH-18581: drill down changed to show proper drill down
        ShowDrCr((CustTotal[BOff]-CustTotal[BOn]),CustTotal);
        if FTraderAcCode<>'' then
        begin
          Inc(FSummaryRecCount);
          SendLine(ConCat(#9, FTraderAcCode,
                          #9, FTraderCompany,
                          #9, FTraderPhone,
                          #9, FormatBFloat(GenRealMask,Round_Up(PostedBal, 2),BOn),     // SSK 11/04/2017 2017-R1 ABSEXCH-18580: roundup done to avoid 0.00 for negative value
                          #9, FormatBFloat(GenRealMask,CustTotal[BOff],BOn),
                          #9, FormatBFloat(GenRealMask,CustTotal[BOn],BOn)));

        end;
      end
      else
      if (pMode = 1) then    // 1  means print the Footer line
      begin
        ShowDrCr((CustTotal[BOff]-CustTotal[BOn]),CustTotal);
        if FTraderAcCode<>'' then
          SendLine(ConCat(#9,#9,#9,'Grand Totals ',
                          #9, FormatBFloat(GenRealMask,ThisPostedBal,BOn),                                 // Posted Totals
                          #9, FormatBFloat(GenRealMask,CustTotal[BOff],BOn),                               // Credit Totals
                          #9, FormatBFloat(GenRealMask,CustTotal[BOn],BOn)));                              // Debit Totals
      end;
    end;

  end;


  { ======== }


  { ========== TMDCReport methods =========== }

  Constructor TMDCReport.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    ExtCustRec:=nil;
    ExtCustObj:=nil;

    AddressList := TStringList.Create;
    AddressListIndex := -1;
    IsMDC:=BOn;

  end;


  Destructor TMDCReport.Destroy;

  Begin
    ClearAddressList;
    FreeAndNil(AddressList);
    Inherited Destroy;
  end;

  procedure TMDCReport.ClearAddressList;
  var
    i: Integer;
  begin
    for i := 0 to AddressList.Count - 1 do
    begin
      TRecordAddress(AddressList.Objects[i]).Free;
      AddressList.Objects[i] := nil;
    end;
    AddressList.Clear;
  end;


  Procedure TMDCReport.Build_MDCAgedDoc(Var FoundOk  :   Boolean);

  Const
    Fnum    =  InvF;
    Keypath =  InvCustK;

  Var
    KeyChk,
    KeyCS        :  Str255;

    InvKey: string;

    NeedTransUpdate,
    LOk,Locked,
    TmpInclude  :  Boolean;

    Rnum,
    Purch,
    Sales,
    Cleared,
    PostedValue :  Real;

    RecAddr     :  LongInt;



  Begin
    LOK := False;
    With MTExLocal^ do
    Begin

MDCADCalled := MDCADCalled + 1;

      With LCust do
      Begin

        KeyChk:=FullCustType(CustCode,CustSupp)+#1;  {* Ignore Nom Ledger Items *}

      end;

      KeyCS:=KeyChk;

      LRepScr^.FileNo := Fnum;

      With CRepParam^ Do
      Begin
        // MH 27/06/08: Moved outside of InvF loop as it is only checking fields on CustF
        {$IFDEF PF_On}  {* Filter on cost Ctr & Dep *}
          TmpInclude := Match_WildChar(LCust.CustCC, RCCDep[BOn], BOff, BOn) And Match_WildChar(LCust.CustDep, RCCDep[BOff], BOff, BOn);
        {$ELSE}
          TmpInclude := True;
        {$ENDIF}
        If TmpInclude Then
        Begin
          If (PrevMode) then
            LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS)
          else
            LStatus:=GetExtCusALCid(ExtCustRec,ExtCustObj,Fnum,Keypath,B_GetGEq,1,KeyCS);

          While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) Do
          Begin
            With LInv do
            Begin
              TmpInclude:=((CustSupp=Filt)
                            and (RunNo>=0)
                            and (Not (InvDocHed In QuotesSet))
                            and ((GetHoldType(HoldFlg)<>HoldQ) or (RunNo>0))

                            and ((Pr2Fig(AcYr,AcPr)<=Pr2Fig(RYr,RPr)) or (Not PrevMode))
                            and ((CtrlNom=Check_MDCCC(CtrlNomFilt)) or (CtrlNom=CtrlNomFilt) or (CtrlNomFilt=0))
                            and ((Currency=RCr) or (RCr=0)));
If (Not TmpInclude) Then MDCADFail1 := MDCADFail1 + 1;

              If (RCr=0) then
                Rnum:=ConvCurrITotal(LInv,BOff,BOn,BOn)
              else
                Rnum:=Itotal(LInv);

              Rnum:=Rnum*DocCnst[InvDocHed]*DocNotCnst;

// MH 27/06/08: Moved outside of InvF loop as it is only checking fields on CustF
//            {$IFDEF PF_On}  {* Filter on cost Ctr & Dep *}
//              TmpInclude := ((TmpInclude)
//                             and (Match_WildChar(LCust.CustCC,RCCDep[BOn],BOff,BOn))
//                             and (Match_WildChar(LCust.CustDep,RCCDep[BOff],BOff,BOn)));
//            {$ENDIF}

              If (TmpInclude) then
                Rnum:=Calc_PrevAgedBal(LInv,RPr,RYr,RCr,DocMatchTyp[BOff],Keypath,Not PrevMode);

If TmpInclude Then
Begin
              TmpInclude:=(TmpInclude and ((Rnum<>0) or (Not OSOnly)) );
  If (Not TmpInclude) Then MDCADFail2 := MDCADFail2 + 1;
End; // If TmpInclude

//              If (TmpInclude) and (Assigned(ThisScrt)) then
              If (TmpInclude) then
              Begin
                // MH 27/06/08: Added check to minimise updates on InvF
                NeedTransUpdate := (TotOrdOS <> Rnum);
                If NeedTransUpdate Then
                  LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyCS,Keypath,Fnum,BOn,Locked);

                If (Not NeedTransUpdate) Or (LOk and Locked) then
                Begin
MDCACIncluded := MDCACIncluded + 1;
                  FoundOk:=BOn;

                  // Get the Transaction record address and store it in the list.
                  InvKey := Form_Int(Check_MDCCC(CtrlNom), 10) +
                            FullCustCode(CustCode)+
                            Get_StaChkDate(LInv) +
                            OurRef;
                  LGetRecAddr(Fnum);
                  AddressList.AddObject(InvKey, TRecordAddress.Create(LastRecAddr[Fnum]));
//                  AddressList.Add(IntToStr(LastRecAddr[Fnum]));

                  // MH 27/06/08: Added check to minimise updates on InvF
                  If NeedTransUpdate Then
                  Begin
                    TotOrdOS:=Rnum;

                    LStatus:=LPut_Rec(Fnum,KeyPath);

                    LReport_BError(Fnum,LStatus);

                    LStatus:=LUnLockMLock(Fnum);
                  End; // If NeedTransUpdate
                End; // If (Not NeedTransUpdate) Or (LOk and Locked)
              end;

              {$IFDEF EXSQL}
              // MH 05/08/2008: Modified to use GetNext as under SQL the extended btrieve will
              // be bypassing the cache and always going to the server
              If (PrevMode) Or SQLUtils.UsingSQLAlternateFuncs then
              {$ELSE}
              If (PrevMode) then
              {$ENDIF}
                LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS)
              else
                LStatus:=GetExtCusALCid(ExtCustRec,ExtCustObj,Fnum,Keypath,B_GetNext,1,KeyCS);
            End; // With LInv
          End; // While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort)
        End; // If TmpInclude
      End; // With CRepParam^
    end; {With..}
  end;



  Procedure TMDCReport.Build_MDCAgeCust(Var FoundOk    :  Boolean);


  Const
    Fnum        =  CustF;
    { CJS 2012-08-22 - ABSEXCH-11027 - 22 - Aged Creditors/Debtors hangs }
    Keypath     =  ATCodeK;


  Var
    ItemCount,
    ItemTotal   :  LongInt;


    KeyCS,
    KeyChk      :  Str255;


  Begin
    New(ExtCustRec);

    New(ExtCustObj,Init);

    Blank(ExtCustRec^,Sizeof(ExtCustRec^));

    ExtCustObj.MTExLocal:=MTExLocal;

    ItemCount:=0;

    FoundOk:=BOff;

    With MTExLocal^ do
    Begin
      ItemTotal:=Used_RecsCId(LocalF^[Fnum],Fnum,ExCLientId);

      InitProgress(ItemTotal);

      ShowStatus(0,RepTitle);
      ShowStatus(1,'Calculating Totals...');

      With ExtCustRec^ do
      Begin

        FNomAuto:=BOn;

        FMode:=3;

        FAlCode:=CRepParam^.Filt;
        FCSCode:=FALCode;

        FDirec:=BOn;

        FB_Func[BOff]:=B_GetPrev;
        FB_Func[BOn]:=B_GetNext;

      end;

      With CRepParam^ do
        { CJS 2012-08-22 - ABSEXCH-11027 - 22 - Aged Creditors/Debtors hangs }
        If (EmptyKey(ACFilt,CustKeyLen)) then
          KeyChk := Filt
        else
          KeyChk := Filt + ACFilt;

      KeyCS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
      Begin
        With ExtCustRec^ do
        Begin
          FCusCode:=LCust.CustCode;

        end;

        With LCust do
          ShowStatus(2,'Checking : '+dbFormatName(CustCode,Company));

        Build_MDCAgedDoc(FoundOk);

        Inc(ItemCount);

        UpdateProgress(ItemCount);

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

      end;

      AddressList.Sort;
      UpdateProgress(ItemTotal);

      InitProgress(0);

      Dispose(ExtCustRec);
      Dispose(ExtCustObj,Done);

    end; {With..}

  end;


  Procedure TMDCReport.Process;

  Var
    FoundOk  :  Boolean;

  Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}

    InitStatusMemo(4);

    RepTitle:='Multiple '+RepTitle;
    PageTitle:='Multiple '+PageTitle;

    RFnum:=ReportF;
    RKeyPath:=RpK;

    FoundOk:=BOff;
    CRepParam.LastCtrlNom:=-1;

    Build_MDCAgeCust(FoundOk);

    {ThreadRec^.THAbort:=Not FoundOk;
    ThreadRec^.THAbortPrint:=BOn;

    If (FoundOk) then}
      Inherited Process;

  end;

  procedure TMDCReport.RepBeforePrint(Sender: TObject);
  begin

    If (RUseForms) then
    Begin
      {$IFDEF FRM}
        pfInitNewBatch(BOff,BOn);
      {$ENDIF}
    end
    else
      Begin
        RepFiler1.Title:=Application.Title+'. '+RepTitle;

        {* Set extension to EFP for faxing via MAPI or if emailing in Enterprise format *}
        If ((RDevRec.fePrintMethod=1) and (RDevRec.feFaxMethod = 1)) Or
           ((RDevRec.fePrintMethod=2) and (RDevRec.feEmailAtType = 0)) then
          RepFiler1.FileName:=GetTempFNameExt('!REP','.EDF')
        else
          RepFiler1.FileName:=GetWindowsTempFileName('!RP');
      end;

  end;


  procedure TMDCReport.RepPrint(Sender: TObject);
  var
    TmpStat      :  Integer;
    TmpRecAddr   :  LongInt;
    {$IFDEF REPPFC}
      Res : LongInt;
    {$ENDIF}
  begin
    ShowStatus(2, 'Processing Report.');

    with MTExLocal^, RepFiler1 do
    begin
      If (Assigned(ThreadRec)) then
        RepAbort:=ThreadRec^.THAbort;

      AddressListIndex := 0;
      while (AddressListIndex < AddressList.Count) do
      begin
        If (IncludeRecord) then
        Begin
          ThrowNewPage(5);
          PrintReportLine;
          Inc(ICount);
        end;

        Inc(RCount);

        If (Assigned(ThreadRec)) then
          UpDateProgress(RCount);

        If (Assigned(ThreadRec)) then
          RepAbort:=ThreadRec^.THAbort;

        AddressListIndex := AddressListIndex + 1;
      end; {While..}

      ThrowNewPage(5);
      PrintEndPage;

    end; {With..}

  end;




  Procedure TMDCReport.PrintReportLine;


  Const
    Fnum    =  InvF;
    KeyPath =  InvFolioK;

  Var
    CrDr       :  DrCrType;
    LineAged   :  AgedTyp;

    Rnum,
    Sales,Purch,
    Cleared    :  Double;

    n          :  Byte;
    PostChar   :  String[1];
    OrdPayFlag : String[1];

    AgedDate   :  LongDate;

    LGenStr,
    GenStr     :  Str255;


  Begin

    Rnum:=0; PostChar:='';

    Purch:=0; Sales:=0; Cleared:=0;

    GenStr:=''; LGenStr:='';

    With MTExLocal^,RepFiler1 do
      With CRepParam^ do
      Begin

        Case ReportMode of
          0..2
               :  With LInv Do
                  Begin
                    If (CustCode<>LastCust) or (LastCtrlNom<>Check_MDCCC(CtrlNom)) then
                    Begin
                      If (LastCust<>'') then
                        PrintDueTot(0);

                      If (Check_MDCCC(CtrlNom)<>LastCtrlNom) then
                      Begin
                        If (LastCtrlNom<>-1) then
                          PrintDueTot(3);

                        LastCtrlNom:=Check_MDCCC(CtrlNom);

                        If (LastCtrlNom=0) then
                          If (Filt=TradeCode[BOn]) then
                            LastCtrlNom:=Syss.NomCtrlCodes[Debtors]
                          else
                            LastCtrlNom:=Syss.NomCtrlCodes[Creditors];

                        PrintMDNomLine(FullNomKey(LastCtrlNom),BOff);

                        TmpLastNC:=LastCtrlNom;
                        LastCtrlNom:=Check_MDCCC(CtrlNom);
                      end;


                      Case ReportMode of

                        0,1  :  PrintCustLine(CustCode,BOff);


                      end; {Case..}

                      LastCust:=CustCode;

                      TmpLastC:=CustCode;

                      PostedBal:=Currency_Txlate(LProfit_to_Date(CustHistPCde,CustCode+FullNomKey(Check_MDCCC(CtrlNom)),RCr,RYr,RPr,Purch,Sales,Cleared,BOn),RCr,RTxCr);

                        // CA 09/04/2013 v7.0.3 ABSEXCH-12361 : Ctrl Total not adding correctly. The following if statement  was preventing
                        //                                      the Ctrl Total from being displayed and then totalled up.
//                      If (KeepCust<>CustCode) then
//                      Begin
                        ThisPostedBal:=ThisPostedBal+PostedBal;
                        GrandPostedBal:=GrandPostedBal+PostedBal;
                        KeepCust:=CustCode;
//                      end;


                    end;


                    Rnum:=TotOrdOS;
                    ThisInvBal:=Rnum;

                    {If (RCr=0) then
                      Rnum:=BaseTotalOS(Inv)
                    else
                      Rnum:=CurrencyOS(Inv,On,Off,Off);}

                    Rnum:=Currency_Txlate(ThisInvBal,RCr,RTxCr);

                    PostChar:=IfThen(RunNo=0,'*','');

                    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Include Prompt Payment Discount Goods and VAT Values
                    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                    GenStr:=DiscStatus[0 + (1*Ord((DiscSetAm<>0) Or ((thPPDGoodsValue + thPPDVATValue) <> 0.0))) + (1*Ord(DiscTaken Or (thPPDTaken <> ptPPDNotTaken)))];

                    GenStr:=GenStr+DisplayHold(HoldFlg);

                  end;

        end; {Case..}


        DefFont (0,[]);

        Case ReportMode of
          0  :  With LInv do
                Begin
                  ShowDrCr(Rnum,CrDr);

                  SendLine(ConCat(#9,PostChar,#9,OurRef,
                          #9,YourRef,
                          #9,POutDate(DueDate),#9,
                          #9,FormatBFloat(GenRealMask,CrDr[BOff],BOn),
                          #9,FormatBFloat(GenRealMask,CrDr[BOn],BOn),
                          #9,GenStr));

                end;
          1  :  If (Not Summary) then
                With LInv do
                Begin
                  Blank(LineAged,SizeOf(LineAged));


                    AgedDate:=Get_StaChkDate(LInv);

                    MasterAged(LineAged,AgedDate,DueLimit,Rnum,RAgeBy,RAgeInt);

                  // MH 06/10/2014 Order Payments: Added Order Payments indicator
                  OrdPayFlag := IfThen((Filt='C') And (thOrderPaymentElement <> opeNA), '!', '');

                  LGenStr:=ConCat(#9,OurRef,PostChar,OrdPayFlag, #9,YourRef,
                                  #9,POutDate(AgedDate),
                                  #9,FormatFloat(GenRealMask,Lineaged[7]));


                  For n:=0 to 6 do
                    LGenStr:=LGenStr+ConCat(#9,FormatBFloat(GenRealMask,Lineaged[n],BOn));

                  SendLine(Concat(LGenStr,#9,GenStr));
                end;


        end; {Case..}


        CalcDueTotals(CrDr,0.0,0.0);

      end; {With(s)..}
  end;




  function TMDCReport.IncludeRecord: Boolean;
  var
    Rnum: Real;
    RecordAddress: LongInt;
    IsAged: Boolean;
    InvoiceYrPr: LongInt;
    ReportYrPr: LongInt;
  begin
    Result := False;
    with MTExLocal^ do
    begin
      // Retrieve the stored Transaction record address
      RecordAddress := TRecordAddress(AddressList.Objects[AddressListIndex]).Address;
      if (RecordAddress <> -1) then
      begin
        // Locate the Transaction record
        LSetDataRecOfs(LRepScr^.FileNo, RecordAddress);
        LStatus := LGetDirect(LRepScr^.FileNo, LRepScr^.KeyPath, 0);
        if (LStatusOk) then
        begin
          // Calculate the aging values
          if (CRepParam^.RCr = 0) then
            Rnum := ConvCurrITotal(LInv, BOff, BOn, BOn)
          else
            Rnum := Itotal(LInv);

          InvoiceYrPr := Pr2Fig(LInv.ACYr, LInv.AcPr);
          ReportYrPr  := Pr2Fig(CRepParam^.RYr, CRepParam^.RPr);
          IsAged := (InvoiceYrPr <= ReportYrPr) and (LInv.RunNo > 0) and
                    (not (LInv.InvDocHed In DirectSet)) and (ReportMode <> 0);

          if IsAged then
            MasterAged(CRepParam^.PostAged, LInv.DueDate, CRepParam^.DueLimit,
                       Rnum, CRepParam^.RAgeBy, CRepParam^.RAgeInt);

          if (not EuroConv_Detected) then
            EuroConv_Detected := (LInv.OldORates[UseCoDayRate] <> 0.0);

          Result := True;
        end;
      end;
    end;
  end;

  Procedure TMDCReport.PrintEndPage;

  Begin
    With RepFiler1,CRepParam^ do
    Begin
      PrintDueTot(0);

      PrintDueTot(3);

      If (ReportMode<>2) then
      Begin
        DefFont(-2,[fsItalic,fsBold]);

        // MH 03/06/2015 2015-R1 ABSEXCH-16376: Remove Order Payments note from non-SPOP systems
        {$IFDEF SOP}
        If (ReportMode = 1) And (CRepParam^.Filt = 'C') Then
          // MH 06/10/2014 Order Payments: Extended explanitory text for Aged Debtors Split by Control Account
          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.PrintLeft('* denotes unposted transactions, ! denotes Order Payment transactions',MarginLeft)
        Else
        {$ENDIF SOP}
          // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
          Self.PrintLeft('* denotes unposted transactions',MarginLeft);

      end;

      DefLine(-1,1,PageWidth-MarginRight-1,0);

    
      PrintDueTot(4);


      {If (ReportMode<>2) then
        PrintDueTot(2);}

      Inherited PrintEndPage;

    end; {With..}
  end;



  { ======== }

  //PR: 22/10/2009 Added Parameter Printing for Aged Creditor/Debtor Reports
  procedure AddParametersToAgingReport(var EntTest : TGenReport; IRepParam:  DueRepPtr);
  const
    AgingStrings : Array[1..3] of string[6] = ('Days','Weeks','Months');
  begin
    if Assigned(EntTest.oPrintParams) then
    begin

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Summary Report';
        Value := IRepParam.Summary;
      end;

      {$IFDEF MC_ON}
      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RCr), True);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(IRepParam.RTxCr), True);
      end;
      {$ENDIF}

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Account';
        Value := IRepParam.AcFilt;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Control GL Code';
        if IRepParam.CtrlNomFilt = 0 then
          Value := ''
        else
          Value := IRepParam.CtrlNomFilt;
      end;

      if Syss.UseCCDep then
      begin
        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Cost Centre';
          Value := IRepParam.RCCDep[True];
        end;

        with EntTest.oPrintParams.AddParam do
        begin
          Name :=  'Department';
          Value := IRepParam.RCCDep[False];
        end;
      end;


      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Age Report by';
        Value := AgingStrings[IRepParam.RAgeBy];
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Aging Interval';
        Value := IRepParam.RAgeInt;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'O/S Transactions Only';
        Value := IRepParam.OSOnly;
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name :=  'Posted Balance as at';
        Value := PPR_OutPr(IRepParam.RPr, IRepParam.RYr);
      end;

      with EntTest.oPrintParams.AddParam do
      begin
        Name := 'Backdate to Per/Yr';
        Value := IRepParam.PrevMode;
      end;

      EntTest.bPrintParams := True;
    end;

  end;



  Procedure AddADebRep2Thread(LMode    :  Byte;
                              IsCust   :  Boolean;
                              IRepParam:  DueRepPtr;
                              AOwner   :  TObject);


  Var
    EntTest  :  ^TADebReport;

  Begin

    If (Create_BackThread) then
    Begin


      New(EntTest,Create(AOwner));

      try
        With EntTest^ do
        Begin
          ReportMode:=LMode;
          IsPay:=IsCust;

          If (Assigned(IRepParam)) then
            CRepParam^:=IRepParam^;

          If (Create_BackThread) and (Start) then
          Begin
            if IRepParam.PrintParameters then
              AddParametersToAgingReport(EntTest^, CRepParam);

            With BackThread do
              AddTask(EntTest,ThTitle);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(EntTest,Destroy);
          end;
        end; {with..}

      except
        Dispose(EntTest,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  Procedure AddAMDCRep2Thread(LMode    :  Byte;
                              IsCust   :  Boolean;
                              IRepParam:  DueRepPtr;
                              AOwner   :  TObject);


  Var
    EntTest  :  ^TMDCReport;

  Begin

    If (Create_BackThread) then
    Begin


      New(EntTest,Create(AOwner));

      try
        With EntTest^ do
        Begin
          ReportMode:=LMode;
          IsPay:=IsCust;

          If (Assigned(IRepParam)) then
            CRepParam^:=IRepParam^;

          If (Create_BackThread) and (Start) then
          Begin
            if IRepParam.PrintParameters then
              AddParametersToAgingReport(EntTest^, CRepParam);

            With BackThread do
              AddTask(EntTest,ThTitle);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(EntTest,Destroy);
          end;
        end; {with..}

      except
        Dispose(EntTest,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;


  { ========== TStaReport methods =========== }

  Constructor TStaReport.Create(AOwner  :  TObject);

  Begin
    Inherited Create(AOwner);

    New(CRepParam);

    FillChar(CRepParam^,Sizeof(CRepParam^),0);

    New(CustAlObj,Init);

    RUseForms:=BOn;

    TotTabs:=0;

  end;


  Destructor TStaReport.Destroy;

  Begin
    Dispose(CRepParam);

    Dispose(CustAlObj,Done);

    Inherited Destroy;
  end;




  Procedure TStaReport.Process;

  Var
    ThisScrt   :  Scratch2Ptr;

  Begin
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL then
      ReOpen_LocalThreadfiles;
  {$ENDIF}
    If (Assigned(CustAlObj)) then {* Pass client BT object into allocation search object *}
      CustAlObj.MTExLocal:=MTExLocal;

    {$IFDEF FRM}

      If (ReportMode In [2,3]) then
      Begin
        try
          eCommFrmList:=TeCommFrmList.Create;


        except
          eCommFrmList.Destroy;
          eCommFrmList:=nil;
        end; {try..}

      end;
    {$ENDIF}

    With CRepParam^ do
    Begin
      If (ShowOS) and (Not (ReportMode In [5,8,10,11..14])) then
      Begin

        New(ThisScrt,Init(7,MTExLocal,BOff));

        ScrPtr^.RepPtr:=ThisScrt;

        ScrPtr^.SFName:=FileNames[ReportF];

        RDelSwapFile:=(ReportMode=2);

        If (RDelSwapFile) then
          TmpSwapFileName:=SetDrive+FileNames[ReportF];
      end;
    end; {With..}


    Inherited Process;
  end;



  Procedure TStaReport.RepSetTabs;

  Begin

  end;


  Procedure TStaReport.RepPrintPageHeader;


  Begin

  end; {Proc..}


  Procedure TStaReport.RepPrintHeader(Sender  :  TObject);


  Begin

  end;


  { ========== Procedure to Add Matching Documents ========= }

  Procedure TStaReport.Add_Match2Sta(StaCtrl  :  StaCtrlRec;
                                     InvR     :  InvRec;
                                     Fnum,
                                     Keypath,
                                     Fnum2,
                                     Keypath2,
                                     KeyPathI :  Integer);



  Var
    KeyChk,
    KeyS2,
    KeyI     :  Str255;

    TmpStat  :  Integer;
    TmpRecAddr,
    RecAddr  :  LongInt;

    ThisScrt :  Scratch2Ptr;

    IsOs     :  Boolean;




  Begin
    With MTExLocal^ do
    Begin

      IsOs:=BOff;

      ThisScrt:=StaCtrl^.RepPtr;

      TmpStat:=LPresrv_BTPos(Fnum2,KeyPathI,LocalF^[Fnum2],TmpRecAddr,BOff,BOff);

      KeyChk:=FullMatchKey(MatchTCode,MatchSCode,InvR.OurRef);
      KeyS2:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (ChkRepAbort) do
      With LPassWord.MatchPayRec do
      Begin

        KeyI:=DocCode;

        LStatus:=LFind_Rec(B_GetEq,Fnum2,InvOurRefK,KeyI);

        {$IFDEF MC_On}

          IsOS:=(CurrencyOS(LInv,BOn,BOff,BOff)<>0);

        {$ELSE}

          IsOS:=(BaseTotalOS(LInv)<>0);

        {$ENDIF}

        With StaCtrl^ do
        With LInv do
        If (LStatusOk) and (ThisScrt<>NIL) and (Not IsOS) then
        Begin


          LStatus:=LGetPos(Fnum2,RecAddr);  {* Get Preserve IdPosn *}

          With ThisScrt^ do
          Begin
            If (Not In_Scratch(LInv.OurRef,0,BOff)) then {* Check if already included *}
              Add_Scratch(Fnum2,Keypath2,RecAddr,FullCustCode(LInv.CustCode)+
                                '1'+InvR.OurRef+Get_StaChkDate(LInv),LInv.OurRef);

          end;


        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

      end; {While..}

      TmpStat:=LPresrv_BTPos(Fnum2,KeyPathI,LocalF^[Fnum2],TmpRecAddr,BOn,BOn);

    end; {with..}
  end; {Proc..}



  { ======== Proc to Scan invoices out of a ledger, and choose all O/S / matched ones ===== }

  Procedure TStaReport.Build_Statement(StaCtrl  :  StaCtrlRec;
                                       Fnum,
                                       Keypath  :  Integer);

  Const
    ScrKey   :   Array[BOff..BOn] of Char = ('9','1');



  Var
    KeyChk,
    KeyS2,
    ScrStr   :   Str255;

    IsOS,
    TmpBo,
    IsDue,
    IsInMnth,
    Use4Match:   Boolean;

    RecAddr  :   LongInt;

    ThisScrt :  Scratch2Ptr;




  Begin
    With MTExLocal^ do
    Begin
      
      ThisScrt:=StaCtrl^.RepPtr;

      Use4Match:=BOff;

      With LCust do
        KeyChk:=FullCustType(CustCode,CustSupp);

      KeyS2:=KeyChk;

      StaCtrl^.FoundSta:=BOff;


      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS2,Length(KeyChk),BOn)) and (ChkRepAbort) do
      With LInv do
      With StaCtrl^ do
      Begin

        {$IFDEF MC_On}

          IsOS:=IncDocInStat(CurrencyOS(LInv,BOn,BOff,BOff));

        {$ELSE}

          IsOS:=IncDocInStat(BaseTotalOS(LInv));

        {$ENDIF}

        
        IsDue:=(((Get_StaChkDate(LInv)<=StaAgedDate) or (Syss.IncNotDue)) and (Not (InvDocHed In QuotesSet+PSOPSet)))
                  and ((Currency=CRepParam^.RCr) or (CRepParam^.RCr=0));

        IsInMnth:=(MonthDiff(LInv.TransDate,StaAgedDate)=0);

        If ((IsOS) or (IsInMnth)) and (IsDue) then
        Begin
          LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

          Use4Match:=((EmptyKey(RemitNo,DocKeyLen)) and (Not OrdMatch) and ((InvDocHed In MatchSet)
                     or (ITotal(LInv)<0)) and (IsInMnth));

          {$IFDEF MC_On}

            CrFlags[Currency]:=BOn;

          {$ENDIF}

          FoundSta:=BOn;

          If (Use4Match) then
            ScrStr:=FullCustCode(CustCode)+ScrKey[BOn]+OurRef+Get_StaChkDate(LInv)
          else
            ScrStr:=FullCustCode(CustCode)+ScrKey[BOff]+Get_StaChkDate(LInv);

          If (ThisScrt<>NIL) and (ShowMonthDoc) then
          Begin
            If (Not ThisScrt^.In_Scratch(LInv.OurRef,0,BOff)) then {* Check if already included *}
              ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,ScrStr,OurRef);

            If (Use4Match) then
              Add_Match2Sta(StaCtrl,LInv,PWrdF,HelpNdxK,InvF,InvFolioK,Keypath);
          end;

        end;

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

      end; {While..}
    end; {With..}

  end; {Proc..}



  Procedure TStaReport.PrintReportLine;

  Var
    TmpMode,
    ThisDebtL,
    CrCount    :  Byte;

    ContDebt,
    Ok2Print,
    Built      :  Boolean;

    SLLoop     :  LongInt;

    TmpRForm   :  Str20;

    PapCust    :  CustRec;

    // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
    iContactRole : Integer;



{$IFDEF SOP}
  { == Function to Scan a transaction line and produce a label for all serial numbers == }

  Function LblFind_SerNos  :  Boolean;

  Const
    SFnum      = MiscF;
    SKeypath   = MIK;


  Var
    SalesDoc,
    FoundOk,
    FoundAll    :  Boolean;

    Loop        :  Integer;

    SerCount,
    SerGot       :  Double;

    SKeyS,SKeyChk:  Str255;

    BSNoRec      :  ^BatchRepSNoInfoType;


  Begin
    With MTExLocal^,RepFiler1 do
    With CRepParam^, LId do
    Begin
      Result:=BOff;   FoundAll:=BOff;  Loop:=0;

      If (Is_SerNo(LStock.StkValType)) and (SerialQty<>0.0) then
      Begin
        SerCount:=0.0;

        SerGot:=SerialQty;

        SalesDoc:=(IdDocHed In SalesSplit) or ((IdDocHed In WOPSplit) and (LineNo<>1));

        If (IdDocHed In WOPSPlit) and (SerGot<0) and (LineNo<>1) then
          SerGot:=SerGot*DocNotCnst;

        If (SalesDoc) then
          SKeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(LStock.StockFolio)+#1)
        else
          SKeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(LStock.StockFolio));


        SKeyS:=SKeyChk+NdxWeight;


        LStatus:=LFind_Rec(B_GetLessEq,SFnum,SKeyPath,SKeyS);

        While (LStatusOk) and (CheckKey(SKeyChk,SKeyS,Length(SKeyChk),BOn)) and (Not FoundAll) and (ChkRepAbort) do
        With LMiscRecs^.SerialRec do
        Begin
          If (SalesDoc) then
            FoundOk:=(((CheckKey(DocPRef,OutDoc,Length(DocPRef),BOff)) and (SoldLine=ABSLineNo)) or
                      ((CheckKey(DocPRef,OutOrdDoc,Length(DocPRef),BOff)) and (OutOrdLine=ABSLineNo)))
          else
            FoundOk:=(((CheckKey(DocPRef,InDoc,Length(DocPRef),BOff)) and (BuyLine=ABSLineNo))  or
                      ((CheckKey(DocPRef,InOrdDoc,Length(DocPRef),BOff)) and (InOrdLine=ABSLineNo)));

          If (FoundOk) then
          Begin
            Result:=BOn;

            LGetRecAddr(SFnum);

            
            For Loop:=1 to StkLabCopies do
            If (Ok2Print) then
            Begin
              New(BSnoRec);

              FillChar(BSNoRec^,Sizeof(BSNoRec^),#0);

              With BSNoRec^ do
              Begin
                RecSize:=Sizeof(BSNoRec^);

                SNoRecAddr:=LastRecAddr[SFnum];

                SNoKey:=SKeyS;
              end;

              ScrPtr^.RepPtr:=BSNoRec;

              Ok2Print:=pfAddBatchForm(RDevRec,28,RForm,
                                       RFnum,RKeyPath,FullIdKey(LId.FolioRef,LId.AbsLineNo),
                                       PWrdF,0,NdxWeight,
                                       '',
                                       ScrPtr,
                                       BOff);
            end;

            If (Not BatchChild) or (SalesDoc) then
            Begin
              If (BatchRec) then
              Begin
                If (SalesDoc) then
                  SerCount:=SerCount+QtyUsed
                else
                  SerCount:=SerCount+BuyQty;
              end
              else
                SerCount:=SerCount+1.0;
            end;

          end;

          FoundAll:=(SerCount>=SerGot);

          If (Not FoundAll) then
            LStatus:=LFind_Rec(B_GetPrev,SFnum,SKeyPath,SKeyS);

        end; {While..}
      end;

    end;
  end;
{$ENDIF}

  //------------------------------

  // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
  Function DebtChaseLetterToRoleId (Const DebtLetterFormNo : Integer) : Integer;
  Begin // DebtChaseLetterToRoleId
    Case DebtLetterFormNo Of
      // Debt Chase Letter 1
      38 : Result := riDebtChaseLetter1;
      // Debt Chase Letter 2
      39 : Result := riDebtChaseLetter2;
      // Debt Chase Letter 3
      40 : Result := riDebtChaseLetter3;
    Else
      Result := 0;
    End; // Case DebtLetterFormNo
  End; // DebtChaseLetterToRoleId

  //------------------------------

  Begin
    Built:=BOff;
    Ok2Print:=BOn;

    // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
    iContactRole := 0;

    ThisDebtL:=NofChaseLtrs;

    With MTExLocal^,RepFiler1 do
      With CRepParam^ do
      Begin
        TmpRForm:=RForm;

        PapCust:=LCust;

        ContDebt:=((ReportMode=3) and (Not (Syss.DebtLMode In [0,1])));


        If (Not (ReportMode In [11..14])) then
        Begin
          With LCust do
            ShowStatus(2,'Account : '+dbFormatName(CustCode,Company));
        end
        else
          Begin
          With LStock do
            ShowStatus(2,dbFormatName(StockCode,Desc[1]));
          end;

        Case ReportMode of
           2,3  :
               Begin
                  If (ReportMode=2) then
                  Begin
                    TmpMode:=22;

                    {$IFDEF FRM}

                      If (LCust.FDefPageNo<>0) or (RForm='') then
                      begin
                        {$IFDEF EXSQL}
                        if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                          RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[4]
                        else
                        {$ENDIF}
                          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[4];
                      end;

                      RDevRec.feEmailsubj:='Statement of Account from '+Syss.UserName;

                      // MH 03/01/2014 v7.XMRD: Added support for Statement Contact Roles
                      iContactRole := riSendStatement;
                    {$ENDIF}
                  end
                  else
                  Begin
                    TmpMode:=Succ(ReportMode);

                    {$IFDEF Frm}
                      If (Not ContDebt) then
                      Begin
                        If (DebtLevel=0) then
                        Begin
                          ScrPtr^.DebtLetter:=TrigEquiv(LCust.CreditStatus);

                          {$IFDEF EXSQL}
                          if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                            RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+ScrPtr^.DebtLetter]
                          else
                          {$ENDIF}
                            RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+ScrPtr^.DebtLetter];

                          // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
                          iContactRole := DebtChaseLetterToRoleId(37+ScrPtr^.DebtLetter);
                        end
                        else
                        Begin
                          If (LCust.FDefPageNo<>0) or (RForm='') then
                          Begin
                            {$IFDEF EXSQL}
                            if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                              RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+DebtLevel]
                            else
                            {$ENDIF}
                              RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+DebtLevel];

                          end;

                          // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
                          //PR: 13/10/2014 ABSEXCH-15697 Moved this line out of 'If (LCust.FDefPageNo<>0) or (RForm='') then' condition
                          //                             as iContactRole wasn't getting set if default form was already set. 
                          iContactRole := DebtChaseLetterToRoleId(37+DebtLevel);

                          ScrPtr^.DebtLetter:=DebtLevel;
                        end;
                      end;


                      RDevRec.feEmailsubj:='Overdue Debt Letter from'+Syss.UserName;

                    {$ENDIF}
                  end;

                  With ScrPtr^ do
                  Begin
                    {$IFDEF MC_On}

                      ThisCr:=1;

                    {$ELSE}

                      ThisCr:=0;

                      SepCr:=BOff;

                    {$ENDIF}


                    FoundSta:=BOn;

                    Blank(CrFlags,Sizeof(CrFlags));

                    Built:=((Not ShowMonthDoc) and  (Not SepCr));

                    Repeat

                      If (Not Built) then
                        Build_Statement(ScrPtr,InvF,InvCustK);


                      Built:=BOn;


                      If (FoundSta) and ((CrFlags[ThisCr]) or (Not SepCr)) then
                      Begin

                        {$IFDEF FRM}

                          RDevRec.feFaxMsg:=RDevRec.feEmailsubj;
                          RDevRec.feEmailMsg:=RDevRec.feEmailsubj;

                          PapCust:=Link_CustHO(LCust.RemitCode);

                          If (ShowMonthDoc) and (ReportMode=2) then
                          Begin
                              {* Set Fax/Email address *}
                            // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
                            If (iContactRole > 0) Then
                            Begin
                              SetEcommsFromCust_WithRole(PapCust, RDevRec, MTExLocal, BOn, iContactRole);
                            End // If (iContactRole > 0)
                            Else
                              SetEcommsFromCust(PapCust,RDevRec,MTExLocal,BOn);

                            Ok2Print:=Send_FrmPrint(RDevRec,TmpMode,RForm,
                                         CustF,CustCodeK,FullCustCode(LCust.CustCode),
                                         ReportF,RpK,FullNomKey(7)+FullCustCode(LCust.CustCode),
                                         '',
                                         ScrPtr,
                                         BOff,
                                         PapCust.StatDMode);

                          end
                          else
                          Begin
                            Repeat

                              If (ContDebt) then
                              Begin
                                DebtLetter:=ThisDebtL;
                                Ok2Print:=CustAlObj^.DebtLetters[ThisDebtL];

                                If (Ok2Print) then
                                Begin
                                 {$IFDEF EXSQL}
                                  if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                                    RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+ThisDebtL]
                                  else
                                  {$ENDIF}
                                    RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[37+ThisDebtL];

                                  // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
                                  iContactRole := DebtChaseLetterToRoleId(37+ThisDebtL);
                                end;
                              end
                              else
                                Ok2Print:=BOn;


                              If (Ok2Print) then
                              Begin
                                // MH 03/01/2014 v7.XMRD: Added support for Debt Chase Letter Contact Roles
                                If (iContactRole > 0) Then
                                Begin
                                  // MH 07/07/2014 v7.0.11 ABSEXCH-14049: Modified to use the Customer record which complies with Head Office redirection
                                  SetEcommsFromCust_WithRole(PapCust {LCust}, RDevRec, MTExLocal, BOn, iContactRole);
                                End // If (iContactRole > 0)
                                Else
                                  // MH 07/07/2014 v7.0.11 ABSEXCH-14049: Modified to use the Customer record which complies with Head Office redirection
                                  SetEcommsFromCust(PapCust {LCust},RDevRec,MTExLocal,BOn);

                                // MH 07/07/2014 v7.0.11 ABSEXCH-14049: Modified to use the Customer record which complies with Head Office redirection
                                Ok2Print:=Send_FrmPrint(RDevRec,TmpMode,RForm,
                                                        CustF,CustCodeK,FullCustCode(LCust.CustCode),
                                                        InvF,InvCustK,FullCustType(LCust.CustCode,LCust.CustSupp),
                                                        '',
                                                        ScrPtr,
                                                        BOff,
                                                        {LCust}PapCust.StatDMode);
                              end;


                              Dec(ThisDebtL);

                            Until (Not ContDebt) or (ThisDebtL<1) or (ThreadRec^.THAbort);
                          end;
                        {$ENDIF}

                      end;


                      Inc(ThisCr);

                    Until (ThisCr>CurrencyType) or (Not SepCr) or (ThreadRec^.THAbort);
                  end;
              end;


           5  :
              Begin
                {$IFDEF FRM}

                  If (LCust.FDefPageNo<>0) or (RForm='') then
                  begin
                   {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                      RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[2]
                    else
                    {$ENDIF}
                      RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[2]
                  end;

                  Ok2Print:=pfAddBatchForm(RDevRec,ReportMode,RForm,
                                         CustF,CustCodeK,FullCustCode(LCust.CustCode),
                                         InvF,InvCustK,FullCustType(LCust.CustCode,LCust.CustSupp),
                                         '',
                                         ScrPtr,
                                         BOff);
                {$ENDIF}


              end;
           8  :
              Begin
                {$IFDEF FRM}

                  If (LCust.FDefPageNo<>0) or (RForm='') then
                  begin
                   {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                      RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[1]
                    else
                    {$ENDIF}
                      RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[1];

                  end;

                  Ok2Print:=pfAddBatchForm(RDevRec,ReportMode,RForm,
                                         CustF,CustCodeK,FullCustCode(LCust.CustCode),
                                         PWrdF,PWK,NoteTCode+NoteCCode+LCust.CustCode,
                                         '',
                                         ScrPtr,
                                         BOff);
                {$ENDIF}

              end;

           10  :
              Begin
                {$IFDEF FRM}

                  If (LCust.FDefPageNo<>0) or (RForm='') then
                  begin
                   {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                      RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[3]
                    else
                   {$ENDIF}
                      RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[3];
                  end;

                  Ok2Print:=pfAddBatchForm(RDevRec,26,RForm,
                                         CustF,CustCodeK,FullCustCode(LCust.CustCode),
                                         PWrdF,0,NdxWeight,
                                         '',
                                         ScrPtr,
                                         BOff);
                {$ENDIF}

              end;

        {$IFDEF STK}
           11  :
              Begin
                {$IFDEF FRM}

                  Ok2Print:=pfAddBatchForm(RDevRec,26,RForm,
                                         StockF,StkCodeK,FullStockCode(LStock.StockCode),
                                         PWrdF,0,NdxWeight,
                                         '',
                                         ScrPtr,
                                         BOff);
                {$ENDIF}

              end;
           12..14
             :
              Begin
                {$IFDEF FRM}

                  If (LCust.CustCode<>LId.CustCode) then {* Get Cust record for form def switch over *}
                    LGetMainRec(CustF,LId.CustCode);

                  // MH 07/02/2012 v6.10 ABSEXCH-10984: Removed this section as it is now done in GetReportInput
                  // BEFORE the Print To dialog - this section was then overwriting what the customer had specified
                  // in that dialog with the default.
                  //
                  // NOTE: Left the LGetMainRec in place above as I have no idea whether any code elsewhere relies on it :-(
                  //
                  (****
                  If (LCust.FDefPageNo<>0) or (RForm='') then
                  begin
                   {$IFDEF EXSQL}
                    if SQLUtils.UsingSQL  and Assigned(MTExLocal) then
                      RForm:=LGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[21]
                    else
                   {$ENDIF}
                      RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[21];


                  end;
                  ****)

                  {$IFDEF SOP}
                    {$B-}
                      If (ReportMode<>14) or (Not LblFind_SerNos) then
                    {$B+}
                  {$ENDIF}
                    For SLLoop:=1 to StkLabCopies do
                      If (Ok2Print) then
                        Ok2Print:=pfAddBatchForm(RDevRec,26,RForm,
                                                 RFnum,RKeyPath,FullIdKey(LId.FolioRef,LId.AbsLineNo),
                                                 PWrdF,0,NdxWeight,
                                                 '',
                                                 ScrPtr,
                                                 BOff);
                {$ENDIF}

              end;
        {$ENDIF}


        end; {Case..}


        RForm:=TmpRForm;
      end; {With(s)..}
  end;




  {*  Process Customer Auto Add Dated Notes *}

  Procedure TStaReport.Process_AutoCustNotes(Fnum,KeyPath  :  Integer;
                                             CCode         :  Str10;
                                             NDate         :  LongDate;
                                             NDesc         :  Str80);


  Var
    LOk,
    Locked  :  Boolean;

  Begin

    KeyF:=FullCustCode(CCode);

    With MTExLocal^ do
    Begin
      //PR: 09/05/2014 ABSEXCH-15165 Need to use CustCodeK (0) instead of passed-in keypath (5) in
      //                             order to find and lock correct account using just the account code
      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyF,CustCodeK,Fnum,BOn,Locked);

      If (LOk) and (Locked) then
      With LCust do
      Begin

        LGetRecAddr(Fnum);

        Add_AutoNotes(NoteCCode,NoteCDCode,CustCode,NDate,NDesc,NLineCount);

        LStatus:=LPut_Rec(Fnum,CustCodeK);

        LUnLockMLock(Fnum);
      end;
    end;
  end; {Proc..}


  { ============== Procedure to Auto Add Notes ============= }


  Procedure TStaReport.Add_AutoNotes(NoteType,
                                     NoteSType  :  Char;
                                     FolioCode  :  Str10;
                                     NDate      :  LongDate;
                                     NDesc      :  Str80;
                                 Var DLineCount :  LongInt);


  Const
    Fnum      =  PWrdF;

    Keypath   =  PWk;


  Begin
    {$IFDEF C_On}
    With MTExLocal^,LPassword,NotesRec do
    Begin

      LResetRec(Fnum);

      LineNo:=DLineCount;

      NType:=NoteSType;

      RecPfix:=NoteTCode;
      SubType:=NoteType;

      NoteDate:=NDate;

      NoteLine:=NDesc;

      NoteFolio:=FullNCode(FolioCode);

      NoteNo:=FullRNoteKey(NoteFolio,NType,LineNo);

      ShowDate:=(NoteDate<>'');

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      If (LStatusOk) then
        Inc(DLineCount);

    end; {With..}

    {$ENDIF}
  end; {Proc..}



  function TStaReport.Get_LetterDesc  :  Str255;

  Var
    n  :  Byte;


  Begin
    Result:='';

    With MTExLocal^,LCust do
    Begin
      If (Syss.DebtLMode In [0,1]) then
        Result:=Form_Int(TrigEquiv(CreditStatus),0)
      else
      Begin
        For n:=1 to NofChaseLtrs do {* Show all letters being sent out *}
        Begin
          If (CustAlObj^.DebtLetters[n]) then
          Begin
            If (Result<>'') then
              Result:=Result+', ';

            Result:=Result+Form_Int(n,0);
          end;
        end;
      end;
    end; {With..}


  end;


  Function TStaReport.IncDocInStat(DVal  :  Double)  :  Boolean;

  Begin
    Result := False;
    With MTExLocal^,CRepParam^ do
    Begin
      Case SBalIncF of
        0  :  Result:=(DVal<>0.0);
        1  :  Result:=(DVal>0.0);
      end; {Case..}

    end; {With..}
  end;

  {== Replicted from DocSupU1 global version ==}

  Function  TStaReport.LCustBal_OS(CustCode  :  Str10;
                                   CSupp     :  Char;
                                   CustBal   :  Real;
                                   CompDate  :  LongDate)  :  Boolean;


  Const
    Fnum    =  InvF;
    Keypath =  InvCDueK;


  Var
    NewObject,
    FoundOk :  Boolean;

    KeyR,
    KeyChk
            :  Str255;

    DocBal  :  Double;




  Begin
    NewObject:=BOff;

    KeyChk:=CSupp+FullCustCode(CustCode);

    KeyR:=KeyChk+NdxWeight;

    FoundOk:=((Syss.UpBalOnPost) and (CustBal<>0)) or ((CRepParam^.ShowOS) {$IFDEF CU} and (Not LHaveHookEvent(1000,140,NewObject)) {$ENDIF}) ;

    DocBal:=0.0;

    If (Not FoundOk) then
    With MTExLocal^ do
    Begin

      LStatus:=LFind_Rec(B_GetLessEq,Fnum,KeyPath,KeyR);

      While (LStatusOk) and (CheckKey(KeyChk,KeyR,Length(KeyChk),BOff)) and (Not FoundOk) and (Not ThreadRec^.THAbort) do
      Begin
        {$IFDEF Mc_On}

          DocBal:=CurrencyOS(LInv,BOn,BOff,BOff);

          FoundOk:=((IncDocInStat(DocBal)) and (Not(LInv.InvDocHed In QuotesSet))
                   and ((Get_StaChkDate(LInv)<=CompDate) or (Syss.IncNotDue)));

        {$ELSE}

          DocBal:=BaseTotalOS(LInv);

          FoundOk:=((IncDocInStat(DocBal)) and (Not(LInv.InvDocHed In QuotesSet))
                   and ((Get_StaChkDate(LInv)<=CompDate) or (Syss.IncNotDue)));

        {$ENDIF}

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetPrev,Fnum,KeyPath,KeyR);
      end; {While..}
    end; {If Found..}

    LCustBal_OS:=FoundOk;

  end; {Func..}


  {$O-}


  function TStaReport.RightFEAcc(Const SFiltBy,StatDMode  :  Byte)  :  Boolean;


  Begin
    {0 = Include All
     1 = Hard Copy versions
     2 = Fax Only
     3 = Email Only}

    Result:=(SFiltBy=0) or ((SFiltBy=1) and (StatDMode In [0,3,4]))
           or ((SFiltBy=2) and (StatDMode=1))
           or ((SFiltBy=3) and (StatDMode=2));



  end;



  function TStaReport.IncludeRecord  :  Boolean;


  Const
    NoteDesc  :  Array[2..3] of Str20 = ('Statement ','Debt Chase Letter ');

  Var
    n          :  Byte;

    NewObject,
    TmpInclude :  Boolean;
    Purch,Sales,
    Cleared    :  Real;

    NDesc      :  Str80;

  Begin
    TmpInclude:=BOff;

    NDesc:=''; NewObject:=BOff;

    {$B-}

    With MTExLocal^ do
      With CRepParam^ do
      Begin
        Case ReportMode of
          2,3
             :  With LCust do
                Begin

                  {$B-}

                  TmpInclude:=((CustSupp=Filt) and (CustCode>=StaStart) and (CustCode<=StaEnd) and
                               ((IncStat and (NonIncStat=0)) or (Not IncStat and (NonIncStat=1)) or (NonIncStat=2)) and
                               (LCustBal_OS(CustCode,CustSupp,0,ScrPtr^.StaAgedDate)) and

                                 RightFEAcc(SFiltBy,LCust.StatDMode) and


                              (CheckKey(AccTFilt,RepCode,Length(AccTFilt),BOff)));


                  If (ReportMode=3) and (TmpInclude) then
                  Begin

                    Blank(CustAlObj^.DebtLetters,SizeOf(CustAlObj^.DebtLetters));

                    // MH 18/06/2009: Modified for Debt Chase Letters so that it optionally scans all the transactions
                    // to pick up backdated transactions
                    //Update_CreditStatus(CustCode,InvF,InvCustK,CustF,CustCodeK,Syss.DebtLMode,CustAlObj);
                    Update_CreditStatus(CustCode,InvF,InvCustK,CustF,CustCodeK,Syss.DebtLMode,CustAlObj, CRepParam^.StSepCr);

                    Case Syss.DebtLMode of
                      0,1  :  TmpInclude:=(((DebtLevel=0) or (TrigEquiv(CreditStatus)=DebtLevel)) and (CreditStatus>=Syss.WksODue));
                      else Begin
                             TmpInclude:=BOff;

                             For n:=1 to NofChaseLtrs do {* If we have candidates for all three, then stop loop *}
                               If (Not TmpInclude) then
                                 TmpInclude:=CustAlObj^.DebtLetters[n];
                           end;
                    end; {Case..}
                  end;

                  {$IFDEF CU}
                    If (TmpInclude) and (LHaveHookEvent(1000,99+ReportMode,NewObject)) then
                    Begin
                      TmpInclude:=LExecuteHookEvent(1000,99+ReportMode,MTExLocal^);
                    end;
                  {$ENDIF}

                  {$IFDEF C_On}

                    If (TmpInclude) and (Not RDevRec.Preview) and (Syss.AutoNotes) then
                    Begin

                      NDesc:=NoteDesc[ReportMode];

                      If (ReportMode=3) then
                        NDesc:=NDesc+Get_LetterDesc+' ';

                      NDesc:=NDesc+'sent.';

                      Process_AutoCustNotes(RFNum,RKeypath,CustCode,Today,NDesc);

                    end;

                  {$ENDIF}

                  If (CustCode>StaEnd) then
                  Begin
                    KeyS:=NdxWeight;
                    B_Next:=B_GetGEq;
                  end;

                  {$B+}

                end;

          5,8,10
             :  With LCust do
                Begin

                  {$B-}

                  TmpInclude:=((CustSupp=Filt) and (CustCode>=StaStart) and (CustCode<=StaEnd));

                  If (CustCode>StaEnd) then
                  Begin
                    KeyS:=NdxWeight;
                    B_Next:=B_GetGEq;
                  end;

                  {$B+}

                end;

          {$IFDEF STK}
            11 :
                  With LStock do
                  Begin

                    {$B-}

                    TmpInclude:=((Stk_InGroup(StaStart,LStock)) and (CheckKey(AccTFilt,BinLoc,Length(AccTFilt),BOff)) and
                                 (Not (StockType In [StkGrpCode,StkDListCode])));

                    {$B+}
                  end;

          {$ENDIF}

          {$IFDEF STK}
            12..14 :
                  With LId do
                  Begin

                    {$B-}

                    TmpInclude:=(Is_FullStkCode(StockCode) and ((KitLink=0) or (Not StkLabXComp)));

                    If (TmpIncLude) and (LStock.StockCode<>StockCode) then
                      TmpInclude:=LGetMainRecPos(StockF,StockCode);


                    Case StkLabQtyMode of
                      1  :  StkLabCopies:=Round(Qty);
                      3  :  StkLabCopies:=Round(QtyPick);
                    end; {Case..}


                    {$B+}
                  end;


          {$ENDIF}


        end; {Case..}
      end; {With..}

      {$B+}

      Result:=TmpInClude;
  end;


  Procedure TStaReport.PrintEndPage;

  Begin

  end;


  Function TStaReport.GetReportInput  :  Boolean;

  Var
    BoLoop
       :  Boolean;

    n  :  Integer;

    FoundCode
       :  Str20;

    ExLocal : TdExLocal;
    sKey : Str255;
    iStatus : Integer;

  Begin
    RFnum:=CustF;

    RKeyPath:=CustCodeK;

    RepKey:='';
    RepLen:=256;

    With CRepParam^ do
    Begin

      Filt:=TradeCode[BOn];


      Case ReportMode of
        2  :  Begin

                ThTitle:='Statements';
                RepTitle:='Statement Run';


                RForm:=SyssForms.FormDefs.PrimaryForm[4];

                // MH 06/01/2014 v7.0.8 ABSEXCH-14907: Modified to use an intelligent index that will skip Suppliers and set RepStartKey to allow
                //                                     it to jump into the first requested account where applicable to improve performance (and work!)
                RKeyPath    := ATCodeK;    // acCustSupp + acCode
                RepKey      := Filt;
                If (CRepParam^.StaStart <> '') Then
                Begin
                  // Jump in at the first requested account and switch to an intelligent index
                  RepStartKey := RepKey + Trim(CRepParam^.StaStart);
                End; // If (CRepParam^.StaStart <> '')
              end;

        3  :  Begin
                AgeDate:=Today;

                If (DebtLevel<>0) then
                  n:=37+DebtLevel
                else
                  n:=38;

                RForm:=SyssForms.FormDefs.PrimaryForm[n];

                ThTitle:='Debt Ltrs';
                RepTitle:='Debt Chase Letters Run';

                // MH 06/01/2014 v7.0.8 ABSEXCH-14908: Modified to use an intelligent index that will skip Suppliers and set RepStartKey to allow
                //                                     it to jump into the first requested account where applicable to improve performance (and work!)
                RKeyPath    := ATCodeK;    // acCustSupp + acCode
                RepKey      := Filt;
                If (CRepParam^.StaStart <> '') Then
                Begin
                  // Jump in at the first requested account and switch to an intelligent index
                  RepStartKey := RepKey + Trim(CRepParam^.StaStart);
                End; // If (CRepParam^.StaStart <> '')
              end;

        5  :  Begin
                Filt:=TradeCode[ShowOS];

                ThTitle:='Trade Ledger';
                RepTitle:='Trading Ledger Run';

                RForm:=SyssForms.FormDefs.PrimaryForm[2];

                // MH 29/10/2013 v7.X MRD1.1: Added report filter on account types
                If ShowOS Then
                Begin
                  // Customer
                  Case IncludeAccountTypes Of
                    atCustomersAndConsumers : Begin
                                                // Switch to CustSupp+Code index and specify correct CustSupp key
                                                RKeyPath := ATCodeK;  // acCustSupp + acCode
                                                RepKey := TradeCode[BOn]; // CustSupp='C'
                                              End; // atCustomersOnly
                    atCustomersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;
                                                RepKey := ConsumerUtils.CUSTOMER_CHAR;  // SubType='C'
                                              End; // atCustomersOnly
                    atConsumersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;
                                                RepKey := ConsumerUtils.CONSUMER_CHAR;  // SubType='U'
                                              End; // atConsumersOnly
                  Else
                    Raise Exception.Create ('TStaReport.GetReportInput: Unhandled Account Type setting (' + IntToStr(Ord(IncludeAccountTypes)) + ')');
                  End; // Case IncludeAccountTypes
                End // If ShowOS
                Else
                Begin
                  // Supplier - Switch to CustSupp+Code index and specify correct CustSupp key to improve performance
                  RKeyPath := ATCodeK; // acCustSupp + acCode
                  RepKey := TradeCode[BOff]; // CustSupp='S'
                End; // Else
                RepLen := Length(RepKey);

                // MH 06/01/2014 v7.0.8 ABSEXCH-14910: Modified to set RepStartKey to allow it to jump into the first requested account
                If (CRepParam^.StaStart <> '') Then
                Begin
                  // Jump in at the first requested account and switch to an intelligent index
                  RepStartKey := RepKey + Trim(CRepParam^.StaStart);
                End; // If (CRepParam^.StaStart <> '')
              end;

        8  :  Begin

                Filt:=TradeCode[ShowOS];

                ThTitle:='Acc Details';
                RepTitle:='Account Details Run';


                RForm:=SyssForms.FormDefs.PrimaryForm[1];

                // MH 29/10/2013 v7.X MRD1.1: Added report filter on account types
                If ShowOS Then
                Begin
                  // Customer
                  Case IncludeAccountTypes Of
                    atCustomersAndConsumers : Begin
                                                // Switch to CustSupp+Code index and specify correct CustSupp key
                                                RKeyPath := ATCodeK;      // acCustSupp + acCode
                                                RepKey := TradeCode[BOn]; // CustSupp='C'
                                              End; // atCustomersOnly
                    atCustomersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;  // acSubType + acCode
                                                RepKey := ConsumerUtils.CUSTOMER_CHAR;  // SubType='C'
                                              End; // atCustomersOnly
                    atConsumersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;  // acSubType + acCode
                                                RepKey := ConsumerUtils.CONSUMER_CHAR;  // SubType='U'
                                              End; // atConsumersOnly
                  Else
                    Raise Exception.Create ('TStaReport.GetReportInput: Unhandled Account Type setting (' + IntToStr(Ord(IncludeAccountTypes)) + ')');
                  End; // Case IncludeAccountTypes
                End // If ShowOS
                Else
                Begin
                  // Supplier - Switch to CustSupp+Code index and specify correct CustSupp key to improve performance
                  RKeyPath := ATCodeK; // acCustSupp + acCode
                  RepKey := TradeCode[BOff]; // CustSupp='S'
                End; // Else
                RepLen := Length(RepKey);

                // MH 06/01/2014 v7.0.8 ABSEXCH-14909: Modified to set RepStartKey to allow it to jump into the first requested account
                If (CRepParam^.StaStart <> '') Then
                Begin
                  // Jump in at the first requested account and switch to an intelligent index
                  RepStartKey := RepKey + Trim(CRepParam^.StaStart);
                End; // If (CRepParam^.StaStart <> '')
              end;


        10  :  Begin
                Filt:=TradeCode[ShowOS];

                ThTitle:='Acc Labels';
                RepTitle:='Account Label Run';


                RForm:=SyssForms.FormDefs.PrimaryForm[3];

                RDevRec.LabelMode:=BOn;

                // MH 29/10/2013 v7.X MRD1.1: Added report filter on account types
                If ShowOS Then
                Begin
                  // Customer
                  Case IncludeAccountTypes Of
                    atCustomersAndConsumers : Begin
                                                // Switch to CustSupp+Code index and specify correct CustSupp key
                                                RKeyPath := ATCodeK;      // acCustSupp + acCode
                                                RepKey := TradeCode[BOn]; // CustSupp='C'
                                              End; // atCustomersOnly
                    atCustomersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;  // acSubType + acCode
                                                RepKey := ConsumerUtils.CUSTOMER_CHAR;  // SubType='C'
                                              End; // atCustomersOnly
                    atConsumersOnly         : Begin
                                                // Switch to SubType+Code index and specify correct subtype key
                                                RKeyPath := CustACCodeK;  // acSubType + acCode
                                                RepKey := ConsumerUtils.CONSUMER_CHAR;  // SubType='U'
                                              End; // atConsumersOnly
                  Else
                    Raise Exception.Create ('TStaReport.GetReportInput: Unhandled Account Type setting (' + IntToStr(Ord(IncludeAccountTypes)) + ')');
                  End; // Case IncludeAccountTypes
                End // If ShowOS
                Else
                Begin
                  // Supplier - Switch to CustSupp+Code index and specify correct CustSupp key to improve performance
                  RKeyPath := ATCodeK;       // acCustSupp + acCode
                  RepKey := TradeCode[BOff]; // CustSupp='S'
                End; // Else
                RepLen := Length(RepKey);

                // MH 06/01/2014 v7.0.8 ABSEXCH-14911: Modified to set RepStartKey to allow it to jump into the first requested account
                If (CRepParam^.StaStart <> '') Then
                Begin
                  // Jump in at the first requested account and switch to an intelligent index
                  RepStartKey := RepKey + Trim(CRepParam^.StaStart);
                End; // If (CRepParam^.StaStart <> '')
              end;


      {$IFDEF STK}

        11..14
          :  Begin

                ThTitle:='Stk Labels';
                RepTitle:='Stock Label Run';

                // MH 07/02/2012 v6.10 ABSEXCH-10984: Added Account Code so correct form definition set can be used
                If (Trim(AccTFilt) <> '') Then
                Begin
                  // Own MtExLocal instance not created yet so use a temporary ExLocal instance to avoid messing
                  // up the global Cust record or position
                  ExLocal.Create;
                  Try
                    // Load Customer/Supplier record to find out what form definition set they have defined
                    sKey := FullCustCode(AccTFilt);
                    iStatus := Find_Rec(B_GetGEq,F[CustF],CustF,ExLocal.LRecPtr[CustF]^,CustCodeK,sKey);
                    If (iStatus = 0) And (ExLocal.LCust.FDefPageNo <> 0) Then
                    Begin
                      // Load form definition set
                      RForm := pfGetMultiFrmDefs(ExLocal.LCust.FDefPageNo).FormDefs.PrimaryForm[21];
                    End // If (iStatus = 0) And (ExLocal.LCust.FDefPageNo <> 0)
                    Else
                      // Customer load failed or they are using form definition set 0 (Global)
                      RForm := SyssForms.FormDefs.PrimaryForm[21];
                  Finally
                    ExLocal.Destroy;
                  End; // Try..Finally
                End // If (Trim(AccTFilt) <> '')
                Else
                  RForm := SyssForms.FormDefs.PrimaryForm[21];

                RDevRec.LabelMode:=BOn;

                Case ReportMode of
                  11
                      :  Begin
                           RFnum:=StockF;

                           RKeyPath:=SAgeInt;


                           If (ShowOS) then
                           Begin
                             RepKey:=StaStart;
                             RepLen:=Length(RepKey);
                           end;

                         end;

                  12..14
                      :  Begin
                           RFnum:=IDetailF;
                           RKeyPath:=IDLinkK;

                           If (ReportMode=12) then
                             RepKey:=FullNomKey(StkLabFolio)
                           else
                             RepKey:=FullIdKey(StkLabFolio,StkLabLineNo);

                           RepLen:=Length(RepKey);

                         end;

                end; {Case..}

              end;

      {$ENDIF}

      end; {Case..}

      New(ScrPtr);

      Blank(ScrPtr^,Sizeof(ScrPtr^));

      With ScrPtr^ do
      Begin
        StaAgedDate:=AgeDate;

        If (Not (ReportMode In [5,8,10,11..14])) then

          ShowMonthDoc:=ShowOS;

        SepCr:=StSepCr;

      end;



    end; {With..}

    Result:=BOn;
  end;





  Procedure TStaReport.Finish;

  Var
    ThisScrt   :  Scratch2Ptr;

  Begin
    With MTExLocal^,CRepParam^.ScrPtr^ do       {* Close scratch file, as otherwise DLL cannot open it *}
      If (Assigned(RepPtr)) and (ShowMonthDoc) then
      Begin
        ThisScrt:=RepPtr;

        ThisScrt^.KeepFile:=Not ThreadRec^.ThAbortPrint;

        Dispose(ThisScrt,Done);
      end;

    Inherited Finish;

    If (Not ThreadRec^.ThAbortPrint) then
      DelSwpFile;

  end;


  { ======== }



  Procedure AddStaRep2Thread(LMode    :  Byte;
                             IRepParam:  CustRepPtr;
                             AOwner   :  TObject);


  Var
    EntTest  :  ^TStaReport;

  Begin

    If (Create_BackThread) then
    Begin


      New(EntTest,Create(AOwner));

      try
        With EntTest^ do
        Begin
          ReportMode:=LMode;

          If (Assigned(IRepParam)) then
            CRepParam^:=IRepParam^;

            If (ReportMode In [2,3]) then
            Begin
              RDevRec.feBatch:=BOn;

              {If (ReportMode=2) then} {* Hide Fax/Email/XML tabes in this mode *}
                RDevRec.feTypes:=14;

            end;

          If (Create_BackThread) and (Start) then
          Begin
            With BackThread do
              AddTask(EntTest,ThTitle);
          end
          else
          Begin
            Set_BackThreadFlip(BOff);
            Dispose(EntTest,Destroy);
          end;
        end; {with..}

      except
        Dispose(EntTest,Destroy);

      end; {try..}
    end; {If process got ok..}

  end;

{$ENDIF} { RW }


procedure TGenReport.ParamNewPage(Sender: Tobject);
begin
  RepFiler1.Bold := True;
  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support 
  Self.PrintLeft(oPrintParams.Header, RepFiler1.MarginLeft);
  RepFiler1.Bold := False;
  // MH 05/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
  Self.CRLF;
  Self.CRLF;
end;

{ TRecAddress }

constructor TRecordAddress.Create(WithAddress: Integer);
begin
  inherited Create;
  FAddress := WithAddress;
end;



Initialization
  {$IFDEF REPMETRICS}
    DebugList := TStringList.Create;
  {$ENDIF}

  MDCADCalled := 0;
  MDCADFail1 := 0;
  MDCADFail2 := 0;
  MDCACIncluded := 0;
Finalization
  {$IFDEF REPMETRICS}
DebugList.Add ('MDCADCalled: ' + IntToStr(MDCADCalled));
DebugList.Add ('MDCADFail1: ' + IntToStr(MDCADFail1));
DebugList.Add ('MDCADFail2: ' + IntToStr(MDCADFail2));
DebugList.Add ('MDCACIncluded: ' + IntToStr(MDCACIncluded));

    DebugList.SaveToFile('c:\RepMetrics.txt');
    DebugList.Free;
  {$ENDIF}
end.

