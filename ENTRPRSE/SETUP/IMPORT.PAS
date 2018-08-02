unit Import;

{ markd6 10:38 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Classes, Dialogs, Forms, SysUtils, Windows, SetupU;

function SCD_InitExchDll(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

function SCD_InitImport(var DLLParams: ParamRec): LongBool;  {$IFDEF WIN32} StdCall; {$ENDIF} export;

implementation


//--------------------------------------------------------------------------

Function DoStuff (Const FName, Idx, MainDir, CurrVer, Existing : ShortString) : LongInt;
Var
  StrList    : TStringList;
  TheStr     : String;
  I          : SmallInt;
Begin { DoStuff }
  Result := 1000;

  { Do paranoid check of file existance }
  If FileExists(FName) Then Begin
    // Remove any potential hidden/read-only attributes }
    FileSetAttr (FName, 0);

    { Use stringlist to process file }
    StrList := TStringList.Create;
    Try
      { Read file into stringlist }
      StrList.LoadFromFile(FName);

      If (StrList.Count > 0) Then
        For I := 0 To Pred(StrList.Count) Do Begin
          TheStr := UpperCase(Trim(StrList[I]));

          If (Pos('EXCHEQUER_PATH', TheStr) > 0) Then Begin
            { Exchequer Path - check to see if already set }
            If (Pos(Idx, Existing) = 0) Then
              { Not set - initialise }
              StrList[I] := 'Exchequer_Path              ' + MainDir;
          End { If (Pos('EXCHEQUER_PATH', TheStr) > 0) }
          Else
            If (Pos('MULTI_CURRENCY', TheStr) > 0) Then Begin
              { Currency Version }
              If (CurrVer = '0') Then
                StrList[I] := 'Multi_Currency              OFF'
              Else
                StrList[I] := 'Multi_Currency              ON';
            End; { If (Pos('MULTI_CURRENCY', TheStr) > 0) }
        End; { For I }

      { Save changes }
      StrList.SaveToFile(FName);

      Result := 0;
    Finally
      StrList.Free;
    End;
  End; { If FileExists(W_MainDir + 'IMPORT\ExImport.Sys') }
End; { DoStuff }

//--------------------------------------------------------------------------

//
//
// 1000     Unknown Error
// 1001     Unknown Exception
function SCD_InitImport(var DLLParams: ParamRec): LongBool;
Var
  W_MainDir, W_CurrVer, W_Existing  : String;
  DLLStatus                         : LongInt;
Begin { SCD_InitImport }
  DllStatus := 1000;

  Try
    { Get path of main Exchequer dir }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    W_MainDir := IncludeTrailingBackslash(W_MainDir);

    GetVariable(DLLParams, 'L_CURRVER', W_CurrVer);

    GetVariable(DLLParams, 'VI_EXISTING', W_Existing);

    { Check for DOS Import configuration file - ExImport.Sys }
    If FileExists(W_MainDir + 'IMPORT\ExImport.Sys') Then
      DllStatus := DoStuff (W_MainDir + 'IMPORT\ExImport.Sys', 'A', W_MainDir, W_CurrVer, W_Existing)
    Else
      { Import file not found }
      DllStatus := 0;

    If (DllStatus = 0) Then Begin
      { Check for Windows Import configuration file - ExchDll.Ini }
      If FileExists(W_MainDir + 'IMPORT\ExchDll.Ini') Then
        DllStatus := DoStuff (W_MainDir + 'IMPORT\ExchDll.Ini', 'B', W_MainDir, W_CurrVer, W_Existing)
      Else
        { Import file not found }
        DllStatus := 0;
    End; { If (DllStatus = 0) }
  Except
    { Unknown Exception }
    On Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_InitImport }

//--------------------------------------------------------------------------

function SCD_InitExchDll(var DLLParams: ParamRec): LongBool;
Var
  W_MainDir, W_CurrVer, W_Existing  : String;
  DLLStatus                         : LongInt;
Begin { SCD_InitExchDll }
  DllStatus := 1000;

  Try
    { Get path of main Exchequer dir }
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    W_MainDir := IncludeTrailingBackslash(W_MainDir);

    GetVariable(DLLParams, 'L_CURRVER', W_CurrVer);

    { Check for COM Toolkit configuration file - ExchDll.Ini }
    If FileExists(W_MainDir + 'ExchDll.Ini') Then
      DllStatus := DoStuff (W_MainDir + 'ExchDll.Ini', 'B', W_MainDir, W_CurrVer, '')
    Else
      { Import file not found }
      DllStatus := 0;
  Except
    { Unknown Exception }
    On Exception Do
      DLLStatus := 1001;
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_InitExchDll }

end.
