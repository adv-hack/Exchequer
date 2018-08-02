unit HandlerU;

interface

Uses Classes, CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, GSTCalcU, ChainU, piMisc, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  {$IFDEF EX600}
    sVersionNo = '027';
  {$ELSE}
    sVersionNo = 'v5.70.026';
  {$ENDIF}


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  slAboutText : TStringList;
  iPos        : SmallInt;
Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Define About Box Message }
    slAboutText := TStringList.Create;
    Try
      PIMakeAboutText ('Exchequer Tax Settlement Discount Plug-In',   // sName
                       ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)',          // sVersionNo : string;
                       slAboutText);               // AboutText

      If (slAboutText.Count > 0) Then
        For iPos := 0 To Pred(slAboutText.Count) Do
          AddAboutString (slAboutText[iPos]);
    Finally
      FreeAndNIL(slAboutText);
    End;

    { Define Handlers }
    SetHandlerStatus(wiMisc + 1, 1, EventEnabled);         { VAT Calculation }

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
  With EventData Do
    If (WinId = (wiMisc + 1)) And (HandlerId = 1) Then
    Begin
      If (ClassVersion>'5.5') then
        { VAT/GST Calculation }
        CalcTAX(EventData)
      else
        Calc500Tax(EventData);
    end;

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
