{-----------------------------------------------------------------------------
 Unit Name: uExportBox
 Author:    vmoura
 Purpose:
 History:

      The export box is a interface to export com objects. The ideia is
      get the class TExportBox and add it into a new class where you
      can get the data from a database, create the xmls and store it into a list.
      The dsr will get access to this list, get the xmls and send through the COMS Layer.
-----------------------------------------------------------------------------}
Unit uExportBox;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DSRExport_TLB, StdVcl;

Type
  TExportBox = Class(TAutoObject, IExportBox)
  Protected
    function DoExport(const pCompanyCode, pDataPath, pXMLPath: WideString;
      pParam1, pParam2, pParam3, pParam4: OleVariant;
      pUserReference: LongWord): LongWord; safecall;
    Function Get_XmlCount: Integer; Safecall;
    Function Get_XmlList(Index: Integer): WideString; Safecall;
  End;

Implementation

Uses ComServ;

{-----------------------------------------------------------------------------
  Procedure: DoExport
  Author:    vmoura
  Arguments: pCompany: LongWord; const pPath: WideString; pMultiCurr: Shortint; pParam1, pParam2: OleVariant; const pXML, pXSL, pXSD: WideString; pUserReference: LongWord; out pResult: LongWord
  Result:    None

-----------------------------------------------------------------------------}
function TExportBox.DoExport(const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlCount
  Author:    vmoura
  Arguments: None
  Result:    Integer

  Get the number of the xmls holding by a list
-----------------------------------------------------------------------------}
Function TExportBox.Get_XmlCount: Integer;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlList
  Author:    vmoura
  Arguments: Index: Integer
  Result:    WideString

  give the xml itself
-----------------------------------------------------------------------------}
Function TExportBox.Get_XmlList(Index: Integer): WideString;
Begin

End;

Initialization
  TAutoObjectFactory.Create(ComServer, TExportBox, Class_ExportBox,
    ciMultiInstance, tmApartment);
End.

