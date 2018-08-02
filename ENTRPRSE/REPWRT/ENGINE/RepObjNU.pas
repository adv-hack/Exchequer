Unit RepObjNU;

{ prutherford440 14:10 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 21/09/94                      }
{                                                              }
{               Rep Gen Object Control Unit III                }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses SysUtils,
     GlobVar,
     VarConst,
     SCRTCH1U,
     MCParser,
     RepObjCU,
     {DebugWin,}
     RwOpenF;

Type

  RepNomCtrlPtr  =  ^RepNomCtrlObj;


  RepNomCtrlObj  =  Object(RepCtrlObj)

                   Procedure ResetScratchTot(Var  RecCount  :  LongInt);


                   Function Get_NomVal(VNo   :  Longint;
                                       NVNo  :  Str10;
                                       FmulaPtr
                                             :  Pointer;
                                       Fnum2,
                                       Keypath2
                                             :  Integer;
                                   Var FErr  :  Byte)  :  Double;

                   Function Is_NomVar(RepStr   :  ShortString;
                                      SPos     :  Byte;
                                  Var FormLen  :  Word;
                                  Var FormName :  ShortString)  :  Boolean;


                   Function  ResolveFmula(VRNo      :  LongInt;
                                          FmulaLPtr,
                                          FmulaFPtr :  Pointer;
                                          FmulaStr  :  Str255;
                                          Fnum2,
                                          Keypath2  :  Integer;
                                      Var FErr      :  Byte)  :  Str80;

                   Procedure Calc_NomFmula(Fnum2,
                                           Keypath2   :  Integer;
                                           FmulaPtr   :  Pointer;
                                       Var FErr       :  Byte);

                   Procedure Process_File; Virtual;

                   Procedure Process_Report; Virtual;

                 end; {Object..}

  RepRunCtrlPtr  =  ^RepRunCtrlObj;


  RepRunCtrlObj  =  Object(RepNomCtrlObj)

                     NomMode  :  Boolean;

                     Constructor Create(AOwner : TObject;RepCRec : RepGenRec);

                     Procedure Process_File; Virtual;

                     Procedure Process_Report; Virtual;

                     Procedure BuildTempData(Var NoFound : LongInt); Virtual;
                   end; {Object..}



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Forms,
   {Crt,
   Dos,
   EWinSBS,}
   ETStrU,
   {ETools2,}
   ETMiscU,
   {ETPrintU,
   ETPrompt,
   EPrntDef,}
   ETDateU,
   {ExAsvarU,
   PrintU,}

   BtrvU2,
   BtSupU1,

   RpCommon,
   RwFuncs,

   VarFposU,
   ComnUnit,
   ComnU2,
   InvListU,
   SysU1,
   RepObj2U;




   { ---------------------------------------------------------------- }

   {  RepNomCtrl Methods }

   { ---------------------------------------------------------------- }



  Procedure RepNomCtrlObj.ResetScratchTot(Var  RecCount  :  LongInt);

  Const
    Fnum2    =  RepGenF;
    Keypath2 =  RGK;


  Var
    Locked  :  Boolean;
    RecAddr : LongInt;

  Begin
    With MtExLocal^ Do Begin
      Locked:=BOff;

      KeyChk:=FullRepKey(ReportGenCode,RepNomCode,RepCtrlRec^.RepName);

      KeyS:=KeyChk;

      RecCount:=0;

      LStatus:=LFind_Rec(B_GetGEq,FNum2,KeyPath2,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
        With LRepGen^.ReportNom do Begin
          Inc(RecCount);

          If (CalcField) Then Begin

            {Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked,RecAddr);}
            Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

            If (Ok) and (Locked) then Begin
              LGetRecAddr(Fnum2);

              Blank(NomTotals,Sizeof(NomTotals));

              (*
              Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);
              Report_BError(FNum2, Status);
              { Need to release multiple-record lock }
              Status:=UnLockMultiSing(F[Fnum2],Fnum2,RecAddr);
              *)

              LStatus:=LPut_Rec(Fnum2,KeyPath2);
              LReport_BError(Fnum2,LStatus);
              LStatus:=LUnLockMLock(Fnum2);
            end;

          end;

          LStatus:=LFind_Rec(B_GetNext,FNum2,KeyPath2,KeyS);
        End; { With }
    End; { With }
  end;


  { ======== Procedure(s) to Calculate Nominal Formulas ======== }

  Function RepNomCtrlObj.Get_NomVal(VNo   :  Longint;
                                    NVNo  :  Str10;
                                    FmulaPtr
                                          :  Pointer;
                                    Fnum2,
                                    Keypath2
                                          :  Integer;
                                Var FErr  :  Byte)  :  Double;


  Var
    Key2S       :  Str255;

    FmulaCtrl   :  RepLinePtr;

    Rnum        :  Double;

    Lnum        :  LongInt;

    Selected    :  Boolean;


  Begin
    With MtExLocal^ Do Begin
      FmulaCtrl:=FmulaPtr;

      Rnum:=0;

      Selected:=BOff;

      Key2S:=PartCCKey(ReportGenCode,RepNomCode)+FullRepLineKey(RepCtrlRec^.RepName,RepNomCode,NVNo);

      LStatus:=LFind_Rec(B_GetEq,FNum2,KeyPath2,Key2S);

      If (LStatusOk) then
      With LRepGen^.ReportNom do Begin

        If (Not CalcField) then
        Begin

          GetNom(Application.MainForm,NomRef,Lnum,-1);

          With FmulaCtrl^ do
          Begin
            Selected:=BOn;

            FillObject(Selected);

            If (Selected) then
            Begin
              Selected:=BOff;

              FillObject(Selected);

              If (FindObj(VNo)) then
                Rnum:=RepField^.GetValue(BOff);
            end
            else
              Rnum:=0;

          end;

        end
        else
        Begin

          Rnum:=NomTotals[VNo];

        end;
      end {If Line Found Ok..}
      else
        FErr:=1;

      Get_NomVal:=Rnum;
    End; { With }
  end; {Func..}


  {* ------------------------ *}



  Function RepNomCtrlObj.Is_NomVar(RepStr   :  ShortString;
                                   SPos     :  Byte;
                               Var FormLen  :  Word;
                               Var FormName :  ShortString)  :  Boolean;

  Var
    TmpBo,
    FoundOk
           :  Boolean;
    CPos,
    Rl     :  Byte;




  Begin


    FoundOk:=FALSE;

    RL:=Length(RepStr);

    TmpBo:=(RepStr[SPos] In [RepNomCode]);

    If (TmpBo) then
    Begin

      CPos:=Succ(Spos);

      While (Cpos<=Rl) and (Not FoundOk) do
      Begin

        FoundOk:=(Not (RepStr[Cpos] In ['0'..'9']));

        If (Not FoundOk) then
          Inc(Cpos);

      end;

      FormLen:=Pred(Cpos-Spos);

      FormName:=Copy(RepStr,Succ(SPos),FormLen);

    end
    else
    Begin

      FormLen:=0;

      FormName:='';

    end;

    Is_NomVar:=TmpBo;


  end; {Func..}

  {* ------------------------ *}


  Function  RepNomCtrlObj.ResolveFmula(VRNo      :  LongInt;
                                       FmulaLPtr,
                                       FmulaFPtr :  Pointer;
                                       FmulaStr  :  Str255;
                                       Fnum2,
                                       Keypath2  :  Integer;
                                   Var FErr      :  Byte)  :  Str80;

  Var
    TmpFmula   :  Str255;
    FmulaLCtrl :  RepLinePtr;
    FmulaFCtrl :  RepFieldPtr;

    FmulaNoDecs,
    n,m       :  Byte;

    flen      :  Word;

    Rnum      :  Double;

    NomRef    :  Str10;


  Begin
{DBug.MsgI (0, 'Begin RepNomCtrlObj.ResolveFmula', 3);}

    FmulaLCtrl:=FmulaLPtr;

    FmulaFCtrl:=FmulaFPtr;
{DBug.Msg (1, 'VRNo='+IntToStr(VRNo)+', ' + 'Fmla=' + FmulaStr);}

    TmpFmula:=FmulaStr;

    n:=0; flen:=0; m:=0;

    NomRef:='';

    Rnum:=0;

    n:=Pos(RepNomCode,TmpFmula);

    FmulaNoDecs:=FmulaFCtrl^.RepFieldRec^.RepDet.NoDecs;

    If (n<>0) then
    Begin

      While (n<>0) do
      Begin

        If (Is_NomVar(TmpFmula,n,Flen,NomRef)) then
        Begin
{DBug.Msg (1, 'NomRef=' + NomRef);}

         NomRef:=SetPadNo(NomRef,VNoLen);

          Rnum:=Get_NomVal(VRNo,NomRef,FmulaLCtrl,Fnum2,Keypath2,FErr);
{DBug.Msg (1, 'RNum=' + Form_Real(Rnum,0,FmulaNoDecs));}

          m:=Succ(n+Flen);

          TmpFmula:=Copy(TmpFmula,1,Pred(n))+Form_Real(Rnum,0,FmulaNoDecs)+Copy(TmpFmula,m,Succ(Length(TmpFmula)-m));
{DBug.Msg (1, 'TmpFmula=['+IntToStr(Length(TmpFmula))+']' + TmpFmula);}
        end
        else
          FErr:=1;

        n:=Pos(RepNomCode,TmpFmula);

      end; {While..}

    end;

    With FmulaLCtrl^ do
      ResolveFmula:=SetFormula(TmpFmula,FmulaNoDecs,n);

{DBug.Indent (-3);
DBug.Msg (0, 'End RepNomCtrlObj.ResolveFmula');}
  end; {Func..}



  {* ------------------------ *}


  Procedure RepNomCtrlObj.Calc_NomFmula(Fnum2,
                                        Keypath2   :  Integer;
                                        FmulaPtr   :  Pointer;
                                    Var FErr       :  Byte);

  Var

    TmpNomRec  :  ^ReportNomType;

    RecAddr,
    RecAddr2,
    VrNo       :  LongInt;


    Locked     :  Boolean;

    FmulaCtrl  :  RepLinePtr;

    LocalRField:  RepFieldPtr;

    LocalNode  :  NodePtr;



  Begin
{DBug.MsgI (0, 'Begin RepNomCtrlObj.Calc_NomFmula', 3);}

    With MtExLocal^ Do Begin
      New(TmpNomRec);

      VrNo:=0;  Locked:=BOff;

      TmpNomRec^:=LRepGen^.ReportNom;

      LStatus:=LGetPos(Fnum2,RecAddr);

      FmulaCtrl:=FmulaPtr;

      With LineCtrl^ do
      Begin
        LocalNode:=GetFirst;

        While (LocalNode<>NIL) do
        Begin

          LocalRField:=LocalNode^.LITem;

          With LocalRField^ do
          With RepFieldRec^ do
          Begin

            If (RepDict.VarType In ITypValSet-LnumValSet) then
            Begin

              VrNo:=RepDet.RepVarNo;

              If (VrNo<MaxNomTots) then
              With TmpNomRec^ do
              Begin

                NomTotals[VrNo]:=RealStr(ResolveFmula(VrNo,FmulaCtrl,LocalRField,
                                         VarSubSplit,Fnum2,Keypath2,FErr));

                FieldTot[MaxNoSort]:=NomTotals[VrNo];

              end;
            end; {If numerical formula }
          end; {With..}

          LocalNode:=GetNext(LocalNode);

        end; {While..}

      end; {With..}

      LSetDataRecOfs(Fnum2,RecAddr);

      LStatus:=LGetDirect(Fnum2,KeyPath2,B_SingLock);

      Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath2,Fnum2,BOn,Locked);

      If (Ok) and (Locked) then
      Begin
        LGetRecAddr(FNum2);

        LRepGen^.ReportNom:=TmpNomRec^;

        (*
        Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

        Report_BError(FNum2, Status);

        { Need to release multiple-record lock }
        Status:=UnLockMultiSing(F[Fnum2],Fnum2,RecAddr2);
        *)

        LStatus:=LPut_Rec(FNum2,KeyPath2);
        LReport_BError(FNum2,LStatus);
        LStatus:=LUnLockMLock(FNum2);
      end;

      Dispose(TmpNomRec);

    End; { With }

{DBug.Indent (-3);
DBug.Msg (0, 'End RepNomCtrlObj.Calc_NomFmula');}
  end; {Proc..}






  Procedure RepNomCtrlObj.Process_File;

  Const
    Fnum2     =  RepGenF;
    Keypath2  =  RGK;

  Var
    Selected,
    BlnkFmula :  Boolean;
    TSelect   :  Str100;
    FErr      :  Byte;
    Lnum      :  LongInt;

    FmulaCtrl :  RepLinePtr;


  Begin
{DBug.MsgI (0, 'Begin RepNomCtrlObj.Process_File', 3);}

    With MtExLocal^ Do Begin
      FErr:=0;

      Lnum:=0;


      BlnkFmula:=BOff;

      TSelect:='';

      New(FmulaCtrl,Init(RepCtrlRec^.RepName,MtExLocal));
      FmulaCtrl^.OnValErr := Warn_ValErr;

      FmulaCtrl^.InitRepFObj(Fnum2,Keypath2,MtExLocal);


      KeyChk:=FullRepKey(ReportGenCode,RepNomCode,RepCtrlRec^.RepName);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,FNum2,KeyPath2,KeyS);



      While (LStatusOk) and
            {$IFDEF THREDZ}
            (Not ThreadRec^.THAbort) And
            {$ENDIF}
            (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) and {(PrntOk) and} (KeepRep) do
      With RepCtrlRec^ do
      Begin

        {Stppout(PrntOk);} {RW32}

        Selected:=BOn;

        With LRepGen^.ReportNom Do Begin
          If (Not CalcField) then
            GetNom(Application.MainForm, NomRef,Lnum,-1)
          Else
            ResetRec(Fnum);

          Nom.Desc:=RepLDesc;

        End; { With }

        LineCtrl^.FillObject(Selected);  {* Check for any record selection *}

        If (Selected) or (LRepGen^.ReportNom.CalcField) then
        Begin
          With LRepGen^.ReportNom do
            If (PrintVar) and (RepDest<>2) then
              (*
              Case Break of
                { Line Break }        {RW32}
                3  :  {If (Ln > 0) then Begin
                        RepPrintLn('')};

                { Page Break }
                4  :  {If (Ln > 1) then
                        Ln:=255};
              End; { Case }
              *)
              Case Break of
                3   : RepPrintLn('');
                4   : If (Not NewPage) then {* Don't start a new page if we are at the beginning of one *}
                        RepFiler1.NewPage;
              end; {Case..}

          Selected:=BOff;

          LineCtrl^.FillObject(Selected);

          TSelect:=GroupRepRec.ReportHed.RepSelect;

          KeepRep:=LineCtrl^.Evaluate_Expression(TSelect,FErr);

          If (LineCtrl^.SelErr) Then Begin {* Abort with warning *}
            Warn_ValErr('H',TSelect);
            KeepRep:=BOff;
          End; { If }

          { Check for new page }
          If (RepFiler1.LinesLeft < 8) Then
            RepFiler1.NewPage;

          If (KeepRep) then
            Case RepDest of

              2  :  ExportCDF(LineCtrl^.FillCDFLine);  {* Output in CDF *}

              else  With LineCtrl^ do
                    Begin

                      {* Calculate any Totals *}

                      LineTotals(0,0);

                      NewPage:=BOff;

                      With LRepGen^.ReportNom do
                      Begin

                        If (SubTot) and (PrintVar) then
                        Begin
                           PrintColUndies(LineCtrl^.FillUndies(BOff));
                          {RepPrintLn(LineCtrl^.FillTULine(BOff));}

                          {Inc(Ln);}

                        end;

                        If (CalcField) then
                        Begin

                          FErr:=0;

                          BlnkFmula:=(EmptyKey(VarSubSplit,100));

                          If (Not BlnkFmula) then
                            Calc_NomFmula(Fnum2,Keypath2,FmulaCtrl,FErr);

                          If (LineCtrl^.FmulaErr) or (FErr<>0) then {* Abort with warning *}
                          Begin

                            Warn_ValErr('N'+RepPadNo,VarSubSplit);

                            KeepRep:=BOff;

                          end;


                          If (PrintVar) then Begin
                            {RepPrintLn(LineCtrl^.FillNomTotLine(BlnkFmula));}
                            LineCtrl^.FillNomColText (BlnkFmula);
                            PrintColText(LineCtrl^.ColText);
                          End; { If }
                        end
                        else
                          If (PrintVar) then Begin
                            {RepPrintLn(LineCtrl^.FillLine);}
                            LineCtrl^.FillColText;
                            PrintColText(LineCtrl^.ColText);
                          End; { If }



                        If (PrintVar) then
                        Begin
                          Inc(LineCount);

                          Inc(RepRunCount);

                          {Inc(Ln);}
                        end;
                      end;
                    end;

            end; {Case..}

        end; {If Line Selected}

        LStatus:=LFind_Rec(B_GetNext,FNum2,KeyPath2,KeyS);

      end; {While..}


      If (RepCtrlRec^.RepDest<>2) then
        RepEnd;


      Dispose(FmulaCtrl,Done);

    End; { With }

{DBug.Indent (-3);
DBug.Msg (0, 'End RepNomCtrlObj.Process_File');}
  end;{Proc..}


 {* ------------------------ *}


 Procedure RepNomCtrlObj.Process_Report;

 Var
   RecSelected  :  LongInt;


 Begin
{DBug.MsgI (0, 'Begin RepNomCtrlObj.Process_Report', 3);}

   RecSelected:=0;


   ResetScratchTot(RecSelected);

   If (RecSelected>0) then
   Begin

     Process_File;

   end;

{DBug.Indent (-3);
DBug.Msg (0, 'End RepNomCtrlObj.Process_Report');}
 end;



   { ---------------------------------------------------------------- }

   {  RepRunCtrl Methods }

   { ---------------------------------------------------------------- }




  Constructor RepRunCtrlObj.Create(AOwner : TObject;RepCRec : RepGenRec);
  {Constructor RepRunCtrlObj.Init(RepCRec  :  ReportHedType);}

  Begin
    Inherited Create (Aowner, RepCRec{$IFDEF GUI}, nil, nil, nil, nil, nil, nil {$ENDIF});

    {RepNomCtrlObj.Init(RepCRec);}

    NomMode:=(RepCtrlRec^.RepType=RepNomCode);

  end; {Constructor..}



  Procedure RepRunCtrlObj.Process_File;


  Begin
{DBug.MsgI (0, 'Begin RepRunCtrlObj.Process_File', 3);}

    POnStr:='';
    POffStr:='';

    If (NomMode) then
      RepNomCtrlObj.Process_File
    else
      RepCtrlObj.Process_File;

{DBug.Indent (-3);
DBug.Msg (0, 'End RepRunCtrlObj.Process_File');}
  end;{Proc..}


 {* ------------------------ *}


 Procedure RepRunCtrlObj.Process_Report;

 Var
   RecSelected  :  LongInt;


 Begin
{DBug.MsgI (0, 'Begin RepRunCtrlObj.Process_Report', 3);}

   If (NomMode) then
     RepNomCtrlObj.Process_Report
   else
     RepCtrlObj.Process_Report;


{DBug.Indent (-3);
DBug.Msg (0, 'End RepRunCtrlObj.Process_Report');}
 end;


 Procedure RepRunCtrlObj.BuildTempData(Var NoFound : LongInt);
 Begin
{DBug.MsgI (0, 'Begin RepRunCtrlObj.BuildTempData', 3);}

   If (NomMode) then
     RepNomCtrlObj.ResetScratchTot(NoFound)
   Else
     RepCtrlObj.SelectRecords(NoFound);

{DBug.Indent (-3);
DBug.Msg (0, 'End RepRunCtrlObj.BuildTempData');}
 End;

end. {Unit..}