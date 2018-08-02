unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CustWinU, CustAbsU, Classes;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Dialogs, SysUtils, ChainU, PISecure, PIMisc;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

var
  bPlugInEnabled : Boolean;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iEID : byte;
  iPos : integer;
  slAboutText : TStringList;
const
  sPlugInName = 'Populate Job Charge Plug-In';
  {$IFDEF EX600}
    sVersionNo = 'v6.00.003';
  {$ELSE}
    sVersionNo = 'v5.71.003';
  {$ENDIF}
begin
  CustomOn := True;

  //Check Plug-In Security
  bPlugInEnabled := PICheckSecurity('EXCHCOMMXL000076', 'kK,m`de dw!hee3(', sPlugInName
  , sVersionNo + ' (DLL)', stSystemOnly, ptDLL, DLLChain.ModuleName);

  If bPlugInEnabled Then
  With CustomHandlers Do Begin
    { Set About Message }
    slAboutText := TStringList.Create;
    PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
    for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
    slAboutText.Free;

    // Enable Hook
    SetHandlerStatus(EnterpriseBase + 5000, 60, EventEnabled); // Job Costing - Auto Calc Charge Switch
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
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
