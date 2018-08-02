unit McmfUNCS;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Dialogs, SysUtils, Windows;


{ Replicates setup details from SysR and ModrR in W_FromDir to all companies }
{ with matching ISN in the COMPANY.DAT in W_CompDir.                         }
Function Dyn_ReplicateEntLicence (Const W_CompDir : ShortString;
                                  Var   W_FromDir : ShortString) : LongInt;

Function Dyn_MCM_SecWizard (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


{ Replications the licencing details around the various companies in the MCM }
//
//     3        Failed to load ENTCOMP.DLL
//
//  1000        Unknown Error
//  1001        Unknown Exception
//  1002        Incorrect security parameter
//  1003        Btrieve Not Running
//  1004        Unknown Error reading SysR
//  1005        Unknown Error reading ModR
//  1100..1199  Error Opening Exchqss.dat
//  1200..1299  Error opening Company.Dat
//  1300..1399  Error Opening SysF in Company
//  1400..1499  Error Opening PwrdF in Company
//  1500..1599  Error Locking SysR in company
//  1600..1699  Error Locking ModR in company


Function Dyn_ReplicateEntLicence (Const W_CompDir : ShortString;
                                  Var   W_FromDir : ShortString) : LongInt;
Const
  ResNames : Array[0..1] of PChar = ('ENTCOMP', 'REPLICATEENTLICENCE');
Var
  _dynRepl     : Function (Const W_CompDir : ShortString; Var W_ErrDir : ShortString) : LongInt; StdCall;
  _MyGSRHandle : THandle;
  DLLAddr      : TFarProc;
  ErrDir       : ShortString;
Begin { Dyn_ReplicateEntLicence }
  Result := 3;

  { Load ENTCOMMS.DLL dynamically }
  _MyGSRHandle := LoadLibrary(ResNames[0]);

  Try
    If (_MyGSRHandle > HInstance_Error) Then Begin
      _dynRepl := GetProcAddress(_MyGSRHandle, ResNames[1]);

      If Assigned(_dynRepl) then Begin
        ErrDir := W_FromDir;
        Result := _dynRepl(W_CompDir, ErrDir);

        If (Result>0) then
          W_FromDir:=ErrDir;
        {If (Result > 0) Then ShowMessage ('Error ' + IntToStr(Result) + ' in ' + ErrDir);}
      End; { If }

      { Unload library }
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;
    End; { If }
  Except
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    _dynRepl := Nil;
  End;
End; { Dyn_ReplicateEntLicence }


{ Replications the licencing details around the various companies in the MCM }
//
//     
//
// Results:-
        //  0           OK
        //  1           Already Fully Released
        //  2           Release Code Entered
        //  3        Failed to load ENTCOMP.DLL
        //  1000        Unknown Error
        //  1001        Unknown Exception
        //  1100..1199  Btrieve Error opening SysF
        //  1200..1299  Btrieve Error Opening PwrdF
        //  1300        Unknown Error Reading Enterprise Licence File
        //  10000+      Error in SCD_SecWarnWizard

Function Dyn_MCM_SecWizard (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt;
Const
  ResNames : Array[0..1] of PChar = ('ENTCOMP', 'MCM_SECWIZARD');
Var
  _dynWiz      : Function (Const CompDir, EntDir : ShortString; Const Mode : Byte; Const Repl : Boolean) : LongInt; StdCall;
  _MyGSRHandle : THandle;
  DLLAddr      : TFarProc;
  Res          : LongInt;
Begin { Dyn_MCM_SecWizard }
  Result := 3;

  { Load ENTCOMMS.DLL dynamically }
  _MyGSRHandle := LoadLibrary(ResNames[0]);

  Try
    If (_MyGSRHandle > HInstance_Error) Then Begin
      _dynWiz := GetProcAddress(_MyGSRHandle, ResNames[1]);

      If Assigned(_dynWiz) Then Begin
        
        Res := _dynWiz(CompDir, EntDir, Mode, Repl);
        Result := Res;
      End; { If }

      { Unload library }
      FreeLibrary(_MyGSRHandle);
      _MyGSRHandle:=0;
    End; { If }
  Except
    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    _dynWiz := Nil;
  End;
End; { Dyn_MCM_SecWizard }





end.
