unit TCompObj;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, FileCtrl, Forms, SysUtils, Windows, GlobVar, VarConst,
     BtrvU2, BtSupU1, VarRec2U;


Type
  TFileRange = 1..MaxFiles;

  TCompany = Class(TObject)
  Private
    FDataPath : String;
    FDLLStatus : LongInt;
    FFileOpen  : Array [TFileRange] Of Boolean;
  Protected
    Function  GetFileOpen (Index : TFileRange) : Boolean;
    Function  GetSystemFound : Boolean;
  Public
    Constructor Create (Const DataPath : String);
    Destructor Destroy; Override;

    Function  CheckISN (Const EntISN : ISNArrayType) : Boolean;
    Procedure CloseFiles;
    Function  LockSys(Const SysMode :  SysRecTypes) : Boolean;
    Function  OpenDataFile (Const FileNo : Integer) : Boolean;
    Procedure UpdateSys(Const SysMode :  SysRecTypes);

    Property FileOpen[Index : TFileRange] : Boolean Read GetFileOpen;
  Published
    Property DataPath : String Read FDataPath;
    Property DLLStatus : LongInt Read FDLLStatus;
    Property SystemFound : Boolean Read GetSystemFound;
  End; { TCompany }

implementation

{$IFDEF EXSQL}
uses SQLUtils;
{$ENDIF}

Const
  {$I FilePath.Inc}

{---------------------------------------------------------------------------}

Constructor TCompany.Create (Const DataPath : String);
Var
  I : SmallInt;
  J : SysRecTypes;
Begin { Create }
  FDataPath := DataPath;
  FDLLStatus := 0;

  For I := Low(FFileOpen) To High(FFileOpen) Do
    FFileOpen[I] := False;
End; { Create }

{---------------------------------------------------------------------------}

Destructor TCompany.Destroy;
Begin { Destroy }
  { Close all open files }
  CloseFiles;

End; { Destroy }

{---------------------------------------------------------------------------}

Procedure TCompany.CloseFiles;
Var
  I : SmallInt;
Begin { CloseFiles }
  For I := Low(FFileOpen) To High(FFileOpen) Do Begin
    If FileOpen[I] Then Begin
      Close_File (F[I]);

      FFileOpen[I] := False;
    End; { If FileOpen[I] }
  End; { For I }
End; { CloseFiles }

{---------------------------------------------------------------------------}

{ Check to see if Btrieve file exists and attempt to open it. Returns True }
{ if opened OK, status code is stored in globally to main proc in LStatus  }
Function TCompany.OpenDataFile (Const FileNo : Integer) : Boolean;
Var
  LStatus   : Integer;
Begin { OpenDataFile }
  FDLLStatus := 0;

  If Not FileOpen[FileNo] Then Begin
    { Open specified file }
    LStatus := Open_File(F[FileNo], FDataPath + FileNames[FileNo], 0);
{If LStatus <> 0 Then
  ShowMessage ('Open_File (' + FDataPath + FileNames[FileNo] + ') = ' + IntToStr(LStatus));}

    { Set open flag }
    FFileOpen [FileNo] := (LStatus = 0);

    Result := (LStatus = 0);

    FDLLStatus := LStatus;
  End { If }
  Else
    Result := True;
End; { OpenDataFile }

{---------------------------------------------------------------------------}

Function TCompany.GetFileOpen (Index : TFileRange) : Boolean;
Begin { GetFileOpen }
  Result := FFileOpen[Index];
End; { GetFileOpen }

{---------------------------------------------------------------------------}

Function TCompany.CheckISN (Const EntISN : ISNArrayType) : Boolean;
Var
  WantLock : Boolean;
Begin { CheckISN }
  Result := False;

  If OpenDataFile (SysF) Then Begin
    WantLock := False;
    If GetMultiSys(False, WantLock, SysR) Then Begin
      With Syss Do Begin
        Result := (ExISN[1] = EntISN[1]) And (ExISN[2] = EntISN[2]) And
                  (ExISN[3] = EntISN[3]) And (ExISN[4] = EntISN[4]) And
                  (ExISN[5] = EntISN[5]) And (ExISN[6] = EntISN[6]);

        { HM 01/09/99: Modified to accept all zeros as valid as well }
        If (Not Result) Then
          Result := (ExISN[1] = 0) And (ExISN[2] = 0) And
                    (ExISN[3] = 0) And (ExISN[4] = 0) And
                    (ExISN[5] = 0) And (ExISN[6] = 0);
      End; { With Syss }
    End; { If }
  End; { If }

  If Result Then Begin
    If OpenDataFile (PwrdF) Then Begin
      { Check duplicate record matches }



    End; { If }
  End; { If }
End; { CheckISN }

{---------------------------------------------------------------------------}

Function TCompany.GetSystemFound : Boolean;
Begin { GetSystemFound }
{$IFDEF EXSQL}
  Result := SQLUtils.ValidCompany(FDataPath);
{$ELSE}
  Result := FileExists (FDataPath + PathSys) And             { ExChQss.Dat }
            FileExists (FDataPath + Path1 + CustName) And    { CustSupp.Dat }
            FileExists (FDataPath + Path2 + DocName) And     { Document.Dat }
            FileExists (FDataPath + Path3 + PassNam) And     { ExchqChk.Dat }
            // HM 27/03/02: Dictnary.Dat moved to exe dir only - not a company specific file any more
            //FileExists (FDataPath + Path5 + RepDictNam) And  { Dictnary.Dat }
            DirectoryExists (FDataPath + 'FORMS');
{$ENDIF}
End; { GetSystemFound }

{---------------------------------------------------------------------------}

Function TCompany.LockSys(Const SysMode :  SysRecTypes) : Boolean;
Var
  WantLock : Boolean;
Begin { LockSys }
  FDLLStatus := 0;

  // HM 01/05/02: Why isn't WantLock initialised?  Is this deliberate or a bug?
  //              Not changed as not causing any known problems at this point.

  Result := GetMultiSys(True, WantLock, SysMode);
End; { LockSys }

{---------------------------------------------------------------------------}

Procedure TCompany.UpdateSys(Const SysMode :  SysRecTypes);
Var
  WantLock : Boolean;
Begin { UpdateSys }
  FDLLStatus := 0;

  PutMultiSys(SysMode, True);
End; { UpdateSys }

{---------------------------------------------------------------------------}

end.
