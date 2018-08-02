unit HandlerU;

interface

Uses CustWinU, CustAbsU, Windows;

{ Following functions required to be Exported by Enterprise }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers); Export;
Procedure TermCustomHandler; Export;
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem01); Export;
procedure ExecNewProcess(ProgramName : String);

implementation

Uses Dialogs, SysUtils, ChainU, PIMisc, PISecure, Classes, Forms, ExchequerRelease;

Const
  EventDisabled = 0;
  EventEnabled  = 1;
  sPluginName = 'VAT Partial Exemption Plug-In';
  {$IFDEF EX600}
      // CA 30/04/2013 v7.0.3  ABSEXGENERIC-313: Code done in VB Code so version number updated
      // CA 09/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
      sVersion = '015';
//      sVersion = 'v7.03.013';
//    sVersion = 'v6.100.013';
  {$ELSE}
    sVersion = 'v5.71.008';
  {$ENDIF}
  sSystemCode =   'EXCHCIBVAT000066';
  sSecurityCode = '1v4f964auo;k73-0';

{---------------------------------------------------------------------------}

{ Called by Enterprise to initialise the Customisation }
Procedure InitCustomHandler(Var CustomOn       : Boolean;
                                CustomHandlers : TAbsCustomHandlers);
var
  i : integer;
  T : TStringList;
  bHookEnabled : Boolean;
Begin

  bHookEnabled := PICheckSecurity(sSystemCode,
                                  sSecurityCode,
                                  sPluginName,
                                  '',
                                  stSystemOnly,
                                  ptDLL,
                                  DLLChain.ModuleName);

  if bHookEnabled then
  begin

    CustomOn := True;

    { Enable Hooks and Set About Message here }
    T := TStringList.Create;
    Try
      PIMakeAboutText(sPluginName, ExchequerModuleVersion (emGenericPlugIn, sVersion) + ' (DLL)', T);

      for i := 0 to T.Count - 1 do
        CustomHandlers.AddAboutString(T[i]);
    Finally
      T.Free;
    End;

    With CustomHandlers Do Begin
(*    { Define About Box Message }
    AddAboutString (' ');
    AddAboutString ('VAT Partial Exemption Hook v1.3');
    AddAboutString ('Hook Point :  After Transaction Save');
    AddAboutString (' '); *)


    { Before Store Transaction }
      SetHandlerStatus(EnterpriseBase + 2000, 170, EventEnabled);

    End; { With }
  end;
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
Procedure ExecCustomHandler(Const EventData : TAbsEnterpriseSystem01);
var
Curr_Dir : string;
Data_Dir : string;
CommandLine : string;
VPXTrans : Boolean;
Begin

    If  (eventdata.WinId = (EnterpriseBase + 2000)) And (eventdata.HandlerId = 170) THEN
    Begin
            IF  (Copy(EventData.Transaction.thOurRef,1,3) = 'PIN') OR
                (Copy(EventData.Transaction.thOurRef,1,3) = 'PCR') THEN

                begin
                        //GetDir(0, Curr_dir);
                        Curr_Dir := ExtractFilePath(Application.ExeName);
                        Data_dir := EventData.Setup.ssDataPath;
                        CommandLine := Trim(Curr_dir) + '\VATUPD.EXE ' + EventData.Transaction.thOurRef + '|' + Data_dir;
                        execnewprocess(CommandLine);
                end;
    End;

  { Pass onto other Hook DLL's }
  DLLChain.ExecCustomHandler(EventData);
End;

{Supply a fully qualified path name in ProgramName}
procedure ExecNewProcess(ProgramName : String);
var
  StartInfo  : TStartupInfo;
  ProcInfo   : TProcessInformation;
  CreateOK   : Boolean;
begin

  { fill with known state }
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);

  CreateOK := CreateProcess(nil, PChar(ProgramName), nil, nil,False,
              CREATE_NEW_PROCESS_GROUP+NORMAL_PRIORITY_CLASS, 
              nil, nil, StartInfo, ProcInfo);

  { check to see if successful }
  if CreateOK then
    //may or may not be needed. Usually wait for child processes
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
end;





end.

