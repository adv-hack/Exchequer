unit CredPopU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, Mask, ExtCtrls, SBSPanel,
  GlobVar,VarConst,VarRec2U,ExWrap1U, BTSupU1, Recon3U,   SalTxL1U, BorBtns;


type
  tAgeCurrency = Record
                   OwnAged  :  AgedTyp;
                   BaseAged :  AgedTyp;
                 end;

  TAgeBy = (abDays = 1, abWeeks, abMonths);

  TCredThread = class(TThread)
  private
    fKeyChk  :  Str255;
    fAgeX,

   fMode    :  Byte;
   //GS 20/03/2012 ABSEXCH-9584: array for preserving the base currency values
   //of the credit fields
   CreditVal : Array[1..4] of Extended;

    fAgeInt  :  Integer;
    fAgeAs   :  LongDate;

    {$IFDEF SOP}
      fUseHO   :  Boolean;
      fHOAc    :  CustRec;
    {$ENDIF}

    {$IFDEF MC_On}
    fShowCurrSym: Boolean;
    {$ENDIF}


    Display  :  Array[1..5] of TCurrencyEdit;
    //GS 20/03/2012 ABSEXCH-9584: array for storing the handles of the credit fields
    CreditDisplay  :  Array[1..4] of TCurrencyEdit; 
    TotAged  :  AgedTyp;

    CurrAged :  Array[0..CurrencyType] of tAgeCurrency;

    CustAlObj:  GetExNObjCid;

    ShowLPDate  :  TEditDate;

    ExLocal  :  TdMTExLocalPtr;

    procedure ThreadDelay(dt  :  Word;
                          SAPM:  Boolean);

    procedure SetTotals;


  protected
    BeingCreated1,
    BeingCreated2,
    UseOsKey       :  Boolean;
    
    //GS 20/03/2012 ABSEXCH-9584: var for storing the target credit currency
    fTxLate,
    fCurrency,
    CreditTranslate:  Byte;


    procedure Execute; override;

    procedure OutTotals;

  public
    InThreadSynch  :  Boolean;

    constructor Create(CustR,
                       HOCust  :  CustRec;
                       AgeX,
                       TMode,
                       RCurr,
                       RTxLate
                               :  Byte;
                       AgeInt  :  Integer;
                       AgeAs   :  LongDate;
                       UseHO,
                       UseOSK  :  Boolean;
                       TC1,TC2,TC3,TC4,TC5
                               :  TCurrencyEdit;
                         TED1  :  TEditDate;
                       ShowCurrSym: Boolean); Overload;

    //GS 20/03/2012 ABSEXCH-9584: overloaded constructor to handle credit field currency translation
    constructor Create(CustR,
                       HOCust  :  CustRec;
                       AgeX,
                       TMode,
                       RCurr,
                       RTxLate
                               :  Byte;
                       AgeInt  :  Integer;
                       AgeAs   :  LongDate;
                       UseHO,
                       UseOSK  :  Boolean;
                       TC1,TC2,TC3,TC4,TC5
                               :  TCurrencyEdit;
                         TED1  :  TEditDate;
                       ShowCurrSym: Boolean;
                       CreditField1, CreditField2, CreditField3,
                       CreditField4: TCurrencyEdit;
                       CreditTranslate: Byte); Overload;

    Destructor Destroy; override;

    procedure CleanUp;

    Function WaitforTerminate  :  Boolean;

    procedure Set_NewAge(KeyChk  :  Str255;
                         AgeX,
                         RCurr,
                         RTxlate :  Byte;
                         AgeInt  :  Integer;
                         AgeAs   :  LongDate;
                         UseHO   :  Boolean;
                         HOCust  :  CustRec);

  private

    ExecuteOff  :  Boolean;

    // CJS 2011-09-07 Revised calculation of Ageing Column
    Procedure MasterAged(Var AgedAry  :  AgedTyp;
                             DueDate,
                             AsAtDate :  LongDate;
                             Amount   :  Real;
                             DrvMode  :  Byte;
                             Interval :  Integer);

    Procedure CredAging_Scan;

    {$IFDEF SOP}
      Procedure SPOP_Scan;
    {$ENDIF}

    Procedure LastPaid_Scan;

  end;


  TCredPopUp = class(TForm)
    SBSPanel1: TSBSPanel;
    AccCodeLab: Label8;
    AccF: Text8Pt;
    CompF: Text8Pt;
    CrLimitLab: Label8;
    BalanceLab: Label8;
    CredAvailLab: Label8;
    CrLimF: TCurrencyEdit;
    BalF: TCurrencyEdit;
    CommitF: TCurrencyEdit;
    AvailF: TCurrencyEdit;
    CommitBttn: TButton;
    SOPPanel: TSBSPanel;
    SORF: TCurrencyEdit;
    SDNF: TCurrencyEdit;
    SORLab: Label8;
    SDNLab: Label8;
    SBSPanel3: TSBSPanel;
    AgeAtLab: Label8;
    AgeAtF: TEditDate;
    AgeByLab: Label8;
    AgeByF: TSBSComboBox;
    AgeIntLab: Label8;
    AgeIntF: TCurrencyEdit;
    DDaysF: TCurrencyEdit;
    DDaysLab1: Label8;
    DDaysLab2: Label8;
    Age1: TCurrencyEdit;
    Age2: TCurrencyEdit;
    Age3: TCurrencyEdit;
    Age4: TCurrencyEdit;
    Age1Lab: Label8;
    Age2Lab: Label8;
    Age3Lab: Label8;
    Age4Lab: Label8;
    SBSPanel2: TSBSPanel;
    OkCP1Btn: TButton;
    FrzeBtn: TButton;
    Label81: Label8;
    Label82: Label8;
    CredSF: TCurrencyEdit;
    Age5: TCurrencyEdit;
    Age5Lab: Label8;
    IntText: Label8;
    HOComF: TBorCheck;
    Label83: Label8;
    CurrF: TSBSComboBox;
    Label811: Label8;
    CurrF2: TSBSComboBox;
    Label84: Label8;
    LastPaidF: TEditDate;
    Label85: Label8;
    CurrF3: TSBSComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure AccFExit(Sender: TObject);
    procedure CommitBttnClick(Sender: TObject);
    procedure AgeByFChange(Sender: TObject);
    procedure CompFDblClick(Sender: TObject);
    procedure Age1DblClick(Sender: TObject);
    procedure FrzeBtnClick(Sender: TObject);
    procedure SORFDblClick(Sender: TObject);
    procedure AccFDblClick(Sender: TObject);
    procedure HOComFClick(Sender: TObject);
    procedure HOComFMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SDNFChange(Sender: TObject);
    procedure CurrFChange(Sender: TObject);
  private
    { Private declarations }

    ComBtnClicked,
    fFreeze,
    UseOSNdx,
    
    InReset     :  Boolean;
    fAgeX,
    fCurrency,
    fTxlate,
    //GS 31/01/2012 ABSEXCH-9584: vars to store target currency for the credit fields
    fCreditTxlate     :  Byte;
    fAgeInt     :  Integer;

    fAgeAs      :  LongDate;

    LastLedgMode
                :  Byte;



    {$IFDEF SOP}
      fUseHO    :  Boolean;
      fHOAC     :  CustRec;


      ShowOrders,
    {$ENDIF}


    ShowTotals  :  TCredThread;

    DispCust    :  TFCustDisplay;

    procedure SetCaption;

    procedure Set_Currency;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure OutCred;

    procedure SetAgeCaption;

    procedure CalcTotals;

    procedure ResetTotals;

    {$IFDEF SOP}
      procedure ShowCommitHO;

      procedure CalcOrdTotals;

      procedure ResetOrdTotals(ReStart  :  Boolean);

    {$ENDIF}

    procedure Link2Ledger(MOfset  :  SmallInt);

    procedure SetFreeze(F  :  Boolean);

    Function Check_MainThread  :  Boolean;

  public
    { Public declarations }

    ExLocal    :  TdExLocal;

    procedure SetUpAccount(CustR  :  Str10);

    Property  Freeze  :  Boolean Read fFreeze Write SetFreeze;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  BtrvU2,
  BtKeys1U,
  SBSComp2,
  BTSupU2,
  CurrncyU,
  DocSupU1,
  ComnUnit,
  InvListU,
  ExThrd2U,
  // CJS 2011-09-07 Revised calculation of Ageing Column
  SQLUtils,
  SQLRep_Config,
  Math,
  StrUtil,
  DateUtils,

  SysU3;

{$R *.DFM}



{ TCredThread }

constructor TCredThread.Create(CustR,
                               HOCust  :  CustRec;
                               AgeX,
                               TMode,
                               RCurr,
                               RTxLate
                                       :  Byte;
                               AgeInt  :  Integer;
                               AgeAs   :  LongDate;
                               UseHO,
                               UseOSK   :  Boolean;
                               TC1,TC2,TC3,TC4,TC5
                                       :  TCurrencyEdit;
                                 TED1  :  TEditDate;

                               ShowCurrSym: Boolean);

begin
  InThreadsynch:=BOff;
  
  BeingCreated1:=BOn;
  BeingCreated2:=BOn;

  UseOSKey:=UseOSK;

  FreeOnTerminate := BOff;
  fKeyChk:=CustR.CustCode;
  fAgeX:=AgeX;
  fAgeAs:=AgeAs;
  fAgeInt:=AgeInt;
  fMode:=TMode;
  fCurrency:=RCurr;
  fTxLate:=rTxlate;
  {$IFDEF MC_On}
  {fShowCurrSym:=ShowCurrSym;}
  {$ENDIF}

  {$IFDEF SOP}
    fUseHO:=UseHO;
    fHOAc:=HOCust;
  {$ENDIF}


  Display[1]:=TC1;
  Display[2]:=TC2;
  Display[3]:=TC3;
  Display[4]:=TC4;
  Display[5]:=TC5;

  ShowLPDate:=TED1;

  ExecuteOff:=BOff;

  FillChar(Totaged,Sizeof(TotAged),0);
  FillChar(Curraged,Sizeof(CurrAged),0);

  New(ExLocal,Create(29+fMode));

  try
    With ExLocal^ do
    Begin
      LCust:=CustR;

      {$IFDEF SOP}
        Open_System(CustF,InvF);
      {$ELSE}
        Open_System(InvF,InvF);
      {$ENDIF}

    end;

    New(CustAlObj,Init);

    CustAlObj.MTExLocal:=ExLocal;
  except
    ShowMessage('Unable to create Credit Controller thread.');

  end;

  inherited Create(True);

  Priority:=tpIdle;

  Resume;

end;

Destructor TCredThread.Destroy;

Begin
  {ExLocal.Destroy;}

  Inherited Destroy;
end;


procedure TCredThread.CleanUp;

Begin
  Dispose(CustAlObj,Done);

  Dispose(ExLocal,Destroy);

  {ExLocal.Destroy;}
end;


procedure TCredThread.Set_NewAge(KeyChk  :  Str255;
                                 AgeX,
                                 RCurr,
                                 RTxlate :  Byte;
                                 AgeInt  :  Integer;
                                 AgeAs   :  LongDate;
                                 UseHO   :  Boolean;
                                 HOCust  :  CustRec);

Begin
  If (fKeyChk<>KeyChk) then
    fKeyChk:=KeyChk;

  If (AgeX<>fAgeX) then
    fAgeX:=AgeX;

  If (AgeInt<>fAgeInt) then
    fAgeInt:=AgeInt;

  If (AgeAs<>fAgeAs) then
    fAgeAs:=AgeAs;

  {$IFDEF SOP}
    If (fUseHO<>UseHO) then
      fUseHO:=UseHO;

    If (HOCust.CustCode<>fHOAc.CustCode) then
      fHOAc:=HOCust;

  {$ENDIF}

  {$IFDEF MC_On}
    If (fCurrency<>RCurr) then
      fCurrency:=RCurr;

    If (fTxLate<>RTxLate) then
      fTxLate:=RTxLate;
  {$ENDIF}

end;

procedure TCredThread.ThreadDelay(dt  :  Word;
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

Function TCredThread.WaitforTerminate  :  Boolean;

Var
  n       :  Integer;

  TmpBo   :  Boolean;

Begin
  n:=0;

  Repeat

    Inc(n);

    Application.ProcessMessages;

    ThreadDelay(200,BOn);

    TmpBo:=Terminated;

    ThreadDelay(200,BOn);

    If (TmpBo) then
      TmpBo:=ExecuteOff;

  Until (TmpBo) or (n>9);

  Result:=TmpBo;
end;


procedure TCredThread.SetTotals;
Var
  n,
  CS :  Byte;
begin
  CS := 0;
  If (fMode=0) then
  Begin
    If (fTxLate=0) then
    Begin
      If (fCurrency=0) then
        TotAged:=CurrAged[0].BaseAged
      else
        TotAged:=CurrAged[fCurrency].OwnAged;
      CS:=fCurrency;
    end
    else
    Begin
      For n:=Low(Display) to High(Display) do
        TotAged[n]:=Currency_Txlate(CurrAged[fCurrency].BaseAged[n],0,fTxlate);

      CS:=fTxlate;
    end;
  end;

  For n:=Low(Display) to High(Display) do
    If (Assigned(Display[n])) then
    Begin
      {$IFDEF MC_On}
         // HM 13/06/02: Added flag to suppress currency symbols on
         //              Order/Delivery note Outstanding fields


         If fShowCurrSym Then
         Begin
           Display[n].ShowCurrency:=BOn;

           If (Display[n].CurrencySymb<>SSymb(CS)) then
             Display[n].Value:=0.001;

           Display[n].CurrencySymb:=SSymb(CS);
         end;
         {else //EL: 05/07/2002. v5,00.002. Could optinaly show currency symbol on the comitted values as well, but as upper part all
                 assumed to be base currency, would need to do it for them too.
         Begin
           If (Display[n].CurrencySymb<>PSymb(0)) then
             Display[n].Value:=0.001;

           Display[n].CurrencySymb:=PSymb(0);
         end;}

      {$ENDIF}

      Display[n].Value:=TotAged[n];

    end;

    //GS 20/03/2012 ABSEXCH-9584: translate the credit values:
    //iterate the array of credit field handles
    For n:=Low(CreditDisplay) to High(CreditDisplay) do
    begin
      //if the target handle is assigned
      If (Assigned(CreditDisplay[n])) then
      begin
        //examine the users selected TX currency;
        //populate the target field with the translated currency val, or revert to displaything the base val
        if CreditTranslate <> 0 then
        begin
          //currency has been changed to a nonbase currency; translate the base val to the target currency
          CreditDisplay[n].value := Currency_Txlate(CreditVal[n],0,CreditTranslate);
        end
        else
        begin
          //currency has been changed to the base currency; no need to translate, just display the preserved base value
          CreditDisplay[n].value := CreditVal[n];
        end;//end if
      end;//end if
    end;//end for

end;

procedure TCredThread.OutTotals;
begin
  InThreadSynch:=BOn;

  Synchronize(SetTotals);

  InThreadSynch:=BOff;
end;

{ The Execute method is called when the thread starts }

procedure TCredThread.Execute;
begin
  ExecuteOff:=BOff;

  try
    Case fMode of
      0  :  CredAging_Scan;

      {$IFDEF SOP}
        1  :  SPOP_Scan;
      {$ENDIF}

    end; {Case..}
  finally
    ExecuteOff:=BOn;
    InThreadSynch:=BOff;

  end;

end;

procedure TCredThread.MasterAged(var AgedAry: AgedTyp; DueDate,
  AsAtDate: LongDate; Amount: Real; DrvMode: Byte; Interval: Integer);
var
  AgeBy: TAgeBy;
  AgeColumn: Integer;
  Gap: Integer;
  DocumentDate: TDateTime;
  EffectiveDate: TDateTime;
begin
  Gap := 0;
  if (DueDate >= AsAtDate) then
    AgeColumn := 0
  else
  begin
    AgeBy := TAgeBy(DrvMode);
    case AgeBy of
      abDays: Gap := DaysBetween(ToDateTime(DueDate), ToDateTime(AsAtDate));
      abWeeks: begin
                 {
                   SQL-Compatible. SQL uses a 'datediff()' function, which for
                   weeks calculates the difference between the weeks that the
                   dates fall in. Unfortunately, SQL assumes that a week begins
                   on a Sunday, whereas Delphi assumes that it begins on a
                   Monday. To produce the same results as SQL, we get the start
                   of the week (which will be Monday) then subtract half a day
                   to put us into the Sunday of the correct week.
                 }
                 DocumentDate := StartOfTheWeek(ToDateTime(DueDate)) - 0.5;
                 EffectiveDate   := StartOfTheWeek(ToDateTime(AsAtDate)) - 0.5;
                 Gap := WeeksBetween(DocumentDate, EffectiveDate);
               end;
      abMonths: begin
                  DocumentDate := StartOfTheMonth(ToDateTime(DueDate));
                  EffectiveDate   := StartOfTheMonth(ToDateTime(AsAtDate));
                  Gap := MonthsBetween(DocumentDate, EffectiveDate);
                end;
    end;

    AgeColumn := Floor((Gap) / Interval) + 1;
    if (AgeColumn < 1) then
      AgeColumn := 0
    else if (AgeColumn > 5) then
      AgeColumn := 5;
  end;

  AgedAry[AgeColumn] := AgedAry[AgeColumn] + Amount;

end;


Procedure TCredThread.CredAging_Scan;


Const
  Fnum     =  InvF;


Var
  ExtCustRec  :  ExtCusRecPtr;

  n           :  Byte;

  Keypath     :  Integer;

  LOk,
  NoStop,
  FoundOk,
  Locked      :  Boolean;

  OwnLAged,
  LineAged    :  AgedTyp;

  KeyChk,
  KeyS        :  Str255;


Begin
  With CustAlObj^,MTExLocal^ do
  Begin


    Blank(TotAged,Sizeof(Totaged));
    Blank(CurrAged,Sizeof(Curraged));

    NoStop:=Not Terminated;

    OutTotals;

    {If (LCust.CustCode<>fKeyChk) then
      FoundOk:=LGetMainRec(CustF,fKeyChk)
    else}
      FoundOk:=BOn;

    If (FoundOk) then
    Begin
      New(ExtCustRec);

      Blank(ExtCustRec^,Sizeof(ExtCustRec^));

      With ExtCustRec^ do
      Begin

        FCusCode:=fKeyChk;

        FCr:=0;

        FNomAuto:=BOn;

        FMode:=3;

        FAlCode:=TradeCode[IsACust(LCust.CustSupp)];
        FCSCode:=LCust.CustSupp;

        FDirec:=BOn;

        FB_Func[BOff]:=B_GetPrev;
        FB_Func[BOn]:=B_GetNext;

      end; {With..}

      If (UseOSKey) then
      Begin
        KeyChk:=ExtCustRec^.FAlCode+FullCustCode(fKeyChk);
        Keypath:=InvOSK;
      end
      else
      Begin
        KeyChk:=fKeyChk+LCust.CustSupp;

        Keypath:=InvCustK;

      end;



      KeyS:=KeyChk;

      FoundOk:=BOff;

      LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetGEq,1,KeyS);

      BeingCreated1:=BOff;

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) and (Not Terminated)  do
      With LInv do
      Begin
        NoStop:=Not Terminated;

        FoundOk:=((InvDocHed In SalesSplit+PurchSplit) and (ExtCusFiltCid(-1,ExtCustRec,CustAlObj)) and (BaseTotalOs(LInv)<>0)) ;

        If (FoundOk)  and (NoStop) then
        Begin
          Blank(LineAged,Sizeof(LineAged));
          Blank(OwnLAged,Sizeof(OwnLAged));

          {* Calculate Totals Base Only *}
          // CJS 2011-09-07 Revised calculation of Ageing Column
          // HV - 25-11-2015, Fixed issue for Jira ABSEXCH-12722, Object Creditcontroller is not ageing balances correctly by month in MSSQL only
          DocSupU1.MasterAged(LineAged,Get_StaChkDate(LInv),fAgeAs,BaseTotalOS(LInv),fAgeX,fAgeInt);
          DocSupU1.MasterAged(OwnLAged,Get_StaChkDate(LInv),fAgeAs,CurrencyOS(LInv,BOn,BOff,BOff),fAgeX,fAgeInt);                                
          For n:=0 to 5 do
          Begin
            Case n of
              0,1  :  Begin
                        {TotAged[1]:=TotAged[1]+LineAged[n];}
                        CurrAged[Currency].BaseAged[1]:=CurrAged[Currency].BaseAged[1]+LineAged[n];

                        If (Currency<>0) then
                          CurrAged[0].BaseAged[1]:=CurrAged[0].BaseAged[1]+LineAged[n];

                        CurrAged[Currency].OwnAged[1]:=CurrAged[Currency].OwnAged[1]+OwnLAged[n];

                      end;
              2..5
                   :  Begin
                        {TotAged[n]:=TotAged[n]+LineAged[n];}
                        CurrAged[Currency].BaseAged[n]:=CurrAged[Currency].BaseAged[n]+LineAged[n];

                        If (Currency<>0) then
                          CurrAged[0].BaseAged[n]:=CurrAged[0].BaseAged[n]+LineAged[n];

                        CurrAged[Currency].OwnAged[n]:=CurrAged[Currency].OwnAged[n]+OwnLAged[n];
                      end;

            end; {Case..}


          end;



          OutTotals;
        end;

        LStatus:=GetExtCusALCid(ExtCustRec,CustAlObj,Fnum,Keypath,B_GetNext,3,KeyS);
      end; {While..}


      Dispose(ExtCustRec);

    end; {If Found account Ok}
  end; {With..}

  LastPaid_Scan;

end; {Proc..}


{$IFDEF SOP}
  Procedure TCredThread.SPOP_Scan;


Const
  Fnum     =  InvF;
  Keypath  =  InvCustK;
  Fnum2    =  CustF;
  Keypath2 =  CustInvToK;


Var
  UOR     :  Byte;

  KeyS2,
  KeyChk2,
  KeyChk,
  KeyS    :  Str255;


  AddHOIn,
  RunOnce,
  NoStop  :  Boolean;

  OrdToday,
  NetTot,
  VATTot  :  Real;

  LocalCust
          :  CustRec;


Begin
  UOR:=0;

  Blank(TotAged,Sizeof(Totaged));

  NoStop:=Not Terminated;  RunOnce:=BOn;  AddHOIn:=BOff;

  OutTotals;

  With ExLocal^ do
  Begin
    LocalCust:=LCust;

    BeingCreated2:=BOff;

    If (fUseHO) then
    Begin
      KeyChk2:=fHOAc.CustCode;
      KeyS2:=KeyChk2;

      LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2,ExClientId);


    end;



    While (((LStatusOk) and (CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff))) or RunOnce) and (NoStop) and (Not Terminated) do

    Begin


      KeyChk:=FullCustType(LCust.CustCode,Char(Succ(Ord(LCust.CustSupp))));
      KeyS:=KeyChk;

      LStatus:=Find_RecCId(B_GetGEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) and (Not Terminated) do
      With LInv do
      Begin
        NoStop:=Not Terminated;

        NetTot:=0; VatTot:=0;

        If ((Currency=fCurrency) or (fCurrency=0)) and (NoStop) then
        Begin

          If (fCurrency<>0) then
          Begin
            If (Not (InvDocHed In OrderSet)) then
            Begin
              NetTot:=(ITotal(LInv)-InvVAT);
            end
            else
            If ((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo)) then
            Begin
              NetTot:=TotOrdOS;
            end;
          end
          else
          Begin

            If (Not (InvDocHed In OrderSet)) then
            Begin
              NetTot:=ConvCurrINet(LInv,BOff,BOn);

              {VATTot:=Conv_TCurr(InvVAT,XRate(CXRate,BOff,Currency),Currency,BOff);}
            end
            else
            If ((RunNo=OrdUSRunNo) or (RunNo=OrdUPRunNo)) then
            Begin
              UOR:=fxUseORate(UseCODayRate,BOn,CXRate,UseORate,Currency,0);

              NetTot:=Conv_TCurr(TotOrdOS,XRate(CXRate,UseCoDayRate,Currency),Currency,UOR,BOff);

            end;

          end;

          If (Not (InvDocHed In PSOPSet)) then
          Begin

            NetTot:=NetTot*DocCnst[InvDocHed]*DocNotCnst;

            VATTot:=VATTot*DocCnst[InvDocHed]*DocNotCnst;

          end;


          If (InvDocHed In DeliverSet) then
          Begin
            TotAged[1]:=TotAged[1]+NetTot;
          end
          else
            If (InvDocHed In OrderSet) then
            Begin
              TotAged[2]:=TotAged[2]+NetTot;

            end;

        end; {If Right Currency}

        OutTotals;

        {* Restore position *}

        LStatus:=Find_RecCId(B_GetNext,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);

      end;


      RunOnce:=BOff; {*Force loop to stop after one go*}


      If (fUseHO) and (Not AddHOIn) then
      Begin
        LStatus:=Find_RecCId(B_GetNext,LocalF^[Fnum2],Fnum2,LRecPtr[Fnum2]^,KeyPath2,KeyS2,ExClientId);

        If ((Not LStatusOk) or (Not CheckKey(KeyChk2,KeyS2,Length(KeyChk2),BOff)))
           and (NoStop) and (Not Terminated) then
        Begin
          LCust:=fHOAc;
          LStatus:=0;
          KeyS2:=KeyChk2;
          AddHOIn:=BOn;
        end;

      end
      else
      Begin

        LStatus:=9;
      end;


    end; {HO Loop}

    LCust:=LocalCust;

  end; {With..}


end; {Proc..}



{$ENDIF}


  Procedure TCredThread.LastPaid_Scan;


  Const
    Fnum     =  InvF;
    Keypath  =  InvCDueK;

  Var
    NoStop,
    FoundOk     :  Boolean;

    KeyChk,
    KeyS        :  Str255;


  Begin
    With ExLocal^ do
    Begin


      NoStop:=Not Terminated;

      KeyChk:=LCust.CustSupp+FullCustCode(fKeyChk);

      KeyS:=KeyChk+NdxWeight;

      FoundOk:=BOff;

      LStatus:=Find_RecCId(B_GetLessEq,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);

      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (NoStop) and (Not Terminated) and (Not FoundOk) do
      With LInv do
      Begin
        NoStop:=Not Terminated;

        FoundOk:=(InvDocHed In RecieptSet);

        If (Not FoundOk) then
          LStatus:=Find_RecCId(B_GetPrev,LocalF^[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,KeyS,ExClientId);

      end; {While..}

      If (NoStop) and (Assigned(ShowLPDate)) then
      Begin
        If (FoundOk) then
          ShowLPDate.DateValue:=LInv.TransDate
        else
          ShowLPDate.DateValue:='';
      end;
    end; {With..}
  end; {Proc..}




{ ======================================================================================= }






procedure TCredPopUp.SetCaption;

Begin
  With ExLocal,LCust do
  Begin
    Caption:='ObjectCredit for '+dbFormatName(CustCode,Company);

    {$IFDEF SOP}
      If (fUseHO) and (fHOAc.CustCode<>CustCode) then
        CapTion:=Caption+'. (via '+Trim(fHOAc.CustCode)+', H/O A/C';

    {$ENDIF}

    {$IFDEF MC_On}
      Caption:=Caption+'. ('+Ssymb(Currency)+')';

    {$ENDIF}
  end;

end;


procedure TCredPopUp.Set_Currency;

Begin
  If (CurrF.ItemIndex>=0) then
    fCurrency:=CurrF.ItemIndex;

  If (CurrF2.ItemIndex>=0) then
    fTxlate:=CurrF2.ItemIndex;

  //GS 20/03/2012 ABSEXCH-9584: pass preserved currency setting into var
  If (CurrF3.ItemIndex>=0) then
    fCreditTxlate:=CurrF3.ItemIndex;

end;

procedure TCredPopUp.FormCreate(Sender: TObject);
begin

  ExLocal.Create;

  ClientHeight:=293-SOPPanel.Height;
  ClientWidth:=441;

  MDI_SetFormCoord(TForm(Self));

  Left := Application.MainForm.ClientWidth - (Width + GetSystemMetrics(SM_CXHTHUMB) + 4);

  ShowTotals:=nil;
  
  //GS 20/03/2012 ABSEXCH-9584: initialise target credit currency 
  fCreditTxlate := 0;
  fCurrency:=0;
  fTxLate:=0;

  {$IFDEF SOP}
    ShowOrders:=nil;
    fUseHO:=BOff;
  {$ENDIF}

    {$IFDEF MC_On}

    Set_DefaultCurr(CurrF.Items,BOn,BOff);
    Set_DefaultCurr(CurrF.ItemsL,BOn,BOn);
    CurrF.ItemIndex:=0;

    Set_DefaultCurr(CurrF2.Items,BOn,BOff);
    Set_DefaultCurr(CurrF2.ItemsL,BOn,BOn);
    CurrF2.ItemIndex:=0;

    //GS 31/01/2012 ABSEXCH-9584: populate the currency combo box
    Set_DefaultCurr(CurrF3.Items,BOn,BOff);
    Set_DefaultCurr(CurrF3.ItemsL,BOn,BOn);
    CurrF3.ItemIndex:=0;

  {$ELSE}
    Label81.Visible:=BOff;
    CurrF.Visible:=BOff;
    CurrF2.Visible:=BOff;
    Label811.Visible:=BOff;


  {$ENDIF}

  DispCust:=nil;

  InReset:=BOn;
  ComBtnClicked:=BOff;

  fAgeX:=3;
  fAgeInt:=1;
  fAgeAs:=ETDateU.Today;
  fFreeze:=BOff;

  LastLedgMode:=0;

  CrLimF.Value:=0.0;
  BalF.Value:=0.0;
  CommitF.Value:=0.0;
  AvailF.Value:=0.0;
  SORF.Value:=0.0;
  SDNF.Value:=0.0;
  Age1.Value:=0.0;
  Age2.Value:=0.0;
  Age3.Value:=0.0;
  Age4.Value:=0.0;
  Age5.Value:=0.0;

  AgeByF.ItemIndex:=Pred(fAgeX);
  AgeIntF.Value:=fAgeInt;
  AgeAtF.DateValue:=fAgeAs;


  {$IF Not Defined(SOP) or Defined(LTE)}
    CommitBttn.Visible:=BOff;
    CommitF.Visible:=BOff;
    CredAvailLab.Left:=CommitBttn.Left;
    AvailF.Left:=CommitF.Left;
    HOComf.Visible:=BOff;
    CommitBttn.Width:=100;
  {$IFEND}

  AgeByFChange(nil);

  InReset:=BOff;

  SetAgeCaption;

  LastValueObj.GetAllLastValuesFull(Self);

  {$IFDEF MC_On}
    Set_Currency;

  {$ENDIF}

  Label84.Visible:=BOn;
  LastPaidF.Visible:=BOn;
  
  UseOSNdx:=UseV5OsNdx;
end;

procedure TCredPopUp.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  If (CanClose) then
    Send_UpdateList(BOff,75);

end;

procedure TCredPopUp.FormClose(Sender: TObject; var Action: TCloseAction);
begin

  {$B-}
  If ((Not Assigned(ShowTotals)) or (Not ShowTotals.InThreadSynch)) {$IFDEF SOP} and  ((Not Assigned(ShowOrders)) or (Not ShowOrders.InThreadSynch)) {$ENDIF} then
  {$B+}
  Begin
    Action:=caFree;

    If Assigned(ShowTotals) then
    With ShowTotals do
    Begin
      try
        Terminate;
        WaitForTerminate;

        If (Not ExecuteOff) then
          Suspend;
        CleanUp;
        Free;
      except;
        ShowTotals.CleanUp;
        ShowTotals.Free;
      end;
    end;

    {$IFDEF SOP}
      If Assigned(ShowOrders) then
      With ShowOrders do
      Begin
        try
          Terminate;
          WaitForTerminate;

          If (Not ExecuteOff) then
            Suspend;

          CleanUp;
          Free;
        except;
          ShowOrders.CleanUp;
          ShowOrders.Free;
        end;
      end;
    {$ENDIF}
  end
  else
  Begin
    Set_BackThreadMVisible(BOn);

    ShowMessage('This Window can not be closed until the main ObjectThread Controller has finished.');

    Set_BackThreadMVisible(BOff);
  end;
end;

procedure TCredPopUp.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;

end;

procedure TCredPopUp.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TCredPopUp.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;


Procedure TCredPopUp.WMCustGetRec(Var Message  :  TMessage);



Begin


  With Message do
  Begin

    {If (Debug) then
      DebugForm.Add('Mesage Flg'+IntToStr(WParam));}

    Case WParam of
      01  :  CurrFChange(nil);

      18  :  Begin
               DispCust:=nil;
             end;

    end; {Case..}

  end;
  Inherited;
end;



{ == Procedure to Send Message to Get Record == }

Procedure TCredPopUp.Send_UpdateList(Edit   :  Boolean;
                                     Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_FormCloseMsg;
    WParam:=Mode;
    LParam:=Ord(Edit);
  end;

  With Message1 do
    MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);

end; {Proc..}


{ ============== Display Credit Control Record ============ }

Procedure TCredPopUp.OutCred;

Var
  CrDr       :   DrCrDType;

  BalYTD     :   Byte;
  HistCode   :   Char;

  ThisYTD,
  Cleared,
  Commit     :   Double;

  {$IFDEF SOP}
    LocalCust  :   CustRec;
  {$ENDIF}


Begin

  Blank(CrDr,Sizeof(CrDr));

  Cleared:=0;

  Commit:=0;  ThisYTD:=0;

  With ExLocal,LCust do
  Begin

    AcCF.Text:=Strip('B',[#32],CustCode);

    CompF.Text:=Strip('R',[#32],Company);

    {$IFDEF SOP}
      LocalCust:=LCust;

      If (fUseHO) and (fHOAc.CustCode<>CustCode) then
      Begin
        
        LCust:=fHOAc;
      end;

    {$ENDIF}


    CrLimF.Value:=CreditLimit;

    {CredStatF.Value:=CreditStatus;}

    With Syss do
    Begin
      If (IsACust(CustSupp)) then
      Begin
        BalYTD:=YTDNCF;
        HistCode:=CustHistGPCde;
      end
      else
      Begin
        BalYTD:=YTD;
        HistCode:=CustHistCde;
      end;

      Balance:=Profit_to_Date(CustHistCde,CustCode,0,CYr,99,CrDr[BOff],CrDr[BOn],Commit,BOn);

      ThisYTD:=CrDr[Not IsACust(CustSupp)];

      Balance:=Profit_to_Date(CustHistCde,CustCode,0,200,99,CrDr[BOff],CrDr[BOn],Commit,BOn);

    end;

    BalF.Value:=Balance*TradeConst[IsaCust(CustSupp)];


    {$IFDEF SOP}
      If (SWBentlyOn) then
      Begin
        Commit:=SDNF.Value;

      end;
    {$ENDIF}

    CommitF.Value:=(Commit*TradeConst[IsACust(CustSupp)]);

    // MH 01/07/2009: Modified calculation to sign amounts as it previously only worked for customers
    //AvailF.Value:=(CreditLimit-(Balance+Commit));
    AvailF.Value := CreditLimit - (Balance*TradeConst[IsACust(CustSupp)]) - (Commit*TradeConst[IsACust(CustSupp)]);

    DDaysF.Value:=(DivWChk(Balance,ThisYTD)*365);

    CredSF.Value:=CreditStatus;

    {$IFDEF SOP}
      LCust:=LocalCust;

    {$ENDIF}

  end; {with..}



end; {Proc..}


procedure TCredPopUp.OkCP1BtnClick(Sender: TObject);
begin
  // If the Credit thread is currently recalculating values, we can't close the
  // form yet (the user has to wait until the recalculation is finished, then
  // click the OK button again).
  {$B-}
  If ((not Assigned(ShowTotals)) or (not ShowTotals.InThreadSynch)) Then
  {$B+}
  begin
    LastValueObj.UpdateAllLastValues(Self);
    Close;
  end;
end;

procedure TCredPopUp.AccFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  Inherited;

  If (Sender is Text8pt) then
  With (Sender as Text8pt) do
  Begin
    AltMod:=Modified;

    FoundCode:=Strip('B',[#32],Text);

    If ((AltMod) or (FoundCode='')) and (ActiveControl<>OKCP1Btn)  then
    Begin
      Freeze:=BOff;

      StillEdit:=BOn;

      FoundOk:=(GetCust(Self,FoundCode,FoundCode,BOn,99));


      If (FoundOk) then
      Begin

        StillEdit:=BOff;

        Text:=FoundCode;

        ExLocal.AssignFromGlobal(CustF);
        
        SetUpAccount(FoundCode);
      end
      else
      Begin

        SetFocus;
      end; {If not found..}
    end;

  end; {with..}
end;


procedure TCredPopUp.SDNFChange(Sender: TObject);
begin
  {$IFDEF SOP}
    If (SWBentlyOn) then
      OutCred;
  {$ENDIF}
end;


{$IFDEF SOP}
  procedure TCredPopUp.ShowCommitHO;

  Begin
    If (fUseHO) and (fHOAc.CustCode<>ExLocal.LCust.CustCode) and (SOPPanel.Visible) then
    Begin
      HOComF.Visible:=BOn;
      CommitBttn.Width:=60;
    end
    else
    Begin
      HOComF.Visible:=BOff;
      CommitBttn.Width:=100;
    end;


  end;
{$ENDIF}


procedure TCredPopUp.SetUpAccount(CustR  :  Str10);

{$IFDEF SOP}
  Var
    LocalCust  :  CustRec;

{$ENDIF}

Begin
  { Stop any threads here }

  If (ExLocal.LCust.CustCode<>CustR) then
    ExLocal.LGetMainRecPos(CustF,CustR);

  {$IFDEF SOP}
    With ExLocal,LCust do
    Begin
      LocalCust:=LCust;
      Blank(fHOAc,Sizeof(fHOAc));
      fUseHO:=BOff;



      If (SOPConsHO=1) or (Not EmptyKey(SOPInvCode,CustKeyLen)) then
      Begin
        If (Not EmptyKey(SOPInvCode,CustKeyLen)) then
        Begin
          fUseHO:=ExLocal.LGetMainRecPos(CustF,SOPInvCode);


        end
        else
          fUseHO:=(SOPConsHO=1);

        HOComF.Checked:=fUseHO;

        fHOAc:=LCust;

      end;

      LCust:=LocalCust;

      ShowCommitHO;

    end;
  {$ENDIF}

  {ExLocal.LCust:=CustR;}

  SetCaption;

  OutCred;

  If (Not InReset) then
    ResetTotals;

  {$IFDEF SOP}
    If ((SOPPanel.Visible) or (SWBentlyOn)) and (Not InReset) then
      ResetOrdTotals(BOn);
  {$ENDIF}

  If (Assigned(DispCust)) then
    Link2Ledger(LastLedgMode);
end;

procedure TCredPopUp.CommitBttnClick(Sender: TObject);
begin
  If (Not ComBtnClicked) then
  Begin
    ComBtnClicked:=BOn;

    SOPPanel.Visible:=Not SOPPanel.Visible;

    If (SOPPanel.Visible) then
      ClientHeight:=ClientHeight+SOPPanel.Height
    else
      ClientHeight:=ClientHeight-SOPPanel.Height;

    {$IFDEF SOP}
      ShowCommitHO;
      ResetOrdTotals(SOPPanel.Visible);
    {$ENDIF}

    ComBtnClicked:=BOff;

  end;

end;

procedure TCredPopUp.SetAgeCaption;
Var
  n          :  Byte;
  AgeTit     :  Array[1..5] of Str20;
  IntStr     :  Str20;

begin
  AgeTit[1]:='Current';

  For n:=2 to 5 do
  Begin
    AgeTit[n]:='';

    AgeTit[n]:=Form_Int((fAgeInt*Pred(n)),0)+' '+AgedHed[fAgeX];

    If ((Pred(n)*fAgeInt)>1) then
      AgeTit[n]:=AgeTit[n]+'s';

    If (n=5) then
      AgeTit[n]:=AgeTit[n]+'+';

  end;

  Age1Lab.Caption:=AgeTit[1];
  Age2Lab.Caption:=AgeTit[2];
  Age3Lab.Caption:=AgeTit[3];
  Age4Lab.Caption:=AgeTit[4];
  Age5Lab.Caption:=AgeTit[5];

  With AgeByF do
  If (ItemIndex>=0) then
  Begin
    IntStr:=Items[ItemIndex];

    If (AgeIntF.Value>1) then
      IntText.Caption:=IntStr
    else
      IntText.Caption:=Copy(IntStr,1,Pred(Length(IntStr)));
  end;

end;

procedure TCredPopUp.AgeByFChange(Sender: TObject);


begin
  Freeze:=BOff;

  If (ActiveControl <> OkCP1Btn) and (Not InReset) then
  Begin
    fAgeInt:=Round(AgeIntF.Value);
    fAgeX:=Succ(AgeByF.ItemIndex);
    fAgeAs:=AgeAtF.DateValue;

    SetAgeCaption;

    ResetTotals;
  end;

end;

procedure TCredPopUp.CurrFChange(Sender: TObject);
begin
  {$IFDEF MC_On}

     If (Assigned(Sender)) then
       PostMessage(Self.Handle,WM_CustGetRec,1,0)
     else if (ActiveControl <> OkCP1Btn) then
     Begin

       Freeze:=BOff;

       If (Not InReset) then
       Begin
         Set_Currency;


         If (Assigned(ShowTotals)) then
         With ShowTotals do
         Begin
           fCurrency:=Self.fCurrency;
           fTxLate:=Self.fTxlate;
           //GS 20/03/2012 ABSEXCH-9584: pass the target credit currency
           //to the ShowTotals object
           CreditTranslate := self.fCreditTxlate;

           OutTotals;
         end;
       end;
     end;
  {$ENDIF}
end;


Function TCredPopUp.Check_MainThread  :  Boolean;

Begin
  {$B-}
    {v5.70 If the OCC thread was called whilst the main thread OTC is working, the call to OutTotals which uses a Synchronise call
     Gets queued up until the Main OTC finishes, thus causing Ent to hang if you tried to close the OCC, since technically it
     is still inside the thread.  A check is made to ensure its nt still waiting for the Synchornise to return before allowing
     closure.
     An alternative was this check which stoped the OCC thread from being called whilst the OTC was detected as busy, but this
     is not as user friendly. May need to revert to it if the other check is not good enough }
    {Result:=(Not Assigned(BackThread)) or (BackThread.IdleMode);}

    Result:=BOn;
  {$B+}
end;



procedure TCredPopUp.CalcTotals;


Begin

  With ExLocal do
  If (ShowTotals=nil) and (LCust.CustCode<>'') and Check_MainThread then
  
  //GS 20/03/2012 ABSEXCH-9584: utilise the overloaded create method so that
  //the credit fields are translated accordingly
  {$IFDEF SOP}
    ShowTotals:=TCredThread.Create(LCust,fHOAc,fAgeX,0,fCurrency,fTxlate,fAgeInt,fAgeAs,fUSeHO,UseOSNdx,Age1,Age2,Age3,Age4,Age5,LastPaidF,BOn, CRLimF, BalF, CommitF, AvailF,  fCreditTxlate);

  {$ELSE}
    ShowTotals:=TCredThread.Create(LCust,LCust,fAgeX,0,fCurrency,fTxlate,fAgeInt,fAgeAs,BOff,UseOSNdx,Age1,Age2,Age3,Age4,Age5,LastPaidF,BOn,CRLimF, BalF, CommitF, AvailF,  fCreditTxlate);

  {$ENDIF}





end;


procedure TCredPopUp.HOComFClick(Sender: TObject);
begin
  {$IFDEF SOP}
    Freeze:=BOff;

    If (Not InReset) then
    Begin
      fUseHO:=Not fUseHO;

      SetCaption;

      OutCred;

      ResetOrdTotals(SOPPanel.Visible);
    end;
  {$ENDIF}

end;


procedure TCredPopUp.HOComFMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  HOComFClick(Sender);
end;


procedure TCredPopUp.ResetTotals;

Var
  n  :  Integer;

Begin
  InReset:=BOn;

  If (ShowTotals<>nil) and Check_MainThread then
  With ShowTotals do
  Begin
    If (Not BeingCreated1) then
    Begin

      Terminate;

      If (WaitForTerminate) then
      Begin
        If (Not ShowTotals.ExecuteOff) then
          ShowTotals.Suspend;

        ShowTotals.CleanUp;
        ShowTotals.Free;
        ShowTotals:=nil;
        CalcTotals;
      end
      else
        If (Debug) then
          ShowMessage('Aging Thread Not aborted correctly in ObjectCC')
        else
          MessageBeep(0);
    end; {We have not really started yet, so cannot terminate}
  end
  else
    CalcTotals;

  InReset:=BOff;

end;


{$IFDEF SOP}
  procedure TCredPopUp.CalcOrdTotals;
  Begin

    With ExLocal do
    If (ShowOrders=nil) and (LCust.CustCode<>'') then
      ShowOrders:=TCredThread.Create(LCust,fHOAc,fAgeX,fAgeInt,0,fCurrency,fTxlate,fAgeAs,fUseHO,BOff,SDNF,SORF,nil,nil,nil,nil, BOff);
      
  end;



  procedure TCredPopUp.ResetOrdTotals(ReStart  :  Boolean);

  Var
    n  :  Integer;

  Begin
    InReset:=BOn;

    If (ShowOrders<>nil) then
    With ShowOrders do
    Begin
      If (Not BeingCreated2) then
      Begin
        Terminate;

        If (WaitForTerminate) then
        Begin
          If (Not ShowOrders.ExecuteOff) then
            ShowOrders.Suspend;

          ShowOrders.CleanUp;
          ShowOrders.Free;
          ShowOrders:=nil;

          If (ReStart) then
            CalcOrdTotals;
        end
        else
          If (Debug) then
            ShowMessage('SPOP Thread Not aborted correctly in ObjectCC')
          else
            MessageBeep(0);
      end;
    end
    else
      CalcOrdTotals;

    InReset:=BOff;

  end;

{$ENDIF}


procedure TCredPopUp.AccFDblClick(Sender: TObject);
begin
  {If (Not EmptyKey(AccF.Text,CustKeyLen)) and (ExLocal.LCust.CustCode=AccF.Text) then
    Link2Ledger(-9);}
end;

procedure TCredPopUp.CompFDblClick(Sender: TObject);
begin
  AccF.DblClick;
end;


procedure TCredPopUp.Link2Ledger(MOfset  :  SmallInt);


Begin

  If (DispCust=nil) then
    DispCust:=TFCustDisplay.Create(Self);

  try

    ExLocal.AssignToGlobal(CustF);

    With DispCust do
      Display_Account(IsACust(ExLocal.LCust.CustSupp),10+MOfSet,ExLocal.LInv);

  except

    DispCust.Free;

  end;

  LastLedgMode:=MOfSet
end;

procedure TCredPopUp.Age1DblClick(Sender: TObject);
begin
  Link2Ledger(13);
end;

procedure TCredPopUp.SetFreeze(F  :  Boolean);

Begin
  If (F<>fFreeze) then
  Begin
    fFreeze:=F;

    If F then
      FrzeBtn.Caption:='Un&freeze'
    else
      FrzeBtn.Caption:='&Freeze';
  end;
end;
procedure TCredPopUp.FrzeBtnClick(Sender: TObject);
begin
  Freeze:=Not Freeze;
end;

procedure TCredPopUp.SORFDblClick(Sender: TObject);
begin
  Link2Ledger(1+(2*Ord(Sender=SDNF)));
end;

//GS 20/03/2012 ABSEXCH-9584: overloaded constructor to handle credit field currency translation
constructor TCredThread.Create(CustR, HOCust: CustRec; AgeX, TMode, RCurr,
  RTxLate: Byte; AgeInt: Integer; AgeAs: LongDate; UseHO, UseOSK: Boolean;
  TC1, TC2, TC3, TC4, TC5: TCurrencyEdit; TED1: TEditDate;
  ShowCurrSym: Boolean; CreditField1, CreditField2, CreditField3,
  CreditField4: TCurrencyEdit; CreditTranslate: Byte);
var
  n: integer;
begin
  //store credit field handles
  CreditDisplay[1] := CreditField1;
  CreditDisplay[2] := CreditField2;
  CreditDisplay[3] := CreditField3;
  CreditDisplay[4] := CreditField4;

  //store the origional (base currency) field vals
  For n := low(CreditDisplay) to high(Creditdisplay) do
  begin
    CreditVal[n] := creditDisplay[n].Value;
  end;//end for

  //store target translation currency
  self.CreditTranslate := CreditTranslate;

  //call origional constructor
  self.Create(CustR, HOCust, AgeX, TMode, RCurr, RTxLate, AgeInt, AgeAs, UseHO, UseOSK, TC1, TC2, TC3, TC4, TC5,
  TED1, SHowCurrSym);
end;

end.
