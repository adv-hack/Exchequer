// Customisation Interface Unit for Trade Counter Customisation
unit CustIntU;

interface

{$IFDEF TCCU}  // Trade Counter Customisation

Uses EnterpriseTrade_TLB,
     oCustTxt,      // Custom Text class
     oFuncs,        // Functions class
     oEvent,        // Base EventData class
     oHookPnt,      // Hook Point/Custom Text Array object
     oSysSetup,     // SystemSetup class
     oTrade,        // TTradeConnectionPoint Plug-In Wrapper class
     oUserPro,      // User Profile class
     oVersion;      // Version Class

Type
  TTradeCustomisation = Class(TObject)
  Private
    // Dynamic Array used to store the Plug-In Wrapper Objects (1 per Plug-In)
    FPlugIns    : Array Of TTradeConnectionPoint;

    // Global Hook Points object
    FHookPoints : THookPointStatus;

    // Global Custom Text object
    FCustomText : THookPointStatus;

    // Functions sub-object
    FFunctionsO : TTradeFunctions;
    FFunctionsI : ITradeFunctions;

    // SystemSetup sub-object
    FSystemSetupO : TTradeSystemSetup;
    FSystemSetupI : ITradeSystemSetup;

    // UserProfile sub-object
    FUserProfileO : TTradeUserProfile;
    FUserProfileI : ITradeUserProfile;

    // Version sub-object
    FVersionO     : TTradeVersion;
    FVersionI     : ITradeVersion;

    // EventData Object
    FEventDataO : TTradeEventData;
    FEventDataI : ITradeEventData;

    // Custom Text object
    FCustomTextO : TTradeCustomText;
    FCustomTextI : ITradeCustomText;
  Protected
    // Local methods
    Procedure AddPlugIn (Const PlugInWrapper : TTradeConnectionPoint);
    Function GetPlugInCount : Integer;
    function GetPlugIns(Index: Integer): TTradeConnectionPoint;
  Public
    Property EventDataI : ITradeEventData Read FEventDataI;
    Property EventDataO : TTradeEventData Read FEventDataO;
    Property FunctionsO : TTradeFunctions Read FFunctionsO;
    Property SystemSetupO : TTradeSystemSetup Read FSystemSetupO;
    Property PlugInCount : Integer Read GetPlugInCount;
    Property PlugIns[Index:Integer] : TTradeConnectionPoint Read GetPlugIns;

    Constructor Create;
    Destructor Destroy; Override;

    // Runs through the Plug-Ins calling the OnCustomEvent method
    Procedure ExecuteEvent;
    // Returns True if the specified Hook Point is enabled
    Function  GotEvent (WindowId: TTradeWindowIds; HandlerId: Integer) : Boolean;
    // Returns True if the specified Text is customised
    Function GotCustomText (WindowId: TTradeWindowIds; TextId: Integer) : Boolean;
    // Runs through the Plug-Ins calling the OnCustomText method
    Function CustomText (WindowId: TTradeWindowIds; TextId: Integer; CurrText : ShortString) : ShortString;
    // Run through TCCustom.Ini and Load the Plug-Ins
    Procedure LoadPlugIns;
    // Called to call the OnStartup method on the Plug-ins
    Procedure Startup;
    // Called to call the OnShutdown method on the Plug-Ins
    Procedure ShutDown;
  End; { TTradeCustomisation }

{$ENDIF}

Var
  // Indicates whether Customisation has been disabled by the command-line parameter
  CustomisationEnabled    : Boolean = False;

{$IFDEF TCCU}  // Trade Counter Customisation
  TradeCustomisation : TTradeCustomisation = NIL;

  Procedure StartCustomisation;
  Procedure KillCustomisation;
{$ENDIF}

implementation

{$IFDEF TCCU}  // Trade Counter Customisation

uses Classes, ComObj, Dialogs, Forms, IniFiles, SysUtils, Windows;

  //===========================================================================

  Procedure StartCustomisation;
  Begin { StartCustomisation }
    If CustomisationEnabled Then
      // Create internal customisation interface and load Plug-Ins
      TradeCustomisation := TTradeCustomisation.Create;

    If CustomisationEnabled Then
      // Load the Plug-Ins
      TradeCustomisation.LoadPlugIns;

    If CustomisationEnabled Then
      // Start the Plug-Ins
      TradeCustomisation.Startup;
  End; { StartCustomisation }

  //----------------------------------------

  Procedure KillCustomisation;
  Begin { KillCustomisation }
    If CustomisationEnabled and assigned(TradeCustomisation) Then Begin
      // Send the OnShutdown to all the Plug-ins
      TradeCustomisation.ShutDown;

      // Destroy the internal customisation interface
      FreeAndNIL(TradeCustomisation);
    End; { If CustomisationEnabled }
  End; { KillCustomisation }

  //===========================================================================

  Constructor TTradeCustomisation.Create;
  Begin { Create }
    Inherited;

    // Initialise the Plug-In Array to 0 elements
    FPlugIns := NIL;

    // Create Global Hook Points status object
    FHookPoints := THookPointStatus.Create;

    // Create Global Custom Text status object
    FCustomText := THookPointStatus.Create;

    // Create EventData COM Object
    FEventDataO := TTradeEventData.Create;
    FEventDataI := FEventDataO;

    // Create Custom Text event object
    FCustomTextO := TTradeCustomText.Create;
    FCustomTextI := FCustomTextO;

    // Create Functions sub-object
    FFunctionsO := TTradeFunctions.Create;
    FFunctionsI := FFunctionsO;

    // Create SystemSetup sub-object
    FSystemSetupO := TTradeSystemSetup.Create;
    FSystemSetupI := FSystemSetupO;
//    FSystemSetupO.Assign(FEventDataO, );

    // Create UserProfile sub-object
    FUserProfileO := TTradeUserProfile.Create;
    FUserProfileI := FUserProfileO;

    // Create Version sub-object
    FVersionO := TTradeVersion.Create;
    FVersionI := FVersionO;
  End; { Create }

  //---------------------------------------------------------------------------

  Destructor TTradeCustomisation.Destroy;
  Begin { Destroy }
    // Destroy Global Hook Points object (NOTE: Normal Delphi Object not a COM Object)
    FreeAndNIL(FHookPoints);

    // Destroy Global Custom Text object (NOTE: Normal Delphi Object not a COM Object)
    FreeAndNIL(FCustomText);

    // Initialise the Plug-In Array to 0 elements
    FPlugIns := NIL;

    // Destroy EventData COM Object
    FEventDataO := NIL;
    FEventDataI := NIL;

    // Destroy Custom Text event COM object
    FCustomTextO := NIL;
    FCustomTextI := NIL;

    // Functions sub-object
    FFunctionsO := NIL;
    FFunctionsI := NIL;   // Setting Interface to Nil will cause Destroy

    // SystemSetup sub-object
    FSystemSetupO := NIL;
    FSystemSetupI := NIL;   // Setting Interface to Nil will cause Destroy

    // UserProfile sub-object
    FUserProfileO := NIL;
    FUserProfileI := NIL;   // Setting Interface to Nil will cause Destroy

    // Version sub-object
    FVersionO := NIL;
    FVersionI := NIL;   // Setting Interface to Nil will cause Destroy

    // Reset global vars to prevent accidental usage
    CustomisationEnabled := False;
    TradeCustomisation := NIL;

    Inherited;
  End; { Destroy }

  //---------------------------------------------------------------------------

  // Run through TCCustom.Ini and Load the Plug-Ins
  Procedure TTradeCustomisation.LoadPlugIns;
  Var
    TradePlugIn   : ITradeClient;
    SectList      : TStringList;
    I             : SmallInt;
  Begin { LoadPlugIns }
    SectList := TStringList.Create;
    Try
      With TIniFile.Create (ExtractFilePath(Application.ExeName) + 'TCCUSTOM.INI') Do
        Try
          ReadSectionValues('PlugIns', SectList);

          If (SectList.Count > 0) Then
            For I := 0 To Pred(SectList.Count) Do Begin
              Try
                // Create the Plug-In - if not registered then it will create an EOLESysError exception
                TradePlugIn := CreateOLEObject(SectList.Values[SectList.Names[I]]) As ITradeClient;

                // Add the Wrapper object into the Plug-In List
                AddPlugIn (TTradeConnectionPoint.Create(SectList.Values[SectList.Names[I]],
                                                        TradePlugIn,
                                                        FFunctionsI,
                                                        FSystemSetupI,
                                                        FUserProfileI,
                                                        FVersionI,
                                                        FHookPoints,
                                                        FcustomText));

                // Pause for 1/20th second to allow the Plug-Ins background processing time
                SleepEx (50, True);
              Except
                On EOLESysError Do
                  MessageDlg ('The Trade Counter Plug-In ' + QuotedStr(SectList.Values[SectList.Names[I]]) + ' cannot be created, ' +
                              'please ensure that it is correctly installed and registered on this workstation.' + #13#13 +
                              'Please notify your Technical Support of this problem', mtWarning, [MbOk], 0);
                On Exception Do
                  ;
              End;
            End; { For I }
        Finally
          Free;
        End;
    Finally
      SectList.Free;
    End;
  End; { LoadPlugIns }

  //---------------------------------------------------------------------------

  // Add the Wrapper object into the Plug-In List
  Procedure TTradeCustomisation.AddPlugIn (Const PlugInWrapper : TTradeConnectionPoint);
  Begin { AddPlugIn }
    // Extend dynamic array by 1 for new Plug-In entry
    SetLength (FPlugIns, PlugInCount + 1);

    // Store the new Plug-In into the last element of the array
    FPlugIns[High(FPlugIns)] := PlugInWrapper;
  End; { AddPlugIn }

  //---------------------------------------------------------------------------

  // Called to call the OnStartup method on the Plug-ins
  Procedure TTradeCustomisation.Startup;
  Var
    I : SmallInt;
  Begin { Startup }
    If (PlugInCount > 0) Then
      // Iterate through the array of Plug-Ins calling the OnStartup method
      For I := 0 To High(FPlugIns) Do
        FPlugIns[I].Startup;
  End; { Startup }

  //---------------------------------------------------------------------------

  // Called to call the OnShutdown method on the Plug-Ins
  Procedure TTradeCustomisation.ShutDown;
  Var
    I : SmallInt;
  Begin { ShutDown }
    If (PlugInCount > 0) Then
    Begin
      // Iterate through the array of Plug-Ins calling the OnShutdown method
      For I := 0 To High(FPlugIns) Do Begin
        FPlugIns[I].Shutdown;

        // Pause for 1/20th second to allow the Plug-Ins background processing time
        SleepEx (50, True);
      End; { For I }

      // Iterate through the array of Plug-Ins shutting down the Trade Counter interface to the Plug-In
      For I := 0 To High(FPlugIns) Do Begin
        FPlugIns[I].Finish;
        FPlugIns[I] := Nil;

        // Pause for 1/20th second to allow the Plug-Ins background processing time
        SleepEx (50, True);
      End; { For I }
    End; { If (Length(FPlugIns) > 0) }
  End; { ShutDown }

  //---------------------------------------------------------------------------

  // Returns number of Plug-Ins loaded
  Function TTradeCustomisation.GetPlugInCount : Integer;
  Begin { GetPlugInCount }
    Result := 0;
    try
      Result := Length(FPlugIns);
    except
    end;
  End; { GetPlugInCount }

  //---------------------------------------------------------------------------

  // Returns True if the specified Hook Point is enabled
  Function TTradeCustomisation.GotEvent (WindowId: TTradeWindowIds; HandlerId: Integer) : Boolean;
  Begin { GotEvent }
    // Check Customisation is enabled
    If CustomisationEnabled Then
      // Return True if some Plug-In has enabled the hook point in the Global Hook Point Status Array
      Result := (FHookPoints.StatusArray[WindowId,HandlerId] <> thsDisabled)
    Else
      Result := False;
  End; { GotEvent }

  //---------------------------------------------------------------------------

  // Runs through the Plug-Ins calling the OnCustomEvent method
  Procedure TTradeCustomisation.ExecuteEvent;
  Var
    I : SmallInt;
  Begin { ExecuteEvent }
    If (PlugInCount > 0) Then
      // Iterate through the array of Plug-Ins calling the OnCustomEvent method
      For I := 0 To High(FPlugIns) Do Begin
        FPlugIns[I].CustomEvent (FEventDataI);

        // Pause for 1/20th second to allow the Plug-Ins background processing time
        SleepEx (50, True);
      End; { For I }
  End; { ExecuteEvent }

  //---------------------------------------------------------------------------

  // Returns True if the specified Text is customised
  Function TTradeCustomisation.GotCustomText (WindowId: TTradeWindowIds; TextId: Integer) : Boolean;
  Begin { GotEvent }
    // Check Customisation is enabled
    If CustomisationEnabled Then
      // Return True if some Plug-In has enabled the CustomText in the Global Custom Text Status Array
      Result := (FCustomText.StatusArray[WindowId,TextId] <> thsDisabled)
    Else
      Result := False;
  End; { GotEvent }

  //---------------------------------------------------------------------------

  // Runs through the Plug-Ins calling the OnCustomText method
  Function TTradeCustomisation.CustomText (WindowId: TTradeWindowIds; TextId: Integer; CurrText : ShortString) : ShortString;
  Var
    I : SmallInt;
  Begin { CustomText }
    // Return standard text as default
    Result := CurrText;

    // check that there are some Plug-Ins and that at least one of them has customised the specified text
    If (PlugInCount > 0) And GotCustomText (WindowId, TextId) Then Begin
      // Initialise Custom Text Event Data
      FCustomTextO.WindowId := WindowId;
      FCustomTextO.TextId := TextId;
      FCustomTextO.Text := CurrText;

      // Iterate through the array of Plug-Ins calling the OnCustomText method
      For I := 0 To High(FPlugIns) Do Begin
        FPlugIns[I].CustomText (FCustomTextI);

        // Pause for 1/20th second to allow the Plug-Ins background processing time
        SleepEx (50, True);
      End; { For I }

      Result := FCustomTextO.Text;
    End; { If (PlugInCount > 0) }
  End; { CustomText }

  //---------------------------------------------------------------------------

  Function TTradeCustomisation.GetPlugIns(Index: Integer): TTradeConnectionPoint;
  Begin { GetPlugIns }
    If (Index >= 0) And (Index < PlugInCount) Then
      Result := FPlugIns[Index]
    Else
      Raise Exception.Create ('TTradeCustomisation.GetPlugIns: Invalid Plug-In Index (' + IntToStr(Index) + ')');
  End; { GetPlugIns }

  //---------------------------------------------------------------------------

Initialization
  // Check the Command Line Parameters for Customisation related switches
  CustomisationEnabled := Not FindCmdLineSwitch('NoCustom', ['/', '-', '\'], True);

{$ENDIF}
end.
