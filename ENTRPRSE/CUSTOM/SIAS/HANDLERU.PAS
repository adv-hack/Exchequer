unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses Controls, Forms, StdCtrls, TEditVal, CustWinU, CustAbsU;


{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU, LineDlg;

Const
  EventDisabled = 0;
  EventEnabled  = 1;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Var
  n  :  Byte;

Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Define About Box Message }
    AddAboutString ('SIAS Foods Line Window');
    AddAboutString ('Copyright Exchequer Software Ltd. 1986 - 1999.');
    AddAboutString ('Version: 1.00');

    { Define Handlers }
    SetHandlerStatus(EnterpriseBase + 4000, 10, EventEnabled); { Form Closing }

    { Call other Hook DLL's to get their customisation }
    DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
  End; { With }
End;


{ Called by Enterprise to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;


{ Called by ExecCustomHandler to control Inv Events }
Procedure InvLineHooks(Const EventData : TAbsEnterpriseSystem);
Var
  frmSIASLine : TfrmSIASLine;
Begin { InvLineHooks }
  With EventData, Transaction, thLines.thCurrentLine Do Begin
    If (thInvDocHed In [cuPJI, cuPJC, cuNMT]) Then Begin
      Case EventData.HandlerId Of
        10   : Begin
                 frmSIASLine := TfrmSIASLine.Create(Application.MainForm);
                 Try
                   With frmSIASLine Do Begin
                     Caption := 'SIAS Details: ' + thOurRef;

                     edtRawMat.Text := Trim(Copy(tlJobCode, 1, 6));
                     edtBatchRef.Text := Trim(Copy(tlJobAnal, 1, 6));
                     ccyWeight.Value := tlUnitWeight;

                     IsNom := (thInvDocHed = cuNMT);

                     ShowModal;

                     tlJobCode := Copy (edtRawMat.Text, 1, 6);
                     tlJobAnal := Copy (edtBatchRef.Text, 1, 6);
                     tlUnitWeight := Round(ccyWeight.Value);
                   End; { With }
                 Finally
                   frmSIASLine.Free;
                 End;
               End;
      End; { Case }
    End; { If }
  End; { With }
End; { InvLineHooks }


{ Called by Enterprise whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  Case EventData.WinId Of
    { Miscellaneous Events }
     EnterpriseBase + 4000 : InvLineHooks(EventData);
  End; { Case }


  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
