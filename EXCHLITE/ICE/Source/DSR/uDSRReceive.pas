{-----------------------------------------------------------------------------
 Unit Name: uDSRReceive
 Author:    vmoura
 Purpose:
 History:
-----------------------------------------------------------------------------}
Unit uDSRReceive;

Interface

Uses Windows, Sysutils, Classes;

Type

  {this class expose a receive function that loads an e-mail parameters and try to process its attachments.
}

  TDSRReceive = Class
  Public
    //Class Function Receive(Const pSubj, pSender, pTo, pFiles: WideString): LongWord;
    Class Function Receive(Const pSubj, pSender, pTo: WideString; pFiles: TStringList): LongWord;
  End;

Implementation

Uses StrUtils,

  uConsts, uBaseClass, uAdoDsr, uDSRSettings, uDSRHistory,
  uDSRFileFunc, uCommon {, uExFunc}
  ;

{ TDSRReceive }

{-----------------------------------------------------------------------------
  Procedure: Receive
  Author:    vmoura

  this function does as follow

  1) Get the list of files from an e-mail
  2) get the header of the files and verifu integrity
  3) save files in the right directory
  4) update database
-----------------------------------------------------------------------------}

//Class Function TDSRReceive.Receive(Const pSubj, pSender, pTo, pFiles: WideString):LongWord;
Class Function TDSRReceive.Receive(Const pSubj, pSender, pTo: WideString; pFiles: TStringList):LongWord;
Var
//  lXml: WideString; {extracted xml}
  lCont: Integer; {counter}
//  lStr: TStringlist; {receive the files}
  lInbox, {inbox directory}
    lFileName: String; {file to be written}
  lDSRHeader: TDSRFileHeader; {dsr header}
  lCompanyId, {company id}
    lPackId: Integer; {package id}
  lDb: TADODSR; {database connection}
  lLog: _Base; {logging}
  lTempGuid, {temporary message identification}
    lGuid: TGuid; {file log}
//  lSyncReq: TSyncRequest; {sync request structure}
  lSender: String; {the sender of the message}
  lUpdt: TDBOption;
Begin
  { BI 1. Comms plugin receives packet from remote source.
   BI 2. Comms plugin passes packet to DSR.}
  Result := S_OK;
  lLog := _Base.Create;

  _CallDebugLog('receive starting');

  If Lowercase(Trim(pSubj)) = Lowercase(Trim(cCLIENTSYNCEMAILTEST)) Then
  Begin
    Result := S_OK;
    _LogMSG('TDSRReceive.Receive :- E-Mail Test received from ' + pSender + ' to ' + pTo);
  End
  Else
  Begin
    fillchar(lTempGuid, Sizeof(Tguid), 0);

    If (pSubj <> '') {And (pSender <> '')} And (pTo <> '') And (pFiles <> nil) Then
    Begin

      //lStr := TStringlist.Create;
      lSender := ifthen(Trim(pSender) <> '', pSender, cUNKNOWMAIL);

(*      Try
        If pFiles <> '' Then
          lStr.CommaText := pFiles;
      Except
        on e:exception do
          _LogMSG('DSRReceive.Receive :- Error loading e-mail files to process. Error: ' + e.Message);
      End;*)

      lInbox := IncludeTrailingPathDelimiter(_GetApplicationPath + cINBOXDIR);

      {check number of files received}
      //If lStr.Count > 0 Then
      If pFiles.Count > 0 Then
      Begin
        Try
    { if not the .ini file is set, the usual computer will be the server...}
          lDb := TADODSR.Create(_DSRGetDBServer);
        Except
          On E: Exception Do
          Begin
            Result := cDBERROR;
            lLog.DoLogMessage('TReceive.Receive', cDBERROR, 'Error: ' + E.MEssage);
          End; {begin}
        End; {try}

        Try
          If (lDb <> Nil) Then
          Begin
            If lDb.Connected Then
            Begin
          {create a temporary inbox entry}
              lDb.UpdateInBox(lTempGuid, 0, pSubj, pSender, pTo, 0, 0,
                cRECEIVINGDATA, ord(rmNormal), dbDoAdd);

              lLog.ConnectionString := lDb.ConnectionString;

      {the mail msg can hold one or more files}
              //For lCont := 0 To lStr.Count - 1 Do
              For lCont := 0 To pFiles.Count - 1 Do
              Begin
                _CallDebugLog('receive processing file ' + inttostr(lCont));

            {verify the file extenstion}
                //If _ValidExtension(lStr[lCont]) Then
                If _ValidExtension(pFiles[lCont]) Then
                Begin
                  Result := S_OK;
                  FillChar(lDSRHeader, SizeOF(TDSRFileHeader), 0);

                  //_GetHeaderFromFile(lDSRHeader, lStr[lCont]);
                  _GetHeaderFromFile(lDSRHeader, pFiles[lCont]);

      { verify header details}
                  If (lDSRHeader.Total > 0) And
                    _IsValidDSRVersion(lDSRHeader.Version, CommonBit {cDSRVERSION}) And
                    (lDSRHeader.Mode In [Ord(rmNormal), Ord(rmSync), Ord(rmBulk),
                    Ord(rmDripFeed)]) And _IsValidGuid(Trim(lDSRHeader.BatchId))
                      Then
                  Begin
                    FillChar(lGuid, Sizeof(TGuid), 0);
                    Try
                      lGuid := StringToGUID(Trim(lDSRHeader.BatchId));
                    Except
                    End;

             {process only xml data here}
                    If (lDSRHeader.Flags = ord(mtData)) Then
                    Begin
                      lCompanyId := 0;

        { BI 3. DSR saves packet to local file system storage.}
                      If lDSRHeader.SplitTotal > 0 Then
                        lFileName := lInbox + lDSRHeader.BatchId + '\' +
                          inttostr(lDSRHeader.Order) + '.' + FormatFloat('000',
                          lDSRHeader.Split)
                      Else
                        lFileName := lInbox + lDSRHeader.BatchId + '\' +
                          inttostr(lDSRHeader.Order) + cXmlExt;

                      Try
                        ForceDirectories(ExtractFilePath(lFileName));
                      Except
                      End;

                    {copy file from temp directory to the inbox\guid directory}
                      //CopyFile(pChar(lStr[lCont]), pChar(lFileName), False);
                      CopyFile(pChar(pFiles[lCont]), pChar(lFileName), False);

                      Sleep(1);

        { if there are more files, it should try to combine those files into the original xml}
                      If lDSRHeader.SplitTotal > 0 Then
                        If _CombineFiles(lFileName, ChangeFileExt(lFileName,
                          cXMLEXT)) Then
                          lFileName := ChangeFileExt(lFileName, cXMLEXT);

    {BI 4. DSR writes entry into ICE database inbox table, using batch ID,
     batch order number, and total batch items values, including message type and other relevant information.}
                      If _FileSize(lFileName) > 0 Then
                      Begin

                      {check the xml from the file... if not valid, delete it and the
                      mail process will start asking for the missing file...}
                        Try
                          If _GetXmlFromFile(lFileName) = '' Then
                            _DelFile(lFileName);
                        Except
                          On e: exception Do
                          Begin
                            Result := cINVALIDXML;
                            _LogMSG('TReceive.Receive :- Error loading xml from file. Error: '
                              + e.Message);
                            _DelFile(lFileName);
                          End;
                        End; {try}

                     {when the client request to import the plugin link will be used to see what kind of import plugin to use}
                        lPackId := 0;

                        {check company security id...}
                        If lDSRHeader.Mode In [Ord(rmBulk), Ord(rmDripFeed)] Then
                          lCompanyId := lDb.GetCompanyIdbyGuid(Trim(lDSRHeader.CompGuid));

                    { the mail already is in the database }
                        If lDb.SearchInboxEntry(lGuid) > 0 Then
                          lUpdt := dbDoUpdate
                        Else
                          lUpdt := dbDoAdd;

              {check whether this message had already been processed. if not, check if the file or
              batch is completed, otherwise, add new entry}
                        If _CheckFileComplete(lDSRHeader, lFileName) And
                          _CheckBatchComplete(lDSRHeader, ExtractFilePath(lFileName))
                          Then
                        Begin
                          lDb.UpdateInBox(lGuid, lCompanyId, pSubj, pSender, pTo,
                            lPackId, lDSRHeader.Total, cREADYIMPORT,
                            ord(lDSRHeader.Mode), lUpdt);
                          lDb.SetInboxTotalDone(lGuid, 100);
                        End
                        Else
                          lDb.UpdateInBox(lGuid, lCompanyId, pSubj, pSender, pTo,
                            lPackId, lDSRHeader.Total, cRECEIVINGDATA,
                            ord(lDSRHeader.Mode), lUpdt);

                        Try
                          lDb.SetInboxTotalDone(lGuid,
                            Trunc((_CountFiles(ExtractFilePath(lFileName)) /
                              lDSRHeader.Total) * 100));
                        Except
                        End;

                        {delete temp data}
                        lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0,
                          dbDoDelete);
                      End
                      Else
                        Result := cINVALIDFILE;
                    End
                  End {If _IsValidGuid(lDSRHeader.Guid) And (lDSRHeader.Total > 0) And}
                  Else
                    Result := cINVALIDPARAM;

    { BI 5. This process continues until all packets for a batch have been received.
           BI a. If any packets are missing or unreadable, the DSR will request a retransmission by sending a NACK
                 status message for the given batch ID and order number. To the destination.
           BI b.For all packets that are read and saved to file system storage, the DSR will send an ACK status message
                 to the remote source, for the particular packet ID.
      BI 6. Once all packets are successfully received, DSR marks all inbox entries for this batch
                 as 'ready for import'.}

                  If Result <> S_OK Then
                  Try
                    lLog.DoLogMessage('TDSRReceive.Receive', Result,
                      ' Error receiving attachment ' + pFiles[lCont], True, True);

                    lLog.DoLogMessage('TDSRReceive.Receive', Result,
                      ' Guid: ' + lDSRHeader.BatchId + ' File: ' + pFiles[lCont]);
                  Except
                  End;
                End {If (ExtractFileExt(lStr[lCont]) = cXMLEXT) Or}
                Else
                Begin
                  Result := cINVALIDFILE;
                  Try
                    lLog.DoLogMessage('TDSRReceive.Receive', Result,
                      ' Error receiving attachment. Invalid file: ' + pFiles[lCont],
                      True, True);
                  Except
                  End;

                  If Not _ValidExtension(pFiles[lCont]) Then
                    _DelFile(pFiles[lCont])
                End; {begin}

                If (lCont Mod 2) = 0 Then
                  Sleep(1);
              End; {For lCont := 0 To lStr.Count - 1 Do}

          {delete/update temp data}
              If Not _IsValidGuid(lGuid) And (Not (ldb.SearchInboxEntry(lGuid) > 0))
                Then
                lLog.DoLogMessage('TDSRReceive.Receive', Result,
                  'Error downloading e-mail subject: ' + pSubj);

          {delete temp entry}
              lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);
            End
            else
               Result := cDBERROR;
          End
          Else
            Result := cDBERROR;
        Except
          On E: Exception Do
          Begin
            Result := cERROR;
            lLog.DoLogMessage('TDSRReceive.Receive', Result,
              'Error processing mail. Error: ' + e.message, True, True);

          {delete temp entry}
            if Assigned(lDb) then
              if lDb.Connected then
               lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);
          End; {try..except}
        End; {If lStr.Count > 0 Then}
      End
      Else
        Result := cNOFILESRECEIVED;
    End
    Else
      Result := cINVALIDPARAM;
  End; {else begin}

  If Result <> S_OK Then
    lLog.DoLogMessage('TDSRReceive.Receive', Result,
      'Error Processing e-mail. Subject: ' + pSubj + '. Sender: ' + pSender +
      '. To: ' + pTo +
      IfThen(pFiles <> Nil, '. Nro of Files: ' + inttostr(pFiles.Count),
        '. No files received.') , True, True);

  If Assigned(lLog) Then
    FreeAndNil(lLog);

(*  If Assigned(lStr) Then
    FreeAndNil(lStr);*)

  If Assigned(lDb) Then
  Begin
    Try
      If lDb.Connected Then
        lDb.UpdateInBox(lTempGuid, 0, '', '', '', 0, 0, 0, 0, dbDoDelete);
    Except
    End;

    FreeAndNil(lDb);
  End; {If Assigned(lDb) Then}

  _CallDebugLog('receive end');
End;

End.

