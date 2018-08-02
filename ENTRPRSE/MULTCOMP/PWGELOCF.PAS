unit PWGELocF;
//
// Pervasive.SQL Worgkroup Engine Locator File functions
//

interface

Uses Classes, Controls, Dialogs, FileCtrl, Forms, SysUtils, Windows, WiseUtil;

{$IFDEF NOSHMEM}  // EntComp2.Dll
// Creates the Gateway and Redirecting Locator Files for the
// P.SQL v8 Workgroup Engine in the main Enterprise directory
function SCD_GenRootLocFiles(var DLLParams: ParamRec): LongBool; StdCall; export;

// Runs through the Company List in Company.Dat creating the Gateway
// and Redirecting Locator Files for the P.SQL v8 Workgroup Engine
function SCD_GenLocFiles(var DLLParams: ParamRec): LongBool; StdCall; export;
{$ENDIF}

implementation

Uses GlobVar, VarConst, BtrvU2, EntRegU, RegProg, GlobExcH, CompUtil;

//-------------------------------------------------------------------------

// Remove any pre-existing Gateway Locator Filez
Procedure RemoveLocatorFile (Const CompanyDir  : ShortString);
Begin // RemoveLocatorFile
//ShowMessage (Format('RemoveLocatorFile (%s)', [CompanyDir]));
  If FileExists (CompanyDir + '~PVSW~.LOC') Then
  Begin
    // Remove Read-only attribute if present
    FileSetAttr (CompanyDir + '~PVSW~.LOC', 0);
    SysUtils.DeleteFile (CompanyDir + '~PVSW~.LOC');
  End; // If FileExists (CompanyDir + '~PVSW~.LOC')
End; // RemoveLocatorFile

//-------------------------------------------------------------------------

// ProcessCompanyDir - Creates Redirecting Locator Files in subdirectories
// by recursively scanning the directory tree
//
//   CompanyDir - A valid path including a '\'
//   RootDir    - Don't Want RLF's in Root Directory of DataSet
//
Procedure ProcessCompanyDir (Const CompanyDir  : ShortString;
                             Const RootDir     : Boolean);
Var
  FileInfo : ^TSearchRec;
  FStatus  : SmallInt;
  LocFile  : ShortString;
Begin
//ShowMessage (Format('ProcessCompanyDir (%s)', [CompanyDir]));
  RemoveLocatorFile (CompanyDir);

  If (Not RootDir) Then
  Begin
    // Create a new Gateway/Redirecting locator files
    With TStringList.Create Do
    Begin
      Try
        // Create Redirecting Locator File telling the WGE to look in the directory below
        Add ('=>..\');

        Try
          // Create the file and make it read-only as per PVSW spec
          SaveToFile (CompanyDir + '~PVSW~.LOC');
        Except
          // MH 16/03/06: Suppress any errors trying to update the locator files
        End;

        FileSetAttr (CompanyDir + '~PVSW~.LOC', faReadOnly);
      Finally
        Free;
      End; // Try..Finally
    End; // With TStringList.Create
  End; // If (Not RootDir)

  // Scan for subdirectories and put RLF's in them as well
  New(FileInfo);
  Try
    FStatus := FindFirst(CompanyDir + '*.*', faDirectory or faHidden or faReadOnly, FileInfo^);
    Try
      While (FStatus = 0) Do
      Begin
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then
        Begin
          If ((FileInfo.Attr And faDirectory) = faDirectory) Then
          Begin
            { scan files in subdirectory }
            // MH 11/05/06: Don't do pre-reqs folder as may upset some finicky setup program
            If (UpperCase(FileInfo.Name) <> 'PREREQS') Then
              ProcessCompanyDir (IncludeTrailingPathDelimiter(CompanyDir + FileInfo.Name), False);
          End; // If ((FileInfo.Attr And faDirectory) = faDirectory)
        End; // If (FileInfo.Name <> '.') And (FileInfo.Name <> '..')

        FStatus := FindNext(FileInfo^);
      End; { While (FStatus = 0) }
    Finally
      SysUtils.FindClose (FileInfo^);
    End; // Try..Finally
  Finally
    Dispose(FileInfo);
  End; // Try..Finally
End;

//-------------------------------------------------------------------------

// Create a Gateway Locator File containing the name of the Workgroup Server workstation
Procedure CreateGLF (Const CompanyDir  : ShortString;
                     Const ServerPC    : ShortString);
Begin // CreateGLF
//ShowMessage (Format('CreateGLF (%s, %s)', [CompanyDir, ServerPC]));
  RemoveLocatorFile (CompanyDir);

  With TStringList.Create Do
  Begin
    Try
      Add (ServerPC);

      Try
        // Create the file and make it read-only as per PVSW spec
        SaveToFile (CompanyDir + '~PVSW~.LOC');
      Except
        // MH 16/03/06: Suppress any errors trying to update the locator files
      End;

      FileSetAttr (CompanyDir + '~PVSW~.LOC', faReadOnly);
    Finally
      Free;
    End; // Try..Finally
  End; // With TStringList.Create
End; // CreateGLF

//-------------------------------------------------------------------------

{$IFDEF NOSHMEM}  // EntComp2.Dll

// Creates the Gateway and Redirecting Locator Files for the
// P.SQL v8 Workgroup Engine in the main Enterprise directory
function SCD_GenRootLocFiles(var DLLParams: ParamRec): LongBool;
Var
  V_RootDir, WG_ServerPC : String;
  RootDirs               : TStringList;
  DllStatus              : LongInt;
Begin // SCD_GenRootLocFiles
  DllStatus := 1000;

  Try
    { Get Enterprise Main Directory from WISE }
    GetVariable(DLLParams, 'V_ROOTDIR', V_RootDir);
    FixPath (V_RootDir);

    // Get name of Server PC from Install/Upgrade program
    GetVariable(DLLParams, 'WG_SERVERPC', WG_ServerPC);

    // Create the Redirecting Locator Files in all sub-directories
    ProcessCompanyDir (IncludeTrailingPathDelimiter(Trim(V_RootDir)),
                       True);

    // Create a Gateway Locator File in the main directory
    CreateGLF (IncludeTrailingPathDelimiter(Trim(V_RootDir)), WG_ServerPC);

    DllStatus := 0;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1001;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_GenRootLocFiles

{$ENDIF}

//-------------------------------------------------------------------------

{$IFDEF NOSHMEM}  // EntComp2.Dll

// Runs through the Company List in Company.Dat creating the Gateway
// and Redirecting Locator Files for the P.SQL v8 Workgroup Engine
function SCD_GenLocFiles(var DLLParams: ParamRec): LongBool;
Const
  FNum    = CompF;
  KeyPath : Integer = CompCodeK;
Var
  lStatus, I             : SmallInt;
  V_MainDir, WG_ServerPC : String;
  KeyS                   : Str255;
  DllStatus              : LongInt;
  RootDirList            : TStringList;
Begin // SCD_GenLocFiles
  DllStatus := 1000;

  Try
    { Get Enterprise Main Directory from WISE }
    GetVariable(DLLParams, 'V_MAINDIR', V_MainDir);
    FixPath (V_MainDir);

    // Get name of Server PC from Install/Upgrade program
    GetVariable(DLLParams, 'WG_SERVERPC', WG_ServerPC);

    { open company database }
    lStatus := Open_File(F[FNum], V_MainDir + FileNames[FNum], 0);

    If (lStatus = 0) Then
    Begin
      // Use a stringlist to store all the Root directories so that they can be
      // written at the end - this prevents the GLF's in nested companies from
      // being overwritten by RLF's
      RootDirList := TStringList.Create;
      Try
        lStatus := Find_Rec(B_GetFirst, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        While (lStatus = 0) Do
        Begin
          If (Company^.RecPFix = cmCompDet) Then
          Begin
            With Company^.CompDet Do
            Begin
              // Company Dataset

              // Create the Redirecting Locator Files in all sub-directories
              ProcessCompanyDir (IncludeTrailingPathDelimiter(Trim(CompPath)),
                                 True);

              // Store the root directory in a list so that the GLF's can be created at the end
              RootDirList.Add (IncludeTrailingPathDelimiter(Trim(CompPath)));
            End; // With Company^.CompDet
          End; // If (Company^.RecPFix = cmCompDet)

          lStatus := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);
        End; // While (lStatus = 0)

        // Create the Gateway Locator Files
        If (RootDirList.Count > 0) Then
        Begin
          For I := 0 To Pred(RootDirList.Count) Do
          Begin
            // Create a Gateway Locator File in the main directory
            CreateGLF (RootDirList[I], WG_ServerPC);
          End; // For I
        End; // If (RootDirList.Count > 0)

        DLLStatus := 0;
      Finally
        FreeAndNIL(RootDirList);

        { close company database }
        Close_File(F[CompF]);
      End; // Try..Finally
    End // If (lStatus = 0)
    Else
      { Btrieve Error opening Company.Dat }
      DLLStatus := 10100 + lStatus;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      DLLStatus := 1001;
    End; { On }
  End;

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // SCD_GenLocFiles

{$ENDIF}

//-------------------------------------------------------------------------



end.
