{-----------------------------------------------------------------------------
 Unit Name: uVAT100Im
 Author:    Phil Rogers
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uVAT100Im;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, VAT100Im_TLB, StdVcl, DSRIMport_TLB;

Type
  TVAT100Im = Class(TAutoObject, IImportBox)
  Protected
    Function DoImport(Const pCompanyCode, pDataPath, pXML, pXSL,
      pXSD: WideString; pUserReference: LongWord): LongWord; Safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ, Variants, DSRUtility_TLB, uCommon, SysUtils,

  uConsts, uVAT100Import
  ;

{-----------------------------------------------------------------------------
  Procedure: DoImport
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Function TVAT100Im.DoImport(Const pCompanyCode, pDataPath,
  pXML, pXSL, pXSD: WideString; pUserReference: LongWord): LongWord;
Var
  lVAT100Import : TVAT100Import;
  lUtility      : IDSRUtil;
  lServer       : String;
Begin
  Result   := S_OK;
  lUtility := Nil;

  // Get the database server name
  Try
    lUtility := CoDSRUtil.Create As IDSRUtil;

    If lUtility <> Nil Then
      lServer := lUtility.GetDBServer;
  Finally
    lUtility := Nil;
  End;

  // If the server name is null, assume local.
  If Trim(lServer) = '' Then
    lServer := _GetComputerName;

  // Check if all parameters are valid
  If (lServer <> '') And (pDataPath <> '') And (pXML <> '') Then
  Begin
    lVAT100Import := TVAT100Import.Create;
    lVAT100Import.CompExCode := pCompanyCode;
    lVAT100Import.DataPath := pDataPath;
    lVAT100Import.XML := pXML;
    lVAT100Import.DSRDBServer := lServer;

    Try
      Result := lVAT100Import.UpdateRecords;
    Except
      Result := cIMPORTPLUGINERROR;
    End;

    lVAT100Import.Free;
  End
  Else
    Result := cINVALIDPARAM;
End;

Initialization
  TAutoObjectFactory.Create(ComServer,
                            TVAT100Im,
                            Class_VAT100Im,
                            ciMultiInstance,
                            tmApartment);
End.

