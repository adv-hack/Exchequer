unit ReportJU;


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type


    MBRRepPtr     =  ^MBRRepParam;

    MBRRepParam   =  Record

                     ReconCode :  LongInt;

                     RepTotal  :  Totals;

                     RCr,
                     RepMode   :  Byte;

                     OBal      :  Real;

                     PrintOBal :  Boolean;

                     KeyChk    :  Str255;

                     BankMCtrl :  PassWordRec;
		   end;



  TBankRReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private

                       Procedure CalcDueTotals(CrDr      :  DrCrType);

                       Procedure PrintDueTot;

                       Function GetReportInput  :  Boolean; Virtual;

                     public

                       CRepParam  :  MBRRepPtr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}


 Procedure AddBankRecRep2Thread(LMode    :  Byte;
                                IRepParam:  MBRRepPtr;
                                AOwner   :  TObject);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  Dialogs,
  Forms,
  Printers,
  RpDefine,
  TEditVal,
  ETDateU,
  ETStrU,
  BTKeys1U,
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  BankRCSU,
  SalTxl1U,
  ExThrd2U;



{ ========== TBankRReport methods =========== }

Constructor TBankRReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

end;


Destructor TBankRReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TBankRReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1
          :  Begin
              SetTab (MarginLeft, pjLeft, 40, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
            end;

        2
          :  Begin
              SetTab (MarginLeft, pjLeft, 50, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjLeft, 50, 4, 0, 0);
            end;

    end; {Case..}
  end; {With..}
end;







Procedure TBankRReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  Begin
               SendLine(ConCat(#9,'Reference',#9,'Payments',#9,'Receipts',#9,
                    'Balance',#9,'Status',#9,'Operator'));
            end;

      2
          :  Begin
               SendLine(ConCat(#9,'Reference',#9,'Cash Book Entries',#9,'Statement Entries',#9,
                    'Details'));
            end;


    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TBankRReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);


end;




{ ======================= Calculate Due Totals ==================== }

Procedure TBankRReport.CalcDueTotals(CrDr      :  DrCrType);


Var
  n          :  Byte;

Begin
  With CRepParam^ do
    Case ReportMode of
        1,2
           :  Begin

                For n:=1 to 2 do
                  RepTotal[n]:=RepTotal[n]+CrDr[(n=2)];

              end;
      end; {Case..With..}
end;




{ ======================= Due Sub / Grand Total ================ }

Procedure TBankRReport.PrintDueTot;

Var
  Rnum       :  Real;

  Dnum1,
  Dnum2,
  Dnum3      :  Double;


Begin

  With MTExLocal^, CRepParam^, RepFiler1 do
  Begin

    DefFont(0,[fsBold]);

    DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

    Case ReportMode of

          1
             :  Begin


                  If (RepMode=1) then
                    Dnum3:=(RepTotal[1]-RepTotal[2])*DocNotCnst
                  else
                    Dnum3:=0;

                  Dnum1:=Reptotal[1];
                  Dnum2:=RepTotal[2];

                  SendLine(ConCat(#9,'Totals:',#9,FormatFloat(GenRealMask,Dnum1),
                          #9,FormatFloat(GenRealMask,Dnum2),
                          #9,FormatFloat(GenRealMask,Dnum3)));
                end; {Case..}

          2
             :  Begin

                  Dnum3:=(RepTotal[1]-RepTotal[2]);

                  If (ABS(RepTotal[1])<ABS(RepTotal[2])) then
                    Dnum3:=Dnum3*DocNotCnst;

                  Dnum1:=Reptotal[1];
                  Dnum2:=RepTotal[2];

                  ClearTabs;
                  SetTab (MarginLeft, pjLeft, 50, 4, 0, 0);
                  SetTab (NA, pjRight, 30, 4, 0, 0);
                  SetTab (NA, pjRight, 30, 4, 0, 0);
                  SetTab (NA, pjRight, 30, 4, 0, 0);

                  SendLine(ConCat(#9,'Totals:',#9,FormatFloat(GenRealMask,Dnum1),
                          #9,FormatFloat(GenRealMask,Dnum2),
                          #9,FormatFloat(GenRealMask,Dnum3)));

                end; {Case..}



    end; {Case..With..}

    DefFont(0,[]);

  end; {With..}
end;



{ ======================= Customer End ======================= }


Procedure TBankRReport.PrintEndPage;
Var

  n        :  Byte;
  FoundOk  :  Boolean;


Begin
  With RepFiler1 do
  Begin

    PrintDueTot;

  end;

  Inherited PrintEndPage;


end;


Procedure TBankRReport.PrintReportLine;


Var
  Rnum       :  Real;
  Dnum1,
  Dnum2,
  Dnum3      :  Double;

  CrDr       :  DrCrType;

  GenStr     :  Str255;

  UOn1,
  UOn2       :  Str20;

  TmpMRec    :  ^MiscRec;



Begin
  Rnum:=0;

  Blank(CrDr,Sizeof(CrDr));

  UOn1:='';
  UOn2:='';

  With MTExLocal^, RepFiler1, CRepParam^, LMiscRecs^.BankMRec do
  Begin

     If (Not PrintOBal) then
     Begin
       PrintOBal:=bOn;

       New(TmpMRec);

       TmpMRec^:=LMiscRecs^;

       LResetRec(MiscF);

       BankRef:='Opening Cleared Balance';

       BankValue:=OBal;

       PrintReportLine;

       LMiscRecs^:=TmpMRec^;

       Dispose(TmpMRec);

     end;


     Case ReportMode of
       1
          :
             Begin

               ShowDrCr(BankValue,CrDr);

               CalcDueTotals(CrDr);

               If (RepMode=1) then
                 Dnum3:=(RepTotal[1]-RepTotal[2])*DocNotCnst
               else
                 Dnum3:=0;

               Dnum1:=CrDr[BOff];

               Dnum2:=CrDr[BOn];

               GenStr:=BankMEStatus(EntryStat,BOn)+FullOurRefKey(MatchDoc);

               
               SendLine(ConCat(#9,BankRef,
                               #9,FormatBFloat(GenRealMask,Dnum1,BOn),
                               #9,FormatBFloat(GenRealMask,Dnum2,BOn),
                               #9,FormatBFloat(GenRealMask,Dnum3,BOn),
                               #9,GenStr,
                               #9,EntryOpo));

               If (EntryStat>1) then
               Begin
                 DefLine(-1,1,PageWidth-MarginRight-1,-0.1);
               end;

             end;

      2
          :
             Begin

               Blank(CrDr,Sizeof(CrDr));

               CrDr[(EntryStat=2)]:=BankValue;


               If (Tagged) then
                 CalcDueTotals(CrDr);

               Dnum1:=CrDr[BOff];

               Dnum2:=CrDr[BOn];

               GenStr:=PoutDate(EntryDate);

               If (EntryStat=1) then
               Begin
                 GenStr:=GenStr+' '+MatchDoc;
               end
               else
               Begin
                 GenStr:=GenStr+Spc(10);
               end;

               If (Tagged) then
                 GenStr:=GenStr+' *';

               
               SendLine(ConCat(#9,BankRef,
                               #9,FormatBFloat(GenRealMask,Dnum1,BOn),
                               #9,FormatBFloat(GenRealMask,Dnum2,BOn),
                               #9,GenStr));
                               
               If (EntryStat=2) then
               Begin
                 DefLine(-1,1,PageWidth-MarginRight-1,-0.1);
               end;

             end;


     end; {Case..}



   end; {With(s)..}
end;




{ ======================= Customer Include ======================= }


Function TBankRReport.IncludeRecord  :  Boolean;

Var
  TmpInclude,
  TBo        :  Boolean;


Begin
  TmpInclude:=BOff;

  TBo:=BOff;


  With MTExLocal^, CRepParam^ do
  Begin


    Case ReportMode of

      1
           :  With LMiscRecs^.BankMRec do
              Begin

                  TmpInclude:=((RepMode=1)
                             or ((EntryStat>1) and (RepMode=2))
                             or ((EntryStat=1) and (RepMode=3))
                             or ((EntryStat=0) and (RepMode=4)));

              end;
      2    :  TmpInclude:=BOn;


    end; {Case..}
  end; {With..}

  Result:=TmpInclude;

end; {Func..}






Function TBankRReport.GetReportInput  :  Boolean;

Const
  RepFiltTit :  Array[0..4] of Str10  =  ('','All','Unmatched','Matched','New');


Var
  BoLoop
     :  Boolean;
  n  :  Integer;


Begin
  With CRepParam^ do
  Begin

    RFont.Size:=8;
    ROrient:=RPDefine.PoPortrait;


    Case ReportMode of

       1
            :   Begin

                  ThTitle:='G/L Bank Rec Rep';

                  RepTitle:='Auto G/L Reconciliation Matching';
                  PageTitle:='Automatic General Ledger Reconciliation Matching';

                  PrintOBal:=(RepMode<>1);

                end;
       2
            :   Begin
                  ThTitle:='G/L Bank Rec Rep';

                  RepTitle:='Manual Reconciliation Matching';
                  PageTitle:=RepTitle;

                  PrintOBal:=BOn;



                end;


    end; {Case..}


    If (Nom.NomCode<>ReconCode) then
      Global_GetMainRec(NomF,FullNomKey(ReconCode));


    With BankMCtrl.BankCRec do
    Begin
      With Nom do
        RepTitle2:=dbFormatName(Form_Int(NomCode,0),Desc)+'. Started '+PoutDate(EntryDate);

       RepTitle2:=RepTitle2+' by '+ReconOpo;

      {$IFDEF MC_On}

        RepTitle2:=CurrDesc(RCr)+'.'+RepTitle2;

      {$ENDIF}

    end; {With..}

    If (ReportMode=1) then
      PageTitle:=PageTitle+'. ('+RepFiltTit[RepMode]+' Entries)';


  end; {With..}

  Result:=BOn;
end;





Procedure TBankRReport.Process;


Begin
  RFnum:=MiscF;

  RKeyPath:=MIK;

  RepKey:=CRepParam^.KeyChk;

  Inherited Process;

end;


Procedure TBankRReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddBankRecRep2Thread(LMode    :  Byte;
                               IRepParam:  MBRRepPtr;
                               AOwner   :  TObject);


Var
  EntTest  :  ^TBankRReport;

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