unit RepJCE2U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU;


type



  TJCCISReport1  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Procedure RepSetValTabs; Virtual; 

                       
                     private

                       UpdateCISSys,
                       ContMMode
                               :  Boolean;
                       CSDate,
                       CEDate  :  LongDate;

                       REWeeks,
                       REMonths:  LongInt;



                       Procedure RepPrintPageHeader2(ContMode  :  Boolean); 

                       Procedure StkEnd;

                       Function StkInclude  :  Boolean;

                       Procedure StkLine;

                       
                       Procedure PrintEOYTot(GMode     :  Byte); Virtual; 

                       Function ContinuousEmploy(SuppCode  :  Str10;
                                             Var SDate,
                                                 EDate     :  LongDate;
                                             Var EWeeks,
                                                 EMonths   :  Integer)  :  Boolean;

                       Procedure Print_Voucher;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       
                       Function GetReportInput  :  Boolean; Virtual;

                     public
                       ERMode  :  Byte;

                       ThisScrt   :  Scratch2Ptr;

                       CRepParam  :  JobCRep1Ptr;

                       VTots      :  Array[4..7] of Record
                                                      Gross,
                                                      Materials,
                                                      Tax         :  Double;

                                                      Counter     :  LongInt;
                                                    end;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure PrintValDetail;

                       Procedure CalcEOYTotals(CISTot  :  Totals);


                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;


                       Procedure Build_CISVouchers(Mode     :  Byte;
                                               Var AbortPrint
                                                            :  Boolean);

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddCISListRep2Thread(LMode    :  Byte;
                               IRepParam:  JobCRep1Ptr;
                               AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  VarJCstU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  {InvListU,
  RevalU2U,}
  SalTxl1U,
  JobSup1U,
  IntMU,
  {$IFDEF POST}
    CISSup2U,
  {$ENDIF}

  {$IFDEF FRM}
    PrintFrm,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  CISSup1U,
  JChkUseU,
  RpDefine,
  ExThrd2U;


{ ========== TSListReport methods =========== }

Constructor TJCCISReport1.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ERMode:=0;  UpdateCISSys:=BOff;

  Blank(VTots,Sizeof(VTots));
end;


Destructor TJCCISReport1.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TJCCISReport1.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ERMode of

        9 :  Begin
              SetTab (MarginLeft, pjLeft, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);
              SetTab (NA, pjRight, 39, 4, 0, 0);
              SetTab (NA, pJLeft, 25, 4, 0, 0);
             end;

        10:  Begin
             end;

    end; {Case..}

    SetTabCount;
  end; {With..}


end;



Procedure TJCCISReport1.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);    // Code
              SetTab (NA, pjLeft, 45, 4, 0, 0);            // Name      / SSK 09/05/2017 2017-R2 ABSEXCH-17146: Newwidth changed for Name & Company
              SetTab (NA, pjLeft, 72, 4, 0, 0);            // Company   // to accommodate full length of the field
              SetTab (NA, pjLeft, 22, 4, 0, 0);            // CIS Type
              SetTab (NA, pjLeft, 35, 4, 0, 0);            // CertNo.   // SSK 24/04/2017 2017-R2 ABSEXCH-17146: removed the tab setting for Expires column
            end;


        3 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 43, 4, 0, 0);
              SetTab (NA, pjLeft, 43, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjRight,20, 4, 0, 0);
              SetTab (NA, pjRight,20, 4, 0, 0);
              SetTab (NA, pjLeft, 40, 4, 0, 0);

            end;

        4,5
          :  ;  {Voucher print, no report output}

        20,21  {End of year summary. 21 = RCT30 for Ireland. Title only}
          :  Begin
               SetTab (MarginLeft, pjLeft, 40, 4, 0, 0);
               SetTab (NA, pjLeft, 40, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);

             end;


       25 :   {Detailed EOY report}
             Begin
               SetTab (MarginLeft, pjLeft, 46, 4, 0, 0);
               SetTab (NA, pjLeft, 43, 4, 0, 0);
               SetTab (NA, pjLeft, 30, 4, 0, 0);
               SetTab (NA, pjLeft, 40, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);
               SetTab (NA, pjRight,39, 4, 0, 0);


             end;



    end; {Case..}

    SetTabCount;
  end; {With..}


end;



Procedure TJCCISReport1.RepPrintPageHeader2(ContMode  :  Boolean);

Var
  GenStr  :  Str255;

Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^,MTExLocal^ do
  Begin
    DefFont(0,[fsBold]);

    Case ERMode of

      9
          :  Begin
               If (ContMode) then
                 GenStr:=' (continued...)'
               else
                 Genstr:='';

               SendRepDrillDown(1,TotTabs,1,CISCertKey(LJobDetl^.JobCISV.CISCertNo),JDetlF,JDStkK,3);

               SendLine(ConCat(#9,#9,'Matching for '+LJobDetl^.JobCISV.CISCertNo,#9,'OurRef',#9,'Date',#9,'YourRef',#9,'Value',#9,GenStr));

               DefLine(-1,TabStart(2),TabEnd(6+Ord(ContMode)),0);
             end;



      10
          :  Begin
             end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





  { ======================= Due End ======================= }


  Procedure TJCCISReport1.StkEnd;

  Var
    KitEnd     :  Str255;

    n,m        :  Byte;

  Begin

    With RepFiler1, CRepParam^ do
    Begin

      Case ERMode of

        9      :  Begin
                    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                    Self.CRLF;

                    RepSetTabs;

                  end;
      end; {Case..}
    end; {With..}
  end;




  { ======================= Due Include ======================= }


  Function TJCCISReport1.StkInclude  :  Boolean;

  Const
    Fnum    =  InvF;
    KeyPath =  InvOurRefK;


  Var
    TmpInclude :  Boolean;

    KeyS2      :  Str255;


  Begin

    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1 do
    Begin
      Case ERMode of

          9
               :  With LPassword.MatchPayRec do
                  Begin

                    TmpInclude:=BOn;

                    KeyS2:=DocCode;

                    LResetRec(Fnum);

                    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS2);

                  end;


        end; {Case..}



      end; {With..}

      {$B+}



      StkInclude:=TmpInclude;
  end; {Func..}


  { ======================= Due Line ======================= }


  Procedure TJCCISReport1.StkLine;


  Var
    UseRate,
    TBo        :  Boolean;

    N          :  Byte;


    GenStr     :  Str255;




  Begin


    With MTExLocal^, RepFiler1, CRepParam^ do
    Begin


      Case ERMode of


        9
           :  With LInv, LPassword.MatchPayRec do
              Begin

                GenStr:='';

                SendRepDrillDown(1,TotTabs,1,OurRef,InvF,InvOurRefK,0);

                SendLine(ConCat(#9,#9,#9,DocCode,
                         #9,POutDate(TransDate),
                         #9,YourRef,
                         #9,FormatCurFloat(GenRNDMask,Trunc(SettledVal),BOff,Syss.VatCurr)));

              end;


      end; {Case..}

    end; {With(s)..}
  end;



Procedure TJCCISReport1.PrintValDetail;



Const
  Fnum       =  PWrdF;

  Keypath    =  HelpNdxK;


Var
  KeyCS,
  KeyChk     :  Str255;

  NewLine    :  Boolean;

  Rnum       :  Real;


Begin

  Rnum:=0;

  NewLine:=BOn;  ContMMode:=BOff;


  With MTExLocal^,CRepParam^ do
  Begin
    ERMode:=9;

    KeyChk:=FullMatchKey(MatchTCode,MatchCCode,LJobDetl^.JobCISV.CISFolio);

    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin

      If (StkInclude) then
      Begin
        If (NewLine) or (ContMMode) then
          RepPrintPageHeader2(ContMMode);

        NewLine:=BOff; ContMMode:=BOff;

        StkLine;
      end;

      With RepFiler1 do
        If (LinesLeft<5) then
        Begin
          ThrowNewPage(5);
          ContMMode:=BOn;
        end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    If (Not NewLine) then
      StkEnd;

    ERMode:=0;
    RepSetTabs;
  end; {With..}
end; {Proc..}



Procedure TJCCISReport1.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of
             // SSK 24/04/2017 2017-R2 ABSEXCH-17146: 'Expires' Column is removed
      1   :  SendLine(ConCat(#9, 'Code', #9, 'Name', #9, 'Company', #9, CCCISName^ + ' Type', #9, 'Cert. No.'));


      2   :  ;


      3   :  SendLine(ConCat(#9,'Code',#9,'Name',#9,'Company',#9,CCCISName^+' Type',
                      #9,'Weeks',#9,'Months',#9,'Period'));

      4,5 :  ;

      20,21
          :  Begin
               SendLine(ConCat(#9,'Contractor''s tax reference',#9,SyssCIS^.CISRates.CISTaxRef));

               SendLine(ConCat(ConstStr(#9,3),'Column A',#9,'Column B',#9,'Column C'));

               SendLine(ConCat(#9,'Subcontractors''s Name',#9,'Latest Cert./Reg Card No.',#9,'Total payments made',
                               #9,'Cost of materials used',#9,'Total Tax deducted'));

             end;

      25
          :  Begin
               SendLine(ConCat(ConstStr(#9,5),'Column A',#9,'Column B',#9,'Column C'));

               SendLine(ConCat(#9,'Subcontractors''s Name',#9,'Employee Name',#9,GetIntMsg(4)+' No.',#9,'Latest Cert./Reg Card No.',
                               #9,'Total payments made',#9,'Cost of materials used',#9,'Total Tax deducted'));

             end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}


Procedure TJCCISReport1.RepPrintHeader(Sender  :  TObject);


Begin
  If (Not (ReportMode In [4,5])) then
    Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1 do
  Case ReportMode of
      25  :  If (CurrentPage>1) then
              PrintEmplLine(LJobMisc^.EmplRec.EmpCode,BOn);


  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TJCCISReport1.CalcEOYTotals(CISTot  :  Totals);

Var
  n          :  Byte;


Begin

  With CRepParam^ do
    Case ReportMode of

        20,21,25
           :  Begin
                For n:=Low(CISTot) to High(CISTot) do
                Begin
                  LineTot[n]:=LineTot[n]+CISTot[n];
                  StkTot[n]:=StkTot[n]+CISTot[n];
                  RepTotal[n]:=RepTotal[n]+CISTot[n];
                end;
              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TJCCISReport1.PrintEOYTot(GMode     :  Byte);

Var
  n,TM       :  Byte;

  ShowTot    :  Totals;


Begin


  With RepFiler1, CRepParam^, MTExLocal^ do
  Case ReportMode of
    20,21,25
       :  Begin
            TM:=(2*Ord(ReportMode=25));

            Case GMode of
              0  :  Begin
                      ShowTot:=LineTot;

                      LGetMainRec(CustF,LastJob);

                      SetReportDrillDown(1);

                      If (ReportMode<>25) then
                      Begin

                        SendText(ConCat(#9,LCust.Company,#9,Copy(StaStart,1,5),Spc(3),Copy(StaStart,6,Length(StaStart)-5)));
                      end
                      else
                      Begin
                        DefLine(-1,TabStart(2),TabEnd(05+TM),0);
                        DefFont(0,[fsBold]);


                        SendText(ConCat(ConstStr(#9,2+TM),'Totals: ',LCust.Company));
                      end;

                    end;
              1  :  Begin
                      ShowTot:=StkTot;
                      DefLine(-1,TabStart(2),TabEnd(05+TM),0);
                      DefFont(0,[fsBold]);

                      SendText(ConCat(ConstStr(#9,2+TM),'Totals for ',CISVTypeName(LastCIS)));

                    end;
              2  :  Begin
                      ShowTot:=RepTotal;
                      DefLine(-1,TabStart(1),TabEnd(05+TM),0);
                      DefFont(0,[fsBold]);

                      SendText(ConCat(ConstStr(#9,2+TM),'Return Totals',ConstStr('.',20)));

                    end;
            end;

            n:=3+TM;

            SendLine(ConCat(ConstStr(#9,n),FormatFloat(GenRNDMask,ShowTot[1]),
                            #9,FormatBFloat(GenRNDMask,ShowTot[2],(GMode<>2)),#9,FormatBFloat(GenRealMask,ShowTot[3],(GMode<>2))));


            Blank(LineTot,Sizeof(LineTot));

            If (GMode=1) then
            Begin
              Blank(STKTot,Sizeof(StkTot));
              // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
              Self.CRLF;
            end;

            DefFont(0,[]);

          end; {Case..}

  end; {Case..}

end;





{ ======================= Calculate if a sub contract employee has worked x weeks or months continously ==================== }
{Suppcode is the suplier code associated with the sub contractor.
SDate,Edate start and end date of purchase invoices to search for.
Will return the period of continous employemtn found in Sdate and EDate.
EWeeks, EMonths, number of contious weeks and months found.
Function returns true id Eweeks or EMonths <>0}

Function TJCCISReport1.ContinuousEmploy(SuppCode  :  Str10;
                                     Var SDate,
                                         EDate     :  LongDate;
                                     Var EWeeks,
                                         EMonths   :  Integer)  :  Boolean;
Const
  Fnum     =  InvF;
  Keypath  =  InvDateK;

Var
  n,fs       :  Byte;

  ResetWeeks,
  ContFound,
  FoundOk    :  Boolean;

  BeginDate,
  EndDate,
  LastMDate  :  LongDate;
  CEDays,
  CEMonths,
  MDiff,
  CEWeeks    :  Integer;
  KeyChk,
  KeyChk2,
  KeyS2      :  Str255;

  TmpStat,
  TmpKPath   : Integer;
  TmpRecAddr
             : LongInt;

  LastIDates : Array[1..7] of LongDate;


Begin
  Result:=BOff;

  TmpKPath:=GetPosKey;

  With MTExLocal^ do
  Begin
    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);

    KeyChk:=SDate; KeyChk2:=EDate;

    KeyS2:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    CEWeeks:=0; Blank(LastIDates,Sizeof(LastIDates));  CEDays:=0;  CEMonths:=0;  MDiff:=0;

    LastMDate:='';  ResetWeeks:=BOff;  ContFound:=BOff;  BeginDate:=''; EndDate:='';

    While (LStatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS2,Length(KeyChk),BOff)) and (Not ThreadRec^.THAbort) and (Not ContFound) do
    With LInv do
    Begin
      If (CheckKey(SuppCode,CustCode,Length(SuppCode),BOff)) and (InvDocHed In CISDocSet-CreditSet) then
      Begin
        fs:=0;  FoundOk:=BOff;

        {We have to compre against a whole week, or we will only be able to track exact 7 day gaps}
        For n:=Low(LastIDates) to High(LastIDates) do
        Begin
          FoundOk:=(TransDate=LastIDates[n]);

          If (FoundOk) then
            Break
          else
            If (LastIDates[n]='') and (fs=0) then
              fs:=n;
        end;

        If (Not FoundOk) and (fs>0) then
          LastIDates[fs]:=TransDate;

        ResetWeeks:=BOn;

        For n:=Low(LastIDates) to High(LastIDates) do
        Begin

          If (LastIDates[n]<>'') then {We have to start count again}
          Begin
            CEDays:=NoDays(LastIDates[n],TransDate);

            If (CEDays>7) then {There is a break in invoice run, so we count again}
            Begin
              LastIDates[n]:='';
            end
            else
            Begin
              If (fs<>n) then {Don't reset if we are comparing self}
                ResetWeeks:=BOff;

              If (CEDays=7) then
              Begin
                If (BeginDate='') and (CRepParam^.RepType=1) then
                  BeginDate:=LastIDates[n];

                Inc(CEWeeks);
                LastIDates[n]:='';
              end;
            end;

            If (LastIDates[n]='') and (Not FoundOk) and (fs=0) then
            Begin
              LastIDates[n]:=TransDate;
              fs:=n;
            end;

          end; {Ignore blank slots}
        end; {Loop}

        If (ResetWeeks) then
        Begin
          CEWeeks:=0;

          If (CRepParam^.RepType=1) then
            BeginDate:='';
        end;

        If (LastMDate='') then {We have to start count again}
          LastMDate:=TransDate
        else
        Begin
          MDiff:=MonthDiff(LastMDate,TransDate);

          If (MDiff>1) then {There is a break in invoice run, so we count again}
          Begin
            LastMDate:=''; CEMonths:=0;

            If (CRepParam^.RepType=0) then
              BeginDate:='';
          end
          else
          Begin
            If (MDiff<>0) then
              Inc(CEMonths);

            If (BeginDate='') and (CRepParam^.RepType=0) then
              BeginDate:=LastMDate;

            LastMDate:=TransDate;
          end;


        end;

        If (TransDate>EndDate) then
          EndDate:=TransDate;

      end;

      With CRepParam^ do
        ContFound:=(((CEWeeks>ExpTol) and (RepType=1)) or ((CEMonths>ExpTol) and (RepType=0)));

      If (Not ContFound) then
        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

    end;

    TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);
  end; {With..}
  EWeeks:=CEWeeks; EMonths:=CEMonths;

  If (ContFound) then
  Begin
    SDate:=BeginDate; EDate:=EndDate;
  end;

  Result:=ContFound;
end;


Procedure TJCCISReport1.Print_Voucher;

Var
  LOk,Locked
             :  Boolean;

  SBSPFMode,
  SBSPFNo    :  Byte;

  TmpCNo     :  Str255;

  Ok2Print   :  Boolean;

  {$IFDEF POST}
    VDupliO  :  ^TScanCIS;

  {$ENDIF}


Begin
  With CRepParam^, RepFiler1, MTExLocal^, LJobDetl.JobCISV do
  Begin
    {$IFDEF FRM}
        Ok2Print:=BOff;

        With RDevRec do
          If (ShowER) and ((Not Preview) or (Debug)) and (Not TestMode) then {* Attmept to renumber it *}
          Begin
            {$IFDEF POST}
               New(VDupliO,Create(Self.fMyOwner));

               Try
                 VDupliO^.MTExLocal:=Self.MTExLocal;

                 Repeat
                   TmpCNo:=FullStockCode(JobFilt+IntToStr(CISCount));

                   Inc(CISCount);

                 Until (ThreadRec^.THAbort) or (Not VDupliO^.LChkDupliCertNo(TmpCNo,JDStkK,0));

                 If (Not ThreadRec^.THAbort) then {Lock Voucher record}
                 Begin
                   LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,RKeyPath,RFnum,BOn,Locked);

                   If (LOk) and (Locked) then
                   Begin
                     LGetRecAddr(RFnum);

                     CISCertNo:=FullStockCode(JobFilt+IntToStr(Pred(CISCount)));

                     LStatus:=LPut_Rec(RFnum,RKeyPath);

                     LReport_BError(RFnum,LStatus);

                     LStatus:=LUnLockMLock(RFnum);

                   end;
                 end;

               Finally
                 Dispose(VDupliO,Destroy);

                 UpdateCISSys:=(Not ThreadRec^.THAbort);
               end;
            {$ENDIF}
          end;

        If (LCust.FDefPageNo<>0) or (RForm='') then
          RForm:=pfGetMultiFrmDefs(LCust.FDefPageNo).FormDefs.PrimaryForm[52+CISVTypeOrd(CRepParam^.RepType,BOff)];

        Ok2Print:=pfAddBatchForm(RDevRec,30,RForm,
                                 JDetlF,JDStkK,CISCertKey(CISCertNo),
                                 PWrdF,HelpNDXK,FullMatchKey(MatchTCode,MatchCCode,CISFolio),
                                 '',
                                 Nil,
                                 BOff);


    {$ENDIF}


  end; {With..}
end;


Procedure TJCCISReport1.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^, CRepParam^ do
  Begin
    Case ReportMode of

      1,3 :  With LJobMisc^.EmplRec do
             Begin
               SendRepDrillDown(1,TotTabs,1,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmpCode),JMiscF,JMK,0);
               SendRepDrillDown(3,3,2,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);

             end;
      20,21
          :  Begin
               SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);

             end;
      25  :  Begin
               Case DDMode of
                 0  :  {Normal Line}
                       With LJobDetl^.JobCISV do
                       Begin
                         SendRepDrillDown(1,TotTabs,1,FullCustCode(Copy(CISVSDate,1,CustKeyLen)),CustF,CustCodeK,0);

                         SendRepDrillDown(2,2,2,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)),JMiscF,JMK,0);

                         SendRepDrillDown(3,TotTabs,2,CISCertKey(CISCertNo),JDetlF,JDStkK,3);

                       end;

                 1  :  {Total Line}
                       Begin
                         SendRepDrillDown(1,TotTabs,1,FullCustCode(LCust.CustCode),CustF,CustCodeK,0);


                       end;

               end; {Case..}

             end;

    end; {Case..}
  end; {With..}
end;

{ ======================= Customer Line ======================= }


Procedure TJCCISReport1.PrintReportLine;

Var
  GenStr     :  Str255;
  ThisTot    :  Totals;
  NewCCode   :  Str10;
  PrintNames :  Boolean;

Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin

    GenStr:='';  PrintNames:=ShowER;

    Blank(ThisTot,Sizeof(ThisTot));

    With LJobMisc^.EmplRec do
    Begin
      Case ReportMode of
         20,21,25
            :  With LJobDetl^.JobCISV do
               Begin
                 If (LastCIS<>CISCType) or (LastJob<>LCust.CustCode) then
                 Begin
                   NewCCode:=LCust.CustCode;

                   If (LastJob<>'') then
                     PrintEOYTot(0);

                   If (LastCIS<>CISCType) then
                   Begin
                     If (LastCIS<>0) then
                       PrintEOYTot(1);

                     LastCIS:=CISCType;
                   end;

                   LastJob:=NewCCode;

                   If (ReportMode=25) then
                     LGetMainRec(CustF,LastJob);

                   PrintNames:=BOn;
                 end;

                 StaStart:=CISVCert;

                 ThisTot[1]:=Trunc(CISvGrossTotal);
                 ThisTot[2]:=Round_Up(CalcCISJDMaterial(LJobDetl^),0);
                 ThisTot[3]:=CISvTaxDue;

                 CalcEOYTotals(ThisTot);


               end;

      end; {Case..}


      If (ReportMode In [1,3]) then
        LGetMainRec(CustF,Supplier);

      SetReportDrillDown(0);


      Case ReportMode of
        1  :  Begin
                // SSK 24/04/2017 2017-R2 ABSEXCH-17146: changes made to remove the expires column
                SendLine(ConCat(#9, EmpCode,
                                #9, EmpName,
                                #9, LCust.Company,
                                #9, TxLate_CISTypeStr(CISType),
                                #9, CertNo));

              end;

        2  :  Begin
                ERMode:=9;

                StkLine;
              end;

        3  :  Begin
                GenStr:=POutDate(CSdate)+' - '+POutDate(CEDate);

                SendLine(ConCat(#9,EmpCode,
                         #9,EmpName,
                         #9,LCust.Company,
                         #9,TxLate_CISTypeStr(CISType),
                         #9,Form_Int(REWeeks,0),
                         #9,Form_Int(REMonths,0),
                         #9,GenStr));

              end;


      4,5  :  Print_Voucher;


      25   :  With LJobDetl^.JobCISV do
              Begin
                If (PrintNames) then
                  GenStr:=ConCat(#9,LCust.Company,#9,EmpName)
                else
                  GenStr:=#9+#9;

                SendLine(ConCat(GenStr,
                         #9,CISCertNo,
                         #9,Copy(CISVCert,1,5),Spc(3),Copy(CISVCert,6,Length(CISVCert)-5),
                         #9,FormatFloat(GenRNDMask,ThisTot[1]),
                         #9,FormatBFloat(GenRNDMask,ThisTot[2],BOn),
                         #9,FormatBFloat(GenRealMask,ThisTot[3],BOn)));

                If (ShowEr) then
                  PrintValDetail;
              end;


      end; {Case..}

    end; {With..}


  end;
end;


{ ======================= Customer End ======================= }


Procedure TJCCISReport1.PrintEndPage;
Var

  n  :  Byte;




Begin
  With RepFiler1 do
  Begin
    Case ReportMode of
      20,21,25
         :  Begin
              For n:=0 to 2 do
                If (RepPrintExcelTotals) or (n=0) then
                Begin
                  PrintEOYTot(n);
                end;
            end;
    end; {case..}

  end;

  If (Not (ReportMode In [4,5])) then
    Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJCCISReport1.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;


{ == Link to other records == }

Function LinkToVRecs  :  Boolean;

Var
  KeyJF      :  Str255;

Begin
  With MTExLocal^, CRepParam^, LJobDetl^.JobCISV do
  Begin
    KeyJF:=Strip('R',[#0],PartCCKey(JARCode,JASubAry[3])+FullEmpCode(Copy(CISvCode1,1,EmplKeyLen)));


    Result:=(LGetMainRec(JMiscF,KeyJF));


    If (Result) then
    Begin
      KeyJF:=FullCustCode(Copy(CISVSDate,1,CustKeyLen));

      If (KeyJF<>LCust.CustCode) then
        Result:=LGetMainRec(CustF,KeyJF);
    end;
  end;
end;

Begin

  TmpInclude:=BOff;
  REWeeks:=0; REMonths:=0;
  CSDate:=''; CEDate:='';

  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin

    Case ReportMode of
      1  :  With LJobMisc^.EmplRec do
            Begin
              TmpInclude:=(((CISType=RepType) or (RepType=0) or ShowER) or ((CISType=0) and QtyMode)) and (EType=2);

              If (ShowER) and (CISType<>4) and (TmpInclude) then
                TmpInclude:=(NoDays(Today,CertExpiry)<=ExpTol) and (CISType<>0) and (CertExpiry<>'') and (Not CIS340) ;
            end;

      2  :  TmpInclude:=BOn;


      3  :  With LJobMisc^.EmplRec do
            Begin

              TmpInclude:=(EType=2) and (Supplier<>'');

              If (TmpInclude) then
              Begin
                CSDate:=RepSDate; CEDate:=RepEDate;

                TmpInclude:=ContinuousEmploy(Supplier,CSDate,CEDate,REWeeks,REMonths);

              end;

            end;

      4,5
         :  With LJobDetl^.JobCISV do
            Begin

              If (CIS340) then
              Begin
                //PR: 18/07/2012 ABSEXCH-11799. Should be checking CISHTax rather than CISCType.
                //CRepParam^.RepType is 5 for High/Low tax and 6 for Zero tax.
                //CISHTax is 1 for High Tax, 4 for Low Tax, and 2 for Zero tax.

                // CJS 2013-04-09 - ABSEXCH-14053 - Unable to print single CIS Statements
                TmpInclude := ((CRepParam^.RepType in [4, 5]) and (CISHTax in [1, 4])) or ((CRepParam^.RepType = 6) and (CISHTax = 2));
              end
              else
                TmpInclude:=(CISCType=CRepParam^.RepType);


              If (KeyS>RepKey2) and (ReportMode=5) then
              Begin
                 KeyS:=NdxWeight;
                 B_Next:=B_GetGEq;
                 TmpInclude:=BOff;
               end;

               If (TmpInclude) then {Link to Employee and Supplier}
                 TmpInclude:=LinkToVRecs;
            end;
      20,21,25
         :
            Begin
              If (ThisScrt<>NIL) then {* Get Id Link *}
                ThisScrt^.Get_Scratch(LRepScr^);

              TmpInclude:=LinkToVRecs;
            end;
    end; {Case..}
  end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJCCISReport1.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With CRepParam^ do
  Begin

    Case ReportMode of

       1    :   Begin
                  ThTitle:='Sub-Contract Report';

                  RepTitle:='Sub-Contract Employee Report';

                  If (RepType>0) and (Not ShowER) then
                    RepTitle2:=CCCISName^+' Type : '+TxLate_CISTypeStr(RepType)
                  else
                    If (ShowER) then
                      RepTitle2:=CCCISName^+' Certificates expired, or due to expire in '+Form_Int(ExpTol,0)+' days.';

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoPortrait;

                  RFnum:=JMiscF;


                  Case SortOrd of
                    0   :  RKeyPath:=JMK;
                    1   :  RKeyPath:=JMSecK;
                    2   :  RKeypath:=JMTrdK;
                  end;

                  RepKey:=PartCCKey(JARCode,JASubAry[3]);

                  RepLen:=Length(RepKey);
                end;



       2    :   Begin
                  ThTitle:='Global Time Rates Report';

                  RepTitle:=ThTitle;

                  PageTitle:=RepTitle;

                  RFnum:=JCtrlF;

                  RKeyPath:=JCK;

                  RepKey:=PartCCKey(JBRCode,JBSubAry[3])+FullNomKey(PRateCode);

                  ERMode:=9;
                end;

       3    :   Begin
                  ThTitle:='Cont. Working Report';

                  RepTitle:='Sub-Contract Continuous Working Period Report';

                  RepTitle2:='List of Sub-Contract employees who have worked for more than '+Form_Int(ExpTol,0)+' ';

                  Case RepType of
                    0  :  RepTitle2:=RepTitle2+'month';
                    1  :  RepTitle2:=RepTitle2+'week';
                  end; {Case..}

                  If (ExpTol>1) then
                    RepTitle2:=RepTitle2+'s';


                  RepTitle2:=RepTitle2+' continuously between '+POutDate(RepSDate)+' - '+POutDate(RepEDate)+'.';

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoPortrait;

                  RFnum:=JMiscF;


                  Case SortOrd of
                    0   :  RKeyPath:=JMK;
                    1   :  RKeyPath:=JMSecK;
                    2   :  RKeypath:=JMTrdK;
                  end;

                  RepKey:=PartCCKey(JARCode,JASubAry[3]);
                  RepLen:=Length(RepKey);
                end;

       4,5  :   Begin
                  ThTitle:='Print '+GetIntMsg(4);

                  RFnum:=JDetlF;

                  RForm:=pfGetMultiFrmDefs(0).FormDefs.PrimaryForm[52+CISVTypeOrd(CRepParam^.RepType,BOff)];
                  
                  RUseForms:=BOn;

                  Case ReportMode of
                    4   :  Begin
                             RepKey:=RepKey1;
                             RKeypath:=JDStkK;
                             RepLen:=Length(RepKey);
                           end;
                    5   :  Begin
                             RepKey:=RepKey1;
                             RepKey2:=RepKey2+NdxWeight;
                             RKeypath:=RepKPath;
                             RepLen:=256;
                           end;
                  end;

                end;
       20,21,25
            :   Begin
                  ThTitle:='Contractor''s Return';

                  RepTitle:=ThTitle;


                  If (RepType=99) then
                    RepTitle2:='All'
                  else
                    RepTitle2:=CISVTypeName(RepType);


                  RepTitle2:=RepTitle2+' '+GetIntMsg(4)+'s between '+POutDate(RepSDate)+' - '+POutDate(RepEDate)+'.';

                  If (ReportMode=25) then
                  Begin
                    RepTitle:='Detailed '+RepTitle;
                    ROrient:=RPDefine.PoLandscape;

                  end
                  else
                    If (ReportMode=21) then
                      RepTitle:='RCT47/RCT48/RCT30 '+RepTitle;

                  If (Trim(JobFilt)<>'') then
                  Begin
                    Global_GetMainRec(CustF,FullCustCode(JobFilt));
                    RepTitle:=RepTitle+' for '+Trim(Cust.Company);
                  end
                  else
                    RepTitle:=RepTitle+'.';

                  PageTitle:=RepTitle;

                  RFnum:=ReportF;

                  RKeyPath:=RpK;
                end;


    end; {Case..}


  end; {With..}

  Result:=BOn;
end;


{ =========== Proc to Scan and Build Back Order Report ========= }

Procedure TJCCISReport1.Build_CISVouchers(Mode     :  Byte;
                                      Var AbortPrint
                                                   :  Boolean);


Const
  Fnum      =  JDetlF;



Var
  KeyS2,
  KeyChk,
  KeyChk2,
  MatchStr :  Str255;

  RecAddr  :  LongInt;

  Keypath  :  Integer;

  TmpInclude
           :  Boolean;



Begin

  MatchStr:='';

  RecAddr:=0;


  TmpInclude:=BOn;


  With MTExLocal^, CRepParam^ do
  Begin
    If (Trim(JobFilt)<>'') then
    Begin
      Keypath:=JDLookK;

      KeyChk:=CISPrefix+FullCustCode(JobFilt)+RepSDate;
      KeyChk2:=CISPrefix+FullCustCode(JobFilt)+RepEDate+NdxWeight;
    end
    else
    Begin
      Keypath:=JDEmpK;

      KeyChk:=CISPrefix+RepSDate;
      KeyChk2:=CISPrefix+RepEDate+NdxWeight;
    end;

    KeyS2:=KeyChk;


    ShowStatus(2,'Calculating Totals.');

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS2);

    While (LStatusOk) and (CheckKeyRange(KeyChk,KeyChk2,KeyS2,Length(KeyChk),BOff)) and (ChkRepAbort) do
    With LJobDetl^.JobCISV do
    Begin
      TmpInclude:=(CISCType=RepType) or (RepType=99);

      If (TmpInclude) then
      Begin
        LStatus:=LGetPos(Fnum,RecAddr);  {* Get Preserve IdPosn *}

                  {Voucher type}             {Supplier}              {CertNo}       {Date}
        MatchStr:=ECISType2Key(CISCType)+Copy(CISVSDate,1,CustKeyLen)+CISVCert+Copy(CISVCode2,1,LDateKeyLen);

        ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,MatchStr,'');

        If (AbortPrint) then
          AbortPrint:=BOff;

        If (CISvGrossTotal>0) and ((CISCType>=Low(VTots)) and (CISCType<=High(VTots))) then
        With VTots[CISCType] do
        Begin
          Gross:=Gross+Trunc(CISvGrossTotal);
          Materials:=Materials+Round_Up(CalcCISJDMaterial(LJobDetl^),0);
          Tax:=Tax+CISvTaxDue;
        end;
      end;

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS2);

    end; {While..}
  end;

end; {Proc..}



Procedure TJCCISReport1.Process;

Var
  AbortPrint   :  Boolean;

Begin
  AbortPrint:=BOff;
{$IFDEF EXSQL}
  if SQLUtils.UsingSQL then
    ReOpen_LocalThreadfiles;
{$ENDIF}

  If (ReportMode in [20,21,25]) then
    New(ThisScrt,Init(21,MTExLocal,BOff));

  Try
    If (ReportMode in [20,21,25]) then
    Begin
      RepKey:=FullNomKey(ThisScrt^.Process);

      InitStatusMemo(4);

      ShowStatus(0,RepTitle);

      Build_CISVouchers(ReportMode,AbortPrint);

    end;

    Inherited Process;

  Finally
    If (Assigned(ThisScrt)) then
    Begin
      Dispose(ThisScrt,Done);
      ThisScrt:=nil;
    end;
  end;




end;


Procedure TJCCISReport1.Finish;


Begin
  If (ReportMode In [4,5]) and (UpdateCISSys) then
  With SyssCIS^.CISRates, CRepParam^ do
  Begin
    With CISVouchers[RepType] do
    Begin
      Prefix:=JobFilt;
      Counter:=CISCount;
    end;

    {* Inform input window to update sys counter *}

    SendMessage(TForm(fMyOwner).Handle,WM_FormCloseMsg,68,RepType);

  end;

  Inherited Finish;
end;


{ ======== }



Procedure AddCISListRep2Thread(LMode    :  Byte;
                               IRepParam:  JobCRep1Ptr;
                               AOwner   :  TObject);


Var
  EntTest  :  ^TJCCISReport1;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        If (Assigned(IRepParam)) then
          CRepParam^:=IRepParam^;


        If (Create_BackThread) and (Start) then
        Begin
          With BackThread do
            AddTask(EntTest,ThTitle);
        end
        else
        Begin
          Set_BackThreadFlip(BOff);
          Dispose(EntTest,Destroy);
        end;
      end; {with..}

    except
      Dispose(EntTest,Destroy);

    end; {try..}
  end; {If process got ok..}

end;





Initialization



Finalization

end.
