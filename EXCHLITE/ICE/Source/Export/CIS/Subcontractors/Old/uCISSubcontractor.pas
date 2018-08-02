{-----------------------------------------------------------------------------
 Unit Name: uCISSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}

Unit uCISSubcontractor;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISSubcontractor_TLB, DSRExport_TLB, StdVcl;

Type
  TCISSubcontractorExport = Class(TAutoObject, IExportBox)
  Protected
    fXml: WideString;
    Function DoExport(Const pCompanyCode, pDataPath, pXMLPath: WideString;
      pParam1, pParam2, pParam3, pParam4: OleVariant;
      pUserReference: LongWord): LongWord; Safecall;
    Function Get_XmlCount: Integer; Safecall;
    Function Get_XmlList(Index: Integer): WideString; Safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ, uConsts, uSubcontractorExport
  ;

{-----------------------------------------------------------------------------
  Procedure: DoExport
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSubcontractorExport.DoExport(Const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
Var
  lSubExport: TSubContractorExport;
Begin
  Result := S_OK;
  fXml := '';
  lSubExport := TSubContractorExport.Create(pDataPath, pXMLPath);
  {load the list of subcontractors}
  lSubExport.BuildRecords;
  {check for any exported record}
  If lSubExport.RecordExists Then
    fXml := lSubExport.XML
  Else
    Result := cNODATATOBEEXPORTED;

  lSubExport.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlCount
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSubcontractorExport.Get_XmlCount: Integer;
Begin
  Result := 0;
  If fXml <> '' Then
    Result := 1;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlList
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSubcontractorExport.Get_XmlList(Index: Integer): WideString;
Begin
  If fXml <> '' Then
    Result := fXml;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISSubcontractorExport,
    Class_CISSubcontractorExport,
    ciMultiInstance, tmApartment);
End.

