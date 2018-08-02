unit RepJCE3U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,SCRTCH2U,ReportU,
  RepJCE2U;


type



  TJCCISReport2  =  Object(TJCCISReport1)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                     private
                       Procedure RepSetValTabs; Virtual;

                       Procedure PrintEOYTot(GMode     :  Byte); Virtual;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


Procedure AddCISListRep3Thread(LMode    :  Byte;
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

  CISSup1U,
  JChkUseU,
  RpDefine,
  ExThrd2U;


{ ========== TSListReport methods =========== }

Constructor TJCCISReport2.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

end;


Destructor TJCCISReport2.Destroy;

Begin
  Inherited Destroy;
end;




Procedure TJCCISReport2.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ERMode of

        9 :  Begin
              SetTab (MarginLeft+20, pjLeft, 29, 4, 0, 0);
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




Procedure TJCCISReport2.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of


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
               SetTab (NA, pjLeft, 30, 4, 0, 0);
               SetTab (NA, pjLeft, 10, 4, 0, 0);
               SetTab (NA, pjLeft, 30, 4, 0, 0);
               SetTab (NA, pjRight,29, 4, 0, 0);
               SetTab (NA, pjRight,29, 4, 0, 0);
               SetTab (NA, pjRight,29, 4, 0, 0);


             end;



    end; {Case..}

    SetTabCount;
  end; {With..}


end;



Procedure TJCCISReport2.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of


      20,21
          :  Begin
               SendLine(ConCat(#9,'Contractor''s UTR : ',SyssCIS340^.CIS340.CISCUTR,'.',#9,'A/C Office Ref :',SyssCIS340^.CIS340.CISACCONo));

               SendLine(ConCat(#9,'Subcontractors''s Name',#9,'CTR',#9,'Total payments made',
                               #9,'Cost of materials used',#9,'Total Tax deducted'));

             end;

      25
          :  Begin
               SendLine(ConCat(#9,'Contractor''s UTR : ',SyssCIS340^.CIS340.CISCUTR,'.',#9,'A/C Office Ref :',SyssCIS340^.CIS340.CISACCONo));


               SendLine(ConCat(#9,'Subcontractors''s Name',#9,'Employee Name',#9,'Statement Ref',#9,'UTR',#9,'H.Tax',#9,'Verification',
                               #9,'Total payments',#9,'Cost materials used',#9,'Total Tax deducted'));

             end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}










{ ======================= Due Sub / Grand Total ================ }

Procedure TJCCISReport2.PrintEOYTot(GMode     :  Byte);

Var
  n,TM       :  Byte;

  ShowTot    :  Totals;


Begin


  With RepFiler1, CRepParam^, MTExLocal^ do
  Case ReportMode of
    20,21,25

       :  Begin
            TM:=(4*Ord(ReportMode=25));

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
                        DefLine(-1,TabStart(4),TabEnd(05+TM),0);
                        DefFont(0,[fsBold]);


                        SendText(ConCat(ConstStr(#9,2+TM),'Totals: ',LCust.Company));
                      end;

                    end;
              1  :  Begin
                      ShowTot:=StkTot;
                      DefLine(-1,TabStart(4),TabEnd(05+TM),0);
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


{ ======================= Customer Line ======================= }


Procedure TJCCISReport2.PrintReportLine;

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

      If (ReportMode=25) then
        SetReportDrillDown(0);


      Case ReportMode of

      25   :  With LJobDetl^.JobCISV do
              Begin
                If (PrintNames) then
                  GenStr:=ConCat(#9,LCust.Company,#9,EmpName)
                else
                  GenStr:=#9+#9;

                SendLine(ConCat(GenStr,
                         #9,CISCertNo,
                         #9,UTRCode,
                         #9,YesNoBlnk(CISHTax=1),
                         #9,CISVERNo,
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



Procedure TJCCISReport2.PrintEndPage;
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

  TGenReport.PrintEndPage;
end;



Function TJCCISReport2.GetReportInput  :  Boolean;

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


       20,21,25
            :   Begin
                  ThTitle:='Contractor''s Return';

                  RepTitle:=ThTitle;


                  If (RepType=99) then
                    RepTitle2:='All'
                  else
                    RepTitle2:=CISVTypeName(RepType);


                  RepTitle2:=RepTitle2+' CIS Tax Statements between '+POutDate(RepSDate)+' - '+POutDate(RepEDate)+'.';

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




Procedure TJCCISReport2.Process;


Begin
  Inherited Process;

end;


Procedure TJCCISReport2.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddCISListRep3Thread(LMode    :  Byte;
                               IRepParam:  JobCRep1Ptr;
                               AOwner   :  TObject);


Var
  EntTest  :  ^TJCCISReport2;

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