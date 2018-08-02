unit WiseIntf;

interface

Uses SysUtils, WiseUtil;

// Wrapper functions to allow them to be called from WISE Setup Programs

function Wise7_GetEnterpriseDir (Var DLLParams: ParamRec) : LongBool; StdCall; Export;

implementation

Uses SetFuncs;

//---------------------------------------------------------------------------

// Wrapper function around GetEnterpriseDir to allow it to be called from
// the WISE Setup Programs.  The following WISE Script Variables are
// used:-
//
//   Variable          | Used for
//  -------------------+-------------------------------------------
//   ENTDIR              Set to Enterprise Directory
//   FUNCRES             Set to function result:-
//
//                         0        OK
//                         1001     Unknown Exception
//                         1002     Unable to Find Enterprise Directory
//                         1003     EnterpriseDir PChar too short
//
// Note: The function result is set to TRUE if the function succeeds
//
Function Wise7_GetEnterpriseDir (Var DLLParams: ParamRec) : LongBool;
Var
  EnterpriseDir : PChar;
  Res           : SmallInt;
Begin { Wise7_GetEnterpriseDir }
  EnterpriseDir := StrAlloc (255);
  Try
    // Call standard function to get the path
    Res := GetEnterpriseDir (EnterpriseDir);

    // Set the Wise script variables
    If (Res = 0) Then SetVariable (DllParams, 'ENTDIR', EnterpriseDir);
    SetVariable (DllParams, 'FUNCRES', IntToStr(Res));

    Result := (Res = 0);
  Finally
    StrDispose (EnterpriseDir);
  End;
End; { Wise7_GetEnterpriseDir }

end.
