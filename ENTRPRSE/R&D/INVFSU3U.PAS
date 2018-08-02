Unit InvFSu3U;


{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 11/01/95                      }
{                                                              }
{                   Inv List Support III Unit                  }
{                                                              }
{               Copyright (C) 1993 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses SysUtils, GlobVar,VarConst;

// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
Type
  enumMoveEmUpMode = (mumDefault=0, mumInsert=1);


Function Show_CMG(DocHed  :  DocTypes)  :  Boolean;



Function InvLLTotal(IdR      :  Idetail;
                    UseDisc  :  Boolean;
                    SetlDisc :  Real)  :  Real;

Function InvLLCost(IdR      :  Idetail)  :  Real;


Procedure UpdateRecBal(IdR      :  IDetail;
                   Var LInv     :  InvRec;
                       Deduct,
                       Disp     :  Boolean;
                       Mode     :  Byte);

Procedure MoveEmUp(      KeyChk,
                         KeyS,
                         KeyLimit:  Str255;
                         IncBy   :  LongInt;
                         Fnum,
                         KeyPath :  Integer;
                   // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
				   Const MoveEmUpMode : enumMoveEmUpMode = mumDefault);

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   BtrvU2,
   ETMiscU,
   ETStrU,
   ComnUnit,
   ComnU2,
   InvListU,
   MiscU,

   {$IFDEF EXSQL}
     SQLUtils,
   {$ENDIF}

   SysU1,
   SysU2,
   PWarnU,
   CurrncyU,
   BTSupU1,

   // MH 24/03/2015 v7.0.14 ABSEXCH-16284: Calculate Prompt Payment Discount Goods and VAT Values
   PromptPaymentDiscountFuncs;






{ ============ Function to Determine if Cost/Margin info is displayed ========== }


Function Show_CMG(DocHed  :  DocTypes)  :  Boolean;

Begin

  {* Place check here for show GP password *}

  Show_CMG:=((DocHed In SalesSplit) and (PChkAllowed_In(143)));

end; {Func..}



{ ======= Psuedo function for link to misc ======= }


Function InvLLTotal(IdR      :  Idetail;
                    UseDisc  :  Boolean;
                    SetlDisc :  Real)  :  Real;


Begin

  InvLLtotal:=InvLTotal(IdR,UseDisc,SetlDisc);

end;


{ ======= Psuedo function for link to misc ======= }


Function InvLLCost(IdR      :  Idetail)  :  Real;


Begin

  InvLLCost:=InvLCost(IdR);

end;



{ ============ Procedure to update the Invoice balances ============= }

Procedure UpdateRecBal(IdR      :  IDetail;
                   Var LInv     :  InvRec;
                       Deduct,
                       Disp     :  Boolean;
                       Mode     :  Byte);


Var
  LineTotal,
  WithDiscVal,
  DiscLineTotal,
  LineCost       :  Real;

  DecCnst        :  Integer;


Begin

  LineTotal:=0;
  LineCost:=0;

  DiscLineTotal:=0;
  WithDiscVal:=0;

  If (Deduct) then
    DecCnst:=-1
  else
    DecCnst:=1;


  With LInv do
    Case Mode of

      0..9  :  Begin

                 WithDiscVal:=InvNetVal-DiscAmount;

                 LineTotal:=(Round_Up(InvLTotal(IdR,BOff,0),2)*DecCnst);

                 InvNetVal:=InvNetVal+LineTotal;

                 DiscLineTotal:=(Round_Up(InvLTotal(IdR,BOn,0),2)*DecCnst);

                 WithDiscVal:=WithDiscVal+DiscLineTotal;

                 InvVAT:=InvVAT+(IdR.VAT*DecCnst);

                 DiscAmount:=Round_Up(InvNetVal-WithDiscVal,2);   {* v1.35 *}

                 DiscSetAm:=Round_Up(Calc_PAmount((InvNetVal-DiscAmount),DiscSetl,PcntChr),2);

                 // MH 24/03/2015 v7.0.14 ABSEXCH-16284: Calculate Prompt Payment Discount Goods and VAT Values
                 UpdatePPDTotals (LInv);

                 With IdR do
                   LineCost:=InvLCost(IdR)*DecCnst;

                 TotalCost:=TotalCost+LineCost;


               end;

      17  :  Begin
               LineTotal:=(Round_Up(Currency_ConvFT(InvLTotal(IdR,BOff,0),IdR.Currency,Currency,UseCoDayRate),2)*DecCnst);

               InvNetVal:=InvNetVal+LineTotal;

               LineCost:=IdR.Qty*DecCnst;

               TotalInvoiced:=TotalInvoiced+LineCost;

             end;

    end; {Case..}

  {If (Disp) then EX32. display new rquired..
    OutInvReq(Mode);}
end;







{ ============ Procedure to Insert/Delete List Lines =========== }

Procedure MoveEmUp(      KeyChk,
                         KeyS,
                         KeyLimit:  Str255;
                         IncBy   :  LongInt;
                         Fnum,
                         KeyPath :  Integer;
                   // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                   Const MoveEmUpMode : enumMoveEmUpMode = mumDefault);


Var
  FoundOk,
  Locked       :  Boolean;

  TmpKPath,
  TmpStat      :  Integer;

  KLNoStr      :  Str255;

  KLimitLno    :  LongInt;


  LAddr,
  TmpRecAddr   :  LongInt;


  KFolio, KStart, KEnd, KRes : LongInt;
Begin
  KRes := -1;

  {$IFDEF EXSQL}
    // For SQL Edition try going direct to database, if it fails use original code
    //PR: 01/10/2010 v6.4 ABSEXCH-9837/ABSEXCH-10289 Revert to original code until insert line functionality can be refactored
	// MH 03/11/2015 2016R1 ABSEXCH-16613: Re-introduced SQL Performance mods
    If SQLUtils.UsingSQLAlternateFuncs Then
    Begin
      // Extract key information from btrieve key strings
      KeyChk := KeyChk + #0#0#0#0;     Move(KeyChk[1],KFolio,Sizeof(KFolio));  // Bodge as EL likes to trim stuff
      KeyS := KeyS + #0#0#0#0;         Move(KeyS[5],KEnd,Sizeof(KEnd));        // Bodge as EL likes to trim stuff
      KeyLimit := KeyLimit + #0#0#0#0; Move(KeyLimit[5],KStart,Sizeof(KStart));// Bodge as EL likes to trim stuff

      If (KStart >=0) And (KEnd >= 0) Then
      Begin
        // MH 03/11/2015 2016R1 ABSEXCH-16613: Inserts need to affect additional line
		If (MoveEmUpMode = mumInsert) Then
        Begin
          // For Inserts we need to renumber the line number passed in to make the space for the
          // new line, otherwise they end up with the same number and the inserted line appears
          // below the original line as it has a higher PositionID
          KRes := ExecSQL('Update [COMPANY].Details Set tlLineNo=tlLineNo+' + IntToStr(IncBy) + ' Where (tlFolioNum = ' + IntToStr(KFolio) + ') And ((tlLineNo >= ' + IntToStr(KStart) + ') And (tlLineNo <= ' + IntToStr(KEnd) + '))', SetDrive)
        End // If (MoveEmUpMode = mumInsert)
        Else
        Begin
          // MH 14/07/2010 v6.4 ABSEXCH-9837: Inclusion of current line was causing Lock Timeout
          //KRes := ExecSQL('Update [COMPANY].Details Set tlLineNo=tlLineNo+' + IntToStr(IncBy) + ' Where (tlFolioNum = ' + IntToStr(KFolio) + ') And ((tlLineNo >= ' + IntToStr(KStart) + ') And (tlLineNo <= ' + IntToStr(KEnd) + '))', SetDrive)
          KRes := ExecSQL('Update [COMPANY].Details Set tlLineNo=tlLineNo+' + IntToStr(IncBy) + ' Where (tlFolioNum = ' + IntToStr(KFolio) + ') And ((tlLineNo > ' + IntToStr(KStart) + ') And (tlLineNo <= ' + IntToStr(KEnd) + '))', SetDrive)
        End; // Else
      End // If (KStart >=0) And (KEnd >= 0)
      Else
        KRes := ExecSQL('Update [COMPANY].Details Set tlLineNo=tlLineNo+' + IntToStr(IncBy) + ' Where (tlFolioNum = ' + IntToStr(KFolio) + ') And ((tlLineNo <= ' + IntToStr(KStart) + ') And (tlLineNo >= ' + IntToStr(KEnd) + '))', SetDrive);

      // Drop the cache otherwise changes may not be picked up correctly
      DiscardCachedData('Details.Dat');
    End; // If SQLUtils.UsingSQLAlternateFuncs
  {$ENDIF}

  If (KRes <> 0) Then
  Begin
    FoundOk:=BOff; Locked:=BOff;

    Blank(KLNoStr,SizeOf(KLNoStr));

    KLNoStr:=Copy(KeyLimit,5,Length(KeyLimit)-4);

    Move(KLNoStr[1],KLimitLNo,Sizeof(KLimitLNo));

    KeyLimit:=Strip('R',[#0],KeyLimit);

    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);

    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

                                                                                           {* Modded v4.30c to check actual line nos
                                                                                              as otherwise lines 255 or above fail *}
    While (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) and {(KeyS>=KeyLimit)} (Id.LineNo>=KLimitLNo) do
    Begin

      FoundOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked,LAddr);

      If (FoundOk) and (Locked) then
      With Id do
      Begin

        If ((LineNo<=(LastAddrD-IncBy)) and (LineNo<>StkLineNo)) then
          LineNo:=LineNo+IncBy;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
      end;

      Status:=Find_Rec(B_GetPrev,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);
    end; {While..}


    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
  End; // If (KRes <> 0)
end; {Loop..}








end.
