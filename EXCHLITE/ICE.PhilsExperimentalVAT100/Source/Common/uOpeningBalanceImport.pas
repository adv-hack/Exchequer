unit uOpeningBalanceImport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  EntLicence,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass,
  uOpeningBalanceDB,
  uClientLicence,
  uCrossReference
  ;

{$I ice.inc}

type
  TOpeningBalanceImport = class(_ImportBase)
  private
    oTrans: ITransaction3;
    NetValue: Double;
    VATAmount: Double;
    ClientLicence: TClientLicence;
    function WriteDetails(Node: IXMLDOMNode): Boolean;
    function WriteFullDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
    procedure AddLines(oAdd: ITransaction; Node: IXMLDOMNode);
    procedure AddFullLines(oAdd: ITransaction; Node: IXMLDOMNode);
    function RevaluationRequired(Trans: ITransaction): Boolean;
    procedure AddRevaluationTransaction(ForTrans: ITransaction3);
  public
    oToolkit: IToolkit;
    OBCrossRef: TOBCrossReference;
    CrossRef: TCrossReference;
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  Math,
  GlobVar,
  VarConst,
  BtrvU2,
  BtKeys1U,
  ETStrU,
  CTKUtil,
  Dialogs
  ;

const
  VATCodes:       array[1..23] of Char = ('S','E','Z','M','I','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATCodesLessMI: array[1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

  // This array cross-references the TLB Document Type constants with the
  // Enterprise DocTypes constants.  -1 indicates that the COM Toolkit does
  // not support the transaction type
  TKDocTypeVal : Array[DocTypes] of SmallInt =
               //  SIN,   SRC,   SCR,   SJI    SJC,   SRF,   SRI,   SQU,
                  (dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI, dtSQU,
               //  SOR    SDN,   SBT    SDG    NDG    OVT    DEB    PIN,
                   dtSOR, dtSDN, dtSBT, -1,    -1,    -1,    -1,    dtPIN,
               // PPY     PCR    PJI    PJC    PRF    PPI    PQU,   POR,
                  dtPPY,  dtPCR, dtPJI, dtPJC, dtPRF, dtPPI, dtPQU, dtPOR,
               // PDN,    PBT,   SDT,   NDT,   IVT,   CRE,   NOM,   RUN,
                  dtPDN,  dtPBT, -1,    -1,    -1,    -1,    dtNMT, -1,
               // FOL,    AFL,   ADC,   ADJ,   ACQ,   API,   SKF,   JBF,
                  -1,     -1,    -1,    dtADJ, -1,    -1,     -1,    -1,
               // WOR,    TSH,   JRN,   WIN,   SRN,   PRN
                  dtWOR,  dtTSH, -1,    -1,    dtSRN, dtPRN,
               // JCT,    JST,   JPT,   JSA,   JPA
                  dtJCT,  dtJST, dtJPT, dtJSA, dtJPA
                  );

// ===========================================================================
// TOpeningBalanceImport
// ===========================================================================

procedure TOpeningBalanceImport.AddFullLines(oAdd: ITransaction;
  Node: IXMLDOMNode);
var
  LineNode, SubNode: IXMLDOMNode;
  ChildNodes: IXMLDOMNodeList;
  TransLine: ITransactionLine3;
  i: Integer;
begin
  if (Node <> nil) then
  begin
    ChildNodes := Node.selectNodes('//tlrec');
    for i := 0 to ChildNodes.length - 1 do
    begin
      LineNode := ChildNodes.item[i];
      TransLine := oAdd.thLines.Add as ITransactionLine3;

      with TransLine do
      begin
        SubNode := _GetChildNodeByName(LineNode, 'tlasapplication');
        if (tlAsApplication <> nil) and (SubNode <> nil) then
        with tlAsApplication do
        begin
          tplCalculateBeforeRetention := _GetNodeValue(SubNode, 'tplcalculatebeforeretention');
          tplDeductionType   := _GetNodeValue(SubNode, 'tpldeductiontype');
          tplOverrideValue   := _GetNodeValue(SubNode, 'tploverridevalue');
          tplRetentionExpiry := _GetNodeValue(SubNode, 'tplretentionexpiry');
          tplRetentionType   := _GetNodeValue(SubNode, 'tplretentiontype');
        end;

        SubNode := _GetChildNodeByName(LineNode, 'tlasnom');
        if (tlAsNOM <> nil) and (SubNode <> nil) then
        with tlAsNOM as ITransactionLineAsNOM2 do
        begin
          tlnNomVatType := _GetNodeValue(SubNode, 'tlnnomvattype');
        end;

        TransLine.tlBOMKitLink         := _GetNodeValue(LineNode, 'tlbomkitlink');
        TransLine.tlChargeCurrency     := _GetNodeValue(LineNode, 'tlchargecurrency');
        TransLine.tlCISRate            := _GetNodeValue(LineNode, 'tlcisrate');
        TransLine.tlCISRateCode        := _GetNodeValue(LineNode, 'tlcisratecode');
        TransLine.tlCompanyRate        := _GetNodeValue(LineNode, 'tlcompanyrate');
        TransLine.tlCost               := _GetNodeValue(LineNode, 'tlcost');
        TransLine.tlCostApport         := _GetNodeValue(LineNode, 'tlcostapport');
        TransLine.tlCostCentre         := _GetNodeValue(LineNode, 'tlcostcentre');

        { If importing into a Practice system, and the Client system is single
          currency, force the currency to 1. }
        if (EnterpriseLicence.elProductType = ptLITEAcct) and
           (not ClientLicence.elIsMultiCcy) then
          TransLine.tlCurrency         := 1
        else
          TransLine.tlCurrency         := _GetNodeValue(LineNode, 'tlcurrency');

        TransLine.tlDailyRate          := _GetNodeValue(LineNode, 'tldailyrate');
        TransLine.tlDepartment         := _GetNodeValue(LineNode, 'tldepartment');
        TransLine.tlDescr              := _GetNodeValue(LineNode, 'tldescr');
        TransLine.tlDiscFlag           := _GetNodeValue(LineNode, 'tldiscflag');
        TransLine.tlDiscount           := _GetNodeValue(LineNode, 'tldiscount');
        TransLine.tlGLCode             := _GetNodeValue(LineNode, 'tlglcode');
        TransLine.tlInclusiveVATCode   := _GetNodeValue(LineNode, 'tlinclusivevatcode');
        TransLine.tlItemNo             := _GetNodeValue(LineNode, 'tlitemno');
        TransLine.tlJobCode            := _GetNodeValue(LineNode, 'tljobcode');
        TransLine.tlLineDate           := _GetNodeValue(LineNode, 'tllinedate');
        TransLine.tlLineNo             := _GetNodeValue(LineNode, 'tllineno');
        TransLine.tlLineType           := _GetNodeValue(LineNode, 'tllinetype');
        TransLine.tlLocation           := _GetNodeValue(LineNode, 'tllocation');
        TransLine.tlNetValue           := _GetNodeValue(LineNode, 'tlnetvalue');
        TransLine.tlPayment            := _GetNodeValue(LineNode, 'tlpayment');
        TransLine.tlPeriod             := _GetNodeValue(LineNode, 'tlperiod');
        TransLine.tlPriceMultiplier    := _GetNodeValue(LineNode, 'tlpricemultiplier');
        TransLine.tlQty                := _GetNodeValue(LineNode, 'tlqty');
        TransLine.tlQtyDel             := _GetNodeValue(LineNode, 'tlqtydel');
        TransLine.tlQtyMul             := _GetNodeValue(LineNode, 'tlqtymul');
        TransLine.tlQtyPicked          := _GetNodeValue(LineNode, 'tlqtypicked');
        TransLine.tlQtyPickedWO        := _GetNodeValue(LineNode, 'tlqtypickedwo');
        TransLine.tlQtyWOFF            := _GetNodeValue(LineNode, 'tlqtywoff');
        TransLine.tlRecStatus          := _GetNodeValue(LineNode, 'tlrecstatus');
        TransLine.tlSOPABSLineNo       := _GetNodeValue(LineNode, 'tlsopabslineno');
        TransLine.tlSOPFolioNum        := _GetNodeValue(LineNode, 'tlsopfolionum');
        TransLine.tlSSDCommodCode      := _GetNodeValue(LineNode, 'tlssdcommodcode');
        TransLine.tlSSDCountry         := _GetNodeValue(LineNode, 'tlssdcountry');
        TransLine.tlSSDSalesUnit       := _GetNodeValue(LineNode, 'tlssdsalesunit');
        TransLine.tlSSDUpliftPerc      := _GetNodeValue(LineNode, 'tlssdupliftperc');
        TransLine.tlSSDUseLineValues   := _GetNodeValue(LineNode, 'tlssduselinevalues');
        TransLine.tlStockCode          := _GetNodeValue(LineNode, 'tlstockcode');
        TransLine.tlUnitWeight         := _GetNodeValue(LineNode, 'tlunitweight');
        TransLine.tlUserField1         := _GetNodeValue(LineNode, 'tluserfield1');
        TransLine.tlUserField2         := _GetNodeValue(LineNode, 'tluserfield2');
        TransLine.tlUserField3         := _GetNodeValue(LineNode, 'tluserfield3');
        TransLine.tlUserField4         := _GetNodeValue(LineNode, 'tluserfield4');
        TransLine.tlVATAmount          := _GetNodeValue(LineNode, 'tlvatamount');
        TransLine.tlVATCode            := _GetNodeValue(LineNode, 'tlvatcode');
        TransLine.tlVATIncValue        := _GetNodeValue(LineNode, 'tlvatincvalue');
        TransLine.tlYear               := _GetNodeValue(LineNode, 'tlyear');
      end;

      { These fields are read-only in the standard toolkit, so we need to use
        the back-door interface to be able to write to them. }
      with TransLine as IBetaTransactionLine do
      begin
        tlABSLineNo          := _GetNodeValue(LineNode, 'tlabslineno');
        tlB2BLineNo          := _GetNodeValue(LineNode, 'tlb2blineno');
        tlB2BLinkFolio       := _GetNodeValue(LineNode, 'tlb2blinkfolio');
        tlBinQty             := _GetNodeValue(LineNode, 'tlbinqty');
        tlCOSDailyRate       := _GetNodeValue(LineNode, 'tlcosdailyrate');
        tlNominalMode        := _GetNodeValue(LineNode, 'tlnominalmode');
        tlQtyPack            := _GetNodeValue(LineNode, 'tlqtypack');
        tlReconciliationDate := _GetNodeValue(LineNode, 'tlreconciliationdate');
        tlStockDeductQty     := _GetNodeValue(LineNode, 'tlstockdeductqty');
        tlUseQtyMul          := _GetNodeValue(LineNode, 'tluseqtymul');
      end;

      TransLine.Save;
      TransLine := nil;
    end;
  end;
end;

// ---------------------------------------------------------------------------

procedure TOpeningBalanceImport.AddLines(oAdd: ITransaction; Node: IXMLDOMNode);
var
  LineNode: IXMLDOMNode;
  ChildNodes: IXMLDOMNodeList;
  TransLine: ITransactionLine3;
  i: Integer;
begin
  NetValue  := 0.00;
  VATAmount := 0.00;
  if (Node <> nil) then
  begin
    ChildNodes := Node.selectNodes('//tlrec');
    for i := 0 to ChildNodes.length - 1 do
    begin
      LineNode := ChildNodes.item[i];
      TransLine := oAdd.thLines.Add as ITransactionLine3;

      with TransLine do
      begin
        TransLine.tlCostCentre         := _GetNodeValue(LineNode, 'tlcostcentre');
        { If importing into a Practice system, and the Client system is single
          currency, force the currency to 1. }
        if (EnterpriseLicence.elProductType = ptLITEAcct) and
           (not ClientLicence.elIsMultiCcy) then
        begin
          TransLine.tlCurrency         := 1;
          TransLine.tlDailyRate        := 1.0;
          TransLine.tlCompanyRate      := 1.0;
        end
        else
        begin
          TransLine.tlCurrency         := _GetNodeValue(LineNode, 'tlcurrency');
          TransLine.tlDailyRate        := _GetNodeValue(LineNode, 'tldailyrate');
          TransLine.tlCompanyRate      := _GetNodeValue(LineNode, 'tlcompanyrate');
        end;
        TransLine.tlDepartment         := _GetNodeValue(LineNode, 'tldepartment');
        TransLine.tlDescr              := _GetNodeValue(LineNode, 'tldescr');
        TransLine.tlGLCode             := _GetNodeValue(LineNode, 'tlglcode');
        TransLine.tlNetValue           := _GetNodeValue(LineNode, 'tlnetvalue');
        TransLine.tlPeriod             := _GetNodeValue(LineNode, 'tlperiod');
        TransLine.tlQty                := 1;
        TransLine.tlVATAmount          := _GetNodeValue(LineNode, 'tlvatamount');
        if (oAdd.thDocType = dtNMT) and (TransLine.tlVATAmount <> 0.00) then
          (TransLine.tlAsNOM as ITransactionLineAsNom2).tlnNomVatType := nlvManual;
        TransLine.tlVATCode            := _GetNodeValue(LineNode, 'tlvatcode');
        TransLine.tlYear               := _GetNodeValue(LineNode, 'tlyear');
        if (_GetNodeValue(LineNode, 'tlPaymentMode') = 'P') then
          TransLine.tlPayment := True;
      end;
      with TransLine as IBetaTransactionLine do
      begin
        tlABSLineNo := i + 1;
      end;

      if (TransLine.tlGLCode <> oToolkit.SystemSetup.ssGLCtrlCodes[ssGLCurrencyVariance]) then
      begin
        NetValue  := NetValue + TransLine.tlNetValue;
        VATAmount := VATAmount + TransLine.tlVATAmount;
      end;

      TransLine.Save;
      TransLine := nil;
    end;
  end;
end;

// ---------------------------------------------------------------------------

procedure TOpeningBalanceImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  ErrorCode: LongInt;
  ErrorMsg: string;
//  oConfig: IConfiguration;
begin
  ErrorCode := 0;

  if not isFileOpen then
  begin
    ErrorCode := 0;
    oTrans := oToolkit.Transaction as ITransaction3;
    if Assigned(oTrans) then
      isFileOpen := True
    else
    begin
      ErrorCode := cCONNECTINGDBERROR;
      ErrorMsg  := 'Cannot connect to Toolkit';
    end;
    { Open the Document Numbers file as well. }
    SetDrive := DataPath;
    if Assigned(ClientLicence) then
      ClientLicence.Free;
    ClientLicence := TClientLicence.Create;
    { Open the Opening Balance Cross-Reference file }
    ErrorCode := Open_File(F[OBRefF], DataPath + FileNames[OBRefF], 0);
    if ErrorCode = 0 then
    begin
      { Open the OurRef Cross-Reference file }
      CrossRef := TCrossReference.Create(DataPath);
      ErrorCode := CrossRef.ErrorCode;
      ErrorMsg  := CrossRef.ErrorMsg;
    end;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TOpeningBalanceImport.AddRecord: ' + ErrorMsg, ErrorCode);
end;

// ---------------------------------------------------------------------------

procedure TOpeningBalanceImport.AddRevaluationTransaction(
  ForTrans: ITransaction3);
{ Adds a revaluation transaction as an adjustment for the supplied
  transaction (which is assumed to be a transaction which has been revalued). }

  function IsSales: Boolean;
  var
    Ref: string;
  begin
    Ref := Uppercase(Copy(ForTrans.thOurRef, 1, 3));
    Result := (Pos(Ref, 'SIN') <> 0);
  end;

  function ControlAccount(AcCode: string): Integer;
  begin
    if IsSales then
    begin
      Result := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLDebtors];
      if oToolkit.Customer.GetEqual(AcCode) = 0 then
        if (oToolkit.Customer.acDrCrGL <> 0) then
          Result := oToolkit.Customer.acDrCrGL;
    end
    else
    begin
      Result := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLCreditors];
      if oToolkit.Supplier.GetEqual(AcCode) = 0 then
        if (oToolkit.Supplier.acDrCrGL <> 0) then
          Result := oToolkit.Supplier.acDrCrGL;
    end;
  end;

var
  oAdd: ITransaction3;
  oNewTrans: ITransaction3;
  oAddNote: INotes;
  FuncRes: Integer;
begin
  oAdd := oTrans.Add(TKDocTypeVal[NMT]) as ITransaction3;

  try
    with oAdd as IBetaTransaction do
      thAllowCtrlCodes := True;
  except
    on E:Exception do
    begin
      DoLogMessage('TOpeningBalanceImport.WriteDetails: failed to initialise ' +
                   'a new record, possibly because the wrong version of the ' +
                   'Toolkit is installed.',
                   cUPDATINGDBERROR,
                   'Error: ' + E.Message);
    end;
  end;

  oAdd.thAcCode   := ForTrans.thAcCode;
  oAdd.thCurrency := 0;
  oAdd.thPeriod   := ForTrans.thPeriod;
  oAdd.thYear     := ForTrans.thYear;
  oAdd.thYourRef  := ForTrans.thOurRef;
  oAdd.thLongYourRef := ForTrans.thOurRef + ' - Auto-Variance';

  if IsSales then
  begin
    { Credit line }
    with oAdd.thLines.Add as ITransactionLine2 do
    begin
      tlAsNOM.tlnGLCode := ControlAccount(oAdd.thAcCode);
      tlCurrency    := 0;
      tlNetValue    := Abs((ForTrans as IBetaTransaction).thRevalueAdj) * -1.0;
      tlCostCentre  := ForTrans.thLines[1].tlCostCentre;
      tlDepartment  := ForTrans.thLines[1].tlDepartment;
      tlCompanyRate := 1.0;
      tlDailyRate   := 1.0;
      tlDescr       := ForTrans.thOurRef + ' - Auto-Variance';
      tlVATCode     := ForTrans.thLines[1].tlVATCode;
      Save;
    end;
    { Debit line }
    with oAdd.thLines.Add as ITransactionLine2 do
    begin
      tlAsNOM.tlnGLCode := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLUnrealisedCurrencyDifference];
      tlCurrency    := 0;
      tlNetValue    := Abs((ForTrans as IBetaTransaction).thRevalueAdj);
      tlCostCentre  := ForTrans.thLines[1].tlCostCentre;
      tlDepartment  := ForTrans.thLines[1].tlDepartment;
      tlCompanyRate := 1.0;
      tlDailyRate   := 1.0;
      tlDescr       := ForTrans.thOurRef + ' - Auto-Variance';
      tlVATCode     := ForTrans.thLines[1].tlVATCode;
      Save;
    end;
  end
  else
  begin
    { Credit line }
    with oAdd.thLines.Add as ITransactionLine2 do
    begin
      tlAsNOM.tlnGLCode := ControlAccount(oAdd.thAcCode);
      tlCurrency    := 0;
      tlNetValue    := Abs((ForTrans as IBetaTransaction).thRevalueAdj) * -1.0;
      tlCostCentre  := ForTrans.thLines[1].tlCostCentre;
      tlDepartment  := ForTrans.thLines[1].tlDepartment;
      tlCompanyRate := 1.0;
      tlDailyRate   := 1.0;
      tlDescr       := ForTrans.thOurRef + ' - Auto-Variance';
      tlVATCode     := ForTrans.thLines[1].tlVATCode;
      Save;
    end;
    { Debit line }
    with oAdd.thLines.Add as ITransactionLine2 do
    begin
      tlAsNOM.tlnGLCode := oToolkit.SystemSetup.ssGLCtrlCodes[ssGLUnrealisedCurrencyDifference];
      tlCurrency    := 0;
      tlNetValue    := Abs((ForTrans as IBetaTransaction).thRevalueAdj);
      tlCostCentre  := ForTrans.thLines[1].tlCostCentre;
      tlDepartment  := ForTrans.thLines[1].tlDepartment;
      tlCompanyRate := 1.0;
      tlDailyRate   := 1.0;
      tlDescr       := ForTrans.thOurRef + ' - Auto-Variance';
      tlVATCode     := ForTrans.thLines[1].tlVATCode;
      Save;
    end;
  end;

  FuncRes := oAdd.Save(True);
  if (FuncRes <> 0) then
  begin
    DoLogMessage('TOpeningBalanceImport.AddRevaluationTransaction: failed to save transaction ' + oAdd.thOurRef +
                 ' Line no ' + IntToStr(oAdd.SaveErrorLine) +
                 ' Account ' + Trim(oAdd.thAcCode) +
                 ' Net value ' + FloatToStr(oAdd.thNetValue),
                 cUPDATINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
  end
  else
  begin
    oToolkit.Transaction.SavePosition;
    try
      oNewTrans := oToolkit.Transaction as ITransaction3;
      oNewTrans.Index := thIdxOurRef;
      if (oNewTrans.GetEqual(oAdd.thOurRef) = 0) then
      begin
        with oNewTrans.thNotes.Add do
        begin
          ntText := 'Manufactured journal in support of currency variance';
          ntType := ntTypeGeneral;
          ntOperator := 'CS-CLIENT';
          ntLineNo := 1;
          FuncRes := Save;
          if (FuncRes <> 0) then
            DoLogMessage('TOpeningBalanceImport.AddRevaluationTransaction: failed to save note for transaction ' + oNewTrans.thOurRef,
                         cUPDATINGDBERROR,
                         'Error: ' + IntToStr(FuncRes));
        end;
      end
      else
        DoLogMessage('TOpeningBalanceImport.AddRevaluationTransaction: failed to re-locate transaction ' + oNewTrans.thOurRef,
                     cUPDATINGDBERROR,
                     'Error: ' + IntToStr(FuncRes));
    finally
      oToolkit.Transaction.RestorePosition;
    end;
  end;
end;

constructor TOpeningBalanceImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TOpeningBalanceImport.Destroy;
begin
  OBCrossRef := nil;
  oToolkit := nil;
  oTrans := nil;
  if Assigned(ClientLicence) then
    ClientLicence.Free;
  CrossRef.Free;
  inherited;
end;

// ---------------------------------------------------------------------------

function TOpeningBalanceImport.RevaluationRequired(
  Trans: ITransaction): Boolean;
{ Determines whether or not a revaluation transaction needs to be added to
  as an adjustment for the supplied transaction }
begin
  Result := (not SameValue((Trans as IBetaTransaction).thRevalueAdj, 0.0));
end;

function TOpeningBalanceImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TOpeningBalanceImport.WriteDetails(Node: IXMLDOMNode): Boolean;

  function NextOurRef(OurRef: Str10): Str10;
  var
    RefNo: Integer;
  begin
    Result := Copy(OurRef, 1, 3);
    RefNo := StrToIntDef(Copy(OurRef, 4, 6), 0) + 1;
    if (RefNo = 0) then
      { Not a valid number. Abort. }
      Result := ''
    else
      Result := Result + RightJustify(IntToStr(RefNo), '0', 6);
  end;

  procedure AssignNextDocumentRef(oAdd: ITransaction3);
  var
    Key: Str255;
    FuncRes: LongInt;
  begin
    oAdd.AllocateTransNo;
    { Make sure this reference does not already exist. }
    oTrans.Index := thIdxOurRef;
    repeat
      Key := oTrans.BuildOurRefIndex(oAdd.thOurRef);
      FuncRes := oTrans.GetEqual(Key);
      if (FuncRes = 0) then
        { OurRef already exists. Increment, and search again. }
        oAdd.thOurRef := NextOurRef(oAdd.thOurRef);
    until (FuncRes <> 0);
  end;

var
  FuncRes: LongInt;
  oAdd: ITransaction3;
  DocType: DocTypes;
begin

  if _GetNodeValue(Node, 'thunallocated') then
  begin
    Result := WriteFullDetails(Node);
    Exit;
  end;

  DocType := DocTypes(_GetNodeValue(Node, 'thdoctype'));

  if TKDocTypeVal[DocType] = -1 then
  begin
    DoLogMessage('TOpeningBalanceImport.WriteDetails: Doc Type value of ' +
                 IntToStr(Ord(DocType)) +
                 ' not valid for the Toolkit. ',
                 cUPDATINGDBERROR);
    Result := False;
    Exit;
  end;

  oAdd := oTrans.Add(TKDocTypeVal[DocType]) as ITransaction3;
  try
    with oAdd as IBetaTransaction do
      thAllowCtrlCodes := True;
  except
    on E:Exception do
    begin
      DoLogMessage('TOpeningBalanceImport.WriteDetails: failed to initialise ' +
                   'a new record, possibly because the wrong version of the ' +
                   'Toolkit is installed.',
                   cUPDATINGDBERROR,
                   'Error: ' + E.Message);
    end;
  end;
  try

    oAdd.thAcCode      := _GetNodeValue(Node, 'thaccode');
    oAdd.thControlGL   := _GetNodeValue(Node, 'thcontrolgl');

    { If importing into a Practice system, and the Client system is single
      currency, force the currency to 1. }
    if (EnterpriseLicence.elProductType = ptLITEAcct) and
       (not ClientLicence.elIsMultiCcy) then
      oAdd.thCurrency  := 1
    else
      oAdd.thCurrency  := _GetNodeValue(Node, 'thcurrency');

    oAdd.thDueDate     := _GetNodeValue(Node, 'thduedate');
    oAdd.thManualVAT   := _GetNodeValue(Node, 'thmanualvat');
    oAdd.thOperator    := _GetNodeValue(Node, 'thoperator');
    oAdd.thPeriod      := _GetNodeValue(Node, 'thperiod');
    oAdd.thTransDate   := _GetNodeValue(Node, 'thtransdate');
    oAdd.thYear        := _GetNodeValue(Node, 'thyear');

    if (_GetNodeValue(Node, 'thcompanyrate') <> 0) then
      oAdd.thCompanyRate := _GetNodeValue(Node, 'thcompanyrate');

    if (_GetNodeValue(Node, 'thdailyrate') <> 0) then
      oAdd.thDailyRate   := _GetNodeValue(Node, 'thdailyrate');

    oAdd.thHoldFlag    := 0;
    oAdd.thProcess     := ipNormal;

    AddLines(oAdd, _GetChildNodeByName(Node, 'tlrec'));

    { If this is a NOM transaction, and VAT is positive, this is Input VAT. If
      VAT is negative, it is Output VAT. The Net Value will be the inverse of
      the VAT. }
    if DocType = NMT then
    begin
      with oAdd.thAsNOM as ITransactionAsNom2 do
      begin
        tnVatIO := _GetNodeValue(Node, 'thvatio');
{
        if (VATAmount = 0.00) then
          tnVatIO := vioNA
        else if (VATAmount < 0.00) then
          tnVatIO := vioOutput
        else
          tnVatIO := vioInput;
}          
        tnDescription := 'Opening Balance';
      end;
      if (VATAmount <> 0) then
        oAdd.thNetValue := VATAmount * -1.00
      else
        oAdd.thNetValue := 0.00;
      oAdd.thTotalVAT := VATAmount;
    end
    else
    begin
      oAdd.thNetValue := NetValue;
      oAdd.thTotalVAT := VATAmount;
    end;

    oAdd.thVATAnalysis['S']  := VATAmount;

    { These fields are read-only in the standard toolkit, so we need to use
      the back-door interface to be able to write to them. }
    with oAdd as IBetaTransaction do
    begin
      thTotalReserved  := _GetNodeValue(Node, 'thtotalreserved');
      thTotalInvoiced  := _GetNodeValue(Node, 'thtotalinvoiced');
      thVariance       := _GetNodeValue(Node, 'thvariance');
      thTotalOrdered   := _GetNodeValue(Node, 'thtotalordered');
      thReValueAdj     := _GetNodeValue(Node, 'threvalueadj');
    end;

    { Save the transaction. }
    AssignNextDocumentRef(oAdd);
    if (DocType in [PPI, SRI]) then
      FuncRes := oAdd.Save(True)
    else if (DocType = NMT) then
      FuncRes := oAdd.Save(False)
    else
      FuncRes := oAdd.Save(False);

    if (FuncRes <> 0) and (FuncRes <> 5) then
    begin
      DoLogMessage('TOpeningBalanceImport.WriteDetails: failed to save transaction ' + oAdd.thOurRef +
                   ' Line no ' + IntToStr(oAdd.SaveErrorLine) +
                   ' Account ' + Trim(oAdd.thAcCode) +
                   ' Net value ' + FloatToStr(oAdd.thNetValue),
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end
    else
    begin
      OBCrossRef.Add(_GetNodeValue(Node, 'thobalcode'), oAdd.thOurRef);
      Result := True;
    end;

  finally
    oAdd := nil;
  end;
end;

// ---------------------------------------------------------------------------

function TOpeningBalanceImport.WriteFullDetails(
  Node: IXMLDOMNode): Boolean;

  function IsPaymentOrReceipt(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'PPY') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SRC');
  end;

  function IsInvoice(Ref: string): Boolean;
  begin
    Result := (Uppercase(Copy(Ref, 1, 3)) = 'SIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'PIN') or
              (Uppercase(Copy(Ref, 1, 3)) = 'ADJ') or
              (Uppercase(Copy(Ref, 1, 3)) = 'SCR') or
              (Uppercase(Copy(Ref, 1, 3)) = 'PDN');
  end;

  function ExtractDocumentNumber(Ref: string): Integer;
  var
    NumberRef: string;
  begin
    { Extract the numeric part of the document number. }
    NumberRef := Copy(Ref, 3, Length(Ref));
    { Convert it to an actual number and return the result. }
    Result := StrToIntDef(NumberRef, 0);
  end;

  function UpdateDocumentNumber(Ref: string; DocNumber: Integer): Integer;
  var
    Key: ShortString;
    FuncRes: Integer;
  begin
    Key := Copy(Ref, 1, 3);
    FuncRes := Find_Rec(B_GetEq, F[IncF], IncF, RecPtr[IncF]^, 0, Key);
    if (FuncRes = 0) then
    begin
      { Copy the current 'next document number' into Result, to return it. }
      Move(Count.NextCount[1], Result, Sizeof(Result));
      { Copy the new document number into 'next document number'... }
      Move(DocNumber, Count.NextCount[1], Length(Count.NextCount));
      { ...and save the record. }
      Put_Rec(F[IncF], IncF, RecPtr[IncF]^, 0);
    end
    else
      Result := 0;
  end;

var
  FuncRes: LongInt;
  oAdd: ITransaction3;
  DocType: Integer;
  SubNode: IXMLDOMNode;
  i: Integer;
  VATCode: string;
  DocCode: ShortString;
  RunStr: string;
  RunNo: Integer;
  DocNumber, OldDocNumber: Integer;
  OldOurRef: string;
begin
  DocType := _GetNodeValue(Node, 'thdoctype');
  RunNo   := _GetNodeValue(Node, 'thrunno');
//  Trace('Our Ref: ' + _GetNodeValue(Node, 'thourref'));
  oAdd := oTrans.Add(DocType) as ITransaction3;
  try

    with oAdd as IBetaTransaction do
      thAllowCtrlCodes := True;

    oAdd.thOurRef            := _GetNodeValue(Node, 'thourref');
    oAdd.thYourRef           := _GetNodeValue(Node, 'thyourref');
    oAdd.thAcCode            := _GetNodeValue(Node, 'thaccode');
    oAdd.thFolioNum          := _GetNodeValue(Node, 'thfolionum');

    { If importing into a Practice system, and the Client system is single
      currency, force the currency to 1. }
    if (EnterpriseLicence.elProductType = ptLITEAcct) and
       (not ClientLicence.elIsMultiCcy) then
      oAdd.thCurrency        := 1
    else
      oAdd.thCurrency        := _GetNodeValue(Node, 'thcurrency');

    oAdd.thYear              := _GetNodeValue(Node, 'thyear');
    oAdd.thPeriod            := _GetNodeValue(Node, 'thperiod');
    oAdd.thTransDate         := _GetNodeValue(Node, 'thtransdate');
    oAdd.thDueDate           := _GetNodeValue(Node, 'thduedate');
    oAdd.thCompanyRate       := _GetNodeValue(Node, 'thcompanyrate');
    oAdd.thDailyRate         := _GetNodeValue(Node, 'thdailyrate');
    oAdd.thNetValue          := _GetNodeValue(Node, 'thnetvalue');
    oAdd.thTotalVAT          := _GetNodeValue(Node, 'thtotalvat');
    oAdd.thSettleDiscPerc    := _GetNodeValue(Node, 'thsettlediscperc');
    oAdd.thSettleDiscAmount  := _GetNodeValue(Node, 'thsettlediscamount');
    oAdd.thTotalLineDiscount := _GetNodeValue(Node, 'thtotallinediscount');
    oAdd.thSettleDiscDays    := _GetNodeValue(Node, 'thsettlediscdays');
    oAdd.thSettleDiscTaken   := _GetNodeValue(Node, 'thsettledisctaken');
    oAdd.thTransportNature   := _GetNodeValue(Node, 'thtransportnature');
    oAdd.thTransportMode     := _GetNodeValue(Node, 'thtransportmode');
    oAdd.thHoldFlag          := _GetNodeValue(Node, 'thholdflag');
    oAdd.thTotalWeight       := _GetNodeValue(Node, 'thtotalweight');
    oAdd.thTotalCost         := _GetNodeValue(Node, 'thtotalcost');
    oAdd.thManualVAT         := _GetNodeValue(Node, 'thmanualvat');
    oAdd.thDeliveryTerms     := _GetNodeValue(Node, 'thdeliveryterms');
    oAdd.thOperator          := _GetNodeValue(Node, 'thoperator');
    oAdd.thJobCode           := _GetNodeValue(Node, 'thjobcode');
    oAdd.thTotalOrderOS      := _GetNodeValue(Node, 'thtotalorderos');
    oAdd.thUserField1        := _GetNodeValue(Node, 'thuserfield1');
    oAdd.thUserField2        := _GetNodeValue(Node, 'thuserfield2');
    oAdd.thUserField3        := _GetNodeValue(Node, 'thuserfield3');
    oAdd.thUserField4        := _GetNodeValue(Node, 'thuserfield4');
    oAdd.thTagged            := _GetNodeValue(Node, 'thtagged');
    oAdd.thNoLabels          := _GetNodeValue(Node, 'thnolabels');
    oAdd.thControlGL         := _GetNodeValue(Node, 'thcontrolgl');
    if (trim(_GetNodeValue(Node, 'thprocess')) <> '') then
      oAdd.thProcess           := _GetNodeValue(Node, 'thprocess')
    else
      oAdd.thProcess         := ipNormal;
    oAdd.thPORPickSOR        := _GetNodeValue(Node, 'thporpicksor');
    oAdd.thBatchDiscAmount   := _GetNodeValue(Node, 'thbatchdiscamount');
    oAdd.thPrePost           := _GetNodeValue(Node, 'thprepost');
    oAdd.thFixedRate         := _GetNodeValue(Node, 'thfixedrate');
    oAdd.thLongYourRef       := _GetNodeValue(Node, 'thlongyourref');
    oAdd.thEmployeeCode      := _GetNodeValue(Node, 'themployeecode');

    SubNode := _GetChildNodeByName(Node, 'thvatanalysis');
    if (SubNode <> nil) then
    begin
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        VATCode := _GetNodeValue(SubNode.childNodes.item[i], 'tvacode');
        oAdd.thVATAnalysis[VATCode[1]] := _GetNodeValue(SubNode.childNodes.item[i], 'tvavalue');
      end;
    end;

    SubNode := _GetChildNodeByName(Node, 'thdeladdress');
    if (oAdd.thDelAddress <> nil) and (SubNode <> nil) then
    with oAdd.thDelAddress do
    begin
      Street1                := _GetNodeValue(SubNode, 'street1');
      Street2                := _GetNodeValue(SubNode, 'street2');
      Town                   := _GetNodeValue(SubNode, 'town');
      County                 := _GetNodeValue(SubNode, 'county');
      PostCode               := _GetNodeValue(SubNode, 'postcode');
    end;

    SubNode := _GetChildNodeByName(Node, 'thasbatch');
    if (oAdd.thAsBatch <> nil) and (SubNode <> nil) then
    with oAdd.thAsBatch do
    begin
      btBankGL               := _GetNodeValue(SubNode, 'btbankgl');
      btChequeNoStart        := _GetNodeValue(SubNode, 'btchequenostart');
    end;

    SubNode := _GetChildNodeByName(Node, 'thasnom');
    if (oAdd.thAsNOM <> nil) and (SubNode <> nil) then
    with oAdd.thAsNOM as ITransactionAsNOM2 do
    begin
      tnAutoReversing        := _GetNodeValue(SubNode, 'tnautoreversing');
      tnVatIO                := _GetNodeValue(SubNode, 'tnvatio');
    end;

    SubNode := _GetChildNodeByName(Node, 'thautosettings');
    if (oAdd.thAutoSettings <> nil) and (SubNode <> nil) then
    with oAdd.thAutoSettings do
    begin
      atAutoCreateOnPost     := _GetNodeValue(SubNode, 'atautocreateonpost');
      atEndDate              := _GetNodeValue(SubNode, 'atenddate');
      atEndPeriod            := _GetNodeValue(SubNode, 'atendperiod');
      atEndYear              := _GetNodeValue(SubNode, 'atendyear');
      atIncrement            := _GetNodeValue(SubNode, 'atincrement');
      atIncrementType        := _GetNodeValue(SubNode, 'atincrementtype');
      atStartDate            := _GetNodeValue(SubNode, 'atstartdate');
      atStartPeriod          := _GetNodeValue(SubNode, 'atstartperiod');
      atStartYear            := _GetNodeValue(SubNode, 'atstartyear');
    end;

    { These fields are read-only in the standard toolkit, so we need to use
      the back-door interface to be able to write to them. }

    with oAdd as IBetaTransaction do
    begin
      DocCode := Copy(oAdd.thOurRef, 1, 3);
      RunStr  := Trim(_GetNodeValue(Node, 'thdeliveryrunno'));
      if (RunStr <> '') and IsPaymentOrReceipt(oAdd.thOurRef) then
      begin
        thDeliveryRunNo := DocCode +
                           FullNomKey(StrToInt(RunStr));
      end
      else if (RunStr <> '') and IsInvoice(oAdd.thOurRef) then
      begin
        thDeliveryRunNo := FullNomKey(StrToInt(RunStr)) +
                           DocCode;
      end
      else
        thDeliveryRunNo := RunStr;
      thSource         := _GetNodeValue(Node, 'thsource');
      thOutstanding    := _GetNodeValue(Node, 'thoutstanding');
      thOrdMatch       := _GetNodeValue(Node, 'thordmatch');
      thTotalReserved  := _GetNodeValue(Node, 'thtotalreserved');
      thTotalInvoiced  := _GetNodeValue(Node, 'thtotalinvoiced');
      thPostDiscAmount := _GetNodeValue(Node, 'thpostdiscamount');
      thVariance       := _GetNodeValue(Node, 'thvariance');
      thTotalOrdered   := _GetNodeValue(Node, 'thtotalordered');
      thReValueAdj     := _GetNodeValue(Node, 'threvalueadj');
      thZeroLineNos    := True;
    end;

    AddFullLines(oAdd, _GetChildNodeByName(Node, 'tlrec'));

    { Extract the document number from thOurRef. }
    OldOurRef := oAdd.thOurRef;
    DocNumber := ExtractDocumentNumber(oAdd.thOurRef);

    { Update Document Numbers with this document number, storing the original
      value. }
    OldDocNumber := UpdateDocumentNumber(oAdd.thOurRef, DocNumber);

    { Save the transaction. }
    FuncRes := oAdd.Save(False);
    if (FuncRes = 5) then
    begin
      oAdd.AllocateTransNo;
      FuncRes := oAdd.Save(False);
    end;

    { Replace the original Document Number value. }
    UpdateDocumentNumber(oAdd.thOurRef, OldDocNumber);

    if (OldOurRef <> oAdd.thOurRef) then
    begin
      { If the OurRef values are not the same, the transaction could not be
        stored against the incoming OurRef (presumably because a transaction
        already exists against that reference). Record this fact. }
      DoLogMessage('TTransaction.Import.WriteFullDetails: document OurRef ' +
                   OldOurRef + ' had to be stored as ' + oAdd.thOurRef,
                   0);
      CrossRef.Add(OldOurRef, oAdd.thOurRef);
    end;

    if (FuncRes <> 0) and (FuncRes <> 5) then
    begin
      DoLogMessage('TTransactionImport.WriteFullDetails: failed to save transaction ' + oAdd.thOurRef +
                   ' Line no ' + IntToStr(oAdd.SaveErrorLine),
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end
    else
    begin
      OBCrossRef.Add(oAdd.thOurRef, oAdd.thOurRef);
{
      if (RunNo <> 0) and RevaluationRequired(oAdd) then
        AddRevaluationTransaction(oAdd);
}        
      Result := True;
    end;
  finally
    oAdd := nil;
  end;
end;

// ---------------------------------------------------------------------------

end.
