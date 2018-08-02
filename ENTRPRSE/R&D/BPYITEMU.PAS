unit BPyItemU;

interface

{$I DefOvr.Inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SBSPanel,GlobVar,VarConst,BTSupU1,ExWrap1U, BorBtns,
  SupListU,CustSupU,SBSComp,

  {$IFDEF CU}
    CustIntU,
    CustWinU,
    OInv,
  {$ENDIF}

  Recon3U, Menus;

// CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns
const
  BIM_PPD_AVAILABLE_COL = 7;
  BIM_TOTAL_AFTER_PPD_COL = 8;
  BIM_PPD_EXPIRY_COL = 9;
  BIM_PPD_STATUS_COL = 10;

  // CJS 2015-05-18 - T2-160 - Set/Unset PPD
  // Values for thBatchPayPPDStatus
  PPD_BATCHPAY_UNSET = 0;
  PPD_BATCHPAY_SET = 1;

type


  TBIMList  =  Class(TCLMList)
  Public
    BatchCtrl    :  PassWordRec;
    CurrCol      :  Integer;
    CCode        :  Str10;

    {$IFDEF Cu}
      CWId,CWEvent :  LongInt;

      CustomEvent  :  TCustomEvent;
      RunCEVent    :  Boolean;
    {$ENDIF}

    // Calculate and return the value for the 'Outstanding' column, for the
    // currently selected row
    Function AmountOutstanding(ForcePPD: Boolean = False): Double;

    Function SetFilter  :  Str255; Override;

    Function CheckRowEmph :  Byte; Override;

    Function OutLine(Col  :  Byte)  :  Str255; Override;

    // CJS 2015-05-13 - v7.0.14 - PPD - T2-159 - PPD Columns - override method
    // to apply RAG colours to PPD Expiry column
    procedure ModifyCell(Col, Row: Integer; var CellDetails: TCellDetails); override;

  end;


type
  TBatchItems = class(TForm)
    CListBtnPanel: TSBSPanel;
    CSBox: TScrollBox;
    CHedPanel: TSBSPanel;
    CLORefLab: TSBSPanel;
    CLDueLab: TSBSPanel;
    CLYRefLab: TSBSPanel;
    CLOSLab: TSBSPanel;
    CLAMTLab: TSBSPanel;
    CLDateLab: TSBSPanel;
    CLORefPanel: TSBSPanel;
    CLDatePanel: TSBSPanel;
    CLAMTPanel: TSBSPanel;
    CLOSPAnel: TSBSPanel;
    CLStatPanel: TSBSPanel;
    CLYRefPanel: TSBSPanel;
    CLDuePanel: TSBSPanel;
    CLStatLab: TSBSPanel;
    CBtnPanel: TSBSPanel;
    ClsCP1Btn: TButton;
    CCBSBox: TScrollBox;
    btnUntag: TButton;
    btnTag: TButton;
    GenCP3Btn: TButton;
    btnPartAllocate: TButton;
    PopupMenu1: TPopupMenu;
    Tag1: TMenuItem;
    UnTAG1: TMenuItem;
    ReCalc1: TMenuItem;
    Find1: TMenuItem;
    N2: TMenuItem;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    btnWriteOff: TButton;
    Discount1: TMenuItem;
    pnlPPDAvailable: TSBSPanel;
    pnlTotalAfterPPD: TSBSPanel;
    pnlPPDExpiry: TSBSPanel;
    pnlPPDStatus: TSBSPanel;
    lblPPDAvailable: TSBSPanel;
    lblTotalAfterPPD: TSBSPanel;
    lblPPDExpiry: TSBSPanel;
    lblPPDStatus: TSBSPanel;
    btnSetUnsetPPD: TButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure CLORefPanelMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CLORefLabMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CLORefLabMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure ClsCP1BtnClick(Sender: TObject);
    procedure GenCP3BtnClick(Sender: TObject);
    procedure btnTagClick(Sender: TObject);
    procedure btnPartAllocateClick(Sender: TObject);
    procedure btnWriteOffClick(Sender: TObject);
    procedure CBtnPanelDblClick(Sender: TObject);
    procedure btnSetUnsetPPDClick(Sender: TObject);
  private
    RecMode,
    BeenIn,
    InHBeen,
    JustCreated,
    StoreCoord,
    LastCoord,
    SetDefault,
    fNeedCUpdate,
    fDoingClose,
    GotCoord,
    CanDelete    :  Boolean;

    PagePoint    :  Array[0..4] of TPoint;

    StartSize,
    InitSize     :  TPoint;

    DispTransPtr
                 :  Pointer;

    //PR: 21/08/2015 ABSEXCH-16743
    DoubleClick : Boolean;


    procedure Find_FormCoord;

    procedure Store_FormCoord(UpMode  :  Boolean);

    procedure FormSetOfSet;

    Function ScanMode  :  Boolean;

    procedure Display_Trans(Mode  :  Byte);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo); Message WM_GetMinMaxInfo;



    Procedure Send_UpdateList(Mode   :  Integer);

    procedure ShowRightMeny(X,Y,Mode  :  Integer);

    Procedure  SetNeedCUpdate(B  :  Boolean);

    Property NeedCUpDate :  Boolean Read fNeedCUpDate Write SetNeedCUpdate;

    Procedure BACS_TagDoc(Mode     :  Byte;
                          LUpdate  :  Boolean;
                          TOk,
                          UOk      :  Boolean);

    Procedure BACS_PartPayDoc(Mode     :  Byte);

    Procedure BACS_SetDocDisc(Mode  :  Byte);

    procedure SetHelpContextIDs; // NF: 20/06/06

    // CJS 2015-05-18 - T2-160 - Set/Unset PPD
    procedure GiveTakePPD;
    procedure ApplyPPD(Amount: Double);

    // Updates the UI (e.g. button states) based on the currently selected
    // transaction in the list
    procedure UpdateUIState;

  public
    { Public declarations }

    ExLocal      :  TdExLocal;

    ListOfSet    :  Integer;

    MULCtrlO     :  TBIMList;

    DDownTitle   :  Str20;
    TaggedByAccount    :  Boolean;


    procedure FormDesign;

    procedure RefreshList(ShowLines,
                          IgMsg      :  Boolean);

    procedure FormBuildList(ShowLines  :  Boolean);

    procedure SetCaption;

    procedure SetFormProperties;

  end;


Procedure Set_BIFormMode(State  :  Boolean);


Function Compare_Dates(ToDate,DlDate  :  Str10;
                       DrvMode        :  Byte;
                       Interval       :  Integer)  :  LongInt;

Function AgedPos(AgedDate,
                 AsAtDate  :  LongDate;
                 DrvMode   :  Byte;
                 Interval  :  Integer)  :  Integer;

Procedure MasterAged(Var AgedAry  :  BACSAnalType;
                         AgedDate,
                         AsAtDate :  LongDate;
                         Amount   :  Real;
                         DrvMode  :  Byte;
                         Interval :  Integer);

Function FullBACSCtrlKey(SPMode  :  Boolean) :  Str20;

Function BACS_GetRunNo(UpDate,
                       SalesDoc  :  Boolean;
                       MTExLocal :  TdMTExLocalPtr)  :  Longint;


Procedure Set_AgedStr(Var  AgeTit  :  AgedTitType;
                           MaxN,
                           AgeType,
                           AgeInt  :  Byte);


Procedure BACS_CtrlPut(Fnum,
                       Keypath      :  Integer;
                   Var BACSCtrlRec  :  PassWordRec;
                       MTExLocal    :  TdMTExLocalPtr;
                       PutMode      :  Byte);

Function Refresh_BACSCtrl(Var BACSCtrlRec  :  PassWordRec)  :  Boolean;

Procedure BACS_CtrlGet(Fnum,
                       Keypath    :  Integer;
                   Var BACSCtlRec :  PassWordRec;
                       SPMode     :  Boolean;
                       MTExLocal  :  TdMTExLocalPtr);

Function BACSUsrKey2(SPMode  :  Boolean) :  Str20;


Procedure BACS_UsrGet(SPMode     :  Boolean;
                  Var UsrCount,
                      UsrAddr    :  LongInt;
                      GetMode    :  Byte);

Procedure BACS_UsrUnLock(UsrAddr,UsrId    :  LongInt;
                         SPMode,
                         DelUsrRec  :  Boolean);


Function BACS_HasUsers(SPMode,DelDormant :  Boolean;
                       UsrCount          :  LongInt)  :  Boolean;

Procedure ForceInvSDisc(Var  InvR, EInv  :  InvRec;
                             BACSCtrl    :  PassWordRec;
                             Mode        :  Byte);

Function BatchDocSign(SPMode  :  Boolean;
                      Value   :  Double )  :  Double;

Function BatchDocHed(SPMode  :  Boolean)  :  DocTypes;

Function BatchPTit(SPMode  :  Boolean)  :  Str20;

// CJS 2016-07-06 - ABSEXCH-17383 - amendments for eRCT Plugin
Procedure BACS_TagTransaction(Mode     : Byte;
                              LUpdate  : Boolean;
                              TOk,
                              UOk      : Boolean;
                              KeyPath  : Integer;
                              var ExLocal  : TdExLocal;
                              var BatchCtrl: PasswordRec;
                              MULCtrlO : TBIMList = nil;
                              Owner: TBatchItems = nil);

// MH 07/02/2018 2018-R1 ABSEXCH-19292: Added new method to allow eRCT Plug-In to validate the Account is valid
Function BACS_ValidateAccount (var ExLocal: TdExLocal; CustCode: string) : Integer;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  Math,
  MathUtil,
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,
  BTSupU2,
  BTSupU3,
  BTKeys1U,
  BTSFrmU1,
  CmpCtrlU,
  ColCtrlU,
  ComnUnit,
  ComnU2,
  CurrncyU,
  CLPALU,

  {$IFDEF GF}
    FindCtlU,
  {$ENDIF}

  ExThrd2U,

  {$IFDEF CL_On}
    LedgSupU,
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
  {$ENDIF}


  DocSupU1,
  InvListU,
  SysU1,
  SysU2,
  Tranl1U,
  PWarnU,
  APIUtil,
  SalTxl1U,

  StrUtil,

  // CJS 2015-02-27 - ABSEXCH-15298 - T1-011 - Disable Discount button for transactions >= 01/04/2015
  TransactionHelperU,

  StrUtils,
  PromptPaymentDiscountFuncs,
  oSystemSetup,
  MiscU,
  SavePos;



{$R *.DFM}

Var
  BIFormMode  :  Boolean;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_BIFormMode(State  :  Boolean);

Begin

  BIFormMode:=State;

end;


{$I BITI1U.PAS}



  Function Compare_Dates(ToDate,DlDate  :  Str10;
                         DrvMode        :  Byte;
                         Interval       :  Integer)  :  LongInt;


  Var
    Res  :  LongInt;


  Begin
    Res:=0;

    Case DrvMode of

      1  :  Res:=NoDays(Todate,DlDate);

      2  :  Res:=Round(DivwChk(NoDays(ToDate,DlDate),7));

      else
            Res:=MonthDiff(ToDate,DlDate);

    end;

    If (Res<0) and (Res>(Interval*-1)) then  {* Force a not due as otherwise truncing will nullify it *}
      Res:=Interval*-1;



    Compare_Dates:=Res;

  end; {Func..}


  { ===== Function to Return Ageing Position ===== }

  Function AgedPos(AgedDate,
                   AsAtDate  :  LongDate;
                   DrvMode   :  Byte;
                   Interval  :  Integer)  :  Integer;
  Var
    TmpI  :  Integer;

  Begin

    TmpI:=Trunc(DivWChk(Compare_Dates(AgedDate,AsAtDate,DrvMode,Interval),Interval));

    If (TmpI=0) then {* Include all due now in Col1 *}
      TmpI:=1
    else
      If (TmpI<0) then
        TmpI:=0
      else
        If (TmpI>Pred(NoBacsTot)) then
          TmpI:=Pred(NoBacsTot);

    AgedPos:=TmpI;

  end;


  { ===== Procedure to Return Ageing Based upon Interval ===== }


  Procedure MasterAged(Var AgedAry  :  BACSAnalType;
                           AgedDate,
                           AsAtDate :  LongDate;
                           Amount   :  Real;
                           DrvMode  :  Byte;
                           Interval :  Integer);



  Var
    Diff  :  Integer;


  Begin

    Diff:=AgedPos(AgedDate,AsAtDate,DrvMode,Interval);

    Case Diff of

       0..2    :  AgedAry[Diff+1]:=AgedAry[Diff+1]+Amount;

       else       If (Diff>=0) then
                    AgedAry[NoBacsTot]:=AgedAry[NoBacsTot]+Amount
                  else
                    AgedAry[1]:=AgedAry[1]+Amount;

    end;

    AgedAry[0]:=AgedAry[0]+Amount;

  end; {Procedure..}


{ ======== Function to Create BACS Ctrl Str =======}

Function FullBACSCtrlKey(SPMode  :  Boolean) :  Str20;


Begin

  FullBACSCtrlKey:=PartCCKey(MBACSCode,MBACSCTL)+HelpKStop+FullNomKey(FirstAddrD-Ord(SPMode))+HelpKStop;

end; {Func..}



Function  BACSLCheckExsists(KeyR  :  AnyStr;
                            FileNum,KeyPath
                                  :  Integer;
                            MTExLocal
                                  :  TdMTExLocalPtr)  :  Boolean;

Var
  KeyS     :  AnyStr;
  TmpFn    :  FileVar;

  TmpStat,
  TmpKPath,
  CEStatus :  Integer;

  TmpRecAddr
           :  LongInt;


Begin
  KeyS:=KeyR;

  With MTExLocal^ do
  Begin
    TmpFn:=LocalF^[FileNum];

    TmpKPath:=GetPosKey;

    TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOff,BOff);


    CEStatus:=Find_RecCId(B_GetGEq+B_KeyOnly,TmpFn,FileNum,LRecPtr[FileNum]^,KeyPath,KeyS,ExClientId);

    Result:=((CEStatus=0) and (CheckKey(KeyR,KeyS,Length(KeyR),BOn)));

    TmpStat:=LPresrv_BTPos(Filenum,TmpKPath,TmpFn,TmpRecAddr,BOn,BOff);
  end;
end;


{ ========== Function to Return Next Run No ========= }

Function BACS_GetRunNo(UpDate,
                       SalesDoc  :  Boolean;
                       MTExLocal :  TdMTExLocalPtr)  :  Longint;

Var
  TmpS  :  Str5;
  NotDupli
        :  Boolean;
  DocHed:  DocTypes;


Begin
  If (SaleSdoc) then
    DocHed:=SRC
  else
    DocHed:=PPY;

  TmpS:=DocNosXLate[SDG];

  DocNosXlate[SDG]:='PAY';

  NotDupli:=BOn;

  Result:=0;

  Repeat
  {$IFDEF EXSQL}
    if SQLUtils.UsingSQL and Assigned(MTExLocal) then
      Result:= MTExLocal.LGetNextCount(SDG,UpDate,BOff,0)
    else
  {$ENDIF}
      Result:=GetNextCount(SDG,UpDate,BOff,0);
      
    If (UpDate) then
    Begin
      If (Not Assigned(MTExLocal)) then
        NotDupli:=(Not CheckExsists(PAY_RunNo(DocHed,Result),InvF,InvBatchK))
      else
        With MTExLocal^ do
          NotDupli:=(Not BACSLCheckExsists(PAY_RunNo(DocHed,Result),InvF,InvBatchK,MTExLocal))

    end;

  Until (Not UpDate) or (NotDupli);


  DocNosXLate[SDG]:=TmpS;

end;


{ ========== Procedure to Return up to 4 Aged titles ======== }


Procedure Set_AgedStr(Var  AgeTit  :  AgedTitType;
                           MaxN,
                           AgeType,
                           AgeInt  :  Byte);


Var
  n  :  Byte;


Begin

  Blank(AgeTit,Sizeof(AgeTit));

  For n:=1 to MaxN  do
  Begin

    AgeTit[n]:=Form_Int((AgeInt*n),0)+' '+AgedHed[AgeType];

    If ((n*AgeInt)>1) then
      AgeTit[n]:=AgeTit[n]+'s';

    If (n=MaxN) then
      AgeTit[n]:=AgeTit[n]+'+';

  end;

end; {Proc..}


{ =========== Procedure to Get/Initialise Bacs Ctrl Record ========== }


Procedure BACS_CtrlGet(Fnum,
                       Keypath    :  Integer;
                   Var BACSCtlRec :  PassWordRec;
                       SPMode     :  Boolean;
                       MTExLocal  :  TdMTExLocalPtr);




Var
  KeyS  :  Str255;


Begin

  KeyS:=FullBACSCtrlKey(SPMode);


  If (Not Assigned(MTExLocal)) then
  Begin
    Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (Not StatusOk) then {* Initialise *}
    With PassWord do
    With BACSCRec do
    Begin

      ResetRec(Fnum);


      PassWord.RecPfix:=MBACSCode;
      PassWord.Subtype:=MBACSCTL;

      TagRunNo:=BACS_GetRunNo(BOn,SPMode,Nil);

      PayType:=BACSCCode;

      InvCurr:=0;

      {$IFDEF MC_On}

        PayCurr:=1;

      {$ENDIF}


      SalesMode:=SPMode;

      If (Not SalesMode) then
        CQStart:=IntStr(Get_NextChequeNo(BOff));


      AgeType:=3;

      AgeInt:=1;

      TagAsDate:=Today;

      TagCode:=HelpKStop+FullNomKey(FirstAddrD-Ord(SalesMode))+HelpKStop;

      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      BACSCtlRec:=PassWord;

    end
    else
      BACSCtlRec:=PassWord;
  end
  else
  With MTExLocal^ do
  Begin
    LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);

    If (Not LStatusOk) then {* Initialise *}
    With LPassWord do
    With BACSCRec do
    Begin

      LResetRec(Fnum);


      LPassWord.RecPfix:=MBACSCode;
      LPassWord.Subtype:=MBACSCTL;

      TagRunNo:=BACS_GetRunNo(BOn,SPMode,MTExLocal);

      PayType:=BACSCCode;

      InvCurr:=0;

      {$IFDEF MC_On}

        PayCurr:=1;

      {$ENDIF}


      SalesMode:=SPMode;

      If (Not SalesMode) then
        CQStart:=IntStr(Get_NextChequeNo(BOff));


      AgeType:=3;

      AgeInt:=1;

      TagAsDate:=Today;

      TagCode:=HelpKStop+FullNomKey(FirstAddrD-Ord(SalesMode))+HelpKStop;

      LStatus:=LAdd_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      BACSCtlRec:=LPassWord;

    end
    else
      BACSCtlRec:=LPassWord;


  end;
end; {Proc..}


{ ========= Proc to Store/Update BACS Ctrl Rec ========== }
{Modes : 0 Lock, update and unlock in one operation.
         1 Lock only, do not update.
         2 Update and do not lock only}

Procedure BACS_CtrlPut(Fnum,
                       Keypath      :  Integer;
                   Var BACSCtrlRec  :  PassWordRec;
                       MTExLocal    :  TdMTExLocalPtr;
                       PutMode      :  Byte);



Var
  TmpPWord  :  PassWordRec;

  LOk,
  Locked    :  Boolean;

  KeyS      :  Str255;

  LAddr     :  LongInt;


Begin

  Locked:=BOff;

  TmpPWord:=BACSCtrlRec;

  If (Not Assigned(MTExLocal)) then
  Begin

    KeyS:=FullBACSCtrlKey(BACSCtrlRec.BacsCRec.SalesMode);

    If (PutMode In [0..2]) then
      LOk:=GetMultiRecAddr(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,LAddr)
    else
    Begin
      LOK:=BOn; Locked:=BOn;
    end;

    If (LOk) and (Locked) and (PutMode<>1) then
    Begin

      PassWord:=TmpPWord;

      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (PutMode<>2) then
        Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);


    end
    else
      If (LOk and Locked) and (PutMode=1) then
        BACSCtrlRec:=PassWord;

  end
  else
  With MTExLocal^ do
  Begin
    KeyS:=FullBACSCtrlKey(BACSCtrlRec.BacsCRec.SalesMode);

    If (PutMode In [0..2]) then
      LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked)
    else
    Begin
      LOK:=BOn; Locked:=BOn;
    end;


    If (LOk) and (Locked) and (PutMode<>1)  then
    Begin
      LGetRecAddr(Fnum);

      LPassWord:=TmpPWord;

      LStatus:=LPut_Rec(Fnum,KeyPath);

      LReport_BError(Fnum,LStatus);

      If (PutMode<>2) then
        LStatus:=LUnLockMLock(Fnum);

    end
    else
      If (LOk and Locked) and (PutMode=1) then
        BACSCtrlRec:=LPassWord;

  end;


end; {Proc..}


{ == Function to refresh BacsCrlRec  == }

Function Refresh_BACSCtrl(Var BACSCtrlRec  :  PassWordRec)  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  TmpPWord  :  PassWordRec;

  KeyS      :  Str255;

  TKeypath,
  TmpStat      :  Integer;
  TmpRecAddr   :  LongInt;


Begin
  TmpPWord:=PassWord;

  TKeypath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyS:=FullBACSCtrlKey(BACSCtrlRec.BacsCRec.SalesMode);

  Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  Result:=StatusOk;

  If (StatusOk) then {* Initialise *}
    BACSCtrlRec:=PassWord;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWord;
end;


{ ======== Function to Create First part of BACS Usr Str =======}

Function BACSUsrKey1(SPMode  :  Boolean) :  Str20;


Begin

  Result:=Chr(1+Ord(SPMode));

end; {Func..}


{ ======== Function to Create BACS Usr Str 2=======}

Function BACSUsrKey2(SPMode  :  Boolean) :  Str20;


Begin

  Result:=PartCCKey(MBACSCode,MBACSUSR)+BACSUsrKey1(SPMode);

end; {Func..}

{ ======== Function to Create BACS Ctrl Str =======}

Function BACSUsrKey3(SPMode  :  Boolean; UsrNo  :  LongInt) :  Str20;


Begin

  Result:=BACSUsrKey1(SPMode)+HelpKStop+FullNomKey(UsrNo)+HelpKStop;

end; {Func..}


{ ======== Function to Create BACS Usr Str =======}

Function FullBACSUsrKey(SPMode  :  Boolean; UsrNo  :  LongInt) :  Str20;


Begin

  Result:=PartCCKey(MBACSCode,MBACSUSR)+BACSUsrKey3(SPMode,UsrNo);

end; {Func..}


{ =========== Procedure to Get/Initialise Bacs User Record ========== }
{Get Mode :-
 0 = Attempt to create or resuse record.
 1 =   As 0 + leave locked.
}


Procedure BACS_UsrGet(SPMode     :  Boolean;
                  Var UsrCount,
                      UsrAddr    :  LongInt;
                      GetMode    :  Byte);

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  TmpPWord  :  PassWordRec;

  KeyS      :  Str255;

  FoundOk,
  Locked,
  LOk       :  Boolean;

  GStatus,
  TKeypath,
  TmpStat   :  Integer;
  TmpRecAddr:  LongInt;

  TimeR
            :  TimeTyp;


Begin
  TmpPWord:=PassWord;  Locked:=BOff;

  TKeypath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  Repeat
    LOk:=BOff;

    KeyS:=FullBACSUsrKey(SPMode,UsrCount);

    GStatus:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

    If (GStatus=0) then {Attempt to lock it}
      LOk:=(Try_Lock(B_GetDirect,B_SingNWLock+B_MultLock,KeyS,Keypath,Fnum,RecPtr[Fnum])=0);

    FoundOk:=(GStatus=0) and (LOk);

    If (GStatus=0) and (Not FoundOk) then
      Inc(UsrCount);

  Until (FoundOk) or (GStatus<>0);

  With PassWord do
  With BACSURec do
  Begin
    If (Not FoundOk) then
    Begin

      ResetRec(Fnum);

      PassWord.RecPfix:=MBACSCode;
      PassWord.Subtype:=MBACSUSR;

      LIUCount:=UsrCount;

      UsrCode:=BACSUsrKey3(SPMode,UsrCount);

    end
    else
      GetPos(F[Fnum],Fnum,UsrAddr);

    OpoName:=EntryRec^.LogIn;
    StartDate:=Today;

    GetCurrTime(TimeR);

    StartTime:=SetN(TimeR.HH)+':'+SetN(TimeR.MM);

    WINLogName:=WinGetUserName;

    WINCPUName:=WinGetComputerName;

    If (FoundOk) then
    Begin
      Status:=Put_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);

      If (GetMode=0) then {unlock it now}
      Begin
        Status:=UnLockMultiSing(F[Fnum],Fnum,UsrAddr);

      end;
    end
    else
    Begin
      Status:=Add_Rec(F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath);

      Report_BError(Fnum,Status);


      If (GetMode=1) then {Leave it locked}
      Begin
        LOk:=GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,UsrAddr);

      end;

    end;
  end;{With..}


  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWord;
end; {Proc..}


Procedure BACS_UsrUnLock(UsrAddr,UsrId    :  LongInt;
                         SPMode,
                         DelUsrRec  :  Boolean);

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  Locked    :  Boolean;

  TmpPWord  :  PassWordRec;

  TKeypath,
  TmpStat   :  Integer;
  TmpRecAddr:  LongInt;

  KeyS      :  Str255;


Begin
  TmpPWord:=PassWord;

  TKeypath:=GetPosKey;

  FillChar(KeyS,Sizeof(KeyS),#0);

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  If (DelUsrRec) then
  Begin
    SetDataRecOfs(Fnum,UsrAddr); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}

    {$B-}
    If (StatusOk) and (GetMultiRecAddr(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked,UsrAddr)) then
    {$B+}
    Begin
      Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

      Report_BError(Fnum,Status);
    end;
  end
  else
    Status:=UnLockMultiSing(F[Fnum],Fnum,UsrAddr);


  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWord;
end; {Proc..}


Function BACS_HasUsers(SPMode,DelDormant :  Boolean;
                       UsrCount          :  LongInt)  :  Boolean;

Const
  Fnum     =  PWrdF;
  Keypath  =  PWK;

Var
  TmpPWord  :  PassWordRec;

  FoundOk   :  Boolean;

  BCode,
  TKeypath,
  B_Func,
  TmpStat   :  Integer;
  LAddr,
  TmpRecAddr:  LongInt;

  KeyChk,
  KeyS      :  Str255;


Begin
  TmpPWord:=PassWord;

  TKeypath:=GetPosKey;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOff,BOff);

  KeyChk:=BACSUsrKey2(SPMode);


  KeyS:=KeyChk;

  Status:=Find_Rec(B_GetGEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  FoundOk:=BOff;

  While (StatusOk) and (Not FoundOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOff)) do
  Begin
    B_Func:=B_GetNext;

    If (PassWord.BACSURec.LIUCount<>UsrCount) then
    Begin
      BCode:=Try_Lock(B_GetDirect,B_SingNWLock+B_MultLock,KeyS,Keypath,Fnum,RecPtr[Fnum]);

      FoundOk:=(BCode = 84) or (BCode=85);


      If (BCode=0) then
      Begin {If are tidying up and its not us then get rid of it}
        If (DelDormant) then
        Begin
          Status:=Delete_Rec(F[Fnum],Fnum,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
            B_Func:=B_GetGEq;
        end
        else
        Begin
          GetPos(F[Fnum],Fnum,LAddr);

          Status:=UnLockMultiSing(F[Fnum],Fnum,LAddr);

          SetDataRecOfs(Fnum,LAddr); {* Retrieve record by address Preserve position *}

          Status:=GetDirect(F[Fnum],Fnum,RecPtr[Fnum]^,Keypath,0); {* Re-Establish Position *}
        end;
      end;
    end;

    If (Not FoundOk) then
      Status:=Find_Rec(B_Func,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath,KeyS);

  end;

  Result:=FoundOk;

  TmpStat:=Presrv_BTPos(Fnum,TKeypath,F[Fnum],TmpRecAddr,BOn,BOff);

  PassWord:=TmpPWord;
end; {Proc..}



Procedure ForceInvSDisc(Var  InvR, EInv  :  InvRec;
                             BACSCtrl    :  PassWordRec;
                             Mode        :  Byte);

Var
  SDiscDate  :  LongDate;
  DiscVar,
  DiscConv   :  Double;
  UOR        :  Byte;
  StopDCalc  :  Boolean;


Begin
  With BACSCtrl.BACSCRec do
  Begin
    UOR:=0; DiscVar:=0.0; DiscConv:=0.0; StopDCalc:=BOff;

    If (Mode = 0 )  then {* Auto set discount *}
    With InvR do
    Begin
      BDiscount:=0.0;

      If (IncSDisc) and (Not DiscTaken) then
      Begin
        SDiscDate:=CalcDueDate(TransDate,DiscDays+SDDaysOver);

        If (SDiscDate>=TagAsDate) then
          BDiscount:=DiscSetAm;
      end
      else
        StopDCalc:=DiscTaken;

    end
      else
        StopDCalc:=InvR.DiscTaken;


    EInv:=InvR;

    If (Mode In [0,1]) and (Not StopDCalc) then
    With EInv do
    Begin
      DiscTaken:=BOn;

      DiscSetAm:=BDiscount;

      DiscConv:=Round_Up(Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      If (UOR<>0) then {* Due to it being a pre triangulation invoice, we need to work out what the
                          discount should have been back in its own currency *}
      Begin
        DiscVar:=Round_Up(Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),2);

        PostDiscAm:=Round_Up(DiscConv-DiscVar,2);
      end;

    end;

  end; {With..}
end; {Proc..}



{ ======== Function to Return Batch Title ======= }

Function BatchPTit(SPMode  :  Boolean)  :  Str20;

Begin
  If (SPMode) then
    BatchPTit:='Receipt'
  else
    BatchPTit:='Payment';

end;


{ ======== Function to Return Batch Title ======= }

Function BatchDocHed(SPMode  :  Boolean)  :  DocTypes;

Begin
  If (SPMode) then
    BatchDocHed:=SRC
  else
    BatchDocHed:=PPY;

end;


{ ======== Function to Return Batch Sign ======= }

Function BatchDocSign(SPMode  :  Boolean;
                      Value   :  Double )  :  Double;

Begin
  If (SPMode) then
    BatchDocSign:=Value
  else
    BatchDocSign:=Value*DocNotCnst;

end;

// Locates the Batch Receipts/Payments header
function BACS_FindHeader(var ExLocal: TdExLocal; ForSales: Boolean): Integer;
const
  KeyPath = 0;
var
  Key: Str255;
begin
  // Note: Changes to this routine may need to be duplicated in BACS_ValidateAccount below

  Key  := FullBACSCtrlKey(False);
  Status := Find_Rec(B_GetEq, F[PwrdF], PwrdF, ExLocal.LRecPtr[PWrdF]^, KeyPath, Key);
  Report_BError(PwrdF, Status);
  Result := Status;
end;

// Locates the Trader Batch Payments Header record
function BACS_FindAccountHeader(RunNo: Integer; CustCode: string; var ExLocal: TdExLocal): Integer;
const
  KeyPath = MIK;
var
  Key: Str255;
begin
  // Note: Changes to this routine may need to be duplicated in BACS_ValidateAccount below

  if (ExLocal.LMiscRecs.BacsSRec.TagCustCode <> CustCode) then
  begin
    Key := PartCCKey(MBACSCode,MBACSSub)+FullNomKey(RunNo)+FullCustCode(CustCode);
    Status := Find_Rec(B_GetEq, F[MiscF], MiscF, ExLocal.LRecPtr[MiscF]^, KeyPath, Key);
    Report_BError(MiscF, Status);
    Result := Status;
  end
  else
    Result := 0;
end;

//-------------------------------------------------------------------------

// MH 07/02/2018 2018-R1 ABSEXCH-19292: Added new method to allow eRCT Plug-In to validate the Account is valid
//
// Note: Based on BACS_FindHeader and BACS_FindAccountHeader above with suppressed error reporting
Function BACS_ValidateAccount (var ExLocal: TdExLocal; CustCode: string) : Integer;
var
  PwordSavePos, MiscSavePos : TBtrieveSavePosition;
  KeyS : Str255;
  lStatus : Integer;
Begin // BACS_ValidateAccount
  // Save/Restore the position and data for any files accessed in this routine to ensure no
  // collateral damage is caused by the check
  PwordSavePos := TBtrieveSavePosition.Create;
  MiscSavePos := TBtrieveSavePosition.Create;

  // Save the current position in the file for the current key
  PwordSavePos.SaveFilePosition (PwrdF, GetPosKey);
  PwordSavePos.SaveDataBlock (ExLocal.LRecPtr[PWrdF], SizeOf(PassWordRec));
  Try
    // Read Batch Payments Header to get Run Number
    KeyS := FullBACSCtrlKey(False);
    lStatus := Find_Rec(B_GetEq, F[PwrdF], PwrdF, ExLocal.LRecPtr[PWrdF]^, 0, KeyS);
    If (lStatus = 0) Then
    Begin
      MiscSavePos.SaveFilePosition (MiscF, GetPosKey);
      MiscSavePos.SaveDataBlock (ExLocal.LRecPtr[MiscF], SizeOf(MiscRec));
      Try
        // Use the Run Number to look for the Account Record
        KeyS := PartCCKey(MBACSCode,MBACSSub) + FullNomKey(ExLocal.LPassword.BacsCRec.TagRunNo) + FullCustCode(CustCode);
        lStatus := Find_Rec(B_GetEq, F[MiscF], MiscF, ExLocal.LRecPtr[MiscF]^, MIK, KeyS);
        If (lStatus = 0) Then
          Result := 0  // OK
        Else
          Result := 2; // Account Header not found
      Finally
        MiscSavePos.RestoreDataBlock (ExLocal.LRecPtr[MiscF]);
        MiscSavePos.RestoreSavedPosition;
      End; // Try..Finally
    End // If (lStatus = 0)
    Else
      Result := 1; // Batch Payments Header not found
  Finally
    PwordSavePos.RestoreDataBlock (ExLocal.LRecPtr[PWrdF]);
    PwordSavePos.RestoreSavedPosition;

    FreeAndNIL(MiscSavePos);
    FreeAndNIL(PwordSavePos);
  End; // Try..Finally
End; // BACS_ValidateAccount

//-------------------------------------------------------------------------

// CJS 2016-07-06 - ABSEXCH-17383 - amendments for eRCT Plugin
Procedure BACS_TagTransaction(Mode     : Byte;
                              LUpdate  : Boolean;
                              TOk,
                              UOk      : Boolean;
                              KeyPath  : Integer;
                              var ExLocal  : TdExLocal;
                              var BatchCtrl: PasswordRec;
                              MULCtrlO : TBIMList = nil;
                              Owner: TBatchItems = nil);
Var
  // DocCnst  :  Integer;
  DocAry   :  BACSAnalType;
  TagVal   :  Real;
  N        :  Byte;
  LOK,
  LLocked  :  Boolean;
  KeyS     :  Str255;
  EInv     :  InvRec;

  HasPPD: Boolean;
  PPDAvailableInBase: Double;
  PPDAvailableInCurrency: Double;
  TagSignMultiplier: Integer;
  InvSignMultiplier: Integer;

  CalledFromList: Boolean;
Begin
  // This routine can be called either from the Batch Payments Item list, or
  // alternatively from a non-UI routine (currently this would be the eRCT
  // system). It needs to do some things differently for each case.
  CalledFromList := Assigned(MULCtrlO);

  If (Mode = 1) then
    TagSignMultiplier := 1   // Tag
  else
    TagSignMultiplier := -1; // Untag

  KeyS:='';

  HasPPD := False;

  With ExLocal, LInv do
  Begin

    // CJS 2015-08-17 - ABSEXCH-16753 - Incorrect Paid This Run value on Batch Sales Receipts
    InvSignMultiplier := DocCnst[LInv.InvDocHed];

    if not CalledFromList then
      BACS_FindHeader(ExLocal, False);

    If (LUpDate) and (TOK or UOK) then
    begin
      if UsingSQL and CalledFromList then
        MULCtrlO.PrepareSQLCall;
        
      LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,InvF,BOff,LLocked);
    end;

    If ((LOk) and (LLocked)) or (Not LUpDate) then
    Begin
      If (UOk) and (Not UnTagged) then
        TagSignMultiplier:=TagSignMultiplier*DocNotCnst;

      ForceInvSDisc(LInv,EInv,BatchCtrl,1);

      If (TOK) or (UOK) then
      Begin

        LGetRecAddr(InvF);

        Blank(DocAry,Sizeof(DocAry));

        With BatchCtrl.BACSCRec do
        Begin
          HasPPD := PPDFieldsPopulated(LInv);
          {
          CanTakePPD := ValidPPDAvailable(LInv,
                                          BatchCtrl.BacsCRec.IntendedPaymentDate,
                                          BatchCtrl.BacsCRec.PPDExpiryToleranceDays);
          }
          // CJS 2015-05-22 - v7.0.14 - PPD - T2-159 - PPD Columns
          If (Tagged=0) then
          begin
            BatchThen:=BaseTotalOS(EInv);
            if (LInv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) and HasPPD then
            begin
              // CJS 2015-06-05 - ABSEXCH-16492 - incorrect values on Batch Payments itemised list
              // CJS 2015-07-08 - ABSEXCH-16646 - Batch Payments tagged value in wrong currency
              // CJS 2015-08-17 - ABSEXCH-16753 - Incorrect Paid This Run value on Batch Sales Receipts
              PPDAvailableInBase := (LInv.thPPDGoodsValue + LInv.thPPDVATValue) * TagSignMultiplier * InvSignMultiplier * DocNotCnst;
              PPDAvailableInBase := Conv_TCurr(PPDAvailableInBase, XRate(LInv.CXRate, BOff, LInv.Currency), LInv.Currency, 0, BOff);
              BatchThen := BatchThen - PPDAvailableInBase;
            end;
          end;

          {$IFDEF MC_On}

            // CJS 2015-05-22 - v7.0.14 - PPD - T2-159 - PPD Columns
            If (Tagged=0) then
            begin
              BatchNow:=CurrencyOS(EInv,BOff,BOff,BOff);
              if (LInv.thBatchPayPPDStatus = PPD_BATCHPAY_SET) and HasPPD then
              begin
                // CJS 2015-06-05 - ABSEXCH-16492 - incorrect values on Batch Payments itemised list
                // CJS 2015-07-08 - ABSEXCH-16646 - Batch Payments tagged value in wrong currency
                // CJS 2015-08-17 - ABSEXCH-16753 - Incorrect Paid This Run value on Batch Sales Receipts
                PPDAvailableInCurrency := (LInv.thPPDGoodsValue + LInv.thPPDVATValue) * TagSignMultiplier * InvSignMultiplier * DocNotCnst;
                BatchNow := BatchNow - PPDAvailableInCurrency;
              end;
            end;

            If (Currency<>PayCurr) then
              TagVal:=Currency_ConvFT(BatchThen,0,PayCurr,UseCoDayRate)*TagSignMultiplier
            else
              TagVal:=BatchNow*TagSignMultiplier;

          {$ELSE}

            TagVal:=BatchThen*TagSignMultiplier;

          {$ENDIF}

          MasterAged(DocAry,Get_StaChkDate(LInv),TagASDate,TagVal,AgeType,AgeInt);

          if not CalledFromList then
            BACS_FindAccountHeader(TagRunNo, LInv.CustCode, ExLocal)
          else
          begin
            LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}
            Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}
          end;

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,MIK,MiscF,BOn,LLocked);

          If (LOk) and (LLocked) then
          Begin
            LGetRecAddr(MiscF);

            if not CalledFromList then
              LMiscRecs^.BACSSRec.TotalTagged[0]:=0;

            With LMiscRecs^.BACSSRec do
              For N:=1 to NoBACSTot do
              begin
                If (Not UOK) then
                  TotalTagged[N]:=TotalTagged[N]+DocAry[N]
                else
                  TotalEx[N]:=TotalEx[N]+DocAry[N];

                if not CalledFromList then
                begin
                  If (HasTagged[N]) then
                    TotalTagged[0]:=TotalTagged[0]+TotalOS[N]-TotalEx[N]
                  else
                    TotalTagged[0]:=TotalTagged[0]+TotalTagged[N];
                end;
              end; // For N:=1...

            Status:=Put_Rec(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK);

            Report_BError(MiscF,Status);

            UnLockMLock(MiscF,LastRecAddr[MiscF]);

            If (LUpDate) then
            Begin
              ExLocal.LastInv:=ExLocal.LInv;

              LSetDataRecOfs(InvF,LastRecAddr[InvF]); {* Retrieve record by address Preserve position *}

              if UsingSQL and CalledFromList then
                MULCtrlO.PrepareSQLCall;

              Status:=GetDirect(F[InvF],InvF,LRecPtr[InvF]^,Keypath,0); {* Re-Establish Position *}

              ExLocal.LInv:=ExLocal.LastInv;

              ExLocal.AssignToGlobal(InvF);

              if Assigned(Owner) then
                Owner.Send_UpdateList(71);
            end;

          end;

        end; {With..}

        If (Not UOK) then
        Begin
          If (Tagged=0) then
            Tagged:=1
          else
            Tagged:=0;
        end;

        If (Tagged=0) then
        Begin
          BatchNow:=0;
          BatchThen:=0;
        end;
      end;

      If (UOk) then
      Begin
        UnTagged:=Not UnTagged;
      {Tagged:=BOff;}

      end;

      If (LUpDate) and (TOk or UOK) then
      Begin
        LastInv:=LInv;

        LSetDataRecOfs(InvF,LastRecAddr[InvF]); {* Retrieve record by address Preserve position *}

        if UsingSQL and CalledFromList then
          MULCtrlO.PrepareSQLCall;

        Status:=GetDirect(F[InvF],InvF,LRecPtr[InvF]^,Keypath,0); {* Re-Establish Position *}

        LInv:=LastInv;

        if UsingSQL and CalledFromList then
          MULCtrlO.PrepareSQLCall;

        Status:=Put_Rec(F[InvF],InvF,LRecPtr[InvF]^,KeyPAth);

        Report_BError(InvF,Status);

        UnLockMLock(InvF,LastRecAddr[InvF]);

        if CalledFromList then
          MULCtrlO.AddNewRow(MULCtrlO.MUListBoxes[0].Row,BOn);
      end;
    end; {With..}
  end; {If Locked ok}
end; {Proc..}

(*
function BACS_TagDoc(MULCtrlO: TBIMList;
                     ExLocal: TdExLocal;
                     Mode: Byte;
                     LUpdate: Boolean;
                     TOk, UOk: Boolean): Boolean;
var
  DocCnst : Integer;
  DocAry  : BACSAnalType;
  TagVal  : Real;
  N       : Byte;
  LOK,
  LLocked : Boolean;
  KeyS    : Str255;
  EInv    : InvRec;
  UpdateRequired: Boolean;
begin
  UpdateRequired := False;

  If (Mode = 1) then
    DocCnst := 1
  else
    DocCnst := -1;

  KeyS := '';

  with MULCtrlO, ExLocal, LInv do
  Begin

    If (LUpDate) and (TOK or UOK) then
      LOk := LGetMultiRec(B_GetDirect, B_MultLock, KeyS, KeyPath, ScanFileNum,
                          BOff, LLocked);

    If ((LOk) and (LLocked)) or (Not LUpDate) then
    Begin
      If (UOk) and (Not UnTagged) then
        DocCnst := DocCnst * DocNotCnst;

      ForceInvSDisc(LInv, EInv, BatchCtrl, 1);

      If (TOK) or (UOK) then
      Begin

        LGetRecAddr(ScanFileNum);

        Blank(DocAry, Sizeof(DocAry));

        With BatchCtrl.BACSCRec do
        Begin

          If (Tagged=0) then
            BatchThen:=BaseTotalOS(EInv);

          {$IFDEF MC_On}

            If (Tagged=0) then
              BatchNow:=CurrencyOS(EInv,BOff,BOff,BOff);

            If (Currency<>PayCurr) then
              TagVal:=Currency_ConvFT(BatchThen,0,PayCurr,UseCoDayRate)*DocCnst
            else
              TagVal:=BatchNow*DocCnst;

          {$ELSE}

            TagVal:=BatchThen*DocCnst;

          {$ENDIF}

          MasterAged(DocAry,Get_StaChkDate(LInv),TagASDate,TagVal,AgeType,AgeInt);

          LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

          Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,MIK,MiscF,BOn,LLocked);

          If (LOk) and (LLocked) then
          Begin
            LGetRecAddr(MiscF);

            With LMiscRecs^.BACSSRec do
              For N:=1 to NoBACSTot do
                If (Not UOK) then
                  TotalTagged[N]:=TotalTagged[N]+DocAry[N]
                else
                  TotalEx[N]:=TotalEx[N]+DocAry[N];

            Status:=Put_Rec(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK);

            Report_BError(MiscF,Status);

            UnLockMLock(MiscF,LastRecAddr[MiscF]);

            If (LUpDate) then
            Begin
              ExLocal.LastInv:=ExLocal.LInv;

              LSetDataRecOfs(ScanFileNum,LastRecAddr[ScanFileNum]); {* Retrieve record by address Preserve position *}

              Status:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath,0); {* Re-Establish Position *}

              ExLocal.LInv:=ExLocal.LastInv;

              ExLocal.AssignToGlobal(InvF);

              UpdateRequired := True;
//              Send_UpdateList(71);
            end;

          end;

        end; {With..}

        If (Not UOK) then
        Begin
          If (Tagged=0) then
            Tagged:=1
          else
            Tagged:=0;
        end;

        If (Tagged=0) then
        Begin
          BatchNow:=0;
          BatchThen:=0;
        end;
      end;

      If (UOk) then
      Begin
        UnTagged:=Not UnTagged;
      {Tagged:=BOff;}

      end;

      If (LUpDate) and (TOk or UOK) then
      Begin
        LastInv:=LInv;

        LSetDataRecOfs(ScanFileNum,LastRecAddr[ScanFileNum]); {* Retrieve record by address Preserve position *}

        Status:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath,0); {* Re-Establish Position *}

        LInv:=LastInv;

        Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

        Report_BError(ScanFileNum,Status);

        UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

        AddNewRow(MUListBoxes[0].Row,BOn);
      end;
    end; {With..}
  end; {If Locked ok}
  Result := UpdateRequired;
end; {Proc..}
*)

{ ====================================== Form Methods ===================================== }
{ ========================================================================================= }


Procedure  TBatchItems.SetNeedCUpdate(B  :  Boolean);

Begin
  If (Not fNeedCUpdate) then
    fNeedCUpdate:=B;
end;

procedure TBatchItems.Find_FormCoord;


Var
  ThisForm:  TForm;

  VisibleRect
          :  TRect;

  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin

    GetValues:=BOn;

    PrimeKey:='I';

    If (GetbtControlCsm(ThisForm)) then
    Begin
      {StoreCoord:=(ColOrd=1); v4.40. To avoid on going corruption, this is reset each time its loaded}
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);

    end;

    GetbtControlCsm(CSBox);

    GetbtControlCsm(CListBtnPanel);

    GetbtControlCsm(CBtnPanel);

    MULCtrlO.Find_ListCoord(GlobComp);

  end; {With GlobComp..}


  Dispose(GlobComp,Destroy);

    {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;

end;


procedure TBatchItems.Store_FormCoord(UpMode  :  Boolean);


Var
  GlobComp:  TGlobCompRec;


Begin

  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:='I';

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(CBtnPanel);

    StorebtControlCsm(CSBox);

    StorebtControlCsm(CListBtnPanel);

    MULCtrlO.Store_ListCoord(GlobComp);

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;



procedure TBatchItems.FormSetOfSet;

Begin
  PagePoint[0].X:=ClientWidth-(CBtnPanel.Left);
  PagePoint[0].Y:=ClientHeight-(CBtnPanel.Height);

  PagePoint[1].X:=ClientWidth-(CSBox.Width);
  PagePoint[1].Y:=ClientHeight-(CSBox.Height);

  PagePoint[3].X:=CBtnPanel.Height-(CCBSBox.Height);
  PagePoint[3].Y:=CSBox.ClientHeight-(CLORefPanel.Height);

  PagePoint[4].Y:=CBtnPanel.Height-(CListBtnPanel.Height);

  GotCoord:=BOn;

end;


{ ======= Link to Trans display ======== }

procedure TBatchItems.Display_Trans(Mode  :  Byte);

Var
  DispTrans  :  TFInvDisplay;
  Res : Integer;
  RecAddr: Integer;
  // Flag to determine whether or not to reposition Inv and call Display_Trans
  RequiresRefresh: Boolean;
  DisplayOptions : TransactionDisplayOptionsSet;
Begin

  If (DispTransPtr=nil) then
  Begin
    DispTrans:=TFInvDisplay.Create(Self);
    DispTransPtr:=DispTrans;
  end
  else
    DispTrans:=DispTransPtr;

    try
      RequiresRefresh := True;
      //PR: 05/10/2010 Now using a pre-fill cache for the list so we have to refind the selected transaction in the database
      //before showing it
      if SQLUtils.UsingSQL then
      with MulCtrlO do
      begin
        // CJS 2015-02-27 - ABSEXCH-15298 - T1-011 - Disable Discount button for transactions >= 01/04/2015
        //PR: 21/08/2015 ABSEXCH-16743 Removed PrepareSQLCalls as they were causing an error 43 to be displayed when displaying trans
//        if UsingSQL then PrepareSQLCall;
        Res := GetPos(F[ScanFileNum], ScanFileNum, RecAddr);
        if (RecAddr <> PageKeys^[MuListBoxes[0].Row]) then
        begin
          // We've changed record position, so locate the new record
          SetDataRecOfs(ScanFileNum,PageKeys^[MuListBoxes[0].Row]);
//          if UsingSQL then PrepareSQLCall;
          Res:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);
        end
        else
          // Still on the same record, so we don't need to update anything
          RequiresRefresh := False;
      end;

      //PR: 21/08/2015 ABSEXCH-16743 Added Mode <> 100 check so that a double click will display transaction
      if RequiresRefresh or (Mode <> 100) then
      begin
        ExLocal.AssignFromGlobal(InvF);

        if RestrictedEditOnly(Inv) then
          DisplayOptions := [GDPR_AllowPostedEdit]
        else
          DisplayOptions := [];

        With ExLocal,DispTrans do
        Begin
          LastDocHed:=LInv.InvDocHed;

          //PR: 21/08/2015 ABSEXCH-16743 Add check for either a double click or a change of transaction when displaying a transaction.
          if (LastFolio<>LInv.FolioNum) and (DoubleClick or ScanMode) then
            Display_Trans(Mode,LInv.FolioNum,BOff,(Mode<>100), DisplayOptions);

        end; {with..}
      end; // if RequiresRefresh...
    except

      DispTrans.Free;

    end;

end;




Function TBatchItems.ScanMode  :  Boolean;

Var
  n  :  Byte;

Begin
  If (Assigned(DispTransPtr)) then
  With TFInvDisplay(DispTransPtr) do
  Begin
    For n:=Low(TransActive) to High(TransActive) do
    Begin
      Result:=TransActive[n];

      If (Result) then
        break;
    end;
  end
  else
    Result:=BOff;
end;



Procedure TBatchItems.WMCustGetRec(Var Message  :  TMessage);

Var
  IMode  :  SmallInt;

Begin
  //PR: 21/08/2015 ABSEXCH-16743
  DoubleClick := False;

  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      // CJS 2015-02-27 - ABSEXCH-15298 - T1-011 - Disable Discount button for transactions >= 01/04/2015
      // Removed WParam = 1 (On Select Cell), as we are using WParam = 3 instead,
      // because the row position has not yet changed when the WParam = 1
      // message is received
      0, 169
         :  Begin
              If (WParam=169) then
              Begin
                MULCtrlO.GetSelRec(BOff);
                IMode:=0;
              end
              else
                IMode:=WParam;

              InHBeen:=((WParam=0) or ((InHBeen) and ScanMode));

              //PR: 21/08/2015 ABSEXCH-16743
              DoubleClick := (WParam = 0);

              Display_Trans(2+(98*IMode));

            end;

      2  :  ShowRightMeny(LParamLo,LParamHi,1);

      // CJS 2015-02-27 - ABSEXCH-15298 - T1-011 - Disable Discount button for transactions >= 01/04/2015
      3 {On List Click} :
            begin
              Display_Trans(100);
              UpdateUIState;
            end;

      25 :  NeedCUpdate:=BOn;


      71 :  begin
              RefreshList(BOn, BOn);
            end;
      116
          :  Begin
               With MULCtrlO do
               Begin
                 AddNewRow(MUListBoxes[0].Row,(LParam=1));
               end;
            end;

      117 :  With MULCtrlO do
             Begin
               If (MUListBox1.Row<>0) then
                 PageUpDn(0,BOn)
                else
                  InitPage;
             end;

      200   :  DispTransPtr:=nil;

    {$IFDEF GF}

      // CJS 2014-06-09 - ABSEXCH-15203 - Find option on Batch Payment items fails
      3002  //PR: 05/12/2013 ABSEXCH-14824
            : If (Assigned(FindCust)) then
                With MULCtrlO,FindCust,ReturnCtrl do
                Begin
                  InFindLoop:=BOn;

                  Find_OnList(SearchMode,SearchKey);

                  With MUListBoxes[0] do
                    If (CanFocus) then
                      SetFocus;

                  InFindLoop:=BOff;
                end;

    {$ENDIF}




    end; {Case..}

  end;
  Inherited;
end;


{ == Procedure to Send Message to Get Record == }

Procedure TBatchItems.Send_UpdateList(Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode;
    LParam:=0;
  end;

  With Message1 do
    MessResult:=SendMessage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


Procedure TBatchItems.WMGetMinMaxInfo(Var Message  :  TWMGetMinMaxInfo);

Begin

  With Message.MinMaxInfo^ do
  Begin

    ptMinTrackSize.X:=200;
    ptMinTrackSize.Y:=210;

    {ptMaxSize.X:=530;
    ptMaxSize.Y:=368;
    ptMaxPosition.X:=1;
    ptMaxPosition.Y:=1;}

  end;

  Message.Result:=0;

  Inherited;

end;

procedure TBatchItems.SetCaption;

Var
  LevelStr  :  Str255;
  AllowDisc :  Boolean;

Begin

  With ExLocal.LCust do
    Caption:='Batch '+BatchPTit(RecMode)+'. Itemised list for '+dbFormatName(CustCode,Company)+'. '+DDownTitle;

  If (Assigned(MULCtrlO)) then
    AllowDisc:=ChkAllowed_In(264+Ord(MULCtrlO.BatchCtrl.BACSCRec.SalesMode))
  else
    AllowDisc:=BOff;

  btnTag.Enabled:=Not TaggedByAccount;
  btnPartAllocate.Enabled:=Not TaggedByAccount;
  //HV 29/06/2016 2016-R3 ABSEXCH-17033: Can Unset PPD by selecting Part Allocate option through right click menu in Batch Payment/Receipt List sync with current state of Part Allocate button.
  ReCalc1.Enabled := btnPartAllocate.Enabled;
  Tag1.Enabled:=Not TaggedByAccount;
  ReCalc1.Enabled:=Not TaggedByAccount;

  // CJS 2015-05-18 - v7.0.14 - T2-162 - Discount/Write Off Button
  btnWriteOff.Enabled := (not TaggedByAccount) and AllowDisc and (SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL <> 0);
  Discount1.Enabled:=btnWriteOff.Enabled;
end;



procedure TBatchItems.FormDesign;


begin


end;





procedure TBatchItems.RefreshList(ShowLines,
                               IgMsg      :  Boolean);
Var
  KeyStart    :  Str255;
  LKeypath,
  i,
  LKeyLen     :  Integer;

  lFolioNum   : String;
  sQuery      : AnsiString;

  function IncrementMonth(const sDate : LongDate; IncBy : Integer) : LongDate;
  var
    dt : TDateTime;
  begin
    dt := ToDateTime(sDate);
    dt := IncMonth(dt, IncBy);
    Result := DateTimeAsLongDate(dt);
  end;

  function EndOfMonth(const sDate : LongDate) : LongDate;
  begin
    Result := Copy(sDate, 1, 6) + '31';
  end;

  function StartOfMonth(const sDate : LongDate) : LongDate;
  begin
    Result := Copy(sDate, 1, 6) + '01';
  end;

  procedure FindDates(var dtStart : LongDate; var dtEnd : LongDate);
  begin
    //PR: 06/10/2010 Huge bodge to make the SQL query work in the way that batch aging currently works out dates.
    with MULCtrlO do
    begin
      Case CurrCol of
        2    : begin  //Not Due
                 Case  BatchCtrl.BACSCRec.AgeType of
                   1  :   dtStart := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, 1);
                   2  :   dtStart := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, 4);
                   { CJS 2013-06-03 ABSEXCH-13817 - Batch Payments - Aging by more 1 than 1 month }
                   3  :   dtStart := StartOfMonth(IncrementMonth(BatchCtrl.BACSCRec.TagAsDate, -(BatchCtrl.BACSCRec.AgeInt - 1)));
                 end; //Case
                 dtEnd := '99999999';

               end;
        3    : with BatchCtrl.BACSCRec do
               begin
                 Case AgeType of
                   1  :  begin
                           dtEnd := BatchCtrl.BACSCRec.TagAsDate;
                           dtStart := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, -((AgeInt *2) - 1) );
                         end;
                   2  :  begin
                           dtEnd := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, 3);
                           dtStart := CalcDueDate(TagAsDate, -(( 2 * AgeInt * 7) - 4));
                         end;
                   3  :  begin
                           dtEnd := EndOfMonth(BatchCtrl.BACSCRec.TagAsDate);
                           dtStart := StartOfMonth(IncrementMonth(dtEnd, -AgeInt));
                         end;
                 end; //Case
               end; //with
        4    : with BatchCtrl.BACSCRec do
               begin
                 Case AgeType of
                   1  :  begin
                           dtEnd := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, -(AgeInt * 2) );
                           dtStart := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, -((AgeInt * 3) - 1));
                         end;
                   2  :  begin
                           dtEnd := CalcDueDate(TagAsDate, -(( 2 * AgeInt * 7)-3));
                           dtStart := CalcDueDate(TagAsDate, -(( 3 * AgeInt * 7) - 4));
                         end;
                   3  :  begin
                           dtEnd := EndOfMonth(IncrementMonth(BatchCtrl.BACSCRec.TagAsDate, 2 * -AgeInt));
                           dtStart := StartOfMonth(IncrementMonth(dtEnd, -AgeInt * 2));
                         end;
                 end; //Case
               end; //with
        5    : with BatchCtrl.BACSCRec do
               begin
                 Case AgeType of
                   1  :    dtEnd := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, -(AgeInt * 3) );
                   2  :    dtEnd := CalcDueDate(BatchCtrl.BACSCRec.TagAsDate, -((3 * AgeInt * 7) - 3));
                   3  :    dtEnd := EndOfMonth(IncrementMonth(BatchCtrl.BACSCRec.TagAsDate, 3 * -AgeInt));
                 end; //case
                 dtStart := '000000';
               end; //with
      end; //Case
    end; //With
  end; //Find Dates

  function DateParams : string;
  const
    sPurch   = '(SubString(thOurRef, 1, 1) = ''P'' )';
    sSales   = '(SubString(thOurRef, 1, 1) = ''S'' )';
    sDate    = '(thTransDate >= %s and thTransDate <= %s)';
    sDueDate = '(thDueDate >= %s and thDueDate <= %s)';
  var
    dtStart, dtEnd : longdate;
  begin
    //Syss.StaUIDate = Age Sales by Invoice Date - if false use Due Date
    //Syss.PurchUIDate = Age Purchase by Invoice Date - if false use Due Date
    // CJS 2015-05-26 - v7.0.14 - PPD - T2-157 - Trader PPD Column (6)
    if MULCtrlO.CurrCol in [0, 1, 6] then
      Result := ''
    else
    begin
      if Syss.StaUIDate and Syss.PurchUIDate then
        Result := sDate
      else
      if Syss.StaUIDate and not Syss.PurchUIDate then
        Result := '(( ' + sSales + ' and ' + sDate + ')  or (' + sPurch + ' and ' + sDueDate + ')) '
      else
      if not Syss.StaUIDate and Syss.PurchUIDate then
        Result := '(( ' + sSales + ' and ' + sDueDate + ')  or (' + sPurch + ' and ' + sDate + ')) '
      else
      if not Syss.StaUIDate and not Syss.PurchUIDate then
        Result := sDueDate;

      FindDates(dtStart, dtEnd);

      Result := ' and ' + Format(Result, [QuotedStr(dtStart), QuotedStr(dtEnd), QuotedStr(dtStart), QuotedStr(dtEnd)]);
    end;
  end;
Begin

  If (MulCtrlO.BatchCtrl.BACSCRec.UseOSNdx) then
  Begin
    KeyStart:=TradeCode[RecMode]+FullCustCode(MULCtrlO.CCode);
    LKeypath:=InvOSK;
  end
  else
  Begin
    KeyStart:=FullLedgerKey(MULCtrlO.CCode,TradeCode[RecMode],BOn);
    LKeypath:=InvCustK;
  end;


  LKeyLen:=Length(KeyStart);

  //PR: 05/10/2010 Fix for ABSEXH-9789. Use Prefill cache under SQL to avoid screen flicker.
  With MULCtrlO do
  Begin
    if SQLUtils.UsingSQL then
    begin
      // CJS 2015-03-02 - ABSEXCH-16164 - Exclude Order Payment SRCs from Batch Receipts
      // Amended query to exclude Order Payments Sales Receipts
      sQuery := 'thOutstanding = ''' + TradeCode[RecMode] + ''' and thAcCodeComputed = ''' + FullCustCode(MULCtrlO.CCode)+ ''' ' +
                'and ((thOrderPaymentElement = ' + IntToStr(Ord(opeNA)) + ') OR (thDocType <> ' + IntToStr(Ord(SRC)) + ')) ' +
           DateParams;
      {$IFDEF MC_ON}
      if BatchCtrl.BACSCRec.InvCurr <> 0 then
        sQuery := sQuery + ' and thCurrency = ' + IntToStr(BatchCtrl.BACSCRec.InvCurr);
      {$ENDIF}
      //PR: 17/01/2011 ABSEXCH-10736 The default Control Codes apply where Ctrl Codes are blank - eg the run specifies the default
      //creditors code for a purchase payments run then it will also include any payments with a Control GL of 0.
      if BatchCtrl.BACSCRec.TagCtrlCode <> 0 then
      begin
        if (RecMode and (BatchCtrl.BACSCRec.TagCtrlCode = Syss.NomCtrlCodes[Debtors])) or
           (not RecMode and (BatchCtrl.BACSCRec.TagCtrlCode = Syss.NomCtrlCodes[Creditors])) then
              sQuery := sQuery + ' and (thControlGL = ' + IntToStr(BatchCtrl.BACSCRec.TagCtrlCode) + ' or thControlGL = 0)'
        else
          sQuery := sQuery + ' and thControlGL = ' + IntToStr(BatchCtrl.BACSCRec.TagCtrlCode);
      end;

      //PR: 26/11/2010 Fix for ABSEXCH-10526 Check whether Authorisation Method is Automatic or Manual - if so then
      //only authorised transactions should be shown. For authorised transactions, thHoldFlag will have a value of 3,
      //ignoring bits 5 & 7 (Notes & Suspend Posting.)
      //PR: 06/12/2010 Fix for ABSEXCH-10545 - ignore authorisation for Receipts
      if (Syss.AuthMode in ['A', 'M']) and not RecMode then
        sQuery := sQuery + ' and (thHoldFlag & 7) = 3'
      { CJS 2012-11-15 ABSEXCH-13701 - PINs on Query appearing in Batch Payments }
      else
        sQuery := sQuery + ' AND (thHoldFlag & 7) <> 1';
        
      //HV 19/07/2016 2016-R3 ABSEXCH-16551: Batch Payments/Receipts display differing behaviour between Pervasive and MSSQL, if transactions opened in edit mode
      lFolioNum := EmptyStr;
      for i := Low(DocEditNowList^) to DocEditedNow do
      begin
        if DocEditNowList^[i] > 0 then
        begin
          if lFolioNum = EmptyStr then
            lFolioNum := IntToStr(DocEditNowList^[i])
          else
            lFolioNum := lFolioNum + ',' + IntToStr(DocEditNowList^[i]);
        end;
      end;
      if lFolioNum <> EmptyStr then
        sQuery := sQuery + ' AND thFolioNum Not In (' + lFolioNum  + ')';

     //PS 26/07/2016 2016-R3 ABSEXCH-17057: Added condition to synchonized behaviour between SQL and PSQL.
      sQuery := sQuery + ' And thFolioNum <=' +  IntToStr(BatchCtrl.BACSCRec.LastInv) ;
    end
    else
      sQuery := '';


    if not SQLUtils.UsingSQL then
    try
      sQuery := '';
      If (Not Assigned(CusExtObjPtr)) then
        ExtObjCreate;

      With CusExtRecPtr^ do
      Begin

        FCusCode:=FullCustCode(CCode);

        FNomAuto:=BOn;

        FAlCode:=TradeCode[RecMode];

        FMode:=3;

        FCr:=BatchCtrl.BACSCRec.InvCurr;

        FCheckLI:=BOn;
        FLastInv:=BatchCtrl.BACSCRec.LastInv;


        FCtrlNom:=BatchCtrl.BACSCRec.TagCtrlCode;


      end;
    except
      CusExtObjPtr:=nil;
    end;

    IgnoreMsg:=IgMsg;

    StartList(InvF,LKeypath,KeyStart,'','',LKeyLen,(Not ShowLines), sQuery);

    IgnoreMsg:=BOff;
  end;

  UpdateUIState;
  // CJS 2015-02-27 - ABSEXCH-15298 - T1-011 - Disable Discount button for transactions >= 01/04/2015
  // CJS 2015-05-18 - v7.0.14 - T2-162 - Discount/Write Off Button - no longer
  // needs to be checked for Settlement Discount
  // Display_Trans(100);
  // btnWriteOff.Enabled := (TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported);
end;



procedure TBatchItems.FormBuildList(ShowLines  :  Boolean);

Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;



Begin
  MULCtrlO:=TBIMList.Create(Self);


  Try

    With MULCtrlO do
    Begin


      Try

        With VisiList do
        Begin
          AddVisiRec(CLORefPanel,CLORefLab);
          AddVisiRec(CLYRefPanel,CLYRefLab);
          AddVisiRec(CLDuePanel,CLDueLab);
          AddVisiRec(CLOSPanel,CLOSLab);
          AddVisiRec(CLAMTPanel,CLAMTLab);
          AddVisiRec(CLStatPanel,CLStatLab);
          AddVisiRec(CLDatePanel,CLDateLab);

          // CJS 2015-05-11 - v7.0.14 - PPD - T2-159 - PPD Columns
          AddVisiRec(pnlPPDAvailable, lblPPDAvailable);
          AddVisiRec(pnlTotalAfterPPD, lblTotalAfterPPD);
          AddVisiRec(pnlPPDExpiry, lblPPDExpiry);
          AddVisiRec(pnlPPDStatus, lblPPDStatus);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          {HidePanels(0);}

          LabHedPanel:=CHedPanel;

          ListOfSet:=10;

          SetHedPanel(ListOfSet);

        end;
      except
        VisiList.Free;

      end;


      {$IFDEF Cu}

        CWId:=EnterpriseBase+2050;

        CWEvent:=174+Ord(RecMode);

        CustomEvent:=TCustomEvent.Create(CWId,CWEvent);

        Try
          With CustomEvent do
          If (GotEvent) then
          Begin
            BuildEvent(ExLocal);
            RunCEvent:=BOn;
          end;
        except
          RunCEvent:=BOff;

        end; {try..}


      {$ENDIF}


      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=10;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOff;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      For n:=0 to MUTotCols do
      With ColAppear^[n] do
      Begin
        AltDefault:=BOn;

        If (n In [3, 4, 7, 8]) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;
        end;
      end;

      Filter[1,0]:='1';  {* Used to Filter by aging *}

      ListLocal:=@ExLocal;

      ListCreate;

      UseSet4End:=BOff;

      NoUpCaseCheck:=BOn;

      HighLiteStyle[1]:=[fsBold];

      Set_Buttons(CListBtnPanel);

      LNHCtrl.NHNeedGExt:=BOn;

      {ReFreshList(ShowLines,BOff);}

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;



  FormSetOfSet;

  FormReSize(Self);

  {RefreshList(BOn,BOn);}

end;


procedure TBatchItems.FormCreate(Sender: TObject);

Var
  n  :  Integer;

begin
  fDoingClose:=BOff;
  ExLocal.Create;

  LastCoord:=BOff;

  NeedCUpdate:=BOff;

  JustCreated:=BOn;

  InitSize.Y:=235;
  InitSize.X:=700;

  Self.ClientHeight:=InitSize.Y;
  Self.ClientWidth:=InitSize.X;

  {Height:=244;
  Width:=370;}

  InHBeen:=BOff;

  DispTransPtr:=nil;

  BeenIn:=BOff;

  TaggedByAccount:=BOff;

  RecMode:=BIFormMode;

  MDI_SetFormCoord(TForm(Self));

  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
    With TScrollBox(Components[n]) do
    Begin
      VertScrollBar.Position:=0;
      HorzScrollBar.Position:=0;
    end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;


  DDownTitle:='';

  FormDesign;

  FormBuildList(BOff);

  SetHelpContextIDs; // NF: 20/06/06 Fix for incorrect Context IDs

  DoubleClick := False;

end;



procedure TBatchItems.FormDestroy(Sender: TObject);

Var
  n  :  Byte;
begin
  ExLocal.Destroy;


 end;

procedure TBatchItems.FormCloseQuery(Sender: TObject;
                              var CanClose: Boolean);
Var
  n  : Integer;

begin
  For n:=0 to Pred(ComponentCount) do
  If (Components[n] is TScrollBox) then
  With TScrollBox(Components[n]) do
  Begin
    VertScrollBar.Position:=0;
    HorzScrollBar.Position:=0;
  end;

  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  If (NeedCUpdate) then
    Store_FormCoord(Not SetDefault);

  Send_UpdateList(70);

  {* This check was placed here in v4.31 as if this screen had an item tagged whilst this
    screen & the main BP list were maximized, a major GPF occured *}

  If (WindowState=wsMaximized) then
    WindowState:=wsNormal;

end;

procedure TBatchItems.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  If (Not fDoingClose) then
  Begin
    fDoingClose:=BOn;

    Action:=caFree;

    If (MULCtrlO<>nil) then
    Begin
      try
      {$IFDEF CU}
        MULCtrlO.CustomEvent.Free;
      {$ENDIF}
      
        MULCtrlO.Destroy;
      finally
        MULCtrlO:=nil;
      end;
    end;

  end;
end;


procedure TBatchItems.FormResize(Sender: TObject);
Var
  n           :  Byte;
  NewVal      :  Integer;


begin

  If (GotCoord) then
  Begin

    CBtnPanel.Left:=ClientWidth-PagePoint[0].X;

    CBtnPanel.Height:=ClientHeight-PagePoint[0].Y;


    CSBox.Width:=ClientWidth-PagePoint[1].X;
    CSBox.Height:=ClientHeight-PagePoint[1].Y;

    CCBSBox.Height:=CBtnPanel.Height-PagePoint[3].X;

    CListBtnPanel.Height:=CBtnPanel.Height-PagePoint[4].Y;
    CListBtnPanel.Left:=Pred(CBtnPanel.Left-CListBtnPanel.Width);

    If (MULCtrlO<>nil) then
    Begin
      LockWindowUpDate(Handle);

      With MULCtrlO,VisiList do
      Begin
        VisiRec:=List[0];

        With (VisiRec^.PanelObj as TSBSPanel) do
          Height:=CSBox.ClientHeight-PagePoint[3].Y;

        RefreshAllCols;
      end;

      LockWindowUpDate(0);

      MULCtrlO.ReFresh_Buttons;

    end;{Loop..}

    MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));

  end; {If time to update}
end;





procedure TBatchItems.SetFormProperties;


Var
  TmpPanel    :  Array[1..3] of TPanel;

  n           :  Byte;

  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;

Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;


  try

    With MULCtrlO.VisiList do
    Begin
      VisiRec:=List[0];

      TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
      TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

      TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
      TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


      TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
    end;

    TmpPanel[3].Font.Assign(TmpPanel[1].Font);

    TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;


    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],1,Caption+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          For n:=1 to 3 do
            With TmpPanel[n] do
              Case n of
                1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                3    :  MULCtrlO.ReColorBar(Font,Color);
              end; {Case..}

          MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
        end;

      end;

    finally

      ColourCtrl.Free;

    end;

  Finally

    For n:=1 to 3 do
      TmpPanel[n].Free;

  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;

end;

procedure TBatchItems.ShowRightMeny(X,Y,Mode  :  Integer);

Begin
  With PopUpMenu1 do
  Begin

    PopUp(X,Y);
  end;


end;


procedure TBatchItems.PopupMenu1Popup(Sender: TObject);

Var
  n  :  Integer;

begin
  StoreCoordFlg.Checked:=StoreCoord;

end;



procedure TBatchItems.PropFlgClick(Sender: TObject);
begin
  SetFormProperties;
end;

procedure TBatchItems.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;





procedure TBatchItems.ClsCP1BtnClick(Sender: TObject);
begin
  Close;
end;


procedure TBatchItems.CLORefPanelMouseUp(Sender: TObject;
                                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  BarPos :  Integer;
  PanRSized
         :  Boolean;

begin

  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    PanRSized:=ReSized;

    BarPos:=CSBox.HorzScrollBar.Position;

    If (PanRsized) then
      MULCtrlO.ResizeAllCols(MULCtrlO.VisiList.FindxHandle(Sender),BarPos);

    MULCtrlO.FinishColMove(BarPos+(ListOfset*Ord(PanRSized)),PanRsized);

    NeedCUpdate:=(MULCtrlO.VisiList.MovingLab or PanRSized);

  end;

end;


procedure TBatchItems.CLORefLabMouseMove(Sender: TObject; Shift: TShiftState;
                                               X, Y: Integer);
begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (MULCtrlO<>nil) then
    Begin
      MULCtrlO.VisiList.MoveLabel(X,Y);
      NeedCUpdate:=MULCtrlO.VisiList.MovingLab;
    end;
  end;

end;


procedure TBatchItems.CLORefLabMouseDown(Sender: TObject;
                                       Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

Var
  ListPoint  :  TPoint;


begin
  If (Sender is TSBSPanel) then
  With (Sender as TSBSPanel) do
  Begin

    If (Not ReadytoDrag) and (Button=MBLeft) then
    Begin
      If (MULCtrlO<>nil) then
        MULCtrlO.VisiList.PrimeMove(Sender);

      NeedCUpdate:=BOn;
    end
    else
      If (Button=mbRight) then
      Begin
        ListPoint:=ClientToScreen(Point(X,Y));

        ShowRightMeny(ListPoint.X,ListPoint.Y,0);
      end;

  end;
end;




procedure TBatchItems.FormActivate(Sender: TObject);
begin
  If (Assigned(MULCtrlO))  then
    MULCtrlO.SetListFocus;

end;




procedure TBatchItems.GenCP3BtnClick(Sender: TObject);
Var
  ReturnCtrl  :  TReturnCtrlRec;

begin

  {$IFDEF GF}

    If (Not MULCtrlO.InListFind)  then
    Begin

      With ReturnCtrl,MessageReturn do
      Begin
        FillChar(ReturnCtrl,Sizeof(ReturnCtrl),0);

        WParam:=3000;
        LParam:=0;
        Msg:=WM_CustGetRec;
        DisplayxParent:=BOn;
        ShowOnly:=BOn;
        Pass2Parent:=BOn;

        //PR: 04/12/2013 ABSEXCH-14824
        Ctrl_GlobalFind(Self, ReturnCtrl, tabFindDocument);

      end;
    end; {If in list find..}

  {$ENDIF}
end;



{ ========== Control Individual Tag ========== }

Procedure TBatchItems.BACS_TagDoc(Mode     :  Byte;
                                  LUpdate  :  Boolean;
                                  TOk,
                                  UOk      :  Boolean);
        Begin
  // CJS 2016-07-06 - ABSEXCH-17383 - amendments for eRCT Plugin
  // Moved functionality into BACS_TagTransaction so that it can be called
  // externally
  BACS_TagTransaction(Mode, LUpdate, TOk, UOk, MULCtrlO.KeyPath,
                      ExLocal, MULCtrlO.BatchCtrl, MULCtrlO, self);
      end;



{ ========== Control Individual Tag ========== }

Procedure TBatchItems.BACS_PartPayDoc(Mode     :  Byte);


Var
  DocCnst  :  Integer;
  DocAry   :  BACSAnalType;
  TagVal,
  TTagOwn  :  Real;
  UOR,
  N        :  Byte;

  LOK,
  LLocked,
  Ok2Store :  Boolean;

  KeyS     :  Str255;

  TmpGlobAlloc
           :  ^GlobAllocAry;

  EInv     :  InvRec;
  Res : Integer;
  //PR: 14/05/2015 ABSEXCH-12684 Dummy var for change to PartAllocate func
  TakePPD : Boolean;

  PPDAvailableInCurrency: Double;
Begin
  //PR: 26/08/2015 ABSEXCH-16795
  TakePPD := False;

  Ok2Store:=BOff;

  If (Mode=1) then
    DocCnst:=1
  else
    DocCnst:=-1;

  KeyS:=''; UOR:=0;

  New(TmpGlobAlloc);
  TmpGlobAlloc^:=GlobalAllocRec^;

  Blank(GlobalAllocRec^,Sizeof(GlobalAllocRec^));

  

  With MULCtrlO, ExLocal, LInv do
  Begin
    //PR: 06/10/2010 Now using a pre-fill cache for the list so we have to refind the selected transaction in the database
    //before part-allocating it
    if SQLUtils.UsingSQL then
    with MulCtrlO do
    begin
      if UsingSQL then PrepareSQLCall;
      SetDataRecOfs(ScanFileNum,PageKeys^[MuListBoxes[0].Row]);
      Res:=GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);
    end;

    if UsingSQL then PrepareSQLCall;
    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,LLocked);

    If (LOk) and (LLocked) then
    Begin
      ForceInvSDisc(LInv,EInv,BatchCtrl,1);


      LGetRecAddr(ScanFileNum);

      If (Tagged=1) then {* Reverse current Tag *}
        BACS_TagDoc(0,BOff,BOn,BOff);



      Blank(DocAry,Sizeof(DocAry));

      With BatchCtrl.BACSCRec do
      Begin
        TagVal:=0; TTagOwn:=0;

        {$IFDEF CL_On}
          With CLOrefPanel do  //PR: 14/05/2015 ABSEXCH-12684 Add TakePPD char
          begin
            PPDAvailableInCurrency := EInv.thPPDGoodsValue + EInv.thPPDVATValue;
            BatchThen:=PartAlloc(EInv,PayCurr,Color,Font,Self,TagVal,TTagOwn,Ok2Store,TakePPD,PPDAvailableInCurrency);
            if TakePPD then
              thBatchPayPPDStatus := PPD_BATCHPAY_SET
            else
              thBatchPayPPDStatus := PPD_BATCHPAY_UNSET;
          end;
          BatchNow:=TTagOwn;
        {$ELSE}
          BatchThen:=0;
          BatchNow:=0;
        {$ENDIF}

        {$IFDEF MC_On}

         {* Modified v4.30a *}

          UOR:=fxUseORate(UseCoDayRate,BOn,CXRate,UseORate,Currency,0);

          BatchNow:=Conv_TCurr(TTagOwn,XRate(CXRate,UseCoDayRate{BOff},Currency),Currency,UOR,BOn);

         If (Currency<>PayCurr) then
           TagVal:=Currency_ConvFT(BatchThen,0,PayCurr,UseCoDayRate)*DocCnst
         else
           TagVal:=BatchNow*DocCnst;

        {$ELSE}

         TagVal:=BatchThen*DocCnst;

        {$ENDIF}


        MasterAged(DocAry,Get_StaChkDate(LInv),TagASDate,TagVal,AgeType,AgeInt);

        LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

        Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,MIK,MiscF,BOn,LLocked);

        If (LOk) and (LLocked) then
        Begin
          LGetRecAddr(MiscF);

          With LMiscRecs^.BACSSRec do
            For N:=1 to NoBACSTot do
              TotalTagged[N]:=TotalTagged[N]+DocAry[N];

          Status:=Put_Rec(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK);

          Report_BError(MiscF,Status);

          UnLockMLock(MiscF,LastRecAddr[MiscF]);

          ExLocal.LastInv:=ExLocal.LInv;

          LSetDataRecOfs(ScanFileNum,LastRecAddr[ScanFileNum]); {* Retrieve record by address Preserve position *}

          if UsingSQL then PrepareSQLCall;
          Status:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath,0); {* Re-Establish Position *}

          ExLocal.LInv:=ExLocal.LastInv;

          ExLocal.AssignToGlobal(InvF);

          Send_UpdateList(71);

        end;

      end; {With..}

      Tagged:=Ord(TagVal<>0.0);


      If (Tagged=0) then
      Begin
        BatchNow:=0;
        BatchThen:=0;
      end;

      LastInv:=LInv;

      LSetDataRecOfs(ScanFileNum,LastRecAddr[ScanFileNum]); {* Retrieve record by address Preserve position *}

      if UsingSQL then PrepareSQLCall;
      Status:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath,0); {* Re-Establish Position *}

      LInv:=LastInv;

      if UsingSQL then PrepareSQLCall;
      Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

      Report_BError(ScanFileNum,Status);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

      AddNewRow(MUListBoxes[0].Row,BOn);

    end; {With..}
  end; {If Locked ok}

  GlobalAllocRec^:=TmpGlobAlloc^;

  Dispose(TmpGLobAlloc);

end; {Proc..}


{ ========== Control Individual Tag ========== }

Procedure TBatchItems.BACS_SetDocDisc(Mode  :  Byte);


Var
  PDocAry,
  DocAry   :  BACSAnalType;

  N,
  UOR      :  Byte;

  EDisc,
  IDisc    :  Double;

  EInv     :  InvRec;

  LOK,
  LLocked,
  Ok2Store :  Boolean;

  KeyS     :  Str255;

  mrResult :  Word;

  ISCtrl   :  TCLPAL;

  Res : Integer;
  Row: Integer;
Begin
  Ok2Store:=BOff;

  KeyS:='';

  UOR:=0;  Edisc:=0.0; IDisc:=0.0;

  Blank(DocAry,Sizeof(DocAry));
  Blank(PDocAry,Sizeof(PDocAry));

  With MULCtrlO, ExLocal, LInv do
  Begin
    //PR: 06/10/2010 Now using a pre-fill cache for the list so we have to refind the selected transaction in the database
    //before changing the settlement discount
    if SQLUtils.UsingSQL then
    with MulCtrlO do
    begin
      if UsingSQL then PrepareSQLCall;
      SetDataRecOfs(ScanFileNum,PageKeys^[MuListBoxes[0].Row]);
      Res := GetDirect(F[ScanFileNum],ScanFileNum,RecPtr[ScanFileNum]^,KeyPath,0);
    end;

    if UsingSQL then PrepareSQLCall;
    LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,ScanFileNum,BOff,LLocked);

    If (LOk) and (LLocked) then
    Begin
      EInv:=LInv;

      LGetRecAddr(ScanFileNum);

      With BatchCtrl.BACSCRec do
      Begin
        UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

        EDisc:=Round_Up(Currency_ConvFT(Conv_TCurr(EInv.BDiscount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),0,PayCurr,
                      UseCoDayRate),2);

        MasterAged(PDocAry,Get_StaChkDate(EInv),TagASDate,EDisc*DocCnst[InvDocHed],AgeType,AgeInt);

          ISCtrl:=TCLPAL.Create(Self);

          try

            With ISCtrl do
            Begin
              PAValue:=BDiscount;

              BSDiscMode:=BOn;
              BCurSymb:=SSymb(Currency);

              mrResult:=InitIS(BOff,CLORefPanel.Color,CLORefPanel.Font);

              If (mrResult=mrOk) then
              Begin
                BDiscount:=PAValue;
              end;
            end;

          finally

            ISCtrl.Free;

          end; {Try..}



        If (MrResult=mrOk) then
        Begin
          IDisc:=Round_Up(Currency_ConvFT(Conv_TCurr(BDiscount,XRate(CXRate,BOff,Currency),Currency,UOR,BOff),0,PayCurr,
                      UseCoDayRate),2);


          MasterAged(DocAry,Get_StaChkDate(Inv),TagASDate,IDisc*DocCnst[InvDocHed],AgeType,AgeInt);

          LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

          Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,MIK,MiscF,BOn,LLocked);

          If (LOk) and (LLocked) then
          Begin
            LGetRecAddr(MiscF);

            {* Refresh BatchCtrl *}

            Send_UpdateList(77);

            {Lock totals}
            BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,1);


            For N:=1 to NoBACSTot do
            Begin
              With LMiscRecs^.BACSSRec do
                TotalOS[N]:=TotalOS[N]+(DocAry[N]-PDocAry[N]);

              With BatchCtrl.BACSCRec do
                TotalTag[N]:=Round_Up(TotalTag[N]+(DocAry[N]-PDocAry[N]),2);
            end;

            Status:=Put_Rec(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK);

            Report_BError(MiscF,Status);

            UnLockMLock(MiscF,LastRecAddr[MiscF]);

            BACS_CtrlPut(PWrdF,PWK,BatchCtrl,nil,0);

            {*Replace Batch Ctrl *}

            Send_UpdateList(78);

            {* Update list view *}

            Send_UpdateList(71);

          end;
        end;
      end; {With..}

      LastInv:=LInv;

      LSetDataRecOfs(ScanFileNum,LastRecAddr[ScanFileNum]); {* Retrieve record by address Preserve position *}

      if UsingSQL then PrepareSQLCall;
      Status:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,Keypath,0); {* Re-Establish Position *}

      LInv:=LastInv;

      if UsingSQL then PrepareSQLCall;
      Status:=Put_Rec(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPAth);

      Report_BError(ScanFileNum,Status);

      UnLockMLock(ScanFileNum,LastRecAddr[ScanFileNum]);

      AddNewRow(MUListBoxes[0].Row,BOn);

      //PR: 06/10/2010 refresh list to drop and restore Pre-fill cache
      // CJS 2015-05-22 - T2-160 - amended to redisplay without a complete
      // refresh of the list
      if SQLUtils.UsingSQL then
      begin
        Row := MULCtrlO.MUListBoxes[0].Row;
        MULCtrlO.RefreshCache;
        MULCtrlO.Set_Row(Row);
      end;

    end; {With..}
  end; {If Locked ok}

end; {Proc..}




procedure TBatchItems.btnTagClick(Sender: TObject);

Var
  AgingColumn :  SmallInt;
  TagMode: Boolean;
  Res      : Integer;
  TagByTransaction: Boolean;
  IsTaggedByAccount: Boolean;
  Row: Integer;
begin
  If (MULCtrlO.ValidLine) then
  With ExLocal,LMiscRecs^.BACSSRec, MULCtrlO.BatchCtrl.BACSCRec,Inv do
  Begin

    // CJS 2015-09-03 - ABSEXCH-16819 - Incorrect Paid This Run value on tagged Batch Payments
    // Make sure that the local LInv holds the current record
    AssignFromGlobal(InvF);

    LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

    TagMode:=((Sender=btnTag) or (Sender=Tag1));

    //PR: 05/10/2010 Now using a pre-fill cache for the list so we have to refind the selected transaction in the database
    //before tagging it
    if SQLUtils.UsingSQL then
    with MulCtrlO do
    begin
      if UsingSQL then PrepareSQLCall;
      LSetDataRecOfs(ScanFileNum,PageKeys^[MuListBoxes[0].Row]);
      Res:=GetDirect(F[ScanFileNum],ScanFileNum,LRecPtr[ScanFileNum]^,KeyPath,0);
    end;

    TagByTransaction := (((Inv.Tagged=1) and (Not TagMode)) or ((Inv.Tagged=0) and (TagMode)));

    AgingColumn := Succ(AgedPos(Get_StaChkDate(Inv),TagAsDate,AgeType,AgeInt));

    IsTaggedByAccount := HasTagged[AgingColumn];

    // If we are untagging a Transaction where the items are currently tagged
    // by account, or if the items are not tagged by account, we can continue
    // with the tag.
    If ((Tagged=0) and (Not TagMode)) or (Not IsTaggedByAccount) then
    begin
      BACS_TagDoc(Ord(TagMode), True, TagByTransaction, IsTaggedByAccount);

      // Update the display of the current row
      if SQLUtils.UsingSQL then
      begin
        Row := MULCtrlO.MUListBoxes[0].Row;
        MULCtrlO.RefreshCache;
        MULCtrlO.Set_Row(Row);
      end;

    end;
  end;
end;

procedure TBatchItems.btnPartAllocateClick(Sender: TObject);

Var
  BColNo   :  SmallInt;
  Row: Integer;
begin
  If (MULCtrlO.ValidLine) then
  With ExLocal,LMiscRecs^.BACSSRec, MULCtrlO.BatchCtrl.BACSCRec,Inv do
  Begin

    // CJS 2015-09-03 - ABSEXCH-16819 - Incorrect Paid This Run value on tagged Batch Payments
    // Make sure that the local LInv holds the current record
    AssignFromGlobal(InvF);

    LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

    BColNo:=Succ(AgedPos(Get_StaChkDate(Inv),TagAsDate,AgeType,AgeInt));

    If (Not HasTagged[BColNo]) then
    Begin
      If (BDiscount=0.0) then
        BACS_PartPayDoc(1)
      else
      Begin
        Set_BackThreadMVisible(BOn);

        ShowMessage('It is not possible to part allocate a transaction if settlement discount has been applied.'+#13+
                    'Please remove the settlement discount first, before attempting to part allocate.');

        Set_BackThreadMVisible(BOff);

      end;
    end;

    //PR: 18/01/2011 Refresh list to reload prefill cache (ABSEXCH-10738)
    // CJS 2015-05-22 - T2-160 - amended to redisplay without a complete
    // refresh of the list
    if SQLUtils.UsingSQL then
    begin
      Row := MULCtrlO.MUListBoxes[0].Row;
      MULCtrlO.RefreshCache;
      MULCtrlO.Set_Row(Row);
    end;

  end; {With..}

end;

procedure TBatchItems.btnWriteOffClick(Sender: TObject);
Var
  BColNo   :  SmallInt;

begin
  If (MULCtrlO.ValidLine) then
  With ExLocal,LMiscRecs^.BACSSRec, MULCtrlO.BatchCtrl.BACSCRec,Inv do
  Begin

    // CJS 2015-09-03 - ABSEXCH-16819 - Incorrect Paid This Run value on tagged Batch Payments
    // Make sure that the local LInv holds the current record
    AssignFromGlobal(InvF);

    LSetDataRecOfs(MiscF,LastRecAddr[MiscF]); {* Retrieve record by address Preserve position *}

    Status:=GetDirect(F[MiscF],MiscF,LRecPtr[MiscF]^,MIK,0); {* Re-Establish Position *}

    BColNo:=Succ(AgedPos(Get_StaChkDate(Inv),TagAsDate,AgeType,AgeInt));

    If (Not HasTagged[BColNo]) and (Not DiscTaken) and (Not PDiscTaken) and (Not (InvDocHed In RecieptSet)) then
    Begin
      If  (BatchThen=0.0) then
        BACS_SetDocDisc(1)
      else
      Begin
        Set_BackThreadMVisible(BOn);

        ShowMessage('It is not possible to adjust the settlement write-off on a part allocated transaction.'+#13+
                    'Please remove the write-off first, before attempting to adjust the discount.');

        Set_BackThreadMVisible(BOff);

      end;
    end;

  end; {With..}

end;

procedure TBatchItems.SetHelpContextIDs;
// NF: 20/06/06 support for different IDs for Sales and Purchase.

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
//      if AControl.Name = 'ClsCP1Btn' then exit;

      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

var
  bSales : boolean;
begin
  // Fix incorrect IDs
//  CompF.HelpContext := 1841;

  bSales := RecMode;
  {$IFDEF LTE}
    // Set Correct Tab IDs
    if bSales then IncHelpContextIDs(5000, Self);
  {$ELSE}
    // Exchequer
  {$ENDIF}
end;

procedure TBatchItems.CBtnPanelDblClick(Sender: TObject);
begin
  ShowMessage(IntToStr(self.Handle));
end;

// CJS 2015-05-18 - T2-160 - Set/Unset PPD
procedure TBatchItems.btnSetUnsetPPDClick(Sender: TObject);
begin
  GiveTakePPD;
end;

// -----------------------------------------------------------------------------

procedure TBatchItems.GiveTakePPD;
var
  PPDAvailable: Double;
begin
  // Make sure we have the correct Transaction record
  with MulCtrlO do
  begin
    if UsingSQL then PrepareSQLCall;
    SetDataRecOfs(ScanFileNum, PageKeys^[MuListBoxes[0].Row]);
    Status := GetDirect(F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath, 0);
    Report_BError(ScanFileNum, Status);
  end;

  PPDAvailable := (Inv.thPPDGoodsValue + Inv.thPPDVATValue) * DocCnst[Inv.InvDocHed] * DocNotCnst;
  if (Inv.Currency <> MULCtrlO.BatchCtrl.BACSCRec.PayCurr) then
    PPDAvailable := Conv_TCurr(PPDAvailable, XRate(Inv.CXRate, BOff, Inv.Currency), Inv.Currency, 0, BOff);

  if Inv.thBatchPayPPDStatus = PPD_BATCHPAY_UNSET then
  begin
    Inv.thBatchPayPPDStatus := PPD_BATCHPAY_SET;
    ApplyPPD(PPDAvailable);
  end
  else
  begin
    Inv.thBatchPayPPDStatus := PPD_BATCHPAY_UNSET;
    ApplyPPD(-PPDAvailable);
  end;
  UpdateUIState;
end;

// -----------------------------------------------------------------------------

// CJS 2015-05-18 - T2-160 - Set/Unset PPD
procedure TBatchItems.ApplyPPD(Amount: Double);
var
  AgingColumn: Integer;
  PPDAvailableInBase: Double;
  Row: Integer;
begin
  // Determine the correct AgingColumn
  With MULCtrlO.BatchCtrl.BACSCRec do
    AgingColumn := Succ(AgedPos(Get_StaChkDate(Inv), TagAsDate, AgeType, AgeInt));

  // BACS Control Record

  // Lock the record
  BACS_CtrlPut(PWrdF, PWK, MULCtrlO.BatchCtrl, nil, 1);

  with MULCtrlO.BatchCtrl.BACSCRec do
  begin
    if ExLocal.LMiscRecs^.BACSSRec.HasTagged[0] or (Inv.Tagged = 1) then
    begin
      // Update the Outstanding amount
      TotalTag[AgingColumn] := TotalTag[AgingColumn] - Amount;

      // If entries are tagged, update the Total Tagged amount
      if TotalTag[0] <> 0 then
        TotalTag[0] := TotalTag[0] - Amount;
    end;
  end;

  // Store (and unlock) the record
  BACS_CtrlPut(PWrdF, PWK, MULCtrlO.BatchCtrl, nil, 2);

  // BACS Trader Account Record

  // Make sure we have the right record
  ExLocal.LSetDataRecOfs(MiscF, ExLocal.LastRecAddr[MiscF]);
  Status := GetDirect(F[MiscF], MiscF, ExLocal.LRecPtr[MiscF]^, MIK, 0);

  With ExLocal.LMiscRecs^.BACSSRec do
  begin
    // Update the Outstanding amounts
    TotalOS[0]           := TotalOS[0] - Amount;
    TotalOS[AgingColumn] := TotalOS[AgingColumn] - Amount;

    // If entries are tagged, update the TotalTagged and TagBal fields as well
    if HasTagged[0] or (Inv.Tagged = 1) then
    begin
      TotalTagged[0]           := TotalTagged[0] - Amount;
      TotalTagged[AgingColumn] := TotalTagged[AgingColumn] - Amount;
      TagBal := TagBal - Amount;
    end;
  end;

  // Store the record
  Status := Put_Rec(F[MiscF], MiscF, ExLocal.LRecPtr[MiscF]^, MIK);
  Report_BError(MiscF, Status);

  // Transaction

  // If this transaction is tagged, update BatchNow and BatchThen
  if (Inv.BatchNow <> 0) then
  begin
    Inv.BatchNow := Inv.BatchNow - Amount;
    PPDAvailableInBase := Conv_TCurr(Amount, XRate(Inv.CXRate, BOff, Inv.Currency), Inv.Currency, 0, BOff);
    Inv.BatchThen := Inv.BatchThen - PPDAvailableInBase;
  end;

  // Store the record
  with MulCtrlO do
  begin
    if UsingSQL then PrepareSQLCall;
    Status := Put_Rec(F[ScanFileNum], ScanFileNum, RecPtr[ScanFileNum]^, KeyPath);
    Report_BError(ScanFileNum, Status);
  end;

  // Update this list
  Row := MULCtrlO.MUListBoxes[0].Row;
  if SQLUtils.UsingSQL then
    MULCtrlO.RefreshCache;
  MULCtrlO.Set_Row(Row);

  // Update the main Batch Payments list
  Send_UpdateList(71);
end;

// -----------------------------------------------------------------------------

procedure TBatchItems.UpdateUIState;
var
  AllowDiscount: Boolean;
  PaidThisRun: Double;
  Outstanding: Double;
  FullyPaid: Boolean;
  HasPPD: Boolean;
  ValidLine: Boolean;
begin
  If (Assigned(MULCtrlO)) then
  begin
    AllowDiscount := ChkAllowed_In(264 + Ord(MULCtrlO.BatchCtrl.BACSCRec.SalesMode));
    ValidLine := MULCtrlO.SelectedRowIsValid;
  end
  else
  begin
    AllowDiscount := False;
    ValidLine := False;
  end;

  if ValidLine then
  begin
    // Tag and Part-Allocate are only available if we are tagging transactions
    // individually (note that Untag is still available, to allow single
    // transactions to be excluded). Also Part-Allocate is only available if
    // PPD is not marked for taking on this transaction
    btnTag.Enabled          := not TaggedByAccount;
    Tag1.Enabled            := not TaggedByAccount;
    btnUnTag.Enabled        := True;
    ReCalc1.Enabled         := not TaggedByAccount;

    // CJS 2015-07-09 - ABSEXCH-16653 - Disallow Part Allocation if PPD is already taken
    if Inv.thPPDTaken <> ptPPDNotTaken then
      btnPartAllocate.Enabled := False
    else
      btnPartAllocate.Enabled := (not TaggedByAccount) and (Inv.thBatchPayPPDStatus = PPD_BATCHPAY_UNSET);

    if (Inv.TransDate < '20150401') then
      // For Transactions previous to 1 April 2015 use the Settlement Discount
      // system...
      btnWriteOff.Enabled := AllowDiscount and TransactionHelper(@Inv).SettlementDiscountSupported
    else
      // ...otherwise use the new Prompt Payment Discount system
      btnWriteOff.Enabled := (not TaggedByAccount) and AllowDiscount and (SystemSetup.ControlCodes.ssSettlementWriteOffCtrlGL <> 0);

    Discount1.Enabled := btnWriteOff.Enabled;
    //HV 29/06/2016 2016-R3 ABSEXCH-17033: Can Unset PPD by selecting Part Allocate option through right click menu in Batch Payment/Receipt List sync with current state of Part Allocate button.
    ReCalc1.Enabled := btnPartAllocate.Enabled;
    // We need to know whether this transaction has been part-allocated. The only
    // way to do this is to see if there is a difference betweent the amount
    // outstanding and the amount paid.
    PaidThisRun := Round_Up(Inv.BatchThen*DocCnst[Inv.InvDocHed]*DocNotCnst, 2);
    Outstanding := Round_Up(MULCtrlO.AmountOutstanding, 2);
    FullyPaid   := (Outstanding = PaidThisRun);

    // CJS 2015-06-23 - ABSEXCH-16519 - Batch Payments after taking PPD via ledger
    // CJS 2015-06-29 - ABSEXCH-16612 - allow expired PPD to be taken
    HasPPD := PPDFieldsPopulated(Inv);
    // CJS 2015-07-09 - ABSEXCH-16652 - Disallow Set/Unset PPD if PPD is already taken
    if (Inv.thPPDTaken = ptPPDNotTaken) and HasPPD and (FullyPaid or (PaidThisRun = 0)) then
    begin
      btnSetUnsetPPD.Enabled := True;
      if Inv.thBatchPayPPDStatus = PPD_BATCHPAY_UNSET then
        btnSetUnsetPPD.Caption := 'Set PPD'
      else
        btnSetUnsetPPD.Caption := 'Unset PPD';
    end
    else
      // If the Amount Outstanding is not the same as Paid This Run, the user
      // must have used Part Allocate to amend the value, so PPD is no longer
      // available
      btnSetUnsetPPD.Enabled := False;
  end
  else
  begin
    // We are on an empty line, so disable everything
    btnTag.Enabled          := False;
    btnUnTag.Enabled        := False;
    btnPartAllocate.Enabled := False;
    Tag1.Enabled            := False;
    ReCalc1.Enabled         := False;
    Discount1.Enabled       := False;
    btnSetUnsetPPD.Enabled  := False;
  end;
end;

// -----------------------------------------------------------------------------

Initialization

  BIFormMode:=BOff;

end.
