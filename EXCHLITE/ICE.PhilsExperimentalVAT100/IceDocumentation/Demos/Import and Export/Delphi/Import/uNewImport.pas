Unit uNewImport;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DemoImport_TLB, StdVcl, DSRImport_TLB;

Type
  TNewImport = Class(TAutoObject, INewImport, IImportBox)
  Protected
    function DoImport(pCompany: LongWord; const pPath: WideString;
      pMultiCurr: Shortint; const pXML, pXSL, pXSD: WideString;
      pUserReference: LongWord): LongWord; safecall;
  Public
  End;

Implementation

Uses ComServ;

{ TNewImport }

function TNewImport.DoImport(pCompany: LongWord; const pPath: WideString;
  pMultiCurr: Shortint; const pXML, pXSL, pXSD: WideString;
  pUserReference: LongWord): LongWord;
begin
  // load the xml
  // transform and validate it if necessary
  // get the node values
  // store into your system
end;

Initialization
  TAutoObjectFactory.Create(ComServer, TNewImport, Class_NewImport,
    ciMultiInstance, tmApartment);
End.

