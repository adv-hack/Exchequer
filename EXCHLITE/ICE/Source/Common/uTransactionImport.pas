unit uTransactionImport;

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
  uClientLicence
  ;

{$I ice.inc}

type
  TTransactionImport = class(_ImportBase)
  private
    oTrans: ITransaction3;
    ClientLicence: TClientLicence;
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
    procedure AddLines(oAdd: ITransaction; Node: IXMLDOMNode);
  public
    oToolkit: IToolkit;
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
  end;

implementation

uses
  GlobVar,
  VarConst,
  BtrvU2,
  BtKeys1U,
  ETStrU,
  CTKUtil
  ;

const
  VATCodes:       array[1..23] of Char = ('S','E','Z','M','I','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATCodesLessMI: array[1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');

// ===========================================================================
// TTransactionImport
// ===========================================================================

procedure TTransactionImport.AddLines(oAdd: ITransaction; Node: IXMLDOMNode);
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
  //    TransLine.tlAcCode       := _GetNodeValue(LineNode, 'tlaccode');
  //    TransLine.tlAnalysisCode := _GetNodeValue(LineNode, 'tlanalysiscode');

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
  //    TransLine.tlDocType            := _GetNodeValue(LineNode, 'tldoctype');
  //    TransLine.tlFolioNum           := _GetNodeValue(LineNode, 'tlfolionum');
        TransLine.tlGLCode             := _GetNodeValue(LineNode, 'tlglcode');
        TransLine.tlInclusiveVATCode   := _GetNodeValue(LineNode, 'tlinclusivevatcode');
        TransLine.tlItemNo             := _GetNodeValue(LineNode, 'tlitemno');
        TransLine.tlJobCode            := _GetNodeValue(LineNode, 'tljobcode');
  //    TransLine.tlLineClass          := _GetNodeValue(LineNode, 'tllineclass');
        TransLine.tlLineDate           := _GetNodeValue(LineNode, 'tllinedate');
        TransLine.tlLineNo             := _GetNodeValue(LineNode, 'tllineno');
  //    TransLine.tlLineSource         := _GetNodeValue(LineNode, 'tllinesource');
        TransLine.tlLineType           := _GetNodeValue(LineNode, 'tllinetype');
        TransLine.tlLocation           := _GetNodeValue(LineNode, 'tllocation');
        TransLine.tlNetValue           := _GetNodeValue(LineNode, 'tlnetvalue');
  //    TransLine.tlOurRef             := _GetNodeValue(LineNode, 'tlourref');
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
  //    TransLine.tlRunNo              := _GetNodeValue(LineNode, 'tlrunno');
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

      if TransLine.tlGLCode = oToolkit.SystemSetup.ssGLCtrlCodes[ssGLCurrencyVariance] then
        with oAdd as IBetaTransaction do
          thAllowCtrlCodes := False;

      TransLine.Save;
      TransLine := nil;
    end;
  end;
end;

procedure TTransactionImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
  ErrorMsg: string;
//  oConfig: IConfiguration;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin
    ErrorCode := 0;
    oTrans := oToolkit.Transaction as ITransaction3;
    if Assigned(oTrans) then
      isFileOpen := True
    else
    begin
      ErrorCode := cCONNECTINGDBERROR;
      ErrorMsg  := 'Cannot retrieve Transaction interface';
    end;
    { Open the Document Numbers file as well. }
    SetDrive := DataPath;
    FuncRes := Open_File(F[IncF], SetDrive + FileNames[IncF], 0);
    if (FuncRes <> 0) then
    begin
      ErrorCode := cCONNECTINGDBERROR;
      ErrorMsg  := 'Cannot open Document Numbers file';
    end;
    if Assigned(ClientLicence) then
      ClientLicence.Free;
    ClientLicence := TClientLicence.Create;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TTransactionImport.AddRecord: ' + ErrorMsg, ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TTransactionImport.AddRecord: ' + ErrorMsg, ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TTransactionImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TTransactionImport.Destroy;
var
  FuncRes: Integer;
begin
  FuncRes := Close_File(F[IncF]);
  if ((FuncRes <> 0) and (FuncRes <> 3)) then
    DoLogMessage('TTransactionImport.Destroy: Failed to close Document Numbers file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
  oToolkit := nil;
  oTrans := nil;
  if Assigned(ClientLicence) then
    ClientLicence.Free;
  inherited;
end;

// ---------------------------------------------------------------------------

function TTransactionImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TTransactionImport.WriteDetails(Node: IXMLDOMNode): Boolean;

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
  DocNumber, OldDocNumber: Integer;
  OldOurRef: string;
begin
  DocType := _GetNodeValue(Node, 'thdoctype');
//  Trace('Our Ref: ' + _GetNodeValue(Node, 'thourref'));
  oAdd := oTrans.Add(DocType) as ITransaction3;
  try

    oAdd.thOurRef            := _GetNodeValue(Node, 'thourref');
    oAdd.thYourRef           := _GetNodeValue(Node, 'thyourref');
    oAdd.thAcCode            := _GetNodeValue(Node, 'thaccode');
//  oAdd.thRunNo             := _GetNodeValue(Node, 'thrunno');
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
//  oAdd.thDocType           := _GetNodeValue(Node, 'thdoctype');
    oAdd.thNetValue          := _GetNodeValue(Node, 'thnetvalue');
    oAdd.thTotalVAT          := _GetNodeValue(Node, 'thtotalvat');
    oAdd.thSettleDiscPerc    := _GetNodeValue(Node, 'thsettlediscperc');
    oAdd.thSettleDiscAmount  := _GetNodeValue(Node, 'thsettlediscamount');
    oAdd.thTotalLineDiscount := _GetNodeValue(Node, 'thtotallinediscount');
    oAdd.thSettleDiscDays    := _GetNodeValue(Node, 'thsettlediscdays');
    oAdd.thSettleDiscTaken   := _GetNodeValue(Node, 'thsettledisctaken');
//  oAdd.thAmountSettled     := _GetNodeValue(Node, 'thamountsettled');
    oAdd.thTransportNature   := _GetNodeValue(Node, 'thtransportnature');
    oAdd.thTransportMode     := _GetNodeValue(Node, 'thtransportmode');
    oAdd.thHoldFlag          := _GetNodeValue(Node, 'thholdflag');
    oAdd.thTotalWeight       := _GetNodeValue(Node, 'thtotalweight');
    oAdd.thTotalCost         := _GetNodeValue(Node, 'thtotalcost');
//  oAdd.thPrinted           := _GetNodeValue(Node, 'thprinted');
    oAdd.thManualVAT         := _GetNodeValue(Node, 'thmanualvat');
//  oAdd.thDeliveryNoteRef   := _GetNodeValue(Node, 'thdeliverynoteref');
    oAdd.thDeliveryTerms     := _GetNodeValue(Node, 'thdeliveryterms');
    oAdd.thOperator          := _GetNodeValue(Node, 'thoperator');
    oAdd.thJobCode           := _GetNodeValue(Node, 'thjobcode');
//    oAdd.thAnalysisCode      := _GetNodeValue(Node, 'thanalysiscode');
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
//  oAdd.thPostedDate        := _GetNodeValue(Node, 'thposteddate');
    oAdd.thPORPickSOR        := _GetNodeValue(Node, 'thporpicksor');
    oAdd.thBatchDiscAmount   := _GetNodeValue(Node, 'thbatchdiscamount');
    oAdd.thPrePost           := _GetNodeValue(Node, 'thprepost');
    oAdd.thFixedRate         := _GetNodeValue(Node, 'thfixedrate');
    oAdd.thLongYourRef       := _GetNodeValue(Node, 'thlongyourref');
    oAdd.thEmployeeCode      := _GetNodeValue(Node, 'themployeecode');

//    if oAdd.thManualVAT then
    begin
      SubNode := _GetChildNodeByName(Node, 'thvatanalysis');
      if (SubNode <> nil) then
      begin
        for i := 0 to SubNode.childNodes.length - 1 do
        begin
          VATCode := _GetNodeValue(SubNode.childNodes.item[i], 'tvacode');
          oAdd.thVATAnalysis[VATCode[1]] := _GetNodeValue(SubNode.childNodes.item[i], 'tvavalue');
        end;
      end;
    end;

{
    SubNode := _GetChildNodeByName(Node, 'thgoodsanalysis');
    if (SubNode <> nil) then
    begin
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        VATCode := _GetNodeValue(SubNode.childNodes.item[ChildIndex], 'tgacode');
        oAdd.thGoodsAnalysis[VATCode[1]] := _GetNodeValue(SubNode.childNodes.item[ChildIndex], 'tgavalue');
      end;
    end;

    SubNode := _GetChildNodeByName(Node, 'thlineanalysis');
    if (SubNode <> nil) then
    begin
      for i := 0 to SubNode.childNodes.length - 1 do
      begin
        LineCode := _GetNodeValue(SubNode.childNodes.item[ChildIndex], 'tlacode');
        oAdd.thLineAnalysis[LineCode] := _GetNodeValue(SubNode.childNodes.item[ChildIndex], 'tlavalue');
      end;
    end;
}

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

(*
    SubNode := _GetChildNodeByName(Node, 'thasapplication');
    if (oAdd.thAsApplication <> nil) and (SubNode <> nil) then
    with oAdd.thAsApplication do
    begin
//    tpApplicationBasis := _GetNodeValue(SubNode, 'tpapplicationbasis');
//    tpApplied          := _GetNodeValue(SubNode, 'tpapplied');
      tpAppsInterimFlag  := _GetNodeValue(SubNode, 'tpappsinterimflag');
      tpATR              := _GetNodeValue(SubNode, 'tpatr');
      tpCertified        := _GetNodeValue(SubNode, 'tpcertified');
//    tpCertifiedValue   := _GetNodeValue(SubNode, 'tpcertifiedvalue');
      tpCISDate          := _GetNodeValue(SubNode, 'tpcisdate');
      tpCISManualTax     := _GetNodeValue(SubNode, 'tpcismanualtax');
//    tpCISSource        := _GetNodeValue(SubNode, 'tpcissource');
//    tpCISTaxDeclared   := _GetNodeValue(SubNode, 'tpcistaxdeclared');
      tpCISTaxDue        := _GetNodeValue(SubNode, 'tpcistaxdue');
//    tpCISTotalGross    := _GetNodeValue(SubNode, 'tpcistotalgross');
      tpDeferVAT         := _GetNodeValue(SubNode, 'tpdefervat');
      tpEmployeeCode     := _GetNodeValue(SubNode, 'tpemployeecode');
      tpParentTerms      := _GetNodeValue(SubNode, 'tpparentterms');
      tpTermsInterimFlag := _GetNodeValue(SubNode, 'tptermsinterimflag');
//    tpTermsStage       := _GetNodeValue(SubNode, 'tptermsstage');
//    tpTotalAppliedYTD  := _GetNodeValue(SubNode, 'tptotalappliedytd');
//    tpTotalBudget      := _GetNodeValue(SubNode, 'tptotalbudget');
//    tpTotalCertYTD     := _GetNodeValue(SubNode, 'tptotalcertytd');
//    tpTotalContra      := _GetNodeValue(SubNode, 'tptotalcontra');
//    tpTotalDeduct      := _GetNodeValue(SubNode, 'tptotaldeduct');
//    tpTotalDeductYTD   := _GetNodeValue(SubNode, 'tptotaldeductytd');
//    tpTotalRetain      := _GetNodeValue(SubNode, 'tptotalretain');
//    tpTotalRetainYTD   := _GetNodeValue(SubNode, 'tptotalretainytd');
    end;
*)

    SubNode := _GetChildNodeByName(Node, 'thasbatch');
    if (oAdd.thAsBatch <> nil) and (SubNode <> nil) then
    with oAdd.thAsBatch do
    begin
//    btTotal                := _GetNodeValue(SubNode, 'bttotal');          // NEEDED
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
      thAllowCtrlCodes := True;
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
      thSource        := _GetNodeValue(Node, 'thsource');
      thOutstanding   := _GetNodeValue(Node, 'thoutstanding');
      thOrdMatch      := _GetNodeValue(Node, 'thordmatch');
//      thAutoPost      := _GetNodeValue(Node, 'thautopost');
      thZeroLineNos   := True;
    end;

    AddLines(oAdd, _GetChildNodeByName(Node, 'tlrec'));

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
      { If the OurRef values are not the same, the transaction could not be
        stored against the incoming OurRef (presumably because a transaction
        already exists against that reference). Record this fact. }
      DoLogMessage('TTransaction.Import.WriteDetails: document OurRef ' +
                   OldOurRef + ' had to be stored as ' + oAdd.thOurRef,
                   0);

    if (FuncRes <> 0) and (FuncRes <> 5) then
    begin
      DoLogMessage('TTransactionImport.WriteDetails: failed to save transaction ' + oAdd.thOurRef +
                   ' Line no ' + IntToStr(oAdd.SaveErrorLine),
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end
    else
      Result := True;
  finally
    oAdd := nil;
  end;
end;

// ---------------------------------------------------------------------------

end.
