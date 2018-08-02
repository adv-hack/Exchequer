Unit ConvData;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows,
     {$IFNDEF BUREAUDLL}
       //DLLWise,
       WiseUtil,
     {$ENDIF}
     IniFiles;

{$IFNDEF BUREAUDLL}
{ Runs through the MCM performing data conversion rotuines for each valid company }
function SCD_ConvertData(var DLLParams: ParamRec): LongBool; StdCall; export;
{$ENDIF}

{ Checks for the Enterprise Data Files in the specified path }
Function IsValidCompany (CompPath : ShortString) : Boolean;

implementation

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U,
     CompUtil, GlobExch, FileCtrl,
{$IFDEF EXSQL}
     SQLUtils,
{$ENDIF}
     VarFPosU;

{-------------------------------------------------------------------------}

{ Checks for the Enterprise Data Files in the specified path }
Function IsValidCompany (CompPath : ShortString) : Boolean;
Begin { IsValidCompany }
  CompPath := IncludeTrailingBackSlash(Trim(CompPath));

  // 1 - Check directory exists
  Result := DirectoryExists (CompPath);

  If Result Then
{$IFDEF EXSQL}
    Result := SQLUtils.ValidCompany(CompPath);
{$ELSE}
    // 2 - Check for data files
    Result := FileExists (CompPath + 'EXCHQSS.DAT') And
              FileExists (CompPath + NumNam) And
              FileExists (CompPath + Path1 + CustName) And
              FileExists (CompPath + Path3 + MiscNam) And
              FileExists (CompPath + Path3 + PassNam) And
              FileExists (CompPath + Path4 + StockNam) And
              FileExists (CompPath + Path2 + DetailName) And
              FileExists (CompPath + Path2 + DocName) And
              FileExists (CompPath + Path2 + NVNam) And      // MH 23/10/06: Added support for NomView.Dat
              FileExists (CompPath + Path2 + HistName) And
              FileExists (CompPath + Path2 + NomNam) And
              FileExists (CompPath + Path6 + JobCtrlNam) And
              FileExists (CompPath + Path6 + JobDetNam) And
              FileExists (CompPath + Path6 + JobRecNam) And
              FileExists (CompPath + Path6 + JobMiscNam);
{$ENDIF}
End; { IsValidCompany }

{-------------------------------------------------------------------------}

{$IFNDEF BUREAUDLL}

{ Runs through the MCM performing data conversion rotuines for each valid company }
//   1000         Unknown Error
//   1001         Incorrect security parameter
//   1002         Btrieve Not Running
//   1003         Error loading Conversion Library
//   1004         Error loading Conversion Function
//   1200..1299   Error opening Company.Dat
//  10000..19999  Error converting company
Function SCD_ConvertData(var DLLParams: ParamRec): LongBool;
Var
  _ControlUpgrade               : Function (    VerNo     : String;
                                                CompDir   : String;
                                            Var RErrStr   : String;
                                                ForceRun  : Boolean) : Integer; StdCall;
  _ConvertDLL                   : THandle;
  Params, w_DataVer, W_MainDir  : ANSIString;
  DLLStatus                     : LongInt;
  LStatus, I                    : SmallInt;
  KeyS                          : Str255;
  Res                           : Integer;
  ErrStr                        : ANSIString;
  CompList                      : TStringList;

  {-------------------------------------------------------------------------}

  { Check to see if Btrieve file exists and attempt to open it. Returns True }
  { if opened OK, status code is stored in globally to main proc in LStatus  }
  Function OpenDataFile (Const FileNo : Integer; Const FilePath : ShortString) : Boolean;
  Begin { OpenDataFile }
    LStatus := 12;

{$IFDEF EXSQL}
    if TableExists(FilePath + FileNames[FileNo]) then begin
{$ELSE}
    If FileExists (FilePath + FileNames[FileNo]) Then Begin
{$ENDIF}
      { Open specified file }
      LStatus := Open_File(F[FileNo], FilePath + FileNames[FileNo], 0);
    End; { If FileExists (FilePath) }

    Result := (LStatus = 0);
  End; { OpenDataFile }

  {-------------------------------------------------------------------------}

Begin { SCD_ConvertData }
  Try
    DLLStatus := 0;    { Unknown Error }

    { Check security parameter to ensure not called by anyone }
    Params := DLLParams.szParam;
    If (Copy (Params, 1, 7) = 'FU4S9GY') And (Length(Params) = 7) Then Begin
      { Check Btrieve is running - often comes in handy :-) }
      If Check4BtrvOk Then Begin

        {------------------------------------------------------------------}

        { Dynamically load conversion DLL }
        _ConvertDLL := LoadLibrary('GEUPGRDE.DLL');
        Try
          If (_ConvertDLL > HInstance_Error) Then Begin
            { DLL Loaded - get handle for function }
            _ControlUpgrade := GetProcAddress(_ConvertDLL, 'ControlUpgrade');
            If Assigned(_ControlUpgrade) Then Begin

              {------------------------------------------------------------------}

              { Got function handle - continue with conversion }

              { Get Enterprise Data Version }
              GetVariable(DLLParams, 'V_ENTDATAVER', W_DataVer);

              { Get directory of main company }
              GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
              FixPath (W_MainDir);

              { Open Company.Dat and run through all companies updating details }
              If OpenDataFile (CompF, W_MainDir) Then Begin
                // NOTE: Because Eduardo is doing a Btrieve reset in his conversion
                // it is better to cache up the companies in a string list, eliminating
                // the need for Btrieve.
                CompList := TStringList.Create;
                Try
                  { Run through ALL Companies adding valid sub-companies into temprary string list }
                  LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
                  While (LStatus = 0) Do Begin
                    { Check its a company }
                    If (Company^.RecPFix = cmCompDet) And IsValidCompany (Company^.CompDet.CompPath) Then
                      CompList.Add (IncludeTrailingBackSlash(Trim(Company^.CompDet.CompPath)));

                    LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
                  End; { While }

                  { Close data files before calling conversion }
                  Close_File (F[CompF]);

                  { Run through any valid companies converting them }
                  If (CompList.Count > 0) Then
                    For I := 0 To Pred(CompList.Count) Do Begin
                      { Call conversion library }
                      ErrStr := '';
                      Res := _ControlUpgrade (W_DataVer, CompList[I], ErrStr, False);

                      If (Res <> 0) Then Begin
                        { Error converting company }
                        DLLStatus := 10000 + Res;
                        Break;
                      End; { If (Res <> 0) }
                    End; { For I }
                Finally
                  CompList.Free;
                End;
              End { If Open CompF }
              Else Begin
                { Error opening Company.Dat }
                DLLStatus := 1200 + LStatus;
              End; { Else }

              {------------------------------------------------------------------}

            End { If Assigned(_ControlUpgrade) }
            Else
              { Error loading Conversion Function }
              DLLStatus := 1004;

            { Unload library }
            FreeLibrary (_ConvertDLL);
            _ConvertDLL := 0;
          End { If (_ConvertDLL > HInstance_Error) }
          Else
            { Error loading Conversion Library }
            DLLStatus := 1003;
        Except
          FreeLibrary(_ConvertDLL);
          _ConvertDLL := 0;
          _ControlUpgrade := Nil;

          { Error loading Conversion Library }
          DLLStatus := 1003;
        End;
      End { If }
      Else Begin
        { Btrieve Not Running }
        DLLStatus := 1002;
      End; { Else }
    End { If }
    Else Begin
      { Incorrect security parameter }
      DLLStatus := 1001;
    End; { Else }
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1000;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; { SCD_ConvertData }
{$ENDIF}

end.
