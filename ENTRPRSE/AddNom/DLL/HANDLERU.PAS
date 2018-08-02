unit HandlerU;

{ Hook Customisation Unit - Allows standard Exchequer behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses
  AddNomPROC, CustWinU, CustAbsU;

{ Following functions required to be Exported by Exchequer }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses
  Windows, AddNomWizard, Dialogs, Forms, SysUtils, ChainU, IntegrationF;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

{ Called by Exchequer to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers01);
Begin
  CustomOn := False;
  frmAddNomWizard := nil;


  { Enable Hooks and Set About Message here }
  With CustomHandlers Do
  Begin
    AddAboutString('Add Journal Wizard');
    AddAboutString(StringOfChar('-',79));
    AddAboutString('');

//    SetHandlerStatus(wiTransaction, 10, EventEnabled);
    SetHandlerStatus(wiTransaction, 157, EventEnabled);
  End; // With CustomHandlers

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

{ Called by Exchequer to End the Customisation }
Procedure TermCustomHandler;
Begin
  if (frmAddNomWizard <> nil) and (frmAddNomWizard.Visible) then
  begin
    frmAddNomWizard.Close;
//    frmAddNomWizard.Release;
//    frmAddNomWizard := nil;
  end;

  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

{ Called by Exchequer whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
var
  hTemp : Hwnd;
Begin
  { Handle Hook Events here }
  With EventData Do
  Begin
    If (WinId = wiTransaction) And (HandlerId = {10}157) Then
    Begin
      StartToolkit(EventData);

      hTemp := screen.activeform.handle;

      if frmAddNomWizard = nil
      then frmAddNomWizard := TfrmAddNomWizard.Create(Application.MainForm)
      else frmAddNomWizard.BringToFront;
      frmAddNomWizard.hNomDaybookHandle := hTemp;

      boResult := FALSE;
//      ShowMessage(IntToStr(IntResult));

//      With TfrmAddNomWizard := TfrmAddNomWizard.Create(Application.MainForm) Do
//      Begin
//      End; // With TfrmIntegration.Create(Application.MainForm)
    End; // If (WinId = wiTransaction) And (HandlerId = 10)
  End; // With EventData

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
