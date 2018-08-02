unit oClient;

{$WARN SYMBOL_PLATFORM OFF}

interface

uses
  ComObj, ActiveX, StdVcl,
  EnterpriseTrade_TLB,      // Trade Counter Customisation Type Library
  EnterpriseTC_TLB;         // D6 Client Type Library

type
  TD6Client = class(TAutoObject, ID6Client, ITradeClient)
  private
    lBaseData : ITradeConnectionPoint;
  protected
    // ID6Client
    // No Implementation

    // ITradeClient
    procedure OnConfigure(const Config: ITradeConfiguration); safecall;
    procedure OnStartup(const BaseData: ITradeConnectionPoint); safecall;
    procedure OnCustomEvent(const EventData: ITradeEventData); safecall;
    procedure OnCustomText(const CustomText: ITradeCustomText); safecall;
    procedure OnShutdown; safecall;

    // Local Methods
  Public
  end;

implementation

uses ComServ, Dialogs, Forms, SysUtils, Windows, ConfigF;

//----------------------------------------------------------------------------

// Called by Trade Counter when the user clicks the optional Setup button in Help|About
procedure TD6Client.OnConfigure(const Config: ITradeConfiguration);
begin
  // Create configuration window
  With TfrmPlugInconfiguration.Create(Application) Do
    Try
      // setup a local reference to the Config object
      lTradeConfig := Config;
      lBaseData := Self.lBaseData;

      // Display the Config window
      ShowModal;

      // Remove local reference to Config object and destroy the window
      lTradeConfig := NIL;
    Finally
      Free;
    End;

    // Return window focus back to the Trade Counter
    SetForegroundWindow(lBaseData.Functions.fnTradehWnd);
end;

//----------------------------------------------------------------------------

procedure TD6Client.OnStartup(const BaseData: ITradeConnectionPoint);
begin
  // Make local reference to Base Object within the Trade Counter Customisation System
  // NOTE: Reference MUST be removed in OnShutdown
  lBaseData := BaseData;

  // Using the Base Object setup the Help|About info and define the Hooks/Text to be used
  With lBaseData Do Begin
    // Define the Customisation Features supported by this Plug-In
    piCustomisationSupport := 'v1.00/CONFIG';

    // Setup properties for Help|About Display in Trade Counter
    piName := 'Trade Counter Test Client (D6)';
    piVersion := 'v5.00.002 (D6-EXE)';
    piAuthor := 'Exchequer Software Ltd.';
    piCopyright := 'Copyright © Exchequer Software Ltd 1986-2002';
    piSupport := 'Contact your Enterprise helpline number';

    // Enable Hook Points
    piHookPoints [twiTransaction, 1] := thsEnabled;       // Exit Edit1

    // Custom Button 1
    piHookPoints [twiTransaction, 101] := thsEnabled;     // Enable Hook Point
    piCustomText [twiTransaction, 101] := thsEnabled;     // Enable Custom Text

    // Custom Button 2
    piHookPoints [twiTransaction, 102] := thsEnabled;     // Enable Hook Point
    piCustomText [twiTransaction, 102] := thsEnabled;     // Enable Custom Text
  End; { With lBaseData }
end;

//----------------------------------------------------------------------------

// Called by Trade Counter whenever an enabled Hook Point is reached
procedure TD6Client.OnCustomEvent(const EventData: ITradeEventData);
begin
  With EventData Do Begin
    If (edWindowId = twiTransaction) And (edHandlerId = 1) Then
      // Exit Edit 1
      Transaction.Edit1 := FormatDateTime('HH:MM', Now)
    Else
      If (edWindowId = twiTransaction) And (edHandlerId = 101) Then Begin
        // Custom Button 1
        Transaction.Edit1 := 'CuBtn1';
        Transaction.Edit2 := '';
        Transaction.Edit3 := '';
      End { If }
      Else
        If (edWindowId = twiTransaction) And (edHandlerId = 102) Then Begin
          // Custom Button 1
          Transaction.Edit1 := '';
          Transaction.Edit2 := 'CuBtn2';
          Transaction.Edit3 := '';
        End; { If }
  End; { With EventData }
end;

//----------------------------------------------------------------------------

// Called by Trade Counter for Label Customisation e.g. Custom Buttons
procedure TD6Client.OnCustomText(const CustomText: ITradeCustomText);
begin
  With CustomText Do
    If (ctWindowId = twiTransaction) And (ctTextId = 101) Then
      // Custom Button 1 Caption
      ctText := 'Btn1'
    Else
      If (ctWindowId = twiTransaction) And (ctTextId = 102) Then
        // Custom Button 2 Caption
        ctText := 'Btn2'
end;

//----------------------------------------------------------------------------

procedure TD6Client.OnShutdown;
begin
  // Remove reference to permanent connection object otherwise the
  // Trade Counter won't unload properly
  lBaseData := NIL;
end;

//----------------------------------------------------------------------------

initialization
  TAutoObjectFactory.Create(ComServer, TD6Client, Class_D6Client,
    ciSingleInstance, tmApartment);
end.

