Unit JHistDDU;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 29/09/98                      }
{                 Job Tree History Support Unit                }
{                                                              }
{                                                              }
{               Copyright (C) 1995 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     BtrvU2;



Type


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

                        FRPF,
                        FSTP,
                        FLTyp       :  Char;

                        JAnl1,
                        JAnl2,
                        JAnl3       :  LongInt;

                        FPSOP       :  Boolean;

                        FMode       :  Byte;

                      end;



  FilterTypeN1       =  Record          {* RecPFix + SubType + (JobCode + AnalRec) + Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..20] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN2       =  Record          {* RecPFix + SubType + (JobCode + StockRec) + Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..26] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;



  FilterTypeN3       =  Record          {* RecPFix + SubType + (JobCode + AnalHed) + Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..14] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;



  FilterTypeN4       =  Record          {* RecPFix + SubType + JobCode + AnalHed + Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..10] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    LongInt;
    Term4            :    FilterRepeatType;
    Compare4         :    LongInt;
    Term5            :    FilterRepeatType;
    Compare5         :    LongInt;
    Term6            :    FilterRepeatType;
    Compare6         :    LongInt;
    Term7            :    FilterRepeatType;
    Compare7         :    LongInt;
    Term8            :    FilterRepeatType;
    Compare8         :    Char;
    Term9            :    FilterRepeatType;
    Compare9         :    Char;
    Term10           :    FilterRepeatType;
    Compare10        :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;


  FilterTypeN5       =  Record          {* RecPFix + SubType + (JobCode + Posted) + Invoiced + JAType *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..11] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    LongInt;
    Term5            :    FilterRepeatType;
    Compare5         :    Char; {* Deliberately set to a char, as long int would not work *}
    Term6            :    FilterRepeatType;
    Compare6         :    Char; {* Deliberately set to a char, as long int would not work *}
    Term7            :    FilterRepeatType;
    Compare7         :    Char; {* Deliberately set to a char, as long int would not work *}
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN6       =  Record          {* RecPFix + SubType + EmpCode + Yr+Pr *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    Array[1..2] of Char;
    Term2            :    FilterRepeatType;
    Compare2         :    Array[1..6] of Char;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    ExtendTail       :    ExtendRepeatType;

  end;

  THeaderKey   = array[1..2] of Char;
  TAnalysisKey = array[1..20] of Char;
  TRunNoKey = array[1..4] of Char;
  FilterTypeN7       =  Record          {* RecPFix + SubType + (JobCode + AnalRec) + Cr + Yr + Pr + PostedRunNo *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    THeaderKey;
    Term2            :    FilterRepeatType;
    Compare2         :    TAnalysisKey;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    TRunNoKey;
    ExtendTail       :    ExtendRepeatType;

  end;

  TJATypeKey = array[1..14] of Char;
  FilterTypeN8       =  Record          {* RecPFix + SubType + (JobCode + JAType) + Cr + Yr + Pr + PostedRunNo *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    THeaderKey;
    Term2            :    FilterRepeatType;
    Compare2         :    TJATypeKey;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    TRunNoKey;
    ExtendTail       :    ExtendRepeatType;

  end;

  TStockKey = array[1..26] of Char;
  FilterTypeN9       = record       {* RecPFix + SubType + (JobCode + StockCode) + Cr + Yr + Pr + PostedRunNo *}

    ExtendHead       :    ExtendGetDescType;
    Term1            :    FilterRepeatType;
    Compare1         :    THeaderKey;
    Term2            :    FilterRepeatType;
    Compare2         :    TStockKey;
    Term3            :    FilterRepeatType;
    Compare3         :    Char;
    Term4            :    FilterRepeatType;
    Compare4         :    Char;
    Term5            :    FilterRepeatType;
    Compare5         :    Char;
    Term6            :    FilterRepeatType;
    Compare6         :    TRunNoKey;
    ExtendTail       :    ExtendRepeatType;

  end;

  FilterTypeN        =  Record

    Case Integer of

      1  :  (FilterN1 :  FilterTypeN1);
      2  :  (FilterN2 :  FilterTypeN2);
      3  :  (FilterN3 :  FilterTypeN3);
      4  :  (FilterN4 :  FilterTypeN4);
      5  :  (FilterN5 :  FilterTypeN5);
      6  :  (FilterN6 :  FilterTypeN6);
      7  :  (FilterN7 :  FilterTypeN7);
      8  :  (FilterN8 :  FilterTypeN8);
      9  :  (FilterN9 :  FilterTypeN9);

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



  GetNomMode1  =  ^Nom1ExtSObj;

  Nom1ExtSObj   =  Object(ExtSNObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              FYr,FPr       :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            FYr,FPr :  Byte)  :  Integer;




               end; {Object..}


  { --------------------------------------- }


  GetNomMode2  =  ^Nom2ExtSObj;

  Nom2ExtSObj  =  Object(Nom1ExtSObj)

                    Constructor  Init;

                    Destructor   Done;

                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              FYr,FPr       :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            FYr,FPr :  Byte)  :  Integer;


               end; {Object..}




  { --------------------------------------- }


  GetNomMode3  =  ^Nom3ExtSObj;

  Nom3ExtSObj  =  Object(Nom2ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              FYr,FPr       :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            FYr,FPr :  Byte)  :  Integer;


               end; {Object..}


  GetNomMode5  =  ^Nom5ExtSObj;

  Nom5ExtSObj  =  Object(Nom3ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              JA1           :  LongInt;
                                              IFlg          :  Boolean;
                                              SMode         :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            JA1     :  LongInt;
                                            IFlg    :  Boolean;
                                            SMode   :  Byte)  :  Integer;


               end; {Object..}


  GetNomMode6  =  ^Nom6ExtSObj;

  Nom6ExtSObj  =  Object(Nom5ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              FYr,FPr       :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            FYr,FPr :  Byte)  :  Integer;


               end; {Object..}




  { --------------------------------------- }


  { --------------------------------------- }


  GetNomMode4  =  ^Nom4ExtSObj;

  Nom4ExtSObj  =  Object(Nom6ExtSObj)

                    Constructor  Init;

                    Destructor   Done;


                    Procedure SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                              Fnum          :  Integer;
                                              RP,ST         :  Char;
                                              JC            :  Str30;
                                              JA1,JA2,JA3   :  LongInt;
                                              FCr,FYr,FPr   :  Byte);



                    Function  GetSearchRec2(B_Func,
                                            Fnum,
                                            Keypath :  Integer;
                                        Var KeyS    :  Str255;
                                            RP,ST   :  Char;
                                            JC      :  Str30;
                                            JA1,JA2,
                                            JA3     :  LongInt;
                                            FCr,FYr,
                                            FPr     :  Byte)  :  Integer;


               end; {Object..}


  { --------------------------------------- }


    GetNomMode    =  ^NomExtSObj;

    NomExtSObj    =  Object(Nom4ExtSObj)

                      Constructor  Init;

                      Destructor   Done;

                      Function  GetSearchRec(B_Func,
                                             Fnum,
                                             Keypath   :  Integer;
                                         Var KeyS      :  Str255;
                                             RP,ST     :  Char;
                                             JC        :  Str30;
                                             JA1,JA2,
                                             JA3       :  LongInt;
                                             FCr,FYr,
                                             FPr,
                                             Mode      :  Byte)  :  Integer;



                 end; {Object..}


    { --------------------------------------- }






 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETDateU,
   VarJCstU,
   ComnUnit,
   ComnU2,
   BTKeys1U,
   BTSupU1,
   SysU1;



Const
  NoExtTries  =  10; {* Number of times a get extended reject count status is retried *}
                     {* Number will be x 65535 records for each try *}
                     {* This value also needs changing in Recon3U *}
                     {* This value also needs changing in DOCSupU1 *}



  { --------------------------------------- }


  Constructor ExtSNObj.Init;

  Begin

    New(SearchRec);

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


  {* This Routine also needs changing in Recon3U *}

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

    KeepTrying := BOn;

    New(TmpSRec);

    TmpSRec^ := GSearchRec^;  {* Keep local copy of search record structure, as this gets modifed
                               by Btrieve, and if it fails will no longer be valid *}

    Repeat
      FStatus := Find_VarRec(B_Func,F[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,Nil);

      If (FStatus=0) then
        Move(SearchRec^.ExtRec.ExtendRec,RecPtr[Fnum]^,FileRecLen[Fnum]);

      {If (Debug) and (Fstatus<>0) then
        Beep;}


      Inc(Tries);

      KeepTrying:= (FStatus=60) and (Tries<=NoExtTries);

      If KeepTrying then
        GSearchRec^:=TmpSRec^;

    Until (Not KeepTrying);


    Dispose(TmpSRec);

    GetSearchRec:=FStatus;

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
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        FYr,FPr       :  Byte);



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
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDAPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;

      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDYPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare3:=Chr(FYr);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDPPos;


        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=0;

        Compare4:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Nom1ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      FYr,FPr :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

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


  Procedure Nom2ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        FYr,FPr       :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterN2 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN2));


      With ExtendHead do
      Begin
        NumTerms:=4;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDSPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;

      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDYPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare3:=Chr(FYr);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDPPos;


        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=0;

        Compare4:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Nom2ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      FYr,FPr :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}



  { --------------------------------------- }


  Constructor Nom3ExtSObj.Init;

  Begin

    Nom2ExtSObj.Init;

  end;



  Destructor  Nom3ExtSObj.Done;
  Begin

    Nom2ExtSObj.Done;

  end;


  Procedure Nom3ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        FYr,FPr       :  Byte);



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
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDHPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;

      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDYPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare3:=Chr(FYr);

      end;

      With Term4 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDPPos;


        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=0;

        Compare4:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Nom3ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      FYr,FPr :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

  Constructor Nom5ExtSObj.Init;

  Begin

    Nom3ExtSObj.Init;

  end;



  Destructor  Nom5ExtSObj.Done;
  Begin

    Nom3ExtSObj.Done;

  end;


  Procedure Nom5ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        JA1           :  LongInt;
                                        IFlg          :  Boolean;
                                        SMode         :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterN5 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN5));


      With ExtendHead do
      Begin
        NumTerms:=7;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDLPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;

      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDIPos;
        CompareCode:=1; {* Compare = *}
        LogicExpres:=1;

        Compare3:=Chr(Ord(IFlg));

      end;



      With Term4 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDJPos;
        CompareCode:=2; {* Compare > *}
        LogicExpres:=1;

        Compare4:=SysAnlsRev;

      end;


      {* Note this term should be a Longint, but neither comparison 3 <, or 6 <=
         would work at all with this type, so by using a string and relying on the fact
         the major types are < 255, a char was used instead *}

      With Term5 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEJDJPos;
        CompareCode:=6; {* Compare <= *}
        LogicExpres:=2;

        If (SMode<>29) then {* Its via WIP Screen *}
          Compare5:=Chr(SysOH2) {v5.60.001. This was initialy the last term, but its too wide as it includes WIP, so additional terms
                                            needed to only include Sub Lab2 - OH2 }
        else
          Compare5:=Chr(SysAnlsEnd);

      end;


      With Term6 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare6);

        FieldOffset:=GEJDJPos;
        CompareCode:=2; {* Compare > *}
        LogicExpres:=1;

        If (SMode<>29) then
          Compare6:=Chr(SysAnlsRev)
        else
          Compare6:=Chr(Pred(SysSubLab));

      end;


      With Term7 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare7);

        FieldOffset:=GEJDJPos;
        CompareCode:=6; {* Compare <= *}
        LogicExpres:=0;

        Compare7:=Chr(SysOH2);

      end;

    end; {With..}

  end;


  Function  Nom5ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      JA1     :  LongInt;
                                      IFlg    :  Boolean;
                                      SMode   :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,JA1,IFlg,SMode);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }


  Constructor Nom6ExtSObj.Init;

  Begin

    Nom5ExtSObj.Init;

  end;



  Destructor  Nom6ExtSObj.Done;
  Begin

    Nom5ExtSObj.Done;

  end;


  Procedure Nom6ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        FYr,FPr       :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterN6 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN6));


      With ExtendHead do
      Begin
        NumTerms:=5;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDEPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;


      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDOPos;
        CompareCode:=1; {* Compare= *}  {* Posted only lines *}
        LogicExpres:=1;

        Compare3:=Chr(1);

      end;

      With Term4 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDYPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare4:=Chr(FYr);

      end;

      With Term5 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEJDPPos;


        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=0;

        Compare5:=Chr(FPr);

      end;

    end; {With..}

  end;


  Function  Nom6ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      FYr,FPr :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }



  Constructor Nom4ExtSObj.Init;

  Begin

    Nom6ExtSObj.Init;

  end;



  Destructor  Nom4ExtSObj.Done;
  Begin

    Nom6ExtSObj.Done;

  end;


  Procedure Nom4ExtSObj.SetNomObj1(Var  SetSearchRec  :  SearchNPtr;
                                        Fnum          :  Integer;
                                        RP,ST         :  Char;
                                        JC            :  Str30;
                                        JA1,JA2,JA3   :  LongInt;
                                        FCr,FYr,FPr   :  Byte);



  Begin
    With SetSearchRec^.Filter.FilterN4 do
    Begin
      ExtSNObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterN4));


      With ExtendHead do
      Begin
        NumTerms:=10;
      end;

      With Term1 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare1);  {* Allow for *}

        FieldOffset:=GERPPos;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1[1]:=RP;
        Compare1[2]:=ST;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare2);

        FieldOffset:=GEJDHPos;
        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Move(JC[1],Compare2,FieldLen);

      end;

      With Term3 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare3);

        FieldOffset:=GEJDHPos+10;
        CompareCode:=3; {* Compare < *}
        LogicExpres:=2;

        Compare3:=JA1;

      end;


      {* It may be necessary to extend the <> to include applications if DD gets too slow/ flickery v5.60.001 *}

      With Term4 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare4);

        FieldOffset:=GEJDHPos+10;
        CompareCode:=1; {* Compare = *}
        LogicExpres:=1;

        Compare4:=JA3;

      end;


      With Term5 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare5);

        FieldOffset:=GEJDHPos+10;
        CompareCode:=4; {* Compare <> *}
        LogicExpres:=1;

        Compare5:=JA2;

      end;

      With Term6 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare6);

        FieldOffset:=GEJDHPos+10;
        CompareCode:=4; {* Compare <> *}
        LogicExpres:=1;

        Compare6:=9;

      end;


      With Term7 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Compare7);

        FieldOffset:=GEJDHPos+10;
        CompareCode:=4; {* Compare <> *}
        LogicExpres:=1;

        Compare7:=10;

      end;

      With Term8 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Compare8);

        FieldOffset:=GEJDYPos;

        If (Not (FYr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}

        LogicExpres:=1;

        Compare8:=Chr(FYr);

      end;

      With Term9 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare9);

        FieldOffset:=GEJDCPos;

        If (Not (FCr In [YTD])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=1;

        Compare9:=Chr(FCr);

      end;


      With Term10 do
      Begin

        FieldType:=BString;

        FieldLen:=Sizeof(Compare10);

        FieldOffset:=GEJDPPos;

        If (Not (FPr In [YTD,YTDNCF])) then
          CompareCode:=1 {* Compare= *}
        else
          CompareCode:=4;{* Compare=<> *}


        LogicExpres:=0;

        Compare10:=Chr(FPr);

      end;

    end; {With..}


  end;


  Function  Nom4ExtSObj.GetSearchRec2(B_Func,
                                      Fnum,
                                      Keypath :  Integer;
                                  Var KeyS    :  Str255;
                                      RP,ST   :  Char;
                                      JC      :  Str30;
                                      JA1,JA2,
                                      JA3     :  LongInt;
                                      FCr,FYr,
                                      FPr     :  Byte)  :  Integer;



  Begin
    SetNomObj1(SearchRec,Fnum,RP,ST,JC,JA1,JA2,JA3,FCr,FYr,FPr);

    GetSearchRec2:=ExtSNObj.GetSearchRec(B_Func,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }




  { --------------------------------------- }

  { NomExtSObj Methods }

  { --------------------------------------- }


  Constructor NomExtSObj.Init;

  Begin

    Nom4ExtSObj.Init;

  end;



  Destructor  NomExtSObj.Done;
  Begin

    Nom4ExtSObj.Done;

  end;



  Function  NomExtSObj.GetSearchRec(B_Func,
                                    Fnum,
                                    Keypath   :  Integer;
                                Var KeyS      :  Str255;
                                    RP,ST     :  Char;
                                    JC        :  Str30;
                                    JA1,JA2,
                                    JA3       :  LongInt;
                                    FCr,FYr,FPr,
                                    Mode      :  Byte)  :  Integer;




  Begin

    Case Mode of

      13    :  GetSearchRec:=Nom1ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,FYr,FPr);

      14    :  GetSearchRec:=Nom2ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,FYr,FPr);

      15    :  GetSearchRec:=Nom3ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,FYr,FPr);

      16..19
            :  GetSearchRec:=Nom4ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,JA1,JA2,JA3,FCr,FYr,FPr);

      25..29
            :  GetSearchRec:=Nom5ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,JA1,(FCr<>0),Mode);

      32    :  GetSearchRec:=Nom6ExtSObj.GetSearchRec2(B_Func,Fnum,Keypath,KeyS,RP,ST,JC,FYr,FPr);


    end; {Case..}

  end; {Func..}






end.

///
{ ================== Procedure to Setup Job Actual Constants =============== }

Procedure SetJInvDefaults(    Opt        :  Byte;
                              Fnum       :  Integer;
                              NomKey     :  Str255;
                          Var ScanParam  :  ScanCtrlRec;
                          Var ScanProcs  :  ScanProcRec);

Var
  ExtNomRec:  ExtNomRecPtr;


Begin


  With ScanParam do
  Begin


    Case Opt of


       15..19,
       32
           :   Begin


                 With ScanProcs do
                 Begin

                   GetExtList:=GetExtNom;

                   ScanParam.ExtFilt:=ExtNomFilt;

                 end;


                 ExtNomRec:=ScanParam.ExtRecPtr;

                 With ExtNomRec^ do
                 Begin



                   FDesc:=NomKey;

                   Case Opt of

                     32  :  Begin

                              FMode:=Displaymode;

                              FPr:=NHist.Pr;
                              FYr:=NHist.Yr;

                            end;
                     else
                            FMode:=DisplayMode+10;

                   end; {Case..}

                 end; {With..}

               end;



    end; {Case..}


  end; {With..}
end; {Proc..}


{ ================== Procedure to Setup Job Actual Constants =============== }



///end. {Unit..}