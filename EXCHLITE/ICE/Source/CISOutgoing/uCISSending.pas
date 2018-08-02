{-----------------------------------------------------------------------------
 Unit Name: uCISSending
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISSending;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISOutgoing_TLB, StdVcl, DSROutgoing_TLB,

  uAdoDSR, uBaseClass

  ;

Type
  TCISSending = Class(TAutoObject, ICISSending, IDSROutgoingSystem)
  Private
    fDb: TADODSR;
    fLog: _Base;
    FFiles: String;

    Function PostDocument(Const pXml: WideString): Longword;
    Function WriteError(pError: Longword; Const pWhere, pMessage: String):
      Longword;
  Protected
    Function SendMsg: LongWord; Safecall;

    Function Get_Authentication: WordBool; Safecall;
    Function Get_BCC: WideString; Safecall;
    Function Get_Body: WideString; Safecall;
    Function Get_CC: WideString; Safecall;
    Function Get_Files: WideString; Safecall;
    Function Get_OutgoingPassword: WideString; Safecall;
    Function Get_OutgoingPort: Integer; Safecall;
    Function Get_OutgoingServer: WideString; Safecall;
    Function Get_OutgoingUsername: WideString; Safecall;
    Function Get_Password: WideString; Safecall;
    Function Get_ServerType: WideString; Safecall;
    Function Get_SSLOutgoing: WordBool; Safecall;
    Function Get_Subject: WideString; Safecall;
    Function Get_To_: WideString; Safecall;
    Function Get_UserName: WideString; Safecall;
    Function Get_YourEmail: WideString; Safecall;
    Function Get_YourName: WideString; Safecall;
    Procedure Set_Authentication(Value: WordBool); Safecall;
    Procedure Set_BCC(Const Value: WideString); Safecall;
    Procedure Set_Body(Const Value: WideString); Safecall;
    Procedure Set_CC(Const Value: WideString); Safecall;
    Procedure Set_Files(Const Value: WideString); Safecall;
    Procedure Set_OutgoingPassword(Const Value: WideString); Safecall;
    Procedure Set_OutgoingPort(Value: Integer); Safecall;
    Procedure Set_OutgoingServer(Const Value: WideString); Safecall;
    Procedure Set_OutgoingUsername(Const Value: WideString); Safecall;
    Procedure Set_Password(Const Value: WideString); Safecall;
    Procedure Set_ServerType(Const Value: WideString); Safecall;
    Procedure Set_SSLOutgoing(Value: WordBool); Safecall;
    Procedure Set_Subject(Const Value: WideString); Safecall;
    Procedure Set_To_(Const Value: WideString); Safecall;
    Procedure Set_UserName(Const Value: WideString); Safecall;
    Procedure Set_YourEmail(Const Value: WideString); Safecall;
    Procedure Set_YourName(Const Value: WideString); Safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ, Sysutils, Classes, windows,

  {FBI-CIS component}
  InternetFiling_TLB,

  {msxml}
  MSXML2_TLB,

  uCommon,
  uConsts,
  uDSRSettings,
  uDSRFileFunc,
  uSystemConfig,

  uXmlBaseClass,

  {cis files}
  CISXCnst

  ;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCISSending.Destroy;
Begin
  If Assigned(fDb) Then
    fDb.Free;

  fLog.Free;

  CoUninitialize;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISSending.Initialize;
Begin
  Inherited;
  CoInitialize(Nil);

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('CIS Outgoing database connection error: ' + E.MEssage);
  End; {try}

  If fDb <> Nil Then
  Begin
    If fDb.Connected Then
      _LogMSG('CIS Outgoing database is connected...')
    Else
      _LogMSG('CIS Outgoing database is not connected...');
  End
  Else
    _LogMSG('CIS Outgoing database is not connected...');

  fLog := _Base.Create;
  If fDb <> Nil Then
    fLog.ConnectionString := fDb.ConnectionString;
End;

{-----------------------------------------------------------------------------
  Procedure: PostDocument
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSending.PostDocument(Const pXml: WideString): Longword;
Var
  lPosting: _Posting; {fbi posting object}
  lXmlPost, {xml to be posted}
    lIrMark, {irmark generated}
    lClassType, {ggw class type id}
    lXmlRes: WideString; {xml response from ggw}
  lXmlDoc: DOMDocument40; {xml dom doc}
  lReturnFile, {file to be stored}
    lFileGuid, {guid for the stored file}
    lAck, {info returned by ggw}
    lRedirection, {redirection address from ggw}
    lCorrelationId: String; {correlation id returned for the posting}
  lHeader: TXMLHeader; {dsr xmlheader}
  lPollingTime: Integer; {polling time returned}
  {lNameSpace,}
  lNode: IXMLDOMNode; {xml dom node}
  lSys: TSystemConf; {system conf file}
  lIsMonthly: Boolean;
Begin
  Result := S_OK;
  Try
    lPosting := CoPosting.Create;
  Except
    On E: Exception Do
      Result := WriteError(cCOMOBJECTERROR, 'TCISSending.PostDocument', 'Error: '
        + e.Message);
  End; {try}

  {check the object}
  If Assigned(lPosting) Then
  Begin
    Try
      lSys := TSystemConf.Create;

      lXmlDoc := CoDOMDocument40.Create;

      If _FileSize(pXml) > 0 Then
      Begin
        Try
          lXmlDoc.load(pXml);
          lXmlPost := lXmlDoc.xml;
        Finally
          lXmlDoc.loadXML('');
        End;
      End
      Else
        lXmlPost := pXml;

      Try
      {remove tabs in the document before sending}
//        lXmlPost := StringReplace(pXml, Chr(9), '', [rfReplaceAll]);

        FillChar(lHeader, SizeOf(TXMLHeader), 0);

      {get the guid out of this message for updating the database later}
        If _GetXMLHeader(lXmlPost, lHeader) Then
        Begin
          If _IsValidGuid(lHeader.Guid) Then
          Begin
            lXmlDoc.loadXML(lXmlPost);

            lIsMonthly := False;

          {get only the valid cis xml inside the node cisxml. this happen because the dsr
          must use the dsrheader and the xml will be encrypted and compressed using its own format.
          so, i have to use the dsr header to get a guid entry, extract the xml to
          be sent to ggw, apply irmark and post it}
            Try
              If _GetNodeByName(lXmlDoc, cCISXMLNODEMONTHLY) <> Nil Then
              Begin
                lXmlPost := _GetNodeValue(lXmlDoc, cCISXMLNODEMONTHLY);
                lIsMonthly := True;
              End
              Else If _GetNodeByName(lXmlDoc, cCISXMLNODESUB) <> Nil Then
                lXmlPost := _GetNodeValue(lXmlDoc, cCISXMLNODESUB);
            Except
              On e: exception Do
                Result := WriteError(cLOADINGXMLERROR, 'TCISSending.PostDocument',
                  'Error loading CISXMLNODE. Error: ' + e.message);
//                _LogMSG('TCISSending.PostDocument :- Error loading CISXMLNODE. Error: '
//                  + e.message);
            End; {try}

           {get/set IrMark}
            lIrMark := '';
            lXmlDoc.loadXML('');
            lXmlDoc.loadXML(lXmlPost);
            lIrMark := _GetNodeValue(lXmlDoc, cCISIRMARKNODE);

(*            If lIrMark = '' Then
            begin
              lNameSpace := _GetNodeByName(lXmlDoc, IR_ENVELOPE);
              //lIrMark := lPosting.AddIRMark(lXmlPost, 3);
              if lNameSpace <> nil then
                lIrMark := lPosting.AddIRMark(lXmlPost, 3)
              else
                lIrMark := lPosting.AddIRMark_2(lXmlPost, lNameSpace.attributes.getNamedItem(XMLNS).nodeValue);
            end;*)

            If lIrMark <> '' Then
            Begin
            {set the http address}
              If fDb.GetSystemValue(cUSECISTESTPARAM) = '1' Then
              Begin
                //If lIsMonthly Then
                //  lPosting.SetConfiguration(cCISMonthlyReturnLIVE)
                //Else
                //  lPosting.SetConfiguration(cCISVerificationRequestLIVE);
                lPosting.SetConfiguration(cGGWCONFIGTEST)
              End
              Else
              Begin
                //lPosting.SetConfiguration(cGGWCONFIG);
                lPosting.SetConfiguration(cGGWCONFIGLIVE);
              End; {else begin}

              lClassType := _GetNodeValue(lXmlDoc, cCISCLASSNODE);

              With TXMLDoc.Create Do
              Begin
                lXmlPost := ApplyEncondeEx(lXmlPost, cMSXMLUTF8);
                Free;
              End;

              lXmlPost := StringReplace(lXmlPost, Chr(9), '', [rfReplaceAll]);
              lXmlPost := StringReplace(lXmlPost, #13, '', [rfReplaceAll]);
              lXmlPost := StringReplace(lXmlPost, #10, '', [rfReplaceAll]);

            {post the document}
              lXmlRes := '';

{$IFDEF CISTEST}
              Try
                lXmlRes := lPosting.Submit(lClassType, True, lXmlPost);
              Except
              End; {try}
{$ELSE}
              Try
                lXmlRes := lPosting.Submit(lClassType,
                  fDb.GetSystemValue(cUSECISTESTPARAM) = '1', lXmlPost);
              Except
              End; {try}
{$ENDIF}

              If lXmlRes <> '' Then
              Begin
              {clear the xml. try except just in case :) }
                Try
                  lXmlDoc.loadXML('');
                Except
                End;

              {check the returned xml}
                Try
                  lXmlDoc.loadXML(lXmlRes);
                Except
                  On E: exception Do
                    _LogMSG('TCISSending.PostDocument :- Error loading XML result from Gateway. Error: '
                      + e.Message);
                End; {try}

                lReturnFile := IncludeTrailingPathDelimiter(lSys.OutboxDir
                  + GUIDToString(lHeader.Guid));

              {outbox + file directory + cisreturn directory}
                lReturnFile := IncludeTrailingPathDelimiter(lReturnFile +
                  cCISRETDIR);

                {generate the file guid for this response}
                lFileGuid := GUIDToString(_CreateGuid);

              {outbox + file directory + cisreturn directory + "file name.xml"
              the reason for a new file is that GGW can return more than one
              file for submission (after polling) }
                lReturnFile := lReturnFile + lFileGuid + cXMLEXT;

                Try
                  ForceDirectories(ExtractFilePath(lReturnFile));
                Except
                End;

                _DelFile(lReturnFile);

              {check the response xml}
                If lXmlDoc.xml <> '' Then
                Begin
                  lAck := Lowercase(_GetNodeValue(lXmlDoc, cCISQUALIFIERNODE));
                  lClassType := _GetNodeValue(lXmlDoc, cCISCLASSNODE);

                 {get the correlationid to store into ice database}
                  lCorrelationId := _GetNodeValue(lXmlDoc, cCORRELATIONIDNODE);

                  If lCorrelationId <> '' Then
                  Begin
                    lPollingTime := cCISDEFAULTPOLLINGTIME;

                  {get poll interval}
                    lNode := _GetNodeByName(lXmlDoc, cCISREDIRECTIONNODE);
                    If lNode <> Nil Then
                    Try
                      lPollingTime :=
                        lNode.attributes.GetNamedItem(cCISPOLLINTERVALNODE).nodeValue;
                    Finally
                      lNode := Nil;
                    End;

                  {get redirection address}
                    Try
                      lRedirection := _GetNodeValue(lXmlDoc, cCISREDIRECTIONNODE);
                    Except
                    End;

(*                    {generate the file guid for this response}
                    lFileGuid := GUIDToString(_CreateGuid);*)

                    {finally, update the database}
                    fDb.UpdateCIS(lHeader.Guid, lIrMark, lCorrelationId, lClassType,
                      lRedirection, lFileGuid, lPollingTime, dbDoAdd);

                  {store the xml result for visualization}

                  {outbox + file directory}
(*                    lReturnFile := IncludeTrailingPathDelimiter(lSys.OutboxDir
                      + GUIDToString(lHeader.Guid));

                  {outbox + file directory + cisreturn directory}
                    lReturnFile := IncludeTrailingPathDelimiter(lReturnFile +
                      cCISRETDIR);

                  {outbox + file directory + cisreturn directory + "file name.xml"
                  the reason for a new file is that GGW can return more than one
                  file for submission (after polling) }
                    lReturnFile := lReturnFile + lFileGuid + cXMLEXT;

                    Try
                      ForceDirectories(ExtractFilePath(lReturnFile));
                    Except
                    End;

                    _DelFile(lReturnFile); *)

                    Try
                      lXmlDoc.save(lReturnFile);
                    Except
                      _CreateXmlFile(lReturnFile, lXmlDoc.xml);
                    End; {try}

                    {check the result}
                    If lAck = Lowercase(cCISQUALIFIERACK) Then
                      Result := S_OK
                    Else If lAck = lowercase(cCISQUALIFIERERROR) Then
                    Begin
                      Result := cERRORSENDINGEMAIL;
                      {end conversation with GGW}
                      Try
                        If Trim(lCorrelationId) <> '' Then
                          lPosting.Delete(lCorrelationId, lClassType,
                            fDb.GetSystemValue(cUSECISTESTPARAM) = '1',
                              lRedirection);
                      Except
                      End;
                    End; {If lAck = lowercase(cCISQUALIFIERERROR) Then}
                  End {If lCorrelationId <> '' Then}
                  Else
                  Begin
                    fDb.UpdateCIS(lHeader.Guid, lIrMark, lCorrelationId, lClassType,
                      lRedirection, lFileGuid, lPollingTime, dbDoAdd);

                    Result := WriteError(cINVALIDXMLNODE,
                      'TCISSending.PostDocument',
                      'Could not load the CIS Correlation ID detail');

                    Try
                      lXmlDoc.save(lReturnFile);
                    Except
                      _CreateXmlFile(lReturnFile, lXmlDoc.xml);
                    End; {try}

                      {end conversation with GGW}
                    Try
                      If Trim(lCorrelationId) <> '' Then
                        lPosting.Delete(lCorrelationId, lClassType,
                          fDb.GetSystemValue(cUSECISTESTPARAM) = '1', lRedirection);
                    Except
                    End;
                  End;
                End {if lXmlDoc.xml <> '' then}
                Else
                Begin
                  fDb.UpdateCIS(lHeader.Guid, lIrMark, lCorrelationId, lClassType,
                    lRedirection, lFileGuid, lPollingTime, dbDoAdd);

                  Result := WriteError(cINVALIDXML, 'TCISSending.PostDocument',
                    'Could not load the CIS result from Gateway');

                  Try
                    lXmlDoc.save(lReturnFile);
                  Except
                    _CreateXmlFile(lReturnFile, lXmlDoc.xml);
                  End; {try}

                  {end conversation with GGW}
                  Try
                    If Trim(lCorrelationId) <> '' Then
                      lPosting.Delete(lCorrelationId, lClassType, fDb.GetSystemValue(cUSECISTESTPARAM) = '1', lRedirection);
                  Except
                  End;
                End;
              End {if lXmlRes <> '' then}
              Else
                Result := WriteError(cERRORSENDINGEMAIL,
                  'TCISSending.PostDocument',
                  'The CIS document could not be posted.');
            End
            Else
              Result := WriteError(cFILEANDXMLERROR, 'TCISSending.PostDocument',
                'Failed to load CIS IRMark.');
          End
          Else
            Result := WriteError(cINVALIDGUID, 'TCISSending.PostDocument', '');
        End {If _GetXMLHeader(lXmlPost, lHeader) Then}
        Else
          Result := WriteError(cINVALIDXML, 'TCISSending.PostDocument',
            'Could not load CIS XML header');
      Except
        On E: exception Do
          Result := WriteError(cERROR, 'TCISSending.PostDocument', 'Error: ' +
            e.Message);
      End; {try}
    Finally
      If Assigned(lSys) Then
        lSys.Free;
      lPosting := Nil; {releasing resources}
      lXmlDoc := Nil;
    End; {if Assigned(lPosting) then}
  End
  Else
    Result := cOBJECTNOTAVAILABLE;
End;

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSending.SendMsg: LongWord;
Var
  lFiles: TStringList;
  lCont: Integer;
  lXml: WideString;
Begin
  Result := S_OK;
  lFiles := TStringList.Create;
  lFiles.CommaText := fFiles;

  {check for attachements}
  If lFiles.Count > 0 Then
  Begin
    _CallDebugLog('CIS sending. Files to send: ' + inttostr(lFiles.Count));

    {process files}
    For lCont := 0 To lFiles.Count - 1 Do
    Try
      {check if file exists}
      If _FileSize(lFiles[lCont]) > 0 Then
      Begin
        lXml := '';
        Try
          lXml := _GetXmlFromFile(lFiles[lCont]);
        Except
          On e: exception Do
            WriteError(0, 'TReceive.Receive',
              'Error loading xml from file. Error: ' + e.Message);
        End; {try}

        If lXml <> '' Then
        Begin
          Result := PostDocument(lXml);
        End {if lXml <> '' then}
        Else
        Begin
          Result := WriteError(cLOADINGXMLERROR, 'TReceive.Receive', '');
          Break;
        End; {begin}

      End {if _FileSize(lFiles[lCont]) > 0 then}
      Else
      Begin
        Result := WriteError(cFILENOTFOUND, 'TCISSending.SendMsg',
          lFiles[lCont]);
        Break;
      End; {begin}
    Except
      On e: Exception Do
        Result := WriteError(cError, 'TCISSending.SendMsg', 'Error: ' +
          e.Message);
    End; {for lCont:= 0 to lFiles.Count - 1 do}
  End {If lFiles.Count > 0 Then}
  Else
    Result := WriteError(cNOFILESTOBESENT, 'TCISSending.SendMsg',
      'No files have been attached.');

  lFiles.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: WriteError
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISSending.WriteError(pError: Longword; Const pWhere, pMessage:
  String): Longword;
Begin
  Result := pError;
  fLog.DoLogMessage(pWhere, pError, pMessage, True, True);
End;

Function TCISSending.Get_Authentication: WordBool;
Begin

End;

Function TCISSending.Get_BCC: WideString;
Begin

End;

Function TCISSending.Get_Body: WideString;
Begin

End;

Function TCISSending.Get_CC: WideString;
Begin

End;

Function TCISSending.Get_Files: WideString;
Begin

End;

Function TCISSending.Get_OutgoingPassword: WideString;
Begin

End;

Function TCISSending.Get_OutgoingPort: Integer;
Begin

End;

Function TCISSending.Get_OutgoingServer: WideString;
Begin

End;

Function TCISSending.Get_OutgoingUsername: WideString;
Begin

End;

Function TCISSending.Get_Password: WideString;
Begin

End;

Function TCISSending.Get_ServerType: WideString;
Begin

End;

Function TCISSending.Get_SSLOutgoing: WordBool;
Begin

End;

Function TCISSending.Get_Subject: WideString;
Begin

End;

Function TCISSending.Get_To_: WideString;
Begin

End;

Function TCISSending.Get_UserName: WideString;
Begin

End;

Function TCISSending.Get_YourEmail: WideString;
Begin

End;

Function TCISSending.Get_YourName: WideString;
Begin

End;

Procedure TCISSending.Set_Authentication(Value: WordBool);
Begin

End;

Procedure TCISSending.Set_BCC(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_Body(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_CC(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_Files(Const Value: WideString);
Begin
  fFiles := Value;
End;

Procedure TCISSending.Set_OutgoingPassword(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_OutgoingPort(Value: Integer);
Begin

End;

Procedure TCISSending.Set_OutgoingServer(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_OutgoingUsername(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_Password(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_ServerType(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_SSLOutgoing(Value: WordBool);
Begin

End;

Procedure TCISSending.Set_Subject(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_To_(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_UserName(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_YourEmail(Const Value: WideString);
Begin

End;

Procedure TCISSending.Set_YourName(Const Value: WideString);
Begin

End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISSending, Class_CISSending,
    ciMultiInstance, tmApartment);
End.

