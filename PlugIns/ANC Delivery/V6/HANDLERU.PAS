unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU, Classes;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;

implementation

Uses Dialogs, SysUtils, ChainU, ANCDlg, PiSecure, PiMisc, VerInfo;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        :  Byte;
Begin
  CustomOn := True;

  bPlugInEnabled := PICheckSecurity('EXCHANCEXP000010',
                                    'FGM£(Dcl!4dA()da',
                                    'Exchequer ANC Delivery Link Plug-In',
                                    '',
                                    stSystemOnly,
                                    ptDll,
                                    DLLChain.ModuleName);
  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      { Define About Box Message }
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText ('Exchequer ANC Delivery Link Plug-In',
                         ANCVer + ' (DLL)',
                         slAboutText);
        For iPos := 0 To Pred(slAboutText.Count) Do
          AddAboutString (slAboutText[IPos]);
      Finally
        FreeAndNIL (slAboutText);
      End;

      { Define Handlers }
      SetHandlerStatus(EnterpriseBase + 1000, 11, EventEnabled); { Customer List - Custom Button 1 }
      SetHandlerStatus(EnterpriseBase + 1000, 21, EventEnabled); { Supplier List - Custom Button 1 }

      SetHandlerStatus(EnterpriseBase + 2000, 14, EventEnabled); { Sales Order Daybook - Custom Button 1 }
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


{ Called by ExecCustomHandler to control Customer/Supplier Account Events }
Procedure AccHooks(Const EventData : TAbsEnterpriseSystem);
Begin { AccHooks }
  Case EventData.HandlerId Of
    11  : ANCExport (EventData, 2);

    21  : ANCExport (EventData, 3);
  End; { Case }
End; { AccHooks }


{ Called by ExecCustomHandler to control Inv Events }
Procedure InvHooks(Const EventData : TAbsEnterpriseSystem);
Begin
  Case EventData.HandlerId Of
    { Sales Order Daybook - Custom Button 1 }
    14 : ANCExport (EventData, 1);
  End; { Case }
End;


{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here  if Plug-In enabled }
  If bPlugInEnabled Then
    Case EventData.WinId Of
      { Customer/Supplier }
      EnterpriseBase + 1000 : AccHooks(EventData);

      { Transaction }
      EnterpriseBase + 2000 : InvHooks(EventData);
    End; { Case }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
