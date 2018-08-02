unit DDFuncs;

interface

Uses
  Classes,
  BtrvU2,  GlobVar, VarRec2U,
  RWOpenF;

{$ALIGN 1}

function GetDDField (const ShortCode : ShortString;
                     var   DataRec   : DataDictRec) : Boolean;

{ TODO : Remove: Not used in new VRW }
procedure LoadFieldList(const  TheList  : TStringList;
                        const FileNo   : Byte);

{ TODO : Remove: Not used in new VRW }
procedure FreeFieldList(Var TheList : TStringList);

Type
  TDBFieldObj = class(TObject)
    sFieldDesc : string;
    DBFieldParams : DataVarType;
  end;

implementation

uses
  SysUtils, Dialogs,
  EtStrU,
  GlobalTypes, EntLicence;

const
 NULL_CHAR = #0;
 TAB_CHAR = #9;

function WantPrefix(const FieldName : ShortString; var SkipPrefix : ShortString) : Boolean;
// ssSkipPrefix is set if the function returns TRUE
const
  NUM_PREFIXES = 5;
  aFilteredPrefixes : array[1..NUM_PREFIXES] of ShortString =
    ('CH','TC','CU','EML','FAX');
var
  siIdx : SmallInt;
begin
  Result := TRUE; SkipPrefix := '';

  // there are also the C0 to Cn prefixed fields that are a 'special' case
  if (UpperCase(FieldName[1]) = 'C') then
    if (FieldName[2] in ['0'..'9']) then
    begin
      Result := FALSE;
      SkipPrefix := Copy(FieldName, 1, 2);
    end;

  // don't want any of the field names that have a prefix in the array above
  for siIdx := 1 to NUM_PREFIXES do
    if (Pos(aFilteredPrefixes[siIdx],FieldName) = 1) then
    begin
      Result := FALSE;
      SkipPrefix := aFilteredPrefixes[siIdx];
    end;

end;

// Build key with the unwanted prefix and a series of 255 chars.
// Then do a get greater than equal to... which will move us to the end of that particular block of field names.
procedure SkipToEndOfBlock(const ssPrefix : ShortString);
const
  FileNum = DictF;
  KeyPath = DIK;
var
  KeyS : ShortString;
begin
  KeyS := 'DV' + ssPrefix;
  while (Length(KeyS) < 10) do
    KeyS := KeyS + chr(255);

  Find_Rec(B_GetGEq, F[FileNum], FileNum, RecPtr[FileNum]^, Keypath, KeyS);
end;

function GetDDField (const ShortCode : ShortString;
                     var   DataRec   : DataDictRec) : Boolean;
const
  FNum    = DictF;
  KeyPath = DIK;
var
  KeyS : ShortString;
  siStatus : Smallint;
begin
  KeyS := 'DV' + LJVAR(ShortCode,8);

  siStatus := Find_Rec (B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);
  if (siStatus = 0) then
    DataRec := DictRec^
  else
    FillChar (DataRec, SizeOf(DataRec), NULL_CHAR);

  Result := (siStatus = 0);
end;

//-------------------------------------------------------------------------

procedure FreeFieldList(Var TheList : TStringList);
Var
  slFieldList : TStringList;
  iField      : SmallInt;
Begin // FreeFieldList
  // Run through the TableList extracting the StringLists and destroying
  // the DBField objects within those lists
  While (TheList.Count > 0) Do
  Begin
    slFieldList := TStringList(TheList.Objects[0]);
    Try
      For iField := 0 To (slFieldList.Count - 1) Do
        TDBFieldObj(slFieldList.Objects[iField]).Free;
    Finally
      FreeAndNIL(slFieldList);
    End; // Try..Finally

    TheList.Delete(0);
  End; // While (TheList.Count > 0)

  FreeAndNIL(TheList);
End; // FreeFieldList

//-------------------------------------------------------------------------

procedure LoadFieldList(const TheList  : TStringList;
                        const FileNo   : Byte);
const
  FNum    = DictF;
  KeyPath = DIK;
var
  rDataRec : DataDictRec;
  KeyS    : ShortString;
  byRWVersionNo : Byte;
  siStatus : SmallInt;
  ssCurrentTable : ShortString;
  slFieldList : TStringList;
  ssSkipPrefix : ShortString;
  oDBField : TDBFieldObj;
begin
  slFieldList := nil;

  if EnterpriseLicence.elIsMultiCcy then
  begin
    byRWVersionNo := 7;
    if (EnterpriseLicence.elModules[ModJobCost] <> mrNone) then
      byRWVersionNo := byRWVersionNo + 2;
  end
  else
  begin
    byRWVersionNo := 3;
    if (EnterpriseLicence.elModules[ModJobCost] <> mrNone) then
      byRWVersionNo := byRWVersionNo + 1;
  end;

  byRWVersionNo := byRWVersionNo + Byte(EnterpriseLicence.elModuleVersion);

  while (TheList.Count > 0) do
    TheList.Delete(0);               // <<<< Memory Leak - need to destroy Object instance
  TheList.Clear;

  { build index }
  FillChar (KeyS, SizeOf(KeyS), NULL_CHAR);
  KeyS := 'DX'#1#1;
  KeyS[3] := Chr(byRWVersionNo);
  KeyS[4] := Chr(FileNo);

  ssCurrentTable := '';

  { Get record }
  siStatus := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  while (siStatus = 0) and
        (DictRec^.SubType = 'X') and
        (DictRec^.DataXRefRec.VarExVers = byRWVersionNo) and
        (DictRec^.DataXRefRec.VarFileNo = FileNo) do
  begin
    // Boolean function to filter out the unwanted prefiexes.
    if (WantPrefix(DictRec^.DataXRefRec.VarName,ssSkipPrefix)) then
    begin
      if GetDDField(DictRec^.DataXRefRec.VarName, rDataRec) then
      begin
        if (ssCurrentTable <> Copy(DictRec^.DataXRefRec.VarKey,1,TBL_CODE_LGTH)) then
        begin
          // add fieldlist to TheList if this isn't the first time thru, in which case ssCurrentTable will be blank
          if (ssCurrentTable <> '') then
            TheList.AddObject(ssCurrentTable, slFieldList);
          // the table has change so update current table
          ssCurrentTable := Copy(DictRec^.DataXRefRec.VarKey,1,TBL_CODE_LGTH);

          // make a new 'sub' list and add the data
          slFieldList := TStringList.Create;
          oDBField := TDBFieldObj.Create;
          with oDBField do
          begin
            sFieldDesc := rDataRec.DataVarRec.VarName + TAB_CHAR + rDataRec.DataVarRec.VarDesc;
            move(rDataRec.DataVarRec, DBFieldParams, SizeOf(DataVarType));
          end;
          slFieldList.AddObject(rDataRec.DataVarRec.VarName, oDBField);
        end
        else
        begin
          // add the data to the current 'sub' list
          oDBField := TDBFieldObj.Create;
          with oDBField do
          begin
            sFieldDesc := rDataRec.DataVarRec.VarName + TAB_CHAR + rDataRec.DataVarRec.VarDesc;
            move(rDataRec.DataVarRec, DBFieldParams, SizeOf(DataVarType));
          end;
          slFieldList.AddObject(rDataRec.DataVarRec.VarName, oDBField);
        end;
      end
      else
      begin
        slFieldList.Add(DictRec^.DataXRefRec.VarName + ': Failed');
      end; // if GetDDField() then...
    end
    else
    begin
      SkipToEndOfBlock(ssSkipPrefix);
    end; // if (WantPrefix()) then...

    { Get next }
    siStatus := Find_Rec (B_GetGretr, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  end; { while }

  if (assigned(slFieldList)) then
    if (slFieldList.Count > 0) then
      if (ssCurrentTable <> Copy(DictRec^.DataXRefRec.VarKey,1,TBL_CODE_LGTH)) then
        // add fieldlist to TheList is this isn't the first time thru, in which case ssCurrentTable will be blank
        if (ssCurrentTable <> '') then
          TheList.AddObject(ssCurrentTable, slFieldList);

end;

end.

