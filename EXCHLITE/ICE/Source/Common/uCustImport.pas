unit uCustImport;

interface

uses
  Classes, SysUtils, ComObj, Controls, Variants,

  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,

  // ICE units
  MSXML2_TLB,
  uXmlBaseClass,
  uConsts,
  uCommon,
  uBtrieveThread,
  uImportBaseClass
  ;

{$I ice.inc}

type
  TCustImport = class(_ImportBase)
  private
    ExLocal: PBtrieveThread;
    fImportType: TCustSuppImportType;
    function WriteDetails(Node: IXMLDOMNode): Boolean;
  protected
    isFileOpen: Boolean;
    procedure AddRecord(pNode: IXMLDOMNode); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    function SaveListToDB: Boolean; override;
    property ImportType: TCustSuppImportType read fImportType write fImportType;
  end;

implementation

uses
  EtStrU,
  BtKeys1U;

// ===========================================================================
// TCustImport
// ===========================================================================

procedure TCustImport.AddRecord(pNode: IXMLDOMNode);
{ Called by the Extract method in the _ImportBase class. }
var
  FuncRes, ErrorCode: LongInt;
begin
  ErrorCode := 0;
  FuncRes   := 0;

  if not isFileOpen then
  begin

    ErrorCode := 0;
    SetDrive := DataPath;

    New (ExLocal, Create(1));

    { Open the table. }
    FuncRes := ExLocal.LOpen_File(CustF);
    if (FuncRes = 0) then
      isFileOpen := True
    else
      ErrorCode := cCONNECTINGDBERROR;
  end;

  if (ErrorCode = 0) then
    { Write the record details from the XML file to the database. }
    WriteDetails(pNode);

  { Log any errors. }
  if (ErrorCode <> 0) then
  begin
    if (FuncRes <> 0) then
      DoLogMessage('TCustImport.AddRecord', ErrorCode,
                   'Error: ' + IntToStr(FuncRes))
    else
      DoLogMessage('TCustImport.AddRecord', ErrorCode);
  end;
end;

// ---------------------------------------------------------------------------

constructor TCustImport.Create;
begin
  inherited;
  isFileOpen := False;
end;

// ---------------------------------------------------------------------------

destructor TCustImport.Destroy;
var
  FuncRes: LongInt;
begin
  if isFileOpen then
  begin
    FuncRes := ExLocal.LClose_File(CustF);
//    FuncRes := Close_File(F[CustF]);
    isFileOpen := False;
    if ((FuncRes <> 0) and (FuncRes <> 3)) then
      DoLogMessage('TCustImport.Destroy: ' +
                   'error closing file',
                   cCONNECTINGDBERROR,
                   'Error: ' + IntToStr(FuncRes));
    Dispose(ExLocal, Destroy);
  end;
  inherited;
end;

function TCustImport.SaveListToDB: Boolean;
begin
  { Not used (the data is written directly to database via AddRecord) but
    must be implemented as TEntImport will attempt to call it, and the base
    method is abstract. }
  Result := True;
end;

// ---------------------------------------------------------------------------

function TCustImport.WriteDetails(Node: IXMLDOMNode): Boolean;
var
  FuncRes: LongInt;
  Key: ShortString;
  Aux: string;
  SubNode: IXMLDOMNode;
begin
  Result := True;

  if (ImportType = csImportCustomers) then
    Key := 'C'
  else if (ImportType = csImportSuppliers) then
    Key := 'S'
  else
  begin
    DoLogMessage('TCustExport.LoadFromDB', cEXPORTTYPENOTSPECIFIED);
    Result := False;
    Exit;
  end;

  { Search for a matching record. }
  Key := Key + _GetNodeValue(Node, 'accode');
  FuncRes := ExLocal.LFind_Rec(B_GetEq, CustF, ATCodeK, Key);
  if (FuncRes <> 0) then
    FillChar(Exlocal.LCust, SizeOf(Exlocal.LCust), 0);

  { Fill in the record structure }
  with Exlocal.LCust do
  begin
    try

      CustSupp  := Key[1];
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

      Balance   := _GetNodeValue(Node, 'acbalance');
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
      sopinvcode  := FullCustCode(_GetNodeValue(Node, 'acinvoiceto'));  // **
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
      postcode    := FullPostCode(_GetNodeValue(Node, 'acpostcode'));   // **
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
        DoLogMessage('TCustImport.GetRecordValue',
                     cLOADINGXMLVALUEERROR,
                     'Error: ' + E.message);
      end;
    end; // try...
  end; { with Cust do... }

  if Result then
  begin

    { If a matching record was found, update the details... }
    if (FuncRes = 0) then
      FuncRes := ExLocal.LPut_Rec(CustF, 0)
    else
      { ...otherwise add a new record. }
      FuncRes := ExLocal.LAdd_Rec(CustF, 0);

    if (FuncRes <> 0) then
    begin
      DoLogMessage('TCustImport.WriteDetails for ' + Trim(Exlocal.LCust.CustCode), cUPDATINGDBERROR, 'Error: ' + IntToStr(FuncRes));
      Result := False;
    end;
  end;

end;

// ---------------------------------------------------------------------------

end.
