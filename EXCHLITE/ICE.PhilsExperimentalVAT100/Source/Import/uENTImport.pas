{-----------------------------------------------------------------------------
 Unit Name: uENTImport
 Author:    vmoura
 Purpose:
 History:
   exchequer import module.
-----------------------------------------------------------------------------}
Unit uENTImport;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, EImport_TLB, StdVcl, Sysutils,
  DSRImport_TLB
  ;

Type
  TENTImport = Class(TAutoObject, IENTImport, IImportBox)
  Private
    Function GetObjectTable(pUserReference: Integer): TObject;
  Protected
    function DoImport(const pDataPath, pXML, pXSL, pXSD: WideString;
      pUserReference: LongWord): LongWord; safecall;
  End;

Implementation

Uses ComServ, uConsts, uCustImport, uImportBaseClass, uEXCHBaseClass,
  uVATImport, uCurrencyImport, uCCDeptImport, uDocNumberImport, uGLCodeImport,
  uGLStructureImport;

{-----------------------------------------------------------------------------
  Procedure: DoImport
  Author:    vmoura
  Result:    None

    dont forget to set the path of the dll to exchequer
-----------------------------------------------------------------------------}
function TENTImport.DoImport(const pDataPath, pXML, pXSL, pXSD: WideString;
  pUserReference: LongWord): LongWord;
Var
  lTable: TObject;
Begin
  Result := S_OK;
  // get the right object
  lTable := GetObjectTable(pUserReference);
  If Assigned(lTable) Then
  Begin
    With _ImportBase(lTable) Do
    Begin
      // set the dll stuff
      DataPath := pDataPath;
      UserReference := pUserReference;

      // try to load the xml param
      If XMLDoc.Load(pXml) Then
      Begin
        // get records from the xml
        If Extract Then
        Begin
          // finally, try to save the loaded information into the database
          If Not SaveListtoDb Then
            Result := cIMPORTINGXMLERROR;
        End
        Else
          Result := cEXTRACTRECORDFROMXMLERROR;
      End
      Else
        Result := cLOADINGFILEERROR;

    //dont forget to free the object
    End;

    FreeAndNil(lTable);
  End
  Else
    Result := cEXCHINVALIDTABLE
End;

{-----------------------------------------------------------------------------
  Procedure: GetObjectTable
  Author:    vmoura
  Arguments: pMsgType: Integer
  Result:    TObject

  get the rigth object
-----------------------------------------------------------------------------}
Function TENTImport.GetObjectTable(pUserReference: Integer): TObject;
Begin
  Result := Nil;
  Case pUserReference Of
    cVATTable: Result := TVATImport.Create;
    cCurrencyTable: Result := TCurrencyImport.Create;
    cCostCentreTable:
      begin
        Result := TCCDeptImport.Create;
        TCCDeptImport(Result).ImportType := cdImportCostCentres;
      end;
    cDeptTable:
      begin
        Result := TCCDeptImport.Create;
        TCCDeptImport(Result).ImportType := cdImportDepartments;
      end;
    cDocNumbersTable: Result := TDocNumberImport.Create;
    cGLCodeTable: Result := TGLCodeImport.Create;
    cGLStructureTable: Result := TGLStructureImport.Create;
    cCustTable:
      begin
        Result := TCustImport.Create;
        TCustImport(Result).ImportType := csImportCustomers;
      end;
    cSupplierTable:
      begin
        Result := TCustImport.Create;
        TCustImport(Result).ImportType := csImportSuppliers;
      end;
  End;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TENTImport, Class_ENTImport,
    ciMultiInstance, tmApartment);
End.

