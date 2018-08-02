{-----------------------------------------------------------------------------
 Unit Name: uImportBox
 Author:    vmoura
 Purpose:
 History:

       The import box is a interface to import data through com objects. The ideia is
      get the class TImportBox and add it into a new class where you
      can get the xml values and store it into your database

-----------------------------------------------------------------------------}
unit uImportBox;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, DSRImport_TLB, StdVcl;

type
  TImportBox = class(TAutoObject, IImportBox)
  protected
    function DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
      pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
  end;

implementation

uses ComServ;

{-----------------------------------------------------------------------------
  Procedure: DoImport
  Author:    vmoura
  Arguments: pCompany: LongWord; const pPath: WideString; pMultiCurr: Shortint; const pXML, pXSL, pXSD: WideString; pUserReference: LongWord; out pResult: LongWord
  Result:    None
-----------------------------------------------------------------------------}
function TImportBox.DoImport(const pCompanyCode, pDataPath, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
begin

end;

initialization
  TAutoObjectFactory.Create(ComServer, TImportBox, Class_ImportBox,
    ciMultiInstance, tmApartment);
end.
