unit BankU1;

{ markd6 15:03 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface


Uses Globvar, VarConst;


Function  PartBankMKey(BNom  :  LongInt;
                       BCr   :  Byte)  :  Str10;

Procedure BankM_CtrlGet(Fnum,
                        Keypath     :  Integer;
                        CtrlNom     :  LongInt;
                        CtrlCr      :  Byte;
                        TDate       :  LongDate;
                    Var BANKMCtlRec :  PassWordRec);

Procedure BANKM_CtrlPut(Fnum,
                        Keypath      :  Integer;
                        CtrlNom      :  LongInt;
                        CtrlCr       :  Byte;
                        BACSCtrlRec  :  PassWordRec);

Procedure BankM_CtrlCalc(Fnum,
                         Keypath  :  Integer;
                         CtrlNom  :  LongInt;
                         CtrlCr   :  Byte;
                         UpBal    :  Double;
                         Deduct,
                         Update,
                         Reset    :  Boolean;
                     Var BANKMCtlRec
                                  :  PassWordRec);

{* ========================================================================== *}
implementation
{* ========================================================================== *}

Uses

{$IFDEF WIN32}

  BtrvU2,

  BTSupU1,
  SysU2,
  ComnU2,
  ComnUnit,
  CurrncyU,
  BtKeys1U,
{$ELSE}
  BtrvU16,
  BtSup1,
  BtSup2,
{$ENDIF}
  SysUtils,
  WinProcs,
  ETStrU,
  ETDateU,
  ETMiscU;

{ ======= Function to Return Part Key ======= }

Function PartBankMKey(BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;

Begin

  PartBankMKey:=FullNomKey(BNom)+Chr(BCr)+HelpKStop;

end;


{ ======= Function to Return Full Key ======= }

Function FullBankMKey(RHed,
                      RSub  :  Char;
                      BNom  :  LongInt;
                      BCr   :  Byte)  :  Str10;

Begin

  FullBankMKey:=RHed+RSub+PartBankMKey(BNom,BCr);

end;

{ =========== Procedure to Get/Initialise Bacs Ctrl Record ========== }


Procedure BankM_CtrlGet(Fnum,
                        Keypath     :  Integer;
                        CtrlNom     :  LongInt;
                        CtrlCr      :  Byte;
                        TDate       :  LongDate;
                    Var BANKMCtlRec :  PassWordRec);

Var
  KeyS  :  Str255;

Begin

  KeyS:=FullBankMKey(MBankHed,MBankCtl,CtrlNom,CtrlCr);

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  If (Not StatusOk) then {* Initialise *}
  With PassWord do
  With BankCRec do
  Begin

    If (Not StatusOk) then
    Begin
      ResetRec(Fnum);

      PassWord.RecPfix:=MBANKHed;
      PassWord.Subtype:=MBANKCTL;

      BankNom:=CtrlNom;
      BankCr:=CtrlCr;

      BankCode:=PartBankMKey(CtrlNom,CtrlCr);

      If (ReconOpo='') then
        ReconOpo:='Imported';

      EntryDate:=TDate;

      NomEntTyp:=Nom.NomType;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

    end;


  end;


  BANKMCtlRec:=PassWord;

end; {Proc..}


{ ========= Proc to Store/Update BACS Ctrl Rec ========== }

Procedure BANKM_CtrlPut(Fnum,
                        Keypath      :  Integer;
                        CtrlNom      :  LongInt;
                        CtrlCr       :  Byte;
                        BACSCtrlRec  :  PassWordRec);

Var
  TmpPWord  :  PassWordRec;

  Locked    :  Boolean;

  KeyS      :  Str255;


Begin

  Locked:=BOff;

  TmpPWord:=BACSCtrlRec;

  KeyS:=FullBankMKey(MBankHed,MBankCtl,CtrlNom,CtrlCr);

  Ok:=GetMultiRec(B_GetEq,B_SingLock,KeyS,Keypath,Fnum,BOn,Locked);

  If (Ok) and (Locked) then
  Begin

    PassWord:=TmpPWord;
    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

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
                                  :  PassWordRec);

Var
  CrDr    :   DrCrType;
  DedCnst :   Integer;

Begin

  ShowDrCr(UpBal,CrDr);

  {* Deduct = Off Status *}

  If (Deduct) then
    DedCnst:=-1
  else
    DedCnst:=1;

  With BankMCtlRec do
  With BankCRec do
  Begin

    {* Reset = Off Status *}

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

    {* Update one is On, one is Off Status *}

    If (UpDate) then
      BankM_CtrlPut(Fnum,Keypath,CtrlNom,CtrlCr,BankMCtlRec);

  end; {With..}

end; {Proc..}



end.
