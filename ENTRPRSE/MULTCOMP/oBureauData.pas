unit oBureauData;

interface

Uses Classes, Forms, SysUtils, enBureauIntF, CompanyCache;

Type
  TBureauDataObject = Class(TComponent, IBureauDataObject)
  Private
    FFileNo      : Byte;             // File Index
    FFilterKey   : ShortString;      // Filter Text
    FIndex       : Byte;             // Current Index
    FKeyString   : ShortString;      // Current Key Value
    FRecPosition : LongInt;          // Saved Record Position

    // List of company details stored for performance reasons
    CompInfoCache : TCompanyInfoCache;

    Procedure CopyDataRecord;
    Function GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
    Function TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
  Protected
    // IBtrieveFunctions methods
    function GetFirst: Integer; safecall;
    function GetPrevious: Integer; safecall;
    function GetNext: Integer; safecall;
    function GetLast: Integer; safecall;
    function Get_Position: Integer; safecall;
    procedure Set_Position(Value: Integer); safecall;
    function RestorePosition: Integer; safecall;
    function SavePosition: Integer; safecall;
    function GetLessThan(const SearchKey: WideString): Integer; safecall;
    function GetLessThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function GetEqual(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThan(const SearchKey: WideString): Integer; safecall;
    function GetGreaterThanOrEqual(const SearchKey: WideString): Integer; safecall;
    function Get_Index: Integer; safecall;
    procedure Set_Index(Value: Integer); safecall;

    // IBtrieveFunctions2 methods
    function Get_KeyString2: WideString; safecall;

    // IBureauDataObject methods
    Function GetCompanyCode : ShortString;
    Function GetCompanyName : ShortString;
    Function GetCompanyPath : ShortString;
    Function GetErrorStatus : SmallInt;
    Function GetErrorString : ShortString;
    Function GetDemoSystem : Boolean;

    Function CompanyStatus (CompCode : ShortString) : Boolean;

    Function GetAllowEnterprise : Boolean;
    Function GetAllowExchequer : Boolean;
    Function GetAllowEBusiness : Boolean;
    Function GetAllowSentimail : Boolean;

    Function GetExchWin9xCmdLine : ShortString;
    Function GetExchWinNTCmdLine : ShortString;
  Public
    Constructor Create(AOwner: TComponent; Const FileNo : SmallInt; Const SearchKey : ShortString);
    Destructor Destroy; Override;
  End; // TBureauDataObject

implementation

Uses GlobVar, VarConst, BtrvU2,
     BureauSecurity,     // SecurityManager Object
     ChkComp,            // Routines for checking the validity of a company dataset
     CompUtil,           // PathToShort
     EntLicence,         // EnterpriseLicence Object for accessing the Enterprise Licence details
     GroupCompFile,      // Company-Group XReference File
     GroupUsersFile,     // Definition of GroupUsr.Dat (GroupUsersF) and utility functions
     ETStrU, BTKeys1U;

//-------------------------------------------------------------------------

Constructor TBureauDataObject.Create(AOwner: TComponent; Const FileNo : SmallInt; Const SearchKey : ShortString);
Begin // Create
  Inherited Create(AOwner);

  // File No to be used - either CompF or GroupCompXRefF
  FFileNo := FileNo;
  // Filter Key is used to control which records are shown
  FFilterKey := SearchKey;
  // Current Index - have to use Index 0 on both companies - cannot switch
  FIndex  := 0;

  // List of company details stored for performance reasons
  CompInfoCache := TCompanyInfoCache.Create;
End; // Create

//------------------------------

Destructor TBureauDataObject.Destroy;
Begin // Destroy
  // List of company details stored for performance reasons
  FreeAndNIL(CompInfoCache);

  Inherited;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TBureauDataObject.CopyDataRecord;
Var
  CompDets : CompanyDetRec;
Begin // CopyDataRecord
  // Add the company details into the cache, this includes details of
  // directory and security checks for reporting errors in the company
  Case FFileNo Of
    CompF          : If (Not CompInfoCache.CompanyExists (Company^.CompDet.CompCode)) Then
                     Begin
                       CompInfoCache.GetCompanyDetails (Company^.CompDet);
                     End; // If (Not CompInfoCache.CompanyExists (

    GroupCompXRefF : If (Not CompInfoCache.CompanyExists (GroupCompFileRec^.gcCompanyCode)) Then
                     Begin
                       FillChar (CompDets, SizeOf(CompDets), #0);
                       CompDets.CompCode := GroupCompFileRec^.gcCompanyCode;
                       CompInfoCache.GetCompanyDetails (CompDets);
                     End; // If (Not CompInfoCache.CompanyExists (...
  Else
    Raise Exception.Create ('TBureauDataObject.CopyDataRecord - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
  End; // Case FFileNo
End; // CopyDataRecord

//-------------------------------------------------------------------------

Function TBureauDataObject.GetDataRecord (Const BtrOp : SmallInt; Const SearchKey : String = '') : Integer;
Var
  BtrOpCode : SmallInt;
  sKey      : Str255;

  //------------------------------

  // Copy of CheckKey from R&D\BTSUPU1.PAS as cannot include that module in this project
  Function CheckKey(KeyRef, Key2Chk : AnyStr; KeyLen : Integer; AsIs : Boolean) :  Boolean;
  Begin
    If (Length(Key2Chk)>=KeyLen) Then
    Begin
      Result := (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
    End // If (Length(Key2Chk)>=KeyLen)
    Else
    Begin
      Result := False;
    End; // Else
  end;

  //------------------------------

Begin { GetDataRecord }
  // Translate Btrieve operations where necessary to correctly filter the data
  Case BtrOp Of
    B_GetFirst    : Begin
                      sKey := FFilterKey + #0;
                      BtrOpCode := B_GetGEq;
                    End; { B_GetFirst }
    B_GetLast     : Begin
                      sKey := FFilterKey + #255;
                      BtrOpCode := B_GetLessEq;
                    End; { B_GetLast }
  Else
    // B_GetNext, B_GetPrev,
    sKey := FFilterKey + SearchKey;
    BtrOpCode := BtrOp;
  End; { Case BtrOp }

  // Get record
  Result := Find_Rec(BtrOpCode, F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, sKey);
  If (Result = 0) Then
  Begin
    // check correct record type was returned
    Case FFileNo Of
      CompF          : Begin
                         // Check it is a company details record
                         If (Company^.RecPFix = cmCompDet) Then
                         Begin
                           CopyDataRecord;
                         End // If
                         Else
                         Begin
                           Result := 4;
                         End; // Else
                       End; // CompF
      GroupCompXRefF : Begin
                         // Check it is within the group we are listing
                         If CheckKey(FFilterKey, sKey, Length(FFilterKey), BOn) Then
                         Begin
                           CopyDataRecord;
                         End // If CheckKey(...
                         Else
                         Begin
                           Result := 4;
                         End; // Else
                       End; // GroupCompXRefF
    Else
      Raise Exception.Create ('TBureauDataObject.GetDataRecord - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
    End; // Case FFileNo

    If (Result = 0) Then
    Begin
      FKeyString := GetCompanyCode;
    End; // If (Result = 0)
  End; // If (Result = 0)
End; // GetDataRecord

//-------------------------------------------------------------------------

function TBureauDataObject.GetFirst: Integer;
begin
  Result := GetDataRecord (B_GetFirst);
end;

//------------------------------

function TBureauDataObject.GetPrevious: Integer;
begin
  Result := GetDataRecord (B_GetPrev);
end;

//------------------------------

function TBureauDataObject.GetNext: Integer;
begin
  Result := GetDataRecord (B_GetNext);
end;

//------------------------------

function TBureauDataObject.GetLast: Integer;
begin
  Result := GetDataRecord (B_GetLast);
end;

//-------------------------------------------------------------------------

function TBureauDataObject.GetLessThan(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetLess, SearchKey);
end;

//------------------------------

function TBureauDataObject.GetLessThanOrEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetLessEq, SearchKey);
end;

//------------------------------

function TBureauDataObject.GetEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetEq, SearchKey);
end;

//------------------------------

function TBureauDataObject.GetGreaterThan(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetGretr, SearchKey);
end;

//------------------------------

function TBureauDataObject.GetGreaterThanOrEqual(const SearchKey: WideString): Integer;
begin
  Result := GetDataRecord (B_GetGEq, SearchKey);
end;

//-------------------------------------------------------------------------

Function TBureauDataObject.TranslateIndex (Const IdxNo : SmallInt; Const FromTLB : Boolean) : SmallInt;
begin
  Result := IdxNo;
end;

//------------------------------

function TBureauDataObject.Get_Index: Integer;
begin
  Result := TranslateIndex (FIndex, False);
end;

//------------------------------

procedure TBureauDataObject.Set_Index(Value: Integer);
Var
  lStatus, NewIdx : Integer;
  CurrPos         : LongInt;
begin
  // Convert Index to file Index Number
  NewIdx := TranslateIndex (Value, True);

  // Check value has changed
  If (NewIdx <> FIndex) Then
  Begin
    // Get current record position
    lStatus := GetPos(F[FFileNo], FFileNo, CurrPos);

    // Change Index
    FIndex := NewIdx;

    If (lStatus = 0) Then
    Begin
      { Restore position in file under new index }
      Case FFileNo Of
        CompF          : Move (CurrPos, Company^, SizeOf(FRecPosition));
        GroupCompXRefF : Move (CurrPos, GroupCompFileRec^, SizeOf(FRecPosition));
      Else
        Raise Exception.Create ('TBureauDataObject.Set_Index - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
      End; // Case FFileNo
      GetDirect(F[FFileNo], FFileNo, RecPtr[FFileNo], FIndex, 0);
    End; // If (lStatus = 0)
  End; // If (NewIdx <> FIndex)
End;

//-------------------------------------------------------------------------

function TBureauDataObject.Get_KeyString2: WideString;
begin
  Result := FKeyString
end;

//-------------------------------------------------------------------------

function TBureauDataObject.Get_Position: Integer;
begin
  Result := FRecPosition;
end;

//------------------------------

procedure TBureauDataObject.Set_Position(Value: Integer);
begin
  FRecPosition := Value;
end;

//------------------------------

function TBureauDataObject.SavePosition: Integer;
begin
  Result := GetPos(F[FFileNo], FFileNo, FRecPosition);
end;

//------------------------------

function TBureauDataObject.RestorePosition: Integer;
Var
  KeyS : Str255;
begin
  // Copy Record Position into Data Record
  Case FFileNo Of
    CompF          : Move (FRecPosition, Company^, SizeOf(FRecPosition));
    GroupCompXRefF : Move (FRecPosition, GroupCompFileRec^, SizeOf(FRecPosition));
  Else
    Raise Exception.Create ('TBureauDataObject.RestorePosition - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
  End; // Case FFileNo

  KeyS := '';
  Result := CTK_GetDirectCId(F[FFileNo], FFileNo, RecPtr[FFileNo]^, FIndex, 0, KeyS, Nil);

  // HM 29/01/01: Added Copy Data Record to update object properties
  If (Result = 0) Then
  Begin
    // Get object to update itself
    CopyDataRecord;

    // Update KeyString
    FKeyString := GetCompanyCode;
  End; { If (Result = 0) }
end;

//-------------------------------------------------------------------------

function TBureauDataObject.GetCompanyCode: ShortString;
begin
  Case FFileNo Of
    CompF          : Result := Company^.CompDet.CompCode;
    GroupCompXRefF : Result := GroupCompFileRec^.gcCompanyCode;
  Else
    Raise Exception.Create ('TBureauDataObject.GetCompanyCode - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
  End; // Case FFileNo
end;

//------------------------------

function TBureauDataObject.GetCompanyName: ShortString;
begin
  Result := CompInfoCache.CompanyCodeDetailsByCode [GetCompanyCode].CompDets.CompName;
end;

//------------------------------

Function TBureauDataObject.GetCompanyPath : ShortString;
Begin
  Result := CompInfoCache.CompanyCodeDetailsByCode [GetCompanyCode].CompDets.CompPath;
End;

//------------------------------

Function TBureauDataObject.GetErrorStatus : SmallInt;
Begin
  Result := CompInfoCache.CompanyCodeDetailsByCode [GetCompanyCode].CompDets.CompAnal;
End;

//------------------------------

Function TBureauDataObject.GetErrorString : ShortString;
Begin
  Result := '*** Error: ' + GetCompDirError (CompInfoCache.CompanyCodeDetailsByCode [GetCompanyCode].CompDets.CompAnal) + '***';
End;

//-------------------------------------------------------------------------

Function TBureauDataObject.GetDemoSystem : Boolean;
Begin
  Result := CompInfoCache.CompanyCodeDetailsByCode [GetCompanyCode].CompDets.CompDemoSys;
End;

//-------------------------------------------------------------------------

Function TBureauDataObject.CompanyStatus (CompCode : ShortString) : Boolean;
Begin
  Result := (CompInfoCache.CompanyCodeDetailsByCode [CompCode].CompDets.CompAnal <> 1);
End;

//-------------------------------------------------------------------------

Function TBureauDataObject.GetAllowEnterprise : Boolean;
Begin
  Case FFileNo Of
    CompF          : Result := True;
    GroupCompXRefF : Result := SecurityManager.smUserPermissions[upOpenEnterprise];
  Else
    Raise Exception.Create ('TBureauDataObject.GetAllowEnterprise - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
  End; // Case FFileNo
End;

//------------------------------

Function TBureauDataObject.GetAllowExchequer : Boolean;
Begin
  Case FFileNo Of
    CompF          : Result := SyssCompany^.CompOpt.OptShowExch;
    GroupCompXRefF : Result := SecurityManager.smUserPermissions[upOpenExchequer];
  Else
    Raise Exception.Create ('TBureauDataObject.GetAllowExchequer - Unknown FileNo (' + IntToStr(Ord(FFileNo)) + ')');
  End; // Case FFileNo
End;

//------------------------------

Function TBureauDataObject.GetAllowEBusiness : Boolean;
Begin
  Result := (EnterpriseLicence.elModules [modEBus] <> mrNone);
  If Result And (FFileNo = GroupCompXRefF) Then
  Begin
    Result := SecurityManager.smUserPermissions[upOpenEBusiness];
  End; // If Result And (FFileNo = GroupCompXRefF)
End;

//------------------------------

Function TBureauDataObject.GetAllowSentimail : Boolean;
Begin
  Result := (EnterpriseLicence.elModules [modElerts] <> mrNone);
  If Result And (FFileNo = GroupCompXRefF) Then
  Begin
    Result := SecurityManager.smUserPermissions[upOpenSentimail];
  End; // If Result And (FFileNo = GroupCompXRefF)
End;

//-------------------------------------------------------------------------

Function TBureauDataObject.GetExchWin9xCmdLine : ShortString;
Begin
  Result := ExtractFilePath(PathToShort(Application.EXEName)) + SyssCompany.CompOpt.OptWin9xCmd + '.BAT';
End;

//------------------------------

Function TBureauDataObject.GetExchWinNTCmdLine : ShortString;
Begin
  Result := ExtractFilePath(PathToShort(Application.EXEName)) + SyssCompany.CompOpt.OptWinNTCmd + '.BAT';
End;

//-------------------------------------------------------------------------

End.
