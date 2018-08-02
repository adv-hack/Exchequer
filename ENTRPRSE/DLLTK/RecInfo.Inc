


Function RecInfo(Const InfoNum : Word) : LongInt;
Var
  CU       : TBatchCURec;
  TH       : TBatchTHRec;
  TL       : TBatchTLRec;
  SB       : TSaleBandsRec;
  ST       : TBatchSKRec;
  HB       : THistoryBalRec;
  NM       : ^TBatchNomRec;
  BOM      : ^TBatchBOMRec;
  SR       : ^TBatchSRRec;
  JH       : ^TBatchJHRec;
  SL       : ^TBatchSLRec;
  ML       : ^TBatchMLocRec;
  MAT      : ^TBatchMatchRec;
  NOTE     : ^TBatchNotesRec;
  CC       : ^TBatchCCDepRec;
  SP       : ^TBatchStkPriceRec;
  VAT      : ^TBatchVATRec;
  Curr     : ^TBatchCurrRec;
  Sys      : ^TBatchSysRec;
  AB       : ^TBatchAutoBankRec;
  BomImp   : ^TBatchBOMImportRec;
  BatSer   : ^TBatchSerialRec;
  Empl     : ^TBatchEmplRec;
  JobAnal  : ^TBatchJobAnalRec;
  JobRate  : ^TBatchJobRateRec;
  JobType  : ^TBatchJobTypeRec;
  DiscRt   : ^TBatchDiscRec;
  SkAlt    : ^TBatchSKAltRec;
  TLArray  : ^TLArrayInfoType;
  ConvTC   : ^TBatchConvTCurr;
  EComms   : ^TSysECommsRec;
  DForm    : ^TDefaultFormRecType;
  Email    : ^TEmailPrintInfoType;
  VATDef   : ^TVATCodeDefaultType;
  EntInfo  : ^TEnterpriseInfoType;
  UserProf : ^TUserProfileType;
  LinkRec  : ^TBatchLinkRec;
  ConvRec  : ^TBatchConvRec;
  BinRec   : ^TBatchBinRec;
  MultiBuyRec
           : ^TBatchMultiBuyDiscount;
Begin
  New (NM);
  New (BOM);
  New (SR);
  New (JH);
  New (SL);
  New (ML);
  New (MAT);
  New (NOTE);
  New (CC);
  New (SP);
  New (VAT);
  New (Curr);
  New (Sys);
  New (AB);
  New (BomImp);
  New (BatSer);
  New (Empl);
  New (JobAnal);
  New (JobRate);
  New (DiscRt);
  New (SkAlt);
  New (TLArray);
  New (JobType);
  New (ConvTC);
  New (EComms);
  New (DForm);
  New (Email);
  New (VATDef);
  New (EntInfo);
  New (UserProf);
  New (LinkRec);
  New (ConvRec);
  New (BinRec);
  New (MultiBuyRec);

  Case InfoNum Of
    { Record Sizes }
    1    : Result := SizeOf(CU);
    2    : Result := SizeOf(TH);
    3    : Result := SizeOf(TBatchTLRec);
    4    : Result := SizeOf(TBatchLinesRec);
    5    : Result := SizeOf(TSaleBandsRec);
    6    : Result := SizeOf(TSaleBandAry);
    7    : Result := SizeOf(TBatchSKRec);
    8    : Result := SizeOf(THistoryBalRec);
    9    : Result := SizeOf(TBatchNomRec);
    10   : Result := SizeOf(TBatchBOMRec);
    11   : Result := SizeOf(TBatchBOMLinesRec);
    12   : Result := SizeOf(TBatchSRRec);
    13   : Result := SizeOf(TBatchSRLinesRec);
    14   : Result := SizeOf(TBatchJHRec);
    15   : Result := SizeOf(TBatchSLRec);
    16   : Result := SizeOf(TBatchMLocRec);
    17   : Result := SizeOf(TBatchMatchRec);
    18   : Result := SizeOf(TBatchNotesRec);
    19   : Result := SizeOf(TBatchCCDepRec);
    20   : Result := SizeOf(TBatchStkPriceRec);
    21   : Result := SizeOf(TBatchVATRec);
    22   : Result := SizeOf(TBatchCurrRec);
    23   : Result := SizeOf(TBatchSysRec);
    24   : Result := SizeOf(TBatchAutoBankRec);
    25   : Result := SizeOf(TBatchBOMImportRec);
    26   : Result := SizeOf(TBatchSerialRec);
    27   : Result := SizeOf(TBatchEmplRec);
    28   : Result := SizeOf(TBatchJobAnalRec);
    29   : Result := SizeOf(TBatchJobRateRec);
    30   : Result := SizeOf(TBatchJobTypeRec);
    31   : Result := SizeOf(TBatchDiscRec);
    32   : Result := SizeOf(TBatchSKAltRec);
    33   : Result := SizeOf(TLArrayInfoType);
    34   : Result := SizeOf(TBatchConvTCurr);
    35   : Result := SizeOf(TSysECommsRec);
    36   : Result := SizeOf(TDefaultFormRecType);
    37   : Result := SizeOf(TEmailPrintInfoType);
    38   : Result := SizeOf(TVATCodeDefaultType);
    39   : Result := SizeOf(TEnterpriseInfoType);
    40   : Result := SizeOf(TUserProfileType);
    41   : Result := SizeOf(TBatchLinkRec);
    42   : Result := SizeOf(TBatchConvRec);
    43   : Result := SizeOf(TBatchBinRec);
    44   : Result := SizeOf(TBatchMultiBuyDiscount);

    { TBatchCURec }
    100  : Result := CalcRecPos (@CU, @Cu.CustCode);
    101  : Result := CalcRecPos (@CU, @Cu.CustSupp);
    102  : Result := CalcRecPos (@CU, @Cu.Company);
    103  : Result := CalcRecPos (@CU, @Cu.AreaCode);
    104  : Result := CalcRecPos (@CU, @Cu.RepCode);
    105  : Result := CalcRecPos (@CU, @Cu.RemitCode);
    106  : Result := CalcRecPos (@CU, @Cu.VATRegNo);
    107  : Result := CalcRecPos (@CU, @Cu.Addr);
    108  : Result := CalcRecPos (@CU, @Cu.DespAddr);
    109  : Result := CalcRecPos (@CU, @Cu.DAddr);
    110  : Result := CalcRecPos (@CU, @Cu.Contact);
    111  : Result := CalcRecPos (@CU, @Cu.Phone);
    112  : Result := CalcRecPos (@CU, @Cu.Fax);
    113  : Result := CalcRecPos (@CU, @Cu.RefNo);
    114  : Result := CalcRecPos (@CU, @Cu.TradTerm);
    115  : Result := CalcRecPos (@CU, @Cu.STerms);
    116  : Result := CalcRecPos (@CU, @Cu.Currency);
    117  : Result := CalcRecPos (@CU, @Cu.VATCode);
    118  : Result := CalcRecPos (@CU, @Cu.PayTerms);
    119  : Result := CalcRecPos (@CU, @Cu.CreditLimit);
    120  : Result := CalcRecPos (@CU, @Cu.Discount);
    121  : Result := CalcRecPos (@CU, @Cu.CreditStatus);
    122  : Result := CalcRecPos (@CU, @Cu.CustCC);
    123  : Result := CalcRecPos (@CU, @Cu.CDiscCh);
    124  : Result := CalcRecPos (@CU, @Cu.CustDep);
    125  : Result := CalcRecPos (@CU, @Cu.EECMember);
    126  : Result := CalcRecPos (@CU, @Cu.IncStat);
    127  : Result := CalcRecPos (@CU, @Cu.DefNomCode);
    128  : Result := CalcRecPos (@CU, @Cu.DefMLocStk);
    129  : Result := CalcRecPos (@CU, @Cu.AccStatus);
    130  : Result := CalcRecPos (@CU, @Cu.PayType);
    131  : Result := CalcRecPos (@CU, @Cu.BankSort);
    132  : Result := CalcRecPos (@CU, @Cu.BankAcc);
    133  : Result := CalcRecPos (@CU, @Cu.BankRef);
    134  : Result := CalcRecPos (@CU, @Cu.LastUsed);
    135  : Result := CalcRecPos (@CU, @Cu.Phone2);
    136  : Result := CalcRecPos (@CU, @Cu.UserDef1);
    137  : Result := CalcRecPos (@CU, @Cu.UserDef2);
    138  : Result := CalcRecPos (@CU, @Cu.SOPInvCode);
    139  : Result := CalcRecPos (@CU, @Cu.SOPAutoWOff);
    140  : Result := CalcRecPos (@CU, @Cu.BOrdVal);
    141  : Result := CalcRecPos (@CU, @Cu.DefCOSNom);
    142  : Result := CalcRecPos (@CU, @Cu.DefCtrlNom);

    144  : Result := CalcRecPos (@CU, @Cu.PadChar1);
    145  : Result := CalcRecPos (@CU, @Cu.PadChar2);
    146  : Result := CalcRecPos (@CU, @Cu.PadChar3);

    148  : Result := CalcRecPos (@CU, @Cu.DirDeb);
    149  : Result := CalcRecPos (@CU, @Cu.CCDSDate);
    150  : Result := CalcRecPos (@CU, @Cu.CCDEDate);
    151  : Result := CalcRecPos (@CU, @Cu.CCDName);
    152  : Result := CalcRecPos (@CU, @Cu.CCDCardNo);
    153  : Result := CalcRecPos (@CU, @Cu.CCDSARef);
    154  : Result := CalcRecPos (@CU, @Cu.DefSetDDays);
    155  : Result := CalcRecPos (@CU, @Cu.DefSetDisc);
    156  : Result := CalcRecPos (@CU, @Cu.PadChar4);
    157  : Result := CalcRecPos (@CU, @Cu.DefFormNo);

    158  : Result := CalcRecPos (@CU, @Cu.StatDMode);
    159  : Result := CalcRecPos (@CU, @Cu.EMailAddr);
    160  : Result := CalcRecPos (@CU, @Cu.EmlSndRdr);
    161  : Result := CalcRecPos (@CU, @Cu.ebusPwrd);
    162  : Result := CalcRecPos (@CU, @Cu.PostCode);
    163  : Result := CalcRecPos (@CU, @Cu.CustCode2);
    164  : Result := CalcRecPos (@CU, @Cu.AllowWeb);
    165  : Result := CalcRecPos (@CU, @Cu.EmlZipAtc);
    166  : Result := CalcRecPos (@CU, @Cu.UserDef3);
    167  : Result := CalcRecPos (@CU, @Cu.UserDef4);
    168  : Result := CalcRecPos (@CU, @Cu.TimeChange);
    169  : Result := CalcRecPos (@CU, @Cu.SSDDelTerms);
    170  : Result := CalcRecPos (@CU, @Cu.CVATIncFlg);
    171  : Result := CalcRecPos (@CU, @Cu.SSDModeTr);
    172  : Result := CalcRecPos (@CU, @Cu.LastOpo);
    173  : Result := CalcRecPos (@CU, @Cu.InvDMode);
    174  : Result := CalcRecPos (@CU, @Cu.EmlSndHTML);

    143  : Result := CalcRecPos (@CU, @Cu.Spare);
    147  : Result := CalcRecPos (@CU, @Cu.LastChar);

    175  : Result := CalcRecPos (@CU, @Cu.PadChar5);
    176  : Result := CalcRecPos (@CU, @Cu.PadChar6);
    177  : Result := CalcRecPos (@CU, @Cu.PadChar7);
    178  : Result := CalcRecPos (@CU, @Cu.PadChar8);
    179  : Result := CalcRecPos (@CU, @Cu.PadChar9);
    180  : Result := CalcRecPos (@CU, @Cu.WebLiveCat);
    181  : Result := CalcRecPos (@CU, @Cu.WebPrevCat);
    182  : Result := CalcRecPos (@CU, @Cu.SOPConsHO);

    183  : Result := CalcRecPos (@CU, @Cu.EmlUseEDZ);

    184  : Result := CalcRecPos (@CU, @Cu.DefTagNo);
    185  : Result := CalcRecPos (@CU, @Cu.OrderConsMode);

    //PR: 21/10/2011 v6.9
    186  : Result := CalcRecPos (@CU, @Cu.UserDef5);
    187  : Result := CalcRecPos (@CU, @Cu.UserDef6);
    188  : Result := CalcRecPos (@CU, @Cu.UserDef7);
    189  : Result := CalcRecPos (@CU, @Cu.UserDef8);
    190  : Result := CalcRecPos (@CU, @Cu.UserDef9);
    191  : Result := CalcRecPos (@CU, @Cu.UserDef10);
    192  : Result := CalcRecPos (@CU, @Cu.acDeliveryPostcode);
    193  : Result := CalcRecPos (@CU, @Cu.acSubType);
    194  : Result := CalcRecPos (@CU, @Cu.acLongACCode);
    195  : Result := CalcRecPos (@CU, @Cu.acPPDMode);
    196  : Result := CalcRecPos (@CU, @Cu.acCountry);
    197  : Result := CalcRecPos (@CU, @Cu.acDeliveryCountry);


    { TBatchTHRec }
    200  : Result := CalcRecPos (@TH, @Th.RunNo);
    201  : Result := CalcRecPos (@TH, @Th.CustCode);
    202  : Result := CalcRecPos (@TH, @Th.OurRef);
    203  : Result := CalcRecPos (@TH, @Th.FolioNum);
    204  : Result := CalcRecPos (@TH, @Th.Currency);
    205  : Result := CalcRecPos (@TH, @Th.AcYr);
    206  : Result := CalcRecPos (@TH, @Th.AcPr);
    207  : Result := CalcRecPos (@TH, @Th.DueDate);
    208  : Result := CalcRecPos (@TH, @Th.TransDate);
    209  : Result := CalcRecPos (@TH, @Th.CoRate);
    210  : Result := CalcRecPos (@TH, @Th.VATRate);
    211  : Result := CalcRecPos (@TH, @Th.OldYourRef);
    212  : Result := CalcRecPos (@TH, @Th.LongYrRef);
    213  : Result := CalcRecPos (@TH, @Th.LineCount);
    214  : Result := CalcRecPos (@TH, @Th.TransDocHed);
    215  : Result := CalcRecPos (@TH, @Th.InvVatAnal);
    216  : Result := CalcRecPos (@TH, @Th.InvNetVal);
    217  : Result := CalcRecPos (@TH, @Th.InvVat);
    218  : Result := CalcRecPos (@TH, @Th.DiscSetl);
    219  : Result := CalcRecPos (@TH, @Th.DiscSetAm);
    220  : Result := CalcRecPos (@TH, @Th.DiscAmount);
    221  : Result := CalcRecPos (@TH, @Th.DiscDays);
    222  : Result := CalcRecPos (@TH, @Th.DiscTaken);
    223  : Result := CalcRecPos (@TH, @Th.Settled);
    224  : Result := CalcRecPos (@TH, @Th.TransNat);
    225  : Result := CalcRecPos (@TH, @Th.TransMode);
    226  : Result := CalcRecPos (@TH, @Th.HoldFlg);
    227  : Result := CalcRecPos (@TH, @Th.TotalWeight);
    228  : Result := CalcRecPos (@TH, @Th.DAddr);
    229  : Result := CalcRecPos (@TH, @Th.TotalCost);
    230  : Result := CalcRecPos (@TH, @Th.PrintedDoc);
    231  : Result := CalcRecPos (@TH, @Th.ManVAT);
    232  : Result := CalcRecPos (@TH, @Th.DelTerms);
    233  : Result := CalcRecPos (@TH, @Th.OpName);
    234  : Result := CalcRecPos (@TH, @Th.DJobCode);
    235  : Result := CalcRecPos (@TH, @Th.DJobAnal);
    236  : Result := CalcRecPos (@TH, @Th.TotOrdOS);
    237  : Result := CalcRecPos (@TH, @Th.DocUser1);
    238  : Result := CalcRecPos (@TH, @Th.DocUser2);
    239  : Result := CalcRecPos (@TH, @Th.EmpCode);
    240  : Result := CalcRecPos (@TH, @Th.Spare);
    241  : Result := CalcRecPos (@TH, @Th.PadChar1);
    242  : Result := CalcRecPos (@TH, @Th.PadChar2);
    243  : Result := CalcRecPos (@TH, @Th.PadChar3);
    244  : Result := CalcRecPos (@TH, @Th.PadChar4);
    245  : Result := CalcRecPos (@TH, @Th.LastChar);
    246  : Result := CalcRecPos (@TH, @Th.Tagged);
    247  : Result := CalcRecPos (@TH, @Th.thNoLabels);
    248  : Result := CalcRecPos (@TH, @Th.PadChar6);
    249  : Result := CalcRecPos (@TH, @Th.CtrlNom);

    250  : Result := CalcRecPos (@TH, @Th.DocUser3);
    251  : Result := CalcRecPos (@TH, @Th.DocUser4);
    252  : Result := CalcRecPos (@TH, @Th.SSDProcess);
    253  : Result := CalcRecPos (@TH, @Th.ExtSource);
    254  : Result := CalcRecPos (@TH, @Th.PostDate);
    255  : Result := CalcRecPos (@TH, @Th.PORPickSOR);
    256  : Result := CalcRecPos (@TH, @Th.BDiscount);
    257  : Result := CalcRecPos (@TH, @Th.PrePostFlg);
    258  : Result := CalcRecPos (@TH, @Th.PadChar7);
    259  : Result := CalcRecPos (@TH, @Th.PadChar8);
    260  : Result := CalcRecPos (@TH, @Th.PadChar9);
    261  : Result := CalcRecPos (@TH, @Th.AllocStat);
    262  : Result := CalcRecPos (@TH, @Th.PadChar10);
    263  : Result := CalcRecPos (@TH, @Th.SOPKeepRate);
    264  : Result := CalcRecPos (@TH, @Th.TimeCreate);
    265  : Result := CalcRecPos (@TH, @Th.TimeChange);
    266  : Result := CalcRecPos (@TH, @Th.CISTax);
    267  : Result := CalcRecPos (@TH, @Th.CISDeclared);
    268  : Result := CalcRecPos (@TH, @Th.CISManualTax);
    269  : Result := CalcRecPos (@TH, @Th.CISDate);
    270  : Result := CalcRecPos (@TH, @Th.TotalCost2);
    271  : Result := CalcRecPos (@TH, @Th.CISEmpl);
    272  : Result := CalcRecPos (@TH, @Th.CISGross);
    273  : Result := CalcRecPos (@TH, @Th.CISHolder);
    274  : Result := CalcRecPos (@TH, @Th.NomVatIO);

    275  : Result := CalcRecPos (@TH, @Th.AutoInc);
    276  : Result := CalcRecPos (@TH, @Th.AutoIncBy);
    277  : Result := CalcRecPos (@TH, @Th.AutoEndDate);
    278  : Result := CalcRecPos (@TH, @Th.AutoEndPr);
    279  : Result := CalcRecPos (@TH, @Th.AutoEndYr);
    280  : Result := CalcRecPos (@TH, @Th.AutoPost);
    281  : Result := CalcRecPos (@TH, @Th.thAutoTransaction);
    282  : Result := CalcRecPos (@TH, @Th.thDeliveryRunNo);
    283  : Result := CalcRecPos (@TH, @Th.thExternal);
    284  : Result := CalcRecPos (@TH, @Th.thSettledVAT);
    285  : Result := CalcRecPos (@TH, @Th.thVATClaimed);
    286  : Result := CalcRecPos (@TH, @Th.thPickingRunNo);
    287  : Result := CalcRecPos (@TH, @Th.thDeliveryNoteRef);
    288  : Result := CalcRecPos (@TH, @Th.thVATCompanyRate);
    289  : Result := CalcRecPos (@TH, @Th.thVATDailyRate);
    290  : Result := CalcRecPos (@TH, @Th.thPostCompanyRate);
    291  : Result := CalcRecPos (@TH, @Th.thPostDailyRate);
    292  : Result := CalcRecPos (@TH, @Th.thPostDiscAmount);
    293  : Result := CalcRecPos (@TH, @Th.thPostDiscTaken);
    294  : Result := CalcRecPos (@TH, @Th.thLastDebtChaseLetter);
    295  : Result := CalcRecPos (@TH, @Th.thRevaluationAdjustment);
    296  : Result := CalcRecPos (@TH, @Th.YourRef);
    297  : Result := CalcRecPos (@TH, @Th.thWeekMonth);
    298  : Result := CalcRecPos (@TH, @Th.thWorkflowState);
    299  : Result := CalcRecPos (@TH, @Th.thOverrideLocation);

   4700  : Result := CalcRecPos (@TH, @Th.DocUser5);
   4701  : Result := CalcRecPos (@TH, @Th.DocUser6);
   4702  : Result := CalcRecPos (@TH, @Th.DocUser7);
   4703  : Result := CalcRecPos (@TH, @Th.DocUser8);
   4704  : Result := CalcRecPos (@TH, @Th.DocUser9);
   4705  : Result := CalcRecPos (@TH, @Th.DocUser10);
   4706  : Result := CalcRecPos (@TH, @Th.thDeliveryPostcode);
   4707  : Result := CalcRecPos (@TH, @Th.thOriginator);
   4708  : Result := CalcRecPos (@TH, @Th.thCreationTime);
   4709  : Result := CalcRecPos (@TH, @Th.thCreationDate);

   4710  : Result := CalcRecPos (@TH, @Th.thPPDPercentage);
   4711  : Result := CalcRecPos (@TH, @Th.thPPDDays);
   4712  : Result := CalcRecPos (@TH, @Th.thPPDGoodsValue);
   4713  : Result := CalcRecPos (@TH, @Th.thPPDVATValue);
   4714  : Result := CalcRecPos (@TH, @Th.thPPDTaken);
   4715  : Result := CalcRecPos (@TH, @Th.thDeliveryCountry);
   4716  : Result := CalcRecPos (@TH, @Th.thIntrastatOutOfPeriod);
   4717  : Result := CalcRecPos (@TH, @Th.DocUser11);
   4718  : Result := CalcRecPos (@TH, @Th.DocUser12);


    { TBatchTLRec }
    300  : Result := CalcRecPos (@TL, @TL.TransRefNo);
    301  : Result := CalcRecPos (@TL, @TL.LineNo);
    302  : Result := CalcRecPos (@TL, @TL.NomCode);
    303  : Result := CalcRecPos (@TL, @TL.Currency);
    304  : Result := CalcRecPos (@TL, @TL.CoRate);
    305  : Result := CalcRecPos (@TL, @TL.VATRate);
    306  : Result := CalcRecPos (@TL, @TL.CC);
    307  : Result := CalcRecPos (@TL, @TL.Dep);
    308  : Result := CalcRecPos (@TL, @TL.StockCode);
    309  : Result := CalcRecPos (@TL, @TL.Qty);
    310  : Result := CalcRecPos (@TL, @TL.QtyMul);
    311  : Result := CalcRecPos (@TL, @TL.NetValue);
    312  : Result := CalcRecPos (@TL, @TL.Discount);
    313  : Result := CalcRecPos (@TL, @TL.VATCode);
    314  : Result := CalcRecPos (@TL, @TL.VAT);
    315  : Result := CalcRecPos (@TL, @TL.Payment);
    316  : Result := CalcRecPos (@TL, @TL.DiscountChr);
    317  : Result := CalcRecPos (@TL, @TL.QtyWOFF);
    318  : Result := CalcRecPos (@TL, @TL.QtyDel);
    319  : Result := CalcRecPos (@TL, @TL.CostPrice);
    320  : Result := CalcRecPos (@TL, @TL.CustCode);
    321  : Result := CalcRecPos (@TL, @TL.LineDate);
    322  : Result := CalcRecPos (@TL, @TL.Item);
    323  : Result := CalcRecPos (@TL, @TL.Desc);
    324  : Result := CalcRecPos (@TL, @TL.LWeight);
    325  : Result := CalcRecPos (@TL, @TL.MLocStk);
    326  : Result := CalcRecPos (@TL, @TL.JobCode);
    327  : Result := CalcRecPos (@TL, @TL.AnalCode);
    328  : Result := CalcRecPos (@TL, @TL.TSHCCurr);
    329  : Result := CalcRecPos (@TL, @TL.Spare);
    330  : Result := CalcRecPos (@TL, @TL.PadChar1);
    331  : Result := CalcRecPos (@TL, @TL.PadChar2);
    332  : Result := CalcRecPos (@TL, @TL.PadChar3);
    333  : Result := CalcRecPos (@TL, @TL.PadChar4);
    334  : Result := CalcRecPos (@TL, @TL.PadChar5);
    335  : Result := CalcRecPos (@TL, @TL.LastChar);
    336  : Result := CalcRecPos (@TL, @TL.DocLTLink);
    337  : Result := CalcRecPos (@TL, @TL.KitLink);
    338  : Result := CalcRecPos (@TL, @TL.FolioNum);
    339  : Result := CalcRecPos (@TL, @TL.LineType);
    340  : Result := CalcRecPos (@TL, @TL.Reconcile);
    341  : Result := CalcRecPos (@TL, @TL.Spare2);
    342  : Result := CalcRecPos (@TL, @TL.SOPLink);
    343  : Result := CalcRecPos (@TL, @TL.SOPLineNo);
    344  : Result := CalcRecPos (@TL, @TL.ABSLineNo);

    345  : Result := CalcRecPos (@TL, @TL.LineUser1);
    346  : Result := CalcRecPos (@TL, @TL.LineUser2);
    347  : Result := CalcRecPos (@TL, @TL.LineUser3);
    348  : Result := CalcRecPos (@TL, @TL.LineUser4);
    349  : Result := CalcRecPos (@TL, @TL.SSDUpLift);
    350  : Result := CalcRecPos (@TL, @TL.SSDCommod);
    351  : Result := CalcRecPos (@TL, @TL.SSDSPUnit);
    352  : Result := CalcRecPos (@TL, @TL.SSDUseLine);
    353  : Result := CalcRecPos (@TL, @TL.PriceMulx);
    354  : Result := CalcRecPos (@TL, @TL.PadChar7);
    355  : Result := CalcRecPos (@TL, @TL.PadChar8);

    356  : Result := CalcRecPos (@TL, @TL.VATIncFlg);
    357  : Result := CalcRecPos (@TL, @TL.QtyPick);
    358  : Result := CalcRecPos (@TL, @TL.QtyPWOff);
    359  : Result := CalcRecPos (@TL, @TL.PadChar9);
    360  : Result := CalcRecPos (@TL, @TL.PadChar10);
    361  : Result := CalcRecPos (@TL, @TL.RtnErrCode);
    362  : Result := CalcRecPos (@TL, @TL.SSDCountry);
    363  : Result := CalcRecPos (@TL, @TL.IncNetValue);
    364  : Result := CalcRecPos (@TL, @TL.AutoLineType);
    365  : Result := CalcRecPos (@TL, @TL.CISRateCode);
    366  : Result := CalcRecPos (@TL, @TL.CISRate);
    367  : Result := CalcRecPos (@TL, @TL.CostApport);
    368  : Result := CalcRecPos (@TL, @TL.NomVatType);
    369  : Result := CalcRecPos (@TL, @TL.BinQty);

    370  : Result := CalcRecPos (@TL, @TL.tlAltStockFolio);
    371  : Result := CalcRecPos (@TL, @TL.tlRunNo);
    372  : Result := CalcRecPos (@TL, @TL.tlStockDeductQty);
    373  : Result := CalcRecPos (@TL, @TL.tlUseQtyMul);
    374  : Result := CalcRecPos (@TL, @TL.tlSerialQty);
    375  : Result := CalcRecPos (@TL, @TL.tlPriceByPack);
    376  : Result := CalcRecPos (@TL, @TL.tlReconciliationDate);
    377  : Result := CalcRecPos (@TL, @TL.tlB2BLinkFolio);
    378  : Result := CalcRecPos (@TL, @TL.tlB2BLineNo);
    379  : Result := CalcRecPos (@TL, @TL.tlCOSDailyRate);
    380  : Result := CalcRecPos (@TL, @TL.tlQtyPack);

    381  : Result := CalcRecPos (@TL, @TL.tlMultiBuyDiscount);
    382  : Result := CalcRecPos (@TL, @TL.PadChar19);
    383  : Result := CalcRecPos (@TL, @TL.tlMultiBuyDiscountChr);
    384  : Result := CalcRecPos (@TL, @TL.tlTransValueDiscount);
    385  : Result := CalcRecPos (@TL, @TL.PadChar20);
    386  : Result := CalcRecPos (@TL, @TL.tlTransValueDiscountChr);
    387  : Result := CalcRecPos (@TL, @TL.tlTransValueDiscountType);

    388  : Result := CalcRecPos (@TL, @TL.tlECService);
    389  : Result := CalcRecPos (@TL, @TL.tlECServiceStartDate);
    390  : Result := CalcRecPos (@TL, @TL.tlECServiceEndDate);
    391  : Result := CalcRecPos (@TL, @TL.tlECSalesTaxReported);
    392  : Result := CalcRecPos (@TL, @TL.tlECPurchaseServiceTax);
    393  : Result := CalcRecPos (@TL, @TL.tlReference);
    394  : Result := CalcRecPos (@TL, @TL.tlReceiptNo);
    395  : Result := CalcRecPos (@TL, @TL.tlFromPostCode);
    396  : Result := CalcRecPos (@TL, @TL.tlToPostCode);
    397  : Result := CalcRecPos (@TL, @TL.tlIntrastatNoTC);

    { TSaleBandsRec }
    500  : Result := CalcRecPos (@SB, @SB.Currency);
    501  : Result := CalcRecPos (@SB, @SB.PadChar1);
    502  : Result := CalcRecPos (@SB, @SB.SalesPrice);
    503  : Result := CalcRecPos (@SB, @SB.PadChar2);
    504  : Result := CalcRecPos (@SB, @SB.LastChar);
    505  : Result := CalcRecPos (@SB, @SB.Spare);

    { TBatchSKRec }
    700  : Result := CalcRecPos (@ST, @ST.StockCode);
    701  : Result := CalcRecPos (@ST, @ST.Desc);
    702  : Result := CalcRecPos (@ST, @ST.AltCode);
    703  : Result := CalcRecPos (@ST, @ST.SuppTemp);
    704  : Result := CalcRecPos (@ST, @ST.NomCodeS);
    705  : Result := CalcRecPos (@ST, @ST.MinFlg);
    706  : Result := CalcRecPos (@ST, @ST.StockFolio);
    707  : Result := CalcRecPos (@ST, @ST.StockCat);
    708  : Result := CalcRecPos (@ST, @ST.StockType);
    709  : Result := CalcRecPos (@ST, @ST.UnitK);
    710  : Result := CalcRecPos (@ST, @ST.UnitS);
    711  : Result := CalcRecPos (@ST, @ST.UnitP);
    712  : Result := CalcRecPos (@ST, @ST.PCurrency);
    713  : Result := CalcRecPos (@ST, @ST.CostPrice);
    714  : Result := CalcRecPos (@ST, @ST.SaleBands);
    715  : Result := CalcRecPos (@ST, @ST.SellUnit);
    716  : Result := CalcRecPos (@ST, @ST.BuyUnit);
    717  : Result := CalcRecPos (@ST, @ST.VATCode);
    718  : Result := CalcRecPos (@ST, @ST.CC);
    719  : Result := CalcRecPos (@ST, @ST.Dep);
    720  : Result := CalcRecPos (@ST, @ST.QtyInStock);
    721  : Result := CalcRecPos (@ST, @ST.QtyPosted);
    722  : Result := CalcRecPos (@ST, @ST.QtyAllocated);
    723  : Result := CalcRecPos (@ST, @ST.QtyOnOrder);
    724  : Result := CalcRecPos (@ST, @ST.QtyMin);
    725  : Result := CalcRecPos (@ST, @ST.QtyMax);
    726  : Result := CalcRecPos (@ST, @ST.ROQty);
    727  : Result := CalcRecPos (@ST, @ST.CommodCode);
    728  : Result := CalcRecPos (@ST, @ST.SWeight);
    729  : Result := CalcRecPos (@ST, @ST.PWeight);
    730  : Result := CalcRecPos (@ST, @ST.UnitSupp);
    731  : Result := CalcRecPos (@ST, @ST.SuppSUnit);
    732  : Result := CalcRecPos (@ST, @ST.BinLoc);
    733  : Result := CalcRecPos (@ST, @ST.CovPr);
    735  : Result := CalcRecPos (@ST, @ST.CovPrUnit);
    736  : Result := CalcRecPos (@ST, @ST.CovMinPr);
    737  : Result := CalcRecPos (@ST, @ST.CovMinUnit);
    738  : Result := CalcRecPos (@ST, @ST.Supplier);
    739  : Result := CalcRecPos (@ST, @ST.CovSold);
    740  : Result := CalcRecPos (@ST, @ST.UseCover);
    741  : Result := CalcRecPos (@ST, @ST.CovMaxPr);
    742  : Result := CalcRecPos (@ST, @ST.CovMaxUnit);
    743  : Result := CalcRecPos (@ST, @ST.ROCurrency);
    744  : Result := CalcRecPos (@ST, @ST.ROCPrice);
    745  : Result := CalcRecPos (@ST, @ST.RODate);
    746  : Result := CalcRecPos (@ST, @ST.StkValType);
    747  : Result := CalcRecPos (@ST, @ST.QtyPicked);
    748  : Result := CalcRecPos (@ST, @ST.LastUsed);
    749  : Result := CalcRecPos (@ST, @ST.StBarCode);
    750  : Result := CalcRecPos (@ST, @ST.StRoCostCentre);
    751  : Result := CalcRecPos (@ST, @ST.StRoDepartment);
    752  : Result := CalcRecPos (@ST, @ST.StLocation);
    753  : Result := CalcRecPos (@ST, @ST.StPricePack);
    754  : Result := CalcRecPos (@ST, @ST.StDPackQty);
    755  : Result := CalcRecPos (@ST, @ST.StKitPrice);
    756  : Result := CalcRecPos (@ST, @ST.StKitOnPurch);
    757  : Result := CalcRecPos (@ST, @ST.StStkUser1);
    758  : Result := CalcRecPos (@ST, @ST.StStkUser2);
    759  : Result := CalcRecPos (@ST, @ST.PadChar1);
    760  : Result := CalcRecPos (@ST, @ST.PadChar2);
    761  : Result := CalcRecPos (@ST, @ST.PadChar3);
    762  : Result := CalcRecPos (@ST, @ST.PadChar4);
    763  : Result := CalcRecPos (@ST, @ST.PadChar5);
    764  : Result := CalcRecPos (@ST, @ST.PadChar6);
    765  : Result := CalcRecPos (@ST, @ST.PadChar7);
    766  : Result := CalcRecPos (@ST, @ST.PadChar8);
    767  : Result := CalcRecPos (@ST, @ST.PadChar9);
    769  : Result := CalcRecPos (@ST, @ST.LastChar);

    770  : Result := CalcRecPos (@ST, @ST.JAnalCode);
    771  : Result := CalcRecPos (@ST, @ST.WebInclude);
    772  : Result := CalcRecPos (@ST, @ST.WebLiveCat);
    773  : Result := CalcRecPos (@ST, @ST.StkUser3);
    774  : Result := CalcRecPos (@ST, @ST.StkUser4);
    775  : Result := CalcRecPos (@ST, @ST.SerNoWAvg);
    776  : Result := CalcRecPos (@ST, @ST.SSDDUplift);
    777  : Result := CalcRecPos (@ST, @ST.TimeChange);
    778  : Result := CalcRecPos (@ST, @ST.SVATIncFlg);
    779  : Result := CalcRecPos (@ST, @ST.LastOpo);
    780  : Result := CalcRecPos (@ST, @ST.ImageFile);
    781  : Result := CalcRecPos (@ST, @ST.PadChar11);
    782  : Result := CalcRecPos (@ST, @ST.PadChar12);
    783  : Result := CalcRecPos (@ST, @ST.WebPrevCat);
    784  : Result := CalcRecPos (@ST, @ST.PadChar13);
    785  : Result := CalcRecPos (@ST, @ST.SSDCountry);
    786  : Result := CalcRecPos (@ST, @ST.Spare);
    787  : Result := CalcRecPos (@ST, @ST.PadChar13);
    788  : Result := CalcRecPos (@ST, @ST.StkLinkLT);
    789  : Result := CalcRecPos (@ST, @ST.PriceByStkUnit);
    790  : Result := CalcRecPos (@ST, @ST.ShowAsKit);
    791  : Result := CalcRecPos (@ST, @ST.QtyPickWOR);
    792  : Result := CalcRecPos (@ST, @ST.UsesBins);
    793  : Result := CalcRecPos (@ST, @ST.SSDAUplift);
    794  : Result := CalcRecPos (@ST, @ST.BOMProdTime);
    795  : Result := CalcRecPos (@ST, @ST.WOPProdTimeDays);
    796  : Result := CalcRecPos (@ST, @ST.WOPProdTimeHours);
    797  : Result := CalcRecPos (@ST, @ST.WOPProdTimeMins);
    798  : Result := CalcRecPos (@ST, @ST.WOPLeadTime);
    799  : Result := CalcRecPos (@ST, @ST.WOPCalcProdTime);
   4600  : Result := CalcRecPos (@ST, @ST.WOPMinEcQty);
   4601  : Result := CalcRecPos (@ST, @ST.WOPIssuedWIPGL);
   4602  : Result := CalcRecPos (@ST, @ST.QtyAllocWOR);
   4603  : Result := CalcRecPos (@ST, @ST.QtyIssueWOR);
   4604  : Result := CalcRecPos (@ST, @ST.WOPMinEcQty);
   4605  : Result := CalcRecPos (@ST, @ST.QtyStockTake);
   4606  : Result := CalcRecPos (@ST, @ST.QtyStockTakeChanged);
   4607  : Result := CalcRecPos (@ST, @ST.QtyFreeze);
   4608  : Result := CalcRecPos (@ST, @ST.BinLoc10);

   //PR: 21/10/2011 v6.9
   4609  : Result := CalcRecPos (@ST, @ST.StkUser5);
   4610  : Result := CalcRecPos (@ST, @ST.StkUser6);
   4611  : Result := CalcRecPos (@ST, @ST.StkUser7);
   4612  : Result := CalcRecPos (@ST, @ST.StkUser8);
   4613  : Result := CalcRecPos (@ST, @ST.StkUser9);
   4614  : Result := CalcRecPos (@ST, @ST.StkUser10);

    { THistoryBalRec }
    800  : Result := CalcRecPos (@HB, @HB.Period);
    801  : Result := CalcRecPos (@HB, @HB.Year);
    802  : Result := CalcRecPos (@HB, @HB.Currency);
    803  : Result := CalcRecPos (@HB, @HB.Value);
    804  : Result := CalcRecPos (@HB, @HB.PadChar1);
    805  : Result := CalcRecPos (@HB, @HB.PadChar2);
    806  : Result := CalcRecPos (@HB, @HB.LastChar);
    807  : Result := CalcRecPos (@HB, @HB.CommitVal);
    808  : Result := CalcRecPos (@HB, @HB.PadChar3);
    809  : Result := CalcRecPos (@HB, @HB.PadChar4);


    { TBatchNomRec }
    900  : Result := CalcRecPos (@NM^, @NM.NomCode);
    901  : Result := CalcRecPos (@NM^, @NM.Desc);
    902  : Result := CalcRecPos (@NM^, @NM.Cat);
    903  : Result := CalcRecPos (@NM^, @NM.NomType);
    904  : Result := CalcRecPos (@NM^, @NM.NomPage);
    905  : Result := CalcRecPos (@NM^, @NM.SubType);
    906  : Result := CalcRecPos (@NM^, @NM.Total);
    907  : Result := CalcRecPos (@NM^, @NM.CarryF);
    908  : Result := CalcRecPos (@NM^, @NM.ReValue);

    909  : Result := CalcRecPos (@NM^, @NM.LastChar);
    910  : Result := CalcRecPos (@NM^, @NM.PadChar1);
    911  : Result := CalcRecPos (@NM^, @NM.PadChar2);
    912  : Result := CalcRecPos (@NM^, @NM.PadChar3);

    913  : Result := CalcRecPos (@NM^, @NM.AltCode);
    914  : Result := CalcRecPos (@NM^, @NM.DefCurr);
    915  : Result := CalcRecPos (@NM^, @NM.PadChar4);
    916  : Result := CalcRecPos (@NM^, @NM.Spare);
    917  : Result := CalcRecPos (@NM^, @NM.Inactive);
    918  : Result := CalcRecPos (@NM^, @NM.LongDesc);

    { TBatchBOMRec }
    1000 : Result := CalcRecPos (@BOM^, @BOM.StockCode);
    1001 : Result := CalcRecPos (@BOM^, @BOM.QtyUsed);
    1002 : Result := CalcRecPos (@BOM^, @BOM.QtyCost);
    1003 : Result := CalcRecPos (@BOM^, @BOM.PadChar1);
    1004 : Result := CalcRecPos (@BOM^, @BOM.PadChar2);
    1005 : Result := CalcRecPos (@BOM^, @BOM.LastChar);

    { TBatchSRRec }
    1200 : Result := CalcRecPos (@SR^, @SR.SerialNo);
    1201 : Result := CalcRecPos (@SR^, @SR.BatchNo);
    1202 : Result := CalcRecPos (@SR^, @SR.DateOut);
    1203 : Result := CalcRecPos (@SR^, @SR.SerCost);
    1204 : Result := CalcRecPos (@SR^, @SR.SerSell);
    1205 : Result := CalcRecPos (@SR^, @SR.CurCost);
    1206 : Result := CalcRecPos (@SR^, @SR.CurSell);
    1207 : Result := CalcRecPos (@SR^, @SR.InMLoc);
    1208 : Result := CalcRecPos (@SR^, @SR.OutMLoc);
    1209 : Result := CalcRecPos (@SR^, @SR.BuyQty);
    1210 : Result := CalcRecPos (@SR^, @SR.QtyUsed);
    1211 : Result := CalcRecPos (@SR^, @SR.Sold);
    1212 : Result := CalcRecPos (@SR^, @SR.PadChar1);
    1213 : Result := CalcRecPos (@SR^, @SR.PadChar2);
    1214 : Result := CalcRecPos (@SR^, @SR.LastChar);
    1215 : Result := CalcRecPos (@SR^, @SR.PadChar3);

    { TBatchJHRec }
    1400 : Result := CalcRecPos (@JH^, @JH.JobCode);
    1401 : Result := CalcRecPos (@JH^, @JH.JobDesc);
    1402 : Result := CalcRecPos (@JH^, @JH.JobFolio);
    1403 : Result := CalcRecPos (@JH^, @JH.CustCode);
    1404 : Result := CalcRecPos (@JH^, @JH.JobCat);
    1405 : Result := CalcRecPos (@JH^, @JH.JobAltCode);
    1406 : Result := CalcRecPos (@JH^, @JH.Completed);
    1407 : Result := CalcRecPos (@JH^, @JH.Contact);
    1408 : Result := CalcRecPos (@JH^, @JH.JobMan);
    1409 : Result := CalcRecPos (@JH^, @JH.ChargeType);
    1410 : Result := CalcRecPos (@JH^, @JH.QuotePrice);
    1411 : Result := CalcRecPos (@JH^, @JH.CurrPrice);
    1412 : Result := CalcRecPos (@JH^, @JH.StartDate);
    1413 : Result := CalcRecPos (@JH^, @JH.EndDate);
    1414 : Result := CalcRecPos (@JH^, @JH.RevEDate);
    1415 : Result := CalcRecPos (@JH^, @JH.SORRef);
    1416 : Result := CalcRecPos (@JH^, @JH.VATCode);
    1417 : Result := CalcRecPos (@JH^, @JH.JobAnal);
    1418 : Result := CalcRecPos (@JH^, @JH.JobType);
    1419 : Result := CalcRecPos (@JH^, @JH.JobStat);
    1420 : Result := CalcRecPos (@JH^, @JH.PadChar1);
    1421 : Result := CalcRecPos (@JH^, @JH.PadChar2);
    1422 : Result := CalcRecPos (@JH^, @JH.LastChar);
    1423 : Result := CalcRecPos (@JH^, @JH.UserDef1);
    1424 : Result := CalcRecPos (@JH^, @JH.UserDef2);

    1425 : Result := CalcRecPos (@JH^, @JH.UserDef3);
    1426 : Result := CalcRecPos (@JH^, @JH.UserDef4);
    1427 : Result := CalcRecPos (@JH^, @JH.UserDef5);
    1428 : Result := CalcRecPos (@JH^, @JH.UserDef6);
    1429 : Result := CalcRecPos (@JH^, @JH.UserDef7);
    1430 : Result := CalcRecPos (@JH^, @JH.UserDef8);
    1431 : Result := CalcRecPos (@JH^, @JH.UserDef9);
    1432 : Result := CalcRecPos (@JH^, @JH.UserDef10);

    1433 : Result := CalcRecPos (@JH^, @JH.jrCostCentre);
    1434 : Result := CalcRecPos (@JH^, @JH.jrDepartment);

    { TBatchSLRec }
    1500 : Result := CalcRecPos (@SL^, @SL.lsStkCode);
    1501 : Result := CalcRecPos (@SL^, @SL.lsLocCode);
    1502 : Result := CalcRecPos (@SL^, @SL.lsQtyInStock);
    1503 : Result := CalcRecPos (@SL^, @SL.lsQtyOnOrder);
    1504 : Result := CalcRecPos (@SL^, @SL.lsQtyAlloc);
    1505 : Result := CalcRecPos (@SL^, @SL.lsQtyPicked);
    1506 : Result := CalcRecPos (@SL^, @SL.lsQtyMin);
    1507 : Result := CalcRecPos (@SL^, @SL.lsQtyMax);
    1508 : Result := CalcRecPos (@SL^, @SL.lsQtyFreeze);
    1509 : Result := CalcRecPos (@SL^, @SL.lsRoQty);
    1510 : Result := CalcRecPos (@SL^, @SL.lsRoDate);
    1511 : Result := CalcRecPos (@SL^, @SL.lsRoCC);
    1512 : Result := CalcRecPos (@SL^, @SL.lsRoDep);
    1513 : Result := CalcRecPos (@SL^, @SL.lsCC);
    1514 : Result := CalcRecPos (@SL^, @SL.lsDep);
    1515 : Result := CalcRecPos (@SL^, @SL.lsBinLoc);
    1516 : Result := CalcRecPos (@SL^, @SL.lsSaleBands);
    1517 : Result := CalcRecPos (@SL^, @SL.lsRoPrice);
    1518 : Result := CalcRecPos (@SL^, @SL.lsRoCurrency);
    1519 : Result := CalcRecPos (@SL^, @SL.lsCostPrice);
    1520 : Result := CalcRecPos (@SL^, @SL.lsPCurrency);
    1521 : Result := CalcRecPos (@SL^, @SL.lsDefNom);
    1522 : Result := CalcRecPos (@SL^, @SL.lsMinFlg);
    1523 : Result := CalcRecPos (@SL^, @SL.lsTempSupp);
    1524 : Result := CalcRecPos (@SL^, @SL.lsSupplier);
    1526 : Result := CalcRecPos (@SL^, @SL.lsLastUsed);
    1527 : Result := CalcRecPos (@SL^, @SL.lsQtyPosted);
    1528 : Result := CalcRecPos (@SL^, @SL.lsQtyTake);
    1529 : Result := CalcRecPos (@SL^, @SL.Spare2);
    1530 : Result := CalcRecPos (@SL^, @SL.PadChar1);
    1531 : Result := CalcRecPos (@SL^, @SL.PadChar2);
    1532 : Result := CalcRecPos (@SL^, @SL.PadChar3);
    1533 : Result := CalcRecPos (@SL^, @SL.PadChar4);
    1534 : Result := CalcRecPos (@SL^, @SL.LastChar);
    1535 : Result := CalcRecPos (@SL^, @SL.PadChar5);
    1536 : Result := CalcRecPos (@SL^, @SL.lsLastTime);
    1537 : Result := CalcRecPos (@SL^, @SL.lsQtyAllocWOR);
    1538 : Result := CalcRecPos (@SL^, @SL.lsQtyIssueWOR);
    1539 : Result := CalcRecPos (@SL^, @SL.lsQtyPickWOR);
    1540 : Result := CalcRecPos (@SL^, @SL.lsWOPWIPGL);

    { TBatchMLocRec }
    1600 : Result := CalcRecPos (@ML^, @ML.loCode);
    1601 : Result := CalcRecPos (@ML^, @ML.loName);
    1602 : Result := CalcRecPos (@ML^, @ML.loAddr);
    1603 : Result := CalcRecPos (@ML^, @ML.loTel);
    1604 : Result := CalcRecPos (@ML^, @ML.loFax);
    1605 : Result := CalcRecPos (@ML^, @ML.loemail);
    1606 : Result := CalcRecPos (@ML^, @ML.loModem);
    1607 : Result := CalcRecPos (@ML^, @ML.loContact);
    1608 : Result := CalcRecPos (@ML^, @ML.loCurrency);
    1609 : Result := CalcRecPos (@ML^, @ML.loArea);
    1610 : Result := CalcRecPos (@ML^, @ML.loRep);
    1611 : Result := CalcRecPos (@ML^, @ML.loTag);
    1612 : Result := CalcRecPos (@ML^, @ML.loNominal);
    1613 : Result := CalcRecPos (@ML^, @ML.loCC);
    1614 : Result := CalcRecPos (@ML^, @ML.loDep);
    1615 : Result := CalcRecPos (@ML^, @ML.loUsePrice);
    1616 : Result := CalcRecPos (@ML^, @ML.loUseNom);
    1617 : Result := CalcRecPos (@ML^, @ML.loUseCCDep);
    1618 : Result := CalcRecPos (@ML^, @ML.loUseSupp);
    1619 : Result := CalcRecPos (@ML^, @ML.loUseBinLoc);
    1620 : Result := CalcRecPos (@ML^, @ML.Spare2);
    1621 : Result := CalcRecPos (@ML^, @ML.PadChar1);
    1622 : Result := CalcRecPos (@ML^, @ML.LastChar);
    1623 : Result := CalcRecPos (@ML^, @ML.loNLineCount);
    1624 : Result := CalcRecPos (@ML^, @ML.loUseCPrice);
    1625 : Result := CalcRecPos (@ML^, @ML.loUseRPrice);
    1626 : Result := CalcRecPos (@ML^, @ML.loWOPWIPGL);

    { TBatchMatchRec }
    1700 : Result := CalcRecPos (@MAT^, @MAT.DebitRef);
    1701 : Result := CalcRecPos (@MAT^, @MAT.CreditRef);
    1702 : Result := CalcRecPos (@MAT^, @MAT.DebitCr);
    1703 : Result := CalcRecPos (@MAT^, @MAT.CreditCr);
    1704 : Result := CalcRecPos (@MAT^, @MAT.DebitVal);
    1705 : Result := CalcRecPos (@MAT^, @MAT.CreditVal);
    1706 : Result := CalcRecPos (@MAT^, @MAT.BaseVal);
    1707 : Result := CalcRecPos (@MAT^, @MAT.Spare);
    1709 : Result := CalcRecPos (@MAT^, @MAT.LastChar);
    1710 : Result := CalcRecPos (@MAT^, @MAT.Spare2);

    { TBatchNotesRec }
    1800 : Result := CalcRecPos (@NOTE^, @NOTE.NoteSort);
    1801 : Result := CalcRecPos (@NOTE^, @NOTE.NoteType);
    1802 : Result := CalcRecPos (@NOTE^, @NOTE.NoteCode);
    1803 : Result := CalcRecPos (@NOTE^, @NOTE.NoteDate);
    1804 : Result := CalcRecPos (@NOTE^, @NOTE.AlarmDate);
    1805 : Result := CalcRecPos (@NOTE^, @NOTE.AlarmSet);
    1806 : Result := CalcRecPos (@NOTE^, @NOTE.LineNo);
    1807 : Result := CalcRecPos (@NOTE^, @NOTE.User);
    1808 : Result := CalcRecPos (@NOTE^, @NOTE.NoteLine);
    1809 : Result := CalcRecPos (@NOTE^, @NOTE.Spare);
    1810 : Result := CalcRecPos (@NOTE^, @NOTE.PadChar1);
    1811 : Result := CalcRecPos (@NOTE^, @NOTE.LastChar);
    1812 : Result := CalcRecPos (@NOTE^, @NOTE.RepeatDays);
    1813 : Result := CalcRecPos (@NOTE^, @NOTE.NoteFor);
    1814 : Result := CalcRecPos (@NOTE^, @NOTE.PadChar2);

    { TBatchCCDepRec }
    1900 : Result := CalcRecPos (@CC^, @CC.CCDepCode);
    1902 : Result := CalcRecPos (@CC^, @CC.CCDepDesc);
    1901 : Result := CalcRecPos (@CC^, @CC.Spare);
    1903 : Result := CalcRecPos (@CC^, @CC.LastChar);

    { TBatchStkPriceRec }
    2000 : Result := CalcRecPos (@SP^, @SP.StockCode);
    2001 : Result := CalcRecPos (@SP^, @SP.CustCode);
    2002 : Result := CalcRecPos (@SP^, @SP.Currency);
    2003 : Result := CalcRecPos (@SP^, @SP.Qty);
    2004 : Result := CalcRecPos (@SP^, @SP.Price);
    2005 : Result := CalcRecPos (@SP^, @SP.DiscVal);
    2006 : Result := CalcRecPos (@SP^, @SP.DiscChar);
    2007 : Result := CalcRecPos (@SP^, @SP.Spare);
    2008 : Result := CalcRecPos (@SP^, @SP.PadChar1);
    2009 : Result := CalcRecPos (@SP^, @SP.LastChar);
    2010 : Result := CalcRecPos (@SP^, @SP.LocCode);
    2011 : Result := CalcRecPos (@SP^, @SP.PriceDate);

    { TBatchVATRec }
    2100 : Result := CalcRecPos (@VAT^, @VAT.VATCode);
    2101 : Result := CalcRecPos (@VAT^, @VAT.VATRate);
    2102 : Result := CalcRecPos (@VAT^, @VAT.PadChar1);
    2103 : Result := CalcRecPos (@VAT^, @VAT.LastChar);
    2104 : Result := CalcRecPos (@VAT^, @VAT.PadChar2);
    2105 : Result := CalcRecPos (@VAT^, @VAT.VATDesc);
    2106 : Result := CalcRecPos (@VAT^, @VAT.VATSpare);

    { TBatchCurrRec }
    2200 : Result := CalcRecPos (@Curr^, @Curr.Name);
    2201 : Result := CalcRecPos (@Curr^, @Curr.ScreenSymb);
    2202 : Result := CalcRecPos (@Curr^, @Curr.PrinterSymb);
    2203 : Result := CalcRecPos (@Curr^, @Curr.DailyRate);
    2204 : Result := CalcRecPos (@Curr^, @Curr.CompanyRate);
    2205 : Result := CalcRecPos (@Curr^, @Curr.LastChar);
    2206 : Result := CalcRecPos (@Curr^, @Curr.PadChar1);

    2207 : Result := CalcRecPos (@Curr^, @Curr.TriEuro);
    2208 : Result := CalcRecPos (@Curr^, @Curr.TriRates);
    2209 : Result := CalcRecPos (@Curr^, @Curr.TriInvert);
    2210 : Result := CalcRecPos (@Curr^, @Curr.TriFloat);
    2211 : Result := CalcRecPos (@Curr^, @Curr.PadChar2);

    { TBatchSysRec }
    2300 : Result := CalcRecPos (@Sys^, @Sys.UserName);
    2301 : Result := CalcRecPos (@Sys^, @Sys.UserAddr[1]);
    2302 : Result := CalcRecPos (@Sys^, @Sys.UserAddr[2]);
    2303 : Result := CalcRecPos (@Sys^, @Sys.UserAddr[3]);
    2304 : Result := CalcRecPos (@Sys^, @Sys.UserAddr[4]);
    2305 : Result := CalcRecPos (@Sys^, @Sys.UserAddr[5]);
    2306 : Result := CalcRecPos (@Sys^, @Sys.UserSort);
    2307 : Result := CalcRecPos (@Sys^, @Sys.UserAcc);
    2308 : Result := CalcRecPos (@Sys^, @Sys.UserRef);
    2309 : Result := CalcRecPos (@Sys^, @Sys.UserBank);
    2310 : Result := CalcRecPos (@Sys^, @Sys.ExPr);
    2311 : Result := CalcRecPos (@Sys^, @Sys.ExYr);
    2312 : Result := CalcRecPos (@Sys^, @Sys.Spare);
    2313 : Result := CalcRecPos (@Sys^, @Sys.LastChar);
    2314 : Result := CalcRecPos (@Sys^, @Sys.DirectCust);
    2315 : Result := CalcRecPos (@Sys^, @Sys.DirectSupp);
    2316 : Result := CalcRecPos (@Sys^, @Sys.PriceDP);
    2317 : Result := CalcRecPos (@Sys^, @Sys.CostDP);
    2318 : Result := CalcRecPos (@Sys^, @Sys.QuantityDP);
    2319 : Result := CalcRecPos (@Sys^, @Sys.MultiLocn);
    2320 : Result := CalcRecPos (@Sys^, @Sys.UserVatReg);
    2321 : Result := CalcRecPos (@Sys^, @Sys.PadChar);
    2322 : Result := CalcRecPos (@Sys^, @Sys.PeriodsPerYr);
    2323 : Result := CalcRecPos (@Sys^, @Sys.CCDepts);
    2324 : Result := CalcRecPos (@Sys^, @Sys.IntraStat);
    2325 : Result := CalcRecPos (@Sys^, @Sys.ExchangeRate);
    2326 : Result := CalcRecPos (@Sys^, @Sys.FinYearStart);
    2327 : Result := CalcRecPos (@Sys^, @Sys.TraderUDFLabel);
    2328 : Result := CalcRecPos (@Sys^, @Sys.StockUDFLabel);
    2329 : Result := CalcRecPos (@Sys^, @Sys.TransHeadUDFLabel);
    2330 : Result := CalcRecPos (@Sys^, @Sys.TransHeadUDFHide);
    2331 : Result := CalcRecPos (@Sys^, @Sys.TransLineUDFLabel);
    2332 : Result := CalcRecPos (@Sys^, @Sys.TransLineUDFHide);
    2333 : Result := CalcRecPos (@Sys^, @Sys.TransLineTypeLabel);
    2334 : Result := CalcRecPos (@Sys^, @Sys.TransLineTypeHide);
    2335 : Result := CalcRecPos (@Sys^, @Sys.JobCostUDFLabel);
    2336 : Result := CalcRecPos (@Sys^, @Sys.CurrentCountry);
    2337 : Result := CalcRecPos (@Sys^, @Sys.OrderAllocStock);
    2338 : Result := CalcRecPos (@Sys^, @Sys.CalPrFromDate);

    2339 : Result := CalcRecPos (@Sys^, @Sys.UseCrLimitChk);
    2340 : Result := CalcRecPos (@Sys^, @Sys.UseCreditChk);
    2341 : Result := CalcRecPos (@Sys^, @Sys.StopBadDr);
    2342 : Result := CalcRecPos (@Sys^, @Sys.UsePick4All);
    2343 : Result := CalcRecPos (@Sys^, @Sys.FreeExAll);
    2344 : Result := CalcRecPos (@Sys^, @Sys.WksODue);

    2345 : Result := CalcRecPos (@Sys^, @Sys.DeductBomComponents);
    2346 : Result := CalcRecPos (@Sys^, @Sys.FilterSNoByBinLoc);
    2347 : Result := CalcRecPos (@Sys^, @Sys.KeepBinHistory);
    2348 : Result := CalcRecPos (@Sys^, @Sys.BinMask);
    2349 : Result := CalcRecPos (@Sys^, @Sys.InputPackQtyOnLine);
    2350 : Result := CalcRecPos (@Sys^, @Sys.PercentageDiscounts);

    2351 : Result := CalcRecPos (@Sys^, @Sys.TTDEnabled);
    2352 : Result := CalcRecPos (@Sys^, @Sys.VBDEnabled);
    2353 : Result := CalcRecPos (@Sys^, @Sys.ECServicesEnabled);
    2354 : Result := CalcRecPos (@Sys^, @Sys.ECSalesThreshold);
    2355 : Result := CalcRecPos (@Sys^, @Sys.EnableOverrideLocations); //PR: 15/10/2010 New field for LIVE
    2356 : Result := CalcRecPos (@Sys^, @Sys.ConsumersEnabled); //PR: 28/11/2013 ABSEXCH-14797 Consumers



    { TBatchAutoBankRec }
    2400 : Result := CalcRecPos (@AB^, @AB.BankRef);
    2401 : Result := CalcRecPos (@AB^, @AB.BankValue);
    2402 : Result := CalcRecPos (@AB^, @AB.BankNom);
    2403 : Result := CalcRecPos (@AB^, @AB.BankCr);
    2404 : Result := CalcRecPos (@AB^, @AB.EntryOpo);
    2405 : Result := CalcRecPos (@AB^, @AB.EntryDate);
    2406 : Result := CalcRecPos (@AB^, @AB.Spare);
    2407 : Result := CalcRecPos (@AB^, @AB.LastChar);

    { TBatchBOMImportRec }
    2500 : Result := CalcRecPos (@BomImp^, @BomImp^.PStockCode);
    2501 : Result := CalcRecPos (@BomImp^, @BomImp^.MStockCode);
    2502 : Result := CalcRecPos (@BomImp^, @BomImp^.QtyUsed);
    2503 : Result := CalcRecPos (@BomImp^, @BomImp^.DeleteStat);
    2504 : Result := CalcRecPos (@BomImp^, @BomImp^.Spare);
    2505 : Result := CalcRecPos (@BomImp^, @BomImp^.LastChar);
    2506 : Result := CalcRecPos (@BomImp^, @BomImp^.PadChar1);

    { TBatchSerialRec }
    2600 : Result := CalcRecPos (@BatSer^, @BatSer^.SerialNo);
    2601 : Result := CalcRecPos (@BatSer^, @BatSer^.BatchNo);
    2602 : Result := CalcRecPos (@BatSer^, @BatSer^.StockCode);
    2603 : Result := CalcRecPos (@BatSer^, @BatSer^.InDoc);
    2604 : Result := CalcRecPos (@BatSer^, @BatSer^.DateIn);
    2605 : Result := CalcRecPos (@BatSer^, @BatSer^.SerCost);
    2606 : Result := CalcRecPos (@BatSer^, @BatSer^.CurCost);
    2607 : Result := CalcRecPos (@BatSer^, @BatSer^.BuyABSLine);
    2608 : Result := CalcRecPos (@BatSer^, @BatSer^.BuyQty);
    2609 : Result := CalcRecPos (@BatSer^, @BatSer^.InMLoc);
    2610 : Result := CalcRecPos (@BatSer^, @BatSer^.OutDoc);
    2611 : Result := CalcRecPos (@BatSer^, @BatSer^.DateOut);
    2612 : Result := CalcRecPos (@BatSer^, @BatSer^.SerSell);
    2613 : Result := CalcRecPos (@BatSer^, @BatSer^.CurSell);
    2614 : Result := CalcRecPos (@BatSer^, @BatSer^.SoldABSLine);
    2615 : Result := CalcRecPos (@BatSer^, @BatSer^.QtyUsed);
    2616 : Result := CalcRecPos (@BatSer^, @BatSer^.OutMLoc);
    2617 : Result := CalcRecPos (@BatSer^, @BatSer^.Sold);
    2618 : Result := CalcRecPos (@BatSer^, @BatSer^.BatchRec);
    2619 : Result := CalcRecPos (@BatSer^, @BatSer^.BatchChild);
    2620 : Result := CalcRecPos (@BatSer^, @BatSer^.CoRate);
    2621 : Result := CalcRecPos (@BatSer^, @BatSer^.DailyRate);
    2622 : Result := CalcRecPos (@BatSer^, @BatSer^.InOrdDoc);
    2623 : Result := CalcRecPos (@BatSer^, @BatSer^.InOrdLine);
    2624 : Result := CalcRecPos (@BatSer^, @BatSer^.OutOrdDoc);
    2625 : Result := CalcRecPos (@BatSer^, @BatSer^.OutOrdLine);
    2626 : Result := CalcRecPos (@BatSer^, @BatSer^.Spare);
    2627 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar1);
    2628 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar2);
    2629 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar3);
    2630 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar4);
    2631 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar5);
    2632 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar6);
    2633 : Result := CalcRecPos (@BatSer^, @BatSer^.LastChar);
    2634 : Result := CalcRecPos (@BatSer^, @BatSer^.DateUseX);
    2635 : Result := CalcRecPos (@BatSer^, @BatSer^.DoNotUpdateTL);
    2636 : Result := CalcRecPos (@BatSer^, @BatSer^.Padchar7);
    2637 : Result := CalcRecPos (@BatSer^, @BatSer^.RecPos);
    2638 : Result := CalcRecPos (@BatSer^, @BatSer^.PadChar8);

    { TBatchEmplRec }
    2700 : Result := CalcRecPos (@Empl^, @Empl^.EmpCode);
    2701 : Result := CalcRecPos (@Empl^, @Empl^.Supplier);
    2702 : Result := CalcRecPos (@Empl^, @Empl^.EmpName);
    2703 : Result := CalcRecPos (@Empl^, @Empl^.Addr[1]);
    2704 : Result := CalcRecPos (@Empl^, @Empl^.Addr[2]);
    2705 : Result := CalcRecPos (@Empl^, @Empl^.Addr[3]);
    2706 : Result := CalcRecPos (@Empl^, @Empl^.Addr[4]);
    2707 : Result := CalcRecPos (@Empl^, @Empl^.Addr[5]);
    2708 : Result := CalcRecPos (@Empl^, @Empl^.Phone);
    2709 : Result := CalcRecPos (@Empl^, @Empl^.Fax);
    2710 : Result := CalcRecPos (@Empl^, @Empl^.Mobile);
    2711 : Result := CalcRecPos (@Empl^, @Empl^.EmpType);
    2712 : Result := CalcRecPos (@Empl^, @Empl^.PayNo);
    2713 : Result := CalcRecPos (@Empl^, @Empl^.CertNo);
    2714 : Result := CalcRecPos (@Empl^, @Empl^.CertExpiry);
    2715 : Result := CalcRecPos (@Empl^, @Empl^.UseORate);
    2716 : Result := CalcRecPos (@Empl^, @Empl^.UserDef1);
    2717 : Result := CalcRecPos (@Empl^, @Empl^.UserDef2);
    2718 : Result := CalcRecPos (@Empl^, @Empl^.Spare);
    2719 : Result := CalcRecPos (@Empl^, @Empl^.LastChar);
    2720 : Result := CalcRecPos (@Empl^, @Empl^.PadChar1);
    2721 : Result := CalcRecPos (@Empl^, @Empl^.CC);
    2722 : Result := CalcRecPos (@Empl^, @Empl^.Dep);
    2723 : Result := CalcRecPos (@Empl^, @Empl^.SelfBill);
    2724 : Result := CalcRecPos (@Empl^, @Empl^.GroupCert);
    2725 : Result := CalcRecPos (@Empl^, @Empl^.CertType);
    2726 : Result := CalcRecPos (@Empl^, @Empl^.UserDef3);
    2727 : Result := CalcRecPos (@Empl^, @Empl^.UserDef4);
    2728 : Result := CalcRecPos (@Empl^, @Empl^.ENINo);
    2729 : Result := CalcRecPos (@Empl^, @Empl^.LabourPLOnly);
    2730 : Result := CalcRecPos (@Empl^, @Empl^.emEmailAddress);

    { TBatchJobAnalRec }
    2800 : Result := CalcRecPos (@JobAnal^, @JobAnal^.JAnalCode);
    2801 : Result := CalcRecPos (@JobAnal^, @JobAnal^.JAnalDesc);
    2802 : Result := CalcRecPos (@JobAnal^, @JobAnal^.JAnalType);
    2803 : Result := CalcRecPos (@JobAnal^, @JobAnal^.JAnalCatry);
    2804 : Result := CalcRecPos (@JobAnal^, @JobAnal^.WIPNomCode);
    2805 : Result := CalcRecPos (@JobAnal^, @JobAnal^.PLNomCode);
    2806 : Result := CalcRecPos (@JobAnal^, @JobAnal^.LineType);
    2807 : Result := CalcRecPos (@JobAnal^, @JobAnal^.Spare);
    2808 : Result := CalcRecPos (@JobAnal^, @JobAnal^.LastChar);

    2809 : Result := CalcRecPos (@JobAnal^, @JobAnal^.CISTaxRate);
    2810 : Result := CalcRecPos (@JobAnal^, @JobAnal^.UpliftP);
    2811 : Result := CalcRecPos (@JobAnal^, @JobAnal^.UpliftGL);
    2812 : Result := CalcRecPos (@JobAnal^, @JobAnal^.RevenueType);
    2813 : Result := CalcRecPos (@JobAnal^, @JobAnal^.jaPayCode);

    { TBatchJobRateRec }
    2900 : Result := CalcRecPos (@JobRate^, @JobRate^.JEmpCode);
    2901 : Result := CalcRecPos (@JobRate^, @JobRate^.JRateCode);
    2902 : Result := CalcRecPos (@JobRate^, @JobRate^.JRateDesc);
    2903 : Result := CalcRecPos (@JobRate^, @JobRate^.JAnalCode);
    2904 : Result := CalcRecPos (@JobRate^, @JobRate^.CostCurr);
    2905 : Result := CalcRecPos (@JobRate^, @JobRate^.Cost);
    2906 : Result := CalcRecPos (@JobRate^, @JobRate^.ChargeCurr);
    2907 : Result := CalcRecPos (@JobRate^, @JobRate^.ChargeRate);
    2908 : Result := CalcRecPos (@JobRate^, @JobRate^.PayRollCode);
    2909 : Result := CalcRecPos (@JobRate^, @JobRate^.Spare);
    2910 : Result := CalcRecPos (@JobRate^, @JobRate^.LastChar);
    2911 : Result := CalcRecPos (@JobRate^, @JobRate^.PadChar1);
    2912 : Result := CalcRecPos (@JobRate^, @JobRate^.PadChar2);
    2913 : Result := CalcRecPos (@JobRate^, @JobRate^.PayFactor);
    2914 : Result := CalcRecPos (@JobRate^, @JobRate^.PayRate);


    { TBatchDiscRec }
    3000 : Result := CalcRecPos (@DiscRt^, @DiscRt^.CustCode);
    3001 : Result := CalcRecPos (@DiscRt^, @DiscRt^.StockCode);
    3002 : Result := CalcRecPos (@DiscRt^, @DiscRt^.DiscType);
    3003 : Result := CalcRecPos (@DiscRt^, @DiscRt^.SalesBand);
    3004 : Result := CalcRecPos (@DiscRt^, @DiscRt^.SPCurrency);
    3005 : Result := CalcRecPos (@DiscRt^, @DiscRt^.SPrice);
    3006 : Result := CalcRecPos (@DiscRt^, @DiscRt^.DiscPer);
    3007 : Result := CalcRecPos (@DiscRt^, @DiscRt^.DiscAmt);
    3008 : Result := CalcRecPos (@DiscRt^, @DiscRt^.DiscMar);
    3009 : Result := CalcRecPos (@DiscRt^, @DiscRt^.QtyBreak);
    3010 : Result := CalcRecPos (@DiscRt^, @DiscRt^.QtyFr);
    3011 : Result := CalcRecPos (@DiscRt^, @DiscRt^.QtyTo);
    3012 : Result := CalcRecPos (@DiscRt^, @DiscRt^.Spare);
    3013 : Result := CalcRecPos (@DiscRt^, @DiscRt^.LastChar);

    { TBatchSKAltRec }
    3100 : Result := CalcRecPos (@SkAlt^, @SkAlt^.StockCode);
    3101 : Result := CalcRecPos (@SkAlt^, @SkAlt^.AltCode);
    3102 : Result := CalcRecPos (@SkAlt^, @SkAlt^.AltDesc);
    3103 : Result := CalcRecPos (@SkAlt^, @SkAlt^.SuppCode);
    3104 : Result := CalcRecPos (@SkAlt^, @SkAlt^.ROCurr);
    3105 : Result := CalcRecPos (@SkAlt^, @SkAlt^.ROPrice);
    3106 : Result := CalcRecPos (@SkAlt^, @SkAlt^.UseROPrice);
    3107 : Result := CalcRecPos (@SkAlt^, @SkAlt^.LastUsed);
    3108 : Result := CalcRecPos (@SkAlt^, @SkAlt^.PadChar1);
    3109 : Result := CalcRecPos (@SkAlt^, @SkAlt^.LastChar);
    3110 : Result := CalcRecPos (@SkAlt^, @SkAlt^.Spare);
    3111 : Result := CalcRecPos (@SkAlt^, @SkAlt^.LastTime);
    3112 : Result := CalcRecPos (@SkAlt^, @SkAlt^.PadChar2);

    { TLArrayInfoType }
    3200 : Result := CalcRecPos (@TLArray^, @TLArray^.TLArray);
    3201 : Result := CalcRecPos (@TLArray^, @TLArray^.NumTL);
    3202 : Result := CalcRecPos (@TLArray^, @TLArray^.UsedSize);
    3203 : Result := CalcRecPos (@TLArray^, @TLArray^.MaxTL);
    3204 : Result := CalcRecPos (@TLArray^, @TLArray^.TLSize);
    3205 : Result := CalcRecPos (@TLArray^, @TLArray^.Spare);
    3206 : Result := CalcRecPos (@TLArray^, @TLArray^.LastChar);

    { TBatchJobTypeRec }
    3300 : Result := CalcRecPos (@JobType^, @JobType^.JTypeCode);
    3301 : Result := CalcRecPos (@JobType^, @JobType^.JTypeDesc);
    3302 : Result := CalcRecPos (@JobType^, @JobType^.Spare);
    3303 : Result := CalcRecPos (@JobType^, @JobType^.LastChar);

    3400 : Result := CalcRecPos (@ConvTC^, @ConvTC^.Amount);
    3401 : Result := CalcRecPos (@ConvTC^, @ConvTC^.Rate);
    3402 : Result := CalcRecPos (@ConvTC^, @ConvTC^.AmtCurr);
    3403 : Result := CalcRecPos (@ConvTC^, @ConvTC^.ConvMode);
    3404 : Result := CalcRecPos (@ConvTC^, @ConvTC^.ConvTo);
    3405 : Result := CalcRecPos (@ConvTC^, @ConvTC^.RtnValue);
    3406 : Result := CalcRecPos (@ConvTC^, @ConvTC^.Spare);
    3407 : Result := CalcRecPos (@ConvTC^, @ConvTC^.LastChar);
    3408 : Result := CalcRecPos (@ConvTC^, @ConvTC^.PadChar1);

    3500 : Result := CalcRecPos (@EComms^, @EComms^.YourEmailName);
    3501 : Result := CalcRecPos (@EComms^, @EComms^.YourEmailAddr);
    3502 : Result := CalcRecPos (@EComms^, @EComms^.SMTPServerName);
    3503 : Result := CalcRecPos (@EComms^, @EComms^.Priority);
    3504 : Result := CalcRecPos (@EComms^, @EComms^.UseMAPI);
    3505 : Result := CalcRecPos (@EComms^, @EComms^.Spare);
    3506 : Result := CalcRecPos (@EComms^, @EComms^.LastChar);

    // TDefaultFormRecType
    3600 : Result := CalcRecPos (@DForm^, @DForm^.dfAccount);
    3601 : Result := CalcRecPos (@DForm^, @DForm^.dfFormNo);
    3602 : Result := CalcRecPos (@DForm^, @DForm^.dfFormName);
    3603 : Result := CalcRecPos (@DForm^, @DForm^.dfLastChar);
    3604 : Result := CalcRecPos (@DForm^, @DForm^.dfPadChar1);
    3605 : Result := CalcRecPos (@DForm^, @DForm^.dfSpare);
    3606 : Result := CalcRecPos (@DForm^, @DForm^.dfCheckGlobal);

    // TEmailPrintInfoType;
    3700 : Result := CalcRecPos (@Email^, @Email^.emPreview);
    3701 : Result := CalcRecPos (@Email^, @Email^.emSenderName);
    3702 : Result := CalcRecPos (@Email^, @Email^.emSenderAddr);
    3703 : Result := CalcRecPos (@Email^, @Email^.emSubject);
    3704 : Result := CalcRecPos (@Email^, @Email^.emPriority);
    3705 : Result := CalcRecPos (@Email^, @Email^.emSendReader);
    3706 : Result := CalcRecPos (@Email^, @Email^.emCompress);
    3707 : Result := CalcRecPos (@Email^, @Email^.emLastChar);
    3708 : Result := CalcRecPos (@Email^, @Email^.emSpare);
    3709 : Result := CalcRecPos (@Email^, @Email^.emCoverSheet);

    // TVATCodeDefaultType = record
    3800 : Result := CalcRecPos (@VatDef^, @VatDef^.StockVATCode);
    3801 : Result := CalcRecPos (@VatDef^, @VatDef^.AccountVATCode);
    3802 : Result := CalcRecPos (@VatDef^, @VatDef^.DefaultVATCode);
    3803 : Result := CalcRecPos (@VatDef^, @VatDef^.LastChar);

    // TEnterpriseInfoType
    3900 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiDefined);
    3901 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiEntVersion);
    3902 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiEntPath);
    3903 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiDataPath);
    3904 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiUserName);
    3905 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiCurrencyVer);
    3906 : Result := CalcRecPos (@EntInfo^, @EntInfo^.eiSpare);
    3907 : Result := CalcRecPos (@EntInfo^, @EntInfo^.LastChar);

    // TUserProfileType
    4000 : Result := CalcRecPos (@UserProf^, @UserProf.upUserId);
    4001 : Result := CalcRecPos (@UserProf^, @UserProf.upName);
    4002 : Result := CalcRecPos (@UserProf^, @UserProf.upEmail);
    4003 : Result := CalcRecPos (@UserProf^, @UserProf.upLockOutMins);
    4004 : Result := CalcRecPos (@UserProf^, @UserProf.upDefSRICust);
    4005 : Result := CalcRecPos (@UserProf^, @UserProf.upDefPPISupp);
    4006 : Result := CalcRecPos (@UserProf^, @UserProf.upDefCostCentre);
    4007 : Result := CalcRecPos (@UserProf^, @UserProf.upDefDepartment);
    4008 : Result := CalcRecPos (@UserProf^, @UserProf.upDefCCDeptRule);
    4009 : Result := CalcRecPos (@UserProf^, @UserProf.upDefLocation);
    4010 : Result := CalcRecPos (@UserProf^, @UserProf.upDefLocRule);
    4011 : Result := CalcRecPos (@UserProf^, @UserProf.upDefSalesBankGL);
    4012 : Result := CalcRecPos (@UserProf^, @UserProf.upDefPurchBankGL);
    4013 : Result := CalcRecPos (@UserProf^, @UserProf.upMaxSalesAuth);
    4014 : Result := CalcRecPos (@UserProf^, @UserProf.upMaxPurchAuth);
    4015 : Result := CalcRecPos (@UserProf^, @UserProf.upSpare);
    4016 : Result := CalcRecPos (@UserProf^, @UserProf.LastChar);
    4017 : Result := CalcRecPos (@UserProf^, @UserProf.upShowGLCodesInTree);
    4018 : Result := CalcRecPos (@UserProf^, @UserProf.upShowProductTypesInTree);
    4019 : Result := CalcRecPos (@UserProf^, @UserProf.upShowStockCodesInTree);
    4020 : Result := CalcRecPos (@UserProf^, @UserProf.upUserStatus);
    4021 : Result := CalcRecPos (@UserProf^, @UserProf.upWindowsUserID);
    4022 : Result := CalcRecPos (@UserProf^, @UserProf.HighlightPIIFields);
    4023 : Result := CalcRecPos (@UserProf^, @UserProf.HighlightPIIColour);

    // TBatchLinkRec
    4100 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkCode);
    4101 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkFolioKey);
    4102 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkAttachTo);
    4103 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLetterLink);
    4104 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLinkType);
    4105 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkDate);
    4106 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkTime);
    4107 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkUserCode);
    4108 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLetterDescription);
    4109 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLetterFileName);
    4110 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLinkDescription);
    4111 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkLinkFileName);
    4112 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkSpare);
    4113 : Result := CalcRecPos (@LinkRec^, @LinkRec^.LastChar);
    4114 : Result := CalcRecPos (@LinkRec^, @LinkRec^.lkPadChar1);

    // TBatchLinkRec
    4200 : Result := CalcRecPos (@ConvRec^, @ConvRec^.cvDocFrom);
    4201 : Result := CalcRecPos (@ConvRec^, @ConvRec^.cvDocTo);
    4202 : Result := CalcRecPos (@ConvRec^, @ConvRec^.cvDocToType);
    4203 : Result := CalcRecPos (@ConvRec^, @ConvRec^.cvStatus);

    //TBatchBinRec
   4300 : Result := CalcRecPos (@BinRec^, @BinRec^.brBinCode);
   4301 : Result := CalcRecPos (@BinRec^, @BinRec^.brInDocRef);
   4302 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutDocRef);
   4303 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar1);
   4304 : Result := CalcRecPos (@BinRec^, @BinRec^.brSold);
   4305 : Result := CalcRecPos (@BinRec^, @BinRec^.brInDate);
   4306 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar2);
   4307 : Result := CalcRecPos (@BinRec^, @BinRec^.brCostPrice);
   4308 : Result := CalcRecPos (@BinRec^, @BinRec^.brCapacity);
   4309 : Result := CalcRecPos (@BinRec^, @BinRec^.brStockFolio);
   4310 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutDate);
   4311 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar3);
   4312 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutDocLine);
   4313 : Result := CalcRecPos (@BinRec^, @BinRec^.brInDocLine);
   4314 : Result := CalcRecPos (@BinRec^, @BinRec^.brQty);
   4315 : Result := CalcRecPos (@BinRec^, @BinRec^.brQtyUsed);
   4316 : Result := CalcRecPos (@BinRec^, @BinRec^.brUsedRec);
   4317 : Result := CalcRecPos (@BinRec^, @BinRec^.brInLocation);
   4318 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutLocation);
   4319 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar4);
   4320 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutOrderRef);
   4321 : Result := CalcRecPos (@BinRec^, @BinRec^.brInOrderRef);
   4322 : Result := CalcRecPos (@BinRec^, @BinRec^.brInOrderLine);
   4323 : Result := CalcRecPos (@BinRec^, @BinRec^.brOutOrderLine);
   4324 : Result := CalcRecPos (@BinRec^, @BinRec^.brCostPriceCurrency);
   4325 : Result := CalcRecPos (@BinRec^, @BinRec^.brPickingPriority);
   4326 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar5);
   4327 : Result := CalcRecPos (@BinRec^, @BinRec^.brSalesPrice);
   4328 : Result := CalcRecPos (@BinRec^, @BinRec^.brCompanyRate);
   4329 : Result := CalcRecPos (@BinRec^, @BinRec^.brDailyRate);
   4330 : Result := CalcRecPos (@BinRec^, @BinRec^.brUseORate);
   4331 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar6);
   4332 : Result := CalcRecPos (@BinRec^, @BinRec^.brTriRates);
   4333 : Result := CalcRecPos (@BinRec^, @BinRec^.brTriEuro);
   4334 : Result := CalcRecPos (@BinRec^, @BinRec^.brTriInvert);
   4335 : Result := CalcRecPos (@BinRec^, @BinRec^.brTriFloat);
   4336 : Result := CalcRecPos (@BinRec^, @BinRec^.brUseByDate);
   4337 : Result := CalcRecPos (@BinRec^, @BinRec^.brSalesPriceCurrency);
   4338 : Result := CalcRecPos (@BinRec^, @BinRec^.brUnitOfMeasurement);
   4339 : Result := CalcRecPos (@BinRec^, @BinRec^.PadChar7);
   4340 : Result := CalcRecPos (@BinRec^, @BinRec^.brAutoPickMode);
   4341 : Result := CalcRecPos (@BinRec^, @BinRec^.brTagNo);
   4342 : Result := CalcRecPos (@BinRec^, @BinRec^.brRecPos);
   4343 : Result := CalcRecPos (@BinRec^, @BinRec^.Spare);
   4344 : Result := CalcRecPos (@BinRec^, @BinRec^.LastChar);

   //TBatchMultiBuyDiscount
   4400 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdOwnerType);
   4401 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdDiscountType);
   4402 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdAcCode);
   4403 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdStockCode);
   4404 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdCurrency);
   4405 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdStartDate);
   4406 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdEndDate);
   4407 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdUseDates);
   4408 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdBuyQty);
   4409 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.mbdRewardValue);
   4410 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.RecordPosition);
   4411 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.Spare);
   4412 : Result := CalcRecPos (@MultiBuyRec^, @MultiBuyRec^.LastChar);



  Else
    Result := 0;
  End; { Case }

  Dispose (Sys);
  Dispose (Curr);
  Dispose (VAT);
  Dispose (SP);
  Dispose (CC);
  Dispose (NOTE);
  Dispose (MAT);
  Dispose (ML);
  Dispose (SL);
  Dispose (JH);
  Dispose (SR);
  Dispose (BOM);
  Dispose (NM);
  Dispose (BomImp);
  Dispose (BatSer);
  Dispose (Empl);
  Dispose (JobAnal);
  Dispose (JobRate);
  Dispose (JobType);
  Dispose (DiscRt);
  Dispose (SkAlt);
  Dispose (TLArray);
  Dispose (ConvTC);
  Dispose (EComms);
  Dispose (DForm);
  Dispose (Email);
  Dispose (VatDef);
  Dispose (EntInfo);
  Dispose (UserProf);
  Dispose (LinkRec);
  Dispose (ConvRec);
  Dispose (BinRec);
  Dispose (MultiBuyRec);
End;


