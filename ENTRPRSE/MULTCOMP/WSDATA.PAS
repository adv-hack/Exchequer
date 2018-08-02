unit wsData;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, IniFiles, SysUtils,
     {$IFDEF SETD}
       SetupU,
     {$ELSE}
       DLLWise,
     {$ENDIF}
     Windows;

{ Loads the Workstation Setup info from Registry and Setup.Usr }
function SCD_LoadWSOptions(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Saves the Workstation Setup info to Registry and Setup.Usr }
function SCD_StoreWSOptions(var DLLParams: ParamRec): LongBool; StdCall; export;

{ Calculates the drive + path for the local excheqr dir needed for the workgroup engine }
function SCD_CalcExchLocal(var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

Uses CompUtil, APIUtil, IIFFuncs;

//-------------------------------------------------------------------------

{ Calculates the drive + path for the local excheqr dir needed for the workgroup engine }
function SCD_CalcExchLocal(var DLLParams: ParamRec): LongBool;
Var
  V_ExchLocal : String;
Begin { SCD_CalcExchLocal }
  V_ExchLocal := WinGetWindowsDir[1] + ':\Excheqr\';
  SetVariable(DLLParams, 'V_EXCHLOCAL', V_ExchLocal);
  Result := False;
End; { SCD_CalcExchLocal }


//-------------------------------------------------------------------------

{ Loads the Workstation Setup info from Registry and Setup.Usr }
function SCD_LoadWSOptions(var DLLParams: ParamRec): LongBool;
Var
  UsrIniF           : TIniFile;
  W_MainDir, W_Temp : String;
  TmpI              : LongInt;
Begin { SCD_LoadWSOptions }
  Try
    { Get Enterprise direcctory }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    { Load global defaults from network }
    If FileExists(W_MainDir + 'WSTATION\SETUP.USR') Then Begin
      UsrIniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
      Try
        { Save Start Menu Group Name }
        W_Temp := UsrIniF.ReadString ('WorkStation', 'GroupName', '');
        If (W_Temp <> '') Then
          SetVariable(DLLParams, 'V_GROUP', W_Temp);

        { Local Program Files }
        W_Temp := UsrIniF.ReadString ('WorkStation', 'LocalProgs', '');
        If (W_Temp <> '') Then Begin
          SetVariable(DLLParams, 'V_LOCPROGS', W_Temp);

          If (W_Temp[1] = 'Y') Then Begin
            { Local directory }
            W_Temp := UsrIniF.ReadString ('WorkStation', 'LocalDir', '');
            If (W_Temp <> '') Then
              SetVariable(DLLParams, 'V_LOCDIR', W_Temp);

            { Replication Engine in Startup }
            W_Temp := UsrIniF.ReadString ('WorkStation', 'StartRepl', '');
            If (W_Temp <> '') Then
              SetVariable(DLLParams, 'V_STARTREPL', W_Temp);
          End; { If }
        End; { If }

        { Client-Server Engine Info }
        //VM: 30/05/2007 cs variables are no longer necessary
        TmpI := UsrIniF.ReadInteger ('ClientServer', 'NetworkOS', -1);
//        SetVariable(DLLParams, 'CS_NETOS', IIF (TmpI >= 0, IntToStr(TmpI), ' '));

        TmpI := UsrIniF.ReadInteger ('ClientServer', 'NetworkVersion', -1);
//        SetVariable(DLLParams, 'CS_NETVER', IIF (TmpI >= 0, IntToStr(TmpI), ' '));

        TmpI := UsrIniF.ReadInteger ('ClientServer', 'EngineVersion', -1);
//        SetVariable(DLLParams, 'CS_ENGVER', IIF (TmpI >= 0, IntToStr(TmpI), ' '));

        { Workgroup Engine Info }

        // WG_INSTALLED - Workgroup Engine is already installed Y/N
        W_Temp := UpperCase(UsrIniF.ReadString ('Workgroup', 'Installed', 'N'));

        If (W_Temp <> '') Then
          SetVariable(DLLParams, 'WG_INSTALLED', W_Temp);

        If (W_Temp = 'Y') Then
        Begin
          // Workgroup engine is installed

          // WG_VERSION - Workgroup Engine version from CD Licence, 0=None, 1=v8
          W_Temp := UpperCase(UsrIniF.ReadString ('Workgroup', 'Version', '0'));
          SetVariable(DLLParams, 'WG_VERSION', W_Temp);

          // WG_SERVERPC - Name of Workgroup Server PC
          W_Temp := UpperCase(UsrIniF.ReadString ('Workgroup', 'ServerPC', ''));
          SetVariable(DLLParams, 'WG_SERVERPC', W_Temp);

          // WG_LICKEY - Licence String for P.SQL Workgroup Engine
          W_Temp := UpperCase(UsrIniF.ReadString ('Workgroup', 'LicenceKey', ''));
          SetVariable(DLLParams, 'WG_LICKEY', W_Temp);
        End; // If (W_Temp = 'Y')
      Finally
        UsrIniF.Free;
      End;
    End; { If FileExists }
  Except
    On Ex:Exception Do
      ;
  End;

  Result := False;
End; { SCD_LoadWSOptions }


{ Saves the Workstation Setup info to Registry and Setup.Usr }
function SCD_StoreWSOptions(var DLLParams: ParamRec): LongBool;
Var
  UsrIniF           : TIniFile;
  W_MainDir, W_Temp : String;
Begin { SCD_StoreWSOptions }
  Try
    { Get Enterprise direcctory }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    FixPath (W_MainDir);

    UsrIniF := TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR');
    Try
      { Save Start Menu Group Name }
      GetVariable(DLLParams, 'V_GROUP', W_Temp);
      UsrIniF.WriteString ('WorkStation', 'GroupName', W_Temp);

      { Local Program Files }
      GetVariable(DLLParams, 'V_LOCPROGS', W_Temp);
      UsrIniF.WriteString ('WorkStation', 'LocalProgs', W_Temp);

      { Local directory }
      GetVariable(DLLParams, 'V_LOCDIR', W_Temp);
      UsrIniF.WriteString ('WorkStation', 'LocalDir', W_Temp);

      { Replication Engine in Startup }
      GetVariable(DLLParams, 'V_STARTREPL', W_Temp);
      UsrIniF.WriteString ('WorkStation', 'StartRepl', W_Temp);
    Finally
      UsrIniF.Free;
    End;
  Except
    On Ex:Exception Do
      ;
  End;

  Result := False;
End; { SCD_StoreWSOptions }


end.
