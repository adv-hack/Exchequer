unit Win64Info;

interface

Uses WiseAPI;

function SCD_CheckForWin64 (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses APIUtil;

function SCD_CheckForWin64 (var DLLParams: ParamRec): LongBool;
Begin // SCD_CheckForWin64
  If IsWow64 Then
    SetVariable(DLLParams, 'OS_RUNNINGWIN64', '1')
  Else
    SetVariable(DLLParams, 'OS_RUNNINGWIN64', '0');
End; // SCD_CheckForWin64


end.
