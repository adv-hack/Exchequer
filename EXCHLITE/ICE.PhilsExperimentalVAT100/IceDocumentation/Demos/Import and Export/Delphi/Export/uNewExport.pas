Unit uNewExport;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, DemoExport_TLB, StdVcl, Classes,
  DSRExport_TLB;

Type
  TNewExport = Class(TAutoObject, INewExport, IExportBox)
  Private
    // add your list here
    fList: TStringList;
  Protected
    function DoExport(pCompany: LongWord; const pPath: WideString;
      pMultiCurr: Shortint; const pParam1, pParam2, pXML, pXSL,
      pXSD: WideString; pUserReference: LongWord): LongWord; safecall;
    function Get_XmlCount: Integer; safecall;
    function Get_XmlList(Index: Integer): WideString; safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ;

{ TNewExport }

Destructor TNewExport.Destroy;
Begin
  fList.Free;
  Inherited Destroy;
End;

Procedure TNewExport.Initialize;
Begin
  Inherited Initialize;
  // create your object list
  fList := TStringList.Create;
End;

function TNewExport.DoExport(pCompany: LongWord; const pPath: WideString;
  pMultiCurr: Shortint; const pParam1, pParam2, pXML, pXSL,
  pXSD: WideString; pUserReference: LongWord): LongWord;
begin
  // set the result of the operation...
  Result := S_OK;
  // do your search here...

  // if everything is ok, get the result, create xml and add into your list
  // otherwise, set an error status to pResult
  fList.Add('add your xml here');
end;

function TNewExport.Get_XmlCount: Integer;
begin
  // get the counter
  Result := fList.Count;
end;

function TNewExport.Get_XmlList(Index: Integer): WideString;
begin
  // test the index
  If (Index >= 0) And (Index < fList.Count) Then
  Try
    // retrieve the xml
    Result := fList[Index];
  Except
  End;
end;

Initialization
  TAutoObjectFactory.Create(ComServer, TNewExport, Class_NewExport,
    ciMultiInstance, tmApartment);
End.

