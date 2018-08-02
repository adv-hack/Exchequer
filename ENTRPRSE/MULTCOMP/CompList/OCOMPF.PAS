unit oCompF;

{$ALIGN 1}

interface

{$Warn Unit_Platform Off}
{$Warn Symbol_Platform Off}

Uses Classes, Dialogs, FileCtrl, SysUtils, Windows, GlobVar, BtrvU2,
     VarRec2U;

{$I CompVar.Pas}

Type
  TCompanyFile = Class(TObject)
  Private
    FSKey  : Str255;

    function GetMcmCode: ShortString;
    function GetMcmCompany: ShortString;
    function GetMcmPath: ShortString;
    function GetRecType: Char;
    function GetRecCount: LongInt;
  Protected
  Public
    Property mcmCode : ShortString Read GetMcmCode;
    Property mcmCompany : ShortString Read GetMcmCompany;
    Property mcmPath : ShortString Read GetMcmPath;

    Property RecCount : LongInt Read GetRecCount;
    Property RecType : Char Read GetRecType;
    Property SearchKey : Str255 Read FSKey;

    Constructor Create;
    Destructor Destroy; Override;

    Function OpenData (Const EntPath: ShortString) : LongInt;
    Procedure CloseData;

    Function GetFirst : LongInt;
    Function GetNext : LongInt;
  End;


implementation

Const
  MultCompNam = 'COMPANY.DAT';

Var
  // Company Record and File
  Company       : ^CompRec;
  SyssCompany   : ^CompRec;
  CompFile      : Comp_FileDef;

//--------------------------------------------------------------------------

{$DEFINE HKSEC}
{$I MCmpFile.Pas}
{$UNDEF HKSEC}

//--------------------------------------------------------------------------

Constructor TCompanyFile.Create;
Begin { Create }
  Inherited Create;

End; { Create }

//---------------------------------------

Destructor TCompanyFile.Destroy;
Begin { Destroy }

  inherited;
End; { Destroy }

//--------------------------------------------------------------------------

Function TCompanyFile.OpenData (Const EntPath: ShortString) : LongInt;
Begin { OpenData }
  Result := Open_File(F[CompF], EntPath + FileNames[CompF], 0);
End; { OpenData }

//--------------------------------------------------------------------------

Procedure TCompanyFile.CloseData;
Var
  FSpec   : FileSpec;
  lStatus : SmallInt;
Begin { CloseData }
  // Check to see if Company.Dat is open
  lStatus := GetFileSpec(F[CompF], CompF, FSpec);

  If (lStatus = 0) then
    // File open - Close it
    Close_File(F[CompF]);
End; { CloseData }

//--------------------------------------------------------------------------

Function TCompanyFile.GetFirst : LongInt;
Begin { GetFirst }
  Result := Find_Rec (B_GetFirst, F[CompF], CompF, Company^, 0, FSKey);
End; { GetFirst }

//--------------------------------------------------------------------------

Function TCompanyFile.GetNext : LongInt;
Begin { GetNext }
  Result := Find_Rec (B_GetNext, F[CompF], CompF, Company^, 0, FSKey);
End; { GetNext }

//--------------------------------------------------------------------------

function TCompanyFile.GetMcmCode: ShortString;
begin
  Result := Company^.CompDet.CompCode;
end;

//---------------------------------------

function TCompanyFile.GetMcmCompany: ShortString;
begin
  Result := Company^.CompDet.CompName;
end;

//---------------------------------------

function TCompanyFile.GetMcmPath: ShortString;
begin
  Result := Company^.CompDet.CompPath;
end;

//---------------------------------------

function TCompanyFile.GetRecType: Char;
begin
  Result := Company^.RecPFix;
end;

//--------------------------------------------------------------------------

function TCompanyFile.GetRecCount: LongInt;
begin
  // Get number of records in Company.Dat
  Result := Used_Recs(F[CompF], CompF);
end;

//--------------------------------------------------------------------------

Initialization
  New(Company);
  FillChar(Company^,Sizeof(Company^),0);

  New(SyssCompany);
  FillChar(SyssCompany^,Sizeof(SyssCompany^),0);

  // Setup File Structures for Company.Dat
  DefineCompany;
Finalization
  Dispose(SyssCompany);
  Dispose(Company);
end.
