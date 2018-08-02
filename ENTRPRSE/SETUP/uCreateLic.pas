unit uCreateLic;

interface

Uses SysUtils, WiseUtil;

// Called from the setup to create a basic licence with the database type set, this is needed
// in order to access the data via BtrvSQL.Dll which uses the database type flag in the licence
// to determine whether a MS SQL or Pervasive system is running
function SCD_CreateLicence(var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

Uses GlobExch, CompUtil, LicRec, EntLic;


// Called from the setup to create a basic licence with the database type set, this is needed
// in order to access the data via BtrvSQL.Dll which uses the database type flag in the licence
// to determine whether a MS SQL or Pervasive system is running
//
//    0        AOK
// 1000        Unknown Exception
// 1001        Incorrect security parameter
function SCD_CreateLicence(var DLLParams: ParamRec): LongBool;
Var
  DLLStatus            : LongInt;
  W_MainDir, W_DBType  : String;
  Params               : ANSIString;
  EntLicR              : EntLicenceRecType;
Begin // SCD_CreateLicence
  Try
    DLLStatus := 0;    // AOK

{$IFDEF LIC600}
    // Check security parameter to ensure not called by anyone
    Params := DLLParams.szParam;
    If (Copy (Params, 1, 4) = 'AK47') And (Length(Params) = 4) Then
    Begin
      // Get directory of data to create licence in
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
      FixPath (W_MainDir);

      // Get Database Type
      GetVariable(DLLParams, 'L_DBTYPE', W_DBType);

      FillChar (EntLicR, SizeOf(EntLicR), #0);
      EntLicR.licEntDB := StrToIntDef(W_DBType, 0);
      If (Not WriteEntLic (W_MainDir + EntLicFName, EntLicR)) Then
        DLLStatus := 1005 // Error writing new licence file
    End // If (Copy (Params, 1, 4) = 'AK47') And (Length(Params) = 4)
    Else
      DLLStatus := 1001; // Incorrect security parameter
{$ENDIF} // LIC600
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_CreateLicence

//=========================================================================

end.
