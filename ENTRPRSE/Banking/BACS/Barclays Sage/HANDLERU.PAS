unit HandlerU;

{ HV 08/06/2016 2016-R2 ABSEXCH-17575: Barclays.NET Sage file format, Sage file format -UK Three Day Payments and UK faster/Next Day Payment  }
{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU, ChainU, ExpObj;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, Forms, Classes, ExWrap, BacConst;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  BacsHook = EnterpriseBase + 2050;
  DefaultOutFileName = 'BAC';

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
Begin
  CustomOn := True;
  if HookIsLicenced(exBarclaysSage) then
  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
    MakeBacsAboutText(exBarclaysSage);
    for i := 0 to AboutText.Count - 1 do
      AddAboutString(AboutText[i]);

    SetHandlerStatus(BacsHook, 1, EventEnabled);
    SetHandlerStatus(BacsHook, 10, EventEnabled);
    SetHandlerStatus(BacsHook, 20, EventEnabled);
    SetHandlerStatus(BacsHook, 30, EventEnabled);
    SetHandlerStatus(BacsHook, 31, EventEnabled);
    SetHandlerStatus(BacsHook, 50, EventEnabled);
    SetHandlerStatus(BacsHook, 60, EventEnabled);
    SetHandlerStatus(BacsHook, 70, EventEnabled);
    SetHandlerStatus(BacsHook, 80, EventEnabled);
  end;
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
  if (WinID = BacsHook) then
    HandleBatchHooks(EventData, HandlerID, exBarclaysSage, ftaCreditOnly, DefaultOutFilename,
                     '');
  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
