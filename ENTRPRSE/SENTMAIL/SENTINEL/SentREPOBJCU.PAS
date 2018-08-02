Unit SentREPOBJCU;

{ prutherford440 09:40 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


{$O+,F+}

{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 05/09/94                      }
{                                                              }
{                 Rep Gen Object Control Unit II               }
{                                                              }
{               Copyright (C) 1994 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




Interface

Uses Windows,
     Classes,
     GlobVar,
     VarConst,
     SCRTCH1U,
     MCParser,
     RepObj2U,
     RepObj3U,
     RepFNO1U,
     RwOpenF,
     ReportO,
     RpDefine,
     Sentu,
     CIS,
     ElVar, DebugLog;

Type

  TExtraRepInfoRec = Record
    xDataPath  : string[255];
    xRepName   : string[255];
  end;


  RepCtrlPtr  =  ^RepCtrlObj;

  RepCtrlObj  =  Object(TGenReport)
                   Procedure RepPrintHeader(Sender  :  TObject); Virtual;
                 Public
                   ThisRepNo  : SmallInt;       { Scratch file number for report }

                   FilesOk    : Boolean;

                   LineCount,
                   SampleNo   :  LongInt;
                   {Ln,Page    :  Integer;}

                   LineCtrl   :  RepLinePtr;

                   HedCtrl    :  RepLHedPtr;

                   ThisScrt   :  ScratchPtr;

                   FastObj    :  FastNDXOPtr;


                   Fnum,
                   Keypath    :  Integer;

                   {KeyS,}
                   KeyChk,
                   POnStr,
                   POffStr    :  Str255;

                   NewPage,
                   CDFOn,
                   DBFOn,
                   KeepRep,
                   TestMode   :  Boolean;

                   DBFCmdLine : string;


                   ExportF    :  Text;

                   RepCtrlRec :  ^ReportHedType;
                   RepGen     :  ^RepGenRec;

                   ElertName,
                   UserID : ShortString;
                   CSVFName : AnsiString;

                   OldRangeStart,
                   OldRangeEnd : TElertRangeRec;

                   ParamList : TList;
                   FLockPosition : longint;
                   FLockCount : Integer;
                   FxInfo :  TExtraRepInfoRec;
                   FDetailsSet : Boolean;
                   FStarted : Boolean;

                   OnDoProgress : TThreadProgressProc;

                   LastBreakList   :  Array[0..9] of LongInt;
                   LastTBreakFound : integer;

                   iResult : Integer;
                   {Constructor Create(AOwner : TObject;RepCRec  :  ReportHedType);}
                   Constructor Create(AOwner : TObject;RepCRec : RepGenRec; xInfo : TExtraRepInfoRec);

                   {Constructor Init(RepCRec  :  ReportHedType);}

                   {Destructor Done;}
                   Destructor Destroy; virtual;

                   Procedure ResetVar;

                   Procedure Open_Def(DFnam  :  Str255;
                                  Var IOFlg  :  Boolean);

                   Procedure Close_Def;

                   Procedure ExportCDF(DFnam  :  Str255);

                   Procedure RepPrintLn(Line2Print  :  Str255);

                   Procedure RepPage;

                   Procedure RepEnd;

                   Procedure SelectRecords(Var NoFound  :  LongInt);

                   Procedure Process_Breaks(LastOne  :  Boolean);

                   Procedure Process_File; Virtual;

                   Procedure Process_Report; Virtual;

                   procedure SetDbfCmdLine;
                   procedure ExpandDbfCmdLine;

                   Procedure UpdateProgress(Max  :  Integer;
                                              s1 : ShortString = '';
                                              s2 : ShortString = '';
                                              s3 : ShortString = '';
                                              s4 : ShortString = ''); virtual;

                   Function  GetReportInput : Boolean; Virtual;
                   Procedure RepSetTabs; Virtual;
                   Procedure RepPrintPageHeader; Virtual;
                   Procedure Process; Virtual;
                   Procedure RepPrint(Sender  :  TObject); Virtual;
                   Procedure RepSetHeadingTabs; Virtual;
                   Procedure PrintColText (Const ColText : ColTextPtrType);
                   Procedure PrintColUndies (Const ColUndies : ColUndiesType);
                   Function  Start : Boolean; Virtual;
                   procedure Finish; Virtual;
                   Procedure BuildTempData(Var NoFound : LongInt); Virtual;
                   Procedure Warn_ValErr(RVNo : Str10; ValLine : Str100);
                   function Lock : SmallInt;
                   function Unlock : SmallInt;
                   procedure SetParameter(var Rep : ReportDetailType;
                                              Par : TReportParamRec);
                   //override beforeprint so we can set filename to correct path
                   Procedure RepBeforePrint(Sender  :  TObject); Virtual;
                   procedure InitInThread; Virtual;
                 End; {Object..}


 Var
   TmpColText : ColTextPtrType;



 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Implementation


 {~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

 Uses
   Dialogs,
   Forms,
   Graphics,
   SysUtils,
   ETStrU,
   ETMiscU,
   ETDateU,
   VarFPosU,

   BtrvU2,
   BtSupU1,
   BtKeys1U,

   RpDevice,
   RpMemo,

   ExBtTh1U,

{$IFDEF DBF}
   DbfInt,
{$ENDIF}

   DicLinkU,
   PrntDlg2,
   RpCommon,
   CurrncyU,
   ComnU2,
   RwFuncs,
   ElObjs,
   Excep3U,
   Enterprise04_TLB,
   ComObj,
   ActiveX,
   WorkSta2,
   CtkUtil04;


 Var
   CommandPool : TBits;


//Local copy of func in Excep3U to allow correct data path rather than use
//global variable SetDrive

  Procedure SentClose_Files(ByFile  :  Boolean);


  Var
    Choice  :  Byte;

    FSpec   : FileSpec;


  Begin

  {$I-}
    If (Debug) or (ByFile) or (ResetBtOnExit) then
    Begin
      For Choice:=1 to TotFiles do
      Begin
        {* Check file is open b4 closing it *}

        Status:=GetFileSpec(F[Choice],Choice,FSpec);

        If (StatusOk) then
          Status:=Close_File(F[Choice])
        else
          Status:=0;
      end;

//      Status:=Reset_B;
    end
    else
      Status:=Stop_B;

    If (Debug) then
      Status_Means(Status);


    

    {$I+}
  end;



Function LGetSwapDir(DPath : String) :  Str255;


Var
  Ok2Cont     :  Boolean;

  IOChk       :  Integer;

  TDirN       :  Str255;

Begin
  {$I-}

  Ok2Cont:=BOn;

  TDirN:=SwapDirN;

  If (SwapDirN<>'') then
  Begin
    TDirN:=Copy(SwapDirN,1,Pred(Length(SwapDirN)));

    If (Not DirectoryExists(DPath+TDirN)) then
    Begin
      MkDir(DPath+TDirN);

      IOChk:=IOResult;

      Ok2Cont:=CheckIOError(IOChk,'Unable to create directory '+SetDrive+SwapDirN+'. When attempting to generate a swap file.');

      If (Ok2Cont) then
        TDirN:=SwapDirN
      else
      Begin
        TDirN:='';

      end;
      {SetFAttr(TDirN,Hidden); *Do not attempt to hide these logs }

    end
    else
      TDirN:=SwapDirN;
  end;


  {$I+}

  Result:=TDirN;
end; {Func..}


//Local copy of func in BTSupU1 to allow correct data path rather than use
//global variable SetDrive

Function LGetTempFNameExt(SwapName,ExtN :  Str10; DPath : String)  :  Str255;


Var
  n,IOChk     :  Integer;

  SwapFileName, SwapFileName1,
  TDirN       :  Str255;
  NumStr      :  Str10;

Begin
  {$I-}

  n:=1;

  TDirN:=LGetSwapDir(DPath);

  Repeat

    Str(n:0,NumStr);

    SwapFileName :=TDirN+SwapName+NumStr+ExtN;

    SwapFileName1 :=TDirN+SwapName+NumStr+'.PDF';

    Inc(n);

  Until (Not FileExists(DPath+SwapFileName)) and (Not FileExists(DPath+SwapFileName1)) or (n>9999);

  {$I+}

  Result:=DPath+SwapFileName;
end; {Func..}


 { ======== Function to Check master inclusion ====== }

 Function File_Include(Fnum  :  Integer)  :  Boolean;

 Var
   TmpBo   : Boolean;
   KeyS    : Str255;
   LStatus : Integer;
 Begin

   TmpBo:=BOff;

   Case Fnum of

     1,2  :  TmpBo:=(Cust.CustSupp=TradeCode[(Fnum=1)]);

     {*431RW  HM 03/04/00: Added Discount Matrix }
     14   :  With MiscRecs^ Do Begin
                        { Customer/Supplier Discounts }
               TmpBo := ((RecMFix = CDDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn]])) Or
                        { Customer/Supplier/Stock Quantity Breaks }
                        ((RecMFix = QBDiscCode) And (SubType In [TradeCode[BOff], TradeCode[BOn], QBDiscSub]));
             End; { If }

     { Job Costing - Rates Of Pay (Employee & Global) }
     19   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBECode, JBPCode]);

     { Job Costing - Budgets }
     25   :  With JobCtrl^ Do
               TmpBo:=(RecPfix = JBRCode) And (SubType In [JBBCode, JBMCode, JBSCode]);

     {*431RW HM 03/04/00: Customer and Supplier Notes }
     29,
     30   :  With Password, NotesRec Do Begin
               TmpBo := (RecPfix = NoteTCode) And (SubType = NoteCCode);

               If TmpBo Then Begin
                 { Get Account Record and check type }
                 KeyS := NoteFolio;
                 LStatus:=Find_Rec(B_GetEq,F[CustF],CustF,RecPtr[CustF]^,CustCodeK,KeyS);
                 If (LStatus = 0) And CheckKey(NoteFolio, KeyS, Length(NoteFolio), BOn) Then
                   TmpBo := (Cust.CustSupp = TradeCode[FNum = 29])
                 Else
                   TmpBo := False;
               End; { If }
             End; { With }

     else    TmpBo:=BOn;

   end; {Case..}


   File_Include:=TmpBo;

 end; {Func..}



 { ======= Function to Set up initial Check key ======= }


 Function File_CheckKey(Fnum  :  Integer)  :  Str255;

 Var
   KeyS   :  Str255;

 Begin

   Blank(KeyS,Sizeof(KeyS));

   Case Fnum of

     7,8  :  KeyS:=PartCCKey(CostCCode,CSubCode[(Fnum=7)]);

     {*431RW  HM 29/03/00: Added Bill Of Materials }
     10   :  KeyS:=PartCCKey(BillMatTCode, BillMatSCode);

     13   :  KeyS:=PartCCKey(PassUCode,C0);

     {*431RW  HM 29/03/00: Added Job Notes }
     15   :  KeyS:=PartCCKey(NoteTCode, NoteJCode);

     16   :  KeyS:=PartCCKey(MFIFOCode,MSernSub);

     { Job Costing - Analysis Codes }
     17   :  KeyS:=PartCCKey(JARCode, JAACode);

     { Job Costing - Job Types }
     18   :  KeyS:=PartCCKey(JARCode, JATCode);

     {*431RW HM 29/03/00: Added FIFO }
     20   :  KeyS:=PartCCKey(MFIFOCode, MFIFOSub);

     { Job Costing - Employees }
     21   :  KeyS:=PartCCKey(JARCode, JAECode);

     { Job Costing - Actuals }
     23   :  KeyS:=PartCCKey(JBRCode, JBECode);

     { Job Costing - Retentions }
     24   :  KeyS:=PartCCKey(JBRCode, JBPCode);

     { Locations }
     26   :  KeyS:=PartCCKey(CostCCode, CSubCode[True]);

     { Stock Locations }
     27   :  KeyS:=PartCCKey(CostCCode, CSubCode[False]);

     { HM 25/01/99: Matched Payments added }
     28   :  KeyS:=PartCCKey('T', 'P');

     {*431RW HM 03/04/00: Customer and Supplier Notes }
     29,
     30   :  KeyS:=PartCCKey(NoteTCode, NoteCCode);

     {*431RW HM 03/04/00: Stock Notes }
     31   :  KeyS:=PartCCKey(NoteTCode, NoteSCode);

     {*431RW HM 12/04/00: Transaction Notes }
     32   :  KeyS:=PartCCKey(NoteTCode, NoteDCode);
     //PR: 20/01/03 CIS Vouchers
     {$IFDEF EN550CIS}
     33   :  KeyS := PartCCKey(JATCode, JBSCode);
     {$ENDIF}
   end; {Case..}

   File_CheckKey:=KeyS;

 end; {Func..}



  { ======= Procedure to Set up initial Btrv Functions key ======= }


 Procedure File_BtrvDrv(    Fnum    :  Integer;
                        Var BFunc1,
                            BFunc2  :  Integer);


 Begin

   Case Fnum of

     7,   8,
     16, 17,
     18, 21,
     23, 24,
     26, 27,

     { HM 04/01/99: Matched Payments added }
     28,

     {*431RW HM 29/03/00: Added new files }
     10, 15,
     20, 29,
     30, 31,
     32
     //PR: 20/01/03 new file for CIS Vouchers
     {$IFDEF EN550CIS}
     ,33
     {$ENDIF}
          :  Begin
               BFunc1:=B_GetGEq;
               BFunc2:=B_GetNext;
             end;
     else    Begin
               BFunc1:=B_StepFirst;
               BFunc2:=B_StepNext;
             end;

   end; {Case..}

 end; {Proc..}



{ ======= Procedure to Reset contents of all data files ===== }

  Procedure Reset_DataRecs;

  Var
    n  :  Byte;

  Begin

    For n:=1 to TotFiles do
      If (n<>SysF) then
        ResetRec(n);

  end; {Proc..}


function ParamVal(const s : shortString; Atype : Byte; OffSet : SmallInt) : ShortString;
var
  R : TElertRangeRec;
begin
//Need to put parameter into TElertRangeRec record to use getrangevalue func
  FillChar(R, SizeOf(R), #0);
  Case AType of
    1  : R.egType := evDate;
    2  : R.egType := evPeriod;
    else
      R.egType := evString;
  end;//case
  R.egString := s;
  R.egOffset := OffSet;
  Result := GetRangeValue(R);
end;



   { ---------------------------------------------------------------- }

   {  RepCtrl Methods }

   { ---------------------------------------------------------------- }




  Constructor RepCtrlObj.Create(AOwner : TObject;RepCRec : RepGenRec; xInfo : TExtraRepInfoRec);
  {Constructor RepCtrlObj.Init(RepCRec  :  ReportHedType);}
  var
    FoundCode : String;

  Begin
//    Query_OKToClose := False;
    Inherited Create(AOwner);
    OnDoProgress := nil;
    ParamList := TList.Create;
    ThisRepNo := -1;
    FxInfo := xInfo;
    FDetailsSet := False;
    FStarted := False;
    FilesOk := False;
    iResult := 0;
  end; {Constructor..}


  {* ------------------------ *}


  Destructor RepCtrlObj.Destroy; {Done;}
  var
    i : integer;
  Begin
    //Reset range records if necessary
    if Assigned(MTExLocal) then
    begin
      MTExLocal^.LElertRec.elRangeStart := OldRangeStart;
      MTExLocal^.LElertRec.elRangeEnd := OldRangeEnd;
    end;

    if Assigned(LineCtrl) then
      Dispose(LineCtrl,Done);

    if Assigned(HedCtrl) then
      Dispose(HedCtrl,Done);

    if Assigned(ParamList) then
    begin
      for i := 0 to ParamList.Count - 1 do
        if Assigned(ParamList[i]) then
          Dispose(PReportParamRec(ParamList[i]));
    end;

    { get rid of scratch file }
    if Assigned(RepCtrlRec) then
      If (RepCtrlRec^.RepType<>RepNomCode) and Assigned(ThisScrt) then
        Dispose(ThisScrt,Done);
    If (ThisRepNo > -1) Then
      CommandPool[ThisRepNo] := False;

    Dispose(RepGen);
    Dispose(RepCtrlRec);

    If (CDFOn) then
      Close_Def;

{    if Assigned(MTExLocal) then
    begin
      MTExLocal^.Close_Files;
      MTExLocal.Destroy;
    end;}

    Destroy_ThreadFiles;
    Inherited Destroy;
    SetQuery_OKToClose(True);

    if FilesOK then
      SentClose_Files(True);
  end; {Destructor..}


  {* ------------------------ *}


  Procedure RepCtrlObj.ResetVar;

  Begin

    If (LineCount>0) then
    Begin
      LineCtrl^.LineTotals(1,255);  {* Reset all sub totals & Break Status *}

      LineCtrl^.FirstGo:=BOn;
    end;

    {Ln:=0;

    Page:=1;}

    RepRunCount:=1;

    LineCount:=0;

    KeyS:='';

    KeyChk:='';

    NewPage:=BOn;

    KeepRep:=BOn;


  end;

  {* ------------------------ *}



  { ============ Open/Close Files ============ }

  Procedure RepCtrlObj.Open_Def(DFnam  :  Str255;
                            Var IOFlg  :  Boolean);

  Var
    TmpIO  :  Integer;

  Begin
    {$I-}
    TmpIO:=0;

    Assign(ExportF,DFnam);

    ReWrite(ExportF);

    TmpIO:=IOResult;

    Report_IOError(TmpIO,DFnam);

    IOFlg:=(TmpIO=0);

    {$I+}

  end;



  Procedure RepCtrlObj.Close_Def;

  Begin
    {$I-}

    Close(ExportF);

    {$I+}

    If (IOResult<>0) then ;
  end;




  { ============ Export Line ============ }

  Procedure RepCtrlObj.ExportCDF(DFnam  :  Str255);

  Var
    TmpIO  :  Integer;

  Begin
    {$I-}

    Writeln(ExportF,DFnam);

    TmpIO:=IOResult;

    Report_IOError(TmpIO,DFnam);

    PrntOk:=(TmpIO=0);

    {$I+}

  end;




  {* ------------------------ *}


  {* Print Line with Global effects *}

  Procedure RepCtrlObj.RepPrintLn(Line2Print  :  Str255);
  Begin
    SendLine(Line2Print);
  end;


  { ======================= Report Page ======================= }

  Procedure RepCtrlObj.RepPage;


  Begin
    (* {RW32}
    With Printer_Def do
    Begin

      If (Page>1) then
      Begin
        Println(ConCat(ConDon,Dson,'('+Syss.UserName+'). '+RepCtrlRec^.RepDesc,'/... continued',ConDof,DsOf));
        Inc(Ln);
      end;


      StdPage(Page);


      RepPrintLn(LineCtrl^.FillHeader);


      Println(ConCat(ConDon,ConstStr('=',132),ConDof));

      Ln:=Ln+4;
    end;

    NewPage:=BOn;
    *)
  end;




  {* ------------------------ *}


  Procedure RepCtrlObj.SelectRecords(Var NoFound  :  LongInt);

  Var
    WantSavePos,
    Selected,
    PassFileFilt,
    Abort,
    ForceEnd,
    FoundFirst,
    FastNDX
              :  Boolean;

    TmpStat,
    B_FuncGet,
    B_FuncNext
              :  Integer;

    MainRecPos,
    RecAddr,
    TotalCount,
    Count,
    NoChecked
              :  LongInt;

    progcount : integer;
  Begin

    NoFound:=0;

    TotalCount:=Used_Recs(F[Fnum],Fnum);

    Count:=0;

    progcount := 0;

    NoChecked:=0;  Abort:=BOff; ForceEnd:=BOff; FoundFirst:=BOn;

    FastNDX:=BOff;

    PassFileFilt:=BOff;

    (* {RW32}
    PopUp(BotW);

    PopShadw(StaW);

    WriteCtrPop(1,StaW,' - Exchequer Report Writer - ');

    WriteCtrPop(3,StaW,'Generating '+Copy(RepCtrlRec^.RepDesc,1,30));

    WriteCtrPop(4,StaW,'% Complete');

    WriteCtrPop(StaW[4],StaW,'<Any> Key to Abort');

    Draw_Scale(PBarW);
    *)
    Try
      progcount := Trunc(100 * (Count / TotalCount));
    Except
      progcount := 1;
    End;
    { Update thread window for progress info }
    InitProgress(TotalCount);
    {ShowStatus}UpdateProgress(progcount,'Processing Report', '('+IntToStr(NoFound)+'/'+IntToStr(TotalCount)+').');


    KeyChk:=File_CheckKey(RepCtrlRec^.DriveFile);

    File_BtrvDrv(RepCtrlRec^.DriveFile,B_FuncGet,B_FuncNext);
    WantSavePos := (B_FuncNext <> B_StepNext);

    KeyS:=KeyChk;

    With GroupRepRec^.ReportHed do
    Begin

      FastNDX:=(DrivePath>0);

      If (FastNDX) then Begin
        WantSavePos := False;
        New(FastObj,Init(FastNDXOrdL^[DriveFile,DrivePath],FNDXInpNo,RepName,MtExLocal));
      End; { If }

      RefreshPos:=(RefreshPos or (FirstPos=0)); {* Force refresh *}

      RefreshEnd:=(RefreshEnd or (LastPos=0)); {* Force refresh *}

      If (RefreshPos) then
      Begin

        If (FastNDX) then
        Begin
          KeyChk:=FastObj^.KeyChk;
          KeyS:=KeyChk;

          Status:=FastObj^.Find_FastNDX(B_GetGEq,KeyS);

        end
        else
        Begin

          Status:=Find_Rec(B_FuncGet,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);
        end;
      end
      else
      Begin
        SetDataRecOfs(Fnum,FirstPos);

        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,0);

        Count:=FirstTot;

        If (FastNDX) and (StatusOk) and (FastObj^.LinkUp) then {* Bring Link file In Line *}
          FastObj^.Jump_NDXStart(FirstPos);

      end;
    end;

    While (StatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    Begin
      If WantSavePos Then Begin
        { Save main record position here if not STEPing }
        TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOff,BOff);
      End; { If }

      Selected:=BOn;

      RecAddr:=0;

      {Loop_CheckKey(PrntOk);}

      Inc(Count);
      Try
        progcount := Trunc(100 * (Count / TotalCount));
      Except
        progcount := 1;
      End;

      {ShowStatus}UpdateProgress(progcount,'Processing Report', '('+IntToStr(NoFound)+'/'+IntToStr(TotalCount)+').');
//      UpdateProgress(Count);

      LineCtrl^.FillObject(Selected);

      With LineCtrl^ do
        Abort:=(SelErr or FmulaErr);

      PassFileFilt:=File_Include(RepCtrlRec^.DriveFile);

      NoChecked:=NoChecked+Ord(PassFileFilt);

      If (Selected) and (PassFileFilt) and (Not Abort) then
      Begin

        Status:=GetPos(F[Fnum],Fnum,RecAddr);  {* Get Preserve File Posn *}

        If (FoundFirst) then
        With GroupRepRec^.ReportHed do
        Begin
          FirstPos:=RecAddr;
          FirstTot:=Count;

          FoundFirst:=BOff;

        end;

        ThisScrt^.Add_Scratch(Fnum,Keypath,RecAddr,LineCtrl^.FullSortKey,'');

        Inc(NoFound);

        {* Check for Abort if test mode and sample found *}

        ForceEnd:=((NoFound=SampleNo) and (TestMode));

        With GroupRepRec^.ReportHed do
        Begin
          ForceEnd:=(ForceEnd or ((LastPos=RecAddr) and (Not RefreshEnd)));

          If (RefreshEnd) then
            LastPos:=RecAddr;
        end;

      end;

      (* {RW32}
      MakeWindow(BotW);

      WriteCtrPop(2,BotW,'Records Processed/Selected : '+Form_Int(NoChecked,0)+'/'+Form_Int(NoFound,0));
      *)

      If WantSavePos Then Begin
        { Restore main record pos here if not STEPing }
        TmpStat:=Presrv_BTPos(Fnum,Keypath,F[Fnum],MainRecPos,BOn,BOff);
      End; { If }

      If (FastNDX) then
        Status:=FastObj^.Find_FastNDX(B_GetNext,KeyS)
      else
        Status:=Find_Rec(B_FuncNext,F[Fnum],FNum,RecPtr[FNum]^,KeyPath,KeyS);

    end; {While..}

    (* {RW32}
    If (FastNDX) then
      Show_Bar(Round(DivWChk(TotalCount,TotalCount)*100),PBarW);

    RmWin;
    RmWin;
    *)

    If (FastNDX) then
      Dispose(FastObj,Done);

    LineCtrl^.LineTotals(2,0); {* Reset Current Values *}

  end; {Proc..}


  {* ------------------------ *}


(*  Procedure RepCtrlObj.Process_Breaks(LastOne  :  Boolean);

  Var
    n         :       Byte;
    MadeGap   :       Boolean;



  Begin

    MadeGap:=BOff;

    With RepCtrlRec^ do
    Begin


      With LineCtrl^ do
      Begin

        If (SubTOn) and (Not FirstGo) then
        Begin

          For n:=MaxNoSort downto 1 do
          Begin

            If (BreakList[n]<>0) then
            Begin

              If (SummOn) then
              Begin

                If (IncInSumm(n)) then
                Begin
                  { Mark break as printed }
                  PrntBrkList[n] := True;

                  If (n<>NOTBreaks) then
                  Begin
                    {RepPrintLn(FillTULine(BOff));}

                    PrintColUndies(LineCtrl^.FillUndies(BOff));

                    {Inc(Ln);}
                  end;

                  {RepPrintLn(FillSummary(n,(n=NOTBreaks)));}
                  FillSummary(n,(n=NOTBreaks), RepDest = 2);
                  PrintColText (ColText);

                  If (n<>NOTBreaks) then Begin
                    { HM Aded 13/3/97: To put line under subtotal }
                    {PrintColUndies(LineCtrl^.FillUndies(BOff));}
                    RepFiler1.CRLF;
                  end;
                end
                else
                  ReduceBreak(n);

                Inc(LineCount);

                Inc(RepRunCount);

                {Inc(Ln);}
              end
              else
              Begin

                {RepPrintLn(FillTULine(BOff));}
                PrintColUndies(LineCtrl^.FillUndies(BOff));

                RepPrintLn(FillTotal(n,BOn));

                {Ln:=Ln+2;}

              end;


            end; {If Break set}

          end; {Loop..}

        end; {If We are totaling..}


        FirstGo:=BOff;

        If (Not LastOne) then
        Begin
          For n:=1 to MaxNoSort Do Begin
            If (BreakList[n]<>0) then Begin
              { HM 10/02/98: Removed Summary filter }
              { HM 08/06/98: Extended filter to check for items printed in summary breaks }
              If (FindObj(BreakList[n])) and
                 ((Not SummOn) Or (SummOn And PrntBrkList[n])) and
                 (Not MadeGap) then Begin
                MadeGap:=BOn;

                Case RepField^.RepFieldRec^.RepDet.Break of
                  { HM 08/06/98: ON Breaks modified to not print a blank line }
                  2   :   ;

                  { Line Break }
                  3   :   Begin
                            RepPrintLn('')
                          end;

                  { Page Break }
                  4   :  If (Not NewPage) then {* Don't start a new page if we are at the beginning of one *}
                          Begin
                            RepFiler1.NewPage;
                          end;
                end; {Case..}

              end; {If..}

              If HedCtrl^.HasHed(n) Then Begin
                { Print Sub Heading }
                RepSetHeadingTabs;                 { Set tabs for sub-headings }
                HedCtrl^.FillColText(n);           { Calculate sub-heading values }
                PrintColText (HedCtrl^.ColText);   { print sub-headings }
                RepSetTabs;                        { set normal line tabs }
              End; { If }

              BreakList[n]:=0;
              PrntBrkList[n] := False;

              LineTotals(1,n); {* Reset that break level *}
            End; {If Set..}
          End; {Loop..}
        end; {If Forced last line *}

        TBreakFound:=0;
      end; {With LineCtrl..}
    end; {With RepCtrl..}
  end;{Proc..}

 *)

  Procedure RepCtrlObj.Process_Breaks(LastOne  :  Boolean);

  Var
    n         :       Byte;
    MadeGap   :       Boolean;

    function SumToCSV(ColT : ColTextPtrType) : AnsiString;
    var
      i : integer;
      s : string;
    begin
      Result := '';
      with ColT^ do
        If (NumCols > 0) Then
          For I := 1 To NumCols Do
          begin
            s := Cols[I].ColVal;
            //Need to remove tab char from start of string
            if (Length(s) > 0) then
              if (s[1] = #9) then
                Delete(s, 1, 1);
            Result := Result + s + ',';
          end;

      i := Length(Result);
      if i > 0 then
        if Result[i] = ',' then
          Delete(Result, i, 1);
    end;



  Begin

    MadeGap:=BOff;

    With RepCtrlRec^ do
    Begin


      With LineCtrl^ do
      Begin

{        if LastOne then
          Move(LastBreakList, BreakList, SizeOf(LastBreakList))
        else}
        begin
          Move(BreakList, LastBreakList, SizeOf(LastBreakList));
          LastTBreakFound := TBreakFound;
        end;


        If (SubTOn) {and (Not FirstGo)} then
        Begin

          For n:=MaxNoSort downto 1 do
          Begin

            If (BreakList[n]<>0) then
            Begin

              If (SummOn) then
              Begin

                If (IncInSumm(n)) then
                Begin
                  { Mark break as printed }
                  PrntBrkList[n] := True;

                  If (n<>NOTBreaks) then
                  Begin
                    {RepPrintLn(FillTULine(BOff));}

                    PrintColUndies(LineCtrl^.FillUndies(BOff));

                    {Inc(Ln);}
                  end;

                  {RepPrintLn(FillSummary(n,(n=NOTBreaks)));}
                  FillSummary(n,(n=NOTBreaks), RepDest = 2);
                  if RepDest <> 2 then
                    PrintColText (ColText)
                  else
                  if CSVTotals and CDFOn then
                    ExportCDF(SumToCSV(ColText));


                  If (n<>NOTBreaks) then Begin
                    { HM Aded 13/3/97: To put line under subtotal }
                    {PrintColUndies(LineCtrl^.FillUndies(BOff));}
                    RepFiler1.CRLF;
                  end;
                end
                else
                  ReduceBreak(n);

                Inc(LineCount);

                Inc(RepRunCount);

                {Inc(Ln);}
              end
              else
              Begin

                {RepPrintLn(FillTULine(BOff));}
                if RepDest = 2 then
                begin
                  if CSVTotals and CDFOn then
                    ExportCDF(LineCtrl^.FillCDFTotals(n, Bon));
                end
                else
                begin
                  PrintColUndies(LineCtrl^.FillUndies(BOff));

                  RepPrintLn(FillTotal(n,BOn));
                end;

                {Ln:=Ln+2;}

              end;


            end; {If Break set}

          end; {Loop..}

        end; {If We are totaling..}


        FirstGo:=BOff;

        If (Not LastOne) then
        Begin
          For n:=1 to MaxNoSort Do Begin
            If (BreakList[n]<>0) then Begin
              { HM 10/02/98: Removed Summary filter }
              { HM 08/06/98: Extended filter to check for items printed in summary breaks }
              If (FindObj(BreakList[n])) and
                 ((Not SummOn) Or (SummOn And PrntBrkList[n])) and
                 (Not MadeGap) then Begin
                MadeGap:=BOn;

                Case RepField^.RepFieldRec^.RepDet.Break of
                  { HM 08/06/98: ON Breaks modified to not print a blank line }
                  2   :   ;

                  { Line Break }
                  3   :   Begin
                            RepPrintLn('')
                          end;

                  { Page Break }
                  4   :  If (Not NewPage) then {* Don't start a new page if we are at the beginning of one *}
                          Begin
                            RepFiler1.NewPage;
                          end;
                end; {Case..}

              end; {If..}

              If HedCtrl^.HasHed(n) Then Begin
                { Print Sub Heading }
                RepSetHeadingTabs;                 { Set tabs for sub-headings }
                HedCtrl^.FillColText(n);           { Calculate sub-heading values }
                PrintColText (HedCtrl^.ColText);   { print sub-headings }
                RepSetTabs;                        { set normal line tabs }
              End; { If }

              BreakList[n]:=0;
              PrntBrkList[n] := False;

              LineTotals(1,n); {* Reset that break level *}
            End; {If Set..}
          End; {Loop..}
        end; {If Forced last line *}

        TBreakFound:=0;
      end; {With LineCtrl..}
    end; {With RepCtrl..}
  end;{Proc..}




  { ======================= Report End ======================= }

  Procedure RepCtrlObj.RepEnd;

  Var
    Selected  :  Boolean;

  Begin
    Selected:=BOff;

    With LineCtrl^ do
      If (SubTOn) Then Begin
        { blanks all the records }
        Reset_DataRecs;

        LineCtrl^.FillObject(Selected);

        If (LastTBreakFound<>0) then
          Process_Breaks(BOn);

        {RepPrintLn(FillTULine(BOff));}
        PrintColUndies(LineCtrl^.FillUndies(BOn));

        if RepCtrlRec^.RepDest <> 2 then
          RepPrintLn(FillTotal(0,BOff))
        else
        if RepCtrlRec^.CSVTotals and CDFOn then
          ExportCDF(FillCDFTotals(0,BOff));

        {RepPrintLn(FillTULine(BOn));}
        {PrintColUndies(LineCtrl^.FillUndies(BOn));}
      end;

    { Restore font to normal }
    With RepFiler1.Canvas.Font Do Begin
      Color := TColor(RepCtrlRec^.DefFont.fColor);
      Style := TFontStyles(RepCtrlRec^.DefFont.fStyle);
    End; { With }
    ICount := LineCount;
    PrintEndPage;

    {StdBot;}
  end;



  {* ------------------------ *}


  Procedure RepCtrlObj.Process_File;
  Const
    Fnum2     =  ReportF;
    Keypath2  =  RpK;
  Var
    Selected  :  Boolean;
    TSelect   :  Str100;
    FErr      :  Byte;
    RecNo,NumRecs : LongInt;
    progcount : integer;
  Begin
    FErr:=0;

    if CDFOn then
      RepCtrlRec^.RepDest := 2
    else
    if DBFOn then
      RepCtrlRec^.RepDest := 3;

    TSelect:='';

    KeyChk:=FullNomKey(9000);

    KeyS:=KeyChk;

    Status:=Find_Rec(B_GetGEq,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

    RecNo   := 1;
    NumRecs := Used_Recs(F[FNum2],FNum2);

    Try
      progcount := Trunc(100 * (RecNo / NumRecs));
    Except
      progcount := 1;
    End;

    {ShowStatus}UpdateProgress(progcount,'Printing Report','('+IntToStr(RecNo)+'/'+IntToStr(NumRecs)+').');

{$IFDEF DBF}
    WantNewDBF := True;
    if DBFOn then
      CreateDBFLists;
{$ENDIF}

    While (StatusOk) And
          (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff))  do
    With RepCtrlRec^ do Begin



      {Stppout(PrntOk);} {RW32}

      ThisScrt^.Get_Scratch(RepScr^);

      Selected:=BOff;

      {RepGenRecs^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);}
      GroupRepRec^.ReportHed.CurrBreak:=Ord(LineCtrl^.FirstGo);

      LineCtrl^.FillObject(Selected);

      {TSelect:=RepGenRecs^.ReportHed.RepSelect;}
      TSelect:=GroupRepRec^.ReportHed.RepSelect;

      KeepRep:=LineCtrl^.Evaluate_Expression(TSelect,FErr);

      If (LineCtrl^.SelErr) then {* Abort with warning *}
      Begin

        Warn_ValErr('H',TSelect);

        KeepRep:=BOff;

      end;

      { Check for new page }
      If (RepFiler1.LinesLeft < 8) Then
        RepFiler1.NewPage;

      If (KeepRep) then
        Case RepDest of

//          2  :  ExportCDF(LineCtrl^.FillCDFLine);  {* Output in CDF *}

          3  :  LineCtrl^.WriteDBFRecord;

          else  With LineCtrl^ do
                Begin


                  If (TBreakFound<>0) then
                    Process_Breaks(BOff);

                  {* Calculate any Totals *}

                  LineTotals(0,0);

                  NewPage:=BOff;

                  If (Not SummOn) Then Begin
                    {RepPrintLn(LineCtrl^.FillLine);}

                    if {RepDest = 2} CDFOn then
                    begin
                      ExportCDF(LineCtrl^.FillCDFLine);
                    end
                    else
                    begin

                      LineCtrl^.FillColText;
                      PrintColText (LineCtrl^.ColText);

                      Inc(LineCount);

                      Inc(RepRunCount);
                    end;
                  End; { If }

                end;

        end; {Case..}



      Status:=Find_Rec(B_GetNext,F[FNum2],FNum2,RecPtr[FNum2]^,KeyPath2,KeyS);

      Inc(RecNo);
      Try
        progcount := Trunc(100 * (RecNo / NumRecs));
      Except
        progcount := 1;
      End;

      {ShowStatus}UpdateProgress(progcount,'Printing Report','('+IntToStr(RecNo)+'/'+IntToStr(NumRecs)+').');
    end; {While..}

{    If (RepCtrlRec^.RepDest<>2) then
      RepEnd;}

    If not (RepCtrlRec^.RepDest in [{2,} 3]) then
      RepEnd;

{$IFDEF DBF}
    if DBFOn then
    begin
      FreeDBFLists;
    end;
{$ENDIF}

  end;{Proc..}


 {* ------------------------ *}


 Procedure RepCtrlObj.Process_Report;

 Var
   RecSelected  :  LongInt;


 Begin


   RecSelected:=0;

   SelectRecords(RecSelected);

   If (RecSelected>0) then
   Begin

     Process_File;

   end;

 end;


 {=============================================================================}

 { Loads any input into the report object }
 Function RepCtrlObj.GetReportInput : Boolean;
 Begin
   Result := Inherited GetReportInput;

   RepTitle := RepCtrlRec^.RepDesc;
   PageTitle := RepTitle;
 End;

 { Sets the tab positions for fields }
 Procedure RepCtrlObj.RepSetTabs;
 Var
   ColWidths : ColWidthsType;
   CStart    : Double;
   I         : SmallInt;
   CJust     : TPrintJustify;
 Begin
   With RepFiler1 Do Begin
     { go through the fields calculating the tab positions and justification }
     ColWidths := LineCtrl^.GetColWidths;

     If (ColWidths[0].Width > 0) Then Begin
       ClearTabs;

       CStart := MarginLeft;

       For I := 1 To ColWidths[0].Width Do Begin
         Case ColWidths[I].Just Of
           'C'      : CJust := pjCenter;
           'L'      : CJust := pjLeft;
           'R', 'B' : CJust := pjRight;
         Else
           CJust := pjLeft;
         End; { Case }

         SetTab (CStart, CJust, ColWidths[I].Width, 4, 0, 0);

         CStart := CStart + ColWidths[I].Width + RepCtrlRec^.ColSpace;
       End; { For }
     End; { If }
   End; { With }
 End;

 { Sets the tab positions for fields }
 Procedure RepCtrlObj.RepSetHeadingTabs;
 Var
   ColWidths : ColWidthsType;
   CStart    : Double;
   I         : SmallInt;
   CJust     : TPrintJustify;
 Begin
   With RepFiler1 Do Begin
     { go through the fields calculating the tab positions and justification }
     ColWidths := HedCtrl^.GetColWidths;

     If (ColWidths[0].Width > 0) Then Begin
       ClearTabs;

       CStart := MarginLeft;

       For I := 1 To ColWidths[0].Width Do Begin
         Case ColWidths[I].Just Of
           'C'      : CJust := pjCenter;
           'L'      : CJust := pjLeft;
           'R', 'B' : CJust := pjRight;
         Else
           CJust := pjLeft;
         End; { Case }

         SetTab (CStart, CJust, ColWidths[I].Width, 4, 0, 0);

         CStart := CStart + ColWidths[I].Width + RepCtrlRec^.ColSpace;
       End; { For }
     End; { If }
   End; { With }
 End;

 { Prints the Column headers }
 Procedure RepCtrlObj.RepPrintPageHeader;
 Begin
   With RepFiler1 Do Begin
     DefFont(0,[fsBold]);

     { Print the header line }
     SendText(LineCtrl^.FillHeader);

     { draw line under the titles }
     SetPen(clBlack, psSolid, -2, pmCopy);
     MoveTo(MarginLeft-1,YD2U(CursorYPos));
     LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
     MoveTo(MarginLeft-1,YD2U(CursorYPos));

     { Start next line }
     RepFiler1.CRLF;

     DefFont(0,[]);
   End; { With }
 End;

 { Called by the Thread Controller to generate and print the report }
 Procedure RepCtrlObj.Process;
 Var
   RecSelected  :  LongInt;
   KeyS2        :  Str255;
   PrnNotify    :  PrintNotifyPtr;
 Begin
{   if not FDetailsSet then
   begin
     InitInThread;
     FDetailsSet := True;
   end;}

   Inherited Process;

   { set up GroupRepRec }
   GroupRepRec^ := RepGen^;

   ShowStatus (0, RepCtrlRec^.RepDesc);

   { Create scratch file }
   If (RepCtrlRec^.RepType<>RepNomCode) then Begin
     ThisRepNo := CommandPool.OpenBit;
     CommandPool[ThisRepNo] := True;

     New(ThisScrt,Init(9000 + ThisRepNo));
   End; { If }


   { Generate Scratch file }
   RecSelected := 0;
   BuildTempData(RecSelected);

   { Print the report }
   Try
     RepFiler1.Execute;
   Except
     on E:Exception do
       UpdateProgress(0, 'Process - Error in Repfiler.Execute: ' +
                           E.Message);
   End;

   { update the last printed date }
   With MtExLocal^ Do Begin
     KeyS2 := FullRepKey_NDX (ReportGenCode, RepGroupCode, RepCtrlRec^.RepName);
     LStatus := LFind_Rec(B_GetEq, RepGenF, RGNdxK, KeyS2);

     If LStatusOk Then Begin
       With LRepGen^.ReportHed Do Begin
         LastRun := Today;
         LastOpo := EntryRec^.Login;
       End; { With }

       LStatus := LPut_Rec(RepGenF, RgNdxK);

{       New (PrnNotify);
       PrnNotify.RepName := LRepGen^.ReportHed.RepName;
       SendMessage (Application.MainForm.Handle, WM_UpdateTree, 0, LongInt(PrnNotify));}
     End; { If }
   End; { With }
 End;

 Procedure RepCtrlObj.BuildTempData(Var NoFound : LongInt);
 Begin
   SelectRecords (NoFound);
 End;

 Procedure RepCtrlObj.RepPrint(Sender  :  TObject);
 Begin
   Process_File;
 End;

 Procedure RepCtrlObj.PrintColText (Const ColText : ColTextPtrType);
 Var
   TabStr : ShortString;
   I, J   : SmallInt;
 Begin
   TmpColText := ColText;
   With RepFiler1, TmpColText^ Do Begin
     TabStr := '';

     If (NumCols > 0) Then
       For I := 1 To NumCols Do Begin
         { Set Font }
         Bold      := (fsBold In TFontStyles(Cols[I].FontStyle));
         Italic    := (fsItalic In TFontStyles(Cols[I].FontStyle));
         StrikeOut := (fsStrikeOut In TFontStyles(Cols[I].FontStyle));
         UnderLine := (fsUnderLine In TFontStyles(Cols[I].FontStyle));
         Canvas.Font.Color := TColor(Cols[I].FontColor);

         { Print Text }
         SendText (TabStr + Cols[I].ColVal);

         { need to keep a track of tabs, otherwise everything is put in the first tab }
         TabStr := TabStr + #9;

         { also take care any embedded tabs. i.e. Debit/Credit columns }
         If (Pos (#9, Copy(Cols[I].ColVal, 2, Length(Cols[I].ColVal) - 1)) > 0) Then
           TabStr := TabStr + #9;
       End; { For }

     { Start new line }
     CRLF;
   End; { With }
 End;

 Procedure RepCtrlObj.PrintColUndies (Const ColUndies : ColUndiesType);
 Const
   UndySet = ['-', '='];
 Var
   TabStr  : ShortString;
   I       : SmallInt;
   TabInfo : PTab;
 Begin
   With RepFiler1 Do Begin
     TabStr := '';

     For I := Low(ColUndies) To High(ColUndies) Do Begin
       If (ColUndies[I] = #0) Then Break;

       { need to keep a track of tabs, otherwise everything is put in the first tab }
       TabStr := TabStr + #9;

       { Check we need to draw an underline }
       If (ColUndies[I] In UndySet) Then Begin
         TabInfo := RepFiler1.GetTab (I + 1);

         If Assigned(TabInfo) Then Begin
           If (ColUndies[I] = '-') Then Begin
             SetPen(clBlack, psSolid, -1, pmCopy);

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             MoveTo(1, YD2U(CursorYPos));
           End { If }
           Else Begin
             SetPen(clBlack, psSolid, -2, pmCopy);

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-({YI2U}(LineHeight)/2));
             MoveTo(1, YD2U(CursorYPos));

             (*
             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-(YI2U(LineHeight) * 0.4));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-(YI2U(LineHeight) * 0.4));
             MoveTo(1, YD2U(CursorYPos));

             MoveTo(XI2U(TabInfo.Pos), YD2U(CursorYPos)-(YI2U(LineHeight) * 0.6));
             LineTo(XI2U(TabInfo.Pos + TabInfo.Width),YD2U(CursorYPos)-(YI2U(LineHeight) * 0.6));
             MoveTo(1, YD2U(CursorYPos));
             *)
           End; { Else }
         End; { If }
       End; { If }
     End; { For }

     CRLF;          { Put lines on a separate line }
   End; { With }
 End;

 Function RepCtrlObj.Start  :  Boolean;
 Var
   mbRet : Word;
   Status, Res : SmallInt;
   Params : PReportParamRec;
   i : integer;
   o1, o2 : SmallInt;
   AttMethod : Byte;
   FToolkit : IToolkit;
 Begin
   AttMethod := 0;
   InitInThread;
     Result:= FilesOK and GetReportInput;

     If (Result) then Begin
       RDevRec.feEmailSubj := Trim(RepGen^.ReportHed.RepDesc) + ' Report';
       RDevRec.feFaxMsg := RDevRec.feEmailSubj + #13#10;
       RDevRec.fePrintMethod := 2; //email

  {     If ((Not CDFOn) And SelectPrinter(RDevRec)) Or
          (CDFOn And SelectCDFFile(RepCtrlRec^.LastPath)) Then} Begin

                     {RepCtrlRec :  ^ReportHedType;
                     RepGen     :  ^RepGenRec;}

       {   Moved to create}
  (*       If (Not Assigned(RepExLocal)) and (Result) then { Open up files here }
         begin
           RepExLocal.LSetDrive := DataPath;
           Result:=Create_ReportFiles;
         end; *)

         If (Result) then
         begin
           MTExLocal:=RepExLocal;

           CoInitialize(nil);
           FToolkit := CreateToolkitWithBackDoor;
//           FToolkit := CreateOLEObject('Enterprise01.Toolkit') as IToolkit;
          if Assigned(FToolkit) then
          Try
            if FToolkit.Status = tkOpen then
              FToolkit.CloseToolkit;

            FToolkit.Configuration.DataDirectory := MTExLocal^.LSetDrive;
            Res := FToolkit.OpenToolkit;

            if Res = 0 then
            begin
              with TElertWorkStationSetup.Create do
              Try
                Try
                  if OutputFormat = 0 then
                    AttMethod := Byte(FToolkit.SystemSetup.ssPaperless.ssAttachMethod)
                  else
                  Case OutputFormat of
                    1 : AttMethod := 0;
                    2 : AttMethod := 2;
                  end;
                Except
                  AttMethod := 0;
                End;
              Finally
                Free;
              End;


              with FToolkit do
                CurrPeriod := IntToStr(SystemSetup.ssCurrentYear + 1900) + IntToStr(SystemSetup.ssCurrentPeriod);
              FToolkit.CloseToolkit;
            end
            else
              AttMethod := 0;
          Finally
            FToolkit := nil;
            CoUninitialize;
          End
          else
            AttMethod := 0;

           with MTExLocal^ do
           begin
             //need to set RDevRec.feEmailAttType here and save it in Sentinel
             Open_System(ElertF, LineF);
             KeyS := LJVar(UserID, 10) + LJVar(ElertName, 30);
             Status := LFind_Rec(B_GetEq, ElertF, 0, KeyS);

             if Status = 0 then
               Status := Lock;

             if Status = 0 then
             begin
               LElertRec.elWorkStation := WorkStationName;
               LPut_Rec(ElertF, 0);
               Status := Lock;
             end;


             Result := Status = 0;

             if Result then //load params
             begin
               Case MTExLocal^.LElertRec.elExRepFormat of
                 2 : begin //html
                       AttMethod := 3;
                       RDevRec.fePrintMethod := 7;
                     end;
                 3 : begin //excel
                       AttMethod := 4;
                       RDevRec.fePrintMethod := 5;
                     end;
                 end; //case
               MTExLocal^.LElertRec.elRpAttachMethod := AttMethod;
               RDevRec.feEmailAtType := AttMethod;
               CDFOn:={RepCtrlRec^.RepDest=2);}MTExLocal^.LElertRec.elActions.eaCSV
                                           and Not (AttMethod in [3,4]);
               if CDFOn and MTExLocal^.LElertRec.elDBF then
               begin
                 DBFOn := True;
                 CDFOn := False;
               end;
               KeyS := pxElOutput + LJVar(UserID, 10) + LJVar(ElertName, 30) + #0#0 + otParams;

               Status := LFind_Rec(B_GetGEq, LineF, ellIdxOutputType, KeyS);

               while (Status = 0) and
               (LElertLineRec.Prefix = pxElOutput) and
               (Trim(LElertLineRec.Output.eoElertName) = Trim(ElertName)) and
               (Trim(LElertLineRec.Output.eoUserID) = Trim(UserID)) and
               (LElertLineRec.Output.eoOutputType = otParams) do
               begin
  {Replace parameter with ones from sentinel.  If param is 'Today' or 'Current Period' then
  we increment the parameter by offset before running the report, else we increment it
  after running the report}
                 New(Params);
                 FillChar(Params^, SizeOf(TReportParamRec), #0);
                 Params^.ParamType := LElertLineRec.Output.eoEntParamType;
                 if not IsToday(LElertLineRec.Output.eoLine1, LElertLineRec.Output.eoEntParamType) then
                   o1 := 0
                 else
                   o1 := LElertLineRec.Output.eoOffStart;

                 if not IsToday(LElertLineRec.Output.eoLine2, LElertLineRec.Output.eoEntParamType) then
                   o2 := 0
                 else
                   o2 := LElertLineRec.Output.eoOffEnd;

                 Params^.Params[1] := ParamVal(LElertLineRec.Output.eoLine1,
                                       LElertLineRec.Output.eoEntParamType,
                                       o1);
                 Params^.Params[2] := ParamVal(LElertLineRec.Output.eoLine2,
                                       LElertLineRec.Output.eoEntParamType,
                                       o2);

                 OldRangeStart := LElertRec.elRangeStart;
                 OldRangeEnd := LElertRec.elRangeEnd;

                     //put first parameter into range rec
                  if ParamList.Count = 0 then
                     begin
                       LElertRec.elRangeStart.egString := Params^.Params[1];
                       LElertRec.elRangeStart.egType := TElertRangeValType(LElertLineRec.Output.eoEntParamType);
                       LElertRec.elRangeEnd.egString := Params^.Params[2];
                       LElertRec.elRangeStart.egInput := True;
                       LElertRec.elRangeEnd.egInput := True;
                     end;


                 if LElertLineRec.Output.eoEntParamType in [1, 2] then
                 begin
                   if not IsToday(LElertLineRec.Output.eoLine1, LElertLineRec.Output.eoEntParamType) then
                     LElertLineRec.Output.eoLine1 :=
                                       ParamVal(LElertLineRec.Output.eoLine1,
                                       LElertLineRec.Output.eoEntParamType,
                                       LElertLineRec.Output.eoOffStart);
                   if not IsToday(LElertLineRec.Output.eoLine2, LElertLineRec.Output.eoEntParamType) then
                     LElertLineRec.Output.eoLine2 := ParamVal(LElertLineRec.Output.eoLine2,
                                       LElertLineRec.Output.eoEntParamType,
                                       LElertLineRec.Output.eoOffEnd);
                   LPut_Rec(LineF, ellIdxOutputType);
                 end;

                 ParamList.Add(Params);
                 Status := LFind_Rec(B_GetNext, LineF, ellIdxOutputType, KeyS);
               end;

               if ParamList.Count > 0 then
               begin
                 with LineCtrl^.InpObj^ do
                 begin
                   i := 0;
                   CurrNode := GetFirst;

                   while (i < ParamList.Count) and (CurrNode <> nil) do
                   begin

                     LineCtrl^.RepField := CurrNode^.LItem;

                     Params := PReportParamRec(ParamList[i]);
                     SetParameter(LineCtrl^.RepField^.RepfieldRec^.RepDet, Params^);


                     inc(i);
                     CurrNode := GetNext(CurrNode);
                   end; //while
                 end; //with
               end; //if count > 0
             end;
           end;
         end;
  //       Result := FilesOk;

         { Set The Font }
         CopyFont (RFont, RepCtrlRec^.DefFont, False);

         If (Result) then Begin
           { Initialise printer settings }
           If (RepCtrlRec^.PaprOrient = 'L') Then
             ROrient := RpDefine.poLandScape
           Else
             ROrient := RpDefine.poPortrait;

           InitRep1;

           RepFiler1.LineHeightMethod := lhmFont;
         End; { If }

  {       If (CDFOn) Then
           Open_Def(RepCtrlRec^.LastPath,CDFOn);}
         If (CDFOn) Then
         begin
           CSVFName := LGetTempFNameExt('!CSV', '.tmp', MTExLocal^.LSetDrive);
 {          if (AttMethod = 0) then}
             Open_Def(CSVFName, CDFOn)
{           else
             CDFOn := False;}
         end
         else
         if DBFOn then
         begin
           CSVFName := LGetTempFNameExt('!DBF', '.dbf', MTExLocal^.LSetDrive);
           CSVFName := ExtractFilePath(CSVFName) + MTExLocal^.LElertRec.elCSVFileName;
           {$IFDEF DBF}
           StartDBF(CSVFName);
           {$ENDIF}
         end
         else
         if AttMethod = 3 then
           CSVFName := LGetTempFNameExt('!HTM', '.tmp', MTExLocal^.LSetDrive)
         else
         if AttMethod = 4 then
           CSVFName := LGetTempFNameExt('!XLS', '.tmp', MTExLocal^.LSetDrive)
       End { If }
     End; { If }
 end;

{ need to keep declaration in sync with rwValErrorEvent }
Procedure RepCtrlObj.Warn_ValErr(RVNo    :  Str10;
                                 ValLine :  Str100);
  Var
    ErrStr    :  Str255;
    mbRet     :  Word;
    ThStr     :  Str255;
    ClientIdR :  ClientIdType;
  Begin
    ThStr:='';
    ErrStr:=RepCtrlRec^.RepDesc + #10#13 +
            'The Report Global Selection is incorrect.' + #10#13 +
            'Field '+RVNo+' is incorrect.';

    With MtExLocal^ do
      If (Assigned(LThShowMsg)) then Begin
        If (Assigned(ExClientId)) then
          ThStr:=#13+'In thread '+Form_Int(ThreadRec^.THIdNo{ExClientId.TaskId},0);

        LThShowMsg(nil,2,ErrStr+ThStr);
      End
      Else
        MessageDlg (ErrStr, mtError, [mbOk], 0);
end;


Procedure RepCtrlObj.RepPrintHeader(Sender  :  TObject);
Var
  LocalNode          : NodePtr;
  InpField           : RepFieldPtr;

  Function InpData (Const RD : ReportDetailType) : String;
  Begin { InpData }
    With RD Do
      Case RepLIType Of
      { Date }
      1  : Result := POutDateB(DRange[1]) + #9 + POutDateB(DRange[2]);

      { Period }
      2  : Result := PPR_OutPr(PrRange[1,1], PrRange[1,2]) + #9 + PPR_OutPr(PrRange[2,1], PrRange[2,2]);

      { Value }
      3  : Result := SysUtils.Format('%0.2f', [VRange[1]]) + #9 + SysUtils.Format('%0.2f', [VRange[2]]);

      { Currency }
      5  : Result := SSymb (CrRange[1]) + #9 + SSymb (CrRange[2]);

      4,         { ASCII }
      6,         { Document No. }
      7,         { Customer Code }
      8,         { Supplier Code }
      9,         { Nominal Code }
      10,        { Stock Code }
      11,        { Cost Centre Code }
      12,        { Department Code }
      13,        { Location Code }
      17 : Begin { Job Code }
             Result := ASCStr[1] + #9 + ASCStr[2];
           End;
    Else
      Result := 'Unknown Data';
    End; { Case }
  End; { InpData }

  Procedure FaxCoverPage;
  Var
    oNewPage, oPrnHead : TNotifyEvent;
    Memo               : TMemoBuf;
  Begin { FaxCoverPage }
    With RepFiler1 Do Begin
      DefFont (16, [fsBold]);
      YPos := PageHeight * 0.24;
      PrintCenter ('FAX TRANSMISSION', (PageWidth - MarginLeft) / 2);
      CRLF;
      CRLF;
      DefFont (10, [fsBold]);
      PrintCenter (Trim(PageTitle) + ' Report', (PageWidth - MarginLeft) / 2);
      CRLF;
      CRLF;

      DefFont (4, [fsBold]);
      ClearTabs;
      SetTab (15, pjRight, 30, 4, 0, 0);   { Description }
      SetTab (55, pjLeft, 150, 4, 0, 0);   { Data }

      PrintLn (#9 + 'F.A.O.:' + #9 + RDevRec.feFaxTo);
      CRLF;
      PrintLn (#9 + 'Fax No.:' + #9 + RDevRec.feFaxToNo);
      CRLF;
      PrintLn (#9 + 'FROM:' + #9 + RDevRec.feFaxFrom + ' (' + Trim(Syss.UserName) + ')');
      CRLF;
      PrintLn (#9 + 'DATE:' + #9 + FormatDateTime ('dddd dd mmm yyyy', Now));
      CRLF;
      CRLF;

      ClearTabs;
      SetTab (20, pjLeft, 170, 4, 0, 0);
      PrintLn (#9 + 'Number of pages including this one:-  ' + Macro (midTotalPages));

      DefFont (4, []);
      CRLF;
      PrintLn (#9 + 'If this or any of the following pages are missing or unreadable please call: ' + Syss.DetailTel);

      DefFont (4, [fsBold, fsUnderline]);
      CRLF;
      PrintLn (#9 + 'Message');

      If (Trim(RDevRec.feFaxMsg) <> '') Then Begin
        DefFont (3, []);
        CRLF;

        Memo := TMemoBuf.Create;
        Try
          Memo.Text := Trim(RDevRec.feFaxMsg);
          Memo.PrintStart := 30;
          Memo.PrintEnd   := PageWidth - 30;
          PrintMemo(Memo, 0, False);
        Finally
          Memo.Free;
        End;
      End; { If (Trim(RDevRec.feFaxMsg) <> '') }

      { Start New Page }
      oNewPage := OnNewPage;
      OnNewPage := Nil;
      oPrnHead := OnPrintHeader;
      OnPrintHeader := Nil;
      NewPage;
      OnNewPage     := oNewPage;
      OnPrintHeader := oPrnHead;
    End; { With RepFiler1 }
  End; { FaxCoverPage }

  Procedure InpDataPage;
  Begin { InpDataPage }
    With RepFiler1 Do Begin
      { Company Name / Date-Time }
      PrintHedTit;

      { Report Name / User }
      PrintStdPage;

      { Print Line }
      //RepPrintPageHeader;
      SetPen(clBlack, psSolid, -2, pmCopy);
      MoveTo(MarginLeft-1,YD2U(CursorYPos));
      LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
      MoveTo(MarginLeft-1,YD2U(CursorYPos));

      { Start next line }
      CRLF;

      { Define Tabs for info section }
      ClearTabs;
      SetTab (MarginLeft, pjLeft, 25, 4, 0, 0);
      SetTab (NA,         pjLeft, 90, 4, 0, 0); {   Description }
      DefFont (0, [fsBold]);
      CRLF;
      PrintLn ('General Information');
      DefFont (0, []);
      With RepCtrlRec^ Do Begin
        PrintLn (#9'F6 Period' + #9 + Format('%2.2d/%4.4d', [Syss.CPr, 1900 + Syss.CYr]));
        PrintLn (#9'Last Printed' + #9 + POutDateB(LastRun) + ' by ' + LastOpo);
        Print   (#9'Test Mode' + #9);
        If TestMode Then
          PrintLn (Format('On (Refresh Start: %s, Refresh End: %s, Count: %d)',
                          [YesNoBo(RefreshPos), YesNoBo(RefreshEnd), SampleNo]))
        Else
          PrintLn ('Off');
      End; { With RepCtrlRec^ }

      { Define Tabs for info section }
      ClearTabs;                                 { Title }
      SetTab (MarginLeft, pjLeft, 12, 4, 0, 0); {   Field No }
      SetTab (NA,         pjLeft, 35, 4, 0, 0); {   Description }
      SetTab (NA,         pjLeft, 30, 4, 0, 0); {   Data Type }
      SetTab (NA,         pjLeft, 50, 4, 0, 0); {   Value 1 }
      SetTab (NA,         pjLeft, 50, 4, 0, 0); {   Value 2 }

      DefFont (0, [fsBold]);
      CRLF;
      PrintLn ('Input Fields');
      DefFont (0, [fsUnderLine]);
      PrintLn (#9 +
               '' + #9 +
               'Description' + #9 +
               'DataType' + #9 +
               'Value1' + #9 +
               'Value2');
      DefFont (0, []);

      If Assigned(LineCtrl) Then
        With LineCtrl^ Do
          If Assigned (InpObj) Then Begin
            LocalNode := InpObj^.GetFirst;
            If Assigned(LocalNode) Then
              While Assigned(LocalNode) Do Begin
                InpField := LocalNode^.LITem;

                With InpField^.RepfieldRec^, RepDet Do
                  PrintLn (#9 + 'I' + IntToStr(RepVarNo) +
                           #9 + RepLDesc +
                           #9 + RepInpTypesL^[RepLIType] +
                           #9 + InpData(RepDet));

                LocalNode := InpObj^.GetNext(LocalNode);
              End { While Assigned(LocalNode) }
            Else
              PrintLn (#9'No Input Fields Defined');
          End; { If Assigned (InpObj)  }

      { Footer }
      CRLF;
      SetPen(clBlack, psSolid, -2, pmCopy);
      MoveTo(MarginLeft-1,YD2U(CursorYPos));
      LineTo((PageWidth+1-MarginRight),YD2U(CursorYPos));
      MoveTo(MarginLeft-1,YD2U(CursorYPos));

      { Start New Page }
      RepSetTabs;
      NewPage;
    End; { With RepFiler1 }
  End; { InpDataPage }

Begin { RepPrintHeader }
  With RepFiler1 Do Begin
    If (CurrentPage=1) Then Begin
      { Check to see if fax cover page wanted }
      If (RDevRec.fePrintMethod = 1) And (RDevRec.feCoverSheet = 'AAAAAAAA') Then Begin
        { Print Fax Cover Page }
        FaxCoverPage;

        If RepCtrlRec^.PrnInpData Then
          InpDataPage
        Else
          RepSetTabs;
      End { If }
      Else Begin
        { Not Faxing - normal operation }
        If RepCtrlRec^.PrnInpData Then
          InpDataPage
        Else
          Inherited;
      End; { Else }
    End { If }
    Else
      Inherited;
  End; { With }
End; { RepPrintHeader }

procedure RepCtrlObj.SetDbfCmdLine;
var
  KeyS1 : Str255;
  TmpLck : Boolean;
  i : integer;
begin
  DbfCmdLine := '';
  With MTExLocal^ Do Begin
    if DBFOn then
    begin
      KeyS1 := FullRepKey_RGK(ReportGenCode, RepCommandType, RepCtrlRec^.ReportKey);
      if LFind_Rec(B_GetEq, RepGenF, RGK, KeyS1) = 0 then
      begin
        DbfCmdLine := Trim(LRepGen^.RCommand.Command);
      end;
    end;
  end;
end;

procedure RepCtrlObj.ExpandDbfCmdLine;
var
  i : integer;
begin
  i := Pos('%1', DbfCmdLine);
  if i > 0 then
  begin
    Delete(DbfCmdLine, i, 2);
    Insert(RepCtrlRec^.LastPath, DbfCmdLine, i);
  end;
end;

function ConvertEDFToHTML (Const EDFPath, HTMLPath : ShortString) : Integer;
Var
  _enRender             : THandle;
  _enrConvertEDFToHTML  : Function (Const EDFPath : ShortString; Const HTMLPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  HTMLFile              : ANSIString;
Begin // ConvertEDFToHTML
  Result := 0;
  // Check for enRender.Dll utility library
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') Then
  Begin
    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    If (_enRender > HInstance_Error) Then
    Begin
      // Try to get a handle to the enrConvertEDFToHTML function
      _enrConvertEDFToHTML := GetProcAddress(_enRender, 'enrConvertEDFToHTML');

      // Check return value for success
      If Assigned(_enrConvertEDFToHTML) Then
      Begin
        // Call enrConvertEDFToHTML to convert the EDF File to HTML/CSS files
        FuncRes := _enrConvertEDFToHTML(EdfPath, HTMLPath);

        If (FuncRes = 0) And FileExists(HTMLPath) Then
        Begin
        End // If (FuncRes = 0)
        Else
          Result := 30004;
      End // If Assigned(_enrConvertEDFToExcel)
      Else
        // Error getting function handle
        Result := 30003;

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    End // If (_enRender > HInstance_Error)
    Else
      // Error loading enRender.DLL
      Result := 30002;
  End // If FileExists (...
  Else
    // enRender.Dll missing
    Result := 30001;
End; // ConvertEDFToHTML

function ConvertEDFToXLS (Const EDFPath, XLSPath : ShortString) : Integer;
Var
  _enRender             : THandle;
  _enrConvertEDFToExcel : Function (Const EDFPath : ShortString; Const XLSPath : ShortString) : Longint; StdCall;
  FuncRes               : LongInt;
  XLSFile               : ANSIString;
Begin // ConvertEDFToXLS
  Result := 0;
  // Check for enRender.Dll utility library
  If FileExists (ExtractFilePath(Application.ExeName) + 'ENRENDER.DLL') Then
  Begin
    // dynamically load DLL and use enrConvertEDFToExcel function to convert the EDF format file
    _enRender := LoadLibrary('ENRENDER.DLL');

    // Check return value for success
    If (_enRender > HInstance_Error) Then
    Begin
      // Try to get a handle to the enrConvertEDFToExcel function
      _enrConvertEDFToExcel := GetProcAddress(_enRender, 'enrConvertEDFToExcel');

      // Check return value for success
      If Assigned(_enrConvertEDFToExcel) Then
      Begin
        // Call enrConvertEDFToExcel to convert the EDF File to an XLS worksheet
        FuncRes := _enrConvertEDFToExcel(EdfPath, XLSPath);

        If (FuncRes = 0) And FileExists(XLSPath) Then
        Begin
        End // If (FuncRes = 0)
        Else
          Result := 30004;
      End // If Assigned(_enrConvertEDFToExcel)
      Else
        // Error getting function handle
        Result := 30003;

      // Unload enRender.DLL
      FreeLibrary(_enRender);
    End // If (_enRender > HInstance_Error)
    Else
      // Error loading enRender.DLL
      Result := 30002;
  End // If FileExists (...
  Else
    // enRender.Dll missing
    Result := 30001;
End; // ConvertEDFToXLS




procedure RepCtrlObj.Finish;
var
  ELObj : TElertObject;
  tmpRec : TElertRec;
  iLockPosition : longint;
begin
 with MTExLocal^, LElertRec do
 begin
   ElObj := TElertObject.CreateNoFile;
   Try
     begin
       inc(elTriggered);
       if elActions.eaCSV then
       begin
         elStatus := 0;
         if elCSVToFolder then elStatus := elStatus or 1;
         if elCSVByFTP then elStatus := elStatus or 2;
         if elCSVByEmail then elStatus := elStatus or 4;
         elStatus := Ord(Pred(esCopyReadyToGo)) + elStatus;
       end
       else
       if elActions.eaRepEmail and elActions.eaRepFax then
         elStatus := Ord(esReportBothReadyToGo)
       else
       if elActions.eaRepEmail then
         elStatus := Ord(esReportEmailReadyToGo)
       else
       if elActions.eaRepFax then
         elStatus := Ord(esFaxReadyToGo)
       else
         elStatus := Ord(esIdle); //shouldn't happen

       if elActions.eaCSV then
       begin
         elRepFile := ExtractFileName(CSVFName);
         if elExRepFormat = 2 then
           ConvertEDFToHTML(RepFiler1.FileName, ExtractFilePath(RepFiler1.FileName) + elRepFile)
         else
         if elExRepFormat = 3 then
           ConvertEDFToXLS(RepFiler1.FileName, ExtractFilePath(RepFiler1.FileName) + elRepFile);
         if FileExists(RepFiler1.FileName) then
           DeleteFile(RepFiler1.FileName);
       end
       else
         elRepFile := ExtractFileName(RepFiler1.FileName);
     end;
     elLastDateRun := Now;
     ElObj.SetDataPointer(@LElertRec);
     elNextRunDue := ElObj.GetNextRunDue(True);
   Finally
     elWorkStation := BlankWorkstation;
     ResetQueryTick(LElertRec);
     iResult := LPut_Rec(ElertF, 0);
    if iResult = 80 then
    begin
      //Keep our record safe
      tmpRec := LElertRec;

      //Re-read record from database
      iResult := LGetPos (ElertF, iLockPosition);
      if (iResult = 0) then
      begin
        SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
        iResult := LGetDirect(ElertF, 0, 0);

        if iResult = 0 then
        begin
          //Restore our record and save.
          LElertRec := tmpRec;
          iResult := LPut_Rec(ElertF, 0);
        end;
      end;
    end;
     ElObj.Free;
     inherited Finish;
   End;
 end;

end;

function RepCtrlObj.Lock : SmallInt;
Var
//  SaveInfo : TElertFileSavePos;
  lRes     : LongInt;
begin
  With MTExLocal^ Do Begin
    // Save position in global file
  //  SaveMainPos(SaveInfo);

    // Save Record Position into LockPos so we can later use it for unlocking
    Result := LGetPos (ElertF, FLockPosition);
    If (Result = 0) Then Begin
      // Copy locked record position into data record
     SetDataRecOfsPtr (ElertF, FLockPosition, LRecPtr[ElertF]^);
      // Reread and lock record
   //   Result := LGetDirect(F[ElertF], ElertF, RecPtr[ElertF]^, 0, B_SingLock + B_SingNWLock);
      Result := LGetDirect(ElertF, 0, B_SingLock + B_SingNWLock);
      If (Result = 0) Then
        // Record Locked
        Inc (FLockCount);
    End { If (Result = 0) };

    // restore position in global file
   // RestoreMainPos(SaveInfo);
  End; { With FBtrIntf^ }
end;

function RepCtrlObj.UnLock : SmallInt;
begin
  Result := 0;
  If (FLockCount > 0) Then Begin
    // Copy locked record position into data record
    SetDataRecOfsPtr(ElertF, FLockPosition, MTExLocal^.LRecPtr[ElertF]^);

    // Unlock Record
    FillChar (KeyS, Sizeof(KeyS), #0);
    Result := MTExLocal^.LFind_Rec(B_Unlock, ElertF, 0, KeyS);
    If (Result <> 0) Then Inc (Result, 30000);

    Dec(FLockCount);
  End; { If (FLockCount > 0) }
end;

procedure RepCtrlObj.SetParameter(var Rep : ReportDetailType;
                                      Par : TReportParamRec);
var
  P1, P2 : Word;
  S : Str10;
begin
  Case Rep.RepLIType of
      1   :  begin {date}
               Rep.DRange[1] := Par.Params[1];
               Rep.DRange[2] := Par.Params[2];
             end;
      2   :  begin {period}
               s := Par.Params[1];
//               PeriodStr(s, p1, p2);
               SplitPeriod(s, p1, p2);
               Rep.PrRange[1, 1] := P1;
               Rep.PrRange[1, 2] := P2{ - 1900};

               s := Par.Params[2];
//               PeriodStr(s, p1, p2);
               SplitPeriod(s, p1, p2);
               Rep.PrRange[2, 1] := P1;
               Rep.PrRange[2, 2] := P2{ - 1900};
             end;
      3    : begin {value}
               Try
                 Rep.VRange[1] := StrToFloat(Par.Params[1]);
                 Rep.VRange[2] := StrToFloat(Par.Params[2]);
               Except;
               End; {leave as default}
             end;
      5    : begin
               Try
                 Rep.CrRange[1] := StrToInt(Par.Params[1]);
                 Rep.CrRange[2] := StrToInt(Par.Params[2]);
               Except;
               End; {leave as default}
             end;

      4,         { ASCII }
      6,         { Document No. }
      7,         { Customer Code }
      8,         { Supplier Code }
      9,         { Nominal Code }
      10,        { Stock Code }
      11,        { Cost Centre Code }
      12,        { Department Code }
      13,        { Location Code }
      17 : Begin { Job Code }
            Rep.ASCStr[1] := Par.Params[1];
            Rep.AscStr[2] := Par.Params[2];
           end;
  end;
end;






Procedure RepCtrlObj.RepBeforePrint(Sender  :  TObject);
var
  DPath : String;
Begin

    Begin
      RepFiler1.Title:=Application.Title+'. '+RepTitle;
      {RepFiler1.FileName:=GetTempFName('!REP');}

      DPath := MTExLocal^.LSetDrive;

{      if MTExLocal^.LElertRec.elActions.eaCSV then
        RepFiler1.FileName := CSVFName
      else}
      begin
        { HM 09/05/00: Applied mods for fax/emailing }
        If (RDevRec.fePrintMethod = 1) Or ((RDevRec.fePrintMethod = 2) And (RDevRec.feEmailAtType = 0)) Then
          { Fax or Email with RPPro attachments }
          RepFiler1.FileName := LGetTempFNameExt('!SRP', '.EDF', DPath)
        Else
          { Printing or Email with PDF Attachments }
         RepFiler1.FileName := LGetTempFNameExt('!SRP', '.EDF', DPath);
      end;
    end;

end;

procedure RepCtrlObj.InitInThread;
var
  RepCRec : RepGenRec;
  FoundCode : String;
begin
  SetQuery_OKToClose(False);
  FStarted := True;

    //PR 24/01/03 Need to set SetDrive before calling GetReport as that's where global
    //data files are opened.
    ReportDataPath := FxInfo.xDataPath;
    SetDrive := ReportDataPath;

    if GetReport (FxInfo.xRepName, FoundCode) Then
    begin
      RepCRec := RepGenRecs^;
      { Create thread files }
      FilesOk := False;
      If Not Assigned(RepExLocal) then { Open up files here }
        FilesOk:=Create_ReportFiles
      Else
        FilesOk := True;

      If FilesOk then
      begin
        MTExLocal:=RepExLocal;

      { Stop it drawing the line under the titles - cos it gets it in the wrong place }
        RNoPageLine:=Bon;

        New(RepCtrlRec);
        RepCtrlRec^:=RepCRec.ReportHed;

        New(RepGen);
        RepGen^:=RepCRec;

        New(LineCtrl,Init(RepCtrlRec^.RepName, MtExLocal));
        LineCtrl^.OnValErr := Warn_ValErr;

        New(HedCtrl,Init(RepCtrlRec^.RepName));

        (* Moved to ?
        If (RepCtrlRec^.RepType<>RepNomCode) then
          New(ThisScrt,Init(9000, MtExLocal));
        *)
        ThisScrt := Nil;

        Fnum:=FileTxlate(RepCtrlRec^.DriveFile,Keypath);
        LineCtrl.RepDrive := Fnum;
        LineCtrl.OrigFile := RepCtrlRec^.DriveFile;
        HedCtrl.RepDrive  := Fnum;
        HedCtrl.OrigFile := RepCtrlRec^.DriveFile;

        ResetVar;
        TestMode:=RepCtrlRec^.TestMode;

        SampleNo:=RepCtrlRec^.SampleNo;

        LineCtrl^.RunNomCtrl:=(RepCtrlRec^.RepType=RepNomCode);

        LineCtrl^.InitRepFObj(RepGenF,RGK, MtExLocal);

        HedCtrl^.InitHedFObj(RepGenF,RGK, MtExLocal);

        MTExLocal^.LElertRec.elFTPTries := 0;
        MTExLocal^.LElertRec.elFTPRetriesNotified := False;

    //    CDFOn:={RepCtrlRec^.RepDest=2);}MTExLocal^.LElertRec.elActions.eaCSV;

        {If (CDFOn) then
          Open_Def(RepCRec.LastPath,CDFOn);}

        POnStr:='';
        POffStr:='';

      end; //if filesOK
    end;
end;




procedure RepCtrlObj.UpdateProgress(Max: Integer; s1, s2, s3,
  s4: ShortString);
begin
  if Assigned(OnDoProgress) then
    OnDoProgress(Max, s1, s2, s3, s4);
end;

Initialization
  CommandPool := TBits.Create;
Finalization
  CommandPool.Free;
end. 