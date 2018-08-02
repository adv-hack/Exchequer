unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Classes, CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;
  CustHookId     : LongInt = 0;
  CustBtnId      : LongInt = 0;
  ACOnHold       : Boolean;
  UsedByOthers   : Boolean;

implementation

Uses Dialogs, SysUtils, ChainU, PISecure, PIMisc, HoldForm, ApiUtil, Shared, ExchequerRelease;



Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  bPlugInEnabled := True;


  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText ('Custom Hold Plug-In', // sName
                         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                     // sVersionNo : string;
                         slAboutText);                          // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      if (Copy(CustomHandlers.ClassVersion, 1, 4) = '5.61') then
      begin
        UsedByOthers := False;
        SetHandlerStatus(wiTransaction, 189, EventEnabled);
      end
      else
      begin
        UsedByOthers := HookPointEnabled(wiTransaction, 82);
        SetHandlerStatus(wiTransaction, 82, EventEnabled);
        SetHandlerStatus(wiTransaction, 101, EventEnabled);
      end;

    End; { With }

    { Call other Hook DLL's to get their customisation }
    DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;


{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  Res : integer;
  TransType : longint;
Begin
//CJS
  // If bPlugInEnabled And (EventData.WinId = wiTransaction) and (EventData.HandlerId in [82, 101]) Then
  If bPlugInEnabled And (EventData.WinId = wiTransaction) and (EventData.HandlerId in [82, 101, 189]) Then
  begin
    if not UsedByOthers then
      EventData.BoResult := True;

    ReadSettingsFile;
    Case EventData.Transaction.thInvDocHed of
      cuSQU : TransType :=  1;
      cuSOR : TransType :=  2;
//      cuSDN : TransType :=  4;  Removed at DR's request
      cuSIN : TransType :=  8;
      cuSCR : TransType :=  16;
      cuSRF : TransType :=  32;
      cuSJI : TransType :=  64;
      cuSRI : TransType :=  128;
      cuSJC : TransType :=  256;
      else
        TransType := 0;
    end; //case


    if EventData.HandlerID = 101 then
    Try
      AcOnHold := EventData.Customer.acAccStatus = 2;
    Except
      AcOnHold := False;
    End;

    if EventData.HandlerId = 189 then
    try
      AcOnHold := EventData.Customer.acAccStatus = 2;
    except
      AcOnHold := False;
    end;

    if AcOnHold and (TransType > 0) then
    begin
      if TransType and Settings.Bools = TransType then
      begin
        if EventData.HandlerID = 101 then
         msgBox('Sales Account ' + EventData.Transaction.thAcCode + ' is on hold - ' +
                'This transaction should be cancelled now. If you proceed to add transaction lines ' +
              'it will not be possible to store this transaction whilst the ‘On-Hold’ status for this Account is enabled. ' +
              'If this situation occurs the Account code must be changed to an Account code that is not ‘On-Hold’.',
               mtWarning, [mbOK], mbOK, 'Account on Hold')
        else
        if EventData.HandlerId = 189 then
        begin
           msgBox('Sales Account ' + EventData.Customer.acCode + ' is on hold - ' +
                  'You must either change to an Account Code which is not ' +
                  'on-hold, or cancel this transaction.',
                  mtWarning, [mbOK], mbOK, 'Account on Hold');
          EventData.BoResult := False;
        end
        else
        if EventData.HandlerId = 82 then
        begin
          msgBox('Sales Account ' + EventData.Transaction.thAcCode + ' is on hold - ' +
                 'This transaction cannot be stored', mtWarning, [mbOK], mbOK, 'Account on Hold');
          EventData.BoResult := False;
        end;
      end;
    end;
  end; //if bPlugInEnabled

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
