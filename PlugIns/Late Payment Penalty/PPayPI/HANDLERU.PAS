unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  Math, ComObj, APIUtil, CustWinU, CustAbsU, Classes, Controls, PISecure
  , MathUtil, Options, Types, PPayProc, Enterprise01_TLB, BTFile;

var
  iHookId : integer;
  bHookEnabled : boolean;

  { Following functions required to be Exported by Enterprise }
  Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers); Export;
  Procedure TermCustomHandler; Export;
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Dialogs, SysUtils, ChainU, PIMisc, Forms, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
type
  THookPointRec = record
    WindowID : integer;
    HandlerID : integer;
  end;
const
  NO_OF_HOOK_POINTS = 1;
  sPlugInName = 'Exchequer Late Payment Penalty Plug-In';
  {$IFDEF EX600}
    //sVersionNo = 'v6.00.019';
    sVersionNo = '021';
  {$ELSE}
    sVersionNo = 'v5.71.019';
  {$ENDIF}
var
  iEID : byte;
  iHook, iPos : integer;
  slAboutText : TStringList;
  aHookPoints : array [1..NO_OF_HOOK_POINTS] of THookPointRec;
begin
  CustomOn := True;

  //Check Plug-In Security
  bHookEnabled := PICheckSecurity('EXCHPROPAY000018', '~$ggkj-Q-d36@6fa', sPlugInName, '', stSystemOnly, ptDLL, DLLChain.ModuleName);

  if bHookEnabled then begin

    With TAbsCustomHandlers01(CustomHandlers) Do Begin
      { Set About Message }
      slAboutText := TStringList.Create;
      PIMakeAboutText(sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)', slAboutText);
      for iPos := 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);

      // Detect if Custom button1 is already in use.
      iHookId := -1;
      if (not HookPointEnabled(wiTransaction, 10)) then iHookId := 10
      else begin
//        if (not HookPointEnabled(wiTransaction, 20)) then iHookId := 20
//        then iHookId := 20;
        iHookId := 20;
      end;

      // Custom Button Sales DayBook
      aHookPoints[1].WindowID := wiTransaction;
      aHookPoints[1].HandlerID := iHookId;

      // Enable Hooks
      For iHook := 1 to NO_OF_HOOK_POINTS do begin
        SetHandlerStatus(aHookPoints[iHook].WindowID, aHookPoints[iHook].HandlerID, EventEnabled);
      end;{for}

      slAboutText.Free;
    End; { With }
  end;{if}

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
{var
  iPos : integer;
  sString : string;

var
  WinPoint     : TPoint;}

Begin
  if bHookEnabled then begin

    { Handle Hook Events here }
    With EventData Do Begin
      // A 'Hook Event' has occured
      Case WinId Of
        wiTransaction : begin
          // Custom Button Sales DayBook
          if HandlerId = iHookId then
          begin
//            Showmessage('2000.' + IntToStr(iHookId));

            // Supply details of active window in Enterprise for better positioning of popup list
//            WinPoint := Application.MainForm.ClientToScreen(Point(Screen.ActiveForm.Left, Screen.ActiveForm.Top));
//            GetCursorPos(WinPoint);

            CompanyRec.Path := EventData.Setup.ssDataPath;

            with TFrmOptions.Create(application) do begin
              Left := mouse.CursorPos.X;
              Top := mouse.CursorPos.Y;
              LEventData := EventData;
              Showmodal;
              Release;
            end;{with}
          end;{if}
        end;
      end;{case}
    end;{with}
  end;{if}

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
