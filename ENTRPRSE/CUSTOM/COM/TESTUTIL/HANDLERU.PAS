unit HandlerU;

{ Hook Customisation Unit - Allows standard Enterprise behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Dialogs, SysUtils, ChainU;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  esEnabled = EventEnabled;

  wiTransaction = EnterpriseBase + 2000;
  wiTransLine   = EnterpriseBase + 4000;


{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Begin
  CustomOn := True;

  With CustomHandlers Do Begin
    { Trans Head - Exit Account - Set Delivery Address }
    SetHandlerStatus (wiTransaction, 9, esEnabled);

    { Trans Head - Period Hooks }
    SetHandlerStatus (wiTransaction, 8,  esEnabled);  { Exit - Period/Year }
    SetHandlerStatus (wiTransaction, 80, esEnabled);  { Set Period/Year from TransDate }
    SetHandlerStatus (wiTransaction, 81, esEnabled);  { Set TransDate from Period/Year }

    { Trans Line - Set Stock Code }
    SetHandlerStatus (wiTransLine, 15, esEnabled);

    { Trans Line - Enter Unit Price }
    SetHandlerStatus (wiTransLine, 9, esEnabled);

    { Trans Line - Exit Cost Centre }
    SetHandlerStatus (wiTransLine, 16, esEnabled);

    { Trans Line - Exit Department }
    SetHandlerStatus (wiTransLine, 17, esEnabled);

    { Sales Trans - Custom Button 1 + 2 }
    SetHandlerStatus (wiTransaction, 31, esEnabled);   { Add/Edit }
    SetHandlerStatus (wiTransaction, 32, esEnabled);   { Add/Edit }
    SetHandlerStatus (wiTransaction, 131, esEnabled);  { View }
    SetHandlerStatus (wiTransaction, 132, esEnabled);  { View }

    { Purchase Trans - Custom Button 1 + 2 }
    SetHandlerStatus (wiTransaction, 41, esEnabled);   { Add/Edit }
    SetHandlerStatus (wiTransaction, 42, esEnabled);   { Add/Edit }
    SetHandlerStatus (wiTransaction, 141, esEnabled);  { View }
    SetHandlerStatus (wiTransaction, 142, esEnabled);  { View }

    AddAboutString ('Hook Test DLL v1.00');
  End; { With CustomHandlers }

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
  With EventData Do Begin
    Try
      //ListBox1.Items.Add (Format('%10.10d  %3.3d', [WindowId, HandlerId]));

      Case WinId Of
        wiTransaction : Case HandlerId Of
                          { TH - Exit Period/Year }
                          8   : Begin
                                  Transaction.thPeriod := 7;  { July }
                                  Transaction.thYear := 105;  { 2005 }
                                End;
                          { TH - Exit Account Code - Set Delivery Address }
                          9   : Begin
                                  Transaction.thDelAddr[1] := 'Deliver To Sandra';
                                  Transaction.thDelAddr[2] := 'c/o Exchequer Software Ltd';
                                  Transaction.thDelAddr[3] := 'Exchequer Grange';
                                  Transaction.thDelAddr[4] := 'Wootton Gardens';
                                  Transaction.thDelAddr[5] := 'Bournemouth, BH1 1PW';
                                End;
                          { Sales Daybook - Custom Button 1 }
                          10  : Begin
                                  Transaction.thUser1 := 'THUD1a';
                                  Transaction.thUser2 := 'THUD2a';
                                  Transaction.thUser3 := 'THUD3a';
                                  Transaction.thUser4 := 'THUD4a';

                                  Transaction.thDelAddr[1] := 'Deliver To Jim';
                                  Transaction.thDelAddr[2] := 'At Jim''s House';
                                  Transaction.thDelAddr[3] := 'On Wednesday Morning';
                                  Transaction.thDelAddr[4] := '(Before 9am)';
                                  Transaction.thDelAddr[5] := '';
                                End;
                          { Sales Daybook - Custom Button 2 }
                          20  : Begin
                                  Transaction.thUser1 := 'THUD1b';
                                  Transaction.thUser2 := 'THUD2b';
                                  Transaction.thUser3 := 'THUD3b';
                                  Transaction.thUser4 := 'THUD4b';

                                  Transaction.thDelAddr[1] := 'Deliver To Neil';
                                  Transaction.thDelAddr[2] := 'At Neil''s House';
                                  Transaction.thDelAddr[3] := 'On Thursday Evening';
                                  Transaction.thDelAddr[4] := '(After 7pm)';
                                  Transaction.thDelAddr[5] := '';
                                End;
                          { TH - Edit Trans Custom Button 1 }
                          31,
                          41  : Transaction.thDelAddr[1] := 'CustBtn1 (Edit)';
                          { TH - Edit Trans Custom Button 2 }
                          32,
                          42  : Transaction.thDelAddr[2] := 'CustBtn2 (Edit)';
                          { TH - View Trans Custom Button 1 }
                          131,
                          141 : Transaction.thDelAddr[3] := 'CustBtn1 (View)';
                          { TH - View Trans Custom Button 2 }
                          132,
                          142 : Transaction.thDelAddr[4] := 'CustBtn2 (View)';

                          { TH - Set Period/Year from TransDate }
                          80  : Begin
                                  Transaction.thPeriod := 6;  { June }
                                  Transaction.thYear := 104;  { 2004 }
                                End;
                          { TH - Set TransDate from Period/Year }
                          81  : Begin
                                  Transaction.thTransDate := '19860518';  { 18/05/1986 }
                                End;
                        End; { Case HandlerId }

        wiTransLine   : Case HandlerId Of
                          { Trans Line - Enter Unit Price }
                          9   : Transaction.thLines.thCurrentLine.tlNetValue := 1.23;

                          { TL - Exit Stock Code - Before Validation }
                          15  : With Transaction.thLines.thCurrentLine Do
                                  If (Trim(tlStockCode) = '') Then
                                    tlStockCode := 'BLUE';

                          { Trans Line - Exit Cost Centre }
                          16  : Transaction.thLines.thCurrentLine.tlCostCentre := 'HM1';

                          { Trans Line - Exit Department }
                          17  : Transaction.thLines.thCurrentLine.tlDepartment := 'HM2';
                        End; { Case HandlerId }
      Else
        ShowMessage (Format('Hooky-Hooky: %d.%d', [WinId,HandlerId]));
      End; { Case WinId }
    Except
      On Ex:Exception Do
        MessageDlg (Format('The following error occured processing Hook (%d.%d):-', [WinId,HandlerId]) + #13#13 + Ex.Message, mtError, [mbOk], 0);
    End;
  End; { With EnterpriseSystem }

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

end.
