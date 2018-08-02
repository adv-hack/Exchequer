unit dllfuncs;

{ prutherford440 09:37 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Enterprise_TLB, {EnterpriseEvents,} AuthObjs, CustAbsU;


function GetVersion : ShortString;

function TransValInBase(const EventData : TAbsEnterpriseSystem) : Double;

procedure AuthorizeTransaction(EventData: TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);

procedure AuthorizeCopiedTransaction(const EventData: TAbsEnterpriseSystem;
                               const DataPath : ShortString);

function UnAuthorizeTransaction(const EventData: TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString;
                               AllowAuthorise : Boolean = True) : Boolean;

procedure StoreTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);

procedure StoreTransactionLines(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);

function TransactionChanged(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;

function AuthorizationNeededCOM(const EventData : TAbsEnterpriseSystem;
                                const DataPath : ShortString) : Boolean;

function CopyTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;

function AllowPrint(const EventData : TAbsEnterpriseSystem;
                    const DataPath : String) : Boolean;

function ConvertTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;

procedure SetAttachPrinter(const EventData : TAbsEnterpriseSystem);
var
  NeedToCheckPrint : Boolean;
  CopyAuthorised : Boolean;
  CopyAuthoriser : String;
  LineChanged : Boolean;

  btnPIN, btnPOR, btnPQU, btnSQU, btnPINHist, btnPORHist : Byte;


implementation

uses
   AuthBase, Dialogs, ComMsg, sysUtils, Forms, Controls, Enterprise04_TLB, AuthVar;

var
  ConvertPQU : string;

function GetVersion : ShortString;
begin
  with PaObject{.Create} do
  begin
    Try
      Result := Version;
    Finally
//      Free;
    End;
  end;
end;

procedure SetConvertRef(const EventData : TAbsEnterpriseSystem;
                                const DataPath : ShortString);
var
  Res : smallInt;
begin
  if EventData.HandlerId = 85 then
  with PaObject do
  begin
    CompanyPath := DataPath;
    Request.Company := CompanyCode;
    Request.Index := ReqOurRefIdx;
    Res := Request.GetEqual(ConvertPQU, True);
    if Res = 0 then
    begin
      Request.OurRef := EventData.Transaction.thOurRef;
      Request.Save;
    end;
  end;
end;




function AuthorizationNeededCOM(const EventData : TAbsEnterpriseSystem;
                                const DataPath : ShortString) : Boolean;
begin
  Result := False;
 { if EventData.Transaction.thHoldFlg and 3 <> 3 then}
  with PaObject{.Create} do
  begin
   Try
//    OpenFiles;
    CompanyPath := DataPath;
    CompanyParams.Company := CompanyCode;
    if CompanyParams.GetEqual(CompanyCode) = 0 then
    begin
      Case EventData.Transaction.thInvDocHed of
        cuSQU  :  Result := CompanyParams.AuthSQU;
        cuPQU  :  Result := CompanyParams.AuthPQU;
        cuPOR  :  Result := CompanyParams.AuthPOR or (EventData.HandlerId = 85);
        cuPIN  :  Result := CompanyParams.AuthPIN or (EventData.HandlerId = 85);
      end; //case
    end
    else
      Result := False; //company not set up for purchase authorisation
{      raise EBtrieveException.Create('Unable to find company ' + CompanyCode +
                                     ' in PA CompanyParams table');}
   Finally
{     CloseFiles;
     Free;}
   End;
  end; //with TPaObject
end;


procedure AuthorizeTransaction(EventData: TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);
var
  InvTot : Double;
  NeedsEAR : Boolean;
  Res : SmallInt;
  WhichUser : ShortString;
  OldCursor : TCursor;
  OverrideRes : integer;
  CarryOn, DelEar, PINFromPOR : Boolean;
begin
  if AuthorizationNeededCOM(EventData, DataPath) then
  begin
    CarryOn := True;
    if (EventData.HandlerId in [btnPIN, btnPOR, btnPQU, btnSQU, btnPINHist, btnPORHist]) and ((EventData.Transaction.thHoldFlg and 3) = 3) then
    begin
      if ComMessageDlg('This transaction has already been authorised. Do you wish to unauthorise it?')
          = mrYes then
      begin
         if UnAuthorizeTransaction(EventData, DataPath, CurrentUser, False {don't allow authorise})then
           ShowComMessage('Transaction has been unauthorised')
         else
           ShowComMessage('It was not possible to unauthorise this transaction at this time. This ' +
                          'may be because it is being edited by another user.'#10'Please try again later');
         CarryOn := False;
      end;
    end;

    if CarryOn then
    begin
      OldCursor := Screen.Cursor;
      Screen.Cursor := crHourGlass;
      Try
        NeedsEAR := False;
        with PaHookUserObject{.Create} do
        begin
          Try
            PINFromPOR := CanAuthorisePINFromPOR(EventData.Transaction.thOurRef);
            EventData.BoResult := False;
            CompanyPath := DataPath;
            UserID := {EventData.Transaction.thUser} CurrentUser;
            if not ValidUser and not PINFromPOR then
              OverrideUser(ovUserNotFound, 0);

            if ValidUser or PINFromPOR then
            begin
              WhichUser := User.UserID;
              InvTot := TransValInBase(EventData);
              if CanAuthorizeTransaction(InvTot) or PINFromPOR then
              begin
                //Authorize
                Authorize(EventData.Transaction.thOurRef);
              end
              else
    {          begin
                OverrideRes := OverrideUser(ovAboveAuthLimit or ovAllowEAR, InvTot);
                Case OverrideRes of
                  mrOK     : Authorize(EventData.Transaction.thOurRef);
                  mrCancel :  begin
                                ErrorStatus := erAboveAuthLimit;
                                ShowError;
                              end;
                  mrRetry  : NeedsEAR := True;
                end; //case
              end;}
              NeedsEAR := True;
            end
            else
            begin
              ErrorStatus := ehInvalidUserOnAuthorize;
              ShowError;
            end;
          Finally
    //        Free;
          End;
        end;


        if NeedsEAR then
        begin
          //Generate an EAR
          EventData.BoResult := False;
          with PaEARGenerator{.Create} do
          begin
            Try
              Try
                CompanyPath := DataPath;
                OpenFiles;
                DelEar := False;
                if EARExists(EventData.Transaction.thOurRef) then
                begin
                {The logic here is that we delete the existing ear unless the
                 user decides not to send another one.  So if the transaction amount
                 has changed then we delete and send a new one.  Same if the user says
                 yes i want to send another ear.}

                 if not TransHasChanged(EventData.Transaction.thOurRef,
                                       TransValInBase(EventData)) then
                   NeedsEAR := ComMessageDlg('An authorisation request has already been sent for transaction '
                                           + EventData.Transaction.thOurRef +
                                            '.'#10#10'Do you want to send another?') = mrYes;
  {               if NeedsEAR then
                   DeleteExistingEAR;}
                   DelEar := NeedsEar;

                end;
                if NeedsEar then
                begin
                  Res :=  NewEAR(CompanyCode, EventData.Transaction.thOurRef,
                                             WhichUser, DelEar);
                  Case Res of
                    earAuthorized           : ShowComMessage('Transaction authorised');
                    earSentForAuthorization : ;//ShowComMessage('Authorisation request sent');
                    earNotRequired          : ShowComMessage('This transaction doesn''t require authorisation');
                    earNoForm               : ShowComMessage('Company ' + CompanyCode +
                                                 ': No form has been selected for ' +
                                                 Copy(EventData.Transaction.thOurRef, 1, 3) +
                                                 ' transactions.'#10'Please run the administration program ' +
                                                 'and select a suitable form before sending an authorisation request');
                    earCancelledByUser      : ShowComMessage(#10'Request cancelled');
                  end;

                  if (EventData.HandlerId = 86) then
                  begin
                    EventData.BoResult := (Res in [earAuthorized, earNotRequired]);
                  end;
                end;
              Except
                on E: Exception do
                  ShowComMessage(E.Message);
              End;
            Finally
    //          Free;
            End;
          end;
        end;
      Finally
        EventData.BoResult := False;
        Screen.Cursor := OldCursor;
      End;
    end; //if CarryOn
  end; //if authorisation needed


end;

function TransactionChanged(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;
var
  Res, i : SmallInt;
  WasClosed, Changed : Boolean;
  Tolerance : Double;

  function TkTransTotal : Double;
  begin
    with FToolkit.Transaction do
      Result := thTotals[TransTotNetInBase];
  end;

  function CustTransTotal : Double;
  begin
    Result := TransValInBase(EventData);
  end;
begin
  Result := True;
  WasClosed := False;
  //If we're converting a quote then we always want to go through the functions
  //otherwise we check whether the transaction has changed
  if not (EventData.HandlerId in [83, 84, 85]) or
         (EventData.Transaction.thHoldFlg and 3 = 3) then
  with PaObject{.Create} do
  begin
   Try
    OpenFiles;
    CompanyPath := {EventData.Setup.ssDataPath}DataPath;
    CompanyParams.Company := CompanyCode;
    if CompanyParams.GetEqual(CompanyCode) = 0 then
      Tolerance := CompanyParams.PINTolerance
    else
      Tolerance := 0;

    if Assigned(FToolkit) then
    begin
      if FToolkit.Status = tkClosed then
      begin
        WasClosed := True;
        FToolkit.Configuration.DataDirectory := {EventData.Setup.ss}DataPath;
        FToolkit.OpenToolkit;
      end;

      with FToolkit.Transaction do
      begin
        Index := thIdxOurRef;
        Res := GetEqual(BuildOurRefIndex(EventData.Transaction.thOurRef));

        if Res = 0 then
        begin
          if (thLines.thLineCount = EventData.Transaction.thLines.thLineCount) and
             (Trim(thAcCode) = Trim(EventData.Transaction.thAcCode)) and
//             (Abs(thNetValue - EventData.Transaction.thInvNetVal) < 0.0001) then
             (Abs(TkTransTotal - CustTransTotal) < 0.0001 + Tolerance) then
          begin
          //unchanged so far
            Changed := False;
            for i := 1 to thLines.thLineCount do
            begin
              if (TRim(thLines.thLine[i].tlDescr) <> Trim(EventData.Transaction.thLines.thLine[i].tlDescr)) or
                 (Trim(thLines.thLine[i].tlStockCode) <>
                         Trim(EventData.Transaction.thLines.thLine[i].tlStockCode)) or
                 (Abs(thLines.thLine[i].tlNetValue -
                 EventData.Transaction.thLines.thLine[i].tlNetValue) >= 0.0001 + Tolerance) then
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
//    Free;
   End;
  end;
end;

procedure StoreTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);
var
  InvTot : Double;
begin

  if not TransactionChanged(EventData, DataPath, CurrentUser) and
     not LineChanged then
  begin
    EventData.BoResult := True;
    PaHookUserObject.ErrorStatus := ehStoredAndAuthorized;
  end
  else
  with PaHookUserObject{.Create} do
  begin
    Try
      Overridden := False;
      Hook := EventData.HandlerID;
      InvTot := TransValInBase(EventData);
      //EventData.ValidStatus := False;
      CompanyPath := {EventData.Setup.ssDataPath}DataPath;
      EventData.BoResult := False;

      UserID := {EventData.Transaction.thUser}CurrentUser;
      if not ValidUser then
        OverrideUser(ovUserNotFound, InvTot);

      if ValidUser then
      begin
        OpenFiles;
        CompanyParams.Company := CompanyCode;
        CompanyParams.GetEqual(CompanyCode);

        if  ((EventData.Transaction.thInvDocHed = cuPIN) and
            (not CompanyParams.FloorOnPins)) or
            CanStoreTransaction(InvTot) then
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
          begin //store but don't authorise
            EventData.Transaction.thHoldFlg := EventData.Transaction.thHoldFlg and 160;
            ErrorStatus := ehStoredNotAuthorized;
          end;
        end
        else
          ErrorStatus := ehAboveFloorLimit;
      end
      else
        ErrorStatus := ehInvalidUser;

     // ShowError;
    Finally
//      Free;
    End;
  end;
  NeedToCheckPrint := False;

end;

function AllowPrint(const EventData : TAbsEnterpriseSystem;
                    const DataPath : String) : Boolean;
var
  Res : SmallInt;
begin
  Result := True;
  if AuthorizationNeededCOM(EventData, DataPath) then
  with PaObject{.Create} do
  begin
   Try
    OpenFiles;
    CompanyPath := DataPath;
    CompanyParams.Company := CompanyCode;
    Res := CompanyParams.GetEqual(CompanyCode);
    if Res = 0 then
      Result := CompanyParams.AllowPrint or
               (EventData.Transaction.thHoldFlg and 3 = 3);
   Finally
//    Free;
   End;
  end;
  if not Result and NeedToCheckPrint then
    ShowCOMMessage('Transactions can not be printed until they have been authorised');
  NeedToCheckPrint := True;
end;

function ConvertTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;
var
  InvTot : Double;
  Flag   : Byte;
  Res : SmallInt;
begin
  ConvertPQU := EventData.Transaction.thOurRef;
  Result := False;
  if not AuthorizationNeededCOM(EventData, DataPath) or
        (EventData.Transaction.thHoldFlg and 3 = 3) then
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
    ShowCOMMessage('You must authorise this transaction before converting it');
  NeedToCheckPrint := False;
end;

function CopyTransaction(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString) : Boolean;
var
  InvTot : Double;
begin
  with PaHookUserObject{.Create} do
  begin
    Try
      Hook := EventData.HandlerID;
      Case Hook of
        87  :  InvTot := TransValInBase(EventData);
        88  :  InvTot := TransValInBase(EventData);
      end;
      Result := False;
      //EventData.ValidStatus := False;
      CompanyPath := {EventData.Setup.ss}DataPath;

      UserID := CurrentUser;
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
           { Authorize(EventData.Transaction.thOurRef);}
            CopyAuthorised := True;
            ErrorStatus := ehStoredAndAuthorized;
            CopyAuthoriser := CurrentUser;
          end
          else
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
//      Free;
    End;
  end;
  NeedToCheckPrint := False;

end;

procedure AuthorizeCopiedTransaction(const EventData: TAbsEnterpriseSystem;
                               const DataPath : ShortString);
begin
  with PaHookUserObject{.Create} do
  begin
    Try
      EventData.BoResult := False;
      EventData.ValidStatus := False;
      CompanyPath := DataPath;
      UserID := {EventData.Transaction.thUser} Trim(CopyAuthoriser);

      Authorize(EventData.Transaction.thOurRef);
      CopyAuthorised := False;
      CopyAuthoriser := '';
    Finally
//     Free;
    End;
  end;
end;

function UnAuthorizeTransaction(const EventData: TAbsEnterpriseSystem;
                                const DataPath, CurrentUser : ShortString;
                                AllowAuthorise : Boolean = True) : Boolean;
var
  Res : SmallInt;
  oTrans : ITransaction;
  WasClosed : boolean;
  CanAuthoriseThis : Boolean;
  InvTot : Double;
  LNo : SmallInt;
begin
  Result := True;
  WasClosed := False;
  CanAuthoriseThis := False;
  with PaHookUserObject{.Create} do
  begin
    Try
      Hook := EventData.HandlerID;
      InvTot := TransValInBase(EventData);
      //EventData.ValidStatus := False;
      CompanyPath := {EventData.Setup.ssDataPath}DataPath;
      EventData.BoResult := False;

      if AllowAuthorise then
      begin
        UserID := {EventData.Transaction.thUser}CurrentUser;
        if ValidUser then
        begin
          InvTot := TransValInBase(EventData);
          CanAuthoriseThis := CanAuthorizeTransaction(InvTot);
        end;
      end;

    Finally
//      Free;
    End;
  end;

  if not CanAuthoriseThis then
  begin

    if Assigned(FToolkit) then
    begin
      if FToolkit.Status = tkClosed then
      begin
        WasClosed := True;
        FToolkit.Configuration.DataDirectory := {EventData.Setup.ss}DataPath;
        FToolkit.OpenToolkit;
      end;

      with FToolkit.Transaction do
      begin
        Index := thIdxOurRef;
        Res := GetEqual(BuildOurRefIndex(EventData.Transaction.thOurRef));

        if Res = 0 then
        begin
          oTrans := Update;

          if Assigned(oTrans) then
          begin
            oTrans.thHoldFlag := oTrans.thHoldFlag and 160;

            Res := oTrans.Save(False);
            if Res <> 0 then
              Result := False;
          end
          else
            Result := False;
        end;

        if Result and not AllowAuthorise then {make a note of deliberate unauthorization}
        begin
          LNo := PaHookUserObject.GetNextNotesLineNo(FToolkit.Transaction);
          with FToolkit.Transaction.thNotes.Add do
          begin
            ntType := ntTypeDated;
            ntOperator := CurrentUser;
            ntDate := FormatDateTime('yyyymmdd', Date);
            ntText := FormatDateTime('hh:mm', Time) + ': ' + 'Unauthorised by ' +
                           CurrentUser;
            ntLineNo := LNo;
            Save;
          end;
        end;
      end;

      if WasClosed then
        FToolkit.CloseToolkit;
    end;

  end;
  NeedToCheckPrint := False;
  SetConvertRef(EventData, DataPath);
end;

procedure StoreTransactionLines(const EventData : TAbsEnterpriseSystem;
                               const DataPath, CurrentUser : ShortString);
begin
{  if TransactionChanged(EventData, DataPath, CurrentUser) then
    LineChanged := True
  else
    LineChanged := False;}

  NeedToCheckPrint := False;
end;

function TransValInBase(const EventData : TAbsEnterpriseSystem) : Double;
var
  CurrFrom : Integer;
  TKitOpened : Boolean;
  Amount : Double;
begin
  TKitOpened := False;
  Amount := EventData.Transaction.thInvNetVal - EventData.Transaction.thDiscAmount;
  if EventData.Transaction.thDiscTaken then
    Amount := Amount - EventData.Transaction.thDiscSetAm;
  CurrFrom := EventData.Transaction.thCurrency;
  if CurrFrom in [0, 1] then
    Result := amount
  else
  with FToolkit do
  Try
    if Status = tkClosed then
    begin
      OpenToolkit;
      TKitOpened := true;
    end;
    Result := Functions.entConvertAmount(amount,
                                         CurrFrom,
                                         1,
                                         SystemSetup.ssCurrencyRateType);
    if TKitOpened then
      CloseToolkit;
  Except
    Result := amount;
  End;
end;

procedure SetAttachPrinter(const EventData : TAbsEnterpriseSystem);
begin
{$IFNDEF HEREFORD}
  with EventData.Setup do
    AttachPrinter := ssPaperless.ssAttachPrinter;
{$ELSE}
    AttachPrinter := 'wor_fin_hplj4100 on ade12';
{$ENDIF}
end;







Initialization
  NeedToCheckPrint := True;
  CopyAuthorised := False;
  CopyAuthoriser := '';
  LineChanged := False;


end.
