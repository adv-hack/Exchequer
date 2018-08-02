Unit HelpSupU;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }



{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 22/10/90                      }
{                                                              }
{                 Context Sensitive Help Controller            }
{                                                              }
{               Copyright (C) 1990 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses
  SecSup2U, GlobVar, VarRec2U;



(*Procedure Replicate_CoSecurity;

Function Get_Security  :  Boolean;

Function DeCode_Usrs(SecStr,RelStr  :  Str20)  :  LongInt;*)


Function FullyReleased  :  Boolean;

Function Get_ISNSecurity(EXISN     : ISNArrayType)  :  Str20;


{Function Update_Users(IncU  :  Integer;
                      Warn  :  Boolean) :  Boolean;

Function Get_ModuleSecurity(ModNo     :  Byte;
                            RelMode   :  Boolean)  :  Str20;

Function Check_ModRel(ModNo  :  Byte;
                      UpNow  :  Boolean)  :  Boolean;

Function Check_RelDateExp(ModNo  :  Byte;
                          LockRec:  Boolean)  :  Boolean;

Procedure Set_RelDate(ModNo      :  Byte;
                      SetAgain,
                      LockRecord :  Boolean);

Function ModRelMode(ModNo  :  Byte)  :  Byte;               }

{ HM 04/06/99: Published existing function for use with Single-CD }
{Function Gen_ModRelCode(SecStr  :  Str20;
                        TDay    :  Boolean)  :  Str20;}

{ HM 04/06/99: Added new function to calculate Release Code Expiry Dates }
Function CalcNewRelDate (NumDays : Integer) : Real;

{Procedure Get_Release;}


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   VarConst,
   Forms,
   SysUtils,
   ETStrU,
   ETMiscU,
   {ETPrompt,}
   ETDateU,
   {BtrvU2,}
{   VarFposU,

   ComnUnit,
   {ComnU2,
   SysU1,  }
   BTSupU1,
   BTSupU2,
{   ESecMsgU,}

   {$IFNDEF COMP}
     {$IFNDEF OLE}
     {$IFNDEF EXDLL}
{       Excep2U,}
     {$ENDIF}
     {$ENDIF}
   {$ENDIF}

   Dialogs,
   {$IFNDEF DLLU}
{   MCMFuncs,}
   {$ENDIF}
{   SysU3,}
   SecureU;




{ == Display ISN == }

Function ISN2Str(EXISN     : ISNArrayType)  :  Str255;


Var
  n       :  Byte;

Begin
  Result:='';

  For n:=Low(EXISN) to High(EXISN)-2 do
  Begin
    Result:=Result+SetPadNo(Form_Int(EXISN[n],0),3);

    If (n<>High(EXISN)-2) then
      Result:=Result+'-';
  end;

end;


{ == Function to Check if Security Ok == }


Function FullyReleased  :  Boolean;

Var
  v1FullExSec,
  v2FullExSec,
  FullExSec,
  CurSecy,
  CurRel     :  LongInt;


Begin

  With Syss do
  Begin

    CurSecy:=Calc_Security(ExSecurity,BOff);

    FullExSec:=CurSecy+SecRelCode;

    v1FullExSec:=CurSecy+v1SecRelCode;

    v2FullExSec:=CurSecy+v2SecRelCode;

    CurRel:=Calc_Security(ExRelease,BOn);

    FullyReleased:=(CurRel=FullExSec) or (CurRel=v1FullExSec) or (CurRel=v2FullExSec);

  end;

end;

Function ISN_CheckSum(EXISN     : ISNArrayType)  :  Integer;

Var
  n       :  Integer;

  Inum    :  Integer;

Begin
  Inum:=0;

  For n:=Low(EXISN) to High(EXISN)-2 do
    Inum:=Inum+EXISN[n];

  Result := Inum Mod 9;

  If (Result<0) or (Result>9) then
    Result:=9;

end;

{ == Function to Generate an ISN based Security Code == }

Function Get_ISNSecurity(EXISN     : ISNArrayType)  :  Str20;

  Function Get_ModuleSecurity(ModNo     :  Byte;
                              RelMode   :  Boolean)  :  Str20;
  Var
    TStr  :  Str255;
    SecNo :  LongInt;
    l,n   :  Byte;
  Begin
    SecNo:=Set_Security;
    TStr:=Form_Int(SecNo,0);
    l:=Length(TStr);

    If (ModNo>9) then
      n:=2
    else
      n:=1;

    TStr:=Copy(TStr,1,l-n)+Form_Int(ModNo,0);
    SecNo:=IntStr(TStr);
    Get_ModuleSecurity:=Calc_SecStr(SecNo,RelMode);
  end;
Begin
  Get_ISNSecurity:=Get_ModuleSecurity(ISN_CheckSum(EXISN),BOff);

end;

 { ================ Procedure to Get Security Release Code ================= }

(*
Procedure GetReleaseCode(Var GotOk  :  Boolean;
                             FullExSec,
                             NextDSec
                                    :  LongInt);
Var
  SecureFrm  :  TSecureFrm;
Begin
  SecureMode:=BOn;

  SecureFrm:=TSecureFrm.Create(Application);

  try
    With SecureFrm do
    Begin
      LFullExSec:=FullExSec;
      LNextDSec:=NextDSec;
      ISNF.Text:=ISN2Str(Syss.EXISN);
      SecF.Text:=Syss.ExSecurity;
      RelF.Text:=Syss.ExRelease;


      ShowModal;

      GotOk:=GotSecOk;
      Syss.ExRelease:=RelF.Text;
    end; {With..}

  finally
    SecureFrm.Free;

  end; {try..}

end;
*)


{ == Procedure to update other companies == }

(*
Procedure Replicate_CoSecurity;

Var
  mbRet   :  Word;
  MCMRes  :  LongInt;
  LogStr,
  DatDir  :  Str255;


Begin
  LogStr:='';
  DatDir:=SetDrive;

  {$IFNDEF DLLU}
    MCMRes:=Dyn_ReplicateEntLicence (ExMainCoPath^,DatDir);


    If (MCMRes<>0) then
    Begin
      LogStr:='It was not possible to access EntComp.DLL to replicate the security codes.'+#13+
                        'Error '+Form_Int(MCMRes,0)+' in '+DatDir;

      mbRet:=MessageDlg(LogStr,mtWarning,[mbOK],0);


      {$IFNDEF COMP}
        {$IFNDEF OLE}
        {$IFNDEF EXDLL}
          AddErrorLog('Error Replicating Security',LogStr,2);
        {$ENDIF}
        {$ENDIF}
      {$ENDIF}

    end;
 {$ENDIF}
end;
*)

{ ============ Function to Check if Security Ok =========== }

(*
Function Get_Security  :  Boolean;

Var
  MCMRes,
  FullExSec,
  NextDSec,
  SecDays,
  CurSecy,
  CurRel     :  LongInt;

  RelDOW,
  RelMoveX   :  Byte;

  TmpBo,
  UseRepCo,
  Locked     :  Boolean;

  RelDateStr :  LongDate;

  Rd,Rm,Ry   :  Word;

  TSecCode,
  TRelCode   :  Str10;

  CurrTime   :  TimeTyp;

  SecFrm     :  TESecFrm;

  LogStr     :  String;

Begin

  SecFrm:=nil;

  LogStr:='';

  Locked:=BOff;

  FullExSec:=0;

  NextDSec:=0;

  SecDays:=0;

  MCMRes:=0;

  CurSecy:=0;

  CurRel:=0;  TSecCode:=''; TRelCode:='';

  UseRepCo:=BOff;

  TmpBo:=SBSIn;

  RelDOW:=0;
  RelMoveX:=0;

  If (Not TmpBo) then
  With Syss do
  Begin

    JulCal(RelDate,Rd,Rm,Ry);

    RelDateStr:=StrDate(Ry,Rm,Rd);

    SecDays:=ABS(NoDays(Today,RelDateStr));
    {SecDays:=10;}


    RelDOW:=DayofWeek(Today);

    GetCurrTime(CurrTime);

    {* Avoid triggering outside office hours, or BOn a Fri-Mon *}

    If ((RelDateStr<Today) and (Not (RelDOW In [0,1,5,6])) and (CurrTime.HH>9)
       and (CurrTime.HH<17))
      or (SecDays>AbsMaxDays) or (RelDate=0) then {* Security Check required *}
    Begin

      Locked:=BOn;


      SecFrm:=TESecFrm.Create(Application);

      try
        SecFrm.SecLab.Caption:='Verifying Security...';

      except
        SecFrm.Free;
        Secfrm:=nil;
      end; {try..}


      If GetMultiSys(BOff,Locked,SysR) and (Locked) then {* We have the lock *}
      Begin

        TSecCode:=ExSecurity; TRelCode:=ExRelease;

        If (Assigned(SecFrm)) then
        Begin
          SecFrm.Free;
          SecFrm:=nil;
          MDI_ForceParentBkGnd(BOff);

        end;


        RelDate:=0;  {* Reset Security Date so once triggered,
                        setting the system date has no effect *}

        CurSecy:=Calc_Security(ExSecurity,BOff);

        If (CurSecy=0) then
        Begin
          {CurSecy:=Set_Security;

          ExSecurity:=Calc_SecStr(CurSecy,BOff);}

          ExSecurity:=Get_ISNSecurity(EXISN);

          CurSecy:=Calc_Security(ExSecurity,BOff);

        end;

        FullExSec:=CurSecy+SecRelCode;

        NextDSec:=CurSecy+SecXtra30Code;

        CurRel:=Calc_Security(ExRelease,BOn);

        If (Not FullyReleased) then {* We Need a Release Code *}
        Begin
          {$IFNDEF DLLU}
            MCMRes:=Dyn_MCM_SecWizard (ExMainCoPath^,SetDrive,4,BOn);

            TmpBO:=(MCMRes=1) or (MCMRes=2);

            MDI_ForceParentBkGnd(BOff);
          {$ENDIF}


          If (MCMRes>2) then
          Begin
            If (MCMRes=1300) then
              LogStr:='The file '+ExMainCoPath^+'Enterprse.Dat could not be found.'+#13+
                      'Without this file, the system cannot be started.'
            else
              LogStr:='It was not possible to access EntComp.DLL'+#13+
                      'Error '+Form_Int(MCMRes,0)+' was returned.';

            {$IFNDEF COMP}
              {$IFNDEF OLE}
              {$IFNDEF EXDLL}
                AddErrorLog('Error accessing EntComp.DLL.',LogStr,2);
              {$ENDIF}
              {$ENDIF}
            {$ENDIF}


            SecFrm:=TESecFrm.Create(Application);

            try
              SecFrm.Visible:=BOff;

              SecFrm.UserLab.Caption:='WARNING!';


              SecFrm.SecLab.Caption:=LogStr;
              SecFrm.OkBtn.Visible:=BOn;

              SecFrm.ShowModal;

            finally

              SecFrm.Free;
              Secfrm:=nil;
              MDI_ForceParentBkGnd(BOff);

            end; {try..}
          end; {If cannot use MCM..}

          {$IFDEF OLDCALLX}

            GetReleaseCode(TmpBo,FullExSec,NextDSec);

            CurRel:=Calc_Security(ExRelease,BOn);

            If (CurRel=NextDSec) then
            Begin
              RelDateStr:=CalcDueDate(Today,MaxDaysSecy);

              RelDOW:=DayofWeek(RelDateStr);

              Case RelDOW of {* Its at the weekend/Bank hols ... move to mid week *}

                0,1   :  RelMoveX:=2;
                5,6   :  RelMoveX:=(4-(RelDOW-5));

                else     RELMoveX:=0;

              end; {Case..}

              If (RelMoveX>0) then
                RelDateStr:=CalcDueDate(RelDateStr,RelMoveX);

              DateStr(RelDateStr,Rd,Rm,Ry);

              RelDate:=CalJul(Rd,Rm,Ry);

              Blank(ExSecurity,SizeOf(ExSecurity));  {* Force new security code,
                                                        otherwise same next 30 day
                                                        code would work again! *}

              Blank(ExRelease,SizeOf(ExRelease));
            
          end;
          {$ENDIF}
        end
        else {* Release code already Set *}
          TmpBo:=BOn;


        {* Update duplicate record *}
        {If (TSecCode<>ExSecurity) or (TRelCode<>ExRelease)  then
        Begin
          TrackSecUpdates(BOff);

          UseRepCo:=BOn;
        end;

        PutMultiSys(SysR,BOn);

        If (UseRepCo) then
          Replicate_CoSecurity;}

      end; {If Locked ok..}
    end {If Security code not required yet}
    else
    Begin
      TmpBo:=BOn;

      If (SecDays=10) or (SecDays <6) then {* Warn about to expire *}
      Begin
        {$IFNDEF DLLU}
        MCMRes:=Dyn_MCM_SecWizard (ExMainCoPath^,SetDrive,4,BOn);
        {$ENDIF}

        LogStr:='Your security code is due to expire on '+PoutDate(RelDateStr)+'.'+#13+
                  'Contact your supplier to release the system before this date.';


        If (MCMRes=0) or  (MCMRes=1) or (MCMRes=2) then
        Begin
          {$IFNDEF COMP}
            {$IFNDEF OLE}
            {$IFNDEF EXDLL}
              AddErrorLog('Security Code Expiry Warning.',LogStr,2);
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        end
        else
        Begin
          {$IFNDEF COMP}
            {$IFNDEF OLE}
            {$IFNDEF EXDLL}
            AddErrorLog('Error accessing EntComp.DLL.','It was not possible to access EntComp.DLL'+#13+
                        'Error '+Form_Int(MCMRes,0)+' was returned.',2);
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}


          SecFrm:=TESecFrm.Create(Application);

          try
            SecFrm.Visible:=BOff;

            SecFrm.UserLab.Caption:='WARNING!';

            LogStr:='Your security code is due to expire on '+PoutDate(RelDateStr)+'.'+#13+
                    'Contact your supplier to release the system before this date.';

            SecFrm.SecLab.Caption:=LogStr;
            SecFrm.OkBtn.Visible:=BOn;

            SecFrm.ShowModal;

          finally

            SecFrm.Free;
            Secfrm:=nil;
            MDI_ForceParentBkGnd(BOff);

          end; {try..}
        end; {If cannot use MCM..}
      end;
    end;
  end; {If SBSIn}

  If (Assigned(SecFrm)) then
    SecFrm.Free;

  Get_Security:=TmpBo;

end; {Proc..}



Function DeCode_Usrs(SecStr,RelStr  :  Str20)  :  LongInt;

Var
  SecNo,
  RelNo,
  Lnum    :  LongInt;

Begin

  SecNo:=Calc_Security(SecStr,BOff);

  If (SecNo>MaxUsrRel) then
    SecNo:=MaxUsrRel;

  RelNo:=Calc_Security(RelStr,BOn);

  Lnum:=RelNo-SecNo;

  If ((Lnum Mod UsrSeed)=0) and (Lnum<>0) then
    DeCode_Usrs:=Lnum Div UsrSeed
  else
    DeCode_Usrs:=1;


end; {Func.,.}


 { ================ Procedure to Get Security Release Code ================= }

Procedure ShowMaxUsers;

Var
  SecureFrm  :  TSecureFrm;
Begin
  SecureMode:=BOff;

  SecureFrm:=TSecureFrm.Create(Application);

  try
    With SecureFrm do
    Begin
      ShowModal;
    end; {With..}

  finally
    SecureFrm.Free;

  end; {try..}

end;


{ ============ Function to Manage User Count =========== }

Function Update_Users(IncU  :  Integer;
                      Warn  :  Boolean) :  Boolean;

Var
  CurSecy,
  MaxUsers   :  LongInt;

  Locked     :  Boolean;

  RelDateStr :  LongDate;

  Rd,Rm,Ry   :  Word;

  SecFrm     :  TESecFrm;


Begin
  SecFrm:=nil;

  Locked:=BOn;

  CurSecy:=0;

  Result:=BOn;

  SecFrm:=TESecFrm.Create(Application);

  try
    SecFrm.SecLab.Caption:='Verifying User License...';

  except
    SecFrm.Free;
    Secfrm:=nil;
  end; {try..}


  If GetMultiSys(BOn,Locked,SysR) and (Locked) then
  With Syss do
  Begin
    If (Assigned(SecFrm)) then
    Begin
      SecFrm.Free;
      SecFrm:=nil;
      MDI_ForceParentBkGnd(BOff);
    end;

    Case IncU of


        1  :  Begin

                CurSecy:=Calc_Security(ExUsrSec,BOff);

                If (CurSecy=0) then {* Usr Security not been set, gen now *}
                Begin
                  CurSecy:=Set_Security;

                  ExUsrSec:=Calc_SecStr(CurSecy,BOff);
                end;

                MaxUsers:=DeCode_Usrs(ExUsrSec,ExUsrRel);

                If (EntULogCount>=MaxUsers) and (Warn) then
                Begin

                  JulCal(UsrRelDate,Rd,Rm,Ry);

                  RelDateStr:=StrDate(Ry,Rm,Rd);

                  If (RelDateStr<Today) then
                  Begin

                    ShowMaxUsers;

                    UsrRelDate:=0;

                    Result:=BOff;

                  end;

                end;

                EntULogCount:=EntULogCount+Ord(Result);

              end;


       -1  :  If (EntULogCount>0) then {*  Mod to prevent a reset whilst all users are in thus
                                          making the count -ve, and increasing the no users *}
                Dec(EntULogCount);



        0  :  EntULogCount:=0;

        99 :  If (SBSIN) then {* If daily password used record time and date used *}
              Begin
                Syss.LastDaily:=DateTimeToFileDate(Now);
              end;


    end; {Case..}

    If (IncU=99) then {* Set Duplicate security record up *}
      TrackSecUpdates(BOff);

    PutMultiSys(SysR,BOn);

  end {If Record Locked}
  else
    Result:=BOff;

  Update_Users:=Result;;

  If (Assigned(SecFrm)) then
    SecFrm.Free;

end; {Func..}*)




{ ===== Functions for setting and resetting Module release ===== }

Function Gen_ModRelCode(SecStr  :  Str20;
                        TDay    :  Boolean)  :  Str20;

Var
  SecNo  :  LongInt;


Begin

  SecNo:=Calc_Security(SecStr,BOn);

  If (SecNo>MaxModRel) then
    SecNo:=MaxModRel;

  SecNo:=SecNo+ModSeed+Ord(TDay);

  Gen_ModRelCode:=Calc_SecStr(SecNo,BOn);


end; {Func..}





(*
Function Check_ModRel(ModNo  :  Byte;
                      UpNow  :  Boolean)  :  Boolean;


Begin
  With SyssMod^.ModuleRel do
  {$B-}
    Check_ModRel:=(ModRelMode(ModNo)=1) or (Not Check_RelDateExp(ModNo,UpNow));
  {$B+}

end;



Procedure Set_RelDate(ModNo      :  Byte;
                      SetAgain,
                      LockRecord :  Boolean);

Var
  RelDOW,
  RelMoveX   :  Byte;

  RelDateStr :  LongDate;

  TmpBo,
  LOk,
  Locked     :  Boolean;


  Rd,Rm,Ry   :  Word;

  CurrTime   :  TimeTyp;

  SecFrm     :  TESecFrm;


Begin
  SecFrm:=nil;

  With SyssMod^.ModuleRel do
  Begin
    Locked:=BOn; LOk:=BOff;

    If (LockRecord) then
    Begin
      SecFrm:=TESecFrm.Create(Application);

      try
        SecFrm.SecLab.Caption:='Verifying Security...';

      except
        SecFrm.Free;
        Secfrm:=nil;
      end; {try..}

      LOk:=GetMultiSys(BOn,Locked,ModRR);

    end
    else
      LOk:=BOn;

    If (LOk) and (Locked) then {* We have the lock *}
    Begin

      If (Assigned(SecFrm)) then
      Begin
        SecFrm.Free;
        SecFrm:=nil;
        MDI_ForceParentBkGnd(BOff);
      end;

      If (SetAgain) then
      Begin
        RelDateStr:=CalcDueDate(Today,MaxDaysSecy);

        RelDOW:=DayofWeek(RelDateStr);

        Case RelDOW of {* Its at the weekend/Bank hols ... move to mid week *}

         0,1   :  RelMoveX:=2;
         5,6   :  RelMoveX:=(4-(RelDOW-5));

         else     RELMoveX:=0;

        end; {Case..}

        If (RelMoveX>0) then
          RelDateStr:=CalcDueDate(RelDateStr,RelMoveX);

        DateStr(RelDateStr,Rd,Rm,Ry);

        RelDates[ModNo]:=CalJul(Rd,Rm,Ry);

        {* Force new security code *}
        Blank(ModuleSec[ModNo,BOff],SizeOf(ModuleSec[ModNo,BOff]));
        Blank(ModuleSec[ModNo,BOn],SizeOf(ModuleSec[ModNo,BOn]));

      end
      else
        RelDates[ModNo]:=0;  {* Reset Security Date so once triggered,}


      If (LockRecord) then
      Begin
        {* Update duplicate record *}

        TrackSecUpdates(BOn);

        PutMultiSys(ModRR,BOn);

        Replicate_CoSecurity;
      end;

    end;


  end;


end;


Function Check_RelDateExp(ModNo  :  Byte;
                          LockRec:  Boolean)  :  Boolean;

Var
  RelDOW,
  RelMoveX   :  Byte;

  RelDateStr :  LongDate;

  SecDays    :  LongInt;

  Rd,Rm,Ry   :  Word;

  CurrTime   :  TimeTyp;


Begin
  Result:=BOn;

  With SyssMod^.ModuleRel do
  Begin
    JulCal(RelDates[ModNo],Rd,Rm,Ry);

    RelDateStr:=StrDate(Ry,Rm,Rd);

    SecDays:=ABS(NoDays(Today,RelDateStr));

    RelDOW:=DayofWeek(Today);

    GetCurrTime(CurrTime);

    {* Avoid triggering outside office hours, or on a Fri-Mon *}

    Result:= ((RelDateStr<Today) and (Not (RelDOW In [1,5..7])) and (CurrTime.HH>9)
       and (CurrTime.HH<17))
      or (SecDays>AbsMaxDays) or (RelDates[ModNo]=0);

    If (Result) and (RelDates[ModNo]<>0) then
      Set_RelDate(ModNo,BOff,LockRec);

  end;


  Check_RelDateExp:=Result;
end;





{ ======== Function to return Relese Mode ======== }

Function ModRelMode(ModNo  :  Byte)  :  Byte;

Var
  TStr,
  TStr2,
  SecStr,
  RelStr  :  Str20;


Begin
  With SyssMod^.ModuleRel do
  Begin
    SecStr:=Strip('R',[#32],ModuleSec[ModNo,BOff]);
    RelStr:=Strip('R',[#32],ModuleSec[ModNo,BOn]);
  end;


  TStr:=Gen_ModRelCode(SecStr,BOff);
  TStr2:=Gen_ModRelCode(SecStr,BOn);

    If (Not Syss.UseModuleSec) then
    Result:=1
  else
    Result:=(1*Ord(TStr=RelStr)) + (2*Ord(TStr2=RelStr));

  ModRelMode:=Result;

end;*)


{ HM 04/06/99: Added to calculate a 30-day expiry date }
Function CalcNewRelDate (NumDays : Integer) : Real;
Var
  RelDateStr        :  LongDate;
  RelDOW, RelMoveX  :  Byte;
  Rd, Rm, Ry        :  Word;
Begin { CalcNewRelDate }
  RelDateStr:=CalcDueDate(Today, NumDays);

  RelDOW:=DayofWeek(RelDateStr);

  Case RelDOW of {* Its at the weekend/Bank hols ... move to mid week *}

   0,1   :  RelMoveX:=2;
   5,6   :  RelMoveX:=(4-(RelDOW-5));

   else     RELMoveX:=0;

  end; {Case..}

  If (RelMoveX>0) then
    RelDateStr:=CalcDueDate(RelDateStr,RelMoveX);

  DateStr(RelDateStr,Rd,Rm,Ry);

  Result := CalJul(Rd,Rm,Ry);
End; { CalcNewRelDate }



{$IFDEF OLDWAYX}

  Procedure Get_Release;


  Var
    CurSecy,
    FullExSec,
    NextDSec:  LongInt;


    GotOk,
    Locked  :  Boolean;

  Begin

    GotOk:=BOff;

    Locked:=BOn;

    FullExSec:=0;

    NextDSec:=0;

    If (GetMultiSys(BOn,Locked,SysR)) and (Locked) then
    With Syss do
    Begin

      CurSecy:=Calc_Security(ExSecurity,BOff);

      If (CurSecy=0) then
      Begin
        ExSecurity:=Get_ISNSecurity(EXISN);

        CurSecy:=Calc_Security(ExSecurity,BOff);
      end;

      FullExSec:=CurSecy+SecRelCode;

      NextDSec:=CurSecy+SecXtra30Code;

      GetReleaseCode(GotOk,FullExSec,NextDSec);


      If (Not GotOk) then {* Reset *}
        GetMultiSys(BOn,Locked,SysR)
      else {* Set Duplicate security record up *}
        TrackSecUpdates(BOff);


      PutMultiSys(SysR,BOn);

      If (GotOk) then
        Replicate_CoSecurity;

      MDI_ForceParentBkGnd(BOff);

    end;

  end;

{$ENDIF}

{ == Procedure to Get Reelase Code == }
(*
Procedure Get_Release;


Var
  MCMRes     :  LongInt;
  SecFrm     :  TESecFrm;
  LogStr     :  String;


Begin

  SecFrm:=nil;

  {$IFNDEF DLLU}
     MCMRes:=Dyn_MCM_SecWizard (ExMainCoPath^,SetDrive,4,BOn);

     If (MCMRes<>0) and (MCMRes<>1) and (MCMRes<>2) then
     Begin
       LogStr:='It was not possible to access EntComp.DLL'+#13+
                   'Error '+Form_Int(MCMRes,0)+' was returned.';

       {$IFNDEF COMP}
         {$IFNDEF OLE}
         {$IFNDEF EXDLL}
           AddErrorLog('Error accessing EntComp.DLL.',LogStr,2);
         {$ENDIF}
         {$ENDIF}
       {$ENDIF}


       SecFrm:=TESecFrm.Create(Application);

       try
         SecFrm.Visible:=BOff;

         SecFrm.UserLab.Caption:='WARNING!';

         SecFrm.SecLab.Caption:=LogStr;
         SecFrm.OkBtn.Visible:=BOn;

         SecFrm.ShowModal;

       finally

         SecFrm.Free;
         Secfrm:=nil;

       end; {try..}
     end; {If cannot use MCM..}


     MDI_ForceParentBkGnd(BOff);

  {$ENDIF}

end;*)



end. {Unit..}
