{-----------------------------------------------------------------------------
 Unit Name: uCISImSubcontractor
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISImSubcontractor;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISImSubcontractor_TLB, StdVcl, DSRIMport_TLB;

Type
  TCISImportSubcontractor = Class(TAutoObject, IImportBox)
  Protected
    Function DoImport(Const pCompanyCode, pDataPath, pXML, pXSL,
      pXSD: WideString; pUserReference: LongWord): LongWord; Safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ, Variants, DSRUtility_TLB, uCommon, SysUtils,

  uConsts, uSubcontractorImport
  ;

{-----------------------------------------------------------------------------
  Procedure: DoImport
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISImportSubcontractor.DoImport(Const pCompanyCode, pDataPath,
  pXML, pXSL, pXSD: WideString; pUserReference: LongWord): LongWord;
Var
  lSubImport: TSubContractorImport;
  lUtility: IDSRUtil;
  lServer: String;
Begin
  Result := S_OK;
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

  {check if all parameters are valid}
  If (lServer <> '') And (pDataPath <> '') And (pXML <> '') Then
  Begin
    lSubImport := TSubContractorImport.Create;
    lSubImport.CompExCode := pCompanyCode;
    lSubImport.DataPath := pDataPath;
    lSubImport.XML := pXML;
    lSubImport.DSRDBServer := lServer;

    Try
      Result := lSubImport.UpdateRecords;
    Except
      Result := cIMPORTPLUGINERROR;
    End;

    lSubImport.Free;
  End
  Else
    Result := cINVALIDPARAM;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISImportSubcontractor,
    Class_CISImportSubcontractor,
    ciMultiInstance, tmApartment);
End.

