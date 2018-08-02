Unit Rep5SupU;

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 05/02/92                      }
{               Report Controller 3 Support Unit               }
{                                                              }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
     GlobVar,
     BtrvU2,
     VARRec2U,
     VarConst,
     ETMiscU,
     InvListU,
     DocSupU1,
     EXWrap1U;





{$IFDEF PF_On}

  Type




  GetExNObjCid  =  ^ExtSNObjCid;

  ExtSNObjCid   =  Object

                 SearchRec  :  SearchPtr;

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
                                    Var GSearchRec:  SearchPtr;
                                    Var KeyS      :  Str255)  :  Integer;


               end; {Object..}


  { --------------------------------------- }


    GetIdMode1   =  ^Id1ExtSObj;

    Id1ExtSObj   =  Object(ExtSNObjCid)

                      Constructor  Init;

                      Destructor   Done;


                      Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               CCDep	   :  CCDepType;
                                               IsCC	   :  Boolean);

                      Function  GetSearchRec2(Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FNomcode  :  LongInt;
                                              CCDep     :  CCDepType;
                                              IsCC      :  Boolean)  :  Integer;

                 end; {Object..}


    { --------------------------------------- }

    GetIdMode2   =  ^Id2ExtSObj;

    Id2ExtSObj   =  Object(Id1ExtSObj)

                      Constructor  Init;

                      Destructor   Done;



                      Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               CCDep	   :  CCDepType);





                      Function  GetSearchRec2(Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FNomcode  :  LongInt;
                                              CCDep     :  CCDepType)  :  Integer;

                 end; {Object..}


    { --------------------------------------- }

    GetIdMode3   =  ^Id3ExtSObj;

    Id3ExtSObj   =  Object(Id2ExtSObj)

                      Constructor  Init;

                      Destructor   Done;


                      Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               CCDep	   :  CCDepType;
                                               IsCC	   :  Boolean);

                      Function  GetSearchRec2(Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FNomcode  :  LongInt;
                                              CCDep     :  CCDepType;
                                              IsCC      :  Boolean)  :  Integer;

                 end; {Object..}


    { --------------------------------------- }

    GetIdMode4   =  ^Id4ExtSObj;

    Id4ExtSObj   =  Object(Id3ExtSObj)

                      Constructor  Init;

                      Destructor   Done;



                      Procedure SetIdObj1(Var  SetSearchRec  :  SearchPtr;
                                               Fnum          :  Integer;
                                               FNomCode      :  LongInt;
                                               CCDep	   :  CCDepType);





                      Function  GetSearchRec2(Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FNomcode  :  LongInt;
                                              CCDep     :  CCDepType)  :  Integer;

                 end; {Object..}


    { --------------------------------------- }

    GetIdMode    =  ^IdExtSObj;

    IdExtSObj    =  Object(Id4ExtSObj)

                      Constructor  Init;

                      Destructor   Done;



                      Function   GetSearchRec(Fnum,
                                              Keypath   :  Integer;
                                          Var KeyS      :  Str255;
                                              FNomcode  :  LongInt;
                                              CCDep     :  CCDepType;
                                              Mode      :  Byte)  :  Integer;

                 end; {Object..}


    { --------------------------------------- }

  {$IFDEF STK}

  Type


    FilterTypeS1       =  Record          {* Stock Code & CC or Dep *}

      ExtendHead       :    ExtendGetDescType;
      Term1            :    FilterRepeatType;
      Compare1         :    Array[1..20] of Char;
      Term2            :    FilterRepeatType;
      Compare2         :    String[3];
      ExtendTail       :    ExtendRepeatType;

    end;


    FilterTypeS2       =  Record          {* Stock Code & CCDep *}

      ExtendHead       :    ExtendGetDescType;
      Term1            :    FilterRepeatType;
      Compare1         :    Array[1..20] of Char;
      Term2            :    FilterRepeatType;
      Compare2         :    CCDepType;
      ExtendTail       :    ExtendRepeatType;

    end;


    FilterTypeS3       =  Record          {* Stock Code & CC or Dep & Customer *}

      ExtendHead       :    ExtendGetDescType;
      Term1            :    FilterRepeatType;
      Compare1         :    Array[1..20] of Char;
      Term2            :    FilterRepeatType;
      Compare2         :    String[3];
      Term3            :    FilterRepeatType;
      Compare3         :    Array[1..6] of Char;
      ExtendTail       :    ExtendRepeatType;

    end;


    FilterTypeS4       =  Record          {* Stock Code & CCDep & Customer *}

      ExtendHead       :    ExtendGetDescType;
      Term1            :    FilterRepeatType;
      Compare1         :    Array[1..20] of Char;
      Term2            :    FilterRepeatType;
      Compare2         :    CCDepType;
      Term3            :    FilterRepeatType;
      Compare3         :    Array[1..6] of Char;
      ExtendTail       :    ExtendRepeatType;

    end;


    FilterTypeS5       =  Record          {* Stock Code & Customer *}

      ExtendHead       :    ExtendGetDescType;
      Term1            :    FilterRepeatType;
      Compare1         :    Array[1..20] of Char;
      Term2            :    FilterRepeatType;
      Compare2         :    Array[1..6] of Char;
      ExtendTail       :    ExtendRepeatType;

    end;


    FilterTypeS        =  Record

      Case Integer of

        1  :  (FilterS1 :  FilterTypeS1);
        2  :  (FilterS2 :  FilterTypeS2);
        3  :  (FilterS3 :  FilterTypeS3);
        4  :  (FilterS4 :  FilterTypeS4);
        5  :  (FilterS5 :  FilterTypeS5);

      end;


    SearchStkPtr        =  ^SearchSRecType;

    SearchSRecType      =  Record

      Case Integer of

        1  :  (Filter  :  FilterTypeS);
        2  :  (ExtRec  :  ResultRecType);

    end; {Rec..}

    GetExObj  =  ^ExtStkObj;

    ExtStkObj   =  Object

                     SearchStkRec  :  SearchStkPtr;

                     MTExLocal  :  TdMTExLocalPtr;

                     Constructor  Init;

                     Destructor   Done;

                     Procedure Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                             Var  ExtendTail  :  ExtendRepeatType;
                                                  FileNum     :  Integer;
                                                  FiltSize    :  Integer);


                     Function  GetSearchRec(Fnum,
                                            Keypath   :  Integer;
                                            DataLen   :  Integer;
                                        Var GSearchRec:  SearchStkPtr;
                                        Var KeyS      :  Str255)  :  Integer;


                   end; {Object..}


    { --------------------------------------- }


    GetStkMode1   =  ^Stk1ExtSObj;

    Stk1ExtSObj   =  Object(ExtStkObj)

                       Constructor  Init;

                       Destructor   Done;


                       Procedure SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                                 Fnum          :  Integer;
                                                 FStkCode      :  Str20;
                                                 CCDep	       :  CCDepType;
                                                 IsCC	       :  Boolean);

                       Function  GetSearchRec2(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkcode  :  Str20;
                                               CCDep     :  CCDepType;
                                               IsCC      :  Boolean)  :  Integer;

                     end; {Object..}


    { --------------------------------------- }

    GetStkMode2   =  ^Stk2ExtSObj;

    Stk2ExtSObj   =  Object(Stk1ExtSObj)

                       Constructor  Init;

                       Destructor   Done;



                       Procedure SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                                 Fnum          :  Integer;
                                                 FStkCode      :  Str20;
                                                 CCDep	       :  CCDepType);





                       Function  GetSearchRec2(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkcode  :  Str20;
                                               CCDep     :  CCDepType)  :  Integer;

                     end; {Object..}


    { --------------------------------------- }

    GetStkMode3   =  ^Stk3ExtSObj;

    Stk3ExtSObj   =  Object(Stk2ExtSObj)

                       Constructor  Init;

                       Destructor   Done;


                       Procedure SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                                 Fnum          :  Integer;
                                                 FStkCode      :  Str20;
                                                 FCusCode      :  Str10;
                                                 CCDep         :  CCDepType;
                                                 IsCC	       :  Boolean);

                       Function  GetSearchRec2(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkCode  :  Str20;
                                               FCusCode  :  Str10;
                                               CCDep     :  CCDepType;
                                               IsCC      :  Boolean)  :  Integer;

                     end; {Object..}


    { --------------------------------------- }

    GetStkMode4   =  ^Stk4ExtSObj;

    Stk4ExtSObj   =  Object(Stk3ExtSObj)

                       Constructor  Init;

                       Destructor   Done;



                       Procedure SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                                 Fnum          :  Integer;
                                                 FStkCode      :  Str20;
                                                 FCusCode      :  Str10;
                                                 CCDep         :  CCDepType);





                       Function  GetSearchRec2(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkcode  :  Str20;
                                               FCusCode  :  Str10;
                                               CCDep     :  CCDepType)  :  Integer;

                     end; {Object..}


    { --------------------------------------- }

    GetStkMode5   =  ^Stk5ExtSObj;

    Stk5ExtSObj   =  Object(Stk4ExtSObj)

                       Constructor  Init;

                       Destructor   Done;


                       Procedure SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                                 Fnum          :  Integer;
                                                 FStkCode      :  Str20;
                                                 FCusCode      :  Str10);

                       Function  GetSearchRec2(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkCode  :  Str20;
                                               FCusCode  :  Str10)  :  Integer;

                     end; {Object..}

    { --------------------------------------- }

    GetStkMode    =  ^StkExtSObj;

    StkExtSObj    =  Object(Stk5ExtSObj)

                       Constructor  Init;

                       Destructor   Done;



                       Function   GetSearchRec(Fnum,
                                               Keypath   :  Integer;
                                           Var KeyS      :  Str255;
                                               FStkcode  :  Str20;
                                               FCusCode  :  Str10;
                                               CCDep     :  CCDepType;
                                               Mode      :  Byte)  :  Integer;

                    end; {Object..}


    { --------------------------------------- }


  {$ENDIF}

{$ENDIF}






 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  SysUtils;


{$IFDEF PF_On}

  { --------------------------------------- }



    Constructor ExtSNObjCid.Init;

  Begin

    New(SearchRec);

    MTExLocal:=nil;
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
                                 Var GSearchRec :  SearchPtr;
                                 Var KeyS       :  Str255) :  Integer;
  Var
    FStatus  :  Integer;

  Begin
    If (Assigned(MTExLocal)) then
    With MTExLocal^ do
    Begin
      FStatus:=Find_VarRec(B_Func,LocalF^[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,ExClientId);

      If (FStatus=0) then
        Move(SearchRec^.ExtRec.ExtendRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

      GetSearchRec:=FStatus;
    end
    else
      GetSearchRec:=97;

  end;




  { --------------------------------------- }


  { --------------------------------------- }

  { Id1ExtSObj Methods }

  { --------------------------------------- }


  Constructor Id1ExtSObj.Init;

  Begin

    ExtSNObjCid.Init;

  end;



  Destructor  Id1ExtSObj.Done;
  Begin

    ExtSNObjCid.Done;

  end;


  Procedure Id1ExtSObj.SetIdObj1(Var  SetSearchRec  :  SearchPtr;
				      Fnum          :  Integer;
				      FNomCode      :  LongInt;
				      CCDep         :  CCDepType;
				      IsCC          :  Boolean);


  Begin
    With SetSearchRec^.Filter.Filter1 do
    Begin
      ExtSNObjCid.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.Filter1));


      With ExtendHead do
      Begin
        NumTerms:=2;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);

        FieldOffset:=GENomCode;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1:=FNomCode;

      end;

      With Term2 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Id.CCDep[BOff]);

        If (IsCC) then
          FieldOffset:=GECC
        else
          FieldOffSet:=GEDep;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare2:=CCDep[IsCC];

      end;

    end; {With..}

  end;


  Function  Id1ExtSObj.GetSearchRec2(Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
					    CCDep     :  CCDepType;
					    IsCC      :  Boolean)  :  Integer;



  Begin
    SetIdObj1(SearchRec,Fnum,FNomCode,CCDep,IsCC);

    GetSearchRec2:=ExtSNObjCid.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}

  { --------------------------------------- }

  { Id2ExtSObj Methods }

  { --------------------------------------- }


  Constructor Id2ExtSObj.Init;

  Begin

    Id1ExtSObj.Init;

  end;



  Destructor  Id2ExtSObj.Done;
  Begin

    Id1ExtSObj.Done;

  end;



  Procedure Id2ExtSObj.SetIdObj1(Var  SetSearchRec  :  SearchPtr;
				      Fnum          :  Integer;
				      FNomCode      :  LongInt;
				      CCDep         :  CCDepType);


  Begin
    With SetSearchRec^.Filter.Filter2 do
    Begin

      Id1ExtSObj.SetIdObj1(SetSearchRec,Fnum,FNomCode,CCDep,BOff);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        DescLen:=Sizeof(SetSearchRec^.Filter.Filter2);
      end;

      With Term2 do
      Begin
        FieldLen:=Sizeof(Id.CCDep);

        FieldOffset:=GEDep;

        Compare2:=CCDep;

      end;


    end; {With..}

  end;


  Function  Id2ExtSObj.GetSearchRec2(Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
                                     FNomcode  :  LongInt;
				     CCDep     :  CCDepType)  :  Integer;




  Begin
    SetIdObj1(SearchRec,Fnum,FNomCode,CCDep);

    GetSearchRec2:=ExtSNObjCid.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}

  { --------------------------------------- }

  { Id3ExtSObj Methods }

  { --------------------------------------- }


  Constructor Id3ExtSObj.Init;

  Begin

    Id2ExtSobj.Init;

  end;



  Destructor  Id3ExtSObj.Done;
  Begin

    Id2ExtSObj.Done;

  end;


  Procedure Id3ExtSObj.SetIdObj1(Var  SetSearchRec  :  SearchPtr;
				      Fnum          :  Integer;
				      FNomCode      :  LongInt;
				      CCDep         :  CCDepType;
				      IsCC          :  Boolean);


  Begin
    With SetSearchRec^.Filter.Filter3 do
    Begin
      ExtSNObjCid.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.Filter3));


      With ExtendHead do
      Begin
        NumTerms:=3;
      end;

      With Term1 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);

        FieldOffset:=GEPostedRun;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare1:=0;

      end;


      With Term2 do
      Begin
        FieldType:=BInteger;

        FieldLen:=Sizeof(Id.NomCode);

        FieldOffset:=GENomCode;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=1;

        Compare2:=FNomCode;

      end;


      With Term3 do
      Begin
        FieldType:=BString;

        FieldLen:=Sizeof(Id.CCDep[BOff]);

        If (IsCC) then
          FieldOffset:=GECC
        else
          FieldOffSet:=GEDep;

        CompareCode:=1; {* Compare= *}
        LogicExpres:=0;

        Compare3:=CCDep[IsCC];

      end;

    end; {With..}

  end;


  Function  Id3ExtSObj.GetSearchRec2(Fnum,
                                            Keypath   :  Integer;
                                        Var KeyS      :  Str255;
                                            FNomcode  :  LongInt;
					    CCDep     :  CCDepType;
					    IsCC      :  Boolean)  :  Integer;



  Begin
    SetIdObj1(SearchRec,Fnum,FNomCode,CCDep,IsCC);

    GetSearchRec2:=ExtSNObjCid.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}

  { --------------------------------------- }

  { Id4ExtSObj Methods }

  { --------------------------------------- }


  Constructor Id4ExtSObj.Init;

  Begin

    Id3ExtSObj.Init;

  end;



  Destructor  Id4ExtSObj.Done;
  Begin

    Id3ExtSObj.Done;

  end;



  Procedure Id4ExtSObj.SetIdObj1(Var  SetSearchRec  :  SearchPtr;
				      Fnum          :  Integer;
				      FNomCode      :  LongInt;
				      CCDep         :  CCDepType);


  Begin
    With SetSearchRec^.Filter.Filter4 do
    Begin

      Id3ExtSObj.SetIdObj1(SetSearchRec,Fnum,FNomCode,CCDep,BOff);

      Prime_TailFilter(ExtendTail,Fnum);


      With ExtendHead do
      Begin
        DescLen:=Sizeof(SetSearchRec^.Filter.Filter4);
      end;

      With Term3 do
      Begin
        FieldLen:=Sizeof(Id.CCDep);

        FieldOffset:=GEDep;

        Compare3:=CCDep;

      end;


    end; {With..}

  end;


  Function  Id4ExtSObj.GetSearchRec2(Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
                                     FNomcode  :  LongInt;
				     CCDep     :  CCDepType)  :  Integer;




  Begin
    SetIdObj1(SearchRec,Fnum,FNomCode,CCDep);

    GetSearchRec2:=ExtSNObjCid.GetSearchRec(B_GetNextEx,Fnum,Keypath,Sizeof(SearchRec^),SearchRec,KeyS);

  end; {Func..}


  { --------------------------------------- }

  { IdExtSObj Methods }

  { --------------------------------------- }


  Constructor IdExtSObj.Init;

  Begin

    Id4ExtSObj.Init;

  end;



  Destructor  IdExtSObj.Done;
  Begin

    Id4ExtSObj.Done;

  end;





  Function  IdExtSObj.GetSearchRec(Fnum,
                                   Keypath   :  Integer;
                               Var KeyS      :  Str255;
                                   FNomcode  :  LongInt;
				   CCDep     :  CCDepType;
                                   Mode      :  Byte)  :  Integer;




  Begin

    Case Mode of
      1,5
           :  With MTExLocal^ do
                GetSearchRec:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      2,3  :  GetSearchRec:=Id1ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FNomCode,CCDep,(Mode=2));

      4    :  GetSearchRec:=Id2ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FNomCode,CCDep);

      6,7  :  GetSearchRec:=Id3ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FNomCode,CCDep,(Mode=6));

      8    :  GetSearchRec:=Id4ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FNomCode,CCDep);
      else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
        raise Exception.Create('Invalid Mode in IdExtSObj.GetSearchRec: ' + IntToStr(Mode));
    end; {Case..}

  end; {Func..}



  {$IFDEF STK}

    { --------------------------------------- }

    { ExtSTkObj Methods }



    Constructor ExtStkObj.Init;

    Begin

      New(SearchStkRec);

      FillChar(SearchStkRec^,Sizeof(SearchStkRec),0);

      MTExLocal:=nil;
    end;

    Destructor  ExtStkObj.Done;
    Begin

      Dispose(SearchStkRec);


    end;

    Procedure ExtStkObj.Prime_InitRec(Var  ExtendHead  :  ExtendGetDescType;
                                      Var  ExtendTail  :  ExtendRepeatType;
                                           FileNum     :  Integer;
                                           FiltSize    :  Integer);

    Begin

      Prime_Filter(ExtendHead,ExtendTail,FileNum,FiltSize);

    end;



    Function  ExtStkObj.GetSearchRec(Fnum,
                                     Keypath    :  Integer;
                                     DataLen    :  Integer;
                                 Var GSearchRec :  SearchStkPtr;
                                 Var KeyS       :  Str255) :  Integer;
    Var
      FStatus  :  Integer;

    Begin

      If (Assigned(MTExLocal)) then
      With MTExLocal^ do
      Begin
        FStatus:=Find_VarRec(B_GetNextEx,LocalF^[Fnum],Fnum,DataLen,GSearchRec^,Keypath,KeyS,ExClientId);

        If (FStatus=0) then
          Move(SearchStkRec^.ExtRec.ExtendRec,LRecPtr[Fnum]^,FileRecLen[Fnum]);

        GetSearchRec:=FStatus;
      end
      else
        GetSearchRec:=97;

    end;



    { --------------------------------------- }

    { Stk1ExtSObj Methods }

    { --------------------------------------- }


    Constructor Stk1ExtSObj.Init;

    Begin

      ExtStkobj.Init;

    end;



    Destructor  Stk1ExtSObj.Done;
    Begin

      ExtStkObj.Done;

    end;


    Procedure Stk1ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                          Fnum          :  Integer;
                                          FStkCode      :  Str20;
                                          CCDep         :  CCDepType;
                                          IsCC          :  Boolean);


    Begin
      With SetSearchRec^.Filter.FilterS1 do
      Begin

        ExtSTkObj.Prime_InitRec(ExtendHead,ExtendTail,Fnum,Sizeof(SetSearchRec^.Filter.FilterS1));


        With ExtendHead do
        Begin
          NumTerms:=2;
        end;

        With Term1 do
        Begin
          FieldType:=BString;

          FieldLen:=Pred(Sizeof(Id.StockCode));  {* Do not Allow for Length byte on this search
                                                    as otherwise it is not recognised as a key field,
                                                    and will search to the end of the file for a match. *}

          Blank(Compare1,Sizeof(Compare1));

          FieldOffset:=GEStkC;

          CompareCode:=1; {* Compare= *}
          LogicExpres:=1;

          Move(FStkCode[1],Compare1,Ord(FStkCode[0]));

        end;

        With Term2 do
        Begin
          FieldType:=BString;

          FieldLen:=Sizeof(Id.CCDep[BOff]);

          If (IsCC) then
            FieldOffset:=GECC
          else
            FieldOffSet:=GEDep;

          CompareCode:=1; {* Compare= *}
          LogicExpres:=0;

          Compare2:=CCDep[IsCC];

        end;

      end; {With..}

    end;


    Function  Stk1ExtSObj.GetSearchRec2(Fnum,
                                        Keypath   :  Integer;
                                    Var KeyS      :  Str255;
                                        FStkcode  :  Str20;
                                        CCDep     :  CCDepType;
                                        IsCC      :  Boolean)  :  Integer;



    Begin
      SetStkObj1(SearchStkRec,Fnum,FStkCode,CCDep,IsCC);

      GetSearchRec2:=ExtStkObj.GetSearchRec(Fnum,Keypath,Sizeof(SearchStkRec^),SearchStkRec,KeyS);

    end; {Func..}

    { --------------------------------------- }

    { Stk2ExtSObj Methods }

    { --------------------------------------- }


    Constructor Stk2ExtSObj.Init;

    Begin

      Stk1ExtSObj.Init;

    end;



    Destructor  Stk2ExtSObj.Done;
    Begin

      Stk1ExtSObj.Done;

    end;



    Procedure Stk2ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                          Fnum          :  Integer;
                                          FStkCode      :  Str20;
                                          CCDep         :  CCDepType);


    Begin
      With SetSearchRec^.Filter.FilterS2 do
      Begin

        Stk1ExtSObj.SetStkObj1(SetSearchRec,Fnum,FStkCode,CCDep,BOff);

        Prime_TailFilter(ExtendTail,Fnum);


        With ExtendHead do
        Begin
          DescLen:=Sizeof(SetSearchRec^.Filter.FilterS2);
        end;

        With Term2 do
        Begin
          FieldLen:=Sizeof(Id.CCDep);

          FieldOffset:=GEDep;

          Compare2:=CCDep;

        end;


      end; {With..}

    end;


    Function  Stk2ExtSObj.GetSearchRec2(Fnum,
                                       Keypath   :  Integer;
                                   Var KeyS      :  Str255;
                                       FStkcode  :  Str20;
                                       CCDep     :  CCDepType)  :  Integer;




    Begin
      SetStkObj1(SearchStkRec,Fnum,FStkCode,CCDep);

      GetSearchRec2:=ExtStkObj.GetSearchRec(Fnum,Keypath,Sizeof(SearchStkRec^),SearchStkRec,KeyS);

    end; {Func..}

    { --------------------------------------- }

    { Stk3ExtSObj Methods }

    { --------------------------------------- }


    Constructor Stk3ExtSObj.Init;

    Begin

      Stk2ExtSobj.Init;

    end;



    Destructor  Stk3ExtSObj.Done;
    Begin

      Stk2ExtSObj.Done;

    end;


    Procedure Stk3ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                          Fnum          :  Integer;
                                          FStkCode      :  Str20;
                                          FCusCode      :  Str10;
                                          CCDep         :  CCDepType;
                                          IsCC          :  Boolean);


    Begin
      With SetSearchRec^.Filter.FilterS3 do
      Begin

        Stk1ExtSObj.SetStkObj1(SetSearchRec,Fnum,FStkCode,CCDep,IsCC);

        Prime_TailFilter(ExtendTail,Fnum);


        With ExtendHead do
        Begin
          NumTerms:=3;

          DescLen:=Sizeof(SetSearchRec^.Filter.FilterS3);

        end;

        Term2.LogicExpres:=1;

        With Term3 do
        Begin
          FieldType:=BString;

          FieldLen:=Sizeof(Compare3);

          FieldOffSet:=GEIdCU;

          CompareCode:=1; {* Compare= *}
          LogicExpres:=0;

          Move(FCusCode[1],Compare3,FieldLen);

          {Compare3:=FCusCode;}

        end;

      end; {With..}

    end;


    Function  Stk3ExtSObj.GetSearchRec2(Fnum,
                                        Keypath   :  Integer;
                                    Var KeyS      :  Str255;
                                        FStkcode  :  Str20;
                                        FCusCode  :  Str10;
                                        CCDep     :  CCDepType;
                                        IsCC      :  Boolean)  :  Integer;



    Begin
      SetStkObj1(SearchStkRec,Fnum,FStkCode,FCusCode,CCDep,IsCC);

      GetSearchRec2:=ExtStkObj.GetSearchRec(Fnum,Keypath,Sizeof(SearchStkRec^),SearchStkRec,KeyS);

    end; {Func..}


    { --------------------------------------- }

    { Stk4ExtSObj Methods }

    { --------------------------------------- }


    Constructor Stk4ExtSObj.Init;

    Begin

      Stk3ExtSObj.Init;

    end;



    Destructor  Stk4ExtSObj.Done;
    Begin

      Stk3ExtSObj.Done;

    end;



    Procedure Stk4ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                          Fnum          :  Integer;
                                          FStkCode      :  Str20;
                                          FCusCode      :  Str10;
                                          CCDep         :  CCDepType);


    Begin
      With SetSearchRec^.Filter.FilterS4 do
      Begin

        Stk2ExtSObj.SetStkObj1(SetSearchRec,Fnum,FStkCode,CCDep);

        Prime_TailFilter(ExtendTail,Fnum);


        With ExtendHead do
        Begin

          NumTerms:=3;

          DescLen:=Sizeof(SetSearchRec^.Filter.FilterS4);
        end;


        Term2.LogicExpres:=1;

        With Term3 do
        Begin
          FieldType:=BString;

          FieldLen:=Sizeof(Compare3);

          FieldOffSet:=GEIdCU;

          CompareCode:=1; {* Compare= *}
          LogicExpres:=0;

          Move(FCusCode[1],Compare3,FieldLen);

          {Compare3:=FCusCode;}

        end;



      end; {With..}

    end;


    Function  Stk4ExtSObj.GetSearchRec2(Fnum,
                                        Keypath   :  Integer;
                                    Var KeyS      :  Str255;
                                        FStkcode  :  Str20;
                                        FCusCode  :  Str10;
                                        CCDep     :  CCDepType)  :  Integer;




    Begin
      SetStkObj1(SearchStkRec,Fnum,FStkCode,FCusCode,CCDep);

      GetSearchRec2:=ExtStkObj.GetSearchRec(Fnum,Keypath,Sizeof(SearchStkRec^),SearchStkRec,KeyS);

    end; {Func..}




    { --------------------------------------- }

    { Stk5ExtSObj Methods }

    { --------------------------------------- }


    Constructor Stk5ExtSObj.Init;

    Begin

      Stk4ExtSobj.Init;

    end;



    Destructor  Stk5ExtSObj.Done;
    Begin

      Stk4ExtSObj.Done;

    end;


    Procedure Stk5ExtSObj.SetStkObj1(Var  SetSearchRec  :  SearchStkPtr;
                                          Fnum          :  Integer;
                                          FStkCode      :  Str20;
                                          FCusCode      :  Str10);

    Var
      CCDep         :  CCDepType;


    Begin
      With SetSearchRec^.Filter.FilterS5 do
      Begin

        Blank(CCDep,Sizeof(CCDep));

        Stk1ExtSObj.SetStkObj1(SetSearchRec,Fnum,FStkCode,CCDep,BOff);

        Prime_TailFilter(ExtendTail,Fnum);


        With ExtendHead do
        Begin
          NumTerms:=2;

          DescLen:=Sizeof(SetSearchRec^.Filter.FilterS5);

        end;

        With Term2 do
        Begin
          FieldType:=BString;

          FieldLen:=Sizeof(Compare2);

          FieldOffSet:=GEIdCU;

          CompareCode:=1; {* Compare= *}
          LogicExpres:=0;


          Move(FCusCode[1],Compare2,FieldLen);

          {Compare2:=FCusCode;}

        end;

      end; {With..}

    end;


    Function  Stk5ExtSObj.GetSearchRec2(Fnum,
                                        Keypath   :  Integer;
                                    Var KeyS      :  Str255;
                                        FStkcode  :  Str20;
                                        FCusCode  :  Str10)  :  Integer;



    Begin
      SetStkObj1(SearchStkRec,Fnum,FStkCode,FCusCode);

      GetSearchRec2:=ExtStkObj.GetSearchRec(Fnum,Keypath,Sizeof(SearchStkRec^),SearchStkRec,KeyS);

    end; {Func..}




    { --------------------------------------- }

    { StkExtSObj Methods }

    { --------------------------------------- }


    Constructor StkExtSObj.Init;

    Begin

      Stk5ExtSObj.Init;

    end;



    Destructor  StkExtSObj.Done;
    Begin

      Stk5ExtSObj.Done;

    end;





    Function  StkExtSObj.GetSearchRec(Fnum,
                                     Keypath   :  Integer;
                                 Var KeyS      :  Str255;
                                     FStkcode  :  Str20;
                                     FCusCode  :  Str10;
                                     CCDep     :  CCDepType;
                                     Mode      :  Byte)  :  Integer;




    Begin

      Case Mode of

        1
             :  With MTExLocal^ do
                  GetSearchRec:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

        2,3  :  GetSearchRec:=Stk1ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FStkCode,CCDep,(Mode=2));

        4    :  GetSearchRec:=Stk2ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FStkCode,CCDep);

        5    :  GetSearchRec:=Stk5ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FStkCode,FCusCode);

        6,7  :  GetSearchRec:=Stk3ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FStkCode,FCusCode,CCDep,(Mode=6));

        8    :  GetSearchRec:=Stk4ExtSObj.GetSearchRec2(Fnum,Keypath,KeyS,FStkCode,FCusCode,CCDep);
        else  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
          raise Exception.Create('Invalid Mode in IdExtSObj.GetSearchRec: ' + IntToStr(Mode));

      end; {Case..}

    end; {Func..}


  {$ENDIF}




{$ENDIF}


end.


