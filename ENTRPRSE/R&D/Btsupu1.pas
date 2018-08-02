unit BTSupU1;


interface

{$I DEFOVR.Inc}

Uses
  Windows,
  Messages,
  Graphics,
  GlobVar,
  VarConst,
  BtrvU2,
  VarRec2U,
  CustomFieldsVar;



Const
  WM_CustGetRec    =  WM_User+$1;
  WM_FormCloseMsg  =  WM_User+$2;
  {WM_CallViaComp  =  WM_User + $3; In TeditVal}
  WM_ChangeComp    =  WM_User+$4;
  {WM_FormStateMsg =  WM_User + $5; NF: Used in faxing for restoring a window}
  WM_SBSFDMsg      =  WM_User+$100;
  WM_ThreadPrintP  =  WM_User+$101;  {* This has been deliberately set to WM_PrintProgress to avoid having to include GlobTypes *}
  {WM_PrintProgress = WM_USER + $101;   In GlobType.Pas/RwMain.Pas }
  {WM_PrintAbort    = WM_USER + $102;                              }
  {WM_InPrint       = WM_USER + $103;                              }
  WM_PrintRep      =  WM_User+$200;   { Used in Report Writer and Print Preview }
  WM_ExportRep     =  WM_User+$201;   { Used in Report Writer }
  WM_UpdateTree    =  WM_User+$202;   { Used in Report Writer }

  // CA  04/06/2012   v7.0  ABSEXCH-12302:    Startup Upgrade Info Window
  WM_UpgradeForm   =  WM_User+$203;   { Used for Startup Upgrade Info Window EH 45 }

  // MH 10/09/2014 Order Payments: Message used to get SaleTx2U to refresh the buttons after a payment or refund is made
  WM_RefreshButtons = WM_USER + $204;

  // CJS 2014-11-05 - T067 - UK VAT Return Wizard
  WM_THREADFINISHED    = WM_USER + $205;
  WM_CONTINUEVATRETURN = WM_USER + $206;
  WM_CANCELVATRETURN   = WM_USER + $207;

  WM_LOCKEDPROCESSFINISHED = WM_USER + $208;

  //RB 26/12/2017 2018-R1 ABSEXCH-19586: User permission implementation related to Anonymisation Control Centre window 
  WM_AnonControlCentreMsg = WM_USER + $209;

  // MH 08/01/2018 2017-R1 ABSEXCH-19316: Changed display mechanism for SQL Posting Prompt Dialog
  WM_ShowSQLPostingPrompt = WM_USER + $210;

  // MH 23/02/2018 2018-R2 ABSEXCH-19172: Added support for exporting lists
  // WM_USER + $211 used for WM_ReevaluateListExportStatus in ExportLists\WindowExport.pas




  // Process IDs, to be passed as WParam of WM_CONTINUEVATRETURN and
  // WM_THREADFINISHED messages
  PID_POSTING          = $1;
  PID_VATSUBMISSION    = $2;
  PID_POSTING_AFTER_REVAL
                       = $3;  //PR: 13/05/2016 ABSEXCH-17450

  // CJS 2016-05-23 - ABSEXCH-17491 - Check All Accounts fails at end of Total Unpost
  PID_TOTAL_UNPOST_FINISHED = $4;

  // CJS 2016-07-01 - ABSEXCH-17383 - eRCT
  PID_BACS_SCAN_FINISHED = $5;
  PID_BATCH_PAYMENTS_FINISHED = $6;

  GenPcntMask   =  ' #0.0%;-#0.0%';
  GenPcnt2dMask =  ' #0.00%;-#0.00%';
  GenProfileMask=  '#0.00 ;#0.00-';
  WildCha       =  '*';
  WildChQ       =  '?';
  DescTrig      =  '/';
  sdbTrig       =  '>';
  supTrig       =  '!';
  BarCTrig      =  '<';
  PostCodeTrig  =  ':'; //PR: 18/11/2013 MRD 1.1.15



Var
  GenRealMask,
  GenRNDMask,
  GenQtyMask     :  Str255;

  GenUnitMask    :  Array[BOff..BOn] of Str255;  {On=Sales, Off=Purch}



Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;


Procedure ResetRec(FNum  :  Integer);

Procedure SetDataRecOfs(FileNum  :  Integer;
                        Ofset    :  LongInt);

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);

Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);

Procedure Report_ErrorStr (Const ErrorStr : ANSIString);

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;

Function  CheckExsists(KeyR  :  AnyStr;
                       FileNum,KeyPath : Integer;
                       DBOpration : Integer = B_GetGEq ) : Boolean;  //HV 19/05/2016 2016-R2 ABSEXCH-15963 - Stock move list does not let store stock name as shorter name of itself.

Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

{ CJS 2012-09-06 - ABSEXCH-13392 - Added optional alternative message parameter }
Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80;
                        AltMessage: Str80 = '')  :   Boolean;

Function Check4DupliYRef(KEyS  :  Str255;
                         CCode :  Str10;
                         Fnum,
                         KeyP  :  Integer;
                         InvR  :  InvRec;
                         DupliP:  Str80)  :   Boolean;

Function Global_GetMainRecPos(Fnum,
                              Keypath  :  Integer;
                              KeyS     :  Str255)  :  Boolean;

Function Global_GetMainRec(Fnum  :  Integer;
                           KeyS  :  Str255)  :  Boolean;


Procedure ChangeLinks(OCode,NCode  :  AnyStr;
                             Fnum  :  Integer;
                             KLen  :  Integer;
                             KeyPth:  Integer);

Procedure DeleteLinks (Code  :  AnyStr;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Procedure DeleteAuditHist (Code     :  AnyStr;
                           KLen     :  Integer;
                           UseReset :  Boolean);


Function GetMultiSys(Wait         :  Boolean;
                     Var  Locked  :  Boolean;
                          SysMode :  SysRecTypes)  :  Boolean;

// MH 04/03/2013 v7.0.2 ABSEXCH-14003: Modified to return successful status for System Setup Auditing
Function PutMultiSys(SysMode  :  SysRecTypes;
                     UnLock   :  Boolean) : Boolean;

Function GetMultiSysCur(Wait         :  Boolean;
                   Var  Locked       :  Boolean)  :  Boolean;

Procedure PutMultiSysCur(UnLock       :  Boolean);

Function GetMultiSysGCur(Wait         :  Boolean;
                    Var  Locked       :  Boolean)  :  Boolean;

Procedure PutMultiSysGCur(UnLock       :  Boolean);

Procedure Init_AllSys;

Procedure Set_ACHistYTDBudget(State  :  Boolean);

Function Total_Profit_To_Date(NType        :  Char;
                              NCode        :  Str20;
                              PCr,PYr,PPr  :  Byte;
                          Var Purch,PSales,
                              PCleared,
                              PBudget,
                              PRBudget     :  Double;
                          Var BValue1,
                              BValue2      :  Double;
                              Range        :  Boolean)  :  Double;


Function Total_Profit_To_DateRange_RevBudgets(  NType            : Char;
                                                NCode            : Str20;
                                                PCr,PYr,PPr,PPr2 : Byte;
                                            Var Purch,PSales,
                                                PCleared,
                                                PBudget,
                                                RevisedBudget1,
                                                RevisedBudget2,
                                                RevisedBudget3,
                                                RevisedBudget4,
                                                RevisedBudget5   : Double;
                                            Var BValue1,
                                                BValue2          : Double;
                                                Range            : Boolean): Double;

Function Total_Profit_To_DateRange(NType        :  Char;
                                 NCode        :  Str20;
                                 PCr,PYr,PPr,PPr2
                                              :  Byte;
                             Var Purch,PSales,
                                 PCleared,
                                 PBudget,
                                 RevisedBudget1 :  Double;
                             Var BValue1,
                                 BValue2      :  Double;
                                 Range        :  Boolean)  :  Double;


Function Profit_To_DateRange(NType        :  Char;
                             NCode        :  Str20;
                             PCr,PYr,PPr,PPr2
                                          :  Byte;
                         Var Purch,PSales,
                             PCleared     :  Double;
                             Range        :  Boolean)  :  Double;



Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str20;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Double;
                        Range        :  Boolean)  :  Double;

Function GetVATNo(Vcode,VICode :  Char)  :  VATType;

Function GetIVATNo(Vcode  :  Char)  :  VATType;

Function GetVATCIndex(Vcode :  Char;
                      UseC  :  Boolean)  :  Integer;

Function GetVATIndex(Vcode :  Char)  :  Integer;

Function Ok2DelAcc(CCode  :  Str10)  :  Boolean;

Procedure Find_FirstHist(Const NType  :  Char;
                         Const NHCtrl :  TNHCtrlRec;
                         Var   fPr,fYr:  Byte);

Function GetTempFNameExt(SwapName,ExtN :  Str10)  :  Str255;

Function GetTempFName(SwapName :  Str10)  :  Str255;

function GetWindowsTempFileName(SwapName: Str10): Str255;

// MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
// than uploading them to the network Exchequer\Swap folder
Function GetWinTempPrintingFilename (Const Extension : ShortString) : ShortString;

Procedure SetAllowHotKey(State      :  Boolean;
                     Var PrevState  :  Boolean);

Function Get_FreeResources  :  Integer;

Procedure Free_ResourceMon;

Function Color_ResourceMon(Value  :  Integer)  :  TColor;

Function FreeDiskSpacePcnt  :  Double;

procedure Delay(dt  :  Word;
                SAPM:  Boolean);

Function FormatDecStr(NDec       : Integer;
                      DispFormat : String)  :  String;

Procedure Set_SDefDecs;

{ HM 01/10/99: Published for OLE Server }
Procedure SetCurrPage(PNo    :  Byte;
                      Var C1P    :  Curr1PRec;
                      Var GCP    :  CurrRec;
                          ReadOn :  Boolean);

{ HM 01/10/99: Published for OLE Server }
Procedure SetGCurPage(PNo    :  Byte;
                  Var C1P    :  GCur1PRec;
                  Var GCP    :  GCurRec;
                      ReadOn :  Boolean);

{$IFDEF DBD}
  Var
    DebugTime  :  Array[0..99,BOff..BOn] of LongInt;
    DebugTitle :  Array[0..99] of Str10;


  Procedure StartBDebug(DN  :  Byte; DT  :  Str10);

  Procedure StopBDebug(DN  :  Byte);

  Procedure FinishBDebug;

{$ENDIF}



{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETMiscU,
  ETDateU,
  Dialogs,
  SysUtils,
  Controls,
  TEditVal,
  Forms,
  BTKeys1U,
  //VARRec2U,  HM 01/10/99: Moved to interface
  ComnUnit,

  {$IFDEF PF_On}
    {$IFNDEF EDLL}
      {$IFNDEF OLE}
        {$IFNDEF RW}
          {$IFNDEF COMP}
            {$IFNDEF ENDV}   { Customisation Interface }
            {$IFNDEF WCA}    { Windows Card System }
            {$IFNDEF EXDLL}
            {$IFNDEF EBAD}
            {$IFNDEF ENSECR}
              {$IFNDEF XO}
               {$IFNDEF SOPDLL}
                InvLst2U,      { Boy, Is this module popular, or what? }
                Excep2U,

                {$IFDEF JAP}
                  JobSup2U,
                {$ENDIF}

               {$ENDIF} 
              {$ENDIF}
            {$ENDIF}
            {$ENDIF}
            {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
      {$ENDIF}
    {$ENDIF}
    {$ENDIF}

  {$ENDIF}

  {$IFDEF DBD}
    DebugU,
    ClipBrd,
  {$ENDIF}

  Excep3U,

  {$IFDEF RW}
    RwOpenF,
  {$ENDIF}
  {$IFDEF EDLL}
    DataDict,
  {$ENDIF}
  {$IFDEF XO}
    xoVarCon,
  {$ENDIF}
  {$IFDEF WCA}
    CardVarC,
  {$ENDIF}

  {$IFDEF EBUS}
  EBusVar,
  EBusLook,
  {$ENDIF}

  {$IFDEF TRADE}
    EPOSCnst,
  {$ENDIF}

  {$IFDEF PERIODDEBUG}
    EParentU,
  {$ENDIF}

  VarSortV,

  SQLUtils,
  SQLFuncs,

  MultiBuyVar,

  ComnU2,
  IntMU,
  {$IFDEF EXDLL}
  CRECache,
  {$ENDIF}
  BTSFrmU1,

  // MH 12/03/2012 v6.10 ABSEXCH-11937
  APIUtil,
  Math,

  //PR: 07/02/2012 ABSEXCH-9795
  QtyBreakVar

   //PR: 03/02/2014 ABSEXCH-14974
   {$IFDEF RW}
     {$IFDEF REP_ENGINE}
   ,AccountContactVar

   ,OrderPaymentsVar
     {$ENDIF}
   {$ENDIF}
   ;


Const
    gfsr_SystemResources  = $0000;

    CurPageEnd  =  CUR3;
    GCurPageEnd =  GCU3;


Var
  _MyGetFreeSystemResources32  :  function(Mode  :  Integer)  :  Integer stdcall;
  _MyGSRHandle                 :  THandle;
  Set_ACHist                   :  Boolean;



{ ================ Procedure to Compare Search Keys ============= }

Function CheckKey(KeyRef,Key2Chk  :  AnyStr;
                  KeyLen          :  Integer;
                  AsIs            :  Boolean) :  Boolean;

Begin
  If (Length(Key2Chk)>=KeyLen) then
    CheckKey:=(UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)=UpcaseStrList(Copy(KeyRef,1,KeyLen),AsIs))
  else
    CheckKey:=False;
end;




{ =============== Function to Compare Search Keys by Range ================== }


Function CheckKeyRange(KeyRef,
                       KeyRef2,
                       Key2Chk  :  AnyStr;
                       KeyLen   :  Integer;
                       AsIs     :  Boolean) :  Boolean;
Var
  KeyRefLen  :  Integer;

Begin
  KeyRefLen:=Length(KeyRef);

  If (KeyRefLen>KeyLen) or (KeyRef2='') then
    KeyRefLen:=KeyLen;



  If (KeyRef2='') then
    KeyRef2:=KeyRef;     { Set To Main Compatibility }


  If (Length(Key2Chk)>=KeyRefLen) then
    CheckKeyRange:=((UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)>=UpcaseStrList(Copy(KeyRef,1,KeyRefLen),AsIs)) and
                    (UpcaseStrList(Copy(Key2Chk,1,KeyLen),AsIs)<=UpcaseStrList(Copy(KeyRef2,1,KeyLen),AsIs)))
  else
    CheckKeyRange:=False;
end;

{ ================ Procedure to Reset Current Record ============== }

Procedure ResetRec(FNum  :  Integer);

Begin
  Case Fnum of
    CustF    :  FillChar(Cust,FileRecLen[FNum],0);
    InvF     :  FillChar(Inv,FileRecLen[FNum],0);
    IdetailF :  FillChar(Id,FileRecLen[FNum],0);
    NomF     :  FillChar(Nom,FileRecLen[FNum],0);
    StockF   :  FillChar(Stock,FileRecLen[FNum],0);
    NHistF   :  FillChar(NHist,FileRecLen[FNum],0);
    IncF     :  FillChar(Count,FileRecLen[FNum],0);
    PWrdF    :  FillChar(PassWord,FileRecLen[FNum],0);
    MiscF    :  FillChar(MiscRecs^,FileRecLen[FNum],0);
    JMiscF   :  FillChar(JobMisc^,FileRecLen[FNum],0);
    JobF     :  FillChar(JobRec^,FileRecLen[FNum],0);
    JCtrlF   :  FillChar(JobCtrl^,FileRecLen[FNum],0);
    JDetlF   :  FillChar(JobDetl^,FileRecLen[FNum],0);
    MLocF    :  FillChar(MLocCtrl^,FileRecLen[FNum],0);
    SysF     :  FillChar(Syss,FileRecLen[FNum],0);
    ReportF  :  FillChar(RepScr^,FileRecLen[FNum],0);

    NomViewF
             :  FillChar(NomView^,FileRecLen[FNum],0);
    {$IFDEF EDLL}
    DictF    :  FillChar(DictRec^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF RW}
    DictF    :  FillChar(DictRec^,FileRecLen[FNum],0);
    RepGenF  :  FillChar(RepGenRecs^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF COMP}
    RepGenF  :  FillChar(RepGenRecs^,FileRecLen[FNum],0);
    CompF    :  FillChar(Company^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF XO}
    xoListF  :  FillChar(xoList^,FileRecLen[FNum],0);
    xoGroupF :  FillChar(xoGroup^,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF WCA}
    csCardF  :  FillChar(csCard,FileRecLen[FNum],0);
    csInvF   :  FillChar(csInv,FileRecLen[FNum],0);
    csSalesF :  FillChar(csSalesDet,FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF EBUS}
    EBsF     :  FillChar(EBusRec,FileRecLen[FNum],0);
    EBsL     :  FillChar(EBusLookupRec, FileRecLen[FNum],0);
    {$ENDIF}
    {$IFDEF TRADE}
      {$IFDEF TRADE153}
        EposF  : FillChar(EposRec, FileRecLen[FNum],0);
      {$ELSE}
        // MH 27/04/07: Removed as file not SQL Compatible
        //EposSysF  : FillChar(EposSysRec, FileRecLen[FNum],0);
        EposCentF : FillChar(EposCentRec, FileRecLen[FNum],0);
      {$ENDIF}
    {$ENDIF}
    SortViewF : FillChar(SortViewRec, FileRecLen[Fnum], 0);
    SortTempF : FillChar(SortTempRec, FileRecLen[Fnum], 0);
  end; {Case..}
end;





{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfs(FileNum  :  Integer;
                        Ofset    :  LongInt);

Begin
  Case FileNum  of
    CustF     :  Move(Ofset,Cust,Sizeof(Ofset));
    InvF      :  Move(Ofset,Inv,Sizeof(Ofset));
    IdetailF  :  Move(Ofset,Id,Sizeof(Ofset));
    NomF      :  Move(Ofset,Nom,Sizeof(Ofset));
    StockF    :  Move(Ofset,Stock,Sizeof(Ofset));
    NHistF    :  Move(Ofset,NHist,Sizeof(Ofset));
    IncF      :  Move(Ofset,Count,Sizeof(Ofset));
    PWrdF     :  Move(Ofset,PassWord,Sizeof(Ofset));
    MiscF     :  Move(Ofset,MiscRecs^,Sizeof(Ofset));
    JMiscF    :  Move(Ofset,JobMisc^,Sizeof(Ofset));
    JobF      :  Move(Ofset,JobRec^,Sizeof(Ofset));
    JCtrlF    :  Move(Ofset,JobCtrl^,Sizeof(Ofset));
    JDetlF    :  Move(Ofset,JobDetl^,Sizeof(Ofset));
    MLocF     :  Move(Ofset,MLocCtrl^,Sizeof(Ofset));
    SysF      :  Move(Ofset,Syss,Sizeof(Ofset));
    ReportF   :  Move(Ofset,RepScr^,Sizeof(OfSet));

    NomViewF
              :  Move(Ofset,NomView^,Sizeof(OfSet));
    {$IFDEF EDLL}
    DictF     :  Move(Ofset,DictRec^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF RW}
    DictF     :  Move(Ofset,DictRec^,Sizeof(Ofset));
    RepGenF   :  Move(Ofset,RepGenRecs^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF COMP}
    RepGenF   :  Move(Ofset,RepGenRecs^,Sizeof(Ofset));
    CompF     :  Move(Ofset,Company^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF XO}
    xoListF  :  Move(Ofset,xoList^,Sizeof(Ofset));
    xoGroupF :  Move(Ofset,xoGroup^,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF WCA}
    csCardF  :  Move(Ofset,csCard,Sizeof(Ofset));
    csInvF   :  Move(Ofset,csInv,Sizeof(Ofset));
    csSalesF :  Move(Ofset,csSalesDet,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF EBUS}
    EBsF     : Move(OfSet,EBusRec,Sizeof(Ofset));
    EBsL     : Move(OfSet,EBusLookupRec,Sizeof(Ofset));
    {$ENDIF}
    {$IFDEF TRADE}
      {$IFDEF TRADE153}
        EposF  : Move(OfSet, EposRec,  Sizeof(Ofset));
      {$ELSE}
        // MH 27/04/07: Removed as file not SQL Compatible
        //EposSysF  : Move(OfSet, EposSysRec,  Sizeof(Ofset));
        EposCentF : Move(OfSet, EposCentRec, Sizeof(Ofset));
      {$ENDIF}
    {$ENDIF}
    SortViewF : Move(Ofset, SortViewRec, SizeOf(Ofset));
    SortTempF : Move(Ofset, SortTempRec, SizeOf(Ofset));
    {$IFDEF SOP}
    MultiBuyF : Move(Ofset, MultiBuyDiscount, SizeOf(Ofset));
    {$ENDIF}
    //PR: 07/02/2012 Added new Qty Break record ABSEXCH-9795
    QtyBreakF : Move(Ofset, QtyBreakRec, SizeOf(Ofset));

    //PR: 03/02/2014 ABSEXCH-14974 Added AccountContactRole (VRW only)
    {$IFDEF RW}
      {$IFDEF REP_ENGINE}
    AccountContactRoleF
              : Move(Ofset, AccContactRole, SizeOf(Ofset));

    OrderPaymentsF
              : Move(Ofset, OrderPaymentVatRec, SizeOf(Ofset));
      {$ENDIF}        
    {$ENDIF}

  end; {Case..}
end;


{ ============ Low Level Proc to Set Data Record for 4-byte offset ========== }

Procedure SetDataRecOfsPtr(FileNum  :  Integer;
                           Ofset    :  LongInt;
                       Var DataRec);

Begin

  Move(Ofset,DataRec,Sizeof(Ofset));

end;



{ =========== Report IOError =========== }


Procedure Report_IOError(IOCode  :  Integer;
                         Fname   :  Str255);


Const
  IOMess1  =  ' WARNING! - I/O Error ';
  IOMess3  =  ' in file';


Var
  mbRet  :  Word;

Begin
  If (IOCode<>0) then
  Begin

    MbRet:=MessageDlg(IOMess1+#13+IOError(IOCode)+IOMEss3+#13+Fname,mtError,[mbOk],0);

    {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}   { Customisation Interface }
                {$IFNDEF WCA}    { Windows Card System }
                {$IFNDEF EXDLL}
                {$IFNDEF EBAD}
                  {$IFNDEF XO}
                   {$IFNDEF SOPDLL}
                    AddErrorLog(IOMess1+#13+IOError(IOCode),'In File : '+Fname,0);
                   {$ENDIF} 
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    {$ENDIF}


  end;

end;

{ ============= Function to Report Btrieve Error ============= }

Procedure Report_MTBError(Fnum,
                          ErrNo    :  Integer;
                          ClientId :  Pointer);
Var
  ErrStr    :  AnsiString;
  mbRet     :  Word;
  ThStr     :  AnsiString;
  ClientIdR :  ClientIdType;

Begin
  ThStr:='';

  If (ErrNo<>0) then
  Begin
    ErrStr:=Set_StatMes(ErrNo);

    If (Assigned(ClientId)) then
      ThStr:=#13+#13+'In thread '+Form_Int(ClientIdType(ClientId^).TaskId,0);

    mbRet:=MessageDlg('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,
           mtError,[mbOk],0);

    {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}   { Customisation Interface }
                {$IFNDEF WCA}    { Windows Card System }
                {$IFNDEF EXDLL}
                {$IFNDEF EBAD}
                  {$IFNDEF XO}
                   {$IFNDEF SOPDLL}
                      AddErrorLog('Btrieve Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+ErrStr+ThStr,'',3);
                   {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    {$ENDIF}

  end;
end; {Proc..}



Procedure Report_BError(Fnum,
                        ErrNo  :  Integer);

Begin
  {$IFNDEF SOPDLL}
    {$IFDEF SENTREPENG}
    //PR: 11/04/2011 Changed for Sentimail to raise an exception rather than showing a dialog 
    if not (ErrNo in [0]) then
      raise Exception.Create('Error in file : '+FileNAmes[Fnum]+#13+'Error '+Form_Int(ErrNo,0)+', '+#13+
                              Set_StatMes(ErrNo));
    {$ELSE}
    If (ErrNo<>0) and (Debug) then
      MessageBeep(0);

    Report_MTBError(Fnum,ErrNo,nil);
    {$ENDIF}
  {$ENDIF}
end; {Proc..}



Procedure Report_ErrorStr (Const ErrorStr : ANSIString);
Begin // Report_ErrorStr
  {$IFNDEF SOPDLL}
    MessageDlg (ErrorStr, mtError, [mbOk], 0);

    {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}   { Customisation Interface }
                {$IFNDEF WCA}    { Windows Card System }
                {$IFNDEF EXDLL}
                {$IFNDEF EBAD}
                  {$IFNDEF XO}
                   {$IFNDEF SOPDLL}
                      AddErrorLog(ErrorStr,'',3);
                   {$ENDIF}
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}
    {$ENDIF}
  {$ENDIF}
End; // Report_ErrorStr










{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRecAddr(Func      :  Integer;
                         LockType  :  Integer;
                     Var Key2S     :  Str255;
                         KeyPth    :  Integer;
                         Fnum      :  Integer;
                         Wait      :  Boolean;
                     Var Locked    :  Boolean;
                     Var LRecAddr  :  LongInt) : Boolean;

Var
  Bcode,
  Fcode    :  Integer;
  MbRet    :  Word;
  TmpForm  :  TBTWaitLock;

Begin
  Locked:=BOff; Fcode:=0;

  TmpForm:=NIL;

  BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,RecPtr[Fnum]);


  If (Bcode<>0) then
  Case Bcode of
       81     :  Report_Berror(Fnum,BCode);  {* Lock table full *}

       84,85  {$IFDEF Su_On}

              :  Begin
                   mbRet:=MessageDlg('Network Violation! - Closing System',
                                      mtError,[mbOk],0);

                   Halt;
                 end;

              {$ELSE}


              :  If (Not Wait) then
                 Begin
                   {* Establish if record found at all *}

                   Fcode:=Find_Rec(Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,Key2s);

                   Repeat

                     mbRet:=MessageDlg('Record in use by another station!',
                                        MtConfirmation,[mbRetry,mbCancel],0);

                     BCode:=Try_Lock(Func,B_SingNWLock+LockType,Key2S,Keypth,Fnum,RecPtr[Fnum]);

                   Until (MbRet=IdCancel) or (Bcode=0);

                   Locked:=(Bcode=0);

                   {* Set record found *}
                   Bcode:=Fcode;

                 end
                 else
                 Begin

                   If (Assigned(Application.Mainform)) then
                     TmpForm:=TBTWaitLock.Create(Application.Mainform)
                   else
                     TmpForm:=TBTWaitLock.Create(Application);

                   Try

                     TMpForm.Init_Test(Func,Fnum,Keypth,LockType,Key2S,RecPtr[Fnum],nil);

                     BCode:=(TmpForm.ShowModal-mrOk);

                   Finally

                     TmpForm.Free;

                   end;

                   Locked:=(Bcode=0);

                 end;

               {$ENDIF}

       22      : Begin
                   Locked:=(VariFile[Fnum]);
                   If (Locked) then
                     Bcode:=0;
                 end;


  end {Case..}
  else
    Locked:=BOn;

  Addch:=#0; {* Reset Lock Key *}

  GetMultiRecAddr:=(Bcode=0);

  If (BCode=0) then
    BCode:=GetPos(F[Fnum],Fnum,LRecAddr);

end;


{ ======= General Routine to Atempt a Record Lock ========= }

Function GetMultiRec(Func      :  Integer;
                     LockType  :  Integer;
                 Var Key2S     :  Str255;
                     KeyPth    :  Integer;
                     Fnum      :  Integer;
                     Wait      :  Boolean;
                 Var Locked    :  Boolean) : Boolean;

Var
  LRecAddr  :  LongInt;

Begin

  LRecAddr:=0;

  GetMultiRec:=GetMultiRecAddr(Func,LockType,Key2S,Keypth,Fnum,Wait,Locked,LRecAddr);

end;

{ Duplicate copt in tdMTExLocal }

{ =========== Function to Check Exsistance of Given Code without disturbing record ========= }


Function  CheckExsists(KeyR : AnyStr;
                       FileNum,KeyPath : Integer;
                       DBOpration : Integer) : Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  KeyS:=KeyR;

  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}

  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);

  //HV 19/05/2016 2016-R2 ABSEXCH-15963 - Stock move list does not let store stock name as shorter name of itself.
  CEStatus:=Find_Rec(DBOpration+B_KeyOnly,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  CheckExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

end;



{ =========== Function to Check Exsistance of Given Code and return record if found ========= }


{$IFDEF EXDLL}
Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  if SQLUtils.UsingSQL then
  begin
    Result := oCRECache.Find(KeyR, FileNum, KeyPath, RecPtr[FileNum]);
  end
  else
    Result := False;

  if not Result then
  begin
    KeyS:=KeyR;

    {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


    TmpKPath:=GetPosKey;

    TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);


    CEStatus:=Find_Rec(B_GetGEq,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

    If (CEStatus<>0) then
      ResetRec(FileNum);

//    CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));
    Result:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

    TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

    //PR: 28/05/2010 Needed to add check for SQL to match Find, above - otherwise under Pervasive objects kept getting added,
    //causing memory leak.
    if Result and SQLUtils.UsingSQL then
      oCRECache.Add(KeyR, FileNum, KeyPath, RecPtr[FileNum]);
  end;

end;

{$ELSE}

Function  CheckRecExsists(KeyR  :  AnyStr;
                          FileNum,KeyPath
                               :  Integer)  :  Boolean;

Var
  KeyS     :  AnyStr;
  {TmpFn    :  FileVar;}

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;



Begin
  KeyS:=KeyR;

  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOff,BOff);


  CEStatus:=Find_Rec(B_GetGEq,F[FileNum],FileNum,RecPtr[FileNum]^,KeyPath,KeyS);

  If (CEStatus<>0) then
    ResetRec(FileNum);

  CheckRecExsists:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

  TmpStat:=Presrv_BTPos(Filenum,TmpKPath,F[FileNum],TmpRecAddr,BOn,BOff);

end;

{$ENDIF}



{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliGen(KEyS  :  Str255;
                        Fnum,
                        KeyP  :  Integer;
                        DupliP:  Str80;
                        AltMessage: Str80)  :   Boolean;

Var
  Sure  :  Boolean;
  TmpCh :  Char;
  Count :  Byte;

  TmpStat,
  TmpKPath
        :  Integer;
  TmpRecAddr
        :  LongInt;

  {TmpFn :  FileVar;}

  MbRet :  Word;
Begin
  {* TmpFn:=F[FileNum]; Stopped using this v4.21, as suspected C/S was getting corrupted  *}


  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOff,BOff);


  Status:=Find_Rec(B_GetEq+B_KeyOnly,F[FNum],Fnum,RecPtr[Fnum]^,KeyP,KeyS);

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOn,BOff);

  If (Status=0) then
  Begin
    { CJS 2012-09-06 - ABSEXCH-13392 - Added optional alternative message parameter }
    if AltMessage = '' then
      mbRet := MessageDlg('That '+DupliP+' already exists!', mtWarning,[mbOk],0)
    else
      mbRet := MessageDlg(AltMessage, mtWarning,[mbOk],0)

  end
  else If (Debug) and (Status<>4) then Status_Means(Status);

  Check4DupliGen:=(Status=0);

end;




{ ================ Procedrue to Check for Duplicate XXX Records,.. ===}

Function Check4DupliYRef(KEyS  :  Str255;
                         CCode :  Str10;
                         Fnum,
                         KeyP  :  Integer;
                         InvR  :  InvRec;
                         DupliP:  Str80)  :   Boolean;

Var
  FoundOk,
  Sure  :  Boolean;
  TmpCh :  Char;
  Count :  Byte;

  TmpStat,
  TmpKPath
        :  Integer;
  TmpRecAddr
        :  LongInt;


  MbRet :  Word;

  KeyChk:  Str255;

  LocalInv
        :  InvRec;


Begin
  FoundOk:=BOff;


  TmpKPath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOff,BOff);

  KeyChk:=KeyS;

  LocalInv:=Inv;

  Status:=Find_Rec(B_GetGEq,F[FNum],Fnum,RecPtr[Fnum]^,KeyP,KeyS);

  While (StatusOK) and (CheckKey(KeyChk,Inv.YourRef,Length(KeyChk),BOff)) and (Not FoundOk) do
  Begin
    FoundOk:=CheckKey(CCode,FullCustCode(Inv.CustCode),Length(CCode),BOff) and (Inv.OurRef<>InvR.OurRef);

    If (Not FoundOk) then
      Status:=Find_Rec(B_GetNext,F[FNum],FNum,RecPtr[FNum]^,KeyP,KeyS);

  end;

  TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[FNum],TmpRecAddr,BOn,BOff);

  Inv:=LocalInv;

  If (FoundOk) then
  Begin
    mbRet:=MessageDlg('That '+DupliP+' already exists!',
                       mtWarning,[mbOk],0);

  end
  else If (Debug) and (Status<>4) then Status_Means(Status);

  Check4DupliYRef:=FoundOk;

end;





{ ==== General purpose Get main rec via main key ==== }

Function Global_GetMainRecPos(Fnum,
                              Keypath  :  Integer;
                              KeyS     :  Str255)  :  Boolean;


Begin
  Result:=BOff;

  If (KeyS<>'') then
    Result:=(Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,KeyS)=0);

end;

{ ==== General purpose Get main rec via main key ==== }

Function Global_GetMainRec(Fnum  :  Integer;
                           KeyS  :  Str255)  :  Boolean;


Begin
  Result:=Global_GetMainRecPos(Fnum,0,KeyS);

end;


{ ================== Procedure to Delete all Records Matching a give Code ============= }



Procedure DeleteLinks (Code  :  AnyStr;
                       Fnum  :  Integer;
                       KLen  :  Integer;
                       KeyPth:  Integer;
                       DelInv:  Boolean);

Var
  KeyS  :  AnyStr;
  Locked:  Boolean;
  LAddr :  LongInt;

Begin
  KeyS:=Code;


  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                            {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

  While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) and ((Not DelInv) or ((DelInv) and (Id.LineNo<> RecieptCode))) do
  Begin

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked,LAddr);

    If (Ok) and (Locked) then
    Begin
      

      {$IFDEF PF_On}
        {$IFNDEF EDLL}
          {$IFNDEF OLE}
            {$IFNDEF RW}
              {$IFNDEF COMP}
                {$IFNDEF ENDV}
                {$IFNDEF WCA}    { Windows Card System }
                {$IFNDEF EXDLL}
                {$IFNDEF EBAD}
                  {$IFNDEF XO}
                    If (Not EmptyKey(Id.JobCode,JobKeyLen)) and (StatusOk) and (Fnum=IdetailF) then
                    Begin
                      Delete_JobAct(Id);

                      {$IFDEF JAP}
                        If (Id.IdDocHed In JAPSplit) then
                          Update_JTLink(Id,Inv,BOn,BOn,Fnum,IdLinkK,Keypth,0);
                      {$ENDIF}

                      SetDataRecOfs(Fnum,LAddr);

                      If (LAddr<>0) then
                        Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth,0);

                    end;
                  {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
                {$ENDIF}
              {$ENDIF}
            {$ENDIF}
          {$ENDIF}
        {$ENDIF}

      {$ENDIF}

      
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);
    end;


    Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


  end;
end;


{ ================== Procedure to Reset all History Records Matching a give Code and after purge year ============= }
{* An exact copy of this is in ExBtTH1U for thread safe operation *}


  Procedure ResetAuditHist (Code  :  AnyStr;
                            KLen  :  Integer);
  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;
                       

  Var
    KeyS  :  AnyStr;
    Locked:  Boolean;                       
    LAddr :  LongInt;           

  Begin
    KeyS:=Code;


    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                              {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

    While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
    With NHist do
    Begin

      If (AfterPurge(Yr,0)) then
      Begin
        Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked,LAddr);

        If (Ok) and (Locked) then
        Begin

          Sales:=0; Purchases:=0; Cleared:=0; {Value1& 2 not reset as jobs use them for qty budgets. Check stk uses deletehist?}

          Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

        end;
      end;

      Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


    end;
  end;



{ ================== Procedure to Delete all History Records Matching a give Code and after purge year ============= }
{* An exact copy of this is in ExBtTH1U for thread safe operation *}


  Procedure DeleteAuditHist (Code     :  AnyStr;
                             KLen     :  Integer;
                             UseReset :  Boolean);
  Const
    Fnum     =  NHistF;
    Keypth   =  NHK;


  Var
    KeyS  :  AnyStr;
    Locked:  Boolean;
    LAddr :  LongInt;
    sCompany : ShortString;
    sWhere : ANSIString;
  Begin
    If (UseReset) then
      ResetAuditHist(Code,KLen)
    else
    Begin
      // MH 04/06/2008: Added an alternate direct to DB Engine version for SQL to improve performance
      If (Not SQLUtils.UsingSQLAlternateFuncs) Then
      Begin
        KeyS:=Code;


        Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);

                                                  {* Mod so that Direct reciept lines do not get deleted on an invoice update *}

        While (Status=0) and (CheckKey(Code,KeyS,KLen,BOn)) do
        With NHist do
        Begin

          If (AfterPurge(Yr,0)) then
          Begin
            Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked,LAddr);

            If (Ok) and (Locked) then
            Begin
              Status:=Delete_Rec(F[Fnum],Fnum,KeyPth);

            end;
          end;

          Status:=Find_Rec(B_GetNext,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);


        end;
      End // If (Not SQLUtils.UsingSQLAlternateFuncs)
      Else
      Begin
        // Do direct call to SQL Server to delete all rows in one go
        sCompany := GetCompanyCode(SetDrive);
        sWhere := '(' + GetDBColumnName('History.Dat', 'f_ex_class', '') + ' = ' + IntToStr(Ord(Code[1])) + ') And ' +
                  '(SubString(' + GetDBColumnName('History.Dat', 'f_code', '') + ', 2, ' + IntToStr(KLen-1) + ') = ' + StringToHex(Copy(Code,2,KLen-1)) + ')';

        If (Syss.AuditYr <> 0) Then
        Begin
          // Add clause for Purge
          sWhere := sWhere + ' And (' + GetDBColumnName('History.Dat', 'f_yr', '') + ' > ' + IntToStr(Syss.AuditYr) + ')';
        End; // If (Syss.AuditYr <> 0)

        DeleteRows(sCompany, 'History.Dat', sWhere);
      End; // Else
    end;
  end;






{ ================== Procedure to Change All Codes Associated with One Link ============= }

Procedure ChangeLinks(OCode,NCode  :  AnyStr;
                             Fnum  :  Integer;
                             KLen  :  Integer;
                             KeyPth:  Integer);

Var
  KeyS  :  AnyStr;
  Locked:  Boolean;

  B_Func,
  QDC,
  NDC,
  VDC   :  Integer;

  LAddr :  LongInt;


Begin
  KeyS:=OCode;

  QDC:=1; NDC:=1; VDC:=1;

  B_Func:=B_GetNext;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);



  While (CheckKey(OCode,KeyS,KLen,BOn)) and (Status=0) do
  Begin

    Ok:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,KeyPth,Fnum,BOn,Locked,LAddr);

    Case Fnum of
       NHistF  :   Case KeyPth of
                      NHK :   With NHist do
                              If (ExClass<>PQCode) then  { ** Do Not Clear Print Q Items - remove all others ** }
                              Begin
                                Sales:=0; Purchases:=0; Cleared:=0;
                              end;
                    end;

       IncF    :   Case KeyPth of
                      IncK:   With Count do
                                LastValue:=0;
                    end;

       IDetailF
               :   Case KeyPth of
                      IdFolioK
                         :   With Id do
                             Begin

                               {$IFDEF PF_On}
                                 {$IFNDEF EDLL}
                                   {$IFNDEF OLE}
                                     {$IFNDEF RW}
                                       {$IFNDEF COMP}
                                         {$IFNDEF EBAD}
                                         {$IFNDEF ENDV}
                                         {$IFNDEF WCA}    { Windows Card System }
                                         {$IFNDEF EXDLL}
                                           {$IFNDEF XO}
                                             If (Not EmptyKey(JobCode,JobKeyLen)) then
                                               Delete_JobAct(Id);
                                           {$ENDIF}
                                         {$ENDIF}
                                         {$ENDIF}
                                         {$ENDIF}
                                         {$ENDIF}
                                       {$ENDIF}
                                     {$ENDIF}
                                   {$ENDIF}
                                 {$ENDIF}

                               {$ENDIF}


                               If (NCode='Reset') then
                               Begin
                                 NetValue:=0;
                                 Qty:=1;
                                 QtyMul:=1;
                                 QtyPack:=1;
                                 PriceMulX:=1.0;
                                 Discount:=0;
                                 VAT:=0;
                                 CostPrice:=0;
                                 Discount:=0;
                                 QtyWOff:=0;
                                 QtyDel:=0;
                                 QtyPick:=0;
                                 QtyPWoff:=0;

                                 // MH 24/03/2009: Added support for new discount fields
                                 Discount2:=0.0;
                                 Discount3:=0.0;
                               end
                               else
                               Begin
                                 {Changed v4.32 so that -ve lines catered for correctly}
                                 {If (IdDocHed In QuotesSet) and (Inv.InvdocHed In [SCR,PCR])
                                      and ((Qty<0.0) or (NetValue<0.0)) then}

                                 If (IdDocHed In QuotesSet) and (Inv.InvdocHed In [SCR,PCR]) then
                                 Begin
                                   QDC:=1; NDC:=1; VDC:=-1;

                                   If ((Qty<0) and (NetValue>=0.0)) or
                                    ((Qty>=0.0) and (NetValue>=0.0)) then
                                     QDC:=-1
                                   else
                                     If ((Qty>=0.0) and (NetValue<0)) or
                                     ((Qty<0.0) and (NetValue<0.0)) then
                                       NDC:=-1;

                                   Qty:=Qty*QDC;
                                   NetValue:=NetValue*NDC;
                                   VAT:=VAT*VDC;


                                   Payment:=DocPayType[Inv.InvDocHed];
                                   UseORate:=Inv.UseORate;
                                   CXRate:=Inv.CXRate;
                                   CurrTriR:=Inv.CurrTriR;

                                 end;

                                 IdDocHed:=Inv.InvDocHed;
                                 FolioRef:=Inv.FolioNum;
                                 DocPRef:=Inv.OurRef;
                                 CustCode:=Inv.CustCode;

                                 {$IFDEF PF_On}
                                   {$IFNDEF EDLL}
                                     {$IFNDEF OLE}
                                       {$IFNDEF RW}
                                         {$IFNDEF COMP}
                                           {$IFNDEF ENDV}
                                           {$IFNDEF WCA}    { Windows Card System }
                                           {$IFNDEF EXDLL}
                                           {$IFNDEF EBAD}
                                             {$IFNDEF XO}
                                               If (JbCostOn) and (DetLTotal(Id,BOff,BOff,0.0)<>0) and (KitLink=0) then
                                                 Update_JobAct(Id,Inv);
                                             {$ENDIF}
                                           {$ENDIF}
                                           {$ENDIF}                                           
                                           {$ENDIF}
                                           {$ENDIF}
                                         {$ENDIF}
                                       {$ENDIF}
                                     {$ENDIF}
                                   {$ENDIF}
                                 {$ENDIF}


                                 B_Func:=B_GetGEq;
                               end;
                             end;
                    end;

    end;


    If (Ok) and (Locked) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPth);
      Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);
    end
    else
      B_Func:=B_GetNext;


    Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,Keypth,KeyS);



    If (Debug) then Status_Means(Status);
  end;
end;



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


Function GetMultiSys(Wait         :  Boolean;
                     Var  Locked  :  Boolean;
                          SysMode :  SysRecTypes)  :  Boolean;

Var
  TempSys  :  Sysrec;
  Key2F    :  Str255;
  LStatus  :  SmallInt;


Begin
{$IFDEF PERIODDEBUG}
  If PD_Enabled Then PD_InGetMultiSys := PD_InGetMultiSys + 1;
{$ENDIF}


  TempSys:=Syss;

  Key2F:=SysNames[SysMode];

  Result:=BOff;

  If (Not Locked) then
  Begin
    LStatus:=Find_Rec(B_GetEq,F[SysF],SysF,RecPtr[SysF]^,0,Key2F);

    Locked:=BOn;

    If (Debug) then Status_Means(LStatus);

    Result:=(LStatus=0);
  end
  else
    Result:=GetMultiRec(B_GetEq,B_MultLock,Key2F,0,SysF,Wait,Locked);


  If (Result) and (Locked) then
  Begin
    LStatus:=GetPos(F[SysF],SysF,SysAddr[SysMode]);

    Case SysMode of
      SysR  :  TempSys:=Syss;
      VATR  :  Move(Syss,SyssVAT^,Sizeof(SyssVAT^));


      CurR,
      CuR2,
      CuR3  :  Begin
                 Move(Syss,SyssCurr1P^,Sizeof(SyssCurr1P^));

                 SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr^,
                             BOn);

               end;



      ModRR :  Move(Syss,SyssMod^,Sizeof(SyssMod^));

      GCuR,
      GCU2,
      GCU3  :  Begin

                 Move(Syss,SyssGCur1P^,Sizeof(SyssGCur1P^));

                 SetGCurPage(Succ(Ord(SysMode)-Ord(GCuR)),
                             SyssGCuR1P^,
                             SyssGCuR^,
                             BOn);

               end;


      DEFR  :  Move(Syss,SyssDEF^,Sizeof(SyssDEF^));
      JobSR :  Move(Syss,SyssJob^,Sizeof(SyssJob^));
      FormR :  Move(Syss,SyssForms^,Sizeof(SyssForms^));
      EDI1R :  Move(Syss,SyssEDI1^,Sizeof(SyssEDI1^));
      EDI2R :  Move(Syss,SyssEDI2^,Sizeof(SyssEDI2^));
      EDI3R :  Move(Syss,SyssEDI3^,Sizeof(SyssEDI3^));
      CstmFR:  Move(Syss,SyssCstm^,Sizeof(SyssCstm^));
      CstmFR2: Move(Syss,SyssCstm2^,Sizeof(SyssCstm2^));

      CISR  :  Move(Syss,SyssCIS^,Sizeof(SyssCIS^));

      CIS340R
            :  Move(Syss,SyssCIS340^,Sizeof(SyssCIS340^));
    end;

    {$IFDEF LTE} {Override non Lite switches with hard wired options}
      Case SysMode of
        SysR  :  With TempSys do
                 Begin
                   TotalConv:=XDayCode; {* Force dayrate *}
                   VATCurr:=0;          {* Force VAT return in base currency *}
                   UseGLClass:=BOn;     {* Force use of GL Class *}
                   AutoValStk:=BOff;    {* Force Non live stk *}
                   UseMLoc:=BOff;       {* Disable locns *}
                   UseLocDel:=BOff;     {* Disable locns *}
                   ExternCust:=BOff;    {* No links to external custs *}
                   ExternSin:=BOff;     {* No external sin generation *}
                   TxLateCR:=BOn;       {* Force DOS key support on *} 
                   LiveCredS:=BOff;     {* Auto calc oldest debt *}
                   ProtectPost:=BOn;    {* Force protected mode posting *}
                   UseUpliftNC:=BOff; {* Force no auto uplift control *}
                   UseStock:=BOn;  {* Force stock warning *}
                 end;
        CstmFR  :  With SyssCstm^.CustomSettings do
                   Begin
                     FillChar(fHide,Sizeof(fHide),#1);
                   end;
        CstmFR2 :  With SyssCstm2^.CustomSettings do
                   Begin
                     FillChar(fHide,Sizeof(fHide),#1);
                   end;
        VATR    :  With SyssVAT.VATRates do
                   Begin
                     FillChar(HideLType,Sizeof(HideLType),#1);
                     FillChar(HideUDF,Sizeof(HideUDF),#1);
                   end;
      end;{Case..}
    {$ENDIF}
  end; {If Ok..}

  Syss:=TempSys;

{$IFDEF PERIODDEBUG}
  If PD_Enabled Then PD_InGetMultiSys := PD_InGetMultiSys - 1;
{$ENDIF}
end;





{ =========== Put MultiUser System File =========== }

// MH 04/03/2013 v7.0.2 ABSEXCH-14003: Modified to return successful status for System Setup Auditing
Function PutMultiSys(SysMode  :  SysRecTypes;
                     UnLock   :  Boolean) : Boolean;
Var
  TempSys  :  SysRec;
  LStatus  :  SmallInt;

Begin
{$IFDEF PERIODDEBUG}
  If PD_Enabled Then PD_InPutMultiSys := PD_InPutMultiSys + 1;
{$ENDIF}

  TempSys:=Syss;

  ResetRec(SysF);

  SetDataRecOfs(SysF,SysAddr[SysMode]);

  LStatus:=GetDirect(F[SysF],SysF,RecPtr[SysF]^,0,0);

  // If we failed to find the record return FALSE
  Result := (LStatus = 0);

  If (LStatus=0) then
  Begin


    Case SysMode of
      DEFR  :  Move(SyssDEF^,Syss,Sizeof(SyssDEF^));
      VATR  :  Move(SyssVAT^,Syss,Sizeof(SyssVAT^));

      CurR,
      CUR2,
      CUR3  :  Begin
                 SyssCurr1P^.IDCode:=SysNames[SysMode];

                 SetCurrPage(Succ(Ord(SysMode)-Ord(CurR)),
                             SyssCurr1P^,
                             SyssCurr^,
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


      ModRR :  Move(SyssMod^,Syss,Sizeof(SyssMod^));
      SysR  :  Syss:=TempSys;
      JobSR :  Move(SyssJob^,Syss,Sizeof(SyssJob^));
      FormR :  Move(SyssForms^,Syss,Sizeof(SyssForms^));
      EDI1R :  Move(SyssEDI1^,Syss,Sizeof(SyssEDI1^));
      EDI2R :  Move(SyssEDI2^,Syss,Sizeof(SyssEDI2^));
      EDI3R :  Move(SyssEDI3^,Syss,Sizeof(SyssEDI3^));

      CstmFR:  Move(SyssCstm^,Syss,Sizeof(SyssCstm^));
      CstmFR2: Move(SyssCstm2^,Syss,Sizeof(SyssCstm2^));

      CISR  : Move(SyssCIS^,Syss,Sizeof(SyssCIS^));

      CIS340R
            :  Move(SyssCIS340^,Syss,Sizeof(SyssCIS340^));

    end;{Case..}


    LStatus:=Put_Rec(F[SysF],SysF,RecPtr[SysF]^,0);

    // Return TRUE if the update succeeded - ignore the unlock below as the update is the important bit
    Result := (LStatus = 0);
  end;


  Report_BError(SysF,LStatus);

  If (UnLock) and (LStatus=0) then
  Begin
    LStatus:=UnlockMultiSing(F[SysF],SysF,SysAddr[SysMode]);

    If (Debug) then
      Status_Means(LStatus);
  end;

  Syss:=TempSys;

{$IFDEF PERIODDEBUG}
  If PD_Enabled Then PD_InPutMultiSys := PD_InPutMultiSys - 1;
{$ENDIF}
end;



{ == Gen routines to get and store multiple currency anf Triangulation pages == }

Function GetMultiSysCur(Wait         :  Boolean;
                   Var  Locked       :  Boolean)  :  Boolean;


Var
  N        :  SysRecTypes;
  TLocked  :  Boolean;


Begin

  Result:=BOn;

  For n:=CURR to CurPageEnd do
  Begin
    If (Result) then
    Begin
      TLocked:=Locked;
      Result:=GetMultiSys(Wait,TLocked,N);
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



Function GetMultiSysGCur(Wait         :  Boolean;
                    Var  Locked       :  Boolean)  :  Boolean;

Var
  N        :  SysRecTypes;
  TLocked  :  Boolean;


Begin

  Result:=BOn;

  For n:=GCUR to GCurPageEnd do
  Begin
    If (Result) then
    Begin
      TLocked:=Locked;
      Result:=GetMultiSys(Wait,TLocked,N);
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




Procedure Set_SDefDecs;

Begin

  {GenRealMask:='###'+ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00 ;###'+
               ThousandSeparator+'###'+ThousandSeparator+'##0'+DecimalSeparator+'00-';

  GenRNDMask:=' ###'+ThousandSeparator+'###'+ThousandSeparator+'##0;-###'+
               ThousandSeparator+'###'+ThousandSeparator+'##0';

  The actual format specifier must be , for thousdands, and . for decimal. Formatfloat will substitute regional settings

 }

 GenRealMask:='###,###,##0.00 ;###,###,##0.00-';

 {$IFDEF DBD}
   {If (Debug) then
     GenRealMask:='###,###,##0.000 ;###,###,##0.000-'; It might me possible to display to three dec places, by setting this mask}
 {$ENDIF}

  GenRNDMask:=' ###,###,##0;-###,###,##0';

  GenQtyMask:=GenRealMask;
  GenUnitMask[BOff]:=GenRealMask;
  GenUnitMask[BOn]:=GenRealMask;

  GenQtyMAsk:=FormatDecStrSD(Syss.NoQtyDec,GenRealMask,BOff);
  GenUnitMask[BOn]:=FormatDecStrSD(Syss.NoNetDec,GenRealMask,BOff);
  GenUnitMask[BOff]:=FormatDecStrSD(Syss.NoCosDec,GenRealMask,BOff);
end;

Function FormatDecStr(NDec       : Integer;
                      DispFormat : String)  :  String;

begin

  Result:=FormatDecStrSD(NDec,DispFormat,False);

end;



  { ================== Read-In all 3 system files ================== }

  Procedure Init_AllSys;

  Var
    TmpIO  :  Integer;
    CCFlg  :  Boolean;
    SysCount
           :  SysrecTypes;

  Begin

    CCFlg:=BOff;

    For SysCount:=SysR to FormR do
    Begin
      GlobLocked:=BOff;

      GetMultiSys(BOff,GlobLocked,SysCount);
    end;


    GlobLocked:=BOff;

    GetMultiSys(BOff,GlobLocked,EDI2R);

    Set_SDefDecs;

    GlobPeriodsInYr:=Syss.PrInYr;

    If (Syss.PrintReciept) then   {* Add Reciept as a printable document *}
      DefPrnSet:=DefPrnSet+[SRC]; {* // Not used in ent, only used in Ex really *}

    {BeepSwitch:=Not Syss.MuteBeep;{* Switch Sound On/Off *}


    {$IFDEF STK}

      {$IFDEF PF_On}

        {* (JC) replicated *}

        If (Syss.QUAllocFlg) then  {* Enable stock allocation by Quote *}
        Begin

          StkAllSet:=StkAllSet+[SQU];
          StkOrdSet:=StkOrdSet+[PQU];
          StkExcSet:=StkExcSet-[SQU,PQU];

          DocNames[SQU]:='Sales Quote/Order';

          DocNames[PQU]:='Purchase Quote/Order';

        end;

      {$ELSE}

        DocNames[SQU]:='Sales Quote/Order';

        DocNames[PQU]:='Purchase Quote/Order';

      {$ENDIF}

    {$ENDIF}

    If (Syss.DirOwnCount) then {* Disable own document count *}
    Begin

      DocNosXLate[SRI]:=DocCodes[SRI];

      DocNosXLate[SRF]:=DocCodes[SRF];

      DocNosXLate[PPI]:=DocCodes[PPI];

      DocNosXLate[PRF]:=DocCodes[PRF];

    end;


    SetIntMessage;
  end;


{ == Function to set flag to override behaviour of dealing with account balances == }

Procedure Set_ACHistYTDBudget(State  :  Boolean);

Begin
  Set_ACHist:=State;

end;

{ ============== Get Profit To Current Period ============== }
{* These routines are duplicated in EXBTTH1U *}

// CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
Function Total_Profit_To_DateRange(NType        :  Char;
                                   NCode        :  Str20;
                                   PCr,PYr,PPr,PPr2
                                                :  Byte;
                               Var Purch,PSales,
                                   PCleared,
                                   PBudget,
                                   RevisedBudget1 :  Double;
                               Var BValue1,
                                   BValue2      :  Double;
                                   Range        :  Boolean)  :  Double;
var
  RevisedBudget2 : Double;
  RevisedBudget3 : Double;
  RevisedBudget4 : Double;
  RevisedBudget5 : Double;
begin
  RevisedBudget2 := 0.0;
  RevisedBudget3 := 0.0;
  RevisedBudget4 := 0.0;
  RevisedBudget5 := 0.0;

  Result := Total_Profit_To_DateRange_RevBudgets(
              NType, NCode, PCr, PYr, PPr, PPr2, Purch, PSales, PCleared, PBudget,
              RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
              BValue1, BValue2, Range);
end;

// CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
Function Total_Profit_To_DateRange_RevBudgets(  NType            : Char;
                                                NCode            : Str20;
                                                PCr,PYr,PPr,PPr2 : Byte;
                                            Var Purch,PSales,
                                                PCleared,
                                                PBudget,
                                                RevisedBudget1,
                                                RevisedBudget2,
                                                RevisedBudget3,
                                                RevisedBudget4,
                                                RevisedBudget5   : Double;
                                            Var BValue1,
                                                BValue2          : Double;
                                                Range            : Boolean): Double;
Const
  Fnum  =  NHistF;
  NPath =  NHK;
Var
  NHKey,NHChk,
  NHKey2       :  Str255;
  Bal          :  Double;
Begin
  // Reset the return values
  Purch          := 0.0;
  PSales         := 0.0;
  PCleared       := 0.0;
  PBudget        := 0.0;
  Bal            := 0.0;
  RevisedBudget1 := 0.0;
  RevisedBudget2 := 0.0;
  RevisedBudget3 := 0.0;
  RevisedBudget4 := 0.0;
  RevisedBudget5 := 0.0;
  BValue1        := 0.0;
  BValue2        := 0.0;

{$IFDEF EXSQL}
  if SQLUtils.UsingSQLAlternateFuncs then
  begin
    SQLUtils.TotalProfitToDateRange(SetDrive, NType, NCode, PCr, PYr, PPr, PPr2,
      Range, Set_ACHist, Purch, PSales, Bal, PCleared, PBudget,
      RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
      BValue1, BValue2);
  end
  else
{$ENDIF}
  begin

    NHChK := FullNHistKey(NType, NCode, PCr, PYr, PPr);

    If (Range) then
      NHKey := FullNHistKey(NType, NCode, PCr, AdjYr(PYr, BOff), YTD)
    else
      NHKey := NHChk;

    If (NType In YTDSet + [NomHedCode, CustHistCde, CustHistPCde, CommitHCode]) and
       (Range) then  {** Get Last Valid YTD **}
    Begin
      NHKey2 := NHKey;
      Status := Find_Rec(B_GetLessEq, F[Fnum], Fnum, RecPtr[Fnum]^, NPath, NHKey2);

      If (StatusOk) and (CheckKey(NHChk, NHKey2, Length(NHChk) - 2, BOn)) and
         (NHist.Pr = YTD) then
        NHKey := NHKey2;
    end;

    If (PPr2 > PPr) and (PPr2 <> 0) and (Not Range) then
    Begin
      NHChK:=FullNHistKey(NType, NCode, PCr, PYr, PPr2);
    end;

    Status := Find_Rec(B_GetGEq, F[Fnum], Fnum, RecPtr[Fnum]^, NPath, NHKey);

    While (StatusOK) and (NHKey<=NHChk) do
    Begin

      If ((NType <> CustHistCde) or (Not (NHist.Pr In [YTD, YTDNCF]))) or
         (Set_ACHist) then
      Begin
        Purch  := Purch  + NHist.Purchases;
        PSales := PSales + NHist.Sales;
      end;

      Bal      := Bal + (NHist.Purchases - NHist.Sales);
      PCleared := PCleared + NHist.Cleared;

      If (Not (NHist.Pr In [YTD, YTDNCF])) then
      Begin
        PBudget        := PBudget + NHist.Budget;
        RevisedBudget1 := RevisedBudget1 + NHist.RevisedBudget1;
        RevisedBudget2 := RevisedBudget2 + NHist.RevisedBudget2;
        RevisedBudget3 := RevisedBudget3 + NHist.RevisedBudget3;
        RevisedBudget4 := RevisedBudget4 + NHist.RevisedBudget4;
        RevisedBudget5 := RevisedBudget5 + NHist.RevisedBudget5;
      end;

      BValue1 := BValue1 + NHist.Value1;
      BValue2 := BValue2 + NHist.Value2;

      Status := Find_Rec(B_GetNext, F[Fnum], Fnum, RecPtr[Fnum]^, NPath, NHKey);
    end;

  end;

  Result := Bal;

end; {Func..}


  Function Total_Profit_To_Date(NType        :  Char;
                                NCode        :  Str20;
                                PCr,PYr,PPr  :  Byte;
                            Var Purch,PSales,
                                PCleared,
                                PBudget,
                                PRBudget     :  Double;
                            Var BValue1,
                                BValue2      :  Double;
                                Range        :  Boolean)  :  Double;

  Begin
    Result:=Total_Profit_To_DateRange(NType,NCode,PCr,PYr,PPr,0,Purch,PSales,PCleared,PBudget,PRBudget,BValue1,BValue2,Range);
  end;


  { ============== Get Profit To Current Period ============== }

  Function Profit_To_DateRange(NType        :  Char;
                               NCode        :  Str20;
                               PCr,PYr,PPr,PPr2
                                            :  Byte;
                           Var Purch,PSales,
                               PCleared     :  Double;
                               Range        :  Boolean)  :  Double;


   Var
     PBudget,
     PBudget2  :  Double;
     BV1,
     BV2       :  Double;


   Begin

     PBudget:=0;
     PBudget2:=0;

     BV1:=0;
     BV2:=0;

     Result:=Total_Profit_to_DateRange(NType,NCode,PCr,PYr,PPr,PPr2,Purch,PSales,PCleared,PBudget,PBudget2,BV1,BV2,Range);


   end; {Func..}




{ ============== Get Profit To Current Period ============== }

Function Profit_To_Date(NType        :  Char;
                        NCode        :  Str20;
                        PCr,PYr,PPr  :  Byte;
                    Var Purch,PSales,
                        PCleared     :  Double;
                        Range        :  Boolean)  :  Double;


Var
  PBudget,
  PBudget2  :  Double;
  BV1,
  BV2       :  Double;


Begin

  PBudget:=0;
  PBudget2:=0;

  BV1:=0;
  BV2:=0;

  Profit_To_Date:=Total_Profit_to_Date(NType,NCode,PCr,PYr,PPr,Purch,PSales,PCleared,PBudget,PBudget2,BV1,BV2,Range);


end; {Func..}


{ =========== Return Vat Rate No. ============ }

Function GetVATNo(Vcode,VICode :  Char)  :  VATType;


Var
  n         :  VATType;
  FoundYet  :  Boolean;


Begin
  n:=Rate3;

  FoundYet:=(Vcode In VATEqRt3);

  If (Not FoundYet) then
  Begin

    n:=Rate4;

    FoundYet:=(VCode In VATEqRt4);

  end;

  If (Not FoundYet) and (VICode In VATSet) and (VCode In VATEqStd) then {* Try and find inclusive specific rate *}
  Begin
    n:=GetVATNo(VICode,#0);

    FoundYet:=(n>=VStart) and (n<=VEnd);
  end;

  If (Not FoundYet) then
  Begin

    n:=Standard;

    FoundYet:=(Vcode In VATEqStd);

  end;


  If (Vcode<>C0) and (Not FoundYet) then
  Begin
    While (n<=VEnd) and (Not FoundYet) do
    With SyssVAT^.VATRates do
    Begin

      FoundYet:=(Vcode=VAT[n].Code);
      Inc(n);
    end;

    If (FoundYet) then
      Dec(n);
  end;

  If (Not FoundYet) then
    n:=Spare8;


  GetVATNo:=n;

end; {Func..}


{ =========== Return Vat Rate No. ============ }

Function GetIVATNo(Vcode  :  Char)  :  VATType;


Var
  n         :  VATType;
  FoundYet  :  Boolean;


Begin
  If (VCode In VATSet) then
  Begin
    n:=GetVATNo(VCode,#0);

    FoundYet:=(n>=VStart) and (n<=VEnd);

  end
  else
  Begin
    n:=Standard;

    FoundYet:=BOn;
  end;



  GetIVATNo:=n;

end; {Func..}


{ =========== Return Vat Rate No. ============ }

Function GetVATCIndex(Vcode :  Char;
                      UseC  :  Boolean)  :  Integer;


Var
  n         :  VATType;
  FoundYet  :  Boolean;


Begin
  Result:=Ord(VEnd)+3-Ord(UseC);

  FoundYet:=(Vcode In VATEqRt3);

  If (Not FoundYet) then
  Begin

    Result:=Ord(VEnd)+4-Ord(UseC);

    FoundYet:=(VCode In VATEqRt4);

  end;



  If (Not FoundYet) then
  Begin

    Result:=Ord(VEnd)+1;

    FoundYet:=(Vcode=VATICode);

  end;


    If (Not FoundYet) then
  Begin

    Result:=Ord(VEnd)+2-Ord(UseC);

    FoundYet:=(Vcode=VATMCode);

  end;

  If (Vcode<>C0) and (Not FoundYet) then
  Begin
    Result:=0;
    n:=VStart;

    While (n<=VEnd) and (Not FoundYet) do
    With SyssVAT.VATRates do
    Begin
      FoundYet:=(Vcode=VAT[n].Code);
      Inc(n);
      Inc(Result);
    end;

    If (FoundYet) then
      Dec(Result);
  end;

  If (Not FoundYet) then
    Result:=0;


  GetVATCIndex:=Result;

end; {Func..}


{ =========== Return Vat Rate No. ============ }

Function GetVATIndex(Vcode :  Char)  :  Integer;


Begin
  Result:=GetVATCIndex(Vcode,BOff);

end; {Func..}


{ ======== Function to Check if an account may be deleted ========= }

Function Ok2DelAcc(CCode  :  Str10)  :  Boolean;

Begin

  Result:=(Not CheckExsists(CCode,InvF,InvCustK));

end;



{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetTempFNameExt(SwapName,ExtN :  Str10)  :  Str255;


Var
  n,IOChk     :  Integer;

  SwapFileName,
  TDirN       :  Str255;
  NumStr      :  Str10;

Begin
  {$I-}

  n:=1;

  TDirN:=GetSwapDir;

  Repeat

    Str(n:0,NumStr);

    SwapFileName:=TDirN+SwapName+NumStr+ExtN;

    Inc(n);

  Until (Not FileExists(SetDrive+SwapFileName)) or (n>9999);

  {$I+}

  Result:=SetDrive+SwapFileName;
end; {Func..}


{ ============= Function to Return Next Available Swap File Name, For MultiUser reasons =============== }

Function GetTempFName(SwapName :  Str10)  :  Str255;


Begin
  Result:=GetTempFNameExt(SwapName,'.SWP');
end; {Func..}

// -----------------------------------------------------------------------------

// MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
// than uploading them to the network Exchequer\Swap folder
Function GetWinTempPrintingFilename (Const Extension : ShortString) : ShortString;
Var
  sWinTempDir : ANSIString;
Begin // GetWinTempPrintingFilename
  // Get windows temporary files directory and convert path to shortfilename equivalent to
  // minimize the length for the legacy routines it will be passed through.  It will come with
  // a trailing \ automatically.
  sWinTempDir := WinGetShortPathName(WinGetWindowsTempDir);
  If DirectoryExists(sWinTempDir) Then
  Begin
    // Note: Can't use WinAPI GetTempFileName as that can't handle files of a non-.Tmp extension
    // so we will have to roll our own.  Need to keep to short file name for legacy reasons
    Repeat
      // Use the Ex prefix instead of !REP in order to identify the file as part of Exchequer - !REP is not very descriptive
      Result := sWinTempDir + 'Ex' + IntToStr(RandomRange(1, 999999)) + Extension;
    Until (Not FileExists(Result));
  End // If DirectoryExists(sWinTempDir)
  Else
  Begin
    // Revert to using legacy Exchequer SWAP directory
    Result := GetTempFNameExt('!REP', Extension);
  End; // Else
End; // GetWinTempPrintingFilename

//-------------------------------------------------------------------------

function GetWindowsTempFileName(SwapName: Str10): Str255;
var
  Dir, Prefix, Filename: string;
begin
  Dir := StringOfChar(#32, MAX_PATH);
  GetTempPath(Length(Dir), PChar(Dir));
  Dir := IncludeTrailingPathDelimiter(Trim(Dir));
  Filename := StringOfChar(#32, MAX_PATH);
  Prefix := SwapName;
  GetTempFileName(PChar(Dir), PChar(Prefix), 0, PChar(Filename));
  Result := Trim(Filename);
end;

// -----------------------------------------------------------------------------

{ ============ Function to set AllowHot key =========== }

Procedure SetAllowHotKey(State      :  Boolean;
                     Var PrevState  :  Boolean);

Begin
  Case State of

    BOff  :  Begin
               PrevState:=AllowHotKey;
               AllowHotKey:=State;
             end;
    BOn   :  AllowHotKey:=PrevState;

  end; {Case..}

end;


{ =============== Routines to manage resource monitoring =========== }

Procedure Init_ResourceMon;

Const
  ResNames  :  Array[0..1] of PChar = ('RSRC32','_MyGetFreeSystemResources32@4');

Var
  DLLAddr  :  TFarProc;

Begin
  _MyGetFreeSystemResources32:=nil;

  _MyGSRHandle:=LoadLibrary(ResNames[0]);

  try
    If (_MyGSRHandle>HInstance_Error) then
    Begin
      DLLAddr:=GetProcAddress(_MyGSRHandle,ResNames[1]);

      If (DLLAddr<>nil) then
        _MyGetFreeSystemResources32:=DLLAddr
      else
      Begin
        _MyGSRHandle:=0;
        FreeLibrary(_MyGSRHandle);
      end;
    end
    else
      _MyGSRHandle:=0;

  except

    FreeLibrary(_MyGSRHandle);
    _MyGSRHandle:=0;

    _MyGetFreeSystemResources32:=nil;


  end; {except..}

end; {Proc..}

Function Get_FreeResources  :  Integer;
Begin

  If (_MyGSRHandle<>0) then
    Result:=_MyGetFreeSystemResources32(gfsr_SystemResources)
  else
    Result:=100;
end;


Procedure Free_ResourceMon;
Begin
  If (_MyGSRHandle<>0) then
  Begin
    FreeLibrary(_MyGSRHandle);

    _MyGSRHandle:=0;

    _MyGetFreeSystemResources32:=nil;
  end;
end;

Function Color_ResourceMon(Value  :  Integer)  :  TColor;

Begin

  Case Value of

    

    0..20   :  Result:=clRed;

    21..35  :  Result:=$000080FF;

    36..50  :  Result:=clYellow;

    else       Result:=clLime;

  end; {Case..}


end;


Function FreeDiskSpacePcnt  :  Double;

Var
  lpRootN  :  PChar;
  lpSPC,
  lpBPS,
  lpNOFC,
  lpTNpC   :  DWord;

Begin
  Result:=0.0;

  lpSPC:=0; lpBPS:=0; lpNOFC:=0; lpTNpC:=0;

  lpRootN:=StrAlloc(255);
  Try
    If (SetDrive<>'') then
      StrPCopy(lpRootN,Copy(SetDrive,1,2)+'\')
    else
      StrPCopy(lpRootN,SetDrive);


    If  GetDiskFreeSpace(lpRootN,lpSPC,lpBPS,lpNOFC,lpTNpc) then
    Begin
      Result:=DivWChk(lpNOFC,lpTNPC)*100;
    end
    else
      Result:=100.0;
  Finally
    StrDispose(lpRootN);
  end;
end;



procedure Delay(dt  :  Word;
                SAPM:  Boolean);

Var
  ThTimeS,
  thTimeN   :  TDateTime;

  thGap     :  Double;

Begin
  thTimeS:=Now;

  thGap:=dt/1e8;

  Repeat
    thTimeN:=Now-ThTimeS;

    If (SAPM) then
      Application.ProcessMessages;

  Until (thTimeN>thgap);

end;



{ ================= Various routines to time btrieve =============== }

{$IFDEF DBD}

  { Returns time in milli-seconds }
Function TimeVal : LongInt;
Var
  Hour, Min, Sec, MSec : Word;
begin
  DecodeTime(Now, Hour, Min, Sec, MSec);

  Result := MSec + (1000 * (Sec + (60 * (Min + (Hour * 60)))));
end;

  Procedure StartBDebug(DN  :  Byte; DT  :  Str10);

  Begin
    DebugTime[DN,BOff]:=Timeval;
    DebugTitle[DN]:=DT;
  end;


  Procedure StopBDebug(DN  :  Byte);

  Begin
    DebugTime[DN,BOn]:=TimeVal-DebugTime[DN,Boff];

    DebugForm.Add(DebugTitle[DN]+' : '+Form_Int(DebugTime[DN,BOn],0));
  end;

  Procedure FinishBDebug;

  Var
    n        :  Integer;
    TotTime  :  LongInt;

    RLines   :  ANSIString;

    Buff     :  PChar;

  Begin
    TotTime:=0;

    For n:=Low(DebugTime) to High(DebugTime) do
       TotTime:=TotTime+DebugTime[n,Bon];

    DebugForm.Add('    -------------- ');

    DebugForm.Add('Total Time : '+Form_Int(TotTime,0));

    DebugForm.Add('    -------------- ');

    RLines:='';

    Buff:=StrAlloc(4096);

    try
      With DebugForm,DeBugBox1,Clipboard do
      Begin
        For n:=0 to Pred(DebugList.Items.Count) do
        Begin
          RLines:=RLines+DebugList.Items[n]+#13+#10;
        end;

        For n:=0 to Length(Rlines) do
          Buff[n]:=RLines[n];

        StrPCopy(Buff,RLines);

        ClipBoard.SetTextBuf(Buff);


      end;

    finally


    end; {try..}

  end;

{$ENDIF}




{ =========== Procedure to find next visible nhist record based on period given ======= }

Procedure Find_FirstHist(Const NType  :  Char;
                         Const NHCtrl :  TNHCtrlRec;
                         Var   fPr,fYr:  Byte);


Const
  Fnum       =  NHistF;
  Keypath    =  NHK;

Var
  KeyChk,
  KeyS,
  KeyS2       :  Str255;


Begin
  With NHCtrl do
  Begin
    Blank(KeyChk,Sizeof(KeyChk));
    Blank(KeyS,Sizeof(KeyS));
    Blank(KeyS2,Sizeof(KeyS2));

    KeyChk:=PartNHistKey(NType,NHCCode,NHCr);

    Keys:=FullNHistKey(NType,NHCCode,NHCr,NHYr,NHPr);

    KeyS2:=KeyS;

    Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Not CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) or (Not StatusOk) then
    Begin

      KeyS:=KeyS2;

      Status:=Find_Rec(B_GetLessEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);
    end;

    If (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (StatusOk) then
    With NHist do
    Begin
      fPr:=Pr;
      fYr:=Yr;
    end
    else
    Begin
      fPr:=0;
      fYr:=0;
    end;
  end;
end;



Initialization
  {$IFNDEF EDLL}

    { Don't initialise the resource monitor if its the Enterprise DLL }
    Init_ResourceMon;

    {$IFDEF DBD}
      FillChar(DebugTime,Sizeof(DebugTime),0);
      FillChar(DebugTitle,Sizeof(DebugTitle),0);

    {$ENDIF}

  {$ENDIF}

  Set_ACHist:=BOff;

  // MH 12/03/2012 v6.10 ABSEXCH-11937: Stash reports locally in Windows\Temp folder rather
  // than uploading them to the network Exchequer\Swap folder
  Randomize;
end.
