
procedure DefineFaxFile;
const
  Idx = FaxF;
begin
  FileSpecLen[Idx]:=Sizeof(FaxFile);
  FillChar(FaxFile,FileSpecLen[Idx],0);

  with FaxFile do
  begin
    RecLen:=Sizeof(FaxRec^);
    PageSize:=DefPageSize;
    NumIndex:=4;

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    // Index 0
    KeyBuff[1].KeyPos := 1;
    KeyBuff[1].KeyLen := 1;
    KeyBuff[1].KeyFlags := Modfy+Dup;

    // Index 1 = Document name
    KeyBuff[2].KeyPos := 1;
    KeyBuff[2].KeyLen := 1;
    KeyBuff[2].KeyFlags := ModSeg+Dup;
    KeyBuff[3].KeyPos := 3;
    KeyBuff[3].KeyLen := 80;
    KeyBuff[3].KeyFlags := Modfy+Dup;

    // Index 2 = APF file name
    KeyBuff[4].KeyPos := 1;
    KeyBuff[4].KeyLen := 1;
    KeyBuff[4].KeyFlags := ModSeg+Mank;
    //KeyBuff[4].NullValue := 0;
    KeyBuff[5].KeyPos := 84;
    KeyBuff[5].KeyLen := 12;
    KeyBuff[5].KeyFlags := Modfy+Mank;
    //KeyBuff[5].NullValue := 0;

    // Index 3 = User Name
    KeyBuff[6].KeyPos := 1;
    KeyBuff[6].KeyLen := 1;
    KeyBuff[6].KeyFlags := ModSeg+Mank+Dup;
    //KeyBuff[6].NullValue := 0;
    KeyBuff[7].KeyPos := 97;
    KeyBuff[7].KeyLen := 20;
    KeyBuff[7].KeyFlags := Modfy+Mank+Dup+AltColSeq;
    //KeyBuff[7].NullValue := 0;
    AltColt := UpperAlt;
  end;

  FileRecLen[Idx]:=Sizeof(FaxRec^);

  Fillchar(FaxRec^,FileRecLen[Idx],0);

  RecPtr[Idx]:=@FaxRec^;

  FileSpecOfs[Idx]:=@FaxFile;

  FileNames[Idx]:=FaxName;
end;

