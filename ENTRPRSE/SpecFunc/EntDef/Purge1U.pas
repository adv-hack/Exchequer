Unit Purge1U;




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


  Procedure Delete_Details(Var RunOk :  Boolean);

  Procedure Purge_Control(ProgBar  :  TSFProgressBar);

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
     Windows,
     SysUtils,
     Messages,
     Dialogs,
     Forms,
     VarFPosU,
     VarRec2U,
     ETStrU,
     ETDateU,
     ETMiscU,
     BtrvU2,
     UnTils,
     ReBuildU,
     Rebuld1U,
     ReBuld2U,
     PurgeOU,
     SQLUtils,
     SQLPurgeDataU,
     oOPVATPayBtrieveFile, oBtrieveFile;



Var
  RunOnce  :  Boolean;

{ =============== Convert Yr/Pr into YrPr Value =========== }

Function Pr2Fig(FYr,FPr  :  Byte)  :  LongInt;

Begin
  Pr2Fig:=IntStr(SetPadNo(Form_Int(FYr,0),3)+SetN(FPr));
end;



{ ======== Procedure to Purge Orders ======== }

{ ====== Procedure to Scan all detail lines beloning to a doc ====== }

Procedure Delete_Details(Var RunOk :  Boolean);

Const
  Fnum      =  IdetailF;
  Keypath   =  IdFolioK;


Var
  KeyS,
  KeyChk  :  Str255;



Begin

  KeyChk:=FullNomKey(Inv.FolioNum);

  KeyS:=FullRunNoKey(Inv.FolioNum,-1);

  Status:=Find_Rec(B_GetGeq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With Id do
  Begin
    Application.ProcessMessages;

    Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

    If (Not StatusOk) then
    Begin

      Write_FixLogFmt(FNum,'Unable to delete line '+Form_Int(LineNo,0)+' of '+Inv.OurRef+', report error '+Form_Int(Status,0),4);

    end;

    RunOk:=(RunOk and (Status In [0]));

    If (RunOk) then
      Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

  end; {While..}

end; {Proc..}

// CJS 2014-12-03 - Order Payments - T110	Extend Purge Orders Process
procedure Delete_OrderPayments(OurRef: string; var RunOk: Boolean);
var
  OPVATPay: TOrderPaymentsVATPayDetailsBtrieveFile;
  Key: Str255;
begin
  OPVATPay := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
  try
    Status := OPVATPay.OpenFile(SetDrive + OrderPaymentsVATPayDetailsFilePath);
    if not StatusOK then
    begin
      // Report the error
      Write_FixMsgFmt('Unable to open Order Payments table, error ' + IntToStr(Status), 4);
      // Exit straight away, and don't allow the process to continue, because
      // otherwise the main Sales Order record will be deleted, leaving
      // orphaned OPVATPay records.
      RunOk := False;
      exit;
    end;

    // Find all the OPVATPay records matching the supplied Sales Order reference
    OurRef := Trim(OurRef);
    Key    := OurRef;
    Status := OPVATPay.GetGreaterThanOrEqual(Key);
    while (StatusOk) and (Trim(OPVATPay.VATPayDetails.vpOrderRef) = OurRef) do
    begin
      Status := OPVATPay.Delete;
      if not StatusOK then
      begin
        Write_FixMsgFmt('Unable to delete Order Payments record, error ' + IntToStr(Status), 4);
        // Exit straight away, and don't allow the process to continue, because
        // otherwise the main Sales Order record will be deleted, leaving
        // orphaned OPVATPay records.
        RunOk := False;
        exit;
      end;
      Status := OPVATPay.GetNext;
    end;
  finally
    OPVATPay.Free;
  end;
end;

{ ========== Procedure to Fix Document Header ========= }


Procedure Purge_Orders(Mode  :  Integer;
                   Var TotalCount,
                       LCount,
                       PCount:  LongInt;
                   Var RunOk :  Boolean;
                       ProgBar
                             :  TSFProgressBar);



 Const
   Fnum     =  InvF;
   Keypath  =  InvYrPrK;


 Var

   KeyS     :  Str255;

   StopPr,
   StopYr   :  Byte;
   IncFilt,
   ExcFilt,
   TypeInc,
   TypeExc  :  Str10;

   B_Func   :  Integer;



 Begin

   FillChar(KeyS,Sizeof(KeyS),0);


   With Purge_OrdRec^ do
   Begin
     StopPr:=PurgePr; StopYr:=PurgeYr;

     IncFilt:=IncCust;
     ExcFilt:=ExcCust;
     TypeInc:=IncType;
     TypeExc:=ExcType;

   end;

   KeyS:=Chr(StopYr)+Chr(StopPr);

   B_Func:=B_GetPrev;

   Write_FixMsgFmt('Purge up to and including : '#9+SetN(StopPr)+'/'+FullYear(StopYr),3);
   Write_FixMsgFmt('Include account      : '+#9+IncFilt+#9+'. Exclude account      : '+#9+ExcFilt,3);
   Write_FixMsgFmt('Include account type : '+#9+TypeInc+#9+'. Exclude account type : '+#9+TypeExc,3);


   If (Assigned(ProgBar)) then
     ProgBar.ProgLab.Caption:='Purging records';

   Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

   While (StatusOk) and (RunOk) and (Pr2Fig(Inv.AcYr,Inv.AcPr)<=Pr2Fig(StopYr,StopPr)) do
   With Inv do
   Begin

     B_Func:=B_GetPrev;

     Application.ProcessMessages;

     If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));


     Inc(LCount);

     If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


     If (RunOk) then
     Begin

       If (InvDocHed In [POR,SOR]) and ((RunNo=OrdPSRunNo) or (RunNo=OrdPPRunNo))
         and ((CustCode=IncFilt) or (IncFilt='')) and ((CustCode<>ExcFilt) or (ExcFilt='')) then
       Begin

         With Cust do
           If (CheckRecExsists(CustCode,CustF,CustCodeK) and ((RepCode=TypeInc) or (TypeInc='')) and
              ((RepCode<>TypeExc) or (TypeExc=''))) then
         Begin
           Inc(PCount);

           Delete_Details(RunOk);

           Delete_Notes(NoteDCode,FullNomKey(Inv.FolioNum)); {* Auto Delete Notes *}

           // CJS 2014-12-03 - Order Payments - T110	Extend Purge Orders process
           Delete_OrderPayments(Inv.OurRef, RunOk);

           {* Delete External Links *}

           KeyF:=FullQDKey('W','T',FullNomKey(Inv.FolioNum));

           DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);


           If (RunOk) then
           Begin
             Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

             If (Not StatusOk) then
             Begin

               Write_FixLogFmt(FNum,'Unable to delete Order '+Inv.OurRef+', report error '+Form_Int(Status,0),4);

             end
             else
               B_Func:=B_GetPrev;

           end;
         end; {If passed filter..}
       end; {If right doc..}
     end; {If aborted..}


     RunOk:=(RunOk and (Status In [0]));


     If (RunOk) then
       Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

   end; {While..}

   If (RunOk) then
   Begin
     LCount:=TotalCount;

     If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;

   end
   else
   begin
     Write_FixMsgFmt('WARNING!', 4);
     Write_FixMsgFmt('The data purge has been aborted.', 4);
     Write_FixMsgFmt('You must restore a backup before using Exchequer again!', 4);
   end;

 end; {Proc..}


{ ========= Proc to remove matching information ========== }

Procedure Purge_Match(Var RunOk :  Boolean;
                          ProgBar
                                :  TSFProgressBar);



Const
  Fnum      =  PWrdF;
  Fnum2     =  InvF;
  Keypath2  =  InvOurRefK;

Var
  KeyChk,KeyS,
  KeyI      :  Str255;

  Mode      :  Byte;

  Keypath,
  TmpKPath,
  TmpStat,
  B_Func    :  Integer;

  RecAddr2  :  LongInt;


Begin
  With Inv do
  Begin
    TmpKPath:=InvYrPrK;

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],RecAddr2,BOff,BOff);

    If (RemitNo<>'') or OrdMatch then
    Begin
      Mode:=3;
      Keypath:=PWK;
    end
    else
    Begin
      Mode:=4;
      Keypath:=HelpNDXK;
    end;

    KeyChk:=FullMatchKey(MatchTCode,MatchSCode,OurRef);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
    With PassWord.MatchPayRec do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      B_Func:=B_GetNext;

      Case Mode of
        3  :  KeyI:=PayRef;
        4  :  KeyI:=DocCode;
      end; {Case..}

      Status:=Find_Rec(B_GetEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyI);

      If (Status In [4,9]) then
      Begin

        Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

        If (Not StatusOk) then
        Begin

          Write_FixLog(FNum,'Unable to delete matching record for '+Inv.OurRef+'/'+KeyI+', report error '+Form_Int(Status,0));

        end
        else
          B_Func:=B_GetGEq;

      end;

      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],RecAddr2,BOn,BOn);

  end; {With..}

end; {Proc..}


{ ========= Proc to remove matching information ========== }

Procedure Copy_PurgeHist(Var RunOk :  Boolean;
                         Var TotalCount,
                             LCount,
                             PCount:  LongInt;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum      =  NHistF;
  Keypath   =  NHK;

Var
  KeyS  :  Str255;
  TimeR :  TimeTyp;


Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Copying History File';

  MakeTempFile(Fnum);

  If (FixFile[BuildF].ReBuild) then
  Begin
    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    While (StatusOk) and (RunOk) do
    With NHist do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));

      Inc(LCount);

      If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


      If (Yr<=Syss.AuditYr) then
      Begin
        Status:=Add_Rec(F[BuildF],BuildF,RecPtr[BuildF]^,0);

        RunOk:=(RunOk and (Status In [0,5]));

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(BuildF,'Unable to write data to temporary file, report error '+Form_Int(Status,0),4);
        end;

      end;


      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    end; {While..}

    Status:=Close_File(F[BuildF]);

    GetCurrTime(TimeR);

    Write_FixLogFmt(FNum,'History archive completed. '+#9+#9+CurrTimeStr(TimeR),3);


    If (RunOk) then
    With Purge_OrdRec^ do
    Begin
      If (FileExists(SetDrive+PurgeHFName)) then
        FixFile[BuildF].ReBuild:=DeleteFile(SetDrive+PurgeHFName);

      If (Not ReNameFile(SetDrive+FileNames[BuildF],SetDrive+PurgeHFName)) then
      Begin
        Write_FixLogFmt(Fnum,'*** Unable to rename '+Filenames[BuildF]+' to '+PurgeHFName,4);
        Write_FixLogFmt(Fnum,'*** Please rename manually before attempting to use Exchequer.',4);

      end
    end;
  end; {If..}



end; {Proc..}



{ ========= Proc to remove Paying In information ========== }

Procedure Purge_PayIn(Var RunOk :  Boolean;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  NomF;
  Fnum2     =  IdetailF;
  Keypath2  =  IdNomK;
  Keypath3  =  IdStkK;

Var
  FoundOk   :  Boolean;

  KeyChk,KeyS,
  KeyChk2,KeyS2,
  KeyN      :  Str255;

  N,
  TmpKPath,
  TmpStat,
  B_Func    :  Integer;

  RecAddr2  :  LongInt;

  PayId     :  IDetail;

  TimeR     :  TimeTyp;


Begin
  KeyN:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Paying in database';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyN);

  While (StatusOk) and (RunOk) do
  With Nom do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));

    If (Not (NomType In [NomHedCode,CarryFlg])) then
    Begin
      KeyChk:=FullNomKey(NomCode*DocNotCnst)+Chr(PayInNomMode);

      KeyS:=KeyChk;

      Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      While (StatusOk) and (RunOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) do
      With Id do
      Begin

        Application.ProcessMessages;

        If (Assigned(ProgBar)) then
          RunOk:=(Not (ProgBar.Aborted));


        TmpKPath:=Keypath2;

        TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],RecAddr2,BOff,BOff);

        FoundOk:=BOff;

        PayId:=Id;

        With PayId do
          KeyChk2:=Full_PostPayInKey(PayInCode,NomCode,Currency,Extract_PayRef2(StockCode));

        KeyS2:=KeyChk2;

        Status:=Find_Rec(B_GetGEq,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath3,KeyS2);

        FoundOk:=((StatusOk) and CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn));


        TmpStat:=Presrv_BTPos(Fnum2,TmpKPath,F[Fnum2],RecAddr2,BOn,BOn);

        B_Func:=B_GetNext;

        If (Not FoundOk) then
        Begin
          Status:=Delete_Rec(F[Fnum2],Fnum2,Keypath2);

          If (Not StatusOk) then
          Begin

            Write_FixLogFmt(FNum2,'Unable to delete paying record '+Extract_PayRef2(StockCode)+
                ', report error '+Form_Int(Status,0),4);

          end
          else
            B_Func:=B_GetGEq;

        end;

        Status:=Find_Rec(B_Func,F[Fnum2],Fnum2,RecPtr[Fnum2]^,KeyPath2,KeyS);

      end; {While..}


    end; {If wrong nom type }

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyN);
  end; {While..}

  GetCurrTime(TimeR);

  Write_FixLogFmt(FNum,'Paying In reference purge completed. '+#9+CurrTimeStr(TimeR),3);

end; {Proc..}



{ ========= Proc to remove RunTime Lines information ========== }

Procedure Purge_RunLines(Var RunOk :  Boolean;
                             StopPr,StopYr
                                   :  Byte;
                             ProgBar
                                   :  TSFProgressBar);


Const
  Fnum     =  IdetailF;
  Keypath  =  IdRunK;

Var
  FoundOk   :  Boolean;

  KeyN      :  Str255;

  B_Func    :  SmallInt;

  TimeR     :  TimeTyp;


Begin
  KeyN:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Run Time Control Lines';

  KeyN:=FullNomKey(1);

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyN);

  While (StatusOk) and (RunOk) do
  With Id do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    B_Func:=B_GetNext;


    If (IdDocHed=RUN) and (Pr2Fig(PYr,PPr)<=Pr2Fig(StopYr,StopPr)) then
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete Run Time Ctrl record '+Form_Int(NomCode,0)+
            ', report error '+Form_Int(Status,0),4);

      end
      else
        B_Func:=B_GetGEq;


    end;


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyN);

  end; {While..}

  GetCurrTime(TimeR);

  Write_FixLogFmt(FNum,'Run Ctrl Lines purge completed. '+#9+CurrTimeStr(TimeR),3);

end; {Proc..}




{ ========= Proc to reset account data ========== }

Procedure Purge_Customers(Var RunOk :  Boolean;
                          Var TotalCount,
                              LCount,
                              PCount:  LongInt;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  CustF;

Var
  n     :  Byte;
  KeyS  :  Str255;
  TimeR :  TimeTyp;


Begin
  KeyS:='';

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Accounts';

  Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (RunOk) do
  With Cust,Purge_OrdRec^ do
  Begin
    Application.ProcessMessages;

    If (Assigned(ProgBar)) then
      RunOk:=(Not (ProgBar.Aborted));

    Inc(LCount);

    If (LCount<=TotalCount) and (Assigned(ProgBar)) then
      ProgBar.ProgressBar1.Position:=LCount;


    If (DelCust and (CustSupp=TradeCode[BOn])) or (DelSupp and (CustSupp=TradeCode[BOff])) then
    Begin

      If (not CheckExsists(CustCode,InvF,InvCustK)) and
         (not ((Syss.DirectCust = CustCode) or (Syss.DirectSupp = CustCode))) then
      Begin
        Inc(PCount);

        Delete_Notes(NoteCCode,CustCode) ; {* Auto Delete Notes *}

        KeyF:=FullQDKey(QBDiscCode,Cust.CustSupp,FullCustCode(Cust.CustCode));

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);

        KeyF:=FullQDKey(CDDiscCode,Cust.CustSupp,FullCustCode(Cust.CustCode));

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);

        {* Delete External Links *}

        KeyF:=FullQDKey('W',CustSupp,FullCustCode(Cust.CustCode));

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);

        {* Delete TeleSales Anal Records *}

        KeyF:=PartCCKey(MatchTCode,MatchSCode)+FullCustCode(Cust.CustCode);

        DeleteLinks(KeyF,MLocF,Length(KeyF),MLK);

        {* Remove posted history *}

        KeyF:=CuStkHistCode+FullCustCode(Cust.CustCode);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        KeyF:=CuStkHistCode+#1+FullCustCode(Cust.CustCode);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        KeyF:=CuStkHistCode+#2+FullCustCode(Cust.CustCode);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        {* Remove Posted History *}

        For n:=1 to 3 do
        Begin
          KeyF:=CustHistAry[n]+FullCustCode(Cust.CustCode);

          DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        end;


        Status:=Delete_Rec(F[Fnum],Fnum,0);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Account record '+CustCode+', '+Company+
                ', report error '+Form_Int(Status,0),4);

        end
      end;
    end;

    Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  end; {While..}

  GetCurrTime(TimeR);

  With Purge_OrdRec^ do
  Begin
    If (DelCust) and (DelSupp) then
      Write_FixMsgFmt('Customer & Supplier Account purge completed. '+#9+#9+CurrTimeStr(TimeR),3)
    else
      If (DelCust) then
        Write_FixLogFmt(FNum,'Customer purge completed. '+#9+#9+CurrTimeStr(TimeR),3)
      else
        If (DelSupp) then
          Write_FixLogFmt(FNum,'Supplier purge completed. '+#9+#9+CurrTimeStr(TimeR),3);

  end; {With..}

end; {Proc..}






{ ========= Proc to remove Paying In information ========== }

Procedure Purge_Locations(Var RunOk :  Boolean;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  MLocF;
  Keypath   =  MLK;
  Keypath2  =  MLSecK;

Var
  FoundOk   :  Boolean;

  KeyChk,KeyS,
  KeyS2,KeyChk2
            :  Str255;

  N,
  TmpKPath,
  TmpStat,
  B_Func    :  Integer;

  RecAddr2  :  LongInt;

  TimeR     :  TimeTyp;


Begin
  KeyChk:=PartCCKey(CostCCode,CSubCode[BOn]);
  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Stock Locations';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With MLocCtrl^ do
  Begin
    Application.ProcessMessages;

     If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));


    TmpKPath:=Keypath;

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],RecAddr2,BOff,BOff);

    FoundOk:=BOff;


    KeyS2:=PartCCKey(CostCCode,CSubCode[BOff])+MLocLoc.loCode;
    KeyChk2:=KeyS2;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS2);

    FoundOk:=((StatusOk) and CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOn));

    TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],RecAddr2,BOn,BOn);

    B_Func:=B_GetNext;

    If (Not FoundOk) then
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

      If (Not StatusOk) then
      Begin

        Write_FixLogFmt(FNum,'Unable to delete location record '+mLocLoc.loCode+
              ', report error '+Form_Int(Status,0),4);

       end
       else
       Begin
         {* Delete Notes *}
         Delete_Notes(NoteLCode,MLocLoc.LoCode);

         B_Func:=B_GetGEq;

       end;

    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  GetCurrTime(TimeR);

  Write_FixLogFmt(FNum,'Location purge completed. '+#9+#9+CurrTimeStr(TimeR),3);

end; {Proc..}


{ ========= Proc to remove Paying In information ========== }

Procedure Purge_SerialNos(Var RunOk :  Boolean;
                              ProgBar
                                    :  TSFProgressBar);


Const
  Fnum      =  MiscF;
  Keypath   =  MIK;
  Fnum2     =  InvF;
  Keypath2  =  InvOurRefK;

Var
  FoundOk   :  Boolean;

  KeyChk,KeyS,
  KeyS2
            :  Str255;

  B_Func    :  SmallInt;

  TimeR     :  TimeTyp;


Begin
  KeyChk:=PartCCKey(MFIFOCode,MSERNSub);
  KeyS:=KeyChk;

  If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Serial Items';

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

  While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (RunOk) do
  With MiscRecs^.SerialRec do
  Begin
    Application.ProcessMessages;

     If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));


    FoundOk:=BOff;

    B_Func:=B_GetNext;

    If (Sold) and (DateOut<=Pr2Date(Syss.PrInYr,Syss.AuditYr)) then
    Begin

      FoundOk:=CheckExsists(OutDoc,Fnum2,Keypath2);

      If (Not FoundOk) then
      Begin
        FoundOk:=CheckExsists(InDoc,Fnum2,Keypath2);

      end;

      If (Not FoundOk) then
      Begin
        Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Serial record '+SerialNo+'/'+BatchNo+
                ', report error '+Form_Int(Status,0),4);

         end
         else
         Begin
           {* Delete Notes *}
           Delete_Notes(NoteRCode,FullNomKey(NoteFolio));

           B_Func:=B_GetGEq;
         end;
      end;
    end;

    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end; {While..}

  GetCurrTime(TimeR);

  Write_FixLogFmt(FNum,'Serial Number purge completed. '+#9+CurrTimeStr(TimeR),3);

end; {Proc..}




{ ========= Proc to reset account data ========== }

Procedure Purge_Stock(Var RunOk :  Boolean;
                      Var TotalCount,
                          LCount,
                          PCount:  LongInt;
                          ProgBar
                                :  TSFProgressBar);


Const
  Fnum      =  StockF;

Var
  KeyS  :  Str255;
  TimeR :  TimeTyp;

  Profit,
  Purch,
  Sales,
  Cleared,
  Rnum
        :  Real;


Begin
  KeyS:='';

  If (Purge_OrdRec^.DelStk) then
  Begin
    If (Assigned(ProgBar)) then
      ProgBar.ProgLab.Caption:='Purging Stock';

    Status:=Find_Rec(B_StepFirst,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);

    While (StatusOk) and (RunOk) do
    With Stock do
    Begin
      Application.ProcessMessages;

      If (Assigned(ProgBar)) then
        RunOk:=(Not (ProgBar.Aborted));


      Inc(LCount);

      If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


      Profit:=Profit_To_Date(Calc_AltStkHCode(StockType),
                                              FullNOmKey(StockFolio),
                                              0,150,YTD,
                                              Purch,Sales,Cleared,BOn);

      If (Not CheckExsists(StockCode,StockF,StkCatK)
         and (Not CheckExsists(StockCode,IDetailF,IdStkK)))
         and (QtyInStock=0.0) and (StockType<>StkGrpCode)
         and (Cleared=0.0) then
      Begin
        Inc(PCount);

        Delete_Notes(NoteSCode,FullNomKey(StockFolio)) ; {* Auto Delete Notes *}

        {* Delete any BOM entries *}

        KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                                           FullNomKey(Stock.StockFolio)));

        DeleteLinks(KeyF,PWrdF,Length(KeyF),PWK);

        {* Delete any BOM where used entries *}

        KeyF:=Strip('R',[#32],FullMatchKey(BillMatTCode,BillMatSCode,
                                           FullNomKey(Stock.StockFolio)));

        DeleteLinks(KeyF,PWrdF,Length(KeyF),HelpNDXK);


        {* Delete Qty Discounts *}

        KeyF:=FullQDKey(QBDiscCode,QBDiscSub,FullNomKey(Stock.StockFolio));

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);

        {* Delete Location stock records *}

        KeyF:=PartCCKey(CostCCode,CSubCode[BOff])+StockCode;

        DeleteLinks(KeyF,MLocF,Length(KeyF),MLK);


        {* Delete FIFO records *}

        {KeyF:=PartCCKey(CostCCode,CSubCode[BOff])+FullNomKey(StockFolio); Removev v3.13 as did not seem correct for FIFO! }

        KeyF:=PartCCKey(MFIFOCode,MFIFOSub)+FullNomKey(StockFolio);

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);


        {* Delete Alt Stk Codes *}

        KeyF:=PartCCKey(NoteTCode,NoteCCode)+FullNomKey(StockFolio);

        DeleteLinks(KeyF,MLocF,Length(KeyF),MLSecK);


        {* Delete Serial records *}

        If (Purge_OrdRec^.DelSN) then
        Begin
          KeyF:=FullQDKey(MFIFOCode,MSERNSub,FullNomKey(StockFolio));

          DeleteLinksPlus(KeyF,MiscF,Length(KeyF),MIK,NoteRCode,1);
        end;

        {$IFDEF EN552}
        {* Delete Bin records *}

        If (Purge_OrdRec^.DelSN) then
        Begin
          KeyF:=FullQDKey(brRecCode,MSERNSub,FullNomKey(StockFolio));

          DeleteLinks(KeyF,MLocF,Length(KeyF),MLSecK);
        end;
        {$ENDIF}


        {* Delete External Links *}

        KeyF:=FullQDKey('W','K',FullNomKey(Stock.StockFolio));

        DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);

        {* Delete TeleSales Anal Records *}

        KeyF:=PartCCKey(MatchTCode,MatchSCode)+StockCode;

        DeleteLinks(KeyF,MLocF,Length(KeyF),MLSuppK);

        {* Delete posted history *}

        KeyF:=Calc_AltStkHCode(StockType)+FullNomKey(StockFolio);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        {* Delete all Location history for this record *}

        KeyF:=Calc_AltStkHCode(StockType)+'L'+FullNomKey(StockFolio);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        {* Delete Sales history *}

        KeyF:=StockType+FullNomKey(StockFolio);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);

        {* Delete all Location Sales history for this record *}

        KeyF:=StockType+'L'+FullNomKey(StockFolio);

        DeleteLinks(KeyF,NHistF,Length(KeyF),NHK);



        Status:=Delete_Rec(F[Fnum],Fnum,0);

        If (Not StatusOk) then
        Begin

          Write_FixLogFmt(FNum,'Unable to delete Stock record '+StockCode+', '+Desc[1]+
                ', report error '+Form_Int(Status,0),4);

        end
      end;


      Status:=Find_Rec(B_StepNext,F[Fnum],Fnum,RecPtr[Fnum]^,0,KeyS);
    end; {While}

    GetCurrTime(TimeR);

    With Purge_OrdRec^ do
    Begin
      If (DelStk) then
        Write_FixLogFmt(FNum,'Stock purge completed. '+#9+#9+CurrTimeStr(TimeR),3);

      If (DelML) and (RunOk) then
        Purge_Locations(RunOk,ProgBar);

      If (DelSN) and (RunOk) then
        Purge_SerialNos(RunOk,ProgBar);

    end; {With..}


  end; {If..}



end; {Proc..}



 { ========== Procedure to Purge Accounting Data ========= }


Procedure Purge_Data(Mode  :  Integer;
                 Var TotalCount,
                     LCount,
                     PCount:  LongInt;
                 Var RunOk :  Boolean;
                     ProgBar
                           :  TSFProgressBar);



 Const
   Fnum     =  InvF;
   Keypath  =  InvYrPrK;


 Var

   KeyS     :  Str255;

   StopPr,
   StopYr   :  Byte;

   Tc       :  Char;

   SLocked  :  Boolean;

   B_Func   :  Integer;

   TimeR    :  TimeTyp;




 Begin

   FillChar(KeyS,Sizeof(KeyS),0);

   SLocked:=BOff;


   GetMultiSys(BOn,SLocked,SysR);

   With Purge_OrdRec^ do
   Begin
     StopPr:=Syss.PrInYr; StopYr:=PurgeYr;

   end;

   If (Assigned(ProgBar)) then
    ProgBar.ProgLab.Caption:='Purging Transactions';

   Syss.AuditYr:=StopYr;

   PutMultiSys(SysR,BOn);

   GetMultiSysCur(BOff,SLocked);

   GetMultiSysGCur(BOff,SLocked);


   KeyS:=Chr(StopYr)+Chr(StopPr);

   B_Func:=B_GetPrev;

   GetCurrTime(TimeR);

   Write_FixMsgFmt('Begin data purge ... Time : '+#9+CurrTimeStr(TimeR),3);

   Write_FixMsgFmt('Purge up to and including : '+#9+FullYear(StopYr),3);


   Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

   While (StatusOk) and (RunOk) and (Pr2Fig(Inv.AcYr,Inv.AcPr)<=Pr2Fig(StopYr,StopPr)) do
   With Inv do
   Begin

     B_Func:=B_GetPrev;

     Application.ProcessMessages;

     If (Assigned(ProgBar)) then
       RunOk:=(Not (ProgBar.Aborted));

     Inc(LCount);

     If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


     If (RunOk) then
     Begin

       If (Not (InvDocHed In [POR,SOR])) and
        ((RunNo>=0) or (RunNo=StkAdjRunNo) or (RunNo=TSTPostRunNo) or (RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo)
        or (RunNo=BatchPostRunNo) or (RunNo=BatchRunNo)) then
       Begin

         If (Not (InvDocHed In SalesSplit+PurchSplit)) or ((Round_up(BaseTotalOs(Inv),2)=0.0) or (RunNo=0)) then
         Begin
           Inc(PCount);

           Delete_Details(RunOk);

           If (RunOk) then {* Remove matching information *}
             Purge_Match(RunOk,ProgBar);

           If (RunOk) then
           Begin
             Delete_Notes(NoteDCode,FullNomKey(Inv.FolioNum)); {* Auto Delete Notes *}


             {* Delete External Links *}

             KeyF:=FullQDKey('W','T',FullNomKey(Inv.FolioNum));

             DeleteLinks(KeyF,MiscF,Length(KeyF),MIK);


             Status:=Delete_Rec(F[Fnum],Fnum,Keypath);

             Inc(PCount);

             If (Not StatusOk) then
             Begin

               Write_FixLogFmt(FNum,'Unable to delete Transaction '+Inv.OurRef+', report error '+Form_Int(Status,0),4);

             end
             else
               B_Func:=B_GetPrev;

           end;
         end {If passed filter..}
         {else
         Begin
           If (InvDocHed In [SRI]) then
           Begin
             MessageBeep(0);

             If (BaseTotalOs(Inv)<>0.0) then
               MessageBeep(0);
           end;
         end;}
       end; {If right doc..}
     end; {If aborted..}


     RunOk:=(RunOk and (Status In [0]));


     If (RunOk) then
       Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS);

   end; {While..}

   GetCurrTime(TimeR);

   Write_FixLogFmt(FNum,'Transaction purge completed. '+#9+CurrTimeStr(TimeR),3);

   If (RunOk) then
     Purge_PayIn(RunOk,ProgBar);

   If (RunOk) then
     Purge_RunLines(RunOk,StopPr,StopYr,ProgBar);

   If (RunOk) then
     Copy_PurgeHist(RunOk,TotalCount,LCount,PCount,ProgBar);

   With Purge_OrdRec^ do
   Begin
     If (RunOk) and (DelCust) or (DelSupp) then
     Begin
       Purge_Customers(RunOk,TotalCount,LCount,PCount,ProgBar);


     end;

     If (RunOk) and (DelStk or DelML or DelSN) then
       Purge_Stock(RunOk,TotalCount,LCount,PCount,ProgBar);

   end; {With..}

   If (RunOk) then
   Begin


     LCount:=TotalCount;

     If (LCount<=TotalCount) and (Assigned(ProgBar)) then
        ProgBar.ProgressBar1.Position:=LCount;


   end
   else
   Begin
     Write_FixMsgFmt('WARNING!',4);
     Write_FixMsgFmt('The data purge has been aborted.',4);
     Write_FixMsgFmt('You must restore a backup before using Exchequer again!',4);
   end;

 end; {Proc..}



{ ======== Procedure to Repair Selective Exchequer Data Files ====== }

Procedure Purge_Control(ProgBar  :  TSFProgressBar);

Var
  TimeR    :  TimeTyp;
  TabChr   :  Char;

  Info: TSQLPurgeInfo;
  PInfo: PSQLPurgeInfo;
Const
  PurgeTit  :  Array[1..2] of Str80 = ('Accounting Data','Orders');

Var
  n        :  Byte;


  Count,
  PCount,
  RCount,
  TotalCount
           :  LongInt;
  ShrinkFiles,
  RunOk,
  ReSort   :  Boolean;

  Mode     :  Integer;



Begin

  RunOk:=BOn;

  Mode:=1+Ord(Purge_OrdRec^.OrderMode);


  ShrinkFiles:=Purge_OrdRec^.RunRBuild;

  ReSort:=BOff;

  Addch:=ResetKey;

  WarnOnce:=BOff;  TabChr:=#32;

  Begin
    If (RunOnce) then
      Write_FixMsgFmt(ConstStr('=',80),3)
    else
    Begin
      ClearRich;
      RunOnce:=BOn;

    end;


    Write_FixMsgFmt('Exchequer '+PurgeTit[Mode]+' Purge.',2);

    Case Mode of

      1    :  With Purge_OrdRec^ do
              Begin {* Accounting Data *}

                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[StockF].Rebuild:=BOn;
                FixFile[MiscF].Rebuild:=BOn;
                FixFile[NomF].Rebuild:=BOn;
                FixFile[NHistF].Rebuild:=BOn;
                FixFile[PWrdF].Rebuild:=BOn;
                FixFile[MLocF].Rebuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF);

                If (DelCust) or (DelSupp) then
                  TotalCount:=TotalCount+Used_Recs(F[CustF],CustF);

                If (DelStk) then
                  TotalCount:=TotalCount+Used_Recs(F[StockF],StockF);

                TotalCount:=TotalCount+Used_Recs(F[NHistF],NHistF);

                PCount:=0;
                With ProgBar do
                Begin
                  ProgressBar1.Max:=TotalCount;
                  Caption:='Exchequer '+PurgeTit[Mode]+' Purge up to and including '+FullYear(Purge_OrdRec^.PurgeYr);
                end;

                TabChr:=#9;

                if SQLUtils.UsingSQL then
                begin
                  Info.Year := Purge_OrdRec^.PurgeYr;
                  Info.Period := Purge_OrdRec^.PurgePr;
                  Info.PurgeCustomers := Purge_OrdRec^.DelCust;
                  Info.PurgeSuppliers := Purge_OrdRec^.DelSupp;
                  Info.PurgeStock     := Purge_OrdRec^.DelStk;
                  Info.PurgeLocations := Purge_OrdRec^.DelML;
                  Info.PurgeSerial    := Purge_OrdRec^.DelSN;
                  Info.RecordsScanned := 0;
                  Info.RecordsProcessed := 0;
                  Info.Progress := ProgBar;
                  SQLPurgeData(@Info);
                  TotalCount := Info.RecordsScanned;
                  PCount := Info.RecordsProcessed;
                end
                else
                  Purge_Data(Mode,TotalCount,RCount,PCount,RunOk,ProgBar);

                FixFile[CustF].Rebuild:=BOff;
                FixFile[InvF].Rebuild:=BOff;
                FixFile[IdetailF].Rebuild:=BOff;
                FixFile[StockF].Rebuild:=BOff;
                FixFile[MiscF].Rebuild:=BOff;
                FixFile[NomF].Rebuild:=BOff;
                FixFile[NHistF].Rebuild:=BOff;
                FixFile[PWrdF].Rebuild:=BOff;
                FixFile[MLocF].Rebuild:=BOff;
                FixFile[SysF].ReBuild:=BOff;

              end;

      2    :  Begin {* Orders *}
                If (Assigned(ProgBar)) then

                FixFile[CustF].Rebuild:=BOn;
                FixFile[InvF].Rebuild:=BOn;
                FixFile[IdetailF].Rebuild:=BOn;
                FixFile[PWrdF].Rebuild:=BOn;
                FixFile[SysF].ReBuild:=BOn;

                Open_RepairFiles(CustF,SysF,BOn,BOff,ProgBar); {* Open all files and check for a Rebuild header *}

                Rcount:=0;

                TotalCount:=Used_Recs(F[InvF],InvF);

                PCount:=0;

                With ProgBar do
                Begin
                  ProgressBar1.Max:=TotalCount;
                  Caption:='Exchequer '+PurgeTit[Mode]+' Purge';
                end;

                Purge_Orders(Mode,TotalCount,RCount,PCount,RunOk,ProgBar);
              end;


    end; {Case..}


    If (Not ReSort) then
    Begin
      Close_Files(BOn);

      GetCurrTime(TimeR);

      Write_FixMsgFmt('Exchequer '+PurgeTit[Mode]+' Purge completed.'+#9+TabChr+CurrTimeStr(TimeR),3);
      Write_FixMsg('');
      Write_FixMsgFmt('Grand Total No. records processed . : '+#9+Form_Int(TotalCount,0),3);
      Write_FixMsgFmt('Grand Total No. records Purged .....: '+#9+Form_Int(PCount,0),3);
      Write_FixMsg('');
      Write_FixMsgFmt(ConstStr('=',80),3);

      If (ShrinkFiles) and (RunOk) then
      Begin

        FixFile[CustF].Rebuild:=(Mode=1);
        FixFile[InvF].Rebuild:=BOn;
        FixFile[IdetailF].Rebuild:=BOn;
        FixFile[StockF].Rebuild:=(Mode=1);
        FixFile[MLocF].Rebuild:=(Mode=1);
        FixFile[MiscF].Rebuild:=(Mode=1);
        FixFile[PWrdF].Rebuild:=(Mode=1);
        FixFile[SysF].ReBuild:=BOff;
        FixFile[BuildF].ReBuild:=BOff;

        ReBuild_Files(Bon,BOn,ProgBar);
      end
      else
      Begin

      end;


    end;

  end; {If Abort..}

//  PostMessage(ProgBar.Handle,WM_Close,0,0);

  FixFile[BuildF].ReBuild:=BOff;

end; {Proc..}

Begin
  RunOnce:=BOff;

end. {Unit..}
