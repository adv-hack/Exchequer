{-----------------------------------------------------------------------------
 Unit Name: uCISCallBack
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uCISCallBack;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, StdVcl, CISIncoming_TLB, Classes, MAth,

  {fbi components}
  InternetFiling_TLB,

  uInterfaces, uXMLBaseClass

  ;

Type
  TCISCallBack = Class(TAutoObject, ICISCallBack, ICallback)
  Private
    fCISMsg: TCISMessage;
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
    Property CISMsg: TCISMessage Read fCISMsg Write fCISMsg;
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
  CISXCnst

  ;

{ TCISCallBack }

{-----------------------------------------------------------------------------
  Procedure: _Unused
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack._Unused;
Begin

End;

{-----------------------------------------------------------------------------
  Procedure: Response
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack.Response(Const message: WideString);
Begin
  ProcessResponseXml(message);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCISCallBack.Destroy;
Begin
  fCISMsg.Free;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack.Initialize;
Begin
  Inherited;
  fCISMsg := TCISMessage.Create;
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessResponseXml
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISCallBack.ProcessResponseXml(Const pXml: WideString);
Var
  lDb: TADODSR; {db}
  lDoc: DOMDocument; {msxml document}
  lNode: IXMLDOMNode; {msxml node}
  lFileGuid,
    lResponseFile, {response from ggw}
    lAck, {acknowledge from GGW}
    lCorreId,
    lClassType: String; {correlation id of the message}
  lSys: TSystemConf;
  lStrXml: TStringList;
  lFileName, lSubj: String;
  lStatus : Smallint;
  lPack: TPackageInfo;
Begin
  {check if this object has already got a response from the ggw}
  If Not Finished Then
  Begin
    lDb := Nil;
    Try
      lDb := TADODSR.Create(_DSRGetDBServer);
    Except
      On E: Exception Do
        _LogMSG('TCISCallBack.ProcessResponseXml :- CIS Incoming database connection error: '
          + E.MEssage);
    End; {try}

    If Assigned(lDb) And lDb.Connected Then
    Begin
      Try
        //lDoc := TXMLDoc.Create;
        lDoc := CoDOMDocument.Create;
      Except
        On e: exception Do
          _LogMSG('TCISCallBack.ProcessResponseXml :- Error creating MSXML object. Error: '
            + e.Message);
      End; {try}

      If Assigned(lDoc) Then
      Begin
        lFileName := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR) +
          _CreateGuidStr + cXMLEXT;

        Try
          ForceDirectories(ExtractFilePath(lFilename));
        Except
        End;

        lStrXml := TStringList.Create;
        lStrXml.Text := pXml;
        lStrXml.SaveToFile(lFileName);
        lStrXml.Free;

        Try
          lDoc.load(lFileName);
        Finally
          If lDoc.xml = '' Then
            _LogMSG('TCISCallBack.ProcessResponseXml :- Error loading xml. Error: '
              + _GetXmlParseError(lDoc.parseError));
        End; {try}

        If lDoc.xml <> '' Then
        Begin
          lCorreId := _GetNodeValue(lDoc, cCORRELATIONIDNODE);
          If lCorreId = '' Then
          Begin
          {try loading via nodes if something gets wrong}
            lNode := _GetNodeByName(lDoc, cCORRELATIONIDNODE);
            If lNode <> Nil Then
              lCorreId := _GetNodeValue(lNode, cCORRELATIONIDNODE)
          End; {if lCorreId = '' then}

       {correlation id found, update database}
          If lCorreId <> '' Then
          Begin
            lSys := TSystemConf.Create;
            lFileGuid := _CreateGuidStr;
            lResponseFile := IncludeTrailingPathDelimiter(lSys.OutboxDir +
              CISMsg.OutboxGuid);
            lResponseFile := IncludeTrailingPathDelimiter(lResponseFile +
              cCISRETDIR);
            lResponseFile := lResponseFile + lFileGuid + cXMLEXT;

            lAck := trim(Lowercase(_GetNodeValue(lDoc, cCISQUALIFIERNODE)));
            If lAck = cCISQUALIFIERACK Then
            Begin
              fUrl := _GetNodeValue(lDoc, cCISREDIRECTIONNODE);
              CISMsg.Redirection := fUrl;
            End
            Else If lAck = cCISQUALIFIERRESPONSE Then
            Begin
              If lDb.GetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid)) <>
                cPROCESSED Then
              Begin
                lDb.SetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid),
                  cPROCESSED);

                {update database with the final response}
                With CISMsg Do
                  lDb.UpdateCIS(StringToGUID(OutboxGuid), IrMark, lCorreId, lAck,
                    Redirection, lFileGuid, Polling, dbDoAdd);

                lDoc.save(lResponseFile);

                lClassType := _GetNodeValue(lDoc, cCISCLASSNODE);
                {this has been a subcontractor verification, create a new inbox entry for import this file}
                //If Lowercase(Trim(lClassType)) = Lowercase(MESSAGE_CLASS_VERIFY)
                //  Then
                  If Not InboxUpdated Then
                  Begin
                    lFileGuid := _CreateGuidStr;

                    lPack := lDb.GetExportPackage(CISMsg.CompanyID,
                      cCISSUBCONTRACTOR);

                    If Lowercase(Trim(lClassType)) = Lowercase(MESSAGE_CLASS_VERIFY) Then
                    begin
                      lSubj := cCISSUBVERIFICATIONSUBJECT + ' ' + DateTimeToStr(Now);
                      lStatus := cREADYIMPORT;
                    end
                    else
                    begin
                      lSubj := cCISMONTHLYRETSUBJECT + ' ' + DateTimeToStr(Now);
                      lStatus := cCISSENT;
                    end;

                    lDb.UpdateInBox(StringToGUID(lFileGuid),
                      CISMsg.CompanyID,
                      lSubj {cCISSUBVERIFICATIONSUBJECT + ' ' + DateTimeToStr(Now)},
                      cCISRECIPIENT,
                      lDb.GetCompanyDescription(CISMsg.CompanyID),
                      ifThen(lPack <> Nil, lDb.GetImportIdbyLink(lPack.PluginLink),
                      0),
                      1,
                      lStatus {cREADYIMPORT},
                      Ord(rmCIS),
                      dbDoAdd);

                    lResponseFile := IncludeTrailingPathDelimiter(lSys.InboxDir +
                      lFileGuid);
                    lResponseFile := lResponseFile + '1.xml';
                    ForceDirectories(ExtractFilePath(lResponseFile));

                    lDoc.save(lResponseFile);
                    InboxUpdated := True;
                  End; {If Not InboxUpdated Then}
              End; {If lDb.GetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid)) <> cPROCESSED Then}

              Finished := True;
            End
            Else If lAck = cCISQUALIFIERERROR Then
            Begin
              lDb.SetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid), cFAILED);

              {update database with an error message}
              With CISMsg Do
                lDb.UpdateCIS(StringToGUID(OutboxGuid), IrMark, lCorreId, lAck,
                  Redirection, lFileGuid, Polling, dbDoAdd);

              lDoc.save(lResponseFile);

              Finished := True;
            End;

            lSys.Free;
          End {If lCorreId <> '' Then}
          Else
            _LogMSG('TCISCallBack.ProcessResponseXml :- Correlation ID could not be found.');
        End {if lDoc.xml <> '' then}
        Else
        Begin
          _LogMSG('TCISCallBack.ProcessResponseXml :- Could not process GGW response message. Could not load empty XML...');
          lDb.SetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid), cFAILED);
          Finished := True;
          // TODO: add log info
        End;

        lDoc := Nil;
        _DelFile(lFileName);
      End {if Assigned(lDoc) then}
      Else
      Begin
        _LogMSG('TCISCallBack.ProcessResponseXml :- Could not process GGW response message. Coult not create XML Document...');
        lDb.SetOutboxMessageStatus(StringToGUID(CISMsg.OutboxGuid), cFAILED);
        Finished := True;
      End;

      lDb.Free;
    End
    Else
      _LogMSG('TCISCallBack.ProcessResponseXml :- Could not process GGW response message. The database is not connected...')
  End; {If Not Finished Then}
End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISCallBack,
    CISIncoming_TLB.Class_CISCallBack,
    ciMultiInstance, tmApartment);
(*  TAutoObjectFactory.Create(ComServer, TCISCallBack, CISIncoming_TLB.Class_CISCallBack,
    ciMultiInstance, tmFree);*)
End.

