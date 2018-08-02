unit uDripfeedImport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb,
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uImportBaseClass,
  uClientLicence,
  uCrossReference
  ;

{$I ice.inc}

type
  TDripfeedImport = class(_ImportBase)
  private
    oTrans: ITransaction3;
    ClientLicence: TClientLicence;
    CrossRef: TCrossReference;

    function AllowSterlingOnly: Boolean;
    function IsSterling(CurrencyType: Byte): Boolean;
    function MustForceCurrencyToSterling: Boolean;

    function WriteDetails(Node: IXMLDOMNode): Boolean;

    function WriteCCDepts(Node: IXMLDOMNode): Boolean;
    function OpenCostCentreFile: Boolean;
    function WriteCCDept(Node: IXMLDOMNode; IsCostCentre: Boolean): Boolean;
    function CloseCostCentreFile: Boolean;

    function WriteStock(Node: IXMLDOMNode): Boolean;
    function OpenStockFile: Boolean;
    function WriteStockGroup(Node: IXMLDOMNode): Boolean;
    function WriteStockItem(Node: IXMLDOMNode): Boolean;
    function CloseStockFile: Boolean;

    function WriteAccount(Node: IXMLDOMNode): Boolean;
    function OpenAccountFile: Boolean;
    function WriteAccountRecord(Node: IXMLDOMNode): Boolean;
    function CloseAccountFile: Boolean;

    function WriteMatching(Node: IXMLDOMNode): Boolean;
    function OpenMatchingFile: Boolean;
    function WriteMatchingRecord(Node: IXMLDOMNode): Boolean;
    function CloseMatchingFile: Boolean;

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
  BtKeys1U,
  EtStrU,
  CTKUtil,
  EntLicence
  ;

const
  VATCodes:       array[1..23] of Char = ('S','E','Z','M','I','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  VATCodesLessMI: array[1..21] of Char = ('S','E','Z','1','2','3','4','5','6','7','8','9','T','X','B','C','F','G','R','W','Y');
  ERR_NON_STERLING_TRANSACTION = 'Cannot import a transaction with a ' +
                                 'currency other than Sterling into a ' +
                                 'single-currency system';
                                 
// ===========================================================================
// TDripfeedImport
// ===========================================================================

procedure TDripfeedImport.AddLines(oAdd: ITransaction; Node: IXMLDOMNode);
var
  LineNode, SubNode: IXMLDOMNode;
  ChildNodes: IXMLDOMNodeList;
  TransLine: ITransactionLine3;
  i: Integer;
  CurrencyType: Byte;
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
  //    TransLine.tlABSLineNo    := _GetNodeValue(LineNode, 'tlabslineno');   // NEEDED
  //    TransLine.tlAcCode       := _GetNodeValue(LineNode, 'tlaccode');
  //    TransLine.tlAnalysisCode := _GetNodeValue(LineNode, 'tlanalysiscode');

{
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
}

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

        CurrencyType := _GetNodeValue(LineNode, 'tlcurrency');

        if MustForceCurrencyToSterling then
          CurrencyType := 1
        else if AllowSterlingOnly and not IsSterling(CurrencyType) then
          raise Exception.Create(ERR_NON_STERLING_TRANSACTION);

        TransLine.tlCurrency           := CurrencyType;

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
        tlABSLineNo          := _GetNodeValue(LineNode, 'tlabslineno');   // NEEDED
        tlB2BLineNo          := _GetNodeValue(LineNode, 'tlb2blineno');     // NEEDED
        tlB2BLinkFolio       := _GetNodeValue(LineNode, 'tlb2blinkfolio');  // NEEDED
        tlBinQty             := _GetNodeValue(LineNode, 'tlbinqty');        // NEEDED
        tlCOSDailyRate       := _GetNodeValue(LineNode, 'tlcosdailyrate');  // NEEDED
        tlNominalMode        := _GetNodeValue(LineNode, 'tlnominalmode');   // CHECK
        tlQtyPack            := _GetNodeValue(LineNode, 'tlqtypack');       // NEEDED
        tlReconciliationDate := _GetNodeValue(LineNode, 'tlreconciliationdate');  // NEEDED
        tlStockDeductQty     := _GetNodeValue(LineNode, 'tlstockdeductqty');  // NEEDED
        tlUseQtyMul          := _GetNodeValue(LineNode, 'tluseqtymul');       // NEEDED
      end;

      if TransLine.tlGLCode = oToolkit.SystemSetup.ssGLCtrlCodes[ssGLCurrencyVariance] then
        with oAdd as IBetaTransaction do
          thAllowCtrlCodes := False;

      TransLine.Save;
      TransLine := nil;
    end;
  end;
end;

// ---------------------------------------------------------------------------

procedure TDripfeedImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
  ErrorMsg: string;
//  oConfig: IConfiguration;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  SetDrive := Datapath;

  if not isFileOpen then
  begin
    oTrans := oToolkit.Transaction as ITransaction3;
    if Assigned(oTrans) then
      isFileOpen := True
    else
    begin
      ErrorCode := cCONNECTINGDBERROR;
      ErrorMsg  := 'Cannot retrieve Transaction interface';
    end;
    if Assigned(ClientLicence) then
      ClientLicence.Free;
    ClientLicence := TClientLicence.Create;
    if (ErrorCode = 0) then
    begin
      CrossRef := TCrossReference.Create(DataPath);
      ErrorCode := CrossRef.ErrorCode;
    end;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TDripfeedImport.AddRecord: ' + ErrorMsg, ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TDripfeedImport.AddRecord: ' + ErrorMsg, ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.AllowSterlingOnly: Boolean;
{ If importing into a non-practice, single-currency system, all imported
  transactions must be in sterling. }
begin
  Result := (EnterpriseLicence.elProductType <> ptLITEAcct) and
            (not EnterpriseLicence.elIsMultiCcy);
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.CloseAccountFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[CustF]);
  Result  := ((FuncRes = 0) or (FuncRes = 3));
  if not Result then
    DoLogMessage('TDripfeedImport.CloseAccountFile: Failed to close file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.CloseCostCentreFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[PwrdF]);
  Result  := ((FuncRes = 0) or (FuncRes = 3));
  if not Result then
    DoLogMessage('TDripfeedImport.CloseCostCentreFile: Failed to close file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.CloseMatchingFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[PwrdF]);
  Result  := ((FuncRes = 0) or (FuncRes = 3));
  if not Result then
    DoLogMessage('TDripfeedImport.CloseMatchingFile: Failed to close file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.CloseStockFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Close_File(F[StockF]);
  Result  := ((FuncRes = 0) or (FuncRes = 3));
  if not Result then
    DoLogMessage('TDripfeedImport.CloseStockFile: Failed to close file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

constructor TDripfeedImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TDripfeedImport.Destroy;
begin
  oToolkit := nil;
  oTrans := nil;
  if Assigned(ClientLicence) then
    ClientLicence.Free;
  if Assigned(CrossRef) then
    CrossRef.Free;
  inherited;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.IsSterling(CurrencyType: Byte): Boolean;
begin
  Result := (CurrencyType = 1);
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.MustForceCurrencyToSterling: Boolean;
{ If importing into a Practice system, and the Client system is single
  currency, currency types must be imported as Sterling. }
begin
  Result := (EnterpriseLicence.elProductType = ptLITEAcct) and
            (not ClientLicence.elIsMultiCcy);
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.OpenAccountFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[CustF], SetDrive + FileNames[CustF], 0);
  Result := (FuncRes = 0);
  if not Result then
    DoLogMessage('TDripfeedImport.OpenAccountFile: Failed to open file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.OpenCostCentreFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
  Result := (FuncRes = 0);
  if not Result then
    DoLogMessage('TDripfeedImport.OpenCostCentreFile: Failed to open file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.OpenMatchingFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
  Result  := (FuncRes = 0);
  if not Result then
    DoLogMessage('TDripfeedImport.OpenMatchingFile: Failed to open file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.OpenStockFile: Boolean;
var
  FuncRes: LongInt;
begin
  FuncRes := Open_File(F[StockF], SetDrive + FileNames[StockF], 0);
  Result  := (FuncRes = 0);
  if not Result then
    DoLogMessage('TDripfeedImport.OpenStockFile: Failed to open file',
                 cCONNECTINGDBERROR,
                 'Error: ' + IntToStr(FuncRes));
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteAccount(Node: IXMLDOMNode): Boolean;
var
  ChildNode: IXMLDOMNode;
begin
  Result := OpenAccountFile;
  if Result then
  begin
    ChildNode := _GetChildNodeByName(Node, 'custrec');
    if (ChildNode <> nil) and ChildNode.hasChildNodes then
      Result    := WriteAccountRecord(ChildNode);
    CloseAccountFile;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteAccountRecord(Node: IXMLDOMNode): Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  Aux: string;
  SubNode: IXMLDOMNode;
  TypeCode: string;
begin
  Result := True;

  { Search for an existing record. }
  Key := _GetNodeValue(Node, 'accode');
  FuncRes := Find_Rec(B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, Key);

  TypeCode := _GetNodeValue(Node, 'acacctype');

  if (Trim(TypeCode) <> '') then
  { Fill in the record structure }
  with Cust do
  begin
    try

      CustSupp  := TypeCode[1];
      CustCode  := FullCustCode(_GetNodeValue(Node, 'accode'));
      Company   := FullCompKey(_GetNodeValue(Node, 'accompany'));
      AreaCode  := _GetNodeValue(Node, 'acarea');
      RemitCode := LJVar(_GetNodeValue(Node, 'acstatementto'), 10);
      AreaCode  := _GetNodeValue(Node, 'acvatregno');

      SubNode := _GetNodeByName(Node, 'acaddress');
      Addr[1]   := _GetNodeValue(SubNode, 'acstreet1');
      Addr[2]   := _GetNodeValue(SubNode, 'acstreet2');
      Addr[3]   := _GetNodeValue(SubNode, 'actown');
      Addr[4]   := _GetNodeValue(SubNode, 'accounty');
      Addr[5]   := _GetNodeValue(SubNode, 'acpostcode');

      SubNode := _GetNodeByName(Node, 'acdeladdress');
      daddr[1]  := _GetNodeValue(SubNode, 'acstreet1');
      daddr[2]  := _GetNodeValue(SubNode, 'acstreet2');
      daddr[3]  := _GetNodeValue(SubNode, 'actown');
      daddr[4]  := _GetNodeValue(SubNode, 'accounty');
      daddr[5]  := _GetNodeValue(SubNode, 'acpostcode');

      Contact   := _GetNodeValue(Node, 'accontact');
      phone     := FullCustPhone(_GetNodeValue(Node, 'acphone'));
      Fax       := _GetNodeValue(Node, 'acfax');
      refno     := _GetNodeValue(Node, 'actheiracc');

      SubNode := _GetNodeByName(Node, 'actradeterms');
      STerms[1] := _GetNodeValue(SubNode, 'acterm1');
      STerms[2] := _GetNodeValue(SubNode, 'acterm2');

      currency  := _GetNodeValue(Node, 'accurrency');

      try
        Aux := _GetNodeValue(Node, 'acvatcode');
        if Aux <> '' then
          vatcode := Aux[1]
        else
          vatcode := #0;
      except
        vatcode := #0;
      end;

      payterms     := _GetNodeValue(Node, 'acpayterms');
      creditlimit  := _GetNodeValue(Node, 'accreditlimit');
      discount     := _GetNodeValue(Node, 'acdiscount');
      creditstatus := _GetNodeValue(Node, 'accreditstatus');
      custcc       := FullCCDepKey(_GetNodeValue(Node, 'accostcentre'));

      try
        Aux := _GetNodeValue(Node, 'acdiscountband');
        if Aux <> '' Then
          cdiscch := Aux[1]
        else
          cdiscch := #0;
      except
        cdiscch := #0;
      end;

      custdep    := FullCCDepKey(_GetNodeValue(Node, 'acdepartment'));
      eecmember  := _GetNodeValue(Node, 'acecmember');
      incstat    := _GetNodeValue(Node, 'acstatement');
      defnomcode := _GetNodeValue(Node, 'acsalesgl');
      defmlocstk := Uppercase(Full_MLocKey(_GetNodeValue(Node, 'aclocation')));
      accstatus  := _GetNodeValue(Node, 'acaccstatus');

      try
        Aux := _GetNodeValue(Node, 'acpaytype');
        if Aux <> '' then
          paytype := Aux[1] // <paytype/>
        else
          paytype := #0;
      except
        paytype := #0;
      end;

      banksort    := _GetNodeValue(Node, 'acbanksort'); // <banksort/>
      bankacc     := _GetNodeValue(Node, 'acbankacc'); // <bankacc/>
      bankref     := _GetNodeValue(Node, 'acbankref');
      lastused    := _GetNodeValue(Node, 'aclastused'); // <lastused/>
      phone2      := _GetNodeValue(Node, 'acphone2');
      userdef1    := _GetNodeValue(Node, 'acuserdef1');
      userdef2    := _GetNodeValue(Node, 'acuserdef2');
      sopinvcode  := FullCustCode(_GetNodeValue(Node, 'acinvoiceto'));
      sopautowoff := _GetNodeValue(Node, 'acsopautowoff');
      bordval     := _GetNodeValue(Node, 'acbookordval');
      defcosnom   := _GetNodeValue(Node, 'accosgl');
      defctrlnom  := _GetNodeValue(Node, 'acdrcrgl');
      dirdeb      := _GetNodeValue(Node, 'acdirdebmode');
      ccdsdate    := _GetNodeValue(Node, 'acccstart'); // <ccdsdate/>
      ccdedate    := _GetNodeValue(Node, 'acccend'); // <ccdedate/>
      ccdname     := _GetNodeValue(Node, 'acccname');
      ccdcardno   := _GetNodeValue(Node, 'acccnumber');
      ccdsaref    := _GetNodeValue(Node, 'acccswitch'); // <ccdsaref/>
      defsetddays := _GetNodeValue(Node, 'acdefsettledays');
      defsetdisc  := _GetNodeValue(Node, 'acdefsettledisc');
      fdefpageno  := _GetNodeValue(Node, 'acformset');
      statdmode   := _GetNodeValue(Node, 'acstatedeliverymode');
      emailaddr   := _GetNodeValue(Node, 'acemailaddr');
      emlsndrdr   := _GetNodeValue(Node, 'acsendreader');
      ebuspwrd    := _GetNodeValue(Node, 'acebuspword');
      postcode    := FullPostCode(_GetNodeValue(Node, 'acpostcode'));
      custcode2   := _GetNodeValue(Node, 'acaltcode');
      allowweb    := _GetNodeValue(Node, 'acuseforebus');
      emlzipatc   := _GetNodeValue(Node, 'aczipattachments');
      userdef3    := _GetNodeValue(Node, 'acuserdef3');
      userdef4    := _GetNodeValue(Node, 'acuserdef4');
      timechange  := _GetNodeValue(Node, 'actimestamp');
      ssddelterms := _GetNodeValue(Node, 'acssddeliveryterms');

      try
        Aux := _GetNodeValue(Node, 'acinclusivevatcode');
        if Aux <> '' Then
          cvatincflg := Aux[1]
        else
          cvatincflg := #0;
      except
        cvatincflg := #0;
      end;

      ssdmodetr   := _GetNodeValue(Node, 'acssdmodeoftransport');
      lastopo     := _GetNodeValue(Node, 'aclastoperator');
      invdmode    := _GetNodeValue(Node, 'acdocdeliverymode');
      emlsndhtml  := _GetNodeValue(Node, 'acsendhtml');
      weblivecat  := _GetNodeValue(Node, 'acweblivecatalog');
      webprevcat  := _GetNodeValue(Node, 'acwebprevcatalog');

      sopconsho   := _GetNodeValue(Node, 'acsopconsho');
      deftagno    := _GetNodeValue(Node, 'acdeftagno');
      ordconsmode := _GetNodeValue(Node, 'acordconsmode');

    except
      on E:Exception Do
      begin
        Result := False;
        DoLogMessage('TDripfeedImport.WriteAccountRecord',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end; // try...
  end; { with Cust do... }

  if Result then
  begin
    { If an existing record was found, update the details... }
    if (FuncRes = 0) then
      FuncRes := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := Add_Rec(F[CustF], CustF, RecPtr[CustF]^, 0);

    if (FuncRes <> 0) then
    begin
      DoLogMessage('TDripfeedImport.WriteAccountRecord: Failed to save record',
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end;
  end;

end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteCCDept(Node: IXMLDOMNode;
  IsCostCentre: Boolean): Boolean;
var
  FuncRes: LongInt;
  Code: ShortString;
  Key: ShortString;
  RecPFix, SubType: Char;
begin
  RecPfix := CostCCode;
  Subtype := CSubCode[IsCostCentre];

  Code := _GetNodeValue(Node, 'cdcode');
  Key := FullCCKey(RecPFix, SubType, Code);

  { Try to find a record matching the code. }
  FuncRes := Find_Rec(B_GetEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, Key);
  try
    if (FuncRes = 0) then
    begin
      { Record found - update the details. }
      Password.CostCtrRec.PCostC := Uppercase(FullCCDepKey(Code));
      Password.CostCtrRec.CCDesc := _GetNodeValue(Node, 'cdname');
      FuncRes := Put_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0);
    end
    else
    begin
      { No record found - add a new record. }
      Password.RecPfix := RecPFix;
      Password.SubType := SubType;
      Password.CostCtrRec.PCostC := Uppercase(FullCCDepKey(Code));
      Password.CostCtrRec.CCDesc := _GetNodeValue(Node, 'cdname');
      FuncRes := Add_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0);
    end;
    Result := (FuncRes = 0);
    if not Result then
    begin
      DoLogMessage('TDripfeedImport.WriteCCDept: Failed to save record',
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end;
  except
    on E:Exception do
    begin
      Result := False;
      DoLogMessage('TDripfeedImport.WriteCCDept',
                   cLOADINGXMLVALUEERROR,
                   'Error: ' + E.message);
    end;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteCCDepts(Node: IXMLDOMNode): Boolean;
var
  ChildNodes: IXMLDOMNodeList;
  i: Integer;
begin
  Result := OpenCostCentreFile;
  if Result then
  try
    { Find and write Cost Centres }
    ChildNodes := Node.selectNodes('//ccrec');
    for i := 0 to ChildNodes.length - 1 do
    begin
      if not WriteCCDept(ChildNodes.item[i], True) then
      begin
        Result := False;
        break;
      end;
    end;
    if Result then
    begin
      { Find and write Departments }
      ChildNodes := Node.selectNodes('//deptrec');
      for i := 0 to ChildNodes.length - 1 do
      begin
        if not WriteCCDept(ChildNodes.item[i], False) then
        begin
          Result := False;
          break;
        end;
      end;
    end;
  finally
    CloseCostCentreFile;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteDetails(Node: IXMLDOMNode): Boolean;

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
  Notes: INotes;
  CurrencyType: Byte;
  RateStr: string;
begin

//  SetDrive := DataPath;

  WriteCCDepts(Node);
  WriteStock(Node);
  WriteAccount(Node);

  DocType := _GetNodeValue(Node, 'thdoctype');
  Trace('Our Ref: ' + _GetNodeValue(Node, 'thourref'));
  oAdd := oTrans.Add(DocType) as ITransaction3;
  with oAdd as IBetaTransaction do
  try
    thAllowCtrlCodes := True;
    thZeroLineNos := True;
    try
      oAdd.thOurRef            := _GetNodeValue(Node, 'thourref');
      oAdd.thYourRef           := _GetNodeValue(Node, 'thyourref');
      oAdd.thAcCode            := _GetNodeValue(Node, 'thaccode');
  //  oAdd.thRunNo             := _GetNodeValue(Node, 'thrunno');
      oAdd.thFolioNum          := _GetNodeValue(Node, 'thfolionum');

      CurrencyType := _GetNodeValue(Node, 'thcurrency');

      if MustForceCurrencyToSterling then
        CurrencyType := 1
      else if AllowSterlingOnly and not IsSterling(CurrencyType) then
        raise Exception.Create(ERR_NON_STERLING_TRANSACTION);

      oAdd.thCurrency          := CurrencyType;

      oAdd.thYear              := _GetNodeValue(Node, 'thyear');
      oAdd.thPeriod            := _GetNodeValue(Node, 'thperiod');
      oAdd.thTransDate         := _GetNodeValue(Node, 'thtransdate');
      oAdd.thDueDate           := _GetNodeValue(Node, 'thduedate');
RateStr := _GetNodeValue(Node, 'thcompanyrate');
if (RateStr <> '') then
  oAdd.thCompanyRate := StrToFloat(RateStr);
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
  //  oAdd.thAnalysisCode      := _GetNodeValue(Node, 'thanalysiscode');
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
      end;

      AddLines(oAdd, _GetChildNodeByName(Node, 'tlrecs'));

      if EnterpriseLicence.elProductType = ptLITEAcct then
      { If running at a Practice, try to import the transaction using
        its existing document number. }
      begin
        { Extract the document number from thOurRef. }
        OldOurRef := oAdd.thOurRef;
        DocNumber := ExtractDocumentNumber(oAdd.thOurRef);

        { Update Document Numbers with this document number, storing the original
          value. }
        OldDocNumber := UpdateDocumentNumber(oAdd.thOurRef, DocNumber);

        { Save the transaction. }
        FuncRes := oAdd.Save(False);

        { Replace the original Document Number value. }
        UpdateDocumentNumber(oAdd.thOurRef, OldDocNumber);

        if (OldOurRef <> oAdd.thOurRef) then
        begin
          oTrans.Index := thIdxOurRef;
          if oTrans.GetEqual(oTrans.BuildOurRefIndex(oAdd.thOurRef)) = 0 then
          begin
            Notes := oTrans.thNotes.Add;
            Notes.ntLineNo := 1;
            Notes.ntType := ntTypeGeneral;
            Notes.ntDate := FormatDateTime('yyyyddmm', Now);
            Notes.ntText := 'Original OurRef: ' + OldOurRef;
            FuncRes := Notes.Save;
            if (FuncRes <> 0) then
              DoLogMessage('TTransactionImport.WriteDetails: could not save note',
                           cUPDATINGDBERROR,
                           'Error: ' + IntToStr(FuncRes));
            { Clear the result, so we don't get the error message twice. }
            FuncRes := 0;
            Notes := nil;
          end;
          { If the OurRef values are not the same, the transaction could not be
            stored against the incoming OurRef (presumably because a transaction
            already exists against that reference). Record this fact. }
          DoLogMessage('TTransaction.Import.WriteDetails: document OurRef ' +
                       OldOurRef + ' had to be stored as ' + oAdd.thOurRef,
                       0);
          { Make a note of the change, because we will need to update any
            related matching records as well. }
          CrossRef.Add(OldOurRef, oAdd.thOurRef);
        end;
      end
      else
        { If running at a Client, the document number does not need to be
          preserved, so just save the transaction under whatever document
          number is assigned by the system. }
        FuncRes := oAdd.Save(False);

      if (FuncRes <> 0) then
      begin
        DoLogMessage('TDripfeedImport.WriteDetails: failed to save transaction',
                     cUPDATINGDBERROR,
                     'Error: ' + IntToStr(FuncRes));
        Result := False;
      end
      else
        Result := True;
    except
      on E:Exception do
      begin
        Result := False;
        DoLogMessage('TDripfeedImport.WriteDetails',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end;
  finally
    oAdd := nil;
  end;

  if Result then
    Result := WriteMatching(Node);
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteMatching(Node: IXMLDOMNode): Boolean;
var
  ChildNodes: IXMLDOMNodeList;
  i: Integer;
begin
  Result := OpenMatchingFile;
  if Result then
  try
    { Find and write Matching Records }
    ChildNodes := Node.selectNodes('//matchrec');
    for i := 0 to ChildNodes.length - 1 do
    begin
      if not WriteMatchingRecord(ChildNodes.item[i]) then
      begin
        Result := False;
        break;
      end;
    end;
  finally
    CloseMatchingFile
  end;
end;

// ---------------------------------------------------------------------------
(*
function TDripfeedImport.WriteMatchingRecord(Node: IXMLDOMNode): Boolean;

  function MatchingSubType(MatchType: Integer): Char;
  begin
    case MatchType of
      maTypeFinancial:          Result := 'P';
      maTypeSPOP:               Result := 'P';
      maTypeCIS:                Result := 'C';
      maTypeCostApportionment:  Result := '0';
      maTypeUser1:              Result := '1';
      maTypeUser2:              Result := '2';
      maTypeUser3:              Result := '3';
      maTypeUser4:              Result := '4';
    else
      Result := 'P';
    end;
  end;

  function BuildSearchKey: ShortString;
  begin
    Result := FullMatchKey('T',
                           MatchingSubType(_GetNodeValue(Node, 'maType')),
                           CrossRef.OurRef(LJVar(_GetNodeValue(Node, 'maDocRef'), 10)));
  end;

  function FindMatching(BaseKey, PayRef: ShortString): Boolean;
  var
    FuncRes: LongInt;
    SearchKey: ShortString;
  begin
    Result := False;
    SearchKey := BaseKey;
    PayRef := LJVar(PayRef, 10);
    FuncRes := Find_Rec(B_GetGEq, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, SearchKey);
    while (FuncRes = 0) and (Copy(SearchKey, 1, Length(BaseKey)) = BaseKey) do
    begin
      if (PayRef = Password.MatchPayRec.PayRef) then
      begin
        Result := True;
        break;
      end;
      FuncRes := Find_Rec(B_GetNext, F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0, SearchKey);
    end;
  end;

var
  Key: ShortString;
  RecordExists: Boolean;
  MatchingType: Integer;
  FuncRes: Integer;
begin
  { Build a search key. }
  Key := BuildSearchKey;

  { Try to locate an existing record. }
  RecordExists := FindMatching(Key, CrossRef.OurRef(LJVar(_GetNodeValue(Node, 'maPayRef'), 12)));
  try
    { Fill in the details. }
    Password.RecPfix := 'T';
    MatchingType := _GetNodeValue(Node, 'maType');
    Password.SubType := MatchingSubType(MatchingType);
    Password.MatchPayRec.DocCode    := CrossRef.OurRef(LJVar(_GetNodeValue(Node, 'maDocRef'), 12));
    Password.MatchPayRec.PayRef     := CrossRef.OurRef(LJVar(_GetNodeValue(Node, 'maPayRef'), 10));
    with Password.MatchPayRec do
    begin
      SettledVal := _GetNodeValue(Node, 'maBaseValue');
      OwnCVal    := _GetNodeValue(Node, 'maDocValue');
      MCurrency  := _GetNodeValue(Node, 'maDocCurrency');
      AltRef     := _GetNodeValue(Node, 'maDocYourRef');
      RCurrency  := _GetNodeValue(Node, 'maPayCurrency');
      RecOwnCVal := _GetNodeValue(Node, 'maPayValue');
      case MatchingType of
        maTypeFinancial: MatchType := 'A';
        maTypeSPOP:      MatchType := 'O';
      else
        MatchType := Password.SubType;
      end;
    end;

    if (RecordExists) then
      { If a record was found, update the existing details... }
      FuncRes := Put_Rec(F[PwrdF], PwrdF, RecPtr[PwrdF]^, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := Add_Rec(F[PwrdF], Pwrdf, RecPtr[PwrdF]^, 0);

    Result := (FuncRes = 0);
    if not Result then
      DoLogMessage('TDripfeedImport.WriteMatchingRecord: failed to save record',
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
  except
    on E:Exception do
    begin
      Result := False;
      DoLogMessage('TDripfeedImport.WriteMatchingRecord',
                   cLOADINGXMLVALUEERROR,
                   'Error: ' + E.message);
    end;
  end;
end;
*)

function TDripfeedImport.WriteMatchingRecord(Node: IXMLDOMNode): Boolean;

  function MatchingSubType(MatchType: Integer): Char;
  begin
    case MatchType of
      maTypeFinancial:          Result := 'P';
      maTypeSPOP:               Result := 'P';
      maTypeCIS:                Result := 'C';
      maTypeCostApportionment:  Result := '0';
      maTypeUser1:              Result := '1';
      maTypeUser2:              Result := '2';
      maTypeUser3:              Result := '3';
      maTypeUser4:              Result := '4';
    else
      Result := 'P';
    end;
  end;

var
  FuncRes: Integer;
  ActualDocCode, ActualPayRef: Str10;
  DocCode, PayRef: Str10;
  DocValue, PayValue: Double;
  BaseValue: Double;
  InvTrans: ITransaction;
  Match: IMatching;
begin
  Result := False;
  { Read the codes, and locate the correct new OurRef values from the
    Cross-Reference file }
  DocCode := _GetNodeValue(Node, 'maDocRef');
  PayRef  := _GetNodeValue(Node, 'maPayRef');

  DocValue := _GetNodeValue(Node, 'maDocValue');
  PayValue := _GetNodeValue(Node, 'maPayValue');
  BaseValue := _GetNodeValue(Node, 'maBaseValue');

  ActualDocCode := CrossRef.OurRef(LJVar(DocCode, 10));
  ActualPayRef  := CrossRef.OurRef(LJVar(PayRef, 10));

  if (ActualDocCode <> '') and (ActualPayRef <> '') then
  begin
    // Find invoice transaction
    oTrans.Index := thIdxOurRef;
    FuncRes := oTrans.GetEqual(oTrans.BuildOurRefIndex(ActualDocCode));
    if (FuncRes = 0) then
    begin
      // Take a copy of the invoice transaction
      InvTrans := oTrans.Clone;
      // Find payment transaction
      FuncRes := oTrans.GetEqual(oTrans.BuildOurRefIndex(ActualPayRef));
      if (FuncRes = 0) then
      begin
        // Got payment - match the invoice with the payment
        Match := oTrans.thMatching.Add;
        with Match do
        begin
          // Copy details from invoice
          maDocRef := InvTrans.thOurRef;
          maDocCurrency := InvTrans.thCurrency;
          maDocValue := DocValue; // InvTrans.thTotals[TransTotInCcy];

          // Copy details from payment
          maPayRef := oTrans.thOurRef;
          maPayCurrency := oTrans.thCurrency;
          maPayValue := PayValue; // oTrans.thTotals[TransTotInCcy];

          // Generate Base Equivalent of matched amount
          maBaseValue := BaseValue; // oToolkit.Functions.entConvertAmount(OBPayValue, maPayCurrency, 0, 0);

          with Match as IBetaMatching do
            maAllowOverSettling := True;
          FuncRes := Save;
          if (FuncRes <> 0) then
            DoLogMessage('TDripFeedImport.WriteDetails: ' +
                         DocCode + ', ' + PayRef + ': ' +
                         'Error matching invoice and payment - ' +
                         oToolkit.LastErrorString,
                         cUPDATINGDBERROR);
        end; { with oTrans.thMatching.Add do... }
      end { if (FuncRes = 0) then... }
      else
        DoLogMessage('TDripFeedImport.WriteDetails: ' +
                     DocCode + ', ' + PayRef + ': ' +
                     'Error loading payment details - ' + oToolkit.LastErrorString,
                     cUPDATINGDBERROR);

      // Remove reference to object
      InvTrans := NIL;
    end { if (FuncRes = 0) then... }
    else
      DoLogMessage('TDripFeedImport.WriteDetails: ' +
                   DocCode + ', ' + PayRef + ': ' +
                   'Error loading invoice details - ' + oToolkit.LastErrorString,
                   cUPDATINGDBERROR);
  end
  else
    DoLogMessage('TDripFeedImport.WriteDetails: ' +
                 'Could not locate matching entries for ' +
                 DocCode + ', ' + PayRef + ' ' +
                 'in Cross Reference file',
                 cUPDATINGDBERROR);
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteStock(Node: IXMLDOMNode): Boolean;
var
  ChildNodes: IXMLDOMNodeList;
  i: Integer;
begin
  Result := OpenStockFile;
  if Result then
  try
    { Find and write Stock Groups }
    ChildNodes := Node.selectNodes('//stockgroup');
    for i := 0 to ChildNodes.length - 1 do
    begin
      if not WriteStockGroup(ChildNodes.item[i]) then
      begin
        Result := False;
        break;
      end;
    end;
    if Result then
    begin
      { Find and write Stock Items }
      ChildNodes := Node.selectNodes('//stockrec');
      for i := 0 to ChildNodes.length - 1 do
      begin
        if not WriteStockItem(ChildNodes.item[i]) then
        begin
          Result := False;
          break;
        end;
      end;
    end;
  finally
    CloseStockFile;
  end;
end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteStockGroup(Node: IXMLDOMNode): Boolean;

  function ToChar(const Value: string): Char;
  begin
    if (Trim(Value) <> '') then
      Result := Value[1]
    else
      Result := #0;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  SubNode, LineNode: IXMLDOMNode;
  i, iBand: Integer;
  DefaultCurrency: Integer;
begin
  Result := True;

  { Search for an existing record. }
  Key := FullStockCode(_GetNodeValue(Node, 'stcode'));
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);

  { If no record was found, clear the Stock record structure ready to create
    a new record. }
  if (FuncRes <> 0) then
    FillChar(Stock, SizeOf(Stock), #0);

  { Fill in the record structure }
  with Stock do
  begin
    try

      StockCode := FullStockCode(_GetNodeValue(Node, 'stcode'));

      SubNode := _GetNodeByName(Node, 'stdesc');
      if (SubNode <> nil) then
      begin
        for i := 0 to SubNode.childNodes.length - 1 do
        begin
          LineNode := SubNode.childNodes[i];
          if (i < (Length(Desc) - 1)) then
            Desc[i + 1] := LineNode.text;
        end;
      end;

      StockType     := ToChar(_GetNodeValue(Node, 'sttype'));
      StockCat      := FullStockCode(_GetNodeValue(Node, 'stparentcode'));
      StockFolio    := _GetNodeValue(Node, 'stfolionum');
      UnitK         := _GetNodeValue(Node, 'stunitofstock');
      UnitS         := _GetNodeValue(Node, 'stunitofsale');
      UnitP         := _GetNodeValue(Node, 'stunitofpurch');
      SellUnit      := _GetNodeValue(Node, 'stsalesunits');
      BuyUnit       := _GetNodeValue(Node, 'stpurchunits');


      if oToolkit.SystemSetup.ssCurrencyVersion = 0 then
        DefaultCurrency := 0
      else
        DefaultCurrency := 1;

      for iBand := Low(SaleBands) to High(SaleBands) do
      begin
        SaleBands[iBand].Currency := DefaultCurrency;
      end; // for iBand

      PCurrency  := DefaultCurrency;
      ROCurrency := DefaultCurrency;

    except
      on E:Exception Do
      begin
        Result := False;
        DoLogMessage('TDripfeedImport.WriteStockGroup',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end; { try... }
  end; { with Stock do... }

  if Result then
  begin
    { If an existing record was found, update the details... }
    if (FuncRes = 0) then
      FuncRes := Put_Rec(F[StockF], StockF, RecPtr[StockF]^, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := Add_Rec(F[StockF], StockF, RecPtr[StockF]^, 0);

    if (FuncRes <> 0) then
    begin
      DoLogMessage('TDripfeedImport.WriteStockGroup: failed to save record',
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end;
  end;

end;

// ---------------------------------------------------------------------------

function TDripfeedImport.WriteStockItem(Node: IXMLDOMNode): Boolean;

  function ToChar(const Value: string): Char;
  begin
    if (Trim(Value) <> '') then
      Result := Value[1]
    else
      Result := #0;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  SubNode, LineNode: IXMLDOMNode;
  i: Integer;
  TempStr: string[29];
begin
  Result := True;

  { Search for an existing record. }
  Key := FullStockCode(_GetNodeValue(Node, 'stcode'));
  FuncRes := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);

  { Fill in the record structure }
  with Stock do
  begin
    try

      StockCode := FullStockCode(_GetNodeValue(Node, 'stcode'));

      SubNode := _GetNodeByName(Node, 'stdesc');
      if (SubNode <> nil) then
      begin
        for i := 0 to SubNode.childNodes.length - 1 do
        begin
          LineNode := SubNode.childNodes[i];
          if (i < (Length(Desc) - 1)) then
            Desc[i + 1] := LineNode.text;
        end;
      end;

      AltCode       := LJVar(_GetNodeValue(Node, 'staltcode'), StkKeyLen);
      SuppTemp      := FullCustCode(_GetNodeValue(Node, 'stsupptemp'));
      NomCodes[1]   := _GetNodeValue(Node, 'stsalesgl');
      NomCodes[2]   := _GetNodeValue(Node, 'stcosgl');
      NomCodes[3]   := _GetNodeValue(Node, 'stpandlgl');
      NomCodes[4]   := _GetNodeValue(Node, 'stbalsheetgl');
      NomCodes[5]   := _GetNodeValue(Node, 'stwipgl');
      ROFlg         := _GetNodeValue(Node, 'stroflg');
      MinFlg        := _GetNodeValue(Node, 'stbelowminlevel');
      StockFolio    := _GetNodeValue(Node, 'stfolionum');
      StockCat      := FullStockCode(_GetNodeValue(Node, 'stparentcode'));
      StockType     := ToChar(_GetNodeValue(Node, 'sttype'));
      UnitK         := _GetNodeValue(Node, 'stunitofstock');
      UnitS         := _GetNodeValue(Node, 'stunitofsale');
      UnitP         := _GetNodeValue(Node, 'stunitofpurch');
      PCurrency     := _GetNodeValue(Node, 'stcostpricecur');
      CostPrice     := _GetNodeValue(Node, 'stcostprice');

      SubNode := _GetNodeByName(Node, 'stsalesbands');
      if (SubNode <> nil) then
      begin
        for i := 1 to SubNode.childNodes.length do
        begin
          LineNode := SubNode.childNodes.item[i];
          if (i < Length(SaleBands)) then
          begin
            SaleBands[i].Currency   := _GetNodeValue(LineNode, 'stscurrency');
            SaleBands[i].SalesPrice := _GetNodeValue(LineNode, 'stsprice');
          end;
        end;
      end;

      SellUnit      := _GetNodeValue(Node, 'stsalesunits');
      BuyUnit       := _GetNodeValue(Node, 'stpurchunits');
      VATCode       := ToChar(_GetNodeValue(Node, 'stvatcode'));
      CCDep[BOn]    := FullCCDepKey(_GetNodeValue(Node, 'stcostcentre'));
      CCDep[BOff]   := FullCCDepKey(_GetNodeValue(Node, 'stdepartment'));
      QtyInStock    := _GetNodeValue(Node, 'stqtyinstock');
      QtyPosted     := _GetNodeValue(Node, 'stqtyposted');
      QtyAllocated  := _GetNodeValue(Node, 'stqtyallocated');
      QtyOnOrder    := _GetNodeValue(Node, 'stqtyonorder');
      QtyMin        := _GetNodeValue(Node, 'stqtymin');
      QtyMax        := _GetNodeValue(Node, 'stqtymax');
      ROQty         := _GetNodeValue(Node, 'stroqty');
      NLineCount    := _GetNodeValue(Node, 'stnlinecount');
      SubAssyFlg    := _GetNodeValue(Node, 'stsubassyflg');
      ShowasKit     := _GetNodeValue(Node, 'stshowaskit');
      BLineCount    := _GetNodeValue(Node, 'stblinecount');
      CommodCode    := _GetNodeValue(Node, 'stcommodcode');
      SWeight       := _GetNodeValue(Node, 'stsweight');
      PWeight       := _GetNodeValue(Node, 'stpweight');
      UnitSupp      := _GetNodeValue(Node, 'stunitsupp');
      SuppSUnit     := _GetNodeValue(Node, 'stsuppsunit');
      BinLoc        := FullBinCode(_GetNodeValue(Node, 'stbinlocation'));
      StkFlg        := _GetNodeValue(Node, 'ststkflg');
      CovPr         := _GetNodeValue(Node, 'stcoverperiods');
      CovPrUnit     := ToChar(_GetNodeValue(Node, 'stcoverperiodunits'));
      CovMinPr      := _GetNodeValue(Node, 'stcoverminperiods');
      CovMinUnit    := ToChar(_GetNodeValue(Node, 'stcoverminperiodunits'));
      Supplier      := FullCustCode(_GetNodeValue(Node, 'stsupplier'));
      QtyFreeze     := _GetNodeValue(Node, 'stqtyfreeze');
      CovSold       := _GetNodeValue(Node, 'stcoverqtysold');
      UseCover      := _GetNodeValue(Node, 'stusecover');
      CovMaxPr      := _GetNodeValue(Node, 'stcovermaxperiods');
      CovMaxUnit    := ToChar(_GetNodeValue(Node, 'stcovermaxperiodunits'));
      ROCurrency    := _GetNodeValue(Node, 'strocurrency');
      ROCPrice      := _GetNodeValue(Node, 'strocprice');
      RODate        := _GetNodeValue(Node, 'strodate');
      QtyTake       := _GetNodeValue(Node, 'stqtytake');
      StkValType    := ToChar(_GetNodeValue(Node, 'stvaluationmethod'));
      HasSerNo      := _GetNodeValue(Node, 'sthasserno');
      QtyPicked     := _GetNodeValue(Node, 'stqtypicked');
      LastUsed      := _GetNodeValue(Node, 'stlastused');
      CalcPack      := _GetNodeValue(Node, 'stcalcpack');
      JAnalCode     := Uppercase(LJVar(_GetNodeValue(Node, 'stanalysiscode'), AnalKeyLen));
      StkUser1      := _GetNodeValue(Node, 'stuserfield1');
      StkUser2      := _GetNodeValue(Node, 'stuserfield2');
      BarCode       := FullBarCode(_GetNodeValue(Node, 'stbarcode'));
      ROCCDep[BOn]  := Uppercase(FullCCDepKey(_GetNodeValue(Node, 'strocc')));
      ROCCDep[BOff] := Uppercase(FullCCDepKey(_GetNodeValue(Node, 'strodep')));
      DefMLoc       := _GetNodeValue(Node, 'stlocation');
      PricePack     := _GetNodeValue(Node, 'stpricepack');
      DPackQty      := _GetNodeValue(Node, 'stshowqtyaspacks');
      KitPrice      := _GetNodeValue(Node, 'stkitprice');
      KitOnPurch    := _GetNodeValue(Node, 'stshowkitonpurchase');
      StkLinkLT     := _GetNodeValue(Node, 'stdefaultlinetype');
      QtyReturn     := _GetNodeValue(Node, 'stqtyreturn');
      QtyAllocWOR   := _GetNodeValue(Node, 'stqtyallocwor');
      QtyIssueWOR   := _GetNodeValue(Node, 'stqtyissuewor');
      WebInclude    := _GetNodeValue(Node, 'stuseforebus');
      WebLiveCat    := _GetNodeValue(Node, 'stweblivecatalog');
      WebPrevCat    := _GetNodeValue(Node, 'stwebprevcatalog');
      StkUser3      := _GetNodeValue(Node, 'stuserfield3');
      StkUser4      := _GetNodeValue(Node, 'stuserfield4');
      SerNoWAvg     := _GetNodeValue(Node, 'stsernowavg');
      StkSizeCol    := _GetNodeValue(Node, 'ststksizecol');
      SSDDUplift    := _GetNodeValue(Node, 'stssdduplift');
      SSDCountry    := _GetNodeValue(Node, 'stssdcountry');
      TimeChange    := _GetNodeValue(Node, 'sttimechange');
      SVATIncFlg    := ToChar(_GetNodeValue(Node, 'stinclusivevatcode'));
      SSDAUpLift    := _GetNodeValue(Node, 'stssdauplift');
      PrivateRec    := _GetNodeValue(Node, 'stprivaterec');
      LastOpo       := _GetNodeValue(Node, 'stoperator');
      ImageFile     := _GetNodeValue(Node, 'stimagefile');
      TempBLoc      := FullBinCode(_GetNodeValue(Node, 'sttempbloc'));
      QtyPickWOR    := _GetNodeValue(Node, 'stqtypickwor');
      WOPWIPGL      := _GetNodeValue(Node, 'stwopwipgl');
      ProdTime      := _GetNodeValue(Node, 'stprodtime');
      Leadtime      := _GetNodeValue(Node, 'stleadtime');
      CalcProdTime  := _GetNodeValue(Node, 'stcalcprodtime');
      BOMProdTime   := _GetNodeValue(Node, 'stbomprodtime');
      MinEccQty     := _GetNodeValue(Node, 'stmineccqty');
      MultiBinMode  := _GetNodeValue(Node, 'stmultibinmode');
      SWarranty     := _GetNodeValue(Node, 'stswarranty');
      SWarrantyType := _GetNodeValue(Node, 'stswarrantytype');
      MWarranty     := _GetNodeValue(Node, 'stmwarranty');
      MWarrantyType := _GetNodeValue(Node, 'stmwarrantytype');
      QtyPReturn    := _GetNodeValue(Node, 'stqtypreturn');
      ReturnGL      := _GetNodeValue(Node, 'streturngl');
      ReStockPcnt   := _GetNodeValue(Node, 'strestockpcnt');
      ReStockGL     := _GetNodeValue(Node, 'strestockgl');
      BOMDedComp    := _GetNodeValue(Node, 'stbomdedcomp');
      PReturnGL     := _GetNodeValue(Node, 'stpreturngl');
      ReStockPChr   := ToChar(_GetNodeValue(Node, 'strestockpchr'));
      Spare         := _GetNodeValue(Node, 'stspare');
      TempStr       := _GetNodeValue(Node, 'stspare2');
      Move(TempStr[1], Spare2[1], Length(Spare2));

    except
      on E:Exception Do
      begin
        Result := False;
        DoLogMessage('TStockImport.GetRecordValue',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end; { try... }
  end; { with Stock do... }

  if Result then
  begin
    { If an existing record was found, update the details... }
    if (FuncRes = 0) then
      FuncRes := Put_Rec(F[StockF], StockF, RecPtr[StockF]^, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := Add_Rec(F[StockF], StockF, RecPtr[StockF]^, 0);

    if (FuncRes <> 0) then
    begin
      DoLogMessage('TStockImport.WriteDetails: failed to save record',
                   cUPDATINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
      Result := False;
    end;
  end;

end;

// ---------------------------------------------------------------------------

end.
