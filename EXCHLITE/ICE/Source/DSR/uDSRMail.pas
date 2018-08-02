{-----------------------------------------------------------------------------
 Unit Name: uDSRMail
 Author:    vmoura

 this unit send messages, acks and nacks and also process the e-mail from client/practice

-----------------------------------------------------------------------------}
Unit uDSRMail;

Interface
                
Uses
  Windows, Sysutils, Classes, uConsts
  ;

Type

  TDSRMail = Class
  Public
    Class Function SendACK(pGuid: TGuid; Const pFrom, pTo_: String; pTotal:
      Longword; pRequestMode: TRecordMode; Const pExCode: String = ''; Const
      pCompGuid: String = ''; Const pMsg: ShortString = ''): Longword;

    Class Function SendNACK(pMsgGuid: TGuid; Const pFrom, pTo_: String; pOrder:
      Longword; pFlag: Word; Const pExCode: String = ''; Const pCompGuid: String
      = ''; Const pReason: String = ''): Longword;

    Class Function SendMsg(Const pUserFrom, pUserTo, pSubject, pBody, pFiles: WideString;
      Const pGUID: String = ''): Longword;

    Class Function SendCISMsg(Const pUserFrom, pUserTo, pSubject, pFiles: String):
      Longword;
  End;

Implementation

Uses ComObj,
  DSROutgoing_TLB, {CISOutgoing_TLB,}
  uSystemConfig, uExFunc, uAdoDSR, uInterfaces, uBaseClass, uDSRHistory,
  uCommon;

{-----------------------------------------------------------------------------
  Procedure: SendACK
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRMail.SendACK(pGuid: TGuid; Const pFrom, pTo_: String;
  pTotal: Longword; pRequestMode: TRecordMode; Const pExCode: String = ''; Const
  pCompGuid: String = ''; Const pMsg: ShortString = ''): Longword;
Var
  lAck: TACK;
  lDSRHeader: TDSRFileHeader;
  //lFile: TFileStream;
  lFile: TMemoryStream;
  lAux: String;
Begin
  FillChar(lAck, SizeOF(TAck), 0);
  FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
  {fill ack header}
  With lAck Do
  Begin
    Total := pTotal;
    Mode := Ord(pRequestMode);
    Msg := pMsg;
    MailFrom := pFrom;
    MailTo := pTo_;
  End; {With lAck Do}

  {fill message header}
  With lDSRHeader Do
  Begin
    ProductType := Ord(_ExProductType);
    Version := CommonBit; // cDSRVERSION;
    BatchId := GUIDToString(pGuid);
    ExCode := pExCode;
    CompGuid := pCompGuid;
    Order := 1;
    Total := 1;
    Split := 0;
    SplitTotal := 0;
    CheckSum := 0;
    SplitCheckSum := 0;
    Flags := Ord(mtACK);
    Mode := Ord(rmNormal);
  End; {With lDSRHeader Do}

  lAux := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR) +
    GuidtoString(_CreateGuid) + cACKEXT;

  //lFile := TFileStream.Create(lAux, fmCreate);
  lFile := TMemoryStream.Create;
  lFile.Write(lDSRHeader, SizeOf(TDSRFileHeader));
  lFile.Write(lAck, SizeOf(TACK));
  lFile.SaveToFile(lAux);
  FreeAndNil(lFile);

  Try
    Result := SendMsg(pFrom, pTo_, cACKSUBJECT + ' ' + DateTimeToStr(Now), '', lAux);
  Finally
    _DelFile(lAux);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SendNACK
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRMail.SendNACK(pMsgGuid: TGuid; Const pFrom, pTo_: String;
  pOrder: Longword; pFlag: Word; Const pExCode: String = ''; Const pCompGuid:
  String = ''; Const pReason: String = ''): Longword;
Var
  lNAck: TNACK;
  lDSRHeader: TDSRFileHeader;
  //lFile: TFileStream;
  lFile: TMemoryStream;
  lAux: String;
Begin
  FillChar(lNack, SizeOF(TNACK), 0);
  FillChar(lDSRHeader, SizeOf(TDSRFileHeader), 0);
  {fill the nack header}
  With lNack Do
  Begin
    Flag := pFlag;
    Order := pOrder;
    Reason := pReason;
    MailFrom := pFrom;
    MailTo := pTo_;
  End; {With lNack Do}

  {fill the main msg header}
  With lDSRHeader Do
  Begin
    ProductType := Ord(_ExProductType);
    Version := CommonBit; // cDSRVERSION;
    BatchId := GUIDToString(pMsgGuid);
    ExCode := pExCode;
    CompGuid := pCompGuid;
    Order := 1;
    Total := 1;
    Split := 0;
    SplitTotal := 0;
    CheckSum := 0;
    SplitCheckSum := 0;
    Flags := Ord(mtNACK);
    Mode := Ord(rmNormal);
  End; {With lDSRHeader Do}

  lAux := IncludeTrailingPathDelimiter(_GetApplicationPath + cTEMPDIR) +
    GuidtoString(_CreateGuid) + cNACKEXT;

  //lFile := TFileStream.Create(lAux, fmCreate);
  lFile := TMemoryStream.Create;
  lFile.Write(lDSRHeader, SizeOf(TDSRFileHeader));
  lFile.Write(lNAck, SizeOf(TNACK));
  lFile.SaveToFile(lAux);
  FreeAndNil(lFile);

  Try
    Result := SendMsg(pFrom, pTo_, cNACKSUBJECT + ' ' + DateTimeToStr(Now), '', lAux);
  Finally
    _DelFile(lAux);
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
(*Class Function TDSRMail.SendMsg(Const pUserFrom, pUserTo, pSubject,
  pFiles: String; Const pGUID: String = ''): Longword;
Var
  lBody: String;
  lSystem: TSystemConf;
  lSend: IDSROutgoingSystem;
  lSenderGuid: String;
Begin
  Result := S_OK;
  lBody := cPIPE + _CreateGuidStr + cPIPE;
  lSystem := TSystemConf.Create;

  {sets the sender guids}
  If Trim(pGuid) <> '' Then
    lSenderGuid := Trim(pGuid)
  Else
    lSenderGuid := lSystem.OutgoingGuid;

  Try
    If _IsValidGuid(lSenderGuid) Then
    Begin
      Try
        lSend := CreateComObject(Stringtoguid(lSenderGuid)) As IDSROutgoingSystem;
      Except
        On e: exception Do
        Begin
          Result := cERROR;
          _LogMsg('TDSRMail.SendMsg :- Exception loading sender subsystem. Error: '
            + e.Message);
        End; {begin}
      End; {try}
    End {If _IsValidGuid(lSystem.OutgoingGuid) Then}
    Else
    Begin
      Result := cCOMMSLAYEROUTGOINGNOTAVAILABLE;
      _LogMSG('TDSRMail.SendMsg :- Invalid outgoing COM Guid "' +
        lSystem.OutgoingGuid + '"');
    End; {begin}

    {check outgoing com availability}
    If Assigned(lSend) Then
    Begin
      Try
        {send message with attachements files separeted by ","}
        Result := lSend.SendMsg(Trim(pUserFrom), Trim(pUserTo), Trim(pSubject),
          Trim(lBody), pFiles);
      Except
        On e: Exception Do
        Begin
          Result := cERROR;
          _LogMsg('TDSRMail.SendMsg :- Exception sending the e-mail. Error: ' +
            e.Message);
        End; {begin}
      End; {try}
    End; {If Assigned(lSend) Then}
  Finally
    lSend := Nil;
  End; {try}

  FreeAndNil(lSystem);
  Sleep(500);
End;*)

{-----------------------------------------------------------------------------
  Procedure: SendMsg
  Author:    vmoura
-----------------------------------------------------------------------------}
Class Function TDSRMail.SendMsg(Const pUserFrom, pUserTo, pSubject, pBody,
  pFiles: WideString; Const pGUID: String = ''): Longword;
Var
  lBody: String;
  lSystem: TSystemConf;
  lSend: IDSROutgoingSystem;
  lDb: TADODSR;
  lSenderGuid: String;
  lEacc: TEmailSystem;
  lDef: TEmailAccount;
  lLog : _base;
Begin
  Result := S_OK;
  if Trim(pBody) = '' then
    lBody := cPIPE + _CreateGuidStr + cPIPE;

  lSystem := TSystemConf.Create;
  lDb := nil;
  lLog := _Base.Create;
  lLog.ConnectionString := _DSRFormatConnectionString(lSystem.DBServer);

  Try
    lDb := TADODSR.Create(lSystem.DBServer);
  except
    on E:exception do
      lLog.DoLogMessage('TDSRMail.SendMsg', cDBERROR, 'Exception connecting the database. Error: ' + e.Message, true, true);
  end;

  {check database connection}
  if Assigned(lDb) then
  begin
    if lDb.Connected then
    begin
      {get default e-mail account. this account will indicate who is the sender plugin}
      lDef := lDb.GetDefaultAccount;
      if lDef <> nil then
      begin
        lEacc := lDb.GetEmailSystemById(lDef.EmailSystem_ID);

        if lEacc <> nil then
          lSenderGuid := lEacc.OutgoingGuid;

        if lSenderGuid = '' then
          lSenderGuid := Trim(pGUID);

        Try
          If _IsValidGuid(lSenderGuid) Then
          Begin
            Try
              lSend := CreateComObject(Stringtoguid(lSenderGuid)) As IDSROutgoingSystem;
            Except
              On e: exception Do
              Begin
                Result := cLOADINGEXPORTPLUGINERROR;
                lLog.DoLogMessage('TDSRMail.SendMsg', Result, 'Exception loading sender subsystem. Error: '
                  + e.Message, true, true);
              End; {begin}
            End; {try}
          End {If _IsValidGuid(lSystem.OutgoingGuid) Then}
          Else
          Begin
            Result := cCOMMSLAYEROUTGOINGNOTAVAILABLE;
            lLog.DoLogMessage('TDSRMail.SendMsg', Result, 'Invalid outgoing COM Guid "' +
              lSenderGuid + '"', true, true);
          End; {begin}

          {check outgoing com availability}
          If Assigned(lSend) Then
          Begin
            {fill send wrapper properties}
            lSend.ServerType := lDef.ServerType;
            lSend.OutgoingServer := lDef.OutgoingServer;
            lSend.UserName := lDef.UserName;
            lSend.Password := lDef.Password;
            lSend.OutgoingPort := lDef.OutgoingPort;
            lSend.Authentication := lDef.Authentication;
            lSend.SSLOutgoing := ldef.UseSSLOutgoingPort;
            lSend.OutgoingUsername := lDef.OutgoingUserName;
            lSend.OutgoingPassword := ldef.OutgoingPassword;
            lSend.YourName := lDef.YourName;
            lSend.YourEmail := lDef.YourEmail;
            lSend.To_ := Trim(pUserTo);
            lSend.Subject := Trim(pSubject);
            lSend.Body := lBody;
            lSend.Files := pFiles;  // separeted by comma

            Try
              {send message with attachements files separeted by ","}
              Result := lSend.SendMsg;
            Except
              On e: Exception Do
              Begin
                Result := cERROR;
                lLog.DoLogMessage('TDSRMail.SendMsg',Result, 'Exception sending the e-mail. Error: ' +
                  e.Message, true, true);
              End; {begin}
            End; {try}
          End; {If Assigned(lSend) Then}
        except
          on e:exception do
          begin
            Result := cError;
            lLog.DoLogMessage('TDSRMail.SendMsg',Result, 'Exception sending the e-mail. Error: ' +
              e.Message, true, true);
            lSend := Nil;
          end;
        End; {try}

        if lEacc <> nil then
          lEacc.Free;

        if lDef <> nil then
          lDef.Free;
      end
      else
      begin
        Result := cERROR;
        lLog.DoLogMessage('TDSRMail.SendMsg', Result,
          'No default sender found!', True, True);
      end;
    end {if lDb.Connected then}
    else
    begin
      Result := cCONNECTINGDBERROR;
      lLog.DoLogMessage('TDSRMail.SendMsg', Result,
        'Database connection failed. Server: ' + lSystem.DBServer, True, True);
    end;
  end {if Assigned(lDb) then}
  Else
  begin
    Result := cASSIGINGOBJECTERROR;
    lLog.DoLogMessage('TDSRMail.SendMsg', Result,
      'Error creating Database Object. Server: ' + lSystem.DBServer, True, True);
  end;

  FreeAndNil(lSystem);
  if lDb <> nil then
    lDb.Free;

  Sleep(500);
End;


{-----------------------------------------------------------------------------
  Procedure: SendCISMsg
  Author:    vmoura

  send a cis message using the cis class sending
-----------------------------------------------------------------------------}
Class Function TDSRMail.SendCISMsg(Const pUserFrom, pUserTo, pSubject,
  pFiles: String): Longword;
const
  CLASS_CISSending = '{D27B5042-0761-4F73-A233-9BAF7D01159D}';  
Begin
  Result := SendMsg(pUserFrom, pUserTo, pSubject, '', pFiles, CLASS_CISSending);
End;

End.

