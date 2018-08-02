{-----------------------------------------------------------------------------
 Unit Name: uCISReceiving
 Author:    vmoura
 Purpose:
 History:

 the dsr will load this dll but will not dispose it during its processing....
 it will call checknow function and load items that have not been processed yet
 so, the callback can keep checking GGW until get any kind of response
-----------------------------------------------------------------------------}
Unit uCISReceiving;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, CISIncoming_TLB, StdVcl, DSRIncoming_TLB,
  Classes,

  {fbi components}
  InternetFiling_TLB,

  uBaseClass, uInterfaces, uCISCallBack

  ;

Type
  TCISReceiving = Class(TAutoObject, ICISReceiving, IDSRIncomingSystem)
  Private
    fLog: _Base;
    fCallBackList: Tlist;
    fPosting: _Posting;

    Procedure ProcessGGWPendingMessages;
    Procedure ClearFinishedCallBacks;
    Procedure Deleterequest(pCIS: TCISMessage);
    Function CreatePosting: _Posting;
    Procedure EndPolling(Const pGuidPoll: String);
  Protected
    Procedure CheckNow; Safecall;
    Function Get_Authentication: WordBool; Safecall;
    Function Get_IncomingPort: Integer; Safecall;
    Function Get_IncomingServer: WideString; Safecall;
    Function Get_MailBoxName: WideString; Safecall;
    Function Get_MailBoxSeparator: WideString; Safecall;
    Function Get_Password: WideString; Safecall;
    Function Get_ServerType: WideString; Safecall;
    Function Get_UserName: WideString; Safecall;
    Function Get_YourName: WideString; Safecall;
    Procedure Set_Authentication(Value: WordBool); Safecall;
    Procedure Set_IncomingPort(Value: Integer); Safecall;
    Procedure Set_IncomingServer(Const Value: WideString); Safecall;
    Procedure Set_MailBoxName(Const Value: WideString); Safecall;
    Procedure Set_MailBoxSeparator(Const Value: WideString); Safecall;
    Procedure Set_Password(Const Value: WideString); Safecall;
    Procedure Set_ServerType(Const Value: WideString); Safecall;
    Procedure Set_UserName(Const Value: WideString); Safecall;
    Procedure Set_YourName(Const Value: WideString); Safecall;
    Function Get_YourEmail: WideString; Safecall;
    Procedure Set_YourEmail(Const Value: WideString); Safecall;

  Public
    Procedure Initialize; Override;
    Destructor Destroy; Override;
  End;

Implementation

Uses ComServ, Sysutils,

  uConsts, uCommon, uDSRSettings, uAdoDSR

  ;

{-----------------------------------------------------------------------------
  Procedure: CheckNow
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.CheckNow;
Begin
  ProcessGGWPendingMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor TCISReceiving.Destroy;
Var
  lCont: Integer;
  lObj: TCISCallBack;
Begin
  If Assigned(fLog) Then
    fLog.Free;

  For lCont := fCallBackList.Count - 1 Downto 0 Do
    If fCallBackList[lCont] <> Nil Then
    Begin
      lObj := TCISCallBack(fCallBackList[lCont]);
      If Assigned(lObj) Then
      Begin
        EndPolling(lObj.PollGuid);
        lObj.Free;
      End; {If Assigned(lObj) Then}
    End; {if fCallBackList[lCont] is TCISCallBack then}

  FreeAndNil(fCallBackList);

  CoUninitialize;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.Initialize;
Begin
  Inherited;
  CoInitialize(Nil);

  fLog := _Base.Create;
  {list of callbacks objects}
  fCallBackList := Tlist.Create;

  Try
    fPosting := CreatePosting;
  Except
    On e: exception Do
      _LogMSG('TCISReceiving.Initialize :- Error creating CIS Object. Error: ' +
        e.Message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessGGWPendingMessages
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.ProcessGGWPendingMessages;
Var
  lCISDetail: Olevariant;
  lPend: Olevariant; {get ggw pending messages}
  lRes: Longword;
  lCont, lTotal: Integer;
  lMsg: TMessageInfo; {outbox message}
  lCisMsg: TCISMessage; {cis message info}
  lCallBack: TCISCallBack; {fbi callback object}
  lDb: TADODSR; {db}
  lRedGuid: String; {guid for redirection polling}
  lAttempt: Integer;
//lxml: widestring;
Begin
  ClearFinishedCallBacks;

  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TCISReceiving.ProcessGGWPendingMessages :- CIS Incoming database connection error: '
        + E.MEssage);
  End; {try}

  {check database connection}
  If Assigned(lDb) And lDb.Connected Then
  Begin
    fLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);
    lPend := lDb.GetOutboxMessages(-1, 0, cCISSENT, 0, 0, lRes, False);
    lTotal := _GetOlevariantArraySize(lPend);

    {check the result}
    If lTotal > 0 Then
    Begin
      If Assigned(fPosting) Then
      Begin
        {loop on pending messages. It will create one call back for each message
        with a pending status}
        For lCont := 0 To lTotal - 1 Do
        Begin
          lMsg := _CreateOutboxMsgInfo(lPend[lCont]);
          If Assigned(lMsg) Then
          Begin
            {load a cis message detail}
            lCISDetail := lDb.GetCISMessageDetail(lMsg.Guid);

            {get the first record}
            If _GetOlevariantArraySize(lCISDetail) > 0 Then
              lCisMsg := _CreateCISMsgInfo(lCISDetail[0]);

            If Assigned(lCisMsg) Then
            Begin
              lCisMsg.CompanyID := lMsg.Company_Id;
              lCallBack := Nil;
              Try
                lCallBack := TCISCallBack.Create;
              Except
                On E: exception Do
                Begin
                  fLog.DoLogMessage('TCISReceiving.ProcessGGWPendingMessages',
                    cOBJECTNOTAVAILABLE, 'CIS Callback object is not available.');
                  fLog.DoLogMessage('TCISReceiving.ProcessGGWPendingMessages',
                    cOBJECTNOTAVAILABLE, 'Error: ' + e.message);
                End;
              End;

              If lCallBack <> Nil Then
              Begin
                {copy parameters to callback}
                lCallBack.CISMsg.Assign(lCisMsg);

                {not setting this variable will call the delete request using the test node }
                lCallBack.CISMsg.UseTestGateway := lDb.GetSystemValue(cUSECISTESTPARAM) = '1';

                With fPosting, lCisMsg Do
                Begin
                  lAttempt := 0;
//                lXml := fPosting.RequestListCom(CorrelationID, CISClassType, true, Redirection);
//                _CreateXmlFile('c:\resultlist.xml', lXml);

//                  lRedGuid := BeginPolling(lCallBack, CorrelationID, CISClassType,
//                    True, Redirection);

                  {it seems that the beginpolling is not only based on the redirection url to work
                  it also uses the usetestgateway to create the usetestgateway node which
                  in live is causing the user not be receiving the xmls back from the gateway}
                  lRedGuid := BeginPolling(lCallBack, CorrelationID, CISClassType,
                    lDb.GetSystemValue(cUSECISTESTPARAM) = '1', Redirection);

                  lCallBack.PollGuid := lRedGuid;

                  Repeat
                    _Delay(1000);
                    Inc(lAttempt);
                  Until (lCallBack.URL <> '') Or (lAttempt > 60);

                  If lCallBack.URL <> '' Then
                    RedirectPolling(lRedGuid, lCallBack.URL)
                  Else
                    EndPolling(lRedGuid);
                End; {With fPosting, lCisMsg Do}

                fCallBackList.Add(lCallBack);
              End; {if lCallBack <> nil then}

              FreeAndNil(lCisMsg);
            End; {if Assigned(lCisMsg) then}

            FreeAndNil(lMsg);
          End; {if Assigned(lMsg) then}
        End; {for lCont:= 0 to lTotal - 1 do}
      End
      Else
        fLog.DoLogMessage('TCISReceiving.ProcessGGWPendingMessages',
          cOBJECTNOTAVAILABLE, 'CIS object is not available.')
    End; {if _GetOlevariantArraySize(lPend) > 0 then}

    lDb.Free;
  End {if Assigned(fDb) and fDb.Connected then}
  Else
    _LogMSG('TCISReceiving.ProcessGGWPendingMessages :- Could not process GGW Pending messages. Database is not connected...')
End;

{-----------------------------------------------------------------------------
  Procedure: ClearFinishedCallBacks
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.ClearFinishedCallBacks;
Var
  lCont: Integer;
  lObj: TCISCallBack;
Begin
  For lCont := fCallBackList.Count - 1 Downto 0 Do
    If fCallBackList[lCont] <> Nil Then
      If TCISCallBack(fCallBackList[lCont]).Finished Then
      Try
        lObj := TCISCallBack(fCallBackList[lCont]);

        {leave 1sec to be able to finish the processing in case the object is trying to save the returned file...}
        _Delay(1000);

        If Assigned(lObj) Then
        Begin
          Deleterequest(lObj.CISMsg);
          _Delay(1000);
          EndPolling(lObj.PollGuid);
          _Delay(1000);
          lObj.Free;
        End; {If Assigned(lObj) Then}
      Finally
        fCallBackList.Delete(lCont);
      End; {if TCISCallBack(fCallBackList[lCont]).Finished then}
End;

{-----------------------------------------------------------------------------
  Procedure: Deleterequest
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.Deleterequest(pCIS: TCISMessage);
Begin
  If Assigned(fPosting) Then
    With pCis, fPosting Do
      //Delete(CorrelationID, CISClassType, True, cGGWCONFIG)
      //Delete(CorrelationID, CISClassType, UseTestGateway, cGGWCONFIG)
      if UseTestGateway then
        Delete(CorrelationID, CISClassType, UseTestGateway, cGGWCONFIGTEST)
      else
        Delete(CorrelationID, CISClassType, UseTestGateway, cGGWCONFIGLIVE)
  Else
    _LogMSG('TCISCallBack.Deleterequest :- Posting COM object not available.');
End;

{-----------------------------------------------------------------------------
  Procedure: CreatePosting
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TCISReceiving.CreatePosting: _Posting;
Begin
  Try
    Result := CoPosting.Create;
  Except
    On E: exception Do
    Begin
      Result := Nil;
      _LogMSG('TCISReceiving.CreatePosting :- CIS Incoming object error: '
        + E.MEssage);
    End; {begin}
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: EndPolling
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TCISReceiving.EndPolling(Const pGuidPoll: String);
Begin
  If Assigned(fPosting) Then
  Begin
    Try
      fPosting.EndPolling(pGuidPoll);
    Except
    End;
  End
  Else
    _LogMSG('TCISReceiving.EndPolling :- Posting COM object not available.');
End;

Function TCISReceiving.Get_Authentication: WordBool;
Begin

End;

Function TCISReceiving.Get_IncomingPort: Integer;
Begin

End;

Function TCISReceiving.Get_IncomingServer: WideString;
Begin

End;

Function TCISReceiving.Get_MailBoxName: WideString;
Begin

End;

Function TCISReceiving.Get_MailBoxSeparator: WideString;
Begin

End;

Function TCISReceiving.Get_Password: WideString;
Begin

End;

Function TCISReceiving.Get_ServerType: WideString;
Begin

End;

Function TCISReceiving.Get_UserName: WideString;
Begin

End;

Function TCISReceiving.Get_YourName: WideString;
Begin

End;

Procedure TCISReceiving.Set_Authentication(Value: WordBool);
Begin

End;

Procedure TCISReceiving.Set_IncomingPort(Value: Integer);
Begin

End;

Procedure TCISReceiving.Set_IncomingServer(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_MailBoxName(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_MailBoxSeparator(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_Password(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_ServerType(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_UserName(Const Value: WideString);
Begin

End;

Procedure TCISReceiving.Set_YourName(Const Value: WideString);
Begin

End;

Function TCISReceiving.Get_YourEmail: WideString;
Begin

End;

Procedure TCISReceiving.Set_YourEmail(Const Value: WideString);
Begin

End;

Initialization
  TAutoObjectFactory.Create(ComServer, TCISReceiving, Class_CISReceiving,
    ciMultiInstance, tmApartment);
End.

