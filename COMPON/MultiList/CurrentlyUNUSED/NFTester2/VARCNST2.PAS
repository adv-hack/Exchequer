//
// Windows Card System VARCNST2
//

procedure DefineCardCustF;
const
  Idx = CustF;
begin
  with CustFile do begin
    FileSpecLen[Idx]:=Sizeof(CustFile);
    Fillchar(CustFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(Cust);
    PageSize:=DefPageSize;
    NumIndex:=cNofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { 00 - Code  (CustCodeK) }
    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=10;
    KeyBuff[1].KeyFlags:=Modfy+AltColSeq;

    { 01 - Surname + Firstname (CustCompK) }
    KeyBuff[2].KeyPos:=13;
    KeyBuff[2].KeyLen:=20;
    KeyBuff[2].KeyFlags:=DupModSeg+AltColSeq;
    KeyBuff[3].KeyPos:=44;
    KeyBuff[3].KeyLen:=05;
    KeyBuff[3].KeyFlags:=DupMod+AltColSeq;

    { 02 - ClubNo  (CustClubK) }
    KeyBuff[4].KeyPos:=70;
    KeyBuff[4].KeyLen:=10;
    KeyBuff[4].KeyFlags:=DupMod+AltColSeq;

    { 03 - CustCode + UseNext (CustAvalK) }
    KeyBuff[5].KeyPos:=02;
    KeyBuff[5].KeyLen:=10;
    KeyBuff[5].KeyFlags:=DupModSeg+Mank+AltColSeq;
    KeyBuff[6].KeyPos:=64;
    KeyBuff[6].KeyLen:=01;
    KeyBuff[6].KeyFlags:=DupMod+Mank+ExtType;
    KeyBuff[6].ExtTypeVal:=BBoolean;

    { 04 - CustCode + ChangeFlg (CustEditK) }
    KeyBuff[7].KeyPos:=02;
    KeyBuff[7].KeyLen:=10;
    KeyBuff[7].KeyFlags:=DupModSeg+Mank+AltColSeq;
    KeyBuff[8].KeyPos:=305;
    KeyBuff[8].KeyLen:=01;
    KeyBuff[8].KeyFlags:=DupMod+Mank;

    { 05 - MMTyp + Surname (CustMTypK) }
    KeyBuff[9].KeyPos:=306;
    KeyBuff[9].KeyLen:=04;
    KeyBuff[9].KeyFlags:=DupModSeg+Mank+ExtType;
    KeyBuff[9].ExtTypeVal:=BInteger;
    KeyBuff[10].KeyPos:=13;
    KeyBuff[10].KeyLen:=20;
    KeyBuff[10].KeyFlags:=DupMod+Mank+AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  End;{with}
  FileRecLen[Idx]:=Sizeof(Cust);
  Fillchar(Cust,FileRecLen[Idx],0);
  RecPtr[Idx]:=@Cust;
  FileSpecOfs[Idx]:=@CustFile;
  FileNames[Idx] := Path1 + 'CUST.DAT';
End;


procedure DefineInv;
const
  Idx = InvF;
begin
  with InvFile do begin
    FileSpecLen[Idx]:=Sizeof(InvFile);
    Fillchar(InvFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(Inv);
    PageSize:=DefPageSize;
    NumIndex:=INofKeys;
    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { Key Definitions }

    { 00 - CustCode + TransDate (InvCustK) }
    KeyBuff[1].KeyPos:=02;
    KeyBuff[1].KeyLen:=06;
    KeyBuff[1].KeyFlags:=DupModSeg+AltColSeq;
    KeyBuff[2].KeyPos:=28;
    KeyBuff[2].KeyLen:=08;      {CHANGED 06 TO 08}
    KeyBuff[2].KeyFlags:=DupMod+AltColSeq;

    { 01  -  Our Ref (InvOurRefK)  }
    KeyBuff[3].KeyPos:=13;
    KeyBuff[3].KeyLen:=10;
    KeyBuff[3].KeyFlags:=Modfy+AltColSeq;

    { 02 - FolioNo  (InvFolioK)  }
    KeyBuff[4].KeyPos:=23;
    KeyBuff[4].KeyLen:=04;
    KeyBuff[4].KeyFlags:=Modfy+ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    { 03 - TransDate (InvInvDteK) }
    KeyBuff[5].KeyPos:=28;
    KeyBuff[5].KeyLen:=08;      {CHANGED 06 TO 08}
    KeyBuff[5].KeyFlags:=DupMod+AltColSeq+Mank;

    { 04 - RunNo + CustCode (InvRunNoK) }
    KeyBuff[6].KeyPos:=45; {CHANGED 41 TO 45}
    KeyBuff[6].KeyLen:=04;
    KeyBuff[6].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[6].ExtTypeVal:=BInteger;
    KeyBuff[7].KeyPos:=02;
    KeyBuff[7].KeyLen:=06;
    KeyBuff[7].KeyFlags:=DupMod+AltcolSeq;

    { 05 - OurRef Doc[3] + CustCode + TransDate (InvCustDK)  }
    KeyBuff[8].KeyPos:=13;
    KeyBuff[8].KeyLen:=03;
    KeyBuff[8].KeyFlags:=DupModSeg+AltColSeq;
    KeyBuff[9].KeyPos:=02;
    KeyBuff[9].KeyLen:=10;
    KeyBuff[9].KeyFlags:=DupModSeg+AltColSeq;
    KeyBuff[10].KeyPos:=28;
    KeyBuff[10].KeyLen:=08;     {CHANGED 06 TO 08}
    KeyBuff[10].KeyFlags:=DupMod+AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With}
  FileRecLen[Idx]:=Sizeof(Inv);
  Fillchar(Inv,FileRecLen[Idx],0);
  RecPtr[Idx] := @Inv;
  FileSpecOfs[Idx]:=@InvFile;
  FileNames[Idx]:=Path2+DocName;
end;

{****************************************************************}
{* Btrieve Sales Details File Definition                        *}
{****************************************************************}
procedure DefineSalesDet;
begin
  with SalesDetFile, SalesDetRec do begin
    FileSpecLen [SalesDetF] := Sizeof(SalesDetFile);
    Fillchar(SalesDetFile, FileSpecLen[SalesDetF], 0);
    RecLen   := Sizeof(SalesDetRec);
    PageSize := DefPageSize2;
    NumIndex := sdNofKeys;

    Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Index 0: sdFolioNum + sdOrder + sdCard }
    KeyBuff[1].KeyPos     := 8;
    KeyBuff[1].KeyLen     := 4;
    KeyBuff[1].KeyFlags   := ModSeg + ExtType;
    KeyBuff[1].ExtTypeVal := BInteger;
    KeyBuff[2].KeyPos     := 71;
    KeyBuff[2].KeyLen     := 2;
    KeyBuff[2].KeyFlags   := ModSeg;
    KeyBuff[2].ExtTypeVal := BInteger;
    KeyBuff[3].KeyPos     := 2;
    KeyBuff[3].KeyLen     := 6;
    KeyBuff[3].KeyFlags   := Modfy + AltColSeq;

    { Index 1: sdCard + sdDate }
    KeyBuff[4].KeyPos     := 2;
    KeyBuff[4].KeyLen     := 6;
    KeyBuff[4].KeyFlags   := DupModSeg + AltColSeq;
    KeyBuff[5].KeyPos     := 17;
    KeyBuff[5].KeyLen     := 08;     {CHANGED 06 TO 08}
    KeyBuff[5].KeyFlags   := DupMod + AltColSeq;

    { Index 2: sdType + sdNumber }
    KeyBuff[6].KeyPos     := 25;
    KeyBuff[6].KeyLen     := 1;
    KeyBuff[6].KeyFlags   := DupModSeg;
    KeyBuff[7].KeyPos     := 26;
    KeyBuff[7].KeyLen     := 4;
    KeyBuff[7].KeyFlags   := DupMod + ExtType;
    KeyBuff[7].ExtTypeVal := BInteger;

    { Index 3: sdRunNo + sdCard + sdFolioNum } {NF: Ill use this for the new PLU Sales report mods.}
    KeyBuff[8].KeyPos     := 12;
    KeyBuff[8].KeyLen     := 4;
    KeyBuff[8].KeyFlags   := DupModSeg + ExtType;
    KeyBuff[8].ExtTypeVal := BInteger;
    KeyBuff[9].KeyPos     := 2;
    KeyBuff[9].KeyLen     := 6;
    KeyBuff[9].KeyFlags   := DupModSeg;
    KeyBuff[10].KeyPos     := 8;
    KeyBuff[10].KeyLen     := 4;
    KeyBuff[10].KeyFlags   := DupMod + ExtType;
    KeyBuff[10].ExtTypeVal := BInteger;

    { Index 4: sdCard + sdType + sdNumber + sdDate }
    KeyBuff[11].KeyPos     := 2;
    KeyBuff[11].KeyLen     := 6;
    KeyBuff[11].KeyFlags   := DupModSeg;
    KeyBuff[12].KeyPos     := 25;
    KeyBuff[12].KeyLen     := 1;
    KeyBuff[12].KeyFlags   := DupModSeg + AltColSeq;
    KeyBuff[13].KeyPos     := 26;
    KeyBuff[13].KeyLen     := 4;
    KeyBuff[13].KeyFlags   := DupModSeg + ExtType;
    KeyBuff[13].ExtTypeVal := BInteger;
    KeyBuff[14].KeyPos     := 17;
    KeyBuff[14].KeyLen     := 08;     {CHANGED 06 TO 08}
    KeyBuff[14].KeyFlags   := DupMod + AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end;{with}

  FileRecLen [SalesDetF] := Sizeof (SalesDetRec);
  Fillchar (SalesDetRec, FileRecLen [SalesDetF], 0);
  RecPtr[SalesDetF] := @SalesDetRec;
  FileSpecOfs[SalesDetF] := @SalesDetFile;

  FileNames[SalesDetF] := Path2 + SalesDetName;{ Set path and name of file }
end;

{********************* DEFINE SYSTEM RECORD ***********************}

procedure DefineSys;
const
  Idx = SysF;
begin
  with SysFile do begin
    FileSpecLen[Idx]:=Sizeof(SysFile);
    Fillchar(SysFile,FileSpecLen[Idx],0);
    RecLen:=Sizeof(Syss);
    PageSize:=DefPageSize2;
    NumIndex:=SNofKeys;
    Variable:=1;
    VariFile[Idx]:=(Variable=1);
  end;{With}
  FileRecLen[Idx]:=Sizeof(Syss);
  Fillchar(Syss,FileRecLen[Idx],0);
  RecPtr[Idx]:=@Syss;
  FileSpecOfs[Idx]:=@SysFile;
  FileNames[Idx]:=PathSys;
end;

procedure BTDelay (dt : Word);
var
  ThTimeS, thTimeN : TDateTime;
  thGap            : Double;
begin
  thTimeS:=Time;
  thGap:=dt/1e8;

  repeat
    thTimeN:=Time-ThTimeS;
  until (thTimeN>thgap);
end;

function NonFatalStatus (StatNo  :  Integer)  :  Boolean;
begin
  NonFatalStatus := (StatNo = 11) or (StatNo = 20) or (StatNo = 35) or (StatNo = 88) or
                    (StatNo = 81) or (StatNo = 85) or (StatNo = 86) or (StatNo = 133);
end;

procedure Open_System(Start, Fin  :  Integer);
const
  NoAttempts     =  100;   {* No of retries before giving up *}
var
  Choice,NoTrys,
  SetAccel     :  Integer;
  mbRet        :  Word;
begin
   { =========== Set Accelrated mode ============ }
   SetAccel:=-1*Ord(AccelMode);

   { =========== Open Files ========== }
{$I-}

    Choice:=Start; Ch:=ResetKey;

    if (Check4BtrvOK) then
    while (Choice<=Fin) and (Ch<>#27) do begin
      NoTrys:=0;
      repeat
        Elded:=BOff;
        Status:=Open_File(F[Choice],SetDrive+FileNames[Choice],SetAccel);
        if (Status <>0) and (NoTrys>NoAttempts) then begin
          if (Debug) then Status_Means(Status);
          Elded:=BOff;

          mbRet:=MessageDlg('Error in File:'+FileNames[Choice]+' Type '+InttoStr(Status),mtInformation,[mbOk],0);


          if (not NonFatalStatus(Status)) then begin
            mbRet:=MessageDlg('Create new file?',mtConfirmation,mbOkCancel,0);
          end;

          {$IFNDEF WIN32}
          If (mbRet=1) and (Not NonFatalStatus(Status))  then
          {$ELSE}
          If (mbRet=IdOk) and (Not NonFatalStatus(Status)) then
          {$ENDIF}
          Begin
            Status:=Make_File(F[Choice],SetDrive+FileNames[Choice],FileSpecOfs[Choice]^,FileSpecLen[Choice]);

            If (Debug) then Status_Means(Status);
          end
          else
          Halt;
        end
        else
          If (Status=0) then
            Elded:=BOn
          else
            Inc(NoTrys);

      until (Elded) or (Ch=#27);
      Inc(Choice);
    end; {while..}

    if (Status<>0) then begin
      MessageDlg('Unable to start Btrieve!'+#13+
                        'Error : '+InttoStr(Status),mtInformation,[mbOk],0);
      Halt;
    end;{if}
    Elded:=BOff;
end;

{ Close All Open Files }
procedure Close_Files(ByFile  :  Boolean);
var
  Choice  :  Byte;
  FSpec   : FileSpec;
begin
  {$I-}
    if Debug or ByFile or ResetBtOnExit then
      begin
        for Choice:=1 to TotFiles do begin
          {* Check file is open b4 closing it *}
          Status:=GetFileSpec(F[Choice],Choice,FSpec);

          if (StatusOk) then Status:=Close_File(F[Choice])
          else Status:=0;
        end;{for}
        Status:=Reset_B;
      end
    else Status:=Stop_B;

    if Debug then Status_Means(Status);
  {$I+}
end;

{****************************************************************}
{*                                                              *}
{* Btrieve Group File Definition                               *}
{*                                                              *}
{****************************************************************}
Procedure DefineGroup;
Const
  Idx = GroupF;
Begin { DefineGroup }
  With GroupFile, GroupRec Do Begin
    FileSpecLen [Idx] := Sizeof(GroupFile);
    Fillchar(GroupFile, FileSpecLen[Idx], 0);
    RecLen   := Sizeof(GroupRec);
    PageSize := DefPageSize2;
    NumIndex := GrNofKeys;
    Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Index 0: grArrayNo }
    With KeyBuff [1] Do Begin
      KeyPos     := 1;
      KeyLen     := 4;
      KeyFlags   := Modfy + ExtType;
      ExtTypeVal := BInteger;
    End; { With }

    { Index 1: grNumber }
    With KeyBuff [2] Do Begin
      KeyPos     := 18;
      KeyLen     := 4;
      KeyFlags   := Modfy + ExtType;
      ExtTypeVal := BInteger;
    End; { With }

    { Index 2: grName }
    With KeyBuff [3] Do Begin
      KeyPos     := 6;
      KeyLen     := 12;
      KeyFlags   := DupMod + AltColSeq;
    End; { With }

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  End; { With }

  FileRecLen[Idx]:=Sizeof(GroupRec);
  Fillchar(GroupRec,FileRecLen[Idx],0);
  RecPtr[Idx]:=@GroupRec;
  FileSpecOfs[Idx]:=@GroupFile;

  { Set path and name of file }
  FileNames[Idx] := Path5 + GroupName;
End;  { DefineGroup }




{****************************************************************}
{*                                                              *}
{* Btrieve Saleable Items File Definition                       *}
{*                                                              *}
{****************************************************************}
Procedure DefineItems;
Const
  Idx = ItemF;
Begin { DefineItems }
  With ItemFile, ItemRec Do Begin
    FileSpecLen [Idx] := Sizeof(ItemFile);
    Fillchar(ItemFile, FileSpecLen[Idx], 0);
    RecLen   := Sizeof(ItemRec);
    PageSize := DefPageSize2;
    NumIndex := siNofKeys;
    Variable := 0;{B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Index 0: siType + siNumber }
    With KeyBuff [1] Do Begin
      KeyPos     := 1;
      KeyLen     := 1;
      KeyFlags   := ModSeg + AltColSeq;
    End; { With }
    With KeyBuff [2] Do Begin
      KeyPos     := 2;
      KeyLen     := 4;
      KeyFlags   := Modfy + ExtType;
      ExtTypeVal := BInteger;
    End; { With }

    { Index 1: siGroup + siType + siNumber }
    With KeyBuff [3] Do Begin
      KeyPos     := 6;
      KeyLen     := 4;
      KeyFlags   := ModSeg + ExtType;
      ExtTypeVal := BInteger;
    End; { With }
    With KeyBuff [4] Do Begin
      KeyPos     := 1;
      KeyLen     := 1;
      KeyFlags   := ModSeg + AltColSeq;
    End; { With }
    With KeyBuff [5] Do Begin
      KeyPos     := 2;
      KeyLen     := 4;
      KeyFlags   := Modfy + ExtType;
      ExtTypeVal := BInteger;
    End; { With }

    { Index 2: siName }
    With KeyBuff [6] Do Begin
      KeyPos     := 11;
      KeyLen     := 16;
      KeyFlags   := DupMod + AltColSeq;
    End; { With }

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  End; { With }

  FileRecLen[Idx]:=Sizeof(ItemRec);
  Fillchar(ItemRec,FileRecLen[Idx],0);
  RecPtr[Idx]:=@ItemRec;
  FileSpecOfs[Idx]:=@ItemFile;

  { Set path and name of file }
  FileNames[Idx] := Path5 + ItemName;
End;  { DefineItems }



{****************************************************************}
{*                                                              *}
{* Btrieve Till Sales Definition                                *}
{*                                                              *}
{****************************************************************}
Procedure DefineTillSales;
Const
  Idx = TillSalesF;
Begin { DefineTillSales }
  With TillSalesFile, TillSales Do Begin
    FileSpecLen [Idx] := Sizeof(TillSalesFile);
    Fillchar(TillSalesFile, FileSpecLen[Idx], 0);
    RecLen   := Sizeof(TillSalesRec);
    PageSize := DefPageSize2;
    NumIndex := tsNofKeys;
    Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

    { Index 0: tsType + tsIndex1}
    With KeyBuff [1] Do Begin
      KeyPos     := BtKeyPos(@TillSales.tsType, @TillSales);
      KeyLen     := sizeof(TillSales.tsType);
      KeyFlags   := DupModSeg;
    End; { With }
    With KeyBuff [2] Do Begin
      KeyPos     := BtKeyPos(@TillSales.tsIndex1[1], @TillSales);
      KeyLen     := sizeof(TillSales.tsIndex1) - 1;
      KeyFlags   := DupMod;
    End; { With }

    { Index 1: tsType + tpIndex2 }
    With KeyBuff [3] Do Begin
      KeyPos     := BtKeyPos(@TillSales.tsType, @TillSales);
      KeyLen     := sizeof(TillSales.tsType);
      KeyFlags   := DupModSeg;
    End; { With }
    With KeyBuff [4] Do Begin
      KeyPos     := BtKeyPos(@TillSales.tsPLU.tpIndex2[1], @TillSales);
      KeyLen     := sizeof(TillSales.tsPLU.tpIndex2) - 1;
      KeyFlags   := DupMod;
    End; { With }

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  End; { With }

  FileRecLen[Idx]:=Sizeof(TillSales);
  Fillchar(TillSales,FileRecLen[Idx],0);
  RecPtr[Idx]:=@TillSales;
  FileSpecOfs[Idx]:=@TillSalesFile;

  { Set path and name of file }
  FileNames[Idx] := Path2 + TillSalesName;
End;  { DefineTillSales }

