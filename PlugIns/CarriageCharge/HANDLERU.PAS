unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Classes, CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;
  bTriggerOnAllOrders : boolean = False;

implementation

Uses Dialogs, SysUtils, ChainU, Carriage, PISecure, PIMisc, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  {$IFDEF EX600}
    sVersionNo = '213';
  {$ELSE}
    sVersionNo = 'v5.70.212';
  {$ENDIF}


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  // Check Release Code status of the Plug-In
  bPlugInEnabled := PICheckSecurity('EXCHCARRGE000007',     // sSystemCode
                                    'D£Hf%aH6asgvE54"',     // sSecurityCode
                                    'Carriage Charges Plug-In', // sDescription
                                    '',      // sVersionNo
                                    stSystemOnly,           // iSecurityType
                                    ptDLL,                  // PluginType
                                    DLLChain.ModuleName);   // sPluginPath

  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText ('Carriage Charges Plug-In', // sName
                         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                     // sVersionNo : string;
                         slAboutText);                          // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      { Define Handlers }
      SetHandlerStatus(wiTransaction, 1, EventEnabled); { Before Transaction Save }

      { Call other Hook DLL's to get their customisation }
      DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
    End; { With }
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
Begin
  { Handle Hook Events here }
  If bPlugInEnabled Then
    If (EventData.WinId = wiTransaction) And (EventData.HandlerId = 1) Then Begin
      { Invoice - Before Transaction Save }
      DisplayCarriageDlg (EventData);
    End; { If }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
