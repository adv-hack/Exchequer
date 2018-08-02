Unit DicLnk2U;

{ markd6 15:57 29/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 19/09/94                      }
{                                                              }
{            Dictionary to Variable Link up Support 2          }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses Dialogs,
     SysUtils,
     GlobVar,
     VarConst,
     VarRec2U;

Type
  DictLinkType  =  Record
                     DCr,
                     DPr,
                     DYr   :  Byte;
                   end;


Function YesNoBo(TmpBo  :  Boolean) :  Str5;


Function GetCustStats(CCode :  Str10;
                      Mode  :  Byte;
                      ChkCr :  Boolean;
                      DLink :  DictLinkType)  :  Double;

Function GetNomStats(NCode :  Str20;
                     Mode  :  Byte;
                     HistCode
                           :  Char;
                     DLink :  DictLinkType)  :  Double;

Function GetStkStats(NCode :  Str20;
                     Mode  :  Byte;
                     HistCode
                           :  Char;
                     DLink :  DictLinkType)  :  Double;

Procedure LinkOtherdb(DrvFile,LinkFile  :  Integer);

Procedure LinkToJxAEmployee;

Function GetJBudgStats(NCode    : Str20;
                       Mode     : Byte;
                       HistCode : Char;
                       DLink    : DictLinkType)  :  Double;

Var
  { Temporary records used for relational lookup within same file }
  TmpJobCtrl : JobCtrlPtr;
  TmpJobMisc : JobMiscPtr;
  TmpMLoc    : MLocPtr;

 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   {Crt,
   Dos,
   EWinSBS,}
   ETStrU,
   {ETools2,}
   {ETPrintU,
   EPrntDef,}
   ETMiscU,
   {ETPrompt,}
   ETDateU,
   {ExAsvarU,}
   BtrvU2,
   BtSupU1,
   BtKeys1U,
   //InvListU,
   ComnUnit,
   ComnU2,
   SavePos,
   SysU1,
   SysU2,
   MultiBuyVar,

   //PR: 13/02/2012 ABSEXCH-9795
   QtyBreakVar

   //PR: 03/02/2014 ABSEXCH-14974
   {$IFDEF RW}
   ,AccountContactVar
   ,OrderPaymentsVar
   {$ENDIF}
   ;


Var
  ExitSave  :  Pointer;


  {== Function to return Yes No Boolean Str ==}

  Function YesNoBo(TmpBo  :  Boolean) :  Str5;

  Begin

    If (TmpBo) then
      YesNoBo:='Yes'
    else
      YesNoBo:='No';

  end; {Func..}




  { ============= Function to Return Customer History Details ============

    0 = Balance
    1 = Net Sales
    2 = Costs
    3 = Margin
    4 = Acc Debit
    5 = Acc Credit
    6 = Budget

    ChkCr = Off for Customers Debit details, On for Suppliers Credit Details.

  }


  Function GetCustStats(CCode :  Str10;
                        Mode  :  Byte;
                        ChkCr :  Boolean;
                        DLink :  DictLinkType)  :  Double;

  Var
    Balance,
    LastYTD,
    ThisPr,
    ThisYTD,
    Cleared,
    Budget1,
    Budget2  :  Double;

    Val1,
    Val2     :  Double;

    CrDr     :  DrCrDType;

    AcPr,AcYr
             :  Byte;

    Range    :  Boolean;

    HistCode :  Char;


  Begin
    Balance:=0;
    LastYTD:=0;
    ThisPr:=0;
    ThisYTD:=0;
    Cleared:=0;

    If (Mode In [1..3]) then
      HistCode:=CustHistGPCde
    else
      HistCode:=CustHistCde;

    With DLink do
    Begin
      Range:=(DPr In [YTD,YTDNCF]);

      AcYr:=DYr;

      If (HistCode In YTDNCFSet) and (AcYr=YTD) then
        AcYr:=Syss.CYr; {* Force year back to this year if not C/F *}

      If (Range) then
      Begin
        If (DPr=YTD) then
          AcPr:=Pred(YTDNCF)
        else
          AcPr:=Syss.CPr;
      end
      else
        AcPr:=DPr;
    end;


    Balance:=Total_Profit_to_Date(HistCode,CCode,Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,Budget1, Budget2, Val1, Val2, Range);

    Case Mode of
      0  :  GetCustStats:=Balance;
      1  :  GetCustStats:=CrDr[BOff];
      2  :  GetCustStats:=CrDr[BOn];
      3  :  GetCustStats:=CrDr[BOff]-CrDr[BOn];
      4  :  GetCustStats:=CrDr[Not ChkCr];
      5  :  GetCustStats:=CrDr[ChkCr];
      6  :  GetCustStats:=Budget1;
      else  GetCustStats:=0;
    end; {Case..}

  end; {Func..}


  { ============= Function to Return Nominal History Details ============

    1 = Debit
    2 = Credit
    3 = Balance
    4 = Budget

  }


  Function GetNomStats(NCode :  Str20;
                       Mode  :  Byte;
                       HistCode
                             :  Char;
                       DLink :  DictLinkType)  :  Double;

 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget,
   Budget2  :  Double;

   Val1,
   Val2     :  Double;

   CrDr     :  DrCrDType;

   AcPr,AcYr
            :  Byte;

   Range    :  Boolean;



 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;
   Budget2:=0;
   Result := 0;

   With DLink do
   Begin
     Range:=(DPr In [YTD,YTDNCF]);

     AcYr:=DYr;

     If (HistCode In YTDNCFSet) and (AcYr=YTD) then
       AcYr:=Syss.CYr; {* Force year back to this year if not C/F *}

     If (Range) then
     Begin
       If (DPr=YTD) then
         AcPr:=Pred(YTDNCF)
       else
         AcPr:=Syss.CPr;
     end
     else
       AcPr:=DPr;
   end;


   Balance:=Total_Profit_to_Date(HistCode,FullNHCode(NCode),Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,
                                 Budget,Budget2,Val1,Val2,Range);

   Case Mode of
     1  :  GetNomStats:=CrDr[BOff];
     2  :  GetNomStats:=CrDr[BOn];
     3  :  GetNomStats:=Balance;
     4  :  GetNomStats:=Budget;
     5  :  GetNomStats:=Budget2;
   end; {Case..}

 end; {Func..}



   { ============= Function to Return Stock History Details ============

    1 = Qty Sold
    2 = Sales
    3 = Costs
    4 = Margin
    5 = Budget
    10= Posted Stock Level

  }


  Function GetStkStats(NCode :  Str20;
                       Mode  :  Byte;
                       HistCode
                             :  Char;
                       DLink :  DictLinkType)  :  Double;

 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget,
   Budget2  :  Double;

   Val1,
   Val2     :  Double;

   CrDr     :  DrCrDType;

   AcPr,AcYr
            :  Byte;

   Range    :  Boolean;



 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;
   Budget2:=0;
   Result := 0;

   With DLink do
   Begin
     Range:=(DPr=YTD);

     AcYr:=DYr;

     If (Range) then
       AcPr:=Pred(YTDNCF)
     else
       AcPr:=DPr;
   end;

   If (Mode=10) Or (Mode = 12) then
     HistCode:=Calc_AltStkHCode(HistCode);

   Balance:=Total_Profit_to_Date(HistCode,FullNHCode(NCode),Dlink.DCr,AcYr,AcPr,CrDr[BOff],CrDr[BOn],Cleared,
                                 Budget,Budget2,Val1,Val2,Range);

   Case Mode of
     1,10
        :  GetStkStats:=Cleared;
     2  :  GetStkStats:=CrDr[BOn];
     3  :  GetStkStats:=CrDr[BOff];
     4  :  GetStkStats:=CrDr[BOn]-CrDr[BOff];
     5  :  GetStkStats:=Budget;
     12 :  GetStkStats:=Val1;
   end; {Case..}

 end; {Func..}


  {* ------------------------ *}


  Procedure LinkOtherdb(DrvFile,LinkFile  :  Integer);
  Var
    KeyL        : Str255;
    I           : SmallInt;
    TmpJCtrl    : JobCtrlPtr;
    TmpJMisc    : JobMiscPtr;
    TmpLoc      : MLocPtr;
    TmpRecAddr  : LongInt;
    TmpKPath,
    TmpStat     : Integer;
  Begin
    Case DrvFile of
      InvF  :  With Inv do Begin
                 Case LinkFile of
                   CustF  :  If (Cust.CustCode<>CustCode) then Begin
                               KeyL:=FullCustCode(CustCode);

                               {GetCust(KeyL,Off,Off,'');}
                               Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                               {$IFDEF RW}
                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               {$ENDIF}
                             end;

                   JobF   :  If (JobRec^.JobCode <> DJobCode) Then Begin
                               { Link to Line Stock Item }
                               KeyL := LJVar(DJobCode,10);

                               Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobCodeK,KeyL);

                               If (Not StatusOk) then
                                 ResetRec(LinkFile);
                             End;

                   JMiscF :  Begin
                               { Job Analysis }
                               If (JobMisc^.RecPFix <> JARCode) Or
                                  (JobMisc^.SubType <> JAACode) Or
                                  (JobMisc^.JobAnalRec.JAnalCode <> DJobAnal) Then Begin
                                 { Link to Job Analysis }
                                 KeyL := PartCCKey(JARCode, JAACode) + LJVar(DJobAnal,10);

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                 If (Not StatusOk) then Begin
                                   ResetRec(LinkFile);
                                 End; { If }
                               End; { If }
                             End;
                 end; {Case..}
               end;

      IdetailF
            :  With Id do Begin
                 {$IFDEF EDLL}
                 If (FolioRef <> 0) Then
                 {$ENDIF}
                   Case LinkFile of
                     CustF  :  If (Cust.CustCode<>CustCode) then Begin
                                 KeyL:=FullCustCode(CustCode);

                                 {GetCust(KeyL,Off,Off,'');}
                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                 {$IFDEF RW}
                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 {$ENDIF}
                               end;

                     InvF   :  If (Inv.FolioNum<>FolioRef) then Begin
                                 KeyL:=FullNomKey(FolioRef);

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvFolioK,KeyL);

                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               end;

                     NomF   :  If (Nom.NomCode<>NomCode) then Begin
                                 KeyL:=FullNomKey(NomCode);

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,NomCodeK,KeyL);

                                 {$IFDEF RW}
                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 {$ENDIF}
                               end;

                     StockF :  If (Stock.StockCode<>StockCode) then Begin
                                 KeyL := FullStockCode(StockCode);
                                 {GetStock(FullStockCode(StockCode),StockCode,-1);}
                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                 {$IFDEF RW}
                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 {$ENDIF}
                               end;

                     JobF   :  If (JobRec^.JobCode <> JobCode) Then Begin
                                 { Link to Line Stock Item }
                                 KeyL := LJVar(JobCode,10);

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobCodeK,KeyL);

                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               End;


                     JCtrlF :  If (JobCtrl^.RecPFix <> JBRCode) Or
                                  (JobCtrl^.SubType <> JBBCode) Or
                                  (JobCtrl^.JobBudg.JobCode <> JobCode) Or
                                  (JobCtrl^.JobBudg.AnalCode <> AnalCode) Then Begin
                                 { Link to Job Analysis }
                                 KeyL := PartCCKey(JBRCode, JBBCode) +
                                         LJVar(JobCode,10) +
                                         LJVar(AnalCode,16) +
                                         Chr(Currency);

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               End;

                     JMiscF :  Begin
                                 { Job Analysis }
                                 If (JobMisc^.RecPFix <> JARCode) Or
                                    (JobMisc^.SubType <> JAACode) Or
                                    (JobMisc^.JobAnalRec.JAnalCode <> AnalCode) Then Begin
                                   { Link to Job Analysis }
                                   KeyL := PartCCKey(JARCode, JAACode) + LJVar(AnalCode,10);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { If }

                                 { Employee }
                                 LinkOtherDb(DrvFile,JDetlF);
                               End;


                     JDetlF :  If (JobDetl^.RecPFix <> JBRCode) Or
                                  (JobDetl^.SubType <> JBECode) Or
                                  (JobDetl^.JobActual.LineFolio <> Id.FolioRef) Or
                                  (JobDetl^.JobActual.LineNo <> Id.LineNo) Then Begin
                                 { Link to Job Actuals }
                                 { HM 24/02/98: Modified to use AbsLineNo instead of LineNo as }
                                 { it didn't work form Nominal Transfers                       }
                                 KeyL := PartCCKey(JBRCode, JBECode) +
                                         FullNomKey(Id.FolioRef) +
                                         FullNomKey(Id.AbsLineNo) +
                                         '!';

                                 Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JDLookK,KeyL);

                                 If (Not StatusOk) then Begin
                                   ResetRec(LinkFile);
                                   FillChar (TmpJobMisc^, SizeOf(TmpJobMisc^), #0);
                                 End { If }
                                 Else Begin
                                   { Link to Employee in JMiscF }
                                   If (TmpJobMisc^.RecPFix <> JARCode) Or
                                      (TmpJobMisc^.SubType <> JAECode) Or
                                      (TmpJobMisc^.EmplRec.EmpCode <> JobDetl^.JobActual.EmplCode) Then Begin
                                     { Take temp backup of JobMisc^ }
                                     New (TmpJMisc);
                                     TmpJMisc^ := JobMisc^;

                                     { Save Position in file }
                                     TmpKPath:=GetPosKey;
                                     TmpStat:=Presrv_BTPos(JMiscF,TmpKPath,F[JMiscF],TmpRecAddr,BOff,BOff);

                                     { Link to employee - stash in memory record }
                                     KeyL := PartCCKey(JARCode, JAECode) + LJVar(JobDetl^.JobActual.EmplCode,6);

                                     Status:=Find_Rec(B_GetEq,F[JMiscF],JMiscF,RecPtr[JMiscF]^,JMK,KeyL);

                                     If (Not StatusOk) then
                                       ResetRec(JMiscF);

                                     { Copy into dummy record }
                                     TmpJobMisc^ := JobMisc^;

                                     { Restore position in file }
                                     TmpStat:=Presrv_BTPos(JMiscF,TmpKPath,F[JMiscF],TmpRecAddr,BOn,BOn);

                                     { Restore JobCtrl }
                                     JobMisc^ := TmpJMisc^;
                                     Dispose (TmpJMisc);
                                   End; { If }
                                 End; { Else }
                               End;

                     (* OLE - Used under Form Designer
                     MLocF  :  If (MLocCtrl^.MLocLoc.loCode <> MLocStk) Then Begin
                                 KeyL := PartCCKey (CostCCode, CSubCode[BOn]) + MLocStk;

                                 Status := Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,MLK,KeyL);

                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               End; { If }
                     *)

                     MLocF  :  Begin { Get Location & Stock/Location XRefs }
                                 { Location - stash in memory record }
                                 If (TmpMLoc^.RecPFix <> CostCCode) Or
                                    (TmpMLoc^.SubType <> CSubCode[BOn]) Or
                                    (TmpMLoc^.MLocLoc.loCode <> MLocStk) Then Begin
                                   { Take temp backup of MLocCtrl^ }
                                   New (TmpLoc);
                                   TmpLoc^ := MLocCtrl^;

                                   { Save Position in file }
                                   TmpKPath:=GetPosKey;
                                   TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOff,BOff);

                                   { Link to Location }
                                   KeyL:=PartCCKey(CostCCode,CSubCode[BOn])+MLocStk;


                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,MLK,KeyL);

                                   If (Not StatusOk) then Begin
                                     ResetRec(LinkFile);
                                   End;

                                   { Copy into dummy record }
                                   TmpMLoc^ := MLocCtrl^;

                                   { Restore position in file }
                                   TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOn,BOn);

                                   { Restore JobCtrl }
                                   MLocCtrl^ := TmpLoc^;
                                   Dispose (TmpLoc);
                                 End; { If }

                                 { Stock/Location XRef }
                                 If (MLocCtrl^.RecPFix <> CostCCode) Or
                                    (MLocCtrl^.SubType <> CSubCode[BOff]) Or
                                    (MLocCtrl^.MStkLoc.lsLocCode <> MLocStk) Or
                                    (MLocCtrl^.MStkLoc.lsStkCode <> StockCode) Then Begin

                                   { Link to Stock/Location }
                                   KeyL:=PartCCKey(CostCCode,CSubCode[BOff])+
                                         FullStockCode(StockCode) +
                                         MLocStk;

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,MLK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { If }

                               End;
                   End; { Case }
               End; { With }

      StockF
            :  With Stock do Begin
                 Case LinkFile of
                   CustF  :  If (Cust.CustCode<>Supplier) then Begin
                               KeyL:=FullCustCode(Supplier);

                               {GetCust(KeyL,Off,Off,'');}
                               Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                               {$IFDEF RW}
                                 If (Not StatusOk) then
                                   ResetRec(LinkFile);
                               {$ENDIF}
                             end;
                 end; {Case..}
               end;

      {$IFDEF RW}
      { HM 04/01/98: Matched Payments added }
      PWrdF :  With Password Do Begin
                 If (RecPFix = 'T') And (SubType = 'P') Then Begin
                   { Matched Payments }
                   With MatchPayRec Do Begin
                     Case LinkFile Of
                       CustF  : Begin
                                  { Link to transaction first as no code on sno record }
                                  LinkOtherdb(DrvFile, InvF);

                                  { Get customer for transaction }
                                  KeyL:=FullCustCode(Inv.CustCode);
                                  Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                  If (Not StatusOk) then
                                    ResetRec(LinkFile);
                                End; { CustF }

                       InvF   : If (Inv.OurRef<>DocCode) And (Inv.OurRef<>PayRef) then Begin
                                  { Load Transaction as valid transaction not already loaded }
                                  KeyL := DocCode;

                                  Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvOurRefK,KeyL);

                                  If (Not StatusOk) then
                                    ResetRec(LinkFile);
                                End; { If }
                     End; { Case LinkFile }
                   End; { With MatchPayRec }
                 End { If }
                 Else
                   {*431RW HM 29/03/00: Added Job Notes }
                   If (RecPFix = NoteTCode) And (SubType = NoteJCode) Then Begin
                     { Job Notes }
                     Case LinkFile Of
                       JobF : Begin
                                { Link to Job }
                                KeyL := NotesRec.NoteFolio;
                                KeyL[0] := #4;

                                Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobFolioK,KeyL);

                                If (Not StatusOk) then
                                  ResetRec(LinkFile);
                              End;
                     End; { Case }
                   End { If }
                   Else
                     {*431RW HM 29/03/00: Added Bill Of Materials }
                     If (RecPFix = BillMatTCode) And (SubType = BillMatSCode) Then Begin
                       { Bill Of Materials - Link to Stock? }
                       Case LinkFile Of
                         StockF : Begin
                                    { Link To Stock Item }
                                    KeyL := FullStockCode(BillMatRec.FullStkCode);
                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                    {$IFDEF RW}
                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                    {$ENDIF}

                                    { Load Supplier Details }
                                    LinkOtherDb(StockF,CustF);
                                  End;
                       End; { Case }
                     End { If }
                     Else
                       {*431RW HM 29/03/00: Added Customer/Supplier Notes }
                       If (RecPFix = NoteTCode) And (SubType = NoteCCode) Then Begin
                         Case LinkFile Of
                           CustF : Begin
                                     KeyL := FullCustCode(NotesRec.NoteFolio);
                                     Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   End;
                         End; { Case LinkFile }
                       End { If }
                       Else
                         {*431RW HM 29/03/00: Added Stock Notes }
                         If (RecPFix = NoteTCode) And (SubType = NoteSCode) Then Begin
                           Case LinkFile Of
                             StockF : Begin
                                        KeyL := NotesRec.NoteFolio;
                                        KeyL[0] := #4;

                                        Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                        If (Not StatusOk) then
                                          ResetRec(LinkFile);
                                      End;
                           End; { Case LinkFile }
                         End { If }
                         Else
                           {*431RW HM 12/04/00: Added Transaction Notes }
                           If (RecPFix = NoteTCode) And (SubType = NoteDCode) Then Begin
                             Case LinkFile Of
                               CustF : Begin
                                         { Ensure Transaction is loaded }
                                         LinkOtherDb(PwrdF,InvF);

                                         { Load Customer/Supplier Details }
                                         LinkOtherDb(InvF,CustF);
                                       End;

                               InvF  : Begin
                                         KeyL := NotesRec.NoteFolio;
                                         KeyL[0] := #4;

                                         Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvFolioK,KeyL);

                                         If (Not StatusOk) then
                                           ResetRec(LinkFile);
                                       End;
                             End; { Case }
                           End; { If }
               End; { PwordF }
      {$ENDIF}

      MiscF :  With MiscRecs^ Do Begin
                 If (RecMFix = MFIFOCode) And (SubType = MSernSub) Then Begin
                   { Serial/Batch Numbers }
                   With SerialRec Do
                     Case LinkFile of
                       { HM 08/10/98: Modified to support Customer }
                       CustF  :  Begin
                                   { Link to transaction first as no code on sno record }
                                   LinkOtherdb(DrvFile, InvF);

                                   { Get customer for transaction }
                                   KeyL:=FullCustCode(Inv.CustCode);
                                   Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 End; { CustF }

                       { HM 08/10/98: Modified to support InDoc }
                       InvF   :  If (Inv.OurRef<>InDoc) And (Inv.OurRef<>OutDoc) then Begin
                                   KeyL:=OutDoc;

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvOurRefK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { InvF }

                       StockF :  If (Stock.StockFolio<>StkFolio) then Begin
                                   KeyL:=FullNomKey(StkFolio);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { StockF }
                     end; {Case..}
                 End { If }
                 Else Begin
                   If (RecMFix = MFIFOCode) And (SubType = MFIFOSub) Then Begin
                     { FIFO }
                     Case LinkFile Of
                       CustF   : If (Cust.CustCode <> FIFORec.FIFOCust) Then Begin
                                   KeyL:=FullCustCode(FIFORec.FIFOCust);
                                   Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { CustF }
                       InvF    : If (Inv.OurRef <> FIFORec.DocRef) Then Begin
                                   KeyL:=FIFORec.DocRef;

                                   Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { InvF }
                       IDetailF: Begin
                                   If (Inv.OurRef <> FIFORec.DocRef) Then
                                     { Load Invoice as necessary }
                                     LinkOtherDb(MiscF,InvF);

                                   If (Id.DocPRef <> FIFORec.DocRef) Or (Id.AbsLineNo <> FIFORec.DocABSNo) Then Begin
                                     { Link to Line Invoice }
                                     KeyL:=FullNomKey(Inv.FolioNum) + FullNomKey(FIFORec.DocABSNo);

                                     Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,IdLinkK,KeyL);

                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   End; { If }
                                 End; { IDetailF }
                       StockF  : If (Stock.StockFolio <> FIFORec.StkFolio) Then Begin
                                   KeyL:=FullNomKey(FIFORec.StkFolio);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                   If (Not StatusOk) then
                                     ResetRec(LinkFile);
                                 End; { StockF }
                     End; { Case LinkFile }
                   End { If }
                   Else
                     If (RecMFix = CDDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn]]) Then Begin
                       { Customer/Supplier Discounts }
                       Case LinkFile Of
                         CustF   : If (Cust.CustCode <> CustDiscRec.DCCode) Then Begin
                                     KeyL:=FullCustCode(CustDiscRec.DCCode);

                                     Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   End; { CustF }
                         StockF :  If (Stock.StockCode<>CustDiscRec.QStkCode) Then Begin
                                     KeyL:=FullStockCode(CustDiscRec.QStkCode);

                                     Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   End; { StockF }
                       End; { Case }
                     End { If }
                     Else
                       If (RecMFix = QBDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn], QBDiscSub]) Then Begin
                         { Customer/Supplier/Stock Quantity Breaks }
                         Case LinkFile Of
                           CustF   : If (Cust.CustCode <> QtyDiscRec.QCCode) Then Begin
                                       KeyL:=FullCustCode(QtyDiscRec.QCCode);

                                       Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                     End; { CustF }

                           StockF  : If (Stock.StockFolio <> QtyDiscRec.QStkFolio) Then Begin
                                       KeyL:=FullNomKey(QtyDiscRec.QStkFolio);

                                       Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                     End; { StockF }
                         End; { Case }
                       End; { If }
                 End; { Else }
               End; { MiscF }
      JMiscF : With JobMisc^ Do Begin
                 Case LinkFile Of

                   CustF : Begin
                             { Employees }
                             If (RecPfix = JARCode) And (SubType = JAECode) Then
                               With EmplRec Do
                                 If (EType = 2 ) Then Begin
                                   { Sub-Contracted - Link to Supplier }
                                    KeyL := FullCustCode(Supplier);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                 End { If }
                                 Else
                                   ResetRec (LinkFile)
                             Else
                               ResetRec (LinkFile);
                           End;
                 End; { Case }
               End;

      JCtrlF : With JobCtrl^ Do Begin
                 If (RecPfix = JBRCode) And (SubType In [JBECode, JBPCode]) Then Begin
                   { Rates Of Pay }
                   Case LinkFile of

                     JMiscF : Begin
                                { Employee Rate Of Pay }
                                If (RecPfix = JBRCode) And (SubType = JBPCode) Then
                                  With EmplPay Do Begin
                                    { Link to employee }
                                    KeyL := PartCCKey(JARCode, JAECode) + LJVar(EmpCode,6);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End { With }
                                Else
                                  { No employee link }
                                  ResetRec(LinkFile);
                              End;

                   End; { Case }
                 End { If }
                 Else
                   With JobBudg Do
                     { Job Budgets }
                     If (RecPfix = JBRCode) And (SubType In [JBBCode, JBMCode, JBSCode]) Then
                       Case LinkFile of

                         StockF : If Not PayRMode Then Begin
                                    If (Stock.StockCode<>StockCode) then Begin
                                      { Link to Line Stock Item }
                                      KeyL := FullStockCode(StockCode);

                                      Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                     end;
                                  End { If }
                                  Else
                                    ResetRec(LinkFile);

                         JobF   : If (JobRec^.JobCode <> JobCode) Then Begin
                                    { Link to Line Stock Item }
                                    KeyL := LJVar(JobCode,10);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobCodeK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End; { If }

                         JMiscF : If (JobMisc^.RecPFix <> JARCode) Or
                                     (JobMisc^.SubType <> JAACode) Or
                                     (JobMisc^.JobAnalRec.JAnalCode <> AnalCode) Then Begin
                                    { Link to Analysis Code }
                                    KeyL := PartCCKey(JARCode, JAACode) + LJVar(AnalCode,10);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End; { If }

                         JCtrlF : If (TmpJobCtrl^.RecPFix <> JBRCode) Or
                                     (TmpJobCtrl^.SubType <> JBECode) Or
                                     (TmpJobCtrl^.EmplPay.EStockCode <> StockCode) Then Begin

                                    If (SubType = JBSCode) And PayRMode Then Begin
                                      { Link to Pay Rate - in same file! }
                                      { stash pay rate rec in TmpJobCtrl }
                                      { so the job budget record isnt    }
                                      { trashed when the rate is gotten  }

                                      { Take temp backup of JobCtrl^ }
                                      New (TmpJCtrl);
                                      TmpJCtrl^ := JobCtrl^;

                                      { Save Position in file }
                                      TmpKPath:=GetPosKey;
                                      TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOff,BOff);

                                      { Link to Pay Rate }
                                      KeyL := PartCCKey(JBRCode, JBECode) +
                                              ConstStr(#255,4) +
                                              ConstStr(#32,6) +
                                              LJVar(StockCode,10);

                                      Status:=Find_Rec(B_GetGEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JCK,KeyL);

                                      If (Not StatusOk) Or
                                         (TmpJCtrl^.JobBudg.StockCode <> LJVar(JobCtrl^.EmplPay.EStockCode,16)) then
                                        ResetRec(LinkFile);

                                      { Copy into dummy record }
                                      TmpJobCtrl^ := JobCtrl^;

                                      { Restore position in file }
                                      TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOn,BOn);

                                      { Restore JobCtrl }
                                      JobCtrl^ := TmpJCtrl^;
                                      Dispose (TmpJCtrl);
                                    End { If }
                                    Else
                                      FillChar (TmpJobCtrl^, SizeOf(TmpJobCtrl^), #0);
                                  End;
                       End; { Case }
               End; { With }

      JobF   : With JobCtrl^ Do Begin
                 Case LinkFile of
                   CustF  : With JobRec^ Do Begin
                              { Link to Customer }
                              KeyL := FullCustCode(CustCode);

                              Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                              If (Not StatusOk) then
                                ResetRec(LinkFile);
                            End;

                   JMiscF : With JobRec^ Do Begin
                              { Link to Job Type }
                              KeyL := PartCCKey(JARCode, JATCode) + LJVar(JobAnal,10);

                              Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                              If (Not StatusOk) then
                                ResetRec(LinkFile);
                            End; { With }

                 End; { Case }
               End; { With }

      JDetlF : With JobDetl^ Do Begin
                 If (RecPFix = JBRCode) And (SubType = JBECode) Then Begin
                   With JobActual Do
                     { Actuals }
                     Case LinkFile Of
                       StockF   : If (Stock.StockCode<>StockCode) then Begin
                                    { Link to Line Stock Item }
                                    KeyL := FullStockCode(StockCode);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End;

                       CustF,
                       InvF     : If (Inv.FolioNum<>LineFolio) then Begin
                                    { Link to Line Invoice }
                                    KeyL:=FullNomKey(LineFolio);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvFolioK,KeyL);

                                    If (Not StatusOk) Then Begin
                                      ResetRec(LinkFile);
                                      ResetRec(CustF);
                                    End { If }
                                    Else
                                      LinkOtherDB (InvF, CustF);
                                  End;

                       { HM 04/02/99: Modified as it didn't look right and DL reported the link to the }
                       {              transaction line was a bit hit and miss                          }
                       IDetailF : If (Id.FolioRef <> LineFolio) Or (Id.AbsLineNo <> LineNo) Then Begin
                       {IDetailF : If (Id.FolioRef <> LineFolio) Or (Id.LineNo <> LineNo) Then Begin}
                                    { Link to Line Invoice }
                                    KeyL:=FullNomKey(LineFolio) + FullNomKey(LineNo);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,IdLinkK,KeyL);
                                    {Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,IdFolioK,KeyL);}

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile)
                                    Else Begin
                                      { Do relational links for detail record }
                                      For I := 1 To MaxFiles Do
                                        LinkOtherdb(IDetailF, I);
                                    End; { Else }
                                  End;

                       JobF     : If (JobRec^.JobCode <> JobCode) Then Begin
                                    { Link to Line Stock Item }
                                    KeyL := LJVar(JobCode,10);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobCodeK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End; { If }

                       JMiscF   : If (JobMisc^.EmplRec.EmpCode <> EmplCode) Then Begin

                                    { Link to employee }
                                    KeyL := PartCCKey(JARCode, JAECode) + LJVar(EmplCode,6);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                    If (Not StatusOk) then
                                      ResetRec(LinkFile);
                                  End; { If }

                       (*
                       JCtrlF  : If (JDDT = TSH) Then Begin
                                   { Load Time Rate - try for Employee specific first }


                                 End { If (JDDT = TSH) }
                                 Else
                                   { Not Timesheet - blank time rate details }
                                   ResetRec (LinkFile);
                       *)
                     End; { Case }
                 End { If }
                 Else
                   If (RecPFix = JBRCode) And (SubType = JBPCode) Then Begin
                     With JobReten Do Begin
                       { Retentions }
                       Case LinkFile Of
                         CustF    : If (Cust.CustCode <> RetCustCode) Then Begin
                                      { Link to Customer }
                                      KeyL := FullCustCode(RetCustCode);

                                      Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                    End;

                         InvF     : If (Inv.OurRef <> RetDoc) then Begin
                                      { Link to Line Invoice }
                                      KeyL:={LJVar(}RetDoc{,10)};

                                      Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,InvOurRefK,KeyL);

                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                    End;

                         JobF     : If (JobRec^.JobCode <> JobCode) Then Begin
                                      { Link to Line Stock Item }
                                      KeyL := LJVar(JobCode,10);

                                      Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JobCodeK,KeyL);

                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                    End; { If }

                         JMiscF   : If (JobMisc^.RecPFix <> JARCode) Or
                                       (JobMisc^.SubType <> JAACode) Or
                                       (JobMisc^.JobAnalRec.JAnalCode <> AnalCode) Then Begin
                                      { Link to Analysis Code }
                                      KeyL := PartCCKey(JARCode, JAACode) + LJVar(AnalCode,10);

                                      Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                      If (Not StatusOk) then
                                        ResetRec(LinkFile);
                                    End; { If }
                       End; { Case }
                     End; { With }
                   End { If (RecPFix = JBRCode) And (SubType = JBPCode) }
                   Else Begin
                     // CIS Vouchers
                     With JobDetl^.JobCISV Do
                       Case LinkFile Of
                         // Supplier
                         CustF    : Begin
                                      KeyL := FullCustCode(Copy(CISVSDATE, 1, 6));

                                      If (Cust.CustCode <> KeyL) Then Begin
                                        Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,CustCodeK,KeyL);

                                        If (Not StatusOk) then
                                          ResetRec(LinkFile);
                                      End; { If (Cust.CustCode <> KEYL) }
                                    End; { CustF - Supplier }

                         // Employee
                         JMiscF   : Begin
                                      KeyL := LJVar(Copy(CISVCode1, 1, 6),6);

                                      If (JobMisc^.EmplRec.EmpCode <> KeyL) Then Begin
                                        KeyL := PartCCKey(JARCode, JAECode) + KeyL;

                                        Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,JMK,KeyL);

                                        If (Not StatusOk) then
                                          ResetRec(LinkFile);
                                      End; { If (JobMisc^.EmplRec.EmpCode <> KeyL) }
                                    End; { JMiscF - Employee }
                       End; { Case LinkFile }
                   End; { Else }
               End; { JDetlF }

      MLocF  : With MLocCtrl^ Do Begin
                 If (RecPFix = CostCCode) And (SubType = CSubCode[False]) Then Begin
                   { Stock Locations }
                   With MStkLoc Do
                     Case LinkFile Of

                       StockF : If (Stock.StockCode<>lsStkCode) Then Begin
                                  { Link to Line Stock Item }
                                  KeyL := FullStockCode(lsStkCode);

                                  Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                  If (Not StatusOk) then
                                    ResetRec(LinkFile);
                                End; { If }

                       MLocF  : If (TmpMLoc^.RecPFix <> CostCCode) Or
                                   (TmpMLoc^.SubType <> CSubCode[True]) Or
                                   (TmpMLoc^.MLocLoc.loCode <> lsLocCode) Then Begin

                                  If (SubType = CSubCode[False]) Then Begin
                                    { Link to Location - in same file! }
                                    { stash stk loc rec in Tmploc so   }
                                    { the stock location record isnt   }
                                    { trashed when the location is got }

                                    { Take temp backup of MLocCtrl^ }
                                    New (TmpLoc);
                                    TmpLoc^ := MLocCtrl^;

                                    { Save Position in file }
                                    TmpKPath:=GetPosKey;
                                    TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOff,BOff);

                                    { Link to Location }
                                    KeyL := PartCCKey(CostCCode, CSubCode[True]) +
                                            LJVar(lsLocCode,3);

                                    Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,MLK,KeyL);

                                    If (Not StatusOk) Or
                                       (TmpLoc^.MStkLoc.lsLocCode <> MLocLoc.LoCode) Then
                                      ResetRec(LinkFile);

                                    { Copy into dummy record }
                                    TmpMLoc^ := MLocCtrl^;

                                    { Restore position in file }
                                    TmpStat:=Presrv_BTPos(LinkFile,TmpKPath,F[LinkFile],TmpRecAddr,BOn,BOn);

                                    { Restore JobCtrl }
                                    MLocCtrl^ := TmpLoc^;
                                    Dispose (TmpLoc);
                                  End { If }
                                  Else
                                    FillChar (TmpMLoc^, SizeOf(TmpMLoc^), #0);
                                End;

                     End; { Case }
                 End { If }
                 Else
                 if (RecPFix = BRRecCode) And (SubType = MSernSub) Then
                 begin
                   //Multi-bins
                   With brBinRec Do
                     Case LinkFile Of

                       StockF : If (Stock.StockFolio<>brStkFolio) Then Begin
                                  { Link to Line Stock Item }
                                   KeyL:=FullNomKey(brStkFolio);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 end;
                       CustF  :  Begin

                                   { Get customer for transaction }
                                   KeyL:=FullCustCode(Inv.CustCode);
                                   Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 End; { CustF }
                     End; //Case
                 end
                else 
                if RecPFix = NoteTCode then  //PR: 12/03/2009 Alt Stock Codes
                 begin
                   With sdbStkRec Do
                     Case LinkFile Of

                       StockF : If (Stock.StockFolio<>sdStkFolio) Then Begin
                                  { Link to Line Stock Item }
                                   KeyL:=FullNomKey(sdStkFolio);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 end;
                       CustF  :  Begin

                                   { Get customer for transaction }
                                   if Cust.CustCode <> sdSuppCode then
                                   begin
                                     KeyL:=FullCustCode(sdSuppCode);
                                     Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);

                                     {$IFDEF RW}
                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                     {$ENDIF}
                                   end;
                                 End; { CustF }
                     End; //Case
                 end;
               End;  { With }
      //PR: 10/06/2009 Added handling for Multi-Buy Discounts
      MultiBuyF : with MultiBuyDiscount do
                    Case LinkFile of
                       CustF  :  Begin
                                   { Get customer for discount }
                                   if Cust.CustCode <> mbdAcCode then
                                   begin
                                     if Trim(mbdAcCode) <> '' then
                                     begin
                                       KeyL:=FullCustCode(mbdAcCode);
                                       Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);
                                     end
                                     else
                                       Status := 4;

                                     {$IFDEF RW}
                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                     {$ENDIF}
                                   end;
                                 End; { CustF }

                       StockF :  If (Stock.StockCode<>mbdStockCode) then Begin
                                   KeyL := FullStockCode(mbdStockCode);
                                   {GetStock(FullStockCode(StockCode),StockCode,-1);}
                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkCodeK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 end;
                    end;//Case

      //PR: 13/02/2010 Added handling for Qty Breaks
      QtyBreakF : with QtyBreakRec do
                    Case LinkFile of
                       CustF  :  Begin
                                   { Get customer for discount }
                                   if Cust.CustCode <> qbAcCode then
                                   begin
                                     if Trim(qbAcCode) <> '' then
                                     begin
                                       KeyL:=FullCustCode(qbAcCode);
                                       Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);
                                     end
                                     else
                                       Status := 4;

                                     {$IFDEF RW}
                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                     {$ENDIF}
                                   end;
                                 End; { CustF }

                       StockF :  If (Stock.StockFolio <> qbStockFolio) then Begin
                                   KeyL := FullNomKey(qbStockFolio);

                                   Status:=Find_Rec(B_GetEq,F[LinkFile],LinkFile,RecPtr[LinkFile]^,StkFolioK,KeyL);

                                   {$IFDEF RW}
                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   {$ENDIF}
                                 end;
                    end;//Case
      //PR: 03/02/2014 ABSEXCH-14974 Add handling for Account Contacts. VRW only.
      {$IFDEF RW}
      AccountContactRoleF
                :
                   begin
                     Case LinkFile of
                        CustF : with AccContact do
                                begin
                                   if Cust.CustCode <> acoAccountCode then
                                   begin
                                     if Trim(acoAccountCode) <> '' then
                                     begin
                                       KeyL:=FullCustCode(acoAccountCode);
                                       Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);
                                     end
                                     else
                                       Status := 4;


                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                   end;
                                 End; { CustF }
                        AccountContactF
                              : begin
                                  if AccContact.acoContactId <> AccContactRole.acrContactId then
                                  begin
                                    if AccContactRole.acrContactId <> 0 then
                                      Status := GetAccountContact(AccContactRole.acrContactId)
                                    else
                                      Status := 4;

                                    If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                  end;
                                end; //AccountContactF

                      end; //case
                    end; //case

      //PR: 14/10/2014 Added handling for Order Payments
      OrderPaymentsF
                :  begin
                     Case LinkFile of
                        InvF : begin
                                   //The transaction we need to link to is in OrderPaymentsVar.OPLinkTransaction
                                   if Trim(Inv.OurRef) <> Trim(OPLinkTransaction) then
                                   begin
                                     if Trim(OPLinkTransaction) <> '' then
                                     begin
                                       KeyL:= FullOurRefKey(OPLinkTransaction);
                                       Status:=Find_Rec(B_GetEq,F[InvF],InvF,RecPtr[InvF]^,InvOurRefK,KeyL);
                                     end
                                     else
                                       Status := 4;


                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                   end;
                               end; { InvF }

                        IDetailF
                              : begin
                                 //Do we need to find the line?
                                 if (Id.FolioRef <> Inv.FolioNum)
                                 or ((Id.IdDocHed = SOR) and (Id.AbsLineNo <> OrderPaymentVatRec.vpSORABSLineNo))
                                 or ((Id.IdDocHed <> SOR) and (Id.SOPLineNo <> OrderPaymentVatRec.vpSORABSLineNo))
                                 then
                                 begin
                                   if (Inv.FolioNum <> 0) and (OrderPaymentVatRec.vpSORABSLineNo <> 0) then
                                   begin
                                     //Find line
                                     if Inv.InvDocHed = SOR then
                                     begin
                                       //If we're linking to SOR then we can use GetEqual
                                       KeyL:= FullRunNoKey(Inv.FolioNum, OrderPaymentVatRec.vpSORABSLineNo);
                                       Status:=Find_Rec(B_GetEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^, IdLinkK, KeyL);
                                     end
                                     else
                                     begin
                                       //SDN or SIN: need to use SOPLineNo and GetGEq/GetNext
                                       KeyL:= FullRunNoKey(Inv.FolioNum, 1);
                                       Status:=Find_Rec(B_GetGEq,F[IDetailF],IDetailF,RecPtr[IDetailF]^, IdLinkK, KeyL);

                                       while StatusOK and (Id.FolioRef = Inv.FolioNum) and (Id.SOPLineNo <> OrderPaymentVatRec.vpSORABSLineNo) do
                                         Status:=Find_Rec(B_GetNext,F[IDetailF],IDetailF,RecPtr[IDetailF]^, IdLinkK, KeyL);

                                       if not StatusOK or (Id.FolioRef <> Inv.FolioNum) or (Id.SOPLineNo <> OrderPaymentVatRec.vpSORABSLineNo) then
                                         Status := 4;

                                     end;
                                   end
                                   else
                                     Status := 4;


                                     If (Not StatusOk) then
                                       ResetRec(LinkFile);
                                 end;
                               End; { IDetailF }

                        CustF : begin  //Find customer from transaction header
                                   if Cust.CustCode <> Inv.CustCode then
                                   begin
                                     if Trim(Inv.CustCode) <> '' then
                                     begin
                                       KeyL:=FullCustCode(Inv.CustCode);
                                       Status:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyL);
                                     end
                                     else
                                       Status := 4;

                                       If (Not StatusOk) then
                                         ResetRec(LinkFile);
                                   end;
                                end; { CustF }
                      end; //case
                    end; //OrderPaymentsF
      {$ENDIF RW}
    end; {Case..}


  end;{Proc..}

//-------------------------------------------------------------------------

// Links to the Employee record for a JPA/JSA transaction
Procedure LinkToJxAEmployee;
Var
  THPos, JMPos : TBtrieveSavePosition;
  iStatus      : SmallInt;
  sKey         : Str255;
Begin // LinkToJxAEmployee
  THPos := TBtrieveSavePosition.Create;
  Try
    // Save the current record and position in the file for the current key
    THPos.SaveFilePosition (InvF, GetPosKey);
    THPos.SaveDataBlock (@Inv, SizeOf(Inv));

    If (Inv.FolioNum <> Id.FolioRef) Then
    Begin
      // Link to transaction as not loaded
      LinkOtherdb(IDetailF, InvF);
    End; // If (Inv.FolioNum <> Id.FolioRef)

    JMPos := TBtrieveSavePosition.Create;
    Try
      // Save the current record and position in the file for the current key
      JMPos.SaveFilePosition (JMiscF, GetPosKey);
      JMPos.SaveDataBlock (RecPtr[JMiscF], JobMiscFile^.RecLen);

      //------------------------------

      // Link to employee - stash in memory record }
      sKey := PartCCKey(JARCode, JAECode) + LJVar(Inv.CISEmpl,6);

      iStatus:=Find_Rec(B_GetEq,F[JMiscF],JMiscF,RecPtr[JMiscF]^,JMK,sKey);

      If (iStatus = 0) Then
      Begin
        // Copy into dummy record
        TmpJobMisc^ := JobMisc^;
      End // If (iStatus = 0)
      Else
      Begin
        ResetRec(JMiscF);
      End; // Else

      //------------------------------

      // Restore record and position in file
      JMPos.RestoreSavedPosition;
      JMPos.RestoreDataBlock (RecPtr[JMiscF]);
    Finally
      FreeAndNIL(JMPos);
    End; // Try..Finally

    // Restore record and position in file
    THPos.RestoreSavedPosition;
    THPos.RestoreDataBlock (@Inv);
  Finally
    FreeAndNIL(THPos);
  End; // Try..Finally
End; // LinkToJxAEmployee

//-------------------------------------------------------------------------


  Function Qty_Total_Profit_To_Date(NType        :  Char;
                                    NCode        :  Str20;
                                    PCr,PYr,PPr  :  Byte;
                                Var Purch,PSales,
                                    PCleared,
                                    PBudget,
                                    PRBudget     :  Double;
                                Var Qty1, Qty2   :  Double;
                                    Range        :  Boolean)  :  Double;


Const
  Fnum  =  NHistF;
  NPath =  NHK;



Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;



Begin
  Purch:=0; PSales:=0; PCleared:=0;  PBudget:=0; Bal:=0; PRBudget:=0;

  Qty1:=0.0; Qty2:=0.0;

  NHChK:=FullNHistKey(NType,NCode,PCr,PYr,PPr);

  If (Range) then
    NHKey:=FullNHistKey(NType,NCode,PCr,AdjYr(PYr,BOff),YTD)
  else
    NHKey:=NHChk;

  If (NType In YTDSet+[NomHedCode,CustHistCde,CustHistPCde]) and (Range) then  {** Get Last Valid YTD **}
  Begin
    NHKey2:=NHKey;
    Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey2);

    If (StatusOk) and (CheckKey(NHChk,NHKey2,Length(NHChk)-2,BOn)) and (NHist.Pr=YTD) then
      NHKey:=NHKey2;
  end;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);


  While (StatusOK) and (NHKey<=NHChk) do
  With NHist do
  Begin

    If ((NType<>CustHistCde) or (Not (Pr In [YTD,YTDNCF]))) then
    Begin
      Purch:=Purch+Purchases;
      PSales:=PSales+Sales;
    end;

    Bal:=Bal+(Purchases-Sales);

    PCleared:=PCleared+Cleared;

    If (Not (Pr In [YTD,YTDNCF])) then
    Begin
      PBudget:=PBudget+Budget;

      PRBudget:=PRBudget+RevisedBudget1;
    end;

    Qty1:=Qty1+Value1;
    Qty2:=Qty2+Value2;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,NPath,NHKey);
  end;


  Result:=Bal;

end; {Func..}



  { ============= Function to Return Job Analysis History Details ============
    0  = Budget Qty
    1  = Budget Value
    2  = Revised Budget Qty
    3  = Revised Budget Value
    4  = Actual Qty
    5  = Actual Value
  }

  Function GetJBudgStats(NCode    : Str20;
                         Mode     : Byte;
                         HistCode : Char;
                         DLink    : DictLinkType)  :  Double;

 Var
   Balance,
   LastYTD,
   ThisPr,
   ThisYTD,
   Cleared,
   Budget,
   Budget2  :  Double;

   Qty1,
   Qty2     :  Double;

   CrDr     :  DrCrDType;
   AcPr,AcYr
            :  Byte;
   Range    :  Boolean;
 Begin
   Balance:=0;
   LastYTD:=0;
   ThisPr:=0;
   ThisYTD:=0;
   Cleared:=0;
   Budget:=0;
   Budget2:=0;
   Qty1:=0.0;
   Qty2:=0.0;
   Result := 0;

   With DLink do
   Begin
     Range:=(DPr In [YTD,YTDNCF]);

     AcYr:=DYr;

     If (HistCode In YTDNCFSet) and (AcYr=YTD) then
       AcYr:=Syss.CYr; {* Force year back to this year if not C/F *}

     If (Range) then
     Begin
       If (DPr=YTD) then
         AcPr:=Pred(YTDNCF)
       else
         AcPr:=Syss.CPr;
     end
     else
       AcPr:=DPr;
   end;


   Balance:=Qty_Total_Profit_to_Date(HistCode,
                                     FullNHCode(NCode),
                                     Dlink.DCr,
                                     AcYr,
                                     AcPr,
                                     CrDr[BOff],
                                     CrDr[BOn],
                                     Cleared,
                                     Budget,
                                     Budget2,
                                     Qty1,
                                     Qty2,
                                     Range);

   Case Mode of
     0  : GetJBudgStats := Qty1;     { Budget Qty }
     1  : GetJBudgStats := Budget;   { Budget Value }
     2  : GetJBudgStats := Qty2;     { Revised Budget Qty }
     3  : GetJBudgStats := Budget2;  { Revised Budget Value }
     4  : GetJBudgStats := Cleared;  { Actual Qty }
     5  : GetJBudgStats := Balance;  { Actual Value }
   end; {Case..}
  end; {Func..}


Procedure Ex_Abort;  far;
Begin
  ExitProc:=ExitSave;

  Dispose (TmpMLoc);
  Dispose (TmpJobMisc);
  Dispose (TmpJobCtrl);
end;


Begin
  ExitSave:=ExitProc;
  ExitProc:=@Ex_Abort;

  New (TmpJobCtrl);
  New (TmpJobMisc);
  New (TmpMLoc);

  FillChar (TmpJobCtrl^, SizeOf(TmpJobCtrl^), #0);
  FillChar (TmpJobMisc^, SizeOf(TmpJobMisc^), #0);
  FillChar (TmpMLoc^,    SizeOf(TmpMLoc^),    #0);
end.
