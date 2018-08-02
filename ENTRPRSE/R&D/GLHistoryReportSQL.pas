//GS 08/03/2012 ABSEXCH-12200:
//this unit encapsulates the logic for producing the GL history report
unit GLHistoryReportSQL;

interface

uses
  SQLRep_BaseReport, GlobVar, SQLCallerU, ReportU, BTSupU3;

type

  //--Enumerations--

  //enum for controling the function of the print OCBLine method; used to control
  //if an opening, or closing balance is printed
  TOCBalanceType = (ocbOpeningBalance = 1, ocbClosingBalance = 2);
  //enum for controlling the functionality of the print totals method; used to control
  //if printing the subtotal, or the grand total
  TTotalMode = (tmSubtotal = 1, tmGrandTotal = 2);
  //enum for controlling access to the balance array; used to control reading
  //the debit, or credit amount from the array
  TDCBalanceType = (dcbDebitBalance = 1, dcbCreditBalance = 2);
  //a balance array, holds cumulative debit and credit values in different entries
  //access a specific entry by passing an enum
  TDCBalance = Array[dcbDebitBalance..dcbCreditBalance] of Double;

  //--Record Structures--

  //a record struct to hold all the report config data; most fields will be populated from
  //the report dialog with the user's input
  TGLHistorySettings = Record
    Currency            :Byte;
    TranslationCurrency :Byte;
    DepartmentCode      :String[3];
    CostCentreCode      :String[3];
    FromPeriod          :Byte;
    FromYear            :Byte;
    ToPeriod            :Byte;
    ToYear              :Byte;
    FromDate            :LongDate;
    ToDate              :LongDate;
    FilterByDate        :Boolean;
    AccountCode         :String[10];
    DocumentCode        :Integer;
    CommitMode          :Byte;
    FromGLCode          :Integer;
    ToGLCode            :Integer;
    SOP                 :Boolean;
    QuoteMode           :Boolean;
    CommitAccounting    :Boolean;
    Tag                 :Boolean;
    PrintParameters     :Boolean;
  end;

  //pointer type to the above record struct
  TGLHistorySettingsPtr = ^TGLHistorySettings;

  //a record struct to hold the the vals of a record returned by the SQL query;
  TGLHistoryRecord = Record
    tlGLCode            :Integer;
    tlDocType           :Integer;
    tlLineDate          :String[8];
    tlPaymentCode       :String[1];
    tlPriceMultiplier   :Double;
    tlNetValue          :Double;
    tlQty               :Double;
    tlQtyMul            :Double;
    tlUsePack           :Boolean;
    tlPrxPack           :Boolean;
    tlQtyPack           :Double;
    tlShowCase          :Boolean;
    tlVATCode           :String[1];
    tlVATIncValue       :Double;
    tlDiscount          :Double;
    tlDiscFlag          :String[1];
    tlDiscount2         :Double;
    tlDiscount2Chr      :String[1];
    tlDiscount3         :Double;
    tlDiscount3Chr      :String[1];
    tlCompanyRate       :Double;
    tlDailyRate         :Double;
    tlUseOriginalRates  :Integer;
    tlCurrency          :Integer;
    tlPeriod            :Integer;
    tlYear              :Integer;
    tlDescription       :String[60];
    thLongYourRef       :String[30];
    thYourRef           :String[20];
    thOurRef            :String[10];
    thAcCode            :String[10];
    thTransDate         :String[8];
    thDueDate           :String[8];
  end;
  //pointer type to the above record struct
  TGLHistoryRecordPtr = ^TGLHistoryRecord;

  //--Class Definition--

  //the GL History report object
  TGLHistoryReport = Object(TSQLRep_BaseReport)
  private
    // Each object to store its own GLHistorySettings
    GLHistorySettings  : TGLHistorySettings;
    //procedure for setting up parameter printing
    procedure SetupParameterPrinting;
    //get the line total for a transaction line
    function CalculateLineTotal(ApplyDiscount: Boolean; GLHistoryRecordPtr: TGLHistoryRecordPtr; GLHistorySettingsPtr: TGLHistorySettingsPtr): Double;
    //set the column structure of the report
    Procedure RepSetTabs; Virtual;
    //the method that prints the reports column-header titles
    Procedure RepPrintPageHeader; Virtual;
    //sets the reports title
    Function GetReportInput  :  Boolean; Virtual;
    //the method that prints the body of the report
    Procedure RepPrint(Sender : TObject); Virtual;
    //output a transaction line onto the report
    Procedure PrintLine_Transaction(DocumentCode, AccountCode, Reference,
                                                PeriodYear, TransactionDate, DueDate, Description, Debit, Credit: String);
    //print an opening or closing balance line
    Procedure PrintLine_OCBalances(BalanceType: TOCBalanceType; GLRecord: TGLHistoryRecordPtr; SettingsRecord: TGLHistorySettingsPtr; GLType: Char);
    //print a totals line
    Procedure PrintLine_Totals(DebitCreditBalance: TDCBalance; Mode: TTotalMode);
    //generate dynamic title strings here
    procedure ConfigureReportTitles;
    //extracts the data from a returned SQL record, and places it in a delphi record structure
    procedure ExtractSQLRecord(SQLRecords: TSQLCaller; DelphiRecord: TGLHistoryRecordPtr);
  public
    Constructor Create(Owner: TObject);
    //some required logging method? specifies what is written to the SQL log to identify this report
    Function SQLLoggingArea : String; Virtual;
  end;

  Function PrintGLHisToryReportSQL (Const ACostCentreCode, CostCentreDesc, ADepartmentCode, DepartmentDesc : ShortString;
          Const FirstReport : Boolean; CRepParam : DocRepPtr; Const Owner : TObject) : Boolean;

implementation

uses
  ExWrap1U, VarConst, ExBtTh1u,
  RPDefine,
  Graphics, ExThrd2U,
  SQLUtils, SQLRep_Config,
  SysUtils, DB, ADODB,
  BtKeys1U, CurrncyU, BTSupU1,
  ETStrU, RPBase, ComnU2,
  ETMiscU, ETDateU, BtSupu2,
  TypInfo, InvListU, Forms, AdoConnect,
  RpDevice, StrUtil;
var
  //interface to the user defined filter settings

  GLHistorySettingsPtr: TGLHistorySettingsPtr;

  //PR: 21/07/2017 ABSEXCH-18591 Variables for caching report settings and
  // amending filenames for multiple reports
  ReportNumber   : Integer;
  LocalDevRec    :  TSBSPrintSetupInfo;


//  PS - 20-11-2015 - ABSEXCH-13036 - GL history Report - Wildcard rules are not respected in MSSQL.
//  PS - Add function to Print report
Function PrintGLHisToryReportSQL (Const ACostCentreCode, CostCentreDesc, ADepartmentCode, DepartmentDesc : ShortString;
               Const FirstReport : Boolean;
               CRepParam  :  DocRepPtr;
               Const Owner : TObject) : Boolean;
var
  GLHistoryReportPtr: ^TGLHistoryReport;
  bContinue : Boolean;
  I: DocTypes;
Begin // PrintReport
  New(GLHistoryReportPtr, Create(Owner));
  Try
    //translate the generic CRepParam record to the more succinct TGLHistorySettings record
    //store the given report settings, they will be used to produce the report
    with GLHistoryReportPtr^.GLHistorySettings do
    begin
      Currency:=            CRepParam.RCr; //:Byte;
      TranslationCurrency:= CRepParam.RTxCr;//:Byte;
      DepartmentCode:=      ADepartmentCode;//CRepParam.RCCDep[BOff]; //:String[3];
      CostCentreCode:=      ACostCentreCode;//CRepParam.RCCDep[BOn];//:String[3];
      FromPeriod:=          CRepParam.RPr;//:Byte;
      FromYear:=            CRepParam.RYr;//:Byte;
      ToPeriod:=            CRepParam.Rpr2;//:Byte;
      ToYear:=              CRepParam.RYr2;//:Byte;
      FromDate:=            CRepParam.SDate;//:LongDate;
      ToDate:=              CRepParam.EDate;//:LongDate;
      FilterByDate:=        CRepParam.ByDate; //:Boolean;
      AccountCode:=         CRepParam.CustFilt;//:String[10];
      DocumentCode:=        GetEnumValue(TypeInfo(DocTypes), Copy(CRepParam.DocWanted,1, 3));//:Integer;
      CommitMode:=          CRepParam.CommitMode;//:Byte;
      FromGLCode:=          CRepParam.ReconCode;//:Integer;
      ToGLCode:=            CRepParam.NomToo;//:Integer;
      //--these need to be resolved (calculated, or from global vars)
      SOP:=                 False;
    {$IFDEF SOP}
      SOP:=                 True;
    {$ENDIF}
      QuoteMode:=           ((CRepParam.DocWanted=DocCodes[SQU]) or (CRepParam.DocWanted=DocCodes[PQU]));//:Boolean;
      CommitAccounting:=    CommitAct;//:Boolean;
      Tag:=                 CRepParam.CCDpTag;
      PrintParameters:=     CRepParam.PrintParameters;//:Boolean;

      //modify document code; if the result is negative
      if (DocumentCode = -1) then
      begin
        DocumentCode := -99; //set to the escape code (-99 = return all doc types)
        //HV 02/12/2015, JIRA-15804, GL History with filter set to 'NOM' Reports shows all Transaction Types
        If (Length(CRepParam.DocWanted) > 0) Then
        Begin
          For I := Low(DocTypes) To High(DocTypes) Do
          Begin
            If (Copy(DocCodes[I], 1, Length(Trim(CRepParam.DocWanted))) = CRepParam.DocWanted) Then
            Begin
              DocumentCode := Ord(I);
              Break;
            End; // If (Copy(DocCodes[I], 1, Length(Trim(CRepParam.DocWanted))) = CRepParam.DocWanted)
          End; // For I
        End; // If (Length(CRepParam.DocWanted) > 0)
      end;//end if
    end;//with GLHistorySettings

    //get a pointer to the 'report settings' record
    GLHistorySettingsPtr := Addr(GLHistoryReportPtr^.GLHistorySettings);
    //setup the columns of the report
    //perform setup for printing parameters; if applicable
    if (GLHistoryReportPtr^.GLHistorySettings.PrintParameters) then
    begin
      GLHistoryReportPtr^.SetupParameterPrinting;
    end;//end if

    If FirstReport Then
    Begin
      // Call Start to display the Print To dialog and then cache the details for subsequent reports
      bContinue := GLHistoryReportPtr^.Start;

      if bContinue then
      begin
        //PR: 21/07/2017 ABSEXCH-18591 cache report settings
        LocalDevRec    := GLHistoryReportPtr^.RDevRec;
//        OutputFilename := GLHistoryReportPtr^.RDevRec.feXMLFileDir;
        ReportNumber := 1;
      end;
    End // If FirstReport
    Else
    Begin
      // Copy in the cached details from the first report printed - don't want to display multiple Print To dialogs
      bContinue := True;
      //PR: 21/07/2017 ABSEXCH-18591 Restore report settings
      GLHistoryReportPtr^.RDevRec := LocalDevRec;

      //PR: 21/07/2017 ABSEXCH-18591 if printing to Excel or HTML then add a number to the filename
      if (GLHistoryReportPtr^.RDevRec.fePrintMethod in [5, 7]) then
      begin
        GLHistoryReportPtr^.RDevRec.feXMLFileDir := IncrementFilename(GLHistoryReportPtr^.RDevRec.feXMLFileDir, ReportNumber);
        inc(ReportNumber);
      end;

      // Need to create MTExLocal instance as the thread controller uses it to store the handle of the print routine!
      If (Not Assigned(GLHistoryReportPtr^.LPostLocal)) then
      Begin
        GLHistoryReportPtr^.Create_LocalThreadFiles(False);

        GLHistoryReportPtr^.MTExLocal := GLHistoryReportPtr^.LPostLocal;
      End;

      GLHistoryReportPtr^.GetReportInput;

      // Configure the TReportFiler component
      GLHistoryReportPtr^.InitRep1;
    End; // Else

    // Initialise the report and add it into the Thread Controller
    If bContinue Then
    Begin
      BackThread.AddTask(GLHistoryReportPtr, GLHistoryReportPtr^.ThTitle);
    End // If bContinue
    Else
    Begin
      Set_BackThreadFlip (BOff);
      Dispose (GLHistoryReportPtr, Destroy);
    end;
  Except
    // Stop printing if there was an exception
    bContinue := False;
    Dispose(GLHistoryReportPtr, Destroy);
  End; // Try..Except

  Result := bContinue;
end;

function TGLHistoryReport.CalculateLineTotal(ApplyDiscount: Boolean;
                                             GLHistoryRecordPtr: TGLHistoryRecordPtr;
                                             GLHistorySettingsPtr: TGLHistorySettingsPtr): Double;
var
  LineTotal: Double;
  UseOrigionalRate: Byte;
begin
  LineTotal := 0;
  //before we use the existing calc line total function we need to
  //package the SQL record data into a compatable format; this will involve packing
  //a transaction line (IDetail) record structure with relevant fields from
  //the SQL GH history record structure

  //initialise the local transaction line record
  FillChar(MTExLocal^.LId, SizeOf(MTExLocal.LId), 0);
  //populate the blank record with relevant info from the GH history record
  with MTExLocal^.LId, GLHistoryRecordPtr^ do
  begin
    nomcode	:=tlGLCode;
    iddoched	:=DocTypes(tlDocType);
    pdate	:=tlLineDate;
    payment	:=tlPaymentCode[1];
    pricemulx	:=tlPriceMultiplier;
    netvalue	:=tlNetValue;
    qty	        :=tlQty;
    qtymul	:=tlQtyMul;
    usepack	:=tlUsePack;
    prxpack	:=tlPrxPack;
    qtypack	:=tlQtyPack;
    showcase	:=tlShowCase;
    vatcode	:=tlVATCode[1];
    incnetvalue	:=tlVATIncValue;
    discount	:=tlDiscount;
    discountchr	:=tlDiscFlag[1];
    discount2	:=tlDiscount2;
    discount2chr:=tlDiscount2Chr[1];
    discount3	:=tlDiscount3;
    discount3chr:=tlDiscount3Chr[1];
    useORate	:=tlUseOriginalRates;
    currency	:=tlCurrency;
    CXRate[false]:=tlCompanyRate;
    CXRate[true] :=tlDailyRate;
    ppr	        :=tlPeriod;
    pyr   	:=tlYear;
    desc  	:=tlDescription;
  end;//end with

  //call the 'DetLTotal' function passing the populated transaction line record, this will return the line total
  LineTotal := DetLTotal(MTExLocal^.LId,ApplyDiscount,BOff,0.0);

  //do complex currency related tasks -_-
  with (MTExLocal^.LId) do
  begin
    if (GLHistorySettingsPtr^.Currency = 0) then
    begin
      UseOrigionalRate := fxUseORate(false, true, CXrate, GLHistoryRecordPtr^.tlUseOriginalRates, Currency, 0);
      LineTotal := Round_Up(Conv_TCurr(LineTotal,XRate(CXRate,false,Currency),Currency,UseOrigionalRate,false),2);
    end;//end if

    with GLHistorySettingsPtr^ do
    begin
      LineTotal:=Round_Up(Currency_Txlate(LineTotal, Currency, TranslationCurrency),2);
    end;//end with
  end;//end with

  result := LineTotal;
end;

procedure TGLHistoryReport.ConfigureReportTitles;
Const
    CommitTitle  :  Array[1..2] of Str50 = ('Committed & Actual values.','Committed values only.');
var
  CostCentreString: String;
  ReturnVal: String[20];
begin
  //set the report orientation to landscape
  ROrient:=RPDefine.PoLandscape;

  RepTitle:='General Ledger History Report';

  with GLHistorySettings do
  begin
  //config report title to show currency filters
  {$IFDEF MC_On}
    If (TranslationCurrency<>0) and (TranslationCurrency<>Currency) then
    begin
      RepTitle:=CurrDesc(Currency)+'to '+CurrDesc(TranslationCurrency)+RepTitle;
    end
    else
    begin
      RepTitle:=CurrDesc(Currency)+RepTitle;
    end;//end if
  {$ENDIF}

  //config report title to show commitment mode
  {$IFDEF SOP}
     If (CommitAccounting) and (CommitMode In [1,2]) then
     begin
       RepTitle2:=CommitTitle[CommitMode];
     end;//end if
  {$ENDIF}

    //config report title to show account
    If (AccountCode <>'') then
    Begin
      //use local record structs, if available
      If (Assigned(MTExLocal)) then
      begin
        With MTExLocal^ do
        Begin
          If LGetMainRec(CustF, AccountCode) then
          begin
            RepTitle2:=RepTitle2+'For '+Strip('B',[#32],LCust.Company);
          end;//end if
        end;//end with
      end
      else
      //use global record structs
      Begin
        GetCust(Application.MainForm,AccountCode,ReturnVal,BOn,-1);
        RepTitle2:=RepTitle2+'For '+Strip('B',[#32],Cust.Company);
      end;//end if
    end;//end if

    //config report title to show document type
    If (DocumentCode<>-99) then
    Begin
      If (RepTitle2<>'') then
      begin
        RepTitle2:=RepTitle2+', ';
      end;//end if
      RepTitle2:=RepTitle2+'Document Filter : '+ GetEnumName(TypeInfo(DocTypes), DocumentCode);
    end;//end if

  {$IFDEF PF_On}
  //config report title to show department
    if (DepartmentCode <> '') then
    begin
      CostCentreString:='';
      If (Assigned(MTExLocal)) then
      begin
        With MTExLocal^ do
        Begin
          If LGetMainRec(PWrdF,FullCCKey('C','D',DepartmentCode)) then
          begin
            CostCentreString:=LPassword.CostCtrRec.CCDesc;
          end;//end if
        end;//end with
      end
      else
      Begin
        GetCCDep(Application.MainForm,DepartmentCode,ReturnVal,False,-1);
        CostCentreString:=Password.CostCtrRec.CCDesc;
      end;//end if

      If (RepTitle2<>'') then
      begin
        RepTitle2:=RepTitle2+', ';
      end;//end if
      RepTitle2:=RepTitle2+CostCtrRTitle[False]+' '+DepartmentCode+'-'+CostCentreString;
    end;//end if

    //config report title to show cost centre
    if (CostCentreCode <> '') then
    begin
      CostCentreString:='';
      If (Assigned(MTExLocal)) then
      begin
        With MTExLocal^ do
        Begin
          If LGetMainRec(PWrdF,FullCCKey('C','C',CostCentreCode)) then
          begin
            CostCentreString:=LPassword.CostCtrRec.CCDesc;
          end;//end if
        end;//end with
      end
      else
      Begin
        GetCCDep(Application.MainForm,CostCentreCode,ReturnVal,True,-1);
        CostCentreString:=Password.CostCtrRec.CCDesc;
      end;//end if

      If (RepTitle2<>'') then
      begin
        RepTitle2:=RepTitle2+', ';
      end;//end if
      RepTitle2:=RepTitle2+CostCtrRTitle[True]+' '+CostCentreCode+'-'+CostCentreString;
    end;//end if
  {$ENDIF}

    //display the date range on the title
    If (FilterByDate) then
    begin
      PageTitle:=RepTitle+' ('+POutDate(FromDate)+' - '+POutDate(ToDate)+')'
    end
    else
    begin
      PageTitle:=RepTitle+' ('+PPR_OutPr(FromPeriod,FromYear)+' - '+PPR_OutPr(ToPeriod,ToYear)+')';
    end;//end if 
  end;//end with
end;

Constructor TGLHistoryReport.Create(Owner: TObject);
begin
  //call the parent constructor (otherwise attached objects wont get initialised!)
  Inherited Create(Owner);
  //setup the columns of the report
  RepSetTabs;

  //add the title to report
  ThTitle := 'G/L History Report';
end;

procedure TGLHistoryReport.ExtractSQLRecord(SQLRecords: TSQLCaller;
  DelphiRecord: TGLHistoryRecordPtr);
begin
  //extract the record data from the SQLCaller object and place it in a dedicated
  //record structure
  with DelphiRecord^, SQLRecords.Records do
  begin
    tlGLCode            := FieldByName('tlGLCode').AsInteger;
    tlDocType           := FieldByName('tlDocType').AsInteger;
    tlLineDate          := Copy(FieldByName('tlLineDate').AsString, 1, 8);
    tlPaymentCode       := Copy(FieldByName('tlPaymentCode').AsString, 1, 1);
    tlPriceMultiplier   := FieldByName('tlPriceMultiplier').AsFloat;
    tlNetValue          := FieldByName('tlNetValue').AsFloat;
    tlQty               := FieldByName('tlQty').AsFloat;
    tlQtyMul            := FieldByName('tlQtyMul').AsFloat;
    tlUsePack           := FieldByName('tlUsePack').AsBoolean;
    tlPrxPack           := FieldByName('tlPrxPack').AsBoolean;
    tlQtyPack           := FieldByName('tlQtyPack').AsFloat;
    tlShowCase          := FieldByName('tlShowCase').AsBoolean;
    tlVATCode           := Copy(FieldByName('tlVATCode').AsString, 1, 1);
    tlVATIncValue       := FieldByName('tlVATIncValue').AsFloat;
    tlDiscount          := FieldByName('tlDiscount').AsFloat;
    tlDiscFlag          := Copy(FieldByName('tlDiscFlag').AsString, 1, 1);
    tlDiscount2         := FieldByName('tlDiscount2').AsFloat;
    tlDiscount2Chr      := Copy(FieldByName('tlDiscount2Chr').AsString, 1, 1);
    tlDiscount3         := FieldByName('tlDiscount3').AsFloat;
    tlDiscount3Chr      := Copy(FieldByName('tlDiscount3Chr').AsString, 1, 1);
    tlCompanyRate       := FieldByName('tlCompanyRate').AsFloat;
    tlDailyRate         := FieldByName('tlDailyRate').AsFloat;
    tlUseOriginalRates  := FieldByName('tlUseOriginalRates').AsInteger;
    tlCurrency          := FieldByName('tlCurrency').AsInteger;
    tlPeriod            := FieldByName('tlPeriod').AsInteger;
    tlYear              := FieldByName('tlYear').AsInteger;
    tlDescription       := Copy(FieldByName('tlDescription').AsString, 1, 60);
    thLongYourRef       := Copy(FieldByName('thLongYourRef').AsString, 1, 30);
    thYourRef           := Copy(FieldByName('thYourRef').AsString, 1, 20);
    thOurRef            := Copy(FieldByName('thOurRef').AsString, 1, 10);
    thAcCode            := Copy(FieldByName('thAcCode').AsString, 1, 10);
    thTransDate         := Copy(FieldByName('thTransDate').AsString, 1, 8);
    thDueDate           := Copy(FieldByName('thDueDate').AsString, 1, 8);
  end;//end with
end;

function TGLHistoryReport.GetReportInput: Boolean;
begin
  //adjust the report title(s) to reflect the users filter settings
  ConfigureReportTitles;
  Result := True;
end;

procedure TGLHistoryReport.PrintLine_OCBalances(
  BalanceType: TOCBalanceType; GLRecord: TGLHistoryRecordPtr; SettingsRecord: TGLHistorySettingsPtr; GLType: Char);
Var
  Title: String;
  AmountNum: Double;
  CreditString, DebitString: String;
  TargetPeriod: Byte;
  TargetYear: Byte;
Const
  OpeningBalanceTitle = 'Opening Balance';
  ClosingBalanceTitle = 'Closing Balance';
begin
  AmountNum    := 0;
  TargetPeriod := 0;
  TargetYear   := 0;
  //configure the line title, and the date range depending on
  //if we want the opening or closing balance
  Case BalanceType of
    ocbOpeningBalance:
    begin
      Title := OpeningBalanceTitle;
      TargetPeriod := SettingsRecord^.FromPeriod;
      TargetYear := SettingsRecord^.FromYear;
    end;
    ocbClosingBalance:
    begin
      Title := ClosingBalanceTitle;
      TargetPeriod := SettingsRecord^.ToPeriod;
      TargetYear := SettingsRecord^.ToYear;
    end;
  end;//end case

  //fetch the balances, logic varies depending on if SOP is enabled,
  //and the 'Committed and Actuals' filter selected on the report dialog
  with GLRecord^, SettingsRecord^ do
  begin
  {$IFDEF SOP}
    if (SOP) then
    begin
      //if the commit mode is not set to 'commitment only'..
      if (CommitMode in [0,1]) then
      begin
        //get the 'actual' opening balance for the GL code
        AmountNum := Get_OCBal(GLType, FullNomKey(tlGLCode), Currency, TargetYear,TargetPeriod, 0, (BalanceType = ocbClosingBalance));
      end;//end if

      //if the commit mode is not set to 'exclude commitment figures'..
      if ((CommitMode in [1,2]) and CommitAct) then
      begin
        //get the 'committed' balance for the GL code and add it to the 'actual' balance
        //the search key is prefixed with the 'commitkey' constant to return the committed amount
        AmountNum := AmountNum + Get_OCBal(GLType, CommitKey+FullNomKey(tlGLCode), Currency, TargetYear,TargetPeriod, 0, (BalanceType = ocbClosingBalance));
      end;//end if
    end
    else
  {$ENDIF}
    begin
      //SOP is disabled, jus get the 'actual' balance for the GL code
      AmountNum := Get_OCBal(GLType, FullNomKey(tlGLCode), Currency, TargetYear,TargetPeriod, 0, (BalanceType = ocbClosingBalance));
    end;
  end;//end with

  //translate the balance to the selected currency
  AmountNum := Currency_Txlate(AmountNum, SettingsRecord^.Currency, SettingsRecord^.TranslationCurrency);

  //prepare the amount for printing
  CreditString := '0.00';
  DebitString := '0.00';

  //determine if the amount is positive or negative, and convert it to a string
  //using a predefined formatting profile 'GenRealMask' defines in BTSupU1
  if (AmountNum < 0) then
  begin
    CreditString := FormatFloat(GenRealMask, ABS(AmountNum));
  end
  else
  begin
    DebitString := FormatFloat(GenRealMask, ABS(AmountNum));
  end;//end if

  //print a line to the body of the report
  DefFont(0,[]);
  // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
  Self.PrintLeft(Title, RepFiler1.MarginLeft);

  Self.SendLine(#9 +
                #9 +
                #9 +
                #9 +
                #9 +
                #9 +
                #9 +
                #9 + DebitString +
                #9 + CreditString);

  //draw a seperator line; if we have printed the closing balance
  If (BalanceType = ocbClosingBalance) then
  Begin
    DefLine(-1,RepFiler1.MarginLeft,245,-0.6);
    // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
    Self.CrLf;
  end;
end;

procedure TGLHistoryReport.PrintLine_Totals(DebitCreditBalance: TDCBalance; Mode: TTotalMode);
Const
  TotalsHeader = 'Totals.:';
var
  DebitAmount, CreditAmount: Double;
  DebitString, CreditString: String;
begin
  //set the font to default
  DefFont(0,[]);

  //get the debit  and credit amount totals from the TDCBalance argument
  //(TDCBalance object is an array, accessed by enum value, depending on what balance is wanted)
  DebitAmount := DebitCreditBalance[dcbDebitBalance];
  CreditAmount := DebitCreditBalance[dcbCreditBalance];

  //if we are about to print the grand total, draw a long seperator line
  if (Mode = tmGrandTotal) then
  begin
    DefLine(-1,1,RepFiler1.PageWidth-RepFiler1.MarginRight-1,0);
  end
  else
  begin
    //else if this is a subtotal balance; draw a short seperator line
    DefLine(-1,210,275,0);
  end;//end if

  //format the debit and credit values before printing them
  if (DebitAmount = 0) then
  begin
    DebitString := '';
  end
  else
  begin
    DebitString := FormatFloat(GenRealMask,ABS(DebitAmount));
  end;//end if

  if (CreditAmount = 0) then
  begin
    CreditString := '';
  end
  else
  begin
    CreditString := FormatFloat(GenRealMask,ABS(CreditAmount));
  end;//end if

  //print a 'total amount' line to the body of the report
  SendLine(ConCat(ConstStr(#9,7),Spc(59)+TotalsHeader,#9, DebitString,
                          #9,CreditString));

   if (Mode = tmSubtotal) then
   begin
     //if we are printing a subtotal balance, print a seperator line below the subtotal amount
     DefLine(-2,210,275,0);
   end;//end if
end;

procedure TGLHistoryReport.PrintLine_Transaction(DocumentCode, AccountCode, Reference,
                                                PeriodYear, TransactionDate, DueDate, Description, Debit, Credit: String);
begin
  //print a line to the body of the report
  self.SendLine(#9 + DocumentCode +
                #9 + AccountCode +
                #9 + Reference +
                #9 + PeriodYear +
                #9 + TransactionDate +
                #9 + DueDate +
                #9 + Description +
                #9 + Debit +
                #9 + Credit);
end;//PrintLine

procedure TGLHistoryReport.RepPrint(Sender: TObject);
var
  Period: String;
  ShowOpenCloseBalance: Boolean;
  ReferenceString: String;
  LineTotal: Double;
  LineDebit: Double;
  LineCredit: Double;
  DebitString: String;
  CreditString: String;
  ApplyDiscount: Boolean;
  SqlCaller: TSQLCaller;
  SqlQuery: AnsiString;
  RecordCount: Integer;
  CompanyCode: String;
  ConnectionString,
  lPassword: WideString;  //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  GLHistoryRecord: TGLHistoryRecord;
  GLHistoryRecordPtr: TGLHistoryRecordPtr;
  LastGLHistoryRecord: TGLHistoryRecord;
  LastGLHistoryRecordPtr: TGLHistoryRecordPtr;
  LastGLCode: Integer; //the GL code of the last line we printed
  GLType: Char;
  SubsectionDebitCredit: TDCBalance; //arrays of type 'Double' for storing the credit & debit totals
  ReportDebitCredit: TDCBalance;

  //inline procedure for starting a new page of the report
  procedure StartNewPage;
  begin
    { CJS 2012-06-26 - ABSEXCH-13063 - GL History Report to Excel - extended the
                                       check for page breaks }
    //determine if we need a new page on the report
    // MH 25/11/2015 2016-R1 ABSEXCH-10720: eDocEngine requires the Page Breaks to be written
    // when printing to Excel, otherwise any data is lost when it reaches the bottom of the page
    If (RepFiler1.LinesLeft<5) {and ((RDevRec.fePrintMethod <> 5) or (RDevRec.feMiscOptions[2]))} then
    begin
      ThrowNewPage(5);
      //if we are starting a new page, but still printing records from the same GL subgroup
      //then print the subgroup header again (this header contains 'Continued..' so the user
      //knows that the rest of the data is on another page)
      with GLHistoryRecord do
      begin
        if (LastGLCode = tlGLCode) then
        begin
          PrintNomLine(FullNomKey(tlGLCode), true);
        end;//end if
      end;//end with
    end;//end if
  end;//end StartNewPage

  //inline function for formatting SQL date strings to something more readable
  function FormatDate(Date: String): String;
  var
    FormattedDate: String;
  begin
    //getout clause for blank dates
    if(Trim(Date) = '') then
      Result := ''
    else
      Result := POutDate(Date);   //SSK 03/05/2018 2018 R1.1 ABSEXCH-19216: this change will facilitate to respect system Date Format in GL history Report
  end;//end FormatDate

begin
  GlType := #0;
  LastGLHistoryRecordPtr := nil;
  //initialise the record counter attached to the TGenReport object
  ICount := 0;
  //start the report logger attached to the TGenReport object
  oReportLogger.StartReport;
  //retrieve the active company code
  CompanyCode := GetCompanyCode(SetDrive);

  //attempt to retrieve the connection string
  //If (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
  //SS:01/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  If (GetConnectionStringWOPass(CompanyCode, False, ConnectionString, lPassword) = 0) Then
  begin
    // Create a SQL Query object to use for executing the stored procedure
    //RB 06/07/2017 2017-R2 ABSEXCH-18944: Use Global SQL Connection for SQLCaller
    SqlCaller := TSQLCaller.Create(GlobalAdoConnection);
    try
      //GS 04/04/2012 ABSEXCH-12751: added status message to the OTC
      ShowStatus(2,'Retrieving Data, Please Wait...');
      ShowStatus(3,'This can take several minutes');

      SqlCaller.Records.CommandTimeout := SQLReportsConfiguration.ReportTimeoutInSeconds;

      // Build the SQL Query for calling the stored procedure
      //GS 16/04/2012 ABSEXCH-12812: adjusted how parameters are compiled into the SQL string so that Explict typing is used; to improve efficiency
      with GLHistorySettings do
      begin
        SqlQuery := '[COMPANY].isp_Report_GLHistory ' +
          '@iv_AccountCode='          + QuotedStr(AccountCode) + ', ' +                 //VARCHAR(10)
          '@iv_Currency='             + IntToStr(Currency) + ', ' +          //INT
          '@iv_DepartmentCode='       + QuotedStr(DepartmentCode) + ', ' +              //VARCHAR(3)
          '@iv_CostCentreCode='       + QuotedStr(CostCentreCode) + ', ' +              //VARCHAR(3)
          '@iv_FromYear='             + IntToStr(FromYear) + ', ' +          //INT
          '@iv_FromPeriod='           + IntToStr(FromPeriod) + ', ' +        //INT
          '@iv_ToYear='               + IntToStr(ToYear) + ', ' +            //INT
          '@iv_ToPeriod='             + IntToStr(ToPeriod) + ', ' +          //INT
          '@iv_FromDate='             + QuotedStr(FromDate) + ', ' +                    //DATETIME
          '@iv_ToDate='               + QuotedStr(ToDate) + ', ' +                      //DATETIME
          '@iv_FromGLCode='           + IntToStr(FromGLCode) + ', ' +        //INT
          '@iv_ToGLCode='             + IntToStr(ToGLCode) + ', ' +          //INT
          '@iv_FilterByDate='         + IntToStr(Ord(FilterByDate)) + ', ' + //BIT
          '@iv_TransactionType='      + IntToStr(DocumentCode) + ', ' +      //INT
          '@iv_CommitMode='           + IntToStr(CommitMode) + ', ' +        //INT
          '@iv_IsSOPEnabled='         + IntToStr(Ord(SOP)) + ', ' +          //BIT
          '@iv_IsQuote='              + IntToStr(Ord(QuoteMode)) + ', ' +    //BIT
          '@iv_IsCommitAccounting='   + IntToStr(Ord(CommitAccounting));     //BIT
        end;//with GLHistorySettings

      //execute the query
      oReportLogger.StartQuery(SqlQuery);
      SqlCaller.Select(SqlQuery, CompanyCode);
      oReportLogger.FinishQuery;
      //GS 04/04/2012 ABSEXCH-12751: added status message to the OTC
      ShowStatus(2,'Processing Report.');
      ShowStatus(3,'');

      try
        //if records were found; process the data
        if (SqlCaller.ErrorMsg = '') then
        begin
          if (SqlCaller.Records.RecordCount > 0) then
          begin
            //log the number of records found
            oReportLogger.QueryRowCount(SqlCaller.Records.RecordCount);
            //initialise the progress bar to the number of records found
            InitProgress(SqlCaller.Records.RecordCount);

            //before we start printing; disable the reports UI for efficiency
            //as theres no point updating the UI after each line is printed; only interested in viewing teh finished report!
            SqlCaller.Records.DisableControls;
            try
            begin
              //go to the first record
              SQLCaller.Records.First;
              //determine if the opening / closing balances should be displayed
              //date /doc type /account code / cost centre / department filters active = dont display balances!
              with GLHistorySettings do
              begin
                ShowOpenCloseBalance := false;
                if(FilterByDate = false) and    //must be filtering by period / year dates  AND
                  (AccountCode = '') and        //have no account code filter               AND
                  (DocumentCode = -99) and      //have no transaction document filter (-99) AND
                  (CostCentreCode = '') and     //have no cost centre filter                AND
                  (DepartmentCode = '') then    //have no department filter..
                begin
                  //..to display the opening / closing balances
                  ShowOpenCloseBalance := true;
                end;//end if
              end;//end with

              //loop through each record returned by the SQL caller object
              if SqlCaller.Records.RecordCount > 0 then
              begin
                //goto the next record, if it exists, and if the user has not clicked the abort button
                While (SQLCaller.Records.Eof = False) and (ThreadRec^.THAbort = False) do
                begin
                  //erase \ initialise the GL history record structure - happens at every iteration
                  FillChar(GLHistoryRecord, SizeOf(GLHistoryRecord), 0);
                  //get addr of record
                  GLHistoryRecordPtr := Addr(GLHistoryRecord);
                  //extract the values from the current SQL record; place results in the fresh record structure
                  ExtractSQLRecord(SQLCaller, GLHistoryRecordPtr);

                  //set up vars to store a persistant copy of a GLHistoryRecord
                  //(this is used if we need to backtrack one record iteration, for any reason)
                  if (LastGLCode = 0) then
                  begin
                    //erase \ initialise the record struct
                    FillChar(LastGLHistoryRecord, SizeOf(LastGLHistoryRecord), 0);
                    //get addr of record
                    LastGLHistoryRecordPtr := Addr(LastGLHistoryRecord);

                    //initialise running totals
                    FillChar(SubsectionDebitCredit, SizeOf(SubsectionDebitCredit),0);
                    FillChar(ReportDebitCredit, SizeOf(ReportDebitCredit),0);
                  end;//end if

                  //increment the record counter
                  Inc(ICount);

                  //initialisation complete; start the print line logic
                  with GLHistoryRecord do
                  begin

                    //if we are about to start printing a different GL subsection..
                    if (LastGLCode <> tlGLCode) then
                    begin
                      //and the last GL code is not zero (indicates that we are in
                      //the middle of the printing process; not at the start)
                      if (LastGLCode <> 0 ) then
                      begin
                        //print total here:
                        //print
                        PrintLine_Totals(SubsectionDebitCredit, tmSubtotal);
                        //accumulate grand totals
                        ReportDebitCredit[dcbDebitBalance] := ReportDebitCredit[dcbDebitBalance] + SubsectionDebitCredit[dcbDebitBalance];
                        ReportDebitCredit[dcbCreditBalance] := ReportDebitCredit[dcbCreditBalance] + SubsectionDebitCredit[dcbCreditBalance];
                        //reset subtotal
                        FillChar(SubsectionDebitCredit, SizeOf(SubsectionDebitCredit),0);
                        //print closing balance here
                        if (ShowOpenCloseBalance = true) then
                        begin
                          PrintLine_OCBalances(ocbClosingBalance, LastGLHistoryRecordPtr, GLHistorySettingsPtr, GLType);
                        end;//end if
                      end;
                      //before we print a new GL subsection header, check if we need to start on a new page
                      StartNewPage;
                      //print GL subsection header here
                      PrintNomLine(FullNomKey(tlGLCode), false);
                      //'PrintNomLine' will load the GL code (nominal) record into the inherited MtExLocal object (this<TGenReport<TThreadQueue>MtExLocal)
                      //extract the 'NomType' field from this record as we will need it later
                      GLType := MTExLocal^.LNom.NomType;
                      //print opening balance here
                      if (ShowOpenCloseBalance = true) then
                      begin
                        PrintLine_OCBalances(ocbOpeningBalance, GLHistoryRecordPtr, GLHistorySettingsPtr, GLType);
                      end;//end if
                      //keep a record of the code of the current GL subsection
                      LastGLCode := tlGLCode;
                      //keep a backup of the current record; its contents will be used later
                      //to print the closing balance for this GL subsection
                      LastGLHistoryRecord := GLHistoryRecord;
                    end;//end if

                    //before we print the next transaction line, check if we
                    //need to contine the current GL subsection on a new page
                    StartNewPage;

                    //calc line total here:
                    //get the 'apply discount' flag, if this line is a run line, construct an ID for the line
                    if (GLHistoryRecord.tlDocType = Ord(RUN)) then
                    begin
                      ApplyDiscount := true;
                      //modify the returned SQL data; construct a run transaction code
                      GLHistoryRecord.thOurRef := GetEnumName(TypeInfo(DocTypes), tlDocType) + ' ' + Trim(GLHistoryRecord.tlLineDate);
                    end
                    else
                    begin
                      ApplyDiscount := (Not Syss.SepDiscounts);
                    end;//end if

                    //calculate the line total
                    LineTotal := CalculateLineTotal(ApplyDiscount, GLHistoryRecordPtr, GLHistorySettingsPtr);

                    //determine if this line total is a debit or credit
                    LineDebit := 0;
                    LineCredit := 0;

                    //accumulate the subsection totals
                    if LineTotal < 0 then
                    begin
                      LineCredit := LineTotal;
                      SubsectionDebitCredit[dcbCreditBalance] := SubsectionDebitCredit[dcbCreditBalance] + LineCredit;
                    end
                    else
                    begin
                      LineDebit := LineTotal;
                      SubsectionDebitCredit[dcbDebitBalance] := SubsectionDebitCredit[dcbDebitBalance] + LineDebit;
                    end;//end if

                    //determine what the description column will display based on the line doc type
                    If (GLHistoryRecord.tlDocType = Ord(NMT)) then
                    begin
                      //exclude the first char of the long YourRef string, as its an illegible length byte
                      ReferenceString:= Copy(GLHistoryRecord.thLongYourRef, 2, Length(GLHistoryRecord.thLongYourRef));
                    end
                    else
                    begin
                      ReferenceString:=GLHistoryRecord.thYourRef;
                    end;//end if

                    //add a drilldown link to the transaction line
                    SendRepDrillDown(1,TotTabs,1,GLHistoryRecord.thOurRef,InvF,InvOurRefK,0);
                    //add a second drilldown link to the transaction line; ontop of the first;
                    //this link is localised to the account code; for opening the account record.
                    SendRepDrillDown(2,2,2,FullCustCode(GLHistoryRecord.thAcCode),CustF,CustCodeK,0);

                    //format the debit and credit values before printing them
                    if (LineDebit = 0) then
                    begin
                      DebitString := '';
                    end
                    else
                    begin
                      DebitString := FormatFloat(GenRealMask,ABS(LineDebit));
                    end;//end if

                    if (LineCredit = 0) then
                    begin
                      CreditString := '';
                    end
                    else
                    begin
                      CreditString := FormatFloat(GenRealMask,ABS(LineCredit));
                    end;//end if

                    //if the preiod is less than '10', add a preceeding zero to make it a double-digit figure
                    Period := IntToStr(tlPeriod);
                    if Length(Period) = 1 then
                    begin
                      Period := '0' + Period;
                    end;//end if

                    //GS 04/04/2012 ABSEXCH-12755: adjust the formatting of the period value, based on system settings
                    Period := PPR_Pr(StrToInt(Period));

                    //print the transaction line here
                    PrintLine_Transaction(thOurRef,
                                          thAcCode,
                                          ReferenceString,
                                          Period + '/' + IntToStr((tlYear + 1900)),
                                          FormatDate(thTransDate),
                                          FormatDate(thDueDate),
                                          tlDescription,
                                          DebitString,
                                          CreditString);

                    //if we have just printed the last record..
                    if(ICount = SqlCaller.Records.RecordCount) then
                    begin
                      //..print the subtotal and closing balance for the final GL subsection
                      PrintLine_Totals(SubsectionDebitCredit, tmSubtotal);
                      if (ShowOpenCloseBalance = true) then
                      begin
                        PrintLine_OCBalances(ocbClosingBalance, LastGLHistoryRecordPtr, GLHistorySettingsPtr, GLType);
                      end
                      else
                      begin
                        //as we are not printing the closing balance;
                        //add a blank line between the subtotal and total for formatting purposes
                        // MH 06/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx helper methods for .xlsx support
                        Self.CrLf;
                      end;//end if
                      //accumulate the grand total
                      ReportDebitCredit[dcbDebitBalance] := ReportDebitCredit[dcbDebitBalance] + SubsectionDebitCredit[dcbDebitBalance];
                      ReportDebitCredit[dcbCreditBalance] := ReportDebitCredit[dcbCreditBalance] + SubsectionDebitCredit[dcbCreditBalance];
                      //print grand total here
                      PrintLine_Totals(ReportDebitCredit, tmGrandTotal);
                    end;//end if
                  end;//end with
                  //update the thread progress bar
                  UpdateProgress(ICount);
                  //go to the next SQL record
                  SQLCaller.Records.Next;
                end;//end while
                //we have finished processing the report, update the progress bar to max
                UpdateProgress(SqlCaller.Records.RecordCount);
              end;//end if
            end //end try (body)
            finally
              //after we have finished printing the report lines, enable the UI
              SQLCaller.Records.EnableControls;
              //reiterate that we want a landscape output (enable/disable controls seems to assert portrait landscape?!)
              ROrient:=RPDefine.PoLandscape;
            end;//end try finally
          end //if SQL returned 0 records
          else if (sqlCaller.ErrorMsg <> '') then
          begin
            WriteSQLErrorMsg (sqlCaller.ErrorMsg);
          end;//end else if
          //print the footer of the report
          PrintEndPage;
        end;//end if SQL returned an error
      finally
        sqlCaller.Close;
      end;//end try
    finally
      sqlCaller.Free;
    end;//end try
  end;//end if
end;

procedure TGLHistoryReport.RepPrintPageHeader;
begin
  //print the column header on the report
  DefFont(0,[fsBold]);
  PrintLine_Transaction('Our Ref',
                'Acc No',
                'Your Ref',
                'Per/Yr', //GS 02/04/2012 ABSEXCH-12734: changed column header as requested
                'Date',
                'Due Date',
                'Description',
                'Debit',
                'Credit');
  DefFont(0,[]);
end;

procedure TGLHistoryReport.RepSetTabs;
  Begin // RepSetTabs
    //set up the columns of the report
    With RepFiler1 do //member of TSQLRep_BaseReport::TGenReport
    Begin
      ClearTabs;
      SetTab (MarginLeft, pjLeft, 21, 4, 0, 0);
      SetTab (NA, pjLeft, 20, 4, 0, 0);
      SetTab (NA, pjLeft, 42, 4, 0, 0);
      SetTab (NA, pjLeft, 15, 4, 0, 0);
      SetTab (NA, pjLeft, 17, 4, 0, 0);
      SetTab (NA, pjLeft, 17, 4, 0, 0);
      SetTab (NA, pjLeft, 85, 4, 0, 0); 
      SetTab (NA, pjRight, 29, 4, 0, 0);
      SetTab (NA, pjRight, 29, 4, 0, 0);
    end;//end with

    SetTabCount;
  end; // RepSetTabs

procedure TGLHistoryReport.SetupParameterPrinting;
const
  CommitStrings : Array[0..2] of String[27] = ('Show Actuals only', 'Combine Committed & Actuals', 'Show Committed only');
begin
  if Assigned(oPrintParams) then
  begin
    with GLHistorySettings do
    begin
      with oPrintParams.AddParam do
      begin
        Name := 'General Ledger Range';
        Value := FormatGLRange(FromGLCode, ToGLCode);
      end;

      {$IFDEF MC_ON}
      with oPrintParams.AddParam do
      begin
        Name :=  'Report for Currency';
        Value := TxLatePound(CurrDesc(Currency), True);
      end;

      with oPrintParams.AddParam do
      begin
        Name :=  'Translate to Currency';
        Value := TxLatePound(CurrDesc(TranslationCurrency), True);
      end;
      {$ENDIF}

      with oPrintParams.AddParam do
      begin
        Name :=  'Period/Year Range';
        if FilterByDate = true then
          Value := 'N/A'
        else
//          Value := Format('%.2d/%d to %.2d/%d', [IRepParam.RPr, IRepParam.RYr + 1900, IRepParam.RPr2, IRepParam.RYr2 + 1900]);
          Value := Format('%s to %s', [PPR_OutPr(FromPeriod, FromYear), PPR_OutPr(ToPeriod, ToYear)]);
      end;

      with oPrintParams.AddParam do
      begin
        Name :=  'Date Range';
        if FilterByDate = false then
          Value := 'N/A'
        else
          Value := POutDate(FromDate) + ' to ' + POutDate(ToDate);
      end;

      if Syss.UseCCDep then
      begin
        with oPrintParams.AddParam do
        begin
          Name :=  'Cost Centre';
          Value := CostCentreCode;
        end;

        with oPrintParams.AddParam do
        begin
          Name :=  'Department';
          Value := DepartmentCode;
        end;

        with oPrintParams.AddParam do
        begin
          Name :=  'Tag';
          Value := Tag;
        end;
      end; //If UseCCDept

      if CommitAccounting then
      with oPrintParams.AddParam do
      begin
        Name :=  'Committed/Actual';
        Value := CommitStrings[CommitMode];
      end;

      with oPrintParams.AddParam do
      begin
        Name := 'Account No';
        Value := AccountCode;
      end;

      with oPrintParams.AddParam do
      begin
        Name := 'Document Type';
        if (DocumentCode = -99) then
        begin
          Value := '';
        end
        else
        begin
          Value := GetEnumName(TypeInfo(DocTypes), DocumentCode);
        end;//end if
      end;

      bPrintParams := True;
    end;//end with
  end;
end;


function TGLHistoryReport.SQLLoggingArea: String;
begin
  //the string that is inserted in the SQL log file
  Result := 'GLHistoryReportSQL';
end;

end.
