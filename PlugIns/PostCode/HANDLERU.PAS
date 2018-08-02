unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Dialogs, SysUtils, ChainU, Classes, PIMISC, PISecure, uAFDCode;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  {$IFDEF EX600}
    sVersionNo = 'v6.00.001';
  {$ELSE}
    sVersionNo = 'b5.00.001';
  {$ENDIF}

var
bPlugInEnabled: boolean;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
var
  slAboutText: TStringList;
  iPos: integer;
Begin
  CustomOn := False;

  bPlugInEnabled:= PICheckSecurity('EXCHAFDPCD000011', 'GEdfu6fgYRweVmnU'
  , 'Exchequer AFD PostCode Plug-In', sVersionNo + ' (DLL)', stSystemOnly, ptDLL
  , DLLChain.ModuleName);

  if bPlugInEnabled then with CustomHandlers do
  begin
    slAboutText:= TStringList.Create;
    with slAboutText do
    try
      PIMakeAboutText('Exchequer AFD PostCode Plug-In', sVersionNo + ' (DLL)', slAboutText);
      for iPos:= 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
    finally
      Free;
    end;

    SetHandlerStatus(wiAccount, 105, EventEnabled); // set customer postcode hook
    SetHandlerStatus(wiAccount, 106, EventEnabled); // set supplier postcode hook
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
  if bPlugInEnabled then with EventData do
  begin
    if (WinID = wiAccount) and (HandlerID in [105, 106]) then with TAFDPostcode.Create do
    try
      DoPostcode(EventData);
    except
      Free;
    end;
  end;

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
