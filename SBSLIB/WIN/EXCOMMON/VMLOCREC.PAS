    { ================ Multi Location File ============= }

Const
  MLocF     =     14;

  MLNofKeys =     3;

  MLK       =     0;
  MLSecK    =     1;
  MLSuppK   =     2;


  MLNofSegs =     3;



Type
    { ================ Master Location Record ================ }


    MLocLocType    = Record
               {002}  loCode       :  String[10];   { Master Location Code }
               {012}  Spare        :  Array[1..20] of Byte;
               {033}  loName       :  String[45];   {    "       "    Name }
               {079}  Spare1       :  String[31];
               {111}  loAddr       :  AddrType;     { Address }
               {266}  loTel        :  String[25]    { Tel     }
               {292}  loFax        :  String[25]    { Fax     }
               {318}  loemail      :  String[100]   { email   }
               {419}  loModem      :  String[25];   {modem number }
               {445}  loContact    :  String[30]    { Contact   }
               {475}  loCurrency   :  Byte;         { Def Currency }
               {477}  loArea       :  String[5];    { Report Area }
               {483}  loRep        :  String[5];    { Report Rep  }
               {488}  loTag        :  Boolean;      { Tagged }
               {489}  loNominal    :  Array[1..10] of LongInt; { Def Nom }
               {530}  loCCDep      :  CCDepType;    { Def CC Dep }
               {536}  loUsePrice   :  Boolean;      { Override Price }
               {537}  loUseNom     :  Boolean;      { Override Noms }
               {538}  loUseCCDep   :  Boolean;      { Override CCDep}

               {539}  Spare2       :  Array[1..227] of Byte;
                    end;

    { ================ Stock Location Record ================ }

    MStkLocType    = Record
               {002}  lsCode1      :  String[30];   { Stock Code + Loc Code }
               {033}  lsCode2      :  String[45];   { Loc Code + Stock Code }
               {079}  lsCode3      :  String[31];   { Supplier + PCurrency + Stock Code }
               {111}  lsStkCode    :  String[20];   { Stock Code }
               {131}  lsStkFolio   :  LongInt;      {    "  Folio }
               {136}  lsLocCode       String[10];   { Loc Code }
               {146}  lsQtyInStock :  Double;       { Actual Stock }
               {154}  lsQtyOnOrder :  Double;       { OnOrder }
               {162}  lsQtyAlloc   :  Double;       { Allocated }
               {170}  lsQtyPicked  :  Double;       { Picked }
               {178}  lsQtyMin     :  Double;       { Min    }
               {186}  lsQtyMax     :  Double;       { Max    }
               {194}  lsQtyFreeze  :  Double;       { Freeze Qty }
               {202}  lsRoQty      :  Double;       { Re-Order Qty }
               {211}  lsRoDate     :  LongDate;     { Re-Order Date }
               {220}  lsRoCCDep    :  CCDepType;    { Re-Order CC/Dep}
               {229}  lsCCDep      :  CCDepType;    { Default CC/Dep}
               {238}  lsBinLoc     :  String[10];   { Bin Location }
               {248}  lsSaleBands  :  SaleBandAry;  { Pricing }
               {318}  lsRoPrice    :  Double;       { Re-Order Price}
               {326}  lsRoCurrency :  Byte;         {     "    Currency}
               {327}  lsCostPrice  :  Double;       { Last Cost Price }
               {335}  lsPCurrency  :  Byte;         {     "     Currency}
               {336}  lsDefNom     :  Array[1..10] of LongInt;
               {406}  lsStkFlg     :  Boolean;      { In Stk Take }
               {407}  lsMinFlg     :  Boolean;      { Below min Flg}
               {409}  lsTempSupp   :  String[10];   { Temp Supplier }
               {420}  lsSupplier   :  String[10];   { Main Suppplier}
               {430}  Spare2       :  Array[1..336] of Byte;
                    end;




    MLocPtr   =  ^MLocRec;


    MLocRec   =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of

                        1  :  (MLocLoc       :  MLocLocType);
                        2  :  (MStkLoc       :  MStkLocType);


                    end;


    MLoc_FilePtr   =   ^MLoc_FileDef;

    MLoc_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..MLNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;

