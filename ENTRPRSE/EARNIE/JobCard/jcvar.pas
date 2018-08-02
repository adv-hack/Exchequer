unit jcvar;

interface

uses
  GlobVar, BtrvU2, Enterprise01_TLB, ComObj, Classes;

const

  MCMF = 1;
  EmpF = 2;

  MCMNumOfKeys = 3;
  MCMNumSegments =4;

  EmpNumOfKeys = 2;
  EmpNumSegments =3;

  MCMFileName = 'JC\MCPay.dat';
  EmpFileName = 'JC\EmpPay.dat';

  ExportString = 'Exchequer Job Card Export';
  ImportString = 'Exchequer Job Card (Import Employees)';

  GroupFileName = 'JC\AcGroups.dat';

  jcName = 'Exchequer Payroll Export ';
  jcVersion = 'v6.5.024';

type
  PMCMRecType = ^MCMRecType;
  MCMRecType = record
    CoCode      : string[6];
    PayID       : string[3];
    CoName      : string[45];
    FileName    : string[30];
    Spare       : Array[1..100] of Char;
  end;

  MCMFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..MCMNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  PEmpRecType = ^EmpRecType;
  EmpRecType = record
    CoCode        : string[6];  //Company Code
    EmpCode       : string[6]; //employee code
    AcGroup       : string[25]; //account group
    EmpName       : string[30]; //employee name
    Spare       : Array[1..100] of Char;
  end;


  EmpFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..EMPNumSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  MCMRec : MCMRecType;
  MCMFile : MCMFileDef;

  EmpRec : EmpRecType;
  EmpFile : EmpFileDef;

  EntDir : string;

  oToolkit : IToolkit;

  GroupList : TStringList;
  FullGroupList : TStringList;
  UseDosKeys : Boolean;
  CurrentCompany : string;

  procedure OpenTheToolkit(const CoCode : string);
  procedure CloseTheToolkit;
  procedure FullGroupListToGroupList;
  procedure GroupListToFullGroupList;

  function JobCardVersion : string;

implementation

uses
  FileUtil, SysUtils, ExchequerRelease;

const
  BuildNo = '024';

function JobCardVersion : string;
begin
  Result := 'Version: ' + ExchequerModuleVersion(emJobCard, BuildNo);
end;

procedure OpenTheToolkit(const CoCode : string);
var
  Res, i : Integer;
  s, GroupFile   : string;
begin
  with oToolkit do
  begin
    for i := 1 to Company.cmCount do
      if Trim(Company.cmCompany[i].coCode) = CoCode then
      begin
        s := Trim(Company.cmCompany[i].coPath);
        Break;
      end;
    Configuration.DataDirectory := s;
    Res := OpenToolkit;
  end;

  if Res <> 0 then
    raise Exception.Create('Unable to open COM Toolkit. Error ' + IntToStr(Res) + #10#10 +
                           QuotedStr(oToolkit.LastErrorString))
  else
  begin //Load group file
    CurrentCompany := CoCode;
    FullGroupListToGroupList;
  end;

end;

procedure CloseTheToolkit;
begin
  GroupListToFullGroupList;
  oToolkit.CloseToolkit;
end;

procedure FullGroupListToGroupList;
var
  i, j  : integer;
  s : string;
begin
  i := 0;
  while i < FullGroupList.Count do
  begin
      s := FullGroupList[i];
      j := Pos(CurrentCompany, s);
      if j = 1 then
      begin
        GroupList.Add(Copy(s, Pos(',', s) + 1, Length(s)));
        FullGroupList.Delete(i);
      end
      else
        inc(i);
  end;
end;

procedure GroupListToFullGroupList;
var
  i : integer;
begin
  for i := 0 to GroupList.Count - 1 do
    FullGroupList.Add(CurrentCompany + ',' + GroupList[i]);
  GroupList.Clear;
end;


procedure DefineMCM;
const
  Idx = MCMF;
begin
  FileSpecLen[Idx] := SizeOf(MCMFile);
  FillChar(MCMFile, FileSpecLen[Idx],0);

  with MCMFile do
  begin
    RecLen := Sizeof(MCMRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := MCMNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    // CompanyCode = string[6]
    KeyBuff[1].KeyPos := BtKeyPos(@MCMRec.CoCode[1], @MCMRec);
    KeyBuff[1].KeyLen := SizeOf(MCMRec.CoCode) - 1;
    KeyBuff[1].KeyFlags := AltColSeq + DupMod;
    //PayRollID = String[3]
    KeyBuff[2].KeyPos := BtKeyPos(@MCMRec.PayID[1], @MCMRec);
    KeyBuff[2].KeyLen := SizeOf(MCMRec.PayID) - 1;
    KeyBuff[2].KeyFlags := AltColSeq + DupMod;

    // CompanyCode = string[6]
    KeyBuff[3].KeyPos := BtKeyPos(@MCMRec.CoCode[1], @MCMRec);
    KeyBuff[3].KeyLen := SizeOf(MCMRec.CoCode) - 1;
    KeyBuff[3].KeyFlags := AltColSeq + DupModSeg;
    //PayRollID = String[3]
    KeyBuff[4].KeyPos := BtKeyPos(@MCMRec.PayID[1], @MCMRec);
    KeyBuff[4].KeyLen := SizeOf(MCMRec.PayID) - 1;
    KeyBuff[4].KeyFlags := AltColSeq + DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(MCMRec);
  FillChar(MCMRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @MCMRec;
  FileSpecOfS[Idx] := @MCMFile;
  FileNames[Idx] := EntDir + MCMFilename;
end;

procedure DefineEmp;
const
  Idx = EmpF;
begin
  FileSpecLen[Idx] := SizeOf(EmpFile);
  FillChar(EmpFile, FileSpecLen[Idx],0);

  with EmpFile do
  begin
    RecLen := Sizeof(EmpRec);
    PageSize := 1024; //DefPageSize;
    NumIndex := EmpNumOfKeys;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);
    //CoCode = string[6];
    KeyBuff[1].KeyPos := BtKeyPos(@EmpRec.CoCode[1], @EmpRec);
    KeyBuff[1].KeyLen := SizeOf(EmpRec.CoCode) - 1;
    KeyBuff[1].KeyFlags := AltColSeq + DupModSeg;
    // EmpCode = string[6]
    KeyBuff[2].KeyPos := BtKeyPos(@EmpRec.EmpCode[1], @EmpRec);
    KeyBuff[2].KeyLen := SizeOf(EmpRec.EmpCode) - 1;
    KeyBuff[2].KeyFlags := AltColSeq + DupMod;
    //AcGroup = String[25]
    KeyBuff[3].KeyPos := BtKeyPos(@EmpRec.AcGroup[1], @EmpRec);
    KeyBuff[3].KeyLen := SizeOf(EmpRec.AcGroup) - 1;
    KeyBuff[3].KeyFlags := AltColSeq + DupMod;

    AltColt:=UpperALT;
  end;

  FileRecLen[Idx] := Sizeof(EmpRec);
  FillChar(EmpRec,FileRecLen[Idx],0);
  RecPtr[Idx] := @EmpRec;
  FileSpecOfS[Idx] := @EmpFile;
  FileNames[Idx] := EntDir + EmpFilename;
end;

Initialization

  EntDir := GetEnterpriseDirectory;

  DefineMCM;
  DefineEmp;


end.
