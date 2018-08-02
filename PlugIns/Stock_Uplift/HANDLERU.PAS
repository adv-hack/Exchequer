unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU, Classes,
     PiSecure, PIMISC, uDeposit, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  sPlugInName = 'Exchequer Stock Uplift Plug-In';
  {$IFDEF EX600}
    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '104';
//    sVersionNo = 'v6.00.102';
  {$ELSE}
    sVersionNo = 'v5.71.102';
  {$ENDIF}

var
  bHookEnabled : boolean;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  slAboutText : TStringList;
  iPos : integer;
Begin
 CustomOn := False;

  bHookEnabled := PICheckSecurity('EXCHSTKUPL000013', 'DhjEXjDZMKDyhFhN',
                    sPlugInName, '', stSystemOnly, ptDLL, DLLChain.ModuleName);
                    
  if bHookEnabled then
  begin
    with CustomHandlers do
    begin
      slAboutText:= TStringList.Create;
      with slAboutText do
      try
        PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
        for iPos:= 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
      finally
        Free;
      end;
      SetHandlerStatus(wiTransaction, 103, EventEnabled);
    end;
  end; // if bHookEnabled then...

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
Begin
  { Handle Hook Events here }
  with EventData do
  begin
    if (WinID = wiTransaction) and (HandlerID = 103) then
    begin
      with TUpLifter.Create do
      try
        DoUplift(EventData);
      finally
        Free;
      end;
    end;
  end;

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
