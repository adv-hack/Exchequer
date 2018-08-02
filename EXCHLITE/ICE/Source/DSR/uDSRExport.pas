{-----------------------------------------------------------------------------
 Unit Name: uDSRExport
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRExport;

Interface

Uses
  Classes,
  uConsts,
  uInterfaces,
  uXmlList
  ;

Type
  TDSRExport = Class
  Private
    Class Function PrepareFilesAndSendCIS(pMessageInfo: TMessageInfo; pXmlList:
      TXMLList): Longword;
  Public
    Class Function SendFiles(pGuid: TGuid; pFrom, pTo_, pSubj: String; Var
      pFileList: TStringList): Longword;
    Class Function PrepareFilesAndSend(pMessageInfo: TMessageInfo; pXmlList:
      TXMLList; pRecMode: TRecordMode): Longword;
    Class Function CallExportPlugin(pPack: TPackageInfo; Const pParam1,
      pParam2, pCompanyPath: WideString; Var pXmlList: TXMLList): Longword;
    Class Function CallExport(pMsg: TMessageInfo): LongWord;
  End;

Implementation

Uses Sysutils, Windows, ComObj, Math,
  uDSRSettings, DSRExport_TLB, uExFunc, uDSRMail, uAdoDsr, uDSRHistory,
  uXmlBaseClass, uDSRFileFunc, uSystemConfig, uCommon, uBaseClass;

{ TDSRExport }

{-----------------------------------------------------------------------------
  Procedure: CallExportPlugin
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRExport.CallExportPlugin(pPack: TPackageInfo;
  Const pParam1, pParam2, pCompanyPath: WideString; Var pXmlList: TXMLList):
  Longword;
Var
  lExport: IExportBox;
  lTotal,
    lCont: Integer;
  lLog: _Base;
  lSystem: TSystemConf;
  lPath: String;
Begin
  lLog := _Base.Create;
  lSystem := TSystemConf.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(lSystem.DBServer);

  { check the package guid}
  If _IsValidGuid(pPack.Guid) Then
  Begin
    Try
     { get the export box (default) and create new export object through a guid}
      lExport := CreateComObject(pPack.Guid) As IExportBox;
    Except
      On e: Exception Do
      Begin
        Result := cLOADINGEXPORTPLUGINERROR;
        lLog.DoLogMessage('TDSRExport.CallExportPlugin', Result, 'Error: ' +
          e.Message);
        lExport := Nil;
      End; {begin}
    End; {try}

    If Assigned(lExport) Then
    Begin
    { get the exchequer company datapath}
      lPath := pCompanyPath;
      If Not _DirExists(lPath) Then
        lpath := _GetExCompanyPath(pPack.ExCode);

      Try
        {call export plugin}
        Result := lExport.DoExport(pPack.ExCode, lPath,
          lSystem.XMLDir, _GetPeriod(pParam1), _GetYear(pParam1),
          _GetPeriod(pParam2), _GetYear(pParam2), pPack.UserReference);

        If (Result <> S_OK) And (Result <> cNODATATOBEEXPORTED) Then
          lLog.DoLogMessage('TDSRExport.CallExportPlugin', Result,
            'Export plug-in error. ' +
            ' Code: ' + pPack.ExCode +
            ' Path: ' + lPath);
      Except
        On e: Exception Do
        Begin
          Result := cPLUGINERROR;
          lLog.DoLogMessage('TDSRExport.CallExportPlugin', Result,
            ' Code: ' + pPack.ExCode +
            ' Path: ' + lPath +
            ' Param1: ' + pParam1 +
            ' Param2: ' + pParam2 +
            ' Error: ' + e.Message, true, true);
        End; {begin}
      End; {try}

    { get the total exported xmls}
      lTotal := lExport.XmlCount;

      If (lTotal >= 0) And ((Result = S_OK) Or (Result = cNODATATOBEEXPORTED)) Then
      Begin
//        If Result = cNODATATOBEEXPORTED Then
//          Result := S_OK;

      { add the xmls to the list}
        For lCont := 0 To lTotal - 1 Do
        Begin
          With pXmlList.Add Do
          Begin
            XML := lExport.XmlList[lCont];
            Pack_Id := pPack.Id;
          End; {with pXmlList.Add do}
        End; {For lCont := 0 To lTotal - 1 Do}
      End
      Else
        Result := cNODATAEXPORTED;
    End {If Assigned(lExport) Then}
    Else
      Result := cEXPORTPLUGINNOTAVAILABLE;
  End {If _IsValidGuid(pPack.Guid) Then}
  Else
    Result := cINVALIDEXPORTGUID;

  lExport := Nil;

  FreeAndNil(lLog);
  FreeAndNil(lSystem);
End;

{-----------------------------------------------------------------------------
  Procedure: CallExport
  Author:    vmoura

  this function does as follow
  1) Load the plugin to use
  2) call export plugin and get a list of xmls
  3) prepare and send this files off
  4) update the database
-----------------------------------------------------------------------------}
Class Function TDSRExport.CallExport(pMsg: TMessageInfo): LongWord;
Var
  lPack: TPackageInfo;
  lXmlList: TXMLList;
  lDb: TADODSR;
  lLog: _Base;
  lMsg: TMessageInfo;
Begin
{
1. User requests DSR to invoke a bulk export operation from dashboard, providing a specific time period and type of record.
2. DSR looks up export plugin configuration information from ICE database and creates and instance of the export plugin from the GUID retrieved from the ICE database.
}

  lLog := _Base.Create;
  lMsg := TMessageInfo.Create;
  lMsg.Assign(pMsg);

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRExport.CallExport', 0,
        'Error connecting the database. Error: ' + e.message);
  End;

  If Assigned(lDb) And lDb.Connected Then
  Begin
    lLog.ConnectionString := lDb.ConnectionString;

  { get the default parameters from the export package}
    Case lMsg.Mode Of
      Ord(rmDripFeed): {Dripfeed}
        lPack := lDb.GetExportPackage(lMsg.Company_Id, cDRIPFEED);
      Ord(rmCIS):
        begin
          //lPack := lDb.GetExportPackage(lMsg.Company_Id, cCISMONTHLYEXPORT);
          lPack := lDb.GetExportPackage(lMsg.Pack_Id, lMsg.Company_Id);
          if lPack = nil then
            lPack := lDb.GetExportPackage(lMsg.Company_Id, cCISMONTHLYEXPORT);
        end;
    Else
      lPack := lDb.GetExportPackage(lMsg.Pack_Id, lMsg.Company_Id);
    End;

  { check the export guid...}
    If lPack <> Nil Then
    Try
    {update the status to avoid send this message again in the same minute}
      lDb.UpdateOutBox(lMsg.Guid, 0, '', '', '', 0, 0, '', '', cPROCESSING,
        lMsg.Mode, dbDoUpdate);

      lXmlList := TXMLList.Create(Nil);

      Result := CallExportPlugin(lPack, lMsg.Param1, lMsg.Param2,
        lDb.GetCompanyPath(lMsg.Company_Id), lXmlList);

    {get the xmls (pure xml or file system files) and send them off}
      If (lXmlList.Count > 0) And (Result = S_OK) Then
      Begin
        {send in Dripfeed mode, normally or cis
        cis requires a slight diferent version of sending due this sending
        uses the fbi components }
        Case lMsg.Mode Of
          ord(rmDripFeed): Result := PrepareFilesAndSend(lMsg, lXmlList, rmDripFeed);
          Ord(rmCIS): Result := PrepareFilesAndSendCIS(lMsg, lXmlList);
        Else
          Result := PrepareFilesAndSend(lMsg, lXmlList, rmNormal);
        End;

        {if in Dripfeed and the e-mail was sent off, update the send date because next time the dsr
        is going to export date from this date until the current date}
        If Result = S_OK Then
        Begin
          {treating cis reforms diferently and the reason for that is later, the incoming
          process will pick up this file and try to process it polling information
          from the GGW}
          If lMsg.Mode = Ord(rmCIS) Then
          Begin
            lDb.UpdateOutBox(lMsg.Guid, 0, '', '', '', 0, lXmlList.Count, '', '',
              cCISSENT, lMsg.Mode, dbDoUpdate);

            {call the CIS polling system. The cisreceiverguid helps to identify if there is
            one instance already running}
            If _FileSize(_GetApplicationPath + cCISRECEIVER) > 0 Then
              _fileExec(_GetApplicationPath + cCISRECEIVER + ' ' + cCISRECEIVERGUID,
                True, False)
            Else
              _LogMSG('TDSRExport.CallExport :- CIS Receiver application not found. Application name: '
                + cCISRECEIVER);
          End
          Else
            lDb.UpdateOutBox(lMsg.Guid, 0, '', '', '', 0, lXmlList.Count, '', '',
              cSENT, lMsg.Mode, dbDoUpdate);
        End
        Else
          lDb.UpdateOutBox(lMsg.Guid, 0, '', '', '', 0, 0, '', '', cFAILED,
            lMsg.Mode, dbDoUpdate)
      End
      Else
      Begin
        lDb.UpdateOutBox(lMsg.Guid, 0, '', '', '', 0, 0, '', '', ifthen((Result =
          cNODATATOBEEXPORTED) Or (Result = cNODATAEXPORTED), cNODATASENT, cFAILED),
          lMsg.Mode, dbDoUpdate);
      End; {begin}

      FreeAndNil(lXmlList);
    Except
      On e: exception Do
      Begin
        Result := cERROR;
        lLog.DoLogMessage('TDSRSERVER.CallExport', 0,
          'General error exporting messages. Error: ' + e.message, True, True);
      End;
    End
    Else
      Result := cINVALIDEXPORTPACK;
  End
  Else
    REsult := cDBERROR;

  If Result <> S_OK Then
    lLog.DoLogMessage('TDSRSERVER.CallExport', Result, 'Mail from: ' +
      lMsg.From + ' To: ' + lMsg.To_ + ' Date: ' + datetimetostr(lMsg.Date),
      True, True);

  If Assigned(lPack) Then
    FreeAndNil(lPack);

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  If Assigned(lLog) Then
    FreeAndNil(lLog);

  If Assigned(lMsg) Then
    freeAndNil(lMsg);
End;

{-----------------------------------------------------------------------------
  Procedure: PrepareFilesAndSend
  Author:    vmoura

  this function does as follow
  1) load and validate the xml
  2) save it in fhe file system
  3) fill the header of the file
  4) try to send the files off with 1 MEGA limit size
-----------------------------------------------------------------------------}
Class Function TDSRExport.PrepareFilesAndSend(pMessageInfo: TMessageInfo;
  pXmlList: TXMLList; pRecMode: TRecordMode): Longword;
Var
  lFilesToSend,
    lDSRFiles: TStringList;
      { dsr files. could be one or more files splitted in 1Mega}
  lXSDFile: String; { schema validation file}
  lXml: WideString;
  lCont, lCont2: Integer;
  lOutputDir,
    lExCode, lCompGuid,
    lFileName: String;
  lXmlDoc: TXMLDoc;
  lXmlHeader: TXMLHeader;
  lDsrHeader: TDSRFileHeader;
  lSystem: TSystemConf;
  lLog: _Base;
  lDb: TADODSR;
Begin
  _CallDebugLog('Start sending');

  Result := S_OK;
  lSystem := TSystemConf.Create;
  lLog := _Base.Create;

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRExport.PrepareFilesAndSend', 0,
        'Error connecting the Database. Error: ' + e.message);
  End;

  {check database connectivity}
  If Assigned(lDb) And lDb.Connected Then
  Begin
    lLog.ConnectionString := lDb.ConnectionString;

    With pMessageInfo, pXmlList Do
    Begin
      {check the list}
      If Count > 0 Then
      Begin
        lOutputDir := IncludeTrailingPathDelimiter(lSystem.OutboxDir +
          GUIDToString(Guid));

      {check the new directory}
        If _DirExists(lOutputDir) Then
        Try
          _DelDirFiles(lOutputDir);
        Finally
          _DelDir(lOutputDir);
        End;

        ForceDirectories(lOutputDir);

        {create lock file for this particular bulk or dripfeed operation.
        this file will remain under the directory until the customer sends an acknowledge
        saying all files have been receiver}
        If pRecMode In [rmBulk, rmDripFeed] Then
          _CreateDSRLockFile(lOutputDir);

        lFilesToSend := TStringList.Create;

        Try
          lXmlDoc := TXMLDoc.Create;
          lExCode := lDb.GetExCode(Company_Id);
          lCompGuid := lDb.GetCompanyGuid(Company_Id);

          {update message status and the total done}
          lDb.SetOutboxMessageStatus(Guid, cCHECKING);
          lDb.SetOutboxTotalDone(Guid, 0);

          {process the list of xmls}
          For lCont := 0 To Count - 1 Do
          Try
            {update total done}
            Try
              lDb.SetOutboxTotalDone(Guid, Trunc(((lCont + 1) / Count) * 100));
            Except
            End;

            {update message status}
            If (lCont Mod 10) = 0 Then
              lDb.SetOutboxMessageStatus(Guid, cCHECKING);

            lXmlDoc.Clear;
            lXml := '';
            Try
              lXml := Items[lCont].XML;
            Except
              lXml := '';
            End;

          { try to load the xml or a file system}
            If _FileSize(lXml) > 0 Then
              lXmlDoc.Load(lXml)
            Else
              lXmlDoc.LoadXml(lXml);

            _CallDebugLog('TDSRExport.PrepareFilesAndSend :- Parse error loading xml: '
              + lXmlDoc.Doc.parseError.reason);

          { verify the xml integrity. the dsr can only send a readable xml}
            If lXmlDoc.Doc.xml <> '' Then
            Begin
              FillChar(lXmlHeader, SizeOf(TXmlHeader), #0);
              _GetXMLHeader(lXmlDoc, lXmlHeader);

          {8. DSR constructs packets ensuring that each packet has appropriate batch ID and batch order numbers. Each packet also holds a value for the total number of packets in the batch.
          also, in case of bulk operation, every xml has a link to what kind of
          import operation needed to be used.
          }

              _FillXMLHeader(lXmlHeader, Guid, lCont + 1, Count, From, To_,
                lDb.GetExportPluginLink(Items[lCont].Pack_Id),
                Ord(pRecMode)); { using the record mode as the xml flag, i can rebuild the message if something gets wrong while loading the xml and the header is corrupted}

            { set xml packet header...}
              If _SetXmlHeader(lXmlDoc, lXmlHeader) Then
              Begin
                lXSDFile := lSystem.XSDDir + lXmlHeader.xsd;

              { if validation is ok}
                If lXmlDoc.Validate(lXSDFile, '') Then
                Begin
                  If lXmlDoc.Doc.xml <> '' Then
                  Begin
                {POP/SMTP store the real file name . So, instead loading files by the real name and
                  also helping the receiver, i will change the file name for a guid and the header
                  will indicate what file to create at the end side}

                    lFileName := lOutputDir + GUIDToString(_CreateGuid) + cXmlExt;

                    FillChar(lDsrHeader, SizeOF(TDSRFileHeader), 0);
                    lDsrHeader.ProductType := Ord(_ExProductType);
                    lDsrHeader.Version := CommonBit; // cDSRVERSION;
                    lDsrHeader.BatchId := GUIDToString(Guid);
                    lDsrHeader.Order := lCont + 1;
                    lDsrHeader.Total := Count;
                    lDsrHeader.ExCode := lExCode; 
                    lDsrHeader.CompGuid := lCompGuid;

                  {set kind of information}
                    lDsrHeader.Mode := Ord(pRecMode);
                    lDsrHeader.Flags := Ord(mtData);

                {these two char will help the dsr to identify that this file belongs to the DSR system}

                    lDSRFiles := Nil;
                    lCont2 := 1;
                {DSR saves the XML packets to local storage and writes an entry into the ICE database outbox table.}
                    Repeat
                      lDSRFiles := _CreateDSRFile(lDsrHeader, lFileName,
                        lXmlDoc.Doc.xml);
                      Inc(lCont2);
                    Until (lDSRFiles <> Nil) Or (lCont2 > 3);

                    If lDSRFiles <> Nil Then
                    Begin
                { DSR invokes services from the utility layer to encrypt and then compress the native XML message data. There is no need for XSLT transformation at this point because we are sending between homogeneous systems.}

                      If lDSRFiles.Count > 0 Then
                        For lCont2 := 0 To lDSRFiles.Count - 1 Do
                          lFilesToSend.Add(lDSRFiles[lCont2]);

                      If lDSRFiles.Count > 1 Then
                      Begin
                        {lFileName := lSystem.OutboxDir +
                          GUIDToString(lXmlHeader.Guid) + '\' +
                          inttostr(lXmlHeader.Number) + cXmlExt;}
                        _CombineFiles(lFileName, lFileName);
                      End; {If lFiles.Count > 1 Then}

                      FreeAndNil(lDSRFiles);
                    End {If lFiles <> Nil Then}
                    Else
                    Begin

                      //lXmlDoc.Save(Extractfilepath(lFileName) + 'ErrorFile ' + inttostr(lCont) + '.xml');

                      Result := cSAVINGFILEERROR;
                      Break;
                    End;
                  End
                  Else
                  Begin
                    Result := cINVALIDXML;
                    Break;
                  End;
                End {If lXmlDoc.Validate(lXSDFile, '') Then}
                Else
                Begin
                  Result := cVALIDATINGXMLERROR;
                  Break;
                End;
              End {If _SetXmlHeader(lXmlDoc, lXmlHeader) Then}
              Else
              Begin
                Result := cSETTINGXMLHEADERERROR;
                Break;
              End;
            End {If lXmlDoc.Doc.xml <> '' Then}
            Else
            Begin
              Result := cINVALIDXML;
              Break;
            End;

            {delete the old file in case the plugin return a system file}
{$IFNDEF DELETEXML}
            If _FileSize(lXml) > 0 Then
              _DelFile(lXml);
{$ENDIF}

            {to avoid 100% CPU}
            If (lCont Mod 5) = 0 Then
              Sleep(1);
          Except
            On e: exception Do
            Begin
              Result := cERROR;
              lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSend', Result,
                'An exception has ocurred while processing files. Error: ' +
                e.message, True, True);
              Break;
            End;
          End; {For lCount := 0 To lTotal - 1 Do}

          FreeAndNil(lXmlDoc);
          If Assigned(lDSRFiles) Then
            FreeAndNil(lDSRFiles);

         { 12. Export complete after all packets are sent.
            update outbox entry. this update would only change the status of the
           outbox table. There is no need to change other field values
             all files have been sent.

           the sending structure below allows the dsr send one or 1 MB messages in one single
           shot. it will avoid the end user receive thousands of emails when export
           a big amount of data   }

          If Result = S_OK Then
          Begin
(*            lFileName := '';
            lFileSize := 0;
            lCont2 := 0; // set for number of files sent
            lDb.SetOutboxMessageStatus(Guid, cSENDING);
            lDb.SetOutboxTotalDone(Guid, 0);
            lTotal := lFilesToSend.Count;
            Sleep(1000);

            {start the sending process}
            For lCont := lFilesToSend.Count - 1 Downto 0 Do
            Begin
              If lFileName <> '' Then
              Begin
                inc(lCont2);
                Try
                  lDb.SetOutboxTotalDone(Guid, Trunc(((lCont2 + 1) / lTotal) *
                    100));
                Except
                End;

                lFileName := lFileName + ',' + lFilesToSend[lCont];
                lFileSize := lFileSize + _FileSize(lFilesToSend[lCont]);
                lFilesToSend.Delete(lCont);

                {check the size of the email}
                If (lFilesToSend.Count = 0) Or (lFileSize >= MBYTE) Then
                Begin
                  Result := TDSRMail.SendMsg(From, To_, Subject, lFileName);
                  If Result <> S_Ok Then
                    Break;

                  lFileName := '';
                  lFileSize := 0;

                  Sleep(2000);
                End; {If (lFilesToSend.Count = 0) Or (lFileSize >= MBYTE) Then}
              End {If lFileName <> '' Then}
              Else
              Begin
                inc(lCont2);
                Try
                  lDb.SetOutboxTotalDone(Guid, Trunc(((lCont2 + 1) / lTotal) *
                    100));
                Except
                End;

                lFileName := lFilesToSend[lCont];
                lFileSize := lFileSize + _FileSize(lFilesToSend[lCont]);
                lFilesToSend.Delete(lCont);
                {check the size of the email}
                If (lFilesToSend.Count = 0) Or (lFileSize >= MBYTE) Then
                Begin
                  Result := TDSRMail.SendMsg(From, To_, Subject, lFileName);
                  If Result <> S_Ok Then
                    Break;

                  lFileName := '';
                  lFileSize := 0;

                  Sleep(2000);
                End; {If (lFilesToSend.Count = 0) Or (lFileSize >= MBYTE) Then}
              End; {begin}

              If (lCont Mod 5) = 0 Then
                Sleep(1);
            End; {For lCont := lFilesToSend.Count - 1 Downto 0 Do}*)

            Result := TDSRExport.SendFiles(Guid, From, To_, Subject, lFilesToSend);

            If Result = S_OK Then
              lDb.SetOutboxTotalDone(Guid, 100);
          End; {If Result = S_OK Then}
        Except
          On e: exception Do
          Begin
            Result := cERROR;
            lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSend', Result,
              'General error while processing messages. Error: '
              + e.message, True, True);
          End;
        End {try..except}
      End
      Else
        Result := cNODATAEXPORTED;
    End; {With pMessageInfo, pXmlList Do}
  End; {if Assigned(lDb) then}

  If Assigned(lFilesToSend) Then
    FreeAndNil(lFilesToSend);

  If Result <> S_OK Then
    lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSend', Result, '', True, True);

  If Assigned(lSystem) Then
    FreeAndNil(lSystem);

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  If Assigned(lLog) Then
    FreeAndNil(lLog);

  _CallDebugLog('end of sending');
End;

{-----------------------------------------------------------------------------
  Procedure: SendFiles
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRExport.SendFiles(pGuid: TGuid; pFrom, pTo_, pSubj: String; Var
  pFileList: TStringList): Longword;
Var
  lFileSize: Integer;
  lCont, lCont2, lTotal: Integer;
  lFileName: String;
  lDb: TADODSR;
Begin
  lFileName := '';
  lFileSize := 0;
  lCont2 := 0; // set for number of files sent
  Result := S_OK;
  
  If Assigned(pFileList) Then
    lTotal := pFileList.Count
  Else
    lTotal := 0;

  Sleep(1000);

  If lTotal > 0 Then
  Begin
    Try
      lDb := TADODSR.Create(_DSRGetDBServer);
    Except
      On e: exception Do
        _LogMSG('TDSRExport.SendFiles :- Error connecting the Database. Error: '
          + e.message);
    End;

    {check database connection}
    If Assigned(lDb) And lDb.Connected Then
    Begin
      lDb.SetOutboxMessageStatus(pGuid, cSENDING);
      lDb.SetOutboxTotalDone(pGuid, 0);

  {start the sending process}
      For lCont := pFileList.Count - 1 Downto 0 Do
      Begin
        If lFileName <> '' Then
        Begin
          inc(lCont2);
          Try
            lDb.SetOutboxTotalDone(pGuid, Trunc(((lCont2 + 1) / lTotal) * 100));
          Except
          End;

          lFileName := lFileName + ',' + pFileList[lCont];
          lFileSize := lFileSize + _FileSize(pFileList[lCont]);
          pFileList.Delete(lCont);

      {check the size of the email}
          If (pFileList.Count = 0) Or (lFileSize >= MBYTE) Then
          Begin
            Result := TDSRMail.SendMsg(pFrom, pTo_, pSubj, '', lFileName);
            If Result <> S_Ok Then
              Break;

            lFileName := '';
            lFileSize := 0;

            Sleep(1000);
          End; {If (pFileList.Count = 0) Or (lFileSize >= MBYTE) Then}
        End {If lFileName <> '' Then}
        Else
        Begin
          inc(lCont2);
          Try
            lDb.SetOutboxTotalDone(pGuid, Trunc(((lCont2 + 1) / lTotal) * 100));
          Except
          End;

          lFileName := pFileList[lCont];
          lFileSize := lFileSize + _FileSize(pFileList[lCont]);
          pFileList.Delete(lCont);
      {check the size of the email}
          If (pFileList.Count = 0) Or (lFileSize >= MBYTE) Then
          Begin
            Result := TDSRMail.SendMsg(pFrom, pTo_, pSubj, '', lFileName);
            If Result <> S_Ok Then
              Break;

            lFileName := '';
            lFileSize := 0;

            Sleep(1000);
          End; {If (lFilesToSend.Count = 0) Or (lFileSize >= MBYTE) Then}
        End; {begin}

        If (lCont Mod 5) = 0 Then
          Sleep(1);
      End; {For lCont := lFilesToSend.Count - 1 Downto 0 Do}

      lDb.Free;
    End
    Else
      Result := cDBERROR;
  End
  Else
    Result := cNOFILESTOBESENT;
End;

{-----------------------------------------------------------------------------
  Procedure: PrepareFilesAndSendCIS
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRExport.PrepareFilesAndSendCIS(pMessageInfo: TMessageInfo;
  pXmlList: TXMLList): Longword;
Var
  lXml: WideString;
  lCont: Integer;
  lOutputDir,
    lExCode, lCompGuid,
    lFileName: String;
  lXmlDoc: TXMLDoc;
  lXmlHeader: TXMLHeader;
  lSystem: TSystemConf;
  lLog: _Base;
  lDb: TADODSR;
Begin
  _CallDebugLog('Start CIS sending...');

  Result := S_OK;
  lSystem := TSystemConf.Create;
  lLog := _Base.Create;

  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On e: exception Do
      lLog.DoLogMessage('TDSRExport.PrepareFilesAndSendCIS', 0,
        'Error connecting the Database. Error: ' + e.message);
  End;

  {check database connectivity}
  If Assigned(lDb) And lDb.Connected Then
  Begin
    lLog.ConnectionString := lDb.ConnectionString;

    With pMessageInfo, pXmlList Do
    Begin
      {check the list}
      If Count > 0 Then
      Begin
        lOutputDir := IncludeTrailingPathDelimiter(lSystem.OutboxDir +
          GUIDToString(Guid));

      {check the new directory}
        If _DirExists(lOutputDir) Then
        Try
          _DelDirFiles(lOutputDir);
        Finally
          _DelDir(lOutputDir);
        End;

        ForceDirectories(lOutputDir);

        Try
          lXmlDoc := TXMLDoc.Create;
          lExCode := lDb.GetExCode(Company_Id);
          lCompGuid := lDb.GetCompanyGuid(Company_Id);

          {process the list of xmls}
          For lCont := 0 To Count - 1 Do
          Try
            lXmlDoc.Clear;
            lXml := '';
            Try
              lXml := Items[lCont].XML;
            Except
              lXml := '';
            End;

          { try to load the xml or a file system}
            If _FileSize(lXml) > 0 Then
              lXmlDoc.Load(lXml)
            Else
              lXmlDoc.LoadXml(lXml);

          { verify the xml integrity. the dsr can only send a readable xml}
            If lXmlDoc.Doc.xml <> '' Then
            Begin
              FillChar(lXmlHeader, SizeOf(TXmlHeader), #0);
              _GetXMLHeader(lXmlDoc, lXmlHeader);

              _FillXMLHeader(lXmlHeader, Guid, lCont + 1, Count, From, To_,
                lDb.GetExportPluginLink(Items[lCont].Pack_Id), 0);

            { set xml packet header...}
              If _SetXmlHeader(lXmlDoc, lXmlHeader) Then
              Begin
                If lXmlDoc.Doc.xml <> '' Then
                Begin
                  lFileName := lOutputDir + GUIDToString(_CreateGuid) + cXmlExt;

                {save the file...}
                  lXml := lXmlDoc.ApplyEncondeEx(lXmlDoc.Doc.xml, cMSXMLUTF8);
                  lXML := StringReplace(lXml, Chr(9), '', [rfReplaceAll]);
                  lXML := StringReplace(lXML, #13, '', [rfReplaceAll]);
                  lXML := StringReplace(lXML, #10, '', [rfReplaceAll]);

                  Try
                    //lXmlDoc.Save(lFileName);
                    _CreateXmlFile(lFileName, lXMl);
                  Except
                    On E: exception Do
                    Begin
                      Result := cFILEANDXMLERROR;
                      lLog.DoLogMessage('TDSRExport.PrepareFilesAndSendCIS', Result,
                        'Error saving CIS XML file. Error: ' + e.Message);
                    End; {begin}
                  End; {try}
                End {If lXmlDoc.Doc.xml <> '' Then}
                Else
                Begin
                  Result := cINVALIDXML;
                  Break;
                End; {else begin}
              End {If _SetXmlHeader(lXmlDoc, lXmlHeader) Then}
              Else
              Begin
                Result := cSETTINGXMLHEADERERROR;
                Break;
              End; {else begin}
            End {If lXmlDoc.Doc.xml <> '' Then}
            Else
            Begin
              Result := cINVALIDXML;
              Break;
            End; {else begin}

            If _FileSize(lXml) > 0 Then
              _DelFile(lXml);

            {to avoid 100% CPU}
            If (lCont Mod 5) = 0 Then
              Sleep(1);
          Except
            On e: exception Do
            Begin
              Result := cERROR;
              lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSendCIS', Result,
                'An exception has ocurred while processing files. Error: ' +
                e.message, True, True);
              Break;
            End; {begin}
          End; {For lCount := 0 To lTotal - 1 Do}

          FreeAndNil(lXmlDoc);

          {send cis msg using dsrmail object which includes a function to call the sender using the cis outgoing guid information}
          If Result = S_OK Then
          Begin
            Result := TDSRMail.SendCISMsg(From, To_, Subject, lFileName);

            If Result = S_OK Then
              lDb.SetOutboxMessageStatus(pMessageInfo.Guid, cPENDING);
          End;
        Except
          On e: exception Do
          Begin
            Result := cERROR;
            lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSendCIS', Result,
              'An error has occurred while processing CIS XML messages. Error: '
              + e.message, True, True);
          End;
        End {try..except}
      End
      Else
        Result := cNODATAEXPORTED;
    End; {With pMessageInfo, pXmlList Do}
  End; {if Assigned(lDb) then}

  If Result <> S_OK Then
    lLog.DoLogMessage('TDSRSERVER.PrepareFilesAndSendCIS', Result, '', True, True);

  If Assigned(lSystem) Then
    FreeAndNil(lSystem);

  If Assigned(lDb) Then
    FreeAndNil(lDb);

  If Assigned(lLog) Then
    FreeAndNil(lLog);

  _CallDebugLog('End of CIS sending');
End;

End.

