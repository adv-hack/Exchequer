unit Warn1U;

{$HINTS OFF}
interface

Uses
  GlobVar,
  VarConst,
  WinTypes,
  Messages,
  Classes,
  Controls,
  StdCtrls,
  Forms;


Function Check_AccForCredit(ICust      :  CustRec;
                            PlusBal,
                            MinusBal   :  Double;
                            CheckStatus,
                            CheckBalance
                                       :  Boolean;
                        Var WTrigger   :  Boolean;
                            Sender     :  TWinControl)  :  Boolean;

Procedure Loop_CheckKey(Var Pchk  :  Boolean;
                        Var fRet  :  TModalResult);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  SysUtils,
  BtrvU2,
  TEditVal,
  BorBtns,
  BTKeys1U,
  BTSupU1,
  CSWarnU,
  {$IFNDEF EXDLL}
    ExThrd2U,
  {$ELSE}
    InvListU,
  {$ENDIF}
  {$IF Defined(CU) }
    CustInit,
    CustIntU,
    CustWinU,
    ExWrap1U,
  {$IFEND}
  SysU1;


{ ==================== Procedure to Warn if Account Over Credit Limit,
                       or Passed Wks Odue                              ================= }

Function Warn_ODCredit(CBalance     :  Double;
                       CustR        :  CustRec;
                       CheckStatus,
                       CheckBalance :  Boolean;
                   Var WTrigger     :  Boolean;
                       Sender       :  TWinControl)  :  Boolean;


Const
  BDMes  :  Array[1..3] of Str50 = ('Account Over Credit Limit',
                                    'Bad Debtor! - Credit Status Exceeded',
                                    'Account on Hold.');

Var
  PMess  :  Array[1..2] of Str50;

  PrevHState
         :  Boolean;

  n,l    :  Byte;
  IAC    :  Integer;
  CrDr   :  DrCrDType;

  mrResult
         :  Word;
  Bal,
  Cleared:  Double;

  WForm  :  TCredLimForm;

  {$IF Defined(CU) }
    oHookPoint : TCustomEvent;
    ExLocal : TdExLocal;
    UseStandardFunc : Boolean;
    CreditStatusDays : LongInt;
  {$IFEND}

Begin
  n:=0; l:=0; Cleared:=0;

  Blank(CrDr,Sizeof(CrDr));

  Blank(PMess,Sizeof(PMess));

  Bal:=0;
  Cleared:=0;

  Result:=BOff; IAC:=0;

  With Syss do
  With CustR do
  Begin
    Bal:=Profit_to_Date(CustHistCde,CustCode,0,Cyr,99,CrDr[BOff],CrDr[BOn],Cleared,BOn);

    IAC:=TradeConst[IsACust(CustSupp)];

    WTrigger:=(AccStatus In [2..3]);

    If (UseCrLimitChk) then
    Begin

      {* v4.30a, was checking for comitted here as well, but committed already included in CBalance when being called from Check_AccForCredit*}

      If (((CBalance{+Cleared})*IAC)>CreditLimit)
         and (CreditLimit<>0) and (CheckBalance) then
      Begin


        Inc(n);
        PMess[n]:=BDMes[1];

        Result:=StopBadDr;  {* Don't allow further entry by forcing ok to false,
                               Input customer assumes customer not found *}

      end;
    end;

    // MH 13/02/2009: Added new Hook Point for Volac to allow custom Credit Status checking
    //                Use Compiler Definition in .003, add fully in v6.01
    {$IF Defined(CU) }
      // Use local var for Days/Weeks Overdue so that it can be changed by the customisation
      // without potentially affecting the customer record
      CreditStatusDays := CreditStatus;

      If UseCreditChk And CheckStatus And (N = 0) Then
      Begin
        // Directly check whether a hook point is enabled to avoid creating the object unnecessarily
        // so there is minimum overhead for general users
        If CustomisationEnabled And (CustomHandlers.CheckHandlerStatus (wiTransaction, 192) = 1) Then
        Begin
          UseStandardFunc := False;

          // Create event handler and call plug-ins - this shouldn't be called repeatedly so
          // no need to cache and re-use objects to save time
          oHookPoint := TCustomEvent.Create(wiTransaction, 192);
          ExLocal.Create;
          Try
            // Setup data to be available from within the hook point
            ExLocal.LCust := Cust;
            oHookPoint.BuildEvent(ExLocal);

            // Can't set these until after BuildEvent as that creates EntSysObj
            oHookPoint.EntSysObj.ValidStatus := False;
            oHookPoint.EntSysObj.IntResult := -1;

            oHookPoint.Execute;
            If oHookPoint.EntSysObj.BoResult Then
            Begin
              // Custom Credit Status Check has been done
              If (Not oHookPoint.ValidStatus) Then
              Begin
                // Custom Credit Status Check failed
                Inc(n);
                PMess[n]:=BDMes[2];

                If (oHookPoint.EntSysObj.IntResult >= 0) Then
                Begin
                  // Override Days/Weeks Overdue figure
                  CreditStatusDays := oHookPoint.EntSysObj.IntResult;
                End; // If (oHookPoint.EntSysObj.IntResult >= 0)
              End; // If (Not oHookPoint.ValidStatus) 
            End // If oHookPoint.ValidStatus
            Else
              UseStandardFunc := True;
          Finally
            ExLocal.Destroy;
            FreeAndNIL(oHookPoint);
          End; // Try..Finally
        End // If CustomisationEnabled And
        Else
          UseStandardFunc := True;

        If UseStandardFunc Then
        Begin
          If (CreditStatus >= WksODue) then
          Begin
            Inc(n);
            PMess[n]:=BDMes[2];
          end;
        End; // If UseStandardFunc
      End; // If UseCreditChk And CheckStatus And (N = 0)
    {$ELSE}
      If (UseCreditChk) and (CreditStatus>=WksODue) and (CheckStatus) and (n=0) then
      Begin
        Inc(n);
        PMess[n]:=BDMes[2];

      end;
    {$IFEND}

    If (AccStatus=2) then {*Warn on hold*}
    Begin
      Inc(n);
      PMess[n]:=BDMes[3];
    end;


    If (n>0) then
    Begin
      WTrigger:=BOn;

      {* Create message box, display status *}

      WForm:=TCredLimForm.Create(Sender);

      try

       With WForm do
       Begin
         CLMsgL.Caption:=PMess[n];
         CLF.Value:=CreditLimit;
         CBF.Value:=Bal*IAC;
         COF.Value:=Cleared*IAC;
         CAF.Value:=CreditLimit-((Bal+Cleared)*IAC);
         {$IF Defined(CU) }
           CWOF.Value:=CreditStatusDays;
         {$ELSE}
           CWOF.Value:=CreditStatus;
         {$IFEND}

         SetAllowHotKey(BOff,PrevHState);
         Set_BackThreadMVisible(BOn);


         mrResult:=ShowModal;

         Set_BackThreadMVisible(BOff);

         SetAllowHotKey(BOn,PrevHState);
       end;

      finally

       WForm.Free;
      end;

    end;
  end; {With..}
end; {Proc..}



{ =========== Procedure to Subst H/O Account when checking for credit status ====== }


Function Check_AccForCredit(ICust      :  CustRec;
                            PlusBal,
                            MinusBal   :  Double;
                            CheckStatus,
                            CheckBalance
                                       :  Boolean;
                        Var WTrigger   :  Boolean;
                            Sender     :  TWinControl)  :  Boolean;


Var
  OldStat  :  Integer;
  KeyS     :  Str255;
  OldCust  :  CustRec;


Begin
  OldCust:=Cust;
  WTrigger:=BOff;

  {$IFDEF SOP}

    If (Not EmptyKey(ICust.SOPInvCode,CustKeyLen)) then {* Substitute H/O account *}
    Begin
      KeyS:=FullCustCode(ICust.SOPInvCode);
      OldStat:=Status;

      Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);

      If (StatusOk) then
        ICust:=Cust;

      Status:=OldStat;
    end;

  {$ENDIF}

  ICust.Balance:=Get_CurCustBal(ICust)-MinusBal+PlusBal;

  Result:=Warn_ODCredit(ICust.Balance,ICust,CheckStatus,CheckBalance,WTrigger,Sender);

  Cust:=OldCust;

end;


{ ==================== Check for printout stop ================= }

Procedure Loop_CheckKey(Var Pchk  :  Boolean;
                        Var fRet  :  TModalResult);

Var
  mRet  :  Word;

Begin

  If (PChk) then

  {$B-}

    If (fRet=mrAbort) then
    Begin

      mRet:=MessageDlg('Halted!'+#13+'Continue?',mtConfirmation,[mbYes,mbNo],0);


      PChk:=(mRet<>mrNo);
      fret:=mrNone;
    end;

  {$B+}

end;


Initialization


end.