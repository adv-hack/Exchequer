{-----------------------------------------------------------------------------
 Unit Name: uImportBaseClass
 Author:    vmoura
 Date:      13-Oct-2005
 Purpose:
 History:

-----------------------------------------------------------------------------}
Unit uImportBaseClass;

Interface

Uses Classes, Forms, SysUtils, Variants, MSXML2_TLB,
  // ICE units
  uXmlBaseClass,
  uBaseClass,
  uConsts,
  uCommon,
  uEXCHBaseClass
  ;

{$I Ice.inc}

Type
  _ImportBase = Class(_EXCH)
  Private
    fDoc: TXMLDoc;
    fUserReference: Integer;
    fList: Tlist;
    fIncludeTrace: Boolean;
    fCompanyCode: string;
  Protected
    Function GetHeader(pXmlNode: IXMLDOMNode): TXMLHeader;
    Procedure AddRecord(pNode: IXMLDOMNode); Virtual; abstract;
    Procedure Clear; Virtual;
    Function GetRecordValue(pXmlNode: IXMLDOMNode; Var pRecord: Pointer): Boolean; Virtual; Abstract;
    Function SaveRecord(pRecord: Pointer; pRecSize: Integer; pUpdateMode: Smallint): Boolean; virtual; abstract;
  Public
    Constructor Create; virtual;
    Destructor Destroy; Override;
    Function Extract: Boolean;
    Function SaveListtoDB: Boolean; virtual; abstract;
    procedure Trace(Msg: string);
  Published
    Property List: TList Read fList Write fList;
    Property UserReference: Integer Read fUserReference Write fUserReference;
    property XMLDoc: TXmlDoc read fDoc write fDoc;
    property IncludeTrace: Boolean read fIncludeTrace write fIncludeTrace;
    property CompanyCode: string read fCompanyCode write fCompanyCode;
  End;

Implementation

// ===========================================================================
// _ImportBase
// ===========================================================================

Constructor _ImportBase.Create;
Begin
  Inherited Create;
  fDoc:= TXMLDoc.Create;
  fList := TList.Create;
  fIncludeTrace := False;
End;

// ---------------------------------------------------------------------------

Destructor _ImportBase.Destroy;
Begin
  Clear;
  fList.Clear;
  FreeAndNil(fDoc);
  Inherited Destroy;
End;

// ---------------------------------------------------------------------------

Function _ImportBase.GetHeader(pXmlNode: IXMLDOMNode): TXMLHeader;
Var
  lNode: IXMLDOMNode;
Begin
  lNode := _GetNodeByName(pXmlNode, 'message');

  If lNode <> Nil Then
  Begin
    FillChar(Result, Sizeof(TXMLHeader), #0);

    With Result Do
    Begin
      Guid := StringToGUID(varasType(lNode.attributes[0].NodeValue, varString));
      Number := varasType(lNode.attributes[1].NodeValue, varSmallint);
      Count := varasType(lNode.attributes[2].NodeValue, varSmallint);
      Source := varasType(lNode.attributes[3].NodeValue, varString);
      Destination := varasType(lNode.attributes[4].NodeValue, varString);
      Flag := varasType(lNode.attributes[5].NodeValue, varByte);
    End;
  End
  Else
    DologMessage('_ImportBase.GetMessageHeader', cINVALIDXMLNODE, 'message');
End;

// ---------------------------------------------------------------------------

Function _ImportBase.Extract: Boolean;

  function GetNameSpace: string;
  var
    CharPos: Integer;
  begin
    Result := XmlDoc.Doc.namespaces.namespaceURI[0];
    CharPos := LastDelimiter(':', Result);
    if (CharPos <> 0) then
      Result := Copy(Result, CharPos + 1, Length(Result));
  end;

Var
  lCont,
  lRecords,
  lRecordCount: Integer;
  lNode: IXMLDOMNode;
Begin
  Result := False;

  lNode := _GetNodeByName(XmlDoc.Doc, 'message');

  lRecordCount := 0;
    // Get records from message to the end
  If lNode <> Nil Then
  Begin
    lRecords := _GetXmlRecordCount(lNode); // get record count
    If lRecords > 0 Then
    Begin
      Result := True;
      For lCont := 0 To lRecords - 1 Do
      Try
        lRecordCount := lRecordCount + 1;
        AddRecord(lNode.childNodes[lCont]);
        Application.ProcessMessages;
      Except
        On e: exception Do
        Begin
          Result := False;
          DoLogMessage('_ImportBase.Extract', 0, 'Error: ' + GetNameSpace + ': ' + e.message);
          Clear;
          Break;
        End;
      End; // for
    End // records > 0
    Else
      DoLogMessage('_ImportBase.Extract', cNOXMLRECORDSFOUND, 'ImpType ' +
        inttostr(UserReference));
  End // node <> nil
  Else
    DoLogMessage('_ImportBase.Extract', cINVALIDXMLNODE, 'message');
End;

// ---------------------------------------------------------------------------

procedure _ImportBase.Clear;
Var
  lCont: Integer;
  lObj: TObject;
Begin
  Try
    For lCont := fList.Count - 1 Downto 0 Do
      If fList[lCont] <> Nil Then
      Begin
        lObj := TObject(fList[lCont]);
        FreeAndNil(lObj);
        fList.Delete(lCont);
      End;
  Except
  End;
end;

// ---------------------------------------------------------------------------

procedure _ImportBase.Trace(Msg: string);
begin
  if IncludeTrace then
    DoLogMessage(Msg, 0);
end;

// ---------------------------------------------------------------------------

End.

