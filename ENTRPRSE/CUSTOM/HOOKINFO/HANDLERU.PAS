unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem01); Export;

implementation

Uses Classes, ChainU, EventInf, PIMisc;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    slAboutText := TStringList.Create;
    Try
      PIMakeAboutText('Enterprise Hook Info Plug-In', 'v5.00.011', slAboutText);
      For iPos := 0 To Pred(slAboutText.Count) Do
        AddAboutString (slAboutText[iPos]);
    Finally
      slAboutText.Free;
    End;

    { Define Handlers }
    SetHandlerStatus(wiAccount, 2, EventEnabled);
    SetHandlerStatus(wiAccount, 31, EventEnabled);
    SetHandlerStatus(wiAccount, 32, EventEnabled);
    SetHandlerStatus(wiAccount, 33, EventEnabled);
    SetHandlerStatus(wiAccount, 34, EventEnabled);

    { Batch/Serial - Enter Batch }
    SetHandlerStatus(wiSerialBatch, 1, EventEnabled);
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
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem01);
Begin
  { Handle Hook Events here }
  DisplayEventInfo(EventData);

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
