// Plug-In Interface Unit for Trade Counter Customisation
unit oTrade;

{$WARN SYMBOL_PLATFORM OFF}

interface

{$IFNDEF TCCU}  // Trade Counter Customisation
   This module should not be included within the application being compiled
{$ENDIF}

uses
  ComObj, ActiveX, EnterpriseTrade_TLB, StdVcl, oHookPnt, oEvent;

type
  TTradeConnectionPoint = class(TAutoIntfObject, ITradeConnectionPoint)
  private
    // Handle to the COM interface implemented by this object - this stops it being
    // destroyed until its OK to be destroyed.  Effectively makes it self-destroying!
    FConnectionPointI : ITradeConnectionPoint;
    // Local Hook Points object to keep track of points used by this Plug-In
    FHookPoints : THookPointStatus;
    // Reference to Global Hook Points object to allow checks on hook points enabled by other Plug-Ins
    FGlobalHookPoints : THookPointStatus;
    // Local CustomText object to keep track of text used by this Plug-In
    FCustomText : THookPointStatus;
    // Reference to Global CustomText object to allow checks on CustomText enabled by other Plug-Ins
    FGlobalCustomText : THookPointStatus;
    // Classname of COM Plug-In - kept for Error Messages
    FClassName : ShortString;
    // Handle to the Plug-In this object controls
    FPlugInI : ITradeClient;
    // Handle to global Functions object
    FFunctionsI : ITradeFunctions;
    // Handle to global SystemSetup object
    FSystemSetupI : ITradeSystemSetup;
    // Handle to global UserProfile object
    FUserProfileI : ITradeUserProfile;
    // Handle to global Version object
    FVersionI : ITradeVersion;
    // Customisation Support of Plug-In
    FCustomisationSupport : ShortString;
    // Help|About Info for Plug-In
    FPlugInName,
    FPlugInVersion,
    FPlugInAuthor,
    FPlugInSupportMsg,
    FPlugInCopyright   : ShortString;
  protected
    // ITradeConnectionPoint
    function Get_piCustomisationSupport: WideString; safecall;
    procedure Set_piCustomisationSupport(const Value: WideString); safecall;
    function Get_piName: WideString; safecall;
    procedure Set_piName(const Value: WideString); safecall;
    function Get_piVersion: WideString; safecall;
    procedure Set_piVersion(const Value: WideString); safecall;
    function Get_piAuthor: WideString; safecall;
    procedure Set_piAuthor(const Value: WideString); safecall;
    function Get_piSupport: WideString; safecall;
    procedure Set_piSupport(const Value: WideString); safecall;
    function Get_piCopyright: WideString; safecall;
    procedure Set_piCopyright(const Value: WideString); safecall;
    function Get_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus; safecall;
    procedure Set_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer;
                               Value: TTradeHookStatus); safecall;
    function Get_piCustomText(WindowId: TTradeWindowIds; TextId: Integer): TTradeHookStatus; safecall;
    procedure Set_piCustomText(WindowId: TTradeWindowIds; TextId: Integer; Value: TTradeHookStatus); safecall;
    function Get_Functions: ITradeFunctions; safecall;
    function Get_SystemSetup: ITradeSystemSetup; safecall;
    function Get_Version: ITradeVersion; safecall;
    function Get_UserProfile: ITradeUserProfile; safecall;

    // Local methods
    Procedure RaiseException (Const Location, ExceptText : ANSIString);
  public
    Property piClassName : ShortString Read FClassName;
    Property piName : ShortString Read FPlugInName;
    Property piVersion : ShortString Read FPlugInVersion;
    Property piAuthor : ShortString Read FPlugInAuthor;
    Property piSupportMsg : ShortString Read FPlugInSupportMsg;
    Property piCopyright : ShortString Read FPlugInCopyright;
    Property piCustomisationSupport : ShortString Read FCustomisationSupport;

    Constructor Create (ClassName                            : ShortString;
                        iPlugIn                              : ITradeClient;
                        iFunctions                           : ITradeFunctions;
                        iSystemSetup                         : ITradeSystemSetup;
                        iUserProfile                         : ITradeUserProfile;
                        iVersion                             : ITradeVersion;
                        oGlobalHookPoints, oGlobalCustomText : THookPointStatus);
    Destructor Destroy; override;

    // Calls the OnStartup method on the Plug-In
    Procedure Startup;
    // Calls the OnShutdown method on the Plug-In
    Procedure ShutDown;
    // Closes down the Plug-In wrapper
    Procedure Finish;
    // Calls the OnCustomEvent method on the Plug-In
    Procedure CustomEvent (iEventData : ITradeEventData);
    // Calls the OnCustomText method on the Plug-In to retrieve CustomText
    Procedure CustomText (iCustomText : ITradeCustomText);
    // Calls the OnConfigure method on the Plug-In
    Procedure Configure (hWnd : THandle);
  end;

implementation

uses ComServ, SysUtils, oConfig, CustIntU;

//---------------------------------------------------------------------------

Constructor TTradeConnectionPoint.Create (ClassName                            : ShortString;
                                          iPlugIn                              : ITradeClient;
                                          iFunctions                           : ITradeFunctions;
                                          iSystemSetup                         : ITradeSystemSetup;
                                          iUserProfile                         : ITradeUserProfile;
                                          iVersion                             : ITradeVersion;
                                          oGlobalHookPoints, oGlobalCustomText : THookPointStatus);
Begin { Create }
  Inherited Create (ComServer.TypeLib, ITradeConnectionPoint);

  // Store Reference handle to self to prevent it being destroyed before its time
  FConnectionPointI := Self;

  // Create Local Hook Points object
  FHookPoints := THookPointStatus.Create;

  // Create Local CustomText object
  FCustomText := THookPointStatus.Create;

  // Take local copies of parameters for later use
  FClassName := ClassName;
  FPlugInI := iPlugIn;
  FFunctionsI := iFunctions;
  FSystemSetupI := iSystemSetup;
  FUserProfileI := iUserProfile;
  FVersionI := iVersion;
  FGlobalHookPoints := oGlobalHookPoints;
  FGlobalCustomText := oGlobalCustomText;

  // Plug-In Properties (Should be set by Plug-In during OnStartup)
  FCustomisationSupport := 'v1.00';
  FPlugInName := ClassName;
  FPlugInVersion := 'Unknown';
  FPlugInAuthor := 'Unknown';
  FPlugInSupportMsg := '';
  FPlugInCopyright := '';
End; { Create }

//---------------------------------------------------------------------------

Destructor TTradeConnectionPoint.Destroy;
Begin { Destroy }
  // Destroy Local Hook Points object (NOTE: Normal Delphi Object not a COM Object)
  FreeAndNIL(FHookPoints);

  // Destroy Local CustomText object (NOTE: Normal Delphi Object not a COM Object)
  FreeAndNIL(FCustomText);

  // Remove references to global sub-objects
  FFunctionsI := NIL;
  FSystemSetupI := NIL;
  FVersionI := NIL;
  FGlobalHookPoints := NIL;
  FGlobalCustomText := NIL;

  // Remove reference to Plug-In - Should have been already reset in Finish
  // method but better safe than sorry
  FPlugInI := NIL;

  // Remove reference to self - technically we can't get to this point with it set
  // but who ever trusts compilers to produce technically correct code!
  FConnectionPointI := NIL;

  Inherited;
End; { Destroy }

//---------------------------------------------------------------------------

Procedure TTradeConnectionPoint.RaiseException (Const Location, ExceptText : ANSIString);
Begin { RaiseException }
  Raise Exception.Create ('The error ' + QuotedStr(ExceptText) +
                          ' occurred in ' + QuotedStr(Location) +
                          ' for the Plug-In ' + QuotedStr(FClassName) +
                          ' - please notify your Technical Support');
End; { RaiseException }

//---------------------------------------------------------------------------

// Calls the OnConfigure method on the Plug-In
Procedure TTradeConnectionPoint.Configure (hWnd : THandle);
Var
  TradeConfigO : TTradeConfiguration;
  TradeConfigI : ITradeConfiguration;
Begin { Configure }
  // Create Configuration Object and make a local reference to the COM Interface
  TradeConfigO := TTradeConfiguration.Create;
  TradeConfigI := TradeConfigO;
  Try
    Try
      // Setup Window Handle for focus swapping
      TradeCustomisation.FunctionsO.TradehWnd := hWnd;

      // Call OnConfigure event on the Plug-In
      FPlugInI.OnConfigure (TradeConfigI);
    Except
      On E:Exception Do
        RaiseException ('OnConfigure', E.Message);
    End;
  Finally
    // Destroy Config Object by removing references to COM Object
    //TradeConfigO := NIL;            // HM 14/08/02: Removed to suppress Compiler Hint
    TradeConfigI := NIL;
  End;
End; { Configure }

//---------------------------------------------------------------------------

// Calls the OnStartup method on the Plug-In
Procedure TTradeConnectionPoint.Startup;
Begin { Startup }
  Try
    FPlugInI.OnStartup(FConnectionPointI);
  Except
    On E:Exception Do
      RaiseException ('OnStartup', E.Message);
  End;
End; { Startup }

//---------------------------------------------------------------------------

// Calls the OnCustomEvent method on the Plug-In
Procedure TTradeConnectionPoint.CustomEvent (iEventData : ITradeEventData);
Begin { CustomEvent }
  Try
    // Only call the Plug-In if this Plug-In enabled the Hook Point
    If (FHookPoints.StatusArray[iEventData.edWindowId, iEventData.edHandlerId] = thsEnabled) Then
      // This Plug-In enabled the Hook Point - call OnCustomEvent with the EventData object
      FPlugInI.OnCustomEvent(iEventData);
  Except
    On E:Exception Do
      RaiseException ('OnCustomEvent', E.Message);
  End;
End; { CustomEvent }

//---------------------------------------------------------------------------

// Calls the OnCustomText method on the Plug-In to retrieve CustomText
Procedure TTradeConnectionPoint.CustomText (iCustomText : ITradeCustomText);
Begin { CustomEvent }
  Try
    // Only call the Plug-In if this Plug-In enabled the Hook Point
    If (FCustomText.StatusArray[iCustomText.ctWindowId, iCustomText.ctTextId] = thsEnabled) Then
      // This Plug-In enabled the Hook Point - call OnCustomEvent with the EventData object
      FPlugInI.OnCustomText(iCustomText);
  Except
    On E:Exception Do
      RaiseException ('OnCustomText', E.Message);
  End;
End; { CustomEvent }

//---------------------------------------------------------------------------

// Calls the OnShutdown method on the Plug-In
Procedure TTradeConnectionPoint.ShutDown;
Begin { ShutDown }
  Try
    FPlugInI.OnShutdown;
  Except
    On E:Exception Do
      RaiseException ('OnShutdown', E.Message);
  End;
End; { ShutDown }

//---------------------------------------------------------------------------

// Closes down the Plug-In wrapper
Procedure TTradeConnectionPoint.Finish;
Begin { Finish }
  // Remove reference to Plug-In - should cause Plug-In to be destroyed
  FPlugInI := NIL;

  // Remove reference to self - should cause this object to self-destruct :-)
  FConnectionPointI := NIL;
End; { Finish }

//---------------------------------------------------------------------------

function TTradeConnectionPoint.Get_Version: ITradeVersion;
begin
  // Return handle to global Version object
  Result := FVersionI;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_Functions: ITradeFunctions;
begin
  // Return handle to global Functions object
  Result := FFunctionsI;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_SystemSetup: ITradeSystemSetup;
begin
  // Return handle to global SystemSetup object
  Result := FSystemSetupI;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_UserProfile: ITradeUserProfile; 
begin
  // Return handle to global UserProfile object
  Result := FUserProfileI;
end;

//---------------------------------------------------------------------------

// Return Enabled status of the hook point
function TTradeConnectionPoint.Get_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer): TTradeHookStatus;
begin
  // Check for local use of the Hook Point by this Plug-In first, if not used locally check the
  // Global array to see if another Plug-In is using it.
  Result := FHookPoints.StatusArray[WindowId, HandlerId];

  If (Result = thsDisabled) Then
    // Check Global Hook Point Array
    If (FGlobalHookPoints.StatusArray[WindowId, HandlerId] <> thsDisabled) Then
      Result := thsEnabledOther;
end;

//----------------------------------------

// Set the enabled status of the hook point
procedure TTradeConnectionPoint.Set_piHookPoints(WindowId: TTradeWindowIds; HandlerId: Integer; Value: TTradeHookStatus);
begin
  // Update Local Hook Point array
  FHookPoints.StatusArray[WindowId, HandlerId] := Value;

  // If enabling something then flag it as enabled in the Global hook Point Array as well - can't
  // do disables easily as we don't know if it was only enabled by this Plug-In.
  If (Value <> thsDisabled) Then
    FGlobalHookPoints.StatusArray[WindowId, HandlerId] := thsEnabled;
end;

//---------------------------------------------------------------------------

// Return Enabled status of the hook point
function TTradeConnectionPoint.Get_piCustomText(WindowId: TTradeWindowIds; TextId: Integer): TTradeHookStatus;
begin
  // Check for local use of the Hook Point by this Plug-In first, if not used locally check the
  // Global array to see if another Plug-In is using it.
  Result := FCustomText.StatusArray[WindowId, TextId];

  If (Result = thsDisabled) Then
    // Check Global Hook Point Array
    If (FGlobalCustomText.StatusArray[WindowId, TextId] <> thsDisabled) Then
      Result := thsEnabledOther;
end;

//----------------------------------------

// Set the enabled status of the Custom Text
procedure TTradeConnectionPoint.Set_piCustomText(WindowId: TTradeWindowIds; TextId: Integer; Value: TTradeHookStatus);
begin
  // Update Local Hook Point array
  FCustomText.StatusArray[WindowId, TextId] := Value;

  // If enabling something then flag it as enabled in the Global hook Point Array as well - can't
  // do disables easily as we don't know if it was only enabled by this Plug-In.
  If (Value <> thsDisabled) Then
    FGlobalCustomText.StatusArray[WindowId, TextId] := thsEnabled;
end;

//---------------------------------------------------------------------------

function TTradeConnectionPoint.Get_piCustomisationSupport: WideString;
begin
  Result := FCustomisationSupport;
end;

procedure TTradeConnectionPoint.Set_piCustomisationSupport(const Value: WideString);
begin
  FCustomisationSupport := Value;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_piAuthor: WideString;
begin
  Result := FPlugInAuthor;
end;

procedure TTradeConnectionPoint.Set_piAuthor(const Value: WideString);
begin
  FPlugInAuthor := Value;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_piCopyright: WideString;
begin
  Result := FPlugInCopyright;
end;

procedure TTradeConnectionPoint.Set_piCopyright(const Value: WideString);
begin
  FPlugInCopyright := Value;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_piName: WideString;
begin
  Result := FPlugInName;
end;

procedure TTradeConnectionPoint.Set_piName(const Value: WideString);
begin
  FPlugInName := Value;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_piVersion: WideString;
begin
  Result := FPlugInVersion;
end;

procedure TTradeConnectionPoint.Set_piVersion(const Value: WideString);
begin
  FPlugInVersion := Value;
end;

//----------------------------------------

function TTradeConnectionPoint.Get_piSupport: WideString;
begin
  Result := FPlugInSupportMsg;
end;

procedure TTradeConnectionPoint.Set_piSupport(const Value: WideString);
begin
  FPlugInSupportMsg := Value;
end;

//---------------------------------------------------------------------------


end.
