unit oSysF;

interface

{$Warn Unit_Platform Off}
{$Warn Symbol_Platform Off}

{$ALIGN 1}

Uses Classes, Dialogs, FileCtrl, SysUtils, Windows, GlobVar, BtrvU2,
     Graphics, VarRec2U;

  {$I VARCOMNU.Pas}
  {$I VARCMN3U.Pas}
  {$I VarRec.Pas}

Type
  TSystemSetupFile = Class(TObject)
  Private
    FSKey  : Str255;
    function GetESN: ISNArrayType;
    function GetDemoVer: Boolean;
  Protected
  Public
    Constructor Create;
    Destructor Destroy; Override;

    Function OpenData (Const EntPath: ShortString) : LongInt;
    Procedure CloseData;

    Function LoadSyss : LongInt;

    Property DemoVer : Boolean Read GetDemoVer;
    Property ESN : ISNArrayType Read GetESN;
  End; { TSystemSetupFile }

implementation

Const
  {$I FilePath.Inc}

Var
  // System Setup Record and File
  Syss      : Sysrec;
  SysFile   : Sys_FileDef;

//--------------------------------------------------------------------------

Constructor TSystemSetupFile.Create;
Const
  Idx = SysF;
Begin { Create }
  Inherited Create;

  // Initialise Btrieve Settings for ExchqSS.Dat
  With SysFile Do Begin
    FileSpecLen[Idx]:=Sizeof(SysFile);                      { <<<<<<<<******** Change }
    Fillchar(SysFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Syss);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=SNofKeys;                                      { <<<<<<<<******** Change }
    Variable:=1;

    { 00 - SysID (SysK)  }                     { <<<<<<<<******** Change }
    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=03;
    KeyBuff[1].KeyFlags:=ModFy;
  End; { With SysFile }

  FileRecLen[Idx]:=Sizeof(Syss);                             { <<<<<<<<******** Change }
  Fillchar(Syss,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }
  RecPtr[Idx]:=@Syss;
  FileSpecOfs[Idx]:=@SysFile;

  FileNames[Idx]:=PathSys;
End; { Create }

//---------------------------------------

Destructor TSystemSetupFile.Destroy;
Begin { Destroy }

  inherited;
End; { Destroy }

//--------------------------------------------------------------------------

Function TSystemSetupFile.OpenData(Const EntPath: ShortString): LongInt;
Begin { OpenData }
  Result := Open_File(F[SysF], EntPath + FileNames[SysF], 0);
End; { OpenData }

//---------------------------------------

Procedure TSystemSetupFile.CloseData;
Var
  FSpec   : FileSpec;
  lStatus : SmallInt;
Begin { CloseData }
  // Check to see if ExchqSS.Dat is open
  lStatus := GetFileSpec(F[SysF], SysF, FSpec);

  If (lStatus = 0) then
    // File open - Close it
    Close_File(F[SysF]);
End; { CloseData }

//--------------------------------------------------------------------------

Function TSystemSetupFile.LoadSyss : LongInt;
Begin { LoadSyss }
  FsKey := SysNames[SysR];
  Result := Find_Rec (B_GetEq, F[SysF], SysF, Syss, 0, FSKey);
End; { LoadSyss }

//--------------------------------------------------------------------------

function TSystemSetupFile.GetESN: ISNArrayType;
begin
  Result := Syss.EXISN;
end;

//--------------------------------------------------------------------------

function TSystemSetupFile.GetDemoVer: Boolean;
begin
  Result := Syss.ExDemoVer;
end;

//--------------------------------------------------------------------------

end.
