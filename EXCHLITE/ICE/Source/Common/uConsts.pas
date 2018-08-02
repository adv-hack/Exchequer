 {-----------------------------------------------------------------------------
 Unit Name: uConsts
 Author:    vmoura
 Purpose:
 History:

 CipherMode

The cipher mode determines how TBlowfish will handle the encryption or
decryption of multiple blocks of data. For a full explaination of the various modes,
see ECB (Electronic Code Book), CBC (Cipher Block Chaining), CFB (Cipher FeedBack) and
OFB (Output FeedBack).

The definition of the CipherMode type is:
type TCipherMode = (CBC, ECB, CFB, OFB);
                   ( 0    1    2    3 )


14/12/2006

the application name has changed from Client Sync to ClientLink                   
-----------------------------------------------------------------------------}
Unit uConsts;

Interface

Uses Windows;

(*
Uses
  blowfish;

{$I exdllbt.inc}

{$I exchdll.inc}
*)

Const

  {similar to X:\ENTRPRSE\FORMDES2\history.pas}
  //cEXVERSION = 'b5.71'; // beta
  //cEXVERSION = 'v5.71'; // release
  {$IFDEF DASH600}
  cEXVERSION = 'v2017R2'; // release
  cHELPFILE = 'dashboard.chm';
  {$ELSE}
  cEXVERSION = 'v7.0.8'; // release
  cHELPFILE = 'DASHBOARD.HLP';
  {$ENDIF}

  //cIAOVERSION = 'b1.00'; //beta
  cIAOVERSION = 'v1.10';   // release

  cDASHBUILD = '.005';
  cDSRBUILD = '.008';

Type

  TCCDeptExportType = (cdExportCostCentres, cdExportDepartments);
  TCustSuppExportType = (csExportCustomers, csExportSuppliers);
  TCCDeptImportType = (cdImportCostCentres, cdImportDepartments);
  TCustSuppImportType = (csImportCustomers, csImportSuppliers);

  TDataTransportDetails = Record
    ID: Integer;
    Title: String;
    BaseFile: String;
    Importer: String; // Name of the import automation object.
    Exporter: String; // Name of the export automation object.
  End;

  TErrorDetails = Record
    ErrNo: Integer;
    Msg: String;
  End;

  TStatusDetails = Record
    StatusNro: Integer;
    Msg: String;
  End;

  TProductName = Record
    ProductNro: Integer;
    Name: String;
  End;

  TCISTaxRate = record
    TaxNo: Integer;
    Name: String;
  end;

Const
  // crc32 calculation
  TableCRC32: Array[0..255] Of DWORD =
  ($00000000, $77073096, $EE0E612C, $990951BA,
    $076DC419, $706AF48F, $E963A535, $9E6495A3,
    $0EDB8832, $79DCB8A4, $E0D5E91E, $97D2D988,
    $09B64C2B, $7EB17CBD, $E7B82D07, $90BF1D91,
    $1DB71064, $6AB020F2, $F3B97148, $84BE41DE,
    $1ADAD47D, $6DDDE4EB, $F4D4B551, $83D385C7,
    $136C9856, $646BA8C0, $FD62F97A, $8A65C9EC,
    $14015C4F, $63066CD9, $FA0F3D63, $8D080DF5,
    $3B6E20C8, $4C69105E, $D56041E4, $A2677172,
    $3C03E4D1, $4B04D447, $D20D85FD, $A50AB56B,
    $35B5A8FA, $42B2986C, $DBBBC9D6, $ACBCF940,
    $32D86CE3, $45DF5C75, $DCD60DCF, $ABD13D59,
    $26D930AC, $51DE003A, $C8D75180, $BFD06116,
    $21B4F4B5, $56B3C423, $CFBA9599, $B8BDA50F,
    $2802B89E, $5F058808, $C60CD9B2, $B10BE924,
    $2F6F7C87, $58684C11, $C1611DAB, $B6662D3D,

    $76DC4190, $01DB7106, $98D220BC, $EFD5102A,
    $71B18589, $06B6B51F, $9FBFE4A5, $E8B8D433,
    $7807C9A2, $0F00F934, $9609A88E, $E10E9818,
    $7F6A0DBB, $086D3D2D, $91646C97, $E6635C01,
    $6B6B51F4, $1C6C6162, $856530D8, $F262004E,
    $6C0695ED, $1B01A57B, $8208F4C1, $F50FC457,
    $65B0D9C6, $12B7E950, $8BBEB8EA, $FCB9887C,
    $62DD1DDF, $15DA2D49, $8CD37CF3, $FBD44C65,
    $4DB26158, $3AB551CE, $A3BC0074, $D4BB30E2,
    $4ADFA541, $3DD895D7, $A4D1C46D, $D3D6F4FB,
    $4369E96A, $346ED9FC, $AD678846, $DA60B8D0,
    $44042D73, $33031DE5, $AA0A4C5F, $DD0D7CC9,
    $5005713C, $270241AA, $BE0B1010, $C90C2086,
    $5768B525, $206F85B3, $B966D409, $CE61E49F,
    $5EDEF90E, $29D9C998, $B0D09822, $C7D7A8B4,
    $59B33D17, $2EB40D81, $B7BD5C3B, $C0BA6CAD,

    $EDB88320, $9ABFB3B6, $03B6E20C, $74B1D29A,
    $EAD54739, $9DD277AF, $04DB2615, $73DC1683,
    $E3630B12, $94643B84, $0D6D6A3E, $7A6A5AA8,
    $E40ECF0B, $9309FF9D, $0A00AE27, $7D079EB1,
    $F00F9344, $8708A3D2, $1E01F268, $6906C2FE,
    $F762575D, $806567CB, $196C3671, $6E6B06E7,
    $FED41B76, $89D32BE0, $10DA7A5A, $67DD4ACC,
    $F9B9DF6F, $8EBEEFF9, $17B7BE43, $60B08ED5,
    $D6D6A3E8, $A1D1937E, $38D8C2C4, $4FDFF252,
    $D1BB67F1, $A6BC5767, $3FB506DD, $48B2364B,
    $D80D2BDA, $AF0A1B4C, $36034AF6, $41047A60,
    $DF60EFC3, $A867DF55, $316E8EEF, $4669BE79,
    $CB61B38C, $BC66831A, $256FD2A0, $5268E236,
    $CC0C7795, $BB0B4703, $220216B9, $5505262F,
    $C5BA3BBE, $B2BD0B28, $2BB45A92, $5CB36A04,
    $C2D7FFA7, $B5D0CF31, $2CD99E8B, $5BDEAE1D,

    $9B64C2B0, $EC63F226, $756AA39C, $026D930A,
    $9C0906A9, $EB0E363F, $72076785, $05005713,
    $95BF4A82, $E2B87A14, $7BB12BAE, $0CB61B38,
    $92D28E9B, $E5D5BE0D, $7CDCEFB7, $0BDBDF21,
    $86D3D2D4, $F1D4E242, $68DDB3F8, $1FDA836E,
    $81BE16CD, $F6B9265B, $6FB077E1, $18B74777,
    $88085AE6, $FF0F6A70, $66063BCA, $11010B5C,
    $8F659EFF, $F862AE69, $616BFFD3, $166CCF45,
    $A00AE278, $D70DD2EE, $4E048354, $3903B3C2,
    $A7672661, $D06016F7, $4969474D, $3E6E77DB,
    $AED16A4A, $D9D65ADC, $40DF0B66, $37D83BF0,
    $A9BCAE53, $DEBB9EC5, $47B2CF7F, $30B5FFE9,
    $BDBDF21C, $CABAC28A, $53B39330, $24B4A3A6,
    $BAD03605, $CDD70693, $54DE5729, $23D967BF,
    $B3667A2E, $C4614AB8, $5D681B02, $2A6F2B94,
    $B40BBE37, $C30C8EA1, $5A05DF1B, $2D02EF8D);

  //cSQLIRISSERVICE = 'MSSQL$IRISSOFTWARE';
  cDEFAULTSQLSERVERNAME = 'MSSQLSERVER';
  cSQLIRISSERVICE = 'MSSQL$%s';
  cDSRSERVICE = 'DSRWrapperServer';
  cWRAPPEREXE = 'wrapperdsrserver.exe';
  cDSRPORTPARAM = 'DSRPort';
  cICEDATABASEFILE = 'IRISCommunicationEngine.mdf';
  cICEDATABASEFILELOG = 'IRISCommunicationEngine_log.LDF';
  cICEDATABASE = 'IRISCommunicationEngine';

//  cDSROUTGOING = 'B53DD5E9-35A8-4B03-990F-7E4CD88D16E1';
//  cDSRINCOMING = 'E3D204B8-390E-4B99-9575-309E5FEE3598';

  // email supporting
  cMAPI = 'MAPI';
  cPOP3 = 'POP3';
  cIMAP = 'IMAP';
  c3RDPRT = '3rdPRT';
  cCIS = 'CIS';
  

  {dashboard}
  cDashNew = 'Inbox New';
  cDashInbox = 'Inbox';
  cDashSent = 'Sent Items';
  cDashOutbox = 'Outbox';
  cDashRecycle = 'Deleted/Failed';
  cADMINUSER = 'manager';
  cSYSTEMUSER = 'system';
  cADMINPASS = 'rD08UGXc-go';  // encrypted password
                 
  cDEFAULTDSRPORT = 6505;

  cPOP3DEFAULTPORT = 110;
  cSMTPDEFAULTPORT = 25;
  

  {timings}
  cDEFAULTPAUSE = 1000; //  1 sec

  cDSRINTERVAL = 15 * cDEFAULTPAUSE;
  cDSRPRODUCERINTERVAL = 10 * cDEFAULTPAUSE;

  {x min * 60 seg * 1000 msec}
  cDSRCHEKMAILINTERVAL = 1 * 60 * cDEFAULTPAUSE;
  cDSRDRIPFEEDINTERVAL = 60 * 60 * cDEFAULTPAUSE;

  cDSRCHECKEMAILEVENT = 'DSRCheckEMailEvent';

  {type of crypto and keys from}
  cCryptoMode = 1; //ECB;
  cCryptoV = 'D2bb9DC2CA49';
  cCryptoKey = 'A812C2D1e62b';

  cGUIDREF = '{F4268284-90A3-432B-96AA-68F07856BCD2}';
  cMSGBODY = '{88D58076-829D-47F5-916D-864F7883C369}';
  cCLIENTSYNCEMAILTEST = 'ClientLink E-mail Test';

  cXMLEXT = '.xml';
  cXSLEXT = '.xsl';
  cXSDEXT = '.xsd';
  cACKEXT = '.ack';
  cNACKEXT = '.nck';
  cDBBACKUPEXT = '.bck';
  cACKSUBJECT = 'ACK:';
  cNACKSUBJECT = 'NACK:';
  cACKFILE = '1.ack';

  cXMLDIR = 'XMLDIR';
  cXSDDIR = 'XSDDIR';
  cXSLDIR = 'XSLDIR';
  cPLUGINSDIR = 'PLUGINS';
  cTEMPDIR = 'SWAP';
  cBULKDIR = 'BULK';
//  cADDONDIR = 'ADDON';
  cICEFOLDER = 'ICS'; // For storing transaction-edit tracking info and
                      // exported XML files.
  cDBBACKUP = 'BACKUP';
  cEMAILSYSTEMDIR = 'ESystem';

  // xml special characters and stuff

  cXMLCDATATAG = '<![CDATA[%s]]>';
  cXMLLessThan = '&lt;';
  cXMLAmpersand = '&amp;';
  cXMLGreaterThan = '&gt;';
  cXMLQuot = '&quot;';
  cXMLApostrophe = '&apos;';

  cTextLessThan = '<';
  cTextAmpersand = '&';
  cTextGreaterThan = '>';
  cTextQuot = '"';
  cTextApostrophe = '''';

  cMSXML = 'Microsoft.XMLDOM';
  cMSXML40 = 'Msxml2.DOMDocument.4.0';
  cMSXML40SCHEMA = 'Msxml2.XMLSchemaCache.4.0';
  cMSXMLISO88591 = 'ISO-8859-1';
  cMSXMLUTF8 = 'UTF-8';

  cLogDir = 'Logs';
  cLogFileExt = '.txt';
  cBULKEXPORTINI = 'bulk.ini';
  cINBOXDIR = 'Inbox';
  cOUTBOXDIR = 'Outbox';
  cDASHBOARDINI = 'dashboard.ini';
  cDSRINI = 'dsr.ini';
  cMAILINI = 'mail.ini';
  cDSRIMP = 'DSRimp.exe';
  cCISINI = 'cis.ini';
  cCISRECEIVER = 'CISReceiver.exe';
  cDSRDOWNLOAD = 'DSRDownload.exe';
  cDSRDOWNLOADGUID = '{C227B4B6-63C0-446D-A46A-82D0FC33EE6A}';
  cDSRLOCKFILE = 'dsr.lok';
  cDSRUPDATEDBFILE = 'updatedb.udb';
  cDSRCREATEDBFILE = 'createdb.udb';
  cEXPRODTYPEPARAM = 'ExProdType';
  cCOMPANYNAMEPARAM = 'CompanyName';
  cDEFAULTEMAILPARAM = 'DefaultEmail';
  cSHOWREMINDERPARAM = 'ShowReminder';
  cSHOWALERTPARAM = 'ShowAlert';
  cPOLLINGTIMEPARAM = 'PollingTime';
  cDELETENONDSREMAILPARAM = 'DeleteNonDSR'; 
  cCLEARSENTBOXPARAM = 'ClearSentBox';

  // generical consts
  CRLF = #13 + #10;
  cPIPE = '|';

  // exchequer tables consts
  cCUSTTABLE = 1;
  cSUPPLIERTABLE = 2;
  cVATTABLE = 3;
  cCURRENCYTABLE = 4;
  cCOSTCENTRETABLE = 5;
  cDEPTTABLE = 6;
  cDOCNUMBERSTABLE = 7;
  cGLCODETABLE = 8;
  cGLSTRUCTURETABLE = 9;
  cTRANSACTIONTABLE = 10;
  cSTOCKTABLE = 11;
  cMATCHINGTABLE = 12;
  cSYSTEMSETTINGSTABLE = 13;
  cHISTORYTABLE = 14;
  cPERIODTABLE = 15; // Actually, the user-defined periods INI file
  cVERSIONTABLE = 16; // Actually, the Enterprise Licence details
  cOPENINGBALANCETABLE = 17; // Additional Transactions, making up Opening Balance
  cOBMATCHINGTABLE = 18; // Matching records for Opening Balances
  cGGW = 500;

  cEXPORTERCOMOBJECT = 'IrisClientSync';
  cIMPORTERCOMOBJECT = 'IrisClientSync';
  cSYSTEMEXPORTERAUTOOBJECT = 'SystemDataExporter';
  cSYSTEMIMPORTERAUTOOBJECT = 'SystemDataImporter';
  cSTATICEXPORTERAUTOOBJECT = 'StaticDataExporter';
  cSTATICIMPORTERAUTOOBJECT = 'StaticDataImporter';
  cTRANSEXPORTERAUTOOBJECT = 'TransactionDataExporter';
  cTRANSIMPORTERAUTOOBJECT = 'TransactionDataImporter';
  cMATCHEXPORTERAUTOOBJECT = 'MatchingDataExporter';
  cMATCHIMPORTERAUTOOBJECT = 'MatchingDataImporter';
  cDRIPFEEDEXPORTERAUTOOBJECT = 'DripfeedDataExporter';
  cDRIPFEEDIMPORTERAUTOOBJECT = 'DripfeedDataImporter';

  // Do not access this array directly -- use the _GetDataTransportDetails
  // function in uCommon.pas.
  DataTransportList: Array[0..17] Of TDataTransportDetails =
  (
    (ID: cVATTABLE; Title: 'VAT'; BaseFile: 'vat';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cCURRENCYTABLE; Title: 'Currency'; BaseFile: 'curr';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cCOSTCENTRETABLE; Title: 'Cost Centres'; BaseFile: 'costcent';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cDEPTTABLE; Title: 'Departments'; BaseFile: 'dept';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cDOCNUMBERSTABLE; Title: 'Doc Numbers'; BaseFile: 'docnumber';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cGLCODETABLE; Title: 'G/L Codes'; BaseFile: 'glcode';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cGLSTRUCTURETABLE; Title: 'G/L Structure'; BaseFile: 'glstructure';
    Importer: cSTATICIMPORTERAUTOOBJECT; Exporter: cSTATICEXPORTERAUTOOBJECT),
    (ID: cCUSTTABLE; Title: 'Customers'; BaseFile: 'cust';
    Importer: cSTATICIMPORTERAUTOOBJECT; Exporter: cSTATICEXPORTERAUTOOBJECT),
    (ID: cSUPPLIERTABLE; Title: 'Suppliers'; BaseFile: 'supp';
    Importer: cSTATICIMPORTERAUTOOBJECT; Exporter: cSTATICEXPORTERAUTOOBJECT),
    (ID: cSTOCKTABLE; Title: 'Stock Items'; BaseFile: 'stock';
    Importer: cSTATICIMPORTERAUTOOBJECT; Exporter: cSTATICEXPORTERAUTOOBJECT),
    (ID: cTRANSACTIONTABLE; Title: 'Transactions'; BaseFile: 'trans';
    Importer: cTRANSIMPORTERAUTOOBJECT; Exporter: cTRANSEXPORTERAUTOOBJECT),
    (ID: cMATCHINGTABLE; Title: 'Matching'; BaseFile: 'match';
    Importer: cMATCHIMPORTERAUTOOBJECT; Exporter: cMATCHEXPORTERAUTOOBJECT),
    (ID: cSYSTEMSETTINGSTABLE; Title: 'Settings'; BaseFile: 'system';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cHISTORYTABLE; Title: 'History'; BaseFile: 'history';
    Importer: cTRANSIMPORTERAUTOOBJECT; Exporter: cTRANSEXPORTERAUTOOBJECT),
    (ID: cPERIODTABLE; Title: 'Periods'; BaseFile: 'periods';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cVERSIONTABLE; Title: 'Version'; BaseFile: 'version';
    Importer: cSYSTEMIMPORTERAUTOOBJECT; Exporter: cSYSTEMEXPORTERAUTOOBJECT),
    (ID: cOPENINGBALANCETABLE; Title: 'Opening Balance'; BaseFile: 'obal';
    Importer: cTRANSIMPORTERAUTOOBJECT; Exporter: cTRANSEXPORTERAUTOOBJECT),
    (ID: cOBMATCHINGTABLE; Title: 'O/B Matching'; BaseFile: 'match';
    Importer: cTRANSIMPORTERAUTOOBJECT; Exporter: cTRANSEXPORTERAUTOOBJECT)
    );

  // Document types exported/imported by ICE.
  ICEDocCodes: String =
  'NOM SIN SJI SJC SRF SRC SCR SRI PIN PJI PJC PPI PRF PCR PPY SBT PBT';
  ICEPracticeDocCodes: String =
  'NOM ';

  // dsr main import/export interfaces
  cDEFAULT_EXPORT_BOX = 'DSRExport.dll';
  cDEFAULT_IMPORT_BOX = 'DSRImport.dll';

  cCLIENTSYNC_BACKUP = 'CSBackup.exe';

  // the usual connection
  cADOCONNECTIONSTR1 =
    //'Data Source=%s\IRISSOFTWARE;Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=IrisCommunicationEngine';
    // the new DASH600 actualy uses server\instance name...
    'Data Source=%s;Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=IrisCommunicationEngine';

  cADOCONNECTIONSTR2 =
    'Data Source=%s;Provider=SQLOLEDB.1;Password=%s;Persist Security Info=True;User ID=%s;Initial Catalog=IrisCommunicationEngine';

  cADOCONNECTIONSTRMASTERUSERICE =
    'Provider=SQLOLEDB.1;Integrated Security=SSPI;User ID=GHJHyhjghIRISICEhdskjJ432!;Password=HGjkyuifdsnjkUH765iuHJ!;Persist Security Info=False;Initial Catalog=master;Data Source=%s\IRISSOFTWARE';

  cADOCONNECTIONMASTER = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=master;Data Source=%s'; 

  // ice database
  cICEDBUSER = 'GHJHyhjghIRISICEhdskjJ432!';
  cICEDBPWD = 'HGjkyuifdsnjkUH765iuHJ!';

  {log life time (both txt and db) in days}
  cLOGTIMELIFE = 7;



  cCONFTABLE = 'config';
  cCOMPANYTABLE = 'company';
  cSYSTEMTABLE = 'system';

  { inbox/outbox status values }
  cNEWENTRY = 0; //'New File';
  cREADYIMPORT = 1; //'Ready for Import';
  cDELETED = 2; //'Deleted';
  cPROCESSED = 3; //'Processed';
  cSAVED = 4; //'Saved';
  cSENT = 5; //'Sent';
  cPENDING = 6; //'Pending'
  cFAILED = 7; // failure
  cRECEIVED = 8; // received messages
  cPROCESSING = 9; // doing something
  cRECEIVINGDATA = 10; // receiving files
  cPOPULATING = 11; // importing something
  cARCHIVED = 12; // option to remove from the interface
  cREMOVESYNC = 13; // end of sync requested
  cSYNCDENIED = 14; // the sync has been denied
  cSYNCFAILED = 15; // the sync has failed
  cSYNCACCEPTED = 16; // sync has been accepted
  cNODATASENT = 17; // no data has been sent
  cBULKFAILED = 18; // bulk has failed
  cBULKPROCESSED = 19; // bulk was processed
  cBULKPROCESSING = 20; // bulk processing
  cDRIPFEEDFAILED = 21; // dripfeed has been failed
  cCISSENT = 22; // the message has been sent to the GGW
  cACKNOWLEDGE = 23;
  cCANCELLED = 24; // the process has been cancelled while it was being processed
  cDRIPFEEDCANCELLED = 25;
  cLOADINGFILES = 26; // loading files from disk or loading from plug-ins
  cSENDING = 27; // sending process
  cCHECKING = 28; // when the files are being validated and ready to go...
  cRESTORED = 29;  // when a message (outbox) has been restored from a deleted status

  StatusDetails: Array[0..29] Of TStatusDetails =
  (
    (StatusNro: cNEWENTRY; Msg: 'New file(s)'),
    (StatusNro: cREADYIMPORT; Msg: 'Ready to Import'),
    (StatusNro: cDELETED; Msg: 'Deleted'),
    (StatusNro: cPROCESSED; Msg: 'Processed'),
    (StatusNro: cSAVED; Msg: 'Saved'),
    (StatusNro: cSENT; Msg: 'Sent'),
    (StatusNro: cPENDING; Msg: 'Waiting Response...'),
    (StatusNro: cFAILED; Msg: 'Failed'),
    (StatusNro: cRECEIVED; Msg: 'Received'),
    (StatusNro: cPROCESSING; Msg: 'Processing...'),
    (StatusNro: cRECEIVINGDATA; Msg: 'Receiving Client Data...'),
    (StatusNro: cPOPULATING; Msg: 'Populating Client...'),
    (StatusNro: cARCHIVED; Msg: 'Archived'),
    //(StatusNro: cREMOVESYNC; Msg: 'End of Dripfeed'),
    (StatusNro: cREMOVESYNC; Msg: 'End of Link'),
    //(StatusNro: cSYNCDENIED; Msg: 'Dripfeed Denied'),
    (StatusNro: cSYNCDENIED; Msg: 'Link Denied'),
    //(StatusNro: cSYNCFAILED; Msg: 'Dripfeed Failed'),
    (StatusNro: cSYNCFAILED; Msg: 'Link Failed'),
    //(StatusNro: cSYNCACCEPTED; Msg: 'Dripfeed Accepted'),
    (StatusNro: cSYNCACCEPTED; Msg: 'Link Accepted'),
    (StatusNro: cNODATASENT; Msg: 'No Data Sent'),
    (StatusNro: cBULKFAILED; Msg: 'Bulk failed'),
    (StatusNro: cBULKPROCESSED; Msg: 'Bulk processed'),
    (StatusNro: cBULKPROCESSING; Msg: 'Processing...'),
    //(StatusNro: cDRIPFEEDFAILED; Msg: 'Dripfeed import failed'),
    (StatusNro: cDRIPFEEDFAILED; Msg: 'Link import failed'),
    (StatusNro: cCISSENT; Msg: 'CIS XML Sent'),
    (StatusNro: cACKNOWLEDGE; Msg: 'Acknowledge'),
    (StatusNro: cCANCELLED; Msg: 'Cancelled'),
    //(StatusNro: cDRIPFEEDCANCELLED; Msg: 'Dripfeed Cancelled'),
    (StatusNro: cDRIPFEEDCANCELLED; Msg: 'Link Cancelled'),
    (StatusNro: cLOADINGFILES; Msg: 'Loading files...'),
    (StatusNro: cSENDING; Msg: 'Sending files...'),
    (StatusNro: cCHECKING; Msg: 'Checking files...'),
    (StatusNro: cRESTORED; Msg: 'Restored')
    );


  cCLIENTLINK = 'ClientLink';
  { CJS - 2013-07-17 - ABSEXCH-14438 - updated branding and copyright }
  cIRISGOVLINK = 'Exchequer GovLink';
  cEXCHEQUER = 'Exchequer';

  cCLIENTLINKNAME = 0;
  cCISNAME = 1;
  cExchequerName = 2;

  ProductName: array[0..2] of TProductName =
  (
    (ProductNro: cCLIENTLINKNAME; Name: cCLIENTLINK),
    (ProductNro: cCISNAME; Name: cIRISGOVLINK),
    (ProductNro: cExchequerName; Name: cEXCHEQUER)
  );

  cALLNEW = 99; // look for new entries and ready to import
  cALLRECYCLE = 100; // deleted and failed

  {nacks }
  cNACKFILEMISS = 200; // missing file req
  cNACKDELETE = 201; // delete entry ??
  cNACKREMOVESYNC = 202; // nack remove sync
  cNACKSYNCDENIED = 203; // nack sync has been denied
  cNACKSYNCFAILED = 204; // nack sync has been failed
  cNACKBULKFAILED = 205; // nack bulk has been failed
  cNACKDRIPFEEDFAILED = 206; // the dripfeed has been failed
  cNACKFILENOTFOUND = 207; // the missing file req couldn't find the req file
  cNACKCANCELSYNC = 208;

  cUNKNOWMAIL = 'Unknown E-Mail';

  //cDRIPFEED = 'Dripfeed';
  cDRIPFEED = 'Update Link';
  cBULKEXPORT = 'Bulk Export';
  //cDRIPFEEDREQUEST = 'Dripfeed Request';
  cDRIPFEEDREQUEST = 'Link Request';
  cCISMONTHLYEXPORT = 'CIS Monthly Return';
  cCISSUBCONTRACTOR = 'CIS Subcontrator';


  cERROR = 10000;
  cFILEANDXMLERROR = cERROR + 100;
  cPLUGINERROR = cERROR + 200;
  cIMPORTPLUGINERROR = cERROR + 300;
  cEXPORTPLUGINERROR = cERROR + 400;
  cDBERROR = cERROR + 500;
  cEXCHERROR = cERROR + 600;
  cXMLRECORDERROR = cERROR + 700;
  cCOMMSLAYERERROR = cERROR + 800;
  cMAILPARAMERROR = cERROR + 900;

  cINVALIDPARAM = cERROR + 9999;

// object/methods errors

  cOBJECTNOTAVAILABLE = cERROR + 1; // 10001
  cASSIGINGMETHODERROR = cERROR + 2; // 10002
  cOBJECTNOTFOUNDONROT = cERROR + 3; // 10003
  cCOMOBJECTERROR = cERROR + 4; // 10004
  cINITDLLERROR = cERROR + 5; // 10005
  cASSIGINGOBJECTERROR = cERROR + 6; // 10006

// file and xml errors + 100
  cINVALIDFILE = cFILEANDXMLERROR + 1; // 10101
  cFILENOTFOUND = cFILEANDXMLERROR + 2; // 10102
  cSAVINGFILEERROR = cFILEANDXMLERROR + 3; // 10103
  cLOADINGFILEERROR = cFILEANDXMLERROR + 4; // 10104
  cDECOMPRESSERROR = cFILEANDXMLERROR + 5; // 10105
  cCOMPRESSERROR = cFILEANDXMLERROR + 6; // 10106
  cENCRYPTERROR = cFILEANDXMLERROR + 7; // 10107
  cDECRYPTERROR = cFILEANDXMLERROR + 8; // 10108
  cINVALIDXML = cFILEANDXMLERROR + 9; // 10109
  cEMPTYXML = cFILEANDXMLERROR + 10; // 10110
  cTRANSFORMINGXMLERROR = cFILEANDXMLERROR + 11; // 10111
  cVALIDATINGXMLERROR = cFILEANDXMLERROR + 12; // 10112
  cLOADINGXSDERROR = cFILEANDXMLERROR + 13; // 10113
  cLOADINGXSLERROR = cFILEANDXMLERROR + 14; // 10114
  cBUILDINGXMLERROR = cFILEANDXMLERROR + 15; // 10115
  cINVALIDXMLNODE = cFILEANDXMLERROR + 16; // 10116
  cLOADINGXMLVALUEERROR = cFILEANDXMLERROR + 17; // 10117
  cSETTINGXMLHEADERERROR = cFILEANDXMLERROR + 18; // 10118
  cINVALIDGUID = cFILEANDXMLERROR + 19; // 10119
  cINVALIDXSD = cFILEANDXMLERROR + 20; // 10120
  cINVALIDXSL = cFILEANDXMLERROR + 21; // 10121
  cINVALIDCHECKSUM = cFILEANDXMLERROR + 22; // 10122
  cLOADINGXMLERROR = cFILEANDXMLERROR + 23; // 10123
  cNOOUTPUTDIRECTORY = cFILEANDXMLERROR + 24; // 10124
  cLOADINGXMLHEADERERROR = cFILEANDXMLERROR + 25; // 10125

// plugins errors + 200
  cNODATAEXPORTED = cPLUGINERROR + 1; // 10201
  cFAILUREVALIDATINGFILE = cPLUGINERROR + 2; // 10202
  cCOULDNOTGENERATEIRMARK = cPLUGINERROR + 3; // 10203
  cEXPORTTYPENOTSPECIFIED = cPLUGINERROR + 4; // 10204

// import errors + 300
  cIMPORTERRORS = cIMPORTPLUGINERROR + 1; // 10301
  cLOADINGIMPORTPLUGINERROR = cIMPORTPLUGINERROR + 2; // 10302
  cINVALIDIMPORTGUID = cIMPORTPLUGINERROR + 3; // 10303
  cNODATATOBEIMPORTED = cIMPORTPLUGINERROR + 4; // 10304
  cIMPORTINGXMLERROR = cIMPORTPLUGINERROR + 5; // 10305
  cIMPORTPLUGINNOTAVAILABLE = cIMPORTPLUGINERROR + 6; // 10306
  cINVALIDIMPORTPACK = cIMPORTPLUGINERROR + 7; // 10307
  cXMLDATAMISMATCH = cIMPORTPLUGINERROR + 8; // 10308
  cCOMPANYALREADYINDRIPFEED = cIMPORTPLUGINERROR + 9; // 10309
  cCOMPANYNOTINDRIPFEED = cIMPORTPLUGINERROR + 10; // 10310
  cIMPORTCANCELLED = cIMPORTPLUGINERROR + 11; // 10311

// export errors + 400
  cLOADINGEXPORTPLUGINERROR = cEXPORTPLUGINERROR + 1; // 10401
  cINVALIDEXPORTGUID = cEXPORTPLUGINERROR + 2; // 10402
  cNODATATOBEEXPORTED = cEXPORTPLUGINERROR + 3; // 10403
  cEXPORTPLUGINNOTAVAILABLE = cEXPORTPLUGINERROR + 4; // 10404
  cINVALIDEXPORTPACK = cEXPORTPLUGINERROR + 5; // 10405
  cWRITINGXMLERROR = cEXPORTPLUGINERROR + 6; // 10406
  cMANAGERNOTINITIALISED = cEXPORTPLUGINERROR + 7; // 10407

// Database error +500
  cCONNECTINGDBERROR = cDBERROR + 1; // 10501
  cGETTINGDBFIELDERROR = cDBERROR + 2; // 10502
  cPOSTINGDBVALUEERROR = cDBERROR + 3; // 10503
  cDBNORECORDFOUND = cDBERROR + 4; // 10504
  cUPDATINGDBERROR = cDBERROR + 5; // 10505
  cDATABASEOFFLINE = cDBERROR + 6; // 10506
  cREADINGDATAERROR = cDBERROR + 7; // 10507
  cRECORDALREADYEXISTS = cDBERROR + 8; // 10508

// exchequer errors 600
  cEXCHSAVINGVALUEERROR = cEXCHERROR + 1; // 10601
  cEXCHLOADINGVALUEERROR = cEXCHERROR + 2; // 10602
  cEXCHINVALIDTABLE = cEXCHERROR + 3; // 10603
  cEXCHINVALIDPATH = cEXCHERROR + 4; // 10604
  cEXCHLOADINGDLLERROR = cEXCHERROR + 5; // 10605
  cEXCHINVALIDCOMPCODE = cEXCHERROR + 6; // 10606
  cEXCHCOMPALREADYEXISTS = cEXCHERROR + 7; // 10607
  cEXCHCOMPLICEXCEEDED = cEXCHERROR + 8; // 10608
  cEXCHCOMPCODEALREADYINUSE = cEXCHERROR + 9; // 10609
  cEXCHNOTRANSACTIONSAVAILABLE = cEXCHERROR + 10; // 10610
  cEXCHINVALIDPRODUCTTYPE = cEXCHERROR + 11; // 10611

// XML RECORDS ERRORS + 700
  cNOXMLRECORDSFOUND = cXMLRECORDERROR + 1; // 10701
  cEXTRACTRECORDFROMXMLERROR = cXMLRECORDERROR + 2; // 10702
  cSAVINGXMLRECORDERROR = cXMLRECORDERROR + 3; // 10703
  cLOADINGXMLRECORDERROR = cXMLRECORDERROR + 4; // 10704

  // COMMS LAYER Error + 800
  cCOMMSLAYEROUTGOINGNOTAVAILABLE = cCOMMSLAYERERROR + 1; // 10801
  cCOMMSLAYERINCOMINGNOTAVAILABLE = cCOMMSLAYERERROR + 2; //10802
  cCOMMSLAYERSENDERROR = cCOMMSLAYERERROR + 3; // 10803

  // MAILS param erros + 900
  cINVALIDDESTINATION = cMAILPARAMERROR + 1; // 10901
  cNOFILESRECEIVED = cMAILPARAMERROR + 2; //10902
  cNOTREADYTOIMPORT = cMAILPARAMERROR + 3; //10903
  cERRORSENDINGEMAIL = cMAILPARAMERROR + 4; //10904
  cNOFILESTOBESENT = cMAILPARAMERROR + 5; //10905
  cMAILLOCKED = cMAILPARAMERROR + 6; //10906

  //SChedules
  cDAILYSCHEDULE = 1;
  cDAILYSCHEDULENAME = 'Daily';

  cWEEKLYSCHEDULE = 2;
  cMONTHLYSCHEDULE = 3;
  cONETIMEONLYSCHEDULE = 4;

  ErrorDetails: Array[0..95] Of TErrorDetails =
  (
    (ErrNo: cERROR; Msg: 'Unrecognized error'),
    (ErrNo: cFILEANDXMLERROR; Msg: 'General file error'),
    (ErrNo: cPLUGINERROR; Msg: 'General plug-in error'),
    (ErrNo: cIMPORTPLUGINERROR; Msg: 'General import plug-in error'),
    (ErrNo: cEXPORTPLUGINERROR; Msg: 'General export plug-in error'),
    (ErrNo: cDBERROR; Msg: 'General database error'),
    (ErrNo: cEXCHERROR; Msg: 'General Exchequer error'),
    (ErrNo: cXMLRECORDERROR; Msg: 'General XML record error'),
    (ErrNo: cCOMMSLAYERERROR; Msg: 'General COMMS layer error'),
    (ErrNo: cMAILPARAMERROR; Msg: 'General mail parameter error'),

    (ErrNo: cINVALIDPARAM; Msg: 'Invalid parameter'),

    //object/methods errors

    (ErrNo: cOBJECTNOTAVAILABLE; Msg: 'Object not available'),
    (ErrNo: cASSIGINGMETHODERROR; Msg: 'Assignment method error'),
    (ErrNo: cOBJECTNOTFOUNDONROT; Msg: 'Object not found on ROT'),
    (ErrNo: cCOMOBJECTERROR; Msg: 'COM Object error'),
    (ErrNo: cINITDLLERROR; Msg: 'DLL initialization error'),
    (ErrNo: cASSIGINGOBJECTERROR; Msg: 'Object assignment error'),

    //file and xml errors+100
    (ErrNo: cINVALIDFILE; Msg: 'Invalid file'),
    (ErrNo: cFILENOTFOUND; Msg: 'File not found'),
    (ErrNo: cSAVINGFILEERROR; Msg: 'Error saving file'),
    (ErrNo: cLOADINGFILEERROR; Msg: 'Error loading file'),
    (ErrNo: cDECOMPRESSERROR; Msg: 'Decompression error'),
    (ErrNo: cCOMPRESSERROR; Msg: 'Compression error'),
    (ErrNo: cENCRYPTERROR; Msg: 'Encryption error'),
    (ErrNo: cDECRYPTERROR; Msg: 'Decryption error'),
    (ErrNo: cINVALIDXML; Msg: 'Invalid XML'),
    (ErrNo: cEMPTYXML; Msg: 'Empty XML'),
    (ErrNo: cTRANSFORMINGXMLERROR; Msg: 'Error transforming XML'),
    (ErrNo: cVALIDATINGXMLERROR; Msg: 'Error validating XML'),
    (ErrNo: cLOADINGXSDERROR; Msg: 'Error loading XSD'),
    (ErrNo: cLOADINGXSLERROR; Msg: 'Error loading XSL'),
    (ErrNo: cBUILDINGXMLERROR; Msg: 'Error building XML'),
    (ErrNo: cINVALIDXMLNODE; Msg: 'Invalid XML node'),
    (ErrNo: cLOADINGXMLVALUEERROR; Msg: 'Error loading XML value'),
    (ErrNo: cSETTINGXMLHEADERERROR; Msg: 'Error setting XML header'),
    (ErrNo: cINVALIDGUID; Msg: 'Invalid GUID'),
    (ErrNo: cINVALIDXSD; Msg: 'Invalid XSD'),
    (ErrNo: cINVALIDXSL; Msg: 'Invalid XSL'),
    (ErrNo: cINVALIDCHECKSUM; Msg: 'Invalid check-sum'),
    (ErrNo: cLOADINGXMLERROR; Msg: 'Error loading XML'),
    (ErrNo: cNOOUTPUTDIRECTORY; Msg: 'No output directory'),
    (ErrNo: cLOADINGXMLHEADERERROR; Msg: 'Error loading XML header'),

    //plugins errors + 200
    (ErrNo: cNODATAEXPORTED; Msg: 'No data found for export'),
    (ErrNo: cFAILUREVALIDATINGFILE; Msg: 'Failure validating file'),

    (ErrNo: cCOULDNOTGENERATEIRMARK; Msg: 'Could not generate IR mark'),
    (ErrNo: cEXPORTTYPENOTSPECIFIED; Msg: 'Export type not specified'),

    //import errors + 300
    (ErrNo: cIMPORTERRORS; Msg: 'Import completed, but with errors'),
    (ErrNo: cLOADINGIMPORTPLUGINERROR; Msg: 'Error loading import plug-in'),
    (ErrNo: cINVALIDIMPORTGUID; Msg: 'Invalid import GUID'),
    (ErrNo: cNODATATOBEIMPORTED; Msg: 'No data found for import'),
    (ErrNo: cIMPORTINGXMLERROR; Msg: 'Error importing XML'),
    (ErrNo: cIMPORTPLUGINNOTAVAILABLE; Msg: 'Import plug-in not available'),
    (ErrNo: cINVALIDIMPORTPACK; Msg: 'Invalid import package'),
    (ErrNo: cXMLDATAMISMATCH; Msg: 'XML data mismatch'),
    (ErrNo: cCOMPANYALREADYINDRIPFEED; Msg: 'Company already in Dripfeed mode'),
    (ErrNo: cCOMPANYNOTINDRIPFEED; Msg: 'Company not in Dripfeed mode'),
    (ErrNo: cIMPORTCANCELLED; Msg: 'The Import process has been cancelled'),

    //export errors + 400
    (ErrNo: cLOADINGEXPORTPLUGINERROR; Msg: 'Error loading export plug-in'),
    (ErrNo: cINVALIDEXPORTGUID; Msg: 'Invalid export GUID'),
    (ErrNo: cNODATATOBEEXPORTED; Msg: 'No data found for export'),
    (ErrNo: cEXPORTPLUGINNOTAVAILABLE; Msg: 'Export plug-in not available'),
    (ErrNo: cINVALIDEXPORTPACK; Msg: 'Invalid export package'),
    (ErrNo: cWRITINGXMLERROR; Msg: 'Error writing XML'),
    (ErrNo: cMANAGERNOTINITIALISED; Msg: 'Plugin Manager not assigned'),

    //Database error + 500
    (ErrNo: cCONNECTINGDBERROR; Msg: 'Error connecting to database'),
    (ErrNo: cGETTINGDBFIELDERROR; Msg: 'Error getting database field'),
    (ErrNo: cPOSTINGDBVALUEERROR; Msg: 'Error posting database value'),
    (ErrNo: cDBNORECORDFOUND; Msg: 'No record found'),
    (ErrNo: cUPDATINGDBERROR; Msg: 'Error updating database'),
    (ErrNo: cDATABASEOFFLINE; Msg: 'Database is off-line'),
    (ErrNo: cREADINGDATAERROR; Msg: 'Error reading data'),
    (ErrNo: cRECORDALREADYEXISTS; Msg: 'Record already exists'),

    //exchequer errors + 600
    (ErrNo: cEXCHSAVINGVALUEERROR; Msg: 'Error saving value'),
    (ErrNo: cEXCHLOADINGVALUEERROR; Msg: 'Error loading value'),
    (ErrNo: cEXCHINVALIDTABLE; Msg: 'Invalid database table'),
    (ErrNo: cEXCHINVALIDPATH; Msg: 'Invalid database path'),
    (ErrNo: cEXCHLOADINGDLLERROR; Msg: 'Error loading DLL'),
    (ErrNo: cEXCHINVALIDCOMPCODE; Msg: 'Invalid company code'),
    (ErrNo: cEXCHCOMPALREADYEXISTS; Msg: 'Company already exists'),
    (ErrNo: cEXCHCOMPLICEXCEEDED; Msg: 'Company Licence Exceeded'),
    (ErrNo: cEXCHCOMPCODEALREADYINUSE; Msg: 'Company Code already in use'),
    (ErrNo: cEXCHNOTRANSACTIONSAVAILABLE; Msg: 'No transactions available'),
    (ErrNo: cEXCHINVALIDPRODUCTTYPE; Msg: 'Invalid Product type'),

    // XML RECORDS ERRORS + 700
    (ErrNo: cNOXMLRECORDSFOUND; Msg: 'No XML records found'),
    (ErrNo: cEXTRACTRECORDFROMXMLERROR; Msg: 'Error extracting record from XML'),
    (ErrNo: cSAVINGXMLRECORDERROR; Msg: 'Error saving record to XML'),
    (ErrNo: cLOADINGXMLRECORDERROR; Msg: 'Error loading XML record'),

    //COMMS LAYER Error + 800
    (ErrNo: cCOMMSLAYEROUTGOINGNOTAVAILABLE; Msg: 'Outgoing COMMS layer not available'),
    (ErrNo: cCOMMSLAYERINCOMINGNOTAVAILABLE; Msg: 'Incoming COMMS layer not available'),
    (ErrNo: cCOMMSLAYERSENDERROR; Msg: 'Error ending COMMS connection'),

    //MAILS param error + 900
    (ErrNo: cINVALIDDESTINATION; Msg: 'Invalid email destination'),
    (ErrNo: cNOFILESRECEIVED; Msg: 'No files received'),
    (ErrNo: cNOTREADYTOIMPORT; Msg: 'Not ready to import'),
    (ErrNo: cERRORSENDINGEMAIL; Msg: 'Error sending e-mail'),
    (ErrNo: cNOFILESTOBESENT; Msg: 'No files to be sent'),
    (ErrNo: cMAILLOCKED; Msg: 'The E-Mail is locked...')
    );

Const
  { common computer sizes }
  KBYTE = Sizeof(Byte) Shl 10;
  MBYTE = KBYTE Shl 10;
  GBYTE = MBYTE Shl 10;

{vaoo consts - copied from sentimail}
Const
  VAOEntDirRootKey = HKEY_CURRENT_USER;
  VAOEntDirKey = 'Software\Exchequer\Enterprise';
  VAOEntName = 'SystemDir';
  ElertKey = 'Software\Exchequer\Sentimail';
  ElVAODirPrefix = 'VAODirPrefix';
  ElVAOSubdir = 'VAOSubdir';

{CIS Consts}

Const
  //cGGWCONFIG = 'https://secure.dev.gateway.gov.uk/submission/ggsubmission.asp';

// MH 09/03/2018: Updated URL's
//  cGGWCONFIGTEST = 'https://secure.dev.gateway.gov.uk/submission';
//  cGGWCONFIGLIVE = 'https://secure.gateway.gov.uk/submission';

  // Submission URLs
  cGGWCONFIGTEST = 'https://test-transaction-engine.tax.service.gov.uk/submission';
  cGGWCONFIGLIVE = 'https://transaction-engine.tax.service.gov.uk/submission';

  // Polling URLs
  cGGWCONFIGTESTPOLL = 'https://test-transaction-engine.tax.service.gov.uk/poll';
  cGGWCONFIGLIVEPOLL = 'https://transaction-engine.tax.service.gov.uk/poll';

//  cCISVerificationRequestLIVE = 'https://www.tpvs.hmrc.gov.uk/new-cis/verify';
//  cCISMonthlyReturnLIVE = 'https://www.tpvs.hmrc.gov.uk/new-cis/monthly_return ';

  //CIS Verification Request https://www.tpvs.hmrc.gov.uk/new-cis/verify
  //CIS Monthly Return https://www.tpvs.hmrc.gov.uk/new-cis/monthly_return
  //https://secure.dev.gateway.gov.uk/submission

  cCORRELATIONIDNODE = 'CorrelationID';
  cCISXMLNODEMONTHLY = 'cisxmlmonthly';
  cCISXMLNODESUB = 'cisxmlsub';
  cCISDEFAULTPOLLINGTIME = 10000; // 10 seconds
  cCISREDIRECTIONNODE = 'ResponseEndPoint';
  cCISPOLLINTERVALNODE = 'PollInterval';
  cCISIRMARKNODE = 'IRmark';
  cCISQUALIFIERNODE = 'Qualifier';
  cCISCLASSNODE = 'Class';
  cCISRETDIR = 'CISRET';
  cCISSUBDIR = 'CISSUB';
  cCISQUALIFIERERROR = 'error';
  cCISQUALIFIERACK = 'acknowledgement';
  cCISQUALIFIERRESPONSE = 'response';
  cCISQUALIFIERMESSAGE = 'message';
  cCISXMLDIR = 'CISXML';
  cCISXMLMONTHLYFILE = 'cismonthly.xml';
  cCISXMLSUBFILE = 'cissub.xml';
  cCISRECEIVERGUID = '{571056BD-BD60-4D67-A5D1-E726C17A5BA2}';
  cISCISPARAM = 'IsCIS';
  cUSECISTESTPARAM = 'UseCISTest';
//  cAUTOMATICDRIPFEEDPARAM = 'AutoDripFeed';
  cCISMONTHLYRETSUBJECT = 'CIS 340 Monthly return submission';
  cCISSUBVERIFICATIONSUBJECT = 'CIS Subcontractor Verification';
  cCISREGIDPARAM = 'CISREGID';
  cCISREGPASSPARAM = 'CISREGPASSWORD';
  cCISMONTHLYRETFILE = 'return.xml';
  cCISMONTHLYRETFILEPROCESS = 'XMLCISreturn.xml';

  cCISSUBCHECKFILE = 'subcheck.xml';
  cCISSUBCHECKFILEPROCESS = 'CISsubcheck.xml';

  cCISXMLSUBRESPONSEDATA = 'ResponseData';
  cCISXMLSUBRESPONSE = 'CISresponse';

  cCISRECIPIENT = 'CIS Gateway';

  cCISTAXRATEUNMATCHED = 'unmatched';
  cCISTAXRATENET = 'net';
  cCISTAXRATEGROSS = 'gross';

  cCISTAXRATE: array[1..3] of TCISTaxRate = (
    (TaxNo: 1; Name: cCISTAXRATEUNMATCHED),
    (TaxNo: 4; Name: cCISTAXRATENET),
    (TaxNo: 2; Name: cCISTAXRATEGROSS)
  );

{vao consts}
const
  cISVAOPARAM = 'IsVAO';

Type
  TInteger8 = Int64;

  XMLHeader = ^TXMLHeader;
  TXMLHeader = Record
    Guid: TGUID;
    Number: Smallint;
    Count: Smallint;
    Source,
      Destination: ShortString;
    Flag: Byte;
    Plugin: ShortString;
    datatype: Smallint;
    desc,
      xsl,
      xsd: ShortString;
    StartPeriod: Byte;
    StartYear: Byte;
    EndPeriod: Byte;
    EndYear: Byte;
{
    StartDate,
    EndDate: ShortString;
                  }
  End;

  //TCompanyMode = (cmSync, cmBulk, cmDripfeed, cmRecreating);

  {kind of record}
  TRecordMode = (rmNormal, rmSync, rmBulk, rmDripFeed, rmCIS);
  { message options}
  TMessageType = (mtData, mtACK, mtNACK, mtSyncRequest);

  TACK = Record
    Mode: Byte;
    Total: Longword;
    Msg: ShortString;
    MailFrom,
      MailTo: ShortString;
  End;

  TNACK = Record
    Flag: Word; {indicates kind of nack}
    Order: Longword; {what file to search if filemiss flar}
    Reason, {reason for this nack}
      MailFrom, {when applying for end of Dripfeed, sync denied or failed}
      MailTo: ShortString;
  End;

  TSyncRequest = Record
    ExCode: String[16];
    Desc: String[50];
    Guid: String[38];
    MailFrom,
    Subject,
    MailTo: ShortString;
  End;

  PDSRFileHeader = ^TDSRFileHeader;
  TDSRFileHeader = Record
    ProductType: Byte;
    BatchId: String[38]; { batch identification }
    Version, { version of the dsr files }
      ExCode: String[16]; {exch company code}
    CompGuid: String[38]; {company guid. Added for better security}
    CheckSum, { check sum of the whole file }
      Order, { order of the file. the order will be also the name of the file }
      Total: Cardinal; { total of files in this batch }
    Split, { if this file is splitted or not }
      SplitTotal: Byte; { total of splits. they are both byte because we will never get 255MB xml file }
    SplitCheckSum: Cardinal; { check sum of split }
    Flags: Word; { kind of message }
    Mode: Byte; { if bulk/sync...  }
//    TailHelp: array[1..5] of Cardinal;
  End;

{  Company = ^TCompany;
  TCompany = Record
    ID: Integer;
    Name: String[50];
  End;
}

  // database options
  TDBOption = (dbDoUpdate, dbDoAdd, dbDoDelete);
  TDBOptions = Set Of TDBOption;

  // file options
  TFileOption = (soDoNothing, soDoEncrypt, soDoDecrypt, soDoCompress,
    soDoDeCompress, soDoRemoveChars);
  TFileOptions = Set Of TFileOption;
  TXmlSaveOptions = Set Of TFileOption;
  TXmlOpenOptions = Set Of TFileOption;

Implementation

End.

