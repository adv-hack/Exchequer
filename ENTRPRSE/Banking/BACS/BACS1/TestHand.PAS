unit TestHand;

{ prutherford440 15:09 08/01/2002: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface


Uses CustWinU, CustAbsU, ChainU, ExpObj, Enterprise01_TLB, ComObj;



{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ExWrap, Forms, Classes;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

  BacsHook = EnterpriseBase + 2050;

  DefaultPayFileName = 'Bacs.imp';
  DefaultRecFileName = 'DDeb.imp';

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
Begin
  CustomOn := True;

//  if HookIsLicenced(exBacs1) then
  { Enable Hooks and Set About Message here }
  with CustomHandlers do
  begin
//    MakeBacsAboutText(exBacs1);
{    for i := 0 to AboutText.Count - 1 do
      AddAboutString(AboutText[i]);
 }
{    SetHandlerStatus(BacsHook, 1, EventEnabled);
    SetHandlerStatus(BacsHook, 10, EventEnabled);
    SetHandlerStatus(BacsHook, 20, EventEnabled);
    SetHandlerStatus(BacsHook, 30, EventEnabled);
    SetHandlerStatus(BacsHook, 31, EventEnabled);
    SetHandlerStatus(BacsHook, 50, EventEnabled);
    SetHandlerStatus(BacsHook, 60, EventEnabled);
    SetHandlerStatus(BacsHook, 70, EventEnabled);
    SetHandlerStatus(BacsHook, 80, EventEnabled);}
    AddAboutString('Test1');
    SetHandlerStatus(wiTransaction, 170, EventEnabled);
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
  oToolkit : IToolkit;
  Res : longint;
begin
  if (EventData.WinID = wiTransaction) and (EventData.HandlerID = 170) then
  begin
    oToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
    Res := oToolkit.OpenToolkit;

    with oToolkit do
    begin
      Res := Transaction.GetEqual(Transaction.BuildOurRefIndex(EventData.Transaction.thOurRef));
      if Res = 0 then
        with Transaction.Update do
        begin
          with thLines[1] do
          begin
            tlNetValue := tlNetValue - 1;
            CalcVatAmount;
          end;

          Save(True);
        end;
      CloseToolkit;
    end;
    oToolkit := nil;
  end;

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
