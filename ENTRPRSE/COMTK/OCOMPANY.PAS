unit oCompany;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     GlobVar, VarConst, VarRec2U,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, VarCnst3, oBtrieve,
     oAddr, MiscFunc, BtrvU2, ExBtTH1U, ExceptIntf;


{$I COMPVAR.PAS}

type
  TCompanyManager = Class;

  TCompanyDetail = Class(TAutoIntfObjectEx, ICompanyDetail, ICompanyDetail2)
  private
    FCompRec : CompanyDetRec;
  protected
    // ICompanyDetail
    function  Get_coCode: WideString; safecall;
    function  Get_coName: WideString; safecall;
    function  Get_coPath: WideString; safecall;

    // ICompanyDetail2
    function Get_coConnect: WideString; safecall;
  public
    Constructor Create (Const CompRec : CompanyDetRec);
  End; { ICompanyDetail }

  {-----------------------------------------}

  TCompanyManager = Class(TAutoIntfObjectEx, ICompanyManager, ICompanyManager2)
  private
    FMCMList : TList;
  protected
    // ICompanyManager
    function  Get_cmCount: Integer; safecall;
    function  Get_cmCompany(Index: Integer): ICompanyDetail; safecall;

    // ICompanyManager2
    function IndexOf(SearchBy: TCompanyManagerSearchMode; const SearchFor: WideString): Integer; safecall;

    procedure ClearList;
  public
    Constructor Create;
    Destructor Destroy; override;

    // Local methods
    procedure BuildCompanyList(Const EntPath : ShortString);
  End; { TCompanyManager }

implementation

uses ComServ, EtStrU,
{$IFDEF EXSQL}
  SQLUtils,
{$ENDIF}
  EntLicence;

Type
  TCompanyType = Record
    CompO  : TCompanyDetail;
    CompI  : ICompanyDetail;
  End;
  pTCompanyType = ^TCompanyType;

Var
  CompFile : Comp_FileDef;
  Company  : ^CompRec;

{$I MCmpFile}

{-------------------------------------------------------------------------------------------------}

Constructor TCompanyDetail.Create (Const CompRec : CompanyDetRec);
begin { Create }
  Inherited Create (ComServer.TypeLib, ICompanyDetail2); //PR: 21/01/2011 ABSEXCH-10392

  FCompRec := CompRec;
end; { Create }

{-----------------------------------------}

function TCompanyDetail.Get_coCode: WideString;
begin
  Result := FCompRec.CompCode;
end;

{-----------------------------------------}

function TCompanyDetail.Get_coName: WideString;
begin
  Result := FCompRec.CompName;
end;

{-----------------------------------------}

function TCompanyDetail.Get_coPath: WideString;
begin
  Result := FCompRec.CompPath;
end;

//------------------------------

function TCompanyDetail.Get_coConnect: WideString;
var
  ConnectionString, lPassword: WideString;
Begin // Get_coConnect
  Result := '';
{$IFDEF EXSQL}
  If EnterpriseLicence.IsSQL Then
  begin
    //SQLUtils.GetConnectionString(FCompRec.CompCode, True, ConnectionString);
    SQLUtils.GetConnectionStringWoPass(FCompRec.CompCode, True, ConnectionString, lPassword) ;
    Result := ConnectionString + ';Password=' + lPassword ;
  end;
{$ENDIF}
End; // Get_coConnect

{-------------------------------------------------------------------------------------------------}

Constructor TCompanyManager.Create;
begin { Create }
  Inherited Create (ComServer.TypeLib, ICompanyManager);

  FMCMList := TList.Create;
end; { Create }

{-----------------------------------------}

Destructor TCompanyManager.Destroy;
begin { Destroy }
  // Empty and Destroy list of companies
  ClearList;
  FreeAndNil(FMCMList);

  inherited Destroy;
end; { Destroy }

{-----------------------------------------}

procedure TCompanyManager.ClearList;
Var
  CompObj  : pTCompanyType;
begin { ClearList }
  If Assigned(FMCMList) Then
    While (FMCMList.Count > 0) Do Begin
      // free company structure
      CompObj := FMCMList.Items[0];
      With CompObj^ Do Begin
        CompO := Nil;
        CompI := Nil;
      End; { With }
      Dispose(CompObj);
      FMCMList.Items[0] := NIL;

      // remove list entry
      FMCMList.Delete (0);
    End; { While (FMCMList.Count > 0)  }
end; { ClearList }

{-----------------------------------------}

procedure TCompanyManager.BuildCompanyList(Const EntPath : ShortString);
Var
  CompObj  : pTCompanyType;
  KeyS     : Str255;
  Res      : SmallInt;
begin { BuildCompanyList }
  // Clear out any pre-existing companies from list
  ClearList;

  // Define Btrieve Interface }
  DefineCompany;

  // Open file
  Res := Open_File(F[CompF], EntPath + FileNames[CompF], 0);
  If (Res = 0) Then Begin
    KeyS := cmCompDet + #0;
    Res := Find_Rec(B_GetGEq, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    While (Res = 0) And (Company^.RecPFix = cmCompDet) Do Begin
      New(CompObj);
      With CompObj^ Do Begin
        CompO := TCompanyDetail.Create (Company^.CompDet);
        CompI := CompO;
      End; { With }
      FMCMList.Add (CompObj);

      Res := Find_Rec(B_GetNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
    End; { While }

    { Close file }
    Close_File(F[CompF]);
  End { If (Res = 0) }
  Else
    Raise Exception.Create ('Cannot open Company.Dat in ' + EntPath + ', error ' + IntToStr(Res));
End; { BuildCompanyList }

{-----------------------------------------}

function TCompanyManager.Get_cmCompany(Index: Integer): ICompanyDetail;
begin
  If (Index >= 1) And (Index <= FMCMList.Count) Then
    Result := pTCompanyType(FMCMList[Index - 1]).CompI
  Else
    Raise EInvalidMethod.Create('Invalid Company Number (' + IntToStr(Index) + ')');
end;

{-----------------------------------------}

function TCompanyManager.Get_cmCount: Integer;
begin
  Result := FMCMList.Count;
end;

//------------------------------

function TCompanyManager.IndexOf(SearchBy: TCompanyManagerSearchMode; const SearchFor: WideString): Integer;
Var
  oComp2 : ICompanyDetail2;
  sSearchFor : ShortString;
  I : SmallInt;
Begin // IndexOf
  Result := -1;

  If (FMCMList.Count > 0) Then
  Begin
    sSearchFor := UpperCase(Trim(SearchFor));

    For I := 0 To (FMCMList.Count -1) Do
    Begin
      oComp2 := (pTCompanyType(FMCMList[I]).CompI As ICompanyDetail2);

      Case SearchBy Of
        smCoCode : If (UpperCase(Trim(oComp2.coCode)) = sSearchFor) Then
                     Result := I + 1;
        smCoName : If (UpperCase(Trim(oComp2.coName)) = sSearchFor) Then
                     Result := I + 1;
        smCoPath : If (UpperCase(Trim(oComp2.coPath)) = sSearchFor) Then
                     Result := I + 1;
      End; // Case SearchBy

      If (Result <> -1) Then
        Break;
    End; // For I
  End; // If (FMCMList.Count > 0)
End; // IndexOf

//-------------------------------------------------------------------------


Initialization
  New(Company);
Finalization
  Dispose(Company);
end.
