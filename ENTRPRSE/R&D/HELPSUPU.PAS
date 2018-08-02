Unit HelpSupU;


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

Uses GlobVar,
     VarRec2U;




Procedure Replicate_CoSecurity;

Function Get_Security  :  Boolean;


Function FullyReleased  :  Boolean;

Function Calc_TodayPW2  :  Str20;

Function Update_Users(IncU  :  Integer;
                      Warn  :  Boolean) :  Boolean;

Function Check_ModRel(ModNo  :  Byte;
                      UpNow  :  Boolean)  :  Boolean;

Function Check_RelDateExp(ModNo  :  Byte;
                          LockRec:  Boolean)  :  Boolean;

Procedure Set_RelDate(ModNo      :  Byte;
                      SetAgain,
                      LockRecord :  Boolean);

Function ModRelMode(ModNo  :  Byte)  :  Byte;


{ HM 04/06/99: Added new function to calculate Release Code Expiry Dates }
Function CalcNewRelDate (NumDays : Integer) : Real;

Procedure Get_Release;


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
   BtrvU2,
   VarFposU,

   ComnUnit,
   {ComnU2,}
   SysU1,
   BTSupU1,
   BTSupU2,
   ESecMsgU,

   {$IFNDEF COMP}
     {$IFNDEF OLE}
     {$IFNDEF EXDLL}
     {$IFNDEF EBAD}
       Excep2U,
     {$ENDIF}
     {$ENDIF}
     {$ENDIF}
   {$ENDIF}

   {$IFDEF LTE} // MHDEMO
     Brand,
   {$ENDIF}

   Dialogs,
   {$IFNDEF DLLU}
   MCMFuncs,
   {$ENDIF}
   SysU3,
   SecSup2U,
   SecureU;




{ == Display ISN == }



{ == Function to Check if Security Ok == }


Function FullyReleased  :  Boolean;

Var
  v1FullExSec,
  v2FullExSec,
  v3FullExSec,
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
    v3FullExSec:=CurSecy+v3SecRelCode;

    CurRel:=Calc_Security(ExRelease,BOn);

    FullyReleased:=(CurRel=FullExSec) or (CurRel=v1FullExSec) or (CurRel=v2FullExSec) or (CurRel=v3FullExSec);

  end;

end;


Function Calc_TodayPW2  :  Str20;

Begin
  Result:=Generate_ESN_BaseSecurity(Syss.EXISN,244,0,0);

end;


 { ================ Procedure to Get Security Release Code ================= }

Procedure GetReleaseCode(Var GotOk  :  Boolean;
                             FullExSec,
                             NextDSec,
                             YrNextDSec
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

      LYrNextDSec:=YrNextDSec;

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


{ == Procedure to update other companies == }

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
        {$IFNDEF EBAD}
          AddErrorLog('Error Replicating Security',LogStr,2);
        {$ENDIF}
        {$ENDIF}
        {$ENDIF}
      {$ENDIF}

    end;
 {$ENDIF}
end;


{$IFDEF LTE} // MH GP
// Check to see if the Activation or Grace Period have expired, if the Activation has expired
// then automatically setup the grace period.
Procedure CheckActivationExpiry;
Var
  RelDateStr : LongDate;
  Rd,Rm,Ry   : Word;
Begin // CheckActivationExpiry
  // Calculate the exipry date
  JulCal(Syss.RelDate,Rd,Rm,Ry);
  RelDateStr:=StrDate(Ry,Rm,Rd);

  // Check whether it has expired
  If (RelDateStr < Today) or (Syss.RelDate=0) Then
  Begin
    If (Syss.GracePeriod = 0) Then
    Begin
      // Activation Expired - start grace period
      Syss.GracePeriod := 1;

      // Set Grace Period Expiry to 30-days from Activation Expiry otherwise they could jump the
      // workstation date forward to get a longer Grace Period
      RelDateStr:=CalcDueDate(RelDateStr, 30);   // Increment the existing Expiry Date by 30 days
      DateStr(RelDateStr,Rd,Rm,Ry);              // Split into Day, Month, Year
      Syss.RelDate := CalJul(Rd,Rm,Ry);          // Convert to Julian Date

      // Update the system setup & licencing records
      PutMultiSys(SysR,BOff);
      TrackSecUpdates(BOff);
    End; // If (Syss.GracePeriod = 0)
  End; // If (RelDateStr < Today) or (Syss.RelDate=0)
End; // CheckActivationExpiry
{$ENDIF}


{ ============ Function to Check if Security Ok =========== }
Function Get_Security  :  Boolean;

Var
  MCMRes,
  FullExSec,
  NextDSec,

  YrNextDSec,

  SecDays,
  CurSecy,
  CurRel     :  LongInt;

  TStatus    :  Integer;

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

  YrNextDSec:=0;

  SecDays:=0;

  MCMRes:=0;

  CurSecy:=0;  TStatus:=0;

  CurRel:=0;  TSecCode:=''; TRelCode:='';

  UseRepCo:=BOff;

  TmpBo:=SBSIn;

  RelDOW:=0;
  RelMoveX:=0;

  If (Not TmpBo) then
  With Syss do
  Begin
    {$IFDEF LTE} // MH GP
      // MH 02/08/06: For Demo Installations there is no grace period (MHDEMO)
      If (Not Syss.ExDemoVer) Then
      Begin
        // Check to see if the Activation or Grace Period have expired
        CheckActivationExpiry;
      End; // If (Not Syss.ExDemoVer)
    {$ENDIF}

    JulCal(RelDate,Rd,Rm,Ry);

    RelDateStr:=StrDate(Ry,Rm,Rd);

    SecDays:=ABS(NoDays(Today,RelDateStr));
    {SecDays:=10;}


    RelDOW:=DayofWeek(Today);

    GetCurrTime(CurrTime);

    // MH 17/07/06: Added separate IAO clause
    {$IFDEF LTE} // MH GP
    // MH 17/07/06: IAO doesn't check the day or time because the activation web-service should be
    // running 24x7 so it is unnecessary, and it also causes the expiry dates to become out of sync
    // with the contracted dates
    If (RelDateStr < Today) Or (RelDate = 0) Then
    {$ELSE}
    {* Avoid triggering outside office hours, or BOn a Fri-Mon *}
    If ((RelDateStr<Today) and (Not (RelDOW In [0,1,5,6])) and (CurrTime.HH>9)
       and (CurrTime.HH<17))
      or (SecDays>AbsMaxDays) or (RelDate=0) then {* Security Check required *}
    {$ENDIF}
    Begin

      Locked:=BOn;


      SecFrm:=TESecFrm.Create(Application);

      try
        SecFrm.SecLab.Caption:='Verifying Security...';

      except
        SecFrm.Free;
        Secfrm:=nil;
      end; {try..}

      If GetMultiSys(BOn,Locked,SysR) and (Locked) then {* We have the lock *}
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

        // MH 17/07/06: Reset IAO Grace Period  (MH GP)
        Syss.GracePeriod := 0;

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

        YrNextDSec:=CurSecy+SecXtra365Code;

        CurRel:=Calc_Security(ExRelease,BOn);

        If (Not FullyReleased) then {* We Need a Release Code *}
        Begin
          {We need to update the fact the system has been reset, before we call the wizard.}

          PutMultiSys(SysR,BOff);
          TrackSecUpdates(BOff);




          {$IFNDEF DLLU}
            {$IFDEF LTE} // MHDEMO
              // MH 02/08/06: For IAO Demo Installations just display an expired message
              If Syss.ExDemoVer Then
              Begin
                MessageDlg ('This Demo Installation of ' + Branding.pbProductName + ' has expired',
                            mtInformation, [mbOK], 0);
                MCMRes := 0;
              End // If Syss.ExDemoVer
              Else
            {$ENDIF}
            MCMRes:=Dyn_MCM_SecWizard (ExMainCoPath^,SetDrive,4,BOn);

            {$IFDEF LTE} // IAO RO
              // LITE - 0=Cancel, 1=Released, 2=New Code Entered
              // for lite it goes into read only mode if no release code is available
              // MH 02/08/06: Added check for Demo Installations
              TmpBO := (MCMRes >= 0) And (MCMRes <= 2) And (Not Syss.ExDemoVer); // MHDEMO
            {$ELSE}
              TmpBO:=(MCMRes=1) or (MCMRes=2);
            {$ENDIF}

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
              {$IFNDEF EBAD}
                AddErrorLog('Error accessing EntComp.DLL.',LogStr,2);
              {$ENDIF}
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
              SecFrm.Visible:=BOff;
              SecFrm.Free;
              Secfrm:=nil;
              MDI_ForceParentBkGnd(BOff);

            end; {try..}
          end; {If cannot use MCM..}

          {$IFDEF OLDCALLX}

            GetReleaseCode(TmpBo,FullExSec,NextDSec,YrNextDSec);

            CurRel:=Calc_Security(ExRelease,BOn);

            If (CurRel=NextDSec) or (CurRel=YrNextDSec) then
            Begin
              RelDateStr:=CalcDueDate(Today,(MaxDaysSecy*Ord((CurRel=NextDSec)))+(OneYrMaxDaysSecy*Ord((CurRel=YrNextDSec))));


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


        If (UseRepCo) then
          Replicate_CoSecurity;}

        {* We need this to unlock the earlier get sys *}

        TStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysR]);

        {PutMultiSys(SysR,BOn); We cannot store here or we overwrite whatever the wizard has done.}

      end; {If Locked ok..}
    end {If Security code not required yet}
    else
    Begin
      TmpBo:=BOn;

      {$IFDEF LTE} // MH GP
      // IAO: Ask throughout the Grace Period or ask from 30-days remaining on the Activation Period
      // MH 02/08/06: Added check on Demo Version to suppress the Activation Wizard (MHDEMO)
      If ((Syss.GracePeriod = 1) Or (SecDays < 30)) And (Not Syss.ExDemoVer) Then
      {$ELSE}
      // Exchequer: Warn 10 days before expiry and then show daily from 5 days to go
      If (SecDays=10) or (SecDays <6) then {* Warn about to expire *}
      {$ENDIF}
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
            {$IFNDEF EBAD}
              AddErrorLog('Security Code Expiry Warning.',LogStr,2);
            {$ENDIF}
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        end
        else
        Begin
          {$IFNDEF COMP}
            {$IFNDEF OLE}
            {$IFNDEF EXDLL}
            {$IFNDEF EBAD}
            AddErrorLog('Error accessing EntComp.DLL.','It was not possible to access EntComp.DLL'+#13+
                        'Error '+Form_Int(MCMRes,0)+' was returned.',2);
            {$ENDIF}
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
            SecFrm.Visible:=BOff;
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
      SecFrm.Visible:=BOff;
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

                  {ExUsrSec:=Calc_SecStr(CurSecy,BOff);}

                  {*v5 makes this ESN specific*}
                  
                  ExUsrSec:=Generate_ESN_BaseSecurity(Syss.EXISN,254,0,0);
                end;

                MaxUsers:=DeCode_Usrs(ExUsrSec,ExUsrRel);

                If (EntULogCount>=MaxUsers) and (Warn) then
                Begin

                  JulCal(UsrRelDate,Rd,Rm,Ry);

                  RelDateStr:=StrDate(Ry,Rm,Rd);

                  If (RelDateStr<Today) then
                  Begin

                    ShowMaxUsers;

                    UsrRelDate:=0; {*!!! When this is implemented a call to TracSecUpdates is required *}


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

end; {Func..}






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
        SecFrm.Visible:=BOff;
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

end;


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
         {$IFNDEF EBAD}
           AddErrorLog('Error accessing EntComp.DLL.',LogStr,2);
         {$ENDIF}
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
         SecFrm.Visible:=BOff;
         SecFrm.Free;
         Secfrm:=nil;

       end; {try..}
     end; {If cannot use MCM..}


     MDI_ForceParentBkGnd(BOff);

  {$ENDIF}

end;




{Compare_ESN_BaseSecurity

Checks validity of release code against security code.
Note modes 1-99 ignore SecCode & RelCode and uses SyssMod^ directly

}

{$IFDEF DONTTHINKWENEEDTHIS}
Function Compare_ESN_BaseSecurity(SecCode,
                                  RelCode     :  Str20;
                                  ModuleNo    :  SmallInt)  :  Boolean;
Var
  FullExSecy  :  LongInt;

Begin

  Result:=BOff; FullExSecy:=0;

  Case ModuleNo of

    0       :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+SecRelCode;

                 Result:=(FullExSecy=Calc_Security(RelCode,BOn));
               end;
        {Module 1-99 Security}
    1..99   :  Begin
                 Result:=Check_ModRel(ModuleNo,BOff);
               end;

            {MCM Daily password}
    248     :  Begin
                 Result:=(RelCode=Calc_SecStr(Set_TodaySecurity-MCMDPOffSet,BOn));
               end;

                {Distributor release based on no of releases}
    249     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+SecDistCode;

                 Result:=(FullExSecy=Calc_Security(RelCode,BOn));
               end;

            {Plug-in generator based on number of releases}
    250     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+PIGSeed;

                 Result:=(FullExSecy=Calc_Security(RelCode,BOn));
               end;

            {Enterprise Daily password}
    251     :  Begin
                 Result:=(Relcode=Get_TodaySecurity);
               end;

        {Plug-in module based on check sum}
    252     :  Begin
                 FullExSecy:=Calc_Security(SecCode,BOff)+PIMSeed;

                 Result:=(FullExSecy=Calc_Security(RelCode,BOn));
               end;

    254     :  ; {Not valid, call decode_usrCount}


  end; {Case..}

end;

{$ENDIF}

(*Initialization
  ShowMessage ('SysRec: ' + IntToStr(SizeOf(SysRec)) + #13 +
               'MonWk1: ' + IntToStr(BtKeyPos(@Syss.MonWk1, @Syss)));*)
end.
