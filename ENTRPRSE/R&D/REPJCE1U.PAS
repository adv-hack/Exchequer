unit RepJCE1U;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,BtrvU2,ETMiscU, BTSupU3,ExBtTh1U,ReportU;


type



  TJCEListReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                     private
                       ERMode  :  Byte;

                       Procedure RepSetValTabs;

                       Procedure RepPrintPageHeader2;

                       Procedure StkEnd;

                       Function StkInclude  :  Boolean;

                       Procedure StkLine;

                       Procedure PrintValDetail;

                       Procedure PrintStockTot(GMode     :  Byte);

                       Procedure CalcStkTotals(StkVal,
                                               QtyVal    :  Real);

                       Function GetReportInput  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                     public

                       CRepParam  :  JobCRep1Ptr;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

                   
Procedure AddEmpListRep2Thread(LMode    :  Byte;
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

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}

  SalTxl1U,
  JobSup1U,
  RpDefine,
  ExThrd2U;


{ ========== TSListReport methods =========== }

Constructor TJCEListReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  ERMode:=0;
end;


Destructor TJCEListReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;





Procedure TJCEListReport.RepSetValTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ERMode of

        9 :  Begin
              SetTab (MarginLeft, pjLeft, 26, 4, 0, 0);
              SetTab (NA, pjLeft, 43, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
             end;

        10:  Begin
             end;

    end; {Case..}
  end; {With..}
end;



Procedure TJCEListReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        1 :  Begin
              SetTab (MarginLeft, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 46, 4, 0, 0);

              SetTab (NA, pjLeft, 20, 4, 0, 0);

              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 46, 4, 0, 0);
              SetTab (NA, pjLeft, 20, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);

            end;

        2 :  Begin
               RepSetValTabs;
             end;


    end; {Case..}
  end; {With..}

  SetTabCount;
end;



Procedure TJCEListReport.RepPrintPageHeader2;


Begin
  RepSetValTabs;

  With RepFiler1,CRepParam^ do
  Begin
    DefFont(0,[fsBold]);

    Case ERMode of

      9
          :  Begin
               SendLine(ConCat(#9'Time',' ','Rate',#9,'Description',#9,'Time Cost',#9,'Time Charge'));

               DefLine(-1,TabStart(1),TabEnd(4),0);
             end;



      10
          :  Begin
             end;

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





  { ======================= Due End ======================= }


  Procedure TJCEListReport.StkEnd;

  Var
    KitEnd     :  Str255;

    n,m        :  Byte;

  Begin

    With RepFiler1, CRepParam^ do
    Begin

      Case ERMode of

        9,10   :  Begin
                    // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
                    Self.CRLF;

                    RepSetTabs;

                  end;
      end; {Case..}
    end; {With..}
  end;




  { ======================= Due Include ======================= }


  Function TJCEListReport.StkInclude  :  Boolean;


  Var
    TmpInclude :  Boolean;
    DayRepInc  :  Boolean;

    ChkRecon   :  Byte;

    KeyS2      :  Str255;


  Begin
    TmpInclude := False;
    {$B-}

    With MTExLocal^, CRepParam^, RepFiler1 do
    Begin
      Case ERMode of

          9
               :
                  Begin

                    TmpInclude:=BOn;

                  end;


        end; {Case..}



      end; {With..}

      {$B+}



      StkInclude:=TmpInclude;
  end; {Func..}


  { ======================= Due Line ======================= }


  Procedure TJCEListReport.StkLine;


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
           :  With LJobCtrl^.EmplPay do
              Begin
                {$IFDEF EXSQL}
                if SQLUtils.UsingSQL then
                  PayRDesc:=LGet_StdPRDesc(EStockCode,JCtrlF,JCK,-1)
                else
                {$ENDIF}
                  PayRDesc:=Get_StdPRDesc(EStockCode,JCtrlF,JCK,-1);


                SendLine(ConCat(#9,EStockCode,
                         #9,PayRDesc,
                         #9,FormatCurFloat(GenUnitMask[BOff],Cost,BOff,CostCurr),
                         #9,FormatCurFloat(GenRealMask,ChargeOut,BOff,ChargeCurr)));


              end;

      
      end; {Case..}

    end; {With(s)..}
  end;



Procedure TJCEListReport.PrintValDetail;



Const
  Fnum       =  JCtrlF;
  Keypath    =  JCK;


Var
  KeyCS,
  KeyChk     :  Str255;

  NewLine    :  Boolean;

  Rnum       :  Real;


Begin

  Rnum:=0;

  NewLine:=BOn;


  With MTExLocal^,CRepParam^ do
  Begin
    ERMode:=9;

    Case ERMode of

      9  :  KeyChk:=PartCCKey(JBRCode,JBSubAry[4])+LJobMisc^.EmplRec.EmpCode;

   end; {Case..}

    KeyCS:=KeyChk;

    LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyCS);

    While (LStatusOk) and (Checkkey(KeyChk,KeyCS,Length(KeyChk),BOn)) and (ChkRepAbort) do
    With CRepParam^ do
    Begin

      If (StkInclude) then
      Begin
        If (NewLine) then
          RepPrintPageHeader2;

        NewLine:=BOff;

        StkLine;
      end;

      With RepFiler1 do
        If (LinesLeft<5) then
          ThrowNewPage(5);

      LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyCS);

    end; {While..}

    If (Not NewLine) then
      StkEnd;

    ERMode:=0;
    RepSetTabs;
  end; {With..}
end; {Proc..}



Procedure TJCEListReport.RepPrintPageHeader;


Begin

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      1
          :  SendLine(ConCat(#9,'Code',#9,'Name',#9,'NI No.',#9,'Payroll',#9,'Company',#9,'Type',
                      #9,'CC/Dep'));

      2   :  SendLine(ConCat(#9'Time',' ','Rate',#9,'Description',#9,'Time Cost',#9,'Time Charge'))



    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TJCEListReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

  With MTExLocal^, RepFiler1 do
  Case ReportMode of
      1  :  If (CurrentPage>1) then
              PrintEmplLine(LJobMisc^.EmplRec.EmpCode,BOn);


  end; {Case..}

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TJCEListReport.CalcStkTotals(StkVal,
                                     QtyVal    :  Real);

Var
  nBo        :  Boolean;
  Rnum       :  Real;

Begin

  Rnum:=0;

  With CRepParam^ do
    Case ReportMode of

        4  :  Begin


              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TJCEListReport.PrintStockTot(GMode     :  Byte);

Var
  n          :  Byte;


Begin


  With RepFiler1, CRepParam^ do
  Case ReportMode of
    1  :  Begin
            DefFont(0,[fsBold]);



            DefFont(0,[]);

          end; {Case..}

  end; {Case..}

end;




Procedure TJCEListReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    Case ReportMode of
      1  :  With LJobMisc^.EmplRec do
            Begin
              SendRepDrillDown(1,TotTabs,1,PartCCKey(JARCode,JASubAry[3])+FullEmpCode(EmpCode),JMiscF,JMK,0);
              SendRepDrillDown(5,5,2,FullCustCode(Supplier),CustF,CustCodeK,0);
            end;

    end; {Case..}
  end; {With..}
end;





{ ======================= Customer Line ======================= }


Procedure TJCEListReport.PrintReportLine;

Var
  GenStr     :  Str255;


Begin


  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin

    GenStr:='';

    SetReportDrillDown(0);

    With LJobMisc^.EmplRec do
    Case ReportMode of
      1  :  Begin
              LGetMainRec(CustF,Supplier);

              GenStr:=CCDep[BOn];

              If (GenStr<>'') and (CCDep[BOff]<>'') then
                GenStr:=GenStr+'/';

              GenStr:=GenStr+CCDep[BOff];

              SendLine(ConCat(#9,EmpCode,
                       #9,EmpName,

                       #9,ENINo,
                       #9,PayNo,
                       #9,LCust.Company,
                       #9,EmplTDescL^[EType],
                       #9,GenStr));

              If (ShowER) then
              Begin
                PrintValDetail;
              end;

            end;

      2  :  Begin
              ERMode:=9;

              StkLine;
            end;




    end; {Case..}



  end;
end;


{ ======================= Customer End ======================= }


Procedure TJCEListReport.PrintEndPage;
Var

  n  :  Byte;


Begin
  With RepFiler1 do
  Begin


  end;

  Inherited PrintEndPage;
end;





{ ======================= Customer Include ======================= }


Function TJCEListReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;

Begin

  TmpInclude:=BOff;


  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin

    Case ReportMode of

          1  :  With LJobMisc^.EmplRec do
                  TmpInclude:=((EType=RepType) or (RepType=0));

          2  :  TmpInclude:=BOn;


        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TJCEListReport.GetReportInput  :  Boolean;

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
                  ThTitle:='Employee Report';

                  RepTitle:='Employee Report';

                  If (RepType>0) then
                    RepTitle2:='Employee Type : '+EmplTDescL^[RepType];

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

    end; {Case..}


  end; {With..}

  Result:=BOn;
end;




Procedure TJCEListReport.Process;

Begin
  Inherited Process;

end;


Procedure TJCEListReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddEmpListRep2Thread(LMode    :  Byte;
                               IRepParam:  JobCRep1Ptr;
                               AOwner   :  TObject);


Var
  EntTest  :  ^TJCEListReport;

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