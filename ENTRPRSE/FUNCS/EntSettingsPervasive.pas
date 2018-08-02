unit EntSettingsPervasive;

interface

uses
  EntSettings, BTUtil, BtConst, BtrvU2, Dialogs, SysUtils;

const
  WindowNoOfSegments = 3;
  ParentNoOfSegments = 4;
  ColumnNoOfSegments = 6;

  WindowNoOfIndexes = 1;
  ParentNoOfIndexes = 1;
  ColumnNoOfIndexes = 1;



type

  TWindowSettingsFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..WindowNoOfSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  TParentSettingsFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..ParentNoOfSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  TColumnSettingsFileDef =
  record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of char;
    KeyBuff   :  array[1..ColumnNoOfSegments] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

procedure DefineWindowSettings;
procedure DefineParentSettings;
procedure DefineColumnSettings;

procedure CreateFiles(const sCompanyPath : string);


var
  WindowSettingsRec : TWindowPositionRec;
  WindowSettingsFile : TWindowSettingsFileDef;

  ParentSettingsRec : TParentSettingsRec;
  ParentSettingsFile : TParentSettingsFileDef;

  ColumnSettingsRec : TColumnSettingsRec;
  ColumnSettingsFile : TColumnSettingsFileDef;


implementation



procedure DefineWindowSettings;
begin

  with WindowSettingsFile do
  begin
    RecLen := Sizeof(WindowSettingsRec);
    PageSize := 2048; //DefPageSize * 2;
    NumIndex := WindowNoOfIndexes;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - ExeName + UserName + WindowName
    // ExeName
    KeyBuff[1].KeyPos := BtKeyPos(@WindowSettingsRec.wpExeName[1], @WindowSettingsRec);
    KeyBuff[1].KeyLen := SizeOf(WindowSettingsRec.wpExeName) - 1;
    KeyBuff[1].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[2].KeyPos := BtKeyPos(@WindowSettingsRec.wpUserName[1], @WindowSettingsRec);
    KeyBuff[2].KeyLen := SizeOf(WindowSettingsRec.wpUserName) - 1;
    KeyBuff[2].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[3].KeyPos := BtKeyPos(@WindowSettingsRec.wpWindowName[1], @WindowSettingsRec);
    KeyBuff[3].KeyLen := SizeOf(WindowSettingsRec.wpWindowName) - 1;
    KeyBuff[3].KeyFlags := Modfy + AltColSeq;

    AltColt:=UpperALT;
  end;

  FillChar(WindowSettingsRec, Sizeof(WindowSettingsRec), 0);
end;

procedure DefineParentSettings;
begin

  with ParentSettingsFile do
  begin
    RecLen := Sizeof(ParentSettingsRec);
    PageSize := 2048; //DefPageSize * 2;
    NumIndex := ParentNoOfIndexes;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - ExeName + UserName + WindowName+Name
    // ExeName
    KeyBuff[1].KeyPos := BtKeyPos(@ParentSettingsRec.psExeName[1], @ParentSettingsRec);
    KeyBuff[1].KeyLen := SizeOf(ParentSettingsRec.psExeName) - 1;
    KeyBuff[1].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[2].KeyPos := BtKeyPos(@ParentSettingsRec.psUserName[1], @ParentSettingsRec);
    KeyBuff[2].KeyLen := SizeOf(ParentSettingsRec.psUserName) - 1;
    KeyBuff[2].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[3].KeyPos := BtKeyPos(@ParentSettingsRec.psWindowName[1], @ParentSettingsRec);
    KeyBuff[3].KeyLen := SizeOf(ParentSettingsRec.psWindowName) - 1;
    KeyBuff[3].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[4].KeyPos := BtKeyPos(@ParentSettingsRec.psName[1], @ParentSettingsRec);
    KeyBuff[4].KeyLen := SizeOf(ParentSettingsRec.psName) - 1;
    KeyBuff[4].KeyFlags := ModFy + AltColSeq;

    AltColt:=UpperALT;
  end;

  FillChar(ParentSettingsRec, Sizeof(ParentSettingsRec), 0);
end;

procedure DefineColumnSettings;
begin

  with ColumnSettingsFile do
  begin
    RecLen := Sizeof(ColumnSettingsRec);
    PageSize := 2048; //DefPageSize * 2;
    NumIndex := ParentNoOfIndexes;
    Variable := B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    FillChar(KeyBuff, SizeOf(KeyBuff), 0);

    //Key 0 - ExeName + UserName + WindowName+ParentName+ColumnNo+'!'
    // ExeName
    KeyBuff[1].KeyPos := BtKeyPos(@ColumnSettingsRec.csExeName[1], @ColumnSettingsRec);
    KeyBuff[1].KeyLen := SizeOf(ColumnSettingsRec.csExeName) - 1;
    KeyBuff[1].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[2].KeyPos := BtKeyPos(@ColumnSettingsRec.csUserName[1], @ColumnSettingsRec);
    KeyBuff[2].KeyLen := SizeOf(ColumnSettingsRec.csUserName) - 1;
    KeyBuff[2].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[3].KeyPos := BtKeyPos(@ColumnSettingsRec.csWindowName[1], @ColumnSettingsRec);
    KeyBuff[3].KeyLen := SizeOf(ColumnSettingsRec.csWindowName) - 1;
    KeyBuff[3].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[4].KeyPos := BtKeyPos(@ColumnSettingsRec.csParentName[1], @ColumnSettingsRec);
    KeyBuff[4].KeyLen := SizeOf(ColumnSettingsRec.csParentName) - 1;
    KeyBuff[4].KeyFlags := ModSeg + AltColSeq;

    KeyBuff[5].KeyPos := BtKeyPos(@ColumnSettingsRec.csColumnNo, @ColumnSettingsRec);
    KeyBuff[5].KeyLen := SizeOf(ColumnSettingsRec.csColumnNo);
    KeyBuff[5].KeyFlags := ModSeg+ExtType;
    KeyBuff[5].ExtTypeVal:=BInteger;

    KeyBuff[6].KeyPos := BtKeyPos(@ColumnSettingsRec.DummyChar, @ColumnSettingsRec);
    KeyBuff[6].KeyLen := 1;
    KeyBuff[6].KeyFlags := ModFy;


    AltColt:=UpperALT;
  end;

  FillChar(ColumnSettingsRec, Sizeof(ColumnSettingsRec), 0);
end;

procedure CreateFiles(const sCompanyPath : string);
var
  FV : TFileVar;
  Res : Integer;
begin
  DefineWindowSettings;
  DefineParentSettings;
  DefineColumnSettings;

  Res := BTMakeFile(FV, sCompanyPath + WindowFileName, WindowSettingsFile, SizeOf(WindowSettingsRec));
  ShowMessage(WindowFileName + ': ' + IntTosTr(Res));
  Res := BTMakeFile(FV, sCompanyPath + ParentFileName, ParentSettingsFile, SizeOf(ParentSettingsRec));
  ShowMessage(ParentFileName + ': ' + IntTosTr(Res));
  Res := BTMakeFile(FV, sCompanyPath + ColumnFileName, ColumnSettingsFile, SizeOf(ColumnSettingsRec));
  ShowMessage(ColumnFileName + ': ' + IntTosTr(Res));
end;



end.
