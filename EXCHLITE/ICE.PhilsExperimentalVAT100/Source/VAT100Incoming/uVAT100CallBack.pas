{-----------------------------------------------------------------------------
 Unit Name: uVAT100CallBack
 Author:    Phil Rogers
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uVAT100CallBack;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, StdVcl, VAT100Incoming_TLB, Classes, MAth,

  {fbi components}
  InternetFiling_TLB,

  uInterfaces, uXMLBaseClass

  ;

Type
  TVAT100CallBack = Class(TAutoObject, IVAT100CallBack, ICallback)
  Private
    fVAT100Msg: TCISMessage;
    fFinished: Boolean;
    fUrl: String;
    fPollGuid: String;
    fInboxUpdated: Boolean;
    Procedure ProcessResponseXml(Const pXml: WideString);
  Protected
    Procedure Response(Const message: WideString); Safecall;
    Procedure _Unused; Safecall;
  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  Published
    Property VAT100Msg: TCISMessage Read fVAT100Msg Write fVAT100Msg;
    Property Finished: Boolean Read fFinished Write fFinished;
    Property InboxUpdated: Boolean Read fInboxUpdated Write fInboxUpdated;
    Property URL: String Read fUrl Write fUrl;
    Property PollGuid: String Read fPollGuid Write fPollGuid;
  End;

Implementation

Uses ComServ, Sysutils,
  uDSRSettings,
  uCommon,
  uAdoDSR,
  uConsts,
  uSystemConfig,
  MSXML2_TLB,
  VATXMLConst
  ;

{ TVAT100CallBack }

{-----------------------------------------------------------------------------
  Procedure: _Unused
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100CallBack._Unused;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Response
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100CallBack.Response(Const message: WideString);
Begin
  ProcessResponseXml(message);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Destructor TVAT100CallBack.Destroy;
Begin
  fVAT100Msg.Free;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100CallBack.Initialize;
Begin
  Inherited;
  fVAT100Msg := TCISMessage.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessResponseXml
  Author:    Phil Rogers
  Description : Parses the XML returned by the GGW and updates the message
                database accordingly. 
-----------------------------------------------------------------------------}
Procedure TVAT100CallBack.ProcessResponseXml(Const pXml: WideString);
Var
  lDb           : TADODSR; {db}
  lDoc          : DOMDocument; {msxml document}
  lNode         : IXMLDOMNode; {msxml node}
  lFileGuid     : string;
  lResponseFile : string; {response from ggw}
  lAck          : string; {acknowledge from GGW}
  lCorreId      : string;
  lClassType    : String; {correlation id of the message}
  lSys          : TSystemConf;
  lStrXml       : TStringList;
  lFileName     : string;
  lSubj         : String;
  lStatus       : Smallint;
  lPack         : TPackageInfo;
Begin
  {check if this object has already got a response from the ggw}
  If Not Finished Then
  Begin
    lDb := Nil;
    Try
      lDb := TADODSR.Create(_DSRGetDBServer);
    Except
      On E: Exception Do
        _LogMSG('TVAT100CallBack.ProcessResponseXml :- VAT100 Incoming database connection error: '
          + E.MEssage);
    End; {try}

    If Assigned(lDb) And lDb.Connected Then
    Begin
      Try
        // Create the xml message document object
        lDoc := CoDOMDocument.Create;
      Except
        On e: exception Do
          _LogMSG('TVAT100CallBack.ProcessResponseXml :- Error creating MSXML object. Error: '
            + e.Message);
      End; {try}

      If Assigned(lDoc) Then
      Begin
        lFileName := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR) +
                                                  _CreateGuidStr + cXMLEXT;
        Try
          // Make sure the destination directory exists
          ForceDirectories(ExtractFilePath(lFilename));
        Except
        End;

        // Save the XML
        lStrXml := TStringList.Create;
        lStrXml.Text := pXml;
        lStrXml.SaveToFile(lFileName);
        lStrXml.Free;

        Try
          // Load the document with the XML.
          lDoc.load(lFileName);
        Finally
          If lDoc.xml = '' Then
            _LogMSG('TVAT100CallBack.ProcessResponseXml :- Error loading xml. Error: ' +
                    _GetXmlParseError(lDoc.parseError));
        End; {try}

        // Now parse some of the message fields
        If lDoc.xml <> '' Then
        Begin
          // Get the value of the CorrelationID node, which determines the type
          //  of response that it is.
          lCorreId := _GetNodeValue(lDoc, cCORRELATIONIDNODE);
          If lCorreId = '' Then
          Begin
            // Try loading via nodes if something goes wrong
            lNode := _GetNodeByName(lDoc, cCORRELATIONIDNODE);
            If lNode <> Nil Then
              lCorreId := _GetNodeValue(lNode, cCORRELATIONIDNODE)
          End; {if lCorreId = '' then}

          // CorrelationID found, so update the database (if it's not blank)
          If lCorreId <> '' Then
          Begin
            lSys := TSystemConf.Create;
            // Create a unique filename and path based on a GUID.
            lFileGuid := _CreateGuidStr;
            lResponseFile := IncludeTrailingPathDelimiter(lSys.OutboxDir + VAT100Msg.OutboxGuid);
            lResponseFile := IncludeTrailingPathDelimiter(lResponseFile + cVAT100RETDIR);
            lResponseFile := lResponseFile + lFileGuid + cXMLEXT;

            // Get the Qualifier node value.
            lAck := trim(Lowercase(_GetNodeValue(lDoc, cCISQUALIFIERNODE)));

            If lAck = cVAT100QUALIFIER_ACK Then
            Begin
              // qualifier = "acknowledgement"

              // Get the URL of the Response End Point.  This is the address to
              //  which subsequent SUBMISSION_POLL messages should be sent.
              fUrl := _GetNodeValue(lDoc, cCISREDIRECTIONNODE);
              VAT100Msg.Redirection := fUrl;
            End
            Else If lAck = cVAT100QUALIFIER_RESPONSE Then
            begin
              // qualifier is "response", which is received when:
              //  1) delete_request is successful
              //  2) data_request is successful
              // We don't use the latter, so it must be the former.

              If lDb.GetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid)) <> cPROCESSED Then
              begin
                // Set the outbox message status to "Processed"
                lDb.SetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid), cPROCESSED);
                // Update the database with the final response
                with VAT100Msg Do
                begin
                  lDb.UpdateVAT100(StringToGUID(OutboxGuid), IrMark, lCorreId, lAck,
                                   Redirection, lFileGuid, Polling, dbDoAdd);
                end;

                lDoc.save(lResponseFile);

                lClassType := _GetNodeValue(lDoc, cCISCLASSNODE); // class

                If Not InboxUpdated Then
                Begin
                  lFileGuid := _CreateGuidStr;

                  // PKR. This might not be right.  It's based on the CIS code.
                  // It's difficult to work out what's going on and the documentation
                  //  is poor.
                  lPack := lDb.GetExportPackage(VAT100Msg.CompanyID, cVAT100EXPORT);

                  If Lowercase(Trim(lClassType)) = Lowercase(MESSAGE_CLASS_VAT_RETURN) Then
                  begin
                    lSubj := VAT_SUBVERIFICATIONSUBJECT + ' ' + DateTimeToStr(Now);
                    lStatus := VAT_SENT;
                  end
                  else
                  begin
                    // Not a response to HMRC-VAT-DEC, so something went wrong.
                    lSubj := lClassType + ' ' + DateTimeToStr(Now);
                    lStatus := cFAILED;
                  end;

                  // Put an entry in the inbox.
                  lDb.UpdateInBox(StringToGUID(lFileGuid),
                                  VAT100Msg.CompanyID,
                                  lSubj,
                                  cVAT100RECIPIENT,
                                  lDb.GetCompanyDescription(VAT100Msg.CompanyID),
                                  // PKR. This needs attention.  I have no clue what it is!
                                  // See above.
                                  ifThen(lPack <> Nil, lDb.GetImportIdbyLink(lPack.PluginLink), 0),
                                  1,
                                  lStatus,
                                  Ord(rmVAT100),
                                  dbDoAdd);

                  lResponseFile := IncludeTrailingPathDelimiter(lSys.InboxDir + lFileGuid);
                  lResponseFile := lResponseFile + '1.xml';
                  ForceDirectories(ExtractFilePath(lResponseFile));

                  lDoc.save(lResponseFile);
                  InboxUpdated := True;
                End; // If Not InboxUpdated
              end; // If lDb.GetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid)) <> cPROCESSED

              Finished := True;
            End
            Else If lAck = cCISQUALIFIERERROR Then
            Begin
              //  qualifier = 'error'
              lDb.SetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid), cFAILED);

              // Update database with an error message
              With VAT100Msg Do
                lDb.UpdateVAT100(StringToGUID(OutboxGuid), IrMark, lCorreId, lAck,
                                 Redirection, lFileGuid, Polling, dbDoAdd);

              lDoc.save(lResponseFile);

              Finished := True;
            End;

            lSys.Free;

          End {If lCorreId <> '' Then}
          Else
            _LogMSG('TVAT100CallBack.ProcessResponseXml :- Correlation ID could not be found.');
        End {if lDoc.xml <> '' then}
        Else
        Begin
          _LogMSG('TVAT100CallBack.ProcessResponseXml :- Could not process GGW response message. Could not load empty XML...');
          lDb.SetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid), cFAILED);
          Finished := True;
          // TODO: add log info
        End;

        lDoc := Nil;
        _DelFile(lFileName);
      End {if Assigned(lDoc) then}
      Else
      Begin
        _LogMSG('TVAT100CallBack.ProcessResponseXml :- Could not process GGW response message. Coult not create XML Document...');
        lDb.SetOutboxMessageStatus(StringToGUID(VAT100Msg.OutboxGuid), cFAILED);
        Finished := True;
      End;

      lDb.Free;
    End
    Else
      _LogMSG('TVAT100CallBack.ProcessResponseXml :- Could not process GGW response message. The database is not connected...')
  End; {If Not Finished Then}
End;

Initialization
  TAutoObjectFactory.Create(ComServer,
                            TVAT100CallBack,
                            VAT100Incoming_TLB.Class_VAT100CallBack,
                            ciMultiInstance,
                            tmApartment);
End.

