Unit SpeF5u;




{**************************************************************}
{                                                              }
{        ====----> E X C H E Q U E R Translate <----===        }
{                                                              }
{                      Created : 19/05/2000                    }
{                                                              }
{                                                              }
{                     Common Overlaid Unit                     }
{                                                              }
{               Copyright (C) 2000 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}


Interface

Uses
  Classes,
  GlobVar,
  VarConst,
  SFHeaderU,
  ProgU;

Procedure Test_V5DocIndex(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              ProgBar
                                    :  TSFProgressBar);

Procedure Set_CCDPad(Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         ProgBar
                               :  TSFProgressBar);

Procedure Reset_SterSettle(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               MCMode:  Byte;
                               ProgBar
                                     :  TSFProgressBar);


Procedure RepairDiscRecs(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

Procedure Del_FIFORecs(Var RunOk    :  Boolean;
                       Var TotalCount,
                           LCount   :  LongInt;
                           Mode     :  Byte;
                           ProgBar
                                    :  TSFProgressBar);

Procedure Reset_BOMSoldRecs(Var RunOk    :  Boolean;
                            Var TotalCount,
                                LCount   :  LongInt;
                                Mode     :  Byte;
                                ProgBar
                                         :  TSFProgressBar);

Procedure Del_DocAuditNotes(Var TotalCount,
                            LCount:  LongInt;
                        Var RunOk :  Boolean;
                            ProgBar
                                  :  TSFProgressBar);

Procedure Reset_AllocStat(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              MCMode:  Byte;
                              ProgBar
                                    :  TSFProgressBar);

Procedure Clean_StkTypeFlg(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure DeleteSerialBatchRecs(Var RunOk :  Boolean;
                                Var TotalCount,
                                    MFind :  LongInt;
                                    ProgBar
                                          :  TSFProgressBar;
                                    DMode :  Byte);

Procedure Clean_PaymentFlg(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure Reset_GreencoreSIN(Var RunOk :  Boolean;
                             Var TotalCount,
                                 MFind :  LongInt;
                                 ProgBar
                                       :  TSFProgressBar);

Procedure Set_StockNoteC(Var RunOk :  Boolean;
                           Var MFind,
                               TotalCount
                                     :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


Procedure Del_DupliLocRecs(Var RunOk    :  Boolean;
                             Var TotalCount,
                                 LCount   :  LongInt;
                                 Mode     :  Byte;
                                 ProgBar
                                          :  TSFProgressBar);

Procedure Del_DeadBinChildRecs(Var RunOk    :  Boolean;
                                 Var TotalCount,
                                     LCount   :  LongInt;
                                     Mode     :  Byte;
                                     ProgBar
                                              :  TSFProgressBar);

Procedure Del_DeadBinMasterRecs(Var RunOk    :  Boolean;
                                 Var TotalCount,
                                     LCount   :  LongInt;
                                     Mode     :  Byte;
                                     ProgBar
                                              :  TSFProgressBar);


Procedure Del_DupliJCtrlRecs(Var RunOk    :  Boolean;
                               Var TotalCount,
                                   LCount   :  LongInt;
                                   Mode     :  Byte;
                                   ProgBar
                                            :  TSFProgressBar);
Procedure Del_TeleSalesCtrlRecs(Var RunOk    :  Boolean;
                                  Var TotalCount,
                                      LCount   :  LongInt;
                                      Mode     :  Byte;
                                      ProgBar
                                               :  TSFProgressBar);

Procedure Set_MLFPad(Var RunOk :  Boolean;
                     Var TotalCount,
                         LCount:  LongInt;
                         Mode     :  Byte;
                         ProgBar  :  TSFProgressBar);

procedure SetDocGLCtrl(var TotalCount, LCount: LongInt; var RunOk: Boolean;
  ProgBar: TSFProgressBar);

Procedure DeleteDupYTDHist (Var RunOk :  Boolean;
                          Var TotalCount,
                              RCount,
                              MFind    :  LongInt;
                              ProgBar  :  TSFProgressBar);

procedure Reset_MarlowWOR(var RunOk       : Boolean;
                          var TotalCount,
                              MFind       : LongInt;
                              ProgBar     : TSFProgressBar);

Procedure DeleteOrphanXDNLines (Var RunOk                     :  Boolean;
                                Var TotalCount, RCount, MFind :  LongInt;
                                    ProgBar                   :  TSFProgressBar);

// Runs through InvF and for any PJC/PJI transactions with a Run No of -19 it changes
// the Transaction Header and Line Run No's to 0
Procedure FixPJXRunNumbers (Var RunOk                     :  Boolean;
                            Var TotalCount, RCount, MFind :  LongInt;
                                ProgBar                   :  TSFProgressBar);

{
  PopulateAccountCodes (SF 121)

  This is related to Fault Log Ref. 20051129101807, a fault reported against
  the Visual Report Writer, but which turned out to be a bug in Exchequer
  resulting in Account Codes being omitted from Transaction Lines generated as
  part of the Batch Procedures for Purchase Payments and Sales Receipts. This
  Special Function populates the Account Code field where it has been left
  empty for these transaction types.

  -- CJS 28/01/2009
}
procedure PopulateAccountCodes(var RunOk                    : Boolean;
                               var TotalCount, RCount, MFind: LongInt;
                               ProgBar                      : TSFProgressBar);

procedure CopyCostOfSales(var RunOk                    : Boolean;
                          var TotalCount, MFind, RCount: LongInt;
                          FromDate, ToDate             : string;
                          ProgBar                      : TSFProgressBar);

procedure RemoveStockLocationRecords(var RunOk: Boolean; var TotalCount, Count,
  RCount: LongInt; ProgBar: TSFProgressBar);

{
  CJS 2010-10-20 Used internally by ReinstateWORs() (SF 126) - v6.9 - ABSEXCH-11368
}
function IsOutstanding(Var RunOk     : Boolean;
                       ProgBar   : TSFProgressBar)  :  Boolean;
{
  CJS 2010-10-20 Reinstate outstanding WORs (SF 126) - v6.9 - ABSEXCH-11368

  This searches for any WOR which have been posted but which still have items
  outstanding on them, and reinstates these as unposted.
}
procedure ReinstateWORs(var TotalCount : LongInt;
                            LCount     :  LongInt;
                            RCount     : Integer;
                        var RunOk      :  Boolean;
                            ProgBar    :  TSFProgressBar);

{
  CJS 2010-10-25 Used internally by MoveSRNs() (SF 127) - v6.9 - ABSEXCH-10890
}
procedure UpdateTransactionLines(FolioNo     : Integer;
                                 var RunOk   :  Boolean;
                                     ProgBar :  TSFProgressBar);
{
  CJS 2010-10-25 Move misplaced SRNs (SF 127) - v6.9 - ABSEXCH-10890

  Searches for any SRNs which have a run number of 0, and amends it to -125
  (unposted), updating any attached transaction lines to ensure that they have
  a run number of zero.
}
procedure MoveSRNs(var TotalCount : LongInt;
                       LCount     :  LongInt;
                       RCount     : Integer;
                   var RunOk      :  Boolean;
                       ProgBar    :  TSFProgressBar);


//PR: 07/03/2012 ABSEXCH-12034 Function to iterate through unposted WORs and delete any which have no lines.
procedure DeleteWORsWithNoLines(var TotalCount   : LongInt;
                                var CheckedCount : LongInt;
                                var DeletedCount : LongInt;
                                var RunOk        :  Boolean;
                                    ProgBar      :  TSFProgressBar);

//PR: 08/03/2012 ABSEXCH-11640 Function to iterate through WOR Lines and delete any which have no header.
procedure DeleteWORLinesWithNoHeader(var TotalCount   : LongInt;
                                     var CheckedCount : LongInt;
                                     var DeletedCount : LongInt;
                                     var RunOk        :  Boolean;
                                         ProgBar      :  TSFProgressBar);

procedure FindEmptyTransactions(var TotalCount : LongInt;
                                var LCount     :  LongInt;
                                var RCount     : Integer;
                                var RunOk      :  Boolean;
                                    ProgBar    :  TSFProgressBar);

procedure FixEmptyTransactions(var TotalCount : LongInt;
                               var LCount     :  LongInt;
                               var RCount     : Integer;
                               var RunOk      :  Boolean;
                                   ProgBar    :  TSFProgressBar);

procedure FixTransactionLineDates(var TotalCount : LongInt;
                                  var LCount     :  LongInt;
                                  var RCount     : Integer;
                                  var RunOk      :  Boolean;
                                      ProgBar    :  TSFProgressBar);

procedure FixTransactionHeader(var TotalCount : LongInt;
                               var LCount     : LongInt;
                               var RCount     : Integer;
                               var RunOk      : Boolean;
                                   ProgBar    : TSFProgressBar);

// CJS 2013-10-18 - ABSEXCH-14703 - copy delivery address line 5 to postcode
procedure CopyToPostcode(var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

procedure RemoveErroneousB2BFolios(var RunOk: Boolean;
                                   var TotalCount, LCount: LongInt;
                                       ProgBar:  TSFProgressBar);

// 147 - CJS 2014-09-25 - ABSEXCH-15658 - Multiple ADJ lines cause posting run to hang
procedure RemoveErroneousAdjustmentLines(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// CJS 2014-12-01 - SF 148 - Order Payments - T109 - Clear legacy Credit Card Fields in CUSTSUPP
procedure PurgeLegacyCreditCardDetails(var TotalCount : LongInt;
                                       var LCount     : LongInt;
                                       var RCount     : Integer;
                                       var RunOk      : Boolean;
                                           ProgBar    : TSFProgressBar);

// CJS 2014-12-02 - SF 149 - Order Payments - T224 - Set Country Code
procedure SetCountryCode(var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// CJS 2015-01-16 - SF 151 - Order Payments - T224 - Set Country Code
procedure SetAccountContactCountryCode(var TotalCount : LongInt;
                                       var LCount     : LongInt;
                                       var RCount     : Integer;
                                       var RunOk      : Boolean;
                                           ProgBar    : TSFProgressBar);

// CJS 2015-03-03 - ABSEXCH-16154 - remove tab characters from transaction line descriptions
procedure RemoveTabCharacters(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// CJS 2015-10-05 - ABSEXCH-16340 - SQL script for reordering transactions
procedure ReorderTransactions(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// CJS 2015-10-06 - ABSEXCH-16838 - transaction delivery address country code
procedure UpdateTransactionCountryCodes(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// PR: 25/11/2015 - ABSEXCH-17001 - Clear random data from Syss.Spare600
procedure CleanSpare600(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);

// CJS 2016-04-20 - ABSEXCH-17432 - SF to clear transaction Intrastat details
procedure ClearIntrastatFields(var TotalCount : LongInt;
                               var LCount     : LongInt;
                               var RCount     : Integer;
                               var RunOk      : Boolean;
                                   ProgBar    : TSFProgressBar);

// CJS 2016-06-03 - ABSEXCH-17495 - move VAT Submission response to correct company
procedure MoveVATSubmission(var RCount: LongInt; var RunOk: Boolean);

//PR: 06/09/2016 ABSEXCH-17700 Remove redundant control lines (Crane Asia)
procedure DeleteRedundantControlLines(var TotalCount : LongInt;
                                      var LCount     : LongInt;
                                      var RCount     : Integer;
                                      var RunOk      : Boolean;
                                          ProgBar    : TSFProgressBar);

//PR: 13/09/2016 ABSEXCH-17636 Remove History records with year of 255
procedure DeleteFutureHistoryRecords(var TotalCount : LongInt;
                                     var LCount     : LongInt;
                                     var RCount     : Integer;
                                     var RunOk      : Boolean;
                                         ProgBar    : TSFProgressBar);

//AP : 14/02/2017 2017-R1 ABSEXCH-15554 : Update manlly Our ref field in Transaction Line based on Documents table
procedure UpdateTransactionLineOurRef(var TotalCount : LongInt;
                                     var LCount     : LongInt;
                                     var RCount     : Integer;
                                     var RunOk      : Boolean;
                                         ProgBar    : TSFProgressBar);    

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     Windows,
     SysUtils,
     Messages,
     Controls,
     Dialogs,
     Forms,
     VarRec2U,
     VarFPosU,
     ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2,
     UnTils,
     Rebuld1U,
     ReBuld2U,
     SetTrans,
     SetTransLineDate,
     SF147SelectionFrmU,
     PurgeLegacyCreditCardDetailsF,
     SetCountryCodeF,
     oAccountContactBtrieveFile,
     oBtrieveFile,
     SQLUtils,
     SQLCallerU,
     SQLReorder,
     oVat100BtrieveFile;

Var
  ProgressCounter  :  LongInt;

Procedure Test_V5DocIndex(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              ProgBar
                                    :  TSFProgressBar);
Const
  Fnum  =  InvF;

Var
  RecPos :  Integer;
  DocFS  :  FullFileKeySpec;
  GenStr :  Str255;

Begin
  Write_FixLogFmt(FNum,'Test for new unallocated index',3);

  DocFS:=GetFullFile_StatCId(F[Fnum],Fnum,Nil);

  GenStr:='This Exchequer data set ';

  RecPos:=BtKeyPos(@Inv.CustCode,@Inv)+1;

  If (DocFS.Ks[21].KeyPos=RecPos) then
    Write_FixLogFmt(FNum,GenStr+'does support the new allocation routines',3)
  else
    Write_FixLogFmt(FNum,'Document.dat needs to be rebuilt in order to support the new allocation routines. Key Pos : '+Form_Int(DocFS.Ks[21].KeyPos,0),3);

  Write_FixLogFmt(FNum,'',3);

  If (DocFS.Ks[19].Keyflags AND AltColSeq <> AltColSeq) then
    Write_FixLogFmt(FNum,'The check for advanced periods during revaluations will be quick.',3)
  else
    Write_FixLogFmt(FNum,'Document.dat needs to be rebuilt in order to speed up the check for unposted transactions during revaluation.',3);


end;


{ ====== Procedure to Reset the Loc field and pad it to 3 chars ====== }

Procedure Set_CCDPad(Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         ProgBar
                               :  TSFProgressBar);


Const
  FnumIdx   : Array[0..2] of Integer = (CustF,IdetailF,StockF);

  Keypath   =  0;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  Fnum    :  Integer;

  Ok2Store,

  Loop,
  NoDocH,
  FDocH   :  Boolean;



Begin

  LoopCtrl:=0; Loop:=BOff;

  Repeat
    KeyChk:='';

    KeyS:=KeyChk;

    Fnum:=FnumIdx[LoopCtrl];

    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    Begin

      Ok2Store:=BOff;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));

      Case LoopCtrl of

        0    :  With Cust do
                 Begin
                   Ok2Store:=((CustCC<>'') and (Length(CustCC)<>CCDpKeyLen)) or ((CustDep<>'') and (Length(CustDep)<>CCDpKeyLen));

                   If (Ok2Store) then
                   Begin
                     CustCC:=FullCCDpKey(CustCC);
                     CustDep:=FullCCDpKey(CustDep);

                   end;

                 end;


        1    :  With Id do
                 Begin
                   Ok2Store:=((CCDep[BOff]<>'') and (Length(CCDep[BOff])<>CCDpKeyLen)) or ((CCDep[BOn]<>'') and (Length(CCDep[BOn])<>CCDpKeyLen));

                   If (Ok2Store) then
                   Begin
                     For Loop:=BOff to BOn do
                       CCDep[Loop]:=FullCCDpKey(CCDep[Loop]);
                   end;
                 end;

        2     :  With Stock do
                 Begin
                   Ok2Store:=((CCDep[BOff]<>'') and (Length(CCDep[BOff])<>CCDpKeyLen)) or ((CCDep[BOn]<>'') and (Length(CCDep[BOn])<>CCDpKeyLen));

                   If (Ok2Store) then
                   Begin
                     For Loop:=BOff to BOn do
                       CCDep[Loop]:=FullCCDpKey(CCDep[Loop]);
                   end;

                 end;

      end; {Case..}


      If (Ok2Store) then
      Begin

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      end;


      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),3);

      end;


      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;


      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Inc(LoopCtrl);

  Until (LoopCtrl>2) or (Not RunOk);


  TotalCount:=MFind;

end; {Proc..}


{ ====== Procedure to Reset the currency settled amount ====== }

Procedure Reset_SterSettle(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               MCMode:  Byte;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvOurRefK;


Var
  KeyS,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  SysOk,
  SLocked,
  FDocH   :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=BOff;

  If (MCMode<>95) then
  Begin
    With SyssCurr do
    Begin
      With Currencies[0] do
      Begin
        CRates[BOff]:=1;
        CRates[BOn]:=1;


      end;

      With Currencies[1] do
      Begin
        CRates[BOff]:=1;
        CRates[BOn]:=1;
      end;
    end;
  end
  else
  Begin
    SysOk:=BOff;  SLocked:=BOff;

    GetMultiSys(BOff,SysOk,SysR);
  end;


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    {If (OurRef='SRC000714') or (OurRef='SRC000365') then
      Beep;}

    If (RunNo>=0) and (NomAuto) and (((Currency=0) and (MCMode=94)) or ((Currency=1) and (MCMode=20)) or ((Currency>0) and (MCMode=95))) then
    Begin
      If (BaseTotalOS(Inv)=0.0) and (CurrencyOS(Inv,BOn,BOff,BOff)<>0.0) then
      Begin

        CurrSettled:=ITotal(Inv)*DocCnst[InvDocHed]*DocNotCnst;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),3);

        end;


        RunOk:=(RunOk and (Status In [0,5]));

      end;
    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;



    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  TotalCount:=MFind;

end; {Proc..}




{ ====== Procedure to reset OrdMatch on all non SPOP based transactions  ====== }

Procedure RepairDiscRecs(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;

  Fnum2     =  CustF;
  Keypath2  =  CustCodeK;

  Fnum3     =  StockF;
  Keypath3  =  StkFolioK;
  Keypath4  =  StkCodeK;



Var
  KeyL,
  KeyS,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  B_Func  :  Integer;

  Ok2Del  :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=0;


  Repeat
    Case LoopCtrl of
      0  :  Begin
              KeyI:=QBDiscCode+QBDiscSub;
            end;
      1,2
         :  Begin
              KeyI:=QBDiscCode+TradeCode[LoopCtrl=2];
            end;

      3,4
         :  Begin
              KeyI:=CDDiscCode+TradeCode[LoopCtrl=4];
            end;
    end; {Case..}


    KeyS:=KeyI;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (Copy(KeyS,1,2)=Copy(KeyI,1,2)) do
    With MiscRecs^ do
    Begin
      Ok2Del:=BOff;

      B_Func:=B_GetNext;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));

      Case LoopCtrl of
        0  :  With QtyDiscRec do
              Begin
                KeyL:=Copy(DiscQtyCode,1,4);

                Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyL);

                Ok2Del:=(Status<>0);
              end;
        1,2
           :  With QtyDiscRec do
              Begin
                KeyL:=Copy(DiscQtyCode,1,6);

                Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyL);

                Ok2Del:=(Status<>0);

                If (Not Ok2Del) then
                Begin
                  KeyL:=Copy(DiscQtyCode,7,4);

                  Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyL);

                  Ok2Del:=(Status<>0);

                end;
              end;
        3,4
           :  With CustDiscRec do
              Begin
                KeyL:=Copy(DiscCode,1,6);

                Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyL);

                Ok2Del:=(Status<>0);

                If (Not Ok2Del) then
                Begin
                  KeyL:=QStkCode;

                  Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath4,KeyL);

                  Ok2Del:=(Status<>0);

                end;
              end;



      end; {Case..}

      If (Ok2Del) then
      Begin

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Discount record '+KeyS+', report error '+Form_Int(Status,0),0);

        end
        else
        Begin
          B_Func:=B_GetGEq;

          Write_FixLogFmt(FNum,'Deleted Discount Record record '+KeyS,0);
        end;

        RunOk:=(RunOk and (Status In [0,5]));

      end;

      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;


      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Inc(LoopCtrl);


  Until (LoopCtrl>4) or (Not RunOk);

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



Procedure Del_FIFORecs(Var RunOk    :  Boolean;
                       Var TotalCount,
                           LCount   :  LongInt;
                           Mode     :  Byte;
                           ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;

  Fnum3     =  StockF;
  Keypath3  =  StkFolioK;


Var
  KeyF,
  KeyChk,
  KeyS  :  Str255;

  B_Func:  Integer;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  TimeR :  TimeTyp;


Begin
  KeyChk:=MFIFOCode+MFIFOSub;

  KeyS:=KeyChk; 

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Repairing FIFO Records';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MiscRecs^,FIFORec do
  Begin
    Ok2Store:=BOff;  B_Func:=B_GetNext;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;

    Ok2Store:=(Length(FIFOCode)<>12);


    If (Ok2Store) then
    Begin
      KeyF:=FullNomKey(StkFolio);

      Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyF);


      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete FIFO record for '+DocRef+', for Stock Code '+Stock.StockCode+'. report error '+Form_Int(Status,0),0);

      end
      else
      Begin
        B_Func:=B_GetGEq;

        Write_FixLogFmt(FNum,'Deleted FIFO Record record for'+DocRef+', for Stock Code '+Stock.StockCode,0);
      end;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}


Procedure Reset_BOMSoldRecs(Var RunOk    :  Boolean;
                            Var TotalCount,
                                LCount   :  LongInt;
                                Mode     :  Byte;
                                ProgBar
                                         :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MiscNDXK;


Var
  KeyF,
  KeyChk,
  KeyS  :  Str255;

  B_Func:  Integer;

  SysOk,
  SLocked,
  Ok2Store
        :  Boolean;

  n     :  Byte;

  TimeR :  TimeTyp;


Begin
  KeyChk:=MFIFOCode+MSERNSub;

  KeyS:=KeyChk;

  SysOk:=BOff;  SLocked:=BOff;

  GetMultiSys(BOff,SysOk,SysR);


  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Resetting Batch Records';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MiscRecs^,SerialRec do
  Begin
    Ok2Store:=BOff;  B_Func:=B_GetNext;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;

    Ok2Store:=(Not BatchChild) and (Not Sold) and (BatchRec) and (Round_Up(BuyQty-QtyUsed,Syss.NoQtyDec)=0.0);


    If (Ok2Store) then
    Begin
      QtyUsed:=BuyQty;
      Sold:=BOn;

      SerialCode:=MakeSNKey(StkFolio,Sold,SerialNo);


      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPAth);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to correct Batch record for '+BatchNo+'. report error '+Form_Int(Status,0),0);

      end
      else
      Begin
        Write_FixLogFmt(FNum,'Reset Batch Record '+BatchNo,0);
      end;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}

Procedure DeleteAuditNotes1(Code  :  AnyStr;
                            Fnum  :  Integer;
                            KLen  :  Integer;
                            KeyPth:  Integer;
                        Var RunOk :  Boolean;
                            ProgBar
                                  :  TSFProgressBar);


Const
  MatchLine  =  'was created by';

Var
  KeyS,
  KeyN  :  AnyStr;
  Locked:  Boolean;

Begin
  KeyS:=Code; Locked:=BOff;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) and (RunOk) do
  With Password.NotesRec do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    If (Match_Glob(Succ(Length(NoteLine)),MatchLine,NoteLine,Locked)) then
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

      Inc(ProgressCounter);
    end;


    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


  end;
end;

{ ============= Procedure to Delete Cust / Docs Notes =========== }

Procedure DeleteAuditNotes2(NoteType  :  Char;
                            NoteFolio :  Str10;
                        Var RunOk     :  Boolean;
                            ProgBar
                                      :  TSFProgressBar);


Const
  Fnum      =  PWrdF;

  Keypath   =  PWk;

Var
  GenStr    :  Str255;


Begin

  GenStr:=PartNoteKey(NoteTCode,NoteType,FullNCode(NoteFolio));

  DeleteAuditNotes1(GenStr,Fnum,Length(GenStr),Keypath,RunOk,ProgBar);

end;

Procedure Del_DocAuditNotes(Var TotalCount,
                            LCount:  LongInt;
                        Var RunOk :  Boolean;
                            ProgBar
                                  :  TSFProgressBar);



Const
  Fnum     =  InvF;
  Keypath  =  InvOurRefK;



Var

  KeyChk,
  KeyS     :  Str255;

  B_Func   :  Integer;



Begin
  ProgressCounter:=0;

  FillChar(KeyChk,Length(KeyChk),0);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv  do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    B_Func:=B_StepNext;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=LCount;

    If (NLineCount>0) then
      DeleteAuditNotes2(NoteDCode,FullNomKey(FolioNum),RunOk,ProgBar) ; {* Auto Delete Audit Notes *}


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  Write_FixLogFmt(FNum,'',0);

  Write_FixLogFmt(FNum,'Number of Notes Deleted :'+Form_Int(ProgressCounter,0),3);

end; {Proc..}


{ ====== Procedure to Reset the currency settled amount ====== }

Procedure Reset_AllocStat(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              MCMode:  Byte;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvOurRefK;


Var
  KeyS,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  SysOk,
  SLocked,
  FDocH   :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=BOff;

  Begin
    With SyssCurr do
    Begin
      With Currencies[0] do
      Begin
        CRates[BOff]:=1;
        CRates[BOn]:=1;


      end;

      With Currencies[1] do
      Begin
        CRates[BOff]:=1;
        CRates[BOn]:=1;
      end;
    end;
  end;


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    {If (OurRef='SRC000714') or (OurRef='SRC000365') then
      Beep;}

    If (RunNo>=0) and (NomAuto)  then
    Begin
      If (BaseTotalOS(Inv)=0.0) and (CurrencyOS(Inv,BOn,BOff,BOff)=0.0) and (AllocStat<>#0) then
      Begin

        Inv.AllocStat:=#0;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to file for '+Inv.OurRef+', report error '+Form_Int(Status,0),3);

        end
        else
        Begin

          Write_FixLogFmt(FNum,'Corrected allocation status for '+Inv.OurRef+'. A/C : '+CustCode+'.'+PoutDate(TransDate) ,3);

        end;


        RunOk:=(RunOk and (Status In [0,5]));

      end;
    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;



    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  TotalCount:=MFind;

end; {Proc..}


{ ====== Procedure to delete any unposed runtime lines ====== }

Procedure Clean_StkTypeFlg(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum      =  IdetailF;
  Keypath   =  IdRunK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  FDocH   :  Boolean;



Begin

  LoopCtrl:=BOff;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Repairing corrupt stock flag';

  While (StatusOk) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    If (StockCode<>'') and (LineType=#0) and (IdDocHed In SalesSplit+PurchSplit+StkAdjSplit-RecieptSet-BatchSet) then
    Begin
      LineType:=StkLineType[IdDocHed];

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);


      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;



    end; {If Run time line..}


    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  TotalCount:=MFind;

end; {Proc..}


{ ====== Procedure to reset OrdMatch on all non SPOP based transactions  ====== }

Procedure DeleteSerialBatchRecs(Var RunOk :  Boolean;
                                Var TotalCount,
                                    MFind :  LongInt;
                                    ProgBar
                                          :  TSFProgressBar;
                                    DMode :  Byte);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;



Var
  KeyL,
  KeyS,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  B_Func  :  Integer;

  Ok2Del  :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=0;


  KeyI:=PartccKey(MFIFOCode,MSERNSub);

  KeyS:=KeyI;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (Copy(KeyS,1,2)=Copy(KeyI,1,2)) do
  With MiscRecs^ do
  Begin
    Ok2Del:=(DMode=0) or (Copy(SerialRec.InDoc,1,3)='POR');

    B_Func:=B_GetNext;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    If (Ok2Del) then
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      With SerialRec do
      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete Serial record '+SerialNo+'/'+BatchNo+', report error '+Form_Int(Status,0),0);

      end
      else
      Begin
        B_Func:=B_GetGEq;

        Write_FixLogFmt(FNum,'Deleted Serial Record record '+SerialNo+'/'+BatchNo,0);
      end;

      RunOk:=(RunOk and (Status In [0,5]));

      Inc(MFind);
    end;

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


{ ====== Procedure to delete any unposed runtime lines ====== }

Procedure Clean_PaymentFlg(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum      =  IdetailF;
  Keypath   =  IdRunK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  FDocH   :  Boolean;



Begin

  LoopCtrl:=BOff;

  KeyChk:=FullNomKey(0);
  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Repairing corrupt reconcile flag';

  While (StatusOk) and (RunOk) and (Id.PostedRun=0) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    If (Payment<>DocPayType[IdDocHed])  and ((LineNo<>RecieptCode) or (Not (IdDocHed In DirectSet))) and (NetValue<>0.0) and (Not (IdDocHed In JapSplit)) then
    Begin
      KeyI:=Payment;

      Payment:=DocPayType[IdDocHed];

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);


      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end
      else
        Write_FixLogFmt(FNum,'Updated  '+DocPRef+' Line '+Form_Int(LineNo,0)+'. Was '+KeyI+', now '+Payment,4);



    end; {If Run time line..}


    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  TotalCount:=MFind;

end; {Proc..}



Procedure Reset_GreencoreSIN(Var RunOk :  Boolean;
                             Var TotalCount,
                                 MFind :  LongInt;
                                 ProgBar
                                       :  TSFProgressBar);


  Const
    Fnum      =  IdetailF;
    Keypath   =  IdFolioK;


  Var
    KeyS,
    KeyI    :  Str255;

    LoopCtrl,
    NoDocH,
    FDocH   :  Boolean;



  Begin

    KeyS:=FullNomKey(135839);

    LoopCtrl:=BOff;
    

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (Id.FolioRef=135839) and (RunOk) do
    With Id do
    Begin
      If (Qty<>0) and (PDate='') then
      Begin
        PDate:='20040610';
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      end;

      If (Not StatusOk) then
      Begin
        Write_FixLog(FNum,'Unable to write data to file, report error '+Form_Int(Status,0));

      end;


      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    If Assigned(ProgBar) then
      ProgBar.ProgressBar1.Position:=TotalCount;


  end; {Proc..}

  { ====== Procedure to Scan all Stock records, and set the Note Counter to 1 ====== }

  Procedure Set_StockNoteC(Var RunOk :  Boolean;
                           Var MFind,
                               TotalCount
                                     :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


  Const
    Fnum      =  StockF;


  Var
    KeyS    :  Str255;



  Begin

    KeyS:='';

    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With Stock do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));



      NLineCount:=1;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;

      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=MFind;


      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    end; {While..}

    If (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=TotalCount;

  end; {Proc..}


  Procedure Del_DupliLocRecs(Var RunOk    :  Boolean;
                             Var TotalCount,
                                 LCount   :  LongInt;
                                 Mode     :  Byte;
                                 ProgBar
                                          :  TSFProgressBar);


  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;


  Var
    KeyF,
    KeyChk,
    KeyS  :  Str255;

    PrevCode
          :  Str20;

    B_Func:  Integer;

    Ok2Store
          :  Boolean;

    n     :  Byte;

    TimeR :  TimeTyp;


  Begin
    KeyChk:=CostCCode+CSubCode[BOn];

    KeyS:=KeyChk; FillChar(PrevCode,SizeOf(PrevCode),#0);


    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Checking for duplicate Location Records';

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With MLocCtrl^,MLocLoc do
    Begin
      Ok2Store:=BOff;  B_Func:=B_GetNext;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=LCount;

      Ok2Store:=(CheckKey(loCode,PrevCode,Length(PrevCode),BOff) and (Trim(PrevCode)<>''));


      If (Ok2Store) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Master Loc record '+loCode+'. report error '+Form_Int(Status,0),0);

        end
        else
        Begin
          B_Func:=B_GetGEq;

          Write_FixLogFmt(FNum,'Deleted Master Loc record '+loCode,0);

          FillChar(PrevCode,SizeOf(PrevCode),#0);
        end;

      end
      else
        PrevCode:=loCode;

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

  end; {Proc..}



  Procedure Del_DeadBinChildRecs(Var RunOk    :  Boolean;
                                 Var TotalCount,
                                     LCount   :  LongInt;
                                     Mode     :  Byte;
                                     ProgBar
                                              :  TSFProgressBar);


  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

    Fnum3     =  StockF;
    Keypath3  =  StkFolioK;

  Var
    KeyF,
    KeyChk,
    KeyS  :  Str255;

    B_Func:  Integer;

    Ok2Store
          :  Boolean;

    n     :  Byte;

    TimeR :  TimeTyp;


  Begin
    KeyChk:=BRRecCode+MSERNSub;

    KeyS:=KeyChk;


    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Checking for redundant Bin Usage Records';

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With MLocCtrl^,brBinRec do
    Begin
      Ok2Store:=BOff;  B_Func:=B_GetNext;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=LCount;

      Ok2Store:=(brBatchChild and (Round_Up(brQtyUsed,3)=0.0));


      If (Ok2Store) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        KeyF:=FullNomKey(brStkFolio);

        Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyF);

        With Stock do
        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Bin usage record '+brBinCode1+' for stock code '+Trim(StockCode)+','+Trim(Desc[1])+'. report error '+Form_Int(Status,0),0);

        end
        else
        Begin

          B_Func:=B_GetGEq;

          {Write_FixLogFmt(FNum,'Deleted Bin usage record record '+brBinCode1+' for stock code '+Trim(StockCode)+','+Trim(Desc[1]),0);}
        end;

      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

  end; {Proc..}


  Procedure Del_DeadBinMasterRecs(Var RunOk    :  Boolean;
                                 Var TotalCount,
                                     LCount   :  LongInt;
                                     Mode     :  Byte;
                                     ProgBar
                                              :  TSFProgressBar);


  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

    Fnum3     =  StockF;
    Keypath3  =  StkFolioK;

  Var
    KeyF,
    KeyChk,
    KeyS  :  Str255;

    B_Func:  Integer;

    Ok2Store
          :  Boolean;

    n     :  Byte;

    TimeR :  TimeTyp;


  Begin
    KeyChk:=BRRecCode+MSERNSub;

    KeyS:=KeyChk;


    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Checking for redundant Bin Master Records';

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With MLocCtrl^,brBinRec do
    Begin
      Ok2Store:=BOff;  B_Func:=B_GetNext;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=LCount;

      Ok2Store:=(Not brBatchChild) and (Not brSold and (Round_Up(brBuyQty-brQtyUsed,Syss.NoQtyDec)<=0));

      If (Ok2Store) then
      Begin
        KeyF:=FullNomKey(brStkFolio);

        Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyF);
      end;

      If (Ok2Store) and (StatusOk) then
      Begin

        If (Not Syss.KeepBinHist) and (Not (CheckKey(Stock.BinLoc,brBinCode1,Length(Stock.BinLoc),BOff))) then
          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath)
        else
        Begin
          brSold:=BOn;

          brCode2:=FullBinCode2(brStkFolio,brSold,brInMLoc,brPriority,brDateIn,brBinCode1);

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
        end;


        With Stock do
        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Bin Master record '+brBinCode1+' for stock code '+Trim(StockCode)+','+Trim(Desc[1])+'. report error '+Form_Int(Status,0),0);

        end
        else
        Begin

          B_Func:=B_GetGEq;

          {Write_FixLogFmt(FNum,'Deleted Bin usage record record '+brBinCode1+' for stock code '+Trim(StockCode)+','+Trim(Desc[1]),0);}
        end;

      end;

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

  end; {Proc..}


  Procedure Del_DupliJCtrlRecs(Var RunOk    :  Boolean;
                               Var TotalCount,
                                   LCount   :  LongInt;
                                   Mode     :  Byte;
                                   ProgBar
                                            :  TSFProgressBar);


    Const
      Fnum      =  JCtrlF;
      Keypath   =  JCK;


    Var
      KeyF,
      KeyChk,
      KeyS  :  Str255;

      PrevCode
            :  Str20;

      B_Func:  Integer;

      Ok2Store,
      Ok2Store2
            :  Boolean;

      n     :  Byte;

      TimeR :  TimeTyp;

      PrevJBR
            :  JobCtrlRec;


    Begin
      KeyChk:=PartCCKey(JBRCode,JBMCode);

      KeyS:=KeyChk; FillChar(PrevCode,SizeOf(PrevCode),#0);

      FillChar(PrevJBR,SizeOf(PrevJBR),#0);


      If (Assigned(ProgBar)) then
        ProgBar.ProgLab.Caption:='Checking for duplicate Job Category Records';

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With JobCtrl^.JobBudg do
      Begin
        Ok2Store:=BOff;  B_Func:=B_GetNext; Ok2Store2:=BOff;

        Application.ProcessMessages;

        If (Assigned(ProgBar)) then
          RunOk:=(Not (ProgBar.Aborted));


        Inc(LCount);

        If (LCount<TotalCount) and (Assigned(ProgBar)) then
            ProgBar.ProgressBar1.Position:=LCount;

        Ok2Store:=(HistFolio>190) and (HistFolio<999);

        If (Not Ok2Store) then
          Ok2Store2:=((PrevJBR.JobBudg.HistFolio=HistFolio) and (PrevJBR.JobBudg.AnalHed=AnalHed) and (PrevJBR.JobBudg.BudgetCode=BudgetCode));


        If (Ok2Store) or (Ok2Store2) then
        Begin
          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          If (Not StatusOk) then
          Begin

            Write_FixLogFmt(FNum,'Unable to delete JobCtrl record '+BudgetCode+'. report error '+Form_Int(Status,0),0);

          end
          else
          Begin
            If (Not Ok2Store2) then
              B_Func:=B_GetGEq;

            Write_FixLogFmt(FNum,'Deleted Job Ctrl  record '+BudgetCode,0);

          end;

        end
        else
          PrevJBR:=JobCtrl^;

        Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

    end; {Proc..}


  Procedure Del_TeleSalesCtrlRecs(Var RunOk    :  Boolean;
                                  Var TotalCount,
                                      LCount   :  LongInt;
                                      Mode     :  Byte;
                                      ProgBar
                                               :  TSFProgressBar);


  Const
    Fnum      =  MLocF;
    Keypath   =  MLK;

  Var
    KeyF,
    KeyChk,
    KeyS  :  Str255;

    B_Func:  Integer;

    Ok2Store
          :  Boolean;

    n     :  Byte;

    TimeR :  TimeTyp;


  Begin
    KeyChk:=MatchTCode+PostLCode;

    KeyS:=KeyChk;


    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Resetting TeleSales Control Records';

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With MLocCtrl^,TeleSRec do
    Begin
      Ok2Store:=BOff;  B_Func:=B_GetNext;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=LCount;

      Ok2Store:=BOn;


      If (Ok2Store) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete TS Control record '+tcCustCode+' for Operator '+Trim(tcLastOpo)+'. report error '+Form_Int(Status,0),0);

        end
        else
        Begin

          B_Func:=B_GetGEq;

          {Write_FixLogFmt(FNum,'Deleted Bin usage record record '+brBinCode1+' for stock code '+Trim(StockCode)+','+Trim(Desc[1]),0);}
        end;

      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

  end; {Proc..}


  { ====== Procedure to Reset the Loc field and pad it to 3 chars ====== }


Procedure Set_MLFPad(Var RunOk :  Boolean;
                     Var TotalCount,
                         LCount:  LongInt;
                         Mode     :  Byte;
                         ProgBar  :  TSFProgressBar);

Const
  FnumIdx   : Array[0..3] of Integer = (CustF,IdetailF,StockF,InvF);



Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  B_Func,
  B_Func2,
  Keypath,
  Fnum    :  Integer;

  Ok2Store,

  NoDocH,
  FDocH   :  Boolean;



Begin

  LoopCtrl:=0;

  Repeat
    KeyChk:='';

    B_Func:=B_StepFirst;
    B_Func2:=B_StepNext;

    Keypath:=0;

    Fnum:=FnumIdx[LoopCtrl];

    Case LoopCtrl of
      3  :  Begin
              Keypath:=InvOurRefK;

              KeyChk:='WOR';

              B_Func:=B_GetGEq;
              B_Func2:=B_GetNext;
            end;

    end; {Case..}

    KeyS:=KeyChk;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    Begin

      Ok2Store:=BOff;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=LCount;


      Case LoopCtrl of

        0    :  With Cust do
                 Begin
                   Ok2Store:=(DefMLocStk<>'') and (Length(DefMLocStk)<>MLKeyLen);

                   If (Ok2Store) then
                     DefMLocStk:=Full_MLocKey(DefMLocStk);

                 end;


        1    :  With Id do
                 Begin
                   Ok2Store:=(StockCode<>'') and (MLocStk<>'') and (Length(MLocStk)<>MLKeyLen);

                   If (Ok2Store) then
                     MLocStk:=Full_MLocKey(MLocStk);

                 end;

        2     :  With Stock do
                 Begin
                   Ok2Store:=(DefMLoc<>'') and (Length(DefMLoc)<>MLKeyLen);

                   If (Ok2Store) then
                     DefMLoc:=Full_MLocKey(DefMLoc);

                 end;

        3     :  With Inv do
                 Begin
                   Ok2Store:=(Trim(DelTerms)<>'') and (Length(DelTerms)<>MLKeyLen) and (InvDocHed=WOR);

                   If (Ok2Store) then
                     DelTerms:=Full_MLocKey(DelTerms);


                 end;

      end; {Case..}


      If (Ok2Store) then
      Begin

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      end;


      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),0);

      end;



      Status:=Find_Rec(B_Func2,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    Inc(LoopCtrl);

  Until (LoopCtrl>3) or (Not RunOk);


  TotalCount:=LCount;

end; {Proc..}


procedure SetDocGLCtrl(var TotalCount, LCount: LongInt; var RunOk: Boolean;
  ProgBar: TSFProgressBar);
const
  Fnum     = InvF;
  Keypath  = InvRNoK;
  Fnum2    = CustF;
  Keypath2 = CustCodeK;
var
  KeyChk2: Str255;
  KeyChk : Str255;
  KeyS   : Str255;
  Loop   : Boolean;
  B_Func : Integer;
begin

  Loop := BOff;

  B_Func := B_GetNext;

  KeyChk := FullNomKey(0);

  KeyS := KeyChk + #1;

  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  while (StatusOk) and (RunOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), BOn)) do
    with Inv do
    begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk := (Not (ProgBar.Aborted));

      Inc(LCount);

      If (LCount < TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position := LCount;

      if (InvDocHed in SalesSplit + PurchSplit - [SBT, PBT]) then
      begin
        KeyChk2 := FullCustCode(CustCode);

        // Locate the matching Customer/Supplier record.
        If (Cust.CustCode <> CustCode) then
          Status := Find_Rec(B_GetEq, F[Fnum2], Fnum2, RecPtr[Fnum2]^, Keypath2, KeyChk2);

        if (Status = 0) then
        begin
          CtrlNom := Cust.DefCtrlNom;

          Status := Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

          if (not StatusOk) then
          begin
            Write_FixLog(FNum,'Unable to write data to file, report error ' + Form_Int(Status, 0));
          end;

        end;

      end;

      Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

    end; { with Inv do... }

end;

{ ==== Procedure to check if nom is being added into tha P&L section ==== }

Function In_PandL(GLCat  :  LongInt)  :  Boolean;

Const
  Fnum     =  NomF;
  Keypath  =  NomCodeK;

Var
  KeyS,
  KeyChk   :  Str255;


  FoundOk  :  Boolean;

  TmpKPath,
  TmpStat
           : Integer;

  TmpRecAddr,
  PALStart
           :  LongInt;

  TmpNom   :  NominalRec;

Begin
  FoundOk:=BOff;

  TmpNom:=Nom;

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOff,BOff);

  PALStart:=Syss.NomCtrlCodes[PLStart];

  FoundOK:=(GLCat=PALStart);

  If (Not FoundOk) then
  Begin
    KeyChk:=FullNomKey(GLCat);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (Not FoundOk) do
    With Nom do
    Begin
      FoundOk:=(Cat=PALStart);


      If (Not FoundOk) then
      Begin

        KeyChk:=FullNomKey(Cat);

        KeyS:=KeyChk;

        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

      end;
    end; {While..}

  end;


  TmpStat:=Presrv_BTPos(NomF,TmpKPath,F[NomF],TmpRecAddr,BOn,BOff);

  Nom:=TmpNom;


  In_PandL:=FoundOk;

end;


{ ================== Procedure to Delete doubled up ytd history records ============= }


Procedure DeleteDupYTDHist (Var RunOk :  Boolean;
                        Var TotalCount,
                            RCount,
                            MFind    :  LongInt;
                            ProgBar  :  TSFProgressBar);

Const
  Fnum     =  NHistF;
  Keypth   =  NHK;
  Fnum2    =  NomF;
  Keypath2 =  NomCodeK;

  HistTypes :  Array[0..3] of Char = ('A','B','C','H');
  CCDTypes  :  Array[0..2] of Char = (#0,'D','C');


Var
  NCode,
  KeyN,
  KeyS  :  AnyStr;
  Locked,
  SysOk,
  SLocked,

  IsPL,
  Ok2Del:  Boolean;
  LAddr :  LongInt;
  n,m   :  Byte;

  NHR   :  HistoryRec;

Begin
  n:=0;

  SysOk:=BOff;  SLocked:=BOff;

  GetMultiSys(BOff,SysOk,SysR);

  While (N<=High(HistTypes)) and (RunOk) and (SysOk) do
  Begin
    m:=0;

    While (m<=High(CCDTypes)) and (RunOk) do
    Begin


      If (m>0) then
        NCode:=HistTypes[n]+CCDTypes[m]
      else
        NCode:=HistTypes[n];


      KeyS:=NCode;

      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                                {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

      While (Status=0) and (CheckKey(NCode,KeyS,Length(NCode),BOn)) and (RunOk) do
      With NHist do
      Begin
        Inc(MFind);

        Application.ProcessMessages;

        If (Assigned(ProgBar)) then
          RunOk:=(Not (ProgBar.Aborted));

        If (MFind<TotalCount) and (Assigned(ProgBar)) then
        begin
          ProgBar.ProgressBar1.Position:=MFind;
          if ((MFind mod 10) = 0) then
           ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(MFind) + ' records';
        end;

        Ok2Del:=BOff;

        If ((Pr=YTD) or (Pr=YTDNCF)) and ((m=0) or (Length(KeyS)>4)) then
        Begin

          NHR:=NHist;

          Ok2Del:=((Pr=YTD) and (ExClass='A')) or ((Pr=YTDNCF) and (ExClass In ['B','C']));

          If (Not Ok2Del) and (ExClass='H') then {* We need to go find ultimate parent and see if it is the P&L Start *}
          Begin
            KeyN:=Copy(Code,1+Ord(m<>0),4);

            Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyN);

            IsPL:=BOff;

            If (StatusOk) then
            Begin
              If (Nom.Cat=0) then
                IsPL:=(Nom.NomCode=Syss.NomCtrlCodes[PLStart])
              else
                IsPL:=In_PandL(Nom.Cat);

              Ok2Del:=((IsPL) and (Pr=YTD)) or ((Not IsPL) and (Pr=YTDNCF));
            end;
          end;

          If (Ok2Del) then {* Delete the record as confirmed bad *}
          Begin
            Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);


            If (Not StatusOk) then
            Begin

              Write_FixLogFmt(FNum,'Unable to delete History record '+Code+', report error '+Form_Int(Status,0),0);

            end
            else
              Inc(RCount);

          end;
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


      end;

      Inc(m);
    end; {m loop..}

    Inc(n);

  end; {n Loop..}
end;

{ ====== Procedure to reset Variance for Advance corruption  ====== }

procedure Reset_MarlowWOR(var RunOk       : Boolean;
                          var TotalCount,
                              MFind       : LongInt;
                              ProgBar     : TSFProgressBar);
const
  Fnum    = InvF;
  Keypath = InvOurRefK;
var
  KeyS,
  KeyI    :  Str255;
  LoopCtrl,
  NoDocH,
  FDocH   :  Boolean;
begin

  KeyS     := 'WOR003903';
  LoopCtrl := BOff;

  Status := Find_Rec(B_GetEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  if (StatusOk) and (RunOk) then
  with Inv do
  begin
    TotalInvoiced := 0.0;
    TotalReserved := 0.0;
    MFind         := MFind + 1;

    Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, 0);

    if (not StatusOk) then
    begin
      Write_FixLog(FNum,'Unable to write data to file, report error '+Form_Int(Status,0));
    end;

    RunOk := (RunOk and (Status in [0,5]));

  end
  else
  begin
    Write_FixLog(FNum,'Unable to find transaction WOR003903, error ' + Form_Int(Status,0));
  end;

  if Assigned(ProgBar) then
    ProgBar.ProgressBar1.Position := TotalCount;

end;

//-------------------------------------------------------------------------

// Runs through IDetail and deletes any PDN/SDN lines where the header is missing
Procedure DeleteOrphanXDNLines (Var RunOk                     :  Boolean;
                                Var TotalCount, RCount, MFind :  LongInt;
                                    ProgBar                   :  TSFProgressBar);
Var
  lStatus : LongInt;
  KeyIDS, KeyInvS : Str255;
  Lock : Boolean;
Begin // DeleteOrphanXDNLines
  Lock := False;
  GetMultiSys(BOff,Lock,SysR);

  MFind := 0;
  RCount := 0;

  KeyIDS := '';
  lStatus := Find_Rec(B_GetFirst, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);
  While (lStatus = 0) Do
  Begin
    MFind := MFind + 1;
    If ((MFind Mod 100) = 0) Then
    Begin
      If Assigned(ProgBar) then
        ProgBar.ProgressBar1.Position := MFind;

      ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(MFind) + ' records, ' + IntToStr(RCount) + ' orphaned lines deleted';
      Application.ProcessMessages;
    End; // If ((MFind Mod 100) = 0)

    If (Id.IdDocHed In [SDN, PDN]) Then
    Begin
      // Check whether the head exists
      KeyInvS := FullNomKey(Id.FolioRef);
      lStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, KeyInvS);
      If (lStatus = 4) Then
      Begin
        lStatus := Delete_Rec(F[IDetailF], IDetailF, IDFolioK);
        If (lStatus = 0) Then
        Begin
          Write_FixLogFmt (IDetailF,'Deleted orphaned line OurRef="' + Trim(Id.DocPRef) + '"' +
                                 ', Folio=' + IntToStr(Id.FolioRef) +
                                 ', StockCode="' + Trim(Id.StockCode) + '"' +
                                 ', Desc="' + Trim(Id.Desc) + '"' +
                                 ', Qty=' + Trim(Form_Real(Id.Qty, 13, Syss.NoQtyDec)) +
                                 ', OrderFolio=' + IntToStr(Id.SOPLink),
                                 0);
          RCount := RCount + 1;
        End // If (lStatus = 0)
        Else
          Write_FixLogFmt (IDetailF,'Error ' + IntToStr(lStatus) + ' deleting orphaned line OurRef="' + Trim(Id.DocPRef) + '"' +
                                 ', Folio=' + IntToStr(Id.FolioRef) +
                                 ', StockCode="' + Trim(Id.StockCode) + '"' +
                                 ', Desc="' + Trim(Id.Desc) + '"' +
                                 ', Qty=' + Trim(Form_Real(Id.Qty, 13, Syss.NoQtyDec)) +
                                 ', OrderFolio=' + IntToStr(Id.SOPLink),
                                 4);
      End; // If (lStatus = 4)
    End; // If (Id.IdDocHed In [SDN, PDN])

    lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);

//If MFind > 200000 Then lStatus := 9;
  End; // While (lStatus = 0)
End; // DeleteOrphanXDNLines
//-------------------------------------------------------------------------

// Runs through InvF and for any PJC/PJI transactions with a Run No of -19 it changes
// the Transaction Header and Line Run No's to 0
Procedure FixPJXRunNumbers (Var RunOk                     :  Boolean;
                            Var TotalCount, RCount, MFind :  LongInt;
                                ProgBar                   :  TSFProgressBar);
Var
  lStatus : LongInt;
  KeyInvS : Str255;
  LineCount : LongInt;

  //------------------------------

  Function LinesOK (Var LineCount : LongInt) : Boolean;
  Var
    lStatus : LongInt;
    KeyIDS : Str255;
  Begin // LinesOK
    Result := True;
    LineCount := 0;

    KeyIDS := FullNomKey (Inv.FolioNum);
    lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);
    While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do
    Begin
      If (Id.PostedRun = -19) Then
      Begin
        Id.PostedRun := 0;

        lStatus := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
        If (lStatus <> 0) Then
        Begin
          Result := False;
          Write_FixLogFmt (IDetailF,'Error ' + IntToStr(lStatus) + ' updating line OurRef="' + Trim(Inv.OurRef) + '"' +
                                    ', Folio=' + IntToStr(Inv.FolioNum) +
                                    ', LineNo=' + IntToStr(Id.LineNo),
                           4);
        End // If (lStatus <> 0)
        Else
          LineCount := LineCount + 1;
      End; // If (Id.PostedRun = -19)

      lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);
    End; // While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum)
  End; // LinesOK

  //------------------------------

Begin // FixPJXRunNumbers
  MFind := 0;
  RCount := 0;

  // Use the OurRef index and jump in at PJC to pickup all the PJC's and PJI's
  KeyInvS := 'PJC';
  lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyInvS);
  While (lStatus = 0) And (Inv.InvDocHed In [PJC, PJI]) Do
  Begin
    // Update progress
    MFind := MFind + 1;
    If ((MFind Mod 10) = 0) Then
    Begin
      If Assigned(ProgBar) then
        ProgBar.ProgressBar1.Position := MFind;
      ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(MFind) + ' records, ' + IntToStr(RCount) + ' transactions corrected';
      Application.ProcessMessages;
    End; // If ((MFind Mod 10) = 0)

    If (Inv.RunNo = -19) Then
    Begin
      // Run through the lines updating them as well
      If LinesOK (LineCount) Then
      Begin
        // Only update the header if all lines were updated OK - then the SF will still pick them up if it is re-run
        Inv.RunNo := 0;
        lStatus := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvOurRefK);
        If (lStatus = 0) Then
        Begin
          Write_FixLogFmt (IDetailF,'Corrected Transaction "' + Trim(Inv.OurRef) + '"' +
                                    ', ' + IntToStr(LineCount) + ' lines corrected',
                           0);
          RCount := RCount + 1;
        End // If (lStatus = 0)
        Else
          Write_FixLogFmt (IDetailF,'Error ' + IntToStr(lStatus) + ' correcting Transaction "' + Trim(Inv.OurRef) + '"' +
                                    ', ' + IntToStr(LineCount) + ' lines corrected',
                           4);
      End; // If LinesOK
    End; // If (Id.FolioRef = 0)

    lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyInvS);
  End; // While (lStatus = 0) And (Inv.InvDocHed In [PJC, PJI])
End; // FixPJXRunNumbers

//-------------------------------------------------------------------------

procedure PopulateAccountCodes(var RunOk                    : Boolean;
                               var TotalCount, RCount, MFind: LongInt;
                               ProgBar                      : TSFProgressBar);
var
  lStatus: LongInt;
  KeyIdS, KeyInvS: Str255;
  i: Integer;
const
  TranTypeStrings: array[0..1] of string = ('PPY', 'SRC');
  TranTypes: array[0..1] of DocTypes = (PPY, SRC);

  //------------------------------

  Function LinesCheck(CustCode: string): Boolean;
  Var
    lStatus : LongInt;
    KeyIDS : Str255;
  Begin // LinesOK
    Result := True;

    KeyIDS := FullNomKey (Inv.FolioNum);
    lStatus := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);
    While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum) Do
    Begin
      If (Trim(Id.CustCode) = '') Then
      Begin
        Id.CustCode := CustCode;

        lStatus := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
        If (lStatus <> 0) Then
        Begin
          Result := False;
          Write_FixLogFmt (IDetailF,'Error ' + IntToStr(lStatus) + ' updating line OurRef="' + Trim(Inv.OurRef) + '"' +
                                    ', Folio=' + IntToStr(Inv.FolioNum) +
                                    ', LineNo=' + IntToStr(Id.LineNo),
                           4);
        End // If (lStatus <> 0)
        Else
          RCount := RCount + 1;
      End; // If (Id.PostedRun = -19)

      lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, KeyIDS);
    End; // While (lStatus = 0) And (Id.FolioRef = Inv.FolioNum)
  End; // LinesOK

  //------------------------------

begin
  MFind := 0;
  RCount := 0;

  for i := Low(TranTypes) to High(TranTypes) do
  begin
    KeyInvS := TranTypeStrings[i];
    lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyInvS);
    While (lStatus = 0) And (Inv.InvDocHed = TranTypes[i]) Do
    Begin
      // Update progress
      MFind := MFind + 1;
      If ((MFind Mod 10) = 0) Then
      Begin
        If Assigned(ProgBar) then
          ProgBar.ProgressBar1.Position := MFind;
        ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(MFind) + ' records, ' + IntToStr(RCount) + ' transactions corrected';
        Application.ProcessMessages;
      End; // If ((MFind Mod 10) = 0)

      If (Trim(Inv.BatchLink) <> '') Then
      Begin
        // Check and update the lines
        LinesCheck(Inv.CustCode);
      End; // If (Id.FolioRef = 0)

      lStatus := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, KeyInvS);
    end; // While (lStatus = 0) And (Inv.InvDocHed = TranTypes[i])
  end;
end; // PopulateAccountCodes

//-------------------------------------------------------------------------

procedure CopyCostOfSales(var RunOk                    : Boolean;
                          var TotalCount, MFind, RCount: LongInt;
                          FromDate, ToDate             : string;
                          ProgBar                      : TSFProgressBar);
var
  FuncRes: Integer;
  InvKey, IdKey, StockKey: Str255;
  AtLeastOneChanged: Boolean;
begin
  MFind := 0;
  RCount := 0;
  InvKey := FromDate;
  // For each Transaction:
  FuncRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvDateK, InvKey);
  while (FuncRes = 0) and (Inv.TransDate <= ToDate) and (not ProgBar.Aborted) do
  begin
    // Update progress
    MFind := MFind + 1;
    If ((MFind Mod 10) = 0) Then
    Begin
      If Assigned(ProgBar) then
      begin
        ProgBar.ProgressBar1.Position := MFind;
        ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(MFind) + ' records, ' + IntToStr(RCount) + ' transactions corrected';
        Application.ProcessMessages;
      end;
    End; // If ((MFind Mod 10) = 0)
    if (Inv.InvDocHed in [SIN, SCR]) then
    begin
      AtLeastOneChanged := False;
      // Look up the Transaction Lines.
      IdKey := FullNomKey(Inv.FolioNum);
      FuncRes := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, IdKey);
      // For each Transaction Line:
      while (FuncRes = 0) and (Id.FolioRef = Inv.FolioNum) and (not ProgBar.Aborted) do
      begin
        Application.ProcessMessages;
        // If there is a Stock Code:
        if (Trim(Id.StockCode) <> '') then
        begin
          // Look up the Stock record.
          StockKey := Id.StockCode;
          FuncRes := Find_Rec(B_GetGEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, StockKey);

          // Copy the required details from the Stock record.
          if (Trim(Stock.WebLiveCat) <> '') then
          begin
            // The WebLiveCat field is being used to hold the updated Cost of
            // Sales figure.
            Id.LineUser4 := Stock.WebLiveCat;

            // Save the Transaction Line.
            FuncRes := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK);
            if (FuncRes <> 0) then
              Write_FixLogFmt (IDetailF,'Error ' + IntToStr(FuncRes) + ' correcting Transaction "' + Trim(Inv.OurRef) + '"' +
                                        ', ' + IntToStr(RCount) + ' transactions corrected',
                               4);
            AtLeastOneChanged := True;
          end;

        end;

        if AtLeastOneChanged then
          RCount := RCount + 1;

        // Get the next Transaction Line.
        FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, IdKey);

      end;
    end;
    // Get the next Transaction.
    FuncRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvDateK, InvKey);
  end;
  if ProgBar.Aborted then
    Write_FixMsgFmt('Special Function has been aborted.', 4);
end;

//-------------------------------------------------------------------------

procedure RemoveStockLocationRecords(var RunOk: Boolean; var TotalCount, Count,
  RCount: LongInt; ProgBar: TSFProgressBar);
var
  InStock: double;
  FreeStock: double;
  OnOrder: double;
  Key: Str255;
  FuncRes: LongInt;
  MinQty: double;
  MaxQty: double;
begin
  Key := 'CD';
  FuncRes := Find_Rec(B_GetGEq, F[MLocF], MLocF, RecPtr[MLocF]^, 0, Key);
  while (FuncRes = 0) and
        (MLocCtrl^.RecPfix = 'C') and (MLocCtrl^.SubType = 'D') and
        (not ProgBar.Aborted) do
  begin
    Count := Count + 1;
    If ((Count Mod 10) = 0) Then
    Begin
      If Assigned(ProgBar) then
      begin
        ProgBar.ProgressBar1.Position := Count;
        ProgBar.InfoLbl.Caption := 'Checked ' + IntToStr(Count) + ' records, ' + IntToStr(RCount) + ' records corrected';
        Application.ProcessMessages;
      end;
    End; // If ((MFind Mod 10) = 0)
    InStock := MLocCtrl^.MStkLoc.lsQtyInStock;
    FreeStock := 0;
    if (Syss.FreeExAll) then
      FreeStock := MLocCtrl^.MStkLoc.lsQtyInStock
    else
    begin
      if (Syss.UsePick4All) then
        FreeStock := MLocCtrl^.MStkLoc.lsQtyInStock - MLocCtrl^.MStkLoc.lsQtyPicked
      else
        FreeStock := MLocCtrl^.MStkLoc.lsQtyInStock - MLocCtrl^.MStkLoc.lsQtyAlloc;
    end;
    OnOrder := MLocCtrl^.MStkLoc.lsQtyOnOrder;
    MinQty  := MLocCtrl^.MStkLoc.lsQtyMin;
    MaxQty  := MLocCtrl^.MStkLoc.lsQtyMax;
    if (InStock = 0) and (FreeStock = 0) and (OnOrder = 0) and (MinQty = 0) and (MaxQty = 0) then
    begin
      // Lock and delete record.
      Delete_Rec(F[MLocF], MLocF, 0);
      RCount := RCount + 1;
    end;
    FuncRes := Find_Rec(B_GetNext, F[MLocF], MLocF, RecPtr[MLocF]^, 0, Key);
  end;
end;

//-------------------------------------------------------------------------

function IsOutstanding(var RunOk     : Boolean;
                       ProgBar   : TSFProgressBar)  :  Boolean;

  // Copied from SysU2.pas and amended
  function WORReqQty(IdR: IDetail): Double;
  begin
    with IdR do
      Result := Round_Up(Qty + QtyPWOff, Syss.NoQtyDec);
  end;

  function Qty_OS(IdR: IDetail): Real;
  begin
    with IdR do
      Result := Round_Up((WORReqQty(IdR) - QtyDel), Syss.NoQtyDec)
  end;

  function BuildQty_OS(IdR: IDetail): Double;
  begin
    with IdR do
      Result := Round_Up(WORReqQty(IdR) - QtyWOff, Syss.NoQtyDec);
  end;

const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK ;
  MODE_INTEGER = 0;
  MODE_FRACTION = 1;

Var
  KeyS,
  KeyChk  :  Str255;
  OSLineFound :  Boolean;
  TotalOS: Double;
begin
  KeyChk := FullNomKey(Inv.FolioNum);
  KeyS   := KeyChk;

  OSLineFound := False;

  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  while (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) and (Not OSLineFound) do
  with Id do
  begin
    If (Assigned(ProgBar)) then
        RunOk := (not ProgBar.Aborted);

    If (LineNo = 1) then
      TotalOS := BuildQty_OS(Id)
    else
      TotalOS := Qty_OS(Id);

    OSLineFound := (TotalOS <> 0);

    if (not OSLineFound) then
      Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, KeyPath, KeyS);

  end; {While..}

  Result := OSLineFound;

end; {Proc..}

//-------------------------------------------------------------------------

procedure ReinstateWORs(var TotalCount : LongInt;
                            LCount     :  LongInt;
                            RCount     : Integer;
                        var RunOk      :  Boolean;
                            ProgBar    :  TSFProgressBar);
const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;
var
  KeyChk : Str255;
  KeyS   : Str255;
  B_Func :  Integer;
  SysOk  :  Boolean;
Begin
  // CJS 2012-01-04: ABSEXCH-12332 - ReinstateWORs - Code Review
  //                 Removed redundant code (opening SysF)

  {
    VarComnU.pas:
      WORUPRunNo = -60;  // Unposted WOR
      WORPPRunNo = -62;  // Posted WOR
  }

  // Find the first posted WOR
  KeyChk := FullNomKey(WORPPRunNo);
  KeyS   := KeyChk;
  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  // Step through all the posted WOR records
  while (StatusOk) and (RunOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), True)) do
  with Inv do
  begin
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
      RunOk := (not ProgBar.Aborted);

    ProgBar.InfoLbl.Caption := 'Checking ' + Inv.OurRef;

    Inc(LCount);

    if (LCount < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := LCount;

    if (IsOutstanding(RunOk, ProgBar)) then
    begin
      RunNo  := WORUPRunNo;
      Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^, Keypath);
      Inc(RCount);

      if (Not StatusOk) then
        Write_FixLogFmt(FNum, 'Unable to write data to temporary file, report error ' + Form_Int(Status, 0), 4)
      else
        Write_FixLog(FNum, 'Works Order ' + Inv.OurRef + ' returned to Daybook ');

      RunOk := (RunOk and (Status In [0,5]));

    end;

    Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  end; {While..}

end; {Proc..}

//-------------------------------------------------------------------------

//  Used internally by MoveSRNs() (SF 127) - v6.9 - ABSEXCH-10890
procedure UpdateTransactionLines(FolioNo     : Integer;
                                 var RunOk   :  Boolean;
                                     ProgBar :  TSFProgressBar);
const
  KeyPath = IdFolioK;
var
  KeyChk: Str255;
  KeyS:   Str255;
begin
  KeyChk := FullNomKey(FolioNo);
  KeyS   := KeyChk;
  Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, Keypath, KeyS);

  // Step through all the transaction lines
  while (StatusOk) and (RunOk) and (CheckKey(KeyChk, KeyS, Length(KeyChk), True)) do
  with Id do
  begin
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
      RunOk := (not ProgBar.Aborted);
    // Make sure the transaction line has a run number of zero
    if (Id.PostedRun <> 0) then
    begin
      Id.PostedRun := 0;
      Status := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, Keypath);
    end;
    Status := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, Keypath, KeyS);
  end;
end;

//-------------------------------------------------------------------------

procedure MoveSRNs(var TotalCount : LongInt;
                       LCount     :  LongInt;
                       RCount     : Integer;
                   var RunOk      :  Boolean;
                       ProgBar    :  TSFProgressBar);
const
  Keypath = InvRNoK;
var
  KeyChk : Str255;
  KeyS   : Str255;
  B_Func :  Integer;
Begin
  // CJS 2012-01-04: ABSEXCH-12331 - MoveSRNs - Code Review
  //                 Removed redundant code (opening SysF)

  KeyChk := FullNomKey(0);
  KeyS   := KeyChk;
  Status := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, Keypath, KeyS);

  // Step through all the unposted records
  while (StatusOk) and (RunOk) and (Inv.RunNo = 0) do
  with Inv do
  begin
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
      RunOk := (not ProgBar.Aborted);

    ProgBar.InfoLbl.Caption := 'Checking ' + Inv.OurRef;

    Inc(LCount);

    if (LCount < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := LCount;

    // If this an SRN or PRN, it needs amending
    if (InvDocHed in [SRN, PRN]) then
    begin
      // Update the Transaction Lines first
      UpdateTransactionLines(FolioNum, RunOk, ProgBar);

      if (RunOk and StatusOk) then
      begin
        // Update the Transaction Header
        if (InvDocHed = SRN) then
          RunNo := SRNUPRunNo
        else
          RunNo := PRNUPRunNo;
        Status := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, Keypath);
        Inc(RCount);
      end;

      if (Not StatusOk) then
        Write_FixLogFmt(InvF, 'Unable to write data to temporary file, report error ' + Form_Int(Status, 0), 4)
      else
        Write_FixLog(InvF, 'Returns Transaction ' + Inv.OurRef + ' returned to correct Daybook ');

      RunOk := (RunOk and (Status In [0,5]));

    end;

    Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, Keypath, KeyS);

  end; {While..}

end; {Proc..}


//PR: 07/03/2012 ABSEXCH-12034 Function to iterate through unposted WORs and delete any which have no lines.
procedure DeleteWORsWithNoLines(var TotalCount   : LongInt;
                                var CheckedCount : LongInt;
                                var DeletedCount : LongInt;
                                var RunOk        :  Boolean;
                                    ProgBar      :  TSFProgressBar);
var
  KeyS   : Str255;
  B_Func :  Integer;
  FuncRes : Integer;

  //Function which looks in the details table and tries to find a line for this transaction.
  function HasLines : Boolean;
  var
    sKey : Str255;
    Res : Integer;
  begin
    sKey := FullNomKey(Inv.FolioNum) + FullNomKey(0);
    Res := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, sKey);
    Result := (Res = 0) and (Id.FolioRef = Inv.FolioNum);
  end;

Begin
  // Find the first unposted WOR
  KeyS := FullNomKey(WORUPRunNo);
  FuncRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvRNoK, KeyS);

  // Step through all the unposted WOR records
  while (FuncRes = 0) and (RunOk) and (Inv.RunNo = WORUPRunNo) do
  with Inv do
  begin

    //Check for abort and update progress bar
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
      RunOk := (not ProgBar.Aborted);

    ProgBar.InfoLbl.Caption := 'Checking ' + Inv.OurRef;

    Inc(CheckedCount);
    if (CheckedCount < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := CheckedCount;

    //Check if transaction has lines - if not then delete it
    if not HasLines then
    begin
      FuncRes := Delete_Rec(F[InvF], InvF, InvRNoK);
      Inc(DeletedCount);

      if (FuncRes <> 0) then
        Write_FixLogFmt(InvF, 'Unable to delete Works Order ' + Inv.OurRef + ', report error ' + Form_Int(FuncRes, 0), 4)
      else
        Write_FixLog(InvF, 'Works Order ' + Inv.OurRef + ' deleted');

      RunOk := RunOk and (FuncRes = 0);

    end;

    //Next record
    FuncRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvRNoK, KeyS);

  end; {While..}

end; {Proc..}

//PR: 08/03/2012 ABSEXCH-11640 Function to iterate through WOR Lines and delete any which have no header.
procedure DeleteWORLinesWithNoHeader(var TotalCount   : LongInt;
                                     var CheckedCount : LongInt;
                                     var DeletedCount : LongInt;
                                     var RunOk        :  Boolean;
                                         ProgBar      :  TSFProgressBar);
var
  KeyS   : Str255;
  B_Func :  Integer;
  FuncRes : Integer;

  //Function which looks in the Invoice table and tries to find a header for this transaction.
  function HasHeader : Boolean;
  var
    sKey : Str255;
    Res : Integer;
  begin
    sKey := FullNomKey(Id.FolioRef);
    Res := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, sKey);
    Result := (Res = 0) and (Id.FolioRef = Inv.FolioNum) and (Inv.InvDocHed = WOR);
  end;

  //function to return line identifier for progress and report
  function FormatId : string;
  begin
    Result := Id.DocPRef + ': Line ' + IntToStr(Id.AbsLineNo);
  end;

Begin
  //The most efficient index will be IdAnalK, which begins with Id.LineType: WOR lines will be 'W'.
  //Unfortunately, the next segment in the index is StockCode, so lines with the same folio won't be
  //together. Consequently, we have to check for a header for every line. (We could cache header folios, but
  //that seems like a bit too much work for a limited-use special function.)

  // Find the first WOR line
  KeyS := StkLineType[WOR];
  FuncRes := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdAnalK, KeyS);

  // Step through all the WOR lines
  while (FuncRes = 0) and (RunOk) and (Id.LineType = StkLineType[WOR]) and (Id.IdDocHed = WOR) do
  with Id do
  begin

    //Check for abort and update progress bar
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
      RunOk := (not ProgBar.Aborted);

    ProgBar.InfoLbl.Caption := 'Checking ' + FormatId;

    Inc(CheckedCount);
    if (CheckedCount < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := CheckedCount;


    //Check if line has a header - if not then delete it
    if not HasHeader then
    begin
      FuncRes := Delete_Rec(F[IDetailF], IDetailF, IdAnalK);
      Inc(DeletedCount);

      if (FuncRes <> 0) then
        Write_FixLogFmt(IDetailF, 'Unable to delete Works Order Line ' + FormatId + '. report error ' + Form_Int(FuncRes, 0), 4)
      else
        Write_FixLog(IDetailF, 'Works Order Line ' + FormatId + ' deleted');

      RunOk := RunOk and (FuncRes = 0);

    end;

    //Next record
    FuncRes := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdAnalK, KeyS);

  end; {While..}

end; {Proc..}

procedure FindEmptyTransactions(var TotalCount : LongInt;
                                var LCount     :  LongInt;
                                var RCount     : Integer;
                                var RunOk      :  Boolean;
                                    ProgBar    :  TSFProgressBar);

  // ...........................................................................
  { Returns True if the supplied value can be considered to be non-zero,
    allowing for floating-point discrepancies. }
  function IsNotZero(TestValue: Double): Boolean;
  const
    Margin = 0.00000001;
  begin
    Result := (Abs(TestValue) > Margin);
  end;
  // ...........................................................................

const
  InvKeyPath = InvOurRefK;
  IdKeyPath = IdFolioK;
var
  InvKey: Str255;
  IdKey: Str255;
  IdCheckKey: Str255;
  HasValue: Boolean;
begin
  { Initialise }
  InvKey := '';
  LCount := 0;
  RCount := 0;
  Write_FixMsgFmt('Transactions with values but without Transaction Lines', 2);
  { Search through all transactions }
  Status := Find_Rec(B_GetFirst, F[InvF], InvF, RecPtr[InvF]^, InvKeypath, InvKey);
  while (StatusOk) and (RunOk) do
  begin
    { Update the progress bar }
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking ' + Inv.OurRef + ', found ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;
    { Does the Transaction have a value (i.e. any non-zero financial figures)? }
    HasValue := IsNotZero(Inv.InvNetVal) or
                IsNotZero(Inv.InvVat) or
                IsNotZero(Inv.TotOrdOS) or
                IsNotZero(Inv.TotalInvoiced) or
                IsNotZero(Inv.Settled) or
                IsNotZero(Inv.CurrSettled);
    if (HasValue) then
    begin
      { Search for transaction lines }
      IdKey := FullNomKey(Inv.FolioNum);
      IdCheckKey := IdKey;
      Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
      { If no lines are found, add the transaction to the report }
      if (Status <> 0) or (not CheckKey(IdCheckKey, IdKey, Length(IdCheckKey), True)) then
      begin
        Inc(RCount);
        Write_FixMsgFmt(Inv.OurRef, 5);
      end;
    end;
    { Find the next transaction }
    Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvKeyPath, InvKey);
  end;
  if (RCount = 0) then
    Write_FixMsg('- None found');
  Write_FixMsg('');
end;

procedure FixEmptyTransactions(var TotalCount : LongInt;
                               var LCount     :  LongInt;
                               var RCount     : Integer;
                               var RunOk      :  Boolean;
                                   ProgBar    :  TSFProgressBar);
var
  ClearTransFrm: TClearTransFrm;
begin
  ClearTransFrm := TClearTransFrm.Create(Application.MainForm);
  try
    ClearTransFrm.ShowModal;
    RCount := ClearTransFrm.RecordsCleared;
  finally
    ClearTransFrm.Free;
  end;
end;

procedure FixTransactionLineDates(var TotalCount : LongInt;
                                  var LCount     :  LongInt;
                                  var RCount     : Integer;
                                  var RunOk      :  Boolean;
                                      ProgBar    :  TSFProgressBar);
var
  FixDatesFrm: TSetTransLineDateFrm;
begin
  FixDatesFrm := TSetTransLineDateFrm.Create(nil);
  try
    FixDatesFrm.ShowModal;
    RCount := FixDatesFrm.LinesFixed;
  finally
    FixDatesFrm.Free;
  end;
end;

procedure FixTransactionHeader(var TotalCount : LongInt;
                               var LCount     : LongInt;
                               var RCount     : Integer;
                               var RunOk      : Boolean;
                                   ProgBar    : TSFProgressBar);
const
  InvKeyPath = InvOurRefK;
var
  InvKey: Str255;
begin
  { Initialise }
  InvKey := '';
  LCount := 0;
  RCount := 0;
  Write_FixMsgFmt('UntilDate on Transaction Headers', 2);
  { Search through all transactions }
  Status := Find_Rec(B_GetFirst, F[InvF], InvF, RecPtr[InvF]^, InvKeypath, InvKey);
  while (StatusOk) and (RunOk) do
  begin
    { Update the progress bar }
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking ' + Inv.OurRef + ', found ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;
    { Is the UntilDate of the wrong length? }
    if Length(Inv.UntilDate) > 8 then
    begin
      { Fix the length, and add the transaction to the report }
      SetLength(Inv.UntilDate, 8);
      Status := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvKeypath);
      if (Status <> 0) then
        Write_FixLogFmt(IDetailF, 'Unable to update Transaction Header ' + Inv.OurRef + '. Error ' + Form_Int(Status, 0), 4)
      else
        Write_FixLog(IDetailF, 'Updated Transaction Header ' + Inv.OurRef);
      Inc(RCount);
    end;
    { Find the next transaction }
    Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvKeyPath, InvKey);
  end;
  if (RCount = 0) then
    Write_FixMsg('- No errors found');
  Write_FixMsg('');
end;

procedure CopyToPostcode(var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
const
  CustKeyPath = 0;
var
  MsgResult: Word;
  Erase: Boolean;
  CustKey: Str255;
begin
  MsgResult := MessageDlg('Erase contents of delivery line 5 after copying?',
                          mtConfirmation, [mbYes, mbNo, mbCancel], 0);
  case MsgResult of
    mrYes:    Erase := True;
    mrNo:     Erase := False;
    mrCancel: Exit;
  end;

  { Initialise }
  LCount := 0;
  RCount := 0;
  CustKey := '';
  Write_FixMsgFmt('Copying Delivery Address Line 5 to Postcode', 2);
  { Search through all Customer/Supplier records }
  Status := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, CustKeypath, CustKey);
  while (StatusOk) and (RunOk) do
  begin
    { Update the progress bar }
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking ' + Trim(Cust.CustCode) + ', found ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;
    { Is there anything in Delivery Address Line 5? }

    if Trim(Cust.DAddr[5]) <> '' then
    begin
      { Copy it to the Postcode }
      Cust.acDeliveryPostCode := Cust.DAddr[5];
      if Erase then
        Cust.DAddr[5] := '';

      Status := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, CustKeypath);
      if (Status <> 0) then
        Write_FixLogFmt(IDetailF, 'Unable to update Account ' + Cust.CustCode + '. Error ' + Form_Int(Status, 0), 4)
      else
        Write_FixLog(IDetailF, 'Updated Account ' + Cust.CustCode);
      Inc(RCount);
    end;
    { Find the next transaction }
    Status := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, CustKeyPath, CustKey);
  end;
  if (RCount = 0) then
    Write_FixMsg('- No Postcodes found to copy');
  Write_FixMsg('');

end;

procedure RemoveErroneousB2BFolios(var RunOk: Boolean;
                                   var TotalCount, LCount: LongInt;
                                       ProgBar:  TSFProgressBar);
{
  Searches for Adjustment Transaction Lines where the B2B Folio Number is the
  same as the Transaction Folio Number, and blanks the B2B Folio Number.
}
const
  Fnum    = IdetailF;
  Keypath = IdRunK;
var
  KeyS,
  KeyChk: Str255;
  FullCount: Integer;
begin
  { Set up a search key to find all records with a run number of zero. }
  FillChar(KeyS, Sizeof(KeyS), 0);

  KeyChk := FullNomKey(0);
  KeyS := KeyChk;

  FullCount := 0;

  { Find the first matching record, if any. }
  Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath, KeyS);

  while (StatusOk) and (Id.PostedRun = 0) and (RunOk) do
  with Id do
  begin

    Application.ProcessMessages;

    if (Assigned(ProgBar)) then
      RunOk := (not (ProgBar.Aborted));

    if (Id.IdDocHed = ADJ) and (Id.FolioRef = Id.B2BLink) then
    begin

      Id.B2BLink := 0;
      Status := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, Keypath);
      // Status := 0;

      if (Status<>0) then
        Write_FixLogFmt(FNum, '** Unable to fix Transaction Line ' + IntToStr(Id.ABSLineNo) + ' for ' + Id.DocPRef + '. Error ' + Form_Int(Status, 0), 4)
      else
        Inc(LCount);

    end;

    Inc(FullCount);

    if (FullCount < TotalCount) and (Assigned(ProgBar)) then
    begin
      ProgBar.InfoLbl.Caption := 'Remove erroneous B2B Folio values: ' +
                                 IntToStr(FullCount) + ' checked, ' +
                                 IntToStr(LCount) + ' updated';
      ProgBar.ProgressBar1.Position := FullCount;
    end;

    Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, Keypath,KeyS);

  end; {While..}

  if (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position := TotalCount;

end; {Proc..}

// 147 - CJS 2014-09-25 - ABSEXCH-15658 - Multiple ADJ lines cause posting run to hang
{
  This searches for any lines where the Run Number is -21. This is a temporary
  run number which should only be set while performing a Daybook-Post on
  Adjustments after doing a Stock Take -- there is a bug in Exchequer which
  occasionally results in the creation of multiple duplicated transaction
  lines, all of which will have this run number.

  Any Adjustments which contain such lines are listed, and the user is given
  the option to select the Adjustments which should be fixed. For each selected
  Adjustment, all lines which have a run number of -21 are deleted.

  See SF147SelectionFrmU.pas for the form which locates and displays the list
  of Adjustments.
}
procedure RemoveErroneousAdjustmentLines(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
var
  TransactionList: TStringList;
  FuncRes: LongInt;
  RecCount: Integer;
  Key: Str255;
  i: Integer;
  CanContinue: Boolean;
begin
  // Get a list of the transactions to process
  TransactionList := TStringList.Create;
  CanContinue := GetAdjustmentsForCorrection(TransactionList, RecCount);

  if not CanContinue then
    ProgBar.Aborted := True
  else
  begin
    // Initialise
    LCount := 0;
    RCount := 0;
    ProgBar.ProgressBar1.Max := RecCount;
    Write_FixMsgFmt('Deleting erroneous Adjustment Lines', 2);

    // For each selected transaction...
    for i := 0 to TransactionList.Count - 1 do
    begin
      // ...locate the Transaction
      Key := TransactionList[i];
      FuncRes := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key);
      if (FuncRes = 0) and (not ProgBar.Aborted) then
      begin
        // For each line on the Transaction...
        Key := FullNomKey(Inv.FolioNum);
        FuncRes := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, Key);
        while (FuncRes = 0) and (Id.FolioRef = Inv.FolioNum) and (not ProgBar.Aborted) do
        begin
          // ...if the line is one of the erroneous duplicates...
          if (Id.PostedRun = -21) then
          begin
            // ...delete it.
            FuncRes := Delete_Rec(F[IDetailF], IDetailF, IdFolioK);
            if (FuncRes <> 0) then
              Write_FixLogFmt(IDetailF, 'Unable to delete Adjustment Line on ' + Inv.OurRef + '. report error ' + Form_Int(FuncRes, 0), 4)
            else
              // Update the count of records actually deleted
              Inc(RCount);
          end;
          // Update the total count of records processed
          Inc(LCount);
          if (Assigned(ProgBar)) then
          begin
            if (LCount mod 100) = 0 then
            begin
              // Update the progress caption and position
              RunOk := (not ProgBar.Aborted);
              ProgBar.InfoLbl.Caption := 'Adjustment Lines, found ' + IntToStr(LCount) + ', deleted ' + IntToStr(RCount);
              ProgBar.ProgressBar1.Position := LCount;
              Application.ProcessMessages;
            end;
          end;
          // Find the next transaction line
          FuncRes := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, Key);
        end; // while (FuncRes = 0) and (Id.FolioRef = Inv.FolioNum)...
      end; // if (FuncRes = 0) and (not ProgBar.Aborted) then...
    end; // for i := 0 to TransactionList.Count - 1 do...
  end; // if not CanContinue...
end;

procedure PurgeLegacyCreditCardDetails(var TotalCount : LongInt;
                                       var LCount     : LongInt;
                                       var RCount     : Integer;
                                       var RunOk      : Boolean;
                                           ProgBar    : TSFProgressBar);
var
  Filter: TCreditCardFilter;
  Key: Str255;
  KeyChk: Str255;
  KeyPath: Integer;

  function GetFilter: TCreditCardFilter;
  var
    Dlg: TPurgeLegacyCreditCardDetailsForm;
  begin
    Dlg := TPurgeLegacyCreditCardDetailsForm.Create(nil);
    try
      if Dlg.ShowModal = mrOk then
      begin
        Result := Dlg.Filter;
      end;
    finally
      Dlg.Free;
    end;
  end;

  // Function to check whether the current CUSTSUPP record needs to have the
  // credit card details cleared.
  function UpdateRequired: Boolean;
  var
    ConcatStr: string;
  begin
    // Does this record pass the filter?
    Result := ((Cust.CustSupp = 'C') and (Cust.acSubType = 'C') and Filter.IncludeCustomers) or
              ((Cust.CustSupp = 'C') and (Cust.acSubType = 'U') and Filter.IncludeConsumers) or
              ((Cust.CustSupp = 'S') and Filter.IncludeSuppliers);

    if Result then
    begin
      // Concatenate all the Credit Card details
      ConcatStr := (Trim(Cust.CCDSDate) +
                    Trim(Cust.CCDEDate) +
                    Trim(Cust.CCDCardNo) +
                    Trim(Cust.CCDSARef));
      if not Filter.ExcludeNameField then
        ConcatStr := ConcatStr + Trim(Cust.CCDName);

      // If there was anything in any of the fields, they need to be cleared
      Result := (ConcatStr <> '');
    end;
  end;

begin
  Filter := GetFilter;

  if Filter.IsSet then
  begin
    { Initialise }
    LCount := 0;
    RCount := 0;
    Write_FixMsgFmt('Purging legacy Credit Card details', 2);

    { Search through all the Trader records }
    KeyChk  := '';
    Key     := KeyChk;
    KeyPath := 0;
    Status := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    while (StatusOk) and (RunOk) do
    begin
      { Update the progress bar }
      Inc(LCount);
      Application.ProcessMessages;
      if (Assigned(ProgBar)) then
      begin
        RunOk := (not ProgBar.Aborted);
        ProgBar.InfoLbl.Caption := 'Checking Customers/Suppliers, found ' + IntToStr(RCount);
        ProgBar.ProgressBar1.Position := LCount;
      end;

      { Main processing }
      if UpdateRequired then
      begin
        { Clear the fields }
        FillChar(Cust.CCDSDate,  SizeOf(Cust.CCDSDate),  #0);
        FillChar(Cust.CCDEDate,  SizeOf(Cust.CCDEDate),  #0);
        FillChar(Cust.CCDName,   SizeOf(Cust.CCDName),   #0);
        FillChar(Cust.CCDSARef,  SizeOf(Cust.CCDSARef),  #0);

        if (not Filter.ExcludeNameField) or (Cust.CustSupp = 'C') then
          FillChar(Cust.CCDCardNo, SizeOf(Cust.CCDCardNo), #0);

        { Save the record and report any errors }
        Status := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, KeyPath);
        if (Status <> 0) then
          Write_FixLogFmt(CustF, 'Unable to update ' + Trim(Cust.CustCode) + '. Error ' + Form_Int(Status, 0), 4);

        Inc(RCount);
      end;

      { Find the next record }
      Status := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    end;
    if (RCount = 0) then
      Write_FixMsg('- No records found to update');
  end
  else
    Write_FixMsg('- cancelled');
  Write_FixMsg('');
end;

procedure SetCountryCode(var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
var
  Filter: TCountryCodeFilter;
  Key: Str255;
  KeyChk: Str255;
  KeyPath: Integer;

  function GetFilter: TCountryCodeFilter;
  var
    Dlg: TSetCountryCode;
  begin
    Dlg := TSetCountryCode.Create(nil);
    try
      if Dlg.ShowModal = mrOk then
      begin
        Result := Dlg.Filter;
      end;
    finally
      Dlg.Free;
    end;
  end;

  function UpdateRequired: Boolean;
  begin
    Result := ((Cust.CustSupp = 'C') and (Cust.acSubType = 'C') and Filter.IncludeCustomers) or
              ((Cust.CustSupp = 'C') and (Cust.acSubType = 'U') and Filter.IncludeConsumers) or
              ((Cust.CustSupp = 'S') and Filter.IncludeSuppliers);

    // MH 07/07/2015 2015-R1 ABSEXCH-16370: Added support for Delivery Country code
    if Result and not Filter.IncludePopulated then
      Result := (Trim(Cust.acCountry) = '') Or (Trim(Cust.acDeliveryCountry) = '');
  end;

begin
  Filter := GetFilter;
  if Filter.IsSet then
  begin
    { Initialise }
    LCount := 0;
    RCount := 0;
    Write_FixMsgFmt('Setting Country Code', 2);

    { Search through all the Trader records }
    KeyChk  := '';
    Key     := KeyChk;
    KeyPath := 0;
    Status := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    while (StatusOk) and CheckKey(KeyChk, Key, Length(KeyChk), True) and (RunOk) do
    begin
      { Update the progress bar }
      Inc(LCount);
      Application.ProcessMessages;
      if (Assigned(ProgBar)) then
      begin
        RunOk := (not ProgBar.Aborted);
        ProgBar.InfoLbl.Caption := 'Checking Customers/Suppliers, found ' + IntToStr(RCount);
        ProgBar.ProgressBar1.Position := LCount;
      end;

      { Main processing }
      if UpdateRequired then
      begin
        { Set the country code }
        // MH 07/07/2015 2015-R1 ABSEXCH-16370: Added support for Delivery Country code
        If (Trim(Cust.acCountry) = '') Or Filter.IncludePopulated then
          Cust.acCountry := Filter.SelectedCode;

        // MH 07/07/2015 2015-R1 ABSEXCH-16370: Added support for Delivery Country code
        If (Trim(Cust.acDeliveryCountry) = '') Or Filter.IncludePopulated then
          Cust.acDeliveryCountry := Filter.SelectedCode;

        { Save the record and report any errors }
        Status := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, KeyPath);
        if (Status <> 0) then
          Write_FixLogFmt(CustF, 'Unable to update ' + Trim(Cust.CustCode) + '. Error ' + Form_Int(Status, 0), 4);

        Inc(RCount);
      end;

      { Find the next record }
      Status := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    end;
    if (RCount = 0) then
      Write_FixMsg('- No records found to update');
  end
  else
    Write_FixMsg('- cancelled');
  Write_FixMsg('');
end;

procedure SetAccountContactCountryCode(var TotalCount : LongInt;
                                       var LCount     : LongInt;
                                       var RCount     : Integer;
                                       var RunOk      : Boolean;
                                           ProgBar    : TSFProgressBar);
var
  ContactFile: TAccountContactBtrieveFile;
  FilePath: string;
  CustCode: string;
  Key: Str255;
  KeyPath: Integer;

  function UpdateRequired: Boolean;
  begin
    if ContactFile.AccountContact.acoContactHasOwnAddress and
       (Trim(ContactFile.AccountContact.acoContactCountry) = '') then
      Result := True
    else
      Result := False;
  end;

begin
  FilePath := SetDrive + '\CUST\ACCOUNTCONTACT.DAT';
  ContactFile := TAccountContactBtrieveFile.Create;
  ContactFile.OpenFile(FilePath);

  { Initialise }
  LCount := 0;
  RCount := 0;
  Write_FixMsgFmt('Populating Account Contact country codes', 2);

  TotalCount := ContactFile.GetRecordCount;
  if Assigned(ProgBar) then
    ProgBar.ProgressBar1.Max := TotalCount;

  { Search through all the Account Contact records, using the AccountCode+ContactName index }
  CustCode := '';
  ContactFile.Index := acoIdxAccountContactName;
  Status := ContactFile.GetFirst;
  while (StatusOk) and (RunOk) do
  begin
    { Update the progress bar }
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking Account Contacts, found ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;

    { Main processing }
    if UpdateRequired then
    begin
      { If necessary, locate the Trader record and retrieve the country code }
      if (CustCode <> Trim(ContactFile.AccountContact.acoAccountCode)) then
      begin
        CustCode := FullCustCode(ContactFile.AccountContact.acoAccountCode);
        Key      := CustCode;
        KeyPath  := 0;
        Status := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
        if (not StatusOk) or (not CheckKey(CustCode, Key, Length(CustCode), True)) then
        begin
          if (Status <> 0) then
            Write_FixLogFmt(CustF, 'Could not find record for ' + Trim(Cust.CustCode) + '. Error ' + Form_Int(Status, 0), 4);
        end;
      end;

      { If there is a country code against the Customer record, copy the
        country code to the Contact record }
      if Trim(Cust.acCountry) <> '' then
      begin
        with ContactFile.AccountContact do
          acoContactCountry := Cust.acCountry;

        { Save the record and report any errors }
        Status := ContactFile.Update;
        if (Status <> 0) then
          Write_FixLogFmt(CustF, 'Unable to update ' + Trim(Cust.CustCode) + '. Error ' + Form_Int(Status, 0), 4);

        Inc(RCount);
      end;
    end;

    { Find the next record }
    Status := ContactFile.GetNext;
  end;
  if (RCount = 0) then
    Write_FixMsg('- No records found to update');
end;

// CJS 2015-03-03 - ABSEXCH-16154 - remove tab characters from transaction line descriptions
procedure RemoveTabCharacters(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
const
  TransactionTypes: array[0..8] of string = (
    'NOM',
    'SIN',
    'PIN',
    'SCR',
    'PCR',
    'PJI',
    'PJC',
    'SJI',
    'SJC'
  );
var
  Key: Str255;
  KeyChk: Str255;
  KeyPath: Integer;
  i: Integer;

  // Replaces any tab characters in the Desc field of the current transaction
  // line record, returning True if any were found.
  function ReplaceTabCharacters: Boolean;
  var
    CharPos: Integer;
    Description: string;
  begin
    Description := Id.Desc;
    // Are there any tab characters?
    CharPos := Pos(#9, Description);
    // If yes, replace them, and return True, otherwise return False
    if (CharPos > 0) then
    begin
      Id.Desc := StringReplace(Description, #9, ' ', [rfReplaceAll]);
      Result := True;
    end
    else
      Result := False;
  end;

begin
  { Initialise }
  LCount := 0;
  RCount := 0;
  Write_FixMsgFmt('Remove tab characters from Transaction Lines', 2);

  KeyPath := IdDocPRefK;

  { For each transaction type: }
  for i := Low(TransactionTypes) to High(TransactionTypes) do
  begin
    { Search through records }
    KeyChk := TransactionTypes[i];
    Key    := KeyChk;
    Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, KeyPath, Key);
    while (StatusOk) and CheckKey(KeyChk, Key, Length(KeyChk), True) and (RunOk) do
    begin
      { Update the progress bar }
      Inc(LCount);
      Application.ProcessMessages;
      if (Assigned(ProgBar)) then
      begin
        RunOk := (not ProgBar.Aborted);
        ProgBar.InfoLbl.Caption := 'Checking Transaction Lines, found ' + IntToStr(RCount);
        ProgBar.ProgressBar1.Position := LCount;
      end;

      { Main processing }
      if ReplaceTabCharacters then
      begin
        { Save the record and report any errors }
        Status := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, KeyPath);
        if (Status <> 0) then
          Write_FixLogFmt(IdetailF, 'Unable to update record. Error ' + Form_Int(Status, 0), 4)
        else
          { Report amendments }
          { Only do this if a small number of records will be amended, and the
            user would reasonably be expected to verify them }
          //Write_FixLog(IdetailF, 'Updated Transaction Line ' + IntToStr(Id.ABSLineNo) + ' in ' + Id.DocPRef);
          ;

        Inc(RCount);
      end;
      { Find the next record }
      Status := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, KeyPath, Key);
    end;
  end;
  if (RCount = 0) then
    Write_FixMsg('- No errors found');
  Write_FixMsg('');
end;

procedure ReorderTransactions(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
var
  ErrorMsg: string;
  CompanyCode: string;
begin
  Write_FixMsgFmt('Re-order Transactions', 2);

  // CJS 2016-04-26 - ABSEXCH-16737 - re-order transactions after SQL migration.
  // Moved the main processing to a separate unit, so that it can be called
  // from the SQL Migration system.
  CompanyCode := GetCompanyCode(SetDrive);
  ErrorMsg := SQLReorder.ReorderTransactions(CompanyCode);

  if (ErrorMsg <> '') then
    Write_FixMsgFmt('Error running SQL query: ' + ErrorMsg, 4);

  Write_FixMsg('');
end;

procedure UpdateTransactionCountryCodes(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
var
  Key: Str255;
  KeyChk: Str255;
  KeyPath: Integer;

  function HasDeliveryAddress: Boolean;
  var
    i: Integer;
  begin
    Result := False;
    // Scan the delivery address lines on the transaction
    for i := Low(Inv.DAddr) to High(Inv.DAddr) do
    begin
      // Return true if we find at least one non-empty address line
      if (Trim(Inv.DAddr[i]) <> '') then
      begin
        Result := True;
        break;
      end;
    end;
  end;

  function TraderCountryCode: string;
  var
    Key: Str255;
    KeyPath: Integer;
    Status: Integer;
  begin
    Result := '';
    // Locate the Trader for this transaction
    Key := Inv.CustCode;
    KeyPath := CustCodeK;
    Status := Find_Rec(B_GetGEq, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    if (Status = 0) then
    begin
      // Is there a Delivery Country Code? If so, return it.
      if (Trim(Cust.acDeliveryCountry) <> '') then
        Result := Cust.acDeliveryCountry
      // Otherwise, is there a default Country Code? If so, return it.
      else if (Trim(Cust.acCountry) <> '') then
        Result := Cust.acCountry;
    end;
  end;

begin
  // Initialise
  LCount := 0;
  RCount := 0;
  Write_FixMsgFmt('Update Transaction Delivery Address Country Codes', 2);

  // Search through records for all unposted Transactions
  KeyChk  := '';
  Key     := KeyChk;
  KeyPath := InvRNoK;
  Status := Find_Rec(B_GetFirst, F[InvF], InvF, RecPtr[InvF]^, KeyPath, Key);
  while (StatusOk) and (Inv.RunNo <= 0) and (RunOk) do
  begin
    // Update the progress bar
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking transactions, fixed ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;

    // Hack: we can't have negative numbers in a set, so we'll search for the
    // abs() of the Run Number in a list of positive versions of the required
    // run numbers. Because we are only scanning negative run numbers there is
    // no danger of accidentally picking up erroneous transactions.
    if (Abs(Inv.RunNo) in [0, 40, 50, 60, 70, 110, 111, 112, 115, 118, 125, 128]) then
    begin
      if (HasDeliveryAddress) and (Trim(Inv.thDeliveryCountry) = '') then
      begin
        Inv.thDeliveryCountry := TraderCountryCode;
        // Only save the record if we actually found a country code
        if (Trim(Inv.thDeliveryCountry) <> '') then
        begin
          // Save the record and report any errors
          Status := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, KeyPath);
          if (Status <> 0) then
            Write_FixLogFmt(InvF, 'Unable to update transaction. Error ' + Form_Int(Status, 0), 4)
          else
            Inc(RCount);
        end;
      end;
    end;
    // Find the next record
    Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, KeyPath, Key);
  end;
  if (RCount = 0) then
    Write_FixMsg('- No records updated');
  Write_FixMsg('');
end;

// PR: 25/11/2015 - ABSEXCH-17001 - Clear random data from Syss.Spare600
procedure CleanSpare600(
                         var TotalCount : LongInt;
                         var LCount     : LongInt;
                         var RCount     : Integer;
                         var RunOk      : Boolean;
                             ProgBar    : TSFProgressBar);
var
  bLocked : Boolean;
begin
  // Initialise
  LCount := 0;
  RCount := 0;
  TotalCount := 0;
  
  Write_FixMsgFmt('Clean System Setup record', 2);

  //Get and lock system setup record
  bLocked := True;
  GetMultiSys(BOff, bLocked, SysR);

  if bLocked then
  begin
    //Clear Spare600
    FillChar(Syss.Spare600, SizeOf(Syss.Spare600), 0);

    //Store record
    PutMultiSys(SysR, True);
    Write_FixMsgFmt('Updated System Setup record.', 1);

    LCount := 1;
    RCount := 1;
    TotalCount := 1;
  end
  else //Problem
    Write_FixMsgFmt('Unable to update System Setup record.', 4);

end;

// CJS 2016-04-20 - ABSEXCH-17432 - SF to clear transaction Intrastat details
procedure ClearIntrastatFields(var TotalCount : LongInt;
                               var LCount     : LongInt;
                               var RCount     : Integer;
                               var RunOk      : Boolean;
                                   ProgBar    : TSFProgressBar);
var
  Key: Str255;
  KeyChk: Str255;
  KeyPath: Integer;
  IdKey: Str255;
  IdKeyChk: Str255;
  IdKeyPath: Integer;
  TransactionCount: Integer;
  LineCount: Integer;
  TraderCount: Integer;
  TransactionAmended: Boolean;
begin
  { Initialise }
  TraderCount      := 0; // Trader records fixed
  TransactionCount := 0; // Transaction records fixed
  LineCount        := 0; // Transaction Line records fixed

  TransactionAmended := False;

  LCount := 0;  // Total records found
  RCount := 0;  // Total records fixed

  Write_FixMsgFmt('Clear Intrastat details from Transactions and Traders', 2);

  if (Syss.Intrastat) then
    Write_FixMsgFmt('Intrastat is enabled on this system, so the details have not been cleared.', 4)
  else
  begin
    { Search through Transaction records }
    KeyChk  := '';
    Key     := KeyChk;
    KeyPath := 0;
    Status := Find_Rec(B_GetFirst, F[InvF], InvF, RecPtr[InvF]^, KeyPath, Key);
    while (StatusOk) and CheckKey(KeyChk, Key, Length(KeyChk), True) and (RunOk) do
    begin
      { Update the progress bar }
      Inc(LCount);
      Application.ProcessMessages;
      if (Assigned(ProgBar)) then
      begin
        RunOk := (not ProgBar.Aborted);
        ProgBar.InfoLbl.Caption := 'Checking Transactions, updated ' + IntToStr(TransactionCount);
        ProgBar.ProgressBar1.Position := LCount;
      end;

      { Main processing }
      TransactionAmended := False;
      if (Inv.InvDocHed in PurchSplit + SalesSplit - [PPY, PBT, SRC, SBT]) then
      begin
        if ((Trim(Inv.DelTerms) <> '') or (Inv.TransMode > 0) or (Inv.TransNat > 0)) then
        begin
          TransactionAmended := True;

          { Amend the record }
          Inv.DelTerms  := '';
          Inv.TransMode := 0;
          Inv.TransNat  := 0;

          { Save the record and report any errors }
          Status := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, KeyPath);
          if (Status <> 0) then
            Write_FixLogFmt(InvF, Format('Unable to update Transaction record %s. Error ', [Inv.OurRef]) + Form_Int(Status, 0), 4);
        end;

        { Search through Transaction Line records }
        IdKeyChk  := FullNomKey(Inv.FolioNum);
        IdKey     := IdKeyChk;
        IdKeyPath := 0;
        Status := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
        while (StatusOk) and CheckKey(IdKeyChk, IdKey, Length(IdKeyChk), True) and (RunOk) do
        begin
          Application.ProcessMessages;

          { Main processing }
          if (Id.SSDUseLine) then
          begin
            TransactionAmended := True;

            { Amend the record }
            Id.SSDUseLine := False;

            { Save the record and report any errors }
            Status := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, KeyPath);
            if (Status <> 0) then
              Write_FixLogFmt(IdetailF, Format('Unable to update Transaction Line record %s, line %s. Error ', [Id.DocPRef, Id.ABSLineNo]) + Form_Int(Status, 0), 4);

          end;
          { Find the next record }
          Status := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdKeyPath, IdKey);
        end;

        if TransactionAmended then
          Inc(TransactionCount);

      end;
      { Find the next record }
      Status := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, KeyPath, Key);
    end;
    RCount := TransactionCount;

    { Search through Trader records }
    KeyChk  := '';
    Key     := KeyChk;
    KeyPath := 0;
    Status := Find_Rec(B_GetFirst, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    while (StatusOk) and CheckKey(KeyChk, Key, Length(KeyChk), True) and (RunOk) do
    begin
      { Update the progress bar }
      Inc(LCount);
      Application.ProcessMessages;
      if (Assigned(ProgBar)) then
      begin
        RunOk := (not ProgBar.Aborted);
        ProgBar.InfoLbl.Caption := 'Checking Traders, updated ' + IntToStr(TraderCount);
        ProgBar.ProgressBar1.Position := LCount;
      end;

      { Main processing }
      if ((Trim(Cust.SSDDelTerms) <> '') or (Cust.SSDModeTr > 0)) then
      begin
        { Amend the record }
        Cust.SSDDelTerms  := '';
        Cust.SSDModeTr := 0;

        { Save the record and report any errors }
        Status := Put_Rec(F[CustF], CustF, RecPtr[CustF]^, KeyPath);
        if (Status <> 0) then
          Write_FixLogFmt(CustF, Format('Unable to update Trader record %s. Error ', [Cust.CustCode]) + Form_Int(Status, 0), 4);

        Inc(TraderCount);
      end;
      { Find the next record }
      Status := Find_Rec(B_GetNext, F[CustF], CustF, RecPtr[CustF]^, KeyPath, Key);
    end;
    RCount := RCount + TraderCount;
    if (RCount = 0) then
      Write_FixMsg('- No errors found');
  end; // if (Syss.Intrastat)...
  Write_FixMsg('');
end;

// CJS 2016-06-03 - ABSEXCH-17495 - move VAT Submission response to correct company
procedure MoveVATSubmission(var RCount: LongInt; var RunOk: Boolean);
const
  Period = '2012-03';
  SourceFolder = 'C:\EXCHEQR\EXCH91S\SECOND';
  DestFolder = 'C:\EXCHEQR\EXCH91S';
var
  VAT100: TVAT100BtrieveFile;
  VAT100Rec: VAT100RecType;
  FuncRes: Integer;
  Found: Boolean;
  CanContinue: Boolean;
  Overwrite: Boolean;
  RecAddr: LongInt;
begin
  VAT100 := TVAT100BtrieveFile.Create;
  try
    // Open the VAT 100 table in the source directory (this should be the
    // directory for the current company)
    VAT100.OpenFile(SourceFolder + '\MISC\VAT100.DAT');

    // Locate the record. Unfortunately the only index is against the
    // Correlation ID, so we'll have to step through the records searching
    // for the right one.
    Found := False;
    FuncRes := VAT100.GetFirst;
    while (FuncRes = 0) and not Found do
    begin
      if (VAT100.Rec.vatPeriod = Period) then
      begin
        VAT100.GetPosition(RecAddr);
        Found := True;
        break;
      end;
      FuncRes := VAT100.GetNext;
    end;

    if Found then
    begin
      // Save the details
      VAT100Rec := VAT100.Rec;

      // Close the table, then re-open it in the destination directory
      VAT100.CloseFile;
      VAT100.OpenFile(DestFolder + '\MISC\VAT100.DAT');

      // Search for an existing record against the details
      CanContinue := True;
      Found := False;
      FuncRes := VAT100.GetFirst;
      while (FuncRes = 0) and not Found do
      begin
        if (VAT100.Rec.vatPeriod = Period) then
        begin
          Found := True;
          CanContinue := False;
          break;
        end;
        FuncRes := VAT100.GetNext;
      end;

      // If found, confirm that it should be overwritten
      Overwrite := False;
      if Found then
      begin
        CanContinue := (MessageDlg('A VAT Submission already exists in the target company against this VAT Period. Do you want to overwrite it?', mtWarning, [mbYes, mbNo], 0) = mrYes);
        Overwrite := CanContinue;
      end;

      if CanContinue then
      begin
        // Copy the record details
        VAT100.Rec := VAT100Rec;

        // Update the existing record, or add the new record
        if Overwrite then
          FuncRes := VAT100.Update
        else
          FuncRes := VAT100.Insert;
        if FuncRes <> 0 then
        begin
          Write_FixMsgFmt('Failed to insert new record into target VAT 100 Submission table, error ' + IntToStr(FuncRes), 4);
          CanContinue := False;
        end
        else
          RCount := 1;
      end
      else
        Write_FixMsgFmt('Update of VAT Submission was cancelled', 4);

      // If everything is ok, go back to the original company and delete
      // the submission
      if CanContinue then
      begin
        VAT100.CloseFile;
        VAT100.OpenFile(SourceFolder + '\MISC\VAT100.DAT');

        Found := False;
        FuncRes := VAT100.RestorePosition(RecAddr);
        if (FuncRes = 0) then
        begin
          FuncRes := VAT100.Delete;
          if FuncRes <> 0 then
            Write_FixMsgFmt('Could not delete the original record, error ' + IntToStr(FuncRes), 4);
        end
        else
          Write_FixMsgFmt('Could not locate the original record to delete it, error ' + IntToStr(FuncRes), 4);
      end;

    end
    else
      Write_FixMsgFmt('No VAT Submission found for Period ' + Period, 4);

  finally
    VAT100.CloseFile;
    VAT100.Free;
  end;
end;

//PR: 06/09/2016 ABSEXCH-17700 Remove redundant control lines (Crane Asia)
procedure DeleteRedundantControlLines(var TotalCount : LongInt;
                                      var LCount     : LongInt;
                                      var RCount     : Integer;
                                      var RunOk      : Boolean;
                                          ProgBar    : TSFProgressBar);
var
  KeyS : Str255;
  KeyPath : Integer;
  Res : Integer;
begin
  LCount := 0;  // Total records found
  RCount := 0;  // Total records fixed

  //Look for lines with folio number of zero
  KeyS     := FullNomKey(0);
  KeyPath := 0; //Folio num + LineNo

  Res := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, KeyPath, KeyS);
  while (Res = 0) and (Id.FolioRef = 0) and (RunOk) do
  begin
    { Update the progress bar }
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking lines. Checked: ' + IntToStr(LCount) + ' Deleted: ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;

    //Only delete the specific lines we identified
    if (Id.IdDocHed = SIN) and (Id.PostedRun = 0) then
    begin
      //Found record to delete
      Delete_Rec(F[IDetailF], IDetailF, KeyPath);
      Inc(RCount);
    end;

    Res := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, KeyPath, KeyS);
  end;

end;

//PR: 13/09/2016 ABSEXCH-17636 Remove History records with year of > 2017
procedure DeleteFutureHistoryRecords(var TotalCount : LongInt;
                                     var LCount     : LongInt;
                                     var RCount     : Integer;
                                     var RunOk      : Boolean;
                                         ProgBar    : TSFProgressBar);
var
  KeyS   : Str255;
  KeyChk : Str255;
  Res : Integer;
begin
  KeyChk := 'USQUA01';
  KeyS := KeyChk;

  Res := Find_Rec(B_GetGEq, F[NHistF], NHistF, RecPtr[NHistF]^, NHK, KeyS);

  while (Res = 0) and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn) and RunOK do
  begin
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking history records. Checked: ' + IntToStr(LCount) + ' Deleted: ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;


    if NHist.Yr > 117 then
    begin
      Delete_Rec(F[NHistF], NHistF, NHK);
      Inc(RCount);
    end;


    Res := Find_Rec(B_GetNext, F[NHistF], NHistF, RecPtr[NHistF]^, NHK, KeyS);
  end;

end;

//AP : 17/02/2017 2017-R1 ABSEXCH-15554 : Update manlly Our ref field in Transaction Line based on Documents table
procedure UpdateTransactionLineOurRef(var TotalCount : LongInt;
                                     var LCount     : LongInt;
                                     var RCount     : Integer;
                                     var RunOk      : Boolean;
                                         ProgBar    : TSFProgressBar);
var
  lStatus,
  lInvStatus: LongInt;
  lKeyIDS,
  lKeyInvS: Str255;
begin
  //Searches in Transaction Lines
  lKeyIDS := '';
  lStatus := Find_Rec(B_GetFirst, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, lKeyIDS);
  while (lStatus = 0) do
  begin  
    // Update the progress bar
    Inc(LCount);
    Application.ProcessMessages;
    if (Assigned(ProgBar)) then
    begin
      RunOk := (not ProgBar.Aborted);
      ProgBar.InfoLbl.Caption := 'Checking transactions, fixed ' + IntToStr(RCount);
      ProgBar.ProgressBar1.Position := LCount;
    end;

    //Looks for the Line having blank OurRef filed
    if (Trim(Id.DocPRef) = '') then
    begin
      //Searches record in Headers
      lKeyInvS := FullNomKey(Id.FolioRef);
      lInvStatus := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, lKeyInvS);
      if (lInvStatus = 0) and (Inv.FolioNum = Id.FolioRef) then
      begin
        //Update parent OurRef value into DETAILS table.
        Id.DocPRef := Inv.OurRef;
			  lStatus := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK);
        if (lStatus <> 0) then
          Write_FixLogFmt(IDetailF, 'Unable to update transaction. Error ' + Form_Int(Status, 0), 4)
        else
			    Inc(RCount);
      end;
    end;
    lStatus := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, lKeyIDS);
  end;
  if (RCount = 0) then
		Write_FixMsg('- No records updated');
	Write_FixMsg('');
end;

Begin

  ProgressCounter:=0;

end. {Unit..}
