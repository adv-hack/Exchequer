library BSPSETUP;

{$REALCOMPATIBILITY ON}

uses
  madExcept,
  madLinkDisAsm,
  madListHardware,
  madListProcesses,
  madListModules,
  D6OnHelpFix,
  conHTMLHelp,
  Dialogs,
  Forms,
  Windows,
  setupbas in 'SETUPBAS.PAS' {SetupTemplate},
  PreReqF in 'PreReqF.pas' {frmPreRequisites},
  CompUtil in 'x:\Entrprse\multcomp\COMPUTIL.PAS',
  SerialU in 'x:\Entrprse\MULTCOMP\Serialu.pas',
  BespokeMSSQLPreReqs in 'BespokeMSSQLPreReqs.pas',
  OSChecks in 'x:\EXCHLITE\CD\OSChecks.pas',
  DebugU in 'x:\EXCHLITE\CD\DebugU.pas',
  DotNet in 'DotNet.pas';

(*
procedure DLLEntryPoint(dwReason: DWord);
begin
  case dwReason of
    DLL_PROCESS_ATTACH: MemMap_OpenSharedData;
    DLL_PROCESS_DETACH: MemMap_CloseSharedData;
  end;
end;
*)


exports
  // CISDBPreReqF
  CheckForPreReqs
  ;

begin
  { First, assign the procedure to the DLLProc variable }
  {DllProc := @DLLEntryPoint;}
  { Now invoke the procedure to reflect that the DLL is attaching
    to the process }
  {DLLEntryPoint(DLL_PROCESS_ATTACH);}
end.

