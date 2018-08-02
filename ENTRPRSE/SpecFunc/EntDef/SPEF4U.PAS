Unit SpeF4U;




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
  GlobVar,
  VarConst,
  SFHeaderU,
  ProgU;


Function Valid_Account(OldNo     :  Str10;
                       InvR      :  InvRec)  :  Boolean;

Function Get_GoodLine(InvR     :  InvRec;
                      InfoMode :  Byte)  :  Boolean;

Function Check_Account(Var OldNo  :  Str10)  :  Boolean;

Procedure Resurect_Hed(Var RunOk :  Boolean;
                       Var TotalCount,
                           MFind :  LongInt;
                           ProgBar
                                 :  TSFProgressBar);

{AP 05/06/2018 2018R2 ABSEXCH-20310:Special Function to set folio number on specified transaction when folio number = 0}
procedure ResetZeroFolioTrans(var ARunOk: Boolean;
                              var ATotalCount, AMFind: LongInt;
                              AProgBar: TSFProgressBar);

Procedure Remove_Match(Mode  :  Integer;
                   Var RunOk :  Boolean;
                   Var TotalCount,
                       MFind :  LongInt;
                       ProgBar
                             :  TSFProgressBar);


Procedure Set_StockCost(Var RunOk :  Boolean;
                        Var MFind,
                            TotalCount
                                  :  LongInt;
                            ProgBar
                                  :  TSFProgressBar);

Procedure Repair_NomLine(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

Procedure Set_CustStaFlg(Var RunOk :  Boolean;
                         Var MFind,
                             TotalCount
                                   :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);



Procedure Del_BadDoc(Var TotalCount,
                         LCount:  LongInt;
                         DMode :  Byte;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar);

Procedure Unallocate_Trans(    Mode  :  Byte;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure Remove_PMPMode(Mode  :  Integer;
                     Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         ProgBar
                               :  TSFProgressBar);

Procedure SetDocUOR(Var RunOk :  Boolean;
                    Var TotalCount,
                        MFind :  LongInt;
                        MaxFolio
                              :  LongInt;
                        MaxDate :  LongDate;
                        EuroCr:  Integer;
                        ProgBar
                              :  TSFProgressBar);

Procedure ResetDocUOR(Var RunOk :  Boolean;
                      Var TotalCount,
                          MFind :  LongInt;
                          MaxFolio
                                :  LongInt;
                          MaxDate :  LongDate;
                          EuroCr:  Integer;
                          ProgBar
                                :  TSFProgressBar);

Procedure Set_CustSetlTerm2(Var RunOk :  Boolean;
                            Var MFind,
                                TotalCount
                                      :  LongInt;
                                CS    :  Boolean;
                                Mode  :  Byte;
                                ProgBar
                                      :  TSFProgressBar);


Procedure Set_StockWeb(Var RunOk :  Boolean;
                       Var MFind,
                           TotalCount
                                 :  LongInt;
                           Mode  :  Byte;
                           ProgBar
                                 :  TSFProgressBar);

Procedure SetUnptCost(Var RunOk :  Boolean;
                      Var TotalCount,
                          MFind :  LongInt;
                          Mode  :  Byte;
                          ProgBar
                                :  TSFProgressBar);

Procedure CleanORef(Var TotalCount,
                        LCount:  LongInt;
                    Var RunOk :  Boolean;
                        ProgBar
                              :  TSFProgressBar);

Procedure Set_PINPCRAuth(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

Procedure Set_ResetDebtLtr(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure Set_DetailsLOC(Mode  :  Integer;
                     Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         UseLoc:  Str10;
                         ProgBar
                               :  TSFProgressBar);

Procedure Clean_ReconFlg(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

Procedure Fix_HistSPOP(Var TotalCount,
                           LCount:  LongInt;
                       Var RunOk :  Boolean;
                           ProgBar
                                 :  TSFProgressBar);


Procedure Fix_HistSPOPBOML(Var TotalCount,
                               LCount:  LongInt;
                           Var RunOk :  Boolean;
                               Mode  :  Integer;
                               ProgBar
                                     :  TSFProgressBar);

Procedure ZeroSaleBOMCost(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              Mode  :  Byte;
                              ProgBar
                                    :  TSFProgressBar);

Procedure RepairOrdMatch(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

Procedure CheckSRCPPY4Stk(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              Mode  :  Byte;
                              ProgBar
                                    :  TSFProgressBar);

Procedure PadYourRef(Var TotalCount,
                         LCount:  LongInt;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar);

Procedure Reset_GenisisSIN(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure Reset_GenisisSOR(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);

Procedure Del_NoPJobAct(Var RunOk :  Boolean;
                        Var TotalCount,
                            LCount:  LongInt;
                            Mode     :  Byte;
                            ProgBar
                                     :  TSFProgressBar);

Procedure Set_StockAltCodes(Var RunOk :  Boolean;
                            Var MFind,
                                TotalCount
                                      :  LongInt;
                                ProgBar
                                      :  TSFProgressBar);

Procedure ResetSet_PurgeACHist(Mode  :  Integer;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               UseAC :  Str10;
                               ProgBar
                                     :  TSFProgressBar);

Procedure ResetSet_PurgeStkHist(Mode  :  Integer;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               UseSC :  Str20;
                               ProgBar
                                     :  TSFProgressBar);

procedure Set_FiltStock(var RunOk: Boolean; var MFind, TotalCount: LongInt;
  ProgBar: TSFProgressBar);

procedure ResetNomMode(var RunOk: Boolean; TotalCount: LongInt;
  var Count: LongInt; var RCount: LongInt;  ProgBar: TSFProgressBar);

procedure MoveBOMLines(var RunOk                    : Boolean;
                       var TotalCount, MFind, RCount: LongInt;
                       FromSORRef                   : string;
                       ProgBar                      : TSFProgressBar);
//PR: 27/06/2017 ABSEXCH-18756
Procedure SetPINRunNumbersFromLines(Var RunOk :  Boolean;
                                    Var ProcessedCount : longint;
                                    Var CheckedCount : longint;
                                    ProgBar :  TSFProgressBar);

//PR: 27/08/2017 ABSEXCH-19162
Procedure FixSettleDoubling(Var RunOk :  Boolean;
                            Var ProcessedCount : longint;
                            Var CheckedCount : longint;
                                ProgBar :  TSFProgressBar);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     Windows,
     SysUtils,
     Messages,
     Forms,
     VarFPosU,
     VarRec2U,
     ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2,
     UnTils,
     Rebuld1U,
     ReBuld2U,
     Purge1U,
     SQLUtils;




{ ============= Function to check for valid customer / supplier ========== }

Function Valid_Account(OldNo     :  Str10;
                       InvR      :  InvRec)  :  Boolean;


Var
  KeyS    :  Str255;


  ShouldSupp
          :  Char;


Begin
  With InvR do
  Begin

    KeyS:=OldNo;

    If (CheckRecExsists(KeyS,CustF,CustCodeK)) then
    Begin
      If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
        ShouldSupp:=Chr(Succ(Ord(Cust.CustSupp)))
      else
        ShouldSupp:=Cust.CustSupp;


      Result:=(ShouldSupp=CustSupp);
    end
    else
      Result:=BOff;
  end;


end;



{ == Procedure to try and get missing details from line == }

{Info mode, means we want
  1  CustCode
  2  Pr
  3  Yr
  4  Date

}

Function Get_GoodLine(InvR     :  InvRec;
                      InfoMode :  Byte)  :  Boolean;

Const
  Fnum      =  IDetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk  :  Str255;

  Ok2Del  :  Boolean;

  B_Func  :  Integer;



Begin

  KeyChk:=FullNomKey(InvR.FolioNum);

  KeyS:=KeyChk+FullNomKey(1);

  Ok2Del:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Ok2Del) do
  With Id do
  Begin
    Case InfoMode of
      1  :  Begin

              Ok2Del:=Valid_Account(CustCode,InvR);

            end;

      2  :  Begin
              Ok2Del:=(PPr In [1..Syss.PrInYr]);

            end;

      3  :  Begin
              Ok2Del:=(PYr In [1..150]);

            end;

      4  :  Begin
              Ok2Del:=(PDate<>'') and (Length(PDate)=Length(Today));

            end;

    end; {case..}

    If (Not Ok2Del) then
      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}


  Get_GoodLine:=Ok2Del;

end;


{ ============= Function to check for valid customer / supplier ========== }

Function Check_Account(Var OldNo  :  Str10)  :  Boolean;

Var
  KeyS    :  Str255;

  ShouldSupp
          :  Char;


Begin
  With Inv do
  Begin

    KeyS:=CustCode;

    If (CheckRecExsists(KeyS,CustF,CustCodeK)) then
    Begin
      If (Not (InvDocHed In [WOR]+JAPSalesSplit)) then
      Begin
        If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
          ShouldSupp:=Chr(Succ(Ord(Cust.CustSupp)))
        else
          ShouldSupp:=Cust.CustSupp;


        Result:=(ShouldSupp<>CustSupp);
      end
      else
        Result:=BOff;
    end
    else
      Result:=BOn;

    If (Result) then
    Begin

      OldNo:=CustCode;

      If (Get_GoodLine(Inv,1)) then {* Attempt to get from line *}
        CustCode:=Id.CustCode
      else
      Begin

        If (InvDocHed In SalesSplit) then
          CustCode:=LJVar(Syss.DirectCust,6)
        else
          CustCode:=LJVar(Syss.DirectSupp,6);
      end;

    end;

  end; {With..}


end;




{ ====== Procedure to Resurrect any missing headers ====== }

Procedure Resurect_Hed(Var RunOk :  Boolean;
                       Var TotalCount,
                           MFind :  LongInt;
                           ProgBar
                                 :  TSFProgressBar);

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;
  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;
  KeyPath3  =  InvOurRefK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  FDocH,
  Posted,
  SysOK,
  SLocked,
  WrongTyp,
  WrongORef,
  GetORef,
  WasAuto,
  NeedsDelete,
  NoValue,
  WTSOk   :  Boolean;

  OrigFolio
          :  LongInt;

  B_Func,
  LastStatus
          :  Integer;

  TempInv :  InvRec;



Begin

  KeyChk:='';  LastStatus:=0; TempInv:=Inv;

  KeyS:=FullNomKey(MinLInt);

  LoopCtrl:=BOn; {* Switched to Searching by Folio number so any corruption was detected *}

  SysOk:=BOff;  GetORef:=BOff;    NeedsDelete:=BOff;


  SLocked:=BOff;

  GetMultiSys(BOff,SysOk,SysR);

  GetMultiSysCur(BOff,SLocked);

  Repeat

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    With Id do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      NoDocH:=BOff;
      FDocH:=BOff;
      WrongTyp:=BOff;
      WrongORef:=BOff;
      WTSOk:=BOff;
      OrigFolio:=0;
      Posted:=BOff;
      WasAuto:=BOff;

      B_Func:=B_GetNext;

      KeyI:=GetECTD(Byte(IdDocHed));

      If (KeyI<>'ERROR') then
      Begin

        If (IdDocHed<>RUN) and (PostedRun<>PayInRunNo) then
        Begin

          If (Inv.FolioNum<>FolioRef) or (Inv.InvDocHed<>IdDocHed) then
          Begin

            KeyI:=FullNomKey(FolioRef);

            Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

            {* Check for Exsisting Header, but wrong doc type, or folio of 0 *}

            WrongTyp:=((StatusOk) and ((Inv.InvDocHed<>IdDocHed)) or (FolioRef=0));

            WrongOref:=(Not WrongTyp) and (StatusOk) and (FolioRef=Inv.FolioNum) and (Inv.OurRef<>DocPRef);

            Posted:=(Not StatusOk) and (PostedRun<>0) and (PostedRun<>StkADJRunNo);

            WasAuto:=(Not StatusOk) and (FolioRef<0) and (IdDocHed In SalesSplit+PurchSplit-PSOPSet-QuotesSet-BatchSet+NomSplit);

            NeedsDelete:=((Not WasAuto) and (Not Posted)and (Not WrongORef) and (FolioRef=0) and ((Qty=0.0) or (NetValue=0.0)) and ((Trim(StockCode)='') or (Qty=0.0)));

            // MH 26/03/2009: Added support for new discount fields for Advanced Discounts
            //NoValue:=((Id.Qty=0.0) or ((Id.NetValue=0.0) and (Id.Discount=0.0)));
            NoValue := (Id.Qty=0.0) or ((Id.NetValue=0.0) and (Id.Discount=0.0) and (Id.Discount2=0.0) and (Id.Discount3=0.0));

            // CJS 06/05/2011: Reinstated check to exclude posted Transaction Lines
            If ((Not StatusOk) or (WrongTyp) or (WrongORef)) and (Not Posted) and (Not WasAuto) and (Not NeedsDelete) and (Not noValue) then
//            If ((Not StatusOk) or (WrongTyp) or (WrongORef)) and (Not WasAuto) and (Not NeedsDelete) and (Not noValue) then
            With Inv do
            Begin

              NoDocH:=BOn;



              If (Not WrongORef) then {* Only store new inv if we have not found original *}
              Begin
                ResetRec(Fnum2);

                If (WrongTyp) then {* We need to move it away, as it belongs to the wrong header *}
                Begin
                  OrigFolio:=FolioRef;
                  FolioRef:=SetNextFolioNos(IdDocHed,BOn);
                end;

                FolioNum:=FolioRef;
                Inv.CustCode:=Id.CustCode;
                InvDocHed:=IdDocHed;
                TransDate:=PDate;
                DueDate:=TransDate;

                NomAuto:=BOn;
                ILineCount:=1;
                NLineCount:=1;

                If (PPr<1) then
                  AcPr:=1
                else
                  AcPr:=PPr;

                If (PYr<1) then
                  AcYr:=99
                else
                  AcYr:=PYr;


                Inv.Currency:=Id.Currency;


                Inv.CXrate[BOn]:=Id.CXRate[BOn];

                If (Inv.CXRate[BOn]=0.0) then
                  Inv.CXRate[BOn]:=1.0;

                OrigRates:=Id.CXRate;

                VATCRate:=SyssCurr.Currencies[Syss.VATCurr].CRates;


                CustSupp:=TradeCode[(InvDocHed In SalesSplit)];

                If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                  CustSupp:=Chr(Succ(Ord(CustSupp)));

                RunNo:=Set_OrdRunNo(InvDocHed,BOff,BOff);


                If (Length(DocPRef)=9) and (Copy(DocPRef,1,3)=DocCodes[InvDocHed]) then
                Begin
                  OurRef:=DocPRef;

                  KeyI:=DocPRef;

                  TempInv:=Inv;

                  Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath3,KeyI);

                  Inv:=TempInv;

                  GetORef:=(Status=0); {* If we can find it, the ref is no good *}
                end
                else
                  GetORef:=BOn;

                If (GetORef) then
                    OurRef:=SetNextDocORef(InvDocHed,BOn);

                Set_DocAlcStat(Inv);

                Status:=Add_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2);

                FDocH:=(StatusOk);

                LastStatus:=Status;
              end;

            end;

            Id.DocPRef:=Inv.OurRef;  {* Resynchronise *}

            If ((FDocH) and (WrongTyp)) or (WrongORef) or ((FDocH) and (GetORef)) then
            Begin
              {* Preserve Pos *}

              Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

              FDocH:=(FDocH or WrongORef);

              WTSOk:=StatusOk;

              If (StatusOk) then
              Begin
                If (WrongTyp) then
                  B_Func:=B_GetGEq
                else
                  B_Func:=B_GetNext;
              end;


            end {If not found..}
            else
            Begin
              If (WasAuto) or (NeedsDelete) then {We need to remove it}
              Begin
                If (WasAuto) then
                  Write_FixLog(FNum,'A line from a deleted auto item has been detected.')
                else
                  Write_FixLog(FNum,'A line with zero value and no folio ref has been detected.');


                Write_FixLogFmt(FNum,'Folio : '+Form_Int(Id.FolioRef,0)+'. Line No. '+Form_Int(Id.LineNo,0)+'. Run No. '+
                                             Form_Int(Id.PostedRun,0),0);

                Write_FixLogFmt(FNum,'Stock Code :'+Id.StockCode+'. Desc : '+Desc,0);


                Write_FixLog(FNum,ConstStr('-',80));

                Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                If (Status=0) then
                Begin
                  Write_FixLog(FNum,'This line has been deleted');
                  B_Func:=B_GetGEq;
                end
                else
                  Write_FixLog(FNum,'Unable to delete line . Report error '+Form_Int(Status,0));



              end;


            end;


          end {If Already found..}
          else
          begin
            KeyS := FullNomKey(Inv.FolioNum + 1);
            B_Func := B_GetGEq;
          end;

        end; {If Run time line..}

        If (NoDocH) then
        Begin

          If (FDocH) then
          Begin

            If (WrongTyp) then
            Begin
              Write_FixLogFmt(FNum,'Unable to locate correct Document header for Line Folio : '+Form_Int(OrigFolio,0)+
                                'Doc Type: '+DocCodes[Id.IdDocHed]+', Account: '+Id.CustCode,0);

              If (WTSOk) then
                Write_FixLogFmt(FNum,'New folio : '+Form_Int(Id.FolioRef,0)+' generated.',0)
              else
                Write_FixLogFmt(FNum,'Failed to store line with new folio '+Form_Int(FolioRef,0)
                               +'. Report error '+Form_Int(Status,0),0);
            end;

            If (Not WrongOref) then
              Write_FixLogFmt(FNum,'Document header  '+Inv.OurRef+', created for folio: '+Form_Int(Id.FolioRef,0),0);
          end
          else
          Begin
            Write_FixLogFmt(FNum,'Unable to find document header for '+DocCodes[IdDocHed]+', folio: '+
                              Form_Int(FolioRef,0),0);
            Write_FixLogFmt(FNum2,'Failed to create document '+Inv.OurRef+', for folio: '+Form_Int(FolioRef,0)
                               +'. Report error '+Form_Int(LastStatus,0),4);

            Write_FixLog(FNum,ConstStr('-',80));

          end;
        end
        else
          If (Posted) then
          Begin
            Write_FixLogFmt(FNum,'Unable to locate correct Document header for Line Folio : '+Form_Int(FolioRef,0)+
                              '. Doc Type: '+DocCodes[Id.IdDocHed]+', Account: '+Id.CustCode,0);

            Write_FixLogFmt(FNum,'Stock Code :'+Id.StockCode+'. Desc : '+Desc,0);

            Write_FixLogFMT(FNum,'This line cannot be fixed as it is marked as posted on Run No. '+Form_Int(PostedRun,0),4);

            Write_FixLog(FNum,ConstStr('-',80));

          end;
      end
      else
      Begin
        Write_FixLog(FNum,'A corrupted unrecognised line has been detected.');


        Write_FixLogFmt(FNum,'Folio : '+Form_Int(Id.FolioRef,0)+'. Line No. '+Form_Int(Id.LineNo,0)+'. Run No. '+
                                     Form_Int(Id.PostedRun,0),0);

        Write_FixLogFmt(FNum,'Stock Code :'+Id.StockCode+'. Desc : '+Desc,0);


        Write_FixLog(FNum,ConstStr('-',80));

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        If (Status=0) then
        Begin
          Write_FixLogFMT(FNum,'This line has been deleted',3);
          B_Func:=B_GetGEq;
        end
        else
          Write_FixLogFMT(FNum,'Unable to delete line . Report error '+Form_Int(Status,0),4);



      end;


      Inc(MFind);


      If (MFind<TotalCount) and (Assigned(ProgBar)) then
      begin
        ProgBar.ProgressBar1.Position:=MFind;
        if ((MFind mod 10) = 0) then
          ProgBar.InfoLbl.Caption := IntToStr(MFind) + ' of ' + IntToStr(TotalCount) + ' records processed';
      end;


      RunOk:=(RunOk and (Status In [0,4,5]));


      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    LoopCtrl:=Not LoopCtrl;

    KeyChk:=FullNomKey(StkAdjRunNo);
    KeyS:=KeyChk;

  Until (Not LoopCtrl) or (Not RunOk);

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



{ ====== Procedure to Reset Zero folio number on specified transaction ====== }

{AP 05/06/2018 2018R2 ABSEXCH-20310:Special Function to set folio number on specified transaction when folio number = 0}
procedure ResetZeroFolioTrans(var ARunOk: Boolean;
                              var ATotalCount, AMFind: LongInt;
                              AProgBar: TSFProgressBar);
var
  lDetKey,
  lDocKey,
  lDocKeyChk: Str255;
  lStatus: LongInt;    
  B_Func: Integer;
begin
  FillChar(lDocKey,Sizeof(lDocKey),0);
  lDocKeyChk:=FullNomKey(0);
  lDocKey:=lDocKeyChk+FullNomKey(1);  
  B_Func := B_GetNext;
  lStatus := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, lDocKey);

  while (lStatus = 0) and (CheckKey(lDocKeyChk, lDocKey, Length(lDocKeyChk), BOn)) do
  begin
    Application.ProcessMessages;
    if Assigned(AProgBar) then
      ARunOk := not (AProgBar.Aborted);

    Inv.FolioNum := SetNextFolioNos(Inv.InvDocHed, True);
    lDetKey := Inv.OurRef;

    //Update Details Table Folio Num based on OurRef
    Status := Find_Rec(B_GetEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdDocPRefK, lDetKey);
    while (StatusOK) and (Id.FolioRef = 0) and (Inv.OurRef = Id.DocPRef) do
    begin
      Id.FolioRef := Inv.FolioNum;  {* Resynchronise *}
      
      //Update Folio num in to Detail table
      Status := Put_Rec(F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdDocPRefK);
      if not StatusOK then
        Write_FixLogFmt(IDetailF, 'Unable to update Transaction Line. Error ' + Form_Int(Status, 0), 4);

      Status := Find_Rec(B_GetNext, F[IDetailF] ,IDetailF ,RecPtr[IDetailF]^ ,IdDocPRefK, lDetKey);
    end;

    //Update Folio Num in to Document Table
    lStatus := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvFolioK);

    if (lStatus = 0) then
    begin
      Write_FixLogFmt(InvF, 'New folio : ' + Form_Int(Inv.FolioNum,0) + ' generated for '+  Trim(Inv.OurRef), 0);
      Inc(AMFind);
      B_Func := B_GetGEq;
    end
    else
    begin
      Write_FixLogFmt(InvF, 'Failed to store transaction with new folio for ' + Trim(Inv.OurRef)
                               + '. Report error ' + Form_Int(lStatus, 0), 0);
      B_Func:= B_GetNext;
    end;

    if (AMFind < ATotalCount) and Assigned(AProgBar) and ARunOk then
    begin
      AProgBar.ProgressBar1.Position := AMFind;
      if ((AMFind mod 10) = 0) then
        AProgBar.InfoLbl.Caption := IntToStr(AMFind) + ' of ' + IntToStr(ATotalCount) + ' records processed';
    end;

    ARunOk := (ARunOk and (lStatus In [0,5]));
    
    lStatus := Find_Rec(B_Func, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, lDocKey);
  end;
  
  if (Assigned(AProgBar)) and ARunOk then
    AProgBar.ProgressBar1.Position := ATotalCount;
end;


{ ====== Procedure to delete all matching allocation information ====== }
{1 = All matching info
 2 = Cust matching info
 3 = Supplier matching info }

Procedure Remove_Match(Mode  :  Integer;
                   Var RunOk :  Boolean;
                   Var TotalCount,
                       MFind :  LongInt;
                       ProgBar
                             :  TSFProgressBar);


Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;

  Fnum2     =  CustF;
  Keypath2  =  CustCodeK;

  Fnum3     =  InvF;
  Keypath3  =  InvOurRefK;


Var
  KeyI,
  KeyS,
  KeyChk  :  Str255;

  Ok2Del  :  Boolean;

  B_Func  :  Integer;



Begin
  // CJS 2011-10-26: ABSEXCH-11616 - SF 50 & 51 do not delete matching records
  {$IFDEF EXSQL}
  if UsingSQL then
    KeyChk := MatchTCode + MatchSCode
  else
  {$ENDIF}
    KeyChk := MatchTCode;

  KeyS:=KeyChk;

  B_Func:=B_GetNext;

  Ok2Del:=BOff;

  Status:=Find_Rec(B_GetGeq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With PassWord.MatchPayRec do
  Begin

    Ok2Del:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
    begin
      RunOk := (Not (ProgBar.Aborted));
      ProgBar.ProgLab.Caption := 'Searching...';
    end;

    Case Mode of

      1,2,3
         :  If (MatchType='A') then
            Begin
              Case Mode of

                2,3:  Begin
                        KeyI:=DocCode;

                        Status:=Find_Rec(B_GetEq,F[Fnum3],Fnum3,RecPtr[Fnum3]^,Keypath3,KeyI);

                        If (StatusOk) then
                        Begin
                          KeyI:=Inv.CustCode;

                          Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

                          Ok2Del:=(StatusOk) and (Cust.CustSupp=TradeCode[(Mode=2)]);

                          // CJS 2011-10-26: reset the Status so that the loop
                          // doesn't end just because we couldn't find a
                          // customer for this particular invoice.
                          Status := 0;
                        end;
                      end;

                else  Ok2Del:=BOn;
              end; {Case..}


              If (Ok2Del) then
              Begin
                Inc(MFind);

                If (Assigned(ProgBar)) then
                begin
                  ProgBar.ProgLab.Caption := 'Removing matching for ' + DocCode;
                end;

                Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

                If (Not StatusOk) then
                Begin

                  Write_FixLogFmt(FNum,'Unable to match record for '+DocCode+'/'+PayRef+', report error '+Form_Int(Status,0),4);

                  B_Func:=B_GetNext;
                end
                else
                  B_Func:=B_GetGEq;
              end
              else
                B_Func:=B_GetNext;

            end
            else
              B_Func:=B_GetNext;

      4  :  If (MatchType='O') and ((MCurrency In [3,8]) or (RCurrency In [3,8])) then
            Begin

              If (Assigned(ProgBar)) then
              begin
                ProgBar.ProgLab.Caption := 'Removing matching for ' + DocCode;
              end;

              Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

              Inc(MFind);
              If (Not StatusOk) then
              Begin

                Write_FixLogFmt(FNum,'Unable to match record for '+DocCode+'/'+PayRef+', report error '+Form_Int(Status,0),4);

                B_Func:=B_GetNext;
              end
              else
                B_Func:=B_GetGEq;
            end
            else
              B_Func:=B_GetNext;

    end; {Case..}

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}



{ ====== Procedure to Scan all Stock records, and set the ROC price the same as the R-Order price ====== }

Procedure Set_StockCost(Var RunOk :  Boolean;
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



    ROCPrice:=CostPrice;

    If (PCurrency>0) then
      ROCurrency:=PCurrency
    else
      ROCurrency:=1;

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


{ ====== Procedure to delete any unposed runtime lines ====== }

Procedure Repair_NomLine(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  IdetailF;
  Keypath   =  IdRunK;
  Fnum2     =  InvF;
  Keypath2  =  InvFolioK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Boolean;

  B_Func  :  Integer;


Begin
  FillChar(KeyS,Sizeof(KeyS),0);

  KeyChk:=FullNomKey(0);

  KeyS:=KeyChk+FullNomKey(1);

  LoopCtrl:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    B_Func:=B_GetNext;

    If (Not (IdDocHed In OrderSet+[RUN]+JAPSplit)) then
    Begin
      KeyI:=FullNomKey(FolioRef);

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

      If (StatusOk) and (Inv.RunNo>0) and (Inv.RunNo<>PostedRun) and (Qty<>0) and (NetValue<>0) and
         (NomCode<>0) then
      Begin
        Write_FixLogFmt(FNum,'Transaction '+Inv.OurRef+', Line '+Form_Int(LineNo,0)+', '+Id.Desc,0);
        Write_FixLogFmt(FNum,'Posting Run '+Form_Int(PostedRun,0)+' changed to '+Form_Int(Inv.RunNo,0),0);


        PostedRun:=Inv.RunNo;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        If (Status<>0) then
          Write_FixLogFmt(FNum,'** Unable to Store line '+Id.Desc+'. Report error '+Form_Int(Status,0),4)
        else
          B_Func:=B_GetGEq;

        RunOk:=(RunOk and (Status In [0,5]));

      end; {If ok to change..}

    end; {If Run time line..}


    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=MFind;



    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


{ ====== Procedure to Scan all Account records, and set the Statment flag to yes ====== }

Procedure Set_CustStaFlg(Var RunOk :  Boolean;
                         Var MFind,
                             TotalCount
                                   :  LongInt;
                             ProgBar
                                   :  TSFProgressBar);



Const
  Fnum      =  CustF;


Var
  KeyS    :  Str255;
  OldFlg  :  Boolean;



Begin

  KeyS:='';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Cust do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    OldFlg:=IncStat;

    If (CustSupp=TradeCode[BOn]) then
      IncStat:=BOn;

    If (OldFlg<>IncStat) then
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




{ ====== Procedure to Scan all detail lines beloning to Orders, and see if O/S  ====== }

Function Check_DetailsLG(Mode  :  Integer;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    FoundOk:=(Round(Qty-(QtyDel+QtyWOff))<>0);

    If (Not FoundOk) and (DeductQty<>0) then {* Qty is not o/s so set deduct to same *}
    Begin
      DeductQty:=0;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

      end
      else
      Begin

        Write_FixLogFmt(FNum,'Doc '+Inv.OurRef+' Line '+Form_Int(LineNo,0)+' qty '+Form_Real(DeductQty,0,4)+' Adjusted to 0',0);

      end;

    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Check_DetailsLG:=FoundOk;

end; {Proc..}



{ ========== Procedure to Fix Document Header ========= }


Procedure Fix_HistSPOP(Var TotalCount,
                           LCount:  LongInt;
                       Var RunOk :  Boolean;
                           ProgBar
                                 :  TSFProgressBar);


Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;

  LoopKey  :  Array[BOff..BOn,BOff..BOn] of Integer = ((OrdUSRunNo,OrdPSRunNo),
                                                      (OrdUPRunNo,OrdPPRunNo));


Var

  KeyChk,
  KeyS     :  Str255;

  Loop     :  Boolean;

  B_Func   :  Integer;




Begin

  Loop:=BOff;

  B_Func:=B_GetNext;

  Repeat

    KeyChk:=FullNomKey(LoopKey[Loop,BOn]);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Inv do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


      If (Check_DetailsLG(0,RunOk,ProgBar)) then;



      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    Loop:=Not Loop;

  Until (Not Loop) or (Not RunOk);

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



{ ========== Procedure to Fix Document Header ========= }


Procedure Del_BadDoc(Var TotalCount,
                         LCount:  LongInt;
                         DMode :  Byte;
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

  DTStr    :  Str10;


Begin
  DTStr:='';

  
  FillChar(KeyChk,Length(KeyChk),0);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    B_Func:=B_GetNext;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    DTStr:=GetECTD(Byte(InvDocHed));

    If (DTStr<>Copy(OurRef,1,3)) then
    Begin
      Write_FixLogFmt(FNum,'Doc '+Inv.OurRef,3);
      Write_FixLogFmt(FNum,' does not match Doc Type '+DTStr+', and is likely to be corrupt.',0);

      Disp_PartInv(Fnum);

      If (RunNo>0) then
      Begin
        Write_FixLogFmt(FNum,'It is showing a Posting Run No. of '+Form_Int(RunNo,0),0);
        Write_FixLog(FNum,'. So deleting it will require an unpost to be performed.')
      end
      else
      Begin
        If (RunNo =AutoRunNo) then
        Begin
          Write_FixLogFmt(FNum,'It is showing an Auto Daybook Run No. of '+Form_Int(RunNo,0),0);
          Write_FixLog(FNum,'. So deleting will have no impact on the Accounts.');
        end
        else
          If (RunNo >=BatchPostRunNo) and (RunNo<=BatchRunNo) then
          Begin
            Write_FixLogFmt(FNum,'It is showing a Batch Run No. of '+Form_Int(RunNo,0),0);
            Write_FixLog(FNum,'. So deleting will have no impact on the Accounts.');
          end
          else
            If (RunNo=StkADJRunNo) then
            Begin
              Write_FixLogFmt(FNum,'It is showing a Stock Adjustment Run No. of '+Form_Int(RunNo,0),0);
              Write_FixLog(FNum,'. So deleting will have an impact on stock, and Check will need to be Run.');
            end
            else
              If (RunNo >=OrdPPRunNo) and (RunNo<=OrdUSRunNo) then
              Begin
                Write_FixLogFmt(FNum,'It is showing an SPOP Run No. of '+Form_Int(RunNo,0),0);
                Write_FixLog(FNum,'. So deleting will have an impact on stock, and Check will need to be Run.');
              end
              else
                If (RunNo >=StkValARunNo) and (RunNo<=StkValRRunNo) then
                Begin
                  Write_FixLogFmt(FNum,'It is showing a Stk Valuation Run No. of '+Form_Int(RunNo,0),0);
                  Write_FixLog(FNum,'. So deleting will have no impact on the accounts.');
                end
                else
                  If (RunNo=TSTPostRunNo) then
                  Begin
                    Write_FixLogFmt(FNum,'It is showing a Time Sheet Run No. of '+Form_Int(RunNo,0),0);
                    Write_FixLog(FNum,'. So deleting will have an impact on accounts and Job Costing.');
                    Write_FixLogFmt(FNum,'An unpost will be necessary.',0);
                  end
                  else
                    If (RunNo=MDCCARunNo) then
                    Begin
                      Write_FixLogFmt(FNum,'It is showing a MC Revaluation Run No. of '+Form_Int(RunNo,0),0);
                      Write_FixLog(FNum,'. So deleting will have no impact on the accounts.');
                      Write_FixLog(FNum,'However it is an indication of an interrupted revalaution.');
                    end
                    else
                      If (RunNo=0) then
                      Begin
                        Write_FixLogFmt(FNum,'It is showing an unposted Run No. of '+Form_Int(RunNo,0),0);
                        Write_FixLog(FNum,'. So deleting will have a small impact on the accounts.');
                        Write_FixLog(FNum,'Running Check for Accounts and Stock will adjust the difference.');
                    end
                    else
                    Begin
                      Write_FixLogFmt(FNum,'It is showing a Special Run No. of '+Form_Int(RunNo,0),0);
                      Write_FixLog(FNum,'. So deleting will have no impact on the Accounts.');
                    end;

        Write_FixMsg('');
      end;




      If (DMode=1) then
      Begin

        If (FolioNum<>0) then
          Delete_Details(RunOk);

        If (RunOk) then
        Begin
          Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

          If (Not StatusOk) then
          Begin

            Write_FixLogFmt(FNum,'Unable to delete Doc: '+Inv.OurRef+', report error '+Form_Int(Status,0),4);

          end
          else
            B_Func:=B_GetGEq;


        end;

      end;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}



{ ====== Procedure to Unallocate all customer and supplier transactions ====== }

Procedure Unallocate_Trans(    Mode  :  Byte;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvCDueK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl,
  SysOk,
  NoDocH,
  FDocH   :  Boolean;



Begin
  SysOk:=BOff;

  GetMultiSys(BOff,SysOk,SysR);

  GetMultiSys(BOff,SysOk,VATR);

  If (Assigned(ProgBar)) then
  begin
    ProgBar.ProgLab.Caption := 'Searching...';
  end;

  Case Mode of
    1    :  FillChar(KeyChk,Sizeof(KeyChk),0);

    2,3  :  KeyChk:=TradeCode[(Mode=2)];
  end; {Case..}

  KeyS:=KeyChk+#32;

  LoopCtrl:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Inv do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
    begin
      RunOk := (Not (ProgBar.Aborted));
      ProgBar.ProgLab.Caption := 'Searching...';
    end;

    If (Not (InvDocHed in DirectSet)) and (RevalueAdj=0.0) then
    Begin
      If (Assigned(ProgBar)) then
      begin
        ProgBar.ProgLab.Caption := 'Unallocating ' + OurRef;
      end;

      Settled:=0;

      CurrSettled:=0;

      CXRate[BOff]:=0;

      FillChar(RemitNo,Sizeof(RemitNo),0);


      If (VAT_CashAcc(SyssVAT.VATRates.VATScheme)) then  {* Cash Accounting set Blank VATdate &
                                                            Until Date *}
      Begin
        If (SettledVAT=0) then
        Begin

          FillChar(VATPostDate,Sizeof(VATPostDate),0);

          UntilDate:=NdxWeight;

          {FillChar(UntilDate,Sizeof(UntilDate),0);}

        end
        else
        Begin

          VATPostDate:=SyssVAT.VATRates.CurrPeriod;

          UntilDate:=Today;

        end;
      end
      else
        UntilDate:=NdxWeight;


      Set_DocAlcStat(Inv);  {* Set Allocation Status *}

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),40);

      end;


      Inc(MFind);
    end;

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

  If (RunOk) then
    Remove_Match(Mode,RunOk,TotalCount,MFind,ProgBar);

 end; {Proc..}


 { ====== Procedure to delete all Protectrd mode log records ====== }

Procedure Remove_PMPMode(Mode  :  Integer;
                     Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         ProgBar
                               :  TSFProgressBar);


Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;


Var
  KeyS,
  KeyChk  :  Str255;

  Ok2Del  :  Boolean;

  B_Func  :  Integer;



Begin

  KeyChk:='LM';

  KeyS:=KeyChk;

  B_Func:=B_GetNext;

  Ok2Del:=BOff;

  Status:=Find_Rec(B_GetGeq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  Begin

    Ok2Del:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);


    If (Not StatusOk) then
    Begin
      Write_FixLogFmt(FNum,'Unable to Delete Protected mode post record. Report error '+Form_Int(Status,0),4);

      B_Func:=B_GetNext;
    end
    else
      B_Func:=B_GetGEq;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



Procedure UOR_FIFOSNo(Var RunOk    :  Boolean;
                      Var TotalCount,
                          LCount   :  LongInt;
                          Mode     :  Byte;
                          MaxFolio :  LongInt;
                          MaxDate  :  LongDate;
                          ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;

Var
  KeyF,
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  TimeR :  TimeTyp;


Begin
  KeyChk:=MFIFOCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting FIFO + Serial  Records';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MiscRecs^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=MSernSub) then
    With SerialRec do
    Begin
      If (InDoc='') then
        KeyF:=InOrdDoc
      else
        KeyF:=InDoc;

      If (CheckRecExsists(KeyF,InvF,InvOurRefK)) then
      Begin
        Ok2Store:=(SUseORate<>Inv.UseORate) and ((Mode=0) or ((Inv.FolioNum>MaxFolio)
                                           or ((Inv.InvDocHed In [PDN,SDN]) and (Inv.TransDate>MaxDate))));

        If (Ok2Store) then
          SUseORate:=Inv.UseORate;

      end;
    end
    else
      If (SubType=MFIFOSub) then
      With FIFORec do
      Begin
        KeyF:=DocRef;

        If (CheckRecExsists(KeyF,InvF,InvOurRefK)) then
        Begin
          Ok2Store:=(FUseORate<>Inv.UseORate) and ((Mode=0) or ((Inv.FolioNum>MaxFolio)
                                           or ((Inv.InvDocHed In [PDN,SDN]) and (Inv.TransDate>MaxDate))));

          If (Ok2Store) then
            FUseORate:=Inv.UseORate;

        end;

      end;


    If (Ok2Store) then
    Begin

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update FIFO/SNo record '+SerialRec.SerialCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}



Procedure UOR_JobAct(Var RunOk :  Boolean;
                     Var TotalCount,
                         LCount:  LongInt;
                         Mode     :  Byte;
                         MaxFolio :  LongInt;
                         MaxDate  :  LongDate;
                         ProgBar
                                  :  TSFProgressBar);



Const
  Fnum      =  JDetlF;
  Keypath   =  JDLedgerK;

Var
  KeyChk,
  KeyS,
  KeyF  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  TimeR :  TimeTyp;


Begin
  KeyChk:=JBRCode;

  KeyS:=KeyChk;


  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Job Actual Records';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With JobDetl^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=JBECode) then
    With JobActual do
    Begin
      KeyF:=LineORef;

      If (CheckRecExsists(KeyF,InvF,InvOurRefK)) then
      Begin
        Ok2Store:=(JUseORate<>Inv.UseORate)  and ((Mode=0) or ((Inv.FolioNum>MaxFolio)
                                           or ((Inv.InvDocHed In [PDN,SDN]) and (Inv.TransDate>MaxDate))));

        If (Ok2Store) then
          JUseORate:=Inv.UseORate;

      end;

    end;

    If (Ok2Store) then
    Begin

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Job Actual record '+JobActual.LedgerCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


end; {Proc..}




{ ====== Procedure to Scan all detail lines beloning to SQU and x -1====== }

Procedure Set_DetailsUOR(Mode  :  Integer;
                     Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         MaxFolio
                               :  LongInt;
                         MaxDate
                               :  LongDate;
                         ProgBar
                               :  TSFProgressBar);


Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Detail Lines';

  While (StatusOk) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    LoopCtrl:=UseORate;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;


    If (Not (IdDocHed In PSOPSet+[ADJ,TSH])) then
      UseORate:=Ord((FolioRef<=MaxFolio) or (MaxFolio=0))
    else
      UseORate:=Ord(PDate<=MaxDate);


    If (LoopCtrl<>UseORate) then
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

    If (Not StatusOk) then
    Begin

      Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

end; {Proc..}





Procedure SetDocUOR(Var RunOk :  Boolean;
                    Var TotalCount,
                        MFind :  LongInt;
                        MaxFolio
                              :  LongInt;
                        MaxDate :  LongDate;
                        EuroCr:  Integer;
                        ProgBar
                              :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvFolioK;



Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  SysOk,
  Ok2Store,
  NoDocH,
  FDocH   :  Boolean;



Begin
  SysOk:=BOff;

  GetMultiSysCur(BOff,SysOk);

  {Get Nom Folio Number}

  Begin


    LoopCtrl:=0;

    KeyChk:=FullNomKey(0);

    KeyS:=KeyChk;

    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Converting Document Headers';

    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) do
    With Inv do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      LoopCtrl:=UseORate;

      If (Not (InvDocHed In PSOPSet+[ADJ,TSH])) then
        UseORate:=Ord(((FolioNum<=MaxFolio) or (MaxFolio=0)) and ((EuroCr=0) or (EuroCr<>Inv.Currency)))
      else
        UseORate:=Ord((TransDate<=MaxDate) and ((EuroCr=0) or (EuroCr<>Inv.Currency)));

      If (LoopCtrl<>UseORate) then
        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);


      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;



      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    If (RunOk) then {* Set Lines *}
      Set_DetailsUOR(0,RunOk,TotalCount,MFind,MaxFolio,MaxDate,ProgBar);

    If (RunOk) then
      UOR_FIFOSNo(RunOk,TotalCount,MFind,0,MaxFolio,MaxDate,ProgBar);

    If (RunOk) then
      UOR_JobAct(RunOk,TotalCount,MFind,0,MaxFolio,MaxDate,ProgBar);

  end;

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}


{ ====== Procedure to Scan all detail lines beloning to SQU and x -1====== }

Function ReSet_DetailsUOR(Mode  :  Integer;
                      Var RunOk :  Boolean;
                          ProgBar
                                :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;

  Fnum2     =  StockF;
  Keypath2  =  StkCodeK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (UseORate<>Inv.UseORate) then
    Begin
      UseORate:=Inv.USeORate;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      FoundOk:=BOn;

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

      end;


    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  ReSet_DetailsUOR:=FoundOk;

end; {Proc..}


Procedure ResetDocUOR(Var RunOk :  Boolean;
                      Var TotalCount,
                          MFind :  LongInt;
                          MaxFolio
                                :  LongInt;
                          MaxDate :  LongDate;
                          EuroCr:  Integer;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvRNoK;



Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;
  Loop2,
  LoopCtrl:  Byte;

  SysOk,
  Ok2Store,
  NoDocH,
  FDocH   :  Boolean;



Begin
  SysOk:=BOff;

  GetMultiSysCur(BOff,SysOk);

  {Get Nom Folio Number}

  If (MaxFolio<>0) and (EuroCr<>0) then
  Begin


    LoopCtrl:=0;  Loop2:=0;

    KeyChk:=FullNomKey(0);

    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Converting Document Headers';


    Repeat
      KeyS:=KeyChk;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Inv do
      Begin

        Application.ProcessMessages;

        If (Assigned(ProgBar)) then
          RunOk:=(Not (ProgBar.Aborted));



        LoopCtrl:=UseORate;

        If (InvDocHed In [SIN,PIN,PDN,SDN]) and
           (((FolioNum>MaxFolio) or ((InvDocHed In [SDN,PDN]) and (Inv.TransDate>MaxDate)))
                              and (EuroCr<>Inv.Currency) and (Inv.Currency>1)) then
          UseORate:=0;

        If (LoopCtrl<>UseORate) then
        Begin


          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

          RunOk:=(RunOk and (Status In [0,5]));

          {* Set Lines *}
          If ReSet_DetailsUOR(0,RunOk,ProgBar) then;
        end;


        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

        end;


        Inc(MFind);

        If (MFind<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=MFind;


        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

      end; {While..}

      Inc(Loop2);

      Case Loop2 of
        1  :  KeyChk:=FullNomKey(OrdUSRunNo);

        2  :  KeyChk:=FullNomKey(OrdUPRunNo);
      end;

    Until (Loop2>2) or (Not RunOk);

    If (RunOk) then
      UOR_FIFOSNo(RunOk,TotalCount,MFind,1,MaxFolio,MaxDate,ProgBar);

    If (RunOk) then
      UOR_JobAct(RunOk,TotalCount,MFind,1,MaxFolio,MaxDate,ProgBar);

  end;


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


{ ====== Procedure to Scan all Account records, and set the payment terms to system set up defaults ====== }

Procedure Set_CustSetlTerm2(Var RunOk :  Boolean;
                            Var MFind,
                                TotalCount
                                      :  LongInt;
                                CS    :  Boolean;
                                Mode  :  Byte;
                                ProgBar
                                      :  TSFProgressBar);


Const
  Fnum      =  CustF;


Var
  KeyS    :  Str255;


  SysOk   :  Boolean;


Begin

  KeyS:='';

  SysOk:=BOff;


  GetMultiSys(BOff,SysOk,SysR);


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Cust do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (CustSupp=TradeCode[CS]) then
    Begin

      // CJS 2015-06-30 - ABSEXCH-16614 - remove Special Functions 55 and 56
      {
      If (Mode In [55,56]) then
      Begin
        DefSetDDays:=Syss.SettleDays;
        DefSetDisc:=Syss.SettleDisc;
      end
      else
      }
        If (Mode In [76,77]) then
        Begin
          EmlSndRdr:=True;

        end
        else
          If (Mode In [81,82]) then
          Begin
            AllowWeb:=1;

          end;



      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;
    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;


    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}

end; {Proc..}


{ ====== Procedure to Scan all Stock records, and set Allow on Web ====== }

Procedure Set_StockWeb(Var RunOk :  Boolean;
                       Var MFind,
                           TotalCount
                                 :  LongInt;
                           Mode  :  Byte;
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


    If (StockCat<>'X') then
    Begin

      If (Mode In [83]) then
      Begin
        WebInclude:=1;
      end;



      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;
    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;


    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}

end; {Proc..}


{ ====== Procedure to Scan all detail lines beloning to SQU and x -1====== }

Function Set_DetailsCP(Mode  :  Integer;
                   Var RunOk :  Boolean;
                       ProgBar
                             :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;

  Fnum2     =  StockF;
  Keypath2  =  StkCodeK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=(Mode=69);


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If ((CostPrice=0) or (Mode In [67,70,79])) and (StockCode<>'') and (Mode<>69) then
    Begin


      KeyI:=StockCode;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

      If (Status=0) then
      Begin

        If (Mode=70) then
          CostPrice:=0.0
        else
          CostPrice:=Currency_ConvFT(Stock.CostPrice,Stock.PCurrency,Id.Currency,UseCoDayRate);


        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        FoundOk:=BOn;

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

        end
        else
        Begin

        end;


      end;


    end;

    Inv.TotalCost:=Inv.TotalCost+(Qty*CostPrice);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Set_DetailsCP:=FoundOk;

end; {Proc..}



{ === Set cost price of any zero lines from stock record == }

Procedure SetUnptCost(Var RunOk :  Boolean;
                      Var TotalCount,
                          MFind :  LongInt;
                          Mode  :  Byte;
                          ProgBar
                                :  TSFProgressBar);



Const
  Fnum      =  InvF;
  Keypath   =  InvRNoK;

  Fnum2     =  CustF;
  Keypath2  =  CustCodeK;




Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  Ok2Store,
  LoopCtrl,
  NoDocH,
  SysOk,SLocked,
  FDocH   :  Boolean;



Begin

  LoopCtrl:=BOff;

  SysOk:=BOff;


  SLocked:=BOff;

  GetMultiSys(BOff,SysOk,SysR);

  GetMultiSysCur(BOff,SysOk);

  {GetMultiSys(BOff,SLocked,CurR);}


  Repeat
    If (Mode=79) then
      KeyChk:=FullNomKey(OrdUSRunNo)
    else
      KeyChk:=FullNomKey(0);

    KeyS:=KeyChk+#1;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    With Inv do
    Begin
      TotalCost:=0.0;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Ok2Store:=BOff;

      If (Not (InvDocHed In PurchSplit+[SRC,SBT,ADJ]+NomSplit)) then
      Begin

        Ok2Store:=(Set_DetailsCP(Mode,RunOk,ProgBar));

        If (Ok2Store) and (TotalCost<>0.0) then
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);
      end;


      If (Not StatusOk) and (Ok2Store) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    {LoopCtrl:=Not LoopCtrl;}

  Until (Not LoopCtrl) or (Not RunOk);


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



{ ========== Procedure to Clean up OurRef Key ========= }


Procedure CleanORef(Var TotalCount,
                        LCount:  LongInt;
                    Var RunOk :  Boolean;
                        ProgBar
                              :  TSFProgressBar);



Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;



Var
  OldORef  :  Str10;

  KeyS     :  Str255;


Begin
  KeyS:='';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    If (OurRef[10]<>#0) and (Length(OurRef)=9) then
    Begin
      FillChar(OldORef,Sizeof(OldORef),0);

      OldORef:=OurRef;

      FillChar(OurRef,Sizeof(OurRef),0);

      OurRef:=OldORef;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


    end;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



end; {Proc..}



{ ====== Procedure to set Authorised on all PIN's & PCR's  ====== }

Procedure Set_PINPCRAuth(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
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
  FDocH   :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=BOff;

  KeyS:='P';


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (KeyS[1]='P') do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (InvDocHed In [PIN,PCR]) then
    Begin

      HoldFlg:=(HoldFlg AND 128) + (HoldFlg AND 32) + 3;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


      RunOk:=(RunOk and (Status In [0,5]));

    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;


    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



{ ====== Procedure to reset Debt chase letter level  ====== }

Procedure Set_ResetDebtLtr(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
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
  FDocH   :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=BOff;


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (LastLetter<>0) then
    Begin

      LastLetter:=0;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


      RunOk:=(RunOk and (Status In [0,5]));

    end;

    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=MFind;


    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


{ ====== Procedure to Scan all detail lines and force a location code in ====== }

Procedure Set_DetailsLOC(Mode  :  Integer;
                     Var RunOk :  Boolean;
                     Var TotalCount,
                         MFind :  LongInt;
                         UseLoc:  Str10;
                         ProgBar
                               :  TSFProgressBar);


Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;


Var

  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl:  Byte;

  FoundOk :  Boolean;



Begin
  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;


  FoundOk:=BOff;

  Begin

    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);


    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Setting Blank Detail Lines to Loc '+UseLoc;

    While (StatusOk) and (RunOk) do
    With Id do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;


      If (MLocStk='') or (MLocStk='   ') and (Not (IdDocHed In [PPY,SRC,PBT,SBT,NMT,TSH,RUN]))
         and (StockCode<>'') and (StockCode<>LJVar('',16)) and (StockCode[1]<>#1) then
      Begin
        MLocStk:=UpCaseStr(LJVar(UseLoc,3));

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);
      end;

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

      end;

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}
  end;
end; {Proc..}


{ ====== Procedure to delete any unposed runtime lines ====== }

Procedure Clean_ReconFlg(Var RunOk :  Boolean;
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
    ProgBar.ProgLab.Caption:='Repairing corrupt reconcile flag';

  While (StatusOk) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    If (Reconcile>3) then
    Begin
      Reconcile:=0;

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




{ ====== Procedure to Scan all detail lines beloning to Orders, and see if O/S  ====== }

Function Check_DetailsBOM(Mode  :  Integer;
                      Var RunOk :  Boolean;
                          ProgBar
                                :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk  :  Str255;

  FoundOk :  Boolean;

  B_Func  :  Integer;



Begin

  If (Mode=0) then
    KeyChk:=FullRunNoKey(Inv.FolioNum,-1)
  else
    KeyChk:=FullRunNoKey(Inv.FolioNum,RecieptCode);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin
    B_Func:=B_GetNext;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    FoundOk:=((KitLink<>0)  and (Mode=0)) or ((LineNo=RecieptCode) and (Mode=1));

    If (FoundOk) and (DeductQty<>0) then {* This Should not be here *}
    Begin

      Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete BOM Line from Doc: '+Inv.OurRef+', report error '+Form_Int(Status,0),4);

      end
      else
      Begin
        B_Func:=B_GetGEq;

        If (Mode=1) then
        Begin
          Write_FixLogFmt(FNum,'Removed corrupt Line from Doc: '+Inv.OurRef+', Stk Code '+Trim(StockCode)+'. Qty '+Form_Real(DeductQty,0,3),4);

        end;
      end;



    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Check_DetailsBOM:=FoundOk;

end; {Proc..}



{ ========== Procedure to Fix Document Header ========= }


Procedure Fix_HistSPOPBOML(Var TotalCount,
                               LCount:  LongInt;
                           Var RunOk :  Boolean;
                               Mode  :  Integer;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;

  LoopKey  :  Array[BOff..BOn,BOff..BOn] of Integer = ((OrdUSRunNo,OrdPSRunNo),
                                                       (OrdUPRunNo,OrdPPRunNo));


Var

  KeyChk,
  KeyS     :  Str255;

  Loop     :  Boolean;

  B_Func   :  Integer;




Begin

  Loop:=BOff;

  B_Func:=B_GetNext;

  Repeat

    KeyChk:=FullNomKey(LoopKey[Loop,BOn]);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With Inv do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
         ProgBar.ProgressBar1.Position:=LCount;


      If (Check_DetailsBOM(Mode,RunOk,ProgBar)) then;



      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}


    Loop:=Not Loop;

  Until (Not Loop) or (Not RunOk);


end; {Proc..}



{ ====== Procedure to Scan all detail lines beloning to doc and zero cost if bom====== }

Function Zero_Details4BOM(Mode  :  Integer;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;

  Fnum2     =  StockF;
  Keypath2  =  StkCodeK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  OldCP,
  Div1,Div2,
  CalcCP  :  Double;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (StockCode<>'') then
    Begin

      KeyI:=StockCode;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

      If (Status=0) and (Stock.StockType=StkBillCode) and (CostPrice<>0.0) then
      Begin


        CostPrice:=0.0;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

        FoundOk:=BOn;

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

        end
        else
        Begin
          {No need to show this information}
          {Write_FixLogFmt(FNum,'Stock Item '+StockCode+' on '+Inv.OurRef+' Cost adjusted from '+
                       Form_Real(OldCP,0,Syss.NoCosDec)+' to '+Form_Real(CostPrice,0,Syss.NoCosDec),4);}

        end;
      end;


    end;

    Inv.TotalCost:=Inv.TotalCost+(Qty*CostPrice);

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Zero_Details4BOM:=FoundOk;

end; {Proc..}



{ === Set cost price of any zero lines from stock record == }

Procedure ZeroSaleBOMCost(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              Mode  :  Byte;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvRNoK;



Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  Ok2Store,
  NoDocH,
  SysOk,SLocked,
  FDocH   :  Boolean;



Begin


  SysOk:=BOff;


  SLocked:=BOff;


    KeyChk:=FullNomKey(0)+'S';

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    With Inv do
    Begin
      TotalCost:=0.0;

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Ok2Store:=BOff;

      If ((InvDocHed In SalesSplit-[SRC])) then
      Begin

        Ok2Store:=(Zero_Details4BOM(Mode,RunOk,ProgBar));

        If (Ok2Store) then
          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath)
        else
          Status:=0;
      end;


      If (Not StatusOk) and (Ok2Store) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    {LoopCtrl:=Not LoopCtrl;}

    If (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=TotalCount;


  TotalCount:=MFind;

end; {Proc..}


{ ====== Procedure to reset OrdMatch on all non SPOP based transactions  ====== }

Procedure RepairOrdMatch(Var RunOk :  Boolean;
                         Var TotalCount,
                             MFind :  LongInt;
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
  FDocH   :  Boolean;



Begin

  KeyS:='';

  LoopCtrl:=BOff;

  KeyS:='P';
  
  Repeat
    KeyI:=KeyS;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (RunOk) and (KeyS[1]=KeyI[1]) do
    With Inv do
    Begin

      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      If (Not (InvDocHed In PSOPSet+[PIN,SIN])) and (OrdMatch) then
      Begin

        OrdMatch:=BOff;

        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

        end
        else
          Write_FixLogFmt(FNum,'Matching information repaired on '+OurRef,4);



        RunOk:=(RunOk and (Status In [0,5]));

      end;

      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;


      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    LoopCtrl:=Not LoopCtrl;

    KeyS:='S';


  Until (Not LoopCtrl) or (Not RunOk);

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


{ ====== Procedure to Scan all detail lines beloning to doc and zero cost if bom====== }

Function Delete_SRCStkLines(Mode  :  Integer;
                        Var RunOk :  Boolean;
                            ProgBar
                                  :  TSFProgressBar)  :  Boolean;

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;

  Fnum2     =  StockF;
  Keypath2  =  StkCodeK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  OldCP,
  Div1,Div2,
  CalcCP  :  Double;

  FoundOk :  Boolean;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=KeyChk;

  FoundOk:=BOff;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Id.LineNo<RecieptCode) and (RunOk) do
  With Id do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (StockCode<>'') then
    Begin

      KeyI:=StockCode;

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

      If (Status=0) then
      Begin
        FoundOk:=BOn;

        Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

        If (Status=0) then
          Write_FixLogFmt(FNum,'Line '+Form_Int(LineNo,0)+' of '+Inv.OurRef+'. ('+StockCode+'). Has been removed.',0)
        else
        Begin

          Write_FixLogFmt(FNum,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);

        end

      end;


    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  Result:=FoundOk;

end; {Proc..}



{ === Set cost price of any zero lines from stock record == }

Procedure CheckSRCPPY4Stk(Var RunOk :  Boolean;
                          Var TotalCount,
                              MFind :  LongInt;
                              Mode  :  Byte;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvOurRefK;



Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  Ok2Store,
  LoopCtrl,
  NoDocH,
  SysOk,SLocked,
  FDocH   :  Boolean;



Begin


  SysOk:=BOff;


  SLocked:=BOff;


  KeyChk:='SRC';

  LoopCtrl:=BOff;

  Repeat
    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
    With Inv do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Ok2Store:=BOff;

      If ((InvDocHed In [SRC,PPY])) then
      Begin

        Ok2Store:=(Delete_SRCStkLines(Mode,RunOk,ProgBar));

      end;

      Inc(MFind);

      If (MFind<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=MFind;

      RunOk:=(RunOk and (Status In [0,5]));

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

    end; {While..}

    LoopCtrl:=Not LoopCtrl;

    KeyChk:='PPY';

  Until (Not RunOk) or (Not LoopCtrl);


  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;


  TotalCount:=MFind;

end; {Proc..}


{ ========== Procedure to Pad YourRef Key ========= }


Procedure PadYourRef(Var TotalCount,
                         LCount:  LongInt;
                     Var RunOk :  Boolean;
                         ProgBar
                               :  TSFProgressBar);



Const
  Fnum     =  InvF;
  Keypath  =  InvRNoK;



Var
  OldORef  :  Str10;

  KeyS     :  Str255;


Begin
  KeyS:='';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    If (Length(YourRef)<>10) then
    Begin
      FillChar(OldORef,Sizeof(OldORef),0);

      OldORef:=YourRef;

      FillChar(YourRef,Sizeof(YourRef),0);

      YourRef:=LJVAR(OldORef,10);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to write data to file, report error '+Form_Int(Status,0),4);

      end;


    end;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



end; {Proc..}


{ ====== Procedure to reset Variance for Advance corruption  ====== }

Procedure Reset_GenisisSIN(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
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
  FDocH   :  Boolean;



Begin

  KeyS:='SIN001402';

  LoopCtrl:=BOff;


  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (StatusOk) and (RunOk) then
  With Inv do
  Begin
    FillChar(DAddr,Sizeof(DAddr),0);

    RunNo:=0;
    
    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

    If (Not StatusOk) then
    Begin
      Write_FixLog(FNum,'Unable to write data to file, report error '+Form_Int(Status,0));

    end;


    RunOk:=(RunOk and (Status In [0,5]));


  end; {While..}


  If Assigned(ProgBar) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}



{ ====== Procedure to reset Variance for Advance corruption  ====== }

Procedure Reset_GenisisSOR(Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               ProgBar
                                     :  TSFProgressBar);


Const
  Fnum      =  InvF;
  Keypath   =  InvOurRefK;
  Fnum2     =  IdetailF;
  Keypath2  =  IdfolioK;


Var
  KeyS,
  KeyChk,
  KeyI    :  Str255;

  LoopCtrl,
  NoDocH,
  FDocH   :  Boolean;



Begin

  KeyS:='SOR048209';

  LoopCtrl:=BOff;


  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  If (StatusOk) and (RunOk) then
  With Inv do
  Begin
    KeyChk:=FullNomKey(FolioNum);
    KeyI:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

    While (StatusOk) and (CheckKey(KeyChk,KeyI,Length(KeyChk),BOn)) and (RunOk) do
    With Id do
    Begin
      IdDocHed:=SRC;
      LineNo:=RecieptCode;

      FolioRef:=2014;
      DocPRef:='SRC000001';
      LineType := 'X';
      NomMode:=0;
      PostedRun:=142;

      Status:=Put_Rec(F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2);

      If (Not StatusOk) then
      Begin
        Write_FixLog(FNum2,'Unable to write data to file, report error '+Form_Int(Status,0));

      end;

      Status:=Find_Rec(B_GetNext,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyI);

    end;

    RunNo:=142;
    CustSupp:='C';
    InvDocHed:=SRC;
    FolioNum:=2014;
    OurRef:='SRC000001';
    NomAuto:=TRUE;


    Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

    If (Not StatusOk) then
    Begin
      Write_FixLog(FNum,'Unable to write data to file, report error '+Form_Int(Status,0));

    end;


    RunOk:=(RunOk and (Status In [0,5]));


  end; {If found..}


  If Assigned(ProgBar) then
    ProgBar.ProgressBar1.Position:=TotalCount;


end; {Proc..}


Procedure Del_NoPJobAct(Var RunOk :  Boolean;
                        Var TotalCount,
                            LCount:  LongInt;
                            Mode     :  Byte;
                            ProgBar
                                     :  TSFProgressBar);



Const
  Fnum      =  JDetlF;
  Keypath   =  JDLedgerK;

Var
  KeyChk,
  KeyS,
  KeyF  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  DelRecs
        :  LongInt;
  TimeR :  TimeTyp;
  B_Func:  Integer;



Begin
  KeyChk:=JBRCode;

  KeyS:=KeyChk;

  DelRecs:=0;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With JobDetl^ do
  Begin
    B_Func:=B_GetNext;

    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=JBECode)  then
    With JobActual do
    Begin
      KeyF:=LineORef;


//      If ((Not Posted) and (Mode=88)) or (JDDT In PSOPSet+QuotesSet+JAPSplit) then
      // CJS: 27/03/2008: added SRC support
      If ((Not Posted) and (Mode=88)) or (JDDT In PSOPSet+QuotesSet+JAPSplit+[SRC]) then
      Begin

        Ok2Store:=(Not CheckRecExsists(KeyF,InvF,InvOurRefK));

        If (Not Ok2Store) then {Check line exists}
        Begin
          KeyF:=FullIdKey(LineFolio,LineNo);

          Ok2Store:=(Not CheckRecExsists(KeyF,IDetailF,IdLinkK));

        end;

        If (Not Ok2Store) and (Mode =96) then {Check SPOP line has a value, delete if not}
        Begin
          Ok2Store:=((Qty=0) and (Cost=0.0) and (Charge=0.0) and (Not (JDDT In JAPSplit)));

        end;
      end;


    end;

    If (Ok2Store) then
    Begin

      Status:=Delete_Rec(F[Fnum],Fnum,Keypath);


      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete Job Actual record '+JobActual.LedgerCode+
                ', report error '+Form_Int(Status,0),0);

      end
      else
      Begin
        B_Func:=B_GetGEq;

        Inc(DelRecs);

        If (Mode<>96) then
          Write_FixLogFmt(FNum,'Deleted Job Actual record '+JobActual.LedgerCode+' for '+JobActual.LineORef,0);
      end;


    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  Write_FixLogFmt(FNum,'Total Job Actual records deleted:  '+Form_Int(DelRecs,0),0);

end; {Proc..}



  { ========= Procedure to shadow Alt code within Alt db ========== }


  Procedure Shadow_StkRec(StockR  : StockRec;
                      Var AltDBNF : LongInt);

  Const
    Fnum     =  MLocF;
    Keypath  =  MLK;


  Var
    KeyChk,
    KeyS     :  Str255;

    LOk,
    LLocked,
    FoundOk,
    NewRec   :  Boolean;
    B_Func   :  Integer;


  Begin
    With StockR, MLocCtrl^,sdbStkRec do
    Begin
      If (Strip('B',[#32],AltCode)<>'') then
      Begin

        KeyChk:=PartCCKey(NoteTCode,NoteCCode)+LJVar(AltCode,StkKeyLen);
        KeyS:=KeyChk;

        FoundOk:=BOff; LOk:=BOff; LLocked:=BOff;

        B_Func:=B_GetGEq;

        Repeat

          Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

          FoundOk:=(StatusOk and (CheckKey(KeyChk,KeyS,Length(KeyS),BOff)) and (sdStkFolio=StockFolio));

          B_Func:=B_GetNext;

        Until (Not StatusOk) or (FoundOk) or (Not CheckKey(KeyChk,KeyS,Length(KeyS),BOff));

        NewRec:=((Status In [4,9]) or (Not FoundOk and StatusOk));

        If (FoundOk) then
        Begin

          LOk:=BOn; LLocked:=BOn;


        end
        else
          If (NewRec) then
          Begin
            LOk:=BOn; LLocked:=BOn;

            ResetRec(Fnum);

            RecPfix:=NoteTCode;

            Subtype:=NoteCCode;

            sdNLineCount:=1;
            sdStkFolio:=StockFolio;

            {$IFDEF MC_On}
              sdROCurrency:=1;
            {$ENDIF}

            sdFolio:=ALTDBNF;

            Inc (AltDBNF);

            sdCode3:=FullNomKey(sdFolio)+FullNomKey(sdStkFolio);

          end;



        If (LOk) and (LLocked) then
        Begin
          sdCode1:=LJVar(AltCode,StkKeyLen);
          sdCode2:=Full_SupStkKey(sdStkFolio,sdCode1);

          sdSuppCode:=Supplier;
          sdROCurrency:=ROCurrency;
          sdROPrice:=ROCPrice;
          {* Update last edited flag *}

          sdLastUsed:=Today;


          If (NewRec) then
            Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath)
          else
            Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

          If (Not StatusOk) then
          Begin

            Write_FixLog(FNum,'Unable to write data to file, report error '+Form_Int(Status,0));

          end;


        end;
      end;

    end;
  end;



{ ====== Procedure to Scan all Stock records, and set the ROC price the same as the R-Order price ====== }

Procedure Set_StockAltCodes(Var RunOk :  Boolean;
                            Var MFind,
                                TotalCount
                                      :  LongInt;
                                ProgBar
                                      :  TSFProgressBar);


Const
  Fnum      =  StockF;


Var
  KeyS    :  Str255;
  AltdbNF :  LongInt;



Begin

  KeyS:=''; AltdbNF:=1;


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Stock do
  Begin

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));



    Shadow_StkRec(Stock,AltDBNF);


    Inc(MFind);

    If (MFind<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=MFind;

    RunOk:=(RunOk and (Status In [0,5]));

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}

  If Assigned(ProgBar) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}


{ ================== Procedure to Delete all History Records Matching a give Code and after purge year ============= }
{* An exact copy of this is in ExBtTH1U for thread safe operation *}


  Procedure DeleteDelAuditHist (Code     :  AnyStr;
                                KLen     :  Integer;
                            Var TotalCount,
                                MFind    :  LongInt;

                                ProgBar
                                         :  TSFProgressBar);

  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;


  Var
    KeyS  :  AnyStr;
    Locked:  Boolean;
    LAddr :  LongInt;

  Begin

    Begin

      KeyS:=Code;


      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                                {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

      While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
      With NHist do
      Begin
        Inc(MFind);

        If (MFind<TotalCount) and (Assigned(ProgBar)) then
          ProgBar.ProgressBar1.Position:=MFind;

        If (Not AfterPurge(Yr,0)) then
        Begin
          Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);
        end;

        Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


      end;
    end;
  end;



{ ====== Procedure to Scan all History lines and for a given type code and reset them ====== }

Procedure ResetSet_PurgeACHist(Mode  :  Integer;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               UseAC :  Str10;
                               ProgBar
                                     :  TSFProgressBar);



Var

  n       :  Byte;



Begin
  For n:=1 to 3 do
  Begin
    KeyF:=CustHistAry[n]+FullCustCode(UseAC);

    DeleteDelAuditHist(KeyF,Length(KeyF),TotalCount,MFind,ProgBar);

  end;

end; {Proc..}


{ ====== Procedure to Scan all History lines and for a given type code and reset them ====== }

Procedure ResetSet_PurgeStkHist(Mode  :  Integer;
                           Var RunOk :  Boolean;
                           Var TotalCount,
                               MFind :  LongInt;
                               UseSC :  Str20;
                               ProgBar
                                     :  TSFProgressBar);





Begin
  If (CheckRecExsists(UseSC,StockF,StkCodeK)) then
  With Stock do
  Begin


    {* Delete posted history *}

    KeyF:=Calc_AltStkHCode(StockType)+FullNomKey(StockFolio);

    DeleteDelAuditHist(KeyF,Length(KeyF),TotalCount,MFind,ProgBar);

    {* Delete all Location history for this record *}

    KeyF:=Calc_AltStkHCode(StockType)+'L'+FullNomKey(StockFolio);

    DeleteDelAuditHist(KeyF,Length(KeyF),TotalCount,MFind,ProgBar);

    {* Delete Sales history *}

    KeyF:=StockType+FullNomKey(StockFolio);

    DeleteDelAuditHist(KeyF,Length(KeyF),TotalCount,MFind,ProgBar);

    {* Delete all Location Sales history for this record *}

    KeyF:=StockType+'L'+FullNomKey(StockFolio);

    DeleteDelAuditHist(KeyF,Length(KeyF),TotalCount,MFind,ProgBar);


  end; {With..}
end; {Proc..}

procedure Set_FiltStock(var RunOk: Boolean; var MFind, TotalCount: LongInt;
  ProgBar: TSFProgressBar);
const
  Fnum = StockF;
var
  KeyS: Str255;
  n   : Byte;
  TempStockCode: Str20;
  TempStockCat: Str20;
begin
  KeyS := '';

  if Assigned(ProgBar) then
    ProgBar.ProgLab.Caption := 'Checking Stock records.';

  Status := Find_Rec(B_StepFirst, F[Fnum], Fnum, RecPtr[Fnum]^, 0, KeyS);

  while (StatusOk) and (RunOk) do
  with Stock do
  begin

    Application.ProcessMessages;
    If (Assigned(ProgBar)) then
      RunOk := (Not (ProgBar.Aborted));

    TempStockCode := StockCode;
    TempStockCat  := StockCat;

    FillChar(StockCode[1], SizeOf(StockCode), 0);
    FillChar(StockCat[1], SizeOf(StockCat), 0);

    StockCode := UpcaseStr(LJVar(TempStockCode, 16));
    StockCat  := UpcaseStr(LJVar(TempStockCat,  16));

    for n := 2 to 6 do
      Desc[n] := Strip('R', [#0, #32], Desc[n]);

    Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^,0);

    if (not StatusOk) then
    begin
      Write_FixLog(FNum, 'Unable to write data to file, report error ' + Form_Int(Status, 0));
    end;

    Inc(MFind);

    if (MFind < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := MFind;

    RunOk := (RunOk and (Status In [0,5]));

    Status := Find_Rec(B_StepNext, F[Fnum], Fnum, RecPtr[Fnum]^, 0, KeyS);

  end; {While..}

end; {Proc..}

procedure ResetNomMode(var RunOk: Boolean; TotalCount: LongInt;
  var Count: LongInt; var RCount: LongInt;  ProgBar: TSFProgressBar);
const
  Fnum = IdetailF;
var
  KeyS: Str255;
  n   : Byte;
begin
  KeyS := '';

  if Assigned(ProgBar) then
    ProgBar.ProgLab.Caption := 'Checking Transaction Line records.';

  Status := Find_Rec(B_StepFirst, F[Fnum], Fnum, RecPtr[Fnum]^, 0, KeyS);

  while (StatusOk) and (RunOk) do
  begin

    Application.ProcessMessages;
    If (Assigned(ProgBar)) then
    begin
      RunOk := (Not (ProgBar.Aborted));
      if (Count mod 100) = 0 then
        ProgBar.ProgLab.Caption := 'Checking Transaction Line records: ' + IntToStr(Count);
    end;

    if (not (Id.IdDocHed in [ADJ, TSH, WOR, SRN, PRN])) and (Id.NomMode = 2) then
    begin
      Inc(RCount);
      Id.NomMode := 0;
      Status := Put_Rec(F[Fnum], Fnum, RecPtr[Fnum]^,0);
      if (not StatusOk) then
      begin
        RunOk := False;
        Write_FixLog(FNum, 'Unable to write data to file, report error ' + Form_Int(Status, 0));
      end;
    end;

    Inc(Count);

    if (Count < TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position := Count;

    Status := Find_Rec(B_StepNext, F[Fnum], Fnum, RecPtr[Fnum]^, 0, KeyS);

  end; {While..}

end;

{
  For J F McKenna. Moves hidden BOM lines out of a SOR transaction and copies
  them to a new ADJ transaction.
}
procedure MoveBOMLines(var RunOk                    : Boolean;
                       var TotalCount, MFind, RCount: LongInt;
                       FromSORRef                   : string;
                       ProgBar                      : TSFProgressBar);
var
  FuncRes: Integer;
  InvKey, IdKey: Str255;
  InvFolio: LongInt;
  AtLeastOneChanged: Boolean;
begin
  MFind  := 0;
  RCount := 0;
  InvKey := FromSORRef;
  // Find the Transaction:
  FuncRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, InvKey);
  if (FuncRes = 0) then
  begin
    AtLeastOneChanged := False;

    // Set up the search key for the transaction lines
    IdKey := FullNomKey(Inv.FolioNum);
    InvFolio := Inv.FolioNum;

    // Set up and add the new Adjustment Transaction header.
    Inv.InvDocHed := ADJ;
    Inv.FolioNum := SetNextFolioNos(ADJ, False);
    Inv.OurRef := FullDocNum(ADJ, True);
    Inv.RunNo := 0;
    Inv.NomAuto := False;
    Inv.InvDocHed := ADJ;
    Inv.TransDate := Today;
    Inv.NLineCount := 1;
    Inv.ILineCount := 1;
    Inv.OpName := EntryRec^.Login;
    Inv.Currency := 1;
    Inv.CXrate := SyssCurr.Currencies[Inv.Currency].CRates;
    Inv.CXRate[BOff] := 0;
    FuncRes := Add_Rec(F[InvF], InvF, Inv, 0);

    if (FuncRes = 0) then
    begin
      // Look up the Transaction Lines.
      FuncRes := Find_Rec(B_GetGEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, IdKey);

      // For each Transaction Line which matches with the original Folio:
      while (FuncRes = 0) and (Id.FolioRef = InvFolio) and (not ProgBar.Aborted) do
      begin
        Application.ProcessMessages;
        if Id.PostedRun = -30 then
        begin
          // Move the Transaction Line to the new Adjustment Transaction
          Id.FolioRef := Inv.FolioNum;
          Id.DocPRef := Inv.OurRef;

          // Save the Transaction Line.
          FuncRes := Put_Rec(F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK);
          if (FuncRes = 0) then
            // Update the Line Count on the Transaction header
            Inv.ILineCount := Inv.ILineCount + 1
          else
            // Report the error, but carry on
            Write_FixLogFmt (IDetailF,
                             'Error ' + IntToStr(FuncRes) +
                             ' correcting Transaction Line ' + IntToStr(Id.LineNo),
                             4);
          AtLeastOneChanged := True;
        end;

        if AtLeastOneChanged then
          RCount := RCount + 1;

        // Get the next Transaction Line.
        FuncRes := Find_Rec(B_GetNext, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, IdKey);
      end;
    end;
  end;
  if ProgBar.Aborted then
    Write_FixMsgFmt('Special Function has been aborted.', 4);
end;

//PR: 27/06/2017 ABSEXCH-18756
Procedure SetPINRunNumbersFromLines(Var RunOk :  Boolean;
                                    Var ProcessedCount : longint;
                                    Var CheckedCount : longint;
                                    ProgBar :  TSFProgressBar);
var
  DocRes, LineRes, SaveRes : Integer;
  DocKeyS, LineKeyS : Str255;
  LineFound : Boolean;
  DisplayCount : Integer;
begin
  DisplayCount := 1;
  //Find first PIN
  DocKeyS := 'PIN000001';
  DocRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, DocKeyS);

  //Iterate through all PINs
  while (DocRes = 0) and (Inv.InvDocHed = PIN) and not ProgBar.Aborted do
  begin
    //Check if transaction should have been posted
    Inc(CheckedCount);
    if (Inv.RunNo = 0) and (Trim(Inv.VATPostDate) <> '') then
    begin
      //Look through lines for populated run number - zero value lines have run no of 0
      LineFound := False;
      LineKeyS := FullNomKey(Inv.FolioNum) + FullNomKey(1);
      LineRes := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, LineKeyS);
      while (LineRes = 0) and (Id.FolioRef = Inv.FolioNum) and not LineFound do
      begin
        LineFound := Id.PostedRun <> 0;
        if not LineFound then
          LineRes := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, LineKeyS);
      end;

      if LineFound then
      begin
        Inv.RunNo := Id.PostedRun;
        SaveRes := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvOurRefK);
        if SaveRes <> 0 then
          Write_FixLogFmt(InvF,'Unable to write data to file, report error '+Form_Int(Status,0),40)
        else
          inc(ProcessedCount);
      end; //If Found


    end; //(Inv.RunNo = 0) and Trim(Inv.VATPostDate) <> ''

    //Get next PIN
    DocRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, DocKeyS);

    //Update display;
    if CheckedCount mod 100 = 1 then
    begin
      Inc(DisplayCount);
      if DisplayCount > 100 then
        DisplayCount := 1;

      ProgBar.InfoLbl.Caption := 'Records processed/Records checked: ' + IntToStr(ProcessedCount) + '/' +
                        IntToStr(CheckedCount);
      ProgBar.InfoLbl.Refresh;
    end;
    Application.ProcessMessages;
  end;

  if ProgBar.Aborted then
    Write_FixMsgFmt('Special Function has been aborted.', 4);
end;

//PR: 27/08/2017 ABSEXCH-19162
Procedure FixSettleDoubling(Var RunOk :  Boolean;
                            Var ProcessedCount : longint;
                            Var CheckedCount : longint;
                                ProgBar :  TSFProgressBar);
const

  // MH 01/06/2018: Modified Transactions included in SF for David/EIRE
  TransTypeArray : Array[1..8] of DocTypes = (SCR, SIN, SJC, SJI, {SRC,}
                                               PCR, PIN, PJC, PJI{, PPY});
var
  DocRes, LineRes, SaveRes : Integer;
  DocKeyS, LineKeyS : Str255;
  NeedToCheckTrans, NeedToStoreTrans, LineFound : Boolean;
  DisplayCount : Integer;
  iTransType : Integer;
  TransLineCount : Integer;
begin
{Process required:

 Search through all Sales/Purchase financial transaction headers.

 If Variance <> 0 then
   Find the first line where line number = 2147483647 and Period = 0 and Year = 0
   Subtract the NetValue of the line from the Settled value on the header
   Set Variance to 0
   Set TotalReserved to 0

   Delete the line

   Find the next line
   if no more variance lines on this transaction then go to next transaction
}
  DisplayCount := 1;
  //Find first transaction
  for iTransType := Low(TransTypeArray) to High(TransTypeArray) do
  begin
    DocKeyS := DocCodes[TransTypeArray[iTransType]];
    DocRes := Find_Rec(B_GetGEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, DocKeyS);

    //Iterate through all transactions of this type
    while (DocRes = 0) and (Inv.InvDocHed = TransTypeArray[iTransType]) and not ProgBar.Aborted do
    begin
      Inc(CheckedCount);


      //If variance <> 0 then we need to check the transaction
      if Round_Up(Inv.Variance, 2) <> 0.00 then
      begin
        LineFound := False;

        //Look through lines for variance line with period = 0 and year = 0
        LineKeyS := FullNomKey(Inv.FolioNum) + FullNomKey(RecieptCode);
        LineRes := Find_Rec(B_GetGEq, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, LineKeyS);

        TransLineCount := 0;
        while (LineRes = 0) and (Id.LineNo = RecieptCode) and (Id.FolioRef = Inv.FolioNum) do
        begin
          // MH 01/06/2018: Modified SF for David/EIRE
          LineFound := True; //(Id.PYr = 0) and (Id.PPr = 0);

          if LineFound then
          begin
            NeedToStoreTrans := True;

            //Set variance and total reserved to 0
            Inv.Variance := 0;
            Inv.TotalReserved := 0;

            //Correct settled amount - DocCnst array gives us the correct signage
            Inv.Settled := Inv.Settled + (Id.NetValue * DocCnst[Inv.InvDocHed]);

            //Delete line
            SaveRes := Delete_Rec(F[IDetailF], IDetailF, IdFolioK);
            if SaveRes <> 0 then
              Write_FixLogFmt(InvF,'Unable to delete line for transaction ' + Inv.OurRef + Form_Int(SaveRes,0),40)
            Else
              TransLineCount := TransLineCount + 1;
          end; //if LineFound

          //Check for more lines
          LineRes := Find_Rec(B_GetNext, F[IDetailF], IDetailF, RecPtr[IDetailF]^, IdFolioK, LineKeyS);
        end; //while (LineRes = 0) and (Id.LineNo = RecieptCode) and (Id.FolioRef = Inv.FolioNum)

        if NeedToStoreTrans then
        begin
          //Save transaction
          SaveRes := Put_Rec(F[InvF], InvF, RecPtr[InvF]^, InvOurRefK);

          if SaveRes <> 0 then
            Write_FixLogFmt(InvF,'Unable to store transaction ' + Inv.OurRef + Form_Int(SaveRes,0),40)
          else
          begin
            Write_FixLogFmt(InvF,'Transaction ' + Inv.OurRef + ' Updated - ' + IntToStr(TransLineCount) + ' lines deleted',40);
            inc(ProcessedCount);
          end;

          //Reset variable
          NeedToStoreTrans := False;
        end; //if NeedToStoreTrans

      end; //if Round_Up(Inv.Variance, 2) <> 0.00

      //Get next PIN
      DocRes := Find_Rec(B_GetNext, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, DocKeyS);

      //Update display;
      if CheckedCount mod 100 = 1 then
      begin
        Inc(DisplayCount);
        if DisplayCount > 100 then
          DisplayCount := 1;

        ProgBar.InfoLbl.Caption := 'Records processed/Records checked: ' + IntToStr(ProcessedCount) + '/' +
                          IntToStr(CheckedCount);
        ProgBar.InfoLbl.Refresh;
      end;

      Application.ProcessMessages;
    end; //while (DocRes = 0) and (Inv.InvDocHed = TransTypeArray[iTransType]) and not ProgBar.Aborted
  end; //for iTransType := Low(TransTypeArray) to High(TransTypeArray)

  if ProgBar.Aborted then
    Write_FixMsgFmt('Special Function has been aborted.', 4);

end; //FixSettleDoubling

end. {Unit..}
