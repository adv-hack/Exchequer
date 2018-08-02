unit oViews;

interface
{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF}, GlobVar, VarConst, VarCnst3, oBtrieve, MiscFunc,
     oCust, oAddr, {oLines, oLine,} oNotes, ExBtTH1U, oMatch, ExceptIntf;

type

  //Base class
  TTransactionView = Class(TAutoIntfObjectEx)
  protected
    FTransactionI : ITransaction;
    FTrans        : ^TBatchTHRec;
  public
    constructor Create(const Trans : ITransaction; TransRec : Pointer; const DispIntf : TGUID);
    destructor Destroy; override;
  end;

  //NOM
  TTransactionAsNOM = class(TTransactionView, ITransactionAsNOM, ITransactionAsNOM2)
  protected
    function Get_tnOurRef: WideString; safecall;
    procedure Set_tnOurRef(const Value: WideString); safecall;
    function Get_tnDescription: WideString; safecall;
    procedure Set_tnDescription(const Value: WideString); safecall;
    function Get_tnTransDate: WideString; safecall;
    procedure Set_tnTransDate(const Value: WideString); safecall;
    function Get_tnYear: Smallint; safecall;
    procedure Set_tnYear(Value: Smallint); safecall;
    function Get_tnPeriod: Integer; safecall;
    procedure Set_tnPeriod(Value: Integer); safecall;
    function Get_tnLastEditedBy: WideString; safecall;
    procedure Set_tnLastEditedBy(const Value: WideString); safecall;
    function Get_tnAutoReversing: WordBool; safecall;
    procedure Set_tnAutoReversing(Value: WordBool); safecall;
    function Get_tnYourRef: WideString; safecall;
    procedure Set_tnYourRef(const Value: WideString); safecall;
    function Get_tnUserField1: WideString; safecall;
    procedure Set_tnUserField1(const Value: WideString); safecall;
    function Get_tnUserField2: WideString; safecall;
    procedure Set_tnUserField2(const Value: WideString); safecall;
    function Get_tnUserField3: WideString; safecall;
    procedure Set_tnUserField3(const Value: WideString); safecall;
    function Get_tnUserField4: WideString; safecall;
    procedure Set_tnUserField4(const Value: WideString); safecall;

    //ITransactionAsNOM2
    function Get_tnVatIO: TVatIOType; safecall;
    procedure Set_tnVatIO(Value: TVatIOType); safecall;

  end;

  //TSH
  TTransactionAsTSH = Class(TTransactionView, ITransactionAsTSH)
  protected
    function Get_ttEmployee: WideString; safecall;
    procedure Set_ttEmployee(const Value: WideString); safecall;
    function Get_ttTransDate: WideString; safecall;
    procedure Set_ttTransDate(const Value: WideString); safecall;
    function Get_ttPeriod: Integer; safecall;
    procedure Set_ttPeriod(Value: Integer); safecall;
    function Get_ttYear: Integer; safecall;
    procedure Set_ttYear(Value: Integer); safecall;
    function Get_ttDescription: WideString; safecall;
    procedure Set_ttDescription(const Value: WideString); safecall;
    function Get_ttWeekMonth: Integer; safecall;
    procedure Set_ttWeekMonth(Value: Integer); safecall;
    function Get_ttOurRef: WideString; safecall;
    procedure Set_ttOurRef(const Value: WideString); safecall;
    function Get_ttOperator: WideString; safecall;
    procedure Set_ttOperator(const Value: WideString); safecall;
    function Get_ttUserField1: WideString; safecall;
    procedure Set_ttUserField1(const Value: WideString); safecall;
    function Get_ttUserField2: WideString; safecall;
    procedure Set_ttUserField2(const Value: WideString); safecall;
    function Get_ttUserField3: WideString; safecall;
    procedure Set_ttUserField3(const Value: WideString); safecall;
    function Get_ttUserField4: WideString; safecall;
    procedure Set_ttUserField4(const Value: WideString); safecall;
  end;

  //ADJ
  TTransactionAsADJ = Class(TTransactionView, ITransactionAsADJ)
  protected
    function Get_taOurRef: WideString; safecall;
    procedure Set_taOurRef(const Value: WideString); safecall;
    function Get_taDescription: WideString; safecall;
    procedure Set_taDescription(const Value: WideString); safecall;
    function Get_taDate: WideString; safecall;
    procedure Set_taDate(const Value: WideString); safecall;
    function Get_taYear: Integer; safecall;
    procedure Set_taYear(Value: Integer); safecall;
    function Get_taPeriod: Integer; safecall;
    procedure Set_taPeriod(Value: Integer); safecall;
    function Get_taYourRef: WideString; safecall;
    procedure Set_taYourRef(const Value: WideString); safecall;
    function Get_taLastEditedBy: WideString; safecall;
    procedure Set_taLastEditedBy(const Value: WideString); safecall;
    function Get_taUserField1: WideString; safecall;
    procedure Set_taUserField1(const Value: WideString); safecall;
    function Get_taUserField2: WideString; safecall;
    procedure Set_taUserField2(const Value: WideString); safecall;
    function Get_taUserField3: WideString; safecall;
    procedure Set_taUserField3(const Value: WideString); safecall;
    function Get_taUserField4: WideString; safecall;
    procedure Set_taUserField4(const Value: WideString); safecall;
  end;


  //NOM
  TTransactionAsWOR = class(TTransactionView, ITransactionAsWOR)
  protected
    function Get_twOurRef: WideString; safecall;
    procedure Set_twOurRef(const Value: WideString); safecall;
    function Get_twAcCode: WideString; safecall;
    procedure Set_twAcCode(const Value: WideString); safecall;
    function Get_twStartDate: WideString; safecall;
    procedure Set_twStartDate(const Value: WideString); safecall;
    function Get_twCompleteDate: WideString; safecall;
    procedure Set_twCompleteDate(const Value: WideString); safecall;
    function Get_twYourRef: WideString; safecall;
    procedure Set_twYourRef(const Value: WideString); safecall;
    function Get_twAltRef: WideString; safecall;
    procedure Set_twAltRef(const Value: WideString); safecall;
    function Get_twOperator: WideString; safecall;
    procedure Set_twOperator(const Value: WideString); safecall;
    function Get_twPeriod: Integer; safecall;
    procedure Set_twPeriod(Value: Integer); safecall;
    function Get_twYear: Integer; safecall;
    procedure Set_twYear(Value: Integer); safecall;
    function Get_twLocation: WideString; safecall;
    procedure Set_twLocation(const Value: WideString); safecall;
    function Get_twUserField1: WideString; safecall;
    procedure Set_twUserField1(const Value: WideString); safecall;
    function Get_twUserField2: WideString; safecall;
    procedure Set_twUserField2(const Value: WideString); safecall;
    function Get_twUserField3: WideString; safecall;
    procedure Set_twUserField3(const Value: WideString); safecall;
    function Get_twUserField4: WideString; safecall;
    procedure Set_twUserField4(const Value: WideString); safecall;
  end;

  PBatchMember = ^TBatchMember;
  TBatchMember = Record
    TransI  :  ITransaction;
    TransO  :  TObject;
  end;

  TBatchInfo = Record
    biNetVal     : Double;
    biVat        : Double;
    biTransI     : ITransaction;
    biTransO     : TObject;
    biSaveResult : SmallInt;
  end;

  TBatchCallbackProc = procedure (var BatchInfo : TBatchInfo; BtrMode : SmallInt) of Object;


  TTransactionAsBatch = class(TTransactionView, ITransactionAsBatch)
  private
    FBatchList : TList;
    FTransactionO : TObject;
    FToolkitO : TObject;
    FDocType : DocTypes;
    function TLB2Ent(DT : TDocTypes) : DocTypes;
    procedure UnsetTotal(Index: Integer);
  protected
    function Get_btTotal: Double; safecall;
    function Get_btChequeNoStart: Integer; safecall;
    procedure Set_btChequeNoStart(Value: Integer); safecall;
    function Get_btBankGL: Integer; safecall;
    procedure Set_btBankGL(Value: Integer); safecall;
    function Get_btBatchMembers(Index: Integer): ITransaction; safecall;
    function Get_btBatchCount: Integer; safecall;
    function AddBatchMember(TransactionType: TDocTypes): ITransaction; safecall;
    function UpdateBatchMember(Index : Integer): ITransaction; safecall;
  public
   procedure SetInfo(var BatchInfo : TBatchInfo; BtrMode : SmallInt);
   procedure AddToList(TransO : TObject);
   constructor Create(Trans : TObject; Toolkit : TObject; TransRec : Pointer; const DispIntf : TGUID);
   Destructor Destroy; override;
  end;

  TTransactionAsReturn = class(TTransactionView, ITransactionAsReturn)
  private
    FTransObj : TObject;
  private
    function Get_trPurchaseReturnStatus: TPurchaseReturnStatus; safecall;
    procedure Set_trPurchaseReturnStatus(Value: TPurchaseReturnStatus); safecall;
    function Get_trTotalQtyExpected: Double; safecall;
    function Get_trTotalQtyReturned: Double; safecall;
    function Get_trTotalQtyRepaired: Double; safecall;
    function Get_trTotalQtyWrittenOff: Double; safecall;
    function Get_trTotalAmountRepaired: Double; safecall;
    function Action: IReturnAction; safecall;
    function Get_trAcCode: WideString; safecall;
    procedure Set_trAcCode(const Value: WideString); safecall;
    function Get_trTransDate: WideString; safecall;
    procedure Set_trTransDate(const Value: WideString); safecall;
    function Get_trPeriod: Integer; safecall;
    procedure Set_trPeriod(Value: Integer); safecall;
    function Get_trYear: Integer; safecall;
    procedure Set_trYear(Value: Integer); safecall;
    function Get_trYourRef: WideString; safecall;
    procedure Set_trYourRef(const Value: WideString); safecall;
    function Get_trLongYourRef: WideString; safecall;
    procedure Set_trLongYourRef(const Value: WideString); safecall;
    function Get_trCurrency: Integer; safecall;
    procedure Set_trCurrency(Value: Integer); safecall;
    function Get_trDailyRate: Double; safecall;
    procedure Set_trDailyRate(Value: Double); safecall;
    function Get_trCompanyRate: Double; safecall;
    procedure Set_trCompanyRate(Value: Double); safecall;
    function Get_trUserField1: WideString; safecall;
    procedure Set_trUserField1(const Value: WideString); safecall;
    function Get_trUserField2: WideString; safecall;
    procedure Set_trUserField2(const Value: WideString); safecall;
    function Get_trUserField3: WideString; safecall;
    procedure Set_trUserField3(const Value: WideString); safecall;
    function Get_trUserField4: WideString; safecall;
    procedure Set_trUserField4(const Value: WideString); safecall;
    function Get_trDelAddress: IAddress; safecall;
    function Get_trFixedRate: WordBool; safecall;
    procedure Set_trFixedRate(Value: WordBool); safecall;
    function Get_trSalesReturnStatus: TSalesReturnStatus; safecall;
    procedure Set_trSalesReturnStatus(Value: TSalesReturnStatus); safecall;
  public
    constructor Create(const Trans : ITransaction; TransRec : Pointer; const DispIntf : TGUID;
                       const TransObject : TObject);
    property TransObj : TObject read FTransObj write FTransObj;

  end;


  function IsBatchHeader(const DocType : string) : Boolean;


implementation

uses
  ComServ, oTrans, oToolkit, Btrvu2, oReturns;

const
  BatchMemberSetP = [dtPIN, dtPCR, dtPQU, dtPOR, dtPJI, dtPJC, dtPPI, dtPRF];

  BatchMemberSetS = [dtSIN, dtSCR, dtSQU, dtSOR, dtSJI, dtSJC, dtSRI, dtSRF];

  FullBatchMemberSet = BatchMemberSetP + BatchMemberSetS;

function IsBatchHeader(const DocType : string) : Boolean;
begin
  Result := (DocType = 'PBT') or (DocType = 'SBT')
end;


constructor TTransactionView.Create(const Trans : ITransaction; TransRec : Pointer; const DispIntf : TGUID);
begin
  inherited Create(ComServer.TypeLib, DispIntf);

  FTransactionI := Trans;
  FTrans := TransRec;
end;

{--------------------------Trans as NOM------------------------------}

function TTransactionAsNOM.Get_tnOurRef: WideString;
begin
  Result := FTransactionI.thOurRef;
end;

procedure TTransactionAsNOM.Set_tnOurRef(const Value: WideString);
begin
   FTransactionI.thOurRef := Value;
end;

function TTransactionAsNOM.Get_tnDescription: WideString;
begin
  Result := FTransactionI.thLongYourRef;
end;

procedure TTransactionAsNOM.Set_tnDescription(const Value: WideString);
begin
  FTransactionI.thLongYourRef := Value;
end;

function TTransactionAsNOM.Get_tnTransDate: WideString;
begin
  Result := FTransactionI.thTransDate;
end;

procedure TTransactionAsNOM.Set_tnTransDate(const Value: WideString);
begin
  FTransactionI.thTransDate := Value;
end;

function TTransactionAsNOM.Get_tnYear: Smallint;
begin
  Result := FTransactionI.thYear;
end;

procedure TTransactionAsNOM.Set_tnYear(Value: Smallint);
begin
  FTransactionI.thYear := Value;
end;

function TTransactionAsNOM.Get_tnPeriod: Integer;
begin
  Result := FTransactionI.thPeriod;
end;

procedure TTransactionAsNOM.Set_tnPeriod(Value: Integer);
begin
  FTransactionI.thPeriod := Value;
end;

function TTransactionAsNOM.Get_tnLastEditedBy: WideString;
begin
  Result := FTransactionI.thOperator;
end;

procedure TTransactionAsNOM.Set_tnLastEditedBy(const Value: WideString);
begin
  FTransactionI.thOperator := Value;
end;

function TTransactionAsNOM.Get_tnAutoReversing: WordBool;
begin
  Result := FTrans.NomAutoReverse;
end;

procedure TTransactionAsNOM.Set_tnAutoReversing(Value: WordBool);
begin
  FTrans.NomAutoReverse := Value;
end;

function TTransactionAsNOM.Get_tnYourRef: WideString;
begin
  Result := FTransactionI.thYourRef;
end;

procedure TTransactionAsNOM.Set_tnYourRef(const Value: WideString);
begin
  FTransactionI.thYourRef := Value;
end;

function TTransactionAsNOM.Get_tnUserField1: WideString;
begin
  Result := FTransactionI.thUserField1;
end;

procedure TTransactionAsNOM.Set_tnUserField1(const Value: WideString);
begin
  FTransactionI.thUserField1 := Value;
end;

function TTransactionAsNOM.Get_tnUserField2: WideString;
begin
  Result := FTransactionI.thUserField2;
end;

procedure TTransactionAsNOM.Set_tnUserField2(const Value: WideString);
begin
  FTransactionI.thUserField2 := Value;
end;

function TTransactionAsNOM.Get_tnUserField3: WideString;
begin
  Result := FTransactionI.thUserField3;
end;

procedure TTransactionAsNOM.Set_tnUserField3(const Value: WideString);
begin
  FTransactionI.thUserField3 := Value;
end;

function TTransactionAsNOM.Get_tnUserField4: WideString;
begin
  Result := FTransactionI.thUserField4;
end;

procedure TTransactionAsNOM.Set_tnUserField4(const Value: WideString);
begin
  FTransactionI.thUserField4 := Value;
end;

function TTransactionAsNOM.Get_tnVatIO: TVatIOType;
begin
  Case FTrans.NOMVatIO of
    #0   : Result := vioNA;
    'I'  : Result := vioInput;
    'O'  : Result := vioOutput;
  end;
end;

procedure TTransactionAsNOM.Set_tnVatIO(Value: TVatIOType);
begin
  Case Value of
    vioNA     : FTrans.NOMVatIO := #0;
    vioInput  : FTrans.NOMVatIO := 'I';
    vioOutput : FTrans.NOMVatIO := 'O';
  end;
end;



{----------------------- Transaction as TSH -----------------------------------}

function TTransactionAsTSH.Get_ttEmployee: WideString;
begin
//  Result := FTransactionI.thEmployeeCode;
  Result := FTrans.EmpCode;
end;

procedure TTransactionAsTSH.Set_ttEmployee(const Value: WideString);
begin
//  FTransactionI.thEmployeeCode := Value;
  FTrans.EmpCode := Value;
end;

function TTransactionAsTSH.Get_ttTransDate: WideString;
begin
//  Result := FTransactionI.thTransDate;
  Result := FTrans.TransDate;
end;

procedure TTransactionAsTSH.Set_ttTransDate(const Value: WideString);
begin
//  FTransactionI.thTransDate := Value;
  FTrans.TransDate := Value;
end;

function TTransactionAsTSH.Get_ttPeriod: Integer;
begin
//  Result := FTransactionI.thPeriod;
  Result := FTrans.AcPr;
end;

procedure TTransactionAsTSH.Set_ttPeriod(Value: Integer);
begin
//  FTransactionI.thPeriod := Value;
  FTrans.AcPr := Value;
end;

function TTransactionAsTSH.Get_ttYear: Integer;
begin
//  Result := FTransactionI.thYear;
  Result := FTrans.AcYr;
end;

procedure TTransactionAsTSH.Set_ttYear(Value: Integer);
begin
//  FTransactionI.thYear := Value;
  FTrans.AcYr := Value;
end;

function TTransactionAsTSH.Get_ttDescription: WideString;
begin
//  Result := FTransactionI.thLongYourRef;
  Result := FTrans.LongYrRef;
end;

procedure TTransactionAsTSH.Set_ttDescription(const Value: WideString);
begin
//  FTransactionI.thLongYourRef := Value;
  FTrans.LongYrRef := Value;
end;

function TTransactionAsTSH.Get_ttWeekMonth: Integer;
begin
//  Result := FTransactionI.thSettleDiscDays;
  Result := FTrans.DiscDays;
end;

procedure TTransactionAsTSH.Set_ttWeekMonth(Value: Integer);
begin
//  FTransactionI.thSettleDiscDays := Value;
  FTrans.DiscDays := Value;
end;

function TTransactionAsTSH.Get_ttOurRef: WideString;
begin
//  Result := FTransactionI.thOurRef;
  Result := FTrans.OurRef;
end;

procedure TTransactionAsTSH.Set_ttOurRef(const Value: WideString);
begin
//  FTransactionI.thOurRef := Value;
  FTrans.OurRef := Value;
end;

function TTransactionAsTSH.Get_ttOperator: WideString;
begin
//  Result := FTransactionI.thOperator;
  Result := FTrans.OpName;
end;

procedure TTransactionAsTSH.Set_ttOperator(const Value: WideString);
begin
//  FTransactionI.thOperator := Value;
  FTrans.OpName := Value;
end;

function TTransactionAsTSH.Get_ttUserField1: WideString;
begin
  Result := FTransactionI.thUserField1;
end;

procedure TTransactionAsTSH.Set_ttUserField1(const Value: WideString);
begin
  FTransactionI.thUserField1 := Value;
end;

function TTransactionAsTSH.Get_ttUserField2: WideString;
begin
  Result := FTransactionI.thUserField2;
end;

procedure TTransactionAsTSH.Set_ttUserField2(const Value: WideString);
begin
  FTransactionI.thUserField2 := Value;
end;

function TTransactionAsTSH.Get_ttUserField3: WideString;
begin
  Result := FTransactionI.thUserField3;
end;

procedure TTransactionAsTSH.Set_ttUserField3(const Value: WideString);
begin
  FTransactionI.thUserField3 := Value;
end;

function TTransactionAsTSH.Get_ttUserField4: WideString;
begin
  Result := FTransactionI.thUserField4;
end;

procedure TTransactionAsTSH.Set_ttUserField4(const Value: WideString);
begin
  FTransactionI.thUserField4 := Value;
end;

{--------------------------TransAsADJ---------------------------------------}

function TTransactionAsADJ.Get_taOurRef: WideString;
begin
  Result := FTransactionI.thOurRef;
end;

procedure TTransactionAsADJ.Set_taOurRef(const Value: WideString);
begin
  FTransactionI.thOurRef := Value;
end;

function TTransactionAsADJ.Get_taDescription: WideString;
begin
  Result := FTransactionI.thLongYourRef;
end;

procedure TTransactionAsADJ.Set_taDescription(const Value: WideString);
begin
  FTransactionI.thLongYourRef := Value;
end;

function TTransactionAsADJ.Get_taDate: WideString;
begin
  Result := FTransactionI.thTransDate;
end;

procedure TTransactionAsADJ.Set_taDate(const Value: WideString);
begin
  FTransactionI.thTransDate := Value;
end;

function TTransactionAsADJ.Get_taYear: Integer;
begin
  Result := FTransactionI.thYear;
end;

procedure TTransactionAsADJ.Set_taYear(Value: Integer);
begin
  FTransactionI.thYear := Value;
end;

function TTransactionAsADJ.Get_taPeriod: Integer;
begin
  Result := FTransactionI.thPeriod;
end;

procedure TTransactionAsADJ.Set_taPeriod(Value: Integer);
begin
  FTransactionI.thPeriod := Value;
end;

function TTransactionAsADJ.Get_taYourRef: WideString;
begin
  Result := FTransactionI.thYourRef;
end;

procedure TTransactionAsADJ.Set_taYourRef(const Value: WideString);
begin
  FTransactionI.thYourRef := Value;
end;

function TTransactionAsADJ.Get_taLastEditedBy: WideString;
begin
  Result := FTransactionI.thOperator;
end;

procedure TTransactionAsADJ.Set_taLastEditedBy(const Value: WideString);
begin
  FTransactionI.thOperator := Value;
end;

function TTransactionAsADJ.Get_taUserField1: WideString;
begin
  Result := FTransactionI.thUserField1;
end;

procedure TTransactionAsADJ.Set_taUserField1(const Value: WideString);
begin
  FTransactionI.thUserField1 := Value;
end;

function TTransactionAsADJ.Get_taUserField2: WideString;
begin
  Result := FTransactionI.thUserField2;
end;

procedure TTransactionAsADJ.Set_taUserField2(const Value: WideString);
begin
  FTransactionI.thUserField2 := Value;
end;

function TTransactionAsADJ.Get_taUserField3: WideString;
begin
  Result := FTransactionI.thUserField3;
end;

procedure TTransactionAsADJ.Set_taUserField3(const Value: WideString);
begin
  FTransactionI.thUserField3 := Value;
end;

function TTransactionAsADJ.Get_taUserField4: WideString;
begin
  Result := FTransactionI.thUserField4;
end;

procedure TTransactionAsADJ.Set_taUserField4(const Value: WideString);
begin
  FTransactionI.thUserField4 := Value;
end;

{--------------------------- Trans as WOR-------------------------------------}

function TTransactionAsWOR.Get_twOurRef: WideString;
begin
  Result := FTransactionI.thOurRef;
end;

procedure TTransactionAsWOR.Set_twOurRef(const Value: WideString);
begin
  FTransactionI.thOurRef := Value;
end;

function TTransactionAsWOR.Get_twAcCode: WideString;
begin
  Result := FTransactionI.thAcCode;
end;

procedure TTransactionAsWOR.Set_twAcCode(const Value: WideString);
begin
  FTransactionI.thAcCode := Value;
end;

function TTransactionAsWOR.Get_twStartDate: WideString;
begin
  Result := FTransactionI.thTransDate;
end;

procedure TTransactionAsWOR.Set_twStartDate(const Value: WideString);
begin
  FTransactionI.thTransDate := Value;
end;

function TTransactionAsWOR.Get_twCompleteDate: WideString;
begin
  Result := FTransactionI.thDueDate;
end;

procedure TTransactionAsWOR.Set_twCompleteDate(const Value: WideString);
begin
  FTransactionI.thDueDate := Value;
end;

function TTransactionAsWOR.Get_twYourRef: WideString;
begin
  Result := FTransactionI.thYourRef;
end;

procedure TTransactionAsWOR.Set_twYourRef(const Value: WideString);
begin
  FTransactionI.thYourRef := Value;
end;

function TTransactionAsWOR.Get_twAltRef: WideString;
begin
  REsult := FTransactionI.thLongYourRef;
end;

procedure TTransactionAsWOR.Set_twAltRef(const Value: WideString);
begin
  FTransactionI.thLongYourRef := Value;
end;

function TTransactionAsWOR.Get_twOperator: WideString;
begin
  Result := FTransactionI.thOperator;
end;

procedure TTransactionAsWOR.Set_twOperator(const Value: WideString);
begin
  FTransactionI.thOperator := Value;
end;

function TTransactionAsWOR.Get_twPeriod: Integer;
begin
  Result := FTransactionI.thPeriod;
end;

procedure TTransactionAsWOR.Set_twPeriod(Value: Integer);
begin
  FTransactionI.thPeriod := Value;
end;

function TTransactionAsWOR.Get_twYear: Integer;
begin
  Result := FTransactionI.thYear;
end;

procedure TTransactionAsWOR.Set_twYear(Value: Integer);
begin
  FTransactionI.thYear := Value;
end;

function TTransactionAsWOR.Get_twLocation: WideString;
begin
  Result := FTransactionI.thDeliveryTerms;
end;

procedure TTransactionAsWOR.Set_twLocation(const Value: WideString);
begin
  FTransactionI.thDeliveryTerms := Value;
end;

function TTransactionAsWOR.Get_twUserField1: WideString;
begin
  Result := FTransactionI.thUserField1;
end;

procedure TTransactionAsWOR.Set_twUserField1(const Value: WideString);
begin
  FTransactionI.thUserField1 := Value;
end;

function TTransactionAsWOR.Get_twUserField2: WideString;
begin
  Result := FTransactionI.thUserField2;
end;

procedure TTransactionAsWOR.Set_twUserField2(const Value: WideString);
begin
  FTransactionI.thUserField2 := Value;
end;

function TTransactionAsWOR.Get_twUserField3: WideString;
begin
  Result := FTransactionI.thUserField3;
end;

procedure TTransactionAsWOR.Set_twUserField3(const Value: WideString);
begin
  FTransactionI.thUserField3 := Value;
end;

function TTransactionAsWOR.Get_twUserField4: WideString;
begin
  Result := FTransactionI.thUserField4;
end;

procedure TTransactionAsWOR.Set_twUserField4(const Value: WideString);
begin
  FTransactionI.thUserField4 := Value;
end;

{--------------------------- Trans as Batch -----------------------------------}

constructor TTransactionAsBatch.Create(Trans : TObject; Toolkit : TObject; TransRec : Pointer; const DispIntf : TGUID);
var
  TransI : ITransaction;
begin
  TransI := TTransaction(Trans);
  inherited Create(TransI, TransRec, DispIntf);
  FDocType := TLB2Ent(TransI.thDocType);
  FTransactionO := Trans;
  TransI := nil;
  FBatchList := TList.Create;
  FToolkitO := Toolkit;
end;

Destructor TTransactionAsBatch.Destroy;
var
  i : integer;
begin
{  for i := 0 to FBatchList.count - 1 do
    PBatchMember(FBatchList.Items[i])^.TransI := nil;}
  FBatchList.Free;
end;

function TTransactionAsBatch.Get_btTotal: Double;
begin
  Result := FTrans.TotalInvoiced;
end;

function TTransactionAsBatch.Get_btChequeNoStart: Integer;
begin
  if Trim(FTrans.RemitNo) <> '' then
    Result := StrToInt(FTrans.RemitNo)
  else
    Result := 0;
end;

procedure TTransactionAsBatch.Set_btChequeNoStart(Value: Integer);
begin
  FTrans.RemitNo := IntToStr(Value);
end;

function TTransactionAsBatch.Get_btBankGL: Integer;
begin
  Result := FTrans.BatchNom;
end;

procedure TTransactionAsBatch.Set_btBankGL(Value: Integer);
begin
  if Value >= 0 then
    FTrans.BatchNom := Value;
end;

function TTransactionAsBatch.Get_btBatchMembers(Index: Integer): ITransaction;
begin
  if (Index > 0) and (Index <= FBatchList.Count) then
    Result := PBatchMember(FBatchList.Items[Index - 1])^.TransI.Clone
  else
    raise ERangeError.Create('Invalid list entry (' + IntToStr(Index) + ')');
end;

function TTransactionAsBatch.Get_btBatchCount: Integer;
begin
  Result := FBatchList.Count;
end;

function TTransactionAsBatch.AddBatchMember(TransactionType: TDocTypes): ITransaction;
var
  TransO : TTransaction;

  function TransTypeInMemberSet : Boolean;
  begin
    if FTransactionI.thDocType = dtPBT then
      Result := TransactionType in BatchMemberSetP
    else
      Result := TransactionType in BatchMemberSetS;
  end;

begin
  if TransTypeInMemberSet then
  begin
    if TTransaction(FTransactionO).InUpdateMode then
    begin
      TransO := TTransaction.Create(imAdd, FToolkitO, TTransaction(FTransactionO),
                                   TTransaction(FTransactionO).BtrIntf);

      TransO.InitNewTrans(TransactionType);
      TransO.SetBatchInfo := SetInfo;
      Result := TransO;
    end
    else
      raise Exception.Create('Batch header must be in update mode to add batch members');
  end
  else
  begin
    if not (TransactionType in FullBatchMemberSet) then
      raise Exception.Create('This transaction type cannot be added to a batch')
    else
      raise Exception.Create('This transaction type cannot be added to this type of batch');
  end;
end;

function TTransactionAsBatch.UpdateBatchMember(Index : Integer): ITransaction;
var
  oldIdx : Integer;
begin
  if (Index > 0) and (Index <= FBatchList.Count) then
  begin
    if TTransaction(FTransactionO).InUpdateMode then
    begin
      TTransaction(PBatchMember(FBatchList.Items[Index - 1])^.TransO).BatchIndex := Index - 1;
      Result := PBatchMember(FBatchList.Items[Index - 1])^.TransI.Update;
    end
    else
      raise Exception.Create('Batch header must be in update mode to update batch members');
  end
  else
    raise ERangeError.Create('Invalid list entry (' + IntToStr(Index) + ')');
end;

procedure TTransactionAsBatch.SetInfo(var BatchInfo : TBatchInfo;  BtrMode : SmallInt);
var
  BatchMember : PBatchMember;
  TotSign : integer;
  Index : Integer;
begin
  New(BatchMember);

  //Convert clone transaction to general
  BatchMember.TransO := BatchInfo.biTransO;
  TTransaction(BatchMember.TransO).ConvertToBatchGeneral;
  BatchMember.TransI := TTransaction(BatchMember.TransO);
  Index := TTransaction(BatchMember.TransO).BatchIndex;

  //if updating then remove old values from header totals
  if BtrMode = B_Update then
    UnsetTotal(Index);

  //If purchase batch then values are -ve
  if FDocType = PBT then
    TotSign := - DocCnst[TLB2Ent(BatchMember.TransI.thDocType)]
  else
    TotSign := DocCnst[TLB2Ent(BatchMember.TransI.thDocType)];

  //Set header values
  FTrans.TotalInvoiced := FTrans.TotalInvoiced +
                          ((BatchInfo.biNetVal + BatchInfo.biVat) * TotSign);
  FTrans.InvNetVal := FTrans.InvNetVal + (BatchInfo.biNetVal * TotSign);
  FTrans.InvVat := FTrans.InvVat + (BatchInfo.biVat * TotSign);

  if BtrMode = B_Insert{True} then
    FBatchList.Add(BatchMember)
  else
    FBatchList[Index] := BatchMember;

  //Save header quietly and return result to member transaction
  BatchInfo.biSaveResult := TTransaction(FTransactionO).QuietBatchSave;
end;

function TTransactionAsBatch.TLB2Ent(DT : TDocTypes) : DocTypes;
begin
  Result := TKDocTypeToEntDocType(TLBDocTypeToTKDocType(DT));
end;

procedure TTransactionAsBatch.AddToList(TransO : TObject);
var
  BatchMember : PBatchMember;
begin
  New(BatchMember);
  BatchMember.TransO := TransO;
  TTransaction(BatchMember.TransO).SetBatchInfo := SetInfo;
  BatchMember.TransI := TTransaction(TransO);
  FBatchList.Add(BatchMember);
end;

procedure TTransactionAsBatch.UnsetTotal(Index: Integer);
var
  NVal, Vat : Double;
  TotSign : integer;
  BatchMember : TBatchMember;
begin
  BatchMember := PBatchMember(FBatchList.Items[Index])^;
  if FDocType = PBT then
    TotSign := - DocCnst[TLB2Ent(BatchMember.TransI.thDocType)]
  else
    TotSign := DocCnst[TLB2Ent(BatchMember.TransI.thDocType)];

  NVal := BatchMember.TransI.thTotals[TransTotNetInCcy];
  Vat  := BatchMember.TransI.thTotalVat;

  FTrans.TotalInvoiced := FTrans.TotalInvoiced -
                          ((NVal + Vat) * TotSign);
  FTrans.InvNetVal := FTrans.InvNetVal - (NVal * TotSign);
  FTrans.InvVat := FTrans.InvVat - (Vat * TotSign);
end;

{ TTransactionAsReturn }

function TTransactionAsReturn.Action: IReturnAction;
var
  ReturnAction : TReturnAction;
  ToolkitO : TToolkit;
  ToolkitI : IToolkit;
begin
  ToolkitO := (FTransObj as TTransaction).Toolkit as TToolkit;
  ToolkitI := ToolkitO;
  ReturnAction := TReturnAction.Create(FTransObj as TTransaction, ToolkitO);
  Result := ReturnAction;
end;

constructor TTransactionAsReturn.Create(const Trans: ITransaction;
  TransRec: Pointer; const DispIntf: TGUID; const TransObject: TObject);
begin
  inherited Create(Trans, TransRec, DispIntf);
  FTransObj := TransObject;
end;

function TTransactionAsReturn.Get_trAcCode: WideString;
begin
  Result := FTransactionI.thAcCode;
end;

function TTransactionAsReturn.Get_trCompanyRate: Double;
begin
  Result := FTransactionI.thCompanyRate;
end;

function TTransactionAsReturn.Get_trCurrency: Integer;
begin
  Result := FTransactionI.thCurrency;
end;

function TTransactionAsReturn.Get_trDailyRate: Double;
begin
  Result := FTransactionI.thDailyRate;
end;

function TTransactionAsReturn.Get_trDelAddress: IAddress;
begin
  Result := FTransactionI.thDelAddress;
end;

function TTransactionAsReturn.Get_trFixedRate: WordBool;
begin
  Result := FTransactionI.thFixedRate;
end;

function TTransactionAsReturn.Get_trLongYourRef: WideString;
begin
  Result := FTransactionI.thLongYourRef;
end;

function TTransactionAsReturn.Get_trPeriod: Integer;
begin
  Result := FTransactionI.thPeriod;
end;

function TTransactionAsReturn.Get_trPurchaseReturnStatus: TPurchaseReturnStatus;
begin
  if FTransactionI.thDocType = dtPRN then
    Result := TPurchaseReturnStatus(FTrans.TransMode)
  else
    raise EInvalidMethod.Create('The property ''trPurchaseReturnStatus'' is not available in this object');
end;

function TTransactionAsReturn.Get_trSalesReturnStatus: TSalesReturnStatus;
begin
  if FTransactionI.thDocType = dtSRN then
    Result := TSalesReturnStatus(FTrans.TransMode)
  else
    raise EInvalidMethod.Create('The property ''trSalesReturnStatus'' is not available in this object');
end;

function TTransactionAsReturn.Get_trTotalAmountRepaired: Double;
begin
  Result := FTrans.DocLSplit[6];
end;

function TTransactionAsReturn.Get_trTotalQtyExpected: Double;
begin
  Result := FTrans.DocLSplit[2];
end;

function TTransactionAsReturn.Get_trTotalQtyRepaired: Double;
begin
  Result := FTrans.DocLSplit[3];
end;

function TTransactionAsReturn.Get_trTotalQtyReturned: Double;
begin
  Result := FTrans.DocLSplit[1];
end;

function TTransactionAsReturn.Get_trTotalQtyWrittenOff: Double;
begin
  Result := FTrans.DocLSplit[4];
end;

function TTransactionAsReturn.Get_trTransDate: WideString;
begin
  Result := FTransactionI.thTransDate;
end;

function TTransactionAsReturn.Get_trUserField1: WideString;
begin
  Result := FTransactionI.thUserField1;
end;

function TTransactionAsReturn.Get_trUserField2: WideString;
begin
  Result := FTransactionI.thUserField2;
end;

function TTransactionAsReturn.Get_trUserField3: WideString;
begin
  Result := FTransactionI.thUserField3;
end;

function TTransactionAsReturn.Get_trUserField4: WideString;
begin
  Result := FTransactionI.thUserField4;
end;

function TTransactionAsReturn.Get_trYear: Integer;
begin
  Result := FTransactionI.thYear;
end;

function TTransactionAsReturn.Get_trYourRef: WideString;
begin
  Result := FTransactionI.thYourRef;
end;

procedure TTransactionAsReturn.Set_trAcCode(const Value: WideString);
begin
  FTransactionI.thAcCode := Value;
end;

procedure TTransactionAsReturn.Set_trCompanyRate(Value: Double);
begin
  FTransactionI.thCompanyRate := Value;
end;

procedure TTransactionAsReturn.Set_trCurrency(Value: Integer);
begin
  FTransactionI.thCurrency := Value;
end;

procedure TTransactionAsReturn.Set_trDailyRate(Value: Double);
begin
  FTransactionI.thDailyRate := Value;
end;

procedure TTransactionAsReturn.Set_trFixedRate(Value: WordBool);
begin
  FTransactionI.thFixedRate := Value;
end;

procedure TTransactionAsReturn.Set_trLongYourRef(const Value: WideString);
begin
  FTransactionI.thLongYourRef := Value;
end;

procedure TTransactionAsReturn.Set_trPeriod(Value: Integer);
begin
  FTransactionI.thPeriod := Value;
end;

procedure TTransactionAsReturn.Set_trPurchaseReturnStatus(Value: TPurchaseReturnStatus);
begin
  if FTransactionI.thDocType = dtPRN then
  begin
    if Value in [prsPending..prsComplete] then
      FTrans.TransMode := Ord(Value)
    else
      raise EValidation.Create('Invalid Return Status (' + IntToStr(Value) + ')');
  end
  else
    raise EInvalidMethod.Create('The property ''trPurchaseReturnStatus'' is not available in this object');
end;

procedure TTransactionAsReturn.Set_trSalesReturnStatus(
  Value: TSalesReturnStatus);
begin
  if FTransactionI.thDocType = dtSRN then
  begin
    if Value in [srsPending..srsComplete] then
      FTrans.TransMode := Ord(Value)
    else
      raise EValidation.Create('Invalid Return Status (' + IntToStr(Value) + ')');
  end
  else
    raise EInvalidMethod.Create('The property ''trSalesReturnStatus'' is not available in this object');
end;

procedure TTransactionAsReturn.Set_trTransDate(const Value: WideString);
begin
  FTransactionI.thTransDate := Value;
end;

procedure TTransactionAsReturn.Set_trUserField1(const Value: WideString);
begin
  FTransactionI.thUserField1 := Value;
end;

procedure TTransactionAsReturn.Set_trUserField2(const Value: WideString);
begin
  FTransactionI.thUserField2 := Value;
end;

procedure TTransactionAsReturn.Set_trUserField3(const Value: WideString);
begin
  FTransactionI.thUserField3 := Value;
end;

procedure TTransactionAsReturn.Set_trUserField4(const Value: WideString);
begin
  FTransactionI.thUserField4 := Value;
end;

procedure TTransactionAsReturn.Set_trYear(Value: Integer);
begin
  FTransactionI.thYear := Value;
end;

procedure TTransactionAsReturn.Set_trYourRef(const Value: WideString);
begin
  FTransactionI.thYourRef := Value;
end;

destructor TTransactionView.Destroy;
begin
  FTrans := nil;
  inherited;
end;

end.
