Unit Vrec2u;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

(* 11/02/1998
   This Unit is the same as VARREC2U.PAS from x:\SBSLib\Win\Excommon\ ,
   The reason is 16 bits needs to use BtrvU16 instead of BtrvU2
*)


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 31/07/90                      }
{                                                              }
{               Global variables & Type definitions            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}



Interface

{$O+}

Uses GlobVar,BtrvU16;


Const
  NofSBands  =   10;
  NofSUBnds  =   08;
  NofSDesc   =   06;
  NofSNoms   =   05;

Type
  CCDepType      =  Array[False..True] of String[3];  {  CC/Dep Type }

  ISNArrayType   = Array[1..8] of Byte;

    SaleBandsRec =  Record
                       Currency   :  Byte;    { Currency of Band }
                       SalesPrice :  Real;    { Price of Band    }
                     end;

     StkDescType  =  Array[1..NofSDesc] of      { Multiple Descriptions }
                       String[35];



     SaleBandAry  =  Array[1..NofSBands] of
                       SaleBandsRec;




      { ================ Multi Location File ============= }

  Const
    MLocF     =     14;

    MLNofKeys =     3;

    MLK       =     0;
    MLSecK    =     1;
    MLSuppK   =     2;


    MLNofSegs =     6;



  Type
   DefMLNomType  =  Array[1..10] of LongInt;
      { ================ Master Location Record ================ }


      MLocLocType    = Record
                 {002}  loCode       :  String[10];   { Master Location Code }
                 {012}  Spare        :  Array[1..20] of Byte;
                 {033}  loName       :  String[45];   {    "       "    Name }
                 {079}  Spare1       :  String[31];
                 {111}  loAddr       :  AddrTyp;      { Address }
                 {266}  loTel        :  String[25];   { Tel     }
                 {292}  loFax        :  String[25];   { Fax     }
                 {318}  loemail      :  String[100];  { email   }
                 {419}  loModem      :  String[25];   {modem number }
                 {445}  loContact    :  String[30];   { Contact   }
                 {475}  loCurrency   :  Byte;         { Def Currency }
                 {477}  loArea       :  String[5];    { Report Area }
                 {483}  loRep        :  String[5];    { Report Rep  }
                 {488}  loTag        :  Boolean;      { Tagged }
                 {489}  loNominal    :  DefMLNomType; { Def Nom }
                 {530}  loCCDep      :  CCDepType;    { Def CC Dep }
                 {536}  loUsePrice   :  Boolean;      { Override Price }
                 {537}  loUseNom     :  Boolean;      { Override Noms }
                 {538}  loUseCCDep   :  Boolean;      { Override CCDep}
                 {539}  loUseSupp    :  Boolean;      { Override Supplier}
                 {540}  loUseBinLoc  :  Boolean;      { Override Bin Loc }
                 {541}  loNLineCount :  LongInt;      { Notes Line Count }
                 {545}  Spare2       :  Array[1..221] of Byte;
                 {766}
                      end;

      { ================ Stock Location Record ================ }

      MStkLocType    = Record
                 {002}  lsCode1      :  String[30];   { Stock Code + Loc Code }
                 {033}  lsCode2      :  String[45];   { Loc Code + Stock Code }
                 {079}  lsCode3      :  String[31];   { Supplier + PCurrency + Stock Code }
                 {111}  lsStkCode    :  String[20];   { Stock Code }
                 {131}  lsStkFolio   :  LongInt;      {    "  Folio }
                 {136}  lsLocCode    :  String[10];   { Loc Code }
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
                 {336}  lsDefNom     :  DefMLNomType;
                 {406}  lsStkFlg     :  Boolean;      { In Stk Take }
                 {407}  lsMinFlg     :  Boolean;      { Below min Flg}
                 {409}  lsTempSupp   :  String[10];   { Temp Supplier }
                 {420}  lsSupplier   :  String[10];   { Main Suppplier}
                 {431}  lsLastUsed   :  LongDate;     { Last used rec }
                 {439}  lsQtyPosted  :  Double;       { Posted loc qty }
                 {447}  lsQtyTake    :  Double;       { Stock Take Qty }
                 {455}  lsROFlg      :  Boolean;      { RO Flg }
                 {456}  Spare2       :  Array[1..310] of Byte;
                 {766}
                      end;




      SdbStkType    = Record
                 {002}  sdCode1      :  String[30];   { Supplier Stk Code }
                 {033}  sdCode2      :  String[45];   { Stk Folio + sdCode1}
                 {079}  sdCode3      :  String[31];   { sdFolio + Stock Folio}
                 {110}  sdStkFolio   :  LongInt;      { Stock Link Folio }
                 {114}  sdFolio      :  LongInt;      { Own Folio Link }
                 {119}  sdSuppCode   :  String[10];   { Supplier Code}
                 {130}  sdAltCode    :  String[20];   { Supplier Own Stock Code}
                 {150}  sdROCurrency :  Byte;         { Re Order Curency }
                 {151}  sdRoPrice    :  Double;       { Re-Order Price}
                 {159}  sdNLineCount :  LongInt;      { Note Count }
                 {164}  sdLastUsed   :  LongDate;     { Last used }
                 {172}  sdOverRO     :  Boolean;      { Overrride RO Price }
                 {174}  sdDesc       :  String[35];   { General Description }
                 {209}  Spare2       :  Array[1..557] of Byte;
                 {766}
                      end;

      CuStkType    = Record
                 {002}  csCode1      :  String[30];   { CustCode + Stock Code}
                 {033}  csCode2      :  String[45];   { Spare }
                 {079}  csCode3      :  String[31];   { StockCode + CustCode }
                 {111}  csCustCode   :  String[10];   { CustCode }
                 {122}  csStockCode  :  String[20];   { Stock Code}
                 {142}  csStkFolio   :  LongInt;      { Stock Folio}
                 {146}  csSOQty      :  Double;       { Repeat Order }
                 {155}  csLastDate   :  LongDate;     { Last date accessed }
                 {163}  Spare2       :  Array[1..603] of Byte;
                 {766}
                      end;




      MLocPtr   =  ^MLocRec;


      MLocRec   =  Record
                        RecPfix   :  Char;         {  Record Prefix }
                        SubType   :  Char;         {  Subsplit Record Type }



                        Case SmallInt of

                          1  :  (MLocLoc       :  MLocLocType);
                          2  :  (MStkLoc       :  MStkLocType);
                          3  :  (SdbStkRec     :  sdbStkType);
                          4  :  (CuStkRec      :  CuStkType);


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


      { ================ Security Validation Record =============== }

      VSecureType= Record
                {002}   SecCode   :  String[12];      {  Lookup Code }

                {014}   Spare1    :  Array[1..10] of Byte;

                {025}   ExUsrRel  :  String[10];

                {035}   UsrRelDate:  Real;

                {042}   ExRelease :  String[10];

                {052}   RelDate   :  Real;

                {058}   ISN       :  ISNArrayType;

                {064}   DemoFlg   :  Boolean;

                {066}   Modules   :  Array[1..10] of String[10];

                {176}   ModRelDate:  Array[1..10] of Real;

                {236}   LastDaily :  LongInt;

                {240}   Spare2    :  Array[1..41] of Byte;


                      end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}




Begin


end.