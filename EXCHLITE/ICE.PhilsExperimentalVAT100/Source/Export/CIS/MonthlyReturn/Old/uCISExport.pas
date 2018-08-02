{-----------------------------------------------------------------------------
 Unit Name: uCISExport
 Author:    vmoura
 Purpose: return the CIS xml from the path (company) given
 History:
-----------------------------------------------------------------------------}
Unit uCISExport;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, StdVcl, CISExp_TLB, DSRExport_TLB;

Type
  TCISExport = Class(TAutoObject, IExportBox)
  Private
    fXml: WideString;
  Protected
    Function DoExport(Const pCompanyCode, pDataPath, pXMLPath: WideString;
      pParam1, pParam2, pParam3, pParam4: OleVariant;
      pUserReference: LongWord): LongWord; Safecall;
    Function Get_XmlCount: Integer; Safecall;
    Function Get_XmlList(Index: Integer): WideString; Safecall;
    { Protected declarations }
  End;

Implementation

Uses ComServ, Sysutils,
  uCommon, uConsts, uXMLBaseclass, MSXML2_TLB, uSystemConfig;

{-----------------------------------------------------------------------------
  Procedure: DoExport
  Author:    vmoura

  get the cis xml from the specified company and format it using the dsr header
-----------------------------------------------------------------------------}
Function TCISExport.DoExport(Const pCompanyCode, pDataPath,
  pXMLPath: WideString; pParam1, pParam2, pParam3, pParam4: OleVariant;
  pUserReference: LongWord): LongWord;
Var
  lDoc, lCIS: TXMLDoc; {xmls dom objects for loading files}
  lNode: IXMLDOMNode; {temp node object}
  lSys: TSystemConf; {system obj}
  lOldFile, lNewFile: String;
Begin
  fXml := '';

  {check the company path}
  If _DirExists(pDataPath) Then
  Begin
    //lOldFile := IncludeTrailingPathDelimiter(pDataPath) + cCISXMLDIR + '\CISreturn.xml';
    lOldFile := IncludeTrailingPathDelimiter(pDataPath) + cCISXMLDIR + '\' +
      cCISMONTHLYRETFILEPROCESS;

    If _FileSize(lOldFile) > 0 Then
    Begin
      lSys := Nil;
      lDoc := Nil;
      lCis := Nil;

      Try
      {system parameters obj}
        lSys := TSystemConf.Create;
      {dom object to load the cis xml}
        lDoc := TXMLDoc.Create;
        lDoc.LoadXml(lOldFile);

      {default dsr xml format}
        lCIS := TXMLDoc.Create;
        lCIS.LoadXml(IncludeTrailingPathDelimiter(pXMLPath) + cCISXML);

        lNode := _GetNodeByName(lCis.Doc, 'cisxml');
      {check if the cis node exists}
        If lNode <> Nil Then
        Begin
        {set the whole xml into the cmdata}
          _SetNodeValueByName(lNode, cCISXMLNODE, lDoc.Doc.xml);
          lNewFile := IncludeTrailingPathDelimiter(pDataPath) + cCISXMLDIR + '\' +
            _CreateGuidStr + cXMLEXT;

        {save the file...}
          lCIS.Save(lNewFile);

        {check fif the file exists}
          If _FileSize(lNewFile) > 0 Then
          Begin
          {delete the old file}
            _DelFile(lOldFile);

          {this will be the file used by the dsr sender thread}
            fXml := lNewFile;

            Result := S_OK;
          End {If _FileSize(lNewFile) > 0 Then}
          Else
            Result := cFILEANDXMLERROR;
        End; {If _FileSize(lOldFile) > 0 then}
      Except
        On e: exception Do
        Begin
          Result := cERROR;
          _LogMSG('TCISExport.DoExport :- Error exporting CIS XML file. Error: ' +
            e.Message);
        End; {begin}
      End; {try}

      {free objects section}
      If Assigned(lSys) Then
        lSys.Free;

      If Assigned(lCIS) Then
        lCis.Free;

      If Assigned(lDoc) Then
        ldoc.Free;
    End {If _FileSize(lOldFile) > 0 Then}
    Else
      Result := cFILENOTFOUND
  End {if _DirExists(pDataPath) then}
  Else
    Result := cINVALIDPARAM;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlCount
  Author:    vmoura

  this function will allways return 1
-----------------------------------------------------------------------------}
Function TCISExport.Get_XmlCount: Integer;
Begin
  Result := 0;
  If (fXml <> '') And (_FileSize(fXMl) > 0) Then
    Result := 1;
End;

{-----------------------------------------------------------------------------
  Procedure: Get_XmlList
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISExport.Get_XmlList(Index: Integer): WideString;
Begin
  If fXml <> '' Then
    Result := fXml;
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISExport, Class_CISExport,
    ciMultiInstance, tmApartment);
End.

