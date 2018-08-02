unit HandlerU;

{ prutherford440 15:12 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }
{Template for use in BACS export dlls}
interface

Uses CustWinU, CustAbsU, ChainU;


const
  DefaultPayFileName = 'JPMorganPay.txt';
  DefaultRecFileName = 'JPMorganDDebit.txt';



{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, Forms, Classes, ExWrap, BacConst, IniFiles, JPMorganObj;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  BacsHook = EnterpriseBase + 2050;

procedure ReadIniFile(const DataPath : string);
begin
  with TIniFile.Create(Datapath + 'JPMorgan.ini') do
  Try
    sClientID := ReadString('Settings', 'ClientID', '');
    iMandateNo := ReadInteger('Settings', 'MandateField', 0);
  Finally
    Free;
  End;
end;



{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
Begin
  CustomOn := True;
  if HookIsLicenced(exJPMorgan) then
  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
    MakeBacsAboutText(exJPMorgan);
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
var
  DefaultOutFileName : string;
Begin
  { Handle Hook Events here }
  with EventData do
  if (WinID = BacsHook) then
  begin
    if HandlerID = 1 then
      ReadIniFile(EventData.Setup.ssDataPath);
    HandleBatchHooks(EventData, HandlerID, exJPMorgan, ftaBoth, DefaultPayFilename,
                     DefaultRecFileName);
  end;


  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
