unit HandlerU;

{ HV 07/04/2017 2017-R1 ABSEXCH-18556:
  New format for The Honourable Soc of Gray's Inn - E-banking Platform- C Hoare & Co}

{ prutherford440 15:12 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

uses CustWinU, CustAbsU, ChainU, ExpObj;

{ Following functions required to be Exported by Enterprise }
procedure InitCustomHandler(var CustomOn: Boolean;
                                CustomHandlers: TAbsCustomHandlers); export;
procedure TermCustomHandler; export;
procedure ExecCustomHandler(const EventData: TAbsEnterpriseSystem); export;

implementation

uses Dialogs, SysUtils, Forms, Classes, ExWrap, BacConst;

const
  EventDisabled = 0;
  EventEnabled  = 1;
  BacsHook = EnterpriseBase + 2050;
  DefaultOutFileName = 'HoareTransCode.csv';

{ Called by Enterprise to initialise the Customisation }
procedure InitCustomHandler(var CustomOn: Boolean;
                                CustomHandlers: TAbsCustomHandlers);
var
  i: integer;
begin
  CustomOn := True;

  { Enable Hooks and Set About Message here }
  if HookIsLicenced(exHoareTransCode) then
  begin
    with CustomHandlers do
    begin
      MakeBacsAboutText(exHoareTransCode);
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
  end;
end;

{ Called by Enterprise to End the Customisation }
procedure TermCustomHandler;
begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;
  { Put Shutdown Code Here }
end;

{ Called by Enterprise whenever a Customised Event happens }
procedure ExecCustomHandler(const EventData: TAbsEnterpriseSystem);
begin
  { Handle Hook Events here }
  with EventData do
    if (WinID = BacsHook) then
      HandleBatchHooks(EventData,
                       HandlerID,
                       exHoareTransCode,
                       ftaCreditOnly,
                       DefaultOutFileName,
                       '');
                       
  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

end.
