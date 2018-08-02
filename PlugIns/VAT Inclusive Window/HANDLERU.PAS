unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Classes, Controls, Forms, StdCtrls, TEditVal, CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

Var
  bPlugInEnabled : Boolean = False;

implementation

Uses Dialogs, SysUtils, ChainU, VatInfoW, PISecure, PIMisc, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn : Boolean; CustomHandlers : TAbsCustomHandlers);
const
  sPlugInName = 'Exchequer VAT Inclusive Window Plug-In';
  {$IFDEF EX600}
     // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
    sVersionNo = '205';
//    sVersionNo = 'v6.00.203';
  {$ELSE}
    sVersionNo = 'v5.71.203';
  {$ENDIF}
Var
  slAboutText : TStringList;
  iPos        :  Byte;
Begin                                     
  CustomOn := True;


  bPlugInEnabled := PICheckSecurity('EXCHVATWIN000008',
                                    'Dj2RTfqb*$24&FDa',
                                    sPlugInName,
                                    '',
                                    stSystemOnly,
                                    ptDll,
                                    DLLChain.ModuleName);
  If bPlugInEnabled Then
    With CustomHandlers Do Begin
      // Set about text
      slAboutText := TStringList.Create;
      Try
        PIMakeAboutText (sPlugInName, ExchequerModuleVersion (emGenericPlugIn, sVersionNo) + ' (DLL)' , slAboutText);
        For iPos := 0 To Pred(slAboutText.Count) Do
          AddAboutString (slAboutText[IPos]);
      Finally
        FreeAndNIL (slAboutText);
      End;

      { Define Handlers }
      {SetHandlerStatus(EnterpriseBase + 4000, 3, EventEnabled); { Quantity Exit }
      {SetHandlerStatus(EnterpriseBase + 4000, 4, EventEnabled); { Discount  }
      {SetHandlerStatus(EnterpriseBase + 4000, 5, EventEnabled); { Unit Price }
      {SetHandlerStatus(EnterpriseBase + 4000, 6, EventEnabled); { Vat }
      SetHandlerStatus(EnterpriseBase + 4000, 7, EventEnabled); { Form Closing }
      SetHandlerStatus(EnterpriseBase + 4000, 8, EventEnabled); { Form Displayed }
      SetHandlerStatus(EnterpriseBase + 4000, 26, EventEnabled); { VAT Calculated }
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

//---------------------------------------------------------------------------

{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Var
  ActForm : TForm;
Begin
  { Handle Hook Events here }
  If bPlugInEnabled And (EventData.WinId = wiTransLine) Then
    With EventData, Transaction Do
      If (thInvDocHed In [cuSor, cuSin]) Then Begin
        Case HandlerId Of
          26,
          3..6 : Begin
                   If Assigned(frmVATInfo) Then Begin
                     { Display details }
                     frmVATInfo.UpdateInfo(EventData);
                   End; { If }
                 End;

          7    : Begin
                   If Assigned(frmVATInfo) Then Begin
                     frmVATInfo.Close;
                     frmVATInfo.Free;
                     frmVATInfo := NIL;
                   End; { If }
                 End;

          8    : Begin
                   If Not Assigned(frmVATInfo) Then Begin
                     ActForm := Screen.ActiveForm;

                     frmVATInfo := TfrmVATInfo.Create(Application.MainForm);
                     frmVATInfo.Refresh;

                     ActForm.Show;
                     ActForm.Refresh;
                   End; { If }
                 End;
        End; { Case HandlerId }
      End; { If (thInvDocHed In [cuSor, cuSin]) }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
