unit HandlerU;

//------------------------------------------------------------------------------
//HV 09/05/2018 2018-R1.1 ABSEXCH-20015: Thomas Pink - HSBC-MT103 Priority Payments (XML Foramt)

{ prutherford440 15:09 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }

{$ALIGN 1}  { Variable Alignment Disabled }

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }           
//------------------------------------------------------------------------------

interface

uses CustWinU, CustAbsU, ChainU, ExpObj;

  { Following functions required to be Exported by Enterprise }
  procedure InitCustomHandler(var CustomOn: Boolean; CustomHandlers: TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(const EventData: TAbsEnterpriseSystem); Export;

implementation

uses Dialogs, SysUtils, ExWrap, Forms, Classes, BacConst, IniFiles;

const
  EventDisabled = 0;
  EventEnabled  = 1;
  BacsHook = EnterpriseBase + 2050;
  DefaultPayFileName = 'HSBCMT103PPay.XML';
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
{ Called by Enterprise to initialise the Customisation }
procedure InitCustomHandler(var CustomOn: Boolean; CustomHandlers: TAbsCustomHandlers);
var
  i : integer;
begin
  CustomOn := True;

  if HookIsLicenced(exHSBCMT103PPXML) then
  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
    MakeBacsAboutText(exHSBCMT103PPXML);
    for i := 0 to AboutText.Count - 1 do
      AddAboutString(AboutText[i]);

    SetHandlerStatus(BacsHook, 1,  EventEnabled);
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

//------------------------------------------------------------------------------
{ Called by Enterprise to End the Customisation }
procedure TermCustomHandler;
begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;
  { Put Shutdown Code Here }
end;

//------------------------------------------------------------------------------
{ Called by Enterprise whenever a Customised Event happens }
procedure ExecCustomHandler(const EventData: TAbsEnterpriseSystem);
var
  DefaultOutFileName: String;
begin
  { Handle Hook Events here }
  with EventData do
  if (WinID = BacsHook) then
    HandleBatchHooks(EventData, HandlerID, exHSBCMT103PPXML, ftaCreditOnly, DefaultPayFilename,'');

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
end;

//------------------------------------------------------------------------------

end.
