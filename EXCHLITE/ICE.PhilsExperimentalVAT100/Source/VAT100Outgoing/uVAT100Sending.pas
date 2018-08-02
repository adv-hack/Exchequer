{-----------------------------------------------------------------------------
 Unit Name: uVAT100Sending
 Author:    Phil Rogers
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uVAT100Sending;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, VAT100Outgoing_TLB, StdVcl, DSROutgoing_TLB,

  uAdoDSR, uBaseClass

  ;

Type
  TVAT100Sending = Class(TAutoObject, IVAT100Sending, IDSROutgoingSystem)
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

  {FBI component}
  InternetFiling_TLB,

  {msxml}
  MSXML2_TLB,

  uCommon,
  uConsts,
  uDSRSettings,
  uDSRFileFunc,
  uSystemConfig,

  uXmlBaseClass,

  {VAT100 files}
  VATXMLConst

  ;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Destructor TVAT100Sending.Destroy;
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
Procedure TVAT100Sending.Initialize;
Begin
  Inherited;
  CoInitialize(Nil);

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('VAT100 Outgoing database connection error: ' + E.MEssage);
  End; {try}

  If fDb <> Nil Then
  Begin
    If fDb.Connected Then
      _LogMSG('VAT100 Outgoing database is connected...')
    Else
      _LogMSG('VAT100 Outgoing database is not connected...');
  End
  Else
    _LogMSG('VAT100 Outgoing database is not connected...');

  fLog := _Base.Create;
  If fDb <> Nil Then
    fLog.ConnectionString := fDb.ConnectionString;
End;

{-----------------------------------------------------------------------------
  Procedure: PostDocument
  Author:    vmoura
-----------------------------------------------------------------------------}
function TVAT100Sending.PostDocument(const pXml: wideString): Longword;
// Input parameter pXML is an XML filename.
var
  lPosting       : _Posting;   {fbi posting object}
  lXmlPost       : widestring; {xml to be posted}
  lIrMark        : widestring; {irmark generated}
  lClassType     : widestring; {ggw class type id}
  lXmlRes        : wideString; {xml response from ggw}
  lXmlDoc        : DOMDocument40; {xml dom doc}
  lReturnFileName: string;  {file to be stored}
  lFileGuid      : string;  {guid for the stored file}
  lAck           : string;  {info returned by ggw}
  lRedirection   : string; {redirection address from ggw}
  lCorrelationId : string; {correlation id returned for the posting}
  lHeader        : TXMLHeader; {dsr xmlheader}
  lPollingTime   : Integer; {polling time returned}
  lNode          : IXMLDOMNode; {xml dom node}
  lSys           : TSystemConf; {system conf file}
begin
  Result := S_OK;
  try
    // Create an FBI posting object.
    lPosting := CoPosting.Create;
  except
    on E: Exception do
      Result := WriteError(cCOMOBJECTERROR,
                           'TVAT100Sending.PostDocument',
                           'Error: ' + e.Message);
  end; {try}

  // Check that the FBI Posting object was created ok
  if Assigned(lPosting) then
  begin
    try
      lSys := TSystemConf.Create;

      lXmlDoc := CoDOMDocument40.Create;

      if _FileSize(pXml) > 0 then
      begin
        try
          lXmlDoc.load(pXml);
          lXmlPost := lXmlDoc.xml;
        finally
          lXmlDoc.loadXML('');
        end;
      end
      else
      begin
        lXmlPost := pXml;
      end;

      try
        // Remove tabs in the document before sending
        // lXmlPost := StringReplace(pXml, Chr(9), '', [rfReplaceAll]);

        FillChar(lHeader, SizeOf(TXMLHeader), 0);

        // Get the guid from this message for updating the database later
        if _GetXMLHeader(lXmlPost, lHeader) then
        begin
          if _IsValidGuid(lHeader.Guid) then
          begin
            lXmlDoc.loadXML(lXmlPost);

            // Get the valid VAT100 XML inside the node VAT100xml.
            // We use the DSR header to get a guid entry, extract the xml to
            //  be sent to ggw, apply an IRMark and post it.

            // PKR. Actually, the XML already contains an IRMark, so we don't need to apply one.

            // This needs to be removed or modified...
            Try
              If _GetNodeByName(lXmlDoc, cCISXMLNODEMONTHLY) <> Nil Then
              Begin
                lXmlPost := _GetNodeValue(lXmlDoc, cCISXMLNODEMONTHLY);
              End
              Else If _GetNodeByName(lXmlDoc, cCISXMLNODESUB) <> Nil Then
                lXmlPost := _GetNodeValue(lXmlDoc, cCISXMLNODESUB);
            Except
              On e: exception Do
                Result := WriteError(cLOADINGXMLERROR, 'TVAT100Sending.PostDocument',
                  'Error loading VAT100XMLNODE. Error: ' + e.message);
            End; {try}

           {get/set IrMark}
            lIrMark := '';
            lXmlDoc.loadXML('');
            lXmlDoc.loadXML(lXmlPost);
            lIrMark := _GetNodeValue(lXmlDoc, VAT_IR_MARK);
(*
            If lIrMark = '' Then
            begin
              lNameSpace := _GetNodeByName(lXmlDoc, IR_ENVELOPE);
              //lIrMark := lPosting.AddIRMark(lXmlPost, 3);
              if lNameSpace <> nil then
                lIrMark := lPosting.AddIRMark(lXmlPost, 3)
              else
                lIrMark := lPosting.AddIRMark_2(lXmlPost, lNameSpace.attributes.getNamedItem(XMLNS).nodeValue);
            end;

*)
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

{$IFDEF VAT100TEST}
              Try
                lXmlRes := lPosting.Submit(lClassType, True, lXmlPost);
              Except
              End; {try}
{$ELSE}
              Try
                lXmlRes := lPosting.Submit(lClassType,
                  fDb.GetSystemValue(cUSEVAT100TESTPARAM) = '1', lXmlPost);
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
                    _LogMSG('TVAT100Sending.PostDocument :- Error loading XML result from Gateway. Error: '
                      + e.Message);
                End; {try}

                lReturnFileName := IncludeTrailingPathDelimiter(lSys.OutboxDir +
                                                    GUIDToString(lHeader.Guid));

                {outbox + file directory + VAT100return directory}
                lReturnFileName := IncludeTrailingPathDelimiter(lReturnFileName +
                                                                cVAT100RETDIR);

                {generate the file guid for this response}
                lFileGuid := GUIDToString(_CreateGuid);

                {outbox + file directory + VAT100return directory + "file name.xml"
                the reason for a new file is that GGW can return more than one
                file for submission (after polling) }
                lReturnFileName := lReturnFileName + lFileGuid + cXMLEXT;

                Try
                  ForceDirectories(ExtractFilePath(lReturnFileName));
                Except
                End;

                _DelFile(lReturnFileName);

                lPollingTime := 0;

                // Check the response xml
                If lXmlDoc.xml <> '' Then
                Begin
                  lAck := Lowercase(_GetNodeValue(lXmlDoc, cVAT100_QUALIFIER_NODE));
                  lClassType := _GetNodeValue(lXmlDoc, cVAT100_CLASS_NODE);

                  // Get the correlationid node value to store in the ICE database
                  lCorrelationId := _GetNodeValue(lXmlDoc, cCORRELATIONIDNODE);

                  If lCorrelationId <> '' Then
                  Begin
                    // Not null, so continue processing
                    // Get the polling URL and polling interval from XML
                    //  something like this:
                    //
                    //  <ResponseEndPoint PollInterval = "10">
                    //    https://secure.dev.gateway.gov.uk/poll
                    //  </ResponseEndPoint>

                    lPollingTime := cVAT100_DEFAULT_POLLING_TIME;

                    // Get the polling Redirection node
                    lNode := _GetNodeByName(lXmlDoc, cVAT100_POLLING_URL);

                    If lNode <> Nil Then
                    Try
                      // Get the polling interval
                      lPollingTime := lNode.attributes.GetNamedItem(cVAT100_POLL_INTERVAL_ATTR).nodeValue;
                    Finally
                      lNode := Nil;
                    End;

                    // Get the redirection URL
                    Try
                      lRedirection := _GetNodeValue(lXmlDoc, cVAT100_POLLING_URL);
                    Except
                    End;

                    // Finally, update the database}
                    fDb.UpdateVAT100(lHeader.Guid, lIrMark, lCorrelationId, lClassType,
                                     lRedirection, lFileGuid, lPollingTime, dbDoAdd);

                    Try
                      lXmlDoc.save(lReturnFileName);
                    Except
                      _CreateXmlFile(lReturnFileName, lXmlDoc.xml);
                    End; {try}

                    // Check the result
                    if lAck = Lowercase(cVAT100_QUALIFIER_ACK) then
                    begin
                      // The submission was successful
                      Result := S_OK;
                    end
                    else
                    begin
                      if lAck = lowercase(cVAT100_QUALIFIER_ERROR) then
                      begin
                        Result := cERRORSENDINGEMAIL;
                        // Submission failed, so end the conversation with GGW
                        // by sending a delete_request
                        try
                          If Trim(lCorrelationId) <> '' Then
                            lPosting.Delete(lCorrelationId,
                                            lClassType,
                                            fDb.GetSystemValue(cUSEVAT100TESTPARAM) = '1',
                                            lRedirection);
                        except
                        end; // try
                      end; // if lAck = lowercase(cVAT100_QUALIFIER_ERROR)
                    end;
                  end // if lCorrelationId <> ''
                  else
                  begin
                    // correlationid element is ''
                    // Update the database.
                    fDb.UpdateVAT100(lHeader.Guid,
                                     lIrMark,
                                     lCorrelationId,
                                     lClassType,
                                     lRedirection,
                                     lFileGuid,
                                     lPollingTime,
                                     dbDoAdd);

                    // Log the error.
                    Result := WriteError(cINVALIDXMLNODE,
                                         'TVAT100Sending.PostDocument',
                                         'VAT100 Correlation ID value is blank');
                  end;

                  try
                    lXmlDoc.save(lReturnFileName);
                  except
                    _CreateXmlFile(lReturnFileName, lXmlDoc.xml);
                  end; {try}

                end // If lXmlDoc.xml <> ''
                else
                begin
                  // XML is empty
                  fDb.UpdateVAT100(lHeader.Guid, lIrMark, lCorrelationId, lClassType,
                                   lRedirection, lFileGuid, lPollingTime, dbDoAdd);

                  Result := WriteError(cINVALIDXML, 'TVAT100Sending.PostDocument',
                    'Could not load the VAT100 result from Gateway');

                  // Save the XML (even though it's empty!)
                  Try
                    lXmlDoc.save(lReturnFileName);
                  Except
                    _CreateXmlFile(lReturnFileName, lXmlDoc.xml);
                  End; {try}

                  // End the conversation with the GGW
                  Try
                    lPosting.Delete(lCorrelationId, lClassType, fDb.GetSystemValue(cUSEVAT100TESTPARAM) = '1', lRedirection);
                  Except
                  End;
                End;
              End {if lXmlRes <> '' then}
              Else
                Result := WriteError(cERRORSENDINGEMAIL,
                  'TVAT100Sending.PostDocument',
                  'The VAT100 document could not be posted.');
            End
            Else
              Result := WriteError(cFILEANDXMLERROR, 'TVAT100Sending.PostDocument',
                                   'VAT100 return does not contain an IRMark.');
          End
          Else
            Result := WriteError(cINVALIDGUID, 'TVAT100Sending.PostDocument', '');
        End {If _GetXMLHeader(lXmlPost, lHeader) Then}
        Else
          Result := WriteError(cINVALIDXML, 'TVAT100Sending.PostDocument',
            'Could not load VAT100 XML header');
      Except
        On E: exception Do
          Result := WriteError(cERROR, 'TVAT100Sending.PostDocument', 'Error: ' +
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
Function TVAT100Sending.SendMsg: LongWord;
Var
  lFiles : TStringList;
  lIndex : Integer;
  lXml   : WideString;
Begin
  Result := S_OK;
  lFiles := TStringList.Create;
  lFiles.CommaText := fFiles; // comma-separated filenames converted to list

  // Check for attachments
  If lFiles.Count > 0 Then
  Begin
    _CallDebugLog('TVAT100Sending.SendMsg. Files to send: ' + inttostr(lFiles.Count));

    // Process the files
    for lIndex := 0 To lFiles.Count - 1 do
    begin
      try
        // Check if the file exists
        If _FileSize(lFiles[lIndex]) > 0 Then
        Begin
          lXml := '';
          Try
            // Load the XML from the current file
            lXml := _GetXmlFromFile(lFiles[lIndex]);
          Except
            On e: exception Do
              WriteError(0, 'TVAT100Sending.SendMsg',
                         'Error loading xml from file ' + lFiles[lIndex] + '. Error: ' + e.Message);
          End; {try}

          If lXml <> '' Then
          Begin
            Result := PostDocument(lXml);
          End {if lXml <> '' then}
          Else
          Begin
            // The XML is empty, so log an error
            Result := WriteError(cLOADINGXMLERROR, 'TVAT100Sending.SendMsg', '');
            Break;
          End; {begin}
        End // file exists
        Else
        Begin
          // File doen't exist, or it's empty.
          Result := WriteError(cFILENOTFOUND, 'TVAT100Sending.SendMsg', lFiles[lIndex]);
          Break;
        End; {begin}
      except
        On e: Exception Do
          Result := WriteError(cError, 'TVAT100Sending.SendMsg', 'Error: ' +
            e.Message);
      end; // try
    end; // for each file
  End // if lFiles.Count > 0
  Else
    // No files to process
    Result := WriteError(cNOFILESTOBESENT, 'TVAT100Sending.SendMsg',
                         'No files have been attached.');
  lFiles.Free;
End;

{-----------------------------------------------------------------------------
  Procedure: WriteError
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TVAT100Sending.WriteError(pError: Longword; Const pWhere, pMessage:
  String): Longword;
Begin
  Result := pError;
  fLog.DoLogMessage(pWhere, pError, pMessage, True, True);
End;

Function TVAT100Sending.Get_Authentication: WordBool;
Begin

End;

Function TVAT100Sending.Get_BCC: WideString;
Begin

End;

Function TVAT100Sending.Get_Body: WideString;
Begin

End;

Function TVAT100Sending.Get_CC: WideString;
Begin

End;

Function TVAT100Sending.Get_Files: WideString;
Begin

End;

Function TVAT100Sending.Get_OutgoingPassword: WideString;
Begin

End;

Function TVAT100Sending.Get_OutgoingPort: Integer;
Begin

End;

Function TVAT100Sending.Get_OutgoingServer: WideString;
Begin

End;

Function TVAT100Sending.Get_OutgoingUsername: WideString;
Begin

End;

Function TVAT100Sending.Get_Password: WideString;
Begin

End;

Function TVAT100Sending.Get_ServerType: WideString;
Begin

End;

Function TVAT100Sending.Get_SSLOutgoing: WordBool;
Begin

End;

Function TVAT100Sending.Get_Subject: WideString;
Begin

End;

Function TVAT100Sending.Get_To_: WideString;
Begin

End;

Function TVAT100Sending.Get_UserName: WideString;
Begin

End;

Function TVAT100Sending.Get_YourEmail: WideString;
Begin

End;

Function TVAT100Sending.Get_YourName: WideString;
Begin

End;

Procedure TVAT100Sending.Set_Authentication(Value: WordBool);
Begin

End;

Procedure TVAT100Sending.Set_BCC(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_Body(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_CC(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_Files(Const Value: WideString);
Begin
  fFiles := Value;
End;

Procedure TVAT100Sending.Set_OutgoingPassword(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_OutgoingPort(Value: Integer);
Begin

End;

Procedure TVAT100Sending.Set_OutgoingServer(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_OutgoingUsername(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_Password(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_ServerType(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_SSLOutgoing(Value: WordBool);
Begin

End;

Procedure TVAT100Sending.Set_Subject(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_To_(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_UserName(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_YourEmail(Const Value: WideString);
Begin

End;

Procedure TVAT100Sending.Set_YourName(Const Value: WideString);
Begin

End;

Initialization
  TAutoObjectFactory.Create(ComServer, TVAT100Sending, Class_VAT100Sending,
    ciMultiInstance, tmApartment);
End.

