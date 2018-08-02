Unit oLLinesDataWrite;

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

Interface

Uses ADODB, SysUtils, oBaseDataWrite, oDataPacket, SQLConvertUtils, GlobVar,
  BtrvU2;

Type
  TLLinesDataWrite = Class(TBaseDataWrite)
  Private
    FADOQuery : TADOQuery;
    llheadernoParam, lllinenoParam, llstockcodeParam, lldescription1Param, 
    lldescription2Param, lldescription3Param, lldescription4Param, lldescription5Param, 
    lldescription6Param, llpriceParam, llvatinclusiveParam, llvatrateParam, 
    lldisctypeParam, lldiscountParam, lldiscamountParam, lldiscdescParam, 
    llquantityParam, llserialitemParam, lldummycharParam, lllistfolionoParam, 
    llbomparentfolionoParam, llbomqtyusedParam, llbomParam, llkitlinkParam, 
    transrefnoParam, padchar1Param, linenumberParam, nomcodeParam, currencyParam, 
    padchar2Param, corateParam, vatrateParam, ccParam, depParam, stockcodeParam, 
    padchar3Param, QtyParam, qtymulParam, netvalueParam, discountParam, 
    vatcodeParam, padchar4Param, VatParam, paymentParam, discountchrParam, 
    padchar5Param, qtywoffParam, qtydelParam, costpriceParam, custcodeParam, 
    linedateParam, itemParam, descriptionParam, weightParam, mlocstkParam, 
    jobcodeParam, analcodeParam, tshccurrParam, docltlinkParam, spare3Param, 
    kitlinkParam, folionumParam, linetypeParam, reconcileParam, padchar6Param, 
    soplinkParam, soplinenoParam, abslinenoParam, lineuser1Param, lineuser2Param, 
    lineuser3Param, lineuser4Param, ssdupliftParam, ssdcommodParam, padchar7Param, 
    ssdspunitParam, ssduselineParam, padchar8Param, pricemulxParam, qtypickParam, 
    vatincflgParam, padchar9Param, qtypwoffParam, padchar10Param, rtnerrcodeParam, 
    ssdcountryParam, padchar11Param, incnetvalueParam, autolinetypeParam, 
    cisratecodeParam, padchar12Param, cisrateParam, costapportParam, nomvattypeParam, 
    padchar13Param, binqtyParam, tlaltstockfolioParam, tlrunnoParam, tlstockdeductqtyParam, 
    padchar16Param, tluseqtymulParam, tlserialqtyParam, padchar17Param, 
    tlpricebypackParam, padchar18Param, tlreconciliationdateParam, tlb2blinkfolioParam, 
    tlb2blinenoParam, tlcosdailyrateParam, tlqtypackParam, spareParam, 
    spare2Param, lastcharParam, llbomcomponentParam : TParameter;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    // Called from the SQL Write Threads to provide basic info required for SQL Execution
    Procedure Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString); Override;

    // Implemented in descendant classes to (a) populate the ADO Query with the data from the DataPacket and
    // (b) return the ADOQuery in use by the descendant
    Procedure SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean); Override;
  End; // TLLinesDataWrite

{$I w:\entrprse\dlltk\ExchDll.inc}
{$I w:\entrprse\epos\shared\layrec.Pas}

Implementation

Uses Graphics, Variants;

//=========================================================================

Constructor TLLinesDataWrite.Create;
Begin // Create
  Inherited Create;
  FADOQuery := TADOQuery.Create(NIL);
End; // Create

//------------------------------

Destructor TLLinesDataWrite.Destroy;
Begin // Destroy
  FADOQuery.Connection := Nil;
  FADOQuery.Free;
  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

// Called from the SQL Write Threads to provide basic info required for SQL Execution
Procedure TLLinesDataWrite.Prepare (Const ADOConnection : TADOConnection; Const CompanyCode : ShortString);
Var
  sqlQuery : ANSIString;
Begin // Prepare
  Inherited Prepare (ADOConnection, CompanyCode);

  // Link the ADO Connection into the Query so it can access the data
  FADOQuery.Connection := ADOConnection;

  // Setup the SQL Query and prepare it
  sqlQuery := 'INSERT INTO [COMPANY].LLines (' + 
                                             'llheaderno, ' + 
                                             'lllineno, ' + 
                                             'llstockcode, ' + 
                                             'lldescription1, ' + 
                                             'lldescription2, ' + 
                                             'lldescription3, ' + 
                                             'lldescription4, ' + 
                                             'lldescription5, ' + 
                                             'lldescription6, ' + 
                                             'llprice, ' + 
                                             'llvatinclusive, ' + 
                                             'llvatrate, ' + 
                                             'lldisctype, ' + 
                                             'lldiscount, ' + 
                                             'lldiscamount, ' + 
                                             'lldiscdesc, ' + 
                                             'llquantity, ' + 
                                             'llserialitem, ' + 
                                             'lldummychar, ' + 
                                             'lllistfoliono, ' + 
                                             'llbomparentfoliono, ' + 
                                             'llbomqtyused, ' + 
                                             'llbom, ' + 
                                             'llkitlink, ' + 
                                             'transrefno, ' + 
                                             'padchar1, ' + 
                                             'linenumber, ' + 
                                             'nomcode, ' + 
                                             'currency, ' + 
                                             'padchar2, ' +
                                             'corate, ' + 
                                             'vatrate, ' + 
                                             'cc, ' + 
                                             'dep, ' + 
                                             'stockcode, ' + 
                                             'padchar3, ' + 
                                             'Qty, ' + 
                                             'qtymul, ' + 
                                             'netvalue, ' + 
                                             'discount, ' + 
                                             'vatcode, ' + 
                                             'padchar4, ' + 
                                             'Vat, ' + 
                                             'payment, ' + 
                                             'discountchr, ' + 
                                             'padchar5, ' + 
                                             'qtywoff, ' + 
                                             'qtydel, ' + 
                                             'costprice, ' + 
                                             'custcode, ' + 
                                             'linedate, ' + 
                                             'item, ' + 
                                             'description, ' + 
                                             'weight, ' + 
                                             'mlocstk, ' + 
                                             'jobcode, ' + 
                                             'analcode, ' + 
                                             'tshccurr, ' + 
                                             'docltlink, ' + 
                                             'spare3, ' + 
                                             'kitlink, ' + 
                                             'folionum, ' + 
                                             'linetype, ' + 
                                             'reconcile, ' + 
                                             'padchar6, ' + 
                                             'soplink, ' + 
                                             'soplineno, ' + 
                                             'abslineno, ' + 
                                             'lineuser1, ' + 
                                             'lineuser2, ' +
                                             'lineuser3, ' + 
                                             'lineuser4, ' + 
                                             'ssduplift, ' + 
                                             'ssdcommod, ' + 
                                             'padchar7, ' + 
                                             'ssdspunit, ' + 
                                             'ssduseline, ' + 
                                             'padchar8, ' + 
                                             'pricemulx, ' + 
                                             'qtypick, ' + 
                                             'vatincflg, ' + 
                                             'padchar9, ' + 
                                             'qtypwoff, ' + 
                                             'padchar10, ' + 
                                             'rtnerrcode, ' + 
                                             'ssdcountry, ' + 
                                             'padchar11, ' + 
                                             'incnetvalue, ' + 
                                             'autolinetype, ' + 
                                             'cisratecode, ' + 
                                             'padchar12, ' + 
                                             'cisrate, ' + 
                                             'costapport, ' + 
                                             'nomvattype, ' + 
                                             'padchar13, ' + 
                                             'binqty, ' + 
                                             'tlaltstockfolio, ' + 
                                             'tlrunno, ' + 
                                             'tlstockdeductqty, ' + 
                                             'padchar16, ' + 
                                             'tluseqtymul, ' + 
                                             'tlserialqty, ' + 
                                             'padchar17, ' + 
                                             'tlpricebypack, ' + 
                                             'padchar18, ' + 
                                             'tlreconciliationdate, ' + 
                                             'tlb2blinkfolio, ' + 
                                             'tlb2blineno, ' + 
                                             'tlcosdailyrate, ' + 
                                             'tlqtypack, ' +
                                             'spare, ' + 
                                             'spare2, ' + 
                                             'lastchar, ' + 
                                             'llbomcomponent' + 
                                             ') ' + 
              'VALUES (' + 
                       ':llheaderno, ' + 
                       ':lllineno, ' + 
                       ':llstockcode, ' + 
                       ':lldescription1, ' + 
                       ':lldescription2, ' + 
                       ':lldescription3, ' + 
                       ':lldescription4, ' + 
                       ':lldescription5, ' + 
                       ':lldescription6, ' + 
                       ':llprice, ' + 
                       ':llvatinclusive, ' + 
                       ':llvatrate, ' + 
                       ':lldisctype, ' + 
                       ':lldiscount, ' + 
                       ':lldiscamount, ' + 
                       ':lldiscdesc, ' + 
                       ':llquantity, ' + 
                       ':llserialitem, ' + 
                       ':lldummychar, ' + 
                       ':lllistfoliono, ' + 
                       ':llbomparentfoliono, ' + 
                       ':llbomqtyused, ' + 
                       ':llbom, ' + 
                       ':llkitlink, ' + 
                       ':transrefno, ' + 
                       ':padchar1, ' + 
                       ':linenumber, ' + 
                       ':nomcode, ' + 
                       ':currency, ' + 
                       ':padchar2, ' + 
                       ':corate, ' + 
                       ':vatrate, ' + 
                       ':cc, ' + 
                       ':dep, ' +
                       ':stockcode, ' + 
                       ':padchar3, ' + 
                       ':Qty, ' + 
                       ':qtymul, ' + 
                       ':netvalue, ' + 
                       ':discount, ' + 
                       ':vatcode, ' + 
                       ':padchar4, ' + 
                       ':Vat, ' + 
                       ':payment, ' + 
                       ':discountchr, ' + 
                       ':padchar5, ' + 
                       ':qtywoff, ' + 
                       ':qtydel, ' + 
                       ':costprice, ' + 
                       ':custcode, ' + 
                       ':linedate, ' + 
                       ':item, ' + 
                       ':description, ' + 
                       ':weight, ' + 
                       ':mlocstk, ' + 
                       ':jobcode, ' + 
                       ':analcode, ' + 
                       ':tshccurr, ' + 
                       ':docltlink, ' + 
                       ':spare3, ' + 
                       ':kitlink, ' + 
                       ':folionum, ' + 
                       ':linetype, ' + 
                       ':reconcile, ' + 
                       ':padchar6, ' + 
                       ':soplink, ' + 
                       ':soplineno, ' + 
                       ':abslineno, ' + 
                       ':lineuser1, ' + 
                       ':lineuser2, ' + 
                       ':lineuser3, ' + 
                       ':lineuser4, ' + 
                       ':ssduplift, ' + 
                       ':ssdcommod, ' +
                       ':padchar7, ' + 
                       ':ssdspunit, ' + 
                       ':ssduseline, ' + 
                       ':padchar8, ' + 
                       ':pricemulx, ' + 
                       ':qtypick, ' + 
                       ':vatincflg, ' + 
                       ':padchar9, ' + 
                       ':qtypwoff, ' + 
                       ':padchar10, ' + 
                       ':rtnerrcode, ' + 
                       ':ssdcountry, ' + 
                       ':padchar11, ' + 
                       ':incnetvalue, ' + 
                       ':autolinetype, ' + 
                       ':cisratecode, ' + 
                       ':padchar12, ' + 
                       ':cisrate, ' + 
                       ':costapport, ' + 
                       ':nomvattype, ' + 
                       ':padchar13, ' + 
                       ':binqty, ' + 
                       ':tlaltstockfolio, ' + 
                       ':tlrunno, ' + 
                       ':tlstockdeductqty, ' + 
                       ':padchar16, ' + 
                       ':tluseqtymul, ' + 
                       ':tlserialqty, ' + 
                       ':padchar17, ' + 
                       ':tlpricebypack, ' + 
                       ':padchar18, ' + 
                       ':tlreconciliationdate, ' + 
                       ':tlb2blinkfolio, ' + 
                       ':tlb2blineno, ' + 
                       ':tlcosdailyrate, ' + 
                       ':tlqtypack, ' + 
                       ':spare, ' + 
                       ':spare2, ' + 
                       ':lastchar, ' + 
                       ':llbomcomponent' +
                       ')';
  FADOQuery.SQL.Text := StringReplace(sqlQuery, '[COMPANY]', '[' + Trim(CompanyCode) + ']', [rfReplaceAll]);
  FADOQuery.Prepared := True;

  // Setup references to the parameters so we can directly access them for each row instead of having
  // to search for them each time
  With FADOQuery.Parameters Do
  Begin
    llheadernoParam := FindParam('llheaderno');
    lllinenoParam := FindParam('lllineno');
    llstockcodeParam := FindParam('llstockcode');
    lldescription1Param := FindParam('lldescription1');
    lldescription2Param := FindParam('lldescription2');
    lldescription3Param := FindParam('lldescription3');
    lldescription4Param := FindParam('lldescription4');
    lldescription5Param := FindParam('lldescription5');
    lldescription6Param := FindParam('lldescription6');
    llpriceParam := FindParam('llprice');
    llvatinclusiveParam := FindParam('llvatinclusive');
    llvatrateParam := FindParam('llvatrate');
    lldisctypeParam := FindParam('lldisctype');
    lldiscountParam := FindParam('lldiscount');
    lldiscamountParam := FindParam('lldiscamount');
    lldiscdescParam := FindParam('lldiscdesc');
    llquantityParam := FindParam('llquantity');
    llserialitemParam := FindParam('llserialitem');
    lldummycharParam := FindParam('lldummychar');
    lllistfolionoParam := FindParam('lllistfoliono');
    llbomparentfolionoParam := FindParam('llbomparentfoliono');
    llbomqtyusedParam := FindParam('llbomqtyused');
    llbomParam := FindParam('llbom');
    llkitlinkParam := FindParam('llkitlink');
    transrefnoParam := FindParam('transrefno');
    padchar1Param := FindParam('padchar1');
    linenumberParam := FindParam('linenumber');
    nomcodeParam := FindParam('nomcode');
    currencyParam := FindParam('currency');
    padchar2Param := FindParam('padchar2');
    corateParam := FindParam('corate');
    vatrateParam := FindParam('vatrate');
    ccParam := FindParam('cc');
    depParam := FindParam('dep');
    stockcodeParam := FindParam('stockcode');
    padchar3Param := FindParam('padchar3');
    QtyParam := FindParam('Qty');
    qtymulParam := FindParam('qtymul');
    netvalueParam := FindParam('netvalue');
    discountParam := FindParam('discount');
    vatcodeParam := FindParam('vatcode');
    padchar4Param := FindParam('padchar4');
    VatParam := FindParam('Vat');
    paymentParam := FindParam('payment');
    discountchrParam := FindParam('discountchr');
    padchar5Param := FindParam('padchar5');
    qtywoffParam := FindParam('qtywoff');
    qtydelParam := FindParam('qtydel');
    costpriceParam := FindParam('costprice');
    custcodeParam := FindParam('custcode');
    linedateParam := FindParam('linedate');
    itemParam := FindParam('item');
    descriptionParam := FindParam('description');
    weightParam := FindParam('weight');
    mlocstkParam := FindParam('mlocstk');
    jobcodeParam := FindParam('jobcode');
    analcodeParam := FindParam('analcode');
    tshccurrParam := FindParam('tshccurr');
    docltlinkParam := FindParam('docltlink');
    spare3Param := FindParam('spare3');
    kitlinkParam := FindParam('kitlink');
    folionumParam := FindParam('folionum');
    linetypeParam := FindParam('linetype');
    reconcileParam := FindParam('reconcile');
    padchar6Param := FindParam('padchar6');
    soplinkParam := FindParam('soplink');
    soplinenoParam := FindParam('soplineno');
    abslinenoParam := FindParam('abslineno');
    lineuser1Param := FindParam('lineuser1');
    lineuser2Param := FindParam('lineuser2');
    lineuser3Param := FindParam('lineuser3');
    lineuser4Param := FindParam('lineuser4');
    ssdupliftParam := FindParam('ssduplift');
    ssdcommodParam := FindParam('ssdcommod');
    padchar7Param := FindParam('padchar7');
    ssdspunitParam := FindParam('ssdspunit');
    ssduselineParam := FindParam('ssduseline');
    padchar8Param := FindParam('padchar8');
    pricemulxParam := FindParam('pricemulx');
    qtypickParam := FindParam('qtypick');
    vatincflgParam := FindParam('vatincflg');
    padchar9Param := FindParam('padchar9');
    qtypwoffParam := FindParam('qtypwoff');
    padchar10Param := FindParam('padchar10');
    rtnerrcodeParam := FindParam('rtnerrcode');
    ssdcountryParam := FindParam('ssdcountry');
    padchar11Param := FindParam('padchar11');
    incnetvalueParam := FindParam('incnetvalue');
    autolinetypeParam := FindParam('autolinetype');
    cisratecodeParam := FindParam('cisratecode');
    padchar12Param := FindParam('padchar12');
    cisrateParam := FindParam('cisrate');
    costapportParam := FindParam('costapport');
    nomvattypeParam := FindParam('nomvattype');
    padchar13Param := FindParam('padchar13');
    binqtyParam := FindParam('binqty');
    tlaltstockfolioParam := FindParam('tlaltstockfolio');
    tlrunnoParam := FindParam('tlrunno');
    tlstockdeductqtyParam := FindParam('tlstockdeductqty');
    padchar16Param := FindParam('padchar16');
    tluseqtymulParam := FindParam('tluseqtymul');
    tlserialqtyParam := FindParam('tlserialqty');
    padchar17Param := FindParam('padchar17');
    tlpricebypackParam := FindParam('tlpricebypack');
    padchar18Param := FindParam('padchar18');
    tlreconciliationdateParam := FindParam('tlreconciliationdate');
    tlb2blinkfolioParam := FindParam('tlb2blinkfolio');
    tlb2blinenoParam := FindParam('tlb2blineno');
    tlcosdailyrateParam := FindParam('tlcosdailyrate');
    tlqtypackParam := FindParam('tlqtypack');
    spareParam := FindParam('spare');
    spare2Param := FindParam('spare2');
    lastcharParam := FindParam('lastchar');
    llbomcomponentParam := FindParam('llbomcomponent');
  End; // With FADOQuery.Parameters
End; // Prepare

//-------------------------------------------------------------------------

// Sets the values of the private parameters prior to inserting the data
Procedure TLLinesDataWrite.SetQueryValues (Var ADOQuery : TADOQuery; Const DataPacket : TDataPacket; Var SkipRecord : Boolean);
Var
  DataRec : ^TLayLineRec;
Begin // SetParameterValues
  // Return the ADOQuery instance for this data
  ADOQuery := FADOQuery;

  // Redirect the local record to point to the data buffer in the Data Packet
  DataRec := DataPacket.dpData;

  // Populate the TParameter objects with the data - which populates the Query values
  With DataRec^, llTKTLRecord Do
  Begin
    llheadernoParam.Value := llHeaderNo;                                                  // SQL=int, Delphi=LongInt
    lllinenoParam.Value := llLineNo;                                                      // SQL=int, Delphi=LongInt
    llstockcodeParam.Value := llStockCode;                                                // SQL=varchar, Delphi=String16
    lldescription1Param.Value := llDescription[1];                                        // SQL=varchar, Delphi=string[35]
    lldescription2Param.Value := llDescription[2];                                        // SQL=varchar, Delphi=string[35]
    lldescription3Param.Value := llDescription[3];                                        // SQL=varchar, Delphi=string[35]
    lldescription4Param.Value := llDescription[4];                                        // SQL=varchar, Delphi=string[35]
    lldescription5Param.Value := llDescription[5];                                        // SQL=varchar, Delphi=string[35]
    lldescription6Param.Value := llDescription[6];                                        // SQL=varchar, Delphi=string[35]
    llpriceParam.Value := llPrice;                                                        // SQL=float, Delphi=Double
    llvatinclusiveParam.Value := ConvertCharToSQLEmulatorVarChar(llVATInclusive);         // SQL=varchar, Delphi=Char
    llvatrateParam.Value := ConvertCharToSQLEmulatorVarChar(llVATRate);                   // SQL=varchar, Delphi=Char
    lldisctypeParam.Value := ConvertCharToSQLEmulatorVarChar(llDiscType);                 // SQL=varchar, Delphi=Char
    lldiscountParam.Value := llDiscount;                                                  // SQL=float, Delphi=double
    lldiscamountParam.Value := llDiscAmount;                                              // SQL=float, Delphi=Double
    lldiscdescParam.Value := llDiscDesc;                                                  // SQL=varchar, Delphi=string20
    llquantityParam.Value := llQuantity;                                                  // SQL=float, Delphi=Double
    llserialitemParam.Value := llSerialItem;                                              // SQL=bit, Delphi=Boolean
    lldummycharParam.Value := ConvertCharToSQLEmulatorVarChar(llDummyChar);               // SQL=varchar, Delphi=char
    lllistfolionoParam.Value := llListFolioNo;                                            // SQL=int, Delphi=integer
    llbomparentfolionoParam.Value := llBOMParentFolioNo;                                  // SQL=int, Delphi=integer
    llbomqtyusedParam.Value := llBOMQtyUsed;                                              // SQL=float, Delphi=Double
    llbomParam.Value := llBOM;                                                            // SQL=bit, Delphi=boolean
    llkitlinkParam.Value := llKitLink;                                                    // SQL=int, Delphi=integer
    transrefnoParam.Value := TransRefNo;                                                  // SQL=varchar, Delphi=String[9]
    // *** BINARY ***
    padchar1Param.Value := CreateVariantArray (@PadChar1, SizeOf(PadChar1));// SQL=varbinary, Delphi=Array[1..2] Of Char
    linenumberParam.Value := LineNo;                                                      // SQL=int, Delphi=LongInt
    nomcodeParam.Value := NomCode;                                                        // SQL=int, Delphi=LongInt
    currencyParam.Value := Currency;                                                      // SQL=int, Delphi=SmallInt
    // *** BINARY ***
    padchar2Param.Value := CreateVariantArray (@PadChar2, SizeOf(PadChar2));// SQL=varbinary, Delphi=Array[1..2] Of Char
    corateParam.Value := CoRate;                                                          // SQL=float, Delphi=Double
    vatrateParam.Value := VATRate;                                                        // SQL=float, Delphi=Double
    ccParam.Value := CC;                                                                  // SQL=varchar, Delphi=String[3]
    depParam.Value := Dep;                                                                // SQL=varchar, Delphi=String[3]
    stockcodeParam.Value := StockCode;                                                    // SQL=varchar, Delphi=String[16]
    // *** BINARY ***
    padchar3Param.Value := CreateVariantArray (@PadChar3, SizeOf(PadChar3));// SQL=varbinary, Delphi=Array[1..3] Of Char
    QtyParam.Value := Qty;                                                                // SQL=float, Delphi=Double
    qtymulParam.Value := QtyMul;                                                          // SQL=float, Delphi=Double
    netvalueParam.Value := NetValue;                                                      // SQL=float, Delphi=Double
    discountParam.Value := Discount;                                                      // SQL=float, Delphi=Double
    vatcodeParam.Value := ConvertCharToSQLEmulatorVarChar(VATCode);                       // SQL=varchar, Delphi=Char
    // *** BINARY ***
    padchar4Param.Value := CreateVariantArray (@PadChar4, SizeOf(PadChar4));// SQL=varbinary, Delphi=Array[1..3] Of Char
    VatParam.Value := VAT;                                                                // SQL=float, Delphi=Double
    paymentParam.Value := Payment;                                                        // SQL=int, Delphi=WordBool
    discountchrParam.Value := ConvertCharToSQLEmulatorVarChar(DiscountChr);               // SQL=varchar, Delphi=Char
    padchar5Param.Value := ConvertCharToSQLEmulatorVarChar(PadChar5);                     // SQL=varchar, Delphi=Char
    qtywoffParam.Value := QtyWOFF;                                                        // SQL=float, Delphi=Double
    qtydelParam.Value := QtyDel;                                                          // SQL=float, Delphi=Double
    costpriceParam.Value := CostPrice;                                                    // SQL=float, Delphi=Double
    custcodeParam.Value := CustCode;                                                      // SQL=varchar, Delphi=String[6]
    linedateParam.Value := LineDate;                                                      // SQL=varchar, Delphi=String[8]
    itemParam.Value := Item;                                                              // SQL=varchar, Delphi=String[3]
    descriptionParam.Value := Desc;                                                       // SQL=varchar, Delphi=String[55]
    weightParam.Value := LWeight;                                                         // SQL=float, Delphi=Double
    mlocstkParam.Value := MLocStk;                                                        // SQL=varchar, Delphi=String[3]
    jobcodeParam.Value := JobCode;                                                        // SQL=varchar, Delphi=String[10]
    analcodeParam.Value := AnalCode;                                                      // SQL=varchar, Delphi=String[10]
    tshccurrParam.Value := TSHCCurr;                                                      // SQL=int, Delphi=SmallInt
    docltlinkParam.Value := DocLTLink;                                                    // SQL=int, Delphi=SmallInt
    // *** BINARY ***
    spare3Param.Value := CreateVariantArray (@Spare3, SizeOf(Spare3));     // SQL=varbinary, Delphi=Array[1..2] Of Char
    kitlinkParam.Value := KitLink;                                                        // SQL=int, Delphi=LongInt
    folionumParam.Value := FolioNum;                                                      // SQL=int, Delphi=LongInt
    linetypeParam.Value := ConvertCharToSQLEmulatorVarChar(LineType);                     // SQL=varchar, Delphi=Char
    reconcileParam.Value := Reconcile;                                                    // SQL=int, Delphi=Byte
    // *** BINARY ***
    padchar6Param.Value := CreateVariantArray (@PadChar6, SizeOf(PadChar6));// SQL=varbinary, Delphi=Array [1..2] Of Byte
    soplinkParam.Value := SOPLink;                                                        // SQL=int, Delphi=LongInt
    soplinenoParam.Value := SOPLineNo;                                                    // SQL=int, Delphi=LongInt
    abslinenoParam.Value := ABSLineNo;                                                    // SQL=int, Delphi=LongInt
    lineuser1Param.Value := LineUser1;                                                    // SQL=varchar, Delphi=String[30]
    lineuser2Param.Value := LineUser2;                                                    // SQL=varchar, Delphi=String[30]
    lineuser3Param.Value := LineUser3;                                                    // SQL=varchar, Delphi=String[30]
    lineuser4Param.Value := LineUser4;                                                    // SQL=varchar, Delphi=String[30]
    ssdupliftParam.Value := SSDUplift;                                                    // SQL=float, Delphi=Double
    ssdcommodParam.Value := SSDCommod;                                                    // SQL=varchar, Delphi=String[8]
    // *** BINARY ***
    padchar7Param.Value := CreateVariantArray (@PadChar7, SizeOf(PadChar7));// SQL=varbinary, Delphi=Array[1..3] of Char
    ssdspunitParam.Value := SSDSPUnit;                                                    // SQL=float, Delphi=Double
    ssduselineParam.Value := SSDUseLine;                                                  // SQL=int, Delphi=WordBool
    // *** BINARY ***
    padchar8Param.Value := CreateVariantArray (@PadChar8, SizeOf(PadChar8));// SQL=varbinary, Delphi=Array[1..2] of Char
    pricemulxParam.Value := PriceMulx;                                                    // SQL=float, Delphi=Double
    qtypickParam.Value := QtyPick;                                                        // SQL=float, Delphi=Double
    vatincflgParam.Value := ConvertCharToSQLEmulatorVarChar(VATIncFlg);                   // SQL=varchar, Delphi=Char
    // *** BINARY ***
    padchar9Param.Value := CreateVariantArray (@PadChar9, SizeOf(PadChar9));// SQL=varbinary, Delphi=Array[1..3] of Char
    qtypwoffParam.Value := QtyPWOff;                                                      // SQL=float, Delphi=Double
    // *** BINARY ***
    padchar10Param.Value := CreateVariantArray (@PadChar10, SizeOf(PadChar10));// SQL=varbinary, Delphi=Array[1..2] of Char
    rtnerrcodeParam.Value := RtnErrCode;                                                  // SQL=int, Delphi=SmallInt
    ssdcountryParam.Value := SSDCountry;                                                  // SQL=varchar, Delphi=string[5]
    // *** BINARY ***
    padchar11Param.Value := CreateVariantArray (@PadChar11, SizeOf(PadChar11));// SQL=varbinary, Delphi=Array[1..2] of Char
    incnetvalueParam.Value := IncNetValue;                                                // SQL=float, Delphi=Double
    autolinetypeParam.Value := AutoLineType;                                              // SQL=int, Delphi=Byte
    cisratecodeParam.Value := ConvertCharToSQLEmulatorVarChar(CISRateCode);               // SQL=varchar, Delphi=Char
    // *** BINARY ***
    padchar12Param.Value := CreateVariantArray (@PadChar12, SizeOf(PadChar12));// SQL=varbinary, Delphi=Array[1..2] of Char
    cisrateParam.Value := CISRate;                                                        // SQL=float, Delphi=Double
    costapportParam.Value := CostApport;                                                  // SQL=float, Delphi=Double
    nomvattypeParam.Value := NOMVatType;                                                  // SQL=int, Delphi=Byte
    // *** BINARY ***
    padchar13Param.Value := CreateVariantArray (@PadChar13, SizeOf(PadChar13));// SQL=varbinary, Delphi=Array[1..3] of Char
    binqtyParam.Value := BinQty;                                                          // SQL=float, Delphi=Double
    tlaltstockfolioParam.Value := tlAltStockFolio;                                        // SQL=int, Delphi=longint
    tlrunnoParam.Value := tlRunNo;                                                        // SQL=int, Delphi=longint
    tlstockdeductqtyParam.Value := tlStockDeductQty;                                      // SQL=float, Delphi=Double
    // *** BINARY ***
    padchar16Param.Value := CreateVariantArray (@PadChar16, SizeOf(PadChar16));// SQL=varbinary, Delphi=Array[1..2] of Char
    tluseqtymulParam.Value := tlUseQtyMul;                                                // SQL=int, Delphi=WordBool
    tlserialqtyParam.Value := tlSerialQty;                                                // SQL=float, Delphi=Double
    // *** BINARY ***
    padchar17Param.Value := CreateVariantArray (@PadChar17, SizeOf(PadChar17));// SQL=varbinary, Delphi=Array[1..2] of Char
    tlpricebypackParam.Value := tlPriceByPack;                                            // SQL=int, Delphi=WordBool
    // *** BINARY ***
    padchar18Param.Value := CreateVariantArray (@PadChar18, SizeOf(PadChar18));// SQL=varbinary, Delphi=Array[1..3] of Char
    tlreconciliationdateParam.Value := tlReconciliationDate;                              // SQL=varchar, Delphi=String[8]
    tlb2blinkfolioParam.Value := tlB2BLinkFolio;                                          // SQL=int, Delphi=LongInt
    tlb2blinenoParam.Value := tlB2BLineNo;                                                // SQL=int, Delphi=longint
    tlcosdailyrateParam.Value := tlCOSDailyRate;                                          // SQL=float, Delphi=Double
    tlqtypackParam.Value := tlQtyPack;                                                    // SQL=float, Delphi=Double
    // *** BINARY ***
    spareParam.Value := CreateVariantArray (@Spare, SizeOf(Spare));        // SQL=varbinary, Delphi=array[1..176] of Char:
    // *** BINARY ***
    spare2Param.Value := CreateVariantArray (@Spare2, SizeOf(Spare2));     // SQL=varbinary, Delphi=Array[1..3] Of char
    lastcharParam.Value := ConvertCharToSQLEmulatorVarChar(LastChar);                     // SQL=varchar, Delphi=Char
    llbomcomponentParam.Value := llBOMComponent;                                          // SQL=bit, Delphi=boolean
  End; // With DataRec^
End; // SetParameterValues

//=========================================================================

End.

