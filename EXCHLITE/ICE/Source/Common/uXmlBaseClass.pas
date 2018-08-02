{-----------------------------------------------------------------------------
 Unit Name: uXmlBaseClass
 Author:    vmoura
 Date:
 Purpose:  xmls base class
 History:

  //  fXMLDoc := CreateOleObject('Msxml2.DOMDocument.4.0') As DOMDocument40;
  //  fXSLDoc := CreateOleObject('Msxml2.DOMDocument.4.0') As DOMDocument40;
  //  fXSDDoc := CreateOleObject('Msxml2.XMLSchemaCache.4.0') As XMLSchemaCache40;

-----------------------------------------------------------------------------}

Unit uXmlBaseClass;

Interface

Uses
  Classes, SysUtils, Activex,
  MSXML2_TLB,
  uBaseClass, uConsts
  ;

Const
  cREMOVECOMMENTS =
    '<?xml version="1.0"?> ' +
    '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"> ' +
    '<xsl:output method="xml" encoding="ISO-8859-1" indent="yes" %s/> ' +
    '<xsl:template match="@*|node()"> ' +
    '  <xsl:copy> ' +
    '     <xsl:apply-templates select="@*"/> ' +
    '     <xsl:apply-templates select="node()"/> ' +
    '  </xsl:copy> ' +
    '</xsl:template> ' +
    '<xsl:template match="comment()"> ' +
    '</xsl:template> ' +
    '</xsl:stylesheet> ';

Type
  // base class and the structure
  _XMLBase = Class(_Base)
  Protected
    Function Save(Const pFile: String): Boolean; Overload; Virtual; Abstract;
    // save a file to disc
    Function SaveXml(Const pXml: WideString; Const pFile: String): Boolean;
      Overload; Virtual; Abstract;
    // save a xml from string
    Function Load(Const pFile: String): Boolean; Virtual; Abstract;
    // load xml from disc
    Function LoadXml(Const pXml: WideString): Boolean; Virtual; Abstract;
    // load xml from string
  Public
  End;

  _XMLDoc = Class(_XMLBase)
  Private
    fDoc: DOMDocument40;
(*    Function ApplyEnconde(Const pXml: WideString): WideString;
    Function ChangeEncode(Const pFile: String): WideString; Overload;
    Function ChangeEncode(Const pXML: WideString): WideString; Overload;*)
  Public
    Function ApplyEnconde(Const pXml: WideString): WideString; overload;
    Function ApplyEncondeEx(Const pXml: WideString; const pEncode: String = cMSXMLISO88591): WideString;
    Function ChangeEncode(Const pFile: String): WideString; Overload;
    Function ChangeEncode(Const pXML: WideString): WideString; Overload;

    Function Save(Const pFile: String): Boolean; Override;
    Function SaveXml(Const pXml: WideString; Const pFile: String): Boolean;
      Override;
    Function Load(Const pFile: String): Boolean; Override;
    Function LoadXml(Const pXml: WideString): Boolean; Override;
    Procedure Clear;

    Constructor Create; Reintroduce;
    Destructor Destroy; Override;

    Property Doc: DOMDocument40 Read fDoc Write fDoc;
  End;

  TXMLDoc = Class(_XMLDoc)
  Public
    Procedure RemoveComments(CDATASections: String = ''); Virtual;
    Function Transform(Const pXml: WideString): WideString; Overload;

    Function Transform(pXSL: DOMDocument40): WideString; Overload;

    Function Validate(Const pFile: String; Const pXml: WideString): Boolean;
      Virtual;

  End;

  TXSLDoc = Class(_XMLDoc); // just to be a different name in the context

Implementation

Uses ComObj, Variants,
  uCommon;

{ TXMLDoc }

{-----------------------------------------------------------------------------
  Procedure: Clear
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _XMLDoc.Clear;
Begin
  fDoc.load('');
End;

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor _XMLDoc.Create;
Begin
  Inherited Create;
  CoInitialize(Nil);
  fDoc := CreateOleObject(cMSXML40) As DOMDocument40;
  fDoc.preserveWhiteSpace := False;
  fDoc.async := False;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor _XMLDoc.Destroy;
Begin
  Clear;
  fDoc := Nil;
  CoUninitialize;
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: ApplyEnconde
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.ApplyEnconde(Const pXml: WideString): WideString;
Begin
  Result := pXml;
  If (Pos(Lowercase(cMSXMLISO88591), Lowercase(Result)) = 0) And
    (Pos('encoding', Lowercase(Result)) = 0) Then
    Result := StringReplace(Result, '?>', ' encoding="' + cMSXMLISO88591 +
      '"?>', []);
End;

{-----------------------------------------------------------------------------
  Procedure: ApplyEncondeEx
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.ApplyEncondeEx(Const pXml: WideString; const pEncode: String = cMSXMLISO88591): WideString;
begin
  Result := pXml;
  If (Pos(Lowercase(pEncode), Lowercase(Result)) = 0) And
    (Pos('encoding', Lowercase(Result)) = 0) Then
    Result := StringReplace(Result, '?>', ' encoding="' + pEncode +
      '"?>', []);
end;

{-----------------------------------------------------------------------------
  Procedure: ChangeEncode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.ChangeEncode(Const pFile: String): WideString;
Var
  lAux: TStringlist;
Begin
  lAux := TStringlist.Create;
  Try
    lAux.LoadFromFile(pFile);
  Finally
    Result := lAux.Text;
  End;

  lAux.Free;
  Result := ApplyEnconde(Result);
End;

{-----------------------------------------------------------------------------
  Procedure: ChangeEncode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.ChangeEncode(Const pXML: WideString): WideString;
Begin
  Result := ApplyEnconde(pXML);
End;

{-----------------------------------------------------------------------------
  Procedure: Load
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.Load(Const pFile: String): Boolean;
Var
  lXml: WideString;
Begin
  Result := False;
  If _FileSize(pFile) > 0 Then
  Begin
    {without changing the xml encode, MSXML can not load characters like £}
    lXml := ChangeEncode(pFile);
    Try
      Result := fDoc.loadXML(lXml);
    Finally
      If fDoc.xml = '' Then
        DoLogMessage('_XMLDoc.Load', cINVALIDXML, 'Error: ' +
          _GetXmlParseError(fDoc.parseError))
    End;
  End {try loading as a xml}
  Else If Not LoadXml(pFile) Then
    DoLogMessage('TXMLDoc.Load', cINVALIDXML, Copy(pFile, 1, 255));
End;

{-----------------------------------------------------------------------------
  Procedure: LoadXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.LoadXml(Const pXml: WideString): Boolean;
Var
  lXml: WideString;
Begin
  Result := False;
  If pXml <> '' Then
  Begin
    lXml := ChangeEncode(pXml);
    Try
      Result := fDoc.loadXML(lXml);
      If Not Result And (_FileSize(lXml) > 0) Then
        fDoc.load(lXml)
    Finally
      If fDoc.xml = '' Then
        DoLogMessage('_XMLDoc.Load', cINVALIDXML, 'Error: ' +
          _GetXmlParseError(fDoc.parseError));
    End;
  End
  Else
    DoLogMessage('_XMLDoc.LoadXml', cEMPTYXML);
End;

{-----------------------------------------------------------------------------
  Procedure: SaveXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.Save(Const pFile: String): Boolean;
Begin
  Result := False;
  If fDoc.xml <> '' Then
    Result := SaveXml(fDoc.xml, pFile)
  Else
    DoLogMessage('TXMLDoc.SaveXml', cSAVINGFILEERROR,
      _TranslateErrorCode(cEMPTYXML));
End;

{-----------------------------------------------------------------------------
  Procedure: SaveXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _XMLDoc.SaveXml(Const pXml: WideString; Const pFile: String): Boolean;
Var
//  lStr: TStringList;
  lPath: String;
Begin
  Result := False;

  If pXml <> '' Then
  Begin
    If _FileSize(pFile) > 0 Then
      DeleteFile(pFile);

    lPath := ExtractFilePath(pFile);

    If (Trim(lPath) = '') Or Not _DirExists(lpath) Then
      lPath := _GetApplicationPath;

    If Not _DirExists(lpath) Then
      ForceDirectories(lpath);

    Result := _CreateXmlFile(lPath + ExtractFileName(pFile), pXml);
    (*
    lStr := TStringList.Create;
    Try
      lStr.Text := pXml;
      lStr.SaveToFile(pFile);
      Result := True;
    Except
      On e: exception Do
      Begin
        DoLogMessage('_XMLDoc.SaveXml', cSAVINGFILEERROR, 'Error: ' +
          e.Message);
        If FileExists(pFile) Then
          DeleteFile(pFile);
      End;
    End;

    FreeAndNil(lStr);
    *)
  End
  Else
    DoLogMessage('_XMLDoc.SaveXml', cEMPTYXML);
End;

{ TXMLDoc }

{ RemoveComments uses the XSLT transformation in cREMOVECOMMENTS to remove any
  comments from the current XML. The optional CDATASections parameters, if
  supplied, should be a whitespace-separated list of the XML nodes which are
  CDATA elements (XSLT does not normally preserve CDATA nodes -- it transforms
  them into simple text nodes). }
Procedure TXMLDoc.RemoveComments(CDATASections: String);
Var
  lXml: WideString;
  lRemoveComments: String;
Begin
  If (CDATASections <> '') Then
    lRemoveComments := Format(cREMOVECOMMENTS, ['cdata-section-elements="' +
      CDATASections + '" '])
  Else
    lRemoveComments := Format(cREMOVECOMMENTS, ['']);
  lXml := Transform(lRemoveComments);
  If lXml <> '' Then
  Begin
    self.Clear;
    Self.LoadXml(lXml)
  End
  Else
    DoLogMessage('TXMLDoc.RemoveComments', cTRANSFORMINGXMLERROR,
      'Removing comments');
End;

{-----------------------------------------------------------------------------
  Procedure: Transform
  Author:    vmoura

  load a xml or a file and try to transform it...
-----------------------------------------------------------------------------}
Function TXMLDoc.Transform(Const pXml: WideString): WideString;
Var
  lXsl: TXSLDoc;
Begin
  Result := '';
  lXsl := TXSLDoc.Create;

  Try
    If _FileSize(pXml) > 0 Then
      lXsl.Load(pXml)
    Else
      lXsl.LoadXml(pXml);

    If lXsl.fDoc.xml <> '' Then
      Result := Transform(lXsl.fDoc)
    Else
      DoLogMessage('TXMLDoc.Transform', cLOADINGFILEERROR,
        _TranslateErrorCode(cEMPTYXML));
  Except
    On e: exception Do
      DoLogMessage('TXMLDoc.Transform', cLOADINGFILEERROR, 'Error: ' +
        e.Message);
  End;

  FreeAndNil(lXsl);
End;

{-----------------------------------------------------------------------------
  Procedure: Transform
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TXMLDoc.Transform(pXSL: DOMDocument40): WideString;
Begin
  Result := '';
  If fDoc.xml <> '' Then
  Try
    Result := fDoc.transformNode(pXsl);
  Except
    On e: exception Do
      DoLogMessage('TXMLDoc.Transform', cTRANSFORMINGXMLERROR, 'Error: ' +
        e.Message);
  End
  Else
    DoLogMessage('TXMLDoc.Transform', cEMPTYXML);
End;

{-----------------------------------------------------------------------------
  Procedure: Validate
  Author:    vmoura

  it is just a option to load a file or a xml
-----------------------------------------------------------------------------}
Function TXMLDoc.Validate(Const pFile: String; Const pXml: WideString): Boolean;
Var
  lSchema: XMLSchemaCache40;
  lSchemaDoc: DOMDocument40;
  lTarget: String;
  lTmpXml: WideString;
Begin
  Result := False;

  If fDoc.xml <> '' Then // test xml
  Try
    fDoc.schemas := Unassigned;
    lTmpXml := fDoc.xml; // save temp xml
    Clear;

    // create schema interface

    lSchema := CreateOleObject(cMSXML40SCHEMA) As XMLSchemaCache40;
    lSchemaDoc := CreateOleObject(cMSXML40) As DOMDocument40;
    lSchemaDoc.async := False;

    Try
      // get xml from file
      If (pFile <> '') Then
      Begin
        If _FileSize(pFile) > 0 Then
        Begin
          If Not lSchemaDoc.load(pFile) Then
            DoLogMessage('TXMLDoc.Validate', cLOADINGXSDERROR, pFile);
        End
        Else
          DoLogMessage('TXMLDoc.Validate', cFILENOTFOUND, pFile);
      End
      Else If pXml <> '' Then // get xml from text
      Begin
        If Not lSchemaDoc.loadXML(pXml) Then
          DoLogMessage('TXMLDoc.Validate', cLOADINGXSDERROR);
      End
      Else
        DoLogMessage('TXMLDoc.Validate', cEMPTYXML);

      Try
        // get the target where the validation will be applied
        If lSchemaDoc.xml <> '' Then
        Begin
          lTarget := lSchemaDoc.selectSingleNode('//*/@targetNamespace').Text;
          lSchema.add(lTarget, lSchemaDoc);
        End;
      Except
        On e: exception Do
        Begin
          DoLogMessage('TXMLDoc.Validate', cLOADINGXSDERROR, 'Error: ' +
            e.Message);
          lTarget := '';
        End;
      End;
    Except
      On e: Exception Do
      Begin
        DoLogMessage('TXMLDoc.Validate', cLOADINGXSDERROR, 'Error: ' +
          e.Message);
        lTarget := '';
      End;
    End;

    If lTarget <> '' Then
    Begin
      fDoc.schemas := lSchema;

      Try
         // validate xml agains schema
        If fDoc.loadXML(lTmpXml) Then
          // validate xml agains schema
          Result := True
        Else
        Begin
          Result := False;
          DoLogMessage('TXMLDoc.Validate', cINVALIDXML, 'Error: ' +
            _GetXmlParseError(fDoc.parseError));
        End;
      Except
        On e: exception Do
          DoLogMessage('TXMLDoc.Validate', cVALIDATINGXMLERROR, 'Error: ' +
            e.Message);
      End;
    End;
  Finally
    If Assigned(lSchema) Then
      lSchema := Nil;

    If Assigned(lSchemaDoc) Then
      lSchemaDoc := Nil;

    fDoc.schemas := Unassigned;
  End
  Else
    DoLogMessage('TXMLDoc.Validate', cEMPTYXML);
End;

End.

