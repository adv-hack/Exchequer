unit oJobInv;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oBtrieve, GlobVar, VarConst, VarCnst3, MiscFunc,
     BtrvU2, ExBTTH1U, oNotes, oLinks, oJobAct, oJobRet, oJobBud, oToolkit,
     Varrec2u, GlobList, CacheStat, ExceptIntf;

type
  JobInvRec = Record
    JobCode  : String[10];
    CustCode : string[6];
    InvCurr  : integer;
    Detail   : Byte;
    RevenueAnal : string[10];
    InvType  : Byte;
    TransferWIP : WordBool;
    WIPAnalysis : string[10];
    EndDoc : string[10];
    EndTransfer : string[10];
    CCDep : CCDepType;
    UseCCAndDep : WordBool;
  end;

  TDetails = Class
    bTagged : WordBool;
    dCost,
    dQty,
    dCharge : Double;
  end;

  TJobInvoice = Class; //redeclared below

  TJobInvoiceTransactionList = Class(TAutoIntfObjectEx, IJobInvoiceTransactionList)
  private
    FJobInvoice : TJobInvoice;
    FList : TList;
  protected
    function Get_jiTransactionCount: Integer; safecall;
    function Get_jiTransaction(Index: Integer): IJobInvoiceTransaction; safecall;
  public
    constructor Create(JobInv : TJobInvoice);
    destructor Destroy; override;
  end;


  TJobInvoiceTransaction = Class(TAutoIntfObjectEx, IJobInvoiceTransaction, IJobInvoiceTransaction2,
                                   IJobInvoiceTransaction3)
  private
    FJobInvoice : TJobInvoice;
    FIndex : Integer;
  protected
    function Get_jiOurRef: WideString; safecall;
    function Get_jiOurRefI: ITransaction; safecall;
    function Get_jiTagged: WordBool; safecall;
    procedure Set_jiTagged(Value: WordBool); safecall;
    function Get_jiCharge : Double; safecall;
    procedure Set_jiCharge(Value: Double); safecall;
    function Get_jiCost: Double; safecall;
    function Get_jiQty: Double; safecall;
  public
    constructor Create(JobInv : TJobInvoice; Index : integer);
  end;


  TJobInvoice = Class(TAutoIntfObjectEx, IJobInvoice, ICacheStatus)
  private
    FRec : JobInvRec;
    FList : TStringList;
    FBtrIntf : TCtkTdPostExLocalPtr;
    FToolkit : TToolkit;
    FTransactionListO : TJobInvoiceTransactionList;
    FTransactionListI : IJobInvoiceTransactionList;
    FFilesUsed : Set of Byte;
    function TransOurRef(const s : string) : string;
    function TransLineNo(const s : string) : longint;
    function JActKey(const s : string) : string;
    function GetTransactionClone(const OurRef : string) : ITransaction;
    procedure LoadList;
    function IncludeThisRec : Boolean;
    Procedure LGen_InvHed(CCode  :  Str30;
                               RNo    :  LongInt;
                               TDate,
                               DDate  :  Str8;
                               RCr    :  Byte;
                               JCode,
                               ACode,
                               RDoc   :  Str10;
                           Var Ignore :  Boolean;
                               Mode   :  Byte);
    function Gen_JobInv(Const  Mode,
                                     ICurr,
                                     DetLev  :  Byte;
                              Const  ICCDep  :  CCDepType;
                              Const  IJACode :  Str10;
                              Const  Fnum,
                                     Keypath :  Integer;
                              Var    NeedHed :  Boolean;
                                     GenWIP,
                                     UseOrigCCDep
                                             :  Boolean;
                              Const  KeyChk  :  Str255;
                              Const  TTEnabled
                                             :  Boolean) : SmallInt;
    function LUpdate_JobAct(Idr    :  IDetail;
                                    InvR   :  InvRec) : SmallInt;
    Function LGetJobMisc(ACode  :  Str10;
                         GMode  :  Byte)  :  Boolean;
    Function FullIANKey(JC,AC    :  Str10;
                        FullKey  :  Boolean)  :  Str255;
    Procedure Update_IAN(JC,AC    :  Str10;
                         Value1,
                         Value2   :  Double);
    Function IS_IAN(JC,AC  :  Str10) :  Boolean;
    Procedure LStore_InvHed(Mode        :  Byte;
                            RKeypath    :  Integer;
                      Const TTEnabled   :  Boolean);
    Procedure Gen_CloseJobNom(Const JCode,
                                    ACode    :  Str10;
                              Const StageOn,
                                    WIPOnly  :  Boolean;
                              Const Fnum,
                                    Keypath  :  Integer;
                              Const TTEnabled:  Boolean);
    Procedure LAdd_StockValue(BSNCode,
                               PLNCode:  LongInt;
                               STKValue
                                      :  Real;
                               JCode,
                               ACode,
                               ECode,
                               OCode  :  Str10;
                               AsDIR  :  Boolean;
                               ACr,
                               AMode  :  Byte;
                               ACCDep :  CCDepType;
                               RevRate:  CurrTypes;
                          Var  Abort  :  Boolean);
   Function CCDepMatch(LinkCCDep :  Boolean;
                       RCCDep    :  CCDepType)  :  Boolean;
   Procedure LCreate_JNomTxfrLines(Var   Idr  :  IDetail;
                                         Const LCr  :  Byte;
                                         Const ADIR :  Boolean);
   procedure SetActualValue(Index, WhichVal : Integer;
                            BoolValue : WordBool;
                           FloatValue : Double);
  protected
    function Get_jiJobCode: WideString; safecall;
    function Get_jiAccCode: WideString; safecall;
    function Get_jiInvoiceCurrency: Integer; safecall;
    procedure Set_jiInvoiceCurrency(Value: Integer); safecall;
    function Get_jiDetail: TJobInvoiceDetailType; safecall;
    procedure Set_jiDetail(Value: TJobInvoiceDetailType); safecall;
    function Get_jiInvoiceType: TJobInvoiceType; safecall;
    procedure Set_jiInvoiceType(Value: TJobInvoiceType); safecall;
    function Get_jiTransferWIP: WordBool; safecall;
    procedure Set_jiTransferWIP(Value: WordBool); safecall;
    function Get_jiWIPAnalysis: WideString; safecall;
    procedure Set_jiWIPAnalysis(const Value: WideString); safecall;
    function Get_jiRevenueAnalysis: WideString; safecall;
    procedure Set_jiRevenueAnalysis(const Value: WideString); safecall;
    function Get_jiInvoice: WideString; safecall;
    function Get_jiInvoiceI: ITransaction; safecall;
    function Get_jiCostCentre: WideString; safecall;
    procedure Set_jiCostCentre(const Value: WideString); safecall;
    function Get_jiDepartment: WideString; safecall;
    procedure Set_jiDepartment(const Value: WideString); safecall;
    function Get_jiUseCCAndDept: WordBool; safecall;
    procedure Set_jiUseCCAndDept(Value: WordBool); safecall;
    function Get_jiTransactionList: IJobInvoiceTransactionList; safecall;
    function Get_jiWIPTransfer: WideString; safecall;
    function Get_jiWIPTransferI: ITransaction; safecall;
    function Execute: Integer; safecall;
    //ICacheStatus
    procedure SetFileChanged(FileNo, ClientID : Integer);
  public
    function Get_jiTransactionCount: Integer; safecall;
    function Get_jiTransactions(Index: Integer): WideString; safecall;
    function Get_jiTransactionsI(Index: Integer): ITransaction; safecall;
    function Get_jiTagged(Index: Integer): WordBool; safecall;
    procedure Set_jiTagged(Index: Integer; Value: WordBool); safecall;
    function Get_jiCharge(Index: Integer): Double; safecall;
    function Get_jiCost(Index: Integer): Double; safecall;
    function Get_jiQty(Index: Integer): Double; safecall;
    procedure Set_jiCharge(Index: Integer; Value: Double); safecall;
    Constructor Create(const JCode    : string;
                       const AcCode   : string;
                             Toolkit  : TToolkit);
    destructor Destroy; override;
  end;

implementation

uses
  ComServ, BtKeys1U, BtSupU1, VarJcstU, EtDateU, SysU1, EtMiscU, CurrncyU, SysU3, MiscU, EtStrU,
  Dllth_Up, ComnU2, Revalu2u, oTrans, DllErrU,

  //PR: 02/11/2011 v6.9
  AuditNotes,
  AuditNoteIntf,

  //PR: 02/03/2015  ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU;


Function FullJDAnalKey(JC   :   Str10;
                       JA   :   Str10)  :  Str20;


Begin

  FullJDAnalKey:=FullJobCode(JC)+FullJACode(JA);

end;


Constructor TJobInvoice.Create(const JCode    : string;
                               const AcCode   : string;
                                     Toolkit  : TToolkit);
var
  si : SmallInt;
begin
  inherited Create(ComServer.TypeLib, IJobInvoice);



  FList := TStringList.Create;
  FTransactionListO := TJobInvoiceTransactionList.Create(Self);
  FTransactionListI := FTransactionListO;

  FRec.JobCode := JCode;
  FRec.CustCode := AcCode;

  New(FBtrIntf, Create(34));

  FBtrIntf^.Open_System(InvF, InvF);
  FBtrIntf^.Open_System(IDetailF, IDetailF);
  FBtrIntf^.Open_System(JDetlF, JDetlF);
  FBtrIntf^.Open_System(JobF, JobF);
  FBtrIntf^.Open_System(MiscF, MiscF);
  FBtrIntf^.Open_System(JMiscF, JMiscF);
  FBtrIntf^.Open_System(CustF, CustF);
  FBtrIntf^.Open_System(IncF, IncF);
  FBtrIntf^.Open_System(NHistF, NHistF);

  FToolkit := Toolkit;

  si := FToolkit.EnterpriseI.enCurrencyVersion;
  if si in [1, 2] then
    FRec.InvCurr := 1
  else
    FRec.InvCurr := 0;

  LoadList;

  if SQLBeingUsed then
  begin
    FFilesUsed := [InvF, IDetailF, JDetlF, JobF, MiscF, CustF, IncF, NHistF];
    CacheStatusList.Add(Self as ICacheStatus);
  end;

end;

destructor TJobInvoice.Destroy;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
    TDetails(FList.Objects[i]).Free;
  FList.Free;
  FTransactionListI := nil;
  Dispose(FBtrIntf, Destroy);
  inherited Destroy;
end;


function TJobInvoice.Get_jiJobCode: WideString;
begin
  Result := FRec.JobCode;
end;

function TJobInvoice.Get_jiAccCode: WideString;
begin
  Result := FRec.CustCode
end;

function TJobInvoice.Get_jiInvoiceCurrency: Integer;
begin
  Result := FRec.InvCurr;
end;

procedure TJobInvoice.Set_jiInvoiceCurrency(Value: Integer);
begin
  FRec.InvCurr := Value;
end;

function TJobInvoice.Get_jiDetail: TJobInvoiceDetailType;
begin
  Result := TJobInvoiceDetailType(FRec.Detail);
end;

procedure TJobInvoice.Set_jiDetail(Value: TJobInvoiceDetailType);
begin
  if (Value <= jidFullDetail) then
    FRec.Detail := Ord(Value)
  else
    raise ERangeError.Create('Invalid Job Invoice Detail Type (' + IntToStr(Value) + ')');
end;

function TJobInvoice.Get_jiInvoiceType: TJobInvoiceType;
begin
  Result := TJobInvoiceType(FRec.InvType);
end;

procedure TJobInvoice.Set_jiInvoiceType(Value: TJobInvoiceType);
begin
  if (Value <= jitWIPOnly) then
    FRec.InvType := Ord(Value)
  else
    raise ERangeError.Create('Invalid Job Invoice Type (' + IntToStr(Value) + ')');
end;

function TJobInvoice.Get_jiTransferWIP: WordBool;
begin
  Result := FRec.TransferWIP;
end;

procedure TJobInvoice.Set_jiTransferWIP(Value: WordBool);
begin
  FRec.TransferWIP := Value;
end;

function TJobInvoice.Get_jiWIPAnalysis: WideString;
begin
  Result := FRec.WIPAnalysis;
end;

procedure TJobInvoice.Set_jiWIPAnalysis(const Value: WideString);
begin
  FRec.WIPAnalysis := LJVar(UpperCase(Value), AnalKeyLen);
end;

function TJobInvoice.Get_jiRevenueAnalysis: WideString;
begin
  Result := FRec.RevenueAnal;
end;

procedure TJobInvoice.Set_jiRevenueAnalysis(const Value: WideString);
begin
  FRec.RevenueAnal := LJVar(UpperCase(Value), AnalKeyLen);
end;


function TJobInvoice.Execute: Integer;
var
  FinalInv : Boolean;
  TTEnabled : Boolean;
  WantHed : Boolean;
  TmpBo : Boolean;
begin
  Result := 0;

  if FRec.InvType = jitWIPOnly then
      FRec.TransferWIP := True;

  if (FRec.InvType <> 2) and ((FRec.RevenueAnal = '') or not (CheckRecExsists(FullJAKey(JARCode, JAACode, FRec.RevenueAnal),JMiscF, 0))) then
    Result := 30000;

  if (Result = 0) and WordBoolToBool(FRec.TransferWIP) then
    if (FRec.WIPAnalysis = '') or not (CheckRecExsists(FullJAKey(JARCode, JAACode, FRec.WIPAnalysis),JMiscF, 0)) then
      Result := 30001;

  if (Result = 0) and Syss.UseCCDep then
  begin
    For TmpBo := False to True do
    begin
      if (FRec.CCDep[TmpBo] = '') or not CheckRecExsists(CostCCode+CSubCode[TmpBo]+FRec.CCDep[TmpBo], PwrdF, PWK) then
      begin
        if TmpBo then
          Result := 30002
        else
          Result := 30003;
      end;
    end;
  end;

  if Result = 0 then
  begin
    WantHed := True;
    TTEnabled := False;//???
    FinalInv := FRec.InvType = 1;
    if FRec.TransferWIP then
    begin
      Try
        Gen_CloseJobNom(FRec.JobCode,FRec.WIPAnalysis, not FinalInv,FRec.InvType = 2,JdetlF,JDLedgerK,TTEnabled);

        FRec.EndTransfer := FBtrIntf^.LInv.OurRef;
      Except
        Result := 30004;
      End;
    end;

    if FRec.InvType <> 2 then
    begin
      Try
        Gen_JobInv(1+Ord(FinalInv),
                   FRec.InvCurr,FRec.Detail,
                   FRec.CCDep,
                   FRec.RevenueAnal,
                   JDetlF,JDLedgerK,
                   WantHed,
                   FRec.TransferWIP,
                   FRec.UseCCAndDep,
                   PartCCKey(JBRCode,JBECode)+FRec.JobCode+#1,
                   TTEnabled);

        //PR: 02/11/2011 v6.9 Add audit not to parent job record - FBtrIntf^.LJobRec has been populated with
        //the correct job record during Gen_JobInv
        if Result = 0 then
          AuditNote.AddNote(anJob, FBtrIntf^.LJobRec^.JobFolio, anEdit);

        FRec.EndDoc := FBtrIntf^.LInv.OurRef;
      Except
        Result := 30005;
      End;
    end;
  end;

  If (Result <> 0) Then
    LastErDesc := Ex_ErrorDescription (602, Result);


end;

function TJobInvoice.Get_jiTransactions(Index: Integer): WideString;
begin
  if (Index > 0) and (Index <= FList.Count) then
    Result := TransOurRef(FList[Index - 1])
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

function TJobInvoice.Get_jiTransactionsI(Index: Integer): ITransaction;
begin
  if (Index > 0) and (Index <= FList.Count) then
    Result := GetTransactionClone(TransOurRef(FList[Index - 1]))
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

function TJobInvoice.Get_jiInvoice: WideString;
begin
  Result := FRec.EndDoc;
end;

function TJobInvoice.Get_jiInvoiceI: ITransaction;
begin
  Result := GetTransactionClone(FRec.EndDoc);
end;

function TJobInvoice.Get_jiTagged(Index: Integer): WordBool;
begin
  if (Index > 0) and (Index <= FList.Count) then
  begin
    Result := TDetails(FList.Objects[Index - 1]).bTagged;
  end
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

procedure TJobInvoice.Set_jiTagged(Index: Integer; Value: WordBool);
begin
  SetActualValue(Index, 1, Value, 0);
end;

function TJobInvoice.Get_jiCharge(Index: Integer): Double;
begin
  if (Index > 0) and (Index <= FList.Count) then
  begin
    Result := TDetails(FList.Objects[Index - 1]).dCharge;
  end
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

function TJobInvoice.Get_jiCost(Index: Integer): Double;
begin
  if (Index > 0) and (Index <= FList.Count) then
  begin
    Result := TDetails(FList.Objects[Index - 1]).dCost;
  end
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

function TJobInvoice.Get_jiQty(Index: Integer): Double;
begin
  if (Index > 0) and (Index <= FList.Count) then
  begin
    Result := TDetails(FList.Objects[Index - 1]).dQty;
  end
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;


procedure TJobInvoice.Set_jiCharge(Index: Integer; Value: Double);
begin
  SetActualValue(Index, 2, False, Value);
end;

procedure TJobInvoice.SetActualValue(Index, WhichVal : Integer;
                                     BoolValue : WordBool;
                                     FloatValue : Double);
//WhichVal = 1 Tagged, 2 Charge
var
  TempInt, Res : integer;
  KeyS, KeyChk : Str255;
  OurRef : string;
  Found : Boolean;
  LNo : Longint;
  RecLocked: Boolean;
begin
  if (Index > 0) and (Index <= FList.Count) then
  begin

    Keys := JActKey(FList[Index - 1]);
    KeyChk := KeyS;
    OurRef := TransOurRef(FList[Index - 1]);
    LNo := TransLineNo(FList[Index - 1]);
    with FBtrIntf^ do
    begin
      Found := False;

      Res := LFind_Rec(B_GetGEq, JDetlF, JDLedgerK, KeyS);

      while (Res = 0) and not Found and (KeyS = KeyChk) do
      begin
        Found := (LJobDetl^.JobActual.LineORef = OurRef) and (LJobDetl^.JobActual.LineNo = LNo);

        if not Found then
          Res := LFind_Rec(B_GetNext, JDetlF, JDLedgerK, KeyS);
      end;

      if Found then
      begin
        LGetMultiRec(B_GetDirect, B_SingLock, KeyS, JDLedgerK, JDetlF, True, RecLocked);
        if RecLocked then
        begin
          Case WhichVal of
            1  : begin
                   LJobDetl^.JobActual.Tagged := WordBoolToBool(BoolValue);
                   TDetails(FList.Objects[Index - 1]).bTagged := BoolValue;
                 end;
            2  : begin
                   LJobDetl^.JobActual.Charge := FloatValue;
                   TDetails(FList.Objects[Index - 1]).dCharge := FloatValue;
                 end;
          end; //Case
          Res := LPut_Rec(JDetlf, JDLedgerK);
        end;
      end
      else
        raise Exception.Create('Unable to find Job Actual record for list member (' + IntToStr(Index) + ')' );

    end;


  end
  else
    raise ERangeError.Create('Invalid list member (' + IntToStr(Index) + ')');
end;

function TJobInvoice.GetTransactionClone(const OurRef : string) : ITransaction;
begin
  Result := TToolkit(FToolkit).TransactionO.GetCloneInterface(OurRef);
end;

function TJobInvoice.Get_jiTransactionCount: Integer;
begin
  Result := FList.Count;
end;

function TJobInvoice.IncludeThisRec : Boolean;
begin
  with FBtrIntf^.LJobDetl^.JobActual do
    Result :=((JAType<=SysAnlsEnd) and (JAType>SysAnlsRev) and (Posted) and (Not Invoiced))
                          and (Not (JDDT In PsopSet+QuotesSet));
end;

procedure TJobInvoice.LoadList;
var
  Res : integer;
  KeyStart, KeyChk : Str255;
  KeyLen : integer;
  i : integer;
  DetObj : TDetails;
begin
  KeyStart:=PartCCKey(JBRCode,JBECode)+FullJobCode(FRec.JobCode)+#1;

  KeyChk := KeyStart;
  KeyLen:=Length(KeyStart);

  with FBtrIntf^, LJobDetl^ do
  begin
    Res := LFind_Rec(B_GetGEq, JDetlf, JDLedgerK, KeyStart);

    while (Res = 0) and CheckKey(KeyStart, KeyChk, KeyLen, False) do
    begin
      if IncludeThisRec then
      begin
        DetObj := TDetails.Create;
        DetObj.bTagged := JobActual.Tagged;
        DetObj.dCharge := JobActual.Charge;
        DetObj.dCost := JobActual.Cost;
        DetObj.dQty := JobActual.Qty;

        FList.AddObject(JobActual.LineORef + '/' + IntToStr(JobActual.LineNo) + ':' + KeyStart, DetObj);
      end;
      Res := LFind_Rec(B_GetNext, JDetlf, JDLedgerK, KeyStart);
    end;
  end;
end;

Procedure TJobInvoice.LGen_InvHed(CCode  :  Str30;
                               RNo    :  LongInt;
                               TDate,
                               DDate  :  Str8;
                               RCr    :  Byte;
                               JCode,
                               ACode,
                               RDoc   :  Str10;
                           Var Ignore :  Boolean;
                               Mode   :  Byte);




  Const
    Fnum     =  InvF;
    Keypath  =  InvOurRefK;




  Var
    KeyC  :  Str255;
    LOk   :  Boolean;


  Begin
    LOk := False;
    With FBtrIntf^ do
    Begin

        Ignore:=BOff;

        If (Mode In [0..3]) then
        Begin
          LOk:=LGetMainRec(CustF,CCode);

          If (Mode=3) then
            RCr:=LCust.Currency;
        end;

        If (Mode<>0) or (LOk) then
        With LInv do
        Begin

          LResetRec(Fnum);

          NomAuto:=BOn;

          TransDate:=TDate; AcPr:=GetLocalPr(0).CPr; AcYr:=GetLocalPr(0).CYr;

          If (Mode<>0) then
            DueDate:=CalcDueDate(TransDate,LCust.PayTerms)
          else
            DueDate:=DDate;

          ILineCount:=1;

          NLineCount:=1;

          RunNo:=RNo;


          If (Mode In [1,3]) then
          Begin
            //PR: 02/03/2015  ABSEXCH-15298 Settlement Discount withdrawn from 01/04/2015
            if TransactionHelper(@LInv).SettlementDiscountSupported then
            begin
              DiscSetl:=Pcnt(LCust.DefSetDisc);
              DiscDays:=LCust.DefSetDDays;
            end
            else
            begin
              DiscSetl:=0.0;
              DiscDays:=0;
            end;
          end;


          {$IFDEF SOP}
            DelTerms:=LCust.SSDDelTerms;
            TransMode:=LCust.SSDModeTr;

          {$ENDIF}



        {$IFDEF MC_On}

          Currency:=RCr;

          CXrate[BOn]:=SyssCurr^.Currencies[Currency].CRates[BOn];

        {$ELSE}

          Currency:=0;

          CXrate:=SyssCurr^.Currencies[Currency].CRates;


        {$ENDIF}


          VATCRate:=SyssCurr^.Currencies[Syss.VATCurr].CRates;

          OrigRates:=SyssCurr^.Currencies[Currency].CRates;

          SetTriRec(Currency,UseORate,CurrTriR);
          SetTriRec(Syss.VATCurr,UseORate,VATTriR);
          SetTriRec(Currency,UseORate,OrigTriR);


          //OpName:=EntryRec^.LogIn;


          Case Mode of
            0..3
               :  Begin

                    CustCode:=LCust.CustCode;

                    CustSupp:=LCust.CustSupp;

                    CtrlNom:=LCust.DefCtrlNom;

                    Case Mode of

                      0  :  If (CustSupp=TradeCode[BOn]) then
                              InvDocHed:=SCR
                            else
                              InvDocHeD:=PCR;

                      1  :  InvDocHed:=SIN;

                      2  :  InvDocHed:=PPI;

                      3  :  Begin
                              InvDocHed:=PJI;
                              RunNo:=JCSelfBillRunNo;

                            end;

                    end; {Case..}


                    YourRef:=RDoc;

                    If (InvDocHed In PSOPSet) then {* Set a separator in ledger *}
                      CustSupp:=Chr(Succ(Ord(CustSupp)));


                    TransNat:=SetTransNat(InvDocHed);

                    TransMode:=1;

                    DJobCode:=JCode;
                    DJobAnal:=ACode;


                  end;


          end; {Case..}

          LSetNextDocNos(LInv,BOn);

        end
        else
        Begin

          Ignore:=BOn;

        end;

    end; {With..}
  end; {Proc..}

function TJobInvoice.Gen_JobInv(Const  Mode,
                                     ICurr,
                                     DetLev  :  Byte;
                              Const  ICCDep  :  CCDepType;
                              Const  IJACode :  Str10;
                              Const  Fnum,
                                     Keypath :  Integer;
                              Var    NeedHed :  Boolean;
                                     GenWIP,
                                     UseOrigCCDep
                                             :  Boolean;
                              Const  KeyChk  :  Str255;
                              Const  TTEnabled
                                             :  Boolean) : SmallInt;

 Const
   Fnum2      =  IdetailF;
   Keypath2   =  IdFolioK;
   Fnum3      =  MiscF;
   Keypath3   =  MIK;

  JobInvType  :  Array[1..2] of String[10] = ('Stage','Final');


 Var
   Ignore,
   NeedL1,
   LOk,
   Locked    :  Boolean;

   JInvTot   :  Array[1..4] of Double;
   JInvCost  :  Array[1..4] of Double;

   JActCharge,
   JActCost  :  Double;

   TmpStat,
   TmpKPath  :  Integer;
   TmpRecAddr:  LongInt;

   GenStr,
   KeyChk2,
   KeyS      :  Str255;

   n         :  Byte;

   NewInv    :  InvRec;

   TmpJDetl  :  JobDetlRec;



 Procedure Prime_LineRec;


 Begin
   With FBtrIntf^,LId do
   Begin
     LResetRec(Fnum2);

     FolioRef:=LInv.FolioNum;

     DocPRef:=LInv.OurRef;

     IdDocHed:=LInv.InvDocHed;

     PDate:=LInv.TransDate;

     CustCode:=LInv.CustCode;

     JobCode:=LInv.DJobCode;
     AnalCode:=LInv.DJobAnal;

     LineNo:=LInv.ILineCount;

     ABSLineNo:=LineNo;

     {$IFDEF STK}

       LineType:=StkLineType[IdDocHed];

     {$ENDIF}

     PriceMulX:=1.0;

     Currency:=LInv.Currency;

     CXRate:=LInv.CXRate;
     CurrTriR:=LInv.CurrTriR;


     If (Not UseOrigCCDep) or (DetLev<>2) then
       CCDep:=ICCDep;


     PYr:=LInv.ACYr;
     PPr:=LInv.AcPr;

     Payment:=DocPayType[IdDocHed];

     If (Syss.AutoClearPay) then
       Reconcile:=ReconC;

   end; {With..}

 end;

 Function Finish_Line  :  Boolean;

 Begin
   With FBtrIntf^ do
   Begin
     LStatus:=LAdd_Rec(Fnum2,KeyPath2);

     //LReport_BError(Fnum2,LStatus);

     Finish_Line:=LStatusOk;

     If (LStatusOk) then
     Begin
       Inc(LInv.ILineCount);

       {* Generate Job Actual Record *}

       If (LId.NetValue<>0) then
         LUpdate_JobAct(LId,LInv);
     end;
   end;

 end;

 Procedure Add_DetLine(Charge,Cost  :  Double);

 Var
   LineDesc  :  Str80;
   LineCCDep :  CCDepType;

 Begin
   FillChar(LineCCDep,Sizeof(LineCCDep), 0);

   With FBtrIntf^,LId do
   Begin
     With LJobDetl^.JobActual do {* Link back to line for description *}
     Begin
       GenStr:=FullRunNoKey(LineFolio,LineNo);

       LStatus:=LFind_Rec(B_GetEq,Fnum2,IdLinkK,GenStr);

       If (LStatusOk) then
       Begin
         LineDesc:=Desc;

         LineCCDep:=LId.CCDep;
       end
       else
         LineDesc:='';

     end;

     Prime_LineRec;

     If (NeedL1) then
     Begin

       Desc:=JobInvType[Mode]+' Invoice for Job: '+JobCode;

       NeedL1:=Not Finish_Line;

       {* Inc line no as line been used twice... *}

       LineNo:=LInv.ILineCount;

       ABSLineNo:=LineNo;

     end;

     Qty:=1;

     QtyMul:=1;

     If (LineDesc<>'') then
       Desc:=LineDesc+'/'+LJobMisc^.JobAnalRec.JAnalName
     else
       Desc:=LJobMisc^.JobAnalRec.JAnalName;

     DocLTLink:=LJobMisc^.JobAnalRec.JLinkLT;

     If (UseOrigCCDep) and (DetLev=2) and (LineCCDep[BOff]<>'') and (LineCCDep[BOn]<>'') then
       CCDep:=LineCCDep
     else
       CCDep:=ICCDep;


     NetValue:=Charge;
     CostPrice:=Cost;

     VATCode:=LCust.VATCode;

     CalcVat(LId,LInv.DiscSetl);

     LGetJobMisc(IJACode,2);

     NomCode:=LJobMisc^.JobAnalRec.WIPNom[BOn];


     If Finish_Line then;

   end;
 end;



 Begin
   Result := 0;

   Blank(JInvTot,Sizeof(JInvTot));

   Blank(JInvCost,Sizeof(JInvCost));

   Ignore:=BOff;

   GenStr:='';
   Locked:=BOff;

   KeyS:=KeyChk;

   TmpKPath:=Keypath;

   JActCharge:=0.0; JActCost:=0.0;

   NeedL1:=BOn;

   With FBtrIntf^ do
   Begin
     KeyChk2:=FullJobCode(FRec.JobCode);

     {* Lock Job Here *}

     LOk:=LGetMultiRec(B_GetEq,B_MultLock,KeyChk2,JobCodeK,JobF,BOn,Locked);


     If (LOk) and (Locked) then
     Begin
       Try

         LGetRecAddr(JobF);


         With LJobRec^ do
         Begin
           LGen_InvHed(LJobRec^.CustCode,
                  0,
                  Today,'',
                  ICurr,
                  JobCode,IJACode,
                  '',
                  Ignore,1);

           NeedHed:=Ignore;

           NewInv:=LInv;

         end;


//         ShowStatus(1,'Generating Invoice for Job : '+LJobRec^.JobCode);


         If (DetLev=1) then {* Clean up temp databse first*}
         Begin
           GenStr:=FullIANKey(LJobRec^.JobCode,'',BOff);

           LDeleteLinks(GenStr,MiscF,Length(GenStr),MIK,BOff);

         end;


         LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);

         While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Ignore) do
         With LJobDetl^.JobActual do
         Begin
                                   {Allow fixe price jobs to tag 0 charge}
           If (Not Invoiced) and ((Charge<>0) or (LJobRec^.ChargeType=2)) then
           Begin

             LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,Keypath,Fnum,BOn,Locked);

             If (LOk) and (Locked) then
             Begin
               LGetRecAddr(Fnum);

               If (Tagged or (Mode=2)) and (Not Ignore) then
               Begin

                 If (LGetJobMisc(AnalCode,2)) then
                 With LJobMisc^.JobAnalRec do
                 Begin

                   If ((JAType >JobXRev) and (JAType<=JobXLab)) and (LJobDetl^.JobActual.JAType<>Pred(SysAnlsSRet)) then
                   Begin
                     {* Preserv Pos *}

                     TmpJDetl:=LJobDetl^;

                     TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOff,BOff);


                     JActCharge:=(Currency_ConvFT(Charge,CurrCharge,ICurr,UseCoDayRate)*DocCnst[JDDT]);
                     JActCost:=(Currency_ConvFT(Round_Up(Qty*Cost,2),ActCurr,ICurr,UseCoDayRate)*DocCnst[JDDT]);

                     Case DetLev of
                       0  :  Begin
                               JInvTot[JAType]:=JInvTot[JAType]+JActCharge;
                               JInvCost[JAType]:=JInvCost[JAType]+JActCost;
                             end;

                       1  :  Begin
                               Update_IAN(LJobRec^.JobCode,AnalCode,JActCharge,JActCost);
                             end;


                       2  :  Begin
                               Add_DetLine(JActCharge,JActCost);

                             end;

                     end; {Case..}

                     TmpStat:=LPresrv_BTPos(Fnum,TmpKPath,LocalF^[Fnum],TmpRecAddr,BOn,BOff);

                     LJobDetl^:=TmpJDetl;

                   end;


                   Invoiced:=BOn;

                   InvRef:=LInv.OurRef;
                 end;

                 Tagged:=BOff;

                 LStatus:=LPut_Rec(Fnum,KeyPath);

                 //LReport_BError(Fnum,LStatus);
                 Result := LStatus;

                 if Result <> 0 then
                   Result := Result + (100 * FNum);

               end;

               LStatus:=LUnLockMLock(Fnum);

             end; {If Locked..}

           end; {If not correct line type }

           If (Not Ignore) then
             LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

         end; {While..}


         If (Not NeedHed) then
         Begin

           Case DetLev of

             0  :  Begin
                     If (LGetJobMisc(IJACode,2)) then
                     Begin
                       For n:=JobXRev to JobXLab do
                       If (JInvTot[n]<>0) or (n=1) then
                       With LId do
                       Begin

                         Prime_LineRec;

                         If (n>JobXRev) then
                         Begin

                           Qty:=1;

                           QtyMul:=1;

                           Desc:=JobXDesc^[n]+' charge.';

                           NetValue:=JInvTot[n];
                           CostPrice:=JInvCost[n];

                           VATCode:=LCust.VATCode;

                           CalcVat(LId,LInv.DiscSetl);

                           NomCode:=LJobMisc^.JobAnalRec.WIPNom[BOn];

                         end
                         else
                         Begin
                           Desc:=JobInvType[Mode]+' Invoice for Job: '+JobCode
                         end;

                         If Finish_Line then;

                       end; {Loop..}
                     end; {If Anal OK..}
                   end; {DetLev 0}


             1  :  Begin
                     KeyChk2:=FullIANKey(LJobRec^.JobCode,'',BOff);
                     KeyS:=KeyChk2;

                     LStatus:=LFind_Rec(B_GetGEq,Fnum3,KeyPath3,KeyS);

                     While (LStatusOk) and (CheckKey(KeyChk2,KeyS,Length(KeyChk2),BOn)) and (Not Ignore) do
                     With LId, LMiscRecs^,CustDiscRec do
                     Begin
                       Prime_LineRec;

                       If (NeedL1) then
                       Begin

                         Desc:=JobInvType[Mode]+' Invoice for Job: '+JobCode;

                         NeedL1:=Not Finish_Line;

                         {* Inc line no as line been used twice... *}

                         LineNo:=LInv.ILineCount;

                         ABSLineNo:=LineNo;

                       end;


                       LGetJobMisc(DCCode,2);

                       Qty:=1;

                       QtyMul:=1;

                       Desc:=LJobMisc^.JobAnalRec.JAnalName;

                       DocLTLink:=LJobMisc^.JobAnalRec.JLinkLT;

                       NetValue:=QSPrice;
                       CostPrice:=QDiscP;

                       VATCode:=LCust.VATCode;

                       CalcVat(LId,LInv.DiscSetl);


                       LGetJobMisc(IJACode,2);


                       NomCode:=LJobMisc^.JobAnalRec.WIPNom[BOn];

                       If Finish_Line then
                       Begin
                         LStatus:=LDelete_Rec(Fnum3,KeyPath3);
                       end;

                       LStatus:=LFind_Rec(B_GetNext,Fnum3,KeyPath3,KeyS);

                     end;
                   end;
           end; {Case..}

           LStore_InvHed(1,-1,TTEnabled);


         end; {If Inv header created ok..}

       Finally
         LStatus:=LUnLockMLock(JobF);


       end; {try..}
     end {If Locked..}
   end; {With..}

 end; {Proc..}

  // HM - Duplicated in X:\entrprse\ole\OLEBtrO.Pas - duplicate changes there
  function TJobInvoice.LUpdate_JobAct(Idr    :  IDetail;
                                    InvR   :  InvRec) : SmallInt;

  Const
    Fnum      =  JDetlF;
    Keypath   =  JDLookK;


  Var
    KeyChk  :  Str255;

    FoundOk,
    NewRec,
    LOk,
    Locked  :  Boolean;

    CostUp,
    TmpQ,
    TmpQM,
    UpLift  :  Double;



    QPrice,
    QDisc   :  Real;

    CHDisc  :  Char;

    StkKeyF,
    TmpKey  :  Str20;

    OldCust :  CustRec;

    OStat   :  Integer;

    {$IFDEF Rp}
      {$IFDEF STK}
        ShareRep    :  ^TStkReport;
      {$ENDIF}
    {$ENDIF}


  Begin
    Result := 0;
    With FBtrIntf^ do
    Begin

      Locked:=BOff;

      OldCust:=LCust;

      QPrice:=0;
      QDisc:=0;
      CHDisc:=#0;

      CostUp:=0.0;

      OStat:=LStatus;
      LOk:=BOff;

      TmpKey:='';

      With IdR do                                      {* JA_X Replace with dedicated job code *}
        KeyChk:=PartCCKey(JBRCode,JBECode)+FullJDLookKey(FolioRef,ABSLineNo);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

      NewRec:=(LStatus=4);

      If (Not EmptyKey(IdR.JobCode,JobKeyLen)) and (InvR.NomAuto) then
      Begin

        If ((LStatusOk) or (NewRec))  then
        Begin


          If (NewRec) then
          With LJobDetl^,JobActual do
          Begin

            LOk:=BOn;
            Locked:=BOn;

            LResetRec(Fnum);

            RecPFix:=JBRCode;

            SubType:=JBECode;

          end
          else
          Begin
            LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);
            LGetRecAddr(Fnum);
          end;

          If (LOk) and (Locked) then
          With LJobDetl^,JobActual do
          Begin


            JobCode:=IdR.JobCode;  {* JA_X Replace with proper job code *}

            ActCurr:=IdR.Currency;
            ActYr:=IdR.PYr;
            ActPr:=IdR.PPr;
            LineFolio:=IdR.FolioRef;
            LineNo:=IdR.ABSLineNo;
            LineORef:=InvR.OurRef;
            StockCode:=IdR.StockCode;
            JDate:=InvR.TransDate;
            OrigNCode:=IdR.NomCode;


            If (IdR.IdDocHed=TSH) then
            Begin
              Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

              Cost:=Round_up(IdR.NetValue,Syss.NoCosDec);

              {TmpQ:=IdR.Qty;
              TmpQM:=IdR.QtyMul;

              IdR.Qty:=1; IdR.QtyMul:=1;


              IdR.Qty:=TmpQ;
              IdR.QtyMul:=TmpQM;}


            end
            else
            Begin

              {$IFDEF SOP}

                Qty:=Round_Up(Qty_OS(IdR),Syss.NoQtyDec);

              {$ELSE}

                Qty:=Round_Up(IdR.Qty,Syss.NoQtyDec);

              {$ENDIF}


              If (IdR.IdDocHed In StkADJSplit) then {* Reverse affect on Job *}
                Qty:=Qty*DocNotCnst;


              With IdR do
              Begin

                TmpQ:=Qty;
                TmpQM:=QtyMul;

                Qty:=1; QtyMul:=1;

                If (IdDocHed<>ADJ) then
                  Cost:=DetLTotalND(Idr,BOn,BOff,BOff,0.0)*LineCnst(Payment)
                else
                  Cost:=CostPrice;

                Qty:=TmpQ;
                QtyMul:=TmpQM;


              end;

            end;


            JDDT:=InvR.InvDocHed;



            ActCCode:=IdR.CustCode;

            UpLift:=0;

            If (JDDT=TSH) then
              EmplCode:=InvR.BatchLink;

            If (AnalCode<>IdR.AnalCode) then {* JA_X Replace with dedicated Analcode *}
            Begin

              AnalCode:=IdR.AnalCode;  {* JA_X Replace with dedicated Analcode *}

              If (LJobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
                LOk:=LGetJobMisc(AnalCode,2)
              else
                LOk:=BOn;

              If (LOk) then
                JAType:=LJobMisc^.JobAnalRec.AnalHed;
            end;




            {$B-}

            If (Not (JDDT In SalesSplit+QuotesSet+PSOPSet)){ and
               (LGet_BudgMUp(JobCode,AnalCode,StockCode,ActCurr,UpLift,CostUp,1))} then {* Recharge set *}

            Begin


            {$B+}

              If (LJobRec^.JobCode<>JobCode) then
                LGetMainRec(JobF,JobCode);

              Case LJobRec^.ChargeType of

                CPChargeType  :  Charge:=Round_Up(Round_Up(Cost+(Cost*Pcnt(UpLift)),2)*Qty,2);

                TMChargeType  :  Begin
                                   If (JDDT=TSH) then
                                     Charge:=Round_up(Round_Up(IdR.CostPrice,Syss.NoNetDec)*Round_Up(Qty,Syss.NoQtyDec),2)


                                   {.$IFNDEF JC}

                                     else
                                     Begin

                                       {$IFDEF STK}

                                         {$IFDEF PF_On}

                                           If (Is_FullStkCode(StockCode)) then
                                           Begin

                                             If (StockCode<>Stock.StockCode) then
                                               LGetMainRec(StockF,StockCode);

                                             If (LJobRec^.CustCode<>Cust.CustCode) then
                                               LGetMainRec(CustF,LJobRec^.CustCode);

                                             FoundOk:=BOn;

                                             {$IFDEF Rp}

                                               New(ShareRep,Create(Self.fMyOwner));

                                               try
                                                 ShareRep^.MTExLocal:=Self.MTExLocal;

                                                 ShareRep^.Calc_StockPrice(LStock,LCust,ActCurr,Calc_IdQty(Qty,Idr.QtyMul,Not LStock.DPackQty),QPrice,QDisc,CHDisc,IdR.MLocStk,FoundOk);
                                               finally

                                                 Dispose(ShareRep,Destroy);

                                               end; {try..}
                                             {$ENDIF}

                                             Charge:=Round_Up(Round_Up(QPrice-Calc_PAmount(QPrice,QDisc,CHDisc),Syss.NoNetDec)*Round_Up(Calc_IdQty(Qty,Idr.QtyMul,Not LStock.DPackQty),Syss.NoQtyDec),2);

                                           end;

                                         {$ENDIF}
                                       {$ENDIF}

                                     end;

                                   {.$ELSE}

                                    ;

                                   {.$ENDIF}
                                 end;

              end; {Case.}


              If (JDDT=TSH) then
                CurrCharge:=IdR.Reconcile
              else
                CurrCharge:=LJobRec^.CurrPrice;


            end;


            If (CostUp=0.0) then {* If budget uplift not set, use analysis records *}
            Begin
              If (LJobMisc^.JobAnalRec.JAnalCode<>IdR.AnalCode) then
                LOk:=LGetJobMisc(AnalCode,2)
              else
                LOk:=BOn;

              If (LOk) then
                CostUp:=LJobMisc^.JobAnalRec.UpliftP;

            end;

            If (CostUp<>0.0) and (Cost<>0.0) then {* Inflate Cost by uplift amount *}
            Begin
              UpliftTotal:=Round_Up(Cost*CostUp,Syss.NoCosDec);

              Cost:=Round_Up(Cost+UpliftTotal,Syss.NoCosDec);

              UpliftGL:=LJobMisc^.JobAnalRec.UpliftGL;
            end;


            LedgerCode:=FullJDLedgerKey(JobCode,Posted,Invoiced,ActCurr,JDate);

            {* Only show these once posted, otherwise drill down shows them all *}

            RunKey:=FullJDRunKey(JobCode,PostedRun,JDate);

            LookKey:=FullJDLookKey(LineFolio,LineNo);

            If (JDDT=TSH) then
              EmplKey:=FullJDEmplKey(JobCode,EmplCode,ReconTS);

            If ((Qty=0) and (IdR.IdDocHed In PSOPSet+QuotesSet)) or
             ((Qty=0) and (Cost=0)) or ((IdR.LineNo=RecieptCode) and (IdR.IdDocHed In PurchSet)) then {* Remove actual record *}
            Begin

              If (Not NewRec) then
                LStatus:=LDelete_Rec(Fnum,Keypath)
              else
                LStatus:=0;

            end
            else
            Begin
              If (NewRec) then
                LStatus:=LAdd_Rec(Fnum,KeyPath)
              else
              Begin
                LStatus:=LPut_Rec(Fnum,KeyPath);

                LStatus:=LUnLockMLock(Fnum);
              end;

            end;

            //LReport_BError(Fnum,LStatus);
            Result := LStatus;

          end; {If Found and Locked}

        end {If Ok, or new}
        else
          //LReport_BError(Fnum,LStatus);
          Result := LStatus;
      end
      else
        If (Not NewRec) then {* It used to have a job code, now been deleted *}
        Begin

          LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyChk,KeyPath,Fnum,BOn,Locked);

          If (LOk) and (Locked) then
            LStatus:=LDelete_Rec(Fnum,Keypath)

        end;


      LStatus:=OStat;

      LCust:=OldCust;
    end; {with..}
  end;

  Function TJobInvoice.LGetJobMisc(ACode  :  Str10;
                                   GMode  :  Byte)  :  Boolean;

  Const
    Fnum     = JMiscF;
    Keypath  = JMK;


  Var
    KeyChk  :  Str255;


  Begin
    KeyChk:=FullJAKey(JARCode,JASubAry[GMode],ACode);

    With FBtrIntf^ do
    Begin
      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyChk);

      Result:=LStatusOk;
    end;

  end;

Function TJobInvoice.FullIANKey(JC,AC    :  Str10;
                     FullKey  :  Boolean)  :  Str255;


Begin
  If (FullKey) then
    Result:=PartCCKey(MatchTCode,MFIFOCode)+FullJDAnalKey(JC,AC)
  else
    Result:=PartCCKey(MatchTCode,MFIFOCode)+FullJobCode(JC);
end;

Procedure TJobInvoice.Update_IAN(JC,AC    :  Str10;
                              Value1,
                              Value2   :  Double);

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;

Var
  FoundRec,
  NewRec   :  Boolean;


Begin
  With FBtrIntf^, LMiscRecs^,CustDiscRec do
  Begin

    FoundRec:=IS_IAN(JC,AC);

    NewRec:=(LStatus=4);

    If (NewRec) then
    Begin
      LResetRec(Fnum);

      RecMFix:=MatchTCode;

      SubType:=MFIFOCode;

      DiscCode:=FullJDAnalKey(JC,AC);

      DCCode:=AC;
    end;

    QSPrice:=QSPrice+Value1;
    QDiscP:=QDiscP+Value2;

    If (NewRec) then
      LStatus:=LAdd_Rec(Fnum,KeyPath)
    else
      If (FoundRec) then
        LStatus:=LPut_Rec(Fnum,KeyPath);

    //LReport_BError(Fnum,LStatus);

  end; {With..}

end; {Proc..}


Function TJobInvoice.IS_IAN(JC,AC  :  Str10) :  Boolean;

Const
  Fnum     =  MiscF;
  Keypath  =  MIK;

Var
  KeyChk,
  KeyS     :  Str255;

  B_Func   :  Integer;

Begin

  With FBtrIntf^ do
  Begin
    KeyChk:=FullIANKey(JC,AC,BOn);
    KeyS:=KeyChk;

    B_Func:=B_GetEq;

    LStatus:=LFind_Rec(B_Func,Fnum,KeyPath,KeyS);

    IS_IAN:=(LStatusOk and CheckKey(KeyChk,KeyS,Length(KeyChk),BOn));
  end;
end;

Procedure TJobInvoice.LStore_InvHed(Mode        :  Byte;
                                 RKeypath    :  Integer;
                           Const TTEnabled   :  Boolean);

Const

  Fnum     =  InvF;

  Keypath  =  InvOurRefK;


Var
  LRunNo,
  RecAddr   :  LongInt;

  OInv      :  InvRec;

  AbortTran : Boolean;
Begin

  AbortTran := False;

  Blank(OInv,Sizeof(OInv));

  LRunNo:=0;

  With FBtrIntf^ do
  Begin
    LCalcInvTotals(LInv,FBtrIntf,BOn,BOn); {* Calculate Invoice Total *}

    If (Mode In [0]) then
    With LInv do
    Begin

      Settled:=BaseTotalOS(LInv);


      {$IFDEF MC_On}

        CurrSettled:=CurrencyOS(LInv,BOn,BOff,BOff);

      {$ELSE}

        CurrSettled:=Settled;

      {$ENDIF}

      If (InvDocHed In DirectSet) then
      Begin

        TotalInvoiced:=InvNetVal;

      end;

    end;

    LRunNo:=LInv.RunNo;

    LInv.RunNo:=0; {Reset run no so allocation gets set}

    Set_DocAlcStat(LInv);

    LInv.RunNo:=LRunNo;

(*    If (VAT_CashAcc(SyssVAT^.VATRates.VATScheme)) and (Mode In [0]) then  {* Cash Accounting set VATdate to Current
                                                                                              With Inv do VATPeriod *}
    With LInv do
    Begin

      VATPostDate:=SyssVAT^.VATRates.CurrPeriod;

      UntilDate:=Today;

    end; *)


    If (RKeypath>=0) then
      LStatus:=LPut_Rec(Fnum,RKeyPath)
    else
    begin
      LStatus:=LAdd_Rec(Fnum,KeyPath);

      //PR: 03/11/2011 v6.9 Add audit note for created invoice.
      if LStatus = 0 then
        AuditNote.AddNote(anTransaction, LInv.FolioNum, anCreate);
    end;

    //LReport_BError(Fnum,LStatus);

    If (Not AbortTran) and (TTEnabled) then
      AbortTran:=(Not LStatusOk);

    If (LStatusOk) and (Not Syss.UpBalOnPost) and (Not AbortTran) then
    With LInv do
      LUpdateBal(LInv,BaseTotalOS(LInv),
                 (ConvCurrICost(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 (ConvCurrINet(LINV,BOff,BOn)*DocCnst[InvDocHed]*DocNotCnst),
                 BOff,2);

  end; {With..}
end; {Proc..}

 Procedure TJobInvoice.Gen_CloseJobNom(Const JCode,
                                          ACode    :  Str10;
                                    Const StageOn,
                                          WIPOnly  :  Boolean;
                                    Const Fnum,
                                          Keypath  :  Integer;
                                    Const TTEnabled:  Boolean);

  Const
   Fnum2      =  IdetailF;
   Keypath2   =  IdLinkK;

   StageTitle :  Array[BOff..BOn] of Str20 = ('','StageInv');



  Var
    KeyI,
    KeyS,
    KeyChk   :  Str255;

    LOk,
    Locked,
    GotHed,
    Abort    :  Boolean;

    RecAddr,
    WOFFNom,
    ULNom,
    WOnNom   :  LongInt;

    ACCDep,
    UCCDep   :  CCDepType;

    LineCost :  Real;

    RevRate  :  CurrTypes;

    CopyJDetl:  JobDetlRec;


  Begin

    With FBtrIntf^ do
    Begin

      Abort:=BOff;
      GotHed:=BOff;

      Locked:=BOff;

      WOFFNom:=0;  WOnNom:=0;  ULNom:=0;

      LineCost:=0;

      If (JCode<>LJobRec^.JobCode) then
        LGetMainRec(JobF,JCode);

      Blank(ACCDep,Sizeof(ACCDep));

      Blank(UCCDep,Sizeof(UCCDep));

      Blank(RevRate,Sizeof(RevRate));



      KeyChk:=PartCCKey(JBRCode,JBECode)+JCode+#1;
      KeyS:=KeyChk;

      LStatus:=LFind_Rec(B_GetGEq,Fnum,KeyPath,KeyS);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not Abort) do
      With LJobDetl^.JobActual do
      Begin

        If (Reverse) and (Not Reversed) and (Posted) and ((Tagged) or (Not StageOn)) then
        Begin

          CopyJDetl:=LJobDetl^;

          If (AnalCode<>LJobMisc^.JobAnalRec.JAnalCode) then
            LOK:=LGetJobMisc(AnalCode,2)
          else
            LOk:=BOn;

          If (LOk) then
          Begin
            If (Not GotHed) then
              Create_NTHed(Abort,GotHed,Trim(JCode)+'. '+StageTitle[StageOn],3,FBtrIntf);


            If (GotHed) then
            Begin

              WOFFNom:=OrigNCode;

              If (WOFFNom=0) then
                WOFFNom:=LJobMisc^.JobAnalRec.WIPNom[BOff];

              WOnNom:=LJobMisc^.JobAnalRec.WIPNom[BOn];

              ULNom:=LJobMisc^.JobAnalRec.UpLiftGL;


              LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPath,Fnum,BOn,Locked);

              If (LOk) and (Locked) then
              Begin
                LGetRecAddr(Fnum);

                Reversed:=BOn;

                If (StageOn) and (WIPOnly) then
                Begin
                  Invoiced:=BOn; Tagged:=BOff;
                end;

                LStatus:=LPut_Rec(Fnum,KeyPath);

                //LReport_BError(Fnum,LStatus);

                LStatus:=LUnLockMLock(Fnum);


                If (LStatusOk) then
                Begin

                  LineCost:=Round_Up((Round_Up(Qty*Cost,2))*DocCnst[JDDT],2);

                  LStatus:=LGetPos(Fnum,RecAddr);

                  {* Link back to line to get CC/Dep *}

                  KeyI:=FullRunNoKey(LineFolio,LineNo);

                  LStatus:=LFind_Rec(B_GetEq,Fnum2,KeyPath2,KeyI);

                  If (LStatusOk) then
                  Begin
                    ACCDep:=LId.CCDep;
                    RevRate:=LId.CXRate;
                  end
                  else
                    RevRate:=SyssCurr^.Currencies[ActCurr].CRates;

                  LAdd_StockValue(LJobMisc^.JobAnalRec.WIPNom[BOn],WOffNom,LineCost,JCode,ACode,'',LineORef,
                            BOff,ActCurr,1,ACCDep,RevRate,Abort);

                  If (CopyJDetl.JobActual.UpliftTotal<>0.0) then {* Also reverse out effect of Uplift *}
                  With CopyJDetl.JobActual do
                  Begin
                    WOFFNom:=UpLiftGL;

                    If (WOFFNom=0) then
                      WOFFNom:=ULNom;

                    With SyssCIS^.CISRates.CISRate[Construct] do
                    Begin
                      UCCDep:=RCCDep;
                    end;

                    If (UCCDep[BOff]='') or (UCCDep[BOn]='') then
                      UCCDep:=ACCDep;

                    LineCost:=Round_Up((Round_Up(Qty*UpliftTotal,2))*DocCnst[JDDT],2);

                    LAdd_StockValue(WOffNom,WOnNom,LineCost,'','','',LineORef,
                          BOff,ActCurr,3,UCCDep,RevRate,Abort);


                  end;


                  LSetDataRecOfs(Fnum,RecAddr);

                  LStatus:=LGetDirect(Fnum,KeyPath,0);
                end;

              end;

            end; {If header generated ok..}

          end; {If analcode found ok..}

        end; {If line not reversable.}

        LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);


      end; {While..}


      If (GotHed) then {* Update nominal line count *}
      Begin

        RecAddr:=LInv.ILineCount;

        LOk:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,InvFolioK,InvF,BOn,Locked);

        If (LOk) and (Locked) then
        With LInv do
        Begin
          LGetRecAddr(InvF);

          ILineCount:=RecAddr;

          LStatus:=LPut_Rec(InvF,InvFolioK);

          //LReport_BError(InvF,LStatus);

          LStatus:=LUnLockMLock(InvF);
        end;

        Reset_NomTxfrLines(LInv,FBtrIntf);

      end; {If header generated ok..}
    end; {With..}

  end; {Proc..}

Procedure TJobInvoice.LAdd_StockValue(BSNCode,
                                   PLNCode:  LongInt;
                                   STKValue
                                          :  Real;
                                   JCode,
                                   ACode,
                                   ECode,
                                   OCode  :  Str10;
                                   AsDIR  :  Boolean;
                                   ACr,
                                   AMode  :  Byte;
                                   ACCDep :  CCDepType;
                                   RevRate:  CurrTypes;
                              Var  Abort  :  Boolean);

Const
  Fnum    =  IDetailF;
  Keypath =  IdRunK;


Var
  FoundOk,
  Done   :  Boolean;

  KeyChk,
  KeyS   :  Str255;

  TNCode :  LongInt;


Begin
  With FBtrIntf^ do
  Begin

    Done:=BOn;

    FoundOk:=BOff;

    TNCode:=BSNCode;

    Repeat
      FoundOk:=BOff;

      KeyChk:=Strip('R',[#0],FullRunNoKey(StkValVRunNo,TNCode));

      KeyS:=FullRunNoKey(StkValVRunNo,TNCode);

      LStatus:=LFind_Rec(B_GetEq,Fnum,KeyPath,KeyS);


      While (LStatusOk) and (CheckKey(KeyChk,KeyS,Length(KeyChk),BOn)) and (Not FoundOk) and (Not Syss.SepRunPost)  do
      With LId do
      Begin
        FoundOk:=((AsDir) or (Currency=ACr));

        If (FoundOk) then
          FoundOk:=CCDepMatch(BOn,ACCDep);

        {$IFDEF MC_On}
          If (UseCoDayRate) and (AMode In [1,3]) and (Not AsDir) and (FoundOk) then {* If Daily rate use original line rate to convert}
            FoundOk:=(CXRate[UseCoDayRate]=RevRate[UseCoDayRate]);

        {$ENDIF}

        If (Not FoundOk) then
          LStatus:=LFind_Rec(B_GetNext,Fnum,KeyPath,KeyS);

      end;


      If (FoundOk) then
      Begin

        LId.NetValue:=LId.NetValue+StkValue;


        LStatus:=LPut_Rec(Fnum,KeyPath);

      end
      else
      Begin

        LCreate_JNomTxfrLines(LId,ACr,(ASDir and Done));

        With LId do
        Begin

          NomCode:=TNCode;

          If (Syss.SepRunPost) then
          Begin
            Case AMode of
              3  :  Desc:=Trim(JCode)+'. Uplift Reversal.';

              else  Desc:=Trim(JCode)+'.'+Copy(OCode+': '+Strip('R',[#32],ECode)+'. '+LInv.TransDesc,1,50);
            end; {Case..}
          end
          else
          Begin
            Case AMode of
              3  :  Desc:=Trim(JCode)+'. Uplift Reversal.';
              else  Desc:=Trim(JCode)+'.'+LInv.TransDesc;
            end; {Case..}
          end;

          {$IFDEF MC_On}

            If (Not AsDir) then {* Show which currency is being reversed out *}
            Begin
              Desc:=PSymb(Currency)+' '+Desc;

              If (UseCoDayRate) and (AMode In [1,3]) then {* If Daily rate use original line rate to convert}
              Begin
                CXRate:=RevRate;

                If (LInv.FolioNum=FolioRef) then
                  CurrTriR:=LInv.CurrTriR;

              end;
            end;

          {$ENDIF}


          Case AMode of
            0  :  PostedRun:=TSTTempRunNo;
            1,3
               :  PostedRun:=CloseJobRunNo;
            else  PostedRun:=StkValVRunNo;
          end; {Case..}

          NetValue:=StkValue;

          If (AMode<>2) and (Not Done) then
          Begin

            JobCode:=JCode;
            AnalCode:=ACode;

          end;

          CCDep:=ACCDep;

          LStatus:=LAdd_Rec(Fnum,KeyPath);

          Inc(LInv.ILineCount);

        end; {With..}

      end; {If Add needed}


      //LReport_BError(Fnum,LStatus);


      Abort:=Not LStatusOk;

      {* Generate a reversing actual to cancel out the value of WIP *}

      If (AMode<>2) and (Not Done) and (Not Abort) then
        LUpdate_JobAct(LId,LInv);

      Done:=Not Done;

      TNCode:=PLNCode;

      If (Not AsDir) then
        StkValue:=StkValue*DocNotCnst;

    Until (Done) or (Abort);
  end; {With..}
end; {Proc..}

 Function TJobInvoice.CCDepMatch(LinkCCDep :  Boolean;
                              RCCDep    :  CCDepType)  :  Boolean;


 Var
   TmpBo   :  Boolean;


 Begin

   TmpBo:=(Not LinkCCDep) or (Not Syss.UseCCDep);

   If (LinkCCDep) and (Syss.UseCCDep) then
   With FBtrIntf^,LId do
     TmpBo:=((CheckKey(RCCDep[BOff],CCDep[BOff],Length(RCCDep[BOff]),BOff))
           and (CheckKey(RCCDep[BOn],CCDep[BOn],Length(RCCDep[BOn]),BOff)));


   CCDepMatch:=TmpBo;

 end; {Func..}

Procedure TJobInvoice.LCreate_JNomTxfrLines(Var   Idr  :  IDetail;
                                         Const LCr  :  Byte;
                                         Const ADIR :  Boolean);



Begin
  With FBtrIntf^ do
  Begin

    LResetRec(IDetailF);

    With Idr do
    Begin

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      If (ADIR) then {* Set first part to normal part *}
      Begin
        LineNo:=LInv.ILineCount;

        Inc(LInv.ILineCount);

        VATCode:=VATZCode;

        Currency:=LInv.Currency;

        CXRate:=LInv.CXRate;
        CurrTriR:=LInv.CurrTriR;

      end
      else
      Begin
        LineNo:=RecieptCode;

        Currency:=LCr;

        CXrate:=SyssCurr^.Currencies[Currency].CRates;
        SetTriRec(Currency,UseORate,CurrTriR);

      end;


      ABSLineNo:=LInv.ILineCount;

      Qty:=1;
      QtyMul:=1;

      PriceMulX:=1.0;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;

      IDDocHed:=LInv.InvDocHed;

      If (LineNo=RecieptCode) then
      Begin
        Payment:=SetRPayment(IdDocHed);

        If (Syss.AutoClearPay) then
          Reconcile:=ReconC;
      end
      else
        Payment:=DocPayType[IdDocHed];



      CustCode:=LInv.CustCode;

      PDate:=LInv.TransDate;
    end; {With..}
  end;{With..}
end; {Proc..}

function TJobInvoice.Get_jiCostCentre: WideString;
begin
  Result := FRec.CCDep[True];
end;

procedure TJobInvoice.Set_jiCostCentre(const Value: WideString);
begin
  FRec.CCDep[True] := Value;
end;

function TJobInvoice.Get_jiDepartment: WideString;
begin
  Result := FRec.CCDep[False]
end;

procedure TJobInvoice.Set_jiDepartment(const Value: WideString);
begin
  FRec.CCDep[False] := Value;
end;

function TJobInvoice.Get_jiUseCCAndDept: WordBool;
begin
  Result := FRec.UseCCAndDep;
end;

procedure TJobInvoice.Set_jiUseCCAndDept(Value: WordBool);
begin
  FRec.UseCCAndDep := Value;
end;

function TJobInvoice.Get_jiTransactionList: IJobInvoiceTransactionList;
begin
  Result := FTransactionListI;
end;

function TJobInvoice.Get_jiWIPTransfer: WideString;
begin
  Result := FRec.EndTransfer;
end;

function TJobInvoice.Get_jiWIPTransferI: ITransaction;
begin
  Result := GetTransactionClone(FRec.EndTransfer);
end;


function TJobInvoice.TransOurRef(const s : string) : string;
begin
  Result := Copy(s, 1, Pos('/', s) - 1);
end;

function TJobInvoice.JActKey(const s : string) : string;
begin
  Result := Copy(s, Pos(':', s) + 1, Length(s));
end;

function TJobInvoice.TransLineNo(const s : string) : longint;
var
  i, j : integer;
begin
  i := Pos('/', s);
  j := Pos(':', s);
  Try
    Result := StrToInt(Copy(s, i + 1, j-i-1));
  Except
    Result := 0;
  End;
end;

function TJobInvoiceTransaction.Get_jiOurRef: WideString;
begin
  Result := FJobInvoice.Get_jiTransactions(FIndex);
end;

function TJobInvoiceTransaction.Get_jiOurRefI: ITransaction;
begin
  Result := FJobInvoice.Get_jiTransactionsI(FIndex);
end;

function TJobInvoiceTransaction.Get_jiTagged: WordBool;
begin
  Result := FJobInvoice.Get_jiTagged(FIndex);
end;

procedure TJobInvoiceTransaction.Set_jiTagged(Value: WordBool);
begin
  FJobInvoice.Set_jiTagged(FIndex, Value);
end;

function TJobInvoiceTransaction.Get_jiCharge : Double;
begin
  Result := FJobInvoice.Get_jiCharge(FIndex);
end;

procedure TJobInvoiceTransaction.Set_jiCharge(Value: Double);
begin
  FJobInvoice.Set_jiCharge(FIndex, Value);
end;

function TJobInvoiceTransaction.Get_jiCost: Double;
begin

end;

function TJobInvoiceTransaction.Get_jiQty: Double;
begin

end;


constructor TJobInvoiceTransaction.Create(JobInv : TJobInvoice; Index : integer);
begin
  inherited Create(ComServer.TypeLib, IJobInvoiceTransaction3); //PR: 21/01/2011 ABSEXCH-10392
  FJobInvoice := JobInv;
  FIndex := Index;
end;

function TJobInvoiceTransactionList.Get_jiTransactionCount: Integer;
begin
  Result := FJobInvoice.Get_jiTransactionCount;
end;

function TJobInvoiceTransactionList.Get_jiTransaction(Index: Integer): IJobInvoiceTransaction;
var
  TmpTrans : TJobInvoiceTransaction;
begin
  TmpTrans := TJobInvoiceTransaction.Create(FJobInvoice, Index);

  Result := TmpTrans;
  FList.Add(Pointer(Result));
end;

constructor TJobInvoiceTransactionList.Create(JobInv : TJobInvoice);
begin
  inherited Create(ComServer.TypeLib, IJobInvoiceTransactionList);
  FJobInvoice := JobInv;
  FList := TList.Create;
end;

destructor TJobInvoiceTransactionList.Destroy;
var
  i : integer;
begin
  for i := 0 to FList.Count - 1 do
    FList[i] := nil;
  FList.Free;
end;





procedure TJobInvoice.SetFileChanged(FileNo, ClientID: Integer);
begin
  if (FileNo in FFilesUsed) and (ClientID <> FBtrIntf^.ExClientID.TaskID) then
  begin
    //DropCache(FileNo, ClientID);  When it's ready
  end;
end;

end.
