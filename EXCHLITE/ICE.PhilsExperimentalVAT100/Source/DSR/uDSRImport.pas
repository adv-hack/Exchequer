{-----------------------------------------------------------------------------
 Unit Name: uDSRImport
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRImport;

Interface

Uses Windows, Sysutils, Classes, uADODSR, uXmlList;

Type
  TDSRImport = Class
  Protected
    Class Function ImportFiles(pGuid: TGuid; pXmlList: TXMLList; pCompany:
      Longword): Longword;
  Public
(*    Class Function CallImport(pCompany: Longword; pGuid: TGUID; pPackageId:
      Longword; Const pSendMsg: Boolean = True; Const pRecreate: Boolean = False):
      LongWord;*)

    Class Function CallImport(pCompany: Longword; pGuid: TGUID; pPackageId:
      Longword; pRecreate: Boolean): LongWord;

    Class Procedure CreateCompany(pMsgGuid: TGuid; Const pDesc, pCompGuid: String;
      Var pExCode: String; Var pResult: Longword);
  End;

  TDSRCreateCompany = Class(TThread)
  Private
    fDb: TADODSR;
    fDescription,
      fCode,
      fGuid: String;
    fReturnedValue: Longword;
    fMSGGUID: TGuid;
    Function GetNextCompCode(SeedText: ShortString): ShortString;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Execute; Override;
  Published
    Property Description: String Read fDescription Write fDescription;
    Property Code: String Read fCode Write fCode;
    Property Guid: String Read fGuid Write fGuid;
    Property ReturnedValue: Longword Read fReturnedValue Write fReturnedValue;
    Property MSGGUID: TGuid Read fMSGGUID Write fMSGGUID;
  End;

Implementation

Uses ComObj, Math, variants, strutils,
  DSRImport_TLB, uInterfaces, uCommon, uConsts, uBaseClass, uXmlBaseClass,
  uDSRSettings, uSystemConfig, uDSRFileFunc, uExFunc,
  uDSRMail, uMCM;

{ TDSRImport }

{-----------------------------------------------------------------------------
  Procedure: ImportFiles
  Author:    vmoura

  import a set of files using the right package
-----------------------------------------------------------------------------}
Class Function TDSRImport.ImportFiles(pGuid: TGuid; pXmlList: TXMLList; pCompany:
  Longword):
  Longword;
Var
  lPackId: Integer;
  lCont: Integer;
  lPack: TPackageInfo;
  lDb: TADODSR;
  lImport: IImportBox;
  lLog: _Base;
  lExCode,
    lCompPath: String;
  lImpGuid: TGUID;
Begin
  Result := S_OK;
  lLog := _Base.Create;

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRImport.ImportFiles', 0,
        'Error connecting database. Error: ' + e.message);
  End;

  {check the database connection}
  If Assigned(lDb) And lDb.Connected Then
  Begin
    lLog.ConnectionString := lDb.ConnectionString;
    lPackId := 0;
    lCompPath := '';
    FillChar(lImpGuid, SizeOf(TGuid), 0);
    lExCode := '';

    {update message status}
    lDb.SetInboxMessageStatus(pGuid, cPOPULATING);

    For lCont := 0 To pXmlList.Count - 1 Do
    Begin
      Try
        lDb.SetInboxTotalDone(pGuid, Trunc(((lCont + 1) / pXmlList.Count) * 100));
      Except
      End;

      {check if the end of sync has been requested for this company}
      If lDb.IsEndOfSyncRequested(pCompany) Then
      Begin
        Result := cIMPORTCANCELLED;
        Break;
      End; {if lDb.IsEndOfSyncRequested(pCompany) then}

      {avoid look up a new pack every time}
      If lPackId <> pXmlList[lCont].Pack_Id Then
      Begin
        lPackId := pXmlList[lCont].Pack_Id;

        If Assigned(lPack) Then
          FreeAndNil(lPack);

        If Assigned(lImport) Then
          lImport := Nil;

        {load import parameters}
        lPack := lDb.GetImportPackage(lPackId, pCompany);
        If Assigned(lPack) Then
        Begin
          If Lowercase(Trim(lExCode)) <> Lowercase(Trim(lPack.ExCode)) Then
          Begin
            lExCode := lPack.ExCode;
            lCompPath := lDb.GetCompanyPath(lExCode);
            If Not _DirExists(lCompPath) Then
              lCompPath := Trim(_GetExCompanyPath(lExCode));
          End; {If Lowercase(Trim(lExCode)) <> Lowercase(Trim(lPack.ExCode)) Then}

          lImpGuid := lPack.Guid;
        End; {If Assigned(lPack) Then}
      End; {If lPackId <> pXmlList[lCont].Pack_Id Then}

      If Assigned(lPack) Then
      Begin
        _CallDebugLog('Importing file ' + inttostr(lcont + 1) +
          ' using package : ' + lPack.Description + ' Company: ' + lExCode);

   {BI 10. If and only if all messages are validated satisfactorily, DSR requests import plugin import all XML messages.}
        If Not Assigned(lImport) Then
        Try
    { load the export box (default) and create a plugin using the guid provided by the package component}
          lImport := CreateComObject(lPack.Guid) As IImportBox;
        Except
          On e: Exception Do
          Begin
            Result := cLOADINGIMPORTPLUGINERROR;
            lLog.DoLogMessage('TDSRImport.ImportFiles', Result, 'Company: ' +
              lExCode + ' Error: ' + e.Message, True, True);
            lImport := Nil;
          End;
        End; {If Not Assigned(lImport) Then}

    {if the dsr manage to load the import correct import package,
    call doimport using the xml provided, the exchequer company code
    (will pass the datapath through). the userreference is not necessary yet)}
        If Assigned(lImport) Then
        Begin
          Try
            Result := lImport.DoImport(
              lPack.ExCode,
              lCompPath,
              pXmlList[lCont].XML,
              '',
              '',
              lPack.UserReference);
          Except
            On E: Exception Do
            Begin
              Result := cPLUGINERROR;
              lLog.DoLogMessage('TDSRImport.ImportFiles', Result, 'Company: ' +
                lExCode + ' Error: ' + e.Message, True, True);
            End; {begin}
          End; {try}

      {if the dsr get an error, it wont update the status of this message}
          If Result <> S_OK Then
          Begin
            lLog.DoLogMessage('TDSRImport.ImportFiles', Result,
              'Import plug-in error. Company: ' + lExCode, True, True);

            Break;
          End; {If Result <> S_OK Then}
        End {If Assigned(lImport) Then}
        Else
          Result := cINVALIDIMPORTPACK;
      End {If Assigned(lPack) Then}
      Else
      Begin
        Result := cIMPORTPLUGINNOTAVAILABLE;
        lLog.DoLogMessage('TDSRImport.ImportFiles', Result, ' Link: ' +
          pXmlList[lCont].PluginLink + ' Company: ' + inttostr(pCompany), true,
          True);
      End; {begin}

      {update message status}
      If (lCont Mod 10) = 0 Then
        lDb.SetInboxMessageStatus(pGuid, cPOPULATING);

      {to avoid 100% CPU}
      If (lCont Mod 3) = 0 Then
        Sleep(1);
    End; {For lCount := 0 To lXmlList.Count - 1 Do}
  End
  Else
    Result := cDBERROR;

  If Assigned(lPack) Then
    FreeAndNil(lPack);

  If Assigned(lImport) Then
    lImport := Nil;

  If Result <> S_OK Then
    lLog.DoLogMessage('TDSRImport.ImportFiles', Result, '', True, True);

  If Assigned(lDb) Then
    FreeAndNil(lDb);
  If Assigned(lLog) Then
    FreeAndNil(lLog);
End;

{-----------------------------------------------------------------------------
  Procedure: CallImport
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRImport.CallImport(pCompany: Longword; pGuid: TGUID;
  pPackageId: Longword; pRecreate: Boolean): LongWord;

  Procedure _UpdateOutbox(pMsg: TMessageInfo; pCompany: Integer; Const pMessage:
    String; pSendResponse: Integer; pDb: TADODSR);
  Begin
    pDb.UpdateOutBox(_CreateGuid, pCompany, pMessage, pMsg.To_, pMsg.From, 0, 1,
      pMsg.Param1, pMsg.Param2, IfThen(pSendResponse = S_OK, cSENT, cFAILED),
      Ord(rmNormal), dbDoAdd);
  End; {procedure}

Var
  lXml: WideString; {xml extracted}
  lPath, {file's path}
    lXSDFile, {xsd file}
    lExCode, {exchequer company code}
    lFileName: String; {filename to be saved}
  lXmlDoc: TXMLDoc; {xml dom document}
  lCount, lTotal: Integer; {counters}
  lProcess: Boolean; {if files were processed or not}
  lXMLHeader: TXMLHeader; {xml header}
  lXmlList: TXMLList; {list of xmls}
  lMsg: TMessageInfo; {e-mail object}
  lDB: TADODSR; {database connection}
  lLog: _Base; {log obj}
  lSystem: TSystemConf; {system parameters}
  lDSRHeader: TDSRFileHeader; {dsr file header}
  lSyncReq: TSyncRequest; {sync request header}
  lSendResponse: Integer; {get the response from the sender}
  lComp: Integer; {company code}
  lPack: TPackageInfo; {load a package info, if necessary}
Begin
  Result := S_OK;

  lLog := _Base.Create;
  lSystem := TSystemConf.Create;

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRImport.CallImport', 0,
        'Error connecting database. Error: ' + e.message);
  End;

  If Assigned(lDb) And lDb.Connected Then
  Begin
    If pCompany > 0 Then
      lComp := pCompany;

  { BI 7.User selects batch in the dashboard application and requests import.}
    lLog.ConnectionString := lDb.ConnectionString;
    lMsg := Nil;

    If _IsValidGuid(pGuid) Then
      lMsg := lDb.GetInboxMessage(pGuid);

  { check a valid message }
    If lMsg <> Nil Then
    Try
      If lMsg.Status In [cREADYIMPORT, cFAILED, cPROCESSING] Then
      Begin
        If Not pRecreate Then
        Begin
          {change status of the mail to processing to avoid user call it several times}
          lDb.UpdateInBox(pGuid, pCompany, '', '', '', 0, 0, cLOADINGFILES
            {cPOPULATING}, lMsg.Mode,
            dbDoUpdate);

          If lDB.GetInboxMessageStatus(pGuid) <> cLOADINGFILES {cPOPULATING} Then
            lDb.SetInboxMessageStatus(pGuid, cLOADINGFILES {cPOPULATING});
        End; {if not pRecreate then}

        lXmlList := TXMLList.Create(Nil);
      { BI 8.	DSR retrieves all packets from storage and decompresses and decrypts the native XML message data. DSR creates an ordered collection of the XML messages.}
        lTotal := lDb.GetTotalFiles(pGuid);

        If lTotal > 0 Then
        Begin
          lProcess := True;

          {cis files have another treatment}
          If lMsg.Mode = Ord(rmCIS) Then
          Begin
            lXmlList.DeleteFiles := False;
            
            {recreate inbox file}
            lFileName := IncludeTrailingPathDelimiter(lSystem.InboxDir +
              GUIDToString(pGuid)) + '1.xml';

            lProcess := _FileSize(lFileName) > 0;

            If lProcess Then
            Begin
              if lMsg.Pack_Id = 0 then
              begin
                lPack := lDb.GetExportPackage(lMsg.Company_Id, cCISSUBCONTRACTOR);
                if lPack <> nil then
                begin
                  lMsg.Pack_Id := lDB.GetImportIdbyLink(lPack.PluginLink);
                  lPack.Free;
                end; {if lPack <> nil then}
              end; {if lMsg.Pack_Id = 0 then}

             { Add the xml to list of xmls }
              With lXmlList.Add Do
              Begin
                XML := lFileName;
                Pack_Id := lMsg.Pack_Id;
              End; {With lXmlList.Add Do}
            End; {if lProcess then}
          End
          Else
          Begin
            {extract the xml from the stored files}
            For lCount := 1 To lTotal Do
            Begin

              Try
                lDb.SetInboxTotalDone(pGuid, Trunc((lCount / lTotal) * 100));
              Except
              End;

              lFileName := lSystem.InboxDir + GUIDToString(pGuid) + '\' +
                inttostr(lCount) + cXmlExt;

              FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
              _GetHeaderFromFile(lDSRHeader, lFileName);

               {retrieve the xml from the file. this xml will help to determinate what package to use}
              Try
                lXml := _GetXmlFromFile(lFileName);
              Except
                On e: exception Do
                Begin
                  lLog.DoLogMessage('TDSRImport.CallImport', 0,
                    'Error retrieving xml from ' + lFilename + '. Error: ' +
                    e.message, True, True);
                  lXml := '';
                End;
              End; {try}

              If lXml <> '' Then
              Begin
               {check the exchequer version that you are about to import...
               if a user request to recreate the company, it will be importing data to the same company
               version!!!}
                If (lDSRHeader.ProductType <> Ord(_ExProductType)) Or pRecreate Then
                Begin
                  lXmlDoc := TXMLDoc.Create;

                  If lXmlDoc.LoadXml(lXml) Then
                  Begin
                    FillChar(lXMLHeader, SizeOf(TXMLHeader), #0);
                    _GetXMLHeader(lXmlDoc, lXMLHeader);

                {get the xsd file provided by the xml (attribute)}
                    lXSDFile := lSystem.XSDDir + lXMLHeader.xsd;

                {BI 9. DSR validates all XML messages with their relevant XSD schema files (information loaded from the ICE database). Remember no XSLT at this point because we are dealing with homogeneous systems. The exception is GGW messages which we will look at shortly.}
                    If Not lXmlDoc.Validate(lXSDFile, '') Then
                    Begin
                    // BI 10a a.	For each message that fails to validate against native schema, a NACK status message specifying invalid message data is returned to the originating system. The ICE inbox entry is deleted, as is the packet from file system storage. Import is cancelled.
                      lProcess := False;
                      Result := cVALIDATINGXMLERROR;
                      lLog.DoLogMessage('TDSRSERVER.CallImport', Result, lFilename);
                    End
                    Else
                    Begin
                    { Add the xml to list of xmls }
                      With lXmlList.Add Do
                      Begin
                        XML := lXml;
                        {get the link from the exported xml  }
                        Pack_Id := lDb.GetImportIdbyLink(lXmlHeader.Plugin);
                        PluginLink := lXmlHeader.Plugin;
                      End; {With lXmlList.Add Do}
                    End; {begin}
                  End
                  Else
                  Begin
                    lProcess := False;
                    Result := cLOADINGXMLERROR;
                    lLog.DoLogMessage('TDSRImport.CallImport', Result, lFilename,
                      True, True);
                  End; {begin}

                  FreeAndNil(lXmlDoc);
                End
                Else
                Begin
                  Result := cEXCHINVALIDPRODUCTTYPE;
                  lProcess := False;
                  lLog.DoLogMessage('TDSRImport.CallImport', Result,
                    'It is only possible to sync between Customer and Practice version of Exchequer.',
                    True, True);
                  Break;
                End;
              End
              Else
              Begin
                {sync request}
                lFileName := lSystem.InboxDir + GUIDToString(pGuid) + '\' +
                  cACKFILE;
                _GetHeaderFromFile(lDSRHeader, lFileName);

                {changed to support rmSync}
                If (lDSRHeader.Flags = Ord(mtSyncRequest)) And
                  (lDSRHeader.Mode = Ord(rmSync)) Then
                Begin
                  If lDSRHeader.ProductType <> Ord(_ExProductType) Then
                  Begin
                  {look for a sync request before deny this file}

                    {get the company information}
                    FillChar(lSyncReq, SizeOf(TSyncRequest), 0);
                    _GetSyncReqFromFile(lSyncReq, lfileName);
                    lProcess := True;
                    Break;
                  End
                  Else
                  Begin
                    Result := cEXCHINVALIDPRODUCTTYPE;
                    lProcess := False;
                    lLog.DoLogMessage('TDSRImport.CallImport', Result,
                      'It is only possible to sync between Customer and Practice version of Exchequer.',
                      True, True);
                    Break;
                  End;
                End
                Else
                Begin
                  lProcess := False;
                  Result := cINVALIDXML;
                  lLog.DoLogMessage('TDSRImport.CallImport', Result,
                    ChangeFileExt(lFilename, cXMLEXT), True, True);
                  Break;
                End; {begin}
              End; {begin}

              {quick update to the message status}
              If ((lCount Mod 10) = 0) And Not pRecreate Then
                lDb.SetInboxMessageStatus(pGuid, cLOADINGFILES {cPOPULATING});

              {dont eat cpu!}
  //            If (lCount Mod 2) = 0 Then
              Sleep(1);
            End; {For lCount := 1 To lTotal Do}
          End; {else ord(rmcis)}

        { if all files are validated and the dsr could load its xml,
        the dsr is able to load the import plugin}
          If lProcess Then
          Begin
            lDb.SetInboxMessageStatus(pGuid, cPOPULATING);
            lDb.SetInboxTotalDone(pGuid, 0);
            {create the new company }
            If (lDSRHeader.Flags = Ord(mtSyncRequest)) And (lDSRHeader.Mode =
              Ord(rmSync)) Then
            Begin
              {check the company parameters}
              If (Trim(lSyncReq.Desc) <> '') And (Trim(lSyncReq.ExCode) <> '') And
                (Trim(lSyncReq.Guid) <> '') Then
              Begin
                lExCode := Trim(lSyncReq.ExCode);
                {call the thread company aloow multiple companies being created}
                CreateCompany(pGuid, lSyncReq.Desc, lSyncReq.Guid, lExCode, Result);

                If Result = S_OK Then
                Begin
                  lComp := lDB.GetCompanyId(lExCode);
                  lLog.DoLogMessage('TDSRImport.CallImport', Result, 'The Company '
                    + lSyncReq.Desc + ' and code ' + lSyncReq.ExCode +
                    ' has been created. Id: ' + lSyncReq.Guid, True, True);
                End
                Else
                Begin
                  lLog.DoLogMessage('TDSRImport.CallImport', Result,
                    'The company name ' + lSyncReq.Desc + ' code ' + lSyncReq.ExCode
                    + ' could not be created');
                End; {begin}
              End {If (Trim(lSyncReq.Desc) <> '') And (Trim(lSyncReq.ExCode) <> '') And (Trim(lSyncReq.Guid) <> '') Then}
              Else
              Begin
                Result := cINVALIDPARAM;
                lLog.DoLogMessage('TDSRImport.CallImport', Result, 'Company code: '
                  + lSyncReq.ExCode + '. Company name: ' + lSyncReq.Desc);
              End; {begin}
            End {If (lDSRHeader.Flags = Ord(mtSyncRequest)) And (lDSRHeader.Mode = rmSync) Then}
            Else
            Begin
              lComp := pCompany;
              {if recreate is set, just import the data}
              If pRecreate Then
                Result := ImportFiles(pGuid, lXmlList, pCompany)
              Else
              Begin
                {check if this company is already in dripfeed mode and the user is trying to
                import a bulk data...}
                If (lDSRHeader.Flags = Ord(mtData)) And (lDSRHeader.Mode =
                  Ord(rmBulk)) And
                  _CheckExDripFeed(lDb.GetCompanyPathbyGuid(lDSRHeader.CompGuid))
                  Then
                  Result := cCOMPANYALREADYINDRIPFEED
                Else If (lDSRHeader.Flags = Ord(mtData)) And (lDSRHeader.Mode =
                  Ord(rmDripFeed)) And Not
                  _CheckExDripFeed(lDb.GetCompanyPathbyGuid(lDSRHeader.CompGuid))
                  Then
                  Result := cCOMPANYNOTINDRIPFEED
                Else {get the list of xmls and try to import it using the xml headers configuration}
                  Result := ImportFiles(pGuid, lXmlList, lComp {pCompany});
              End; {if pRecreate then}
            End; {begin}

          { BI 11. On success reported by import plugin, DSR marks ICE inbox entries as processed.}
            If (Result = S_OK) And Not pRecreate Then
              lDb.UpdateInBox(pGuid, lComp {pCompany}, '', '', '', 0, 0, cPROCESSED,
                lMsg.Mode, dbDoUpdate)
          End
          Else
            Result := cFAILUREVALIDATINGFILE;
        End
        Else
          Result := cNODATATOBEIMPORTED;
      End
      Else
        Result := cNOTREADYTOIMPORT;
    Except
      On e: exception Do
      Begin
        Result := cERROR;
        lLog.DoLogMessage('TDSRImport.CallImport', 0, 'Error: ' + e.message,
          True, True);
      End;
    End
    Else
      Result := cINVALIDGUID;
  End
  Else
    REsult := cDBERROR;

  If Assigned(lXmlList) Then
    FreeAndNil(lXmlList);

  {check the result and update database}
  If Result <> S_OK Then
  Begin
    lLog.DoLogMessage('TDSRImport.CallImport', Result, '', True, True);
    If (Result <> cINVALIDGUID) And Not pRecreate Then
      lDb.UpdateInBox(pGuid, lComp {pCompany}, '', '', '', 0, 0, ifThen(Result =
        cCANCELLED, cCANCELLED, cFAILED), ifthen(lMsg <> Nil, lMsg.Mode, -1),
        dbDoUpdate);
  End {If Result <> S_OK Then}
  Else If (lMsg <> Nil) Then
    lLog.DoLogMessage('TDSRImport.CallImport', 0, 'Message subject "' +
      lmsg.Subject + '" successfully imported!', True, True);

  {send a ACK or Nack to the original mail saying what happened/what to do next
  if recreate is set, i dont need send anything}
  If (lMsg <> Nil) And Not pRecreate Then
  Begin
    {the header indicate a sync request has been made}
    If (lDSRHeader.Flags = Ord(mtSyncRequest)) And (lDSRHeader.Mode = Ord(rmSync))
      Then
    Begin
      {when recreating a company, there is no need for sending emails back to client}
        {send a request asking for a bulk export}
      If Result = S_OK Then
      Begin
        lDb.UpdateInBox(pGuid, lComp {pCompany}, '', '', '', 0, 0, cSYNCACCEPTED,
          lMsg.Mode, dbDoUpdate);

        lSendResponse := TDSRMail.SendACK(lMsg.Guid, lMsg.To_, lMsg.From,
          lMsg.TotalItens, rmBulk, lSyncReq.ExCode, lSyncReq.Guid,
          //'[** DRIPFEED REQUEST ACCEPTED **]. The subject was: ' + lMsg.Subject);
          '[** LINK REQUEST ACCEPTED **]. The subject was: ' + lMsg.Subject);

        _UpdateOutbox(lMsg, lComp,
          //'[** DRIPFEED REQUEST ACCEPTED **]. The subject was: ' + lMsg.Subject,
          '[** LINK REQUEST ACCEPTED **]. The subject was: ' + lMsg.Subject,
          lSendResponse, lDb);
      End
      Else
      Begin
          {send a nack saying what went wrong}
        lSendResponse := TDSRMail.SendNACK(lMsg.Guid, lMsg.To_, lMsg.From, 0,
          cNACKSYNCFAILED, lSyncReq.ExCode, lSyncReq.Guid,
          //'Dripfeed Request Failed. Reason: ' + ifthen(Result =
          'Link Request Failed. Reason: ' + ifthen(Result = cEXCHCOMPLICEXCEEDED,
          'Please contact your Accountant to confirm licence status.',
          _TranslateErrorCode(Result)));

        _UpdateOutbox(lMsg, lComp,
          //'Dripfeed Request Acknowledge. The subject was: ' + lMsg.Subject,
          'Link Request Acknowledge. The subject was: ' + lMsg.Subject,
          lSendResponse, lDb);
      End; {else begin}
    End {begin}
    Else If (lDSRHeader.Flags = Ord(mtData)) And (lDSRHeader.Mode = Ord(rmBulk)) Then
    Begin
      {retrieve company path}
      lPath := lDb.GetCompanyPath(lComp);
      If lPath = '' Then
        lPath := lDB.GetCompanyPathbyGuid(lDSRHeader.CompGuid);

        {check if this company can be changed its status to dripfeed}
      If (Result = S_OK) Or (Result = cCOMPANYALREADYINDRIPFEED) Then
      Begin
        {Apply dripfeed mode when success}
        If (Result = S_OK) Then
          _ApplyDripFeed(lPath);

        lSendResponse := TDSRMail.SendACK(lMsg.Guid, lMsg.To_, lMsg.From,
          lMsg.TotalItens, rmDripFeed, lDSRHeader.ExCode, lDSRHeader.CompGuid,
          '[** Bulk Data successfully imported **]. The subject was: ' +
          lMsg.Subject);

        _UpdateOutbox(lMsg, lComp, 'Bulk Acknowledge. The subject was: ' +
          lMsg.Subject, lSendResponse, lDb);
      End
      Else
      Begin
        {remove dripfeed mode if failure}
        _RemoveDripFeed(lPath);

        lSendResponse := TDSRMail.SendNACK(lMsg.Guid, lMsg.To_, lMsg.From, 0,
          cNACKBULKFAILED, lDSRHeader.ExCode, lDSRHeader.CompGuid,
          'Bulk Failed. Reason: ' + _TranslateErrorCode(Result));

        _UpdateOutbox(lMsg, lComp, 'Bulk Acknowledge. The subject was: ' +
          lMsg.Subject, lSendResponse, lDb);
      End; {begin}
    End {begin}
    Else If (lDSRHeader.Flags = Ord(mtData)) And (lDSRHeader.Mode = Ord(rmDripFeed))
      Then
    Begin
        {check if this company can be changed its status to dripfeed}
      If Result = S_OK Then
      Begin
        lSendResponse := TDSRMail.SendACK(lMsg.Guid, lMsg.To_, lMsg.From, 1,
          rmNormal, lDSRHeader.ExCode, lDSRHeader.CompGuid,
          //'[** Dripfeed successfully imported **]. The subject was: ' +
          '[** Linked Data successfully imported **]. The subject was: ' +
          lMsg.Subject);

        //_UpdateOutbox(lMsg, lComp, 'Dripfeed Acknowledge. The subject was: ' +
        _UpdateOutbox(lMsg, lComp, 'Link Acknowledge. The subject was: ' +
          lMsg.Subject, lSendResponse, lDb);
      End
      Else
      Begin
        lSendResponse := TDSRMail.SendNACK(lMsg.Guid, lMsg.To_, lMsg.From, 0,
          cNACKDRIPFEEDFAILED, lDSRHeader.ExCode, lDSRHeader.CompGuid,
          //'Dripfeed Failed. Reason: ' + _TranslateErrorCode(Result));
          'Link Failed. Reason: ' + _TranslateErrorCode(Result));

        //_UpdateOutbox(lMsg, lComp, 'Dripfeed Acknowledge. The subject was: ' +
        _UpdateOutbox(lMsg, lComp, 'Link Acknowledge. The subject was: ' +
          lMsg.Subject, lSendResponse, lDb);
      End; {else begin}
    End; {If (lDSRHeader.Flags = Ord(mtData)) And (lDSRHeader.Mode = Ord(rmDripFeed)) then}
  End; {If (lMsg <> Nil) Then}

  If Assigned(lDb) Then
    FreeAndNil(lDb);
  If Assigned(lLog) Then
    FreeAndNil(lLog);
  If Assigned(lSystem) Then
    FreeAndNil(lSystem);
  If Assigned(lMsg) Then
    FreeAndNil(lMsg);
End;

{-----------------------------------------------------------------------------
  Procedure: CreateCompany
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Procedure TDSRImport.CreateCompany(pMsgGuid: TGuid; Const pDesc, pCompGuid:
  String; Var pExCode: String; Var pResult: Longword);
Var
  lTh: TDSRCreateCompany;
  lRel: Integer;
Begin
  lRel := 0;
  lTh := TDSRCreateCompany.Create;
  With lTh Do
  Begin
    Description := Trim(pDesc);
    MSGGUID := pMsgGuid;
    Code := pExCode;
    Guid := pCompGuid;
    Try
      Resume;
      Repeat {wait the thread finish its job}
        Sleep(500);
        Inc(lRel);
      Until (Terminated) Or (lRel = 100);

      If Not Terminated Then
      Begin
        Terminate;
        Sleep(1000);
      End;
    Finally
      pResult := ReturnedValue;
      pExCode := Code;
      lTh.Free;
    End;
  End; {With lTh Do}
End;

{ TDSRCreateCompany }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor TDSRCreateCompany.Create;
Begin
  Inherited Create(True);
  FreeOnTerminate := False;
  fDescription := '';
  fGuid := '';
  fCode := '';
  fReturnedValue := cERROR;

  Try
    fDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      _LogMSG('TDSRCreateCompany.Create :- Error connecting database. Error: ' +
        e.message);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TDSRCreateCompany.Destroy;
Begin
  If Assigned(fDb) Then
    FreeAndNil(fDb);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: Execute
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TDSRCreateCompany.Execute;
Var
  lComp: OleVariant;
  lCompId: Integer;
  lAux,
    lCompGuid: String;
  lValidGuid: Boolean;
Begin
  fReturnedValue := cERROR;

(*  If Assigned(fCompLock) Then
  Begin
    fCompLock.BeginWrite;*)

      {check and validate the new companies}
  Try
    If Assigned(fDb) Then
    Begin
      Try
        lValidGuid := _IsValidGuid(fMSGGUID);

        If lValidGuid Then
          fDb.SetInboxTotalDone(fMSGGUID, 10);
        Sleep(100);

          {get the next valid company code if that exists...}
        lAux := StringReplace(Trim(fDescription), ' ', '', [rfReplaceAll]);
        fReturnedValue := cERROR;
        lAux := GetNextCompCode(Copy(lAux, 1, 4));
        If lAux <> '' Then
          fCode := lAux;

        _CallDebugLog('About to create the new company...');
        fReturnedValue := CreateExCompany(fDescription, fCode);

        If lValidGuid Then
          fDb.SetInboxTotalDone(fMSGGUID, 30);

        Sleep(500);

        _CallDebugLog('Result of creating company: ' + inttostr(fReturnedValue));

        {if this company already exists, check the company guid. if they are equal, this company
        was created by a sync request}
        If fReturnedValue = cEXCHCOMPALREADYEXISTS Then
        Begin
          lCompGuid := fDb.GetCompanyGuid(fCode);
          If (lCompGuid <> '') And (Trim(fGuid) <> '') Then
            If (Lowercase(lCompGuid) = Trim(fGuid)) Then
              fReturnedValue := 0;
        End; {If ReturnValue = cEXCHCOMPALREADYEXISTS Then}

        If fReturnedValue <> S_OK Then
          _LogMSG('TDSRCreateCompany.Execute :- Error creating company. Error Code: '
            + inttostr(fReturnedValue) + ' Description: ' +
            _TranslateErrorCode(fReturnedValue));

        If lValidGuid Then
          fDb.SetInboxTotalDone(fMSGGUID, 60);

        Sleep(500);

          {update and check the new company}
        If fReturnedValue = 0 Then
        Begin
          If lValidGuid Then
            fDb.SetInboxTotalDone(fMSGGUID, 70);

          _CallDebugLog('Loading Exchequer companies...');
          lComp := null;
          Try
            lComp := _LoadExCompanies;
          Except
            On E: exception Do
              _LogMSG('TDSRCreateCompany.Execute :- Error loading Exchequer companies. Error: '
                + e.Message);
          End; {try}

          If lValidGuid Then
            fDb.SetInboxTotalDone(fMSGGUID, 80);

          If _GetOlevariantArraySize(lComp) > 0 Then
          Begin
            _CallDebugLog('updating db with exchequer companies');
            fDb.CheckExCompanies(lComp);
            _CallDebugLog('Get company id code');
            lCompId := fDb.GetCompanyId(fCode);
            _CallDebugLog('Set company guid');

            Try
              fDb.SetCompanyGuid(lCompId, stringtoguid(Trim(fGuid)));
            Except
              fDb.SetCompanyGuid(lCompId, _CreateGuid)
            End;

            _CallDebugLog('set company status');
            fDb.SetCompanyStatus(lCompId, True);
          End
          Else
            _LogMSG('TDSRCreateCompany.Execute :- No companies have been returned from Exchequer.');
        End; {if ReturnValue = 0 then}

        If lValidGuid Then
          fDb.SetInboxTotalDone(fMSGGUID, 90);

        Sleep(500);
      Except
        On e: exception Do
        Begin
          fReturnedValue := cERROR;
          _LogMSG('TDSRCreateCompany.Execute :- Error creating company. Error 1: '
            + e.Message);
        End;
      End; {If Assigned(lDb) Then}
    End
    Else
      fReturnedValue := cDBERROR;
  Except
    On e: exception Do
      _LogMSG('TDSRCreateCompany.Execute :- Error creating company . Error 2: '
        + e.Message);
  End; {try}

(*    fCompLock.EndWrite;
  End {If Assigned(fCompLock) Then}
  Else
    _LogMSG('TDSRCreateCompany.DoWriting :- No company lock assigned');*)

  If lValidGuid Then
    fDb.SetInboxTotalDone(fMSGGUID, 100);

  Sleep(1000);

  Terminate;
End;

{-----------------------------------------------------------------------------
  Procedure: GetNextCompCode
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TDSRCreateCompany.GetNextCompCode(SeedText: ShortString): ShortString;
Var
  sBase, sCode: String[6];
  iLoop: SmallInt;
  iMax, iId: LongInt;
Begin // GetNextCompCode
  Result := '';

  SeedText := Uppercase(Trim(SeedText));

  For iLoop := 4 Downto 1 Do
  Begin
    // Check we got enough chars
    If (Length(SeedText) >= iLoop) Then
    Begin
      sBase := Copy(SeedText, 1, iLoop);
      iMax := Trunc(Power(10, 6 - iLoop)) - 1;

      For iId := 1 To iMax Do
      Begin
        sCode := sBase + Format('%*.*d', [6 - iLoop, 6 - iLoop, iId]);

        If (fDb.GetCompanyId(sCode) = 0) And (fDb.GetCompanyGuid(sCode) = '') Then
        Begin
          Result := sCode;
          Break;
        End; // If (fDb.GetCompanyId(sCode) = 0) And (fDb.GetCompanyGuid(sCode) = '') Then
      End; // For iId
    End; // If (Length(SeedText) >= iLoop)

    If (Result <> '') Then
      Break;
  End; // For iLoop
End;

End.

