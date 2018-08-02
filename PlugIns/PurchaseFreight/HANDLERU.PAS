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


implementation

Uses Dialogs, SysUtils, ChainU, UplftDlg, PISecure, PIMisc, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  {$IFDEF EX600}
    sVersionNo = '113';
  {$ELSE}
    sVersionNo = 'v5.71.111';
  {$ENDIF}


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  // Check Release Code status of the Plug-In
  bPlugInEnabled := PICheckSecurity('EXCHPURCHF000003',     // sSystemCode
                                    'CIBs38as2*£jaftK',     // sSecurityCode
                                    'Exchequer Purchase Freight Plug-In', // sDescription
                                    '',  // sVersionNo
                                    stSystemOnly,           // iSecurityType
                                    ptDLL,                  // PluginType
                                    DLLChain.ModuleName);   // sPluginPath

  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText ('Exchequer Purchase Freight Plug-In', // sName
                         ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',                     // sVersionNo : string;
                         slAboutText);                          // AboutText

        If (slAboutText.Count > 0) Then
          For iPos := 0 To Pred(slAboutText.Count) Do
            AddAboutString (slAboutText[iPos]);
      Finally
        FreeAndNIL(slAboutText);
      End;

      // Check to see if button 1 is available
      If (Not HookPointEnabled (wiTransaction, 41)) Then Begin
        SetHandlerStatus(wiTransaction, 41, EventEnabled);
        CustHookId := 41;
        CustBtnId := 5;
      End { If (Not HookPointEnabled (wiTransaction, 41)) }
      Else Begin
        // Button 1 already in use - Use Button 2
        SetHandlerStatus(wiTransaction, 42, EventEnabled);
        CustHookId := 42;
        CustBtnId := 6;
      End; { Else }

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
  If bPlugInEnabled And (EventData.WinId = wiTransaction) And (EventData.HandlerId = CustHookId) Then
    CalcUplift (EventData);

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
