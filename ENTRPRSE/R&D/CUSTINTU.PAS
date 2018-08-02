unit CustIntU;

interface

Uses Classes, Dialogs, Forms, IniFiles, StdCtrls, ShellApi, SysUtils, Windows,
     {$IFNDEF EXDLL}
     CustInit,
     {$ENDIF}
    {$IFDEF CU}
      CustTypU,
      {$IFDEF COMCU}
        ComServ,
        Enterprise_TLB,
        ZEvData,
      {$ENDIF}
    {$ENDIF}
     ExWrap1U;


Type
  TCustomEvent = Class(TObject)
  Private
   {$IFDEF CU}
      WinId, HandlerId   : LongInt;
   {$ENDIF}

    Function GetValidStatus : Boolean;
    Function GetDataChanged : Boolean;
  Public
    {$IFDEF CU}
      EntSysObj : TEnterpriseSystem;

      {$IFDEF COMCU}
        ComEventO : TCOMEventData;
        ComEventI : ICOMEventData;

        ThreadIdx : Byte;
      {$ENDIF}
    {$ENDIF}

    Property DataChanged : Boolean Read GetDataChanged;
    Property ValidStatus : Boolean Read GetValidStatus;

    Constructor Create(Const WindowId, EventId : LongInt);
    Destructor  Destroy; OverRide;

    Function  GotEvent : Boolean;

    Procedure SetEventIds(Const WindowID,EventID  :  LongInt);

    Procedure BuildEvent(Const ExLocal : TdExLocal);
    Procedure Execute (Const DoFocusFix : Boolean = False);

    { Added new methods to support COM customisation within threads }
    Procedure ExecuteDelphiCust;
    Procedure MarshalCOMClients;
    Procedure ThreadExecute;
  End; { TCustomEvent }


{$IFDEF CU}
  Procedure InitCustomisation;
  Procedure TerminateCustomisation;
  Procedure AddCustomAbout(Const Memo1 : TMemo);

  Function CustomisationCompanyCode : ShortString;
  Procedure SetCustomisationCompanyCode (Const CompCode : ShortString);

  { HM 14/02/00: Added to allow detection of COM Clients }
  Function ActiveCOMClients : Boolean;

  Var
    CustomHandlers : TCustomHandlers;
{$ENDIF}

implementation

{$IFDEF CU}
  Uses
    ActiveX,
    GlobVar,
    VarConst,
    CustAbsU, Messages, //PR: 24/09/2009 Added Messages unit for customisation focus issue fix
    {$IFDEF COMCU}
      ZEntSys,
    {$ENDIF}
    ETStrU;

  { External Declarations }
  Procedure InitCustomHandler(Var CustomOn : Boolean;CustomHandlers : TAbsCustomHandlers); External 'EntCustm.Dll';
  Procedure TermCustomHandler; External 'EntCustm.Dll';
  Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem); External 'EntCustm.Dll';
{$ENDIF}

Var
  LocalCompanyCode : String[6];

{ Initialises the Customisation Subsystems }
Procedure InitCustomisation;

{$IFDEF CU}
  {$IFDEF COMCU}
    Procedure RunComClients;
    Var
      cmdFile, cmdPath, cmdParams : PChar;
      IniF    : TIniFile;
      FileStr : ShortString;
      Ded     : Boolean;
      FCount  : SmallInt;
      Flags, Res : LongInt;

      Procedure WaitForCOMObj;
      Var
        stTime, fiTime, cuTime : Double;

        { Calculates the current time in hundredths of seconds }
        Function CurrentTime : Double;
        Var
          wHour, wMin, wSec, wMSec  : Word;
          lHour, lMin, lSec, lMSec : LongInt;
        begin
          { Get current time }
          DecodeTime(Now, wHour, wMin, wSec, wMSec);

          { Copy fields into longs to force compiler to work in LongInt mode  }
          { otherwise you can get Range Check Errors as it works in Word mode }
          lHour := wHour;
          lMin  := wMin;
          lSec  := wSec;
          lMSec := wMSec;

          { Calculate number of seconds since midnight }
          Result := (((((lHour * 60) + lMin) * 60) + lSec) * 100) + (lMSec / 10);
        End;

      Begin { WaitForCOMObj }
        { STEP 1: Mandatory 0.50 second delay to allow COM Client to startup without conflicts }
        stTime := CurrentTime;
        fiTime := stTime + 50;
        Repeat
          Application.ProcessMessages;
          cuTime := CurrentTime;
        Until (cuTime < stTime) Or (cuTime > fiTime);

        { Check COM Object not already available }
        If Not Assigned (ComEntSys) Then Begin
          { STEP 2: Five second timing loop waiting for COM Object to startup }
          stTime := CurrentTime;
          fiTime := stTime + 500;
          Repeat
            Application.ProcessMessages;
            cuTime := CurrentTime;
          Until (cuTime < stTime) Or (cuTime > fiTime) Or Assigned (ComEntSys);

          If Assigned (ComEntSys) Then Begin
            { STEP 3: COM Object now running - wait 0.50 secs to allow full initialisation }
            stTime := CurrentTime;
            fiTime := stTime + 50;
            Repeat
              Application.ProcessMessages;
              cuTime := CurrentTime;
            Until (cuTime < stTime) Or (cuTime > fiTime);
          End; { If Assigned (ComEntSys) }
        End; { If Not Assigned (ComEntSys) }
      End; { WaitForCOMObj }

    Begin { RunComClients }
      cmdFile   := StrAlloc(255);
      cmdPath   := StrAlloc(255);
      cmdParams := StrAlloc(255);

      IniF := TIniFile.Create(ExtractfilePath(Application.ExeName) + 'ENTCUSTM.INI');
      Try
        Ded := False;
        FCount := 1;
        Repeat
          FileStr := IniF.ReadString ('COMClients', IntToStr(FCount), '');

          FileStr := Trim(FileStr);
          Ded := (FileStr = '') Or (Not FileExists(FileStr));

          If (Not Ded) Then
          Begin
            { Run COM Client }
            (*
            StrPCopy (cmdParams, '');
            StrPCopy (cmdFile, FileStr);
            StrPCopy (cmdPath, ExtractFilePath(FileStr));

            Flags := SW_SHOW; //SW_SHOWMINIMIZED;
            Res := ShellExecute (0, NIL, cmdFile, cmdParams, cmdPath, Flags);
            *)

            // MH 18/09/07: Modified to use WinExec as under Vista ShellExecute causes the user
            // to be asked if they want to run the plug-in
            StrPCopy (cmdFile, FileStr);
            WinExec(cmdFile, SW_SHOW);

            Inc(FCount);

            { HM 03/05/00: Wait for COM Object to be running if first client or COM Object not running }
            WaitForCOMObj;
          End; { If }
        Until Ded;
      Finally
        IniF.Destroy;
      End;

      StrDispose(cmdFile);
      StrDispose(cmdPath);
      StrDispose(cmdParams);
    End; { RunComClients }
  {$ENDIF}
{$ENDIF}

Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      { Create CustomHandler Object }
      CustomHandlers := TCustomHandlers.Create;

      { Call Customisation Startup }
      InitCustomHandler(CustomClients, CustomHandlers);

      {$IFDEF COMCU}
        If COMCustomisationEnabled Then Begin
          { Run COM Client .EXE's }
          RunComClients;
        End; { If COMCustomisationEnabled }
      {$ENDIF}
    End; { If }
  {$ENDIF}
End;

{-----------------------------------------}

{ Closes the Customisation Subsystems }
Procedure TerminateCustomisation;
Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      { Notify Customisation that its shutting down }
      TermCustomHandler;

      {$IFDEF COMCU}
        If COMCustomisationEnabled Then Begin
          { Check to see if anyone attached }
          If Assigned (ComEntSys) Then Begin
            { Send Closing Event to COM Clients }
            ComEntSys.OnCloseEvent;

            COMServer.UIInteractive := False;

            { Unregister from the ROT }
            RevokeActiveObject (ComEntSys.FROTValue, Nil);
          End; { If Assigned (ComEntSys) }
        End; { If COMCustomisationEnabled }
      {$ENDIF}

      { Free CustomHandler Object }
      If Assigned (CustomHandlers) Then Begin
        CustomHandlers.Free;
        CustomHandlers := NIL;
      End; { If Assigned (CustomHandlers) }
    End; { If }
  {$ENDIF}
End;

{-----------------------------------------}

{ Adds the Custom About Strings to the About Box }
Procedure AddCustomAbout(Const Memo1 : TMemo);
{$IFDEF CU}
  Var
    I : SmallInt;
{$ENDIF}
Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      With CustomHandlers Do
        { Copy about messages }
        If (AbMsgs.Count > 0) Then Begin
          Memo1.Lines.Add('');
          Memo1.Lines.Add(ConstStr('-',79));
          Memo1.Lines.Add('');

          For I := 0 To Pred(AbMsgs.Count) Do
            Memo1.Lines.Add(AbMsgs.Strings[I]);
        End; { If }
    End; { If CustomisationEnabled }
  {$ENDIF}
End;

//-------------------------------------------------------------------------

Function CustomisationCompanyCode : ShortString;
Begin // CustomisationCompanyCode
  Result := LocalCompanyCode;
End; // CustomisationCompanyCode

Procedure SetCustomisationCompanyCode (Const CompCode : ShortString);
Begin // SetCustomisationCompanyCode
  LocalCompanyCode := CompCode;
End; // SetCustomisationCompanyCode

//-------------------------------------------------------------------------

{ HM 14/02/00: Added to allow detection of COM Clients }
Function ActiveCOMClients : Boolean;
Begin { ActiveCOMClients }
  {$IFDEF CU}
    {$IFDEF COMCU}
      { Check to see if COM Customisation is enabled }
      If COMCustomisationEnabled Then
        { Check to see if anyone has connected to the COM Server }
        Result := Assigned(ComEntSys)
      Else
        { COM Customisation disabled at command-line }
        Result := False;
    {$ELSE}
      { COM Customisation not compiled in }
      Result := False;
    {$ENDIF}
  {$ELSE}
    { Customisation not compiled in }
    Result := False;
  {$ENDIF}
End; { ActiveCOMClients }

{ ================================================================ }

{ Initialises a Custom Event Object }
Constructor TCustomEvent.Create(Const WindowId, EventId : LongInt);
Begin
  Inherited Create;

  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      { Take local copy of Id's } {v5.00.003 asignemnt moved to own procedure
                                   SetEventIDs so we have a central synchronised place to refresh all instances}
      {WinId     := WindowId;
      HandlerId := EventId;}


      EntSysObj := Nil;

      SetEventIDs(WindowId,EventId);

      {$IFDEF COMCU}
        ComEventO := Nil;
        ComEventI := Nil;

        ThreadIdx := 0;
      {$ENDIF}
    End; { If CustomisationEnabled }
  {$ENDIF}
End;

{-----------------------------------------}

{ De-Initialises a Custom Event Object }
Destructor TCustomEvent.Destroy;
Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      If (Assigned(EntSysObj)) then
        EntSysObj.Free;

      {$IFDEF COMCU}
        ComEventO := Nil;
        ComEventI := Nil;
      {$ENDIF}
    End; { If CustomisationEnabled }
  {$ENDIF}

  Inherited Destroy;
End;

{ Set up Window and Handler Id's within the objects private properties and EntSys if assigned }

Procedure TCustomEvent.SetEventIds(Const WindowID,EventID  :  LongInt);

Begin
  {$IFDEF CU}
  WinId     := WindowId;
  HandlerId := EventId;

  If (Assigned(EntSysObj)) then
  Begin
    EntSysObj.WinId:=WindowID; EntSysObj.HandlerId:=EventID;
  end;
  {$ENDIF}
end;



{-----------------------------------------}

{ Returns True if a Custom Event has been setup }
Function TCustomEvent.GotEvent : Boolean;
Begin
  Result := False;

  {$IFDEF CU}
    If CustomisationEnabled Then
      Result := (CustomHandlers.CheckHandlerStatus (WinId, HandlerId) = 1)
  {$ENDIF}
End;

{-----------------------------------------}

{ Builds an Event Object from an ExLocal instance }
Procedure TCustomEvent.BuildEvent(Const ExLocal : TdExLocal);
Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      EntSysObj := TEnterpriseSystem.Create(WinId, HandlerId);

      EntSysObj.AssignExLocal(ExLocal);
    End; { If CustomisationEnabled }
  {$ENDIF}
End;

{-----------------------------------------}

{ Calls the DLL Event Handler for the current Event Object }
Procedure TCustomEvent.ExecuteDelphiCust;
Begin { ExecuteDelphiCust }
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      Try
        { Check to see if a DLL Client is handling this event }
        If CustomHandlers.GotHandler(WinId, HandlerId) Then Begin
          { Call the Customisation DLL }
          ExecCustomHandler(EntSysObj);
        End; { If CustomClients }
      Except
        On Ex : Exception Do
          MessageDlg ('An error has occured in the Customisation for event ' +
                      IntToStr(WinId) + '.' + IntToStr(HandlerId) + '.' + #10#13#10#13 +
                      '''' + Ex.Message + '''' + #10#13#10#13 +
                      'Please notify your Technical Support.', mtError, [mbOk], 0);
      End;
    End; { If }
  {$ENDIF}
End; { ExecuteDelphiCust }

{-----------------------------------------}

{ Calls the DLL Event Handler for the current Event Object }
Procedure TCustomEvent.Execute (Const DoFocusFix : Boolean = False);
Begin
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      { Delphi 5.0 Customisation }
      ExecuteDelphiCust;

      {$IFDEF COMCU}
        // Check COM Customisation is allowed
        If COMCustomisationEnabled Then Begin
          // Check that at least one client has connected
          If Assigned(ComEntSys) Then Begin
            { Check to see if a DLL Client is handling this event }
            If CustomHandlers.GotCOMHandler(WinId, HandlerId) Then Begin
              { Auto-Create Com Object as necessary }
              If (Not Assigned(ComEventO)) Then Begin
                { Create Com object }
                ComEventO := TCOMEventData.Create;

                { initialise com object }
                ComEventO.InitEventData (EntSysObj);

                { Create an interface reference - used to stop Interface }
                { reference count hitting 0 until WE want it to          }
                ComEventI := ComEventO;
              End; { If }

              { Call the COM Customisation }
              ComEntSys.OnHookEvent(EntSysObj, ComEventO);
            End; { If CustomHandlers.GotCOMHandler }
          End; { If Assigned(ComEntSys) }
        End; { If COMCustomOn }
      {$ENDIF}

      //PR: 24/09/2009 Fix customisation focus issue by finding focused control and sending a WM_SetFocus message to it.
      // MH 22/02/2010: Modified to make it controlled by the calling hook as we were getting collateral damage with
      // buttons on Serial/Batch not working if the UDef Fields plug-in was installed, etc...
      If DoFocusFix Then
        PostMessage(GetFocus, WM_SETFOCUS, 0, 0);
    End; { If CustomisationEnabled }
  {$ENDIF}
End;

{-----------------------------------------}

{ Returns the Valid Status field from the object }
Function TCustomEvent.GetValidStatus : Boolean;
Begin
  Result := True;

  {$IFDEF CU}
    If CustomisationEnabled And Assigned(EntSysObj) Then Begin
      Result := EntSysObj.ValidStatus;
    End; { If }
  {$ENDIF}
End;

{-----------------------------------------}

Function TCustomEvent.GetDataChanged : Boolean;
Begin
  Result := True;

  {$IFDEF CU}
    If CustomisationEnabled And Assigned(EntSysObj) Then Begin
      Result := EntSysObj.DataChanged;
    End; { If }
  {$ENDIF}
End;

{-----------------------------------------}

{ Call Synchronised to Marshal the Client Event Sinks to allow cross apartment calls }
Procedure TCustomEvent.MarshalCOMClients;
Begin { MarshalClientsToArray }
  {$IFDEF CU}
    {$IFDEF COMCU}
      // Check COM Customisation is allowed
      If COMCustomisationEnabled Then Begin
        // Check that at least one client has connected
        If Assigned(ComEntSys) Then Begin
          // Check that the index has been set
          If (ThreadIdx <= High(ClientMarshal)) Then Begin
            // call COM Object to marshal client event sinks
            ComEntSys.MarshalClients(ThreadIdx);
          End { If (ThreadIdx ... }
          Else
            Raise Exception.Create ('COM Customisation: Invalid Thread Index (' + IntToStr(ThreadIdx) + ')');
        End; { If Assigned(ComEntSys) }
      End; { If COMCustomisationEnabled }
    {$ENDIF}
  {$ENDIF}
End; { MarshalClientsToArray }

{-----------------------------------------}

{ Execute the event through the marshalled client sink interfaces }
Procedure TCustomEvent.ThreadExecute;
Begin { ThreadExecute }
  {$IFDEF CU}
    If CustomisationEnabled Then Begin
      { Delphi 5.0 Customisation }
      ExecuteDelphiCust;

      {$IFDEF COMCU}
        // Check COM Customisation is allowed
        If COMCustomisationEnabled Then Begin
          // Check that at least one client has connected
          If Assigned(ComEntSys) Then Begin
            // Check to see if a DLL Client is handling this event
            If CustomHandlers.GotCOMHandler(WinId, HandlerId) Then Begin
              // Check that the thread index has been set
              If (ThreadIdx <= High(ClientMarshal)) Then Begin
                // Check that the Clients have been marshalled
                If ClientMarshal[ThreadIdx].Marshalled Then Begin
                  { Auto-Create Com Object as necessary }
                  If (Not Assigned(ComEventO)) Then Begin
                    { Create Com object }
                    ComEventO := TCOMEventData.Create;

                    { initialise com object }
                    ComEventO.InitEventData (EntSysObj);

                    { Create an interface reference - used to stop Interface }
                    { reference count hitting 0 until WE want it to          }
                    ComEventI := ComEventO;
                  End; { If }

                  { Call the COM Customisation }
                  ComEntSys.OnThreadEvent(ThreadIdx, EntSysObj, ComEventO);
                End; { If ClientMarshal[ThreadIdx].Marshalled }
              End; { If (ThreadIdx ... }
            End; { If CustomHandlers.GotCOMHandler(WinId, HandlerId) }
          End; { If Assigned(ComEntSys) }
        End; { If COMCustomisationEnabled }
      {$ENDIF}
    End; { If CustomisationEnabled }
  {$ENDIF}
End; { ThreadExecute }

Initialization
  LocalCompanyCode := '';
end.
