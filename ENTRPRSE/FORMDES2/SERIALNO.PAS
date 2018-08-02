Unit serialno;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 01/08/94                      }
{             Definition Processor Support Unit III            }
{                                                              }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Dialogs,
     Forms,
     SysUtils,
     GlobVar,
     VarConst,
     VarRec2U,
     BtrvU2;



Const
  MaxLabelaX =    10;  {* Maximum labes across allowed *}

  MaxNoUDV   =    9;   {* Maximum no user definavble vars *}


Type

  LabelStockType  =  Record

                       LabelStock  :  StockRec;

                       DelDocFolio :  LongInt;

                       DelDocAcc   :  Str10;

                       DelLineAddr :  LongInt;

                     end;

  StaCtrlRecType  =  Record

                       StaAgedDate  :  LongDate;

                       ShowMonthDoc,
                       SepCr,
                       UseScr,
                       FoundSta     :  Boolean;

                       RepPtr       :  Pointer;

                       ThisCr       :  Byte;

                       CrFlags      :  Array[0..CurrencyType] of Boolean;

                     end;

  StaCtrlRec =    ^StaCtrlRecType;


  FieldCtrlType  =  Record

                      UFlen      :  Byte;
                      UDDecNo    :  Byte;

                      UDDecP     :  Boolean;

                    end;

Var
  SNoFieldWidth : LongInt;
  SNFieldIncInp : Boolean;     { Include Input Documents in search }
  SNDOSMode     : Boolean;

  // HM 28/08/03 v5.52
  SNoShowBins   : Boolean;
  SNoShowUseBy  : Boolean;

  {SNMode     :    Boolean;}

  {UsrDefVar  :    Array[0..MaxNoUDV] of ^Str80;}

  {DefTotals  :    AgedTyp;
  DefTotals2 :    ^AgedTyp;}

  {LabMode    :    Byte;

  MPage,
  NoLabsAX,
  LabFnum,
  LabKeypath,
  SNBatch,
  SNWidth
             :    Integer;}

  {LabIsCust  :    Boolean;

  LabEnd     :    ^Str255;}

  {CurrAged   :    Array[CurStart..CurrencyType] of ^AgedTyp;}


  {TInv       :    ^InvRec;
  TCust      :    ^CustRec;}

  {LabelCust  :    Array[1..MaxLabelaX] of ^CustRec;

  LabelProd  :    Array[1..MaxLabelaX] of ^LabelStockType;}



  {DefFVar    :    FileVar;   { === Used so that any external pops do not affect file positioning  === }

  {RepScrLink :    Pointer;}


 (*
  Function PartDefNoteKey(RC,ST  :  Char;
                          CCode  :  Str20)  :  Str30;



  Function Include(Mode  :  Byte)  :  Boolean;

  Procedure CalcDefs(Mode  :  Byte);

  Function NotePadLNo(FNo     :  Integer)  :  Str255;

  Function Short_Oref(FOurRef  :  Str10)  :  Str10;
 *)
  {$IFDEF PF_On}

    {$IFDEF STK}

      {$IFDEF SOP}


       { ====== Func to return Serial No/ Batch No. ====== }

       {Function DocSerNo(DocNo  :  Str10;
                         DocLNo,
                         StkFol :  LongInt;
                         Mode   :  Byte)  :  Str20;}

       Procedure Def_BuildSno(Mode   :  Byte;
                          Var DMode  :  Byte;
                          Var Fnum3,
                              Keypath3
                                     :  Integer;
                              ThisPtr
                                     :  Pointer);

       Procedure Show_SNoId(Var IdR  :  IDetail;
                                SNOD :  Str80);

       {Procedure Consol_Pick(Mode,
                             Fnum,
                             Keypath  :  Integer;
                         Var KeyS     :  Str255);}

      {$ENDIF}

    {$ENDIF}

 {$ENDIF}

 (*
  Procedure Def_OverRLen(FCtrl   :  FieldCtrlType;
                     Var IMask   :  InpDiskDesc;
                         Fno     :  LongInt);


  Function Seek_CustInclude(Mode  :  Byte;
                            IsCust:  Boolean;
                            CEnd
                                  :  Str20)  :  Boolean;


  Procedure Seek_LabelCust(Mode    :  Byte;
                             Link,
                             IsCust  :  Boolean;
                             Fnum,
                             Keypath :  Integer;
                             CEnd    :  Str255);

  Function Set_LabIno(Fno  :  Integer;
                      Mode :  Byte)  :  Integer;
 *)

  Function GetNoteNo (Const Source, LType : Byte; FNo : String)  :  Str255;

  Function GetSerialNote (Const NoteNo   : String;
                          Const NoteType : Char) : String;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

  Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETDateU,
   ETMiscU,
   BtSupU1,
   BtKeys1U,
   {ETPrompt,}
   VarFPosU,
   {CurrncyU,}
   ComnUnit,
   ComnU2,
   SysU1,
   SysU2,
   InvListU,
   //InvListFD,
   DicLinkU,

   {$IFDEF PF_On}

     {InvLst2U,}

   {$ENDIF}


   {$IFNDEF JC}

     {$IFDEF STK}

       {RepFSupU,}

     {$ENDIF}

   {$ENDIF}

   {DefSup4U,}

   EntMiscFuncs, //PR: 27/05/2011

   SCRTCH1U;





  { ============ Create Check key for notes ======== }

(******
  { ============ Key Building routines =========== }
  Function PartDefNoteKey(RC,ST  :  Char;
                          CCode  :  Str20)  :  Str30;

  Begin

    PartDefNoteKey:=RC+ST+CCode;

  end; {Func..}
*******)

(*********
  { =============== Filter to see if line should be included ============= }
  Function Include(Mode  :  Byte)  :  Boolean;


  Const
    Fnum     =  InvF;
    KeyPath2 =  InvOurRefK;


  Var
    TBO,
    Loop :  Boolean;

    KeyS :  Str255;

    OldStat
         :  Integer;

    RepSCRO
         :  ScratchPtr;

    StaCtrl
         :  StaCtrlRec;






  Begin
    TBO:=BOff;

    KeyS:='';

    OldStat:=Status;  {* Status preserved here, as otherwise direct docs do
                         not abort properly since a stk/other Bt function will
                         reset Status *}

    RepScrO:=RepScrLink;

    StaCtrl:=RepScrLink; {* For mode 22 operations, if RepScr used with mode 22 this will have to
                            changed *}

    {$IFDEF STK}

      {$IFDEF SOP}

        If (Mode=18) then
        Begin

          If (RepScrO<>NIL) and (RepScr^.RecAddr<>0) then {* Get Id Link unless Serial only line *}
            RepScrO^.Get_Scratch(RepScr^)
          else
            Show_SNoId(Id,RepScr^.KeyStr);

        end;

      {$ENDIF}

      With StaCtrl^ do
      If (Mode=22) and (ShowMonthDoc) then
      Begin

        RepScrO:=RepPtr;

        If (RepScrO<>NIL) and (RepScr^.RecAddr<>0) then {* Get Id Link unless Serial only line *}
          RepScrO^.Get_Scratch(RepScr^);

      end;


      If (Mode In [1,7,12,13,14,18,23]) then  {* Establish link to stock record *}
      With Id do
      Begin

        If (Is_FullStkCode(StockCode)) and (StockCode<>Stock.StockCode) and (Mode<>23) then
          GetStock(StockCode,KeyS,-1);

        If (Not Is_FullStkCode(StockCode)) then {* Blank Last Stock Rec *}
          ResetRec(StockF);


        {$IFDEF PF_On}

          If (JBCostOn) then
          Begin

            If (Not EmptyKey(JobCode,Fpos[IHJCNo])) then
              GetJob(JobCode,KeyS,-1);

            If (Not EmptyKey(AnalCode,Fpos[IHJANo])) then
              GetJobMisc(AnalCode,KeyS,2,-1);

            {$IFDEF JC}

              If (Mode=23) then {* Get Payrate *}
                GetEmpRate(StockCode,KeyS,-1);

            {$ENDIF}

          end;

        {$ENDIF}

      end;

    {$ENDIF}


    {$IFDEF PF_On}

      If (Mode In [24]) then
      With JobDetl^.JobActual do
      Begin

        If (CheckRecExsists(LineORef,InvF,InvOurRefK)) then
        Begin

          If (CheckRecExsists(FullIdKey(LineFolio,LineNo),IdetailF,IdLinkK)) then
          Begin

            {$IFDEF STK}

              If (Is_FullStkCode(StockCode)) then
                GetStock(StockCode,KeyS,-1);

            {$ENDIF}


            GetJobMisc(AnalCode,KeyS,2,-1);

          end;
        end;
      end;


    {$ENDIF}


    Case Mode of
      1,23
         :  Begin
              TBO:=(Id.LineNo<>RecieptCode);

            end;

      2  :  With Password.MatchPayRec do
            Begin

              TBO:=(PayRef=RemitDoc);

              If (TBO) then  {* Link up to Invoice Record *}
              Begin
                KeyS:=DocCode;

                ResetRec(Fnum);

                If (KeyS<>'') then
                  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
              end; {If..}

            end; {With..}


    
      3,4,22
         :  Begin

              {$IFDEF MC_On}

                TBO:=(CurrencyOS(Inv,On,Off,Off)<>0);

              {$ELSE}

                TBO:=(BaseTotalOS(Inv)<>0);

              {$ENDIF}

              With StaCtrl^ do
              Case Mode of

                22   :  Begin

                          TBO:=(((TBO) or (ShowMonthDoc)) and ((Inv.Currency=ThisCr) or (Not SepCr)));

                          {$IFNDEF JC}

                            TBO:=(TBO and ((Get_StaChkDate(Inv)<=StaAgedDate) or (Syss.IncNotDue)));

                          {$ENDIF}

                        end;

              end; {Case..}

              TBO:=(TBO and (Not(Inv.InvDocHed In QuotesSet+PSOPSet)) and (Inv.NomAuto));

              {$IFNDEF JC}

                If (Mode In [3,4]) and (Not Syss.IncNotDue) then
                  TBO:=(TBO and (Get_StaChkDate(Inv)<=Today));

              {$ENDIF}


              {* On Debt chase letters, only include those relevent to the letter *}

              If (TBo) and (Mode=4) and (Not Syss.IncNotDue) then
                TBo:=(CalcWksODue(Inv.DueDate)>=Cust.CreditStatus);

            end;


      5  :  TBO:=((Inv.NomAuto) and (Not(Inv.InvDocHed In PSOPSet)));

      6..13,17,18,25
         :  TBo:=On;

    {$IFDEF STK}



      14
         :  With Id do  {* Matching picking Run, and Product type, ignore blank or desc only lines *}
              TBo:=((SOPLineNo=Inv.PickRunNo) and (Stock.StockType In StkProdSet)
                   and ((Is_FullStkCode(StockCode)) or ((Mode=14) and (KitLink=0))));




    {$ENDIF}

    {$IFDEF PF_On}

        24
          :  With JobDetl^.JobActual do
             Begin
               TBo:=((Posted) and (InvRef=TInv^.OurRef));
             end;

    {$ENDIF}

    end; {Case..}

    Status:=OldStat;

    Include:=TBO;
  end; {Func..}
*******)


(*******
  { ================= Calculate Definitions ================== }
  Procedure CalcDefs(Mode  :  Byte);

  Var
    Rnum  :  Real;

    StaCtrl
          :  StaCtrlRec;

    StaDate
          :  LongDate;


  Begin

    Rnum:=0;


    StaCtrl:=RepScrLink;


    Case Mode of

      1,18,23
         :  With Id do
            Begin

              DefTotals2^[0]:=DefTotals2^[0]+1;  {Increase per line}

              {$IFDEF STK}



                If (Is_FullStkCode(StockCode)) then
                Begin

                  DefTotals2^[1]:=DefTotals2^[1]+1;

                  DefTotals[2]:=DefTotals[2]+DivWChk(Qty_OS(Id),RealStr(Strip('B',[#32],Stock.BinLoc)));

              {$ELSE}

                Begin
              {$ENDIF}

                  DefTotals[6]:=DefTotals[6]+Qty;
                end;

            end;

      3,4,5,22
         :  With Inv do
            Begin

              Case Mode of

                4,22
                    :  StaDate:=StaCtrl^.StaAgedDate;

                else   StaDate:=Today;

              end; {Case..}


              {$IFNDEF JC}

                {$IFDEF MC_On}

                  With Syss do
                    MasterAged(CurrAged[Currency]^,Get_StaChkDate(Inv),StaDate,CurrencyOS(Inv,Off,Off,Off),
                               StaAgeMthd,StaAgeInt);

                {$ENDIF}

                  With Syss do
                    MasterAged(CurrAged[0]^,Get_StaChkDate(Inv),StaDate,BaseTotalOs(Inv),StaAgeMthd,StaAgeInt);

              {$ENDIF}

                {* Add Doc Total Value *}

                Rnum:=ConvCurrItotal(Inv,Off,On,On)*DocCnst[Inv.InvDocHed]*DocNotCnst;

                DefTotals[1+(Ord(Rnum<0))]:=DefTotals[1+(Ord(Rnum<0))]+ABS(Rnum);


                {* Give Running Total, Own Currency if Showing one currency *}

                {$IFDEF MC_On}

                  If (StaCtrl^.SepCr) then
                    DefTotals[5]:=DefTotals[5]+CurrencyOS(Inv,Off,Off,Off)
                  else
                    DefTotals[5]:=DefTotals[5]+BaseTotalOS(Inv);

                {$ELSE}

                   DefTotals[5]:=DefTotals[5]+BaseTotalOS(Inv);

                 {$ENDIF}


            end;

        2   :  With PassWord.MatchPayRec do
               Begin
                 Rnum:=OwnCVal*DocNotCnst;

                 DefTotals[5]:=DefTotals[5]+Rnum;
               end;



      {$IFDEF SOP}

        13  :  Begin

                 DefTotals[4]:=DefTotals[4]+DefTotals[1];

                 DefTotals[5]:=DefTotals[5]+DefTotals[2];

                 DefTotals[6]:=DefTotals[6]+DefTotals[3]; {* Weight *}

                 DefTotals[7]:=DefTotals[7]+DefTotals[0]; {* No Cartons *}

               end;

        14  :  Begin

                 DefTotals[4]:=DefTotals[4]+Qty_OS(Id);

                 DefTotals[5]:=DefTotals[5]+Id.QtyPick;

                 {* Specials for carton totals *}

                 DefTotals[2]:=DefTotals[2]+DivWChk(Qty_OS(Id),RealStr(Strip('B',[#32],Stock.BinLoc)));

                 DefTotals[6]:=DefTotals[6]+DivWChk(Id.QtyPick,RealStr(Strip('B',[#32],Stock.BinLoc)));;

               end;

      {$ENDIF}

      {$IFDEF PF_On}

        24  :  With JobDetl^.JobActual do
               Begin

                 DefTotals[1]:=DefTotals[1]+(Qty*Cost)*DocCnst[JDDT];

                 DefTotals[2]:=DefTotals[2]+(Charge)*DocCnst[JDDT];

               end;

      {$ENDIF}

    end;
  end;
*******)


(*******
 { ==== Procedure to Return mode values for finding note lines ==== }
 Procedure Calc_NoteMode(CurrNo  :  Integer;
                     Var LKey    :  Str255;
                     Var LNo     :  LongInt);


 Var
   LMode,
   LType   :   Byte;

 Begin

   LMode:=0;
   LType:=0;

   LKey:='';

   LNo:=0;

   LMode:=(1*Ord((CurrNo>=7000) and (CurrNo<=7199)))+
          (2*Ord((CurrNo>=7200) and (CurrNo<=7399)))+
          (3*Ord((CurrNo>=7400) and (CurrNo<=7599)));

   Case LMode of

     1  :  Begin

             
             If (CurrNo>7099) then
               LType:=2
             else
               LType:=1;

             LKey:=PartDefNoteKey(NoteTCode,NoteCCode,FullNCode(Cust.CustCode))+Chr(LType+48);


           end;

     2  :  Begin

             If (CurrNo>7299) then
               LType:=2
             else
               LType:=1;

             LKey:=PartDefNoteKey(NoteTCode,NoteDCode,FullNCode(FullNomKey(Inv.FolioNum)))+Chr(LType+48);

           end;

     3  :  Begin

             If (CurrNo>7499) then
               LType:=2
             else
               LType:=1;

             LKey:=PartDefNoteKey(NoteTCode,NoteSCode,FullNCode(FullNomKey(Stock.StockFolio)))+Chr(LType+48);

           end;

   end; {Case}

   LNo:=CurrNo-(6899+(LMode*100)+((Pred(LType)+Pred(LMode))*100));

 end; {Proc..}
*******)



(*******
 { ====== Func to return Note Lines ====== }
 Function NotePadLNo(FNo     :  Integer)  :  Str255;


 Const
   Fnum         =  PWrdF;
   Keypath      =  PWK;


 Var
   KeyS,
   KeyChk   :  Str255;
   TmpPWrd  :  PasswordRec;

   TmpKPath,
   TmpStat
            :  Integer;

   FoundOk  :  Boolean;

   TmpStr,
   NoteKey  :  Str255;

   ICount,
   NLNo,
   TmpRecAddr
            :  LongInt;


 Begin

   FoundOk:=Off;

   TmpPWrd:=PassWord;

   TmpKPath:=GetPosKey;

   TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,Off,Off);


   TmpStr:='';

   ICount:=0;


   Calc_NoteMode(FNo,NoteKey,NLNo);


   KeyChk:=NoteKey;

   KeyS:=KeyChk;

   Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

   While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),On)) and (Not FoundOk) do
   With PassWord.NotesRec do
   Begin

     Inc(ICount);

     FoundOk:=(ICount=NLNo);

     If (Not FoundOk) then
     Begin

       Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
     end;

   end; {While..}

   If (FoundOk) then
     TmpStr:=PassWord.NotesRec.NoteLine;

   TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,On,Off);

   PassWord:=TmpPWrd;


   NotePadLNo:=TmpStr;

 end; {Func..}
*******)


(*******
 { ====== Function to Return unpadded ourref ===== }
 Function Short_Oref(FOurRef  :  Str10)  :  Str10;

 Var
   TmpS  :  Str10;

 Begin

   TmpS:=Copy(FOurRef,1,3)+Strip('L',['0'],Copy(FOurRef,4,Length(FOurRef)-3));

   Short_Oref:=TmpS;

 end; {Func..}
*******)



 {$IFDEF PF_ON}
   {$IFDEF STK}
     {$IFDEF SOP}
       (*******
       { ====== Func to return Serial No/ Batch No. ====== }
       Function DocSerNo(DocNo  :  Str10;
                         DocLNo,
                         StkFol :  LongInt;
                         Mode   :  Byte)  :  Str20;

       Const
         Fnum     =  MiscF;
         Keypath  =  MIK;


       Var
         TmpKPath,
         TmpStat
                  :  Integer;

         TmpRecAddr
                  :  LongInt;

         KeyS,
         KeyChk   :  Str255;

         TmpMisc  :  MiscRec;
         TmpFVar  :  FileVar;

         FoundOk  :  Boolean;

         TmpStr   :  Str20;

       Begin

         TmpStr:='';

         FoundOk:=BOff;

         TmpMisc:=MiscRecs^;


         TmpKPath:=GetPosKey;

         TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);


         KeyChk:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StkFol)+#1);

         KeyS:=KeyChk+NdxWeight;

         Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) do
         With MiscRecs^.SerialRec do
         Begin

           FoundOk:=((CheckKey(DocNo,OutDoc,Length(DocNo),BOff)) and (SoldLine=DocLNo));

           If (Not FoundOk) then
             Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         end; {While..}

         If (FoundOk) then
         With MiscRecs^.SerialRec do
         Case Mode of
           1  :  TmpStr:=SerialNo;
           2  :  TmpStr:=BatchNo;
         end; {Case..}

         DocSerNo:=TmpStr;

         MiscRecs^:=TmpMisc;

         TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

       end; {Func..}
       *****)

       { ====== Count Number of Description ====== }

       Function SNO_SeekDesc(RecAddr  :  LongInt;
                             Fnum,
                             Keypath  :  Integer;
                             KeyChk,
                             KeyS     :  Str255)  :  LongInt;


       Var
         Lnum  :  LongInt;



       Begin


         Lnum:=0;


         Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))
              and (Id.KitLink<>0) and (Not Is_FullStkCode(Id.StockCode)) do
         Begin

           Inc(Lnum);

           Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         end;


         SetDataRecOfs(Fnum,RecAddr);  {* Establish old Path *}

         Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

         SNO_SeekDesc:=Lnum;

       end; {Func..}




       { ====== Proc to return Serial No/ Batch No. ====== }

       Procedure Def_BuildSno(Mode   :  Byte;
                          Var DMode  :  Byte;
                          Var Fnum3,
                              Keypath3
                                     :  Integer;
                              ThisPtr
                                     :  Pointer);


       Const
         Fnum      =  IDetailF;
         Keypath   =  IdFolioK;
         Fnum2     =  MiscF;
         Keypath2  =  MIK;


       Var
         KeyS,
         KeyChk,
         KeyS2,
         KeyChk2  :  Str255;

         LinkDoc  :  Str10;

         TmpMisc  :  MiscRec;
         TmpId    :  IDetail;


         FoundOk,
         FoundAny,
         FoundAll, {*EN420}
         SalesDoc,
         Got2Store
                  :  Boolean;

         TmpKPath,
         TmpKPath2,
         TmpStat
                  :  Integer;

         SerCount :  Double; {*EN420}

         LCount,
         TCount,
         RecAddr,
         LinkLNo,
         TmpRecAddr,
         TmpRecAddr2
                  :  LongInt;


         ThisScrt :  ScratchPtr;

         TmpStr,
         AccumStr
                  :  Str255;
         Write2File : Boolean;


       Begin

         LCount:=1;
         TCount:=0;
         RecAddr:=0;

         FoundOk:=BOff;

         FoundAny:=BOff;

         Got2Store:=BOff;

         AccumStr:='';

         {*EN420}

         FoundAll:=BOff; SerCount:=0;

         {*EN420}

         TmpMisc:=MiscRecs^;

         TmpKPath2:=GetPosKey;

         TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOff,BOff);

         TmpId:=Id;

         ThisScrt:=ThisPtr;

         TmpKPath:=GetPosKey;

         TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

         TmpStr:='';  LinkDoc:=''; LinkLNo:=0;

         With Inv do
         Begin

           KeyChk:=FullNomKey(FolioNum);

           KeyS:=FullIdKey(FolioNum,1);

           Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

           SalesDoc:=(Id.IdDocHed In SalesSplit);

           While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) {and (PrntOk) }do
           With Id do
           Begin

             {Loop_CheckKey(PrntOk);}
             Application.ProcessMessages;

             TCount:=1;

             TmpStr:='';

             If (ThisScrt<>NIL) then {* We need to add this anyway, as line had no serial numbers *}
             Begin

               Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Get Preserve IdPosn *}

               ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,FullNomKey(FolioNum)+SetPadNo(Form_Int(LCount,0),6)+'!',
                                     '');

             end;


             If (Is_FullStkCode(StockCode)) then
             Begin

               If (Stock.StockCode<>StockCode) then
                 GetStock(Application.MainForm, StockCode,StockCode,-1);

               // Check to see if line uses Serial/Batch Numbers
               If (Is_SerNo(Stock.StkValType)) then
               Begin

                 {* Take into account how many Desc lines are following *}

                 TCount:=SNO_SeekDesc(RecAddr,Fnum,Keypath,KeyChk,KeyS);

                 { MH 04/06/97: Modified to include unsold input docs }
                 If SNFieldIncInp or (Not SalesDoc) Then
                   KeyChk2:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio))
                 Else
                   KeyChk2:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1);

                 KeyS2:=KeyChk2+NdxWeight;

                 //PR: 27/05/2011 ABSEXCH-11406 Setting LinkDoc from the related order was causing SDNs to show the wrong serial numbers
                 //under certain circumstances.
(*                 If (SOPLink<>0) then
                 Begin
                   LinkDoc:=SOP_GetSORNo(SOPLink);
                   LinkLNo:=SOPLineNo;
                 end
                 else
                 Begin
                   LinkDoc:=OurRef;
                   LinkLNo:=ABSLineNo;
                 end;
*)


                 Got2Store:=BOff;

                 {*EN420}

                 SerCount:=0;

                 FoundAll:=(SerCount>=Abs(Id.SerialQty));

                 {*EN420}

                 AccumStr:='';

                 Status:=Find_Rec(B_GetLessEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS2);
                                                                                          {*EN420}
                 While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not FoundAll) do
                 With MiscRecs^.SerialRec do Begin
                   {Loop_CheckKey(PrntOk);}
                   Application.ProcessMessages;



                   //PR: 27/05/2011 ABSEXCH-11406 Refactored check to new function Funcs\EntMiscFuncs.DoesSerialBelong
                    FoundOK := DoesSerialBelong(OurRef, Id, MiscRecs^.SerialRec);

(*                   {$B+}
                   { MH 04/06/97: Modified to include unsold input docs }
                   { EL 16/08/1997 Modified to check for order lines, and own ref, in line with SOP changes }
                   If SNFieldIncInp or (Not SalesDoc) Then
                     FoundOk:=((CheckKey(LinkDoc,OutDoc,Length(LinkDoc),BOff)) and (SoldLine=LinkLNo)) Or
                              ((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo)) Or
                              ((CheckKey(LinkDoc,OutOrdDoc,Length(LinkDoc),BOff)) and (OutOrdLine=LinkLNo) and (IdDocHed In OrderSet)) Or
                              ((CheckKey(LinkDoc,InDoc,Length(LinkDoc),BOff)) and (BuyLine=LinkLNo) and (Not BatchChild)) or
                              ((CheckKey(OurRef,InDoc,Length(OurRef),BOff)) and (BuyLine=ABSLineNo) and (Not BatchChild)) or
                              ((CheckKey(LinkDoc,InOrdDoc,Length(LinkDoc),BOff)) and (InOrdLine=LinkLNo) and (IdDocHed In OrderSet) and (Not BatchChild))
                   Else
                     FoundOk:=((CheckKey(LinkDoc,OutDoc,Length(LinkDoc),BOff)) and (SoldLine=LinkLNo)) or
                              ((CheckKey(OurRef,OutDoc,Length(OurRef),BOff)) and (SoldLine=ABSLineNo)) Or
                              ((CheckKey(LinkDoc,OutOrdDoc,Length(LinkDoc),BOff)) and (OutOrdLine=LinkLNo) and (IdDocHed In OrderSet));

                   {$B-}
*)

                   If (FoundOk) then
                   Begin


                     If (Not FoundAny) then
                       FoundAny:=BOn;

                     TmpStr:='';
                     Case Mode of
                       1,11  :  TmpStr:=Strip('B',[#32],SerialNo);
                       2,12  :  TmpStr:=Form_Real(QtyUsed,0,Syss.NoQtyDec)+' x '+Strip('B',[#32],BatchNo);
                       3,13  :  Begin
                                  TmpStr:=Strip('B',[#32],SerialNo);


                                  If (Strip('B',[#32],BatchNo)<>'') then
                                  Begin
                                    If (TmpStr<>'') then
                                      TmpStr:=TmpStr+',';

                                    TmpStr:=TmpStr+Form_Real(QtyUsed,0,Syss.NoQtyDec)+' x '+Strip('B',[#32],BatchNo);
                                  end;
                                end;
                     end; {Case..}

                     {$IFDEF EN552}
                     If SNoShowBins Then
                       TmpStr:=TmpStr+','+Trim(StringsRec.fsSVStrs[6])+Trim(InBinCode);
                     {$ENDIF}
                     if SNoShowUseBy Then
                       TmpStr:=TmpStr+','+ Trim(StringsRec.fsSVStrs[7])+POutDateB(DateUseX);

                     If (ThisScrt<>NIL) then
                     Begin

                       // HM 29/08/03: Modified to be >=10 and 0..3 because of changes for handling bins
                       //              whilst hopefully keeping backward compatibility
                       Got2Store:=(Mode>=10);
                       Write2File := (Mode In [0..3]);

                       If (Not Write2File) Then Begin
                         { Multiple numbers per line - measure to see if it will fit }
                         If SNDOSMode Then
                           { DOS style PCC form - characcter width }
                           Write2File := (Length(StringsRec.fsSVStrs[4]+TmpStr+AccumStr) > SNoFieldWidth)
                         Else
                           { Exchequer Form Definition MM width }
                           Write2File := (GetPixWidth (StringsRec.fsSVStrs[4]+TmpStr+AccumStr+'W') > SNoFieldWidth);
                       End; { If }

                       {If (GetPixWidth (StringsRec.fsSVStrs[4]+TmpStr+AccumStr+'W') > SNoFieldWidth) or (Mode<10) then}
                       If Write2File Then
                       Begin

                         If (Mode<10) then
                           AccumStr:=TmpStr;

                         ThisScrt^.Add_Scratch(Fnum,Keypath,0,FullNomKey(FolioNum)+SetPadNo(Form_Int(LCount+Succ(TCount),0),6),
                                               AccumStr);


                         AccumStr:=TmpStr;

                       end
                       else
                       Begin

                         If (AccumStr<>'') then
                           AccumStr:=AccumStr+',';

                         AccumStr:=AccumStr+TmpStr;
                       end;
                     end;

                     {*EN420}
                     If (Not BatchChild) or (SalesDoc) then
                     Begin

                       If (BatchRec) then
                       Begin
                         If (BatchChild) then
                           SerCount:=SerCount+QtyUsed
                         else
                           SerCount:=SerCount+BuyQty;
                       end
                       else
                         SerCount:=SerCount+1.0;
                     end;
                       {*EN420}

                   end;


                   {*EN420}
                   FoundAll:=(SerCount>=Abs(Id.SerialQty));

                   If (Not FoundAll) then
                     Status:=Find_Rec(B_GetPrev,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS2);

                 end; {While..}


                 If (Got2Store) and (ThisScrt<>NIL) then Begin
                   ThisScrt^.Add_Scratch(Fnum,Keypath,0,FullNomKey(FolioNum)+SetPadNo(Form_Int(LCount+Succ(TCount),0),6),
                                         AccumStr);
                 End;
               End // If (Is_SerNo(Stock.StkValType))
               Else
{$IFDEF EN552}
                 // Check to see if line uses Bins
                 If Stock.MultiBinMode And SNoShowBins Then
                 Begin
                   // Take into account how many Desc lines are following
                   TCount:=SNO_SeekDesc(RecAddr,Fnum,Keypath,KeyChk,KeyS);

                   // Check whetherr to include input docs
                   KeyChk2:=FullQDKey(brRecCode,MSERNSub,FullNomKey(Stock.StockFolio));
                   KeyS2:=KeyChk2 + NDXWeight;

                   Got2Store:=BOff;
                   SerCount:=0;
                   FoundAll:=(SerCount>=Id.BinQty);  // NOTE: CAn't do ABS as Bin Qty's can be fractions (e.g. Kilo's)
                   AccumStr:='';

                   Status:=Find_Rec(B_GetLessEq,F[MLocF],MLocF,RecPtr[MLocF]^,MLSecK,KeyS2);

                   While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not FoundAll) Do
                   Begin
                     With MLocCtrl^.brBinRec Do
                     Begin
                       Application.ProcessMessages;

                       // Check to see if we want this Bin
                       If SNFieldIncInp Or (Not SalesDoc) Then
                         // Purchase and Sales Transactions
                         FoundOK := (
                                     // Check the Out Order OurRef
                                     CheckKey(OurRef,brOutOrdDoc,Length(OurRef),BOff) And
                                     (brOutOrdLine=ABSLineNo) And
                                     (IdDocHed In OrderSet+[WOR])
                                    ) Or
                                    (
                                     // Check the out document OurRef
                                     CheckKey(OurRef,brOutDoc,Length(OurRef),BOff) And
                                     (brSoldLine=ABSLineNo)
                                    ) Or
                                    (
                                     // Check the In Order OurRef - don't check bin sales records
                                     CheckKey(OurRef,brInOrdDoc,Length(OurRef),BOff) And
                                     (brInOrdLine=ABSLineNo) And
                                     (IdDocHed In OrderSet+[WOR]) And
                                     (Not brBatchChild)
                                    ) Or
                                    (
                                     // Check the In document OurRef - don't check bin sales records
                                     CheckKey(OurRef,brInDoc,Length(OurRef),BOff) And
                                     (brBuyLine=ABSLineNo) And
                                     (Not brBatchChild)
                                    )
                       Else
                         // Sales (Out Only) - Check its a sales entry and a child and the OurRef matches
                         FoundOK := brSold And brBatchChild And
                                    (
                                     (
                                      // Check the Out Order OurRef
                                      CheckKey(OurRef,brOutOrdDoc,Length(OurRef),BOff) And
                                      (brOutOrdLine=ABSLineNo) And
                                      (IdDocHed In OrderSet+[WOR])
                                     ) Or
                                     (
                                      // Check the out document OurRef
                                      CheckKey(OurRef,brOutDoc,Length(OurRef),BOff) And
                                      (brSoldLine=ABSLineNo)
                                     )
                                    );

                       If FoundOK Then
                       Begin
                         FoundAny := BOn;

                         // Generate text for bin line in scratch file
                         TmpStr:=Trim(StringsRec.fsSVStrs[6])+Form_Real(brQtyUsed,0,Syss.NoQtyDec) + ' x ' + Trim(brBinCode1);
                         if SNoShowUseBy Then
                           TmpStr:=TmpStr+','+ Trim(StringsRec.fsSVStrs[7])+POutDateB(brDateUseX);

                         // Check to see if the accumulating text needs to be stored
                         If (ThisScrt<>NIL) then
                         Begin
                           Got2Store:=(Mode>=10);
                           Write2File := (Mode In [0..3]);

                           If (Not Write2File) Then
                           Begin
                             // Multiple numbers per line - measure to see if it will fit
                             If SNDOSMode Then
                               { DOS style PCC form - character width }
                               Write2File := (Length(StringsRec.fsSVStrs[4]+TmpStr+AccumStr) > SNoFieldWidth)
                             Else
                               { Exchequer Form Definition MM width }
                               Write2File := (GetPixWidth (StringsRec.fsSVStrs[4]+TmpStr+AccumStr+'W') > SNoFieldWidth);
                           End; // If (Not Write2File)

                           If Write2File Then
                           Begin
                             // NOTE: If Mode < 10 (1 Per Line) we are writing out the text just generated,
                             // otherwise the new text is too long to fit on a line with what we have previously
                             // generated so we are writing out what we have previously generated
                             If (Mode < 10) then
                               AccumStr:=TmpStr;

                             ThisScrt^.Add_Scratch(Fnum,Keypath,0,FullNomKey(FolioNum)+SetPadNo(Form_Int(LCount+Succ(TCount),0),6),
                                                   AccumStr);
                             AccumStr:=TmpStr;
                           end
                           else
                           Begin
                             If (AccumStr<>'') then
                               AccumStr:=AccumStr+',';

                             AccumStr:=AccumStr+TmpStr;
                           end;
                         End; // If (ThisScrt<>NIL)

                         If (Not brBatchChild) or (SalesDoc) then
                         Begin
                           // NOTE: btBatchRec SHOULD always be true
                           If (brBatchRec) then
                           Begin
                             If (brBatchChild) then
                               SerCount:=SerCount+Round_Up(brQtyUsed, Syss.NoQtyDec)
                             else
                               SerCount:=SerCount+Round_Up(brBuyQty, Syss.NoQtyDec);
                           end
                           else
                             SerCount:=SerCount+1.0;
                         End; // If (Not brBatchChild) or (SalesDoc)
                       End; // If FoundOK

                       // Check to see if we've got all the Bin details yet
                       FoundAll:=(SerCount>=Id.BinQty);

                       If (Not FoundAll) then
                         // Get the next Bin record
                         Status:=Find_Rec(B_GetPrev,F[MLocF],MLocF,RecPtr[MLocF]^,MLSecK,KeyS2);
                     End; // With MiscRecs^.SerialRec
                   End; // While (StatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn)) and (Not FoundAll)

                   If (Got2Store) and (ThisScrt<>NIL) then
                   Begin
                     ThisScrt^.Add_Scratch(Fnum,Keypath,0,FullNomKey(FolioNum)+SetPadNo(Form_Int(LCount+Succ(TCount),0),6),
                                           AccumStr);
                   End; // If (Got2Store) and (ThisScrt<>NIL)
                 End; // If Stock.MultiBinMode And SNoShowBins
{$ELSE}
  ;
{$ENDIF} // EN552
             end; // If (Is_FullStkCode(StockCode))

             Inc(LCount);
             Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
           end; {While..}

         end; {With..}


         MiscRecs^:=TmpMisc;

         TmpStat:=Presrv_BTPos(Fnum2,TmpKPath2,F[Fnum2],TmpRecAddr2,BOn,BOff);

         Id:=TmpId;

         TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);

         If (FoundAny) then
         Begin

           Fnum3:=ReportF;

           Keypath3:=RpK;

           DMode:=18;

         end;

       end; {Proc..}


       Procedure Show_SNoId(Var IdR  :  IDetail;
                                SNOD :  Str80);

       Var
         TmpId  :  Idetail;
       Begin

         With IdR do
         Begin

           TmpId:=IdR;

           ResetRec(IdetailF);

           StockCode:=TmpId.StockCode;

           Desc:=StringsRec^.fsSVStrs[4]+SNoD;

         end;
       end;


(*******
       { ======= Procedure to Consolidate Picking List ======= }
       Procedure Consol_Pick(Mode,
                             Fnum,
                             Keypath  :  Integer;
                         Var KeyS     :  Str255);


       Var
         KeyRef  :  Str255;

         RepSCRO :  ScratchPtr;


       Begin

         RepScrO:=RepScrLink;

         DefTotals[0]:=0;
         DefTotals[1]:=0;
         DefTotals[2]:=0;
         DefTotals[3]:=0;

         KeyRef:=KeyS;

         While (StatusOk) and (CheckKey(KeyRef,KeyS,Length(KeyRef),On)) do
         With Id do
         Begin

           If (RepScrO<>NIL) then {* Get Id Link *}
             RepScrO^.Get_Scratch(RepScr^);

           If (Include(Mode)) then
           Begin
             DefTotals[1]:=DefTotals[1]+Qty_OS(Id);

             DefTotals[2]:=DefTotals[2]+QtyPick;

             DefTotals[3]:=DefTotals[3]+(QtyPick*LWeight);

             DefTotals[0]:=DefTotals[0]+DivWChk(QtyPick,RealStr(Strip('B',[#32],Stock.BinLoc)));
           end;

           Status:=Find_Rec(B_GetNext,DefFVar,Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         end; {While..}

         If (StatusOk) then
         Begin
           Status:=Find_Rec(B_GetPrev,DefFVar,Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

         end;

       end; {Proc..}
*******)


     {$ENDIF}

   {$ENDIF}



 {$ENDIF}



(*******
  Procedure Def_OverRLen(FCtrl   :  FieldCtrlType;
                     Var IMask   :  InpDiskDesc;
                         Fno     :  LongInt);



  Begin

    With IMask do
    With FCtrl do
    Begin

      IMask:=Fpos[Fno];

      Len:=UFlen;

      If (UDDecP) then
        NoDecs:=UDDecNo;

    end;

  end;
*******)


(*******
    { ========== Global Function to Check inclusion of account range printing ========== }
    Function Seek_CustInclude(Mode  :  Byte;
                              IsCust:  Boolean;
                              CEnd
                                    :  Str20)  :  Boolean;


    Var
      TmpBo  :  Boolean;

      TmpStat:  Integer;




    Begin

      TmpBo:=Off;

      TmpStat:=Status;


      Begin

        Case Mode of
          10  :  TmpBo:=Off;

          {$IFDEF STK}

            {$IFNDEF JC}

              19
                :  With Stock do
                     TmpBo:=(Stk_InGroup(CEnd,Stock) and (StockType In StkProdSet-[StkDListCode]));

            {$ELSE}

              19
                :  TmpBo:=Off;

            {$ENDIF}

            20
              :  With Stock do
                   TmpBo:=(CheckKey(CEnd,StockCode,Length(CEnd),Off));

            21
              :  TmpBo:=On;

          {$ENDIF}

          else   With Cust do
                   TmpBo:=((IsCust=IsACust(CustSupp)) and (CustCode<=CEnd));

        end; {Case..}

      end;

      Status:=TmpStat;

      Seek_CustInclude:=TmpBo;

    end; {Func..}
*******)


(*******
    {$IFDEF SOP}

      { ======== Setup Label ======== }
      Procedure Seek_LinkLab(Var LabLink  :  LabelStockType;
                                 Link     :  Boolean);

      Const
        Fnum     =  InvF;
        Keypath  =  InvFolioK;
        Fnum2    =  IdetailF;
        Keypath2 =  IdFolioK;


      Var
        RepScrO  :  ScratchPtr;

        KeyS     :  Str255;


      Begin

        RepScrO:=RepScrLink;

        With LabLink do
        If (Link) then
        Begin

          If (Cust.CustCode<>DelDocAcc) then
          Begin
            GetCust(DelDocAcc,Off,Off,'');

            If (Not Ok) then
              ResetRec(CustF);
          end;


          If (Inv.FolioNum<>DelDocFolio) then
          Begin
            KeyS:=FullNomKey(DelDocFolio);

            Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

            If (Not StatusOk) then
              ResetRec(Fnum);
          end;

          SetDataRecOfs(Fnum2,DelLineAddr); {* Restore position and path *}

          Status:=GetDirect(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,0);

          If (Not StatusOk) then
            ResetRec(Fnum2);


        end
        else
        With Id do
        Begin

          If (RepScrO<>NIL) then {* Get Id Link *}
            RepScrO^.Get_Scratch(RepScr^);

          GetStock(StockCode,StockCode,-1);

          LabelStock:=Stock;

          DelDocFolio:=FolioRef;

          DelDocAcc:=CustCode;

          DelLineAddr:=RepScr^.RecAddr;

        end; {With..}

      end; {Proc..}

    {$ENDIF}
*******)

(*******
    { ========== Scan for Multiple Label Records ========== }
    Procedure Seek_LabelCust(Mode    :  Byte;
                             Link,
                             IsCust  :  Boolean;
                             Fnum,
                             Keypath :  Integer;
                             CEnd    :  Str255);


    Var
      n     :  Byte;
      KeyS  :  Str255;




    Begin


      For n:=1 to MaxLabelAX do
      Case Mode of

        9,10  :  Blank(LabelCust[n]^,Sizeof(LabelCust[n]^));

        19..21
              :  Blank(LabelProd[n]^,Sizeof(LabelProd[n]^));

      end; {Case..}


      If (Not Link) then
      Begin

        Case Mode of

          9,10  :  LabelCust[1]^:=Cust;

          {$IFDEF STK}

            19,20
                  :  LabelProd[1]^.LabelStock:=Stock;

            {$IFDEF SOP}

              21    :  Seek_LinkLab(LabelProd[1]^,Off);

            {$ENDIF}

          {$ENDIF}


        end; {Case..}

        n:=2;
      end
      else
        n:=1;



      KeyS:='';


      If (Not (Mode In [10,20])) and (n<=NoLabsAX) then
      Begin

        Repeat

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

          If (StatusOk) and (Seek_CustInclude(Mode,IsCust,CEnd)) then
          Begin

            Case Mode of

              9  :  LabelCust[n]^:=Cust;

              {$IFDEF STK}

                19
                   :  LabelProd[n]^.LabelStock:=Stock;

                {$IFDEF SOP}

                  21 :  Seek_LinkLab(LabelProd[n]^,Off);

                {$ENDIF}

              {$ENDIF}


            end; {Case..}

            Inc(n);

          end;

        Until (Not StatusOk) or (n>NoLabsAX) or (n>MaxLabelAX);


      end;


      Case Mode of

        9,10
           :  Cust:=LabelCust[1]^;

        20 :  For n:=1 to MaxLabelAX do {* Set to same for multiple copies *}
                LabelProd[n]^.LabelStock:=Stock;

        19,21
           :  Stock:=LabelProd[1]^.LabelStock;

      end;


    end; {Proc..}
*******)



(*******
    { ========= Function to Set Ino ========= }
    Function Set_LabIno(Fno  :  Integer;
                        Mode :  Byte)  :  Integer;

    Var
      Ino  :  Integer;

    Begin

      Ino:=0;

      Case Mode of
        9,10
          :  Begin
               Ino:=Trunc((Fno-5000)/100)+1;

               Cust:=LabelCust[Ino]^;
             end;

        {$IFDEF STK}

          19..21
            :  Begin

                 Ino:=(Fno-5010);

                 Stock:=LabelProd[Ino]^.LabelStock;

                 {$IFDEF SOP}

                   If (Mode=21) then
                     Seek_LinkLab(LabelProd[Ino]^,On);

                 {$ENDIF}


               end;

        {$ENDIF}


      end; {Case..}

      Set_LabIno:=Ino;
    end;
*******)

{ Function to return Note Lines }
Function GetNoteNo (Const Source, LType : Byte; FNo : String)  :  Str255;
Const
  Fnum         =  PWrdF;
  Keypath      =  PWK;
Var
  KeyS, KeyChk             : Str255;
  TmpPWrd                  : PasswordRec;
  TmpKPath, TmpStat        : Integer;
  FoundOk                  : Boolean;
  TmpStr, NoteKey          : Str255;
  ICount, NLNo, TmpRecAddr : LongInt;
Begin
  { Save PWordF position and record }
  TmpPWrd:=PassWord;
  TmpKPath:=GetPosKey;
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

  NLNo := IntStr(FNo);

  TmpStr:='';

  Case Source Of
    { Cust }
    0 : NoteKey := NoteTCode + NoteCCode + FullNCode(TCust.CustCode) + Chr(LType+48);
    { Inv (CH) }
    1 : NoteKey := NoteTCode + NoteDCode + FullNCode(FullNomKey(TInv.FolioNum)) + Chr(LType+48);
    { Stock }
    2 : NoteKey := NoteTCode + NoteSCode + FullNCode(FullNomKey(Stock.StockFolio)) + Chr(LType+48);
    { Inv (TH) }
    3 : NoteKey := NoteTCode + NoteDCode + FullNCode(FullNomKey(Inv.FolioNum)) + Chr(LType+48);
    { Serial Numbers }
    4 : NoteKey := NoteTCode + NoteRCode + FullNCode(FullNomKey(MiscRecs^.SerialRec.NoteFolio)) + Chr(LType+48);
    { Job Record }
    5 : NoteKey := NoteTCode + NoteJCode + FullNCode(FullNomKey(JobRec.JobFolio)) + Chr(LType+48);
  End; { Case }

  KeyChk:=NoteKey;
  KeyS:=KeyChk;
  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  ICount:=0;
  FoundOk:=BOff;
  While StatusOk And CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) And (Not FoundOk) Do
    With PassWord.NotesRec do Begin
      Inc(ICount);

      FoundOk:=(ICount=NLNo);

      If (Not FoundOk) then Begin

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
      end;
    end; {While..}

  If (FoundOk) then
    TmpStr:=PassWord.NotesRec.NoteLine;

  { Restore PwordF position and record }
  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
  PassWord:=TmpPWrd;

  Result := TmpStr;
End;


{ ====== Proc to return Serial No/ Batch No. ====== }
Function GetSerialNote (Const NoteNo   : String;
                        Const NoteType : Char) : String;
Var
  LinkDoc                     : Str10;
  TmpMisc                     : MiscRec;
  KeyS, KeyChk                : Str255;
  TmpKPath, TmpStat           :  Integer;
  FoundOk, FoundAll, SalesDoc :  Boolean;
  LinkLNo, TmpRecAddr         :  LongInt;
Begin { GetSnoNote }
  Result := '';

  { Save position in MiscF (Serial Numbers) }
  TmpMisc  := MiscRecs^;
  TmpKPath := GetPosKey;
  TmpStat  := Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOff,BOff);

  With Id Do Begin
    { Work out if its Purchase or Sales }
    SalesDoc:=(IdDocHed In SalesSplit);

    { See if there is a valid stock code in the line }
    If Is_FullStkCode(StockCode) Then Begin
      { load if not already loaded }
      If (Stock.StockCode<>StockCode) then
        GetStock(Application.MainForm, StockCode,StockCode,-1);

      If Is_SerNo(Stock.StkValType) Then Begin
        { Build index key to find Serial No's for the stock item }
        If SNFieldIncInp or (Not SalesDoc) Then
          KeyChk := FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio))
        Else
          KeyChk := FullQDKey(MFIFOCode,MSERNSub,FullNomKey(Stock.StockFolio)+#1);
        KeyS := KeyChk + NdxWeight;

        { Work out which document to look for }
        If (SOPLink<>0) then Begin
          LinkDoc:=SOP_GetSORNo(SOPLink);
          LinkLNo:=SOPLineNo;
        End { If SOPLink <> 0 }
        Else Begin
          LinkDoc:=Inv.OurRef;
          LinkLNo:=ABSLineNo;
        End; { Else }

        { Get Serial Record }
        FoundAll := False;
        Status:=Find_Rec(B_GetLessEq,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);

        While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundAll) Do Begin
          With MiscRecs^.SerialRec do Begin
            {Loop_CheckKey(PrntOk);}
            Application.ProcessMessages;

            {$B+}

            { MH 04/06/97: Modified to include unsold input docs }
            { EL 16/08/1997 Modified to check for order lines, and own ref, in line with SOP changes }
            If SNFieldIncInp or (Not SalesDoc) Then
              FoundOk:=((CheckKey(LinkDoc,OutDoc,Length(LinkDoc),BOff)) and (SoldLine=LinkLNo)) Or
                       ((CheckKey(Inv.OurRef,OutDoc,Length(Inv.OurRef),BOff)) and (SoldLine=ABSLineNo)) Or
                       ((CheckKey(LinkDoc,OutOrdDoc,Length(LinkDoc),BOff)) and (OutOrdLine=LinkLNo) and (IdDocHed In OrderSet)) Or
                       ((CheckKey(LinkDoc,InDoc,Length(LinkDoc),BOff)) and (BuyLine=LinkLNo) and (Not BatchChild)) or
                       ((CheckKey(Inv.OurRef,InDoc,Length(Inv.OurRef),BOff)) and (BuyLine=ABSLineNo) and (Not BatchChild)) or
                       ((CheckKey(LinkDoc,InOrdDoc,Length(LinkDoc),BOff)) and (InOrdLine=LinkLNo) and (IdDocHed In OrderSet) and (Not BatchChild))
            Else
              FoundOk:=((CheckKey(LinkDoc,OutDoc,Length(LinkDoc),BOff)) and (SoldLine=LinkLNo)) or
                       ((CheckKey(Inv.OurRef,OutDoc,Length(Inv.OurRef),BOff)) and (SoldLine=ABSLineNo)) Or
                       ((CheckKey(LinkDoc,OutOrdDoc,Length(LinkDoc),BOff)) and (OutOrdLine=LinkLNo) and (IdDocHed In OrderSet));

            {$B-}

            If (FoundOk) Then Begin
              (* HM 24/06/99: Don't need to do this as the Details are duplicated on the Child Record
              If BatchChild Then Begin
                { Find main Batch Record }
                KeyS := FullQDKey(MFIFOCode,MSERNSub,BatchNo);
                KeyChk := KeyS;

                Status:=Find_Rec(B_GetGEq,F[MiscF],MiscF,RecPtr[MiscF]^,MiscBtcK,KeyS);
                While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) And (Not FoundAll) Do Begin
                  If (Not BatchChild) Then Begin
                    { Get notes }
                    Case NoteType Of
                      '0' : Result := DateUseX;
                      '1' : Result := SerialNo;
                      '2' : Result := BatchNo;
                      'G' : Result := GetNoteNo (4, 1, NoteNo);
                      'D' : Result := GetNoteNo (4, 2, NoteNo);
                    End; { Case }
                  End; { If }

                  Status:=Find_Rec(B_GetNext,F[MiscF],MiscF,RecPtr[MiscF]^,MiscBtcK,KeyS);
                End; { While }

                FoundAll := True;
              End { If }
              Else *) Begin
                { Get notes }
                Case NoteType Of
                  '0' : Result := DateUseX;
                  '1' : Result := SerialNo;
                  '2' : Result := BatchNo;
                  'G' : If (NoteFolio > 0) Then
                          Result := GetNoteNo (4, 1, NoteNo);
                  'D' : If (NoteFolio > 0) Then
                          Result := GetNoteNo (4, 2, NoteNo);
                End; { Case }
              End; { Else }

              FoundAll := True;
            End; { If }

            If (Not FoundAll) Then Begin
              { Get next Serial Number record }
              Status:=Find_Rec(B_GetPrev,F[MiscF],MiscF,RecPtr[MiscF]^,MIK,KeyS);
            End; { If }
          End; { With MiscRecs^.SerialRec }
        End; { While }
      End; { If Is_SerNo(Stock.StkValType) }
    End; { If Is_FullStkCode(StockCode) }
  End; { With Id }

  { Restore MiscF }
  MiscRecs^ := TmpMisc;
  TmpStat   := Presrv_BTPos(MiscF,TmpKPath,F[MiscF],TmpRecAddr,BOn,BOff);
End; { GetSnoNote }






Begin
  SNoFieldWidth := 0;
  SNFieldIncInp := False;     { Include Input Documents in search }
  SNDOSMode     := False;

  {
  SNMode:=BOff;

  LabMode:=0;

  LabFnum:=0;

  LabKeypath:=0;

  New(LabEnd);

  LabEnd^:='';

  LabIsCust:=BOff;

  RepScrLink:=NIL;

  DefTotals2:=NIL;
  }




end.