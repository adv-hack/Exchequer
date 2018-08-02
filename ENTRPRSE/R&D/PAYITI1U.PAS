{ ============== TPIMList Methods =============== }


procedure TPIMList.ExtObjDestroy;

Begin
  If (ThisScrt<>nil) then
  Begin
    Dispose(ThisScrt,Done);

    Dec(RepScrCount^);
  end;

  Inherited;


end;


Function TPIMList.SetCheckKey  :  Str255;


Var
  TmpYr,
  TmpPr   :  Integer;

  DumStr    :  Str255;


Begin
  FillChar(DumStr,Sizeof(DumStr),0);

  Case DisplayMode of

    0  :  With Id do
          Begin
            DumStr:=StockCode;
          end; {With..}

    1..3
       :  With RepScr^ do
          Begin

            DumStr:=AccessK;

          end;


  end; {Case..}


  SetCheckKey:=DumStr;
end;




Function TPIMList.SetFilter  :  Str255;

Begin

  Case DisplayMode of
    0    :  Result:=FullNomKey(Id.PostedRun);

    1..3 :  Result:=NdxWeight;

  end; {Case..}


end;


Function TPIMList.Ok2Del :  Boolean;

Begin
  Result:=BOff;
end;


{$IFDEF STK}

  { ===== Procedure to Match Order Lines with Invoice Lines ===== }


  Procedure TPIMList.Match_ORLine(IdR    :  IDetail;
                                  ICode  :  Str10);



  Const
    Fnum     =  PWrdF;
    Keypath  =  HelpNdxK;

    Fnum2    =  InvF;
    Keypath2 =  InvOurRefK;

    Fnum3    =  IDetailF;
    Keypath3 =  IdFolioK;


  Var

    N         :  Byte;


    NeedScr,
    NoAbort,
    FoundOk   :  Boolean;


    KeyS,
    KeyChk,
    KeyIS,
    KeyIChk   :  Str255;

    RecAddr   :  LongInt;

    TmpFn     :  Integer;

    Rnum      :  Real;

    MsgForm   :  TForm;
    mbRet     :  TModalResult;


  Begin

    MsgForm:=CreateMessageDialog('Please Wait...'+#13+'Checking Deliveries & Invoices.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;


    NoAbort:=BOn;

    FoundOk:=BOff;

    RecAddr:=0;

    NeedScr:=BOn;

    If (ThisScrt<>nil) then {* Close previous search *}
    Begin
      Dispose(ThisScrt,Done);
      ThisScrt:=nil;
    end;

    Rnum:=0;


    KeyChk:=FullMatchKey(MatchTCode,MatchSCode,ICode);
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) do
    With PassWord.MatchPayRec do
    Begin

      KeyIS:=DocCode;

      mbRet:=MsgForm.ModalResult;

      Loop_CheckKey(NoAbort,mbRet);

      MsgForm.ModalResult:=mbRet;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyIS);

      If (StatusOk) then
      Begin

        KeyIChk:=FullNomKey(Inv.FolioNum);

        KeyIS:=KeyIChk;

        FoundOk:=BOff;

        Status:=Find_Rec(B_GetGEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3,KeyIS);

        While (StatusOk) and (CheckKey(KeyIChk,KeyIS,Length(KeyIChk),BOn)) and (NoAbort) and (Not FoundOk) do
        With Id do
        Begin

          mbRet:=MsgForm.ModalResult;

          Loop_CheckKey(NoAbort,mbRet);

          MsgForm.ModalResult:=mbRet;


          FoundOk:=((SOPLink=Idr.FolioRef) and (SOPLineNo=Idr.ABSLineNo));

          If (FoundOk) then
          Begin

            If (NeedScr) then
            Begin

              Inc(RepScrCount^);  {* This set in case a previous match is still active
                                     and its called again. *}

              New(ThisScrt,Init(2000+RepScrCount^));


              NeedScr:=BOff;

            end;

            Status:=GetPos(F[Fnum3],Fnum3,RecAddr);  {* Get Preserve IdPosn *}

            ThisScrt^.Add_Scratch(Fnum3,Keypath3,RecAddr,PDate+Inv.OurRef,Inv.OurRef);

          end
          else
            Status:=Find_Rec(B_GetNext,F[Fnum3],Fnum3,RecPtr[Fnum3]^,KeyPath3,KeyIS);

        end; {While..}

      end; {If Inv found ok..}

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {Match While..}

    MsgForm.Free;

  end; {Proc..}


        { ===== Procedure to Match Order Lines with Invoice Lines ===== }


  Procedure TPIMList.Match_OSLine(IdR    :  IDetail;
                                  ICode,
                                  CCode  :  Str10);


  Const
    Fnum2    =  InvF;
    Keypath2 =  InvFolioK;

    Fnum3    =  IDetailF;
    Keypath3 =  IdAnalK;


  Var

    N         :  Byte;

    NeedScr,
    NoAbort,
    TmpBo     :  Boolean;


    KeyS,
    KeyChk,
    KeyIS     :  Str255;

    FoundCode :  Str20;

    GetENom   :  GetNomMode4;

    NomERec   :  ExtNomRecPtr;


    RecAddr   :  LongInt;

    TmpFn     :  Integer;

    Rnum      :  Real;

    MsgForm   :  TForm;

    mbRet     :  TModalResult;

  Begin

    MsgForm:=CreateMessageDialog('Please Wait...'+#13+'Checking Outstanding Orders.',mtInformation,[mbAbort]);
    MsgForm.Show;
    MsgForm.Update;


    New(GetENom,Init);
    New(NomERec);

    FillChar(NomERec^,Sizeof(NomERec^),0);


    NeedScr:=BOn;

    NoAbort:=BOn;

    RecAddr:=0;

    If (ThisScrt<>nil) then
    Begin
      Dispose(ThisScrt,Done);
      ThisScrt:=nil;
    end;

    Rnum:=0;

    TmpBo:=BOff;

    With NomERec^ do
    Begin
      FCCode:=CCode;

      If (IdR.IdDocHed In SalesSplit) then
        FLTyp:=StkLineType[SOR]
      else
        FLTyp:=StkLineType[POR];

      KeyChk:=FLTyp;

    end;

    KeyS:=KeyChk;

    Status:=GetExtOSOrd(NomERec,GetENom,Fnum3,Keypath3,B_GetGEq,0,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoAbort) do
    With Id do
    Begin

      mbRet:=MsgForm.ModalResult;
      Loop_CheckKey(NoAbort,mbRet);
      MsgForm.ModalResult:=mbRet;


      TmpBo:=((CheckKey(CCode,CustCode,Length(CCode),BOff)) and (Is_FullStkCode(StockCode)) and (LineNo>0));

      // MH 21/05/2010 v6.4 ABSEXCH-9724: Removed check on Stock Level so ALL outstanding lines are shown
      (*
      If (TmpBo) and (IdR.IdDocHed In SalesSplit) then {* Check if any stock available *}
      Begin

        If (Stock.StockCode<>StockCode) then
          GetStock(Self,StockCode,FoundCode,-1);

        With Stock do
          TmpBo:=((QtyInStock-QtyPicked)>0);
      end;
      *)

      If (TmpBo) then
      Begin


        KeyIS:=FullNomKey(FolioRef);


        Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyIS);

        If (StatusOk) and (ICode<>Inv.OurRef) then
        Begin

          If (NeedScr) then
          Begin

            Inc(RepScrCount^);  {* This set in case a previous match is still active
                                     and its called again. *}

            New(ThisScrt,Init(2000+RepScrCount^));


            NeedScr:=BOff;

          end;

          Status:=GetPos(F[Fnum3],Fnum3,RecAddr);  {* Get Preserve IdPosn *}

          ThisScrt^.Add_Scratch(Fnum3,Keypath3,RecAddr,PDate+Inv.OurRef,Inv.OurRef);

        end;

      end; {If Inv found ok..}

      Status:=GetExtOSOrd(NomERec,GetENom,Fnum3,Keypath3,B_GetNext,0,KeyS);

    end; {Match While..}

    MsgForm.Free;

    Dispose(NomERec);

    Dispose(GetENom,Done);


  end; {Proc..}

{$ENDIF}


{ ========== find Inv link ======== }


Function TPIMList.Link2Inv  :  Boolean;


Const
  Fnum     =  InvF;
  KeyPath2 =  InvFolioK;



Var
  KeyS   :  Str255;


Begin
  Result:=BOff;

  With Id do
  Begin

    Blank(KeyS,Sizeof(KeyS));

    Case DisplayMode of

      0..3
        :  Begin

              KeyS:=FullNomKey(FolioRef);

            end;

    end; {Case..}

    If (Inv.FolioNum<>FolioRef) then
    Begin
      ResetRec(Fnum);

      If (KeyS<>'') then
      Begin

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
        Result:=StatusOk;
      end;
    end
    else
      Result:=BOn;
  end; {With..}
end;


{ ========== Generic Function to Return Formatted Display for List ======= }


Function TPIMList.OutPayIn(Col  :  Byte)  :  Str255;

Var
  UOR    :  Byte;

  TmpRecAddr
         :  LongInt;

  GenStr :  Str255;

  LineBal,
  Rnum   :  Real;

  DeductD:  Boolean;


Begin

  With LNHCtrl,Id do
  Begin
    UOR:=0;

    DeductD:=(IdDocHed=RUN);

    If (Not DeductD) then
      DeductD:=Not Syss.SepDiscounts;

    LineBal:=DetLTotal(Id,DeductD,BOff,0.0);

    If (NHCr=0) then
    Begin
      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      LineBal:=Conv_TCurr(LineBal,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
    end;

    LineBal:=Currency_Txlate(LineBal,NHCr,NHTxCr);


    Rnum:=LineBal;

    Link2Inv;

    Case Col of

       0  :  OutPayIn:=Inv.OurRef;

       1  :  OutPayIn:=Inv.CustCode;

       2  :  OutPayIn:=Desc;

       3  :  Begin
               OutPayIn:=FormatCurFloat(GenRealMask,Rnum,BOff,NHCr);
             end;

       4  :  OutPayIn:=GetReconcileStatus(Reconcile);

       else
             OutPayIn:='';
     end; {Case..}


   end; {With..}
end;


{$IFDEF STK}

  { ========== Generic Function to Return Formatted Display for List ======= }


  Function TPIMList.OutSORMatch(Col  :  Byte)  :  Str255;

  Var

    GenStr :  Str255;

    Rnum   :  Real;

    BlnkLine
           :  Boolean;


  Begin
    Result:='';

    BlnkLine:=BOff;

    If (ThisScrt<>nil) then {* Get Id Link *}
      ThisScrt^.Get_Scratch(RepScr^)
    else
    Begin
      ResetRec(IDetailF);
      ResetRec(ReportF);
      BlnkLine:=BOn;
    end;

    If (Not BlnkLine) then
    With LNHCtrl,Id do
    Begin

      Case Col of

         0  :  OutSORMatch:=RepScr^.KeyStr;

         1  :  OutSORMatch:=PoutDate(PDate);

         2  :  OutSORMatch:=FormatFloat(GenQtyMask,Qty);

         else
               OutSORMatch:='';
       end; {Case..}


     end; {With..}
  end;

  Function TPIMList.OutSORBack(Col  :  Byte)  :  Str255;

  Var

    GenStr :  Str255;

    Rnum   :  Real;

    FoundCode
           :  Str20;


  Begin


    With LNHCtrl,Id do
    Begin

      If (ThisScrt<>nil) then {* Get Id Link *}
      Begin
        ThisScrt^.Get_Scratch(RepScr^);

        GetStock(Self,StockCode,FoundCode,-1);
      end;

      Case Col of

         0  :  OutSORBack:=RepScr^.KeyStr;

         1  :  OutSORBack:=PoutDate(PDate);

         2  :  OutSORBack:=StockCode;

         3  :  OutSORBack:=FormatFloat(GenQtyMask,Qty_OS(Id));

         4  :  OutSORBack:=FormatFloat(GenQtyMask,Stock.QtyInStock-Stock.QtyPicked);

         else
               OutSORBack:='';
       end; {Case..}


     end; {With..}
  end;


{$ENDIF}


Function TPIMList.OutLine(Col  :  Byte)  :  Str255;
Begin

  Case DisplayMode of

    0  :  OutLine:=OutPayIn(Col);

    {$IFDEF STK}

      1,3:  OutLine:=OutSORMatch(Col);
      2  :  OutLine:=OutSORBack(Col);

    {$ENDIF}

    else    OutLine:='';

  end; {Case..}

end;



{ =================================================================================== }

