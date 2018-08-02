unit DictionaryProc;

interface
uses
  DictRecord;

  Procedure DeleteAllXrefRecs(sFieldCode : string);
  Procedure AddAllXrefRecs(DictFieldRec : DataVarType);
  function AddXrefRec(sFieldCode : string; iVersion, iFile : integer): boolean;
  function DeleteXrefRec(sFieldCode : string; iVersion, iFile : integer): boolean;

type
  TPrevRec = Record
    iLastAddedVarNo : LongInt;
    iAvailFile : LongInt;
    iAvailFile2 : LongInt;
    iAvailVer : LongInt;
  end;

var
  PrevRec : TPrevRec;

implementation
uses
  BTConst, BTUtil, BTFiles, MathUtil;

Procedure DeleteAllXrefRecs(sFieldCode : string);
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
begin
  repeat
    BTRec.KeyS := XrefRecordPrefix + sFieldCode;
    BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dxIdxFieldCode, BTRec.KeyS);
    if BTRec.Status = 0 then
    begin
      BTRec.Status := BTDeleteRecord(btFileVar[DictionaryF], LDictionaryRec
      , SizeOf(LDictionaryRec), dxIdxFieldCode);
      BTShowError(BTRec.Status, 'BTDeleteRecord', btFileName[DictionaryF]);
    end;{if}
  until (BTRec.Status <> 0)
end;

Procedure AddAllXrefRecs(DictFieldRec : DataVarType);
var
  iPos2, iPos1 : integer;
  bAddRec : boolean;
  LDictionaryRec : DataDictRec;
  BTRec : TBTRec;
begin
  For iPos1 := 1 to NoOfExchVersions do
  begin
    if BitIsSet(DictFieldRec.AvailVer, aExchVersionsBitFlag[iPos1]) then
    begin
      For iPos2 := 1 to NoOfAvailFiles do
      begin
        if iPos2 < 32
        then bAddRec := BitIsSet(DictFieldRec.AvailFile, aAvailFilesBitFlag[iPos2])  // 1-31 stored in the first field
        else bAddRec := BitIsSet(DictFieldRec.AvailFile2, aAvailFilesBitFlag[iPos2]); // 32- stored in the second field
        if bAddRec then
        begin
          AddXrefRec(DictFieldRec.VarName, iPos1, iPos2);
{          FillChar(LDictionaryRec, SizeOf(LDictionaryRec), #0);
          LDictionaryRec.RecPfix := 'D';
          LDictionaryRec.SubType := 'X';
          LDictionaryRec.DataXRefRec.VarKey := CHR(iPos1) + CHR(iPos2) + DictFieldRec.VarName;
          LDictionaryRec.DataXRefRec.VarName := DictFieldRec.VarName;
          LDictionaryRec.DataXRefRec.VarFileNo := iPos2;
          LDictionaryRec.DataXRefRec.VarExVers := iPos1;
          BTRec.Status := BTAddRecord(btFileVar[DictionaryF], LDictionaryRec
          , SizeOf(LDictionaryRec), 0);
          BTShowError(BTRec.Status, 'BTAddRecord', btFileName[DictionaryF]);}
        end;
      end;{for}
    end;{if}
  end;{for}
end;

function AddXrefRec(sFieldCode : string; iVersion, iFile : integer): boolean;
var
  LDictionaryRec : DataDictRec;
  BTRec : TBTRec;

  function GetVerNo(iNo : integer) : integer;
  begin{GetVerNo}
    Case iNo of
      1..9 : Result := iNo;
      10 : Result := 11;
      11..13 : Result := iNo + 10;
    end;{case}
  end;{GetVerNo}
  
begin
  iVersion := GetVerNo(iVersion);
  FillChar(LDictionaryRec, SizeOf(LDictionaryRec), #0);
  LDictionaryRec.RecPfix := 'D';
  LDictionaryRec.SubType := 'X';
  LDictionaryRec.DataXRefRec.VarKey := CHR(iVersion) + CHR(iFile) + sFieldCode;
  LDictionaryRec.DataXRefRec.VarName := sFieldCode;
  LDictionaryRec.DataXRefRec.VarFileNo := iFile;
  LDictionaryRec.DataXRefRec.VarExVers := iVersion;
  BTRec.Status := BTAddRecord(btFileVar[DictionaryF], LDictionaryRec
  , SizeOf(LDictionaryRec), 0);
  BTShowError(BTRec.Status, 'BTAddRecord', btFileName[DictionaryF]);
  Result := BTRec.Status = 0;
end;

function DeleteXrefRec(sFieldCode : string; iVersion, iFile : integer): boolean;
var
  BTRec : TBTRec;
  LDictionaryRec : DataDictRec;
begin
  BTRec.KeyS := XrefRecordPrefix + CHR(iVersion) + CHR(iFile) + sFieldCode;
  BTRec.Status := BTFindRecord(BT_GetEqual, btFileVar[DictionaryF], LDictionaryRec
  , SizeOf(LDictionaryRec), dxIdxVerFileName, BTRec.KeyS);
  if BTRec.Status = 0 then
  begin
    BTRec.Status := BTDeleteRecord(btFileVar[DictionaryF], LDictionaryRec
    , SizeOf(LDictionaryRec), dxIdxVerFileName);
    BTShowError(BTRec.Status, 'BTDeleteRecord', btFileName[DictionaryF]);
  end;{if}
end;

initialization
  PrevRec.iLastAddedVarNo := 1000;
  PrevRec.iAvailFile := 0;
  PrevRec.iAvailFile2 := 0;
  PrevRec.iAvailVer := 0;

end.
