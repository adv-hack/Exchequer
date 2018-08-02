Unit PF2MC1U;




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



 Procedure MCConv_Control(ProgBar  :  TSFProgressBar);

 Procedure Repair_JobAct(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);

 Procedure Reset_EmplCertDate(Var RunOk :  Boolean;
                              Var TotalCount,
                                  LCount,
                                  PCount:  LongInt;
                                  ProgBar
                                        :  TSFProgressBar);


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     Windows,
     SysUtils,
     Dialogs,
     Messages,
     Forms,
     VarRec2U,
     VarFPosU,
     ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2,
     UnTils,
     Rebuld1U,
     ReBuld2U;


  { ========= Proc to convert account data ========== }

Procedure PFMC_Customers(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  CustF;

Var
  KeyS  :  Str255;
  StartTime
        :  Int64;


Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Accounts';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Cust do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (Currency=0) then
    Begin

      Inc(PCount);

      Currency:=1;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Account record '+CustCode+', '+Company+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Account currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



{ ========= Proc to convert account data ========== }

Procedure PFMC_Stock(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  StockF;

Var
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;
  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Stock';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Stock do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (ROCurrency=0) then
    Begin
      ROCurrency:=1;
      Ok2Store:=BOn;
    end;


    If (PCurrency=0) then
    Begin
      PCurrency:=1;
      Ok2Store:=BOn;
    end;

    For n:=Low(SaleBands) to High(SaleBands) do
    With SaleBands[n] do
    If (Currency=0) then
    Begin
     Currency:=1;
     Ok2Store:=BOn;

    end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Stock record '+StockCode+', '+Desc[1]+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Stock currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



{ ========= Proc to convert account data ========== }

Procedure PFMC_InvHed(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  InvF;

Var
  KeyS  :  Str255;
  StartTime
        :  Int64;



Begin
  KeyS:='';


  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Transaction headers';

  StartTime:=TimeVal;


  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Inv do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (Not (InvDocHed In [SBT,PBT,NMT,ADJ,TSH])) and (Currency=0) then
    Begin

      Inc(PCount);

      Currency:=1;

      If (CXRate[BOn]=0.0) then
      Begin
        CXRate[BOn]:=1.0; {* Force day rate to be 1 also, incase any get missed, and user switched to day rate type method *}

        Write_FixLog(FNum,'The Daily Rate for '+OurRef+', '+YourRef+'was set to zero.'+
                          'This has been ammended to 1.0');
      end;

      CurrSettled:=Settled; {* Make these the same as they should be *}

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Transaction '+OurRef+', '+YourRef+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Transaction header completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


{ ========= Proc to convert lines, + generate new run time lines ========== }

Procedure PF2MCID(Var RunOk :  Boolean;
                  Var TotalCount,
                      LCount,
                      PCount:  LongInt;
                      ProgBar
                            :  TSFProgressBar);


Const
  Fnum      =  IdetailF;

Var
  GStr,
  KeyS  :  Str255;

  StartTime
        :  Int64;



Begin
  KeyS:=''; GStr:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Detail Lines';

  StartTime:=TimeVal;

  MakeTempFile(Fnum);

  If (FixFile[BuildF].ReBuild) then
  Begin
    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With Id do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


      If (Currency=0) then
      Begin


        If (IdDocHed=RUN) and (NomMode=0) then
        Begin
          Status:=Add_Rec(F[BuildF],BuildF,RecPtr[BuildF]^,0);

          RunOk:=(RunOk and (Status In [0,5]));

          If (Not StatusOk) then
          Begin

            Write_FixLogFmt(BuildF,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);
          end;

        end;

        Currency:=1;


        If (NomMode=PayInNomMode) then
        Begin
          GStr:=Extract_PayRef2(StockCode);

          StockCode:=Full_PostPayInKey(PayOutCode,NomCode,Currency,GStr);


        end
        else
          If (Is_PayInLine(StockCode)) and (PostedRun<>0) and (IdDocHed In [SRc,PPY,SRI,SRF,PPI,PRF]) then
          Begin
            GStr:=Extract_PayRef2(StockCode);

            StockCode:=Full_PostPayInKey(PayInCode,NomCode,Currency,GStr);


          end;


        Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        If (Not StatusOk) then
        Begin
          Write_FixLogFmt(FNum,'Unable to update Transaction Line Folio '+Form_Int(FolioRef,0)+
                  ', report error '+Form_Int(Status,0),4);

        end;
      end;

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    end; {While..}

    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Merging new Run time detail Lines';


    Status:=Find_Rec(B_StepFirst,F[BuildF],BuildF,RecPtr[BuildF]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With Id do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));



      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to Add Transaction Run time line. Folio '+Form_Int(FolioRef,0)+'. '+PDate+
                  ', report error '+Form_Int(Status,0),4);

      end;

      Status:=Find_Rec(B_StepNext,F[BuildF],BuildF,RecPtr[BuildF]^,0,KeyS);

    end; {While..}




    Status:=Close_File(F[BuildF]);



    Write_FixLogFmt(FNum,'Detail line conversion completed. '+FmtTime(TimeVal-StartTime,BOn),3);


    Begin
      FixFile[BuildF].ReBuild:=DeleteFile(SetDrive+FileNames[BuildF]);

      If (Not FixFile[BuildF].ReBuild) then
      Begin
        Write_FixMsgFmt('Unable to erase '+Filenames[BuildF],4);
        Write_FixMsgFmt('Please erase manually before attempting to use Exchequer.',4);

      end
    end;
  end; {If..}



end; {Proc..}


{ ========= Proc to convert lines, + generate new run time lines ========== }

Procedure PF2MCHist(Var RunOk :  Boolean;
                    Var TotalCount,
                        LCount,
                        PCount:  LongInt;
                        ProgBar
                              :  TSFProgressBar);

Const
  Fnum      =  NHistF;

Var
  KeyS  :  Str255;
  StartTime
        :  Int64;



Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting History Records';

  StartTime:=TimeVal;

  MakeTempFile(Fnum);

  If (FixFile[BuildF].ReBuild) then
  Begin
    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With NHist do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


      If (Cr=0) then
      Begin


        If (Not (ExClass In [CustHistCde,CustHistPCde,CustHistGPCde,'D','T',IOVATCh[BOff],IOVATCh[BOn]])) and
           (ExClass<>Calc_AltStkHCode(StkStkCode)) and (ExClass<>Calc_AltStkHCode(StkBillCode))
               and (ExClass<>Calc_AltStkHCode(StkDescCode)) and (ExClass<>Calc_AltStkHCode(StkDListCode)) then
        Begin
          Status:=Add_Rec(F[BuildF],BuildF,RecPtr[BuildF]^,0);

          RunOk:=(RunOk and (Status In [0,5]));

          If (Not StatusOk) then
          Begin

            Write_FixLogFmt(BuildF,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);
          end;

          Cr:=1;

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

        end;



        If (Not StatusOk) then
        Begin
          Write_FixLogFmt(FNum,'Unable to update History '+NHist.Code+
                  ', report error '+Form_Int(Status,0),4);

        end;
      end
      else {* Delete non Cr 0 as they should not be in there *}
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,0);

        If (Not StatusOk) then
        With NHist do
        Begin

          Write_FixLogFmt(FNum,'Unable to delete History Record,Type : '+ExClass+' Code '+Code+'Currency '+Form_Int(Cr,0)+
                            ', report error '+Form_Int(Status,0),4);

        end;


      end;

      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    end; {While..}

    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Merging new History records';


    Status:=Find_Rec(B_StepFirst,F[BuildF],BuildF,RecPtr[BuildF]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With NHist do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));



      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update History '+Code+
                  ', report error '+Form_Int(Status,0),4);

      end;

      Status:=Find_Rec(B_StepNext,F[BuildF],BuildF,RecPtr[BuildF]^,0,KeyS);

    end; {While..}




    Status:=Close_File(F[BuildF]);

    Write_FixLogFmt(FNum,'History conversion completed. '+FmtTime(TimeVal-StartTime,BOn),3);


    Begin
      FixFile[BuildF].ReBuild:=DeleteFile(SetDrive+FileNames[BuildF]);

      If (Not FixFile[BuildF].ReBuild) then
      Begin
        Write_FixMsgFmt('Unable to erase '+Filenames[BuildF],4);
        Write_FixMsgFmt('Please erase manually before attempting to use Exchequer.',4);

      end
    end;
  end; {If..}



end; {Proc..}


Procedure PFMC_Locations(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  MLocF;
  Keypath   =  MLK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=CostCCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Location Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MLocCtrl^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=CSubCode[BOn]) then
    With MLocLoc do
    Begin
      If (loCurrency=0) then
      Begin
        loCurrency:=1;
        Ok2Store:=BOn;

      end;

    end
    else
      If (SubType=CSubCode[BOff]) then
      With MStkLoc do
      Begin
        If (lsROCurrency=0) then
        Begin
          lsROCurrency:=1;
          Ok2Store:=BOn;
        end;


        If (lsPCurrency=0) then
        Begin
          lsPCurrency:=1;
          Ok2Store:=BOn;
        end;

        For n:=Low(lsSaleBands) to High(lsSaleBands) do
        With lsSaleBands[n] do
        If (Currency=0) then
        Begin
         Currency:=1;
         Ok2Store:=BOn;

        end;

      end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Location record '+MStkLoc.lsCode1+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Location currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



Procedure PFMC_FIFOSNo(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

    StartTime
        :  Int64;



Begin
  KeyChk:=MFIFOCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting FIFO + Serial Records';

  StartTime:=TimeVal;

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
      If (CurSell=0) then
      Begin
        CurSell:=1;
        Ok2Store:=BOn;
      end;

      If (CurCost=0) then
      Begin
        CurCost:=1;
        Ok2Store:=BOn;
      end;


    end
    else
      If (SubType=MFIFOSub) then
      With FIFORec do
      Begin
        If (FIFOCurr=0) then
        Begin
          FIFOCurr:=1;
          Ok2Store:=BOn;
        end;


      end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update FIFO/SNo record '+SerialRec.SerialCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'FIFO /SNo currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


Procedure PFMC_Match(Var RunOk :  Boolean;
                     Var TotalCount,
                         LCount,
                         PCount:  LongInt;
                         ProgBar
                               :  TSFProgressBar);

Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=MatchTCode+MatchSCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Matching Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With PassWord,MatchPayRec do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (MCurrency=0) then
    Begin
      MCurrency:=1;
      Ok2Store:=BOn;
    end;

    If (RCurrency=0) then
    Begin
      RCurrency:=1;
      Ok2Store:=BOn;
    end;

    If (SettledVal<>OwnCVal) then
    Begin
      Ok2Store:=BOn;
      OwnCVal:=SettledVal;
    end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Matching record '+DocCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'Matching currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


Procedure PFMC_JobAct(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  JDetlF;
  Keypath   =  JDLedgerK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=JBRCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Job Actual Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) {and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn))} do
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

      If (ActCurr=0) then
      Begin
        ActCurr:=1;
        Ok2Store:=BOn;
      end;

      If (CurrCharge=0) then
      Begin
        CurrCharge:=1;
        Ok2Store:=BOn;
      end;

      LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);


    end
    else
      If (SubType=JBPCode) then
      With JobReten do
      Begin
        If (OrgCurr=0) then
        Begin
          OrgCurr:=1;
          Ok2Store:=BOn;
        end;

        If (RetCurr=0) then
        Begin
          RetCurr:=1;
          Ok2Store:=BOn;
        end;

        RetenCode:=FullJRHedKey(JobCode,AccType,RetCurr,RetDate);
      end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Job Actual record '+JobActual.LedgerCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'JobActual currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



Procedure PFMC_JobBud(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  JCtrlF;
  Keypath   =  JCK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  B_Func:  Integer;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=JBRCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Job Budget Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With JobCtrl^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    B_Func:=B_GetNext;

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=JBSubAry[1]) or (SubType=JBSubAry[5]) then
    With JobBudg do
    Begin

      {If (CurrBudg=0) then
      Begin
        CurrBudg:=1;
        Ok2Store:=BOn;
      end;

      If (CurrPType=0) then
      Begin
        CurrPType:=1;
        Ok2Store:=BOn;
      end;

      {* Set to currency 0 in any case...
      BudgetCode:=FullJBCode(JobCode,CurrBudg,AnalCode);}


    end
    else
      If (SubType=JBSubAry[3]) or (SubType=JBSubAry[4]) then
      With EmplPay do
      Begin
        If (CostCurr=0) then
        Begin
          CostCurr:=1;
          Ok2Store:=BOn;
        end;

        If (ChargeCurr=0) then
        Begin
          ChargeCurr:=1;
          Ok2Store:=BOn;
        end;

        EmplCode:=FullJBCode(EmpCode,CostCurr,EStockCode);

      end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Job Budget record '+JobBudg.BudgetCode+
                ', report error '+Form_Int(Status,0),4);

      end
      else
        B_Func:=B_GetGEq;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'Job Budget currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



{ ========= Proc to convert account data ========== }

Procedure PF2MCJobs(Var RunOk :  Boolean;
                    Var TotalCount,
                        LCount,
                        PCount:  LongInt;
                        ProgBar
                              :  TSFProgressBar);


Const
  Fnum      =  JobF;

Var
  KeyS  :  Str255;
  StartTime
        :  Int64;



Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Job Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With JobRec^ do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (CurrPrice=0) then
    Begin

      Inc(PCount);

      CurrPrice:=1;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,0);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Job '+JobCode+', '+JobDesc+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Job records completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}



Procedure PFMC_TeleSales(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  MLocF;
  Keypath   =  MLK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=MatchTCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting TeleSales Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MLocCtrl^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (SubType=MatchSCode) then
    With cuStkRec do
    Begin
      If (csLPCurr=0) then
      Begin
        csLPCurr:=1;
        Ok2Store:=BOn;

      end;

    end
    else
      If (SubType=PostLCode) then
      With TeleSRec do
      Begin
        If (tcCurr=0) then
        Begin
          tcCurr:=1;
          Ok2Store:=BOn;
        end;

      end;


    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update TeleSales record '+cuStkRec.csCode2+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'TeleSales currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


Procedure PFMC_AltStk(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  MLocF;
  Keypath   =  MLK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;

  StartTime
        :  Int64;


Begin
  KeyChk:=NoteTCode+NoteCCode;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Alt stock Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MLocCtrl^ do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    With sdbStkRec do
    Begin
      If (sdROCurrency=0) then
      Begin
        sdROCurrency:=1;
        Ok2Store:=BOn;

      end;

    end;

    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Alt Stock record '+sdbStkRec.sdCode1+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'Alt Stock currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


Procedure PFMC_BankR1(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  PWrdF;
  Keypath   =  PWK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  B_Func:  Integer;

  n     :  Byte;

  StartTime
        :  Int64;



Begin
  KeyChk:=MBankHed+MBankCtl;

  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Auto Bank Rec Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With PassWord,BankCRec do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    B_Func:=B_GetNext;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (BankCr=0) then
    Begin
      BankCr:=1;
      Ok2Store:=BOn;
    end;


    If (Ok2Store) then
    Begin
      BankCode:=PartBankMKey(BankNom,BankCr);

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Auto Bank Rec record '+Form_Int(BankNom,0)+
                ', report error '+Form_Int(Status,0),4);

      end
      else
        B_Func:=B_GetGEq;
    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}


  Begin
    Write_FixLogFmt(FNum,'Auto Bank Rec currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}


Procedure PFMC_BankR2(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;

Var
  KeyChk,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  B_Func:  Integer;

  n     :  Byte;

  StartTime
        :  Int64;


Begin
  KeyChk:=MBankHed+MBankSub;

  KeyS:=KeyChk;


  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Converting Auto Bank Ref Records';

  StartTime:=TimeVal;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With MiscRecs^,BankMRec do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    B_Func:=B_GetNext;

    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (BankCr=0) then
    Begin
      BankCr:=1;
      Ok2Store:=BOn;
    end;


    If (Ok2Store) then
    Begin
      BankMatch:=PartBankMKey(BankNom,BankCr);

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Auto Bank Ref record '+Form_Int(BankNom,0)+
                ', report error '+Form_Int(Status,0),4);

      end
      else
        B_Func:=B_GetGEq;
    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}



  Begin
    Write_FixLogFmt(FNum,'Auto Bank Ref currency update completed. '+FmtTime(TimeVal-StartTime,BOn),3);

  end; {With..}

end; {Proc..}




 { ========== Procedure to Purge Accounting Data ========= }


Procedure MCConv_Data(Mode  :  Integer;
                  Var TotalCount,
                      LCount,
                      PCount:  LongInt;
                  Var RunOk :  Boolean;
                      ProgBar
                            :  TSFProgressBar);




 Var

   KeyS     :  Str255;

   Tc       :  Char;

   SLocked  :  Boolean;

   B_Func   :  Integer;

  StartTime
            :  Int64;




 Begin

   FillChar(KeyS,Sizeof(KeyS),0);

   SLocked:=BOff;


   GetMultiSys(BOn,SLocked,SysR);

   If (Assigned(ProgBar)) then
     ProgBar.ProgLab.Caption:='Single to Multi currency Conversion';

   StartTime:=TimeVal;


   Write_FixMsgFmt('> Begin data conversion ... '+#9+DateTimeToStr(Now),3);


   PFMC_Customers(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_Stock(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_InvHed(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PF2MCId(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PF2MCHist(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_Locations(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_FIFOSNo(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_Match(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_JobAct(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_JobBud(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PF2MCJobs(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_TeleSales(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_AltStk(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_BankR1(RunOk,TotalCount,LCount,PCount,ProgBar);

   If (RunOk) then
     PFMC_BankR2(RunOk,TotalCount,LCount,PCount,ProgBar);


   PutMultiSys(SysR,BOn);

   If (RunOk) then
   Begin


     LCount:=TotalCount;

     If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


   end
   else
   Begin
     ShowMessage('WARNING!'+#13+
                 'The currency conversion has been aborted.'+#13+
                 'You must restore a backup before using Exchequer again!');

     Write_FixMsgFmt('WARNING!',4);
     Write_FixMsgFmt('The currency conversion has been aborted.',4);
     Write_FixMsgFmt('You must restore a backup before using Exchequer again!',4);

   end;

 end; {Proc..}




{ ======== Procedure to Repair Selective Exchequer Data Files ====== }

Procedure MCConv_Control(ProgBar  :  TSFProgressBar);



Var
  n        :  Byte;


  Count,
  PCount,
  RCount,
  TotalCount
           :  LongInt;
  RunOk    :  Boolean;

  Mode     :  Integer;



Begin

  RunOk:=BOn;

  Mode:=0;


  Addch:=ResetKey;

  WarnOnce:=BOff;

  If (Assigned(ProgBar)) then
  Begin
    ProgBar.Caption:='Exchequer Single to Multi Currency conversion.';

    Write_FixMsgFmt(' Exchequer Single to Multi Currency conversion.',3);

    Case Mode of

      0    :  Begin {* Accounting Data *}
                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[StockF].Rebuild:=BOn;
                FixFile[MiscF].Rebuild:=BOn;
                FixFile[NomF].Rebuild:=BOn;
                FixFile[NHistF].Rebuild:=BOn;
                FixFile[PWrdF].Rebuild:=BOn;
                FixFile[JobF].Rebuild:=BOn;
                FixFile[JCtrlF].Rebuild:=BOn;
                FixFile[JDetlF].Rebuild:=BOn;
                FixFile[MLocF].Rebuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF)+
                            Used_Recs(F[CustF],CustF)+
                            Used_Recs(F[StockF],StockF)+
                            Used_Recs(F[NHistF],NHistF)+
                            Used_Recs(F[PWrdF],PWrdF)+
                            Used_Recs(F[MiscF],MiscF)+
                            Used_Recs(F[MLocF],MLocF)+
                            Used_Recs(F[JobF],JobF)+
                            Used_Recs(F[JdetlF],JDetlF)+
                            Used_Recs(F[JCtrlF],JCtrlF);

                PCount:=0;

                If (Assigned(ProgBar)) then
                  ProgBar.ProgressBar1.Max:=TotalCount;


                MCConv_Data(Mode,TotalCount,RCount,PCount,RunOk,ProgBar);


                FixFile[CustF].Rebuild:=BOff;
                FixFile[InvF].Rebuild:=BOff;
                FixFile[IdetailF].Rebuild:=BOff;
                FixFile[StockF].Rebuild:=BOff;
                FixFile[MiscF].Rebuild:=BOff;
                FixFile[NomF].Rebuild:=BOff;
                FixFile[NHistF].Rebuild:=BOff;
                FixFile[PWrdF].Rebuild:=BOff;
                FixFile[JobF].Rebuild:=BOff;
                FixFile[JCtrlF].Rebuild:=BOff;
                FixFile[JDetlF].Rebuild:=BOff;
                FixFile[MLocF].Rebuild:=BOff;
                FixFile[SysF].ReBuild:=BOff;

              end;


    end; {Case..}


    Begin
      Close_Files(BOn);


      Write_FixMsgFmt('Exchequer Single to Multi Currency conversion completed',3);

      Write_FixMsg('');
      Write_FixMsgFmt('Grand Total No. records processed . : '+#9+#9+Form_Int(TotalCount,0),3);
      Write_FixMsgFmt('Grand Total No. records converted...: '+#9+#9+Form_Int(PCount,0),3);
      Write_FixMsg('');
      Write_FixMsgFmt(ConstStr('=',80),3);


      Begin
      end;


    end;

  end; {If Abort..}

  FixFile[BuildF].ReBuild:=BOff;

  If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}


 Procedure Repair_JobAct(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  JDetlF;
  Keypath   =  JDLedgerK;
  Fnum2     =  IdetailF;
  Keypath2  =  IdLinkK;

Var
  KeyChk,
  KeyChkI,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;



Begin
  KeyChk:=JBRCode+JBECode;

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With JobDetl^,JobActual do
  Begin
    Ok2Store:=BOff;

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;



    KeyChkI:=FullRunNoKey(LineFolio,LineNo);

    Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,Keypath2,KeyChkI);

    If (StatusOk) and (Id.CustCode<>ActCCode) then
    Begin
      Ok2Store:=BOn;
      ActCCode:=Id.CustCode;
    end;

    If (Ok2Store) then
    Begin

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Job Actual record '+JobActual.LedgerCode+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

    If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}


 Procedure Reset_EmplCertDate(Var RunOk :  Boolean;
                              Var TotalCount,
                                  LCount,
                                  PCount:  LongInt;
                                  ProgBar
                                        :  TSFProgressBar);


Const
  Fnum      =  JMiscF;
  Keypath   =  JMTrdK;

Var
  KeyChk,
  KeyChkI,
  KeyS  :  Str255;

  Ok2Store
        :  Boolean;

  n     :  Byte;



Begin
  KeyChk:=PartCCKey(JARCode,JASubAry[3]);

  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
  With JobMisc^,EmplRec do
  Begin
    Ok2Store:=(CertExpiry<>'');

    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));


    Inc(LCount);

    If (LCount<TotalCount) and (Assigned(ProgBar)) then
       ProgBar.ProgressBar1.Position:=LCount;


    If (Ok2Store) then
    Begin
      Blank(CertExpiry,Sizeof(CertExpiry));

      Inc(PCount);

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath);

      If (Not StatusOk) then
      Begin
        Write_FixLogFmt(FNum,'Unable to update Employee record '+EmpCode+EmpName+
                ', report error '+Form_Int(Status,0),4);

      end;
    end;

    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

    If (Assigned(ProgBar)) then
    ProgBar.ProgressBar1.Position:=TotalCount;

end; {Proc..}





end. {Unit..}