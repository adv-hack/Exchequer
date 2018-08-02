unit RepAlcU;

{$I DEFOVR.Inc}


interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  StdCtrls,ExtCtrls,Grids,
  GlobVar,VarConst,VarRec2U, BtrvU2,ETMiscU, BTSupU3,ExBtTh1U, SBSOutl,ReportU;


type



  TAllocReport  =  Object(TGenReport)

                       Procedure RepSetTabs; Virtual;

                       Procedure RepPrintPageHeader; Virtual;

                       Procedure RepPrintHeader(Sender  :  TObject); Virtual;

                       Function Link2Inv(ORef  :  Str20)  :  Boolean;

                     private
                       RepTotal    :  Totals;
                       AllocTrans  :  Str50;
                       TheOutLine  :  TSBSOutlineB;

                       Procedure CalcDueTotals(Var TTot,PTot      :  Totals);

                       Procedure PrintDueTot;

                       Function GetReportInput  :  Boolean; Virtual;

                       procedure Print_UOutLine;

                     public

                       CRepParam  :  ^AllocCType;

                       Constructor Create(AOwner  :  TObject);

                       Destructor  Destroy; Virtual;

                       function IncludeRecord  :  Boolean; Virtual;

                       Procedure SetReportDrillDown(DDMode  :  Byte); Virtual;

                       Procedure PrintReportLine; Virtual;

                       Procedure PrintEndPage; Virtual;

                       Procedure Process; Virtual;
                       Procedure Finish;  Virtual;

                   end; {Class..}

Procedure AddAllocRep2Thread(LMode      :  Byte;
                             IRepParam  :  MLocRec;
                             MyOutLine  :  TSBSOutlineB;
                             AOwner     :  TObject);


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
  ComnUnit,
  ComnU2,
  CurrncyU,
  SysU1,
  SysU2,
  BTSupU1,
  {InvListU,}
  {RevalU2U,}
  SalTxl1U,

  IntMU,

  {DocSupU1,}
  AllocS1U,
  BPyItemU,
  RpDefine,
  ExThrd2U;


{ ========== TBatchReport methods =========== }

Constructor TAllocReport.Create(AOwner  :  TObject);

Begin
  Inherited Create(AOwner);

  New(CRepParam);

  FillChar(CRepParam^,Sizeof(CRepParam^),0);

  FillChar(RepTotal,Sizeof(RepTotal),0);

  TheOutLine:=Nil;
end;


Destructor TAllocReport.Destroy;

Begin
  Dispose(CRepParam);

  Inherited Destroy;
end;



Procedure TAllocReport.RepSetTabs;

Begin
  With RepFiler1 do
  Begin
    ClearTabs;

    Case ReportMode of

        7
         :  Begin
              SetTab (MarginLeft, pjLeft, 24, 4, 0, 0);
              SetTab (NA, pjLeft, 28, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjLeft, 17, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjLeft, 30, 4, 0, 0);

            end;
       12,15
         :  Begin
              SetTab (MarginLeft+10, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);
              SetTab (NA, pjRight, 30, 4, 0, 0);
              SetTab (NA, pjRight, 29, 4, 0, 0);

            end;

    end; {Case..}
  end; {With..}

  SetTabCount;
end;

Procedure TAllocReport.RepPrintPageHeader;

Var
  GenStr  :  Str255;

Begin
  {$IFDEF MC_On}
    GenStr:='Variance'+#9+'Total Settled'+#9+'Settled Base';

  {$ELSE}

    GenStr:=#9+'Total Settled'+#9;

  {$ENDIF}

  With RepFiler1,CRepParam^ do
  Begin
    RepSetTabs;

    DefFont(0,[fsBold]);

    Case ReportMode of

      7,8
          :  SendLine(ConCat(#9'Doc',' ','Ref',#9,'Your',' ','Ref',#9,'Date',#9,'Date',' ','Due',#9,'Outstanding',#9,
                       'S.Disc',#9,GenStr,#9,'Status'));

      12,15
          :  SendLine('OutLine Page Header');

    end; {case..}

    DefFont(0,[]);
  end; {With..}
end; {Proc..}





Procedure TAllocReport.RepPrintHeader(Sender  :  TObject);


Begin
  Inherited RepPrintHeader(Sender);

end;




{ ======================= Calculate Due Totals ==================== }

Procedure TAllocReport.CalcDueTotals(Var TTot,PTot      :  Totals);



Var
  nBo        :  Boolean;
  n          :  Byte;
  Rnum       :  Real;

Begin

  Rnum:=0;

  With CRepParam^ do
    Case ReportMode of
      7,8  :  Begin

                For n:=1 to NoTotals do
                Begin

                  RepTotal[n]:=RepTotal[n]+Ttot[n];

                end;

              end;

    end; {Case..With..}
end;






{ ======================= Due Sub / Grand Total ================ }

Procedure TAllocReport.PrintDueTot;

Var
  n          :  Byte;


Begin


  With RepFiler1, CRepParam^ do
  Case ReportMode of
    7,8
       :  Begin
            DefFont(0,[fsBold]);

            DefLine(-1,TabStart(4),TabEnd(10),0);

            SendLine(ConCat(ConstStr(#9,4),'Total : ',#9,FormatCurFloat(GenRealMask,RepTotal[1],BOn,arcPayCurr)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[2],BOn,arcPayCurr)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[3],BOff,0)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[4],BOff,arcPayCurr)
            ,#9,FormatCurFloat(GenRealMask,RepTotal[5],BOn,0)));

            DefLine(-2,TabStart(4),TabEnd(10),0);

            DefFont(0,[]);

          end; {Case..}

    12
       :  Begin
            RepSetTabs;
            DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

            SendLine('');

            DefFont(0,[fsBold]);

            SendLine(ConCat(#9,'Total  Debit: ',#9,FormatFloat(GenRealMask,arcOwnTransValue)
            ,#9,'Total Credit: ',#9,FormatFloat(GenRealMask,arcOwnSettleD)));

            DefFont(0,[]);

            DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

          end; {Case..}

    15
       :  Begin
            RepSetTabs;
            DefLine(-2,1,PageWidth-MarginRight-1,-0.5);

          end; {Case..}

  end; {Case..}

end;



Procedure TAllocReport.SetReportDrillDown(DDMode  :  Byte);

Begin
  With MTExLocal^ do
  Begin
    SendRepDrillDown(1,TotTabs,1,LInv.OurRef,InvF,InvOurRefK,0);
  end; {With..}
end;



{ ======================= Customer Line ======================= }


Procedure TAllocReport.PrintReportLine;

Var
  Rnum,
  Rnum2,
  Rnum3,
  Rnum4
             :  Double;
  PTot,
  TTot       :  Totals;

  DetLink    :  Str10;

  GenStr     :  Str255;


Begin

  With MTExLocal^, RepFiler1, CRepParam^ do
  Begin
    Rnum:=0; Rnum2:=0.0;  Rnum3:=0.0; Rnum4:=0.0;

    Blank(PTot,Sizeof(PTot));

    Blank(TTot,Sizeof(TTot));

    GenStr:='';

    With LInv,LMiscRecs.AllocSRec do
    Case ReportMode of
      7,8
        :  Begin

              Case ReportMode of
                7  :  With LInv do
                      Begin

                        Rnum:=ariOutStanding;
                        Rnum2:=ariOrigSetDisc;
                        Rnum3:=ariVariance;
                        Rnum4:=ariSettleOwn;

                        TTot[5]:=ariSettle*DocCnst[LInv.InvDocHed]*DocNotCnst;

                        Rnum:=Rnum*DocCnst[LInv.InvDocHed]*DocNotCnst;

                        Rnum2:=Rnum2*DocCnst[Inv.InvDocHed]*DocNotCnst;
                        Rnum3:=Rnum3*DocCnst[Inv.InvDocHed]*DocNotCnst;
                        Rnum4:=Rnum4*DocCnst[Inv.InvDocHed]*DocNotCnst;

                      end;

              end; {Case..}



              TTot[1]:=Rnum;

              TTot[2]:=Rnum2;
              TTot[3]:=Rnum3;
              TTot[4]:=Rnum4;


              GenStr:=DisplayHold(HoldFlg);



             {Rnum:=Rnum*DocCnst[InvDocHed]*DocNotCnst;}

             SetReportDrillDown(0);

             SendLine(ConCat(#9,OurRef,
                             #9,YourRef,
                             #9,POutDate(TransDate),
                             #9,POutDate(DueDate),
                             #9,FormatCurFloat(GenRealMask,RNum,BOff,arcPayCurr),
                             #9,FormatCurFloat(GenRealMask,RNum2,BOn,arcPayCurr),
                             #9,FormatCurFloat(GenRealMask,RNum3,BOn,0),
                             #9,FormatCurFloat(GenRealMask,RNum4,BOff,arcPayCurr),
                             #9,FormatCurFloat(GenRealMask,TTot[5],BOff,0),
                             #9,GenStr));



            end;


    end; {Case..}


    CalcDueTotals(TTot,PTot);
  end;
end;


{ ======================= Customer End ======================= }


Procedure TAllocReport.PrintEndPage;
Var

  n          :  Byte;

  Rnum,
  Rnum2
             :  Double;

  TmpMR      :  MLocRec;

Begin
  If (ReportMode In [7,8]) then
  With RepFiler1, CRepParam^ do
  Begin

    TmpMR.AllocCRec:=CRepParam^;

    PrintDueTot;

    SendLine('');

    Rnum:=Round_Up(Calc_arcUnallocated(TmpMR,BOff),2);

    If (Rnum<>0.0) then
      Rnum2:=Round_Up(Calc_arcUnallocated(TmpMR,BOn),2)
    else
      Rnum2:=0.0;

    DefFont(0,[fsBold]);

    SendLine(ConCat(ConstStr(#9,3),BatchPTit(arcSalesMode),#9,'Total :',#9,
             FormatCurFloat(GenRealMask,arcOwnTransValue,BOff,arcPayCurr),#9,
             FormatCurFloat(GenRealMask,arcTransValue,BOff,0),#9,'Unallocated:',#9,
             FormatCurFloat(GenRealMask,Rnum,BOff,arcPayCurr),#9,
             FormatCurFloat(GenRealMask,Rnum2,BOff,0)));

  end
  else
    If (ReportMode In [12,15]) and (Assigned(TheOutLine)) then
    Begin
      Print_UOutLine;
      PrintDueTot;

    end;


  Inherited PrintEndPage;
end;


Function TAllocReport.Link2Inv(ORef  :  Str20)  :  Boolean;

Var
  KeyI  :  Str255;

Begin
  With MTExLocal^ do
  Begin
    If (LInv.OurRef<>ORef) then
    Begin
      KeyI:=ORef;
      LStatus:=LFind_Rec(B_GetEq,InvF,InvOurRefK,KeyI);

      Result:=LStatusOk;
    end
    else
      Result:=BOn;

  end;
end;




{ ======================= Line Include ======================= }


Function TAllocReport.IncludeRecord  :  Boolean;


Var
  TmpInclude :  Boolean;

Begin

  TmpInclude:=BOff;

  {$B-}

  With MTExLocal^, CRepParam^ do
  Begin


    Case ReportMode of

          7
             :  With LMiscRecs^.AllocSRec do
                Begin

                  TmpInclude:=(ariTagMode<>0) and (Link2Inv(ariOurRef));


                end;

         12,15
             :  TmpInclude:=BOff;


        end; {Case..}
    end;{With..}

  {$B+}

  Result:=TmpInclude;

end; {Func..}






Function TAllocReport.GetReportInput  :  Boolean;

Var
  BoLoop
     :  Boolean;
  n  :  Integer;

  FoundCode
     :  Str20;


Begin
  With Cust, CRepParam^ do
  Begin

    If (arcCustCode<>Cust.CustCode) then
      Global_GetMainRec(CustF,arcCustCode);


    Case ReportMode of

       7    :   Begin
                  ThTitle:='Allocation Report';

                  RepTitle:=BatchPTit(arcSalesMode)+' Allocation Report for '+dbFormatName(CustCode,Company);

                  AllocTrans:=DocNames[DocSplit[arcSalesMode,2]];

                  If (arcFromTrans) then
                    RepTitle2:='For '+AllocTrans+' '+arcOurRef;

                  PageTitle:=RepTitle;

                  RFont.Size:=8;
                  ROrient:=RPDefine.PoLandScape;


                end;

     12     :   Begin
                  ThTitle:='Unallocation Report';

                  RepTitle:='Unallocation Matching Report for '+arcOurRef;

                  PageTitle:=RepTitle;

                  RFont.Size:=10;
                  ROrient:=RPDefine.PoPortrait;


                end;


     15     :   Begin
                  ThTitle:=CCCISName^+' Matching Report';

                  RepTitle:=ThTitle+' for '+GetIntMsg(4)+' No. '+arcCode1;

                  PageTitle:=RepTitle;

                  RFont.Size:=10;
                  ROrient:=RPDefine.PoPortrait;


                end;


    end; {Case..}


    Case ReportMode of

       7    :   Begin
                  RFnum:=MiscF;

                  RKeyPath:=MIK;

                  RepKey:=PartCCKey(MBACSCode,MBACSALSub)+Tradecode[arcSalesMode]+FullCustCode(arcCustCode);
                end;

       12   :   Begin
                  RFnum:=MiscF;

                  RKeyPath:=MIK;

                  RepKey:=PartCCKey(MBACSCode,MBACSALSub)+NdxWeight;

                end;


       15   :   Begin
                  RFnum:=PWrdF;

                  RKeyPath:=HelpNDXK;

                  RepKey:=PartCCKey(MBACSCode,MBACSALSub)+NdxWeight; {Force a no find as data coming from outline}

                end;



    end; {Case..}



  end; {With..}

  Result:=BOn;
end;


procedure TAllocReport.Print_UOutLine;

type
  TXYPosition = Record
    X : Real;
    Y : Real;
  end;

Var
  iPos2, iLevel, iLastLevel, iPos : integer;
  rPrevLevelXPos, rYStartPos, rXStartPos : real;
  bDrawLineDown : boolean;
  aPosPrevItemAtLevel : array of TXYPosition;

  PenStyle : TPenStyle;
  iIndentSpaces : byte;
  iLineWidth : byte;
  sFontName : string;
  iFontSize : Byte;

  ODDRec    :  ^ODDType;

  Procedure DrawItemLines(rXPos, rYPosPrevItemAtThisLevel, rPrevLevelXPos : Real; bLineDown : boolean);
  begin{DrawItemLines}
    with RepFiler1 do begin

      SetPen(clBlack,PenStyle,iLineWidth,pmBlack);

      {draw mini horizontal line by item}
      MoveTo(rXPos, LineMiddle + 0.75);
      LineTo(rXPos + 2, LineMiddle + 0.75);

      {draw vertical line down to next item on this level}
      if bLineDown then begin
        MoveTo(rXPos, LineMiddle + 0.75);
        LineTo(rXPos, LineBottom);
      end;

      {draw vertical line up to previous item on this level}
      if rYPosPrevItemAtThisLevel <> -1 then begin
        MoveTo(rXPos, LineMiddle + 0.75);
        LineTo(rXPos, rYPosPrevItemAtThisLevel);
      end;{if}

      if rPrevLevelXPos <> -1 then begin
        {draw Horzontal line back to previous level}
        MoveTo(rXPos, LineMiddle + 0.75);
        LineTo(rPrevLevelXPos, LineMiddle + 0.75);

        {draw Vertical line back to previous level}
        LineTo(rPrevLevelXPos, LineTop);
      end;{if}
    end;{with}

  end;{DrawItemLines}

  function EndOfPageLine : boolean;
  begin
    with RepFiler1 do begin
      Result := LinesLeft < 3;
      if LinesLeft < 3 then
        begin
          DefLine(-2,1,PageWidth-MarginRight-1,-0.5);
          ThrowNewPage(3);
        end
      else
        // MH 08/01/2016 2016-R1 ABSEXCH-10720: Redirect to .xlsx compatible methods for .xlsx support
        Self.CRLF;
    end;{with}
  end;


Begin{PrintOutLine}

  with RepFiler1, TheOutline do
  begin
    For iPos:=1 to 1 do
      SendLine('');

    // initialise values

    PenStyle:=psSolid;
    iIndentSpaces :=10;
    iLineWidth :=8;
    sFontName := RFont.Name;
    iFontSize:=RFont.Size;

    iLastLevel := 1;
    if iIndentSpaces < 7 then iIndentSpaces := 7;

    ICount:=ItemCount;

    For iPos := 1 to ItemCount do begin

      // set properties
      XPos := XPos + 5;
      FontName := sFontName;
      FontSize := iFontSize;
      FontColor := clBlack;
      Bold := FALSE;
      LineHeight := iFontSize / 2;
      ResetLineHeight;

      // initialise array element
      if length(aPosPrevItemAtLevel) <= Items[iPos].Level then begin
        SetLength(aPosPrevItemAtLevel, Items[iPos].Level + 1);
        aPosPrevItemAtLevel[Items[iPos].Level].X := -1;
        aPosPrevItemAtLevel[Items[iPos].Level].Y := -1;
      end;{if}

      // don't always join up ALL items on the same level
      if (iLastLevel > Items[iPos].Level) then begin
        For iLevel := Items[iPos].Level + 1 to iLastLevel
        do aPosPrevItemAtLevel[iLevel].Y := -1;
      end;{if}

      // indent node
      Print( StringOfChar(' ',(Items[iPos].Level - 1) * iIndentSpaces) );

      // save X Y start positions for this node
      rXStartPos := YD2U(CursorXPos) - 3;
      rYStartPos := LineMiddle + 0.75;

      // print text


      ODDRec:=Items[iPos].Data;

      If (Assigned(ODDRec)) then
      With ODDRec^ do
      Begin
        SendRepSubHedDrillDown(MarginLeft,PageWidth+MarginLeft,1,NKey,NFnum,NKeyPath,0);
      end;

      Print(Items[iPos].Text);

      // work out whether there are any items below this node on the same level.
      bDrawLineDown := ItemCount > iPos;
      if bDrawLineDown then bDrawLineDown := Items[iPos].Level = Items[iPos + 1].Level;

      // Work out whether to draw a line back (horizontally) to the previous level
      if (Items[iPos].Level = 1) or (iLastLevel >= Items[iPos].Level)
      then rPrevLevelXPos := -1
      else rPrevLevelXPos := aPosPrevItemAtLevel[Items[iPos].Level - 1].X;

      // draw lines for item
      DrawItemLines(rXStartPos, aPosPrevItemAtLevel[Items[iPos].Level].Y
      , rPrevLevelXPos, bDrawLineDown);

      // save item positions
      aPosPrevItemAtLevel[Items[iPos].Level].X := rXStartPos + (iFontSize / 2);
      aPosPrevItemAtLevel[Items[iPos].Level].Y := rYStartPos;
      iLastLevel := Items[iPos].Level;

      // If EOP about to happen, then draw lines to the bottom the page
      if LinesLeft < 3 then begin

        // for each level up to the current level
        For iLevel := 1 to Items[iPos].Level do begin
          if (aPosPrevItemAtLevel[iLevel].X <> -1)
          and (aPosPrevItemAtLevel[iLevel].Y <> -1) then begin
            // go through all remaining nodes
            For iPos2 := iPos + 1 to ItemCount do begin

              // no line necessary
              if Items[iPos2].Level < iLevel then break;

              // node found that line will go to
              if Items[iPos2].Level = iLevel then begin
                // draw line
                MoveTo(aPosPrevItemAtLevel[iLevel].X - (iFontSize / 2), LineBottom);
                LineTo(aPosPrevItemAtLevel[iLevel].X - (iFontSize / 2), aPosPrevItemAtLevel[iLevel].Y);
                break;
              end;{if}
            end;{for}
          end;{if}
        end;{for}
      end;{if}

      // For new page, set last Y positions to the top of the page, to draw lines to previous page
      if EndOfPageLine then begin
        For iLevel := 1 to length(aPosPrevItemAtLevel) - 1 do begin
          if aPosPrevItemAtLevel[iLevel].Y <> -1 then aPosPrevItemAtLevel[iLevel].Y := LineTop;
        end;{for}
      end;{if}

    end;{for}

  end;{with}

  SetLength(aPosPrevItemAtLevel, 0);
end;{PrintOutLine}


Procedure TAllocReport.Process;

Begin
  Inherited Process;


end;


Procedure TAllocReport.Finish;


Begin

  Inherited Finish;
end;


{ ======== }



Procedure AddAllocRep2Thread(LMode       :  Byte;
                              IRepParam  :  MLocRec;
                              MyOutLine  :  TSBSOutlineB;

                              AOwner     :  TObject);


Var
  EntTest  :  ^TAllocReport;

Begin

  If (Create_BackThread) then
  Begin

    New(EntTest,Create(AOwner));

    try
      With EntTest^ do
      Begin
        ReportMode:=LMode;

        CRepParam^:=IRepParam.AllocCRec;

        If (Assigned(MyOutLine)) then
          TheOutLine:=MyOutLine;

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