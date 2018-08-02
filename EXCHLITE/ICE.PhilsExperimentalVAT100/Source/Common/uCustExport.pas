unit uCustExport;
{
   Customer/Supplier export class.

   The ExportType property determines whether Customers (csExportCustomers) or
   Suppliers (csExportSuppliers) are exported.

   They are exported to different XML files, but with identical structures.
}


interface

uses
  Forms, Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uXMLFileManager,
  uExportBaseClass
  ;

{$I ice.inc}

type
  TCustExport = Class(_ExportBase)
  private
    fExportType: TCustSuppExportType;
    FileManager: TXMLFileManager;
  protected
    function BuildXmlRecord(pCust: Pointer): Boolean; override;
  public
    constructor Create;
    destructor Destroy; override;
    function LoadFromDB: Boolean; override;
    property ExportType: TCustSuppExportType read fExportType write fExportType;
  end;

implementation

uses
  uEXCHBaseClass;

{ TCustExport }

function TCustExport.LoadFromDB: Boolean;

  function IsValidRecord(Key: string): Boolean;
  begin
    if (ExportType = csExportCustomers) then
      Result := (Copy(Key, 1, 1) = 'C')
    else if (ExportType = csExportSuppliers) then
      Result := (Copy(Key, 1, 1) = 'S')
    else
      Result := False;
  end;

var
  FuncRes: LongInt;
  Key: ShortString;
  ErrorCode: Integer;
  CustRecPtr: ^CustRec;
  lRecNode: IXMLDOMNode;
  FileName: string;
begin
  Result := False;

  ErrorCode := 0;

  if (ExportType = csExportCustomers) then
  begin
    Key := 'C';
    FileManager.BaseFileName := 'cus'
  end
  else if (ExportType = csExportSuppliers) then
  begin
    Key := 'S';
    FileManager.BaseFileName := 'sup';
  end
  else
  begin
    DoLogMessage('TCustExport.LoadFromDB', cEXPORTTYPENOTSPECIFIED);
    Result := False;
    Exit;
  end;

  SetDrive := DataPath;

  FileManager.Directory := DataPath + cICEFOLDER;

  { Remove any existing drip-feed files from the export path. }
  DeleteFiles(FileManager.Directory, FileManager.BaseFileName + '*.xml');

  Clear;

  { Open the table... }
  FuncRes := Open_File(F[CustF], SetDrive + FileNames[CustF], 0);
  if (FuncRes = 0) then
  begin

    { ...and find the first record. }
    FuncRes := Find_Rec(B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, ATCodeK, Key);
    Result := (FuncRes = 0);

    CustRecPtr := @Cust;
    while ((FuncRes = 0) and IsValidRecord(Key)) do
    begin
      { Free any existing XML document handler (in fActiveXMLDoc), and create
        a new one. }
      CreateXMLDoc;

      { Locate and delete the empty CustRec section, because we are going to
        recreate it. }
      lRecNode := ActiveXMLDoc.Doc;
      try
        lRecNode := _GetNodeByName(lRecNode, 'message');
        lRecNode.removeChild(_GetNodeByName(lRecNode, 'custrec'));
      finally
        lRecNode := nil;
      end;

      { Build the required XML record from the Customer/Supplier details
        details. }
      BuildXMLRecord(CustRecPtr);
      FuncRes := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, ATCodeK, Key);

      ActiveXMLDoc.Load(StringReplace(ActiveXMLDoc.Doc.xml, #9#13#10, '', [rfReplaceAll]));
      ActiveXMLDoc.RemoveComments;

      FileName := FileManager.SaveXML(ActiveXMLDoc.Doc.xml);
      Files.Add(FileName);

      Application.ProcessMessages;

    end;

    FuncRes := Close_File(F[CustF]);
  end
  else
    ErrorCode := cCONNECTINGDBERROR;

  { Log any errors. }
  if (ErrorCode <> 0) then
    DoLogMessage('TCustExport.LoadFromDB', ErrorCode, 'Error: ' + IntToStr(FuncRes));
End;

{-----------------------------------------------------------------------------
  Procedure: BuildXmlRecord
  Author:    vmoura
  Arguments: pCust: Pointer
  Result:    Boolean
-----------------------------------------------------------------------------}
function TCustExport.BuildXmlRecord(pCust: Pointer): Boolean;
var
  lRootNode, lRecNode, lSubNode: IXMLDomNode;
  SpareStr: string[109];
const
  AS_CDATA = True;
Begin
  Result := False;

  With CustRec(pCust^) Do
  Begin
    lRootNode := ActiveXMLDoc.Doc;

    { Locate the top node, 'message' -- all the other records will be added as
      child nodes below this node. }
    lRootNode := _GetNodeByName(lRootNode, 'message');

    if (lRootNode <> nil) then
    try

      { Add the record node. }
      lRecNode := lRootNode.appendChild(ActiveXMLDoc.Doc.createElement('custrec'));

      { Add the field nodes. Fields which could potentially hold invalid (for
        HTML) characters, such as '<' or '&', are saved as CDATA nodes. All
        other fields are stored as TEXT nodes. }
      _AddLeafNode(lRecNode, 'accode',               CustCode);
      _AddLeafNode(lRecNode, 'accompany',            Company, AS_CDATA);
      _AddLeafNode(lRecNode, 'acarea',               AreaCode);
      _AddLeafNode(lRecNode, 'acacctype',            CustSupp);
      _AddLeafNode(lRecNode, 'acstatementto',        RemitCode);
      _AddLeafNode(lRecNode, 'acvatregno',           VATRegNo);

      lSubNode := lRecNode.appendChild(ActiveXMLdoc.Doc.createElement('acaddress'));
      try
        _AddLeafNode(lSubNode, 'acstreet1',            Addr[1]);
        _AddLeafNode(lSubNode, 'acstreet2',            Addr[2]);
        _AddLeafNode(lSubNode, 'actown',               Addr[3]);
        _AddLeafNode(lSubNode, 'accounty',             Addr[4]);
        _AddLeafNode(lSubNode, 'acpostcode',           Addr[5]);
      finally
        lSubNode := nil;
      end;

      lSubNode := lRecNode.appendChild(ActiveXMLdoc.Doc.createElement('acdeladdress'));
      try
        _AddLeafNode(lSubNode, 'acstreet1',            DAddr[1]);
        _AddLeafNode(lSubNode, 'acstreet2',            DAddr[2]);
        _AddLeafNode(lSubNode, 'actown',               DAddr[3]);
        _AddLeafNode(lSubNode, 'accounty',             DAddr[4]);
        _AddLeafNode(lSubNode, 'acpostcode',           DAddr[5]);
      finally
        lSubNode := nil;
      end;

      _AddLeafNode(lRecNode, 'accontact',            Contact, AS_CDATA);
      _AddLeafNode(lRecNode, 'acphone',              Phone,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acfax',                Fax,     AS_CDATA);
      _AddLeafNode(lRecNode, 'actheiracc',           RefNo);
      _AddLeafNode(lRecNode, 'acowntradterm',        TradTerm);

      lSubNode := lRecNode.appendChild(ActiveXMLdoc.Doc.createElement('actradeterms'));
      try
        _AddLeafNode(lSubNode, 'acterm1',              STerms[1]);
        _AddLeafNode(lSubNode, 'acterm2',              STerms[2]);
      finally
        lSubNode := nil;
      end;

      _AddLeafNode(lRecNode, 'acbalance',            Balance);
      _AddLeafNode(lRecNode, 'accurrency',           Currency);
      _AddLeafNode(lRecNode, 'acvatcode',            VATCode);
      _AddLeafNode(lRecNode, 'acpayterms',           PayTerms);
      _AddLeafNode(lRecNode, 'accreditlimit',        CreditLimit);
      _AddLeafNode(lRecNode, 'acdiscount',           Discount);
      _AddLeafNode(lRecNode, 'accreditstatus',       CreditStatus);
      _AddLeafNode(lRecNode, 'accostcentre',         CustCC);
      _AddLeafNode(lRecNode, 'acdiscountband',       CDiscCh);
      _AddLeafNode(lRecNode, 'acdepartment',         CustDep,    AS_CDATA);
      _AddLeafNode(lRecNode, 'acecmember',           EECMember);
      _AddLeafNode(lRecNode, 'acstatement',          IncStat);
      _AddLeafNode(lRecNode, 'acsalesgl',            DefNomCode);
      _AddLeafNode(lRecNode, 'aclocation',           DefMLocStk, AS_CDATA);
      _AddLeafNode(lRecNode, 'acaccstatus',          AccStatus);
      _AddLeafNode(lRecNode, 'acpaytype',            PayType);
      _AddLeafNode(lRecNode, 'acbanksort',           BankSort,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acbankacc',            BankAcc,    AS_CDATA);
      _AddLeafNode(lRecNode, 'acbankref',            BankRef,    AS_CDATA);
      _AddLeafNode(lRecNode, 'aclastused',           LastUsed);
      _AddLeafNode(lRecNode, 'acphone2',             Phone2,     AS_CDATA);
      _AddLeafNode(lRecNode, 'acuserdef1',           UserDef1,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acuserdef2',           UserDef2,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acinvoiceto',          SOPInvCode);
      _AddLeafNode(lRecNode, 'acsopautowoff',        SOPAutoWOff);
      _AddLeafNode(lRecNode, 'acbookordval',         BOrdVal);
      _AddLeafNode(lRecNode, 'accosgl',              DefCOSNom);
      _AddLeafNode(lRecNode, 'acdrcrgl',             DefCtrlNom);
      _AddLeafNode(lRecNode, 'acdirdebmode',         DirDeb);
      _AddLeafNode(lRecNode, 'acccstart',            CCDSDate);
      _AddLeafNode(lRecNode, 'acccend',              CCDEDate);
      _AddLeafNode(lRecNode, 'acccname',             CCDName,    AS_CDATA);
      _AddLeafNode(lRecNode, 'acccnumber',           CCDCardNo,  AS_CDATA);
      _AddLeafNode(lRecNode, 'acccswitch',           CCDSARef,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acdefsettledays',      DefSetDDays);
      _AddLeafNode(lRecNode, 'acdefsettledisc',      DefSetDisc);
      _AddLeafNode(lRecNode, 'acformset',            FDefPageNo);
      _AddLeafNode(lRecNode, 'acstatedeliverymode',  StatDMode);
      _AddLeafNode(lRecNode, 'acemailaddr',          EmailAddr,  AS_CDATA);
      _AddLeafNode(lRecNode, 'acsendreader',         EmlSndRdr);
      _AddLeafNode(lRecNode, 'acebuspword',          EmlSndRdr,  AS_CDATA);
      _AddLeafNode(lRecNode, 'acaltcode',            CustCode2,  AS_CDATA);
      _AddLeafNode(lRecNode, 'acpostcode',           PostCode);
      _AddLeafNode(lRecNode, 'acuseforebus',         AllowWeb);
      _AddLeafNode(lRecNode, 'aczipattachments',     EmlZipAtc);
      _AddLeafNode(lRecNode, 'acuserdef3',           UserDef3,   AS_CDATA);
      _AddLeafNode(lRecNode, 'acuserdef4',           UserDef4,   AS_CDATA);
      _AddLeafNode(lRecNode, 'actimestamp',          TimeChange);
      _AddLeafNode(lRecNode, 'acssddeliveryterms',   SSDDelTerms,AS_CDATA);
      _AddLeafNode(lRecNode, 'acinclusivevatcode',   CVATIncFlg);
      _AddLeafNode(lRecNode, 'acssdmodeoftransport', SSDModeTr);
      _AddLeafNode(lRecNode, 'aclastoperator',       LastOpo);
      _AddLeafNode(lRecNode, 'acdocdeliverymode',    InvDMode);
      _AddLeafNode(lRecNode, 'acsendhtml',           EmlSndHtml);
      _AddLeafNode(lRecNode, 'acweblivecatalog',     WebLiveCat, AS_CDATA);
      _AddLeafNode(lRecNode, 'acwebprevcatalog',     WebPrevCat, AS_CDATA);
      _AddLeafNode(lRecNode, 'acsopconsho',          SOPConsHO);
      _AddLeafNode(lRecNode, 'acdeftagno',           DefTagNo);
      _AddLeafNode(lRecNode, 'acordconsmode',        OrdConsMode);

      SpareStr := Spare;
      _AddLeafNode(lRecNode, 'spare', SpareStr, AS_CDATA);

      _AddLeafNode(lRecNode, 'spare2', Spare2, AS_CDATA);

      _AddLeafNode(lRecNode, 'spare51', Spare5[1]);
      _AddLeafNode(lRecNode, 'spare52', Spare5[2]);

      lRecNode  := nil;
      lRootNode := nil;

      Result := True;
    Except
      On e: Exception Do
        DoLogMessage('TCustExport.BuildXml', cBUILDINGXMLERROR, 'Error: ' +
          e.message);
    End
    Else
      DoLogMessage('TCustExport.BuildXml', cINVALIDXMLNODE);
  End;
End;

constructor TCustExport.Create;
begin
  inherited Create;
  UseFiles := True;
  FileManager := TXMLFileManager.Create;
end;

destructor TCustExport.Destroy;
begin
  FileManager.Free;
  inherited;
end;

End.

