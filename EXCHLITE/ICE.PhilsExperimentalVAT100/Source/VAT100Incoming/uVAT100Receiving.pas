{-----------------------------------------------------------------------------
 Unit Name: uVAT100Receiving
 Author:    Phil Rogers (based on uCISReceiving by vmoura)
 Purpose:
 History:

 The DSR will load this DLL but will not dispose of it during its processing.
 It will call the CheckNow function and load items that have not been processed
 yet.  The callback can keep checking GGW until it gets any kind of response
-----------------------------------------------------------------------------}
Unit uVAT100Receiving;

{$WARN SYMBOL_PLATFORM OFF}

Interface

Uses
  ComObj, ActiveX, VAT100Incoming_TLB, StdVcl, DSRIncoming_TLB,
  Classes,

  {fbi components}
  InternetFiling_TLB,

  uBaseClass, 
  uInterfaces, 
  uVAT100CallBack
  ;

Type
  TVAT100Receiving = Class(TAutoObject, IVAT100Receiving, IDSRIncomingSystem)
  Private
    fLog: _Base;
    fCallBackList: Tlist;
    fPosting: _Posting;

    Procedure ProcessGGWPendingMessages;
    Procedure ClearFinishedCallBacks;
    Procedure Deleterequest(pVAT100: TCISMessage);
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

Uses
  ComServ, 
  Sysutils,
  uConsts, 
  uCommon, 
  uDSRSettings, 
  uAdoDSR
  ;

{-----------------------------------------------------------------------------
  Procedure: CheckNow
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.CheckNow;
Begin
  ProcessGGWPendingMessages;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Destructor TVAT100Receiving.Destroy;
Var
  lCont: Integer;
  lObj: TVAT100CallBack;
Begin
  If Assigned(fLog) Then
    fLog.Free;

  For lCont := fCallBackList.Count - 1 Downto 0 Do
    If fCallBackList[lCont] <> Nil Then
    Begin
      lObj := TVAT100CallBack(fCallBackList[lCont]);
      If Assigned(lObj) Then
      Begin
        EndPolling(lObj.PollGuid);
        lObj.Free;
      End; {If Assigned(lObj) Then}
    End; {if fCallBackList[lCont] is TVAT100CallBack then}

  FreeAndNil(fCallBackList);

  CoUninitialize;
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Initialize
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.Initialize;
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
      _LogMSG('TVAT100Receiving.Initialize :- Failed to create FBI Posting object. Error: ' +
        e.Message);
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: ProcessGGWPendingMessages
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.ProcessGGWPendingMessages;
Var
  lVAT100Detail : Olevariant;
  lPend         : Olevariant; {get ggw pending messages}
  lRes          : Longword;
  lCont, lTotal : Integer;
  lMsg          : TMessageInfo; {outbox message}
  lVAT100Msg    : TCISMessage; {cis message info}
  lCallBack     : TVAT100CallBack; {fbi callback object}
  lDb           : TADODSR; {db}
  lRedGuid      : String; {guid for redirection polling}
  lAttempt      : Integer;
Begin
  ClearFinishedCallBacks;

  lDb := Nil;
  Try
    lDb := TADODSR.Create(_DSRGetDBServer);
  Except
    On E: Exception Do
      _LogMSG('TVAT100Receiving.ProcessGGWPendingMessages :- ' +
              'VAT100 Incoming database connection error: ' +
              E.MEssage);
  End; {try}

  {check database connection}
  If Assigned(lDb) And lDb.Connected Then
  Begin
    fLog.ConnectionString := _DSRFormatConnectionString(_DSRGetDBServer);

    // Outbox?
    lPend := lDb.GetOutboxMessages(-1, 0, cCISSENT, 0, 0, lRes, False);

    // Get the number of messages in the mailbox
    lTotal := _GetOlevariantArraySize(lPend);
    If lTotal > 0 Then
    Begin
      // Check that we have an FBI posting object.
      If Assigned(fPosting) Then
      Begin
        // Loop through the pending messages. Create one callback for each message
        //  with a pending status.
        For lCont := 0 To lTotal - 1 Do
        Begin
          // Create message info for this object.
          lMsg := _CreateOutboxMsgInfo(lPend[lCont]);
          If Assigned(lMsg) Then
          Begin
            // Load a VAT100 message detail from the database.
            lVAT100Detail := lDb.GetVAT100MessageDetail(lMsg.Guid);

            // Ensure that there's something to work with.
            If _GetOlevariantArraySize(lVAT100Detail) > 0 Then
            begin
              // _CreateCISMsgInfo used to avoid duplication of code.
              lVAT100Msg := _CreateCISMsgInfo(lVAT100Detail[0]);
            end;

            If Assigned(lVAT100Msg) Then
            Begin
              lVAT100Msg.CompanyID := lMsg.Company_Id;
              lCallBack := Nil;
              Try
                lCallBack := TVAT100CallBack.Create;
              Except
                On E: exception Do
                Begin
                  fLog.DoLogMessage('TVAT100Receiving.ProcessGGWPendingMessages',
                    cOBJECTNOTAVAILABLE, 'VAT100 Callback object is not available.');
                  fLog.DoLogMessage('TVAT100Receiving.ProcessGGWPendingMessages',
                    cOBJECTNOTAVAILABLE, 'Error: ' + e.message);
                End;
              End;

              If lCallBack <> Nil Then
              Begin
                // Created a callback, so copy the parameters in
                lCallBack.VAT100Msg.Assign(lVAT100Msg);

                // Not setting this variable will call the delete request to
                //  default to the test node.
                lCallBack.VAT100Msg.UseTestGateway := lDb.GetSystemValue(cUSEVAT100TESTPARAM) = '1';

                With fPosting, lVAT100Msg Do
                Begin
                  lAttempt := 0;

                  // It seems that the beginpolling is not only based on the redirection url to work
                  // it also uses the usetestgateway to create the usetestgateway node which
                  // in live is causing the user not be receiving the xmls back from the gateway}
                  lRedGuid := BeginPolling(lCallBack,
                                           CorrelationID,
                                           CISClassType, // Also used for VAT 100
                                           lDb.GetSystemValue(cUSEVAT100TESTPARAM) = '1',
                                           Redirection);

                  lCallBack.PollGuid := lRedGuid;

                  // Check every second for up to 1 minute, whether the callback
                  //  URL has been set.
                  Repeat
                    _Delay(1000);  // Wait for 1 second
                    Inc(lAttempt); // Increment the attempt counter
                  Until (lCallBack.URL <> '') Or (lAttempt > 60);

                  If lCallBack.URL <> '' Then
                    RedirectPolling(lRedGuid, lCallBack.URL)
                  Else
                    EndPolling(lRedGuid);
                End; {With fPosting, lVAT100Msg Do}

                fCallBackList.Add(lCallBack);
              End; {if lCallBack <> nil then}

              FreeAndNil(lVAT100Msg);
            End; {if Assigned(lVAT100Msg) then}

            FreeAndNil(lMsg);
          End; {if Assigned(lMsg) then}
        End; {for lCont:= 0 to lTotal - 1 do}
      End
      Else
        fLog.DoLogMessage('TVAT100Receiving.ProcessGGWPendingMessages',
          cOBJECTNOTAVAILABLE, 'VAT100 object is not available.')
    End; {if _GetOlevariantArraySize(lPend) > 0 then}

    lDb.Free;
  End {if Assigned(fDb) and fDb.Connected then}
  Else
    _LogMSG('TVAT100Receiving.ProcessGGWPendingMessages :- ' +
            'Could not process GGW Pending messages. Database is not connected.')
End;

{-----------------------------------------------------------------------------
  Procedure: ClearFinishedCallBacks
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.ClearFinishedCallBacks;
Var
  lCont: Integer;
  lObj: TVAT100CallBack;
Begin
  For lCont := fCallBackList.Count - 1 Downto 0 Do
    If fCallBackList[lCont] <> Nil Then
      If TVAT100CallBack(fCallBackList[lCont]).Finished Then
      Try
        lObj := TVAT100CallBack(fCallBackList[lCont]);

        { leave 1sec to be able to finish the processing in case the object is 
          trying to save the returned file...}
        _Delay(1000);

        If Assigned(lObj) Then
        Begin
          Deleterequest(lObj.VAT100Msg);
          _Delay(1000);
          EndPolling(lObj.PollGuid);
          _Delay(1000);
          lObj.Free;
        End; {If Assigned(lObj) Then}
      Finally
        fCallBackList.Delete(lCont);
      End; {if TVAT100CallBack(fCallBackList[lCont]).Finished then}
End;

{-----------------------------------------------------------------------------
  Procedure: Deleterequest
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.Deleterequest(pVAT100: TCISMessage);
Begin
  If Assigned(fPosting) Then
    With pVAT100, fPosting Do
      if UseTestGateway then
        Delete(CorrelationID, CISClassType, UseTestGateway, cGGWCONFIGTEST)
      else
        Delete(CorrelationID, CISClassType, UseTestGateway, cGGWCONFIGLIVE)
  Else
    _LogMSG('TVAT100CallBack.Deleterequest :- Posting COM object not available.');
End;

{-----------------------------------------------------------------------------
  Procedure: CreatePosting
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Function TVAT100Receiving.CreatePosting: _Posting;
Begin
  Try
    Result := CoPosting.Create;
  Except
    On E: exception Do
    Begin
      Result := Nil;
      _LogMSG('TVAT100Receiving.CreatePosting :- VAT100 Incoming object error: '
        + E.MEssage);
    End; {begin}
  End; {try}
End;

{-----------------------------------------------------------------------------
  Procedure: EndPolling
  Author:    Phil Rogers
-----------------------------------------------------------------------------}
Procedure TVAT100Receiving.EndPolling(Const pGuidPoll: String);
Begin
  If Assigned(fPosting) Then
  Begin
    Try
      fPosting.EndPolling(pGuidPoll);
    Except
    End;
  End
  Else
    _LogMSG('TVAT100Receiving.EndPolling :- Posting COM object not available.');
End;

//------------------------------------------------------------------------------
// This class implements interfaces which define the following methods, so they
// need to be here, even if they do nothing.
//------------------------------------------------------------------------------
Function TVAT100Receiving.Get_Authentication: WordBool;
Begin

End;

Function TVAT100Receiving.Get_IncomingPort: Integer;
Begin

End;

Function TVAT100Receiving.Get_IncomingServer: WideString;
Begin

End;

Function TVAT100Receiving.Get_MailBoxName: WideString;
Begin

End;

Function TVAT100Receiving.Get_MailBoxSeparator: WideString;
Begin

End;

Function TVAT100Receiving.Get_Password: WideString;
Begin

End;

Function TVAT100Receiving.Get_ServerType: WideString;
Begin

End;

Function TVAT100Receiving.Get_UserName: WideString;
Begin

End;

Function TVAT100Receiving.Get_YourName: WideString;
Begin

End;

Procedure TVAT100Receiving.Set_Authentication(Value: WordBool);
Begin

End;

Procedure TVAT100Receiving.Set_IncomingPort(Value: Integer);
Begin

End;

Procedure TVAT100Receiving.Set_IncomingServer(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_MailBoxName(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_MailBoxSeparator(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_Password(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_ServerType(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_UserName(Const Value: WideString);
Begin

End;

Procedure TVAT100Receiving.Set_YourName(Const Value: WideString);
Begin

End;

Function TVAT100Receiving.Get_YourEmail: WideString;
Begin

End;

Procedure TVAT100Receiving.Set_YourEmail(Const Value: WideString);
Begin

End;

Initialization
  TAutoObjectFactory.Create(ComServer, TVAT100Receiving, Class_VAT100Receiving,
    ciMultiInstance, tmApartment);
End.

