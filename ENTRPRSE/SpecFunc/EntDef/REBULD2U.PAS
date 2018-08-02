unit ReBuld2U;

{**************************************************************}
{                                                              }
{        ====----> E X C H E Q U E R Translate <----===        }
{                                                              }
{                      Created : 18/05/2000                    }
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
  VarConst;


Procedure MakeTempFile(FileNo  :  Integer);

Procedure ReBuild_Hed(FileNo  :  Integer);

Function Check_FileSize  :  Int64;

Function GetECTD(DC  :  Byte)  :  Str5;

Procedure SetPlainText(Mode  :  Boolean);

Procedure Disp_PartInv(FileNo  :  Integer);

Procedure Disp_PartialRec(FileNo  :  Integer;
                          RecNo   :  LongInt);

Procedure GetMultiSys(Wait         :  Boolean;
                      Var  Locked  :  Boolean;
                           SysMode :  SysRecTypes);

Procedure GetMultiSysCur(Wait         :  Boolean;
                    Var  Locked       :  Boolean);


Procedure GetMultiSysGCur(Wait         :  Boolean;
                     Var  Locked       :  Boolean);


Procedure PutMultiSys(SysMode  :  SysRecTypes;
                      UnLock   :  Boolean);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  Windows,
  SysUtils,
  Forms,
  VarRec2U,
  BtrvU2,
  ETStrU,
  ETDateU,
  ETMiscU,
  ProgU,
  VarFPosU,
  UnTils,
  ReBuld1U;


{ ======= setup All File Characteristics ======== }

Procedure DefineTempCust;

Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(CustFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Cust);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Cust;

  FileSpecOfs[Idx]:=@CustFile;


  FileNames[Idx]:=Path1+'CustSupp.New';                         { <<<<<<<<******** Change }

end; {..}






Procedure DefineTempDoc;

Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(InvFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Inv);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Inv;

  FileSpecOfs[Idx]:=@InvFile;


  FileNames[Idx]:=Path2+'Document.New';                         { <<<<<<<<******** Change }

end; {..}





Procedure DefineTempId;

Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(IdFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Id);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Id;

  FileSpecOfs[Idx]:=@IdFile;


  FileNames[Idx]:=Path2+'Details.New';                         { <<<<<<<<******** Change }


end; {..}






Procedure DefineTempNom;

Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(NomFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Nom);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Nom;

  FileSpecOfs[Idx]:=@NomFile;


  FileNames[Idx]:=Path2+'Nominal.New';                         { <<<<<<<<******** Change }
end; {..}







Procedure DefineTempStock;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(StockFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Stock);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Stock;

  FileSpecOfs[Idx]:=@StockFile;


  FileNames[Idx]:=Path4+'Stock.New';                         { <<<<<<<<******** Change }


end; {..}







Procedure DefineTempNumHist;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(NHFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(NHist);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@NHist;

  FileSpecOfs[Idx]:=@NHFile;


  FileNames[Idx]:=Path2+'History.New';                         { <<<<<<<<******** Change }




end; {..}





Procedure DefineTempCount;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(CountFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Count);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Count;

  FileSpecOfs[Idx]:=@CountFile;


  FileNames[Idx]:='ExchNum.New';                         { <<<<<<<<******** Change }




end; {..}



Procedure DefineTempPassWord;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(PassFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(PassWord);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@PassWord;

  FileSpecOfs[Idx]:=@PassFile;


  FileNames[Idx]:=Path3+'ExChqChk.New';                         { <<<<<<<<******** Change }




end; {..}




Procedure DefineTempMisc;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(MiscFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(MiscRecs^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@MiscRecs^;

  FileSpecOfs[Idx]:=@MiscFile^;


  FileNames[Idx]:=Path3+'ExStkChk.New';                         { <<<<<<<<******** Change }




end; {..}



Procedure DefineTempJobMisc;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(JobMiscFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(JobMisc^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobMisc^;

  FileSpecOfs[Idx]:=@JobMiscFile^;


  FileNames[Idx]:=Path6+'JobMisc.New';                         { <<<<<<<<******** Change }




end; {..}


Procedure DefineTempJobRec;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(JobRecFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(JobRec^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobRec^;

  FileSpecOfs[Idx]:=@JobRecFile^;


  FileNames[Idx]:=Path6+'JobHead.New';                         { <<<<<<<<******** Change }




end; {..}


Procedure DefineTempJobDetl;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(JobDetlFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(JobDetl^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobDetl^;

  FileSpecOfs[Idx]:=@JobDetlFile^;


  FileNames[Idx]:=Path6+'JobDet.New';                         { <<<<<<<<******** Change }




end; {..}

Procedure DefineTempJobCtrl;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(JobCtrlFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(JobCtrl^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@JobCtrl^;

  FileSpecOfs[Idx]:=@JobCtrlFile^;


  FileNames[Idx]:=Path6+'JobCtrl.New';                         { <<<<<<<<******** Change }




end; {..}


Procedure DefineTempMLoc;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(MLocFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(MLocCtrl^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@MLocCtrl^;

  FileSpecOfs[Idx]:=@MLocFile^;


  FileNames[Idx]:=Path4+'MLocStk.New';                         { <<<<<<<<******** Change }




end; {..}


Procedure DefineTempNView;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(NomViewFile^);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(NomView^);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@NomView^;

  FileSpecOfs[Idx]:=@NomViewFile^;


  FileNames[Idx]:=Path2+'NomView.New';                         { <<<<<<<<******** Change }




end; {..}


Procedure DefineTempSys;


Var
  Idx :  Integer;

Begin

  Idx:=BuildF;

  FileSpecLen[Idx]:=Sizeof(SysFile);                      { <<<<<<<<******** Change }

  FileRecLen[Idx]:=Sizeof(Syss);                             { <<<<<<<<******** Change }

  RecPtr[Idx]:=@Syss;

  FileSpecOfs[Idx]:=@SysFile;

  FileNames[Idx]:='ExchqSS.New';


end; {..}



{ ====== Procedure to Setup BuildF ====== }

Procedure Define_TempDef(FileNo  :  Integer);

Begin

  Case FileNo of

    CustF  :  DefineTempCust;
    InvF   :  DefineTempDoc;
    IdetailF
           :  DefineTempId;
    NomF   :  DefineTempNom;
    StockF :  DefineTempStock;
    NHistF :  DefineTempNumHist;
    IncF   :  DefineTempCount;
    PWrdF  :  DefineTempPassword;
    MiscF  :  DefineTempMisc;
    JMiscF :  DefineTempJobMisc;
    JobF   :  DefineTempJobRec;
    JCtrlF :  DefineTempJobCtrl;
    JDetlF :  DefineTempJobDetl;
    MLocF  :  DefineTempMLoc;
    NomViewF: DefineTempNView;
    SysF   :  DefineTempSys;

  end; {Case..}


  FillChar(F[BuildF],Sizeof(F[BuildF]),0);

  FixFile[BuildF].ReBuild:=BOn;

end; {Proc..}



{ ========= Procedure to Create TempFile once defined ========= }


Procedure MakeTempFile(FileNo  :  Integer);


Begin

  Define_TempDef(FileNo);

  If (FileExists(SetDrive+FileNames[BuildF])) then
    FixFile[BuildF].ReBuild:=SysUtils.DeleteFile(SetDrive+FileNames[BuildF]);


  If (FixFile[BuildF].ReBuild) then
  Begin
    //PR: 29/11/2017 ABSEXCH-19503 Encrypt new file if necessary
    Temp_Make(FixFile[FileNo].Encrypted);   {* Make & Open Temp File *}

    FixFile[BuildF].ReBuild:=StatusOk;

    If (Not StatusOk) then
    Begin

      Write_FixLogFmt(FileNo,'Unable to create temporary file, report error'+Form_Int(Status,0)+
                          '. Rebuild will be cancelled for this file.',4);

    end;

  end
  else
    Write_FixLogFmt(FileNo,'Unable to erase temporary file '+FileNames[BuildF]+'. Please erase '+
                         'and retry rebuilding,',4);



  FixFile[FileNo].CreateNFile:=FixFile[BuildF].ReBuild;

  FixFile[FileNo].NewFileNo:=BuildF;

end; {Proc..}



{ ======= Procedure to Rebuild Header from New File ======= }


Procedure ReBuild_Hed(FileNo  :  Integer);

Var
  PageCount   :  Word;

  NoPages,
  PageEquiv   :  LongInt;

  PageByte    :  Byte;

  InFile,
  OutFile     :  File;

  PageBuffer  :  Array[1..DefPageSize7] of Byte;

  TmpIO       :  Integer;

  TmpBo,
  Abort       :  Boolean;


Begin

  TmpIO:=0;

  TmpBO:=BOff;

  Abort:=BOff;

  NoPages:=0;

  PageEquiv:=0;

  FillChar(PageBuffer,Sizeof(PageBuffer),0);

  With FixFile[FileNo] do
  Begin

    NoPages:=Round(DivWChk(FileLength,PageSize));


    {$I-}

    Assign(InFile,SetDrive+FileNames[NewFileNo]);

    Assign(OutFile,SetDrive+FileNames[FileNo]);

    Reset(InFile,1);

    TmpIO:=IOResult;

    If (TmpIO=0) then
      Reset(OutFile,1);

    TmpIO:=IOResult;

    If (TmpIO=0) then
    Begin

      BlockRead(InFile,PageBuffer,PageSize);

      TmpIO:=IOResult;

      Abort:=(TmpIO<>0);

      If (Not Abort) then
      Begin

        PageEquiv:=Conv_LSBLnum(NoPages);

        Move(PageEquiv,PageBuffer[39],Sizeof(PageEquiv));

        BlockWrite(OutFile,PageBuffer,PageSize);

        TmpIO:=IOResult;

        HedFixed:=(TmpIO=0);

      end;

      If (TmpIO<>0) then
      Begin

        Write_FixLogFmt(FileNo,'Unable to rebuild header. Rebuild will be cancelled for this file'+
                            ' Contact your dealer.',4);

      end
    end {If Opened ok..}
    else
    Begin

      Write_FixLogFmt(FileNo,'Unable to open this file. Please ensure all other users are out of Exchequer.',4);

    end;

    Close(InFile);

    Close(OutFile);

    TmpIO:=IOResult;  {* Final reset of IOResult *}


    {$I+}

  end; {With..}

end; {Proc..}



{ ======== Procedure to Scan Files to be rebuilt and set Largest Size ====== }



Function Check_FileSize  :  Int64;


Var
  TSize    :  File of Byte;

  n        :  Byte;

  Bigest
           :  Int64;


  FName    :  Str255;


Begin

  Bigest:=0;


  For n:=1 to TotFiles do
  With FixFile[n] do
  If (ReBuild) then
  Begin

    {$I-}

    FName:=SetDrive+FileNames[n];

    Assign(TSize,FName);

    If (IOResult=0) then
    Begin

      Reset(TSize);

      ReBuild:=(IOResult=0);

      If (Not Rebuild) then
        Write_FixLogFmt(n,'Unable to lock file. Please ensure all other users are out of Exchequer.',4);


      FileLength:=FileSize(TSize);

      Close(TSize);

      If (FileLength>Bigest) then
        Bigest:=FileLength;

    end;

    If (IOResult=0) then;

  end; {Loop..}

  Check_FileSize:=Bigest;

  {$I+}

end; {Func..}



Procedure SetPlainText(Mode  :  Boolean);

Begin
  SendMessage(Application.MainForm.Handle,WM_CustGetRec,500+Ord(Mode),0);
end;


{ ========= Proc to display partial records ======= }

Procedure Disp_PartCust(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With Cust do
  Begin

    Write_FixLogFilt(FileNo,'Account Type : '+CustSupp);
    Write_FixLogFilt(FileNo,'Account Code : '+CustCode);
    Write_FixLogFilt(FileNo,'Account Name : '+Company);

    For n:=1 to 5 do
      Write_FixLogFilt(FileNo,'Account Addr : '+Addr[n]);

    For n:=1 to 5 do
      Write_FixLogFilt(FileNo,'Delivry Addr : '+DAddr[n]);

    Write_FixLogFilt(FileNo,'Contact .....: '+Contact);

    Write_FixLogFilt(FileNo,'Telephone ...: '+Phone);

    Write_FixLogFilt(FileNo,'Fax Number ..: '+Fax);

  end;

  
end; {Proc..}



{ ========= Proc to display partial records ======= }

Function GetECTD(DC  :  Byte)  :  Str5;

Begin
  If ((DC>=Ord(SIN)) and (DC<=Ord(JPA))) then
    GetECTD:=DocCodes[DocTypes(DC)]
  else
    GetECTD:='ERROR';

end;

Procedure Disp_PartInv(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With Inv do
  Begin

    Write_FixLogFilt(FileNo,'Document No. : '+OurRef);

    Write_FixLogFilt(FileNo,'Operator Name: '+OpName);

    Write_FixLogFilt(FileNo,'Document Type: '+GetECTD(Byte(InvDocHed)));

    Write_FixLogFilt(FileNo,'Account Code : '+CustCode);

    Write_FixLogFilt(FileNo,'Doc Date ....: '+PoutDate(TransDate));

    Write_FixLogFilt(FileNo,'Doc Due Date : '+PoutDate(DueDate));

    Write_FixLogFilt(FileNo,'Your Ref 1 ..: '+YourRef);
    Write_FixLogFilt(FileNo,'Your Ref 2 ..: '+TransDesc);

    Write_FixLogFilt(FileNo,'Currency ....: '+Form_Int(Currency,0));


    Write_FixLogFilt(FileNo,'Doc Net Value : '+Form_Real(InvNetVal,0,2));

    For n:=1 to 5 do
      Write_FixLogFilt(FileNo,'Delivry Addr:'+DAddr[n]);

  end;

end; {Proc..}


{ ========= Proc to display partial records ======= }

Procedure Disp_PartId(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With Id do
  Begin

    Write_FixLogFilt(FileNo,'OurRef ......: '+DocPRef);

    Write_FixLogFilt(FileNo,'Line Folio  .: '+Form_Int(FolioRef,0));

    Write_FixLogFilt(FileNo,'Line Type ...: '+GetECTD(Byte(IdDocHed)));

    Write_FixLogFilt(FileNo,'Account Code : '+CustCode);

    Write_FixLogFilt(FileNo,'Line Date ...: '+PoutDate(PDate));

    Write_FixLogFilt(FileNo,'Stock Code ..: '+StockCode);

    Write_FixLogFilt(FileNo,'Line No.  ...: '+Form_Int(ABSLineNo,0));

    Write_FixLogFilt(FileNo,'Item No.  ...: '+Item);


    Write_FixLogFilt(FileNo,'Line Desc ...: '+Desc);

    Write_FixLogFilt(FileNo,'Line Qty ....: '+Form_Real(Qty,0,4));

    Write_FixLogFilt(FileNo,'Currency ....: '+Form_Int(Currency,0));

    Write_FixLogFilt(FileNo,'Unit Value ..: '+Form_Real(NetValue,0,2));

  end;

end; {Proc..}


{ ========= Proc to display partial records ======= }

Procedure Disp_PartStock(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With Stock do
  Begin

    Write_FixLogFilt(FileNo,'Stock Code ..: '+StockCode);

    Write_FixLogFilt(FileNo,'Stock Group .: '+StockCAT);

    Write_FixLogFilt(FileNo,'Stock Folio .: '+Form_Int(StockFolio,0));

    For n:=1 to 6 do
      Write_FixLogFilt(FileNo,'Desc ........: '+Desc[n]);


  end;

end; {Proc..}


{ ========= Proc to display partial records ======= }

Procedure Disp_PartJobRec(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With JobRec^ do
  Begin

    Write_FixLogFilt(FileNo,'Job Code .......: '+JobCode);

    Write_FixLogFilt(FileNo,'Contract Group .: '+JobCAT);

    Write_FixLogFilt(FileNo,'Alt Code .......: '+JobAltCode);

    Write_FixLogFilt(FileNo,'Job Folio ......: '+Form_Int(JobFolio,0));

    Write_FixLogFilt(FileNo,'Job Desc .......: '+JobDesc);

    Write_FixLogFilt(FileNo,'Job Account ....: '+CustCode);

    Write_FixLogFilt(FileNo,'Job Contact ....: '+Contact);

  end;

end; {Proc..}



{ ========= Proc to display partial records ======= }

Procedure Disp_PartJobMisc(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With JobMisc^,JobAnalRec do
  Begin

    Write_FixLogFilt(FileNo,'Job Code .......: '+JAnalCode);

    Write_FixLogFilt(FileNo,'Analysis Code ..: '+JANameCode);

    Write_FixLogFilt(FileNo,'................: '+JMNDX3);

    Write_FixLogFilt(FileNo,'Analysis Name ..: '+JAnalName);

    Write_FixLogFilt(FileNo,'Record Type ....: '+RecPFix+SubType);

  end;

end; {Proc..}


{ ========= Proc to display partial records ======= }

Procedure Disp_PartJobCtrl(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With JobCtrl^,JobBudg do
  Begin

    Write_FixLogFilt(FileNo,'Budget Code ....: '+BudgetCode);

    Write_FixLogFilt(FileNo,'Analysis Code ..: '+AnalCode);

    Write_FixLogFilt(FileNo,'Job Code .......: '+JobCode);

    Write_FixLogFilt(FileNo,'Record Type ....: '+RecPFix+SubType);

  end;

end; {Proc..}


{ ========= Proc to display partial records ======= }

Procedure Disp_PartJobAct(FileNo  :  Integer);

Var
  n  :  Byte;


Begin

  With JobDetl^,JobActual do
  Begin

    Write_FixLogFilt(FileNo,'Ledger Code ....: '+LedgerCode);

    Write_FixLogFilt(FileNo,'Analysis Code ..: '+AnalKey);

    Write_FixLogFilt(FileNo,'Stock/Pay Key ..: '+StockKey);

    Write_FixLogFilt(FileNo,'Employee Key ...: '+EmplKey);

    Write_FixLogFilt(FileNo,'Run time Key ...: '+RunKey);

    Write_FixLogFilt(FileNo,'Lookup Key .....: '+LookKey);

    Write_FixLogFilt(FileNo,'Main Header Key.: '+HedKey);

    Write_FixLogFilt(FileNo,'Record Type ....: '+RecPFix+SubType);

  end;

end; {Proc..}



{ ========= Procedure to Control partial displays ======== }

Procedure Disp_PartialRec(FileNo  :  Integer;
                          RecNo   :  LongInt);



Begin

  Write_FixMsg('');

  Write_FixLogFmt(FileNo,'Rec No. : '+Form_Int(RecNo,0)+' This record has been partially read:- ',4);

  SetPlainText(True);

  Case FileNo of

    CustF  :  Disp_PartCust(FileNo);

    InvF   :  Disp_PartInv(FileNo);

    IdetailF
           :  Disp_PartId(FileNo);

    StockF :  Disp_PartStock(FileNo);

    JobF   :  Disp_PartJobRec(FileNo);

    JMiscF :  Disp_PartJobMisc(FileNo);

    JCtrlF :  Disp_PartJobCtrl(FileNo);

    JDetlF :  Disp_PartJobAct(FileNo);

  end; {Case..}

  SetPlainText(False);

  Write_FixMsgFmt(ConstStr('~',80),4);

end; {Proc..}



{ === Procedure to Populate Global Currency Array === }

Procedure SetCurrPage(PNo    :  Byte;
                  Var C1P    :  Curr1PRec;
                  Var GCP    :  CurrRec;
                      ReadOn :  Boolean);


Const
  PageNos  :  Array[1..CurrencyPages] of Integer = (0,31,61);

Var
  n  :  Integer;


Begin
  For n:=0 to Currency1Page do
  If (n+PageNos[PNo]<=CurrencyType) then
  Begin
    If (ReadOn) then
    Begin
      GCP.Currencies[n+PageNos[PNo]].SSymb:=C1P.Currencies[n].Ssymb;
      GCP.Currencies[n+PageNos[PNo]].Desc:=C1P.Currencies[n].Desc;
      GCP.Currencies[n+PageNos[PNo]].CRates:=C1P.Currencies[n].CRates;
      GCP.Currencies[n+PageNos[PNo]].PSymb:=C1P.Currencies[n].PSymb;
    end
    else
    Begin
      C1P.Currencies[n].Ssymb:=GCP.Currencies[n+PageNos[PNo]].SSymb;
      C1P.Currencies[n].Desc:=GCP.Currencies[n+PageNos[PNo]].Desc;
      C1P.Currencies[n].CRates:=GCP.Currencies[n+PageNos[PNo]].CRates;
      C1P.Currencies[n].PSymb:=GCP.Currencies[n+PageNos[PNo]].PSymb;
    end;

  end; {Loop..}
end;



{ === Procedure to Populate Global Triangulation Currency Array === }

Procedure SetGCurPage(PNo    :  Byte;
                  Var C1P    :  GCur1PRec;
                  Var GCP    :  GCurRec;
                      ReadOn :  Boolean);


Const
  PageNos  :  Array[1..CurrencyPages] of Integer = (0,31,61);

Var
  n  :  Integer;


Begin
  For n:=0 to Currency1Page do
  If (n+PageNos[PNo]<=CurrencyType) then
  Begin
    If (ReadOn) then
    Begin
      GCP.GhostRates.TriRates[n+PageNos[PNo]]:=C1P.GhostRates.TriRates[n];
      GCP.GhostRates.TriEuro[n+PageNos[PNo]]:=C1P.GhostRates.TriEuro[n];
      GCP.GhostRates.TriInvert[n+PageNos[PNo]]:=C1P.GhostRates.TriInvert[n];
      GCP.GhostRates.TriFloat[n+PageNos[PNo]]:=C1P.GhostRates.TriFloat[n];
    end
    else
    Begin
      C1P.GhostRates.TriRates[n]:=GCP.GhostRates.TriRates[n+PageNos[PNo]];
      C1P.GhostRates.TriEuro[n]:=GCP.GhostRates.TriEuro[n+PageNos[PNo]];
      C1P.GhostRates.TriInvert[n]:=GCP.GhostRates.TriInvert[n+PageNos[PNo]];
      C1P.GhostRates.TriFloat[n]:=GCP.GhostRates.TriFloat[n+PageNos[PNo]];
    end;

  end; {Loop..}
end;



{ =========== Get MultiUser System File =========== }


Procedure GetMultiSys(Wait         :  Boolean;
                      Var  Locked  :  Boolean;
                           SysMode :  SysRecTypes);

Var
  TempSys  :  Sysrec;
  Key2F    :  Str255;


Begin

  TempSys:=Syss;

  Key2F:=SysNames[SysMode];


  Status:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

  Locked:=BOn;

  If (Debug) then Status_Means(Status);

  Ok:=(Status=0);


  If (Ok) and (Locked) then
  Begin
    Status:=GetPos(F[SysF],SysF,SysAddr[SysMode]);

    Case SysMode of
      SysR  :  TempSys:=Syss;
      VATR  :  Move(Syss,SyssVAT,Sizeof(SyssVAT));
      DEFR  :  Move(Syss,SyssDEF,Sizeof(SyssDEF));

      CurR,
      CuR2,
      CuR3  :  Begin
                 Move(Syss,SyssCurr1P^,Sizeof(SyssCurr1P^));

                 SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr,
                             BOn);

               end;

      GCuR,
      GCU2,
      GCU3  :  Begin

                 Move(Syss,SyssGCur1P^,Sizeof(SyssGCur1P^));

                 SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                             SyssGCuR1P^,
                             SyssGCuR^,
                             BOn);

               end;


    end;
  end; {If Ok..}

  Syss:=TempSys;
end;


{ =========== Put MultiUser System File =========== }

Procedure PutMultiSys(SysMode  :  SysRecTypes;
                      UnLock   :  Boolean);

Var
  TempSys  :  SysRec;

Begin
  TempSys:=Syss;

  ResetRec(SysF);

  SetDataRecOfs(SysF,SysAddr[SysMode]);

  Status:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

  If (StatusOk) then
  Begin


    Case SysMode of
      DEFR  :  Move(SyssDEF,Syss,Sizeof(SyssDEF));
      VATR  :  Move(SyssVAT,Syss,Sizeof(SyssVAT));

      CurR,
      CUR2,
      CUR3  :  Begin
                 SyssCurr1P^.IDCode:=SysNames[SysMode];

                 SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr,
                             BOff);

                 Move(SyssCurr1P^,Syss,Sizeof(SyssCurr1P^));


               end;

      GCuR,
      GCU2,
      GCU3  :  Begin
                 SyssGCuR1P^.IDCode:=SysNames[SysMode];

                 SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                             SyssGCuR1P^,
                             SyssGCuR^,
                             BOff);

                 Move(SyssGCur1P^,Syss,Sizeof(SyssGCur1P^));
               end;

      SysR  :  Syss:=TempSys;
    end;{Case..}


    Status:=Put_Rec(F[SysF],SysF,RecPtr[SysF]^,0);
  end;


  Report_BError(SysF,Status);


  Syss:=TempSys;

end;



{ == Gen routines to get and store multiple currency anf Triangulation pages == }

Procedure GetMultiSysCur(Wait         :  Boolean;
                    Var  Locked       :  Boolean);

Var
  N        :  SysRecTypes;
  TLocked  :  Boolean;


Begin

  OK:=BOn;

  For n:=CURR to CurPageEnd do
  Begin
    If (OK) then
    Begin
      TLocked:=Locked;
      GetMultiSys(Wait,TLocked,N);
    end;

  end;

  Locked:=TLocked;
end;


Procedure PutMultiSysCur(UnLock       :  Boolean);

Var
  N        :  SysRecTypes;


Begin

  For n:=CURR to CurPageEnd do
  Begin
    Begin
      PutMultiSys(n,UnLock);
    end;

  end;

end;



Procedure GetMultiSysGCur(Wait         :  Boolean;
                     Var  Locked       :  Boolean);

Var
  N        :  SysRecTypes;
  TLocked  :  Boolean;


Begin

  OK:=BOn;

  For n:=GCUR to GCurPageEnd do
  Begin
    If (OK) then
    Begin
      TLocked:=Locked;
      GetMultiSys(Wait,TLocked,N);
    end;

  end;

  Locked:=TLocked;
end;


Procedure PutMultiSysGCur(UnLock       :  Boolean);

Var
  N        :  SysRecTypes;


Begin

  For n:=GCUR to GCurPageEnd do
  Begin
    Begin
      PutMultiSys(n,UnLock);
    end;

  end;

end;



end.
