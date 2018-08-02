{


Note:
~~~~~


01.01.89
--------
Key Posn calculation.

First byte of any Turbo String contains single byte length.  To avoid this
being included as part of the search use the following formula, note also
that all records start @ posn 2.

Field Posn= (Prev Posn + (Length of  Prev Field) + 1).


18.01.89
--------
If A key is to be made up of actual fields, as opposed to a dedicated "key"
field, Ensure it is always padded out to its full length, as all Btrieve keys
are not checked for length byte, and any changes which result in a "key" field
being smaller will cause a 4 can't find error as the previous value will not be
entirely overwritten.


09.03.89
--------
Whenever blanking an indexed field, never use the :='' directive, as this only
resets then length byte - ingnored by Btrieve - use the procedure
Tools.Blank(Var,SO(Var)) which is an untyped procedure to completely erase ANY given
variable.

}

{ ======= setup All File Characteristics ======== }

Procedure DefineCust;

Const
  Idx = CustF;

Begin
  With CustFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(CustFile);                    { <<<<<<<<******** Change }
    Fillchar(CustFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Cust);                                  { <<<<<<<<******** Change }

    PageSize:=DefPageSize7;

    NumIndex:=cNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}



    { 00 - Code  (CustCodeK) }

    { Key Definitons }                                       { <<<<<<<<******** Change }
    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=10;
    KeyBuff[1].KeyFlags:=Modfy+AltColSeq;


    { 01 - Company (CustCompK) }

    KeyBuff[2].KeyPos:=14;
    KeyBuff[2].KeyLen:=45;
    KeyBuff[2].KeyFlags:=DupMod+AltColSeq;


    { 02 - CustSupp+VATReg+Code (CustVATK) }

    KeyBuff[3].KeyPos:=BtKeyPos(@Cust.CustSupp,@Cust);
    KeyBuff[3].KeyLen:=01;
    KeyBuff[3].KeyFlags:=ModSeg+AltColSeq;

    KeyBuff[4].KeyPos:=BtKeyPos(@Cust.VATRegNo,@Cust)+1;
    KeyBuff[4].KeyLen:=05;
    KeyBuff[4].KeyFlags:=ModSeg+AltColSeq;

    KeyBuff[5].KeyPos:=BtKeyPos(@Cust.CustCode,@Cust)+1;
    KeyBuff[5].KeyLen:=10;
    KeyBuff[5].KeyFlags:=Modfy+AltColSeq;


    { 03 - Phone No. (CustTelK) }

    KeyBuff[6].KeyPos:=BtKeyPos(@Cust.Phone,@Cust)+1;
    KeyBuff[6].KeyLen:=30;
    KeyBuff[6].KeyFlags:=DupMod+AltColSeq;

    { 04 - Cust Alt Code. (CustAltK) }

    KeyBuff[7].KeyPos:=BtKeyPos(@Cust.CustCode2,@Cust)+1;
    KeyBuff[7].KeyLen:=20;
    KeyBuff[7].KeyFlags:=DupMod+AltColSeq;


    { 05 - CustSupp+Code (ATCodeK) }

    KeyBuff[8].KeyPos:=BtKeyPos(@Cust.CustSupp,@Cust);
    KeyBuff[8].KeyLen:=01;
    KeyBuff[8].KeyFlags:=ModSeg+AltColSeq;

    KeyBuff[9].KeyPos:=BtKeyPos(@Cust.CustCode,@Cust)+1;
    KeyBuff[9].KeyLen:=10;
    KeyBuff[9].KeyFlags:=Modfy+AltColSeq;


    { 06 - CustSupp+Company (ATCompK) }

    KeyBuff[10].KeyPos:=BtKeyPos(@Cust.CustSupp,@Cust);
    KeyBuff[10].KeyLen:=01;
    KeyBuff[10].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[11].KeyPos:=BtKeyPos(@Cust.Company,@Cust)+1;
    KeyBuff[11].KeyLen:=45;
    KeyBuff[11].KeyFlags:=DupMod+AltColSeq;


    { 07 - CustSupp+Alt CustCode (ATAltK) }

    KeyBuff[12].KeyPos:=BtKeyPos(@Cust.CustSupp,@Cust);
    KeyBuff[12].KeyLen:=01;
    KeyBuff[12].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[13].KeyPos:=BtKeyPos(@Cust.CustCode2,@Cust)+1;
    KeyBuff[13].KeyLen:=20;
    KeyBuff[13].KeyFlags:=DupMod+AltColSeq;


    { 08 - Post Code (CustPCodeK) }

    KeyBuff[14].KeyPos:=BtKeyPos(@Cust.PostCode,@Cust)+1;
    KeyBuff[14].KeyLen:=20;
    KeyBuff[14].KeyFlags:=DupMod+AltColSeq+ManK;


    { 09 - RefNo (CustRCodeK) }

    KeyBuff[15].KeyPos:=BtKeyPos(@Cust.RefNo,@Cust)+1;
    KeyBuff[15].KeyLen:=10;
    KeyBuff[15].KeyFlags:=DupMod+AltColSeq+ManK;

    { 10 - Invoice To (CustInvToK) }

    KeyBuff[16].KeyPos:=BtKeyPos(@Cust.SOPInvCode,@Cust)+1;
    KeyBuff[16].KeyLen:=10;
    KeyBuff[16].KeyFlags:=DupMod+AltColSeq;

    { 11 - CustSupp+email Addr (CustEmailK) }

    KeyBuff[17].KeyPos:=BtKeyPos(@Cust.CustSupp,@Cust);
    KeyBuff[17].KeyLen:=01;
    KeyBuff[17].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[18].KeyPos:=BtKeyPos(@Cust.EmailAddr,@Cust)+1;
    KeyBuff[18].KeyLen:=100;
    KeyBuff[18].KeyFlags:=DupMod+AltColSeq;

    //PR: 21/08/2013 MRD 1.1.01
    {12 - SubType + AcCode (CustACCodeK) }
    KeyBuff[19].KeyPos:=BtKeyPos(@Cust.acSubType,@Cust);
    KeyBuff[19].KeyLen:=01;
    KeyBuff[19].KeyFlags:=ModSeg+AltColSeq;

    KeyBuff[20].KeyPos:=BtKeyPos(@Cust.CustCode,@Cust)+1;
    KeyBuff[20].KeyLen:=SizeOf(Cust.CustCode) - 1;
    KeyBuff[20].KeyFlags:=Modfy+AltColSeq;

    {13 - SubType + LongAcCode (CustLongACCodeK) }
    KeyBuff[21].KeyPos:=BtKeyPos(@Cust.acSubtype,@Cust);
    KeyBuff[21].KeyLen:=01;
    KeyBuff[21].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[22].KeyPos:=BtKeyPos(@Cust.acLongAcCode,@Cust)+1;
    KeyBuff[22].KeyLen:=SizeOf(Cust.acLongAcCode) - 1;
    KeyBuff[22].KeyFlags:=DupMod+AltColSeq;

    {14 - SubType + Company (CustNameK) }
    KeyBuff[23].KeyPos:=BtKeyPos(@Cust.acSubtype,@Cust);
    KeyBuff[23].KeyLen:=01;
    KeyBuff[23].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[24].KeyPos:=BtKeyPos(@Cust.Company,@Cust)+1;
    KeyBuff[24].KeyLen:=SizeOf(Cust.Company) - 1;
    KeyBuff[24].KeyFlags:=DupMod+AltColSeq;

    {15 - SubType + AltCode (CustAltCodeK) }
    KeyBuff[25].KeyPos:=BtKeyPos(@Cust.acSubtype,@Cust);
    KeyBuff[25].KeyLen:=01;
    KeyBuff[25].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[26].KeyPos:=BtKeyPos(@Cust.CustCode2,@Cust)+1;
    KeyBuff[26].KeyLen:=SizeOf(Cust.CustCode2) - 1;
    KeyBuff[26].KeyFlags:=DupMod+AltColSeq;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(Cust);                             { <<<<<<<<******** Change }

  Fillchar(Cust,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Cust;                 { <<<<<<<<******** Change }

  FileSpecOfs[Idx]:=@CustFile;


  FileNames[Idx]:=Path1+CustName;                         { <<<<<<<<******** Change }

  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Cust: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',Sizeof(CustFile):4);
      Writeln('Total...:',FileRecLen[Idx]+Sizeof(CustFile):4);
    end;

  {$ENDIF}

end; {..}






Procedure DefineDoc;

Const
  Idx = InvF;

Begin
  With InvFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(InvFile);                      { <<<<<<<<******** Change }
    Fillchar(InvFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Inv);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize7;
    NumIndex:=INofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { Key Definitons }                                       { <<<<<<<<******** Change }


    { 00 - RunNo + DocCode[1] + Folio No. (InvRNoK) }

    KeyBuff[1].KeyPos:=BtKeyPos(@Inv.RunNo,@Inv);
    KeyBuff[1].KeyLen:=04;
    KeyBuff[1].KeyFlags:=ModSeg+ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;

    KeyBuff[2].KeyPos:=BtKeyPos(@Inv.OurRef[1],@Inv);
    KeyBuff[2].KeyLen:=1;
    KeyBuff[2].KeyFlags:=ModSeg+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility

    KeyBuff[3].KeyPos:=BtKeyPos(@Inv.FolioNum,@Inv);
    KeyBuff[3].KeyLen:=04;
    KeyBuff[3].KeyFlags:=Modfy+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;


    { 01 - CustCode + CustSupp + NormFlg (InvCustK) }

    KeyBuff[4].KeyPos:=BtKeyPos(@Inv.CustCode[1],@Inv);
    KeyBuff[4].KeyLen:=06;
    KeyBuff[4].KeyFlags:=DupModSeg+AltColSeq;


    KeyBuff[5].KeyPos:=BtKeyPos(@Inv.CustSupp,@Inv);
    KeyBuff[5].KeyLen:=01;
    KeyBuff[5].KeyFlags:=DupModSeg+AltColSeq;

    KeyBuff[6].KeyPos:=BtKeyPos(@Inv.NomAuto,@Inv);
    KeyBuff[6].KeyLen:=01;
    KeyBuff[6].KeyFlags:=DupMod+ExtType;
    KeyBuff[6].ExtTypeVal:=BBoolean;


    { 02  -  Our Ref (InvOurRefK)  }

    KeyBuff[7].KeyPos:=BtKeyPos(@Inv.OurRef[1],@Inv);
    KeyBuff[7].KeyLen:=10;
    KeyBuff[7].KeyFlags:=Modfy+AltColSeq;



    { 03 - FolioNo  (InvFolioK)  }

    KeyBuff[8].KeyPos:=BtKeyPos(@Inv.FolioNum,@Inv);
    KeyBuff[8].KeyLen:=04;
    KeyBuff[8].KeyFlags:=Modfy+ExtType;
    KeyBuff[8].ExtTypeVal:=BInteger;


    { 04 - CustSupp + CustCode + DueDate + NormFlg (InvCDueK) }

    KeyBuff[9].KeyPos:=BtKeyPos(@Inv.CustSupp,@Inv);
    KeyBuff[9].KeyLen:=1;
    KeyBuff[9].KeyFlags:=DupModSeg+AltColSeq+Mank;

    KeyBuff[10].KeyPos:=BtKeyPos(@Inv.CustCode[1],@Inv);
    KeyBuff[10].KeyLen:=6;
    KeyBuff[10].KeyFlags:=DupModSeg+AltColSeq+Mank;

    KeyBuff[11].KeyPos:=BtKeyPos(@Inv.DueDate[1],@Inv);
    KeyBuff[11].KeyLen:=08;
    KeyBuff[11].KeyFlags:=DupModSeg+AltColSeq+Mank;

    KeyBuff[12].KeyPos:=BtKeyPos(@Inv.NomAuto,@Inv);
    KeyBuff[12].KeyLen:=01;
    KeyBuff[12].KeyFlags:=DupMod+ExtType+Mank;
    KeyBuff[12].ExtTypeVal:=BBoolean;


    { 05 - VATDate + OurRef (InvVatK)  }

    KeyBuff[13].KeyPos:=BtKeyPos(@Inv.VATPostDate[1],@Inv);
    KeyBuff[13].KeyLen:=08;
    KeyBuff[13].KeyFlags:=DupModSeg+Mank;


    KeyBuff[14].KeyPos:=BtKeyPos(@Inv.OurRef[1],@Inv);
    KeyBuff[14].KeyLen:=10;
    KeyBuff[14].KeyFlags:=DupMod+Mank+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility



    { 06 - Your Ref  (InvYrRefK)  }

    KeyBuff[15].KeyPos:=BtKeyPos(@Inv.YourRef[1],@Inv);
    KeyBuff[15].KeyLen:=20;
    KeyBuff[15].KeyFlags:=DupMod+AltColSeq+Mank;


    { 07- BatchLink (InvBatchK)/(PSOP Due DATE) }

    KeyBuff[16].KeyPos:=BtKeyPos(@Inv.BatchLink[1],@Inv);
    KeyBuff[16].KeyLen:=12;
    KeyBuff[16].KeyFlags:=DupMod+Mank;


    { 08- Long YourRef (InvLYRefK) }

    KeyBuff[17].KeyPos:=BtKeyPos(@Inv.TransDesc,@Inv)+1;
    KeyBuff[17].KeyLen:=20;
    KeyBuff[17].KeyFlags:=DupMod+AltColSeq+Mank;



    { 09- Transaction Date (InvDateK) }

    KeyBuff[18].KeyPos:=BtKeyPos(@Inv.TransDate[1],@Inv);
    KeyBuff[18].KeyLen:=08;
    KeyBuff[18].KeyFlags:=DupMod+AltColSeq+Mank;


    { 10- Transaction Period (InvYrPrK) }

    KeyBuff[19].KeyPos:=BtKeyPos(@Inv.AcYr,@Inv);
    KeyBuff[19].KeyLen:=02;
    KeyBuff[19].KeyFlags:=DupMod+{AltColSeq+ExtType+}Mank;
    {KeyBuff[19].ExtTypeVal:=BInteger;{v4.32. This won't take effect until a rebuild is used. Not an official index,
                                      was just an AltColSeq which was failing once you got a search past the lower
                                      case range of ASCII Routine HasFutureTrans would need to be modified once
                                      this index was official to use 149 as the future period check
                                      Taken out under v4.32.002, left AltCol Seq out to correct future period post}


    { 11 - AllocStat + CustCode  (InvOSK) }

    KeyBuff[20].KeyPos:=BtKeyPos(@Inv.AllocStat,@Inv);
    KeyBuff[20].KeyLen:=01;
    KeyBuff[20].KeyFlags:=DupModSeg+AltColSeq+ManK;

    KeyBuff[21].KeyPos:=BtKeyPos(@Inv.CustCode,@Inv)+1;
    KeyBuff[21].KeyLen:=6;
    KeyBuff[21].KeyFlags:=DupMod+AltColSeq+Mank;


    {$IFDEF ExWin}

      { 12 - CISDate (InvCISK)  }

      KeyBuff[22].KeyPos:=BtKeyPos(@Inv.CISDate,@Inv)+1;
      KeyBuff[22].KeyLen:=08;
      KeyBuff[22].KeyFlags:=DupMod+Mank;

      // MHCL
      { 13 - CustCode + CustSupp + NormFlg + Date + Folio (InvCustLedgK) }
      With KeyBuff[23] Do
      Begin
        KeyPos:=BtKeyPos(@Inv.CustCode[1],@Inv);
        KeyLen:=06;
        KeyFlags:=DupModSeg+AltColSeq;
      End; // With KeyBuff[23]
      With KeyBuff[24] Do
      Begin
        KeyPos:=BtKeyPos(@Inv.CustSupp,@Inv);
        KeyLen:=01;
        KeyFlags:=DupModSeg+AltColSeq;
      End; // With KeyBuff[24]
      With KeyBuff[25] Do
      Begin
        KeyPos:=BtKeyPos(@Inv.NomAuto,@Inv);
        KeyLen:=01;
        KeyFlags:=DupModSeg+ExtType;
        ExtTypeVal:=BBoolean;
      End; // With KeyBuff[25]
      With KeyBuff[26] Do
      Begin
        KeyPos:=BtKeyPos(@Inv.TransDate[1],@Inv);
        KeyLen:=08;
        KeyFlags:=DupModSeg+AltColSeq;
      End; // With KeyBuff[26]
      With KeyBuff[27] Do
      Begin
        KeyPos:=BtKeyPos(@Inv.FolioNum,@Inv);
        KeyLen:=04;
        KeyFlags:=DupMod+ExtType;
        ExtTypeVal:=BInteger;
      End; // With KeyBuff[27]

    {$ENDIF}

    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region Index for Multi-Region Tax
    // InvTaxRegionK = 14 - thTaxRegion + VATPostDate + OurRef
    // Note: Can't use ManK as per InvVatK as Tax Region 0 would never appear in the index
    With KeyBuff[28] Do
    Begin
      KeyPos:=BtKeyPos(@Inv.thTaxRegion,@Inv);
      KeyLen:=SizeOf(Inv.thTaxRegion);
      KeyFlags:=DupModSeg + ExtType;
      ExtTypeVal:=BInteger;
    End; // With KeyBuff[28]
    With KeyBuff[29] Do
    Begin
      KeyPos:=BtKeyPos(@Inv.VATPostDate[1], @Inv);  // String - offset to first character
      KeyLen:=SizeOf(Inv.VATPostDate) - 1;          // String - ignore length byte
      KeyFlags:=DupModSeg;
    End; // With KeyBuff[29]
    With KeyBuff[30] Do
    Begin
      KeyPos:=BtKeyPos(@Inv.OurRef[1], @Inv);  // String - offset to first character
      KeyLen:=SizeOf(Inv.OurRef) - 1;          // String - ignore length byte
      KeyFlags:=DupMod + AltColSeq;
    End; // With KeyBuff[30]

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }
  end; {With..}
  FileRecLen[Idx]:=Sizeof(Inv);                             { <<<<<<<<******** Change }

  Fillchar(Inv,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Inv;                 { <<<<<<<<******** Change }

  FileSpecOfs[Idx]:=@InvFile;    { <<<<<<<<******** Change }


  FileNames[Idx]:=Path2+DocName;                         { <<<<<<<<******** Change }

  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Doc: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
    end;

  {$ENDIF}

end; {..}





Procedure DefineIdetail;

Const
  Idx = IdetailF;

Begin
  With IdFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(IdFile);                      { <<<<<<<<******** Change }
    Fillchar(IdFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Id);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize3;  // 2k
    NumIndex:=IDNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}

    { Key Definitons }                                       { <<<<<<<<******** Change }



    { 00 - Folio No + Line No (IdFolioK) }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=4;
    KeyBuff[1].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;

    KeyBuff[2].KeyPos:=5;
    KeyBuff[2].KeyLen:=4;
    KeyBuff[2].KeyFlags:=DupMod+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;


    { 01  -  PostedRun + NomCode  (IDRunK)  }

    KeyBuff[3].KeyPos:=9;
    KeyBuff[3].KeyLen:=4;
    KeyBuff[3].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    KeyBuff[4].KeyPos:=13;
    KeyBuff[4].KeyLen:=4;
    KeyBuff[4].KeyFlags:=DupMod+ExtType;
    KeyBuff[4].ExtTypeVal:=BInteger;

    { 02  -  NomCode + [NomMode+Currency+Yr+Pr] + PostedRun (IDNomK)  }

    KeyBuff[5].KeyPos:=13;
    KeyBuff[5].KeyLen:=4;
    KeyBuff[5].KeyFlags:=DupModSeg+ExtType+Mank;
    KeyBuff[5].ExtTypeVal:=BInteger;

    KeyBuff[6].KeyPos:=17;
    KeyBuff[6].KeyLen:=4;
    KeyBuff[6].KeyFlags:=DupModSeg+Mank;

    KeyBuff[7].KeyPos:=9;
    KeyBuff[7].KeyLen:=4;
    KeyBuff[7].KeyFlags:=DupMod+ExtType+Mank;
    KeyBuff[7].ExtTypeVal:=BInteger;


    { 03  -  StockCode  (  IdStk  )  }

    KeyBuff[8].KeyPos:=30;
    KeyBuff[8].KeyLen:=20;
    KeyBuff[8].KeyFlags:=DupMod+ManK;



    { 04  -  LineType + StockCode + PDate (  IdAnalk  )  }

    KeyBuff[9].KeyPos:=54;
    KeyBuff[9].KeyLen:=1;
    KeyBuff[9].KeyFlags:=DupModSeg+Mank;


    KeyBuff[10].KeyPos:=30;
    KeyBuff[10].KeyLen:=20;
    KeyBuff[10].KeyFlags:=DupModSeg+Mank;

    KeyBuff[11].KeyPos:=129;
    KeyBuff[11].KeyLen:=08;
    KeyBuff[11].KeyFlags:=DupMod+Mank;

    { 05  -  Folio No. + ABS LineNo (  IdLinkK  )  }

    KeyBuff[12].KeyPos:=01;
    KeyBuff[12].KeyLen:=4;
    KeyBuff[12].KeyFlags:=DupModSeg+ExtType+Mank;
    KeyBuff[12].ExtTypeVal:=BInteger;

    KeyBuff[13].KeyPos:=50;
    KeyBuff[13].KeyLen:=04;
    KeyBuff[13].KeyFlags:=DupMod+ExtType+Mank;
    KeyBuff[13].ExtTypeVal:=BInteger;


    { 06  -  LineType + CustCode + StockCode + PDate (  IdCAnalk  )  }

    KeyBuff[14].KeyPos:=54;
    KeyBuff[14].KeyLen:=1;
    KeyBuff[14].KeyFlags:=DupModSeg+Mank;

    KeyBuff[15].KeyPos:=118;
    KeyBuff[15].KeyLen:=10;
    KeyBuff[15].KeyFlags:=DupModSeg+Mank;


    KeyBuff[16].KeyPos:=30;
    KeyBuff[16].KeyLen:=20;
    KeyBuff[16].KeyFlags:=DupModSeg+Mank;

    KeyBuff[17].KeyPos:=129;
    KeyBuff[17].KeyLen:=08;
    KeyBuff[17].KeyFlags:=DupMod+Mank;


    { 07  -  [NomCode + NomMode] +Reconcile + [Currency+Yr+Pr] (IDReconK)  }

    KeyBuff[18].KeyPos:=13;
    KeyBuff[18].KeyLen:=5;
    KeyBuff[18].KeyFlags:=DupModSeg;

    KeyBuff[19].KeyPos:=BtKeyPos(@Id.Reconcile,@Id);
    KeyBuff[19].KeyLen:=1;
    KeyBuff[19].KeyFlags:=DupModSeg;

    KeyBuff[20].KeyPos:=18;
    KeyBuff[20].KeyLen:=3;
    KeyBuff[20].KeyFlags:=DupMod;

    // MHSL
    { 8  -  StockCode + PDate + Folio ( IdStkLedgK )  }
    With KeyBuff[21] Do
    Begin
      KeyPos:=30;
      KeyLen:=20;
      KeyFlags:=DupModSeg+ManK;
    End; // With KeyBuff[21]
    With KeyBuff[22] Do
    Begin
      KeyPos:=129;
      KeyLen:=08;
      KeyFlags:=DupModSeg+Mank;
    End; // With KeyBuff[22]
    With KeyBuff[23] Do
    Begin
      KeyPos:=01;
      KeyLen:=4;
      KeyFlags:=DupMod+ExtType+Mank;
      ExtTypeVal:=BInteger;
    End; // With KeyBuff[23]

    // MH 19/08/2009: Added new index for EC Sales List
    // 9 - CustCode + ECService + ServiceStartDate (IdServiceK)
    With KeyBuff[24] Do
    Begin
      KeyPos   := BtKeyPos (@Id.CustCode[1], @Id);   // Skip length byte
      KeyLen   := SizeOf (Id.CustCode) - 1;          // subtract length byte
      KeyFlags := DupModSeg + ManK;
    End; // With KeyBuff[24]
    With KeyBuff[25] Do
    Begin
      KeyPos     := BtKeyPos (@Id.ECService, @Id);
      KeyLen     := SizeOf (Id.ECService);
      KeyFlags   := DupModSeg + ManK + ExtType;
      ExtTypeVal := BBoolean;
    End; // With KeyBuff[25]
    With KeyBuff[26] Do
    Begin
      KeyPos   := BtKeyPos (@Id.ServiceStartDate[1], @Id);    // Skip length byte
      KeyLen   := SizeOf (Id.ServiceStartDate) - 1;           // subtract length byte
      KeyFlags := DupMod + ManK;
    End; // With KeyBuff[26]

    // CJS 2014-01-06 - ABSEXCH-14854 - new indexes (10 - 12)
    
    // Index 10 - CustCode+DocPRef (IdCustCodeK) 
    With KeyBuff[27] Do
    Begin
      KeyPos   := BtKeyPos (@Id.CustCode[1], @Id);   // Skip length byte
      KeyLen   := SizeOf (Id.CustCode) - 1;          // subtract length byte
      KeyFlags := DupModSeg + Mank; //PR: 13/08/2015 ABSEXCH-16180 Corrected to DupModSeq
    End; // With KeyBuff[27]
    With KeyBuff[28] Do
    Begin
      KeyPos   := BtKeyPos (@Id.DocPRef[1], @Id);   // Skip length byte
      KeyLen   := SizeOf (Id.DocPRef) - 1;          // subtract length byte
      KeyFlags := DupMod + Mank;
    End; // With KeyBuff[28]

    // Index 11 - DocPRef (IdDocPRefK)
    With KeyBuff[29] Do
    Begin
      KeyPos   := BtKeyPos (@Id.DocPRef[1], @Id);   // Skip length byte
      KeyLen   := SizeOf (Id.DocPRef) - 1;          // subtract length byte
      KeyFlags := DupMod + Mank;
    End; // With KeyBuff[29]

    // Index 12 - Year+Period+DocPRef (IdYrPrK)
    With KeyBuff[30] Do
    Begin
      KeyPos     := BtKeyPos (@Id.PYr, @Id);
      KeyLen     := SizeOf (Id.PYr);
      KeyFlags   := DupModSeg + ExtType + Mank;
      ExtTypeVal := BInteger;
    End; // With KeyBuff[30]
    With KeyBuff[31] Do
    Begin
      //PR: 13/08/2015 ABSEXCH-16180 Corrected to use Id.PPr
      KeyPos     := BtKeyPos (@Id.PPr, @Id);
      KeyLen     := SizeOf (Id.PPr);
      KeyFlags   := DupModSeg + ExtType + Mank;
      ExtTypeVal := BInteger;
    End; // With KeyBuff[31]
    With KeyBuff[32] Do
    Begin
      KeyPos   := BtKeyPos (@Id.DocPRef[1], @Id);   // Skip length byte
      KeyLen   := SizeOf (Id.DocPRef) - 1;          // subtract length byte
      KeyFlags := DupMod + Mank;
    End; // With KeyBuff[32]

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(Id);                             { <<<<<<<<******** Change }

  Fillchar(Id,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Id;

  FileSpecOfs[Idx]:=@IdFile;


  FileNames[Idx]:=Path2+DetailName;                         { <<<<<<<<******** Change }

  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('IDetail: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',Sizeof(IdFile):4);
      Writeln('Total...:',FileRecLen[Idx]+Sizeof(IdFile):4);
      {Ch:=ReadKey;}
    end;
  
  {$ENDIF}

end; {..}






Procedure DefineNominal;

Const
  Idx = NomF;

Begin
  With NomFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(NomFile);                      { <<<<<<<<******** Change }
    Fillchar(NomFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Nom);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=NNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=1;


    { Key Definitons }                                       { <<<<<<<<******** Change }


    { 00 - Code  (NomCodeK)  }


    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=04;
    KeyBuff[1].KeyFlags:=ModFy+ExtType;
    KeyBuff[1].ExtTypeVal:=BInteger;



    { 01 - Description (NomDescK) }

    KeyBuff[2].KeyPos:=06;
    KeyBuff[2].KeyLen:=40;
    KeyBuff[2].KeyFlags:=DupMod+AltColSeq;


    { 02 - Cat + Code (NomCatK) }


    KeyBuff[3].KeyPos:=BtKeyPos(@Nom.CAT,@Nom);
    KeyBuff[3].KeyLen:=4;
    KeyBuff[3].KeyFlags:=ModSeg+ExtType;
    KeyBuff[3].ExtTypeVal:=BInteger;

    KeyBuff[4]:=KeyBuff[1];



    { 03 - Alt Code (NomAltK) }

    KeyBuff[5].KeyPos:=BtKeyPos(@Nom.AltCode,@Nom)+1;
    KeyBuff[5].KeyLen:=50;
    KeyBuff[5].KeyFlags:=DupMod+AltColSeq;

    // Index 4 - NomCodeStr (NomCodeStrK)
    KeyBuff[6].KeyPos:=BtKeyPos(@Nom.NomCodeStr[1],@Nom);
    KeyBuff[6].KeyLen:=SizeOf(Nom.NomCodeStr)-1;
    KeyBuff[6].KeyFlags:=ModFy+AltColSeq;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(Nom);                             { <<<<<<<<******** Change }

  Fillchar(Nom,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Nom;

  FileSpecOfs[Idx]:=@NomFile;


  FileNames[Idx]:=Path2+NomNam;                         { <<<<<<<<******** Change }

end; {..}







Procedure DefineStock;

Const
  Idx = StockF;

Begin
  With StockFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(StockFile);                      { <<<<<<<<******** Change }
    Fillchar(StockFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Stock);                                  { <<<<<<<<******** Change }
     PageSize:=DefPageSize3;  // 2k
    NumIndex:=STNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc;                {* Used for max compression *}



    { Key Definitons }                                       { <<<<<<<<******** Change }




    { 00 - Code  (StockCodeK) }

    { Key Definitons }                                       { <<<<<<<<******** Change }
    KeyBuff[1].KeyPos:=02;
    KeyBuff[1].KeyLen:=20;
    KeyBuff[1].KeyFlags:=Modfy+AltColSeq;


    { 01 - StockFolio  (StockFolioK)  }


    KeyBuff[2].KeyPos:=292;
    KeyBuff[2].KeyLen:=04;
    KeyBuff[2].KeyFlags:=Modfy+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;


    { 02 - StockCat+StockCode (StockCATK)  }


    KeyBuff[3].KeyPos:=297;
    KeyBuff[3].KeyLen:=20;
    KeyBuff[3].KeyFlags:=ModSeg;

    KeyBuff[4].KeyPos:=02;
    KeyBuff[4].KeyLen:=20;
    KeyBuff[4].KeyFlags:=Modfy+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility


    { 03 - Desc[1] (StockDescK) }

    KeyBuff[5].KeyPos:=23;
    KeyBuff[5].KeyLen:=35;
    KeyBuff[5].KeyFlags:=DupMod+AltColSeq;


    { 04 - Supplier + PCurrency + StockCode  (StockMinK) }

    KeyBuff[6].KeyPos:=260;
    KeyBuff[6].KeyLen:=06;
    KeyBuff[6].KeyFlags:=ModSeg+Mank;

    KeyBuff[7].KeyPos:=601;
    KeyBuff[7].KeyLen:=1;
    KeyBuff[7].KeyFlags:=ModSeg+Mank;

    KeyBuff[8].KeyPos:=02;
    KeyBuff[8].KeyLen:=20;
    KeyBuff[8].KeyFlags:=Modfy+Mank+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility


    { 05 - BNomCode+StockCode (StockValK) }

    KeyBuff[09].KeyPos:=282;
    KeyBuff[09].KeyLen:=04;
    KeyBuff[09].KeyFlags:=ModSeg+ExtType;
    KeyBuff[09].ExtTypeVal:=BInteger;

    KeyBuff[10].KeyPos:=02;
    KeyBuff[10].KeyLen:=20;
    KeyBuff[10].KeyFlags:=Modfy+AltColSeq;


    { 06 - AltCode (StockAltK) }

    KeyBuff[11].KeyPos:=239;
    KeyBuff[11].KeyLen:=20;
    KeyBuff[11].KeyFlags:=DupMod+Mank+AltColSeq;


    { 07 - BinLoc (StockBinK) }

    KeyBuff[12].KeyPos:=553;
    KeyBuff[12].KeyLen:=10;
    KeyBuff[12].KeyFlags:=DupMod;

    { 08 - BarCode (StkBarCK) }

    KeyBuff[13].KeyPos:=BtKeyPos(@Stock.BarCode,@Stock)+1;
    KeyBuff[13].KeyLen:=20;
    KeyBuff[13].KeyFlags:=DupMod;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(Stock);                             { <<<<<<<<******** Change }

  Fillchar(Stock,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Stock;

  FileSpecOfs[Idx]:=@StockFile;


  FileNames[Idx]:=Path4+StockNam;                         { <<<<<<<<******** Change }

  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Stock: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',Sizeof(StockFile):4);
      Writeln('Total...:',FileRecLen[Idx]+Sizeof(StockFile):4);

    end;

  {$ENDIF}

end; {..}





Procedure DefineNumHist;

Const
  Idx = NHistF;

Begin
  With NHFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(NHFile);                      { <<<<<<<<******** Change }
    Fillchar(NHFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(NHist);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=NhNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc;                {* Used for max compression *}


    { 00 - Type + Code + [Currency + Year + Pr] (NhK)  }                     { <<<<<<<<******** Change }
    KeyBuff[1].KeyPos:=22;
    KeyBuff[1].KeyLen:=1;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=02;
    KeyBuff[2].KeyLen:=20;
    KeyBuff[2].KeyFlags:=DupModSeg;


    KeyBuff[3].KeyPos:=23;
    KeyBuff[3].KeyLen:=3;
    KeyBuff[3].KeyFlags:=DupMod;




    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(NHist);                             { <<<<<<<<******** Change }

  Fillchar(NHist,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@NHist;

  FileSpecOfs[Idx]:=@NHFile;


  FileNames[Idx]:=Path2+HistName;                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('NHist: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}


end; {..}




Procedure DefineCount;

Const
  Idx = IncF;

Begin
  With CountFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(CountFile);                      { <<<<<<<<******** Change }
    Fillchar(CountFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Count);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=IncNofKeys;                                      { <<<<<<<<******** Change }
    Variable:=1;

    { 00 - Code (IncK) }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=3;
    KeyBuff[1].KeyFlags:=Modfy+AltColSeq;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(Count);                             { <<<<<<<<******** Change }

  Fillchar(Count,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Count;

  FileSpecOfs[Idx]:=@CountFile;


  FileNames[Idx]:=NumNam;                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Count: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}


end; {..}



Procedure DefinePassWord;

Const
  Idx = PWrdF;

Begin
  With PassFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(PassFile);                      { <<<<<<<<******** Change }
    Fillchar(PassFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(PassWord);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=PwNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecPfix+SubType) + Login  (PWK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=12;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) + Access [1..11] (PWK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=27;
    KeyBuff[4].KeyLen:=11;
    KeyBuff[4].KeyFlags:=DupMod+Mank;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(PassWord);                             { <<<<<<<<******** Change }

  Fillchar(PassWord,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@PassWord;

  FileSpecOfs[Idx]:=@PassFile;


  FileNames[Idx]:=Path3+PassNam;                         { <<<<<<<<******** Change }



  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('PassWord: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
      {Ch:=ReadKey;}
    end;

  {$ENDIF}

end; {..}




Procedure DefineMiscRecs;

Const
  Idx = MiscF;

Begin
  With MiscFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(MiscFile^);                      { <<<<<<<<******** Change }
    Fillchar(MiscFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(MiscRecs^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=MINofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecMfix+SubType) + DiscCode (MIK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=26;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) + QStkCode (MiscNdxK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=31;
    KeyBuff[4].KeyLen:=20;
    KeyBuff[4].KeyFlags:=DupMod+Mank;


    { 02 - (RecPfix+SubType) + BatchNo (MiscBtcK)  }                     { <<<<<<<<******** Change }

    KeyBuff[5].KeyPos:=1;
    KeyBuff[5].KeyLen:=2;
    KeyBuff[5].KeyFlags:=DupModSeg+Mank;

    KeyBuff[6].KeyPos:=52;
    KeyBuff[6].KeyLen:=10;
    KeyBuff[6].KeyFlags:=DupMod+Mank;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(MiscRecs^);                             { <<<<<<<<******** Change }

  Fillchar(MiscRecs^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@MiscRecs^;

  FileSpecOfs[Idx]:=@MiscFile^;


  FileNames[Idx]:=Path3+MiscNam;                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Misc File: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}


end; {..}



Procedure DefineJobMisc;

Const
  Idx = JMiscF;

Begin
  With JobMiscFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(JobMiscFile^);                      { <<<<<<<<******** Change }
    Fillchar(JobMiscFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(JobMisc^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=JMNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecPfix+SubType) + EmplCode (JMK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=10;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) +  Surname (JMSecK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=19;
    KeyBuff[4].KeyLen:=20;
    KeyBuff[4].KeyFlags:=DupMod+Mank;


    { 02 - (RecPfix+SubType) +  Supplier (JMTrdK)  }                     { <<<<<<<<******** Change }

    KeyBuff[5].KeyPos:=1;
    KeyBuff[5].KeyLen:=2;
    KeyBuff[5].KeyFlags:=DupModSeg+Mank;

    KeyBuff[6].KeyPos:=40;
    KeyBuff[6].KeyLen:=10;
    KeyBuff[6].KeyFlags:=DupMod+Mank;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(JobMisc^);                             { <<<<<<<<******** Change }

  Fillchar(JobMisc^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobMisc^;

  FileSpecOfs[Idx]:=@JobMiscFile^;


  FileNames[Idx]:=Path6+JobMiscNam;                         { <<<<<<<<******** Change }


{$IFNDEF EXWIN}

  If (Debug) then
  Begin
    Writeln('Job Misc : .. ',FileRecLen[Idx]:4);
    Writeln('FileDef.:',FileSpecLen[Idx]:4);
    Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
    Writeln;
  end;

{$ENDIF}

end; {..}



Procedure DefineJobRec;

Const
  Idx = JobF;

Begin
  With JobRecFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(JobRecFile^);                      { <<<<<<<<******** Change }
    Fillchar(JobRecFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(JobRec^);                                  { <<<<<<<<******** Change }
      PageSize:=DefPageSize3;  // 2k
    NumIndex:=JRNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - JobCode (JobCodeK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=10;
    KeyBuff[1].KeyFlags:=Modfy+AltColSeq;

    { 01 - Job Folio  (JobFolioK)  }


    KeyBuff[2].KeyPos:=43;
    KeyBuff[2].KeyLen:=04;
    KeyBuff[2].KeyFlags:=Modfy+ExtType;
    KeyBuff[2].ExtTypeVal:=BInteger;


    { 02 - JobCat+JobCode (JobCATK)  }


    KeyBuff[3].KeyPos:=59;
    KeyBuff[3].KeyLen:=10;
    KeyBuff[3].KeyFlags:=ModSeg+AltColSeq;

    KeyBuff[4].KeyPos:=02;
    KeyBuff[4].KeyLen:=10;
    KeyBuff[4].KeyFlags:=Modfy+AltColSeq;


    { 03 - Desc (JobDescK) }

    KeyBuff[5].KeyPos:=13;
    KeyBuff[5].KeyLen:=30;
    KeyBuff[5].KeyFlags:=DupMod+AltColSeq;


    { 04 - Completed + JobCode (JobCompCK)  }


    KeyBuff[6].KeyPos:=80;
    KeyBuff[6].KeyLen:=04;
    KeyBuff[6].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[6].ExtTypeVal:=BInteger;

    KeyBuff[7].KeyPos:=02;
    KeyBuff[7].KeyLen:=10;
    KeyBuff[7].KeyFlags:=DupMod+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility

    { 05 - Completed + JobDesc (JobCompDK)  }


    KeyBuff[8].KeyPos:=80;
    KeyBuff[8].KeyLen:=04;
    KeyBuff[8].KeyFlags:=DupModSeg+ExtType;
    KeyBuff[8].ExtTypeVal:=BInteger;

    KeyBuff[9].KeyPos:=13;
    KeyBuff[9].KeyLen:=30;
    KeyBuff[9].KeyFlags:=DupMod+AltColSeq;   // MH 14/05/07: Modified to use Alt Col Seq for SQL Compatibility


    { 06 - JobAlt Code (JobAltK)  }                     { <<<<<<<<******** Change }

    KeyBuff[10].KeyPos:=70;
    KeyBuff[10].KeyLen:=10;
    KeyBuff[10].KeyFlags:=DupMod+AltColSeq;

    { 07 - Account Code (JobCustK) }

    KeyBuff[11].KeyPos:=BtKeyPos(@JobRec^.CustCode,@JobRec^)+1;
    KeyBuff[11].KeyLen:=10;
    KeyBuff[11].KeyFlags:=DupMod+AltColSeq+ManK;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(JobRec^);                             { <<<<<<<<******** Change }

  Fillchar(JobRec^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobRec^;

  FileSpecOfs[Idx]:=@JobRecFile^;


  FileNames[Idx]:=Path6+JobRecNam;


{$IFNDEF EXWIN}

  If (Debug) then
  Begin
    Writeln('Job Rec : .. ',FileRecLen[Idx]:4);
    Writeln('FileDef.:',FileSpecLen[Idx]:4);
    Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
    Writeln;
  end;

{$ENDIF}
end; {..}




Procedure DefineJobDetl;

Const
  Idx = JDetlF;

Begin
  With JobDetlFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(JobDetlFile^);                      { <<<<<<<<******** Change }
    Fillchar(JobDetlFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(JobDetl^);                                  { <<<<<<<<******** Change }
      PageSize:=DefPageSize3;  // 2k
    NumIndex:=JDNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecPfix+SubType) + LedgerCode (JDLedgerK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=21;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) +  AnalKey + Cr+Yr+Pr (JDAnalK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=29;
    KeyBuff[4].KeyLen:=20;
    KeyBuff[4].KeyFlags:=DupModSeg+Mank;

    KeyBuff[5].KeyPos:=167;
    KeyBuff[5].KeyLen:=03;
    KeyBuff[5].KeyFlags:=DupMod+Mank;


    { 02 - (RecPfix+SubType) +  StockKey (JDStkK) +Cr+Yr+Pr }                     { <<<<<<<<******** Change }

    KeyBuff[6].KeyPos:=1;
    KeyBuff[6].KeyLen:=2;
    KeyBuff[6].KeyFlags:=DupModSeg+Mank;

    KeyBuff[7].KeyPos:=50;
    KeyBuff[7].KeyLen:=26;
    KeyBuff[7].KeyFlags:=DupModSeg+Mank;

    KeyBuff[8].KeyPos:=167;
    KeyBuff[8].KeyLen:=03;
    KeyBuff[8].KeyFlags:=DupMod+Mank;


    { 03 - (RecPfix+SubType) +  EmplKey (JDEmpK)  }                     { <<<<<<<<******** Change }

    KeyBuff[9].KeyPos:=1;
    KeyBuff[9].KeyLen:=2;
    KeyBuff[9].KeyFlags:=DupModSeg+Mank;

    KeyBuff[10].KeyPos:=88;
    KeyBuff[10].KeyLen:=21;
    KeyBuff[10].KeyFlags:=DupMod+Mank;

    { 04 - (RecPfix+SubType) +  RunKey (JDPostedK)  }                     { <<<<<<<<******** Change }

    KeyBuff[11].KeyPos:=1;
    KeyBuff[11].KeyLen:=2;
    KeyBuff[11].KeyFlags:=DupModSeg+Mank;

    KeyBuff[12].KeyPos:=110;
    KeyBuff[12].KeyLen:=22;
    KeyBuff[12].KeyFlags:=DupMod+Mank;


    { 05 - (RecPfix+SubType) +  LookupK (JDLookK)  }                     { <<<<<<<<******** Change }

    KeyBuff[13].KeyPos:=1;
    KeyBuff[13].KeyLen:=2;
    KeyBuff[13].KeyFlags:=DupModSeg+Mank;

    KeyBuff[14].KeyPos:=133;
    KeyBuff[14].KeyLen:=19;
    KeyBuff[14].KeyFlags:=DupMod+Mank;


    { 06 - (RecPfix+SubType) +  HedKey + Cr+Yr+Pr (JDHedK)  }                     { <<<<<<<<******** Change }

    KeyBuff[15].KeyPos:=1;
    KeyBuff[15].KeyLen:=2;
    KeyBuff[15].KeyFlags:=DupModSeg+Mank;

    KeyBuff[16].KeyPos:=153;
    KeyBuff[16].KeyLen:=14;
    KeyBuff[16].KeyFlags:=DupModSeg+Mank;

    KeyBuff[17].KeyPos:=167;
    KeyBuff[17].KeyLen:=03;
    KeyBuff[17].KeyFlags:=DupMod+Mank;



    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(JobDetl^);                             { <<<<<<<<******** Change }

  Fillchar(JobDetl^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobDetl^;

  FileSpecOfs[Idx]:=@JobDetlFile^;


  FileNames[Idx]:=Path6+JobDetNam;                         { <<<<<<<<******** Change }


{$IFNDEF EXWIN}

  If (Debug) then
  Begin
    Writeln('Job Detl : .. ',FileRecLen[Idx]:4);
    Writeln('FileDef.:',FileSpecLen[Idx]:4);
    Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
    Writeln;
  end;

{$ENDIF}

end; {..}


Procedure DefineJobCtrl;

Const
  Idx = JCtrlF;

Begin
  With JobCtrlFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(JobCtrlFile^);                      { <<<<<<<<******** Change }
    Fillchar(JobCtrlFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(JobCtrl^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=JCNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (RecPfix+SubType) + BudgetCode (JCK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=1;
    KeyBuff[1].KeyLen:=2;
    KeyBuff[1].KeyFlags:=DupModSeg;

    KeyBuff[2].KeyPos:=4;
    KeyBuff[2].KeyLen:=27;
    KeyBuff[2].KeyFlags:=DupMod;


    { 01 - (RecPfix+SubType) +  Code2NDX (JCSecK)  }                     { <<<<<<<<******** Change }

    KeyBuff[3].KeyPos:=1;
    KeyBuff[3].KeyLen:=2;
    KeyBuff[3].KeyFlags:=DupModSeg+Mank;

    KeyBuff[4].KeyPos:=36;
    KeyBuff[4].KeyLen:=21;
    KeyBuff[4].KeyFlags:=DupMod+Mank;


    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}
  FileRecLen[Idx]:=Sizeof(JobCtrl^);                             { <<<<<<<<******** Change }

  Fillchar(JobCtrl^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobCtrl^;

  FileSpecOfs[Idx]:=@JobCtrlFile^;


  FileNames[Idx]:=Path6+JobCtrlNam;                         { <<<<<<<<******** Change }

  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Job Ctrl : .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}


end; {..}



  Procedure DefineMLoc;

  Const
   Idx = MLocF;

  Begin
   With MLocFile^ do
   Begin
     FileSpecLen[Idx]:=Sizeof(MLocFile^);                      { <<<<<<<<******** Change }
     Fillchar(MLocFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
     RecLen:=Sizeof(MLocCtrl^);                                  { <<<<<<<<******** Change }
       PageSize:=DefPageSize3;  // 2k
     NumIndex:=MLNofKeys;                                      { <<<<<<<<******** Change }

     Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


     { 00 - (RecPfix+SubType) + BudgetCode (MLK)  }                     { <<<<<<<<******** Change }

     KeyBuff[1].KeyPos:=1;
     KeyBuff[1].KeyLen:=2;
     KeyBuff[1].KeyFlags:=DupModSeg;

     KeyBuff[2].KeyPos:=4;
     KeyBuff[2].KeyLen:=30;
     KeyBuff[2].KeyFlags:=DupMod;


     { 01 - (RecPfix+SubType) +  Code2NDX (MLSecK)  }                     { <<<<<<<<******** Change }

     KeyBuff[3].KeyPos:=1;
     KeyBuff[3].KeyLen:=2;
     KeyBuff[3].KeyFlags:=DupModSeg+Mank;

     KeyBuff[4].KeyPos:=35;
     KeyBuff[4].KeyLen:=45;
     KeyBuff[4].KeyFlags:=DupMod+Mank;


     { 02 - (RecPfix+SubType) +  Code3NDX (MLSuppK)  }                     { <<<<<<<<******** Change }

     KeyBuff[5].KeyPos:=1;
     KeyBuff[5].KeyLen:=2;
     KeyBuff[5].KeyFlags:=DupModSeg+Mank;

     KeyBuff[6].KeyPos:=81;
     KeyBuff[6].KeyLen:=31;
     KeyBuff[6].KeyFlags:=DupMod+Mank;


     AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

   end; {With..}
   FileRecLen[Idx]:=Sizeof(MLocCtrl^);                             { <<<<<<<<******** Change }

   Fillchar(MLocCtrl^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

   RecPtr[Idx]:=@MLocCtrl^;

   FileSpecOfs[Idx]:=@MLocFile^;


   FileNames[Idx]:=Path4+MLocName;                         { <<<<<<<<******** Change }

   {$IFNDEF EXWIN}

     If (Debug) then
     Begin
       Writeln('MLoc Stk : .. ',FileRecLen[Idx]:4);
       Writeln('FileDef.:',FileSpecLen[Idx]:4);
       Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
       Writeln;
     end;

   {$ENDIF}


  end; {..}


{$IFDEF EXWin}

  Procedure DefineNomView;

  Const
    Idx = NomViewF;

  Begin
    With NomViewFile^ do
    Begin
      FileSpecLen[Idx]:=Sizeof(NomViewFile^);                      { <<<<<<<<******** Change }
      Fillchar(NomViewFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
      RecLen:=Sizeof(NomView^);                                  { <<<<<<<<******** Change }
      PageSize:=DefPageSize;
      NumIndex:=NVNofKeys;                                      { <<<<<<<<******** Change }

      Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


      { 00 - (RecPfix+SubType) + NVCode1 (NVCodeK)  }                     { <<<<<<<<******** Change }

      KeyBuff[1].KeyPos:=1;
      KeyBuff[1].KeyLen:=2;
      KeyBuff[1].KeyFlags:=DupModSeg;

      KeyBuff[2].KeyPos:=BtKeyPos(@NomView^.NomViewLine.NVCode1,@NomView^)+1;;
      KeyBuff[2].KeyLen:=60;
      KeyBuff[2].KeyFlags:=DupMod;


      { 01 - (RecPfix+SubType) +  ViewIdx (NVCode2 - NVViewIdxK)  }                     { <<<<<<<<******** Change }

      KeyBuff[3].KeyPos:=1;
      KeyBuff[3].KeyLen:=2;
      KeyBuff[3].KeyFlags:=DupModSeg;

      KeyBuff[4].KeyPos:=BtKeyPos(@NomView^.NomViewLine.NVCode2,@NomView^)+1;
      KeyBuff[4].KeyLen:=10;
      KeyBuff[4].KeyFlags:=DupMod;


      { 02 - (RecPfix+SubType) +  Cat (NVCode3 NVCatK)  }                     { <<<<<<<<******** Change }

      KeyBuff[5].KeyPos:=1;
      KeyBuff[5].KeyLen:=2;
      KeyBuff[5].KeyFlags:=DupModSeg;

      KeyBuff[6].KeyPos:=BtKeyPos(@NomView^.NomViewLine.NVCode3,@NomView^)+1;
      KeyBuff[6].KeyLen:=20;
      KeyBuff[6].KeyFlags:=DupMod;

      { 03 - (RecPfix+SubType) +  Alt (NVCode4 NVAltK)  }                     { <<<<<<<<******** Change }

      KeyBuff[7].KeyPos:=1;
      KeyBuff[7].KeyLen:=2;
      KeyBuff[7].KeyFlags:=DupModSeg;

      KeyBuff[8].KeyPos:=BtKeyPos(@NomView^.NomViewLine.NVCode4,@NomView^)+1;
      KeyBuff[8].KeyLen:=60;
      KeyBuff[8].KeyFlags:=DupMod;


      { 04 - (RecPfix+SubType) + NomViewNo + Desc  (NVDescK)  }                     { <<<<<<<<******** Change }

      KeyBuff[9].KeyPos:=1;
      KeyBuff[9].KeyLen:=2;
      KeyBuff[9].KeyFlags:=DupModSeg+Mank;

      KeyBuff[10].KeyPos:=BtKeyPos(@NomView^.NomViewLine.NomViewNo,@NomView^);
      KeyBuff[10].KeyLen:=4;
      KeyBuff[10].KeyFlags:=DupModSeg+ExtType+Mank;
      KeyBuff[10].ExtTypeVal:=BInteger;

      KeyBuff[11].KeyPos:=BtKeyPos(@NomView^.NomViewLine.Desc,@NomView^)+1;
      KeyBuff[11].KeyLen:=100;
      KeyBuff[11].KeyFlags:=DupMod+Mank;



      AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

    end; {With..}
    FileRecLen[Idx]:=Sizeof(NomView^);                             { <<<<<<<<******** Change }

    Fillchar(NomView^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

    RecPtr[Idx]:=@NomView^;

    FileSpecOfs[Idx]:=@NomViewFile^;


    FileNames[Idx]:=Path2+NVNam;                         { <<<<<<<<******** Change }


  end; {..}
{$ENDIF}


Procedure DefineSys;

Const
  Idx = SysF;

Begin
  With SysFile do
  Begin
    FileSpecLen[Idx]:=Sizeof(SysFile);                      { <<<<<<<<******** Change }
    Fillchar(SysFile,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(Syss);                                  { <<<<<<<<******** Change }
      PageSize:=DefPageSize3;  // 2k
    NumIndex:=SNofKeys;                                      { <<<<<<<<******** Change }
    Variable:=1;

    { 00 - SysID (SysK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=03;
    KeyBuff[1].KeyFlags:=ModFy;


  end; {With..}
  FileRecLen[Idx]:=Sizeof(Syss);                             { <<<<<<<<******** Change }

  Fillchar(Syss,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Syss;

  FileSpecOfs[Idx]:=@SysFile;


  FileNames[Idx]:=PathSys;


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Syss: .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.:',FileSpecLen[Idx]:4);
      Writeln('Total...:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}

end; {..}



Procedure DefineRepScr;

Const
  Idx = ReportF;

Begin
  With RepFile^ do
  Begin
    FileSpecLen[Idx]:=Sizeof(RepFile^);                      { <<<<<<<<******** Change }
    Fillchar(RepFile^,FileSpecLen[Idx],0);                 { <<<<<<<<******** Change }
    RecLen:=Sizeof(RepScr^);                                  { <<<<<<<<******** Change }
    PageSize:=DefPageSize;
    NumIndex:=RpNofKeys;                                      { <<<<<<<<******** Change }

    Variable:=B_Variable+B_Compress+B_BTrunc; {* Used for max compression *}


    { 00 - (AccessK) (RpK)  }                     { <<<<<<<<******** Change }

    KeyBuff[1].KeyPos:=2;
    KeyBuff[1].KeyLen:=100;
    KeyBuff[1].KeyFlags:=DupMod;

    AltColt:=UpperALT;   { Definition for AutoConversion to UpperCase }

  end; {With..}

  FileRecLen[Idx]:=Sizeof(RepScr^);                             { <<<<<<<<******** Change }

  Fillchar(RepScr^,FileRecLen[Idx],0);                        { <<<<<<<<******** Change }

  RecPtr[Idx]:=@RepScr^;

  FileSpecOfs[Idx]:=@RepFile^;


  FileNames[Idx]:='';                         { <<<<<<<<******** Change }


  {$IFNDEF EXWIN}

    If (Debug) then
    Begin
      Writeln('Report File : .. ',FileRecLen[Idx]:4);
      Writeln('FileDef.....:',FileSpecLen[Idx]:4);
      Writeln('Total.......:',FileRecLen[Idx]+FileSpecLen[Idx]:4);
      Writeln;
    end;

  {$ENDIF}


end; {..}




  { ================== Procedure to Return Any Parameters ================= }

  Procedure GetBTParam;

  Var
    n  :  Word;


  Begin

    If (ParamCount>0) then
      For n:=1 to ParamCount do
      Begin

        If (Not AccelMode) then
          AccelMode:=(ParamStr(n)=AccelSwitch);

        If (Not RemDirOn) then
          If (ParamStr(n)=RemDirSwitch) then
          Begin

            RemDirOn:=BOn;

            SetDrive:=ParamStr(Succ(n));

            If (SetDrive[Length(SetDrive)]<>'\') then
              SetDrive:=SetDrive+'\';

            RemDirNo:=Ord(UpCase(SetDrive[1]))-64;

          end;

          If (ParamStr(n)=CoDirSwitch) and (ExMainCoPath <> Nil) then
          Begin

            ExMainCoPath^:=ParamStr(Succ(n));

            If (ExMainCoPath^[Length(SetDrive)]<>'\') then
              ExMainCoPath^:=ExMainCoPath^+'\';

          end;

        {$IFNDEF ENTRB}

          {$IFDEF EXWIN}

            If (Not JBFieldOn) then
              JBFieldOn:=(ParamStr(n)=JBFieldSwitch);

            If (Not SWInfoSOn) then
              SWInfoSOn:=(ParamStr(n)=CUInfoSSwitch);

            If (Not SWBentlyOn) then
              SWBentlyOn:=(ParamStr(n)=CUBentlySwitch);
          {$ENDIF}

          If (Not MUDelay2) then
            MUDelay2:=(ParamStr(n)=MUDelay2Switch);

          If (Not MUNoCheck) then
            MUNoCheck:=(ParamStr(n)=MUNoCheckSwitch);
        {$ENDIF}

      end; {Loop..}

  end; {Proc..}


{$IFDEF EXWIN}
  procedure BTDelay(dt  :  Word);

  Var
    ThTimeS,
    thTimeN   :  TDateTime;

    thGap     :  Double;

  Begin
    thTimeS:=Time;

    thGap:=dt/1e8;

    Repeat
      thTimeN:=Time-ThTimeS;

    Until (thTimeN>thgap);

  end;

{$ENDIF}



  { ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

  Function Checkfile_open(FileNo  :  Integer)  :  Boolean;


  Var
    n,
    TmpIO,
    IOChk         :  Integer;

    DelayLen      :  LongInt;

    {$IFNDEF EXWIN}
      Result      :  Boolean;
    {$ENDIF}


  Begin

    If (Check4BtrvOk) and (Not MUNoCheck) then
    Begin
      {$IFDEF EXSQL}
        If (Not SQLUtils.UsingSQL) Then   // NOTE: Put SQLUtils into VarConst
        Begin
      {$ENDIF} // EXSQL}
          TmpIO:=0;

          {* This delay was found to be necessary with the Novell32 Client (18/03/1997) when used in conjunction with the MCM
             If You selected a company via the MCM the exclusive check crashed btrieve with out this delay *}

          {$IFDEF EXWIN}
            {$IFNDEF ENTRB}
              DelayLen:=2000+(5000*Ord(MUDelay2));

              BTDelay(DelayLen);

            {$ENDIF}
          {$ENDIF}

          IOChk:=Open_File(F[FileNo],SetDrive+FileNames[FileNo],-4);

          If (IOChk=0) then
          Begin

            TmpIO:=Close_File(F[FileNo]);

          end;

          TmpIO:=Reset_B;

          Result:=(IOChk=0);
      {$IFDEF EXSQL}
        End // If (Not SQLUtils.UsingSQL)
        Else
        Begin
          // SQL - need to do Exclusive check differently - works on entire database not the file
          Result := ExclusiveAccess(SetDrive);
        End; // Else
      {$ENDIF} // EXSQL}
    end
    else
      Result:=BOff;

    {$IFNDEF EXWIN}
      Checkfile_open:=Result;
    {$ENDIF}

  end; {Func..}




{$IFNDEF EXWIN}



{$ELSE}


  Function NonFatalStatus(StatNo  :  Integer)  :  Boolean;


  Begin

    NonFatalStatus:=(StatNo=11) Or (StatNo=20) or (StatNo =35) or (StatNo=88)
                   or (StatNo=81) or (StatNo=85)  or (StatNo=86) or (StatNo=87) or
                   (StatNo=133);


  end;



  Procedure Open_System(Start,Fin  :  Integer);


  Const
    NoAttempts     =  100;   {* No of retries before giving up *}
  Var
    Choice,NoTrys,
    SetAccel,
    ForceLocal     :  Integer;
    mbRet        :  Word;

  Begin
     { =========== Set Accelrated mode ============ }

     mbRet:=0;

     SetAccel:=1*Ord(AccelMode);

     {$IFNDEF BCS}
       ForceLocal:=0;
     {$ELSE}

       {$IFDEF DBD}
         ForceLocal:=0;
       {$ELSE}
         ForceLocal:=0;
       {$ENDIF}

     {$ENDIF}

     { =========== Open Files ========== }
  {$I-}

      Choice:=Start; Ch:=ResetKey;

      NoTrys:=0;


        {* If (Not Check4BTrvOk) then  * Try Shelling Out and force load Btrieve
          JumpStart_Btrieve;           Won't work because heap too big..! use MUCDOS *}


      If (Check4BtrvOK) then
      While (Choice<=Fin) and (Ch<>#27) do
      Begin

        NoTrys:=0;

      Repeat
        Elded:=BOff;

        Status:=Open_File(F[Choice],SetDrive+FileNames[Choice],SetAccel+ForceLocal);


        If (Status <>0) and (NoTrys>NoAttempts) then
        Begin
          If (Debug) then Status_Means(Status);
          Elded:=BOff;

          mbRet:=MessageDlg('Error in File:'+FileNames[Choice]+' Type '+InttoStr(Status)+#13+
                            Set_StatMes(Status),mtInformation,[mbOk],0);


          If (Not NonFatalStatus(Status)) then
          Begin

            If (SBSIN) or (Debug) then
              mbRet:=MessageDlg('Create new file?',mtConfirmation,mbOkCancel,0)
            else
              mbRet:=IdCancel;

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

      Until (Elded) or (Ch=#27);

      Inc(Choice);

      end; {while..}

      If (Status<>0) then
      Begin
        mbRet:=MessageDlg('Unable to start Btrieve!'+#13+
                          'Error : '+InttoStr(Status),mtInformation,[mbOk],0);

        Halt;
      end;
      Elded:=BOff;
  end;




  { ============= Close All Open Files ============= }

  Procedure Close_Files(ByFile  :  Boolean);


  Var
    Choice  :  Byte;

    FSpec   : FileSpec;


  Begin

  {$I-}
    If (Debug) or (ByFile) or (ResetBtOnExit) then
    Begin
      For Choice:=1 to TotFiles do
      Begin
        {* Check file is open b4 closing it *}

        {$IFDEF EXSQL}
        // MH 05/11/2009: Modified to ignore BStat call in SQL Edition as was causing significant delay
        if SQLUtils.UsingSQLAlternateFuncs then
          Status := 0
        Else
        {$ENDIF}
          Status:=GetFileSpec(F[Choice],Choice,FSpec);

        If (StatusOk) then
          Status:=Close_File(F[Choice])
        else
          Status:=0;
      end;

      Status:=Reset_B;
    end
    else
      Status:=Stop_B;

    If (Debug) then
      Status_Means(Status);


    

    {$I+}
  end;


{$ENDIF}

