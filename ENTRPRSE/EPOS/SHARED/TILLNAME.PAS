unit TillName;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface
uses
  Classes, SysUtils, StrUtil;

type
  TTillObject = Class
    Number : Byte;
    CompanyCode : string6;
  end;

  TTillInfo = Class
    public
//      NoOfTills : integer;
      Names : TStringList;
//      Companies : TStringList;
      AllowModify : boolean;
      LastErrorNo : integer;
      constructor Load(bLock : boolean);
      function Add(iTillNo : byte; sNewName, sCompanyCode : string) : boolean;
      function Delete(iTillNo : Byte) : boolean;
      function SaveListEdits : boolean;
      function GetNextTillNo : byte;
      destructor Unload;
    private
      iLockPos : integer;
      bLocked : boolean;
      procedure LoadTillList;
      procedure GetRecord(bLock : boolean; bSetTills : boolean = TRUE);
  end;

implementation
uses
  MiscUtil, GlobVar, EPOSCnst, BtrvU2, APIUtil, Dialogs, BTSupU1;


constructor TTillInfo.Load(bLock : boolean);
var
  sKey : str255;
begin
  inherited create;

  Names := TStringList.Create;
//  Companies := TStringList.Create;

  if OpenEPOSBtrv(EPOSCentF) then GetRecord(bLock);
end;

procedure TTillInfo.GetRecord(bLock : boolean; bSetTills : boolean = TRUE);
var
  sKey : str255;
begin
  AllowModify := FALSE;

  sKey := 'N'; // This record should always exist, and holds the list of tills

  {Get (and lock) record}
  if bLock then LastErrorNo := Find_Rec(B_GetGEq + B_MultNWLock, F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0, sKey)
  else LastErrorNo := Find_Rec(B_GetGEq, F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0, sKey);

  case LastErrorNo of
    0 : begin
      {Found OK}
      GetPos(F[EposCentF], EposCentF, iLockPos);

      AllowModify := TRUE;
      bLocked := bLock;

      if bSetTills then LoadTillList;

    end;

//      84 : {record locked} ;

    else Report_BError(EposCentF,LastErrorNo);
  end;{case}
end;


procedure TTillInfo.LoadTillList;
var
  iPos : integer;
  oTill : TTillObject;
begin
//  NoOfTills := 0;
  For iPos := 1 to 99 do begin

    // Add Till Name and number to names list
    oTill := TTillObject.Create;
    oTill.Number := iPos;
    oTill.CompanyCode := EposCentRec.TillNames.Company[iPos];
    Names.AddObject(EposCentRec.TillNames.Name[iPos], oTill);

//    if EposCentRec.TillNames.Name[iPos] <> '' then begin
      // Add company code of till to company list
//      Companies.Add(EposCentRec.TillNames.Company[iPos]);
//       := iPos;
//    end;{if}
  end;{for}
end;

function TTillInfo.Add(iTillNo : byte; sNewName, sCompanyCode : string) : boolean;
var
  oTill : TTillObject;
begin
  EposCentRec.TillNames.Name[iTillNo] := sNewName;
  EposCentRec.TillNames.Company[iTillNo] := sCompanyCode;
//  GetRecord(TRUE);
  Result := Put_Rec(F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0) = 0;
  if Result then begin

//    oTill := TTillObject.Create;
//    oTill.Number := iTillNo;
//    oTill.CompanyCode := sCompanyCode;
    Names[iTillNo - 1] := sNewName;
    TTillObject(Names.Objects[iTillNo - 1]).CompanyCode := sCompanyCode;
//    Companies.Add(sCompanyCode);
//    inc(NoOfTills);
  end;{if}
end;

function TTillInfo.SaveListEdits : boolean;
var
  iResult, iPos : integer;
begin
  GetRecord(TRUE, FALSE);
  For iPos := 1 to 99 do begin
{    if (iPos - 1) >= Names.Count then
      begin
        EposCentRec.TillNames.Name[iPos] := '';
        EposCentRec.TillNames.Company[iPos] := '';
      end
    else begin}
    EposCentRec.TillNames.Name[iPos] := Names[iPos - 1];
    EposCentRec.TillNames.Company[iPos] := TTillObject(Names.Objects[iPos - 1]).CompanyCode;
//      NoOfTills := iPos;
//    end;{if}
  end;{for}

  iResult := Put_Rec(F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0);
  Result := iResult = 0;
end;

function TTillInfo.Delete(iTillNo : Byte) : boolean;
begin
  Result := FALSE;
//  if NoOfTills > 0 then begin
    EposCentRec.TillNames.Name[iTillNo] := '';
    EposCentRec.TillNames.Company[iTillNo] := '';
//    GetRecord(TRUE);
    Result := Put_Rec(F[EposCentF], EposCentF, RecPtr[EposCentF]^, 0) = 0;
    if Result then begin
      Names[iTillNo -1] := '';
      TTillObject(Names.Objects[iTillNo -1]).CompanyCode := '';
//      Companies.Delete(iTillNo - 1);
    end;{if}
//  end;{if}
end;

destructor TTillInfo.Unload;
begin
  if bLocked then UnLockMultiSing(F[EposCentF], EposCentF, iLockPos);
  ClearList(Names);
  Names.Free;
//  Companies.Free;
  inherited destroy;
end;

function TTillInfo.GetNextTillNo: byte;
var
  iPos : byte;
begin
  Result := 0;
  For iPos := 0 to Names.Count - 1 do
  begin
    if Names[iPos] = '' then
    begin
      Result := TTillObject(Names.Objects[iPos]).Number;
      Exit;
    end;{if}
  end;{for}
end;

end.
