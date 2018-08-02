unit CompId;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows;

Type
  TCompanyIdCacheType = Class(TObject)
  Private
    FCompList : TStringList;
    FLiveCompanies : LongInt;

    Function FormatCID (Const CompanyId : LongInt) : ShortString;

    Function GetCacheTotal : LongInt;

    Function GetCompanyId (Index : LongInt) : ShortString;
    Function GetCompanyIdCount (Index : LongInt) : LongInt;
    Function GetLiveCompanies : LongInt;
  Public
    Constructor Create;
    Destructor Destroy; Override;

    { Adds the specified Company Id into the internal cache }
    Procedure AddToCache (Const CompanyId : LongInt; Const DemoData : Boolean = False);

    { Loads all Company Id's into the cache with no additional processing }
    Procedure BuildCache;

    { Returns True if the Company Id is already in the cache }
    Function  CheckExists (Const CompanyId : LongInt) : Boolean;

    { Generates a new unique Company Id }
    Function  GenCompId : LongInt;

    { Properties }
    Property CacheTotal : LongInt Read GetCacheTotal;
    Property CompanyId [Index : LongInt] : ShortString Read GetCompanyId;
    Property CompanyIdCount [Index : LongInt] : LongInt Read GetCompanyIdCount;

    // IAO - Number of Live Companies installed (i.e. not Demo Data) - Set by BuildCache
    Property LiveCompanies : LongInt Read GetLiveCompanies;
  End; { TCompanyIdCacheType }

implementation

Uses BtrvU2, GlobVar, VarConst, ETStrU, ETDateU, ETMiscU, BtKeys1U, BtSupU1, VarFPosU, EntLicence;

//-----------------------------------------

Constructor TCompanyIdCacheType.Create;
Begin { Create }
  Inherited;

  { Create StringList and set it to ignore duplicates added into list, }
  { therefore the number of items in the list is the number of companies }
  FCompList := TStringList.Create;
  FCompList.Sorted := True;
  FCompList.Duplicates := dupIgnore;

  FLiveCompanies := 0;
End; { Create }

//-----------------------------------------

Destructor TCompanyIdCacheType.Destroy;
Begin { Destroy }
  FreeAndNil (FCompList);

  Inherited;
End; { Destroy }

//-----------------------------------------

{ Formats a Company Id for adding into the Cache and for checking its exestance in the Cache }
Function TCompanyIdCacheType.FormatCID (Const CompanyId : LongInt) : ShortString;
Begin { FormatCID }
  Result := Format('%10.10d', [CompanyId]);
End; { FormatCID }

//-----------------------------------------

{ Returns the number of unique Company Id's in the cache }
Function TCompanyIdCacheType.GetCacheTotal : LongInt;
Begin { GetCacheTotal }
  If Assigned(FCompList) Then
    Result := FCompList.Count
  Else
    Result := 0;
end; { GetCacheTotal }

//-----------------------------------------

{ Adds the specified Company Id into the internal cache }
Procedure TCompanyIdCacheType.AddToCache (Const CompanyId : LongInt; Const DemoData : Boolean = False);
Var
  CID            : ShortString;
  CIDCnt, CIDIdx : LongInt;
Begin { AddToCache }
  { Format Company ID into standard string format }
  CID := FormatCID (CompanyId);

  { Check to see if it exists }
  CIDIdx := FCompList.IndexOf(CID);
  If (CIDIdx >= 0) Then Begin
    { CID already exists - get existing entry and increment counter }
    CIDCnt := LongInt(FCompList.Objects[CIDIdx]);
    Inc(CIDCnt);
    FCompList.Objects[CIDIdx] := TObject(CIDCnt);
  End { If (CIDIdx >= 0) }
  Else Begin
    CIDCnt := 1;
    FCompList.AddObject (FormatCID (CompanyId), TObject(CIDCnt));

    // MH 29/11/06: Extended to count licences used which for IAO is not related to the number of companies
    If (Not DemoData) Then
      Inc(FLiveCompanies);
  End; { Else }
End; { AddToCache }

//-----------------------------------------

{ Loads all Company Id's into the cache with no additional processing }
Procedure TCompanyIdCacheType.BuildCache;
Const
  FNum = CompF;
Var
  KeyS                 : Str255;
  LStatus              : Smallint;
  TmpComp              : ^CompRec;
  TmpStat, FKeyPath    : Integer;
  TmpRecAddr           : LongInt;
Begin { BuildCache }
  { Save current position in Company.Dat }
  New (TmpComp);
  TmpComp^ := Company^;
  FKeyPath := GetPosKey;
  TmpStat:=Presrv_BTPos(CompF,FKeyPath,F[CompF],TmpRecAddr,BOff,BOff);

  // MH 29/11/06: Extended to count licences used which for IAO is not related to the number of companies
  FLiveCompanies := 0;

  { Process Company Records }
  LStatus := Find_Rec(B_StepFirst, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  While (LStatus = 0) Do
  Begin
    // Check its a Company Record
    If (Company.RecPFix = cmCompDet) Then
    Begin
      { Add into Cache object for counting }
      AddToCache(Company.CompDet.CompId, Company.CompDet.CompDemoData);
    End; // If (Company.RecPFix = cmCompDet)

    LStatus := Find_Rec(B_StepNext, F[CompF], CompF, RecPtr[CompF]^, CompCodeK, KeyS);
  End; { While (LStatus = 0) }

  { Save current position in Company.Dat }
  TmpStat:=Presrv_BTPos(CompF,FKeyPath,F[CompF],TmpRecAddr,BOn,BOn);
//  TmpStat:=Presrv_BTPos(CompF,FKeyPath,F[CompF],TmpRecAddr,BOn,BOff);
//  Status:=GetDirect(F[CompF],CompF,RecPtr[CompF]^,FKeyPath,0); {* Re-Establish Position *}
  Company^ := TmpComp^;
  Dispose (TmpComp);
End; { BuildCache }

//-----------------------------------------

{ Returns True if the Company Id is already in the cache }
Function TCompanyIdCacheType.CheckExists (Const CompanyId : LongInt) : Boolean;
Begin { CheckExists }
  Result := FCompList.IndexOf(FormatCID (CompanyId)) >= 0;
End; { CheckExists }

//-----------------------------------------

{ Generates a new unique Company Id }
Function TCompanyIdCacheType.GenCompId : LongInt;
Begin { GenCompId }
  Repeat
    { Generate a random Company Id in the range 1 .. 99,999 }
    Result := 1 + Random (99998);
  Until Not CheckExists (Result);
End; { GenCompId }

//-----------------------------------------

function TCompanyIdCacheType.GetCompanyId(Index: Integer): ShortString;
begin
  If (Index >= 0) And (Index < FCompList.Count) Then
    Result := FCompList.Strings[Index]
  Else
    Raise Exception.Create ('Invalid Index ' + IntToStr(Index));
end;

//-----------------------------------------

function TCompanyIdCacheType.GetCompanyIdCount(Index: Integer): LongInt;
Var
  CIDCnt : LongInt;
begin
  If (Index >= 0) And (Index < FCompList.Count) Then Begin
    CIDCnt := LongInt(FCompList.Objects[Index]);
    Result := CIDCnt;
  End { If (Index ... }
  Else
    Raise Exception.Create ('Invalid Index ' + IntToStr(Index));
end;

//-------------------------------------------------------------------------

Function TCompanyIdCacheType.GetLiveCompanies : LongInt;
Begin // GetLiveCompanies
  If EnterpriseLicence.IsLITE Then
    Result := FLiveCompanies
  Else
    Result := GetCacheTotal;
End; // GetLiveCompanies

//-------------------------------------------------------------------------

Initialization
  Randomize;
end.

