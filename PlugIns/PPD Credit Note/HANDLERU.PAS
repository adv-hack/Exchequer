unit HandlerU;

{ Hook Customisation Unit - Allows standard Exchequer behaviour to }
{                           be modified by calling code in the DLL  }

interface

Uses CustWinU, CustAbsU;

Const
  sPlugInTitle = 'Exchequer PPD Credit Note Plug-In';
  sVersionNo = 'v7.0.13.003';

Var
  iCustomerButton : Integer;
  iCustomerLabel : Integer;
  iSupplierButton : Integer;
  iSupplierLabel : Integer;


{ Following functions required to be Exported by Exchequer }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); Export;

implementation

Uses Classes, Dialogs, SysUtils, PIMisc, ChainU, TakePPDF;

Const
  EventDisabled = 0;
  EventEnabled  = 1;

//=========================================================================

{ Called by Exchequer to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
Const
  CustomerButtons : Array [1..6] of Integer = (120, 121, 145, 146, 147, 148);
  SupplierButtons : Array [1..6] of Integer = (130, 131, 155, 156, 157, 158);

Var
  slAboutText: TStringList;
  iPos: integer;
Begin
  CustomOn := False;

  { Enable Hooks and Set About Message here }
  With TAbsCustomHandlers01(CustomHandlers) Do
  Begin
    slAboutText:= TStringList.Create;
    with slAboutText do
    try
      PIMakeAboutText(sPlugInTitle, sVersionNo + ' (DLL)', slAboutText);
      for iPos:= 0 to slAboutText.Count - 1 do AddAboutString(slAboutText[iPos]);
    finally
      Free;
    end;

    // Check for Custom Button availability

    // Customer Ledger
    iCustomerButton := -1;
    For iPos := Low(CustomerButtons) To High(CustomerButtons) Do
    Begin
      If (Not HookPointEnabled(wiAccount, CustomerButtons[iPos])) Then
      Begin
        // Custom Button available
        iCustomerButton := CustomerButtons[iPos];
        Break;
      End // If (Not HookPointEnabled(wiAccount, CustomerButtons[iPos])) 
    End; // For iPos
    iCustomerLabel := iCustomerButton;

    // Supplier Ledger
    iSupplierButton := -1;
    For iPos := Low(SupplierButtons) To High(SupplierButtons) Do
    Begin
      If (Not HookPointEnabled(wiAccount, SupplierButtons[iPos])) Then
      Begin
        // Custom Button available
        iSupplierButton := SupplierButtons[iPos];
        Break;
      End // If (Not HookPointEnabled(wiAccount, SupplierButtons[iPos]))
    End; // For iPos
    iSupplierLabel := iSupplierButton;

    If (iCustomerButton <> -1) Then
      SetHandlerStatus(wiAccount, iCustomerButton, EventEnabled);
    If (iSupplierButton <> -1) Then
      SetHandlerStatus(wiAccount, iSupplierButton, EventEnabled);
  End; // With CustomHandlers

  { Call other Hook DLL's to get their customisation }
  DLLChain.InitCustomHandler(CustomOn, CustomHandlers);
End;

//-------------------------------------------------------------------------

{ Called by Exchequer to End the Customisation }
Procedure TermCustomHandler;
Begin
  { Notify other Hook DLL's to Terminate }
  DLLChain.TermCustomHandler;

  { Put Shutdown Code Here }
End;

//-------------------------------------------------------------------------

{ Called by Exchequer whenever a Customised Event happens }
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem);
Begin
  { Handle Hook Events here }
  If (EventData.WinId = wiAccount) And (EventData.HandlerId = iCustomerButton) Then
  Begin
    // Customer Ledger - Give PPD
    DisplayPPDDialog (moCustomer, EventData);
  End // If (EventData.WinId = wiAccount) And (EventData.HandlerId = iCustomerButton)
  Else If (EventData.WinId = wiAccount) And (EventData.HandlerId = iSupplierButton) Then
  Begin
    // Supplier Ledger - Take PPD
    DisplayPPDDialog (moSupplier, EventData);
  End // If (EventData.WinId = wiAccount) And (EventData.HandlerId = iSupplierButton)
  Else
    // Pass onto other Hook DLL's
    DLLChain.ExecCustomHandler(EventData);
End;

//=========================================================================

end.
