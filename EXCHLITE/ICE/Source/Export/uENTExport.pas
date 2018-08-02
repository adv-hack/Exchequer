{-----------------------------------------------------------------------------
 Unit Name: uENTExport
 Author:    vmoura
 Purpose:
 History:

      TENTExport is a class to export data from Exchequer database.

      This class can access different classes to export an specific type of
      data, like customer.

      The idea is just create a new class and use the UserReference to get
      access to it.

-----------------------------------------------------------------------------}

unit uENTExport;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, EExport_TLB, StdVcl, Classes, Sysutils,
  DSRExport_TLB
  ;

type
  TENTExport = Class(TAutoObject, IENTExport, IExportBox)
  private
    fXmlList: TStringList;
    Function GetObjectTable(pReference: Longword): TObject;
  protected
    Function Get_XmlCount: Integer; Safecall;
    Function Get_XmlList(Index: Integer): WideString; Safecall;
    function DoExport(const pDataPath, pParam1, pParam2, pXML, pXSL,
      pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
  public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  end;

Implementation

uses
  ComServ,
  uConsts,
  uExportBaseClass,
  uEXCHBaseClass,
  uCustExport,
  uVATExport,
  uCurrencyExport,
  uCCDeptExport,
  uDocNumberExport,
  uGLCodeExport,
  uGLStructureExport,
  uTransactionExport
  ;

{ TENTExport }

destructor TENTExport.Destroy;
begin
  If Assigned(fXmlList) Then
  Begin
    fXmlList.Clear;
    FreeAndNil(fXmlList);
  End;

  Inherited Destroy;
End;

// ---------------------------------------------------------------------------

function TENTExport.GetObjectTable(pReference: Longword): TObject;
{ Creates and returns an Export object matching the supplied reference. }
begin
  Result := nil;
  case pReference of
    cVATTable:  Result := TVATExport.Create;
    cCurrencyTable: Result := TCurrencyExport.Create;
    cCostCentreTable:
      begin
        Result := TCCDeptExport.Create;
        TCCDeptExport(Result).ExportType := cdExportCostCentres;
      end;
    cDeptTable:
      begin
        Result := TCCDeptExport.Create;
        TCCDeptExport(Result).ExportType := cdExportDepartments;
      end;
    cDocNumbersTable: Result := TDocNumberExport.Create;
    cGLCodeTable: Result := TGLCodeExport.Create;
    cGLStructureTable: Result := TGLStructureExport.Create;
    cCustTable:
      begin
        Result := TCustExport.Create;
        TCustExport(Result).ExportType := csExportCustomers;
      end;
    cSupplierTable:
      begin
        Result := TCustExport.Create;
        TCustExport(Result).ExportType := csExportSuppliers;
      end;
    cTransactionTable: Result := TTransactionExport.Create;
  end;
end;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
  Arguments: None
  Result:    None
-----------------------------------------------------------------------------}
Procedure TENTExport.Initialize;
Begin
  Inherited Initialize;
  fXmlList := TStringList.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlCount
  Author:    vmoura
  Arguments: None
  Result:    Integer
-----------------------------------------------------------------------------}
Function TENTExport.Get_XmlCount: Integer;
Begin
  If Assigned(fXmlList) Then
    Result := fXmlList.Count;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlList
  Author:    vmoura
  Arguments: Index: Integer
  Result:    WideString
-----------------------------------------------------------------------------}
Function TENTExport.Get_XmlList(Index: Integer): WideString;
Begin
  // test the index
  If Assigned(fXmlList) And (Index >= 0) And (Index < fXmlList.Count) Then
  Try
    Result := fXmlList[Index];
  Except
    Result := '';
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: DoExport
  Author:    vmoura

  pDataPath: exchequer path reference
  pParam1 and pParam2 are parameters of the search engine
  pXml is the Xml structure to a specific kind of data
  pXsl is the transformation file to the xml reference above
  pXsd is the schema validation to the xml above
  pUserReference is an user identification to a kind of data
                 example: customer on exchequer has the value 1
-----------------------------------------------------------------------------}
function TENTExport.DoExport(const pDataPath, pParam1, pParam2, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
Var
  lTable: TObject;
  liCont: Integer;
Begin
  Result := S_OK;

  // get the right object to export
  lTable := GetObjectTable(pUserReference);
  If Assigned(lTable) Then
  Begin

    With _ExportBase(lTable) Do
    Begin
      UserReference := pUserReference;
      XMLFile := pXML;
      XSLFile := pXSL;
      XSDFile := pXSD;

      // set the exchequer path and multicurrency variables
      DataPath := pDataPath;
      fXmlList.Clear;

      // Set the "search" parameters
      Param1 := pParam1;
      Param2 := pParam2;

      // load records from the exchequer database
      If LoadFromDB Then
      Begin
      // create xml structured packets
        For liCont := 0 To List.Count - 1 Do
          fXmlList.Add(XmlRecord[liCont]);
      End 
      Else
        Result := cNODATATOBEEXPORTED;
    End; // with

    //dont forget to free the object
    FreeAndNil(_ExportBase(lTable));
  End
  Else
    Result := cEXCHINVALIDTABLE;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TENTExport, Class_ENTExport,
    ciMultiInstance, tmApartment);
End.

