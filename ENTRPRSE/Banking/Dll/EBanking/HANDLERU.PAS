unit HandlerU;

{ Hook Customisation Unit - Allows standard Exchequer behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

{ Following functions required to be Exported by Exchequer }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Dialogs, Forms, SysUtils, ChainU, BankList, Classes;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Exchequer to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Begin
  CustomOn := False;
  frmBankList := nil;


  { Enable Hooks and Set About Message here }
  With CustomHandlers Do
  Begin
    AddAboutString('eBanking Module');
    AddAboutString(StringOfChar('-',79));
    AddAboutString('');

    SetHandlerStatus(wiTransaction, 10, EventEnabled);
    SetHandlerStatus(wiMisc + 2, 10, EventEnabled);
  End; // With CustomHandlers

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Exchequer to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

procedure FormClosed(Sender : TObject);
//Called from the form's OnClose event so we can set it to nil
begin
  frmBankList := nil;
end;

{ Called by Exchequer whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  With EventData Do
  Begin
    If ((WinId = wiTransaction) or (WinID = wiMisc + 2))And (HandlerId = 10) Then
    Begin
      StartToolkit(EventData.Setup.ssDataPath, WinID <> wiTransaction);
      if (WinId = wiTransaction) then
      begin
        if frmBankList = nil then
        begin
          frmBankList := TfrmBankList.Create(Application.MainForm);
          frmBankList.OnFormClosed := FormClosed;
        end;

        frmBankList.LoadList;
        frmBankList.BringToFront;
      end;
    End; // If (WinId = wiTransaction) And (HandlerId = 10)
  End; // With EventData

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
