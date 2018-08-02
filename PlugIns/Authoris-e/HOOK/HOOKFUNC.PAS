unit HookFunc;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  AuthObjs, CustAbsU;

{move into com section to prevent problem with comtk on shutdown
procedure StoreTransaction(const EventData : TAbsEnterpriseSystem);
function TransactionChanged(const EventData : TAbsEnterpriseSystem) : Boolean;
}

function AuthorizationNeeded(const EventData : TAbsEnterpriseSystem) : Boolean;

function ConvertTransaction(const EventData : TAbsEnterpriseSystem) : Boolean;

function CopyTransaction(const EventData : TAbsEnterpriseSystem) : Boolean;

procedure DeleteRequest(const RefNo, DataPath : ShortString);


{procedure AuthorizeTransaction(const EventData: TAbsEnterpriseSystem);
 moved into Com hook}
function GetVersion : ShortString;

implementation

uses
  AuthBase, Dialogs, Controls, Enterprise01_TLB, AuthVar;

var
  QuoteRef : ShortString;

function GetVersion : ShortString;
begin
  with TPaObject.Create do
  begin
    Try
      Result := Version;
    Finally
      Free;
    End;
  end;
end;

function TransactionChanged(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  Res, i : SmallInt;
  WasClosed, Changed : Boolean;
begin
  Result := True;
  WasClosed := False;
  //If we're converting a quote then we always want to go through the functions
  //otherwise we check whether the transaction has changed
  if not (EventData.HandlerId in [83, 84, 85]) then
  with TPaObject.Create do
  begin
   Try
    OpenFiles;
    CompanyPath := EventData.Setup.ssDataPath;
    if Assigned(FToolkit) then
    begin
      if FToolkit.Status = tkClosed then
      begin
        WasClosed := True;
        FToolkit.Configuration.DataDirectory := EventData.Setup.ssDataPath;
        FToolkit.OpenToolkit;
      end;

      with FToolkit.Transaction do
      begin
        Index := thIdxOurRef;
        Res := GetEqual(BuildOurRefIndex(EventData.Transaction.thOurRef));

        if Res = 0 then
        begin
          if (thLines.thLineCount = EventData.Transaction.thLines.thLineCount) and
             (Abs(thNetValue - EventData.Transaction.thInvNetVal) < 0.0001) then
          begin
          //unchanged so far
            Changed := False;
            for i := 1 to thLines.thLineCount do
            begin
              if (thLines.thLine[i].tlDescr <> EventData.Transaction.thLines.thLine[i].tlDescr) or
                 (thLines.thLine[i].tlStockCode <>
                         EventData.Transaction.thLines.thLine[i].tlStockCode) or
                 (thLines.thLine[i].tlNetValue <>
                 EventData.Transaction.thLines.thLine[i].tlNetValue) then
                   Changed := True;
            end;
            Result := Changed;
          end;
        end;
      end;

      if WasClosed then
        FToolkit.CloseToolkit;
    end; //if assigned tkit
   Finally
    Free;
   End;
  end;
end;


function AuthorizationNeeded(const EventData : TAbsEnterpriseSystem) : Boolean;
begin
  Result := False;
  with TPaObject.Create do
  begin
   Try
    OpenFiles;
    CompanyPath := EventData.Setup.ssDataPath;
    CompanyParams.Company := CompanyCode;
    if CompanyParams.GetEqual(CompanyCode) = 0 then
    begin
      Case EventData.Transaction.thInvDocHed of
        cuSQU  :  Result := CompanyParams.AuthSQU;
        cuPQU  :  Result := CompanyParams.AuthPQU;
        cuPOR  :  Result := CompanyParams.AuthPOR;
        cuPIN  :  Result := CompanyParams.AuthPIN;
        cuPCR,
        cuPJC,
        cuPRF  :  Result := CompanyParams.AuthPIN and (EventData.HandlerId = 88) and
                            (EventData.Transaction.thInvNetVal > 0);
      end; //case
    end
    else
      raise EBtrieveException.Create('Unable to find company ' + CompanyCode +
                                     ' in PA CompanyParams table');
   Finally
     CloseFiles;
     Free;
   End;
  end; //with TPaObject
end;

procedure StoreTransaction(const EventData : TAbsEnterpriseSystem);
var
  InvTot : Double;
begin
  with TPaHookUserObject.Create do
  begin
    Try
      Hook := EventData.HandlerID;
      InvTot := EventData.Transaction.thInvNetVal;
      EventData.BoResult := False;
      //EventData.ValidStatus := False;
      CompanyPath := EventData.Setup.ssDataPath;

      UserID := EventData.Transaction.thUser;
      if not ValidUser then
        OverrideUser(ovUserNotFound, InvTot);

      if ValidUser then
      begin

        if CanStoreTransaction(InvTot) then
        begin
          EventData.BoResult := True;
          EventData.ValidStatus := True;

          if CanAuthorizeTransaction(InvTot) then
          begin
             EventData.Transaction.thHoldFlg := 3 +
                (EventData.Transaction.thHoldFlg and 160);
             ErrorStatus := ehStoredAndAuthorized;
          end
          else
          begin
            //Can't set this to 0 so try 2
            EventData.Transaction.thHoldFlg := 2 + EventData.Transaction.thHoldFlg and 160;
            ErrorStatus := ehStoredNotAuthorized;
          end;
        end
        else
          ErrorStatus := ehAboveFloorLimit;
      end
      else
        ErrorStatus := ehInvalidUser;

      ShowError;
    Finally
      Free;
    End;
  end;
end;

{not used - now in comfuncs}
procedure AuthorizeTransaction(const EventData: TAbsEnterpriseSystem);
var
  InvTot : Double;
  NeedsEAR : Boolean;
  Res : SmallInt;
  WhichUser : ShortString;
begin
  begin
    NeedsEAR := False;
    with TPaHookUserObject.Create do
    begin
      Try
        EventData.BoResult := False;
        EventData.ValidStatus := False;
        CompanyPath := EventData.Setup.ssDataPath;
        UserID := EventData.Transaction.thUser;
        if not ValidUser then
          OverrideUser(ovUserNotFoundA, 0);

        if ValidUser then
        begin
          WhichUser := User.UserID;
          InvTot := EventData.Transaction.thInvNetVal;
          if CanAuthorizeTransaction(InvTot) then
          begin
            //Authorize
            Authorize(EventData.Transaction.thOurRef);
          end
          else
            NeedsEAR := True;
        end
        else
        begin
          ErrorStatus := ehInvalidUserOnAuthorize;
          ShowError;
        end;
      Finally
        Free;
      End;
    end;

    if NeedsEAR then
    begin
      //Generate an EAR
      with TPaEARGenerator.Create do
      begin
        Try
          EventData.BoResult := False;
          EventData.ValidStatus := False;
          CompanyPath := EventData.Setup.ssDataPath;
          OpenFiles;
          if EARExists(EventData.Transaction.thOurRef) then
          begin
          {The logic here is that we delete the existing ear unless the
           user decides not to send another one.  So if the transaction amount
           has changed then we delete and send a new one.  Same if the user says
           yes i want to send another ear.}

            if not TransHasChanged(EventData.Transaction.thOurRef,
                                   EventData.Transaction.thInvNetVal) then
              NeedsEAR := MessageDlg('An authorisation request has already been sent for transaction '
                                       + EventData.Transaction.thOurRef +
                                        '.'#10#10'Do you want to send another?',
                                        mtConfirmation, mbYesNoCancel, 0) = mrYes;
            if NeedsEAR then
              DeleteExistingEAR;
          end;

          if NeedsEAR then
          begin
            NewEAR(CompanyCode, EventData.Transaction.thOurRef,
                                   WhichUser);
            ShowMessage('Authorisation request sent');
          end;
        Finally
          Free;
        End;
      end;
    end;
  end;

end;

function ConvertTransaction(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  InvTot : Double;
  Flag   : Byte;
  Res : SmallInt;
begin
  Result := False;
  if not AuthorizationNeeded(EventData) or (EventData.Transaction.thHoldFlg and 3 = 3) then
  begin
    Result := True;
    //not needed temporarily
{    if EventData.HandlerID in [83, 84] then
      QuoteRef := EventData.Transaction.thOurRef //save for next run through
    else
    if (EventData.HandlerID = 85) and (EventData.Transaction.thInvDocHed = cuPQU) then
    begin
      with TPaObject.Create do
      begin
       Try
        OpenFiles;
        CompanyPath := EventData.Setup.ssDataPath;
        Request.Index := reqEARIdx;
        Res := Request.GetEqual(MakeRequestString(CompanyCode, QuoteRef));
        if Res = 0 then
        begin
          Request.OurRef := EventData.Transaction.thOurRef;
          Request.Save;
        end;
       Finally
        Free;
       End;
      end
    end;}
  end
  else
    ShowMessage('You must authorize this transaction before converting it');
end;

function CopyTransaction(const EventData : TAbsEnterpriseSystem) : Boolean;
var
  InvTot : Double;
begin
  with TPaHookUserObject.Create do
  begin
    Try
      Hook := EventData.HandlerID;
      Case Hook of
        87  :  InvTot := EventData.Transaction.thInvNetVal;
        88  :  InvTot := EventData.Transaction.thInvNetVal;
      end;
      Result := False;
      //EventData.ValidStatus := False;
      CompanyPath := EventData.Setup.ssDataPath;

      UserID := EventData.Transaction.thUser;
      if not ValidUser then
        OverrideUser(ovUserNotFound, InvTot);

      if ValidUser then
      begin
        if CanStoreTransaction(InvTot) then
        begin
          EventData.BoResult := True;
          EventData.ValidStatus := True;
          ErrorStatus := ehStoredNotAuthorized;
          Result := True;
        end
        else
          ErrorStatus := ehAboveFloorLimit;
      end
      else
        ErrorStatus := ehInvalidUser;

      ShowError;
    Finally
      Free;
    End;
  end;
end;

procedure DeleteRequest(const RefNo, DataPath : ShortString);
var
  Res : SmallInt;
begin
  with TPaObject.Create do
  begin
   Try
    OpenFiles;
    CompanyPath := DataPath;
    Request.Company := CompanyCode;
    Res := Request.GetEqual(RefNo);

    if Res = 0 then
      Request.Delete;
   Finally
    Free
   End;
  end;
end;








end.
