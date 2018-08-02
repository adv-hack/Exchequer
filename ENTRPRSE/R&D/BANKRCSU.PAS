Unit BANKRcSU;

{$I DEFOVR.INC}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 25/10/94                      }
{                                                              }
{                    Bank Match Support Unit                   }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses GlobVar,
     VarConst,
     ExWrap1U;




Function BankMEStatus(EStatus  :  Byte;
                      FullMode :  Boolean)  :  Str80;

Function PartBankMKey(BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;

Function PartBankManKey(BNom  :  LongInt;
                        BCr   :  Byte;
                        BDate :  LongDate)  :  Str10;


Function FullBankMKey(RHed,
                      RSub  :  Char;
                      BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;


Function FullBankManKey(RHed,
                        RSub  :  Char;
                        BNom  :  LongInt;
                        BCr   :  Byte;
                        BDate :  LongDate)  :  Str10;


Procedure BankM_CtrlGet(Fnum,
                        Keypath     :  Integer;
                        CtrlNom     :  LongInt;
                        CtrlCr      :  Byte;
                    Var BANKMCtlRec :  PassWordRec;
                        MTExLocal   :  TdMTExLocalPtr);

Procedure BANKM_CtrlPut(Fnum,
                        Keypath      :  Integer;
                        CtrlNom      :  LongInt;
                        CtrlCr       :  Byte;
                        BACSCtrlRec  :  PassWordRec;
                        MTExLocal    :  TdMTExLocalPtr);

Procedure BankM_CtrlCalc(Fnum,
                         Keypath  :  Integer;
                         CtrlNom  :  LongInt;
                         CtrlCr   :  Byte;
                         UpBal    :  Double;
                         Deduct,
                         Update,
                         Reset    :  Boolean;
                     Var BANKMCtlRec
                                  :  PassWordRec;
                         MTExLocal:  TdMTExLocalPtr);


Procedure  BankM_ManCalc(Fnum,
                         Keypath  :  Integer;
                         CtrlNom  :  LongInt;
                         CtrlCr   :  Byte;
                         CrDr     :  DrCrType;
                         Deduct,
                         Update,
                         Reset    :  Boolean;
                     Var BANKMCtlRec
                                  :  PassWordRec;
                         MTExLocal:  TdMTExLocalPtr);


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   ETStrU,
   ETMiscU,
   ETDateU,
   BtrvU2,
   ComnUnit,
   {SetMenuU,}
   ComnU2,
   BTKeys1U,
   BTSupU1,
   CurrncyU,
   InvListU,
   SysU1;







{ ======= Function to Return Line Status ======= }

Function BankMEStatus(EStatus  :  Byte;
                      FullMode :  Boolean)  :  Str80;

Var
  TStr  :  Str80;


Begin

  Case FullMode of

    BOff  :  Case EStatus of

              1  :  TStr:='Matched .: ';
              2  :  TStr:='Unmatched:          ';
              3  :  TStr:='Wrong Val: ';
              4  :  TStr:='Cleared! : ';
              else  TStr:='';

            end; {Case..}

    BOn   :  Case EStatus of

              1  :  TStr:='Matched with ...: ';
              2  :  TStr:='Unmatched:        ';
              3  :  TStr:='Wrong Value ....: ';
              4  :  TStr:='Already Cleared!: ';
              else  TStr:='';

            end; {Case..}

  end; {Case..}


  BankMEStatus:=TStr;
end;


{ ======= Function to Return Part Key ======= }

Function PartBankMKey(BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;


Begin

  PartBankMKey:=FullNomKey(BNom)+Chr(BCr)+HelpKStop;

end;



{ ======= Function to Return Part Key ======= }

Function PartBankManKey(BNom  :  LongInt;
                        BCr   :  Byte;
                        BDate :  LongDate)  :  Str10;

Var
  Sdd,Smm,Syy
        :  Word;

Begin

  DateStr(BDate,Sdd,Smm,Syy);

  PartBankManKey:=FullNomKey(BNom)+Chr(BCr)+Form_Int(Syy,4)+Chr(Smm)+Chr(Sdd)+HelpKStop;

end;



{ ======= Function to Return Full Key ======= }

Function FullBankMKey(RHed,
                      RSub  :  Char;
                      BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;


Begin

  FullBankMKey:=PartCCKey(RHed,RSub)+PartBankMKey(BNom,BCr);

end;


{ ======= Function to Return Full Key ======= }

Function FullBankManKey(RHed,
                        RSub  :  Char;
                        BNom  :  LongInt;
                        BCr   :  Byte;
                        BDate :  LongDate)  :  Str10;


Begin

  FullBankManKey:=PartCCKey(RHed,RSub)+PartBankManKey(BNom,BCr,BDate);

end;



{ =========== Procedure to Get/Initialise Bacs Ctrl Record ========== }


Procedure BankM_CtrlGet(Fnum,
                        Keypath     :  Integer;
                        CtrlNom     :  LongInt;
                        CtrlCr      :  Byte;
                    Var BANKMCtlRec :  PassWordRec;
                        MTExLocal   :  TdMTExLocalPtr);



Var
  KeyS  :  Str255;


Begin

  FillChar(KeyS,Sizeof(KeyS),0);

  KeyS:=FullBankMKey(MBankHed,MBankCtl,CtrlNom,CtrlCr);


  If (Not Assigned(MTExLocal)) then
  Begin

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    With PassWord do
    With BankCRec do
    Begin
      If (Not StatusOk) then {* Initialise *}
      Begin


        If (Not StatusOk) then
        Begin
          ResetRec(Fnum);


          PassWord.RecPfix:=MBANKHed;
          PassWord.Subtype:=MBANKCTL;

          BankNom:=CtrlNom;
          BankCr:=CtrlCr;

          BankCode:=PartBankMKey(CtrlNom,CtrlCr);

          
          ReconOpo:=EntryRec^.LogIn;

          EntryDate:=Today;

          If (Nom.NomCode<>BankNom) then
            Global_GetMainRec(NomF,FullNomKey(BankNom));

          NomEntTyp:=Nom.NomType;

          Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);
        end;


     end;

       {* Set to current posting run No. *}
      TagRunNo:=GetNextCount(RUN,BOff,BOff,0);

    end;


    BANKMCtlRec:=PassWord;
  end
  else
  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

    With LPassWord do
    With BankCRec do
    Begin
      If (Not LStatusOk) then {* Initialise *}
      Begin


        If (Not LStatusOk) then
        Begin
          LResetRec(Fnum);


          LPassWord.RecPfix:=MBANKHed;
          LPassWord.Subtype:=MBANKCTL;

          BankNom:=CtrlNom;
          BankCr:=CtrlCr;

          BankCode:=PartBankMKey(CtrlNom,CtrlCr);

          ReconOpo:=EntryRec^.LogIn;

          EntryDate:=Today;

          If (LNom.NomCode<>BankNom) then
            LGetMainRec(NomF,FullNomKey(BankNom));

          NomEntTyp:=LNom.NomType;

          LStatus:=LAdd_Rec(Fnum,KeyPath);

          LReport_BError(Fnum,LStatus);
        end;


     end;

       {* Set to current posting run No. *}
      TagRunNo:=GetNextCount(RUN,BOff,BOff,0);

    end;


    BANKMCtlRec:=LPassWord;
  end

end; {Proc..}


{ ========= Proc to Store/Update BACS Ctrl Rec ========== }

Procedure BANKM_CtrlPut(Fnum,
                        Keypath      :  Integer;
                        CtrlNom      :  LongInt;
                        CtrlCr       :  Byte;
                        BACSCtrlRec  :  PassWordRec;
                        MTExLocal    :  TdMTExLocalPtr);


Var
  TmpPWord  :  PassWordRec;

  LOk,
  Locked    :  Boolean;

  KeyS      :  Str255;

  LAddr     :  LongInt;



Begin

  Locked:=BOff;

  TmpPWord:=BACSCtrlRec;

  KeyS:=FullBankMKey(MBankHed,MBankCtl,CtrlNom,CtrlCr);

  If (Not Assigned(MTExLocal)) then
  Begin

    LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr);

    If (LOk) and (Locked) then
    Begin

      PassWord:=TmpPWord;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

    end
  end
  else
  With MTExLocal^ do
  Begin
    LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked);

    If (LOk) and (Locked) then
    Begin
      LGetRecAddr(Fnum);

      LPassWord:=TmpPWord;

      LStatus:=LPut_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      LStatus:=LUnLockMLock(Fnum);

    end;
  end;
end; {Proc..}


{ ======== Procedure to update Ctrl Totals ======== }

Procedure BankM_CtrlCalc(Fnum,
                         Keypath  :  Integer;
                         CtrlNom  :  LongInt;
                         CtrlCr   :  Byte;
                         UpBal    :  Double;
                         Deduct,
                         Update,
                         Reset    :  Boolean;
                     Var BANKMCtlRec
                                  :  PassWordRec;
                         MTExLocal:  TdMTExLocalPtr);


Var
  CrDr    :   DrCrType;
  DedCnst :   Integer;

Begin

  ShowDrCr(UpBal,CrDr);

  If (Deduct) then
    DedCnst:=-1
  else
    DedCnst:=1;

  With BankMCtlRec do
  With BankCRec do
  Begin

    If (Reset) then
    Begin
      EntryTotDr:=0;
      EntryTotCr:=0;

      MatchCount:=0;
    end
    else
    Begin
      EntryTotDr:=EntryTotDr+(CrDr[BOff]*DedCnst);
      EntryTotCr:=EntryTotCr+(CrDr[BOn]*DedCnst);

      MatchCount:=MatchCount+DedCnst;

    end;

    If (UpDate) then
      BankM_CtrlPut(Fnum,Keypath,CtrlNom,CtrlCr,BankMCtlRec,MTExLocal);

  end; {With..}

end; {Proc..}


{ ======== Procedure to update Ctrl Totals ======== }

Procedure  BankM_ManCalc(Fnum,
                         Keypath  :  Integer;
                         CtrlNom  :  LongInt;
                         CtrlCr   :  Byte;
                         CrDr     :  DrCrType;
                         Deduct,
                         Update,
                         Reset    :  Boolean;
                     Var BANKMCtlRec
                                  :  PassWordRec;
                         MTExLocal:  TdMTExLocalPtr);


Var
  DedCnst :   Integer;

Begin

  If (Deduct) then
    DedCnst:=-1
  else
    DedCnst:=1;

  With BankMCtlRec do
  With BankCRec do
  Begin

    If (Reset) then
    Begin
      ManTotDr:=0;
      ManTotCr:=0;
    end
    else
    Begin

      ManTotDr:=ManTotDr+(CrDr[BOff]*DedCnst);
      ManTotCr:=ManTotCr+(CrDr[BOn]*DedCnst);

    end;

    If (UpDate) then
      BankM_CtrlPut(Fnum,Keypath,CtrlNom,CtrlCr,BankMCtlRec,MTExLocal);

  end; {With..}

end; {Proc..}


end.