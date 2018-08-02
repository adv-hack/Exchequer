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
  Procedure LocalMessageDlg(const sMessage : string);

implementation

Uses
  Dialogs, SysUtils, ChainU, PIMisc;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  iEID : byte;
  iPos : integer;
  slAboutText : TStringList;
const
  sPlugInName = 'Exchequer Metro Date Plug-In';
  sVersionNo = 'v5.00.002';
begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Set About Message }
    slAboutText := TStringList.Create;
    PIMakeAboutText(sPlugInName, sVersionNo + ' (DLL)', slAboutText);
    for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
    slAboutText.Free;

    // Enable Hook
    SetHandlerStatus(EnterpriseBase + 4000, 57, EventEnabled); // Do not override TX Line date
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

{Callback Procedure used to show the error messages}
Procedure LocalMessageDlg(const sMessage : string);
begin
  MessageDlg(sMessage, mtWarning, [mbOK], 0);
end;

end.
