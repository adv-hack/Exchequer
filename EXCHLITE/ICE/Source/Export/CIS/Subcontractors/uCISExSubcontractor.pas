{-----------------------------------------------------------------------------
 Unit Name: uCISSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}

Unit uCISExSubcontractor;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISExSubcontractor_TLB, DSRExport_TLB, StdVcl, Sysutils;

Type
  TCISSubcontractorExport = Class(TAutoObject,  IExportBox)
  Protected
    fXml: WideString;
    Function DoExport(Const pCompanyCode, pDataPath, pXMLPath: WideString;
      pParam1, pParam2, pParam3, pParam4: OleVariant;
      pUserReference: LongWord): LongWord; Safecall;
    Function Get_XmlCount: Integer; Safecall;
    Function Get_XmlList(Index: Integer): WideString; Safecall;
    { Protected declarations }
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ, Variants, DSRUtility_TLB, uCommon, 

  uConsts, uSubcontractorExport
  ;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCISSubcontractorExport.Destroy;
Begin
  CoUninitialize;

  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: DoExport
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSubcontractorExport.DoExport(Const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
Var
  lSubExport: TSubContractorExport;
  lUtility: IDSRUtil;
  lServer: String;
Begin
  Result := S_OK;
  fXml := '';
  lUtility := Nil;

  {get the database server name}
  Try
    lUtility := CoDSRUtil.Create As IDSRUtil;

    If lUtility <> Nil Then
      lServer := lUtility.GetDBServer;
  Finally
    lUtility := Nil;
  End;

  If Trim(lServer) = '' Then
    lServer := _GetComputerName;

  _CallDebugLog('Server is: ' + lServer + ' Data Path: ' + pDataPath + ' Xml Path: ' + pXMLPath );  

  {check if all parameters are valid}
  If (lServer <> '') And (pDataPath <> '') And (pXMLPath <> '') Then
  Begin
    fXml := '';
    lSubExport := TSubContractorExport.Create;
    lSubExport.CompExCode := pCompanyCode;
    lSubExport.DataPath := pDataPath;
    lSubExport.XMLPath := pXMLPath;
    lSubExport.DSRDBServer := lServer;

  {load the list of subcontractors}
    lSubExport.BuildRecords;
  {check for any exported record}
    If lSubExport.RecordExists Then
      fXml := lSubExport.XML
    Else
      Result := cNODATATOBEEXPORTED;

    lSubExport.Free;
  End
  Else
    Result := cINVALIDPARAM;
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

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISSubcontractorExport.Initialize;
Begin
  Inherited;
  CoInitialize(Nil);
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISSubcontractorExport,
    Class_CISSubcontractorExport, ciMultiInstance, tmApartment);
End.

