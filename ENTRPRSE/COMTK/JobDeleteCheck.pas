unit JobDeleteCheck;

{$I DEFOVR.Inc}

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Forms,Grids,GlobVar,VarConst,VarRec2U,BtrvU2,
  ExBtTh1U;


type

{PR: 31/08/2012 ABSEXCH-13202 Class to update nominal history after deleting a job. This is a cut-down version of
TCheckNom in PostSp2U.pas which has been converted from a ThreadQueue/EntPost descendant to a normal class. As this
is only used after deleting a job, all unnecessary methods and variables have been removed for clarity.}

  TJobDeleteCheck = Class
  private
     DelJobR:  JobRecType;
     CommitMode:  Byte;
     FExLocal : TdPostExLocalPtr;

     FSOPLicenced : Boolean;
     FResult : Boolean;
     Function Set_ActJNHist(JRec  :  JobRecType)  :  Str255;
     Procedure Update_JobParentActual(LowKey,
                                      HiKey      :  Str255);
     Procedure Update_JobGlobalActuals;

     //Function to assign to ExLocal's LThShowMsg property to direct error handling away from display.
     function HandlePostingError(Sender  :  TObject;
                           Const SMode   :  Byte;
                           Const SMsg    :  ShortString)  :  Boolean;
   public
     constructor Create;
     function Execute : Boolean;

     property DelJobRec : JobRecType read DelJobR write DelJobR;
     property ExLocal : TdPostExLocalPtr read FExLocal write FExLocal;
     property SOPLicenced : Boolean read FSOPLicenced write FSOPLicenced;
  end; {Class..}

Implementation

Uses
  Dialogs,
  RPDefine,
  ETDateU,
  ETStrU,
  ETMiscU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  BTSupU1,
  ExWrap1U,

  SQLUtils;





  { ====== Function to set full NHist Key ====== }
  Function TJobDeleteCheck.Set_ActJNHist(JRec  :  JobRecType)  :  Str255;

  Var
    NCode  :  Char;

  Begin
    With JRec do
    Begin
      NCode:=JobType;

      Result:=FullNHistKey(Ncode,FullJobCode(JobCode),0,GetLocalPr(0).CYr,1);
    end; {With..}


  end; {Func..}

   { ============ Procedure to Update all Parent with lower budget records  ============ }

   Procedure TJobDeleteCheck.Update_JobParentActual(LowKey,
                                              HiKey      :  Str255);

   Const
     Fnum     =  NHistF;
     Keypath  =  NHK;

   Var
     n,
     Loop   :  Byte;

     CDpCode:  Str20;

     KeyChk,
     KeyHChk,
     KeyS,
     KeyHS  :  Str255;

     FoundOk,FLoop,
     BeenWarned,
     LOk,
     Locked :  Boolean;

     LowHist,
     GetHist,
     HedHist,
     HiHist :  HistoryRec;

     LastStatus
            :  Integer;

     TmpKPath,
     TmpStat
            :  Integer;

     TmpRecAddr
            :  LongInt;

     PBalBF :  Double;

     LUP    :  tPassDefType;
     {$IFDEF PERIODFIX}
       oUPCache : TUserPeriodCache;
     {$ENDIF}

  Begin

    LastStatus:=0; Loop:=0; n:=0; PBalBF:=0;


    Locked:=BOff;

    Extract_NHistfromNKey(Lowkey,LowHist);

    Extract_NHistfromNKey(Hikey,HiHist);

    LUP:=UserProfile^;
    {$IFDEF PERIODFIX}
      oUPCache := oUserPeriod.GetCache;
    {$ENDIF}

    With FExLocal^ do
    Begin
      With LowHist do
        KeyChk:=ExClass+Copy(Code,1,JobCodeLen);

      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,Keypath,KeyS);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      Begin


        GetHist:=LNHist;

        With GetHist do
        Begin
          Purchases:=Purchases*DocNotCnst;
          Sales:=Sales*DocNotCnst;
          Cleared:=Cleared*DocNotCnst;
          Value1:=Value1*DocNotCnst;
          Value2:=Value2*DocNotCnst;
        end;

        FLoop:=BOff; FoundOk:=BOff;

        TmpKPath:=KeyPath;

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

        If (GetHist.Pr<>YTD) and ((AfterPurge(GetHist.Yr,0))) then {Only process non carry forward codes, as YTD will be updated automatically. Purge year not destroyed}
        Repeat {Attempt to find immediate parent equivalent, if not create via fill}
          With HiHist do
          Begin
            {* Have to append the matching folio number to the code *}
            Code:=Copy(Code,1,JobCodeLen)+Copy(GetHist.Code,Succ(JobCodeLen),NomKeyLen);

            KeyHChk:=FullNHistKey(ExClass,Code,GetHist.Cr,GetHist.Yr,GetHist.Pr);
          end;

          KeyHS:=KeyHChk;

          LStatus:=LFind_Rec(B_GetEq,Fnum,Keypath,KeyHS);

          If (Not LStatusOk) or (Not CheckKey(KeyHChk,KeyHS,Length(KeyHChk),BOn)) then
          Begin
            {$IFDEF PERIODFIX}
            oUserPeriod.SetPeriodYear(GetHist.Pr, GetHist.Yr);
            {$ELSE}
            With UserProfile^ do
            Begin
              UCYr:=GetHist.Yr;
              UCPr:=GetHist.Pr;
            end;
            {$ENDIF}

            LFillBudget(FNum,KeyPath,n,KeyHChk);

          end
          else
            FoundOk:=BOn;

          fLoop:=Not fLoop;

        Until (Not fLoop) or (FoundOk);

        If (FoundOk) then
        Begin
          HedHist:=LNHist;

          LPost_To_Hist2(HedHist.ExClass,HedHist.Code,
                                 GetHist.Purchases,
                                 GetHist.Sales,
                                 GetHist.Cleared,
                                 GetHist.Value1,
                                 GetHist.Value2,
                                 HedHist.Cr,HedHist.Yr,HedHist.Pr,
                                 PBalBF);


          If (GetHist.ExClass In YTDSet) then {Process carry forward codes YTD, and future YTD}
            LPost_To_CYTDHist2(HedHist.ExClass,HedHist.Code,
                               GetHist.Purchases,
                               GetHist.Sales,
                               GetHist.Cleared,
                               GetHist.Value1,
                               GetHist.Value2,
                               HedHist.Cr,HedHist.Yr,YTD);
        end; {If FoundOk..}

        TmpStat:=LPresrv_BTPos(Fnum,TmpKpath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

        LStatus:=LFind_Rec(B_GetNext,Fnum,keypath,KeyS);

      end; {While..}

      LReport_BError(Fnum,LastStatus);

    end; {With..}

    UserProfile^:=LUP;
    {$IFDEF PERIODFIX}
      oUserPeriod.RestoreCache(oUPCache);
    {$ENDIF}
  end; {Proc..}

  { === Procedure to Scan all low level Job records and update upper levels with actual totals === }

  Procedure TJobDeleteCheck.Update_JobGlobalActuals;


  Const
    Fnum1    =  JobF;
    Keypath1 =  JobCodeK;


    ModeCode = JobGrpCode;




  Var
    KeyS,
    KeyChk,
    KeyCat,
    LowKey,
    HiKey    :  Str255;

    RecAddr  :  LongInt;

    Mode,
    LoopEnd,
    NoAbort  :  Boolean;

    mbRet    :  Word;

    Fnum,
    Keypath,
    TmpKPath,
    TmpStat
             :  Integer;

    ItemCount,
    TmpRecAddr
             :  LongInt;

    {$IFDEF Rp}
      TbBalance :  Double;
//      ChkTbBal  :  ^TGenReport;

    {$ENDIF}


  Begin
    // Send_UpdateList(70);



    {$B-}

    With FExLocal^ do
    Begin

    {$B+}

      ItemCount:=0;

      KeyS:='';

      LowKey:='';

      HiKey:='';

      LoopEnd:=BOff;


      Fnum:=Fnum1;

      Keypath:=Keypath1;

      LJobRec^:=DelJobR;
      LStatus:=0;

      While (LStatusOk) do
      Begin

        If (Not (LJobRec^.JobType In [JobGrpCode]))  then
        Begin
          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

          LowKey:=Set_ActJNHist(LJobRec^);

          With LJobRec^ do
            KeyChk:=FullJobCode(JobCat);

          LoopEnd:=BOff;

          Repeat

            LStatus:=LFind_Rec(B_GetEq,Fnum,keypath,KeyChk);

            LoopEnd:=Not LStatusOk;

            If (LStatusOk) then
            Begin

              HiKey:=Set_ActJNHist(LJobRec^);


              Update_JobParentActual(LowKey,HiKey);

            end;

            If (Not LoopEnd) then
              With LJobRec^ do
              Begin
                LoopEnd:=(EmptyKey(JobCat,JobCodeLen));

                KeyChk:=FullJobCode(JobCat);
              end; {With..}

          Until (LoopEnd);


          TmpStat:=LPresrv_BTPos(Fnum,Keypath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);


        end; {If a non heading variable}

        LStatus:=9; {* Force end as only dealing with one *}
      end; {while..}

      With DelJobR do {* Remove job history here *}
      Begin
        KeyChk:=JobType+JobCode;

        LDeleteLinks(KeyChk,NHistF,Length(KeyChk),NHK,BOff);
      end;
    end; {If In Nom/Stock}
  end; {Proc..}


function TJobDeleteCheck.Execute : Boolean;
Begin
  FResult := True;
  FExLocal^.LThShowMsg := HandlePostingError;
  Try
    Update_JobGlobalActuals;
  Except
    on E:Exception do
      HandlePostingError(Self, 0, 'Exception in TJobDeleteCheck.Execute: ' + E.Message);
  End;
  Result := FResult;
end;

constructor TJobDeleteCheck.Create;
begin
  inherited;
  CommitMode := 0;
end;

function TJobDeleteCheck.HandlePostingError(Sender  :  TObject;
                        Const SMode   :  Byte;
                        Const SMsg    :  ShortString): Boolean;
begin
  FResult := False;
  Result := False;
  LastErDesc := SMsg;
end;

end.
