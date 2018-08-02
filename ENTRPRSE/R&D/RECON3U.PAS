Unit Recon3U;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 29/01/93                      }
{                  Nominal Sturcture Support Unit              }
{                                                              }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     BtrvU2,
     EXWrap1U;



Type

  Str60           =   String[60];

  ExtNomRecPtr    =   ^ExtNomRec;

  ExtNomRec       =   Record

                        FNomCode    :  LongInt;
                        FCr,
                        FYr,
                        FPr,
                        FRecon,
                        FNomMode    :  Byte;

                        FDesc       :  String[60];

                        FCCode      :  String[10];
                        FRDate      :  LongDate;
                        FLTyp       :  Char;
                        fMatchDate  :  Boolean;
                        FMode       :  Byte;

                      end;



  FilterTypeN1       =  Record          {* Nominal Code & NomMode & Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN1CC     =  Record          {* Nominal Code & NomMode & Yr+Pr & CC *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Array[1..3] of Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Array[1..3] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN2       =  Record          {* Nominal Code & NomMode & Cr+Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN2RD     =  Record          {* Nominal Code & NomMode & Cr+Yr+Pr & Recon Date *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Array[1..8] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN2CC     =  Record          {* Nominal Code & NomMode & Cr+Yr+Pr & CC*}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Array[1..3] of Char;
    Term7            :    FilterRepeatType;
    Compare7         :    Array[1..3] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;

    FilterTypeN2CCRD   =  Record          {* Nominal Code & NomMode & Cr+Yr+Pr & CC & ReconDate *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Array[1..3] of Char;
    Term7            :    FilterRepeatType;
    Compare7         :    Array[1..3] of Char;
    Term8            :    FilterRepeatType;
    Compare8         :    Array[1..8] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN3       =  Record          {* Nominal Code & NomMode & Cr & Desc *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Array[1..60] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN4       =  Record          {* Nominal Code & NomMode & Cr & Reconcile *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    LongInt;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN5       =  Record          {* Line Type + CustCode *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..6] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Array[1..16] of Char;
    Term4            :    FilterRepeatType;
    Compare4         :    LongInt;
    ExtendTail       :    ExtendRepeatType;

  end;

  ExtStkRecPtr    =   ^ExtStkRec;

  ExtStkRec       =   Record

                        FStkCode    :  Str20;
                        FCr,
                        FYr,
                        FPr         :  Byte;

                        FCustCode   :  Str10;
                        FIsaC       :  Boolean;

                        FPostedRun  :  LongInt;

                        FMode       :  Byte;

                      end;





  FilterTypeS1       =  Record          {* Stock Code & Posted Run & Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..20] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    LongInt;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeS2       =  Record          {* Stock Code & Posted Run & Cr+Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..20] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    LongInt;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeS3       =  Record          {* Stock Code & Posted Run & Yr+Pr + Cust code +Line Type *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..10] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Array[1..20] of Char;
    Term4            :    FilterRepeatType;
    Compare4         :    LongInt;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeS4       =  Record          {* Stock Code & Posted Run & Yr+Pr + Cust code +Line Type *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..10] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Array[1..20] of Char;
    Term4            :    FilterRepeatType;
    Compare4         :    LongInt;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    Char;
    Term7            :    FilterRepeatType;
    Compare7         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  ExtCusRecPtr    =   ^ExtCusRec;

  ExtCusRec       =   Record

                        FCusCode    :  Str10;
                        FCr,
                        FYr,
                        FPr         :  Byte;

                        FCheckLI,
                        FNomAuto    :  Boolean;

                        FMode       :  Byte;

                        FAlCode,
                        FCSCode     :  Char;

                        FAlDate     :  LongDate;

                        FLastInv,
                        FCtrlNom    :  LongInt;
                        
                        FDirec      :  Boolean;

                        FB_Func     :  Array[BOff..BOn] of
                                         Integer;

                        FLogPtr     :  Pointer;
                      end;





  FilterTypeC1       =  Record          {* Cust Code & NomAuto & Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..06] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeC2       =  Record          {* Cust Code & NomAuto & Cr+Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..06] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeC3       =  Record          {* Cust Code & Cr & AlCode, or Alocated today *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..06] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Boolean;
    Term4            :    FilterRepeatType;
    Compare4         :    Array[1..08] of Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeC1Cid       =  Record          {* Cust Code & NomAuto & Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..06] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN        =  Record

    Case Integer of

      1  :  (FilterN1 :  FilterTypeN1);
      2  :  (FilterN2 :  FilterTypeN2);
      3  :  (FilterN3 :  FilterTypeN3);
      4  :  (FilterN4 :  FilterTypeN4);
      5  :  (FilterN5 :  FilterTypeN5);
      6  :  (FilterS1 :  FilterTypeS1);
      7  :  (FilterS2 :  FilterTypeS2);
      8  :  (FilterS3 :  FilterTypeS3);
      9  :  (FilterS4 :  FilterTypeS4);
     10  :  (FilterC1 :  FilterTypeC1);
     11  :  (FilterC2 :  FilterTypeC2);
     12  :  (FilterC3 :  FilterTypeC3);
     13  :  (FilterC1CId
                      :  FilterTypeC1CId);
     14  :  (FilterN1CC
                      :  FilterTypeN1CC);
     15  :  (FilterN2CC
                      :  FilterTypeN2CC);

     16  :  (FilterN2RD
                      :  FilterTypeN2RD);
     17  :  (FilterN2CCRD
                      :  FilterTypeN2CCRD);

    end;


  SearchNPtr         =  ^SearchNRecType;

  SearchNRecType      =  Record

    Case Integer of

      1  :  (Filter  :  FilterTypeN);
      2  :  (ExtRec  :  ResultRecType);

  end; {Rec..}



  GetExNObj  =  ^ExtSNObj;

  ExtSNObj   =  Object

                 SearchRec  :  SearchNPtr;

                 Constructor  Init;

                 Destructor   Done;

                 Procedure Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                         Var  ExtendTail  :  ExtendRepeatType;
                                              FileNum     :  Integer;
                                              FiltSize    :  Integer);


                 Function  GetSearchRec(B_Func,
                                        Fnum,
                                        Keypath   :  Integer;
                                        DataLen   :  Integer;
                                    Var GSearchRec:  SearchNPtr;
                                    Var KeyS      :  Str255)  :  Integer;


               end; {Object..}


  { --------------------------------------- }


  GetExNObjCid  =  ^ExtSNObjCid;

  ExtSNObjCid   =  Object

                   DebtLetters  :  Array[0..NofChaseLtrs] of Boolean;

                 SearchRec  :  SearchNPtr;

                 MTExLocal  :  TdMTExLocalPtr;

                 Constructor  Init;

                 Destructor   Done;

                 Procedure Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                         Var  ExtendTail  :  ExtendRepeatType;
                                              FileNum     :  Integer;
                                              FiltSize    :  Integer);


                 Function  GetSearchRec(B_Func,
                                        Fnum,
                                        Keypath   :  Integer;
                                        DataLen   :  Integer;
                                    Var GSearchRec:  SearchNPtr;
                                    Var KeyS      :  Str255)  :  Integer;


               end; {Object..}


  { --------------------------------------- }


  GetNomMode1  =  ^Nom1ExtSObj;

  Nom1ExtSObj   =  Object(ExtSNObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FNomCode      :  LongInt;
                                              FYr,FPr,FNm   :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
                                            FYr,FPr,FNm
                                                      :  Byte)  :  Integer;


                    Procedure SetNomObj1CC(Var SetSearchRec  :  SearchNPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               FYr,
                                               FPr,FNm       :  Byte;
                                               CCode         :  Str10;
                                               CCMode        :  Boolean);

                    Function  GetSearchRec2CC(B_Func,
                                              Fnum,
                                              Keypath :  Integer;
                                          Var KeyS    :  Str255;
                                              FNomcode:  LongInt;
                                              FYr,FPr,
                                              FNm     :  Byte;
                                              CCode   :  Str10;
                                              CCMode  :  Boolean)  :  Integer;



               end; {Object..}


  { --------------------------------------- }


  GetNomMode2  =  ^Nom2ExtSObj;

  Nom2ExtSObj  =  Object(Nom1ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FNomCode      :  LongInt;
                                             FCr,FYr,FPr,
                                             FNm           :  Byte);




                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
                                            FCr,FYr,
                                            FPr,FNm
                                                      :  Byte)  :  Integer;

                    Procedure SetNomObj1CC(Var SetSearchRec  :  SearchNPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               FCr,FYr,
                                               FPr,FNm       :  Byte;
                                               CCode         :  Str10;
                                               CCMode        :  Boolean);

                    Function  GetSearchRec2CC(B_Func,
                                              Fnum,
                                              Keypath :  Integer;
                                          Var KeyS    :  Str255;
                                              FNomcode:  LongInt;
                                              FCr,FYr,
                                              FPr,FNm :  Byte;
                                              CCode   :  Str10;
                                              CCMode  :  Boolean)  :  Integer;


                    Procedure SetNomObj3CC(Var SetSearchRec  :  SearchNPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               FCr,FNm       :  Byte;
                                               CCode         :  Str10;
                                               CCMode        :  Boolean);

                    Function  GetSearchRec3CC(B_Func,
                                              Fnum,
                                              Keypath :  Integer;
                                          Var KeyS    :  Str255;
                                              FNomcode:  LongInt;
                                              FCr,FNm :  Byte;
                                              CCode   :  Str10;
                                              CCMode  :  Boolean)  :  Integer;

                    Procedure SetNomObj1RD(Var SetSearchRec  :  SearchNPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               FCr,FYr,
                                               FPr,FNm       :  Byte;
                                               CCode         :  LongDate);


                    Function  GetSearchRec2RD(B_Func,
                                              Fnum,
                                              Keypath :  Integer;
                                          Var KeyS    :  Str255;
                                              FNomcode:  LongInt;
                                              FCr,FYr,
                                              FPr,FNm :  Byte;
                                              CCode   :  LongDate)  :  Integer;

                    Procedure SetNomObj1CCRD(Var SetSearchRec  :  SearchNPtr;
                                                 Fnum          :  Integer;
                                                 FNomCode      :  LongInt;
                                                 FCr,FYr,
                                                 FPr,FNm       :  Byte;
                                                 CCode         :  Str10;
                                                 CCMode        :  Boolean;
                                                 RDate         :  LongDate);

                    Function  GetSearchRec2CCRD(B_Func,
                                                Fnum,
                                                Keypath :  Integer;
                                            Var KeyS    :  Str255;
                                                FNomcode:  LongInt;
                                                FCr,FYr,
                                                FPr,FNm :  Byte;
                                                CCode   :  Str10;
                                                CCMode  :  Boolean;
                                                RDate   :  LongDate)  :  Integer;



               end; {Object..}




  { --------------------------------------- }


  GetNomMode3  =  ^Nom3ExtSObj;

  Nom3ExtSObj  =  Object(ExtSNObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FNomCode      :  LongInt;
                                             FDesc         :  Str60;
                                             FCr,
                                             FNm           :  Byte;
                                        Var  ReduceX       :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
                                            FDesc     :  Str60;
                                            FCr,FNm
                                                      :  Byte)  :  Integer;

               end; {Object..}


  { --------------------------------------- }


  GetNomMode3Cid  =  ^Nom3ExtSObjCid;

  Nom3ExtSObjCid  =  Object(ExtSNObjCid)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FNomCode      :  LongInt;
                                             FDesc         :  Str60;
                                             FCr,
                                             FNm           :  Byte;
                                        Var  ReduceX       :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
                                            FDesc     :  Str60;
                                            FCr,FNm
                                                      :  Byte)  :  Integer;

               end; {Object..}


  { --------------------------------------- }

  GetNomMode32Cid =  ^Nom32ExtSObjCid;

  Nom32ExtSObjCid =  Object(Nom3ExtSObjCid)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj2(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FNomCode      :  LongInt;
                                             FCr,
                                             FNm,
                                             RMd           :  Byte);




                    Function  GetSearchRec32(B_Func,
                                             Fnum,
                                             Keypath   :  Integer;
                                         Var KeyS      :  Str255;
                                             FNomcode  :  LongInt;
                                             FCr,FNm,RMd
                                                       :  Byte)  :  Integer;

               end; {Object..}


  { --------------------------------------- }

  GetNomMode32 =  ^Nom32ExtSObj;

  Nom32ExtSObj =  Object(Nom3ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj2(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FNomCode      :  LongInt;
                                             FCr,
                                             FNm,
                                             RMd           :  Byte);




                    Function  GetSearchRec32(B_Func,
                                             Fnum,
                                             Keypath   :  Integer;
                                         Var KeyS      :  Str255;
                                             FNomcode  :  LongInt;
                                             FCr,FNm,RMd
                                                       :  Byte)  :  Integer;

               end; {Object..}


  { --------------------------------------- }

{$IFDEF STK}

  GetNomMode4  =  ^Nom4ExtSObj;

  Nom4ExtSObj  =  Object(ExtSNObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                             Fnum          :  Integer;
                                             FLineTyp      :  Char;
                                             FCCode        :  Str10);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FLineTyp  :  Char;
                                            FCCode    :  Str10) :  Integer;

               end; {Object..}

{$ENDIF}


  { --------------------------------------- }


  GetStkMode1  =  ^Stk1ExtSObj;

  Stk1ExtSObj   =  Object(Nom2ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FStkCode      :  Str20;
                                              FPostedRun    :  LongInt;
                                              FYr,FPr       :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FStkCode      :  Str20;
                                            FPostedRun    :  LongInt;
                                            FYr,FPr       :  Byte)  :  Integer;


               end; {Object..}



  { --------------------------------------- }

  GetStkMode2  =  ^Stk2ExtSObj;

  Stk2ExtSObj  =  Object(Stk1ExtSObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FStkCode      :  Str20;
                                              FPostedRun    :  LongInt;
                                              FCr,FYr,FPr   :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FStkCode      :  Str20;
                                            FPostedRun    :  LongInt;
                                            FCr,FYr,FPr   :  Byte)  :  Integer;



               end; {Object..}


    { --------------------------------------- }

  GetStkMode3  =  ^Stk3ExtSObj;

  Stk3ExtSObj  =  Object(Stk2ExtSObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FStkCode      :  Str20;
                                              FCustCode     :  Str10;
                                              FPostedRun    :  LongInt;
                                              FCr,FYr,FPr   :  Byte;
                                              FIsaC         :  Boolean);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FStkCode      :  Str20;
                                            FCustCode     :  Str10;
                                            FPostedRun    :  LongInt;
                                            FCr,FYr,FPr   :  Byte;
                                            FIsaC         :  Boolean)  :  Integer;



               end; {Object..}


    { --------------------------------------- }
  GetStkMode4  =  ^Stk4ExtSObj;

  Stk4ExtSObj  =  Object(Stk3ExtSObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FStkCode      :  Str20;
                                              FCustCode     :  Str10;
                                              FPostedRun    :  LongInt;
                                              FCr,FYr,FPr   :  Byte;
                                              FIsaC         :  Boolean);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FStkCode      :  Str20;
                                            FCustCode     :  Str10;
                                            FPostedRun    :  LongInt;
                                            FCr,FYr,FPr   :  Byte;
                                            FIsaC         :  Boolean)  :  Integer;



               end; {Object..}


    { --------------------------------------- }

  GetCusMode1  =  ^Cus1ExtSObj;

  Cus1ExtSObj   =  Object(Stk4ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetCusObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FCusCode      :  Str10;
                                              FNomAuto      :  Boolean;
                                              FYr,FPr       :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FCusCode      :  Str10;
                                            FNomAuto      :  Boolean;
                                            FYr,FPr       :  Byte)  :  Integer;


               end; {Object..}



  { --------------------------------------- }

  GetCusMode2  =  ^Cus2ExtSObj;

  Cus2ExtSObj  =  Object(Cus1ExtSObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetCusObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FCusCode      :  Str10;
                                              FNomAuto      :  Boolean;
                                              FCr,FYr,
                                              FPr           :  Byte);





                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FCusCode  :  Str10;
                                            FNomAuto  :  Boolean;
                                            FCr,FYr,
                                            FPr       :  Byte)  :  Integer;


                    Procedure SetCusObj3(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FCusCode      :  Str10;
                                              FNomAuto      :  Boolean;
                                              FCr           :  Byte;
                                              FAlCode       :  Char);


                    Function  GetSearchRec3(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FCusCode  :  Str10;
                                            FNomAuto  :  Boolean;
                                            FCr       :  Byte;
                                            FAlCode   :  Char)  :  Integer;


                    Procedure SetCusObj4(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FCusCode      :  Str10;
                                              FNomAuto      :  Boolean;
                                              FCr           :  Byte;
                                              FAlCode       :  Char;
                                              FAlDate       :  LongDate);


                    Function  GetSearchRec4(B_Func,
                                            Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FCusCode  :  Str10;
                                            FNomAuto  :  Boolean;
                                            FCr       :  Byte;
                                            FAlCode   :  Char;
                                            FAlDate   :  LongDate)  :  Integer;


               end; {Object..}


  { --------------------------------------- }



    GetNomMode    =  ^NomExtSObj;

    NomExtSObj    =  Object(Cus2ExtSObj)

                      Constructor  Init;

                      Destructor   Done;



                      Function  GetSearchRec(B_Func,
                                             Fnum,
                                             Keypath   :  Integer;
                                         Var KeyS      :  Str255;
                                             FNomcode  :  LongInt;
				             FCr,FYr,
                                             FPr,FNm,
                                             Mode      :  Byte;
                                             CCode     :  Str10;
                                             RDate     :  LongDate)  :  Integer;


                      Function  GetSearchRec2(B_Func,
                                              Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FStkcode  :  Str20;
                                              FCustCode :  Str10;
                                              FIsaC     :  Boolean;
                                              FPostedRun:  LongInt;
                                              FCr,FYr,
                                              FPr,
                                              Mode      :  Byte)  :  Integer;

                      Function  GetSearchRec3(B_Func,
                                              Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FCuscode  :  Str10;
                                              FNomAuto  :  Boolean;
                                              FAlCode   :  Char;
                                              FAlDate   :  LongDate;
				              FCr,FYr,
                                              FPr,
                                              Mode      :  Byte)  :  Integer;




                 end; {Object..}


    { --------------------------------------- }


    GetCusMode1Cid  =  ^Cus1ExtSObjCid;

    Cus1ExtSObjCid   =  Object(ExtSNObjCid)


                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetCusObj3(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              FCusCode      :  Str10;
                                              FNomAuto      :  Boolean;
                                              FCr           :  Byte;
                                              FAlCode,
                                              FCSCode       :  Char);

                    Function  GetSearchRec3(B_Func,
                                              Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FCusCode  :  Str10;
                                              FNomAuto  :  Boolean;
                                              FCr       :  Byte;
                                              FAlCode   :  Char;
                                              FCSCode   :  Char)  :  Integer;

               end; {Object..}



  { --------------------------------------- }



Function GetExtBankM(ExtRecPtr,
                     ExtObjPtr  :  Pointer;
                     Fnum,
                     Keypath,
                     B_End      :  Integer;
                     Mode       :  Byte;
                 Var KeyS       :  Str255)  :  Integer;


Function GetExtBankMCid(ExtRecPtr,
                        ExtObjPtr  :  Pointer;
                        Fnum,
                        Keypath,
                        B_End      :  Integer;
                        Mode       :  Byte;
                    Var KeyS       :  Str255)  :  Integer;

Function ExtBankFiltCid(Mode       :  Integer;
                        RecPtr,
                        ExtObjPtr  :  Pointer):  Boolean;

Function GetExtBankR(ExtRecPtr,
                     ExtObjPtr  :  Pointer;
                     Fnum,
                     Keypath,
                     B_End      :  Integer;
                     Mode       :  Byte;
                 Var KeyS       :  Str255)  :  Integer;


Function ExtBankRFilt(Mode       :  Integer;
                      RecPtr,
                      ExtObjPtr  :  Pointer):  Boolean;


{$IFDEF STK}

  Function GetExtOSOrd(ExtRecPtr,
                       ExtObjPtr  :  Pointer;
                       Fnum,
                       Keypath,
                       B_End      :  Integer;
                       Mode       :  Byte;
                   Var KeyS       :  Str255)  :  Integer;

{$ENDIF}



  Function GetExtCusAL(ExtRecPtr,
                       ExtObjPtr  :  Pointer;
                       Fnum,
                       Keypath,
                       B_End      :  Integer;
                       Mode       :  Byte;
                   Var KeyS       :  Str255)  :  Integer;

  Function ExtCusFilt(Mode       :  Integer;
                      RecPtr     :  Pointer):  Boolean;

  Function GetExtCusALCid(ExtRecPtr,
                          ExtObjPtr  :  Pointer;
                          Fnum,
                          Keypath,
                          B_End      :  Integer;
                          Mode       :  Byte;
                      Var KeyS       :  Str255)  :  Integer;

  Function ExtCusFiltCid(Mode       :  Integer;
                         RecPtr,
                         ExtObjPtr  :  Pointer):  Boolean;


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   Dialogs,
   ETMiscU,
   ETStrU,
   ETDateU,
   ComnUnit,
   ComnU2,
   BTKeys1U,
   InvListU,

   SupListU,

   CurrncyU,

   {$IFDEF FRM}
     {$IFNDEF OLE}
       FrmThrdU,
     {$ENDIF}
    {$ENDIF}

   SysU1,
   SysU2,
   SQLUtils,
   BTSupU1,

   IniFiles;



Const
  NoExtTries  =  10; {* Number of times a get extended reject count status is retried *}
                     {* Number will be x 65535 records for each try *}
                     {* This value also needs changing in JHISTDDU *}
                     {* This value also needs changing in DOCSupU1 *}


//PR: 24/12/2014 ABSEXCH-14274 Allow Extended Btrieve retries to be taken from an ini file if available. If no ini file then
//                             reverts to the current NoExtTries value
  EXT_BTRIEVE_INI = 'ExchExt.ini';

var
  ExtendedBtrieveRetries : Integer;

//PR: 24/12/2014 ABSEXCH-14274
procedure LoadRetryCount;
begin
  with TIniFile.Create(SetDrive + EXT_BTRIEVE_INI) do
  Try
    ExtendedBtrieveRetries := ReadInteger('Search', 'Retries', NoExtTries);
  Finally
    Free;
  End;
end;


  { --------------------------------------- }


  Constructor ExtSNObj.Init;

  Begin

    New(SearchRec);

    LoadRetryCount;

  end;

  Destructor  ExtSNObj.Done;
  Begin

    Dispose(SearchRec);

  end;

  Procedure ExtSNObj.Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                   Var  ExtendTail  :  ExtendRepeatType;
                                        FileNum     :  Integer;
                                        FiltSize    :  Integer);

  Begin

    Prime_Filter(ExtendHead,ExtendTail,FileNum,FiltSize);

  end;


  {* This value also needs changing in JHistDDU *}
  {* This value also needs changing in DOCSupU1 *}

  Function  ExtsNObj.GetSearchRec(B_Func,
                                  Fnum,
                                  Keypath    :  Integer;
                                  DataLen    :  Integer;
                              Var GSearchRec :  SearchNPtr;
                              Var KeyS       :  Str255) :  Integer;
  Var
    FStatus  :  Integer;
    Tries    :  Byte;
    KeepTrying
             :  Boolean;

    TmpSRec  :  SearchNPtr;

  Begin
    Tries:=0;

    KeepTrying:=BOn;

    New(TmpSRec);

    TmpSRec^:=GSearchRec^;  {* Keep local copy of search record structure, as this gets modifed
                               by Btrieve, and if it fails will no longer be valid *}

    Repeat
      FStatus:=Find_VarRec(B_Func,F[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,Nil);

      If (FStatus=0) then
        Move(SearchRec^.ExtRec.ExtendRec,RecPtr[Fnum]^,FileRecLen[Fnum]);

      {If (Debug) and (Fstatus<>0) then
        Beep;}

      Inc(Tries);

      //PR: 24/12/2014 ABSEXCH-14274 Change to use new ExtendedBtrieveRetries variable
      KeepTrying:= (FStatus=60) and (Tries <= ExtendedBtrieveRetries);

      If KeepTrying then
        GSearchRec^:=TmpSRec^;

    Until (Not KeepTrying);


    Dispose(TmpSRec);

    GetSearchRec:=FStatus;

  end;


  { --------------------------------------- }


  Constructor ExtSNObjCid.Init;

  Begin

    New(SearchRec);

    MTExLocal:=nil;

    FillChar(DebtLetters,SizeOf(DebtLetters),0);

    LoadRetryCount;

  end;

  Destructor  ExtSNObjCid.Done;
  Begin

    Dispose(SearchRec);

  end;

  Procedure ExtSNObjCid.Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                      Var  ExtendTail  :  ExtendRepeatType;
                                           FileNum     :  Integer;
                                           FiltSize    :  Integer);

  Begin

    Prime_Filter(ExtendHead,ExtendTail,FileNum,FiltSize);

  end;



  Function  ExtSNObjCid.GetSearchRec(B_Func,
                                     Fnum,
                                     Keypath    :  Integer;
                                     DataLen    :  Integer;
                                 Var GSearchRec :  SearchNPtr;
                                 Var KeyS       :  Str255) :  Integer;
Var
    FStatus  :  Integer;
    Tries    :  Byte;
    KeepTrying
             :  Boolean;

    TmpSRec  :  SearchNPtr;

  Begin
    If (Assigned(MTExLocal)) then
    With MTExLocal^ do
    Begin
      Tries:=0;

      KeepTrying:=BOn;

      New(TmpSRec);

      TmpSRec^:=GSearchRec^;  {* Keep local copy of search record structure, as this gets modifed
                                 by Btrieve, and if it fails will no longer be valid *}

      Repeat
        FStatus:=Find_VarRec(B_Func,LocalF^[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,ExClientId);

        If (FStatus=0) then
          Move(SearchRec^.ExtRec.ExtendRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

        Inc(Tries);

        //PR: 24/12/2014 ABSEXCH-14274 Change to use new ExtendedBtrieveRetries variable
        KeepTrying:= (FStatus=60) and (Tries <= ExtendedBtrieveRetries);

        If KeepTrying then
          GSearchRec^:=TmpSRec^;

      Until (Not KeepTrying);


      Dispose(TmpSRec);


      GetSearchRec:=FStatus;
    end
    else
      GetSearchRec:=97;

  end;




  { --------------------------------------- }


  Constructor Nom1ExtSObj.Init;

  Begin

    ExtSNobj.Init;

  end;



  Destructor  Nom1ExtSObj.Done;
  Begin

    ExtSNObj.Done;

  end;


  Procedure Nom1ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FNomCode      :  LongInt;
                                        FYr,FPr,FNm   :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterN1 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN1));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);  {* Allow for *}

        FieldOffset:=GENomCode;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(FNomCode,Compare1,Sizeof(FNomCode));

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEPYr;

        If (Not (FYr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}

        LogicExpres:=1;

        Compare2:=Chr(FYr);

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEPPr;


        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=1;

        Compare3:=Chr(FPr);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEPNm;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare4:=Chr(FNm);

      end;

    end; {With..}

  end;


  Function  Nom1ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      FNomcode:  LongInt;
                                      FYr,FPr,
                                      FNm
                                              :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,FNomCode,FYr,FPr,FNm);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}



  Procedure Nom1ExtSObj.SetNomObj1CC(Var SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FYr,
                                         FPr,FNm       :  Byte;
                                         CCode         :  Str10;
                                         CCMode        :  Boolean);

  Var
    CCDpFilt  :  Str10;
    SetCCDep  :  Boolean;


  Begin
    SetCCDep  :=BOff;

    FillChar(CCDpFilt,Sizeof(CCDpFilt),#0);

    With SetSearchRec^.Filter.FilterN1CC do
    Begin

      SetNomObj1(SetSearchRec,Fnum,FNomCode,FYr,FPr,FNm);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=6;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN1CC);
      end;

      Term4.LogicExpres:=1;

      With Term5 do
      Begin

        FieldType:=BString;

        FieldLen:=Length(CCode);

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Blank(Compare5,Sizeof(Compare5));

        If CCMode then
          FieldOffset:=GECC+1
        else
          FieldOffSet:=GEDep+1;

        If (FieldLen<=ccKeyLen) then {* EN440CCDEP *}
        Begin
          Move(CCode[1],Compare5,FieldLen);
        end
        else {Its combined, search for first half}   {* EN440CCDEP *}
          Begin
            SetCCDep:=BOn;

            FieldLen:=ccKeyLen;

            FieldOffSet:=GEDep+1;

            If (CCMode) then
              CCDpFilt:=Copy(CCode,5,ccKeyLen)
            else
              CCDpFilt:=Copy(CCode,1,ccKeyLen);

            Move(CCDpFilt[1],Compare5,FieldLen);
          end;
      end;

      With Term6 do
      Begin
        FillChar(CCDpFilt,Sizeof(CCDpFilt),#0);

        FieldType:=BString;

        FieldLen:=ccKeyLen;

        FieldOffset:=GECC+1;

        LogicExpres:=0;

        Blank(Compare6,Sizeof(Compare6));

        If (SetCCDep) then
        Begin
          CompareCode:=1; {* Compare= *}

          If (Not CCMode) then
            CCDpFilt:=Copy(CCode,5,ccKeyLen)
          else
            CCDpFilt:=Copy(CCode,1,ccKeyLen);

          Move(CCDpFilt[1],Compare6,FieldLen);
        end
        else
        Begin
          CompareCode:=4;

          // When searching for Cost Centre only or Department only, store a
          // dummy value in Compare6. This should never be a valid Cost Centre
          // or Department.

          // CJS 2012-03-29: ABSEXCH-11806 - Transactions missing from
          // drill-down:
          //
          // Pervasive uses CHR(255) values as the dummy code. Under SQL this
          // does not work, because the emulator translates these into 'zzz', as
          // CHR(255) is outside the allowed collation character range. This
          // causes problems if a Cost Centre or Department code of 'ZZZ' is
          // used.

          {$IFDEF EXSQL}
          if SQLUtils.UsingSQLAlternateFuncs then
            FillChar(Compare6, sizeof(Compare6), #32)
          else
          {$ENDIF}
            FillChar(Compare6,sizeof(Compare6),NdxWeight);
        end;



      end;


    end; {With..}

  end;




  Function  Nom1ExtSObj.GetSearchRec2CC(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FYr,FPr,
                                        FNm     :  Byte;
                                        CCode   :  Str10;
                                        CCMode  :  Boolean)  :  Integer;



    Begin
      SetNomObj1CC(SearchRec,Fnum,FNomCode,FYr,FPr,FNm,CCode,CCMode);

      GetSearchRec2CC:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

    end; {Func..}



  { --------------------------------------- }



  Constructor Nom2ExtSObj.Init;

  Begin

    Nom1ExtSObj.Init;

  end;



  Destructor  Nom2ExtSObj.Done;
  Begin

    Nom1ExtSObj.Done;

  end;


  Procedure Nom2ExtSObj.SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                       Fnum          :  Integer;
                                       FNomCode      :  LongInt;
                                       FCr,FYr,
                                       FPr,FNm       :  Byte);


  Begin
    With SetSearchRec^.Filter.FilterN2 do
    Begin

      Nom1ExtSObj.SetNomObj1(SetSearchRec,Fnum,FNomCode,FYr,FPr,FNm);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=5;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN2);
      end;

      Term4.LogicExpres:=1;

      With Term5 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEPCr;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare5:=Chr(FCr);

      end;


    end; {With..}

  end;


  Function  Nom2ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      FNomcode:  LongInt;
                                      FCr,FYr,
                                      FPr,FNm
                                              :  Byte)  :  Integer;


  Begin
    SetNomObj1(SearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  Procedure Nom2ExtSObj.SetNomObj1CC(Var SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FCr,FYr,
                                         FPr,FNm       :  Byte;
                                         CCode         :  Str10;
                                         CCMode        :  Boolean);


  Var
    CCDpFilt  :  Str10;
    SetCCDep  :  Boolean;

  Begin
    FillChar(CCDpFilt,Sizeof(CCDpFilt),#0);
    SetCCDep:=BOff;

    With SetSearchRec^.Filter.FilterN2CC do
    Begin

      SetNomObj1(SetSearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=7;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN2CC);
      end;

      Term5.LogicExpres:=1;

      With Term6 do
      Begin
        FieldType:=BString;

        FieldLen:=Length(CCode);


        If CCMode then
          // CostCentre only, or CostCentre first
          FieldOffset:=GECC+1
        else
          // Department only, or Department first
          FieldOffSet:=GEDep+1;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Blank(Compare6,Sizeof(Compare6));

        If (FieldLen<=ccKeyLen) then {* EN440CCDEP *}
        Begin
          // CostCentre or Department only.
          Move(CCode[1],Compare6,FieldLen);
        end
        else
          { Filter for both Cost Centre and Department. Store the first code
            in Compare6, and the second code in Compare7. The CCMode tells us
            which order they are in (True = Cost Centre first, False =
            Department first). }   {* EN440CCDEP *}
          Begin
            // Set a flag to indicate (for Compare7) that we are filtering for
            // both Cost Centre and Department
            SetCCDep:=BOn;

            FieldLen:=ccKeyLen;

            // For combined filters, Compare6 always holds the Department code
            FieldOffSet:=GEDep+1;

            // Use the CCMode flag to determine where to read the Department
            // code from.
            If (CCMode) then
              CCDpFilt:=Copy(CCode,5,ccKeyLen)
            else
              CCDpFilt:=Copy(CCode,1,ccKeyLen);

            Move(CCDpFilt[1],Compare6,FieldLen);
          end;

      end;

      With Term7 do
      Begin
        FillChar(CCDpFilt,Sizeof(CCDpFilt),#0);

        FieldType:=BString;

        FieldLen:=ccKeyLen;

        // For combined filters, Compare7 always holds the Cost Centre code (if
        // we are searching for Cost Centre only or Department only, the code
        // will be in Compare6 and Compare7 will hold a dummy value).
        FieldOffset:=GECC+1;

        LogicExpres:=0;

        Blank(Compare7,Sizeof(Compare7));

        If (SetCCDep) then
        Begin
          CompareCode:=1; {* Compare= *}

          // Use the CCMode flag to determine where to read the Cost Centre
          // code from.
          If (Not CCMode) then
            CCDpFilt:=Copy(CCode,5,ccKeyLen)
          else
            CCDpFilt:=Copy(CCode,1,ccKeyLen);

          Move(CCDpFilt[1],Compare7,FieldLen);
        end
        else
        Begin
          CompareCode:=4;

          // When searching for Cost Centre only or Department only, store a
          // dummy value in Compare7. This should never be a valid Cost Centre
          // or Department.

          // CJS 2012-03-21: ABSEXCH-11806 - Transactions missing from
          // drill-down:
          //
          // Pervasive uses CHR(255) values as the dummy code. Under SQL this
          // does not work, because the emulator translates these into 'zzz', as
          // CHR(255) is outside the allowed collation character range. This
          // causes problems if a Cost Centre or Department code of 'ZZZ' is
          // used.

          {$IFDEF EXSQL}
          if SQLUtils.UsingSQLAlternateFuncs then
            FillChar(Compare7, sizeof(Compare7), #32)
          else
          {$ENDIF}
            FillChar(Compare7,sizeof(Compare7),NdxWeight);
        end;



      end;

    end; {With..}

  end;



  Function  Nom2ExtSObj.GetSearchRec2CC(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FCr,FYr,
                                        FPr,FNm :  Byte;
                                        CCode   :  Str10;
                                        CCMode  :  Boolean)  :  Integer;


  Begin
    SetNomObj1CC(SearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm,CCode,CCMode);

    GetSearchRec2CC:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  Procedure Nom2ExtSObj.SetNomObj3CC(Var SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FCr,FNm       :  Byte;
                                         CCode         :  Str10;
                                         CCMode        :  Boolean);


  Begin
    With SetSearchRec^.Filter.FilterN2CC do
    Begin

      SetNomObj1CC(SetSearchRec,Fnum,FNomCode,FCr,YTD,YTD,FNm,CCode,CCMode);

      Prime_TailFilter(ExtendTail,Fnum);


      If (FCr=0) then
        Term5.CompareCode:=5;  {* >= *}


    end; {With..}

  end;



  Function  Nom2ExtSObj.GetSearchRec3CC(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FCr,FNm :  Byte;
                                        CCode   :  Str10;
                                        CCMode  :  Boolean)  :  Integer;


  Begin
    SetNomObj3CC(SearchRec,Fnum,FNomCode,FCr,FNm,CCode,CCMode);

    GetSearchRec3CC:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


    Procedure Nom2ExtSObj.SetNomObj1RD(Var SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FCr,FYr,
                                         FPr,FNm       :  Byte;
                                         CCode         :  LongDate);


  Begin
    With SetSearchRec^.Filter.FilterN2RD do
    Begin

      SetNomObj1(SetSearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=6;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN2RD);
      end;

      {$IFDEF MC_On}
        If (FCr=0) then
          Term5.CompareCode:=5; {* >= *}
      {$ENDIF}

      Term5.LogicExpres:=1;

      With Term6 do
      Begin
        FieldType:=BString;

        FieldLen:=Length(CCode);

        FieldOffSet:=GEIDRD;

        CompareCode:=5; {* Compare >= *}
        LogicExpres:=0;

        Blank(Compare6,Sizeof(Compare6));

        Move(CCode[1],Compare6,FieldLen);

      end;


    end; {With..}

  end;



  Function  Nom2ExtSObj.GetSearchRec2RD(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FCr,FYr,
                                        FPr,FNm :  Byte;
                                        CCode   :  LongDate)  :  Integer;


  Begin
    SetNomObj1RD(SearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm,CCode);

    GetSearchRec2RD:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  Procedure Nom2ExtSObj.SetNomObj1CCRD(Var SetSearchRec  :  SearchNPtr;
                                           Fnum          :  Integer;
                                           FNomCode      :  LongInt;
                                           FCr,FYr,
                                           FPr,FNm       :  Byte;
                                           CCode         :  Str10;
                                           CCMode        :  Boolean;
                                           RDate         :  LongDate);


  Begin
    With SetSearchRec^.Filter.FilterN2CCRD do
    Begin

      SetNomObj1CC(SetSearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm,CCode,CCMode);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=8;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN2CCRD);
      end;

      {$IFDEF MC_On}
        If (FCr=0) then
          Term5.CompareCode:=5; {* >= *}
      {$ENDIF}

      {If (FCr=0) then
        Term5.CompareCode:=5; {* >= *}

      Term7.LogicExpres:=1;

      With Term8 do
      Begin
        FieldType:=BString;

        FieldLen:=Length(RDate);

        FieldOffSet:=GEIDRD;

        CompareCode:=5; {* Compare >= *}
        LogicExpres:=0;

        Blank(Compare8,Sizeof(Compare8));

        Move(RDate[1],Compare8,FieldLen);

      end;


    end; {With..}

  end;



  Function  Nom2ExtSObj.GetSearchRec2CCRD(B_Func,
                                          Fnum,
                                          Keypath :  Integer;
                                      Var KeyS    :  Str255;
                                          FNomcode:  LongInt;
                                          FCr,FYr,
                                          FPr,FNm :  Byte;
                                          CCode   :  Str10;
                                          CCMode  :  Boolean;
                                          RDate   :  LongDate)  :  Integer;


  Begin
    SetNomObj1CCRD(SearchRec,Fnum,FNomCode,FCr,FYr,FPr,FNm,CCode,CCMode,RDate);

    GetSearchRec2CCRD:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}




  { --------------------------------------- }


  Constructor Nom3ExtSObj.Init;

  Begin

    ExtSNobj.Init;

  end;



  Destructor  Nom3ExtSObj.Done;
  Begin

    ExtSNObj.Done;

  end;


  Procedure Nom3ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FNomCode      :  LongInt;
                                        FDesc         :  Str60;
                                        FCr,FNm       :  Byte;
                                   Var  ReduceX       :  Byte);


  Begin
    With SetSearchRec^.Filter.FilterN3 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN3));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);  {* Allow for *}

        FieldOffset:=GENomCode;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(FNomCode,Compare1,Sizeof(FNomCode));

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEPCr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare2:=Chr(FCr);

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEPNm;


        CompareCode:=1; {* Compare= *}

        LogicExpres:=1;

        Compare3:=Chr(FNm);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Length(FDesc);

        FieldOffset:=GEIdDe;
        CompareCode:=1+B_SExComp3;   {* Compare= (Ignore case) *}
        LogicExpres:=0;

        Blank(Compare4,Sizeof(Compare4));

        Move(FDesc[1],Compare4,FieldLen);

        {* Explanatory note. Because the CQ No./Bank descritpion is sometimes
           padded out, and often depending on the document different lengths, it
           is not possible to use a fixed length comparison of 60 chars (the size of the
           field. So The comapre4 is set to 60, but the field length is set to the length
           of the comparing String. Extentail is then moved up the record so as to shrink
           the size of the comparison and fooling BT that compare record stucture has
           shrunk. Bit of a bodge, but the only way around TP rigid record
           structures. *}

        If (FieldLen<Sizeof(Compare4)) then
        Begin
          Move(ExtendTail,Compare4[Succ(FieldLen)],Sizeof(ExtendTail));
          Blank(ExtendTail,Sizeof(ExtendTail));
          ReduceX:=Sizeof(Compare4)-FieldLen;

        end;


        ExtendHead.DescLen:=ExtendHead.DescLen-ReduceX;


      end;

    end; {With..}

  end;


  Function  Nom3ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      FNomcode:  LongInt;
                                      FDesc   :  Str60;
                                      FCr,FNm
                                              :  Byte)  :  Integer;

  Var
    ReduceX  :  Byte;

  Begin
    ReduceX:=0;

    SetNomObj1(SearchRec,Fnum,FNomCode,FDesc,FCr,FNm,ReduceX);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,(Sizeof(SearchRec^)-ReduceX),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }



  Constructor Nom3ExtSObjCid.Init;

  Begin

    ExtSNobjCid.Init;

  end;



  Destructor  Nom3ExtSObjCid.Done;
  Begin

    ExtSNObjCid.Done;

  end;


  Procedure Nom3ExtSObjCid.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                           Fnum          :  Integer;
                                           FNomCode      :  LongInt;
                                           FDesc         :  Str60;
                                           FCr,FNm       :  Byte;
                                      Var  ReduceX       :  Byte);


  Begin
    With SetSearchRec^.Filter.FilterN3 do
    Begin
      ExtSNObjCid.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN3));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);  {* Allow for *}

        FieldOffset:=GENomCode;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(FNomCode,Compare1,Sizeof(FNomCode));

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEPCr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare2:=Chr(FCr);

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEPNm;


        CompareCode:=1; {* Compare= *}

        LogicExpres:=1;

        Compare3:=Chr(FNm);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Length(FDesc);

        FieldOffset:=GEIdDe;
        CompareCode:=1+B_SExComp3;   {* Compare= (Ignore case) *}
        LogicExpres:=0;

        Blank(Compare4,Sizeof(Compare4));

        Move(FDesc[1],Compare4,FieldLen);

        {* Explanatory note. Because the CQ No./Bank descritpion is sometimes
           padded out, and often depending on the document different lengths, it
           is not possible to use a fixed length comparison of 60 chars (the size of the
           field. So The comapre4 is set to 60, but the field length is set to the length
           of the comparing String. Extentail is then moved up the record so as to shrink
           the size of the comparison and fooling BT that compare record stucture has
           shrunk. Bit of a bodge, but the only way around TP rigid record
           structures. *}

        If (FieldLen<Sizeof(Compare4)) then
        Begin
          Move(ExtendTail,Compare4[Succ(FieldLen)],Sizeof(ExtendTail));
          Blank(ExtendTail,Sizeof(ExtendTail));
          ReduceX:=Sizeof(Compare4)-FieldLen;

        end;


        ExtendHead.DescLen:=ExtendHead.DescLen-ReduceX;


      end;

    end; {With..}

  end;


  Function  Nom3ExtSObjCid.GetSearchRec2(B_Func,
                                         Fnum,
                                         Keypath :  Integer;
                                     Var KeyS    :  Str255;
                                         FNomcode:  LongInt;
                                         FDesc   :  Str60;
                                         FCr,FNm
                                                 :  Byte)  :  Integer;

  Var
    ReduceX  :  Byte;

  Begin
    ReduceX:=0;

    SetNomObj1(SearchRec,Fnum,FNomCode,FDesc,FCr,FNm,ReduceX);

    GetSearchRec2:=ExtSNObjCid.GetSearchRec(B_Func,Fnum,Keypath,(Sizeof(SearchRec^)-ReduceX),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }






  Constructor Nom32ExtSObj.Init;

  Begin

    Nom3ExtSObj.Init;

  end;



  Destructor  Nom32ExtSObj.Done;
  Begin

    Nom3ExtSObj.Done;

  end;


  Procedure Nom32ExtSObj.SetNomObj2(Var  SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FCr,FNm,RMd   :  Byte);

  Var
    ReduceX  :  Byte;

  Begin

    ReduceX:=0;

    With SetSearchRec^.Filter.FilterN4 do
    Begin
      Nom3ExtSObj.SetNomObj1(SearchRec,Fnum,FNomCode,'',FCr,FNm,ReduceX);

      Prime_TailFilter(ExtendTail,Fnum);

      With ExtendHead do
      Begin
        NumTerms:=4;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN4);
      end;


      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEIDRC;


        CompareCode:=1; {* Compare= *}

        LogicExpres:=0;

        Compare4:=Chr(RMd);

      end;


    end; {With..}

  end;


  Function  Nom32ExtSObj.GetSearchRec32(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FCr,FNm,RMd
                                                :  Byte)  :  Integer;


  Begin

    SetNomObj2(SearchRec,Fnum,FNomCode,FCr,FNm,RMd);

    GetSearchRec32:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }



   Constructor Nom32ExtSObjCid.Init;

  Begin

    Nom3ExtSObjCid.Init;

  end;



  Destructor  Nom32ExtSObjCid.Done;
  Begin

    Nom3ExtSObjCid.Done;

  end;


  Procedure Nom32ExtSObjCid.SetNomObj2(Var  SetSearchRec  :  SearchNPtr;
                                         Fnum          :  Integer;
                                         FNomCode      :  LongInt;
                                         FCr,FNm,RMd   :  Byte);

  Var
    ReduceX  :  Byte;

  Begin

    ReduceX:=0;

    With SetSearchRec^.Filter.FilterN4 do
    Begin
      Nom3ExtSObjCid.SetNomObj1(SearchRec,Fnum,FNomCode,'',FCr,FNm,ReduceX);

      Prime_TailFilter(ExtendTail,Fnum);

      With ExtendHead do
      Begin
        NumTerms:=4;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterN4);
      end;


      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEIDRC;


        CompareCode:=1; {* Compare= *}

        LogicExpres:=0;

        Compare4:=Chr(RMd);

      end;


    end; {With..}

  end;


  Function  Nom32ExtSObjCid.GetSearchRec32(B_Func,
                                        Fnum,
                                        Keypath :  Integer;
                                    Var KeyS    :  Str255;
                                        FNomcode:  LongInt;
                                        FCr,FNm,RMd
                                                :  Byte)  :  Integer;


  Begin

    SetNomObj2(SearchRec,Fnum,FNomCode,FCr,FNm,RMd);

    GetSearchRec32:=ExtSNObjCid.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

{$IFDEF STK}

  Constructor Nom4ExtSObj.Init;

  Begin

    ExtSNobj.Init;

  end;



  Destructor  Nom4ExtSObj.Done;
  Begin

    ExtSNObj.Done;

  end;


  Procedure Nom4ExtSObj.SetNomObj1(Var SetSearchRec  :  SearchNPtr;
                                       Fnum          :  Integer;
                                       FLineTyp      :  Char;
                                       FCCode        :  Str10);


  Begin
    With SetSearchRec^.Filter.FilterN5 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN5));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Id.LineType);  {* Allow for *}

        FieldOffset:=GEIDLT;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1:=FLineTyp;

      end;


      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Length(FCCode);

        FieldOffset:=GEIDCu;
        CompareCode:=1+B_SExComp3;   {* Compare= (Ignore case) *}
        LogicExpres:=1;

        Blank(Compare2,Sizeof(Compare2));

        Move(FCCode[1],Compare2,FieldLen);


      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEStkC;
        CompareCode:=4; {<> Blank}
        LogicExpres:=1;

        FillChar(Compare3,Sizeof(Compare3),#32);


      end;

      With Term4 do
      Begin

        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEIDLN;
        CompareCode:=4; {<> -1, ie not BOM item}
        LogicExpres:=0;

        Compare4:=DocNotCnst;


      end;

    end; {With..}

  end;


  Function  Nom4ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FLineTyp  :  Char;
                                      FCCode    :  Str10) :  Integer;

  Begin

    SetNomObj1(SearchRec,Fnum,FLineTyp,FCCode);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,(Sizeof(SearchRec^)),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

{$ENDIF}

  Constructor Stk1ExtSObj.Init;

  Begin

    Nom2ExtSObj.Init;

  end;



  Destructor  Stk1ExtSObj.Done;
  Begin

    Nom2ExtSObj.Done;

  end;


  Procedure Stk1ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FStkCode      :  Str20;
                                        FPostedRun    :  LongInt;
                                        FYr,FPr       :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterS1 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterS1));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Pred(Sizeof(Id.StockCode));  {* Do not Allow for Length byte on this search
                                                  as otherwise it is not recognised as a key field,
                                                  and will search to the end of the file for a match. *}

        FieldOffset:=GEStkC;

        Blank(Compare1,Sizeof(Compare1));

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(FStkCode[1],Compare1,Ord(FStkCode[0]));

        {Compare1:=FStkCode;}

      end;

      With Term2 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEPostedRun;
        CompareCode:=2; {* Compare > 0  (only posted items) *}
        LogicExpres:=1;

        Compare2:=FPostedRun;

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEPYr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare3:=Chr(FYr);

      end;


      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEPPr;

        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}

        LogicExpres:=0;

        Compare4:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Stk1ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FStkCode      :  Str20;
                                      FPostedRun    :  LongInt;
                                      FYr,FPr       :  Byte)  :  Integer;



  Begin
    SetStkObj1(SearchRec,Fnum,FStkCode,FpostedRun,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}



  { --------------------------------------- }



  Constructor Stk2ExtSObj.Init;

  Begin

    Stk1ExtSObj.Init;

  end;



  Destructor  Stk2ExtSObj.Done;
  Begin

    Stk1ExtSObj.Done;

  end;


  Procedure Stk2ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FStkCode      :  Str20;
                                        FPostedRun    :  LongInt;
                                        FCr,FYr,FPr   :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterS2 do
    Begin

      Stk1ExtSObj.SetStkObj1(SearchRec,Fnum,FStkCode,FpostedRun,FYr,FPr);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=5;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterS2);
      end;

      Term4.LogicExpres:=1;

      With Term5 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEPCr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare5:=Chr(FCr);

      end;

    end; {With..}

  end;


  Function  Stk2ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FStkCode      :  Str20;
                                      FPostedRun    :  LongInt;
                                      FCr,FYr,FPr   :  Byte)  :  Integer;



  Begin
    SetStkObj1(SearchRec,Fnum,FStkCode,FpostedRun,FCr,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

  Constructor Stk3ExtSObj.Init;

  Begin

    Stk2ExtSObj.Init;

  end;



  Destructor  Stk3ExtSObj.Done;
  Begin

    Stk2ExtSObj.Done;

  end;



  Procedure Stk3ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FStkCode      :  Str20;
                                        FCustCode     :  Str10;
                                        FPostedRun    :  LongInt;
                                        FCr,FYr,FPr   :  Byte;
                                        FIsaC         :  Boolean);



  Begin
    With SetSearchRec^.Filter.FilterS3 do
    Begin

      Stk1ExtSObj.SetStkObj1(SearchRec,Fnum,FStkCode,FpostedRun,FYr,FPr);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=6;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterS3);
      end;


      With Term1 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);

        FieldOffset:=GEIDLT;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        {$IFDEF STK}

        If (FIsaC) then
          Compare1:=StkLineType[SIN]
        else
          Compare1:=StkLineType[PIN];

        {$ENDIF}
      end;

      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEIDCu;
        CompareCode:=1+B_SExComp3; {* Compare= *}
        LogicExpres:=1;

        Blank(Compare2,Sizeof(Compare2));

        Move(FCustCode[1],Compare2,Ord(FCustCode[0]));

      end;


      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Pred(Sizeof(Id.StockCode));  {* Do not Allow for Length byte on this search
                                                  as otherwise it is not recognised as a key field,
                                                  and will search to the end of the file for a match. *}

        FieldOffset:=GEStkC;

        Blank(Compare3,Sizeof(Compare3));

        CompareCode:=1+B_SExComp3; {* Compare= *}
        LogicExpres:=1;

        Move(FStkCode[1],Compare3,Ord(FStkCode[0]));

        {Compare1:=FStkCode;}

      end;

      With Term4 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEPostedRun;
        CompareCode:=2; {* Compare > 0  (only posted items) *}
        LogicExpres:=1;

        Compare4:=FPostedRun;

      end;

      With Term5 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEPYr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare5:=Chr(FYr);

      end;


      With Term6 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare6);

        FieldOffset:=GEPPr;

        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}

        LogicExpres:=0;


        Compare6:=Chr(FPr);

      end;


    end; {With..}

  end;


  Function  Stk3ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FStkCode      :  Str20;
                                      FCustCode     :  Str10;
                                      FPostedRun    :  LongInt;
                                      FCr,FYr,FPr   :  Byte;
                                      FIsaC         :  Boolean)  :  Integer;



  Begin
    SetStkObj1(SearchRec,Fnum,FStkCode,FCustCode,FpostedRun,FCr,FYr,FPr,FIsaC);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }


  Constructor Stk4ExtSObj.Init;

  Begin

    Stk3ExtSObj.Init;

  end;



  Destructor  Stk4ExtSObj.Done;
  Begin

    Stk3ExtSObj.Done;

  end;


  Procedure Stk4ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FStkCode      :  Str20;
                                        FCustCode     :  Str10;
                                        FPostedRun    :  LongInt;
                                        FCr,FYr,FPr   :  Byte;
                                        FIsaC         :  Boolean);



  Begin
    With SetSearchRec^.Filter.FilterS4 do
    Begin

      Stk3ExtSObj.SetStkObj1(SearchRec,Fnum,FStkCode,FCustCode,FpostedRun,FCr,FYr,FPr,FIsaC);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=7;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterS4);
      end;

      Term6.LogicExpres:=1;

      With Term7 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare7);

        FieldOffset:=GEPCr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;


        Compare7:=Chr(FCr);

      end;

    end; {With..}

  end;


  Function  Stk4ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FStkCode      :  Str20;
                                      FCustCode     :  Str10;
                                      FPostedRun    :  LongInt;
                                      FCr,FYr,FPr   :  Byte;
                                      FIsaC         :  Boolean)  :  Integer;



  Begin
    SetStkObj1(SearchRec,Fnum,FStkCode,FCustCode,FpostedRun,FCr,FYr,FPr,FIsaC);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }



  Constructor Cus1ExtSObj.Init;

  Begin

    Stk4ExtSObj.Init;

  end;



  Destructor  Cus1ExtSObj.Done;
  Begin

    Stk4ExtSObj.Done;

  end;


  Procedure Cus1ExtSObj.SetCusObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FCusCode      :  Str10;
                                        FNomAuto      :  Boolean;
                                        FYr,FPr       :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterC1 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterC1));


      With ExtendHead do
      Begin
        NumTerms:=3;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Do not Allow for Length byte on this search  *}

        FieldOffset:=GECu;

        CompareCode:=1+B_SExComp1; {* Compare= (Must specify AltColSeq or will not recognise
                                                this as part of field. In order for the Extended search
                                                to accept a compare is part of the field, the following
                                                must match: POS,Len, use of Altcolseq, Type. *}
        LogicExpres:=1;

        {Compare1:=FCusCode;}

        Move(FCusCode[1],Compare1,Ord(FCusCode[0]));

      end;


      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEIYr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare2:=Chr(FYr);

      end;



      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEIPr;

        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}

        LogicExpres:=0;

        Compare3:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Cus1ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FCusCode      :  Str10;
                                      FNomAuto      :  Boolean;
                                      FYr,FPr       :  Byte)  :  Integer;


  Begin
    SetCusObj1(SearchRec,Fnum,FCusCode,FNomAuto,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}



  { --------------------------------------- }



  Constructor Cus2ExtSObj.Init;

  Begin

    Cus1ExtSObj.Init;

  end;



  Destructor  Cus2ExtSObj.Done;
  Begin

    Cus1ExtSObj.Done;

  end;


  {* This mode not used... Ledger uses normal filter for currency *}


  Procedure Cus2ExtSObj.SetCusObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FCusCode      :  Str10;
                                        FNomAuto      :  Boolean;
                                        FCr,FYr,FPr   :  Byte);







  Begin
    With SetSearchRec^.Filter.FilterC2 do
    Begin

      Cus1ExtSObj.SetCusObj1(SearchRec,Fnum,FCusCode,FNomAuto,FYr,FPr);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=4;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterC2);
      end;

      Term3.LogicExpres:=1;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEICr;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare4:=Chr(FCr);

      end;

    end; {With..}

  end;


  Function  Cus2ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FCusCode      :  Str10;
                                      FNomAuto      :  Boolean;
                                      FCr,FYr,
                                      FPr       :  Byte)  :  Integer;

  Begin
    SetCusObj1(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}



  Procedure Cus2ExtSObj.SetCusObj3(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FCusCode      :  Str10;
                                        FNomAuto      :  Boolean;
                                        FCr           :  Byte;
                                        FAlCode       :  Char);








  Begin
    With SetSearchRec^.Filter.FilterC1 do
    Begin

      Cus1ExtSObj.SetCusObj1(SearchRec,Fnum,FCusCode,FNomAuto,0,0);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=3;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterC1);
      end;

      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEICr;


          If (FCr=0) then
          Begin

            CompareCode:=4;  {* Compare<> *}

            Compare2:=NdxWeight;
          end
          else
          Begin

            CompareCode:=1; {* Compare= *}

            Compare2:=Chr(FCr);

          end;


        LogicExpres:=1;

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEIAl;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare3:=FAlCode;

      end;

    end; {With..}

  end;


  Function  Cus2ExtSObj.GetSearchRec3(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FCusCode  :  Str10;
                                      FNomAuto  :  Boolean;
                                      FCr       :  Byte;
                                      FAlCode   :  Char)  :  Integer;

  Begin
    SetCusObj3(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FAlCode);

    GetSearchRec3:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


{$IFDEF EX32} {... original version}
  Procedure Cus2ExtSObj.SetCusObj4(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        FCusCode      :  Str10;
                                        FNomAuto      :  Boolean;
                                        FCr           :  Byte;
                                        FAlCode       :  Char;
                                        FAlDate       :  LongDate);








  Begin
    With SetSearchRec^.Filter.FilterC3 do
    Begin

      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterC3));

      {Cus2ExtSObj.SetCusObj3(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FALCode);}

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=4;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterC3);
      end;



      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Do not Allow for Length byte on this search  *}

        FieldOffset:=GECu;

        CompareCode:=1+B_SExComp1; {* Compare= (Must specify AltColSeq or will not recognise
                                                this as part of field. In order for the Extended search
                                                to accept a compare is part of the field, the following
                                                must match: POS,Len, use of Altcolseq, Type. *}
        LogicExpres:=1;

        {Compare1:=FCusCode;}

        Move(FCusCode[1],Compare1,Ord(FCusCode[0]));

      end;

      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEICr;


          If (FCr=0) then
          Begin

            CompareCode:=4+B_SExComp1;  {* Compare<> *}

            Compare2:=NdxWeight;
          end
          else
          Begin

            CompareCode:=1+B_SExComp1; {* Compare= *}

            Compare2:=Chr(FCr);

          end;


        LogicExpres:=1;

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEIAl;
        CompareCode:=1+B_SExComp1; {* Compare= *}
        LogicExpres:=2;

        Compare3:=FAlCode;

      end;


      {With Term3 do
      Begin

        LogicExpres:=2;

      end;}

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEIAD;
        CompareCode:=1+B_SExComp1; {* Compare= *}
        LogicExpres:=0;

        Move(FAlDate[1],Compare4,Ord(FAlDate[0]));

      end;

    end; {With..}

  end;

{$ENDIF}


Procedure Cus2ExtSObj.SetCusObj4(Var  SetSearchRec  :  SearchNPtr;
                                      Fnum          :  Integer;
                                      FCusCode      :  Str10;
                                      FNomAuto      :  Boolean;
                                      FCr           :  Byte;
                                      FAlCode       :  Char;
                                      FAlDate       :  LongDate);








Begin
  With SetSearchRec^.Filter.FilterC3 do
  Begin

    {ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterC3));}

    Cus2ExtSObj.SetCusObj3(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FALCode);

    Prime_TailFilter(ExtendTail,Fnum);


    With ExtendHead do
    Begin
      NumTerms:=4;

      DescLen:=Sizeof(SetSearchRec^.Filter.FilterC3);
    end;




    With Term3 do
    Begin

      FieldType:=BBoolean;

      FieldLen:=Sizeof(Compare3);

      FieldOffset:=GEINA;
      CompareCode:=1; {* Compare= *}
      LogicExpres:=1;

      Compare3:=FNomAuto;

    end;


    {With Term3 do
    Begin

      LogicExpres:=2;

    end;}


    With Term4 do
    Begin

      FieldType:=BString;

      FieldLen:=Sizeof(Compare4);

      FieldOffset:=GEIAD;
      CompareCode:=5; {* Compare >= *}
      LogicExpres:=0;

      Move(FAlDate[1],Compare4,Ord(FAlDate[0]));

    end;



  end; {With..}

end;



  Function  Cus2ExtSObj.GetSearchRec4(B_Func,
                                      Fnum,
                                      Keypath   :  Integer;
                                  Var KeyS      :  Str255;
                                      FCusCode  :  Str10;
                                      FNomAuto  :  Boolean;
                                      FCr       :  Byte;
                                      FAlCode   :  Char;
                                      FAlDate   :  LongDate)  :  Integer;

  Begin
    SetCusObj4(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FAlCode,FAlDate);

    Result:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

  { NomExtSObj Methods }

  { --------------------------------------- }


  Constructor NomExtSObj.Init;

  Begin

    Cus2ExtSObj.Init;

  end;



  Destructor  NomExtSObj.Done;
  Begin

    Cus2ExtSObj.Done;

  end;



 Function  NomExtSObj.GetSearchRec(B_Func,
                                    Fnum,
                                    Keypath   :  Integer;
                                Var KeyS      :  Str255;
                                    FNomcode  :  LongInt;
				    FCr,FYr,
                                    FPr,FNm,
                                    Mode      :  Byte;
                                    CCode     :  Str10;
                                    RDate     :  LongDate)  :  Integer;




  Begin
    Result := 0;
    Case Mode of

      1    :  GetSearchRec:=Nom1ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FNomCode,FYr,FPr,FNm);
      11,12:  GetSearchRec:=Nom1ExtSObj.GetSearchRec2CC(B_Func,Fnum,Keypath,KeyS,FNomCode,FYr,FPr,FNm,CCode,(Mode=12));


      2    :  GetSearchRec:=Nom2ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,FYr,FPr,FNm);
      22,23:  GetSearchRec:=Nom2ExtSObj.GetSearchRec2CC(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,FYr,FPr,FNm,CCode,(Mode=23));
      31..49
           :  GetSearchRec:=Nom2ExtSObj.GetSearchRec3CC(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,FNm,CCode,(Mode In [32,43]));

      101,102
           :  GetSearchRec:=Nom2ExtSObj.GetSearchRec2RD(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,FYr,FPr,FNm,RDate);

      111,112,
      122,123
           :  GetSearchRec:=Nom2ExtSObj.GetSearchRec2CCRD(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,FYr,FPr,FNm,
                                                          CCode,(Mode In [112,123]),RDate);

      131..149
           :  GetSearchRec:=Nom2ExtSObj.GetSearchRec2CCRD(B_Func,Fnum,Keypath,KeyS,FNomCode,FCr,YTD,YTD,FNm,
                                                          CCode,(Mode In [132,143]),RDate);


    end; {Case..}

  end; {Func..}


  Function  NomExtSObj.GetSearchRec2(B_Func,
                                     Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
                                     FStkcode  :  Str20;
                                     FCustCode :  Str10;
                                     FIsaC     :  Boolean;
                                     FPostedRun:  LongInt;
				     FCr,FYr,
                                     FPr,
                                     Mode      :  Byte)  :  Integer;



  Begin
    Result := 0;
    Case Mode of

      1    :  GetSearchRec2:=Stk1ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FStkCode,FPostedRun,FYr,FPr);

      2    :  GetSearchRec2:=Stk2ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FStkCode,FPostedRun,FCr,FYr,FPr);

      3    :  GetSearchRec2:=Stk3ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FStkCode,FCustCode,FPostedRun,FCr,
                                                       FYr,FPr,FIsaC);
      4    :  GetSearchRec2:=Stk4ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FStkCode,FCustCode,FPostedRun,
                                                       FCr,FYr,FPr,FIsaC);

    end; {Case..}

  end; {Func..}




  Function  NomExtSObj.GetSearchRec3(B_Func,
                                     Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
                                     FCuscode  :  Str10;
                                     FNomAuto  :  Boolean;
                                     FAlCode   :  Char;
                                     FAlDate   :  LongDate;
				     FCr,FYr,
                                     FPr,
                                     Mode      :  Byte)  :  Integer;




  Begin
    Result := 0;
    Case Mode of

      1    :  GetSearchRec3:=Cus1ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FCusCode,FNomAuto,FYr,FPr);

      2    :  GetSearchRec3:=Cus2ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,FCusCode,FNomAuto,FCr,FYr,FPr);

      3    :  GetSearchRec3:=Cus2ExtSObj.GetSearchRec3(B_Func,Fnum,Keypath,KeyS,FCusCode,FNomAuto,FCr,FAlCode);

      4    :  GetSearchRec3:=Cus2ExtSObj.GetSearchRec4(B_Func,Fnum,Keypath,KeyS,FCusCode,FNomAuto,FCr,FAlCode,FAlDate);

    end; {Case..}

  end; {Func..}




  { --------------------------------------- }


  { --------------------------------------- }

  { Cus1ExtSObjCid Methods }

  { --------------------------------------- }

  Constructor Cus1ExtSObjCid.Init;

  Begin

    ExtSNObjCid.Init;

    FillChar(DebtLetters,Sizeof(DebtLetters),0);

  end;



  Destructor  Cus1ExtSObjCid.Done;
  Begin

    ExtSNObjCid.Done;

  end;




  Procedure Cus1ExtSObjCid.SetCusObj3(Var  SetSearchRec  :  SearchNPtr;
                                           Fnum          :  Integer;
                                           FCusCode      :  Str10;
                                           FNomAuto      :  Boolean;
                                           FCr           :  Byte;
                                           FAlCode,
                                           FCSCode       :  Char);


  Begin
    With SetSearchRec^.Filter.FilterC1CId do
    Begin

      ExtSNObjCid.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterC1CId));

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        NumTerms:=4;

        DescLen:=Sizeof(SetSearchRec^.Filter.FilterC1CId);
      end;


      With Term2 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEICS;
        CompareCode:=1+B_SExComp1; {* Compare= (Must specify AltColSeq or will not recognise
                                                this as part of field. In order for the Extended search
                                                to accept a compare is part of the field, the following
                                                must match: POS,Len, use of Altcolseq, Type. *}
        LogicExpres:=1;

        Compare2:=FCSCode;

      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Do not Allow for Length byte on this search  *}

        FieldOffset:=GECu;

        CompareCode:=1+B_SExComp1; {* Compare= (Must specify AltColSeq or will not recognise
                                                this as part of field. In order for the Extended search
                                                to accept a compare is part of the field, the following
                                                must match: POS,Len, use of Altcolseq, Type. *}
        LogicExpres:=1;

        {Compare1:=FCusCode;}

        Move(FCusCode[1],Compare1,Ord(FCusCode[0]));

      end;

      With Term3 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEICr;


          If (FCr=0) then
          Begin

            CompareCode:=4;  {* Compare<> *}

            Compare3:=NdxWeight;
          end
          else
          Begin

            CompareCode:=1; {* Compare= *}

            Compare3:=Chr(FCr);

          end;


        LogicExpres:=1;

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEIAl;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare4:=FAlCode;

      end;

    end; {With..}

  end;


  Function  Cus1ExtSObjCid.GetSearchRec3(B_Func,
                                         Fnum,
                                         Keypath   :  Integer;
                                     Var KeyS      :  Str255;
                                         FCusCode  :  Str10;
                                         FNomAuto  :  Boolean;
                                         FCr       :  Byte;
                                         FAlCode   :  Char;
                                         FCSCode   :  Char)  :  Integer;

  Begin
    SetCusObj3(SearchRec,Fnum,FCusCode,FNomAuto,FCr,FAlCode,FCSCode);

    GetSearchRec3:=ExtSNObjCid.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}





{ ========= Function to Control Scanning of Bank Match Lines ========= }

  Function GetExtBankM(ExtRecPtr,
                       ExtObjPtr  :  Pointer;
                       Fnum,
                       Keypath,
                       B_End      :  Integer;
                       Mode       :  Byte;
                   Var KeyS       :  Str255)  :  Integer;



  Var
    ExtNomRec :  ExtNomRecPtr;

    TmpStat   :  Integer;

    ExtNomObj :  GetNomMode3;



  Begin

    TmpStat:=0;

    Begin
      ExtNomRec:=ExtRecPtr;

      ExtNomObj:=ExtObjPtr;

      With ExtNomRec^ do
      Begin

        If (B_End In [B_GetPrev,B_GetNext]) and (ExtNomObj<>NIL) then
        Begin

          TmpStat:=ExtNomObj^.GetSearchRec2(B_End+30,Fnum,KeyPath,KeyS,FNomCode,FDesc,FCr,FNomMode);

        end
        else

          TmpStat:=Find_Rec(B_End,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;{With..}

    end; {With..}

    GetExtBankM:=TmpStat;

  end; {Func..}




{ ========= Function to Control Scanning of Bank Match Lines ========= }

Function GetExtBankMCid(ExtRecPtr,
                        ExtObjPtr  :  Pointer;
                        Fnum,
                        Keypath,
                        B_End      :  Integer;
                        Mode       :  Byte;
                    Var KeyS       :  Str255)  :  Integer;



  Var
    ExtNomRec :  ExtNomRecPtr;

    TmpStat   :  Integer;

    ExtNomObj :  GetNomMode3Cid;



  Begin

    TmpStat:=0;

    Begin
      ExtNomRec:=ExtRecPtr;

      ExtNomObj:=ExtObjPtr;

      With ExtNomRec^ do
      Begin

        If (B_End In [B_GetPrev,B_GetNext]) and (ExtNomObj<>NIL) then
        Begin

          TmpStat:=ExtNomObj^.GetSearchRec2(B_End+30,Fnum,KeyPath,KeyS,FNomCode,FDesc,FCr,FNomMode);

        end
        else
          With ExtNomObj^.MTExLocal^ do
            TmpStat:=LFind_Rec(B_End,Fnum,KeyPath,KeyS);

      end;{With..}

    end; {With..}

    GetExtBankMCid:=TmpStat;

  end; {Func..}



  { ========== Function to Evaluate Filter ========== }


Function ExtBankFiltCid(Mode       :  Integer;
                        RecPtr,
                        ExtObjPtr  :  Pointer):  Boolean;


Var
  TmpBo      :  Boolean;
  ExtNomRec  :  ExtNomRecPtr;
  ExtNomObj  :  GetNomMode3Cid;

  IdL        :  Byte;
  ChkDesc    :  Str80;

Begin

  TmpBo:=BOff;

  ExtNomRec:=RecPtr;
  ExtNomObj:=ExtObjPtr;

  With ExtNomRec^,ExtNomObj^.MTExLocal^ do
  Begin

    ChkDesc:=FDesc;

    IdL:=Length(Strip('R',[#32],LId.Desc));

    If (Idl>Length(ChkDesc)) then
      ChkDesc:=LJVar(ChkDesc,IDL);

    TmpBo:=((LId.NomMode=FNomMode) and (FCr=LId.Currency) and (CheckKey(ChkDesc,LId.Desc,Length(ChkDesc),BOff)));

    If (TmpBo) and (fMatchDate) then
      TmpBo:=(FrDate=LId.PDate);

  end;

  ExtBankFiltCid:=TmpBo;

end;



{ ========= Function to Control Scanning of Bank Match Lines ========= }

  Function GetExtBankR(ExtRecPtr,
                       ExtObjPtr  :  Pointer;
                       Fnum,
                       Keypath,
                       B_End      :  Integer;
                       Mode       :  Byte;
                   Var KeyS       :  Str255)  :  Integer;



  Var
    ExtNomRec :  ExtNomRecPtr;

    TmpStat   :  Integer;

    ExtNomObj :  GetNomMode32Cid;



  Begin

    TmpStat:=0;

    Begin
      ExtNomRec:=ExtRecPtr;

      ExtNomObj:=ExtObjPtr;

      With ExtNomRec^ do
      Begin

        If (B_End In [B_GetPrev,B_GetNext]) and (ExtNomObj<>NIL) then
        Begin

          TmpStat:=ExtNomObj^.GetSearchRec32(B_End+30,Fnum,KeyPath,KeyS,FNomCode,FCr,FNomMode,FRecon);

        end
        else
          With ExtNomObj^.MTExLocal^ do
            TmpStat:=LFind_Rec(B_End,Fnum,KeyPath,KeyS);

      end;{With..}

    end; {With..}

    GetExtBankR:=TmpStat;

  end; {Func..}



  { ========== Function to Evaluate Filter ========== }


Function ExtBankRFilt(Mode       :  Integer;
                      RecPtr,
                      ExtObjPtr  :  Pointer):  Boolean;


Var
  TmpBo      :  Boolean;
  ExtNomRec  :  ExtNomRecPtr;
  ExtNomObj  :  GetNomMode32Cid;


Begin

  TmpBo:=BOff;

  ExtNomRec:=RecPtr;

  ExtNomObj:=ExtObjPtr;

  With ExtNomRec^,ExtNomObj^.MTExLocal^ do
  Begin
    //PR: 10/03/2014 ABSEXCH-14761 Add check for non-zero Posted Run to avoid emulator issue.
    TmpBo:=((LId.NomMode=FNomMode) and (FCr=LId.Currency) and (FRecon=LId.Reconcile) and (LId.PostedRun <> 0));

  end;

  ExtBankRFilt:=TmpBo;

end;



{$IFDEF STK}


  { ========= Function to Control Scanning of Bank Match Lines ========= }

    Function GetExtOSOrd(ExtRecPtr,
                         ExtObjPtr  :  Pointer;
                         Fnum,
                         Keypath,
                         B_End      :  Integer;
                         Mode       :  Byte;
                     Var KeyS       :  Str255)  :  Integer;



    Var
      ExtNomRec :  ExtNomRecPtr;

      TmpStat   :  Integer;

      ExtNomObj :  GetNomMode4;



    Begin

      TmpStat:=0;

      Begin
        ExtNomRec:=ExtRecPtr;

        ExtNomObj:=ExtObjPtr;

        With ExtNomRec^ do
        Begin

          If (B_End In [B_GetPrev,B_GetNext]) and (ExtNomObj<>NIL) then
          Begin

            TmpStat:=ExtNomObj^.GetSearchRec2(B_End+30,Fnum,KeyPath,KeyS,FLTyp,FCCode);

          end
          else

            TmpStat:=Find_Rec(B_End,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

        end;{With..}

      end; {With..}

      GetExtOSOrd:=TmpStat;

    end; {Func..}




{$ENDIF}




  { ========= Function to Control Scanning of Cust Allocation Lines ========= }

  Function GetExtCusAL(ExtRecPtr,
                       ExtObjPtr  :  Pointer;
                       Fnum,
                       Keypath,
                       B_End      :  Integer;
                       Mode       :  Byte;
                   Var KeyS       :  Str255)  :  Integer;



  Var
    ExtCusRec :  ExtCusRecPtr;

    TmpStat   :  Integer;

    ExtCusObj :  GetNomMode;

    MsgForm   :  TForm;



  Begin
    MsgForm := nil;
    TmpStat:=0;

    Begin
      ExtCusRec:=ExtRecPtr;

      ExtCusObj:=ExtObjPtr;

      With ExtCusRec^ do
      Begin

        If (B_End In [B_GetPrev,B_GetNext]) and (ExtCusObj<>NIL) then
        Begin

          If (Mode=3) then
          Begin
            MsgForm:=CreateMessageDialog('Please Wait...'+#13+'...Searching...',mtInformation,[]);
            MsgForm.Show;
            MsgForm.Update;
          end;

          TmpStat:=ExtCusObj^.GetSearchRec3(B_End+30,Fnum,KeyPath,KeyS,FCusCode,FNomAuto,FAlCode,FALDate,FCr,FYr,FPr,FMode);

          If (Mode=3) then
            MsgForm.Free;

        end
        else

          TmpStat:=Find_Rec(B_End,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;{With..}

    end; {With..}

    GetExtCusAL:=TmpStat;

  end; {Func..}






    { ========== Function to Evaluate Filter ========== }


  Function ExtCusFilt(Mode       :  Integer;
                      RecPtr     :  Pointer):  Boolean;


  Var
    TmpBo      :  Boolean;
    CtrlCode   :  LongInt;
    ExtCusRec  :  ExtCusRecPtr;

  Begin

    TmpBo:=BOff;

    ExtCusRec:=RecPtr;

    With ExtCusRec^ do
    Begin

      Case FMode of

        3,4
           :  Begin

                TmpBo:=((Inv.NomAuto=FNomAuto) and ((FCr=Inv.Currency) or (FCr=0)) and ((Inv.AllocStat=FAlCode) or (FMode=4)));

                {* Check also eventualy for hold modes, if on hold ignore?. Authorised only *}

                TmpBo:=((TmpBo) and (Autho_Doc(Inv)));  {* Check if Authorised *}

                {* Check if being edited at present *}

                If (TmpBo) then {* Check if in list of currently edited documents *}
                  TmpBo:=(Found_DocEditNow(Inv.FolioNum)=0);

                If (TmpBo) and (FMode=4) then {* Show if either unallocated, or allocated today *}
                  TmpBo:=((Inv.AllocStat=FAlCode) or (FAlDate=Inv.UntilDate));

                If (TmpBo) and (FCtrlNom<>0) and (FMode<>4) then
                Begin
                  If (((Inv.InvDocHed In SalesSplit) and (FCtrlNom=Syss.NomCtrlCodes[Debtors]))
                    or  ((Inv.InvDocHed In PurchSplit) and (FCtrlNom=Syss.NomCtrlCodes[Creditors])))
                    and (Inv.CtrlNom=0) then
                      CtrlCode:=FCtrlNom
                    else
                      CtrlCode:=Inv.CtrlNom;

                  TmpBo:=(CtrlCode=FCtrlNom);
                end;


              end;

        else  Begin

                TmpBo:=((FYr=Inv.AcYr) and ((FPr=Inv.AcPr) or (FPr In [YTD,YTDNCF])) and (Inv.NomAuto=FNomAuto));

                If (FMode=2) then
                  TmpBo:=((TmpBo) and (FCr=Inv.Currency));

              end;
      end; {Case..}

    end;

    ExtCusFilt:=TmpBo;

  end;



    { ========= Function to Control Scanning of Cust Allocation Lines ========= }

  Function GetExtCusALCid(ExtRecPtr,
                          ExtObjPtr  :  Pointer;
                          Fnum,
                          Keypath,
                          B_End      :  Integer;
                          Mode       :  Byte;
                      Var KeyS       :  Str255)  :  Integer;



  Var
    ExtCusRec :  ExtCusRecPtr;

    TmpStat   :  Integer;

    ExtCusObj :  GetCusMode1Cid;


  Begin

    TmpStat:=0;

    Begin
      ExtCusRec:=ExtRecPtr;

      ExtCusObj:=ExtObjPtr;

      With ExtCusRec^ do
      Begin

        If (B_End In [B_GetPrev,B_GetNext]) and (ExtCusObj<>NIL) then
        Begin


          TmpStat:=ExtCusObj^.GetSearchRec3(B_End+30,Fnum,KeyPath,KeyS,FCusCode,FNomAuto,FCr,FAlCode,FCSCode);

        end
        else
          With ExtCusObj^.MTExLocal^ do
            TmpStat:=LFind_Rec(B_End,Fnum,KeyPath,KeyS);

      end;{With..}

    end; {With..}

    GetExtCusALCid:=TmpStat;

  end; {Func..}






    { ========== Function to Evaluate Filter ========== }

  {Modes...
   0 Called from Update_Credit Status      (LedSup2U.Pas)
   -1   "     "   Object Credit Controller (CredPopUp.Pas)
  }


  Function ExtCusFiltCid(Mode       :  Integer;
                         RecPtr,
                         ExtObjPtr  :  Pointer):  Boolean;


  Var
    TmpBo,
    TInc       :  Boolean;
    ExtCusRec  :  ExtCusRecPtr;
    ExtCusObj  :  GetCusMode1Cid;
    CtrlCode   :  LongInt;

Procedure Write_PostLogDD(S         :  String;
                          SetWrite  :  Boolean;
                          DK        :  Str255;
                          DM        :  Byte);

{$IFDEF FRM}
  {$IFNDEF OLE}
  Var
    PostLog  :  TPostLog;
  {$ENDIF}
{$ENDIF}

Begin
  {$IFDEF FRM}
  {$IFNDEF OLE}
    PostLog:=nil;

    try
      If (Assigned(ExtCusRec^.FLogPtr)) then
      Begin
        PostLog:=ExtCusRec^.FLogPtr;

        With PostLog do
        Begin
          If (SetWrite) and (Not Got2Print) then
            Got2Print:=SetWrite;

          Write_MsgDD(S,DK,DM);
        end;
      end;
    except
      If (Assigned(PostLog)) then
      Begin
        PostLog.Free;
      end;

    end;

  {$ENDIF}
  {$ENDIF}
end;


Procedure Write_PostLog(S         :  String;
                        SetWrite  :  Boolean);
Begin
  Write_PostLogDD(S,SetWrite,'',0);
end;

  Begin

    TmpBo:=BOff;

    ExtCusRec:=RecPtr;

    ExtCusObj:=ExtObjPtr;

    With ExtCusRec^,ExtCusObj^.MTExLocal^ do
    Begin

      Case FMode of

        3  :  Begin

                TmpBo:=((LInv.NomAuto=FNomAuto) and (LInv.AllocStat=FAlCode));

                If (TmpBo) then
                Begin
                  TmpBo:=((FCr=LInv.Currency) or (FCr=0));

                  If (Not TmpBo) then
                    Write_PostLogDD(LInv.OurRef+' excluded as it does not match the currency requested for this run.',BOn,LInv.OurRef,0);


                end;

                {* Check also for hold modes, Authorised only *}

                TInc:=((Autho_Doc(LInv)) and ((Not OnHold(LInv.HoldFlg)) or (GetHoldType(LInv.HoldFlg)=HoldA)));  {* Check if Authorised *}

                If (Not TInc) then
                  Write_PostLogDD(LInv.OurRef+' excluded as it is either on hold, or has not been authorised.',BOn,LInv.OurRef,0);


                TmpBo:=(TInc and TmpBo);

                {* Check if being edited at present *}

                If (Mode<>-1) then {* Check if in list of currently edited documents *}
                Begin
                  TInc:=(Found_DocEditNow(LInv.FolioNum)=0);

                  If (Not TInc) then
                    Write_PostLogDD(LInv.OurRef+' excluded as it is being edited by you!.',BOn,LInv.OurRef,0);

                  TmpBo:=(TInc and TmpBo);
                end;

                If (FCtrlNom<>0) then
                Begin
                  If (((LInv.InvDocHed In SalesSplit) and (FCtrlNom=Syss.NomCtrlCodes[Debtors]))
                    or  ((LInv.InvDocHed In PurchSplit) and (FCtrlNom=Syss.NomCtrlCodes[Creditors])))
                    and (LInv.CtrlNom=0) then
                      CtrlCode:=FCtrlNom
                    else
                      CtrlCode:=LInv.CtrlNom;

                  TInc:=(CtrlCode=FCtrlNom);

                  If (Not TInc) then
                    Write_PostLogDD(LInv.OurRef+' excluded as it does not match the G/L Control Code requested for this run.',BOn,LInv.OurRef,0);

                  TmpBo:=(TInc and TmpBo);
                end;


              end;

        else  Begin

                TmpBo:=((FYr=LInv.AcYr) and ((FPr=LInv.AcPr) or (FPr In [YTD,YTDNCF])) and (LInv.NomAuto=FNomAuto));

                If (FMode=2) then
                  TmpBo:=((TmpBo) and (FCr=LInv.Currency));

              end;
      end; {Case..}

    end;

    ExtCusFiltCid:=TmpBo;

  end;




end.